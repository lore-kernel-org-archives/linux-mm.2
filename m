Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFCCF532DE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE0E6B00A0; Tue, 24 Mar 2026 01:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F1D6B00A3; Tue, 24 Mar 2026 01:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4AE6B00A5; Tue, 24 Mar 2026 01:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF6AD6B00A0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:44:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71324CA06F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:44:36 +0000 (UTC)
X-FDA: 84579866952.18.C2297EA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E822160002;
	Tue, 24 Mar 2026 05:44:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RhFkMTZ6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331074; a=rsa-sha256;
	cv=none;
	b=pBKgqmLiunXUQmyNqmJPqkn7+iQdQ1iX1w9m43k28NTduSyHCXrVDuRK/CRl2x04Af37tk
	8klufcUljd5oXGD+aEIPCjUh8ekUrDcZFlpms668XdgZLbgvWrLvziYzWn7PH6/o5jDdgS
	J+3P06bMifQ3IPtFpkz5MvDY0xZAnZc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RhFkMTZ6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=TP9VrPRNxJAjOHVGFBVQ34AHzQGO5HuyfsRX1D1xDvA4CmFdDJhjLmuOXnqYY8yi7ZPvbz
	mXdtKVsa/J2r/D1Qa2XmC3gCcGU25sB0Uu9BjTw3DKR1fQYLVj9eJc2XgeD3mfx0RLzCMM
	Jdl4Bi98N5LvcR2Qb99NNGxB3SJuNOY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RhFkMTZ67F+sUOPh21pTSl/sGN
	vbAOmcVHo3QDjLZMm+8mwGdxGYs65tgfHx+kzkwVz3DQHpRt5zdDazU+dDGR0LZ4c5bUWkvigVG2G
	KfIbGwz4L58S6ivdox/SL+IoOIhOi+yM7Hu2OryhR3ydvdOWSYWQgAUByZZ+eMhP7QmOPzU0aEcT2
	PGidfeDi40O8AbS0yzmHcSmSP7b/K//vTmwxS62JcR/NM6toAW07hp3IqF652oo8qEkI/kTpApJaf
	T+rqOXvjOuLxOWmj78woNA1j81Xfp+SAjYImg+4fndeQSCBeCWQL6YUhQr5WRRdMR3diESbjsuOKU
	NA79Ff6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uZ4-00000000cGy-2feu;
	Tue, 24 Mar 2026 05:44:30 +0000
Date: Mon, 23 Mar 2026 22:44:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 26/41] fs: Drop osync_buffers_list()
Message-ID: <acIkvmMRxM09LEwf@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-67-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-67-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 3E822160002
X-Stat-Signature: qxpg9xs3gnqujsk91nc156t9753e7nqc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774331074-148824
X-HE-Meta: U2FsdGVkX1//jGZrM3TNjF8mJxQRR6EkUYvpolb8M40WQ8ENmI1ajLRpHX8jKsyPDW8z1tDfwHrLNL0L+9ON6mU0Ar4V9OK9LK4OLRkiM55pJoQMClNAYymVbSgOajMEk8Rxt6vth80FeQhnsrHvZ8he9NjAFNio0gC4lcPZM8VPaNhf+YJhRB/kWX6JJKDJh/MpM0cuYyQliSzGB1LUI9/aSV5Dib1sjirouTl3NTc7BCwBCSx9wWY1uwte1KKymLOXViJVxGZNPIi8z9MvoY1piR+yycjGcSQkIcSTefRCJJCeQXAjBWhVcJ0CcO1h6yBIIvlZMXNfPiovpXWkbmE5J527uO+WLTC9afSObcdXihFf2OKXlqHHjw5Nu+eJbjYj8AsOpf1HrHw+qfs6bba1ky+0yy6WuwLOudeZ1kTj238yywzsvJ1zHoYfbDSsicKSbMEDt4rFTelNwM7C1oZRiYvE0vBSed3NwjX5qcyj0xoDNSp/w+xMDMQcyTT6Mnu7ShS7Dqo+ShhM1ZqJ4CBqH7gQsLIpt1ZHjy8Y/0CK2UuhXGJh0PDSfhUu9ECtPwOwN8x1ocEcA/gNrSWj46rtFkBoO+7BLGna4LNx7GmBeiNkR0TMZCqdKZ03MXvCA038ZdysEynB7m9RLezvpQsEsd3VmNsUhLE3ZSzPFp1RWkjMxYg/lNHAgI/ZnOupV8J1pYA7DuBugNsU1n9xvc8JbO+ZSl98kpKwFnVPVgFgPk+qxyN7va2eAC8NATo+93Gdetw6zfl7whVXCEjuGdQI8iWVAgUpFoOP4DSwz+SbJSrCWOcawAPdEeQmHOXRFry/6F6ZzVcLJrJWvjM1ANEbjV87gP4YRA6KduCdSoGZyGseWJoME0EEQ2U1EZunp5Hv4wl/njm6rNMmq+6oONagZL9pU1dprgAcT0vvBXZKi7uK8fo9+UjHU0WrOSid+mGD7l9QNcVjwqwaHAw
 s4wp9IT8
 z6KfTVdnMvgRNVOCz86g8vwmXwFpuaM1kbnBuNZNGcbO9gP/zVcehRU5k8xj/d7qEe8OVdUL9LrB26eaZKx9QtXmCUV+MgQ8VCLZYCDN74YcyufH7QYmI4/Muo4BkgxssBU4cgY67aesXHS6iOqUK9ody7T0lHdlDXjUAfxx3o0l7cdTMuWrUfiFIqrxKswgFuh3jDK03p2wECLQGxwaEMxwu639cmoa2YCFKTDAVDD/zjzAp3aa0JEAA16e+XDANFgT5zlUz34W/yLGYvyC6mZAy4ETZ45mrh2gYWOZFeEJV9IS9uo/YpSyHRkBzj5kzMN34IwNwdVTqjBU7Ds86EdOPE8NR+72H9PrLXdY2ogL+ckKiqjV33YvJ7M6uz6zdc0Egvrdi7Ij2ohC/J9UyqkseRIR3q9GvfK05nn0qJC7LJ466cBohjlg+/DZAFQSTRef6ApWHVn7/Lge8wVsN/6PBHPhr9zIamkW7i/BtildpMuAQ18xULPm3mzHP59F8lmgqKjyWJDBkWcuFqn6tkyKvbCgttQDjwXoCpd7yLuaCPLecpGvcbwjOX6kgPFjvRioaKBjZ9Gb9i7BTIAvXgEghEPh+EAREzK7hkIACUrRxSZDctlB3HZ0RPerkbOozYQqzilWnXX0HpnUQKBOiCv4TUNCEf8Cq6cYbEd7cjZsu2RgYP1vUXzcGwTIdIrUanwMCP2H8rgTmF6uhRHsUl20QB7rSoGYfOYOsnTd9yWmv+m9v0mGmdV8p7MvMJ+RztnaY/FreB6aBj7rNkx2Guuir4+xk9usaJsERP3O6iOScPR+1xGhN994QT4vvI2Bl3S1gDaxbdprqV4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>



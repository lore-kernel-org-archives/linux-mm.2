Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AECCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD996B008C; Wed, 27 May 2026 03:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894C76B0092; Wed, 27 May 2026 03:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2996B0093; Wed, 27 May 2026 03:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACA56B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:33:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2C1314020F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:33:15 +0000 (UTC)
X-FDA: 84812383950.30.5910E97
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C97320007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:33:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U6snnG1n;
	spf=none (imf13.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779867194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaR6k388gQ4mgCsIMny1yKyYgs9PsCBspKn5KTEv2ys=;
	b=3M8Inxk9gPMMMFFh1FEvssKuV/F/lcZloz7JmTCc5lRvbhfcFk0KYk3Do22z0h9kmi9a2U
	uoQUXoxzFUbS2kXGsKGVAJ5f2g+RZhd09r+WUqeTagEMpCGKSt0djX/QXSin7wMUxJjoKG
	ZTyjOonukSLdU4vXHgY2iRQu04b/u0o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=U6snnG1n;
	spf=none (imf13.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779867194; a=rsa-sha256;
	cv=none;
	b=jxOW5di3OQT62FP29dPzPA63HUkojj4Xm8q2ku/uVuIUUZCQczTRmT+ZW0BQJTR0n3Cghx
	pPSnv/cBKwtucbdI2oNdumcParAYCb3l5Dz+d+OiLvtpUFH5mZEWHJsTgUmDwdiLpFlgwm
	h3IbcNjzNaMU3QY2MQnq5G+/eAyDIDI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CaR6k388gQ4mgCsIMny1yKyYgs9PsCBspKn5KTEv2ys=; b=U6snnG1nOqO34XUk5lvYXxxT8Q
	t4Yt5NBhocvasjjbqCxsAWA1lLEnYlxmvJQ+F5kjflsnRvNRbbn77zvy67zivP0DprdLP5b/et29M
	oJH7+KCLcafkpcp9jZRUUcjDcGD4+9O6ivrMhOJ0V6R9/CBl3JZ/RiBSe6blU5CREZbi+LxJeoQkT
	zMCRfsjDd7Dr0UpDg7LyymYigasthG6H//cX4lqKGRBTYLIHJyYR4xRmt0Glut56MJXQuiLusnsVl
	UrJgcGmku2fvUStnI7U8lJkOVxpVgmkPfXHtGn6SadITL6aYXuf0oOvSU/ToQC+SX4pzKKOWtCCuw
	BPIfaRBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8lM-00000003TEw-1GDi;
	Wed, 27 May 2026 07:33:12 +0000
Date: Wed, 27 May 2026 00:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <ahaeOOkuVZmIXFpN@infradead.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: i7b4wn69jmm1sx3s68w3jxdappmh53ay
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C97320007
X-HE-Tag: 1779867194-667375
X-HE-Meta: U2FsdGVkX1/eiBsr1bNwlHcCopLarhmtdHpZOTGyq1HakTXp3LtjoEtZeGc+BnhOBhjFgP8z61H9mOP2UZkSJDe6s40lY00uuJBs0ublIrcLUHHj8HRvLj2pVgLowrE1FOXBuc/hki5VeI/HRE2u37RneIndMzJvhMeYENyD1ExoAjwzQwmCWE0XBDWkC5+KWuktKwWit+uPJLnAygiduJ4F5DCMeI16yj1TQEHiU82sdeKVOtNZtZ0tQ9MTuaBdzUnpaD02EdN0h0wGJIi7XoTazy4F+0ERsFHQ+xSw3VYWm/pOvugz3I8MWQBVvQDHSSM5H6sqxjTUhOIqVEPSUHPprkFZVfo8b05NoWFjQp/kwR9rbzeO9nsGub3Bc2GIKjQsIka04diAdeMGUI7lubYVazY0Vt5FwVHz89jnm1Z2dpGIrVEm2vwHpcX/1sbMvxBmwIn6VgFVFjPU/cZ+5nDZMwZOA0gL4tbW3d1Ynqg1hEGH3pxr/j9VKX+fgs8a1OWG1oSiRnqRWpcVW1OzAovaA57ybgjVFZqXOGjQ9gQPzfXssgQb5cJdgBOdooNpck3mOWj2T0Jqehpe2QgXCDCNcFRhiBzm9WEK1nfaCnVIlW8bZMPn+VnXLo3YQXgTt850h6N31mK8YxLidp6bwhAFjaxJLztFutSO/YKFXKpudamBBCbzr+iGk3WaO5/QfooR9O0R95yVVDpQFNuWqTAYJfhbxyI8mSbtNWUcgBliiretaaeV/AINBlhda5GWBfI2l6QmulAndtCMf3Bh5j5HdOFgQefaT07Ayy50ivUGetItcqshb8E8LCn8vPVuvpjgYc6NuItE6ykFfUbqLJSms7IguDxv98cGiURLuREiMDXXFBU/o45LLn5wPx+pzTQdRkMDTcsjPnZHl4bEW3ruvHqo2hv9VomSqlmpH4pwe6Xgj8DOdUPPnK2WUw4tekV9ywe1g1XN6sELRgO
 sae9JCj+
 yrsQzpQ/V8bjq1hODbE7yjwkZtbj2wjINAc39Lpu6oH4rdBXbfgCWUCc59jrnAd21m29JTVFHV8BT6YbuQvBhpAa2+/0SaU7I0pn5rWPQLF4P01/bBvVYLRjnEt8/cve1u0iywgiXZ79JgbungZDAmvcHXZ+GRh3d7MbEDcO18E9IsbsVaLGtkNSYjiyEpQ+eUNRP8IiNNVNQmTYEhGMTR7be6WF7VKGiBSEhrmPd0SeS01tH37OmTCh5ZC8oYK+9BFi5+9Vu6bIYSL/D1aA0pzVTAGB7gc/KoZq/i2sDJVpUR5tEhDwwcVzPJjCyJ10LJDehPVCYErkIrREJ6PELOyvMsAL89n/GQstupk6nZ6kSr9XUY+90cnPnPO9EA28oazWphWrttFV0S1tB6P4rbGhYBA7mDISvzFZJw/sfAFzflzkSzjspRLvFMbd19HuicULrA5R3qTT4UX1qCZqjDx6YoOInPAVThydXcOHm9Hiv7MUFsivDmUZHvg4KPBRdy9p5hl9B+GHvbMT+FQS8SDhgiPODAc4J+CPPsN8aFaMLRMoHb9eEKptnRaxlkgbvNYod2QEt9WZ92xRzbQ7xQrQpihHMYo1y0BpSwdaJ/2folI6CWpDRK35Vsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please stick to the raid6: prefix used for all commits since the move
and most before that.



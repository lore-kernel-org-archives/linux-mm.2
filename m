Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DF7CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 23:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F15A8E0006; Mon, 17 Nov 2025 18:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1AD8E0002; Mon, 17 Nov 2025 18:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DED48E0006; Mon, 17 Nov 2025 18:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7FE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:22:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B882B1A02C4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:22:50 +0000 (UTC)
X-FDA: 84121676100.16.A8478A5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 44EA31C0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:22:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="pR+/MY0Q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763421769; a=rsa-sha256;
	cv=none;
	b=wTcSPL8y2WZd1LfEvVsSxET/xSvtyWGjF6SOFuyUE7y5DZ9Ajs+whNlcW8x7f9guBfxgMy
	3eR75wRFuX2Cn1wGqVG+0YGhFogYIuDdcXu5XMNeZPV0K8jDry2mr9nN7bEWpWdGiSAgdF
	ca76t6hmN1eTHGoQnktljDzYHbUnUmI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="pR+/MY0Q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763421769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tW51k/48tIPIeu/OA5C8tFspHqOenqhYuYE1vLb6mk=;
	b=CyiYPRvlf6nY7kH2iB/2zQ3ZbhLrWweUkMZ5gRPQnVuYh8stmP9Nsr2AmlvIClbqp0ju7A
	IkgFtBSABAS5IuYetgDaAIGI87YMZox7RSLHV7D+ljq/o/G+H9jgHQZmS1jf7zO8bYQvUM
	mxhkEepYGX4ApPxUEacDh2MGUGSvzlI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2tW51k/48tIPIeu/OA5C8tFspHqOenqhYuYE1vLb6mk=; b=pR+/MY0Qaw1o61uWOSxUf1fOTO
	rVCl2RdEbFl5fqSjcqYn0uYhBgBMMOQrSZdd1WEcikQcpc4m21mUTaoEXhTrHGm+mSSLaPWip44dt
	FzDoES5HUEHizaSBHcqZBXN/ghiiH+YPnRgmm41Xvx/srSa1r+od8ux1+ku/DeboOgbkBX0fk2877
	wAZuPLFEBq2RQpIDBBexqUh8x0hSU2iyL3jqt4Gyfg7VGrWlAncEw98XGrw94y0sXrOFvM+tvBFQH
	qbE71HhdMq4bJc9YSbEpoCbpKb+MvPQ5UvfP3TeHxBfy09zEoaKS80ozzt0TZ2vUCn5bQQwxpxm86
	kGRhyNTg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL8YW-0000000EZso-3OIP;
	Mon, 17 Nov 2025 23:22:44 +0000
Date: Mon, 17 Nov 2025 23:22:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@redhat.com,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
Message-ID: <aRuuRGxw2vuXcVv6@casper.infradead.org>
References: <20251117224701.1279139-1-ackerleytng@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
X-Rspamd-Queue-Id: 44EA31C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: huk51iddiquc7x77d6te5q6p13ffkuob
X-Rspam-User: 
X-HE-Tag: 1763421768-211051
X-HE-Meta: U2FsdGVkX18EAL2IAdS6FTzlHwCSitaSVF/XrHQbxb8UURGRYP5ILCY3bJgKKmuw9cImEkid2WP/ESQk5kuLcTudBe2vy5dCJJQFdv+IX9Ku2Rxp/N7v5MwLLWM1bXbIpkxanQGHEJW7DICa7co51rGkae6NwDOcBpi9WZ2L92IyHCWBAoCwidEDVnQTREAr+jhMZsuxjO81L4e6O+zQOPxnfR4jWXnC4xTnczE4k0jNpiAUHG3XSKiXAl1mZj/1trSYKuGWUiu9lSmXZuhJvwec5YoydLzCIiUitukfsKNksK5h31xbNrzktsWqgqMgU4AyU9QMZjUFBNlHQl2PFuC8/oI0dMMQi1Yz20op1YX+EkP/3o8Pxo/v0A/8w2LsOvohslbS35wt+4mR/YCoSiP04ekifqFmqbiSn8dQymShQIxtXKvL3cYLzC0GHCmJw8FS7DAABU4aLGnHxCX+HeDBTd+1+559nwf34QykKksjCpEFBFwdiTsgkdPagB6luh5SPIDj5WUHSIlQjpy0Fe/D5Wufkaul36wtRqpnx8VnJ7ieIhoMLutiWI1L4llxINx4RAoYbjpi8p/fHP0IkD10GXxBvTqHgSKZ0jq6EjOiceVzi6cnQdvHYBAIVE5fCeBb4qP0qdhSIRIHGsfz8y/l4g7WrnVbzE6vdr7bnqiyPtEI5TuVqBoe3zOr9yjnerIi14yyWuzQcXH6ikEwqRyzMVSGkHXB5ZZzt1+wtDDfu8OUUQptx1LIwW6tLC/pBp6pqyRufGPZ9wDs8NzcguEoC/ZAmG8Uh3esoCZWoxAegkNQXxPmwWMIbPq6T9/HBw0tIgVBA6TeL56dYbIFSRrKKYyoYFz6epSGSEVJRG21x3OoMtlR6YoZ+GnRBTaTbdHBVH93hrtBvQ+v2Tx5TN1AjuBAcopuj5d/6tVXOxcC94jF9vSh8xAda1ItvE0ZwdWhmb0RhtQfKHS4Ylx
 c7ByJQgY
 PicUUOF/tRZRENkC6c8g8YIE/uold7DuldRXpRkzUsyyvdGYUFGpc2v//yF/Ni0zkZHqpcYQn1bzNZYdxnBl61h6pHOFpK31sGj+UZ9mdr38F4a8Y7Hnva1kLx7g+bSb4fiWcFhOV6if5gSLzhVKzmNKzEdLHxwjSxdixzi2x8Gb3A7Arseh8mBTG6bMFKeugaGZkHmkpFWWC8czcZAueWBtHcMVjU4ED69mMV/IYrfpnqmMxTR/nVMkiDgy5/cN6Dy2o+HQ6n+wD8HC4iAAoI/TzWNzm++W9ePEq5dBCRIhsglc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 02:46:57PM -0800, Ackerley Tng wrote:
> guest_memfd is planning to store huge pages in the filemap, and
> guest_memfd's use of huge pages involves splitting of huge pages into
> individual pages. Splitting of huge pages also involves splitting of
> the filemap entries for the pages being split.

Hm, I'm not most concerned about the number of nodes you're allocating.
I'm most concerned that, once we have memdescs, splitting a 1GB page
into 512 * 512 4kB pages is going to involve allocating about 20MB
of memory (80 bytes * 512 * 512).  Is this necessary to do all at once?


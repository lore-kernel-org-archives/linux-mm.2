Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C269D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8556B0006; Mon, 15 Dec 2025 09:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BFB36B000A; Mon, 15 Dec 2025 09:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD546B000C; Mon, 15 Dec 2025 09:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 608A56B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:00:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE50FB7497
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:00:52 +0000 (UTC)
X-FDA: 84221866344.21.C9D02C4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 179C7A001B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:00:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=le4XRb1X;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765807251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkCYGiCYJi+miO4Sgpe6xzcq/dDOhFl6pIaaLHV9nqM=;
	b=B4q1cp+H+l6f+xUL9PwNd1mgoSR0FvIfMXCJB/pBWwrbZ0DvUgsPnroodkBervPDjqiWIi
	LH1RK+JoM1HRk62TcgpiYdvZ+g8njGs+zNHaVrzSV7qZqECeQaECku6xEspF5nBrTKJYDH
	zptuhKT/dgdsjog2av0lON4Yvlyh+Fg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=le4XRb1X;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765807251; a=rsa-sha256;
	cv=none;
	b=F7NlA6HYLERs+6hmAKgz8c1Tz2M5RmvBCHx/n5Oyzh1NjBg3GEMgl7UzlvcWWbTOU3NMYT
	bJSZtnauQPFrs+OY/KlK37kcLHcV13U88efXoa9OJDlFeCIe2s2tkywB2v/P2wbyiRB4Xa
	kmWbpNa0SClx+0zoe3rQZQCze2vmZV4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rkCYGiCYJi+miO4Sgpe6xzcq/dDOhFl6pIaaLHV9nqM=; b=le4XRb1X/irlAOoRpHp/4YebJK
	rDsR2KgG+emZE+CZTmEosUoyRJ8H/f6ngj/KdzlvvIq8eU00Rb8vD4ygnKsyBNCUMLfLodZCNORZX
	Fg5iafDkoVb5F1LIitOytK6BCojhwCPKGualr1r/Vyoqqr216nhpi8D7lKEvenSGCg1Irvb6y/lAI
	6mhXS2lgZ4/XpVgKuONdgPli87rt2Ilw2VOpEwlQfbY89E3ReoqkznnEGxLbs+CI8PhoQKRmkCNVL
	sG+dusE2nYM0rQJhm1RYxJWYCFKKlv+r+lOonynJRewO3VSUT1ChIQhsD08UMbEF0xzia4ybuec0E
	NxxLj5Cg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV97f-00000001zD9-3tD3;
	Mon, 15 Dec 2025 14:00:24 +0000
Date: Mon, 15 Dec 2025 14:00:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	corbet@lwn.net, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
Message-ID: <aUAUd_XJPVsl_CZL@casper.infradead.org>
References: <20251215123407.380813-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215123407.380813-1-zhangqilong3@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 179C7A001B
X-Stat-Signature: r7rj8oq5pc7ypufn7mpoeax48gon5bp8
X-Rspam-User: 
X-HE-Tag: 1765807249-203070
X-HE-Meta: U2FsdGVkX1+BF2i66bUQonfLg4Qm54ZvJbAFg+1VYIK8A2VRqaypupiafQvjoI1+sF07vkr60sH2oZt8ACAzdwTWFJ2Fmn+vIp0WsA3mg54oya+bGZH9PF1rANvPP0k3nVCcWNDcDoLEs0b0O8ABxL0E0Xli0uWDmy07W4dOCdN7ZRfqgV4W6/vGbS4qRDcUlZplZh000OS1Fa89CKWpM69WJ7ajYTwDhjm1GbJYz+zpC3Bi9uwm/BO9yDoKHa17n2TTdYGlyh5wzwODa+rsdBx/Q6qPH2C0F7hRq/SGN4uHqueKdVuCoYKeWDaKll8xDcss4TzxHdYgUG01c1gg9fKqKbQzXta79idPIimXuy4MHK0pEmTIlW5L/545vyd4qg2FupW8gh81qL8Xto6FfJFTV8lCYHdGWCQsWl5gFPfLuJXZHlOuLWzq0/DyM3YrDGlk6ZXS8vTnlpCzF35eBbHQauYcawis+3xID0vl3Vq98iBkVEfu3zer5U20fhMDA4Id1vM4TbCWgNBN3k3gMGWjkdLpJARmv+jl8wFHZlPTvMO1EESDfV5QJDKmA9NuuOZ1qJjFvQ/TwvD14lGRz93R1gvZRBBOF51y06hDRiJ5oKDE1ifTy7y8/iD5QmPk++Fa/MEPDY9RCPtlXtDMRcgoqfMv1wDohM7nUIn6BNybsoTC4hGG+KixiI2FFlGbVJM46r8UmMPDSnbSARe38ezfUv9PdOYsa1vqylY+/1rglmlm33UL/zdRGQMX7Ak9W66EKfIoSKwzyfdZqpQ1b1xDtuGtGktsp56hwFqUVcIFesD4m4jy+V08Ie/6+hA9MhM5uoDlcXgPeGXxuZtc4YQBpdoj9wpyCxYgbNrRdJEZ+eubsXK36uPmPlIk65PbDZc5Gcj5msIIIz3MX8DcW6XHikhMBc5TX3XibgKAn/yofbtCpz3UxoS31yRcHMTX7pmXPWDaPrWMluUU6Xl
 j031h3g7
 RPf0goXlpJqqyanIYJAQ37+r4hDdTRIQ6xUMPFx4Hsgzlo2romFcgSIATakmgM2SQLIduNluOhqvxV0781AT70VuJyzSLoO0gtDIGkYeV1eaISXlfSYLAo7S2F+rssExEWx1hrV/TzZudCWxbwdStIKsbq3sww7Ukdg4vH+89MDry3iqZJ8oVkhZoPYtSncAVVcFIx8wzwmjOIF45RDoV88CLcN17x5R/dZd6UKykJ7ngnsabZ8pmaC0ShslsrXb+uqym
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 08:34:05PM +0800, Zhang Qilong wrote:
> This patch series implementate THP COW for private executable file
> mmap. It's major designed to increase the iTLB cache hit rate for
> hot patching application, and we add a new sysfs knob to disable or
> enable it.

You're going to have to provide data to get this patch in.  We've
deliberately not done this in the past due to memory consumption overhead.
So you need to prove that's now the wrong decision to make.

Microbenchmarks would be a bare minimum, but what are really needed are
numbers from actual workloads.


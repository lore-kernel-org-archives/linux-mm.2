Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F42CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 02:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F335F6B00E5; Mon, 18 Aug 2025 22:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AF16B00E7; Mon, 18 Aug 2025 22:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47936B00E9; Mon, 18 Aug 2025 22:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D23636B00E5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 22:46:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 776F0C0224
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:46:47 +0000 (UTC)
X-FDA: 83791969254.09.D38B6DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id D98DB40008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:46:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="wEqEC/Ki"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755571606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRcfDxQN0Y07fq+oKJMThMYIDH4cn5ueNFH/T0aHZsU=;
	b=vqR2XtJlMqlsx7Qp6Uou3hkhBRc9y3rroHpR/eFMeuj3hjfQzUvoNvrDQX7erMzgGBuid9
	XuEtnT7L/wxq/Qhi+Pf+Lbat+gcnXrWvw9K3YSRzHeTsM3Lu4kXTg3ngPUTHgGpvjtf7rK
	SSAssg/EWtTqBNKQK9cIGEyeqV7Q9Gc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="wEqEC/Ki";
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755571606; a=rsa-sha256;
	cv=none;
	b=gHWHOxuI26gMej0fYKeWiQ0a1sf3bNKnbySVQaoBwCpftOMUlzqqXyPSLf1PhZ/9CpkLyc
	V9vcDnv0jdrfUPRuux42ZNX5FUmMl9lv0T8pa3orcrckm+8R4sBMxtC4ZefYWSnVtR1rYJ
	Xq4/VT/ubkDEMp58iVL9OItUScUqADM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bRcfDxQN0Y07fq+oKJMThMYIDH4cn5ueNFH/T0aHZsU=; b=wEqEC/KiXklf7eS2WgGEIgkIYR
	iZZbLkZJsJ6RbCIrjJhSKwyqix5agvMYN81rEa6KzpC6MKKmqt9fgxVx5Ie6dRtaFt+rk7rUnIL02
	dXKTthU7DqTnf9+W+v48hPboU7vjjfL02caVhyAH5/LQBpXjta5TJzZKfeE6SRgeubbqHnMgMtGfV
	ylLkPlHSB0DV4FJpfmxw2d9rXDdUmGsPy3ZG0vOdfBWvyFQm0jiLpvlcZ+99B40/zUaFM8bhGMjQr
	r3sIm24nHwWQmbBW9KhByQhoLc1NyKKXMTk0rPYbsLqkD950r+d+301vQTqWLUZiwEv0oAr2ZPt+I
	Igr4Kyww==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoCN1-0000000F0kr-0WSI;
	Tue, 19 Aug 2025 02:46:43 +0000
Date: Tue, 19 Aug 2025 03:46:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <aKPlkhXY9CON4x9v@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
X-Stat-Signature: q4nse4otfaai5wea7ysamtnddz8cgxoe
X-Rspam-User: 
X-Rspamd-Queue-Id: D98DB40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755571605-753306
X-HE-Meta: U2FsdGVkX185VNetdAptg5sa0C++s+osZz23oMZK/J0NuzYQiF6mJbY0YtYHU7EhLgXPigBLeLe5W9P5gz3XsU+gDxXwLAjYems2/ClJOGhSE3YECJv2t+hfr+EfGs5Lt8trGOGoflClM0Ke2K/HooUDscchrCcjE7HQy4DMK7LG7GC393mxbxklaQHoH/srkNmvYH4QPMklAPQqJbyS+yj8F/8zuwdHj8dgamDUSx4Sn3skjWEhKrrlqxXFiShTfPMQ82BYI7oeMLqFLfu22YzEGNPRodcWzyruldYxQec3QoA3rgu5OEq1jVhbczuooU1IO5Ka/SxANZ0QSMSMJio9inabETEu1mjBtGSQy1y3PU74kdTM51yBPw4QmBfgQ6O2NM0y6Zd2R2IWjqJzL5Gjv36Y2KaY3Wfxe7Cuh144kn3bwdRglEdNKUPf/yhlK8jxD52k9gsqgI9fXAOZoPmccE0D2ETIK6trOIdNSjOAhRfNJt+jjWboYLFp5c7VrsnLMOmUg8Aizv0SyVcn7qJYyq9TvtYrgf4lTTzeGNjWKWNTutVMJyEM1PGZf4gs7/gKhRuOIt50kZaeidJycvp78hJJ7zEdKwNHdN/depzuxFiYFvni5B8A35UF0pCXgy9LKig9sSDXQrE7EDkQWmkTfi5VUZZEtzvXwVMv/UmQokNcQ4vqvD0eBmzjbyBCwbLTslQiYMBMFbfmAnRdj//1DRSJyLRk6ChzTyt2ZDAkkvd2BRzGC6ARDibXlMitvFaypXQ6GC0Gc4Cc4U3b5ksxHU+pFdlnqJH7WR+HvfBGnwRVGn1pcNhrYITaLzNfNnSVMTj9zeyNac63hVLmR2jR+sZI8jTTnTn3scK5bvCB/P3J/ivyl7ICSvhDF0cJfiqR3u+HouvCrMICGOb/Z2EDVsz/6q/yqbyIILUrFf1XuWEs2A2p1FGUBSAu0x5A4wOZfQFecjZYEdiOSkX
 B8qnowk8
 bCbdh6CA7kwd37ux99W9Mzhz73jzp3aBL02Vsj6oH/bWxxrFrdxty7IpuOs7HwIDR+WtHJGp73Fh9Fh7FgXcxKZVqHvczV4xb31tuhuKq8u4+NM3hHuLvJR2ja5Jq38fnnE2F7SQvqRaZSuaXPhyeB2+/A6jnaSgJc2qGt+Z7AuDCzeDbuqvZ8X85GPl9F3QyWVcHj85RB1kqcdOYczXzcJUJ0GRbxTXZslV0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 05:36:53PM -0700, Boris Burkov wrote:
> +++ b/mm/filemap.c
> @@ -960,15 +960,19 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
>  {
>  	void *shadow = NULL;
>  	int ret;
> +	bool charge_mem_cgroup = !test_bit(AS_UNCHARGED, &mapping->flags);
>  
> -	ret = mem_cgroup_charge(folio, NULL, gfp);
> -	if (ret)
> -		return ret;
> +	if (charge_mem_cgroup) {
> +		ret = mem_cgroup_charge(folio, NULL, gfp);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	__folio_set_locked(folio);
>  	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
>  	if (unlikely(ret)) {
> -		mem_cgroup_uncharge(folio);
> +		if (charge_mem_cgroup)
> +			mem_cgroup_uncharge(folio);
>  		__folio_clear_locked(folio);

This is unnecessarily complex; mem_cgroup_uncharge() is a no-op if
the folio is not charged.  Sure, it's a wasted function call, but
this is a rare error path, so minimising size is more important than
minimising time.

So you can drop the 'bool' as well:

+	if (!test_bit(AS_UNCHARGED, &mapping->flags)) {


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AD0CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004DC6B00E3; Wed, 13 May 2026 10:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7F36B00E5; Wed, 13 May 2026 10:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7F56B00E7; Wed, 13 May 2026 10:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CAE636B00E3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:29:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 659E985962
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:29:16 +0000 (UTC)
X-FDA: 84762629112.19.50AD4A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C96E640008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:29:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZMLtdyM;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778682554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80kPOj9I4TjPETf1OfIMLz24iiSOYssKYHSj3XfuzzU=;
	b=uvmcNV41tftp3gwSA4dVcDwegd+6st5NZ4qA0KoIBF7O0ZaGtrblFec37pPAaIxEUpsCBT
	RLLqiWV8A/X2CT4f3uOHKChuvntxpjoBCmgUglcOblbZk+BGvsLPRrwMmQHkj6K3/Dxd51
	MTygj+O2VkpYwE6dgCjtGY6Y6kXZIoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZMLtdyM;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778682554; a=rsa-sha256;
	cv=none;
	b=0BV3K/URABV9vCTDrkZrsl6yGO+WHKPrf0z6fjFNmUWrtcvtlVT4r18YvhEJJY8glfKSEh
	nJ45K85lGuHZRAsSaEDRs1OA8TwgOXJSn4Ppdc9Ad3zksgNcrQjeGHjwljZE8e1GmRG2fQ
	E6W00sB1tg16PJpsngoyFudewuAdYW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E1160123;
	Wed, 13 May 2026 14:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B162C19425;
	Wed, 13 May 2026 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778682553;
	bh=edzZokcmT2eO0GQN6AXC/9EBqi6mYNQBmL8PuKLDZ4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZMLtdyMm3nuVmZJm1sQ2mrOKQBytY1fyUfcPTr9mKqGJDy2crUM929dzGpapfl00
	 uRmMsjkKFO+kWD5XLtGQgrXEk+vcx8XeGr+FTLdgzg4vNQnQ4PPjvwv9ULJQrR3DoY
	 9HyagXoEoM1E7ZPaLFjKjXNso2XWShZAQXeHIbLhEuaaQQZsb/9DuTTg1CiYTKTF1x
	 9VJs8UtLMO3OUgC1FADFrpQYiXLD4T8NNjjH4bgSMDfk2c2unuz0ffrJzFtKDZEEtc
	 V3CXYGWsR9Z60dVNKBgVI1gpJsQWv1al/9prcZrGvpt/EsIJIq2/YRmESdooSVAVLs
	 ajlzcDHah/ULw==
Date: Wed, 13 May 2026 17:29:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] memblock: don't touch memblock arrays when
 memblock_free() is called late
Message-ID: <agSKsPZH8J22kguc@kernel.org>
References: <20260513105122.502506-1-rppt@kernel.org>
 <agRyMXYfoww-7Z4X@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agRyMXYfoww-7Z4X@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C96E640008
X-Stat-Signature: 4hizp4ox6tnp5kxxqqixk5yr98mk3iac
X-HE-Tag: 1778682554-944105
X-HE-Meta: U2FsdGVkX1/8FIEpTB6RuMVRvIzy11058tR+pcj+DP+t7icGJvD+WRqJ4WGR/2LGhOg2D/YPR6YBKpuQ48GyH1sw7QADWL0ucmVRqNQkiQR6WE2hi+O4cbZVOdvyofIJkuO87sV8lzta8cE2p9wv5NZlHCkV9CXU54QkhLBJ62mhHFdCeJEy2fcwGLUTxjnT4vr0U0ba+C7ePmghVGPmPni8WG0i3WPulSBayR2w0K09cn1cn65aM7EQC+qBednlBY29SO7jPqqGH/v0njrkGQhpnQoB0JSCfL0kZyR6AFSadKvUedjWSNGwiEe6tPVNECGjhkfr577hXsR6NmXSrEefpivE9HI8uHx/1AuIN6KZZUeLz77roYfRQorQI/4oQv+w9uqpMNn34EKk1AdIcD1imwoqDd9Joh7aVwNWNloYqo7RA4Z1f4K7OgMOF3U/8s07shiHbIVSR0yEBExjoo+XeHja3K515m8BIS1GQZD34WoHTe6Vlh8SLPjrnScCs8HuFj6iJjMDETmhyby8vs8B4zzhnMHXs30E/uWM+xH2CcALgT6gSoYEwyy+VC9X/pIbYz01itl9dotMoD18XC95BrHVEEYPXUJDn6bBnX4ZlPYUkpeihAjAd7pFZvoDGjaRps8hyvXqg56IE5Al8+ZUgBVgSTTKrJEQ2jIw0opiPKSbInRUedqqhC9DpA029/od/wyp+6nN5uJFdai42o5M8oIsc4WdzFfno336bLAdsWBryv8IPZuR0Yic2BhsiRuhqDIa0XHQfYaMaV33dQB3T99mMCd2+7lyGeKWNm+C7rNJVhQ4MkgojkWOtXVhMwRNk3qOSdF7EqUcMyoMyJmb/3oRTJtoqBCq8C5EJG+sP83hKcZZ0ziPXc01h0hAKhQvUE+7kNrf0hSh/piV7ar9Ro+IIbgx5IEb9gd+VZ0YheJcEESqBOOjttaAEVARUt+kzMN40vhuwOQ4gWq
 fgKswPis
 jn9WXrDmnwT78coE1tE0mbVYNV/y/n+/v0dpYnEUTK1+7Oji1LhFpt4Tcq6lw792vwqmzFPeaQR5GNxeV9rGBxyqsZT4rUtbVDoZ8tI2OkQxt0lLjSACkVBlcAEtKQjBe4LrH7q+rtoykmdqWguOIeCqh1tF3Cbh7EoMF0LOXAy/QJiFEZZrfzoBZ5rShrSB8uhwkHPrbPOwNVi2A0Hr7JJHM2ecd9Z0bWWhofwN1GchYOwb6fn9f4IjiGkNFM7eX35AXWKxwx8mQResPOqYUFNGlasEKJhCsySZcIv1HeY/epjfPkqkwqXqk0kPrUa3jJFeD3Ki0H5qx7kaxmCLiWwacDATCDuSVS9IeB0G2Z2sXqmNlAtC8VUljdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 05:47:34AM -0700, Breno Leitao wrote:
> On Wed, May 13, 2026 at 01:51:22PM +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > When memblock_free() is called after memblock_discard() on architectures
> > that don't select ARCH_KEEP_MEMBLOCK, it tries to update memblock.reserved
> > that was already discarded and it causes use-after-free, for example
> > 
> > [    8.514775] BUG: KASAN: use-after-free in memblock_isolate_range+0x4ac/0x650
> > [    8.514775] Read of size 8 at addr ffff88a07fe6a000 by task swapper/0/1
> > [    8.514775] Call Trace:
> > [    8.514775]  <TASK>
> > [    8.514775]  kasan_report+0xb2/0x1b0
> > [    8.514775]  memblock_isolate_range+0x4ac/0x650
> > [    8.514775]  memblock_phys_free+0xc4/0x190
> > [    8.514775]  housekeeping_late_init+0x257/0x280
> > [    8.514775]  do_one_initcall+0xaa/0x470
> > [    8.514775]  do_initcalls+0x1b4/0x1f0
> > [    8.514775]  kernel_init_freeable+0x4b5/0x550
> > [    8.514775]  kernel_init+0x1c/0x150
> > [    8.514775]  ret_from_fork+0x5dc/0x8e0
> > [    8.514775]  ret_from_fork_asm+0x1a/0x30
> > [    8.514775]  </TASK>
> > 
> > Make sure memblock_free() updates memblock.reserved only when called early
> > enough or when ARCH_KEEP_MEMBLOCK is enabled.
> > 
> > Reported-by: Waiman Long <longman@redhat.com>
> > Reported-by: Breno Leitao <leitao@debian.org>
> > Closes: https://lore.kernel.org/all/20260505051821.1107133-1-longman@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Tested-by: Waiman Long <longman@redhat.com>
> 
> Tested-by: Breno Leitao <leitao@debian.org>

Thanks!
 
> Don't you want a Fixes: tag?

Right,
Fixes: 87ce9e83ab8b ("memblock, treewide: make memblock_free() handle late freeing")
 
> > @@ -989,13 +989,15 @@ void __init_memblock memblock_free(void *ptr, size_t size)
> >  int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
> >  {
> >  	phys_addr_t end = base + size - 1;
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
> >  		     &base, &end, (void *)_RET_IP_);
> >  
> >  	kmemleak_free_part_phys(base, size);
> > -	ret = memblock_remove_range(&memblock.reserved, base, size);
> > +
> > +	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
> > +		ret = memblock_remove_range(&memblock.reserved, base, size);
> >  
> >  	if (slab_is_available())
> >  		__free_reserved_area(base, base + size, -1);
> 
> given slab_is_available() is a cheap function, it is fine to call it
> switch in here.
> 
> Thanks for the fix!
> --breno
> 

-- 
Sincerely yours,
Mike.


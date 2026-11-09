Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79385606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SsY3NZY5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Gfs5si5n;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1+XxaE5u;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=//9sHfMv
Received: by kanga.kvack.org (Postfix)
	id D56C66B05B2; Mon,  9 Nov 2026 12:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EB06B05B3; Mon,  9 Nov 2026 12:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D0D6B05B4; Mon,  9 Nov 2026 12:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 904EA6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:11:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 103441A075F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:11:25 +0000 (UTC)
X-FDA: 85416221730.01.AC65E5E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9D5E620008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:11:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SsY3NZY5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gfs5si5n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1+XxaE5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="//9sHfMv";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794244283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gs6QBIGalAs9lEG41sgY64X7mlEyPCFXyN0vk0XfcLQ=;
	b=d32GbjRpBeGls1p45mqVpsmQuGlvw8NHJIyPsY8nIKem7pzDsqwwbpx3hCTojceFOVjw1m
	OXHxJhh5J7ccUjCRoSXoCSjbYOUslZk2YYb1U/AmlVi/EzDC7c/OGJoNtnQatWGAER9gHF
	OS4Ay7diKw/zmyJr3nLC1VAnTHmMMWg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SsY3NZY5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gfs5si5n;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1+XxaE5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="//9sHfMv";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794244283;
	b=Xy3Zx9fpPdz5Jur2BGBeL/rAlVWqrjPw90IoE9KgriVXQynBDfu4mDGA+8gzF/VXs0F1DX
	S4lTl37T841ju+5EZ3G0D32hFvzZgYZGrXMvkBXZNOhQAXbr1Z8UYFCBg5/Q6wyYVrow2y
	T/BA6paEP/f3ErfUI9nj6ISTGpUZjmw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E62F41FB53;
	Mon,  9 Nov 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794244281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs6QBIGalAs9lEG41sgY64X7mlEyPCFXyN0vk0XfcLQ=;
	b=SsY3NZY5sMQeTbtV7S8+yP3pq+ks38fZoFZm9Ebpm0CPO8jjwrVg7A5iHmX+4ahVUVYmPB
	NqRcMBF5DCWpTf9drN2Y/vjh0NRxXclb1UOJvEQzuZWxVT9ccQIorovXRHIDiketABtJMF
	S4PkgaVisKb5v9+OSS0MvXRJrlQp0Q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794244281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs6QBIGalAs9lEG41sgY64X7mlEyPCFXyN0vk0XfcLQ=;
	b=Gfs5si5n9TEWpaR1fl2aMvru04EM9s6SJUkkHkAFcEK24xgXICLVSH6sce2/7k6TFzp5iR
	8fwTLliGP0eUZTDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794244279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs6QBIGalAs9lEG41sgY64X7mlEyPCFXyN0vk0XfcLQ=;
	b=1+XxaE5uo8TfQfC3A9/88to8Y9OLGLVLHci8k626/NbcbB6UC677xEhkEfF7ZHx4b4HfvE
	xEB7IRobo3dqbXNYqpj4dLut9FDMIB1hx3z7EhYpbXWIFP9IWXLkX3hVMeGB+mL3uOg0BD
	QoGIiDXJeXCcqvS8xjBzirpTGVxIELA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794244279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs6QBIGalAs9lEG41sgY64X7mlEyPCFXyN0vk0XfcLQ=;
	b=//9sHfMvBMOGxyFoizeJphQPIUv4nhiiueyDnbLr2//cxHGwfRkp1peTplCdyLnt3T3U3c
	zUprmjIIQovyzMCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E43B913302;
	Mon,  9 Nov 2026 17:11:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id py5/L7b+8WpAFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 17:11:18 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 150B622368; Mon, 09 Nov 2026 18:11:14 +0100 (CET)
Date: Mon, 9 Nov 2026 18:11:14 +0100
From: Jan Kara <jack@suse.cz>
To: alireza.haddadi@it.uu.se
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Message-ID: <gewwqi2kcu4nsitueyw2nd6g6eqjb3wqh4mks5lqcbkc6re4sn@eaqpgn2hxls5>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D5E620008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3ungasfuuf511q6hiy5fcpm3sw5i1ukp
X-HE-Tag: 1794244282-979896
X-HE-Meta: U2FsdGVkX18raF87CxuolzXesCoqeT4GRcP5voKVaO/XNQOzm/T/HzU9HKxkf1gBVYVxZ5TA4M7tDqeEJL0Aae77zSbnwVvsDIxlVQe2RYagJfDbQ33gYVjzAsJdnEGX0dABWI4mCMMxRNpPUdeoRtgsk73+KJG+z0wilrPqLE/HG3P/CJdTpn3tAIK0X1L84TnRRED2c5nwcUtLcR1Z9xT56rWeHNZKhFeaBEQmS/VdYfKhGBlO/Hpyd9Kvb4CKmnOicyoo8V/wwQmbxFyxluPNnv9X8Ickl0ivLC6tcn6CyDZGEL+L4dWeIG1BVB3YnfLkr3dpapKITKnEP2rnJwor4GP54t5WCeFIcFZZPSJLPZlT+XI4EnlLcXX3aSa7Ive4tWO79skn6rKgpxhuAzqA0WFYEkEIIHKhrsFj5iwA8+sSVv6tlb3R11akFINoeORY43NLxVPdoL9rt34WnCQJHVk1UwcLBJuXeQOs10w4QZZLtN5Fdbd8ZUOX48NqGiDs5ypmSePyjpcMeaFsSEz9EytY7K4/WJOEMjkzWDitaoPdbZ1ykkBffGoY1iWAYl3QBwfyqK6NTfkmylTqsHXXXP5gIonkW269WcPfYM6psYtE1aOe88dzcHqoF4jbYdTEL1LrMZowUj85hY0m1V+v3BSkoGnRhOgmkkbSKGm64mjxhtREBwxpecwPfhpidI3KErfrkTvquut6A/syluvAg89DVTHckSad7I4dOBedLxfHB+ntxkEENd/6TFpj8v9dacEZe4Hv+KBW8dgRzgLcAwuyCVwjEhGAtOIxcq8vlswHvU+LhbFSQvexuvEffpSIsmvkOTlOLW6TNvJdgCASz+AyYRU/Azaw03N04vPF9n3TNvdSHIQIpIcpyXp8yDEYSN9DekISSA8gSS9tAsp+ssU1dX8B9KjapVRh++J1tKle5nO8cFUHD9hO4oIjgrRZOOexwytUM7LHYQY
 XkbxxQ+n
 lgsc0ZZ2+CynxSI1TgtK4m/gyqYwLJoEJcZSfCHcOsPWIOpN5FZyTezwvG0R2WBe5wmonrTObxPYEPmL4mESbcxPGjlcJT8CuJgr4aURjKu9ksHXSZjj0KdzXEIIWM4xEPNwtjIzsj5NUoFpU1eODpVVafQYLxhUxJKqFlmT+ZiaYqoZymlz81QhXSfhPHc1FHPVsMZMaKd4Ft4C5AgMbesTaya5ga5ZDFnZud2rIIAxfCL0ITEZeNn/RAUF3ybTwTTqG7fqGIK6R/QGOf3ETEGKJJW3DhbF+QhzXLHJ8c+pZSJV7Ap35NO3njgTD0zsScSbzzFLb2RpBolDBLDm7o7hpdbmC4F8327kl+HLjD50+mTWQSmjArzfODnhySNdEIXQQSrV0Virft9yUiRfRn1c6VRzdP1IdpzrbxSMCtjCcd0yKJM/EgPSaZ+q2zBqeYvU260sWYOqYDeM5srm5B22WhAkmmycEIEjnvdFJqACG9JCN56v1Sz9Lc2WYDwLtYKQQ7Xx1aqy2LvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 09-11-26 15:23:24, Alireza Haddadi via B4 Relay wrote:
> From: Alireza Haddadi <alireza.haddadi@it.uu.se>
> 
> After commit 0b9c0aeba938 ("mm/filemap: count only the faulting address
> as a mmap hit"), once a file's mmap_miss goes over MMAP_LOTSAMISS it can
> stay there until the file is closed.
> 
> With mmap_miss over the limit, do_sync_mmap_readahead() reads only the
> page that faulted. Since nothing gets read ahead, no later fault can
> land on a page that readahead brought in. In turn filemap_map_pages()
> never counts a hit, and the counter never comes back down. From then
> on every fault on the file reads only a single page, even when the
> access has become sequential.
> 
> I ran into this on v7.3 with llama.cpp, where a model larger than its
> memory limit sometimes ended up being read 4 KiB at a time, but other
> programs hit it as well. Anything that does some random reads and then
> reads the same open file in order faces the same problem. I tested the
> following:
> 
>  - SQLite with mmap_size set, 300 random lookups followed by a full scan
>    of a 1.8 GiB table. The scan took 9.3-14.2 s instead of 2.1 s in 8 of
>    10 runs.
> 
>  - numpy.memmap, 1000 random rows sampled from the first 75% of a 4 GiB
>    array and then the last 25% read sequentially, as a training and
>    evaluation loop would do. The sequential part took 3.3 s instead of
>    0.3 s in 5 of 5 runs.
> 
> Give a sequential reader a way back. When readahead is off and the page
> before the faulting one is in the page cache, read the next page too
> and mark it with PG_readahead. A sequential reader faults on that page
> next, which starts async readahead. That path is not gated by mmap_miss,
> and the pages it brings in count as hits again, so the counter drops
> and readahead resumes. A random reader, however, rarely has the previous
> page cached, so it keeps reading one page per fault, or at most two.
> Forced THP readahead is left as it is.
> 
> This reproducer takes 100 random faults on a file of at least 4 GiB
> and then reads 1 GiB of it in order:
> 
> 	#define _GNU_SOURCE
> 	#include <fcntl.h>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
> 	#include <sys/mman.h>
> 	#include <sys/resource.h>
> 
> 	/* ./a.out FILE N: N random faults, then read 1 GiB in order */
> 	int main(int argc, char **argv)
> 	{
> 		long G = 1L << 30, i, flt, size;
> 		struct rusage ru;
> 		volatile char *p;
> 		int fd;
> 
> 		if (argc != 3 || (fd = open(argv[1], O_RDONLY)) < 0)
> 			return 2;
> 		size = lseek(fd, 0, SEEK_END);
> 		posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
> 		p = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
> 
> 		/* N random faults beyond 3 GiB */
> 		for (i = 0; i < atol(argv[2]); i++)
> 			p[3 * G + random() % (size - 3 * G) / 4096 * 4096];
> 
> 		/* then read [2 GiB, 3 GiB) in order */
> 		getrusage(RUSAGE_SELF, &ru);
> 		flt = ru.ru_majflt;
> 		for (i = 2 * G; i < 3 * G; i += 4096)
> 			p[i];
> 		getrusage(RUSAGE_SELF, &ru);
> 		printf("%ld major faults for %ld pages\n",
> 		       ru.ru_majflt - flt, G / 4096);
> 		return 0;
> 	}
> 
> 	$ ./a.out FILE 100
> 	before: 262144 major faults for 262144 pages
> 	after:       2 major faults for 262144 pages
> 
> I also ran the access patterns from that commit's changelog (random,
> strides of 1021, 1024, 2053, and 4099 pages, and sequential, on a
> 20 GiB and a 4 GiB file in an 8 GiB guest). With this change, bytes
> read stay within 0.1% and times within 3% in all cases, so its gains
> are kept.
> 
> Fixes: 0b9c0aeba938 ("mm/filemap: count only the faulting address as a mmap hit")
> Signed-off-by: Alireza Haddadi <alireza.haddadi@it.uu.se>
> Cc: fujunjie <fujunjie1@qq.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Vishal Moola <vishal.moola@gmail.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>

Hum, this looks like an ellegant way around the problem so I'm willing to
give this a try :). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Tested on mm-new (x86-64):
> 
>  - With the patch, no run gets stuck: the SQLite scan (10 runs) and
>    the numpy pass (5 runs) take as long as their controls.
>  - mm selftests: no new failures. droppable fails about once in 20
>    runs, with and without this patch.
>  - A KVM guest with KASAN, lockdep and DEBUG_VM ran the reproducer
>    above, strided and interleaved access, and a 4-thread test: after
>    200 random faults, 4 threads read the same file in order through
>    one mapping, so they all take the new path at once; the file is
>    twice the guest's memory, so this runs under reclaim. No reports,
>    with or without the patch.
>  - W=1 and sparse are clean, also with THP or LRU_GEN disabled.
> 
> The cost for random readers, once readahead is off: when every third
> page is cached and each access lands just after a cached page, 1.77
> pages are read per access instead of 0.89. Strided access reads the
> same as before.
> 
> Forced THP readahead has a similar problem with mmap_miss. I left it
> out to keep this change small and will look at it separately.
> 
> I can share the benchmark scripts (SQLite, numpy, the access patterns
> of 0b9c0aeba938) if that helps.
> ---
>  mm/filemap.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 93db8fc60ae0..0930aacee9fe 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3403,8 +3403,33 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * Do we miss much more than hit in this file? If so,
>  		 * stop bothering with read-ahead. It will only hurt.
>  		 */
> -		if (mmap_miss > MMAP_LOTSAMISS)
> +		if (mmap_miss > MMAP_LOTSAMISS) {
> +			struct folio *prev = NULL;
> +
> +			/*
> +			 * Nothing is read ahead now, so mmap_miss stays high
> +			 * forever.  If the previous page is cached, this may be
> +			 * a sequential read: read the next page as well and
> +			 * mark it, so that async readahead, which does not
> +			 * check mmap_miss, restarts when the mark is hit.  The
> +			 * pages it reads then count as hits and lower
> +			 * mmap_miss.  A random reader rarely has the previous
> +			 * page cached and keeps reading one page per fault.
> +			 */
> +			if (!force_thp_readahead && vmf->pgoff)
> +				prev = xa_load(&mapping->i_pages,
> +					       vmf->pgoff - 1);
> +			if (prev && !xa_is_value(prev)) {
> +				fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> +				ra->start = vmf->pgoff;
> +				ra->size = 2;
> +				ra->async_size = 1;
> +				ra->order = 0;
> +				ractl._index = ra->start;
> +				page_cache_ra_order(&ractl, ra);
> +			}
>  			return fpin;
> +		}
>  	}
>  
>  	if (force_thp_readahead) {
> 
> ---
> base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
> change-id: 20261108-mmap-miss-bf5a501088eb
> 
> Best regards,
> --  
> Alireza Haddadi <alireza.haddadi@it.uu.se>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


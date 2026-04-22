Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5292DF9B607
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE696B0095; Wed, 22 Apr 2026 06:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6208E6B00A1; Wed, 22 Apr 2026 06:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AB06B00A0; Wed, 22 Apr 2026 06:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35CD76B0095
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:15:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8E23BE769
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:15:10 +0000 (UTC)
X-FDA: 84685783980.24.3AF2ED1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 35D0040008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:15:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2yIseIFj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qaKJR6FB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2yIseIFj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qaKJR6FB;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776852908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+BDt9d73puNgLCqsjSH8JR3Iy9Bzj4q0jrj4OOX3pA=;
	b=y3niioTRTuMILcwsRqtlyRFmCpwMIT9mo1ln9GbUMibOu7xHJSZiODdYgxqroi9iBnwRsZ
	itEM6mYDGqQ4Kx3QCDnGvWALkbHstAmPWnbBZn2m1r9fPy5TpWShBoJyW+x566ie3tFR1a
	+CKsuKhhZDDcd14dRc02ggHgClAMYhg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2yIseIFj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qaKJR6FB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2yIseIFj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qaKJR6FB;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776852908; a=rsa-sha256;
	cv=none;
	b=Voo10+F1OFTg4RJ31TPvcxa6VBVzHLxEVNd7YPhwsHRFDvGiXR8WS9aYrEUS7HhJ1e1mZ0
	SVUZ5bkDXRS4wvV/I9cFqxB9099JFwnSGwCIJuvYqloaew7aiy/HlrGtssonydRDnhSseA
	PVvAHg3jexjcQKqbBO+qc67RYlKiZwE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 50EEA5BCEE;
	Wed, 22 Apr 2026 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+BDt9d73puNgLCqsjSH8JR3Iy9Bzj4q0jrj4OOX3pA=;
	b=2yIseIFjaai70KqONL6i3f4wcI6m01kvIxg8Ut3Oq/Bpydh8zZsi5VtTdJ/I/0+G7g4qh6
	y15NapIvqKwGLQzQiSDQXyO5Akk7T2QRYO1s452uHCtGHUMlD5khybqTZTEpM/8dakI8d0
	PlldcCSbQOowhwTqZfiQ75Ly8xJh5TQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+BDt9d73puNgLCqsjSH8JR3Iy9Bzj4q0jrj4OOX3pA=;
	b=qaKJR6FBaoqh8xlaNAWIzeQBE4CkFfEYMNR5APnwIwydAFVrXGKgpW1eqWkTbOUEfhryhE
	iZ33FQ2/JosHK8DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+BDt9d73puNgLCqsjSH8JR3Iy9Bzj4q0jrj4OOX3pA=;
	b=2yIseIFjaai70KqONL6i3f4wcI6m01kvIxg8Ut3Oq/Bpydh8zZsi5VtTdJ/I/0+G7g4qh6
	y15NapIvqKwGLQzQiSDQXyO5Akk7T2QRYO1s452uHCtGHUMlD5khybqTZTEpM/8dakI8d0
	PlldcCSbQOowhwTqZfiQ75Ly8xJh5TQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+BDt9d73puNgLCqsjSH8JR3Iy9Bzj4q0jrj4OOX3pA=;
	b=qaKJR6FBaoqh8xlaNAWIzeQBE4CkFfEYMNR5APnwIwydAFVrXGKgpW1eqWkTbOUEfhryhE
	iZ33FQ2/JosHK8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41112593AF;
	Wed, 22 Apr 2026 10:15:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iujbD6qf6GmRZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 10:15:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 09F49A0B60; Wed, 22 Apr 2026 12:14:58 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:14:58 +0200
From: Jan Kara <jack@suse.cz>
To: Frederick Mayle <fmayle@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, kernel-team@android.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
Message-ID: <q3gze6hnx4mtkpht5gdjfgo3csyf4rpbh3nlmq7r22ajyczgii@to5n6cfhoeaz>
References: <20260422005608.342028-1-fmayle@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422005608.342028-1-fmayle@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35D0040008
X-Stat-Signature: 4cwi9wp8rbufb1nbximp9yirn67ak7pf
X-Rspam-User: 
X-HE-Tag: 1776852907-181931
X-HE-Meta: U2FsdGVkX1+4ei7C3O+OYCOLFv25FIDvJlAPGOO+c7nSOfLK4IVmSyDK5mliMNf49oPLBjp2rWSvwmbAN9Iag2YA9SaR8FZj/C3XU0IAxbeCfaAviwC7xiKDYQ0HCKE5H0Tyro8N50MuXQYJpecedEThXTty3lyX32m+ewnIsa2yDrfAEnPJURagvkA8YkZHLmRfcf563KU9yrfv1Lv9MYkWeCHSc+YS+CfkTUohMteoCa1vG1l/TssVicpH0VPmmUs6cZdW41Y96xE0OMJvH/ISrHi04F1k97uCg2VCN24yLJNMwvhh9Pc8K1NoCQYWIxcQfVtrbaz8PlKzZwo/9orGyLvBjUJMg3QeAwgqNG8H4hQB9WjP2LuWpAQGbvBPdhWvjfuZW+yep2jo1CpzubP2dxnd1k6M5wp/G/L66OAlmSmYy3H5YyGLRLgP3Xn3yeGuB8z4IyEdENSt//S3Rpa0d8Z2Q39G3d3l8Gq5Q7YBoBsvit8w1/pfWlOwOXpKoWiCO0vvwIAsJshgB5MBIYSgw6iY3PYLl1tJfrSq+MP1/DiWOs+sIq5WqBSqHLXAcw+5bT6nrCdaRY/DYMJGLq6HfpDY/lM39PG6BlzzrO8MVmtn3MrRiFPMQj+QoYDzh/riUBUEpz6HEjtFTE6uxUq4psGRS49QhhHZ8kxMhlip0vIac1E4mM1PnfC0LBsEeaRoeO4inU1sh09RxjLS1KuJLl3tdUCavwDMXk3C+6fgB5xhw4rjke8z5QeeBymjYpxT70aWXPu5N1qp7If4gDm/Wshr3/rRekFYqEWuh3oudKyUVIDW9/wj7Ejf2/ELodD3xUHPraZmtmyz6RGSmyCMMSSTSP6EovWO1gBYir+vFCjhHCGNbrMdLu3q0nQ+WWYi4luIYNATsRF0NkFB1n4xt2H+y/uMGu1e3rdVTagkn8Ga9t1uimM7RiawZdwE/7eHcsP2JBKTLMJuDpl
 f3ct8YSX
 2e+8jMr004AijzW4Ulft6Nii3qtHAvyhy4RWp10xkXFJied79CbNggFzXAZ1mP2U8KbRVuVugayMcrm376FUAzTPRP8l9QNZof7v52hxMdS4YourHycBJTYm7xN39w5VfUccegjhzR9+jwmuAyulMXktFC/+weQ7ii/DSPIoCMqU0YX7p+uddC8c1SiZp9jGhVeHLqFrS1w1De2mXnMVWwdK29Nq13iFyOYB9SIkNNp/DmtEif6VKH2iXDu/NsgKrRGK+3B8H+OFUbZ1fTRh2HuClJR4WjN/z0QlKYdTddpgIgx9uxny7nulRJ1XmURSSp1O4gkNNL/2bGSrgSYjttvo/xFWV1Bmbdog8yth4T6bZt3ZanFu7EaBSkWk90UTwqGqyBzy3qwgUshcWfFf0JHS80xTrDpnJYeJvF/ciuEOr7zSwQJVRs2iagXLja1CRJCMb8Ixl1TdtjCThVr2zEPvwx0Qqe6xao3csu3SBpz91mpbCH7/YqbsdRT2PP9/y5SO0wEeY0sbDkGL+meAyp77XEwDvGvq7v8ceHTk5wKJF+J9X+40xGrzZ1/hwY/nA+NJyRgt2Nii/NPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-04-26 17:56:07, Frederick Mayle wrote:
> When a file mapping covers a strict subset of a file, an access to the
> mapping can trigger readahead of file pages outside the mapped region.
> Readahead is meant to prefetch pages likely to be accessed soon, but
> these pages aren't accessible via the same means, so it fair to say we
> don't have a good indicator they'll be accessed soon. Take an ELF file
> for example: An access to the end of a program's read-only segment isn't
> a sign that nearby file contents will be accessed next (they are likely
> to be mapped discontiguously, or not at all). The pressure from loading
> these pages into the cache can evict more useful pages.
> 
> To improve the behavior, make three changes:
> 
> * Introduce a new readahead_control option, max_index, as a hard limit
>   on the readahead. The existing file_ra_state->size can't be used as a
>   limit, it is more of a hint and can be increased by various
>   heuristics.
> * Set readahead_control->max_index to the end of the VMA in all of the
>   readahead paths that can be triggered from a fault on a file mapping
>   (both "sync" and "async" readahead).
> * Limit the read-around range start to the VMA's start.
> 
> Note that these changes only affect readahead triggered in the context
> of a fault, they do not affect readahead triggered by read syscalls. If
> a user mixes the two types of accesses, the behavior is expected to be
> the following: if a fault causes readahead and places a PG_readahead
> marker and then a read(2) syscall hits the PG_readahead marker, the
> resulting async readahead *will not* be limited to the VMA end.
> Conversely, if a read(2) syscall places a PG_readahead marker and then a
> fault hits the marker, the async readahead *will* be limited to the VMA
> end.
> 
> There is an edge case that the above motivation glosses over: A single
> file mapping might be backed by multiple VMAs. For example, a whole file
> could be mapped RW, then part of the mapping made RO using mprotect.
> This patch would hurt performance of a sequential read of such a
> mapping, the degree depending on how fragmented the VMAs are. A usage
> pattern like that is likely rare and already suffering from sub-optimal
> performance because, e.g., the fragmented VMAs limit the fault-around,
> so each VMA boundary in a sequential read would cause a minor fault.
> Still, this would make it worse. See a previous discussion of this topic
> at [1].
> 
> Tested by mapping and reading a small subset of a large file, then using
> the cachestat syscall to verify the number of cached pages didn't exceed
> the mapping size.
> 
> In practical scenarios, the effect depends on the specific file and
> usage. Sometimes there is no effect at all, but, for some ELF files in
> Android, we see ~20% fewer pages pull into the cache.
> 
> A comprehensive performance evaluation hasn't been done, but, in
> addition to the anecdontal memory savings mentioned above, a benchmark
> was run with fio 3.38, showing neutral looking results:
> 
>     /data/local/tmp/fio --version
> 
>     fio --name=mmap_test --ioengine=mmap --rw=read --bs=4k \
>         --offset=1G --size=1G --filesize=3G --numjobs=1 \
>         --filename=testfile.bin
> 
>         Before: 4366.6 MiB/s (avg of 3459, 4592, 4613, 4697, 4472)
>         After:  4444.0 MiB/s (avg of 4633, 4655, 4511, 4571, 3850)
>                 +1.7%
> 
>     Same, with --ioengine=mmap --rw=randread
> 
>         Before: 445.6 MiB/s  (avg of 446, 447, 442, 452, 441)
>         After:  447.0 MiB/s  (avg of 447, 446, 446, 451, 445)
>                 +0.3%
> 
>     Same, with --ioengine=psync --rw=read
> 
>         Before: 3086.6 MiB/s (avg of 3122, 3094, 3066, 3094, 3057)
>         After:  3084.6 MiB/s (avg of 3039, 3103, 3103, 3084, 3094)
>                 -0.06%
> 
>     Same, with --ioengine=psync --rw=randread
> 
>         Before: 2226.4 MiB/s (avg of 2256, 2183, 2207, 2265, 2221)
>         After:  2231.4 MiB/s (avg of 2236, 2241, 2236, 2193, 2251)
>                 +0.2%
> 
> [1] https://lore.kernel.org/all/ivnv2crd3et76p2nx7oszuqhzzah756oecn5yuykzqfkqzoygw@yvnlkhjjssoz/
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: android-mm@google.com
> Cc: kernel-team@android.com
> Signed-off-by: Frederick Mayle <fmayle@google.com>

Looks good to me. Thanks! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/pagemap.h | 2 ++
>  mm/filemap.c            | 4 ++++
>  mm/readahead.c          | 5 ++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index ec442af3f886..cc628050bc5e 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1366,6 +1366,7 @@ struct readahead_control {
>  	bool dropbehind;
>  	bool _workingset;
>  	unsigned long _pflags;
> +	unsigned long max_index; /* limit readahead to i<=max_index */
>  };
>  
>  #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
> @@ -1374,6 +1375,7 @@ struct readahead_control {
>  		.mapping = m,						\
>  		.ra = r,						\
>  		._index = i,						\
> +		.max_index = ULONG_MAX,					\
>  	}
>  
>  #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..d2f6bef12f58 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3314,6 +3314,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	bool force_thp_readahead = false;
>  	unsigned short mmap_miss;
>  
> +	ractl.max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
> +
>  	/* Use the readahead code, even if readahead is disabled */
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> @@ -3396,6 +3398,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * mmap read-around
>  		 */
>  		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
> +		ra->start = max(ra->start, vmf->vma->vm_pgoff);
>  		ra->size = ra->ra_pages;
>  		ra->async_size = ra->ra_pages / 4;
>  		ra->order = 0;
> @@ -3438,6 +3441,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	}
>  
>  	if (folio_test_readahead(folio)) {
> +		ractl.max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  		page_cache_async_ra(&ractl, folio, ra->ra_pages);
>  	}
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 7b05082c89ea..95a424b2f3a3 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -324,6 +324,8 @@ static void do_page_cache_ra(struct readahead_control *ractl,
>  		return;
>  
>  	end_index = (isize - 1) >> PAGE_SHIFT;
> +	if (end_index > ractl->max_index)
> +		end_index = ractl->max_index;
>  	if (index > end_index)
>  		return;
>  	/* Don't read past the page containing the last byte of the file */
> @@ -471,7 +473,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  	pgoff_t start = readahead_index(ractl);
>  	pgoff_t index = start;
>  	unsigned int min_order = mapping_min_folio_order(mapping);
> -	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
> +	pgoff_t limit = min_t(pgoff_t, (i_size_read(mapping->host) - 1) >> PAGE_SHIFT,
> +				       ractl->max_index);
>  	pgoff_t mark = index + ra->size - ra->async_size;
>  	unsigned int nofs;
>  	int err = 0;
> 
> base-commit: db2a1695b2b6feb071b47b72e61d0359bf1524bf
> -- 
> 2.54.0.rc1.555.g9c883467ad-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


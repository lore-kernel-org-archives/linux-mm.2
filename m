Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19332FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8381D6B0092; Mon, 27 Apr 2026 09:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9076B0093; Mon, 27 Apr 2026 09:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF616B0095; Mon, 27 Apr 2026 09:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEB06B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:25:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 183601A0176
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:25:26 +0000 (UTC)
X-FDA: 84704407452.19.F43BEFF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id BCA2880002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:25:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfpB1JJ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pGKz+bLm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfpB1JJ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pGKz+bLm;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lCwe8jhmfKWQiton2Foqse5sbsgfeXHo7k8fm/mu9c=;
	b=64l+V0LgfsEsjPsrK4Buw3zO31ZWzgf5aC6V8vBX9bcrKdk/d3ZyS3qLRAodPzSNni0r3H
	NBnRzSzOSpWqPMSbGD7tWzFP7rkS1fVRkrKYxZYsJBJFlKxSWKGXE+yIrgWR8i40zxlBvN
	/Qdtq2Q+1v9dNpiH/7iVWDInqlDrNLA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfpB1JJ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pGKz+bLm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kfpB1JJ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pGKz+bLm;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296324; a=rsa-sha256;
	cv=none;
	b=AQHWZzaIQyB30WLLZAA0u5trM3r8eFsuWPR7OemWcSOPjS68jyqC2irshHOfEOgZJSp9vO
	QljLbi1lsTZq6+41KoldipBrZZTPusMO8LBfcJExJBusKXH4Sl4nNVC4tkvc8SijnU6ygZ
	cWUk3PoTV6ZQLlGTKaAOUMRGpar0TsY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BE6E5BCD4;
	Mon, 27 Apr 2026 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777296322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+lCwe8jhmfKWQiton2Foqse5sbsgfeXHo7k8fm/mu9c=;
	b=kfpB1JJ1SYrVhXxaJGAKFWkwce7fy4OaGvvQrySy91zgvKfRLU+oUm1Tiu6kO91iP3MXyp
	ojr5F+I1Y/Mu8VWFABkNwM5iBF5iggH914qx9tB3XN9qoRgaIa3UVgtzO+xNTb8dUEmeTp
	CtikYl4D5XG9CCBgoyAzioFFaydACK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777296322;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+lCwe8jhmfKWQiton2Foqse5sbsgfeXHo7k8fm/mu9c=;
	b=pGKz+bLmZJ2jZgDHyStHSAkxSk1J0e6SiOa+GfOmiq2XzugJQoS1TK7J49xSsREQDv6ACt
	56WySvR+HdmS8tCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777296322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+lCwe8jhmfKWQiton2Foqse5sbsgfeXHo7k8fm/mu9c=;
	b=kfpB1JJ1SYrVhXxaJGAKFWkwce7fy4OaGvvQrySy91zgvKfRLU+oUm1Tiu6kO91iP3MXyp
	ojr5F+I1Y/Mu8VWFABkNwM5iBF5iggH914qx9tB3XN9qoRgaIa3UVgtzO+xNTb8dUEmeTp
	CtikYl4D5XG9CCBgoyAzioFFaydACK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777296322;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+lCwe8jhmfKWQiton2Foqse5sbsgfeXHo7k8fm/mu9c=;
	b=pGKz+bLmZJ2jZgDHyStHSAkxSk1J0e6SiOa+GfOmiq2XzugJQoS1TK7J49xSsREQDv6ACt
	56WySvR+HdmS8tCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F24CB593B0;
	Mon, 27 Apr 2026 13:25:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jH8jO8Fj72n7UwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Apr 2026 13:25:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B79ADA0B3C; Mon, 27 Apr 2026 15:25:17 +0200 (CEST)
Date: Mon, 27 Apr 2026 15:25:17 +0200
From: Jan Kara <jack@suse.cz>
To: fujunjie <fujunjie1@qq.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [RFC PATCH 1/1] mm/filemap: tighten mmap_miss hit accounting
Message-ID: <qll45txbsmwpkrgzjqpzqh563vwd7dcycfl7beaey5gqh63wfa@y2kqsfvhltca>
References: <20260427102243.3519326-1-fujunjie1@qq.com>
 <tencent_3F158B17AE85E73945C5F97D8F8A918F9B07@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3F158B17AE85E73945C5F97D8F8A918F9B07@qq.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BCA2880002
X-Rspamd-Server: rspam06
X-Stat-Signature: 5iypbi7jqwghpnw1tdwz3imzi3rx9n64
X-HE-Tag: 1777296323-791743
X-HE-Meta: U2FsdGVkX192l/ldBpEoMlI1RcmD8b10crlRvb9cEwL6hZjdCmxU4UMc58x3uEVrpVfnUUbfdF7+u3Oi5aa2lkTgYZO+VX5xiWFcx34XQdrTudE+1XunkuX0+TN1K8MTCYwpX8NyfVq1TngdJwdTjSOxKB1LZ4p1oHzJ0oIwFz7MlXwnFrgvynf56VO4BS+9rgteRjTneZUQYaCNxj1o+Gap0yZ4R3WWs1VNf1CMuPYyvlJmRZj+A5hnhxiYE0213ZeyqHj4BSfjjSDBjI79OH+HfEDGmRPbeNcbpcF4cnY0/BbOztSNcL/V1zRYg/NTST4yDSZy/g7VwuQLkolcGYsPNI5sS58ty72YLh/Vl0L7xWoyNCL6oLRr4XsJ5mU9jSTjAjt0q40F311ZdkBmbQm5FP0VKiZjdkd/P9vm13qSj2VddiaBDPQ9OGG/697ES5CwDEB2JouaCtnZJJJw+fevh4uYo9u8E993jgUb5TfRMlshKuxyMNWUSXZPZaBrnqBrVj0k6tTkzoFgJad87DmFnWmQL9jdE+n3p97aKAl6tASEYAZsrCu6NepBMVAbcM3acbJm6cUtyLoS6R2z9z5/PTFS0Wbn/tWBRNzSPJbyTYuPVPdrfJK+rSj5F6Z1+AnJs277jq+q+/E68o6VN8xjGKJtf4F5y4+IktPxUEC+99ZgrtW7XRoIbrBiWr7Jn0eYsnJbdw89uVpAbOb422li/2HcbppxjDMuH42eg/N8qE/o4ChatMuLQUjoljv0ty+cNy/9DvoTTfaNpcMUz0Us4iZzVoNGHrasBIBjrpP55HV+6fPNMDqAFXI8BniI8nlZ8MdDfOilqbk3UiI5BHd6OeWH8jptTMheHbwmT9/XRAAlQAaxuroukO+zhm1b/8vgJxsNnY4M1rVaJOgH76NeTeUQnjtaOLqWE+KKUjTXYcMLggEl8LQjHWwlqdckr7ual6387a7uhtDWUGM
 7SOXP6H2
 g6Z02mMlNOXwvRUht574NNzq8pHndR/nqVfYRwsaFBGna46O5wTKQFvUpQDfVuONH6oADauDnDh1nNHrDSoJMBGLQro36psaKrajQP8iw89YCK3A0Yf9wPyHqO6F0y6HbTdqwBKcLenbGrhaEUUXNSrdmCKUOYeoL43GrZoOfH4B0sUgY1lI7nZDKdaVnKcg6qG0zHyzH5ygRmKaNxnq1CQ+ss1KiHNJd7dmKj///SJYLVqwNfjevk1LFcZUhl/6/G0df6fPCJLD7LVPqYRtEPflGNwuIyKfGWnBrzJEhbg6ZU24c/UsV404faqTZYWWFSfOhx+EQOMKjsAh/mIT/dZyMAzu+qMzgP/x9UH6hDbJJthoZuBkja2Lvrt2wuG2maPCjFogNbXEFlUTWFBU0HRzaaZrsfbtaDWYgb2Bsp4Tu1sJ9jbrSv6ueGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-04-26 10:22:43, fujunjie wrote:
> file->f_ra.mmap_miss is used to stop mmap readahead after repeated
> misses.  filemap_fault() increases it when synchronous mmap readahead is
> needed, while filemap_map_pages() reduces it when fault-around finds
> folios already present in the page cache.
> 
> The hit side of that accounting is too generous in two cases.
> 
> First, fault-around can install PTEs for multiple pages around the
> faulting address.  The fault only proves that the faulting address was
> accessed, not that the nearby PTEs will be used by the workload.
> Crediting all of those nearby PTEs as mmap hits can make sparse random
> access look like successful mmap readahead and keep mmap readahead
> enabled for longer than intended.
> 
> Second, a fault that misses in the page cache can start synchronous mmap
> readahead, drop the mmap_lock, and return VM_FAULT_RETRY.  The retry may
> then find the folio that this same fault pulled into the page cache.  If
> filemap_map_pages() credits that retry as a hit, the same miss can
> immediately cancel its own mmap_miss increase.
> 
> Only credit one mmap hit when filemap_map_pages() actually maps the
> faulting address.  Also skip the credit on FAULT_FLAG_TRIED retries.
> Keep the existing workingset behavior: recently refaulted folios still
> do not reduce mmap_miss.
> 
> Current evidence comes from a local KVM/data-disk microbenchmark using
> mmap_miss_probe.  In an 8 GiB guest with 2 vCPUs, a 20 GiB file,
> 8192 KiB read_ahead_kb, cold page cache before each run, and 1% of the
> file accessed, the median of 3 runs changed as follows.  This is file
> cache capacity pressure from the file being larger than guest memory; no
> separate memory hog was used.
> 
> mmap_miss_probe is a small userspace benchmark used only for these
> measurements.  It mmap()s a prepared file with MADV_NORMAL and then
> touches one byte at selected base-page offsets; the access order is
> random, sequential, or a fixed page stride.  The harness drops caches
> before each run and samples /proc/vmstat around that access loop.
> 
> Each case used a fresh temporary qcow2 data disk, seen by the guest as
> /dev/vda, formatted as ext4 and mounted at /mnt/mmap-matrix.
> 
> Each before/after entry is "pgpgin GiB / elapsed seconds".  "pgpgin GiB"
> is the delta of the guest /proc/vmstat pgpgin counter, converted from
> KiB to GiB; I use it as an approximate block input counter, not as
> resident memory or exact application IO.  "Elapsed seconds" is the
> wall-clock runtime of the whole mmap_miss_probe access pass, not
> per-access latency.
> 
>         workload       before              after
>         random         223.377 GiB/101.293s 1.010 GiB/4.790s
>         stride1021     204.214 GiB/97.557s 204.208 GiB/108.086s
>         stride2053     409.584 GiB/193.700s 0.970 GiB/3.685s
>         stride4099     406.452 GiB/134.241s 0.975 GiB/3.499s
>         sequential       0.212 GiB/0.050s   0.212 GiB/0.057s
> 
> The same 8 GiB guest with a 4 GiB file, so the file fits in memory,
> showed the same direction for sparse random access without file-cache
> reclaim pressure:
> 
>         workload       before             after
>         random         3.987 GiB/1.960s   0.980 GiB/1.221s
>         stride1021     4.002 GiB/1.838s   4.002 GiB/1.851s
>         stride2053     3.991 GiB/1.835s   0.811 GiB/0.985s
>         stride4099     4.001 GiB/1.836s   0.819 GiB/1.037s
>         sequential     0.056 GiB/0.013s   0.056 GiB/0.018s
> 
> This RFC does not claim to solve every sparse pattern.  In particular,
> the stride1021 rows above are intentionally included: the 20 GiB run is
> still about 204 GiB of pgpgin.
> 
> In the table, strideN means that the benchmark advances by N base pages
> between mmap loads.  Thus stride1021 is 1021 * 4 KiB = 4084 KiB.  With
> 8192 KiB read_ahead_kb, file->f_ra.ra_pages is 2048 base pages, and
> synchronous mmap read-around uses a 2048-page window centered around the
> fault, i.e. roughly [index - 1024, index + 1023].  A stride1021 access
> therefore lands inside the previous read-around window.  About every
> other access can be a real faulting-address page-cache hit, and the
> other half can each read about 8 MiB.  For about 52k accesses in the
> 20 GiB/1% run, half of them times 8 MiB is about 205 GiB, which matches
> the observed 204 GiB.  This first version keeps the scope intentionally
> limited to mmap_miss hit accounting.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>

Thanks for the patch! I agree with the changes in the logic. In fact I was
proposing something very similar some time ago [1] but it wasn't fixing the
problem reported back then and I never got to checking whether there are
some other workloads that would benefit. So kudos to you doing that. Some
comments to implementation:

1) These are two separate logical changes - handling of filemap_map_pages()
and handling of FAULT_FLAG_TRIED. Please create two separate patches for
them.

2) After changing the mmap_miss logic in filemap_map_pages() there's no
need for the odd propagation of mmap_miss variable to
filemap_map_order0_folio() and filemap_map_folio_range(). Now you are
guaranteed to need to update mmap_miss at by at most 1. So I think you
should just drop mmap_miss argument, check return value of
filemap_map_order0_folio() / filemap_map_folio_range() in
filemap_map_pages() and based on it just update file->f_ra.mmap_miss if
appropriate. Much simpler.

[1] https://lore.kernel.org/all/20240201173130.frpaqpy7iyzias5j@quack3/

								Honza

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c1..463cd19c49f09 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3757,6 +3757,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  	unsigned int count = 0;
>  	pte_t *old_ptep = vmf->pte;
>  	unsigned long addr0;
> +	bool fault_mapped = false;
>  
>  	/*
>  	 * Map the large folio fully where possible:
> @@ -3780,16 +3781,6 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  		if (PageHWPoison(page + count))
>  			goto skip;
>  
> -		/*
> -		 * If there are too many folios that are recently evicted
> -		 * in a file, they will probably continue to be evicted.
> -		 * In such situation, read-ahead is only a waste of IO.
> -		 * Don't decrease mmap_miss in this scenario to make sure
> -		 * we can stop read-ahead.
> -		 */
> -		if (!folio_test_workingset(folio))
> -			(*mmap_miss)++;
> -
>  		/*
>  		 * NOTE: If there're PTE markers, we'll leave them to be
>  		 * handled in the specific fault path, and it'll prohibit the
> @@ -3806,8 +3797,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  			*rss += count;
>  			folio_ref_add(folio, count - ref_from_caller);
>  			ref_from_caller = 0;
> -			if (in_range(vmf->address, addr, count * PAGE_SIZE))
> +			if (in_range(vmf->address, addr, count * PAGE_SIZE)) {
>  				ret = VM_FAULT_NOPAGE;
> +				fault_mapped = true;
> +			}
>  		}
>  
>  		count++;
> @@ -3822,8 +3815,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  		*rss += count;
>  		folio_ref_add(folio, count - ref_from_caller);
>  		ref_from_caller = 0;
> -		if (in_range(vmf->address, addr, count * PAGE_SIZE))
> +		if (in_range(vmf->address, addr, count * PAGE_SIZE)) {
>  			ret = VM_FAULT_NOPAGE;
> +			fault_mapped = true;
> +		}
>  	}
>  
>  	vmf->pte = old_ptep;
> @@ -3831,6 +3826,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  		/* Locked folios cannot get truncated. */
>  		folio_ref_dec(folio);
>  
> +	if (fault_mapped && !(vmf->flags & FAULT_FLAG_TRIED) &&
> +	    !folio_test_workingset(folio))
> +		(*mmap_miss)++;
> +
>  	return ret;
>  }
>  
> @@ -3844,10 +3843,6 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  	if (PageHWPoison(page))
>  		goto out;
>  
> -	/* See comment of filemap_map_folio_range() */
> -	if (!folio_test_workingset(folio))
> -		(*mmap_miss)++;
> -
>  	/*
>  	 * NOTE: If there're PTE markers, we'll leave them to be
>  	 * handled in the specific fault path, and it'll prohibit
> @@ -3856,8 +3851,12 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  	if (!pte_none(ptep_get(vmf->pte)))
>  		goto out;
>  
> -	if (vmf->address == addr)
> +	if (vmf->address == addr) {
>  		ret = VM_FAULT_NOPAGE;
> +		if (!(vmf->flags & FAULT_FLAG_TRIED) &&
> +		    !folio_test_workingset(folio))
> +			(*mmap_miss)++;
> +	}
>  
>  	set_pte_range(vmf, folio, page, 1, addr);
>  	(*rss)++;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


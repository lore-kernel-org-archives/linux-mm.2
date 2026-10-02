Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0511BCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E626B009E; Fri,  2 Oct 2026 10:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF9D6B009F; Fri,  2 Oct 2026 10:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21BF6B00A0; Fri,  2 Oct 2026 10:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C845E6B009E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:24:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69D80A76FE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:24:22 +0000 (UTC)
X-FDA: 85277906364.09.429196C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6118B120003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:24:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0+VEU8jS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t9txnZW9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZncI0ZHD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+fQGFDT3;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790951060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9nWLyt2r9hby9CPMFpc04BYUPpRYn+tUbcNwqB8KBw=;
	b=Jo5Ex5LL+LXnq6sqX5BKl3ALFLia5L5iNct/womwedCxHUkfGic6LZN0c6B0u3NXOXiQh3
	QE3Sdg44WAqXEFzJfDpwQ2S2gdli+tlcPTwlDADDw6ixcFKIncs17XS1PNQHD37neJuo5N
	ReFVB1pawQ7WwAhwrar4LkqgWb5jUVI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0+VEU8jS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t9txnZW9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZncI0ZHD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+fQGFDT3;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790951060;
	b=FJvksfqrdJJX1nwyx+XNe52+/h2d8elkfVXbGt4bsYJdKDHBip/bvjHAPpD7bUO5gRMSQl
	tnNCWA7Xnoa8MvPkpukuzZg+tyChC1K9bofjku184MFOFn17VKazouqV3TlnaSceRiDxQE
	cW7NfyhHQpAM6Jv14px7VIO1Tfb+HB0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A391721E30;
	Fri,  2 Oct 2026 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790951054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9nWLyt2r9hby9CPMFpc04BYUPpRYn+tUbcNwqB8KBw=;
	b=0+VEU8jSmyjNeYNEiuQzuUWs+Xor+pWJ7/9lIa11Y/3iA3Yeb68ijV3BrbJqJwBIVHXL/e
	5fATdWHS3VLJh6Z82EVwuaqerNpXQtCHq9Zt6lytxulPY2F/PMzZZBfnNlnr5i5ox3vWWD
	usy1Egflh4+3QKzSu1z8e6sqRBM0a6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790951054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9nWLyt2r9hby9CPMFpc04BYUPpRYn+tUbcNwqB8KBw=;
	b=t9txnZW97H1P+0WE3mw++Fn5Md9J3eG8aDo9pMF1UbgGD6vU9fDmPe1Wuf4tQugYXI9h3A
	wFwmVJo4I3vsi0CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790951050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9nWLyt2r9hby9CPMFpc04BYUPpRYn+tUbcNwqB8KBw=;
	b=ZncI0ZHDiUMhRI+MvCpHAZutzKEYk4L4tWV1IrBnq2tzvGYTtxgYQ9JnKWq8no8WwSavCZ
	+HWc5kIsj6MTY0/SxuYIP/cl9crT9hqf9fbL3HbAmS7US/F2LPx7T8f7XLK0YUrgDhcwKx
	v1eza+sO1TN8IL3QmZ5AVDyHv6JRhWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790951050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9nWLyt2r9hby9CPMFpc04BYUPpRYn+tUbcNwqB8KBw=;
	b=+fQGFDT3l6yI58R8SW1Uh0jqxyqqrk/+0fThT58vWcwrmquhurU8wX/hRBTmYrHvPukCjK
	FWGt/RJ6JVNu4zCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80A52139A3;
	Fri,  2 Oct 2026 14:24:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GKeuE4m+v2oeOwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 02 Oct 2026 14:24:09 +0000
Date: Fri, 2 Oct 2026 15:24:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Pan Deng <pan.deng@intel.com>
Subject: Re: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <ar-9z-Ls26elb5JI@pedro-suse.tail5790ac.ts.net>
References: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6118B120003
X-Rspam-User: 
X-Stat-Signature: ahx1h7a9mg3m4f7d4p7c8qmqxe56gbqo
X-HE-Tag: 1790951060-713215
X-HE-Meta: U2FsdGVkX1/JhQ+ysgdS0D8mLaDFN4Fg8si5Tao/Qx9+KLRgyrRXf+12x1kmjMmMA5XHOdXHg6uSVUb8BLeAOISSBytFDTGiXmdEKkJyJXJZ3zSxi1YDXr3d3gxIOWZAVAO8v2ILMa7OnmPmZQ7TnCzGZqhPticXb+bGgVmV6bUgje9FvK76nIavizbpNrWx3fCYbwn7Sf+8RPo8zchphA/8XkQeDBUztSIJ9d5+Yg7GDEnzV3UVfYji/6qeolivArEOaXZlgItUayH+aliH+yHwWbCJOucVqHnrpnC1svKpSUvz9lX0JK8rpfvo77PWqE8yXPag0tz8Vvqz9px1a9Az09E9rKrS2CvOAcb79xC9bABdIUwsJTuGFlup/QWijJF1+FyiXpKlPn8aGaT7YAeFWm0niBNE331BYkIMjvMIxrdTYUKstodJfGAD97TqNnQPRE86wBO12qw3pQ6hgBTYT7YZHdeIhQriIk+bpEEBMkdOeWqOWhByZsmZNjUrtWh2DQjTwJRyiY/8y2YcFMeQMTNNh3yCjj8vC8K+DvPvOVjNT3+wcs61lb+NS6BH70bRJJLyrv4fqMGdZFrLVKWvR3DYBp7DmNghv//m+8BrVn+/Z2OFzvZMM+m3d25xc0JheVXX5wSUILirVo/E1wbvHRTOdjcduHvp4d3/bxDj8Bl5yk8XfFYWJTqnrRuvySXcUN3Bx6kTnnhKy3GFSZoQNVh7IvBlFKYYbfPxnZHroI1V21jXpTpHND53SpxOL5DLZZa39AVXdYnRHwyCQoQjItzERmJ3AqsJeKVPwM02gC4F49kwEGdZKflQEI18MgDHu+oQGvsvUENRVcL5qZPh12U/vEXDwGOuNNHFcXjT0DI+NplpMmhu0rPX+ZfZ/y1EdO8uRgrx5NVwefxwdXCC+cTombq4adUD5CXtHDYaGf/wHeaFrhpbFv97+GLoxM7shN2AkSS1e5TWCwS
 FvaKjS3C
 M3nl7NhoYDDNhed5ng5qv2YPl/rznbnznEOi+iJFYpMHQPBSte0yquysaKC6ucVBT5hSD9k417Pkao2l0+ZV2CDHWRgezgxBVZodVSsNOYYDC2G4PNFKC36eUdezacvStDDQ2aK2Atwb0WqbBCVji7HJlpI25F8egP1f+mDNDdzibAWCJWbKWffiOq6qk153BiUqEV0zzI5gkrhIAQ9FFQpvTKqYVPA/+rLXP6XTxrg3OEceswYIz37XExSYXe3M8CgHmc20D6mV5Ye3qj90eHd7M8QSGem13s9SyZhw3rJ64zynOQNJNHdNYruJkubtoH137VqbWyrx3r67OHuqrdleGUfJ2/Fsu2nG1S+w7hVaAjTCFNrVt+8ZdPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 06:53:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> When updating a VMA, vma_prepare() unconditionally removes it from its rmap
> interval trees under the rmap lock, and vma_complete() reinserts it before
> releasing the lock.
> 
> This is wholly unnecessary if its page offset (file rmap) or anonymous page
> offset (anon rmap) is unchanged.
> 
> So, track whether they will change in the newly introduced
> vp->file_pgoff_unchanged and vp->anon_pgoff_unchanged fields, and use them
> to determine whether to remove the VMA or not.
> 
> The rmap lock keeps things safe as no rmap walks can concurrently occur
> during the operation.
> 
> Additionally, some architectures (arm, parisc, nios2, csky) have dcache
> flush rmap walkers which take only flush_dcache_mmap_lock(), which is
> likewise held across the operation.
> 
> If the VMA remains in the tree, it's necessary to keep the augmented
> rb_subtree_last field updated to reflect its changed range.
> 
> Provide mapping_rmap_tree_[pre, post]_update() and
> anon_rmap_tree_[pre, post]_update_vma() (replacing the existing logic in
> the anonymous case) to handle both the changed and unchanged cases.
> 
> For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
> is also updated when propagating in place.
> 
> When performing a VMA shrink or a split where the VMA is the lower one, the
> page offset cannot change, so set the flags unconditionally in these cases.
> 
> When merging VMAs the page offset is unchanged only in some cases, so
> update init_multi_vma_prep() to set the flags only if the page offsets
> remain the same.
> 
> Finally, while we're here, also update expand_upwards() similarly.
> 
> These changes ultimately result in less rmap lock contention.
> 
> Pan Deng reported results using the UnixBench/excel benchmark on a 2-socket
> 192 core, 384 thread x86-64 system for v7.3-rc4 with/without the patch
> applied:
> 
> Execl Throughput, index score:
> 
>                     avg    %stdev      min        max
>   v7.3-rc4        3511.5     0.44%    3494.5    3543.4
>   + patch         4069.0     0.48%    4047.4    4109.5 (+15.9%)
> 
> Average wait on file rmap lock in ms, 5 runs per kernel:
> 
>                avg      %stdev     min       max
>   v7.3-rc4    9.470     2.91%     9.070     9.820
>   + patch     8.420     3.34%     8.100     8.770 (-11.1%)
> 
> Profiling data obtained during the operation highlighted the file rmap lock
> as the primary source of contention.
> 
> Suggested-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Looks great, thanks!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

<snip>

> index 077e23694143..ad6be42cc65a 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -201,8 +201,15 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
>  	if (vp->file)
>  		vp->mapping = vma->vm_file->f_mapping;
>  
> -	if (vmg && vmg->skip_vma_uprobe)
> +	if (!vmg)
> +		return;
> +
> +	if (vmg->skip_vma_uprobe)
>  		vp->skip_vma_uprobe = true;
> +	if (vma_start_pgoff(vma) == vmg_start_pgoff(vmg))
> +		vp->file_pgoff_unchanged = true;
> +	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
> +		vp->anon_pgoff_unchanged = true;

FWIW I kinda would've liked to abstract this out to rmap code, but a quick look
shows that it is likely to become a header dependency hell if put in rmap.h. Could
perhaps have been separated out to a function call.

Anyway, your call :) This version already hides most of the ugly to
interval tree code.
 

-- 
Pedro


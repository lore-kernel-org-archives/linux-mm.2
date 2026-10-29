Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2C4606A339
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALOVMv66
Received: by kanga.kvack.org (Postfix)
	id 3E6866B05C9; Thu, 29 Oct 2026 16:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371536B05CB; Thu, 29 Oct 2026 16:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239526B05D3; Thu, 29 Oct 2026 16:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3FA16B05C9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:51:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96EB81404FF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:51:21 +0000 (UTC)
X-FDA: 85376859162.13.68B3BE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8331C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:51:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALOVMv66;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793307080;
	b=Frhi7PZtPwSOr/Rfg5f4YxTsx3ya+fjYO4ZDVkird4HLNgzGy7GkgrJ3KWt85GIRI3AXIu
	Y9xAnkgVykbg7K4mk98oJDt8DG1wdLys3nX1QJ1Y4fWrNILCilMI5IzV7YjnneDPZ6Q0Tp
	jBWtlD4mFXu5WgJ6BPEIALcUtOt938Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALOVMv66;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793307079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/QeBdycFBmMW/5BeoBbGqWDGKRCZXC7X2wditQIHQE=;
	b=OVvbprTwK1aSP/rcgn+wJpe70blAdWeOv/Are/3wOLMS/lSm1KexBob3p/RyGpxru4d7Ld
	sWJNA1+KrSl2IwLevVAGWqLLH9WJOmLY7H5luDudxfHcW2Nkb6skLQp9FMQM7xuTsz02kN
	UDvItoOJh5qJeamp2nEJKHVNP76M8No=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E9DB600C8;
	Thu, 29 Oct 2026 20:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBF31F01816;
	Thu, 29 Oct 2026 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307079;
	bh=M/QeBdycFBmMW/5BeoBbGqWDGKRCZXC7X2wditQIHQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ALOVMv660GDEhsdxOlSAlq0oNCfopkpdQ3k/WmJpMIyPVijk3Jd9X0dAtInQlI1yi
	 LjluZmI3Fdv29QPt9V1ar8P5gNPZEMNchqKup0F37+PtYfeF5/5mGYdX8Gkpun6cz7
	 z8ttoaIzCFw9v7JWmxadjnQ/vWs3qqCJLXGbgB4xrKo85yEFlIawGednHbNq5gKfIq
	 /pGQEqd4AFYLzSWHQ4C5Wt3a6YqJArVR7YGqKW1xRNPsXDeZ9D5NtVIKUpixXDV20E
	 +IO5TsJo3i9+tJipwYMsQZZIKD4G9pktMXucs5K7JzitxSaw8HPm7N/nM1r4Df+HMB
	 Xn2qLpOqf2Fkw==
Date: Thu, 29 Oct 2026 20:51:17 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, Vitaly Vul <vitaly.vul@partner.samsung.com>, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <auOrt2Cfq92heZQk@thinkstation>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
 <atJBK6hWYh2AqXwK@thinkstation>
 <de86277d-ed7e-4208-a3c2-6d26a8278d0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de86277d-ed7e-4208-a3c2-6d26a8278d0c@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E8331C0009
X-Stat-Signature: kk7ixpxgirhopo8gycqswburqmtaa91f
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793307079-945301
X-HE-Meta: U2FsdGVkX1/iTSiwIB6CYpdUcYZiculsTlJaiOpaDwokxqb9MVBPBse2Pd6N6iudgYiHL9ZNnUPrgQMKII1T4WalqmArSuwt3igL+4g8abiEEpvVkqqJDn/tLE3j1QTLeZePHCrP7cTpHnSajYcPxjMXYNN2R4579qMSWC3FlQJAAsLbBdE5rP6OHBf68tSz8BDuBZittkNEZkvCGLjF9vVvzt1L0NP6ZKQSRvArw9dNFq8Kp5gZzDUO8d9pdDwHHJ4m7+m8DilJGVGaRN6zW9HMFLvbM6zdpdggOXJij6ySLszni9OoLJLNkaYod1GQ4sPuhW7Y2hAiidUPGKT9VrCBHPLC8Wu9qYuYLuakKIZM0Dez0QOfOu+JtRzi9PDPGn+zcEJ+mD9Euj99aS0ap/fJwqwS9IxP8ajcW1LfZqVtQqyA6L5kHFTbnT/y1quU9nLqlIgzUdGQATyXWLSYg+X6RK/CgorWd29TROaXdLvMl62htmKBZ01dYqW7xAySpVOFk76kTfTsxfXILd3Ve32LmdWpBdjWu6YLf5qb6pYmfDLYxWhFPROpfyecOi9gCFHyP6BUsQMyXpu3nQJGtp9BbfdVUTdZL3F7LLr49KWSJbqTWQ20r3v2yTHthztErTjdEE1Nri0GHy+WAZMf/W4h9E2reMuD9/Qjjr4AD/EVF1rKESdVsTSW+j4ebET3XYqzhIJ3iAjZhYvMVMafE6uKNaI1pC3RZ0/aerdDtriT0FLjxxKyuQt/K7DhnJ7N1IH56+j7Cm+dBEwWYR77rrv+AihvXZ6xcA0+dCpKLBjrQrtPbOC8XV72GYq/5KHILfXVfD5GEsnAkP+AicpOKIGnCFdUY8FFZNB6ixvn7xG1cOB1jX4kDPn2dKDux1A738dmVLb+NFrYcts+VbaZqtCqGa+GMJoPjhAH5v5z9k6HYWDALe5Ye8d793w7H8oOXwlZcG/2J++5pS3xS82
 AoiSWYe9
 FKcILKt6QVuO69fObRodESfQvnvJ9dKPTjE01y79WZDImN5VFHRI7+chImv6ntxvIRG6hcJCKJEg7WPrfaqPRW4PUAlZP7t+qBNQuPIQyMwjNfIvrLGOwWJTlwJo7Y1CjBKGUMVAz+aSn7oKHvOxtaYc6cY9XuPHNsp+2GBTgyFaSEfQ4eBda5pOJMCVn5t2NkAz8/eeh8bU/iiHk1gl1bjLvz4sNsmGN1yb4SycEJ5gg0nUOY2bpfubxpql/gs01FPdwWSTNcMyhjYhAFAuZwEapMXt/n/gb0AkaKXb14GjPoFHe1R92wDGtmHtg5aXygFWYPBIfIX3F9cLC38PrRzXuSdg1dM+osuCat0d+9t7CuDQw8qyG2lnN3+ZgFH5/qG5vfUtbcjUJ/fJ96z5PZfa6iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I refined the commit message a bit per Vlastimil's feedback...

On Tue, Oct 20, 2026 at 10:42:53AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/16/26 17:46, Harry Yoo wrote:
> >> ---
> >>
> >>  mm/mempool.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/mempool.c b/mm/mempool.c
> >> index cb74e718b2c6..95533e2975ce 100644
> >> --- a/mm/mempool.c
> >> +++ b/mm/mempool.c
> >> @@ -378,7 +378,9 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
> >>  			pool->free(element, pool->pool_data);
> >>  			spin_lock_irqsave(&pool->lock, flags);
> >>  		}
> >> -		pool->min_nr = new_min_nr;
> >> +		/* Raced, the array may now be smaller than new_min_nr */
> >> +		if (new_min_nr <= pool->min_nr)
> 
> There could be just '<' ?
> The outer if uses <= but the == case only leads to an early goto out_unlock.

However I didn't adjust this. the end result:
> mempool: fix min_nr exceeding the elements array after concurrent resizes
> 
> When mempool_resize() shrinks a pool, it releases and re-acquires
> pool->lock for every pool->free() call until the pool holds no more
> than new_min_nr elements, and then updates pool->min_nr to new_min_nr.
> 
> The shrink path has stored new_min_nr unconditionally since a historical
> commit 6892188b54d4 ("[PATCH] Re: [patch] change mempool to not alter
> managed elements"). However, unconditionally updating pool->min_nr is
> incorrect when a concurrent mempool_resize() has shrunk the pool size
> below new_min_nr.
> 
> Re-check new_min_nr against pool->min_nr under the lock and update
> pool->min_nr only if new_min_nr is not larger than pool->min_nr.
> 
> This was discovered by formal verification of mm/mempool.c against the
> kernel binary. While reproducing it in the kernel has not been
> successful, in a userspace implementation of mempool, ASAN was able to
> detect a heap buffer overflow.
> 
> In theory, an in-tree caller can hit this: fs/smb/client resizes the
> global cifs_req_poolp from cifs_demultiplex_thread() (grow, when a TCP
> session is created) and from clean_demultiplex_info() (shrink, when one
> goes away). The two are coordinated only through the atomic
> tcpSesAllocCount, so mounts and unmounts racing on one client run the
> resizes above concurrently; pool->free is kmem_cache_free() there and
> the window is a preemption inside it.  The other callers
> (block/blk-zoned.c, drivers/s390/scsi/zfcp_erp.c) serialise their
> resizes.

[+Cc folks in COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
 as the paragraph above mentions it. ]

> Assisted-by: LLM
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Here I'm bit hesitant to add Cc: stable for a 24-years-old theoretical
race that hasn't been reproduced in the kernel. But it would be easy
to backport if anybody complains.

> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=6892188b54d484098b79b0c9813c20e543124e2d
> Link: https://patch.msgid.link/20261016132510.789715-1-nickolai@csail.mit.edu
> [ harry@kernel.org: refine changelog per Vlastimil's comment ]
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

This will be queued to slab/for-next-fixes soon.

Thanks!

-- 
Cheers,
Harry / Hyeonggon


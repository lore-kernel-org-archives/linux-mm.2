Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69981606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WCj9b7r5
Received: by kanga.kvack.org (Postfix)
	id 93A816B02C5; Thu, 22 Oct 2026 05:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED7F6B02C6; Thu, 22 Oct 2026 05:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8029D6B02CD; Thu, 22 Oct 2026 05:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 586ED6B02C5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:57:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59996A8392
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:57:07 +0000 (UTC)
X-FDA: 85349808894.30.3DDD654
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74495C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:57:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WCj9b7r5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNDduFV50mDAnusTfhsrm1AfLUFfYS9m3CckSvA24Lw=;
	b=jPUhmD7SYxIgxATIOyNxSxn1q0OzajHHN+HANRQ+iHjPu1PovceUSgF+aEA9wAiOel4+fB
	D37PSghVoitBJpitXfhjiAD8M9N2m0oQDhy9s8k6qHtsG9dSlyCaWBzR6oj2p/EeiMVcth
	y0914QKJrhsMAS9GSE0Zk6yO2kMzXlo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WCj9b7r5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663025;
	b=MRWd0xN7ZCZ57SDlE3OQ+o1CZbtEAz+rYOXUL36WbgmV91O4JhItNqdDALqR7UQjjLCHKC
	Hik0zv4XboLwN57Uf7AXIjJ3jigKbNkj4yih9XzwZGrLspzrgkATsoM8+5KjZWnqs2F+kB
	Q7C3o+1PdED8Es7MlpzYyIIBlT2UT9A=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac847f9d78so266456a91.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792663024; x=1793267824; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BNDduFV50mDAnusTfhsrm1AfLUFfYS9m3CckSvA24Lw=;
        b=WCj9b7r5OTjnkMA6/kfiOQbFN5W15eIFXb68rBBdyH/RtjLyZQLyCNpoCPPW8SgzlS
         RFNJ+EFqitW/58Kuww63ilLHQgXp7U9OyQU/5fugtfOpI/P0y4sPPzJaADS1za69HSsQ
         nZandkJwD7PM3zIlOxkNEPAcAXYjseCDj+BtboZ2TMDpXl5B5Wj4yuqz4EoSRB3tXKUN
         V3Wrt3EDiG+JqwlwtYlstFh8+EQd6yph74fB3KjncW2n91ST6IWU+S6GURKdSrM4mWG/
         msNJMrl6rl7efSPaVH4U9p5mqAPMKpzddhEBIAR9VxKYE0041XR6mrKqNlapzZgOQY1Z
         MmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792663024; x=1793267824;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BNDduFV50mDAnusTfhsrm1AfLUFfYS9m3CckSvA24Lw=;
        b=owk7/erVApVB+3SNpsZVGUim2dcK+pDbE4LPEydxkgJfoT9DdLkw0R5cvihpLzVpAE
         k6c5QTa7hkfELe9DepLuO0ccjq1bgQ+Bd4dKPzs6UPQksWBe9njzUIyXPOn1vwHnJYxZ
         HapoROdaSlp89DoaF4m//hlaK1oiCCVkTpgc2no24gh15krqrjttGQwhKGNVawHd8SIk
         j8CDLqdhgX1G6OIjXRWHjK8QsmmQfCobZKR6szcBJTDkYiCA+NO1WK/WL+5XpXy1Oqr+
         wwSr/rYuPSbRfcQFWhXLvffOX0+6iMRm6/Pt0uPVl/0RL6n+G1cXv/uW0azhMfsWdp6j
         hf9w==
X-Forwarded-Encrypted: i=1; AKwUvBxAYlSoo5Qv4aQZxqpJ/2YhPEDr41O7RXh16JQ5wKC/FKi9JJAQpF1mvOt8h4xVB7vyx5pq52Kysw==@kvack.org
X-Gm-Message-State: AFq9FYLyPwt8YRy0RGWvWezbPNeUfrgupNR5l7rA5CJv4NxlojoOEkwj
	gfclLuUMFcrsAYVvlsrgJcJ0ulO7twV2ftpdluy2EcFbgcTe/YMduRos
X-Gm-Gg: AYBFou1QHK+9SGBbU8RgWKITN8FwpNU5fe8wxQNYEarqCT5JmSz9zTKsyxjjefNDvKb
	gFM3yT+/SVtsCvpplaFYUzkihiFQaoupsmkh2JCb+Vc5e+G9h6dW1sPniZd+P3jhgmKDw+qR3A8
	zdf/9gvLO9vERCYhMOXq/v9A1s5Sy8NzmbjdhKuM3exEXiAOyDqDtR8jKXKjcEmxRD4LyLOhhoi
	ZUeaTcy5S0McpEw/iai08TRjhMneUGV/3ERb7rl9OekMd/BHheIhBCEoFpCHj5JdPyOQJe8cj3s
	pnpYjDN+1ntmFV5JRU8LNINqRxH5G1DTZswir0S+nKNTW0hkI1q60Ktkk/D0m1LtRwGROG3Fk0G
	YUNjn3COi/j8wnsPIMeyLB6VzMaBUZxJcoNGjcpFO5vyOAD7sHHoKWM0LDRMnvqMlIseIbKn9Pc
	viq5a8V1FKsANd5n3Uz+aMj4a5RDLTOuTHrwEqSjMr46gMmLLdcLPk3SlOMopMcQkeamvaY/4pV
	yXncfwNGl7zexdmJGWe2OQt2J2QSZuROdVd3XZI697gZY5/4NzrkNmwP2/QYipwhUe/HPx/MUs9
	PgGDVjGruklMlA8joQ==
X-Received: by 2002:a17:90b:4c52:b0:3a4:c895:570 with SMTP id 98e67ed59e1d1-3ad86eec0acmr6462563a91.4.1792663024062;
        Thu, 22 Oct 2026 02:57:04 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4896c71sm3742644a91.6.2026.10.22.02.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:57:03 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vma: avoid broken uffd merge on mremap
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, shaos <shawnq1@163.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
References: <20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org>
Date: Thu, 22 Oct 2026 17:56:51 +0800
Message-Id: <179266301162.763593.1501773594946042790.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 74495C0009
X-Stat-Signature: 5xhzmcg3xrpciqu8zbopjhifbg95wfd1
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792663025-819265
X-HE-Meta: U2FsdGVkX1+iUG8/6pY6A4vlDW8pl32CoCZ8qHo65XuYRQ9LSc9n8TaPVaUj0xND4MnKGz636ThDj4h2pgkC+N9emsPnwcHa4VP0UD88rEFShnOXhuSHADMZm/GOUHmik5v5DFV0hNB7KGET+Blba8b96jdn3WzxsWPDvE9618FrEjnAKpdBeYZH4YvZHFsgSdih+b8lQCqYO+hGX4y+Qqjte6a5ZWyDusTpZ6ZAXgs5uNdTn/X1+vn0yb95MY8wTYAkSxKHnzSML9fFAsrkqmjruV6tVq6JLHRndJuGTMMZm1p9V3Up39a29Zl7XKW+qk8gFDCR81KVjHj+0MxWDMswi1u9zUvG4WqL5IPHFyL13DtP/Yi3249RD6z+4ZLLpxlBvwlIQHaUl4r6+7UbCyUE2BwFOv4h42JTkc9zvJR7l4jxjw2EV5//HIrkR1u2AXXYyoEPkpIAm4HTKfS/6s97306RXjPJpslIoHIndA/XUa48stul+DYwLHFOdtlvXDKtx6vWncuaicr4rEMXE2C9VkV95sGAWxI2v7/KvTXUDqSXQozu8y3krc7gljSCRLKlWbggxiwccAz6wgwjPGfjjLUgCQgsj+iUBqB4mmSGDSA7+O23dMKYAQ0uoKi5wgsBxXgLmUCX0dhChQXP3UNTr9FcoQ+BBVtFHEuC4y1MGybhsKAARmBsrWYJa2end4UQOqK/S1EaKxZPJe9OOWd5agcOHqD+bXIGvyuL2FmHSeJsdfT76Ri3ePIds9L3x8H+mxFnA/aEvr49zj6KOTDr/evpVyIwV6In2NLDeAJwweuLPiQOtQjBFzfUu4kJIlLufzFh22d7HN/wfXJggPZu1WLlNCCuGZ77kw92C/z+sS2FOEILWRsNShldG1op5aN/U4Qe+WMQhpiqNH6+WF3qRf2sPJVgqRNg1oQcut5ytnGYMuJp67TbojCn/oDIeTxyHE+uclLWXE0h51L
 nDzotn6u
 gs9L0YdGUFipwTD6dYszE17C17P8NSu8jgYyh+UXVR4TbRIY5ryUt6GqbNRzZYMbuxzfuFr7MAD1vfAMX3nFLsacD+YyjY+E/sAIddvU99v/YGi+/SHX58QiuTw0JvRGYhMH8YTJXLtQ9arw0Pc8TjtUNVDSXiMvc2Nb7oCT2UonRfeKtnP+Zozb0yzfQ/BkNFSzJShJjTofsUs/N/66mbGYL6gVusnRxU6050NydfyE0RFihnQJyIM8gJ/xEAEgdvFp7Y+xtJhcarsJ6b/3rLZkUdnXdAufE/nFIP0Q+StrPq7BrcSlNWpdUpBwwaVNyqHAqw3e4H3iL2OSeoAEBLg7KbBD74qt/iM0ILSX/JTaBTDKnNLyyddOr5jPvPwpVIYVRF+HeEbdnee6vdzR5s2UXDSdfefal0r78o3ap67YzyhcHn7dZgYS2OBAipfCwnO1T2GYVtAh0l8OgW20jLlvZuQ5zpkMDAF4CUwhrCDP57bGpcD3kJfATKItGM8dqZqCE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Userfaultfd often causes unexpected interactions within mm, and does so at
> the intersection of uffd, mremap() and VMA merging.
> 
> When an mremap of a VMA occurs, copy_vma_and_data() calls
> mremap_userfaultfd_prep() to notify uffd of this.
> 
> However, mremap_userfaultfd_prep() simply drops the UFFD context for the
> VMA if the user did not register it for remap, i.e. didn't specify the
> UFFD_FEATURE_EVENT_REMAP flag.
> 
> This is OK for the VMA itself, as upon page table move, move_ptes() clears
> UFFD page table flags, using vma_has_uffd_without_event_remap() to
> determine whether to do so.
> 
> However, this doesn't account for merging with adjacent VMAs, whose page
> tables won't have received this treatment, and thus latent UFFD markers
> will be left around.
> 
> Worse, it'll break UFFD for any VMAs it is merged with. This is very
> surprising behaviour for a user, who will then simply not receive UFFD
> events for VMAs they ought to.
> 
> Resolve the issue by explicitly checking for this case via
> vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
> function explicitly designated for mremap() operations.
> 
> Also update the userland VMA tests accordingly.
> 
> Reported-by: shaos <shawnq1@163.com>
> Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
> Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c                          | 5 +++++
>  tools/testing/vma/include/stubs.h | 5 +++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index b7dec22d0928..4d605c0967d6 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1211,6 +1211,11 @@ static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vm
>  
>  	vmg->copied_from = vmg->middle;
>  	vmg->middle = NULL;
> +
> +	/* If not registered for remap, uffd context will be cleared. */
> +	if (vma_has_uffd_without_event_remap(vmg->copied_from))
> +		return NULL;
> +

Hi Lorenzo,

Preventing the merge here keeps the later UFFD context reset confined
to the moved range, preserving the unmoved neighbor's UFFD registration.

>  	return vma_merge_new_range(vmg);
>  }
>  
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index be8f5161f92a..f786a585caf0 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -386,6 +386,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  	return true;
>  }
>  
> +static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> +{
> +	return false;
> +}
> +

Would it make sense to have the stub in tools/testing/vma/include/stubs.h
return a configurable bool, e.g. uffd_without_event_remap, and add a test
for the true case? The existing tests would continue to cover the false case.

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Thanks,
Xueyuan

-- 
Xueyuan Chen <xueyuan.chen21@gmail.com>


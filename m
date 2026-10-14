Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF9DCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C826C6B0088; Wed, 14 Oct 2026 12:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33836B008A; Wed, 14 Oct 2026 12:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22506B008C; Wed, 14 Oct 2026 12:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 872F66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:43:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 247DA1A0665
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:43:54 +0000 (UTC)
X-FDA: 85321803588.22.1A8F596
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5AA298000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:43:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7rdmmvN;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791996232;
	b=1NdkmDGVPyahxpuEWzL3xIRFQVyyw1hKtVp+gjjmMz7LHEvwqVrvUGMvL/9qsICdta9QQH
	4RMksyA9BR9Ra+t2ihizHktMs8L3rqxrlxAOt1gCew7JTlU6OCq8MKZ5q2kBZ2tXp12urJ
	xSn59mWvfqaZPZe5pGJgRzubi3AbQtc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7rdmmvN;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791996232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMpqIpjk0oH8Hp+oTEjeUG/Kp3ExxsukdF4YXrCzIVQ=;
	b=zlCpaIDcq//hBmiN84aKN80LvWpJBseMjATGBlA8iZK1fMjSeQfjjAf49DV2544i1o121S
	RaQFxp/y2zqxAwzPcmg9Vn80W38sARU4bvtzADBHL+coTFJj8atGkOKRH7tkPae0nk4CGX
	smPdPRLjj4RYwoJ8o0LNxLYBEjNNjrA=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-46556b9e02cso3199553fac.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791996231; x=1792601031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tMpqIpjk0oH8Hp+oTEjeUG/Kp3ExxsukdF4YXrCzIVQ=;
        b=H7rdmmvNapqaOWsFdutXVzYtVA1nkpwqpWnmC2gMPmmeDDyBHpHv8I1d1AtsS4Y7Bt
         h3Z3VddJcdqOv9FQDnC2dkOoTKf2Hr03YPTnZjD3fb/oaUNCPwyI7AG5RWjAqz2v1Rl+
         /XWcy+lxcmlz2VFOH2X/i5TmdmDn8hFh79N9GpU65Fz/s0tPi5F9BXlMm3tfS8u+WArN
         MJKGXe99LpFWzYVN0945Wg3ZIJL4umNnXTsoswyOPhMD+9ZfS4REAJWc+KLZog39IGW7
         UA5RF7JINFoIj7wpPqVNFEftGk41tWc9gxrfJsXX/AtGBHtWM/LVW0kN/4K8wpuD4PPX
         IcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791996231; x=1792601031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMpqIpjk0oH8Hp+oTEjeUG/Kp3ExxsukdF4YXrCzIVQ=;
        b=dbUdXDIkmY1cOYPo4mkuBPtkT7qYP2IkXSsU3N+dfov9NwQyeyDsKGvad6ugKKBns6
         N6X3s4MruqzQqRpOUsLcgaZvkXcysj+u0MxIuRqIDvGupNupM2sIPNlL+g7Y/Hja76/T
         PjxrUmdr7izvNcHYFlp7uPeQvrKNOHvey50KoffHvLz+PiFVQifi2bNMOqImY2TgvikL
         V25E7NLYEMff5/3E4dUzLAq1cIRdnOQdBt0286ZWn7iGc76YNAjEmNU0EppuxtWvzx0R
         TsKP3sosDptjPa+DCuCy9+rAZpOYCGNfao45sF5IhCNrmqLlCBu4E/SjBUcMP7Y1bp/G
         23Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxV1uNtN2XXNwx7KMuabo46sdLtqKyFT5+9x8KcF+T8LyJTlWPWpzp0MjsQiRh+6xSLyGX8mmayrA==@kvack.org
X-Gm-Message-State: AFq9FYKYe/I49gKRzDXxXDdx6LgO4Vw7MnIx16wfGbcvzQ25Z0Dy1CVs
	XeUWNaclBt1aaP3ZQk3Jf4ZSC2NTbXU7z/LSSVwet62vOAUMQ9DDC0+u
X-Gm-Gg: AYBFou2pJgSVgkfp2Voj7KSICru6Pz7AFaPCcMPNWqELz1dHQp/oRf4pjZ8ch9c32pY
	68p+lF4JiQj2wBGZ7T2lFEFvgxjQ3jgj98K27lSuqKkfNPb0ibdvAJrvJnA3ZJXW5eHDoldTbMv
	souFt/JTuDSLvI9IPhsL3ypoZ50ZJMFMNjW/80rCNE5hAZhSzz6Vjzdz87lcW5QIPUfEzkjEInF
	gWQp77RxQnbzxgPdcHNCqLwpEuNHN+NbjlO0w0VXlTbKObL8Ctv+dngap5QzatiosAeTZ7bFkem
	SUVwroh9gfBoyZFScUS45qDtvKlBcIJZFB1bJ78BndTN5cM1WnAG6MDN/Pc3VMBnRVCZefEmAw0
	+lPX1WNVu4PEDEE4n0p3CoXostkMWhWrcoxevcL45N0ohK/4q4TRZ4cJ1PeCjMi6Ab7Ft6lcxrI
	zC1QPt86WbHdvEgGtIMByeWwtjb7BpsDlp55i0uigN+Xh5tSjTroNSUrgz5MipbpSuIvCvSreqh
	8k6Mc4Cv48vsBc613Gl6A60gvqn
X-Received: by 2002:a05:6870:d14f:b0:48f:e0f6:bfef with SMTP id 586e51a60fabf-4a2a8b0ce81mr11201261fac.27.1791996231164;
        Wed, 14 Oct 2026 09:43:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a6dfcabc34sm2256325fac.15.2026.10.14.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:43:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: account full object size for percpu memory allocations
Date: Wed, 14 Oct 2026 09:43:48 -0700
Message-ID: <20261014164349.2332145-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5AA298000C
X-Stat-Signature: 8s1jd7f48f87nfsgu3tp456q9da96c4b
X-HE-Tag: 1791996232-666618
X-HE-Meta: U2FsdGVkX19roJGUfe6xnK1sjwzesCRYBLv25EmMM/d7IGSPdi3bdN8yYSEeuwhvr0i/sRmRGJbV7hum91H5CDWXNq/8G1zvReS6Qdx5k9ovGEzm+hXVDsj4/qBrRNfBdmg5znS4qqQKYu4mcu05NRARiJh65hv+/RM6MzM7kdwxCaUkTWpQfZB69KjtbJ5X3RMkINTcqeA68waArrw4HEbg+YYgaezRib6MN4NtQ0k3ur7yJ4pDRc3Do3HAKCi1qBgv6ajK3mQfAjYMc5NX1WwdUVj3L1Ehojot/xgZgNWjtmGxLBmpNmBE0WbnpFtjRZ7TssovEpj3h3tm9HQbwZdf0Wm49tO+MNN/RdX4sQbaj7jsCA7BIInzE/z2Pq9H/QYb50JpvxI2BRswlFSKTatK5wj/3i3mMwra6Wfu/ey4uej2hhS424QeF7iUQgsNdqnlf3NpQDXxhhCOUxFrjKx2FLG16jdz1gH4lUdhcMxBJ7sm+TELtD81YHuwF5P5rKEjfUzJHpozvyadvKAiwuAemrtoSqUbVTu95OPr0pTVlY+Z+B0sT6EwNyBg3vcNRHcrBDsCEEqZmgnM8wLn+YyEcYbJYf16N/aZkC/sK7QNKryZ197abqkJuybjcrh5olR/ingJT0IfO+mJkS8rcLQyC/wW+ZphFgvwdm0daqMSyWLnSUdspevAD9Q/jtgg0c9ONEyRMGl2KRGhv47SVepISM2a+pQSbqMt7LeZmWLmzb7UzAeHmhHTRMeiE1OjFlvAuYGq97bYZHIzP0VN/Tp/rd/ldcUdPghHGjHvHOHDR2LTSheNPVOd62yy7FeIDFZAFeW4/B+eR6+Rmc8GwiUv9kaWQUU0VveEsKB90hTeIq3LllNLpUz8jxit4hvp/QGV1k5aw0GMOXHOGeK+0p6PJ37bO8K0IJPU0Oz/E0zzL4asy0kBBwmdBKyM1tDtf0u2OmmWn/v83lIVh+1
 nSHyXjye
 5aa1P0poJ5XstyIMnduW+bBWcEQpstSsx1pN39IIacBeZBwHvYhEWudJsB5h/1Xbj4neZebSvgfCJGxu9w6GuohMwQ8L4BlYV8noy13M/1fkgDiRZt4fjqJ5pamSjaYQ2pn3VwU6U6njmNtn9l3jSrYzGfmfbCShXiyIUtDp2Qlea0Wm20gR9/zvGARtVMt+KyHFgMfRoaPzgMZBZhyUa27wyybIHA1cLKbDrY+7hNLN4LgSkH/0zhDXG/whCjWYM/ZqKXl9ivsWn8mTYzyGtNDB7CYKSHTt3MKN0iCgVJLehvL9ZQdWE1EiyPWwlu4Zsk+0hxQsvin/pix9IIdPSb1AapN2pp6HBIjuhjl2y7NSIhQwgEgR1cM+5dXgmmjama3p0AdYMq4AHu+dALAYoIlSOYQRd2x1XypzeU5TtUtSYymy+4VsPCbQub6qjTdTZILR4CKm/zFm6xELPf7UAmngId937wxLPkHSm25jAakhh6sMLE5l8Ljyydr3vJrGUTg2NiiNqrnwYA1Jx8KYWrl3ROQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 20:34:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:

> When memory allocation profiling is enabled, the pages backing percpu
> memory chunks are attributed to func:pcpu_alloc_pages. However, the
> accounting of individual percpu memory allocations via alloc_percpu()
> and friends record only the size of a single object rather than its
> full size across all CPUs.
> 
> As a result, it is often not straightforward to identify which kernel
> code is actually responsible for percpu memory, because the size is
> under-accounted by a factor of num_possible_cpus().
> 
> Account full object size with pcpu_obj_full_size(size) instead, which
> multiplies the object size by num_possible_cpus() and adds the objcg
> pointer overhead. This is consistent with what memcg already does for
> charging percpu allocations.

Hi Harry,

This looks quite good to me. Thanks for finding this!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Some comments below that shouldn't be blocking:

> Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
> measuring mm_init()'s rss_stat counters.
> 
> Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:
> 
>                   bytes   calls   per allocation
>     unpatched      6320     395         16
>     patched      418176     396       1056
> 
> 'percpu' field in memory.stat: 422400 (1056 bytes per process)
> 
> Memory allocation profiling now accounts the same amount of memory as
> what memcg charges.
> 
> Cc: stable@vger.kernel.org
> Fixes: 60fa4a9e2323 ("mm: percpu: add codetag reference into pcpuobj_ext")
> Assisted-by: LLM # Verification
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
>  mm/percpu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3eff382e565a..d7883507dc15 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1696,14 +1696,15 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
>  {
>  	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
>  		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
> -			      current->alloc_tag, size);
> +			      current->alloc_tag, pcpu_obj_full_size(size));
>  	}
>  }

So @size by itself isn't used, so I was looking to see if we could just
pass pcpu_obj_full_size(size) to the function instead. Looking at the
call site, pcpu_memcg_post_alloc_hook() also has the same oddity where
pcpu_obj_full_size(size) is used for all calcualtions.

So I'm wondering if we can send a follow up to just unify all of these
and pass pcpu_obj_full_size(size) where the caller never uses @size
by itself, I think it would also help in demonstrating the intent to
account the full size. Same idea for the free hook below as well,
paired with pcpu_memcg_free_hook().

Happy to follow up on that myself too : -)

Anyways, the change looks good. Just wanted to bring this up as a
follow-up cleanup patch.

Have a great day Harry!

>  static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
>  {
>  	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
> -		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
> +		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
> +			      pcpu_obj_full_size(size));
>  }
>  #else
>  static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
> 
> ---
> base-commit: 0e199ae6e803e76ebf128e009d336e5917221e63
> change-id: 20261013-fix-alloc-percpu-accounting-48bf24919caf
> 
> Best regards,
> --  
> Cheers,
> Harry / Hyeonggon


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3D2FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47236B0088; Mon,  9 Mar 2026 23:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D224F6B0089; Mon,  9 Mar 2026 23:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AE56B008A; Mon,  9 Mar 2026 23:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFFC46B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:40:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E3B0C09B3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:40:15 +0000 (UTC)
X-FDA: 84528750390.03.D6E1411
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 611821C0008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:40:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bnMQHuMK;
	spf=pass (imf21.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773114013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
	b=i2g8Vz4lL3t+d4pVdtPnxvsjcO+kP7xGIGthDdioef7gF37XWK7374e6ciha1pA5xEAElJ
	PL8BHKB1gnQDItk4pEex1g+ECdZNPoS5YAuEIV33YpPgFQ4CdODo2OEDg1kZ51GUJ6Z3Rq
	q1+vzEtA2emQxEFsbW1XqOBVsE3rPgE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773114013; a=rsa-sha256;
	cv=pass;
	b=QLZv8r4i6QW8+UsuM7/bxtTQSoqWzYWsefAf6PrYJ3IJYaWfEbaOZGsuV2AIeemJ5vblKZ
	IdE0p9V1+aX0KWhkmskUCqq505U9BP/94MZMilzNLQ/3YuDyHRyEpuSbeCgTaeGklBVov3
	t8tBdxp7JSV42xcC1bNDKrNpHf9xcAo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bnMQHuMK;
	spf=pass (imf21.hostedemail.com: domain of shicenci@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c739d32b72cso2408856a12.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773114012; cv=none;
        d=google.com; s=arc-20240605;
        b=MoHmDTE0WaG1wNx+hP0j9rFXZc6JFhAEgsrlWrHDp1De53k2cQTDNQQf+ZweB/PTfE
         uiNrb2A48CX8idej3eyfUVzI16OeXW/Jj3DTlWZeYk0R0otzVsmzt8uhYg4XWpCAozcn
         Nwp5nJJT2LoWCnlRpFHvrlilBiqndMp1dLoIR7/DJ91fMvhpOD3WF8Oebp5dmg8tjUw2
         jxQ76m9Bpec1udeN45h6jIl/qjW0KGhIO1kCwTAt0YaxlSLpI0qyq70czkChgQ+NBZmd
         sevADrz9pGBLs8KTJOPmOaAMADyOA5sPkSsR3jJN+ko9//zlsBZTu3M58nrXtVWlT9Lj
         49GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        fh=A7v3UZok3MWeVtSDL6A/ns8gJoA4ldLst8qqljDk0Ss=;
        b=d/02ZuZeLz/7genJ/2B7dsXCv1fyKm/EXYJ+13WJJus4etwjveR1dBZkFbi3wCtR6m
         ENtDQwCfwUcWnEtwRgjmCVNBzLdEuHJgQBG4ymp3Gh1mii+4XI+vcUJ7WgcfrsgH+PHx
         iKrgLNwCVgoSyaF1em2IvTVk5v9U0onXvW45H28dkv5Mv4oePLCjl1+xUjQoYx/GsFpl
         WfbE7VJQ91BJlE/ZrEKu2PctXi/M6kIL9Mrwxx9dtEcJosskg1Tj3dZzfcdsar848EHv
         Z5z7g5CDQirFFp7hPKqhwjLDsW6zBTCLXgnHOYXyP4Gc2aEskAinBQaOkQpMCvjcOHjS
         3gww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773114012; x=1773718812; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        b=bnMQHuMKmW4Qpp12xGe4i5QaY2OMKjrPoUkGhXom5CSK9KUMnxrc+Cq67Ngtz89s9Q
         njsj/atM+CVyPVm/vdVd7LLFQ0Gr3j46UBBwNUD0jP52+WUmDOBL53cA+zCfMQVwq4Jk
         dvzeeCXEdLA3f1DrRGIsBOEB1eRcWDHZ6zSn32oWGhCEq2doopyH9+ADPKR0Ai8/P+ho
         8YLO3nO88srlYlGKoPbmB+iV0KpBKLIaNrRgZZtPDWYzGedjw1iRPC7TxyNzi5JhbiTR
         aXtfkv1AUpxyx4kTO54xhMZ5w4n+rDXPduAzxXieS4imexjmBTqmIxaN4Z5MsFl8CHqV
         MkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773114012; x=1773718812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        b=JPLlb3fidzgp7dfFox6dbhJxQQZ7NmJ7mW+wCCvblxzMnFW4Vfo++k00ly7+lu+NUZ
         KF78e+feLwD/sgFj68BA4zCGGF5ZnOAYpKPrVBDtkgisMQ8fxfxvK+x+dX/yfvj8Z/vd
         XZgoYEyjm+89hn82cZ59q2+AIptg3xxQdowzO+9GuaKnBAWmww66EnHy1Ak76W4+8PU2
         TB8QmNmX2Mk21y7cw1+dt5LXUQvzfTQ431cBguHyJAO+gveqihI/zcx8xufagk9IVgsX
         4uiuXAKtQAFcKq16Y0d+x6W6K+0K+lFD87B2wN7TVeAsNG7/7JqrVYrIwgEK15YRWKQh
         nE7g==
X-Forwarded-Encrypted: i=1; AJvYcCXiDqA7l/ynl/5lu+ttVwpI3584jWCGxzOSk+aWwQbzRQgJbOExh9BZCCUCOdgPkjO2xDoEGS8Ksw==@kvack.org
X-Gm-Message-State: AOJu0Yyt75EtUxxG9Pf/2cacKR7kehMLSieIysAK8+ulP9lZ0iSvLHV+
	7/iUbi7ba/4uZXx5jT4y5vjlz+OjurZNO/gGzzbR3Re5DHDr3Rh0qea86HTfxGH0Fd3eD6PIl7i
	x0itiojuXxDoqDVCi2KWjoH+5X0fo90U=
X-Gm-Gg: ATEYQzwYDSQjGezm2sThdj9rz9FWvWDXEDBORledeeP5yXv84EU9cB76/lA8mLSCAcJ
	tw7GXhHYh2gu7nqhel4GzkScfU7h2fLyTo6tuxLqON5ovimvRMLpdIxOfNhjGjdLEtSld7Ht/xd
	lceNGCGqBotAFryUWBnlUj4wsvqac/UnacaYxTd1Ra+HiQW+pLhTyQy812Nm6raGV5FfDYuH5HZ
	KrOgPaCt2UgiqLsEQbslR/E+0jHsfXAfFcVa4ecFitE2HvXGuuCVKr139cXv2xf29mKI6+Su4rR
	cME0aEg=
X-Received: by 2002:a05:6a21:9ccb:b0:395:291b:f555 with SMTP id
 adf61e73a8af0-398590ebdaamr11794026637.69.1773114012045; Mon, 09 Mar 2026
 20:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <aa5NmA25QsFDMhof@hyeyoo> <20260309072219.22653-1-harry.yoo@oracle.com>
In-Reply-To: <20260309072219.22653-1-harry.yoo@oracle.com>
From: Zw Tang <shicenci@gmail.com>
Date: Tue, 10 Mar 2026 11:40:00 +0800
X-Gm-Features: AaiRm51P9s3DC7FjytFC4I2paYZUeQw-qAwJyjCHl-40jBVff_9Gjy4xmE9iqAQ
Message-ID: <CAPHJ_VLzRECge4=L5RRqZyf-Sou8APi=Sc=d0brBAMdj3UC_Cw@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: fix an incorrect check in obj_exts_alloc_size()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, hannes@cmpxchg.org, hao.li@linux.dev, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@kernel.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	viro@zeniv.linux.org.uk, surenb@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 611821C0008
X-Stat-Signature: i93w85aoeybuamph3t8w41tzqesyyr75
X-HE-Tag: 1773114013-573473
X-HE-Meta: U2FsdGVkX196eq+m8ZM3/LN/AjM/qNbaP6k3M5DMe16VY3v0y1JjIqLPbDYUvP6rWEfLcnqGWbLkB7gkUdu9hIP2Z5nB7AUtEMo/5lo2vNe1InAmXFoY4g6JMsdYW/Q9d9KPtVNapbfMND6mXDwgEQyjXNGQcMbgZ9GDp4mCdoJq2OXdDny26NGffGAZ7pLl5pE9tsagva1BSgd4kbtVBdjwWTQpTvv4Og8B648+/Zf8fWF5b5m38LrShWGp0rQO0For9jaIPTVcPfA6UDGo4rUlFMfHGBRyzt5AgS3G3z0JFWKhEIRttxSelJ7ZQbGCLSpVitsvEoANqK+8S0pxUM0yTIHcllQHVOJMTYu2bYtF2N0u6NzKiYQjdOQqhttrJhQC7I6oOjqzmEvZOTaUUL4vOdhztt3g5nTQUbmUAO9o40TggSV5PrUDqZbZah1PLjiqGKZ/Sh2iUN8eN1DupW584w88ik3q5BcxgrRUP6c8WlQfSdPcPovwtFBkqc6MTMqQ5jNPWR6iJTGyIEbYWgpSb6537nqhaLD9N3MKsG6OHy6kcsdFqpdrKcq44tkfuJ7EU/okGiB7Ef/Qs+HrDfMgmmiDqBA7nmgWQGKFTSgZCVU3hDRtrrEMFG5JFs2jxCC8SyVBUKvFG+oNWlCz1YQvBUz2UvkGcTWzro0Nva9mwpTTvg4lC/IWsKp488XbFCyuZNrNJ8KWsJhsf0yoexPYgI0fNSQ/B6JBlXWPwCuPCC0Uu7giajVXfu73rNDG/Dlz/RRHjlkU1D29B2wnc1jUHGnE1ZM/CjLuxbjHntukVUzBQl2LcR06QGOsjfVi3F1EvfvDTZFsqvCFqb83vFxcmEhU838BusID5tqwkH4ZLDZ7O673yL/oD9Fti91nvhK82HfWQzYaTgBamXAMiYq9dsBPa0dDiuSERzyrv9x6eJsTY/7mSEYjdjRjq+BDVDQrwbDVbEn/DKJj/ry
 e4BC5Jw9
 IVHD/Lk7pZDpMCJSL8qgNWLepDmGbkF3aqYUhHeJyDsW2BkOrjQO8GlQBqYVSpmJnyX+eY3Wj1XJVUOGOFP4T3yH+8IhBt1ZxaidiGLdX/pSdCWekXNGKyaMPseYJ6NlwWroPBGTNnuvgQ1kvGuNqqVi+BFzB5EIBBjtIs4qctVcq4/fgNrYyQlsbm/CN4CYRCqxibDhUjhcL3CXXr8mvYdotOQ3BjHdtsx9KX26d16jSbf2NqD1WbImaAapQptRG3DKfnNsSa4ajGPQ3IomKu8SmDlykDsBaQu7zG0Goyu+TPpBEZyc+yL145el+4Eq+RXYZFJM8Y4IR5eQ0KD8b46WzdCk93ADhjqC7oIyKtMzCV9dO103qW10J/89xpLMZ5x609xa/n6aAUGNS2jxJC3xhydhmBCiG7x2ITTDBSYx5ST4XBX/dZSC8S43KuW7GkI2p6O68jgwHVNNLKi/9SbZf2yXEvu/547JHjGMdSDxFaxV+3p8vR6+xgnEsdYFCcuAOCMCMynGVkJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

Thanks for the patch.

I tested it on my environment with the original syzkaller reproducer,
and the warning no longer reproduces after applying the patch.

Kernel version tested: v7.0-rc2

Tested-by: Zw Tang shicenci@gmail.com

Best regards,
Zw Tang

Harry Yoo <harry.yoo@oracle.com> =E4=BA=8E2026=E5=B9=B43=E6=9C=889=E6=97=A5=
=E5=91=A8=E4=B8=80 15:22=E5=86=99=E9=81=93=EF=BC=9A
>
> obj_exts_alloc_size() prevents recursive allocation of slabobj_ext
> array from the same cache, to avoid creating slabs that are never freed.
>
> There is one mistake that returns the original size when memory
> allocation profiling is disabled. The assumption was that
> memcg-triggered slabobj_ext allocation is always served from
> KMALLOC_CGROUP type. But this is wrong [1]: when the caller specifies
> both __GFP_RECLAIMABLE and __GFP_ACCOUNT with SLUB_TINY enabled, the
> allocation is served from normal kmalloc. This is because kmalloc_type()
> prioritizes __GFP_RECLAIMABLE over __GFP_ACCOUNT, and SLUB_TINY aliases
> KMALLOC_RECLAIM with KMALLOC_NORMAL.
>
> As a result, the recursion guard is bypassed and the problematic slabs
> can be created. Fix this by removing the mem_alloc_profiling_enabled()
> check entirely. The remaining is_kmalloc_normal() check is still
> sufficient to detect whether the cache is of KMALLOC_NORMAL type and
> avoid bumping the size if it's not.
>
> Without SLUB_TINY, no functional change intended.
> With SLUB_TINY, allocations with __GFP_ACCOUNT|__GFP_RECLAIMABLE
> now allocate a larger array if the sizes equal.
>
> Reported-by: Zw Tang <shicenci@gmail.com>
> Fixes: 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from it=
s own slab")
> Closes: https://lore.kernel.org/linux-mm/CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C=
0gFxC6xGOG0ZLHgPmnA@mail.gmail.com [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
> Zw Tang, could you please confirm that the warning disappears
> on your test environment, with this patch applied?
>
>  mm/slub.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..6371838d2352 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2119,13 +2119,6 @@ static inline size_t obj_exts_alloc_size(struct km=
em_cache *s,
>         size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
>         struct kmem_cache *obj_exts_cache;
>
> -       /*
> -        * slabobj_ext array for KMALLOC_CGROUP allocations
> -        * are served from KMALLOC_NORMAL caches.
> -        */
> -       if (!mem_alloc_profiling_enabled())
> -               return sz;
> -
>         if (sz > KMALLOC_MAX_CACHE_SIZE)
>                 return sz;
>
>
> base-commit: 6432f15c818cb30eec7c4ca378ecdebd9796f741
> --
> 2.43.0
>


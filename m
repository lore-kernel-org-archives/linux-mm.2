Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEDC606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EUubEDut
Received: by kanga.kvack.org (Postfix)
	id CFB686B0AD2; Thu, 22 Oct 2026 23:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD35A6B0AD4; Thu, 22 Oct 2026 23:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4106B0AD5; Thu, 22 Oct 2026 23:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889FB6B0AD2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:30:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B2718011B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:30:49 +0000 (UTC)
X-FDA: 85352464218.07.66CD2DF
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 63EA41C0009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:30:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUubEDut;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIGi8MMXWRGMe2b3LNjOQAhNFelVBzD0TDA4w15AaDU=;
	b=2RE4CPjXUxpwk7lA1JVaXUUkO05zI18BAvYpuQkMQtc1txT8qTaLxugDpMXUr9kchIMD+3
	MFeaxzBKen8JQjxcpLr08FfEWXXzjjlv7wppAlPSuUBHKn66X/zSnBmqQPxdlB70e57ZvZ
	YeSIUjFkmbsY+ESQvC64IQ2EP70IqMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726247;
	b=ADGAQa7HjH0jfmPziKRLrxyZDFhizt+n43L4Gs3Db4XMAn0CEORXknkXQ7QZjHhQjWUvuJ
	Ut1mCWgQPVltbky2yTIb9aGv/rkIo+iH5I52q7APEpUR99sPLAbFCnAggJOUkMT70FN/pb
	4VlnEE5HFbi605KD0Ed6ToZItpVZqbg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EUubEDut;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4a6f1a4cb8cso6887fac.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792726246; x=1793331046; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zIGi8MMXWRGMe2b3LNjOQAhNFelVBzD0TDA4w15AaDU=;
        b=EUubEDut9ZA9dlgGRUlQjRLKMadKch4OuVXoG1N+HiLjhSbwohXxBdDGLC9OCAFr3q
         Mw5NKg0x0nVIv8mxfqdWqbn0titrzlgwqB2KhPUd2QWyjGI1Y1w3ZX1m1LG/9R0MO9Ft
         skC4Hzt877MpJLmJwQ6/PALQvbYcjEGUaLdWKEqGkvQSLbgvqorTPUnf9vLyIf1k+gcw
         E8fyVLBQzqLOzOpbg3k1t1WKaipGdTjcNPVQ//cAD5TuVl9SGW38EYkbxkX3kon23ffS
         Pggzf/QMNRNYFKDr60mKpCJT8PTu4Ulu7QUsLSFon3qkeXElHbxA1odC1vCrnfXztlYA
         W/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792726246; x=1793331046;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zIGi8MMXWRGMe2b3LNjOQAhNFelVBzD0TDA4w15AaDU=;
        b=DDs4n4ml5q261cbt7r8DPUCxhUn9SoKeNYwTUBubXKXLAQ2EJuv4reniJ3AK6CJIGC
         g/oYmMqHi8JPmPenImgBwsw+orvImn0n493ielh9L0OtimdqMsawX3Y1kbMNZkFhTKmL
         mcbJzXZxpGQo2qkFv7Q714XS/nUUlGyWDAqkdPcuI7JLGus1CBNAwZR0jtxGqrRl3qol
         CcqMvfPR3uMWnc5wErV3gnWq4aokmS/Qj3LBhyjUXcP90AHQWwNFMz0eQ/AZZMi9Ng8/
         ac5s77spQtrLlABhcuvMXt6kTEkzeXFla7036j+S/ym5YlGfQpoICPK+4qMAm5I9h2p0
         07Qw==
X-Forwarded-Encrypted: i=1; AKwUvByCtjwfs4b7BirT+6/3EE6ZhNCcZ9UTVTjGtRqXA2DdWcBZ3v9majrs6O94MIlTlMnuF4Xud0T9IQ==@kvack.org
X-Gm-Message-State: AFq9FYKq+3tGpvvX+moaUENvZTrZXXcLbBm4AwD4Ml8TYVa0/jyhPym+
	gIpUvcQ+gK0w0sOdDxG30cYjCogDjg/7d79dH0lfd0UfKyk4o0S5oqm8
X-Gm-Gg: AYBFou2g0jiNmSAlTREDNvxZm7K86mSgKh5w3yg4zRHycgblrftU7i0utBYbkLcO+H9
	bgBr3QhNAXtRBrStalFXVS3mZ+FANCxq7tXqDgCpFJHESaFv/mw2hSjaV+qt7VDMNt1b1ysg7r9
	3Tc6PW4QdmzfJ/1WeAw+Fxz2CoDOaN1sPDGvrBlndeDKAr3+ia4gf2T9WPckWMbphW6Atk5/bHB
	ki7wDiwvlrUfBedtSa138Bpmm7ytjOx555J0nIGNK7J6eIKL1SwNCkLAP7g0n2d94MOYVCSrK6I
	SKz+gOBhDoCeHNVTZ3pX3TWR1OdmQXLtLdm71b+bzTvfk0UmHSrtJ6oJNHw7uFBiwabIvbFdWo1
	10JaXbbcF7Ll+rGm5hLdrOmOi8FXIMcolNF2xYd2N9heu87D84qvFQ53M3WU1xh1xvxIOwwQmIe
	QijN8ZbePj7E7uSnrRxAA3E7I7plefVVfblm/2xPvezhtTRTC9+aMhmsPIF9J76KglbqMNLYDXb
	mEmhKVMugrGTVpm454SwSMKbEHzY2EwXXpZAvqPISbmQBT5zkhpEcc+C9vJwWZ+ggvE3oaSfD8k
	se/XzYeuRVA7dVVa1Q==
X-Received: by 2002:a05:6870:e196:b0:4a7:235d:b346 with SMTP id 586e51a60fabf-4a821ef833amr776609fac.1.1792726246059;
        Thu, 22 Oct 2026 20:30:46 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a820ab47f9sm697893fac.13.2026.10.22.20.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 20:30:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mremap: populate calculated fields in vrm state
 correctly
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Nickolai Zeldovich <nickolai@csail.mit.edu>
In-Reply-To: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
References: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
Date: Fri, 23 Oct 2026 11:30:35 +0800
Message-Id: <179272623522.1002865.18403086831547127814.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63EA41C0009
X-Stat-Signature: wm9rtb4pmm4rn3jyk4bh67yjyz6zosg9
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792726247-656209
X-HE-Meta: U2FsdGVkX1//DdVZA6oktpgW1WRGx1aQsnux7TEjm+xJjy++jsGnw9WiQkJAE9dNDyh7MOYvzsZlyqv2t6jyouZNdSgwBfGsqUb8RPo4XZFY5oiZISMU/if7NTh1x6v52twwGHTO+PHeXnpfMxOIV9Xn/kwodtbAbWegRZiS5R8wBKQEkMv6TnCVH5UkB7CV44+mKmbdm+S71VM1tiVxIQxdfLkTUayn7tn/9ZZMMpmm4YIK4g7PqX3hv8c73/hRXUN1XMYPtnrnXlFR9hv21yOScTQUrr/yNt5occ+XFKhMw9TfZFBOcvWYbSzabOib2O2Xoq3clHtTbTT1WK1OGP1Hjkuqyw7AZCqhYZHZmU9B0az4PKAKNCe3XgXJDyCtOA2RdXOfjsgNiD1zWVlUSSSU70DGLeyGSyfGsaK6jlvrPUdcx+cSgTCWNCBYc4bpWyStulKWBSh7LSLXxv3rWZmvFnstr7MhPCXMl1B6O0sAYtSzAthaOVyQzyoJM1tTf9daFq+J4vwuGZnKM5zblEuvsvCOb2ffF9T2J/d1XwKqaoEj6ieRPuYn/EqphtuNCZuGZKJWwULh0S27vYL3bHDaJ8ByqF6XjYuRo0cnLVsZTPSbCRtZK5mZ/gCJwgeXKs7zBGcc4rBDvuNKSyMrL/nYCm6p34CCF15HVFxto/e+Ehk9oj1ECk5VdXL/ExgbwbYpElK3sUtGERt/S+xBTdNmgIZNKEjPVt2C7FRoXX9ecl6OTuYxMjGAuhZG4lpDR/3I+5ZG1nMP2AcNtPIMdZ4kOL7LydOk/x5tQ1b5tSug5EDUGgJKS+YmReq57wSyoXi+LSTC/+U2DANOAEBsxwEDpedvYGdjLJpq3H/Ys4rIGO1nTo8iVOF5U9zeu1aAVbohDuUvRj7z1TLEqvCJsSpcOs87nn1hBDvDsDe09/XYzUhL2u0ySOPymnivp4upboGuT44JBp43Ucq2a4L
 mymBL7wJ
 FUjhYkin7H3G5SeeNj1JJ5Ll/NSzeOLCA5SHloNjul2tE/oTGxxVy89grexw5WA6tZ0vbo1T3mAjoND4s46BAaZo4cXZ0dFtkV5jJNsyvZSAYtuBR/UMVNnd6LoLWnzzvMknVkIgHHkm+XIlBdV6kg3ItbhW23fWB9+liPdqhxjQhb+jmDzGJvTZag4pBPWeBumuxiKqrKx0rKLfWNC+sggJBVBT9tDanIJ0Qo+TknbBnor0GbnAsz8ETOy8ZFNISkDC7fUMPzSvgdDCwRgFW3lloIAZF289eSg0IL18Fa7DRyi27UAO/vJluR2Vf+EoHsemJwQ7wYofgNhLPm4eCi3IROWM2gi8DO5oKXmfNxYKeF9nyFsT4PuhggZqV0MarLX5KBgiDTqQL5cXc8msvym2HB89XBMK9aywU2Aof7TH8gZYCeqBmmWsWrbV/7KzCr3VW0r/rcovK1BPjLpGnAg/a7GRHgvQQBcwJu312cdH4tlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
> introduced the vma_remap_struct helper to pass state sanely through
> mremap() logic.
> 
> Part of this state is vrm->delta - equal to the absolute difference between
> vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
> respectively).
> 
> This value is used to correctly charge accounted VMAs.
> 
> When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
> having performed the shrink of the VMA first, prior to any potential
> move (e.g. MREMAP_FIXED | MREMAP_MAYMOVE specified).
> 
> However it does not recalculate vrm->delta, which results in incorrectly
> overcharging the VMA.
> 
> The charge leaks to Committed_AS globally, meaning a mischievous user can
> cause allocations to fail across the system in strict overcommit mode.
> 
> Resolve the issue by abstracting the update of vrm->delta to
> vrm_populate_calculated() and invoking this from mremap_to() when
> vrm->old_len is changed.
> 
> Additionally, update vrm->remap_type whose value depends on
> vrm->delta. The field is not read again after the shrink, but it is the
> logically correct thing to do and protects against future changes which
> break this.
> 
> Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
> Cc: stable@vger.kernel.org
> Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/mremap.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 2e1ee879f70f..3f645cdc8060 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -887,12 +887,6 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
>  	return pmc_progress(pmc);
>  }
>  
> -/* Set vrm->delta to the difference in VMA size specified by user. */
> -static void vrm_set_delta(struct vma_remap_struct *vrm)
> -{
> -	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
> -}
> -
>  /* Determine what kind of remap this is - shrink, expand or no resize at all. */
>  static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
>  {
> @@ -905,6 +899,13 @@ static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
>  	return MREMAP_EXPAND;
>  }
>  
> +/* Populate calculated fields. */
> +static void vrm_populate_calculated(struct vma_remap_struct *vrm)
> +{
> +	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
> +	vrm->remap_type = vrm_remap_type(vrm);
> +}

Hi Lorenzo,

Good idea to update remap_type for here too.

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

-- 
Thanks,
Xueyuan



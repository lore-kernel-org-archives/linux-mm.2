Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0A2FCC07C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 21:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99D86B0005; Fri,  6 Mar 2026 16:20:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47B96B0089; Fri,  6 Mar 2026 16:20:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28FB6B008A; Fri,  6 Mar 2026 16:20:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFAED6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:20:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 510961B86D7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:20:38 +0000 (UTC)
X-FDA: 84516907356.29.A35A8F7
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FE9614000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:20:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y7E5M/lO";
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772832036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xF2QVJKlsJyPQ0rinDSP7ff02KEvuEZ/pXqwJdII48=;
	b=J65syQu5YT8wdImjWjQzK2s3BgOCt7/9oDE/kbqRCriCiL0WoGXi3Co6fmBMwhL8rXGXoG
	qOENwflL0eByPxyhoC5Rd0ht+C8ZQOzjgWzM/1RqrQtCyXvTnYH8dFZk5pFCFIkrleYyJJ
	lkT9kbBbSMEmDielikmXeEmPu59l9YU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y7E5M/lO";
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772832036; a=rsa-sha256;
	cv=pass;
	b=nY50rZqryo3o2lUKta3pj9d4u2gBdatlCk9EACTdaHWnQXW5+UyuBnP+ikmXwGAmDKrnKh
	JeaDku0VgJfXTjjWqvkxO9V2uKPTJYusty0D73rgQIP2c0bsMtr1Z6OfT17SAIPhXVT09Z
	h9TTxxF/Sqk6zO7BWoVnKzyRc6gXUTo=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-505a1789a27so57880041cf.3
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 13:20:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772832036; cv=none;
        d=google.com; s=arc-20240605;
        b=L8Q5GJ+ywmpn1zeqL3CZhWxr7W3F9wOndiPTFqE2TzdvBOGPJ9z8l93Q0V7qadXfvU
         jk88FcOXPqd3CO5RwTYVu06/FEXmv3A95/dtlh8Dt0aBuOfaPA19MiqZ3XFC4dnHsj/c
         quZEHq/KQJCUuqFMNzWpFFoOCYxPJe+HJQWU0dq0ODwWMdLpaowQuBKPNUMhCOnlcx41
         1KQMBxabWnp2HXFC/VyiTlBLl3NMGC9bDyYXLSj/42JIIAKaObOOSQa+rFq/Wp3nyi33
         YGDBkvXobIzTMWb4+cmtOpRX0ES5L3eZBjtfCfbSXgaJZNKdOvGypjv4HeEMO1WvAzFd
         5mGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4xF2QVJKlsJyPQ0rinDSP7ff02KEvuEZ/pXqwJdII48=;
        fh=RWi1ukwHfVbt5d9McpmOTTng4N58WyfwEXWqNeK+EY0=;
        b=EE61IGXE1Wo23ptcPIoef2BEw/xLaOwFfVeeqH9dzOckCBLrgKoh8uchVzVPonFHGT
         bGMwKm8JcT4tG7wayMcgsX/jxkBHQleBWi5s/hwWMKlBHOdoMGiaj9abTMYLXJVtAVrk
         iLUkrYSwh/Gdi4hIVCPVqvILVYu6MHTYciEoYc10qVn2pX2bHp4c6NxUIe0ESxluJRmv
         Eu77WXKsEI774pcCl9s+qFIhLmX825xuUmYLQSzM9WSdZ3brMz5vRn06ez/tY3j98y8A
         L6OEpuny7FyVMO/jZ1iOQVIUGH3wgvZB1wLdKYFQDp9f6SLyTotcY42lH4nUx7krQCVI
         DpZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772832036; x=1773436836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xF2QVJKlsJyPQ0rinDSP7ff02KEvuEZ/pXqwJdII48=;
        b=Y7E5M/lOHK2B8MMOQs173LbEnAQ9gxWD9c0D57nvaQZy7kdsyAmNwqDH+jYbzmZajn
         9DKP/JE17NlhbpHBC8phF6Mv5lQ820+ZSm1DNU2MrX79xh5awCZQq5HuC5FtPNBpIOVx
         Z3cwdlWXIr0MafDeQGTh6/RgSBmW80KmULkwOal2AqLoOtNCmhgBrQniwLks+9Dl7yys
         qRl2lon15wqZRUKjz0q9LT8Ae6IJpDpctgb1Diq2Zr2OyjkZP0j8qTueOwRZ63G0feHM
         nG8h/HBHbq4hbFyLSpLOLqhrM1zsaaX6StQUC7RAtHuk4yXM4CZV8CcVosOvRppf3sGX
         1dKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772832036; x=1773436836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xF2QVJKlsJyPQ0rinDSP7ff02KEvuEZ/pXqwJdII48=;
        b=ilAonypUwT0CDSHqDNEFLYgmrYHE07B6bbzHw1W68BInwnZY2aW0QSTktxIgvYJh76
         CQnXKevaZFjRW7b+8xeSQkYAd23zNU/W31sHHJucT+yjWfCvfjoTy3NPbshqw0q+1PGO
         7aIyMtC7avYSeq1KdoB6C20GC+ResxYG+fuhKrtx+Cb2Tk2kNsHbcBzXkW+lICG9RNy3
         v7d0qkWKVb/2rFSdfBhy1KsYUVGORhV2TvLs83Ev1CWfX558z4xnH5+WlyHQqS1TsktU
         ZvcXCNlfLrxHjuktE7tzIfc8SxzN5MPzu+8HbKBbXIcG7N0fxRHx4ZSdQ2CXfKHd0xag
         anvw==
X-Forwarded-Encrypted: i=1; AJvYcCXpdy0xIziyKuiCRDgCQNBPsu0jtm/0rjrl/fDjRV3HrqYr9WK5u5UWTscqkE3CFUo2xZB+hUmS7Q==@kvack.org
X-Gm-Message-State: AOJu0YxIjV6O2sUX2QKPxwNQmqnHinKu7Oq8JwTTRXKBNd+Ss3gv54Gj
	TOqsicssktqfBBgNaE3v1PHTyIiKA7Cg2ilfZ+vXaZaJ30AYjB8IONcFC22izyNcJOXyGdyfImD
	31jZhAF0b6SkWtMonzfmPXIVDRv7JEvM=
X-Gm-Gg: ATEYQzy4ITimYZwEYZWWmP34603lJCgAUVyjQXq33HDoUqZvzubo6c09W/e6ZiBF6RM
	tcKusry5RUjOHTgzPATgf9Jzjw7e8RpHwbPKjy1AiCdpPNFJBr2d+O8ivd8c9ekJDhMVkdsumY4
	cbbK5UJU7aUOc6IpU3I5m98mVVAfamxpJbs341+XN35IPp9hVfiPBVoIX091Va4b253uvDjnAOV
	STYBvWtg6LvImZ6Z4osq1MJv+zP7fIY95EPZ9dY0lxXp237GINcJ+UFRIv5dWN4N1rek4meSZoA
	C7hK1A==
X-Received: by 2002:a05:622a:1923:b0:4ec:fdaa:b31e with SMTP id
 d75a77b69052e-508f49096camr42838931cf.32.1772832035179; Fri, 06 Mar 2026
 13:20:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com> <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 7 Mar 2026 05:20:23 +0800
X-Gm-Features: AaiRm50sO_fItcg8g6Y4AgDfWstLovjyaZSZQA5x11X8O-Ah4D4-J_DxFKLuC_I
Message-ID: <CAGsJ_4wA-bpCaY8uLnwmzDT40s4RbsOXdRutvj5bZU+Em6cFeg@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8FE9614000B
X-Stat-Signature: 8x1cmcftgbfp9sbmnkhsczqqquhdq7x6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772832036-584780
X-HE-Meta: U2FsdGVkX1/2w2LOrDbhjCPdeae6OvbovqYnfJvCpeVz1bo7HNeZ9epCpsfTxgdxZq9wKXxjqC2s4kwvj+ao5QBPnQwLOHOVbzIYDL8OYCLIai73KVOj32jVTqUfIbp1PweEr6Xd74wi/+H0lRCyvKWJdsqypo/VFRu/DsUBiQzFxqDs+VNbg/IdtQ2KnY0UwL2SKzWW4NffeCk15oe6p1syv3F7ldG8MXnSSXMo7H6yv++1Xab+X1JtGF5fa79fz8I2CJjmYuXC8SyeHxwxUVrgIk7xAmAZfSHF+A3uplykNezbl1bhA2DGtDou8F7GTMw8LmEcwx16JVaUHU8vPlKWRqCzCm++Kif9gMFOW583IBO5Pg5mBMcBvskR732mN1mIRIBDZSfJKSpnC+XlorWfCev2ACHbxPpep3KxOqLiTuGwBaIhBPCxA+DWrKm9RHyXK7qPi4KNCZbwfX1xwJxdkEIVb3B4AHODRTq9kP1kcnCtqfrpwjwzKnmRj3dJN45esLM1lMIT4f/PvaMBFiDwGIRnXG53UrLUYk0Sk1hRsxZ+rtK4UKNfG7TkKHLV+FHh0lyhAg12HgqvfUllfC7KKggj3Xxi1kZSM25L56NCT6WjlXu024zvr8qMJsZfoVnYNJV0lPyydmVUnx3HaWyyJeICrOVs2Gsyy+6tBUgqiqrbLTqSCmpWSDFhIZcBx58vQ7IblMzbDQk3RbmcKP3TSyoaMn8UhsAlimNLGjcnB9LqN9J00x1O/m3KVZxGX2F2Q7XLrtoLurtcYTFbm6143wfeVgmVqadvcLZev/cWN7b2CiZlfqfjRd3wZyKsb5x586Lyd76U6EOAMZ0pJ5/kDjmrN85ca6bONERMz3rBR/uTBECFK1vfQ7VDTscIwnvkUeGSbV6785LLr7HZI8vKpKw7CD3vjQyNZ29vLCvxTjNJIxUK4322DQJdP86E2z4jOdT0kWmWnBb11Yx
 5NquIfnw
 82cSowSRzOI5TxBOEimVonA3TaCSsTKdUJsZ+pwmjxTyZFlI+Z98miVtT/KVFOGRAQ1zm2MhbKkcijdMrCWWiqMFCp/mZ3HcP67C2Xqer3DaJRkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 10:07=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Implement the Arm64 architecture-specific clear_flush_young_ptes() to ena=
ble
> batched checking of young flags and TLB flushing, improving performance d=
uring
> large folio reclamation.
>
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and t=
ry to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can obs=
erve
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvem=
ent
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropp=
ed
> from approximately 35% to around 5%.
>
> W/o patchset:
> real    0m1.518s
> user    0m0.000s
> sys     0m1.518s
>
> W/ patchset:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 3dabf5ea17fa..a17eb8a76788 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm=
_area_struct *vma,
>         return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>  }
>
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +                                        unsigned long addr, pte_t *ptep,
> +                                        unsigned int nr)
> +{
> +       if (likely(nr =3D=3D 1 && !pte_cont(__ptep_get(ptep))))
> +               return __ptep_clear_flush_young(vma, addr, ptep);
> +
> +       return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> +}

A similar question arises here:

If nr =3D 4 for 16KB large folios and one of those entries is young,
we end up flushing the TLB for all 4 PTEs.

If all four entries are young, we win; if only one is young, it seems
we flush 3 redundant pages. but arm64 has TLB coalescing, so
maybe they are just one TLB?

> +
>  #define wrprotect_ptes wrprotect_ptes
>  static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>                                 unsigned long addr, pte_t *ptep, unsigned=
 int nr)
> --
> 2.47.3

Thanks
Barry


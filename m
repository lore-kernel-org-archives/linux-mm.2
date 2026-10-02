Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D96FCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC946B0092; Fri,  2 Oct 2026 10:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48CF26B0093; Fri,  2 Oct 2026 10:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4FF6B0095; Fri,  2 Oct 2026 10:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8D46B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:18:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84DA71A0742
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:18:08 +0000 (UTC)
X-FDA: 85277890656.29.F2E71F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8F5D5A0008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:18:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oappmKQy;
	spf=pass (imf15.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uOM3jWz9hTdESdoL/7PR8IoiwAtC5PATol6n9clR1w=;
	b=DTUhFurs7SiizKEg3tqRvprRkqKBXHUcdst6hbyEPsQPDBwgg0mlUIb2GXCDPb4GIWC+9M
	8axV3cbvw+x0yTU+CIscXiMdT0KWUBE3FZDIlmyYMgrlFsOxgwQNob3DWPxhddfvlEvjdR
	XQ56O51aVpwKhOpazFEnvEXMZjCelYk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oappmKQy;
	spf=pass (imf15.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950686;
	b=zLiSwpAA3A2Y/YjtAU+U1CjPP92lNMwG1rVM88aHWAVDdi3tGle233UMZAr+JfZiMETtOZ
	UvQGIvlM1wRDXPgSgsyPAWIJaEL82KyLBP6VISbFrlNmNuEjLVFXw46sXk3lZhXBzrCuFs
	PfIcc4r090jj/L4I7sqZs5VFq0iym2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DA1B447F3
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C9D1F00899
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950684;
	bh=0uOM3jWz9hTdESdoL/7PR8IoiwAtC5PATol6n9clR1w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oappmKQya7E9Zo7YvGbz225Wzyq9o2rw3IkqXrNEP986A+djebCRgzN1ysoUo49KR
	 Y3zwqRU23muhQZHXWWOUht7UDXXxDd97rIh5r0+f95SHYAGKsMQOS723ZGtMNlZ+hn
	 gPy9sQhFMULcctANzXMz394AQljzN89hPcRjnFBPJxGaKqtI7Q6qIImyjX1dP8qUdh
	 EeYxjSsVJWcgPp98mLiL0CzXPIlhCZdWBhTfAcLHiJeWFMIO/ma69M2wW+eBMQwxuj
	 4Rf5fU9EaLkITmAdsQNanXa9dv2jzoOIA4sq4JVVR142LtdxAZQVTbWVRYgBTJr/5z
	 MaKGZ0aqoUZ9Q==
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acb6b726b5so7258324a12.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 07:18:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz7HeZBBdwVmx/Yhx/QwlhAuk8XJomicJOEtAgYKEypZmi2xOsUGGClE10JoHwYtGeW7kudScixQw==@kvack.org
X-Gm-Message-State: AFq9FYJhf1i5+LAZBT4L64jQ4KY+xlRd9pUJF0YVISuhVJBebbvFrJMG
	DipFA2pYyRYkxXFVnyQZoW+v3YDS1X3bR3ckafJ5VYbspFs9sG+m/jc7oVXn2GXnZkdqfdSkv8v
	FRdv78Zz94gJr4W3YbndWrAsD884s0kc=
X-Received: by 2002:a05:6402:44d5:b0:6a9:ce42:e684 with SMTP id
 4fb4d7f45d1cf-6af9e022740mr1653386a12.4.1790950683375; Fri, 02 Oct 2026
 07:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20261002095503.3585565-1-usama.arif@linux.dev> <20261002095503.3585565-4-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-4-usama.arif@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 2 Oct 2026 22:17:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5yr0xqAUUKftz_RL-SCp02RdFB=aK0sP+uDDwXZPUmxA@mail.gmail.com>
X-Gm-Features: AclHuK_4yoHncqxrokiRpDq18m_ydAvkbPTMAsmKGSie1oxuSHyShV6peln57f8
Message-ID: <CAAhV-H5yr0xqAUUKftz_RL-SCp02RdFB=aK0sP+uDDwXZPUmxA@mail.gmail.com>
Subject: Re: [PATCH v8 03/30] loongarch: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, 
	qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F5D5A0008
X-Rspam-User: 
X-Stat-Signature: x5da8sau1cbk1yy1cfrgyyz4ura9ujif
X-HE-Tag: 1790950686-328199
X-HE-Meta: U2FsdGVkX191jj5zHjO9FWNFyL86vBOUD/sBtIjhhbduqnDWp5CA0vkuESORupkkn/WPcr0XfAYs3KyQEXxVKnWO5dEq1P6dt0VPaYghUirA5oTasf5K2fxLnueWp9sB69vObk2p+KODNJ+75GpNb8YHdIYn4uxS7rLab0tWYnMk0Zf7SnbN7frORxtYDNpxgKYqsx+KMns/4Ru5lAzBG4Cb/EOa2Gr/+ea4pD64168klwNYKgES+HWtVnl7jr2CTH3DndqsTFsRJ+8+4rF2NSWDfjkAZcXu8IzuE5nnTttyIRYotmKVlGA+rGE/AkihEKxDKeFqC0lDHERX/SXNvBhFNcQ9L2o5+EgBeT4n2b90zKdrLv9D4vAUJxNYKWfbRYjcCxTYCiHB6G6/yGgQABjnN9knEg/EK//DPpGMhvjNLxyK2ePmxJua+bMAQFsvV8TNblZLaLxCu2o/aS2OjKUL5QPW/UhLdj69RV+NEWPO03qec87WnFebB7bdqMmZEYAWaftb9q/5iRCzZvc1VivYfrDE6Pv63A/1eW/Vhx6FJrvbb1bbqK/131nEK2yHknKFmYNX6mt5usthvV9tjBNGHsddCBuJpMV2GJjHaYkKKcbSpkVcCbTsv8FWSPdVnJ2U1mqoeoBQeDcZyIw9yIwzrDT7Gdr3UVOy+oKzTwFVqiB8OMk/2BPSdvsGaXX2VS7wVKahfzRN/V23JuW7DlvVnH9zaJ7K/HBJwbTyaUywiw7koyYUenlLa4I2hSw/pXQKUN2m1eF58NaBjkqN8HZcZz4TfojLT06uEqCtn1Qg6ohTfBgNKNjiFcXnj+sp6lhIgUFPBXCmq0FVCnNJaUtNK0lxIyD6kj9U4d7xq7EwccwIzjbsH2bToh2jNuu6frMdEf5ogDxFQ4S1FZA7KjSUN9A/mFexnSPLRA220xSfIy93v4ZJuNrHQdoqDMZ8eGwcsvRJfyTm+lo/MmD
 teoxO1X4
 V11/LTpACOeqX6mH5Xzt9UvpY+iiGxFJquNQKoLUTs80SNO/VUkOAcBWL2Lq37/S/kniBHCMz/gr7MwaxrUb0M6Qt6kFmKscDn7jc4ehnKTwnVYSI+JIib4wS3g+9YXWNz8BZHgoFJFN+O/PrzoC8IsKU3o/V2wqjavKy+VOb79KGPlEts1CZptodubQ2XJEFkTu41LC36AwjdcjnBtu5qA4KDeVSvfKYmITLK1kribh6W95pSd5hYiKeKqfpmlRoXJX16KemW6S4Bps/51bhAXSK5mRQIM0qKBYUG+p/aQp2PoTWbhUPKuNgf/+TGoRewRzUhyXX39PouB9E/62X43qtYtwHyRnl74ckHTqf33jPHAHuJcrgkQDd9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Usama,

On Fri, Oct 2, 2026 at 5:55=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, which makes PG_anon_exclusive have to survive in a swap
> PMD and not just in a swap PTE.
>
> A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
> _PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so t=
he
> PMD helpers can use the same bit.
>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/loongarch/include/asm/pgtable.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/includ=
e/asm/pgtable.h
> index cf29a4c8ac593..87fecc3a51001 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -351,6 +351,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pt=
e)
>         return pte;
>  }
>
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +       pmd_val(pmd) |=3D _PAGE_SWP_EXCLUSIVE;
> +       return pmd;
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +       return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +       pmd_val(pmd) &=3D ~_PAGE_SWP_EXCLUSIVE;
> +       return pmd;
> +}
I think the order should be pmd_swp_exclusive, pmd_swp_mkexclusive and
pmd_swp_clear_exclusive. That looks more natural.

The riscv version is already like this, but others are not.


Huacai

> +#endif
> +
>  #define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
>  #define pte_present(pte)       (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PR=
OTNONE))
>  #define pte_no_exec(pte)       (pte_val(pte) & _PAGE_NO_EXEC)
> --
> 2.53.0-Meta
>


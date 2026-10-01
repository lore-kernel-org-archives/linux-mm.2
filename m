Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D1ACA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 07:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9826B0088; Thu,  1 Oct 2026 03:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27AAC6B008A; Thu,  1 Oct 2026 03:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A286B008C; Thu,  1 Oct 2026 03:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D67806B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 03:55:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CEE8A689E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:55:59 +0000 (UTC)
X-FDA: 85273298838.28.6EF34E4
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 84F6B1C0004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:55:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GeRF/b4L";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790841357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AHrAL5m9r+wBvSCXVxM17eZGx8eAClbgj8DyTpgrNA=;
	b=Zx50lWEjDXv3FqaBlN/vidkXUm4QhtvCaEa1zMQkFqsk5uJplaFAwRJtltRBliEbxKvJbV
	5tBexydRhIDkh1B5cOv2MvQRPWn80KLPyAFKGVKGjHkd4kwJqJhV2P1u4DE2ZTUCicFdrL
	GuNDIVIr4oH6qWWvikicyQYINYQOHmo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GeRF/b4L";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790841357;
	b=FvEqZInV4NNeoyHigYcM2Jt7eVBdZqN8dnlFM76R064DYoaph7AwmtDj2CeDZViyQE4xoD
	UidoZtZhSJohkEJ3GqQqR4kzdvi34H9CKsOIxcGD+vdiIckJK7aWi31n8e/UYErwc9llMO
	5VV2mKE/k3HotdQNVY3179akkxZ5JAs=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3920so46617995e9.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 00:55:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790841356; cv=none;
        d=google.com; s=arc-20260327;
        b=WRyOcy9zDdEOP9zmz45av9uuJmzdQOxBoA6y+DP1Ai1iQtZdhdkziOqZ0l++ihqJkv
         MClWcqxvj+fbZxZ8SQuzy6tyYkjZX4UgeFh7ZckCBV4+tAaRRzU6lA4NlsF4efs+qp6A
         Rc2mZcnh67WYC5MF1VTScvUqEFUJ+KdKMMHj5bLxbY5roZC20uC/8rvsmwT6LX0PWKdb
         63UVnW7CxJKeH4+M6h1RFeXen3Oocjysvnlhsx0fF3GWZKPzFOAp8YozaTZEXVLVLvMu
         4ZiP99ilBzO2g+G3pY0hpi9Uf4NA2k1L/tJZLMJYEdVtGtNMr21pHVAM2+3bJEl+tjRz
         gTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1AHrAL5m9r+wBvSCXVxM17eZGx8eAClbgj8DyTpgrNA=;
        fh=9uECv6tujkZmrcP516avANM+u4mtsrIlbD6bJKCWdbg=;
        b=PZjCP/PPbnjzArrxXAKY2fPU0YvCDfxjEnwLwsPBePul9V65Rdbz1JKBv5akx8nsEP
         ioUDQNJngszjMilzrLH9KdI+zWVk6Xnx63LJYfw8Un01MPH7Q2xSnG/NSf3+XveAydpu
         P/9KhcGJbZMRtcSILpHiSn6+GZtxm632ASdaXI4iCVdaxyjmxI/2ABQRzBG3fbomg0f1
         hGbdVlPsqb50W05g4eUfs8arv34vN4kfnIi4WeeQTrbZ5hn9QrAXYSieEEgycBSNV2sZ
         LgJBzY675xD74QBckQjUSKw9odhv6GTsFf7//yY17/Abz03HovWz/hf765gIiwHvaLAi
         lwsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790841356; x=1791446156; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AHrAL5m9r+wBvSCXVxM17eZGx8eAClbgj8DyTpgrNA=;
        b=GeRF/b4LnEZ7N3IbWBqEEiOA2omscVEPfTq4Vciy55dVdY7XLHNrSxLIW7XBBcKiPD
         CPijOKf6whUc+5GBYMnPk8jM4Jp8eZUPzp01OG+ZVgi8Nib7dUhTN1dj2SnoTVOfw0y5
         LiMh1o0nqh1Vy10vK63btaG9LfufO1ljW4yqstrrgZ4z0nRytZ1tGnYoFTHKLxpAl7PV
         zk459U/FTIHEiyUddtLKLpy62BlZ5k6U470n+AvMvl2QxLqiki3zFF1zRKGgo4OTwXB7
         km8Dg1CxgsMxuFjxnPAAw4GVVw/UsX9GSAFDqi402v/oOzetqqPVek0d0ZbeOrCffIv+
         XYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790841356; x=1791446156;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1AHrAL5m9r+wBvSCXVxM17eZGx8eAClbgj8DyTpgrNA=;
        b=V0+WgKrbMTb2wfT5S4lAE/G8N1rY7vpiwjTI1uke3qTyiaU6SaUNcYMwXUDz0wBs5O
         hUOwkbzcHxT4Qoc2zyX3EXJfFQx55CgXvhfEhc4dsD0m/haRrRNUnbC9RDiTYK5BnXJ/
         qwPZGaqHV3R0LDyOIWKjpar41y4eVrpQCovE7J60lOdxxMK4ygFib7m3KP5WbZX/eT6h
         IwD5L/HIwT4TXkjUxIQBnRw6Yt/0h/J7FDxikBONx+e3E1z0dc/7oDDCl+DpUVwVo5JI
         IvxwqRQXup6B+anJnxGiDFXnI3CyrnFsmI21x3mZG/wYNFUzj8xADepjsvZnkONw7bf8
         c2GA==
X-Forwarded-Encrypted: i=1; AKwUvBwWAMC1j7Fa2yoKaOOPCTXkFoz46VEp3W/M1XAn31d3T3Ujr03bZLTRpV71opx2AJ95qzwrd/rvyQ==@kvack.org
X-Gm-Message-State: AFuF++mQ8HtBM1UDbkYupGfhMJB/TtelfGUfrFZGdsOC/1CQqgj92wka
	fU9XDQHnvy5Xs1bJlPzs+I1tS61ATFoSdAEM5r1OrULCLewcrEbHkeQ9DTMDOogAUuTeIuClVe3
	irnhYp3nXDxkF42q6ZJw2bzh25Ibqed8=
X-Gm-Gg: AYBFou3vhQm7peWPtxhf3TRI0GM+1wQUCncKSVhPRoBafyFg9haquxxSpDfttB0Yz6T
	b05lxvo198DWCXa5UrEjEhnS+gQQEpQMy18JBPRUMOPopJnPVmbUKxAf3Ycj8GmlrU0U3jlYrsE
	g4ZxxbwhQb4375y6cMLTUOCX0zA5PhLmxRs5vexiNOspLL0MJIeSh/Zko7DHbFEQ+vNS+h/y4ur
	ltzSh9ZNBrGGNk/JZJDIF9QmmhkVP1qcO9tpSTpU/dnRKnqw0maD7LaD7rtokIEIpnAVcJInK/q
	vi4JWHV5v8Lcj5577MqdzdDlB1YRU0ReV5Z4vg6oaZRIAoa0pvE5TNNxxg==
X-Received: by 2002:a05:600c:5020:b0:4a0:1efa:c746 with SMTP id
 5b1f17b1804b1-4a01efad733mr26833895e9.21.1790841355651; Thu, 01 Oct 2026
 00:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-6-jiangwen6@xiaomi.com>
 <ar0s14p8KPgmDKmR@milan>
In-Reply-To: <ar0s14p8KPgmDKmR@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 1 Oct 2026 15:55:44 +0800
X-Gm-Features: AclHuK_wExzN3hq35-9mtJ9Vi_bHjI_pv0wB1wZZplKSMEZ1VOjoAMFGpVzuuYY
Message-ID: <CAHKocdEF3RE5FA+LPRf_E0ns02a5akvUDKvSDvERoyTryV1X6Q@mail.gmail.com>
Subject: Re: [PATCH v9 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size()
 to batch multiple CONT_PTE
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: t9tksspg6ed63zsohi59jxm7aj7r11kb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 84F6B1C0004
X-HE-Tag: 1790841357-405998
X-HE-Meta: U2FsdGVkX18O9ne3qIZjKne1+lYD4FRuLzpTUKT8/AeRqkOkdx4XYXrl8tVMaS9nZ3SOAihuG8Q74y6xRqri8mRQn3hyy+Mr8wgG0wlOt8WLsexQrSax9tVa3/VwmetVNF6NBuNz5uLbwz97UK/qdaAGDvynmr3eyT9tdPsIuxZt1u260K+lsyh2Mb6GXH3iXtlQVW+8qrXCE/JDLvYQM7opDaKOY3LD5feZyfqlKi6vSaJU6nKq2/47HfWZ2mnuUG0t04t74/6gVUBGtJj9PP4Xjjc161U7YMHvg6gxtxo1r/2cMd7Ik6QWriK04Ov4O7HqDYjsWPcO7N1IN42YlbUBz2SCzzRe3q6OeEoEqbFtgzQXMlBKa2zF3KWUZGnBr41bIHe/2OjCQxQB4Q3DMTk/1X04Z6vROYuUxtkPqjcVUL9eQVcQ90d7zydWzvejP8j+8mYLQXhm/noyXbGRCgPyJ7uk8ih2y6MZyAqqxvQGGJ01NUQcxO0pWJ5G21JdH/LMbOC3JsEGlDPIWmZXHT6QdHd7yqOa3Ab45Iqs4SGmJIt9QU+UwZ/QgOzAbvr/i275reJ5DH2hVOdVLtN26UwdFVfGgk30NJ7VMjcsBpSoxskFc67+7Bq09CgubKXt7saIQC0b71w7sRnD5uAI+9Nux3/6/rPD7gE/3s8efa/fvNqobXRouizN+La+dKdCQMjMhZrGMLPBYGUjfyl0ViVU777Nj6rYFUl46/tJJFdaEVacHKCNzfM26tIjMbapjeH84CeVZnZ+J9bFuJtBf8MyjapkMp1sX50tuh6SYTeNU4Pyxrp35Gk6xxWIEvyWPi6ajE4VodfIZbxzoUOIvH2/6ssttyWRu84ciTU2fex5ar156vbs5J4cg+HSK7U71ABS+qD6RPWrF4iIUsinpr+arGBLM0AvuJTylWyoc931xU+qVn3RIosklYkoM8iU768nyTxX2Q4aUmh6Vjq
 crXxb72j
 PdIJmTXnk1Okf7Me/moT+K4rX1jpVAj1jhkMMF9LciSgweIzRcUzclG0jW8fzJoYmRnRI5IS77E7nbg1WIxkidPiyXCFE9mYIkW/16de9YPF5t0nWZxP3uagIusPkEV0WO+7yz6EMhyK/MKx8fqQn7l47zlsNHuWwFZCJR91JSMTy+l90/Rk+JZMsBYXhywK5yVS3Ryn1JuSe1Hggl8q9Wg/kTyMvFO2qd/bec3Buh13ejSGQh2M9DPn22yqf5YVRQetHJj7S9SW5FPkk5KUoOKRqKZJU1Guwscfnye53CWHfsHHw4v50X9tGKEbBk7ZmS7/+pEPJ8ziIqD6QmdbnvFmM/LMsXAVcyOeXNgHJ8IL1PayQdV3eM1UCXHqbFXbzpf4Jqx2KKBqFp6250ocFGBHDci2km01BUCkUCBSSBvVG3j/nUPg9QPP/0XNnjMUME4th3FJc3G7kZuqR779+ttnle68Q8zGGtVA6vOE9+rN/EjlHSYB8kha1dj8jBdJOnwpwEBy9+oLWvtpk/Sq2hyI3Zl4ZiTfc5XNV3uhKzbp41IvTluM1dLD0py5oKGmMF0y/W0rjXcBIlnjfoPFp0tW26EKwcsq8N4rgKAx8HAMnUA+FTq//INK0ti4Lk1ClNDLcai1uzLht+r4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sept 2026 at 23:38, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Wed, Sep 23, 2026 at 02:28:27PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> > blocks, reducing both PTE setup and TLB flush iterations.
> >
> > For CONT_PTE_SIZE-aligned ranges, return a mapping size that may cover
> > multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes are vmalloc
> > mapping spans, not HugeTLB hstate sizes.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > ---
> >  arch/arm64/include/asm/vmalloc.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> > index 4ec1acd3c1b34..4053b1ec1902e 100644
> > --- a/arch/arm64/include/asm/vmalloc.h
> > +++ b/arch/arm64/include/asm/vmalloc.h
> > @@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> >                                               unsigned long end, u64 pfn,
> >                                               unsigned int max_page_shift)
> >  {
> > +     unsigned long size;
> > +
> >       /*
> >        * If the block is at least CONT_PTE_SIZE in size, and is naturally
> >        * aligned in both virtual and physical space, then we can pte-map the
> >        * block using the PTE_CONT bit for more efficient use of the TLB.
> > +      * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
> > +      * capped below PMD_SIZE.
> >        */
> >       if (max_page_shift < CONT_PTE_SHIFT)
> >               return PAGE_SIZE;
> > @@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> >       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
> >               return PAGE_SIZE;
> >
> > -     return CONT_PTE_SIZE;
> > +     size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> >
> Capped below PMD_SIZE? It is half of PMD_SIZE. Where is that limitation
> comes from? I think the commit message should be improved in that sense.
>

Hi Uladzislau,

You're right, and the "half" is a leftover that can be dropped entirely.

Before this series decoupled vmalloc from the HugeTLB, the value
returned here was fed into ilog2, which reconstructs pagesize as
1UL << shift. That forced the size to be a power of two, and PMD_SIZE >> 1
was then the largest power of two strictly below PMD_SIZE,

How that pte_set_huge() takes the size directly, the size only needs
CONT_PTE_SIZE alignment. And this function is only ever called for
a range that the caller has already confined to a single PMD via
pmd_addr_end(), so no explicit PMD cap is needed at all. I'll
simplify it to:

        size = min2(end -addr, 1UL << max_page_shift);

and update the commit message accordingly.

Thanks,
Wen


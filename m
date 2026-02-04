Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44DC2E83EE5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71A06B0092; Wed,  4 Feb 2026 02:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49556B0093; Wed,  4 Feb 2026 02:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972956B0096; Wed,  4 Feb 2026 02:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 811CF6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:37:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 332C91B23A8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:37:38 +0000 (UTC)
X-FDA: 84405969396.09.5A6F81E
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A91320003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:37:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e1fI0NAh;
	spf=pass (imf13.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770190656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xKiGXhAf0POKtC5HLVPhalwQmNgPksjY3TFJBTsNxc=;
	b=veoeM2jzgC9qkym0D27y4BFn3k352fQNc2GfWisQsLnKwcuiDsv/0+kdXypvPQodn6G0KU
	BE+Zrqo1EdJjU0GWh67gdttxOfEw0S7icMcrCCszL1OwtOHqkfMjNIrPV6WHRMb3sLtzJC
	BD+ObNy/jjBTwan3E4tpocu9SrbR0XE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e1fI0NAh;
	spf=pass (imf13.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770190656; a=rsa-sha256;
	cv=none;
	b=fbOQTGyhb3jf0e7Dq283Qei8u/pqKhCZA35op/RQFmU2w59tpnhN/Xi5vbSg11qHMpMwGD
	vOYf6u4sUyMk3DDyPfz5+SL+0VxG0f6Nhu+dgE60wA0A0/QkKvqocBECnycWoo5Zrw4b71
	2yRGiUBR2HCBexVEhDa2SCU7Cjohv64=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso3811677b3a.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 23:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770190655; x=1770795455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xKiGXhAf0POKtC5HLVPhalwQmNgPksjY3TFJBTsNxc=;
        b=e1fI0NAhxzoflE2k/dbSPlhWOqMKC7q95HOAoEjSd6lqozrsbOoYPg/Z7jXb5ssQ9y
         mNNBAaQ8ryibJDa2f7IDWGYxPBozQbssorYXu50+MmpnCHWWbC/uEqYHUp4wdgESPbqb
         wnyXRW4IvDyePH7RlbR/JVWbaefEVl4upJ/7vgjw5r5C/6IfikdJHBlHHCIDYMj/KYkl
         gHVGM6SSe13f5LJdddqVyUZ2eyWJ1QPJGtRegVy+MxN7IZYBrRTvrDCRplhyE79e+/on
         /UG8s6on2NGcC/IlknHVCvXMJLd8/hPv+QU+OcHWrd+eXfsgwhojgRJVDSowBDoecJwd
         0FAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770190655; x=1770795455;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xKiGXhAf0POKtC5HLVPhalwQmNgPksjY3TFJBTsNxc=;
        b=vEGitzawdp65TdUF2k8lNO8a9s2SVAlKBroOIM8ZLe4nm9XxEvSRX5Ivz/yEddL4WQ
         ZJ0H/fwppXE7r9wY8FaJqRg7OyvHcLYSFOKRSwxK7MRr0DlSwnEHpGxuwhnl6oz8HrWV
         9b9uhEtKK54QhZuvQdulNVak1rnjMew5Wo7Cr9Ynj0/Tzxqx02uUgA/J72b0wRqG9j6v
         kRt/qwobJacdOrq58DMIf8HLibu2F0yAulfJ8qPmCze4zckuWlZuwnJmo8TwLuiaUFEq
         W+Q9pHpnF2mqSV3DxPVssXd/4yo6GSE69YoxVC69M1/Fks+VZr2KuOFw/bo2BdK+LpZO
         noTA==
X-Forwarded-Encrypted: i=1; AJvYcCWmlfvEVo67gL80r3t3A8t/qQ3PPDTJckNfnTxBcw1aape/6aKfU6EU4tZJ9Xxgv//IlWmq9gZ75Q==@kvack.org
X-Gm-Message-State: AOJu0YyAVfip5Kj4uma84UduJhRBsHfcKwseNpNxIsnzFZDqMH/X/Uup
	XSltOG5I12Nu54Sdi2cQYJb4MsdIZgvZ4CgJLyqy8FSwcbSDcHVK+8D2
X-Gm-Gg: AZuq6aKQ68gmdgB37bKR0hhq05JzF9VVPRO4JtmFw48m17+7994+Ptaoy5lWdozmNSE
	y+lyuCzrVceDQb1eNnx8/XySIbF9w0DCPGJTREiUxPqPAiC1aOpIK5u6Gsu06BgMHBODA5hBgDQ
	/d6Gb9u9s82iCsPeiiNFVmicHqedA4P6aNewn4o2bFY5vnnub4GVX//lhWL458kOGSJZNdI4415
	rvk2fjOiC0XUIl5UeYO1WKwSusP676uYcDEDvgn4af+DTGp69EcQG8Bdyww1itd977oI1ZL/vfJ
	P2/hJpvtXfwQgfiFd8EqEg5vxqniNfbv2jwSUEqi2Yyau8+P7wggWVXt2KIVHSWXWVNh2rt43oq
	lxFF5/Ka2VBukF4+EBhf/PNgK40CcmCoHoLiQZRi0PBlrJXLVlTF+96KQh336Ow2cBScNlVVlhH
	DAGLpHvDoiWYwZZm98lB01mlVH6HIgCDOIDk4SHR6DFK6eU8ON9IMwwEnS3Iyi
X-Received: by 2002:a05:6a00:4b47:b0:821:807a:e427 with SMTP id d2e1a72fcca58-8241c1dfd96mr2358341b3a.21.1770190655016;
        Tue, 03 Feb 2026 23:37:35 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8241d163fb2sm1561632b3a.14.2026.02.03.23.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 23:37:34 -0800 (PST)
Message-ID: <abe69ec973a115015d998907e9f7fd4d3c45f38a.camel@gmail.com>
Subject: Re: [PATCH v3 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Wed, 04 Feb 2026 13:07:27 +0530
In-Reply-To: <20260116100818.7576-3-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101245epcas5p30269c6aa35784db67e6d6ca800a683a7@epcas5p3.samsung.com>
	 <20260116100818.7576-3-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A91320003
X-Stat-Signature: jajua84puzn6emf1brgoxwy9w9btherh
X-Rspam-User: 
X-HE-Tag: 1770190656-583658
X-HE-Meta: U2FsdGVkX1+foI3N7S7mr4rFI5J66uMhS30AagkiWIp6PTjuL4HqotJDRqybFZQyhgDfCutitZ8WhJIpeGRE3BFVT2SYCdpYWRFvVr0Chq/ouql8OjTU/LBxOO2pHRrZ8V/YESnrYEg+Q7YBvLdxCW/Z0wCku0QgKhhDyZBxfpNFfL7sSCfqfnHz/mYC1j60qSDuL/tDTwjsQT5TDpciuGNV6DHJvhgL0xzMaguChsAVwFRBgJXxVm+v0Uj1BmMZkZHfKd4/+zgIMHjx3VlSSD3LrTbslED8Sn1WojnAQzmr3ZRxMU38JThNkXYkGGMUgt8Bj4APTsHnH2QaxjMS95SHPG6kHxnjD/0dGGf2TR6hR+dqAokyM4HRQY3cxorNDmVj2LkpPhlfyxiIe6qEUsbR24wQ9PEarwfICRLazTw2C5KJev0qknFmxnGkGzH5y4R+bjiqCtB5yck2lKCoYQgBL4LYFMDEUeQR2k/uxKo2y5B80aoImbczAguwsa5SvIa49nOyu1F5JTaAloWX6/A9hw6v5N79n1PjmhHSEVlE+lpwwsO1t47pn1Id5x09yIzXMGPCQSn2FFpy+hpq+OGSNwDwtMt84iSzXDRxR4Ezt7oQAA21CCCSlHly8T03b3+0pyvCYnpYB2HM3Bul7ttNfX4K90A3wsYE2dLB0ssMaAbAf6yeqpnTHMf3K4rwPPMzLmyutWt1NRYTHtUbwaTsWM6xNWKJuU4uo2JmMq1htInv/5AG1RL1CDHTFuhMzQ2Te0XLmGj8uKTSY3n1D1uTQFStSiNi+NItsoI95Wynq4nBKoiE/kmW2jKq9PjYFwPk1BuaVs1majxDLiiOw5ehkKHHsncqMiYem8LrZY1xw0Jy4MQr/1rfnfEVsiImATxifjdFxyGNqU7Z8Dy1D7T9qb4XdPHhk84c5JR7YTTTUO6VJf2pucFPH6mFdbwnJxi+axZ0RgtCJY5vTx9
 hiqbhWQP
 I4HZe5QuQf+BDpX6HpJSgLrxdRJ638ckk/XPVc5LiMzoDFHNlSFqTn6yIAhsgqhLsm5LIqFIYP14UlSwZy015IwIVEYt+33egRC6d9leFGWiu5hfaT1lynbGj575EUgvLeLxRh0ddTvo8EWEhSOGyqcHv5/W8Anh2BashBtGvS7dP4XHSJRkq8PgXC5WEtA0Ztq6cepXiS4+kDUUGnR7liiGI8t4MDaUQLZ90qP0xW/sp3Cor60sGFQCBOWejBITct347djTLznacZ9Xwyifsrg0g7RhdIZBA1ROn3j4eJ7qOlq3LL/xvUOKJeui9QiawyOXNWxSH4A5ORoK6zw/6y3i5dZH1wRXAA89tDKY3odt6HItMLYwTVIk6VAatpv4xlLqxBrUBPbpXY4/sP3FCClvI/VY5mPpKsmTXfqrZmACb6t0kpvLXOPhkUs4Ey178q9TQWJPT51OTXQblMvOm6QKJlubuhGM//75Nde+KrnFUvBTL2ZpF5LntKJNtCdA1xlLA9Y155CeM/Kb/aE7DDfJ1wFl+RuNcXcnYDzFLpFuTs5C6lZ2EgIHUy2e8loNRY88etzAKve/MDtJ/HStzo/s1Ds9TtXRRQC/ewp+rF9MHDsNo6g6qqE5hc+Qd7XtMotYVSixufbRlnZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Introduce helper routines to pack and unpack AG prediction metadata
> for folios. This provides a compact and self-contained representation
> for AG tracking.
> 
> The packed layout uses:
>  - bit 31	: valid
>  - bit 24-30	: iomap type
>  - bit 0-23	: AG number
# AG limited to 2^24 - is this a reasonable assumption?
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_iomap.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ebcce7d49446..eaf4513f6759 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -12,6 +12,37 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>  struct xfs_zone_alloc_ctx;
>  
> +/* pack prediction in a u32 stored in xarray */
Nit: Maybe some brief comment about what these are doing and their significance?
> +#define XFS_AGP_VALID_SHIFT 31
> +#define XFS_AGP_TYPE_SHIFT 24
> +#define XFS_AGP_TYPE_MASK 0x7fu
> +#define XFS_AGP_AGNO_MASK 0x00ffffffu
> +
> +static inline u32 xfs_agp_pack(u32 agno, u8 iomap_type, bool valid)
Nit: Maybe use xfs_agnumber_t instead of u32 for agno?
Nit: I think xfs style is like 
static inline u32
<function name, parameters etc>
> +{
> +	u32 v = agno & XFS_AGP_AGNO_MASK;
> +
> +	v |= ((u32)iomap_type & XFS_AGP_TYPE_MASK) << XFS_AGP_TYPE_SHIFT;
> +	if (valid)
> +		v |= (1u << XFS_AGP_VALID_SHIFT);
> +	return v;
> +}
> +
> +static inline bool xfs_agp_valid(u32 v)
> +{
> +	return v >> XFS_AGP_VALID_SHIFT;
> +}
> +
> +static inline u32 xfs_agp_agno(u32 v)
> +{
> +	return v & XFS_AGP_AGNO_MASK;
> +}
> +
> +static inline u8 xfs_agp_type(u32 v)
> +{
> +	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & XFS_AGP_TYPE_MASK);
> +}
Again Nit:
We are introducing functions here but using it in the upcoming patches, any reason why can't we
introduce and use the functions in the same patch? In that way we can also look into the definitions
and usages in the same patch instead of this where we have to switch between 2 patches - one to look
into the definitions and another to look into the usages/call-sites? Again no hard preferences here
- just a suggestion.
--NR
> +
>  int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
>  		xfs_fileoff_t count_fsb, unsigned int flags,
>  		struct xfs_bmbt_irec *imap, u64 *sequence);



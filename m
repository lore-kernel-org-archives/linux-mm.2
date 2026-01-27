Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F502D2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B955C6B0089; Tue, 27 Jan 2026 18:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B810D6B008A; Tue, 27 Jan 2026 18:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AD66B008C; Tue, 27 Jan 2026 18:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF876B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:44:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2403813AB2D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:44:05 +0000 (UTC)
X-FDA: 84379374450.07.6E4AD6E
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 511911A0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:44:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IZxTBb4i;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769557443; a=rsa-sha256;
	cv=none;
	b=KG+1VxogRiAH8vWGjLl2xv6Qc084YdA7g8H6mQLT/P7GwwgC/5e51tuQcBZwwcdMBBoW3A
	6Uq4EqnBz0zSPvk84FYTEiQ87NwynNjiiOYBvqBfUnmwtYSHfenjGUyO/0rRstzXYELoZX
	r01rnJZ4zmetMmT+F4e1jcceDBA0rSI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IZxTBb4i;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769557443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1qRlmFFKOqQW1uayanhd5aQp7S6yFTJSXPtSSKOmMM=;
	b=b5Wdnhe/1EW2grMH36Du9f8SB10RuLHM7u2wnHNdyKeXSI41GskZzwuLnJXzzztAAcvd7p
	WXpPpq5j/Fe5d19U60xR2uU3OdiIcv5OJSWRjxg2EcLabK0V5niWfqqCcorG6pg2D67g7t
	sBWUyfmkpwjYqIrwKVo9Yyi4zIGvES8=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5014f383df6so53377821cf.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769557442; x=1770162242; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v1qRlmFFKOqQW1uayanhd5aQp7S6yFTJSXPtSSKOmMM=;
        b=IZxTBb4ic/mgt/P/phOzogCmRefVytLou6RjJ7FUHHNkbwuZ7RHuSFvTBrko2Rr5B4
         TUMuONLo4ezqc5KWdjSJ5ZwTtEbabjPgdHbW9KC8Q4rvczWP0reySy8487jSnu58wso+
         YOWuAfHete/GsY6qTebYuSKwFsTBFoo7/45RodcqHuBU0uorU6JJFZrqCoqUwtlDFJc/
         3ICvBhbamli2gpod1Arr5Wz0SALWpNqQNiHnbq6zGW0qnhBhBvUQ1dQwjMTE1egF2OYa
         gmXI1oLeCauAB5P/nM595RQZPZthu5duFuCIveh5I3kDl28Oj66JnzZeQbbFmMMjCF7p
         XwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769557442; x=1770162242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1qRlmFFKOqQW1uayanhd5aQp7S6yFTJSXPtSSKOmMM=;
        b=ohotC9AGcCOzYx3t/Grmi2zEl44uMwPkhjSRth/xrzVpAsRx3i7uJ8Q9lIdINfuRMf
         H/+j8IUh+BEqezdskabrm5yFcR7vrIJDjKjCp3IVYPb0JfDtnlTVPO04PkDJid7DYuDb
         lZKPLEHuAeWILtq77yDhmgL1P3j1w2rWuYAliEkMlhvnVOBN1+3D46ryKpQa7jm2xt5Y
         Ymzt8W8EacUty1JgEMnWlt5Whxh9ajxePQ9UOAXoKZ/UxF1R4dYDpsyuF0EW4+tIRwTx
         rxRWK3WtZYsFkcZFMWCVG+3HZG2x0lYkCuw79TBCbivTCZM3Q2kC0I4DCZju0CN/sAcZ
         sP4A==
X-Forwarded-Encrypted: i=1; AJvYcCXnCDWZvHqdakdBduZF1UcjkM2D+cOUjPN6kwswE4c1P8uMu6rzgyl0k1KERb5T6WS2CxM+WccJrg==@kvack.org
X-Gm-Message-State: AOJu0YzVoISpRF9AGcwIKCI+TByOFo3D/yUmFC58CbyroUoqamSEXlha
	9V5HNXALc/0qqTgjQWI6q3UZYX24UkVTZV+5h7PLYEk9UYEAjMKtFzlZ5YbyyjMTkRI=
X-Gm-Gg: AZuq6aIsrByANLnK9gRFiHEHjaS9L961+Z6mM9bRfGDg6cKPGcD7xdppBD3edNTtr8V
	Dw3Kej0UhOLUcWbgCHE2rgS0twPuAVspNEbzAYa3h+U82vu2hKYaf2RBUAdmTB96ZSRuxwqvdWl
	i38scHH88jyzWGnLdLE2aitAQTE1CiynGwpqgdMPzijBSW0XoSwvGRcvdHyVM79/Qgaqkq1z8/x
	szjafykmtljzJv2kZEVQk0iA1lFnGUqTAfUSkMTaF4oxTpjau1jdnu0Fw5h4AlcxnhdgRpxGiTZ
	k+12hAHpvc2gCOxk/WBKBmlpiFWD0fyOMzb8jaq4J/asDGTgmchD0Lr284wMbumTLAcOz2oTaFs
	VCzDR2xayWiHG9Sn46ITb8dfMqy8ZzQl0Eb+dSNM08scsumC/jQjlMXx+cl9dxTHmV5JsRqDmQA
	X+/lQWnY+t9uLsGN9chDK6Te76OVLm7GkDiw8A4cfA2A2WEv8qw8XoTbSJ4R+7CGMWP8pEwteM4
	88PO2zW
X-Received: by 2002:ac8:5902:0:b0:4ee:2074:4b6e with SMTP id d75a77b69052e-5032fa034e6mr45336511cf.45.1769557442464;
        Tue, 27 Jan 2026 15:44:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36a9bdbsm6298466d6.11.2026.01.27.15.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 15:44:01 -0800 (PST)
Date: Tue, 27 Jan 2026 18:43:58 -0500
From: Gregory Price <gourry@gourry.net>
To: Bing Jiao <bingjiao@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXlNvgS1CsU0JoE_@gourry-fedora-PF4VCD3F>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
 <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
 <aXlKOxGGI9zne8sl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlKOxGGI9zne8sl@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 511911A0008
X-Stat-Signature: de6ijy15pqy7h7y581hsjjwq4mnze4g4
X-HE-Tag: 1769557443-657420
X-HE-Meta: U2FsdGVkX1/SBez7tfWLk/fsiWdckmlqh2oKEQrqSZ7wj6VHt3/B+rquz5nCMMySjsXgJe0K7hN1pXsdEhdN8hAS3Kl54NN2zr1z2siHwzr7aAVEQxBVnl0/CNjDly0jr9LTH+1jDzvtjchjqeGTJytFOclMkkPemi4o6UOtPQg7ta36NCwnSPObqj6/7pZp9/hX3ptgB5zn4O+Zv/7RAt44wiy1kAX0x4MVmEN05OORyD0+igKWamKSriQRtSvMGn6i48585urx2vrCVPxCZvUbVc13z26pMex1MADKXuv/00YbPyPGdhyExsr/0Zafv0NCx9mhhiSHSgCa2+imUJ8L3d4WKpgUAmC5RZtqAMGtnpnNs8LOkclB/l2N5JMEQrmJBEgzT93iMVjMZxLrTwS2xtgEq8olyrVdxwDdiD+DrHg8auKXVsOoQGMlM8YzvcxyU3IA+L2ZUjEx/VbU/WUbeCVVUnEs06sTfad5mAgcvmzX7aC3N/g7XX/YpicwKFGZxSkP5/ut/oji0ZEKYt2Ua9H6fHeXchCBxrICsY8qhLl7lbJ76x4Ad/TVGpVgYIukeuWs15TMabPcBnyUCUDsKj9JNGNl5CfLwoKDWVBeyhtHWMhHJgokgQX5D0O7M0RStyhb51qDITF4LtxU3+QFVO4kjAeUO1KxizC8pavAyICNEZdI885YdPjKoUfHO4pUO8IrRiwpa2I1K++S/XrK3YxUlx4rI/JTUtKL3lgE0uFF4jkB33nzr7EXs3dkJQUbJpsVGeNg0EcReF3IWOsKOzVRLHF3w1GDMwW0Pvc6lJR3Q9fy2lNf3KUIceeagVYvV2Jt9t81bLuNNXRzQhIavtZmBRrH/H2iLf0X80OpxE4q2r5NPrwT3NgmsZOav1jL7+MDbzdDTTn/8HicCpDs2JB/z1CnZA9bxtkoy5woUuu5bpL1KMgaQPJPmc9AuSJSwPlW0FJBlwGsZ1v
 kItWtFrQ
 XtB+DmNS/SuBB0PjADagrvQlBgl58kNf53m7AtKHOQ6wa/Atg1K+Spu9nyVfbH4wjWgYOR7yFOV6LJeWJDlNSviT6Y9/pRkxD8zgbHbEbK2dW5RdgoazHw4FW5CEu5F1Hso0aFtTgjKC4XkLgi39lsBbCIZcfe98bz8ZHxLvXTj69xQeaW+woq4YEk31wxY6hetqqQPzPxO7I7enRDHa4GZ+D1a11jPSi4fxw8ShplH4H4IYwEzJdaChf5ZkdtpOi/iUf+TDLdSGE0bumdPpmrp4Wpr0oPt3H/QYmPv71NhfiOkOscC1wC48dDTXtmIRfsps+YxIoxPgjDJacAAo9Fml+NohTAIoycUPxB8QtcVPB4FKT4brSukUTlrVUiN/iKDmPZW5VLKEMnhikRKS6265/I7I8X7YC0B5jZOwyOB4NAv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 11:28:59PM +0000, Bing Jiao wrote:
> Hi, Gregory, hope you are doing well.
> 
> I observed that during the allocation of a large folio,
> alloc_migration_target() cleans __GFP_RECLAIM but subsequently applies
> GFP_TRANSHUGE. Given that GFP_TRANSHUGE includes __GFP_DIRECT_RECLAIM,
> I am wondering if this triggers a form of reclamation that should be
> avoided during demotion.
> 
> struct folio *alloc_migration_target(struct folio *src, unsigned long private)
> ...
> 	if (folio_test_large(src)) {
> 		/*
> 		 * clear __GFP_RECLAIM to make the migration callback
> 		 * consistent with regular THP allocations.
> 		 */
> 		gfp_mask &= ~__GFP_RECLAIM;
> 		gfp_mask |= GFP_TRANSHUGE;
> 		order = folio_order(src);
> 	}
> 
> #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
> 

I think the answer is that the demotion code is a mess and no one
actually knows what it's doing.  We probably need to rework this
entirely because we've now found at least 2 paths which clean and then
add reclaim.

~Gregory


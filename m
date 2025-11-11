Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BC9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B31C8E000E; Tue, 11 Nov 2025 04:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363588E0002; Tue, 11 Nov 2025 04:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B518E000E; Tue, 11 Nov 2025 04:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5618E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:31:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36A1DB9AA5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:31:53 +0000 (UTC)
X-FDA: 84097809306.14.7A46705
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6CA3520009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:31:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ANftsj27;
	spf=pass (imf03.hostedemail.com: domain of glider@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762853511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcuXePJv9UMRmDbNyzI2WPi4AQ0WM2JROyTQZuxeHnI=;
	b=6WLEOYQwgo+gQKVr3L8H4jMGNh0tDSbPXW/BAnSl0Ub3K7h2EUZ1nXdKX+ZSle6gq5Vt9C
	XKPbE9fvFxnMUIHwByyelqImGBOz6z/cwdb0t6CXc8DbCdemY5zXRc0JVNUcwiIeu8n/pd
	uldLeUdlM6dLGXv9rLtnlIiRSd/S80s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ANftsj27;
	spf=pass (imf03.hostedemail.com: domain of glider@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762853511; a=rsa-sha256;
	cv=none;
	b=kJY/+rsKf8/dwBoqpcgeJBLiwiHdZjD/WeS8ztxXjg31d3b4JIfodA5qChCvRS67WpBkxF
	Z0P8M5zGPMdI0ILuamwKk/Vu539S5/7Bp/FRFSoOIZ7F8n757VPQVE3SgeFa6+szFdem8q
	1Hdr0DGcLla/HQKqY5tcIuWeQrSya/o=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ed9c19248bso32560301cf.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762853510; x=1763458310; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mcuXePJv9UMRmDbNyzI2WPi4AQ0WM2JROyTQZuxeHnI=;
        b=ANftsj27QmrF8F67fF+yXwVo2TtDJhzeJ/S2iAoayB5ZFhKDZSZIiQ3+EW4JAZlVRT
         xyQhMfduOcM2ESPjP36Fo6ztnwGv4i3uKVw/O85cGV2dZuJuR+CStxfZR9NsOkJ2CUQy
         XQmiLJuZHu8fJhcUALRpWBG8i6sOtVzTddBtlSsGad6uN0k2tPsy4TVkEtxZtk/i0KB9
         XSIV2fGVS+e1Cc9vIBoq7aXxh6hRnXJwZ3zbJpgmY7FndF5HAp9HfnNiROIYrKjzJ5Ec
         9HYnKgB2GNdirqyZ9wm9wONJ7CRrsgkaD4m0Rdn1879VS2kYvKoiPvn3ej8mOMYE8cEM
         tpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762853510; x=1763458310;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcuXePJv9UMRmDbNyzI2WPi4AQ0WM2JROyTQZuxeHnI=;
        b=Zwzf3/2J9Bat/LZ18ywqIteQ156dbQAJP5V9RBPxSa5RqiHoIjbuk+qiBiSQo9T19d
         DXKSydpP5VfSSgjFWaoK0AILLue86ILEdqPI+GKN0vXWdBxV+pvNZhzS6j6U2t0m5n4C
         R5ojtBd1xr6nSxCmjw2V/AT/qQV15GpfRvjoOaB9NwoVX91tfKgYjqrQVoCh2c8L1U9s
         hVKOgxd8lT4xR3VUJuzL/LcHjQ09RVHNTJNOlHhy/9y6GkO5Uz5CJIm6iI4C1uhW5q97
         eFM4E/L7R/T89Zsa+i1z6MNM6vMvbtdc1KGZ63SitP6B9tPnlPGRCLojqlhISkKD+At0
         Sosg==
X-Forwarded-Encrypted: i=1; AJvYcCVKjVag1Xfy3ZQWlyd8PI/RJwyhZEd2+ql6bV5Z7slVJmEkBICqyfx18zeAkf1bTzbUAVCpELw0vw==@kvack.org
X-Gm-Message-State: AOJu0YwihEHUEnxVu1+5d/SruJLgtyHyr+KPL+XjVz3trg5hkKE7yzIW
	fXdjz+SsIBchv/IA+ZsuBcBchAsSDqBTnqS/cF1XXqmUWtAqiwGIrXQsRbdPj8PeHi2btgm4ikI
	vWLtNAhm3NlcY5NN/xUW1W+9DJRo1tH3a2sarUt3Y
X-Gm-Gg: ASbGncufWBHfcGrwEAh1cXFFV65gv5NqNz5g7Jz8mqqFaqAuyu1oBwGOsbHwjeni7YJ
	kVyV81r59GxrmvGzR5vv6kNVhdnIdb02CEXUAl1iFlXg56vCfwzt1gpLXhQ5I7SAF1Yn06ROKCf
	P0wjlbv24ebZ+EtpkJjIm20AFxiUKjQZmDdwU0Os6nojQ/v1Firc3Pinlg9ScbdSbEoZtAuDKtm
	tNH6gXOX5YYXzNkkw2lB8W9nlAHPprykqQidJzh0ri3R2PERkGsCv3N3AizYMtBVUtPLJEpGCms
	U/8a67phYLXy7/3Wp7oqEtN2UbtDj4RBw+9m
X-Google-Smtp-Source: AGHT+IEzr91NsU9OUC24gjDEzFi/WJBgPa8H1cJUF2UmeUnuLOth+gagFxzFFCqIthcpMbxe1OUruDtNQIgW1/7rFEY=
X-Received: by 2002:a05:622a:2c1:b0:4ed:6d2c:dbf2 with SMTP id
 d75a77b69052e-4eda4edae35mr142374501cf.32.1762853509963; Tue, 11 Nov 2025
 01:31:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <5be986faa12ed1176889c3ba25852c42674305f4.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <5be986faa12ed1176889c3ba25852c42674305f4.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:31:13 +0100
X-Gm-Features: AWmQ_bnBejbyt9xhMGcc96j04H3RtNf27KB78uQcmIocgSxJqcCqkGPoQwhXWUQ
Message-ID: <CAG_fn=XFXFAvKS2+bc66FR+gw7rfSybETAOBUR_vneaVdF5F9A@mail.gmail.com>
Subject: Re: [PATCH v6 06/18] x86/kasan: Add arch specific kasan functions
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6CA3520009
X-Stat-Signature: udbjqieiy4rg641b7iz19ghk37oudfd1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762853511-944756
X-HE-Meta: U2FsdGVkX1+bhPi56FEcWezdvT/iluYM6fV4TRWgg6pDzFTSys7xx4//Jb9Q7ODGN7FwPV7Ch1bAFpLwCE2/tX2dByveRbWJfo9Bvu4k4o9IRlVoeM5QtmETd/XoWa9le4M/VATg1yZkvGKX5K+qMiPhkPhVcjNSX88fN/jOOQXCbbkytuvNRdCOHHCm1sHJ3+NhwqeH9kvYerelit2wwkz8NmXPQI0WtOuWZ6/0I3ZNRMRj8IKm+tw+Pv6YnKnjuNH3yq/krFV6nWytuC+kDCM0Xqb9t1a48hITnV44ibOX35taSJigUd0OLmbEFUT+byJfxDunfCOLoDB3y/E2ENLm/mFCI9XJHJii2d3zBHmVfBb1pjk0/Ay7z/kKDlUnT3Ke7yx/tW7LKk78Sz9j+eeCJGT5kWGo+MJKkk5nRY5a4ZWVDSKlig9DsI80hJxhLcvEaKd/O/wkMbmpzsBV7Vqss1C3PBzKjNHBY0CLyqBAbVWYB1lp6m46NY1hEiM3EEDg8gRE5SibgFjaRBszdinruEuUXM+oHUT2+QnYgeMfl1Wc288KDD3RBOyBK/d0EKiBeCdk1vQI6rcTixnv+jgkc1I9XBt1n7cwN4zHLbqNrvIOoNoA6q7+oeW2rXIsAETuTt6+rtfJjC9XxveoTFP6rbKQj6sPNJZ5HU3DpzGh//s6SvlBHvF7DeiXmvxZ05xKsrQhCfs7/cuH2StyKaAH1X9CipqZw4f5RfiMmNf3WhBa1HyujNBrxUgLb7QT4/kl2M5ePIL+USmWXDIPO3aEAK8kJPK2ftZbZDykz22xRWj9JzaTflefG9DTsg+vTNt7qKNFid5/FoJ8ftkSpJw0SBQ7wXb93OvOnrVXJLvxUd6Ct0ujCMvS/RAIZRQIXQG2DUjpM8Jdsl8YE704M72pVyYPD8GiEX1ZjCxu3K+Y64GTGINGcL57e/DhBZ/wneKq4YAgtw794hHCwUP
 wCPp2/V6
 jhrbejBXRx3vYplA70obwdHgxLJZQMs7Q+oRQmYPbLuJAvqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +#ifdef CONFIG_64BIT
> +static inline void *__tag_set(const void *__addr, u8 tag)
> +{
> +       u64 addr = (u64)__addr;
> +
> +       addr &= ~__tag_shifted(KASAN_TAG_MASK);

KASAN_TAG_MASK is only defined in Patch 07, does this patch compile?


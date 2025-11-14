Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724DDCE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11358E0024; Fri, 14 Nov 2025 14:14:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC15C8E0023; Fri, 14 Nov 2025 14:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89E48E0024; Fri, 14 Nov 2025 14:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A39758E0023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:14:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1248413B246
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:14:11 +0000 (UTC)
X-FDA: 84110163102.22.F4E59EA
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 336018000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:14:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SwYBGRd/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763147649; a=rsa-sha256;
	cv=none;
	b=6W7bATaxLre5zqq+u+aNov0SjwCtAtUxcB7JL0sS0ClIierCFy9MAFHfDhuPVZTCQ9iFJp
	dioVWMAeaZ0R4IngVFLoxjRwunHXTGnOvZVAhrJ3oG9P+/9PlMxy2yWKKsANmPqJY10RtH
	h7SUoXGU2tyKjE+KBvxBZY1fy9bYWyQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SwYBGRd/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763147649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aI9onR+f63JFzaNIBKoGx3OAwegzLui4sLBarF2xej0=;
	b=MDuGUvt6GySQqsw0b4H4wgFzoj+08EUXNRK/hAiWM0EOBZMoYKOdBY62CnBo9ryTXV7n0G
	C29xdN73OkTAY4FIULJEERAHMPthhq4dwN4GdERlvahbzZj91EcLolvVnBCDOS8SKUEZHf
	4iRkaE0xUM8EYiogCSJxkWVCG6dXBg4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64369269721so408803a12.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763147647; x=1763752447; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aI9onR+f63JFzaNIBKoGx3OAwegzLui4sLBarF2xej0=;
        b=SwYBGRd/Hnxkoc+UFaarrdMD0hEQw/A3+N4l8kB4fLrqzNFddq7QWm0rHrV3qxhfLY
         1m7NTpl61Vcohy99FTmxj07+xTP7WDfP3vqUi+nWXRjkeHmzpN4KGZF4CV+YfEEMUYlA
         Nmwma2ALaPM/ouuuoWtSgTpEDYRUdxLgEEI2OtA8e0YmwTN4Ngw5ACGT7MRE/OFKvzGv
         xXJkRusX3r9vrT+Z+EdpESaU2DmOpOmwVzn+3TDp29XRBmYv6ZuQXX2pP5sCmczHeeKD
         rhSUy5iGwVn1RGxJKZm+mAWYtB7n8UPy2j1LR0baLXX3XcuhsRm+bMdkCGb1MeFmlJNw
         uSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763147647; x=1763752447;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aI9onR+f63JFzaNIBKoGx3OAwegzLui4sLBarF2xej0=;
        b=kZaCoVgI31xPviyL3NKEA0qJubGSi22cy+StUO+r8GsZhWj+5TR192iGUCHfcUtsM9
         G3pi5FCkF7Mrc36q5QY8FbINoKvEk7sFGDbK4yvVWHsDI5b6PTEm8uTaC4RIFsj08xAV
         dEN+sf7MzPjSlTy+SutqAGF2Ro6kk511WPkrmR7FJOsCpYwX/wG/1VZuyuvbGZQ4TSiZ
         nS4pPr0tGuK29n9IIjmzjo6jvVB6SFGY7YsgGw2NoJUeDxFbITNlCUC948cNiZHaANGy
         6qVPzbxDXW0adK1aHV/wxaqQbo/6usUYd9cpmjNgJYBycIXROiv6A0Vbv/piQzjxahMM
         Eggw==
X-Forwarded-Encrypted: i=1; AJvYcCVNTv47LF8IDUKY/iOJpr0Lqe0DZJfYoNVsfDBBPb4PCRS8tVEP42iB4oDEN0x920JfxYmzMUyWfg==@kvack.org
X-Gm-Message-State: AOJu0YwBk1wwhLiWskSA1yw/w1vEDltP0EALt64URjb4CAjmL/fUAsLl
	0FFrh7iEDhJ8uGw7NfLbNeFd73Ax46ozeqjWl3h9qAgi6mHxx1IpynUSnLNI6028z1ryIllA6sO
	yuKtbGfPtRq4PXp/uG62vd6j+SoCbkKw=
X-Gm-Gg: ASbGncvhc40uXzvaX5mlbKqQCz0sRyBtU5KmTz3ibKjVQ8lFXSAvkPWmdlH8ufcoD2E
	DGLVwMp3j9larfhBgzioCmbWZWKJIkLMd7qZyLeVYZ+Vnnnys1+rv9C7XpG969RiYXdRtE9Dbpn
	U4cliLyQjOxYf0IQQmGWkX+IJBlVWn/MKyL738LROBKKspXXdVbb82Znztd7MtjyVPLbZtRFL9d
	4SNc5tOdVndn0vaM+NiowN6ymJ6EpyUbf/cTlC29TD6HZSuPcELRmqnHulpnQ==
X-Google-Smtp-Source: AGHT+IEvBu7ESLrGNRMv2QiwL16IZgt6aUNJ72TYzx+vz9COzg0vAhK2L9oI/n3nL6QJ1JU+lRhqexZnJfrgTYt3DEI=
X-Received: by 2002:a05:6402:4603:b0:640:f974:7629 with SMTP id
 4fb4d7f45d1cf-64350e225e0mr3893696a12.15.1763147647239; Fri, 14 Nov 2025
 11:14:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763117269.git.zhengqi.arch@bytedance.com> <66cd5b21aecc3281318b66a3a4aae078c4b9d37b.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <66cd5b21aecc3281318b66a3a4aae078c4b9d37b.1763117269.git.zhengqi.arch@bytedance.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Fri, 14 Nov 2025 20:13:55 +0100
X-Gm-Features: AWmQ_blqeEJIFeEqLe5Vq5SGpFC4UPadwiIAm270RAB9lR4JL9-RyEZ3PVaRM7w
Message-ID: <CA+=Fv5SGu_Y-zwryrQiTQDy32SipMk_dfjZezth1=aZmnDKNeA@mail.gmail.com>
Subject: Re: [PATCH 1/7] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org, 
	david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 336018000B
X-Stat-Signature: pxjyn6tgmgqx33pxjoe5153o7rfg9p4a
X-Rspam-User: 
X-HE-Tag: 1763147648-72586
X-HE-Meta: U2FsdGVkX1+W03BHJRzWQENMQfvUQ9E6UW5GLKcFBe3Vg0ETLDoSAx/W3Nd+Th0KnYOtmmZH5EHRzpd0rpq4SZE/ve3jVl/QLMYLwNhFXlXySKl4pa/JjvJgO7rxNxPmdbRCufiTHYcrDNoJqqfSz7h7F4BZmMcvMZUZqRJuZEEQbJdA6qdOk/3qO9/JeW8lrvz7g9XJJ6AE86sBZ7R6ID+cZNVLA0NYpp9f1FBe1a6v5UJ5NzMFhj0e1UHGtchZAnPuVe64cayEskOVFyEaXFm0CUJ8q2z0uveF39I0/RgnrIW+3CxCJAkdn/8mjiQ4EaArsqRufmtWyrpbvrzyW234kKyCom7qiELkJmg5xSC7UEsTKQmqJcKiMcTMCvCbh94kyrTryt6Dv0OVbUuxEmOiRL7gz7aw4iUkZfqPS1KBbdXk7cdFawlYdnLkvXRbQrTySFgZ82rBEZxmXxl0CvZIjStvkGNmzpmTm1Bca31DN5q9JbC+fkm9H7nJ4N2vKiOROeRZbsC6E9U+b3Fp6kTS6JV9JMoAdBu8pVPYXFCB1LBqmHxyVkbb1ffoxkAI1AIvlv5UL7J5GxhtmaefR/5TsflCnSCvWwsmP3vE7hNNeLKLlKKDp4m9rken0U6g8/5CKMExVqVLjfwJU6BBUg4+BrovzNznBgipFDlKhExe5opmMU5QD+MtlmydWj9H2rJskpugtTbweyUjgYcauvIRdUQp0sN1KjWCVWcPIfSIst/mUAUqu6toyYctj4vH3/HAW50Wc95AvQCYh80B152nkcNfvhfqlj6EuuZGZupdFtcxAiLvJVXBhsFfJkKf/ADaCunWoZzkXRfabOB1gJfD1fhiOIQvBvLdIJ043fPQXg5/yGRDTBZQT/qHCDmBNSTeX1HoQwz+497Vxo8VJExElgBqFiORbfkJWvFvYzrmB2oZOdE21lMtf4Cuu03HY3wNn4+bNI5vef6m89D
 L3uVbxT1
 ebqySkjp4HR3ozn86BVJJyxP3MuXxxWxhMbE9/bDrtIiOgpyDhzV03DKsgtWsf9IwNkKX4gqjU5MlfOYZ8JSDkHXsA2r5DB3/YIqtn4i4hQQr/ntIcq27kcF3HY9EaNmPsqaB7sFuxJvQCaXWEwac3uZHDgbKd6jWZZZYTWxHIYvYVZeynyypYmH287aG/SnE+MBi2UVgDF41frYDKvQNIkSas7aqOzkI/xMubHO2yZ1OzujiXEyuCj1IbcwJFh973KJJY3btTP9SrlkQ+jHA6pMpGBnNUKZFpTUKaK9ZbGXrpbwRH62uj+oYJVuUes6XUExjsf2tomodgsWQGkH16Ce+BBWvsqDDgmGdoF8gpTiAe13pZWbERYkvaRqi2GtTvJYNaB12K69R9FVmLPfBpccuYA8KZItw0jjJskW2MiXgzeXSg4GdfHERjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I applied your patches to a fresh pull of torvalds/linux.git repo but was unable
to build the kernel (on Alpha) with this patch applied.

I made the following changes in order to get it to build on Alpha:

diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 7e9455a18aae..6761b0c282bf 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/hugetlb.h>
-#include <asm-generic/tlb.h>
 #include <asm/pgalloc.h>
+#include <asm/tlb.h>

 #include "internal.h"


/Magnus


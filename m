Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CBDCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491766B00C6; Tue, 19 Aug 2025 09:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441A46B0128; Tue, 19 Aug 2025 09:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330906B0129; Tue, 19 Aug 2025 09:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 205316B00C6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:50:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB646BB33F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:27 +0000 (UTC)
X-FDA: 83793641694.12.C5067B2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id F37A140015
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ii5siVPO;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fLkDwiiUZSss6sfPf8N7ZCd7V1JUEtWvKlq+l/gMKQ=;
	b=wm7/tPMpc3NT6ywbCBc1Qhg9MNj2B/uodtrrHfwnyhhUaUQzmZtcuyK50VSDKgeBLo5Si1
	WaajKKEgJEW/FIcEUByybHmtnWtYhFEUVn/HVdjO8pSfVk2eFpG6XJY8QpYPFH0fcIp4MF
	90uPnBbyhhD/Kqme+mRE3hNJQ9pB0z8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ii5siVPO;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611425; a=rsa-sha256;
	cv=none;
	b=Tb4DuryxGNjFTWZNhS2e1gmxJAhQorJa12lM12dCcad7XGPkg8QGbfoNWi1jO9FTK2oDu/
	qrmPJL2wGWy40e9vc2bSUDamJsjmuD8+20vZzEaQLo+r6FtfWJz98qomJFGtgyDgmANteK
	eO+S1cuf94cqvcciC7ehxlYE7o0nWJc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-244582738b5so42525605ad.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755611424; x=1756216224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fLkDwiiUZSss6sfPf8N7ZCd7V1JUEtWvKlq+l/gMKQ=;
        b=Ii5siVPORa9vb+D4lGra0C7CNqkEV4cvdbIx74XtJa3WVmIOT1HT2I8GiTj3BDCvCD
         +BIehjVlxDxId1HU6lnLRViJm2IJ8L7RMI5V0vMnbG0vGhwp/7dj+MyeveeLmIiHgSL+
         2dUCFQ/RIVO1iaLK87QyS5/ogaMJdti91r6I60GKIV+JneTL17Jn7zcoKI9DjnRuZDj7
         X5Qvh/w+YphZXhRHB7BJYHO/NLC9TMgtnF4B9B7ike1doSXihnPXHpw2iTx7uwD+sNOA
         UDE48bRfA4ZFAyu+Y+Pk4Odv/DUL1l6f1pa1n93GqyfUiJJ8q7NnJ35IEfT3alPTfvhE
         5evQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755611424; x=1756216224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fLkDwiiUZSss6sfPf8N7ZCd7V1JUEtWvKlq+l/gMKQ=;
        b=A8Sol/hQWICixKFwm6ioDlR/MJib8txEAcWl/5C6X5Q0co3iH52degvbY/5VeMc8Gn
         DAy0EoiL5krIZ8q83CSU71mvoyECJfy2l5+llD55/NVxW/ksfMjnEWWgya+jSK5im+Nc
         bL2uxA+IwptZK770q6N9/JwfgjDgNpeDHH9nlK8nTjrFxwAEUJP/zkqwkIptMJNA8zzP
         GzolEtljdLtkkJTo9QQEEY+P9ZXOTzu9xTfufj/iiX58rt2p3vwNpQ+qn+u3w85/95Nf
         U1qSRYz+I1W1cq1Kz1jHNe0xsGSnHiDYxZOYlBKDRI+uLkqaT9wPsV+29fJ2S+ootohR
         fvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjhs/VtXZDlpkv4UhZ5J655Li3BSKJ1Tu6r9fWMMhM2Fj7Y0YuOdkiAK73/OXGZbfbrdSm8WxfEw==@kvack.org
X-Gm-Message-State: AOJu0YxH8ne4Z1Keqxn76CPzLFtpRufXk6XTx354jPKMKetW4lXfLbt3
	BgYoqgw9lsz1SDlgZleC9DfNSXxPjVOi0XDdnMALjGS95MchptjsSN3H7f9iU7E/iOI=
X-Gm-Gg: ASbGncuLJmiHrhK06H/xWXIn2MHR/lwAsIiLavXXhA7fpxtj6xq7ZgML/ayrptcHNTz
	JBSnIdy84PZjQtq2vldU6p+3AaUzmpAuq1qa1speifl4Yf7zKzsV66kmzi8QrOeAKdlu9iWj4+h
	5xdGWNg6Cl8qiLBlmtd1i1KKS92sj+k/G7weCCGj3dMzdttks0koEmaMnRyePCwCqOGjOQo+BeG
	57VbS96r24IIJegEroL7ludNlh9wnOiAE0SGrz0qKJud2cWWePv0ZTGKKwUxDrUAV3Vkrr5cBt+
	j5BIgrv3r+nawwUWN9WrjA3v8Eq3qh+ZnHV8Z7TuG4eqzQpbW+bf9/kVKnHTz3pYle+OwupI+vC
	FpgB8w5RnPiqOUgYWyHd37Stsmytpr5dZ5j2iGrJvxJku/Ns8L+G8WAjn
X-Google-Smtp-Source: AGHT+IESvYgemIySPSxA386V71buITJEB5A1eQjLKfmg5oq42Sd+h+mzvTGReO0QPPNPP/g2BvgHbA==
X-Received: by 2002:a17:902:d488:b0:244:99aa:5488 with SMTP id d9443c01a7336-245e046e326mr36849155ad.30.1755611423589;
        Tue, 19 Aug 2025 06:50:23 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d5533c4sm109937815ad.140.2025.08.19.06.50.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 19 Aug 2025 06:50:23 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH 1/2] riscv: remove irqflags.h inclusion in asm/bitops.h
Date: Tue, 19 Aug 2025 21:50:06 +0800
Message-Id: <20250819135007.85646-2-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20250819135007.85646-1-cuiyunhui@bytedance.com>
References: <20250819135007.85646-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F37A140015
X-Stat-Signature: qd5tdpadi1d8ato8535xkoih8zfdb95j
X-Rspam-User: 
X-HE-Tag: 1755611424-164221
X-HE-Meta: U2FsdGVkX18lc7WyjiKkkX5TEIU3P4y0di+QJ4ugZWTjnu3Sz7SCcFXPX8daK4pCChZdcgdcZQESoenfdShQCFyrmOMZ+M/DHXcfLksGzQoJCt5D7dIzRHihhqMo6OoJ4Ip6PSG2/TuC22yYPpItlAsDTnuFuC5lmoR/lZSVMWjRsORp3eL/tf406DHFla7cseQcEvWocz7gEt+TuSnKgKvb1d8bGW1uNrhjLyAWdPAh6UD/t35wSHMCrZFlgs0gEZA+F6TSCvAauSGv+xfMsTtavQYOLGj16yNNU3G3V9r5uCVTYh5HRM6jUwmz26D3u/ZOqDZ3Ix1AqX509RMJvvkkkK1sM0p7XzUciLM+iQ2QU1gZm8ngXEDrtzq7CDFn4ZnM/zToFaV4o9zmIXTnokCzD5HQH4Tw5BzupLqB71IlXHJpwRLfhpixO38ps94DFVc7Rsjal4DYFbsVyE6LdNTfZ22/0TpB+imIAbZAJ0DBUxVnjMAquc/AX/Se/UV0X7v8LQIq8qVSTutIep3vpCDlkT99p204wKOUFO/pSha5o8DyN95G4HdNCltCWSO7THSgh9gZFc9O2z2UlhoZoLcfIVfEBeex/pTOuqRjwVfJ3SysimMpRQ3FmQM6TcMSd7soAa2MakHxvXmJ87OEiXts8J2v/sjKE82QhRU7qkEVlFPxFkW25O6l6EXBWyEdDHaptkg5pAtzM1UGX1s7xsLFVPEt6xW/khggvWSdDdG8/hNNUFy4NrvHUcCU2wrWmKt2gdRyRZgkTzzFoeuv43VbmxC8TqLeKJa4TsRsZ/REnkX+2Qu21f5MVpP0dXf8/UYZCXTbeU3WANNp07ZGjHdMXlYZh3OW7ZL3F6mtUOLE0eQj4IwxJ6MlkwwwVWtBifmNAXNCuPNnwDmOlnfIY+OiR+0nkrrMTc02bOHVtkYtaEZqYePyq4l33loewH3GemPQYaabiR9jvBy0WgK
 7fdh7lPm
 EBfvP8w6YgzOcBkyWU2DvgIzhYFiCVT2ehuPghoTq5VIYlHX3zPg4jkitrln1CI6K5dLrFcEBlnDoFlUjVx196pvNb62/DTU5OZENzHuzj5Bf0zzoeu67MTL8MVuAXPEhmHtXeDW+iunNe5CE/j1qzsIJ7MGMVdDaT8Ap1wzO50JI64vtcDAsFkiBNpGzY9mSBP9xA5Ery4LrZKuRFitn8bxviiv+DG+cpy9oyxxF8ell6tdIfjSEbC245TLf6TsEMw3O9TnSWmEb2ZyV6OZf54ZLYWln+qPjNrzx8vFrq+uzdDARLhp6tQg5NGDIq4R556G9awaoZ16zfeWBXOqofn50qunRzeBdODCjxe4wCuuxwx4CxozuCSybd3eSgv7lu6RunDIWkfAZ8SY9WXvgvNNFDzwe9rsBKVWW8CttJTAgvaszlWkNuOPEPG++x1g2QswR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The arch/riscv/include/asm/bitops.h does not functionally require
including /linux/irqflags.h. Additionally, adding
arch/riscv/include/asm/percpu.h causes a circular inclusion:
kernel/bounds.c
->include/linux/log2.h
->include/linux/bitops.h
->arch/riscv/include/asm/bitops.h
->include/linux/irqflags.h
->include/linux/find.h
->return val ? __ffs(val) : size;
->arch/riscv/include/asm/bitops.h

The compilation log is as follows:
CC      kernel/bounds.s
In file included from ./include/linux/bitmap.h:11,
               from ./include/linux/cpumask.h:12,
               from ./arch/riscv/include/asm/processor.h:55,
               from ./arch/riscv/include/asm/thread_info.h:42,
               from ./include/linux/thread_info.h:60,
               from ./include/asm-generic/preempt.h:5,
               from ./arch/riscv/include/generated/asm/preempt.h:1,
               from ./include/linux/preempt.h:79,
               from ./arch/riscv/include/asm/percpu.h:8,
               from ./include/linux/irqflags.h:19,
               from ./arch/riscv/include/asm/bitops.h:14,
               from ./include/linux/bitops.h:68,
               from ./include/linux/log2.h:12,
               from kernel/bounds.c:13:
./include/linux/find.h: In function 'find_next_bit':
./include/linux/find.h:66:30: error: implicit declaration of function '__ffs' [-Wimplicit-function-declaration]
   66 |                 return val ? __ffs(val) : size;
      |                              ^~~~~

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/bitops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/bitops.h b/arch/riscv/include/asm/bitops.h
index d59310f74c2ba..d9837b3cf05fe 100644
--- a/arch/riscv/include/asm/bitops.h
+++ b/arch/riscv/include/asm/bitops.h
@@ -11,7 +11,6 @@
 #endif /* _LINUX_BITOPS_H */
 
 #include <linux/compiler.h>
-#include <linux/irqflags.h>
 #include <asm/barrier.h>
 #include <asm/bitsperlong.h>
 
-- 
2.39.5



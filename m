Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 564C0CAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0C46B00B8; Fri, 12 Sep 2025 11:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88476B00B9; Fri, 12 Sep 2025 11:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E376B00BA; Fri, 12 Sep 2025 11:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1386B00B8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C5648710E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:50 +0000 (UTC)
X-FDA: 83880935460.29.F540FD3
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7520880019
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fxgpXtHl;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvjoC9HrZ6XyeC1MmkaG/lWnbuRS5G1sVQIYvweJDZo=;
	b=3AIzl2/tTEw49jdiCW5bIwrSGV0AqlmgPAkQuDYyOrEEn01o5frr8IY9d7+AoRe4d//btq
	TINm5Sjbb09A39iKTsL5ZKlM3aFxxM+n4CTNtlwnpxqUC1xDKvhnEHNAJRpJ1KCosnTmKr
	+k1vXlmgLE5BbaChr+DsXzJKUJdbxYA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fxgpXtHl;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689848; a=rsa-sha256;
	cv=none;
	b=Km3de5y3HFVfiADUz/d7CehAUbT36ZQhc77UKYAADdZnXER4r3zmu+bTIW41W50tawZw0O
	ecprI/2uDxueUy825+N93f9hSPOHMm5XV5NeF6bFhYQXAL5LkJDR5c1+Dq/Omi6RmjWu7M
	pp0aLD+cxwBHwHJT+aIJyQ5X0whae2w=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d71bcac45so13894177b3.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689847; x=1758294647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvjoC9HrZ6XyeC1MmkaG/lWnbuRS5G1sVQIYvweJDZo=;
        b=fxgpXtHlUQJoag26fdnRfLXaoxlsY30+xVH9auOvVTJWD/MlP/fJ2MbMx9eV8ATprF
         eokCGkHtk+sJhaY5/gY9XAo66CVhXT1B8hrxtL3dCBh3ifPzsUszhBwa/+3c0DahKRTT
         EYZnnV6wF2wOXTyIxlJte9zfLUlhZKAhd/6Z27/DCRN6xIZhiS0Ng0UIbLUxTrU1e0mx
         FUIK6v48fYrhAj8sbnTpNuX5is5LOf8fCYCCQsC9o5VcpygZU7z6j1n4xDfvdaK0SSIn
         U46vy4XMN/0bm30jzm+EFR18PPUSBe+qXP6JdrJHIdzAfXsINLNQx1rOdb7UbBXDb6pq
         +HlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689847; x=1758294647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvjoC9HrZ6XyeC1MmkaG/lWnbuRS5G1sVQIYvweJDZo=;
        b=k5EqEhEBEHTFz9mhZDGJvfsHNBW634nUpkU5KPmMmLYKcS3hSaoj8i5TYGvSfjz2re
         P8r9C3XQ5rIFRQ8TtwxFksPaLtlTr2J2zb0UlKYfMh6WtqSD23urcdWKcnRKZ+LMMTgG
         Yryjb+iSW7whnm6ZjyW/0Irj3cHGC82nIM341+I/HmK1MEX9ZBvEGjAoewyIXvSr1PWN
         pFMP9orrRt60kf0adOLlGA28PDocLEZDG7f6eh1WhxcNQlEkojmTycNKTCbWif5Tr4JJ
         iTZ9P8r4qHetHMygekj6JgwRZyHLOiy7berOBYklAc1xsqw+DUGGrk8vcoHILpPHRYhX
         N2Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWW/pVe6VcxkMzYab4Wba3ATM+bXIZ+N4g19uaZjKjgZ1Cpf826KzNpzU6WictXbhinmvgJJ8skow==@kvack.org
X-Gm-Message-State: AOJu0Yz9IIp67Q5/SlGHKeIu727UnJ6SLDVz0a4JaPcIUbfFY+DhevSm
	Yg7kjAmBEaCRsN2NI9wXRCsbE2xP+uvlq2jr89jmVmL7PRGHMj8rVyh+epFlROj2U8Q=
X-Gm-Gg: ASbGncvFwYpOhGOXpuZcUsMr+gR7jnE/EELMS8zvCnsFkltxGv20NHnLSTZJQGhdsfq
	NFcIkIZnvkFmv52HY6uzj0LsC2F8L33zcQcdHYW3Zc5sBqYCsVUxs5Erg/AtilnAN0fI4Motm9Z
	v3o49aMo/8l3PAStX/pzBaQ7Omtsd/9f8D6qnB44bkPnGZy/4XMrkg4PvtS3DwZtzFioAjgdpqD
	jt3FnnVNxwPxLRPMO7qNPln+G+XFPYeyDx1pw2P2k+DXf50r1jFRR5u6wEUGjoQi/h7Rfh5AkWv
	Sdj0bcx7PR/ySBiXruxJ2eDydt2C+kLa+Y6PeLTEaAOmnYWXbByfkc6xOmBBBAjASjVlixV73ZD
	0XSFdZZFw+tBqHtszkuW4nYjvRxR3hOMIsQ==
X-Google-Smtp-Source: AGHT+IG0Y2LxTvBY/AtHJvp89fVFaBOgxCKmySrObEvM5zSsJDKwSvyDpIHnZ+Ay7rKBasM7LP2xug==
X-Received: by 2002:a05:690c:768a:b0:731:1bc7:7830 with SMTP id 00721157ae682-7311bc77c1fmr16987957b3.23.1757689847322;
        Fri, 12 Sep 2025 08:10:47 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:47 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 11/16] mm/swapfile: Have nr_swapfiles as non-static
Date: Fri, 12 Sep 2025 18:08:50 +0300
Message-ID: <20250912150855.2901211-12-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7520880019
X-Stat-Signature: 3m3cie4zwwt6sm1zz5xodatnujezt7s1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757689848-575312
X-HE-Meta: U2FsdGVkX19iFe8ptRw06IFh2xBNab8DwO+9mfejturfYvTIpka98IxcFHP7hm4Lz0000f3GxNfgqgWUmCyjraTD+9SMS2mIzvfv7lIR04+5fmDjbNa1kKe7dTwi+022GTiudG6iDpbme4m4DJUERViQMA4gYANGlZXzCUcLpSqot21IuJmzMW6bHCoTJl4Q0P2douMC3KjHf8Vz7ETc2hoUG1MzGWcgWOkDPCmN++j6S0wnlA8YX1FZdb79YIxHUUv14lzu9qY4dUur3mpYpPnTkUx+4lm0yNdCb+4i7no0RMOmO2ZkfWj/5auJGSDwffW707zoPrKcTeYrtWxFE6aDIBWju0Q6RhgFXkk/L8jos7H1sUWH5Xxf+qvpioWItVbOabn61fw3/nXX/EtNDuZd3EmwBMz0NV7OQyvl1BAp8sDSlbjX18ZdiakMQyTahPJkgnvUfeGFXFAOVf8OkXq8qSy5ywLBUx6TZGXD4OJkeRY+FswXf6TMg6iFT/7Tr16Wh6sw3q6AloyMqFgAmKLH4bpl4DfmSMkB9MLnwpKJ4KjvgK+co5WwAd6qqXdK+Dg3JghpU9TPgq9FN9zAvj/snzXQ0/LcO41FisCfjX83tMgR8up5BnjzPxyMg/V/xQeYzMnVn4I4POKl9WsV34y0EjFJfNs7JPpr7glgKSNTm3vygmPfFGXjr9IeO3MuYk47yJEGoudxKl/kVMQa/irPZSlK08+HI2HkQ+AG3zc8nPn76I05+6BjOUpd39MyIXeuCJ7TtnYFO2fGOOyJk79NedydipZ/94CIBna+nDARyJ1Dv+ReuoYDDRX6IJYAzKwnph0PQ74p2MumKXb0aPcXYhbiPiuJJ721hSGj0ySyfXb2UK3q6sUcqFyzHrZVFne2Cloe3rHclZUkbO1PXy03kI7q/JDUTc/BZBKaIesqRs5QH/FdbZimrUMx/Ak8dbiGiqREFMxnjzwKbuX
 IQ2AUzJj
 fAX7vQkzjx1EfV4ou2Eixczmmr3s8Uq1PxwJwVFnLLE3/3r5n1ruX1qvlTZYLynjonK7Ufc3YhRcSm+UgB4AA18d27CYi25Rhywi1eHtGUyP/tP29sY1ws9MCXaEv5X2sMT7QkQ868MDveyy2Z3Fu/Re2WZOUBdKpTLGj7xwD9VF1wWq68Ky4R/DkyvW1r2Q/vQF7gqxraAnYJX/2prPo1Q4F5cdFPe97hd8PwVG1y6NUj0Mn0GSsYWbM4hF7EDK0PDA8zLHvj5qUaSw6HvKZ1Hyl6CTxfnufoU4UhSy1OASkTwlT/S5thrSdQDTrq8UqKQGxhdCmCL6bDvuuzVufBJGhUd7CgkJaq6U20CPY9fOt1c81jzEfCQpwlJb4Bgo0JICv1HLZUN/WSgrSsArPb6g60w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_swapfiles is required for debugging the kernel, and needs to be
accessible for kmemdump into vmcoreinfo.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a7ffabbe65ef..2ef51da2c642 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -63,7 +63,7 @@ static struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
 static inline void unlock_cluster(struct swap_cluster_info *ci);
 
 static DEFINE_SPINLOCK(swap_lock);
-static unsigned int nr_swapfiles;
+unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA39ACF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B706B0010; Wed, 19 Nov 2025 10:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D906B00BA; Wed, 19 Nov 2025 10:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE516B00BB; Wed, 19 Nov 2025 10:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C38086B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90B074E757
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:37 +0000 (UTC)
X-FDA: 84127781514.08.51D23CF
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B2ED4001B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fZJXpEtm;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuFAdi/dQ7TYcP6kPKC/D+o7MTxWjWW8Ku2RD10GvbQ=;
	b=Bf1gpADFWwYZ9soXvODcBuv1sS4G00+OzhrWg8BnX2B9XwuKERKoKEzzuBkRY9uPl2xGWB
	2Z3K15ALS9soZKPHVGp3pAj9qXHy3F46+bJOB1uR+8+HlGva45cVHxQ8JjiIrD+nBvarIr
	YkVbERj3vfflGWfhrdGH+bfbo4+ZGgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567135; a=rsa-sha256;
	cv=none;
	b=toG0U2tUK+Fs+NUg/sSu8RcZxg71VD0rN6q0UuPPOErC+l39MoE/bQ4ha89JMzwLj5Vmes
	fw8/mEvkiKPAdQVcZOC9NTd0t/qtMUS3ZZlXEByNguxif5qqDrreGJ726cQOKlLMLiYBgK
	K1hf0e0Wk1mUPqSkR5Vqz7NsMKaTA78=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=fZJXpEtm;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c48e05aeso712917f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567134; x=1764171934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AuFAdi/dQ7TYcP6kPKC/D+o7MTxWjWW8Ku2RD10GvbQ=;
        b=fZJXpEtmAALdtimE01r1onGJyS2loilOdKTu9Y0mKPhB2sYzkA0b4Cd0+SqxBhlGkP
         DFqPS5mNDYtNdl+faijMl+UrkIWwAGo0vPsTCLpZZKNnqR1+sb8nXHfc7iSB6yf0726O
         2CLbj4EJ1SKj5IMU37cYQlEWsn0pW/yTCjZeXvFjs2f8YlRs7Pk77xjJUv6DHIBByu5g
         34iBHIzUSOgPV7wA0/qqYk81Ga2NPSrvxJRctEq4jUkeH4LB73lSMjZOfYbBezj/K4Yn
         2F5T4asszEKHdJo32bycVAK88hyiHe+B9r367Q36huacvy/wL35FTjK8H8wsmNdXaHzi
         e7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567134; x=1764171934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AuFAdi/dQ7TYcP6kPKC/D+o7MTxWjWW8Ku2RD10GvbQ=;
        b=jiPW00ulzkqwfkg0H++9NdOyVbA2MTFho8UhIEDGmd0NZs8bXmgza+UIWI9vQu1EYa
         Hu4O21hpUHNwZUTN+aNVRIFNUjcuGU8QLjQK68AiuVc/4PkaWlTGZjM5z+/cmFmhrF4V
         fFf4hhr2rxqmq4kMlGWgcU3ESePN4JCU/mrimN4ShfvA86tKIBwicKjvRyHgvXQg0XLu
         rdzyZqTSqWh5vsxL/e018akQs2+98HnpgFpz5Ow1HlUlrNcWfOeGgLFIzHZrTT+D3JW/
         kmKyxORUymGpMO+4Kv2pnSN5IpBJOeKqjqKbDXR+hhtwLq4ktnqFGFe5IOo7sckIai+n
         R3UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTHgxKg92/nIMA+BmLdx8kRKvTgdmuj69xG325qFaXsSHIRLOT5/sGSVtRVRIx+bIQ34mwgt7NEA==@kvack.org
X-Gm-Message-State: AOJu0Ywo6SU2w3VvYQME2DAWBPRQHR23xIdBxrKCIXdDNmKzzaDm3MQ2
	4zwvGQ4g+FoVX87XRFh1431vS6Ty2CCJavGNLYRCsQZzQ1wE60Vzmkl9tQykpcLa3Zk=
X-Gm-Gg: ASbGncsXbt4ppq0i8qOyQog8siA1FLH6z0gqresYYLQI46fsOM+GQDxuVgWsVEFS7YH
	FncQSMSEmtjhoJ1/kfAkvgxma3Ma+ypD/GqqxJwzXqSPzJx2y0xM2bmwx1MQlc7IbS2JCTAcc7m
	wM8m0EZPEQi5cgbOR/mV3BQXG1w7RtIZtOnmVV6y99860GEzh5axv/rO4ScrRkP7SlB2qu7ZVTF
	R0R/e9TlS0+3fCIVntgbWoMCSafq+3NsXZeGTiR+4NkaMSnnmlU7RXSbjGRQiUG2fyXpp2OkDqq
	GhpFybvSINFBzrGHrvifwbOvkYBm0ZFSKCRnyE+dTpRJBHu/3ey+xP7OuKbwlKFhHyi8tJozpyy
	I9tl3nB/JyN8a0wQlM/W9jZSGoz086SpRD9mMs7NN9SoMltbwta5T4lhcdRq48ac72pZXVJcUf3
	xQI8QbA/eHOQc3571ijdFSqr6QM94mXQ==
X-Google-Smtp-Source: AGHT+IEEW1UNe8+i9pRkQXcVi1K6qHmkkggtbzPn6ocK+c8Bp9XYSPJPKkUMg9h5XQagLem1rvsEdA==
X-Received: by 2002:a05:6000:26d0:b0:429:eb80:11f5 with SMTP id ffacd0b85a97d-42cb20e4a02mr3468125f8f.26.1763567134112;
        Wed, 19 Nov 2025 07:45:34 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:33 -0800 (PST)
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
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 10/26] mm/swapfile: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:11 +0200
Message-ID: <20251119154427.1033475-11-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B2ED4001B
X-Stat-Signature: q8p7gxd5d8d7jwrrq9cx44eeomw8hwbk
X-HE-Tag: 1763567135-629211
X-HE-Meta: U2FsdGVkX1/RtG8WFV+gvXh5Lqw0A9V2DrEzE1Kb05vinwtpauyxpD3mryLvQYeRuL0R//vIaprTXeoiaPAKnGOT6D6t+Uk6ssgIsXfdwfJ0KvURceb7DiddvDP4LJjYlDx0KHBi40XYRfbulxuWzovG+Sxo2WYyoi7s38g4sRjYY0ib9L4QWMKZdvxOig6XymFB0BJjaIWsHZTxcuQMi1W8dbsvYdIyY5KtTKiCoD/SdSYgmY0ftGWXBLCW5gI6bDboQCp1ArceKMBhcW02gQKCxlCD+wznSJFRzNx6G4yBRaJb4fiCwg8ZqMxDTPG426nbkL/yNwRhVB24XK5HD9yXqcq+rAak5rJsTqJWJ+ULcwleXO9MLSLNzoO0zK/AHse5DKGJ0SRGQOzx3ycHtbj7aeBts1VmKWM5oSkLZsUDtFzNXWUO3D4BotaHYutdpUWiIrEQkPQBWhpCKvDMrFm+7AxFn7cJIkprFUImRv+nKY6tExzBBOiagjQLNgysotBtLs9BU5s3MrxUOxmIo1bMYnXz51K71eCREUXYWRRHrFuwbOLTesRRz3zYXndH5wcOdySTl3wHSY0M191Qps4b/gM5vpjMwYmsGdKCymzXrW3Hag0QmjyO6brZBq4P9i2aoCIe5QKkvJpVyBS7yGVUi4Lk272oEYIYY4dRYCEvCNyL3GnowZl5UIz+lIIqqSVRlR4RV9jlg5jNDPwk+d0hdNyWi6Dq8Kjip8zP9ITrhusWcicXr7e5eJt33SiGbGRH7U8iJB2dgjaIRwX8NZGBIO63jhMCodhDTBE7eXvsd88sCk6gZG7oNz6MaRn0t5udniDj86K7o/VDCC9Rv/zB9EU4OiXlTU5ssOmCLjQ59mbVuKx0305D/D1mxK/Ewkqe9AcWkWtxmHeNmZPod8bgcf7rglYuSmvUecPsEYuE9Z2Sz+bWxR4oFDXlwqWeia7tfX/0QThW74VbwC1
 tIvOIDmE
 ZcwwXN7Vx9NEv6EWmlkbiZfbuk+VKcvUo2amlSzwYdCmcYQat9e9rCAUIUBAy8Cp6XaEpMx76Glar/8SX/KaEe6ETzSkv7Z5V2GCUUoXZXPPeUVoUk1QCsGTvrL5dfyR3TNrMDX4CqJKB4AtSpGHvzBxY86KzUtEOTHNi0VVyir5qodlNF+XJgT/ly+igYdvXt8eQ7ZACeZ7IY28ET+8cGIqyIrth9jEBOFSqiwGT378cF0xPj2KdFZ+0Dnre5u2R+B97uLGytzt+DKM9IUhXZNj1/LyTar+BdN+JlUj7bIznxcOJqRnazLTQtp49OWWs4BnSu23biiVclQUkeU19k5Zmat6J8zzpvJbojQjvE6edoWuNQmF0bxve9DELQkR1kKqo5NecWl0OOwtVWQc141qVoIGTC4M1mnD6nP2TseJ+zsIQcdb4OrSrS5gUtql7Ozx1GPzZ4PhCR6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - nr_swapfiles

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 10760240a3a2..ee677be19041 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/meminspect.h>
 
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
@@ -65,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
+MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);
 atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under
-- 
2.43.0



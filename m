Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05EC6CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB9C8E0014; Tue, 18 Nov 2025 01:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C448E0005; Tue, 18 Nov 2025 01:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BBD8E0014; Tue, 18 Nov 2025 01:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 304D68E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:09:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF08413AB3A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:27 +0000 (UTC)
X-FDA: 84122700774.12.6AE7B61
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A72A40011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8tePxgK;
	spf=pass (imf07.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEgeRPZ1WVUAmTyDqrYk51gPF5hM55Y+9UDrOi9Fr0c=;
	b=CREpR1XqsOymxrIYcaUMQvCAJ+fenJYUTLwnXb62MMTeb7MEVkCMXy3IjiH1p9aghfdlDl
	Vva9dg/aMfWKjvO7U1AMhhMTMxJyYtnV33ahjOh5R/ylLOTgKgZBlbto/OGX0Uw04wBhef
	7QjK9pCGPgGMbCRs5X0FEK2OhYm43Lg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8tePxgK;
	spf=pass (imf07.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446166; a=rsa-sha256;
	cv=none;
	b=1tiF62f4qbVgNWlr9q5L/EVzU+BphAk6JJldB1MbEbJGStb91eWXHQ0qUcubUyQGfgdn5M
	4MU5yg/tEcGvlGNiNmkd3TFdtJnmU7W5PXPXJ4LPhZ3raj6UR5SJ13KaNn2gLt9KNSHmXN
	n7vo/2QtLinultqri99MIRprQPd3Bgc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29845b06dd2so58864775ad.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763446165; x=1764050965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEgeRPZ1WVUAmTyDqrYk51gPF5hM55Y+9UDrOi9Fr0c=;
        b=E8tePxgKYCD2D/4xU7mu/UPXNjB4xruvXjF4YDPl6Vl5rgKyRZ/8rQIo8AbIPGiT4z
         89DuD6Nr9LjPCRvuW6oi9ajHBmUcdPjGSN0YLlF3LiXHWvcDuWk6NWXyQeXILfkD2cJY
         gpv9FzlbRhnRxy7T1ACGlmHqpGVm9ihAhTcHF23Krviik0a9HMnDd6Ux4G/GWwtF4rV7
         IlnjoTrzHpGUNPzUboaFxEabv8f7mJkhBfMgy42oyfKEzrOjxg+6StXlIRHujQOKutgr
         VS9T37HPpjoW5cIrcTtknI0yrfVnVLQ6KsMNeP6WiFUFKzAd8vlLGPju254xT6zcDBLk
         /0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763446165; x=1764050965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WEgeRPZ1WVUAmTyDqrYk51gPF5hM55Y+9UDrOi9Fr0c=;
        b=kg8efmVM5DxZCE/bQHukfsMW/+9BliBKNbVxGDBNu6OLLxwDuXpPbDQ9pY4++cnAhN
         uJKMQGZgNRdoJi4h8EbMyWPz8us/3M6Mye9ZO4ug6sfIL89Y0WeOLGxTqMeFtZe8Am/P
         Zc5BKgQlVibENiNjjLoa+7ckeekjFIdmlQ30TB0Im3kejB+fF0yPcc5NNZJ78JOhEoZ3
         iqKnpkWRiSBi2BEgC4HMiiPm2mj4beAE6PUPCvcsW8hNDTpqmv5kYINiCyQxa3IKo7aY
         4D/YnyzxBJzDG2F+9NR6hAz7bAdXpaHXfFt0I3dpdnQ0pjwl8CptglpbVBZy3B745nxE
         crEA==
X-Forwarded-Encrypted: i=1; AJvYcCVobVXIRsv/pXa0DaxrE8sOA9LeWT1TgMibmx9X/udEHJt9e5imrx5M9p4G8iAzrNI6EY9Jnt91Aw==@kvack.org
X-Gm-Message-State: AOJu0YwUnaJnGYL7GWDs5dkm/qNgw234CVByNWdQ1B+IUGwGEHAUktFk
	ianTyvR/0XDiOer7vpZEDKaFyqu2fUbrPeQ7HyygsRe6PgQGe6kNmbwY
X-Gm-Gg: ASbGncvaz3NIVNz3cRb0k42uA58ySFyqvMcuBH3z1TZSstScWO+D3Qk9yQgLIx9MK3F
	oHrqZB4GXZkSUxqDyVNODwukioXeDKMEMObFyAyyWGHHsx4RIThlbI82d7XFsLmrYbK1kHip52A
	BXn9A/3MzbSqKVSvc1D0TbfcjfMVMPQd09RiedhEHgQDqpI1B3gHTfyj8vMBwubTXMV2I/yOeav
	LSyNw+mLb3c6W5m8Ungu02EVqJ4YzER9d5u0qgEcGNscvIMZ4b5meWwksofJfo4Y97FdPEOmjLa
	ivxQcaejylZLphQ9OLPk2bEBQC9EwY7gXBaFPaKWFmB3rvMFXnboClAiTDQVz7xLbNJyvM5bkNq
	PSAKmItgguq9TTpfS6yKl4MiNM8kV4SrJmNstH9paJLGjjSdp86+WghZg7sWtS2nCqhJvOYtAIk
	dcH0HVyqZfvhl/mCI27DyX8kmYq9SXhG2tdhqd
X-Google-Smtp-Source: AGHT+IHR4jT6grCSM9DxBMtGcN44xRUf9MF6cSjBcdCwzNXajGnSdM3Wt/G53xPYXfmlcguV3TjMNw==
X-Received: by 2002:a17:902:e84c:b0:295:4d97:84dd with SMTP id d9443c01a7336-2986a742d00mr159697895ad.51.1763446164864;
        Mon, 17 Nov 2025 22:09:24 -0800 (PST)
Received: from chandna.localdomain ([106.222.230.39])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2986e5ef32asm124461135ad.39.2025.11.17.22.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 22:09:24 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
Date: Tue, 18 Nov 2025 11:38:51 +0530
Message-ID: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763227530.git.chandna.sahil@gmail.com>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A72A40011
X-Stat-Signature: aug6s1qwyq6zon5a8rw36fn1j9swnfyf
X-Rspam-User: 
X-HE-Tag: 1763446165-92414
X-HE-Meta: U2FsdGVkX1/EBfQYWzFtM7apPsqIt4XkM+A0JhAPPmzQij/OUXqBsVenZioIr/Np4R1h6YmN4uoYjpiHhAPCGP1jk3zfcC2tNPO0s1xnrZDWMkQVJMUxF7PJmibwfBaVjrqNflMSYMAzWNZ3lqXYtBwsBX3z0A7ja71Vd5UIigN3rAn+9KjWL3jDf3G1lRsWN9QRr/okzmLUTp1v/ydug5hrZvHd2PrGoh0hF/yKL4TAukFVb9+//4FW62wLujePq6/5cloD/w/MMAm8ViCQ49scBGqFZKyDDa7NxAScfO20f6K24eRd5+tP/D2zmdBlaE8Tzaxw867qUTGvH4QUdJPmHIdyp4Pxk4tewgTB8RIPy5dNvT03eWYlX41pZaGbkoyJ7Lejz8Vm4NU8R8epd8P52qRVepJKhhOQR2eGgyM0FbOFxrl/MFQlsVWO409+sUJ2YxOc6KYbF5fRIq2NJARJhWfFHdQ0yQ08HYGdvreM0rOgkRSptzoiKUeIfOHLwz/JWOND40hX1Utff5fK7OKEPNKHMw20qgLJJcJKEgSQgePfdlavCGLNbqMQCvuU06QbBFFk33Mmvy3J8pWutFQOXRJKJeGdV/KoGUK8UhgGHbwfTR2X+4rAk4qWzyzM8mEVnsRYzWUfwKxjGmMBQCkYnr/WDsg3FfWwO86nfL4Lwla3OxbaO38wwvxeI6MiazMBM0nV8WqeUVhPtWa1DvPPiLnUHEh71oJxq5z8eTDodW8pKgvNIrjohipmPwaQCzptypb4ouLmlboE7/FMA6p8HXAHdXFtKD6j9K2ct/quO84lFm4prSXG92EpwgLgzA2lKi4CwEFdh2JeE3Zq4SujCPsyEIV0lwaFwpxrNlmGwaDBZTeqL367glYebHIReKcMAG0Tpo3Luei/JT0l3Bm3qF40F4mn2dxK13Kx/SKt1yrBr/sFx6cgtQpo/rcWU1s3SsfRPpsVRDEA30B
 VLx8BTcR
 doGqs9UyzS4gncRAKQ80eqLFYPMha3qh3480nIuYN2VMcJwID3PAXVkpKCOv2mJy/HeTX+jjxMuqjqgrifUOjtZf1BTcT91pWh1XGRduAzQovUy/BxF5nuSkspSWXgWHsLMGT731cDQCrJ9wWg0NFbERsfZV1N8MAp5yDEfPzsHgesFX/3lZjY846sEJPZ3vG/FqjOLEitnRvBuL8e5rkmVWKpf3QLwvsOtWyvmbAxhruL74z3uctVzxYPvAb16TtNy2skbHtS+7h1rHJnnwUEK/J15OG/SjmBeOBekZuPzWtGC8cSITOR6bZK3G1TDjMFT3Qr7Y9kFCGFo3ie0oK6RmOa9R5gRSaxZ7iB+FlNRJodbb+WsTBMprzO+UH8LnP04IamQRT+2rWV941XGrDql0OSoQACakBUDY7bEjTHQHBLlftTTSDd26/F5kxMEvRiCN6ngUddqRFTJ4DEVzePsa+t131Kq3DzmnXlYX458ASFnwuDBkcOme0pxx3Yb18C1rGBJs3NzDnCBwLd3lcYqu/dkAHfxDUUIc9ATG5Le5yd+SAI5J5uFgemw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..c35604db32ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.50.1



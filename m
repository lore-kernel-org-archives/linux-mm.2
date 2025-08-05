Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15836C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66978E000D; Tue,  5 Aug 2025 10:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC80D8E0001; Tue,  5 Aug 2025 10:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6C78E000D; Tue,  5 Aug 2025 10:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7CEB8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D1EF1A0271
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:39 +0000 (UTC)
X-FDA: 83742929718.20.2A2BF70
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 864244000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K+ouiWfp;
	spf=pass (imf07.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUUI2xKZlk5/jtNpSyx53EShjk/LU4/amvgKSzwK4wM=;
	b=jSbjSLCWudJMM/VSvxc+tmXTbowCubvmzb3YYyADwtlJaV3TGU4z0VPSLMZzMg3ZiurAQ0
	mZ3ejTot3JNRQPLjK03fz8dGE1RFzu8u32D3vbmkIdqevy5KDOqYf6gZ0S80jH+YWv+1GZ
	9Xtznjm4j5GeIf2/s0Q35OLmKRBHInM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403997; a=rsa-sha256;
	cv=none;
	b=llWW+U5L1B7wg8oGnLCCjbjChPqtCwqN2TJxosgtPcaTCJSdk6sPX34DbAddwx+sEIzHaj
	G5g2cOzSRwce/CmoENiSZGeaGpck6CUt0ZjgFwN7skGUI2mOiI5uAVnUFMbXCnlwWTb6Rw
	FlSLcGr1ZZxx2J8o7V0caSZUykI1QlU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K+ouiWfp;
	spf=pass (imf07.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55b96b154bdso3368327e87.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403996; x=1755008796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUUI2xKZlk5/jtNpSyx53EShjk/LU4/amvgKSzwK4wM=;
        b=K+ouiWfpOUWQ6YlOC8GpV2bT9KOoXrkhGA5tu/o9oPNFIxDs+yAxH4TKv9ExrbPgnJ
         kF6AVuU25tXfeJ9EpR3tqMiym3exnl5fetwNLwAptgjKUZgqNgyBCUz0rohP41nJGUYD
         htrgBDIfZz5iZ4K/+/w5ZY7a2pAvxrc69hPU4gxHs7V39zqXoaQ+4z0KNg8iETMtX/eN
         gApWbnglyqin2/VfdXLFuWk9WnLqSa6JvZMNWXOazBhE9cQ0+q4EZUkXOxkoR+uI+yml
         lLU7miPj2/sbx+8Qs2UHrqENcY5YkLD7jtQ7Rf69mTixXmpPPJAaZaZKrZM53vlChaDN
         KO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403996; x=1755008796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUUI2xKZlk5/jtNpSyx53EShjk/LU4/amvgKSzwK4wM=;
        b=kOqiRjplsQ2EZ6UAHIJGK9ceWP1pCbiwxcpxjhEYNBBmaoX9Zj8jhbZmJX3d5vKNUF
         U85ttbIbnJZimWDf3bps6zEQQYrLKhapgCIIV4sHDE3DSCmFEGEHSeY2gEtU/8vqrR22
         DjrmMIGnVItvkuIKTlbWCZFo70ZViovxR04kJKqXyHnmnOXf/zAaLa1EbB8D3+TO+qVi
         n5GFhSiMck2F4msFbFH6r+QpMQHkCQvwyxIyMpdE4vOcTU4N9HBLL2LA/7wQjPEizRhE
         YEb8dOdQWFlpmuhEYLlOK0RRycpfQnjkXacqe1mpGscFM5EYbXMhtLu5YqyANVreafLt
         u+6A==
X-Forwarded-Encrypted: i=1; AJvYcCW7V1l3Fgi6nGmsGFSeMACBIu4xOkr6v5P9HMPYmWl3O44Y4oWvsZwjACMwUP+2n6sFzE8beWFQxw==@kvack.org
X-Gm-Message-State: AOJu0YxCrhnfE+70t1lobln0NjfO7G1o5vwLhrB4EUWk9tFNkEkvtgL9
	IfiT3ty739Nq7RgiW8UdO7rc9BO/u6JCDk4KXyUJVgy3MHaWRmBFrKVj
X-Gm-Gg: ASbGncvQEL67l/4Kb4yWroeo3rGt3ZjkgwUgwzwCC6QF2UXHF5iecVylDxDCg4PVVGX
	Z94BzbCNMLwwG95+xnlljtGSDPpnmCxZWHWZecIJG+QNQJonMbcB88xrR2tbRWA9Vr7UnJR7hfo
	WcdOGcLVEHmzMkNO8tj0bb05ZrKyfTF4Ktv92yCgB+Nd2+PRv+okca0cGC7c5x5ocBZvFkShKk2
	Ab+VVCeUmdffYMmzJTZFy5KEQ6ouT0775lwcTObOvNblk9mABzuZWAXD97MERKZlDQVLE8hQi26
	RWLjNvWj+2ybmGnwRaz3nBCUBTaOVSjOhDeuyd0XPT7xv8+xjaQ7e2pew590BoETET7wbupcD21
	pa82Uz9AORjeBzuUZ9S2pbdj0pppAlTPueRtFrjR1z4plbKdHSseO5P06GwWBioHU4UJ30g==
X-Google-Smtp-Source: AGHT+IEuyOphkquEE1TcD7oJ1sEAoZRW6geJFjdlevxIlBKJ8sCVOgd5wEIObFEm35WGh0DuMN4+1Q==
X-Received: by 2002:a05:6512:228a:b0:55c:ac98:edb6 with SMTP id 2adb3069b0e04-55cac98f040mr114526e87.12.1754403995715;
        Tue, 05 Aug 2025 07:26:35 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:35 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	trishalfonso@google.com,
	davidgow@google.com
Cc: glider@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v4 3/9] kasan/arm,arm64: call kasan_init_generic in kasan_init
Date: Tue,  5 Aug 2025 19:26:16 +0500
Message-Id: <20250805142622.560992-4-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 864244000E
X-Stat-Signature: pwiff7j51cytznrwqom35mzttoko4jny
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754403997-29934
X-HE-Meta: U2FsdGVkX1/DBUUPQYAXpb4Oo2PNUxGeTO3DGOltfzeEFiCr3n/jWkwjHvQOGEpxWJ3k0e0sNXIB6t+3m7ED9fXU2JxxoxexjzNquw4dfTAvM6G6bu5a1GDwXfuxpdP6Hxu+i3f6i+FBVunPHPC7rJW8kUGeRgQms4VbNKSIyKz7ii0xXK5Bv7AnOpoRXR+zVQgAT/NdJUWRQSLofllqx1OmLtqyQCpRap9LFl4RE92062V26X2GnkIwZ/cel2MEud9AzifbPJXl6hOfqoDbuTjAV1i+9/+K7ZBdiZnd4DTcS7mkoW43+mLXhJIVHV7Jy5sKNmkn3QtmxM4uXXhSQoJUBQMo+4jqqVaRKJaz3Kv75WM3xFeOwZA7YgCpTAbZobdmS4oURI5NbHALgHzFUXHhS58Z/5S9nNQNna++8V90Lyaax/5jJ2gNfQI4ypVmayVJfAYJqdy3SP86paeg2Xf+oUG7Zg1I9d3PyllpRwULBYHHE7H2xL3iKStEPSjGxXlxb03bZ9sSq/3Qh48I4lgOxEy4XkGTmB/EialE9zeonKKH2bd0QeSLqcLYSiBhlHROTGb3YbBQpN+rOFfKSJgaUJhqsab+zAVBg3Svy/I5O4kXSWGRHfD4UC9PhlOSzwGux4+AFih71mUiDGddNvkamLzOduKgxqdzMqzdJZD8xG+m1ubQDbq7XwFu2ysdX0xZ8nYfuFJ0cN1y29pXpTSAEr0Q7lyU1lQIat8LGGfwVPz0/pxbMR55BJwK+9RQ7bwcP2T21Tt67UUWE2x9BwCqGw1rtOK+/4ysGOWbLsgzRbh5a4NUSlmsHimMju00zlvDNmMRwZ9upnq9q5uko57BTk2ImN4TwWnsxLoG2nWC0VknrJfvc9IfzQTGb92rG0Cf0eTAp1JlLpCvx0UWvtCwvKyxIZZY6UGJ+AtSRZELL3W6zGGsQvi/rvRglouJUjeWj0fnujP9XAnDWmr
 52e0v3rW
 95t00GrCjXOGeeppwsNQGXUifmfmgeg+Ul4HfdH0V5UJSN71BDluM/0DO4WVnobme/cq1U4+cC/wAVvEpoP9izr6BqjLXlRAI5MR2cEs6JqodtCaERzO5cuf/EThNleJVDLH6Emnhu58NJxtDW9WgReXvHFo9NFjKWsErOpPfLffYov0fClERae+/Ix7fT/oHzmIW/CW0BbbUcbBOzcT0dM6vmtnzIIK2xKfuLc9sm5ufp8VZZGgOQAim9FzpGSo4ZgXhZB6Ww7dKnHxg+9PuQefm1unkK10C3+5FGR3CtRrl8I0JLMMDZBS55GQtzY9jDjXJok6WaFCgU54mxAonbcpjWWnncZ5Vx+8RPfcd5ftxyNiTbs6BLpvHAkVCPPz0wR14uxsG7y1gHnpjpzIkEqZGJDPwBvaSnnoDtRKtz5qiFfLMTADGkr5eIxi+I+9gS3kVpLe5M90dNSjQPY87moY21a02zzsbrxKwvfVCZ+jM6JAQtXKahyLOtyj/7mvAyGYC86Vz2OfJFGrFuELciq/WuzLJlwBXDnFCL3FmDmxeOFvmw+3urdpjmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization.
Since arm64 doesn't select ARCH_DEFER_KASAN, this will be a no-op for
the runtime flag but will print the initialization banner.

For SW_TAGS and HW_TAGS modes, their respective init functions will
handle the flag enabling.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/arm/mm/kasan_init.c   | 2 +-
 arch/arm64/mm/kasan_init.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f70313..c6625e808bf 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -300,6 +300,6 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
-	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 }
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index d541ce45dae..abeb81bf6eb 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -399,14 +399,12 @@ void __init kasan_init(void)
 {
 	kasan_init_shadow();
 	kasan_init_depth();
-#if defined(CONFIG_KASAN_GENERIC)
+	kasan_init_generic();
 	/*
 	 * Generic KASAN is now fully initialized.
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
-	pr_info("KernelAddressSanitizer initialized (generic)\n");
-#endif
 }
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
-- 
2.34.1



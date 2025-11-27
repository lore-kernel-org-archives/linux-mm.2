Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C21D7D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A69A6B0096; Thu, 27 Nov 2025 09:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255E76B0098; Thu, 27 Nov 2025 09:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F286B0099; Thu, 27 Nov 2025 09:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFEC26B0096
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B5A613947D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:17 +0000 (UTC)
X-FDA: 84156576714.23.8598D26
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1B8540010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XC7E7f4v;
	spf=pass (imf11.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0swZ8Ypan+oXrthAo/pUrKpZWoHKJGiiGThfa6sHH8=;
	b=TdUXq5US6UJYcAS/1aYHZ2h9uy6cvRQbPINxFhYDE3yYJed2+0BtAa63JtzG6SX8XnvKMn
	cK8fb9NL74usICXYWqkNkZKVKmGyf9wPCZEekl6Tp6JEXPQfTT7KxXfvsPwDP/L60Koc+Z
	ntMO0U44WBUGKRnYIJQ/admxzAe2Bfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252735; a=rsa-sha256;
	cv=none;
	b=gmlV2AQGc3MSYTjeAkIFOLHe+w+xtnyyeFUnk4JjKKnZPKxq2OtCTPsL8e3ZgKCCzYcMup
	HJk4D7mUJ1Fiy8Kgb9CJlw6gGDXgu26h68ZCpieEFTvMC/Ot1j64ZnUZtPhn2kSzWlElw5
	A8Q1Fln67nWmlm8SShAwhlWOXTWtJaQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XC7E7f4v;
	spf=pass (imf11.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34372216275so998618a91.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252734; x=1764857534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0swZ8Ypan+oXrthAo/pUrKpZWoHKJGiiGThfa6sHH8=;
        b=XC7E7f4vlb2y3Iif+/Lj3UgwEMtBcfj4bgzP0QHLVOftMND8BH8VU41U8kG5gAUJ9T
         JCROekOTNKbBSmrUW4/K4Qtye0CpQDtoZnSJj5lZjc/oGt6VjHAcK3DDbQ9HI7aIib0c
         CJlMlWGPlhwBa5n8ub7Y8hN6s3SYM9kpOblD+Jqzx2xJkN/R9uNZyHUD43SpAnVRBVVo
         0I7kk/iaSAuC+zfDJXqRwp79Fq92Kh7ueYnpUOljnmvBxkzXpUH5foJ9q/KvFTBomsIP
         tNy5wJnFNmQCSHLws7L2ey0zHoHh939civi4d7uURuQgGGCSuxQ6XWIjoRtXOwTADthg
         0MsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252734; x=1764857534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0swZ8Ypan+oXrthAo/pUrKpZWoHKJGiiGThfa6sHH8=;
        b=it5sqAKtgQMKs39jbnhx1zP5nWkqvFXtDO7CJA1fC6TlKaiC82kVBkt0bCBQA/Yjg6
         XCFBrSC4sdMVOouKoci7gW0vxVFi5RjYW8CfVemx3LGnqOVYNkD2QtBL7IjpAZL6Pji6
         5wug+tVWIBMG9IgDKtc7STo7fngeBDb/+qclMs87jnYsonBvrC6d5LfErgYe7SC+RsqI
         dTTEyqDRtZIxOuRBB+Oh65aFgf7asiC54Vyc/McbG+Zb1ozU6/bW9bfw/WqB97MTZQ7x
         p03bMQT8Jld3Ny1nHLSDfZOqV5yF1dZa5IBeO1BOs8PmgXbwQzPIBZ/Gd+hN8L3/YO+h
         V4Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXWCx+NoO2Kt1vchYe1btOdtpwx+ALhpSUpxSUOm7EVu9YWokvmab2wNMQZX4MyzccxcFEIoXCkNg==@kvack.org
X-Gm-Message-State: AOJu0YxEwLBspjI3zyenJZRD7YF72bkgeCNXqcdH2lQmJohXUR5s6mj3
	xKk3ISjrqO4smWoWpoZ+1Gn1LAkJ3KKXylcLYw/pKaqFf+Zucoc0PPeauPH0N87x/Eor3oNkZ9p
	G4lRNUHr++w==
X-Gm-Gg: ASbGncuJs+kAp+uaqv7b4HkJ6mQNTOt7lblF11CeozW8myRXc8L1qGJqISPpDTBv29K
	MaScP7MlPQ+9itpkIJX4e9KoVyMBlGr1nZUYJNLhBkD7Jc0hvSg96WKoFrE2B33xFL/zsXT/m+U
	1B87I8M+R5JKk2EilrCVGf4s8awn1oj6+B2gSQNcnQ7a91T0SNRi7GGrPUeXm92HYi11Zd9Un7G
	UF3OUOE9M4o/ZdLOt6ocaWusE56gGZlDUqvUXlgIaB9UL19bnA1xBsxN48g0t7SRd2NyG9+IYpD
	9fd5q+5T7C4BhlRF64cokrapxLI75ZPxa4Vjim5Cu7p9+HXIPI98ecrNpjz8Vuqz+Z5JFH6ICl6
	3EwzHT5gdqfYQiJfOOemAvcTQKDx2k1lKaXvuVXl2ZJEJ/Y5b5STVdzgFnsFE10R6baCvnP7N54
	RtvGgCSsyZS7r91lbvnoGwSyjlso7vCuNtKNcOreYPMWIbIOBGOR4i277gEBBryCxCWYGdJDJ5U
	A==
X-Google-Smtp-Source: AGHT+IHkhvWqjx6FEHq30tTA44a11zGXZ1BYveiPwreNaqri3rljB5haB7+w3kfLn/irkM5FUcsJKg==
X-Received: by 2002:a17:90b:35cc:b0:33b:cfac:d5c6 with SMTP id 98e67ed59e1d1-34733f487f1mr23197433a91.29.1764252734477;
        Thu, 27 Nov 2025 06:12:14 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.11.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:14 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	apatel@ventanamicro.com,
	guoren@kernel.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [RFC PATCH v2 4/9] fork: Add arch override for do_shoot_lazy_tlb()
Date: Thu, 27 Nov 2025 22:11:12 +0800
Message-ID: <20251127141117.87420-5-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1B8540010
X-Stat-Signature: wcjk6trtic6uti5nar6jh4yifgtixuof
X-HE-Tag: 1764252735-275973
X-HE-Meta: U2FsdGVkX1/sTMtADN2DeJ95M/KRefw5QVBboubc/5Q/0FXjAKYWEalfyte3pH3FVI4imuv5WGoHi0S7d/l7HaoXvFya6fMv1TGnsJnMP2xTd/533FpxpWAf49RL1a64MLblkLuMj5Ia8aduy6eov4mO8CjoQW2V9VRG87D/YbV1Rb5Y1nYuO4KyF3olc6FRrXRr0WwQb7C1T3qZSYTelIEyl+mg7yD/U0soLS2neQ0n7KLru06qjFfR921d8f30rGlN0YUbB6XyvO8NaQq7em91/tl1zeJIAxeMdBn0Hn/SXYVL8K60/ROx9QsMsYDW+Wayr9vaAzYDskGC2YogsJgMkwazRd8ZhBhZYOU+luC+6OHn3reI6ZjeN77/q2ZHTY5tZNkWyX/Z0GPJM1T5yGMOROT9ASvkUwlnBpBbszp9GIkqTKmQzI1np3d+rIb+QospJrlOs2irPScayx4hEm+w2ssacyPITKFfbA6StjDAL52xE7d72mLX05DQUJDH8/UjQ+EcllNQaz30RezUEyj0CWiHVWuzABJ/PngbvydKyxh/C/v0yImayrHEcCbnOa9C7i7vm18LtuqaKA9lqXRF6vNfBqsYTsBiBcQVm+ba5HR2ZsChv/JxeEEeWzu2G742XTevizGKm6o72kwGPMYO0xhSgfMPKPEDYm5sySlTvxmqVuOPBUoGEbLra0XnSULLEynK9cufhtfc/0QI1iY/J3wP2jGBoqD1t0kam8Hrtxg5cuLfNDNubqmI6K8o2haETGQEm8r/a8FLRs1U2ywZxmTM3KIYbZGpZcBU2Dq5rjZkaTi1FfQ+3HU6mBlj24wixtuZlvxRHrzaBXQT4FedYWUaNcmS6elpUH5OsHVsmNGVHUcU7wKOtS1PBPJ5p4B4fi58XMahJSCJF3orjmSehGg3B5OCGEGZobTk8h0Cfh0hWJMeXmBAtKxDt6Cwu1F5QaBkMyX5IyJJ+H2
 SSs1rKT4
 RGvDx0Qlq3tcxMlpeOBZM1Omuo9cf6XnJ+UEztTWRflK3xJ4EHWJh+zL8ZH8s/zjp6zuB46q9HTWd/I3hilz0wsWScvBpqAqxXPMRrCF8E+TQYdt1iUdxA17fDoW5BfhcK+QHaLhcNIXzglw8+CSbrH3XDANjenvWMOQX3kon8s/U4R+YdX+6Vz5oxlh7CI16MoyHYtCsSwr+CirS1neRd1u4hMReUtRFKaVd/PZpn9T2dCM5q83a6UiJsdPbYJnGxMTo/zcnAaf3xcD8PYPsFvGI3Wr4zA+FUf6wGbIJLcCKvYWmAcbwcfC2U6OKBM/brjvrp2uhk/UrvNj5HhvEjbOEbB25XsRDgAZykuGPDL0nUvzD/K0ZQVL1Cs06bYC0+0HaglpTewhSfmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When both CONFIG_RISCV_LAZY_TLB_FLUSH and CONFIG_MMU_LSYZ_TLB_SHOOTDOWN
is enabled, riscv needs an arch special method to free the mm that needs
to be shot down. Thus we add arch override for  do_shoot_lazy_tlb().

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 kernel/fork.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a95..b6d11acd6ac10 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -612,7 +612,8 @@ static void do_check_lazy_tlb(void *arg)
 	WARN_ON_ONCE(current->active_mm == mm);
 }
 
-static void do_shoot_lazy_tlb(void *arg)
+#ifndef arch_do_shoot_lazy_tlb
+static void arch_do_shoot_lazy_tlb(void *arg)
 {
 	struct mm_struct *mm = arg;
 
@@ -622,6 +623,7 @@ static void do_shoot_lazy_tlb(void *arg)
 		switch_mm(mm, &init_mm, current);
 	}
 }
+#endif
 
 static void cleanup_lazy_tlbs(struct mm_struct *mm)
 {
@@ -661,7 +663,7 @@ static void cleanup_lazy_tlbs(struct mm_struct *mm)
 	 * - A delayed freeing and RCU-like quiescing sequence based on mm
 	 *   switching to avoid IPIs completely.
 	 */
-	on_each_cpu_mask(mm_cpumask(mm), do_shoot_lazy_tlb, (void *)mm, 1);
+	on_each_cpu_mask(mm_cpumask(mm), arch_do_shoot_lazy_tlb, (void *)mm, 1);
 	if (IS_ENABLED(CONFIG_DEBUG_VM_SHOOT_LAZIES))
 		on_each_cpu(do_check_lazy_tlb, (void *)mm, 1);
 }
-- 
2.20.1



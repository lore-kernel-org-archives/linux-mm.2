Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36574C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360EA6B0099; Wed,  8 Jul 2026 13:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAC66B009B; Wed,  8 Jul 2026 13:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9A26B009D; Wed,  8 Jul 2026 13:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDC9E6B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:07:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 123EA8CB16
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:18 +0000 (UTC)
X-FDA: 84966240156.17.D01D014
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5707B40002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKQdUVzH;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm8S7fxMLu6TlkbuGaHjv8eWStidNKhc6ejgToCRJ4U=;
	b=eNHe2f02XA8ZyOffsdMjnn1+34N+MxkZ4OUdPyIr+beXJFiY50hZ9N1gYMQOkelpoI7C9u
	IGnW/04Y0j4CU3PkzIBv81iCKfDvfEnt7hyCkyjlsd0uLPJm7YbTAvD0DGGDiXKTjPwMFH
	phsDp3gx5BBYokTeiTGQYDsTpQjWMGU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKQdUVzH;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530436;
	b=hrBP06sDyO7MaPTOW0oaI6wDhhGOF+fHyRhZak6MQGfmpA3HvlqYKlhiyo2elo7nVmSrV0
	W9npNkN4ZZfV5zMQMfPeKRTUwMHEKxvgll7WEXF/r/m/tRiLe4Ro6gArr+iGhmzt8OY4O3
	oao6EdLeyypIzJ6fHxYoi3PyfwIq2cY=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84794e800f4so663658b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783530435; x=1784135235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cm8S7fxMLu6TlkbuGaHjv8eWStidNKhc6ejgToCRJ4U=;
        b=jKQdUVzHMRVtA9DAiVyfsIzj5vlpxkd0CVkO1Z54y3rUtc1SNTUUyIPy2dH3fKA4fp
         TS+BweQywi7g178vLIUEgLKI5b+3PZ8kycRXv2jUZ4NqTROBc8xEG4rLwn5NQjgbXfbc
         c7eXlcYKOYU3ZoRZiUl3gIs302dNzduqLkyC7cW4X389YbJ8MuZOwVrUbUIUNEC+DN/h
         5i+7Tn/mfyidwyBKhPZb3MEM/Cz4h4qOFtlDKvKdkqdutWZIU01HVFJRMhH25tSaEvyM
         UXm4b0yIcF7Fvq5gCGJmZMCm6W8GRIz0fH6Dn2sQKzD+cV2PIEtxG893bCmZFjPlAqvl
         haLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530435; x=1784135235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cm8S7fxMLu6TlkbuGaHjv8eWStidNKhc6ejgToCRJ4U=;
        b=M0eKj/jGI8g/p36qo0FKWbbNZdJN47nOOFdM3r+Ou/bI3XlPWROG2BhNRodUNIK91O
         Zq0O3suAWu6q7V+3ilCxyq4CFPh+3/KQE8yexy9c0r9agM53EHE/SNgPLF0A5f2eisEF
         6oZMoxcc0lS1djnYeyeloPxM2T8J5DhWWvEfXNppB0eazNFp4pXEKmMhv/RckPurZiCR
         MH2PJRwIQ9YYcfSX/nGtGRR4baXTd6uOBOIfWw6iEJoMWjSgwWFO6wlUqGd1dhhXS22A
         19pf47n0a2JeDSbw5toU75pauWFtg4PP1g+DN/PAGvCjnCxKx3hDYJATsZPnzsL0Kx4M
         T3sg==
X-Gm-Message-State: AOJu0Yy5U1U1RwV52BNguNgHP6Wg4wTn9MzRodZU4RIql1Tx+S5oMtp4
	w71DqNYerpGZO7QqiLjF0dwbYiPAFm3v+pSeivHH/GV9x28BoJ41o8hU
X-Gm-Gg: AfdE7cnq6+845xNp7FKy6GOtfuLvt2E6old0InZYQFtX9a7rmIAvX3ShRWuLsgpUb48
	tuxIS9VA2+/f5IFxSBuh37kO3zSdDLAFECW+mRY89+0r9a5ZiuFZgHA6bfNMWUxSBhEnXrqM4bH
	YNexvwpXreC1StXiyVlp/VuqJxFCbPCVsqou+4/OyZ4HuCa83D8pGcZ/3WI7eDGQ5h+3gcVK0PC
	oNKhAKnEUJgBV7io5aUOPGgOXgw1hEBX1VYdREtLKAr8vN0kxQOlVG1zgnptGpbwGeUouWc1XCY
	uGvofRGKDylNePYw23BusFXDkrx2VK1d1BwGPX97FAUTTcT0nyWuYGVTXpmUQD01YrNQ5CmZSxC
	V5Cxq8jbIjKmi1KT/FgCHEDK1J/JTmUQSkD0rmFllGsb7dJewme1trDh6nDA42FNMfz3Q8Rh1HS
	YetGhBG7SJfbjWggBJfA==
X-Received: by 2002:a05:6a00:6f0d:b0:848:438d:3665 with SMTP id d2e1a72fcca58-848438d3bb1mr2984905b3a.41.1783530435052;
        Wed, 08 Jul 2026 10:07:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84847275fa0sm1119528b3a.22.2026.07.08.10.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:07:14 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH 3/3] arm64: remove early_ioremap_reset() call and __late_* macros
Date: Thu,  9 Jul 2026 02:06:47 +0900
Message-ID: <20260708170647.362562-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708170647.362562-1-ekffu200098@gmail.com>
References: <20260708170647.362562-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1wypq96yod91z4wbhyb37zrehjfkjy9i
X-Rspamd-Queue-Id: 5707B40002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783530436-198592
X-HE-Meta: U2FsdGVkX191+nBV0JuVlJDz4FQ5sKGQQkCzFZDRNIFU5tZHL9IVFgaXSXFiBeFSkBkLsMFUqA2HoaTV6TmR75GELF57GZby/MfRfPTUZGf+7uSCS6DBx7f1Q3GqCxd/1pEnyGCPG6bMjZM/e40dVyPU0ov8TmZQn7wmn6kx+IXjj+V/KBhuQNn26LGq7YYBJ4I/brvaEhrx4yetdZTioW2Gko/ZgQveQ3ILlazNhn8jxQKbNz5Po3JGuJLNgQuu+EE58kZxY5qqN+FMEdbiQPAwD5FbD9XM48h4yjwbGPeIcZd3+C4Zn0giCHBu/WdTve5B5LSrk6uzKII6OS39uO3IlLSXuHbXevzu8ZI3QYcFjd0/frHibsWtpT7zcSilrqNBVaygpaG7BuXaZ3Fq+Y7AlvVQ8Uc4R7xOm/eYO0SSKoT3GtK1hpQ/dhbK8RqZce0y4rB4om7ZGrp0B1ZzL1GfyoUZxzSJQZmyF5fSQkRe5ndhL+5qSAlzSN4/iq6tXkzWVILz/NRffEYJzGpKJ+9Y2EJWsVU1vHHI7PuMMvXo4kc1HnTcXKb9F5CCICpx6Ds459bTSTxGVEVGrsj1pHqX0HtNcGusXaPsRDqYt1H3wLk//hpV7T4dqDAv6VrruQFBd8KUl+00Aiosh8UHsroA8UEsQxvE6JOG4EGFWhWY9SzGqtC9pt8rgDyL8k+PlmLKy+YOWBJTIbLBxi/h2DaYWuOZ+1UX+p9EogJedttXnUrg2Y84Vm1njkbiF4PHz/PU69zXtC/E2d7YPygKtjJFoSoAxh/bc6sVwz+As/YuBS86CLNYVZDJLxCbN+JNIzpbSpWfK4S+/ZpOFBSKeKx89YKB5GWuEyA0XoFM2UYofjVb6zrU88bu0ZOGm9pbfuCt2dRxyo8aT1quYpR4t8jFOXysqiPDnqywjtjAL1Ji6Lw4Bk8+7V7/cRB0YyDWHKU3fKF8bEHvIwiuSet
 P8xLFajS
 C04O/fKSbXVQCzRMX22H/cjbUIyGJ7CHb2btyw74yYTQ+X9PMKpYWE3zAtKBcxSP4zSzt+pQuGPJODBbypFVqJyAneWconwLYaLQaXDZw1x/MN+rOkMujlqrHphPj/QLpZFQNcBuWzsgwckm/DE4Y905pcV1up/5QASCDBipldG7w077ptrelp4Kenwzrft/zxTEtC0t2HgkCClTNI4P0EG0MNbLZv0pzvR5/RjY0jqdRQWyIEmX5DL4Xiq3uaARS8oEsJzYnyNIcxUcjiKQzyTzei3cBD+hBe+76i/c6He3fyyd0n7bTI1P6ciW5jynVSeirKaE3S7IuuwDN/KTjCk7W07lNfK2/XVmw8zonSprNuCl4h+09wAupaTqDtU9jco5dq6uaRSF+VFYOtw2SuSw/tRBDM//jOWZJTf4nMfjUzVEObETliEmezfucXivbf7LN6BTlrkb61OE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64, __early_set_fixmap(), __late_set_fixmap() and
__late_clear_fixmap() are all __set_fixmap(). Calling
early_ioremap_reset() changes nothing. So remove the call and the
macros.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/arm64/include/asm/fixmap.h | 3 ---
 arch/arm64/kernel/setup.c       | 2 --
 2 files changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 65555284446e..abd9800aabf7 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -110,9 +110,6 @@ void __init early_fixmap_init(void);
 
 #define __early_set_fixmap __set_fixmap
 
-#define __late_set_fixmap __set_fixmap
-#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
-
 extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 23c05dc7a8f2..29c6100f0c50 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -347,8 +347,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 
 	request_standard_resources();
 
-	early_ioremap_reset();
-
 	if (acpi_disabled)
 		psci_dt_init();
 	else
-- 
2.43.0



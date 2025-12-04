Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707A8D1CDB9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 02:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886106B000A; Wed,  3 Dec 2025 21:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D466B0012; Wed,  3 Dec 2025 21:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A606B0023; Wed,  3 Dec 2025 21:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68A6D6B000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:34:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CC4A13BC0B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 02:34:04 +0000 (UTC)
X-FDA: 84180218808.07.DD517EB
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D76DA000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 02:34:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=RwSXnQRX;
	spf=pass (imf25.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.41 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764815642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8cBwp0aWYwyhGai8JhHTyTaXAP5UhX6tjhsjDn6rkoQ=;
	b=qzGULzP7LR2YnCOFJpWO5jUZuGLb5LlH5gso0u3+rCO9v8SG3wh9CITbLjCwX1UnzXd/Pq
	HQLgd791IfZhLBoievFmxHnBLSi2a3bhYEMg2c1l6wg35PCEuVqyYcBoTwUT2SQ4LbIDZm
	3xG7xDG2juug0jI5bKCzbPI7HWLAXuk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=RwSXnQRX;
	spf=pass (imf25.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.41 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764815642; a=rsa-sha256;
	cv=none;
	b=5zM7fWW90tfcoYz62Szn2w7PJdErcPQCIYxNeAajeCj2WxDKlh9Q52wXx3RXs2vwEhpAjf
	izTOnT28+IiFeicx8hmuV2/6MLcbOaOfoFyMfpRzu75/9V1oaicOQpc/ztiTad/lZSD3A4
	GPUSAAQv5hqjD7mbmXADV+DmaMMDsqw=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c7533dbd87so408019a34.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 18:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764815641; x=1765420441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8cBwp0aWYwyhGai8JhHTyTaXAP5UhX6tjhsjDn6rkoQ=;
        b=RwSXnQRXXZpx6eS9J9kn1aSyllRa3cT3b1vaSeLjE1uYCH3j7ZIMhPAt01c5BV9t7u
         LA9k5Bq4f/acLzVdVgZo9UmN9BLMvlu7K7lEQx+wgP2NJisLEtdkLR4cQfCOS1qSPJSa
         Jy0QEVsPCvHHmlZ6msNhoMiPwM842b6FXaVjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764815641; x=1765420441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8cBwp0aWYwyhGai8JhHTyTaXAP5UhX6tjhsjDn6rkoQ=;
        b=FN+JNUSlMkHjeP0xXl/uAGLmICjKNo0Xv82adwFz2NdkkmKCztfczi2IFEmKPwT1Lo
         5zgLHP/7qORAaDdz6SeOg0CJY6jsTSQMTawWkXz4xZxgCACWf+PUjhrmsRTT9L4KvL1i
         1g9uQn6dQgjSHwVtq91z+t1QvfFq0cHIAVtB+hm6EwG3TCxiZEPRv4dHaChYYRBYbYay
         EIUKLaMjCdq2BcQ8iDO7jQtbhSfMkijbm8kIaM+60xUMi5+SjFjzpMtJLuhy2xxTnBg2
         NpekuEbGhhUEe+RS/XPrbeDlO/FdjY8L1U9ku/7PDTPQBokYtq5cO6XNA8OXgsqDPu3F
         AvOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXiDrI2Non29X4UHJ8rYyz7BsnIuM0CS1f6HN324SiAGlwgcOyithmkt4eM9d48YlsI50r+dt2XA==@kvack.org
X-Gm-Message-State: AOJu0YwNDbDMprIE+E/GDrrPV+T5t5lAQRzqzoqpF0IDxkR+lJpGjMqO
	zbfZLxUWHbyNPMwZInP5D8TezRCIcz4pLD263lrAHbl6YOx3D7ARKtTwddrFA7q1bus=
X-Gm-Gg: ASbGnctoue2boeAfvpalLiqJMQAMABCG+2lupqliCgCU5H5cBuGNd9phAVdjB2bbtE8
	BnmDCq+QCFfgQeTGzx0wMqCLwBnFFNHNW2I4XRyMTAOsrwCfJaI8HxBvNPm9LF1HZWNoyNszi4r
	IV1pwqftpGSpo8MWsK8jfrxjzamdz/NwHlbd45R+ury5t+iBX7OWrS3uR5p02RJbPhTO2xuGvU6
	YeBbH7C5IuUfNX5yFG3b+UkO2Mf8C4KgwXyJyH88GJtWXTZlGaGwm3RUX2Au8MREM55CNmTJmBS
	KQL7oNhKg987J2ZzwLCDSiqKd9Y7zQ6rM7W5T9y9hxCedUa+CF24JlpH2ST+gp9XPGI4TaF0mw2
	rjnrLOeEC7uJFFDTUDR96cjOhBddLdKBIrOyEL4vGQaPt3kCBmDD0s26e3BOeNv1U7zesAUY+11
	NqhIUHCdABStbaONAEZat3d+uzin5lzbf1Js0I
X-Google-Smtp-Source: AGHT+IHvRpXJtnyiwKLjzZx/ozcRmKCi93mtb3M0cqUPz6Vsa5iPSfTaNpHqBjpIkA+snazfQwc2Tg==
X-Received: by 2002:a05:6830:44aa:b0:78a:8b0d:cd54 with SMTP id 46e09a7af769-7c958c06fc3mr950721a34.34.1764815641091;
        Wed, 03 Dec 2025 18:34:01 -0800 (PST)
Received: from shuah-framework.internal ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95a8f8d0bsm510833a34.5.2025.12.03.18.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 18:34:00 -0800 (PST)
From: Shuah Khan <skhan@linuxfoundation.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: Shuah Khan <skhan@linuxfoundation.org>,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb"
Date: Wed,  3 Dec 2025 19:33:56 -0700
Message-ID: <20251204023358.54107-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D76DA000C
X-Stat-Signature: 7da748r3js3n8p5so4tgosebwiuycwnb
X-Rspam-User: 
X-HE-Tag: 1764815641-979623
X-HE-Meta: U2FsdGVkX1+c89PvU8Fksw0iMuo0bBSeWrR1bOJ/tPRVhvkBeIUyJOhjmYo9NXiGDqcBM/GLRJyPaPx9JCAp8eeExwauT0lgWF/vys2hdwlLJYOK4oDOMp1GXnd05PlJzabV6pvTD+C7oY9uoAMdOaYvZEdxj6bltrZFg32/lFSxjzKrAnjwA5FL/xFhe8N9jL8TdecA6F5md9qdBwjgBGZxMqngj/H/pibMCOoWh4X8pWXuxSaUE5rvBtdrRr0jhiQCUsEcv+pKZ5km3dOXIR3T91b1+co1QX1nDsSrCfJoE1z7aoYDh7SgGHbdJ2929eYdG6EwJsEBJzx+xJKR/0F31gJBwt/d6vAk56GnsVioeHDqG00sjUs98nLsffuV6ZrxEG7wfDL86cmL26PgM4kdlrR49qCx7ljMWDuHe/oeuRyRJAKUfKD93Hb+UjclZMP+SJc942D7ytwu+i6eGNZfJhbWomhAivZ0lIBtz4fj/0YWBlGFPjywPSLnI53p0+9d1m3QBmHecupIE5ZUX2kjdax95ZfXBv+IJ183ChKNuwhbxKj8CcIHUq68BgbGA0aTOvv6Ld0APdD5p4QsNmucbTNqTJqvbMf9PXXItAcqmPZRYiT4EarPcNAiHjADbxLcY/7dUGV8kgaYhfXtoZ7BjcPUncBctiSXdDGIZH459FkficH7ILrP5B83grJky3Xhq7hojJld5F7vIhAc2BOS1F5QMbTUZVDscWHxYBh4Lk72QDwNEYCRv16uFa5aV6n+lbN9j+1SH1wesdR46Bjsjlgg+D2qYPyRFBazPMNyOoNcRdeyNO5TBu70x1T+F5O7FaHdfJguxN3KbAhYkYrW6P0xm/GNrQSryYskpVLACNM6VaEVviL6V2uEV7RZ/ffP0jN6GhNDFBayv7DjCI6wvE9EZP/3zOMeMUSuAk7nCEljdDKtIi/RVIyYM+Av1mynqnQ1WUxVM4m9rKM
 eiEN0dTy
 4hEaMr3rlSvJZcdWD2xod4U/8LhLnDXXMU+zjEJnLv6Gtqx4/omRIXbAvSBc6wp0mowVbsqQMkGreUDlwOdfBAQEYSIAxpqW9o1tLcWvd8ida2/ipRxoO9HJ5vCR0t44Ycb4Y3piXI6IbiO9X4kvGEyB8F8XUWrXQwZ+93kg256RNrWrYuX9A+4AwQLrfruNnmj+DBmLt2jww4VXN4W5dYWxsUtUYl8YDOU6457v3OtZ62DVZZyBbSPmwqM1CPCF0Hp7LAY/axGO0+xzUXVtarJ2a0rWI9E9XwCi92ifMvmXHD1WYjzttNxctLzKxXfo2O8j+UIqE2XjbKPDC59v6rynNwastwd/RctsolrBADyGVOOzQPJY57oGAlJpsbryd7rQhCrkQSJJtSs5L69l9CHcfgjB6JJkcT+pfdy5oCpiCfebHSVT6uKDFOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.

Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
systems. git fetch-pack fails when cloning large repos and make hangs
or errors out of Makefile.build with Error: 139. These failures are
random with git clone failing after fetching 1% of the objects, and
make hangs while compiling random files.

The blow is is one of the git clone failures:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
Cloning into 'linux_6.19'...
remote: Enumerating objects: 11173575, done.
remote: Counting objects: 100% (785/785), done.
remote: Compressing objects: 100% (373/373), done.
remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
Resolving deltas: 100% (9195212/9195212), done.
fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
fatal: fetch-pack: invalid index-pack output

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 arch/powerpc/Kconfig                   |  1 -
 arch/powerpc/platforms/Kconfig.cputype |  1 +
 include/linux/mm.h                     | 13 +++----------
 mm/Kconfig                             |  7 -------
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9537a61ebae0..e24f4d88885a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -137,7 +137,6 @@ config PPC
 	select ARCH_HAS_DMA_OPS			if PPC64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 4c321a8ea896..7b527d18aa5e 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -423,6 +423,7 @@ config PPC_64S_HASH_MMU
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
+	select ARCH_HAS_GIGANTIC_PAGE
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..d16b33bacc32 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
@@ -2087,17 +2087,10 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
 #else
 /*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (e.g., hugetlb, dax).
  */
 #define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index ca3f146bc705..0e26f4fc8717 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -908,13 +908,6 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
-#
-# We can end up creating gigantic folio.
-#
-config HAVE_GIGANTIC_FOLIOS
-	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
-		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
-- 
2.51.0



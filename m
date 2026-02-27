Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDA2FEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE0B6B00C7; Fri, 27 Feb 2026 12:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6216B00C9; Fri, 27 Feb 2026 12:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1536B00CA; Fri, 27 Feb 2026 12:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F22A6B00C7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E45A1C2A89
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:47 +0000 (UTC)
X-FDA: 84490994574.10.E239F6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 336F64000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFbemy0PcyEmSBNxC/D9/wuhnN4nV+G16h8jmD3VSkI=;
	b=N2Wft/jiEu/SnvMtOtmfNtIQO1Dytl7+3AP/FtLOnf3xT4f2tUKn1jrIfRYB20pzt1M1v/
	mJ8u1qsCJMDN2hmgw9ur8d8Z7Jj1EZfq2FrI2v0DLNbySYYnuseEZVLRN0K6oj43OBolhA
	vLJ74Z7zQdh6rbTrdqruAd/zBtcsSHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215066; a=rsa-sha256;
	cv=none;
	b=pFnefCaaeAs9qEX7RjbZxSRlyl9i1zD6BCQaURqyALR9T4W1ywcuY0S6fkZO+oVmqXLKce
	i5OR5l9y+grR3Z+2ak70WneivvCPb7g6S6ye1lsQKWynLm219YVxNoj6m6vCCsNuuduCU4
	tOxOcXUSjfRuO/ulG3EOhJ+MRpDXZ9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33E3014BF;
	Fri, 27 Feb 2026 09:57:39 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FF1E3F73B;
	Fri, 27 Feb 2026 09:57:41 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 26/30] arm64: kpkeys: Protect init_pg_dir
Date: Fri, 27 Feb 2026 17:55:14 +0000
Message-ID: <20260227175518.3728055-27-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 336F64000E
X-Stat-Signature: esr68a5e8jkd8rxy5jphs8khoizoac4m
X-Rspam-User: 
X-HE-Tag: 1772215066-773438
X-HE-Meta: U2FsdGVkX1+dA7Kq9N105xY25f11CdH524HF/SAXJGxmjzeE5xHUHgKz1kFAdpimUnz8i5Np9LWQfd7G50VUmxTYvJnJpS4ZwJI8JZHOSU9Y2gATfgIjcEq3VXBRdzjgIELg7YiL7Je1NsRrUWRGBrI/SdpZCGZ34mIU5eCSqPNGrcHVn0BLuDr1Dng2F5laoVhG+nsqPrjtleUROWgTYZJXZ8bLuqPbYVqLgNPJelt1L7Zww55VI/joSXCFoOmWSiTEKurD3Rvk12j6LOJ5g/lA7wVY7iowwNQPxfSM9JqreCfuoY0HJoV3KgVzdvffgA7yo968Y9TCdCXxvoz4WLdKa+gc5Rm1TSq5e20VVDnYuFExCp1TTRtbhU+/LmmZwUCnJBmxdwi74ItA7HRDztfU5TpdR7x6aldvVO3km8rhuShEFETz0ckM2mjAJNkjR/kAU9RJZKEARwn+ge0RRMwxu85X48IIIUxZlVbD0AU7cGfWIMqFObMtc+wmP7Ov+dSm9mrIk67tFBTrAq6LaukPs9348ZgJY59bsgNwCoO8aXy9VKa6niKZLmMZOXZp+nMVu4Aew/aC8EhhxIczAxIe0ul0UFP2FPrjP5P6DcysuPoDQPxAnzJjpee4eiLJfCEGtu7BR+TLzmq7XAa0HTrgQeTBoSbr/QxDvTg3KrGvzDipHhVHy2UUkV2H65gVoLWbA7KaHNpNJ8hibS+tbBGk+ycS0E82SkGNvGbc+naaTNVX3dlXRoqLCmryKkBpobtVx9mlYdVnPa1kXacaCK6r0UpjIF7ocrfghEEZDTA1LXIdKkkKgFs2erWwbe7p0d+/6mYs9uVVE2koUREpgzJHzKZoRMVdxSNnY1jVDuhOuF47Jq0B06y/3211ugly64Fv1ESarEiTIMmoe5aYTFUyXJRwN/I6+KGgASfyuZESLsSPMbhwvjbBFhT4BQfu8TmNHNWFRZtSbP1bBWS
 DJjwoW/G
 cHjd0/T7jN1g7Df9AZPDOEw3EIkqBwrAgn9aVTbHA2UHcv0JKDfKeT4XJPLK1YzAHYmyiuvdu+5ggic5GGP6jl8TGxzvQPuwOrS7/+ieY3XmeI5+WIbQkdzhN6jVny3u/A2p4w9p121Ve1NwhY8UP3Bk8ktwl5fN6R76w6cBDOPXcDRVshpXZJDC1uw+Efy8ZIls7K1jnzgVolBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kpkeys_hardened_pgtables is enabled, protect the page tables
that map the kernel image by setting the appropriate pkey for the
linear mapping of those pages.

Most other static page tables (e.g. swapper_pg_dir) should be
read-only both in the kernel image mapping and the linear mapping,
so there is no need to change their pkey.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

This patch may not be comprehensive - there are multiple static pools
used for various page directories.

---
 arch/arm64/include/asm/kpkeys.h |  3 +++
 arch/arm64/mm/mmu.c             | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index eeebbdfe239a..2d8bb1e25e3b 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -66,6 +66,9 @@ static inline bool arm64_supports_kpkeys_hardened_pgtables(void)
 		system_supports_poe() : cpu_has_poe();
 }
 
+#define arch_kpkeys_protect_static_pgtables arch_kpkeys_protect_static_pgtables
+void arch_kpkeys_protect_static_pgtables(void);
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool arm64_supports_kpkeys_hardened_pgtables(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7072d5ac0579..1e2cf0166c1d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1048,6 +1048,19 @@ void __init mark_linear_text_alias_ro(void)
 			    PAGE_KERNEL_RO);
 }
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+void __init arch_kpkeys_protect_static_pgtables(void)
+{
+	extern char __pi_init_pg_dir[], __pi_init_pg_end[];
+	unsigned long addr = (unsigned long)lm_alias(__pi_init_pg_dir);
+	unsigned long size = __pi_init_pg_end - __pi_init_pg_dir;
+	int ret;
+
+	ret = set_memory_pkey(addr, size / PAGE_SIZE, KPKEYS_PKEY_PGTABLES);
+	WARN_ON(ret);
+}
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #ifdef CONFIG_KFENCE
 
 bool __ro_after_init kfence_early_init = !!CONFIG_KFENCE_SAMPLE_INTERVAL;
-- 
2.51.2



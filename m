Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E16CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2FF6B008A; Tue, 26 May 2026 23:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073AE6B008C; Tue, 26 May 2026 23:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAB56B0092; Tue, 26 May 2026 23:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC3426B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9834FA03B6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:29 +0000 (UTC)
X-FDA: 84811837698.12.F78F04F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id C12B4180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rqu/zPvY";
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779854187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVYS1QmkmunlPWb8BqMD8qeEPXnJn99EKXuuGpXAWnc=;
	b=H6uF/DSgTPTt3nnAGGVRgKBDCEjeen/IPNQ8O/SyBhXlYmYNOdUOv1Bm2Q+Qb7ecP8eLhE
	AfhjQAfyrswO4Xy+v6kaDdOEJmc1xfz8VDlqNCZ+Cael9VojAyq2lODI/dSGDcgSmxTksN
	5T4ohIiEzUbDXT4uG3PbVOf4ZHK0oJ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rqu/zPvY";
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779854187; a=rsa-sha256;
	cv=none;
	b=hWxv+iLHyfsLQLjEQENXtbDggaheScTE0ZlJqdYpE1NI3CPNeFdEfl8IQxGD8X81yKSe2h
	Uya0gknrnEjgLNm8M1Y7IDT0BUqHFfYUrfkmrff43WyP1BpaV41Zs4BlP+uq46Irpy0ip7
	7BIFc10Ce/REgpydBfRxOLt1H53qwks=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-365e54bc4cdso809683a91.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 20:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779854186; x=1780458986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVYS1QmkmunlPWb8BqMD8qeEPXnJn99EKXuuGpXAWnc=;
        b=rqu/zPvYR+ehrzATwsjTMmmCJPBV0ZQQ0mUK7wsdgqhgYDJ9QqMgJ+OKRXX8AWiTV2
         qR0D5UtI+MwO95QXDOJNcNJz/bZEniG5AqAaG8zRs0hf1gzn/CESNT7lxDomA02DsG9f
         +JvM+/7puQ/CwVP4M34JpouwsZ53eBLeS579P6uXqksn6IvAScDJCRULz52VZwvqQ5QD
         b31uLpMOLXKqyD2OOKVm6r/fheY4kpaW/1aayA82ne8RjskkisD5kc0tkhXTx/cQ3RHL
         Y385csVhvcvQPm0UeFPQyuqdyRtR1k32h14BO7+s/vdrAiKaE2raTnSUJB4hgd1DEqFv
         VoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779854186; x=1780458986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rVYS1QmkmunlPWb8BqMD8qeEPXnJn99EKXuuGpXAWnc=;
        b=HEsLMY5ZlHim6M1KLax4DlYB/rG+uEmV+10QxKmWxZSRaHVAaqY71JuQW2C6nAlkxd
         F2OqIcJkp+PMcwpdAvzcZUfqyiD+KlPrrctX0/t9YRUjY5EdJ8te2lVpAq3TadsMiSOG
         6Tm/uGMcubVbdG9/TdE8dDAxgT4Tf1yEdjypsd5Ggsj+JTGuLb/FAlNCzZfLclp35wNg
         oS2pV+JdLFNIwFHRwNRR7jb+dSwEYDm0pECU7ugdauCNiKE7xbOEwake8RyaSC1hQlZK
         hRODEMNeh4smjJroZgLgkgRVdMkRn3vc3CfCG2FPCjD7rtJ85aiTox3FJMIE4gX7Rv9u
         0dOw==
X-Forwarded-Encrypted: i=1; AFNElJ8QSzXaMacOvmYXke8HXVETbqICbF/lyTFwOVpGPW9Z+LxUeMxH8MWMMLMRZfSyWyXLqC+v5plgRw==@kvack.org
X-Gm-Message-State: AOJu0Yx5GEUYHkkNWqtYRiauUmeLGY6sEImbz3zrQyAaIsMgwvCA80Yn
	usqtQAGwwuUDU0ZMn0dzSNPiLpdZlVrlbyko/dLh0iH2b5Odkf7TKqRs
X-Gm-Gg: Acq92OEAWW1MKqomuMnoJ1150dH+8m4rkYZkYK8VLzMtsdxM+jrtxN9CntcuIo31qX7
	ZGLZMqIcVgpu/oH6dplcGSmCQ6q2SAp2B4U7d4NwBB8mZZmBgr0Nk5zpQCHnXkEFd/Hilt2piJ0
	OLfxX6RTKvFFfbf+bU7Bu38FZXvl5KCm4DtiW0zqS1qT3WFBbLOVPTLINQ53srM/7vGSs0jduj9
	HFXMxmMJXS9KXKjqwm2kg4RgO9dfmAwZMj83p5qvkONTLNlES4KjjLnI1k2642NQ1noF0sZPkHk
	/2ZOBFZdldS/CjZUkzRgcF5nHyXqO8vkWKs5H+myqXy0AbCAgB8Ib7XwhR8pHAI3KWTXhgbH8aW
	vkGzBduiGeb+cupHxy/ZEWydyVxU5IYGhvfu/l/o2ViVnr3G4pEUNDvVWc5B6qsKMVp6C9PFJMu
	5gS05D6VFubkmZsetM1ddtqT3cvo0amX6tZGXErKrNCUHmj2Gop/+yTl1OwcwFfggclti81gWvm
	V8JcM7OXZvF3MEwR/1MUGAFF+g/EvqtbUlv+UxFGrQ7WGRR
X-Received: by 2002:a05:6a21:6711:b0:39b:91d1:6c10 with SMTP id adf61e73a8af0-3b328f122bbmr11576536637.4.1779854185699;
        Tue, 26 May 2026 20:56:25 -0700 (PDT)
Received: from firefly-aio-3588q.. ([36.28.158.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70f1ed8sm828385b3a.43.2026.05.26.20.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 20:56:24 -0700 (PDT)
From: Xueyuan chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
Date: Wed, 27 May 2026 11:56:05 +0800
Message-ID: <20260527035607.14919-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ccmwwnh8d1rknhhbeqgz1jqdy6sg5uqs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C12B4180006
X-HE-Tag: 1779854187-549987
X-HE-Meta: U2FsdGVkX18qMKr/UBweXXI7CG02KOciCroWT5kufMXcjRquJDqIAjTkjvpdvGo8bmSUCTWb1OnHdAGgt3Aolgk4gpXZW+9OktssXRbYvxzuX36xMrK95CLImQWcczpBsYnKPGgDcMFdGFEaCXQMoli+UXka2xdu6A/pREF1Uv/yRea3lJoFJoUg7YtgH5iWm/Xu6IvUVP+ZXbmDhztMHTnyvhTugOf3Oi4GASXx7qlxkBKIPZlz/PHUcj9u+7A10e4AYorJn05fkVGIYTCiCO9r27Dr41SdnMmQ2AsHQtu91He7IU8ZKYOlIruh4hHWYBlNGX1Q3zX9lIW+dYuZ/a3uZkdRz0JAv7G87ULFRBaNa/rrs2aFweJ/RVzjPSCpA/wrrgI/yvV3W0/Wrsw1mvRrLyVqGmEcCjISTYqeOBT2u7pNMvy73qVDr3MgAtBwyCUbZ5qWZDDZmoosGUgkGsbZipUakZCh80idVnxkvEDty/Ml4Jrq1VfEk6mYB/UBNBEPbvlXYFIW2Bu4Wn+9w7SAa5UVquI4z3wnrh5yZXkkbDdP/1H7JR3Xtxfc5BwztvVFai4XSyHZacAFbRJoKVTi0E5ELDI7et730EUJmkJzJcDSRdBzaeuWYQPgpIpfa4yPshJLIkTGSwP7Uf5eSNC1udBojNUupC93kgAsjUGPIldDzxS1xqtTFvWfKurcKJuvnYWpvQ9iYc3g9avHiKnfh5D/gTue7sSk3N+kysuwq+cw8fm4mCAcMoknvdiXI3OFF2KaP/zVbHp09/n8PnwuIc9qUKzmvWd5dfjfrtHPIWseLMzd8A8cqJRP8F8unZFPcP0uNGeyXOPPtiqBdXboJqd/DTnL3OTxZ3WkGrxdrJ83C0/D2FegJM7xSSoAxmgBJqQy67yoHoUPLuFPcEBRrvanTyrJUC4Qdq87k4kj2NsbuXaI0kZautGoMYOJyuvjD6xhnHOJMXlz6+b
 dBjo0pvP
 +UeN94ZqB1E8u+vqILPVmGQa1wtUXXMbzya5nEzv2k+qPyTyBZByS4J2484i1blpXvVDsJC3M2PEBhMBkOE+foQiP6Q0wx0oFB1IKbuwGs0hMMS1BXE5MSvDkQ8gHr1itzYk3HyxGxdsAVtr80SjX7ilBgctzH1SusHtkulOPa6hNMpUc/dmdTErkPuolNZR0IUIsUFkpFfxfb6OWLVniLr3TpU8mafkEBbSrLZr24SutBhaEFnoogv0Fw7RYLzwwKGU32WMH+u3QRZUzIQ9JGpyZJ7fzCn6vlJLU3xI3SHIUdh0mT9e2+81lvGDcqSUUPKBpgPZPlmozwUJrmJXuojM+KWlNCL5HA04arkG4Ljfp0FLXU4yrIaJPh9ykXOle4a7/5y2itkU2guAICLh4VF/2w7xgpfuVUlhgAVqrGjcuHWpFGyflStfufc1//rOxiYHy8OV+CMBeBNymLlNWeSZDlshCw/mpiCJvC6GvgSjL7ehAC0TnAg9xZ1LNm6blzUI7/rW4ru6gFE+EoAECO6UNolYbijn7pCJ9UNSgPT+iS/j1clHLgiT50g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

The huge zero folio is shared globally, and its contents should never
change after initialization. As Jann Horn pointed out[1], the kernel has
had bugs, including security bugs, where read-only pages were later written
to. If the huge zero folio is read-only in the direct map, such writes
fault instead of silently corrupting shared zero contents.

For the persistent huge zero folio, set this up once after the folio is
allocated at boot.

The permission change is best-effort. If the architecture cannot safely
make the direct map read-only, keep using the writable persistent huge zero
folio.

While at it, mark the huge_zero_folio pointer itself __ro_after_init.
READONLY_HUGE_ZERO_FOLIO depends on PERSISTENT_HUGE_ZERO_FOLIO, so the
pointer is initialized during boot and never replaced.

This was inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[2] with Yang Shi.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/huge_mm.h |  5 +++++
 mm/Kconfig              | 17 +++++++++++++++++
 mm/huge_memory.c        | 25 ++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index edece3e26985..45d1352619d1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -5,6 +5,7 @@
 #include <linux/mm_types.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
+#include <linux/init.h>
 #include <linux/kobject.h>
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
@@ -554,6 +555,10 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
+#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
+bool __init arch_make_huge_zero_folio_readonly(struct folio *folio);
+#endif
+
 static inline struct folio *get_persistent_huge_zero_folio(void)
 {
 	if (!IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
diff --git a/mm/Kconfig b/mm/Kconfig
index 776b67c66e82..f31200816646 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -787,6 +787,23 @@ config PERSISTENT_HUGE_ZERO_FOLIO
 	  Say Y if your system has lots of memory. Say N if you are
 	  memory constrained.
 
+config ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
+	bool
+
+config READONLY_HUGE_ZERO_FOLIO
+	bool "Map the huge zero folio read-only in the direct map"
+	depends on PERSISTENT_HUGE_ZERO_FOLIO
+	depends on ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
+	help
+	  The persistent huge zero folio is shared globally, and nothing
+	  should ever change its contents after initialization.
+
+	  When supported, mark the folio read-only in the direct map so such
+	  writes trigger a fault instead of silently corrupting the zero contents.
+
+	  If the permission change is not supported, the kernel keeps using
+	  the writable persistent huge zero folio.
+
 config MM_ID
 	def_bool n
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf9b480bb3b0..c568755dd58e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -75,7 +75,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
+struct folio *huge_zero_folio __ro_after_init;
+#else
 struct folio *huge_zero_folio __read_mostly;
+#endif
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
@@ -305,6 +309,18 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 	return 0;
 }
 
+#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
+static bool __init make_huge_zero_folio_readonly(void)
+{
+	return arch_make_huge_zero_folio_readonly(READ_ONCE(huge_zero_folio));
+}
+#else
+static bool __init make_huge_zero_folio_readonly(void)
+{
+	return false;
+}
+#endif
+
 static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
@@ -965,8 +981,15 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		if (IS_ENABLED(CONFIG_READONLY_HUGE_ZERO_FOLIO) &&
+		    !make_huge_zero_folio_readonly())
+			pr_warn("Making persistent huge zero folio read-only failed\n");
+
 		return 0;
 	}
 
-- 
2.47.3



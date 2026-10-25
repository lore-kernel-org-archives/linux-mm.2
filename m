Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CD0606A320
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=LQo+bfXx
Received: by kanga.kvack.org (Postfix)
	id 23C3C6B05B7; Sun, 25 Oct 2026 13:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F1B6B05B8; Sun, 25 Oct 2026 13:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018256B05B9; Sun, 25 Oct 2026 13:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C250D6B05B7
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 330D1805DA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:29 +0000 (UTC)
X-FDA: 85361862978.03.89DF784
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E4E2180004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LQo+bfXx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd4NBiUaZHjhgQI6f1triFkm5VKVfeLrpjHZ+ms4srE=;
	b=NwWlihhEUS2GC1PwzloksGvZ8IHKnPhPeKIah1VoH/vR6DjaylDEFA+yQwlmXsMclUS2jX
	xvQFLypU5OR4MQIHwP1S5eRQIzTQj60+L5VnTrGEF6E85QlaRGr7ObNQfMBZBNRS8EFXx5
	H6D89shTziHvDoS/hDGdOiAvMF4tcNg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LQo+bfXx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950027;
	b=GPZ0Ku918jD9H3ZoLmwiC9f0Hx+mdg7UIl+28mzeeIROkcEOeKuNzx2uOs5k9mXErfhZQt
	fAwI+E8W/7fNnr/TlxCDsiNU2yBTDU5aIOwgULn69U3nWQr3rLaneh06nzUPNEYRhQphdj
	LJNSNM7EU1YML0EdvpTAq+EBMfggsLQ=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eaeb7fdda2so2420500e0c.3
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950026; x=1793554826; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cd4NBiUaZHjhgQI6f1triFkm5VKVfeLrpjHZ+ms4srE=;
        b=LQo+bfXx7g7hjsPzdQNwTrVc+t4shwasrGf4PsoGyjte54f4COF/9UytD8JtXQTTsL
         pxrM7e/xe41qbtgLMnugR5hzuwCaDkwAhRfweBYBAebKazPk7QnHOa1uYdPmNPvn1jCX
         nfS/NgAIv3fmNkUq/25xgeyIJaZO6zYpxxwv5zMdpGkl9PYjSuq2FmNetjHV99vrarLW
         zYN0oKblxqMKkzKT9cFbg+amYVLljoqzn2ynvIdQxw8Nhpbm+rU5sQvLb0c3/10HIOpi
         SkPSYialHGDcsCy43XiIAflLBufgF3GdyYLIF9u2lzvvBC6Pf2ZbbTLJbZU+3NoI6a+n
         IMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950026; x=1793554826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cd4NBiUaZHjhgQI6f1triFkm5VKVfeLrpjHZ+ms4srE=;
        b=ceyLsC9gIe2/DHCsdyiT6H1RjZMC0iBPcoaGFYiJyxYExRHjnuLX27Bm3qcLG24co6
         l9L/U8IoneihKakhI1kdtiUi2fiCvvUdyDZBsQBGNbLc7qPalrXLnM+pQM5LOJWPrN91
         WYFUazliqfSSpL1So4noDsUv8MLWOir/ZbalG0mm60+Q83WLNk6nz18lIykvN8+TzfW8
         f1Bvy3gqLP41dAc+sqATdquGMpikKUGK6kA1P92L2QCZTu37ZtZojg5mXfBmjeOVQzIC
         gQb/s2nDioAbqpceBfiocTBxoJGSDK1AAvVeR4eu+MbSAqcBjA0vCce0UWP2OX7o3+3m
         0cNQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6kLTcZnZ0TwJBzGPmbN9BNpttijJ6eyyzj1K3yuJkl/vM9oFxJDgpMo1Ca/oJUHiE/yMp6kLpxQ==@kvack.org
X-Gm-Message-State: AFq9FYKOvd7mCRNEF0C7nHCeC3NQ084WdEZ4fit4TelSNwuTcPnKOsNh
	vNFYkHNWwsF6yajWH2NmOSvqwmqq2De0fGv5bM4mkGYkCTSfpKR81eYvfnZEBc610gE=
X-Gm-Gg: AYBFou3Q8ogHOpYYyU0N492fbSadI0hl9Ym87/jb5qTPzTB/u+gElbIN3Ff8MSA7VUN
	QZ4zigJPzl00az/Z4WNIXZgiBHq27gdJQi5CGaWOQonxXhU90jkw5b0+RI/HfXO1gNZ6MolDFh2
	/brylVDYfVqwviq8pZGrMyq+DGmcToenRrppsq6IW3Z16wtjioUEHVSbC17JaHApQ1WDcjpyg5V
	frfYwkOC+1YdxJo+iND6jBPgalQ/G1KI/B01puEZW+WnUZQLSsuBNlrXekimlL8KqnBz6fUfnuz
	NX9Sh7P4wcwvrZZ/MrnbhjjDDcla4H6ouPmn4v3Ek6YcZHhKKqwImfjuo2icz4LHtldeUgf2tT3
	SBFADQtCemsQ6YF3y771qbnISuF9+2HuipOf5BDzywpnNPa5sbEOX6fFs7F89KkVJVvQAU3lCo8
	ygKF46MSsKyMCL7XM/llKzJWkF7DdMNQRtkDw4XXgsgLLU9ggWHLOBDET04bCcXxoJjs7LjQrBJ
	9beprRUck1loix0oqIUWNXzWcut06X8WhlhJ++zcleA21m7F1Hpth19VC7jVKtz3l+hfEC43bIH
	CpFHPs59ksEIY8NqTiiimNUs1II9MbLTd3SLpfVtfGBfbX0ovs391NFzaGVG4msdR4KfqMPxXUx
	T
X-Received: by 2002:a05:6122:78b:b0:5ea:c874:6c4 with SMTP id 71dfb90a1353d-5ec232c784dmr1663615e0c.16.1792950026456;
        Sun, 25 Oct 2026 10:40:26 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:26 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 5/9] kho: add read-only Kexec Handover mode
Date: Sun, 25 Oct 2026 13:40:12 -0400
Message-ID: <20261025174017.3870481-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E4E2180004
X-Stat-Signature: b4i63a1kyx8fz6nh6tauuau65jwaqfzk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792950027-102170
X-HE-Meta: U2FsdGVkX19y/Jo8kih9T4m4oWwrHwDCcYSNeS5kgBHJEPswabYHrBihrQJ/622G++BdwbTwgw0UfdE/HbXrzPAUCkyURR5ud0dGV+1yFitHQk96sYgbnPnRCr0PtsvAaY8ZGw/+5FljnCSB9l8xFjJOozG82LO49REkuCf8Vup5Wa2uG1MjLGyJ4l88TzNFG+Pgv94skXqXokavdgYaXlIu8kGwxptRSpfNjodiU1B2lqEzoXotfcAfyxtzqVyQgMaPHnnvX+I1dyNYvEkAw0SfUD5/rJNSMAQYHUSGF4SQ7uxcLUrEWVVRMhntrzYy4AMbbAHDQDeta05Ic4d/p5lKgnLA1bFU/eymLeXsCQ5ZYmswtDCKNZFwztB4W4n8k1f6jmYBlfqP5sl636TlpgJBiA5n/HoGK4bwHEVEGSXLwhxxUgb3FimPwU3fqbnP/6wezLKZGZqnFnLk4i54zEWGIbAhBCoDxroV6i22PUkuyLUblsrTQaVsLSLp8b9Q1vcAjsdSxaqnUZWaqhnrZGkIFNQuhrCvaOPKTKu9kHl4xAPDs3PgrGjh9OO0V0oarvGxFBlo5JacdoqHEZqjk/FbaUwd6ELwvp0VK9bpNdBqP64p5unqaTnV8JLJq6HJyQ+kd1VZ5nHDSiUNwBToQLDNREWpjF+aPYgPBEGzJZy+3Y4FapBRqB5dsUunpmLTF8Cn2sUptdtHePTTJY0i0S26Qnp3WwruGNnIW5/1zErvEDgyeAaMEiSaJpnueE9D68i86GzGZiifRomxGhWg4OpKP9kruD6tJyN9ZWj+hFtVjgoJpDadzl2n5UmEKt/FXHDEJfKF5DsCWTEf8od+wGacajrHtX7rKPYpXn8+pU1fmP+sJpzRoRYqcjWIi+gtWmlvmkP52DEQGE4R65pbjgnncdU1PKXAUxhdyXdUvrjzVQGWLGuBwhy8QZvDAvl1QDuu4V6S+S7yaJ519eq
 psK4yKWr
 3CDFvtoLDo0PyqPadrxZV/lFFamizF0wX2C/E9ppGm6zCdcjGlGQnbwXj6QSFvp5mveublg0qJ5iQHZQQ9JefpMoxTLqEBva+hplM2o0FLZEQmhlEIVhpurX62ZjiuCtJ7wZTHBdBh0Y11HSHPAAmitgW4Wv6Q3pH7PhW7p9uUTYj4o+BzqEv6WLE4D/Bp84J2yBRGkCt6ymVetG4jVsTiEVTkXLMS9kCKSnjjLq0csfElE4eDZdPKHE8NVjOXfdveqoHIFe0fJ2vaQAe5NGKw83Uq+QN9dMLGZuMdqOvUfUNgHSj+DFgatqWKe88bFgmpFe2y8BOHa/pfAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Kernels that inspect preserved KHO state without taking ownership of
preserved memory need a way to traverse the KHO FDT, radix tree, and
vmalloc chains in place while leaving the underlying physical pages and
metadata unmodified.

Add CONFIG_KEXEC_HANDOVER_READONLY and the 'kho_ro=<pa>' kernel
command-line parameter so both regular KHO and read-only KHO can be
compiled into the same kernel image and activated via the command line.
Map and validate the incoming KHO FDT once in an early_initcall, and
cache radix-tree node, leaf, folio, and vmalloc mappings in a unified
RCU-protected hash table (kho_ro_map_ht) for the lifetime of the
read-only KHO kernel.

Also export kho_is_ro(), kho_ro_lookup_folio_order(),
kho_ro_map_folio(), and kho_ro_map_vmalloc() so callers can check if
read-only KHO mode is active and map preserved folios and vmalloc
regions verified against the KHO radix tree.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../admin-guide/kernel-parameters.txt         |   8 +
 Documentation/core-api/kho/index.rst          |   3 +
 include/linux/kexec_handover.h                |  44 +-
 kernel/liveupdate/Kconfig                     |  10 +
 kernel/liveupdate/Makefile                    |   1 +
 kernel/liveupdate/kexec_handover_internal.h   |  13 +
 kernel/liveupdate/kexec_handover_ro.c         | 429 ++++++++++++++++++
 7 files changed, 501 insertions(+), 7 deletions(-)
 create mode 100644 kernel/liveupdate/kexec_handover_ro.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3b89b54db550..887a4b14cf40 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3051,6 +3051,14 @@ Kernel parameters
 			bootmem areas.  The form "nn%" defines scale factor
 			(in percents) of memory that was used during boot.
 
+	kho_ro=		[KEXEC,EARLY]
+			Format: <phys_addr>
+			Enables read-only Kexec HandOver mode, pointing to the
+			page-aligned physical address of a preserved KHO FDT
+			blob, and disables regular KHO. The FDT and preserved
+			memory must not be part of this kernel's System RAM.
+			Requires CONFIG_KEXEC_HANDOVER_READONLY.
+
 	kmac=		[MIPS] Korina ethernet MAC address.
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index bce7fe281194..803e5dfc3caf 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -86,6 +86,9 @@ Public API
 .. kernel-doc:: kernel/liveupdate/kexec_handover_common.c
   :export:
 
+.. kernel-doc:: kernel/liveupdate/kexec_handover_ro.c
+  :export:
+
 KHO Serialization Blocks API
 ============================
 
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..bdb8dc3c3f54 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -13,6 +13,43 @@ struct kho_vmalloc;
 struct folio;
 struct page;
 
+#if defined(CONFIG_KEXEC_HANDOVER) || defined(CONFIG_KEXEC_HANDOVER_READONLY)
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
+#else
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
+				       size_t *size)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_KEXEC_HANDOVER || CONFIG_KEXEC_HANDOVER_READONLY */
+
+#ifdef CONFIG_KEXEC_HANDOVER_READONLY
+bool kho_is_ro(void);
+int kho_ro_lookup_folio_order(phys_addr_t pa);
+void *kho_ro_map_folio(phys_addr_t pa, pgprot_t prot);
+const void *kho_ro_map_vmalloc(const struct kho_vmalloc *preservation);
+#else
+static inline bool kho_is_ro(void)
+{
+	return false;
+}
+
+static inline int kho_ro_lookup_folio_order(phys_addr_t pa)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void *kho_ro_map_folio(phys_addr_t pa, pgprot_t prot)
+{
+	return NULL;
+}
+
+static inline const void *kho_ro_map_vmalloc(const struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_READONLY */
+
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
@@ -31,7 +68,6 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
 void kho_memory_init_early(void);
@@ -112,12 +148,6 @@ static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 
 static inline void kho_remove_subtree(void *blob) { }
 
-static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
-				       size_t *size)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline void kho_memory_init(void) { }
 
 static inline void kho_memory_init_early(void) { }
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index f50daee8eff0..d633e4c9197d 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -48,6 +48,16 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 	  The default behavior can still be overridden at boot time by
 	  passing 'kho=off'.
 
+config KEXEC_HANDOVER_READONLY
+	bool "Read-only kexec handover"
+	depends on ARCH_SUPPORTS_KEXEC_HANDOVER
+	select LIBFDT
+	help
+	  Enable read-only Kexec Handover ('kho_ro=<pa>'). This allows a
+	  kernel to traverse preserved KHO subtrees, radix trees, and
+	  metadata by mapping them in place without taking ownership of
+	  or modifying the preserved KHO state.
+
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index f6bed6bcd380..74a584e6bb43 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -8,6 +8,7 @@ luo-y :=								\
 		luo_session.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o kexec_handover_common.o
+obj-$(CONFIG_KEXEC_HANDOVER_READONLY)	+= kexec_handover_ro.o kexec_handover_common.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index dd79e5006562..39e85d0e2c7d 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -18,7 +18,20 @@ struct kho_vmalloc_walk_ops {
 	int (*entry)(phys_addr_t pa, void *priv);
 };
 
+#ifdef CONFIG_KEXEC_HANDOVER
 const void *kho_get_fdt(void);
+#else
+static inline const void *kho_get_fdt(void) { return NULL; }
+#endif
+
+#ifdef CONFIG_KEXEC_HANDOVER_READONLY
+const void *kho_ro_get_fdt(void);
+bool kho_ro_cmdline_enabled(void);
+#else
+static inline const void *kho_ro_get_fdt(void) { return NULL; }
+static inline bool kho_ro_cmdline_enabled(void) { return false; }
+#endif
+
 bool kho_vmalloc_validate(const struct kho_vmalloc *preservation,
 			  unsigned int *vm_flags);
 int kho_vmalloc_walk(const struct kho_vmalloc *preservation,
diff --git a/kernel/liveupdate/kexec_handover_ro.c b/kernel/liveupdate/kexec_handover_ro.c
new file mode 100644
index 000000000000..fbf6d2ec8395
--- /dev/null
+++ b/kernel/liveupdate/kexec_handover_ro.c
@@ -0,0 +1,429 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_ro.c - Read-Only Kexec Handover backend
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Implements the read-only KHO backend (kho_ro=<pa>). In read-only mode, KHO
+ * is not enabled for outgoing or incoming page ownership transfer and makes no
+ * changes to boot or struct page initialization. Instead, when subsystems
+ * retrieve preserved state, this backend traverses the KHO FDT, radix tree,
+ * and preserved metadata by mapping physical pages read-only (PAGE_KERNEL_RO)
+ * without modifying or freeing the KHO metadata or reclaiming the preserved
+ * pages.
+ *
+ * The preserved KHO FDT, radix tree, and folio/vmalloc metadata are assumed to
+ * remain static for the lifetime of the read-only KHO kernel: the FDT is
+ * mapped at early_initcall time, and radix-tree nodes, leaves, and
+ * folio/vmalloc mappings are cached on first access. If a caller needs
+ * read-write access to preserved folio contents outside of KHO metadata, it
+ * can map them with PAGE_KERNEL via kho_ro_map_folio().
+ */
+
+#define pr_fmt(fmt) "KHO-RO: " fmt
+
+#include <linux/bitops.h>
+#include <linux/cleanup.h>
+#include <linux/hashtable.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+
+#include <asm/setup.h>
+
+#include "kexec_handover_internal.h"
+
+#define KHO_RO_MAP_HASH_BITS 10
+
+/*
+ * In read-only KHO mode, the preserved KHO tree and memory must reside outside
+ * of the kernel's direct map so they do not conflict with the kernel that owns
+ * the KHO state. Virtual mappings used to access the tree and preserved memory
+ * are stored in an RCU-protected hash table (kho_ro_map_ht) that remains
+ * static for the lifetime of the kernel and is never unmapped, allowing fast
+ * lockless multi-threaded lookups under rcu_read_lock() during traversal while
+ * serializing insertions on cache misses with kho_ro_lock.
+ *
+ * Entries are keyed by (pa, size, prot):
+ * - Radix-tree nodes/leaves and preserved folios use their physical address,
+ *   mapped byte size (PAGE_SIZE << order), and pgprot_t.
+ * - Preserved kho_vmalloc regions use preservation->first.phys with size = 0
+ *   and PAGE_KERNEL_RO so a discontiguous vmalloc mapping never collides with
+ *   a direct page/folio mapping (which always has size > 0).
+ */
+struct kho_ro_map_entry {
+	struct hlist_node node;
+	phys_addr_t pa;
+	size_t size;
+	pgprot_t prot;
+	void *vaddr;
+};
+
+static bool kho_ro __ro_after_init;
+static phys_addr_t kho_ro_fdt_phys __ro_after_init;
+static phys_addr_t kho_ro_mem_map_phys __ro_after_init;
+static const void *kho_ro_fdt __ro_after_init;
+static DEFINE_MUTEX(kho_ro_lock);
+static DEFINE_HASHTABLE(kho_ro_map_ht, KHO_RO_MAP_HASH_BITS);
+
+/**
+ * kho_is_ro - Check if KHO is operating in read-only mode.
+ *
+ * Return: true if read-only KHO mode is active, false otherwise.
+ */
+bool kho_is_ro(void)
+{
+	return kho_ro;
+}
+EXPORT_SYMBOL_GPL(kho_is_ro);
+
+static int __init kho_parse_ro(char *p)
+{
+	unsigned long long pa;
+
+	if (!p || kstrtoull(p, 0, &pa) || !pa || !PAGE_ALIGNED(pa))
+		return -EINVAL;
+
+	kho_ro_fdt_phys = pa;
+	kho_ro = true;
+	pr_info_once("Read-only mode enabled with FDT at %pa\n",
+		     &kho_ro_fdt_phys);
+	return 0;
+}
+early_param("kho_ro", kho_parse_ro);
+
+static int __init kho_ro_early_parse(char *param, char *val,
+				     const char *unused, void *arg)
+{
+	if (parameq(param, "kho_ro"))
+		kho_parse_ro(val);
+	return 0;
+}
+
+bool __init kho_ro_cmdline_enabled(void)
+{
+	static char tmp_cmdline[COMMAND_LINE_SIZE] __initdata;
+
+	if (!kho_ro) {
+		strscpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+		parse_args("kho_ro", tmp_cmdline, NULL, 0, 0, 0, NULL,
+			   kho_ro_early_parse);
+	}
+
+	return kho_ro;
+}
+
+static int kho_ro_map_range(unsigned long vaddr, phys_addr_t pa, size_t size,
+			    pgprot_t prot)
+{
+	if (!pa || !size || !PAGE_ALIGNED(pa | size) || pa + size - 1 < pa)
+		return -EINVAL;
+
+	if (region_intersects(pa, size, IORESOURCE_SYSTEM_RAM,
+			      IORES_DESC_NONE) != REGION_DISJOINT) {
+		pr_warn_once("Cannot map System RAM at %pa (size 0x%zx)\n",
+			     &pa, size);
+		return -EINVAL;
+	}
+
+	return vmap_page_range(vaddr, vaddr + size, pa, prot);
+}
+
+static void *kho_ro_map(phys_addr_t pa, size_t size, pgprot_t prot)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area_caller(size, VM_IOREMAP, __builtin_return_address(0));
+	if (!area)
+		return NULL;
+
+	area->phys_addr = pa;
+	if (kho_ro_map_range((unsigned long)area->addr, pa, size, prot)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+
+	return area->addr;
+}
+
+static int __init kho_ro_init(void)
+{
+	phys_addr_t mem_map_phys;
+	const void *fdt;
+
+	if (!kho_ro)
+		return 0;
+
+	fdt = kho_ro_map(kho_ro_fdt_phys, PAGE_SIZE, PAGE_KERNEL_RO);
+	if (!fdt) {
+		pr_err("Failed to map FDT at %pa\n", &kho_ro_fdt_phys);
+		goto err_disable;
+	}
+
+	if (kho_check_fdt(fdt, kho_ro_fdt_phys))
+		goto err_unmap;
+
+	mem_map_phys = kho_get_mem_map_phys(fdt);
+	if (!mem_map_phys)
+		goto err_unmap;
+
+	kho_ro_fdt = fdt;
+	kho_ro_mem_map_phys = mem_map_phys;
+	return 0;
+
+err_unmap:
+	vunmap(fdt);
+err_disable:
+	pr_warn("Disabling read-only mode\n");
+	kho_ro = false;
+	return -EINVAL;
+}
+early_initcall(kho_ro_init);
+
+const void *kho_ro_get_fdt(void)
+{
+	return kho_ro_fdt;
+}
+
+static void *kho_ro_lookup_cached(phys_addr_t pa, size_t size, pgprot_t prot)
+{
+	struct kho_ro_map_entry *entry;
+	void *vaddr = NULL;
+
+	rcu_read_lock();
+	hash_for_each_possible_rcu(kho_ro_map_ht, entry, node, pa) {
+		if (entry->pa == pa && entry->size == size &&
+		    pgprot_val(entry->prot) == pgprot_val(prot)) {
+			vaddr = entry->vaddr;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return vaddr;
+}
+
+static void *kho_ro_insert_cached(phys_addr_t pa, size_t size, pgprot_t prot,
+				  void *vaddr)
+{
+	struct kho_ro_map_entry *entry;
+	void *existing;
+
+	guard(mutex)(&kho_ro_lock);
+	existing = kho_ro_lookup_cached(pa, size, prot);
+	if (existing)
+		return existing;
+
+	entry = kzalloc_obj(*entry);
+	if (!entry)
+		return NULL;
+
+	entry->pa = pa;
+	entry->size = size;
+	entry->prot = prot;
+	entry->vaddr = vaddr;
+	hash_add_rcu(kho_ro_map_ht, &entry->node, pa);
+
+	return vaddr;
+}
+
+static void *kho_ro_map_cached(phys_addr_t pa, size_t size, pgprot_t prot)
+{
+	void *vaddr, *cached;
+
+	vaddr = kho_ro_lookup_cached(pa, size, prot);
+	if (vaddr)
+		return vaddr;
+
+	vaddr = kho_ro_map(pa, size, prot);
+	if (!vaddr)
+		return NULL;
+
+	cached = kho_ro_insert_cached(pa, size, prot, vaddr);
+	if (cached != vaddr)
+		vunmap(vaddr);
+
+	return cached;
+}
+
+static void *kho_ro_map_radix(phys_addr_t pa)
+{
+	return kho_ro_map_cached(pa, PAGE_SIZE, PAGE_KERNEL_RO);
+}
+
+static bool kho_ro_radix_key_exists(unsigned long key)
+{
+	const struct kho_radix_leaf *leaf;
+
+	leaf = kho_radix_find_leaf(kho_ro_mem_map_phys, key, kho_ro_map_radix);
+	if (!leaf)
+		return false;
+
+	return test_bit(kho_radix_get_bitmap_index(key), leaf->bitmap);
+}
+
+/**
+ * kho_ro_lookup_folio_order - Look up the preserved order of a physical page in KHO.
+ * @pa: Page-aligned physical address of the preserved folio.
+ *
+ * Queries the preserved KHO memory radix tree in read-only mode to determine
+ * the order at which @pa was preserved.
+ *
+ * Return: Non-negative page order on success, -ENOENT if @pa is not preserved,
+ * or -EOPNOTSUPP if read-only KHO is not active.
+ */
+int kho_ro_lookup_folio_order(phys_addr_t pa)
+{
+	unsigned int order, max_order;
+
+	might_sleep();
+	if (!kho_ro)
+		return -EOPNOTSUPP;
+	if (!pa || !PAGE_ALIGNED(pa) || !kho_ro_mem_map_phys)
+		return -ENOENT;
+
+	max_order = min_t(unsigned int, __ffs64(pa >> PAGE_SHIFT),
+			  KHO_RADIX_KEY_WIDTH - 2);
+
+	for (order = 0; order <= max_order; order++) {
+		if (kho_ro_radix_key_exists(kho_encode_radix_key(pa, order)))
+			return (int)order;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(kho_ro_lookup_folio_order);
+
+/**
+ * kho_ro_map_folio - Map a preserved KHO folio into kernel virtual address space.
+ * @pa:   Page-aligned physical address of the preserved folio.
+ * @prot: Page protection flags for the mapping (e.g. PAGE_KERNEL_RO or PAGE_KERNEL).
+ *
+ * Looks up @pa in the preserved KHO radix tree to determine its folio order,
+ * maps the entire folio (PAGE_SIZE << order) into kernel virtual address
+ * space with @prot permissions, and caches the mapping (keyed by @pa, size,
+ * and @prot) for the lifetime of the read-only KHO kernel.
+ *
+ * Return: Virtual pointer to the mapped folio on success, or NULL on failure.
+ */
+void *kho_ro_map_folio(phys_addr_t pa, pgprot_t prot)
+{
+	int order;
+
+	might_sleep();
+	order = kho_ro_lookup_folio_order(pa);
+	if (order < 0)
+		return NULL;
+
+	return kho_ro_map_cached(pa, PAGE_SIZE << order, prot);
+}
+EXPORT_SYMBOL_GPL(kho_ro_map_folio);
+
+struct kho_ro_vmalloc_ctx {
+	unsigned long vaddr;
+	size_t contig_size;
+	unsigned int order;
+};
+
+static const struct kho_vmalloc_chunk *kho_ro_vmalloc_get_chunk(phys_addr_t pa)
+{
+	if (kho_ro_lookup_folio_order(pa) != 0)
+		return NULL;
+
+	return kho_ro_map(pa, PAGE_SIZE, PAGE_KERNEL_RO);
+}
+
+static void kho_ro_vmalloc_put_chunk(const struct kho_vmalloc_chunk *chunk)
+{
+	vunmap(chunk);
+}
+
+static int kho_ro_vmalloc_map_entry(phys_addr_t pa, void *priv)
+{
+	struct kho_ro_vmalloc_ctx *ctx = priv;
+	int err;
+
+	if (kho_ro_lookup_folio_order(pa) != ctx->order)
+		return -EINVAL;
+
+	err = kho_ro_map_range(ctx->vaddr, pa, ctx->contig_size,
+			       PAGE_KERNEL_RO);
+	if (err)
+		return err;
+
+	ctx->vaddr += ctx->contig_size;
+	return 0;
+}
+
+static const struct kho_vmalloc_walk_ops kho_ro_vmalloc_ops = {
+	.get_chunk = kho_ro_vmalloc_get_chunk,
+	.put_chunk = kho_ro_vmalloc_put_chunk,
+	.entry = kho_ro_vmalloc_map_entry,
+};
+
+/**
+ * kho_ro_map_vmalloc - Map a preserved vmalloc region read-only in place.
+ * @preservation: Pointer to the KHO vmalloc preservation metadata.
+ *
+ * Allocates a VM_IOREMAP virtual address range, validates each chunk header and
+ * preserved page order in the cached KHO radix tree, maps the preserved
+ * physical pages directly with read-only permissions (PAGE_KERNEL_RO) with
+ * zero RAM allocation or memcpy overhead, and caches the mapping for the
+ * lifetime of the read-only KHO kernel.
+ *
+ * Return: Read-only virtual pointer on success, or NULL on failure.
+ */
+const void *kho_ro_map_vmalloc(const struct kho_vmalloc *preservation)
+{
+	struct kho_ro_vmalloc_ctx ctx;
+	struct vm_struct *area;
+	unsigned int vm_flags;
+	size_t total_size;
+	void *cached;
+
+	might_sleep();
+	if (!kho_ro || !kho_vmalloc_validate(preservation, &vm_flags))
+		return NULL;
+
+	/* Use size 0 in the cache key to distinguish vmalloc from folios. */
+	cached = kho_ro_lookup_cached(preservation->first.phys, 0,
+				      PAGE_KERNEL_RO);
+	if (cached)
+		return cached;
+
+	total_size = (size_t)preservation->total_pages * PAGE_SIZE;
+	area = get_vm_area_caller(total_size, VM_IOREMAP,
+				  __builtin_return_address(0));
+	if (!area)
+		return NULL;
+
+	ctx = (struct kho_ro_vmalloc_ctx){
+		.vaddr = (unsigned long)area->addr,
+		.contig_size = PAGE_SIZE << preservation->order,
+		.order = preservation->order,
+	};
+
+	if (kho_vmalloc_walk(preservation, &kho_ro_vmalloc_ops, &ctx)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+
+	cached = kho_ro_insert_cached(preservation->first.phys, 0,
+				      PAGE_KERNEL_RO, area->addr);
+	if (cached != area->addr)
+		vunmap(area->addr);
+
+	return cached;
+}
+EXPORT_SYMBOL_GPL(kho_ro_map_vmalloc);
-- 
2.56.0.307.g5fe7bd680c-goog



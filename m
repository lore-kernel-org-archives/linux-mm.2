Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E65C53219
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9EB6B0088; Sun, 26 Jul 2026 18:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082316B008A; Sun, 26 Jul 2026 18:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1B36B008C; Sun, 26 Jul 2026 18:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEF016B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B43F1C0C23
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:23 +0000 (UTC)
X-FDA: 85032355086.10.DE49BC9
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf01.hostedemail.com (Postfix) with ESMTP id 683C640008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="a6MJPm/i";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 314hmaggKCNwH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=314hmaggKCNwH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xln7DlQ/Erzs4SFfLWkI0/3SV9SUpyYGCbY4YNaEuz4=;
	b=SjiDMVVhNu/QvC4Hmeru99Qj/xmm9+zF618Dx9BnR/D7p4clGkP/B+T7lSKc+oPgpCRy7p
	oc2pN+KJSs4JDdYrrPDzsY/gNGTo8Im4U1rorX5sZd5eIVGnBotIasgNOUJFzkFoxPOYkI
	sokTswQ4cGY9GYK9cUWlCIHk0uRe1oo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="a6MJPm/i";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 314hmaggKCNwH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=314hmaggKCNwH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104601;
	b=rPEaw9yffYFx4X+2dKsMCNNwfWQzapLC6nijgMHyw0dk7JJt7OR/IZBewH8hPqsNekiXD8
	4n6Kcxsrey821vvMC9oF4NoOH8h78jiBfqYUSVoAI2TaWLpjzz1N7xa7j5ZsE0EF4YNpeP
	q0BAP4JgW56JtWCA3paOG8lxG9USxrY=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-472a798fc7cso1358137f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104600; x=1785709400; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xln7DlQ/Erzs4SFfLWkI0/3SV9SUpyYGCbY4YNaEuz4=;
        b=a6MJPm/ifrhYn0OGw5F/lDSQYALTYnIvg8DsNHwRl6x+PTHr5udBRRAGdPojVmimUD
         vWI7aCTpYzu6PfGk2x4SGMGloFiX4HYU/p6loNTE9g84aC8iTFaK3QpXEg/Tavph6PNp
         ElyqV7PbI2AqLnIQDJ372wWPv2dT/UDTcIHoC2tjwylnc7FSVyCA0bdcy+xDUu4AGCOD
         Bzy4GnAijlRn3HWf3pJlPDaHKoLSDbjwGyRLjLgxROpVDtf/aR4Q72KI8UzbTutW/L+b
         7icc7SWh9CX31odS/uVJSfEYZsR8w8YQN9yUPUYBeGvy8xU9dJo6DDO4wheClMqwJIFO
         r6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104600; x=1785709400;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xln7DlQ/Erzs4SFfLWkI0/3SV9SUpyYGCbY4YNaEuz4=;
        b=FGYkqaUtSpRb8kduG757DzgG6OsmM0w0zB/kjdhoz3g9Ngb5JSc+kgdCT2kBXDuOGn
         qezUogX9qrsQgMOt0dbOYrDpSTFxTfmeCbTPNgtE8yL2yWOP284CNw8J3Bl/KI5SWeOa
         gjo63bCL4gCNRvpPMUhZGUsC89wdnqBebWKGcPhTxmCTUZwJkGb19pGMYcCYRYQxlF9R
         pKRKeBgnSuZSsuXd9ODWeD8nlDHHq/f2FzVyElWz3h3AbiKQ9C2PON4LJzIzVE2dBOKQ
         Toa7nIzLW6FyJWfwyvz6CnWW+JWcI6T1DqopkKmcvQh6EQDrOw85lM+lY5Nhzv6gh86x
         7tlQ==
X-Gm-Message-State: AOJu0YzzAFjuYA/SYD9vHEN7iDlZB6XM2eVYa/cPHtMgqgnJ/UWCTlF7
	cnR7cn97RqJgfeCAz/JaeOmScU33F1RY+JKFQzn2h//B6AOu5rwJj2qA8LxtsTKFGZEwfVdn0Oj
	myFsmJYYHXxhfMA==
X-Received: from wmbju21.prod.google.com ([2002:a05:600c:56d5:b0:493:c2c9:129b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b20:b0:495:4a34:16e3 with SMTP id 5b1f17b1804b1-496b56f0fc4mr100656295e9.1.1785104599743;
 Sun, 26 Jul 2026 15:23:19 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:34 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
Subject: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map helpers
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 683C640008
X-Rspam-User: 
X-Stat-Signature: do88g1hwcyqezub3bagxgtjupte3tnko
X-HE-Tag: 1785104601-887143
X-HE-Meta: U2FsdGVkX19xC07j4zrhC18pSo4gYyXRFSdFM5jed0agdG7ddXyRWe/hxZYlaGqVSNs6BxpEv/dT4RybYT6FPecTAvHuMvbe+lc8RYCEtVu+9BvJWVdH/HIaSF3pOXAIF8luMo98yiTbOqJ2kn+w9qVL6eNqdwvQ4IGuwzctuiqmeLUcRhLkEKCWWQ8TO+iPsVQ60P59qfEfoAVgIh3jI6E2VNC4QBziKVZd6v8wD6loadlk+kFn4WV8ysGik9Zxf13Js3a+QJ8dz6Z+nGbr/4lw3wuctZEIC/whXS3BaJkSSwRKqFMhef/vN1Igs98hTP7Z1OF7lEZdFotr999T2KYxkyLIKgBmO2lYY6+Dc5FaPDCT8P2riClGbExYW36UJroJLOnNqtp8Kr9evGJCPasTc7R2mPQehon0n30Ppln6mahK+3gKHwk+UxYYIPC301wrTWfzK3Bsod3HpmFkAxbtK7HL7UuxL6r1tyEWUv8S7MwEscmV7mrlQ/pJhB/jaihmzd6hUAx5/7nv2f3pnd+2CSp35xdA1pKezsnZSVePYFs68pzKUSum5oCOZzkKcGKCPHaEqr8HxmxOPuaZLglInnESSUQSfCEKKRLCXOJOmbVwBNgnRMVTsIRfHc5CtmFx8wO8A1b8ob6JMTsUv1tLqw1nsVjaCwn3EOCeQ7ir6hfTMzDSE4jQwvIgNkd/br+wmBdyQozDv0+wfh9wHYTgREO+gNcdE43l8ZOW8yruJzjePDb+2F2gLN95v6QuLFu3Zz5duO4pUVGZHcnoGzl6cRa7i6WXYXh8wsNE5PmFnjy5163TZy9CLPU/dVmMBhKk1rVmFMPqwm+zsIQ9zydLHvp5pyHJGTRAtXUrZn2ews6Skq/bupe6K6A/A1+gBVX4/uPYJRKcVtktbyRnKfAzuH1EXluA6cPYe4U0SRzxaovxWl//UTZseYJbZWUyYCCUf/ICoSrbLPDZlaf
 QgnLRXwQ
 tJFd+Tc6AonkuQzF1XQAe0IaV6htc4OG8nAD1Opy471zCawaKs+PTkRgbT6OW1iZ5S60mr2yRrc4Op/i361VaUVRiqhbOka245C1iDLQNflDNsOqVzzYhRKEv7h6wzoZ7u6oGVppQkYL/rH0i8xLTufLjatT5J5a5hZcdQBTPUQHzkjzbU5+mbJess8MDGNUCcyaS2SDgAuFIZIumHH6+kWWJ5n81ETmjTYB257nYf+7XuH32+FyMCO0o/GsKrz6rRp/s3uyWSjdTvl8krBaMpvTohpbDFSnvrsZO0DtM7Da+nIkI5kE3YiDEqLqPRUQgqqZqIaPBK+hBv6WRXnxSAeKebQPG4PQoDAzUkMNfTj4RNFngDa+j5GD2NkPuKMveLZoLXxH4TUkDpi3+4IZ/CeXf7l4Vv7LXV0BO42S+Xycn9AoLB+dg9AKkQsLq22+H7rEtZQ9I6MU48e7hGvHwHcKM8dyw3kc8th9Oat9XOq7YeZjQoO0nIDxy3bGXOOXbkhzGUpX2Rgcen3GFY+yZvld1wpjSIiyC+dDUFEJGLmYK4fmjfboDnMK2Mrm3xt25+FlG5XTQrl0ykiP/KrqGLuq2Lkrx8tTrYW6Igj4j9RitAVD6PLiqvhcBLbd9g+Bj3PeXON+2Js1C0g/EGI8KY+rfD/2XtW6iJnM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>

Let's provide folio_{zap,restore}_direct_map helpers as preparation for
supporting removal of the direct map for guest_memfd folios.
In folio_zap_direct_map(), flush TLB to make sure the data is not
accessible.  On some architectures, there may be a double TLB flush
issued because set_direct_map_valid_noflush already performs a flush
internally.

The new helpers need to be accessible to KVM on architectures that
support guest_memfd (x86 and arm64).

Direct map removal gives guest_memfd the same protection that
memfd_secret does, such as hardening against Spectre-like attacks
through in-kernel gadgets.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
[Added comment, dropped modified set_direct_map API, added highmem check]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/set_memory.h | 13 +++++++++++++
 mm/memory.c                | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5ac..1bf2a15bca118 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -40,6 +40,15 @@ static inline int set_direct_map_valid_noflush(struct page *page,
 	return 0;
 }
 
+static inline int folio_zap_direct_map(struct folio *folio)
+{
+	return 0;
+}
+
+static inline void folio_restore_direct_map(struct folio *folio)
+{
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
@@ -56,6 +65,10 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+int folio_zap_direct_map(struct folio *folio);
+void folio_restore_direct_map(struct folio *folio);
+
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
diff --git a/mm/memory.c b/mm/memory.c
index a73af1fccb3d0..789c65a6d6a0e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
 
 #include <trace/events/kmem.h>
 
@@ -7758,3 +7759,48 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_vma_unlock_read(vma);
 }
+
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
+/**
+ * folio_zap_direct_map - remove a folio from the kernel direct map
+ * @folio: folio to remove from the direct map
+ *
+ * Removes the folio from the kernel direct map and flushes the TLB.  This may
+ * require splitting huge pages in the direct map, which can fail due to memory
+ * allocation.  So far, only order-0 folios are supported; this guarantees
+ * the unmap is either a complete success or a total failure.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int folio_zap_direct_map(struct folio *folio)
+{
+	struct page *page = folio_page(folio, 0);
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	if (folio_test_large(folio) || folio_test_highmem(folio))
+		return -EINVAL;
+
+	ret = set_direct_map_valid_noflush(page, 1, false);
+	flush_tlb_kernel_range(addr, addr + folio_size(folio));
+
+	return ret;
+}
+EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
+
+/**
+ * folio_restore_direct_map - restore the kernel direct map entry for a folio
+ * @folio: folio whose direct map entry is to be restored
+ *
+ * This may only be called after a prior successful folio_zap_direct_map() on
+ * the same folio.  Because the zap will have already split any huge pages in
+ * the direct map, restoration here only updates protection bits and cannot
+ * fail.
+ */
+void folio_restore_direct_map(struct folio *folio)
+{
+	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_page(folio, 0),
+						  folio_nr_pages(folio), true));
+}
+EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
+#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */

-- 
2.54.0



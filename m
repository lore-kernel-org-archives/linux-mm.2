Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272A4C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845836B00A1; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C5F6B00A2; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3B86B00A3; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5299B6B00A1
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF39314025D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:29 +0000 (UTC)
X-FDA: 85052076858.07.ACD71C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C700A0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgNuVO3e;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3kXUz2Z2rDW9BnKcIvM/TL6/lSSMoYpc0koUm//CXU=;
	b=I9YZFBZbIoYVsziRMX5Nt9z4G98uzrk8CNw3sMmO1urT4P6TXXBko8tZGqF4K1ZQ6iwolC
	x+u/5SY1uu3jf41xipz8PdiDc4PFx68+4/NJoWgZRCVEuk+lkb4fYa8SJUNdsfVf0vYLXq
	UtSkaqXCi/2uiFvLlr8vdGxLqK2HOnA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574168;
	b=m7PJ/T2fSQhClp4zGTXCKC37JDIflQMUw+d2+CXuemowY2n79pYAXairl4LVnPESfxlTqF
	evsXR4kPQ/mma4c23IcPh2XqGKnZzFZ9OUojW+gOvu+JJdRDVjjHPY5pzdJuowJbsfr43V
	gMClITELQ1ZaF5i4GDCG5unVXgsXZbs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgNuVO3e;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DECF960AA4;
	Sat,  1 Aug 2026 08:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5921F00ADE;
	Sat,  1 Aug 2026 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574167;
	bh=v3kXUz2Z2rDW9BnKcIvM/TL6/lSSMoYpc0koUm//CXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgNuVO3ecZRiZnO66E61fzNWgHjg8+r203fe7t0v1iYhva313WTdnWnUOfZyONHkk
	 i7/aVSiBiapw7W6dmdrvfsnMWFIpglmqg7ccNGjzVDZq1M+t0gGjCwzmkwq7G4n0IB
	 uRthP/MB63J0+6mwIClV4OjKJJeGZ/QWz+BbeiyVcVhpFwRY1lfqRiviRYF9ioQMaL
	 DHGvhIVF0D4n+4ZqebVLqEX9dlL1BgkfkUkZ9Xgf+bW+4T5ACsKlhihPMvlAQ0yjtq
	 YxNnxNwx3tmNjpDLIVGjImpJCP5dLgwFlwPpoZvKvIfkq5UMFk7FQxCngJa5XNs0Vs
	 65dHIVuRteNbA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/22] kho: initialize kho_scratch pointer earlier in boot
Date: Sat,  1 Aug 2026 10:48:23 +0200
Message-ID: <20260801084833.1897543-15-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r1no3tjct9utf4u87fmurt8468qez3fy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C700A0003
X-HE-Tag: 1785574168-989538
X-HE-Meta: U2FsdGVkX1+h5WJCU3qINFGPD5JF97Ihcv1x30L0XDPDOwlzoLi5ZVY4/BjCR9+gar4B9gmDF2DgKGA2p8RC3ijqJjeSNhKWfnMZaomKf/z2EVMXSKeKgPSN4A1mR6LioSeecl9K4Z9CJ5VeFAC9KVWX4mxcURyh3vijULY90r4G9ijgaQrtT+Qd6W4AjzegNEHZkoDLAH6vyQRAGygCf7hpFl5QFDgM0Rf8loRROyzRzHu00Ba8Qm/ohFvviiqOQukhQJyhCXfEFkgjaYjucBnUSm3xNuHU3vZ9pyWMV1spMTgWkJNsuyjBe+JGgS6cuXHe7zYvGSqO3HxMjdlW06yVxUmzDpa9ZACteuf4DHPGke/b2WKi4s03j2UzzHj2YiqIOVsgRMuyWnubtGaJ8oCWqntyb13to5rFBs+RpCwLFNvsYxThcmaezBWEZCJbZzOP3kt4gQ7gGuAuifEmbLm+sUbyd49huJ/XYrWjh4XccgjocB9kgCQwyiXoCwGLZ0rLGr12Uxz8yAhEqa2mMnOQP0I8d8cv460ZqhYkRi4VqvrtpfOI34UMtDUKO7qWXNYlPXrFo+VGjDlvfRf644v1SzosUHWYh9jIpI5P47js+ONWY9TXReYPCG9v8RCY0eLaGsYVrCeKxpK8X/L51zsA3mJ6hnNtLU1yv/rYIoW4gAaVOaPW0rQnAqQdkChPegsaRbB/fIlkouaJgxZBKbNbhV9v8uKVPPJkvC40JY0SXMnOGFx9Csbr75eELGs4JJQwXbPS/WMl4HURDnrGE2DuWwAfn9xmXyNrlUV0pKAi/i5KD5stJG2CO2634GdFi0NFr3hk88QaQsQE7unjA/eAMez5d+xLqmuVmN7XBxwbbis7eXcie9t1O8BD7kQgHxGryY1oxK9kqhcXnVRd86Nct0O80kRKT4ok+F8FYns/qebLkWyCTeAq41uEmImwpccxqcZ1i2/8HIOTPfd
 8LJcwjIw
 9yBB56pkVOmeNoWM+W+/R/+M+J9O/x0xMTYAPQvFWFZOpt7asOj9En5VaadjgUglMksSQGBWbomhWsXRjn6btXD9XKNWEl2aaUQdGhFcPgec89HRThNeCH2B/Ucv4PAhQbpmsRfywO3OQWtqYT8yNjR2b2km/v69Mxq+e0aUmY6Nfihn6dSipVu5QL0WOhyympodBuel2xdgnRUffdY1fUmu4DTCHLItxAbM+V6L4zuUff0+OmQojxDU3Lv8R5CVPKCxAGPzcgw2lnqCiuyimeS3HHtwMdqHuDHj+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In a future patch, mm init will use kho_scratch_overlap() for deciding
the migrate type of pageblocks it initializes. The earliest user
currently is free_area_init(). kho_scratch_overlap()
relies on kho_scratch pointer being initialized. Introduce
kho_memory_init_early() to do this.

kho_populate() would normally be a good place to do this, but
unfortunately, phys_to_virt() does not work at that point on ARM64. So
we need yet another initialization function.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 15 +++++++++++++--
 mm/mm_init.c                       |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 40cb95a80981..18ba417f1ada 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -33,6 +33,7 @@ void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
+void kho_memory_init_early(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
@@ -110,6 +111,8 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
 
 static inline void kho_memory_init(void) { }
 
+static inline void kho_memory_init_early(void) { }
+
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b3b97a6ff9c8..2ddfc804cdf7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1534,8 +1534,6 @@ static void __init kho_mem_retrieve(void)
 	const void *fdt = kho_get_fdt();
 	int err;
 
-	kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1756,6 +1754,19 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
+void __init kho_memory_init_early(void)
+{
+	if (!is_kho_boot())
+		return;
+
+	/*
+	 * kho_scratch_overlap() needs kho_scratch to be initialized. It
+	 * is used by free_area_init() on KHO boots, so initialize it
+	 * early.
+	 */
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+}
+
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..84d4b1c997bc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2687,6 +2687,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	kho_memory_init_early();
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-- 
2.55.0.571.g244d577d93-goog



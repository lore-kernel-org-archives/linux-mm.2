Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F8DEC01A2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB72B6B00A0; Mon, 23 Mar 2026 03:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EF66B00A2; Mon, 23 Mar 2026 03:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4F86B00A3; Mon, 23 Mar 2026 03:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 979326B00A0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:50:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B80013BF8C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:50:33 +0000 (UTC)
X-FDA: 84576555546.19.81BA9B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91AB5100002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:50:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2yPHSZJ;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBQ46eALmOXx1bXFmc5/BhXaBncR35rS+7D8fkUk74Y=;
	b=pHkjB0Tn4L0Nog0PP/z379R2kLo1GLFwcgdwMidovTSaed2N0tmkDJQ6BrDR4wrw4Q7YqA
	tEbS3aEo2Bi4pFhXmHS7hdBwC1fWwuHg9U2TlXzbSTj6xRM1RIdPBw0H4c5eD3boXeCzp1
	eWkn7nPWqwHGtsmE7hGTSVWLu3nZHyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252231; a=rsa-sha256;
	cv=none;
	b=eRix/9MJHDI+9ZLJsH4KD6bkhu3aoOLN56dpGghvKC29j5olA8PMdkxjXceexId2bhR78d
	EhSYDgOzPOUfooMggFptVwke+fR+TgOyP48PsZUPT0hm0KilGt0ZXTzKElFcapDKffsMMk
	D5faYJlggDE3um1g6Z+B6WUHDlO4A18=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2yPHSZJ;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C11DB43704;
	Mon, 23 Mar 2026 07:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A012C4CEF7;
	Mon, 23 Mar 2026 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252230;
	bh=2YaMKdXLS6q2N8eU5YUjQf/EJjPIOHb0bH+1NaX/nR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2yPHSZJSFV/2Xg29g07aWdlpqOxb4al6/yvYuIOUOc2J7tJq3yci9lYgN2Ad0Btc
	 nh8HF9hH3MVm8s1S/WvMnipPqcfHyqAWEvEIecCcyDRi1zIUz73z0ufinHvS2jUzLd
	 5aN1Ha8QPGf10iolGEgBJSw3s3hSAP0Nc5WD7PS9QgwP1azCodE+X0whKC6tqHZLc6
	 x38IZNl+bgo7TYx0jvflmrbVMoc8805c5TR7QMdkpN9XA29LY99N0h9RQbpDy+SrSX
	 EuBPFYqGifP/Y+eDtcoJ7SoPLUbAZ5a/FJM8kp8xH+wzmAySKlRhhdc4rhpWSVh4yl
	 yYvsW9iWMARwA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 9/9] memblock: warn when freeing reserved memory before memory map is initialized
Date: Mon, 23 Mar 2026 09:48:36 +0200
Message-ID: <20260323074836.3653702-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: adbzma1fejcmgcig3c7uiyxan6o5p1p1
X-Rspamd-Queue-Id: 91AB5100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774252231-748083
X-HE-Meta: U2FsdGVkX19ST1GZ343Ju7A8TPgR/B/XzRhn1lyVhhm7tB3Z2/VFoi3aYE2MpGm7+zplGeIbkH8hVi9gysfaXMOAfoVdV6E26dOLs47J1lr5njiBsivmvr1swnitifq2TeKhopvALNIzmxSOnDMKhBtes+KhNsVApTs8vMpeROPMgF2O+2XX7cY1soc7gImMWcBDk+hEG/d4YJ2mhZdPrkNGjiW36UMIFwXAJj9KO9Y9ZdnKMrgNpwk4jSgrjX+udhgJhLSkfs/kC4y6UkRXdaHDrD/9mq4L08xFleqvRTWHUQTZlRxIaYfAWktzCdInDiMuTsmyV0yMgni5MunKAMoUT3I9kmO9NX9J+G+2GvVruycyuQW1Mbq8ek6K14HwRACcTkCpSJZzK0G62MUCLDmsJ2e/Cc8rMs22HM5pHBOAR4m5QAMGUn9/zTGryHId8RXbwXOmTk0YNFS4oBh4Bdq7xRzUl04lfl/ikFlA3kWs5oCYaaUbBT4jQODRwQLTx50X1ZGCCpeN45RaJdY1FUq7ZmAI86uPEcB3jHg6QUbbPp1Z7jHH6kA2j9CWt+V+X9NLC+SQ0Vr8hQO2F7958aTOjhhINiaYxzKhb18ixa4F13bydZQWZESV91FFVueSQFSdU4FENf/Ddwjl9rbwc0r7buv5radq2ENh5RoByl/Om+uj1W38+CQD/FNuAu1CCWDkRugmTnh8dA1+PZpjVafihPPLpi2cHXoWvSUKITtZFfN+4xYWqcTB60JhOYtPxgpX4yNYGQG0SbdP7i5dgG4vIHOPuf9MzBrZDYwqnaCH1R8r8rdLddy6XjBvVITlkH9mRocsTkl9uvLqaA+tLlIKQy2aQoiCR7xFbtICSgpUrXroJVRi/TU6RA8TKmKilb8DQPcuGJfmNiay8svYyEoOpM1ygf2mwXILsepf8lMPDZKsoWk8DB97lePsW8tqN4SWa2HNNC2ydwbtw+a
 +0kdd0mL
 VXNllv9D6dMt/SFU6Jf6IfWs1nQeBQoe+j6VtnYel+0TD3nlfMyYck9OUuWn4nX7Ot78NRSuQBuWdCj970qV1r364Q6hy/yg/y6n65oE+UOAn49UnsR/h+3S8R3zFqlAgFkacBCWqsLPRO8T1E6VlBo38C+DA2q0yBJLfa1j+uZkdYzz13K/p88opG8U9NLJlDpLfU0/JVTCuzu5R2qoZUi3wmK3YvDn+Xzu648LXp9/VlGe5rd0/Im5cxI8OD5+kjeBwg4dras3F6t3QToEzpji3Z8pAkBKFrJ28cDIpAFApGNlGAxXDwGVw6HUuFGc2CkJ7SI05Me7khHSHhyH1HdIDIUNCgrktbOxOF8po4ZkQ2pt0v7lRN3fslHXKljM7k+yC4a6Q0Qs2zLiD+yqGsA4QcPbzFdW62aBp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, freeing of reserved
memory before the memory map is fully initialized in deferred_init_memmap()
would cause access to uninitialized struct pages and may crash when
accessing spurious list pointers, like was recently discovered during
discussion about memory leaks in x86 EFI code [1].

The trace below is from an attempt to call free_reserved_page() before
page_alloc_init_late():

[    0.076840] BUG: unable to handle page fault for address: ffffce1a005a0788
[    0.078226] #PF: supervisor read access in kernel mode
[    0.078226] #PF: error_code(0x0000) - not-present page
[    0.078226] PGD 0 P4D 0
[    0.078226] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[    0.078226] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68-92.123.amzn2023.x86_64 #1
[    0.078226] Hardware name: Amazon EC2 t3a.nano/, BIOS 1.0 10/16/2017
[    0.078226] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
...
[    0.078226]  __free_one_page+0x170/0x520
[    0.078226]  free_pcppages_bulk+0x151/0x1e0
[    0.078226]  free_unref_page_commit+0x263/0x320
[    0.078226]  free_unref_page+0x2c8/0x5b0
[    0.078226]  ? srso_return_thunk+0x5/0x5f
[    0.078226]  free_reserved_page+0x1c/0x30
[    0.078226]  memblock_free_late+0x6c/0xc0

Currently there are not many callers of free_reserved_area() and they all
appear to be at the right timings.

Still, in order to protect against problematic code moves or additions of
new callers add a warning that will inform that reserved pages cannot be
freed until the memory map is fully initialized.

[1] https://lore.kernel.org/all/e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org/

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/internal.h   | 10 ++++++++++
 mm/memblock.c   |  5 +++++
 mm/page_alloc.c | 10 ----------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..f60c1edb2e02 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1233,7 +1233,17 @@ static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
 
+static inline bool deferred_pages_enabled(void)
+{
+	return static_branch_unlikely(&deferred_pages);
+}
+
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
+#else
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 void init_deferred_page(unsigned long pfn, int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index dc8811861c11..ab8f35c3bd41 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -899,6 +899,11 @@ static unsigned long __free_reserved_area(phys_addr_t start, phys_addr_t end,
 {
 	unsigned long pages = 0, pfn;
 
+	if (deferred_pages_enabled()) {
+		WARN(1, "Cannot free reserved memory because of deferred initialization of the memory map");
+		return 0;
+	}
+
 	for_each_valid_pfn(pfn, PFN_UP(start), PFN_DOWN(end)) {
 		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df3d61253001..9ac47bab2ea7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -331,11 +331,6 @@ int page_group_by_mobility_disabled __read_mostly;
  */
 DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
-static inline bool deferred_pages_enabled(void)
-{
-	return static_branch_unlikely(&deferred_pages);
-}
-
 /*
  * deferred_grow_zone() is __init, but it is called from
  * get_page_from_freelist() during early boot until deferred_pages permanently
@@ -348,11 +343,6 @@ _deferred_grow_zone(struct zone *zone, unsigned int order)
 	return deferred_grow_zone(zone, order);
 }
 #else
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-
 static inline bool _deferred_grow_zone(struct zone *zone, unsigned int order)
 {
 	return false;
-- 
2.53.0



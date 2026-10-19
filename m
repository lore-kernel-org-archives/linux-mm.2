Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A4E606A323
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ihmPrN+N
Received: by kanga.kvack.org (Postfix)
	id D6A006B0306; Mon, 19 Oct 2026 13:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5656B0307; Mon, 19 Oct 2026 13:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A696B0308; Mon, 19 Oct 2026 13:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABE06B0306
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2248F16082C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:20 +0000 (UTC)
X-FDA: 85340019240.03.94A19F2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5531180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ihmPrN+N;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429938;
	b=e6S8h/V+UsaXUCXR8PeaekBV6pX/HmOmU/ipe9Y9oCSh2fr2m4Z13CXMpQ2Zd1bMGXnWoD
	Hplg4CkEoz42hsfhiUMc8C57AFbtc86nrj5TC2URlEU2J9f1q/nwyBsTfJ0qP6caRV47VQ
	Ch29ClTIoG1fXUDYE1r0e1Hy6T6L6Uo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ihmPrN+N;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjpbZTGan3B30P6ZyrSjX5pZ5tCnJRUq6rHSDYdsfAw=;
	b=1trD2Snxpc6gWv5oeWTv/9aqC43+mbHV3BBBlPDLwSmhusTye6WT8uKb3Ehu3VyVfeIyWp
	ZoiYJYC09JTCtrpku2gEISDgk+B7pu1GqChlFbJJPVVOwcm3E0EF00gOXreIBd+b4Pu3gL
	AHeMLPxlHjTR2yv5b+SMC4+8FWESaVE=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53634b8328eso17878671cf.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429937; x=1793034737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TjpbZTGan3B30P6ZyrSjX5pZ5tCnJRUq6rHSDYdsfAw=;
        b=ihmPrN+Np/Arb+5lOWx0LUO+ugazkbgrbFTVhvdUz6gkHaXfuOtiJibytzyNXmcVo3
         kI2zC/tvN1chTIJYegDPehCHs+c3B6s0Q3ia389+/mv9A65zbjuh9sDIXM21R4qLyMzR
         IwV8wa085x5N6vG8osrWOpm1i42X+2qHhxe8Fux4OqL87D6U0FBbZfo96d0JL4AMnQTA
         XH0cJJwxRyo9aBjdvuvEJ67DFSJybgJg9jrOLjiG9khKSstgTIrKjD0FXiMDzI2yC846
         M036YZkXcAgkWCnxFfYq7VMDIeXscVvBbkZrS5cN7YZVlPrOeQiGgr+myyzjTG0x5/wr
         p1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429937; x=1793034737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TjpbZTGan3B30P6ZyrSjX5pZ5tCnJRUq6rHSDYdsfAw=;
        b=n2JLZ6GPGRfdqP9Q9xdfnTu+pZM/m2kHMi7H26RUZXu4VqCMWuQVokG/10JPmq9uqu
         ls/CclV/BYEnOqapieV6RSwT+0zo1jRwPKPVZkjmN0ql3KPVqnm8ne5kxhnCh8ouoNIM
         O8ZJMW4cnyjNoFh25UeyClk6wFlAZG/MMdxDT75hT5mp9Wbq4kncRva9QIbsQJxXiAEY
         PoGeTq0cQvz9tg+5eWkJtql4ORFnsCaEkp8P7l+x2/hX3A+dQwDMmn37s2zMrYwcVP+d
         nuG1XKCGQj/cWSpJMLv/1c8DMLOiYejJmVG6ysss9A3784gsuFFkZfaR+dzhoijTODhJ
         Y9zQ==
X-Gm-Message-State: AFq9FYIYifj+3BaCAREXfVNScP+be5KdcYDxhBJOYda0ZAXMs3XEKexx
	LNkUHEcWECtpHn8UXOn76aZqrEgsWWYTBTN/Enekr5Zlo2p3z5mlPnjt+go20HVUpqw=
X-Gm-Gg: AYBFou1uZKi3kwWTaZABRhks5oFAnb+LY1wFXuvbH4noWLBUq75VQdyHMC8c68fr0tA
	oZFg6wa9DUpWajVTqwZMjQ7NWRzNxa+k2zL2OGAbO40lTqWPM/TYLxzimfVKv3SBEDiu2KKlhPQ
	cKrzU6SerRxTrYBJ2Y/kc8HcjEwBmpk5PbxCHZ7fvu2lwKbmdnmBD8fsX+Ri4HA7HOnqN0s7RFq
	pHoIoIIN+DHMhJcOGvoWc0IEAbaV2UtzVkqV4PNIzpMCIVyS2EI6tYUKlN2RI8YlnXlz9Dndz3O
	tmpNviJjOt2B2gJJzveF3SYviuhdW8J2AXg43lQNFF8+hL83T5r73T7l32HTq+EZc91V2I0/iV0
	sIkSI/ZbZcwXp7vPbY4fPvp2gChEW/Pyc7lLy1fLXhWYTUmeKErUVCg6g1+NRwPpIFAu+IX6dz6
	3d5NCFSKq89Nu1sW6i8mujgobX2Jrl7nwVcJvLiKDVvimMnof9K2xLNELHRt09y618bPifzGj+Y
	KOC40Fd0Iz/p05JJvLQla/0z8nBMIxWzalZ2GhHR9GJTVpDWMLMrKBCQ+DT
X-Received: by 2002:a05:622a:514e:b0:530:42d4:4c9a with SMTP id d75a77b69052e-5364605937emr117819301cf.44.1792429936970;
        Mon, 19 Oct 2026 10:12:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:16 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 5/7] selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
Date: Mon, 19 Oct 2026 13:12:04 -0400
Message-ID: <20261019171206.3331374-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5531180005
X-Stat-Signature: ixqs9t3ndtuozmfp8n3moiokrooa3yyt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792429938-256255
X-HE-Meta: U2FsdGVkX1+Qihehl1grrKxxgg7PKHA4uzkFKt5MPeW1WVLApmsb9ncSMgvOwhl8O5im1300tc00HWG4ZzzIgBoyunk+acUyeM/HNWJldtmtsqZkfLPpoaF/9yyLwH0ljobyXhNUmq9d6EQ16OBOBBZem9/MA7a/a2mKkjAsagwkXSdv1HiqQnCir2l36lPMwb9RuwAfSIwUMEz6LCT7qEKbzKVp7YbHTcS2EQscqRU+MP9EofjG3drScIKcD5h+6CfT1RCIEXWn3AoYzPPUSoSAO/tgW/ZdUlYavjlzo6CY6wk0sOav3UdA6eNu21YVKSW/XwgbxSsEv4wgmNIFwsrD+rrYEIhoTqTOWk52seEFcRQsIBYD/vobbCx3guwaB0mQrs2mZG054fbLqpQLZ+/XzDhJdHae6Q6PSRskp+CpDckMCPMVtt3SVk75I1i3N4zxoG2GGH81b4zEdb7SlR0JjsihxMV19Wft9rIyrc0q/WYmqq19NfdMMypIcL2ml60+SBIKGcMG84r1EyJES9dytJm9Pk+NNZu9theh+zNJ+W68iSLCxiWv7s9Ybo2YeY85FS4aTmG31biA+6qstbX1BdH/hBj6yQsYhKyuEmzOSPpVQ5t3ycnGkS/OB41YW6CmOUNRlhvw+wAI9FvJ/wbCYscSLJxjCj2Rq90uRNJavmN1OSMyXHgF+JRrmcZz5PjBVwhGUzstVGypQc9pzi66c2DM4/XRqilD3O0IoFOYdAfFCuNas0qSCsUU4K7GxkGTulxc9xyTaVSLnmGrVjVqD3BmM+OH//NbTSsBRKoM03R2vJtsGN8lK/jXoDpscvroDpyrHGBxFJnsy4/xyrNERMkXpuGBe6hZOt+fwmNP7wEfQJ7IETZyVfy0buGOu7nzxkrN9PqNrpn+rNpc83JyBm7MelQO46YxCuf25VrJwWJsNEV4MpSKsvPRfJde/KaYXLusffIrz9EhARY
 72xEfo2P
 tKBGRVFih8ey9fLR64YDFWFRWlQBOpBMNTCoCg/+zdn9WP3Ezi2+HZIY6+4evJ0uBjsyZdSOLNeqCIWLVqcEX7z7ojGOYapmCfxIK+zaiXJYiCljH+/roF6Rsm08BHwtFJtSFNqIYWjNLf0KB2TChkIa3CkqtozjRyeZyx8dRG/p9RJUpJdZrx7TomB3EZlwQFawVScwTyfMcUftmGPMHs3Sz9EcYZ9LFRdUl2dkuD+9d++ePIorSdczwSBCDL1FlCYBL7/4Dyv6xjWu8jmPHKkGMnOQMj1W3+mQCyoJbaZg7k4aG50hCL9fmRVoJNAqTi7m3ahteFjK/BFTTuI2aPEe2Cnvp7SchsrIsbJD1Y3lBeCSzCGdph5TnRrAbTq3HQPTxic0bEW61zH9aAAMAlTrAJgX/CJBpT629
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that paging out a whole PMD-mapped THP swaps it without corrupting
it, and that pages outside the range stay mapped after paging out a base
page or half of a PMD- or PTE-mapped THP.

Also check that MADV_COLD on half of either THP preserves its contents.

Tests skip when PMD-sized THPs cannot be allocated, and the MADV_PAGEOUT
tests also when MADV_PAGEOUT cannot swap. With /proc/kpageflags the
PTE-mapped cases also confirm that PTE-mapping left the folio large.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
v3: Kept Sarthak's Reviewed-by; the MADV_PAGEOUT tests now skip only if
MADV_PAGEOUT cannot swap, and fail if reclaim then does not happen, as he
suggested for v2 7/8.
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 238 ++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index 7d92f0ecbd27..b5eec490fb68 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -8,6 +8,7 @@
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
+#include <string.h>
 #include <sys/ipc.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
@@ -17,10 +18,15 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 /* Reclaim can fail transiently, so retry for up to a second. */
 #define PAGEOUT_RETRIES 100
 
 static size_t page_size;
+static size_t pmd_size;
 /* Whether MADV_PAGEOUT can swap out anonymous memory, see main(). */
 static bool can_swap;
 
@@ -92,6 +98,111 @@ FIXTURE_TEARDOWN(madv_cold_pageout)
 	close(self->pagemap_fd);
 }
 
+/*
+ * Reserve a PMD-aligned range, so that memory mapped over it with MAP_FIXED
+ * can be backed by PMD-mapped THPs.
+ */
+static char *reserve_aligned(struct __test_metadata *_metadata, size_t size)
+{
+	char *reservation, *aligned;
+
+	reservation = mmap(NULL, size + pmd_size, PROT_NONE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(reservation, MAP_FAILED);
+
+	aligned = (char *)(((uintptr_t)reservation + pmd_size - 1) &
+			   ~(pmd_size - 1));
+	if (aligned != reservation)
+		ASSERT_EQ(munmap(reservation, aligned - reservation), 0);
+	ASSERT_EQ(munmap(aligned + size, reservation + pmd_size - aligned), 0);
+
+	return aligned;
+}
+
+/* Map PMD-aligned anonymous memory filled with 1s. */
+static char *map_aligned_pages(struct __test_metadata *_metadata, size_t size)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  mapping);
+	memset(mapping, 1, size);
+
+	return mapping;
+}
+
+/*
+ * Collapse a PMD-aligned range into PMD-mapped THPs, and confirm the result
+ * with check_huge(). MADV_COLLAPSE may fail transiently with EAGAIN.
+ */
+static bool collapse(char *mapping, size_t size,
+		     bool (*check_huge)(void *, size_t, int, uint64_t))
+{
+	int nr_hpages = size / pmd_size;
+	int retry;
+
+	for (retry = 0; retry < 10; retry++) {
+		if (madvise(mapping, size, MADV_COLLAPSE)) {
+			if (errno != EAGAIN)
+				return false;
+		} else if (check_huge(mapping, size, nr_hpages, pmd_size)) {
+			return true;
+		}
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/* Map a PMD-mapped anonymous THP filled with 1s, or return NULL. */
+static char *map_thp(struct __test_metadata *_metadata)
+{
+	char *mapping;
+
+	if (!pmd_size)
+		return NULL;
+	mapping = map_aligned_pages(_metadata, pmd_size);
+	if (collapse(mapping, pmd_size, check_huge_anon))
+		return mapping;
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	return NULL;
+}
+
+/*
+ * Changing the protection of one page PTE-maps a THP. When /proc/kpageflags
+ * is readable, also check that the folio is still large.
+ */
+static void pte_map_thp(struct __test_metadata *_metadata, char *mapping,
+			int pagemap_fd, int kpageflags_fd)
+{
+	unsigned long pfn;
+	uint64_t flags;
+
+	ASSERT_EQ(mprotect(mapping + page_size, page_size, PROT_READ), 0);
+	ASSERT_EQ(mprotect(mapping + page_size, page_size,
+			   PROT_READ | PROT_WRITE), 0);
+	ASSERT_TRUE(check_huge_anon(mapping, pmd_size, 0, pmd_size));
+	if (kpageflags_fd < 0)
+		return;
+
+	pfn = pagemap_get_pfn(pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, kpageflags_fd, &flags), 0);
+	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
+}
+
+static void assert_filled(struct __test_metadata *_metadata,
+			  const char *mapping, size_t size)
+{
+	size_t offset;
+
+	for (offset = 0; offset < size; offset += page_size) {
+		ASSERT_EQ(mapping[offset], 1)
+			TH_LOG("memory changed at offset %zu", offset);
+	}
+}
+
 /* Page out the range until its first page is swapped, or madvise() fails. */
 static bool pageout_until_swapped(char *mapping, size_t size, int pagemap_fd)
 {
@@ -124,6 +235,11 @@ static bool pageout_until_unmapped(char *mapping, size_t size, int pagemap_fd)
 	return false;
 }
 
+static bool page_is_present(int pagemap_fd, char *addr)
+{
+	return pagemap_get_entry(pagemap_fd, addr) & PM_PRESENT;
+}
+
 /* Create an unlinked, zero-filled temporary file, or return -1. */
 static int create_temp_file(size_t size)
 {
@@ -452,6 +568,127 @@ TEST_F(madv_cold_pageout, pageout_skips_unevictable_page)
 	ASSERT_EQ(shmdt(mapping), 0);
 }
 
+/* MADV_PAGEOUT of a whole THP must swap it without corrupting it. */
+TEST_F(madv_cold_pageout, pageout_swaps_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, pmd_size, self->pagemap_fd));
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT must not reclaim pages outside the advised range. kswapd or
+ * page migration could also unmap them, but neither should happen when the
+ * selftests run by themselves.
+ */
+TEST_F(madv_cold_pageout, pageout_stays_within_range)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	memset(mapping, 1, 3 * page_size);
+	ASSERT_TRUE(pageout_until_swapped(mapping + page_size, page_size,
+					  self->pagemap_fd));
+
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping));
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping + 2 * page_size));
+	assert_filled(_metadata, mapping, 3 * page_size);
+
+	ASSERT_EQ(munmap(mapping, 3 * page_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT of half of a THP must split it, and reclaim only the advised
+ * half. See pageout_stays_within_range about other unmapping.
+ */
+static void pageout_half_thp(struct __test_metadata *_metadata, char *mapping,
+			     int pagemap_fd)
+{
+	size_t offset;
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, pmd_size / 2, pagemap_fd));
+
+	for (offset = pmd_size / 2; offset < pmd_size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(pagemap_fd, mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, pmd_size);
+}
+
+TEST_F(madv_cold_pageout, pageout_stays_within_pmd_mapped_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madv_cold_pageout, pageout_stays_within_pte_mapped_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/* MADV_COLD on part of a THP may split it, but must not change it. */
+TEST_F(madv_cold_pageout, cold_preserves_half_of_pmd_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madv_cold_pageout, cold_preserves_half_of_pte_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
@@ -474,6 +711,7 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 
 	page_size = getpagesize();
+	pmd_size = read_pmd_pagesize();
 	/* The harness forks each test, which inherits this. */
 	pin_to_current_cpu();
 	/* Only root can reserve the page that hugetlb_vma_is_rejected maps. */
-- 
2.56.0



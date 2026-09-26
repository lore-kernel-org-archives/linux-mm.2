Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E31C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A476B0098; Sat, 26 Sep 2026 05:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C906B0099; Sat, 26 Sep 2026 05:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2696B009B; Sat, 26 Sep 2026 05:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4916B0098
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:26:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3EDF16087E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:26:57 +0000 (UTC)
X-FDA: 85255384074.25.841EDF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B03F20002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:26:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ot1JG7uA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eV84FIWl/nzRxlwPhoVqnWJO2Z3uN9aWosu8vZ1OKII=;
	b=lDxwEzYRKfAcqy76Vo/Bilc8ndkCMZpjzjauWg55VZiCVvOSHCfenMaRawRRcMreOFzP6A
	74ZD+4t403SPLVX0b8CJ5VQ4qd2xdm/HBfc3k9t+9AaVg993zeuTJV4/lgURH+f34o7IAY
	7dhYmyzeC/Td0OzRs5b2IqTAJDJwdAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ot1JG7uA;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414816;
	b=7rNkD/WEjSs17Atd+9iLVagQPD1SA/HaWus7GY9CtxvjmSTXboEZb+4aVE8frRldgLhCE1
	ryjS2m3LZGXQGudXa+2kyX7ndewEpNzBXSAd/sB6i1DLAv5zp/AX082FnTeHr1cVMAuOPj
	8204S9NRg3ZmoqnCrUFeA8rE7hcIwAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DA18601E4;
	Sat, 26 Sep 2026 09:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA21F00893;
	Sat, 26 Sep 2026 09:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414815;
	bh=eV84FIWl/nzRxlwPhoVqnWJO2Z3uN9aWosu8vZ1OKII=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ot1JG7uAEJRhW6v2Qwk04AMXnxVxrYCaSmAMfXnv2bKPpKm8Ip2GpOBFlvKsGloxO
	 ND1XdE8rL2JgosT/JamxHnT+bk/YGYjMaW9BnwhqPMinJ0D5hyMjLB3HYjgoTezdd4
	 6DlKAcy16ogcTPjAYFxIJXE3vC4ar5EprlmAqQn2i286DzXlgCIQ+b7wdPcHqZZA3m
	 3BwgD0FdiJLSJzMIHWuRpNyC/hkoFDqMens1SU2HJo+wQ0o0EYnxCbhH+Ci4M9IdUJ
	 m3LWSxCck6QkYxxTVuE6mB3tqB4LX+cFF3tqc+PI8gkxSVsNhDX0HDTe5CDkkqmCpZ
	 fxmEGNwG2Lv0Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 26 Sep 2026 12:26:30 +0300
Subject: [PATCH v2 1/5] hibernation: make swsusp_page helpers static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-hibernation-v2-1-235f69f3ab2a@kernel.org>
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
In-Reply-To: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B03F20002
X-Stat-Signature: z5eihx3uji4khcjear63kchpzp91d6th
X-Rspam-User: 
X-HE-Tag: 1790414816-909345
X-HE-Meta: U2FsdGVkX1/IleiPBsSNWBD5WUWbWE5JfqVrVN12EZC/uwqtdtMkmxlEQkut12bISdHlB8qYymEONJS5AD+EztyXrZt5apn5uMV0maKKDfSNvx8/MD7CQ2m6o0xGUdjIVvC+FMiXWxV+vjhJe+80iSG9yV9MnqqhBOlAWynWst9GOP17OwlfYqXg3fGRDNFj6JV7xVNK/cpM/dE0JxvjrGeSSRfNlds0vJPqbOAX0oIEqG0Ww4gs1RajM96RwjKwDcnMlOfDCKlJLiLLR76ZpaA7Q0jSTZu9BLZo9HxPZDfLZKfn9hIMpaJycYAmhkPHnUcrct/KgQIk1hF9dTaFHxN/JfaUBHqJ9fnUy17h9RtQ7F55zUdlTm91VrmYebzTpNaTbpZIP819Hos0ffzi5m036HItgzv/l1tFiV0C57eGmW8lVIK0CCy2+BUhD7gFIRO8LBQf+udM07PEzJ6hLhAjvumT9gccEHligBAQ333Mx1sVC8264UO9AQX4UJlgbS9SWv7wImlC+6n/pMEHH1XjsBAhCBA5hUZUXU74Eoitd0Psf+2tRYej+YueXhj/V6HhLiNRG/nAxBb2u8wd5Di14ykCur1/StT+6Nz8INx+diq5kVrrrkQSdXDVZWjdfwRpM88v1DtD2IPb1eFxC0Hy1rSJrPCBgtnshyKFH84wL8n+LCyZ1yIfwqwykicNg4eWEKCEMjgdeBVL/6iw1Vy9uyDMef5rcITTKOZbpJV9PyzxkU04hF2w7mloQzY1pVf5/S/eHK0G4/KdfmlwBSxfO1xmx4uhe+e2PRqXrOrXTnOq4VN+Tn+yHjgrfeS/ue9stgLlt/UpjgLgpmo+9rlZXYeWU7d3KQANHdb+PX8pGkA26C9Oy84qRbxYQ26D79B5oTyCXf73aEtECnpoNoSqRgekdySZ0ejnAUXL0uq4GpGQ48MRzkQW7iSojon9bnKIkKxIjjYrQG0x+12
 TG8LJpB7
 T6ElmKaRJWQ7LG8I/M4lmsxYQLGVzLkzcDHN7tUP1dVUhEK6VAmF8naae/Zxpkjs2wUbpPxemoiGg3o6NWshQTG+T96wWoubNjaFBLn7ihDkMGoUwPlbCNgLXjHdP3HHdZ2Rc7Dxe+901aJlEvFQwDDubzXL4WbeZb8B5thHkrcxYQ+kI9Et0CnBW+rPTHtmQVZ0F2iCr26PvhuTjc59efOyQKQvYQIlQxEMwUEp3RysfZbT4TvesJnnt5nYqOBcnVgy5o7+yawb8bi+c/iURjVHezpWf2QCb1xC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 31a1b9d7fe768 ("mm: page_alloc: move mark_free_page() into
snapshot.c") several helpers that set, clear and query free and forbidden
page status are only used inside kernel/power/snapshot.c

Make them static and add necessary forward declarations near the existing
declarations of similar helpers.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/suspend.h |  6 ------
 kernel/power/snapshot.c | 15 +++++++++------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index b02876f1ae38..b3435c5ef63f 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -381,9 +381,6 @@ struct platform_hibernation_ops {
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void register_nosave_region(unsigned long b, unsigned long e);
-extern int swsusp_page_is_forbidden(struct page *);
-extern void swsusp_set_page_free(struct page *);
-extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern asmlinkage int swsusp_arch_suspend(void);
 extern asmlinkage int swsusp_arch_resume(void);
@@ -404,9 +401,6 @@ int arch_hibernation_header_restore(void *addr);
 
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
-static inline void swsusp_set_page_free(struct page *p) {}
-static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d5dba0e50b2e..e732bf6389e4 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -112,9 +112,12 @@ static inline void hibernate_unmap_page(struct page *page)
 	}
 }
 
-static int swsusp_page_is_free(struct page *);
-static void swsusp_set_page_forbidden(struct page *);
-static void swsusp_unset_page_forbidden(struct page *);
+static int swsusp_page_is_free(struct page *page);
+static void swsusp_set_page_free(struct page *page);
+static void swsusp_unset_page_free(struct page *page);
+static int swsusp_page_is_forbidden(struct page *page);
+static void swsusp_set_page_forbidden(struct page *page);
+static void swsusp_unset_page_forbidden(struct page *page);
 
 /*
  * Number of bytes to reserve for memory allocations made by device drivers
@@ -1036,7 +1039,7 @@ static struct memory_bitmap *free_pages_map;
  * corresponding bits in forbidden_pages_map and free_pages_map simultaneously
  */
 
-void swsusp_set_page_free(struct page *page)
+static void swsusp_set_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_set_bit(free_pages_map, page_to_pfn(page));
@@ -1048,7 +1051,7 @@ static int swsusp_page_is_free(struct page *page)
 		memory_bm_test_bit(free_pages_map, page_to_pfn(page)) : 0;
 }
 
-void swsusp_unset_page_free(struct page *page)
+static void swsusp_unset_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_clear_bit(free_pages_map, page_to_pfn(page));
@@ -1060,7 +1063,7 @@ static void swsusp_set_page_forbidden(struct page *page)
 		memory_bm_set_bit(forbidden_pages_map, page_to_pfn(page));
 }
 
-int swsusp_page_is_forbidden(struct page *page)
+static int swsusp_page_is_forbidden(struct page *page)
 {
 	return forbidden_pages_map ?
 		memory_bm_test_bit(forbidden_pages_map, page_to_pfn(page)) : 0;

-- 
2.53.0



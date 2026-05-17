Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13741CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357336B0005; Sun, 17 May 2026 08:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308086B0088; Sun, 17 May 2026 08:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D916B008C; Sun, 17 May 2026 08:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14F976B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:34:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4A80A0528
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:53 +0000 (UTC)
X-FDA: 84776856066.21.591F36E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf01.hostedemail.com (Postfix) with ESMTP id C888040003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0u79BM5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779021292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=STBdzgKjvPOvwUZo4dBwGw6O4WoEeCxQfi7KFeellUE=;
	b=Xk0X4TFhXTaOL4Crih3MK7gu1nJuVoBnY4DIBbMc1G21r0ljAekx9tCKvcCbtzUlYlPq8N
	5LBrZK1CwjRGVMgUFH0y06eLLepXj2KKOVGx4Sm53KbyPI6pEKcwPsu+jxB3Pjiy8xxPix
	yFsnozdq4PTJdjsxcBaQ7eHFyo+MioI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779021292; a=rsa-sha256;
	cv=none;
	b=KgnXB1md8ZjPqcjgoCYCckIvYlMgw3LzSCCA2uaJUuDukhTAlMHCEQ4FefI2k75Q1VdO71
	sFWkWMy3lNkME8Z30BxwQ5ubKR90b5dH3+iP6GyvJH4qDsHOtTpioXkOEtg5ng0FAtm1ga
	N8zct7J+PTOys262TO8QSRBbTvHn5M0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0u79BM5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779021289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=STBdzgKjvPOvwUZo4dBwGw6O4WoEeCxQfi7KFeellUE=;
	b=T0u79BM5I9Gt9t7TqvxKLffnWzUEMms/F/PWT1x7sbrwkhHY+qo4LUD65kjSwhOxB0o4NT
	riHelewZfb4UdSKs72CHbsCj8IxZA//KgKKj4PgIGIBU4CuTZu3II9Otv0vMdKReM35pYg
	mCg25CEgPq3dkR1sKgqaxRIuPKLxJzU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/3] mm: move offset_in_page() to page_helpers.h
Date: Sun, 17 May 2026 14:34:29 +0200
Message-ID: <20260517123428.1181981-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1534; i=thorsten.blum@linux.dev; h=from:subject; bh=MrC+0YWETyNYg6CxOeGPNoPuLtOeYreu8yN0bDb2ezY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcW6849C6U8ub++mfV7aOFvzdIRv0OzGtxXzJT9Yg15 /kZf25f7ChlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJTNzL8N8h6E5glljGhMjS T2IXV+rua7atXW+4TetxydtlXMEL/5gx/C9k8+I/OXPjQ93SHr/fjZxSF3iZbm4JUuapeOenJLy 5kRUA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C888040003
X-Stat-Signature: diepazo6c7ypnqza99jc4jartsno6m1f
X-Rspam-User: 
X-HE-Tag: 1779021291-249996
X-HE-Meta: U2FsdGVkX18fA4HAIRG2xZAZbFzRQQYGKsXv6fMU3g1BuurTKntQiYvaoQ//Iq8zUY5WWfluFg2nEvrAISwkM5iMQLJjU1wBIQst1HuJHwzKqOFUIhcbpUCgWIVuu4QxM/RYM/OBWVjpjqDr+hZs9ge6RnincXmwkZF5Rd/cl+lV8B4K/62OEd3gx10Zfp90IDmlCaF0Lfoz0VXKDRDtwmshvqSELEwmezjomdncoZVkBg74pa39GmULGwx6uEYHRIG0xBHbjKPuNFJGYrUWnxwSwPmG7cA7O/ZlrYd70qA3S/4wSWsRaibOVwe+gXJM2OIgwAH2rJ5luc/czJXfmyN6zPi1tJ9i4ZTzgCXjld4Qxf/9v1uBaznGKAh4WKaVFasGo+RUiLV1zPZ47QTnmXlLACt8VC+LwlyUzImfDIbmycbbIUyoDG7+4f4zeu6VC9TyvNKTuGyGm1xZejrrFZtyBl6UUFdVi6eYJHV6l1/5rG8iFmP0IOwpDbTzTQCOgxcKz9U8x8XQ4OQYLp2aqmMOfSB0dRvfQtv1Ol2yjfhl8eadTlZigCSbQ05BXbWlz3wmxPHEba0TfPGIk8/6tpoaCYra8L4sBSmGd0VwduOi46tKkVm9KCp8RdgiylgJFpYLISUDlRbn87WQvXGgjFMsabjNXBDTOrsWyacF6af6WBpOmY84WeJntHlQzgv79Ao22nvgAID6qgKDwRHHu4iesOvpEZkWVEgP9RI7bLV39FY24NH9CUdmPOK+Oj//Q6A8+k3Lq1U9LuD1hhVY7kpOeTVsyU2yw9opTn2vucPxJvjkYH4ojj/lyJtYMPY9SpxnhUSxFMp43LQrV8XV1vgXu0vfu4TwmpZTvoLOxWJiyrSSp63P5Ce57l0UUV+DhA2XrxjfzNIGGzsNCkAs74NgDIuj650Yqm1PfBwlviniSKrz3whOLaLATBGaySAE3GciFo+E98CPHetogQ2
 CsLk3a0y
 FqyNY57GH2QSqETzxXAKcje87oSo2L0Bgz2Za+1MPC6hkmUbtHf3GgSVKDxOX8XJZw2lGjynpFdfftFnLrMyCUmAslIfbq03ivVNYJnQc0uvRBj9dvv4gTNuyj8GWGQKALlb+f2vWCCH5uf2TjesbIbV70KatrWrHiJuXjbAxEEq9E/CGCg17Eu16cdWorxoaM+XT0mNt0wYI4+tG+Cr/ZjFWwXLZqn9exHbJ4n4MjXS52wk2nKlAHc7EXG3mIAMhS+nmnhDEvY6E96kZ3SLlRcX0Zb5ytuHz4CUODWLbyiihCOWO0XGXus3GqjG+FuCfd8PUWo04qHif7G9Wxn2Nv105oYZjJZnl7WC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move offset_in_page() out of linux/mm.h so users that only need page
offset calculations can include this lightweight header instead of
pulling in all of linux/mm.h.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/linux/mm.h           |  2 +-
 include/linux/page_helpers.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/page_helpers.h

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..bf49e52f749a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -17,6 +17,7 @@
 #include <linux/mm_types.h>
 #include <linux/mmap_lock.h>
 #include <linux/range.h>
+#include <linux/page_helpers.h>
 #include <linux/pfn.h>
 #include <linux/percpu-refcount.h>
 #include <linux/bit_spinlock.h>
@@ -3033,7 +3034,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
  */
 extern void pagefault_out_of_memory(void);
 
-#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
 /*
diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
new file mode 100644
index 000000000000..102a4f3c3868
--- /dev/null
+++ b/include/linux/page_helpers.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_PAGE_HELPERS_H
+#define _LINUX_PAGE_HELPERS_H
+
+#include <asm/page.h>
+
+#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+
+#endif /* _LINUX_PAGE_HELPERS_H */


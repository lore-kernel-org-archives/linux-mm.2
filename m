Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048A2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7816B00F7; Fri, 26 Jun 2026 12:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F1E6B00F8; Fri, 26 Jun 2026 12:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5A66B00F9; Fri, 26 Jun 2026 12:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 914E36B00F7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:27:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F1D3167933
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:27:32 +0000 (UTC)
X-FDA: 84922594344.29.87817F8
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0B9D1C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:27:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dh0UU0ha;
	spf=pass (imf21.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491250;
	b=K9P0JJDzekEFwWgNa0cmCFqDHQ/ajeVEISKetR+TSovfu58Bs4NRtVcJenlzywocVpfDM6
	jht/WHQTbM86mHU5AKfvVlRX6dZRUnX3DVOOVjaIONhXEuUaQYIXFBNU26Sa/fOvd+1dRS
	NdlM4iIeTLucOMZsTErRqkomyMtFRGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HpoSa0kJHGxaMqXrlQmbJAllTdbx9FWh5USHBk9S4yk=;
	b=2oYIS2G6YIRIQpwmN3oM2Od1IG/z4FRnaJZLI77O9Q4pA3e1uqKJ3kEridSaYifBIFErh9
	J9vprdZTItQYCLBw7aL+sq1l5rVj4E/N8T5EINdRNguVg3Jb2r5h8Gou3rToqO5eWtwPY+
	F1AsoOvxIOUf90571dAjbghJWdsH03U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dh0UU0ha;
	spf=pass (imf21.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782491246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HpoSa0kJHGxaMqXrlQmbJAllTdbx9FWh5USHBk9S4yk=;
	b=Dh0UU0hal5UjSh+WqmVdVTLVLJIVjLghW2MnwL9ELm8gBkUC6093mFC0ffwRliYbdEdmX9
	tyo1NNjk4AZ+NtpRhh8KEbbbHtpbbP5A5c9kkUeceOmLy6g27cMJz3XXfSn941kHpTUlEE
	Q/f5eH0Z1xLlr5d0lMZXeeT7cZqEJ5s=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	sj@kernel.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH v2] docs: pagemap: fix flags location, member name and sample code
Date: Sat, 27 Jun 2026 00:27:10 +0800
Message-ID: <20260626162710.25844-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: sraw6p6jhjoi6xztzr1kwyuxxm6ey4fd
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0B9D1C0005
X-HE-Tag: 1782491248-520843
X-HE-Meta: U2FsdGVkX19rWPHMVj8hMLhc7R+YiDEpj1SZRe1Y9SSEjZNDfzQAhotnxW5pzq1PhOcq1vcFEOESbZfF62LUdqZi1K340b6jkAm+5wMHRjiqbQGYkLZtpSA8wAOcBzZ2cH7JO7h0rvoH30FWWA781PVo2apDRoteWY3IFxscfcAUhJg7oeVkzHZaGJW662gv8oniLpFmtTkMQ9JqaPnUE4RvYdrpL9BlsAbtkEjRY7qsmJXc5MEjcGlCOMumQsN+a5nmoTc+GR3ccbLPZrBzln/RAQN2jMJmLRkALi8tQn5QKGJQjGOBmivT4+ZUSX/oe0OTBxcaaXcJGjyXsPObXeagLmTWh4SjoDpOV7UuVs9QKuh9nwJ8HkvyKYRnUSF5jpf2BSHg8nqTMFkZ5Ab2Dzb3qwzv9lz97EpEN10KKxIgnwNF5A+DsLbtNbiZ9N7lSi8DXb+cVXBQWsKtOygfu2rJKfjqiVGN2PtS9s4bptm0fS4Ql615jHB7pdMs+4KFqAvsN0+5aJJO/JpoHVxVmfUV6CyriaUi6qHA0aU+FGRw2mB5dJ+G4gAm3GR2ccC+PMWU6qKL982YNVH9MmaYBTMRjTMSPq5SiysQXkVDm9Ylz78BsPlPnvitikDhJ/gX0Euh94DNE+oCSFCSB5Qx5rQ5YXH452koJnZAEQNUxH6vAh6X7xoyVHAVor2+srWDK91UD4aJS0kWgposOy8oZRYLxG8c+DIc3zZgmceQfruvvDCNnfkTz14vAaOvFGSitdyB7c5uEgnCp+poO2Bqy0CIHBOchilqkz1Jc2ic6b6pT8RcrVIgBF110LC9ub3O/faSFIS/T6flF/2tZ5V1B0qS0Jn0wvSSEfWkdipJPNvFilVinh7V5a9CuGQ2CabAOZTc8ZHLCrADg1gFTRUHbReQ4QOi45BdtzPVQpkr852CjmZkKtYst4/42hGwYGJT+u8//qiYbImwX43311K
 crYqcP9N
 dKDBjkGUEqf537oc/HikO57TAuEfo9ck6OsVpIZuqLRAkbTyPxyljxxpbwpi/ga+lKC4wGJdQOWr2r8/WfFeAb2/SWIea5Z21wAKdD1evTpqx0j6n0448PW4TCvoHXKelcMoWPVRNmcAdLJXumpvBoNwNrNb3P2QHp9lGO9ku9Q+xBP6d87FYUf3IAfV5c/Ltclewz/+ksyq1jq604/a0manZa69dFWrokOT2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userland visible page flags (KPF_*) were initially moved to
include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
stable page flags"), and later moved to
include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
(Scripted) Disintegrate include/linux").  Update the doc to reflect the
current location of these flags.

The member @walk_end of struct pm_scan_arg {} was wrongly written as
"end_walk".

The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
The second one included the wrong category in the required mask -
PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
intention.

Fix them all together.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---

* From v1 [1]:
  - drop PAGE_IS_SWAPPED in .category_mask (David)
  - fix typo in commit message (David)
  - didn't collect SeongJae's R-b (as the content has changed anyway) but
    thank you for that!

[1] https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev

 Documentation/admin-guide/mm/pagemap.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index c57e61b5d8aa..20e3fe76f099 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -67,7 +67,7 @@ number of times a page is mapped.
  * ``/proc/kpageflags``.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from ``fs/proc/page.c``, above kpageflags_read):
+   The flags are (from ``include/uapi/linux/kernel-page-flags.h``):
 
     0. LOCKED
     1. ERROR
@@ -264,7 +264,7 @@ The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
     provided or not.
  3. The range is specified through ``start`` and ``end``.
  4. The walk can abort before visiting the complete range such as the user buffer
-    can get full etc. The walk ending address is specified in``end_walk``.
+    can get full etc. The walk ending address is specified in ``walk_end``.
  5. The output buffer of ``struct page_region`` array and size is specified in
     ``vec`` and ``vec_len``.
  6. The optional maximum requested pages are specified in the ``max_pages``.
@@ -275,7 +275,7 @@ Find pages which have been written and WP them as well::
 
    struct pm_scan_arg arg = {
    .size = sizeof(arg),
-   .flags = PM_SCAN_CHECK_WPASYNC | PM_SCAN_CHECK_WPASYNC,
+   .flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
    ..
    .category_mask = PAGE_IS_WRITTEN,
    .return_mask = PAGE_IS_WRITTEN,
@@ -288,7 +288,7 @@ present or huge::
    .size = sizeof(arg),
    .flags = 0,
    ..
-   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED,
+   .category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE,
    .category_inverted = PAGE_IS_SWAPPED,
    .category_anyof_mask = PAGE_IS_PRESENT | PAGE_IS_HUGE,
    .return_mask = PAGE_IS_WRITTEN | PAGE_IS_SWAPPED |
-- 
2.53.0



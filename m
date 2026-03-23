Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2C3EC01B9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64406B0095; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BB06B0098; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957836B0095; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 847226B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28ABCBCA27
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:17 +0000 (UTC)
X-FDA: 84576905154.10.65E7F68
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id E6C5E2000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=KvJlPcDi;
	spf=pass (imf03.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=972MCStl0Do5pbAEI1ulif24I8j7EecGgHsf7doFi+Q=;
	b=lLp2utRyKrN5D3KbkEpw4DYGsMcevYdGG0ZeF0oxQDK8TbYvAsD1fhzOdYKJxQ++EwggOU
	IpX0sWI7EVIfM+RoNnJNpSz7km983rR4R3hYQmXmfuuwRTRcaISShkriPtXszZh2p28rjA
	T51ROgxhrk1QrEg9rOQoQw26CE6FRLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260555; a=rsa-sha256;
	cv=none;
	b=b4SqrsqDs/ESg/K9YHUjrnPL4afbKgBJXlAJoH8HwxwX5dRKtdO6TXHlTYJEd72aNBkqj2
	qZLwQ3s87nxqREiWEn2ydDPFOqfGax2vsmnJfQqBbk98u7S/6LuLsgWpotEMDo9VrutTAa
	B/UPX3vN4jDVlQZn2tBSlnfmjIg63vg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=KvJlPcDi;
	spf=pass (imf03.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100913euoutp0176eafe22b60ff2ebd0d21774dbf82538~fcJK7zY5T1424914249euoutp01m
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260323100913euoutp0176eafe22b60ff2ebd0d21774dbf82538~fcJK7zY5T1424914249euoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260553;
	bh=972MCStl0Do5pbAEI1ulif24I8j7EecGgHsf7doFi+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvJlPcDiBhJVwKtTD3Qm8FlVlND9yR6iGVq4FvcsX4FAeEEf0tbbgkS9mJ/q3nbel
	 DFd6KXxe8jPfgJ/BGyy8F9IXIIA2xGppJVH50E70+r8KFBJexZSo8YC8Qw3gK6SM2f
	 9jjaW1MhLIRW/27WCcNgb/edxN8O7UfbH9C8vC0s=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260323100911eucas1p173dd26efc96b0907995fda7d551d1db6~fcJI1zBPu2572725727eucas1p1y;
	Mon, 23 Mar 2026 10:09:11 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100910eusmtip2e9e46f4e66801de4b7b4824f5e72b134~fcJITYgu-0975809758eusmtip2n;
	Mon, 23 Mar 2026 10:09:10 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 5/7] of: reserved_mem: rearrange code a bit
Date: Mon, 23 Mar 2026 11:08:59 +0100
Message-Id: <20260323100901.4079171-6-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100911eucas1p173dd26efc96b0907995fda7d551d1db6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100911eucas1p173dd26efc96b0907995fda7d551d1db6
X-EPHeader: CA
X-CMS-RootMailID: 20260323100911eucas1p173dd26efc96b0907995fda7d551d1db6
References: <20260323100901.4079171-1-m.szyprowski@samsung.com>
	<CGME20260323100911eucas1p173dd26efc96b0907995fda7d551d1db6@eucas1p1.samsung.com>
X-Stat-Signature: 19hrypknk5uwwi3oaqcfe9hegn7ha1r3
X-Rspam-User: 
X-Rspamd-Queue-Id: E6C5E2000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1774260554-729533
X-HE-Meta: U2FsdGVkX18B462kPLEmpHwG+NIEtxTBG0qIflGKLl3mEyK81eLf+JSAoN9d+gQNe/oK1loGVJu7GPnWPWd5k1aMm3PikrUhdFkr8bwDHQUtJ9ONUlftFXm1gPbvOnM2T3v3YKn3S2gKbXL+UzfHHFYc8UP2SwtZKC95wcLE0Z8Xpa28Kqr83x9kkVZTrRVJVzpMkhYwu7lf2yBlYx/ycRVXkU91VyuElosXAvqK8sdI3MsX/nZDhoX3N0Bdwpi+7fVzIyoae7ebMvECyinasbb0mvopdCmvn4FaSkfmCThPWORqtJjNcM+2iBgEgfqUdVgv353KnWIBRT/NYh/s9o4qk4zC+bXpo7Y9Zj+J09sUfgw2/AGaDutP/SUTSDeKCnaJvGXPJd88k/AoBJ1J0LFwwWHpasbBY2rIDuDxnzHNbpl+vwqV+EKOnv1j7C8Kr/q6eYR1UeLw4shYH8J29+onqyPYCIOiw0z8JIMNQWaG1r9xXzs1UXzZZGYswZBgKzyvA66xgrpIbDKmxX8HkHy87iASXJPiEVDGsErtR2lYgpGWwJIL09dSpEBEBFxNT1f6cRiYxdsG//8csi4gbIw+cLUQ3uXKPWkzDdec9Q9OmOdlnVfihkhBBRLu2STnLXY4EoTYtEXVFa5uI6Cr9lN81peLoDzYwiGR06K7H0B9Jof1ELDErtcoujzCWNd+Yze6BiiBWGJ54aiEhIVh3HGFSC6jXXbHi5F/b3utMEJVh8ZtmHzMgOZvn9Ag1V1nJ0CcGsLj7EQIgVwqbUBJsHJYsOz2gulvw1Tp0ZT4u0+amQlH2shf8rEv5o0qAyWZccJLdFhX21aXqAn0K4L5dAZ2azkGeWylovA7z+jsl6WNIpXgmPUyRZa03CY8moinOlv0ncTJjF+/jnHcTChplGNklLY6PCvNIaUKPwam0ApQL06dFmlC4x7hvM7N9eO8xQMuU2VSwaNGAYkTwGM
 azmIxfOF
 BU5Ho2Eu2f8iWyHdhKoYgB7tiZ4q4wRhHAjX3BZ6V8/gy2oTcS4y1MOoqqDKXNuZTgx1e3Bt1Q8h5FfVxJNJap//qWZaHzPCAxve5PHrrURSdy99pYKBjf6HUO91YzAra2CPJNg+jqbiky+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move __rmem_check_for_overlap() and __rmem_cmp() functions before
fdt_scan_reserved_mem_reg_nodes() to avoid forward declaration and keep
related code close together.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 99 ++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 61ef148add68..dceaf19f31fb 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -214,7 +214,55 @@ static int __init __reserved_mem_check_root(unsigned long node)
 	return 0;
 }
 
-static void __init __rmem_check_for_overlap(void);
+static int __init __rmem_cmp(const void *a, const void *b)
+{
+	const struct reserved_mem *ra = a, *rb = b;
+
+	if (ra->base < rb->base)
+		return -1;
+
+	if (ra->base > rb->base)
+		return 1;
+
+	/*
+	 * Put the dynamic allocations (address == 0, size == 0) before static
+	 * allocations at address 0x0 so that overlap detection works
+	 * correctly.
+	 */
+	if (ra->size < rb->size)
+		return -1;
+	if (ra->size > rb->size)
+		return 1;
+
+	return 0;
+}
+
+static void __init __rmem_check_for_overlap(void)
+{
+	int i;
+
+	if (reserved_mem_count < 2)
+		return;
+
+	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
+	     __rmem_cmp, NULL);
+	for (i = 0; i < reserved_mem_count - 1; i++) {
+		struct reserved_mem *this, *next;
+
+		this = &reserved_mem[i];
+		next = &reserved_mem[i + 1];
+
+		if (this->base + this->size > next->base) {
+			phys_addr_t this_end, next_end;
+
+			this_end = this->base + this->size;
+			next_end = next->base + next->size;
+			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
+			       this->name, &this->base, &this_end,
+			       next->name, &next->base, &next_end);
+		}
+	}
+}
 
 /**
  * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
@@ -565,55 +613,6 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 	return ret;
 }
 
-static int __init __rmem_cmp(const void *a, const void *b)
-{
-	const struct reserved_mem *ra = a, *rb = b;
-
-	if (ra->base < rb->base)
-		return -1;
-
-	if (ra->base > rb->base)
-		return 1;
-
-	/*
-	 * Put the dynamic allocations (address == 0, size == 0) before static
-	 * allocations at address 0x0 so that overlap detection works
-	 * correctly.
-	 */
-	if (ra->size < rb->size)
-		return -1;
-	if (ra->size > rb->size)
-		return 1;
-
-	return 0;
-}
-
-static void __init __rmem_check_for_overlap(void)
-{
-	int i;
-
-	if (reserved_mem_count < 2)
-		return;
-
-	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
-	     __rmem_cmp, NULL);
-	for (i = 0; i < reserved_mem_count - 1; i++) {
-		struct reserved_mem *this, *next;
-
-		this = &reserved_mem[i];
-		next = &reserved_mem[i + 1];
-
-		if (this->base + this->size > next->base) {
-			phys_addr_t this_end, next_end;
-
-			this_end = this->base + this->size;
-			next_end = next->base + next->size;
-			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
-			       this->name, &this->base, &this_end,
-			       next->name, &next->base, &next_end);
-		}
-	}
-}
 
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
-- 
2.34.1



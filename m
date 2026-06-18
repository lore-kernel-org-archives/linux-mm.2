Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7B9CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 22:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2F36B0088; Thu, 18 Jun 2026 18:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4236B008A; Thu, 18 Jun 2026 18:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694216B008C; Thu, 18 Jun 2026 18:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBC06B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:40:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94C621402C1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:40:35 +0000 (UTC)
X-FDA: 84894504030.05.0CDFBAE
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCF104000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:40:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=WQ6+3nIT;
	spf=pass (imf17.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781822434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ApwCf7gpHgvcRXw+jcerBXpdyD2CtuN4rEen5WYkVwQ=;
	b=BHtvGqoewepEYEhmV28ET/dDjuNo+YQ2GE3MIKj/yNj7eZ87+mn/uGoLpFSezE/EESvEZt
	gOtG169rR8RSMVqQnN8fBpstbEVMVggn2OgsvhqU7Nq8AfnHi6UYrUixTEs/1Vg+zZV0kN
	3xgTrTWeDbifXwvHrCK7PxYLiErdwEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781822434;
	b=Gim+/KH1wWTzHmLK+yawWvrXmLMG+7yJ6K8qaGE0UKF+6Tt+gdZbW0ZfOZsF1HhVcHlRRl
	LPol5BePJh04RXcKjpLmejmXx71fSN9ES1BHASYQkQvJ0IgqY0w7PAM2G68Mw+nWQ7SRuU
	HBmHVGEJo6s+oWJTEphoS0LT90NqVt4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=WQ6+3nIT;
	spf=pass (imf17.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from thinkpad-p16sg1.corp.microsoft.com (unknown [52.148.140.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id B86EE20B7167;
	Thu, 18 Jun 2026 15:40:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B86EE20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781822431;
	bh=ApwCf7gpHgvcRXw+jcerBXpdyD2CtuN4rEen5WYkVwQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WQ6+3nITFaUoApJS2gd3L88W/q4Hs5kTBRI8981tg0QPi2f3sqZqOWcDkV3Jlt8QW
	 edV8ZExu6U4Ji+eDs6froMXJp26di0ia4++icpLJEqGjXeF+JqtbXbbnTnL1CP1/pO
	 S+1KPikxyu8UqUeaKKSj5xsx2izvM51q1zuqNLak=
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: rppt@kernel.org,
	akpm@linux-foundation.org,
	kees@kernel.org,
	tony.luck@intel.com,
	gpiccoli@igalia.com,
	bp@alien8.de,
	rdunlap@infradead.org,
	peterz@infradead.org,
	feng.tang@linux.alibaba.com,
	dapeng1.mi@linux.intel.com,
	elver@google.com,
	enelsonmoore@gmail.com,
	kuba@kernel.org,
	lirongqing@baidu.com,
	ebiggers@kernel.org
Subject: [RFC PATCH] reserve_mem: add support for static memory
Date: Thu, 18 Jun 2026 15:40:18 -0700
Message-ID: <20260618224018.117978-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCF104000F
X-Stat-Signature: i4bqeuit53h9rq1yddb9xxxr443ac1zi
X-HE-Tag: 1781822433-9334
X-HE-Meta: U2FsdGVkX19TdOTNZN+0CWAdS2V4rW96l/801+YY6sm34+mqNOiFZHWa9zhEUntdnk6kzimqYIL8eNPNNT/pql9i4MJ4LHAskjAMTSiOV92MW2p0quSf+pLI0SQaxh6TI7Lj4bCthcvfDE72nvbZ4YiSgee7ApL7tDE6a09Y3XTPMoUgyc8LR201uemkG9Ub1W5zpFAwcLmxLDxQFFOL0tfw5Ny9sBSkIC3w9zklAOLO8erg8xtXELhXfAcRL8d3D++AZktrHMjxg9posi/elp3pkeDjaewxuMps8nR+oHBtGhmx8Rp0aip89APGe8GaB5XwepIbZ/gbV+gjGwJ8iPz/nDgEYgrMolF5ic1FqztH/g9rkh6Dk/RCIM0OA5/7UVBHE8pS3aTeMDAq8xHcml/Cl7nYOds35xKx42tfr/5h8H0UPlwZmdPrNS2k10PYB08sQOdBs5mykAp/5aQ4LUYxSwl4YomcComVtrlFMPePTJd2GNm6E8HGZD/uhTBw/S+oBZLr97cjYPdbpFqXrJeZl15k+FMHe0MdbI5DFNW8am9YNMrszgKKwRR4uH1Qu2IvJVgYG+kZHnlBkYdhXVPa4U7kgGTMSpU4kx0+HdRQ8JIsoeMD8Wz+WTWT/qOP6XMZQMx4zZPg3skcnjTZF0KKYy7zRlCF4/KyZ3pxHQ5rWg3tHGeVtllDQx8hNuWFT8dPDdRYa30/feSBiLSTvlE6AHGEJYK3FSn1BnaxWbjeBv9yT9SF6Mv+Y64kQ5g70GHiguP6Zf8+LaVCML4OcpPh27M3KTH4Hd/Sr6A9X9XRFApBEdVry/Hg9+God0toKM1GAUswKVGn2LY5F+Btv/RXzyAFLSaojKtUaQk/NVXY1r1d6Ub7rQGUlJSJ989C1Y3xtPvsyO7a23XJGjTA25Un4TaK2DFOyNWy8KoJw9Ssskbl2TZohGXet69xPfv0k5/1dvZOLK0sznK73+U
 0FQcCxxT
 wD8f4PkyDywxBSpXQblkHUjdJCMIiAlEYXCiZ1uxkBk6q43H+2HThXXhFvlpIr9Y6epeiYLt/WOID+TValxplDs/RaDS4beB8OTL9FmsT+G1p3eKeoDo4MVCXWDBpOSJJsxmG2vr0jbmzhk+H4GpSg90A+MPPiVf01LuRNP6CjWTChx63JyrmmMtJnoYjFl2lPlap1Z5PRNdl6qnpq59RFs7QDOcQPt1I1UDJ0BAU14NHlAMKvbGCPg3fnJiQuH9stnp0YqmwNU0BWa20IyBKdaIRkp7shC+7mDhk/ob4zWvjoMtKt3BqLInYTOYkHmsyNZj2jsewW/loh5x2gzxyyx4yVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reserve_mem relies on dynamic memory allocation, this limits the
usecase where memory and its address is required to be preserved
across the boots. Eg: ramoops memory reservation on ACPI platforms

So add support to pass a pre-determined static address and reserve
memory at this specified address. This enables use case like ramoops
on ACPI platforms to reliably access ramoops region across the boots.

Also skip parsing of "align" parameter when static address is passed.

Example syntax for static address
 reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops

Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
---
 .../admin-guide/kernel-parameters.txt         | 15 ++++++
 mm/memblock.c                                 | 48 +++++++++++++------
 2 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f228..7e0baca564b97 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6563,6 +6563,21 @@ Kernel parameters
 
 			reserve_mem=12M:4096:oops ramoops.mem_name=oops
 
+	reserve_mem=	[RAM]
+			Format: nn[KMG]:<@offset>:<label>
+			Reserve physical memory at pre-determined location and label it with
+			a name that other subsystems can use to access it. This is typically
+			used for systems that do not wipe the RAM, and this command
+			line will try to reserve the same physical memory on
+			soft reboots. Note, it is guaranteed to be the same
+			location unless some other early allocation for eg: crashkernel=256M
+                        (without static address) is reserved or overlapps this region.
+
+			The format is size:offset:label for example, to request
+			4 megabytes for ramoops at 0x1E0000000:
+
+			reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
+
 	reservetop=	[X86-32,EARLY]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
diff --git a/mm/memblock.c b/mm/memblock.c
index 6349c48154f4b..79f1f806ea364 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2721,6 +2721,7 @@ static int __init reserve_mem(char *p)
 	char *name;
 	char *oldp;
 	int len;
+	bool addr_is_static = false;
 
 	if (!p)
 		goto err_param;
@@ -2739,16 +2740,27 @@ static int __init reserve_mem(char *p)
 	if (*p != ':')
 		goto err_param;
 
-	align = memparse(p+1, &p);
+	/* parse the static memory address */
+	if (*p == '@') {
+		start = memparse(p+1, &p);
+		addr_is_static = true;
+	}
+
 	if (*p != ':')
 		goto err_param;
 
-	/*
-	 * memblock_phys_alloc() doesn't like a zero size align,
-	 * but it is OK for this command to have it.
-	 */
-	if (align < SMP_CACHE_BYTES)
-		align = SMP_CACHE_BYTES;
+	if (!addr_is_static) {
+		align = memparse(p+1, &p);
+		if (*p != ':')
+			goto err_param;
+
+		/*
+		 * memblock_phys_alloc() doesn't like a zero size align,
+		 * but it is OK for this command to have it.
+		 */
+		if (align < SMP_CACHE_BYTES)
+			align = SMP_CACHE_BYTES;
+	}
 
 	name = p + 1;
 	len = strlen(name);
@@ -2772,16 +2784,24 @@ static int __init reserve_mem(char *p)
 	}
 
 	/* Pick previous allocations up from KHO if available */
-	if (reserve_mem_kho_revive(name, size, align))
+	if (!addr_is_static && reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of scratch region */
-	start = memblock_phys_alloc(size, align);
-	if (!start) {
-		pr_err("reserve_mem: memblock allocation failed\n");
-		return -ENOMEM;
-	}
+	if (addr_is_static) {
+		if (memblock_reserve(start, size)) {
+			pr_err("reserve_mem: memblock reservation failed\n");
+			return -ENOMEM;
+		}
+
+	} else {
+		/* TODO: Allocation must be outside of scratch region */
+		start = memblock_phys_alloc(size, align);
+		if (!start) {
+			pr_err("reserve_mem: memblock allocation failed\n");
+			return -ENOMEM;
+		}
 
+	}
 	reserved_mem_add(start, size, name);
 
 	return 1;
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EE7EF8FF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6CC66B008C; Wed,  4 Mar 2026 10:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A636B00A6; Wed,  4 Mar 2026 10:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9437A6B00A7; Wed,  4 Mar 2026 10:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 801346B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:56:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F28628BC66
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:56:48 +0000 (UTC)
X-FDA: 84508833696.30.512F991
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80C5A100010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:56:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpXrKQDJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772639807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2xh3h6rivjh0buAF1oUNqKe0DeOBCMpnppXxVtsRdpw=;
	b=yRGzaLpZfUfhLBZzYiZxCJ4BzyNzJmjHTpTxsuSpcSsDHoMuCkjF3Sb9OV1nCVYSi/A5hz
	DW/kYAfXMZVzsE2fhidWKhOSoeBeUUidnqWfO2gsFx3V1IUKYsyqgvFu+pkmXtSbRV0mer
	BxWbr4rezqXJQIuiyvE+3puVZNg1xz8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772639807; a=rsa-sha256;
	cv=none;
	b=dkoUYlXv4pxMNRTBVjHfsV/OGNcd0G/cn4K1KdOF53i2sDQvEzHxRYeMM1ekSBeVw7OJZb
	PndpWb+r6Sfn3p1P12ZpzPJa/n9HC8Z075sgBPzczTjf3kFNEKiNL4rWRv0NC8n0OE4OWe
	KPydNAees1w0jAFXvfkJ78bQvUjhcmU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JpXrKQDJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC3E860018;
	Wed,  4 Mar 2026 15:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB04FC19423;
	Wed,  4 Mar 2026 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772639806;
	bh=SJm4GuSnbYszVKyxT4amRwFe33V6qzxh/kVyiR1igu4=;
	h=From:To:Cc:Subject:Date:From;
	b=JpXrKQDJgkQZ5nG7H5rajo8ti08hDhRDHS0Tcbebrb7Ko8lnA2n0pO/doWPie//Zs
	 VcywXdRhl7TM3rlw2Uho0gplR/QjKPWxoX3a+HNIUQaF5gy9Np8lKkCIFqoHvyA1Yr
	 4LV6yCaWvW644thqATm0sSN/0t4QIFk1Tqg7OVgTX7/FgvWw4DjnXO+Qf1n1KjpxQw
	 LnQobDBjB9gI2SdhbtLpH4wqu+/plM2RyykoBGYN9yo873BZ2TyQOJUsJwWu1/fxSb
	 FCqZhXnj4y9xe2plxkG9qT2ZmKdgH8ZDAR61yYmTP6CKnLwkP6+lLGfKfin5Zd3c4g
	 sz+yU7Y3T+OPw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v1] docs: filesystems: clarify KernelPageSize vs. MMUPageSize in smaps
Date: Wed,  4 Mar 2026 16:56:36 +0100
Message-ID: <20260304155636.77433-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80C5A100010
X-Stat-Signature: y3zdwcx6me6hjusabmjoguud9jf4w65y
X-Rspam-User: 
X-HE-Tag: 1772639807-916442
X-HE-Meta: U2FsdGVkX1/DdBqM8enwmnnQoJbxLKsdGnfcFb+oTKW0VNmbqdxKM/R47Qjy/TJBm6TXzj/WCHSh27N5nogOooUNMKdlyMFjbEno8h2Q/anjTPg8ilHQPAjEfCJa/pLqartuvuC5TVQo7ySS9OEbbLoKxgzewrLD6T6Wto4V9lVaxaDkbnLWrzVBu4EWjvBzF8+7hZTQjjgoEL9bcrM/FMcA9e1DBYDqc3PvMmyKvhXFdW/SZr6cBHnyPS0kodFGxUoNX3l/xZYbD35QL28dsFb5HtsmD6TF6w2Lncuww/1Yk6Hn66Cljf+HbN8manun7sbf2LkkSu6FEXXmqwHQGvMwFxMfladrsfNjvw8f6YT5GXaPC2r8upRdYWg0xCrNQ3PEJQ5hPWEYztH47Vamf/qR3XOpTWDn5EIYYBbkuFWV+FMaQxYeeE4YDo6YN5+g/3ioUQb8hqtR+4i4QX4pgCQBIV/qRrGOIDZMKZmd4nBgos1Njj2x5doDBtYrjQYNbfGwkegLezUAMhJMH6Xk5snjQecfPGjAquwqJBBoAWGP4t+1VP4EakBe6+4DkAQhS2uFDXYMh3b4S5tz3PPZxS+hoIoaJO8rqcDeKFsFq3ju7eovRACgLMfuXgr3zqK6lMgRqriT07m90MB57ufyZnf+32o2/yB+H1dxAU+c8I23cRSz7qZYdhjCsSc/qN5J0szX+fFUtBTxrpPF/8ED2XkXd4AsaMd0lNa0xnXvgmVMhOleTAjxhuBEWqj100Qus6BS866NhQ4WPapr6LAXX04kjzWc8oR/rgY4C0hI7v1rWEiYoQnnk2ElyAdMxtfDU9/hS6H8tWQYUv1CQr3CvErDZ2VX0rstr/lHeLz6GhvTqrdYilQhef7ooounDFwmSspeOP4qgJzreP2UF/ikfZepCsHlSmkkYh+g6nlBzuSZlrj5/LBXTt4uHEeMrZ+IMjOwenu8SP740F+FTEb
 KJXgRNdy
 8ucmIE7Hy6esVVA7jSv5zQvnE7ELbdBdMCR+2+ciFVlyD9ZInUroo8DioJHntq1E+hPjBRDn9bdYe6ztek+iZzw/Akj4NCnx0owP8TgT4JFA07XIq2kmM0Aw7CwZC+R8Ps9RZu3oMmoyjc1WRMf9KGIvbxpcUe2OxmzUqD9OfbS5P5/8S5DtZXCQahUi9NUFXaR6av8NcKXozuUa8JOYLj4s9Rp5f+vjNz6+wuXNaAYEj69Hb/0gVvbpqecEugGcCIrZCI22DWSi/0BdFywoov1uHm4gI5zfT5+hGucgxpWwJhlMgRNoc+Sfc8fvitEni2idd/OF2aoSy3aHzqGRpxr5+diTK1gOUDYxaLQj9y2b9KG6wZV72NvS5CDVrEBgxJGPeSUo8KEiA4QbLOMgdpnyz1SW+TSb/MeOATU3sCIx6dujoMmAPC/UoCv4+MxtfrZPQlA1sN8y5yxQukDGOIr5XPuaky/PY9qcu3QcFNvTt4Jf7JUuTjGAfQTOs0D5t7pem/rGNxTrer/QUxGG85cIsk0Jc5uYjBp9mUolXOfa0FwZuVnggZ/xUau5TfzHWWRlr5hO57NU6U8IJt1Vsq4UrBVpiqAHpf5DKpFabmFNEaaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was recently some confusion around THPs and the interaction with
KernelPageSize / MMUPageSize. Historically, these entries always
correspond to the smallest size we could encounter, not any current
usage of transparent huge pages or larger sizes used by the MMU.

Ever since we added THP support many, many years ago, these entries
would keep reporting the smallest (fallback) granularity in a VMA.

For this reason, they default to PAGE_SIZE for all VMAs except for
VMAs where we have the guarantee that the system and the MMU will
always use larger page sizes. hugetlb, for example, exposes a custom
vm_ops->pagesize callback to handle that. Similarly, dax/device
exposes a custom vm_ops->pagesize callback and provides similar
guarantees.

Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
regarding PMD entries.

While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
and "ShmemPmdMapped" entries really mean, and make it clear that there
are no other entries for other THP/folio sizes or mappings.

Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst | 37 ++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..0f67e47528fc 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -464,6 +464,7 @@ Memory Area, or VMA) there is a series of lines such as the following::
     KSM:                   0 kB
     LazyFree:              0 kB
     AnonHugePages:         0 kB
+    FilePmdMapped:         0 kB
     ShmemPmdMapped:        0 kB
     Shared_Hugetlb:        0 kB
     Private_Hugetlb:       0 kB
@@ -477,13 +478,25 @@ Memory Area, or VMA) there is a series of lines such as the following::
 
 The first of these lines shows the same information as is displayed for
 the mapping in /proc/PID/maps.  Following lines show the size of the
-mapping (size); the size of each page allocated when backing a VMA
-(KernelPageSize), which is usually the same as the size in the page table
-entries; the page size used by the MMU when backing a VMA (in most cases,
-the same as KernelPageSize); the amount of the mapping that is currently
-resident in RAM (RSS); the process's proportional share of this mapping
-(PSS); and the number of clean and dirty shared and private pages in the
-mapping.
+mapping (size); the smallest possible page size allocated when
+backing a VMA (KernelPageSize), which is the granularity in which VMA
+modifications can be performed; the smallest possible page size that could
+be used by the MMU (MMUPageSize) when backing a VMA; the amount of the
+mapping that is currently resident in RAM (RSS); the process's proportional
+share of this mapping (PSS); and the number of clean and dirty shared and
+private pages in the mapping.
+
+Historically, the "KernelPageSize" always corresponds to the "MMUPageSize",
+except when a larger kernel page size is emulated on a system with a smaller
+page size used by the MMU, which was the case for PPC64 in the past.
+Further, "KernelPageSize" and "MMUPageSize" always correspond to the
+smallest possible granularity (fallback) that could be encountered in a
+VMA throughout its lifetime.  These values are not affected by any current
+transparent grouping of pages by Linux (Transparent Huge Pages) or any
+current usage of larger MMU page sizes (either through architectural
+huge-page mappings or other transparent groupings done by the MMU).
+"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" provide insight into
+the usage of some architectural huge-page mappings.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
@@ -528,10 +541,14 @@ pressure if the memory is clean. Please note that the printed value might
 be lower than the real value due to optimizations used in the current
 implementation. If this is not desirable please file a bug report.
 
-"AnonHugePages" shows the amount of memory backed by transparent hugepage.
+"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
+memory backed by transparent hugepages that are currently mapped through
+architectural huge-page mappings (PMD). "AnonHugePages" corresponds to memory
+that does not belong to a file, "ShmemPmdMapped" to shared memory (shmem/tmpfs)
+and "FilePmdMapped" to file-backed memory (excluding shmem/tmpfs).
 
-"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
-huge pages.
+There are no dedicated entries for transparent huge pages (or similar concepts)
+that are not mapped through architectural huge-page mappings (PMD).
 
 "Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
-- 
2.43.0



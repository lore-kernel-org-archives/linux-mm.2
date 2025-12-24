Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70185E776F0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CC56B008A; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7D86B0095; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F41B6B008A; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44AFC6B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE9DF8B498
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:07 +0000 (UTC)
X-FDA: 84255062934.05.9DD0896
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AE3F4000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=azpTgwXx;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597646; a=rsa-sha256;
	cv=none;
	b=O8hLjJgB48X0J+WUmOwgc+3DvOhgveIaiChONMDqjUC5cwFQv93wZuoq4sj6hyrCaPdiYf
	Ijmg61Jl23sfkTji8Zgqpw8sFmAk7VQrGN5lH8jC2GpEvj8pzJy1agwP94yyCQYOKXImDI
	A8By/3RNj/LE9SZEbeEhYuuzaXJgnqs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=azpTgwXx;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIh1XzVs83L7IUYypMXcMemNQQ0OLf+PJujjXTHlUNM=;
	b=oTn6Ak+HRZIMXuVNlr74gGikrjOOft5ucRaPCXsJMsCO88OAoz9jgSlCEyT4ekGdkFaZRr
	VKI0+LnhDxzIUhBF2VAm/AQD6W39CkO1q1NqvHa4qn/rtxHqpsUmsGPzpcOZzjDbsOKt+v
	v6pb3SJzpipek+fCRs8W74KptvKk178=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597645;
	bh=WIh1XzVs83L7IUYypMXcMemNQQ0OLf+PJujjXTHlUNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azpTgwXxj0eWzpifwpvE/easXXJA1SasvPI3MXVrTCE0gfqrkvb3denE9UoKHQKr4
	 WJU2h/pONKmiU8CDPPYQYKm6TwgFUAM1FiF5sKOsjaG3tFfXEoU5DbmfvP1dJL6TF3
	 Jwd+PyGrO2g2bLMnk1LuLnzXMFhGU/nYtLisiWHv8xuoSFDJQp7LM+Rh+KioSrvOmp
	 W6XlG6TfMMe7eu6lL6ierMwvJ3wFhbWO9buO3LM1I62Oiei0+ytfkbuSgAhjweTUT3
	 BKdUdEgJ2lpleMXSeGKDxJQ+iplAWpL8ca5z87F12ZkpHcxsexTgQc7GMKloh484lM
	 FcGFA3UfPh/uA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzWd5XcRzfHr;
	Wed, 24 Dec 2025 12:34:05 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 3/3] mm: Take into account mm_cid size for mm_struct static definitions
Date: Wed, 24 Dec 2025 12:33:58 -0500
Message-Id: <20251224173358.647691-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
References: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6AE3F4000B
X-Stat-Signature: aj9ntjtkb1oewatzwctb4ddk4t9woidr
X-HE-Tag: 1766597646-623865
X-HE-Meta: U2FsdGVkX1/EzQzIYuhJ/UoN4uUyosMXs1S94NGyL/ubdUArdbyuCCy4bVDV4PI4+ePZglCDitjzEsJ3FBiSGLyLSF0qcVkr+93uM7+UDl+Ga5wliHSVLCobhIdE7XxekiQIC+LjLyMYG40upHDQno3/Gjd3SMkJjK6+KuiifJZ1ONzxoXzzvk0zdqc2P8x2sNcAhqjPgdQDSiji1Ftzqqtb0kPCrOCqmTc1/YOo0A5FLWCp4XgfPMPz0e8+XJE4tBOu7IeoDfjgsD7OoDFsNreoZsfJaqJVuRIcZB9tVCx3hFhuHAq1s+ngwCW8zHjMQRcZWuFC19c+9DTwRnM718MK6TztcFSj1n25rXbOj7JNVWDJTTsCK079e9HBvQsJOTEhYUPGovCsu3AAD0+O212KR4Epjue95AVKyfpkGZbp0xjFplRY0NqtOeKvMmsGM7PjnhEXUUGtkv1QqG25T4Sj+rPGi1Oj8ge8UpIJbxr4ulvuDSfKUBFRm9uSND4YpnkyIxNqX2ebL3rLNeegW2hROppcNqllOpTsNVAnEtHKki3VDZEKGHErQcsUFPhI3r7NCBDdEQyo1r0TJwOWFZ1Lb4lU0+1RW6UxmemRMNXRavriJ8YFPhYyQ/PHP7LiMvmx0/VfeyqBmf5h3gaYExrV1YCaYbTOhruzvq1a5tkIa3/gNrktyZOFiFjXHPxAXegDY01QF3F3K2UMmKzhILXwF7eeuSdcbpPFhGyWgj+uREvjl6sENbX94hNpP8GVkQCqUG1p1DpjoSeYZzMO+9t3J1X+XN72m6qwykks0zuwsSt6ogCudXlAHiHFLQlV6j2gtfPFVlj0wZNNK+rmaWNIz8Z5XQe+ynKS1bje81kX9dPptnMRub9RfBvp9XApIjmV0ZtYdUQyicIViPciUhA8wx5jjnGwDxOokqF3TvE/mE1/Eh3fhLh8wROha+uXgJnbmH/2qOYPH1+lES5
 hLnLg9Pg
 BHq+9W5AukjunpnFL4VcSOevfkw9r+ZYLI3GrhVGWUHY3/yJZyrPJXRgBPs1BxFMaBLNGKh3V+wVEO22tTeUpVcW8SheaoEi37tLMzP2ZXzeH/4o4lSuJ/k2NPoFQIlCagbLBY3q34r2QQhwMDlzHl3MliNKdbsRsydARDGVqxD3z/YGmDz3xnaZHxomEFoxnWpB5cuWqDkzCOiALC9FlYjk1nBUc1mk0YowTZtIO/4zm/Yz2LxE8KZpObl79l8gpE6/dxpkdkC5QKRpqoo7abPjyeUSunudWHton1tU5AXJeO0bVMsb1duolwWryiQdDZFAMfhOX/q57xvQ/dQiG5IoAjrEyM8yJNbPs7u8gnIGEKAie1p4tuF7wlZjR9Iy13fnsszz2cCBpqa7YoPxcDBnmtlwrOmnuX5p3isnaP0Nw+x/y7K+ZFrxlkkG2vPRFT5onlKs2JqWZ1TUfXb9Qs1u+Lhc5uFcuZhu2xATUJixDdHMGuheJoCz1bGITLulrdBlhNHJTAvwH7Ya1uJuhaC4ehA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both init_mm and efi_mm static definitions need to make room for the
2 mm_cid cpumasks.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Add a space between # and define for the mm_alloc_cid() definition to
make it consistent with the coding style used in the rest of this header
file.

Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/mm_types.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 110b319a2ffb..aa4639888f89 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1368,7 +1368,7 @@ extern struct mm_struct init_mm;
 
 #define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
 {								\
-	[0 ... sizeof(cpumask_t)-1] = 0				\
+	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
 }
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
@@ -1500,7 +1500,7 @@ static inline int mm_alloc_cid_noprof(struct mm_struct *mm, struct task_struct *
 	mm_init_cid(mm, p);
 	return 0;
 }
-#define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
+# define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
 
 static inline void mm_destroy_cid(struct mm_struct *mm)
 {
@@ -1514,6 +1514,8 @@ static inline unsigned int mm_cid_size(void)
 	return cpumask_size() + bitmap_size(num_possible_cpus());
 }
 
+/* Use 2 * NR_CPUS as worse case for static allocation. */
+# define MM_CID_STATIC_SIZE	(2 * sizeof(cpumask_t))
 #else /* CONFIG_SCHED_MM_CID */
 static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p) { }
 static inline int mm_alloc_cid(struct mm_struct *mm, struct task_struct *p) { return 0; }
@@ -1522,6 +1524,7 @@ static inline unsigned int mm_cid_size(void)
 {
 	return 0;
 }
+# define MM_CID_STATIC_SIZE	0
 #endif /* CONFIG_SCHED_MM_CID */
 
 struct mmu_gather;
-- 
2.39.5



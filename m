Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1A5C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF716B017C; Wed, 29 Jul 2026 10:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6EF6B017E; Wed, 29 Jul 2026 10:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A61D6B017F; Wed, 29 Jul 2026 10:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF756B017C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03A3C1A06BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:18 +0000 (UTC)
X-FDA: 85042117398.05.891A3CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63BD04000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIlg5X7D;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lzc973wrpBvl2rlA3xdelaF9rXhGdCJv6jnQryQfQag=;
	b=Tw4k2ZmuGAPrKZiUA1ahCZEoHjk1SVHplKOKbaW8co0Y/9KthqU0yFKN7wzDlnFXFfP8Xb
	0BeZOefTJ4syyFzYXgNx6dv+RiZH8IDtOjn6oEG23EAGhgvQPSME4lKvdb5htIgbpGVDW9
	+ICCrtenykqLOoIMfkTPJySmZmKpn4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337037;
	b=cbr2s3BkgsYG5Cj86d7514OtA6Jqq8zStplq6T2pat1yUUj0YYe2Nb/+WLRpag2stI5a7/
	JkeCVGMM5ZUtsLUaFC6DcqZgBP8SJ/Up3beGnxdQC2uodgxU7ahAcRegpY9svKNF/FAwRM
	RqKWYCiZyXfwv2A6mtxOdHjBUdfkmwQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIlg5X7D;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04851600BC;
	Wed, 29 Jul 2026 14:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861861F00A3A;
	Wed, 29 Jul 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337036;
	bh=Lzc973wrpBvl2rlA3xdelaF9rXhGdCJv6jnQryQfQag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIlg5X7DHxSwfw45OQMrO1e+tdKJl3H5HoRQn7bw1lvRhCT/1qTvoruee3GbsKFaZ
	 Dx4FKZJoNEifrcSBreQ7rWPhXIu2KBIOnUV8alkolgAkvh2tkjkAEDDLTAMeZgnmT/
	 zEdtk3uEyZaptDOZtHpYw/2Y9Zt23OKLRso60zx3Ph5PXXjUAG2ZYfTTtBvJjbAsAD
	 rBNT2dkLTAhh0hNa9Goqw2acttyw/0YzyLZ5PKZcp+5W7Ng2PHGiIxDJ/9el0hnBC/
	 AJblsf0WWsO4h0vNlU0KRdjI5gaFWMg9xm7JUj7+Fao6Nitnoju2BtH01qvXP0oQ0u
	 vuDP+8MOxQIaQ==
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
Subject: [PATCH v5 21/22] memblock: add memblock_reserved_hugetlb_size()
Date: Wed, 29 Jul 2026 16:56:06 +0200
Message-ID: <20260729145610.2827231-22-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pgubxr4caaiuntcab3rerwdh3d68kiop
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63BD04000C
X-HE-Tag: 1785337037-265840
X-HE-Meta: U2FsdGVkX19QXeieFXec4nAex+Ki5ZIKevvSc3uzjRY3LEWukFWDH8JcqIlP0/iHctcetaCan7XQsNdFB4N1r/hQb8yv2zfZBI7yw6E/AiPDVeyzAyDTZQx6YU91hxP9vWuZ+lm5NJxqvQsKEOB26BrOGa6s5LwmHPdxs6m1+qkxFbsyUrKbd0mcveuxPFM2zekhjS7OyIr7H/KQc4gT8xMoE5Wtv+mlW43TQCD8ZWSnSSCy+da27NF0Q1IpI+LjqKK/5jqKGkljmnEZSTkDxYPR/5ymCMmGB8bJYddEWNtxgJWj5d78bT9amZKuiZzuoK2Ip0cnVNh4gAv7oLv64y/ty87/9SpQ2GR0Llww1+noiWk4c4rGvULc1M8wRiynfxUOoGVwrxuz7Wg7Ufr+W22BTCvnj7kaLVDdrxnkjPEC1GL6haLsM17Uf6UPLMVVr2zVuBGb+MiL/APw6hD24E2LwR52BnAHdalSlUK+vS/SDVazrhmvniPqjk/lBYRA9sEzMN2cYmJIRBEZHjnuTlOo0cQF/bbFiI/oOWZEVDgFVvHW1VB1C4u7K+f3a51KDzPGYo+HdolNh0dl0gHYgOoHWNcg+TV0Fzmar1dBuzAWqdBETE8mXKa5b8E9uQoOonxA8wBM9F6OayYOoiFQsbOkU881i7GRZcOFP7Pf7u3ixSbqbNJEJ8FhCMBlnkKOV0le2ai8mwPsq4udBbs8R7mZttXw+azsqGxls5hvdDIWKZY3dGGlmrA3GkSdCChhhMToJGMhaBdEV9IClI8fFKvX67ls7VzNb2R/vZte4MT3TbKUDBy/DhKDBjwu73XP/aib1CL/7l9cbkvHpcRsWBMkvGSoHn+m0CJFGxwPU8ebtxWSQ5z0HZ03yMomxoVOa+VSORRuRHujmD41yqT3Q2EBaadu6uCAy++s5q0oAAzyjve5tuGp7iMBpMEMdtZ4AVlxxUzVoIdAcY2rQ8p
 QLlrlzFw
 S797C4/O96D/aZl7NhPL7Mf4OBFkgYSJ7lOe9K8HMg2OdYwiDA38WpyJPi5zvaGaojtpLTcI2ns8zPHfT083wChqbSZLAcRmzNMub8I8ZmyulO56FS+2Yf4e5YsFL4zVhB8xrLhkdTGjFAJTg44+UEt93+Sd4bOrBC+SC8cep8LaDiwsptpYDtFSeLlxQcNWPIMlRf7FNZKagk10CgH24A38DqWoedwT3nPhSGR4/XOvqgR8uIvX7SaGpydyj3WACv7RHZ5zmfH8elJ3K9cKK/bDv9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Similar to memblock_reserved_kern_size(), but calculates only the memory
reserved for hugetlb pages. This is needed in an upcoming commit that
subtracts hugetlb reservation size when computing the size of KHO
scratch areas.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 678fe466529a..d62db9e776cf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -487,6 +487,7 @@ static inline __init_memblock bool memblock_bottom_up(void)
 phys_addr_t memblock_phys_mem_size(void);
 phys_addr_t memblock_reserved_size(void);
 phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
+phys_addr_t memblock_reserved_hugetlb_size(phys_addr_t limit, int nid);
 unsigned long memblock_estimated_nr_free_pages(void);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index 77c6540e7528..37e06e70c1d0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1899,6 +1899,28 @@ phys_addr_t __init_memblock memblock_reserved_size(void)
 	return memblock.reserved.total_size;
 }
 
+phys_addr_t __init_memblock memblock_reserved_hugetlb_size(phys_addr_t limit, int nid)
+{
+	struct memblock_region *r;
+	phys_addr_t total = 0;
+
+	for_each_reserved_mem_region(r) {
+		phys_addr_t size = r->size;
+
+		if (r->base > limit)
+			break;
+
+		if (r->base + r->size > limit)
+			size = limit - r->base;
+
+		if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
+			if (r->flags & MEMBLOCK_RSRV_HUGETLB)
+				total += size;
+	}
+
+	return total;
+}
+
 phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int nid)
 {
 	struct memblock_region *r;
-- 
2.55.0.508.g3f0d502094-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CCACCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729E28E00D1; Mon,  3 Nov 2025 19:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB788E0058; Mon,  3 Nov 2025 19:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F02C8E00D1; Mon,  3 Nov 2025 19:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB828E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:39:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEFE5C032A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:39:56 +0000 (UTC)
X-FDA: 84071067192.17.256A00A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 345E9A0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:39:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lkWRoWfQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762216795; a=rsa-sha256;
	cv=none;
	b=DyUc0SOeuBtg1hUL94FOfWcGwuH0Tx3NWxt71aF3RHnfsNb5v4nmJVDvss3xvAHjjIOWcg
	4gRsHaDcxvtVn5OPIinJ9IdxBeDMdHD3VWQ9lZEtslBH0C/orjtWvgHp1gUJ8zZia3ccvu
	6HVavcMCGNmhxewZBJefpAEBdIfZwn8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lkWRoWfQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762216795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iam28yxbxtTcQIZpnqIWn4zgf5SETAhbeipE7iPuLHg=;
	b=WqihtfM6OpZ3ikER/hDlg15gK2W/TgZIvnUlpfYGX72jWXoyvXKk946ha3z3+x5yknb5CU
	z238iUzpg2X+zz/T5Xxh1GqRcmqFhoW3rv5HpUdBPztDbZYXjNogK5yKI+pIxNz9L0rQ89
	YTdeF+pLIm4rahtz9fuilcbD+j7pBhw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-794e300e20dso4797943b3a.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 16:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762216794; x=1762821594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iam28yxbxtTcQIZpnqIWn4zgf5SETAhbeipE7iPuLHg=;
        b=lkWRoWfQ0yxfyd6PwpcIU7n9sZpVK4pLOQnY60fJ/yT0NV1r9pTlbmcuNdFg7lMeCu
         8vyfgU0+Yw953t2wpI7XO3QdZyeo2r8RFI/jmRaw8gH7Zy+wYi32hud5j6hFSYiEWkQ4
         I7JdobXur09O5c2PaXtLIs4XPajcb8gXm4xDFc1XMuBvI/v7ZKppwxEibKa2v4+CjrTZ
         8Sf4HBXsnmY6scMmU3Wg/edq/2GtBbbYfzB+ER3kpgdPCDLKXZk3odW+207h75avB5BZ
         xoYevWyGmm89WDsU0V9d3fO+vuF4Tokwfo+F2J5HvsVPcrPplLPQEz0LYmItYznIMArj
         BfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762216794; x=1762821594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iam28yxbxtTcQIZpnqIWn4zgf5SETAhbeipE7iPuLHg=;
        b=EzfsinciceWe7ezHu5cF+aBPonWqox8ECfoOk6LaZcqCPzIyY9B3DmB1qqpE8j30in
         GWe+fVulXlIk9LEYnFNoHksNF/CgePR0esFfx5qDKPdVXdRGNYm8zdwF8YrgUI2ksQQ7
         S8MnC/hR2VK7HDZezvJfgcc06Ar61wgsw+TLF2smbbKoSf0LorgVKJ/nA075d70uzSge
         oSKSG7gfMDrOFwa7l43DNq4ZTXKYlF19A17GcD6y1NgmROS/YsFvyL/+c79mnHPtrymN
         HFODUnS7nlULr8sSpN0IU1o7g0pScEny/j10L8cOH0Ci1RJ13ZX7vYzGhHSg6oWaOJmg
         RX7g==
X-Forwarded-Encrypted: i=1; AJvYcCX4v7B3kn9KuIlbBJM+QhzqecfqjKyes7eGJCV7SQWAxdM5CdPaknqp4tlTWUCTjo6525ZZUVCyog==@kvack.org
X-Gm-Message-State: AOJu0Yxhr8T8pdO2LI2r6jNCzgOVhm82+SM7LdBo4X2exTgGX6gHFHE3
	VR2nKWO10MFXX72oDwlGGjLYWpls4sA0YVit94EvYrgQhY3ogLQrmgx7
X-Gm-Gg: ASbGncvwWA69LoOp8V5hZHWm/y8Qb4AufW83v6tBHJxSH1NAwlu9JBQaMRb8knGP9d2
	NrFBbeqH9/pe47bS3KpN80HmogFo1w4ayRSoSmSirTKo897zCzAXQtKLLe+i3tYCJ3I/h+GJB4F
	xyiEMynhwhknhz8BtQhUo92ge+dpVHAE0sglmmT4GnultfzzlgkbZAZ/xKpzL9MAU8KYNGRmHy8
	WEiplwSKKY5KbthhhtmAVytJk58U1SwQLd34RTG4yzmQdiuZuar7MZ7iBOQ8dyLvwFY/mgCZuPO
	eX5Yc0zSkKxKNCTfmhh6JuGMV8AVbzmb7VIHyV/IXGp4QXo9uBDIOjXYWlfyxQ8Upl1q30hKVKa
	55LWFEYCdGGHAjZMQUhk1lpO5pkOH53H8txn7n3OOl8hP7BgZiVTkj+oqrBo9v54fD2goau81UU
	VrCM4HOwex0pxgsU9Gm2gMVNbhXw==
X-Google-Smtp-Source: AGHT+IFJbftbMdXgKxfl5nxnplvx3Z6+G0scrRMZ2oVSB3QoWsoHMMWseKqIUdRWNIb6rfsyQvsVRA==
X-Received: by 2002:a05:6a21:6d8d:b0:2cb:519b:33fe with SMTP id adf61e73a8af0-34e2a1a60bemr1475870637.21.1762216793733;
        Mon, 03 Nov 2025 16:39:53 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:30f4:78b7:7acf:47d9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd634081dsm666661b3a.58.2025.11.03.16.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 16:39:52 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org
Subject: [PATCH] memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory
Date: Tue,  4 Nov 2025 09:39:21 +0900
Message-ID: <20251104003921.9707-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 345E9A0002
X-Stat-Signature: uhmm69bzat8ehn7oauteuncp5pk4fcuc
X-Rspam-User: 
X-HE-Tag: 1762216795-455073
X-HE-Meta: U2FsdGVkX193ORKqseFqQAb9eybDE3LEIxbc+PosO3B0e7Ex2G/jljGp/3WzoUE0Mc/6yycNAOTFHqakhKrnREBY8S75MIGVUM0+eQsPJy3LyMEr5W8y9mS91xXq3RW35hZCYpB8gv1yBDV1fAYxgZlK2m6iVkJZQgNn88NtBlqELPTfJew2vcIJ7Vkm6geOZygXUtbPT2z5pk2Z/scofGCSBeLXG/pUCzTSl7CXoZ+mCFnQjRvuoHHeqOLlU96brWRrbTteSOy666OBAo0XuF13ZSW5BqoxdcZAY1EmpURNJSeDEzveP4cVT7AN33NBRGDj5PEGhnx2hQrcgXt+gLNaCB8vDbg3D2wfPDhSY9zfcyn6DxNLNQOvKOZi+GtZoF2oilCtjDpbxVqNFRXBiFPUs2DXbu1Svt3pZjaTFUv557DyEZJ+alca/JUUMd8rjy4ZAWzSCofrN/I82rBQNoHXSxy2+o6LeA+I+qe2txLO4QWWZJNqOwg4Q6opniem0FIx7ULwlldszgLOx8A1mi1xOYomgtuDDQYw6GWUF9edWXDeEK1Sd3PdBmvnTH35iJsdxj/NllfWVEAzNKPj2NzDhI8BFaVR7rdYMJWQCh27cKABInrLKHH+D3yE5PrNtov/wEtZjXARP8namcAgQd4C7Vkblo1RUQ0qbFPNLyRyZugapGiacaqe0zWb9eLLcVm5oDLqbgKOw5tMu+wJFqR3HIABNDhBLcrx6lNo8K1gNCLpe5coeJ/RVlz53TWiR2aXJmZJQ5iBAUgmAHRK2VknDcKpkV1kGOP6VBnWCNy5J5CD0Q9bpXuBskO8Gtbu4C3tJtIMQze3+/xZpsiUO15k/o5tlS/3Pk0Y7b93MpTFTDhkioV3mH0yLvKQ8KX6aa3CsRW/3HRknEvaqUmwzC8tE2fMmZIulRm50b8de1COJYk0LNyRvfzsUyRIwYIxwxeCzv92riippvJcB+6
 9D0PYuci
 bQA8SU0nfELJzvwLEeCrV45ecx32OEDt8UlAHua0oqwMlhYRJPn0hj+PgQEcfT9AkBycQg7hh3hqyivpO63ZdnHvwYVwp8AiynuF0tQrfBw6K7cdnu3qzHt0z4wR2xP8z2BchQtLefvDhf+TjR0M0zVeH5cAdrgj2S33ls6j7zE7FFqAUj3XSIuojd/EAEmjiJRrVB/pbI5hKUCKGXmIEflmLVjbdLezeRhYsnBpp9zm1QBeZNOIPN9gGSi8aO7oR6MEM6+NNZ7zEWzzBNReBgu3VwPNPUXm7RoJmsFNsUzjEVyA+Ua4frIJOm3rhzt5Jv2BcGfghljACSK2UAFIg4XpPxACmj6uGEGua7K8hgExapS4GBGhaliQAXQEjwz3xDFcn0La+GaK6BrGzeWufWdAiE00vdDYhes8b6ithbcEE2trJaNBXZmlGe2K2zNzsGb4nbB3omnhyQRFBZvL2qw2MLRl2zDnKB89vX+gjJYWEo0CPZlmcmfSwiZoSC+oCylSFumN67toy4aRusQffAW9apqm/QLPS7q3uDRInIFoVUBjtmJF7ZHfzgnYhpNnlVCwN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblock_estimated_nr_free_pages() returns the difference between the total
size of the "memory" memblock type and the "reserved" memblock type.

The "soft-reserved" memory regions are added to the "reserved" memblock
type, but not to the "memory" memblock type. Therefore,
memblock_estimated_nr_free_pages() may return a smaller value than
expected, or if it underflows, an extremely large value.

/proc/sys/kernel/threads-max is determined by the value of
memblock_estimated_nr_free_pages().  This issue was discovered on machines
with CXL memory because kernel.threads-max was either smaller than expected
or extremely large for the installed DRAM size.

This fixes the issue by improving the accuracy of
memblock_estimated_nr_free_pages() by subtracting only the overlapping size
of regions with "memory" and "reserved" memblock types.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/memblock.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..af014fa10a44 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1812,6 +1812,22 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
 	return total;
 }
 
+static phys_addr_t __init memblock_addrs_overlap_size(phys_addr_t base1, phys_addr_t size1,
+		phys_addr_t base2, phys_addr_t size2)
+{
+	phys_addr_t start, end;
+
+	if (!memblock_addrs_overlap(base1, size1, base2, size2))
+		return 0;
+
+	memblock_cap_size(base1, &size1);
+	memblock_cap_size(base2, &size2);
+	start = max(base1, base2);
+	end = min(base1 + size1, base2 + size2);
+
+	return end - start;
+}
+
 /**
  * memblock_estimated_nr_free_pages - return estimated number of free pages
  * from memblock point of view
@@ -1826,7 +1842,22 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
  */
 unsigned long __init memblock_estimated_nr_free_pages(void)
 {
-	return PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
+	int memory_idx, reserved_idx;
+	struct memblock_type *memory_type = &memblock.memory;
+	struct memblock_type *reserved_type = &memblock.reserved;
+	struct memblock_region *memory_region, *reserved_region;
+	phys_addr_t phys_mem_size = 0;
+
+	for_each_memblock_type(memory_idx, memory_type, memory_region) {
+		phys_mem_size += memory_region->size;
+		for_each_memblock_type(reserved_idx, reserved_type, reserved_region) {
+			phys_mem_size -= memblock_addrs_overlap_size(memory_region->base,
+					memory_region->size, reserved_region->base,
+					reserved_region->size);
+		}
+	}
+
+	return PHYS_PFN(phys_mem_size);
 }
 
 /* lowest address */
-- 
2.43.0



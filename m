Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE8CFC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06716B00A6; Tue, 21 Jul 2026 10:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7976B00C0; Tue, 21 Jul 2026 10:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5C36B00C2; Tue, 21 Jul 2026 10:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56B656B00A6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:26:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBAA61C00B9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:26:20 +0000 (UTC)
X-FDA: 85013008920.27.89771DE
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 13EBF1C000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:26:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2TGoGNi;
	spf=pass (imf20.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfQ7lBIrWKrgOrRh6zBOJZcgVY+erDBJr0XtlKK6s84=;
	b=zBcl54BiTRNA4mTj4J57rlhwnpy3P8NXpMB/riS+dvrFiDP4yLzDrO40XeFZJ5bu56jwnJ
	98kBFpzUdPjCo8xBCDMyRUjGzonXjXh59pQfF+Tb3Fs/rWH/tdlB3mEUBBClUrpAdk8SnB
	8Bu8fMrL2KDVepiGjz2sCV1OYLpjuSQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2TGoGNi;
	spf=pass (imf20.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643979;
	b=4+ng/BpwE5HsUt3zmVTcMJZ4geumjTkJ8UgEWaG7+OcswBrowM+OFxHbqxQEusEuKVaa2w
	BTFottJzwYMpGm102SrZAL5qv0ktKIflAocrcH7WDyY9gyJZyfeMqiy9r9iAYObzqUUYBX
	YNwOY63ADJ+id/TQ8BHTlL5/tl8Phug=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so4884920b3a.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784643978; x=1785248778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RfQ7lBIrWKrgOrRh6zBOJZcgVY+erDBJr0XtlKK6s84=;
        b=f2TGoGNiyRFWmXX2gMr4h+FwOg6K0Sl7HjpoMkHMsJ54lxTi0Vala5yPRl/xE9eHx7
         +XA/fOJLodK40R0WaxYQ1qocYizHVRvHr4vc4ZI/J9LOvvWHP01rnkKaCEJE2V5LD6r8
         pOzjyy+2sXMTq50HrG+V1nb75m8SBEuAi8ujSgKqaQGqDCE8cNd0EcEU6eAK8VhGQZdu
         RIGgEvstK4fvxIIvV9RPAzWnWcAiQeeuyULFow1qXu5mjZmmn0LV2bndUP6DuPIw30AA
         AGeWe4hUDyEkC02gH/D8luGSU9uAUv6d235Ov+IiwlsVNVAmR9928ix46T7N9be7Nq/N
         Tqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784643978; x=1785248778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RfQ7lBIrWKrgOrRh6zBOJZcgVY+erDBJr0XtlKK6s84=;
        b=H4JcTgzo6NQAy3uOinRq0zNWSRf8laJ3k4wnPXx86lYhS+cvdDR6ZZOM1PiDCaJlWy
         7ea0sP8hAfDBXgit5KlKFuUcaP5Xu+DhctvSiH0RO6ab1gCYhH/a5RsB8dNo1ydUda0t
         9Z3NzwTpfyfWA/Nl70PwOuchVJI6HviQxiSmWRmwZKNkeMYcPE7NB8nfRNHxTPlqFEWx
         fnNE7nRKdZc0aI3X4lR2cprvYy3blxjc1zZ6Klvl0W+y6syE4qZGt42vm7Ocr2+dw2EC
         zqJpiWh4GaR6JR9/Hbb+L7WSrNLtztr/Q/Og/VyrfgxQPlrsNNmeJBlf39lJTSzSpEs9
         uIMA==
X-Gm-Message-State: AOJu0YzYVW2T0HTgQb/g6PJGLmdEzrEXeJssCDEy4F5MGaydD3lFKBWi
	AEIY7LI0SnfoCoO0v4NYt2wqSCkYSTJgytQVQI2MYk59jImgCBjnGviTNSfhi8EF
X-Gm-Gg: AR+sD11mQp6ZUe9pHneewsoJh1RzXTOc3cX4gClRtMFohZhGodN/fe+YGOZuu11S+sn
	aB0YsycKinkIbPuqH4hSw/oOpJTavsrnP0rHrT5JI9i4HX2QoV8AOWWV6ins0qKFTs4TOxMgGqF
	59+SDr4NqoUHGGRGRD5Tc0JHwMfM8T8NsPVUwAQEpJbV60liTKl/J54xjPq6kVUugyrrOIEhDqQ
	f34xGjNTXR4eTXQmElPFW3NcappXYmMkFFFAiziWygMxpwMtX45ZUcq2KvDm8Qw5osSueZwKHK7
	SmgpxQ1yEngCjk0nnrhu9ZRpIa/sCjM2FTS4MQBEDAbm/dqevrbv1q5hHyJyXT7bZsuK49eWPnq
	8AZHX1AQc5QexlHuTSHR3rIdBA50dLrpz6x2OZl3kChQhhhYugq8bB0XWatnpsvOA8UxGePd/YE
	cCI38hEREedZOsuLF4Aw==
X-Received: by 2002:a05:6a00:2294:b0:848:55a6:fbe with SMTP id d2e1a72fcca58-84c28c948b3mr17278814b3a.35.1784643977877;
        Tue, 21 Jul 2026 07:26:17 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([144.48.80.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af7acf4sm7647371b3a.51.2026.07.21.07.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 07:26:17 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH 1/1] mm: fix out-of-bounds access and race in generic_access_phys
Date: Tue, 21 Jul 2026 22:26:04 +0800
Message-ID: <f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784428532.git.rakukuip@gmail.com>
References: <cover.1784428532.git.rakukuip@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 13EBF1C000C
X-Rspamd-Server: rspam01
X-Stat-Signature: ma9y3wun53m37tu1kgs1zf8nnarw16xy
X-HE-Tag: 1784643978-220585
X-HE-Meta: U2FsdGVkX1+eBdU4GOXZfUdDK+oIWFPQ1kL3BFrZtgxb2G+jr8FUirR79NONHtK/Nrk1hutOo+G9sTOfKyEngNLjBrFA9N9bSABzvDO2QjITcJ3QDRxzScz9u6yAf/RzkiuBtfgBIhJasqTbFLLP8EJolGOW5z/bWSoeYDWltrYUXiqjpwz6hijW3KtWCWNFraNF7j6BAHjBukS1OhKXaVMv/TCZRfxc3YR+IsDFBTnsJkABUnRpOAhUQav+d8/0vUIxaw8M5CSGbExgsOvYfhLBbJz757WGLmZzmyyCnCr54CRgUX8o045GJ/VmKbZUntuYuRDrVVMvPYF5z+pfPbsDe5zX/7Pb+7Zx0d4CHsTmA03F4Aei2D/niM48Jt43PJU2Ay9kQoq4rsXEtqWI2eeMk2qrtdKzWG/IYTw7a9/cpJyGHokSeEB+eA8JHq26sp0U3+p8Gzm3JPWqO8PBrJukK5PXbeudLIt8kMRRSHw6GMllfkWW9bs+9/4CS6UfysxP7hE8FYFsP3pjjUgDfJ5Uivzki25ST7eZGTcQiGEo27KnZvQTsFnew4iIdgpgZevB//vVU8GByqTu72SJTxPMzS6EgjZBwsmYvTXljMOc4sitnkVaC+f01FWda1pFtO/qFB6gYGFIg2vyX+mhCXXgeRIrMr7XIp8XTswfhXI4G7HFR7Zn0Id/xTUSjtOGrXD2DjeJJw265aE5NDhtdJoeyljVd74jvpLucL6rWOyewOfR421o25YLoHxq+guUYqwLZuA332NiTtRVgaSxPY3CNeBw+O5XXAbbxma7/R+qQ7PgQfDUc+S8YBH6p6D5i0LKq9LdMLEuiESkFyEmzi3E87imHgfG5hoem3QdlQpSpSFGm/B7ZwYJAkSmdv1aM+PjT5OUKOHKxzrj4RczEnIQm9prsnndgPlHxJDNONJxc2iZ/rWcgCbg3l7Za8OlAf24hHl3ElTFj4g6Myu
 G8DOdXBW
 uKKiDE76RUt3MNIJvjlqKTa/hkNpv+KXovxpJ3tBBjbgR/jzuEECw9AKOn0xlIbRWhsZ8I1SBzEaovuiKLBh2tCp4ixyElb8HFC70PeSc+9TJ85Xw6cFWOIsvEAjOJ1rOjkqzrOyEWe/IUgt1KaoTlc2nt/AuUCil9fwibbzCYVZraSFMDT5J5Bt77WTbZF33O4M0BFv1UJC8mBa9B5+ciFm6N2d1NzlG/qPVgyhl7xQ4X3cL+5Hk/sYK+MqMdMi9ip0ZJN62VglT5KLU3W4v20HWMooIGstEYcaVAFsVhi8Wr6l8O+x5W0aXmk9Mnvg/id+K6Ax/d/Yb7kVzaq2PGJVCmjqqOP/qjrgQ2z2yyMHffsl0s95zgk5AXKpvzeD2T8l+RAeKhI3pL3rNzNZpdDV53+zIMpcaNVfoGtZYr95ZV9Mh4YiN6ZZtHEz52Gj5d/xMbIe1rJOB+/vuElwo8tYSdafsC4BcIS53GaJZgLkpXfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

generic_access_phys() improperly validates the memory access range. It
only validates the start address using follow_pfnmap_start() and then
uses ioremap_prot() to map the entire requested length. This fails to
verify if the access range stays within the VMA boundaries or if it
crosses into adjacent physical/MMIO mappings, allowing out-of-bounds
read or write access.

Furthermore, the previous implementation failed to handle partial
progress semantics required by __access_remote_vm() and lacked
necessary concurrency checks (retry logic) to prevent the use of
stale mappings after releasing the PFNMAP lock.

Fix this by:
- Processing memory access in page-sized chunks, ensuring every page
  is validated within its VMA boundaries.
- Introducing a retry mechanism to re-validate the PFN/protection
  after mapping, ensuring safety against concurrent page table
  modifications.
- Returning the total number of bytes successfully copied to satisfy
  the partial progress semantics of the access_process_vm
  infrastructure.

Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
 mm/memory.c | 79 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..b2b1960dfdc4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6966,50 +6966,61 @@ EXPORT_SYMBOL_GPL(follow_pfnmap_end);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write)
 {
-	resource_size_t phys_addr;
-	pgprot_t prot = __pgprot(0);
-	void __iomem *maddr;
-	int offset = offset_in_page(addr);
-	int ret = -EINVAL;
-	bool writable;
-	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
+	unsigned long offset = offset_in_page(addr);
+	int total_copied = 0;
+
+	while (len > 0) {
+		unsigned long chunk_len = min(len, (int)(PAGE_SIZE - offset));
+		resource_size_t phys_addr;
+		pgprot_t prot;
+		bool writable;
+		void __iomem *maddr;
+		struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
 retry:
-	if (follow_pfnmap_start(&args))
-		return -EINVAL;
-	prot = args.pgprot;
-	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
-	writable = args.writable;
-	follow_pfnmap_end(&args);
+		if (follow_pfnmap_start(&args))
+			return total_copied ? total_copied : -EFAULT;
 
-	if ((write & FOLL_WRITE) && !writable)
-		return -EINVAL;
+		phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
+		prot = args.pgprot;
+		writable = args.writable;
+		follow_pfnmap_end(&args);
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
-	if (!maddr)
-		return -ENOMEM;
+		if ((write & FOLL_WRITE) && !writable)
+			return total_copied ? total_copied : -EACCES;
+
+		maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
+		if (!maddr)
+			return total_copied ? total_copied : -ENOMEM;
+
+		if (follow_pfnmap_start(&args)) {
+			iounmap(maddr);
+			return total_copied ? total_copied : -EFAULT;
+		}
+
+		if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
+		    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+		    (writable != args.writable)) {
+			follow_pfnmap_end(&args);
+			iounmap(maddr);
+			goto retry;
+		}
 
-	if (follow_pfnmap_start(&args))
-		goto out_unmap;
+		if (write)
+			memcpy_toio(maddr + offset, buf + total_copied, chunk_len);
+		else
+			memcpy_fromio(buf + total_copied, maddr + offset, chunk_len);
 
-	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
-	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
-		goto retry;
-	}
 
-	if (write)
-		memcpy_toio(maddr + offset, buf, len);
-	else
-		memcpy_fromio(buf, maddr + offset, len);
-	ret = len;
-	follow_pfnmap_end(&args);
-out_unmap:
-	iounmap(maddr);
+		addr += chunk_len;
+		total_copied += chunk_len;
+		len -= chunk_len;
+		offset = 0;
+	}
 
-	return ret;
+	return total_copied;
 }
 EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
-- 
2.43.0


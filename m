Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B057E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C086B00A2; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54DB6B00A3; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C766B00A4; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 957B96B00A1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:16:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 556E6160409
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:16 +0000 (UTC)
X-FDA: 84238537152.12.B19B5C5
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 977951C0006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:16:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204174; a=rsa-sha256;
	cv=none;
	b=JSP47oePIRknpUlCUUTN6H1/d8hDaFJAUDacVRikFGK+jGnqhMA+gV04cgSBpt+8FkO+ye
	Xrn2DxfQ04/+l2jwq7vropdFIH7XBdRt9nKXZtkAX+ZkkKx3elEeSOhBcPFD4dD01SpXz5
	jq7aGhcpgBswHD61QLHQLxIMt5I+vGQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of houtao@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=houtao@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0a8LllONtNh1UCp+2iZ2NJSy0wT09r5z7SBh1hn+ec=;
	b=q0itiRjKrAwMh+Vs5Sp3/J2IUTp7pZoaGFJ1Z3vjFXd6lw2HSXHn2VMn39O44lPzu6R7EM
	9WpqtadPSAAcc1LW5AtK/lPl1zE1oqGujdhRN9MmLP5IzUD5k9txxTGfVn2ybjyu8CLzPL
	qW0wFAuQ+6fL+OUHUZS5/O8FheX3IaU=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dYB080GRyzYQthR
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 609A540591
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:16:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPn5IkZpFwpFAw--.56015S12;
	Sat, 20 Dec 2025 12:16:07 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: [PATCH 08/13] mm/huge_memory: add helpers to insert huge page during mmap
Date: Sat, 20 Dec 2025 12:04:41 +0800
Message-Id: <20251220040446.274991-9-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20251220040446.274991-1-houtao@huaweicloud.com>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPn5IkZpFwpFAw--.56015S12
X-Coremail-Antispam: 1UD129KBjvJXoWxZryfJFyfCF45JrW8WF47twb_yoW5uF17pF
	97GFn8ZrWIqrnrurnxWFs8Ary3X3yxWayUKFW7WF1ava17t34F9a1kJw15tF15JryUCFs3
	Xa17GFy5uFyUWa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
	kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
	v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
	pf9x07j4fO7UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 977951C0006
X-Stat-Signature: 3kri7zihr5hdwrmkbra8c51srpqw8hqf
X-Rspam-User: 
X-HE-Tag: 1766204171-169561
X-HE-Meta: U2FsdGVkX1+iU71BULe5RqDuP+t9oqW0/yPGPPOa+7LKva9vwQ5fwqG8dH69x3gEFEzSl6A0uT5gDWIqTVWhef4bKYI4zD3465O6sb/hyuhj1hWHX89CEiQK2qPBjnTLCAMddnYcQgGDcMgn/wjZFq0xyQr2Yyx0o8k2dCsr3KtvyatMO14KBTvPl6LgQrJGL0VhzETu++22uwy4T9hQkYT42rfCLBPi8/gHxvk1LYV1ThFgvOlX5zWZlNM0mT3qvbT2nhlDmMOc90SKLyP7IbYpeVujEwIU989PXnK5jw5XePK921e0SwZ0njdqIOi3PwhAAa3VHcdC1jUniQKGsyi6SgA0GNgcOJLPUsQFyTglEByrfBTTkdXF/RfN0ZG1qgXr+DzKivPS0y5LnBD2oLMujm48yB7Zin6mpVppX32HUswuOlPnoHDoPoqLHKjOHDJB215WEi/uiPvObvpKJdpTcqWPav2c8WcvzqtFJgUiEfYyLqjYtgxE83kRwZNWriZklA73kB7KVi23746fofsJL2IQv2kg2fnZ7sDryKZ5r+E2vKZ4agUfEId6T2mCBHoraaPvqQc3qeFWydATGe2IEHq5UvMbePf0a9FbvQ8ZE4ed6MnktwWCUcT+fA6nk5vubupkfP7Mx2CSvVqAeabGvrTKhcsJurSleev/bHufK+guGxYcd1zdNCAK6LfX6DD+PBPKEUooTiWyi1dpmOJkuCKbrnCSAoQCa3HJCUJvS0i+0qt3/EWqsYTETfilbu4F6VTOxna5BSymt8ajCKQBqOd5trmP/6zfSKS2Wh5NBGfh8yfZaI7HYS9GGTIRc3L6nD3QY7jD8Zq1smsH07D7U7/csP/LLn8jcDWu05A8L1R8siOGyonVnv1+m4smunMUUUK1BVtytnd/Qt9xJxGZlbQM+NWjMa/DBLwGOVZ5zq4H7TTMjU6c9M7+1LRGzvoecuHoFALH5jRW1Tq
 oAD6rMZq
 PCgSbLxrrWD6usvkxHHZ3TW8Orm+JvfB8qnJq0OmMLxw0yghCIpZpYPe5m67Derf3+G/9r8GpXfIeqI4euLMpB9wANZXgg63Gx+g30kcX5TGgpSgjzmMLfPWPXXijfWR/iB7PL78toBMRb6QKFYvDLz0Fh9zYGi+XrjXAiE1krZhc+CQFRQ1U7JNoIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hou Tao <houtao1@huawei.com>

vmf_insert_folio_{pmd,pud}() can be used to insert huge page during page
fault. However, for simplicity, the mapping of p2pdma memory inserts all
necessary pages during mmap. Therefore, add vm_insert_folio_{pmd|pud}
helpers to support inserting pmd-sized and pud-sized page during mmap.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/huge_mm.h |  4 +++
 mm/huge_memory.c        | 66 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..8cf8bb85be79 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -45,6 +45,10 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
+int vm_insert_folio_pmd(struct vm_area_struct *vma, unsigned long addr,
+			struct folio *folio);
+int vm_insert_folio_pud(struct vm_area_struct *vma, unsigned long addr,
+			struct folio *folio);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..11d19f8986da 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1644,6 +1644,41 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
 
+int vm_insert_folio_pmd(struct vm_area_struct *vma, unsigned long addr,
+			struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	vm_fault_t fault_err;
+
+	mmap_assert_write_locked(mm);
+
+	pgd = pgd_offset(mm, addr);
+	p4d = p4d_alloc(mm, pgd, addr);
+	if (!p4d)
+		return -ENOMEM;
+	pud = pud_alloc(mm, p4d, addr);
+	if (!pud)
+		return -ENOMEM;
+	pmd = pmd_alloc(mm, pud, addr);
+	if (!pmd)
+		return -ENOMEM;
+
+	fault_err = insert_pmd(vma, addr, pmd, fop, vma->vm_page_prot,
+			       vma->vm_flags & VM_WRITE);
+	if (fault_err != VM_FAULT_NOPAGE)
+		return -EINVAL;
+
+	return 0;
+}
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 {
@@ -1759,6 +1794,37 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 	return insert_pud(vma, addr, vmf->pud, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
+
+int vm_insert_folio_pud(struct vm_area_struct *vma, unsigned long addr,
+			struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct folio_or_pfn fop = {
+		.folio = folio,
+		.is_folio = true,
+	};
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	vm_fault_t fault_err;
+
+	mmap_assert_write_locked(mm);
+
+	pgd = pgd_offset(mm, addr);
+	p4d = p4d_alloc(mm, pgd, addr);
+	if (!p4d)
+		return -ENOMEM;
+	pud = pud_alloc(mm, p4d, addr);
+	if (!pud)
+		return -ENOMEM;
+
+	fault_err = insert_pud(vma, addr, pud, fop, vma->vm_page_prot,
+			       vma->vm_flags & VM_WRITE);
+	if (fault_err != VM_FAULT_NOPAGE)
+		return -EINVAL;
+
+	return 0;
+}
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 /**
-- 
2.29.2



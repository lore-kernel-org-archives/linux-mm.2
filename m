Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C52C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9476B00AF; Mon, 20 Jul 2026 10:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0776B00B1; Mon, 20 Jul 2026 10:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F776B00B2; Mon, 20 Jul 2026 10:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3676B00AF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CAB8A028E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:28 +0000 (UTC)
X-FDA: 85009413216.09.7F65456
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 681471C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PARktKwn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgnvDCamwFs796LwtMmRe0oIoMrcoFkkE3Z0cH2KMyM=;
	b=5FJBYR9dZ9gqLAiL5jwrjvDnFFiG15aggl3ySiYQESyYdRmYXrWBsHO+S7CSVUj6zPG5G4
	X48/pF4Fpunci9Dg9N7s7exRSEoM9ZtF2Y5DIGKN01CDiRXGXW4SnUBV+2iks3Z3MVlJCo
	Ba/XCvolVC13XaoDLqF3P48MVrqf0+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558366;
	b=3SBvbmDYQb/sdvnhQNwzOAuTi9V7+xgwwS5H2hF34Flt+tixGsYwwIhS1BJ1dJnXOfvfOz
	3iylxuH0AoR5vME9zkrWFVYuori3xFzDJf2qHAWbNjFJ3MahN0/maG3ChiE4VoIODy/vz2
	qX4bjHnlcidw3Oh0+dbLJkZiy0KqgJI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PARktKwn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE6844020D;
	Mon, 20 Jul 2026 14:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE40C1F00A3A;
	Mon, 20 Jul 2026 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558365;
	bh=mgnvDCamwFs796LwtMmRe0oIoMrcoFkkE3Z0cH2KMyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PARktKwnNf8IBlDQKxgtToydOiMnc1qkMBjEP8ybthDMEZZ7nAqAYsFFh7Rg4JTVd
	 23lkWvslhzpe3DUvTZlXqPlNRbq+vfadGJTqlcBu02bu1gRiPLEpatpEzdCsODXWkF
	 euv2iYgEIVRLn/43u/IG8iXoIYv9R5uP++DBWseAjGDnWHVGSYPb4Vz63u+nx4haHf
	 kFUcACtnuHpkMc3NoUn8MBOzfPYy89JhAw0MZaCd0C4l42ZRBk20EMnf0KlxC8AvUi
	 SMMu92CV2DgVC2quoGEAoo08v10Nawt/ngx9UZBf6eAKvyxg+GEm0r9foEPwXHl3df
	 3N5n2jzpZ74NA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:29 +0100
Subject: [PATCH v2 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-3-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3665; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RyscjNpggtQJ4miTDtxwbhTzbm6OnS6a6lUgnowGnY8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijF7/NPfcE+j2tnWlo17rDb9Dl7Zt0U4RvnOyU0Hnc
 aydjMDxjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkxlRGhvNzGRa5CK71/fHo
 6R5B4x33JtX/fht3JTs1qYul+8G6oO8MfyW+fgh8tef+zs8ljq5zEhqPOS1YW2jllsY87eSx3K8
 TWFgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 681471C0004
X-Stat-Signature: ohxm3ic7rs8msm8tp3zcop1frr8xaymq
X-Rspam-User: 
X-HE-Tag: 1784558366-468345
X-HE-Meta: U2FsdGVkX1/ibJKxE/A7n5BBoWn0QjZ+T9szkAUyyxAXASTbE5UuS8wdJ/9JDbbtoQGhSx0vZZjRFByojWm17SBDB/VR9BLlUFHBNMF+RdBP4eIAJpCNBLD20rlMOP0dHwiyAsxOzbpDH1NXMwHLy8K2I73wM+FOiBw12zzszPO51mUnI3T4gkNI0P6sqdP5JMURoELgGI9707zBWjTxVV3vgdV8gin5ALhCp8cCK/LigvZDjL/A5q01rEwS99DG/Zrh+3wWC+BFe9iw0E/e4LgQI52z4BCLG2MM2MIdKuCUwtgPu1mi02mNit8hStfsj1313pUjmwMKb2r7wG2SfOA/FuFLyy23h1yd7Ox5fQrcN9Px69DYZWOp5oxyz5h6Sk0YoSkT5etT8rx+ntocxsuDfPcQOZ1E0VlklGsINTNG6qi2i7Da9iYO+4XPmpW1HWtYeB7HDi4Z6ehUEwoINXIuYO9P3VxTSiphqVfEwkU2NR+KE7VDdg4JP8i4PkZydqk0MGjicGgOOrNhlgCovfSKk9S3IPKJEdqtVzlfslKeZukYc3KEPU5m1yAKVy58d6+EGEO/v7TWdF6q4aUjkodflDys/+fKYubGJTRRoY2y/fPG3OLnlGkgyH/EhxQrlIQvg1K05apb6w0KHvKTPVFc3psTQpP0CH3Pv1UTCEZ+xu+yzIreUlVxVwlcZXz6rqHEcVDM6jtSxjn5lml4a6VBFWgIhyFkIU1Y+Gy8NkDiyB5jro+RzPT9sL/4zAHAC+C4gJ3S9rZYnWic5hQdGAM4FnL8SXZo4avev4m6sfOv5BLuq2HbAyal/cdg6XLDCgaxa9mn9uhilPjVyEOP4XpRwQw2tpbow0hRFLCk3OiD1low32Qpj5RSEV3LGaJnK+gY+pK3a2CSDHqLaSfJGm0z1bAUmaoAaJnKhA5NcnxlOQIu7RcYqB6AiWxUzfeiEppQ0H24XFlZqDd8mUp
 hSCcj7s9
 bzox4ELRvCicLplmctyLmLT0tAAk5AljYIwnqUd14HkMHH0u5IYsxtVW/nfYBgCqZNO45oGTELnWyIqPPo6vBf7Ra/3GBXFOhf76DX4xDKT+N3GaIdYkQ7ohDNgGUUema0dr3OCgr4lyRIg7QNWHqmF7HjVrLc0kup3dKvZ+JPlRD0MgyeD44E5uuOSY1uPG4k5dB1XO22DJkBNnT23qDFtodhrFIfhiyUxTLBjt1pQHavG4t3D5KfjQnFDqpJAF3wpunHfpIHr9tFUQpbM2aMdZ37VhDc08Ihu+ySMtZlhuVw+g16YfEVTswitXUD63AQ5ca0LNZazN8OXskzcRWP1AkVCX/1JbOwZi4QTfTsMy/ggoDnZ3zkoaK4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce __vma_address() which abstracts the VMA start page offset field
as pgoff_start, then update vma_address() to use it.

Then introduce vma_anon_address() which does the equivalent of
vma_address(), only using the virtual page offset of the VMA rather than
the file-backed one.

Also add an assert to ensure that the function is not called for mappings
which are file-backed but not MAP_PRIVATE to ensure it is only used in the
correct places.

This will be necessary for determining the address of a folio's index
within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
field is used for the reverse mapping.

No callers are updated, so no functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca2..04acfeffa066 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1005,19 +1005,9 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-/**
- * vma_address - Find the virtual address a page range is mapped at
- * @vma: The vma which maps this object.
- * @pgoff: The page offset within its object.
- * @nr_pages: The number of pages to consider.
- *
- * If any page in this range is mapped by this VMA, return the first address
- * where any of these pages appear.  Otherwise, return -EFAULT.
- */
-static inline unsigned long vma_address(const struct vm_area_struct *vma,
-		pgoff_t pgoff, unsigned long nr_pages)
+static inline unsigned long __vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, pgoff_t pgoff_start, unsigned long nr_pages)
 {
-	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 	unsigned long address;
 
 	if (pgoff >= pgoff_start) {
@@ -1035,6 +1025,41 @@ static inline unsigned long vma_address(const struct vm_area_struct *vma,
 	return address;
 }
 
+/**
+ * vma_address - Find the virtual address a page range is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
+/**
+ * vma_anon_address - Find the address an anonymous folio with index @pgoff_virt
+ * is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff_virt: The virtual page index belonging to the folio.
+ * @nr_pages: The number of pages to consider.
+ *
+ * This is only valid for anonymous or MAP_PRIVATE-mapped file-backed VMAs.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear. Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff_virt, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(!vma_is_anonymous(vma) && vma_test(vma, VMA_SHARED_BIT));
+
+	return __vma_address(vma, pgoff_virt, vma_start_virt_pgoff(vma), nr_pages);
+}
+
 /*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.

-- 
2.55.0



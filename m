Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BB7C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E636B00C1; Fri, 17 Jul 2026 14:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E726B00C5; Fri, 17 Jul 2026 14:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DC56B00C6; Fri, 17 Jul 2026 14:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34C156B00C1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:22:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9FDD12020D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:40 +0000 (UTC)
X-FDA: 84999089280.02.4BC1004
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E112C000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JcVCkXYb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312559;
	b=NX7WSkPKyd6fnZApjyWujCA9OwslzoW3ctzlyDHv68yXfyEnvYJSpckWligq2yZQles3FL
	ykwFDRMqmgU5NhHCNB6e2Mjg2cn+rBO6PDozUkM/OBSBOW+CIpsYL0dvbvMRTs8AUeYQdb
	so6MA1d32XWAwKCmJ+0VsAJdf28W/8s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JcVCkXYb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgnvDCamwFs796LwtMmRe0oIoMrcoFkkE3Z0cH2KMyM=;
	b=Gf+uEVY05alhbsqZRcCqtRNaeadkIxCuViUe3FbcpoTCpF1D6Gro2axno73mO5GBLyJmXW
	9uV4qvNdCfyl8zzjYna3ySLDUJrdqb2kYOGqkRmUH41iyAuGvxOfAwkYwC7YZtLbx+Rtg/
	KO8j7kXP7KCp6cl+rkhQPYsctMly6Gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9390F60A6E;
	Fri, 17 Jul 2026 18:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2291F00A3A;
	Fri, 17 Jul 2026 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312558;
	bh=mgnvDCamwFs796LwtMmRe0oIoMrcoFkkE3Z0cH2KMyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JcVCkXYbqHwnz/lv+52TG6IeFP5mcYERwkcsuQUadn1YjT+dBFptC5HqOqi3OM+zD
	 iwyOeiSdGMXoozab7Cy0MAodevehkDpNww7QWxCdO3tK8ONU/ZCABlw/wz9qpXm7M8
	 30l1oXnFmtHGeT0l9BpADeMgWLz+jsDYtN7MJ3bes9HMF2rRHjlw11sQdeuDEePd/l
	 MTbz1rSAzbZ6sejQsfm9xCviBOSMCC6mwoOPMNI+rpflGY//L+fqKjvhbX2dG0hWN3
	 TG6XjEatCuDuXysY9EllWP0C95dgnbBEYFi6uw1rGmf7Rk/2onDTW0a5L1aNLz0tHA
	 9vhC9PMU8wesw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:41 +0100
Subject: [PATCH 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-3-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZuKWncvuNBOpfV8iuztPcVGTK/zP8pEr5g8pp7l
 ztvXmEN6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBElh1nZHj22efli9O3TSY/
 Dr/bsahig2BfcZum2+97DQ8/bxCNCd3EyHA4KO7o1ikMG+7V/jS5e07vhVPXslO1n/ST/YPNW6/
 M9mACAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 0E112C000D
X-Rspam-User: 
X-Stat-Signature: ugj7ejtdu9fue3e3frt43o89iqhuiigh
X-Rspamd-Server: rspam03
X-HE-Tag: 1784312558-277168
X-HE-Meta: U2FsdGVkX1/XYJ8TMDjI7J+5Tb+hLPrdlbxWMJ31kkY7TjA1PEpnMZd7YGfO5OLfphccaIR9iwbsMMXUC7w4p9DkKQyBJ3aHEeyw+qrB+gjdifhXwkZIZsMWKaeH21WSNu3HQPJupm79sUpCjjLM5lJEO2o6a0QE2WMiDLDGoqZAf5pStKiDv1+G97zGMtH5Qe6UxUu4PxfId0Drp9vvWyKaVEHPhv6KKTSiSlcc8HwVoBF849ZhO2kUBLQ7YjMpX3sdtkPWufyWMkoeS5anCKjSQ+UI3AE8fiik34mOjYSyy5oaTcYxRKIlqezYSY6sw6PZ5nC7XWX2qVya4n+YXy4r8FrcuBqMYiY1w/0RUnc33PzHODa2vlphD4rU3QNGn77o0rEeT03tdTYCqUcRxgKp4FZY1KW3VC1/fjn4Ua/ioKovv8ZnqjJYfP8yQKsVL6R70c1lg31FbPdgNkACMcIIMpAplVS0W/6eLpcGmTGB1jAAeR5La6mKarHqhGW8wo7V5ImavaYvWhSBOBQdIXppKMjXwvg6EWOP2OAoN0uUAR54WXdzCNW9aBwlgUnXCuP1aCAf2EgFmuwnHaHz1sodA0iDuW85g9AU3vI3Uxr+nsXMURJ5ceLb7mJM8cT0OZYBVNHk3qMyub0/bNpD1WKj7cd6i5BpepDwy9SdPNkKGGzEaxYLI1NGCTfsWj9Fl2pqJdp2qsOFUfvgRyOIowpoDbWSFPK/pR0Q1wvDzwmuU4Jltqp9g7HX3EP01XUbUj7r7fjT2MS6OKIO97cJSVg+DEhcAEiWPu6JHIZc6x1sDY2Kij9FD+3DmF8b29bC4gKVH2A3uw3y1MVORkiTGhHoVb80Si2Me+YJCKMbvwJAHlikJZG3EFqWVSmm0JM/bkq+5u9NRUbCLrSJ+jryx6SdRWt91IkAjjyCJkjbKrnkJe3V7DDlXSrUiBQ62NC+LfvvohrsUN2rYGzvXg+
 3P27XBAF
 uT+MdiQNlvR0LnYGx+W9ocuQ50K8NiNYg1HDNHVo0Em0R+I5DQUsLCv4+Q6qfgnjkJ8EBOIrh/dogc9vDtiP2jZOKQOWhKX7iTngldfE9LrUWsf0R5u13PpY4R8gZKOauFJV1SFx+RrdOBvEdpBOwvbIbN6km6oXG8QkzEysUtac94sX4GxeKjd17/+kUdbqHOxsdl35muVfgHtwzZ1C7d9e4ZxhngUIX9KxW0OuO5qmKL+nrn6GbnYnPFpr/OvvQF3PFmp4cbV8yJ385+xvnH45rJ7+kGKNFHgLqW1ibGQO+NDqjVsE+m3HfyNgkbz/7VS+8L/Pzx9ck+stfZ/iFSKiDDWLqbn3oy0lKeQnnsKgRBJGk+vOxEEoUdQ==
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



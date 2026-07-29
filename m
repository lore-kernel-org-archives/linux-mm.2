Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17732C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05516B0096; Wed, 29 Jul 2026 12:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B63D6B0099; Wed, 29 Jul 2026 12:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0D76B0096; Wed, 29 Jul 2026 12:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25DA36B0096
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B19F1C07CA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:39 +0000 (UTC)
X-FDA: 85042400478.06.06F344C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7751340008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WU1azaNu;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zuC9MNwDX34SkqJADsn0U6UXEfBdDKnSFkXL39okPs=;
	b=ufTttAxE2oCwjbSxzZfKFaskhx+O7fna02Fdi+zOZp3rih8JBrGp42mUScDKkBiWj+3lbz
	b4C1sI+F4fey4xoSvOsh340n5e090aIWt446IZSyjUTv7Mxm3Hc+9r2BPHo1PZ5GYC2hap
	q0ZqJCbN2aYO+tI2/JWIPzd3IWldNDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343777;
	b=Hkr+UkUA+JYCgxt1PkUEMOs456tAf0QAIOkTXiDeSlaHLpvjD3SKCdJqGTqfL9Tll9Z39f
	j92DlkqvniE9+B8nLPgVKYtaYjFYXOUQJMY9nKRDHfeEK2QmaeBSlFNnY0jUUeYs4AnxP+
	gCQa2ktQz2bqrL2bU1LrdRXpdH6mw70=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WU1azaNu;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F4A6600DA;
	Wed, 29 Jul 2026 16:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808B71F00A3D;
	Wed, 29 Jul 2026 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343776;
	bh=4zuC9MNwDX34SkqJADsn0U6UXEfBdDKnSFkXL39okPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WU1azaNu7E7l4pfUEbRHfyCcGqUiwo1bOq9Bv2xjWe+nrAYCdiZVXzBCT/uOBYO9m
	 gHXvxDSxTFyk8utBxgTseywpnuXCHgvSg1TfR2HpTThSL4Uhj7sVOlYVewkNZJC73t
	 NBLTfZ8Sr7MkGFBGhEuIyDZqOQpZevlBcPsAtzXgSeIDMvYLKwN3V4w3U3tvSiP4Tc
	 R6K3MKi2a+oQJBwtqcrvA1FnL8xkwLV3R/NHH2YKM5hpBaZxqm0yC2Lcw0r9+FKGff
	 2MERa/F+SmegzgfJHKpd6jNkglTY+fm7guhANhEnfR7Ze1EP6v2yEzoFFt06EWLeHt
	 mF5CuT/qnYa+w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:38 +0100
Subject: [PATCH v3 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3669; i=ljs@kernel.org;
 h=from:subject:message-id; bh=KY9ZqNIwwoGsLwvvtZ58EeaTav1eJzmFIkOeHGwp7s8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H5oxc7XV3gebFJ31Ftjgq05g3Fsjua2ieFNJYEb8
 0sKH9t2lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCJLKhgZNh2O3iktrR2mtfDl
 sh7m1V8mnuZLv///j9buGVs3/BUWCmf4yZh2WFEkuUbg4IYVak8EZ3a2tZ05n2DdZ3964rEJuXv
 YGAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 7751340008
X-Stat-Signature: rks1izu94po93qggrmfjieyqto135ofm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785343777-426764
X-HE-Meta: U2FsdGVkX1+GSzX6kDOzKDkSXPINPvFM7pagsVtQCO11WaaTr3OQNI+IghME2v1/3+i1pcwEBWYBbEJeklqXFc1B2rVGVARhQg4FoZWErMkrfJbFDJowT2qZZsok/dTok/YmH6QGs09aF+5fPS8iOv4zNshlRZYmUsgEF7MGKklpAKWOlR120K93QYV1cLy8dSi8Dsy3eft8FI6NCU/FIOwN3goSC3AjYdMzuIrYQN67F2+YavVwVN3YjvLrQyo5+fI9re1KjK+U6H2qwOy/uePowepoXcW/gsb/85FFbM3HyqIDfEUgcAol8wNVmz+tS5ycdZcsFl+ipIiMBqInbamOemiMQYCIttX01DAAR9sbNlxl1o+whqUzTMgGie3ZgXKrIVbf40q6z+KbG7DscDhjBsG3abUeuTFdJ6oTiUq0bP/fh2V1zTboJlmhYo6CRhNwKaRd/WS8BB5Xtend6fWKyDHkCyW/fOT/H7HyDfhiJ851xhPnrl3vsPrJ4ja1uWtXHGNFmoYC4AI5ey6qiRtskVTOR6CLdLubFgW0gMY1y+NeZNf76s1avx1I7IHjtouPRXE2z1SSEReeAY1ZAo7ftUvDhDv4O3rB9i4+mGCRjlxeiENzKNk8yZh2XkjFFkVAvhij89ylI0O8vI0GG67FJ8SlKhdHDi5wQoWoBlSmnMPkBpgQNfPNHwxHVmPoS8QFtUpAZ0YgcqWHLCr1I95+EOhBDT9lBfPqGNbEgSwtdFotw/EIQYHrAcfp9wFIw8XMsynj7HI56TzqEs7lzCYjNN8oFw85TSXBrsRMcRYjMONc0C2hsHPAOF5Iqm02vlRJB6dRlTUCoJ9zbQrE+RQ67sHPkCnpCsuAQdm+1v6V/UhHu04z0Jxv306/5t61WKIO/wFQ27Xjf/759nwSogv3DRSiT1ydAXywu+XgGJmRryTcUWp6RyNNWn8Gl/QhrwzY933D8EmTGRUWKD4
 itoTTm0R
 L5BvA6bexU8E/+ui8TgSEUMRo/Sq25EAZfIk4tiy+BAczCE0TbOGM/avlakS+IUcH/L4fNReDrSi8VHd6wr1qwcNl4gmqw+LykDuvGQS9mbTCB8TyNHLoC1U5RmF7uqpNFtMPM1dg+6kSY2PIVZfpYY7NcotPsJCxIi1Jc96vbXDmtXWNBfDicnK2JJXrF5jcymskpMdSfJNW80e9YiSFigkFaJZ2vTmmHbgYuvSGhcVlfb4MRG9U9oCZcJ4ok1kUi7LfE37zg+K39382/QKx0a63znbC4Nsl+VTZ7o/wcK4aTKR/s89+5V9nPS0BdWNiRuEhMEMd1qXtpWSqKYTcl0HRHul5r3IpO6CNCFml8uTQAfx1JEjz+YDpyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce __vma_address() which abstracts the VMA start page offset field
as pgoff_start, then update vma_address() to use it.

Then introduce vma_anon_address() which does the equivalent of
vma_address(), only using the anonymous page offset of the VMA rather than
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
index f26423de4ca2..0d11eb8e615f 100644
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
+ * vma_anon_address - Find the address an anonymous folio with index @pgoff_anon
+ * is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff_anon: The anonymous page index belonging to the folio.
+ * @nr_pages: The number of pages to consider.
+ *
+ * This is only valid for anonymous or MAP_PRIVATE-mapped file-backed VMAs.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first
+ * address where any of these pages appear. Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff_anon, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(!vma_is_anonymous(vma) && vma_test(vma, VMA_SHARED_BIT));
+
+	return __vma_address(vma, pgoff_anon, vma_start_anon_pgoff(vma), nr_pages);
+}
+
 /*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.

-- 
2.55.0



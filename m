Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2D8C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2318F6B0122; Mon, 29 Jun 2026 11:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E26E6B0128; Mon, 29 Jun 2026 11:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CC36B0129; Mon, 29 Jun 2026 11:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8DFD6B0122
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47A4740188
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:09 +0000 (UTC)
X-FDA: 84933270618.05.7C21924
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89C344001B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C/5rVcyE";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745447;
	b=nHubkj4kltNlh4CsnUd4TPEbH/tpmCjmxerWtVb7Yr5m3NJ5lRZSbbcWxdKPJR+NxRQfiz
	6BQnqmRNbXIhlSkc0l4/Yv5WCQS0/Oi8agkDp19yfX9FnxAxtX8Ep4oeA/5M1AR5Eawnkl
	DehdARcqOsV1feidAv+FL1tO3a8NHPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DdTYzEtu4ByiEUoSpMsinYaOl4+O4+ddJT+gWoYupA=;
	b=mnW1oppvULmCF0C98rVysUcxa7zDXLIgENLiqlMxXOCyGSEJ+ZAD8TOvTyOBz1ym9oZfo7
	bhuUPG0SRlnPV7W1lu0V4m85VEy4jNEFd6PAktNJ9gHQ73vpZ3j0fTexG4tbwppx74Zgwu
	SGWffiSSw2mWWPk8EsoISD+OIWGWfmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C/5rVcyE";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6D1E43EEA;
	Mon, 29 Jun 2026 15:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D8D1F000E9;
	Mon, 29 Jun 2026 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745446;
	bh=1DdTYzEtu4ByiEUoSpMsinYaOl4+O4+ddJT+gWoYupA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/5rVcyEx/DDRNUuTGZxEIfgwq0ywplFZzKOf6vzDKxIfUFz9aKIZkEICUqgIa06G
	 vR6p7lB01J9QCTLZ/DWSzDmEcjVeRSlnKvOODgIorGqNEBgsbzzWBGtLCRgNORsdFl
	 gDWfh8k0JvYr4OCmiZ1gOvzYlIcXhzjJF4FXcCqe1Yurw33PwM7P1GPw5gRwRNyq5P
	 eTHRvW7PVXd5VSkI7WINZRVmGgrORlXvR1C4UZr44aiF4/h46c70FC89n/m18HUAog
	 OWiav7nKM5MXu/shgHYgVlYyHv44ZoKfzqp9SkeIKHaa7tpLy/wuZ3v56QIDURqi7V
	 cS94ReU+6pujQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 02/10] mm: introduce linear_virt_page_index()
Date: Mon, 29 Jun 2026 16:03:42 +0100
Message-ID: <ab82859030cfa88aa52768d1f32f78c903d15844.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1pbrnnzm974f1wzbogzmggpsqr5etmm4
X-Rspamd-Queue-Id: 89C344001B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782745447-340979
X-HE-Meta: U2FsdGVkX18n3rXxkEGTuNp3PVihFpFB4DFmaK5ykL+6nopkgXsS2QIkDjFnLkp5S1jnDTmKIiAMODT8dfOw7ZX1kRAkrW89od+WC1zQCdVmLJ4ZBqrPls6GxPgTv32hRpUQazb0k6P6ANvfo96j/+ec4iChDOSOgiJZdCP+tWLsaTe0x3wWzjK16NBWSMQZ3JplhT5/+sphe26JP70VTN7o147a+CKESZN1mcwIZ8bV8Dk/rCA1dmYscC3vJhM5iIa4gZh3bAAQYBvWzqEZUuY/hgW2MxrKAXPj5QnaEyS75s1f7HJ3TV5CBG3LQaLt53daOZUMmfRkayUv77HKl68wvha0JalFhiJTQWLwkzDyofQp51L4EwK32Q7LokCqYEZjzHDqpnF8lTKYmcVCMsBswovOfdEJnhMFL+XITKcUm7SatTblgEtoBmAdHGm0XB6O+cw2RNB9gy/Dhr4q++mlabZKWG0V/lCN/+uDsADrlXPK0Iv5fNKHRwMFkakPkndXeT9FoDZX8foiuCfSjugV9ywn8e/qYWeY9e0qEuT4oWAJVO2ftLVAhIPZcw0+uCmZltojWR9p0LuIY3n1TgnrQt8m2Ea7LlL+l6n2r3YBCMsiDx+hSSJ1Ap0++7ZLJZZbvBL+Led2dYQidaA6ljFcEgaTTSEYQ17bEFF8N+u7h2PGcjx4pknFrsf6HyUrmdvxroPo/esLXkRLSl7o0uN3dR+mUIG4eGtjyT7tb9RZFReU3yPOcmSshOaICR4QE1o5Ceye9v1g2zbD1dLWcA4SxUGbdvSrf9G5rwir0jUQoawxRynrrFlnv/sZ/nybHeAjSKv1HRn0LLRCFNh8RIsRiCJf2E7y0IKtvcfOrhfr8hzc1ycN2lWwyYwBAVt+XsjNxfUKIOZEWslMeK3sKNYq8Us1/0vyfcQ+mPRE+xTabV2GqZ8ZNhE4gGXhh4AL1Hz6mNSxMu6vXhoxQ0u
 G1Brkgvm
 FNiQPQ2hxg3BxczwpEJByfzDvvzXyVVX2MOlgCN/hSNd47dkT8Dth7bwXDTsA0/5LWyOx86tw/h/regY8bFvdqrWf5hc7xVmsfDNj0Vo3oW5qVPkBRvVghT4/9SRIAlgffDgQngiZzsozPQHGcP5LuRsXx/LeW7zsqyd/gz0+UY7AnYk8xV+QxZ+4SFwPhD5GtwakohWDxNSqAHUqhUtnTWvwItaIkssUmH1j2KLHsh09wOQK9mUm2TKjBcmG/sdzz9RbVvKqvnpj9+U16z17uNoz+KGOPfTH3xpK5l1s8jTQSXZX4qg/SNjRilPfGuMqsUAsF3HtPIs/ZOm3jdggOjxfHiq58Jk0MZYpeveqHyWovHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function provides the virtual equivalent of linear_page_index(),
instead offsetting based on the virtual page offset of the VMA.

It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
not be called for shared file-backed mappings.

For pure anon VMAs, this will be equal to linear_page_index().

We implement the algorithm in __linear_virt_page_index(), which is provided
for internal mm code that might be interacting with shared VMAs.

In linear_virt_page_index() we assert that both of these invariants are
true.

Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
but not fulfill this invariant, so when asserting this we check
vma->vm_file to account for this.

We do not update callsites yet, so no functional change intended.

Also const-ify vma_is_anonymous() to make it compatible with the
const-ified linear_virt_page_index().

VMA userland tests are updated accordingly.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              |  2 +-
 include/linux/pagemap.h         | 41 +++++++++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 22 ++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd826c052be1..9451aa537abb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1533,7 +1533,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
 	desc->vm_ops = NULL;
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 68a88d34a468..6e0d719d639a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1105,6 +1105,47 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+static inline pgoff_t __linear_virt_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_virt_pgoff(vma);
+	return pgoff;
+}
+
+/**
+ * linear_virt_page_index() - Determine the absolute virtual page offset of
+ * @address within @vma.
+ * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * This returns the virtual page offset of @address, which is the page offset
+ * the address possessed at the time the VMA was first faulted.
+ *
+ * For anonymous mappings, this returns the same value as linear_page_index().
+ *
+ * For MAP_PRIVATE file-backed mappings, this returns the virtual page offset of
+ * @address, which is the page offset the address possessed at the time the VMA
+ * was first faulted.
+ *
+ * It is not valid to call this function for shared file-backed mappings.
+ *
+ * Returns: The absolute virtual page offset of @address within @vma.
+ */
+static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	if (!vma->vm_file) /* Is anonymous except MAP_PRIVATE-/dev/zero */
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 09cfbf9572e8..bac6caf2eaa2 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1601,3 +1601,25 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
+
+static inline pgoff_t __linear_virt_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_virt_pgoff(vma);
+	return pgoff;
+}
+
+static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_virt_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	if (!vma->vm_file) /* Is anonymous except MAP_PRIVATE-/dev/zero */
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D596BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C236B0095; Wed, 29 Jul 2026 12:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC8C6B0096; Wed, 29 Jul 2026 12:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38DD6B0098; Wed, 29 Jul 2026 12:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87BC86B0095
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5BEA1A0739
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:32 +0000 (UTC)
X-FDA: 85042400184.14.0EF1325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EDB928000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhpd0p3b;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343771;
	b=Mr5qui4tzfs+Yr57E9TL5jdnMcUIE5qW3Og30bqDRfcQVtiKm5L31+leqGHe3EBnhEYaDy
	SIDJsXVt33qfzXO2ecoBhZcNcRvMCe2aSuitlWDcxIIBnwA3Uq6q1PGyJm67bdAX3dhyhE
	PWl20Rp6ipRO/j8tAQbU3lZC4sYeT48=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhpd0p3b;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5kAutsj482xFMCwr+33we+a5btvgg3Nzu6z2dOByr0=;
	b=ejU0rTDxyo9ajkxbPb6Rmf5N92WCQwXG8C/bpqDEEQeKLJ9omAgJpbfONHqzoevqSif9kV
	vSSoinX50ttpTDFw6BwRkoEpGyCmhO7926I2d42e4t/2uoWNJifxJzCXyGmQU7PCw7JCty
	7PP9M5Xt2mWkcQjDMspzKT+2BHkwSF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EE8D41A4C;
	Wed, 29 Jul 2026 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5871F000E9;
	Wed, 29 Jul 2026 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343770;
	bh=k5kAutsj482xFMCwr+33we+a5btvgg3Nzu6z2dOByr0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hhpd0p3bXLycu3LhvAj8ez3BxmG7t7+mx2ZPT0+kcXKmDqV/EAHCqSBeCc9UTueMN
	 F0feD/IkKhCTU8xcq48A5BVBFFthxR2+TwVjLB03ERYQSFHJCuRoNruqgMd4bXb/8f
	 vb8CZrETPDBWe+4pQOfuJEDepEGleqczB+c24ydzEt3vL6ld3F90kiU5d39L//+sSO
	 KnwHzKjLCRuwFC0Ho+Fdks2vY/e2YoaHlEQlDyOF4YmonBE22u2Esyg/VSZgPbuKF7
	 DbaEFdErKqVSMjBwB5V+TZn3evxTHY+MJ5+iEKkRvx8brUQLhXvXInmVyVXsF8fa7S
	 THza4vR69ARBg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:37 +0100
Subject: [PATCH v3 02/15] mm: introduce linear_anon_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4933; i=ljs@kernel.org;
 h=from:subject:message-id; bh=N82Ec3g8xe0NAsE4B7h+svvxqnczc4k7NB9slAtBrDc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H7YCR6+//mTxBz7LWdvC74vkz7ibv5Pfr4NU3H6s
 2c/dR+adJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAizD8ZGf74frBrf/v9pI7l
 9EmK5z3zJ7GzO7rdFi/P/mr9bZLvmwaG/37BMVs7SgszxIJUP8n+UOcoF+/WPrnITet0hsfxn5L
 H+QA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: z68zu7wutfahg1tcyba6w3q18iwyx5d9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDB928000E
X-Rspam-User: 
X-HE-Tag: 1785343770-211096
X-HE-Meta: U2FsdGVkX18YzYLid7eVTVzUUxwbVk7+ugg2+h2ckTSIYfy+SGO9mL18biTsMAiqYm/Gg5BdojxodJIHUXbjEQv7DRZieA8HN+h+JyC8uBzFbxuM8/ql7ckZFfA4DGM3jXmxAkSO166ZXkhj7cQCpkuXp3FNt0A30WAQ2bDwGiGBfztVS0lA9k6GyITSTLgrl/G9MxxRL71KOT/YKGJCCvswHlDSV4zrkVqpiOU57+n8GPQy2yYU7I793S2N3rI/HBKlVDlcxsG8ubU8ar54dUvKxwMmeCXYN2s9KsItq59iOHjX4PX2O/56NAEy0ESbZwa3FMMYmG4JRMwZT8O4O+2Tj0mS2arBDDb8SK0LJvreS3eRUJzz2DXZdNl+JwRIEthjWkWwZmaV+4eMkph0vbIjps+GaPcVUetcX22cm/jC7KU22nWhdfe4obiZOLlX4jYV0ZhtFDfRIqc8YJust+dNlAa9FLO7C57Fs+Ow4wWgYfYEd05FrHfP7O1W5ytIgRlmamTswa4OqZlEeMe3V/dAW59rDKLA01Ex4DEDAkHl0VNpCh+/Jh1JTscWKYvrv2d5l8dDRfS8l9PaRdi7nsF3TsIrO1mKmxZR7teStVRiAlHc+L53eEFmRQNCUkmfOC9yITNzK1yyXi4tR/S9vWO6gBuhZyDSuvLeLWlOkGlmW1BqaVgdh29Vy8/GzD42BUSkvf+qUxWdnOAK/qxAai00Myt5Tsn25gXuvcsDZ1XDSJ7UoOyQz+oVJS/CJqxf9+Rnvr2xsKyxE7kzGhHdgjoSudQ9dNIeepqvruMCrAYa/Dxfleg76iYUgiaQMvnC3dEL7kdC8oWXSJKdNiBrpPhqDBo43mDxaYcjpBMt6rkzluSkHTdZLPAmtH5vBqD0+KnhCG40JPxXj30hTqG+ZWngbQKdrPauICkeipmZoIm8bPe56Pm2tVMsKZhLptqU1l6dVBlqdYgAwccz+t5
 Zy+7S7rF
 AM81nrsYjhWENcLxv4M0fe6JRsgBkh2UBWvBR9D1KIlIMT57Zuq5QU8EEig3TzwCAL0OI8MnA2emCHIx6zMBX+NctWvsFAacdSpnWbg96MFj9gx0h1xSVwVVzQrd6V6sxHyE8hbeaOCK+w1EY/pMCM+EwbF4t53kbKAH8rajVzW0JeRpSx/TfDdivL0iA/NnD57Dm+EWMf/Q0/H890M3havne94nrRRpvNnsrj3cU0khIe+rIe9dX69vVuL+ckLE27WhqbGaxoajtH7PJeH3PN55VyRUv/NpRSbY3TPi3tZQ0q9w+KSMujukAMO/+bA/dRVoSkBky+dLp2muXa3OQAa4WMLXKESbmZywKhvqQIIlHvk6J8O+92hBweA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function provides the anonymous equivalent of linear_page_index(),
instead offsetting based on the anonymous page offset of the VMA.

It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
not be called for shared file-backed mappings.

For pure anon VMAs, this will be equal to linear_page_index().

Assert that both of these invariants are true In linear_anon_page_index()
and implement the algorithm in __linear_anon_page_index().

Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
but not fulfill this invariant, so when asserting this we check
vma->vm_file to account for this.

We do not update callsites yet, so no functional change intended.

Also const-ify vma_is_anonymous() to make it compatible with the
const-ified linear_anon_page_index().

VMA userland tests are also updated accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  2 +-
 include/linux/pagemap.h         | 42 +++++++++++++++++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 25 +++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index df78847f5f07..64214191e7c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
 	desc->vm_ops = NULL;
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c6fc783aaee5..259177544b03 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1101,6 +1101,48 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_anon_pgoff(vma);
+	return pgoff;
+}
+
+/**
+ * linear_anon_page_index() - Determine the absolute anonymous page offset of
+ * @address within @vma.
+ * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * This returns the anonymous page offset of @address, which is the page offset
+ * the address possessed at the time the VMA was first faulted.
+ *
+ * For anonymous mappings, this returns the same value as linear_page_index().
+ *
+ * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
+ * of @address, which is the page offset the address possessed at the time the
+ * VMA was first faulted.
+ *
+ * It is not valid to call this function for shared file-backed mappings.
+ *
+ * Returns: The absolute anonymous page offset of @address within @vma.
+ */
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}
+
 struct wait_page_key {
 	struct folio *folio;
 	int bit_nr;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 26d9210b1e8b..5f1d93b3aefb 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1417,7 +1417,7 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
 	mas_set(&vmi->mas, addr);
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
@@ -1610,3 +1610,26 @@ static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
 {
 	return vma_flags_to_page_prot(vma->flags);
 }
+
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_anon_pgoff(vma);
+	return pgoff;
+}
+
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+					     const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}

-- 
2.55.0



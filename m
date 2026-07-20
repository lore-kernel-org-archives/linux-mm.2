Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8659C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935076B00AD; Mon, 20 Jul 2026 10:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CA86B00AF; Mon, 20 Jul 2026 10:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8225C6B00B0; Mon, 20 Jul 2026 10:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57DE46B00AD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1A471A01B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:18 +0000 (UTC)
X-FDA: 85009412796.19.6B2420C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3CE45140011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kb58OMVN;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFP97SMDeM1EuvkMbJb8/u/+y/6Q9ReGgoU9c1P8hOU=;
	b=QyJ4VLjVytaQNiDzXyFEpNJNn5hdkzHKMyavn989KlouoG39v5KAq/99WRup1xGAbW5bkH
	4Kwgsk/U3w3IKdiXZfzrIakKM7DQuiJMi7nU0SoQ4Te1XttKv/Q9LZvbsyOPdLbzfAWXUb
	vO2kZvFyc0vRqbmuxU+4S4GpOdbV1OY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558357;
	b=w7FTA9brH7DVUeQIaC1pSYJZKMHTZ16H4sYE58cLvCu183h76eaby9zqldPSE7siQctE8t
	Aa/SQQ4klwsEUpz0Ua9VwxZ0SGN3Jfiy4PRCEOuHKt+lKQ8JUP9LtKPKzAi9PW3LTW54IU
	BM2RqvKiNQnfke6hiBeHjEbPjSz83FY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kb58OMVN;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC53B60103;
	Mon, 20 Jul 2026 14:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A194A1F00A3D;
	Mon, 20 Jul 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558356;
	bh=iFP97SMDeM1EuvkMbJb8/u/+y/6Q9ReGgoU9c1P8hOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kb58OMVN45aKYQMIYQk7+XxpHyXqBxUjmblkfpqYSokdZsRbRS2TMPlSw8h6Eu8RL
	 E/nMP3K2HGckSYICbTQON4rwaDSZCllu7H3aYe6IPGBPIUu9HzxJWLaywJT29MZa8C
	 tRsEqA+uMG1cWiuRoErHfFBAyaLTQfml3qBscH2UvSiXV5lbxClz2UodHnD/X8yE0V
	 BOpGJcrPKHcrFpvHLc1WMGqdP0Kop/2dzYQEJkDdHA1DFZOLYzZuzpPcguNSCeX2ew
	 caPDz+ynLReA1Y3SJt+9yHqNUVSB6Mp5azJ5z07gq1JNnDvTYl28TNnJxhsxc4kqpM
	 Hmz1bg/5kytJw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:28 +0100
Subject: [PATCH v2 02/15] mm: introduce linear_virt_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-2-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5006; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XmUIXnVj5BvnQMZaGvlFqJYGhJEsEnn8SPAP5N1zKgU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijF6rSoV/FWHl51nq6XJ0deCVw8ZRu/x75/g9bkl9d
 PdEmtnzjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwk7DbD/xCziuWr/gRlzmhY
 1KslcTi8dVHtuptPZ50UtNZk/mc17wjD//y4r3wfOO1/uYUvZkvKWLb2TJNbr0pynfSkabVue6c
 cYAAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3CE45140011
X-Stat-Signature: a6qbus3u9acm8uh1rss4uwhgm7r6zcsj
X-Rspam-User: 
X-HE-Tag: 1784558357-59329
X-HE-Meta: U2FsdGVkX1+OJ0KXhLYL6fpAFMYREJbQgSoZyPQDGZCfe2kWLW+T1JZjiU6aQn9UifFYUMH7eLf6+TinU7ZnZiCF6GtE8tgtLMR2kTEk19aoABk52Fi3TFMttRgpusHgzEP1IMTBlIhvRFkzcBYRDrF3BVp3u1EQWLvA5lxxEczdP5EI1s/e0A1Co6y8C3sgifvU3owhEGbKKSQrAdJvkCRlFAxmrmqk06j3wLQfogyA0cbneXdEX2JF56fWCuo3H1lmo9onl91LkOFERBKHhrMRIVBrkOCvZf1XI0GYv9un6YBJKwS9lPW52vLmASlmPtzVucJXkQdqDNcUSeSg+KBuK/TOA4T1gWrtDX4hhKutw79Eyo3bKvhxcP/MABZZkGBlRzmq9SyfzvD95q25loF89Q9A11Kuemn7KOH8in9X1NFjVdoXHFN7peZVuIVKbQawcc9dzbXktKj8LxdkUdoP1HmKiZgZvYKXJN0oVayTlDkbmbE3t/Tbver+N46AmaIN7i90310icpM4fN4yeyPsePh3kXdJxn2AvCpQX7dDepRwfTH7/sLSwPTVQicBTnijROmCd0ZJ99lx95AxtP6Zjz5WPA9SoJ2JGO1CeU8sclUe+3zICJdUlda+rSNpyfsU6psMuKpwcBls/h4mkz6W5PIiE33puiRunX8LoIr800MmwvheuRev9fh1OYN4k93LOLJzm+13rVwHPpk5WMXXINQGrAjsmqtmmlPO+zIttbtFbPnxADZtvPIUD2k+DoEKV0250fT+LQ7ZKeoKECXrmV1g32yzAaiztK7M38TvQFUbDQ6sJKBTLhqZ100OUsUksgd3IoQCGSxbwEyNbJ8v3yu9GVszWW36AysjHSB5aws23h2mOg4THmoVi21EndTaccMruQPZ5bhg6oI4ZTgBw/7SMcwGsqWjgtrqOWvggCNNHXWNIDbkDx+P96viZUAe9kTICyicd0ENHjs
 SlKoLKtm
 5DBZYtYBt+AbBPa4mmUJoOLTtCZMuPOjhUS1pZoPkKtW9hCPiNW7i3A/McCUcr1+jRSfkDv5w88dD653dEUoNoqsocstFeTIei62DgXIcC5vOHXhxld9k+FGYo/VReQMrraPdpwXNDT9D83TwQ1bE0iIOVyut7cqHlICGBLPwrs0ugE/cv6zIENA/z7mUxGHaRuJGDd474vXFFaJy8x4bG0B0cbjZ7MJW9/1NiFw83nzx7eTI1SDzjOY4l17inc9XdrQYj4eG2kJWio292GXWcmDyxHv/lZB2SgPmVAMetClRgKpBjp5F5o5QF1CekTd0BgMJM/SOVV0OTqm+iefYlJaxXtj4rxfercSnQDpcDHIt70l2bQ7dFiKNLQ==
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  2 +-
 include/linux/pagemap.h         | 42 +++++++++++++++++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 25 +++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 59b98cc60402..b6503b5f0010 100644
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
index c6fc783aaee5..c9c65ba60ab3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1101,6 +1101,48 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
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
index 00d416d79ec1..0c74899abb33 100644
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
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}

-- 
2.55.0



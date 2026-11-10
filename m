Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D0D606A9F0
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfu626Kw
Received: by kanga.kvack.org (Postfix)
	id 94A4F6B05B8; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4576B05B9; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7752A6B05BA; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50E616B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:58:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFB8C809E1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:59 +0000 (UTC)
X-FDA: 85419816678.02.8830031
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E5844000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfu626Kw;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329878;
	b=S/mwYNjr9KxdpGJR2A1j2axngYqCjakvLg7yphNHsqt2+mfx7HrbmBCotZORLES8q29bMN
	YwA5W+baftpOFoX55c+qVI20yjYyKJ9SYkSRJt5Vkq1sQtTtQNeCfsDUGvrN61uSuEzZe7
	V0Wp/uFZAV8VV3qPeZyCqoGEYYDU0/k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfu626Kw;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbTBuXRxbATil13VQfmSROal5KZd0JmHctFeuDO/odI=;
	b=vKYn84qcSiBYFALcmrxUVYLRBkN9YMwbcA1p9SaFmFFC3nmUhCl63KMgTrOm6Ohv655nND
	WVK6otpiW2WYjPEpBECpeBrjf2QFm7iFX394KWu/UiZ/yFCNZOhn9zr7kedB0ISTv/nTHs
	zPCpngquBaOmLKVDmwpVOM662KSl6rM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6035C47405;
	Tue, 10 Nov 2026 16:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA7B1F008A5;
	Tue, 10 Nov 2026 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329877;
	bh=JbTBuXRxbATil13VQfmSROal5KZd0JmHctFeuDO/odI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bfu626KwVogfTJj8jaiDaRkJqmwZQNSxJ2L/mRSUe79KfKrc0KYeXaTl27q650ODJ
	 1axZTpHPlFgB6vVFFGpfFn05OtyoOOYmq/Ub2vfl7n8LMdPy6c1rpr4TgGk3pfD2m5
	 Gfu9tvO3ck7Wpd+hyRvcTBYkHtLQdJ0J7x+OrybcCpc7q45nFjAjiCf6eF1xIEUXhc
	 3U9EfMH0BKmIitYzZUwMXiQdE82vhXtUWZrQkB9m0IbQgM+TfPLyG5YtFO3anNCwc5
	 0EfyTUoX6CDJN8ufbqLkFMk2hpUdAugM11oj6H8SwQ7qevbo9tBPscm0mI3sBs0XY+
	 TrNld9fbuAepQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 16:57:44 +0000
Subject: [PATCH 2/3] mm: only assert VMA locks if CONFIG_DEBUG_VM is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
In-Reply-To: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3440; i=ljs@kernel.org;
 h=from:subject:message-id; bh=4EpJ116zFLkOIel92sc9+BafyFBTVp7rWM0n4oPQ7KY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI++/K6rN50T/LePQf3rAItS+NXj8NWNjqe1wy4r33x5
 KFlXqwxHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIFx6G//7Rp9eIMfHyPFNZ
 EmH1uSRTNHJiRt7s+RZ/Cy9s8FOqusPIsGlXod9k9/6UjJAIv6l6Utw+L/a7frngN9ft+p+ZzOs
 EeAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: t71yj6idckr8rct8uufw5giipett6end
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E5844000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794329877-364739
X-HE-Meta: U2FsdGVkX18CSz9dM+j4WPvRYkJ3LL2o9dAxDvDcRu6u6+9KyB8KCdKeHgEvUfeGMyykD698TWH5LnJeC18P85Rrj63UZRoq3z4yin92ivkvlAFdZCljI9zzZVo0DvS1IrD4czgKKXkFGSV3ENM6ZgD2OqB0YbLuDR9jiwUmzACq6MwoOzVnusYX7siukDnW4e3umUrr5ILS85s7kQws6r5FgoSVjmjO0ahwt2d37R9LntKmrLemVwy7OM0IFUdheY+kie0MmCKSaVivae5FKJLSf503yKhJAM4l1Uq9b/Hki4rWsrPvYBJoyTr7RJJmsXqcihIH9JJ03j8hxj8RLNdc1euf0qeL7Y99NfWMl4dhbnOK3M2eHVa2Wm4AdX0/oeB+S9j/EC5h6Up48lGNu6RTncujVnV8fktpAPAbdEGbPt6tJ5RKc2by8GytMbEnBz+sLWMyKECVSX2fQJGay3LkpCAIkyjAxJZ712RgeuwbMr6rUJw6qBlR708uJ0ZIpH8PGyj9tnQkt0fzkiHpSjTwO/EdZCpP4L9iOlUa7CPUQpTZY+RVmv1aSc2XOL0vAT0uH35yrp1WZMMZXag0XFFpP9rIkgWzXRjVoMIP2gM8EmqSGkKSq0MEh7hW8mD0nGtCy4yXn3fmlNzHZsuGqb3OrNClpJYP2htd62FJHlDqgVCifKUW0qm3nB8DlWK+voQyT86AL+Y7v2nGxpot5NOM8VzwOStluBbLKiTkJa2RAxbq/RXOzh9VE73+lGA0ZN5rHRiSujfnHuvG5HlgTXFUHe9P/jRF12F4zPFFrfpMP5do3CaKQ+uq4+rcnKLxM22JKSaCjg+74jUv0AzppgYYFY4dIAM7B+FITbCc517IKM5DtyHRHf42dbFNKtXWDMAPD0CZhOQHbpdEoYGXpu38nRojfuHxyJE4ckrB07aNpmS64hDh4Ib9oDmsGomkSVaetznz2KoS6ZbuAOp
 I2qMAUHB
 TC04ns8XxeiOaFWaEyieYj2RExw+CSuILVDlEBpsTa21jLtdZNd8HD1m1BUckDekCdV2RenEUzZ4gfh2JdcjUwixBK3rx1JYJIHYiucjO/+kKGfpWkzcgX1a9Zp4uJzVT224OCw/xYlJ+GTrLP7EcV1HYesyND/Zw/NfUJL097ZHlbgu4FLGK1flhaWSfYpoyst9MmXnjaoSFBVebh52Fr9leZyR5aR1t/9/Y+f+aX4qYJr16pGu1oKFRY/nNhulUhn88by7Os4Piddk8WcrZaIr4C/UyKE3smDoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to the mmap lock asserts, we have also asserted VMA locks
regardless of whether or not the kernel is a debug build or not.

Similarly, these are asserting basic assumptions about kernel code which
should never assert in production code.

Since all such bugs are generally asserted using VM_WARN_ON_ONCE() or
similar, it creates an odd and inconsistent situation where some
programmatic asserts are only checked under CONFIG_DEBUG_VM and some are
always checked.

Since the intent is the same as any VM_WARN_ON_ONCE() check, do not assert
if CONFIG_DEBUG_VM is not set.

Implement by updating vma_assert_attached() and vma_assert_detached() to
use VM_WARN_ON_ONCE() rather than WARN_ON_ONCE(), and gating
vma_assert_[write_]locked() and vma_assert_can_modify() on CONFIG_DEBUG_VM.

nommu loses its CONFIG_LOCKDEP asserts if !CONFIG_DEBUG_VM in
vma_assert_[write_]locked(), but this doesn't seem to be a problem.

In addition, there were already inconsistencies - vma_assert_write_locked()
uses VM_WARN_ON_ONCE_VMA() and performs no actions if CONFIG_DEBUG_VM is
not set, and vma_assert_locked() looked up vma->vm_refcnt but also only
asserted if CONFIG_DEBUG_VM was set.

Therefore simply update these functions such that they're predicated on
CONFIG_DEBUG_VM and update their kdoc descriptions accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 9367430ee53c..bada7a03ddf4 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -354,9 +354,14 @@ int vma_start_write_killable(struct vm_area_struct *vma)
 /**
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
 		return;
@@ -369,11 +374,16 @@ static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
  * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
  * lock and is not detached.
  * @vma: The VMA to assert.
+ *
+ * Assert only if CONFIG_DEBUG_VM is set.
  */
 static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_locked(vma->vm_mm);
 		return;
@@ -480,12 +490,12 @@ static inline void vma_assert_attached(struct vm_area_struct *vma)
 	if (!IS_ENABLED(CONFIG_MMU))
 		return;
 
-	WARN_ON_ONCE(!vma_is_attached(vma));
+	VM_WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(vma_is_attached(vma));
+	VM_WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
@@ -549,6 +559,9 @@ struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
 
 static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
 	if (vma_is_attached(vma))
 		vma_assert_write_locked(vma);
 }

-- 
2.56.0



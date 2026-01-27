Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B11D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CED6B0093; Tue, 27 Jan 2026 14:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDABA6B0095; Tue, 27 Jan 2026 14:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B466B0096; Tue, 27 Jan 2026 14:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A066D6B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69CDBC1766
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:21 +0000 (UTC)
X-FDA: 84378735042.16.2A3C62D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4EFF180015
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFjN+VuE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdC4ITwVda0lUdFB5wjfyhrvZbsNw2ij9MPQ4wY5Xmw=;
	b=eYFa9Dp+1sYSSijSAfrmjfvMqLFwsw3/rUL+fgAHhB1mbVAq2k9XDXkGFHDlxBD7hUaPMo
	1l1H7ippunhuuJXRfcVJn7h4bXiVFa2dxt4ZIehi8/czCuzFVGD0v3C4YwyL+m5cnK/0NP
	VIO/AgS4OZnZ+15zndvV37vgRWk/gO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542219; a=rsa-sha256;
	cv=none;
	b=t7Tcqk13DdXf6PLDUKryA+Lk1NisCUupp2K9lK/FDgIxMDdMVK+HuR2KetoH32GPkh3WnA
	sJm8HY4ihG5KhGSKuQyUB9NBugymFTmL4qWpoTccuRQvwFDV1hi43Vzm142EBJ35+ZXgNL
	3wHe4iu9ky+rHk0C4SLHbSoOYRrlKVI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFjN+VuE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8F694169F;
	Tue, 27 Jan 2026 19:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1C0C116C6;
	Tue, 27 Jan 2026 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542218;
	bh=0i1d2fpNNGr7J2FXKMkhDUOQSLx8UrCEb1MMN67S4zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFjN+VuEwQhJBIsfMbC+PmRxi9KIPVJN4uRtNpCoxNN9r9XQMLQHf0SUC/QcdqCdv
	 yTbesD04KbeYLsqu9jsK5VCgiKMXWXlhDdWUti9o3laDuHpqKq0cyQpRIpTuVRDK3G
	 9s8YlgqtFbLBtQtxXOEyaDTUXUdJl17RWcVocISkGcSkSmsU5NvoiKCQikZgy87kFF
	 O8R4uqwxHCNJdejR+L/GTxAWcoaC7L8L3E8vakXLO1fq4oq3POjF84JIKWuCS7CIvg
	 pmavXqI0eF6TLmjO0g1n2PwhdMCDUBPPfgqRUjUwbI3BRxSmDJW4/QV6Mt7Z+eEND/
	 4/xB2oNKKGPkg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 05/17] userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Tue, 27 Jan 2026 21:29:24 +0200
Message-ID: <20260127192936.1250096-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4EFF180015
X-Stat-Signature: qo4cdmtcwx6enz3a9wi1tosczxp4krwb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769542219-877555
X-HE-Meta: U2FsdGVkX1+5PyQZwKqSzFuTNZw5V/Lw86yXa6J9NatqoKm3gas6vBfNZKMGXvUlfHwCNBRLUYCaHtZtveyhJx9BgniqWKiMMXoopjaN4mwc/mQbL9vJKXIHhFw4d/WqO5y5xlONDtSTJpWF87ChD9Lv4gXgu0X/0mjlfu/KxztBJUMTRePMlm2NPN5kwPS29pZToEDCa6lzo7/mq1lu65bbb00co9VoHFTW8UaKVCnXOw9eeCPzUT6AekbuSsj5bDtQh5no5pD0lDSMRjc7G3W1xgN2JawSj/GnN0Kq5LvMr5EMel7cLW9r6FRD41jxqM+/IMXYw9rchpEcxM7hT4FAtLpO4RtBxrjJLhayZBLNUuddLPjzVrBeeU53Km5Atw+0EPTFasqaWd9dgLYMIWLWDJtKWQjG3+lcdzyDyw3imXkDVYat8u86NsrjjiIfiXuYUVDC0lgIeru3fWK3HwPjYgxfttWOoemxWHLWfc7GvAB1Wxz7krnWtliMNEvg9WgfV0GNl/Qsp+s7O8KOZcR7P6ABZa/8ZeY10bYdizp/0gcTf+AfoeFOttr14a42f6SbV0od2G31UPTSuDH9WKPIa9o5BHsxQdFC3QIy1642JDZfwKrb04BiOgI6tJeFGCs6WpufHT1NaxZmVh4pTstPsIq2CoNma7/3MbYcD5fvMBEuKGSvgVC6PsxZwMdcPyOnX5cgsTvFC2VP5ouTykBsGXHQwEV2Pycbwpzd3uE4gJf1naSh3mx5iNfMSzOyBJu5WgwUSo3NrmBNYqo2AegUXXujjeiIjL4eCdfwOGMZPrnyX1b51vWWIp+uiTB7M1Oi7QicSbWlMWZ0k3tj4BVpeO8zsVh7eEh5TcgwUXRLlnUHZm0L7D8+E9NyrA4tHjm260qPX/tdX1DAbdoqQgSX2UOywtRBVepYYg6matAgx8zf3cqhMtfVlU8KZbwo/y0Nsk+DQiiizs/6eZI
 OpdFzID0
 tuq9IiK61Jgg6Yk3xZlDWnbP+r2iRiEGDmRIBDQSE3qni0ygdNg9cZU2THcJH7n+7QI5yH7LN+JqpWc/Wc4INwkimXGC+xtuFIIP3ogwrJjcK+/3A0pZZx2yM7hNQRYNRUM1h/r9cIorKPD2h+0Vx/MoEoOaLUVN4ELI1P3Q20gFaesULoaQeXYweSS7uDU39NQTNnDh/H+ocE7RQrB1zRWk/7xXqxNaiwaN51IjohLVYC4lRRWoPM141QW88GMJOPLLjApYq+tDgahmsG6bJvXxCQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Implementation of UFFDIO_COPY for anonymous memory might fail to copy
data data from userspace buffer when the destination VMA is locked
(either with mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the
data with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it
never happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
anonymous memory.

shmem implementation will be updated later and the loop in
mfill_atomic() will be adjusted afterwards.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 45d8f04aaf4f..01a2b898fa40 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+{
+	unsigned long src_addr = state->src_addr;
+	void *kaddr;
+	int err;
+
+	/* retry copying with mm_lock dropped */
+	mfill_put_vma(state);
+
+	kaddr = kmap_local_folio(folio, 0);
+	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
+	kunmap_local(kaddr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+
+	/* reget VMA and PMD, they could change underneath us */
+	err = mfill_get_vma(state);
+	if (err)
+		return err;
+
+	err = mfill_get_pmd(state);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	int ret;
 
-	if (!state->folio) {
-		ret = -ENOMEM;
-		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr);
-		if (!folio)
-			goto out;
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
+	if (!folio)
+		return -ENOMEM;
 
-		ret = mfill_copy_folio_locked(folio, src_addr);
+	ret = -ENOMEM;
+	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
+		goto out_release;
 
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
 		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 	 */
 	__folio_mark_uptodate(folio);
 
-	ret = -ENOMEM;
-	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
-		goto out_release;
-
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
 				       &folio->page, true, flags);
 	if (ret)
 		goto out_release;
 out:
 	return ret;
 out_release:
+	/* Don't return -ENOENT so that our caller won't retry */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	folio_put(folio);
 	goto out;
 }
@@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 			break;
 	}
 
-	mfill_put_vma(&state);
+	if (state.vma)
+		mfill_put_vma(&state);
 out:
 	if (state.folio)
 		folio_put(state.folio);
-- 
2.51.0



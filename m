Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DA9FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF086B009D; Mon, 30 Mar 2026 06:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77C76B009E; Mon, 30 Mar 2026 06:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66BE6B009F; Mon, 30 Mar 2026 06:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92B456B009D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 533E113B9D6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:03 +0000 (UTC)
X-FDA: 84602313726.18.C337A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9090E1C0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnZmUZP7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865521; a=rsa-sha256;
	cv=none;
	b=On3Psj9Q3BOD2sEITXLQNodXxG3/55wloiJOy2RevS04Jjz6P9pCYnvAafqm5JO8FNI3+z
	6NNOzqqtw8KNbJVTEEqiuc9p6uqyLYf09YjyDeYNiACPbXB7266kvRhJX2fgZYSDuOh4jx
	XL16y9SGjqhutP31FyeZPSDxGusSwVw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnZmUZP7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KG9O15NEX//F7Y7M34uU3bVy0OPGvFNGxrIfN55SF7g=;
	b=C8r9Bi25oq/2fkNiICImLJr1ZDjoi3dgNqxFO0mUC222pccrFDUBo0548CUDt299T6JT4F
	c4egCo9iUIkzBLR1cHT4dgs7iWVMg5/R08VPhEsicIQyUZIHzkfyIbqomfVQZZlvpEk/Bo
	XPCRVzZUphFR0B7a8Y8QlazDWvcJWlY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA081443BD;
	Mon, 30 Mar 2026 10:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500A1C4AF09;
	Mon, 30 Mar 2026 10:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865520;
	bh=5SzGyiFXZk7l7ucReQ40iRkaPGcy2CcX6r/21eMkk2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnZmUZP7gvczpmYCEel4ZXmQ2PPmuQj3/XLGNLve0YawXSP2n2h581cordUCP7K2b
	 MmmnEb7e8DcyW1uRo2AewcgnTOx9blnu4afb+Q6gn6po2hgdRBuRrJswZumlsmYQNN
	 WYGrErDR5bviDJ6dVcSCtl71iYEOnC/KGr//7ne2uRD2lGWNH5EdqFy8ypdTN6NjbK
	 wMigsbkomvod7dn/ko2q+w52YIV1vn+g4FPibveRYXwvjuSLuiL4fl4nvG3oPg8ZBe
	 Vh0YR62YlJQBCLgTH39pGzGix1bhYmhld6ri6Jv3CHDGtgiWE7cMHSiyIKoqN90k+r
	 gOXP70eeEkHwg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 05/15] userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
Date: Mon, 30 Mar 2026 13:11:06 +0300
Message-ID: <20260330101116.1117699-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9090E1C0002
X-Stat-Signature: 7zydy58syzcuzn4ey39exbyoim8ijdpk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774865521-592117
X-HE-Meta: U2FsdGVkX1/hJ3o+kgIPDanquFMTcaJaCm/KEknZq/9pxClp9/qD5j0grHmlcG66yee1kzH4YODxd1cbR3X4bK1zDQ9bH5FRkIprfzsd9g4CRZjSYIR+JMjpT7aWNly19py32bgOksD1b9sslr6rx7mRyRD3P9f0nG8FaU1j2eyi/oGRQ2HTQ2QRADSuEgDi2LCysz8A/SXuWR8kRe5UScM6CBZHYbjMovN/Chht/O2CxwI6FrWf149AuNZWK05+AFU4Ss5G7YcV+Jie58avtCfo0fwkdvaS3B1Qf1AkxNMjiEWSzt5m0JcvixFGAyd14bYPbrGzHWftkOejauUbiD6SgJhDB7ewBimFHWKTuX7a9rgwxkHt5msBsaXl0l5/yozDGtXgaKlmSPIXTQJo4Jg/o35IeZpJmUOHtQ0sd63WOP7zzuTGOVqYjEEDDmmV7rIXeuoYUTce8Q70NPSG36wC3Esc35wyk31r0dQqFnCVO1+6jC3DC1D+sM62lvcxNx32E0ib7Bo/ydBXXxdFSDIaRcY9+ghmEWty+mglPgspKjsnabckkw/be41TB4sniWhgh4rOfi9fyqvOORrrPMO8OaB1NM4STMF0ZERuUkmcS9vS18tDCLnzdmmCFozhU3HdWuDswOsC+738RhcvPcJtHKhTUBm8LYUIhvGgFPdbmSdTXgkfb20PdjEFpI2P5LdGi82r2vVpcYD7hVTxMIH5fgEBjIJb1/VV5mKpYnqPJPR6PhsMZ20tpQVtrdn9uKwMaoVsMV0DCnxonRtpBCVg7ysu26MVb+5VLZEvDcFanYr0esxSK/wGozVPtbPp6Dbt7WR0zTFkqSuPfbGaGH1+vAgrqsJqsKWDl6K1IPGGpHGe6Kf1bd5re/Orf/2KGK4YY9JwGyZbB7QnviVOubPrWuliMthp7jQL9Ni8PbVzRK5Cr44eKdOgZAypB8FeaFFbIYubnSCOEezT2e/
 L2ptNf9K
 kTZV6vIKp55ljKlXyfVJLuwbPgse6+gcWJ21OluNOJSswGp9YKS0cIczqEHF4/xzc8pYGyXXQM5NLs5URb3JEwO/lGkC6i/+l7SVoAYVbvbzhnqOLx1YzTpVZcF1RpBgqn/9kmk9F093B6AbQcOAe1akPKDRsFyabCcKActVXCuRj3eslR4my7DppyvkH7o2pLzKSp2MUns6HLpRNbQWcUyMENGBdbruYUwxXwHzzKDcHJmJDSkf6ZXvTDzcJpHoA3RWhNG/6gaRgzVEdq4Pecxrq/fkk58yybHc4RYYJxY9phUaWoTO0sfGDK6DsQwoGxXTzoyp4zQ6iA9viq4P+bmp18GUjdXZ69ttRWyMKBf8Jn4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Implementation of UFFDIO_COPY for anonymous memory might fail to copy data
from userspace buffer when the destination VMA is locked (either with
mm_lock or with per-VMA lock).

In that case, mfill_atomic() releases the locks, retries copying the data
with locks dropped and then re-locks the destination VMA and
re-establishes PMD.

Since this retry-reget dance is only relevant for UFFDIO_COPY and it never
happens for other UFFDIO_ operations, make it a part of
mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for anonymous
memory.

As a temporal safety measure to avoid breaking biscection
mfill_atomic_pte_copy() makes sure to never return -ENOENT so that the
loop in mfill_atomic() won't retry copiyng outside of mmap_lock.  This is
removed later when shmem implementation will be updated later and the loop
in mfill_atomic() will be adjusted.

[akpm@linux-foundation.org: update mfill_copy_folio_retry()]
  Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/userfaultfd.c | 75 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c6a38db45343..82e1a3255e1e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -405,35 +405,63 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
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
+	err = mfill_establish_pmd(state);
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
 
-		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
-			state->folio = folio;
-			/* don't free the page */
-			goto out;
-		}
-	} else {
-		folio = state->folio;
-		state->folio = NULL;
+	ret = mfill_copy_folio_locked(folio, src_addr);
+	if (unlikely(ret)) {
+		/*
+		 * Fallback to copy_from_user outside mmap_lock.
+		 * If retry is successful, mfill_copy_folio_locked() returns
+		 * with locks retaken by mfill_get_vma().
+		 * If there was an error, we must mfill_put_vma() anyway and it
+		 * will take care of unlocking if needed.
+		 */
+		ret = mfill_copy_folio_retry(state, folio);
+		if (ret)
+			goto out_release;
 	}
 
 	/*
@@ -443,17 +471,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
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
-- 
2.53.0



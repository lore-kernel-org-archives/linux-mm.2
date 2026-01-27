Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBF4D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FC46B00A4; Tue, 27 Jan 2026 14:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504BE6B00A7; Tue, 27 Jan 2026 14:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDB16B00A8; Tue, 27 Jan 2026 14:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9756B00A4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 053B91A01E3
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:59 +0000 (UTC)
X-FDA: 84378736638.13.26B09B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5B70140008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwfokdNa;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qq97hi4sqGbcfgT1ckebpE5yFKEBXCMOPcv/XbXyjOg=;
	b=rYoGheYeuAw4SAr38hKQ4Ycq5Gi0nR95VgBEscebB5Tm5k0xPVZ+h27+lW9LPtrc/rp45L
	936+6KaYchd0d+MaJ5c0BqHInmQZGvAb//P09v2vKGtRpQckOzNqUti7LNfAlexhqFI0Ce
	cZOHI5NIBGQR0WFn8WnJL5kyqIniSCo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwfokdNa;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542257; a=rsa-sha256;
	cv=none;
	b=Q05iqCQyNUcflya+S2GFnFhgkiKaNH4/phRgdjgrn91bnW49Qzr6nr/W/qilhigtUHhAan
	lnW8KTTwRugNpfDp7OK/t6S5qYFMk1vHK3awgCVB6la6/OlF9m4maptW3t0OY6FhMeFNTy
	IF4UQ+byGjkOAPsmddU2q0JV5Vln5Yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91A7A4179D;
	Tue, 27 Jan 2026 19:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A4CC116C6;
	Tue, 27 Jan 2026 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542256;
	bh=dAICMUfnaufCCr/AJKZx+mvFFt/TvpVz3/Hz00SDDT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwfokdNanFjWz8h5LlR+icqZBH0klOoYnKAr1LNi95YICtl63fsrIcY8NnT+EiRGe
	 yWtnqTwr+5yZpeYTvJL+8lRdpKwuDymh+P32EIO7DBV2T1c59DdkBL1R/WUsNWgMjo
	 lwiKT5FEt89BPbSUwIaq5DpMdSJP8rTXn1u4K7DWOR24Jk6vMPpdim08J8mSngmaUC
	 SPR+4MGDgZLIL7Ui9/esE9aoXfCdTxImkuayPuQIrY/yHzrePZ7E3MShe2i3YI3kJQ
	 X9XKKQQ96ySvXVHKpmqecHcxy28t+t+LDSTtQZT/ngMyhyrkh3tbjgj2uPuiHiqjkZ
	 T57CGZrW7YBBA==
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
Subject: [PATCH RFC 11/17] userfaultfd: mfill_atomic() remove retry logic
Date: Tue, 27 Jan 2026 21:29:30 +0200
Message-ID: <20260127192936.1250096-12-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B70140008
X-Stat-Signature: yuy6bibn13hpea98jfiq1ofbbk8r6udg
X-Rspam-User: 
X-HE-Tag: 1769542257-308306
X-HE-Meta: U2FsdGVkX1/nZ3KVt0uq8LVUM8CyQ2a+l7OgZ6AV705eKYcC+JFMxmLT619r7Um+83hQgHcVJWt3Os5yLGxJBpl0UePQY6x/VTi/DMzOu9euASpo2AivNYBCXSMJif2+HDNdm8lvO8JWQHVzBRxWY6/WiSWmZGVxUS7PlJU8um9aCqb4EyAqA33/GKJTxu2SJyq3bh4X6myKi8dTfVvcTZW6iyfSRyHwvVa6DeWiKbvF2DYnpTKM7ndlx1GE1hG44G8nBNMo2TS9BdUlcJmh/5Z6IExoA9+jgasmbg+OJ+7fQILs9+jf+XXdqrQVBsAFk9YpX2j65zH1rKDmJjSKcwrizgZ4iDHsmGvMxUc8Ls+hs6KGEuJM0sTuKjd0Weh2kgbnI1iKvm61VHEJbNzkxXEZFbAaI3eZmXZAZbibbCAtWfohD+Fl/wrutl8u3zdGLWo0jMeQRCwjdSqKsnzDB+Z5F+FmwXNJUMq20uvxe/UicNscW13ePJA/63H5eqFIlhAXTR51yCgrhh4V8ynyQL2sUMOfUL+BEAxYz3Fa67dKwhlqcEEBmuOXK0MKHsSwR/RmNb8s24VytnkKBNuMwTBdWToog6MJrholwPDLPQ/XYy/ITQGzfBfqsk/B4z4sBQyUonmZbFXxZzeARlgiqy2GrXCrz0wnEBQWU1i4W56vocQs5oHAMNqNSJ5So+pBODEqRBZgD+wclTYgVAngPsFn4f/UiXihPO1MrPPXhlizPsA1urzUAOEvlSfEQI/F8pOtB96Wp84W7cD50Z+m3xeDsUa9suZIBntYTTB8uHE4tmqKnLt+WK5LAjE3oNGbU4ceNH/PUeXS5PNPkgm5Ho2rBpEsZ+gjtCVGy0bE7YqIf7+5wO1bmI15TH1bXCONyamodGGMxDJOt9dka6wrhGkdVx4XgB8TTpgRO0SCTWQLW81ihEuKAW8O7gBttXcdHAqTIx+IrrVEzqxHD6l
 01H7SGvg
 0RsV1520RQRbwxqLmKN1fnHZPDSCmdpqsyDHHgHRGCgNhFwtz2mvfhJMF2zWV9dpzSUmMm9cFJOKEdbDqAS9cdtnmcdvUzeo1+n3bC/Wrq5yaaU/bIDD43tt0sPxd5g5tndkuJBmS/JmSeFgLwDZqcWItb1nuU81f51RZxKYIco/ysaDDgJWb9kfK0NfeFk7LRdyAQhk1/0f8UpHQFbuogWpE+sG6+4Zr2WHLWHJl5f0hl6FFzqJWFx2PmkPD25l1CvPA4lHoc8uAIRo6ky/QlWJ4jN/h7XwlNWZsa3aTJJ/zY4LFE4iVlSdtl7wZXIrPDMZg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since __mfill_atomic_pte() handles the retry for both anonymous and
shmem, there is no need to retry copying the date from the userspace in
the loop in mfill_atomic().

Drop the retry logic from mfill_atomic().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 54aa195237ba..1bd7631463c6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -29,7 +29,6 @@ struct mfill_state {
 	struct vm_area_struct *vma;
 	unsigned long src_addr;
 	unsigned long dst_addr;
-	struct folio *folio;
 	pmd_t *pmd;
 };
 
@@ -889,7 +888,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-retry:
 	err = mfill_get_vma(&state);
 	if (err)
 		goto out;
@@ -916,26 +914,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *kaddr;
-
-			mfill_put_vma(&state);
-			VM_WARN_ON_ONCE(!state.folio);
-
-			kaddr = kmap_local_folio(state.folio, 0);
-			err = copy_from_user(kaddr,
-					     (const void __user *)state.src_addr,
-					     PAGE_SIZE);
-			kunmap_local(kaddr);
-			if (unlikely(err)) {
-				err = -EFAULT;
-				goto out;
-			}
-			flush_dcache_folio(state.folio);
-			goto retry;
-		} else
-			VM_WARN_ON_ONCE(state.folio);
-
 		if (!err) {
 			state.dst_addr += PAGE_SIZE;
 			state.src_addr += PAGE_SIZE;
@@ -951,8 +929,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	if (state.vma)
 		mfill_put_vma(&state);
 out:
-	if (state.folio)
-		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
-- 
2.51.0



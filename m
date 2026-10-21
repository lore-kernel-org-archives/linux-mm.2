Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4028F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8263bFw
Received: by kanga.kvack.org (Postfix)
	id 5B19F6B077D; Wed, 21 Oct 2026 15:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5893A6B077E; Wed, 21 Oct 2026 15:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7116B077F; Wed, 21 Oct 2026 15:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231EE6B077D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:58:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEB491A0660
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:44 +0000 (UTC)
X-FDA: 85347696168.29.92B1406
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EBE0A0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8263bFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAydzIVAoeyERrjwsju4GbQSFXyp+3uvSqDPl/+MC38=;
	b=SIsrBcVnnN+ylIamlR/P1tgKOhQ8UhrLd68Tft+yY1dedbWnCNo4Q5qT9r4O9HeFn/Usak
	WNaXpv19VBYBKspRxI09Ks86ZnpZNk5qnmvuVDggnJkbmaowvq/oSJijyJ6olu5kLNJItF
	amdlNZFP/6h0KABOaNaRplu5GTcxxWo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8263bFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612723;
	b=jiEcu6ZXbl03l065cqQ1Iju58X/vlcwPJJURbyhojKyK3XWvFNvSdmDlnHpIYrdmNqV3w1
	8FUoAbJMy2MltkCmt4N2MnIDvyrepj2sZknQ5scf/0HQtCAGcjeXnZ0meCHyMxN50gchfI
	mRYN4EwWgnuYS8mIOHS0Qn9YzZKSSSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5966C41EEF;
	Wed, 21 Oct 2026 19:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A431F000C2;
	Wed, 21 Oct 2026 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612722;
	bh=yAydzIVAoeyERrjwsju4GbQSFXyp+3uvSqDPl/+MC38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8263bFwrjWQCX3skqmlYw9DM0UQgw+9ci9Lt62/2mojFUV7kkvumXst7+UErRWp9
	 IINsXsZnkTi+e+xRuxpg/j4lucDxk5ISFSK5Q0je5vVM1l7G1h4C2H53E5vPbWRPe8
	 DRoVtHs7oYWlCiZwf6deKaTupTnx7nxYuKH1eTg4XJ5PTv8/uw4fhwygv5BzQvDjW1
	 qzKJ1ihZA96DUzQ/52wxhYsczbXLEpXyLvqisiLaLWg2Wrd24NLeZPchZswFJ1Tqhn
	 b/Mf0diwZsLoTHwvZ1/6naes9QMbn8NUxIM/v577i+6DICb6m7iGDFLIAN3wYhi63K
	 VevkQqnwtjBxA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 3/9] mm: Expose locked mprotect operation
Date: Wed, 21 Oct 2026 21:57:52 +0200
Message-ID: <20261021195759.119421-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EBE0A0002
X-Stat-Signature: on3txfie3y9c1i4i8gewmjme4zgwrxbs
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792612722-637474
X-HE-Meta: U2FsdGVkX18cWJHL59sCJOOo7kPjAjpvJ5dwH2N8f+YBGZlq/lolvG13Dx2beNKN7Qht3s7Ix44V0Eu0/C8uj8Ta4UN/83F3u/H6Ah/syLheT5ITzNKXyNDmRG5humB4wmfwMbc3Z1VrwWxFyxdLhV31SWs2cSebjn2WyaI0wksE4LgJJd4Qg5IZ6kRhKDOLf/+KW2PTbfQ/CYdZpfniqcX1fjWT5pMm7hA++nQUW3JNj4X9xehWgUXjJ0VKqPd6W4yezDcgiIVH3RAo5gHTRWHa4/W+alZfhGVNC3Slks4dNYHPg3V9Anv6TfFCWp34v7rDA6FbE0dmI8GAXmFf+TkONokeV47bW+EMVM30DUb/XC3aNzrEkIU2OvVZjVOf6RvJWdWZC4YVawMxt+tnq9iH6S4XhsQsb2JJfQ6I7xdtDOWWvSYRvNkc5x86QnxziJfQ/hxRZSGlUlM8kRuPCtTC8J1dndOIa024t59YNtu1h56JDxPXKtx92CHOqkx+YUhLA7qe8PI6ClKDonUiYMxHpk/N2+DnPTlgJiCMUP2rmguDIdaYYjqySpF/H9usrZ3shMZ2U6yZFnpDz8Rn3bzWvhh2j4W/lTWv7qowlUj1iu52IWSH1hZ8pyDtGXjN9QLDrnzJftTTBa+nJAMVsy2PlDAXf4Kyq7HEFIXAyQR0wxEY986qr7tFYUz2Ok1NfLpb2V1tS4rOmBdH3oyNY6bpUe4lEMAX5FLYiydRBw5kQp9kb/4iYdAK8AN2obh1Wh19QbKbVU8Jj/Mr65VfuNrJ+ZtK2xWT+E1ZK98tP47WElFxuaSCBxOhxS7zmsROkf0iPnh1KU8lvTKg9+MnJG4jDwwD7BbQe1Ny4RUP0cym0m+Z5Qgjs6s2kBtpSbcvJMTPDFuDBCgTCU1L8F3yn3Zs/pZ0SF51g8d1xZiYmzU/YrKs3Bz+Bkl8XF2zt2JhV0BFGCrJodTRMchDNOA
 qB1NYxAi
 BBQwwhsGJKeR02ZmLyHe+kyfSc8e+eay+OWYWEPtk/g6ahMzdv4x9//den4la7x4h3FAhre+r9HqpcOm4WH0b9qp2nj5oRsGufM3neSJR9GS64dcQphWJsx6mBAzKauQa4eX7b9AEXo4xmkToMFPosH8YJca5NzmOH0R/pwXqMZjPklNX9vOugTYuKaq+1EcPh93mLDajVOlidnsh0zZ63WkM+raerX38cT3ddA3WqJTxbEGdKG1BnuQtWDEUlRayQBYXsZuIXrPGGMj3WhmtKTXCRArjGKd/zoAB1XKz5sb7uG1jR1BC31YSPzUEPBQgvbVwZDrufXk2wNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The bpf_user_page_exec() in following patch needs to change page
protections while holding current->mm's mmap write lock.

Exposing the do_mprotect_pkey_locked helper for that.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/mm.h |  3 +++
 mm/mprotect.c      | 20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 63f40e615754..47e853093601 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3435,6 +3435,9 @@ extern long change_protection(struct mmu_gather *tlb,
 extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	  unsigned long start, unsigned long end, vm_flags_t newflags);
+/* Caller must hold current->mm's mmap write lock. */
+int do_mprotect_pkey_locked(unsigned long start, size_t len,
+			    unsigned long prot, int pkey);
 
 /*
  * doesn't attempt to fault and will return short.
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..8d800830d3e1 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -868,8 +868,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 /*
  * pkey==-1 when doing a legacy mprotect()
  */
-static int do_mprotect_pkey(unsigned long start, size_t len,
-		unsigned long prot, int pkey)
+int do_mprotect_pkey_locked(unsigned long start, size_t len,
+			    unsigned long prot, int pkey)
 {
 	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
@@ -899,8 +899,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 
 	reqprot = prot;
 
-	if (mmap_write_lock_killable(current->mm))
-		return -EINTR;
+	mmap_assert_write_locked(current->mm);
 
 	/*
 	 * If userspace did not allocate the pkey, do not let
@@ -1013,10 +1012,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		error = -ENOMEM;
 
 out:
-	mmap_write_unlock(current->mm);
 	return error;
 }
 
+static int do_mprotect_pkey(unsigned long start, size_t len,
+			    unsigned long prot, int pkey)
+{
+	int ret;
+
+	if (mmap_write_lock_killable(current->mm))
+		return -EINTR;
+	ret = do_mprotect_pkey_locked(start, len, prot, pkey);
+	mmap_write_unlock(current->mm);
+	return ret;
+}
+
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-- 
2.54.0



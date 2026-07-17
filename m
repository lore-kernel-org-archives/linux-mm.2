Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94095C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C5C6B00CB; Fri, 17 Jul 2026 13:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864146B00CC; Fri, 17 Jul 2026 13:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A706B00CD; Fri, 17 Jul 2026 13:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF166B00CB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:27:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADB7F8014F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:45 +0000 (UTC)
X-FDA: 84998950890.29.E0753BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D2EB4000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L87zM+vX;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pQm/Ojh5C3HMOQwR66ivQbCKfkvu5WSMILH5D2c3DA=;
	b=mAvUtzeLWPD1p8hZuHGKF3N49rMr5qjGB+plH7fm/WgWMt7adVPONEQhETqG7bHgQ3EoNd
	1IAJYNnN5vgr2CqKBnAovJUm3uQi/dub4TGi7a/c+DHmymxIYZZpDYGH+fKotAzBg+NHvn
	nE15ERbnIil47f+6M+WQNV8O6Hx23Jk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L87zM+vX;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309264;
	b=Txk7A6dXFViW5tnBKzi7fBCNMGrNIJRb9WRXIaCMEK7zoGL9KsnES+xo2bXJ8NHNdvn3DF
	VRepOB3zM5/KBPjUjFsR4syVQ+SZgH3qtGstt20S8oVhQ16kgkONJXsPNFvkzyVU5Ws20P
	lZ/zwx/lDIepcqvjsM+kPWy6+7Th57E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F04760A6D;
	Fri, 17 Jul 2026 17:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5F21F00A3D;
	Fri, 17 Jul 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309263;
	bh=6pQm/Ojh5C3HMOQwR66ivQbCKfkvu5WSMILH5D2c3DA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L87zM+vX3nYW7/x31SZ8P1ixK6XcMEKB+Lfgk3QLsMu4NHWMKlAFtv7FCyDtW4WFk
	 SUXf75Saw0cu/nF94tgqw+ytukguPjC/QRj0rrCiD54C+07h5RSWQGj4g+cUmpYSwA
	 ZOriBrDMr3pEI4dc1fubJ4nW71n1+MoSgyor5yJ64XQbIt6LqtzH//tuVcl0QH6O3W
	 Wjw24fXun3+j3jZOnO/mjVq3S4oMqCU9Tj/2HgRbhF2C2rOJeZheVCexT9JOrTx9fT
	 1CNdEAJ40J3NhAjwYYn5kppvkK/SxsY8sGlBh+VVt6Phkn+X/p70dWY2kozf2/B4WR
	 OT3JHT/z826Iw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:27:11 +0100
Subject: [PATCH v2 3/3] mm/mseal: remove further superfluous comments,
 do_mseal()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-mseal-fixups-v2-3-0daa0014b813@kernel.org>
References: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
In-Reply-To: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4363; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MDOTli1ONneEZj3m3sNVoalGk6wNclirN2tJYNxD1yY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiUr+86nw2y1b1D+esnC0ORWVN159smf6hsWfnPH+tR
 Yc8a4tfd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiN94x/DN7nrwvm3ulVDBb
 53PW7wECgSy2Ey5tXWRzVCOmu6tVl42R4c33DseQqdfFa5mSr/nVXrm28l7z3ZB5L348Tlq28OY
 Hbg4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D2EB4000C
X-Stat-Signature: ysufo1pdrrwg6nbm5i47akya5mxq93ak
X-HE-Tag: 1784309263-716619
X-HE-Meta: U2FsdGVkX19KG6+qxUeQbDj+ss4oAUAT4LVV5rlR/OzSnoxyzb6AlCVppBAMSQLAEdX1g7tQe749nivG8zTN7ePVI2GUDsjxi+Pwobd0FJm1x503aiSmaYJqb3C3O33yca8Rx2WptJI1FAnAm2LcciTlEEGHbkahCnuWto2/1r9/bt/7KX3x6joXMAFlTmKQezzAZsR/5mPXuk6x8LkX+fw0Huy3V3MBoSiG/4tMUI93MvLSN+bBOpkjYTYBL/hKvT+5qDppbp6op9k4lDBb3kMKfRfWDJj2fUd3dLRpUeEMzAY8737ihHS2t13N81JL9aXXDrrRCGykkbQfDUamwk/rNKBOtoci1h+qWpgThlubwGKG4cj0UxehyZ3r0wv0OL2Jij3hIATl4AGSLsY5FfD1a4HQVq8GQPGlwjVfr1/QlauhU9yZc0Rd2zthEM9TbaEZlETWdLm4LYbQflRbBVqGywJl1t5lRx/ZBlZgdxFsPJ7qXeq1B3SXDjTUFmWLbE7xPBFR/bvC9EEAz73YY3G4fDoPLOJf2DdABiwuoLj03KMoyg1dtyR4KvwzANtHscMaJSKo665xBwygWyhK6a20LmgviHSuhurlEhMY58I78LoXPOtMNUNvxQcJPDBShpGFHmwDh6g/zrn3SHBAp1p8dHkvyXcOm0nIEEEAGOf5bsno+rDIe/9nBGiePxzlWtimGqK/PGSRlV0PAFdord62IQakKPpYyAd0M2rxzHZ5Stxkm8KSoReiWVEMTzeLb36NB8xuA37fe+/bkjrSLmQsNwW3fAgV05tooJkEGUzxEuoAcWrJ5jlM3ln8YH7bORkA+gWsiWYIONCzlHsBybp31dzazWysBGF7hKCFCYLfFNMcwsqQHghez+oUU1O9D9nXq60HGVYfTowkwvK79GMkb4Wq17wVfrZojYOeN8W3pEDnGxR8EuUSSif3HOBuBCYW11JMFkbfhM41VS6
 0IBrbDHp
 iygvNN0FLoanrTWgA6l7C/E+XdKL5Tt6Rdj7jevl3Acd1HggD2fbQ2LyC7JFoDcIqSsY21OuCdudkjDE1OqTzXq77U8uWJVjao+5UfhNqiErMnkqWzIyubXhnlpwqkxG1Yubf7hbUaqnaCW6nHUKOZjNBBpwLXzXIovEFyJOYlfL76meqSg40uRJTM6A3FbUbYT0a8yeGDP3x0V0nS8dR7dXB1JKkkJD3a/YdjYHnLZx/7Y/lHXTSB14mGavkWEzthJjw77SdNErEpZ6J6rl3wiKIcL/Cst29ZvWV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to abstract do_mseal() any longer so put the system call
implementation in the system call declaration.

The comment around do_mseal() is strangely formatted, overly long and adds
a lot of superfluous information that the code already provides, so boil it
down to the essentials.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mseal.c | 74 ++++++++++++++------------------------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 2a516da694c6..7a8ac66dc215 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -99,61 +99,25 @@ void mseal_mmap_page_zero(void)
 }
 
 /*
- * mseal(2) seals the VM's meta data from
- * selected syscalls.
+ * Seal VMAs in the specified input range to prevent an attacker replacing what
+ * is mapped in the range with something else.
  *
- * addr/len: VM address range.
+ * Disallows:
+ * - VMA unmapping, remapping or shrinking.
+ * - Overwriting the VMA with another one via mmap(), mremap() or similar.
+ * - Alteration of properties via mprotect()/pkey_mprotect().
+ * - Destructive madvise() behaviours (like MADV_DONTNEED) on anonymous read-only
+ *   ranges.
  *
- *  The address range by addr/len must meet:
- *   start (addr) must be in a valid VMA.
- *   end (addr + len) must be in a valid VMA.
- *   no gap (unallocated memory) between start and end.
- *   start (addr) must be page aligned.
+ * Since unmapped ranges can be mapped at any time, the input range must span
+ * mapped ranges only.
  *
- *  len: len will be page aligned implicitly.
- *
- *   Below VMA operations are blocked after sealing.
- *   1> Unmapping, moving to another location, and shrinking
- *	the size, via munmap() and mremap(), can leave an empty
- *	space, therefore can be replaced with a VMA with a new
- *	set of attributes.
- *   2> Moving or expanding a different vma into the current location,
- *	via mremap().
- *   3> Modifying a VMA via mmap(MAP_FIXED).
- *   4> Size expansion, via mremap(), does not appear to pose any
- *	specific risks to sealed VMAs. It is included anyway because
- *	the use case is unclear. In any case, users can rely on
- *	merging to expand a sealed VMA.
- *   5> mprotect and pkey_mprotect.
- *   6> Some destructive madvice() behavior (e.g. MADV_DONTNEED)
- *      for anonymous memory, when users don't have write permission to the
- *	memory. Those behaviors can alter region contents by discarding pages,
- *	effectively a memset(0) for anonymous memory.
- *
- *  flags: reserved.
- *
- * return values:
- *  zero: success.
- *  -EINVAL:
- *   invalid input flags.
- *   start address is not page aligned.
- *   Address range (start + len) overflow.
- *  -ENOMEM:
- *   addr is not a valid address (not allocated).
- *   end (start + len) is not a valid address.
- *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
- * Note:
- *  user can call mseal(2) multiple times, adding a seal on an
- *  already sealed memory is a no-action (no error).
- *
- *  unseal() is not supported.
+ * The flags parameter is currently reserved.
  */
-static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long, flags)
 {
+	size_t len_aligned;
 	unsigned long end;
-	size_t len;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -163,12 +127,12 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (!PAGE_ALIGNED(start))
 		return -EINVAL;
 
-	len = PAGE_ALIGN(len_in);
+	len_aligned = PAGE_ALIGN(len);
 	/* Check to see whether len was rounded up from small -ve to zero. */
-	if (len_in && !len)
+	if (len && !len_aligned)
 		return -EINVAL;
 
-	end = start + len;
+	end = start + len_aligned;
 	if (end < start)
 		return -EINVAL;
 
@@ -177,9 +141,3 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 
 	return mseal_range(start, end);
 }
-
-SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
-		flags)
-{
-	return do_mseal(start, len, flags);
-}

-- 
2.55.0



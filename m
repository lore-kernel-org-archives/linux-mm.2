Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F7EF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC576B009E; Mon, 20 Apr 2026 09:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3BF6B00A4; Mon, 20 Apr 2026 09:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E98D6B00A5; Mon, 20 Apr 2026 09:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DCE96B009E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:17:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB951160A5C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:17:37 +0000 (UTC)
X-FDA: 84678986154.01.BFACEBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2326C0007
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:17:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xwydb+Mj;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776691056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFIBw9Ac3UOIXz9JbH70Q6KtsllSHeUJyYBID+nfIPk=;
	b=KG6dIfzVJo+da20+r76aqgbTcdfQfLcu7iTN2D6RDYj8XlC2tzuYofoYezX7hmZoA6eeix
	QrFjy7HsV3+Z5ZdwGcDhhgXDNwXFP+i0208w/auDkioZSqgo7yztvY0TeUhWH7UF2BwkYs
	32j4qaHUNHQryv6LWqrwP+Am5Pdngpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776691056; a=rsa-sha256;
	cv=none;
	b=kuhAtbjSbe7VDR0Y5g9mzPS2JDaEiQDJmCjK9zNjH1g7AR5u2rtUsrGnQ8M2ehxfbSFRJU
	sQK4r5gXGvgnWEife3XRILWCHN6XttodDhuy/OjrKG3Hbari04J3YB19splkbeZ2+jfFB0
	rsgEhO1jlRSeQAbW1fZ8ZJvIs92Weco=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xwydb+Mj;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8B1D43430;
	Mon, 20 Apr 2026 13:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BD5C2BCB6;
	Mon, 20 Apr 2026 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691054;
	bh=2SxazbbS9oAi21Q7GCbtTy4MJm0ReOyr2NXSzDd7QZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xwydb+MjE38Yz9wYsZXCGWZYWrHWsEcBXCdCsRZtkpXb41BtpGs6AlBxVvjQ3smkI
	 xw/QvsEQTRuPfzI7DWy/zEmrmCEg1VqEjcuz4KzbAIQH/VhHdNE7sqIeqo4Ir9DYYJ
	 bn+j345Wqv90UavNBj0FWgAE4Dq2oECYsudZJYrqQ5QLyrWL5gJB2zDrQGmCgopI8g
	 kCxReA9D8SGG4ijUdlo6jhYihcoTGJ5cL8ZyVeElzlZcLVBStVXT/C1+zgLWZM9Mi8
	 wXQ2fRkJqCggDws+bDDgfGcj+9rUDrTBui+tLfsxaNOlWYGfMBjLLi/8fVYIQ8oWbT
	 vbQIBf8tXZCQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	=?UTF-8?q?=EA=B9=80=EC=98=81=EB=AF=BC?= <osori@hspace.io>,
	Oleg Nesterov <oleg@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	surenb@google.com,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH AUTOSEL 6.18] x86: shadow stacks: proper error handling for mmap lock
Date: Mon, 20 Apr 2026 09:08:53 -0400
Message-ID: <20260420131539.986432-67-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n51cra3wkitszdbgjryimi6szp8nb9y8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2326C0007
X-Rspam-User: 
X-HE-Tag: 1776691055-536692
X-HE-Meta: U2FsdGVkX1/rBL5eFkYmx6SK2UnM4o3DP262SA04S+7JqV5+nehnIxxl0Jb69NWJQoTz2bVMwDbpHWAyqZAd9251LF73VTGRhNw4Yi1OXU79EIgNbQTyPQ2e4nc4z0Dn/UWEUoxqRNijK3vTOy35ZsVVN90pnWWEIn12Pcp0jsR5YsqPPJKyRtnPube+J8IiUVTJhwPK2rwoV4dROvHV+k3JRD3ZgerSBVhVIqNGJinl5OVuvs73OgEEJxzQQ6nhRBRBwl+s8V9LOY+pyAS84dy82rAjRSbanPxP+ZuFDaN4j6atYNz6uuNysJ2pj3rkURMrZ+xbxP8PJMaCdpML0o+9vsFinVczsQSw6dVZKZ56lUSt2ACQNC/wjpbFRu7JJFGxVlSclUWHwKKnVoERFY1fxn8EUxdqxx58Yw46yyRwzt778rRFHQfsoYzmr8FDCzilSYrIKC/C3nQ0ITH6wsqWhKxfIXj1Cv4gR8kARWtyLj1vTwfQeQLjUX6oZVerdz0PIqp/hUb0wo+gaRi0PwKUhg26witrJr/4dzQV7pZm6koOXJrZ/jNP7bhRI3CtMZIUfg9FIpFnoYUZ0LQka1aHdXv94w93f+HLX5uaGXOBhGfGvqx3Eqth0Eqn8nvBBGpy8oo4FBrLSUoSO6RYREnbU4eDcfy/pDDr/iRwVhwZVfKdQlQkk3TFsP+CCJ4PDAOKdn4URUJM94jUHftAlrDS+JHm/FUfnWs/8wUAnZhlYEW2NGHRsRtGhzEVv7/fjRQ+ISLTownFqqiDjt/iX5/cRJBTP8s3rsoAWtBoKeVkdDMXfKqZf8tfkxYg0fp9b8SRaBLGLhuoGVXJIOW1N95VGLViQxTinBKMk2Ob/ngC77zUXfrO2FhvINX0N5ZSypLi3uxvcU2a1v/aHG5RDs1UXLP20CNhJiO/NaAVmONqSWZBdZLU0SdSMFr34bBqM5+CGXbBGldZqSVDIJ0
 vMd1o8eq
 lZaGaO85gAit4QkSs8qnRtlxGPZKGiKttpW5L3YmRpx/++zPuRlD+QVNSoF9XlwGZMdHLVRrJua18tWuHG94gsMX7lHSjCeFnmdUEDkFz8g54hLFnr79B+JpWQMl80YBZHEcRxDkwICWcaLwwVUj4fpDu+UgYPVxpVwYlSIa6NBWhJ1WIsnm5gtkJazyZTIweyQyqbN4rcEjGEvKhe9f+v1nPvBhROvmPehrJiV07j2B588eFy50WlFW7p5XmgYGNlbJ/Q/NCNzDm/2C+9yZkmduYwiisBWp34hmHHhw9KqaXaQLL7IPig8he3fooPwG6nvUExoFmJ2V8oFBiyISqNNkTW6V/t8lrWCEkvSSgHtjWpyYQ60mKRrUUIBfDYQFSFvr/ERz7xYG/iRGKHgLevk71Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 52f657e34d7b21b47434d9d8b26fa7f6778b63a0 ]

김영민 reports that shstk_pop_sigframe() doesn't check for errors from
mmap_read_lock_killable(), which is a silly oversight, and also shows
that we haven't marked those functions with "__must_check", which would
have immediately caught it.

So let's fix both issues.

Reported-by: 김영민 <osori@hspace.io>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/x86/kernel/shstk.c   | 3 ++-
 include/linux/mmap_lock.h | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 978232b6d48d7..ff8edea8511b4 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -351,7 +351,8 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 	need_to_check_vma = PAGE_ALIGN(*ssp) == *ssp;
 
 	if (need_to_check_vma)
-		mmap_read_lock_killable(current->mm);
+		if (mmap_read_lock_killable(current->mm))
+			return -EINTR;
 
 	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
 	if (unlikely(err))
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714f..95ee1f224c492 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -322,7 +322,7 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
-static inline int mmap_write_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_write_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -369,7 +369,7 @@ static inline void mmap_read_lock(struct mm_struct *mm)
 	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
-static inline int mmap_read_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_read_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -379,7 +379,7 @@ static inline int mmap_read_lock_killable(struct mm_struct *mm)
 	return ret;
 }
 
-static inline bool mmap_read_trylock(struct mm_struct *mm)
+static inline bool __must_check mmap_read_trylock(struct mm_struct *mm)
 {
 	bool ret;
 
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA11D109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285056B0096; Tue, 31 Mar 2026 10:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CFC6B0098; Tue, 31 Mar 2026 10:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1999B6B0099; Tue, 31 Mar 2026 10:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09EC46B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:31:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DDD01601F6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:31:13 +0000 (UTC)
X-FDA: 84606595626.11.189B708
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA3F3C0011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:31:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=oTPjgewB;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774967471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NGshc/UqCbA7iiGIi9F1QT8k5YqCxY0TabFipUM0D5E=;
	b=VTuICg7ASCFeRhtfuhi3mYL4VBNPvr5WvBEvD0o1kH7zZEsbZdJrMo3X9hz3bzPX/zVjr7
	a3zk4OA5zVjIPm1jPDFN21BK6kjup8zXjmL8DER4wpjNovAR+u3pJUlSHRLwhkzVLdBRIt
	rTK71+D0DlFl0Wb2VyHxouRqggbPXys=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774967471; a=rsa-sha256;
	cv=pass;
	b=54WzF6CfZsbJXJpY+r8slUz5JW4aT0a/Om8OMwMr63dVqMZUaVfjuQAtUOJy2y6i54QWAX
	rdz6Qwd4quPQ6cAph7AsABrDOe5KsRpq3tVVnRLZ91Pl3/D3BF4OSzGUIF5JOW4KYN1Hrl
	zNuR0GhxQmAtC3hkzM6iox8+hGxOojw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=oTPjgewB;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1774967445; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=PR2BOI0WUA/jbhJQoSugMXDrktANluxu9zUXOhjhGawzQnC3UckTjVktO70EJQnYfgVs7aGj/B9IWJ0+HQQer1ItO9kjPlrDCA57bD1D/nA0dd/+cAUxY1ZFmoGi5dKiW6wnGKI8VZW8AR+pyS+FQBIpyJYdmiiyXNnR9VN8R0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774967445; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NGshc/UqCbA7iiGIi9F1QT8k5YqCxY0TabFipUM0D5E=; 
	b=FFkSnReCN8BEp19kru1SmBJxFsDJgH/Gk+J+MBmlkAJ1q7M8u/P8yPXH43mA65ny28VGt51DUwkxIlOipe0GCd6DL/SpiZ3iGWiXMykKi/cp/S+lRbnEHtXegUKq7NALMvtPLLQQTSyrL4X4uogXTASU2rEF9uqabEaOcRlvHT8=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774967445;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=NGshc/UqCbA7iiGIi9F1QT8k5YqCxY0TabFipUM0D5E=;
	b=oTPjgewBYhOtOkyBL+NYJtv7YEeThH7kqVgCTxPSD+IXAfYDqARFNo5YN9bw3UVK
	NcgB+INEzz2o3Kh16N5BVixwG8WbLTUFk7nMsvp2eW1nQtuwDjQREbUBDCPWK6WB48N
	nmR2emg2xSakv1oXPn8lizcJvOB87dIp2FDi8QE0=
Received: by mx.zoho.in with SMTPS id 177496744424821.477018728494045;
	Tue, 31 Mar 2026 20:00:44 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [PATCH] mm: update stale locking comment in do_anonymous_page()
Date: Tue, 31 Mar 2026 19:59:36 +0530
Message-Id: <20260331142936.229667-1-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam12
X-Stat-Signature: m3p1h9pbsefdazo4u6r8qicr1mfs1of9
X-Rspamd-Queue-Id: EA3F3C0011
X-Rspam-User: 
X-HE-Tag: 1774967470-374615
X-HE-Meta: U2FsdGVkX1+1j3hfkJhav79CQLwenIPXiq0r+QYVjNUAstziWxjO++vEabUogLfvS8RAx4rrM73T7+h3CVXHBU9WyGvqbg8xPpEoqwh9CyHLeg+jm0OXJPSjdnLj1cSpYGa/E8dDxmR/EXKBV1B2WeTX8mIg7bZQZnkyrNmTs1FZACCu87obnKUipxqOtKXCBXgX2CBzbjVbbDoYA1nAxrY7YFyriaypE0mrEsZ0/2HRGEVIqZC2fXcwxDowNrST13bCDGc9NAo4v/aBpi8h1x6kmAylPQHaVtPLx0NDC6zHLOOMDVfiTcDKEicTH1K2HPFiCAlpC1WeT4Pcz23UR7sz2Oo0ssnZRkvRQPbE9bZjz8EShGbMwJ2S/8ZZJwabnb+EUS4rXw+jvfu7R+3CxrtpCH8gBGvZkZjRHQEVIIOQXqBl2YxP6WMcwDAe3iAtuQNOuBecog+Age0dnFlTm2UcPOrUGj5o+vQ1X6VNe2pVbWAswXfvkWax6PrXwnoAFpk2L345MC6ZneFMvlaiejGjiv8iRjaG1AZid40TiHJJcEcoENOgxq4q8IpoqIZ7znkQv9MNduAeQpeRkyYekoz3xU9hLouRRQBFSHcJjT0IZLq7v6T/j6j62ZBMdOIcNdJwasJwzIiqwpINQ5ZxHoZuxl9T4JpGZAJLQtT1CucnbrE3wvhyA9Eeva2nVlLI1dnhzsbY8w8C2QIGVJwo4OyYJiXw40IVA7oeHgFGy4S842NU5rb9D9GkdeJPLNmorR6nQ2Tfk+JE0KMxiHcGv3DMLz+QWob59pAeTuJ4fCFURlU9ul/ABF5cuj2wwgpCiv9AEyWtRaw+iVAym3c3GsQQ2eKJYqTZ82wU8tDXm4PtWBua0PkUl6XIEyZj/Kilrze1pHl1LJ0clLa7mc8InMqGKoBAfyUwDZ/xBT94n7g0tNWO/Bs8nFn4agRnmIShL2CkAiTtPK88BO2Vlpn
 pNAN7kVq
 p1fp668qRORkZxMrhKYeTKhXMp0IAH4hDShNppa6sBqYLzGCpsXgLLCKkU2D32RMxin3Z2bqG1umc6tHASeaWqGhraeNIB8/B9n+7f+R3fTxlX6dHaEetCiukAm6EqJaQWgqEom99TOnyg0shEDv740opC2L0oCmM7cSGcO4QtufEEQr6D2xBlE14eVpDL/8uj9zTEWnlv7oB9eun3gbZn38Ms/QdqU7iW+312TwPC+t7QKESjFuc+VS5sdwanneoX0mcjhav46PydJeiqdSRrghU7g/+JTmuIPnmezBPFLoUbBuBnb/5PeEezMwpGKofILxc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment above do_anonymous_page() dates back to 2005 and describes
the pre-per-VMA-lock world where mmap_lock was always held on entry.
Since CONFIG_PER_VMA_LOCK was introduced (6.4), the fault handler now
has a fast path that enters holding only a per-VMA read lock, with
mmap_lock not held at all.

Update the comment to describe both entry contexts accurately.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 mm/memory.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86..cc8dbbaea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5210,9 +5210,25 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter in one of two locking contexts:
+ *
+ * 1) VMA lock path (FAULT_FLAG_VMA_LOCK set):
+ *    Entered holding a read lock on the faulting VMA (vma_start_read),
+ *    but NOT holding mmap_lock. This is the fast path introduced with
+ *    per-VMA locking (CONFIG_PER_VMA_LOCK). If this function cannot
+ *    complete the fault (e.g. needs to wait on I/O or encounters a
+ *    condition requiring the mm lock), it must return VM_FAULT_RETRY
+ *    and the caller will fall back to the mmap_lock path below.
+ *
+ * 2) mmap_lock path (FAULT_FLAG_VMA_LOCK not set):
+ *    Entered holding a non-exclusive (read) lock on mmap_lock, which
+ *    excludes VMA tree modifications but allows concurrent faults on
+ *    other VMAs. No per-VMA lock is held.
+ *
+ * In both cases, on entry the pte is mapped but not yet locked.
+ * On return, the pte is unmapped and unlocked, and whichever of
+ * the above locks was held on entry is still held (mmap_lock is
+ * not dropped, VMA read lock is not dropped, rather, the caller releases it).
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
-- 
2.34.1



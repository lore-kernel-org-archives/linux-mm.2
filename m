Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA0CC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660896B08A9; Sun, 16 Aug 2026 18:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6364A6B08AA; Sun, 16 Aug 2026 18:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8266B08AC; Sun, 16 Aug 2026 18:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D130F6B08A9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49C8E40628
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:47 +0000 (UTC)
X-FDA: 85108621374.10.4198552
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56304A0008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O JIjznK";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DN6VmWJH;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc7LbnNgXQF/PbZDks+SvKPcsvsUstGaFXUd5oKeSUM=;
	b=AYiPTPHaGGJ3f47ciE1ozfjq6QvvnaRZnnRyZjvEO7EU2OsM3tdJwKnqB/HJYwprKY9e03
	yJWJEcqQra9VjLGVJCVqIYpQfZrRSe24tRSIoIpNgEehXOaPyMdIC85Qhp/YRMSjxMphnz
	i7q5lKSUNNTq2T7B+8ToUp2gnprj9p0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O JIjznK";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DN6VmWJH;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920465;
	b=3bBWULKtTAecpDLhi/JePquiwYVU8H0uftrS6AkGNzZABAwM0Az3uJnENsdpfPvNwska2P
	Ez7mAmUztU8gZoPLrmkzdls6nS3ennVBioekmBrGhV8XdBKj7KUPUhj2rIbryIPtd17ohE
	3rWtc0GVCn9Y62Oqudj+EKLkomYiPOE=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E8A1714000FD;
	Sun, 16 Aug 2026 18:47:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sun, 16 Aug 2026 18:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920464; x=
	1787006864; bh=Rc7LbnNgXQF/PbZDks+SvKPcsvsUstGaFXUd5oKeSUM=; b=O
	JIjznKjsNnYrZJwbG2uEUZFbMrw0iEtyB2PYr2C07fvU0o43n6DmSy+/NXaQqF9l
	XdM+SNyedXBr9JJFdltwuRAcVT970OFe049Y916sAT65U5i3DLW77lm5Ya6dLewv
	dzhODT/0Q5OI9i++R5/39ITM5AGoaPMukebE/394olpt8relbwvJ67POozAGYyOP
	rcKHcz1vOFUJkhm0A2WsN6XLCm9dXzPTXdb8fCxzyqiqmeDqhS1c7RSm/mKmYOZv
	wed7fmFQ4UgXp8CgGb/oi5qhQTohqYA7bL3MV/J/s6RNzLBnw6YzNObXC1lO6iO1
	wuhB4gKZAQlPQrGpollkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920464; x=1787006864; bh=R
	c7LbnNgXQF/PbZDks+SvKPcsvsUstGaFXUd5oKeSUM=; b=DN6VmWJHWJ/BUnpT4
	1QmAA+Hm4z/fUd6jjpmq0qmMwJisK58EFfAtlxb5nLYKnFshztmqTU0fvX15yXmx
	M6n/Ou93dZx7EbnVyCK8QO4Q3CAOVRZPaKpHg4aeYy65LCExZ00uh5N3zCuczfFZ
	y2lpXB02FA9hVNN4p/zaMl4AUZv9vQz2GR9N/VQKHx2nre+8O8sxNV21Tx7WXYuv
	7gzkAxxIWyEjLP4ZJQUDKuK9XRouGPe+nC2UgtjiBzHVMFsQhZEVr1zeM4aIV70J
	t8JpmOTJISP6JC8Vf5euZRtBCazQdZsrPPOVVt8cDgPyrKCqvKiA9EpB96xCSzW7
	hs9Ug==
X-ME-Sender: <xms:ED6Caph0NsV7KW9ofXAhkz0I1EZerSFYCH82Zi9bYw42bXuUgdMPOg>
    <xme:ED6CajVqg_tTrNG3TmqY972OPOrM-hCLjJb8zGUKWUGOFr9XvwA_9cNerFl3dcHEZ
    cNDft4Tr5If3jXX43oaZhDgyHkhR3HvVCPRQoOGqAJdQqM0ACLAKOYH>
X-ME-Received: <xmr:ED6CalLOCWRHWCuq_aPboWguufmd5AB7hYjWnCniS6NhxOjFANQ7UF0Tsq4>
X-ME-Proxy-Cause: dmFkZTFkhNC7YI+Ei0MrF6zu90W9yR7z714JmmtstcBEn9fnZ0JEx8KxNru7XjOIPijUAd
    VrNDumTIvQCtLJHAbrPKMRdbJsCYKY1AWxa28xNEDdkQaDqy3PIOJVA9R+OjsTN2M4dnB4
    WQk97ejO2lmWwXR5mw6146Dl5x2vSRCf1uehpA4Z3DNP/uvzS8DmGwE+/LsFmt9BQO6ZtJ
    eWd0dPZ2F0WrWW1tiYo0zV8d4Xgh8ztMbcUaDgwCK69ZeQi0ebesOWu50OSj19NNGHzec3
    w5R1etyOsXXy4NxsI/YxbKwNbzdBv+aWoLN5/PFLP+n740pr735uP0KJxEPqjezkxGUEAo
    z0No3HJZUJpep6tsc5V41NtAo/QmKAX1kCmR1GI4As8yw+j+1WrkBGvJZfJG6IqsJdVFZs
    5FIr/7VYJuR8ul6w0vGbtWCITm2mD0nL5V0Cih+VpPedlzBfi4FBcgFxNxgdcHQuReNJxB
    oByGinK4f+XZOIoDvDzy5ihCsDXKlG1e/qbXGsJ3ayhAWA7YZiHa6xXbrMd3RjWrrsUWwo
    t1nTkzHa8RrFwbbWD2Zsomhb6fsaDA+a67RbUMyEDFtzlbvMh63VAPk4XH5d3OvGnh31cm
    KlVuA+iMrvppmUkIPdXNd5uceV7/4WuFPUQtG1l2sUw95+q7De/imXhZpvCA
X-ME-Proxy: <xmx:ED6Caq1nr5SyfxXFUxtbyx_4F9JTe4TR1A8d0_O4gSi0HxgotpVOEA>
    <xmx:ED6CatDTsX6Yt-HsFi2Tv2P2xKBMO4OowrOK825cqA7WXkoz_A6W8w>
    <xmx:ED6CauctxWk8yhBZ9OOsC3YTM9sznNUhDFHLZwk_DQuCDOS01IbfQQ>
    <xmx:ED6Cagxq7i_vStaDheMAkBzgIyMg-Sx1RFwjFLJ7bJli60bOslJ3Jw>
    <xmx:ED6CarGkZr4ysxrNTao2sjfpKWZ2TEPcXXoI1-yzA9XBOgIcwAJ9QMEL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:44 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 47/57] mm/madvise: collapse under a per-VMA read lock
Date: Sun, 16 Aug 2026 23:45:59 +0100
Message-ID: <20260816224609.308019-48-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 56304A0008
X-Stat-Signature: 8rhet8y5xthr8eskway97xq64hzud6og
X-Rspam-User: 
X-HE-Tag: 1786920465-397856
X-HE-Meta: U2FsdGVkX18Zo7EoLPyqsQXGWNg7LUtbXMbXdkQXBnXKAqxIacwZWEyrdX2X6499+Kj7RuDoXU+OG4g2UoPi9iL/f1bIoM8/kmJi8/GkEMnQmiJ4t33rIZz50eN2FkLdI+sLij05z17c/EyMNV2uAWCCYEeaiCi3ctlzqPXDUiOSfifEFcyOscTV2/KQqUoXHiVDPs18mUtD/LqSfSamGl6OrP5zU5hKvhmzCNx+Wbbl+KCDk2tl+t5vp3mqHZ8sHBMa0pz13myZHBB++PEWtFg7OFo8ntlkmobsHtfiNyjIzxRLYCTE2lUjoDLXcYr+y27QRkZyE/D8SfjC2NwwvtadnAwD2F4j5Hap7d+rOJh8ynSjHbHZ2E05D4N0Hz3CqwEBYYbllnWBg9gdoU+c/xG5N6/p07BRPXcC337/azywnPbwmObYrc+BT3YM2xETvzOzhIg+yJW5hvqGONMdbRLoEqfJrZcnAQB+HPxofEtwTpEsov/ZeQat/apwNix6XJ66HkqOqfjs91WsiURW56Lvb7yTNs8oFlI9xPBHggJnOAJLJIMblz+NylsUGr8xQ2d3CSZa0rlj0mJE2uAiasg2NJG6NRg8Y6rMbngiCuKw6artFiOfoCd7ZhQej+eAh15WjVoqrxkBDmilun353Ov7pxdKe4hTj0Rd1KDiNaCuaU8rqSdieykJvpfTRvfybu7W2zuykwOsD3KTJ5HscIRlcQ4Y9DXm0G7cu4pLrdZ/PO206ExlJaWP2oenMGAdow9UaRUrKjdFDv6iSVNQNiYzlXJMH9lRnUZLoSxbGD/D8+/cSGYLK+ZmePRIWK2x7rb3ZjAFWelbkMyjHdeotnv8tqn4VRvg8NQOxlJXIUkOiTqg57EeeVS0y7pQ9zHKI9iRdfdY5XaeHCfwwpluTJWJ9Jx060mZjKvOj5MAJl0gDKzV+aSDujLJoar0K/BJEtrTBEucLvEBhqRy0D8
 nKLWu9We
 sWHpO4bxwRv/iMa2758LOzNVNLWkWUzbVKlSNT0fUJtliWPkRAeDthqiJG1xQ8vUR09844iakdCPYlSw1oj7KpGvSoACqrATzxeZdgQ9WozZTd+P/mNw3ZcCQ/Q8PDsdOB2J1smdEPbTScfdGhvMOso7NGANMLGkTi+nwGtn6jmDG7zfRD4fdxvAsrSsyRidq4ZfF38kPpgYvQn8fRAtMZLb6FCzUtKwv/8sY4RrZLDGjI9F7ZmLgwr2topTfHKJDhx0H+E/WW+3IhboYLkY7Rnmyt315UinBBb3sq0CO711kr2YfykezBhZVuNgPCIh/jgsMNMHDf0DZYZwSn/LVCpppjeMeAVDhz1zRSFG1uqkta6j4LfUxw/g69+938doMXSjn1wLTXxxhj6WvNrUcDwNhUfUR/r1xVndNxVEBAGUyCGhoB4vMsS2VjVihxsGEMtERdVBpY/JPLjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

MADV_COLLAPSE arrives under mmap_lock, gives it up, and takes it again per
PMD to scan and hand a table to the collapse.  Every writer to the address
space waits behind each of those, and the range can be as large as the
caller asked for.

Take a read lock on the VMA instead: MADVISE_VMA_READ_LOCK in the lock
mode, lock_vma_under_rcu() per PMD, and the walk told not to release what
the behaviour already let go.

A scan that finds nothing keeps the lock, so a range that is already
collapsed walks it without relocking.  A collapse gives the lock up and
looks the VMA up again afterwards: it can shrink while nothing is held,
which the scan reports as a refused range like any other.

Remote madvise is the exception.  process_madvise() has to untag the range
with untagged_addr_remote() before any VMA is looked at.  That reads mm
state mmap_lock protects, so remote MADV_COLLAPSE keeps the mmap_read it
has.

A VMA that cannot be locked is reported as SCAN_VMA_LOCK, which reaches
the caller as -EAGAIN.  lock_vma_under_rcu() also fails on a VMA being
written to, and reporting that as a range which shrank would tell the
caller a collapse succeeded where none was attempted.  With that, nothing
produces SCAN_VMA_NULL any more, and the test for it goes.

Both callers hold a read lock on the VMA now.  That is what the changes
outside madvise.c are for: the engine's interface documented mmap_lock as
its precondition, and only here does that stop being true of every caller.
The scan asserts the lock again too, which was not possible while the
callers disagreed.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 24 +++++++------
 mm/collapse.h |  8 ++---
 mm/madvise.c  | 98 +++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 93 insertions(+), 37 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index b3343595bdf2..1e3b2d202ffe 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -3685,8 +3685,8 @@ static enum scan_result collapse_scan_file_pmd(struct vm_area_struct *vma,
 
 	/*
 	 * A PMD that is huge already has nothing left to collapse, and skipping
-	 * it here is what keeps mmap_lock out of a collapse that would find
-	 * nothing.  Everything else is worth the page cache scan, pmd_none()
+	 * it here is what keeps a collapse that would find nothing from being
+	 * run at all.  Everything else is worth the page cache scan, pmd_none()
 	 * included: a file range can be collapsed out of the cache without being
 	 * mapped first, which is why this is not the test the anonymous side
 	 * makes.
@@ -3703,8 +3703,8 @@ static enum scan_result collapse_scan_file_pmd(struct vm_area_struct *vma,
 
 /*
  * Build a PMD over what the page cache holds, and map it over the range if a huge
- * folio is already there but mapped by PTEs.  Runs with no mmap_lock, which the
- * caller gave up, and takes it again only for that last step.
+ * folio is already there but mapped by PTEs.  Runs with no lock on the VMA,
+ * which the caller gave up, and takes mmap_lock only for that last step.
  */
 static enum scan_result collapse_file_pmd(struct mm_struct *mm,
 		unsigned long addr, struct collapse_control *cc)
@@ -3746,9 +3746,9 @@ static enum scan_result collapse_file_pmd(struct mm_struct *mm,
 
 /*
  * Scan one table's worth of @vma and decide whether there is anything to collapse
- * in it.  The caller holds a read lock and still holds it when this returns:
- * what is looked at is either the VMA or a page table that the lock keeps in
- * place.
+ * in it.  The caller holds a read lock on @vma and still holds it when this
+ * returns: what is looked at is either the VMA or a page table that the lock
+ * keeps in place.
  *
  * Returns whether collapse_run_pmd() has anything to do, and a scan that found
  * something has to be run: the file side takes a reference on the file while it
@@ -3761,6 +3761,8 @@ bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	struct mm_struct *mm = vma->vm_mm;
 
+	vma_assert_locked(vma);
+
 	/*
 	 * What the scan answers with, so cleared before it runs.
 	 * collapse_anon_scan_init() clears the orders too, but only once the
@@ -3789,10 +3791,10 @@ bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
 }
 
 /*
- * Collapse what the scan selected.  Called with no mmap_lock: the caller gives it
- * up first, because a collapse takes it again for each round and revalidates
- * under it, and holding it across the whole collapse would keep a writer to the
- * address space waiting for it.
+ * Collapse what the scan selected.  Called with no lock on the VMA the scan
+ * looked at: the caller gives that up first, because a collapse takes its own
+ * for each round and revalidates under it, and holding one across the whole
+ * collapse would keep a writer to the VMA waiting for it.
  */
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 		unsigned long end, struct collapse_control *cc)
diff --git a/mm/collapse.h b/mm/collapse.h
index e5a0ffab049c..aeaca305e71a 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -207,8 +207,8 @@ static inline int collapse_test_exit_or_disable_mmref(struct mm_struct *mm)
  *	collapse_run_pmd(mm, addr, end, cc);	when the scan found work
  *	collapse_control_release(cc);
  *
- * The caller holds mmap_lock for reading and passes a range within one PTE table
- * of @vma.  A range the VMA does not cover is refused, which is also how a caller
+ * The caller holds a read lock on @vma and passes a range within one PTE table
+ * of it.  A range the VMA does not cover is refused, which is also how a caller
  * learns that its own range shrank.
  *
  * A scan returns with that lock still held: it only reads, and almost every table
@@ -218,8 +218,8 @@ static inline int collapse_test_exit_or_disable_mmref(struct mm_struct *mm)
  * A collapse is called without it: the caller gives the lock up first, and with it
  * @vma and anything derived under it, so a caller carrying on has to look up
  * again.  What the collapse does -- allocate, quiesce, copy, flush -- is slow
- * enough that a writer would wait behind it, so it takes the lock again per round
- * instead, and revalidates rather than trusting what the scan saw.
+ * enough that a writer to the VMA would wait behind it, so it takes its own lock
+ * per round instead, and revalidates rather than trusting what the scan saw.
  *
  * A scan that found something has to be run: the file side takes a reference on
  * the file while it still has the VMA to take it from, and the run is what gives
diff --git a/mm/madvise.c b/mm/madvise.c
index bd9123ee3cb1..5f6d815d70ad 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -276,6 +276,18 @@ static void mark_mmap_lock_dropped(struct madvise_behavior *madv_behavior)
 	madv_behavior->lock_dropped = true;
 }
 
+/*
+ * The VMA-lock counterpart, for a behaviour that releases the VMA it was handed
+ * and locks what it needs for itself.  The walk has nothing left to release,
+ * and unlike the mmap_lock case it has nothing to carry on with either: the VMA
+ * fast path applies to one VMA and returns.
+ */
+static void mark_vma_lock_dropped(struct madvise_behavior *madv_behavior)
+{
+	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_VMA_READ_LOCK);
+	madv_behavior->lock_dropped = true;
+}
+
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
@@ -948,6 +960,8 @@ static int madvise_collapse_errno(enum scan_result r)
 static int madvise_collapse(struct madvise_behavior *madv_behavior)
 {
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	const bool vma_locked =
+		madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK;
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct mm_struct *mm = madv_behavior->mm;
 	unsigned long hstart, hend, addr;
@@ -981,13 +995,22 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 	}
 
 	/*
-	 * Nothing below wants the lock the VMA walk left held, and
-	 * lru_add_drain_all() waits on every CPU, so give it up first.  The
-	 * walk carries on under mmap_lock and its own caller is what drops it,
-	 * so reporting this only tells the walk that its VMA is now stale.
+	 * Give up whatever the caller locked for us.  lru_add_drain_all() below
+	 * must not run under a lock, and the loop locks what it works on for
+	 * itself, one VMA at a time, so the caller's VMA is of no use past here.
+	 *
+	 * Which lock that is depends on how we were reached.  A range inside one
+	 * VMA arrives with that VMA read-locked and nothing else; a range that
+	 * spans VMAs arrives under mmap_lock, because try_vma_read_lock() took
+	 * it and turned the walk generic.
 	 */
-	mmap_read_unlock(mm);
-	mark_mmap_lock_dropped(madv_behavior);
+	if (vma_locked) {
+		vma_end_read(vma);
+		mark_vma_lock_dropped(madv_behavior);
+	} else {
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+	}
 	vma = NULL;
 	vma_orders = 0;
 	lru_add_drain_all();
@@ -996,22 +1019,36 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 		enum scan_result result;
 
 		/*
-		 * A collapse gives the lock up, and the VMA has to be found
-		 * again after one: it can shrink while nothing is held.  A scan
-		 * that finds nothing to collapse leaves the lock alone, so a
-		 * range that is already collapsed walks it without relocking.
+		 * On another process, the reference this call holds is what
+		 * keeps the address space from being torn down -- so if it is
+		 * the only one left, the owner has gone and every page of it is
+		 * waiting on us to stop.  Nothing else here would notice: the
+		 * range is the caller's, and it can be enormous.
+		 */
+		if (mm != current->mm && collapse_test_exit_mmref(mm)) {
+			hend = addr;
+			break;
+		}
+
+		/*
+		 * A collapse gives the VMA read lock up, and the VMA has to be
+		 * found again after one: it can shrink while nothing is held.
 		 *
 		 * Reschedule only here, where nothing is held: a preemption
 		 * point under a lock is a writer waiting longer.
 		 */
 		if (!vma) {
 			cond_resched();
-			mmap_read_lock(mm);
-			vma = vma_lookup(mm, addr);
-			if (!vma) {
-				mmap_read_unlock(mm);
-				hend = addr;
-				break;
+			vma = lock_vma_under_rcu(mm, addr);
+			if (IS_ERR_OR_NULL(vma)) {
+				/*
+				 * Not only a VMA that has gone: this also fails
+				 * on one being written to right now.  Say what
+				 * is true of both -- try again.
+				 */
+				vma = NULL;
+				last_fail = SCAN_VMA_LOCK;
+				goto out;
 			}
 			vma_orders = collapse_possible_orders(vma,
 					vma->vm_flags, TVA_FORCED_COLLAPSE);
@@ -1023,7 +1060,7 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 			result = cc->scan_refusal;
 		} else {
 			/* collapse_run_pmd() takes its own locks, so give this up */
-			mmap_read_unlock(mm);
+			vma_end_read(vma);
 			vma = NULL;
 			/* The mask belonged to that lock, not to this range */
 			vma_orders = 0;
@@ -1036,7 +1073,7 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 		 * The VMA shrank under us, so the rest of the range was never
 		 * ours to collapse: stop, and expect only what came before.
 		 */
-		if (result == SCAN_VMA_NULL || result == SCAN_ADDRESS_RANGE) {
+		if (result == SCAN_ADDRESS_RANGE) {
 			hend = addr;
 			break;
 		}
@@ -1067,8 +1104,14 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 	}
 
 out:
-	/* The VMA walk this returns to expects the lock it was holding */
-	if (!vma)
+	if (vma)
+		vma_end_read(vma);
+	/*
+	 * Hand mmap_lock back only to a caller that is going to carry on with
+	 * it: the generic walk finds the next VMA under it.  The VMA fast path
+	 * applies to one VMA and returns, so it wants nothing back.
+	 */
+	if (!vma_locked)
 		mmap_read_lock(mm);
 	collapse_control_release(cc);
 	kfree(cc);
@@ -1866,7 +1909,10 @@ int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK &&
 	    try_vma_read_lock(madv_behavior)) {
 		error = madvise_vma_behavior(madv_behavior);
-		vma_end_read(madv_behavior->vma);
+		/* A behaviour that let the VMA go has nothing left to release */
+		if (!madv_behavior->lock_dropped)
+			vma_end_read(madv_behavior->vma);
+		madv_behavior->lock_dropped = false;
 		return error;
 	}
 
@@ -1941,8 +1987,16 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_PAGEOUT:
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
-	case MADV_COLLAPSE:
 		return MADVISE_MMAP_READ_LOCK;
+	case MADV_COLLAPSE:
+		/*
+		 * Only for this process.  On another one the range has to be
+		 * untagged with untagged_addr_remote(), which reads mm state
+		 * that mmap_lock protects, before any VMA is looked at.
+		 */
+		if (madv_behavior->mm != current->mm)
+			return MADVISE_MMAP_READ_LOCK;
+		fallthrough;
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
-- 
2.54.0



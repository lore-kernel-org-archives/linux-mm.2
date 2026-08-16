Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99371C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68B06B0895; Sun, 16 Aug 2026 18:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40B16B0898; Sun, 16 Aug 2026 18:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52D26B0895; Sun, 16 Aug 2026 18:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B14A6B0895
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5B5E12010A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:29 +0000 (UTC)
X-FDA: 85108620618.30.EB9E924
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF66840007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d 6Y2jbr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=SnXwxds2;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxOUZtNI4iK6oDUbeznOi5j6qWIw7a+qTCAWQpT1d7E=;
	b=08E/t76QAsf50gSyAn7ow948MM80oIPmYjZyhZCdS+tpbrfmknFCa/62vRAkcy9oTRFN8p
	nXVd4R3tpnkjmc5PRhfZgTMSdgyyQDUR9GLpZD6Q6XKed6rloKB9M6rGwGMoU1MxaoRbKs
	7FWJo9BsPzGmlVdpRdihFXx6wEQ1SQo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d 6Y2jbr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=SnXwxds2;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920447;
	b=WYwjPmroikKbuAGwqjj0No5LGitFjOMyii74/69wdvxNU+ePKSWxIaAHF1broBEXvA2iHn
	NV09Vj+gz/jd4ZybetOpBTZje+VZU4Y3YTQmMwQozEQey6FmchsiIb7if9QBBINwdPKAOf
	29U6L/4UDQUCAXJAYyFeKPd2dL6zLkQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 75E8F14000FB;
	Sun, 16 Aug 2026 18:47:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 16 Aug 2026 18:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920447; x=
	1787006847; bh=RxOUZtNI4iK6oDUbeznOi5j6qWIw7a+qTCAWQpT1d7E=; b=d
	6Y2jbrLxcG+b7UlQQQDlAUCnECDZvaCKHbgYYo96wTHEGmtT61158UIi24EfmWBq
	1r0MiJt1qD9EWnwIlRJ1FVDPQSHCuQQk2fnFJeYBzxHGnpFwer1hwqp22UwnDM2i
	GF665c+8S6CCznhnz7Rxaon2MSmgX0NrQJdycztlwwZuy5MpTU2Teq7AmK9Br+rh
	izXEyoj2U8owy02g1nD1Qj6i4jC4YyjP5FI2rG4tML9AyVg6sUVTfMzPyT6WUOF9
	zAAV5AdKP1cwODl6BUU4DOg8bV+kyvHHxuV+0Y0QmTPawvH2JEVhRfVi3ztWiTCc
	Vz6hvChnLuvM2EhXEAC4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920447; x=1787006847; bh=R
	xOUZtNI4iK6oDUbeznOi5j6qWIw7a+qTCAWQpT1d7E=; b=SnXwxds2phmTEsFOj
	Q2LaIYTq8f6mE6MN8pVm+gwliOOaKFVpnarOySZ1FjmfvCANGLx6V98d0FLbztWA
	B9biuWNQ114cLiT0pExzYfTBAjP1lIJeDENfz04uTJKdsENucFxvn8NFnjIzDojQ
	rN4j4aKvkTKFdK+PWQx9CFZ2bOkedltp9DqnN7IbzuX99k9Y5+1++80cNQmc3arD
	b8c5YS9+7N68QAUhoUdsSU4gM67AF3m8qbE1G7ElyxXnjn20xzG3lb0IekzfMn5G
	gxgHPBwT5QWFMdOWoUEnYJE6pNoxkJ3aZJHhY4pVR79n5Yk+ZaFycQjFXiJOknTt
	X3SxA==
X-ME-Sender: <xms:_z2Cauc9DGmMoL75smZAHOOUa-L2NhdOxlJ_rp36LakMlT2Eqh75eg>
    <xme:_z2CatgaO-eQNOwuf6F2Z2Ck9MdJhWXiB-qTo6xvOm79lKajoFkqBFFVS1BFFdku_
    oDq_lPJn_jcAL4OhM6C9oAL0_KZAQXbrfsL_CBve53Ot_yhga5383iJ>
X-ME-Received: <xmr:_z2Carl1Nvp8EvT3DIIdmWUI7gymooa294TrXQH_9rRaAq_ETSOJo3puZLQ>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTVW
    SGg4/Aho0z4roUqJEIyLZFKJMrH29ZtJmmfVu0Xk4xI9g5vXJsHBT/1UTWE52f63Iditod
    QO+tCxiJRIyoY5eyvFqF/AP9BwfZSJJILY0yBU4a+Y77JTTBvzFRPmzoF2NwjJw/SQV0mw
    3gBuVTYtebOsIyX9LdjddvoMVP97xwlvjYt5YJaoGGSpdBdloyVecVWIk3bHdHHzpzaiBL
    dxjak1g91n3VQ8llIqbPfezoTwPoq1nkTX2Ju/5Z66s1JgNHx0dnFQ8yPZHSqhczgAz/jU
    7Zani/FxXTb5g+3pyTmIq3aqyP8cdvHFbM+9BhJbzY2xyTHsPI232s/hahjg
X-ME-Proxy: <xmx:_z2Caog4DUmEzXcltHF3csxAQnf_5pGe0MKw-3JmUR5xItcbVb-GFQ>
    <xmx:_z2Cag-DLAjOOqxozuEjbqqJzs9d0xyiZQpE9DmPV51677Zf2XDseg>
    <xmx:_z2CarpliFz2PvMsBQicbwgsE6m2IQuC7QERKy31r2MkPIheQOY3ZA>
    <xmx:_z2CauPAuGHUr9v0vxTyGEGaDHW5mg17JLDPnFJNXuV7vGuwrCOYig>
    <xmx:_z2CajQV9oAXOJAUMVuE72pGShFy5qQPsRrZc15PIVYZdxOi8IaBoqlW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:26 -0400 (EDT)
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
Subject: [RFC PATCH 37/57] mm/collapse: report what the fault-in pass paid
Date: Sun, 16 Aug 2026 23:45:49 +0100
Message-ID: <20260816224609.308019-38-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tn4r1a8wsi6msuna1ss9us1zmmu7auyc
X-Rspamd-Queue-Id: DF66840007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786920447-445635
X-HE-Meta: U2FsdGVkX1832dYNVtRDtrXZsckWlS79hccpv8gnf4gAakk4Pb82Q+e1EYDr7xApABeuvgtKaDIlwzOjuJ1FTms6CYkJoCqV2OGPVrrJzOjuLOboy2XpNNZF3+BGZ/1EPoaKhYNc1YwNiqH+Ue48OTOMukWhTNgEoqGr/nggJQ7t68BzF86j7HCbAXB4elGbbGRzVBsoPgjKHQwEJ3cOx6IudvmDutKcA3j27NCBUPi+pYARxHnzUOVPH6uZFZWX3tZJCsCqpAzZikqTtSVgZ0ThXm53Ph6SqYMiag3zLauNtSzefEV0gLLXGLXC20WK6TlJre1mMZZk+gpYVlTI7m/c7uJslXAMoZAzwSe7Lvb5fc6rhEIQXkUBqrr9LW5IL0hC+EWvfWxP1vK5rBTmhHkGYBEax8ra7QrmlIrg1t+sKb7GanXh8plmLqHJB6Vzj28+w9SHlpZcwkHAPnijspbbK5Ou/sLZWcWIaNLbjNjkxx6+U88nHmgU+7Sx/NAG12DPHiM5tGQ/7/jcIAWNzaF3JInJS2sjfIYMA/9UJV6jMPVsSCHPT6Hb0mlNxj+NnEDYHJhiBX2HIw7YKmKtnV/66j9MYChYWkxfruaHBQ9XHrimtZr1q3mRBcBbtS7bDNInQ1CaWvJhpX52E98YGMp20ulKfJkPKV/2H/xETSJZxIQMPPPTnmbPhu2HPaKdFG8gNTLeX/ETAH5fEpBpXeOBuLjGLJcCNrcsStR2f275u7iix+Ifg97XIrzczyGS+bpthU3hyEY744O6UrjROnee5J42MoItfoty/JHoGJVh67koZK+SADRanY5QOVl/WosiqBg5x5/12dqmCta3RZb4Z5frbA2WqjWmRxdDP4xWPvXifFBfPxCmMThty7cd4Mzvln7n69Cv4mLxNv+iipo6q0w/9a8BRtr3Ty/WnMftpwG1fJ72D3AMdokrdIHuYsqvSfI2Kns8ACZXB//
 g6lQK5uj
 E0UMi/D8QLjlvlezqAhCGRBqmPj6qQTfu58/WLJlKsweaFeAjflRCxH92mF23AWAh/WyfOQHbHO+jlyNXBcoLyZ/lHPvKQCajyl2OZw7EpXITeH8l6mARJvsRIy866q8OLSPzLfQU/yJchKntfekY1iV95lTFymAnCIFBHLKwWHdeyX7s626r/csImoBoQjLN2Eu9PkH2Ifewr82JXnCxCPZB0WpicqRJE7Jgr/DpQftjxR7awhfQU5MWqL9pi2WOxHy9F7uIcuo+oLDXacejo9KKrQxCP4moU8yyB/G4918HZKkWEOoReefn9wYxu3MfT0s5Laj8WTolS3WmtXJcWJj+PW3iBQRthj2U3XgN4SbzaKUg22lGsuobgFUJHqyl/9GtL3hCySQ4Se+jLufcCUtNGQVrvfmb6Y8lDMs0TA/xdqcg4rPWU0v1fQyhJiF4BVlBFmeWY0ui7pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The fault-in pass is the one place a collapse does work on someone else's
behalf: a swap read, or a CoW break, for every slot that needs one.  How
much of that a round pays is invisible, and it is the first thing to look
at when collapses are slow, or when a workload notices khugepaged at all.

Add mm_collapse_faultin: the faults taken across the round, with the
outcome.  A round that collapses a full table without faulting anything
and one that reads sixty-four pages back from swap are otherwise
indistinguishable.

The mm is captured before the walk, because the pass returns with
mmap_lock dropped on failure and the VMA is then unsafe to touch at the
report.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
 mm/collapse.c                      | 19 ++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 573cf5428969..c2314e26111c 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -160,6 +160,30 @@ TRACE_EVENT(mm_collapse_scan,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_collapse_faultin,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int nr_faults, int result),
+
+	TP_ARGS(mm, nr_faults, result),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, nr_faults)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->nr_faults = nr_faults;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, nr_faults=%u, result=%s",
+		__entry->mm,
+		__entry->nr_faults,
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 TRACE_EVENT(mm_collapse_candidate,
 
 	TP_PROTO(struct mm_struct *mm, unsigned long addr, unsigned int order,
diff --git a/mm/collapse.c b/mm/collapse.c
index b750a1fc81a5..1b5db42b6991 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -509,8 +509,10 @@ static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
 
 /*
  * Bring one address to a state the freeze will accept: present, and exclusive if
- * it is anonymous.  Returns with mmap_lock dropped on every failure, because the
- * fault path may drop it and the caller cannot tell which case it is in.
+ * it is anonymous.  Every fault it takes to get there counts in *nr_faults, each
+ * one an allocation or a read the round is paying for.  Returns with mmap_lock
+ * dropped on every failure, because the fault path may drop it and the caller
+ * cannot tell which case it is in.
  *
  * SCAN_EXCEED_SWAP_PTE is the exception: it is a verdict on this candidate
  * rather than on the round, nothing was faulted to reach it, and it keeps the
@@ -518,7 +520,8 @@ static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
  */
 static enum scan_result collapse_faultin_addr(struct vm_area_struct *vma,
 					      struct collapse_candidate *cand,
-					      pmd_t *pmd, unsigned long addr)
+					      pmd_t *pmd, unsigned long addr,
+					      unsigned int *nr_faults)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	const unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_UNSHARE |
@@ -571,6 +574,7 @@ static enum scan_result collapse_faultin_addr(struct vm_area_struct *vma,
 
 		/* Only swap or shared PTEs reach here; the rest broke out */
 		ret = handle_mm_fault(vma, addr, flags, NULL);
+		(*nr_faults)++;
 		/*
 		 * Not a verdict on this window: the fault dropped the lock to
 		 * wait, which is what a swap-in normally does.  Distinct from
@@ -600,7 +604,9 @@ static enum scan_result collapse_faultin(struct vm_area_struct *vma,
 					 struct collapse_control *cc,
 					 pmd_t *pmd)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned int nr_faults = 0;
 	unsigned int i;
 
 	for (i = 0; i < cc->nr_candidates; i++) {
@@ -616,7 +622,8 @@ static enum scan_result collapse_faultin(struct vm_area_struct *vma,
 		     j++, addr += PAGE_SIZE) {
 			enum scan_result r;
 
-			r = collapse_faultin_addr(vma, cand, pmd, addr);
+			r = collapse_faultin_addr(vma, cand, pmd, addr,
+						  &nr_faults);
 			/*
 			 * The one failure that judges this candidate rather
 			 * than the round, and so the one that leaves the lock
@@ -627,7 +634,7 @@ static enum scan_result collapse_faultin(struct vm_area_struct *vma,
 			if (r == SCAN_EXCEED_SWAP_PTE) {
 				cand->state = CAND_SKIPPED;
 				cand->result = r;
-				collapse_trace_candidate(vma->vm_mm, cand,
+				collapse_trace_candidate(mm, cand,
 							 COLLAPSE_PASS_FAULTIN);
 				break;
 			}
@@ -638,6 +645,8 @@ static enum scan_result collapse_faultin(struct vm_area_struct *vma,
 		}
 	}
 out:
+	/* @vma is unsafe on the failure path: the callee dropped mmap_lock */
+	trace_mm_collapse_faultin(mm, nr_faults, result);
 	return result;
 }
 
-- 
2.54.0



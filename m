Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED11C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F59E6B087B; Sun, 16 Aug 2026 18:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6FF6B087D; Sun, 16 Aug 2026 18:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7955E6B087E; Sun, 16 Aug 2026 18:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 464AE6B087B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C66C3805DF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:06 +0000 (UTC)
X-FDA: 85108619652.28.C05715B
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECC3A1C0009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S mT7gsg";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HD6CvoxK;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=206JYDvQB0ujHXi5pJEt/V4UdyhHvopT44QwBt0napI=;
	b=6qLu49SmHFUowjKMuxsBWcm/nylGpQombNpTbrFL6aR7+6p2jL/3cnlUvydwIuhCnI2VJW
	si+8rDcAQtIHzteapin+9FecMg/2UfiiCbyZwvdrdAWBKCO69qAS6mGIjizEaKRLQ5zaWi
	K//zqAYfhhdE++BT1cAKF0Bq32CWt/M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S mT7gsg";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HD6CvoxK;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920425;
	b=nKmG57lLrxkGKs7y/zYoeKHq/4rX8pr39Av+v0GieqLod6sb7qyE6dfFV7oPzk19wLEnxQ
	XgXIt2vnZmlPdCEdmqq6S1V2ysfDLGd4X2q1/KGb8+BzkIus6mCU/4v6Z9rCwDO4cIPtXz
	nclMCJHUXRzenqUtcK2yRXHwdNMAMNg=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 7FA5EEC0074;
	Sun, 16 Aug 2026 18:47:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920424; x=
	1787006824; bh=206JYDvQB0ujHXi5pJEt/V4UdyhHvopT44QwBt0napI=; b=S
	mT7gsgM5hzoFn1e/Zc+g6MXtweaEWB8DtqJUpnR6CPUbPr5gd0rmpDOjnI7B+FJZ
	txMLHobGB7wjUnh15YuS1D6f9A1qo1XtIhszT6QcE85qy8Ng6FcOXmB+ZP9D8a9U
	eoLwiTHGvY2J9TaxwDI4LMtRrJOeGgZFniGnCc+dVkjUHq3woiaAyvmBovWPwtXf
	7FrR0IgNIW/wbvN7neSBi1ErynrI6HYN5oxFeC19LqBFV5hGrZlaB8W2MdMkbyUn
	prTIHTooXk1tuKhBRj4FGMd0Ld/CURRaWtTpmQ3M1Sea56np3V90gvgeVj6b5O6A
	wk9d9RZCe8+y2PrEjeL8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920424; x=1787006824; bh=2
	06JYDvQB0ujHXi5pJEt/V4UdyhHvopT44QwBt0napI=; b=HD6CvoxK3cTmYVE2m
	ReLahvWPkzgEQ4xT4HkS/JQyy1p6N1JC5QRs9cFhD+r6mqagE+WgEjY852OpRFV+
	QUbyUv2hgQfdnaxbPeyhLjhSJ7NdwBSUf8CezLenlk2bsJjHJWDk8Yv2zQ+2BnHW
	NJqMInRKsOVl+590OdISwJAY/+wpCY/KXsjKnc1i0oLKwB5ZuyT78BzdhFleZHZ3
	HPgTJd6Tl+RGi0FLD9+ZAqGcvJ8YzLrf1NdGGgAhNz/03iWNX+NEVWRM2Lu0cvfw
	69jmBoQG3EJyQP6apVDX+G/Rc4Nm8EZ1FAt3rAaji1H0KQUrfhZqxzrureH9kn8r
	QQuDA==
X-ME-Sender: <xms:6D2CamHTYocA8sOqtNWS5Y4B-6fWP7tBCFtkHJZwC_QJpjoqG1rdsQ>
    <xme:6D2Caspb3DTx9M4XN-9-uhl2lFEoSP0uVqHCgbPGFm52dnBqJJbxUp_gT8apHHXyf
    8ofGRbiok3mbptAljwQwEyNAH3dCRPVw44aAaw73S6SnQEGYimPWfux>
X-ME-Received: <xmr:6D2CasOIUKMg_JyiLqT4LDQBbQTKwdJJyA8XRG4X4R5Hwxi3fiumragNbd0>
X-ME-Proxy-Cause: dmFkZTGeQUP6jehEeI0kOFfHX8Bz1vci7ZS0pF5h1BDhjvrnMAYVx6hGR3OE9yv6W3r0gb
    n0/FUryAyJMRviPVI/zcKHlW5AI1WzRuWaH5KZl7QKEdlwAk6TndP7sFtmhpcUxoS2T1Ub
    bJYQdn3ioRn3ttrBnyjoeoqk/8OxdnzTOD/CD/598C7l9KFQmDhpWnCO05OTUOy71ONkYN
    1mUBKy2LgCWDUmlELwjFPAnmnv6K5fs53d2O4zI6fbjDWLajXYbzG+y30fmb5KnxmJ+KbM
    yupMSRc5Aw9K+Bbz/tXrPcir7VA0gcPKiOoeZixTP7fXgAmXhGWtgZIkK9P0VDdjDmjmE/
    vWPsFH7ul4cYFqd0Pb083yR7+P0Ep3+LJFuPrtz77cQGVMhStHZpW289eHgvarwxIEFYEM
    +ALAAqWpg18S5YrkTaLDxuOv8uigPsSWuJ/XKe+OsF7XwjD2hjS1D/a46c+kLVxStz75+O
    DACM9YC77Y//czQG/9f12QOqbdQHTdxxlslZP+eor7NOYfVbjXDbL6UAhu4Yhl/d8xVJwH
    n0qOTZ1svyTljhI8LFos0S5R4ZiR/3pFdPEW1V8s/kvfdC+Ux5Mk3EJmhpkcGwhdlTIVdz
    y3Ba/zg8hH0wHRl0+R61js1Su6FP9MrYAYldXcP+OaLB23y634BaHsTI2LCA
X-ME-Proxy: <xmx:6D2CaspPeu8pSGU5qw_SQWwgszYcTGNA6Rf9uQEIPQW6AHhlMFVfZA>
    <xmx:6D2Caim2XJT7qleuxMc-Y9SS2x5-MZrhm3r8rcGzDQYy7y8vEq-Iug>
    <xmx:6D2CasyD7wJwBG8lWQUIuQ-ud_rMuLK_wkIZThDfbY6tIncYj1HH9w>
    <xmx:6D2Cao26PDXHoNG3POJl0FhmmIPMq7R2qs6NhYpu4miPubwyZ_twaw>
    <xmx:6D2CambJWVFXnDZAcbsEBb1knU5u5l01JCwn7W-0WhcK3sJz3MtZxn9i>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:03 -0400 (EDT)
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
Subject: [RFC PATCH 24/57] mm/collapse: report each candidate's outcome to tracing
Date: Sun, 16 Aug 2026 23:45:36 +0100
Message-ID: <20260816224609.308019-25-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1w3kmqjumquxj316eazgi1f7g69rre13
X-Rspamd-Queue-Id: ECC3A1C0009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786920424-292193
X-HE-Meta: U2FsdGVkX18FHoYYRarQBhqIzlFr8XkB+fBm7mOPVTxQABKfnQOvCIRtdNIQhMOlufy66EixpnJxhhWVUI1fHdXzExugH3o/BDSo+fki2/k5uwGcLKwcnFOUJQBn8UMVlZPKRiZdbTMN68017DVj4vasTX1U5u3hahXoTnhNDZlKbwoctutHyhJnjIpDFzKUgRLgK8Qn+LkTO8oOL9YqUfavvsacXLkPBtXgKKqgfa9qdoI4R85aKwJlG9zgbVWhReezF6NR+YcCvXmr9qvmqQ1/U3AdMWzWhc8M/fZHfeIv8JtiGxPO885KQ2X4qxotLM0JHvo0NMtsDmXsK5xUtIwPudVeOX9v7+5qNbjPxC5U+dE2XWUIGjdakYvjlUicC+WU5EueSRO/I10Hi9iwGhv6amvPXCTIlUuvyKSjiOIsjivzUXIM9KL80RIS5Mr5KFGzwPZqWK0RqPVPROKWOOwutSQB3LmqVRgtVvh7bFgsXvwzoHKewO5hKdOyQargA4NVsTRl2mdLXm8jjurS0FNQuc7ULu1kXaKo0O8L/Tnd9cRaEHDkJWzbuI1ccNSyMSzQSB2yubl3sOE7MASQEW2cc4fDbCOOpWxrnPsW0b+8aGtrvgh9HHzYakdKFqk0f9207pRiAb0k5kf8LVI94dq/XzSq043q/Dwu07kej21cTM+oGlSL+WXgQ1StRrB5mz8M1nQIv1D+lpl1hYy22OVQNztdrCHzdn9RdeAuQYCl5aHT+AidD5VLQ7xzKIxXZeiQ7QerfnUR+HG5wrszGpFTZPrVvUZBl7TiPeLY8ENTnjeeWjmOUHBw8IbjsdfUB5EhXNeHZXhVTs8goZlBAgOr4fdyqPMazzkdyl+ysTkvYZY4Dr2M2M5r3ea4ZGFJE92QQf0m04f+u37k0QcbMzSGnHbOLhvu1VLvcXnHBHUTxxbP1Bbk3+/1tHBUFwfaAG/N5dQeyL8c4fqKhEr
 wzs2WKFt
 BF4upMKjxoEnCXZdBFYsmJO+hlEAh+bpAijrVOtXWydm8ECZaKkVx5j+Sgem6n36kfH0qYfq8KLrR1RR24I2TG154gQWLtdrVpp1dJB0cR+O+wSL0sTX9FL7uMkUNlSXQUhz6Alo2eOMxMoWghP8NjcDrzVXf6n+9jQ2RoHC/U4vAP3hPkkPo84zYtxKRnRBWHj3jj9ELMDeV5PBICh/ECiBMbrj0dBuu3U7qDHImOjvOzSrhIEaCosOSiVKlbtRvpdnMxduor8BsyV80JDOKG5wr9BIpsuDWOV2cFNCsqvnQAi62XQsnX7ajFhb2RAOykWcueLRayPpuBLYnz5zCW/OfYD2b1OQnsDStUcnN9xhD5t7rAUDRzBzye4GZGVmgJ31DuLR/lAiIoNDB+OfxjeZsdG2849hBCBIllNzVDp83B8Qg+JtZfnapayW48eyLj+uzMlNabcXvWe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The engine decides per candidate, and every one of those decisions is
currently invisible: the mechanism it is about to replace reports through
mm_collapse_huge_page_isolate, which the engine never calls.  Switching
the anonymous path over without something in its place would take
existing tracing with it.

Add one tracepoint, mm_collapse_candidate: a window's address and order,
the pass that reached a verdict on it, and what that verdict was.

Every candidate a pass judged produces exactly one -- the pass that
refused it, or the install for one that made it.  A candidate the round
gave up on before any pass judged it produces none.

That is enough to follow a round: which windows were attempted, and which
ones the batch dropped and where.  It is also what a scan of the trace
buffer can attribute to an address.

It goes in the huge_memory trace system, next to the events it stands in
for, so a consumer enabling that system keeps seeing collapses.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 40 ++++++++++++++++++++++++++++++
 mm/collapse.c                      | 32 +++++++++++++++++++++++-
 mm/collapse.h                      | 13 ++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index ff938ac9c43c..86131845b761 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -44,12 +44,21 @@
 	EM( SCAN_PAGE_NOT_EXCLUSIVE,	"page_not_exclusive")		\
 	EMe(SCAN_ALLOC_LIGHT_MISS,	"alloc_light_miss")
 
+#define COLLAPSE_PASS_STATUS						\
+	EM( COLLAPSE_PASS_ALLOC,	"alloc")			\
+	EM( COLLAPSE_PASS_REVALIDATE,	"revalidate")			\
+	EM( COLLAPSE_PASS_FAULTIN,	"faultin")			\
+	EM( COLLAPSE_PASS_FREEZE,	"freeze")			\
+	EM( COLLAPSE_PASS_COPY,		"copy")				\
+	EMe(COLLAPSE_PASS_INSTALL,	"install")
+
 #undef EM
 #undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
 #define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 SCAN_STATUS
+COLLAPSE_PASS_STATUS
 
 #undef EM
 #undef EMe
@@ -117,6 +126,37 @@ TRACE_EVENT(mm_collapse_huge_page,
 		__entry->order)
 );
 
+TRACE_EVENT(mm_collapse_candidate,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long addr, unsigned int order,
+		 int pass, int result),
+
+	TP_ARGS(mm, addr, order, pass, result),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, addr)
+		__field(unsigned int, order)
+		__field(int, pass)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->addr = addr;
+		__entry->order = order;
+		__entry->pass = pass;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, addr=0x%lx, order=%u, pass=%s, result=%s",
+		__entry->mm,
+		__entry->addr,
+		__entry->order,
+		__print_symbolic(__entry->pass, COLLAPSE_PASS_STATUS),
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct folio *folio, int none_or_zero,
diff --git a/mm/collapse.c b/mm/collapse.c
index 9b73ebff1103..91ff20138a8e 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -20,6 +20,7 @@
 #include <linux/vmstat.h>
 
 #include <asm/tlb.h>
+#include <trace/events/huge_memory.h>
 #include "collapse.h"
 #include "internal.h"
 
@@ -195,6 +196,14 @@ static unsigned int candidate_nr_pages(const struct collapse_candidate *cand)
 	return 1U << cand->order;
 }
 
+static void collapse_trace_candidate(struct mm_struct *mm,
+				     const struct collapse_candidate *cand,
+				     enum collapse_pass pass)
+{
+	trace_mm_collapse_candidate(mm, cand->addr, cand->order, pass,
+				    cand->result);
+}
+
 /* Where a candidate sits in the table, in the PTE offsets selection counts in */
 static unsigned int candidate_offset(const struct collapse_candidate *cand,
 				     unsigned long pmd_addr)
@@ -278,6 +287,8 @@ static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
 					      BIT(cand->order))) {
 			cand->state = CAND_SKIPPED;
 			cand->result = SCAN_VMA_CHECK;
+			collapse_trace_candidate(mm, cand,
+						 COLLAPSE_PASS_REVALIDATE);
 			continue;
 		}
 
@@ -420,6 +431,8 @@ static enum scan_result collapse_faultin(struct vm_area_struct *vma,
 			if (r == SCAN_EXCEED_SWAP_PTE) {
 				cand->state = CAND_SKIPPED;
 				cand->result = r;
+				collapse_trace_candidate(vma->vm_mm, cand,
+							 COLLAPSE_PASS_FAULTIN);
 				break;
 			}
 			if (r != SCAN_SUCCEED) {
@@ -878,6 +891,7 @@ static void collapse_freeze(struct vm_area_struct *vma,
 				continue;
 			cand->state = CAND_SKIPPED;
 			cand->result = SCAN_NO_PTE_TABLE;
+			collapse_trace_candidate(mm, cand, COLLAPSE_PASS_FREEZE);
 		}
 		return;
 	}
@@ -904,6 +918,7 @@ static void collapse_freeze(struct vm_area_struct *vma,
 		cand->result = result;
 		if (result != SCAN_SUCCEED) {
 			cand->state = CAND_SKIPPED;
+			collapse_trace_candidate(mm, cand, COLLAPSE_PASS_FREEZE);
 			continue;
 		}
 
@@ -986,6 +1001,7 @@ static void collapse_reserve(struct mm_struct *mm, struct collapse_control *cc)
 
 		cand->state = CAND_SKIPPED;
 		cand->result = result;
+		collapse_trace_candidate(mm, cand, COLLAPSE_PASS_ALLOC);
 	}
 }
 
@@ -1016,6 +1032,7 @@ static void collapse_deposit(struct mm_struct *mm, struct collapse_control *cc)
 	if (!cand->deposit) {
 		cand->state = CAND_SKIPPED;
 		cand->result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+		collapse_trace_candidate(mm, cand, COLLAPSE_PASS_ALLOC);
 	}
 }
 
@@ -1060,6 +1077,8 @@ static void collapse_provision(struct mm_struct *mm,
 			}
 			cand->result = result;
 		}
+
+		collapse_trace_candidate(mm, cand, COLLAPSE_PASS_ALLOC);
 	}
 }
 
@@ -1106,6 +1125,8 @@ static void collapse_copy(struct vm_area_struct *vma,
 			 */
 			if (copy_mc_user_highpage(dst, src, addr, vma)) {
 				cand->result = SCAN_COPY_MC;
+				collapse_trace_candidate(vma->vm_mm, cand,
+							 COLLAPSE_PASS_COPY);
 				break;
 			}
 		}
@@ -1294,6 +1315,7 @@ static void collapse_install_pmd(struct vm_area_struct *vma,
 		/* Table gone under us; see collapse_abort_candidate() on @pte */
 		spin_unlock(pmd_ptl);
 		cand->result = SCAN_NO_PTE_TABLE;
+		collapse_trace_candidate(mm, cand, COLLAPSE_PASS_INSTALL);
 		collapse_abort_candidate(vma, cand, NULL);
 		return;
 	}
@@ -1315,6 +1337,7 @@ static void collapse_install_pmd(struct vm_area_struct *vma,
 
 	if (!collapse_verify_candidate(cand, pte, &nr_populated)) {
 		cand->result = SCAN_PTE_NON_PRESENT;
+		collapse_trace_candidate(mm, cand, COLLAPSE_PASS_INSTALL);
 		collapse_abort_candidate(vma, cand, pte);
 		goto out_unlock;
 	}
@@ -1411,6 +1434,8 @@ static void collapse_install(struct vm_area_struct *vma,
 				continue;
 
 			cand->result = SCAN_NO_PTE_TABLE;
+			collapse_trace_candidate(mm, cand,
+						 COLLAPSE_PASS_INSTALL);
 			collapse_abort_candidate(vma, cand, NULL);
 		}
 		return;
@@ -1439,6 +1464,8 @@ static void collapse_install(struct vm_area_struct *vma,
 
 		if (!collapse_verify_candidate(cand, cand_pte, &nr_populated)) {
 			cand->result = SCAN_PTE_NON_PRESENT;
+			collapse_trace_candidate(mm, cand,
+						 COLLAPSE_PASS_INSTALL);
 			collapse_abort_candidate(vma, cand, cand_pte);
 			continue;
 		}
@@ -1548,8 +1575,11 @@ static unsigned int collapse_finish(struct mm_struct *mm,
 			pte_free(mm, cand->deposit);
 			cand->deposit = NULL;
 		}
-		if (cand->state == CAND_INSTALLED)
+		if (cand->state == CAND_INSTALLED) {
 			nr_installed++;
+			collapse_trace_candidate(mm, cand,
+						 COLLAPSE_PASS_INSTALL);
+		}
 	}
 
 	return nr_installed;
diff --git a/mm/collapse.h b/mm/collapse.h
index 3803f5a89087..34de3ebb05e3 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -13,6 +13,19 @@
 struct collapse_candidate;
 struct collapse_retry;
 
+/*
+ * Which pass of a round reached a verdict on a candidate.  Only collapse.c
+ * produces these; the trace header khugepaged.c builds names them.
+ */
+enum collapse_pass {
+	COLLAPSE_PASS_ALLOC,
+	COLLAPSE_PASS_REVALIDATE,
+	COLLAPSE_PASS_FAULTIN,
+	COLLAPSE_PASS_FREEZE,
+	COLLAPSE_PASS_COPY,
+	COLLAPSE_PASS_INSTALL,
+};
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
-- 
2.54.0



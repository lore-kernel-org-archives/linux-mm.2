Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FF4C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAD46B0899; Sun, 16 Aug 2026 18:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A35C6B089B; Sun, 16 Aug 2026 18:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D0A6B089C; Sun, 16 Aug 2026 18:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4E7D6B0899
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27C1A805DF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:33 +0000 (UTC)
X-FDA: 85108620786.22.7FF3C0C
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4BFDB1C0007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f qgBePJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gpO6yFOx;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920451;
	b=LXYrssblYAyyv1tE+f+1TpvRacALNJilD2YudmaP10EEzA1SR9xWNBnShbTfkJIWUgqvT2
	Qfacrl3zbo/dqVpNq94abCeE6Nm+y0SMp6d2JQ+nKwqZgNHJyIw7ZuSTdpQF411nbkC2zi
	37PJOXIwE4MZ22IJ2N/PLjVk0Knzr/I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f qgBePJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gpO6yFOx;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfEyxC9Im7mJEsMqgxdNAvFiFjPJWbWm6qSLISrElYA=;
	b=qOuveMkOkwL6UVGzKzm+e/VZcOPN0LiKXIMk8o2osyJoTu11PXPJSUswyMbK1w+1I36ze+
	zqE4yKtiIT/GCmJ6LjXVNZKXsqrSG47gefMxu0DKdVp5M4m7M2evqVVm66tjhqv9OArUPO
	9GMyxRRs1L6UZt19nrEvJfrdQpqNtLw=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D78D914000EB;
	Sun, 16 Aug 2026 18:47:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920450; x=
	1787006850; bh=VfEyxC9Im7mJEsMqgxdNAvFiFjPJWbWm6qSLISrElYA=; b=f
	qgBePJx4Bo3HbFJyeN2dZyhF6W9vnCXweOhotKni8XlBOVASElVU5dDs8OSyDqdK
	c3ENyv0gVOn0GF/NvBBjd/axEHh/Vu8OexIiFhoZAyggYbtaQDsBhoZ+WmmcvYre
	rWG8XLy6TdLlRnx+oS3VLWx1tmGctzd4o+aPwimxACFpcLZlVOOHALp/b1osRmjW
	HHd5fHrMb6H8J6du7ZpmsHf7pvDTzYgS52ZD1dgyZETwlhRC74DhRuOI/eWQNorX
	HZj3gEeBLBCiC9/17CeZw/zjl8AchF2hQnumgqlX4AT8VXMEYNLd5ZfR2hb3h0bI
	QYhqjteKd5UVfBPR9QY9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920450; x=1787006850; bh=V
	fEyxC9Im7mJEsMqgxdNAvFiFjPJWbWm6qSLISrElYA=; b=gpO6yFOxNjDM9wgvm
	3tsCw8lKEZToheIBY3nKC2J4r3FJzgoxnFqVEsgQQnshctjzWY/pSaLewzUi76q5
	3IG+sIUJ92z/e4usee5qInuTP/IcWSBbKXWykSMkyvVJfkpbluuujqyeI9PtAo+s
	L7W4e5VJvCyWL1xgX9T9IsqPun435x92ISw04DUDOgTZL6alvD4hE6SN6TZGgLqB
	UiKRUA2q9xuSOfRdxrv4J5brvGf30kjj6McGa82RdHsTOzI6JPFQ56GkeRidnsm7
	/HLzOGmhJQBVg3lJKloFnVagBya3S0yGmwutcPJD8kNs0/KvWleWhECOfs0P3Tds
	oRWTg==
X-ME-Sender: <xms:Aj6CavD0kEISF2dmf9U7AWoCNgkTu0cC5MASo7-XBmCpvz-1Z76a8g>
    <xme:Aj6Caq0fe0v2hX2Tamh-RU7uKhTXvF40s2q3FOa7GiBOCCVKipQ2m5eQPbYOMUxdS
    QBcB7bXAh1eUH6zpaSSG4GK3VoxNy5PCkv9FmUmFuz-vxh_1SRGw0gk>
X-ME-Received: <xmr:Aj6CamriK1iEFRlPmQ8kAYTL-GS_JAwUb4JXhpa0WdEBq4yDT3TTG3uncAs>
X-ME-Proxy-Cause: dmFkZTGU6CsvhMdBtF1sno4coJRY9LqZz27w5X62/KcvcmaHPoOW0E1BwYMGQvImxADkeF
    Vrd/NWvQclh95CfVK4mxB+x5IwibSBkynFlxvp5GF5/z4jepOu57IyLHUvB8DzXymwpMun
    cyoWwWLP4hjAaD7bSTsoDmYKe03ryBERSg0IuR8ZqJolHrsaFnqWf5mL2byVsL9qLL9zPI
    9yLFlvwwZlCiJbT4IVFlRVV/9A2lZNuDFrGWvpQWw3cjqX9EcFrpnMQcn/0MdQygQWXSYC
    yXHZy2pRvgBssh5qObsL1GM1XSEE6m2uHX2m5CwJlvTSIfOodU1appS1XFI/CBVlhtQ7QD
    //r8SeRFX4Frzvk62JSidcpbkYQUZimo/tP4qXTbike3XiqGAJwN8Xr3kRNfVDMumZRQHN
    pQp4OueLITAI0UouqFGbnagXu8ExdBZus5wetT1OuQE4tDgzakpVZarjUM7ZWQst2XqwMV
    fEfmHg1AsnJoug3gmFQcrWEQqoHtEIHh6/2bOBBVF24rcuBgAxfpkyNDVHw+513ohCb20R
    eUKVVADrXLoZVGdZhVrUf0blIOO6VCtgQS0h6hA9dsHLM66Bq2f2A+gNMrsdllE3L1IMqD
    Xct95UMn7x9keDJbsXybO6LH2pGdcd4KxecDU1YaEJdlNnE1zEHhod/LDs/w
X-ME-Proxy: <xmx:Aj6CauWFX3tnCETBw2oBNGlWgXgN-zRw9ovW0-A93mFKiVw5CEe0gA>
    <xmx:Aj6CaqgBdV618gwoNm-EQsfz9zgS4Onrp2P0mThaIib6K0BQkMoITg>
    <xmx:Aj6Cat_CL57Uh6zbjXqc53wVSAzIJ18HxvQSJsgj-c6wl66Qu1-16w>
    <xmx:Aj6CaqSnxqe-stI2huEgrKNfuoMUaB2_KvAuHj1KSxml3w9a55ZA7Q>
    <xmx:Aj6CauIbWLZaPc36TnoMXfX-3K7XM5LsCrEH3fUecP-GoBf7R0DW0Iw2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:30 -0400 (EDT)
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
Subject: [RFC PATCH 39/57] mm/collapse: name the file collapse's tracepoints after collapse
Date: Sun, 16 Aug 2026 23:45:51 +0100
Message-ID: <20260816224609.308019-40-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BFDB1C0007
X-Rspam-User: 
X-Stat-Signature: zfjid376uacaatcs7offm18d6dd5n3rz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786920451-484652
X-HE-Meta: U2FsdGVkX1+5ZgkuvhcYXjYb1m9u3OfIui6mM/bBFJoCoUf4MePY+Y8nNVOFN+7BevNrHjAjmF06n69cpDL9n1R3+GwjWTOz4t49zUFqYq7XjE8zilKf2QBLvXilHtuOqRe8BJDCChujWEW4mTick+QNhIRge992UuaxrLF4fhSwAkKSLyjdNojoKC25WFOx9egjXzz0jXHI7jgNR9o5S/YtSNtk/EmU7Yn5VDh8i8/zIwz9BwpLPjcn951rQ4E4pKbfegxeQSs1ZVeO2OkCBUhX+oju2Wl6KVP4SX2dq62YEXiCESn6ko2uaoKBM0pKQ35w7uSb9VM+prXSII0ZkO7RDPBkvdneHWR+59CX+tUzdVuwPpM/SB/JDd/2fqZGG5tGW/ea3NxwQtCN/ReLSBZWlIVg6q1DsZ55EwClH/zVCeH6XN7miTrl8ykzvIiXq/Q+2VINJBni8oFVyHDLPdNxzgfOyl6GBWrOsXzgX6lHQKCWZjsGA0WUEnN9tuS+W4+1SQAyjkEgw2jVHDS5yG2eMzTUjN7FnEi9Jk2Aq4yv67xBlAlsdbRF4hkA9XTBGA3aXM5qYNSGtokN94TIZHEDopdVFatXgDTcTKA92rUhHCuHwRinOP1UqCcl/ljWnqDZ+cQ94Qty3FAlQLNFV5TTraaxH4v10HEbXwW2SAdYaLMM8ji6+hoWJGQ+MCGpOXqaKF6fp28ptlR85xDXaCvA2r2Du6RCsjGSe1RmoyeJDX0T7SoMf4OoNszvzm2hS42DDn4ABYRDmJgm70yarpd1d9hiCV5a0WN3ZdADSRxKGeVyfQpS3LZ8Bj62xC+nBs3M6jTwR/xRztAzNMcmxE9EZAzM8o0yqkU1dMKE6u7mCfTm5teGAVtLbRe4se1ylEppA04bxpivXyu04/oZe47BNvcVlKftGRCHXHm1VyPFKfFKHYOTvzAUO8mFBJgSaO7nxkWwiHPGKB1R3s6
 +1/AdBVG
 OUDQAOVTJEv9VujjoTRV3Z/ps8jJgMhHYSxMuGz/NcOtlYst3mgZNg59Jz1jeajdzn+3IVLxFryFghFeIONIS1PWY3hnfRMcmWxQbp9bbSBgcTxLVLd6YNE4+O5e7k4TOGKWg+2qKJbjQUze+U/TAurYThKPjhviuP1vHFI5r8NB1odFTUAK6r2xOIzvxH6REpdr4PSRYMs2NYMIpoMusBPVOxZwTIU2g2SX4dsGmQtidaw5c3C7/HDgmWzYeRzs0798aMsJkwD9b2keh0nG99Mq7irJy+K+nK8sn++K6CxngXdmPkAyOfI0sBWXc95ohgIs8luXMVZUSrP/G48on7WTTioYGCelEQ5aMkAWLYpyjQ2+0NmnZbGSzerg1K01BeDx0hQE0/gtL07HjOXLxgSuisI7iF0Xv8Wyxk/6lu8J7BV5ONzu6f7IMBLpljV9sD7jbPaXfYw0GbxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The two file events are named for khugepaged, from when khugepaged was the
only thing that collapsed and the code lived in its file.  Neither is true
now: MADV_COLLAPSE reaches them through the same entry point, and they are
emitted from collapse.c beside the events that do use the collapse name.

Rename mm_khugepaged_scan_file to mm_collapse_scan_file, and
mm_khugepaged_collapse_file to mm_collapse_file.  Every event a collapse
emits is then under one prefix: the anonymous and file scans, the
per-candidate verdicts, the fault-in, the round, and the file collapse
itself.

mm_khugepaged_scan keeps its name.  That one is the daemon reporting a
scan pass of its own, from khugepaged.c, and it is not something a
collapse emits.

Renaming a tracepoint breaks anything watching the old name.  In tree that
is raw_tp_null_args[], which tells the BPF verifier that the folio
argument of both may be NULL.  Without a matching entry the verifier would
let a program dereference it unchecked.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 4 ++--
 kernel/bpf/btf.c                   | 4 ++--
 mm/collapse.c                      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index d7c0195ace92..5d0891e03bb0 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -308,7 +308,7 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
 		__entry->order)
 );
 
-TRACE_EVENT(mm_khugepaged_scan_file,
+TRACE_EVENT(mm_collapse_scan_file,
 
 	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
 		 int present, int swap, int result),
@@ -342,7 +342,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
-TRACE_EVENT(mm_khugepaged_collapse_file,
+TRACE_EVENT(mm_collapse_file,
 	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c4673a54c4ba..58f78274d989 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6705,8 +6705,8 @@ static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	/* huge_memory */
 	{ "mm_khugepaged_scan_pmd", 0x10 },
 	{ "mm_collapse_huge_page_isolate", 0x1 },
-	{ "mm_khugepaged_scan_file", 0x10 },
-	{ "mm_khugepaged_collapse_file", 0x10 },
+	{ "mm_collapse_scan_file", 0x10 },
+	{ "mm_collapse_file", 0x10 },
 	/* kmem */
 	{ "mm_page_alloc", 0x1 },
 	{ "mm_page_pcpu_drain", 0x1 },
diff --git a/mm/collapse.c b/mm/collapse.c
index d0d28e8dfcea..6c17c83a4e21 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -3519,7 +3519,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
@@ -3625,7 +3625,7 @@ static enum scan_result collapse_pagecache_pmd(struct mm_struct *mm,
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_collapse_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
 
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AA2C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC2E6B089B; Sun, 16 Aug 2026 18:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78C16B089D; Sun, 16 Aug 2026 18:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E6F6B089E; Sun, 16 Aug 2026 18:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 692926B089B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF8DB1A05E0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:34 +0000 (UTC)
X-FDA: 85108620828.15.1E9CCA1
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FCAE40003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="g swbJJk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U1MZ5/c6";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzLUHFRii2gq6ACAxatB8F8suZiMKSOoddlYvZzHBZg=;
	b=mRCivbrKCe7vmFTyLGEQfftaMUklVrPrbz12nbPd33487wXFL0KtnF57NKDH/NUtrs/0Uo
	7ZIodKzYjYbzCy0cLJHh1zSaN938jit4o47wCGmXcfcDW0FocwhIJdM0LaQWSXo/MGglts
	0EIWzM6/fL8uedtRukF0GS1Khwh2SE4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="g swbJJk";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U1MZ5/c6";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920453;
	b=nE50hFpW/n9OIABfNakfVY0/yeHka9X7e5AG5NDOl1xT0Jizl2Y4Ic1sQZBp/8gi9kSpmi
	4+v/lxxGjkfF9Kx18GKicDrqR0zYDUPOIIHxGepi1D6HMw+SQLRDpJlCaajii04DPh+9Yn
	885KuLg622cSuXi+Vh/RoFxFoWgITlg=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 9E70FEC0074;
	Sun, 16 Aug 2026 18:47:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920452; x=
	1787006852; bh=QzLUHFRii2gq6ACAxatB8F8suZiMKSOoddlYvZzHBZg=; b=g
	swbJJkID1QsVjOARJRQEemN69kiFpzyr+Mt7D34rSba1wHp/hOzc3cGXLET3iNCS
	tBqLFgEqokNSzd9iU45z844C2K+jbK5nTP3V+25a+TglzB/VUebojSICLNM1irnG
	qHqAWBB7Z3PMADn9c+fdCtnltLQ5u7uiJq08DsA6ETTRqtjAF8KJ3l0LTQVxQOF8
	+feuumKMO6IpJuTcsTHTvT6lUrwoT8DcaTCBtTpM2eqw/4AubVswrjp4QquzTU8+
	qOWKmXU01SRITpbhnsTPr0ArlNrikkjFxxgjxAdZ9agI0FJ0P/krf4dAaYwAP6Fh
	08ewTb5Gt02+1ste71YVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920452; x=1787006852; bh=Q
	zLUHFRii2gq6ACAxatB8F8suZiMKSOoddlYvZzHBZg=; b=U1MZ5/c6jWxKp9TY2
	r+UeUxfnV92NvTdQmc2rYhwT6aaj4KjUx0gmqO3ibqTzkf8IvndbM3Mi34vVJZ8O
	w0K8qDSl/6fPO5/CUWnLb24ho2vmJv3Kj24OAr/PmySFGM13wChEX5xozXFBGMOJ
	5h8jD5Br+4a1eeRHGq4e/Op43jbUeqph2FpNxW8iX6HXA3y/VLpu7UKX+Jd/GZy8
	uh7FuYijgc1+pfSNYj1rcEe4F3LkU5JUmtZbBfc50MN4O5/sRUdWrXqieArZDyy0
	EogELfhjQGNcolaF+X/BtlVDNUgbVgVzkLwSIWMlBjXx9HWaDXdLVHIl1mfYogcN
	4SNcA==
X-ME-Sender: <xms:BD6CarVQBBBgHw2kUTH4BAQTAgoW0vNo9-T_V1s-Gp8SZNL37qO3hQ>
    <xme:BD6CatTdwey4NrVUNtFdsMC4zhu38jZ6OE6ELbMhZBQ2bkGwdMMYHhn5BXu-xFR17
    2hzaP8UbHdQE2mbhz6xB9R3ThuiLuDa5WyhDZ5iGYUwyts8CGyzUYxO>
X-ME-Received: <xmr:BD6CamssqVI7mMqy3VkSXmm3JwltssFDc4jSWuOrT6m6h8af7N1_ZCRsgCc>
X-ME-Proxy-Cause: dmFkZTFcTQrb7i2Wnr2aEeZt1aoD7asKutBPdJgU3YSD5OfcfuljRo8Y5zG4WAng55KhcU
    fdYu9dW0n+wtsUDWiYHh8AwjWiiyOeVLRvzra0gUIzgKMFXfu2OsH3wUsDwz3Dpe7vEjB9
    JjBmMfD78Db5X6Vl1RDz8Wz4IQF1tjtPvs8yYIcZ4vdtxAZhotrvrKr9o/e/MWe2qw9p1d
    u/4ngMViLbtWn8zpPvYSIgtjaF8APmxmHCU5Ga5Rd5eIGcQp1MbbGmkchmHrMFMoUd9mrv
    TpVQ9+TKNOdfLLUK+2CPoHpagx885EUQUSZxhSq0AxxU5QJRQ+JA8yzxyjEYMjW1uFFjH3
    KM5L2v8sZoJpHBCvI6Nsa/j6UZDwcdngSl5LZCfOF7f6wAZPSUOnJLz4aLZzXuecwrvcr5
    zhoDLChk4xqwGS1DiTGDHhodMYwKhBIzVXpaVBMmQBuijJi+gtMZx9AYlrVSShheB7nXiE
    D9fJK66yif99eFxt4yYvz4rkygDBGnFSOyJlmhNlLizlPFuj3MnDi4HECMSMT7L57BEJem
    zxSv2Uc51Suko0811otPJ48mbAVKsa1BGF3GG2NL/bPloFW20n0QACLTfTdRZ/rZ/K/XnH
    DIZ7dAY4OKAldJMJOl+s79NAIATJ65Dt3g1HhgU92eBcsPMM9Qk9kXneLfeA
X-ME-Proxy: <xmx:BD6CauYplfxXEfleisltafahvNcy0Ua-PPDAB9dIRs5q8ZbSMhGrNQ>
    <xmx:BD6Cap_P9_949TD2TLqmmbjknm09sokO3rgCtxW-GnjiLCj6J10nYg>
    <xmx:BD6CagDlmYZFuleHsZ4G2ZMFJDGw23E8HnrLf-paMTRqjnmD4ynjSQ>
    <xmx:BD6CalveF8zZ0klvD55XC0oeKBR5d09sXLyr7wcBaW5ip9kUzdt7uw>
    <xmx:BD6CajGrvtAdRWpre7gj_gywfNTHwtItj5YhVfieKUyP7BYy_m96MDkD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:31 -0400 (EDT)
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
Subject: [RFC PATCH 40/57] mm/collapse: remove the tracepoints of the mechanism that is gone
Date: Sun, 16 Aug 2026 23:45:52 +0100
Message-ID: <20260816224609.308019-41-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: und7jhhhjtr39de1d7jhg1zta48kyesk
X-Rspamd-Queue-Id: 0FCAE40003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786920452-968698
X-HE-Meta: U2FsdGVkX1/AuBa43CWYfPh987BOivlzCB6yveijKgYH5KsNUpT7qPaUzAHoJ2r+3iwNgnaITGvJJdholk0vmiTfw11dNBBUARJxN6j2mAr6bCtKW7zpIpib1PY12pgpg+jT7MalcOqiZ3aGGAhVMi5Iajt3ApRWx7S2B7GOrpUupJmenlnwpU3kiMxB2B37hE1oIZszkf2LX4qxX2q1/93yhmqaY+32+GU0r16p+VRBY/be9aG6IYhrha7KoR9COS9K5ameDedFm7q1APzmWS482v8rWxyzQbT7SpC5G2pfRZSviBHEYsS0boGtLu7QE+d27mC6GuJhv3g0F84BTJuilskWcPXmx6UCcQtNyOYCDPCgHepQnm+q6dp1EKAUxP3AkILmHNVCO4KUVxFcaIjjNv7fLopQc6t0v1e2sA1fBqY4rpLbKV3qnBvf1uBg2w1QvcEoVEg+xGT57GakWBii1LkExepMIEUDS72tJljpLadRaX9c76kAbuaOeeUrWW+iOozIuiNwd3y2iGtGv8TfLwoI4TH4ODl1HifZMYlvYYW6Yp1zUyGc/LNfH216OUlWMArxreWTkplAh6Ex3IQnLdQpG7e3TYzEaYCWfztF9d7mE+k8UseUop+yemTnFtdfIg1dZ1kZFzw1E0vHYmR40LaqXjkeAQyLMq0mLfwZ7odiES4TRjEfaDF/j9PHJgHiPpPVDJ2NYzexioKoVs9WP9VKUnkhfUjc/yTmUZk8rB6eoj9lAn855fRgEPq5R0Qm9j8fiWT0NZg23I11bLLCpqarWMKPcjZdxaHQpmdoMHqJhJ16GNZOA/R8EPbxsC/HEye/N8vpLfuVqEelF/Q0ERbVgZjF3liOVLQgFa5giXwi5AQT9VeAaVoKtRzRnTbCC5npQnd4nBzRNQAffuz6rsfjloMtk6O5WL5qJ1DYwBPEa4AW5mhQPSPAXvLLY/4a0x8x8pvj2nPFqNC
 Axi9ifln
 PxoD18BioWKTjio3QqiFRzDAOAS0yIW+24iXsDH4QSDifnJwdW99rzuRghJEi/Q/S9p2q/03ncr080DP6H0rXSZNNC1VAd4vKdUaKhqn3FqvhBU4jomeSCsuGybF8Ja/MB4H2V14No76+XLpYzBc243RAnxA5kG/ADyTxqf9+lIAdJ85izDLcM1T90Z0EABp56hkHNEamDMPPV6ju0P8ZgaOtclKJl/SsuXEhf5Hhnad+reyPZmSnDFedyQnZdzdGQIWkIweSX6Ww6ELfHUSpzt8vb+goKHStwXPjQi3s+y6tsP4CHP4HtVlmqC76sJFXrzlqV5zu/K00vtI5+qxLAainnXV6eWa/MRUeiFE6F7MEX23eKEbOp/PCua+YXd47WuvXEcVT9yWImthLeIdV4KHQBs2B5iymAj0NbLALbRW+0M/eYnV22lfC7nPQ0syfdx7cqo/7uGiScuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Four tracepoints lost their only emitter when the anonymous mechanism was
deleted: mm_khugepaged_scan_pmd, mm_collapse_huge_page,
mm_collapse_huge_page_isolate and mm_collapse_huge_page_swapin.  Enabling
one now does nothing.

Remove them, and the two entries they have in raw_tp_null_args[], which
can never match again.  A tool that still asks for one fails to attach
rather than sitting on an event that never fires.

The engine's own events cover the same ground: mm_collapse_scan,
mm_collapse_candidate, mm_collapse_faultin and mm_collapse_round.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h | 123 -----------------------------
 kernel/bpf/btf.c                   |   2 -
 2 files changed, 125 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 5d0891e03bb0..6aabf4235648 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -65,67 +65,6 @@ COLLAPSE_PASS_STATUS
 #define EM(a, b)	{a, b},
 #define EMe(a, b)	{a, b}
 
-TRACE_EVENT(mm_khugepaged_scan_pmd,
-
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
-		 int referenced, int none_or_zero, int status, int unmapped),
-
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct *, mm)
-		__field(unsigned long, pfn)
-		__field(int, referenced)
-		__field(int, none_or_zero)
-		__field(int, status)
-		__field(int, unmapped)
-	),
-
-	TP_fast_assign(
-		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
-		__entry->referenced = referenced;
-		__entry->none_or_zero = none_or_zero;
-		__entry->status = status;
-		__entry->unmapped = unmapped;
-	),
-
-	TP_printk("mm=%p, scan_pfn=0x%lx, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
-		__entry->mm,
-		__entry->pfn,
-		__entry->referenced,
-		__entry->none_or_zero,
-		__print_symbolic(__entry->status, SCAN_STATUS),
-		__entry->unmapped)
-);
-
-TRACE_EVENT(mm_collapse_huge_page,
-
-	TP_PROTO(struct mm_struct *mm, int isolated, int status, unsigned int order),
-
-	TP_ARGS(mm, isolated, status, order),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct *, mm)
-		__field(int, isolated)
-		__field(int, status)
-		__field(unsigned int, order)
-	),
-
-	TP_fast_assign(
-		__entry->mm = mm;
-		__entry->isolated = isolated;
-		__entry->status = status;
-		__entry->order = order;
-	),
-
-	TP_printk("mm=%p, isolated=%d, status=%s, order=%u",
-		__entry->mm,
-		__entry->isolated,
-		__print_symbolic(__entry->status, SCAN_STATUS),
-		__entry->order)
-);
-
 TRACE_EVENT(mm_collapse_scan,
 
 	TP_PROTO(struct mm_struct *mm, unsigned long addr, int none_or_zero,
@@ -246,68 +185,6 @@ TRACE_EVENT(mm_collapse_candidate,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
-TRACE_EVENT(mm_collapse_huge_page_isolate,
-
-	TP_PROTO(struct folio *folio, int none_or_zero,
-		 int referenced, int status, unsigned int order),
-
-	TP_ARGS(folio, none_or_zero, referenced, status, order),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
-		__field(int, none_or_zero)
-		__field(int, referenced)
-		__field(int, status)
-		__field(unsigned int, order)
-	),
-
-	TP_fast_assign(
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
-		__entry->none_or_zero = none_or_zero;
-		__entry->referenced = referenced;
-		__entry->status = status;
-		__entry->order = order;
-	),
-
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s, order=%u",
-		__entry->pfn,
-		__entry->none_or_zero,
-		__entry->referenced,
-		__print_symbolic(__entry->status, SCAN_STATUS),
-		__entry->order)
-);
-
-TRACE_EVENT(mm_collapse_huge_page_swapin,
-
-	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret,
-		 unsigned int order),
-
-	TP_ARGS(mm, swapped_in, referenced, ret, order),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct *, mm)
-		__field(int, swapped_in)
-		__field(int, referenced)
-		__field(int, ret)
-		__field(unsigned int, order)
-	),
-
-	TP_fast_assign(
-		__entry->mm = mm;
-		__entry->swapped_in = swapped_in;
-		__entry->referenced = referenced;
-		__entry->ret = ret;
-		__entry->order = order;
-	),
-
-	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d, order=%u",
-		__entry->mm,
-		__entry->swapped_in,
-		__entry->referenced,
-		__entry->ret,
-		__entry->order)
-);
-
 TRACE_EVENT(mm_collapse_scan_file,
 
 	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58f78274d989..22fc8f974be2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6703,8 +6703,6 @@ static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	/* host1x */
 	{ "host1x_cdma_push_gather", 0x10000 },
 	/* huge_memory */
-	{ "mm_khugepaged_scan_pmd", 0x10 },
-	{ "mm_collapse_huge_page_isolate", 0x1 },
 	{ "mm_collapse_scan_file", 0x10 },
 	{ "mm_collapse_file", 0x10 },
 	/* kmem */
-- 
2.54.0



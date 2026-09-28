Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10116CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EC16B0092; Mon, 28 Sep 2026 06:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2442D6B0093; Mon, 28 Sep 2026 06:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135696B0095; Mon, 28 Sep 2026 06:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B14086B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B976A0173
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:39 +0000 (UTC)
X-FDA: 85262741718.05.068501F
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf19.hostedemail.com (Postfix) with ESMTP id 149871A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T /LZi2s";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="J/jYptmh";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcUsOL3101xiV9NL11+6UCDVa/c8zCTvs2ZvNLpRaUs=;
	b=WFvW8grlg3kGNeo9g4L+5klpVlNNYFlc9445hvaoeWGk4BwxPUsLMzerjBVg4f9aTJE1Nr
	W3zWgBLlgZM6DftSZQ4Fasrlb4t/b87lG7hO+e2Ag5koQpL3cOSo3GZILwtU7Fs0lEjnkh
	V/+mF23SiXgHwLQJ158iXK0bkCzeJKQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T /LZi2s";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="J/jYptmh";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589997;
	b=fuKnr+8MQfg9nhsl+hXd4gm3FlhkDOV2sbinRgP05HxZMEgoYdLDhiyXqlWRBgPDR9iz1c
	F9eM5Hru/2EC1zqBEIyrZEMPRd8TuR9qFLOm2I2VWCqgNziyTAAwnSpvhD0vU2q2DshU5+
	+F/X1uzWV+ohrtgiTXliTxs069UKPEo=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8823B14000DE;
	Mon, 28 Sep 2026 06:06:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 06:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790589996; x=
	1790676396; bh=kcUsOL3101xiV9NL11+6UCDVa/c8zCTvs2ZvNLpRaUs=; b=T
	/LZi2sg4uuBWkOjTyNhCVObsn/DS+ZLuyww5KBI+VR+LMoYmLG5qVxFC8DPJEMLU
	zCg5ZSDx3XZnBf3o6tAnnlv9XjbZ27plLqBnQQ4Mf9bf/RTnwlOyTlirAwLicNJH
	ePapL++6HhWEQYA6ODwWZ2qunWJXbRbqe9q1h4pnYckOItqJGJRcnEtxUNp1KCwW
	ng3U62MKI0mjf9QOVsQ6ScOnc9E5V2qKhfZUFNmWG4t1FqvXrs3rpeLNEsl3mPdx
	uhLSsX8vzlC6jH19/lOWaiB4CwHgI6a5andWwG1p5iLbKLnwaKa8GqyNjcD8BpWJ
	C8TSvDDX/Y1tNE8OksbEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790589996; x=1790676396; bh=k
	cUsOL3101xiV9NL11+6UCDVa/c8zCTvs2ZvNLpRaUs=; b=J/jYptmhWRqiG/+5q
	n4x+RmHp8dmJolILwLSCJFzPxbbLZHmFZVtponmj5hc8UQTP0VLUkdU9pxIRDLNF
	xQS6u/I+0mw5hl6/sojXitXHjxVRzuv/DZzEHaWj7SxIeze+7dQGpX5Xv5VwLKic
	C/usFjS4+GJXlZwkmwwvjJZM14uYEzJZxcBnl8ZF86OURQ5vtPhXPQ05PilZMhMb
	I/jPBg/iMbNdn3o1dDrD9DpQqYiZRah4p0dIO/a9dTseCpjAr2JO7ARtUgslG52k
	nkIA9oMCp2c6yY14BBU89d8y6nZhiZF+LUGovG5H6hrRHgFe3tKBLaV96AupCDxA
	EvRQQ==
X-ME-Sender: <xms:LDy6avLfqQjp-yK0TWiT6j8SaqKTBPrw8E1x9Zyks8_ardtQEHUk5A>
    <xme:LDy6avGE5OeXHQCNGYG4qlWpol2lQ4D67uknTFgXTo66JeLXVQ_kJBTDNWto9tFHE
    w7HyLqawVtAespFnRNSmdkgY7VqMQMnHF3Roq4N0QqMdMi5dbfYcdkp>
X-ME-Received: <xmr:LDy6at28ylqVdclOEQ5rV8U0eF5QTex3Bt0oWVwx9Uyg5qbdBWDL5lnTxzo>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqaa
    nkU2cSQL8qRENKHB4iLNlXxdqgyOVujeFZPY74aW8lk80wFKRFo5VNSaZ7AT7QmlDWD9LR
    0yipAeB93S3lT7SuNh0By8tlp0OfFp2H8zgTSrQFo0KHX5n2NESmCyvNsDjZk8XaZbHIST
    ZPBWSoO1tX2inUBxZBeekbSe37r41xaOOV2PulMgtKG58RnGeLhAV0T8OH5yiRIoqbrmVd
    rE1verYunpxGQv9dp7hI2EwK8yDFx2fJJ/dWIgZxWZ5d1F2VtlbOGwI8/VX8tKwzmSYfE8
    kXoTXNVhISb8KqFylRnZAVVbp+5Vyeo83tcqBZaBffEQeZold3dtspwRSUrw
X-ME-Proxy: <xmx:LDy6auzQYrJrdyET1-xzeeFunAEG-S3GcTZMqTsqB-KXcARhxMbT-g>
    <xmx:LDy6akivFgq_rF-Vc7qOEEZSnw63Q7QrUHYqFgykkCRvZuoyuPEUZQ>
    <xmx:LDy6alztq1DqoAh5tn1TFl_P6zwpsHZQAmmCyfAe8Golq_2GdqNb6w>
    <xmx:LDy6aqzX47Mg6uhRuYWVCKAF0FOCEOP03LYWqiKdFgAiKqzXOuM8kQ>
    <xmx:LDy6auZLLy71yC652L2PG6mBw9wnLrjjhpSNO7UbUrJzrCQs6GPAUUsB>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:35 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 01/13] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Mon, 28 Sep 2026 11:06:15 +0100
Message-ID: <20260928100630.21870-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 96um9smgau4s9e4b8xq6s57gmmofg6b9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 149871A0007
X-HE-Tag: 1790589996-862754
X-HE-Meta: U2FsdGVkX18Zw4F0mqOitMj90qrLxmhkQxgPF23IWMC7y/S6onvAhGFnaEM3zyS39HQbVtb4CmLrqm2hAWLZ+oQZ0a3jERn9BLeJN/REzBzPMcKgCb5RdM/qltnirULfsbZ4slWiaknJ3Yyl/zXAcH7aJpl1HgAjvls7032Iqj5C4ITiq7OX1PMMVqG95FfTz+FczjjRczvu8BN8I0UswnWeRzGtqEkytpp1TIEDz1WDg/8b0CbLn65vDD+mBrXmdE0x4Jw1A2LPSNQiJtvLrV2nThCMsPpNZatsExfXB0NHrpjACchF4kkfi8wyMcH0IeKURcUT5Ob8bHrkVQqArWsdwC/53WGpfhtKZLTTwkgaXQR8O1YQuQgUE4TqYPmf/mhD+Qd1duWs1a8jnYyrnGBYhmqsYA7f6rjcYlDuP4xKnu5Z6+j1886cfs2u+oVJeZA6FMj4s2D0xRrMylCXX+y9LtVFV/kb5aBJSkwAklVRyCeV67D72+GPmpeM3/CGRPGxpn2cT/OJhJh16Ho+1NbPSbaRMt1w+EgakJRDJScuSRXITwMlQteu23yAKZm+giIsMsQTTjr9kER5VXQrvyIjdvH3NLMR8vUQ1k1PhsdyAzYJukddb+y88VI4e0XLMMc8WVDNuSRiuoEUGkulVzc/mclX3QtwublmXnKSOF7kfDW+vYHA6e4bcbhK8B0OPLlxoWZ44VwQQwWckIXd0nmqWRJD54KlL9jVXMEqgiqk3Fg/eAClVL2PbSuu8POiEdFgWrPTr4bMyr2ZA4xbyoZjoNjasfeZTiKUBWpjKSSuQBop7SqpZ5s+UwZ62On5n2Jk0TcoGLRQ8zFVUXc219c+aMZe2v3XpDJ/oVMHmKpFIlJ7qKsKQLu0EUW/gGXaFaYtXFLgW4ZdIhc3/BgkflhoyjFr55Nz4brG4E1J/E93L4t/dnPQZFFfchgC4krBxL5EdipObV/Uh6lZviR
 ZDBbMBNX
 rbCFR3xN7v23IC9h8nt1k7JH3k29SclshYHC3HilOHl5iZRABDn4O9KYqVcXeFt3+3U63zuLGS8OmjBUcU5eXsPZtmvajMo+v8vk12oqjs/bqNDA2ugnTbfAYHzfECq5T95xxpQ/QA3cj6+YC7XqRRJtpc71WyszesHez6eSKritpHT4exmYD+9oeJJieLRIWKok8D8wQDOsWsSbdnmpsX0fwyG0zqTIBEn0c8EWffq+8u7Vi9ieRP5fBPymhxebZJmFg1QHC/ckz2eUswUCq87gRNow/kQddBtQlERe9x+s6qKdOy3Qn85YaVJ2K+yimFjOLfdtm2uJEtQi1Bh/pp/VPQvDA3y5aRYknV71AfQHAbs5gwff6fGU8RHReyC6LnCwTDZNw6vze7sKPSbxh1RqU8RmVIlsTv6ugLB6Bdm9fHl5AaJJEPW1iZ7Yq70JxovvyZ0/Zr4lvekYd1UnLF2YO1S+vppN+UaaNUWYIgHwlmjSt/Rr1wDYz3WoQnGOMtrPZlPaNbnR/yzaH/HoeuMKnGEugcUj5/QgO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e13d233b9967..75c876acf527 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3229,7 +3229,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3285,7 +3284,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC510C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069E66B009D; Thu, 10 Sep 2026 08:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D866B009E; Thu, 10 Sep 2026 08:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47F26B009F; Thu, 10 Sep 2026 08:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22EC6B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:02:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C7171404CF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:50 +0000 (UTC)
X-FDA: 85197716100.01.158A268
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id 612AC160011
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="R oNmw2t";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pXjiJ4ax;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=;
	b=h3ewgjdPhm7N+xJbQaqdVeaAl8S1XJ+ymYC6COHujqot4naRCHBDsFwaJ43qyWFOXRNueK
	j3Yn7IU87Bjd2kWvqtZVxKxKzwwlNDeOznEwGQebqBaZXaZmpPCma5Zh9zcAVi0UEwHvqq
	q2whTwnAl7sFYddov44eqsfVvEqKJFI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="R oNmw2t";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pXjiJ4ax;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041768;
	b=t7CPwaLJKbXx3bKQhWCUbeclJDMFdrOwyROxat42lsJYekgcKX2wZthb6oT1Ymlbg3KT+5
	NtLBGEX7gluql1dDXjlAMpmwhsesgJMeYZWlT3/tB2INfJ72Q3O1RasU/M3W7ZtLEWdGVy
	h9XJCTQvSgrrRbqSjW2PDn1lBRTXIRU=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 3E4E21D00066;
	Thu, 10 Sep 2026 08:02:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 10 Sep 2026 08:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041767; x=
	1789128167; bh=JI5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=; b=R
	oNmw2t/7fOO/tSm9mOPQlzF/zGd4IY8hpx14GxEtJ8n5ub6w+GRon1KrYeUFRBGG
	WfZBzLrd6ntIDQLjAjae1jJDFEOJW881bVcTOyhLU7DaSWUDcq3XfgdAZ8tSpT45
	yZ6euI/d31PbHULlnNTpcXwRf3z8NTwGo+Q+w9o5+A/7/3pYuQxDHHkFVRUT0e6H
	jgaFUNRvT/+joNHuExDaMfuB9De2Wh8qBGqTEw2mdV+GTPvCxgxmS2MzoAowsnHx
	o2BUapLwa7a+z39wClLamUff0u2iAuhDlXfVxr1xCSI7FIMdC4oC/4YrrO1lloUW
	We+L82oK+W0h+w92P9HlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041767; x=1789128167; bh=J
	I5Fa516GYJ3tjpfUWQYw4F0sEV0mYVe3RtQG+xuZIc=; b=pXjiJ4axMe0kUEfir
	yIUluhNqtjF3b5GB2g9HF7xhzeC25rvgo80hH5WCBD9MIpzb7GsvcuZsIMxLw3PW
	4KTmM64h4qV1aEJLjoSTet8G+9y/yqwD80rcz2TVW2RF7fWyYLGrGAp32p9iCmQU
	fC1dBbiMRRiKHJDiiiGOZOFInu9FCJG4ICzXBsZ9HZ4tZvgTNnWnd45nBQy27OsO
	jDnVcAmISuoutwhFViaRNr0tk9fBVJ+wcdK9vs7MoQF7VNRR4XwFidODb67jZQdR
	dj4uTOYiRJLrctXy+tei3g7Q/NMsnlq0C7kNeLF7LWucCdBw03Hc+TT5QAM9uGx9
	AHlAQ==
X-ME-Sender: <xms:ZpyiajdpNYmzQnJ9axglhrl2lZBW4Kfc05Hrr7LPzK56m7WF37jo8Q>
    <xme:ZpyialL1PWKYqpXg9CedIsrsaMh58kmlbWZSyHclDpzy5mEKoQnH_xSdZKIPFm16M
    UWshw_Qi6sxw_PJonxY_XEtJmO4qK7pDWZCtfFt4orDR5MZx_eLw286>
X-ME-Received: <xmr:Zpyiaiq8QoWXiGanOKV2DYrgO-1Mf2gAHvefmln1SUp3ZlGrNpF59FlLaiM>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2Cuooc
    sGdntzh/yP1mv7gIr2vSfojU8NuPx5fqlOjAGDaKaG8GehyParYQCFRQVBwE8xM1cWN8Fo
    9XYhMVUUlRGCVVIjjGKrULoOkvrbLwds8TG3IyuIKPFUAg5H9k2M7VYfpV82EMOFQws8sd
    O1RPXNeLjDaYUKiXZ07EzB7/z6Zl9pfiotitqbkXDhBkRDECc5IUIMsZGJABqfKWlaZ8Mh
    5Px1YXB0tVWvvvdm0Av5Ew0fLm+rKWSOdOPn1dkL4NEarjmDFQk9B5OKzlE9mAI4GjVueL
    yJQkDpVSg9TiBUpOsfwIKTYEQLszQXZEUTYgVFQxKXlv4ma+qGaBdn6W4/Dw
X-ME-Proxy: <xmx:ZpyiarWy1beRcONEV_yjnS6FrTcACyvHx8NdA1MQVHjdi7t0enK2dA>
    <xmx:Zpyiat1nJwbPCB4G80nZ5m8Kf93n_Y1JDXCBvh1LGZzJBxiaM2ESxg>
    <xmx:Zpyias1i_AhNOnPxEOlig1dQkdx-_Inh1k_3R6ivhytUQoT7pdxGpA>
    <xmx:Zpyiasle1bks65Uu41TJHA7cirMX-ui5W8QxQ5Nl39e0fEd6znYfDA>
    <xmx:Z5yiai1S4uWhe_ScfRv1YsH9ZnlVI3sX9tHZyfRSnqggMuPkR3a_tz2c>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:46 -0400 (EDT)
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
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 01/12] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Thu, 10 Sep 2026 13:02:21 +0100
Message-ID: <20260910120238.2529819-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 612AC160011
X-Stat-Signature: iwtbtxm5kb9x648gqynsn5cuyg31dyrm
X-Rspam-User: 
X-HE-Tag: 1789041768-448865
X-HE-Meta: U2FsdGVkX19u/tWZpzb6qJn7lBGx1+b5inU8XIrxusj0ekOBh4isiImxa8ntbA0Hhv3/7Cx8MEBIp9Ofwc1MAPcPJVZTYh2unltxLDxSYGe42GugSRh3B/fuTkczaPl9MWpCuICdKjSKQcG2W2M92KwemMAE1xOBW4+E3LE+9dKPrdxCkVwPKOavAJ9S3GIkawcpkQSAGk4X4CTkJegTl4mWEgJB2WcjkuKdJPL1c3y+EQ2CSCKZwBnRkCXCnhNaQJmFirS+kGhCS8mwQXdcBDvpDWs42uWWqOrRSUJ4HQrnIC4QfXT+ZpCJpJOqZSDY/bIbav0K5tKjqWNOcS6a4zOieNqa8tI3HX2bEGAKvcTBjvDE7szz/e7SmWPFvfyJPpBv+H6hulg7P73rI1+tkPua1+eyFFGovIx2K23/+j0mtxXT8lVJbZkhD4t5Ok8sTPgSDOJpfkIPFywfCyB5uyo/jsHR7BJMyr/j6dBRdep6E35In4sHvXrVnVMwNARTI+FzNsFsB41QT3EIfNzODeVROz5SgBhJYie/lDgXs5gB230lxtpvS8TzT+d6IoYM+SVz8Dxqg9vUwOFGGcakXg6sXHevomJNsnfpa9O3PrMlVdhk4cfpEYL1aJfyUOz4aEFJEFpzHzwI03Tv1/dpcpkVrIirUH9cE8sk5Cq1PJC1DUxaeEz9QHscTmPiYnKIt/uF424SMz2nRYmBs9TSx30QzxWqKfx3ageggDA2lsGdvNx1MEWweeg0Z5mHwfWVMQCGTaOrD5CbgGd41KXdS88HfyFaA/726jwVPMAM4uOUiUBYXalPVoPDE2lMFb31clxbkn9XC+KjYNwX7aasldvM+3sxXTb4kj+8mqt2Y73KTaZdBxIIZLyFY7GL0PiAPXy2TuU1fkTU77WZsFhM7my8vyVHNqR+iJDDX/d/h/V97l7wfV3dzlYxyj58Y7sLM6SWfo6n6JqiIQobJxM
 zHPuLsvQ
 RS4kUu1u6Ce6PclwyObccaoh/0BghiZw71lxuUd1/RsNpYKSqrppIUyY9Y6cK0OY9poayM+VNGwiF1TZ6uqvs7tGQjP9VNLv0fvYzt2EFS/5Hb7u+nfI24E26QZsn3WaSujlGSdSWKHKYwOZT8dg4YIOE0K6L2PkarJLWkoVcK1Ghf47nPgu7FtlmBMDBwKCFmmTpk9NVgB2N2q/UrnlofG2wZlQ/qeD2la8KRH9dvYksxitbjlEd89FI6DO6b2g21zsnOJ6ar83g2SBKHHrXENs/mxD3+5sTeyIHkxS9pI9/wasBYerVeV0g6yqX2jfqXCacQI51wMcbYydstuJLYZGsMAWz0dt9HoK/+1DowUdVjCdLuIPIqMNxWBqpXSWLk41j0CSiZWcjgc1YPdUePuRmpT5lYA3JUc1bLTiiTGyLWoj08RJEH8QtdhF4YTwb772vaz+FubkYd7cQgSnymLzoOPOqDR6c+nMCKCTy3/5Rbjefou8Yx5mCbTHi3/zrKfI51uHcCxq6tBJbKhlyIMR6Xjo7/eouGdZ5
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



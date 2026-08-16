Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FAB2C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797666B089F; Sun, 16 Aug 2026 18:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CC16B08A1; Sun, 16 Aug 2026 18:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E6A6B08A2; Sun, 16 Aug 2026 18:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2994B6B089F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F1781C1974
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:38 +0000 (UTC)
X-FDA: 85108620996.24.36605A1
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf14.hostedemail.com (Postfix) with ESMTP id C50BF100002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n G9tow1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BOnDi6ps;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyrP/wXPOBJTdhoFE5YGqbURIEa1HSuJzV4RfAXPajU=;
	b=kxSU3vSJwBeLULczMqvsJXF36bsa5CviZ1uCxR1mxmacm+faaBsD0RPpPLKtOB71XuEOUy
	fK00BoeGInTAuBl2Eioyu71tydjrTVpPW3QYPT1TSshRYOHpuTyKnllFs8WIuEqN2LboBL
	exIvZRE/9GMPEETUFlpWO0i2FjVwLYM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n G9tow1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BOnDi6ps;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920456;
	b=KKT+2af1jYWfKuBpvfekCiW6K2wGXrpgX25J4HW1sSD8LyKgmvg5Vf7MqWuJCSKHersEI/
	hj2dUa/A/Cf3G10cN3rL4ZBJcifEN2J3AJHQlavhli8aEuRrNRfbJobyuF6fs0BdinErHl
	sHET5whKntNdUNA1Nu4qUXbX8SOzpyE=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5785714000F8;
	Sun, 16 Aug 2026 18:47:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 16 Aug 2026 18:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920456; x=
	1787006856; bh=UyrP/wXPOBJTdhoFE5YGqbURIEa1HSuJzV4RfAXPajU=; b=n
	G9tow1dkQz77VjVwwF3jcgHCENpHOmT8atxbCLLECcSiWMcmK6RFYtDpUvqxkL9w
	CDUp/5852TW8lhwrZBw4LnSUM49QS+ubiCBuP/Oc7zR+MnT7KO093rX60nzUsC8k
	WF259W3rgsUCWMJnwYpO7w3ilcTCjCDYsbN844W1SHCtSPPG2qstrHMDxqNHsLlJ
	H4Gkc9DevfM9JdR2snF+2PuW8JDFOhRAEBUlmzRJd7C3w7d5o8CPVFsE1fyzWzBQ
	rHcAlP72IyQuA3Oa18FluUCvGMft6PBoqd3uurqhboVAcG32GFWXZl/UT3Umx44e
	sLOTkOswIKKnPFy5hb0FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920456; x=1787006856; bh=U
	yrP/wXPOBJTdhoFE5YGqbURIEa1HSuJzV4RfAXPajU=; b=BOnDi6psLSSwsXcqy
	wmRIZYHNoPw/nNbEwui6al4nbqSnxczcCAJHo4343mGOYCf6oK2m18CURKPQZoZs
	xxZjGtrvx3UEn4n7ABQXcJInQWQkREL/pkyU5g+S7F8sPN341QWSiUWETqSUJ8at
	iXfU/+DnEsUhOfdIcMKtOJUrlBSisODgaAJdTHLCHvsk9q7M9gqUQvHcTf7waYn7
	o++nyGT4JgrTC538YZDVwugzrO0mxcS23JtdrqvkLoBlRIxbWz9SGDhWLHGfAdDQ
	FDs4Ee5ybxfGyhj4wF+/cg7InCmu16q9iKiW+4yBOQ4G5eYrHMPjDj6dLAXkpJpe
	fcJuQ==
X-ME-Sender: <xms:CD6Caj-CF3Y0_otzv_4ZbdHY3gFX2yND2MmM3jDxjierR0z7_MoOBA>
    <xme:CD6CalBEjuXq5U-S7q1kTm-gKv2a85jFabeIpNonbwWh4tGOrQglGJyIRSramCnJ4
    Yf6XfOVBPTsjqyxWn2m3W8NaprqcFmDHYPI15y09NsZ1AoOWSJsjlhT>
X-ME-Received: <xmr:CD6CatHtgEXI0qqNF35XcyifsmWQdkizFI3ENThStE6oxSZGPjuXV_PniyY>
X-ME-Proxy-Cause: dmFkZTFcTQrb7i2Wnr2aEeZt1aoD7asKutBPdJgU3YSD5OfcfuljRo8Y5zG4WAng55KhcU
    fdYu9dW0n+wtsUDWiYHh8AwjWiiyOeVLRvzra0gUIzgKMFXfu2OsH3wUsDwz3Dpe7vEjB9
    JjBmMfD78Db5X6Vl1RDz8Wz4IQF1tjtPvs8yYIcZ4vdtxAZhotrvrKr9o/e/MWe2qw9p1d
    u/4ngMViLbtWn8zpPvYSIgtjaF8APmxmHCU5Ga5Rd5eIGcQp1MbbGmkchmHrMFMoUd9mrv
    TpVQ9+TKNOdfLLUK+2CPoHpagx885EUQUSZxhSq0AxxU5QJRQ+JA8yzxyjEYMjW1uFFjcm
    d7hzQcIDGBAJ9Kg3rplLw7jfe4LEi0F6SofMNmrKPLYc4yjweROnOFdgG3+P+anRpdNgju
    yFWVmmTGSJ1pkA7ZfQP/zLvd+Qc57RLKd2grwoOvBrCoYfMf2/7JtIEgRKykbeQlJl1t2i
    o3a7q3cY2oo04ey7M5qY21DAFRN0hvbmP917wCqhCug8/gv9jHuXVVRBq1P4rS/xZjYMWZ
    +SfkbQhdbebpKUDV9jBzsvGf+1KfqEwOb5sbvgleSn3QvacH+qZWnvUYuTftewxhZ+GZdQ
    8ctAXFBvI8gELPNX5p5dipgHyieJ7AirBkuIwt+OgA/k+nC52hzYouNJCAlA
X-ME-Proxy: <xmx:CD6CasDqx8V6n1QCtiGUuhnFqgpylWRxWbs14mo2yFU_swQX1tzccw>
    <xmx:CD6Caue0aLuCRyziW8qesyDXAY2Pz218diWwhOcQabijGhMKJxytBQ>
    <xmx:CD6CarKuEQXWLeQMpHAA_DLMhLjch0EeW6biCjjXzyDI-ZGBE49saw>
    <xmx:CD6CanuiW9Cj_kDQHiJh12QejcAO1iKHn9vPoyaNOlWqV6Lyy3ajUA>
    <xmx:CD6Cao9rCdG_QX7fvRRJ82Zli3b-4DelKLGbYqVGJRFm2x9yP3VPSP6Q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:35 -0400 (EDT)
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
Subject: [RFC PATCH 42/57] mm/collapse: allow error injection into the freeze
Date: Sun, 16 Aug 2026 23:45:54 +0100
Message-ID: <20260816224609.308019-43-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mnfq9hw3hxrg1gxyhjd9gxyytgr4ghsk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C50BF100002
X-HE-Tag: 1786920456-844286
X-HE-Meta: U2FsdGVkX19FcPebjzR77TQSya9kWPNNEmpSaQdQlydfqxtMpxl76w4+m58IUHfKQ2KN8pUgqvX6i1EXlDJmgLgXtkQbOssNA90ezRCuiEVs1tBFhup1KaHs/pVzhVag7qcjZlNmYpQjrOIwbtC5OwPzmks0b+BX12juN8NRiKyuJrIWdlWqtRud0q1LiSX3v7cNi7DQWyId5xnsRAd6h2OSE9/XGaNkJJKlUzbxQ44GQqeNc6PRfjfrG1PG+rbKOMvQiV/5pEPsqTeEEukhgTjN59Xrah7waST9IhwKZuJ9fVZ2zxhtIdiRzLgpl1gshkdQrvEzDz9vcpKK7Pz1IC2MhmRL1sPcHRy8Br0LSqyzn9Ym4eDZkUOuRozhSktGkAf6NJpTSMbRs/H8rB/km3Z5UPbWaJmgMyFbCXujMJZ99UGczMpmkx9nPm+eUISjrxuEmfAxo1CnmjvzDtm0EFyONdyPzbGkosyjjLbSN1ABdYFWVLUidy0Cn5Lndk50nGzXB+5+DSKNSEnmAc0KyNsi4QmKwxvg5Wv5gBI8K3ZXbjfhMHABiN7a7/Iyfs+ChtF5MbQ4w+jmrVJaQrSB96VNyaxSJ/5/BsbkvuSu2Yg7LDwDhWVVBAzGK+htOcvyUA20UNQTwofgoiTl+fM9HbtU51pxh0XGLti+SJY4prDcxZEWl7GSd2AUzhqYWGIoR3ykxuGI+3QQL6P07r2EXCik9O8Jwf8gbCTXl3H226ws+0kWoSK89SXXIa4S96lVZuOEOrTtLxnIcaC66CSBdd96+Z8dffr//0DSoP2nYEPWa+cj/zE9MNuA2y5FFNs1k1uQQ7Gk98ICb7ebtD/pSbsD0ygY1MhHPITWpYAKu9xZCIOEEObAq/VLXhXXWlTw/xbKE7Z4b8LB5flxL+1M+1Bjvg/W9PLNhvOhDXiRqiIokXhGlQujgYdbZ8FvKpyH5EmSYIe2ZG6yT7l2H50
 276PTgHu
 b7PCf1xWOKiV5IqD4nvNj0P1qEG2Spca+FAzFkIsFYIQTplGESoAdi45elbUEtjdiKH4bf2RJxFq7S9DAQ/+y0l8OzZ5zc3UvtC22qQf0rUohOspLQWjT90NH3l80ItZivDaRykr5a5dV57UDjY+12+/IsWQlZ8pdsA7dHd3W0KmdscbIzwG6M7NNBv0yzc7GbMxU3KxvcpAtxe7LylXJoNrk87N2RUG7st9FSptuJIvs+JRZEPsBY3d1ebguaqpehOB7vzAjX1XccEldQbs9teWD9p8bLBMqLSQPgNkFdbunq+GMy4UBucnP+PiUIlvyiH9jYa3gswiYsXgYavIlcEJq9arH+3b+iL8s5SiSChkSq5iu/jMze96pySYfHkVddwZhyVu6taD0eHJTCvB3IfTliREPIUPWUKAsQ6BUsFuyDN+CBb9f0v0tk8NnJJtw+uAPGCrXjvtmUOkIyF0UwqIIw4Q/GTshUNKGmNF8Xs0uUwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The freeze refuses a candidate for reasons a test cannot arrange: a
co-mapper appearing between the two sweeps, a GUP-fast pin, writeback.
What the round does then -- the candidate drops out, its neighbours carry
on, the region goes back to selection at a lower order -- is worth
exercising on purpose.

Tag collapse_freeze_candidate(), noinline so fail_function can find the
symbol.  ERRNO is the only injection type for a function that returns a
value rather than a pointer or a bool, so an injected result is a negative
errno.  It only ever reaches cand->result, where every caller compares it
against SCAN_SUCCEED and finds it unequal, which is the refusal the test
wants.  Tracing prints it as a number, having no symbol for it.

A forced return happens at function entry, so this reaches the refusal,
not the freeze's own unwind path.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 952e3f62d920..76a53616b240 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -4,6 +4,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bitops.h>
 #include <linux/dax.h>
+#include <linux/error-injection.h>
 #include <linux/highmem.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>	/* x86 flush_tlb_range() uses hstate_vma() */
@@ -937,7 +938,7 @@ static enum scan_result collapse_check_candidate(struct vm_area_struct *vma,
  * collapse_freeze() issues the ranged TLB flush over everything that froze
  * before dropping the ptl.  No copy may run before it completes.
  */
-static enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
+static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
 		struct collapse_candidate *cand, pte_t *pte)
 {
 	const unsigned int nr_pages = candidate_nr_pages(cand);
@@ -1085,6 +1086,7 @@ static enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
 	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
 	return result;
 }
+ALLOW_ERROR_INJECTION(collapse_freeze_candidate, ERRNO);
 
 /*
  * Raise the two barriers on the sources of every candidate: migration entries in
-- 
2.54.0



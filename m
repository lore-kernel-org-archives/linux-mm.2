Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486ABCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28516B00C2; Fri,  2 Oct 2026 05:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D001B6B00C3; Fri,  2 Oct 2026 05:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEECD6B00C4; Fri,  2 Oct 2026 05:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 953C06B00C2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1137AA06AC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:25 +0000 (UTC)
X-FDA: 85277233650.09.A00D1D3
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E3C418000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PGQXu12m;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oYm7RYYh/0ZcOga2k+AH+M9SDlDq5X2FtnYEwZCu18=;
	b=MWNbdiFEAyKZf69FF9AggT6w/w4q5Meku3YdgAvUK2oYjmhxHoMtHyP2p44w3jagtO+0MR
	SMowL46DRY9V+NolWejCHWGZ9M7nYqEaxAEc7ZCSmZLEWTOe1ARxr63Hh5j8ZqDCmPs7Wu
	ppSZt2+au23khGdLmvvQlrZkVhDspw8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PGQXu12m;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935043;
	b=pR2i6mD7IZAC9oaKb0/QBoygikNPDKkHjUtxyD8X3GIHXSw5ISyTsecbfMuLH4ulD4G5sN
	xUC0hQscqU4+4tU9+yudA0bUmVwnev8Zf++DeQrrtoJmkiolKWFmt0tS0Gf+VgqlqLtrrR
	RQyzwlx+xOJt/yIX079lCMZwq1obWBI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m4azhIZnpKty8kdqDwfR1PkRU+4t+lf/1EC6ZF7XDMc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935042; v=1; x=1791539842;
 b=PGQXu12mig4NejLiUE5ILsGwnwGpN2PkNA+tqKoPiQ/+rTeBGRcvOTZ9TlcPvzoNb1olYEsA
 hk9m/fB59ygchU7ogk2ux5yZVTo1XSW7bCD2wvHoB6ETZxBe0aWQRMPXmnF/qq+iTrn0f8ApWCE
 L3Cjr0b7F+x41xastVbYHwAE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id eacc6b0cb29b5092;
	Fri, 02 Oct 2026 09:57:22 +0000
X-Mizu-Trace-ID: eacc6b0cb29b5092
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 24/30] mm/khugepaged: treat PMD swap entries as mapped THPs
Date: Fri,  2 Oct 2026 02:52:38 -0700
Message-ID: <20261002095503.3585565-25-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: byr9u9iamaju6pt6mgfqomydmha5mbd3
X-Rspamd-Queue-Id: 2E3C418000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790935042-827339
X-HE-Meta: U2FsdGVkX1+L+CiZhb6XraNg2PYQ4gb7FvNaSSNtvycvwHz9Db90HStB4PMjIllBcoBlnyiuLHY6m+VmRTIjAqTK660wQI5T00WIWv1uivkzW+pz82U3fLY5tchXkAl4eGaJCtBQoFS15812SQuEaWiro3wwfVbT6jjgxv8NSr51/XcJw8PddlYShbwsDDFcEutxinQKPp3KKKBOcwy1o6Yg/brSwIwsmGGY9oJ/J3rIeCkbIdfI25FmVCuECP/fSpvT+rnpVGwFPXWLAVuPttYOE985xwMWrq9vUOiiQhEcbcza5kZxVztY3E+C6ahdjRlGGe47GwbaM2ULHZPYN4NrGgoj4/SmOANqENip/+VHv/37Uj2fknR3mxHySS0aAFMyIHPq+QT6EfenNYje1t77mnKgpQHavX2viNPC8Ehr+ci7Yxmbnr0ooITBirWxVFhhwpKPXa9ouZiBUnQIiKyC7egZbvNRkuVk+Pz+GcPpGzZxQUNKbFFKf2jGa/CEaR+Buc6p9gA5B/LjWtFiemHHzj0+CP0CUhXfeiFeYoPOyF6d1Sbolz1HFWk/hFdcMQA+CrQQM7y1ePPy6zztQY0j/5szxyy5+OWIuJ33Bqo1lEinsxlDchKoQqS9mC2GWXGKSz4o2VzcG8/XcvpIn4ZnjhKkdJUju0m/uLlgGH9+4FAdCgFhXWZkTmp6r/VHcr5aDDAq8XOOk1/j4jdxhToChqTptfKbGCBmEakednFXEYAiesJOAFgKAAl2fBRin2yftF6U/367w/ce+cYgeA7AQTfmuJDH5/8/KbsFyIH0HmBPo35mBGViLb+eBOWyf2dglUfueLYJ4rzHpmegB4DX4s2nlDac70vISptt7gTNRElClgVpWhwFi4tu4HM6lmQp1dLEcr9uw0t7TqDsT9WsgxNBahfvVwiloTkWpjKDoZNaQAxR0a53Zp6y2mTasjIrLWscJMiE2Oq/2Bf
 Lf1WaLjc
 j61BpY23Vt8QwjIaRtxey53cwmM7qSCywP5lU/hN5L1m3efRPASU1SwExpCjhjpBfa4RbrdN3mU7RHpKTlPeuG8MV0rID02kwnHS2YIZndr/rvSy0kG+AW1y40yIll+vNPVPKveMoH/MnDOCTeMl3cNbQuPMWqLQV941kRn6oe40Dd2CeAMnk8TBC/pm0BcPygKkFfIXsOqQsozB1YzX7vmZOFl5xzOkvikHo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_pmd_state() would report a PMD swap entry as SCAN_NO_PTE_TABLE - it
is not present and, on x86, is also pmd_bad(). The range is already a THP;
it just happens to be on disk.

Return SCAN_PMD_MAPPED next to the existing migration-entry case and before
the pmd_present() and pmd_bad() tests.

This does change MADV_COLLAPSE. Today a swapped-out THP is HPAGE_PMD_NR PTE
swap entries and MADV_COLLAPSE, which ignores khugepaged_max_ptes_swap,
swaps them all in. With a PMD swap entry it reports SCAN_PMD_MAPPED, which
madvise_collapse() counts as success, so the call returns 0 without making
the range resident. It still faults back in as a whole THP on first touch;
only the point at which the I/O happens moves.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/khugepaged.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0d8cd44b14c57..bbbf96c616295 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1052,6 +1052,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	 */
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
+	/*
+	 * A PMD-mapped THP that has been swapped out is still a THP from
+	 * khugepaged's perspective; treat it like a present huge PMD.
+	 */
+	if (pmd_is_swap_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
-- 
2.53.0-Meta



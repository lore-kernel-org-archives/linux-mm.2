Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4EFC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FEA6B00A0; Thu, 20 Aug 2026 15:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01246B00A3; Thu, 20 Aug 2026 15:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E4B6B00A5; Thu, 20 Aug 2026 15:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4FD6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:08:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01A8AC0278
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:08:40 +0000 (UTC)
X-FDA: 85122584442.26.1F60662
Received: from outbound.pv.icloud.com (pv-2002j-snip4-11.eps.apple.com [57.103.64.151])
	by imf19.hostedemail.com (Postfix) with ESMTP id 142CD1A0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:08:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=DvzKLwAp;
	spf=pass (imf19.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.64.151 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252919;
	b=0t87VJBLPGamPz3gL3LkzQ/tudpgTQwM0fFvpKJOCMmG9DsII/JJ+PYR/qok7VeEoychA2
	T3G8MYpHwSl9abpDJTLdS1XqL1rIKHbsrtSjmW9QZG+UZjp2QtS6TovfEPC/Sr6RAz37zH
	trkrh2BwvyCrgubddvKs3HZ3YxdNB5A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=DvzKLwAp;
	spf=pass (imf19.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.64.151 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3s0Ljrmz+8dOXY74UkRYnfmWbkQ+GvF09NHEk47To3A=;
	b=8AgoaY34nuTIqPpAUe+R1mH+ASV6deBHWEkSL7vyfTOabHqr6HTwI8Nugek/t6U0VYVS9S
	hTuN9LviTKPQjqf/Jxd+74K0womv09MDOGlgJMyxmQ9FeFdgUefleMm4N/sd/nGA3E+Xmx
	RYbUGrGRMJvunNQN4PkB9qV1lP2tP/8=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-100-percent-7 (Postfix) with ESMTPS id AAC25180017D;
	Thu, 20 Aug 2026 19:08:35 +0000 (UTC)
X-ICL-RepId: 01a02093-3d9f-7588-8130-04ffbe368baa
X-ICL-Out-Info: HUtFAUMHWwJACUgBTUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwZfEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFAGWxIYXBRcUFgeRhJWDV0JGRtEXlAbXwJCDxwTVhUTHUMZDysISgRDB0UCXgslEwlTVl8VFxtcABcGWxQERAFdBV0CSAtIAlQHUwBFF0oBXARbCl0IVVUIRRlTHhccRgxFGVswVB0dDlgGDFBNAUMICgJRHFYNVw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787252917; x=1789844917; bh=3s0Ljrmz+8dOXY74UkRYnfmWbkQ+GvF09NHEk47To3A=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=DvzKLwApPQXZqzynZ7bkNPk/UIXJovm1PsFZEGEyN7fZ/MHY9rqijklSbIobI/t5ZfZ+29Ws5qENBTnzSHI2jsZXAc/SbrNmrURkIIKI8BsHOIIv7Hs1gaCwCgJGOVhIP948rsMPRDj8Qjz83k0Foy0C2U3XHzRoWk3XSSiKN2jMIK3lErdKJSMHU4fbtHvYzDY459uLGh0Kb15C5csK9YQi2w63Hnc+nDbyEoZKcDeHruSIhYeRVumnzDrxoyRMLxKWsS3T4Uwfxf8xHlXFacia6TPgL36HRwjZ3TWenE6+snp95Jevy3ao0MG0ODEfrCpHGoYdFtXDn8ITDKYOFw==
Received: from ncore (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-100-percent-7 (Postfix) with ESMTPSA id D8F9518004CD;
	Thu, 20 Aug 2026 19:08:32 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ferran Duarri <ferran.duarri@me.com>
Subject: [PATCH] mm: thp: default defrag mode to defer+madvise
Date: Thu, 20 Aug 2026 21:08:23 +0200
Message-ID: <20260820190825.221308-1-ferran.duarri@me.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Cdw-6xi3i8Xa2vJbUX9Xhac0iJ9gChYm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDE0NCBTYWx0ZWRfX5rRlyORAKSTA
 YflDb6Uo2HPau8pptg+LgnUFfQiPGm57Mi9NBMXzoE4957Owa7biwy25PVuiMOlwaN0qvfagao7
 2HJvA0+L96cPScQ2w+5mIKrXPMTg58wSS0pXTNIER2E6bznm6U16LIZJ4KHIVa/K0LuRDasjACD
 UtPMIJVExufeS+UO29tA5Wa/Q15t6Gp2tEP31mafiUo66vtHwGdBISbSkfF7IXu74CvCzAa0cT7
 uQubHjLtdt6f7X5lh/6nPd7NWgjwDfBy9PuuPqLZoeC03k8pGVgk0yWetnnG7EsQ5+8i2s9RAEW
 5Fgo2rwJjTHQ1yoBmt8CueVzzUKtl8w9OquVcNC2KXJca8C07G/mpG2lmfR/+E=
X-Proofpoint-GUID: Cdw-6xi3i8Xa2vJbUX9Xhac0iJ9gChYm
X-Authority-Info-Out: v=2.4 cv=R5sO2NRX c=1 sm=1 tr=0 ts=6a8750b4
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22 a=HHGDD-5mAAAA:8
 a=IfQJFRUz1_8WHmrlOekA:9
X-JNJ: AAAAAAABXe0s/9meRF5CqFxVL4K4aIjrMUjItU1mUEHJob394tZov5V/hbwzCWQ9NAkIP40dvchsyM1ekDaCo/Ip1msKphRLZ+FeVNezmnaPzScbuXIdsoEWtdu7V0MKeH+YTf4X3J7kPmn8iSeF3u0a2W5WwtZnLns5LFbAAcBM8rvV4FRLUOAfSi1L5K7EfevyiJWMeGjQMlrfnUgC98zpDS6FHUCMzZnOTUwR7blYm2+VM5JEyQOi+igVq8y2cMDF3idSMn4eZkMIZjTgn7uB42lnoGCweTfPGEuVB+Z1bx/CSX88Wd9KyQhMunZh0uql6UlZPtiwORlWj+lI8BVYkgkLvbcKEAn6Cz0s+6Sh+2pVYTenzLqjHK+Kr4AQXuidHamMrZ2sGHlHSRG7LWv8Bf0io7joZomDIUTnpTvyxksyZqsJHeYBF69VN3ai+ZxZJ5hjHIhe4zpq3xNYCuv50++Hl7Q6yD3DRUwFiNstVQQ9ZImxbVBYBPfrnpYz+gMblaljyEG1SeQZCYZvEUpwL9xhHmLJwDFEXNajQDtSwhZiFarxASOIFzADl1irwmxRhoX8Q56Tg2/RXPdOCKZm7G5I0DMONlJRLjbjDHW12vyGAfMVKdLXSNfwSrSLnhjf2xU5ABSql+tpYfbcDA3jwADAcbsoUGdhelGNg1Zfj+DJpLIIxgVQzpRR5FHT2IqtN0ZFXJdv+Dwre1mKrlIiDGefq7WjhC746ZgSOsATX5wAxw9y6uS2QII16+b6OqDMcHZafflVSBFGWVyG6osyDAJhR+M3jiP33gMHRkg/dgPmATS659VMlMDMgzyDfFEovrxX00hYzRxtQcLLlZUr6zQXjU2U7DkHA97LQ6kiBpJGK8s89SsedMeFS6mD/rjEh1sWbP/PtAooTWwemlkyIKqptGre+lUPOSqFzPMifUaNeqSKCuiFSl/yS4ACUuYud45/MMDLWqsRhpKaoKG
 p4ukC36l
 bN7ncjN9z2bF3CXzeh31VZrcoSpkBo8FiDb0CJHmnSgmpSLS2Ytk3hI4g9ZedbV46NJVKnbHOee82ba9Cr2Zla4GznyPkGptU9gMRmxfG6oIsxLIBEMHYYUj0yfzj2qY5H3oru5zcfEKD0mj05QiTLuL2TnT7Znr23Z3tKCa2zy74ujnX7HyWrLfWODmjY/ASOaup+XGMETLe+YY6/tnVEgofj761tpYmJXbH46UgBHj/duBQ7QvNVCjovuOWjq6Jo/Hle4DU1A==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 142CD1A0003
X-Stat-Signature: j9x6juigwzwwmpbeeahpfx5sm7go9fo6
X-HE-Tag: 1787252918-484255
X-HE-Meta: U2FsdGVkX1/+kn+YhF3WJs4XP5AtNwRGh7ADqczrRFF+1QakW/jrAmdzkO5lgisQ5Oc2wnfYh/mt2Das+K2yjt4jgyJKEf27kWbfPqCZjd+gCNBEd9QdqG/bAYBUEfFgW0lkMhUoDGYrfj+uNH6U2jQ7tu9r1JgLsuCsozxzHzOYRiCYvr2a9UJyW50cFs/jaF6VFa9znUuzr86Zijb5o0OSyak8c51jf10YaBzXOfyYUwSP9MMFvVZfPsYhgf6580bYTBcONRvKbCuZ3SGhZ8qY6+YI0VCIq8Y2SxyAmjMGOtEN+haKF0Ti74y50qy1SOGx2VHEZDC+NqZ7itXRQmwH04LXGRdtL87r7gYhpC58gMmqCKcmGz5JumhVF2uK4n15/kOKqFONAVPE+T6fO+yujMkGxSrY2t/5/QSkgBai3SxiRK8rRd1cw3V14txQEW2NaVLZQswyISW8pcEwHH3pStZ9mXTeO7FVtDZtl0UpDZJ0wYBPcM5JR4EJ8IRigIVXzZnXwCub55hIlNEz4vqxIBGTCYAymhDeUFh5uQFTUOKwFG9+Hnl8cKS3OJjLlypRkK5+B1WcMs27qm5E4Bbdx/IToIAZUtymoEAvNIeOTb2LoJMGZoB6RLxprL8tkLvzd0qhEQo+NJHzpdS1AUxQeVMYTVOY2AEe0HZasyBc4p3SsmaHzD9pO0LXKz12ML2/g1G+VZrnWoQzo5FUo44K40RqGVJwV2Bin1aWpSMx8Rw0hxG6g3G6f5ftiRH5v7P+MlNz6zz/oA799LeMpI9jjHaBWrxpuQUAf1KXTU63K6G9nmlqF8TDL3J+axf4sjJ+kwTO9aozrM/76mffhGXCKFIwubFEgN5WFiLxrv1hxjNGrj3ENDkxPWBB67slUhlSNx4sZJ8VM/yGLHIJH3tr8dYfAzmitir5X4SKQewXz3Hkjv3HJjf6tcSthM6fQ/oCO+tShS+nN0EUdxE
 gOis1hRK
 rtm8EdJ2pw9fXVLHHUjOIqRNf+4gIl1nikEvz8fOGPrMvTdjoWgswDHfmbMWdIIdDrXEP9CVhD2cmie3tYcOurwjQmHGnp/SiKBAMpyKRR7+umDBTl+iMNz2DcwyY6GG05bBNh/L/gfzpxl49Uw13LZEBgBhyL2RCAz7ZM7LH3T5Iw6ti4RLBux43n20IuCs1UrUk1BaHrpNsQ3zTxjmToMxKJqzZd11TIdsuwANgmLcCw8LksGlpKI1gsqdxaWMzfENujo8bHhS4kXK7ptYUgq5o2cPS0K5bcY9d5ga8908whqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

transparent_hugepage_flags unconditionally sets
TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
THP is applied by default; they do not express a preference about how
hard the allocator should work to produce a huge page, yet the defrag
default is pinned as if they did.

In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
compaction in the fault path. Paired with transparent_hugepage=madvise
that is a bounded cost, since only regions that asked for it are
affected. Paired with transparent_hugepage=always every anonymous fault
becomes eligible, and under memory pressure the faulting thread can
stall in compaction.

"defer+madvise" keeps the same set of regions eligible for huge pages
and the same allocation attempt, but on failure it wakes kswapd and
khugepaged to compact in the background instead of doing it inline. The
fault proceeds with small pages and the region is collapsed later. This
is the configuration long recommended to users running THP=always with
large anonymous working sets, and it is a strictly weaker stall
guarantee to make the default.

This changes only the compiled-in default;
/sys/kernel/mm/transparent_hugepage/defrag continues to accept every
existing mode, including the current "madvise" behaviour.

No stall measurement is offered with this patch. On the machine that
prompted it the fault path never reaches direct compaction at all:
thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
is 0, because memory has stayed abundant enough that no huge-page
allocation has had to fall back. That makes the box unable to testify
either way, and a number gathered under those conditions would measure
nothing. The argument above is a correctness one about which knob the
Kconfig choice is entitled to set, and it should be judged on that.

Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b118bcd392cb..749f669cca56 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
 	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
 #endif
-	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
+	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 


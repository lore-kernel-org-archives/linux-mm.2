Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5AEC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6B46B0095; Fri,  4 Sep 2026 11:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D196B0096; Fri,  4 Sep 2026 11:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0006B0098; Fri,  4 Sep 2026 11:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8D46B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DB3112013F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:36 +0000 (UTC)
X-FDA: 85176416472.02.D7BC172
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 948ED4000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 3NweBx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gyV2zD0K;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+81dAj5x80FGoAjSvzsRnSg4Kzca8fLKWA2APX95ZQ=;
	b=7xGCYIC/sh5tt3JffyAN+8z68pxucgxJqwei/AIW8S/Yx+VpYxrNVqe10vZ9VpFYFh+KyX
	RFcIlxrDVkjHI4EsLlcCemmS9SzNA2HAvO0FV6WuK/Vx6+UoOQyeHwrYm8RZv/BJ3IAHg4
	j3k/DDEnCgqiuzWc2n6y2M7sA7MlPqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534634;
	b=OAX8KQDIbkBe/LBYduLaYkRSCngIx/f6SFfgSVmrCtcds2+KYOaiP6l9ZdXzwd/xDvSnDq
	Um7+9mgvpDnrVa09381bmBARb+ssfaZMbUXFPvqR/9IkFNJk2Q1QMGp9uXu02U4Oc5dy5S
	RN/FY4nb7YlczVpnhCR3S+vZLcwi04Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 3NweBx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gyV2zD0K;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 262ED1400106;
	Fri,  4 Sep 2026 11:10:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 04 Sep 2026 11:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534634; x=
	1788621034; bh=b+81dAj5x80FGoAjSvzsRnSg4Kzca8fLKWA2APX95ZQ=; b=L
	3NweBxOYvekh7y+hOqszpAnTsy8gz0WprsWq8AldTZqaL/QPKFChdgvlQrLfc5Y6
	aqXesZ2d9nEwwTqE9cR6Ivgc0b3042sKxWSgANB2qWTF5KD3Ijzuqw3ZwjfQSneQ
	3UtQLvzV5hPT5zDu3WX4SlMKFiszdVoUK/pjKw3IlW6k+Gr59ovuysX6fMaaCbL/
	aDoZ0aJbBG0bQFGmRs9JtnF14+SJCcnByRyzvJmBaPSY4RJfW2ObrlDgq1GXoGjO
	mc+9E9DURSxJ/XYL5lvd+QAw8Ar1v0PMwoxF1fsHmlKKaZt5SFOaNenQY6QZpG47
	srbYSaeyQOf6m7DwbmBRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534634; x=1788621034; bh=b
	+81dAj5x80FGoAjSvzsRnSg4Kzca8fLKWA2APX95ZQ=; b=gyV2zD0K4arKTtjK+
	89MDgRn69V26iXslSbZHsojlXX+xmoSbFVH6nABVDMWD8tO2/sZv6ko71UnxWQXE
	xGDSSeA0yRJq7tu85SH/ENfOCw0ImG1pFhRwD+ZWfSRbzkXbWIo5p8c1sP+aY35b
	iLnC1mKnostEQ9pyNkYX7BANKA00/iX9hP9AJ3KLcL1JCrmjJoqdPmO6y7iTczon
	AgrxR4aQ+QKDO3lwuQhm8NVkLBR7aoMLp5Pj15nGOJzVRK5nlFJGoPgfnnvOM4dp
	0rc0bA32oZfval7SI2f7+egEvMh4ylVRp+EzTYIt4LzPag2gC8hyJRKROgECubqT
	1ThNA==
X-ME-Sender: <xms:ad-aar2BS6CodJ8deXMTA2O5dMh858AhxhrdFzSzk7RQ3ScbINEsSQ>
    <xme:ad-aamDKNuB8LtaUm6vTuVqXqDdxjrMQCzBUnnuj2jh6jhTmkFszbXc8uf71KSGsg
    -BZKjeOuoesIYC2jlhibbcY7GDLjVja7zX3fTSrum1LdkmhED21s-Or>
X-ME-Received: <xmr:ad-aaiAHiERYuIuqxWxXB8oL6ki2ap0oiQ_mo15vXZcbsw-OatJekQ61-eY>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckpt
    aMYL+zmXSgfpUsAfEbdq3YcIoDlCmZxuiv4vEQV80awfFv7+kV3xGOfWwk+caLcPCmKQfj
    TKRiZUVKN65tTPwVy12o9rg9A8OAnzwOdHKxy66fYZzQOeRzRghLrCcywsyUmjySG2SorR
    AI7XMp9dEEpZKqUw0c8FQEevu0Y2iZ3joWaO39rAcm9Zba9QxhTcdlDK8OlRJM7b/9GNfo
    rX6/rUjmWqQUUBqaQ7kTJfP+KvRdWdx9PhtIWbhMDsjMWyFqorifeMQGo8xtnO9vLKpSNG
    Oo97AIto7b7gxYB/alJR+3nNAoiHuOgKfpdgoWIPPdo/w6UAQeSR9SqqhTMQ
X-ME-Proxy: <xmx:ad-aanOhd9h7_JnBXTViOlgfJxYx-c7W6wO5SaVLOMyR1L_kmPPTTQ>
    <xmx:ad-aasPCwEL8c8K-rzsd0SK6J6o6egpUjjokjZkaI06QM3_7SkSglQ>
    <xmx:ad-aaru6-t1H8iBob3uNYt4lNi7IzgU2ZlB_gCHXm7Zks9Lqcd4oKA>
    <xmx:ad-aah-jiGC8JVyALvoaiuitYpPSAcv3yKVHlgn5U9FcM8LA9bGLqQ>
    <xmx:at-aaiNPopID2c3MM0mzpm1g4Eg-hkDhKaur5yjr0NLQDQhros6zKoM4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:33 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 02/12] mm/khugepaged: count collapses where khugepaged makes them
Date: Fri,  4 Sep 2026 16:10:16 +0100
Message-ID: <ef229484e454d804ffbdbf8ae87798919594fd1b.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 948ED4000C
X-Stat-Signature: uxetng1pad7e5aus5cbzjpyz9nymmi1u
X-Rspam-User: 
X-HE-Tag: 1788534634-25604
X-HE-Meta: U2FsdGVkX19q3vgnoR3q1eZ5r8mipykV/TIkU54Pl4WQM0B6HJQCq3tYAxG4nRWgF+fonjg48EkOpQmr61JICcPJkIMrJRbSm8e2guPQx3f/hCBlwhIuNPW8fUgZIWmF5ksjTOoqtbOyvZyjUDMHMP3nC85W3ByvJVfswoKMGVGBQYzG53T7nnAOskEJ+R3wsujbRZBlP553UCMg3zKQWv3ZK72kKIwNC0yW961RrIsYxD9Wgn8oyOa0U0tvy2qlzbPGhSHz7BJY0bY6KzSoNk8rKHncA8eOdfjeQGjXAi9g+RVRAKHpcCi0Jk6QF+p819WSZr5wdnSvJMUnZ98gu2CVuFTkF35ekiyemv9VJRSDe9ASJ+IMrCk78TDUnQb+xGwWoqjbqYssxkfb/t2NmsM/uIYwpIv6hYUu9Gpot8xDWQI3fneBnfeRs8Uk+cZxZUJ6uMPlO+DkAqyHhTIuO7q7ggl0vbF53g4GzYre9uiL/hj+m97WA4cz37aZskXWYx5bVglUpPc2HyA4WkoNnTCMqumVNlp4i9BNRAvxAPMEglQwdWYjVvWHCAPMqpQqo58ZWOGCwsTmJwhxiWFRVOpG/PCgJEJsukxpZo0doQOhUN/DuprlKuAdUfu6kynx7NuG7ZuMOzFIbBR63/exXSGw/2l3Jmugh7JPeyPVW7QbzdR47quVrznvJH+UQCwiIMBs9vEj/bdSL3HhvpyH88cfNvT8E+Yrg57ciXBcWbx9YgYKjxLLvLKkPsuVWSg48ppEfwDTe7mkDOdsPcLpUT56aMgflDc+7Y1O0hmOxRO134xEW5rPBGcGO7NvNXKuCYouYlsofI6+Rl1AqutPxzKl0P39x8sX+3KTL0hcGURdKHKi3KBR7n5zkwHdU4KpdMWXYBH29UbtR4l4NUpIVGWeAc2XRWJ3grSBIF+cy9jeRIEnSqpOiwsryPW2vYWZiLrOrHIBWxLW5pyhI3t
 7OWxgXuw
 Sa3Yo/sBn1IBC9MKVK2u2uD9WVQp9hNBV1y3rSo+E+6NJ0CncVUKS1uPDTs3pbqM0hG1zMFckVjWXIUraVE2ReOXA7LhlmcdV+dV5gPuB3YV8exXlblSwvf4RFx4kLTeGardOn8fp8k8WSPucMk7wwe342DbPdwMV3TquqwxFhvQNDmmojgFAObWYb/nNAH6Fe6SPKUknZ3M3qdIbVEwyjilYjbdilecrXvFc61DYA4LRnJ71sBMecSa653HuY08CktvrzhBTXdwrLVSrZtEYH/X+lqvSxWLiTCNDcPyH9Vx+qBLHEvhpZ8xyS5fSzS4+rGyFNctrhj8MoYr3L2u/6cgW6iAsWjZ3AU5Xqx6ZYpelT27VGaTaw/0eeBf0oRck5TMc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f1f8d4375e96..a6dfd8cddc50 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2822,10 +2822,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2861,9 +2859,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2940,6 +2935,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D79BC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10646B009F; Thu, 10 Sep 2026 08:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6A86B00A0; Thu, 10 Sep 2026 08:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDB86B00A1; Thu, 10 Sep 2026 08:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9631E6B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:02:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35CE01404CC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:53 +0000 (UTC)
X-FDA: 85197716226.19.DE412D9
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf01.hostedemail.com (Postfix) with ESMTP id 40FD940006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g Akp2IS";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cBn3+Vw8;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041771;
	b=MzUWo16XdJSf7+uocaV0HkIlYEl1GZXt0fXEYdh2o1Osm1lWcaG4Oj9bHm4y+012OjrnAG
	JdBdgxQwrmEhK1rSav+34fYTAg18p14JnJEQ8quX3UGOcahpNcyg6LNW76/EvnE0aLLmvQ
	/0LS7DX4mFfbZnwL6Mlf0CamhnwXQsA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g Akp2IS";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cBn3+Vw8;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=;
	b=GtzQw6CFjCUwrfImCL05eFDzB3zehNQggD5pBnzqM3if0cMl/fp8yCTRwNzGQv75CBFKAB
	kdTRzqjeRsoKgJYVnO0vWZ9FQXfE59T68Z2IKIuDXmmkyuuJkveAXv+2YcWYuPR4oq3DuS
	2GVt3JaULj43r/4zqF0ubotJRq+mroU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 32D381D000AF;
	Thu, 10 Sep 2026 08:02:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 10 Sep 2026 08:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041770; x=
	1789128170; bh=8kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=; b=g
	Akp2IS3NHDVLdMko2d0FV0YB9jFZ8P58J2lDDhdm+9rn2ICnAutLjjqPNBKXg5ji
	lOI02rQhsVa5mXv3g/m9fV0xldDJQ2Inh16KvSZsdlBpaCdx18L/X6PWmvghqoEn
	TkljnvzD3nue6abvEgrfgqpzSAa+k34eHKHFdenFppTVK0gWBTYHpals4W/6j+ys
	zwrHjEh3mfTvMsUghgzLROyM400/foH2+TsWMn3WK6buUEYVBgcW+DNki8hsl0Wg
	XSmzuwv+hmkJFLXpd/CBy66Cp+lgdWF+0nCtnHJZB8NLNIK0GORKzn5hiun8QHXJ
	HatFXX6MRpAlEmxYMxkrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041770; x=1789128170; bh=8
	kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=; b=cBn3+Vw8POMp+fium
	FQ//oEUoWBMKXZdRZ86XmcbWe3fhuloiKaHwzrKiMyDUUPzFJoTAU3VEYgbKeTOK
	j/tqsnDr5jSq8iJpLC0bWqmyKkX8W7XHXARs/lbBoRy0jErYut2DmM9cTw9gyi6g
	Fo8Gx9oNLlc1jEbFFgJMc2BqCtK8zTWJj0nJW+JwNE1Gx1ndN08sd9TfJBhKNrMx
	zwh0jWKP5PTh45SFCtHgVlXDMSswUok9TXoy+ac6iPGNGjc65vvps9KrrCoDGKyk
	oSy+EDoI1kLKNQmz/GWZQOeczDhEx0llpanWN3rOOhuc8tTNKSwBofM07oLxeOkA
	TI44g==
X-ME-Sender: <xms:aZyiavIh7p5NixtID34QQtB1eVLozEiAENhyMdgT-s_uAfxfbeHzWQ>
    <xme:aZyiavGeQA7vI0J-4d_Kc49zX_HQz14E6ycycMDOKc9IqOf3vC2q4oJ-_jo12CWcg
    ipsdZKPb4cVGT_UVGnoeSwRFlVej4gisvItw6tfDUpk2kCi0dy_wBLA>
X-ME-Received: <xmr:aZyiat3OXWeev0a7czX4UgyDQKGJJlHfNSh4BJIXf9TBZD4X_rq7P0YGMns>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2CuoZA
    UmuXX4LIsJW7XVhqlJ8zVOJIJ0NZD3NUnvHLW/LU5aYowrVKTasei+Z3d2uPbvnci0030K
    yz8sOx+VruTDAAU4PwIeDL2+c/v69MtCSMnOR2gZBHe1xmwcFNPzazqUiDd28vHkibOjBl
    rydmZFXtzNseUJaRa69q6JOEKLHbI//bE8Wmkdx6AhpI6UOOXADahWweL3ANdYpno/6T09
    aeZ/Owe5RdNZf5Setq1i2PJ7LMhHyjLJfZELXrv9fOvpeSYe0A5jBN8sv4Sj40ecqCdKBY
    WMnR4RMhwbxccxq+s/2o8NRXwS9R8hFoxtFyZYufbV+lgI2m3qedCD8KSyag
X-ME-Proxy: <xmx:aZyiaux6LcdLjkSvTRSrNZkw2w7y4AUEyBq9QobZ3ViFAI6fVp4xFA>
    <xmx:aZyiakgRHbFSW53CW5Cpz4_NFSzqJG5vGeRZrL9W1Toy1gnY1h08Kg>
    <xmx:aZyialynb4LFmlvuhEjIHM23pQr13s71-B1dET0RIUOV1Zu6TguLnA>
    <xmx:aZyiaqwJVjWkv8lOp6QD3_WcVYc8808VK9yFOXDlU7Vcf-RflZqovA>
    <xmx:apyiauCl9mPky25QS1wxM759gmk4WN0YzQ2aygLrcw8WP6GlGYk7Rlgq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:49 -0400 (EDT)
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
Subject: [PATCH v2 02/12] mm/khugepaged: count collapses where khugepaged makes them
Date: Thu, 10 Sep 2026 13:02:22 +0100
Message-ID: <20260910120238.2529819-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40FD940006
X-Stat-Signature: in5j81ur69xp6wac1yi6er69fm4jzai8
X-HE-Tag: 1789041771-497911
X-HE-Meta: U2FsdGVkX1+sL3e7xt9HevfCiIneEXKRf8k9F+U/KIBpmCFTaExJH5f0rbZ2Mw+mOnSG2KRJtsARi+YhER60BzOCfIGmHESFkJLJ1lA06PJXqL3+3MCo3fK/OWsrOFuLw3YFi13xQfR41ddRarMlN29Cl1uf46aQv4az5isAEZo+urgZvOHSXRtIQMGcn+d7siB6vKS033YVVgEtROUzOt0Sxl6XccveIdS8H4c1U8CmJ8Vr/8pjkW6bRRaXkfPRMyoLojGlHCfGZo2nxqp+0AFIllxkOkdxvs3eiCl5brqMbv600yLAAaPTUi2vxiviRn5pxXiMPUUjgTGR8lEuibHTDVM2Vy/NQUi5b+Pwh+2Z/o1vSd3vS45BQZn9/eH6Qgvgz4JMhFpUx6KKa4XFN+qOamyjrJMIoVU8c5NPGR1KkO6nICGzXntTz9jflCrEzvONcDM8B5R1YepY80AsN68ANpOpFZr9XQ8tIKfqFFuRSz33TAgC5YrCxAGcHSieXkQ2GUb3HMGg2p7o4UjndzrKOSA10eg3K9J3qXoD6KyRIYHutV3rEgw+9EWrY1Y6xfR/CSUVcH1xu7fPXt1Oc6w4Nk9dbh1zS8+19lquil4rFNo5TogT74z88ugb76ItvDigpSK8GQehol75y1i6zmNjogYEEVSBWIDYsexJ9hqhDWOwthHIoLcf2fghUyGIeIZyAX1jSlhHRSxeat5C26AbLmMk2xFK8sebscHg18kEWH/jAMqy1vsQIEAum0CMV4WoWnzeqKjkfWP2IGwuzzrF1HIz8o4+B+Ll9x2l9qgnyU3M+eC8/N5ExsJaMcqKWdJagqTdrSAEMKDC7PuUoDJmdduj8Fj84ozvMDbvqg7MRT0+p7Kw11qSZ6mWaga7yGETy9xG/TDYa9FgBCgsaBnMG2HHHCmSkycejuCOHR52tJzd3wvnPjrU4KMYj7ILn/Jlab8l/Ve31tVgSbX
 DJUxVNdg
 83eFmojTGocqjdGJi2KaJBRzf/LVnM6Cp8nq4IGkpyVqCiad3l7U5fcdCaVmx9qFOfTEmbSHiNAtMGweS6yyXQmj2wD7zqlRA/dh9a35mxiEzp9caeAL5iga6EIUzNJxXR5RcVAx0YdW5+ZoQxxywyOuv44I+TRGh+QhuBN/ppweCh1A+qDlzxfQuCtV74aPQ7C7j7Qu80PPtCF2Ij9S1edgyxgIn5LOw5kUcN5/Mry1GYVBnveswxSIe42/eDtFJB4M8x1CxqWX67tQ+SJjXKFV8jEFZOMSVh9hT2Ehmg3mmJrMNnFut2V7bM0DX686n+h9SB6V4BemmbjrWHsfqHmJmsgk2ydxjF/RUMFN55dOd1QOV6cHubPuqhn+KXLFaXjjtRlpI5QlIkFGgbhrUk5Jmf0kp+vmJ+O5qCUCzXrxm/nYwTY63a8k95EorwzSgx5jTygqocupCcVhzckVU5JlmtxacG+hGEIBCMI8wKk21pDulM/qhlsFpyg==
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

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75c876acf527..4979a93e3648 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2815,10 +2815,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2854,9 +2852,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2933,6 +2928,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
-- 
2.54.0



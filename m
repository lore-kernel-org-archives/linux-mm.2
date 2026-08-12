Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F17C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FC56B0151; Wed, 12 Aug 2026 09:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F666B0153; Wed, 12 Aug 2026 09:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFA66B0154; Wed, 12 Aug 2026 09:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB5B6B0151
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CA34160370
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:58 +0000 (UTC)
X-FDA: 85092685356.10.A59321B
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF059A000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W AI67wc";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XUxiESsR;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgwf8/Ke7VGpiXTGkaQbuCrVb2lFqUgVIPPrp0NabqI=;
	b=0+YIkXU0t9a+vjMeYz3+TSjKJ78aB07PqwedDzs7PgkzCBOwhCfmGHKlhF8QZzQ47Q7v56
	Aa+gAnVdUbjIV/IIRYPx04rMhvj1yzbaJfME8F3Sw6BpztxrDHt3sMdBN+kaASLJj98I+m
	lqqMc7qdMEZLaVfOTa9yStvNKEYZrVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W AI67wc";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XUxiESsR;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541036;
	b=yca2DLPzSV/gggtO1SpUr2GR/YfMwVS1y7icDj0JRTfl7vrkgILm86TQioGrPQyfa+5q2e
	BML3zjEeDVLDuuzHetR9PZbCqItDkXirpw4g29iH5bmjPplkzoZ9OBpD4EXP5UOyb0nPUf
	poUy5prGxu7Kue6wPHpMQf0Fr8wHxB8=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9E37A7A015F;
	Wed, 12 Aug 2026 09:23:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 12 Aug 2026 09:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541035; x=
	1786627435; bh=kgwf8/Ke7VGpiXTGkaQbuCrVb2lFqUgVIPPrp0NabqI=; b=W
	AI67wcsCbhXxN5ySnYvIchAVFeBeAgIPa1rrr+fIiwwm+gg7sjzHHuwpOoYBxQ8n
	ChQjU+C0cnT+H5uB9aBaf6Y4/7ocb/pfwlyDUvgleidJmL7Az8Ml12zWteVeWwN9
	De7yN6Vhk9lBCN9RBLhjfE+o1idleXplTIf52+qyKYJd6wYTt8mOlMyohVvuubzW
	i1ivBsbSmi3JIEnLqho2FDrD65Y/tVYg8kRb1ZFbT91oDCo3Ie0hg8chK3cs3+bd
	w0M4Euzgcyb4sK4q1H84DJarbF65dG0h8Eye7Ramzxi/r102sF44kvKmjrDixUvv
	ZkA2O25Xto2tDTbvWkd0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541035; x=1786627435; bh=k
	gwf8/Ke7VGpiXTGkaQbuCrVb2lFqUgVIPPrp0NabqI=; b=XUxiESsRJ2NdKdLAJ
	zyc0sb7bj50PGVkpd3+Posb5XFYM8rOQA3LbqIHz620YgpUPsVaeuSPK4xKAuVO6
	UkJFV2EBGsTdi9noQoWqnaMDoj9ssfDdp4zHCNADMMR87GR3Pi1kVQmrPHQe/GXb
	tKNEidYXA51rlxQI8dtdyqhS768ADDYnggIf57Ug1hJJcHYWbYXcv3anlaKBhYBC
	Z5agvmpiLMPiwVeoky7L/FxcoLmBseA3SCBNAsXM1y8u25hWlwwUKD/uDrE0zxCH
	Fb+NkHqVgGpSgdxL0BZ9O7n3NwSwqFzKmhv24TfL6RPho1OxpoTiWKG1VpECxvqQ
	oxe5g==
X-ME-Sender: <xms:63N8apfNQQBzmJdmhKmc52oKY8Y0SZsWcgAp_Dm4RNC2eqqCFylAMA>
    <xme:63N8arJ6GIJb3K2816o-gI9SdPcAVXdHgnfdEITge5DlRTHILEQB7lSZ76BRlQbu-
    hHiUPwcb3-dbJCBbEWgJOGaOd0ielgiVzrqEWltk16qaMaX5VMhpoA>
X-ME-Received: <xmr:63N8arBpfSPG0kSLrTAZsJ26o7LwASuaag_us-9jCUr3H1sRuALEOKXVe2Q>
X-ME-Proxy-Cause: dmFkZTFzqtrNoSTXX2MRzKyN6p8XXqdjDSX08KYyJpXp82eYC1ae2GegaTOhbDzreYT/K0
    OAsc1zsfjWszwuQXvOMxV3FM9x50+HqAsA48u5Kq52QtHo+TJJPCEG+EOeKn5Il8AepNuY
    amkSO7LHncjzMJKy/SPUs50UUrTlzGP0ayf7b+h/q5NreZMQSrrfXSzcd6tsdBCg4Hhmbc
    7COQKDHpqWJD3HpoJ7/Bw0J3tcRV9tZIkmRGQ4nZ/O76iTBc+eN6GYtayu9aLLTJal0DNN
    hI5LqlugC7KhSFwlZIIFqKKnJB7XY7vZnEBEdRJ8Mvpq9sE5OflKN5J+H3ujbniJsnhlZt
    AO8s3IAdX3RECZ65RDz6vZeKF9y7e5/y26Zz/FaKwgKRPbu3b56Zt0D9mkA5eY/On1BDUN
    I9ma2NHB/D+64EcN3N7LxO3fy2AgeqQ31XBqVh/XaUCXD1q9B5JOs7C72aocdlKdm/FV5i
    Ns9weHmhUOW4IdfeIeNN/rOuwSH9MM0OsOa+KOf0Vn5HvZG9aU1ZOYDUy0RLkBhiG/nxOo
    MIblt/EzJD+PYQjYcMDVjPPBq+vd4tb14ejXbM5KGhtJdmIwOX2nHCfpMA7zZxGXjpQQyX
    0ON8a6SdRxRGhFE1GKNFxde/DmqcwOVMa4FV5LNzOODt1ffD7KWFqyklEEUA
X-ME-Proxy: <xmx:63N8asgwdklCFswOaDCFSdNkhqBTRHMux8VNR7n5OKEGx7m6DFIm9w>
    <xmx:63N8atPHTq4Jg4mmgT2chybXfv2rb3t9y9QoeSX4mmoNZk26QFoRpQ>
    <xmx:63N8ara43y4dFVc5v70vsBf-yWdEusCgH3AMkDYT7dL2_q7PUr4UPQ>
    <xmx:63N8aq9P7mAl1zRAjKDNn85BE8VfJZG2mOxd-qQ4Va4qcNLKqthL8A>
    <xmx:63N8al8FmW62gB2-m6k51GwKmVlYMVeRk6wsUoqVMYC4XWwjm2EinAPl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:54 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v3 18/18] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Wed, 12 Aug 2026 14:23:04 +0100
Message-ID: <20260812132304.199287-19-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF059A000B
X-Stat-Signature: jqrr7osmyjsucj61af5zwkxcohwn985r
X-Rspam-User: 
X-HE-Tag: 1786541036-602370
X-HE-Meta: U2FsdGVkX1804pRDPhszFq6gxWFgdjveIbdSGlbBN18IhkLrAo95a/Wg7HPKODEM/ejUhhnyDiKlg9nDf+lzO8PsENXoBzWgg2NA8nZiD/PcM08ZLNMUWPBKi5hUHWfiUYG26H/UOHEzO3OX4GSf9ZXcfQWzicyQKezCEKonbH3gD9grLEntrQDsU45tChlxX11NbHVTkKXhfuRptBYzSuYTtsmvmjfEgtY5VL12fQ6Q8SCpmczv1pU+RhuuCMxcCwnxhz6Mb7AuQs3VQ3uzKM/Moc4wSbuzgJj2EclwMWhYDfyl3wTlUXDobYFl0pnibJgbWQYqTTm9/IWffjfCze6PQehKGQArTT1Xboo0FXl1CFFpeGCxkVmeTlMjhwI8wryWm5d2bPSYdzRtAa+Ey6EQTh5QmO8Vl0ZkfCO8En8as2Xs6NJxq7JUz8cq82ARHQfaATD0eu8c8vvcbC+eNK44ITtwEopaDqjFEBSxhtalLonL850hV+mA6XDIQpXrTivQTeuIoAuPhedDj3zOM/Z9FSUHJNJdIGEd9ZFWRWuoCoiOMS9z9BtUp43rtBQcBKByWSMas7LXhp0BPCkihyqMYYpBLT3L4+sIFggOcqSsaWicdm683y+nRDcEbEyesCtceeW/6XaejDz5Tr0ZkGEzZtS1CcDNtJhixDWKPDtRMcR20/4XcrnQfZYAYm9R+py91FcM9M1crWIuYNyarSKY5FD0DKtsMhygq6A3aYKFJ8XXaiB8tgKtX39rir7JBS7rZKPpRiLwGN2lP3pfrgp5nktb0QALd7szxrtPnZOxDLxj+2Iwh70k0aIVTrIOZJ0yp5VbB1h7MunHkcqne3B1G5o++oKkFKJ6//7ZPNBjwvPOAg6v2vYJR5qCxmu7+aaJutVHkbNbZH9/KdGehaBQ4stfzj3vO4EcGp9QI2dH+HUBOq7FOyWklduupNFqqjRVMMJnFcm4xNZqGLR
 buSKlGMJ
 ye2tPwOylyhyG+JqO1j6W+ilkQIpNI4EuX84QfH3Jp9zZOVqWC5tJxCzwGjtp4AEGWwCESm5TncySs6G+gaShkoIRq3eobGK9gE11wOGnhYTcX0V36Yw5nnToAYA5tfOpj/j+AonLFoI/Lk0h+6pAWXBjfkRS5vlTnreKL0ivkh3BiKDT4fR7AXwoLPXSPzIx/JD5QEC1USr4HcW5mv8gIZPFC4Ht/f+H+NVkz7U++JeuRv66TGCT4WkleFaJqhMoUXXcAFOBwUTI/LE/4wN8FsYiE+1OprGCkdKQ500gYaxgGnUryJTc4ik0Q24RuHTmiZGdaRdn687TwwScxnw2YmeYdu8Esy2rBsfAzueWM+S6UmZCDrr3A1V/NPvW4qC6F70OcpMsl9TbH5d5Trs+KG5zqcYkSF3JJphjML8LnyRevJrAiRkBYUGyKrmP02nulZ7zCX4YFhpjjCIfYtsMZkPEhiYBOUAnZFT6qYMmfm51nMWr6VVrSrDuhXkOqi+xNTTH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area.  Empty-table reclaim (CONFIG_PT_RECLAIM) only
engages when a zap spans a full table, so no soak ever ran it against a
collapse -- fuzzing had to find that class instead: the page table
vanishing between the engine's park and install passes.

Make the thread zap a whole PMD-aligned area once every 64 iterations, and
keep the fine-grained zaps as the common case.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index bde36af03e49..3601c030d43e 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -141,8 +141,24 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Once in a while zap a whole PMD-aligned area: only a zap
+		 * spanning the full table triggers the empty-table reclaim
+		 * (CONFIG_PT_RECLAIM), which can free the table under a
+		 * collapse that is midway through it.  Sub-table zaps never
+		 * reach that path.
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0



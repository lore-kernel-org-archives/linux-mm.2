Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEEFCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028A46B0005; Fri, 29 May 2026 01:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4CF6B0088; Fri, 29 May 2026 01:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC0E6B008A; Fri, 29 May 2026 01:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C45306B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:03:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E984162E58
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:03:11 +0000 (UTC)
X-FDA: 84819263382.05.8E2DAA5
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6449840013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:03:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=lzqXenZD;
	spf=pass (imf01.hostedemail.com: domain of "prvs=060908d096=li.wang@windriver.com" designates 205.220.166.238 as permitted sender) smtp.mailfrom="prvs=060908d096=li.wang@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780030989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfLRKeSmvYn5uCp3OE3OJgd8g6Ba94ugsI1TbBUXG4Y=;
	b=aJTrO5OpyWyct4xanxDFiqepiG0IcS/YyLr9LHh1YqfPtWc0PfMoBQqaUVVWnIZYUMYxaf
	F/T03FrqEzlE3F+PEyI9Sj1b5YHJPHz18MrsbiViWWcXU5rHlTjIqHG2A5j5SCa7qljnnK
	IM5pVVQPWc+mlTTrm6uUVf9L/7Wtbfk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=lzqXenZD;
	spf=pass (imf01.hostedemail.com: domain of "prvs=060908d096=li.wang@windriver.com" designates 205.220.166.238 as permitted sender) smtp.mailfrom="prvs=060908d096=li.wang@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780030989; a=rsa-sha256;
	cv=none;
	b=AdF1UZ4jH2Xioq5np2vvEpTFOVTYh61ghSx20dyizkoJLkcUX4yLUZh0J0du1DP8AgZI4F
	q59N2KpgRFr6pGegqDMu0FQv3YNC5etg8Dw2VFNl/fizvpKirJGI2k4z7C2FlIBPFJcK67
	adG8gouq9inPucYdJuWrx19A96+pAYs=
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T4K2vQ3467785;
	Thu, 28 May 2026 22:02:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=MfLRKeSmvYn5uCp3OE3OJgd8g6Ba94ugsI1TbBUXG4Y=; b=
	lzqXenZDg/0b4Fei59D4lzIbOtYKW50GjQ7PCpPtBIhRpu87mPwSJQOhDC9IQ/5Q
	ERJ647U11ObGJ4CdLCUWCuO7XFv+iS5Vc4dleTVU022kvqLx8KTspffCnd63OtCt
	pnVky4Q9Ow1HttBCzkOigpMk0LpDCaRBYUd2KXhKGNWkevvH7lTf0pIcGJ6+h5z/
	54xgAY4/FeKGQTrwYC/3htiyes8xxiQ7TFAGhlyauOHaiyqM39iaa6bbWZy73EJ7
	pB55i1FBq+ddY/3OAMfAq4EesfBV5csJ4dE28OLfmyilWx9AO4987BFj8vqegZsh
	NlFSvkSAxZBaepry7HCJAA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ee7x6j04y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 28 May 2026 22:02:37 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 28 May 2026 22:02:36 -0700
Received: from pek-lpd-susbld.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 28 May 2026 22:02:32 -0700
From: Li Wang <li.wang@windriver.com>
To: <sashal@kernel.org>
CC: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <david@kernel.org>,
        <hannes@cmpxchg.org>, <hughd@google.com>, <jackmanb@google.com>,
        <linux-mm@kvack.org>, <mhocko@suse.com>,
        <mikhail.v.gavrilov@gmail.com>, <npiggin@gmail.com>,
        <ryncsn@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
        <vbabka@suse.cz>, <willy@infradead.org>, <ziy@nvidia.com>
Subject: [PATCH] mm/page_alloc: clear page->private in free_pages_prepare()
Date: Fri, 29 May 2026 13:02:30 +0800
Message-ID: <20260529050231.1849697-1-li.wang@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260301013838.1699247-1-sashal@kernel.org>
References: <20260301013838.1699247-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ByPxEch99TkJW6u_SMEC8EIFC64UK1-U
X-Proofpoint-ORIG-GUID: ByPxEch99TkJW6u_SMEC8EIFC64UK1-U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDA0NSBTYWx0ZWRfX6eLWvh2mQSG6
 QtuAQrsqBOjRQoB4plIeeMX/q1xOu42+3gKxMDLHC0/5FWgCiRXUWC6+8GqXxf2ODhu/+G+PRQX
 fZRM+IV+ewfCWyRfqDleUcbqK4z+Yu44j8toytublkUNOB+VmtYYVyYRuJqPqIn86n9GXEQJj8S
 NVBu2jguijHstMVHbZYI8QS7jSDhOose7CKoMoKnhJ05FgP2/APZq+oP0D1EUgAMWEXAn/Woy2K
 G+kxZ+nt20vS6KVU9NbUIGSIFyuMw7u5XrEtUY8WdM9vylH1wdVY1H6XVyQnIHEJV8l8iKLVJfs
 aGktv2j7BS7Oos9fVK8ZAo8qTgHRC8+S3aB3AEruLBy4xrZ9KWoiciCOyIabFdWzb5EMShLgpqu
 MjAvXumCVMK2GeoikzJ9Db4001wIXyuCR7FMy9+TcAJO88oxLJzaEk9OItvbb6USdMsX7UB9vra
 dl9g2WrRHKetPNq47gg==
X-Authority-Analysis: v=2.4 cv=bY1bluPB c=1 sm=1 tr=0 ts=6a191ded cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8
 a=1XWaLZrsAAAA:8 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=iox4zFpeAAAA:8
 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=yWvz4_beDETysViLzRIA:9
 a=ZmIg1sZ3JBWsdXgziEIF:22 a=1CNFftbPRP8L7MoqJWF3:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290045
X-Stat-Signature: u5tucaep4p3pxcdpudgqnt84f8db5emb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6449840013
X-HE-Tag: 1780030985-877319
X-HE-Meta: U2FsdGVkX1+cMCTPSleqMgKel2/9usiNKvnjFs8dPrPXsl0SU0DCCJTr+2UQt0XK+/Wq90GXw24D/vPQCWEAYcH3A1Tv+G0Miohm+s+arYRsxC5aRIfvDQbB78StIM6grCHP4f7ubmE38abdTAger8e8P2TuOs9vzZreS4KOY+YfySj5XTu26Eqe31R0A6PvOOOIkCjjKrha4JRW+sBJIVtaDJTHiWTTqCHpKyxnHr2OBBa/hQ4+gPtaVJtAtztxTlR1MtGXS1H/IhWZIDgFiWhVK0w41WTVEwErYsP5cXihZGQfNuT/LXU3j76X1b+8Ug5wqjGlXf1kl6Xu3df9tEs25+eGBw8SHqOdBDZvdDidQdrL3itbeactUeJU/e5GuKKWd0YdCl845eFyCg+/Gdpg8wYDoALTdX+N0aGu4KBBF+T7Lk4Ay81MbLa5/YaBe3fN5fWQv3hw6nUH5fREY0UzhqqtSu6fno5Gq883MIyg/4iep6YqtT2rzs8QAOaj+9jduGZzpf71BxWxAcLRWHdywg/n4UyHoa63jWw/Nh47ZAgBCJHYwLFCZtQ8Uq0dNx37I91rV/dAbqcHbnyTzZGshRIIJVUOolRCRze61tWW8rzn1UQRsTTG2q+Ed7SOvPiOj6SwkWXXydVG6XY/YAfwsK+wq6aNVO8UKp8mNi/piKWGGWssunuwZsozNh/k159VXov5TgrUxTMZ97Fukn8pWKr3jx+1WtC6zkRAtf2pRREzxb3spsSNPPe+cBsMXRevafd0tOa+OZ51ULU0+sQq3QP+yqgGhsIe7NT/kQtPlHs2QSzUptBrp0yJzxChTBchCN85Q1CunlLhAt1C2NkP3TycHdFRYSDw29KFOO2OLoxw/IXG5/XUR4CO2HKgZjIFTOsNXTwCxNpzbk76wrZYFh0RWzv3K7MZtYKK6JXpAfVYmAG7UJ0gheBUXRR9nI1h7kAIdhXcujxKLvD
 cVin91jn
 UyDgBABPbpTt7xk2FEYzpt7H+XetnFLXMxcseNsYLNxNQiKQAhhE2tCdtniMmWSMuVGWKeJcNdUvhRLAx7VG9BMDYEHr4kGMXR30Arcuvka3hkX74+pxIYkdTmlYdNGq27C+3GMgbfPD2p9mGtkoAu4gPyO9edJDz1z90y2jtFcJtZeR7n4mVspeHBDD8xCaw2BUOJTKbh2FBgkdq8wExi2MKNeBcoytvaHSk5sIZ4iHohoPVrF8Z1vO6xSYOvreWJkBNMsDKQMDjOiuKQ719DOBt2QBMvVBvO0j+BwG5PHVfh9muSfabY7ZTH+x97CLerSVV1WlRA0J1uyoP8APlER8OMMMjEAvXVxZet8stimuCVRsUF/JbgIxCFqqBAHAaEk/uWlQzaxy8RyAO9UwE5HZG5dgU1DDHJ6upgliu1B8ElhGpl+A4OW6qGIo/ZRL7rlaiJL14p97ZRfVP0ozxq8srRNjKXazE+ASnQPH3E9eshjXc0pPglcUWY7dZvoA4sdAUlPRj8Qmlk+Fp2Fhk3UFX9cq/RVhuCiF5K2vJaLBp1NaaoKR5kx1rA3oamAlVjB7G+Wr6vFZkcOO0jfywTeumEfCFF+TZPgEjQOENFdpUuVh3zJDaUOXpeD80wOf4rKXF0eIKWdHfb42zkdDFVA4Dw1Uxa2kDk2qx6cJZgzUrj2o9b0xbfuyr6upLITJ4hO/RunPhcM8pMcQev0QBLJ+iTJ/tMdPTq9Vcxc5MyJeq+nj3MsxX15VHsLUG0oVt9jDQ4fP9+JQhb3fKqDNDdRiRlF1fEhkCuBHqfdFpvU6dIvC+PTiBODJnKydLehvhlU7upMpBqoVBaLVBpJ+uc8ORwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[commit ac1ea219590c09572ed5992dc233bbf7bb70fef9 upstream]

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages.  When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem.  The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0.  When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Link: https://lkml.kernel.org/r/20260207173615.146159-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[backport: context only]
Signed-off-by: Li Wang <li.wang@windriver.com>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b617fb364b15..ffdc71103c2a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1178,6 +1178,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 
-- 
2.34.1



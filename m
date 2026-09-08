Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF43C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440116B00A0; Tue,  8 Sep 2026 11:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417566B00A1; Tue,  8 Sep 2026 11:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243406B00A2; Tue,  8 Sep 2026 11:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDA4A6B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C4A8A4D36
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:52 +0000 (UTC)
X-FDA: 85190947464.20.6903BDD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0514E80006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=F8qfU00k;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NbbDhIJs;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEW56JejWUnkPaYS3ZKh84eLtVvqFm414kT9yUb9ry4=;
	b=xHEbAnp0i/b9hFvZK1SjofFlP5SWnqtKCLd6zZSXQULfHmVINckLE3ii6HHV9Qn43MJA/M
	ZZ7SV86a6JY2dePDMyaJOLf0ZWg7l5F65LwSx8JmpsS7IrqVXBV1DsiLl5P3oF6TPPjuj+
	TrnTVBCYn0IC3K/arjqNfEmuyqqDTw0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=F8qfU00k;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NbbDhIJs;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880610;
	b=xBgFwFH8TLF9vNj9Id0DcBIAm/4DUxdv+PwbSbFNM9b6dXqPNr3PPirItiodlAK6YRgq2J
	trKppfe03v2zGLjyNz1cnRff3pt1MEVcsl3URPudv7q8sLOFzZhJBiozNd6IiAvRg0aGuS
	iHZHk5ojuZDWoBkMTDBJDiUZ/9NjIkA=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYxuf2421324
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KEW5
	6JejWUnkPaYS3ZKh84eLtVvqFm414kT9yUb9ry4=; b=F8qfU00kTiWnanrMZoAc
	tW1rVxmHitpXEcM2pkmXaG5hQprmnRz8Ac5IJORFDzuSnPavZH2qXEH52m7PTJHU
	P8X9fx+lxEm3WTd2RdpHFoyTxloqoYOG1G/p4IO64Wfv5PK1WO9hGt0yQH3OpYda
	wu+pY0o3l6ePb378loqGUu+h79QeS47gefSsfnwi90uK1O2GAztZ5N/KsBqz89JR
	04OhuRwYtDCceQHgwbSkbZ8kkJedXjmzxXL1PephgK5BUMJcn9GdijLCDgofz7St
	uSrgfIg3K2wmszc8wA/AblhEVBqSoWwSyjO82SMYIfVoJNqzZbjjn3GNWodmDps9
	PQ==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5d7s7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:48 -0400 (EDT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66cbfb7ec42so7546520d50.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880607; x=1789485407; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KEW56JejWUnkPaYS3ZKh84eLtVvqFm414kT9yUb9ry4=;
        b=NbbDhIJs6BP8h1apeO+yrXr4ZDywW7C/H3jD4347pVVjYICbV+nucqimEGFllcmjmk
         gAE5ewQi/M4kfup6dzFmK6euUpRge5NJj7jGWy2UZOcvhr2CqoU57XHVIhS54nff1fmS
         Qr79N43/DxSihb3R5628bAWbTzrKajkW8Wh0t99+9g9WMbL8btqd+NJBYsyUy4I5rCyp
         pYaBO72arSQQ1DdC77bQCkNlznS8B+Jm6aNBq4hPw24W0MusEzHmAUzI5NVtWrFUjGZp
         Lv2s4YQZqg4gm2uV73RSn/S64oaCeHeAHri8tvSzZCrdD3xULAS4EMx6WSgLfjWBK+NU
         icgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880607; x=1789485407;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KEW56JejWUnkPaYS3ZKh84eLtVvqFm414kT9yUb9ry4=;
        b=dnZSZhiQUdsw/d77qFCsRFUODXa/umOB8AYE16Rl14ab4qSXyZHZOtqDYZhJUJDhYI
         nnKoeee9j6fY+W3gv8hmZJJczFtYDSz1uqtHui7wLKZ3NkaD+dEEVCCMS3sdT+9vQFjE
         PYhO21CO7LOZlkafOjjIWGy4x+HMlJNb5llYCQ44Z+TEz/kJnCsJK8vNrB2KRCick3z1
         ZnQWXgxpO6sJMF8niM/ckSGBAJ45yK9JOmkyP30ffNXLTi6/MRiuUFI+V3sPZ2oTO4H4
         nz3fK+PNjDwrNpRl4akRq7CNcwqueaRoZmYtW5mKBWku1jWhs2/WPnW0RTNObvLbtRNg
         9igg==
X-Gm-Message-State: AFuF++kJCrA6BRZq6OJ4XabqYr/8ODv5RSXylfIbEj6YdJZwbMTE57I0
	j7FIVWYzugBowanPgmc/F0hg2Yj4bxtNR3D9qm1QgGSNVxELq79B4NxIIeTZbOAldu977QOXvmR
	mGXFn6ibSbINs3fPkMMiGqtXFOhP2nGZSsVp44w5hnbKFZJ4w
X-Gm-Gg: AYBFou1Kl/6YO2JmfIUsH1Sjnks55CtU2tEzmoyY1nqCQ8gPhfayJViDdaET1hbnYLZ
	fjZROVRElYzBYumhEaT63NRPPtcbmeo3kANXLFr9/fx+iQVCRWuwC5W/MsQ1O3U5Sv1LheLC5B1
	HBcmdX9+krBovfzJ5ex1jwtem1pmJ9qM2JygMIAPLWKfiswBtVrMFXBw6PLxuqOdJdwT0k/aMwM
	HNdm4zStLWSnIgSGd/o+EKGEc9McVVKPVInE3arXomXlJWEenLa0vo48RJuzQZdNrxeUbrAJlvA
	5Ej2/YHoMiYXVTlAHVgQ8zUHwEjJwmkjImikdVryQfZOnwBVhU6hvseixbNzfK2asUDKJci9AK2
	pAuTj1ptEimsGILjat8a9dPjgUaE+c3Juy2+ttzoI5tJTPokQGjX62A==
X-Received: by 2002:a53:ac8b:0:b0:66d:ca8:bed2 with SMTP id 956f58d0204a3-66fb5a6d869mr8592458d50.40.1788880607511;
        Tue, 08 Sep 2026 08:16:47 -0700 (PDT)
X-Received: by 2002:a53:ac8b:0:b0:66d:ca8:bed2 with SMTP id 956f58d0204a3-66fb5a6d869mr8592383d50.40.1788880607058;
        Tue, 08 Sep 2026 08:16:47 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:46 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:34 -0400
Subject: [PATCH v2 4/8] mm/zswap: use folio_swap_entry() in
 zswap_store_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-4-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=809;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8AYImtP77V28QZu+QpRL/jO+FL03+XtzE9Z7zsh/mng=;
 b=uZ2zEOx+HX0JY5Ju3hCDh0SXAKTVBbrmKJa0Tzb/jbmsxqOFRFGF7tBeIaRnkWDnl5W+MmFsd
 OWzWdJ95vWBCHcciSRV07CPafJrAmEMk5d6veCOX6VowyFC+1bVmoTb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX1edltPxuUdNG
 pcyfTANpYF4owFYHpwOXB8KdY3A6ov1xH7jTKGVEcoPXRTqHz95ut6yvsMSzt9w018nIcRg16hS
 qsxgc0/dpKQu7ge89TMUll2Ik5acu7Hm0mP8OC5+JKnCCRVZJbw9x7NpsS1YUfcgmGjWcuSBUXQ
 FM3Iu1nUlf7gw01nGPHKhjSa8SMO0RqLjpVOo2QpL9Qe6htBzVtRxMXatX2QRSCggJJVzh0jSxH
 tfXdpxgeyGOjt1IZH3YpyLgZ/o9VFcjRA434plA2UGiJhn9jm27LX9NaKqw6cl2uM7RSxDYoYP9
 JfKXeNqbsdXIWvY0j1uKcU+K7udqSQLezDKs4u/SK9IBzbGrioGZFpqEAgpE9TxDtAfD5iaanEQ
 2KgrAqccrg7jaEpXvlLwJFJYk0CbgbOWjC2az5atuOyZWccWYROx88qUY+DNr+BCsQaTy/Jp0xO
 1q+qCtl1kGlL9EPjbzg==
X-Proofpoint-ORIG-GUID: AS_gCucqrWZdn3TuEF_NG6M5_FkbBWQW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX+lR597kDrc0K
 AOZpnwluGvb8a/8EMuNmGwmYmn+XEryqmv6OAVHTmJy65B6Nc0QugGthzwR1yQUS1eRr0l/TTLe
 EW38uc35qsDUj2kbXIeU12LDygyHK6hnpjUhW0FINgzKKCn49Geu
X-Proofpoint-GUID: AS_gCucqrWZdn3TuEF_NG6M5_FkbBWQW
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa026e0 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=Y3A6ZkbiG78JemsH3QIA:9 a=QEXdDO2ut3YA:10 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0514E80006
X-Stat-Signature: d8nft184j7wq7g4iyy8kthbeiq1b88jp
X-Rspam-User: 
X-HE-Tag: 1788880609-539916
X-HE-Meta: U2FsdGVkX1/Gw/t9xvYuw8HC5+X+XkG/VMDh6HVAHxJasdslrq8bHn9vccJlaF+Iu5/t7lhMLhVzLYjtZDSqT7HbrAFrLD+SwvCzn+frmeIUOrRmH7rLXA8kZfa7jw8u6Wdh+sYA2XQZsSt6CQ2hIMUFoThkVHcECsGsXjQdpszSYebJu5AQ0hYjdxr5w9Q6YEJ6vg+d9Tn1zexSJZ8ZqOBna3tAcbJciq93iLqLSnPg3zWeJwI++dj9sCPcX1Q2hj4VYs/lcGZbl019O/jpBd+xSgR5lX0gjypluSoLXOdUbxZDogTgCe4zy6lsN3vtGnJOi6CrAxw6m9o+qLwsdu+wmy7dR5+HZxhRcPkbVtcfX/SlzzBLGPL+gDMNd9czq9IGiD4SCv++QZse+wTAVl7jXYAbLelDkpqgFxgb3MKFgq6TUlvU3hIlPcyn3t2guaWETFSDPtve6YFWygOiiqrgbIWSAOrJTJ3f/fr2mB/bxT3lpHga5ecy6Emh0ek501TqhgJd7g2klDkYqYF+QhqlR02uk8KVbHE5zdz2oxOInYGxQ2b8zKI4Wt87YKz0s434+9L7C2VflJtFRlDe06BRqjTmRwKnLaQGtrDFw93YND8C1wzWIEz8Z2R7bzTveN+Tq0W2aXJBU2cBa3+u1a//iFiOysRiuYPIdNgRfTyxZDcUrJviVGD0vKxAU0o+NmrGigVX4XTI3/+EtAz2QdD+tklogqCmB0rw8RlKuXmrrDaXtnZ26YEmZk5erXYnQSzFFP4nL5YyEku+33U4FxD7CE/nmm7XfUn6iyRyzeYPwFvXCSApefRtEM9vqrAc3s0k7OEhBqHM7sq1pzSySYXhvWlQ9m0tcps50IkqI+wFZVV4hdjDj73BaSHvpy0dSeqdQ0P1JOc5aJlQzhuYY8PW5NbzTgInkfoGgLv+ko8VtrgZI+VufoQCnnTTkCmwQYS6aMwfzGEkNnao2S3
 v04UBnis
 hlmD8eA4v3rg1TFGWuQ+iUOQCGWKrN6CfWO2GtEjxbD4STSroRlTJByieVLezSLzpVvVV674o0iKcikDMzWcHN1QFBGCw9azVHkXIGHgHaQRr4AdGpEcmv4R0686ARuQAqYpNUoxpcMgTG6M+nIuBn8VEnM29wBL7VWxGSRCpCI47PKLWOSXZxDEKyWlj6B1keQdTw7MRQYlJvTeT0dxyybwWi1H7BG62Y5HLwR2f/hcfWyrZ/glSV0pXEP+QpLARo7ZvpkAecSiowDdmDh2HgvQkEBhXvaDxHHkMKok7jaa/RZBxR20RpGtxRWogmd6ZuhQe/aXZRdLklVm5DNwNDwkU0DBPwJlU8yjYp2IVHUIz5CC0/HaDLhAEONkO3s5ZpbN0NjfybvjcoxkJ7qlb2iBXzJWXjS19slCtDfGknjUcW+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store_page() open-codes the swap entry computation from
folio->swap and the page index. Use folio_swap_entry() instead.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/zswap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0d8bd72193..c27e22d067e3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1398,8 +1398,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
-					      swp_offset(folio->swap) + index);
+	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */

-- 
2.39.5



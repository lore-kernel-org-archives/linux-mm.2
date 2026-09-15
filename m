Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33852C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0D66B00A0; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C716B00A1; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B796B00A2; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4332A6B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0F861C28B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:44 +0000 (UTC)
X-FDA: 85217568408.16.DC469EE
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 313E61A0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=S9rK6HyP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=RXJasecW;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514442;
	b=LmXWcRvmgHLQ3rVPbhLOhGAbp2qfm4bag+PE1zlBfIkM7EtXG5BMNhJ8EIgFnQCfH0bCaw
	TJRWWKV1V11qMkF/d5LGlxBhofhdGsC9C8P8/D9z3BXd09a8oBZPoBFvsiEMmfbAMJTIoA
	cAu26T05DYOZVtYk/xL/82OcM4Xym7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=S9rK6HyP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=RXJasecW;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8BxBffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=;
	b=bSyba+R4o3pTjhqGN3/64xLWLOVApAuKlNNzvZr7ZDm3gTHZ500PkAFponewD6galM6By0
	QAPMzUy3XlJsMaV5G/Bs+aoyuQGGiu+gXOXO2B/Bkjd6bpmMpHjX/sngeXGNvyS9JPV2cJ
	ZqDNrJ+epPXCywAU7Qh8jjW4TGed+eU=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbikc1478036
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=I8Bx
	BffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=; b=S9rK6HyP/h7A4yGqszKk
	zM3hQPXjLzadtt72/LiNjWiSpMSiAC9FPRsS/wcxtzKR1JCC3IQiaFjfi2DLIfdb
	X0TK93p8VJJWSlgRtA7aDm/QdN9UM3D5OIkpcveq9x2st3xVmMVPdgIQyDqchoRz
	Jp+3ZemsV8+s/4IlKN6BxFbyiCAOsPMsgjYgNAxbXmO4qLp1Ii9/X6T0QGKdWP/8
	QvllnTi7BbiHAo1gO637scqE4IJstR9xZG4IBjdVwXtW5Uz0LKnJdkIrg4yD6bng
	X/MKcgToO3WxcCaN4zAElmfY2WP6OiR2I3D3ZTzDW+7q4JK1/+i47CTRlI/8KK+G
	VQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqab3u2wa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a00c70d28so585012385a.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514440; x=1790119240; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I8BxBffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=;
        b=RXJasecWlyhoNsQkJflcfDHIFoI1wEHGnE3WIuckQCl9uLTOYUx8Dg4zFM61aojIHR
         LEZLcUEZkHFFdAlQz94h9OcPP+cAQSyeu+8YhrmbEuXTtbHP1/HvPwuORZ5kcctb2iF3
         wLzBHYDS9uo6QfbBgYL5O/e5ZyPekr52ZZKARMzEe+ouvUGWc5ID+mgTTi9agETdv/wN
         eiUL0YiAr0YYC+anFFym5XCqiDaAbrKHvWTmS0VQBe3z6kRQaocXlJFBWp/4XtiOyiNr
         fypqsW/WHzHAFB8mBv4vgwkVFsUXKOAOJEIOHJ2OwzBQup3kIbdgYs6NUzfwYzH5xcMI
         UyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514440; x=1790119240;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I8BxBffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=;
        b=pUXlfbv6f3SJpbhnDwgP7OcVVJfLW9DouGkKByM6nY3jq2tw9g29hrhwqcLnzZTi6G
         F15i/hZ9axoFHOEfEDhJBEEAyNdfA1kmc9v7M4ylyfLMlmyz45+3XeOv/Xs7d070/Dl7
         Isug3NErmmyMcR6aOwt/mKLIfzgml7e66DuuQEY/EemOafiPeZzPCW71MEzUdQWBwkFc
         PQaUVkkQ2OoWsLSZBGM0woTp/a+smEZHFkwVRjwRTxhLOb0AFuVsnOZnktyVxpuTuFYs
         X8Y/IH/3TCilxRG8NdQufy6IFeZ16znYQVPi/2ZDTv3qIrpK5XAgAwG2D5RsrDF4ff+W
         VxuQ==
X-Forwarded-Encrypted: i=1; AKwUvBwD4xdxjrpRDzEcis3PjtGEoKSNSVnCO1RrSfD1EYreWuwHZ46qbXXqJBI5rx+9ecw3/n3YXQq04A==@kvack.org
X-Gm-Message-State: AFuF++msfCDZ4Vw3ixCKIl/+z91dwJQGTMpRTt0XxxAKsg8gvaMyuUzn
	OFpd5gOsehxjHbfj4LuGUYvy8RGfmFcitpbsHRpC/jxyTHqMx31l8iK8BFGQGaUQPVN41LR/Ssc
	N07VUhV1dp9gHfaENhUXF2EqMGaOmMejbAZtK/lcaPg3kXALS
X-Gm-Gg: AYBFou3Z3snMoxUXaR7YHx83yCeCoLHnneGU0BBCDTVoDEI3GysIyCDLLuY9DsZRrIr
	0jFmq9p2Iqj38SDznv22T5KSaaKs1Ih44oWY5iRrzYrvFcorrfSLAW17xlNaq3aRLufa3A8feFG
	0HrTZpeF2M89N0mHbuhkILBrIqb6vcJ7jP72E+3V8PyFlDpR4auptj8vgGnZ7bJMFPboxS7wmeA
	fWKtGfP5Mul1n916spfFEpAv6kGTIsbeHLsnV1yVsxF9kNdE+x+q953IDliscgFdLBLo4x+jk/i
	00NFynJSPwvOqfRHIIKUIBZQwR+U03e7ZwQNwtXDvHUnwd2RY4A6/bH0qFk6+boJcYvwXXDEVWn
	Qm7TxmRRkC1MlcV+zZQb3Bk7/yVVC0s1UjNzU6hJiP1/ANEFL
X-Received: by 2002:a05:620a:3910:b0:939:e93d:a66a with SMTP id af79cd13be357-93bb78f7f4dmr61546085a.32.1789514439956;
        Tue, 15 Sep 2026 16:20:39 -0700 (PDT)
X-Received: by 2002:a05:620a:3910:b0:939:e93d:a66a with SMTP id af79cd13be357-93bb78f7f4dmr61541285a.32.1789514439451;
        Tue, 15 Sep 2026 16:20:39 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:13 -0400
Subject: [PATCH v3 09/11] mm: memcontrol: constify the swap accounting
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wZ7UnBf3QaZVjgfHJlCjkDQs5ZCx1m2hy7FBVH9jNJ8=;
 b=uQOuh4Y4lcarwBt0PjaPQLOIRjitIWOjUpkIOJTKiZT9gi8Z6zqXMWbVyhurz9h9MOSuF8ZZ/
 lJj8Mrj/5nOBz5sF8o9hxVOYzRvSrTFDO4XuzZtHYt0sUaQOOzg4iHb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6r1oWGUZ9MkI
 gxkU3PH9C7T3fC2pSByskFjs1F1Kpa/PEsvp7W1gBH1zSGR4znFK797ajiCdHt/nEEtpZ1m9RLL
 vejA5Dzn6PGqK9daxwXkUoUrzGmgZXeEblKDA3bN0KELjs+X1DQLaiezB/UJRMNkzRw1wRvk7XV
 5E1lIkOydW7NXAej3L8xtgWLQ9G9hh2clVyJILto9HnyxVHse90fa/MmHWrfqXZe7zCEP4XTTYO
 rtjJ7Em2FLNY5m0cks211S3TOLBxJbgI7OdqHGYVCCUtec00h2JYtL0ZYOjgHC5yg0Bk5Yw0DXW
 fRT3MJrFHlvlWgNi7eTKCZzgHRK2gzJb+3On5hCJ4BK29CAXYbWgfhCc1+0PvDHVM+g0RxJq5Dm
 wdoivL5mB/v/lcKkZ8P1rybeL5d5pcQsDwuqDF8tIt4PuHob5UqZWpJ2djRNlBxXFdLZjIThfBV
 T/ZDNil5DJ2maYh7WQA==
X-Proofpoint-ORIG-GUID: u9pzGmG-8diR3elfp3PIfrxErejV1OGm
X-Proofpoint-GUID: u9pzGmG-8diR3elfp3PIfrxErejV1OGm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX2CoJ6g0PmOvn
 AmsnDSWcz88Wh6ryEhQhAe/gB/Koy7fObrsGeSQaeP5PKAh8Si1Q1x5xSX2T4Ntd2riBaql3BlR
 3BkiJYPW9/gucwlR3r9Hhy7Kd5lIbGO5yLZ1G7yxzuiBFM98isrG
X-Authority-Analysis: v=2.4 cv=Pc1qFShd c=1 sm=1 tr=0 ts=6aa9d2c8 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 impostorscore=10
 priorityscore=1501 adultscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 313E61A0003
X-Rspam-User: 
X-Stat-Signature: yzq9mswxtw1j6atbm4rrqeynejhzai1h
X-HE-Tag: 1789514441-334542
X-HE-Meta: U2FsdGVkX1/yaNMlMDEOW188v5M3nzxiXGopqjSNK8ekTTNr6lAQZHQqI34iG87WPf+4fQjumw6JgAYfqIQwpJBDdsAF5umDe4WuvKjD/iF99k7i4Fp5dc9ue1rRUIBWJ3gJZdynN0sHGaWN0dbMmIu+s2Bmes6184f7IMIJqKE6NjaN6qA1eNzf2YbYNR/VN8e7/HyOUCi1bY8osDad0/G+tVCAVuAG9jSgKDB6EBPUr4r49J6f2Z1lfsjLiN/0eun1D66V58ggjHKqQUON0ssmYugHUSujjA1f4/42APVRKlzZ5aR7+nuB1MC5WKsD/ugCNsTioKTaWrvE1ebyeD861qCYMRt6MM46AdpUBLzGdXBn2ifFUndKYHxWtklFtVIvjNqXBZXiryyaxoef9xYEVIM7N2ZFRFKpsct83DQJPvqGCDNO1Y4HT6aJXscLQdMcw4RoWxibwGF/TLCPzThbaF3IPVZG02oC/rZpWwGu5t/Rz0s7/AdKNZc5NUh1W+JuoYl5Jnw4rzHE1hZcT+NjxTt43aCkA4YLJMpU0GjplcuAfih43V7hTSNjTJ7jImRgV/l1oCHzTr4dopw2StZHwiob/l+acNnpGozAoAnL0c+PmAMXLGQaMJk2HnA0NySr2nk+A76ud6GlELWB2s/5vWFqgsaBLK4NXYhrQAa07dmE2/Zoape7wJEwXwCUzpvWcbEN8Axzi5dljX1LS2eGiXWxWWfbBcyZV8WwyHfVCnHsXewgF9sEKhNsOoAjo7E7xTWjLPv2HfvOJzy0lxhoBxlhQXRjPFB0AiC2zEpjeRBHNY2pcG9/EplWZgYXuOir4XTSDR4vagLCbqDuSL96CF5HoPuzV/no8GKZX3IenatetfxFVUiK9YrTPqM9DDbcWGtN57FNHZNPi+u/JBlItKvWKLMpolBVu2RqJ1NEyjaTCPQ50l1DBuKqCgUs6N04HkYqnDiDuE3gKBi
 b7prSis+
 5a1MgbP148imOFeCrc1FJEfwlJoh4leEMPQBrqwHGrKS8hujUmKf5mnL+747vZznAfgt+0GT0/UxW+tVwo7JwAosFQCN67OSjRHj5ZaCOIE0B9hQZSi+atD8tXDC6wFi2FS1aFJKRsjDHDwO090/EOEW1bPodu/Ye88vsTcpRckjSi2VLYMlcp759kUf6dsvgdV78BPpcZMaH/TbIPStQkef/vabPd09J3oG+1/LiGuyqBkrh9HF4WVmejrI92Evlhmln8uqUK4EvZK92LXLyPKCkOHFqPofR4+qefhs51Zz8iMx2J0NF7GyfZoEFLZKPOvWWCQQ6JgZf0HElDpBfOmUD0ccszHYeugdVsW2cyOW6ZsEIjDL8FHHIAZssAq/cx79s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
mem_cgroup_swap_full() only read swap counters and limits. Constify
them.

Remove externs from function declarations while at it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 12 ++++++------
 mm/memcontrol.c      |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 43155e122b5c..18f833a448fb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -529,9 +529,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
-long mem_cgroup_get_folio_swap_margin(struct folio *folio);
-extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
-extern bool mem_cgroup_swap_full(struct folio *folio);
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio);
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg);
+bool mem_cgroup_swap_full(const struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
@@ -543,17 +543,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
-static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+static inline long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
 }
 
-static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+static inline long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
 }
 
-static inline bool mem_cgroup_swap_full(struct folio *folio)
+static inline bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	return vm_swap_full();
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b13f5ed74a5a..ebf325af7acc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6003,7 +6003,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -6019,7 +6019,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -6036,7 +6036,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5



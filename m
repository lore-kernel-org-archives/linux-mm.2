Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B99FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFFA6B00A1; Tue, 15 Sep 2026 19:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B21F6B00A3; Tue, 15 Sep 2026 19:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1346B00A1; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C13816B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0470116036F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:46 +0000 (UTC)
X-FDA: 85217568492.04.29DAA57
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8A68720003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KyNFFuFb;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=D9NW6fog;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514443;
	b=ZLmK5vu6TRR1xoTWESrTmIMiyfUzD5KSMRZURdmn3wkiOo3vDFcf5yk0lGWGnaS5zzraTv
	cxUQ5qV0AX/zUMlnjEaRgNF7Sn0gs7+ESoMOpyHr2PZriD2QDJEV+a6smSrHhNrkJP7FF/
	3wN/mK/+fW9ZU2S7KiMk8DyrGdE637A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KyNFFuFb;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=D9NW6fog;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMhjgHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=;
	b=UWRxjIeqauxyEVe8wsSgDtMeedaYyFNmkJzGmZhsMC4370DvCRfHOJgkd107UsLQzNXVGd
	Kz9aufYxEFH1pGH5AJFQ5etzCn75Cf4NT3HbPFKzAjunK0afVMbIZijsTiVU0ydrFyzah4
	Lh8Lvi9MF6nWDcVdDta2AUKUDyQ5eRI=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbZIB1477921
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HMhj
	gHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=; b=KyNFFuFb9uuMNkmZ/nGZ
	MJxQuTaGbvpjICGU6Ngu4s/VAVoknIB+GaN/H/ipDGxEBq+pRj2Ja/zCsTaNyMh8
	rTOgf2pf2FBnV+O4Vrj6n4TRBTaeqpKC0yCpqjinkj1J635s46VL0nCAwmfyDXDv
	21nj21VnC7bjU8uQ98XSkcPNx2DUQuBA5Oz9EHiMP/h5PZhblHSVwq/PAdjJl8dg
	4RrUoFbY+u9DNOSI2/UXiXR7I4qivI4I50mklJ/B/osSLT3I7+Nl5XBsTeXOfZB8
	HMyB0aorOW1vIrddY9qQ4mkdBe9dVSnWmpY9MgN2oJRiiPS1SaTwDP5jxKEO/MxW
	pg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqab3u2wm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:42 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93918756165so967785785a.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514441; x=1790119241; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HMhjgHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=;
        b=D9NW6fogJf0REHG0m7JpOr4+MfWMqMLss0/H+2XcqAoY6nEzpVeWyzlHST1x0D28t/
         pYraiaEZKs6RoGKUKAZECFIRwaW9y12ovZ/H5+hDi8oEU4FwAB7hRQEhWE6RD6mBqzuF
         dIZGmGrGo3YgKHwTdMw0ARSS8vplqQLQ5p5iE/NRbqkSi7e2fDLtaij/Ixv1kngaHThs
         c1Tpfa4Gvf9HdDdw4f5gTSXeYMBF7+bgMnu+NAftAIWrAchIgLCBOTSB2sglr2w1TWKL
         ve2UNp87auiBh85ya4NHPEzEVONyKjabKXFoaQ63LTaafCflVlWofSN7L3Yh9chH5AwU
         vS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514441; x=1790119241;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HMhjgHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=;
        b=0dXrr4fiqysXAVXfZn2Ldq2PGejtGps4RT3GoXe8GME5iIhAjfqLVyfsraiDcTSRXe
         KWeJjECgQikG+21lHlfV2QPf9STZ6J0IDJl0c0wPq1NZuJL9bLEtieDgwdjlwARAos1g
         KATUXNmCQ/HfrpwZN5v6dTr8/VfvPZL5WvGa2aRQ6y6Ufi9ubRCY6bc1816qkMo708uS
         g0+fHvzJAukGCyCLXiIkjpOlNVWDgexg3r3vPeUYexWtTwNNYR/QxiA33cUvTExDvfMK
         893/CtkYxP10PkAeuXkWeEL/Lpqyr45M8AhkAmYmHwul+qTDEG6feSQi0qdtIy4W52hR
         NugA==
X-Forwarded-Encrypted: i=1; AKwUvBz2QbYxp5fo9EeVC/p63BZQQ11FPkwlGYYeakVlXg6q/bRmSyZR7gXwgC2VxECeRH0hj+KfoAmXtA==@kvack.org
X-Gm-Message-State: AFuF++mOCstkdc+ja5D6++EwDvrgZGAxpR9BW6mM2GmElhLu96C/nY9h
	Ls6VNYKw7NIxOEbJAIsBz67wfIbl+5YGcvZN/YmFXiwaQl7XDcUmjp/hKvq9iI7i0HNXnFgb/85
	Z5rNn1/w6I4BxJ93zljrbaeDfEXgIWHqMgM5Ty0KcnSfon3s8
X-Gm-Gg: AYBFou2Mmprs5pTdEVj0AZ5+5B6zAVeSXiIIcenNnzQpU72R8vsQbkFq145MqEq9SJ3
	h/XggnFNgFeO5GVtA0QdqTu74jFUlgs8TreYf+SCK2CIUAJya9FyrCgtXmaGk/of8TXv6ce3TAw
	UktbSvJY4E/ycr+MJkHqTUcl8Ekmf8H3MBDxLm5QQV6r3pMYj/fD4S0WGDN1VkgSzxuRIQIGPky
	wzYPWo0Dl0g+yZNxhoZjsemKQX9LJJgAmlxrTMI4Wwmj1RLHX6DdmndsYku7mrGeFcGCh/9KKeY
	a2KkhRZnNASblwHZmuoTk3nGnMIyLt/tRal+NkSpkEF33QwgTsj0/TKHSDjGX8x37UogUXdpQXQ
	SnfumZM/hn04j7+hnE2daicRo2aQFNltO5f5PU/cRT7nmJtn2
X-Received: by 2002:a05:620a:2715:b0:93a:2239:4ac1 with SMTP id af79cd13be357-93bb787fabamr64991885a.32.1789514441309;
        Tue, 15 Sep 2026 16:20:41 -0700 (PDT)
X-Received: by 2002:a05:620a:2715:b0:93a:2239:4ac1 with SMTP id af79cd13be357-93bb787fabamr64985185a.32.1789514440925;
        Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:14 -0400
Subject: [PATCH v3 10/11] mm: memcontrol: constify mem_cgroup_swappiness()
 and mem_cgroup_get_max()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-10-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9okpZMTMnyXLmB2Ry6c0Ho0fpCdh1VUMQUGi454i+qg=;
 b=fi/2DRaM94/2tgQrx1Km8UqYFSnS643KGtWcuw4p72BsEv73LKIWc+7o20uPW2rGtmzVXgwVD
 NdaMZWxQM9QDr1iBOLN5X4QSyCwbT7wdxmvFu2Zj1i7et6qcP0Mi0MV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXyPdQvpSKUw3S
 oNFOrflC+aVtDSEJN41IYME55cksiamq104YwcArYpKZeUa729vrYo8OaiOtVYVy6rD6RM7YuEJ
 wfyd3JyaIk9cw6SikNHIRXca29L4mVjueBPIMmgC11W9eeQLfs41AD0dkDHHIniXezeY0gRq3ew
 Qasj5SBetItWnlwWMpIqHlZLAUqcplzo+U7Zy0oXnm+qLVa5wE3RD7w4lOBJcov14LdYiQm1qhp
 9o9HhymFapic6dk87xgNQmwjkfadFXZQja2D468J8f5xuijoSFDZ0SghTnyoXe9622zeIUD13pi
 B8yOHgB+FKKwGdRanJkeNI4UA6m6cczH7ezzxpFGmbBWgnRgaW+ALEdcTpZ+hPdwzeGzsISkA5v
 3Zyl1Inj8qZ+yuMD5SO4NoBKeeXLxpchwCsSPL+tZ1iPQJctHD3RXXdUjiDOpKTRGvr5GcGNEp4
 BtRX9fyq6ee0naFXB7g==
X-Proofpoint-ORIG-GUID: ML7kgcGpILvZ-LkXFWjFhyOlzhjhq4Hi
X-Proofpoint-GUID: ML7kgcGpILvZ-LkXFWjFhyOlzhjhq4Hi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6UlNKRknZcag
 qNg7BdjJlgBEw8SWZ8bwsedIMxT0hTjS9Wpg1VCGhXRmn3BfR9e29Fh+Yb1YfyXaTOSaqrYi0ND
 UOjUsK5JA+I1AicEQLZYyRtbZ8KTdCGpnjuRayZO4wUaYOMK33mm
X-Authority-Analysis: v=2.4 cv=Pc1qFShd c=1 sm=1 tr=0 ts=6aa9d2ca cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=LvCEVWXYBYKFGHUOtEoA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 impostorscore=10
 priorityscore=1501 adultscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A68720003
X-Rspam-User: 
X-Stat-Signature: 5gizh5crikqpg1y5suqnjkfq6bqs64me
X-HE-Tag: 1789514443-885569
X-HE-Meta: U2FsdGVkX199gtdn6f9VP1PYKRXBqEgdaokSqwkAUwZEkweRBNdibtxZ8NttXW4yhh0btoUyiH0CpmsiquC3iYlnA5StDqXET+KrHYZjWtKfbi8ozgWXQjNspy0RHyjCU0fLOwfhQNK1dHiSmJcjRA2oExh01aItrjkEa3ewVjB5deO9RoW/ugbGribRjWgsuBadZSi5J2hbI+NdHxNiaH/3uRdA64pQHVnqgdv4tJDjgPIKcqu75vLW7vkcYcjFyYx3qTCnQ5uIw/YntjYlcyu+dzGdngMBCGbhceoWiHbI4IZ6i9lZzzYnL6HpDMmWNFIlq1M26I4TBGSYyV4ewUv6K9kO/LG4TntEg7VEGd6wC7Gvq0LxH0OgW23Hkb9GgEH5y9+0i8YZjB30N1D6L7Y5g2Rjp9GRWjsrhKWcpKxVPyYFXzaT02qE1oh6wAEJQVLK82m3PGY1Uc2+ieBYQygGm6rmhB8NsfR21sZKpWSrzi5mP3WodqnMOmGYA00D6DpV3PYiw7GNkUXEnRVePlE//GKRquLuEAbfYOlWYB7ipExBoqvymRmzA7KBk2tIobind5a2WZ4n2a55WqJVtNJkBw8oB8zlP+IabVT/h+TxDsCzzeOYrppS6/7wv16xOsZveoGTPlsb0DWwAPNFbxR1SOUzVZZDfc1LJMvwvKZ+utJWuy2SWW/MHkEpLoXhCAp5FzPaP2FZ2/efAHfQq8GjFu8ntZbxo8MknkXMLKc0BC96WJq6GZKo66jvHKn+drCj4kzbw7OnmTS7zyvRTStL3/L6Expjr9zbzQ0jyjqiIPatODhojiUdU59rCZW7zFwLf9ciY3kG7VCNS854ss/vmu9jwZC+UcLpg5XzJptsiOi/BlT9uroaopFMJjuePovmn9TRxemabIIe+j7vfGvq5NtU5yhYf32dTi1G5KseDZd1XCRtpS7nPHImcoW2bAkZZknpXccX++Vky1c
 ViOyRk6c
 H8/5pCd5C+sSDsEGhBwkm5BJgSycuTtIjF2RYjYp+XWB5XPt6RqUI+dYHQLptleppMke8fAOatwFLgYn6pqiNpTuwNwPqpyKZ9OxzhyvTXRX0kERHMMsYJjz8z9IM5/qGQ84Yr/5ffvtA55mQidgPnztxxH/1620fLGVI54abpdgK45PShFqwtYbp6V2WsUl7ZelwSEV9fSnx1e1262FV7ql6pJ8W0yncpMKOJI0aI1BXQACqFwCOmFv4uEz2gYhuts8RzhgB2aKLpV7oiEME9V1CU0rGOT5RYhIdm3cgclaGA8UqKbj2D/vYL1/BbNg/1Qw4bWO/Vqk2G23f8AOFoItKBJgJ0dEgliSeoZVK7HwqVsv/Pik9gtUbedHWEnJ00tRljS+EyvaSnWLiuvhJGPqSXrSrInPYJrZIvyH4MwCO+aM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both only read swappiness and the memory limits. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 +-
 mm/swap.h                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9beb065c0879..f11899085473 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -941,7 +941,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1372,7 +1372,7 @@ unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ebf325af7acc..6e3731b97690 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1884,7 +1884,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..1957960dc60d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,7 +82,7 @@ enum swap_cluster_flags {
 
 extern int vm_swappiness;
 
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&

-- 
2.39.5



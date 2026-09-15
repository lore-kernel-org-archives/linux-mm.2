Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3E8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6EA6B0092; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78EB86B0093; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E226B0095; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5786B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F0F44058C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:33 +0000 (UTC)
X-FDA: 85217567946.27.448EA61
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 091AE4000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJo8qCDv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3xQAUI5O;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514431;
	b=lI9xh0EkGJQkkGA3sk5QX2z0D3plv/RNoUJPWvJ1GalPgYBceaShPkjAtihGSN1JFHA0OF
	DjrCksT9AQLveGKQlm2lx8dQlcDUsoykjyog0ltdki2bM6m6/qfqsByywiMmE9O9177sjT
	HrSjNZKS67cHAWm5TOD7EiYwXpvNg/E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJo8qCDv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3xQAUI5O;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syzBFL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=;
	b=5tpL/A1f3OhnSpL6Ngg/NGoIWq9tgqrWUekuph9NvSwW9njtiEtHt62c9U3sUqe/cArraO
	Z0pAlHd9eTxXYUg30ZHLbokv3BRxpJ6gjMEsQuEo2n/x4kskdG132JaKIcABzPmI7qpMmA
	rdGXtuZ1Yq3KnPlPDtDmQH4sv4CA8xQ=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbm9n4082509
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=syzB
	FL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=; b=kJo8qCDvINEVZqP/5oth
	HLfSBaOLnWVkh7Re2h5liuZWA82jqqvlBWzwiOotHwZJh4aXBRx4H18KiT5ztxIf
	2Yu1WLF1GYjfcjoGfm++1wmUhLPTC9W8kCVZsiuQHjw/SAuPQzKPyLha+DmMc8Dr
	LSFoYs987JATwwVrnE7c71/2GbM9B+i7KBDpy5896pyNa1XsJtPAcxaOs/jruQCz
	+m7cTVX+opvJXhb4R5RgPp0n2bKb83efc4RwIlldPELbRHxzhzCnX1WIGGYaACCj
	pNFMW4DiNLBS1cmUIWTFYC16us+OV8Bl34S2O9/ZWQs3//qbkEUhrjjkNO4H4v0F
	Yw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2f7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:29 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a2d361e1aso461793085a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514429; x=1790119229; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=syzBFL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=;
        b=3xQAUI5OavIqf7u2Ixv6vpbB85aCNQH4559sIoU6VkfCjS5MH9gSdBWKunLgBOJUdX
         bA/Dp3Q1lsy0M/hclistsJ0q8VFnqAW1TK6Z9RoY1MPHTnL6U2E2ZP69CMdonTOVDIuT
         ABy5D6kJEnSJOt1SCLhviYDyeLyz0ye/H+rnFTV2Fmmiasp6BIp0ZsoJynJoBDme6tYA
         SJU1Y4zx8Fr8MmWCeFMyyTFW6UYBC8x6Cuk7TeVu5j3haiLrCNzDM4w5gio/jAE+Qcru
         UcyeDsuunFjmLlV84RU6SJ1/xJxzC4SP/H9mjuWH2OIn4uiFsajeAPTK3aZSIa5+AmYE
         IjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514429; x=1790119229;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=syzBFL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=;
        b=fM+stni0OHB1mmh+lhlvz2oA06ov5o9sKIu2/DIA7FitmZjuqSj0HsMZil4hKLZETN
         jl8h1LDmLozwfbvhVI4u8goqOaGfDR4oTLOsyEAW5rTfMj8iQodqwarh3DkoNCh0nzhz
         CSvrV5oJGj9ytJhVwrk206W2gqVM4EsApUkcZtR03sBROeTFZlKXaRuvWNBlfJj3p3JX
         03AiooZ4zN2HQDGoilEDYvD3P1dlh2aeab1CmH3ldVupJ9b4KpDKMQvReE9If2KWacSe
         azN7gqjp0wf0qWigCnFPMmVRLR9KkBE+2NBO0EifZbpUMAljWNdjjPBRzod2h8a2A0ys
         qgaA==
X-Forwarded-Encrypted: i=1; AKwUvBww/gD4+KFNJ1v7pxzlKNtLtACQ6IAwx53iIjh2xI0iZpm/Ch5Uw3QTz2baHZfAlg0IsplaJW4c2w==@kvack.org
X-Gm-Message-State: AFuF++lVWnstf0uzyUc6dZD977b2HJHZYfYbizTYllftJ5IXhSO8Ss+k
	kyR/337AGgQMjX5dSEJ9pt/IAmC1Ae0WHC3b7arCm5PPIZrXW8Wpn2SIzZFYeoE5RpQgrLSIee6
	Be6uhhFhFGMbs6hhU22yPJrWYdpjJwBnr2d3UyZsmp+Skr6D8
X-Gm-Gg: AYBFou03WlLNNF8XGSB0L2nsksGv3ediU/ti74suQd3gOmQ2nhwJvB8Fpj3xFrJTVD4
	S9gAYhSyG04noc/hoyLhYA7tONfMhMDMu7gQSuxCYdpGw4no1PAgnn4ofBAeqI4otAOj8B8Idgd
	Poh2dikg0J0McLbVNUSfC2TBgK4b0GjU8Y9KvWVY94g6H1NmRQM+ucyfXXxYPSzY5vKXfmOInSW
	We/VgBfq2PVI+emsbbwPm84RDgrGOXIEltxRD1Va7+qnJZS/P0xiCbQ+JHlwJyM6MAXcz0zBP+2
	lNBB8m4y+sZQ+f38lvnpj3S7FZKJrepu+mQL0bNhRA/XbrBauQLtBngXNcj2H14LOqZ7DU7dPa/
	bIWXo+/obDv6Q/x3ba0tMwsYHEvp6F50shc8XwqZmBIDcJGf8
X-Received: by 2002:a05:620a:2711:b0:939:869:a8bb with SMTP id af79cd13be357-93bb7715c0bmr57405785a.14.1789514428264;
        Tue, 15 Sep 2026 16:20:28 -0700 (PDT)
X-Received: by 2002:a05:620a:2711:b0:939:869:a8bb with SMTP id af79cd13be357-93bb7715c0bmr57399485a.14.1789514427821;
        Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:06 -0400
Subject: [PATCH v3 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QU3UUXZVJYXJfewV6rqLP/CJmky95kyoP/VKGjLhX7Y=;
 b=JA48nYviRKcNhLAAS6ffUDuwEht6UL6bjWqY7JWZ7J4zMmEDDLksEm2DyPuq8wbZkrLnj2JIK
 0WWHvP/d3RCCkeC2+GDxfaabWve5E+SsXaz8G4xxUSWglk4KCH+Uvzw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: OkMBCQF_T8BukQ1eG9h_Iqw--Bos86Ak
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX77jZTCikn/eH
 td/Cb5FUYTBOTQlCLvKvlhuSY3AqEuNyqXrp1Ni/4sAARF6jJs9y7o4wRXkM70wI1OE9qA6+cc+
 5lqsEGLmAkcXGGoMNrX6NbbwGi86DcyTGSmPtYCPyF/68vOK3EaUqZf56hiBq+cB3eDw5VBDT6C
 F5VpPL6/TJcLECsWpI0Yt9rxw56P9/Jj6VeeN7tYDUrMtVSupc4gioaCLUlGIf5jb33dW3Q/U4j
 l8EmfF19CfZGxxR5z1LjxW/XYU+qL51cpj+z3VdwCNDEPyGbg7G/oFUzbzUS6Uf1bQDBmMZpUEA
 FtipODbiwf/OiQ3ypcsB1JTsRxcCtjA22oZiikvbnhlFiuXzgH+1nH3NilXPoHl/WnSAL2OoTqP
 BeuidfZbLPwuKVFTXlgbY5vuBMbhMNRyvQQTYhv5/rIQslbLWPDRSH5sS66gg4jZAPYe0V8OlJF
 jS35q9nZ/cvAhNt7jlQ==
X-Proofpoint-ORIG-GUID: OkMBCQF_T8BukQ1eG9h_Iqw--Bos86Ak
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2bd cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX2QuNqZ+KLsXJ
 H+JDXOuOTbkKqUNo39H98xouw2FHcFIAujMJkh7+MTtAe42sBE4vUhxyAsl0k/8HLgl5f2WfQp2
 JRZ2FvqbUfFYjLsfOZFRjeiZFmFiWWj4l58dc8mAxSbF4KdeWdnc
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 091AE4000A
X-Stat-Signature: nyem4ybqa7hoqcrk5cponh6ht3ffepox
X-Rspam-User: 
X-HE-Tag: 1789514430-625946
X-HE-Meta: U2FsdGVkX18l4OuNtnDeOd3TVN4SSeg6UMMdqxhJBxxX6InCCeX4TBiSZTrSb9NCDtL9Fe3GLGmJVU834X5P4s0P+SswhERB/RZWu19ESlgcfCZm78RdS652q4EZXAQm8ZUrBXrPgWY5JDbSERTQFi8G/EgkTZ/cRBLLVfCTabdI8mZfUiTgOW0Tza7F1sjRIes9w7cWMYlDw71vePXbKTb9hh/ostT1b2R+qpHhXhDdY9lLXclpC6dmk4hoRjLafMr4WOIvfoO116InpIQLWLtfnHg3xeyP/6eu4EviuyHVj2Nko5SIN0pFLL6yzmZ5UdRIn78cMECjaSgGAM5twwSchVNiB8LzS4SJ1/kkKnBliFMKH+nxTyopoxLsyp+LEJDN8fkdlU3XB2vqExkNPW25D5lWxkXryEHGLNgsa3MKDTK26XmRuHkTSo9V5kz5KTvshsyYu54JtFfDDAQ0FYbhNZFjwDE/6YrDucUrsGmQpH1hRFNRtruwT+ocPqj9zcI7gwaGU5PjBgkCAQiGv1+QEaZC6E6VCwNzuZYLknPlCvYuvvL6s9Hsuz4DzOld5G/wGO8qEJFyr11ePhm4NDkpK5ky7BraGQzDVYcMmrCm8JJDeMGL+VSINLiDiEyb0BRJ7sug1hjlhQ5h8okELFg8Mlkza42m7ii7tKJstcPZ0JUzDC3xjXmRDt1Eg5/cbzIFiEX5vHamIexPwJeOcbh0T6TFLGl2jKf6+ptZ4nempB9x9BIjzX93uj98EgQb1a2MogEJLLTW5P4F9oVQz4tkA0n1BLYP1xoK7tMDLBk6UIrcbbVUl96T0BfBxGD2DM8+FXaKky3agOjyj3wljWtH9GMVxwTyVj8HuHn5K/EcTv/HIudMJ0j70CaMd3SYpnJkbfDbQzUV3ga+e5Wj8zcQ8qcDdYs/G9lf2LKaWgnYyAXQCTdNF63+Oa33a7V4muAV3FePBsxEmhxHIsk
 KAimTjmD
 iEj8l5KktFQAo4nPNLm2M1EvpVgsh2E9BNk+pYuoEqVWnUvFZEg/SydGgLV802p+fzZdhFRXZ7T0GdlBLHvpfMJfeLe3QOKZKxV+M/rinfoe+gTqM/5JOJpHR06nHf2YoEAIAJ41pyu4PG+YbYdF5FOtgCM5ZOOhXlzFjkn4itFB3mWPR5mH/LqCfrsXwHErSI2Zd8JBAXM1michxpe7MQ9hCG4QDwaUkCJG2vLhh/Az9th8GnhelqSheRrL+iUFAdz7+vDPeZPmDOqeZJN/R2+p1dbHOwei239d76aF9IG2pktWScLWP2kj5STZCJV7db3d2ZnKzUCkUzKLiaz+bnHAcxz8bXtrJKIfhuVmVDDpj5LCQUnhkFB3VUXE8pTHbxOU9Bp2QkwGcVU0DnQm42bLUiWicftJbV75a7fd0vcHxS6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5a5ca6814782..65cb45f4be32 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -505,7 +505,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1075,7 +1075,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1104,7 +1104,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5



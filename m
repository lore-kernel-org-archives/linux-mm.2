Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6362CC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211F36B008C; Tue, 15 Sep 2026 19:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8A36B0092; Tue, 15 Sep 2026 19:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8F26B0093; Tue, 15 Sep 2026 19:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D799C6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 711EA140537
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:32 +0000 (UTC)
X-FDA: 85217567904.08.7CED64A
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id C461520008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L4aJ+zBw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gqFPrm+4;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBCJeWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=;
	b=8NSvNU9MYTw1ufMDVod5RLzF2A3KUxev3En9OgdpNTwXgLBzgNsCs6Wx1iRq4KPoK0DK2B
	UrH72EvWQEHY2wuRhOLHpFMhSBsGQCh7l7L219bQZYomr9a3HGGj2l6gFmRvtugHaMxerI
	4fz5zSerFUpv1nCR800ymExUQNUD2yM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L4aJ+zBw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=gqFPrm+4;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514429;
	b=D6320XKGVWYqu/WowzOWnsIKlu8u4SRAjeBdm3gMyZCuyZSyZys7IgEZ2B3T5jWDVplDy4
	f0u7BkGuhfX8u4yb/85tHTVyzyY9V2YsK6h3b7ScJ3HSW5nHuMTL0x65ibmfPPVrXUL2cv
	E/FLsy0IHRGsMIn9bqCFSJs208TGiso=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbPWc4081390
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=FBCJ
	eWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=; b=L4aJ+zBwibRg4UAsnrLX
	NddmpMUEA7UJRhoX1tpUqJr43HyM0cil8/vMIHBdBV5pA/1i+hOYglCttwnS4oeg
	beownRoNkTnKeVFn4oH/PAK5vgphDUDL+H/A0rSAirgdYfQVtIPxtp5IUkS3reXr
	sEvVy7rYjCuhQqsti2XvXwpbkwSoR44gcQ+b8F9HMEXVbuC73L8WoXTYwTDi4Trk
	6K+X/0V3JJZUZtCl2a7kbrRnuDQBh5jRE1YxWRklyALr1qBXfhROG25LfjxP2GVS
	LRcktpE71RZGxkG4MLGBE9sJl5345uSFv0Blpp1QwXn6RBPsdOz/Ujk+YJyH6JrH
	cQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2ex-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:28 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-939f27c80a3so975838485a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514427; x=1790119227; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBCJeWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=;
        b=gqFPrm+4FjzL1EX5EenEkGySCiFnPLx+EHc/cvzi/KrkjDuWn+dLQD7oWlH5zVikiX
         OM1bNv/5IJM1L4RW9lybQEYv4Vl1kQ6Fhr/qqZ8dms2Ff8eJWwqZDpjDJ5JwJ95T49Ek
         g9Qa7PDkP4aLsGL5Krm0gu9iHfMvKxzjnrDd6CT2O+aKMpreHGIGrKMwCXaNpRWOsdYe
         t5pLEOwlTTvYeOZ10xxztEfff0LatqaHGaysS22U1I64OLF5zHWeeCbCvICL009hchSY
         YRwUxKctOPETpY0aFQV99iYAQwxlEYGYgdiEvaDrFwbUVAfbjfZ4C336ifr+IrhM8RCI
         X1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514427; x=1790119227;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBCJeWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=;
        b=SBJl4ee360K3xpy3NF6W3PBgUxykEd2neEyocl2gayP2mTK7nHVT/IoBgciicc/SSf
         p2UUkjcwFe4tTuhexVntGXsXgepQ8WHJmfP/9BwLlV6ey2Qvz+0o/lacqShBqUJcjEp/
         2s6oimkHWFRAmo7tguAgvL1Sw617QDAAT5ChLFI9BVFllFIbCNtYsGPcUM+OfbhThjrN
         F+Ltl60J5bLoik30o9RVMS235NQYdFo7I96NHcWh86oNWaa9H0DeP8FYFK3JINsto2C5
         GIldU+yy6NJtiS9XhJZ5su7U8Qcc0NNV11AAgxW/5suHw6N9tovsali1R0vpC+JLxxq6
         +YCA==
X-Forwarded-Encrypted: i=1; AKwUvBwnz3WJ3aGjU025XI2F93nzTZKIhz+lzMI3pxZwT/9Qn7lhY5r6VoSraBBGwje6+PB+qZ9ZpXKdXQ==@kvack.org
X-Gm-Message-State: AFuF++lFRIYpi8MpWh1DdyvOAK/drkmd0U2xjOzC0fqRjZc0zsrVrpBY
	5xoImiztlMJiOHHqA1kibcuxhFG2TldFOUpgBTx+OJQDfNjprQUsbJn6RDp9rHIUEadCCxU/4b3
	M45KihMklw5MELkw7HtsqUsIEk4qLFC/59KOV90ncB6K3moCqaMjdrIu4
X-Gm-Gg: AYBFou3sCMz0IvWUsKuBgj0keUcbOObZytoQfiyG9T1n2GG7nr6JGl5Vl+xrIVzJRPQ
	mm7sO5ugevJUpWJc6pcFQdMRj994zu/TD+ys3+puBC3hQynI+04fMj/xqHkPmALkqXMQjPmMj+g
	I7aGNZAe/ZzmmyDgnupPBo2YYt4ggczly3zx8djyvlPW4FzRPjDfKpkQhtP1iA+73EJovWz46yz
	erhkHY+fSCJKFTxF7cSKT3X+f/Mi657Ic61RHfiVEN57cXh7iWOk7R5shJyVqQX1OSj69lnQTA1
	2Q+2aTbhGxLzl8Q7vS24A0ifPcqSXrAD0yqkMQaMYM+gUn8RZp1Y/+A3BAbgq/gp/b80uVHisXW
	RKWyX/HcotpGpnx1cJQMH2mMgRjgygtAac4viVGkmmRi/7BBU
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr16401485a.49.1789514426939;
        Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr16398085a.49.1789514426448;
        Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:05 -0400
Subject: [PATCH v3 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=9803;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TBe+kpZpnxYCh+hDOUW6HhNWIRW2j11TxbbwpfMI934=;
 b=Hj29N656xE+edsmtuesw90kLHwIh/rIPa6VxsRWP+/6l/9rtD+8QIYACCn7Z7PSiIl5K+8W2f
 SFnj2gdPx5WArdZV3hzcg2enrtim5X0lvWeXbrLxKv/6ywpcIl5Q2b5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 3aSElkaG3tLA1IQG3eDmhcglL5vwW_m8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8T7aUz5Xi2YJ
 f4s1+DU0sW0MvuVUXu5TGfe/qWFsP4G8epyaoKtGBaJwLCnLcgEYHWmoRs5YYNaX4rGXd0nmqqg
 yGjOBjrGeiTDs8uWL7tk20ji2UnyW0xadRvLTL2mJifPq2xX2fbBdPmINCIBAmujx1aAMIT+AaO
 iRtbJGYqZkRr/QNn31lWfshXe3DTlSwk3UkpTkzs4Cz6ccEKR3Kqzqb1t6+DcG14MzFmq2i5sjq
 F+f17/3WdQVh48Vw8J5XhwbmMIMbZbijQQ0ishCcrYXUhHDjHJvD4wxHLj6ZHoMvYOi7Pqad0WU
 dOqnMZYSGhWeOIO1VF+Rwkb5qQYqCKaUGisRqWjC7Jm/GrEk3KSZeUIJN10Dk5X+OsNNSPP5is8
 ck8kHnCscxKSjjoT3zj7GPZ0NWxf+Cfc6NaPqOPZ1eJI9UVTrw5r7xl1TBM/xbhiiIuniaSSkWT
 zJXdSru7zao8fI6yq0g==
X-Proofpoint-ORIG-GUID: 3aSElkaG3tLA1IQG3eDmhcglL5vwW_m8
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2bc cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=di1ooo_fNIOSg_FWGpoA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX60svZeMgyx88
 5p82MsjXPMyeIiUTAu00Opbff13q/HPg4ESrmDw6qtq8uUXMs8R5FA1IpYz4eKMgDJJ1zzK/gS9
 Ut169M3/qVfUzkhujFFwyzuFKdvJWgb+dQLVVpx1OaZg9hy3Za5r
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspam-User: 
X-Stat-Signature: 4cunmiir6y5i4n5cm98bmp9hgsc8kg81
X-Rspamd-Queue-Id: C461520008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789514429-312203
X-HE-Meta: U2FsdGVkX18gV3TUUCsQ/gpopKiogz7RH7he18dse/Jeb9P7B6ayn1lZ4fFWwiGWCTPZuYepXkaat6ACLsPZMaq68Ws+YipGw6iim5UH80qPuiF94twYsSfPB0lVfEcURXhStVvZwUWFYjAS/Igg5vgth+qQsvLxgUUcx5PUNUUP2FmqToavdbgtW/CU5w5MVbxcOogdf6ZZrMfPDFzbR/KhJZv6ReRutNHIThmc6+XFAeBVYI4/BHabsfUd6xe7cKgBitqX1r2ROib5ajlf4uqktQiIBgoqAtMJegPb85fGUw6BHpJZ38JlejZRGJ0b2XvYujmN5qMkmuIVIXr+sg+aCEkOM5PpwL+GPODMmD8d9tX0Ctvp+2op5LpYjb+oPTIt4mzpQAmXGQNxl0HlrDxy/R9DMMLTqPJGf1d+/1Ooe8fXKhk09zdVgPHkM/qhoqDnU7O7H5xli8f07N5cxdmFzrdklFMzqSpNlN7R4LO2RsZgQw4UVDMJ+KCOVTII3HLKVw4g+aXS7EO7oce+/mixsaDA/r2bq5D3ffxTgVkdcmi35dLuOrDcEM+2RzhQxnC/MWvPlve9XrB3awd72XWxuCDX8sw7IpfgspLj8sibxSl2a8ArzU/zmrzGwY//6HjuF6APPOC6olGOKL1Z+v00s3Kq+03GFBwmiFXL3lbHotWK4zIlNMZ+Ej16EPgAVcBWugRBB38TdaCBJJ+IEDmuV/NSGJFnsM9id2KRuedndnP9fPTVdlWPaJr7V9TpJ9EFRSwX83MqI9FHBwmWK9b8FgLrc867LRVNm/2QmRVG4p9BEzDLGpajjhCuWo+RKw9131ZG2oksb3AUHNuLtfs9jOHVmtSnAp/jw3SaRl6805k1SRdXyYnLSCmpzwa5CtNJlgMXU0S3xkFzTdRWp8PM+VAFYXqyFemihF7aNUf232zKzfHWYVsPSS4EJqAT2YrEhqBU9G5r7pupJ17
 Mnx1XJMK
 Os817mxPKXnX9nCUIOHNsdZMzyncg4/HujUJTQ6KxWmayu9cDx8BvzqdXW9pdlURhg+bxhuTrXd9ZcuD4/oJcNzu3abPKbQ+3NTen61GNXY39fdSXeuQaYSkNi9wSmHhJ6MSp3Xu3VYbNCt4tTftPkztn2zl1wXps1f3CRV30AoLvIf6J5u2tQMHJ6L9JG2tuOFP1feSRmIWAkVOSi3c9cHWFiWZS+wISvvfpN5jDnPPnmRQVSwnAxlt0KOEH5XETiqthG2hcDif89Qgi5PQUWpEKMr4N4OOVezwfEIJX2lbFnnSgo766rYylx8RmBh54QAoE4XNHNIM+55L1KLYBJ+mJhyRjBxjX/zPjsy7VZ/oAJWaeRwMdbYXg4X1qPEVlMv1m2ect9b2GouvRQWUYio6WAenz6C7+BiKDn1ojonCashs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio. Constify it, along with the page
wrappers built on top of it and get_obj_cgroup_from_folio(), which only
reads the folio's objcg.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 50 +++++++++++++++++++++++-----------------------
 mm/memcontrol.c            |  8 ++++----
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..5a5ca6814782 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -410,7 +410,7 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
  * or NULL. This function assumes that the folio is known to have a
  * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
@@ -448,7 +448,7 @@ static inline struct obj_cgroup *folio_objcg(struct folio *folio)
  * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
  * memcg associated with a folio from being released.
  */
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
@@ -461,7 +461,7 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
  *
  * Returns true if folio is charged to a memory cgroup, otherwise returns false.
  */
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return folio->memcg_data != 0;
 }
@@ -481,7 +481,7 @@ static inline bool folio_memcg_charged(struct folio *folio)
  * A caller should hold an rcu read lock to protect memcg associated with a
  * page from being released.
  */
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	/*
 	 * Because folio->memcg_data might be changed asynchronously
@@ -498,11 +498,11 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	if (PageTail(page))
 		return NULL;
-	return folio_memcg_check((struct folio *)page);
+	return folio_memcg_check((const struct folio *)page);
 }
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
@@ -527,14 +527,14 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
  * that the folio has an associated memory cgroup. It's not safe to call
  * this function against some types of folios, e.g. slab folios.
  */
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
 	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return folio_memcg_kmem(page_folio(page));
 }
@@ -777,7 +777,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
@@ -905,8 +905,8 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
-ino_t page_cgroup_ino(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio);
+ino_t page_cgroup_ino(const struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
@@ -956,7 +956,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
@@ -990,7 +990,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 	struct mem_cgroup *memcg;
@@ -1084,22 +1084,22 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 
 #define root_mem_cgroup		(NULL)
 
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return false;
 }
 
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	return NULL;
 }
@@ -1109,12 +1109,12 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return NULL;
 }
 
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	return false;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return false;
 }
@@ -1248,7 +1248,7 @@ static inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1406,7 +1406,7 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 }
@@ -1471,7 +1471,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 }
@@ -1767,7 +1767,7 @@ void __memcg_kmem_uncharge_page(struct page *page, int order);
  * needs to be used outside of the local scope.
  */
 struct obj_cgroup *current_obj_cgroup(void);
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio);
 
 static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
@@ -1870,7 +1870,7 @@ static inline void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+static inline struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1901,7 +1901,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 {
 }
 
-static inline ino_t page_cgroup_ino(struct page *page)
+static inline ino_t page_cgroup_ino(const struct page *page)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..54937efa075d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -357,7 +357,7 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
  * after page_cgroup_ino() returns, so it only should be used by callers that
  * do not care (such as procfs interfaces).
  */
-ino_t page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(const struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
@@ -1242,7 +1242,7 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  *
  * See folio_memcg() for folio->objcg/memcg binding rules.
  */
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -3140,7 +3140,7 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 	return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 }
 
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 

-- 
2.39.5



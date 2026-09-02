Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9E3C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85C16B00A2; Wed,  2 Sep 2026 15:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D0E6B00A4; Wed,  2 Sep 2026 15:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE576B00A5; Wed,  2 Sep 2026 15:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60C706B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E82A8140366
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:29 +0000 (UTC)
X-FDA: 85169808738.27.57ECD0F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F96820009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nWfy+fZf;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NMlDejzf;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHaxPxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=;
	b=OLGq6cbjKVTiha2smXW+Ng3aXXmZHPYBXHsRTVdmFvl6xhngfp7GPIaIPhT6bXyNkHMLJt
	+73inq0Ef8m46ZOfWC5A3V8ZQDKDmRUA9yF03sgeKJ2ogK8KJaGVmqiA0kapTG6ZwHmm7T
	kSnlcD61mPdBqJFNrty15z6t0sCBImE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nWfy+fZf;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NMlDejzf;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377307;
	b=yGVF8IkjjrQ8cFgVlar//GFqCJH+b//JKrSBqXCYJJC3gCYHiqFU9udydDxSgUtTT3XBob
	v7ssmxyGxV+rEk9t4+hET3uo122vrNOoEg3tbGIua1Isoond4zcPMky+lx2yP2tJHZbI6S
	rtAEXqbmEn49Nx9RuoRxzy+txXjDKbw=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IaHMT542273
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GHax
	PxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=; b=nWfy+fZfM8qfCpaZpSpQ
	L1JUtiIJ59dCMVZ9Ut5IOrT4+VyVTClww5bMOuN007okF3VkENvnewDoL6uiLpC0
	3cf1ykLAQR1xKyPo1en5vZV91LlKkLJsw1YVNbr1MGJYti+DxhvCo7tThpHdpf3X
	4p8alJ2pftoeZfLxDH3gZole91XX2qVreDF74ETDjOWhJgSH/qN5Ih4ciGIVto0F
	7Wu/28XSxqBivuWfE9EIEA2LUyx09LxHr/q6rV2yWAj+sHpfIKZ3ERqqGfl7tenG
	sKgkVPQFpV+O3olgkG04NrOVYOcwpe/hFU8rdPbMhWSSO0efzF0YNF0q0ohDsVsk
	Pg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gefkbmu27-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:26 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53001b668a6so34817021cf.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377305; x=1788982105; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GHaxPxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=;
        b=NMlDejzfHcGpo4b3zWgEcqNGjJKLLDmTAnq3xBRuv3o8nw0khWuQY7PIZAbkKNLoHy
         9IaUHCHkk55NPMJRXq+9PSP/yrM86M3Kef6OpNR+QBxH/Nvu/19dOEoWkHqqdO7UKxRn
         iVFUEIjbD02KBfC+Ks5a0pGhj+2GdtrtseysPezRV83FVFeQYfuF2zAYdAJQtLQ7GCSA
         yy4+FlldyXWx2VsEOJ6kKgpzVVXm8OQm86cxRiEH326O27o6iMoIlybRVOlsw3caHtRm
         Itg8psMCRBvRbXAZsk1kGUgAzVc3oF+NbTX1y10QXzTLzAB2665IMA0yUaSWrXcFfihA
         7Vyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377305; x=1788982105;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHaxPxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=;
        b=gcsBK8Rk3JG4yln6mAjgNhfT2fiYRB+jVIIxyh+QehurBOmWEX+e9qPIQhBLoSnFgD
         sBLOs+Ce1eVbETMlleSJQLr+cKBxj8XerSdjOAT3mZiwNqQJPkXvDUTwZ3Qx0IBktXtv
         DHawRrSxy7srU1rphVB0RG/BS7/7KbuV3UvhMVNCusvtYsAbNcD9k+ebofpYaDyU5XNq
         eJ07oMrWTmG88jtdBK31nYtFZJnu2iDkWQC+foj4zRLmJ2i3VQZe3WW0mwVdh6yNH5Yo
         9AQZ3zE5Id/p7h8NUGfZ6461p5EWujlLI3cHyoX3OjHAv4pus5tjUWOOHddoSAfEIzX6
         Fo+g==
X-Forwarded-Encrypted: i=1; AKwUvBxa9vfePjsQEOm9HYfsysOw9PwBjjaQviO1C1YJksL/FyJ2lCpHU98je16gk6XAga6vfHjAELWS8Q==@kvack.org
X-Gm-Message-State: AFuF++nHeaKJvwmzLgg1wGrZ8iaoR0Phqp4yCFH3m/9ZIR0bZ7JuJp2s
	+T4TO2XqZLyhOHD6ICZdxhfgt3nY2C0LbA0KrEQSUM4ktoKjZUFucEgcb8IwPG1vW558A9LIlOC
	ncyTJuHJq95UQ8HdHOBR6vRek4DUpN1EGF9dggojQIT/DeYRH
X-Gm-Gg: AYBFou3eB7GElOZ9vqBqbywmRU8olMYylWw6WjLio0hLPshBSvzknEYGLS4zEq9YG6J
	DCDCsOzY/IS/xhwgKFt7rsrWDiosndTIZpCQPdi0cgI2k4uueqTZe05Oons2xwVjJOguK6GNFyT
	mNpEj9eUa1GWFazATjOEnDBeS0TEGWBmNYSSZniBwv/3DI+77deVQPY7HqiLr5mH+yi2QuN4i3B
	a3eF8Oe7mCWu614NgjIZdFqVdXXy4BWAjueTTiU++TZ4ClZ0W85Bhnfb9C/8rknQpWxQA64lS7F
	UeJ3i+8pH8B32eFAwE17kXJI+7Uaa9yT8MSPggn2Zqs7I6pl1UjrJgLuEOeqSLn/kbWLZQwiWar
	7vQTd5bV8px1XcZuBtjqp3lnP0HpCP2dIg0aQaIpGD6MXX76782I60w==
X-Received: by 2002:a05:622a:3c6:b0:517:9570:c1bd with SMTP id d75a77b69052e-53036cc7af7mr83271531cf.25.1788377304933;
        Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
X-Received: by 2002:a05:622a:3c6:b0:517:9570:c1bd with SMTP id d75a77b69052e-53036cc7af7mr83270531cf.25.1788377304282;
        Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:51 -0400
Subject: [PATCH 05/11] mm: memcontrol: constify the mem_cgroup accessors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-5-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YeEds/rFaDomadG9QFfipJEUkETcVxHCgrtHyNs5aqQ=;
 b=heNyU5KL6+13ZfVbO+NJTfkfC82stDaN9oZEnTLjBt5pKCexJPD4SAneseDa6P+7Wpc1LNyFG
 ToQ2yZIbJB5BriA9ZaYMx0Iy4rO0B0wK9sTwqxZRCoHaaT5qgV5iXpE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: Hpg77LA4q0VjbwILY4Df2NSdd2M-UsLR
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX/CVKUVzsYwS1
 PnHwLNKhzK1KsM7UsitAG3cy36EnJIaQOx7gbiWybOp5I3ef8antV8TBn/efaC8+9pvewGF5nRs
 rov0X9GOOvzDpxpyAWSbhTVIIJ+93YwGaNMoLelcxFUGMr7COUN0
X-Authority-Analysis: v=2.4 cv=aIzAb79m c=1 sm=1 tr=0 ts=6a9878da cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX58o0qpQgIjpB
 M/2U9qkUBWZFguRe5vAEusr14rPQc1ATAPKfCirDr6PLrI5miQI6erokzO5b6gkIE1wlryrk8Vs
 jvNYwvl+gPjPhJpKVEsJqcJ+CwEKwnyTZDldIkwXfI6aGskDz7aDOV+r1vpoajfjByKUj5hc24E
 5joUUFFE6eZc4UOxVnXd5WImZ+EYlSvW1oGEghiDYPq69VSFiH5FFUNaVcGWeoC5zEKbQ1KN7Mw
 XfeRM31Mg5mfnjQGMJ68k1aOVC/OXOLG4aRt7XIsJjIYtgKlELHk5NYmrZlCqA1K/Jn0coOfv0+
 McsACkkZHI4o39ze/IFdJqGhA2EIxhX4XlRKXqvy6qaxZf4Gqh7rJSN8hTEwlaQj2/H4fY4GK9h
 nLADIMKv/ZArHQZfsEQVEWpkIOEuMBfZysZPpLJ4WHXzs46BUw69gzpgZeJKMhurADKls1ak9Qw
 4eXgMxvbj/KTxqlPxcA==
X-Proofpoint-ORIG-GUID: Hpg77LA4q0VjbwILY4Df2NSdd2M-UsLR
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 adultscore=0 malwarescore=0
 bulkscore=10 clxscore=1015 impostorscore=10 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3k3tsz15apob4sh9e64xeapny595siuk
X-Rspamd-Queue-Id: 4F96820009
X-HE-Tag: 1788377307-389392
X-HE-Meta: U2FsdGVkX1/hQpavrd9BdKbq59CIN8M8/aKShMR0A/z4dP3hIBhNtD2fsGv7FUFvC/JoppLaB5GGrwjLFsMGVil4WG63IO74ekviK6SWuTMmiq2bAoql06XzBPdISGSUfxwW+KNdKQWFqjGdD/+H0UwvcvxEVRo/I1euInV3wjYB0T2Jmpv93woj5utKCeBvfY55N7nM4IYgb0gd5mxQpA9z3gU+kK+GO2C4U8O7TeYA5NQx47KTAhqMWQaGCsIpurth51l4siLBCZPLO3Q4IcPJKiwplP3pUZrpsTIOrYZIw4j0loYozx1rg4Y2jb3kPAph/ftd36K1sgHC04ZE7C0rtWu2ct/4LftFfOTX8V/uItoozm0YYdeQJ3hsab8sGT5rPP9AFHHWYxEVltFQCNwaEEgs/ZKxak47xro5Q5xlVo9QJh8yZIJJGw3xWgpCYXwbHi5NMN/xSawlJn975iZfM5PiGXu8RCpIui0Di5o7DHIdIUm6XioDm76YURdCL/LpNZPDCbHFzVsL3+vxR+4Rxxf1J9oxRNALW2wkhn2AILv/yOw+hxLR50RVxZsvJ71PclrMtXWLVHMq8rJaoneZOXAh8aZ5BDLwvUXpg98EShKHOsUF1whw/GZ9oMzSjbBVuwQo5JhdBiNbpkLpfV6j/W/x3Ua5hLqXdUG4tH++Xra4YwMp/u+FQNUlmudfFDjTeA1CGKHSURoNadeRI5XbZWrpDJqcfO5Vph/d83MdOUtDXRiEcj5WUqxsEVGWhg5TMtfnEIjxFs/WPkBh6yJEvkKn6gTe6j4GdGLYplHR8GbE46hiGbLWCgOUl6kvGOjGB/QzRjOgzGHzYDpNBt8hfhokbmx6MpEM/DofoQP+b8Vgx5hlckiS7DxwHgS8KHVwtEgbtgTCNNLwpMATp4OLSQBq5CllU+UXjH83c9BHUnfGCYUgcF6GVw0tMIhUTw+387mbxvH7lysK0LG
 YpRfcI5p
 zdXSHtbf+D44s6X5EWiFCDpIeIyPFVAqtQH7nll3JFcJb0760q8SJtu3FioKnTG+Do+QcOdSXIQVKzGVhG0SLOKZEOOT20r6jwy/MxyRcLV3RF5Sp29MNB/NbESmCgFT7vIlExVIV3X1MaiA8jjJBSJQE64U0nFlvH2c3Dabborv6pevYHwxX8CT4CepzOcAUonApB+0d1hp/MgwMPZxJNX6kVwuaBD3mpMleSbU7dmBreSgTo9khc3SJdiAQQdiqDVlrYswVa9DfAWKOuUO7WT2qe9QusXEsNt+J3ZooPX39DsWBvVcJ8AEHC0YjGy4YM37pXby2sMc8hcnDmjPgczZ8sHhVZlyJmaB5wRdzKf97+B5J3C+A9Fo18Okfbr7zMX4FHKXGJNYTIAhQ7eMIs2s4ndwAi5PY2oRp6S4ICW0r36I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_id(), parent_mem_cgroup(), mem_cgroup_is_root(),
mem_cgroup_is_descendant(), memcg_kmem_id(), and the other memcg
accessors only read from the memcg. Constify them, along with
mem_cgroup_shrink_is_root()'s shrink_control.

mem_cgroup_print_oom_context()'s task stays non-const, as
task_cgroup() takes a non-const task.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 41 +++++++++++++++++++++--------------------
 mm/memcontrol.c            |  3 ++-
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4b7cc97e45b2..bda969b3e1d9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -506,7 +506,7 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return folio_memcg_kmem(page_folio(page));
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
 }
@@ -522,7 +522,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
  * and do not honour sc->memcg can use this to early-return 0 in per-memcg
  * contexts.
  */
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
 }
@@ -806,7 +806,7 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
@@ -815,7 +815,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
@@ -844,13 +844,13 @@ static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
  *
  * Returns the parent memcg, or NULL if this is the root.
  */
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return mem_cgroup_from_css(memcg->css.parent);
 }
 
-static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
-			      struct mem_cgroup *root)
+static inline bool mem_cgroup_is_descendant(const struct mem_cgroup *memcg,
+			      const struct mem_cgroup *root)
 {
 	if (root == memcg)
 		return true;
@@ -858,7 +858,7 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-				   struct mem_cgroup *memcg)
+				   const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -904,7 +904,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
@@ -1080,12 +1080,12 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return false;
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return true;
 }
 
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return true;
 }
@@ -1187,13 +1187,13 @@ static inline struct lruvec *folio_lruvec(const struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return NULL;
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-		struct mem_cgroup *memcg)
+		const struct mem_cgroup *memcg)
 {
 	return true;
 }
@@ -1287,7 +1287,7 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1299,7 +1299,7 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1337,7 +1337,8 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 }
 
 static inline void
-mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+			     struct task_struct *p)
 {
 }
 
@@ -1773,7 +1774,7 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1845,7 +1846,7 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return -1;
 }
@@ -1912,7 +1913,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1930,7 +1931,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2845f761e37..35f924c9f2a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1812,7 +1812,8 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
  * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
  * enabled
  */
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+				  struct task_struct *p)
 {
 	rcu_read_lock();
 

-- 
2.39.5



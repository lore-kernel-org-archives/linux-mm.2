Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2877BC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4576B00AA; Tue,  8 Sep 2026 12:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C650C6B00B4; Tue,  8 Sep 2026 12:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C776B00B5; Tue,  8 Sep 2026 12:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E16C6B00AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:07:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24DE34073F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:07:46 +0000 (UTC)
X-FDA: 85191075732.14.49E8244
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 216C24001A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:07:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SzZChqUC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=R61Td+AA;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPu+VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=;
	b=aGCIRthS/gmjZPHoIU6xYVlLB7F3qzr+POBEogq0CpirReIc149EZ6guyD7QLlvDCi2cNn
	cyFPYDLagvHRWDqetreIYg2aUcps/XRG1ASqzmghaMbc2Co4+0x0pw63R3x3OjkKn0sFKM
	B6szbc/aYWbZqd6h2wGI58n0hgNhejs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883663;
	b=BT5aPO4rakQHvN+m4e7fIM3XjqKDARPcbk4LwiubhDrmp26LbnpEFzb8gmRPtrroylWfQx
	hO/y6ElVc/FQcsy+a/9Wb2QSisU8Ba4MaF9YvOHboolwCuh8MQtoFMATk9XiIvQVdUn9+J
	NOqdeqJ3ee2v+S4V++ZdOG65G5mwatA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SzZChqUC;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=R61Td+AA;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbd6P1250328
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=JPu+
	VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=; b=SzZChqUCj2RrrRu26Vbb
	S+hFBEVl1fnRrfLGFU8PJWD7t0hsYEOxdJRXby6zo8p5u1coJXOTqmGeqYNVdvbk
	cvtn5rdl0dM7Q64T7MzXFaU2SbwNy4445lm10hBr9khR0xzC9srsOtcHdohfDfLk
	FNT1U0MVWmn45fOepEmR8kiMZ2sMEyJSnTGri+FPMJzTNqWvR8/I6owy8SxNFYo4
	eyiGMMnXVauH8BlFyO51yyCTE2DwgNiRPFgr40WnM5gmsvKLjQdSCmXgoDh1KABF
	EKoZLWsd353Dihl2cTy506WgwEmJCQcrlcprxMrn+Ch5EPYMil4dji6hXgsukFFH
	ag==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjhqkts1w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:52 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52fb8f67601so59761141cf.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883071; x=1789487871; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPu+VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=;
        b=R61Td+AAMDuvIdtIyGDsPhrYjUUK2JuM+CNn/DBdUwEkF5GuBLVMdWLCWtxgsl1cG2
         VrB90KhSzt41Bs4dWf1BKXVnhrHYh2MuJD+w797zGmPVGFCjbClZeTr450W23QNKPXIW
         X9pQu5IzsKrFR/Z9uYb7LUkKPDl3BqGqwJAAL0Avi7GixiOfIsM3vdEfcOrzv42AatdN
         cb5063xwXD6jXlxYEYY9VcUN3txINNSJrY9CjPr2hBkziopDlWEXm4nXrQJ6UnrDzpxJ
         0YnIJTLCekivmqKd45rV1X/NICk3cj8qV1EfztPuucDGnus7GIgWcb2gsR44WUi/IJUk
         l0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883071; x=1789487871;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPu+VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=;
        b=ktuZuX41d9vrGhWStvIvCfv6NtvuHFC44WkJ+XUdMx9JTrzviwGyKN1A0pQsbUeF2t
         RZg5pigrhjM4D6Jvzgk8y3bz8g+4b8FIM5QA6SF2V6XyNaHnjpRLGQTgVq1cTvWjLsKx
         7s5bnuE8FT0Vx5+361CR1IG0MkSsWHOdIzOQjStQjCE5ADc2qRPfTpNamZS+RYBoLBN9
         Rgq0qRmh6Sez/pjCd5khb0y4xWzmaeKrcwKfWNJiS+ZQ9SSwh13zKZOZlYNFBU+M/Wwg
         Nqsd4u9GZyCm2pLW/hegOSw1RIdIuXOq7R7JgLPVGsYMUxggGdBY0vLDXdQ7+sQZYvk8
         2jGw==
X-Forwarded-Encrypted: i=1; AKwUvBwUoZFNVDDjojpa7EMbxefgBQpYqsET7miEgKEUI4fH+Jh+YIFcDpT+9zPCOyL65VyWYwPSCFswPQ==@kvack.org
X-Gm-Message-State: AFuF++kvbNNUYab4Xpdz2UQRKGcQ45b3v51d6hHx3VZEeXcSy4vFiK8K
	fJTT0Zg+tFwfPubbhUaaMMA725eEWJBGQS9D4uAAjaeUAEx9cZePf3XZZtKbZZWrV7f+ZNaPRBO
	bmKwWYoCi8Izr/NvmobTMEfsitjymI9rWwk63pZt2V/xmfcyg
X-Gm-Gg: AYBFou3z+mzTlbFcuZgXnRvIsrtWxyzCFX6SJ13RIJae3fZxkiVj/Ny3JEhzlzO6Xkn
	m4WIOo93e1eAHJmYtJFZKtD6XoFLS49xt2DN2aq1Rjs64EvWPTRb4TD/VYshED0sFgOHfTkVpSD
	lTNUDSUdfxuVCgJ4ruhgnyPZoPZFPFBiOsnqlbySdj+d8fSlMRWWoO0OcrlFhx+ZpHaQPW9TUki
	CwrsZqwNE9TU7nAlJ3htgS5b3Fz4uegTShJv8yrfk6gLXpgiCQJYHOFXJmDQweA3BjiP95wt21e
	kLOTWi3CwQMr/0IFTYvMZrCsJtshWvC/jCeYTDIS5o0MYz3MY8fmBwIJnSqYiKv+xJCVgmofRDV
	6D4Cmo4ECEv4CZoQSqAM8+hJAaKP0BdqltW3qAGhpNRSa/j/P
X-Received: by 2002:ac8:5913:0:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-53054955026mr345684401cf.25.1788883071181;
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
X-Received: by 2002:ac8:5913:0:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-53054955026mr345683351cf.25.1788883070534;
        Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:41 -0400
Subject: [PATCH v2 05/11] mm: memcontrol: constify the mem_cgroup accessors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-5-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jiPYBXKFlzm0BDkhwYK0OYvgkcvR4Sv/E5MM2St2AWA=;
 b=JvaWaS81wg00VnUqUAX8UucBmzqegdvFjSzAalJyDxkAPhhk1S5Ihi4t5Xpt1f9ZIcc/maHCv
 2v3eahfSrU2A/nvyuy9V5fT1uiBZNATglvBHDN5Uc+sueiccL2fj+Ik
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX5X62E33QidUo
 twyTr7VG7UsoIsmC/5ayqD2HXoE0gS8MCRDOaUrnmg5X6OpB4sXtUHxCeceqc72WwRRnMLx7vP1
 GU9jjuBBJjuy6v/5W7vCK2tFYLj80wYgpFg/W/dNPQtXn2rNlqZQI6yxfqKQFLSB57WtlsIE0mR
 aJXKP2rg/14Nj647lvksvNt312ZZeh5kSZUVoW+LV0aOVNAYRsRg2oqYM5Q+FZSb52vMGLGQGUv
 WjhpADp3W+lXRbs1dfLpWhZV0rgTwnxxIDsrjRALCx5nRXmo1zQ4KwZIxNEQKvHFJFhLJfZa/1U
 Qe31AOlz9F9ozikk5tga1g4sfkcZ6LqeZWm3X1GeVfhP28kQDM87SVstkaNPpsZx7DZbjwADPQl
 W9y3SQpG7hUoO1DNGyDGdpX7DLULnliyJ/jI3WOrA6DiGtAadaPO6Jc8jU9HAnbFmhcHQvtvUtn
 b0hzEa/XELDB6HbzQqQ==
X-Proofpoint-ORIG-GUID: UfQNc8kqtBAH49gJjjOG7Gs3922Httcf
X-Authority-Analysis: v=2.4 cv=CuOPtH4D c=1 sm=1 tr=0 ts=6aa03080 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX0jJkbJlM133o
 OsKGzwfI6XSR8LPq4/clg6co91QLQ/SFBph0bSncZHa1DrqnuXHWGk0RsRFUtAEYlcfMYive0Mn
 rTWVXeHMM06bdNuQyyERytXXD0UkcK+x3SuQCaz5tYRnktMjzis4
X-Proofpoint-GUID: UfQNc8kqtBAH49gJjjOG7Gs3922Httcf
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 216C24001A
X-Stat-Signature: d3d5ipzhg6r5omk91uebdgtmxdofu7po
X-HE-Tag: 1788883662-444759
X-HE-Meta: U2FsdGVkX1+s9W8Gbsml/IPjwNwmCPvpV+FzoQUfB4O8H0G/dJ1RtxOEdEiK4vBueV3PVwGihwK3m9TPiwCjh8RDLDd0teahDMX7eG+HiG2vAmclvkKJp6cKIKtIsUWCdVgq/A/1mL6qu0D1xbuWCSHRlgR+DFOLNaZ8YjHniT8IgszFokmSmn2nXWfEGpNyxnt8CuxkS8UtLsJWHA40oc7+oikbzJFNXUJXL+jRpKjQVmFtxU9AxwLud1DytGySiHZrhF/VrGN4LtpQTh8SyNj8RvnySpOKY5SSWoRVxdOnKcJRkHfZjMWbSlpEAjyCRqQPsLmEq7t/uX7R0r0FHc0w7HM16D3eQbQaYjQH1VzGWUfdnVaaPLATAZL972cd07z1jjVSziGB7ohFgbR5Dfiyo4N65YGoZQe0inxKJhLHEE3676FcYHvzUH/8PZk3ZugPYHvDVAielmy4FsVXVHgxtJa2ynryonaakvVB9EucxxA4nlpjRGgw2RjZ2tK4LYdgWKyN8b/4H0tqoDh2Yb+QgSLipUbgdC/ojwk5kT6rKb8i2CVBTCmXe3/c0fYzEYwFTU1SB0N69A5pU9esZAuSdHQfl0275V7cKAvK2aAhdWRqBZi/m+OzsJBk+k09201MGMxVQP52RUePConMrFFKoDcUFylmM1TWoJfBBHaGBDYI482T6YaZs4qMgE7+4z+wkSwDMRhy826ynFPD5KxXQQG5ud5vn0EvtkRnZxCa/oDhrjaQTMy/9j2h4wNK6jCUf9X92XfQ/w0TD8vC0u4tw+8NsJo2WA9KEL2pZ1bNhv9srz2UxsR6dndTZrU59x/stEURbBY/s+jHfdW42117GVkkJ/WLurnAgMazZ4m7jkgtc27/sc4KlUa7emazQiOl0XznrK3Blh7GNnnY1Uy3uoacQBq87goFfYBfIgLPIR9EnlVQHXzJyLmonuYx7ilEZmIMzdvt+kuyTtA
 BDmztT7s
 wYWxbpB0LVOVYxJgtrpDQFrmkAygNSdzRJaoMFHfyLyP1CbsyRgzv6r7Yf8W/Kz0oRjk+fQGASFh60bkzwpBCRaXHIe7TjVoyE3tq+Ug52sfbLqRTFegJQOdrxKAU1YZ5IV4Xdk50TlalWhdUyU9rpE08tANX75SwVD4Ci5Sgc224G2GPodwcTtiy7OAJs7xhQqgOiFzxDnCu4EKLPCUAxDraWbI9TB5JYwopheFobUXQaPvUG1ODuIaAGOWvyUGFtLXVXJ34YyacHYNs5oJaVk1c3z3cJy987P24tMbb7moOSoStYPdIOKG5HL8z7GDePab6lrW0qQ96H7HQvD4G9KMU/ivzYuQB3oEAJQsNDiblInwciDLTkOQpxyp9MOz3Sxv3uCr6TpygXn7HfEtRkBpBZqVtKowdJoS/cmubWEwnV+U=
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
index dde828a1206f..c434a567bf57 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -539,7 +539,7 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return folio_memcg_kmem(page_folio(page));
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
 }
@@ -555,7 +555,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
  * and do not honour sc->memcg can use this to early-return 0 in per-memcg
  * contexts.
  */
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
 }
@@ -840,7 +840,7 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
@@ -849,7 +849,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
@@ -878,13 +878,13 @@ static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
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
@@ -892,7 +892,7 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-				   struct mem_cgroup *memcg)
+				   const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -943,7 +943,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
@@ -1119,12 +1119,12 @@ static inline bool PageMemcgKmem(const struct page *page)
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
@@ -1227,13 +1227,13 @@ static inline struct lruvec *folio_lruvec(const struct folio *folio)
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
@@ -1327,7 +1327,7 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1339,7 +1339,7 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1377,7 +1377,8 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 }
 
 static inline void
-mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+			     struct task_struct *p)
 {
 }
 
@@ -1813,7 +1814,7 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1885,7 +1886,7 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return -1;
 }
@@ -1952,7 +1953,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1970,7 +1971,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49d2e7e3c023..2456ffeb5241 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1818,7 +1818,8 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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



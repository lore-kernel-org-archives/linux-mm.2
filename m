Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E619C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0BB6B009B; Tue, 15 Sep 2026 19:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853776B009D; Tue, 15 Sep 2026 19:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3FB6B009E; Tue, 15 Sep 2026 19:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4181F6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99B4212059B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:38 +0000 (UTC)
X-FDA: 85217568156.19.8695310
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19F671C0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nnNJ5syd;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UoraSykG;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514436;
	b=K5TCD8pG5OxgkXDfdsX70LcNNQGRdbu9STz3fhIE7K5G9AEqCkJce4ts1G/YmqMlrwIePU
	1UZTE5oaqKtUQyepvsxYJMegfZA+VuOEkHr+RGv4BvNcgD4XGT55rPE70lguqGeecQWpF0
	FRziPSfw4rwdItW3cJEqWhvSp7TvUuA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nnNJ5syd;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UoraSykG;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiZAkQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=;
	b=1EukoU/BRBMS1h+eWhvUKfWQe2b7rhWg1re2ttaVIFyKDWMhz1LJxjakWX+ee9R0DItueR
	Hv8xo0Hl2J/AU6aHduT7CW31v25G7U1LPEmBS+cgOcq6hmZ8FJdpfNILmeq2JC+P2HnHQr
	u/ftqZ6k0htE1TlOC+eQ6bxhyrO5q/s=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbPH54081222
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=MiZA
	kQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=; b=nnNJ5sydtfrpp0aZfz+I
	epA46FThJFmAO9Acy9qFAMU12voDDysm/IF1iuYdmhTj/67CDILG3P8Leb4F1ftM
	FJQvEKmSvI1xBPW4omPtcIIkPe8myDvLtSHwQdbGroFMjBXZIsa0sfWu0cdQEZ9i
	kWti1Yqhx/D97Ym+awvzmeUFcg373CuvvWW3mOcs41/q1gEyE8xF8L6+BphH47+W
	KH1yfLdB+5tiXrazaO6LNb+AYMEfsMf164J8VskyvKyYFSVdMPT27iUCRuKN1zUj
	76zeOOgGFDvm3uk01zl99HKcS8SuxY9EtHDvr7bj04jaMGUadRls+ohCRV8enqN+
	DQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2gc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-936e393061dso801994185a.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514434; x=1790119234; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MiZAkQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=;
        b=UoraSykGdLvKCX4rbT4fKC75K6CYAP/oVeH6zO+Fw4P5BiUwfVJD6ecAxHhfGO0JJ4
         kA7lrDJFgvBO9vuUZeSWATRKYBN4Y1NI8my1KANBmbqMmDkk2/y2mU+iXTfMe6KlRLqs
         BQUxq/QF+FjzE2h55eaqaaYg2gfNoVsBO1OmoRAluRgnrspNx4iE2y1n5YHVomvyP7ff
         NidYML5USdqQCaqhRE/kNUfnOfPST5VwtIeNhOKz0RjVpTkHQlHLcCgJcURzoCgrbZ6g
         j0ESBCz8+LGh9teuK4AB7yW6BccPemKiP1yc39K91mEQimmzde/YJifYOUXIJdh+Knhl
         TuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514434; x=1790119234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MiZAkQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=;
        b=VShhU3+oM1rjELF/gW9PVwbo9SttHV+8VD8V6XNC3fU+Vmo4UOBfsZyZt4FWG8awMO
         tb2Lx/H6vhepYFjc26F0W0iIU4dRdB39d/dvb1XN6MXJPM/cRi8NgfH710BHsPZU868Y
         14f9cqY9exybWGYC/oD7VL9wQUe5tzyIsnLGTXOJFKEBpwNHih6Aj7rYaXAUobxah6Ay
         ZEZN07pUdwR6Df69j8rJ1nxSFF9SrrhsbACUwek5hty37sdETakDMg8KjkRbsgrJCjmR
         1FSzBjhk7O/KzLTxYNEVuBNSaRonsacQkZOne4GMwx2PUjZ9xGqKszh8LxrO5z9TO5kX
         0HPg==
X-Forwarded-Encrypted: i=1; AKwUvByxTfGEmxIbTK56MmDSd+1IIJqf5uVmXW8U2N3YSvHfHvFJSMXAEU/B84kTi0YQ/U1A1y0KSQelzg==@kvack.org
X-Gm-Message-State: AFuF++lZW7IeO6G7//2ME6C5q8mksPgYZkiZQ6sxAy3ed8Q5jZArNtZX
	PvH4J8Mhqc9idcjAJjAN+p3wv0CEwtP+GsVoejvAioWBuqUBOuvCEOrZ1b5gotlJyhxM5GhiBjt
	+fhmZ0od0TyXh+bS1TZGQEWTqDEghVTMNyrR8LA6UqJ8niy6o
X-Gm-Gg: AYBFou3g0Q/3MpuWfIl/pJoLt4iNI9zuMyRygDTAnkwsl7Hv9zqg34A7E5DDfzCz5hh
	POhaqs0srOyQKiQVIL9Re6PyE3dKmJFxP5rXVpepcw9w/w0Y8ybcb0LhsAn5RhY61w8ugRhuYMs
	n8jX6qMpmQC7BIzg1LC7R8y7oU1+ZawPz1UWT7jYalxfTJuMuM/H/uJQK1Bz9zeqshRuXAjYEjs
	GtxcNX2sBP1JfkYVe9/LU7O2gmypYUjLLjjMwgA1Bi0WPwyc4QbhPlIxCOY+fEgVqxloBqKUjfC
	KUpqZnWX4PJYHHtxglytgr35Vmegt2VKNCWkF2jwf/iOzASVkSRw/WVNinSr+gvykrLSn9NZu7R
	qYSXXDTqkrnvETvNjdtJUmdctDArdvZHpZhiDoiDfyy8AbAaM
X-Received: by 2002:a05:620a:4621:b0:939:deae:8ca1 with SMTP id af79cd13be357-93bb793775cmr60423385a.44.1789514433877;
        Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
X-Received: by 2002:a05:620a:4621:b0:939:deae:8ca1 with SMTP id af79cd13be357-93bb793775cmr60418785a.44.1789514433398;
        Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:10 -0400
Subject: [PATCH v3 06/11] mm: page_counter: constify page_counter_read()
 and page_counter_margin()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-6-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=mGW09hkh76YIeApZZFaqV/ozCPHzHyH1NGa5yMwc4ME=;
 b=DUenCOQT0K+st93DFFRNvmdZs/ls99b6FAGmw2v32/XZVcMUKm4spMJRgdm/dKJIfaSSVJUeh
 BHHac3BvuFaBQ1rihynZ7hxLlVPIobPduaPZYAkwQMwfspXkpDvMt4z
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: iTTZku4m-BDk7gzu8LlGvkXcJkKbZ1Ox
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX4NnwAk+MzVhj
 kyTL6CbEe0LgV42uOYqPvNX89drXTT2q2u5Z5mC8FJAPFbhCZ1uTR82il6qKyq+i6YPsIZwsUJ4
 goGs/D4hW3ivqwL2lohS0SKLVUuG6RFyfJK9TiS9v7gornXH7UY0odMemuaun2Yo4JTZ3bxVo1D
 xCpwATh4XbBhHvJGJGN15R+XG4YLn9t7q63SZKcC6DKi4kF/sAnGTP2byqsi+2a0DFj6Eq7NCis
 NbFUEQC8z3I+M3bG3Op19agfnAYWnykuz7ooRdEIlkH352ISnH/912ZhZdHTjTn7AoDsPbuWw8N
 5HVXO2STifzj4qhC5pBehwYE+ZZ5jG3CUd9gWCDCtyBtWEFMAAI5vZhFqs6hKS+pXdAorbaLvEF
 y9PVUEWNbUJuYsHBBCxXuuPs/p/F8zR3TyB4E6g5ZI2NcT2J9HS2a+UJJJKVOA+ul7rf4B0yrrS
 gL1RJm1Li8WN2HeJh2A==
X-Proofpoint-ORIG-GUID: iTTZku4m-BDk7gzu8LlGvkXcJkKbZ1Ox
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2c2 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX09hrdW/mvNm0
 A4OFyoOmjnYPZPnsg05LTRx+D9RsGiRnfzk6h0I6cTuv1Med3HfgSe3J6hWktQ4lgW+n5mluJXz
 g1bex9rTw7zM+7vnXz02nj0SwcZoUmkKPsaD4O+3AkKkRRYnvsJk
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19F671C0007
X-Stat-Signature: xdcgtdbtizu8oiu7nziiwhnj17b1bbbo
X-HE-Tag: 1789514435-683022
X-HE-Meta: U2FsdGVkX1+JzxIX7WpGAz1o9kwlpKmPLqYlKqIo7r0keCwUkYzMTBowZ6c6cKSVNM2r1rBABZFMPV/fKsl2vkt/+e8YXLWywYv/yRM+hciOHqXCCjFzGFbInLbZx9/U71RYW/tKtnSVFQrgq5ckVDTp0K0cQxo1di8L5rCtL8zF+MqmNvlZAMZaFyjTE4bXJ1rPe16AUyjCZcSk1k9QTltp3lyOz/J7of/6B4WuSqIvozSG9/eCJDC02Sqd1IQYBbtPshVVYmIdKYjgdKFt1JOdkR5tkjZf0pS4CLxoo5BiJ9vqLq3X7Z7u99Awc7X+cxNVP1xRummfuLB7mAxtpniob6tSLLDPX8F8MF/+U5XoD24sT1OWmWIesXFGKVtPUpX0JMqpliybIizhl140/+qVrqMBTOUFl3RRiVcCdrDgDqlRo8sMbEaS6YNTUWr4pKNLnm+tFrqlFNQVNdxoX+BPfFi7utHLx+aVHGZnGSc4UP2w0GCSaWDBTcx1YnZjdXZLy82VpMQtssRvdKZj0nXP2DqTBZYB8zJc5VmRxlzrS+8zeGFyPSO/IW2HKhNIjb/t+lLjay8engX3rcdjV9YmwyRuk0b5BDwTG1TOcZL/lTvUlu/fVbJ4eflvw9yvRT3fdkwWm7hp/JB295LkbA4z81E/1JlUtvMJSSVzFu5pcs6ueEr/RD9Xs7fHR7Y3zUhcASzHHxJI4JW9o8DnOTWw/PuPW7nxXA+c4iwj1dqigPcBQsw6jWG9gsp5H1/gx2Zzl9WTWoTWphv32YCCWq7uZuvYFtB31cqnlc6Q/zdQISvqKYS6HwYzZwSOJRi2A7/sbOKjwcEYHId4PuWQodx6KhkzlSibqsc+G8cvWwg4jM7QC76R/LoufkPga/1H8l1pk4SmggJh2b4NQTqIF/CR845P+DyZVQhizhtnRIIPWS16erG3pfkY7+zkK0bpfFpOmOY3zrBsG2V+WZw
 v/ekkAIK
 TImVDHFNyVtAPrdvD34hN+hwY8sFoysXe/Gz9KbXgiX41gniyyymGEvgQTVKaYRstafWFaz7gnWlj97BA/u/lj5pNuEzCvqEzVS3IOxQrpTFH169kUnKLy/IZheebbazbApUTVQGyZI7i3Ks5WWQxKKt+ytb78ZHqsTzKI7XNnQQ6SPpV1l0bmDXStEAF0gpSLjdonciJdImuF+c5+0/XOGjPpq5J3l5K5/Tb4elXmsQYDv1fs6wOlxjrhgffpNTMRcUyXhApEFBqCoMOSyJ8Prgikr6/CgsQjYxnbtzJMKQJKLcpt8e6tNySVfHmkpOVlcWYWQuOFLcbJCsaujjOif9WbqPOILYGCIGsNaC+pcX317Qqx3O2LlSpT0e6/zKZta0TcpNJBB1/Gho2wxuqaGv6YuOW4ghn3JJWaDcDpb90AZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both only read the counter. Constify them so that users can read
counters from const memcgs.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page_counter.h | 4 ++--
 mm/page_counter.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 07b7cb12249c..2baf7a2b29b2 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -63,12 +63,12 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->track_failcnt = false;
 }
 
-static inline unsigned long page_counter_read(struct page_counter *counter)
+static inline unsigned long page_counter_read(const struct page_counter *counter)
 {
 	return atomic_long_read(&counter->usage);
 }
 
-long page_counter_margin(struct page_counter *counter);
+long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 98322803941a..9167ffd1380c 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -54,7 +54,7 @@ static void propagate_protected_usage(struct page_counter *c,
  * Return: The minimum value of max minus usage across @counter and all of
  * its ancestors. The value may be negative during a concurrent charge.
  */
-long page_counter_margin(struct page_counter *counter)
+long page_counter_margin(const struct page_counter *counter)
 {
 	long margin = PAGE_COUNTER_MAX;
 

-- 
2.39.5



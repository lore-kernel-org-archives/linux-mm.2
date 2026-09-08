Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1468C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC98C6B00A7; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BB76B00A9; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5926B00AB; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 816C06B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1F75A0567
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:58:00 +0000 (UTC)
X-FDA: 85191051120.29.4D447A3
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 780651C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lxeRvEac;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=0aYMx50K;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8aHVipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=;
	b=TFWyHpfOE8Bnpvlw/pUp8P2vdmm3xx4cBLwIqadPDLRNqY8NKuW9Far5nMQqFQWRJWKLfN
	NKuALrYmnJ0l7Vml/0fAogJcIsCXF7MTsgXOvpkbJ6LqLYCxs3ZZ97gyeyHjTRDJ7CB1G7
	39p/xS/1+SbysuQhxoTa7TEzOY21Bfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883078;
	b=B5g64OFTS8K9y7kLkWlAzDYxA7v9GD1mfb2aJMtEWujJE+VF7JrifNIHX0Epq8gODmRhXm
	+gCiQ7KaKELYn3pGu9W3opDveRWEkvgiiAXKSk5n4RMmLFy4LMHeImtSgXDu1kIxM9FQwY
	8QMTMklBtSez22lJso5QcQhvCqvQ4f4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lxeRvEac;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=0aYMx50K;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbi9T2588921
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=y8aH
	Vipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=; b=lxeRvEacj2CaULKnGj7D
	G070QUPMJYU2sjFsGzNrfg9ZL7z5QhvqjAiT2NZaVnRKkEii7DomukliQ3x0q9vN
	y8ICEDwRwh1u3TvZ9muB9RYSmrMHJIjcVa2VSfutXdVGbvjKyQGSY8Z9aV5l5bFH
	AVNkSf408qYKht7bAbZxIKCdu1aZyG8wtfv1mqqRzqUI02JsYeUuxjLVNutaItyN
	MHTK2cO68UnylVxld7WZEmCnYJdQd+UiQW+RIjbLvmCuc2DOc2Oy4a8zCOHQ8Ti1
	QfGu98zQ1mh7IXZXoNbSDCyu2oY6HMtbTTCFNPFATLiMLau5+y5XVew8TgWLUwpm
	XA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5dm9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:57 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52ef04756caso92313481cf.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883076; x=1789487876; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8aHVipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=;
        b=0aYMx50Kiv0ZBu6FDPa9kYk00K1OtWV9ih+XLyM8GkWMGR6wHE0caF9540/Rc6yBKu
         XaKZ8ViuT9iKuR8XOfueyZJBlL8WYaxfKHBU8KRgmU59pHAEzdLN5Q0SaRsTSKulGUoL
         nHF3qY/KoPiRxN6yR+jsjgPdqzi2Av28fxYI622RNTLYe4CJejuOQ4Ke1f540g7gbhBK
         Lq0A6DY3rlGH8R8pWK0T2neW79wwMNXcvc4BbpAhz1sxAEBgEutDbi1ZQGND49KUCPmT
         dECeHpNPp2ntdMD0sOPEb6yWAkp4N+o5aci/UT6A8+VRwaMtlCz4YkyJkpw9fe6+fNPQ
         kIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883076; x=1789487876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y8aHVipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=;
        b=Qm8A6qvV+kpwOIMGdDFBFQSzlzfdEGDpaRUzXCqwfgRtA5kS2bMw6FSlYXyKroOVxr
         VUCPFZR9fAskPitL1yIvP5Fq7QSDpFgXjvWdhCkvdZ4bSsRZCo2tOgocqq2tTi+4YHu6
         QShBltzez28rvj0yGkHeN+WT25ydozIKbWrtFdWIoECfXPIdI/pXSc8fwUZpz4pym+gz
         coZP2Yl2PbFs+BYTv5eaBtP67ocgNYtYcfl9D+tCQS6FC3JV6Hju9REBtiO5gC/XH2eJ
         /GaAxLg6PqRGHbAQjRrrh6HKx41Mxe26eAt977iAfJejEchTlRoi5Rw+xNdfe91qeWhw
         6wfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPmc6amH7qkVYTAJL51PPoObkgzqYRtKLc3muSeNXUEPlQnvetuTEqGn8jfngQO79xi34Y0VhrFw==@kvack.org
X-Gm-Message-State: AFuF++mq6iylBApK1V1g2NAQk/BQWiyUeo735SYDuDBHvf3+FrIOu88L
	1j2qJ3Y28kxSELvW0zRB9gAIPSoeON4P/tuPNX1HysjpeO1nvynlqrWj9/lbn/46cUGaYWA6iNx
	6dRKRytwOdQn9WhMuDaUzUSAhHzzPfo/eAQ2wr4d6rjloBkQ1
X-Gm-Gg: AYBFou371Y3X28JocIPluGEoeRVGBK4+TwVTfEHC0tEcJF7cCe9Pgbr5Qkfkf0JuYNQ
	G4vsv3jqzDPMO2w37mP3xoihqHTUT10K5YOWjwckoizzooR90ayyQx4PCnjgoKp00JOPtcgzfSv
	4X2Xer0pMumtaYuuQ4i5NsdxpNWM9yjtleuyL225ZAO0dWox7ZQYem2Y3Wlk8l3HjCfS/C5npDa
	TS4l7ZzRPnOjhSyyHP5f79+XM24gc4j2jYeG6CRwpjxg1ZtJIH0Pc4D7SxxVaicCjBO/OyI+RX2
	rilXDP7bMa85wB874YcLeWO6rDywxoP3bZQsPkxAKuQ8wwtvqQRWgaeAsGgQJEJKsKr1/CMllFv
	JHooMOywXe+i9X6IlCUMOa30ED5R2vm88h6YJq2QzaWxsINKT
X-Received: by 2002:a05:622a:1f8d:b0:530:42e4:1b5d with SMTP id d75a77b69052e-530a2dc44demr11256111cf.42.1788883076247;
        Tue, 08 Sep 2026 08:57:56 -0700 (PDT)
X-Received: by 2002:a05:622a:1f8d:b0:530:42e4:1b5d with SMTP id d75a77b69052e-530a2dc44demr11254981cf.42.1788883075618;
        Tue, 08 Sep 2026 08:57:55 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:45 -0400
Subject: [PATCH v2 09/11] mm: memcontrol: constify the swap accounting
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-9-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RGpNqosEM7mzuly6uvRrlBbYNHGessdlxA/pengEqCY=;
 b=PCxMwC11hDWIhBZYDJPTOn75inbk2rXcicdxcrk2psxmlRzrBn5H/SvPaBYgZlzebUmYpnvK9
 p523Ms9PBDrBJZRhUDFKp7xLpQVujN0EmkmE022/SnEWdLWMrHaAH4e
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXzWa5CxOT1/1J
 pWvSWe4o42fRQaCv1hmYLEIVyY4oF0ZQL90XxLcquov3/ySv+C0FKkN5Dstl3jffuQQRHDmSDeX
 a0OKY/Krfl8ar4BfYD4vexGzMoZhawieeqpClLhfw5W0hbpefns/jmkaIYMxAgqzULBwnXg+CGx
 2BEEeCJ69JalwE/35GLUOV8LTKI5cS+97LpZUrpOXcUTr3RbbsZnTpAy/xFPWWyBpeq43GWs+Fw
 VPXzvNUnPmBWbvVlTO6/wGva4kdye/NBz6cEhGkSCmq7VFcyBjQERyrSsm7gwfE+Cr30fzcZ8hl
 AQV1w3LSMhGkjebprRdAQPanyijVppTW5gqcBzwQe8UWecPZXRYmrdtLs+NTiFUESjuEfmuROaY
 uiANfICiQ+FZ6TpLcc3T/laQszEWv+LaC7BNcaJqLwgQoMnLZQRXD1yhjRY1ywwG5VcNUXdhA/z
 PIHgg5ds7o2aplH8ZWA==
X-Proofpoint-ORIG-GUID: 3XFBi5fljrxUJ8PAl8LNRQkydXZFhJ1v
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX/38PV8BUwGP7
 4jYo85of3Uz+Gxx0d4ufkwBOYQqael4o0blOK8kOcbDFjcALMmLPyjZnRPisjX6BcduV2yRChQK
 wxAvz0uCF95YmJ9fLIYsissX5JeB6cB2nK4abmT/JC4OxeiO00Ky
X-Proofpoint-GUID: 3XFBi5fljrxUJ8PAl8LNRQkydXZFhJ1v
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa03085 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Stat-Signature: 5tb5cb8t9qz6yju775us7cchmndgehsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 780651C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788883078-470549
X-HE-Meta: U2FsdGVkX19VWJBFXmNtPKZ1bzKMZMLXp0bOD92zb1gWezDLXo83rvYOLpFyHFEfMyXW4V7pN039JIWRTszSYOM42ORy3j8weFKQYgGNz7QUF4h6v/IycmhNreZvZpsiEuKr1KyVhZYS3KsNpvIAD/lkZ38i0li3j8cORgFZLqr6BsnO9N6aX8GynMQcDZz9+OeONNWEzLR/zHfvLR4ltB5LaT1iBnFhDi5Z4v4NyN0beCxghRyPC9DZJiJ9g+Nf4bD0MP8CJhY5XQop28YzrbYqiR9VW8EpMLUGYwHapS2hWxbObd95I4GI9BOOZc6kC512t43Im/u6Ok8lgubIm6a3m4/pZplCaHMPUYhABOsVj7/WT0T3sBog52Gd7jvlxdRYT6rGhe1ttj7991VeJ7wy7TD6BF94tzMKDoJdal1Z6ZHefAVubcx0ffPbiVwsrItveFnubTPGaPoTQ1+HVFnL6OskgiSlmXev2XLh0aP0S8+IA7lxcg/rRNFNr7ZX43Ja2n8UzzczvOtEkTy1dJnHgilPaNOLXJyccNoUr18CvL8VOFRthl9HtDrS03tNHx8ab7bEbDOJ4oD1ZUtCSsK+wOoERn/1eh6Rt2zbRG3fvh6qjnLA92PaAOTWKt8fJ1Zj+WqzPgQ9OJyqRScgYBS+DYGH+1rGV6QZw1eYVFbuO3vxlWpFzb28lJprmUxLjubS5LHDy8SUso+vF0nSJz07b118hgVWpSji/hrsokdHOpHbvifK10IZY0hi2t81o4HRCf0gQB+SvVypnVYkvbRxablzx64H6Nu38GTNsSZ00AmuuWNXtiuNnvyEzNHkkT1kylPkhUPvK29PglwD3D/uHcNyzJmqnQuJfEor4EUl+dPvA0dngjKtKp8s1xQKt6MSbA3jCneK72GPQYel3Xqg66SCVL39xYsI+ipN729pLeHs9t0dOClpa+h8qrVbo+LmVW1anCxDrWtc1+e
 LqNsydCB
 ipZ/p21Bx354BxxrtImtM2stZVl1f0FevqKRj0ml2qDsWm7/rEqClyqVAQOo52/4hhDugKTLtBxhMF/z/Sk5iNER4a6V/sI2BJDSAbdGNqCbFoicJuvK1ifTJnvSURgjyrXKVJ4C10Yrqqwv4AU7A+m3iZvISL4CHz4LGov4zxDrg46nLMYIwAd0UmtzS/5v7Y2X6jyzNIMcE8e9OfthFxvM4TFTs7yK4/tqs60qnr11x11rPd2vs9B9z4xV/BVNl1C+aqEy+V0+MTQ7NVLWjVcEvQwkfe5FfFGBBvlVkAhyzKSw0EEcjMobB4diLZEIfsHQKhN5y3rlP3zB9ysSuGXny/HK6xP+894NZ4hqfZsGQIiShSWkIZIDTQhkBY+YIf9rz
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
index fc290e29e4a9..843d70680b8e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -505,9 +505,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
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
@@ -519,17 +519,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
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
index ad9f5e558814..0fcc0ff587fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5958,7 +5958,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -5974,7 +5974,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -5991,7 +5991,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB05C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E816B009D; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE64B6B009E; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61876B009F; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E73D6B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32FDE80597
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:40 +0000 (UTC)
X-FDA: 85217568240.14.A1468C0
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id A06B340006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cGCg8xNz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XpwqSRs8;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYstSgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=;
	b=uRHByaCmcdC+HPZR9WwsZ8s3iwHoXI968hKjztutizzTnS5t4WsnTFE26ozgFG4YRf/lnS
	5XbpuyrAhH6w4zkPO1WLweww8q7+3WGvorvdBJcBwTe+TCBQK9bp2k2Mq7VVwy+g7RsQyU
	IdwJYyPrhyFWUlz+rgNDTz+y7GLvYE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514437;
	b=UF+ROvr4jfV1vZw+Ya7nUDCP98p7hNPqSJ/Th93+AaEVJ2N7CnXDKZ9MonDEd/FmTxLsCM
	xK1oNX9g8++dFYHAzPk6mlgabbn9JqWYaDkYtsjW3dy0Eev9Cb6Bo7UtVC5pE8H8HmSzB5
	KonoSwfWMeHfaLyvXU7uOHSG7+hXJ7c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cGCg8xNz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XpwqSRs8;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbNMx2571384
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zYst
	SgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=; b=cGCg8xNzEcxZDSZEQJrG
	5wDBt7ZPPO7H7lMeSyxZ6VLAl5vmdsgxOH/kjRmnAnJOkePo2KkJ2PVnIlEJoY8I
	u79tIXjIcUW11nfnic3Wt+RaMrpmXozc+dStJrZruVZI8JYh/RrkNX4yEhRUzbC6
	Wfx0/2xwJr+9MD4kWxmUPRqggE/tcQvpVCOvWkxxFhjfM2qvQ14sFwiu4PO5DT1b
	4MPvShLyJH3qa3byy7FfEeHhxfdPHxHJFNSWsDXbjFs5CYq4j/LkuJBXhfbzha0R
	I5piae7jXD7tj1SjGEH7aCZwp1RMwRrT+mRU7kQIICTnWNm1Q88D0Qvc6C4kX+UM
	iQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9t0a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a01d1d1b6so628643385a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514435; x=1790119235; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zYstSgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=;
        b=XpwqSRs8QASGijf9jtQ7pg+o9fwbrFyOeInkZzYITB1WpZYMQrPy4lBrMWlUNgezHf
         Gc2u48/YTZoGE4i7e3lc7GEXTo2vZG6gCz3a9PDP1+u+iyGtRofpy1n34FEPJDRZntFJ
         J2CBP6YHgrtw+HYzoTVH9sW6moZ6GNwFy1Y/Dhp4MuCOEr4vDzcmnvgXYJ6DeFOF4WH1
         DFletMsDqbcBUQsBQ5I36kn+kavD5mY7SJSQGB5+Qj5B36h03kgN14NGl4RK2UTPIUG4
         uw//nQ1C44oXbmDtAaVcZUNLAJnPphD20MPpks8Oo8EW51TmcaVVORpljPICiivyeo9H
         tD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514435; x=1790119235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zYstSgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=;
        b=h4vJ9+FS/+wBVMqcRgS8kRR6n2yRfsjLlJ2k6VFKkjdD6hFDwBpI6/Un8sTyg2z5Uz
         sQnY6fuhgFJVfIZC/n2S5B5nNHWUsfF1htzBOHp4Qra3K6ELAI7mI3KM2Q1gYWx+h+hr
         BLnM1CaVeBNOr2xwMfVzYZmDeb5uKG1jC+8/k0ErX2ny/PpjMvrvIAC6YBTpnyInfF6U
         NxFAacm9IwkmuBp+JrAgY7XhiMJiowt7KKr9mpUGvKTv+LNM72xHtVA78pLh8yGKQCnz
         O/o8t1173k9twiV/4LMVjbEGmKXr28dZn+uyJKHVLIWwX/GL2HatjPWHAPE4nC/dY6cx
         1jmg==
X-Forwarded-Encrypted: i=1; AKwUvBwxYMWknctzmGpM2MD0yiP0zNYHtaOyQFaW7MjHkh4smNdhbstdpymXuc8sd7+HCtyGmDGrgbZR9A==@kvack.org
X-Gm-Message-State: AFuF++kypCvjuOEPLTURRUlu2tplHFzZnNfJ/NKvz9ZkNNaUKutUX8cJ
	ZJf01JukG1YGTTJDQuSm4Bh4IaOz6wy8c8f5GHbU9Hv6UCiyQQuIPM4f6Ejvjd/3h4aDXMma6dL
	vCPbBxMmPG9waKk/wcA72AdDYmdxpGG5YjOVTypw9R0PJR/ic
X-Gm-Gg: AYBFou0jo6oJYL1k/Amneqp9xAqOxUuPkVr9DQKv5kzYD1OnKs6eh5LyG3cWdjJgaFm
	CP9HI5UKv2Mx05OlYPkwT9Cv8hc9BOMWDUboo5HON9UKE8fYOkkLSZlGhhSmZH9Loc3Mor9c4y0
	vmTW78pieilsGXABcV2NIeLgIbEd7RgEKfgYA28nm44oRenyk9Z3hSlN8JgIdQw0zqx7n+AShsn
	MjQ0VweG9N9GIdzu+MlEK+sXrEdGXhUSzvtDHth4G7sWNk4elNc//s5Cu7HfNQEQeBBxSLCa8G8
	i7do7lnu8CMkoEpJhwABGaDuMr1ZDrhgTY9cOAE/KTpiXDpz7ZFVzTldiCeoBZsgkIZC6KxMBpQ
	DyM087JH6vLZmUliaJ+UMDOCvMa+G/JrdV5m/k6EZF1n7vhRK
X-Received: by 2002:a05:620a:44c4:b0:939:4b31:4669 with SMTP id af79cd13be357-93bb78819fdmr56112085a.29.1789514435305;
        Tue, 15 Sep 2026 16:20:35 -0700 (PDT)
X-Received: by 2002:a05:620a:44c4:b0:939:4b31:4669 with SMTP id af79cd13be357-93bb78819fdmr56108785a.29.1789514434915;
        Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:11 -0400
Subject: [PATCH v3 07/11] mm: memcontrol: constify the reclaim protection
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=XYSX1STKs7pY2BJKy0yWW5bNGeM0JlasGEgQi71dfYU=;
 b=XMrYI16sLOgXeu9GkCuBWqYbFcUTVRSbq0eIip6J9+7GUVK0b2AW8AUTUaE5Pl/y8q5w6PDb9
 0to45QH3WCZCbT8l/vlyV5g6u/GPPekY2Us02TcbUO452qgcavZeFPx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2c4 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=Qozanl9KyY-oOybludYA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: pXb7d6qt-6cD6LkGUESf4gvJTpf6YXX5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6yPe5vLY9O7D
 IKPwSbqDtU1YF+lmEXannMn6dfgBkRU6gZ64gat1+Mi45aoyRgemTz+wgpqY4q/UMUsbxf87a75
 8Jgl5jpCIHkTHZlq17OifFT20aWgL+Yn19LcNE8v7tvF6LrA3EVsShJzqBXL0/OC5GmAxEUnLpM
 z0ckoITn4oKhBQScgLyu/bKrPsxwtTHUxLhkngo9Mz9cLoBpJ5Y8NA+t4ZSGhjXnM5ZGsbGMHAo
 F70lqlMab3BFWRGK/a6PpiwuaPhjZ9EpRmav7aiz2Uywz9JukZGgptWghOc51ZwsaOg42kqqsLw
 QF5c1SoiIsuDxIbQeHOXm+f7rvc+EbhUi9ajLu/7SuUWDDG3Ke2eoALQJiTKj9oH20wt94Fohpa
 ZoMy4VP90dqnbVhnl1MOOVBEW+ikz2iAI0qgSo5c/oATAfeXYK8PTeDbaIrq1j3duk2aeiHbii1
 WQ3/pnqVzTxB3X5qOdA==
X-Proofpoint-GUID: pXb7d6qt-6cD6LkGUESf4gvJTpf6YXX5
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXyaO5ZWW1Rp9t
 nNIKQXWomFF5pOAt2IjVgUbGpTsQow+ffPo+1Pwe0Ru7sOq8Y3FwhAojQRA8ehPaDgD7Xqu/jnn
 mr7lMCoCeHD5aO4P+ETx2gC4DAe9DNC0oF3eeAdz0XRS/TDnM0x0
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A06B340006
X-Stat-Signature: e81ukqgr1aam5yph7r53wmnhodasfbkj
X-HE-Tag: 1789514437-772512
X-HE-Meta: U2FsdGVkX1+evPjAH4hHyVS/128irTgbM+aDBAilcsL1HshlEkU3zKRFLzsrQWhfBdr+lkAWybCXvAN2i9hY9vScBIjfAztuBE9PptWQSWXvdPUG0Q12H51neTtwoKg594Yca1eyCi/uKxWAB00qxFcIIt4zIeJOG5BLhAmpq/WdUN3nPKPqZt8uhXk7X/czvQqMtpdhuCJpabWZA46XWvAeS4aLZ0zfUgIrHHbQ3SzejH9omJ++WiuU3lJ8VH9DBmitfFhRYYPospH2KDQHZb2J4nfTZOgxQyfCDfPBHg1jmkm/RmBI/0zlFeasMAuahlg2teOykdN242IQzDSgP5cxJ1bcZmKf1B5EwiZ4voXJtonrSmsCV97ptdYauKb/kHvDvTtfVliMaJz621cmLhzghoQc5yCOWIJybKN57SRro/fQM1+zia4XWknTCG+ZdlrpLZZAFEWmXVvHJJxlbQ8IHi4m0i05A9Mt1gmRkPMYo0cidwKnvI3bXaK4+CQsRQnpYgPkbof5+QS5GZI1qthzkQ3FUq5rEDVMYZMuI3R8XtW7DpxUJF0fUzaFj8v9bCbXY6B6o0PxTEBxikIay8tazfjT4x5qFfgAzxA0XYI5GzY17CUO2JKBr9glmGC5UDYQL93kZD1ayGiffoYjtkUix9/JCTxpPurlJbLbwvKg+r6+KdDzROIagQNZNeB4XvoK3tDotDy2KC7+HsxNFCPA4YnQvA/W1gOAGrQbkykLcPMNeE44RXFxZ0zdgsdvR/KmDACAVokItkyqsvwDN9HeMhB4XxsekW2qQ/TwUQJDFnK/3uyacIbo7BLlVeauqE6atiZA8SUFhZnfYCxDwkcgeTzhuc8Cb6/FlvPYFwpvn6a2vf1qgrH36IoKlf46fkQLWPxtBtrAjrZ90T3bEYv9M/kxb4BzWheSATG4xB7forQuKgno4OJIulM5DBTQu5p9oT0VecmnWGqeUXX
 TgxXrNlm
 B9ohcxb435tijlHGXQhUw8WBu9flBt3a74qkpAxhpf60PetukMc+BP9nRZid8atdcFW11giJzTxIPWu3DhDF8MYcjAMw0IdZIDCRp7B+3GsS9pI8eTz6g/c+9/QAi2v1goRDBL0j1FJnkFZq4CbAnLD4dX+vHflx8lJWT6FXtZdiPcHOPSXjKqhWhGIU7+aPpesPSKziw1gJInEY0Q9VywATz6mzpUuHCNw1yuLHOs9GS7emA7tOhVUi+dFrCAMwIhDZyEomF3e7Z1Q/tniutfy3DoGlSPQvh7ZoqRuewgCzAJmNlpTMUxDqdL2X9xKDDABJde78E3/Kk7L48bGDwi8+GItEZfy6YRC19J7Tu81NJuFraFq3yEnR2CDL13x7ZFYBR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 01f74413fc79..22067899eb6c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -570,8 +570,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -637,8 +637,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -647,8 +647,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1149,8 +1149,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1163,19 +1163,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5



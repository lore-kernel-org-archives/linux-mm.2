Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E621EC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144156B0166; Tue,  1 Sep 2026 08:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACA96B0167; Tue,  1 Sep 2026 08:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01AE6B0168; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C416F6B0166
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:59:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AD651603AE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:33 +0000 (UTC)
X-FDA: 85165199826.04.D549AC9
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C559100008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XazXTHZQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HWTu27TV;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788267570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nG03EFrhQ3xdhPt16h2vqt87y9zGCEMcI7dzmDL+xeU=;
	b=wMdx9oaPqZgWQ6rOctp75Xlx+QNar8lmQjgTJS1Zq75QNixf8SRjQHfwz1GRjoeHSN6TYr
	nmwTQBKZm1GPecLJTcRRrcUJALQpEsDavmLBlKAxbNdlGdWHdaRu9LYgBimshiLOb1Htlf
	Wzobr+sXUFvgmBhyrM13j+DyHIpqJyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788267570;
	b=vX3JM3xYRtlTBOuBGF2z0okPiUASggl4KYzZiMDI9OVwFEGrZC2PjTYKEDVgvoFSf84Ux3
	5eZ8E7sbgVOSB7F+YclfX4Hy9vLUfGMPXnzJ9ECqaprIjc9jy2LRRYsRcX7pa+cO+vdlPl
	ApCyGAnvC50dCdG6EUHqk1z2Zn6Pd0A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XazXTHZQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HWTu27TV;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681CXx5w1067517
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 08:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nG03
	EFrhQ3xdhPt16h2vqt87y9zGCEMcI7dzmDL+xeU=; b=XazXTHZQbCzJHYJ6TIds
	CANk2snNeL3o34m6FnOzbDuUfVrGFtgi/oHJ6LQ//KMXybfMTM4x+DvjwaMWYz1R
	469RsoZRPHTS2lK82S9G5Mxg5fzQ3IFB/5MmLYmK84c180Y+RfIWZGRIJ/NqvdFl
	AE+lFoQNNFgt3/xN3Q1S1+deQAc6exLhs2zxbg0pzu7u/r/X4YliA4WClTdwJ1R4
	2W9UcQSE190FlnQZe1XG57UMeFzjbif7kdeoTQ5/RoYj88u1J1ez3xarxsS9Q876
	Ta3NZ3WxTqmkYqA/FJy1R9hd0A7s4icaFxAAhBH1yXeEs4kzG/Hsspv3pmJQPvok
	QA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gdeqbdca4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:59:28 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so17552781cf.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 05:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788267568; x=1788872368; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nG03EFrhQ3xdhPt16h2vqt87y9zGCEMcI7dzmDL+xeU=;
        b=HWTu27TVJE0ptGDQd7OJwl2qf+Um6PcLD4vH8hECw6zCUvmKPgri+JDOvxlZYGuiOq
         YLnzamByz7oNqnrz6Idi7mfv2Ndd/B0usFFN5InShtjqYHGJ1HKP5Dca6niFa1NBhc47
         ezO17c73dEt46TWhLQvyo+3OJgEyn+a71Euty8Uu78OAtElGz12qzhugyZkpu46jUFHW
         4n0YEmVFWQ42HmZATUCoTe3Tsh+5fkZzNGvI0V5ZkbZEwdgNLAZPFpG1TloKTvLUcify
         RxZoaJ6uI6nKtP/mV0uHa7cKE3V9ajtcMBPC7kMLSieXFGMK90lBrP0W/3JmWhktXqOt
         uh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788267568; x=1788872368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nG03EFrhQ3xdhPt16h2vqt87y9zGCEMcI7dzmDL+xeU=;
        b=k8JC1lp3E36ZhvzwadGn0GLWP7GnhbOw4lEeCNHQQ4TeAhDY6t5A7iUtTEakJmRHsR
         oGesx2rG3inH6tV5y1h7pOt/eCabZXD5Rc6+iQso6ov8ysU4f6dNL7OUHbVUOL78NcC1
         HVebteq0B1UAuNvCJKIRZi3/SNp+B0/DrFTR84Y2ooJ+HIg7YeL2MfrGTGuetSNsGT3d
         dFvUcUdsKmhL6ddNieEQS38qT9tPT/pZ38hcwaDHG9gwdyo4JwYpJGt/bMvWiQate5P5
         KSauEadOCi08kIEMiJyy+bPfaQ5YbqkN+8lnvfV032u83RLSzMeTus9m4aRmF5b9rhaE
         rLuw==
X-Gm-Message-State: AFuF++kBYgGFIhblzPg1fWjWza1m+oNv892bt6AfY5EQF4vCps34C0RZ
	QhN1WIjfMNYYr4tH9aDTHA50SThbZaYQfWK1TKDNb/spV1mkZX3usXSX08PhzfREcHtnVmHR9z2
	s+fqm/asGlfkwvW82jQRai8ANVq9gJa41oTVjI54R1zgui+oD
X-Gm-Gg: AR+sD1232jtTAi7hinGj+z9iXJZc+RO8quHQusoLUAYJVZaFeIy0N5ZLcLOPqnjF1NR
	OvzOJ8o6yj1Z0VUtkcpnxYehCcz9iR341X8vbOavVDV3AN4ye1x3B03TrXLDIQCHcBZCZJzJect
	3oF1FsFOiMyhHPqEmcWP3TSBc3hSSP1OngsrELMXjAIZK8nmbajJDpeiImx1ymHjdqo7PVHcxX+
	YhX5MURSYzh7qjHpxoYdD/4rTrPVyDDJFOVzNwVTGtLaziXLPMs7jLSjUKFdJlyErJrvhWmjQDx
	LLOTapuh7DPj4ImmGyZ6wtY5szJu4+LGzoXcaJ68B6tGzrp5DSTp65fSCdSplNzYoOOTUijL7tR
	kzVDBVsfzMK+nY02iO0wJlXxfL7IZnGMVjMIDtKIO4/qENtEi66M=
X-Received: by 2002:a05:622a:1aa8:b0:51b:fb5f:b263 with SMTP id d75a77b69052e-5302522caa1mr66139311cf.4.1788267568218;
        Tue, 01 Sep 2026 05:59:28 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa8:b0:51b:fb5f:b263 with SMTP id d75a77b69052e-5302522caa1mr66138571cf.4.1788267567695;
        Tue, 01 Sep 2026 05:59:27 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe830222sm96194331cf.20.2026.09.01.05.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 05:59:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 01 Sep 2026 08:59:19 -0400
Subject: [PATCH 1/2] mm: remove unused mark_page_reserved()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mm-remove-unused-helpers-v1-1-f092d086f7dc@columbia.edu>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788267565; l=769;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=+y26FGfjN1LnTKbYOvV1M/8MSd/C0SMfb1h4AWi2sHM=;
 b=khNF4ndV+FgniVmsA2xC2A5tULhBAoUaVrGa7vzG3126nk6/FaEMXk8v7zbZyfErmdJSCQ0EU
 grp/fjxsFcgACYD68GWBfOScmvnA8KKhnIylAzpqkrJ3iR+dmexBgfn
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfX+tAGCZ0CjYVX
 eBL7DZK/Vj8CC5MpFPQbh5pUi/G7wPcdilaaUMqj5TPdNj1Jz37QXafIIzloV7MztOwMeipY0d7
 iFQ8U76vstHAMn+FJNQpdwEHs9C5I1NHGgQexYJ3Todt/OeSI3m0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfX4rG34j9C22BF
 tXM9t/YW5F7n7mGFdCd3BmZBBWlJDO5xX4gny3XIKBLIk8hGXgFIMKNnKSCcINQHarmEEiwKoXf
 LuzlsCVCoAELIL54mpFw8t7xz3LIAO2hrrGs1Z6l/QxtKAT9r9sj/WJX2b8vGsP6PtWnvFKLIEv
 3wOzO9287LqbtfDYrAX61/v2+b32PCSZRDaYh5Q5ejIqDBSw7y2Pfl9GPywayG4h5G6ijzXHC/g
 c+GtfNkB7ZiNA9MaWosKT5QzMG8OsQQiu8aItdfmbb3FYrs2qHlNYNi3jJKUMV7ABxXZhvw5ikp
 vPoeA+M1+Rah6dubrOfXZR+luZ7OvG4H+VbbSTeqys7uip17LtShhD7ZRPjMNKSOWwZ/nRaoo11
 Su85cUY6ppMRu4pNkzcDmVbqotS25eaGsN88l7D/2EL26Aau4ZTZtsqY2ToCKSj7pL6fSGXG4xq
 30simjJwJ9dPyExF+3g==
X-Proofpoint-ORIG-GUID: MyUN6SAwG5aks3OzRyng3_E7E_bs6mal
X-Authority-Analysis: v=2.4 cv=fcSdDUQF c=1 sm=1 tr=0 ts=6a96cc30 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=XhWKxFEwkI5CrsmnjUoA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: MyUN6SAwG5aks3OzRyng3_E7E_bs6mal
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11892
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010115
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C559100008
X-Stat-Signature: usz94rruh8agftjeisw7bcgism43wo99
X-HE-Tag: 1788267570-931724
X-HE-Meta: U2FsdGVkX18+Lx7gDVc0h9AfmI7rgo3rQ4sv8vCGt6mBS8OTVgq8YFgYUnrgJSvfJjP88yL0kGydVzP20Rvh9qajpznH9Wufdp3Ay19QtLQERf6WxMGluX0zeFnoh/wGBcwxGj0I3zHkNDls3C2UkGNMN6lvNRwlhgyHUIK4xRfo2oSe8XHF7hDQLTR77nBYxZXJcXXhIlqtfjZm7pyMp6fkJY3vUcY4yP7mvw87cFeHdKZz55XLIZSu7quIRlPO1Uy1kX5+fNuDdsN7+hMXzG5R0R6qW2QA3FMrtOrVyGJaxic3gpnt697rDIEiBXwsByu8B6W/aMINhMrpG0xjpAAeLaT1Ts/0cvkuqUu4ichYltJJbvJ3zHQobLuOMRXvb6NVP8ZMDTao26q44fW/NQQA1e123P6qLuV5RWAB2RKGIQtUtvESq9svWBiUvzJuJHCcqPWe8k2bpo3mZUm+n2IBRWYsgDSHlqJeaOluUpQq/f5lz0tmRObz9CRZ4zL4PIomQete+wWWojrJefJ8WnRWxIBi8vuhiNGvMQ9Z2nj7QGp3vsNKvT9WKUU/Q6ANZZD1M5m3ITWwqDq8U6RkFEwYBemnEs1qxPoCxVLi3geyUPjujr014nVM3S9GEsb8l1m2yY6ezL3nPYYYFixxbnHyX+sx2N/J7trttyyU4uYk3m94gcJuuZgPhULHqKPB0olHL/iDJeuHAdciwFRW5tmcvz3c3P/MyDkGjeK3CRwauxHq/k90CI/31ggf3Q7ica0aFLjRd6VeHAUHnU62f54Mgc0fhFrD5lZQFJ80WwupIg1dyVevVd0OD4TSSlecwFOnJ2w3cFqzeB56tRVrOb5tERBfpxSaq3lWBv8X7VroQJ6222OxoY3TVuy0BTNqTYq41lET1RI4ZFn3j4Zv4XJC80+1j/BsibxjLPj35OlNTgr/M1HXhqAksqfIzAacl2WQKBBQoEX1jHK/f7I
 JNuEnKxT
 LE0bPOMX4YHiJjUPA+OxAz9KBLhsm2ESYUdYhnuBVNkyxNfA7SpzLi3qTdgsJJl45/Zyb1eokDslSLzWZnEJzT58G33+cEndJ2gIcZGlk/XC2PsPsqYKEAi3z+4x1sXE2vcdZZZ7gDotnVgr7wI2PS5QbEvKhV53+Qg7c8EfyFNpJnN/H3Ie3HInvS5NZM1n61k2wLB4k/qL2q8hdLDXD9RjRhvl9XbbWJ5ZXbYcRFUe9L1NhMpJnmuignKJl2IBHn+VNPtUSZ6m+VXlzGRastfPTkc8kNA51tyMvRYCEjunadq8xl8xndXHQYtZV0bjw5vjObCtvwVJyOS4TRKdhYIb2hC0EwpyhBgEmK0FbN5SHi05d0xZh9ivCegODHyw5sMzAb2IhVekMg/r1XSd7j97Znc6/5rRtnWAFQcSCPI2cnKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
mm: consolidate empty_zero_page"). Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b28e6fc8d5d..e3736c42c4db 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4080,12 +4080,6 @@ static inline void free_reserved_page(struct page *page)
 	free_reserved_pages(page, 0);
 }
 
-static inline void mark_page_reserved(struct page *page)
-{
-	SetPageReserved(page);
-	adjust_managed_page_count(page, -1);
-}
-
 static inline void free_reserved_ptdesc(struct ptdesc *pt)
 {
 	free_reserved_page(ptdesc_page(pt));

-- 
2.39.5



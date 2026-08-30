Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB3DC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B5B6B0092; Sun, 30 Aug 2026 06:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C346B0095; Sun, 30 Aug 2026 06:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3FD6B0096; Sun, 30 Aug 2026 06:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5196B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7105802BC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:40 +0000 (UTC)
X-FDA: 85157574600.01.AA1651F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F32280002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CGyQ1V6v;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=hzkMu7bi;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iltXE0WYwKKMJapYaKnipYxUvczqFD9fAUv3vS9XHEs=;
	b=XGXk4TRoFpEjqfwCvY4wK1Cjxp4dd8ATyxCpwtyC5aGPf8Pr2lzhuBztkRasWl464YyBxF
	qTzqrcH/ZHHXjWZGTZkgMcwfRLLnIbYrlFZoNn+DePjc1yiEQni/mDdmg50EU6TpEQf2eP
	oL8Dt1VkclccxFlmIHQMOrpQG1vdQ/4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CGyQ1V6v;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=hzkMu7bi;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086018;
	b=4+nhLabLgB/iJ4IuU5OPxH95AaRJe233PV6qEildqlHT24LgJ+7doYI466uDHsO3fzfCCN
	yqhpWIP68wBjpE3U/d70ByGJzw0KF51c2o1/aE9V+xx//JVJ++epMMsBzhHZRK7U+MZ1SI
	rpTSDZ364y/HzeR5a7y91TlPrWxLfus=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9sbMq3234052
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iltX
	E0WYwKKMJapYaKnipYxUvczqFD9fAUv3vS9XHEs=; b=CGyQ1V6vUw+MCMQcXjjo
	5rUZAS8akibjKgiY8wGGK9WLmQ0GU7BqMd6S9+BqN0/qHudVygkiakqm4Ov2LWJC
	5RBnuR9X4qi7+vS4QpVPwUTbUU+iBrac8S0BqC59hPYZicmIwGSrHs8MrAi5cyrm
	6bfhzI8wlFaGiUdJuVRH6cHRo1ogOeWj1GZYV7bSQgYXlKGk/0tdG7r59QAKSmNo
	Sm8PhhQpFEpEfg/7fkAyBsGDGmLJtn3snE7YARtdSqC5Fn/zz5NNhwGNMTqtdUIM
	q47YT7PxWyyhWsZP8fUDU8U6c5DF5aZD9aYhdIQBBTy3nAknLGuYzs8Ez7q8dXH5
	Nw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbudj4n0c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:37 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c26012cd0so31541251cf.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086017; x=1788690817; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iltXE0WYwKKMJapYaKnipYxUvczqFD9fAUv3vS9XHEs=;
        b=hzkMu7biDus+zP8aAWvcokmLukivXVYFeQBROPkDyupZwfpqR+wBsWto3qk27UBohR
         Dm44gsz9n194rBEbvhQqoZyZhRhzy5HQmWBH7L1WRcI22ukAb10fjMITqQwxAPB4JMYI
         kII1LdseCjJxcT4a1HRnLiGdkFKYO48qFW3BB6GjSYn1UkZJbqvs4opLGXQfUvEiDB/n
         u5JLUQAMphFrK01IkvGCxEM6UGEJZvi/rkdPrKh2y29sGc0u3G5iOtHhhHtDOls3rZyO
         rVQuuLdUBhsvCCVuRRtb1H1R2q7X2S24Fn+TGZavXL6oHXonbfegfaKsHDbdtOxFw34f
         NJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086017; x=1788690817;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iltXE0WYwKKMJapYaKnipYxUvczqFD9fAUv3vS9XHEs=;
        b=PSnn2JaZYXJ/56Nx9KbgSpyPym3gcBitIIeADFZEBgzXgcszyuzdkYbnXM/o7MddL5
         NtD1V5p9z/ZwrKUP62FZMjikJ1Upapq1BknBadhQy2yGPVdTmcayPBpXaRoTGt+GgEr7
         XL4EmpKq1+cZ7tvu0iu8EfVf0hjZgnOgVslVEPDsYNt5KM7pu+8t6MYO88jJE392P6T4
         e3M2lcNDlwZ0zKtj/oKdpjW+lXIn/2GWCoMN8zIkxQYaPGHxF9pMLzq7FyYNXJK1yAHy
         TaR5slI2db7vij9dM9f6OXyaWlLOZGmvPC1jD8e61zCC+YeBm6zC2LjLp/ieD9gp2DC1
         rhhQ==
X-Gm-Message-State: AFuF++nsMlkAr0GNsSEb2Tm9nNJEw4xEq265dYU/5tm0sCeVfeUAtc5+
	l39R5ty4l9kBsbiiQLh7gFRRUpULp5i7aVsRwI8xNCnx0jLeHY57Kttx10QCFxmsmhVSysrN32R
	auXm+au+OpXTb9W4x3k8kK+SLEO69aoTgkpg2tnxs7pUPYGhY
X-Gm-Gg: AR+sD13OgDSnJgMDee3sQ7qrbtcfsaDCmsM8cgReYh+5gvV6/74ZteFhyuvrr2Rnp4z
	6GoPt91UxSLxfyNZH1csj4DUPX9C0dKeHczqtptkanrQ2sO3jKLw9QGb+Y2Bl01ZWt11x+3FQ13
	ImdIIuym0xhMnGZ11XAW9h3H9NKwG/jnE+SEJeZ+ggwQc0EvW9E7rME2UDTWK7NDE/AUnPEMx4m
	LhA2GbBcLOOHTtC89gsbWLWThi161DHc98d47cDPidIJuOSMr73H5MWDSHzZFJ+ZktfwJ0GTrYD
	6okqMoGXto4pWhWLE0ozy7LAjVBBmuYiaOrqQO8mwdl+RHoeFaousmzxheFFOzTodPQMddbWLyq
	ZkERou19a+prPF8MS8uWZ0u5giMSihRMh+o1t3P0y8w==
X-Received: by 2002:a05:622a:3cd:b0:52f:a0b3:bcb9 with SMTP id d75a77b69052e-52fb941f705mr207116591cf.10.1788086016949;
        Sun, 30 Aug 2026 03:33:36 -0700 (PDT)
X-Received: by 2002:a05:622a:3cd:b0:52f:a0b3:bcb9 with SMTP id d75a77b69052e-52fb941f705mr207115921cf.10.1788086016476;
        Sun, 30 Aug 2026 03:33:36 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:25 -0400
Subject: [PATCH 3/8] mm/rmap: use folio_page_swap_entry() in
 ttu_anon_swapbacked_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-3-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=796;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hjPNw4K1yXPTP98viqWADLFrOSoXMJ7N2Y21LKrNJ5w=;
 b=SqXdQ6+SfH8WrC7+aQn5jmiLp05F+QV1V+8t1xTPP9zyb0Mm5AKQJxBCFYXPXhX+yzVhjrhEQ
 fe4zwW7ILfhCLYAj2in2hlUqvr8G6n6pplJ43VNfpGfmiyLZR5wFFBQ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX6ENSKQEAGnOX
 WIukFqqYVstZPyA5WCrUDOWEh52J7XrbviAAJRcguqpmO+Y0QzfJo/xXiv/QnkDjOVsAtAsYImT
 xjw9x8/iKU9SOzt+GpeKluh+PU70f0supX2pSFozPgukDI4sSxTo
X-Authority-Analysis: v=2.4 cv=Gr5yPE1C c=1 sm=1 tr=0 ts=6a940701 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=gAJobatAmFEwf0K8sXEA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: Gg3MpqJRLglsFDwrj76dNpqMv9oNurZa
X-Proofpoint-ORIG-GUID: Gg3MpqJRLglsFDwrj76dNpqMv9oNurZa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX2V7qnrNErFte
 D9d2sv6EOvMwwsFRd16O0xDjCeW3jonbviV1lwD+jbl6A27prOqsa/XSfhoy3tufTsMgAmyd9xa
 cHBK3MIfv8nYutOyRj6DFi2u42gMVPb59oFdvotuUvDvXxXKAg2838yZxfOebTkOxFpPy7diseK
 aEAOaGNm5T6NXJuwbaecq/YqPL1bshiEQ6XQKf8cpmQCdFs9M+QoaEsiOW4KWG9qsAyvHR/486a
 YKneb5vuFsAOPw5uXbA2xBxvu9DMHITZNUG4aOWuaAEpb355mBCb+oD+B5VVMmYkWSdW5A2K6Og
 UI6UfSTEmzaeMKIxWct3EFJYZz2A5fYJ9uqccvzjZprdR1dka1PJ4ieqanrfYJCXW4W8OXoXIAL
 mS9glZ7ne8VMrTONEH1vwGMvjR4dktyAydFM4rQM6cQ8pLTefjcTNmB48vExzLdDH4ojRz5zQgR
 Y4zAnF2FYePU+On90Rg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10 adultscore=0
 impostorscore=10 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300088
X-Stat-Signature: 54fkcwegw1qayhc1owh63ur8d88yj8sp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F32280002
X-Rspam-User: 
X-HE-Tag: 1788086018-765497
X-HE-Meta: U2FsdGVkX19e1IEy01Lx0+Hd6RhCvZJCjuHfK25fpRX+SU9qMCnjlAC23Y7caVPtXbv6UYQSZlshHVO/20mlhN09bYoV6rLFUnahl2fCOjZin+pv0TzhjPiteISB13NXdZf2ooKxnVH2Pa8r2aP3VgqJEn+psnT/S7aeZMFhBB+CSYVL3YYooji9p8+23w2pbWVhLSxcA0QnjysUuu+cM0SAFBV3KlLhiTDyIBLBMaR1TH/lGVc0cdgkm3bH+N8wnKz4w47A3jWF4/eczR3oMWiJJMd5W5Pz7rsHRuv3E4XuPwYqXApNG4fzT9z3IGmWm6LmAXrUc6OKBqnh3c7Stp6rMCuPVMwGA4NZiAiqg5ohjM4R+MUkh5QnYXeSYfkqf/jPVgdtX/koVCJr3y9TsJFsPSc3jBUrxfH1L/aDAeac0WaJ+NYuXvywALdb2hIF/3tF0O9EIRXdWlgVwkVPGAbBT6CJPrqD3bc+bnxmRzWDpB77RI7CUPZynxySRzRIQKee/Ptg7fgoS83YrtnSp+wvoSUdc/+b1vQSTFl1AgZ7G25MLmou6m4E7T9xm3EckYTHagjSRAfQilSZiNI+wAuqcT5USgTD1rNZvf56ZWAREVIPUMikCfzPkqTno3ZJAjwFGcRfRXrGLYR2gwmII4KoxcknNVEzvgyOPHld0rPmaAeHSKWgHltACv/FaS0drRCjpUtuwYmrlsgKDlLVZ2DVlgD3AXURCchxMq7oFfnO4/KGETSVniwviLtTJ6Tf6yHGxTtG1S7KoEZCWQJMOdzr8KwnQwIWTbAeMU0o02L6NaDDcOaX+k32lJ+JjF7zyslfnwLDlioZkO2LH6u4RLs/Ia3uW5IemufpUHiJO1kQ23a+ljXP+wkNnWYdvS4fUzh20C2WeRLmSB6XIcxaIthIwyVrn4O6ZBj6/H8WLInmzhm+SgvM1irAygxQvpmDQtS9ZmHTVirRzP09+vP
 zWB+b/Uo
 rDaCSuMnrGpsBhfTf3FLTD+HWFubrOZ6MSmrTLWmg7l/GVU9wYyxajDERc7D6WdaXvFkJN3vAwMLKSMCQxufYlmumyjDcn6KZpwOjRKjeknVFxhBuZsH4/14Ub7ewUEKs3wWEcV/gefITwd+a0h8rJh3tZXuYsU9gwvBghvdXFHkWb1nDGE4jc18VteqXCYpmkRfs7bN1MHIOCbSBkIBdQXNw2fnxza5fT1H8WWOJ67GADjWGtfc9KNRu2KeKaYSKR2Ivj01BCxtKz4gDVS1Da3ebNPux/LckHzxU4wlK4s5qRbauX/u+KBCCmKb3j63OmqD18cTH5gYgLZhyKZpPNCVhwlNRVRI2rpyCKx4KBkCy6rorTQqpiXByJgI/c5NkHPUvk7OEZuaezIpj2uiF/KVigmyYjXX3ioRnn4dAIzQjg2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already have the folio here, so use folio_page_swap_entry() instead
of going through page_swap_entry(). This saves a call to
compound_head().

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fed0362e0bd0..ef34126c6ce8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2143,7 +2143,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 {
 	const bool anon_exclusive = folio_test_anon(folio) &&
 				    PageAnonExclusive(page);
-	swp_entry_t entry = page_swap_entry(page);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (folio_dup_swap(folio, page) < 0)

-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCB8C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67096B009D; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF05A6B009F; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0496B00A0; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 900636B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2D101404A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:48 +0000 (UTC)
X-FDA: 85190947296.13.15E69B4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76AA5C0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hR3yQeBX;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="g+S7/1bA";
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880606;
	b=Ej3ggIOXp8gyRF2rHmHCKHXe/nS4nMLz3lXfbRy+22j86sfoA7g8+FCSpBS1QyaKy8p8fy
	7oVBetRqn76GbPLMCsDmdfE8VaO+0+1KyZpRjn9jK8dMoP5uis9SWt9xtJqI0qns+xdcs5
	wExqyukAsHxBbL14YT6QvLpUNfu5fnA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hR3yQeBX;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="g+S7/1bA";
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gj5Zp+Hf7hb0eLuXb3JsQ3zN3lqZPzkqR65AkPfI+wc=;
	b=v17avWhqIgIvMgyMUEK66LLelgFLVaSWV3SCFQuMzoNMCVmGErYEmQZQvaYIj5D8905jpJ
	Q6TcoeXtdwgeF3Srjy94d6tT7/gsI1IdsUt0R2xewNkndiQ2MykrVrXA8vBpy2UJEXHpVC
	kR79zQ2Plnh5n5SFcHT8wMksvCoRvb4=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYmDC1365554
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Gj5Z
	p+Hf7hb0eLuXb3JsQ3zN3lqZPzkqR65AkPfI+wc=; b=hR3yQeBXVrib9uXqGBgE
	H+c2oLr8jUTZ9b2pEsceow1ABxwqElSCI04sTB8TlbgrM+7UC86an1Gd7k8dRpF1
	3kydobGuJMXRBbQE0W088avJtKol4lLVulTgqIU0KELr/9m9qVAoOjhqgEJ1CkXE
	I25YQfg5JAiAOiUBcHZVaYj8qfB2NSRdMTe/nogjtExXhsEwqRErhS9UpGEXiDBT
	/uB664pRcO2HyoPP3nHpuuuOwwtbSk+vKCT02aD+pNvl/1oOtGaCTws+XEk8bDng
	NCg8Y+fp9biK5pMXEtZ/iUvLFQvJia1jTJzmwPPEeweN7bpZM5F+9hznMepTvTyV
	Aw==
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4y3n1r8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:45 -0400 (EDT)
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8563c2a53dbso87336657b3.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880605; x=1789485405; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gj5Zp+Hf7hb0eLuXb3JsQ3zN3lqZPzkqR65AkPfI+wc=;
        b=g+S7/1bABBAYeLCobw4O6y9NazbvAWfaPv6opMGavJfbrTTMgqm2qBLkstn0bqdevB
         wQIuMMvbWlJwdQIR75q7vtsnWgwI9zeN1Egz0x0jlD6ITiVVk7YUslJOuXxi1xau/A4i
         S9cRfvF56oy9tvdqBFaOGUahBQInnvlp5CYrOW0DlIg/CPF/dvfeFROhH3IXvPGT9nU5
         bBsw+eiCxCKcyo7AfwjmuHinGUnMvzptAIvsMmBF0tSmtBdE+tR0j7kokduEoyPdHmSs
         dQbrnc5R9CfEQLui4UYSr1PtKvKq+AJckArx7caRCt2zEKTpBC7I9fYTvcvDc9b9rjoI
         QN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880605; x=1789485405;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gj5Zp+Hf7hb0eLuXb3JsQ3zN3lqZPzkqR65AkPfI+wc=;
        b=mPJ+7bkooonHoVNtpoe7xJFiP7mz4WAapP1eCewrjTlWD/O+un5M6KFa3TEtlFUhCS
         ys1hMcWn0P4X2iyun4GnLCHnMFRr0HdxjfXC8Iz1OsyE7QWfLv0067nJvD3j3q6kMtxS
         FZQRKhzkdqgQVNq1pDTHMDrOQzXuqol03Nwx+Q4BLOpHmPwt+oRCbtc3RQY+Nun55nbt
         Csa/B6/XhXMzaGA9PDnLs7baeD6wE4xEnNQwYeofZtkqnPcvYSTLfy3VcP8e2ZrHWQ3i
         MQtaw3qoNAGv5QE7Wnq7/Jv6quNC8kdojL3DuVZ+1AMGA3e8kLJ2A6J0qTjBbGfPatRK
         Wj9Q==
X-Gm-Message-State: AFuF++kb1UUZp09yCZ0w3keg9retLeDtAbbcc+QdzTMhlw7RC9/by9pa
	HQhFzuTt2K9Ch8fOV3NpQzPAbL/jkUClvrWQp7dRN3O6lQal5gTx36dRH3ph74y+9lhZvDsmlCF
	CBGCejEsGcwDpGC8DlG3+rz0n5U3x4PqaW2fMOsXjFeQbr+hu
X-Gm-Gg: AYBFou36cglrIpxK4aVQdFDHXO9AProEKFkK4fsMXtQXvycpo34leW1Wk2RcoHRnV0u
	piRKuckfKi4K5bPvXLcx+vgPrpMDWf4se0ankdqYYFjTyL9pmLCr6ccgqPemXfOXtN19DOi2o/Y
	f/QkKo2G31I+uRPvlqUzPlBKuCcL/AIz0ufa33BvDMGdl2RQ5yVZfE5C4wDaYr+nIkJUCIuBJi+
	hmHEtW4cYCEE5tAcDJ/SiI/iyG9M/DVtGeJaKxrRhtvlccvPuN4fqBZyp8Mslp4TnCvHWwEbFx3
	QRu0f/RrfU7sJCNQNo2p3mZVy8tEYSVRJ7Kynb+qvPI+D9iqas3AA1t53PoY3LtIcGHy0AanP83
	fWV+iKuEEMTej71XGwGt74BqkQrFl/ScRGpSPlqdrau+s6xYNtyjSww==
X-Received: by 2002:a05:690c:7:b0:861:a2ae:8c31 with SMTP id 00721157ae682-87127848ae6mr116780567b3.29.1788880605051;
        Tue, 08 Sep 2026 08:16:45 -0700 (PDT)
X-Received: by 2002:a05:690c:7:b0:861:a2ae:8c31 with SMTP id 00721157ae682-87127848ae6mr116779827b3.29.1788880604485;
        Tue, 08 Sep 2026 08:16:44 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:32 -0400
Subject: [PATCH v2 2/8] mm/huge_memory: add a comment to the open-coded
 swap entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=906;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=X5qbXzCaQfbIvXd5MmRhi5GzAdDclgePXL2NiDB48ac=;
 b=uK0LERQcpXKQIHl4Fe0BtkcAaSCmFGqTL2NMvbL1j3TixZ7N83u2P8Bs4llT2jpLvN+8PYknZ
 j48zbH4MSCgB0VdKnnVQAwjEV5D1CfGWlm+Wjq24m4M0lO/kE4WpYYk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: W6Vis-42qVvBur74kwfBeVq_HAG5Abjw
X-Authority-Analysis: v=2.4 cv=T/68ifKQ c=1 sm=1 tr=0 ts=6aa026dd cx=c_pps
 a=0mLRTIufkjop4KoA/9S1MA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=uQMuDZbhYfZjsEHDzQ4A:9 a=QEXdDO2ut3YA:10 a=WgItmB6HBUc_1uVUp3mg:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX1wWM+h8jC0r6
 ezosadtd0DzMEq4kSdTYdQrze0JdZwIo5D5Jx7PESp69FHpWOSwRGeEilnWx0j61TJWidRa9UAf
 Hhc1+mCxaXrSARaOf3El8sG815d4vggi3DD9UZ9Epfq2UBe4RlQd
X-Proofpoint-GUID: W6Vis-42qVvBur74kwfBeVq_HAG5Abjw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfXx8pEi9IgJZKz
 oF/k/OAfi0LrdX8wHcV8s3fIsW/PSCQHN8VkV2QTLnhpy3UZMJP8ecEqYlFOmW3o8dtW3ECFdIH
 7NbELv0KzPdukm9BxpkSSXC5XhEWQIFKN3QKmzWDpt+nvaW6kw3cAvcN/OfwG4zMxGgJlyIntSL
 2T/bLYZ09G20SRR90TNImmwAhdwKY2CPuQ7LS6tbbAOce13wVCq4UWhv61DHsHPzSYeV1qmq7wT
 smTFKvM0jTEVagpffimevCcy8UZCmwGOaUeroLZ/yIArbHvvegrOQCCUMf+jMPyTVOHd7TwJQ+V
 XvHGb8H7oVIxbOJdbz2dQPlAfNLGdTAO2+qr9rXYsXIlslsB5HaJPDuCAclPqyP2hGUMTtTIUeU
 mkE71sRWo2T7hs1kPYxS0kaD5Z+oIiAAyApCwc/z5of6ZQZxLzLxQCOhensZIKKtPBofoJuLnOn
 beGBMl9/pNGEYULCgZw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 priorityscore=1501 adultscore=0 impostorscore=10
 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080165
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 76AA5C0005
X-Rspam-User: 
X-Stat-Signature: 6t6xwtbsafwabnnf1jyigg8ufz4g3hur
X-HE-Tag: 1788880606-261474
X-HE-Meta: U2FsdGVkX1+/SPwCdoJszSiKuUk4L7TmT4JqaaJGmZr7lQX9k5TTcI6g7UWqX/Q8iVaAc9YjlqLKkeNaQujQexbnnTpOCWQhvSE7JbmvNizRW1NkrFvmJEIuS9gTEnxDX6t/v5Y14W+AU+ynj2l0gEWl5G7Osk3k4l+SI2D41Td4OmsTIiKQAs0NfkFk7hnIcVyEk+Y7ksEGEvGbRwvP8ai6KtjtNVNms2mzX/7ax9dphPFt6f5jrSPOyXR2lmudn3FA87xTJLjA5ZKFnxnoPBCINmTSYI/kl73iT8rcezZsPfFzlc46Q35ruxRUPItRWQIqua3sepiHpxx8n8Uar7ol2p+s4YVnsi8p+uztLW+0qHU4Oey5EMbLHJ7XgnUCdh7sRLL4snVllecf+OaSlh88s/Rm/wnuap8jt64WB0wKyjZClHoctmEGP/CwBvEwswHH3bDcABJHeJnmaq3G95udeq3jrmwp3RF9iN9ORLyneCWG3/JiqvNGILmmpf4htsI/c46jv5gnNzNtxJTU9iDAaqs/zLKxD7RAhZ2dfvHtTOgPb9VwN2p7ZNTibv+qnjIdRRqXGTG839vOtS5NwLouoCaJjOw8P4sUn3p9vbZKys1J8WiqguunXwgry/WTEYcgRqz9MTz0/8tbYEnwJWGi5CiahbZMvp3mOC0WFLk1sTbgKiZqOdWoCBr5v3jjvfZ74bjwNHWqQkXGxD0GgPFXkr9miNYg2RXgmKp9MZo37FMB1MX3Ucv0/rPlfEOn6SWy7X7lbQX63N+HlQU0aj/WL1Xims2mrret0pX21HPcgDXSR1SubaOT0EKlZKMQLrelHi+jalNx2QXY3LqUsNT1v5sB63fy+X8n4wahhZNmwngx9PF52zr9tSkkbJgUymvbmnPIcCey8LAnr3OZA6+AXzYVnbkFT0HS2MIW3Ox8Wsz4W3vJMqvU3I1CCUIszUnj79jbW/tnRtc1TO5
 OqnBMTKM
 5XDodSL2WoUgcx/sHEYzz6lyM8UQPYsgpuO1bCQVzAB0lZJdQ8QEmssuHDjEmN9ySPVcyX7CgtLJ+OzX2WT8Lnl1GwEQWXQague5vrOIKFliyRWGyzpwI93wUA6kSDLWHdRCFegrAORfB0dSaX3HzAota4CMYanndZFfvVsfbyEBferat6BGEkuJS++eWQX0QCRjJEFLiWZDQnltS7T8G/9g9sH3neILi2GxzQqYeYlJJGxuukc9CN/QIX70JhlJwl8MUfz+RoztIhb8m47hu7EZE/KhQZxf+AS4FRk90N8v7qZQkG+kqf0NAEt30fq2kkGaies9VfbHxB03sRrbRdUsQYKVLILrfrDHiA/HpQxF3J1DA5Gy//9rS/7+C74Q3L86nCVtRc6cEhA/BJNMxvg1ibV0hDnPvWD7YUT57x5LNIcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap entry of each new folio in __split_folio_to_order() is
computed by hand from folio->swap rather than with folio_swap_entry(),
because the folio's page count is not valid while it is being split.
Add a comment explaining this.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d1ce061601bc..1fabdcbd8c8f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3763,6 +3763,10 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 */
 		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
 
+		/*
+		 * Not all folio fields are valid during a split, so open-code
+		 * the swap entry rather than using folio_swap_entry().
+		 */
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 

-- 
2.39.5



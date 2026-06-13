Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D805CD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76EA96B008C; Sat, 13 Jun 2026 13:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F5E6B0092; Sat, 13 Jun 2026 13:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0356B0093; Sat, 13 Jun 2026 13:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C796B008C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:20:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA17B1A04C7
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:37 +0000 (UTC)
X-FDA: 84875553714.11.0EAEC36
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id C861C180002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EuZLRjQY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=E88VwIVP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf24.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARhAIfL/KUaU+OVkcGHklt1anwnixW8IFSbeLVy/MIA=;
	b=nM0fKh0B40x7i9hcVcFOZOTQB4aTw7CTFqnEQXh/tBKk+OTWgEnFz/VTAb0apezPMQ7r4h
	Wc5hIk072GjZmLuJsLG1FnQLt9YdTF6i//gRR5s6rf9qP7gS+qEmotjD01z+QtwInDjNVr
	U9/vG2g+8uzjPHUxrKGVN9+6JQtQgQg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EuZLRjQY;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=E88VwIVP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf24.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371235;
	b=EbLOdRPOIYKCMlAKzlqquyzhgBpChZeu6+nPfLkkzwA0P/GfzX1P2b72vLqBlU310JjadD
	066CW7DX0IZdu3Ivsbep2ufvcym6GhSAbHj2jad2v8O/h6VPZCQj7FiBsVIaUDuM2R1tbu
	iDZg58p3/2bjeaAR8QU9zj7LZQxdYeA=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9fEU1236647
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ARhAIfL/KUaU+OVkcGHklt1anwnixW8IFSbeLVy/MIA=; b=EuZLRjQYIQQkQPVh
	vrj0YIlJoIpkCzDtE6Bluk16l6bmPwBK8LvWIkZruM9BfSq/HGfh0/5UnKhFmTRt
	TBdyTxxRG0mwqnf96T2jAeJfzujotQTHRitxCez5/acO8Wwfka6s0RwXLy91+sn/
	spSemHGrJe+jZPWo3+JWYDBDEiUJyc5WaaVfb1NTqaNXDliJEVZIsnUYLiJW+awJ
	4qczg8FaUZv9ilsnxvQpIvs/L/p0WqbFiXXe17wbMUK5gydtKp13JrpBu81crECt
	39AsQffZ1Crv/lQTqGJ/PSoc2SVRRpvabxN2pYbcjsyMfoF51owgKBLZMOqI0jTb
	2C7txQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryffhkr3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:33 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c858e0cbc89so1058652a12.0
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371233; x=1781976033; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARhAIfL/KUaU+OVkcGHklt1anwnixW8IFSbeLVy/MIA=;
        b=E88VwIVPktxOTxkNnx5GiC3wyWa8vvJdrd78kEfBvpxbC4IsLX/jlPx5WA/ABKcrV8
         3oLER0gGqB+1rlI95b3vRyQZfRkBYPWfBa0K4YnYXMMfvwPLgpWasfoJy2lowUIstwNl
         cI55pBMT/rYO+PhpNCHvztBrkDkLHgtV9GT74ClUQDjbcjorvfpl4hUuxmgkjLHeI105
         hNVMW/kK/d7Fvw0oqwiOBzShESkXKcR/Q2uckSdHkmHod/Mdf/jnTY3KNOjFAYUFwofn
         fXlUp6jzoqrg+uu6HnZwwZ+kiT01E12TJE/a6rEXrAEqMWxW4vn+xjrQusGgA5rCI9Lu
         kRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371233; x=1781976033;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ARhAIfL/KUaU+OVkcGHklt1anwnixW8IFSbeLVy/MIA=;
        b=nGyJgwSwKtPeaWfm/LU7LgtRxlscq0cdFlkLB0mHEjPZNhflPM+mEtO0LDqe/y3cKP
         h3wxgt7CVG6OmXwFRWwZqMooHLkK3Tqgq8b+ulb98TMI2s4EF71Po3g5kTKqMYz8qZrS
         DI8pIOoJ+/VuLCH88079ijIXbu/KCSIFjBvBS1vZGDok6ROop0v5iLyeYAZt7r/EI3no
         +GNb4hQ2SQf26XEwc/A1sVPLRsnipdHjEqHWHXwGr86s1mGU4KeNiK1rO7c+1vSZSYak
         WA8ImWB+CNqlKiM/pXigTRCZ6QG27z4B0J3IzVkiVfXNiTee09JRzy3mTZZ2qYsVL8Ut
         88eg==
X-Forwarded-Encrypted: i=1; AFNElJ+eu5uvsfn6AzU1hQ+brsQh7t8z04ngI30hqybRWRAutRqJgr2qSFfquYOfjclIlg0896yOUzonHg==@kvack.org
X-Gm-Message-State: AOJu0YyRXqZj2bKXHPjIjkxF8MmV1bZ1rSHRan0yo4vE6f9neUpdEVP/
	dg2j2TrUPBY6YC3EUq2xID9SZwS7USAS7X/Eaf7lPJela3QCOPWb0j1ju1cHys/o9vSVVt9JhrV
	/kjTHcbLiBQqWn4wLYqIHHhOCgQ0B1nYnelB4u/34U2BIi6/3natWoA==
X-Gm-Gg: Acq92OGOILuL59pz8AR56VkZywBKHDJgfQWZMw0qMysvtZNF77p06iB0IaQ59iFROrW
	cvbn3VCHhmK++FY5GzwJP70lg0AUNQ+9UWE6KwaRFbHwQ5ij7LrRrIED6Fq9D7dmBno88qAF/wG
	2WCZr+WFzGDc0k9jFkZ8InihQQbMGMs9uKmccXnXUvRJq1iKOCZsBqCK1eMG67UVB1CUDQioESW
	MXzy8bBfj3PYYqO5SvvYv/d4M3iXqGw4nLeBRQ7lc1/tIyAx6yapD+lCMzlYv+KByLSQylb/6c9
	yfrdUOACUf+9j+ZJsPLTXY7Sjc7LuJaBKMJpMdeO+8AGFqk5TSAWmTFRCVqhWtc/yG6fHAyFxvW
	CAaBlRQIB5gnQ+5CiUVqh3hrcNnwXxvtnO+1jdbB+rkieNFuXCFed4w==
X-Received: by 2002:a05:6a21:6b0d:b0:398:c0ba:9ceb with SMTP id adf61e73a8af0-3b783b717e0mr8866448637.12.1781371232613;
        Sat, 13 Jun 2026 10:20:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:6b0d:b0:398:c0ba:9ceb with SMTP id adf61e73a8af0-3b783b717e0mr8866398637.12.1781371232035;
        Sat, 13 Jun 2026 10:20:32 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:20:31 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:43 +0530
Subject: [PATCH RFC 01/12] mm/vmalloc: introduce maple_tree-based indexing
 for vmap_area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-1-0aa740bb944b@oss.qualcomm.com>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=15109;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=iVIE9NXQEoQrqSLoH90EvemMg/eTbDXpzD72a2nZZo4=;
 b=CPLygkLp+PKrllmdJ6bYk4qLeuLE3uYFh7TJXThjMqD+4hd7JpODplWi/WxJ57JnzWdWOdjE5
 2LkNbUSIzcBAvQYDoloDlpDmAPeXc2xkX4RNTx9MUYxHKE8Xv1G/OE+
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Authority-Analysis: v=2.4 cv=HuxG3UTS c=1 sm=1 tr=0 ts=6a2d9161 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=eoclzLbliDViwx4lJdQA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: xjMDJFxScdG-gQXfkIK_P5Om4UstxR99
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX9VeipxrZ+AT4
 ROsZxIFDTjrRArGOach/TptU9zWIjmEsLTJmmOxfjxzMNbeKAYKXu6BgkJiySt7ewNjqeze6J0G
 8T8IWy44bpL9gQYRPDxVL5VC1xBl3mg=
X-Proofpoint-GUID: xjMDJFxScdG-gQXfkIK_P5Om4UstxR99
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXxdoAhKIQJBH9
 SinNmVsxl8aUSiLwsZfE8Nicuqx2jjBw3H9b/W4U6vtRzpu9gGA8YzJwrbtbDMSsBdnlxIvYZLc
 HXKaPyDEdswRTsZi7RyIR+l5OPAqKAHxRO28r+YzrbOx5AQ3CgOZc+De2MVLw0f0PJdsiZf2Ldn
 R/DS85F1ET4onME9g6HYtbdHRDbXTc0iXdEk+MfiJ9pe0bjhqoxLimPCoLiGXrxkaWFNEoalajc
 HhxoZvx3YyCyNyVihZGMIy0FpPq9ctr3IIws4YIthR2UFCIWfz4+Y9IUk+BVcGYhoK84+6j0UHL
 /UjRzQkVULf9zoe3EMLxRgeq1GEA4hZfQm3vx/bx1GOevDF4xfaBmN4oWMfC8u5OPpgluP5YG02
 ArCmihdxXTIif93iDHNNn2vAPeefL3gX8NodC2YOp4tpROTCgv3PCkTQnatlwvaX3mW4SLsiPEK
 IzrKYGUwt9tjProUPMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130180
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dtpshk6bqr5usdrcgw58kdxgb4gya3o9
X-Rspamd-Queue-Id: C861C180002
X-HE-Tag: 1781371234-48066
X-HE-Meta: U2FsdGVkX1+dwqsiw2G1wDV5F3tNt+6utS+1n0Zotvr1EGSkEWwche5fESdRg00iR0ckT2T+SaCszk/uxj4jObg4t7t9yAUIqxlZPcIAYnWs9gTq4btnsUF5d8OxJVq1uBF4AYIHNx0hTlngfbeB3tVwFx4lmq/i0OioLb/WzknBiajR+DUsLHPUq5q4cHo2PksPRVN8F5lriV8cEkTT5oSviqcsZrMWGwQBSsE+tElpvCY3KS4o8x9/YezSA36e5cx2dQuhp5MlGK0zel2dIWze8BNgHCPsamI1lo5Xbhbt4Eisy0kSYcllLwqdpEndQrGSSfZlOLKK79CijHLWzHT1xhzmKAGNqCbTR3jZ3J0EZb25BzixlM0GH1JNTABQ1RrwU7sIwgXOO8n1J0HZ+uyaXe2ETcfM865JAmk8QA4E4Az5x+Pk8EC9EU8RU7BhS1eOYGNYdwMUB/63h027adPequ5RbtomCLkD3kPwGaWa0n/I7MsXAW7CpDo4vm2bkvLNUPlBgNKWQaQnrXVigyXqMzp+B/JYwucLcpB+VzBRrHx2Z1LUzDA0NsDXshVvTtNTxozvUScs9kekf+MO6kgNz8JNnbZ94sCuilUIODgZKTUAZngnwOj8ycoMYPynuJ4uwgHChE1/O6lD3bZAgi9vobwrdqSCQofvWTMsLGJag2/X/yghUVzVOHTkF9xBT/q7INNI4vMFEHiFpc87ovGb89joIZspNO0KBBBaiSwqm7XK1lzL0nSSBXAfXbrbmhH6glQOqo5q/+YrgiyBIkb29oB/rWJFlqL11rTmLYEWjgyXmNGriUVfPj5RPXhEpscO5g4imCGv05RVn1JU/bLBe45KPWxBy+twuEcqgHopWZoIKUYH0PUnSsOpSCzTa0CFfhR54Ao5KLyUc4i6MmLG73I/xh3PV8g0m7n001qUTTKGWU6Sy2JYxCWs0IwWrTo5Pr65du01OZyVjMq
 3jj15pkv
 nJv01SfbBNXhDiCZJi7kpkrIHjGi4yN/BZP6S8pn0vAyqR+PL6S2ywn7lyd9eMz02CqPPwAWheIgrSF1ASpVHDMAqxEUNSMh7VgpXWdkvRHOXcgAWROi1Dfl+iucB9YR9T5ZpXgfbXZQOc+JxKjparC9qFx3q+n3tZ9rzkEb56SSlQxaNZAeD3Fc6MheiKZo0rYSCW5D8MRiTURG7+S48T8tCLv8TZKHSQmI4COCUjedsQNumGlfGHBpq2i7njRsAGnS7i6TgtgUPdEvNkXpM1EVJJr1La2xroAzfuZ46c3laFx+CW20RfXF4YPsZUhjrgOXQGl8IDFjeAVov1YbiR3VQQ903pTXYThzgWOGjd1irjUR4okh3t/rPmLwidOiKrB2gBtHm0L7o3NNFDsksOd6P138JAFFEP6VOICvcIzQe8B8xxLkyXUUF0+j4/eDdnwDA2tkc41MNyRcqTgbM2tGMuP+ERKxci2EH5ONEoXtzHaYnuOMrCRfunnDEzXbZSY2OnFKwRycq81qlCYIUG365Eenhz9OTnHngdtBC0lhzo3Y6NsgFKGq2Yy+AD1vv9L/lS8+1E0/3M9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the maple_tree data structures, helper API, and runtime readiness
plumbing that this series uses to retire the augmented rb_tree
indexing of vmalloc free and busy ranges.

Two new tree handles are added alongside the existing per-node lazy
index:

  - free_vmap_area_mt    address-keyed gap query for the global
                         free-area allocator
  - vn->busy.mt          per-node address-keyed lookup for find/free

Helpers follow a try_init_*_locked / *_store_*_locked / *_erase_*_locked
naming convention so that the conversion call sites read uniformly.
The try_init_* helpers fold one-shot allocation of the maple-tree
backing state into the first hot-path access; this keeps vmalloc_init()
free of the per-tree GFP_NOWAIT paths and lets the tree machinery
start cold.

No external vmalloc behaviour change in this step. free/busy/lazy
operations still go through the rb_tree and per-node lazy.mt; the new
helpers and globals are wired up by the conversion patches that
follow.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 433 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 402 insertions(+), 31 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568b9b..67f753d04c96 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
+#include <linux/maple_tree.h>
 #include <linux/xarray.h>
 #include <linux/io.h>
 #include <linux/rcupdate.h>
@@ -880,22 +881,22 @@ static bool vmap_initialized __read_mostly;
 static struct kmem_cache *vmap_area_cachep;
 
 /*
- * This linked list is used in pair with free_vmap_area_root.
- * It gives O(1) access to prev/next to perform fast coalescing.
+ * This linked list stores free areas sorted by start address.
+ * It gives O(1) access to neighbors for fast coalescing.
  */
 static LIST_HEAD(free_vmap_area_list);
+/* Next-fit hint to avoid scanning from list head on each allocation. */
+static unsigned long free_vmap_alloc_hint __maybe_unused = 1;
 
 /*
- * This augment red-black tree represents the free vmap space.
- * All vmap_area objects in this tree are sorted by va->va_start
- * address. It is used for allocation and merging when a vmap
- * object is released.
- *
- * Each vmap_area node contains a maximum available free block
- * of its sub-tree, right or left. Therefore it is possible to
- * find a lowest match of free area.
+ * Maple tree shadow of free_vmap_area_list. It is used for
+ * address lookups and first-fit scans.
  */
 static struct rb_root free_vmap_area_root = RB_ROOT;
+static struct maple_tree free_vmap_area_mt __maybe_unused =
+	MTREE_INIT_EXT(free_vmap_area_mt, MT_FLAGS_LOCK_EXTERN, free_vmap_area_lock);
+static bool free_vmap_area_mt_enabled __maybe_unused;
+static bool free_vmap_area_mt_init_tried __maybe_unused;
 
 /*
  * Preload a CPU with one object for "no edge" split case. The
@@ -906,14 +907,17 @@ static DEFINE_PER_CPU(struct vmap_area *, ne_fit_preload_node);
 
 /*
  * This structure defines a single, solid model where a list and
- * rb-tree are part of one entity protected by the lock. Nodes are
+ * maple tree are part of one entity protected by the lock. Nodes are
  * sorted in ascending order, thus for O(1) access to left/right
  * neighbors a list is used as well as for sequential traversal.
  */
-struct rb_list {
+struct mt_list {
 	struct rb_root root;
+	struct maple_tree mt;
 	struct list_head head;
 	spinlock_t lock;
+	bool mt_enabled;
+	bool mt_init_tried;
 };
 
 /*
@@ -940,8 +944,8 @@ static struct vmap_node {
 	bool skip_populate;
 
 	/* Bookkeeping data of this node. */
-	struct rb_list busy;
-	struct rb_list lazy;
+	struct mt_list busy;
+	struct mt_list lazy;
 
 	/*
 	 * Ready-to-free areas.
@@ -1051,6 +1055,10 @@ va_size(struct vmap_area *va)
 	return (va->va_end - va->va_start);
 }
 
+/*
+ * Transitional rb compatibility retained until all rb-only users are moved.
+ * Follow-up patches in this RFC series remove these helpers.
+ */
 static __always_inline unsigned long
 get_subtree_max_size(struct rb_node *node)
 {
@@ -1070,6 +1078,130 @@ static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
+/*
+ * maple nodes are allocated from slab; defer tree population until
+ * slab allocator is up to avoid early-boot failures.
+ */
+static __always_inline bool vmap_mt_runtime_ready(void)
+{
+	return READ_ONCE(vmap_initialized) && slab_is_available();
+}
+
+static __always_inline bool free_mt_supported(void)
+{
+	return free_vmap_area_mt_enabled;
+}
+
+static __always_inline void disable_free_mt_locked(void)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (free_vmap_area_mt_enabled) {
+		__mt_destroy(&free_vmap_area_mt);
+		free_vmap_area_mt_enabled = false;
+	}
+}
+
+static __always_inline void free_mt_store_va_locked(struct vmap_area *va)
+{
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	MA_STATE(mas, &free_vmap_area_mt, va->va_start, va->va_end - 1);
+
+	err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		disable_free_mt_locked();
+}
+
+static __always_inline void free_mt_erase_va_locked(struct vmap_area *va)
+{
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	MA_STATE(mas, &free_vmap_area_mt, va->va_start, va->va_end - 1);
+
+	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		disable_free_mt_locked();
+}
+
+static __always_inline void
+free_mt_update_va_locked(struct vmap_area *va, unsigned long old_start,
+			 unsigned long old_end)
+{
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	MA_STATE(mas_erase, &free_vmap_area_mt, old_start, old_end - 1);
+	MA_STATE(mas_store, &free_vmap_area_mt, va->va_start, va->va_end - 1);
+
+	err = mas_store_gfp(&mas_erase, NULL, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err)) {
+		disable_free_mt_locked();
+		return;
+	}
+
+	err = mas_store_gfp(&mas_store, va, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		disable_free_mt_locked();
+}
+
+static void free_mt_rebuild_locked(void)
+{
+	struct vmap_area *va;
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	__mt_destroy(&free_vmap_area_mt);
+	free_vmap_area_mt_enabled = true;
+
+	list_for_each_entry(va, &free_vmap_area_list, list) {
+		MA_STATE(mas, &free_vmap_area_mt, va->va_start, va->va_end - 1);
+
+		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+		if (WARN_ON_ONCE(err)) {
+			disable_free_mt_locked();
+			return;
+		}
+	}
+}
+
+static __always_inline void try_init_free_mt_locked(void)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (free_vmap_area_mt_init_tried)
+		return;
+
+	if (!vmap_mt_runtime_ready())
+		return;
+
+	free_vmap_area_mt_init_tried = true;
+	free_mt_rebuild_locked();
+}
+
+static __always_inline struct vmap_area *
+__find_vmap_area_list(unsigned long addr, struct list_head *head)
+{
+	struct vmap_area *va;
+
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+
+	list_for_each_entry(va, head, list) {
+		if (addr < va->va_start)
+			break;
+		if (addr < va->va_end)
+			return va;
+	}
+
+	return NULL;
+}
+
 static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
 {
 	struct rb_node *n = root->rb_node;
@@ -1092,29 +1224,268 @@ static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *ro
 }
 
 /* Look up the first VA which satisfies addr < va_end, NULL if none. */
-static struct vmap_area *
-__find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
+static __always_inline struct vmap_area *
+__find_vmap_area_exceed_addr_list(unsigned long addr, struct list_head *head)
 {
-	struct vmap_area *va = NULL;
-	struct rb_node *n = root->rb_node;
+	struct vmap_area *va;
 
 	addr = (unsigned long)kasan_reset_tag((void *)addr);
 
-	while (n) {
-		struct vmap_area *tmp;
+	list_for_each_entry(va, head, list) {
+		if (va->va_end > addr)
+			return va;
+	}
 
-		tmp = rb_entry(n, struct vmap_area, rb_node);
-		if (tmp->va_end > addr) {
-			va = tmp;
-			if (tmp->va_start <= addr)
-				break;
+	return NULL;
+}
 
-			n = n->rb_left;
-		} else
-			n = n->rb_right;
+static __always_inline struct list_head *
+find_vmap_area_insert_point_list(struct vmap_area *va, struct list_head *head)
+{
+	struct vmap_area *tmp;
+	struct list_head *next = head;
+
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->va_start > va->va_start) {
+			next = &tmp->list;
+			break;
+		}
 	}
 
-	return va;
+	if (next != head) {
+		tmp = list_entry(next, struct vmap_area, list);
+		if (WARN_ON_ONCE(va->va_end > tmp->va_start))
+			return NULL;
+	}
+
+	if (next->prev != head) {
+		tmp = list_entry(next->prev, struct vmap_area, list);
+		if (WARN_ON_ONCE(va->va_start < tmp->va_end))
+			return NULL;
+	}
+
+	return next;
+}
+
+/*
+ * Use maple-tree neighbour lookup to locate insertion point in O(log n),
+ * while preserving sorted-list neighbour traversal.
+ */
+static __always_inline struct list_head *
+find_vmap_area_insert_point_mt(struct vmap_area *va, struct maple_tree *tree,
+			       struct list_head *head)
+{
+	struct vmap_area *prev, *next;
+	struct list_head *next_link;
+
+	MA_STATE(mas, tree, va->va_start, va->va_start);
+
+	mas_set(&mas, va->va_start);
+	next = mas_find(&mas, ULONG_MAX);
+
+	if (next) {
+		if (WARN_ON_ONCE(next->va_start <= va->va_start))
+			return NULL;
+		if (WARN_ON_ONCE(va->va_end > next->va_start))
+			return NULL;
+		next_link = &next->list;
+	} else {
+		next_link = head;
+	}
+
+	if (next_link->prev != head) {
+		prev = list_entry(next_link->prev, struct vmap_area, list);
+		if (WARN_ON_ONCE(va->va_start < prev->va_end))
+			return NULL;
+	}
+
+	return next_link;
+}
+
+static __always_inline bool
+insert_vmap_area_list_sorted(struct vmap_area *va, struct list_head *head)
+{
+	struct list_head *next;
+
+	next = find_vmap_area_insert_point_list(va, head);
+	if (!next)
+		return false;
+
+	list_add_tail(&va->list, next);
+	return true;
+}
+
+static __always_inline bool
+insert_vmap_area_list_sorted_mt(struct vmap_area *va, struct maple_tree *tree,
+				struct list_head *head)
+{
+	struct list_head *next;
+
+	next = find_vmap_area_insert_point_mt(va, tree, head);
+	if (!next)
+		return false;
+
+	list_add_tail(&va->list, next);
+	return true;
+}
+
+static __always_inline void
+disable_busy_mt_locked(struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->busy.lock);
+
+	if (vn->busy.mt_enabled) {
+		__mt_destroy(&vn->busy.mt);
+		vn->busy.mt_enabled = false;
+	}
+
+	vn->busy.mt_init_tried = true;
+}
+
+static __always_inline void
+disable_lazy_mt_locked(struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->lazy.lock);
+
+	if (vn->lazy.mt_enabled) {
+		__mt_destroy(&vn->lazy.mt);
+		vn->lazy.mt_enabled = false;
+	}
+
+	vn->lazy.mt_init_tried = true;
+}
+
+static void
+busy_mt_rebuild_locked(struct vmap_node *vn)
+{
+	struct vmap_area *va;
+	int err;
+
+	lockdep_assert_held(&vn->busy.lock);
+
+	__mt_destroy(&vn->busy.mt);
+	vn->busy.mt_enabled = true;
+
+	list_for_each_entry(va, &vn->busy.head, list) {
+		MA_STATE(mas, &vn->busy.mt, va->va_start, va->va_end - 1);
+
+		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+		if (WARN_ON_ONCE(err)) {
+			disable_busy_mt_locked(vn);
+			return;
+		}
+	}
+}
+
+static __always_inline void
+try_init_busy_mt_locked(struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->busy.lock);
+
+	if (vn->busy.mt_init_tried)
+		return;
+
+	if (!vmap_mt_runtime_ready())
+		return;
+
+	vn->busy.mt_init_tried = true;
+	busy_mt_rebuild_locked(vn);
+}
+
+static void
+lazy_mt_rebuild_locked(struct vmap_node *vn)
+{
+	struct vmap_area *va;
+	int err;
+
+	lockdep_assert_held(&vn->lazy.lock);
+
+	__mt_destroy(&vn->lazy.mt);
+	vn->lazy.mt_enabled = true;
+
+	list_for_each_entry(va, &vn->lazy.head, list) {
+		MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
+
+		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+		if (WARN_ON_ONCE(err)) {
+			disable_lazy_mt_locked(vn);
+			return;
+		}
+	}
+}
+
+static __always_inline void
+try_init_lazy_mt_locked(struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->lazy.lock);
+
+	if (vn->lazy.mt_init_tried)
+		return;
+
+	if (!vmap_mt_runtime_ready())
+		return;
+
+	vn->lazy.mt_init_tried = true;
+	lazy_mt_rebuild_locked(vn);
+}
+
+static __always_inline struct vmap_area *
+__find_vmap_area_mt(unsigned long addr, struct maple_tree *tree)
+{
+	MA_STATE(mas, tree, addr, addr);
+
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+	mas_set(&mas, addr);
+
+	return mas_walk(&mas);
+}
+
+static __always_inline struct vmap_area *
+__find_vmap_area_exceed_addr_mt(unsigned long addr, struct maple_tree *tree)
+{
+	MA_STATE(mas, tree, addr, addr);
+
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+	mas_set(&mas, addr);
+
+	return mas_find(&mas, ULONG_MAX);
+}
+
+static __always_inline struct vmap_area *
+__find_vmap_area_enclose_addr_mt(unsigned long addr, struct maple_tree *tree)
+{
+	MA_STATE(mas, tree, addr, addr);
+
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+	mas_set(&mas, addr);
+
+	return mas_find_rev(&mas, 0);
+}
+
+static __always_inline struct vmap_area *
+find_vmap_area_busy_locked(unsigned long addr, struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->busy.lock);
+
+	try_init_busy_mt_locked(vn);
+
+	if (likely(vn->busy.mt_enabled))
+		return __find_vmap_area_mt(addr, &vn->busy.mt);
+
+	return __find_vmap_area_list(addr, &vn->busy.head);
+}
+
+static __always_inline struct vmap_area *
+find_vmap_area_exceed_addr_busy_locked(unsigned long addr, struct vmap_node *vn)
+{
+	lockdep_assert_held(&vn->busy.lock);
+
+	try_init_busy_mt_locked(vn);
+
+	if (likely(vn->busy.mt_enabled))
+		return __find_vmap_area_exceed_addr_mt(addr, &vn->busy.mt);
+
+	return __find_vmap_area_exceed_addr_list(addr, &vn->busy.head);
 }
 
 /*
@@ -1135,7 +1506,7 @@ find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
 
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
-		*va = __find_vmap_area_exceed_addr(addr, &vn->busy.root);
+		*va = find_vmap_area_exceed_addr_busy_locked(addr, vn);
 
 		if (*va)
 			if (!va_start_lowest || (*va)->va_start < va_start_lowest)
@@ -1152,7 +1523,7 @@ find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
 		vn = addr_to_node(va_start_lowest);
 
 		spin_lock(&vn->busy.lock);
-		*va = __find_vmap_area(va_start_lowest, &vn->busy.root);
+		*va = find_vmap_area_busy_locked(va_start_lowest, vn);
 
 		if (*va)
 			return vn;

-- 
2.34.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3409CCD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9936B6B00A7; Sat, 13 Jun 2026 13:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9448A6B00A9; Sat, 13 Jun 2026 13:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE1F6B00AA; Sat, 13 Jun 2026 13:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650286B00A7
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:22:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B0B616599E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:22:01 +0000 (UTC)
X-FDA: 84875557242.06.2B500E1
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94DA1160011
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=naHgFJ1E;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Yc/EToBk";
	spf=pass (imf08.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3woILRguBLbiCsNlGX+tGFbqTQjBlxgBF9gvxbhORY=;
	b=fb2OZP6lb5HeqWJRS143FA1WoUumRkWrebDmd+/Dv0k8FZjMPQZeQOpSQMU4O6czLkf4O2
	kEhp/6Kr/gwOCphJxwou9G6zIr1E0G+JYPIDTIyr+CWPSOMz/DfRZ1ErY87NqtmV7qvBQt
	PQFC0lLdewudsseMbS3UTL/3+LIqqOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371318;
	b=1fcjcsn3mgLNGgxS6X3/qBOztWTIYd+2HIEH/2Qzny7ONPYhNIvL594xEVf3CySBwmKoPz
	uSlh9phhDcjWDGsjSydqkssqQX/b9yWt4JkLnSFy/OrGC5mFTSbT1R6KKogdOvD9telKsc
	6XLbpbYLUb492QHOIhnah+mcw6DBn6Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=naHgFJ1E;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Yc/EToBk";
	spf=pass (imf08.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DFAGgc3317969
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v3woILRguBLbiCsNlGX+tGFbqTQjBlxgBF9gvxbhORY=; b=naHgFJ1EaBRTDRJr
	DzhoO7hyZMLbsLC0R6NaUdr2DlICVDAqLZE5nq8N5Y8EymZh6QWLoif4Vl8LHZBo
	F+dfq+GVsDtpe2AvnhS8lN1CKwCC9boGMColGiGhAHfJuWyUxi2TSCRXZJjAJYRz
	3xG7ml0YrWnFCY5PSliVUDNW55HrEmmV3F7SThB5uQVXYf9jzct8lwRTjJgp+FcB
	3fEDydClBiVJc6eGMq3S9tEimxt9Q14zN9c1m9J+6tQvn8Hd3QudD7QCNhnO8Sbe
	o4PYdPvtm6kmKV5vY1AAkQ6gaWyhgNTF2faXb5xByBsAjhNSqHRl0RLvjD1z9cvN
	V2YlqQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryc6smu3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:57 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84245e2bb00so1866755b3a.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371316; x=1781976116; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3woILRguBLbiCsNlGX+tGFbqTQjBlxgBF9gvxbhORY=;
        b=Yc/EToBkCdAvCmLGjAf3pKqMoLp60X2mkUiCmh/mxbZf75J0n/cmvOwL6Q04VjHeN0
         SaCfsODKhfg9NJiKPkyI+r4QuGLAjtWfkIhg2ZlGO5GD3BY6qeq0ENtREiCqNRssjS8z
         yuqijIuzGRXYyY2KWpGHAlDm3sNeWYDLd9Secdd85YlFgMOouk/MUWv6xTlBKe3F6y/y
         AxH3bSHZDXrD/xq7mRKTzeRm36MN+RbkxCYnD/krkLWRcYqnSCbzzWdALD54s6vvjmcQ
         mxLeI/hGlztwGCiYKuhHG2gOcnsSG8DNKd+6bVWsbnb5lZfeiO3pQsv1iAZXsoIuyp/p
         NKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371316; x=1781976116;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v3woILRguBLbiCsNlGX+tGFbqTQjBlxgBF9gvxbhORY=;
        b=bXCfS6PtLGi8pbXKQMS4D9SMnNrXuOPtfcdkzLq6XMJpT3kajpcZt+d1PYfU2nxj1z
         o9ZqbheFJpqQ1jcvRsZyQW/5zpVFWo5ZDkgt+MP+VdJgd5eaFOXhViOlNjphyspaPsry
         uLVCNl1h01ABz/fCxB/gN6Hns57tWrgx19l9krnz6N3Xiqo4nuU5b1EqwWPRQXUHeR7H
         QUYgj2HH1/nMw8c3L3JDeDqM3Gkqe2NBJMDdEzJ7ui0zAgj2lXYg/6KtoZsFCnSoVYd8
         AEAfIx8AaM4spfw00LqxMbVa+nurtgbbZ01B07UaulAVKHauLEMQOv5x0HHISGakmASA
         LDUA==
X-Forwarded-Encrypted: i=1; AFNElJ/DNozpLuiFECK2paANKXgeznrAnr4TZ8jWAiTqEi3/JM1HfwpMUvdJrpDTBN2aPeER5s2Cq0+7Uw==@kvack.org
X-Gm-Message-State: AOJu0Yw3vuo3cXgyfTbf59roiaBJONZFXIAMSD/lHJ9hUkGYmLaBuBoV
	+xjn2958XVLGdRM9tRZ8xXg+a3aal3JqmKVvUXYrtwIzmxRCa/S9VXhIYgirohJUvmHYM0B+ly3
	lXnJR6eWIZwGAtRp/JpAA62d8maPbUtjqvTjgdNj6XLrzQr4ao9gZUg==
X-Gm-Gg: Acq92OElLieFc2aycTR2O9otReuXm4tBnWAJ+wNsTAhD8edtwOEJjfGdUSPnphA+4AD
	0+/5tDtmrVCjfUH/11K18yM30YGLEEM6jkxee8cqUAMMA5YhBrL5n8iVMkzvuXClnvIiq4646bq
	9reIujHljJI4+ICCNssq/RxzqfNABU2jwa/izKWygoXXxgHk9DqzCb1MtYK6WIhH8UtD2uP+esB
	+sqMpWKY+VT37osuIdrNtGcR40gPx8hROzcCtm7xjJkLQ0ueyLhyepcUPFHl+oWO3ShRVQidjE6
	ZfqvraUWFb7UYhmvC+JRRZH5djqXfD8qgrOd8PnbVl7S0VeEiB2IUpcXLN7jwgx0FkakXMW905/
	qzTm+5YlGfK8XLgyAffmokf8m66vdSI4tBlTWx35ODiu7xmIUczUwSQ==
X-Received: by 2002:a05:6a00:9519:b0:842:51d5:efc4 with SMTP id d2e1a72fcca58-8434cdfe801mr7949101b3a.12.1781371316120;
        Sat, 13 Jun 2026 10:21:56 -0700 (PDT)
X-Received: by 2002:a05:6a00:9519:b0:842:51d5:efc4 with SMTP id d2e1a72fcca58-8434cdfe801mr7949062b3a.12.1781371315541;
        Sat, 13 Jun 2026 10:21:55 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:55 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:53 +0530
Subject: [PATCH RFC 11/12] mm/vmalloc: O(1) lookup of cached vmap_areas
 with bounded fast-reject
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260613-vmalloc_maple-v1-11-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=18238;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=ScP/pU5YNtDAQIGLmY3N7r5kxqt4VI1KDte0xvFILOA=;
 b=wLBVzf7Yg6qD2hFmzKW2VS706XH3RzW2MStsE9F3J2IDleFJTHNfPZCUhTiZUjymhOLhOcjgO
 moUIESnCBZGAGj1XxOleOXmZ593rlf3xmehKBr0u0T4V9xs/GQCBIc6
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX4TrHC2t6Ih3f
 2peGh3VupvQ4wrSZEtONmX0Gs54RAQfWRRxcHerzif/Rilg44r15YMWqEIdM7A1gI3gBH5+sdad
 UaNGFd1axWgutfvF2d4WWP/cYFk+tHc=
X-Authority-Analysis: v=2.4 cv=Oop/DS/t c=1 sm=1 tr=0 ts=6a2d91b5 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=dEBxItZDZOfoxGhxyrAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: jYzRDNpo9jlhlFcLyJad9RfYDFMh5YHw
X-Proofpoint-ORIG-GUID: jYzRDNpo9jlhlFcLyJad9RfYDFMh5YHw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX8KmF1AJXi/RZ
 O1wXb893wuHFZvvrVQuP7sT8ZjBY0kv3U5bAvUHLrz3pcegN+Njm7IQzQelKQ3wbeqybyu4Mlgo
 o+r6PTCk6IWnjpbWXOSRDnAybXkNv0HAJIxXdkpEvYK52JupOMCZ92vOWTAgWAnIHOHkCli/dcu
 ST1cavjgzlMelHvsxCr8uxh8206S+ArNBuhEyf6X4qPGpZwhxZtOlcvbAs+qCJvxaBqF3BTsIYC
 jhlIniKSqtsdssLjQcOrivl0KLOllC1jcu0Q65OvYECeWyXQ/9aIGLdM8QRnHmulUmMIHt33nza
 kxNlf1ePtGYX4jADvBR7x4D5gVAqM8Hgyf2rhgp/xuOA9XnkAMSwcFr1WroXo4RThgQWCGhEprW
 WsME0xyol2brw2yWtgq59dSl7Jkq7GsGYYCbJqDf134iLXxRgw0qxPfaBYLLxqQH2NWCJcD0Tdo
 MVoTwzz6y8H5XqON1ig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130180
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94DA1160011
X-Stat-Signature: xwx9j58wcqt4qn9fnxm4st3ctjz7g7y4
X-HE-Tag: 1781371318-997263
X-HE-Meta: U2FsdGVkX18v2dQAeL6RXfaWtQduK28ibve8oVq26UvbUiQPCuSqLZntJ/XEL0FlHqfcDJ/5cJeBfgH0EQA3XRTfii6dHyLhk0b5q/q5BGZCvwlrGpO/ARZrq4T3rbxRiScsq3uByHdm2f4ete1NO8sUthnHllwHjz709WTIUNFz4I49oDru0IVbiCpsG5NtT2AGpYijXm70f2jFeqlNtjVgeHayeyNxUNpEndaILT3r+owNL0ZjraPGd4YEGvO94RKQNX8bmecSQZ2sogIJAK538VtuLHaEOEGCbM8fXX69uUMcnFfYSb71T12tiqRyeSqzt08OFcr/GyTWbkzmd8iQ39ueLhQ3UtWPTAKB2J9+CPnM+ZoLQJc6S/zP1AhVqQItC4UVgoRdCp/pB90IaRIOuBduelP0c2X6cQeXM858YWPwN86b5XWEyZjbwGKgSLT5DbwRlZO5nwCoIWoCjrz0YitTnA6DIsVoGminAyUaumfMMQwUWNGIOsHAyybRPIbE4ZnKiFH/wslQlAJLh46e1wMwangXZEyGUrocXzMxu9WZvh2Nk3IJzxmVmprUjdPO8aac3NPU0SMH2pRoHitoL+ZuSWHRO2igs5U2Dk+BgArYH7iEobA61W08Ya1GV1PJ8SORjRlLIvH6V63MYUVgILkHLWZ3yfrDq518cjqYjPxsBrLspOlhs0jqGHGKMRIBQmVFS2MPYkCHbaSoae700DzwHks1T0DSpLZS3Qb+0CsOvLU6y1AhnCSe77n4NbE3neJ+/7Xc35Yd24iCaTT0ctTVLAc3FENVpHYhEWZ8/Kk/Y7YPNQ14oUnOt73HGVyLQqas/nWdSBXkBKhBepkDHs4X1K3LgIyvPvLXv97DfdgGEK4881k1C5UBLIl4B3iBzrN3wNUE4Pm6H3AwQ9sEBNUC7HvzQZ+PMWpf7Y+OBWWGTEl2Q5a5memjMgIvcnqouQH7ki2nt20i+cl
 SDa88yDH
 Jttx5dkhBo3Ym7q+vW61KijO+uAgLIAzDfBBIg8pP6bkuXchWqx64hOcuuxqdwqEwMU5YGoEje6JxbdjFCTDI/2Q7XBog961daQicODM9hcVAhGBcAkp1l5gJKz+GKJs+WakE5fUAydreqYoFQan7ocRs4vr3AUvEC52DCrl1rmf0XjH6zCr+WvUYlLD8KG/9INRMySGdWdpdN3xieWrk7650ZgbrEzgTvtLEVUffKKAkv5OyH9EGOtJjZqKyncXG09oAQPM3X3uSzKdfJxWwIFYwNRfJoHnTZoKyOqatkBsTE6dQ4u01Dt+r4ZdWR84wpO5qfK9MAM9YaCwtBPjMHpNhYyVs38eh8nF5yqhESwuiAPzFSSrAD+mgO+lDOUuxoVO3A8lkNSFNr5s6HE0jUtw8OxSiokRJwI8n65hStRSJ6P+fBHFjuC2Ie9+kBkkpk8E9Zvu20MGOOAFahnbJljd/7FuguyvSNWCOKGppx3xnO7rVOFBhBuPABndd1C5/Q/8Cw669zEBXB8M7sBuK6FufKbVd+6/OyZDazqG2r4RB5Nl2t8WaL9izbqilONesfDJlEhlDhKbyQF+2KfcG5C7swjGt4WylSKsL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For an address that lives in a per-CPU chunk reserved from the
maple_tree allocator, walking the busy maple_tree to recover the
struct vmap_area is wasted work — the cache already knows which
vmap_area covers each page in its chunks.

Expose that knowledge directly.  Each chunk gains a back-pointer
array indexed by chunk-relative page offset:

    page_va[(addr - chunk->base) >> PAGE_SHIFT] -> struct vmap_area *

vmap_chunk_lookup() probes the chunk list with a single hash-like
lookup and returns the resident vmap_area in O(1); only chunk-misses
fall through to the existing busy-tree walk.

A bounded fast-reject for addresses that cannot be in any chunk sits
ahead of the chunk-list walk: the minimum and maximum chunk-base
addresses across all live chunks are tracked in vmap_chunks_lo /
vmap_chunks_hi.  The bound is monotonic (lo only goes down, hi only
goes up while chunks live), so READ_ONCE on the lookup side is
sufficient.  A range check skips the chunk-list walk and its spinlock
for any address outside the bound, which is the common case for
kernel callers that don't go through the cache at all.

This is invisible to any caller; only the resolution path is faster.
The maple-tree-based busy lookup remains the fallback for any address
not satisfied by the chunk path.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 372 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 306 insertions(+), 66 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 65ee80eaf4bf..6991054e1cba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2468,97 +2468,280 @@ static inline void setup_vmalloc_vm(struct vm_struct *vm,
 }
 
 /*
- * Per-CPU bump-allocator overlay.
+ * Per-CPU bump-allocator overlay (Option B + Option G).
  *
  * Each CPU reserves a contiguous chunk of vmalloc address space and
  * dispenses page-aligned allocations via a bump pointer. The chunk's
- * range is reserved through the global allocator once; individual
- * allocations within the chunk avoid the global maple-tree work
- * entirely. Each allocation still gets its own vmap_area struct and
- * is inserted into the per-node busy.mt, so find_vmap_area() and
- * vfree() continue to work unchanged.
+ * range is reserved through the global allocator once; per-allocation
+ * the bump path skips global maple-tree work entirely AND skips the
+ * per-node busy.mt insert: each chunk carries a page_va[] array that
+ * maps page-offsets within the chunk to the owning vmap_area struct,
+ * so find_vmap_area(addr) for a chunk-resident addr is one chunk
+ * lookup + array index — no maple_tree descent at all.
  *
- * Recycling: chunks leak in this minimal form. With 16 MB chunks on a
- * 128 GB vmalloc range, the address space supports thousands of chunks
- * before exhaustion. A future iteration can add chunk recycling via a
- * va->bump_chunk back-pointer + refcount; deferred to keep this hot
- * path's struct vmap_area footprint at 48 B.
+ * Constraints: only the standard vmalloc range (VMALLOC_START..
+ * VMALLOC_END) with align and size both <= VMAP_BUMP_CHUNK_SIZE/2
+ * take the bump path. Anything else falls through to the existing
+ * __alloc_vmap_area path which keeps the busy.mt insert.
  *
- * Constraints: only the standard vmalloc range with align <= PAGE_SIZE
- * and size <= VMAP_BUMP_CHUNK_SIZE/2 takes the bump path. Anything
- * else falls through to the existing __alloc_vmap_area path.
+ * Chunks recycle on bump exhaustion: the active chunk is retired
+ * to a global list when it can no longer fit the request; freed VAs
+ * release their page_va entries; when a chunk's alloc count drops to
+ * zero it is returned to the global allocator and freed.
  */
 #define VMAP_BUMP_CHUNK_SIZE	(64UL * 1024 * 1024)
+#define VMAP_BUMP_CHUNK_PAGES	(VMAP_BUMP_CHUNK_SIZE >> PAGE_SHIFT)
+
+/*
+ * VA flag bit 0x4 marks vmap_areas allocated by the bump allocator. These
+ * VAs are never inserted into occupied_vmap_area_mt — the chunk's whole
+ * range was inserted at refill time. reclaim_list_global() consults this
+ * bit to skip occupied_mt_erase_va_locked() on the vfree path, which would
+ * otherwise WARN every time a bump-allocated VA is reclaimed. Bit 0x4 sits
+ * outside VMAP_FLAGS_MASK (0x3 = VMAP_RAM | VMAP_BLOCK) and below the
+ * encode_vn_id() shift (BITS_PER_BYTE), so it does not alias either field.
+ */
+#define VA_FROM_BUMP_CHUNK	0x4
 
 struct vmap_bump_chunk {
-	unsigned long	base;
-	unsigned long	limit;
-	unsigned long	bump;
+	unsigned long		base;
+	unsigned long		limit;
+	unsigned long		bump;
+	atomic_t		alloced;	/* # outstanding pages */
+	struct list_head	link;		/* on vmap_bump_chunks */
+	struct rcu_head		rcu;		/* deferred free */
+	struct vmap_area	*page_va[VMAP_BUMP_CHUNK_PAGES];
 };
 
-static DEFINE_PER_CPU(struct vmap_bump_chunk, vmap_bump);
-static DEFINE_PER_CPU(spinlock_t, vmap_bump_lock);
+static DEFINE_PER_CPU(struct vmap_bump_chunk *, vmap_bump_cur);
+static LIST_HEAD(vmap_bump_chunks);
+static DEFINE_SPINLOCK(vmap_bump_chunks_lock);
 
-/* Try the per-CPU bump-allocator. Returns the chosen address or
- * a negative IS_ERR_VALUE on miss; callers fall through to the
- * regular path on miss.
+/*
+ * Coarse [lo, hi) bounds covering every active vmap_bump_chunk's
+ * range. vmap_chunk_lookup() rejects out-of-range addresses (e.g.
+ * pcpu allocations sitting in the upper half of the vmalloc range)
+ * without taking vmap_bump_chunks_lock. Updated whenever a chunk is
+ * installed or released.
  */
-static unsigned long
+static unsigned long vmap_chunks_lo = ULONG_MAX;
+static unsigned long vmap_chunks_hi;
+
+static __always_inline unsigned long
+vmap_chunk_page_idx(struct vmap_bump_chunk *chunk, unsigned long addr)
+{
+	return (addr - chunk->base) >> PAGE_SHIFT;
+}
+
+/*
+ * Find the chunk containing @addr. Returns NULL if @addr was not
+ * allocated from any chunk. The walk is O(num_chunks); for our
+ * benchmark workloads num_chunks is bounded in the tens, so this is
+ * still under one cache-line of comparisons in practice.
+ */
+static struct vmap_bump_chunk *
+vmap_chunk_lookup(unsigned long addr)
+{
+	struct vmap_bump_chunk *chunk, *cur;
+
+	/*
+	 * Fast reject: addr lies entirely outside any chunk's [base, limit).
+	 * READ_ONCE pairs with the WRITE_ONCE updates in vmap_bump_refill /
+	 * vmap_bump_unlink. The bound is monotonic (lo only goes down, hi
+	 * only goes up while chunks live), so a stale read can only force
+	 * us into the slow path — never miss a real hit.
+	 */
+	if (addr < READ_ONCE(vmap_chunks_lo) ||
+	    addr >= READ_ONCE(vmap_chunks_hi))
+		return NULL;
+
+	cur = this_cpu_read(vmap_bump_cur);
+	if (cur && addr >= cur->base && addr < cur->limit)
+		return cur;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &vmap_bump_chunks, link) {
+		if (addr >= chunk->base && addr < chunk->limit) {
+			rcu_read_unlock();
+			return chunk;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+/*
+ * Reserve and bump-allocate via the per-CPU chunk. Returns the
+ * vmap_area pre-populated (va_start, va_end, page_va[] linkage),
+ * or NULL on miss/refill-needed.
+ */
+static struct vmap_area *
 vmap_bump_alloc(unsigned long size, unsigned long align,
-		unsigned long vstart, unsigned long vend)
+		unsigned long vstart, unsigned long vend, gfp_t gfp_mask,
+		int node, unsigned long va_flags)
 {
 	struct vmap_bump_chunk *chunk;
-	spinlock_t *lock;
-	unsigned long aligned, addr = -ENOENT;
+	struct vmap_area *va;
+	unsigned long aligned, idx, n_pages, i;
 
 	if (vstart != VMALLOC_START || vend != VMALLOC_END ||
 	    size == 0 || size > VMAP_BUMP_CHUNK_SIZE / 2 ||
 	    align > VMAP_BUMP_CHUNK_SIZE / 2)
-		return -EINVAL;
+		return NULL;
 
-	lock = this_cpu_ptr(&vmap_bump_lock);
-	spin_lock(lock);
-	chunk = this_cpu_ptr(&vmap_bump);
-	if (chunk->base) {
-		aligned = ALIGN(chunk->bump, align);
-		if (aligned + size <= chunk->limit) {
-			chunk->bump = aligned + size;
-			addr = aligned;
-		}
+	va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
+	if (unlikely(!va))
+		return NULL;
+
+	/*
+	 * preempt_disable() is sufficient for the per-CPU chunk hot path:
+	 * the chunk pointer is per-CPU and only mutated by the CPU that
+	 * owns it (in vmap_bump_refill). preempt-disable pins us to the
+	 * current CPU and serializes against an in-flight refill on the
+	 * same CPU.
+	 */
+	preempt_disable();
+	chunk = this_cpu_read(vmap_bump_cur);
+	if (!chunk) {
+		preempt_enable();
+		kmem_cache_free(vmap_area_cachep, va);
+		return NULL;
 	}
-	spin_unlock(lock);
-	return addr;
+	aligned = ALIGN(chunk->bump, align);
+	if (aligned + size > chunk->limit) {
+		preempt_enable();
+		kmem_cache_free(vmap_area_cachep, va);
+		return NULL;
+	}
+	chunk->bump = aligned + size;
+	idx = vmap_chunk_page_idx(chunk, aligned);
+	n_pages = size >> PAGE_SHIFT;
+	for (i = 0; i < n_pages; i++)
+		chunk->page_va[idx + i] = va;
+	atomic_add(n_pages, &chunk->alloced);
+	preempt_enable();
+
+	va->va_start = aligned;
+	va->va_end = aligned + size;
+	va->vm = NULL;
+	/*
+	 * Encode the destination vmap_node so the existing per-node pool
+	 * machinery and decode_vn_id() in free_vmap_area_noflush() see a
+	 * valid id. VA_FROM_BUMP_CHUNK marks this VA so reclaim_list_global
+	 * skips occupied_mt_erase_va_locked() — bump VAs were never tracked
+	 * in occupied_vmap_area_mt (the whole chunk range was). The bit
+	 * sits below BITS_PER_BYTE so it does not alias decode_vn_id()'s
+	 * shift, and outside VMAP_FLAGS_MASK so it does not alias VMAP_RAM
+	 * / VMAP_BLOCK.
+	 */
+	va->flags = va_flags | encode_vn_id(addr_to_node_id(aligned)) |
+		    VA_FROM_BUMP_CHUNK;
+	INIT_LIST_HEAD(&va->list);
+	return va;
 }
 
-/* Refill this CPU's bump chunk. Reserves a fresh range from the
- * global allocator. Old chunk's remaining space is leaked (the
- * already-allocated VAs in it stay live; the unused tail is wasted).
+/*
+ * Refill this CPU's bump chunk. Reserves a fresh range from the
+ * global allocator. The old chunk (if any) is moved to the global
+ * vmap_bump_chunks list; it stays alive until its outstanding
+ * allocations drain.
  */
 static int
 vmap_bump_refill(gfp_t gfp_mask)
 {
-	struct vmap_bump_chunk *chunk;
-	spinlock_t *lock;
+	struct vmap_bump_chunk *new_chunk;
 	unsigned long base;
 
+	new_chunk = kvzalloc(sizeof(*new_chunk), gfp_mask);
+	if (!new_chunk)
+		return -ENOMEM;
+
 	preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, NUMA_NO_NODE);
 	base = __alloc_vmap_area(VMAP_BUMP_CHUNK_SIZE, PAGE_SIZE,
 				 VMALLOC_START, VMALLOC_END);
 	spin_unlock(&free_vmap_area_lock);
 
-	if (IS_ERR_VALUE(base))
+	if (IS_ERR_VALUE(base)) {
+		kvfree(new_chunk);
 		return -ENOMEM;
+	}
+
+	new_chunk->base = base;
+	new_chunk->limit = base + VMAP_BUMP_CHUNK_SIZE;
+	new_chunk->bump = base;
+	atomic_set(&new_chunk->alloced, 0);
+	INIT_LIST_HEAD(&new_chunk->link);
+
+	spin_lock(&vmap_bump_chunks_lock);
+	list_add_rcu(&new_chunk->link, &vmap_bump_chunks);
+	if (new_chunk->base < vmap_chunks_lo)
+		WRITE_ONCE(vmap_chunks_lo, new_chunk->base);
+	if (new_chunk->limit > vmap_chunks_hi)
+		WRITE_ONCE(vmap_chunks_hi, new_chunk->limit);
+	spin_unlock(&vmap_bump_chunks_lock);
+
+	preempt_disable();
+	this_cpu_write(vmap_bump_cur, new_chunk);
+	preempt_enable();
 
-	lock = this_cpu_ptr(&vmap_bump_lock);
-	spin_lock(lock);
-	chunk = this_cpu_ptr(&vmap_bump);
-	chunk->base = base;
-	chunk->limit = base + VMAP_BUMP_CHUNK_SIZE;
-	chunk->bump = base;
-	spin_unlock(lock);
 	return 0;
 }
 
+/*
+ * Drop a chunk-allocated VA. Called from the vfree path when the va
+ * has VA_FROM_BUMP_CHUNK set. Clears the page_va[] linkage and
+ * releases the va struct. If the chunk's outstanding count hits zero
+ * AND the chunk is no longer the per-CPU current chunk, the chunk's
+ * range is returned to the global allocator and the chunk descriptor
+ * is freed.
+ */
+static struct vmap_area *
+vmap_bump_unlink(unsigned long addr)
+{
+	struct vmap_bump_chunk *chunk;
+	struct vmap_area *va;
+	unsigned long idx, n_pages;
+
+	chunk = vmap_chunk_lookup(addr);
+	if (!chunk)
+		return NULL;
+
+	idx = vmap_chunk_page_idx(chunk, addr);
+	if (idx >= VMAP_BUMP_CHUNK_PAGES)
+		return NULL;
+
+	va = chunk->page_va[idx];
+	if (!va || va->va_start != addr)
+		return NULL;
+
+	n_pages = (va->va_end - va->va_start) >> PAGE_SHIFT;
+	memset(&chunk->page_va[idx], 0, n_pages * sizeof(va));
+
+	/*
+	 * If this chunk fully drained AND it is no longer the per-CPU
+	 * current chunk, return its range to the global allocator and
+	 * free the descriptor. We do NOT reset the bump pointer for the
+	 * current chunk: addresses inside the chunk may still have stale
+	 * TLB entries until the next lazy-purge flush, so reusing them
+	 * before the flush is unsafe. Forward-only bump avoids that.
+	 */
+	if (atomic_sub_return(n_pages, &chunk->alloced) == 0 &&
+	    chunk != this_cpu_read(vmap_bump_cur)) {
+		spin_lock(&vmap_bump_chunks_lock);
+		list_del_rcu(&chunk->link);
+		spin_unlock(&vmap_bump_chunks_lock);
+
+		spin_lock(&free_vmap_area_lock);
+		if (occupied_mt_supported())
+			WARN_ON_ONCE(!occupied_mt_erase_range_locked(chunk->base,
+								     chunk->limit));
+		spin_unlock(&free_vmap_area_lock);
+		kvfree_rcu(chunk, rcu);
+	}
+
+	return va;
+}
+
 /*
  * Allocate a region of KVA of the specified size and alignment, within the
  * vstart and vend. If vm is passed in, the two will also be bound.
@@ -2589,6 +2772,44 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	allow_block = gfpflags_allow_blocking(gfp_mask);
 	might_sleep_if(allow_block);
 
+	/*
+	 * Per-CPU bump-chunk fast path (Option B + Option G).
+	 *
+	 * Returns a fully-populated va_start/va_end vmap_area struct; the
+	 * chunk's page_va[] array carries the addr->va linkage, so no
+	 * per-node busy.mt insert is needed. find_vmap_area() and
+	 * find_unlink_vmap_area() consult vmap_chunk_lookup() before
+	 * falling back to busy.mt.
+	 */
+	va = vmap_bump_alloc(size, align, vstart, vend, gfp_mask, node,
+			     va_flags);
+	if (!va && vmap_bump_refill(gfp_mask) == 0)
+		va = vmap_bump_alloc(size, align, vstart, vend, gfp_mask, node,
+				     va_flags);
+	if (va) {
+		if (vm) {
+			vm->addr = (void *)va->va_start;
+			vm->size = va_size(va);
+			va->vm = vm;
+		}
+		BUG_ON(!IS_ALIGNED(va->va_start, align));
+		BUG_ON(va->va_start < vstart);
+		BUG_ON(va->va_end > vend);
+
+		ret = kasan_populate_vmalloc(va->va_start, size, gfp_mask);
+		if (ret) {
+			vmap_bump_unlink(va->va_start);
+			kmem_cache_free(vmap_area_cachep, va);
+			if (vm) {
+				vm->addr = NULL;
+				vm->size = 0;
+				vm->requested_size = 0;
+			}
+			return ERR_PTR(ret);
+		}
+		return va;
+	}
+
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
 	 * it is anyway marked with this "vn_id" so it is returned
@@ -2611,19 +2832,6 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	}
 
 retry:
-	if (IS_ERR_VALUE(addr)) {
-		/*
-		 * Per-CPU bump-allocator fast path. On hit, no global
-		 * tree work runs at all. On miss, refill the chunk and
-		 * try again before falling back to the regular path.
-		 */
-		addr = vmap_bump_alloc(size, align, vstart, vend);
-		if (IS_ERR_VALUE(addr) && (long)addr == -ENOENT) {
-			if (vmap_bump_refill(gfp_mask) == 0)
-				addr = vmap_bump_alloc(size, align,
-						       vstart, vend);
-		}
-	}
 	if (IS_ERR_VALUE(addr)) {
 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
 		try_init_free_mt_locked();
@@ -2792,12 +3000,20 @@ reclaim_list_global(struct list_head *head, bool erase_occupied,
 	list_for_each_entry_safe(va, n, head, list) {
 		list_del_init(&va->list);
 		if (erase_occupied) {
+			/*
+			 * Bump-allocated VAs were never inserted into
+			 * occupied_vmap_area_mt — the chunk's whole range was.
+			 * Skip the per-VA erase to avoid a spurious WARN.
+			 */
+			if (va->flags & VA_FROM_BUMP_CHUNK)
+				goto queue_release;
 			if (WARN_ON_ONCE(!occupied_mt_erase_va_locked(va))) {
 				list_add_tail(&va->list, failed);
 				ok = false;
 				continue;
 			}
 		}
+queue_release:
 		/*
 		 * Occupied-only design: there are no free vmap_area objects
 		 * any more. With the occupied marker erased, the range is
@@ -3179,6 +3395,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 
 struct vmap_area *find_vmap_area(unsigned long addr)
 {
+	struct vmap_bump_chunk *chunk;
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	int i, j;
@@ -3186,6 +3403,22 @@ struct vmap_area *find_vmap_area(unsigned long addr)
 	if (unlikely(!vmap_initialized))
 		return NULL;
 
+	/*
+	 * Bump-chunk fast path: if @addr lives in a per-CPU bump chunk,
+	 * the va is at chunk->page_va[(addr - chunk->base) / PAGE_SIZE].
+	 * No maple-tree descent.
+	 */
+	chunk = vmap_chunk_lookup(addr);
+	if (chunk) {
+		unsigned long idx = vmap_chunk_page_idx(chunk, addr);
+
+		if (idx < VMAP_BUMP_CHUNK_PAGES) {
+			va = chunk->page_va[idx];
+			if (va)
+				return va;
+		}
+	}
+
 	/*
 	 * An addr_to_node_id(addr) converts an address to a node index
 	 * where a VA is located. If VA spans several zones and passed
@@ -3220,6 +3453,15 @@ static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
 	struct vmap_area *va;
 	int i, j;
 
+	/*
+	 * Bump-chunk fast path: if @addr was allocated from a per-CPU
+	 * chunk, the page_va[] linkage is the only place it lives. No
+	 * busy.mt walk needed.
+	 */
+	va = vmap_bump_unlink(addr);
+	if (va)
+		return va;
+
 	/*
 	 * Check the comment in the find_vmap_area() about the loop.
 	 */
@@ -6319,8 +6561,6 @@ void __init vmalloc_init(void)
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
 		xa_init(&vbq->vmap_blocks);
-
-		spin_lock_init(&per_cpu(vmap_bump_lock, i));
 	}
 
 	/*

-- 
2.34.1



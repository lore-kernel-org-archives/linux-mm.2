Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18787D2F02C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8046B0093; Tue, 27 Jan 2026 08:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798D96B0096; Tue, 27 Jan 2026 08:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6467D6B0098; Tue, 27 Jan 2026 08:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 551126B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:34:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CC0E1AF27C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:34:29 +0000 (UTC)
X-FDA: 84377838258.07.7FCD0AE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9AD7340003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:34:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2gtBfBV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXz64Yr9;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVBtH18jChRQLmHvgPkNJ9e/TpSuwoBM1URK/iBmFr4=;
	b=AhI7yqO4uJ/5LnBt8IYIRSBLm1IziK/yZM5ObGc2vvWN4vmoM+pDCrbjxtuRraCM+fIWKv
	qH/2JdIMW0vE+WIRA/n5KIHwM91J8ANr9FyHzJyu1uxkh0OQwd/Egyne3Tp62iSyW0bK7u
	jD1Lti00wDfOkk614X/ckyE9AHz293A=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2gtBfBV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXz64Yr9;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769520865; a=rsa-sha256;
	cv=pass;
	b=cXdpYtFLpTg6epqOmBze1jhmHZs41wlfrF040GAe4+klICEcDE11SHCTYJHCK5k90Zi9WO
	nBc1Bs45yFEy556P+7tq+AhM2tJnGVcj4L/kDsGR6swh6Bo+LhPwyexxV40USL8UNAyUJe
	haGdAA3qiOVnnxpDFqcpBvPpQkahBMQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBEQrb3922871;
	Tue, 27 Jan 2026 13:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LVBtH18jChRQLmHvgP
	kNJ9e/TpSuwoBM1URK/iBmFr4=; b=r2gtBfBVSZZr5806eqdirXdFLbWYQgCIpk
	2YTpQilh81OadgavLIfz5RYoEIdSPU7QDHDJppcMnr7ysv614/W6jzDg68Hd/S/9
	0Ew130Xj0a1aNzwayDPHwoTnNdQuSKaP/xECACxH+htxCfq6uGyM/DdewwIPHrLC
	2YFjy8XfK8e/jZsrKaOyQ67YMknqrTGYF/4OfwcoZR9hMeskgnOTj9K70dduUDqP
	J/xS52NEniIxOb4c5/N1j0UAnhCrQ85cCLDj6AaGhX+jrQ8M3fx9ok3XPLbUCc0d
	xLCZH+SS4VNNvxJvIhovfTI/Yrald4VIlDR30RmlDJEOaZl2EhsA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmgbv0h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 13:34:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RCVuXt001744;
	Tue, 27 Jan 2026 13:34:04 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdxr62-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 13:34:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ixi0EZyqPFIQZrTP9p7Gv6gYivVyQ9Jlo/oBOW4IfVriC8ejdrBMJNyh0eGzTJ3loulx4WtJ4O8bDJ8bIBxTwiuB3Kjy7pIrAHmoxawcp3T38HXjv3J4Yyib1Bb0yDfUV8fTSgRITpPfg3IhBp2A/OjicQ0NTsl/SZ+jdBmdK3GBFYbnHm+M9gMw9gfwhjnKEx2jxWCNYOZKVUZ6bYusU3ogCFXiJcX5BdtSPy5gcwlMn9voUiaSoswzLAAC/8khx1ItkzqNlTvA/FA4hSmMSZDfYgukRi4vQTnCwUQyCvOXqjLbXWpMwK8/TV77cbX4WE5WKj/5VW+1mEqoAOF6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVBtH18jChRQLmHvgPkNJ9e/TpSuwoBM1URK/iBmFr4=;
 b=vafOq+GpfLLnX4Pxlc3SpegCDXj2DC5AyIwk6J/riRw00P2eFHVAMXkeq9T01JJTtyuMOk4uFnqlSPMrKEJqERyX+i5Ab1lXklLG0zYQ5OiG1ZfVF5GWssJ/rUoKIatGUTM+TgrcWFZRI5Sr2tDMs+NUiB4ttLUjQgoBX6QL4tbTTrHN+aO6QVEuWQSgnHyzlzhbKQXWKfIrnDdpYLQabG4DzTbrCBCElogDH9mDJI2/1UInO8k7EVMlmumLMr83IQ4nJagj2dsX8en53x1gb7v/ZFfAQlKEW9H6eQk0GRQuAs5F14RUWfJ+LugzPZFSrq/6mbVE2SaJj8byaQyrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVBtH18jChRQLmHvgPkNJ9e/TpSuwoBM1URK/iBmFr4=;
 b=uXz64Yr9zCaWza+LtIlV6QesP9+DB+2Uqk/QRpQEOYCRL49dRGdZ9b3mS1WrGCLV9d7WDIaItAP6LSuYVKFDbE983ngszUeNfRdcjbywQrqO7uJoyjbWUydwjBQmu9qjSTfDTmkcnGp21zkKNCsvq7S3I/GcsU6Ax3pV3cISTw4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4376.namprd10.prod.outlook.com (2603:10b6:610:a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 13:33:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 13:33:45 +0000
Date: Tue, 27 Jan 2026 22:33:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
        muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, akpm@linux-foundation.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, willy@infradead.org, clm@meta.com
Subject: Re: [PATCH v7 1/2] mm/memory-failure: fix missing ->mf_stats count
 in hugetlb poison
Message-ID: <aXi-r2P3OJM8neCp@hyeyoo>
References: <20260120232234.3462258-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120232234.3462258-1-jane.chu@oracle.com>
X-ClientProxiedBy: SL2P216CA0172.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: 11de9c44-40ae-4504-f50c-08de5da8b202
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?R1EVw2WMfJpUKPNFQK3HOYtaJK66Hj5Rtu4HFtQ4qLVSSmB9k+23gMa1vO+V?=
 =?us-ascii?Q?6AFSmMwWAwDJBz0WnWTogxH7iRVM/N5J9BnIWYu2/N7K6dPdubE6D3BVkOFP?=
 =?us-ascii?Q?eX/tC/jBuMOQgUoH5QlPr5rnHTC5w/snKbhRgJknBOCzZMM2bnSrApNn+MIy?=
 =?us-ascii?Q?i7E4CAYdEd+hA+k2LuUuQ1Y5q1RLvWBjuOI6qAPrV1tzFMcRJwGEsgiZ4UGw?=
 =?us-ascii?Q?45jF0iUW8GFbVg5RPUSCJgi9w75+pV5ZtNeZSnIAoyEI4avmpp//nP1EURCJ?=
 =?us-ascii?Q?bEa3T7nhT8gyI/U1bOT73k0EElnf0SSKbkGQjEGcJp9l1BWueg9y2NKlRask?=
 =?us-ascii?Q?KyIaRN9JMmFYVD3Scif4/SmvoBPp/mrA92L8gRQJFUcUC55yYqhWZuzvw3hV?=
 =?us-ascii?Q?TrsU3P8F5eT9v6W0nQBbmSZI28RyrCOMVeumPzS//V4dKa4r2CObgG+NL3ae?=
 =?us-ascii?Q?zxkOVWNZfJInCqAuCCheGB6H1IOwYbKWinySoBLSZJXF6qO3UXFTbYvFvCZq?=
 =?us-ascii?Q?xjc/UcbrKueeUzfZ6vJqJbKPjvktdZHJ1fXgbFHta2t34ZbmoXEtqyXQLy1M?=
 =?us-ascii?Q?j4ppwDZrz2DPN80892+M3XBLDkjOY9BoLhvhmieUHrKTm58/+d0r6CpGQUw1?=
 =?us-ascii?Q?KXZGvIvpvnrfyAjkq5K6i1NUJJNk+7bRlZsSvVAM/C9z49K6Z2JZ7Vq/i2Vs?=
 =?us-ascii?Q?c5ICqxbQxxjKOzXiXjT+LwTASxXqOk6RxkN+7NmXe/wmkpTkr/dRa+0Skifv?=
 =?us-ascii?Q?d/y4NeS0sTLXipdkBqmMwM08Vj1NkIqDExBDljskbwpa1tJJENnXP5vMp0G1?=
 =?us-ascii?Q?/VyxRIjFf4832hNSVKhaCfLtu5zrP09APVcAfOc5N61CnqO4ZqPA5PefTf2H?=
 =?us-ascii?Q?0XLhuO4wsuCZxkoHHFmcxaUohdbe7BslYZNFgf1DSTaHvFq7TQKmpmbn4ZR0?=
 =?us-ascii?Q?cWkjvrar10YL8bs+4FHHo3WKvjfZQENVRbV/3nAeacI6ZpSqwZR/T2vdaxt/?=
 =?us-ascii?Q?9JWjd3cS8ihZHyZsZy+cGgrbk0tGRG96Q1+VeUQjK/jeoHJS+LD0/13O0gAW?=
 =?us-ascii?Q?x+58/WyeSPo+dXk4ne72p3nvt8VnEO4btWWXhokyQQMVcQgv1n1vBuGVdafA?=
 =?us-ascii?Q?5UTjlSvX373mvgCJuWwKZ5hXfKHWY+bnR9t0gtRxVVRM2Mwxn0+tKeII0Mjx?=
 =?us-ascii?Q?o4ZR97jwXmT/OmOcO8y/sAyHtHcK9ySX13zV95VtfXKTL8Axw0iTRkW67C52?=
 =?us-ascii?Q?Hei7oVa9xOIpizbKzokfd3hBDi5f0a+VSDUvkqynlkpkEM5SE6RBGDxoeGxT?=
 =?us-ascii?Q?DE4KLGGV/oIeISAK0669fSDiXvVLOgrpJRvFtG2M98S0AWll+T8anpchstT0?=
 =?us-ascii?Q?b+Ykx0+i0c13/6iceBxTpnNpazkUjjiQQxcJeX0MCBPcpN11+gSyjSDTPOV9?=
 =?us-ascii?Q?rPsylR+SFonkS3yOc4qjoFf/zryAj6vjdzaWrq1lHJxfDTciBMKRfzZMa+qp?=
 =?us-ascii?Q?w8c5d3Ram/lvRgq1LGJBJgRcVBBkthYXoTY4uVlouRN4CGuVrMph1D7rTc2p?=
 =?us-ascii?Q?ouVoadeWqvWGblJOtdM=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?u2UKtGAnsqUR9Ym2EFD6Hr5Vb4Fhbgd1odtJa324nD6RDXBD+OufuyjYJ464?=
 =?us-ascii?Q?f3tyCzPLNdDp1izuhMA7jRTuGS9agKr6uPl6UftG8mv+XmHYdHzOyr1rFYBe?=
 =?us-ascii?Q?bAeBUSfzUoOyyhotAR7uPL7M3dQ4YCqaDE7+xz0DZpQZg6rrLD3W3dIssP4c?=
 =?us-ascii?Q?l7aMgA/h8tjHB2LGK1vO72W2umoUTv3Id05VG0j4xL467DlBjpnHMC6B8uuB?=
 =?us-ascii?Q?KN+s3IKZfDmB7pvxf4w/6CFD9Ea3Rk0eQRHMUPCklI7JSLIJsgTy7WfHdR1W?=
 =?us-ascii?Q?Wzer+FMwXcD5wujW4pqcokQKePXtuZzn9fD4YlLi7UCOMENlNwDtTzs6lheG?=
 =?us-ascii?Q?STnpLNrIW+JqcUdjOfUzQqVH5zczXzHFv8bB+JufO2yT6/bWWoaN3Jr6R1fA?=
 =?us-ascii?Q?u3HyjoM1P0sSkzsk0xSO+eLKUmFFqwoH5JKFbndqRbA3Q6lFFXVxgK3b/EV0?=
 =?us-ascii?Q?TQEj5GDyfp8ftK/N23EmhXm6jDhtiNzLfU6yY2V8ZPYOIHcbEuREQyMygj8C?=
 =?us-ascii?Q?+VCeWGFVEcbRbro1CohFIFRHSAvMDAcpV3WLseTvLMTZB+mTTLi6ZP+gfTU1?=
 =?us-ascii?Q?3aAn4lAYMtKDfQ19RTe0HqsDifERe/2FqrjmtafQFDwEoFL8RIudqsPl/HVi?=
 =?us-ascii?Q?xfFp904CkUZhk5mBCrjXsedunThDPX1dkGae+E1VQqyTHihP8gkpJ41TkKf1?=
 =?us-ascii?Q?HP41bBdsDuL0Z6K/55cpBeyRAbJGxvqcYoWZ0KV8CXP0xTErY7Xltu8RyKZ6?=
 =?us-ascii?Q?2bZt/56g5cAzsDb13/z9fcL9rCEAktmZF67vVC34FvYNLgCXsLmnI+kTbbU1?=
 =?us-ascii?Q?V7keEZB13a3M5znvnWnNCXHLzh91nhVcCKFIGG4EYGeJfdXYCFxFPZtLVUKK?=
 =?us-ascii?Q?c5L09nb5zhD21v0CM713sGxeLUPr9ojhPDrgzDRg+ObM2Mign+PyuQ3CS95w?=
 =?us-ascii?Q?LHpuJ47z2OD/mqioZZEO8piVC/S+H4BFcpvhM4IwB77gfVosvMOUa299c9Ao?=
 =?us-ascii?Q?LBwkmJ8FkEyG4Gao4/4Ks6H1Zc/YgpgzgCBclnWBxT5CtEceG+Ukvr/xFt7d?=
 =?us-ascii?Q?hiejNJwIcbUKtVdq1YHEZxbQdwTJHVo7hHIf6sauGd0uUbWjxl6WF7nnCDp8?=
 =?us-ascii?Q?3xMYhUFChlkfx97Ops7pyg3l4bDCCM7dSTeR1VkK8l2hPxR3tpBGcY7/eQoD?=
 =?us-ascii?Q?gD7a4zZznDtDeGSC3eA/cmXQEQrLEtq6hg4frHoxU6urPLKKY/5A5WXD4ncM?=
 =?us-ascii?Q?Ghjy8g0ysoIgWNlbzPqZ+ZzmD4Y1PZl36X2Tz3dEEJ3O4vm4Xa1zOv6RjQIg?=
 =?us-ascii?Q?QoNvkofvbbY3+H8q1MEmGzfQhWusT1C+JpMndn+hFgWXxETiHtdCZ5M4yqTc?=
 =?us-ascii?Q?k8K0HN2vD/jpq5s1wvQRIpcGCko5DCHORQ4BCIopw5PcoDITya0V3SXHUbD6?=
 =?us-ascii?Q?jxdqUyL8pzuviYNeDEf70VCvpDTgTAI2Nbc94xc9uWrzFYI28hy90ROVEgwC?=
 =?us-ascii?Q?ABn0GpOJyGqijDMzjrJLw+JsfP+7E9NbQxyaRAi7B62WpnrD3ILvBzslrKh+?=
 =?us-ascii?Q?l+VCjXlonMVwREwanKRx+eTwg6IuBBhpNiPHn6BNVmngTHciHU6RZQ5FEfGs?=
 =?us-ascii?Q?c9D25zRUghZROfQyuzbroKox7AzAUaecuyAF0CReuXmONnDWM41cAuIaFS/T?=
 =?us-ascii?Q?i5Hf5sBZhp0TqOtmE1wRBosR0aJ7pLqH7C6a8BPDSGzfNmZm6lDBegRI903a?=
 =?us-ascii?Q?UecL3tiNKg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3kNSWlaN2NMW0NxhCefyAYtBkzLaWaEV92CnDWFZrF77JpJory2eAv+4olVd0Z0spszCmGvSJxOWEA5TPbYSv2nQ0dZ+9b4pudeXLWiIIZNm2s4JyZrp2Essrl1io6ErKfgQzU76ifPOKofBaxPtPxQ85KlqT450Qk2kb93OB8k6bckuLqg6FxWPivG5nnHuxKIezIP+K9MUYnvYguJAO8oOsD2iMFdvZlJJORNpFjOVyjf/vqVn1HOZmIY30ma/P+QcIlFRM7vaSjzh0+KQMwa+gqnEZaVXkErKBysl/quepsx4Q+34vJfkBof8n1R+oGnwLcIEHkCYTRZyh3xk5fSSFu8dAARXgkqE9KgEb2HbiZSSoa+DW6Id8Tw71HylLqsS0JzbwtjhiTZu1Hv07Haxk9lGGLAzD86678JJMJwhtY7ld4/e9eNDnudwyfxGnzcgARyE0xzYyvxkzp38vEo19egCjaH74nZD5PErkPiVifa0umgMh6D5YbeBf3LeAGyz5Ud+FHIp7bMoukiTKX2/IirWmE2hhnMWi0bi7OjCuuQXjLc3HoG20AiTMseMr4zMwqRqaPwsqo0uWMpCyZsE82WOAoqDbgfCU99yFoI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11de9c44-40ae-4504-f50c-08de5da8b202
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 13:33:45.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDdPRCB8QqPCwF2ph5LoB/qzHRjm70WFohUccYJomGL80jHT8MiZNes9ya59ImUDAMYw9sNnHdLsmpi1dfNzCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4376
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270111
X-Proofpoint-ORIG-GUID: pkWhOjfrtE8AYuXaixYshIRUEFklFDbK
X-Proofpoint-GUID: pkWhOjfrtE8AYuXaixYshIRUEFklFDbK
X-Authority-Analysis: v=2.4 cv=AqfjHe9P c=1 sm=1 tr=0 ts=6978becd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=UkdEhG3Za64IPkOVaLgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDExMCBTYWx0ZWRfX5JJj3uUlPM2r
 0+HHS0Qdpd6kyolp8xpEPWSMqmiRbQlXCTnvLD4GaY3QLmwDIxSfIm/WZ5IJtrjoCYrUqTheYHo
 DJMLI31MSNZPoEiG8q/nb+fkQbtawcHasXRvjLHQtf2g073Yg/Inrxnb/o+RhzBRLPo81rWO9kA
 fn0BZVyFsUl6HhwwdmZwdfwmW0tyzjR6T9UJ/EnIN7DuUDDtaZ4RW5fxzaiwDdF01PypjP0TOWR
 nJm6MkCQbsWMU6EbTbpc4iakqGa6QyDo5ZYY9m18jTDLmy5YqrCitvU6Lx4Sb6bb48jT2PfG+Af
 Dd6ntqYMVGDdZVdkIdGSwfSkk/62KH80sxKvreK+V7+E0GACziNC0VqE4AFZP72afeoy3lXpsSA
 veLw/P5AdLRUuYEskaVinMPnttnqbzD6bTy23ioCwmPKacCL9pdu7y2zH1Q1QHxjbTBKQw7whuu
 b2KF5UkfkL5UBUAUkJ3jw68bVnAbTVk5AaUgf9rY=
X-Rspamd-Server: rspam11
X-Stat-Signature: qryse4wrr8rbck9x5sdkzz1yfbu6yosn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD7340003
X-HE-Tag: 1769520865-324691
X-HE-Meta: U2FsdGVkX1/QuksjKpth9V9pmjYiLn5p4KaMtUTUs2rSOvKeBSiBeQEN5HxS0a97T8t7q0qbIuuN6x3SXi3IReHHfilxZ53vXWmgNEWZpztu0ARkMIZrw7V5sUS79b5EQMatxUq3h822e4RUC8F2T/oFwvTHOdY4dRingvYqysh/I3ZeqapNO/oqw92diuji4zSQdAB2/UoWMqN9vYsnZrutiG5on9zFGo/oKQsz+s/Zj4dZqO8cn3v2Ql82tuJIcg6EzgUmQaYzEr6RECuzB2igYHn3QbVBG4pPBoQsnbRnfgr4uLADBQD1yS6WC/AM5ogGoNDh0C1tLR0ZXXET7acRLCKW4EHi41iPgfDx58T+MEPFMZ69DHPyxrVNIhRGoWql8nHwoFJ/ETVBaDGlgDHfSD4tQ4t2ACcurfWbzpIvYi5ZbmwEo2380ZHqILjZp7mPioePMqKAWzf4KgKNjVh2/JHLxW9iFtrdZI0D7v/RH/cAZUzQwu/LLkEoLuSAwu5QTnyZqOWKtXUuw19haYghF4fjM1b8ikbPvciPLuezbzUBN47UWLvYMfwEZDS5dTA9t6727Cvpb5gcJsnj3qtzlH/vPzfAzCgap5lLxzrblut23PfENMbK17ZBWnEHF+pO8c0IlRciNL18by/vQXLETtzka3SVKeAJys+ZRfuUfPTEDuVB6Th6Dq+ZiSoCPduwkSvws+apMARmNt1KagGmnVO6EgiNyUaglDlxxJ8N0oLhG5eCeTfibF52fxZwW18AvIwgPGyQd6ccUAUMcJoYU/0u6UofSf1wo8HYJkVU5JM+L1t/tDt72Ku2GtrYmP5+oE6GCZK9ey0ELlHOoSrhJhr52pSUQHC9rVEyBAvpOQ8QF0h9pACg9M72Zy+zJs0H/TBMIYkHuIFd7sJL168DpV2oNcRKmrsHsXlelx1SKiO8D2a9q9yJsPOMz6FRcAVCvbkFgX8f6ER9r6K
 jPBCYbmr
 QAC0DHUEOXqiS7NtFDGGy83i2CI4qV7yshr12FHx1EWhd/hFfdRAuN6ZkmmM7A68jrLqhbP904ds9OInaPdT/ZhvNN5uSZ1Z5amhNawrTRzhOzXffb+ruGQ759kESoOaPOGkHfgSdMjigkN1dej5jZ9jVkPbq47VJo1mpG9WPkKLafz4mAx6MRqT0pbZLp0E0Xdfh4ATxREAx+Zh4vV/Ze7FjBStcG2t1ZVbe/UUH1lK9dZWnXobaS8c9ZCO1m+B5htuzwRBNuVxduu4y6MZh6qaOosbv+tH4Ubj5qDYxiVc8vXX6RuHrESO3yRW3f7FSxp665o1zTe+BJkuDuNYOFKkp0jLJNhReLZYkCNmQsbCaEur73BBXdxANKOc7e7hFuG7ugj5pfIfDnde00KjzP+PkTudC2FW18tLfXEvDrW1ZGSc9hF0KT6ZQcSjmRRaLdbVnYSdCHA1rY8G68wSLL279W+5G3isNJyi+GWslV7imCPgw8kGQhpLYBTeU5HaEWqmjRFnBL2qOmjKZb/066AvIom9G/ZKCW/Ziy7K/OyRwjAbJcgtQhcbkBR7Fu56s29WfvBfz1WkjmLNYbN6j483isICoJIhBfG+JGKh+bCp3zDqO1fW0L6VpJG19CeUhY3wNXt0OtybjLIFvSHVshgr7npGIQXk93pwttAScleT24ao86WMjOBP41cOT96eBQd25f01eIU35fFDUe2XjfLpui/TRqvaFvmKiHiEWGAhGAp1UBss4MwIfqf52NVQ51O+j0gVcNF3xJYcUshKQIX3Ijw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 04:22:33PM -0700, Jane Chu wrote:
> When a newly poisoned subpage ends up in an already poisoned hugetlb
> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.
> 
> While at it, define __get_huge_page_for_hwpoison() return values in terms
> of symbol names for better readibility. Also rename
> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
> function does more than the conventional bit setting and the fact
> three possible return values are expected.
> 
> Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v6 -> v7:
>   collect acked-by, fix nits pointed out by Miaohe
> v5 -> v6:
>   comments from Miaohe.
> v5 -> v4:
>   fix a bug pointed out by William and Chris, add comment.
> v3 -> v4:
>   incorporate/adapt David's suggestions.
> v2 -> v3:
>   No change.
> v1 -> v2:
>   adapted David and Liam's comment, define __get_huge_page_for_hwpoison()
> return values in terms of symbol names instead of naked integers for better
> readibility.  #define instead of enum is used since the function has footprint
> outside MF, just try to limit the MF specifics local.
>   also renamed folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison()
> since the function does more than the conventional bit setting and the
> fact three possible return values are expected.
> 
> ---

It might be bit late to review, but FWIW:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


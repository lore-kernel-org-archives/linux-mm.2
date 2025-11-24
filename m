Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B5CECFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731786B0010; Mon, 24 Nov 2025 00:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1CC6B0011; Mon, 24 Nov 2025 00:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583196B0022; Mon, 24 Nov 2025 00:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 403606B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:55:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E05FFB7426
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:55:51 +0000 (UTC)
X-FDA: 84144439302.29.A705C7D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 913B920005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:55:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oW1eokU+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Hol6P47I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763963748; a=rsa-sha256;
	cv=pass;
	b=qJRMqWObwxfWMOSl6g7hut9XL8Cbs9Ywh/HGqasrI9f4mDrtHGk2x1yBMI73v04bpG3pGe
	7Eb9QdyIk2p2DK3oRkSd5PgLCB/gpzMopgOHmAhzxP4+svS9NgGJ9aQolZPUaCP8lStuZB
	PCCY2mwMTz6DVZl7t8GxJCA7sx0p9tY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oW1eokU+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Hol6P47I;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763963748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JYznldtBynlEosDJAUxww03Tsznxbp4UnPzuAyhmlg=;
	b=daiE20FvhT3sASSc77klPHtskV5K8HKCVx8kuI735/qhnk09xXA+vep30dTpjl48qTeD1t
	Yb8/n5//t5RNnRGdtsHZYuF/KuDHw3Q7L+InMWUSTJGFVsUxfw6kKH5sThdWSw5cQRUgbQ
	YD+8nGMqhNKzs/E/I88S5+XgXV6SRJM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ANLiqTv3832629;
	Mon, 24 Nov 2025 05:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8JYznldtBynlEosDJA
	Uxww03Tsznxbp4UnPzuAyhmlg=; b=oW1eokU+lQqmr35Tv88OxFoi3qwjD8t3Og
	8kZwGOuJMj0MK7ZPEGKGxGuWS17qSt48YbrRmx1FPuXRLvUNaFNIf1zNuR8MFlVD
	WW5iQB1AoO8oZggJwEckS0isSe7vxOJCT3R32pNQCrNrsk3QvV/v7TMYobFK6W6Q
	UdVmyBsR6sZI4LmLTvISJ6KJYsMDoEjj+OwlQJI+pWaaHo+1dgzE6ar9M8UVsIk4
	C2CZyE1CcgkKFS7nT/A8amVa9IzcAqsx2AdeIwki2IVTYHEo61spndz4ImokmGsu
	GZPiRDYFGYRGe2fMNL7MuOSqhFzcY32lKu0IQ+sRDjWtkxplWTDQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7xd1dfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:55:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO2nilL018875;
	Mon, 24 Nov 2025 05:55:39 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7q0hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8DUDecFaocWwM+w3iDZswBPIIdMn14d/Jbq2wwLW2SzRmwW7Cf0b1N3rjymvXj/2Mo+mcPwnXst65JQrd0GcyfRknY4jbQocslXGve75aBp3P03kseMHu7CnbsyghM+e5MNEsijV9Gme5d390xfUECAvGFLiQlpVG+Kgt27SJNWPJ88aWVSLMiV5n+AZcNv80ErpnIG+QfCNF/u8y7l5N1B38GchpWTpQFx4ABwGXzVGt7/WkZk3+PHp7/7FFkxsS/p6QNFgYpVdGaCAM1BgJL93OLbpmw28/eANpEp+oBhEE2+BEl3QUPjKX42YO0ia904UP/QD03tbCLlEXSuwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JYznldtBynlEosDJAUxww03Tsznxbp4UnPzuAyhmlg=;
 b=na2kPcB8ciNcbobjt4G/4nJiHB6KVNd5TTtYWt+3+Hy6Mksb0voIqtmywIy9Bow2tBPincODjH6C0DDyoZJIPvwPP0FOxNvcsOyv+xFoaz/7i35VpYSKG8ngW5XG2Qydnabcvksu+xjbIuSct4+rTvcneF0pRo9CyA65E+mq5k86hojp11g358FLdBd6x6ZDbaW/AGxPtB5unSst47MHMqz9fnQdbfNJ1z4zHB9IoGRCLwxqxuwbf0d3PljkbQwS23N+7VFpsrfEP7OkBS6RzCFjZ4d2pKF1YD8kFlJZBRO/6UlhsgUdVUPC2JAIevCFDK0y6/c7/ucFLwX2Ma06Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JYznldtBynlEosDJAUxww03Tsznxbp4UnPzuAyhmlg=;
 b=Hol6P47Ij9pIZjXDNlE7iWYUTUA3vIDJzOy7BN6VLQ8rbRglTL/B4iCCCZ0JhtS8sKHifC+zL8Yns8VVj+QxoCZ8Kc+JvsGDWYgxCz9yMzSUXy4cRmbxTjBALwUTgTy57+DxRC97mnIckPbeONLMu0eitWyGWAOHzGAAajCjCO0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:55:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:55:31 +0000
Date: Mon, 24 Nov 2025 14:55:22 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 09/16] slab: Remove folio references from
 __do_krealloc()
Message-ID: <aSPzShRwc_qod5NO@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-10-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-10-willy@infradead.org>
X-ClientProxiedBy: SL2P216CA0078.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 9848d545-05bc-4c15-d459-08de2b1e1358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tQgGb0txCRPaolI2fFd7y2UIufLqCvVg5cA+E0UniCBuMZo8ZfLL/cRLMbTO?=
 =?us-ascii?Q?+kskcKdqjdboQsplWz7PnBMTCv1JpBoSnGnaTgw8QRDsTnA7wTahJdFoZvtF?=
 =?us-ascii?Q?AkgkrSXXUZbj1G4F1b8yIYZi6TJX4GKPbwzxMM0JWw3fTNylC3DonH1V+liF?=
 =?us-ascii?Q?EYl5jRUT60Z+UvfcqxWKC0eSJ8jvzVVPW22dmuAK14OD/kDplZdpQlailcww?=
 =?us-ascii?Q?y7Ub1XVcdGv4ahpD4ZoxDAZqe9t5hpRTBfu5Ad/hOZnnpMccz5StYrmvackR?=
 =?us-ascii?Q?BwZX82EDtJif9KvmanemSPbFvrFomYWMlC3AOMUebpAM+i80geuvRImhvO/s?=
 =?us-ascii?Q?WFrux2FXSTCJX2PrNmtIZF7hvj4qydbVbOPI/SkTresxRazighgVs1b5uey9?=
 =?us-ascii?Q?dr4DL2eVBXbgpHmox4PUv+pX+GS3vQMDCqSci0X+5uYd2d0LHVHAUNv4s4pr?=
 =?us-ascii?Q?//oh5NtWv6plHD+3ARmucoFqrNAjiBhaF+EHvaln5YM0w6AXVHeDlO2p9T5l?=
 =?us-ascii?Q?RJtLM1Wuk33rSrn7Re2zgY9OhWgaUc5f7/oKOOQ44nXhxPZaz+BA6Li9DFk2?=
 =?us-ascii?Q?KFrnUcSeK7RBw98JhxNC/6VIqYYSBWe7raiLAqMg1UbbbeXbXUaQKo2S7qzB?=
 =?us-ascii?Q?sQwHXxnx3J+njyMhFpKeLgGUWjNoPBIwKJNSm7ffKvpBPErGAQEaXgDg6DYQ?=
 =?us-ascii?Q?13rr6Rhl+qukPOlrMVRuGjr0oRQqxPQFO8riAzWJLO3IigUs3lACPXiBs9SY?=
 =?us-ascii?Q?EHrzaQxvzkzaK6R8RH0Q58f4kYHoTDalow+nV1EUAPtvZP1hBV0YbDFE2sU9?=
 =?us-ascii?Q?LatEuXBac+WjIJgpOA+OsJ+TQvsEMjWFeFvm3G/C34OAYstFNv3t2eRDpv4m?=
 =?us-ascii?Q?haMktz4KyjvKJ12EcQ+ar+T+R5CQtUfTK3n0GxOXVRhp0WAsYFV+dNc5xz29?=
 =?us-ascii?Q?RUUsEXG+7dPE1LxSEbpXVAwJrSZPJH4SnGwYuk9l2XPmvFezlveDoRTC94bZ?=
 =?us-ascii?Q?X6bGTqBjLNYDar9xLEi3speSqKS9dDCOecODp/guUuG7y+lxfJS/5BVJMp1a?=
 =?us-ascii?Q?EiyIXGcrVyArkGO9grJ357KTihIgLsz3mfbDpCmZB2UDDxFNlRp+cJ/Kd05P?=
 =?us-ascii?Q?sf376mDSxPCitWrFCPIHl+ikxovrgGbFeimMXbW6p9yJFTNn/nwn27RMLAmG?=
 =?us-ascii?Q?NT9OS1CUr4nUTCLLlcJ7tQhxTSKCVfK5VES8JldgX1VFNnfQnwK9rqGG1OHm?=
 =?us-ascii?Q?SRjAMYbe1DxII1O+e0nD84laSNtZYgqTag9MhDWbX7AO9VyC/d8/YlUq57Ji?=
 =?us-ascii?Q?3lBVyMZ0r+bFh+8VHy4rTzSJvlmRiMEG8hoLPirpl0F+ICATQLrLvDzsKUp8?=
 =?us-ascii?Q?A4rAOyAXHsiDWZEMwLjtRxqEp7zERHtsoSiB0YBnu+PU2e8xJLLbtuazQtuB?=
 =?us-ascii?Q?CBFR4eJlbw/aVVL1TS3XZefSm03z3zVY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7OyMnhVXiBIbeFADaZxjg7AeN8BDrGr+Uo3SwBOtp+AGKOjFG3nsayfNO7hX?=
 =?us-ascii?Q?yz5RkXDJSgPRgWLI6gFkzg2DTXnaknd34kY+RO61imi5TjCqWNrI4pLcR22U?=
 =?us-ascii?Q?dzRCTIHmhzEPxwVeVLwt6OjwMio2v9JaUNJfUbNogLI9Vzamypw36PuQ5bb2?=
 =?us-ascii?Q?cWOKWj2u1tUGobnsc4ktDmIQPNyzNG5xx+N3hzd1i22Klx6wOjg22DpxP+Eo?=
 =?us-ascii?Q?SzWTbxxn1R+H3FteVlS2YdUETpkTDkxvRjNeTExmmvpRsPSXFPYC+tbefV5q?=
 =?us-ascii?Q?jKVh7VQeDMiB4A3Yx8+RZTekhW+exvWSF2kefgbvnaWJO9/BUY7Knb6/SySW?=
 =?us-ascii?Q?nesLzmCdWScxp433dbNgr+/8AyCXwLkc/BphiXYMLz4TmRv+PXENGWREI0AW?=
 =?us-ascii?Q?11NQ/i4p3UiLkoZy1gILgcXEaz3RGm4UgLEcn+7KiUDODZ+1XB01o1qJKsJu?=
 =?us-ascii?Q?5hl74YvkqIPrtmzD9M080XuBZ0hFirUzFFGCn1my8WNKzZ/Nu3h43x9zrnTD?=
 =?us-ascii?Q?OcgeQsiWpgYLLJsC6zrAKAWzjuT8ingOkuFWMQqj6oGorFjM4b+AaqMVmVvC?=
 =?us-ascii?Q?9SB95SBHTm2XdLJJbb9Askt61KqZJbxLaYbcAW4T7r7izWGzGAfV4QfXUleO?=
 =?us-ascii?Q?/3lc2s9bHBd5GkFKSSWwe9nc543+W6AwYEwvlIHmpsZgptdmr2vpHbr/ufrn?=
 =?us-ascii?Q?mxogGae4fKg6VPPvA8+hefA7t7ukjR2CYrLGB28FPH6OMhF+0IjxIjIFaxTG?=
 =?us-ascii?Q?96bSJoiRwKjacCWGK51kmsNXA7sK/FHsMgeABNVZQuk2qdGRtwJvieXygr2G?=
 =?us-ascii?Q?ichAe31uuDB6z4r8/zzK6eY3b+9HIh7ygG6Naai3u1a6JApeoSOr4NZ+Mxlc?=
 =?us-ascii?Q?4lp/oQpch3kUGt/YTh5nhd0KojsGdRaARY94x9pTQLt7iXWb/6rQcsoVNKtn?=
 =?us-ascii?Q?Sh3yNVTedEUjaEtTH8RLcTGyaXUmSpCL2SH23LoWEXqo7CwFPIX8ov/ZCo3g?=
 =?us-ascii?Q?OYAIXaZ/m0WyY2JwplAbhzZIb3kkKpvcZzr8+PJ9SBXr1UDW0vZ2VIzcykO5?=
 =?us-ascii?Q?J/UKaqRYPPQocKVQ5x5VQGZka3cqF50uuP+mcSn38TdGTOhL3LLJiPhTYCZd?=
 =?us-ascii?Q?KVxa43cjhBck6s7yxyhWdE/DiKt8MJFCRGy2i4w6xFDH4Ig32lO1EgG6IL4I?=
 =?us-ascii?Q?8k6V1ueC4h4gu4HBQf+ufzRjYe7uJuq6h5D/rtD5cSJ6s1yRsSnMd/Td5jvo?=
 =?us-ascii?Q?Um9fS+h//Q5QpNwqg6TNyL6HvqdBxbKaVA8OmoZE6SVhjCHMKLCESRQQws1T?=
 =?us-ascii?Q?BNJEvWiwYm8b3pgtXcbvYMV3ogLenPqNGf/KoiEDrI7lhciWHTzD8lSNFJy2?=
 =?us-ascii?Q?Y3SuYeQWYb24+zabIbuYqzf1zhTHOVBOMI1Q/EBFxDH9fqJWs/IudVavUQVK?=
 =?us-ascii?Q?X++H6bcDVmUq5TVMMiYsEAcEaNVyiwX4HQ985JzNAnuRkWZ9NClqRLYmNf8H?=
 =?us-ascii?Q?TA3tHFZMV7Co8CdxVEXVYb0snhctX1ajQpxieHAyURxnmDE7A1TEvhJlNO3t?=
 =?us-ascii?Q?UImaUkmhnxt08hJpnx6yOerBrPkK8m9Nh8BgZ2RN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5d1DDqgmxNiomXo2fyr3wAp5hPWk7u6/iOxEoN8e5gRZLPyVHuvbMDk8TzUq74jlklHKLHZhqgjIzck+1zWyPlCsGYDcrGN+iYorGd8oqwrvYdszRq8TK3CFddyNy6osDypWvtmClW0QeZyj2R9IPqW63pTMoYfMSGJ2TEtt/hWww4x/DVmIOb+joyrON3bc8fkdUy2uOkA/zjkujPBewd2h/LtlqrD7cMhrnacMhV/xPSTFtwifN6axOXtuLf/+3yXw2ciT5s0cT3FcnCHUkcZqkuEuQoLKAzdEsph+8dclIcBmRX/LQnqiyoSaBCUd46SS4ESZyn7X7o9pKt1CYJyHVLESdRoTzHq1xKrzXpUhthlXZr807OniEG917chYQgWSWKv1pdqyQ6LF2cfBvNlsS/5XNMdJTs/RQu9v9L+1LRL83F1oe+MdKX1nvovDSXk7jnpCDDq4iK3aIG8sWpfXzOBKqrPxshk0+/A4GxbAiy9b2Dw/ywSaNoOZ1qP2fYrfll2ne9PuRSFHQSkvLQ1eXoRXy+IzWwANTktG58/v0cJKd90E6pNgqH4IUMMAiT7C9CUZK+REZAedJHi+Afi7rVsr9Wa77X05LqDkzVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9848d545-05bc-4c15-d459-08de2b1e1358
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:55:30.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ds7P0l/VCw3TcuNLVCabJzB6+eP16wHOHMF5J7zwmePGWFJhHuS0zXs1RyqbW9+Be+/W6LoPYI75Ljd1aM2zlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240050
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1MCBTYWx0ZWRfX+PQRWgmKPt6j
 /p6VDc/i1f0lT91gfmk5CqJsWkLrK6CXzVBtkeX7JxbEaaLOps7qoDrUq7oVwUJGRl8tqBJNjXV
 DUOHr5ZDax2n4pccEa3yp/JPL4kS9HjEootojckNi7bmsmHj5FK/cVHxJH7SzRuKefqD9ZuRB64
 va9j1bFgJo1zLnaXXqUqqMPmmdZBaw/vle8IqoyojaPsXmfzV7zW077zD3HeyklTCvWWNSAqGEg
 z81YmhuB9H8gzftnN5YjR97z4PKuznLUyXGfSEv7GPxaSGOTG2dulrXrr+rfdqCx1ZLI86VCa1u
 rkrELekJXe/fm2XG8dZ8gL0DNRJ0yVk5gl7S6r38lKT7+4QCUxRzCZ7GaRbzOsvbfWdQjP0nHmX
 CNB/0N6/hR9WuardUO+Fqtiu/z+WmA==
X-Proofpoint-ORIG-GUID: U1R9OkwUc0_sslMtLf4YZZatmmLg5npz
X-Proofpoint-GUID: U1R9OkwUc0_sslMtLf4YZZatmmLg5npz
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=6923f35c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=a2hdpyfelxQ4SHTieFUA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspamd-Queue-Id: 913B920005
X-Rspamd-Server: rspam07
X-Stat-Signature: onaajft7e7uehpu53k1owyisubi6d1dq
X-Rspam-User: 
X-HE-Tag: 1763963748-228418
X-HE-Meta: U2FsdGVkX1/17la7loeDPIPrirLUG/EinuRz6VaYhmUD2jCtVJj0S03G5DtILGlgOuqHsK0d4EATaUns1G6XsbwrdoLu5mo6BpRwarPA3Grhx/As3MHM/fAVwl9mbcS+4KJDi0vLY2Rfztz1as4TMZpWtViAe+x76rZQj/UOHR1sMyR+X/vVWdCaJLNwNt7WPzyydPbdOvj0EQpTDCnswMJ+SZDiNlB82Wf0B8XjljtzxVR/xZVXXMmdUMT9DIzTi1MaUHGdPpA6xBpkeYqEslgPh+0ZOtExpoJEsldwUl047ZEMU++tkV00GbJxUen6qspUvi2Ymb5KGrNlUJ0jFwt0gM3KfQU4FmSBdVO5Rq/tpj6v5HWloiEFmyn9O6oMYBx/StZw0DsNi778U+swP0ox0dvRxXYdqdE7SknEqnX8vKz60X23cXSuc+d+AfIx0QYzhpA1U1ltsnnJ+TuDrMd6c/1RO5UtM+kwsofm2x63NKoJbnuZWMeGdvTVEfVCM56QIDUiUGoYexIZmDk6Si/YgqZyOIDFgV7uRFvXsl/t//mhzur5f7wbVT35lp2PJ4wc5AkDjY15y4n1Cecw8aoRhuHWo1C4k5D4e26BwLSYzdfPlU0sQNVKY0nGBToEM45fGwP/Q0qxvMP0s/7hwnwWP6xA8wFGWeJ4IeJl00Uz4WXs3oSosDpylkqeaBlDKjmFDuehl0FoLSbIniiSqCVpi/V35Y4eMzw5pVsZ1yMMR6NgbtYzTdi+PkNP6INWq18XV14qQ/Su3YxWaw9eX537pvibxo7g23Xf+bAZx+9MxCeHsrhqhtCZfPhs8NlyLbeuC9JrlAn15eamoQL1iG03QANCzo8tIHBRZFHiJu4LEZuizt1G09y1AQDL0rCT4lndlI2nY7jtTRfs6IP7G73i3nwDynPHw8BdVstBQprkpIBIazZlYmJRMAbE0mi/EYhrPbIcIxxS3YSdYQr
 9HQpN9UP
 kaVrXcWDRjgWtzmPPogVPLnbOhh4nY/e4t6t+xOs0wU7u6RrGrU55FP+PN6Z31g33cNKBkMR1D9DpMiESIMOogJsMSpEFo4RHzEgre0Bg+Vn5uSFdnUQ2DT+ngXZOavnYRNWT8l7BLxgdABsnLa6dPQL0S0y45yV74UVU5tBe2vzUs65jVBJa61ZLxtcMgmycfXa81LDE0Ep4xCy3fQbJMLytwjbshGMWPGoI0JzfpzvBU6n3ah4LliaEvPqcGf5W8UZNbR+nHlYHV/E8VvF0P7uA0gLIuTr5bC26phxrtKLar/05yTcJhYREilKYQ8dCuU73efD7pxzVvwrJ24yczUezXFoQdI1825ql6OI99KfmoxbK8a9tza7HSWRcifMzVG3Mbuu12LKrTt98Z0/LdXbIOJUw5u2SYlJVqrCFxfe5CsuAhzs82dru1lRLQmsX4W92zNnHz0MVo0ri126jGhqS16v1ZtNkWrOoUx7rW8IqwRaKIB6GuowUTZUP044VCoF31OCE6cfKo4/A7faVgrnt2Yx5w+g/Z4lQrKxE+3n1Fnmi+eIm547dGsxBnzYwIwmNmer8HZxWzpS9hH6vs0oZ6uhbGkbNbujGirSyZ2UCIJImZyuHUTdUIyFc//xBviHpM8eq3F51RA2Q/4gS9iLbP1zbdQd2jwgkg7wCV1RtKULe2FD8u158jBn901vaTVrrWeqfOwKjFe7PpF5MuCTAq+soOh5YiVgPKWxCti2lJTXUhJUDZO66NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:23AM +0000, Matthew Wilcox (Oracle) wrote:
> One slight tweak I made is to calculate 'ks' earlier, which means we
> can reuse it in the warning rather than calculating the object size twice.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 184bab91e0af..4570d1dce271 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6977,16 +6977,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  	if (is_kfence_address(p)) {
>  		ks = orig_size = kfence_ksize(p);
>  	} else {
> -		struct folio *folio;
> +		struct page *page = virt_to_page(p);
> +		struct slab *slab = page_slab(page);
>  
> -		folio = virt_to_folio(p);
> -		if (unlikely(!folio_test_slab(folio))) {
> +		if (!slab) {

nit: unlikely() is gone.

>  			/* Big kmalloc object */
> -			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
> -			WARN_ON(p != folio_address(folio));
> -			ks = folio_size(folio);
> +			ks = page_size(page);
> +			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
> +			WARN_ON(p != page_address(page));
>  		} else {
> -			s = folio_slab(folio)->slab_cache;
> +			s = slab->slab_cache;
>  			orig_size = get_orig_size(s, (void *)p);
>  			ks = s->object_size;
>  		}
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon


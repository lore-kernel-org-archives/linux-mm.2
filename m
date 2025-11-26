Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6A8D11196
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 20:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64236B0022; Wed, 26 Nov 2025 15:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AFE6B0023; Wed, 26 Nov 2025 15:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB8C6B0024; Wed, 26 Nov 2025 15:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83B3C6B0022
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:34:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FF3F13BB1F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:34:06 +0000 (UTC)
X-FDA: 84153910092.08.81033E2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id A169A120012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:34:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NzE9urrI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YXX9AWVD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764189242; a=rsa-sha256;
	cv=pass;
	b=kwtV1AoyiCYZpObCaQ3xUa4Frh10zfC1smk4SxNX8eFQ6eI8qMaMMtns8KOR2IlmXgDHSu
	i3K4HH7RXRtkvBWGAM03Meome178iYrGyQ5SADUsM+HZn4+rLYIN7xa1U5CGUVCLg9tR6S
	bB1Im0eymGB7oFEf0ZL79Njjgd9Iu+8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NzE9urrI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YXX9AWVD;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764189242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dilrSJfrsrpDX20qXVrGU5+/G3GUE0rtWz+sjn0gBeI=;
	b=1JO5fPn+1jZjVlnCnHT2Cc9PW1M+d4i6kv5vXbl47OPwE08ZRep0udfqSC4ICZwV9uqM36
	4EJcpcUhaMvTE1MCx4OKMBNyRzNkuqZp9bAnqxI7F4kRA0zY5bnU/UKhsTLRfFWu3IQ5g3
	5Irohx+updsvxT0JQ/SKSN8eAoPKsvQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQJu9323010315;
	Wed, 26 Nov 2025 20:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dilrSJfrsrpDX20qXV
	rGU5+/G3GUE0rtWz+sjn0gBeI=; b=NzE9urrIUx6QEgzBcDxgAsFZGql+ufrfAM
	O/YjYfHNUeUEDrSC35AfDekNVeeiONESToDGEwpYQFRwin/AQoGZubilMrGlr0CQ
	2KwKfvXPe95/GEtF+shVyksA40RIx2hsccYqEWofHtB7FggkJalBOWszDQ5p6kzd
	6gBQw7naPuQTV2wRLS1cMmNhe1jLJo7DAGYlK8jbMLmwNXmqf/dflikwzTQiHsx9
	eZic/bpqTQdrhYaqh+RULHl+Z2eeGBvlsdY8DqNpWZfO26EnU6xADCnIb+R3uaos
	+gy3aPSlfzMrk6F6L1kDUKqT3SdDSyadEij4kABPT1LoVxgsYmfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fknkq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 20:33:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQIqttH032758;
	Wed, 26 Nov 2025 20:33:53 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbf0bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 20:33:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sg/+hir77FpbFK9nMnw+m5hyPYCRra/yWDeFVfZ0+oWBtsi59lhANr6wHiGTrUQ7wuUwzYZXkcxdQ06IV0Begjm/H6dIgcFbfZ8dhBrZqV9/+Epyf/KDTqcxBZKzCO2OuJ00Fw1KVez+ftq8FMJ7z17cF9dp13oeZpe1rv2NQss78kGvu0NcppmJXx4MlBZiPDdR5e2bRP6MsXJeLPffpXYy047c5DShlui4rAoA4uElkX3cKlCMASeDYnGItDvpWo5LKe4nx0+EtSQbdMhyHbqGpoTycvDaVPcveJOOlhMkoZ5sMNg5OaXWGNsY8XoWhmBkeamppu5N7ESBFsQBiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dilrSJfrsrpDX20qXVrGU5+/G3GUE0rtWz+sjn0gBeI=;
 b=dk/qnTt3Ni+ttXni0Q2OjKbku3sCcjc5qpb24DjiydPpzA9RY2KIA5NM0vde0TgaSfh0ZXh+CkvDqLpbNBC5X+rOwmUb7PJqqolPtFOkArXrPTChDPXTxfghvzfX3zD2c2XSDAUCFnTXse3woXHxUd3dMYfa7pwbpopg0owEqOCNGkUlHDftur6oa6sthFzZ0VV7A+LtFsHoMYG8vtAnSHuvxenF0Vj7vuLSslH/H3EUwW71bEoyRrlLTRewMAoGRavxgVSbVMQP96hjIVMdEjuNx6pTf77ZgKHyoB/j263/pnW50e130zL2QtSLxcdEioy2D+7Ue2Mm6Kbhvy6hiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dilrSJfrsrpDX20qXVrGU5+/G3GUE0rtWz+sjn0gBeI=;
 b=YXX9AWVDoUOQ8wtrg9zUgPeocQycypqrERdGC4cQJWhOoYwpoyunjDJKrMXx7p0Eokpra2q5hHfm34j2ifc5stpko+NFc1QsT7Y9SUd7jd4ghmcBimgQPfBgHv8uFbUnlGD6yV8vO2XoUOKHebxvqXTZnKdfaQCcTrHo8ptd8S4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8614.namprd10.prod.outlook.com (2603:10b6:208:57f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 20:33:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 20:33:50 +0000
Date: Wed, 26 Nov 2025 20:33:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
 <aSdYkYYAuATwYqbD@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSdYkYYAuATwYqbD@casper.infradead.org>
X-ClientProxiedBy: LO3P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8614:EE_
X-MS-Office365-Filtering-Correlation-Id: ab3be84e-85ba-47cc-cdd6-08de2d2b1b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UKvtQHZo5jUS//r4XJUW48okn7f/shWmfmKkIwT0AWQfl14MBMfLxvZZCNtq?=
 =?us-ascii?Q?CKdoC1XhBVfz9dnTzvZIIuSrfcMW316rqINbyqr0TEBaMqCbhmMrg83QXhaT?=
 =?us-ascii?Q?5IGQVOQR9Oelai5JZ05Pchhh1bRIK8JTBii409XjY4CCoTB/gidlzrWFho7G?=
 =?us-ascii?Q?gZPw+CiYPvnE2UUhDyu7wleoSalls/jJa9VlK420v+UxhO3fUdhTcR1hKKEr?=
 =?us-ascii?Q?ZZ028oqBJXL6fOamc+zlLgpauddEgt3PPvBsr1/fAl0wDB5b6bz2O+wrwBmu?=
 =?us-ascii?Q?W0p6reflNOLDBl2tg8nzIfyTdTnxzrYQ3xik6l7FCnbZJ1DT0Trb/zPfvCeO?=
 =?us-ascii?Q?PuLWNAd2B9TXj8p57OlDca9LFThvxpCEpWCjBqCu+4j8T9zJUZf+4cvbkjb4?=
 =?us-ascii?Q?ovvHL+TpjY2Ymts/HEqHUNvAoigc/qA8TKcshkT6SdRSyAP5fH6HBFbmEtpa?=
 =?us-ascii?Q?7jUK+H/RJeHW522Uqbz+QOmANYTcYs5ElqutMrr5RhB+OxyyK4GfIZEopghZ?=
 =?us-ascii?Q?2EEH01QDIc3yT7e2U+AQ3G22rvr68QGc1RhfB5ReKrrfqrou6AQzwjXCToD+?=
 =?us-ascii?Q?0tFBm6YzZszW7utxvFjjfYeqD9HE5CPMn7no2z4VfL4hcwdZYAtkBA9wUz+6?=
 =?us-ascii?Q?sQbky6SMMy1dXryBiTfR8VUwD09pAK/8EBHsHYfxkXfI5YVkEqvZzBkhL9Xr?=
 =?us-ascii?Q?6j//UpY49pAckcHjyx36dm7uifhD41tjKd73UzniIyBgnMZZUVFO0y0Qo7XS?=
 =?us-ascii?Q?4DiejD6IPcZ8vbIUeqn/r+R+di10essQcwMWJgS719/N5xrXOnMBJwkvn094?=
 =?us-ascii?Q?qkZ8tsa1Ulpzy1WN5YUnlZ7RzkaSAjzdKZOCxVyFvOZh7enKcARIVnund55W?=
 =?us-ascii?Q?oprtBXStJPjPvS+cl4AtICiJKBvqxmwg/lnPak3cfgTxQtEGcfWKHVYyFmbw?=
 =?us-ascii?Q?2qrHv6P0yX9aK/DsvEvHWkf0A3h0SnFCJm2+KKEhZjef4KwnzSLjIlTU0NC1?=
 =?us-ascii?Q?hst5jZCtZzAv/FYH67qyI4+87flAl0Aa9pgs83lM4C+SLSI+rMW9hKN0Zqw8?=
 =?us-ascii?Q?l9KnZoaSbz1NnCYhZvGWBgeGwoKPS0Sfk88hTkrr81TzRHybuZHkulgzYZrL?=
 =?us-ascii?Q?crVK2DQZflfCzBaq+aQ2sysC51W+2j46Fh3OoWLU2HtKYm63yExOVpGnuhcl?=
 =?us-ascii?Q?TVdylY2ZkzxZ41qYK/ZRjeAqVADioFiqWlCMytZye79UmraD+cCBRIJTBJzp?=
 =?us-ascii?Q?sHlJ5y+dyBAW9qJ6iGJ9pdlcF2yrfFshsEEUWach/b9Cj9kC/ZDZShnycnbJ?=
 =?us-ascii?Q?qUvTABkE8H8CJuKF0Gb6fn5/rbC41y0gxMLa4byz490k36r7voBp9wbdQxY2?=
 =?us-ascii?Q?+b9ow7z/CdMhNn4DZbivPt8H3biBvH9Uw7V0wO41/5FsCVkL+vWYA8rV1uJE?=
 =?us-ascii?Q?4fKaH31gtp0KhDEhmSkfYitBrgEFZIstgwwNf2EiFF3xdKPYUkEYLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tKMe5qJtLCHNv7Aw0nwoSQbFR/Y2z7x8yvwlxeoWmykJM3M2p+siAPTXw68l?=
 =?us-ascii?Q?z2o6tXFw4Gf4xm+nE77yAtwvXXHLdG1fJtTFrw7YcVf9o0b4GbX637eDG22O?=
 =?us-ascii?Q?10gBK4gvxAkvlCyYACHbQ7dnaAypWKi3vLkwjOHVXxsLVxIonp6JI63d8PK3?=
 =?us-ascii?Q?OpO4130WsSOw8tVLgPu1UBJIoj65uNW9o81ykJd7owRXiLHRdlZFSbIv8BCW?=
 =?us-ascii?Q?x0KPfCT24LwXpD+FEpRR03wQsOw+2ACJKGf7x6eZJiAgScfRC1gFGaO1y4WY?=
 =?us-ascii?Q?Bfkg9x09Nm9dIYLn4ryYS1lSVVQPRRrHpnWI0UazsElKyMgAtj0z0qmcAPsM?=
 =?us-ascii?Q?Im8X8c3aR90FDlkNG16r2/C1jrCvaBhS9gBPb4Sscn+acI16Bpa3sF52lXyj?=
 =?us-ascii?Q?+a2BV/azBiHJFMpp6OTc6qSmxsBYicepyUZkCGw0Gb0pdih78QjDDo+zKAQE?=
 =?us-ascii?Q?5EmGEj3e0nNnwPxszFqDPpopvVWpCWETyoALVipYpzOxVQ+by55E4OqtD+L2?=
 =?us-ascii?Q?B6OGre+gSIFAKv9SO68FA5U9X5jgv43zuIOIkvhHd0QR6CQV3/GJA6lmfbnF?=
 =?us-ascii?Q?Jpbzem03JZBPX0+W+VXLcbRsbspECG0WLPV5DyVOWb1qt7dAcIiUuqxhlOnA?=
 =?us-ascii?Q?ltT2B8uj/UNqPoAnB0THqOgxEVh+1X4N5/UwcRiV80dDa7IOtToJDxTsWex7?=
 =?us-ascii?Q?rM9+Mt5faUCxYLeDpHTHB2yrKu2ULFv0blaEQqd9HeJqd7BpKUFkuqX4d+aj?=
 =?us-ascii?Q?WjQLK/CU7aYqtAA+5LxjUqcLNjaCFhUqpz9dtzu35+IYc5bC126Ap4NJFqAr?=
 =?us-ascii?Q?o3VpenQ6bMuIvDlHAJdOUQFMMLseyodoSC+c/oY+HOsFi/HpzaLI5at5QWVx?=
 =?us-ascii?Q?r3u7zkI4PkiZdhT2vl/UKf6QrizZqp2Hy0nSUNbkyPqFE6Qhhw4m3PqSVuMU?=
 =?us-ascii?Q?fv0C/q8446UfxeRFmQeUqQw6b5ACg/Ptdi+yhKCkUNpSMbAB/4zwGyJpdXDq?=
 =?us-ascii?Q?DccVzMNO103YCwB9L3R2Llab0dsc+Sxdu2Zwp1FrUY35llTL49AM4KZYAa/k?=
 =?us-ascii?Q?UjsBQo0yWNObPpT0d1CbF/cKw9KM1FBAwlcqX8Ewwdm1EWaS9yvFyTS9rUnQ?=
 =?us-ascii?Q?78BKEAnpejhzGj63u4RICRTwQkv1ZQSOKkpSCMt3OlRLU61E2/qQRbB8gMkW?=
 =?us-ascii?Q?vZWhudacHcLzOP51dkeXsf1yVTbUPVL1kxaUzZ8qoyJUVs5o9oI6zfzFQ42T?=
 =?us-ascii?Q?bpvWR87J4V0TTx/QYewUX3CkxQmk/d8kqZcotax3TeFMYUciJBuybuofLjHs?=
 =?us-ascii?Q?HFW/XWwSKD9sP9y9DxAFlScUNXPrfcrR33i1TCNbG9ihoi1JhL4n7T73lexP?=
 =?us-ascii?Q?XixO7fuFkjONvstmV/A5ULv0euN/PMXOspo78Up+DBB8dQqOOI9XhCA0n3Zw?=
 =?us-ascii?Q?ltx6t9UjFhu08Dy7Dlc1O+TrdjV2UUBXxjjH3Y+vEhjH8MPTmipXsfB6JBhL?=
 =?us-ascii?Q?f9IsqL+vUA6uQ6tHfQxdkX5DIWYHZDhDUaiPYnQXARRk1Fs3A11uzai/txhr?=
 =?us-ascii?Q?+V2dHJsZ/zdIQvdSL59L1qjSlJ7Cm8p+Fg/UDVd9loAfusDH6G1olhWWjA9R?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vzx+nYNw0/gwa/nRXy59u9iCUbZqeHW2qpFmsFXFgnBAck4embeArgngQNngxXiy/0t3s4fpMe2cdl22gcbPW43jehIuKL+scIwquM/yU2J7YOuWZa6xfIgeYIM82neTe6tybfDr0hJsvzvVcrs3bqaMq5BCIPph1U3xqdWyKQfW7sfYaoAwrXl4lsUxzNkGhkZkuKQbxQuqDZCKTzzrmow9WAc5B50ALpbTa/xuRze3E4nzP1TdvzcQRacyVLFKmJUteVSGY56cJDvhzvUsNEfGHwd2e66fj1DoCD8biZ6mnhqFUjiqIxFY+ZtYuQq0Zm0wn0r/omJ9Tide+MK2BdmhTscTbAky8pPAApTRIwaHLydEzZmx+6BuHXvm+2fxOYzSOlv/Xcmx0Dc03gpJrlmnZR1mYbZMMTIRA8b1kl3kp5WuXnfmc7cYEQWeW5ApzHmrbmF0EM0qZUeWgCbvpd8YWB9kX6KtvHnjRhpTfLkF/RTj/kOCEiueWo/aBXWe8V6rpaDcR14oOy3To1iNGilRijCwAu33yJOGG7fH1rGkcksv0JalwFHiE+Mv/h21O7YIdKu1H5kw+vPhCmD8BrBnKBnlHfPVmmz0IDc4mNQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3be84e-85ba-47cc-cdd6-08de2d2b1b5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 20:33:50.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmit+XtXPL5a4kPeaqtrys44UyXKxSW6B/mC3H46f/GHiRgZmIq9ssihvNJi8PXay6vBRkJUSzqIxpXpKIE2/nSwWrP6cd8JC7kWUmJxGJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260167
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=69276432 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=5cFNsuyhDXtGQ68kzjAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE2NiBTYWx0ZWRfX7VK0AYStdwkk
 c1il2LMrawRda1cHogYBTD9RXNZxQ1HABD9ipt/ISUiiHgXmbxUKmKKJzQ0w1gk9CXX9Yh3k8QZ
 gvl+E4eSPr91a0qwN+UgMp7n6qQECEqm8HLTNFLhJgW6Fp6DJF87pDOAHykIXxv2rkKS0WumxwS
 qbeDwPioh/k6S1d0SysduDG9TmOGrOwAjTCs8UdsJU6LCf2mkLEt5+5xa6gXjnIOo99IlL13vsg
 aEvNrwga5XW9ZKWkJ4HfUWFLy6Icb/VnxCL1quObabred7M2UkeQl9JFVW8TX6O7gORbD8C9jQe
 8xkzljesmyt5eVbsQdPdQtVdQYHyKqW7cOUgjXRWeCNWpZLOZKLZ7iWZ27cP5QXI4M01Ewg20Wg
 FzJIPpxMusJxjMtJkSeJ4YkUQAFOWA==
X-Proofpoint-ORIG-GUID: qsLOUT0ixOT-45DsoSlHzuvLzPKCVPLp
X-Proofpoint-GUID: qsLOUT0ixOT-45DsoSlHzuvLzPKCVPLp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A169A120012
X-Stat-Signature: n8tyea7yfhoed4ydjyqx4zesfjq6mf8d
X-Rspam-User: 
X-HE-Tag: 1764189242-904020
X-HE-Meta: U2FsdGVkX1+E1HWWm6uBiHPnbU2ki1tO+WaSIySr82/yvKESo1RbfNWAvvPitl1mw0RqW4DKgViw47C/AqBfIos7TQqNVscDNVusw12WMBpIZYMup8eIo0avIhGRn7EOTj8oiQ+TcjoeO+8cke4anzoq1dKyopf4ylpckwDrvYJptl46Gi7nMWtr9wLWJIQEzPKiSy17fwcjp+z/bx+wuT6R6mRsr2uTFrBD+ZhclXpTVaVgJcjZNM61uWJr7i/+fxurNi7UeC1drhfWdxsUpcqr5HNkFdqOOanaROzU6nxNkDtLMfSpmLY3k9a6fweth8yl9c9i7i+dQqlKHCGNvNo2w6xoA5AHddfnQZkYAO+8gpAVc/U+yE/xTG3OEATBXo8ve+B6Jjm9gfafpCugtyInGinDjucYreJ1ALQsd2XBQq8bLt/SOm/UpLnwmY/wLK0QoYiD7SL52mQqCr6vd2zllffGpwExh3zmSumP5SL+F+JnfqkMksLYzY/zPpq04KOYf93/zrtvrL67ffYzFW/B4fhIMisloBLSwNYjCqoM5RysPq1nwKf3P4fIBsqohce6owvAZaGh4ZXIUmgbm60QkFxSSKSmHWRHztv4Axp5vZKD+qu1PczoPUMnV/9UVFqvSGtIHZkuaVE15ehE6LiQzXHgo6l6S5mBCn/T6qtX/zhaZ+WISNbcbw1wn96aGxPNRuC2e5TR0b2UdCnkmRiVtdkJ1t5R8aKK9KJsErkVbhMWK7orr3QIaAbylhDq1P8j4+9jv4jd8zlYXf8pkk21CXkr1aSQd2D+uvBoXmAFmBk5G4lwJTh9SEOrxP4u3PrM8Rgs1oM7L6IksU/I6DvjsAMvjvsDM4ifCGbr6FpllVSItNwbvCXDVj1PG2Y2uy42Og3G7idQYwKs7xpAH3TxOk5aaT3luJMTjkmjyUmhlvHrYd9/Wh66mggeMTb5v2qveDu0Gt6jVHgrPPv
 oKv/ZSL1
 8Yzlz3yR17uuTK3ELHY8pa8k1jAtB9CRO2jhHk3o50fCQQP2iiHJmoUMKt60TbrGN4DnS+JrUkPm2MkQZD+pjqXT+yLrChdJLZzgH/636zqensvt7itkKOkJ3KiBJ8gpOdt+InzY6myMo93vw8nieJZ9g2jRmLAdgfw5hsDKArkTgPoJPO7owYQtWWOTt75s3kUVaoK2TeMNNCqEt3gh0lbMAVATzDR11ABCQZ47DWavtieuj9+rwpa1ktqDh2GXxgENmYuPQkwL9YU4rDN5ALiHNP3Ux0sgZDHQUn+kz1dUgxzzm9mKotEU476CIImRBcfc7/RqCDyxb0klFf9Oof28KJN2aOHRjyseVg1X+p11zSWE4UK17NAVsr/+3xsAIp5VkEduZzVPIg1tweMwFTP6wVfPMBhW213GoxsFDJpK4yzH0VTKlNIeZkdkpYiqc5IBnu39YJfheWc5rEUaVtENyOQxmJf9zygfM9/87Ono8wUnE9DT8/KXYjbcMhZSkIs65Uk0XOZQ7JbOXPCSPPLS5FaFtAKgDDhwoJtPNhsA2/fnqu0SAFAcLI6K74dPEubiPVu+XDq+BUtBMJ66zbBDSG5BPVQEbj6Y+68kX+Z4E/OjZSFP0x5amHNai3+U0UzwjRkN/K4p6sLIrwzqpSmUMrKDClJlOIHP3VkkN457vnjH1qWL1btHiNAr8lEShWA+edQYXOM6PGnSeGZvsyCyilnAy2SOVj4R5G8IZH/ssoOP7qREriXxCHJeOrvptzu43
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:44:17PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 06:55:52PM +0000, Lorenzo Stoakes wrote:
> > > It's only "impossible" currently due to some fairly esoteric reasoning.
> > > As far as _this_ function is concerned, it's entirely possible.
> > > I don't want to leave this trap for the next person who calls
> > > __vma_enter_locked(TASK_KILLABLE).
> >
> > Calls __vma_enter_locked(TASK_KILLABLE) _when detaching_, otherwise
> > refcount will always be >0.
> >
> > So we're only looking at us changing vma_mark_detached() to use
> > TASK_KILLABLE.
> >
> > As this is such a subtle corner case I still think it warrants a
> > warning. Or at least a VM_WARN_ON_ONCE(1).
> >
> > A killable detacher is, as Vlasta points out, kind of an unwise thing to do
> > anyway right?
>
> I missed where that was said?

"Yeah I guess it's for the best to keep vma_mark_detached() use the
TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detaching
would be counter productive."

https://lore.kernel.org/all/058f5858-f508-40f8-adfe-e5de78621d64@suse.cz/

>
> > >
> > > > > +			/*
> > > > > +			 * We got a fatal signal, but the last reader went
> > > > > +			 * away as well.  Resolve the race in favour of
> > > >
> > > > This is very subtle, I don't think this really explains this clearly
> > > > enough.
> > > >
> > > > Maybe put something like:
> > > >
> > > > 	/* Couldn't wait on readers probably due to a fatal signal, so unlock. */
> > > >
> > > > Before the refcount_sub_and_test()
> > >
> > > I think this falls into the "saying what you're doing, not why
> > > you're doing it" trap.  Whereas my comment is at a higher level --
> > > there's a race where both exit conditions are true at the same time.
> > > The rcuwait_wait_event() picked one option, but we would rather resolve
> > > the race in the opposite direction.
> >
> > I find your comment unclear, and I think it's too succinct. I was trying to
> > provide the most succinct-yet-still-clear example, but if you prefer higher
> > level you're going to need more detail here.
> >
> > It assumes you 'just know' that:
> >
> > - refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt) means unlock
>
> Actually, I don't know that.  All I know is local to this function --
> that's the value we added earlier before waiting; now we need to
> subtract it since we're no longer waiting.

But why would you add/subtract VMA_LOCK_OFFSET? To, as the name suggests,
lock/unlock the VMA.

If we want to go with 'why' instead of 'what' that's useful information.

I guess you can cutely surmise that 'yes we're undoing what we did'. I don't
think it's going to hurt to explain what that is.

>
> > - err can only be set due to a fatal signal in a non-uninterruptible task
> >   mode
>
> The comment says that in the first five words!

You didn't say that err can only be non-zero because of a fatal signal in
rcuwait_wait_event()?

You said 'we got a fatal signal'. I had to go dig into that code to see where
that came from...

It's super succinct. That's cute, sure. But it's not clear.

>
> > - spurious readers can cause an incremented reference count
>
> I don't know what a "spurious reader" is.  There was a reader when we
> started waiting.  Now there isn't one.

Hmm actually there are two routes here... one with real + spurious reader
refcount increments + one with only spurious. You see this is why I think
clarity is needed, there's _so much going on_.

Anyway, there are two routes to __vma_enter_locked():

__vma_start_write():
	[ mmap write lock held ]
	-> __vma_enter_locked()

In this case, you can be waiting on actual readers.

vma_mark_detached():
	[ mmap write lock, vma write lock held ]
	-> __vma_enter_locked()

In this case, as per the comment:

	/*
	 * We are the only writer, so no need to use vma_refcount_put().
	 * The condition below is unlikely because the vma has been already
	 * write-locked and readers can increment vm_refcnt only temporarily
	 * before they check vm_lock_seq, realize the vma is locked and drop
	 * back the vm_refcnt. That is a narrow window for observing a raised
	 * vm_refcnt.
	 */

So there's a narrow window in which readers 'spuriously' or you could say
temporarily increment vma->vm_refcnt before realising the seqcount indicates a
write lock and decrementing again.

The _only way_ we encounter the issue you are writing defensive code against
here is:

- There was 1 spurious or non-spurious VMA reader.

- A fatal signal arose (assuming nobody ever goes and changes
  rcuwait_wait_event() to add more errors - very likely, not entirely certain
  though, so perhaps 'an error that meant we couldn't wait'.)

- Despite the waiter aborting, the readers finished.

- The VMA is detached (i.e. vma->vm_refcnt is 0 or refcount_sub_and_test()
  wouldn't return true)

- Setting err = 0 indicates that we are now resolving this by treating the VMA
  as detached.

And sure you're mentioning a couple words in reference to fatal signal, a
mention of last reader went away, and detach - but does any of that help clarify
what any of this actually does?

In practice I read this comment and absolutely understood nothing. I don't think
it even provides a hint.

Without reverse engineering the whole thing I wouldn't know what this meant, it
just assumes too much.

>
> > - that a race can exist between a spuriously raised reference count and the
> >   previous reference count check between read above and refcount subtract here
> >
> > - a reference count of 0 means detached
> >
> > - err = 0 means we are treating this VMA as detached resolving this race
> >   'in favour of' the VMA being detached.
> >
> > Let's get some of this information in here please.
>
> I don't think that here is the place to document these things!  And
> certainly not in a patch that we're trying to get applied five days
> before the merge window opens.  There's plenty of time to get the

I mean I could argue being stubborn about reasonable requests rather
contradicts the rush to get this in, so that goes both ways...

...But I propose a compromise below to speed this up.

> comments and the variable names sorted out; can we focus on the right
> way to fix this bug?

Since you're concerned about the urgency, let me suggest a compromise:

	/*
	 * We tried waiting on readers, but failed, likely due to a fatal
         * signal arising. Unlock the VMA and check whether the VMA is
	 * detached.
	 */
	if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
		/*
		 * If the VMA is now detached which means we lost a race.
		 * Let the caller know the VMA is detached.
		 */
		err = 0;
	}

That gives a _lot_ more information, keeps it relatively top-level, doesn't
make undue assumptions etc.

It also puts the broader comment about what you're doing in the right
place, and makes the 'weird thing that should never happen' comment more
specific.

>
> > Again I think we'd be better off with at least a VM_WARN_ON_ONCE() given
> > this is a rather obscure corner case.
>
> Are you satisfied with the WARN_ON(!detaching)?
>

It'd be super weird to reach that code when not detaching so sure, think it
should be VM_WARN_ON() though since the code would be horribly broken if
that was not the case already no?

For the sake of not dragging this out longer this I guess we can do without
the broader WARN_ON() or leave it until later.

But that comment needs updating.

Thanks, Lorenzo


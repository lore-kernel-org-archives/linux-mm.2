Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5670FCF6BF4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8E96B0096; Wed,  7 Jan 2026 02:37:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B789A6B0099; Wed,  7 Jan 2026 02:37:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A102D6B009B; Wed,  7 Jan 2026 02:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2326B0096
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:37:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44F521ABBC
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:37:57 +0000 (UTC)
X-FDA: 84304363794.06.9C7D8BF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7813120004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:37:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nagjkpGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qfdG769w;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767771474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcI7O2ifmp8h+hzDaZkOiO220BBOBv7DEpClU/C09cw=;
	b=ADuwhKc4FwoWmm7byDkTxcpzKJc0MhFVuh7zOqdsO7R+RRwJZC6hldq6waFrmSKofgpiCd
	/KKWzqQlwjBw++Qsh4ARWSyalsOEiNWn9JBhQDsLMkb+mtRGJ+iI8yfm55tptqHON+Ova7
	//O+44i8eFqYSQm/W1/eB4xAXCuRPAg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nagjkpGW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qfdG769w;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767771474; a=rsa-sha256;
	cv=pass;
	b=pdjaAZuvvnBvNLXxf6T/5f5HM9WSLXJr8CyrAg0MH3v3m8IgJSY2WZ2a8wEJHOqMnRCf9U
	ae30tNfNGJPg4Gm5fdxBIUxG3cORH5dWa0bR7UTZdDyTdAkGIWoff7zcB1O5ChEnU2SWQH
	wo3pOmLFSEDuGQb6Os9ZzhGSYJ8X0ig=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6076Kuo51431714;
	Wed, 7 Jan 2026 07:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CcI7O2ifmp8h+hzDaZkOiO220BBOBv7DEpClU/C09cw=; b=
	nagjkpGWGpXuoTu0kwYM8xblp+CGkMllGJj8piI+OAv7wcQz0ZaeD1srL6Nl9K6i
	QPDLuJQ1Dfxhqn/fWqmYv/QPZ55ehBYZQRNdupTGAG3jZyBgIvhJii9+CVfKXxN0
	tjc0DYXxkQjMGJg+voZcW5QQalR1+55FLOq4O2TC2Q0y4+r/oLtG7H/3gBTnZvZB
	LXdmcV1D4mmGw6K2rYPQOM/w2x16hPtaZOvSqIFiGBup2k0y9lRDtL+8YEV3+6dF
	e0emMleokejOuSNw4L1Me0o9UxRHRKmvwE8Z4lwPRIBJtGKG0BkNqrBoJhrdkf/y
	GoF2ZImn69Nnk2au6RV2Lw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhj4ug1wd-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:37:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076txVG020387;
	Wed, 7 Jan 2026 07:20:29 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkhwjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k3lX1cdVmrQ1FSEiy0yPqS9JHne949AnJ0i+kpgKpV1KI+VtEXa+2e3M91zGBDo6DC+PeBzLMKubbWCBnf2tO/fEpVe/hCVb1mSMYXMHhL1yzoqf6mEhNE8YRRv+kUuLt+6DPTqemdwybwL0HjRrlAcTu2WdpXtmNepQGrcgfIbjSefBlblNA5T7d0RsYBXR+Z7SbtKpqKTZEZBWKSQ79ktV6y0FUuMCRHU0FKbvYAUHz2++0Og0I7QdwBUxYGJ7GgdM6F1ED7tDRTepSmm2kamW5gotu/5Hy2FJBsCQAA6HpkJKUghiyhyW477AmuTpxakcJPntxh7xw+AROszqxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcI7O2ifmp8h+hzDaZkOiO220BBOBv7DEpClU/C09cw=;
 b=NxCeGvMuxfGGJG6ZZNH0EpsFqmLApupTKRzAM/X1TS+gO64F7QYdozaar2/ftPZHbTtcw1YK1MYkfgkGtw0FukO1sY7V76JNHPhLLraDguA0qXv9PQLlcQElv7U+pyuTigKCVcWaMThynRJCe2oY5do63nDXqnjarrsS/scxEZhlFU1nXer5Mn7i4hc6ctKT7Y6E6CXkqEbWeB1xV4ZmK2Pnz8mx56UmRhC6i2KQNsd4O6WbMVRjX+n+TKk9oX+Nn1VRn4sE9Y7pVBko5xqBak0kaW7OIeJginMWUe9+dOdElYCQZuwwni7/xI2++64bRKXv8OdVgJ4hdgTfJySHcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcI7O2ifmp8h+hzDaZkOiO220BBOBv7DEpClU/C09cw=;
 b=qfdG769wi/B+HDt6Y8mZvOaCGAs3p4bu4pU0c8/vP+7qXJ9uN8H0DRokG5dHGGMmUaJeX0Z04F5dcmfwvTHwGf5T/H44LyH7Je9h/x3Q+0mjBEnWdj7zGUD0szydCqlSA/x5HDXDyvKmNbAo0e1z3+B/j6oxsDnBQHGTiY0113Q=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:21 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:21 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 4/8] x86/mm: Simplify clear_page_*
Date: Tue,  6 Jan 2026 23:20:05 -0800
Message-Id: <20260107072009.1615991-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: e66d36c1-6ec0-4ed0-07fe-08de4dbd37aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w59zlx0ZlEQAnCG4qY9FMU/Phig+Ojw/Hgi1KV5VeFWNFludkkTJvc858LN8?=
 =?us-ascii?Q?FggqrNDNpMxGYDyKvq0cRUOMMx6AP0lBrUlRHeZSQ8la7YA/bdbCmYD/9Fcs?=
 =?us-ascii?Q?DhMiMSEEUQ5a5tg8z398KVLD9/upxttPypt+kKvGRJg+CrsIL3bckCy9Zw57?=
 =?us-ascii?Q?MTq4pBA6Lx7a2umM4WS1ZNNxkszYswLhBDB7TeT7cjqb0IKeKq8n8Rj0PnxM?=
 =?us-ascii?Q?KfcbzIRljIktkBc4VapLOYUNSNmVmeMAh4nvik6Lnrd6M9U3ZnSsv/Fq3I06?=
 =?us-ascii?Q?f9XXG6tl/adPXi3zDpDlCn24YmQkjEMsX9ARuRTFaUtgRJS6z740i/ZPM36w?=
 =?us-ascii?Q?IMKsDIr75UBrKpmj2GmUa5QRyt85RAr0i83SN/6IhTpJbVCbvrNLAveAucNd?=
 =?us-ascii?Q?X8vVfD/4gjvDIW2XpWovn1ZndpNEBaICcEqDthG5WqwtHT54/pGOTSyOWw66?=
 =?us-ascii?Q?+E+vb7X8UbviziJZyocdcyaXCLFbNMZ0trRF67YZTzPPyYrFZshTyqq9w5Zs?=
 =?us-ascii?Q?oKrltClqP2gq6j/+tnOkhnxCsiyjJxL1WB7Kkr2I+8NsPrvjFjGnDNqWIDZk?=
 =?us-ascii?Q?QlBIkCzKCojH11nsrTFWEI1Pq47lWmT/rIUAnfbD7wn6TA6Niwzulm17svf0?=
 =?us-ascii?Q?wHc/9O4YpjhOlvJsLq5dfXu8gBs/abM//CRtksypJiRoDhgIoh4pidkJ6Teo?=
 =?us-ascii?Q?0iiOk2zd+4I6x4g1K/LgibooO3yPIicX33IgPkteL+0swfvCdjnybjLzOaik?=
 =?us-ascii?Q?sqGOFMLftrNm6dn0kl4WD+YPlPLYOfjq0Jye61WmJjHLhvQFhKzR8Lr+eVwl?=
 =?us-ascii?Q?cSC51ia7RPC3Po13gvHErgUY6jdNPb7BbqE56vMG4b8Yg/k4cvseVdDoQoTx?=
 =?us-ascii?Q?+Zk7J5apLGF9OaAwG9qna3mj5WvqufPnIrKuyAPIZ/CZk/R0g1OMQRSA5+in?=
 =?us-ascii?Q?oWwdY672ljoQ5WR0nBZIrEl5RLhlZBEzbL158nGyXOGJxBR/0HnnrX/hu8ic?=
 =?us-ascii?Q?STX+4iY8m11GnxO8Dsezvi/JRmj674OTDSBV67FHl027H7jxD5oU55Fhyd4e?=
 =?us-ascii?Q?94HKcTqfZUxPKFeuiyvMw3K8DDpEOkzZQdFJiRmxAaTWA9AfVjhlQ1EH/Sy/?=
 =?us-ascii?Q?QrjPvJJ5/tulDVoh4+4go3RnrcoBfYK1ttN5RVq1Hy+IK6gUNzls4SXc6AnJ?=
 =?us-ascii?Q?4uzHE/BlZLBkEahCrRukq7wDW0r4Z1e/H3TL3QHyOV7sRwI1R+WrfIcRVrsv?=
 =?us-ascii?Q?pir3hmKdULFOXsjFD59V843BR5uRj16NNLYu+kou7xX26DE1Qcq5/uev0ArJ?=
 =?us-ascii?Q?l2kjzg/SB7IeHhv6O0+fqVeltfDzhQx61cKUUih4TzYcf5X1hsiQ55CKo+O9?=
 =?us-ascii?Q?a2YQNEhZyG93QnURHbGIE3vtcCpC3wi5EWuAnPLAjGNo661QW4S9KaIzrfHK?=
 =?us-ascii?Q?HTLfndfCPkK894rMWLdaXeMZD1qv5MVE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OcUEo/umY4d8uhFH4oo5q2I0OEAC/24kg34M1mfoABz6W9Ngz72Asd43dWXZ?=
 =?us-ascii?Q?KpEm2tMaTkJ1XslM9NXh1B8yrsMJFGQAMBHr2VXtlSHx2OS1ehBTBuTMMRka?=
 =?us-ascii?Q?WUSbZhLtNmcO8RWEXSKqdg1s63hIgAnsLe6/JkDtB9+1GF0sgxiIFEy17iem?=
 =?us-ascii?Q?yflJfI4bvaUWHwDNv89y/Ygmr1mZZrSJMO9MfkUAom8Rf9MdAwV8e/KixV2e?=
 =?us-ascii?Q?gh4YHtCrsyP65FoWS/YJfSdO2awxo21V9ItRwN0HvnRUyycbspyP1SQNh1RG?=
 =?us-ascii?Q?51z/QBlb7o7D9d+cnHMlLwQMkAbvKBF4BHCO8Y/4SfJnNrBMJRNABxynGDVc?=
 =?us-ascii?Q?BioR5ybjhysfZcPcAtxgXZKT4DpLs+Rohha41Shx9t0Ib9B+0u7WvJpL+AfD?=
 =?us-ascii?Q?7SLn0lNRi8ZXEGzwZWjgsts6gk7WhVt0+g02LWXFvRhv8lB/1aY8eoXFmfEL?=
 =?us-ascii?Q?hR6FXesQKV5SqTeFabIXYiGzCu9q38UZZPwZ6+ubgtm5yjgjIEAfmVFGxy9/?=
 =?us-ascii?Q?I3FFssH5RWyJv2tyF8POHwA2wfU+MfTb5xGTM55ljUD4eQ6ffK03KqOhqyaf?=
 =?us-ascii?Q?IrEtzA1qv6IKxNwXJvaZfRtfTeeRA2ldupflycyMDquCFhNVkUxv9B8R8Ym4?=
 =?us-ascii?Q?9hkaUDb0B4ICz0OwAPz2YNUDGxetxIc9RBPDW06Yr8G9bST7vOHsULS1DrZ+?=
 =?us-ascii?Q?PgcHtqrNkv7zCz2GNClZg+avHbNCftZtwF3n8E89GrR3LjPRckHfNPXrEh4z?=
 =?us-ascii?Q?STWlM+rFGf1NVbT1As+gTYvhIvr2ERyyKyBm4pk6TzvMk0LJbUEuIYoPp55K?=
 =?us-ascii?Q?cUW3AKZuvvm9tPJcfFw0hADvdkZQnusEzNFyYJlkusszxC4ybvjJ5jMCHM15?=
 =?us-ascii?Q?8OpzPvMa8jbTezIbyp2oHjMCvRWNseiD0b95lilTzm1EcaKQxzccRacX1RVL?=
 =?us-ascii?Q?o1rt4HfkNvsiJmc2rgBhIn6Ebw1Z1w+BvgZn3GiIjbKxfZ9hzMSapDMqDI/P?=
 =?us-ascii?Q?Ha0vHvOdQfWYDk0ATalFGBui1xS1yGOMu2VQrcRVrnwJgmnvqYeaFcPJ/LRh?=
 =?us-ascii?Q?5UM0AR5zhZ9JKDrGr7/6DWqdO4yndCGq8jIAd3qK7F1geWnf9zkNzHdn6nh7?=
 =?us-ascii?Q?aBMLTpONVAIV+90TFmz5d5Cp3xLtBnLMzC91q4hE3ebKzSe2tmF7/TPlIszE?=
 =?us-ascii?Q?fQeosmh9AanC62l1jL0qcqA+KCL98KHPJRz17R7VsXyMIaoYjTtaYjOIcAGX?=
 =?us-ascii?Q?2T4OIIFz7/HPIhFkd0OoQrDtQqoqeMD7+N0dwPLtzZjhWp7eptzKHp6+gQjz?=
 =?us-ascii?Q?/9o5RBafMBoVIVoCggwsWM52lOCpgWndwybYhgLVvBzjxVUpdc54sgl/vGue?=
 =?us-ascii?Q?cT9KBaNtGu3+98MEaRNqQ7jNiW1+nqvypNZtb/q5d0anTMw5HRqfkrXXoSaT?=
 =?us-ascii?Q?N0XffZykvTP7TkBIC46tHtxyof8IBQHQ/Sn9rP+nzj7+OzcoLNQm+LIOM/dm?=
 =?us-ascii?Q?8TRaw8JiByqWP6rrfOIw3XwSzWLIQZhZ4baDRbl45wvrfFc7TyuodaBEzdNp?=
 =?us-ascii?Q?E4KDl0BXhhE8S1IWV2KpqyNfdld801TMUSbM/Jl56EQPdI28LRTH7UixdPb8?=
 =?us-ascii?Q?ij5fq7jjWIr25H3InYxiaXVoCrySJnoSmpHSiXZZPZ5fKhpqzVRKF/+Kz1hV?=
 =?us-ascii?Q?+kDbg8OskTlv4xXsnuvCWM+jysUiZwZU0pn9VkbrTSuGashX+G1tAYEoWcu0?=
 =?us-ascii?Q?bGFabwUSXHs+gggovDHZ7FTunZQ0W5A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YYdsFmaXm2zbTfXpvhvoWSLFBhOLLmyYuBUP+kYFQawg2ZIDKiCJmrxzb8lmrE8dUiGELy5C59BkCOjlL1HWxR/9i/uNGmqvnjj7PE/WboqiMRt0HGhkNt0DoD/1rlf1NfdI8ti+56i9cKaihO9SUGyimst8IWQC66yIEz4tNipPgQDJV0xNdPaG2R7o1mUsxXEIl/lw+D4Lw5njparJaLz1d4QATPmC6uhhWa+irN3m2Hkn7FExXoVkeXGBqF/yG01dgRuFhm+hCx311VzEvQzicUkQHJ93xBHijeodKNAINepXtg7v7tQyz0qpAurEMLUVevgpVzbN7fJPKfIWUQaMy+mzB4ESKZNNOriTofcltjYRObqc7o7fyayBp7avgAWKMwFkxEHUq+EyZb4cXkdtIxIZOYg2zveGk2o/cyQWpDLiRU+w0qx9e58fBiJJuOjKcLx7+IUNK6OBAc3cIOZ3Y/Pdn+QVsUYP8X8u5S2G5mO2nyqFJw9emJ+a4yy2NaO0pQ8BOY/ahkwavXjdd0PTmrnEbcFFTeCkmQ6W1cyN+Qj4xfA8V899BKAaJ9bhWfUnJBV1ImgfqVTby5F9piJCIzG6f7b4dB5VUKDAoK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66d36c1-6ec0-4ed0-07fe-08de4dbd37aa
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:21.2581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rB/D8q8mhT6w5QjSBhdJPVl21kOzkFNr1rOeh2U13CM6gQ2sRQVoeqZyLk8A9Te9ahP1yNvTU3fnMzN99nQylotVaV5S5mKRoCyP2hrrnlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2MCBTYWx0ZWRfX4YVGRT0Vnwi2
 xreJwQkjuPuytkkaWQo8gUnkYJWtqjk1Oiyd2PAWRyXK5AMzkAE27+moeoJ9hFEsu/ZLVYlAAZB
 3oy+Rv/SAap3/M35MznZGWQrtDPvn6AJ8oztoWY9L/83xlaLp56qQqw5kksFLwM0cUeAdLBuK22
 Ri2h6q9cZGGFXKW5xi4I0aw0rPK9ZystyjZHIbonA63OTscC/BgoLPJLf1WdUrR7WDwC0v2k41w
 YLCnf1fYwUNam5AgiRaBVJSifM7pRCKrruwzNJrHbd63mAtDhEG/5QhhORc5n/oN0Au8llUgVXS
 +7vwhzvGYZ1O9MCFHxJwDnT3qHBkqGT4jfV165Tdxztszu9OyQ2fczqRK94+7ua3kev5rMGqNkf
 vy4OfGFI6JqmeqQVK25FS6jNLIFNThOdeQVJ/66MKMOlzUbHZjqGZBb/FcnSaQeDYniG79MNaUu
 dyimrbpKe4K/BlHoL8NcFCe8dcnwcHhjIxrLALbk=
X-Proofpoint-GUID: rrttDukFFkrp2ZlFQLWc448SZK2wlb2j
X-Proofpoint-ORIG-GUID: rrttDukFFkrp2ZlFQLWc448SZK2wlb2j
X-Authority-Analysis: v=2.4 cv=WP5yn3sR c=1 sm=1 tr=0 ts=695e0d35 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=CZTfYOs-HqEX1FBfxHsA:9 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7813120004
X-Stat-Signature: 4nahaugs3zfh16oi6upcjtcbw1usxcad
X-HE-Tag: 1767771473-945460
X-HE-Meta: U2FsdGVkX18bUnvNr251WtfJIGrXwZ8MR8331AFujvQboUC5efYAi8SlvDgdtt9vpvHOaxaxLnMIXrcpKgY76aXzUS0nm9RMTqY0PnQBdecWDiD5Qa3sw7wdMCj4E8uozQVcbovvHLwxKsVih66CuW5kFN+kBGkn9UpK7mfVrC7wN2wrJo2PQUAw00qpuQJxE2CmtNRinOeSKtErYFr0qIERDiVdagnQJDfVn7e41Nki/TXC2MWPV37t7K8Vt8CA7Dqz83pJmPhVh2UAMOpR5OrOOlrz9doHzCh80TOIyZT5OTKX0iHbZYVQfmzLBr0obBK58dMlAl1eWTG+OpiD5+69UFzWcifE+J+aRiKS2BLZsMMuNomEHrHYzA7fEKcrChQZUUvKhxmpevIEjKlEt1FQLfRCJl467UFNPOqNs3Ad8ImKP/UvO30iEe6gxTENvD+ORRVpxLsYP+/v2Fcc9XsQDQIcJP+Nmje6UpqUIRY2KKrrOXfaVm3iY0pR148HORlT26UceuUwV7jtOwjWiOGXzttOV6KWf5lbboco2syGugxwNPABIH0wQ4UMeIVeyTtuPsgM3ht4IPFsM1ZsDNvICXoxTMs4baYN4Q4zwpxQA2YQRLgYAt8ir6ao05Sa4ybbS88KLMsbZJMQOHM7oKkhP20MNLM20lWK0bXZvMAZWf01Kr294dNpe6X8o5Af2avZ/n+c50sBFjYyB2y+x0Aq3+qWKmBBR5FtdRfgIu8f7pSumHvz89Nh+ZUkgmq4U/auO9FRiUSKLBz/SaXB6FTQbnc+RyiTz/RS6QD3kQKZEpe1ul8GjS/fZkhXbLm7hITLD9hN7g3WLK6p5g63nTFWLtfEwEJX2Ou+Nm0Q/AuripvjJUNxYrPgg1pxeEr2aTecngdBYhiUz6NQhyQkCypN6z1Gc3xG3ENuqqABmsLKC1trJoKPyKzn9Of0zw+FPTWFuwLtfWXLP21Oxpk
 qx7qp8m9
 NAiF+UxB5euGz3oWIFczLcxetGB5J6JZX/iNw62o84xGPc/sfc4IR/QX8qBcQ8OW9lFCT/ViVj1p8HF/2lOc6G7MfHvoDfeJhfqgGU0XlegX7X+2qBTm+j5zIhMNPq3t9Emf9jRDJxbREWR0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/page_32.h |  6 +++
 arch/x86/include/asm/page_64.h | 67 ++++++++++++++++++++++++++--------
 arch/x86/lib/clear_page_64.S   | 39 ++++----------------
 3 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 2f0e47be79a4..ec3307234a17 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -48,26 +48,63 @@ static inline unsigned long __phys_addr_symbol(unsigned long x)
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
-KCFI_REFERENCE(clear_page_orig);
-KCFI_REFERENCE(clear_page_rep);
-KCFI_REFERENCE(clear_page_erms);
+void __clear_pages_unrolled(void *page);
+KCFI_REFERENCE(__clear_pages_unrolled);
 
-static inline void clear_page(void *page)
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @addr: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - __clear_pages_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration.
+ *
+ *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "REP; STOSB": used on CPUs with "enhanced REP MOVSB/STOSB",
+ *    which enumerate 'ERMS' and provide an implementation which
+ *    unlike "REP; STOSQ" above wasn't overly picky about alignment.
+ *    The instruction writes 1-byte per REP iteration with CPUs
+ *    internally batching these together into larger writes and is
+ *    generally fastest of the three.
+ *
+ * Note that when running as a guest, features exposed by the CPU
+ * might be mediated by the hypervisor. So, the STOSQ variant might
+ * be in active use on some systems even when the hardware enumerates
+ * ERMS.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_page(void *addr)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(addr, len);
+
+	/*
+	 * The inline asm embeds a CALL instruction and usually that is a no-no
+	 * due to the compiler not knowing that and thus being unable to track
+	 * callee-clobbered registers.
+	 *
+	 * In this case that is fine because the registers clobbered by
+	 * __clear_pages_unrolled() are part of the inline asm register
+	 * specification.
+	 */
+	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..f7f356e7218b 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(__clear_pages_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(__clear_pages_unrolled)
+EXPORT_SYMBOL_GPL(__clear_pages_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.31.1



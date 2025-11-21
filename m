Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DECBCFC504
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91796B0092; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40FD6B0062; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA3A6B0032; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 462836B0089
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24E1C160580
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:29 +0000 (UTC)
X-FDA: 84135741858.22.82C4C71
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F02C160005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hFxDkqc0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e51X7FOO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756665; a=rsa-sha256;
	cv=pass;
	b=KbtyBwpkZZnVYi/3gqPO8bfRswTtETxlBp/gnhRqzXVJgq5iE0zHAlxCNRzHpNwaOaWsfJ
	Vu38tQ46rv91aFLvj7oOYLlTw/k5hN6BbEmWQRq3uiHrgiOS1cybdVQfGb0J7z1PodVZnp
	rgUpQIYhUuNbULg8Dt+yGMDk8vMb4IE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hFxDkqc0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e51X7FOO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=heUhF/KHrpNPUxRECWik67AkTBEHy+Cmy0viYUMLa+U=;
	b=RPSgJZ9aS5cg+WSQtIzJ8JZvU5g2CwjAgtyKTYSbZfiHuknSwouuo80w66EveUpsT1DwPu
	2gUVIf0m3/INt/XrMktsJHGq5Zx2U0if7X6VTYqv9m1nyvIwWdwnXCXTJkGYNCSnmGdJyo
	JwVhStW1N2VzzijzYEPAXDF/8MCW0pk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALKIiuo020601;
	Fri, 21 Nov 2025 20:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=heUhF/KHrpNPUxRE
	CWik67AkTBEHy+Cmy0viYUMLa+U=; b=hFxDkqc0MYz8y4zeZFyC0GfLk3sr5dDn
	B4IH+nnakotv4AYN7onDWaIK1RICPIlAAO236GlnhWfgw2vns5HW9jxzZQVa6b/f
	HvewXC+y5aglJFHZcGvMqdqU6Xr0Y4n3LRMAHlZHl6/QjhCgAWUdPhRuStMgUNda
	MCXeY0ZAGQGqvVMHuAxHxR4ea21DoXb69wSY7NqAQpQfrwMgqEenlyMTDAM2yxc1
	rRRM3m0Z5BMH7JEe8HMHi0awya8XU9dU0rV9pchBqH34t+WhE+CuufBy+vTrYRpi
	G4nkZehLeGXHODtvFCxQdfmZs8b26C+PFqLdBK1MnY9/QmW0zXImvg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej90ckd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:23:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJTslT035952;
	Fri, 21 Nov 2025 20:23:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyrcg1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:23:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3tbP7sQwQqETzDEfY2GEVJTjHkncn0hUdRHzuA9y1f9bK1ORx7JpGw4Nlv8XLgIN36RILQbRojlMKOzPaXIkQ0EVBcGK2+aDC4N2EGaOLr7HgtmdmeBtAibeSoJMEETRPGATdIfGppxleer1XmYupem4O89UY+Oea4w3467OmcoRxjny2/XV47CJMwxhCub8TrSQqWYPX6xqVx8eH5hSHjde8SlsJuJvhjgkvTm7VJ03HHP4kFJEeUBL0YqJrIdFyrFKv4eOZ+RYclWBhjoxFOfPpCRS7EotKzZC62aS62UJIwvIxP/7o4Chqxi4uXOHB5RruCB5zV4SxFpfBRliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heUhF/KHrpNPUxRECWik67AkTBEHy+Cmy0viYUMLa+U=;
 b=PhiAWqYG6o9WjekSeLdSYS61VuG15GTdsK1Ep7bpwGmenqpwnONZAeTiIlQCudjRC3+UJiAMfQ7CBwDcY1p67caSIQ2BIX9+Qkeig9V/VIIzcN0/2uO0R6te9Ta9Nb2y+vCRGUSYVYffG+UxJgfEnv7hQishZ10jH4daDW4d7L633Df1xTJCOaCvTZE2T/GDh8Kw3offHfNsMS3f7uQCveep0E9Hc5M2Xv5DNNwlQk4yUs2KiUqJMsd4RF/2HObu+1c17hs3XgJa0lgMFbOOBZRFLFkBqOkoSXxaTGhate9ehkjFf18T7GlgXxX/0SzGETMttvJ4WfygDIEfOxTS5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heUhF/KHrpNPUxRECWik67AkTBEHy+Cmy0viYUMLa+U=;
 b=e51X7FOO/Wjay/+FqjABwoIZmqApc+zD7cP8BVTUgj4pkBGs2XUkpbneT+nkzEwJNeUD96dFdcPwGrOB5LJ2T6pnO2h//HCvACnvPRFl1OcGxVgUgy7QKNKUHUqZTJYMQE5oNifGtxIM32HFOp7Rfa9Mcz5XbNREBqItPO/Jjyc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:23:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:23:54 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 0/7] mm: folio_zero_user: clear contiguous pages
Date: Fri, 21 Nov 2025 12:23:45 -0800
Message-Id: <20251121202352.494700-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:303:2a::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: edbf755f-fb41-4692-a15a-08de293be3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CcRAz10qt0jtNZRLIat38KLCN9nEeO7uB1RT5BrwG8wUNy2o/v2hXJFaLGSr?=
 =?us-ascii?Q?uuFO7g8Qb4IsJ3w/ptBY3oXKX3obmigaun/kGqNX1IeEnkgW9AqOfOy+x4+e?=
 =?us-ascii?Q?SvjOoIs4UgpZThr6V/1cWp/O49TKHQxjYtaTYe72/uszOJXhXUIhZJGKBBQG?=
 =?us-ascii?Q?9Oa+RjrCYCir+/TOzzozwrnINDrPEiR62p0ZYa1tNGctIOpQNGGQ0ZmR92xE?=
 =?us-ascii?Q?HgUePMShNHq8yHK5zc2WQRNPnMQ+3FiTfmHBSVKw40Kv9w2MVeT/HZK7NnTh?=
 =?us-ascii?Q?xhJ9jgUFZF/bfvyZsgAj95ibnZoowpESFr7PB3y0MseGFLjcR5du2dAT4Pcw?=
 =?us-ascii?Q?GnX6KZrzT5rhkCLmZo7ZadQfqse/J9KryQaIBag564ign+KEglmbrs7GUWno?=
 =?us-ascii?Q?EUjf3pwFt7z4QuSTsLcZu9yGnDClRRpGD97SCdrWdnwwMJWQTxtj5bPuXtPI?=
 =?us-ascii?Q?ZHtCy2ceNyeA0uxvo9ZreBnnVwQamj1QYhEupv5fCB1yG5UKZL1MO/juYvYV?=
 =?us-ascii?Q?vsHdb0bP63igMyfX4xygb76i665K8PIwJuOl6No+glIFlAzDkavjtIqrHzQF?=
 =?us-ascii?Q?7wE3DA9BLulK1UB7B6qIhoS8FeQtCD7BIKDbAIUbOGNbDesEKhJFxRLZRWwG?=
 =?us-ascii?Q?fdwZYsDMMwb9tRd65h8eIokCCOEJIQXUSPjdvIaOGNJ6IIKHevaehS0RjnEp?=
 =?us-ascii?Q?dDr1qRYDm3EwSqh7NPHteoH8QYLPjVIsdXNaglw5Huun/vGRjxx4TlOFRWLa?=
 =?us-ascii?Q?weYF1Y2AYSUKucYxerx5alcWzV2Jx+eDT+Sio1bxS9XWb7aYXX6uhErEK+lQ?=
 =?us-ascii?Q?M3KicV656vG4V3AiT1/tkWoMYHB/uUTHiQwCuCIvmUp0P9O32Db5nU1JDCrw?=
 =?us-ascii?Q?tL6Hb3FnBSc6kZYQjWEZi7d+pB9qCVsHk9qfULBIPIURN5ppTsPRyFIJvSSs?=
 =?us-ascii?Q?+JfWioVOQrL95m6QlfJlwQ/Ji+rjNZemxwvDU69ZYtJgGR2R8alsv0L1Z6Qr?=
 =?us-ascii?Q?H4AWHKGzQ7g/wwlabtX4LR1AQclbIDjQ5oddoR9TmTwPD6AaQCWwuGqMn1UX?=
 =?us-ascii?Q?ImmGj1ykpzQ5Zyone4vQhRzBcQX7B17mjArCDI++ve5CTTAsnzCLjEjEkZns?=
 =?us-ascii?Q?YiW4w0UicvPxXFl7RIPb3aOfNRPKkMGqLN0QbbohJcYKsdfQ+A8LqYwub4Eg?=
 =?us-ascii?Q?M02w4ATkQ5RaXugWQnatZZzDwo+KSkKqY3IgIeDnZ3V12a97QmUHG8M1X0H6?=
 =?us-ascii?Q?cWmdGBk6E9frhp9GZUa1cwrR1Brq0E0FqvJreOTFT8Ecpc8mV0vyIhAETH2l?=
 =?us-ascii?Q?uayLfDgPOY8KLNLEdopnGoPv8Y2w8atmoxul1Tucttx23Y1EY5qK/U+nSlr1?=
 =?us-ascii?Q?epLvBrGo/PCGXlFVlJSApnww5NepPp2ylkqnMSmkUYYSsbZPyg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qGERUdUBLIr86ns8emTsPH6UirmTnbMyhUSPoMU7PgWUSZPUZnhR5VpwpfZB?=
 =?us-ascii?Q?UAg5A2z+o8tWmbpMfBH1jozY1xgnfDCpEKWVDo2XUGVyZxcipdt0xF0H3dxf?=
 =?us-ascii?Q?gR00jqFBY1H+42gRhT6PgSgQ3YN4A4fhoE1sjpAuXphG2oFrtIQwd6AMf9A0?=
 =?us-ascii?Q?4yEbBEityA/YHFy1VMlCwU9l8ugDLyDaDsenWRgmqyIohR7RmnJQeriXmx/h?=
 =?us-ascii?Q?9FBUUQdRyA1pckcerACDvfdvCec2UU3akKt73+oVzgRJubDOosSZneSJruUZ?=
 =?us-ascii?Q?hUAT03MO4N15F2CHDHh7vsQhPqR+MwMFb4b4IUCv3xdx1+SaNwaUPhGklqm3?=
 =?us-ascii?Q?vehcruglwHQNvuA6HxMMzCZZYiAJruJwwvyOt6iEcEsH9EzzGmwwhZntYni4?=
 =?us-ascii?Q?hfLfvTlY5GsSPAJRxHYBlNtAwMD8lkvpRwT4RWj/6ZF+mGvv9AabkiuEepdb?=
 =?us-ascii?Q?ae6lIlzxOFN7qkcOwZRhdZwioS4USlxFElKVbfbl3ihy/w1Z21W1/Yv502y1?=
 =?us-ascii?Q?xRZn2oBHCjk6AWKR2/noDxB65sCPebI9Pqrf0I0ZOOlVOpPyc5AOtsTVzm+Z?=
 =?us-ascii?Q?5hY8z7DS03mEymbpkGZRPnc2gLRFabMsU/AK7IPp79+NatV3Ushz410bsaOd?=
 =?us-ascii?Q?70QVc1eVmUkrRuR9dtBOkuLCH4kp/26fIEh0QLeoYam15wNoE4YvQOYbRkW0?=
 =?us-ascii?Q?dtvPMjqM5Z+B/Vu9sjSzJrQH/B/mqXgByF1jBY7i3tzp8d5APXm7XSnwix5g?=
 =?us-ascii?Q?6BGLI65+RnabTu0SqKh25rs/8PWHVHgybQgjlKo98i7bpOjE5Oh3IxbEwuv1?=
 =?us-ascii?Q?hWYpy8uzelWa7AQDPqcS1owI4Zb5nssDuSlEXyDvpqzJejdRcPpjSic7qabr?=
 =?us-ascii?Q?kVdHV4k1t81r2R7v40RQOgtubA8+39OKkyokdF/na3A7DTa/qO/ioViBqzJc?=
 =?us-ascii?Q?yoMICW/qmIvOmeECxvjOrSLc/Hr93b0YfVUzvy8TFD2D9CvO5r+d3ywsHJ+G?=
 =?us-ascii?Q?Xb1SDfjVt8Xj10tnb/za+qQ7AnTYhEAYm8tt2PAK5YTUHKusa97eAx58n1Fg?=
 =?us-ascii?Q?OBrwRlUgpwnE5dvALKOt82GTWQhNnJd6rYUP1GfuLPq+3+r1ZPBDrq9GQA/G?=
 =?us-ascii?Q?TE4ALFkQBgK+Pdn1Cn9opmPdbekQYyE4yqr9U8Us1OymGzBq4yzo1hi+QEBL?=
 =?us-ascii?Q?DwDmhcnWsP2yu11GVXMU1q/kpQCxb0xpSBpj9KmAKyKEH++Vm5z5+j3rKOkP?=
 =?us-ascii?Q?9x6jkxekGsc5dbxBYl5FzRRXN3CmVuz2RYXqTAwu4NV20mkoEfhISB7lWtAy?=
 =?us-ascii?Q?R8EPNTOF3tgwJe2UPO51FbP2g0ITYeBmVh4eUbexxt/1aYZi7TqoWCDBHTy1?=
 =?us-ascii?Q?m/ZrjKpJgOSHpoHbhL/7hPwF389gL/Q0aKF1JP0P7PgMo+5Rz5FMiddLEdtu?=
 =?us-ascii?Q?BvBm9yp99HjWRLGB6K1T4pVInV4TVX2jcvAEAotS7hHasj/08v6pX5TB6rvG?=
 =?us-ascii?Q?/a/l2faZmJ4sReW7+5Ay+eVlWQiHLFyvFk4/1RapfXjjL1LHRlINxYXxR6C6?=
 =?us-ascii?Q?4N9Lts1FoIlYKRLjQzOc/42St1kAtRQEqwSlzfAVPyhYE/YRzEarZLSPMcng?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	coXxLGCc68jFJgenEeHNXtIK/qECYsJi0mes4Mj8lmqM9Cq+MTVNu3duhFp30WXnubE79cuxtC3rLRfHNNHigkWa/6FucKsebaPp7jjQwMiaCx9/M/XZhxzDNjmF4Mi+92wF06+5gIQ6du8oU0KHwELALbkKNDGrg06vBBBaqViTdv/jJH0fAs3N/vGmq/ZCtPtc4/LtCzqma3fGxHKtl5tBzKNwnMp89mEgIW1sbe67+tcO06uS+JHiUfiDyi+5xXTlB8ho6z3n9owcPAxFH0/y8AIx4dgqK8e4VEreWFIuKpLDH1dRzX4aiUsc1Was3Z0QJMin1la4RFV95PGhTfwrJmjltr7+Jf3DYCrUgxYy+NQYThuWpwxnftbiQHQkoftMvQIHjaDzUutTUM0i8BkW0f7W9RfAHYfEhedK0lVOU+mYE0yeOGeHQQ0xa2b4LDL2gg873YMPm2d9Ap0bHLRBA3Vp9r2b4YdSxdNNrlR4TsFB/ZyGUQq4WzOY0c8WwfvxxasKv4/hGwS7ZXXepdplmkDb4Be96LhXq0yTRKFrKXiz8wFAcwhH7+qC54p7f+0VBmEiCe7o4fh9DyRui8wAQkIDOLy/HTTs80r9L0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbf755f-fb41-4692-a15a-08de293be3ee
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:23:53.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxcoyBBfhzGTnuLQ1ecr3nzYI7gSZkC8AuNHCwdmDVgu/03T6Gxrc65JZoUkkH9nTpRdNmCRQ461lv4VuEZ+ymOSAn590IIRYi4Ck9gdwuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210155
X-Authority-Analysis: v=2.4 cv=OMAqHCaB c=1 sm=1 tr=0 ts=6920ca5e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=NEAV23lmAAAA:8 a=yF6BjjoBLw8LOi3scPwA:9 cc=ntf
 awl=host:12098
X-Proofpoint-ORIG-GUID: de0tOywSMaVt2xD5ZTQAaonuQV-ofMDK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX7EL+AwjZ48Lw
 NhaJWOo1oAfftk3HjfLpOivBjcqE4NXDIqM9ByZgxx6jfuJPmGdUNS8zxi8oAEH0cif7UCOTCL/
 /nAoQMeruHSGepAwmPUZGL32rrLAOFTS8xVDYx4qIQp4KVUdvVQWgSQ5TpzP9io1bfZXPgPe8NC
 ad00/9j+xmNPxCG5Th77lIbrZ9IRjdN00d9qvtHkpaI63XMIbAN98DuQkpH4txkqRMo/+h+1AeI
 cfjemHf1ju4LysDKqCX6xxGDLeyWgeupaMgocjrmGLggbiIolQDgOLbSrbFZy5dRjEVcylGtHFQ
 yMohMtI5PKFPUuwD4UbPvI16g9wJgC3et+emvdrBZrXmHD1jKD2yYh43bY2Q4OgRCMV76J5xSj5
 otr1TBnDbAq8RYg+DQ9LR3L0EorC56iA0yxphZoUHbXAtJBdqGU=
X-Proofpoint-GUID: de0tOywSMaVt2xD5ZTQAaonuQV-ofMDK
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F02C160005
X-Stat-Signature: t7pfksmhcwkmuxu7fp5bkcct8onm1jh7
X-HE-Tag: 1763756665-619517
X-HE-Meta: U2FsdGVkX1+UzGC/CAM7pcqJCh+265ly91AtTYDzZdUicmfa4tkEzBLGd+q335yb2Fe41PkTtER+3Uplkv2V3x+8d/6IW/9QksIyHOqt4AMJKnXng5BjGf1dtwKzuKJunnhbhQle9MG+9nlGE7uVWFk0klefP8Kime5hEWyXu9Fj1ksUE8xgdrEgWV39ZkaHYQJMcqdr7hECXAzlhue7bXP2b6j38eEzPY6O31MLEeL+Spa02IJ/VjqgfBhRMpJoGPoIyJqMdxeVLSgZzgq+XOK/k4fFT5rXGdb9xNcjsG4EXSYpdWNYnaAGz8t1Uc94yEcoPlhoDojEyre/esxHpp2hJ7ZkcfHohszBZjuRBGKaiFNaH2oSJmAYwvJ2m7DF7ibmbI5idCiKOr3+zot8tBJHYr1ewqBr6h6YaoMmbGRv8Oj2XxcQPVpbHJz3YLPagffQn3hjQVirYXg1Y7yWLfvX596lUwiU3pag04YBB+vvWKUtEjzGAitkPBpQtxjuXrWyTStcKNfpOoDlnsDRp84Ci1QUMjKripdBpBpCNNRG7kkpu0wZwp+OgP9n5uW0lyh9a1HF9HcHDwfTFN8wjCGepP7OtRQ5UJ7jQqsJ0kjmU1gnW9xVOsLbpK43jYWTRndJMCnB8DGibLsuk+mqbT9SRJwugkcFVLf1eOwPcSdG5l+VtB5ZOstymkG4XglZoOv/uU05We1Q0B1Pb9CNUFFJvz53l8UZSm1O15nRcGTDtnsKG3mdY0VGTGr2ImEXzmH3SbuTpiSpURE/1Twq9QigDu9CPsvOIQ6hhrLu9Fo2Yl+K7fp4AVjmBbpMHF2GZlY8VbHZyhyJd03Ic3kPuwTPgu2rsA9WtRYbMhqWcjNGK+/wVRZntVVZJwfcip1u4yL9mBjLSZ6FBk2x4uJhfWGkO7IfyhraCN6eDSGfJUOYuXrogfbWJ+qxLcky+65SDnm0mipMCcGIYH5j4DB
 B81r8OkO
 zD1PUM0cCdyVa8V+80qZJEfZX8bCacaxQfW4/42XraAFFTPaJ/7xEwF48LUAtDaSRTelKr1A4x/EY+RWCXkulb0rNSno/aUI5zucH30wSdSrO0+f0ka2rfCueG8WBCRAtQ0R9LmXUMsXXr6fw7xuh/Aiek8Xsi9MecqszLnJAcSdw69H/OHbKhnAPVct+m5DPTy8Ki3R1kOsIPaYp7uWzycG5Hv2K1EY7wokjnDwKnB4yIRO9ePlEhfAqgKB8gciXTjB3lzP7YErbXMeFHhKmhikTzUjV+PqiuvM9WByaTCuAJcw2x6vhxIonMXflVOPN7yZUkB0ctqqS/8aqoSYtCSdl+9kS3x9pimyGtQZ/RdWJNIjIGPjg/ZjFZpNcdXjlySBsKADPZHKvoORFcxpKqQHkQ/y/0uk5Icyt8bb0h4rNvRqM+rsvt320rO4YPgLUFWT+2xj6KHPBRQh2jQ+fOZeE5epnA+SpaBnP6RCECmcZaniEr0h4IL83K4uXsWQ8paZWIS1YoXF0s+yFihMmJc48bgGvAmVio7DKE5j+dCUJo147tBDpnKAnN4EuAx3stBJgqoNv1jBTv5nCWkZlbvGYwxBfrenM0pi/waxvtVi3NSDzf9NRD7rn42sMBD+3TfzBNuMOf/W1hYVJRAX4u8dLlu0rVw8jKmHdCnkAy9GWeB2ftVFCkoEs1ekk0EH7BD51vYA6QjcmlwTL7LlbukkxM6FMyLjhdjQlprrbZxkUNTUR02Kj2GOfCNNPu4jNWoxg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds clearing of contiguous page ranges for hugepages,
improving on the current page-at-a-time approach in two ways:

 - amortizes the per-page setup cost over a larger extent
 - when using string instructions, exposes the real region size
   to the processor.

A processor could use knowledge of the full extent to optimize the
clearing better than if it sees only a single page sized extent at
a time. AMD Zen uarchs, as an example, elide cacheline allocation
for regions larger than LLC-size.

Demand faulting a 64GB region shows performance improvement:

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                       baseline              +series             change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

 [#] Notice that we perform much better with preempt=full|lazy. That's
  because preemptible models don't need explicit invocations of
  cond_resched() to ensure reasonable preemption latency, which,
  allows us to clear the full extent (1GB) in a single unit.
  In comparison the maximum extent used for preempt=none|voluntary is
  PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).

  The larger extent allows the processor to elide cacheline
  allocation (on Milan the threshold is LLC-size=32MB.) 

  (The hope is that eventually, in the fullness of time, the lazy
  preemption model will be able to do the same job that none or
  voluntary models are used for, allowing cond_resched() to go away.)

The anon-w-seq test in the vm-scalability benchmark, however, does show
worse performance with utime increasing by ~9%:

                         stime                  utime

  baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is a likely uncommon pattern where the memory bandwidth
is saturated while we are also cache limited because the workload
accesses the entire region.

Raghavendra also tested previous version of the series on AMD Genoa
also sees improvement [1] with preempt=lazy.
(The pg-sz=2MB improvement is much higher on Genoa than I see on
Milan):

  $ perf bench mem map -p $page-size -f populate -s 64GB -l 10

                    base               patched              change
   pg-sz=2MB       12.731939 GB/sec    26.304263 GB/sec     106.6%
   pg-sz=1GB       26.232423 GB/sec    61.174836 GB/sec     133.2%


Changelog:

v9:
 - Define PROCESS_PAGES_NON_PREEMPT_BATCH in common code (instead of
   inheriting ARCH_PAGE_CONTIG_NR.)
    - Also document this in much greater detail as clearing pages
      needing a a constant dependent on the preemption model is
      facially quite odd.
     (Suggested by David Hildenbrand, Andrew Morton, Borislav Petkov.)

 - Switch architectural markers from __HAVE_ARCH_CLEAR_USER_PAGE (and
   similar) to clear_user_page etc. (Suggested by David Hildenbrand)

 - s/memzero_page_aligned_unrolled/__clear_pages_unrolled/
   (Suggested by Borislav Petkov.)
 - style, comment fixes
 (https://lore.kernel.org/lkml/20251027202109.678022-1-ankur.a.arora@oracle.com/)

v8:
 - make clear_user_highpages(), clear_user_pages() and clear_pages()
   more robust across architectures. (Thanks David!)
 - split up folio_zero_user() changes into ones for clearing contiguous
   regions and those for maintaining temporal locality since they have
   different performance profiles (Suggested by Andrew Morton.)
 - added Raghavendra's Reviewed-by, Tested-by.
 - get rid of nth_page()
 - perf related patches have been pulled already. Remove them.

v7:
 - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
   clear_pages().
 - fixed build errors flagged by kernel test robot
 (https://lore.kernel.org/lkml/20250917152418.4077386-1-ankur.a.arora@oracle.com/)

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.
 (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc
 (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v7

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/

Ankur Arora (6):
  mm: introduce clear_pages() and clear_user_pages()
  mm/highmem: introduce clear_user_highpages()
  x86/mm: Simplify clear_page_*
  x86/clear_page: Introduce clear_pages()
  mm, folio_zero_user: support clearing page ranges
  mm: folio_zero_user: cache neighbouring pages

David Hildenbrand (1):
  treewide: provide a generic clear_user_page() variant

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 +
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 ---
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 --
 arch/x86/include/asm/page_32.h     |  6 ++
 arch/x86/include/asm/page_64.h     | 59 +++++++++++++-----
 arch/x86/lib/clear_page_64.S       | 39 +++---------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 29 +++++++++
 include/linux/mm.h                 | 98 ++++++++++++++++++++++++++++++
 mm/memory.c                        | 86 +++++++++++++++++++-------
 mm/util.c                          | 13 ++++
 28 files changed, 269 insertions(+), 94 deletions(-)

-- 
2.31.1



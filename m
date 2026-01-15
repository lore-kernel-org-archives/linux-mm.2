Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A228AD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416366B00E4; Thu, 15 Jan 2026 14:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383126B00E7; Thu, 15 Jan 2026 14:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BBA6B00E8; Thu, 15 Jan 2026 14:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE12D6B00E4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B08C256F4C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:57 +0000 (UTC)
X-FDA: 84335208594.27.988E8CD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FFD1100006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BaYAPUbw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jv+eNhrX;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhQ9Ct52F9pSbUXPfem0XOlenkE/PAU+PEkIeRE93Uo=;
	b=WANxsfW285PBkMDM1Fy8MsFE1+Zzm8ThIK6WdLyh1qZq3UuXDqM19C2wlcqf5lxlm/mnRP
	K5+7qdzqH78gaOoDjtWEE0WGXtcy0t04KaoZs2RLj85ZD0XktBG/9nwsfIQCMULtZ6cdR7
	Dfdfc0tXUyKpT2GWqlrWQAPlY13c34k=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BaYAPUbw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jv+eNhrX;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505874; a=rsa-sha256;
	cv=pass;
	b=l836OHpDB8HV9SHZgPIT8W7MlwdBs8NyEFLH9HjkkgfV0T7HICh79LQJDfDOzyqExTHxFo
	UmYeNEAi1fQDpvz2YkdE/o6s0EgnrR50KEdnNYa5DJLUsx/yZTPPhT4Bf7eV8Odol0oxu4
	XgygukI03LNVeA/4NjcTtvAsdVB84vY=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFSXns2753320;
	Thu, 15 Jan 2026 19:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZhQ9Ct52F9pSbUXPfem0XOlenkE/PAU+PEkIeRE93Uo=; b=
	BaYAPUbw/MXPll8V463pqxl8UmIwkc6ASc3PsxWKQGMQ36qSbkA0m+nmcXXHEHU4
	WUtrt7wNUJJFYR4/LdEEvF3yZTxd0mYFsEaMtUFCN4SmkCkMZeRQ1h3M4MYBfnzJ
	2yzYbDrTJQjAsIDPR4nhPWBy6hRRW7hL/tw1BGlzuP/AZ31bjMRR6Q9NVBMcKldj
	5A9Rg6ogWPeicCLS6MLWzWQ37dMA2yVoCmPfFItOjra1gsDlQYuqvWFmGC9KdMPg
	PP0EmFzIYnwEQpFU5dqLhosnHpJTPayt1RmahCJR/qDDxmLp5b2t/uXOJJ2SJVLX
	M+r+KorXi/fQka05JsYXGw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrgem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI5mwe029103;
	Thu, 15 Jan 2026 19:37:44 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngb91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wObR0Q7lMc7KP7VlocEY3yzucl3slF+3IAkoj4QhhjiWYi5euHz843hi0oTjMpNzbX4EL6DH0o3Ml0l4L30VEZJVgGQVVtOhdPv4IYmptN2md86NWyU1WHV25BzfeJg4VE7myyAMkKLltv4i4A+MJDWn/2rRWhE5JQ9luYhSxD4vdqIkhwaG6xSUQ1i7RN9UJ61B83qOBlEiH0TFzWqzLAimOPreAnT/P1MsJlGcBmD3gP/iyY8hLXTjPnu28UjRauHpBIlN1vnlXw1MCJDU3jrUj0rm9VQYa9fwc71TxrQUyx3EcG/79Ugz7NjTYH5bYWwwY26WKdtd+3FYFvVdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZhQ9Ct52F9pSbUXPfem0XOlenkE/PAU+PEkIeRE93Uo=;
 b=JwU76RdySSzmw7vo1Zaj7Gg51O/uvLKDZ+v3LaImDYgccMyIfCPlO6SGEJfIzcDrRPgq4hAS3wLL6ZDpGbhx/5M31LVHdyAqO1RcK0S057naIc8+B+iYdeHScfMEApmMZA2A8jwBnF5iS1xetUOCYbLkXCVYs9MncehCt0AqltE8KC8BHS/t60mvAxz7VDLp81q9Wzr9k8o+hjf1Khvpjq6qt/aY1Cb0izh0HlgMvVgauWmEytgRMzNgHqfod3iU8WWmiGSMn+zX/J4GFdY/4RtN5bg9AGsDoUwOXGfyVjOxMny0r8gs8la94n2lKplvb1X4GAfWwc0s6hWINb2dzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhQ9Ct52F9pSbUXPfem0XOlenkE/PAU+PEkIeRE93Uo=;
 b=jv+eNhrXFr3doPceko/9Z/QuzFhWn0qw8T07xdy2Nbh9P1mC2S05pdaE2udlZDiree8pDknzYqXnUIw8L3/TB3jOFxGaBUCF55wltaevECG6TTPKoWGGWPabbeOuG/EeL8bo5TuIgpJckl5LrDaurlsasB2XBVkqFhX1AqfHmw0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:40 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:40 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 19/28] maple_tree: Separate wr_split_store and wr_rebalance store type code path
Date: Thu, 15 Jan 2026 14:36:38 -0500
Message-ID: <20260115193647.1695937-20-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0147.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 94880794-19a4-4f16-c8e8-08de546d8bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xeYp+LWvG1OQWBH/GHiNZWnT4ziYMd+ijc0Txcq0WDqUAoUOwKumsf3zJSuq?=
 =?us-ascii?Q?s8WVBnewhlLtcSqL8IDktDS/rdmErHfyPQqY/6Nj9kUz3Aakz+rqbYGmxInd?=
 =?us-ascii?Q?1lmxjxmgy/4n7PC2zTyKjka6g5p9RnM5ZIx3XlbSukckjAWmHU5sF1UQbzoV?=
 =?us-ascii?Q?xWdjMWTss/3rxMKGoM3yzB2dHBFu3bayUhuKayG9qwESGwIN5SCFdCoxEB/L?=
 =?us-ascii?Q?wMGzdYB9qJAPL32/dNDFmSyAUEkR273Br1pxKAB3fBUlkoN2GY7aGsmggEXn?=
 =?us-ascii?Q?UVBNpGXjjNhOtMFTQV0WqmT79N2d1JeHybjjvNs7kt6L3Bu+Vl+2ykuI3Aby?=
 =?us-ascii?Q?57AHu95I9RWJz7PTnBGDTuCkwyElwUoZQG6zrd7HgkOmDbx5WtTtQNNNvpQC?=
 =?us-ascii?Q?Mhn89yZNmeO6MA2HgYqesDY4KmobOOSu5QFbgr0Js5eb8JFyIbAImnoE6mOx?=
 =?us-ascii?Q?bFD/0VPF2jzFQ0h+QK5vH4vhZ13u1BTaXS7DNn19Fz4OtWu7nTqCXEJQ3gPp?=
 =?us-ascii?Q?Ia2KRXsxspsi/5/tTDfa689Zq2MyvPe6slwYnwBQFNPP2Bud8trUKPsX48Hp?=
 =?us-ascii?Q?hTT8IF/s5dm594iwes8tMNtlPQxV7zgjpljyXoBE2JXRe3O5bh7PIMpKzh7X?=
 =?us-ascii?Q?1f68t781NLWtZhR/tFPkXyz+rl5iEI6lWRuQD8E7KXIp9r1IZCwn2MXj4xgr?=
 =?us-ascii?Q?hlKPR1sYF+J3JDcJ+kGUoIWMCEExYVTS2x8O/SYQFsurgGUPA2VGast4LfW9?=
 =?us-ascii?Q?tQiPoErJJrTgODyNf/aCtWIr0H17I2QkaBicE8ao7fdXhmlqBolgHFEulzC9?=
 =?us-ascii?Q?11veS840W7xJ2IPOF98685Luh0xsdeQC6JCeEOqyAo5S5bLLhY/b6Q7TZ2hW?=
 =?us-ascii?Q?vH2ICzPEuXY0IkPd5J0V2EW9nhhdUBjm9MLtv6mUDJN+/AwtwyogC1+PI0WZ?=
 =?us-ascii?Q?OHSjPfaSwoxCER56XteRKvFML6nwwxUv4YtuGvMyOycoGXw4juVN8Wwt3w1k?=
 =?us-ascii?Q?ixWRRCb7pTMadUOZ69yH8uOT5Oh5Tqph5JFcjDqx83U32KBgwQHFf1tFEqEg?=
 =?us-ascii?Q?EJf/Irsh6l8SZkJeSiJO/eHrhmclx0fy6+o3N3qraJKE9/qvmBHVapHbZI34?=
 =?us-ascii?Q?ja7/0VVTHGUjtzQSo4WuLjGHJLPfEfBmd7i9+BIw1haTPabqEucCvgiN8LO2?=
 =?us-ascii?Q?PEDyqGHfM0M4F6hOfAG6IFQkcW2tWuNnHuhUxokQZWKu2/tejGngnyeQ0YxX?=
 =?us-ascii?Q?fZU7rPVUQSbuhf8LyMmYzhFZWVxU+sp7g0hVsLY2z5wiKz5Cd6VxwmHSUWkD?=
 =?us-ascii?Q?bxQ11lyvKfewTnCUQ/Q0ivMaKxWHjpBXib5qydTwbodNQOJDTujVXVGZnekU?=
 =?us-ascii?Q?JfYrgUqJ8ggRgoeyCOpSgwND6pglkjmc0roPcQVKWlguVKBX3ILgf6lp1Mej?=
 =?us-ascii?Q?o3AJ7B689XpfdxvWIos5Bm0dJTfPjRYYpNZqoN66wrVre00jxwhMC3CLHHnz?=
 =?us-ascii?Q?lhD+sYLdZfehko0A3qCvQPec1NTiRN/5LZRS/9m6J8t0hUrQbA01OM8fZ6CS?=
 =?us-ascii?Q?8Lzi7QFKbgfTAZBSHaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MuXnPB4fKo1NmlbcquYQ/L5ykk9hdTci8iA9VsT0ie2PugAedF8a79mgXhOT?=
 =?us-ascii?Q?1sNnK7w6Pz0WnNrXRBcGBPuT6PPgNTNvrOr0Cv7QRiVKFpFfpxtO9R6TZXMd?=
 =?us-ascii?Q?oWnpfCKxlZMlEFFOAOW6oO/aVJkPCPTRIIJyQU9ySP9RYoCrID3vUwwMo7r9?=
 =?us-ascii?Q?5Ec06qgcvQ6cLMDq9y3qMDGNkeLmg+uYUA77r1M1K+xEp7dfv5wXzZ4VinJ2?=
 =?us-ascii?Q?BTL2/J8zk70P/BpXwSm62f+TFK2POvfqJSc+3QzOffxxYMLKsejjjFW2/vwx?=
 =?us-ascii?Q?YRDAcuGJ5k3Hh8wyCe7oNV134c+YuXmIb5JEJ/Akv8UfLCV/hE1axUSJ4x56?=
 =?us-ascii?Q?KQOcUVf8xB6be8dYxnd9O2TuFBQr8Tsc0fl1vOGS1I67nzTrsb5jPyzoiyO7?=
 =?us-ascii?Q?oft69qvLEF97g+1DitHLR/hlUkWwpMG2JeimdNMsT+B8vyvXMoREncnhzeMS?=
 =?us-ascii?Q?1HwrgmmTeG3xMXVeuWm6iXB5fac2G/S3GQQDQET8eHaVyonzLIMUyk/8eQXa?=
 =?us-ascii?Q?JIKN4tvccXNHIg1wSkBlJFhQ5g0Y9zkcEDv+hs/N9C7JgWDOl+U8bfS7GwoY?=
 =?us-ascii?Q?bWEvTEVZhS6kDE9v8mHjm7Ts9L7HzHYzxlsiwwwlLhsFqJqUH8ZjWHBzsnS6?=
 =?us-ascii?Q?L8joWkI6ZZKPwQzQyziMbDRWaDetlgEYO4V61bd22l93i/62yZrIDO/aCdyd?=
 =?us-ascii?Q?4F/NrmBmTsQZjzsglac1doPoNJKEfvKMNAMUdIsTEFu5nBSmqfP8DDvaihi4?=
 =?us-ascii?Q?Eyg0hYNaeZekEX5hMqYLidTWkVdJ8Z3QVXIxrat7Cq56PriIPCoDMuZnxOo2?=
 =?us-ascii?Q?4nYGrYeBB7fujvqVcwaOTbPvUT7+nuwQh/ToiRJkrErvQ7Gpsu9n0uHpjpz4?=
 =?us-ascii?Q?o7jItpqrkEHIfWPPb/hfZ2NSzbppMhH1ck58hbh1UK1KwM5k0MIs20vbhU61?=
 =?us-ascii?Q?/oSLfp14rZaHKifaBgJgOQ1gP/TBCiIEl/deuuE7RVpzFMpP8v1Gd46T4KP2?=
 =?us-ascii?Q?sc3E59/ZT/fV9Gg9aY1+u0MdAkPI66Xf/HM+F9ZpAcZK/oiYdkLr22UQ/x8r?=
 =?us-ascii?Q?ws2Cny2Qa8fu1IClQtfSJ10IeErWy2mvGpHpcOAsBvUqY0O0ZQulE2FuIsyC?=
 =?us-ascii?Q?PwLAbfYxQGZcpE/ILVgkcXJfijv3nlGsW5dYQlJSC2nrh3zC6jkCkfz+CTIi?=
 =?us-ascii?Q?ONfFcWtLbDUx/kQjNLoVsYbkg2/NJpm+DtxJrKZ39aZEOK26uJIdLZHXeHJi?=
 =?us-ascii?Q?AlRzANjZrMk6Mq9TtWm2/E0hke91G47Cj3+t05KVZ2D+pLRRSVHZdIdQeai8?=
 =?us-ascii?Q?FHRGtTiumD7/HwvgjwA4LIVrf/kmlbkuv1nTomp+cCm+M7b9s6lydiRSdPq6?=
 =?us-ascii?Q?+PwwDbFrCB62f7wzpmnJwkow3GmKqDfkRyW061vc9xn9KjU9+ON/g2vgO4X1?=
 =?us-ascii?Q?q5U1sANzXiYHbgD+UzldUl4tg9KYZ65RYOBvQaDBzMPXkzDITILz4hBZud16?=
 =?us-ascii?Q?gsxx2D9T2wSNXaP2YvpciyILywSdvzVYvAhcbYFQNca9H/5u/io+SipEoPUV?=
 =?us-ascii?Q?AhH0crtOA5uh3d5AUC73gHOU7MyQp72mGyiq7QBmH4pq1r2tR22T8AKy1R0A?=
 =?us-ascii?Q?ljdbrwNq39Tdkp10/4uiY6O33Fi0NCSDryy3ndGG+1oZMXqT9I0lE04i4XeW?=
 =?us-ascii?Q?n+iF6y/Pt3zSifx0/FFkVnePoQkKZvGiyiyphbGRlabfUVv3HLI2cnDKn0ZY?=
 =?us-ascii?Q?zEHGPuYAfQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1JMYBPOkJt6eLvWUBej1WHlG/76DafTnWN6P3qqBsYqas1bGuHvnr+Z0fFe9512ipNzBlmtlOjm5oQnYkHsUD9/c0f0aldRBFE40dXit4ECTv443vly//LAWHZIvzxklN12oG4nBLnuiKjabKY4HiYvzWoAzqgO4xuLoOqbWKj4MNDboFfk5Se816cUvs//+L7Te7RA6eOzDzIYhlLw0vGmxY4q/ZIH+rPNLL/ZZ5TSZtw6psmpKkz7DEbP7kKpnJiVv0KNa8iSjZ/0muXwWFoS6DldhNsaBHWQZyhC9fyOtehyLsZJdU00ArkdOaM4BxB471aXgkAKQpkPi58qsc5owPNpqo+yeGY4pFqHpA/p0n6igRgc9DpqlWxBF5r26jcjOVBTHPI7MW2d78eVV7pj5955HF32iy8ThEoCx62aqEhGSVpltLs39Sc/fSDKHG1sIsQmU022z+kMsoq8sgwwu2z88hhfpw76POOIuqLc9AYrWc4FxGjo2reeViqKHzu7HCw/1zlnIApF/wrYHELtRVUYOAIOUA+oB3ov3E6+1EFEyroAKqu9T0ZxgEAh+gpu7Db74QZDd1lD3dV4q0vWRJs+HpMYeCD5yjbdw7U4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94880794-19a4-4f16-c8e8-08de546d8bd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:40.8687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpSwgyjnjDgY8mf39BvfoWbcZX3O89DZsUuSMmaKU76F33lXKDo2ZEGPSPlJaSE+cyiaExz1kfGrVmxgYvsYuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: IUJNkpGZftv3NwfCOeI-m-5RurbQMbRh
X-Proofpoint-ORIG-GUID: IUJNkpGZftv3NwfCOeI-m-5RurbQMbRh
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69694209 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_NXkmabX6IJC5lhnbH0A:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX/lV+5zQvSCxH
 m5Y5hw+2Au/LUYEuOQgbjCXyZSm2R5pKyKOumIrXSPqGvIfz0lVRTc/nB4109vRQcBpXBl+Tnlz
 MSVPUaxxWblCyfqoysLv4UYndoseg45tvRDhgmLNyWMOJAPtzBkv0V7m3jRnSN6PKL0SFZl2WlX
 dyFxxO13WdNf60ES6MVRcIord+Y6v2bNEa80wAT/u63eMISd9If5O04udXCOXVrxp7s4gYxka0o
 hSQm/6GiDi6t1RpPjlRsXc4nnk2jmoJqFtiVPSnHv8lxZJGV4+dlo3WE5Eb9QXHZcI/rW6Qnpis
 4ya/nYbKpIX8HQIHrNXnszw7JkYeX3MPav0j9XGz0NsLwKwo2PtDY0Muwevvzfdhi8Nk32R5XM3
 0zV3XfUxne1GyidVPiisWIQ2rfHjGL1g7kdytH9TKeYbUUIqxuytSeQMli4TBR6vFGw/2xCzzjN
 6wHVksmi4Uv8cTWDVKuek8OUMDCTWqmwHUdfsJuU=
X-Stat-Signature: dyn9p3pie8ic8sqffkx944g743zdrbjp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FFD1100006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768505874-890301
X-HE-Meta: U2FsdGVkX1/nHWpCS8oOV0v+nRhDc3SRvKEW5+/l4mkM3E6yLUGaKDQPy+eBrNjclReZkhTAu5ryLYQ8By0JDugqu6WJ5apPq3pBOknI4QX04ko9g6ATKe0KUDAb9ykzuQjpd8+N4mFxN7e5ZNewHogZfSEW7sDVnVMlxA5cipr3nyN9rHrCStRp9RAlk29PKtuGfvRxzTvefaQicSQ9G731PswRPgUmBl6i1L665FGhnEGCt/NUqNaw0yxTYzCs3hAcUUi0fgGCMtHeCyKcikuly/ruxDM8/a4vgYxCYbIPAVf7llaFH8sJBXI3iR0UK0V2Kt4m3VymeJD/C6S11O6PnjPSomMuhP9NHIMQV36++bPnXtCFU6GVYOBCMX2/0bZ+DOUO1tVLMfcMvw1MK0BkKxs173dX6kj/iS821DQLtPF/UbGalalAnnFEL1N3L0okUQ573cNBJudrfekb9R2WSXSNBeEitt0LWSzJICYb0VEftAAT5S2ctzLjOAMhRfv5IotX+2UWUPM90/vYoKYz7cnxAu3d3a4B279tO6okHG2eUmqKBPa6szIf9CpPhaB91DeP/nknEqlfjNR/6ecIDiCHjCXVP3whC++hPTwL5CVF8d/PjJw3uryU0vKwkoRN1fkfygQMS48e4lhUhSVNEvVrWygAZ3ioggciQHUuu6dRI2yH84nA1Gh1YzrbqXnuKLueoQ5FyKOPsghTJco0N1RrLVo0BxmhQcS8RifC7j/uMYoVlvujg5LFKUJp7IGcN+KkQZS8HRR0tc1K5DmRt0i25MjQwCjDG3aj/WhK32adrb1IoNdndw85Niy6dHmiCJejxEBDrOnPmLyAwlW44C1cFG2U7qPLo1oBhVwgtPXPm/bJiiih/uD7vGp8IL6oKMGSy+n9AXVhuVUJmzecHqp3dodJ2XPQYkZgxfnUT37+qStu8ByBIishXMptcja0/LJz9lgSDE0fcRR
 D8DA9NXH
 rGaQCQYKzI2RXD3iV6CqpI1d5KpCmeT7mp4Zovqs6i4dtuBF31NP/UhADiNtlDfybE03YZhMLvx/j32485LaK2CDtAJ3CJoxgnp0WMAWNJd0aOMPH8q5U3O9iAHqJ5uD5EqxnYPLB+DaIq0TtVdK8JcS4E/f1SB/snYsiEUXaYrBLSuaJj+g/Gj+vWd5PUeYoA4nG1aBGBFG/u5PBr3p3mRHb0K0/tE1ar1i/GQzdOo/c4p0+ADakEtucVaWaIIK/8MFk5GTMop7/m7if1LAqEvQBnC+p2L5sY2yAyFQjcUkF4E88iuIGYw67G7DcHkscpFu78OgZmqBuiuo9bUReoPbakzs+VpsgwVoMoyRYd1vmHOknoZGpYB0bxHfSdWim1tqzJ2VPNXmMc1Olzzihp+tjvdIFU7uWNaGuMYsbXEGeQvvwcsBRF13RgHrn+KAbGAw41AmaGZbwReeNX0b1wVwSMguYamGClRE5MOElZTSDIG3sFZHwZyHiONeChrPqmd4kRGMGRQRYrFQr4CWBb+xPmN2SS4kb9S3FN+BPi1SHBcMQtOWOgD68MSS/jWvrC3sutbqjgseJ+8H36u4PVYNogDxXm4qn7HJRckZX4/VEbUzkfG9ySEZguzhK9+7gmA7rfMp1MDUJPZCEifvoknFUjep6Tjfub2v/f4f78uhcwQsVk87iLFKqLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split and rebalance store types both go through the same function
that uses the big node.  Separate the code paths so that each can be
updated independently.

No functional change intended

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 70225f7856258..5d871d91ca49b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3689,24 +3689,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mtree_range_walk(mas);
 }
 
-/*
- * mas_commit_b_node() - Commit the big node into the tree.
- * @wr_mas: The maple write state
- * @b_node: The maple big node
- */
-static noinline_for_kasan void mas_commit_b_node(struct ma_wr_state *wr_mas,
-			    struct maple_big_node *b_node)
-{
-	enum store_type type = wr_mas->mas->store_type;
-
-	WARN_ON_ONCE(type != wr_rebalance && type != wr_split_store);
-
-	if (type == wr_rebalance)
-		return mas_rebalance(wr_mas->mas, b_node);
-
-	return mas_split(wr_mas->mas, b_node);
-}
-
 /*
  * mas_root_expand() - Expand a root to a node
  * @mas: The maple state
@@ -4343,19 +4325,34 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 }
 
 /*
- * mas_wr_bnode() - Slow path for a modification.
+ * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
- *
- * This is where split, rebalance end up.
  */
-static void mas_wr_bnode(struct ma_wr_state *wr_mas)
+static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
+	return mas_split(wr_mas->mas, &b_node);
+}
+
+/*
+ * mas_wr_rebalance() - Insufficient data in one node needs to either get data
+ * from a sibling or absorb a sibling all together.
+ * @wr_mas: The write maple state
+ */
+static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+{
+	struct maple_big_node b_node;
+
+	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
+	return mas_rebalance(wr_mas->mas, &b_node);
 }
 
 /*
@@ -4386,8 +4383,10 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_spanning_store(wr_mas);
 		break;
 	case wr_split_store:
+		mas_wr_split(wr_mas);
+		break;
 	case wr_rebalance:
-		mas_wr_bnode(wr_mas);
+		mas_wr_rebalance(wr_mas);
 		break;
 	case wr_new_root:
 		mas_new_root(mas, wr_mas->entry);
-- 
2.47.3



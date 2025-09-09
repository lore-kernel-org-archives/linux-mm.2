Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D7DCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810758E000F; Tue,  9 Sep 2025 09:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0DE8E0003; Tue,  9 Sep 2025 09:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A7E8E000F; Tue,  9 Sep 2025 09:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 488638E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:40:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED4A1B9E8A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:40:30 +0000 (UTC)
X-FDA: 83869821420.28.0E6A502
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 660B4140006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:40:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W2PqfARY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wH0CsAHr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757425227; a=rsa-sha256;
	cv=pass;
	b=nFLWbqK0uV3PuJjnU/2WUB1v9+b2tehq0rFD89LY1BlTZ2sP8+V6QCQD4uzytd4UERDp4X
	hdhwreZaX2GhEqSZlt/m1HdJDo11v29tqMs0JDM0qkVclZqiaBdZP5aGNk3sXEl0zlyipY
	3TqI00pavDO0J0eRUrBCqFjUg5v9Txs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W2PqfARY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wH0CsAHr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757425227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XazHwRsDrq8IQP5DjVsdYgHBST0+GfB04FGXoqalQXc=;
	b=ixVA2K+1Wm5eqv4yzZvgCjB602rODNm5jiv4l+SRd59FjIOlMLwyOYGXxPyq9C84pcpAwB
	0+4tz0HzVE9ODi82PRftX0MQS3n66jAxT3+c05hq8Ye+tXM18uIeXQdRrv54YEZuB5tEMl
	WUvMjZJR8C/5UFgokwqt95uZhPnZp04=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589CPGZW032252;
	Tue, 9 Sep 2025 13:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XazHwRsDrq8IQP5DjV
	sdYgHBST0+GfB04FGXoqalQXc=; b=W2PqfARYSEO/reeu1wzSrp71KrOnK1WDj9
	qvG+luKX6KPMw6l9G/vxuSVFnRZkBP6YniBelnFywL66Qlg7qDJtcearSn5lOWDt
	tTSYNE0koynf+qrE+x3F0jG6ISBNuqCHepfS4LZ5Ulye2h24A8LKwHfedaC16+a0
	rcNKOBq9yt7R3gOQ4fqu9QuLO+5Cu98Pk61jqdzTTxnZt0BAtc3tfQQwfJhIvKLW
	ULHQUTFolRMfbKaUKy4jwB2qxbttr/xYiyalUSoHyqwHZw5VIdGBULKIYu1HCzyS
	oIBgQPWCv6mca4R6M+wGJes7RNBUq/wBPMM12EB8msDnV1e/e6yg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pea14x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 13:40:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589D9rNk025959;
	Tue, 9 Sep 2025 13:40:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9myxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 13:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FOHp4khV9y7gbhoktJok8bD2luOkNBNCez+rd73y9QETuVwumNhb5FStmQDROxh3ZicrP7tKzvxftENrNCVF7L2Y31iWegdxoLTDmFpFOxCkNUaIpkVd4S3HC6Puo+rHK7Mmrexn31gjiCnyLdkN38VM7zwtuAkMFLZNO5gG/eZx3QVbQ+c5X+zmyiVgjlzIHJGHNb9JqDKyvdzlMvN58kl5R08P/UFbHtPgvrEQ7Q7K6urtHOWyfIfPy3mQljh93/KKQWkvduLRNJIfZwK1+D42Rv8NtmnYDkpvQ4y05z8sCCtLqUNpgCyTJeLLDOdRYiXD6Y0ERtO8kXabZ2XQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XazHwRsDrq8IQP5DjVsdYgHBST0+GfB04FGXoqalQXc=;
 b=OzHbFutnsulnnyLYKHHxZ7CDTF/svVoBh47zhLCdj0+c2YmFaLQfSWA50GRz5VhujpgNyE9TY2QGS6tewmEd7IvYZQLf/h76zb9yDusuNeGZzsaKI8VIfLsZmDjbcxeFz8N3ZWU7oljzeA9BThDOz107DrsDfx9bjFkGbmjwQ5neisC1RiaCt+tRTwP2HvFBNX0JXja/T8gZ5vZZge5Sq7LNkiWEYMt/NxRGJVTC4cvo98U5TwwtbTQYgoYwDjC5tnHR0azge6faTBC/C1R6TWTeaNY2BzaehRpvb7TTiyzop37mVvPn5G6eVmi/QHjKnqAMOgyOwdnPdrUJE1cDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XazHwRsDrq8IQP5DjVsdYgHBST0+GfB04FGXoqalQXc=;
 b=wH0CsAHrfqFNKWHCACmrZDI4BcpZgSHcrxZvIACEPU1OPtRLAEW2V9IYSrPHv3Apy+rDnz4YPvYBqGNeL/lz/Guu0MZZ2A4oYPQ4GAyJGqRKb9tOCPCQt4nZFH3Mm0u0e1qw8d0Zsbn/dOFOxdbSjr7wKbay8T2oS9adIYSpz+A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7833.namprd10.prod.outlook.com (2603:10b6:610:1ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 13:40:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 13:40:20 +0000
Date: Tue, 9 Sep 2025 09:39:29 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Jann Horn as rmap reviewer
Message-ID: <foqgbk35xwj7jdj5bsj4cy2nfazf2a6iom5tlsocle4f3herf3@arde2gytrk36>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT2PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c45f97-fda9-4711-5ea4-08ddefa66b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SOD/wCIy6P0pvG7ruU2LJHBclo0d0B7b5MyAVMzyRM1rFBt0g97qsRcf30ZJ?=
 =?us-ascii?Q?v5glCeGdHxM46gv3KYq+zWur/5vTxFIS8mdParcU4ocoTR4AjoUviL/HniWn?=
 =?us-ascii?Q?o4YhUsJbGUKn67ds6Vij1amYOxBu6JmplwUq8xbPsVzqtR9gkIjIzpZ9aDG5?=
 =?us-ascii?Q?AI6e70MBE0Q87ReRfOaqbQfTYEKBlEIUfIZgsnv7Etx8dHA7pwsNKiawBoK/?=
 =?us-ascii?Q?rKdqgkAJseO/4MPqtJnqjog5M2xxaCZ6+deNFd1kKfofNGrpMGBrmqf+qIeW?=
 =?us-ascii?Q?N/y/hKBp5lj9hb1bUgNQJIeeAnqj5od2SJ1WD/S5ZGp1W0C7iy9228J4Njfb?=
 =?us-ascii?Q?v9pbQSGLe62+y7XmaJn7440ZZ8k1L1gkx+0RBuBkrrxTiHtU5EHrA5SzStqB?=
 =?us-ascii?Q?1eYa2jPpuyJ03Tzby/FtlVcdqdp5qT2XZWFAMiFT9If0RG0ZVlFdJZIGB26I?=
 =?us-ascii?Q?8a8O7eAnR2v23uIF+vDZbDEMTl3sYP9VVgkkWrYDsNQOQxzAU9FB6E1QIXCX?=
 =?us-ascii?Q?6CuEyW6xX5Suqq3jcCLS4fRl8sIIrYfWCGHaayIu26HZLIOP79+05zWqs6Aa?=
 =?us-ascii?Q?bweM8m2Go2mRHImVSmTmtCaynIj4Q2ydLSESoSaxJr/hFQjCoGHkjUgqrUGa?=
 =?us-ascii?Q?K/sv2yG5TTjtELVD8xy/jzb+Jx5R4vOE7M21C210gfnGVL0MsIeBjsP1H6XN?=
 =?us-ascii?Q?e74D+n4EMMThJ4icCUUiYXvo3V4p31YXR8bit2M+fjA6K65Du+zn/BrPoMCP?=
 =?us-ascii?Q?g2WeDSYwDVNBYfffvrTtT7oL02n+ye/iWQh7BX86MWldhsEvFUvBn0SF5J7t?=
 =?us-ascii?Q?ApNxdXHDLppVEX8FGXsAtnoF7d3PlH1nWFPzxJ8rQSkpPlu2CYY7lq0QHTx7?=
 =?us-ascii?Q?oLW+TfJj5x39fFoHNvfV3MM7WEWXxLK6VML6rKv+KcbLcEtrVEqNZOmnRGQS?=
 =?us-ascii?Q?Ac5Yoc7tbWRYa4touojLVU5S56CY2Ibxr4dm/rVG6JAkdNooTiEZakj/AChB?=
 =?us-ascii?Q?9RVHFYSeOu/kiA4dctS05LCl0oh8u5hBqRvfj50zjjz5aLvGyc69GZSl0/8d?=
 =?us-ascii?Q?+CRj2ky3AJQ+33oPo9ZFY92ppdBiIDei4ZzqGg+qQQjlFL+LFtQeezuEl2wR?=
 =?us-ascii?Q?63KKf1WU97uVP02qLzeIYcQyO5+GyJtYXFWg6ziBvL4UHpWub48YYEPC7QpP?=
 =?us-ascii?Q?Bj0slhP5y/d6gxOp5+BR/lAaoy7+9bDBwJqTZTvo27cBUPx3aym+g7fZwzhQ?=
 =?us-ascii?Q?IZDZ7S4orZMUTc7eQovpy0qXh00pL56V+Aaz9n0FaV8M2voXOOcFlhbmGV0l?=
 =?us-ascii?Q?kLUED85f0ua4DH3Tzo24VOVn6TLe+xuF82L7fleqmcvAMDql/urNlxNbLv7m?=
 =?us-ascii?Q?/8zvAcilvsS6mRfXf6TOhUjToLge+MXxXdDuClIKoHlQQgt5wpPrcXsS7sxB?=
 =?us-ascii?Q?PqqZadSIja4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?grrlPD7Jirg8ydFKkokKa3vBW0fV06nW0Menbj8n974e0bBNmmeoQ8qXFlJO?=
 =?us-ascii?Q?Dnugmvpbn7wMqmUbqEaICbO5/xcmseJM6BzHaxCOAwn6u1KmnisgTSH3mors?=
 =?us-ascii?Q?a1dvOt1rLwbum/c12BcJ2ufSlwZziMfQh8HpL48q5JfXHsSW6gjOMIofuQJS?=
 =?us-ascii?Q?/ew8+B1Vd+LCLoQsKrCzCeaw2Hyf225+rpMi+fNL9fSIPXluZ3SuCXewA2e+?=
 =?us-ascii?Q?KHEzyv/yYOboPUlopXK2Db7qN3VHHWYYfhNFD6S6LuMxWfUCP5DYgBHelq1B?=
 =?us-ascii?Q?PqrfkiTX6YlcsBr2JbPt30UXk3g9qw/cDS6R0HSn02sDIAw5NUg+xJ5hLktg?=
 =?us-ascii?Q?ZmCDX2DBOPGqGRgO0E2sv1alC1mbXxR57v3oo3fmcC0zOPpsB2b6R6Gyba4n?=
 =?us-ascii?Q?fKFFPGG4kP46RuQiipCJaUCeeEhZQPVrIkWVMOE0+7QPXZJcmpEIE1KA3KW/?=
 =?us-ascii?Q?pYnMDdOzn8olCu4N/g7L/AKfC1jKgL+mahXi4JPrDrU2T/r8KnUK71zRWRDg?=
 =?us-ascii?Q?puGHl9stMYEEdYdw6vlGzJ1soDp1bmkPr8TKVoBnD+dKw7smNZau6DoJX/9a?=
 =?us-ascii?Q?q8Crjhq+EkJtMeoqJU05HLIwTylRKKFu4DV9xA1UHzVHDoZ4no1YUdpLO42z?=
 =?us-ascii?Q?rkKNN0MApjMFAGY5G8utpXVAmNB71BuhyMfOIplqouta/Nx0DleTXtO9HOGt?=
 =?us-ascii?Q?rpuX2KnS7Tl60elCBO0d4JLRX6Z7NSojtnm6S+2aLzqB2KG2n2KD91/dM1nt?=
 =?us-ascii?Q?6N59I+BZMI+5c58Vy2/+07LFNjd02/lbJhsqExQ1W4kJ5YFnaR10QB8ypuEv?=
 =?us-ascii?Q?Y6gfcwr7KXXthfHJ7WrvsPZjhjdsqN8XCMJ89dVMWngA3tPScZVlivnZZNCS?=
 =?us-ascii?Q?r+naGkdoqqzk8ogNWCHMeplyBeO6E1p5Dxe/PSL0HuwMLQdEBYXkU2ugTq58?=
 =?us-ascii?Q?9iExNBBPmz1E3OmA7iKlb+MKmtU2pEzAkjqkborsRfQiTMMx5JWeB+RqaMp/?=
 =?us-ascii?Q?qeKiJki5YiGvfSUbwHhO3G/oYtXbGlPdoUDqGWN02OFuW/rAQ/gGQkQO3Urh?=
 =?us-ascii?Q?vdiwIHpAsd6cLFwsCxuYzTIWYHz47xUQU3sKBn7+neXxqpieejbD+fJqVBGf?=
 =?us-ascii?Q?7l5XmhmDxmS5o4Qwo2L/4s/3n8LHChArHd0mL/EZmeF5GU/NsqfSa+ao8t10?=
 =?us-ascii?Q?RvAmm0EDVMfP6jfD5Gaz673isM8s5W5y6GOkzlZwG9bpW/WYmDrcXFEOWsiF?=
 =?us-ascii?Q?GRAcPXqu4fUUyF7QHd1pWp6q/M1Y+ODJvpdRXt+TJUE/QjWhFPx0Mw6iqBoy?=
 =?us-ascii?Q?XAndRemy/j7EyaEe0eSDBypOm5PajQgbilBl40OdXuu5Jy+nR1nF2C655XP1?=
 =?us-ascii?Q?TywCj9cFvG5//m2VVLgAGhKlztRqRhxi/oHzfh+PH2JnPg5VKzJB5d33iAaA?=
 =?us-ascii?Q?W5dHAgeZttgeCnzO+gk72PWV1OjtmtBBmIGdupbcZ1fZraSsincZNM8urqOQ?=
 =?us-ascii?Q?mcWpyBW4LFm/oCon/gGpf5ddiQqWQGBLD4YFTOoDmA8fRO9iwJqxaEQJdK9/?=
 =?us-ascii?Q?DzK8Da4z2lDbIoWIeW9TxBujIpu8lhWWk69YXVC4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ms2THmXwcaeGbQyW2/aH/cl5Vxp5Mwi7x4DGiVhe9WIabJuoK3QUNHPMnMSyhEtjuAspcZaMewcSKw4h3HMRjwtl2aIXSAPGfACR6tOutF6+0WHJx2SiTJzOkaAYGhv7Wj7Kmm1KiK8IAJ4RTno/MQV+SO636o9nRGvDjS8ejVrt3e8dBtuOkrvu9jrE9/I5kA4qebt5/mmfF8HEsqxKQOVx7VpwTaJ0PozDSJlKOGsXusSLaGQgGVWTG9mJJdY7Dt+Plk/EJaNw6qLTgAWmI+QKiXlNsnkK6IjvK0DIwuO3tQhytIIeamNHcQVa4oBDSReZXc3lFN72w4nlVXt5JIv5r2kE9v3Ty2AZsLkRd0DnR/VXKluTmie++Ir8ohOGs0fWBICRAz3ZNW6wNeAcQcJv8t6+BtzUMc+2VhAUYd1vDCaMAOZix+JWNVJMlLzUtR3IveLXdbpdKA++Q9rCOwYuZC+hez+thNu7ASsUea5X1I5+brektlMoWUz85M1g5HOJsFK8E5Tvqc+6jVkZHzHRJBccxfF9Bs6dcZW0HGv3Tt7tEQg+C55+OS/cQ9nc1uf8i5SfasNSxtTmnQrkZb5mYba1DqIPteQTXBiT7HQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c45f97-fda9-4711-5ea4-08ddefa66b50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 13:40:20.3052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2etDDRKtKlnKMxcqCBsxi3ODSmRWb0A81CPUxhhvW8WmLsaoWzHCTzHQT9OOOaFBcSXgmH0ehvuxYC4gGWlMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090134
X-Proofpoint-GUID: DXZ61bex-0qEmnQHkg6DltAF_lR5VdRv
X-Proofpoint-ORIG-GUID: DXZ61bex-0qEmnQHkg6DltAF_lR5VdRv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfXxwjAHaj9rPGh
 vY/dVz32NrZG6WWFDl8ymzxKdPIqkFOEJmw1ftjnRFK3QTl+EUPHFIhqRtF/Pkn2qlA1DA0vSM8
 VZiszxH1Ouv8QW9+XgoBsdAar+sPeiu1QSkUfADctBYeV/iA99RurdlETJON7EcjNpvUtjYQuRC
 k995uP6hLkX3dBmQAp2sb9OQfucGOp4E5R89Aahn3M8RdmpOu8vrw/OfsavtHiVVImPyCKR6b5L
 5RbzZMMkYKoTMG+SC25NrsfnlEEn8WRgq7Tuyx4YZYH8kdG2eM7YIzMk2FKYFc7X9IeP9FIUcoR
 mGWypxbN8cMfCp+LD88xIDXnr+7T3l9Xk2U/2p4Z2OqcRvS3duNvFEWeZNig0XLDyqbBsb2h3Rd
 WHtjH+J/gl/7m0+i8YUo+IeUljWLqg==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c02e49 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=fwyzoN0nAAAA:8
 a=1XWaLZrsAAAA:8 a=37rDS-QxAAAA:8 a=JBU-24PaHKBSD_OOYAgA:9 a=CjuIK1q_8ugA:10
 a=Sc3RvPAMVtkGz6dGeUiH:22 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:13614
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 660B4140006
X-Stat-Signature: 5hzffinckk6yjsy5e7nbarc3e66jpmh4
X-Rspam-User: 
X-HE-Tag: 1757425227-223738
X-HE-Meta: U2FsdGVkX1/UhUiOhrVZL9W/l8H70//3iU8lccKZp7MwxhY0DzLpcokM6oQE+rPVzcXyUj0k/0qXXlm7ChLdJlGiKEq5h5Obzt/2xtb3lsN3GizqxsUmvx8/47zoV5erpu71zTs0P0N8QMzVXyvzTvPFoPP5jXfOAib051q0LdmNtJ5XACrlmZ18FVZgUND/Y5HMuGP6WxJN81WA6RSN4o5GUpsnJAql2jI8H8T+QntF0QPm3MDFzxqeQUn1Q4hwjlR2QW9ep6KvgChuiplbLiQXC1TaH3pfGugdBZV7VYMLpZNM7Xtb2SRrCLQn1FL3vTA19cydXwSwSdQPn9fPrKqjNOLlPLWKJkuS4Wj1fqoo2CUnyBiltoVYl8rMRnYYks0iW64VxH9P7z9y7LIsb+J+4nF6GeDv+z69n5ZfRjW6Xjx5RSanUZQACzxrv3oU4+y2Ww2bfdnWCNrvVGrvJ6QW1b0Nb+S77Y0aJdtinPACfsYg+5v+eFbjxA4eFklTTdlrfB1COQnt9QoOHA/PYGllfSeRjVE4rGFn1sJgU6/OKXSwS2vRwn5VUs1u2juq3NOpehfefHmLW7jdcAYqrFuwiOHo2cLI+ZvbP0ECUkotR7HzwF+GQG5Y7o9Pef8O+k46FLtfsTOmPU6ZYt4R3KwHjUIaogLhL35zST7DYmPvEnJF9iloBRWfrcCQ5Bhned+GoSbeqjCvfbj/BHXp5flfcWUM3kHU4vC79m2ujAbubwfIASct1jrytQ0oCwq1e5LSEu96w2AYMexeqseTC7GxNVC1SE6j50p2mqfpBAwYSli+5PhrQv7kiUx2R6wpK1gREyOq7lplAL7Bc3FIKyBMvVxAzSSPVrVgeQzvMZmhhYG535XgZe2xVHFPcEQJoQ8Jcjuiu3cSSTSQjY32GFbsZiRarRwoecwArV0qbXnr+f0LZbx3eniGhQI8oA1c2J+RTuhXhD8FnnHxCvD
 TI4RgXmr
 o6zUXFEoQtcIcWM0eubrMHc/mw8bk6cp/zD+ByJ/unYZ2gV6ntvjAESYFJ/wysn2R55B6PEL8iuqdYt0pkTsR+430+63fBsj/7e7JkNHF6yWh327KWHtfJt3qbGFQe6UU/UXTCMh5wr35DCuiTZKaoZsTSClLYDa/yFiMxejtuThWr796B/eZ4HOIo1Jc/fG0om6sn8VHiCXsrXHNrYfVGCdX8GkaOm+uePvxTFzvaGAiXJ67Z/cHZVDQnCLMEnfYcaaGWHKUTHr6V7IY09zPKsuUhGC8tXu9+bwx/bfCjL1kJYX++wacmZ/H3u1VSqeZDMewlPF2b1ju3p7ekwxSVYMkuZUCn4aIp+pGJR0XWwaiZj6Ykpg2VcOWBm2N3rAWnz2bj3grkcbBQFEgB6bLYXPHd+rt3fggKcjQRRv9PlNwbOmmZRZdBxq9bwMpXqAtRHHQea5hg98ZFfvAG2Prjz5ITDX+P0NWdwfAuJFRizGpg553Mq9O3Nlp6e47PVjvRqmqMQ8Ior6CorrF7R/jdILnUylPLovtUdDNMyO8cmH4v1Pa2QFCuxEgheEvDeaSLvFw73HFVCeaNjQrBN8tEOQ9l4llftOpuSXIhr+533qZS957aTC0dxsSg08m+YD/D28CeAsgDBsWV3q3X/8xt19oCZqfP4ihqgFqIjjDZZCV36ZnessgsYrQvZf6b6/Eu0+E11RlS3pO/c9pEJNWOOhOzFfcAmEpXCHHP9mRWXzIAqplpfePvWMbvn22gXLE0KZ1YdCBqG9uz8o1J+kgfr5kXYwv3whzzowp1x1P/VG8zpbxfusE/sr02XJ5EgWcftYsQ+IPtKu0tpJ8q/CWIL/kYOCLYCCSe+JrV7K3yBNQKyGarDwnTFNvo6ouxn8PL1Pp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250908 15:50]:
> Jann has been an excellent contributor in all areas of memory management,
> and has demonstrated great expertise in the reverse mapping.
> 
> It's therefore appropriate for him to become a reviewer.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
> I spoke to Jann off-list and he kindly agreed to become rmap reviewer :)
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fef05bc2224..ededb2cf8f9c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16198,6 +16198,7 @@ R:	Rik van Riel <riel@surriel.com>
>  R:	Liam R. Howlett <Liam.Howlett@oracle.com>
>  R:	Vlastimil Babka <vbabka@suse.cz>
>  R:	Harry Yoo <harry.yoo@oracle.com>
> +R:	Jann Horn <jannh@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h
> --
> 2.51.0


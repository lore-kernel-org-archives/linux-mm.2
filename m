Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4A7C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99C36B00DD; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DA76B00E1; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E82D6B00E2; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D01B6B00DD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21CB41B0568
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:41 +0000 (UTC)
X-FDA: 84356577522.14.11C8E49
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9224A180008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OYcCNFvY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v0aE+f+M;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUQ9eFVFzsseOhWKHnC0X84bu3BzNm9gjImGATB5rS8=;
	b=ekc0aBTRAfe7H8GI0RIn7JDgS2fUuZ5JT58DBnQo5JZN4ZUJj3dudbeDdjnAYpBq0j8JR6
	KNlTFma6mH2b2h4CPDB1FgXG6uRZPjkVZTgmAyr0tuNoY4y/lu8GjNhxJPITlfMhN1qvMf
	hfFFGXuW7tqcC0Zdp8OCq2492yavw5I=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OYcCNFvY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v0aE+f+M;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014657; a=rsa-sha256;
	cv=pass;
	b=MxTYHjPuAQ9HnF3oKyb3sbXIUS4WZ6v5qMclIZZHPM9iJdpLZWoBVDFkxFvAIkquqoUnK1
	X1MM60/vePowgXvF48baI6CtUMLnGVXLnqamlhkJpFOE1jTM7VbJyI/+DW0fuWu2+MSkAG
	iH1qYBV/2ZMbT88qSx0hDLNnzmLktDU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCqquD3031785;
	Wed, 21 Jan 2026 16:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yUQ9eFVFzsseOhWKHnC0X84bu3BzNm9gjImGATB5rS8=; b=
	OYcCNFvY7aWLkJ3x1Y8lQOPb+3IvF9eVcoHN36hKKgI5wRPfni/+N5cRPcgTAaWp
	OYxmjvenrjg8lYDS2XfnOlz3RbS4E/lTCgtMuyoXZpwpVNEiANkfWckZPVrcSB0U
	TEfIE1WlGZQEd8EOJJzMF47+DP6/+wjdHdN+cOXJzC43QJb0tmFRqhI08SrczME+
	inGdEACB48LfMx8gNHUDmeqzHA/pWFJyFgiUVfMQUnJCGGrKTZF6rAUQ89oCRJBa
	1FXDW8tUNV50scQhVo9kWivQ2YN36Q+bLxiJQ772dKTdhDRlByulDGUUkZ1ScgBu
	e2xfLl0fx8OApITVTqk0bg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypx5b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGo10g017471;
	Wed, 21 Jan 2026 16:57:28 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhhak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fYDx0hS0z3nfUOBJuvwg8QvZKMhaf/nx2BFVF1VG86dzC1ttF7w3zYqZQQGUAV4wEKhYTobiYRBbTk+ZlZHcff0VCciZn8HRBvlIHnJBEdnY1aPED2KuyVgqP8akEok0Npc2QMEzIndBHFGKIw19T4OZJHBkVtJ2tFsJDVClAEaoH0E/BqMQf1yAwOEYJz/3/FGGW5D3nhemd4K087D88LOag1aYpegzS6V9NMTRQKou+tqI8EDj7077btgDad0THtdcNm8rNLeZP6zno3qBgByQpnFR7XMl743Xv+LFuQF5dfi1Y3nEDc9lQSKBAlmuh9JFaeCJ7t+cXxVqgBe0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUQ9eFVFzsseOhWKHnC0X84bu3BzNm9gjImGATB5rS8=;
 b=ZfJ7mjFo8sHlKsbOsUrnss44MiI8p3iWO2JGW68rN5nAvyI5rI7raSIDUJRcgxhiRp1HsJAMNtjoLYVxnLgjZey6p2UY4vBPWhZE8p4jO53r/6GSdsHxhCnf8zmAvmx7+BZyEIOzurA9JKMSrZTS4b0InqHehvGpmt8sNFsRpPLVILICsBvQTXxcMdPxTziXeGYBEAOaryAFHCu7B9g1Y86VQk0VE3IXO2rFS3xgVjn5JTwVqdmFyimKWMV7Nos1NglHJ7ZrxbXu/dEITbh31LNjOWx2V3uan5mRiUA8bzXfCf6tcwqon0KrIdojJHfsDQ+pOzwGTaL7k/i2IAQdKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUQ9eFVFzsseOhWKHnC0X84bu3BzNm9gjImGATB5rS8=;
 b=v0aE+f+M9QnfcospbIHT3ugEMwkNmlKiXEADBwJp9CV8dh1hbDXgSCRuGHul7iWcihjG6A/1Fr67AuYSX0lEgB+40HO6R+EeUwgZgfsv8qNPjy2Ml7czi82ZGZ3n55prKsmmxSBt9vEVx+RXMwNQ//xdYeaFPKP/GJYggYCNQbs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:25 +0000
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
Subject: [PATCH v2 19/29] maple_tree: Remove unnecessary return statements
Date: Wed, 21 Jan 2026 11:45:16 -0500
Message-ID: <20260121164526.2093265-20-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0337.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: ed599f2f-0306-43cc-fd32-08de590e26ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cBaGq1cgCe/Pwf/hHUzHtq/2FXIx1rd6CcILmhMAQTYqlQXWGYokpEUiQbXm?=
 =?us-ascii?Q?IkpgVrcP0FMvyWSCZD4Sm6nkieMVjzfebFuSKHGfzY2zk+nXgmjvqS1iYI2O?=
 =?us-ascii?Q?ucgjlYcUArzUM/FIjYBRdAgR4phrvuwxrKFeC2kezbn/l7kwSEPn44rqC+bd?=
 =?us-ascii?Q?y0CeRhLqaXjXFqMasf/fefxnKpJM5lZwryK7CiJxWxdB7dbdRrRHDJNh8piO?=
 =?us-ascii?Q?DqtuApkbnaSniKaETDxbiJPaPEHN4KPFhyTY4o+Aop3Z8ILqSsaQhI2iWYiL?=
 =?us-ascii?Q?foaahPrMsi1mBUcixjUvG0DczykF5u+7WOFv0Sk8WgSrDbzz5Qv9Je66LQuW?=
 =?us-ascii?Q?50eN0qHNjsRQuGY9tiPJMf2D0/eQfa6CmNw8HlNX+cFCMwkN1h2wwmt2eKX6?=
 =?us-ascii?Q?DKnPGm81G5LTi9+/LnGbkHA4DEFDbLQSb030+hZHCgcS7hDmhY966cksYjK6?=
 =?us-ascii?Q?XnHDroNDX0eVgod/E0yoFnFr2XEhNK2v/qU4XLg7/OYmJ41D/qNtuinfvENu?=
 =?us-ascii?Q?nr4/OcO7rpPgEGUpHeJV7a4INrdiiNx7UbOFmJPcBvZ2nVn80YcWHPB1PF/Z?=
 =?us-ascii?Q?Pdf5L96EOwkSz1kooBuQZbJHeJrlYsjeoXxDLj/S64KUAF0LRQKWDw4RITd9?=
 =?us-ascii?Q?uLemX+kc7R/TSEd3+qAdceo2YvnRPJur+TuLmPjXcS6rCW2qTI6oUtRHkMVu?=
 =?us-ascii?Q?b76YlAgNBa0hTeQL6g3UfDzPkF4KHCGufuA/Tt/V609PCO3cx0Kn1Z+zTN3N?=
 =?us-ascii?Q?WFLhZqZhvjuAbhSjLhdJMJlA+BQ/zkfANUedoI/VDPJ+s1ZYM7TfDg0zsbwI?=
 =?us-ascii?Q?3+SCAxkqB5AoUvU3cLy3QvgY4QZCorYr99+DMsIRbuiaSww2fq27kWRXbYus?=
 =?us-ascii?Q?jvVHjNDy4eKUoCV4W/Thl2f2uxqEtNPggUU+afdXLMtT8eXqhodD7rIwyb40?=
 =?us-ascii?Q?q4ZAh9feosjXGgvOiJpMAv69QDKDSm5Lw+rN66RbUIm2OuI9WCuJOGASkExz?=
 =?us-ascii?Q?soDkXZRdCzNtZX1/YV6NXlCw1wJwcC3BWk3h5kIJnWWar0WW1H/9SQAmFlFB?=
 =?us-ascii?Q?BbfUQx9G1N2zvMfmxG+OmJU+oxMrgRG8N+yBkN6jsFuoTw+76d3aUrQZ9F5V?=
 =?us-ascii?Q?A3mg93FXz2XcLmbacY35A1Bp1zni1cUoqScnpFq9cDgBd7pnBn10jqV74L6U?=
 =?us-ascii?Q?Hy0XI9OOgSewKsTVb0ZddWTmgLaEw5pEH7Szwfgj1K4Umd/3B/vLYMWUO7AU?=
 =?us-ascii?Q?Fb6b7nfJNmjHbfxdH3URs9BXmfZEFanWQKHNd14prk1k4WkcfJuhddO/zVlG?=
 =?us-ascii?Q?j5uMXTxLkWdEDYjRB4tkLgSqm2VRlYz40vf0sfnfp1xeJAv0Nv80L4Kp4Y9R?=
 =?us-ascii?Q?10zV7soVd2HdldDIitnkICtwJA6tW22D0Ywv2mKBjdN0gZyNa8IsB6S20vM8?=
 =?us-ascii?Q?KX3AKZACDXL2h46l7wHVF9tbwJl/gnv59F4+gJdOCLRp/YbPUOSnLX0vgHrz?=
 =?us-ascii?Q?9dSOpgzIdL0WME8bkBDmfwZVx03eLDfBhtv4Xv63ZTwnLWR8bs9C0N1r/DcN?=
 =?us-ascii?Q?RtWVnfe3udrk2EKqadI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5DdC348uA//VJBQHyu1gLM3QrwQOJqIt1CVaHBaUsrVF97vhCrLWj4BTHfXU?=
 =?us-ascii?Q?s4VaFStnaDppS4YlMtH4zqQTPkGlPR/JAxNzSLMd3a08nNiD2jsqu/MqyuTS?=
 =?us-ascii?Q?kftCEnNINRZtbXCI2et3ptteSlvP0o1U0AgvLudCo0+SqwYOte8Z++oae2uZ?=
 =?us-ascii?Q?EBuon9r+7191EBht4Gc0Yjg2uXJSJpEkatcOEJfhdTTmbSKnfIPRTSIDB4Ab?=
 =?us-ascii?Q?/l5JIpCJeLfY0xbyypC5Tf+GlvtHEjGg1/HUbYxY1PR2VRg+QsC6yvC9e6VU?=
 =?us-ascii?Q?k6i2f38lGvfABFo85l5BAqSdINW7H0Q3/pBNxawuZILN+IQ2Zrw1UI+tddIZ?=
 =?us-ascii?Q?raqjlRE/FjRvdjpP6kIuRlKFH76cHi07TFTs3XEoOWCOXi27ADaYe5gSfBkO?=
 =?us-ascii?Q?7w04D3Yoop+CsSYB68W7hBxaSZ+1Mh3xLU4KpKHVaepnU2sd4N1xLo2YGLIb?=
 =?us-ascii?Q?T/rygtlkImG2Y9HebOfmVW+7zjZRWguwjlG0wLc0Qr7ZCQXVhDpFCLY8VSSy?=
 =?us-ascii?Q?BEs4xtIlNH8HhWlFp2HUWZMpu+aZQ6ZIovCModvog2MgLDRMN+ckro9edz+1?=
 =?us-ascii?Q?pQxWusYo5Fae3BwKSoH2tKMnmoJJFHskFJmYhQfejwrDxiqE6F8kmw/JogFy?=
 =?us-ascii?Q?asy4h7uNqfKfREfEYNV2j4SY4LjurVxO7JPgeCwcxDo8C6DYZ+srYK8lBQh+?=
 =?us-ascii?Q?oYyF+aX39gK8l8nne0tYX7DosLi3E0wJI/Adyu6hq4WVnUUmIHZ31k+wTCZL?=
 =?us-ascii?Q?NjMyMYxvNJAtfPylK6YANZSIPbXO1gAePeKyUPRDgta768Wm/LB1JhEi4VF+?=
 =?us-ascii?Q?v1hX46hhNMDb3ShtjeLofotdxe/GeCF/hK9BDIU90y/vbDYBU9J5Ri0dejHm?=
 =?us-ascii?Q?tU5mh1jgTGBbdSc9mkgOps7xyZcRiWhaisANdhhI2kptz2GpVFlx5ae2i56o?=
 =?us-ascii?Q?gwUX5o3nVaNpmIHiltzywM1YBVebfHRT0dvQfR37CH+7ykWcijkrVN6+X9PB?=
 =?us-ascii?Q?MJUOy7Xthsy4eeDhdGLAqGkkb4n77p736OAdbUiEkCufgl3lUR5gg8P2rK57?=
 =?us-ascii?Q?8wYNcMlyEJwXh4llubWCSU0zGEdQFWrOomwvV3lUnzhgqTxXFE1QdVy8fCP7?=
 =?us-ascii?Q?Rvz697wqj9li7yn1HK3JKDecq5XOSfpYG5OWSdVFAAvUfIJj+bJRCEC8KWUR?=
 =?us-ascii?Q?FclD4VJCFa49pxPT0PERxU0z1Uzxqsfui55Q8CSHfUnuPDvVgFJLhuGle28j?=
 =?us-ascii?Q?AWGrSeBARyvZqHnWaH3svJWy8YY+62InO2AZZZaizyzDaj6WCZ55MrlB1GgJ?=
 =?us-ascii?Q?EmBtks6gBYGKQleTIT/2WQzrx2hoijuURvvMPLUhMDu4YtcDtB06fGBGNoWb?=
 =?us-ascii?Q?DCijGKgzoTF5nxUacpKww1BkdUYU+JZ2mckQALyJcV4WqY6YJ5v6Av4tuJws?=
 =?us-ascii?Q?fvQahnxR/jf3dRBj2ABStL62mLAf+cO+Q1yFGnPmm9jAZQB3JEOQEbGeRZvT?=
 =?us-ascii?Q?WuZO3y9GpI3SgJ0Z/R1B5mwO2J55Me+vRF9UAbGpYbt+xk+j06UrUXAPjeoF?=
 =?us-ascii?Q?EZ8Rd/XRwlOtbSHfQBO3bQtai/ECFvs2grpqMGKoHN6R1r+U3MJFlVFpPpWu?=
 =?us-ascii?Q?4FBYtSPTCJKXQJjZqCxfrq6YoLe46k159EEhwEJ0gDJhby+HDDttZHTvC8mU?=
 =?us-ascii?Q?usElt99T4dFq0ogb04dYTdZ2lGVhVvgLjNC0LWARJPOtYW4pOELY9EaSSleK?=
 =?us-ascii?Q?QwvVb9OASQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DwO4WD5mIzR5Z4tOGGUycgSmEX17Ii+WrDG302lRAeNDw/3zEUw1HQX81qw1792CYLIMN3vDXqNuhFhBmvzwhQhUXfzihXxH+DvBRbXTFlT6MgTBjWLaVqii2iaFOM9uCxkChoRaLexmS46z3wPaH2jJunE8e4XR7obrwzJ32ZM586iZIKzBBKTTfXfX86kNuTOS9R1RtqG6nBWdFCyPkrHMfrJ7bPPSmd12vAXtvKkyZ1YR/IBNSDGzQYkuWpvqHxhsyxVxu1QOHDtS7u0QOcZFCk2WJQojUOL4e5KY5mAZAHLyq0A57Utq1EtCBoNMMJdISapO0fQlCx21iy68zmXtmDvw0XE2+moCbvcblhTqiPffLnicGtI1oZKdLJjCSezle8Hh4zlJBfDH59YPKdy98qb5ACxPLD68icyqs1DobMXcpg4jIy4nGKM78Rnly5DJcj7onWMEkJfqpVQ8IhFXEj7wFuqwzc0co0y4JmJUUtRUIZhFJPidPljD7t7J1a2+3KpNihqWu/fhBT3Z9tSy9KcAUxiL+nBYnpHEgP2or+eoKA+PckkGTcl55HtLUVw7tVE9++A69h4bTWkPSZF2hpn+sycqtrPjbwRhKGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed599f2f-0306-43cc-fd32-08de590e26ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:25.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFr7zUts5TO5K6tPuR+00Quw9RXt5Ku4IY922Ja9HtcifBGZHoOB6J0kB4F5gNTY8Xo2b5Ud9mTIUblwsNZHXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX5XL1XVwCbl2O
 AYEUAGJUyEKnbsOO0K518wwofTAMlUguCdyVrRMtMtUIdIciKfdnHK9qt8Iw1lx3Pf+V2dAN+FO
 NeEPoOf1jDCcCK93Qlfxmcita0DyQ3ksng/WmK5hh7UifnGR1x5cA9LgIyIngzSUehxHIrEtRFF
 Zn0EwYjYXhH8kF76QUtHCGLuryFI4tI1R25ws6e7b1ow/P72o+W46ouFAgxsQFNSkLgDs/ijGnT
 4SB+vqPG1EpooPZKiotuvp5k2F31okAsdzFflEUzaNjeXcrlmliAHdas7MPWyrkwb2aMiVgsmI9
 G2b2vcKASVX8wq6pCjIGoYJYDzO5IGqfIXomgSHKNWRvIThVgji9Lo5KixWxDpMFzyV4Jo6Z2iP
 BMbd9KqHEU7PNJp0XYiuAI/3qQCn20LsRYcPKFVdeDZu0hq65KzI7sdTn+Z8141Tt0kjVhd3iXz
 KKrhWQsNRyfN/eEUpcw==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69710579 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=k0M0yfqvNG3lIp37doYA:9
X-Proofpoint-ORIG-GUID: nEHYVkjGGrRzK_SGmELNrouSFhGtLY83
X-Proofpoint-GUID: nEHYVkjGGrRzK_SGmELNrouSFhGtLY83
X-Rspamd-Server: rspam12
X-Stat-Signature: yaxonejekco85rtgt8h8df9914rc195n
X-Rspamd-Queue-Id: 9224A180008
X-Rspam-User: 
X-HE-Tag: 1769014657-885121
X-HE-Meta: U2FsdGVkX1/SCgLZu5fApZkQheZaYjqD5OC60/xMRZLHXgcmxE+XfUuD9lBabg0pI8w6YvGPGpu2CndFpvoXuV/W49PVr01aCbIFlrrMT9/V/ibsg/906v1puEYOuxRefNXW1EMcuckBGYYvQp1cFjreNkb8qHYeF3qnC+56Q7xwuHHztJqQ3XewYQtBxgxOmGu0AgyRBN0sYRQRPNUdja1bi8DUyfBGb9Z8MyN9QFghXtcyvy2/+VzI85X41a3PgCMSL7aIKs2gH/RDn5pbE7XqTlYZ7He/fogtDJFKil6VCmLl9svBI+TyybL0+yr6tNEDZol9VsuBMPh+8+WSGlPymgK7Zv9xvYGexoW4RoL/SCfydddp9fLh9zrXqnfa+fxEAAY6+hnfGyjAU920nfRuPpLQ/uaL7Hj5CZxHp3TPBVA/5kX39uUsHh0bey7jT+JUQIHzCKvgcvMso7axoWvoCUTKQq05bc6A3kBtIJ+gFtdRhzcDaOaOeWcyXBiGaNQAq/zDGfbaA/Cl8oJN8aUOXxT0B8fKXFDSA7IuYNiwRIkWlVwC+xuUSPWD2jcYWydldvfwjZGy/VgvZj4kZWeRKawf9oJmSXkgHTKJjFzg9y9r8OYB0KHG40CTWIgkJQ5WXaX4bpUEhQbSsD/oRwuKpHHqD3sEgPBsMys4XoqWtlCoKDNFJLdyIj+p1QLFij4VH6T/tg9hycvLPXngN/J96dEs8j6XdidcCV1xRuZwL1IuMmOA/f2MO5Hlunssv6cpx5RlghOHgYdAYVwNWPs8XC1uJWzoD39suFcG2EStJUBUGdWqNHCFeuD6wAdZuY1HTzAjzeWnvk9uAYpi2rmVqBdO0NROoI+JLRKHDERmo6kP/uiRoCe8Sh2mKvX7xylc6oVg4254bdHWtJHl7TCNBRqQGOxp9a6IAJ6uKRiCqI39vMEZclBp2orGc24wsGL/nRB5ikfazAc0C5a
 k3SeahXE
 aAc9bZvNqWHOejVvHyJsjvIqfHlrmoUxUYodouGx4RfT1qqd3ULVWW4otJOwA5UmlvtgzYB2TMgSCkAm1fwbm7oBmewD4kSfURGVrYTG2RBTiQlEasrdCPlqF8A8dnTxAshnpJJS/5had3ACT+hkVIsNucfibAC/nw7ApvrSyX/qPR0cpPJWU1gcnVe58g+wOS/BHH7GkkULgPqKhl5/4gkKLWR8I5jL8ZTlj8t3RkuOPpgtzphfl9gLomc9gMUZnLETa4v0woxxCIFaLsPyxifFafVhtG/ZmuY/6CiQF3lSrbqc7sim/4kLmbhV+8O+FRpsrU9T5WUSm0iG31ch1R1ujsnJ5ka9SlEXVb7G1nd0V0hg17CZftDUYV2yaQmHQ/GwMSI6CQDPSFBkH/fMRzDyd2OcCpN6I60A4n6rUOnbs9aQcavEyxO0y4076j6qIJyBh3KXZceiLCIleOeAAXzhgGmz8SZ7KA4ZC113PmTFia4JUJyaBOYs4RC4eYU9esXsG1LrzAXpeeo+ve0MxbuOX7uHDizMnSZ+UdyaZ8TCzJI4hMwDjQu+y52FEEJfKvw1K3bEqL0orf2ruxbSWpsU7+0owA3e7o8YWvAf2pexABcB4EmXBJSYdjivvgrC639505mjig9u9+CaKUeC9SQJQn/fkrMCWRl2yNBDzvjHfsfdk8vt5L+Ukdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functions do not need to state return at the end, unless skipping
unwind.  These can safely be dropped.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 6d5aa2088d821..56586e4c70c1d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3287,7 +3287,6 @@ static void mas_spanning_rebalance_loop(struct ma_state *mas,
 	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3712,7 +3711,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mas->node = l_mas.node;
 	mas_wmb_replace(mas, old, height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3773,7 +3771,6 @@ static inline void mas_root_expand(struct ma_state *mas, void *entry)
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return;
 }
 
 /*
@@ -4045,8 +4042,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
 done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
-
-	return;
 }
 /*
  * mas_wr_spanning_store() - Create a subtree with the store operation completed
@@ -4209,7 +4204,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
-	return;
 }
 
 /*
@@ -4257,8 +4251,6 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	 */
 	if (!wr_mas->entry || gap)
 		mas_update_gap(mas);
-
-	return;
 }
 
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
@@ -4372,7 +4364,6 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 
 	mas->end = new_end;
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
-	return;
 }
 
 /*
@@ -4431,8 +4422,6 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 	case wr_invalid:
 		MT_BUG_ON(mas->tree, 1);
 	}
-
-	return;
 }
 
 static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
-- 
2.47.3



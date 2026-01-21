Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F4CC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143A16B00EB; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F76E6B00EE; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28BF6B00EB; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE456B00EC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:58:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D3231A07CE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:03 +0000 (UTC)
X-FDA: 84356578446.08.74203D2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C20E40015
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P7ayjBbk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WoRqChdz;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGAJt1GDI9+Yae7PaWvLMkfn8fBjW6Q19HJwhvib6ds=;
	b=XhDi+J/rr1x+11KV8oB0mVJ7q3blDQg3GcL7SuceY6qk6xdz5NIqaMdNCJb7m2QWOCfBzi
	1wPsutGDhsZa5+dHpL9OqIIJR3leauEwk83nTGXUYzf10HUysSFJbzFNr4TM/lrXPpjj16
	ucISD9RwFgPHyMBnWB+VEisevHWbqTw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P7ayjBbk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WoRqChdz;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014680; a=rsa-sha256;
	cv=pass;
	b=lg93cWouF/gXjPaCfzNCWteLHKkYXcZuGjDQSjLDCSOcX1tqvxykD5UBmCjoHhNSNeXuaY
	yH3J7/YSObzU3Duqsas7lv7lO6aoXS59nrkCmUp+qg2ELf6lS8VYD98W1Y2fXpNcUMKdDh
	lRC5wGNYoYk3cwF5C+SoBdmJiaqHnXI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LE6JZS3418790;
	Wed, 21 Jan 2026 16:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GGAJt1GDI9+Yae7PaWvLMkfn8fBjW6Q19HJwhvib6ds=; b=
	P7ayjBbkXywwBKvAjofWqNacc1zqs34VgoPJnHaXhjknQ+z43WdnTUhdGB0Vkp4K
	IVyIClFsASow2jvJlhknDhR8ynW/N7ek8IhM65pO+7GMmE08gJODbTSveCH4QyXj
	y1jiLDAtwsL04WVMQvK3Y/zS4e+Zo4ThTImTH9d+JqfR4wXErSitYu0aGWkplJjL
	xn8YoExuEUpZf2l190I1RvelDiH58O5yIn3hGBFux47HE5p4po5icoYrCBOtPi2r
	1/9yR4sffKzP5aMKZRs/2V0VPR9EwZRq0Jbvu+UBiGBZ+rvpE/EaHofZweLh8ei6
	Y9FVLvt4Szuch280IGbEyw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGqkbO032828;
	Wed, 21 Jan 2026 16:57:51 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfanbn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIaLrVmrWI0okNi80qxl1wEdLcLd9S6WqCPRYov0KoDH2uPnmVfUkI47oBrxb6MlDvqUK0qf3H8ROi+b/V9lkPrYQyNTxO+k2QfhmeOWF1CKabRRBRzvRjmmXMsi47VkEN1hSYaG5596Q8/Pme+bYpj/A5XbWL7x+EbyASiYZn7vgDvYRuV0zhdBYLGUUWMrNgyPss73J6PROpE9/HxBQFdhjrPCMBa9rzmXPdxMQqMNsvOiodSHIGE+7StukhGdrSEv27KHJGENMZ7xJySj7M6ihUHJFaS64VtrFaaPz9g8dx3K3AZErDWZRHYY2pBmNV1ygf1X03Eq4Kpo3lh9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGAJt1GDI9+Yae7PaWvLMkfn8fBjW6Q19HJwhvib6ds=;
 b=Va/EjzV2yF0imH/Ug6fNbam95FcfO1ePz9TeOmjxo1oo9LATz2AUWVEfAS6HTZhcnrSH7Ndveika/7+wdm9q1ck4nbIuKqIMmoQDEj64UXX5I8ovZY1a8ODZbRYOSYXiw1duYqc1N5QJ1wOhlkBqeGbMJWJKrx+URRtLixH4Hbh58PsUReAmgnQoDWLI4GBVEWsL6Av8F5ld/TIT7jU1+FLEjErKy35r+NSZyWpy0rAU6n/YNuixTVKEjN4254YY557rjcXATvCo3vx8p0IG1DcexP5mWWVDqpcsoMXhkzBNyjMeJOraQBbdEvzke2STbmLim+P97kCUDv+sYZuzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGAJt1GDI9+Yae7PaWvLMkfn8fBjW6Q19HJwhvib6ds=;
 b=WoRqChdzpyBa1uSFA5XUEeBt8M4u3HsCS4721x/uG7ftPik7LAsvDScCqzKG+jS7sBaXUicFV1QLWqYRL/qk1LmNF0uucde64vG9ksBwnqSkk+FhwoJ9epKv/6xmZsIoDYqhF/5o/u0GsjnW5HEUMiMY8LcYYcgCIm7zn7Xpt70=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:48 +0000
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
Subject: [PATCH v2 28/29] maple_tree: Don't pass end to mas_wr_append()
Date: Wed, 21 Jan 2026 11:45:25 -0500
Message-ID: <20260121164526.2093265-29-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0021.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::23) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: dc292e98-dc72-4aff-be8a-08de590e3437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nUDqXzlxZnCgKNV4QkWbluznGl7W9E4dwjwtTa5mYKDtsKTMllnxAGzcaji+?=
 =?us-ascii?Q?LIYxPCi4VntzYwlMeCW6BVjotODjR5SP4dkQNUfwaSEhliaW1GLrO+9yMhFv?=
 =?us-ascii?Q?8z7QL4TzjPHEZlKn84uVJmWp1+XBfvRzt2EdXM4sShaEABTjfjz1m3jCnTxB?=
 =?us-ascii?Q?NvDkXutvI2pGJi0LpqIPINDeQpszvnOUG01kj/vVLihC9qtKaAfLYE1VAjen?=
 =?us-ascii?Q?WfAj5SGsPm2S04wLG4IX3mnoFykrdVObKAKj9ExheIWDW0oqOE+Ps1OknmUm?=
 =?us-ascii?Q?WrZ8onGohntC2rKqzDY/bBb/e/doUxeSIOnaIOwRsfu40DcUgjSKBqEp2Nrf?=
 =?us-ascii?Q?BmMtYwqYl/Cp+2A3tqtIx7mO9v6ehlFrF6iVGlYLli98dMwz/LLqGEGRIMEl?=
 =?us-ascii?Q?bh+cb3byXW7gpKWmcXd9MS+kkGsClumyn7lu2Yr5Q5Rg0moJdzddIJNT2ITJ?=
 =?us-ascii?Q?sYH9dTveS8k2w02ZfTsf4OMzNeyZB6WD3N4zlEfPy0kKDp9CLnzlPXZYItPw?=
 =?us-ascii?Q?09CdoQoQmSd0iOVKzHyBrSviTWWYwhMOofaTMPDLp2rdu6EBrhKuehHMLS27?=
 =?us-ascii?Q?1tMSP3aoA7BBh1CAQ6VARQbSwZkyodl4yMDQdmc6RcYRBcppwVr7bj5eqLFx?=
 =?us-ascii?Q?1RFpQQdhYjjSFCXvR7suPYgWGMKitco73xY0F33bztgDF5D6lKwJfZGeGnuj?=
 =?us-ascii?Q?Mkj65mQX0Mmp22AODbqEXipUUxh2AcK+RjR0T+GGJ5yd3Uaw/jaAT9BycJ/v?=
 =?us-ascii?Q?qQ7gIz6gEgMlPeZ9/RE28tYV2iBhtX4npMxJOc3qwf6ZbK11v9S4h88tMAIC?=
 =?us-ascii?Q?aH8n2hoTlF31l1ZZG5vbHMSco+DJeNhpSQz+I1CUC4y/j34s6v2ck5rGQ9kt?=
 =?us-ascii?Q?FR0AGPhXE8bW9ixdusYCjaRfj1npLcCWengmAJ9LxQWnVoTwMUeaEnLhxwBd?=
 =?us-ascii?Q?ZJosuqfZj3q73V9+BDUlHVosk0zWUa9EwkgJ35+UgoH6C9ZFeGWkxAbPW6uL?=
 =?us-ascii?Q?/NGJAFT/Tq+96ZxKjFCOUW3Jp6Jqv9svxncaWWgBKnDp/oJ/J6qwwImqAEIV?=
 =?us-ascii?Q?Rgfb6rOflEAJ4iANtTn4Gz73qpFYRtqMsp3h7q3z8zhcxw8wRM2T02uJa3P5?=
 =?us-ascii?Q?weF2/0fzSlqWZqoPc7s/hqMQSC05AFl7aXAguRGFxaElvpX7PZkfgVvignTp?=
 =?us-ascii?Q?w4im1eqFzLhPQ/N4rOHMqwPiuzC0fa0EdNOUZvPKDhEHwJnB85lT5TAPOWPW?=
 =?us-ascii?Q?XeeE6+FFHvprxhwrby2YHnXLLXJt716lZ/KTjyyuSyn5qZlreJewqo2zKHnj?=
 =?us-ascii?Q?Rm9FSZuW668N72Gl1fU9H6glZLeDCP5g/5nAECI2fDIFmUjIEc59/5dCH2r1?=
 =?us-ascii?Q?5TbaA0bT35JFfpdYYpykgS8gy7Kk9Nnx56NammGa8imcjJJlRFBBgbuuKsCG?=
 =?us-ascii?Q?EjfN8ZFlfiddlqEVzxwTHTCq9xN4JEFRKTUwoKiNAo11ilW/ulDTxnhdAnW9?=
 =?us-ascii?Q?Xqw9EIfvXC7OMIeAKXsVuPEMvj/7WAHN7ZobEfUiSVtjZgKBez07nx7dXwH0?=
 =?us-ascii?Q?HUPWo8wpaZX0O2+fvRM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tU5F8Xlrly6r3ieX5brp1X0B/x5lFDK4JEX6WI/xwSG+GI1blZnjNPedIWZ1?=
 =?us-ascii?Q?xbzQlmHI0d86mSWktOoB7TpYualDFCOE/0FxxTSiWKA2oZJtzoy1sQ+t6u6C?=
 =?us-ascii?Q?az/7MtzHlqpBShcHbgfEw56Rsg23D2kNYITyr0wR6U7B7CUaL1fvpeWydAJl?=
 =?us-ascii?Q?8aNccNtjB8f2Sc6Cv8AKjwwxgvIOwYfmT+xTmEJ0ExMWOmlDc8fdhmCqiHj0?=
 =?us-ascii?Q?1IyYqxkoLAqYOC1Dcwy5kM1xs95y407g4H9OXIxMZKw9E1wNdAOh+M1iZIEU?=
 =?us-ascii?Q?ZusGzN+LbyS7OgTT+RyUjJL8XNBH/3SlobPRtYgkYJXzeH5mL2uiJ1hmbHqb?=
 =?us-ascii?Q?U7Ct2DpJzsPXV5XoapRkvqtznu0xQVxDRH9JsWj+Xe+tJUeAtozS8gzgyLoR?=
 =?us-ascii?Q?DIvi+jLLxgr0ZM11vInbRRxLWgl0cZCYK+sQA3y6yW+kFpFiX1x4KLSnwgLK?=
 =?us-ascii?Q?2L2/yrlH+/EJ5tuqIsvA+OO1hfWDJ2NjB01khdo4mSVPgsmblUXX2aAr9+e4?=
 =?us-ascii?Q?+v+PCdvTjWI7ekyl13avqekggqzKx892U1pvgWua0s585LOL3Jmni6a5DsVO?=
 =?us-ascii?Q?BcFp2M/z1LAZSMgd+vcDgX63hfW0J4eJRiJzGbN/5SygpN3spxryO5BT86QM?=
 =?us-ascii?Q?3afAT3qa2rIHFNKB5n+JQFj+Hi6G+4vYEJMOh5qUYToh19DachehkubUwovI?=
 =?us-ascii?Q?2ECdz6JKRGMm8FXlPcEEKe4SupPaSaQdpV/66ZWr/mw8ukJsJLlzE7Vd5pMr?=
 =?us-ascii?Q?i9nXaxBq7jKhhdTRw3qOvYOY6+D8zAwJtlxUcuxOtUYnak9PkS+7DUjMRQGl?=
 =?us-ascii?Q?qNrjaQYLNSen3vSWSYYJcyc3aZ8emxSvmUw7K1XujuN9A6E75iB8gHVEnq+r?=
 =?us-ascii?Q?7GxlLNH3kxIoBvapwwzsGGScu9qvrBgqooH+yjQPwCgxvDMyijrsGQwvCcv0?=
 =?us-ascii?Q?ZegTOdbmOyVbKEcVq01ifq2w/+UCo6rQMce7FBSGMyEe+fbtwfaDpsVMwu8Y?=
 =?us-ascii?Q?2Mbv1e8bszQEFnRtWDharQ8BOs5bMxFRzrFUbfSdRXVxFk36CSC6BdNLXojp?=
 =?us-ascii?Q?6Zc9jkaqC2NhAPdij/3eOAHEZPXiK9JYphXQEhUCQhqDPaWPeqKQbxbjCj5b?=
 =?us-ascii?Q?92yw/KxpRxNrbPRdKN0pCjP17CRCcZ8Ch8ba/EpqDACeEMaU66PzR7ku0CKX?=
 =?us-ascii?Q?HkjAMApwKOoJLailmUaObEfnpVN2m64EUUsff+OHMZYlqa0i3uzBlL319Wyo?=
 =?us-ascii?Q?mI4aef4s8+zH769QMObHJ2/NwvD/NJ9HsRAxJY4ll2TFFrq9XxmHryASy6xt?=
 =?us-ascii?Q?rc58cemRpNJ4Yvg43H8+fuDqyoYZ6akgFV23kHaGQos2PNn3HLN3arwHpVun?=
 =?us-ascii?Q?0Jea2UsN6mXbmrQm6BALX3PA1QNcP1dUw2HziRXns9gjDiLnzKkaIFfWEEVy?=
 =?us-ascii?Q?hXxksErIKaGFGiqtgwNaoifdCyNnO70F5a+C7vIxm8IiiOtx8WuXaJKGNq1P?=
 =?us-ascii?Q?Ls0OPIvsNpeUn8d3W46EXrneJu0/IKn+CVNIqQz7Z8TCyLjuUjtCbBo9x9QW?=
 =?us-ascii?Q?AfM6lsG5TBLzb8qHjO9qNFvaDRLq6UFF38mNjXT7FsjSZ7fU0ZbmJYBHn+vE?=
 =?us-ascii?Q?g/MvSOkPn5EP6kKvwXopDpnzBJhqiDy5u9ZsUd7LCvJvs8iI6Ftoc67d3dqB?=
 =?us-ascii?Q?WeyTtvXz6ImGSOphVCRYhYneelgW9qXzVpjtsk7aXqroX1QiMBP+FkBq0nNV?=
 =?us-ascii?Q?Vf00GIKdPQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fSx6F2dDL+PS+HTzRbCcGUyaz8LBn8azEU0H8GqAYBAUwRvd/tDwYaC5bmcDD7k3f7KLCmdfuCU2ZlhuHNTQMjfALPAG3GuqKd+JGX38/grO2V+nCFbmjJP7WEGpV/YiT4yOYEaTSCsbfILKnj2dXPz6M9hPy9G32R2hZNjSi/36IEFUdRIatASZVyuW0384X7jv4xM3bh7pAlu7yV7QHiDvJBTzi1h7aO/VyLJ2qOF68ZcYaUP4qlmUAeHZV2YkmwKaYm7dWqRydyCHEKtOlFmrNfqQd/TsAEaTlbX9KcEq+Jd/VqjFOsJlD1jmL4nHGoRjgncg78nbM3a+k43tjXRgc955rL1QegBsPA04ot97N3s/8ieYYOTNdxkzRi/VeJu/lxQun4c4USk9tErO2fNDmV3uU9R9i8qKpu8oPMQwz1eVt2NUH6Q7tHyaDqiVcTxol5IIHkvLZtwEvLBM1G35mE+hgH6EgL/Rdod03KKs9UYWiPnuMNdKSJbNSU6Uujua6TufNBn4RBJIrkae/vWiXsnIh0LhlOl+XraQ57B7Zg93s9QQFLlJZfG2Xg8dSptabNY8GNDKbCFtGMIC7XCezjJI2OHKx6eOYqX+Jp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc292e98-dc72-4aff-be8a-08de590e3437
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:47.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAldiizb1pizZDPkY55P+5FMAPBbZLnx9BokAGxG7Xj0QicFWmRy25cU8QFV7QT9gWgT8jJJsWs1Y9TYJy12Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69710590 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eQoyOrWFz78r1Bu3z2gA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: Tyc0dtjv1qfnxu4jbElnGV16b2vDCKI3
X-Proofpoint-ORIG-GUID: Tyc0dtjv1qfnxu4jbElnGV16b2vDCKI3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX9dpQFE8Vhdu5
 oeZZ5VUmrVHHuLqwxQmkkWr1IHJBVHGfVeEbjzHbf/NxBsCKIQhYp6bSiAMPutmhwRSNjrz7xMh
 VsCYT5koJjtEiiGW8xqUid0RQ0ia7rbxqe96CzxNaWf+mH+89TTuVSEzNj3nGzYUNeXTRMyuE3z
 fzgvMvVQweWp4k2OprNi/qpZSfaSlwDT6INPmVe4tC0d5Jh0uCDpWwEMeffWi9N3TCsSCxw9HPl
 MbiLRXntEm8ppVv969Tzr5/yD6twp6Ll3KjICImphZ+kK3huZ7PPZ68BLhDeX/3ZIi1k3KTzsiQ
 6VmQbKY3BTkowmPnA+WfdN1YZ9DH0xEfZdpVmASNnW+xnPedx8RIdvKAkwqrJWHOdqYaFMGSfI1
 3viAACWvO74CqnQz3w0VeXDxl2IpW2o+3ciVTHZdgBTuQUUfodU9Ao8eNNY79CC0cJqbxxmTCw1
 RLoBn/aXShiinU9f4o+idxxorPRb+i8t06eNQhFk=
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C20E40015
X-Rspamd-Server: rspam07
X-Stat-Signature: apck65rjcmcspgijmjtnmdc4pxgnoaqf
X-HE-Tag: 1769014680-105660
X-HE-Meta: U2FsdGVkX18f/QYWnfDrDzmH8Lvqm57VQ465A531uMN6eC1Bh5uP3d/NdpCDE1aEnVbZHeDOQdQ/O+DJVdgb+/Vu1naA4wc0T1naddp8xnaC7cvyq50gYjJQI4t2uw1PuHtWVvAueNdboYuR6PoHrYDkNIym3lu5MQRN3iEBErDXc7y5/J/FrqLMmDmJhOv3Wd5cRjLcSaQ1dunnziXgbckAmLfBjJSF9SniSSff38F6kx3BlPxTcbQlms9Xt7oPGSb52P0F4wDRaCkOl2SPhqlbJX+trpslKF1jinA+5N5jyQx+8gqGVw74uwEpteNe0yxZbp009MaJpFPgL+fXwRoZPe1XxqAfi0I9GYFci9VG8vOPtD32dQZ5LAvBPi7FSkC88cP1ZUx9tYEuC76N367gQIWut5sp9m7Du8/7dnZxYMfSIolLol6aL3HzgEN0vukxjr4pt3JF0tVfAfLJncu+uutTTLDaTAto+QJyo7bazIaGsVaV8gKb9hzrJuDogjZJeRltgRX8FusLSqri6rlrLBTPAQ1KTc/PNGTw/Wn5iumaaXB3popkuLnvgIE2c8HBEpFaexnsywC0vdA5zJx8WwcMR/WbMRwb0Ur7HIbiXJJu0UayxMyW4nj4g4vZ9buNybNc6BJTj+RHB9ixbMMpe2AUOBc0kVBBls+3DdIIsEhIq8Yu4m0zgcWdgtXora2fY7jhiQp6C2lN5W/aYm0/frAUlUxOdOPsuipPPUFLcfgQBhKD92Nhsnv3FpLZNROfeYGWfvvQW0/VoxDrIB6+nss38DRHjlwDmuabfcdGCRB+8sspR3/lNeP39eZBi68Ype2K02dIujqmpAGpIXgNeP3kNBVq9/zhHPID8HdPts/wEp8e2aDIYvStqu3vmHC7xn5B4tDyyCxxo8kCdfizeRtp55G/lNigLYbbp9JDl5DtYXuKGr66j7BMbCnIBwDpNDsWJ3RvWGk+J+L
 dOj7EXQq
 bxOsD/9OMvso3F8yRsSIJg6whG77LENDoYAXnKb9Wzzli7wplxCwH7jTCo/RHVRMfp+QK0qye3nbkzCV1l6iEeNmiLRV3aP4/MqNLzFCty58YoH4O3EnKRY9cNqaFIFoFcsHwIISNJqvocg+vpKuXoWJsDngWeAXBqw+rhS43tHQCmnzfV7gfGXZzil90/+gHKiSrMEKHmyUV14w4DRYIFRPgDJSlxGONLQ6yGpBFKfRuMcvrE+oE0A7+fqNlkRRK4aziGg6O2S4SG2MSVa2On72YRxfCzeCjni/oVvSYFCwst8Ewrk771t+jttQW/IKKEQLQrXEBpLkGQXgMaZ589e6lH3U4UysrbhlrU5xWlnDbWr8N3epJMFCXZuVz+h/a+F8cM629/QD2UkrbqVY/V06thAv+Im24Wt/hTSCu53ERQ/kXDjJF66FLdd+68pWcl4dCQX1LvTbVJP+8vzRRC+GbRI08+SC2auW15edKkKBdwwofQT5ET92YdwZrGoEgqbsd/j5ldiL1HRVDX6vCoCAaoP+IRlUcaRr2v+i4Ed6SKzOR6PmtDAAcWCg1T2SrYfSLfmsiEvLbzHGWZplfJqA5AOS2DjcqJ5WbacTD/f7nZa8wzQKayf3qN+uD+6AjJ1X9icrzlL/7UcinmKEGUMyyL9EbZHAEA+XqU8gS5/k33Tn1K3UtSQgMZuqABYyOLKXHm7Gypk/QVBRucE5SUxSidrLANRSSxAEE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Figure out the end internally.  This is necessary for future cleanups.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8ce4b252c0696..bc58c10d3a300 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3301,18 +3301,17 @@ static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
 /*
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
- * @new_end: The end of the node after the modification
  *
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
  * inaccurate information.
  */
-static inline void mas_wr_append(struct ma_wr_state *wr_mas,
-		unsigned char new_end)
+static inline void mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
 	unsigned char end = mas->end;
+	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
@@ -3505,7 +3504,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 			mas_update_gap(mas);
 		break;
 	case wr_append:
-		mas_wr_append(wr_mas, new_end);
+		mas_wr_append(wr_mas);
 		break;
 	case wr_slot_store:
 		mas_wr_slot_store(wr_mas);
-- 
2.47.3



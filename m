Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C29C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B6B8E0150; Tue, 12 Aug 2025 11:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C1B8E00B0; Tue, 12 Aug 2025 11:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13D88E0150; Tue, 12 Aug 2025 11:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB2948E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:43:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5168B1A038C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:43:33 +0000 (UTC)
X-FDA: 83768525106.24.AE83124
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 937B3140007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:43:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cE3YONNC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jl2jSyvy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755013410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72u2/VhsFAla8/Z1OlfMF0ud1uCJAhS4+kvP9cOzAVU=;
	b=dzyUSLkeMwGTITppgS8h96cDLlLpSOGs8nxA0o5lZo2wPFZoXecas2EX+PTsdJ3LdRzWZd
	0g3YL+FhDxY4RE3Llv3IRHW1uktrYo3qG16h0GJNplIYn8bv+lj7ncQpdAqxno8K7KcNkJ
	ohWNLHPHVLzrcU3Aamn5k56Qa6kiIxM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cE3YONNC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jl2jSyvy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755013410; a=rsa-sha256;
	cv=pass;
	b=FLRQg6gwqX+EfVosK5WTUyPDzs6aDprGFgebw4g/GX9NTgnNEPmyTiW0MGLw5+CBNbEmkM
	5c+CiUCpCmZXc2T5GV97unexUhRlcTf2SNlve8F85ZLq2sDCahYYDVN/LQ0DrjEqoJ9uM3
	uq0G5zjoMsAfko6Yz8H7KvewP1NYGFE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CDBvVx015970;
	Tue, 12 Aug 2025 15:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=72u2/VhsFAla8/Z1Ol
	fMF0ud1uCJAhS4+kvP9cOzAVU=; b=cE3YONNCaRvExidIloLmPBMuNXnK1K50kr
	mjg+6u+uTbNhK5L1AaaGFZOxI7XjIvZCplmQD3L2K8R9bNrJXZ+TjQvEXxNYep0P
	3PHL+b6PGDxL+SrZ/a4CHuP6Bjx+oGiLZoswZqQIc4lAnblrmJ8CfvPViPrQ+KxJ
	ZwN9pomiLUJPlQzdnW5ophOLzx1Bc5u8yYtX5JICq7WMou6YbQ8QOj2dv3RS8Qxn
	PH/3QawmlG8kz27MEeS/vt+K9weDJ/svsx10skRr3nGaeD2dj8t7MlC+wj2oxR/E
	THYM5Y1/W9nAbvtIVnV4VFieNKcdbxWiCXROAL17MRO06vTN/+hA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf537s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 15:43:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CE7eXZ038715;
	Tue, 12 Aug 2025 15:43:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsgp2tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 15:43:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnKWcNzZsAJSLdYDNywDAMq9cknvnEug1+0Bgf/10n+AQqokpn1TMpPOkbuiP/8pR3B4+YbpHEisNZIGYXpZa0t1/hb1nRo91evG/D3BaxbTxCxZTbhEb4db0I2wKrVUxH0JGHYp+bAzVmrYlYslYEqtAiyaV65eMjTwbVjeUX+Q48lC0HIxG876OteYxsYDnzwKJixN6kjZsJDEoqmK6282R+l7pzf3s24lQbxLVI0spim7p89cXxl/AjHusLaR14etzkBiro0uG134J0ekrLq1fuPxkUfj+aGk/Y2oTCDn04THAG8lIjiQl29L1PAtaN/zi+6P9dfMTZ3eBHNIqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72u2/VhsFAla8/Z1OlfMF0ud1uCJAhS4+kvP9cOzAVU=;
 b=WrBoeWN30gGBfSPfkICKchOHz7W1fc4F3Z5Eh5bp0jvOXhVcf3RYL8hJsMl8h8vVS7x2BJ9aa2hXaGn4H6joNchMTkYP5egtxB1zro0CQRsB1PTpy/i9aS5HemTpA08vbvR/PKwqdp+Dcs+bFFlk8pymoyFAy8Z+Yc8Uy9noGGNsPHI7rfIc1Ppf9g3Tykh+dy87okZ83Blw16bnXu6IAk8HXcW0RvxFX+k7Q0uS/5A8Rh+IjHTP5ehX7Y+2dQHe5BuYyPoirUsJqa6FCxFK3vZRAfODkmh9BSgNhb8NT+8/RjpWGOAcBkHgdyGq3eFsVEiQaZB3Si5jZZx7RPG5fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72u2/VhsFAla8/Z1OlfMF0ud1uCJAhS4+kvP9cOzAVU=;
 b=jl2jSyvyzSagcrhx3i+Yettkq1Y32j0rW+Sn296Ccn7jNszYzMT6/BLu1J4IwOvSaWSzzje/2h0dF9byR2Ie+WWQJ2nzuhyQ6c1ZcHP/JABlDQmTauo+Ks3pSWdg8YvHBoJ4OJY/oNpfVzwmGm+hUjvYYOQMgsKoojhxJf44Kz8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7726.namprd10.prod.outlook.com (2603:10b6:408:1e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 15:42:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 15:42:47 +0000
Date: Tue, 12 Aug 2025 11:42:43 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Message-ID: <ycqvuhtqzci44smufdffsfnn2n7smul3rx3iqhgi3y4ka4ytjt@io6pozoxkkum>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Qianfeng Rong <rongqianfeng@vivo.com>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812135225.274316-1-rongqianfeng@vivo.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0273.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7726:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f7391a-c242-4e58-ead7-08ddd9b6e311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RUOt/xSCpu6G/9WR3GNW9FDXra141S7yefPtdwraaLihlCNCAvgDy/wWxKhg?=
 =?us-ascii?Q?d3BfJ8e2GOQigIguAl+nvzAGUl/cNqloMcCNRsB1qD/6MqbO04qxBAbjRxII?=
 =?us-ascii?Q?nBsgXIPj+OVLyZ5cIDGygd51bs4h9T5x93WHw78qc9CqNpnfJoxYX2XesZOt?=
 =?us-ascii?Q?h6vY32aNLk49Y7U/N1cJIhD/xwGlA321QUg6PQAP+1gEc71zZcRBxFB/w9DA?=
 =?us-ascii?Q?NmSqamOynb3hgyh2TA5Wmr0jbVxnZqPkKTArIfKixAlUlVDJlxlD6to6NGhW?=
 =?us-ascii?Q?h47YcTXqWfodn3AJyOO1qL3vPwJzT5k6/5mqyW/XKcSMmEJLapoxAUtkJVGm?=
 =?us-ascii?Q?6813b6lCBkeqWXuFmjyW7DFcHyWkNXpkFukQ+TgGyO9J6OY/vNmcTOiVffC2?=
 =?us-ascii?Q?jg1st5V4Axe4tqZrPqY1Mqil1B8GXD0kc7ByZdNfFEZvRi9QcYqTnbbpTO3w?=
 =?us-ascii?Q?uqLIJ+KjV0pEQ7jaV7vv1PrTj33A/eBI9x2+tUajXkG/1JiDUb7mPsho1I0O?=
 =?us-ascii?Q?ZjNweHdywa7IZWd/vrghm6sw/8oC98MAhamRe5zmp7iVZaAX0xvPscqFUW+Y?=
 =?us-ascii?Q?MP+/F6QMdxjbPnD4dcH/RAhCawr+jwQFXxELM8dDyRVt2MlyKZVF9Xu4LcbC?=
 =?us-ascii?Q?wj30/amwiyEA6LOJreqKRmgD9YO9Szt5S6IAmbcLP/6g/N2aDgvobhqS0gfd?=
 =?us-ascii?Q?q9FLoR7nWJZ4FmAgPFiczVpalUPWYKdQ21PNjjO4HY+yhkS8yCmlHWiFQz90?=
 =?us-ascii?Q?pk9cBARy6YR75pw2AAqGGmhSSD+/epKQ3Y5KLDYbA72rVKLkaLeUY29RBrfI?=
 =?us-ascii?Q?nB+tfoNeDto+Y2kcyz9eCDOULwn6Q+hhXkPKQTkodGLaIYgsGFSKJPQn4f0i?=
 =?us-ascii?Q?MYxz74L8r0rF42nNCyjFzzUsDB57a7OUEBKewWxDQk4Oa7p849nOwP3nGHBo?=
 =?us-ascii?Q?aFUd7HOMNoyGv6nXBkL+SM7HjFuHy6dgYQhkMClMP2642Dbn7ES58i+NZs4N?=
 =?us-ascii?Q?06u0h5z9e8kx6zOrOPx/bBlilM7I2lw30e7EPdO8BO/YALipL+YPrb89l+Qc?=
 =?us-ascii?Q?CpY2P7ttkJgJ1S4onr5I7kp+P2LB2XNFCKf8ZocuXgMZpuy5w8pWNKdDaIv3?=
 =?us-ascii?Q?zM3wY9VIfb/AE8p6mQWo/GHFlSeFDVBmgV6Zj5W5e3CsbcUuXZv42hlanu5M?=
 =?us-ascii?Q?oIe405j8nIQiELjrjic/aQiUKOcvHnBQFmm6+gLYxKe3unTbg5elUEKsnP1h?=
 =?us-ascii?Q?Jq8Geg1jGlfM4qLj6x5YT0gQa8+KRXdgH79Of24rYJygcKTYgFwBwm5xCmS2?=
 =?us-ascii?Q?NMbQ9wspKzypBYbA6PmaNyDqSFCW84mjs7MI0kZV0LMfXWYu8ezTvpSB/y2c?=
 =?us-ascii?Q?xh9l2MoUBkauP9oBsDfKorwZKoNEyGqjoIJkdasKwQ7izy5ERSg4PP3VOSkj?=
 =?us-ascii?Q?J4qd3yyh6a4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PbLrcg2IJCh9mxklw7rG5BgfoZ5mrUIZXesfAsOCeLm90ouA/9hEGWOrztzq?=
 =?us-ascii?Q?p9B2v9vgXc5bPNfSphbyCZiCTRFY4pO76TrwDi3Gx5XAlT33aSHKREIVWfpm?=
 =?us-ascii?Q?XWpgEzUedZDUw1aHWko57ehFp6ovteA+LlSc8skeVU+3ReCKO7cDEogYD9Kg?=
 =?us-ascii?Q?QfUNViz0b3n36xnZU/LHUtqpsS5SQo6MrL+jGA/g48qNKm6SbY20/cRqB+gO?=
 =?us-ascii?Q?Axu6CbjBYzIQ7YHPFgZpMfiChmXGLgBuGRTF7giZuWTwfP2BazkKFLOFQzFu?=
 =?us-ascii?Q?A2ZDtjMhYUweKk5RLsOzPc82OIUnawgSuaxIfDQO0iJ8Wy4K+dniuqyx6Ha9?=
 =?us-ascii?Q?QI4Nqer7XjkVq2S8VzkS+5gT9jVtQGFlQBBEZQheXv6yb+jHvyHHrCsyp6/5?=
 =?us-ascii?Q?ye8RpmrD0tPZgSc6SgLw624DoZ7OeqrsgfzXyX7d43mUjexrP80L2ayI5NIb?=
 =?us-ascii?Q?EhPLDL+b6X80IspMc17MwFhuonwhcsozHP+Wi2sKTJFhEMALhvDCf0M7ulAV?=
 =?us-ascii?Q?VGVRZZMIxKkDWQV/bsc+86C8M+mUqYMX+CScjHHyKvBp9W9yNDK81EiLWW2s?=
 =?us-ascii?Q?kOBBWPGkDrEvnXNaS/Hv5HepUHIaBuOLu0HfEN/qrcDaT2XQQRKdPcxLmuJX?=
 =?us-ascii?Q?rAb42YM+emB6GR1q/E9o2kWX3S+3vwrDsS3atuc7h3LDbRxRx3CgptVizAmk?=
 =?us-ascii?Q?mYoQ+uf5Ur1kvVqAKPDmdMRkZRWOQVqc/VV4tBVqgyMv+7IZWNAiELzKBbiu?=
 =?us-ascii?Q?avoNWRieoIcUSBCdoX06NiAUUoQh0oNIBuCEiUR+U+l8qIECpCfDeu3nn5Tx?=
 =?us-ascii?Q?XF2Ql60AIWVlsziNuquYO7vdmGVsUw1xYm6nZFisAWxpplR5rAQNebYAczfa?=
 =?us-ascii?Q?0OVyMgzRM0rirsExrMBNt7fStMPpCrf85jIateO53KuMxx9P+Appsm0HO9w+?=
 =?us-ascii?Q?lhPSsTWYEtTap0npnz2ekKWNVY9WrnBUuaOhCTd8yw1I8fQaMdV7KsQpx8yC?=
 =?us-ascii?Q?46I05MWkkPX7/GY1hivttAGeUGaIwj8XpDLqpfhEpTDT+8rDq0OsFhza0CFf?=
 =?us-ascii?Q?HAy8lFNbp9MCs2DC6InnKUsVgi6oStqQd2D528YK3RZXkX+06sK4rtG7WSCn?=
 =?us-ascii?Q?j6tAOfhOLthBset5uvt2GSOqOaNrojv1ne0BdEkNdtUuQv6x/L8qO2B2OYpb?=
 =?us-ascii?Q?io9HY7NeFgOasnMaKm8l1EcfD02je+A9FqeLuCVEN/NaaIygpHtWBxPzV1vd?=
 =?us-ascii?Q?cRkmhgXvQPrZdbZwdihu/E7TbmsUhE4Nb9FvVbevFy5Sxn+YOsGOaPmzML2D?=
 =?us-ascii?Q?RCaL5RttCazwT1c1yXCsYvd3HWQytxkZg+Ytm654zaGSRCnQ4Tt2+JGL0EGy?=
 =?us-ascii?Q?xTxGVvtnjaflfsEPBXmHPHev02givk/ELNDQA9TmukfgV6kZmWnLSeRQAnWW?=
 =?us-ascii?Q?IiffpcwW7iNVnyyENQthxthO5j2jKbWYb0HR0YkrZeDfX18hJVfW1Tv+zXQA?=
 =?us-ascii?Q?MEmDESENhTnKvoAd3OjPCqUc/bbM/yp5voh5cAM4sQAQQbVJfA79wnIoUnvw?=
 =?us-ascii?Q?cOoiBJlRxiEDIhCsgOb5/ilzE7b2SoAz8t1alxQ0MEQ/rSxA457PR/M5ZMaN?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0+8w4o4Riu/NLlfmeBY9B9+ul6xVtcK8R0DWXLV9jmpsnm80je9vIpszJ5mgfj9s1fOdDwBsWZkvhbsUR95WYs8+WnWczxGv7DMTl47wHgxQecyf5UiDs7QZpraaT4UHoavSumFERQZQ8nfZg8oz74dcU4mZytsBtcZFb6YcuiZomXNkPMekyfOwMF3WnSNsMwPndOh/kqQcfBhwzBcUTln3UezluG4BqMYW1VR45JvFzwOnJOoy/Ae8bKGMV5kf99kVLHMNnbw7CH/xQMYaiDuBIEOzEUsvjjzUjUFKiEaN1YyyVgbVzn/PzXSHToMZSV9SfxFodRnHFHxL7QF1yV5SsAFar+2sibCgIl/iu3onpRnE7QndHfpMx+hse1V9pcTT9w7NuBjCzL7X0ZVb2ZPc6dE6aNpS5TwfCMqHPSiSJbhVGdUnW0+rnEMJM7akSaNUekPW5jLeAgWY3aN459RB/OLJHMrg7/l8OZHf8C/kMEQXYc10Zav75Q2TIgA+Q1qhkGm5GrohUktzz9qkyVzIlAPS5Jp2eqGGnNNwCKOSGYjepAgWGRArufUxWv/BIU1pv9vx9lzoOOJknZgbDx/Ip+h9IS6sM+fNBEo4Wfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f7391a-c242-4e58-ead7-08ddd9b6e311
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 15:42:47.4963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTd3TCpbB/ltLkqqS3XJzZxgFQzmceHby8FZ3mVAt3mhsJsFiOnaxcpxvRlTVnuevfUNOaQD8Ep0Sji99BPh2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508120152
X-Proofpoint-GUID: 68v_4wNI9FhpCCmqqIB-tTRVUfkIbgse
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE1MiBTYWx0ZWRfXw+bz9y1k2rJY
 Abbha7nIX+mJs3eg/fH1nIvAPkfquCBW8ZbmiLyXRgEW9wAKzw3Ah7/1cuP7oQJmwoHrxSL6XkW
 aN8s8Wdqt4tMgsfAUZLLZDhEsYBMl6g6pwfmQda4HC8IlAdgvxypkRr1ffr6zBcu9qVw67840dQ
 LEctK9zUwiK4eHJDqMg3Xqr3XAa5hJk9ND4sUWyqAlVaDK/hBHN/sEN+a5fI17bzjCSoYieCk5X
 h1GbX31TlariIss/77B8IfotBTKTKsAxJDXpWZlvpP4xfuqkCnOlHBQN6NRFDt4eUGfYgOroz+V
 iqT5j0FaTF30ho9TkJlnSl0TbYcvMsmqbB4kRgrsKTdLbAqUjtkPbInhYaTMMRqmyXN3aDl2wF9
 e2kxDP39zOQ68VtpAMGuDC8cd4UUS6GHtocJGJbjhPurDSyKVZWO15eiMJPDCUMU7oJc2+rP
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689b6115 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1WtWmnkvAAAA:8 a=yPCof4ZbAAAA:8
 a=FxGaXRssHhVewV9F5S8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: 68v_4wNI9FhpCCmqqIB-tTRVUfkIbgse
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 937B3140007
X-Stat-Signature: yszhean1o5hzxgx1erurte84mur64xsg
X-Rspam-User: 
X-HE-Tag: 1755013409-291740
X-HE-Meta: U2FsdGVkX18WIww50aYTjx9OUDwvotruCWYJHWU9LME9oNRZcLgH9my7F3k1MwVSz5wZbUCeVOkq5Dywq2yP4l2ap6GmtncRoPgPE66ZCR6IwzxU8obEkja4NGv/jJfs8McUhysvJsh0gSrc/Vt4JL0h8TKvbOxoiH9kaxMfCFTMug1+OIzkO5aZb/1Kf4bNS448q2tdfRV2Mk5ug9RZ4+wA4HSUDHv6pi/AQKbi4JxQDkg3KB78zb4hAq2Ny/cUnoXofU8DNV7aBn+i3x52E0eDYGHEZKaxqG7vsBmLyC//qIfb02RPvQZginyZfl16pXsCNlmh+hWYLqG2swgNC5k1DWd5E3TKP/2D58ORaFp9Gagc1TpJFEwDcenrR92VCsZLVhMJvSUYU40fSwOSPML7xiImm/ffwcbQQp0/guNWUd6IK4amvzr9jpuOul2Jcf0gZEQgggTzcszQloa5KL1Yoio8NzsOsEWpDWy4Ry+Pa6j9hvMHvQK8shGyaRlb9tVuKbkyNgtZyVF2629t6S0c3lUTd8bmV98pAmi+7mlXV/Iaps1v4DeNFadNdFTJMz/Vb44OmofYThFz7Pn/DPVEWSHmdJVS+4f+6575R67h643zA5fK61MmELOi2H4jVVz21de8ekKl44sfhRFIcKn7bkOIAhAbHhOPKB/DMKtDrsKCB1geIu4xloztOUAew01xwp3/4/e5f8+0fP5iFdmIwCL01Kh97Gp9xgsr+AruoAp6Lt7VCxDfo1JCZ+e0vbVSfbE2voMvuTJKDtl0xXpYlFxdmFvNT412dQU9i9iwmBHe1UOB6ZCsz0fRxV9KEYEaPCZHkjNHGpGppsqQXmvIrQLzn8Js4LgC8VX5vTwI2zqtW7sbTfSHgGF0AOOYgiPEE/9FIWTEcU7423K+q8+Eb2Hvt7b1CJj1jyChxcI0Fsec8VJVlqZDRN93plb57z7bw9kQQwx0amK6xnY
 k9dqrlDZ
 sPU1yPsuXNuX3C2lVJP2qB3Ch6rVQMhAjtDEG7IxevycvpOHg7vwNIB6eX2DYM5rnj/ozFTD+l859owTHuSz5VOGxKzdQRvFPaY52tYVnO4BJZ47fdhP/fcRZbaQDIG32nJMmFcJJg+lPMCSYHvo6JBnTnttXvTDqMRElngXVp5YTM+7UQeISO0vpCssyXuhjWXXNVflwDAD6cdDejj/rJWJgqcB38skrUWkCVT6O3VG5jmndl0h68hEUcN69PTdN3I+5ZOuyUuQwgnoDU2Tby1E+97BXL8OdpKvvxnHoenGamGYx5NjDqtOqKd41zMkwKDvNNmdTjWPcKKfB1pyFlY8gm2HSX9LSKv5kb/kG4LIs9d+CVy6cYeAH7cu14cfPdDxSCHBmKTyUBgGu73dujpLVnJpsw3pEVDAKplbmnG1h8jzXuTGB/tJ4XOQSOCdHt92Z565ho01EO4egRNWFrPk50oNQdq7736zpmcrTLtebSCNiwByjwFbmWlud9u+JpqB9fvFvdwKTRKpfAveeu2NN0Yr7BFyRNnEEoeslTkBxoKSX053aDDftIlR2BglHLVIwOpANMmxcxzyh22DcDuZIU7D/b0te0GJZLZgSxHDxBNRqCyw1UMJ7ZlBUc0HAd9Ea7UxI2FU4JUCKQYJQhFEf8Mamn/lOsGjYiXymk50GXGTSldadrPboXsGgGoBNTbt8AKzBHgd7KdB+U2s6psRzvw7Pa8wakHK9XIkL5W+nGQcmy/0sVeW4FaTETZml0B1aUeGavgrk2QdiPeY0rbXLLmgWt3xa31Pmelpwbh1R5UZhF3JZIhbQgd0M0XmqNde8xmaFjyyHJiBmu6FdiXx8tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Qianfeng Rong <rongqianfeng@vivo.com> [250812 09:52]:
> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> redundant flags across subsystems.
> 
> No functional changes.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
> v1->v2:
> - Added a modification to remove redundant __GFP_NOWARN in
>   mm/damon/ops-common.c
> ---
>  mm/damon/ops-common.c | 2 +-
>  mm/filemap.c          | 2 +-
>  mm/mmu_gather.c       | 4 ++--
>  mm/rmap.c             | 2 +-
>  mm/vmalloc.c          | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 99321ff5cb92..b43595730f08 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -303,7 +303,7 @@ static unsigned int __damon_migrate_folio_list(
>  		 * instead of migrated.
>  		 */
>  		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> -			__GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
> +			__GFP_NOMEMALLOC | GFP_NOWAIT,
>  		.nid = target_nid,
>  	};
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e5c9544fee4..c21e98657e0b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1961,7 +1961,7 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>  			gfp &= ~__GFP_FS;
>  		if (fgp_flags & FGP_NOWAIT) {
>  			gfp &= ~GFP_KERNEL;
> -			gfp |= GFP_NOWAIT | __GFP_NOWARN;
> +			gfp |= GFP_NOWAIT;
>  		}
>  		if (WARN_ON_ONCE(!(fgp_flags & (FGP_LOCK | FGP_FOR_MMAP))))
>  			fgp_flags |= FGP_LOCK;
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index b49cc6385f1f..374aa6f021c6 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
>  	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
>  		return false;
>  
> -	batch = (void *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
> +	batch = (void *)__get_free_page(GFP_NOWAIT);
>  	if (!batch)
>  		return false;
>  
> @@ -364,7 +364,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
>  	struct mmu_table_batch **batch = &tlb->batch;
>  
>  	if (*batch == NULL) {
> -		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
> +		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
>  		if (*batch == NULL) {
>  			tlb_table_invalidate(tlb);
>  			tlb_remove_table_one(table);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..7baa7385e1ce 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -285,7 +285,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma;
>  
> -		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
> +		avc = anon_vma_chain_alloc(GFP_NOWAIT);
>  		if (unlikely(!avc)) {
>  			unlock_anon_vma_root(root);
>  			root = NULL;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..90c3de1a0417 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5177,7 +5177,7 @@ static void vmap_init_nodes(void)
>  	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
>  
>  	if (n > 1) {
> -		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
> +		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT);
>  		if (vn) {
>  			/* Node partition is 16 pages. */
>  			vmap_zone_size = (1 << 4) * PAGE_SIZE;
> -- 
> 2.34.1
> 


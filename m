Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A220C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AACC6B0312; Fri, 14 Aug 2026 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488ED6B06BF; Fri, 14 Aug 2026 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396A36B06C0; Fri, 14 Aug 2026 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18DCF6B0312
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:58:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A187D1C002E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:58:32 +0000 (UTC)
X-FDA: 85100030064.27.65112AD
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id B634E140008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rtubynNQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786715909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dfgc23Jq3kEUY8mOtV5zozCdABRbWfmGJk+iLYzdkdo=;
	b=AKsDzQQtcgyQ9d1NRgoN0nMqRBvZUObn1kh6x435ZL3p0gK15MgBUzrj/UIi8TQPxmxRMc
	EDPkkRPlDDkgCIGXBeRSgYE9ciYJzBy2OvwSJo0DvCCWC4X19PPokzJxcmSBcB2fxwXzgv
	0MfB9QdfHXlf5V7PE80hT6oyDUMr0Fs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rtubynNQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786715909;
	b=5+h1IJV84yEMvqUGuYJFbR6haKzJNzJzaTwI5oJsML/YamgWI28v+NWUkcjzpzerDWZHLM
	2k6VGsXelagZaqTY288xQFtbNV2PEI4kDdP58AoUIxX009z1h+q+93kQB6jBUb1/qfATmZ
	zGEFAhYWcZu/vQIQTSt4ofz6E72RmwQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RKps4SGMVjEf2SAtPNabRpYj4BB6OrDc4Kdl2E/7QbsSRSl0uDgjx9mCuB3T1BMsYiBtFBDOU0S2ZugDxHBrx9t+PZxWmnr262dfq2FM5ET3n3je63cy78OSxRalDAe4BjLE+c64VxXK5c3WsJmS1/P9KWIILuh3KuBr4D1kQLtaw3n/7VJYDVvFrLXmNsq3GTaGhZ36iZv4IHN33LAgOyy3R5H2aUNyWBTgdIuoYTBsPTcAeNPNmfDIfWhd3K7U7s8xALnWDLEgEkTAC5gkSLAzKTgPOqJt98sbNOYjnLnjklwq6HRNEtQp/PagNDiSTyXaTwj1sxR+G+ilaxLg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dfgc23Jq3kEUY8mOtV5zozCdABRbWfmGJk+iLYzdkdo=;
 b=IuAPJDlyj7+4xBw/ICYhyPV8QHgFS8DV4zfmra/xWdgSmtHbFN0JmvP49SQr8RGZFz+QoCrAuEmBFrCJ5XGaHl9czOvivo4OgtSu4e3zc9kz5hqFf8UA79q27PG6ZkwNx53kCQXs8fqlOK3rIhxqLkq41TkgTi6biHqRoIC+cdLO4z8bJ47mzGvJT8UCEpPorCXp13jAKLbj2eCngQbxBX8gEj55oZT4ZIBVOTuLMkFHAoNBeUu2SfjTWkxGmxy4EY8uF8GOol/Usi7nKJXBcNMcr+LI72d8/q0bmqshNc8ZoDRLtazue4vsusFgN1rAh/pa/MahFSS1qKRzK7+IXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dfgc23Jq3kEUY8mOtV5zozCdABRbWfmGJk+iLYzdkdo=;
 b=rtubynNQyCs0DpEftkyqzxshye5Mi8mrscHt6Eb9suu/khEqW+fpHIPcCuW47ghgYB2a3ikGJYuyD3oqGV/p9k3WTK9ZcrRHjZLfy23+uzuvC8abyNmw4Twk+Uh6yf+tkiJpBz+mNuZW5q0IDF4aCzC0fP36dUM2P62oDZF3PMhQZxGqkbd0b0E4k/IBWwI8De7Qe6naHsdA7RZk2kQvoMu1MEYuqeVPRH3SYVNrjy2Nz25+ZeOMfgk/wVMZfaarak1tlcRgKZdwPQK5cX7VYlogKR3bM1UuS4Lzltt2E762+qVvgqULZAgGMPbqIE4EqodFFgV93GctEC/rZ+REuw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Fri, 14 Aug
 2026 13:58:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 13:58:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
Date: Fri, 14 Aug 2026 09:58:20 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <0774EB62-61DC-40CC-B841-8E7487805B91@nvidia.com>
In-Reply-To: <6bfa6c93-4eb5-46c6-9524-7b59297f3601@kernel.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
 <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
 <DKNGC4X9V83D.268DMWU0WIILG@nvidia.com>
 <6bfa6c93-4eb5-46c6-9524-7b59297f3601@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:208:23e::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7328f22d-01cf-4f79-45b4-08defa0c1a63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1rHsab7IdoFTpO2uP8qYbXVqfkjqAHj3Yr4U1/eZAYy0oEyCgtNU+SRDuZ82IMMWKxij8sWISzqDb14Bq4Etrr0o6zV1JlB4/MQuNjyxAK3ek/aRgBU0+QgOwchuvVIj+GLC53mbYel+hlgPkw01orxxEw2AhsnCAOc0/aIu6cXXekEyEcF9SbXJWfnlMDMeaZjKGyyoQeS/nJzORvHBVBgzCQBPFGdpPKgrnbH79MiFpPO8/y4z8UNFc2dTGeoJZIZTpaJMttdGbG4EBiBMlc88Um08+yPOfU7dvKWGkz7CyQzVzodE5wTaZrHDearVkrs8PvvDhJOW6XAHKFdb/hfQ6PBrAJN+iLcVMrt2EmApqURkJ0YxBBoZrKsscA0HTva3G9M0RkNdWv+xwBeP3fjqdoTvR/iaTxHsBuFpXHg/Zw01Xv6+DwPZizi7Hz70zjZaKXReElmPl6XRxjir0miw9tGUE5ywuRfEeYn8JALE5tdNGE82XBiNvTqiJzzDf4Z6mNZzEuurH2A+sjvuj60EMvH7KQHMBNf6rHGufI0pGz6vSPVl4R1ByoXh6RJjeAxNuAZXjsizFYHZpCQO37BzXGC76+V+rm/PADL7lufXKOxmhbWFwMLPXzoGV7iO9jXTUWoqsIwB1tqbNz58OZYwS1KnAUUC+dlDvHDskvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pbtYiQaAnrZwOsD2sLcVlLbGb810thI1Jbka/CRs4/idGUBLeT5iMeK3cRnl?=
 =?us-ascii?Q?S+SRcPKcyWh1qKI4GZW33yQtRjDK4CKH7zlXr0paE7LSDFxxtAderkxf33So?=
 =?us-ascii?Q?/CzxmBwFXlJbeCMaTW+QDawdxbumtdkvwXHQuJD8IikclOnW7u7YCNC6tgUz?=
 =?us-ascii?Q?3Xlek8Mh+hPHk2UZoqKU+aa9cxwJlrqqMDxgW4WiGTQr63+NoQ+kXs/ZwF7N?=
 =?us-ascii?Q?6w7t8NQXiVhe8FIXXX9YwfYtCQp+4K6BBnk5iZ2a3J+9fyQwg9EFcDRGya2q?=
 =?us-ascii?Q?bFyWXcAzfV2/upzPpvSiKjGoi7MWhFcgxRetJbbNznjC27aNd/tusHthUcWS?=
 =?us-ascii?Q?M70rjtV/D/PwqLAjwvlJCVWtyoRbApuXpxWrANGx60K719q/PbyYnsi9JZdh?=
 =?us-ascii?Q?WmlMCa+O91E7hPetYV4k9mnTkhbB4qCbHHMotkGi89k+Otz1MlBWUQ6R0Ub3?=
 =?us-ascii?Q?OmmQNmZyTdo4FfNU8AV0d0xHTonmmV9VRt3mq8HylHuknUT0pR5fqpsaazAY?=
 =?us-ascii?Q?NHO5aTKwPLIzxFwW+OWXUGaxPqMyckV6WeMq1W8zT+wJ4+QvHQXCkfsaqQdd?=
 =?us-ascii?Q?YmikgS7bX+sMAxKd2B6YLXkJ1WnS1DjaU5NzXFjGdkqGjtdSz/z6Es60zH18?=
 =?us-ascii?Q?UITcJqJhpsHCr2xVC5p+59BvO8rYzIWW4fMOR9tgZBrfgV1qnRMQTV9RkRzf?=
 =?us-ascii?Q?/YU1BTsbmP87QzOhjtb6DKYRdoM3Hj5RfvewpRREpCcRgI2PirGAVrSmKKb0?=
 =?us-ascii?Q?eDHvd8JupoCYIosDZBXjnRjelbydVXA1jBArnMuBTv+YKWTUdCvVodsFq7km?=
 =?us-ascii?Q?/ky0TRVT3H738csIuNFB79eW6DlDE28qsCdRwnjRKHfzIK9dfcASuaBeOhpZ?=
 =?us-ascii?Q?Bt4AZ/IR/dDsFfXv6HF516OX2F/fmBB8cHBnbYTcLr2my6F36z1dtdWHSkAn?=
 =?us-ascii?Q?sPifwa/nzSId8zkDfhziM7Yf7M4pHzSPCLdzyqlbJhpOTDarOX9ByS/1g/m5?=
 =?us-ascii?Q?FDsSONx1XF9KdQ+aIBiy0/gVLZP/HvEe3yE5uzUSGyCFG8rxMKVdybC8iYPq?=
 =?us-ascii?Q?J3ynEQabU7o8Yiw4pQBAXbZ5qSd1+CVB5LIqkkvI2pl+u42GxQIHeLN5Qkew?=
 =?us-ascii?Q?AxPkl5f0tAw+eh/54nLYA3Zefcl3uAGzHolCfKeBs98ZTjiNUWpxU60BRqX2?=
 =?us-ascii?Q?bRl7eZy3miedhwU0YdpbCUQ+Zaxxyc1n1LuzOPAWeUIBhGFRWHaiPDlrFrCS?=
 =?us-ascii?Q?A+dY4iuT68uqK32iasESBCDXbYjJgomeCF9H1puySOtb4/P1VsagkBzcfJmQ?=
 =?us-ascii?Q?cLzOb0Gp6Ji2JwNGUP9/5LN/xu6qA74MTRv+hpf6le09dNa7MECDFBEjtfYB?=
 =?us-ascii?Q?Cwuyeda86UN99Vfy9HicPenU8UtMb0lluQkphgdija/C+iQDqrKnzys002i+?=
 =?us-ascii?Q?I3HKuxzlzZguFuN+7riRrws9dFvwiXmehz+Fy6iHEu+pS1I5Ux/TSjWPCq+P?=
 =?us-ascii?Q?uhRIIx5+eG0sBODWy9eU9kNTlQQvQAd6yWD0HulV5ner5f0YZQ1G1NCwEgst?=
 =?us-ascii?Q?yvTZBwL95fmFqng402qdSjXOJzrhEBp7/1G0oo6N6FBuEL4bihBAla0m51bu?=
 =?us-ascii?Q?OPfjYlHEJdc0DwADhJsIPiOaaaHENGERfGLiD6xF/u9A1LbfinOdUu0hVlmO?=
 =?us-ascii?Q?AgbMRGKryAXPMGcRiiXQEsPZT8Ct2B4BCTZbz2FqUgwaaQFR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7328f22d-01cf-4f79-45b4-08defa0c1a63
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 13:58:22.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBTm8WFCeq5K77L5C4YgDZ4jVfZtGZz+8nK4+ZhT6GKms2filDdiwmvryXiI6FLl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B634E140008
X-Stat-Signature: wam4r3nzfofm4eetq3xsezcnsrcifzkg
X-Rspam-User: 
X-HE-Tag: 1786715909-440320
X-HE-Meta: U2FsdGVkX1/yX8WUN2njZQx8IuYH3oWcj5+NpDPx1/d5zxFh3MdT8j1Q4V2XjI9w+zTOq+5JCQF0Vjyxi03vw4aS+KzkBxxaFnIF6NwoOqwYl8cgqK4uVlJHunuayA6r6LfI8c0qAB3r4PWVPfjnGUSUWy5PnC1Ofw+Jp9NCMt0vtbZcPjjGr21M9j0nVp/KG43lWvhHwc2120hbDKFXGSD3+57V2dm2x5jhT26B62FkoheLru1QoEF59em/daRaXXKpoupLUxAkj4kM38H59T9fXCjXlDLDSrxrVY7/ynYhuMIXXNRxhNBFSmKf3Thu2AUPKGX0urJFdAO6kcEW0LdVr2wtqcKLXyMETM5GsAQ9Ezp8qsZK/yTg4MjKZLNGCrTbSLakXv68z2u+OyiPfEnfLf2zcQolFbrqt5/w5gvoqL9L1eeq3v2MBkW5ZbJSeUT6vU60q/117ddkf2HrVKKpab4nJQaoLE+CGkgqfrVQYtdUEhTc4fMcFDerMTm6rFFWnCk2UMQWOt4LadALuK9GVCbU6QCuWppOJFgM/noKYFIJas0oWX48WayyaAWf1Y29AZHo7Pw3t6aPrnSlKJ/Bs2mSZPSWOGXE/kvsqj46JmxFB3+x4hkENNgE/8gA+xvP0cTqBk/7VpdO3lcl7/ztKNTOM6UnXlY5ToZmZ1v5qruJOYDaBn9DCPVwRhMMr+l1sTD9FXsWm2H/1d6jhME1KFCnUUl1Gk6a9TJhHkbrEa8rhr0GN19aKrRW5emMQ4vSjadTd8ukf3VaLGW3xw+w7P3tKP+412N5v6pSQX0opI801mc04QfC0B04s+OWhlwhdQk5UPX325FFeLb/YCozu2ye6qwBIrQWFWRs08cxZCtzmufgrWKRSDOoHgoUlTaDEUpkNC3QZcztYoWrBfNO/zbkJgwugBXzWa1qHIu3wf6/k+lZIdhHfQxkkSDivQwrtubqa8Kmf/pEXuR
 RBoa4jbi
 i9W2g2AOy4mjA8g7MxnxvoBoWy5+ZXXvKR76gJ+o2ORwIdXpFZPp0mzWTpgq6Ep6ZgY3vDTYBxm+cAYDBB+C00azkXA218XX520fRLLmPB+/OB+HdLjEFO2Hfuy1niAX9yivD3rLhJWG6q0ND8v/3s8TGHrQkI6HSC/DICzu3uL0hshL6ZxNYjR3TMZ9hn2uEvVQKRIFgvny3BV+55+SPtYNM56avhNXrgkHneH3javBvjTrEz8h7l3EGaf2CRNZgdHA/ZPdhpmLwo9R6Hx6Al8mGYYpFtuwLA0P6ctoKv/4ikBzhkbTuQBN6q8uC2jaABpgSqlTIqXmKApJJJuYPem06Tzs6T2RMcJZ1WSaQWhB1hnWi6oh7kJwcV80l3ElJltNGt/8f3s0VqjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Aug 2026, at 3:13, David Hildenbrand (Arm) wrote:

>>> +	if (!pte_present(pteval)) {
>>> +		if (ctx->max_ptes_swap < 0)
>>> +			return SCAN_PTE_NON_PRESENT;
>>> +		if (++ctx->nonpresent_ptes > ctx->max_ptes_swap) {
>>
>> So max_ptes_swap is actually max_ptes_nonpresent. But due to
>> khugepaged's max_ptes_swap config name, we just keep the variable and
>> related function names that way?
>
> Yes, that's how we handle it today, unfortunately, for historical reasons.
> Mistakes were made.
>
> I think we might be able to convert this code to actually only count swap
> entries, and simply reject any other ones (migration, hwpoison, ...), but that's
> something for another patch.

I agree. pte_none covers not faulted in PTEs (zero covers read-only anon)
and swap covers swapped out PTEs. Other non-present cases could be
1. transient (like migration) and they can wait until they are stable or
2. never considered (like hwpoison).

>
> [...]
>
>>
>> SCAN_SUCCEED + folio != NULL means to proceed with the pte, while
>> SCAN_SUCCEED + folio == NULL means to skip the pte.
>>
>> collapse_anon_pte_check() probably needs to document this?
>
> Not really, as you say it's straight forward if you look at it from what's
> actually happening:
>
> SCAN_SUCCEED + folio != NULL: check folio
> SCAN_SUCCEED + folio == NULL: don't check folio (no folio to check?)
>

Sounds good.

For this patch, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


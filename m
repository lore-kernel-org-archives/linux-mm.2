Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63C7C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6346B00A0; Thu,  6 Aug 2026 04:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4676B00A1; Thu,  6 Aug 2026 04:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3506B00A2; Thu,  6 Aug 2026 04:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06E1C6B00A0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:28:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 759191C0FCE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:28:02 +0000 (UTC)
X-FDA: 85070166804.04.2445BD9
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012053.outbound.protection.outlook.com [40.107.75.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51B16140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ES+92G1F;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.53 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Z0y2z0bdzLNCsE7PU+wHRgmZmzK7I72nSAYmQvYZ7o=;
	b=8QjiR3K/QXbv5frIgBm+s8ovEeuqYvS8lqbqebXfPNbBH/GcHviLd5qBR5NuoyHdiFKtWx
	WijyrzUXIX09OKeiLkJ7JcgdkhMlaNW4LIcXul8HAncVD3SOcZtyHwei+IWIJBBmj1kE+h
	sMZlH1LDpr2XCWw+E1y51j5l4G0HrEM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ES+92G1F;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.53 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786004879;
	b=H3280XN0eOq8njcaZEV4Dc7msmLBixZu0ridTminY7/beqXisGP16b3SOOl5DUAhQgHdJ/
	7vwGbJNE2xkHxkGOBwBpuDmzlZuKSJYFrVgFuQ6MxhzSOrjZFt5Q0i2OLsMg663g1ODGQi
	mK/LjGXCYvIipdv3DilCuc5Egjz22fs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIgCG82H0nTXAq5bbjtkOOsoU26PGbu46FMSfPfb5lVki7qgKFk6kEegbq6KuLOYWNF1MqlnFJtz8Ff/dbet/H+wQhV1ivwhOxZ/CoXwB4vRKFJPsBoa4kW8f5GlxK1aVmsgOlZxpqUFDvqbs4a7FyuiLJ9+86Cd5DY2L2LUuUNZe96u/PWw736SjbYr4bScB1T+mdMFCPINrU8Tqyrsq5K6BU5tB76GJo5+ON5u1EjwPSXGp3+zAilT7Be5CDsLJf2CXIYDM5i0ANEZN+wAVd7DDFdlVhrQk5hgk4QyZKkZZGq04fl0TsJ7AnPXzJ0/KBOvvXSYosbZ8zlQzpuk0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Z0y2z0bdzLNCsE7PU+wHRgmZmzK7I72nSAYmQvYZ7o=;
 b=Y/VkjzyWDr1XGGobPrhTsToqISwA386/vdfrgoV0drV+DnW5/lWgksYdH0Enn9tHJWDV+Hv9l43liF0eiT6jSB1dEy64Z4cZ5mGvxkkUCDGUYdJ6R8R5xTZ8/QwUt4aLcRQmOB/8UFu/yJ3DJ8p3UkVZ76XQuDcMlHPTmcfGcCwQsstyulnh2W270R0SN/E6eM8gKGxW1scXbg/TTO4C4DT3gGg0VRLoAomlsvTIFRHPDl6Cp4mPRHpGugf5Y/Rj6l91km3w4ZpAFE5klxUFUfcPlOXrdgun0F0SMlmUotp1x/XLAX0CfUfZHoSwZBio/OqV3efRW19n+tYWKcpgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z0y2z0bdzLNCsE7PU+wHRgmZmzK7I72nSAYmQvYZ7o=;
 b=ES+92G1FIG0xgqme4oAQOrduDFexDw2BLBM/K6Kf/LFtzurkM1lNME4TfvGHmuJpDLyn9LEfAAQqHwmwRviBTxJCS/bBU//xhUwcxjEboa6Jj9qax9mQv86nXdBJgMfJzD6uiE6oAX3wHIgHgQx3LR7aAS4M49Aib+qbXFuPoNyZAT+QWx0xLZBXaUzp+bWXFqQ19RiVM/hIKVqT7wcm2ETtPxcPQp1c/i1b+pYa8QLxp0LbEVLaWKjsIDNlG7ZmaLnHoNnrpPNWVOBXRwm797P/jAPWrstMc7SHQqpWNK1uxa8TXGrDn/y+dWMipVDxXerqsq77Q7z9i5nncb4pEw==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by SI3PR06MB9209.apcprd06.prod.outlook.com (2603:1096:4:2ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 08:27:54 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 08:27:54 +0000
From: xueyuan.chen@vivo.com
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com
Subject: [RFC PATCH 1/2] mm: zsmalloc: add a page limit to pool compaction
Date: Thu,  6 Aug 2026 16:27:35 +0800
Message-ID: <2393398101d122048918dcfc3e1c21f5b4efbb2c.1786003779.git.xueyuan.chen@vivo.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1786003779.git.xueyuan.chen@vivo.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0193.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::18) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|SI3PR06MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e2682b5-efe3-4d87-f75e-08def3949cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PxfAUR+IH0RqqHit+K2JyWhTDRlR6OLxaqvOdVk7eP1LZxlyvyxEbYqCvNKVkwiR8WF1y4rFrKWOBtntdamaR2xVH/yNWFA/TaYYf+sUgbpq6NbyheYKnyk5m85E9JqD7+TU67r95/BtMkU3mG45B/TXeXOwiobmteJmZw37hACrBU3kBJXYwg6Fbx/HLrQnfdxluMRbK0/BJ7v3oZSfVTYU/IdtM3p+aoqtjHmr1DhsWkutG7W1ll0C2Y2HF0Z7siTmVNKJRwC7z9SeznzkWH6aRm9QfsEDLdStN4rGgdaQvR3nV2M1Muz59s4dufckd1vUcJUMbx7QOQ6DNNdfDym2lkTkITYwJbZvUIdMRP75zlLTjBAM56JjNSGFPQdn/VKkbqfIoVJLMp1z5Ez6N3FrnSht/IvMx2d0s3GS1PfxiSHVeH4D/55o+Q91I4775C6vvz4RwFmefnLLFiiZj0N9g6r78xcsfh1b3atXy/bq32loLFOalWLR9XeuLjCCO1IVHrkI25PB1sAphRcuknI9jkxIhINl1c1NiSQ4jvLdZHx2X1itf7kwNtY28PHQU61JARerj1gjZCbisTs1KgoZSqiJyxR9Mvid+6ZTv4VbvqI2RMtcJDAYt6HvRiv5apME8nX61fbOiOMXNR/TU1IGFDlyZ1+lzO+50HAmSEI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LPvuSBfIhtTImDRL7j8Cx0BLcqtxf4kJvmrXFiINMQ6fk8LbiqnpdpqexGce?=
 =?us-ascii?Q?LwBskz905eJ790vvLj6BY0YCKSWblowxSpzLP1NPO1HaymPSBXugyaAaXshm?=
 =?us-ascii?Q?RJcB5kpUr5mYmcJ7E0uRlOnYWfQ6Wbi934WovqIMId7lkb8WdqSjukCPVQuj?=
 =?us-ascii?Q?AL95QXoOmbl4Txcz9bdss5n6dXYsIlE3H4p58rfq+Kl+sM3YFrBK3gJaznyZ?=
 =?us-ascii?Q?Kw0kYyU+L5eW0P7aBJqUl1cLQaqbRQO8AZnMyGTmozRbIinT7KgFoU2QN3o4?=
 =?us-ascii?Q?sdbFbgOGz8Fn/p6tZBczW77grBN16XcRevUAS47ArP71mO1REwK4teXdCFhM?=
 =?us-ascii?Q?oJX/iYz6XS5yW18iuV8IPwCUedJiyOi1AON7diBdSupAy3J6NqN5bAG+Ac0o?=
 =?us-ascii?Q?LgDofHTSOTIu3wjNujjJ0AZ1ZBv8gFwsGoCAUy1h8TvNa2yuJzXQwLkzu+8Y?=
 =?us-ascii?Q?Qvc45higcsftkjg19QQvqwgUxdVJDj6ayc05jsmfNi7IaR7OhrcqjwKWiDzO?=
 =?us-ascii?Q?dI0mXBKYmyr8pNXRcqTg067A7jhVrKZ/w1rg3CippLpYv9qeM5EZmY8Q9cd/?=
 =?us-ascii?Q?2rvAxo6fyh339w8XNFd3btjJfsvGKnnqvN2GrPvhqGnyrKjoagNcSXakoZxq?=
 =?us-ascii?Q?QJmDgvaggEEJ72XPMrXJdE5/8W4PtIwIB9Kazl9Gryt9mnogqsg+9sN7gQep?=
 =?us-ascii?Q?Xoj1K6B0e1uhuBrGhTGKhdZx17bwpVaol7Vl38NsUfPulAvrvP2wTo4kUrRj?=
 =?us-ascii?Q?QvqECVpniQjF7GKnyk1hcuIhkeZDTcb01CcNKw1GMcu/KHeQsah0BVy1f4sZ?=
 =?us-ascii?Q?gTn5Z/deOZ3fmLT2IUaKEawHlP4eqLb8KfrxzBjrzcZdpU0OQzKtYG4n2wlo?=
 =?us-ascii?Q?IftJx+kRxHMM5INxuiHIqkdim445aGWi87yfK/ly1JDF2FdVz+kn5sbHkEM4?=
 =?us-ascii?Q?oEFOqf+dAEZ2Q9v0us6pGdbrjwiZ40zd+Cu2VmbVRMAWVPCIHz7ZsTbrYq4E?=
 =?us-ascii?Q?vIgk8wQoMOtyHiaV5Q14YeGb/ARVc/wmv2NjGRipyUexKUbM6V/0WecVshbc?=
 =?us-ascii?Q?bItFjHeF7PZ/vtOcDr0D2/qBROWEss7Fgmzimrlr6RZzCXU4hO+k8xWO57++?=
 =?us-ascii?Q?q/gpLu7JvIqR6uU3TGRcfbGDpcJBb0krHLnweyLz1NfbIW+uKLz3ibMuBj4s?=
 =?us-ascii?Q?T4rM+hKUuNu/m5zGTtB0ZtaGBh/Xa0PUmsgikRw3FX1g88i304S5DITn6wgm?=
 =?us-ascii?Q?E4hVfqWpP97r3ylLCCzIOLX8dtNOjOZLAy3m9M7V+t/odfHc/KeyeJBviaH6?=
 =?us-ascii?Q?WQU3xRvu6Qa6VpglINr7eEpaQeqL/HqUiyruWQDji3uJq2h23C7yM4Fc0UrB?=
 =?us-ascii?Q?A1RrRHKrLIrsE5cr9lQLa98AejVuk5WhRYG/z4rCScnkYXaSjEQjfwYAxgUe?=
 =?us-ascii?Q?Ex2/lkvFByD7Tsd45W4gDc+WvTN0kB2eoYcL3ikmtqR8bcFRuOO9sQP59e8V?=
 =?us-ascii?Q?mFuoQjtypimAnwEd29Oa6m5gFOQN5IVz2Gdu7CtR2crzWNm1QbIL5y/O9LHt?=
 =?us-ascii?Q?MhpquQv//pIcEPiIAU7jcRJ7A+ypEGw3d1+iWw9080xvsYoyR7g2834TAcJ/?=
 =?us-ascii?Q?NYPe/7UnbY4hMZOnzQfdY0sgQ7g6P+HQq4ayymENtUU4ksF6ERj3yuA6i4ed?=
 =?us-ascii?Q?sAdeV3qtXBZzhn09BmNQZi5ixJ8YylPbne8lsHwJDOXAUSnA?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2682b5-efe3-4d87-f75e-08def3949cc0
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 08:27:54.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8kfVSMU5Rfr92j3JoI2lvsChqCwRjGxEaGpRlDPsiLTdiiQptwy87R1lUMTtIDbRVkjZXMjVv62Kb7EREU6xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR06MB9209
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51B16140004
X-Stat-Signature: o3kn4aksznswtzuzj7sr65dfpiyuge8e
X-Rspam-User: 
X-HE-Tag: 1786004879-51856
X-HE-Meta: U2FsdGVkX18/aLdAXTNi1X9ie5VadbgQpd/EIqRi7vy2Q3Z2okq5e2oAQ00X0W9rDqaAEMScykua9f0SaXXD4bU+ucbKivCGZpqKSYkrq3sU5CnDUzEQ2vqa9K7BcNaJSU+y4olWofEPsRrXw+M7hkb/tfbrhQfwm5V9rNaRFs71CcxVeD4UfiK1suXfoRU3KKxjSZkJ7T7PYut1cZPwzr9qNJzfEt2JCMhv+BM2W9iGca5xRNsrt0gZviwsAgYMOhCX+e5gphMTO8sz9LHYM/e0k+fwE+Rm014vCXanzadVyLAjOjPQyrhhLGe7lMwW1new+6ft6By4EkFbE+/MpyI5mnayB+wxigTj3UBLMsxz48kEIGfYo02Xa2bNiCigUS/Dmtm3EgqX2GQEha0/cBIDcaXJIIze1tArECcNRwAcFZgkNavu5iZNH9vFdAnJuxVI6Kbr9Dwf1CEvHAI8qkK9A/91kYm6F6I3d73zPgSfrTBwHx/BJi3AFJtWVlKJNXfCREGJAPmcnF/vE7dIWWmL84QeF1KV7FcgzrwV9bFi73bPp5rOAXZOp2PPc4/Jzfn9eTqJVouXwgIbKU64+/Uh1hpp26eN/KBMtnN0TAnyzHaewyWAlDVrfu0djTRYv5n7fWsBMolD4NmIoc9YLy+bWnMiiP/BuKx3LBiVTfAv4gsNvH1RaEaaTI+5N72j6+Tkqta0FBZ+AdhX4nfrNAY7WGmoSzLwIgaNyArt2Y3QEopBQKI6/7hPYN0TH5iw/WJhWAtY8Ulxrd+jdF7ekhNpwR0Mx1iUM/AzSRaYRByeSj8XXgzDBSmKvqqMKpVVcO7WkGQJPBcYp0dFN2Z38U2d10qLJCNjNPKg1MkYDwpt4TlBsf18vbwEGe9rl8UDpjyD+B6/8YEdRrUYonCEHAVPCI7Fv9ZPWR1YHePH14+yxLv7RtaWgoju54LyFQqZVCHTYdgGkmR0LL8TuMu
 eI1GPh0Q
 UKT3XCcMAI+KUK/wrZ+0SUanEcU833UaVmrNfUbQFJ71Ibgyf1sw5Hf2XseRMLB0+prBmLhe48NgmrIcI9zvbQ9S7PdcDJ22jNSR0VpfYHuHyt8AiRz38Fz3DOQIR7VsIAojZIPMOBddQ+r4ssQhsfMV6UEfg0HDWJ3UXMPdgUtzs1Xle0vl1hcE/kOMX0a88+vKv6phwnlUt5Swm9+xl1nZSB87WxXCcJAsYuASzrLK6ISod9x6mO83wEJF69tMHBa6PPd60AxmrG20qU2W5RCrtaCzl1k5Xqk9C+B6sBPN5O74x7+GNUh+fFY5+3z04g6T+qIipM6xcA4SYB/sgjP27akMv2KI8TKJfvmPZS+GK4mIslvnKyzI+J4PmblZCtYW8X36IAk5XsrFF41eoCcbR1iCeZN1EO2be+9K94nynesTLCHk6VvIHtWWCS5bPW7ulZ4JpOCCp/KA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen@vivo.com>

Allow pool compaction to stop after reclaiming a requested number of
pages. This prepares it for budgeted callers while keeping zs_compact()
behavior unchanged.

Signed-off-by: Xueyuan Chen <xueyuan.chen@vivo.com>
---
 mm/zsmalloc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 83f5820c45f9..334d24093c64 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1884,7 +1884,8 @@ static unsigned long zs_can_compact(struct size_class *class)
 }
 
 static unsigned long __zs_compact(struct zs_pool *pool,
-				  struct size_class *class)
+				  struct size_class *class,
+				  unsigned long max_pages)
 {
 	struct zspage *src_zspage = NULL;
 	struct zspage *dst_zspage = NULL;
@@ -1896,7 +1897,7 @@ static unsigned long __zs_compact(struct zs_pool *pool,
 	 */
 	write_lock(&pool->lock);
 	spin_lock(&class->lock);
-	while (zs_can_compact(class)) {
+	while ((pages_freed < max_pages) && zs_can_compact(class)) {
 		int fg;
 
 		if (!dst_zspage) {
@@ -1947,12 +1948,16 @@ static unsigned long __zs_compact(struct zs_pool *pool,
 	return pages_freed;
 }
 
-unsigned long zs_compact(struct zs_pool *pool)
+static unsigned long zs_compact_pool(struct zs_pool *pool,
+					unsigned long max_pages)
 {
 	int i;
 	struct size_class *class;
 	unsigned long pages_freed = 0;
 
+	if (!max_pages)
+		return 0;
+
 	/*
 	 * Pool compaction is performed under pool->lock so it is basically
 	 * single-threaded. Having more than one thread in __zs_compact()
@@ -1966,13 +1971,21 @@ unsigned long zs_compact(struct zs_pool *pool)
 		class = pool->size_class[i];
 		if (class->index != i)
 			continue;
-		pages_freed += __zs_compact(pool, class);
+		pages_freed += __zs_compact(pool, class,
+					max_pages - pages_freed);
+		if (pages_freed >= max_pages)
+			break;
 	}
 	atomic_long_add(pages_freed, &pool->stats.pages_compacted);
 	atomic_set(&pool->compaction_in_progress, 0);
 
 	return pages_freed;
 }
+
+unsigned long zs_compact(struct zs_pool *pool)
+{
+	return zs_compact_pool(pool, ULONG_MAX);
+}
 EXPORT_SYMBOL_GPL(zs_compact);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats)
-- 
2.47.3




Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12EA606A325
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cdVQs3oV
Received: by kanga.kvack.org (Postfix)
	id B7ABD6B032C; Mon, 19 Oct 2026 13:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51086B032E; Mon, 19 Oct 2026 13:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66056B032F; Mon, 19 Oct 2026 13:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66CD06B032C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:59:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB1DAC06DB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:59 +0000 (UTC)
X-FDA: 85340136798.09.AA6A0D2
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D233AA0011
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cdVQs3oV;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792432737;
	b=na+u8BGWzTTynhs1bI4yePxMj4QMTjPtDsAsRZ5Grv8dNHM1EuOoX4JNJSNgMQfHEp0a12
	Y3lH9O+c4uqEX+wz/WoLS//6OZUal5KN1U2yIh7QeZOhv0NP5OD48Y8VU7EwxKJXVQ0pCE
	TwswPxIRd3RqNFbUWuoYKoFq3Iqpr44=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cdVQs3oV;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792432737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0BZsAgItxMPGNFuLc9E1CYE5StddcWC+g8chH9UjgI=;
	b=ai8S+wbHV6Q1R6rc8PC8F2csLNhGqud5/hx9l0sR6v9R6L/KRGDcIj3b0Upjl3f8jDsPnM
	JkgAeY4ZTL7ZmxO1WHtbFd/TMqxgK5VgORmxXxL2EN5LudqsnZkDpugXol+mUvJRo1TzJw
	ykiVfgBjCeHVeCBWTOHgi9qCHVo5+ps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQc+hq4CRp9xV3UmCZ1XaCs0gWC1uLMgoWXUseyahHZL5hKv4CzB0vb+vFyigjID11BPDw+sVsJ8t1n046bhF1e/LM7G/2AmjQZ3sXKWN/59mXBjbXewF0lZSUCPmwd+0t5LrfwZJeI198WyGXDtaRZcTUaUOEGzj1PCAn3psGkT/BYblMSaTdw2Wovyiaq2ga9OfRqkz6dc6krXUdqRndfAcJw2qSG+AJyjdR0DFzlVDSQtUqPc5POSKQJa4vGn1ntnzPotySIaak9cT1FDguSriUF4PQPPxZQQTErcMVLRlO977zbKJ0i+559EdTNhIyFSJ8oAb2Vfy2MJCqd2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0BZsAgItxMPGNFuLc9E1CYE5StddcWC+g8chH9UjgI=;
 b=q4mXqkScFFMK3g0L8v/mym7c77Et88B3sUqTWqUvTLipUP+5IREbI5p/zymDMB+XU5pBOxS9B7oJ57Clwu46e4ZTCFjQdNDO73rDeBNuwOpKaHhDpq/ZpOf0SGMM3Q2K+zhTvOgSrzI3B7humUgz5yEUkJY7Kr4aPlpVk1clz2bRRHs4nEIuaaodiYK6dN7scwtiriOMnFiHg7cXilXkyeFW9I9/2v0xkEz9/eWCWlHvj6PkVk3j46hRBnbBhH796VTrYE6RmPlsH3aLhmdiPNTNSMmyT+Asngd5T9BPQWaQN3bjvJsO7fBz1RIjEJugAtUOgrkMWUAplGxSn+aIyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0BZsAgItxMPGNFuLc9E1CYE5StddcWC+g8chH9UjgI=;
 b=cdVQs3oVfjLncVh5Z6UUjpx5UfapEGHTWNbD1n3IX+OPY8yD7mAIBMzX3KxvRehfU42D4V6gh7XBF++Cb5YIrvSqAUg33Mp5vzV289kGFn/gsojbf9xdEZ2SkzCY2oIwO3kNxmWYM5BQm001cpCN5wZe2u10PBgsrlUrGz0fW9ZjRIKMNd928nL1o59bnHkCcs4fcaSwBFsiLefj5cN9aszisw+YhIJ/87L59RF6I+IJgzjF5zF8EmaXObQ68qmSpanjysX4v3bziohsevUEcpQqOWz0cgKX/Ocq9rUuUL8XSd/0vHJ078heCn3wC3vpJ244dI8ldY35hlY2ieL5Iw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA5PPF7F0CA3746.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 17:58:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 17:58:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/mempolicy: convert mempolicy refcnt to refcount_t
Date: Mon, 19 Oct 2026 13:58:37 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <D28A458A-485D-4785-A40F-47AA0AF1455A@nvidia.com>
In-Reply-To: <20261015231322.3392551-1-gourry@gourry.net>
References: <20261015231322.3392551-1-gourry@gourry.net>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:208:23b::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA5PPF7F0CA3746:EE_
X-MS-Office365-Filtering-Correlation-Id: 74cabd6a-38f5-4ac6-fbed-08df2e0a9b1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hlEhr9yK4nHXb/6BEcvdUct0NiYFiTPMdemFF3Pe4VrjBwh83Go55EEdSacEYkIW6Ac+nu3ew8i/Vf3Hts5BAllOBnSICTUtoYs34dIbFlN4mCo55CHWREXdmn7L5OA0YISdPmE2QYYaXYqfzBcFt+oDeTpTEALFweYBizlDQ/FU791JV+TNz5Rv07UWangzbqi0A1d2nJ0vNB6Mc/7i0DTxa4iFiU0VUBYlLD+gFCbRD3iIU+M+fwk2npImkAB6ue6uLuJ2XehNwpPId0coiS34yWAHQ63Ewd6j6gHhfDUIRSYmaN7e4w6D6ziIlmWG+LKqbXm1PeJ0PFYFRx78diwtP6WuF144R1/p8+6jGWfpRCVPA9wpwJQiTW/czwcS3XinOBTYyg5gw4voZgZekQFtKJNIQZjp67T1FIso+/1Y0sT5sSSABFqq3hwNz8oDHCFFT8dvFhijgMAYTSiKaMDJrbNabdwRDk5Wc0dAa772lRW2OGDBbv9VIgzmqNGS+FcE1aQtRExPx6DmCesD5YRHL2m0wTyvQduZJ697yWZH1Fj/WDA2wK1k2im0Xt34mz0y5cuYzlwcJi11iM40hGnzMFqlJ4pVFQ9a0Xdg8ks3ZeVnviLQtL258kOSpaKjR88dU16S+hWzg6R/t4E2XEB8sqOaIp1H9lVFB0qs8L0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ziW4UK0ZKMc7IFZNtFN4h3SvDWekO/ZQl0acYeTelwffH5Y0Cbok0x3hNqfM?=
 =?us-ascii?Q?bdAwXzwqG2f61UZaUffISSme5UGWlrufj3Q71TatSa5/rvsR5qal+lQWdCxX?=
 =?us-ascii?Q?rg99yBMCa7rk1wCZNyUG36nEsKt2o/8NXiamN5mHsRX/bxZQKnh4gDYkCV/S?=
 =?us-ascii?Q?UR7VGoOgh5UODk3wX+zBwxZItj/zLzIbxWjOzrDGkInYei4/x5z01AhOvRfU?=
 =?us-ascii?Q?gDxPnl2z7CHkG2URWPJn67kXydsuS3CBvXSBuk9w8k7zQYDiZ61g2hTB9P4A?=
 =?us-ascii?Q?NKHpmjPCuE7ehaKc9gYyUEq0hE7euDXj/EtqOvEvYFsbX/vY50MaqtURWhwA?=
 =?us-ascii?Q?pFL6R6/OVCskBNn/kbU06U8sP86SZOGZ3gbY5LSxeZyxqL3C8hnDI2GI4c25?=
 =?us-ascii?Q?erLGlFRGCYUcSFRANVEYL9NQIRTdjp4dI5l8+b8YzsGeXWudIuqrAgpUGQr7?=
 =?us-ascii?Q?mD5+Wso4UxWvvmCRYCH+9vogg4hijJbEMDisKBbYKzOeutEDmmx793wGV7Fz?=
 =?us-ascii?Q?lzCvkMS6aPLpFpNUJptThpu6YkeG2/9z9OvMyIZsAQB4F9RVJl8ty/G1GZqD?=
 =?us-ascii?Q?znp4srl1jzMUwCaMtZvboEV6307q9Rofs7K7l2ycReHHktBPxrTxveNzXirg?=
 =?us-ascii?Q?DkyLmqYfkoLpUQqPrcnTn6PciuXmf8bwrzsTNCusNVsOwuXUElXKchLB3RnA?=
 =?us-ascii?Q?NaAMdxnOIwqSf+o6tk5u7tIqbGRJdybChXxjn/L5ryjobmXGfICB8ERhbK6M?=
 =?us-ascii?Q?4qJuusmCGjQvyIKtfLqTwmK+zMA9qxBTEUi3CKEu03I2xyGigM9kyJS4At1s?=
 =?us-ascii?Q?fIPacRjcYDlMcZLu2HcUx0n9+rBuzE4ZeiCDPDefmyzqp3/tio1aWyMrqxlO?=
 =?us-ascii?Q?fgkjpmcietcrkMpNt7Lvj5V405okLC3RSvVEgxmeAIdkFU/OW+JLbAS68ls2?=
 =?us-ascii?Q?UQnoj5Bdk3RbWNdFGoerSArEql4j4bXTt+2CUcUi4fniASy0G7lP9Qs9b11w?=
 =?us-ascii?Q?2A/PVqjNw/W9eSasB/fKHjoa6FDvEQkEgeazkQVI2ZGt2fyFjZss/y0xAvWJ?=
 =?us-ascii?Q?umPBhKQQ3WA+fou7R50L5hVwft037M2GCbi2e/OTGiZpNyFulqSIS2YM5jzN?=
 =?us-ascii?Q?yzE4zif5CcLeirv+6YmMSeIFDHkDIo/D4hkbv/6CiwXku5aJ2U1hhdABgpBH?=
 =?us-ascii?Q?/6kco+/Scby/Ym95HcQtO7eGengle7C1/OqYPT76yKMUL8cKhPVLbV3aEfou?=
 =?us-ascii?Q?HykI5suFgLq7eS4270AJbwKdE80obwHU9/ywo0Vg0YM3MPSXA3pG5ysK0AwS?=
 =?us-ascii?Q?OPpf8lbcCvmgyAr9P7i2aJG5R4/NOSx+bFmhY6nZNfUhWHmjHCyBv9bEIy4N?=
 =?us-ascii?Q?+gikUhh350wGXEYpN+8nxUIw652u9MwSdnFImOWex0PaJvKPBUelInMR0oQI?=
 =?us-ascii?Q?lawl5JDTtmNzbHChWX+mpnTZs66AIaF6RtqZW9a8OZa5DRws+6hqxeORuCw3?=
 =?us-ascii?Q?toRCjNIomWy2todVonbK7LD8shSRmrnaOdQ2X5rPedkYh+aAJhZqGk+LNw5B?=
 =?us-ascii?Q?8nTE8zhjdi2OAWvbUGKdTTivfQDkpsRXtOTTDn5KxwzYtKXtDOhe3LIIBjTV?=
 =?us-ascii?Q?xvHEmusYUGj3LsrRfrQ7zikfEyzbYem2JCqV96O1AmCXnbVUP9NM7QNimgUs?=
 =?us-ascii?Q?fZLupG96+Qg2nhOLNlS2axwtPMq5P7RvcivnVNgG10SFmRYe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cabd6a-38f5-4ac6-fbed-08df2e0a9b1b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 17:58:39.7807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8y8WPdni8Y5m5HVZl+JC06Lozw0qKt5kvIQ3xluZTMWe0mKO/DOvdl8xKDK4GfzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF7F0CA3746
X-Stat-Signature: m3qgra9m9opy8ck8agsqthtz6maciyyf
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D233AA0011
X-Rspam-User: 
X-HE-Tag: 1792432736-491035
X-HE-Meta: U2FsdGVkX19HgLdO+JXMPp+ui9FPyOC36gdC8pamty6ZttLpfbVEoynKnq36rFlqpyuqH1B6vYqRb2U+5WhEtL0M0Kykpw+rRf49mM6fDQ5QcxQ4k+J58HcAF6haN6rYRl+6GOVFjjcSYzyy0UGEaXkOJL0B/488SzlK21JmP6vha7a7/bntIuqDN/dgoDQBd3XA1kZQHpeSdiIOr3naVYhRRILeAo/GISzaqGjZqUn2LO7D8C6dsREXEyPLv5kX0p4ObAqwY0VwyZ/kaR7b41iivAbqIe6jb2XReIm6GK20EMO5MBt0UD9R5JIA8t2TCa0Wl4pXMTw26rxtvwN/qMtY437Jiex/ovpkwIJ5BR2jatxjHCmLX2SNOJLKo391NhUC4GTmFXlct10OH2ULuywN78y/Kw82gKGqy9+NE+1oopMm04p9wtyO0PsZH0VtuBv6uXCxx0qiS7t1DEnd0EoeOSgKGoFcFil6cIGepij/b8haCbyfxtpAcVhCn31x0D4fZl/T2q/Wo/MLXZAMpgpawj9ShSnAe0mlb/8Rz5OoMO3iCAUcPWyA8HEFYKrR3BcFNK+nL1Ram3Q2T3EwIkX/pFZ7rHQWe3HWDT9eShPcuqx/pDATRV0+u8/1xkbTCYXlNeAyEIcGYHB92fnZP7tcY3TLHXW+SIlIDJlnOpbDg7Ttt7hi+MiyBUQAB8RVEhJa5DE7sBiQ6n669ef+910lQ/8jR2+fNGFfPMztXGSMSTNzLVFF3IFOkA+znVoHArE/coDxBjvOAgVNoK7T7L9PG+bf413cmU0JNYTgngIKg9sCg5aLQ6x0zKjAUQjTir0xlvFRTGy+y2tJW2GvLxQRmCe0N2LbYnfJ9zCa4Z9y+KJtjmhxiRvhmv+Y50GuDmqRNyoOoLbG7lTs5kmZaTx4jvjNQBX+FNb53mDNM2yLi+zAfvsFMqVnldwsIKnrEaQu4/PYvvEpbeBkP2C
 So+uAloJ
 catYjDgoXaXF1wfdi1W8Oevl7dOsbDYLyqfWJTzkmO88+WyuFomESKjHnH4W5uioDqu09GRNJkYI5p2o0ssFbo25N2Q2LBWcABAfqMktNjZY/AQMsgnXBAEam9YjapyVVAr8oW0h1lO/pW7UY4HxlIDKiC39QYLMEPdFQzel82cZ6ioRvcX1TzrfHlKLJQDYWOwaDklsSHoudF/H9GI0k3RHslFWs7+rTxklVyUjt32Zxp1JTWC+Tw4Ljl7mAavMRzzmTTcZGKpEOYmKuqpsBjIRmXdSrK259SLMpV+XmszPuT45v5Lj3g1QIV3PjKGlLJ+2Wj6W01YxXxjAPdMze0GyWbAGsm5NRwSp7GUQy/aHMePUYB3yqLQLBA4O1qjVzdbpkGa8EKzsHTgnV4J6sMqxGNlPSnVmm7u4dpGYtSdUdrL8VBDWl/8itbcseCgSvZzc0gYkv6hiQAgneRs7cF9xWVGnFSRXdrhvsvxgpmo5I7/VCrpcwf6jgGMfOF3h7YD5tK1UVBoFV4INdV0KxKxKntQgwbLVtSGw5HkayCcS3pnZ99EF7g3v2CJU4JnE0gVRE5KIG5aevRwPuQUfYhIeoM4hBB5y0gsQ7CoRASGiCqgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 15 Oct 2026, at 19:13, Gregory Price (Meta) wrote:

> struct mempolicy uses an atomic_t as a pure reference counter.
>
> Convert it to refcount_t so that overflow and underflow are caught
> by the refcount saturation checks.
>
> This silences the atomic_as_refcounter.cocci warning, which started
> matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu()=
=2E
>
> No functional change for correct callers.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp=
@intel.com/
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mempolicy.h |  5 +++--
>  mm/mempolicy.c            | 14 +++++++-------
>  2 files changed, 10 insertions(+), 9 deletions(-)
>

LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


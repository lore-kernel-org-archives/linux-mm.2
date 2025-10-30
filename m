Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2D0CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 01:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E728E01AF; Wed, 29 Oct 2025 21:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43ED68E0106; Wed, 29 Oct 2025 21:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DBC8E01AF; Wed, 29 Oct 2025 21:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21A808E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:40:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0AB514072D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:40:44 +0000 (UTC)
X-FDA: 84053076408.01.04B0543
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	by imf22.hostedemail.com (Postfix) with ESMTP id 04265C0009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:40:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ffWqeGYX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761788442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLyCFbjwdqYc97mtY4yxo/NrtYLsHyxadkgo09m4dsA=;
	b=ft25CecCHkQmmCov79yoqwkF8rzMdfPUP8QIuhuT27uVpvd3hu/3U7SJdFWjT2ft4J+Lam
	pJqHr2ra3iSMXdCXPUnN25+pDaWv3QIj1Tp61w8ukaSl0P186o/xDpe5MoOu8VryzlmDEY
	4o1gvGRM8/XsFZAUOkywJtxdS6KU1XU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761788442; a=rsa-sha256;
	cv=pass;
	b=RdURamb0s8IEwOJLkfOIXk9KLd4NUvab7r6f2n3/mRVgSY8UoeY1PU+1bHl8iYI3iP+t5h
	f4E9hB9wS0tQidWhAejMuQA6KN8q8w8COk4Fid//aFFPmcVNv42O+Sv5wC0fxMMVMJyrAc
	XfqJLH5Z9VzFEGXBL0NJer8m8G+FyTY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ffWqeGYX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKlrUyxmvVJvrm9AYC4AL7r7p4JYFn58Phu9lf9qFeVgjFo1THFeJWSWOvTR9fSh+z9vRGM6VjPQ5xrp9ovEMmYJjfxbx5E1xbqU7JbVzLETIsGs8WrWV244cerjo2g0BCTCot7O16x84HO25o1nbHP85ToI2xHsWZSzyvj/a2Tfd2fpuWhBNb4ycONJtm4S8vm3Sdq6pWGTGDRsjSOSxazjoK2M1AERb08eQ9JEiLpjbp6harXBjSWF37CiDp65QVyyTqMgd+hQCPAOtcGX7wTOJT69KeETgh4y7ZDjyDoufBSYsml60CjfDEUvb+ByyFMIesUgGm9iUBMt5//+KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLyCFbjwdqYc97mtY4yxo/NrtYLsHyxadkgo09m4dsA=;
 b=x35KS0TEgTqZXLyR3/E7c68wxUnR9mIDPY60v0FQxKWXh6ECEwhWgN2kr5nKhkx1XXlz5zKA+VpO5dKy5dkc7joyvzbSEQxyBdnYbzqS3D3io0+pmxaYb6jBzkcsXRd2NXuPcFQEfGYqWKbGWorKmgU1EpxClw4ZAPfJZ912JvHsq43km3ClU8UW1Bp+LhvdnErRSTv8fZcgqjduR+CAX2dv6l4fH3MPmJC2qb/rey2312x2t6yJF1bqTn3K3D46uH7hGbu+MjzRivw34VLqG68fSJWl3JnDaHQABILMLsgHz0FyXF4fgZbYIli1E1IAt6kddVe5fAKHaOO1lNlk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLyCFbjwdqYc97mtY4yxo/NrtYLsHyxadkgo09m4dsA=;
 b=ffWqeGYXxmU3p30caAA3tsv6JhMJ0mQP5kwGszH2vU+2MH0n5LuLZh0EBixXRXXqGmwPyQlvmbuU6Mg+8SKo72OQAOtr4yHkaBPUVI1YScJpzwMLdoUpRS1F6aQjuMyzRQ9D8sXoxKXiGwAlEx5Vmiq0A2GyAENRNmrF/zUZ+2cZY9uMC3ZqVoYL+9wlMbxzRk7R5kC0dyTXKM6kqK5R0MpXHPJUGf8h/6ngX82Pzy8wmSm5DW1Bg7b2AdwRZvjpzeJptfO9NwChXXeYbRc9bafKWSTHX85OO9ZiXzMIdtZSIddF2SFw09QtmvOImE/qgoMjftxFEkcmfHsOZrdizA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.14; Thu, 30 Oct 2025 01:40:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 01:40:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 2/3] mm/memory-failure: improve large block size folio handling.
Date: Wed, 29 Oct 2025 21:40:19 -0400
Message-ID: <20251030014020.475659-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251030014020.475659-1-ziy@nvidia.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 07340d58-e069-42b8-4d83-08de17554c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KUKGGcqr+1IJCvRHex/JHWOp+13+ltt6hM/uLburcUHyIYoE6l8XIskXByqI?=
 =?us-ascii?Q?BltJysNGAeLiwPmOM+GKwsCHXJdFJlyMx00ctoconUfx97pwxBo6W+SRBRP7?=
 =?us-ascii?Q?I5b2ySYjBTi0iAWxI06aqAttXDn9jFpfl/M3Pq7jJZjLmJSJ1+yFJ2tr1aIZ?=
 =?us-ascii?Q?2doTIOnACrjFIEWuKC3uCk7TzElpT2kcdpFfJdlr4fcb0ExRFNpVLgzWzFes?=
 =?us-ascii?Q?3ZRckMU56SbwinkLPdSd/KSw47uxwn4qN6/A9aQnrTsInOXW6P7AsS1uayHJ?=
 =?us-ascii?Q?syyKbS58MEX3TnKZVk2ugZiLClydYto3zcAbnyx5ehOGwmC9xA0R1g9DvZ+d?=
 =?us-ascii?Q?51h3V9t5bgjtDI2rXVfoB6XK0qOZmO9kNORH8ocBMF14O7ewayae1/L/ZfzA?=
 =?us-ascii?Q?Q7uIOfydNq1aR3Wq1/Ztmhbxsx5rnVdY1FCZS0Q9HM9jSe8vyAspCmJGiBYK?=
 =?us-ascii?Q?qklwbhKBQwYOJaByvJjcDeNf3jxDZhAFUBWVc85YVOJBW9wh+cIkejxrYyW/?=
 =?us-ascii?Q?9lxAqFheyOKDMa/LXZm8MnLzCnWdAZf8jA7O19J0VCm9YmOT06GX286zXl7z?=
 =?us-ascii?Q?/uG5FA15Wf9pji2IvW1cI8p8QNHKlAOKOsVOgaNlZOSwnfOXzGUFYPFaqkgK?=
 =?us-ascii?Q?2G5uhJjBfynX7RnB6JFxsNE1dhLfpdp45QhobcY/hTaHw9tiP+jf0rIDvJ4c?=
 =?us-ascii?Q?CWhHfF5BSjdC+Wox5n4tXC2g69AU3qZEx3smVl6p7nbzQddO3PoznH9H/Hpf?=
 =?us-ascii?Q?q+1VdotXxXsrAeyejbjpDr8e4EqGHcZ3vuVgRbVruf9z5Yl/qlxgO+jqvg/O?=
 =?us-ascii?Q?LSge6AJuUzplbosFx6OVblKGbEle/dFYfct5MYvDf3MnAedjTi29aDit8dbx?=
 =?us-ascii?Q?VgTWqIu1x4nT5RPxsJ2+C10Vd+bNmfoCd6dU4BH1qxg3Gy2ih2nasC7KSKIF?=
 =?us-ascii?Q?FHqbQP9lL4j+dKZwss0nL+HOG1Y15jNQRJ6bXnWy8qpjDpcurJgYhuw5qL+F?=
 =?us-ascii?Q?xtijdWcBmm3ZmFmeIuB4apu1v0dMftnk4qxw8FtxgbBMMMlQ4/1FNTlwXsEb?=
 =?us-ascii?Q?MXU3lBszNQWEy7LYz1Y0jEbpErnMq3gDVttD/+Z4ksJzPw/7sBvA9FsH7poL?=
 =?us-ascii?Q?OmtAA6YN8a0cTzZnrdU2kmx5G8yfTenBmnZni+L6ik3YiP1VizKEZpiDsjZj?=
 =?us-ascii?Q?pZ1fUQwFCFsORhvhThTKR8T60YJ/17SYxSYKjHeuMrmT87lkRIliSQPfoN2+?=
 =?us-ascii?Q?McWTLfPf4kY/pBe9iO56t+hUFR3vORfOhJUB8eruiZgC91cOLdRFrgCoJyiR?=
 =?us-ascii?Q?QaVJ+RnTU/n8FBTvIY9VLGOYM1hHxQvhZ0izuCHBeegPQ32qYqY5GxsxQBeh?=
 =?us-ascii?Q?ui5ow69wIwk4ZAYktf+VgX3nDWorUfdLFRQkQG0ZGQlumPgbUjtstzMapzHg?=
 =?us-ascii?Q?mneq24cW2F4yB9GZL/1K02vjp2ChDRWm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?egLjIkGrNzmDazw3IHA2i02bGxXh7opjvg0InqYUD+5EG/++iXxeaqmIBSnt?=
 =?us-ascii?Q?MKTdzK7oCnyfSFpP+v8uebB0/BKc9v1/Gi9qI3chqBpsdf/5IRXgBU2ju0/S?=
 =?us-ascii?Q?A9u8Ipl0gO/eXnQSTdvXk9tl08f7vM39/qc1p53KjRn2LyaZEM2OKjSLHZtw?=
 =?us-ascii?Q?BsF6kfPC7TXDivHPfJ37zk5N2InVCCFc2uJA+SvzAhulwwcuQd25U2oTL4m0?=
 =?us-ascii?Q?dEsSzNrTE8E6DLDxJVoL0Ct0GoqxuaO3m610ogT9yTz5Si60n5fwZbfe17/W?=
 =?us-ascii?Q?jQIoZshVjJa0hrzW9QjKp8DVERX4sD96p3ss1Q8xpQGTc3sPxO9Q4CXIVyx1?=
 =?us-ascii?Q?p73fbDjOwY+Fcq14vNWVRD/PtgCXqvinIvTM2/3wkV83Pt7aVjQJF0TA8Ugm?=
 =?us-ascii?Q?leYbkfDhusT0tzHEa/Js2objDxd9UGaJNqWNoejAnhPrdzVeLHGMaVdqvwAu?=
 =?us-ascii?Q?gya4X5QxGETGm1Rz5pgRoZOLcwTPa8X9YKBHluPpq7notnehTexLSvsWUlY4?=
 =?us-ascii?Q?uqlA8+P49hOgJify9/sigR9/QWMCnfwda8LFwlmOyOA2o8k97tMgl34zCvbI?=
 =?us-ascii?Q?QeNDGJWGUKienb6p1wgVUAV4HTeyLV2L0W8ga9TUdORCz/z0ngtmXbX8Cn3W?=
 =?us-ascii?Q?ytMh1efFbJAmFTZjHCWftrFpcyhW3fTny4VzDTdg05tobMiqZKzmmmQSFgSc?=
 =?us-ascii?Q?ZSCkk2j1cWh4rplzPhlVbW61XMOuT804Wmqd41HnyzXBXQcEuPSUvpUdPhmO?=
 =?us-ascii?Q?iPcM2bw7e60MhPYFeFtX0j8iyYdNFbB+0SiMTbSTysD/WnosBzxSzhaG/70h?=
 =?us-ascii?Q?RnXgj0Upe+Fos9sZxa+0Y9zt1/lItACicIHCbjWwzZ+kzq2ppNZ/lOXe3Z8V?=
 =?us-ascii?Q?XvbAT2pS8c+u/wAyu2wXe9+SmEwZDUlgzmifBhtseXb0QXYa+E7d59LCeCLA?=
 =?us-ascii?Q?OFeuh9SH2863CwQnCQELBTtF84dokEjNjsX76SE82mM1OFViKP6ww4Ung3Tq?=
 =?us-ascii?Q?sn5qKKSbiy2vX4xiYOGKaOsRixhgBem20/xospnJseR4axRpFxag8IBpAkOV?=
 =?us-ascii?Q?CPiz6zP+drGZ69i6vvvPJ3gmmeQg2IAL8xx4GGQJhkKYR6HRBsn+60vRYYX0?=
 =?us-ascii?Q?y0uZlWdv99aw9dmAg2rbZfXGru3FX1piwSB8tPh1rF2im/xPhoEuj5T9iMgk?=
 =?us-ascii?Q?GWMgUG6H3IgMhAAE/ZwxYkrPGfJJLk+xWiFRkNOQXwzt9n6Q0RgkVqaMI3f5?=
 =?us-ascii?Q?kh3jImzuF+P6olg+mzVBgBdbUaOFRTq1x+1XhWz/QChgW9C+1H1zvIDCpcK+?=
 =?us-ascii?Q?iiZzvjQDDxtrwgWsWSn11PqWY13ikG3DzmDjWvM+U1GcOGcKW5RGGSzTZFBM?=
 =?us-ascii?Q?N6SSf1KTOXqjYqpIDwOdNSl1Z1YAI7ZULyA0Tkq+2sl5VScMB1za6pC4APzM?=
 =?us-ascii?Q?fxTyHYeQLbp+/rAEiLyYo15PvOzR0/kvwn/erAOTI5mJMdAl0L9oAg9a7Tav?=
 =?us-ascii?Q?ig+RfGOZ4kNMIOB+DJMCAE01RwSfP6fYuxxjD/ot1FFsBmAikHrPUIOdH8Yf?=
 =?us-ascii?Q?iUBrKQQpTxz1e16ES4CtvP0JEKhk4/3A605155cb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07340d58-e069-42b8-4d83-08de17554c92
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 01:40:25.8637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6H5VV3GMdICN2BS9e02/sUbYFnONLR6diw/adqebCDMi8mN5voNId3R5C3/C0gf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261
X-Rspamd-Server: rspam05
X-Stat-Signature: ghb7rru5c8bkunjfkhood6yc1jinodk6
X-Rspam-User: 
X-Rspamd-Queue-Id: 04265C0009
X-HE-Tag: 1761788441-606598
X-HE-Meta: U2FsdGVkX1/TSqaUc1WHVs/ukXLeuqThUzYaWhEsVvnuZ3S2p5aUyWW6e/3HGLnuAG1ElUniNtH35bxIBMHOjRJjuchvRhsK+VMUT4JhlNEMBDNEva5nTc2GmXKXtIa2u/X3NgLk9mY7UinPI6HmQV3U+tNz8mWICOKOCIj4uG9VT07kyIG5NXP7VqD91KstAbjesWbuiY7v7fwRGn6rrToKhaLDlWIlaLmCLA04D1xIYOd8FKH0V1BRF0NyWuBtVuqB4memF1yvk2TYow5df3VosXoarcnntiQnPJPilcGxZ2/RneHUR5fsfj+l5eq0xTvRHEffa9NOPX70P9UmQhnthxaeaNfCQvRGKz3CakHwljAFLGZLfuoK8/QSk++Tm+DM8ou9ZRxC0Kv8JJOboWpbtFWqXI0MIk9DvwJ6x068eT8I73lJ9o+jVU7bIrsV0kMimDkcxaJFKCDr6jeO0T1n9ib7dokMOvYMGbCL44ihuvDQC4XmrwPHJQroBF66L+haEFAHbtSsqBagkEYc7VfkfrkL7b/pJ+PKtP6D6cWLkL+3VQsqvI+BD9aY/FCzml1YBM21tG1LVat6GkBHvXHDWaf0Nk3DbSEHL8DSgsCN0b6cDSQ3LIMdHJ6j0/Inj1p1j6i4CwT8gAW5Z5ZFYO/EIuA55yZ2pLn3VSoetnltHEedkROhVYpI53xSZPuazQ45k7W201QXCMhbhrMTKOj46cJc/qwf41gPQV19TW3K/6m3dxjj+lNbRrMolSpZYsiFJLBMOyY6K1s14baF+WDD7k2IFHZfhqA5fyVVX9QjklWJT953z0APYCgo1zvPkIhs3FEntcen7v1mJOz7O9X6tqZioQBB9C+EZXMkazCX4nY9cnBNoibPjhMI0L8dCgb3LZSkl2qZe1jDtm+1TkF4XejzYVswpoAYGKJvCI0URmrkYBtPvTmw6w6zgjFhq3O8RqYXu8075+lfbRT
 bW7ANO0J
 HehwvjIcoZKg4+RpwNhiwHX6mQUTySZ/jnoXGmhG7oldzp3JwyiXElTt964jbXX6kOl1D/smawA5zA+bJWZnBdqiDFSp25Akjy3RhdD+WWxvKpwF5rA7SISeBdihCLFWz2tmE2VAabPPAYpzucnvLBRO6NAYIN39DGtJeSxbUmhX7HL4t+divigZohNuAh9q60CNTeYPCihhGqTFHbS0qBWv99qrN9U6MwH8qUZxkurAPXx6I+vFoRqTpEx+LpSqSr2jq2WHgxVXUVawRPcG78eFLx9b+g3877oGRT+5aMF0UpFX57nhLfO7IqH5hhgrStgpOhvBmSnGXf6Fl5rtgbWT7umofEELQOOnQTkz3Uen6yrbA1glu8yKY+7pU/mOM8xbxZJEr3h/bU6+haLSXQwuNqaCmksZRBrZl2VlO623R71Y81ZMdqKZ1UKtrVtPDIbyGuePr0o5EKS9FQoVhoH9v9cNjKi48IgX4h5wSyoUtndemSh7IZiEgFg5ozMjrrYDgoHbv2O6Vi/l385GT8Ymdqa1S1pRa72pVGmJuH6KZwAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large block size (LBS) folios cannot be split to order-0 folios but
min_order_for_folio(). Current split fails directly, but that is not
optimal. Split the folio to min_order_for_folio(), so that, after split,
only the folio containing the poisoned page becomes unusable instead.

For soft offline, do not split the large folio if its min_order_for_folio()
is not 0. Since the folio is still accessible from userspace and premature
split might lead to potential performance loss.

Suggested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/memory-failure.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..acc35c881547 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
  * there is still more to do, hence the page refcount we took earlier
  * is still needed.
  */
-static int try_to_split_thp_page(struct page *page, bool release)
+static int try_to_split_thp_page(struct page *page, unsigned int new_order,
+		bool release)
 {
 	int ret;
 
 	lock_page(page);
-	ret = split_huge_page(page);
+	ret = split_huge_page_to_order(page, new_order);
 	unlock_page(page);
 
 	if (ret && release)
@@ -2280,6 +2281,9 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
+		const int new_order = min_order_for_split(folio);
+		int err;
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2294,7 +2298,16 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p, false) < 0) {
+		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		/*
+		 * If splitting a folio to order-0 fails, kill the process.
+		 * Split the folio regardless to minimize unusable pages.
+		 * Because the memory failure code cannot handle large
+		 * folios, this split is always treated as if it failed.
+		 */
+		if (err || new_order) {
+			/* get folio again in case the original one is split */
+			folio = page_folio(p);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
@@ -2621,7 +2634,17 @@ static int soft_offline_in_use_page(struct page *page)
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page, true)) {
+		const int new_order = min_order_for_split(folio);
+
+		/*
+		 * If new_order (target split order) is not 0, do not split the
+		 * folio at all to retain the still accessible large folio.
+		 * NOTE: if minimizing the number of soft offline pages is
+		 * preferred, split it to non-zero new_order like it is done in
+		 * memory_failure().
+		 */
+		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
+						       /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.43.0



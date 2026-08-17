Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B859DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4F56B00E7; Mon, 17 Aug 2026 11:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75106B00E8; Mon, 17 Aug 2026 11:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F0B6B00EA; Mon, 17 Aug 2026 11:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 695ED6B00E7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:22:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AEBE407E1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:22:57 +0000 (UTC)
X-FDA: 85111129194.23.AD66D83
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	by imf19.hostedemail.com (Postfix) with ESMTP id 187DA1A0005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:22:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bny9Alpd;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786980174;
	b=QlEHFwHvdl5MrsSx5nIZVrD4Q3clGe37IJ5itBLIhKWaOku9rAyRY9teg8vFo5Nal6zkut
	DdydySdxDkIMaTxv+VwOOPZ+lCLn5aOEL7q4jgqOagr+SdP8hncTF+bycT3WvmCu6eG38x
	eD7uslOK6xMY7meWFiCAf0hPBK8PnZo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bny9Alpd;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786980174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuAtPxkx9IorZluIXtXKr4uQTjHfeukF0g9O+KTdAMY=;
	b=h0wyKkXlrwh5Rm9kbOvPuKjh3Rz084rCrQqfPAW2E50hvWylMgM4Yk0VqUFBL9TOZbunLF
	ZXRhQCx40P2TPpyGl471AA1FdEPI66EThPPM9ZBEe1tuy43jaCG7rwt1HYd/a3Hd2R5WMX
	hFwV7tMoFQXPwacPGRfbfC/U8a9qNn0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHB3qCbVr5QVoqXwN6S22+MRH/zKTbmUdoA24o3l5l0RIRqPQDLlTvVfQwh0RGmgcyMbQWnkwuP3N32rFwWGQDIazp9AaQfLuM8MCNn4mCsHYA/07jSILJD5QyEnahPjbNxnczZxLDT7ICSdjCRC3QhovHfIGkPEMxU7nQ0Pdg+mu3jE28Y3fECNW6RLbcFvMPpQfn7biqgsdAT/4A7PFk2J5E/U4SsQYlYwF3Yb17w+/o8Z9x378b5QHvBkNhSX64AZtLluPuXNQZTAIOAexta98S4k51oPElNoeEKf6qtR8nTPuRHy6CUNDeB4w2AeHXxCRd1OryciT8l7zcA31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuAtPxkx9IorZluIXtXKr4uQTjHfeukF0g9O+KTdAMY=;
 b=BSajFx9O8Vo+ImPb9nffrWUAL7pIkW//QC7CFQL6CNESyFo2gTrhmIkaPHCM8zzgoJv8Vckkg9Kpq4Jz0u0cyi0uvBVlp2g/agjzMag4cX9BfYR69r53FUJY2Tfqr9qS5ZqOYv/LRWPzH51iYb3xAxyPDdllPspsIZQ322gL4YX5wT1NF/rzB8evvYgZOrUI5XmzQoQIRWTY0Ac8KpRDEsx1rVqmzPGZBXirxDxDKeZwBBh3BedOLYjpTyfs2H9XuHpi7HWVfU0gRLVl0icd1kI9eg5bfFd28U75crRGbOC9GMM+1CFwTMkIWU+lgxvug5alXde3WM6MoBtgJokz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuAtPxkx9IorZluIXtXKr4uQTjHfeukF0g9O+KTdAMY=;
 b=bny9AlpdbI0AlmRt/EK8ux/sil8Mvfd6vy06RAeqQUkSCIPwzgxCjpK7Ks0vCFnC6Za/rGalBIHTH24Dxx2AILfQ30Vje1DpCYUBfjtl3Hy+Y+qdGMLfdAE5BAzFSdqioMjLV/tZ1ekdWTySVJLDjZY5blCHWNAhNXwmWtNJm2oieXqRy9yeuOO6AHZCpot5/+v9x0draX9IQ3Zwsx4QWhgdJ+JrtxiZd8XjtpvkUYSexTRapYu4ZNtK6ThbcZ1pUg4qv0I5WCmG+unAtn2p0H6Pe2VUzwbNYoQmgRhvNdHpnUM1Ypk2xEbZiuTqdbdT++wmITBauwPeCvIMc1yPtQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA3PR12MB9157.namprd12.prod.outlook.com (2603:10b6:806:39a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 15:22:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 15:22:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Date: Mon, 17 Aug 2026 11:22:47 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
In-Reply-To: <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
References: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
 <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA3PR12MB9157:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b946f9-fbbd-450d-98a6-08defc7365ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|6133799003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	16r2q6CZAaATeWTdWOM6OXKK2+GaNL/kh7UAGujPPWn+3n0Q0fMmZS8JidI29+NyxS2jA69o4I0LkLbRXp6fEbSTcIYu5D5E9YjYzGnbuu6C1Ywej+CWBVu66/cremoNmUGl4HWahCUef3wCIw1oRwgq3ZAG10ti6rg0LnGps2hOYYboYwUaxSmYjwkxFBz2m1i0t4R9pHCqkMtsGxEmUAmWnPASIz03mDrswCInq/oNex1wPKpTOzegJxp1pvedz+eDuM9sokF35ANeSsYWnYlHnoW8Gyz/xjTgR56ktP4GuixItAcJ3uyUkiAN2gJm+Ny5WJbOzlLvVmgXp0sTnfK7YciQVzsf9jJ4vqMKkIIUoBFsR5n4KvxHSfsrDirurPJ2MmZ7OtdTs7MTv6Iqkxq20Mw8JXh7Vaji0Wt634tPZ7zAQyzBf3gBbcRfXg8AU2sS+vQWiPRfiG0tQKGPJrbVNDP36Vyv7VWx7FiQsh1YPnURlo7BlpPlhNqum57izeqWcwIjMLhTT+wIXV1BflYAZVULSshlXfJ4i7XCpNbTzbgiC6N4l12mUYlES7Bb14AaeMH2Ipj4LgZJeLfV6As527p57Qo8dvdguqMgZ4kOiMppooa2JDCjBV5Z5UHh7b5hRgYfeRE7vj+tgCL5wY5fmAxjjpL99PLcu3K3d4M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(6133799003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9niunN/hfvppvid9SVdCslOl8w08fAlMTUjuhvaYdDUPYbqmGoqP7aM8Ickv?=
 =?us-ascii?Q?E9fUlL3cxi7lWmtXiSyvS8V2f2K+M8sVnFeHuEaDMrOua2LAmXFRGaauArgq?=
 =?us-ascii?Q?X9QwxGyG9xwnuS/K2LotN4QkQRMK3c4LNNOZeuPBo+B1Cxb7lCNz6Y6T/9Ul?=
 =?us-ascii?Q?9JL2g8RfxzzKX7n04//+knFkymTsUhIHJO/yMv5Mq4d5Tc59T5GR5gPAA5lU?=
 =?us-ascii?Q?3d1o2OVTgFoPpLXHZtvs+X/Xoyb9ZXXnBTKnyO1hYkSD7E22kegtN7YHy83O?=
 =?us-ascii?Q?KBhZ3Xte1QXyPExCPobDv6p+MK/evG9hSyPZffqGXOQaaBlmMn9YkJkzCYu3?=
 =?us-ascii?Q?9/Hxg02kfrWGHZnsI09JTNZYERghP2krblCyyoA3FbAb906S/pAtPvNU/J7V?=
 =?us-ascii?Q?dAJl9xD05cFvHkIUaBlh/QO3lrVXC+X5ekViOlJeSdohVZn8lbtbO8t0KVBt?=
 =?us-ascii?Q?l2m6m8ZF4+r6nLmgeuEOAmo89QQ2xFCzX8NVTFr2ber0zvh8GIloLvLMyFyx?=
 =?us-ascii?Q?6AojigBpTF4HsHMe+FOvH3lqLgPfpsKXV6sAnIUUbSdTeoTnMKQngGSLp9U6?=
 =?us-ascii?Q?nKd6oM5JWgmyLMQSJaEDC11wz0lMwgCjPKeABIxCdzphVKB30W3Dn/uzxUmp?=
 =?us-ascii?Q?M8no3exDs5JRGroEMsNfQonmDFQYFO6nC8P4MRhDn6X8ASri265bI7JmivYz?=
 =?us-ascii?Q?njiQfZXaebxOiN5FVyfYUNeKKYKCfp2tVJaoWKMMtBN9q5wzQbswYxKRjI3I?=
 =?us-ascii?Q?tOM+JCajoCk/tNYEMG45Zp8Th9JeWtxJ0t9cBdDMf1tupYSvyoFeOYbt4hwf?=
 =?us-ascii?Q?jzQh6ox663BcTPOx1DmD+hUkqX/kKdG7HL2jKjahjw+mdWBXJravQYXDxMT/?=
 =?us-ascii?Q?njVipcVCI22mY7zl14aTd9hriEjEa867Fxa8sgSatnBmGw5doCaTp4gG7VvD?=
 =?us-ascii?Q?ahZem+FSltrX8BX2RYETZwgPUmNGZwkQYTnsKxS9/NO4pcHqGdy5ifz+5eRC?=
 =?us-ascii?Q?OE7wo3HqVJehQ3vA+FLB8otwAC8d5pV502EB3lyzUmoBikz16Q5eTcHJOQfa?=
 =?us-ascii?Q?Y4Y8JGrB+STcrC44q/fRWemgQYvQ3HqsWnEuRhbSZCiicbAgJoYm81K4PTGL?=
 =?us-ascii?Q?lRDjLfMdp0jcdb4TyXeY0fAx4tjK7GUfCw28584ldc0ITizvTB0ivsmsd7c3?=
 =?us-ascii?Q?XbVUWPDPU6+x2Wu6cSFGbXJCWQ31dAM3foI1sZUfZOGTjUFr76U2fcAjHnGM?=
 =?us-ascii?Q?1diocYILz1b+J9Y0CARhZFSfxR5dUDf3UJML/bPUljQpAcFQS1bqmFe/ztDD?=
 =?us-ascii?Q?M36DaOMWFwcr6bn164dGeQEByvtr6WSGENxl/pC60c/t3ZYQqgruK4A8mGWu?=
 =?us-ascii?Q?9+orTiF6AF/SlLqwQ7XoFYCcI9XnVoKh5opu4nJ6FpCWF4J0w529N3Ep7duB?=
 =?us-ascii?Q?UlWkQHM9bUOx9X5aS0fnnS3QNwhxQG0pNfgmErWCmcqJfMRMZu1PgRj/jTnM?=
 =?us-ascii?Q?Br+ofFT4vs2SbIt+avqF/l0BWTy0mqxnI40oNn1OtTWvkDQ+BimqIG0VYRLj?=
 =?us-ascii?Q?Pq+wI2wXhzcNaAQ2tLq5weYIwEJ2D2Nuh44fe0DvzRjriFlnf+QUF5LZ80oa?=
 =?us-ascii?Q?lkIxn8JW9zv+YizrnS93leL+KkX7DG7zfViJZRVE6NKmIGbu860QE45SKzYX?=
 =?us-ascii?Q?tbWdn8YDjHehcIHuvn9W0dlz1EA3wh4DyYSIxO136+0xR3ce?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b946f9-fbbd-450d-98a6-08defc7365ac
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 15:22:49.1721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hy8klAbaWAcNaP875dUnDZuD867BVD/u8LED+oO0tR30d+EEzgmHnwZBgQ5AqWEU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9157
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 187DA1A0005
X-Stat-Signature: z8kprygsai9rs6xugi3ct85rwifqhczr
X-HE-Tag: 1786980173-669982
X-HE-Meta: U2FsdGVkX1989zK8vTroFqMR1jzTj5Z0Etso//OfvRwFSEX/oGbh9tiF24SVN5M3TDhM22a4O3HR7AtfV5Q1d0O1VG6clbJDrEl8hv9SXhdiIKhnwBT7tK8CYr+QHsu4ixGYaFo4O8atBnKlov7Oum0NTLR4C7CTTAWL0PyqaPthK9p7+6Vy/A5g9GhupsIAaZkos01HBzL57tkcaXAbwFXHJv+b7SMUM9nV4ZabIfdPcV9CKqocDD1hwVD/ZmzxCwLRBsFBG6ar6sahFgpYNNcHVEgyFZfp8R1vJBnqUNkw33KLG+LtBPsnmJ8SkKNPWVz+K9lTkLIfkls0++6fsEErRjxNob8tcaBjy5U91bhWKNwfPGejAzOPjpcZItNwJQZ0I6ikOmewcf8xGrbAJRad/vgKljNMCzncjImb1US1nikwvuY2gtf16j8M4mGs66ybj6vd6GFtoTzukmMOkNAtqo8vOXCe2icPxgJ8drYxlbWgcmBH9mCsYTl6sx73XnVLLbHb1RatX+0JfBaPuzl1O6Jvr6D0s/SILRaMxxFkPKzYTs7M4zFwmcz75KkjGaMB0cHUGUedLoXAk7y7R52UZ/5WnyYnzL3FuU6+eqQ03AEZ4BxtFwSe6OSMttflYZHyHRPCCkTxuuHLgfkG09aUs8UBWFJpDguWFB7UOnRwF+dNTnmg9kfhHBRdLEcMRnSxTZvsJMBHjWaHp/bkk00dyfGLH/GebDeJS1hAGvbNjLJJVMbkvaui5k+B/FgQ6Dc6rkcccq//uDEItr2vbYjKPAm2YkQosK1s3ZlFf5TF7jpDslZQlYWRoyua79lZKpB6YUzbR3IO8Kc16Zi2hGq+cZOZZOIlHuKe1nC3XtFIujUwOqgvE5szgc2MKbMpG+IXaNELmtdoyWft4IvgFeEamb9Ud4AOv3/CSNFZCdLU2IScEw4J/hGLezOC6i0C34Mzvj3jcJn48Op6cH+
 4HRuSAnD
 7fsc3Xki32YiOoqA4WUngnoKu87Vi1fDoJFNM/oI/j6vQ2aiLSvUHYxAq15her0ICEaQ5+zkJOQd7rA8YNcOQzfEOQOo6nq+oxJPajMWMCJhrv7L9msUV9OJRurwWK1uhHtH8vlON33JpdGhOH55VTRERQVLpnGNKZAedXdfa3GpxHPmJ8H7JLmDVrKZNf4klTbTtMAplsJLyQhnmkm9LeRF0Ig15LhhGSJ/BdKf2YbiixpnwPE1wZixKC39h88CsNRJ7AUIK/ckv4c8NKWqsNYZwgioNFizi6KmSqt/clHmZznKw1SAJei+j1s36a6jh3UQJ2Xp3PTqsAgV0Veg9TQ1QkdddnYJYY01Kok/edmREJ4gLzE9L5B5+/4tW9PnCL8jeM0/H0Tt7sZlq5XT0qCsqwklLoTE4Qd8wfDzdVUh2/HOZhn4GFUuhAmFiOa74YLnKQ2w/8vrcVlUElF9VYiUmWsC4Y5Gkkv5N3WdERG+riNP0T1XDI1wClWu0IZzJAPKvemcKaNdyl+oduo28wpAjFOCeGs0dqetAIH7gTXayeG88s2muXEguOwig8kY0rB+x0Y6OSQ5awSEi/ah2phVP0gQBlMJwXJoTDw3euTQLlso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Aug 2026, at 11:06, Alan Stern wrote:

> On Mon, Aug 17, 2026 at 10:37:29AM -0400, Zi Yan wrote:
>> On 17 Aug 2026, at 10:34, Zi Yan wrote:
>>> But the warning here is when kernel user wants buddy allocator to giv=
e
>>> what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
>>> tells that kernel user please ask for a reasonably sized memory.
>
> That's fine, but it doesn't have to be done in a way that will crash
> many systems.
>
>>> The issue here is that the inode.c code passes the user input len wit=
hout
>>> checking to page allocator code. Capping that is a minimal requiremen=
t
>>> to prevent untrusted userspace input getting into trusted kernel spac=
e code
>>> easily.
>
> I disagree.  If the memory allocators are so fragile that userspace can=

> break into the kernel just by asking for too much memory, the allocator=
s
> should be fixed.
>
> Furthermore, it's generally recognized that library routines such as
> kmalloc() should check their own inputs rather than relying on their
> callers to do this work for them.
>
>>>>> Why are we emitting a WARN if an allocation fails, given that this =
will
>>>>> often panic the kernel?  Should we on the core MM side dial that ba=
ck
>>>>> to a pr_warn() and a helpful backtrace?
>>>>
>>>> I think that would be a very good idea.  Only the caller knows wheth=
er
>>>> an allocation failure will leave the system in an unstable state; th=
e
>>>> library routine shouldn't try to make this decision on its own.
>>>
>>> In this case, the WARN is emitted not because of an allocation failur=
e,
>>> but an invalid input to buddy allocator (order > MAX_PAGE_ORDER). The=

>>> WARN is for kernel developers, telling them their code is asking too =
much
>>> free memory and core MM cannot handle it. Suppressing that means
>>> code outside MM can abuse page allocator. Code like doing
>>> alloc_pages(MAX_PAGE_ORDER + 1, __GFP_NOFAIL | __GFP_NOWARN) should n=
ot
>>> exist, instead of just getting pr_warn() and failures.
>
> Again, I disagree with some of the details of this argument in this
> context.  For instance, if all kernel developers are supposed to know
> that they shouldn't ask kmalloc() for more than MAX_PAGE_ORDER at the
> risk of provoking a WARN, if this is such an important restriction, the=
n
> shouldn't this requirement be mentioned in the kerneldoc for kmalloc()?=



kmalloc is the normal method of allocating memory
for objects smaller than page size in the kernel.

See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/include/linux/slab.h?h=3Dv7.2#n1001

In this case, kmalloc is used to request > 4MB memory.

>
> Regardless, if it is important to let kernel developers know that their=

> code is doing something wrong, why not make the WARN conditional on
> CONFIG_EXPERT or something similar?  In other words, prevent it from
> crashing production systems.



Best Regards,
Yan, Zi


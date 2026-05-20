Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40289CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812B16B00D3; Wed, 20 May 2026 18:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C45C6B00D4; Wed, 20 May 2026 18:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2876B00D5; Wed, 20 May 2026 18:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB6B6B00D3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:36:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7139140464
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:36:27 +0000 (UTC)
X-FDA: 84789258414.23.9989077
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 217931C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:36:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SaZpZ1Jj;
	spf=pass (imf21.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779316585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCZbEwOi3K8kms8zzmNmkkSzIK8lGo2/QMP05wq253Q=;
	b=XKpF8VdpyDq80dbJE54ZO60yx0ehLXlEIT1z/Xd6S9RcDu8rgsx4KXl/p3ddw/YG6mUhnW
	fXR0XtrCfcRJSgiKLz8fgSdNEV8R0Kx82xRwYl+w8d2yZVPQw8xZNcTpY71cEyjCmZCOvu
	TuEHwOx2mpVpcXZsHpNhAZA74F8ZVEw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779316585; a=rsa-sha256;
	cv=fail;
	b=bs3tR3Lb8I+jo/edMsv9kFqOLOxmyxvwb46Y+B8Mj+7pd/aEwWre2dtm/4hpDEbYSYcMHg
	35n9Z+6VbzFIrkTG1zRn2nNwdyTDliJGoXQFyX81e5Liif81LHPpXj3X+s5RKQYxmRS6vE
	x0cjXl/FSg2XUIbSi4hlAXmANUrzw38=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SaZpZ1Jj;
	spf=pass (imf21.hostedemail.com: domain of apopple@nvidia.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fomd5H0GVkuPlTmeZycWcUzLrhB35qcUagWQzSOxbf25OC5enBeVIoRS011h7zq17As/ahix7doFWP9Je+mfEzMZGbHGwtAHcINLoO4weHuaHXSTmIVxduMd0bAJw7Ntd7gaQiB5BCD3WlN8TUDNQ5sn2BSKIlAEhMRfLe2MwqfwNpDsN3TOrEt4ybw/oL0QNCQO2zStzxub4xSOHXmkJxWYdqd4M68sZtA9DS1wsOSu3Pfsw59J8QhaEGqbCxLpHRONaonUJ1cN7nUOMyzirGS4R80k5ML8Snil3b3kN94hSKI53RlWG1fuMpgWnUiqopawVoWlF3Ys35r4fVjlDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCZbEwOi3K8kms8zzmNmkkSzIK8lGo2/QMP05wq253Q=;
 b=TQZ6EcHg6PkE7YJV2zqRiH+ABOQHoehvRkVz4VThSUTbeOesRTBuNdamWNsUInk5OJBNE6ENlBsXPCJ+l8IDb6brfjfkdgcJ7cacOP0ebU38z5eysTiqgVT8n799wUvdkGJrk3FRjtLljY2zb4lz6kbWIoGNvtinIm6GHDBgADjW9/k+3Qzfe/4YOZdNMCjNNR4SpBrgVnXP829qdbUreWZ8CP/yANlsvFnjA4+rm2o9cID4whV7jIjA6jFoVW5DD/pYViFRG23XMOG1kMomie21YYx3ZwwMkHKZi/urBjESg8hErvdqlh1GBWKWWsetJIksPytEfWhDxRSSB/F80Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCZbEwOi3K8kms8zzmNmkkSzIK8lGo2/QMP05wq253Q=;
 b=SaZpZ1JjzCGLFHoV3Q58Y7+ZVH4J8qW0RM8Ot9P5Rlt6iEUb6n1rLTDrRjdlLRFaJ6uH/cYmYITZd+MccQl3HjCydcA+//T8RhLA8IT0op3oQAG6nbG46Qq8Q3vwmnFeayKv/djErdRRHbno8ZY41bZlyPCv3moc5PJTujPdLJuwj0CgCan8OZ6vuR9Q4/Ijrisaul7vf4MgaWT9pAeAm/E/ccmYmOwegekT3qVBu9EFeMjYtnfix8QH/jfkYFVOOGfiHqAPUhGoQT5v4sicwbr3QEtw8eXEnFEy4oaxd6Ye4Kzt8wscpQH4yzx7yb+X76zj5TRiJbqm5n0igpBlxw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.21; Wed, 20 May 2026 22:36:14 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 22:36:14 +0000
Date: Thu, 21 May 2026 08:36:08 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, arnd@arndb.de, 
	bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mingo@redhat.com, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Message-ID: <ag41kVX1wky9hNXc@nvdebian.thelocal>
References: <ag1Sog3zDcJuOaaE@kernel.org>
 <20260520115731.35059-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520115731.35059-1-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5PR01CA0002.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::20) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: f1339256-21cb-495b-8576-08deb6c03308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|11063799006|4143699003|6133799003|5023799004|3023799007|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IKUsfOvyJ6jgmAZd/2iK6eUa1GuexjFw1uWMGEMWD9wdrM8qf3qDdmCcWb3FekjJEiofxTlsdJQsdVJ52sUbzx+YZDg+HwbuNseg/juKjADqiPJAGgWAPEg8g5bMgxW4n1hAqu87mGEiJIwNu2DD4z35NMUtab8ms69dxwNunbI46HKOJ+cdS5z5g9jrBc9wHkKWMhZUpe/rKl/Iu8UODPUapcYIXH03HF7QlOS8Y/OqEANOhOEPdn01lXcOoRTYZVwSTQDY5a/q3Wa5ewGJbtzOBqj6ISLNkjPBn1t5PrnndrXxGvmucYw/XN4ZD2h1Hqw60DI4n8dQCPvBzFyHEnyOb4vPXoqMCrlVJIgbJU0rXD6Zm7UKgkxT0x3fxBAZgES894P+gYJsxqAV4eNYPXG1XMNWsHQbnSbdOA6LrJJASgkkFrECB17siUoF9bisldM9p31F90lalHfgrna6+xGWnqtTpiUwYc39NFPQhB+mXWyvsimdRKMOA3EAFseBK651hR3ACjkCXJ+N9tdf4vqSTjH6u5FJUtXqCPKvyE2oqHFCqwmUQE1Rh4SAuNClnGG7mGCL8mVjPjeQOumlqGsqPLHZXmTKEjk7HOKpul+LJ/QqdnnnFZIBYPp2rD5pykl96MD20JPevNK553iGxY4Ae1GuFUXdcIpV3dYcVX0HWYbDD6IYMD8dmJUfyWUS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(11063799006)(4143699003)(6133799003)(5023799004)(3023799007)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MVlhzd95WkykQFg+0DgJ9dw8MUd7CskhEGdTGF4REzVCYTWcfjRyxYbUHvAW?=
 =?us-ascii?Q?Uz0VmXdnW46hzmvm5ea3PAbwQ0RWhzPFZZDM/8E6oEfwQufeWHsPKYh0AL0b?=
 =?us-ascii?Q?LZCNIaz4KfhyS2SgWrfUZxO2tLUkK1iyi42dnvbVHL4OEPyQKG2pkG3zgnqF?=
 =?us-ascii?Q?jkTKxVRpCS3oZyKj6DF/nlsCu3/Aa+1JNffS8/qC0s+6zLH5z4IGryzJHvVC?=
 =?us-ascii?Q?GMaoGE4rmMYcur7W6fbK9GUSU38Dx7o+1QtxkN1w5y+D6BiCI12YCwkoA9Iu?=
 =?us-ascii?Q?UBYWO8aYohT806K3Rvc/q88/6fKO6hHXPO1H6JFBqJcbxegJbcSmDGuRP8wN?=
 =?us-ascii?Q?PahwPSIhognCMpn45zi851ghfK3YAt9epiNtfxyksuOE/Wm3Y9QsxCo1a9LT?=
 =?us-ascii?Q?oVguXFV+mUOy2WJ1REEfjmeiTwBnd0K8r2QfV0d7B0UeyZ1i72yZwQYpHbCO?=
 =?us-ascii?Q?IT/CckjJb1sO74dAhVp4ACaJmujrCklqAfUQJkXec/zitxPxL8ZHT1HAkMDi?=
 =?us-ascii?Q?nQCjc/gTejI4g4hwMQvrEaaIfr2MaRvZtfsI9IJ6T7sXwfawY2APWh6mLGSq?=
 =?us-ascii?Q?C4RVGV9JBYg3/ZwgBnbf2vMLglJb5P66htuPVA771Por0UZrsHrqxQoRrouE?=
 =?us-ascii?Q?E5G2C7Vm+8lpVsHfcvqpD6WQ/T/Ll8nWJ0Xp2phNITGSX9Oony9RIRcjAvrU?=
 =?us-ascii?Q?o4IziaXvAqIySaTfzEsTwV/MyPZrnfirzvLEvwMyQkd+xth4M6YCtHb4RR55?=
 =?us-ascii?Q?iuYEqs3VTUgOPhIDa3VOSiUWIEEwehtSLFznx3Tn/gQJU89QVN0EJMsVg72c?=
 =?us-ascii?Q?E1A6Bxb/ujs+MN5gLuVxY+49U5EjWEoRfVOF7SUAJpqS9gN2pUlvZQQ4WQpf?=
 =?us-ascii?Q?0JA++/Bj45NM89IjvxpwUyjV1bezpprHbxwqqG35oSNKbsQlfBlAYS6DmiRM?=
 =?us-ascii?Q?QaJXf9upsB7I4oax+xjPJXi+ohxqkbOobG434LKRISdJAgHTV0F3TioJrs1e?=
 =?us-ascii?Q?82KQl9iBl1lI76YWpIpdG4lq98bNDYD+Mgs31qepkgIlDVHY8LnMs7mdfWYT?=
 =?us-ascii?Q?aUcC+qZkMJxFlVUOMV8XAN4qnzDNPJcLP/goCowqliM2BtStH6E4sjab37Lh?=
 =?us-ascii?Q?vgrI7OF2wlo3QZPfPuMyybzosDjL9Ik1fcUmUBi7aEbBsW/JCIbrUknjVbMt?=
 =?us-ascii?Q?Jo6SigctTA0Fj90Z8haLNonYT5sVwnguGltluVbkc+vnfLRk2IVGT6qvtBXx?=
 =?us-ascii?Q?pKHGaXdR3tUwIkb7JqD9pNy/I1arFQ8eUDoyBGfdpwyJWt+Qx3p+CcJpiXb5?=
 =?us-ascii?Q?hKN3J34Vy5bQaPqieS5/fLvAyPkNMOu9p/qFxt59o+wtJyQkcjb/ZhHJchp4?=
 =?us-ascii?Q?h/9ZH4EK+c32Wu+NjM/sS4KIYjn/sfTdOQdcLfP12DP71udY5LHOIlah9Jl5?=
 =?us-ascii?Q?/qIgdaZy+JYLPZ8g5x3wU/UHJEVg9nLNq62TvnplD72JiDsdp4yjNAxfcoh3?=
 =?us-ascii?Q?rW/2D5GF08tk9vQV7NeNjXBKQlpNtVbnBWDLentlm7qjhZjSU2/M+oUig3ml?=
 =?us-ascii?Q?FWkXClMD3rZqxfmTf8kCkgrYXQQYPETK7NCobydB38DN91IWpevaJUF5Sjrv?=
 =?us-ascii?Q?t9t2qb1WV8oI+fC/COY8TtfEjc5Ry7Dtnvdnj3pmvay+PbID5oaFyp1Gr5UN?=
 =?us-ascii?Q?aBbPPNilsv2y0g1AG/mDZdUWMi6Q0dk9LbZk4enRq8L13tuTaXxXFIQein11?=
 =?us-ascii?Q?77qqzEKbPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1339256-21cb-495b-8576-08deb6c03308
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 22:36:14.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHGAuMmC2ySh4FxR6N+nJkupnIXTxZG21IpH5UnnXrlU9lez5fOAHph7Z0iw83EvdRQ7Uzoc9TjREF7rR/XyCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621
X-Rspam-User: 
X-Rspamd-Queue-Id: 217931C0009
X-Stat-Signature: xu3smz3yatqahtx5jgbdgozwcfs39k47
X-Rspamd-Server: rspam06
X-HE-Tag: 1779316584-908686
X-HE-Meta: U2FsdGVkX1/jk2KAwlmXs/cxdws8F2vAljpXbdx7io6R66xsHZnCPpUZPr8bev6cR7uD0p1wxpNkZuSQ8XBCZ9Co+gRFfEGRDXBd9odRUqAjBOAAWgQO8ljeQFPT0iiew373toQPnL6RxjePyVvns2s5/X3PVfG1DaUAiWfnhI0tQFc1lICbj3Mxhk/7ukD663suTCfv5Tz/Q4V5/+D2lMwDQHvZxCWiRTvnFigWpyVJzAunc4A7ViNyFa4FxBcViKJViYeGkSdk51WeHyV8ujrX6OOG+xD0GVsBMI8zvAuYCRcJ/x2D6qiv4CFRHFAn5yjcDSLd2EOvKjfGKvykdguNseJpyPLdH8Ny6tRlPjlgdabaqUzDf3WDyuvmRGbEcMZ+k34u+RGqDn9h/q9WN4KVThiVyuxA0CbUty47ainCifFQFaMlDb/xw+czFeiK1p7vflnenDgWUezQLYE0+l7iSBtLoSkAo87g32mutQu/GZpb1U+MObW9tBrpPSpmjwxnQmDCIsmub6TqHEuXkoiwYgHqc2729U3A4pe2UZlJiWpJ162GnnAnLKtyQSeLLeZ53XcSTURMQVJpKiY1ceLKWRxi5z6CEP8hBlqXNZlqKNKaUgOyC7liO7/YcIwWx66p+BKGZGMrsHVe0RaGk/aGha0PdoaKX56BMtQTjUrigIi+Je+LkXbCtar3eS9p1pLHwT0+0Y58egBTkqf2epk+MK2Xsr+6y3GsM+pF4LCPTdAzA6e48FCHHx/PUq0m2XdJshc6Jwu119XTej5Xc/z2yMKx7Mq5JZ3rf2AWyeXrowTZ+9RyV75zZF9XjiB3uO45NohDoAMeUKGvTqfZj/QdRd6yYzQwzmlOzgaBU9l+DnRrIMFgnF8P6JGk3gszY57TvM8zwEsndjkEQ9k1kezLYefOQ1R3sH0zLjqQwK6q8UIaAMlzrsBN0OzHaVHe0oB7S4H6iwZudn5Xfmb
 i1aydqaj
 eJmCZoMR5Ml+zFmQxsKWkFqaEPQTHvyeh4dH2aJ/WR0909zyKaApNmrXR0aVPh3ZiyoMQhns83LXzsVNUL/0Tvr7Kg19Vddofx3Sl9ZSxj5XagORMfpvrNdSlEcZxOjqzv5VG0mOl17HmozkHMWUyO273IodhLpkE/5+VaIhcxXTCjc93jOCgEUNFDo7mlmQv15bJKbDkJC6qZBDm75uayzj9wdwDnocVeiAGHa04uousnI4CigkXRjP3n3EY6Dggflh/y4Ue6ALSOuYyvzOgTytkmdd4Eitngzuic1fmz/5VbomKIBj9xZPMgy6CL2E6c9SVRVMqSqux5nn0vTr/D9TTelBBl61+CK7sVxg5lmzWHaBNmmW+1NKtENtMSpwF+qf8/AgWuUtPDyV5bdxDYChs9IxMM5mfUsWj8ck2WgN9HbQ7DPfub6sBn4u0eQeSvjlWojUeUhupXUzLep1hKMQYlfPcOqitNG+wYgvO7gz37zbKEEbs433R4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-20 at 21:57 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> On Wed, 20 May 2026 09:20:18 +0300, rppt@kernel.org wrote:
> 
> > On Mon, May 18, 2026 at 04:57:00PM +0800, Li Zhe wrote:
> > > On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:
> > > > On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> > > > >
> > > > > Performance
> > > > > ===========
> > > > > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> > > > >   Base(v7.1-rc3):
> > > > >     First binding: 1486 ms
> > > > >     Average of subsequent rebinds: 273.52 ms
> > > > >   Full series:
> > > > >     First binding: 1272 ms
> > > > >     Average of subsequent rebinds: 104.59 ms
> > > > >
> > > > > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> > > > >   Base(v7.1-rc3):
> > > > >     First binding: 1515 ms
> > > > >     Average of subsequent rebinds: 313.45 ms
> > > > >   Full series:
> > > > >     First binding: 1286 ms
> > > > >     Average of subsequent rebinds: 116.93 ms
> > > >
> > > > This is really good improvement!
> > > >
> > > > It would be also interesting to see how the template approach would improve
> > > > "normal" memory map initialization.
> > >
> > > I also experimented with this approach earlier. Unfortunately, in the
> > > normal memory map initialization path, functions such as
> > > deferred_free_pages() are invoked shortly after struct page
> > > initialization, and this function performs both read and write accesses
> > > to members of the struct page.
> > >
> > > Non-temporal stores via MOVNTI are primarily beneficial for streaming
> > > write operations, where the cache lines written are not expected to be
> > > reused by the CPU in the near future. In this case, however, data
> > > written using MOVNTI is immediately accessed again through regular load
> > > and store instructions. This results in an access pattern that resembles
> > > a write-then-reuse workload rather than a pure streaming store.
> > >
> > > Consequently, non-temporal stores do not deliver the expected reduction
> > > in cache pollution, and using MOVNTI provides no measurable performance
> > > benefit for this particular workload.
> > 
> > We can split initialization and freeing into separate loops if there is
> > overall benefit, but this needs to be verified on other major architectures
> > as well.
> 
> I agree with your point.
> 
> > > That said, a template-based approach can still accelerate initialization.
> > > Based on measurements from this patchset, it should improve performance
> > > on the generic path by roughly 10%. I would appreciate feedback on
> > > whether such an optimization is still considered useful.
> > 
> > Improving the memory map initialization by 10% is valuable.

Agree with that - GPUs have to hotplug 100's GB of ZONE_DEVICE memory so any
improvement here is valuable. Thanks for looking at it.

 - Alistair

> Thank you for your feedback. I will try the optimization after finishing
> the current patchset.
> 
> Thanks,
> Zhe
> 


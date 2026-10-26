Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40F1606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DuUyw8yv
Received: by kanga.kvack.org (Postfix)
	id C209D6B05B0; Sun, 25 Oct 2026 22:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAABD6B05B1; Sun, 25 Oct 2026 22:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BA36B05B2; Sun, 25 Oct 2026 22:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 743166B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:51:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFE06C060B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:51:30 +0000 (UTC)
X-FDA: 85363251540.15.7FAD2F0
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012022.outbound.protection.outlook.com [40.107.209.22])
	by imf27.hostedemail.com (Postfix) with ESMTP id 02AF240004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:51:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DuUyw8yv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6OsTiixpt5M1jc2jalslJkV4KaBfj1Z1QWDgxtaVRk=;
	b=um9q1iWRXMjZbIN5g2u8YpFhQgPIEcWTNzIeIU5WFxACGRe7iuHJr0DaLP2InQzbFoTBiZ
	RK8kQ5kdd07JQ43ILL4MU5NBbfKaBpUd53axAJT7GLmefLidjl4L1LPoamoUCS7seTO8hJ
	rqRRVJjcdbHrBRAYIuRexc1o/61rGe4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DuUyw8yv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792983088;
	b=YOeSPLxOv3MRpbW/zLnb8Wu9Dd4Vd6782YQUMzof50e2ldO+ijFcJH2adhQX1bjA8hZaDu
	RbWhyJIBLJhBpuGNp8TkYn4YvvakkHe0kbZt6CkH/XfIQyfyArQ1/hFQIEwgYstQvxxAMO
	u6QqGGr++SQGh2E3mR7wKt0ddOAJUdA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLhPOmKK2pFh6taEYCBp8CK0feicZ7JlcI3SAcPjUiZ3hWjzOkdzEmaTzpOkyu3Sa7WcXcyRRKXzEZ3cYN51NKgsymmn/qjTpb5aqP3DDeNBsgjuYsjU4Yt7Jzi1+gjokSn5iz13yEIvbvhiKrGI7spiu94DVIAlmCDkbuKZ6CTSVgJHR27OvAE0XKD1Dg1IwPKijiBonbkIpVa1UObbPPHuiyFnVM4iLrPRo7O7OfNyzgSmJ31nXUIlgNSZG31fvJ+gNuxX3NOB4R3hgreUPn3GV34KVsFXr/RMPIOdQbStWIyOwStq7fcVIdFbebmoOY7wAJ6E5OVJAcK4eOh00g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6OsTiixpt5M1jc2jalslJkV4KaBfj1Z1QWDgxtaVRk=;
 b=UaD+feoDSRNARHxbxBhLVtsJGfHVc8NY2IMPFBHnx4h7RMMoJ7NDBdM1Zsx6q3o+pVn9lHMZdTWPYPltjlBh/2UJo45eRPeKG9TEGHVtxjLYJV/ynoCIaHNmpl2Wlp+0cgz232bwIxM79d09vlmhp1RT9FAXg0VzqO2EofkPrenfpT5EPGGXRApa3lTsA3934k9q2EiGifQeyT0lsku1IMpJdcCcjmr5qrZ+2cz1e+dCxQp08gnyk8YU3y3DTtJjPzShRUbTtTK5i/Um9D2tmvvJe1co0pQ32WkzQVG9bF9/fuxAuEZpZIad+wUqaAzseUSAq6yw3gWKweocc+nU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6OsTiixpt5M1jc2jalslJkV4KaBfj1Z1QWDgxtaVRk=;
 b=DuUyw8yv0+5if86sHxruuu4tlL5u4V8B3TR72BaNHQIPD3/ASZT/xdI6O4LKBHupqWqR4F+lymkWuMvEbC2ldmHqH51u64tTe8FNJGMuP2KrfghABjmZqe+3C8t1Ew7TmSLAem0ZOW7obwOwbhPfAH9ZPNtwkc9nEtHRp+i2dpI3ppvf0asKLAqW2CvnG2ey4gp5GxlygMh4XVSfn6yciEhXhC53NX+dxZsGMkCZHkswc1RCIi6trBugrYCgDp4W7EfAoEO5oecBGlNGFWFfRm2biiXld4USdD30M1EhlIfhvJiXcvkfY0G2hZ5FxMo+khhGOcn5d5Iz0F3bNUjvdg==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 02:51:21 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 02:51:21 +0000
Date: Mon, 26 Oct 2026 13:51:16 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, dave@stgolabs.net,
	roman.gushchin@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <at7AJCoQCLPjUv7Y@parvat>
References: <20261019185002.3428594-1-gourry@gourry.net>
 <b7aab691-ae63-498c-8d0c-1696592eea60@nvidia.com>
 <atbZyUYli9Ioy5O6@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atbZyUYli9Ioy5O6@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: MEWPR01CA0269.ausprd01.prod.outlook.com
 (2603:10c6:220:1ed::7) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DM6PR12MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d70899-23c5-4e52-ceab-08df330c041e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|261022105027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	xgcORFdlXCEyeKKspQE+Pxj2MZ8OjE1WwjyWfJP/2Tg1Fg1GEn5r+a4AmNUAwP7UV1BVKCbdAZgZLe57B3aWuKM3rlQep604d7neaOQUhU3zahv2YHCm933L/fcCkYD3WiyJFR9siL5aTfV9KFfMsAQOAeVA/qRSbtwsG1AhZju733I0vB1ydmZRM1Q0qSNeodgLRz7Px02Awx5/pDS0CaoY9Fc+871BupXKgjdjoUkCxqdrH3FS7ojnSrIzPqaDI8KbFKjzpHgXRrTJCgaBxfBcUTv4Q1aXh/cssQ4BJtLtiFlVOlx1e6Fh/hB8tfbzRhWy0rxsuyhTWLLw+3iZ2RoZMtVwIGb2sOZiE4awatYzp8XmpVvQMvEFHaWmne1vKvhnhU/bc6nbkT2FkfrV08wXvBOBVKF769ioq1hXe6jBxKvpO9upHeloXpkEQC2W13iq0yGLLzP3luuHGPk+83iqZgXB7WfenawiDn29jNqO2x4wUgtjduGzRAOV589aEQ4qPJPweRlSblR9/YyA8puZXxUV3QFR1zATflAvDPv983ThzoBt7OqGShW9UE4KY5SIywa9xz7uBQg3wl+e0Z7gnQgRqGKK031IY7Eka9UWxqPBiRxECp204MoFmJwP8II1pBsLtC2gI/fHRakrFIdgGcQuLgpN9FuCLd+V6UM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(261022105027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gv8wOjyvcmsYlIGzLYb9/MmEBHkzaxevBVQxDFVE6Gb/p6uysy+Y5vpIEOTj?=
 =?us-ascii?Q?LScn0EmyyBwmb76Zz7+q7ODIXLjN9eTDLyXZalolJak+JR6WmmOjMSUedwIW?=
 =?us-ascii?Q?49WUr980xh3YibgSeK8re4yi0BT/0UNRzTivwrA2lfeWtgLbeufJ+EgUJw/r?=
 =?us-ascii?Q?HqmJSEeMv1LazCGBni1ceKeqSzohf5gs6Q2iny8z0+O+4IsJwwsjXc38OkOx?=
 =?us-ascii?Q?ZRp3NuTbxGJAj9+VOi1qV7i1yjmenG01fydxOQjW8wHb/2R+8e5b57h1rjV6?=
 =?us-ascii?Q?O5oqq03s1iu55oahLSeNLur8GNxQnYNtkE4Mwzh1j4BHQaDYRQwVcVAtw6gV?=
 =?us-ascii?Q?H/JPx5mjNZyXuGNo/InAJ4L7Ywoh3qxDGj2ekjoLPJr+cTz1ocYSg+78yj4v?=
 =?us-ascii?Q?qEMnRnh30947smLDqSghNY2S3H/tjhL15oxVdQdvfZqm8xKIezVwJu2jgFW/?=
 =?us-ascii?Q?XRhgqTicsaLTaI0k22t286doSmNOSpM8nxt+Nth7vIW+v24iXwolWnrJdkXV?=
 =?us-ascii?Q?GrBRwnxLlV86kVmKc7HvwXvjCZGCdbLreMx0Miarr+nspaGQYKXwAzJuhC/A?=
 =?us-ascii?Q?ziafET382902TpZnZMG55ntZYS5FIYrcSreuF9jqvlsbLRBt7+35OU5uI2R+?=
 =?us-ascii?Q?GUAhH8/9BJy35Nta6txAKT5ygKkvewGuqqj+c3bbzMv5rg990jJkmflIPHDo?=
 =?us-ascii?Q?H7AWNYHxhWEqowlriweXfcA09YR6UxPtlwRzKhYftU8+j4AOT02tK6SPPAUg?=
 =?us-ascii?Q?TDPJOSfPWHGf7qvFSZqmyO/jpB84J+avzk/bp6Pps2/m0FmbS1Jqo6sfFLuf?=
 =?us-ascii?Q?Jp0GN+pIal7znVdH3rXdElWpAv/VZQp3mIMoheSVefBcVXN9Hs8xDjSp1/0a?=
 =?us-ascii?Q?YHXNsDzPu2ZSoymPg3dxCM3lJT2rw8sirGk0XAtMbDtRaws2Mfioc28h/sKd?=
 =?us-ascii?Q?K6voxTlprJk1E9M4VZ4f0n7kqC1hQ8FGCUFk1LeB57bWc63SaP4Llr5rpY4z?=
 =?us-ascii?Q?8Llm5tyNEjYozrPm5kI7ZBrDS+SePJuXlrKRjU2EA+vF0nL2fatPdhvLCSUr?=
 =?us-ascii?Q?+jwg2J0vddVSl8XTRboLWQ/QBp5HCgx/9sL52/1xU9UoeTHJrlr9L7KBo4Xc?=
 =?us-ascii?Q?HA4gF7psnAJo4LbCXwbQD1407d0M46ncW+SSaufNLH3SYlWotiMvHvHjbZq3?=
 =?us-ascii?Q?0hQQXIInfPJ+W1EsXw8o/XUnRpsWWAmAlMeCFedFECY9Ap9h1KNtzQUpPj9Y?=
 =?us-ascii?Q?9MNBJhvmfC5f+pQIRkTQ2r7PkzoDdHcMFEQr8AjZ78Cft6dS/ROlNaBlydHc?=
 =?us-ascii?Q?BGjnxQSZ3lrEmIM/7EqcKV02KJKUpVaqtJUYKbGBeVYtO6mshZfIKqklLX/k?=
 =?us-ascii?Q?C/4B81I0NCeCu5VmM3jkqItcRtYY77Iib+QRjY+4wOFnFWAO/7AaT+0ynStE?=
 =?us-ascii?Q?envcWY5spC1XgwaC9BG3jRv7uIqCy/c+WaCtrmpSZe7BJRozsCB/4ATIiCH5?=
 =?us-ascii?Q?q1/c4dbM4P5EJhGDpT+4nropSRtvE43Z/bg48h5UuNSyyZll8OdiGO9pMC02?=
 =?us-ascii?Q?NnZslnby33HV6bXGXCOQrKITc4+Nupc4ekIaZl4ehfCDBqOo3CAmEqVPgysc?=
 =?us-ascii?Q?7HLeKexfTTERBLK4cNEvACtdVV9OL1CnFUYN3tNOEKyng2gDJeOfwT6Te0e7?=
 =?us-ascii?Q?qxsIWn0gwhJXaaggD/3NupCQaz3qEwb+E0dmkoHqXTII7l7Bs/Dy9Fvxdwdl?=
 =?us-ascii?Q?iMb8g94RpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d70899-23c5-4e52-ceab-08df330c041e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 02:51:21.5647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJQMiPXki5ufOJ/+QQYlxSKDB4ARNumN6QoZOJfihiQHteO/v2PCpQEuMXIcHa0jjdgeSTTxjMMgB4PMEuKZEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
X-Rspamd-Queue-Id: 02AF240004
X-Stat-Signature: ffb646r5rxgz19pu3ntop98oa7683c6x
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792983087-331560
X-HE-Meta: U2FsdGVkX18qVWk6+vzn9Q5RVkmmPkGsO9Q4MlQpK/WIkSBPPikIbEdVyMvNvW10Or5mplrCLUiiAwtUNXOmOZk10edVYfNmN4f3GPPLd1230rBZzueTASRGMXPB2FQmUXNh4Tit21taWb7CFg6rDjp91EavezcLozZOYMvst21nQxXZ3fb2Of53WbFHjYRlho16Fv3GVIuqt27VEMgL2FwpEzzlmwqDQ6ru3oFIGcJ+c/qmyBvI/iWZFR2+Y+jA+kc1TQrNzDxlkVWsDb9eLj+UucB8v7mAYfIfv3wAjezr3Vi5abQCbQhWAuwfVTj9ahXbvw0ojeoQxFmaF62YIo59YvLvv21usPOxeUg1t56qHw3rxlsKpWiATOVSChw4haBBmpto6gPrImRxiKR/gZ09YDdyX1fWbuXNzhsK2nTfyzxwRtrcPt5duvShLN/YQOKLyu778Cj6GF8IgxpiHOxJq1CRon8rvLBKQ5pM/tO6P+fw735ojBT1+O+ECk3NQ7/ImtaGyTiT+3gcnpA6A2kaXp1S6svpAWDKlX/aE4EkGUT0ihchbzo0i/6RJ/JuFuN7otQ/3nkn4i1fqpIniLxwhgiO/+Z4H23T5UIbtddLwDqgDRk4Iwh5nZPR1dYcSBcpAoLM/NbsUT1L1fe93XDAd8j/27kFuzTvSUICphU8tRvwpZGujjbXZrv3Vkv0v/3VTVCszmJrZ2UVw7JqoxPJKlWMNiGzsPPz9ylBgyxg3klzhHcrJpx9GsGOStxX8VLGXLHRg+q6d0OokzWklpmagv0b4dqa1Cac8+qZswgp5zh7wL+nfHf66r8UzsPiscZTXw/J3sHTn7hprkKOpdH7+z02qubrbCyeR+3U+PUpYQdRE2wKUnMNCOHdEqAgkcLVgnqHwA9qpir7zla00/Fld/GOC3eIH3oBzGtXEOL8LWOWdRYGkhECAmWgTQQ2BdtgBIjwR4HEjtSECFK
 lk4XQiad
 ZAaDUePDpttQsFA4norke+bSep4yFGPhMh6wKiss10EopQ9gvsHxyQtcPPsk30AF/y+uqqU18LOWYx1tNn1ulxSAYzmowEDvoKe+H4rnaSfVBJHnZNbICXHXn7u8kbRXFgGPCjVhppfOWWGiys1bVeEFDks1VVu+kQZlNIUh9v23g3S7Rgtv9383ps0VMJDIInkAq45VfGUGKgnI/4RsSedinpKEAxTb0C1eAODaLjWQE+vbjYEsnCDWGIL6MzB8vx7asfnihK8Aqw5D+vOnm/uEvNbMkmaAGLuHXxWaK6d9gVOT6GSynSOrh5AIRCyAhRTVqQ0mFe+F1RPZTtEv0vae5aD9BUz6P+U6O4blVDi8hx4ylWsSxkMW/RMZHmm8KEBRto6d+cCub/Nst2FLi/zzrJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:04:12PM -0400, Gregory Price wrote:
> On Tue, Oct 20, 2026 at 12:49:37PM +1100, Balbir Singh wrote:
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index e82ba737c028d..90f7a7bf4e426 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
> > >  		} else {
> > >  			struct scan_control sc = {
> > >  				.gfp_mask = current_gfp_context(gfp_mask),
> > > -				.reclaim_idx = gfp_zone(gfp_mask),
> > > +				.reclaim_idx = MAX_NR_ZONES - 1,
> > >  				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
> > >  				.priority = DEF_PRIORITY,
> > >  				.may_writepage = 1,
> > 
> > 
> > I just noticed some other issues with this code, in terms of honouring
> > zone_reclaim_node (not related to this patch). I'll send out fixes, for
> > this patch.
> 
> I'm shocked, I tell you, shocked!
> 
> These are all things I accidentally ran into by just uh... using the
> interface.  I'm absolutely positive these interfaces are full of bugs.
>

:)

I was looking at making may_writepage and may_unmap align with the
constraints of node zone reclaim, .may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
and .may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP), which may
violate the contract for proactive reclaim. Proactive reclaim itself
tries to be compatible with cgroups reclaim interface, so it sets these
values to 1. I still feel it is a violation of default node reclaim
parameters, but not sure if it needs to be fixed up.

Balbir


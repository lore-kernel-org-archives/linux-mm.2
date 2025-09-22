Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9474CCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A068E0005; Sun, 21 Sep 2025 22:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71CC8E0001; Sun, 21 Sep 2025 22:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60A68E0005; Sun, 21 Sep 2025 22:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92D608E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:36:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC1C6C046A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:36:42 +0000 (UTC)
X-FDA: 83915323044.24.EC52A32
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 181DB18000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:36:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LMxL954M;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758508600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+o2WLpisjXCuKWaK6xhEk1hFN6SCrD4otNZT4TpP0M=;
	b=Cbs8YDUd0dzL/wnj8ixLEB+1rD/N0eW1K5fGYmAwhN4LgtX5/txJnacBdepuZNK6goY+e6
	soNXzW8jaElp6QIJR3Oj76bt1s6fsS8ZF5DrHrSPvkhl5txnBa1UpEsLaV6GYR2W8ovDnJ
	kZBURlBlPS2JDJoDT/Ps20Lq7Xwl4jE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LMxL954M;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758508600; a=rsa-sha256;
	cv=pass;
	b=MFTMzmQ+ysl4NQWrGvsOshuDF7E+qXdlLknKG4baHYN/3gBzgxy2zng4d5CKh1WAo0d8W7
	odIjJ5GB55cs2J2FAov4uJmlBB1E4Af8dZxZ6GwzQvJlgK2Say1Pz8P6yDHoTCPtJDLPdT
	U63Uh07o5R/F4YMeBxAVjSumiMZWJKs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOGfDF8vmSToeWl5sZtzy+DGShwYfQcPBHY72lAWVT2YyVlcXGUGKepWtemwysAxqGPcArl8MA8N9IrAD9LW6zJsMUxGVIL4+POMjo5nymulTgKlKDqWMOWI9joij2CbFX+5FiX34oUOc/5LjLoQ9+k2Lj48CSX5W7RauILVuAaPsjppWn1JHFojSVg71eDtY8IKNbXLPC9z/Qho4IRF7v8cW28z+EjwqaxVPuJIkXR8ydLK/GAGMR5PLoNx0Na/43oz57scQMTddYLkjPSpAJDMCbOXUt5R0OrAV16ZiqAsPN5hQDY54jMGiLweAFiTKBIDAAvNIHDnBpny7MR31A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+o2WLpisjXCuKWaK6xhEk1hFN6SCrD4otNZT4TpP0M=;
 b=KqPCXS3j9EDfqgZH/lg5MXVlEIbTUPbRv7EF/DOqqqaESnpBo3oipaGRxE+0fHk8Xb5QkgpQeLfOZLhnR5ys7/CxWB3JODQvXtUbbKrTv4KM9nqt/es6gz65Wk0f/bBMw1EBcylSP1WLhqUeyIQBA+L5HOeBuNNDDZQz5jDhbGOwLpZ518C3l8gKfS19vebhUbuVzv76T7O6hHK8YToTDT0NMTJct8h0iIFMwu0VhweeK3myhiflBSt2z/u5XpdQZwE9AzvC1m8l007C9LdAeM939w2PugGEnqjAzXkJfduY3IErMY4ouCGw1Qi8z1E5lR7IWE28TzzynumE5gzhLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+o2WLpisjXCuKWaK6xhEk1hFN6SCrD4otNZT4TpP0M=;
 b=LMxL954MXtCrOz/qX9rdSYEkVlQiuMZ1TNAbPI+NORGoCG+wESJvmaJydYOeLNg8lVbT6B7L4bClE+TxElgPvi9bz4AwJ6OW/w9tKgCEYN8ahlc+ccVfwWD6JvOAqBjAx28/4UslJjL8FajhwTnWklDIQnXTycVxH89SGVJHo/ad3fI46SbSTyt1qwEzPx4wN2fm6sHb1hEt6Tb2rsupLgNiOkoMsrd1cz678uoo0+VOcznrFAyEEGm/gblqnyZn4NG2AaSnpYFQiLG29tx7frszNi48z17gj6xk/adBFHfY2TnATtyqlVTCTOwiyfmV0U4XV/ErYE45Iux8+R2Jzg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF64A94D5DF.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 02:36:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 02:36:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
 catalin.marinas@arm.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Date: Sun, 21 Sep 2025 22:36:31 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3DD2EF5E-3E6A-40B0-AFCC-8FB38F0763DB@nvidia.com>
In-Reply-To: <20250922021458.68123-1-lance.yang@linux.dev>
References: <20250922021458.68123-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:408:f8::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF64A94D5DF:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3cfde4-1ff8-4437-9df5-08ddf980d8fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p0KjRGSrLNvVp1i3RJ9FTvfSF6r5ZYBTky2TfBUoTPycbsrZKNN70lyM007E?=
 =?us-ascii?Q?cJPkydl6xnzidx8ahaNMH59flsj52x4hTB8I0K7XhEnbxmMocyEkd+mBbYPm?=
 =?us-ascii?Q?QzvYCQbM5BF92q7tTxyVGT3po9nABYpkj46ryGu3tTwxxAwPnlSxt6z0MMTC?=
 =?us-ascii?Q?YwfRddtaA33gQKKVhjIzrulUOLzJ4f8K0gXI912z/SSm5+neiksB77r5fFe8?=
 =?us-ascii?Q?B+ZmNY0dN0aVjOZ22OFeJYv8TOlAz9B5q3aXELQLYqgeTk4OnJxZlqkDlbeK?=
 =?us-ascii?Q?Q7QUM0JidFaS6oAuNxrsP238P03lDqFM20NeMBokAoGOJICKojorUREgoCf8?=
 =?us-ascii?Q?fJDtW6nza+K+1ltEccENvxWUfupI29moNQzFFQp0JFfqkDuLWrGU160UAji2?=
 =?us-ascii?Q?Ceg1zEUeKDpjuuDdLdYlb3t0NVJN70BmsgbhnToiFtC1juIasqNL6o3lfcqZ?=
 =?us-ascii?Q?EQStuVNq+X6I0TnmegVBglmkpQvLFTQp5cw8dPss3+aN/OUukVJ9WSRv0ffY?=
 =?us-ascii?Q?aR6aJivM6YAEn91QKpB591XRQVObdRFMUSy6ZmNzsJFVux5tG19Zyqb5IiJq?=
 =?us-ascii?Q?zMMFc4X0iW8PN/k/SRUF2ltS4XP0pvmK651k78dnfKhfNudPeTn8t0BxUJzl?=
 =?us-ascii?Q?3rMz9YKc7mtOssi9vr8dDkQb/wCx6FvdziM5XDcWsq/sEA/rqyn2naWQKa0Z?=
 =?us-ascii?Q?0uC1/uTeLlvnlm6FanBGOh+wmzDgMljJNSMh3tgD44InGtsIMgQoJPYXQqiM?=
 =?us-ascii?Q?iv96fFwas9kNGZfAMa7x2kIksp/GVpwSd2+oGNiHTNKTwPe/fMqZ8kSwFhvq?=
 =?us-ascii?Q?Emk1B9ZspEsf0Vbm6lo2XSo92kvOkI/KesV+g2eoqlSqGlFdDGZJ64ruPGZT?=
 =?us-ascii?Q?nCz28q2FPdgCxi0UwyUcaSDRlE+CSxVUPhf1ahlbNe16V2LwYdbHjw0rU6Az?=
 =?us-ascii?Q?qsqj03likoFhGftD6TgcweKdqcQmfV9E8CA3cO0SC2rVJiz36H0WDBuuIvIm?=
 =?us-ascii?Q?esDeL+ryv4WsIO0Kwr2Tsy3QDPlc8mcVqGxgPS23xqr/Y4IvO8qEW+3CSpEM?=
 =?us-ascii?Q?tCO3mXof7O37LVuHQiLURoPeiaXdzsPBEWvSm8KVYDluacRirS7GltL9wsl5?=
 =?us-ascii?Q?PSK4c83R/8P1bJTcDHFbZpjBmUksMA4o6+k7L2QcxcnJg+JPSigjyr2PzAgf?=
 =?us-ascii?Q?9MQvF7j4vm6dCezA1Nmn4bFqonmEYyyjWWJpNt7PKzBmDjv6hyFW97DmskIm?=
 =?us-ascii?Q?vRId4D4sECUMf70b9V41yEBKjIrBYMMCxWChfyngmZPe9G6oP2UZFxToholt?=
 =?us-ascii?Q?AJPUk/P9jfaub2z1Iw3ydgpAJFTtzqSpkMMPNm4qDyveD45EAqW5CdWXstOv?=
 =?us-ascii?Q?t3rWI95FnWfUcCtOZLidIGq0sKksNOfyo16DFL94pT50+/OOmpfzYLi+xpQc?=
 =?us-ascii?Q?wwgSFuxiVuEgNKkOwxRSbLke3Ce6LlpG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h06pb4gdtSPKPV3NuNG/AZ3EjsaT8yFfczPs45kcvs+0Y/cR7oqpYdNlrQAe?=
 =?us-ascii?Q?yfJXidMHRYNwAk4GhT5pfYxHo3rmApIJa/CtGn9GviH4RzyPx4iz7vm2bYmP?=
 =?us-ascii?Q?RQ1vUW3c8M3qr6KWV12exNq4KZDpR8bBO2Q/BY124G1eA60vh0lltCoDJ4Hd?=
 =?us-ascii?Q?AjIjn20HQDdhgxqLUFPQmnNuT7WIBzIUTo/g1fECuI7OxgywBe/Id/NsIxC3?=
 =?us-ascii?Q?tixwhZslocl0I7U/uARcqNZRJqtxK1qKCDTXoNBR2xQExbHntb2fYXkt8x1q?=
 =?us-ascii?Q?4y/GCh6r5/OCEwlN6mUkegYyeZ8TGLLTFDlhFVp4xwtMpl6E3XpE68LJt+xf?=
 =?us-ascii?Q?XC6rjd6aDwMBvoQPEpaUKzeAE8NFcfVTo7NwaDH23w95QyNbAH4skjXKYNfC?=
 =?us-ascii?Q?DJsBXe69rcwV2CaLEvGJSrYZL4bZKDuCUQn4Q0ppDKTiWuYXlgwIOuxOnkrV?=
 =?us-ascii?Q?lY1dZk1PUVVjbCAA0TsnvsNz0vibcTFIxEqk1XoQsjYlu4XCaScZOiYQl6jH?=
 =?us-ascii?Q?tfGgZQu5tS3em7EuB80wlAnNRg1Oqd9bA9XqXVcgGytZtTODY+cZLd3duACB?=
 =?us-ascii?Q?oYHaRt8Qf1mJSZSehIbQUfO3TFigcEouyDKlPn/tRgKgym60VH5Xvx3PbwkW?=
 =?us-ascii?Q?OHy/v/7eKtVV47shTGm+SU8EKt9Ay/30nsOjKNLZhN8AYOehiVNjFlcxjoaA?=
 =?us-ascii?Q?t3iNKJD+e+6FOwqXSsE0F/ksbpsuIDAPlptuN4VJCmu0bn0gh3jqvc7zlP90?=
 =?us-ascii?Q?aK1NGyL4M13t3g259/Du0Uxt1rHMjXwt94fCagRoH6AxsQ8z+iv466AQaI24?=
 =?us-ascii?Q?ji8pbn3XDEucXD3sJ2bwz4KRketO1+OGq0XYqIkYGFlRJtnWNlTzJ7uc9IUa?=
 =?us-ascii?Q?Qk2PWmqLHLmmswv93hNmek/NB7oEPmj0oZ2wdpdRkcvA6f9ZRI8hZttc9Qb2?=
 =?us-ascii?Q?nDesRGSqffXoy4ZsEBCaOnh9UoxV0EQt7+tcQTpbu7/E6kTcxIeI/G4xS+2x?=
 =?us-ascii?Q?+/RA5lcSpWbgr6YVGGCPU2JNg0JWqGmU+i85EyWbstayvH3EwZn0xk7g3CIe?=
 =?us-ascii?Q?DeOR5Ie8RWK5jk1akz37xJs5Iu9bNIMF+1RPD4LIRd2MBy9DSovjD+8ivuvB?=
 =?us-ascii?Q?fXLDIavgyyBSAAVp9WE6PxQIJQLKFHhT3uqoFx2o96S55UHZRfWX9xwAWZRo?=
 =?us-ascii?Q?rRhxJdOEbdVzmp6XOwyPoo6rp5P7hnK5FtIbcIua2iw7oCVGF11aknPwU3IL?=
 =?us-ascii?Q?WRAsT3rPM1L4uVPUeE5OMO6sx9F/OjmCAni8+5cxT01xVokN/T28DDoq1OVd?=
 =?us-ascii?Q?pL2nlC8jGNo4/wfyZ6RZguIn9VbPU53Iiok28+/l97ufYzIOyH7WDIkyEOIZ?=
 =?us-ascii?Q?FPSodgjIxO7IzRCT590W8Y9gygZQRgP2FtUPjy/U9mxz3Q0psC1ypxEkbnY+?=
 =?us-ascii?Q?7wtml2WViJRb1V1u+Xv/tTJCIb+HfGHhfRSN1W2MBjr3wyOOUkgnp/95ZuUf?=
 =?us-ascii?Q?rnRGU7suPt6C8oBlz0e/1hxxYI7sAu8YM9ot8hXVNxIzl5nGLznV+1cEEC87?=
 =?us-ascii?Q?5jvkgr5Z4UwDLEZM0YY0xMmi3k2fp0vUuHOUnoNG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3cfde4-1ff8-4437-9df5-08ddf980d8fa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 02:36:34.9419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Fun+khF8E0k7+HGMzSGMHyD0+UuW7xmlMp5sxHpsVmRy+/7gc5cQsjWgL6Vnth7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF64A94D5DF
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 181DB18000B
X-Stat-Signature: btc4iuy9u4hgx7yg6ytcx54qgureqbo7
X-HE-Tag: 1758508599-504779
X-HE-Meta: U2FsdGVkX18A4qkIjpGvCbouD97UhGYCKddFVeQqEhBoG1WLyyozQrTa1DW8ZqsSPWqEAkhKeuX5RBmcZP47h68SVdm0rgEaa54C1PqdUCpPcaS6ihT8Ju286+odcmJgeIzKuFRv1ML0kKxFVdOXmm8eUbdVe/yEUKe6BKQs530+4Ql/KLQcK9NnijHUzXMEpMYYJHJQK42/URW4oGNPJgttQ1nz6EC4WSNx2q7aXrDYH516ILPArIYNU6UIFZ6bSlatyYSZGDFEBv5MuobdgE30y998KCPKJnMhu0c8fMzD29lmBNzfqTGL7B4kG1IUMKLnjqRtEyr1D4NbF/aDWfCWv/WuP82VfbaHhnU/9D8+LIvXFIlgX2nHfJ/WF4Hrvad0pC3ORRbIHE65QuxX8XldFveLt3zZ1GvqKf1yK/01TpRzZuIFDGbqYcYJkayr9EgY0Khdx37UoiZzeVlU/NYHa+MsJxPPbh0Y8F4uyP878oDvlzV5+GDL7Yjge0+kmXaC+eXngyR/XlfTphlDqxfKQRe2iA26Ovmh05o/Pqp/Dsc0iancLV3iXVyKpiMipiYKkJa5Xoo4lYVKUrGeBdS9scNwvoowNQ/3rdYgImnWD7RDLziiaMNp8e7cspjEvlDzfz+rab7kdoh67hWlrfQumnQx8fFoLSopYxT2PgqDTehADb/MF91rUnTdnF3ByJFjmg9jc/piKEc6ch3YNOVVy5pQ9EyxLkiaHHj1b/RchJqbJQaZnPINXkyBCCOAyBZSL5J5YJOyqqa8ekJNqCt6qyLWaTaBUT/BaFPxBD8hgz/s0B1ADJWyS/l16zRc43+1elTi45clr+5iul45ESx+Z3YtEUy9QSIxd0ri58Q/2dlEqP1TSuxhBf+zuhSWpjBX083guxIyHxn8qgL7RcDfnQufOyuN+1E33HCoDKg/fpiPgZrxxbQQ+/NUQoIDghYWMBdFphbExudJD5o
 EGeR0UUQ
 KNyC5IPxv3Zre8Xu+HswVIHIE0rNX8N37hfqH3OVwdnENbLK5tyPoD7sFEFreg1lDaneGI1Q9uDm6IApfILPZFd9jFbT6DRF9rDaqVhT7tazfdlF/Nj3DZpO79yThNsCeG65IkAxVuj8+6cWjLDEOumpCAHW3jYTzR6AQDHpmlV7kH5MUZVb+jJlrinKQ7CPFA3Pxc7Oqyhq2StdPaX69QnsHz80OfeUkuCEFTUJJS+mH3/yPAEN8BJ8T00KlFI4fuuiQbJHNfCVNd32cbzlRxsQYSh5VmWBmgsD4ZztQL/TNT8IKJcLIITQP4TkbacI30Tcc7EpGtw15AOuw6FaHGbRQPCm53fBNoM7f5RebisGzY8eJNpq4isOcmlOP1vNHxwFCcCcY87itRROkONoY0iTSEKmzc6VbeodVyKqmtB12QRPKcIHUShkEoZLxwN5fYE8z/aImg0964Y107LZbPprQwVG8eW/pNUSGJZ5KE+TxebMaTVMD7kL5gTaOwPCLlWUyzS626uL847+c1zE4I+pmB3lKIv41GNr8iP2d7yd4hMUMh05WjY/aYLBfSQoqwqSxZco9u8wGuSfxGXEOSjzJrl8/GlWMUKD4260Y+216/MQX9/rM0VV4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Sep 2025, at 22:14, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> When both THP and MTE are enabled, splitting a THP and replacing its
> zero-filled subpages with the shared zeropage can cause MTE tag mismatc=
h
> faults in userspace.
>
> Remapping zero-filled subpages to the shared zeropage is unsafe, as the=

> zeropage has a fixed tag of zero, which may not match the tag expected =
by
> the userspace pointer.
>
> KSM already avoids this problem by using memcmp_pages(), which on arm64=

> intentionally reports MTE-tagged pages as non-identical to prevent unsa=
fe
> merging.
>
> As suggested by David[1], this patch adopts the same pattern, replacing=
 the
> memchr_inv() byte-level check with a call to pages_identical(). This
> leverages existing architecture-specific logic to determine if a page i=
s
> truly identical to the shared zeropage.
>
> Having both the THP shrinker and KSM rely on pages_identical() makes th=
e
> design more future-proof, IMO. Instead of handling quirks in generic co=
de,
> we just let the architecture decide what makes two pages identical.
>
> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@re=
dhat.com
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a=
3f8d4.camel@mediatek.com
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when=
 splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Tested on x86_64 and on QEMU for arm64 (with and without MTE support),
> and the fix works as expected.

=46rom [1], I see you mentioned RISC-V also has the address masking featu=
re.
Is it affected by this? And memcmp_pages() is only implemented by ARM64
for MTE. Should any arch with address masking always implement it to avoi=
d
the same issue?

>
>  mm/huge_memory.c | 15 +++------------
>  mm/migrate.c     |  8 +-------
>  2 files changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 32e0ec2dde36..28d4b02a1aa5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struc=
t shrinker *shrink,
>  static bool thp_underused(struct folio *folio)
>  {
>  	int num_zero_pages =3D 0, num_filled_pages =3D 0;
> -	void *kaddr;
>  	int i;
>
>  	for (i =3D 0; i < folio_nr_pages(folio); i++) {
> -		kaddr =3D kmap_local_folio(folio, i * PAGE_SIZE);
> -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> -			num_zero_pages++;
> -			if (num_zero_pages > khugepaged_max_ptes_none) {
> -				kunmap_local(kaddr);
> +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> +			if (++num_zero_pages > khugepaged_max_ptes_none)
>  				return true;
> -			}
>  		} else {
>  			/*
>  			 * Another path for early exit once the number
>  			 * of non-zero filled pages exceeds threshold.
>  			 */
> -			num_filled_pages++;
> -			if (num_filled_pages >=3D HPAGE_PMD_NR - khugepaged_max_ptes_none) =
{
> -				kunmap_local(kaddr);
> +			if (++num_filled_pages >=3D HPAGE_PMD_NR - khugepaged_max_ptes_none=
)
>  				return false;
> -			}
>  		}
> -		kunmap_local(kaddr);
>  	}
>  	return false;
>  }
> diff --git a/mm/migrate.c b/mm/migrate.c
> index aee61a980374..ce83c2c3c287 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -300,9 +300,7 @@ static bool try_to_map_unused_to_zeropage(struct pa=
ge_vma_mapped_walk *pvmw,
>  					  unsigned long idx)
>  {
>  	struct page *page =3D folio_page(folio, idx);
> -	bool contains_data;
>  	pte_t newpte;
> -	void *addr;
>
>  	if (PageCompound(page))
>  		return false;
> @@ -319,11 +317,7 @@ static bool try_to_map_unused_to_zeropage(struct p=
age_vma_mapped_walk *pvmw,
>  	 * this subpage has been non present. If the subpage is only zero-fil=
led
>  	 * then map it to the shared zeropage.
>  	 */
> -	addr =3D kmap_local_page(page);
> -	contains_data =3D memchr_inv(addr, 0, PAGE_SIZE);
> -	kunmap_local(addr);
> -
> -	if (contains_data)
> +	if (!pages_identical(page, ZERO_PAGE(0)))
>  		return false;
>
>  	newpte =3D pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
> -- =

> 2.49.0

The changes look good to me. Thanks. Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi


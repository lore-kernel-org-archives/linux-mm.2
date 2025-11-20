Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93939CF8860
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E769D6B000A; Thu, 20 Nov 2025 09:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26936B0010; Thu, 20 Nov 2025 09:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE116B0011; Thu, 20 Nov 2025 09:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA76A6B000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:48:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5389D140130
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:48:41 +0000 (UTC)
X-FDA: 84131266842.05.56FCE06
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57BD74000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:48:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i4XwSI38;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i84K+fJQoD6pxUPLvSInUels6OsWt/9cIVeOYMkQcHU=;
	b=SnPIotvYeKnQm087xOlOBPirMD4qmvfdp/3HV59gy+KBzt/qZNfsrT67I8TyBsMQ1l27Fq
	BKWOMjKSm8xUVOFMiUSHk+Yu2qlb2Piga2HQHUs1sNswHiiTcWVo347weho3+LKd6HVYlp
	MKTRzpc5RfDDeIJqsMZS7ZUzIGG0QLY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i4XwSI38;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763650118; a=rsa-sha256;
	cv=pass;
	b=r4SwR8DDEyaqjcoMgV+uaAzPWx7GuZDNMBHp9joe7W80Xg6UTUYeiUAIh33kLxF9gEtYnR
	2DfRFIOIQuflLHXiiNT68+G3j3WcmX7xpjJjigR7AzGhLKDTBGEwgoOoqK2zNNXLkzJxnT
	VUNn9eOup1Ka49UnrhzAkQ0oeHIiT8Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVhZaziUlfzDTdukbr/nS1pXgHQvy3ALIUpWhKJc24PvMApHEZPOJdwevN7Q9+/Scf/by85FUaSD4aC7QwPEF/sxhMUqU8Tiwy2HQvpmjNOhlflOzsOmrs+oGwfQ+q5WOIq+fuXWgG8iLHTsEYZwLo33Z5QCRchW7U1Mc0nHzfwp+9penlkVO+vVPRMC0PORm1mxwXf8f5/YMAjpS2MdIggVyT+aO+tyBiliGIc8Edk2XXnoWgD4arhlgvqqmmU3Nu/SMjiDikH0wDjf42hwAL+cF0pDqQwyYT6Rw4rTxSOfdV+0ypppQ/4Cf/mHWs3rIZcuAX1VPZgsSQLNNPix/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i84K+fJQoD6pxUPLvSInUels6OsWt/9cIVeOYMkQcHU=;
 b=jf94ZOkyuOAnKlin0au5J/ujN/iwC7cJwF2yV6fcEp1wlxhfvd1VtIh7NEmdiBhd95oc1bqs+KbRXKtxoHQNLGYt/rBFA0qS5hJIjh+n1q/u2NG6JZNHGVYWRxL797ybjTA6rtMOEGphOp6YH5Ykgk0xSt0U9Vx/8Ke0wzLVn0DRUe8uFzNviwudngs56xTuisI2WkGKIoIAX3v8RynqvUWyqmvul9WYVDpZcpS8+qLVOuV3rE0hPaji4McJm9alSbAY4m3H7mipAkWfFOYN6bdwQgY2cAcmn3qu4D1QwY26D0rxHxPyInCSg52zkjM8jQJV6nUhf2UTypCFapbcaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i84K+fJQoD6pxUPLvSInUels6OsWt/9cIVeOYMkQcHU=;
 b=i4XwSI38IX2y9xcbuptP8XtqIkII7ZT7jfRDqc0sGjj7C5sCg0RZ+2r1G7sxay/fVrF3xKKmNcUSbEixuOwN4aAFKbBEaQ2BgWHmA7/94Wa50prZ79kzaCy7BNmt3OvJ9nt86sA7YKrPtJytQruspLZBJL3WP5X7glDmv/fxMQF2B9MlbuCluydcC5XxA+BqN798/2YoQKHQBvAkVl1iWUGg+l1akuRnQ5Qx0xS2cmMxWs3yo9YDk1tbBVeNFH+dl3SOVERW9IfhBZODEHdbO3ZPJYU/qg1ny0TPe3sBhpQzzFcLl9prkD9TQmm5EoMLzrUFb1HQ+4/k61vmZ9Ylxg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB9131.namprd12.prod.outlook.com (2603:10b6:806:395::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 14:48:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 14:48:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for
 folio_split_supported()
Date: Thu, 20 Nov 2025 09:48:31 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9D88B1A6-1D00-4770-9B66-A9A0F1B6AC15@nvidia.com>
In-Reply-To: <b051bc10-cf68-4e1b-847d-a1323552b963@kernel.org>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-3-ziy@nvidia.com>
 <b051bc10-cf68-4e1b-847d-a1323552b963@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0326.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB9131:EE_
X-MS-Office365-Filtering-Correlation-Id: 142f2584-9005-4a91-1627-08de2843e0f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HAD43iEED9uW3jOrMJwYCtFhGw2+oLf8vHXXa6+j0Q2e+A4sXgtcRbEXnEnj?=
 =?us-ascii?Q?njP+CRpSqMG5GqPMUIJTJjKq0GUgIE7MPRVqxZg8xCQFfAyUdUroPMWpk+lr?=
 =?us-ascii?Q?anQs5L1dRlKyVHjEZ/snh/Gwz4+C74NdX80bNr2+tVNdKeKtcX5x9BbNyEDN?=
 =?us-ascii?Q?kE3VFs+hq6tNDu8heyPHKmqmjEfmwVJkHReHnttJ6RTWSVowng8/7TNfubAq?=
 =?us-ascii?Q?G5fQQ4MGrlESLqOOdJE03/wZAwwayTSW/uWnIuVoZvHmfPiZ2ESp+xxxc7R8?=
 =?us-ascii?Q?eIl+gv6TSpO6Sf/7ZqaS917Rk1xgNHuovHp6C+UzDUjk2y2fqidBtkcNBOD2?=
 =?us-ascii?Q?2c36lUcGt7ePRO9u9pMwmJdsRvPG1hMhfO5PUBylYWdTkQDxKh3yH6zwvR7v?=
 =?us-ascii?Q?0V+mGlxFGgdGfIrnHv1+LmAfDZ27O06y/Ytz623tIWeMoI7hjIoCJ3eiP6Rg?=
 =?us-ascii?Q?NabdUDq4q/EldH3l1jfwv5FdV8qQt9IQ/Hw0pPxLVvd5ix7nPX6D71cznGz7?=
 =?us-ascii?Q?YDjp/rEgVEInX9CPHm2iCFQZxkykf5j4WNZY2yaI2Y3dKMTf7dNNJmSvmixm?=
 =?us-ascii?Q?c7xzK097UyTdO0XF/jNo8mK8r/WKSLBN8V+AYmx3T831xVZkLTGXgxm9wcpZ?=
 =?us-ascii?Q?O0fSzxJ2Te3to7ltzJxbswkMpCJ22ozbFrBAEMSN1DmYDNgIJxkBj2XqCZZz?=
 =?us-ascii?Q?LCUwfNQFTuAoR4LKF+j6P4GK93R+SwUV2xFgnsjcYh0FAATgGt5aonbGbiGR?=
 =?us-ascii?Q?1QZCj3apCMPdHSll9o+GP3Sgf5og5s0IG0+MfYwjOCKSLq72dvTTDrK/K6W7?=
 =?us-ascii?Q?XkOSNYxpKd2oMBJbG0LZ7po6YP8cfCAaFa71XIWj8GN/neOJsG/hYIwbwano?=
 =?us-ascii?Q?a85CPXSyFsKGFyob+4Z65oUxoBzIv+U11gMNEVgR1hPKlt6MQt9W1F90z9+c?=
 =?us-ascii?Q?nV2hVqG3LycxC9E0z9XloZ4tWhwRR2D2XpLzPLpleIc2rkgs2wyqpC9jwHnf?=
 =?us-ascii?Q?8JAlT1jq7OrAhHBx5h9tz4VHczViSLr+DNZJq1xOcvPCmsfWae6t7j9kNwKE?=
 =?us-ascii?Q?JIaX3sjYF2EkeLMmQuzTzhHDFu1rQtgU7ygrBJNu4lteAsfwTNPUkj52t1MY?=
 =?us-ascii?Q?Tg8SNN82TRd93S4zpyRrVeoPSpMwHqAVXerCL5TcNlL5c/MOlwEoA/rqRJNU?=
 =?us-ascii?Q?f+txOA+KywQ4QgDEO/5iol/fDi30jgpZvvrbhbo9pLspeRYnB/UBMTZOTAij?=
 =?us-ascii?Q?eGXYU+2sQ4LX7OatDakz0FgB4Zxh0VIfEusXp7Oi2Gtaf6aXml4cgAMKLS8o?=
 =?us-ascii?Q?ntzPBBQN3mIxsh1XafVNr9KFAKkQ91/C/bO8gliJkvzrYA8ROcmQt3UGEjWp?=
 =?us-ascii?Q?EQq7MO6IwcIM+VDTj8NhqaanQsbF0IEM8O7H67RNGh+hDkwS/ks2/XRdlV1d?=
 =?us-ascii?Q?1NsKiXEBUsVMIca0/ZubD3xakUF5BW2h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C/NYdJu4+OioIt0NivcQK8+GQ/K76HqM29tTTgH8e4AC0k2K+9FM8iY0EmSp?=
 =?us-ascii?Q?+cxxM71GPRHlKNHCJT0YlQGYWIiQGyEmOlP24wbO26wADcQu9yQTDVUxunHl?=
 =?us-ascii?Q?85uPYPFbnl26V0d7pQssvXoaAF5fTmgVzPX31Sw53QN0x8/0Ag/M+P0UXoHR?=
 =?us-ascii?Q?pVR8N20o1iVXPqwpPbV1uvxtf5uRnQKGu8uXL4cYIc5bIBUWkYk/JIoYRAuR?=
 =?us-ascii?Q?t2e4KL/N866Y4W+46nBRll/KwlqQ38aIQP+IQvHbUeTuEyUW5uwG6aY3zxRY?=
 =?us-ascii?Q?+hXNlhmqxs0V70A2kARIATmKgiw9N/9Ry1Maof/CEZRPsLRBbIh2LQ7e9blO?=
 =?us-ascii?Q?IaSapkbma1lBbt47kgLZ6JhovwB2xRodUyY6LSvgu4BEA/otddw8eP3keat8?=
 =?us-ascii?Q?KDPinSFoHHIb7M01gBV5bAw+UyPpWDHWfKMtJFrcKrtFhNIuRWytIGUGG2wV?=
 =?us-ascii?Q?GdsypZfuve5uAYYD5yEutGvInE7QaA2LJd3ZCp+2tmj812Z9NRfGAUSYOjPP?=
 =?us-ascii?Q?JxPpj1p8kGw0E7ibfhMwbgVlGicePJ8yLcArJFsgTyjkGGCkc/r63gdN4ZCa?=
 =?us-ascii?Q?rsrY1Mu2SNll5kkq+8BQEo1avceHZUuTyOvGKhXrQhbwfhpqfBR0d6kgfgPg?=
 =?us-ascii?Q?XvSPOi2hoJnfPCwOR+UZLoJ+ls1B8b92KE1cu1j8ASKk3O912gMQnMDi5apv?=
 =?us-ascii?Q?qxDRBXi5kChpEx61E4wIIpouNJvpzu20qNA9TcR0Ce0xHevorj6wqHiTDKRz?=
 =?us-ascii?Q?/Ub2/Jf8kLazKJotJUUiCVDgHeDo/qb7Lz6PItZGwZdMnCr4sbHWk0v+yKOG?=
 =?us-ascii?Q?dXREoObWO7EfzhL9PX3x/9FnydW+3SLts6rvbceWvWAQTlq57UJ7qPiibcYP?=
 =?us-ascii?Q?f9P+spvtSax+sjtIs9OPfHcSUWyE0dHHO5L/ML/b98QyUmKaQwwFTXrOWLDm?=
 =?us-ascii?Q?Mkb6jP4hZELPQQVfhs0ej3DU7sJUvFDIA0az+DCiMwS24BxTtT469wr4+FFo?=
 =?us-ascii?Q?/22oaifPYtcdo/fcPAMVJH8pVUjXU8vP9h2Qo23yM8sknnSsDEIthuK6jx55?=
 =?us-ascii?Q?W9iO2zlf2Jf1hNI1wCVsLetoAbevNYtJNhkSFkvb0f4zlKNu8qbFSte47jB7?=
 =?us-ascii?Q?AQSIsghnubNPTjF5XzQMYAHYbEqECr2rncYGrWuPmm0fhtcSNWewh7HAz/+W?=
 =?us-ascii?Q?i048d90YwQ+fz1a7DEL83bY0I2ELc4AeDAkrIB4KX7Uw87YSPXrTY6QmoaUD?=
 =?us-ascii?Q?suTFhBVF0MUOF2vQx4a54O4CDHB+S+ktu4B/3LEXouUxksVzrwJFf/L1diJn?=
 =?us-ascii?Q?lLnYLKK8ergSr3RgTHPVjRA+J+KGFmR4sZLEIdiz1s8ztpTSP9v3JCZti0ay?=
 =?us-ascii?Q?C1ewn/wqioPoW7TO8xs5HEYsLvjfeQmuQgE6Qy6F16djKeGqBH5gzE/xAZ5G?=
 =?us-ascii?Q?VAmePjz7v5ZwI487y96OjhkkzXkI/eOFV86CH88krSWIUg1hwhv9QVK2JNuW?=
 =?us-ascii?Q?NoseJSUcQi/NJAls9IDDUR/W6dx0D6+n8+re0MfBUqYeU4npW7Eov71LJNxJ?=
 =?us-ascii?Q?OyEcH/0TyXF2k3LXeSk3NG+K6ZglBOzGQdbCGHy6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142f2584-9005-4a91-1627-08de2843e0f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 14:48:33.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjDVlSAB+jaBxJiiR0mOkxyXmTv4AN3BL/10puC2rbinCej7EeitqiTbTkZJwLXA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9131
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57BD74000F
X-Stat-Signature: ie4fjspw7cd6uupbyepjdmu8otuzg66d
X-Rspam-User: 
X-HE-Tag: 1763650118-820071
X-HE-Meta: U2FsdGVkX19tboel5XJkieYrLm0y2ggkP/SPEV5oMI9SyPzVmtIFrH/kRG/mPoDPOqoU/wc8zyAW6boNSkRA99RQdKekMlqq2lB+0Of/oW6jOjWnPKlT1ZeiNkVZYeLYcYN5seX2p2hpYAj5IwIpmD6h/lxYc4/4QoPiFICkqc47rTirIqz+aOtliN157GmVMyjHiwHltNdgwiYN73pJockwaMsBRPhVhvDF22oL4s369/L7Mf0hcGb+/GrqaaqvMlC0YpXVkB2Q+EYNfHgMsmTzZe5NDvgRfN4NFhrfi1nrIjcgi+5oAZfaTLv8xOAvVl8MY9ZZHegjLh/NhNU4S8rWcKcgPP56vifwTNZVsCEXfGB9XysM07h6qaVLqPfXqlmPjP2B92/rRMp/uBvgH7v9fT0QF6cNMHb/46mIFHHcPyyROcGMUzzVfTatzdknyTZ2yAnm6S2tw7ZhSWXsQ0YSZNc2pGAUO64cQDgzq3AG5MAuiQQGp6kt3aP3CdqUJX5uyCN9raDw0TjOLHUgdsb8Bzyd6wdrbS5KeRqBivpECzNHWteBBZRnucR1C+9bIrzeNhmvWLrBtdWTeAcBPYiaqjiYbKgzmUj/3pNsE9fUWCqJU6xgo/E7SgM1EFPp6Z5cFT6KdqPmmX7T/lRm8OJ7B9bRfUYVDp5DBl4SYcyWO8eaZt7cCLF5h1QK4WUbQMGMwKun/mAAeHM8esnJl1wLs1QjAcOIvkDBpmL0FnWoaKnXbvNB4xCD2ZQ0CkyQISqFE8mk1ZMtcsPA0i8CLBaPFWl5eiYNbt477kJJJ9fWTdk6B2ApV/eSfbfGGt8tzCrODZiwpjIzF0yOtsbGZsQK8dunIPXzHSIJb7OojojTNTZLc3PfxYgTOY7btTWqUeWDWvnkz9xiDaYZNYhzCEMCUixfb1NQBB+JDl5lp9O8tYXPoY6TIHQ7Oc4UYDlKYKH1NEmtQg0omYwsINe
 49LX12Sn
 +tJokeKHByme1sE9JIFzw6k4iL29QZDxTI5zktpJG1nGkU3W6J3BuEXy9sMHC+NkNSfL9Fw/AdLsB4uh4Ar4gqw3yBfzfBKhx4TWO+iyr/zae/2EvQETroEJCuufbZ43ncYGQ8yBMLIeJTAOjoymAjFzHCun5U0unqTE3V3MyvYgAmCzFgy4wz8tntFabavMh6ay6bbBqeeiX3rnc2Xf3c1qeP+XumkeMfoUZ3/vvafWYs/phSakUr+8TR2Ustn9lFKrWBnhVB/J48xRjRM3CooSyUPrfBGRoi9EwlJ/hmiLbjJizAhK83/xw6KBGvToyf68TNcWgUoAlmgqXbaO0WZTeBGVu53hL4JJa8yLRL9b2hVByZ4atrYjgtxac90YIT0o28RppIAY7yLVVV4e7msN1ACc/tiAFSzXt9hgTCT490uo068jQpR/aGAJ6IBtOxym1FmPRlLPFqA2neCq4Q5W6MvcAEmxAOQIgrsuIXmwCswBCF4LqHt2ZQ+YnnmEe3iRO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Nov 2025, at 4:27, David Hildenbrand (Red Hat) wrote:

> On 11/20/25 04:59, Zi Yan wrote:
>> It clarifies that folio_split_supported() does not check folio->mappin=
g and
>> can dereference it.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/huge_memory.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index efea42d68157..15e555f1b85d 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3688,6 +3688,23 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>>   	return 0;
>>   }
>>  +/**
>> + * folio_split_supported() - check if a folio can be split to a given=
 order
>> + * @folio: folio to be split
>> + * @new_order: the smallest order of the after split folios (since bu=
ddy
>> + *             allocator like split generates folios with orders from=
 @folio's
>> + *             order - 1 to new_order).
>> + * @split_type: uniform or non-uniform split
>> + * @warns: whether gives warnings or not for the checks in the functi=
on
>> + *
>> + * folio_split_supported() checks if @folio can be split to @new_orde=
r using
>> + * @split_type method.
>> + *
>> + * Context: Caller must make sure folio->mapping is not NULL, since t=
he
>> + *          function does not check it and can dereference folio->map=
ping
>
> Only for anon folios. Also, I would drop the detail about dereference.

OK.

>
> I guess we really need the folio lock to prevent concurrent truncation.=

>
> Maybe something like:
>
> "The folio must be locked. For non-anon folios, the caller must make su=
re that folio->mapping is not NULL (e.g., not truncated)."

Sure. Do you think it is worth adding VM_WARN_ONCE_ON(!folio_test_locked)=
;
and VM_WARN_ONCE_ON(!folio->mapping); ?

Best Regards,
Yan, Zi


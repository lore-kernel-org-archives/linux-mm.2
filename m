Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AE4CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCD38E0014; Wed,  5 Nov 2025 11:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4408E0002; Wed,  5 Nov 2025 11:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393368E0014; Wed,  5 Nov 2025 11:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 288B68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:41:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA45E56A24
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:41:45 +0000 (UTC)
X-FDA: 84077119770.12.54B92C5
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by imf25.hostedemail.com (Postfix) with ESMTP id D1CA8A0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:41:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SNjaP+NF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762360903; a=rsa-sha256;
	cv=pass;
	b=cKNUfwqWlPbClSaJu7tTZLvJc7xv0scQXg0dBPLBFtpGU18o2Ox1SHo3opijAcAgd48RYB
	pq3vPnbC8O9zm2ipkYBpBMC+1s4FIagik2SFHScDlUa0uheyJfrVUSKT4EnHzWmERY6WEy
	KZDmjxvRRntb6i0+V4O4YGHq6r3WDDo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SNjaP+NF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+A3X4TIUpczzEnKyuatRJAiJdv4dW4E8O6z2cE9V74=;
	b=Jq2Je5Tb4+L18fPd432Bgv3ZiIC2jaCT28EA8/LBYkoy7g/C9VRnX3gIQav1q88UQujTb2
	MgKGNkjZtxSH6Unbr08aXrQgPY0ZDKXNRH8WRh20gEa/s0mkO129B80tkGP1f7t8vLHh/3
	Z/j9N46lDJ1l0+HTJhm5e7SKBzWukCs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0zWmyYxe3pJrHfiDY7kOlys3CjH/L4Qcjx0K7i3iC0yrvkKTNqLmdGio4NuMm/a7XwOB1vb2VWf0HcW8rD4BlTNWoTINGEtS3pkv7EGY0B8KDftkBvVdFmx1iBeYLq1+bZsIoh00RxPN0a0I8z3D/kZflXyCL5GIFTSSM21CuegXwqz3gn8fE0PcBScExXt/lU71lvfnGP7K2dPB6YIFfa+DIBt+tvdly1z6YCUOeqd05Bg6nXvE0V+2yiehu53maygHEbFjsAI6WzfqUavx0wRfHw9ROrQUDi/f2FvbIdwvACMjb7NTGRUkQpdg5GD2C7JuzktKBvrJTOx9SSycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+A3X4TIUpczzEnKyuatRJAiJdv4dW4E8O6z2cE9V74=;
 b=X+ZYICGGh2L9+ABfCn/NmswFXm4tlt4KyMpk3+ZNXd15LJHASS1BmvBPg22vQjD9ozfsbHIvKBEc+yj2SQA3UL1zj6DvPqPjlhN6xGziGX1AUiRPcJX8+bHvkCR4z1nHfcdSSnSd0Rs9gu7jv+KA/e5jnZAU1cwS/h0NNciCBkp4Jatwi6Ted8xaWBabTew/yU+tiXy2rfISXE6df2RJtM171/fXfRgqvfMFP8gw3Jp/F41tkxtzwqpjS9KtUDAQ6TOeeMOpm78J7yR0VOixSc1W2nnZHpe7B8Qv86flvpPA3NMIW2D9vVvAchV6XR75scqqFwhKA4sjTrhEjEvo+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+A3X4TIUpczzEnKyuatRJAiJdv4dW4E8O6z2cE9V74=;
 b=SNjaP+NFRKvbB/c2GAjW0ZeihiiyItldk6DkTMKbfIwH5HZeVSewUBl8q+22ysl9qnHKx94z8JvNFx4qNev1jiTqjE8ASHh+MA6eAMhDef87K+aGGYwgRFxQOZXMix4/yiLtTkiUnl8hL/hADI9Mluz1HfcyKZsYAdR6QQRixcKeAcMVU/LZ2pVIMRfUfvtdoigUTKB16+Eq2A4vZgiWkIh3HMOGU+F3BTD03Oc4Qn0mouOurS8pfmoSLabKYxWqDq+cCgvg/AJ+s3KJuNUAsRYijh9OtuL3RPbQVDHi8urujg3saHmawgXqVC+YYjyrmV9Y8nSWqBzs8cxHmn9J9g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB7343.namprd12.prod.outlook.com (2603:10b6:806:2b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 16:41:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 16:41:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [Patch v2] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Wed, 05 Nov 2025 11:41:35 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <A4842E31-E15B-4E96-A313-F8C9F6A6B424@nvidia.com>
In-Reply-To: <20251105072521.1505-1-richard.weiyang@gmail.com>
References: <20251105072521.1505-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: 96fdeb5a-0088-4d29-8507-08de1c8a30aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XEoZuo41dySdxIK8gGp26shD9GZj+rCu0ntj6dTmLwePxAMCQyVUBPccI1Bq?=
 =?us-ascii?Q?FWagHl5TYTvFaxQCFdetmoZhJ9+FYEJpcQMHQ53owTH+tkPCX+UgVE/7vM5U?=
 =?us-ascii?Q?oMNHtLQOaDsyYRLHZA+vMnh9HZXiHYOCBQokb0UlH8XhHeOboQVnw/iBdd4a?=
 =?us-ascii?Q?Y0w4jIbFZTPGABjrr798EYoux4oRdXcV8VgdSpEDCWZwN1GBy6faRuVc0iEE?=
 =?us-ascii?Q?1NDeGntiV2Ap5ph8XsSZfW0id7AoNSxrt3qc1i+aynqh+/dhhnqC7mWX7XsL?=
 =?us-ascii?Q?Do9A5HdqicpGcthYEBRZB2VIWv1/2z4kl5FucDfp7SI7LwrlAazB3g8g9uBJ?=
 =?us-ascii?Q?RjOHFzyltoNuImayT9jdSbEvBFB5M8KFNR7wJKtKHMcaB3zo0+qXpMpvWXki?=
 =?us-ascii?Q?5Zobm/LPGcYkbutugG5zY+KIRaI3+zIqDjd9irzeSGJHYu1wvO7YUJmYBIBl?=
 =?us-ascii?Q?VU1w3XoQP2TYkjpEr7wtzHfVaSMRIpb8xwBLxBxEbZZJhKuxK/lkjzDv690K?=
 =?us-ascii?Q?YVSEF2VZ4RtXvpK2Xd5CenYN0a9B88t7Guf43BUGyllWZuWjqyFwbeGpLjXB?=
 =?us-ascii?Q?hug+wicwDUKbt1vY9Snr8xUz1h+ZTJmUv+juZw8fdQaCkDCpZwOuYFw0JC+l?=
 =?us-ascii?Q?s9eMBvGN5ezLzcK9//iTWYpsh2hTaBMIgZGjLjxfSsdMTvszczVjqSDwJ9ky?=
 =?us-ascii?Q?y00zkatx1hts82lPuwCfQKVIf82wnH8em7ThLtUUpERVcouRc9EKVpN4F4Eu?=
 =?us-ascii?Q?3ImxwjQOs+UVjGNBSBsds1qkJK9n5u0olHOnQKCP991IrJCDftbqmNQps6gR?=
 =?us-ascii?Q?eIT3W0snJBQz9c+rEwwDtJFbULcwIq7OVbdXNbG76lCn1r8gq84a+XaQGHQv?=
 =?us-ascii?Q?Vjyj5Wv6bSzSS80l7Lr8rOecnEuslRPexyF1oi5H0VTRq5JqafgYQhjFkQ/v?=
 =?us-ascii?Q?dINzwW5DJoGL6DqDWyCJj62OEmH+OrtExqy5D295mp4/DLbHz0MII9bpKdoU?=
 =?us-ascii?Q?m0PuLRxIO9aSJmo/m40qSwZWOrAsW+dEz3qxyjM4FcD9k/h37uNncOo/RFuG?=
 =?us-ascii?Q?H9SHlNPXxox1N5d3ymTF+cJ2lboqK1S3hxGXVhJoMjjNsKdq0HwESrC6hJZp?=
 =?us-ascii?Q?hWg7Xsv0LILsopqVEyzMFKGxWqfjj4Tkfw+W08opnjvz1UUl0C4MjZvT7ZIj?=
 =?us-ascii?Q?DwMnrB9X3iXqMn0w9HY0vDkhkbBxIs/AVOMan8oh4Wki1RYpYAJoy9vvmKOj?=
 =?us-ascii?Q?Lzj8Lx+dwgMtXVqT/cuQ6udifzpcwb5GuufSZGr1uVmx9fqPM2hD1NKVzrDY?=
 =?us-ascii?Q?cANDHvh0+Nl3ajwSe8vZ0t2PR8AafZcwneppL8tUTVXc345VaM0RZPspMrup?=
 =?us-ascii?Q?r/c7ammCbluGPzlP6NNjWSIv7kwGupMehreppgKVxwKQIlet4hR5oBc/BooO?=
 =?us-ascii?Q?49NYIH4LihXXn2mRGnXUhEi75QERnnhp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vnZgWz5lPsNPAdz1kN4ML/NKKoCRvQuybBx+LClCMTKLWpNzUkrlWIt+JnVU?=
 =?us-ascii?Q?PBD/vdXrvcjokx0qD7tOgAdTwZd22AXQ5B0wQ4E0kcZEF3bf1U6QTBAp7Of0?=
 =?us-ascii?Q?z/w2UIFZw3b4jTnfB3+vBklffDMqdftY1Knc9x7fSu+REDinSFigQrYTOs3N?=
 =?us-ascii?Q?hFuT3RLEU3qw4wlwNZIy3EXxXBZeW1zeaOhAcMbXEySrZphj2lEHcsfr8iMC?=
 =?us-ascii?Q?NA6lwqReAdiuPVNsVGDZXv//W1Ry8r76It84s4ozsfyyy6AmgoiUTm41TjZy?=
 =?us-ascii?Q?u9IahzogkmLTaajGzz6X+badiU8djme9rCNmjHAG+ta2GfxpGFHf3sf6Z5K6?=
 =?us-ascii?Q?YtTMqNdLePcfpLQN+zjl8aeM7l/G5WGiJrm6bGSnfhfzcTOu9zGUaXKi6HYW?=
 =?us-ascii?Q?11nieBJ4fE8cPKNbf0im2vUntHbg/b76YXm8zDObKb+jF9CWnwgpERxCumS0?=
 =?us-ascii?Q?YuMReU8/ISx1xNgOivl0ebYisyYPPA7SvYpc2T/4xqmndg5SrExGrtskXXxk?=
 =?us-ascii?Q?cbL+nQcn9az6hFlElCAavLFHjMeuuqICSV3hMRxbiUnhWtc5Ja2SZ2AWLxw6?=
 =?us-ascii?Q?yY7CkO9zk6XN2L61TJZ0gbn14ZApdiBamhuX9FHu4fi22R8gdMbndsAuRg9K?=
 =?us-ascii?Q?LbejWyedOC8GrMgBO857PROFbaRheXjPZBlgwV3297qXuHiytJENQH3DKBHJ?=
 =?us-ascii?Q?UxEkT8BWepwMzM8bcEg5+n7Bixu4vdlfTyo3vkAd5QHwiGuyPJAOvxHc6jWR?=
 =?us-ascii?Q?E0hEx0FbNTOzB97coElM+A7hSQYoOKz0ZvEA8FKquwG2dsnehXfqKLn3oBLq?=
 =?us-ascii?Q?VYyM+8Xr9lGbyd5aOoUPq009FbdluQdauZ4K4PYoDOe1P/jcTaIW1fbqQqcB?=
 =?us-ascii?Q?d6ecI5c+qu0U5Uc4G2yQjzYlUyyAmJ/8VfxPrgdLgEIaGbfN953iUEQgWOhc?=
 =?us-ascii?Q?S+t4t5EsCquh+/U6CuQonQaFTQpy9+3z6n1U/tGys/id+fNE1iqGtw62kguB?=
 =?us-ascii?Q?eA4LrwqW13rc/EV3qgfYqTmHhQ3b4B0WIE4Nnza5UDwdEDxFkG0ztUrm7svj?=
 =?us-ascii?Q?6NDiY8YokdjcgSfikGNxIEoS9r67L8Oh8U7m3QbzcD2pTuc+4z1p3FdFJ5AM?=
 =?us-ascii?Q?T5uczmBUDtqBncv0YoZvnKqyuegaifbf+iFlSJD4kR6NNZgvX8DjwUeqQya5?=
 =?us-ascii?Q?KbtejUH4iBueBs6auDfUFxlGgp9M4dWbDBpo3T3uGulS9C05KujIHUa9Igiw?=
 =?us-ascii?Q?daQUOnq5vXiwAM/MiVoGzmZGSTxqGzXtKuAUvMEl66ADREBivyJLxVGW8L7S?=
 =?us-ascii?Q?Ky9fMRjBUeIDxCfiLiWbGYvdfK+Vcspf7/W0AYT9ZGmx1dBPdFr/M0NwE6IM?=
 =?us-ascii?Q?dW8QsoqYdtkUxFA5wrYaGDRxE0TppuN2WMwC02qP97/K5EAdPIKjfzfyyxsq?=
 =?us-ascii?Q?928U5F7B8hC8wRyJLWMQPoSgm4ZNW6ZseEkFYZerrs0T/ratNXaDeceXPmBY?=
 =?us-ascii?Q?LYYhK7h7Gi99Z1M7Be42CjD/UI8iFRwTl+zpoxKeIXQWAlOaWJWiRpaci5FO?=
 =?us-ascii?Q?nOmpD1LKLbFlacFJurLfCx2F8nLMAZeehgbPRGiX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fdeb5a-0088-4d29-8507-08de1c8a30aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 16:41:38.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vqN8+fjc6PyjH6xW+BktYS54EHUx/Wp4Cs5eGYRCImM9Qz0EZVuhDqZWlWY5k4f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7343
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1CA8A0003
X-Stat-Signature: 355b34y3yf1qj1w3rnph5jmjz5nicx8d
X-HE-Tag: 1762360902-535107
X-HE-Meta: U2FsdGVkX18kIuCUdMCJK62vWpqzSoM7c7CBW3lCBPK5GtM196wUPB+S2VAfv1aLClc1q2gCpcdZ3wgmAaHzHMXKE+BSXxnOsZ/UE39O7zyidzk0ivylLDiw0Cb1jb/tlBwcTzbC8T672ZFbcdyu5WYe7mqSMvqCQ3th48zEGavYG1pRTwcDZCrJG8vMzjiP+7CsemGwzy09B+1m5s/D5KOPttQHsv7hZYR9kVMDN2X3Gmz/+BCwAZXY6EUCLonQ8zZRR0w4AV62z72Gax7nxk7zNLcDzA7+1jssJKezT1NieAdn9OHvJKSn63Ho6IDmQa7IvuAqVi7L180wQvRxJ27mrWBLhrJitIdwrJa4aTZ+q/8+56KxnE8uyGYTfb449wvgYwlku2yPKoLs9e57wehtqIUE3ANwU+6HLXyBd5O0UurYTVejDdiMQ9O8pdYK35tH0m3KEvmS2I8uLViWoYoME8e4ikfbK2qWmSkXBRDYMdV5mgYkoqMuQ/r2ief06naNeJlXkZmmf64BZJ8i7kykzKcbn/th4Md9w0n008s0PE+tH70qf3IdsXHGC/HL4VUztznTK00VCwOUz0Jg/GGrvyMLhuZIchyt3tZ2AgOLX2YO22mubdRkJz/aVNCAolnw5jmc6Ld8YUAAfndgQ2QJZOcmD41B0YlBwKNYaJ7h/wZs/5dNf/zIYtVeFQp3lI8lYNFmypUjLx9IgzQoNZbijiIu8rX9oxefLu9diLxbM2j0FZHypnfB4UooqUFjVSorL3eMONEtU7LIeWWWZ224Bb41KjejXaqxdHqrDXEZ2idsAAHa3c0bhnoItz/jcmNKSIzfd97ALAblwzTA1lmdNNrro1dCiQwEdqJ29pdvtsEChB4GPf0+RyQFydTG1ZZIkC4be7P4tdrtRjZAoda/uwzA+qarUAgiRAchMDP1KgzDv1JC0dCodEUYzCs3oFEpbXSx6ZsLzcp4ncL
 LvZ0hSsQ
 9JED6WcNrZLNjJHVy6zYhpbv5qLXroXqNl75eNltYn3Eme02c37IiOrcRsgm9DL9VKbjPyJ5i9jGiTbwge47IpL2iq6QMZXli1/YTJlfu3MhHtDlKRzxok12abbZCKDHPPoQOF86NXOVMCGp4pG/nRt0AvBo/NArpz3yuQ32hhLPweCD0gQrMTBF4a8E9IGklXD1fV76woA3vQHyNDFBn1KTT32NUGniKfF0f4dI6X/pGAW+n8NnptP9ceDp0m3k6OqN6xUMCWAttGPgGehVEG9y84QBbIilqyqiJTbHeJyhOny2sAPB167dD/UgDmGOofnumnVPwTdFQYvfqBIpJEKBYj6sdO05wSf2b5W/+/RTcNEiY5bosi33XxvNv13zawOVMWhgIaqFpK/KCCv/c3uCcFa35nq3u+uDS4o/45g3tWMtyR6VXH/PjALQ1nBwfWP6rxQ5mSdqukLeWDeMCAzfGR2xUEDI4u7J0Zf25+kDpv7OA6JX3wjIK0Bbwy39HDoqChSSTmJTlzmRDozgVDgWf29Jaa++W4AEW32lz2XH7WNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Nov 2025, at 2:25, Wei Yang wrote:

> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
>
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order.
>
> The reason for this check comes from the following two aspects:
>
>   * some file system or swap cache just supports order-0 folio
>   * the behavioral difference between uniform/non-uniform split
>
> The behavioral difference between uniform split and non-uniform:
>
>   * uniform split splits folio directly to @new_order
>   * non-uniform split creates after-split folios with orders from
>     folio_order(folio) - 1 to new_order.
>
> This means for non-uniform split or !new_order split we should check th=
e
> file system and swap cache respectively.
>
> This commit unifies the logic and merge the two functions into a single=

> combined helper, removing redundant code and simplifying the split
> support checking mechanism.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>
> ---
> v2:
>   * remove need_check
>   * update comment
>   * add more explanation in change log
>   * selftests/split_huge_page_test pass
> ---
>  include/linux/huge_mm.h |  8 ++---
>  mm/huge_memory.c        | 70 ++++++++++++++++++-----------------------=

>  2 files changed, 33 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index cbb2243f8e56..79343809a7be 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
>  		unsigned int new_order, bool unmapped);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool uniform_split_supported(struct folio *folio, unsigned int new_ord=
er,
> -		bool warns);
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new=
_order,
> -		bool warns);
> +bool folio_split_supported(struct folio *folio, unsigned int new_order=
,
> +		bool uniform_split, bool warns);
>  int folio_split(struct folio *folio, unsigned int new_order, struct pa=
ge *page,
>  		struct list_head *list);
>
> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>  static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
>  {
> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ fal=
se))
> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D */ =
false, /* warns=3D */ false))
>  		return split_huge_page_to_order(&folio->page, new_order);
>  	return folio_split(folio, new_order, page, NULL);
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 381a49c5ac3f..db442e0e3a46 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>  	return 0;
>  }
>
> -bool non_uniform_split_supported(struct folio *folio, unsigned int new=
_order,
> -		bool warns)
> +bool folio_split_supported(struct folio *folio, unsigned int new_order=
,
> +		bool uniform_split, bool warns)

For this one, David suggested to use a enum

enum split_type {
	SPLIT_TYPE_UNIFORM,
	SPLIT_TYPE_NON_UNIFORM,
};

in a separate cleanup patch. It is better to send it along with this
one, so that:

1. it will be easy for reviewers to keep track of both changes,
2. it also helps resolve the dependency issue, where the cleanup patch
   goes after this one.

Thanks.


Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B676109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A716B0005; Wed, 25 Mar 2026 11:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F22C6B0098; Wed, 25 Mar 2026 11:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0D96B0099; Wed, 25 Mar 2026 11:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0526B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:06:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FEDF13BF1B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:06:02 +0000 (UTC)
X-FDA: 84584910564.13.99436FF
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010020.outbound.protection.outlook.com [52.101.193.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35C26A0016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:05:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Yn+kRWPC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774451159; a=rsa-sha256;
	cv=pass;
	b=veithwgDeqarllXolMxAaLJkFPXBnjtUGwR589SlQX7/WJnGz+Yf6NDn8cyNyRwvWZRwq7
	U098VU4Y7bp6P1rw4NxYheB7UtPBq4MMww9QTcDe/YDS7g+CSFapwHJilSheiRDilwj/aI
	QoRZRIgCVdSPsU4E4Nm1vzwVLszPZJA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Yn+kRWPC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcPhkXM6AFjavxzobgqdDz2s3PYl9AB+mMXVZd2JLtk=;
	b=GABaAKuQhMF1DbKM8Fo+ZmTShuKHJE2qcN06QXdkbK9wJ23jPTU9EJILfxyfVNHyYqtP6i
	LmBa5/vxCn7t46Y1olz8UAHUpa50QmLO9hM0KpGd60Hxlq47wsWADJvg5bThJojLavGbfK
	JcP2bhMCN49LSQEl+/cbjA9G4pFNXos=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBgcYQWGeilSREfjyp9T3tL5/g2ENCUgPLhUKLJHgQIModRWy0C0wk9kiM4hiZMpz8GsKMyVFtB3xD8JMfqJvk5WdpDUVCaruhW37j3Mj/Rkx3feI92eHUgqXIeA/et5NClwmU5upx0r3Wy7RZmNa1mznaVhCv5wgE8rTTGFbQvOKz4VoNKQON80zO7VJjKA0BY+aACM/4BV226Bmoy7nHszX/vtNgfTqWAjFtfY8L6Li3grtxyNBVT+8QVIEjbbg28U22cev9bXYhcKGgrCiqb2OqWnmryLbVP59Oqgnx13BPC9XFj777P3jvRsSzdJvb1dg/vSPirwM/KiBJ7OrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcPhkXM6AFjavxzobgqdDz2s3PYl9AB+mMXVZd2JLtk=;
 b=to9ASld/S3JKNHPmdFo0VLSGsiDSHHENhrzPBE93OBJAhKXYFAyk8VZ9EJIPoJjmNzOl18+e4JvdlTerX1gk4W02EPgGkWMc82iBIWGm5CxmOMUHzQsq/uDuk5sk8GX9AwKga2DtM2eYKSTIyUB0W04B4aeRMO10TbJiId3ZggRqo0k1sJxaQrdekmkSTVPXwKVsivzGDl0+A25h1YfaP/Xz6ENkRZV9s6HABUNaD6tbEnHZ2+3yyvP28YGsx2FRTBPkgchPmYCGeQe0yVxc5/YSx8NyeZWosq4sljahBKzLLsewGv8vuivdgFSXLtjXBz1VC2IJ0H/ikQXlQCDxGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcPhkXM6AFjavxzobgqdDz2s3PYl9AB+mMXVZd2JLtk=;
 b=Yn+kRWPCWw8Np/48T8d4E/7sUisKh9wdK5YOeWq45EIK180HUeGREXJHz69H8Qc1lFvEqMwumlV8KYkkrGEgYS4fEBhrdldiZqicGnHP61wo37vkM+B+pK/ynThyIRHF3vVdElFxuZjQurdptue4OxPRFEgA5rFacUsZh0qfEjreppgzMQH10gWt6b2opGo6nQOSO5rmIdrz3oYlMD08rOTGUH9GrbO1uqxh+adWhLFlbC6YUriLJyPadKR7RRqf57nHNxIbT22vTJ4r54Xqrs1k39M7mtpYyfIMQKXkwG12oK6a7det1Xn6ua12sLCnqdLcYgWMIVv6EBN/861XlA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Wed, 25 Mar 2026 15:05:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Wed, 25 Mar 2026
 15:05:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Wed, 25 Mar 2026 11:05:44 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <925CC2D7-D525-4272-A01D-2A1E50127401@nvidia.com>
In-Reply-To: <218144c5-6f51-44c9-bd70-e171005d3606@kernel.org>
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
 <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
 <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
 <539EA481-9CA0-4B2A-B0B4-C254E34BA7EC@nvidia.com>
 <218144c5-6f51-44c9-bd70-e171005d3606@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d038a72-9903-484a-0133-08de8a7fff67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ahiYrlDpAvko77kWY2o2F2sUwk9wfjPecY5kyGLD55dvkjnpI5av5petD/btGi3oYsnsWzPajFsmPFPXU5WyMPWiXeZg8ONyFZDQoa1SAQ+oWX83kLtBcXFRMFvwiDl7KO7UXv5bDlk/vWp5CeDhKSMHUbq9XWnuL+YEEZ0iQLQijZNPQs/MKMn5trngfwFS5RGMdlxi1wbW8m6NnMJ4G76DDucg07qAk9DJhnc8i/iBGjx2IlTdT6s+L8toL4Qubuw2Lf0yezhSjT1XiSY0HjBiivblZWDcG6Zm5+7yj//3oKxm/jq5iGieG3+exMTHwmktLESbclsXGPWzqwW1ofp0Yi8yFlcDumA2IZYvFC7BLw1GaVh59ilVXS9JNQKB4bXiXAnUyIZwxP6fZeXG3dwukNwmJQeeJ14xgK38mfOvxBiZy7YYcwA2qpquJVSh0NIYFqrQzL+zwkJ8hY2kMXF/cDqG2ivPII7UBFO0Y/H9ezuwke7Cx538pcRGEg7QYrsjRRbIet9D0RkISABtCs4FZr5ZvwR6L4nO1dv0QVDNSrNqxAuPFIsMT7d/0OaFYabhQY2FsjfFgRZvKkI6oAOX3ICU7AJz1W3QCG9Kqey20eQILYoffogyeCWxqqFJuyFpBNy8Mag5TnLvSRCV9O6KN0pE+NHVT39ZvoPtT0QY/Ug59eT/CsyM9eFVzo7VKC1aTlDx8Qc+/uuXu+1iirqcY2bJpKHbmVW6Vgv0i20=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MRERbjznk3/7mUSQtOGaAqiRXOQWLx8G6GsCBTku/N5MIMWTyet1c1kiU81A?=
 =?us-ascii?Q?hpOEG/vNVswIKkXGZXTdUloYadrYLZy1UuNAGhr3ncVVBvm5F96GsDnFais0?=
 =?us-ascii?Q?mRyvrSU/O2dJvrbnQ/G4bQhJ2rHheY60dvroSRtxUpVFtt0U4GHwrreXpfdF?=
 =?us-ascii?Q?EqhrhKhFSJmmtyrFW5V7Jh89p1QghZzzA+eeLgYJq5MtKNu8dD283gP63KfE?=
 =?us-ascii?Q?KNzik9PJtibSnR9audM2QXtm7RcfO2kEDAdE1g9bZFq+MwYhokrKwGhQLtDY?=
 =?us-ascii?Q?oEIPrEd/CfoFarLz2lgLq3Z3K/qY+us0Dc+yCYVvdE8ZFrOfIwqDtc4rsyIE?=
 =?us-ascii?Q?IQcMf8Li6kTcCblqJBS73xcJnxTgFhy9Uo9unWT03yqlAED8GgMfOwI6j/zx?=
 =?us-ascii?Q?DAxbDant10EC9zcQ2YWwEkgIQRl/zIh7vIkU9oUSkipI7lrXHreEkKqVqVv6?=
 =?us-ascii?Q?qX2VidLaoPmfpMzv+QqkYc5LE/Vq8tPbPpFqDKh55fSBeIFz/h55HMhcm04h?=
 =?us-ascii?Q?tMdLtGezwQI1wrn2OW1psJWOdmSOP83EhWMqWVQR16JM6eX6eCMNcbVnYW8E?=
 =?us-ascii?Q?dIRw4Y80e9JGYw9J8mn0xEGjxAeS+pOZiMbbjVO66uw663Z4vQqjgPv0GU8A?=
 =?us-ascii?Q?OT3mjO23Ik5hTe5Rg/fNA+Z2efZIU26RSBm1yvZ2AgPDU5Ia2+70+vuJSjqO?=
 =?us-ascii?Q?6Bf43JJ7FE1sfEhO9Aiy9rDWCGXEvyXpGCdBLmVbYl+lAvmvXozEAryHiIbU?=
 =?us-ascii?Q?rw5ikTHV/JEs1KJCIA4OwuZvp7lUht7gFKEZ8R7OMGpNevKI/l9h+K0p6y23?=
 =?us-ascii?Q?LelEAovaZmJLfTTzQe48u1pCDtGgUv6FJtAG2CFJh27g71sdLFBQb4yGqSgy?=
 =?us-ascii?Q?+b0LXnwuDp6yntD1kVXWnoQDI7MjJsAV6dZ6lEs27AETjpZA5bkjLpqkrrgE?=
 =?us-ascii?Q?0ApN4L7GsKIdVosrQg/otORqdnX7FkYn1qrFHg5+K8yE+4QvnkS0Iie9CeO7?=
 =?us-ascii?Q?+tZm6qVdsj35pfo0aPssX2xYPjeSS8RaykTVagPO5znMjAw2GDx1KUtZX9kj?=
 =?us-ascii?Q?7B0A4Mz1if0RWuMORGhQHWL+p5UIsC/28VqqLCPL03do26/gj20TAj1Jrp3b?=
 =?us-ascii?Q?eyWyLxH9UDO32Cy5pkefIXy+AEUj0LyZ9sgJoJcwXlQjHv9U3CJjkJ1VC8E0?=
 =?us-ascii?Q?ZTuxLiaDEBQrTW54fVxSg/i5XUcEchFfqBVEcgnP+/DYkC5wt8079XhMO3cN?=
 =?us-ascii?Q?B1qw56o8dYD9c7Y4Ri/vaGZvdY+mkUTcZBdsVYjlUjKioip68hSG3747AK3b?=
 =?us-ascii?Q?EgkvfI4azTpmVEOZLQeuwIwA8ivwET7laU9VvURHpn4BS5sImyMI1IzkEnd2?=
 =?us-ascii?Q?WaBAJp8gP1Wo9w7JZLshdwp4EHhoZp5vZ1i14FbAecEb/FhEHYn5rtwFS9Gk?=
 =?us-ascii?Q?0FJdNaNPLocC3VDqhbyMap+GjgfXYR/3TxqI58Q9qVx8NvGFnw1oaOlXleZG?=
 =?us-ascii?Q?T/qsgFaxaq5NHLFwhiwWkU80jG6Nwk4pohPW6j1/ocvyTPKjBBb0c7bF6Yde?=
 =?us-ascii?Q?JmbPeCp3U+50bWaDZDGvRvdiJciTszWqorMPddQROCjgsE6B1aoxACXZSWAS?=
 =?us-ascii?Q?I69y3v63hDaSfkAHg1nwzucRMDCjbQF2IZm9TVxLhxQgzlSPs7nsZMUT98ze?=
 =?us-ascii?Q?DUpoPLdFr4j2PlVPHETuEEmSIkl8wfY41xthF8qQxhIIIeVFhgCaQCqORW0v?=
 =?us-ascii?Q?Xd5rupf3wQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d038a72-9903-484a-0133-08de8a7fff67
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 15:05:48.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRCf/livCuFanaYXKRuYeGXd3qX6v9mFZb1nUbD23cIwSDg/918eSDYZkamg9VUE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901
X-Rspamd-Queue-Id: 35C26A0016
X-Stat-Signature: s49tk18psjdmo5k1xkbf8uhbnh3guihw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774451159-34902
X-HE-Meta: U2FsdGVkX1/As26GLUEiVktBxdHkeJKFtJ85a9HPdLhe74EVPUAXNx5RwqE0YIFYxFVXLb6icmNGJ5eHgEKkigX+sdiccW2D+6wUcyWOgq5VfbHrJrl9YG+6s8KDxACxAVaxpimtU8SHgE0HIUfo5vdf6QuJg7A3RrfU2y5+4LeBG2SbzdMJOnjXzUaGUQlrw50JjcoPWPtw8d3+m/W0UkyrvApuxnXyr/HQ7jA/s2B/A0xQa+R+jz+PtygTeYFXuGbH5mB/VvZMEdUZ3rxoJnuAXgztwdsh0hU13d5UU/8aF7HU4GHBk1G0K0X8JR8UgWFeOL6F76ymI4FABYN0RVKQssBpN2+tZ9ckRggwYLxg62koYiOr5cUhMxt6sWEDLGi2pBe2JGwpk6+6GfbWPOd2340rfklMggC1heI3ctm0cXCXAoA1/lUoSr4tbkEHwRrfFd48AEjftn+wglK4PvUo9Zrjj01oy7r70dJnfl93C/7yQgSg5GkHHPgquMB25XwP16v404amWd0RsBwirA35AKLEOmQ+JXhY5jLuJiVCLtUXChlRsEbcOHabfOqEtytIQ8umyW/UJQtEYQ0XqZNCYCJ69ocWTdB/K8oONorjLpPYl5n76Ryp8GOsVM9ffWHWygDVGlj/dJtZDGdhugtpaZG7fINy989rD1WiI0PUAqp4ROCljt8mgxt7pCh8e5UWdqftek9jdT7b5/uH2bw8e2Ns3thUfOFdoFHy+7Es7NuWnuta37Sgl1euSCygdurlQljdSUdAjDeweaeSke7IY46h8PzOja4kHkstgSHXTVrvb2b87QBWA7rLkuXO3WchbLXi7gQOItrOTTHyFFzFWyLRNvOeymcvnn73jWT+m/qn8YVK3eldeTrgtDlJXtW+L2rSiHChCCLc0S6Z0UvS6Dv109eXp6tfUhKvfivJSsF7rO9euRHLvcbC1MpW0acxKIvav5X1/fjHkGP
 vK8qLx1p
 bx0enmITtkHJKFaZxXCRHp487woEHnAk37X/sTRq3t0KRmID/m23nXwIGj693XubAlWAe8TEeu0zKphUmM25MnLOp8WuqYv1Z9QciuACmbi0QJabFH4i7iIQ/wIlF8Z02KdBGTx8kh0VNnY9U/2/sjfE7Pp72DsITgCquODqzmuK1PnmuaR4UJoSfHWa8mh6p2Ltz2kxSwtyDu79RmsOL6kdHrW44W5FeBE8ZjLVfhUhFY/bm5seaEo4EXH6h32GTonxDa2dUlQQptP64Pq69a/p4xy4HLqy9b/z5ZShDY+CXjdggBO4h5PkgKwXdUMr3Ycp3L3lTYu67fdh3o23bo5v0wxFEuL4sx5A4tMVTOYIfCvXVp8vJHHOm4fULSjU0qbcwCrb5RI/a2gK9RORd2iUhKNnpPQxlUEnIXsc3a2NC/lgEf7VzbG6v1SDXZWl48w2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Mar 2026, at 11:04, David Hildenbrand (Arm) wrote:

> On 3/25/26 16:00, Zi Yan wrote:
>> On 25 Mar 2026, at 10:53, David Hildenbrand (Arm) wrote:
>>
>>> On 3/25/26 15:21, Zi Yan wrote:
>>>>
>>>>
>>>> Hi David,
>>>
>>> Hi,
>>>
>>>>
>>>> In terms of folio_change_private(), I did not think it is related to
>>>> folio_{attach,detach}_private(), since the latter change folio refcount during
>>>> the operation. If folio_change_private() is related to attach/detach,
>>>> I imagine it would check folio refcount before touches ->private. But
>>>> that is my interpretation.
>>>
>>> I mean, given that
>>>
>>> a) It's located in pagemap.h in between folio_attach_private() and
>>> folio_detach_private()
>>>
>>> b) It clearly states that "The page must previously have had data
>>> attached and the data must be detached before the folio will be freed."
>>>
>>> This is the wrong API to use?
>>>
>>> Sure, it sets folio->private but in different context.
>>>
>>> I can spot one user in mm/hugetlb.c, that likely also should not be
>>> using this API, because there likely was no previous attach/detach.
>>>
>>>>
>>>> BTW, do you know why we have set_page_private() but no folio_set_private()?
>>>> I would suggest folio_set_private() if it exists.
>>>
>>> folio_set_private() sets ... PG_private. :)
>>>
>>> folio_test_private() checks PG_private and folio_get_private() returns
>>> page->private.
>>>
>>> A cursed interface.
>>
>> Oh man. folio_get_private() should be renamed to folio_get_private_data(),
>> so that we can have folio_set_private_data().
>
> Likely we should strive towards only using folio->private (and the API)
> really for fs-private data (i.e., the pagemap.h interface), and add
> proper custom members for all other use cases.
>
> For page->private it's a different discussion (requires more work I
> guess, because there are many more use cases.
>
Makes sense to me.

Best Regards,
Yan, Zi


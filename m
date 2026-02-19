Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6936DE9A056
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E1A6B0005; Thu, 19 Feb 2026 12:28:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C556B0089; Thu, 19 Feb 2026 12:28:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9CB6B008A; Thu, 19 Feb 2026 12:28:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 563526B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:28:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FA26BA45F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:28:25 +0000 (UTC)
X-FDA: 84461890170.24.279C450
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5234B18000E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:28:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LgL0dE3U;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771522102; a=rsa-sha256;
	cv=pass;
	b=WY7hnZayQnyIhMllIVcSfmoYTGGJgDYVI7+65CJz9tnUtgZGIHRAUajKi7zewxMGoE5S7H
	TfsURwLhfporObdMi8KbB6d1g6p7pnvugGGqY1XNMj5P0iBCFOI5/mo9XgoMHnNfa8J0QV
	8U7ts/g8pdL78wmrHg9czTKB9k1YnZw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LgL0dE3U;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771522102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYIstLP+I3SMhfJZuStgF75zFke/K0CT7EG2UuCuyEs=;
	b=Os8loIwUsmSwPjzj3tXcLEZFQAkTP9w4I51LWImI5WTPoqy3iCxBGkW8pLLhXGTeGsB4FT
	s1/uEAf5ybU4P4R//DTXDup0xJgtIzAnlV598d70+R4MC0DYGY+uhMtRC6ucOSHt6t6Kmq
	ZgE5VPzEjwActF9JJYVLDLeev4tMZW4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEUzx0KpXl5XW87c3IBaYfIL8Ax7DvnfGiyJuvUlKMsekm8u4p4FCO+VLsVbR8ajHNqLggO83T+EvFa9hQXccXDMMMqsxV8j0159El5mXd3eB8ZVHts43zZsH1srMV2db88cD1Dd3EwG6gJBVY4+1cQcnfqYzRLhwDzEiGqzMYF48LvUvf2051F/ll+FaLNn4BbE5+PF5cpBhrLYPY2H8Fex+cP0rGylcfAlt2jsQ6m/eniMgMhyaQEU2c7z5R6T4N/nSePQI3TtR81FIZYaMoJFbGz5hvtGpztrmkAVRH2OZEA6agU3gBhENJlclf6NwzGmV9N1gWNgYBN6lPK9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYIstLP+I3SMhfJZuStgF75zFke/K0CT7EG2UuCuyEs=;
 b=uFwy9H8TeX5StVOLNJ/InMyWkiUeQHFXPe6geqa4sHV2rw50FHB/+e2OswuufCYMmwJzakVK6+diBv1LhOenQouzEC3oYiVTyfJAubaBdJ1EpuYugNYi9SiCZD/m6xhLsBQAudHAQUjjESVGEZpmFtGWE5ObagvA++rPMi6UgWT4+H03tQJWXsgK9KNL4Y441CdKNiaGMVr1GqP5qK73zZntsa34g4dtYCrb3QmvVL8F2zJbGU5FlZl7mHWI+5XOaWA9zoTVnyvGA8lNACeLHpJIuOF0Fudp/SiKQ5omHoI0ue3CeJY02nitKDZbKyJwm5hk61yJNX5iXyqzq0lChg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYIstLP+I3SMhfJZuStgF75zFke/K0CT7EG2UuCuyEs=;
 b=LgL0dE3Un8FU4KUWwN+SuUioB9KXa7diuEMp7+FNgySaIUl8dxaOsx6kgGlNF45gX9pwNuPAToubijFwm1M3SSLl29Igyh0DXP/Qc1IT5rxb9MccBaZ5G4OqsVSZ6KvN199FSvxAvkQLq5MvHpGp2me32//G9CbMhJAmnjb97yjKylG4wwjLnxEgQ1EiLNQkUb6bNYVK4cNeL2/+Pt3zJqh2pQpdIujWd0A7yeWAs4xsuJzUGK/8eRdF4CVE0Vq09YOWiqMtvnyILjPlKf5hrmzWXHelBES3GNjMKy/ILIVXPq2rq8hCBPvBUBw2WA+PayA0Rh3gIPaEgp7RrRABMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 19 Feb
 2026 17:28:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Thu, 19 Feb 2026
 17:28:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Usama Arif <usama.arif@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, riel@surriel.com,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Date: Thu, 19 Feb 2026 12:28:07 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B41A41FF-D8F4-490F-AA3D-D11D94236F89@nvidia.com>
In-Reply-To: <aZdEr32uMfTGjChl@casper.infradead.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <87DAD8A6-85E7-4BC9-B81A-4A842DC546E3@nvidia.com>
 <aZdEr32uMfTGjChl@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: cabf6a30-1381-4dfa-2f35-08de6fdc4257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P3tenMbLoB61NCjAlB4PrIsMJm4pvJptQyj2RSNSn3soT4fEeVwR4dHg579l?=
 =?us-ascii?Q?adbrnFrTKMA+JcaWuWeUPuxkZBetP8rjbxEJGMBiYf0TNgMYfcy4X7RlFFQc?=
 =?us-ascii?Q?FhiWQgZ8KNBSms0wO7kE/5I012nY0kw6L+QHjT7atOibOcqEHRbQ8YIlK1o4?=
 =?us-ascii?Q?cpIDFTg7WCcbtKfMWBUNZ0uVxjZR+wqubIxU50i0cGHXcOxLRAYWhtWj0/p0?=
 =?us-ascii?Q?8ukUayU6Je8dQXRb8fvxIdfDoi+FsFC3NVGtfFvNAKDuL//Nh16I6FNYUoF1?=
 =?us-ascii?Q?6LazXlAASrBuHyofMCuoSGZqrYZFcY8dhQjzzu9BMc4Bqz8+GYQZditG3ZcN?=
 =?us-ascii?Q?rmLmSGgjwBNTn3D6qC36z7AAXs7V6jKJ/g322XFSLv4SvTOLf5EGjJewIcN/?=
 =?us-ascii?Q?HjC0PHfFA7nx1np8OHNKyW3ZCXdY18nF+0FeSBUubGrDgfDSH/VVNw1/mU19?=
 =?us-ascii?Q?Wx0LtRqoQlkvlp40G8B6blF06p+GRZRgsiTR54ISeQoxHzdG6c7qay0hpPtI?=
 =?us-ascii?Q?Cl3Un08iPYyjBdDxM/29jbqYO8Ve3WiF4oEy4Hy1KU5xeoOonEZMIxWfyq5h?=
 =?us-ascii?Q?hKdUlPwHkMEN0nkUam3Tm2zw6E/bU2jvBOeM/gsF/lKND7s0g/4fNwGqQlVa?=
 =?us-ascii?Q?KoTOTCWgLZMoa4bGJkvi91nUaQdniUGUBIJs/yQB5IoDn6hwmMzwpXCx6bhn?=
 =?us-ascii?Q?SRAI7VfhT0LiSqV1rYpOO6+pHko+IPFksEGyLJWkgFZkSjC9/2MjMSNzmniY?=
 =?us-ascii?Q?bCg9eSC7ql7cTJKOaGB9DPnK3sLhakhkPA3c0O5acwcPrPcq5nW3ridkjSiy?=
 =?us-ascii?Q?veR/3xhOxfJQF0Rf31jX7ObusCFbIn1EuyRow8Nv6RY5EECvazyeufHjJaD+?=
 =?us-ascii?Q?TbrUymK/0VDoBfWyNS2kAScFrTFc5pBbRinOQEGozTXp8w/W624JJlal39UD?=
 =?us-ascii?Q?bKrF0fQ4tzZKa0T7Ox8BASi6WI/zW+gVkjaaF1zG0clIsGE/sUNG76lM/S+G?=
 =?us-ascii?Q?befDgPFVpVFpkiYHm3OVnr8ZKSMhA8S4glX2ghnVD2PSPnaLek3syciadkTf?=
 =?us-ascii?Q?IUqUAudgjxC340ALMseSoEWUe/KrjPoJ2/ZWWWC3G0/nYcDqUQylUfx/vED2?=
 =?us-ascii?Q?iUWNeN1BuH/R1mMOtVK950fQZgKlnx39pNH0ie5zKbsfNGdN0xY6bjSa/p/C?=
 =?us-ascii?Q?e38NOBFoD7XsPyVGKMCjWJLLWUIQ8I21MZ3icBSPDNjR4YsyX0VMBueMfkK4?=
 =?us-ascii?Q?euf3g6QBaw7fmRA4EFCB+7RFvyAN1W75m89J9Ju7cWTblZkkFgGGKaIrjj7V?=
 =?us-ascii?Q?vKeLU5yg7cACPzYQhlWjqDtqxTqQbfJ84CnWVGBnaD1ymz78OtC+sazmGN1d?=
 =?us-ascii?Q?Vo8gn3dMGKZz+Pp8XGHzMhoBijpr+DSzlyynlfvGTBcnQwKgJnudg411YiTJ?=
 =?us-ascii?Q?W8cCZ/oPXxnslGtLVowDdHy4SyF+iRVPhVWvjBugJghpSdoWGhGO71fpfX4N?=
 =?us-ascii?Q?14wOjFgRs5Jgycxv1laOp0EK7T3DomF6R5TIHaK5MaZXGFLZeJA1qAHxbm4G?=
 =?us-ascii?Q?4lJMB+ITB9wc7CggKPM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hF8Th062Hzp9juvz0F3WkEYNo43/qh/Yuz7b0wQGMVkSsoRs046FnheQCcj5?=
 =?us-ascii?Q?Dk0Kc+VDXCL2PHIGDFp9hoZ9VyelMm0OKbgEVtQKkCRfi7T35HjRkcldwe48?=
 =?us-ascii?Q?IQYJCP1Tud1eHpyyb3cE3CkJu7Ifvuv7siW14GG6FB3b7Ih/31P+TY0kLDZ/?=
 =?us-ascii?Q?0qMXqJXBG6MVQCAV7SLb9jqO7eVsGXUH3L2UIEyKEkFtRLGoNB937Mu3rw53?=
 =?us-ascii?Q?RwyZf9l/3aWx330oWuBaxf1cxgbTyBkGU+5DC1l62STS49dLB5kM55QMEprn?=
 =?us-ascii?Q?6TcRgd8IC4nqJrc0P9BdrMJboQbQLY8l29Umo0e130ML1wonn9cZ4ZJrIF/g?=
 =?us-ascii?Q?65SDc9BeBBuyDMlfGikWAnPuWWsbp5K+qApe36mOFTqTtdEkh+eHcu14ZBw1?=
 =?us-ascii?Q?aXzKVfyIguvhOBMexWTaKCKeqjiiRTy0t5D2f5xDqT1fUAjnsA6Tw/ZYnkTk?=
 =?us-ascii?Q?OcGcuPaEkbEt+0TzB2iIL8ZsVTjdTSsULyAp/HHdx8W3yADUuAp4CU3zcVWm?=
 =?us-ascii?Q?VEbNSQQNouwPCG/svKiPdK5BiifV7nOerAb555WrVohEGWtWVReqolNF8Pnz?=
 =?us-ascii?Q?jhVB7a1On4hRKK6dSmwfENb/cw96o0NAufpS0oqqdPu+fThSEHn649G+zOyM?=
 =?us-ascii?Q?gRSrmfTLD8UQ6XxmmTD4iz4bBRqdGQUoTCdFx5tY2fPYlsiB/g63S7a/tnvs?=
 =?us-ascii?Q?OrDHQv1y7WV3+8jVCecBSxMZ+w1dNpZRYSsa1H7xOulBRFTZhyuM6E9K+bEt?=
 =?us-ascii?Q?G71L66Bz9ZEQyqWdi2pp18ZAGMPZnnXTPEe5aocs/4cHbxNkebFzjiC2U3S2?=
 =?us-ascii?Q?qm5j/yG4yt7/hn+9Qz6Q6X2Sn6ajlswvmvmLMqwGcTATEMZWx1ybuxfZdNEo?=
 =?us-ascii?Q?NIO2f3AQiDYEGDSeQqkwmDoTp4L3yynsrgGnjqhGl6Qdb2QMeimpxxF3YI5h?=
 =?us-ascii?Q?x/bkteRMwSKZskejgkjACQ3L0yaGYjNmLaXClxXOCdXLIKx8KbeFEHQBd/Yl?=
 =?us-ascii?Q?E6rJI4tSiPZrG8v9qngnpjH0lLffMdzlpdSeCTs0a359PEJiGuo9VJGQaxmz?=
 =?us-ascii?Q?SrtLlDggExLfzmCrzKg64DuMWe+TQJL9jsW2vX6kz9B8j2WYPZGYSM442oHz?=
 =?us-ascii?Q?JYEj/7xXmrAhu8BMhcTIb0czj95c5bdzKaJg2TrrmiIYMPhwAz1nURizQi9w?=
 =?us-ascii?Q?HRemY/oObhH17n+J8Ok0HZpGNqcEXw/fqayrC/XJpHWDXuvQLjPkxfyUwsmM?=
 =?us-ascii?Q?mZfkEZW3EGo8Uyuiu74EjyKbQRsgmf9mStOV9I6xVT89rAbceTQsZYFAMcop?=
 =?us-ascii?Q?d3kIAjCJFmMQvv0I0KVjIO+wLAIj9VRzlJ0FdnI/fuJeIRRU40YOzXSAB/cR?=
 =?us-ascii?Q?baIgMjvQmH0pIonkMPs1Tnf9SOvLOuONaH9sZPXeF1vFua3N2oFRbfXzw20w?=
 =?us-ascii?Q?iFJiY2CAnZo5/SwDqMvn3nj/nVCyu/TWBF7WHe2+beZYSJPNNDj41wdmxpwU?=
 =?us-ascii?Q?4zQsd+4TyLGUzT3LBuTHJKHUkqm6SN8pMQuS2K03KqejuKUsRVa66w+KC3oD?=
 =?us-ascii?Q?oXODLAUipHfNWBT0KM3ZsSwoX2b1zIEFLUEOcZm9kCCgqGUcSU0HHuWWupX1?=
 =?us-ascii?Q?rd9ajJh3OBcg8vS2eKtVNecDob0IXUW5zG5LvnA2m6m/Xo82PAp9DOYhq4hR?=
 =?us-ascii?Q?WtoxHzVm8Ren5KxsTTDayD2yRs8isC8DtGY17aZ2XrBxts1yCcm/I+6b+hC+?=
 =?us-ascii?Q?WQy8On//hg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabf6a30-1381-4dfa-2f35-08de6fdc4257
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 17:28:13.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/IY1635N7hV99Ymf0qdBw7qKCQ62iwbBK5RzBKxxvCJaFiEYu9wnJhuA1Yxfnkb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5234B18000E
X-Stat-Signature: doeg577f4936ik4io3pt84xx9hs8hpry
X-HE-Tag: 1771522102-179501
X-HE-Meta: U2FsdGVkX1+hQj3Qv9Lfh2O4z5j7LfqpdWINDso9irA/jnXd6H47DTstI5V0jmwdeb2Hql612uW5q4cY5tZKTmGWeYDMftU8AFSRqh/en4C56GIhl0AxPQn79u+gMHYK2wrDk66v9Rj1HOabGGrAwEsJxDqScqnYv9/Zm1A/x/d04ebVuImISBoqDXFXeAU+V+Z8ZQDSNNkqDLQ7eGS1o7p2NlUX8g0aZj4BhnC3AIiKZukbBBUlvqnPPTg1SVCYPKAhFq4uym9uxWpCC55o0Mf2jkg2WfUPBY2ehmdnJecVB02FmoZaCZg29GhZ5nzMzEag+3jjeumLNzrD3QDvKiUH2aRvPGhGxS3MSDdXuJY8iF0Idyy8EfRFuWft2arb+kfSq4kKk0lZqh9VjT7gFsglTAmvN5B9if0QfHUtkVkhi9wcVabK5xB4+rwLZanPjquQ6GamDvjdJZetq84n0hwm2CAHN0yQNDOMlCEWmonAxo0bYU+HeOYW9bArjuYXFL3ZPIAc22CK4PDVsqvswKaQl4yyTfyDiPYq6aa2m/fIdG38xvPUXtJ8pZyrMdZFP0todx7xsi3MZRscrJFPlS3bWuz7ML3iVwqE47okG02oBQX+0XwosQQdNh93UZVqNODJqN7z2bxFMdT8yGPEtijRxqLE9FXSoIS6/n28LhlHzXlUhteeGwyx7N3CN6Y1fxUcma1KVEiIVs4QWOw/x1mFCOBZBGtQIC73uaOK3KXN5ZqQKKKSAIUiUPVV4i28pS3RWJZVwFVGi6dcJshxjG/yXIfY4CtOP0r2g5dVopw0vmwDlS8BYzZGiKcvTl+kCq5JqnKiM34FGn3oIuA9kk5vH7w56zlXwmrErAs6A7JFLNAo5Vp5khhlJdwTCK+Pm+aRQAiTuVcm7cg+1RMYDQob8tvey7BM20aLAZeQu1tiR2/HPH4H/hhWWZu/IQJH6GYT+U/TpeVohjTsh+E
 dWMVcGbL
 WWCUR0ZiabSF3tMDVJkIByNh4ttXTzTkmSsSvc+QblSQkODZjpce4R9tHkugaM0+unofOz137ik6HE4Iib4tPmA7dY4u6Wm2tacN1lgHg614VtxKI2zs8qo462Y8TjAR8JE3JpwpXsqT3v0OT2d4C60vML4/+V/DqYYRrIBm1Mry+LFev2Wj6vCeRYVTMT/LQNiOjfGNI7WTHorIX6Nh20UzE41yClUvF4zIJT0/1S5PJ3W9bTdtCGQ+q6X3oVMII0rnjjx15pW43q3yJRvYUAxSWHgnOU/qnldFQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 12:13, Matthew Wilcox wrote:

> On Thu, Feb 19, 2026 at 11:49:27AM -0500, Zi Yan wrote:
>> If HW can support multiple TLB entries translating to the same physical frame
>> and allow translation priority of TLB entries, this remapping would be easy
>> and we can still keep the 1GB PUD mapping. Basically, we can have 1GB TLB entry
>> pointing to the 1GB folio and another 4KB TLB entry pointing to the remapped
>> region and overriding the part in the original 1GB vaddr region.
>
> Uh, do you know any hardware that supports that?  Every CPU I'm familiar
> with has notes suggesting that trying to do this will cause you to Have
> A Very Bad Day.

No. I was imagining it. :)

But thinking about it more, that means for every >PTE TLB hit, HW needs to know
whether any sub-range has an additional translation. It is easy if all sub-range
translations are present in the TLB. Otherwise, a per sub range bitmap or rewalks
of each sub range is needed. Never mind, thank you for waking me up in my
daydream.

Best Regards,
Yan, Zi


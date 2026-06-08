Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B29D8CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A326B0005; Mon,  8 Jun 2026 11:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05A46B008A; Mon,  8 Jun 2026 11:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCF56B008C; Mon,  8 Jun 2026 11:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76176B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:36:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7156D1A014D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:36:52 +0000 (UTC)
X-FDA: 84857148264.14.8346019
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E0A0100010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:36:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ARccvoy1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiNBNv6ygkVTPnjFQNiaC8DdFRx0BPCbbjg1Yj1uquc=;
	b=WwYGzw14ecftpCc9mrjjZlCRckpYWg7c1nj48O0ktPFy6DpDkFBOaH+OvMhb6UkhiL9rS9
	6moiuAkwUFiNGyYofAz3XNMu0JI87oybHbBVLI9eOW/6T93bzmfJoEs94jxwfG60sr1ev7
	7KFi9YkaCDLI1XD0HztudMJLFK/53BQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ARccvoy1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780933009;
	b=U5+jBcW3XFvdyYLGgZsq/2znx2r+n2Y8fI35F7oIMzJx5kNsgerjVhv361ib/kx28iMtQv
	j7TBWHfZ9+dSLdc/m3s50HOJ+dVjMOOBBik2fKWUEDUTf1rEs8ujl8g1Oa0xx7pwX4pBDh
	+OMkEorGW9WFjQoztVJmB1NWMY/TqjI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KN3hRSXL494tf3h9dYSyDylrUjKwWFi08nlgxAVc73i14GjKDJfME2wPOPHs2tlUOVAlNVVk+/LcKs96qG8/KHzqeLLzI+V4/b0OYre5z6GuVqiVt9F6AJP5YoIOtO+6nY7qhmC7zdM85Qt+RI6dIvsGQnjUgMNOF0a129sslXaBfnMBB3i6mBQ+3Hmnr8Wz23h8KW38vMrwipzzssYaI/yPVNqoIDJ2JMbLODohnhZjeOdGbtQBS8tGHXZ8kroTG+d6A2Ww6lcV/oBZmgiv2U4uk3pBx7rM5dS5OntewujlWet3cXRJUomTiHxxK8E9/7Rb5Jkg1Tt0iTZuA8jKGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiNBNv6ygkVTPnjFQNiaC8DdFRx0BPCbbjg1Yj1uquc=;
 b=SGVNEYSEJn+JHCz9uU6s2mQojn+pdP3XC07GF0moC8/TuDDQCSw20jKWl3+vZYUccKNhnB+8Riz/WVHBbqv7KG/TOP9mr879npI0QxljSC+TpQJ94ggXvEARKmQti/Kw7+8DNvHa8g2Htl8IcHYTkSigVVK+4RajaqDGlhvflXo3ikGAXR8c1LXVmY71NQ476YW1kmXF0DSqs1ldJHwmT+mrk9Y8P89TQGttuPGMQAz9S+zmP/EdbR1IKCsPfeVZloiOuvdEw7/edhgdbYSaRVK5pgAknDjqbNYeuyNHqp1OfHY4EVUIRF+cYG1A/u6+klpG4/++rcTnaL1cW/Yg1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiNBNv6ygkVTPnjFQNiaC8DdFRx0BPCbbjg1Yj1uquc=;
 b=ARccvoy1pwGrC39GHSKtZTh0ilg0D5d7d1Ik7P/j6JChe9MqYSU/gwQ6vCWlcjTkoePGXn2J6n8FjDWwN7N10WF2Rt5idn68Lf+y5VXpWqcXUtgWunOqJmqBSJo2V6RTNEJne0Bm+m86sqaeoQEjMXhgna1wIwyfL2Gpl8qSZtE8T6K7F4ET/XpJlsxA2K8htsqAtm9lARt96A5rbXptWu4f4D0VLNOiEpFg/uXGpfDBmPGwgYInGdjXiXLDSCxlI6VQfFOBG2PGSNCihygX9OedxhAu2+D4lXaykE0VpibwF5tQVdzH6BItaqFuNs291vHw/ONgO6S2jsv06HZaKw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6982.namprd12.prod.outlook.com (2603:10b6:806:262::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Mon, 8 Jun 2026 15:36:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 15:36:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, rientjes@google.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
 hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
Date: Mon, 08 Jun 2026 11:36:31 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8EAC3D9C-6956-44DF-861F-A4864F08273D@nvidia.com>
In-Reply-To: <27f6f5d6-e81b-4e0a-af39-b175187299e2@kernel.org>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-10-shivankg@amd.com>
 <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
 <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
 <27f6f5d6-e81b-4e0a-af39-b175187299e2@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c6ee83-8794-4a4a-5d7f-08dec573bbbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RMlcPWJoEYb/wc2ZNuVigHWOq7faaKMLKTDxNezqIQPTxNwm02I/sFoNHOZbtvUgqfhTo9ArigMieOssB5xS/4qsOxs+n+ncaH0D6DtryHsXX/ZdmPR95eBZ/uGCeavylTP3r1LcLsHCXIPbhFqpbhR2nfAMT9oK0Wjt+nByvs7YQ9992HKK7RR+Jb+LxwRGSSqayujH3j9foMp52IGGY1Vm4Ug45Qt30wl14Uyu4QM0otg03wyjshGsv43ObP9DoRFJvsnD7ie46h6MdXxoXHwRXzbLjQz0bWfPss0Se2bh7Dq6kNL5pYhYhZLSHNxMMTj2KPLCKyx7UYpvcRnmE9jyxiymelt3dVAPnONVrD18CPNilsf+bDk6QtyWgBJk4exSp/o+pw8K3z4HRDseiAc6M3jFFI5c34vrOnmwB0neJMKZbDDRoTV8jcFY3avc0Kp7x9mjAFqij3gbEaQ2gRoQZpabBUrJ8rFlKnBpB6Y5tO5+FAQhqxkZozvfJ+z2l1OURI6i7r1y0fVxuMXT/0ljRg/c+vu991aaznNTkKsE9ujtyzq4LGAkX/PWyVMPId68tHBKmm4L2Mrm112KwfsSKNNZ97Qik/Jc/MpMqENgQnN5XWA0AAGsUC1aRubSx4318UWMVNd1/TGjY7nTj1mQfGdF5t1uq5fBt+d+bFTExb0OSs/9cNwcWaN2ok4I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JL6J2wQbNfZHXYLlc4BFW9u2oT5htPLhpM9kdh363hMvtG7tjcJOJFNo0Pcb?=
 =?us-ascii?Q?RGMa+yaAo8w1kmPWYn5gFWFHcuGPpJ/i8MKl8x6+t9tro6S/iuF722imriwz?=
 =?us-ascii?Q?6nh4imbgGnRZNW5BVTWmmSHK1PSjf9aaIugAkw0i41CRCu7bFG0U2bJw6llC?=
 =?us-ascii?Q?5enjyWy+ND7INX3Kt7gZ62hKk5H59MPiCmVN2x1OzFthyQHdQF4JxZuhSkFl?=
 =?us-ascii?Q?P3cAcuPASiF+GwnGDpke43MxwgeQsKjf/it9X9v6cuTBkLwUe0o33hwtGW2G?=
 =?us-ascii?Q?bUvqXhO977W689KqWCPVlgz2Y5Qdm9JKIm8J1IGBcY2VU6M6+ljNmI3WtkAs?=
 =?us-ascii?Q?U3uAvQFtqlv8+oEgI6SZHnERnFti7CoMXYn75P74r/kYnnJrS5UQb+EfIcsH?=
 =?us-ascii?Q?Ndssw3GLsebqrBjUFve6BFlrtoNGtCnbrMIZVmV1qJyKxO4SsRkGIHTrQHQ7?=
 =?us-ascii?Q?W3/ir8MgVX0qNKvg+ESbj3MhKWQU2HLIpoIlQl3U8pQmjJZx6mZ96TAnPhns?=
 =?us-ascii?Q?ca74B+5nTVxoZ2VOCLM8vIugq4yJODupVTmNARpdJcNyFrYWlGHe6bLtGuKO?=
 =?us-ascii?Q?Kpcq28MJZ6cRvhh53rFhiokeN4T4e8Jy5WZjmXcgjiLnrc+1Un0OUad0YyqZ?=
 =?us-ascii?Q?flhDtOkx/IQKw3K2yk9WChkhennVtYWiDxK49399wYTIxYMhg2x55RMsxiDx?=
 =?us-ascii?Q?hGe8/9vOZlf0GEXk3l3+HF1zWi5PGwjVPNpYbOs+vvRb4MhrOnB//CHUfhMF?=
 =?us-ascii?Q?VTBS5rfAeJqZw49sDofo6OjMmoKUMR817He3CLJ4DHMHvgqw1OnSOBUWeIy7?=
 =?us-ascii?Q?ny9YvWebUFkt6qcq1UvW6eJW9d9Iu5PzSXVO/EwJz/RzkX5oHP66OCWfVU1T?=
 =?us-ascii?Q?D5n6XRXWmnMdAERydWDYoTtgk44gDpo/MpmJdz3RUOVYCe0V4EueWRCA3u6z?=
 =?us-ascii?Q?9VXcZ90mnY88PnpxXrloG8ALhrfWkKpsSTRqvz5IefmtpciFW+I4lE6sYTJW?=
 =?us-ascii?Q?wNanXabSVhkWijrE8KmIbHS7Sn1UmrdoeLmcUCLFG0Kj02CpIhaYPVTtzcGM?=
 =?us-ascii?Q?sP4g52m0lx5NWnEBHQA6Qn6WISsZ3b99lD3nP1bHpVFT5ALEqPBjKiJdIOJY?=
 =?us-ascii?Q?yDE2ZXibCrf4YGbyacUi+6F8WxpwL4KLZR4qC5W0V24+Gx/7Dbfzt1f8DlfR?=
 =?us-ascii?Q?OfPZ/XTjWSZ72FUboEXqTUMPfgIF3xD0GtR1iCJW1RN5MV5CcrkUxRZ+v/8G?=
 =?us-ascii?Q?GbaMsT+83wTYWgfzlqK3nhFT0nAGVNb77d/J2/+ICjlTPQ1oOzzUkbs35x4k?=
 =?us-ascii?Q?8E20P0vgVz3SqI/yrvZ9U6/erV51AnMvZhLeu88nvfmXeUmyh7JhU1EJyE/S?=
 =?us-ascii?Q?DYZ6sSOxFioArKi4dPR8h+nWYQma1Ll6+51ka460HyqZBUGQOi77e9pmL0+k?=
 =?us-ascii?Q?wC7PFwldKyp42lYrsF9aW79w4J8rVRexXTz6dgVbODMmRebIeT5+Cr/P+tAb?=
 =?us-ascii?Q?jc1zrf5XVpGJpc7BLRWAhxEzPLla6EZR4T/9yytMvN2sBjbmGklZkpOu/pIu?=
 =?us-ascii?Q?cYj3VI/k7P/nc5W8Iwz5p6QmyX8ht7r3AofWv+kv/nBj251wsGCGhYUcYW58?=
 =?us-ascii?Q?a8arkYO/r/Gi/sz+N0RcFQJZFX7pSFxstA1eN/ZffgVGv/JJvS8g1mOu0UNU?=
 =?us-ascii?Q?seO9YLROKyJ0DLmk8g/hvXZLCIyv+PA7G8+BBHl0mx/eUqzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c6ee83-8794-4a4a-5d7f-08dec573bbbe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 15:36:39.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Av9LTRz/aErzAcMcdoPWL5Dy7Q6hmWqZdtEg9xELT9nrlJAHudNta1vI6q5cECpw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6982
X-Rspamd-Queue-Id: 8E0A0100010
X-Stat-Signature: 5tw1km1149cq9ki76fdxwzuwcm1mnye7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780933009-131818
X-HE-Meta: U2FsdGVkX1+E2Udd0eI4iYMvhErYVztGe/41WQYBTbMstUDpwq4O4eV7Z2i0TaCMUt9NBK18QpCLT1WElMhzEo81/YvxkTUX6Yq6xhJ3zsoRVZHhwjjpbrAjbEyc40nO4curD9S8V5blRAoeDL+Z4yda6eCVgwlS1SG4IpuopAYdudbq35P19Vq/bIh4CoWgHGWdzqVeJPdbqG9YdcAcgQUAF0KJ/70nHHNVe82S7f2VMhuCQpDWPX9t5DnM/oi2rNDOcVJdqAUwEMgLvbrBIX705unz2UAoImmbiyLTG8Wi5bzXCl1+IUZNzD6Vu/Ec4edl0cnymDmDTIxLMRXM9JBOU+Uep9LQlsrT8ny9IrziZS7lsBwhUqhwAQ1eyRRM7Bn1eoOJnsChUVibT+xxv+nuxnYgqCVv/8k5wSxgp/KgbN/5pnSX11LcS20VQjjnKUSJRQ03NbxeowukP+G8Il4gqZ0/1mRHFu3mGzTCF12Rv7sfx15/vmcnpw/Ivxt+FAbZ8QJaK21F6NIdqxOvvz9xSCK/A8PgyOkJ+lPeNpYm6AJrZbNzTwTKDxxZavaSo3vAVBQ9fK8qT3EGWafi8vB/CypdoFQFLosVXcoOYVsqnck2DRREfHmA337Oc5MI2s7vueeZH9lnrdmHWjPXB7uKezScBfabO9dOVzPkVip1ZaBZmP3hixQ52AaRw5Um5d47t2NszgjzYo5Gvo/QrcYn3lqc0uLY2HZKkG+yO+acXZTE+ALyM1+PvMA1Z7y1kxKK/CMbFuHuHFteAn+OFbvI1KFETdvem3HUF9tkoV+KgVOQaUU6wFBYswZRLeKw5r+dDUW3fzzz2h6dp3hK2i+2FAyC8QtfygRTOUCtMF/mUAzCxMtVwV7pZstMHwOWyMjUeqrh6lTHBpU/64U9t889Za5mjMnKKGTpmywCbZb/O/lURL8Sw+N64R9WDv4+mMQbbV2MhC8DE0JldLa
 x3gIplG6
 cC5tV94fSmBb1DC7t2+OiVp5xk/eKOVvEB8nuTNc3usL91yOatpJjWenP+wAPT2Bx88Ac3RsSX2zVgAehkimKhEpAj/y3qFL/uNx9KEdKBG4FDQYe5d9Kc0vkdaWO/AsTU7CFe5LJN30alqGERI8N+LYtFzOeX1jWpNZp15Dzhrwn8grYUo8KtM3MHMS0/hIP2drcNTORv3wpz4uT5YuUDP1400oco/vAOcSGegI5xI4ELltrXVT8ik7hjlM/MlNSkagW9rPm6zXsnsVbZZw7UDk3XmkhAypVz9hhFsPqhc3SRm6w1qm32zNPPMskdNDXY2fALJtTzdzJ/YHFSGUJ1/NteXBwUuuLBQjGKgr2NwNXc1euSfPYTC11gtoxvYeEwTSue0s2hhegLKfHNotSAnjDndAqaOeqRhBJ5WcwVhwXy72kCu7TI6WgxgmEJTC3imTC87Lo/2GSgpugKVtFOlK0vqoT9/3U4mXABA/88Noe2Syi8KmzH0g3FuEMTfAP5Jqp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 11:25, David Hildenbrand (Arm) wrote:

> On 5/20/26 17:06, Garg, Shivank wrote:
>>
>>
>> On 5/11/2026 9:10 PM, David Hildenbrand (Arm) wrote:
>>> On 4/28/26 17:50, Shivank Garg wrote:
>>>> Add folios_mc_copy() which walks list of src and dst folios in locks=
tep,
>>>> and copies folio content via folio_mc_copy(). folios_cnt parameter i=
s
>>>> unused here, but is part of the offload_copy callback signature used=
 by
>>>> later patches in the series.
>>>>
>>>> Split unmapped folios into batch-eligible (unmap_batch/dst_batch) an=
d
>>>> standard (unmap_single/dst_single) lists, gated by the
>>>> migrate_offload_enabled which is off by default. So, when no offload=

>>>> driver is active, the branch is never taken and everything goes
>>>> through the standard path.
>>>>
>>>> After TLB flush, batch copy the eligible folios via folios_mc_copy()=

>>>> and pass already_copied=3Dtrue into migrate_folios_move() so
>>>> __migrate_folio() skips the per-folio copy.
>>>>
>>>> On batch copy failure, already_copied flag stays false and each foli=
o
>>>> fall back to individual copy.
>>>>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>>  include/linux/mm.h |  2 ++
>>>>  mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++--------=
---
>>>>  mm/util.c          | 30 +++++++++++++++++++++++
>>>>  3 files changed, 79 insertions(+), 14 deletions(-)
>>>
>>> [...]
>>>
>>>>
>>>> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>>>> +
>>>>  static const struct movable_operations *offline_movable_ops;
>>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>>
>>>> @@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head =
*from, new_folio_t get_new_folio,
>>>>  	return nr_failed;
>>>>  }
>>>>
>>>> +/* movable_ops folios have their own migrate path */
>>>> +static bool folio_supports_batch_copy(struct folio *folio)
>>>> +{
>>>> +	return likely(!page_has_movable_ops(&folio->page));
>>>> +}
>>>
>>> As these things are not actually folios (and callers will have to be =
taught to
>>> distinguish them way, way earlier), I guess you should make this
>>>
>>> /* movable_ops pages have a separate migration path */
>>> static bool page_supports_batch_copy(struct page *page)
>>> ...
>>
>> I'll change this.
>>
>>>
>>>> +
>>>>  static void migrate_folios_move(struct list_head *src_folios,
>>>>  		struct list_head *dst_folios,
>>>>  		free_folio_t put_new_folio, unsigned long private,
>>>> @@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_he=
ad *src_folios,
>>>>  		/*
>>>>  		 * The rules are:
>>>>  		 *	0: folio will be freed
>>>> -		 *	-EAGAIN: stay on the unmap_folios list
>>>> +		 *	-EAGAIN: stay on the src_folios list
>>>>  		 *	Other errno: put on ret_folios list
>>>>  		 */
>>>>  		switch (rc) {
>>>
>>>
>>> [...]
>>>
>>>> --- a/mm/util.c
>>>> +++ b/mm/util.c
>>>> @@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct fol=
io *src)
>>>>  }
>>>>  EXPORT_SYMBOL(folio_mc_copy);
>>>>
>>>> +/**
>>>> + * folios_mc_copy - Copy the contents of list of folios.
>>>> + * @dst_list: destination folio list.
>>>> + * @src_list: source folio list.
>>>> + * @folios_cnt: unused here, present for callback signature compati=
bility.
>>>> + *
>>>> + * Walks list of src and dst folios in lockstep and copies folio
>>>> + * content via folio_mc_copy(). The caller must ensure both lists h=
ave
>>>> + * the same number of entries. This may sleep.
>>>
>>> This *function*
>>>
>>
>> Will add function.
>>
>>>> + *
>>>> + * Return: 0 on success, negative errno on failure.
>>>> + */
>>>> +int folios_mc_copy(struct list_head *dst_list, struct list_head *sr=
c_list,
>>>> +		unsigned int __always_unused folios_cnt)
>>>> +{
>>>> +	struct folio *src, *dst;
>>>> +	int ret;
>>>> +
>>>> +	dst =3D list_first_entry(dst_list, struct folio, lru);
>>>> +	list_for_each_entry(src, src_list, lru) {
>>>> +		ret =3D folio_mc_copy(dst, src);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +		dst =3D list_next_entry(dst, lru);
>>>> +	}
>>>
>>> Wouldn't it be cleaner to remember "already copied" immediately after=
 we ...
>>> performed the copy? (succeeded with folio_mc_copy)
>>
>> IIUC, you mean something like:
>> 	list_for_each_entry(src, src_list, lru) {
>> 		ret =3D folio_mc_copy(dst, src);
>> 		if (ret)
>> 			return ret;
>> 		dst->migrate_info |=3D FOLIO_CONTENT_COPIED;
>> 		dst =3D list_next_entry(dst, lru);
>> 	}
>>
>> This will be cleaner. However, it will make the folios_mc_copy() speci=
fic for
>> page migration and can't be reused by other potential callers.
>> And offload driver (like DCBM) must set the already copied marker
>> themselves for successful copies.
>
> Right, maybe some helper for that would be possible?
>
>> This will have an upside that on partial-success (even a single failed=
 copy),
>> it will no longer forces re-copy of the whole batch.
>> If that's the intention, I'll move this to migrate.c itself.
>
> True. I'd probably have to take a look at the end result to see if it l=
ooks
> better that way.

Maybe do this optimization in a separate patch to make it simpler to revi=
ew.

BTW, the whole migration code has become more and more complicated due to=

batching at different levels, I wonder if it is worth the complication to=

optimize for the rare memory error case.

Best Regards,
Yan, Zi


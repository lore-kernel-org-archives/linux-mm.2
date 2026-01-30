Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE19AD49C92
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A4F6B0093; Fri, 30 Jan 2026 05:54:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3156D6B009E; Fri, 30 Jan 2026 05:54:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA546B009F; Fri, 30 Jan 2026 05:54:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1057D6B0093
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:54:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D03215948F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:54:42 +0000 (UTC)
X-FDA: 84388322004.03.0713241
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0DAFC000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:54:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GinAugHY;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769770480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
	b=Rn8Z/5NxEQKm56a1TplEfU7RuGaIRIyZMAngCzYHSMBpxZK8KS4kzmicUqOnzgc1kR8pl9
	p9KeeAXXWs97c36edKiWUEXRG09QIK0OU1/CdZtPnmMth+rSEqVzt4CfWhz0aiJhLUtFDF
	BM3tg7QB3TEzWmRuH6odfhm4jjF+thk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GinAugHY;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769770480; a=rsa-sha256;
	cv=pass;
	b=vWIS+d3nzNeen8dBdNQu0zbtWfbyjeWfR/JJT8UFrvGeKtc9OE6trHlvX6ABsWeoYt5HFu
	o6dkApFl8b8a8t7FihylyLa5Jyi+UE8LgZ2XsEZ9xf0sEWVvOEpNy83pCmNMcLiGAjDeHu
	bsRp6D3M2Ug/JF3gCvdOUr6PeTBE9O4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NUo9VsdIzhDyPRmgdh61WqLGU/2bmyyKM6CjC4af/fKwjWz7oi2esOsgXSJyPJy2AC8HeEmdGHnbTSRF2IyZO1OX6IPcfu6MtJoybpxtIe9wrF1N42clekqeWg61sWj5hm+qlMMheog6m3WrizjvezUcW4NCCfHUZ0Mt976AfLvo5ZOQfAxzmIjq9v1tWk2SfXDjFpjLv6aKun/H+aDRAEvBCz2NIzRg03keryCNFaVuE7i7q8tGdf5p25P2HUQl5MknkplsRsG3dMwE/7Cw+U9YninIE4/EYuT8bWA/7Xiv7HqJ+lr/qb2O+iP0DG2WQa5K5H2Vei+jMBWDHnCAHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
 b=hdPXOw+ErBL21+6SbAwN/UBJKTlmpCNDVqCW0U6AG1aFaVLxfjcoe3FOsQTHxHNdwqVHHOhkNZ7c0c76a/0ExHb9+pl/Baqm5l1s+SUFzjeot+YkvBtvGpraPDmfDSGfPA+k1mOVGmGYORAnS9PgFO2KSJDOi2PCfzP0Ke5QK1+MBUt2+dukSKlsA3UBHXdnbSZQJ6sgXWnXVb7iP1ua3J60Y8LEeOefkq21aLYnaxHQhpbXQJhGm5CA4YE95xl34giOaDA366xZoEu5siWOx5OSvnrUEUigSfmT27GxjpLmVTfXjt6sxTNsP/w+bU4EMdbBTAoEvKjndKk7J/ECOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+sCdI7CXE1phQDuSk5W5X7UWsQbj3O4orbU6eVepQA=;
 b=GinAugHYGH5JYoqPZvfyGpx1WicYW5YEUf0t/RSjUVYeVLOKReGYR/eIVFz4lfdpgOAK9g2w+xQKpxxrPatyrmOPrdY/6XaDrD98GTxcNN0XqdWUkPr5gde1DTrHWCsWQZhGumMcCFE6eRTkAWJU/ROvFOl2rw+hfQ17Sk3HqRJAkn0CrD0Ok9kAgtxfpzlH1oiTPXjtU3cHuLgkiI9/psXTdHr7VqQxvVahLiwbbFb8u1KU7CVSU72hGVhPk8Z+GiMSRNVl38cLjshkesO6uZg9Si/FZ/O2CSyQlvspCXFbE+PD+yUx/bnA7qsSLiwi+fAkmrHngJ4xJ05VJL4MwQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 10:51:43 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 10:51:43 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v4 12/13] mm/hmm: Add flag to track device private pages
Date: Fri, 30 Jan 2026 21:50:58 +1100
Message-Id: <20260130105059.51841-13-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130105059.51841-1-jniethe@nvidia.com>
References: <20260130105059.51841-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::29) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 3418e7b0-97c3-48a1-a2d0-08de5fed8e78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?igNSNrF68+BbbpM4ltpjPa5H3rKdk7yqMnsHnxzL5ZNNqgIpouP4Y/9aROi8?=
 =?us-ascii?Q?2b0OCruXHl+V+jz0c/fs5mQkXeS4pdLxPd6RKBG/l3igdIUhtGRpRV/Svpfv?=
 =?us-ascii?Q?m1o0Lx7MPErPZG8XriPtmwNfZMa7e6EbmtRcgCVWTyMl+gcRi7bF0KROdk1J?=
 =?us-ascii?Q?GythlzhsLC7LF+fcR0Lx4sXEDy4juocD/e/URhDApH2YcGtMy99T59TpXGa0?=
 =?us-ascii?Q?e1pR2LbY6J2ibvWs9vU1YNs45adyuJfMIxKkQcR/0i4uzjrd/Wp4uJshiHUE?=
 =?us-ascii?Q?dLK9Ru0cmKBahfKsSkQabVgGGococUBkhp8IoUpeUA5ACYD4/DoO5hGAqnvA?=
 =?us-ascii?Q?b36xySNrBJzaocm3HXsrykq/6M9zFonTgUAjF1Jej6uIH+QXSiwMrnJPlHou?=
 =?us-ascii?Q?dswPeUSYqba+wZ1WD25z0dZIJQTsWl9HKLU2ROd5YzBW0QlN0aeYESLwYwwU?=
 =?us-ascii?Q?NxSGTtqq2jfjTnf0PyL8eq4aapPaHzsojZ1DnrEK6MOs/Fyr8bMxluri8gwC?=
 =?us-ascii?Q?/vFwYYZLlO/aADJM/6/C2Y+4Bbuiy0oRnt49oESZTnehI8xvUICcZs47uvxu?=
 =?us-ascii?Q?3FJTEr5f8NvvjERlQzzpEcCNq508gi4mS0z0Xh6Cg26k5LSR2w1c00pQ9qw3?=
 =?us-ascii?Q?8vy33d+s6baYVBVUL9EcKC1aPaoYquKR4kDUuS1QupTdKszQv548TzUpSzPA?=
 =?us-ascii?Q?QPwmpnbLqKNcovg21HzmZW7u8jkNvTaQj99AiGaieDF8h8IZpauquA3JdRZU?=
 =?us-ascii?Q?4b1aQ/LJ7mBr3icM0d0D/CeaslsjWJ5cKtK/xwzHIhHXMOpHpYOir2BiVZUB?=
 =?us-ascii?Q?x3NUiSchRjMlzy44nCRSZPHvUMeN5Ls+zWw7bJ3B8251R9E6D1FWz71uFOWq?=
 =?us-ascii?Q?yrkttl4rE1/HxlcxyxDRMqY8h0DGpM2g/Vq5vCZu8sd5BfNAG9t0HHly8lcp?=
 =?us-ascii?Q?j/KvtZtCCrO/1zKCvpsnicEaHDVd0Z7Uf7Z92HSEQjuk2vBFrDJRoR8wpX5G?=
 =?us-ascii?Q?Q+RDa82yI2ukCuiXkIWIkBr1e1l01LxxOtYIGhBfLHNU3PSI1kVKBte4IbLi?=
 =?us-ascii?Q?M/wQGGbBUR5AY9BV0mWsB/vpYffYRiLccGjSsc6tukCsQTC5AJsdDsvqYJKs?=
 =?us-ascii?Q?k/uhQwEESWycPtT4nZUPjgBfmuwvwB/6lDJvXBcZfsXdm1hjmNYMY0OIXQcT?=
 =?us-ascii?Q?pgCui7mu+VFwB3fYqGghFhlMOlWMgSL1DY3xQTrbA0niqQcPAvWkxFMdywZf?=
 =?us-ascii?Q?Xbyq4pwihhjXgJQH94h3RHLgGmDkFQpJTO29DGHay6B3/wU81ww71jd7LU5y?=
 =?us-ascii?Q?mHGTLbvHVhkVa8NX9PagewvdR+KbXASi8dhVvaZ9fAfRtpPVUkUA1Iu/B701?=
 =?us-ascii?Q?oeu1xmeqmUe5MJixjU3Umr+xdR7jkrRnoC85JemwYLhLZBo7bwfZUWZFusQh?=
 =?us-ascii?Q?n9LiXxKuk4Hf01cDn6aycHmWC8VV830cQ4l6b3gEGZPCcf0+CHTEfPGKt59W?=
 =?us-ascii?Q?cW5dfocxlR1UNami5UM+WEPcfDHYvViuTjjHS4uwtYlfBYZx0PLyk+yo//Lh?=
 =?us-ascii?Q?ZEMhgpMG+FPqnLjMK6A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MZj8jZwCSHw5LWn8ZlOxoNxqZ7kOyTLTdZPKlK5vfBlOBzW2iC41j5npgIeW?=
 =?us-ascii?Q?l/7cyesqbX33xCd+vK2q5ksEFOd2FJsp4XX/7/DdjQXm8UGXvHbSj5WHGPyc?=
 =?us-ascii?Q?/BgW/kZbUoF3XMp4TC5wjUiw6RMwQ3+1G+aRFs00Z+qncdxuKMMrKMX+7s6U?=
 =?us-ascii?Q?D/hj1nYP1JLpggwojRd+SfBO6TSuCLCJEgQYnQhiOmf0wadNF55IdP09cQ+K?=
 =?us-ascii?Q?EmLBZPNZuDZLGtwh8f1B48eEsy8OTqRdUwgLKJHWSU537gnr9qDxiF9iIVlm?=
 =?us-ascii?Q?nb0zVCkVT5I0BsV38aIujBgWtzB4BiHVd6mUN8mk1y4opLT02QCakkES7vOU?=
 =?us-ascii?Q?CClg+DcssyLmNbmX+IEuDuoxa3Tyfw33yXld7/w02l9Xr0t7jjtdHVSfNUxn?=
 =?us-ascii?Q?mIB48yUId1nx+kUC/Zwsv3Uw3uMpo+ObZ0BrolNpONFsmdCc5bvvdat922CZ?=
 =?us-ascii?Q?IAF5kezvThYk4AqSwbZ7lT706jfOY16QycCFh2cjP2r2S8QaIP7kCK2aLrtk?=
 =?us-ascii?Q?A6SQM3mF4MFx1UzSglgol6gqy9weeIRcUFzzCUjgCVjl6YhmnU45xNtl6aUE?=
 =?us-ascii?Q?hVeejITHOruTxm+Ud7NEQCIuPWRZ+9F2uGEwjl3Eb0L3lkRpf74OQYtZ+Mby?=
 =?us-ascii?Q?gWyyw+oaux85ylHD29ylzHlVjORyjkhuU+z62ZqLsp57+h9FccpDCJG6DcYz?=
 =?us-ascii?Q?A3rZrvguXL6mpXastt+loRaxMfNXhJNSUjleap19sjz19A2lkREbbVckIUuL?=
 =?us-ascii?Q?J9FL4u9b2K2000mmbRXHVhxG9WWiIZDtIKJQzz0y0OleY9EEctVWCoIWYiG7?=
 =?us-ascii?Q?sax03Q1fDo046ogVvCIUoKl9od7uwDh1LXFtPVGeWpcwqp/3GDP+en9qwl+n?=
 =?us-ascii?Q?wUYQI0QtEwBlhyPuLHbACC6+RQbgLGJ1DflKO6zsMvU325GwT031k+5VLYJK?=
 =?us-ascii?Q?gopibL7B5pQqOc3SCYSykhziFAOElTZnW7PcsAVMU/XujCVpi7ILVt/YSzP7?=
 =?us-ascii?Q?h6ooYtCdYu74p7XEXGBtuYJOa8Dq9Vg9vAq6o8va5e0RsWiXvXTRrCTwNh+7?=
 =?us-ascii?Q?pvWsBon292UdvPcB0GIZcgR1LLnSvb3MQG5iVSSAlhRTCOLYLn8/HaWyTvTX?=
 =?us-ascii?Q?wEniKCMO7zBQ/fmQpAiaJeof1s420cYUzG5pG/AV23vX4oZyQOWNNSwNwj/I?=
 =?us-ascii?Q?aIozT54H0TOcgTm8hVaFsbObFFMrFeEA7JHrlRm632OEuwANKsf4sttjikox?=
 =?us-ascii?Q?S2FtlovZhXNYkZa6Jm3HvUX6e5LslTG/M+hRi2uqH3WdxCL1GouqDJY0gO9o?=
 =?us-ascii?Q?LxXIrAOnmWUxmNXLCz9ABB6Jiy+Hx4/++tn987EdluJ3fZwN4OBiPzVeoetv?=
 =?us-ascii?Q?S17zjCWPkZypEY02FQNb1sG6MK6zWzjR/73OWvjXsiFKF+UKxKYOPkallwqE?=
 =?us-ascii?Q?wQWJU5xScpdsGxuDTJpmRt6XmM4z01CSqNg7btRf5mcxGfHQP4IaExmbMOK4?=
 =?us-ascii?Q?QoRctPgitvbvUYmYXB+O4GyvRwbEOHfGH558JPjT6z3soE5Y9DKXKgOwI3/v?=
 =?us-ascii?Q?LDMSJcje8RWvr3CZcfEgvjcgydgq4fm8Oi5iARyQ7msv/5PVcwQ9mCfZsIqm?=
 =?us-ascii?Q?qf4vRZ0+bpJylW9N22MGo+W10TZl+qdPIX8n40vCS36/PhPzmlAerOAapvN6?=
 =?us-ascii?Q?LmA5cxgnlzFMYNKiX8sXviVhGnInIKC6Een0am8a3tcmGg1ceyIr+g12eWRJ?=
 =?us-ascii?Q?aubGd2UNNg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3418e7b0-97c3-48a1-a2d0-08de5fed8e78
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 10:51:43.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGlbHi8/7/0SMwWn20ZXujMxyk5bcKx/fEhqJXhDcbv+a+WRlCP4rUy81Zg7iDgy9bEpEVSN1XuQTP5Qu5S9Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760
X-Rspamd-Server: rspam11
X-Stat-Signature: kqcsba8rneqxu6xbk7pmw3dbziozim8c
X-Rspam-User: 
X-Rspamd-Queue-Id: D0DAFC000A
X-HE-Tag: 1769770479-845533
X-HE-Meta: U2FsdGVkX19ubEsvI+EokWlcbZJVhXSRixbTQsXFeubXPd5CtnzQ0t/14elk1spuEatVuE0ANnucd1f5l4t9kJsVQWnDnPgVCLFguTo1Ndy49YcRTFXe9Ul5TvdPa/k0UxvmFzjJPKDch1Repj/PVu3Pj4Fym9d2ACeTJ/lzpbzcMp804NhwOqsDxLENZgKE2sUswgjut6hUhusTNBodxScg0E5e6+VSjx3CJ6++DY6E1Dm2XitVBm/CQ/njZ8RiD/auHq1umqmAGt0bC2pOpNsufuzt3XIgucaO6qGZguyYkzK8uaZ3Xsr3T4Zgwr+W35o3aQhGPawfLq/uvf4CJ+UR9cr1tkl4ftZRgmAdwlt6LgX7D0w3gghSyGw62Tg4ixMITVTp39CVXLEdI13b0CIfOcQ4TL7JapUOTaPs5NmkkowYoA0VFOPGgTnBuaYQzDrMtBCAr+9C7L5Dkku0TfEKV1DpxuawC+GOKVib+Ouni64RqwFjSBqMimMmqI/8v20Kl0kD9BfLSuPuk3SHTW/xdf4rbBtj9sq4zFiNqwGVf3wUk4xR+2jmokAvcosRivsV9EIMbhp09ch7THdG0R6TKo1mIUm3lIzuy3iEP+/QVIy5Sg2kq0EHKEp9f4XYpTsxztcpjgzTZ73RP050aBnURpP89uNE9NeTg7r8X+OZjHlL5McrBZ3W22i9TPND7fQHqC/KmShPCjKDfSkUlzXcqK2IVjVsVGYS1rTHmByznsBmJp3NUmE8Qy71LjnGTt0RDQvKnT0BPsBLepkMsjxSu50jbhRmrO3U6IyuecGdsL5RrfEGkXMDosU6JpO+RlJC13CulAtO/KZFQSHdInzTlX+Z3DV2pUdRtWbBrspwaoehvFEShjI4LfBoKPhW3BWtyPMMhoQB0+HPim/fSJnSbFowbbqzSoPpgLx8WMeeTq4IyBlztdosNnhDOqUrMH+vrfypmqfTdvyDF2x
 WXLOvtVS
 HPVvKLPbP+e/8K5hMWC0QMERrvpoauTHQmL2Fgx4oyLocefPvjc8CjJupsqA5bmQkSkQ7fR05wAwEX76CwI0clG+nbMtW5llcW8fJmzeyCYkLihHC0IBxhFj+PN4KFYAql8LWVRghbLGpCxREbG1TDCeKueO/erYg/D2Eqkk2BkLf8PwkT2BkFP7VTukGmciH9lq3BH3KrPFmKoaJr48IslLS+Q1kDxG7nsus7D2aVIFF/AlbjFLHXFtF2twApOrS3pUzT/oEQQQhSfRkB7beYXtAMT/NMNYYcy1WlUiFa6jg+GpmGWuWXqd1DAb54+y20XDSyPJCQLy3XvDWvRXZvrsP9695nZIvqgnOOQKB3LsrnkYwrvdRNQ6+Ao0fGAy/ucVKVua5JMy9yPIAhizwygRMaR2Hf47+q3BeMgcHqGvjsz4zwvmxoFyNW7LPYE6Ibk49/pBTeDb0DrMZ5ruU7gt9NduZbFoHA00htY+WFleM6l4fcmLVIxJ+dYNFjQClFnbDpcGRBX+psYQWfxEXtBKxa+Txh5seH5HF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Prepare for this by adding a HMM_PFN_DEVICE_PRIVATE flag to indicate
that a hmm_pfn contains a PFN for a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---
v1:
  - Update HMM_PFN_ORDER_SHIFT
  - Handle hmm_vma_handle_absent_pmd()
v2:
  - No change
v3:
  - No change
---
 include/linux/hmm.h | 4 +++-
 mm/hmm.c            | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..d8756c341620 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,7 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_DEVICE_PRIVATE - the pfn field contains a DEVICE_PRIVATE pfn.
  * HMM_PFN_P2PDMA - P2P page
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
@@ -40,6 +41,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+	HMM_PFN_DEVICE_PRIVATE = 1UL << (BITS_PER_LONG - 7),
 	/*
 	 * Sticky flags, carried from input to output,
 	 * don't forget to update HMM_PFN_INOUT_FLAGS
@@ -48,7 +50,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
 	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 
-	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
+	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 12),
 
 	/* Input flags */
 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
diff --git a/mm/hmm.c b/mm/hmm.c
index 4ec74c18bef6..14895fa6575f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -267,7 +267,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (softleaf_is_device_private(entry) &&
 		    page_pgmap(softleaf_to_page(entry))->owner ==
 		    range->dev_private_owner) {
-			cpu_flags = HMM_PFN_VALID;
+			cpu_flags = HMM_PFN_VALID | HMM_PFN_DEVICE_PRIVATE;
 			if (softleaf_is_device_private_write(entry))
 				cpu_flags |= HMM_PFN_WRITE;
 			new_pfn_flags = softleaf_to_pfn(entry) | cpu_flags;
@@ -347,7 +347,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	    softleaf_to_folio(entry)->pgmap->owner ==
 	    range->dev_private_owner) {
 		unsigned long cpu_flags = HMM_PFN_VALID |
-			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
+			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT) |
+			HMM_PFN_DEVICE_PRIVATE;
 		unsigned long pfn = softleaf_to_pfn(entry);
 		unsigned long i;
 
-- 
2.34.1



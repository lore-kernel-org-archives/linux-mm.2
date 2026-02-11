Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D5EECD6F6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC956B0089; Wed, 11 Feb 2026 17:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794A66B008A; Wed, 11 Feb 2026 17:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676116B008C; Wed, 11 Feb 2026 17:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 558C26B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:18:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01D18140526
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:18:57 +0000 (UTC)
X-FDA: 84433591956.06.8DD089B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF79FA0013
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:18:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=upa43FXx;
	spf=pass (imf25.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 40.107.201.26 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770848335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygQ8QyM5Sk+6SaQfAa+bZC+ruPXAgwaotlv1LECVyNc=;
	b=Na3SVL1yy/Q9Ub4LqRF5HWmbPWojytV4d4zPqPd/WIKg16ZKjLlXHPpSWAznr2ICEnIBsl
	jQRtAmhnkQvaTiZB6sO2O/zKEDTWhK8+dsUTUSdeK1SXNZDbybU34wdSRq41sRv6iEHDGm
	wRk4VaBFNmTvglr5IVya8VlHK5U6yWE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=upa43FXx;
	spf=pass (imf25.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 40.107.201.26 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770848335; a=rsa-sha256;
	cv=pass;
	b=eU1I1m6M/MDHgWt710q7pcIJcrsSAor2/+zmHrhh3UHMM7GL3mkxfJszooJSZ6APD6G/DJ
	EKnqahFgJ4F2v+0OyqguUsCMat575IVjWhtEklswwNdE6TSEySDpbg1D+r1v52/mkT0wjJ
	5jojEu3eyS7FmCY6zN+KnrmvY9feCVk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQL2/oZeg3HxpemppptXfi/Nc6c5+lt0Pm/r3TgCEEjFWD2+WWLfqZbu/oMgqz3W/xxBFeoE//0pi3C3bTWEz2y80RGPulGjhN8YD+zup0MuaVkSig7fih2hZSYE3nYEYLL6VS+558UaWeKXleAhkUIKKZJlmnoQ5JfGxCR5IpYAJM2vRPDbSzaSVy+M7bbzlhicIzlz9oAvNoLHHm6U4AybzOaaqBg8Aub5C1PW1jpACWIthaNcllSpQp5pqj2WjaeL5iB2lE9VJ3nSJM9vtH7b2sToF5LamzpSkeOJ3wXj/t+qQ1NislyAcx6GjfuI4LbP1bLi85ZhGohUvCRxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygQ8QyM5Sk+6SaQfAa+bZC+ruPXAgwaotlv1LECVyNc=;
 b=OSxRAGxVpuQJnQYwIt+tx6Tjfv6qyiD82BaRDc5k8KakdagMWoWgYVeKdAJf+d/3Nbjub87zOaMCJG4Fxy8F9aROyOG4hfeQ6mnz9GgHEXUNdsxxymoJ1bw/uGdyw6j2GDY6qAud+Zo19c1jd0hnU1TthYof6D64VUzfxNIr7+Zo1oEY38JpSlO6OByJemS9gfBiq3RNdgVsSUcZT3jpcR6eUr3josVYAup4v8g8MG919/VQ/xIZBj6Wc8Q1USRsvgk43OS4sLShJu37vAqwqk2HuKhjzdLeRTpENrbxsXsW5ryyThv2VVBZvEFPRGXHu3seb7oX4fo+YMZaHwP8mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygQ8QyM5Sk+6SaQfAa+bZC+ruPXAgwaotlv1LECVyNc=;
 b=upa43FXxpL3902jeH8kTSrrSvbWSIVfuRtmgKlxSq/hQ+Lbik8Ss330L5zP7oe9huGZQqDyzsmz4aOAROujYmqf1Ci2CYYrSEO+l4DMjbaoAXu569K73Mg9+i9wJE+86IpVPy0ukIHq/K51BTq7zurqsAASl7keRKkuuD7FW2t0=
Received: from SJ0PR05CA0031.namprd05.prod.outlook.com (2603:10b6:a03:33f::6)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 22:18:48 +0000
Received: from CO1PEPF00012E82.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::81) by SJ0PR05CA0031.outlook.office365.com
 (2603:10b6:a03:33f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.7 via Frontend Transport; Wed,
 11 Feb 2026 22:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF00012E82.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Wed, 11 Feb 2026 22:18:48 +0000
Received: from [10.31.203.44] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 16:18:46 -0600
Message-ID: <35db57ae-64cd-40ed-8353-7d3b64069471@amd.com>
Date: Wed, 11 Feb 2026 16:18:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
To: Gregory Price <gourry@gourry.net>, <linux-mm@kvack.org>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>, <david@kernel.org>, <osalvador@suse.de>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <dakr@kernel.org>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
References: <20260211215447.2194189-1-gourry@gourry.net>
Content-Language: en-US
In-Reply-To: <20260211215447.2194189-1-gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E82:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 25174c4d-67eb-4739-60e7-08de69bb875b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmZUMlpWb0Zhamw0eEcwWDI2QUJWbGtYWlR1S1FxRUI0ZFBzVDc0U0JiL3lh?=
 =?utf-8?B?UjV2MGJhbE1yL1kreUhyQ1htV2hWN0Uvd1FxZmZUYU9ZSGFDU0oyNDNzdmc5?=
 =?utf-8?B?a2N0ZVZZQWp1YWVic0tsNmd3VUIvZGd5VmsxaHJ1L0JSOS9ORFF6UGt1R0E4?=
 =?utf-8?B?MTZwNHJmTml5bmQvRkxaSGRhVTA1YnpHblBGMjN0WUx5b3lSZnpIRklMeDNj?=
 =?utf-8?B?OGtVbUxnUm0zNHhpR3pXcXJtZWZZK0oxODBVcWo2bkhZdlF6TE5KY2Y1d3BN?=
 =?utf-8?B?MUpTL2FrZGhFU1Vnb3dIYjBsUE55L1BNT1J2eVlMa3ZFN3ZFMUJyY1ZmVkxr?=
 =?utf-8?B?MmdxaFFMa2V5YmVPalk2c1FmM0RtcGpPaGFhZnhRZE9JdEF3QXpnR1hiUnZ4?=
 =?utf-8?B?Qy90NVVVWUdYSDJrV3JiSVpjbzVBb2FUbmlsMXJCTDBQbW4zMTh4VVpLQ1d3?=
 =?utf-8?B?TGl6d2hOR29PcFhNODhSVXliNUFGYy92U1RabEJ0Zy9FUTdpc2czNStOSmxJ?=
 =?utf-8?B?VkVFdm1MYmFSZW5zTGRoRCtGak9zMlFOMkt5dWo3OXRHelphaEhzNVF4ZkRi?=
 =?utf-8?B?UW9pZmtLSmFYMmlGVE9VMVdyM3MybjI3Z2JvdGFtbTVnbkx5MVIrMUJwd2hJ?=
 =?utf-8?B?M0RoT0RWeWw5V05pMWN1UHpyVjkwNTFjMFUwSHhwV0FJcHUyalR3Mm02YTM2?=
 =?utf-8?B?eGpIanl6S29oVlg5NXdxQk11OUQwUkZMSndBMzNaMHorNFMxd0lXRXd0bjls?=
 =?utf-8?B?SFFlRFl2a1Y3SDQ1eUxqS0M0c1Y1QWJTTTBremJIWlBlVVdVdkt1ZGc0a0pQ?=
 =?utf-8?B?V0hDYkZ3OW91OE10Z2ovZkczRFFadmNDYW5jeC8rYUxNVzFpMWtsNFFHcHgw?=
 =?utf-8?B?ZGIrWSsvbFdnNFpBVTQwVUNzZ0RMTHFEWHlMeEp0cmVhbklFK09TNnlPWTY0?=
 =?utf-8?B?Rk5ZQTdmdFV5bmpaN0NkbHFSUlB4dHdUdGZNanZKcko5cXlqWXUrRzdnbHEz?=
 =?utf-8?B?VWtVUUFhK1NDUUpacFR1VGNWT0JIKzZ6ZzZwOWZtK1Y1UHVNQm9XSjlwVHhv?=
 =?utf-8?B?S3hNbU9WOUlNbkVwcXZWMTZEVmlmZHI5c1JZdEd3aHkyWGJPN3FMc0lmTk5L?=
 =?utf-8?B?YU1nbUNkTVI0UTM3NmFJRTdnV1BKVzJHZmUzVWZhMnpjSUdQbFJXUHpZdEFG?=
 =?utf-8?B?Uk9zQ3FKZGwxeU82OUJxQjFFOVZzTW9JUlViUnVUazBla00yTlgxMU14LzEz?=
 =?utf-8?B?U3JjdTNKL2lQV1doK1ZkMVhvaVdNek9tMVQzNE9lSlNhQ21STnhvR0ZMVHpt?=
 =?utf-8?B?eUI4WjJIb0JBcGR3NzhpRUlPU005aFVWNGJvTVV3R0w4aEJzL04vWXpYNWJq?=
 =?utf-8?B?L0I0b0JoTGJha2dZZHIwcEJ6ZGUyVW5IREdhVkRUY1l4dHZyR2dqQzhJQ09h?=
 =?utf-8?B?VmM2dWRydXRZUEVRZEhhbUc3RTU5QkFYY1JVdEJIV1hUTXFVVW5DbnpwKzBF?=
 =?utf-8?B?eGozcC9wM3ljMktxK2tQQ0x6MDlmYVdOVGFOM1JSZlNFbWdxV2VWUm85Snhh?=
 =?utf-8?B?aFRwdGlyS0N5ZWlETjMyVUlRdWhPUlJUV0t2MThNeDNyN1hpMVlKazVkT0NN?=
 =?utf-8?B?Ui9Ja0JMUkVPc3VTWlF2bDJxM0VvSTFsV29LWFdyckpRajFXV0VsT1pRNk5C?=
 =?utf-8?B?MEpvZ2JFMVVtb1RDNEh5M3V5eDRQUTFWbGZOQ2F4N29Nc3pnL3hhYUFzYnlM?=
 =?utf-8?B?SzVWR2ZkWGkwajRQeW93VDg1am5kaDdYT0JVR08yYk1VNkFLSUVaQlRFMzh5?=
 =?utf-8?B?S0xvSE1qU2pmZWNEL1BrY1BNU3FIeVpVbW9oTlUwQkZIMldnaHpSM01zT1cy?=
 =?utf-8?B?Vk1yck8vbE5FdHJVb0RzeDMxZ3dvemI5R1lBeUQ4SG1jOXZLUnVyeWNGaUVx?=
 =?utf-8?B?ekdiTWRMVHRhQUtOVGl5VDRMU2lCS1FXQ1ZySFVPQzZ4YkNnUVZHTWl1cVF6?=
 =?utf-8?B?dTV1eHlYYk1VWWJWYVNFWHdsV2cyVm1KTHlodDh0SVBOOXp1L2srM0lJTjZN?=
 =?utf-8?B?U0dVa0lwZFcvZzRBWldBZExRYm11dlBkRFRRRlVLRXJiMTNmUFRWTklzRHhW?=
 =?utf-8?B?cG5hQXZvMFBlWUNwekp5Tk1hM3JhQ2FaNEhsejJpVXI4cWs5b2tsMUcwdnFU?=
 =?utf-8?B?YWZmZUVlQXluSnk2K0RkQnZJWnBXbDZhTW1pUmkxR0xPV3pzMWhTejFGZFI5?=
 =?utf-8?B?aHFDYysrcGtxa2k3eldMRUxEYVNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iockf9cwFVPJZe2ahVAM8wEBMFueXV8yokryQVi9n2eTtKSOZO/JFBDc+kh9YVhaHgoCCd9hH7pJRt/aoVygof1EKwsCOuN1tZo/wBFV+kbVHd0zrPOq/r2qj+YrEFJPrt9wsi2sTtsHksmWUH+my7/rgviA7QrkGuljLv7BjFUCnJPtP7jRfZHYMuD915a/KuDe01ZKKjNKCKAodzBEoQIH6ywFTgaIDa6kuMXhxliUGND1o9fZYl/FB94PSQeES1A0c3obL36f7+lv4lp3srpPkY7p7xswhW80xNLsRsf3wZ6nH3wfUTCggeevqmZYzyeHcjnBhJBGoGYooheXZjhLjOG2VWBexmHh2apJnqm6NNwG9CLKbOzujqngUE2Xq2awlIUd1KhEIjkrKMER4HaaIzjP8tsx2fx2jZIXxMleMl2pSsbzTV6vF1mKvq3F
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 22:18:48.3080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25174c4d-67eb-4739-60e7-08de69bb875b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E82.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Rspamd-Server: rspam12
X-Stat-Signature: x8kbojsh8j3uuzgpi8xi1qp6xbmje4co
X-Rspamd-Queue-Id: CF79FA0013
X-Rspam-User: 
X-HE-Tag: 1770848334-425940
X-HE-Meta: U2FsdGVkX19k2SswhuQMyiJdjFa8icWjuGycCERYkhRdl44iHZoThwO1/edWOb7EuXM7KKTHXOpun1KmzI/YWmusgNdI9ya7TD3giGrB3p6a1QFWYK0k2bpIQ3tokDaT7reB94dkAbtbLNDW7FT0GFZ9dOwBFdzDmP1IZ9UtvgZUyFDNl4wTeNhM3M/Bou5PqR0WQeVq/JsFyGVojoao3IxitwwWgP32i3BEDKgYXScrWlFE/raehXRbhKdkfsIMaMpgm/h4TFl1qagDDHe/JYguMlDdvMDhnYCsf2PMAiK+4S3Ucj+1k3Ws6jBYNbrkIgBlymWAUt1NAegbjYYQi617Wwg3ZmgxzW5cJJtBgQjwb+BsjlVbe0eC8X24x2h+h5Agph9DtVXBTTkknQ7wHY4l4SZx1C4LovfJKWnwwajDPJIjZoQzYynoYTWxfmbvNnYbht2NNAxxJX8mds0fcUVnuryldrkztSeCtS/peoocOr4KooIxhylseeLryf+9R9qWI/yVC+oNFcVx9YEZZUeTTv4Bjw6OPEroynZShI/pB7g2RZNIT9N/YB6vPsQN+9mKyGXBUqhPTQS9Aa2nmWxAkiu9gg3kv9WAtNrCJQPP2MRCkX4VPVHPPauQUthIUKKid7i+4IPbirFxc+M6ngy444cLGwEdHyr9Y6tulqsmDUrLqqnP0kEPkw7M+LhJhJdf2ZGtPt9yrj7dvoj++FVr7iqaNzgVcAkFEnw5pjvUegUQ6o18CtThqV/I8KQGqYqC3oxeQEM3JmkjnV6p1hWWr1qnqROZghPClLrlhE/xpc2J5vdcccIzDP53YMJRLtDELfGIBAkCld1IVAs/zjMtpgdMt9aUWGhW3VEyLrFCCqln/RkDagP8ILAz7PwAcOuEz5wVrSfeyx0evke8xtGHZM0dF6YAFiVxXn92RHbmgtouC9YvyySTkldjK2jIvClBHhSdWyKM4OQKeWb
 8CsEFaME
 T9FAA8dgZG41FxLP7vk6R9bZw8xAyB19M0NLxpl3tt/hKWmFVlth6XMEmPMD1eWXEC+Ywx4ZDjSz2X7ijqqqcDlSmhtkAifEG2zu+zeH+NQZXVS0pRe12eVVZvYAiCJTL28nMcgXo6Zdzjr4aB5yNqhhGUhum/2SQmFg5XjyJXmCvup7/YzfeUvFSSaDCd5RcvA9u41NtrHmEM3yh55c2hk6vtdXdnmkj1zbuxzS0bVnPVyLv7RtdhZ/nV1Jc8OZnjgS7yRIzOytP6V7froHy7gnDNaVej0jDf4bkkKm1hmURiS4G+v/SLtiMgAX9KY8EJWlpAoqQNvYOOqaJ0S8fvsvFtAbFG4gmMvh6n1cS/d5r5k2xrGveJwsxL9gPa6P8y9O2WjqWlHIF+wjolMwuIqpgOsyQrEfzbd/A6oLbsiywCSdv0FCE7zEf+SkJFHsPgLW6lj6JLFzKcY5d6WtlUVjZhJ/N9zcWqktUeDKBXAptKQLVrWsb91thRpcJ8MdWAEbz3GthHe8D7PgO4DbcX7qs4KtaCwhoF3MEiw/h00/HNPVoWd3x8Ut3/HTBvvacwxpfTxF7arvqDvWVlyOnzP7B1KTILMic5Kde3twc9DMetyDV95k01xGVInjxzvtZT/t0UBrgrfNC+a8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/2026 3:54 PM, Gregory Price wrote:
> Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
> name so the compiler can help catch invalid values being assigned to
> variables of this type.
> 
> Leave the existing functions returning int alone to allow for
> value-or-error pattern to remain unchanged without churn.
> 
> mmop_default_online_type is left as int because it uses the -1
> sentinal value to signal it hasn't been initialized yet.
> 
> Keep the uint8_t buffer in offline_and_remove_memory() as-is for
> space efficiency, with an explicit cast when we consume the value.
> 
> Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
> it is unconditionally available for struct memory_block in memory.h.
> 
> No functional change.
> 
> Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

I saw this when reviewing another set of yours and thought about mentioning it, glad you cleaned it up!

One small nit below, otherwise:
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>

>  drivers/base/memory.c          |  2 +-
>  include/linux/memory.h         |  3 ++-
>  include/linux/memory_hotplug.h | 16 ++++++++--------
>  mm/memory_hotplug.c            | 10 +++++-----
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 751f248ca4a8..3753ca80069d 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -452,7 +452,7 @@ static ssize_t phys_device_show(struct device *dev,
>  static int print_allowed_zone(char *buf, int len, int nid,
>  			      struct memory_group *group,
>  			      unsigned long start_pfn, unsigned long nr_pages,
> -			      int online_type, struct zone *default_zone)
> +			      enum mmop online_type, struct zone *default_zone)
>  {
>  	struct zone *zone;
>  
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index faeaa921e55b..5bb5599c6b2b 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -19,6 +19,7 @@
>  #include <linux/node.h>
>  #include <linux/compiler.h>
>  #include <linux/mutex.h>
> +#include <linux/memory_hotplug.h>
>  
>  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
>  
> @@ -77,7 +78,7 @@ enum memory_block_state {
>  struct memory_block {
>  	unsigned long start_section_nr;
>  	enum memory_block_state state;	/* serialized by the dev->lock */
> -	int online_type;		/* for passing data to online routine */
> +	enum mmop online_type;	/* for passing data to online routine */

Comment looks unaligned.

Thanks,
Ben


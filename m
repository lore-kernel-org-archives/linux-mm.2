Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C8CCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7BC8E0023; Fri, 10 Oct 2025 11:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF178E0003; Fri, 10 Oct 2025 11:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE348E0023; Fri, 10 Oct 2025 11:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4FBB8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:21:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77971160353
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:21:47 +0000 (UTC)
X-FDA: 83982569454.09.9AF9381
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94A5D1C000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:21:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMxAzb2e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760109704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQl3bPZbAwkdYjKQRCUPCIXl4fn8COa/BRyYVijLDog=;
	b=z2L4Q89YvWvn5IJrohP7M7y8FD7mxj0E1MIl9QVGzmsAsMI+b5ltEWNl/KfJaIxhWhbmZM
	kRffuyDtVrxknhG+FcdUwAdOb4jwhedy4GVpcIX6YiL7RsrbimHTvcndOh3Koosa4ofpKn
	36yKloYpBRlyb7JjINMFFMRk1g511Uw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760109704; a=rsa-sha256;
	cv=pass;
	b=AVAKngwFJWkfiuEk+YrnPQRi2C+V/k9bpb4+ankqYWfkgC5geV+xARv2Okn9CYihwdm/LW
	8u44jg6i8sZ9mdE+952ri6xFFQwz5OaAg6gqYtOY9yqGkSV5SalqHjfVKlVWIolvDxWV/D
	qvPzl5K9xvBsPZP2nOTMuTX/dYWO5OM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GMxAzb2e;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JclX7SvnFhMK1UI8/MnGoCl0xzkmkDX3ThJhTH+eluX43/zHnYx86ebQ4AUNcNhBOoSwJr5MKTnALWVciAncAl03DFSu39BWfCSUqkd2smcEMnV4pzo0OiIH3QchxUquPxqCL9d+p3XzHryFaqe5vGzPoBKSngCOAF3eZgexBJpv+g662IOXG4vQt8rD2he6E3oWXhpfyknRloRoEauT5ECVjjLU/gMMDPB8qBbiBR3rvW6KlRN8GWjqIhqRqiY69ddwFfP69q5FxscJChZlE8pV+h3h7ypAZ9FH8sz/GheWWSWLmIivo4QOo5asUEs29LVTdn/lz+M5WfMJ1jHlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQl3bPZbAwkdYjKQRCUPCIXl4fn8COa/BRyYVijLDog=;
 b=GsJpGVxgHTo0Zx+/IGBTCswO12GZ/8ISYjsjfEeRBB377IyJnO7W337aqx71lmzLaWvEMouSqT+iqecxVSF5Hm1FpsNSIgHb78mYGid5gzkzK79HTkNZ+uEERrmsRMCX7HrMuRPOihYYuwaa3n5mQobMXRMIrHSx9zS+5+J5N18zR39eef0bBG7kt0IoWxKpZUWqSbgtCOaf3Onic7IsNVpVujyJNOq/VaLsRfhttbddRgH6tvC4CKWFkvzjeDXw1Lo6kzFPnQFMrVqRe2oixpNeHOXZxVPN4WdoR14/jocFeMQaQ+5lQFjPeUpykHun9bDuvv1cELXSyJC5Q+BlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQl3bPZbAwkdYjKQRCUPCIXl4fn8COa/BRyYVijLDog=;
 b=GMxAzb2etJYJRuEgJ0s1j5LeLv/Hy/0zW/vJthPHFZ7PS3doDK54FeKj1pYwNJ+WTxsBJC31sPckgIWqIs6NcRgSqZaIc2ba55gkkHd7bXzf6wxXXLXden6QybRW3WdQVNq1rYk+JAxppXxIEL9ZbM48tM/MIMz1J4WaXDahgSvAEnRFAuHts9u/QChYkyLcBB6eI8taSZcvJQpv/KwfxcnB35cLPQge7bOgxNmlX1mqkyvg3KsMweh60F8yiIQHKJiCgC4s3V7Uloj7WXb4vL/IDxUXPo1PCljno35vbdiLGENb0dJMyEofeA9QXOH91TTY221Ki8KbtO1u4x/lfQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9687.namprd12.prod.outlook.com (2603:10b6:8:27b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.10; Fri, 10 Oct 2025 15:21:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 15:21:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
 richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Date: Fri, 10 Oct 2025 11:21:37 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3ABDAD81-A650-4C9A-BB4B-5515180F0743@nvidia.com>
In-Reply-To: <20251008032657.72406-1-lance.yang@linux.dev>
References: <20251008032657.72406-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9687:EE_
X-MS-Office365-Filtering-Correlation-Id: 04ae5557-7a12-4a60-8cd7-08de0810b5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Sz2fvXaqM29LBafUiOEG141Mxn4Rj8OgKYnq6CTCvlWTrbw3EVJMPqHr8hO?=
 =?us-ascii?Q?jz0UjTM6S87tn9/SfpJDOPraIOpp4v5WM6t2KDpT1fxBtBeTXtSmFp3BDvV7?=
 =?us-ascii?Q?EVddpeWOtt6+9W1VlP4pvBw3k22PSxKQtVoerwb7gISyjvjNq4JEF1reaRSY?=
 =?us-ascii?Q?sE3f5eDZzerT89FINbKNkvKeT3Rdi7rQOVNL9VVMxLC6j2jRdY76WU/9YeRZ?=
 =?us-ascii?Q?bXtUcnBaLmLEmfJCIETQxsNwfOCValUJ8UIjB7D77GGpRsAZtdXNac1PfgPr?=
 =?us-ascii?Q?Rj15n/rXIvCmf6UNjbviO5z6KWoP7+mQ02FONxPUazetFvlKkzYAxT5Rv/R2?=
 =?us-ascii?Q?0VzGeA3MrDsroFGTXwCFav/GpEaNYl9+v2laPY8yDC2C4CyjcPvSZDREIlxd?=
 =?us-ascii?Q?/bWZ85P2l99B1eVk2unHATxweo3vYkENiK0nIhV7eu1mC0D0SSdGXIoUsCBa?=
 =?us-ascii?Q?XJyA6tpiLPXfINYI+syxKoEwIEEaTO69sb4mpJgNKOpHfLbtIMIDrB2PDZBt?=
 =?us-ascii?Q?Chen56nmZDYgZXCpYE1ST2Fdv3Vpz50h+EY4PEGckMiC18XldN7ZwXDKetgh?=
 =?us-ascii?Q?IKWPk68KB7c02V2YndASIn2gf4yHdnAK6k2sDlVDweBlF1D1/2sHfDR/06yh?=
 =?us-ascii?Q?FjKckVt6HGOR61zJDlP+SA02AjL0w7MOyVwMUrCJ5XyFiUUwZH3dcrRNVxr1?=
 =?us-ascii?Q?mOhqOIeGgX7VpNp5YVUdDvr9SfpwkRTXU63P1ZDbcrz5vDnF3WJJsYIpEnuv?=
 =?us-ascii?Q?Z/bdwBYXDcgFmYzA3Yi4g9BiSqCYO/8O3qMBkOpC6nszprajQ5i7cxSoXWa7?=
 =?us-ascii?Q?11aPdL2+CmkulpoIxLOTS0DCo2qKBs5lneAvWC1TVzZkIfKTtNdKhnwSsh+w?=
 =?us-ascii?Q?eO/QCzAEzr5D/agA9ya7hsw90F+H3UWCJK+S8KmUxPnEDdF9+ZrexmDhgoEu?=
 =?us-ascii?Q?NrrCbBu8voIXjuYS1F/GHUrPlsvhl+y0+SbccVDT4U2FCeXbLGa3WwfYfdDj?=
 =?us-ascii?Q?q0yWWNEEMTGn2MKlDqi4j8p8rL8LLYxTYWtLmvk61tYUyUKyAYev9dTBm9n/?=
 =?us-ascii?Q?jIGISsrtO13iujMEOlNdKTTh/8pKp+x8WNL5XWgL7mbrOdUFdTkkotpKlDRB?=
 =?us-ascii?Q?nvuu3CGzo6FE3o6qWwm0VD4FV0zqPcVbDnvruxJ9A3NlB8pZkRS4hk+aDKlt?=
 =?us-ascii?Q?j0FcoFtTeKUh1i7+dANY4DIqQlTw5mt1I+FfIZV6iC0EzjHfh9FTY5YS0DMa?=
 =?us-ascii?Q?Qz7SNiidzI05Cc4iJpCccqJ6Set6Etpp/PtSWJvUYW8dT58lGctdquYXo1pP?=
 =?us-ascii?Q?bKkwsdXjUDRWPT3656Fr/WgrDVwdNIZFwjZ+LplZr2NwuOzCvDKgt7+QDc46?=
 =?us-ascii?Q?HXMrQWTdIJXzi5xwnTblWqW1T9UkTlu/WP/ajnXMJ124NoYyMYzY2ARvA5bJ?=
 =?us-ascii?Q?Zkse3q1KjaKxqsgEuE1q+3t9dQH5u+NNo9/9XzLb2RlPjLLkTL143A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6FerM2nxvkoG7HS0getC2E31/kp5CckAHS7rS9AZj0RVNc2vLNhpH4PrkqrD?=
 =?us-ascii?Q?twxs7bU1dTFvnGMKlAmVMKIH0Z4Dr6KxiXNBkTY5rK2yB4cybFlw6vXUk4xd?=
 =?us-ascii?Q?I1gXUW+91QntV/VDtP0vTA1E0joxyLMNLqJibj5qr5EycWJSlr9vlwnExZY0?=
 =?us-ascii?Q?uoW0TgjvNvNs1b51N2lP09d3M4v5d/QT/E2gJMHEWtHI1FDlqq1IdPAd/tLm?=
 =?us-ascii?Q?lBR0neIT5Thfz+gkar27bf89SAqLXRXwE42awNrzrjHUkuD3LPhsxoC9s+Z6?=
 =?us-ascii?Q?vtP0+/cp+Q945YLFdCildbQuBj3dmNOp4Ue6kTsHcoGf+gy0TKu8LBtm3B5e?=
 =?us-ascii?Q?mffY/N0tLT6tSvvWf6sGTotGg9F2kREMJRHo5gfqjghRdsf2YT5gKAtQliZB?=
 =?us-ascii?Q?ehO4V/+CROEtZ4Arvl0CDfAGZd2SWAEUihOcLs/6EAgc67hVf/dbhPho8lhE?=
 =?us-ascii?Q?sMhGolSt4Mlb6KKNUMZvoB7943YhghAFRSvgbsHNOqsXi82HtyMf8cXJXGXB?=
 =?us-ascii?Q?V1qazYMal5EKmy+FM4M+GE/jCNUSFtB2Zs/QLHb9+UB71rv2ITQZxliMd+KF?=
 =?us-ascii?Q?gzIjPNZq9AHN1TV1usMSBaTvJHL0UPmqf4H5RVZyeC4fx7826NgoU0ba2nE0?=
 =?us-ascii?Q?R7lcz0xe60Hegov25sLSqAgl+hq080Bx7c+XOuHwNx3d4TpWsy0SHlwfogCh?=
 =?us-ascii?Q?SU8XkzubcSa0tX9Tti8tP561cL8kfq1u4/qMkQ8TlxzbodR9TKv9FWT4dAA7?=
 =?us-ascii?Q?d7jKDQctoMsCcHxum7OicP+S5xY1gd+QD5Q22P1svno65Wu43pL3yXwqGgg9?=
 =?us-ascii?Q?xrYPVl4s50J+qYsKNnVzoZ8595goAfJQS/PDphvPTp/nPA4egfcK3Av60CWb?=
 =?us-ascii?Q?eORcxPQjQra6WAqLQYX66G/zWe9cQf2hwfjBikBi7JvN7ZueDsYJDbLk11Ao?=
 =?us-ascii?Q?wXBp9JtKcAzyFQ0EdclEgHJY7tblQowOqpbl7zqF7xeQ51Av8OqlT3X46V7T?=
 =?us-ascii?Q?iH/YTfDzON3NkzpJmsTXdVOLH1j8wVDzpV2EKAJXQaikRDVv+4O9O/ZdQPw6?=
 =?us-ascii?Q?M+QdpUej+/LK/7OnymrY0ZLmqDVs2K7vo4fRwa/9uY8K/hxUCEdNDNBTOrhB?=
 =?us-ascii?Q?8nnYJCgjw3fSX03MsncY/+euKhb7QA+P0rN3U5yGR1rQ9JE0Tesrqx0PUGSj?=
 =?us-ascii?Q?Bgb5Lppt8XvQYw2gY6LvIPCBGpPtrNKjf7XTUYrZobzhmH9uJz/FxYk9mZd5?=
 =?us-ascii?Q?nbsmVK3YK5jhuMLNctNB9dWjsR1ZrvG3MpNHgXTK/Mxb/w0b9fcbch/m6hBT?=
 =?us-ascii?Q?2jOVIa2wOzJBuwfmzR0zCPJWSUKBU1JZ2UBGqGF0g/eCQg+ZqwNyuoCvCth4?=
 =?us-ascii?Q?BkeLZgDyJ54YVB4XMgaRfbBR8+S2Vdt2VppsJ6IEGtwwMaA3K5+8yLrQPdxt?=
 =?us-ascii?Q?qrfUxKalI3DdCGp2FMBEk4V40GLMSecgqcoJJyOF433l2QNFR00pAGIPF+cP?=
 =?us-ascii?Q?I4T4OM5r1vaLp9rMNxyqAH5V1LlFSKXqBGFsf8l6mjzIiAG5XDLLjg3QYuYT?=
 =?us-ascii?Q?MuIzqEpuHGk6gIWV7r4YgjkF0ZPp5ZMSNbIVvnT8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ae5557-7a12-4a60-8cd7-08de0810b5f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 15:21:40.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 08NDqRV+s3bxYhM+YWq2dcB2FELmwD4yy2ZFyk44Vkr2p57pk/3ef1qvtlj8ER4E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9687
X-Rspamd-Server: rspam05
X-Stat-Signature: qkjoje6ieszp5kdxi7xor6ownu1yjkba
X-Rspam-User: 
X-Rspamd-Queue-Id: 94A5D1C000A
X-HE-Tag: 1760109704-187494
X-HE-Meta: U2FsdGVkX18rdnbH14qGZTz5HZNuEhdzBYSd9qx209buXPYmO5zvth+DSKggyMSNc7wkNqHxTSmaq/ITUJjpW9skvu3KXEjkDexBqIfu8VnIFdEjR+Vx0JNz99sDZ4UXSO/HcFqQQ02BL+qb0jykQWGHxfl1PAjaKmlFlWKWXKjAko4WTRIYCB5VerYGi/uZLKH74mqe8ee0cl+TXBABuiv3X6Jw7YwuY9spv8eSKjgSpM/i8u//m+10GfirLuHG0r783OV4nfof2/dgf+01iCzA2Br5KivqRJRWH+zQrhUZe3nDsGcvRnh56ZhTfS7ueN0PsauNfmFbOIqyJKE+nUhCZj503Xa+r/D4eqQUcHUgBvwsEBWIXPhmgSi2Vo9yvgvbVNw1Xme+tEyNPF3QiBd5ENbBq0Yx/bR2br8kfjb3yTJ1159gJD4EviACRZWRUuPU7jJD4EfZ/XxjT2R7tg+7et6CrQyVdm8/Uj9HuzPfEXAmBLZwtaF42pNinx4RYjsGIfjGVUmzH032wvvLEVznztMFkosJlay2IepYTS0BitxxZj3NPMW3iJrM3vMpQrCxz1C5fKwn0ubdBzhh0ias7skGBHQRjwx/MH/C9uVgYcnl14XZXL8CpIliKRN5uGZWFpEhDSeQI8KlNoDuqfKdy9VQC/gh0PL2T/eLnCU5qnSw0k7DPr2GdNeVB6Zx8SgKt5oc+tZ1BykO+FbjshbmjoPcTkZJt/ZU77/cFkI/8ppWqs/lPumfaPo3SDR6YCo89DCPIatEAuw+YBmC5bGSP6WYDbLbHAfKfFYDOACmoqM/yWUOcOopmXB4sT4UyX5NFTJDXf5JvYr403+ZaFqB78hkvcuUjVuiXmJfRAfHi+A/48w4Val3W6DxlT/fzWd3QDx7nhM/4dLNWU1N7/bvBMVt6Jk1+AI7PHjlBbT1IMlh4TqNjXcUNFK0r0eLbMZw7TfYxVXAZV+70mz
 RIETggls
 mEPZBbjtovWBqoSSbYFzvuI4OhCEWQxr6h7uDl5NMiDnTRft9laocJvfHKYjovjMuVWaGstlmexpXgw7nbUNh8HRaYhrZjoWFX7ppizAbs40F6fCvA+ZPcnQsEDNwFbOhpCUTy9l9QTxWn4pp8UGggRFhjEyqVTKW7j6v7Hwr5u6oKj7AVDop8mfBf0mFtHg+dU2xsFIa766XsPxjryHLkJUeVt7rfsl3ArIe/fc81uO7yL4U4VQGlcibfswF/oVgLhuhAamowINGQIBcqHY3+v2BDp1j33GY9yWxE4vMsG5q32DXjL4Y32vbqHCNLaEklNxLSuj6ONfc0cemm90pzq4QytA7euDBBrE4JIR9SCmUbus9XBAS046vikUR+Lk7HTFP51/8+rmaiGna41u55N/oV7F5KP1fudfMrHFTBZjB+g66M/oA4SDu5EqdvcutWeZ9dQ/S9oZMM85ZaYQEh8r1Y2gcHozubxHnyC2FyroCmtJ4mC7E/33XAf0moyxtEUetFz/LYeBax2nDFrgmpCSa4Hx7+Wm4Z+19uvYyyijVr8ifuP/N5fDBuBp2WNGJyezHJEdurU6E3gI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Oct 2025, at 23:26, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> Currently, special non-swap entries (like PTE markers) are not caught
> early in hpage_collapse_scan_pmd(), leading to failures deep in the
> swap-in logic.
>
> A function that is called __collapse_huge_page_swapin() and documented
> to "Bring missing pages in from swap" will handle other types as well.
>
> As analyzed by David[1], we could have ended up with the following
> entry types right before do_swap_page():
>
>   (1) Migration entries. We would have waited.
>       -> Maybe worth it to wait, maybe not. We suspect we don't stumble=

>          into that frequently such that we don't care. We could always
>          unlock this separately later.
>
>   (2) Device-exclusive entries. We would have converted to non-exclusiv=
e.
>       -> See make_device_exclusive(), we cannot tolerate PMD entries an=
d
>          have to split them through FOLL_SPLIT_PMD. As popped up during=

>          a recent discussion, collapsing here is actually
>          counter-productive, because the next conversion will PTE-map
>          it again.
>       -> Ok to not collapse.
>
>   (3) Device-private entries. We would have migrated to RAM.
>       -> Device-private still does not support THPs, so collapsing righ=
t
>          now just means that the next device access would split the
>          folio again.
>       -> Ok to not collapse.
>
>   (4) HWPoison entries
>       -> Cannot collapse
>
>   (5) Markers
>       -> Cannot collapse
>
> First, this patch adds an early check for these non-swap entries. If
> any one is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
> since we are in the swap pte branch.
>
> Second, as Wei pointed out[3], we may have a chance to get a non-swap
> entry, since we will drop and re-acquire the mmap lock before
> __collapse_huge_page_swapin(). To handle this, we also add a
> non_swap_entry() check there.
>
> Note that we can unlock later what we really need, and not account it
> towards max_swap_ptes.
>
> [1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f=
1e@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8=
bd@lucifer.local
> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@ma=
ster
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v2 -> v3:
>  - Collect Acked-by from David - thanks!
>  - Collect Reviewed-by from Wei and Dev - thanks!
>  - Add a non_swap_entry() check in __collapse_huge_page_swapin() (per W=
ei
>    and David) - thanks!
>  - Rework the changelog to incorporate David's detailed analysis of
>    non-swap entry types - thanks!!!
>  - https://lore.kernel.org/linux-mm/20251001032251.85888-1-lance.yang@l=
inux.dev/
>
> v1 -> v2:
>  - Skip all non-present entries except swap entries (per David) thanks!=

>  - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@l=
inux.dev/
>
>  mm/khugepaged.c | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..bec3e268dc76 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm=
_struct *mm,
>  		if (!is_swap_pte(vmf.orig_pte))
>  			continue;
>
> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
> +			result =3D SCAN_PTE_NON_PRESENT;
> +			goto out;
> +		}
> +
>  		vmf.pte =3D pte;
>  		vmf.ptl =3D ptl;
>  		ret =3D do_swap_page(&vmf);
> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_str=
uct *mm,
>  	for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr +=3D PAGE_SIZE) {
>  		pte_t pteval =3D ptep_get(_pte);
> -		if (is_swap_pte(pteval)) {
> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +			++none_or_zero;
> +			if (!userfaultfd_armed(vma) &&
> +			    (!cc->is_khugepaged ||
> +			     none_or_zero <=3D khugepaged_max_ptes_none)) {
> +				continue;
> +			} else {
> +				result =3D SCAN_EXCEED_NONE_PTE;
> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				goto out_unmap;
> +			}
> +		} else if (!pte_present(pteval)) {
> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +				result =3D SCAN_PTE_NON_PRESENT;
> +				goto out_unmap;
> +			}
> +
>  			++unmapped;
>  			if (!cc->is_khugepaged ||
>  			    unmapped <=3D khugepaged_max_ptes_swap) {
> @@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_stru=
ct *mm,
>  				 * enabled swap entries.  Please see
>  				 * comment below for pte_uffd_wp().
>  				 */
> -				if (pte_swp_uffd_wp_any(pteval)) {
> +				if (pte_swp_uffd_wp(pteval)) {

pte_swp_uffd_wp_any() returns true for both pte_swp_uffd_wp() and
pte_marker_uffd_wp(). Why is it OK to just check pte_swp_uffd_wp() here?

>  					result =3D SCAN_PTE_UFFD_WP;
>  					goto out_unmap;
>  				}
> @@ -1301,18 +1322,6 @@ static int hpage_collapse_scan_pmd(struct mm_str=
uct *mm,
>  				goto out_unmap;
>  			}
>  		}
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <=3D khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result =3D SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out_unmap;
> -			}
> -		}
>  		if (pte_uffd_wp(pteval)) {
>  			/*
>  			 * Don't collapse the page if any of the small
> -- =

> 2.49.0


--
Best Regards,
Yan, Zi


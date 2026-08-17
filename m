Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9BC6C5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 20:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7373F6B0314; Mon, 17 Aug 2026 16:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7104B6B03B8; Mon, 17 Aug 2026 16:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDF56B0874; Mon, 17 Aug 2026 16:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399076B0314
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:34:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA71E8090B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:34:58 +0000 (UTC)
X-FDA: 85111915476.29.CD66EDE
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id D83BF80009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:34:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMOICK+H;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786998896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWB62lEJpWuDk+WdVnDRr+KM+VHqeXPbB3lrNN90s+0=;
	b=6UTZoNbMxOXiPGspdfqjSknvz0aacMI3Ci3y+akXIJGzuuAAbE2PJAGH5hJyy6r+FiSdWF
	iKy4h0xlOneghaNTk9D+sgP90KM3It2l9830xZLeZCsxOj7BPE8Xe6agmK6m6wOES3nBYG
	ORB+40SGE0OI4PKXqs8/eyyKQprF4TA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMOICK+H;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786998896;
	b=gYl6rnQ9jwB1SnLL35WEt8hGPBVYBxkRAPO2eWWomznNDM/N5No/sXnRQngO2i1NX45Y8K
	Xfr3797/Lu73kOpg/A+sJKFa6uC1Cp3SJnC57azi10EGbOi2eesU4VQs602wG3W7mmM9nv
	fxk6tfvg/2A7aqg0pqRZ+fUfU9scqF8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMwrgAAn4wg2llQ3EQ4wVa0KmfeFDLGSlSb9+0W8zHTyjdlIIb1T+ebeWdvJA2//no6XEccs6ic+Mb/VQQSVA536iPYvG53SiZXbXt9srTzpkY6iY0LdjOK6OyxmYWTwJVDgzszhp/+yHQH0nxmIE1zqr6JTUBsjIbsC4e/UrTfH2U8AdqoUGK45jhbSmpxjNAGbhx0M4CaoVFnGPGEVdSONfvvtDQ/f7RdtnLAFf/fGYKSsfVogyGupJhZjGQBET3NucXNR1DECFlxdNXwnFfiKdl4os4vbX0jZCrxKkJeubcWCZ32PnVUL2ILg9vbCEPSZ4hWZqwGG87A36oDpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWB62lEJpWuDk+WdVnDRr+KM+VHqeXPbB3lrNN90s+0=;
 b=Pe2psFxt/Rq1tugjIdMgOi4pZtwiQSzcRyQesSo+yr0CUKbFdluH+//sdTaWg4zP1GOLhkt29vKEzBxR91sDj0DmnAZoXYJgqrivMetsiWMa59F87MqmGhHB21BNWWSzqSiJiJrR68WpCr39iE1K/EiVqB/oDPOaS4MvfH7+mTJqlAm673haEHu/eG05RSbvPIG0QTyvPFKN+8DjkMf7vsPBKWdZsD7eiN/vkGus1n4WNV94RDJVLmlvgJspqRyud2tlZ3swq1XqrNecvPh+Vv+Xm+wrA7zFUhYn1AksNWHAz/FumJCejQOW7l5Uot/MFISvmBn+gGMlAKkgxY5blQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWB62lEJpWuDk+WdVnDRr+KM+VHqeXPbB3lrNN90s+0=;
 b=EMOICK+HyMSwH8s3abMFrE6zWZPY8IvWf4rVVX8KZnBwh8XWXBrOUs2lYkB/8oS3Va6xziwgqJYraSpwDBL9+KVDSxojQCg+u/Zf6IjNhsT3dz1yzhzK9AitxErfKJdXKnu6mPXrwJfshU8541MMHy0Me2fGsU80/i8107kNnRU8WMFqKQCi4U4rMUpPvAnI28hmLDk6A4ajQh9K9zHYNTlzzriNYu5fdklwMfDHLHpSw7XSxxbYmR9ZpKcf5gDZ1BDvOe8t/1wGNCIIrag/nilT4DfqKSfbzBJwwtA1VJxDzOEnn6BMpogtYlQ5IAj2gcjTJJO9tTScxTyinU0oIQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.17; Mon, 17 Aug 2026 20:34:51 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 20:34:45 +0000
Message-ID: <bd091acb-fab9-4678-a185-0b65a2900a11@nvidia.com>
Date: Mon, 17 Aug 2026 13:34:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
To: Zi Yan <ziy@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, linux-usb@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>
References: <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <2026081745-unshaken-retread-d744@gregkh>
 <1ED81A86-22F2-415A-8CC0-7E9B4A4446C2@nvidia.com>
 <2026081732-unaltered-regime-f91f@gregkh>
 <92B3A471-F7BF-488F-94FA-6A011D33D31E@nvidia.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <92B3A471-F7BF-488F-94FA-6A011D33D31E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:a03:5db::10) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c64e8e-379a-4522-2d19-08defc9ef991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|18002099003|22082099003|10067099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	1kySRiEBJsW6ROFLYnk1hWvn/lCw5CY70kFBRoLUzDE/ViZ4cvCX2V/p7BjORS8WMfGHycfbIyI9cvvwP/cyRspz+nypbKd/H8lZtglAoyv4S30bF/rnEzqT419O0B3tGa7NmvCjTIZXuwqn+res9BWpz13cBAm8vvOwXX0LcyXFBYAGpUX7DVG8WV/hSgIz5ssyBI6vS/G0uzYWDgCkdHAXri9jO9VDyamLbxFIYdm1XN+2gP2bEjXl97+U2PbY9054yXtpZO8NSNda33Kbg8xtWMWFkZwQ2CqfjbfjTErg58kYxhFy8PxcBecy+ZV131qFzHS51VEglLTf1c8qyCCnXZyJ8II9Z4IWkwg0m1mse1IJSpUnuV4ZE8FdQXiaa5gE5BhxHxxaC4bG6e3Ns6lTT9a/O+SI0OBWfdp/cMmRPMbmUTRz7s4g0D4jTMbmnhKpsQk/mVRjt0nYnFzjl8jgJWSjndpbaLPjqqouqoch5T4jzJoza7jqiPXo6+B9K6A54V0TFDz1YcqKY7WizMgg0HJzCqNH3NiAWEaDZ3TIshrCDEOtZNMO87Mhk7ejHKg04jFSfjQP2USDVisHB6IUJ2Q//2Du5DGBqlMFdx2JNhqsHm8fgsC93LGaIkrCuPDFN6yJsTvgV1E2ggJq7PFMBsWrwEzgZFvIllLZWCs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWFheVBhRzBkOXkrMlRpM2l6V0k3ci9BMWJaVW9HT1k4Tks3K2JpanQ0ZkRW?=
 =?utf-8?B?ZDdRUlhIQVNVVzhCdVY3Wk9Ka1kyK2kwOXRVYW11b3hKdjVjanp2eVUxNVZi?=
 =?utf-8?B?K2lQQlhia0I1WkIrUHpwZFVYa1ZLVEFwVHkzN0lQSTlhY1UzekVNRmxoMlNm?=
 =?utf-8?B?ajJwOTg0L1I4RnVXdmVyVHo2Q0hRWTlXWU5jbHNIdnZxTVh4NDMrc0pUdEZ1?=
 =?utf-8?B?cGdYdDE2R0toV3l1VTNUZk9PNGllR1dCb2tld09VTGhCTnk5QVo0NEdxYkVF?=
 =?utf-8?B?RXR3WCtOckl2ZHNOTmdGM1ZhRHZFaEQzZDBYdTQyMXBqYWM2ZjV3T3Vxa1Ba?=
 =?utf-8?B?M3BiQmNqM3ZIME5BMGhtQjRwMkRTTEprVjA3cXZxSkNTZHJXYXJXOTdBa09X?=
 =?utf-8?B?OUtoak9xSVpPVXR1N3ZSUHUzUU9ReDhCY2I5NmRmNW41dVd4dUxFMkMyM2Iz?=
 =?utf-8?B?MGtSS2s3S0pBU0RLNGNXT2xTUFdKL0N4bm1HRDFPenRzMUFHNGxCUUlZMWpo?=
 =?utf-8?B?Mkt1L1luNk5PdldhRmlhbStGOXRsZk5NUk9PbUc0N1dBbnF4bGxlZ2xqRVZC?=
 =?utf-8?B?SmFmc0tOcGdydDJHTXF5cWYwVS9TTXJKTStFTjBqMkljUloxZjFRa0F0eGNF?=
 =?utf-8?B?QWFaSEZ1SEJpTVVKSFFpcjl2VGtwWXFLQjVUbkpPZmdWUTc0NVQvaG43eUp5?=
 =?utf-8?B?QjlvNldvWlpmNjFjcG01bzltNVg1MVJPcHFVakJDZ1RJa2dObkJnU3U5S2My?=
 =?utf-8?B?cTh4ZXh0WFEzSVVoWUw4bkk0aGVOUk9ZTzBqY0pCdS9hOW03SjdZcXUwQkh2?=
 =?utf-8?B?Z0ZLaEZsNm9LS2dRbzVSd3lKM0VrSXZzZzFFSjJRNmVLeHhDNmpyWFc4UmVU?=
 =?utf-8?B?T28rZlNzWWxLVEJaUmsvbUxJMmxzMHJjVnhaZFpyNFEyS0p4TUNHb1dyZHVs?=
 =?utf-8?B?M09IRDFpYVpiWE1DZUFvZWFKRjF0NnVKb0tFVlNJbFZJVG01UjdHaFluR3Jp?=
 =?utf-8?B?TXBlQTRTUzJhL2tXTFFSL2xSc1RUMmoyUnJPMU9WaXJiaW5ORzRBaUVDN3Bw?=
 =?utf-8?B?VGJTTlp0eXZmNVNPTDNxSWZIUkhUU3Nxcjk1QVJ4aW0vbG95NEl3L2QxeHJM?=
 =?utf-8?B?QWs2VXVQUG1pZDBHVXd5djluOGdBaUVrMTZqNEdxMEFtZzlybm5mZ1hoQ1pX?=
 =?utf-8?B?dC85K3VhRktyb0VZM3NZejlaS0RjWXJLQld0dWp3VE9iWk53ekFmakxUN2RB?=
 =?utf-8?B?YStjV0djZjVWWGlTV240MjNHRnJrYUJVVjJxdHpZVXNLSE9Kc1RsRFVIVnRG?=
 =?utf-8?B?bngyVVZnV0IyS1E0clRtc045L2RmYXFGZzBCblMrYXVQdEtxRGdnbXlYQjg2?=
 =?utf-8?B?bTdtVDNrYW5LZWtIUE5ISzNMaFIvbWxsNXlMZHM1TW9nZlovek91SDBldlkr?=
 =?utf-8?B?U01UdEJKcVJ3NjN6L2JTMnd2aFlqdmVnTkEvWHZkTG1JNFhjaENxRWdqN21Y?=
 =?utf-8?B?eXJGMDkvdnJQZi82dGlQYXo0Y050aVZMZHhxMlBFMi9FUXJXZk1Ec2xQUnNM?=
 =?utf-8?B?RnNqNG1zL1lMMHExa0l0c1RUZGpRcU4yWmpRbnEwcFQvQ1hyMlhYV1Q1VGhQ?=
 =?utf-8?B?bks2THk3V2E5dXNwdUtuYkhuQm13NEhLd0lTOEVCVG53WjBaTW1pLzZrL2Nq?=
 =?utf-8?B?N2Rkdk4vdjNaTFpybW5wTGtqYy95K0hpMlJqaTc3Y2tUNUdaVzhubDVZdHlU?=
 =?utf-8?B?RUJkVmFOQ0pPUlRYVWNiRUhCNW01QllkL3k2YjhTZG1iMVQxSndIcmh1ZUZi?=
 =?utf-8?B?UGUraGVoYXNEZVNkZW5ibGVvYUFrYXVIdm9EelArRGlab1c4MCtreExrWEVl?=
 =?utf-8?B?Q0J3TXN4am1iZDRGMUhsWUMvY2ZET1F3aysvblM1TmJ4UUR6bGgwRVkvUDQv?=
 =?utf-8?B?RE52SVVHUkd1aUx0ekxRQ1J0Y0tUUWJSaENYYUZzYzRudkFDbFZER2V1Vjk4?=
 =?utf-8?B?QUYxQWFkR3FnU3pnWVRJbmF0aFZTV2dEL3BjaVgwNXZkSkpSZHJrWHVxSGhX?=
 =?utf-8?B?NDFCVi9qNjByemRzZnQ5TjN2Y0t1cTVYMElxWjNaemZ3VnJ4ZVZTOS9ka1FU?=
 =?utf-8?B?UDFKT011MlVxZGI3R3Q1TlBzY2JtN0JrL1hXRVBCMDV4T29JUEVIUmdsV1BJ?=
 =?utf-8?B?L1dXMXpITm9iT1VwT1A1MjJVNUJKQVhIMG1FSW15ODdmWWt2TysxM0pXUlBq?=
 =?utf-8?B?NUM1K0QxZ1JzK05yTzlEUndKbWc3Y3FVZ05KcGU2QzkxdzBFRW5BZHUxWWhQ?=
 =?utf-8?B?TFJ0U0U3TG1RVjBaalp2M2xZcHlHZzBZVGF2aC9yQkptQTI1VEc5UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c64e8e-379a-4522-2d19-08defc9ef991
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 20:34:45.6788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpTHpkOpbPkuHh71MTOXqGNesyCGFoAm8+qHxU46P+4WDMI00q5I9EVVViCbV6p1wrsY5F9cZwRqlIt9VOJITA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
X-Stat-Signature: 4k8ifdkmmep69yfb5jmap9nq46qg5xto
X-Rspamd-Queue-Id: D83BF80009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786998895-677439
X-HE-Meta: U2FsdGVkX19Ku19KEp9oRyh65OzVlSgnlFXPfBGMjOlCuhi1/uqT1/ZTZHQbAlz7+tz+DZ3RrDbxVcZ4xorc1theKLAEtBSuOlVvgE1nI2TGOdRg1Cw8MHoy1Pj8jpHLxatEDwgYBf76WsfCINURTASXBf61XGzGpdZro9zN2Ju50ZlKk7vmuOedCTZs8VfXNqzXvdFRrWT1ZqdZ2lO/NoNfNkry16V1i5A1RynG6fUAjJ0GtB5b9510rzPE8htu/iWQIVCCO55kb+6Hzo6JqKsKFa+ohNbfBPr6rOUTeNZ1Y5NjU9mG5UROHViI1X2BqMd9iQaggqhvJsvo0mZgOoZZIsPqG4adLs1rRs46/2BDJZKd6GfwSztgfR1+emNie5pNSH9qEUx/RwMwce+yhOAMYNp2O4lc6OikZ52EW1d3JkaRg2w0hPiPpkIY2JwQUR4wBV7nk5hilZCX7SkwDoD6mHjHGPmUIZFRBhDdtawA+GXl686ci4ukLQksracYPFksdZ9nMq1rnKk3ev7CC2Du1x/IRu7mZnLmN0V6tW1Dpm8jV+OffLx8CES4n0/BYMvDikyD0F25refjj4VNVxmfxTg6Kl5T/U/HZG7TPxzfA+RYIOmlbUlt3jroco8U6xJCoh9BY7Uyte5uz+F6D6R/HrNT/C2eBRMd2IMjpC+4vdsecg6zEoVnNMh6XVSu749HYjJnLb8G0AWLPSKnIEZ0BC+IELtJYR3rsesuUwLeBwoBD2vw8JFCZ2xuaX7pA1P9YKWRzILpZDJLK0Up5qGiFJ43w/IdkWvjAZlUN31IGPgMRTLBb3P66uFOi+Vjw5P9hYGZuGuYcw2JeYBGm/EmQMkJZxyCTPA5bnew6BVvLtoVr7tzQ6IvtzWNu16gfQX+0spaj0iAqGqOolwfuub2ZVbokkwGVPkD793BCXCHZ5Y8CfZOR1ZnfwBAtFgSJkWyENufRmYzubgecdU
 tumbWr3p
 HXUb0iwcNsieFXRtVppmtiuWcBGTj59ZwOS9eRhgpBMJy30jUjDEDszLV9mBKCGBR/r5T1dRN150oN8XuL4JL+U4TinCs5wgTvcsEzJuR5J5cGBLZucgzC34EG38i/USDzbrKyHR0Yn0Lw4W48D5fE4Z6qY3Q+/lp4wb0Vs9oOijT8tKi2oIur5tPM+ZyzjLIVT3FsB9VRcb/7uNWkSHeolYpMGMwrX9U2iBIDuSMQUPAygmwIvyY6qVdFFn+6W31jkUV7yq/8ykCgUuJnhMSVIZoafcBhrW1KLEm8iXFsmUUZ5Vygqq+LbZpuczBlDTxBNnnLMkC/lbvBrlp8ilQ4DMBNKyMJtQ2Et6lZJU1Wxi5auFH82uSqaeiadMwqhgYX7/pzLiuECzNe3FBWeq8AIpBgkWSn2PHM+fTg1JQzYQMnfczxT+85YYmXpNzc8g6JYQE/gFJo1k67xZjq0BXjK3v7Kckceyu1c4lPF/yMWE2YinZcg6L2jK907rWLdVQqksFqMDZY/JDNigYewymfUfg3xyp6zSy4RXOcGMGoPQzrEQK/duY91/Mn2USANPAdYAl+2MTaaVVv3eViw1YY5YhFi4FRY0/jg07Y1lueh0R8e2C6msv/dnmYaHDGvMsFdKqdnfLAkWl59+zniQkrsS3AYbxDe9JZBfc6lAwHamaKx2z0DTe4uWE3dY6X59tnpIkZkiDHgRjEI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 11:51 AM, Zi Yan wrote:
> On 17 Aug 2026, at 11:55, Greg Kroah-Hartman wrote:
>> On Mon, Aug 17, 2026 at 11:19:23AM -0400, Zi Yan wrote:
>>> On 17 Aug 2026, at 11:06, Greg Kroah-Hartman wrote:
>>>> On Mon, Aug 17, 2026 at 10:34:26AM -0400, Zi Yan wrote:
>>>>> On 17 Aug 2026, at 9:55, Alan Stern wrote:
>>>>>> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
>>>>>>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
... 
> BTW, kvmalloc() also gives a WARN if the input size is bigger than INT_MAX[1][2].
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/slub.c?h=v7.2#n6912
> [2] https://lore.kernel.org/all/CAHk-=wiRq+_jd_O1gz3J6-ANtXMY7iLpi8XFUcmtB3rBixvUXQ@mail.gmail.com/
 
Probably best to remove those WARNs as well, both for consistency, and
because the reasoning still holds for those two references as well.

There is already enough information for the kernel developer: the allocation
failed. "Go investigate, it's easy enough to find out what happened."

No need to print out warnings.


thanks,
-- 
John Hubbard



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13044CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0D18E0005; Fri, 26 Sep 2025 12:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9028E0001; Fri, 26 Sep 2025 12:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7098E0005; Fri, 26 Sep 2025 12:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2650D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:20:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE0E7C0717
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:20:55 +0000 (UTC)
X-FDA: 83931915270.08.9FF57CA
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023107.outbound.protection.outlook.com [40.107.201.107])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12F4240013
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:20:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=AdMKQLUM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.107 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758903653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F7obRBu/4PdlrfgmzJbrZDdle4nN/1dSMQabaCsLXq0=;
	b=DXtv06IsifgiNjkJAtevODeIOYjs6ghJz4L2ZTvJiUwCOVAmtGmmk75SIDA8n3tcDuLFgu
	FlHc+ebCbjWISF+Y19wWKdNAHopYtYYJxr7oQx3rA0NG6lGVY5ksGEw5VdCu57PZuLEvm0
	4r2mNg90Lpq9BddnCabEllp0w5JwJ/Q=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=AdMKQLUM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.107 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758903653; a=rsa-sha256;
	cv=pass;
	b=HA4Ll269Dn7EURHpz/AOJTxgY7ZFN6jctU2x0rhEHCReNJU3U7bsV2btEVlm+THldaWzN7
	0cFI0IegVOYu+qpgxaf65E3XqF5aYmBE6jkc/8EtZ3MNRTFj+gHtPegDsw34lZKartB4dc
	l7IQU6Fxm5hOKfFN3LjnyDRdb4cmPtI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joWEM2JsvJkJTeCQ0LBSAKvZuAToejphcotSg4Bbvnb/KqmEl1fvquO8xST5F7y2WLgVzM7FM52oEW/EZpzKnIlSaWXUT7qE2vJll/QRxfjSaL5agkwcn7wN1yGYZBZgXcbb+fVshFJuU/c1akjzj+36u5ZLWR35/st8APcDl0yfQWwV2LlEe+68NaCZLLQ/f/9PPwdDdRIgQDu2oHKx2geWu3fbhZGs0kHZt00Ms9hytl2v6ZLqMw5+TyZg2LN9L++15PwQth8aadc6wKgxVp0cDYGb+P9ODoPuy2M3PkxUTE3rM0ZRHy7iU1VTFnygxk/KPq7NCKEcjonNgKembg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7obRBu/4PdlrfgmzJbrZDdle4nN/1dSMQabaCsLXq0=;
 b=kGo6GqXUkCk9EnbCOniSBkkpfg1g3rSX2jzY6IldBsEu4sl3DnynRqWE6G5Ph+HNBOiF3nEviA+q7c+CvHYqrfREVCslkIm14A9nP1jF4qQMseNZHoKB+7MHwUQO2TEREOeXeiw4Zxm7tCXMJlTm49Zj99nlcIhZJOKwPabScE4MRlVIxa1WNJLLsEXVF2zaMaBPE4uTju3guegUezB3IdNgR0XomBtHaDkZJijpkBIEAwRlhLHdWBGUT1zd7DS7ryZjVk4ffgQ0hLRojwcJPVQl68IgBvkVwlxKbDkw7zfxiFUfBp5RxWHE9iIKOcxvCWwc36O9KYWo7DR+/0o+vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7obRBu/4PdlrfgmzJbrZDdle4nN/1dSMQabaCsLXq0=;
 b=AdMKQLUM3qfuf9O50bdYcOWd5XXjcH5zGjwa4RqPOR+d/QV1ejCgxG6JrHHKhz29vTmpm54iNlX6aZFxrKE6LgbRoMwnLB0Mm/nL9VEaORVyof2RSzE4CcpkFAXzW1lSJKR5kPoAyl7V5tbXLoGZxF3Rh8Nhb5qFSLhjNMhPVkg=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 DM8PR01MB7066.prod.exchangelabs.com (2603:10b6:8:1b::21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.13; Fri, 26 Sep 2025 16:20:50 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9160.011; Fri, 26 Sep 2025
 16:20:50 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	carl@os.amperecomputing.com,
	cl@gentwo.org
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with PROT_MTE
Date: Fri, 26 Sep 2025 09:20:34 -0700
Message-ID: <20250926162034.1785899-1-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.51.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:930:1a::23) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|DM8PR01MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: bb24ba4e-1a5f-4d91-02d5-08ddfd18a832
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|7416014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkVmSzhaQ1BRMS9BNkZ1dmhuK2NBaTNTUzQ5eGtpWGtwNk5LRDJvb1RockxW?=
 =?utf-8?B?Z2MvY3hWc0FCNmVBeXdjbUJ6bUNYWkNvMzhGMXBNL1Z1WlM5MDMzWlNLcDJI?=
 =?utf-8?B?MXBTeElpbW5xY3VTaUVvOXVUWUJnZXRvVTZSTWorMkpTalBGV0NzWEhpSDZq?=
 =?utf-8?B?bCtqaVdCbkc3ZU9KUzEwbzRUQ1JTVG1jaVRBUEo2UGVIcWNFVms3eHN3b1J6?=
 =?utf-8?B?MEV4VFJ5TEhIclF6UW0ybnJWek1FZVRUY0RtY3dkL1FGNVR6RkhjR050S2dI?=
 =?utf-8?B?bHM4WFlkV3crd1JHMGs2QkN4T04zMUZxUXNncmtwclRaUDJGSjJURytncTdK?=
 =?utf-8?B?RGdHdjVqcGtydm9kSEh4K2VmYWJaMlFuQlF1YlVZdGQvY2l4emhxQ3ZUbGlZ?=
 =?utf-8?B?UzVNY2c5Yk4xRWh0NmJwVncxS3BlKzNlWk1RYUVraDIvMzRYU05NQmp1ei9P?=
 =?utf-8?B?d2JDckJVMHkxeGxYMXdZaU5HWUc4V2pmMllOY3JVWjBqdWJ6TEtwY01BVUc0?=
 =?utf-8?B?dWRRZEdGQkRPUkpDc2lIZ3Jqc01FZzVmdU4zYjRLUzNDdjZyMTdFaXBsUXFa?=
 =?utf-8?B?TzdkcDlWMGZtZ2lCOGlxWWxrVVlBWjRkQld4bnhOZDl3M21OOU44cFBUdUdX?=
 =?utf-8?B?ZGRGSG1TMDRDOXJldjF6ajRQQWNxSUxkSjVvNXZaWEtyems4dm9iQTVJQU5B?=
 =?utf-8?B?K0Rpb1Y0RDZXa0VYcHhEZTRBQjluWDJTQU5ON25HSWZnbENEeVM3Z0lxYmhH?=
 =?utf-8?B?VzBWNVB1RFJpWThUalJXVDZBNVlvaCs0TjlNNWRUenBJQk8zSStPbUI2S0hz?=
 =?utf-8?B?MEZoNVlyN2swMCt5VVBQUWsxUE5VSVNUZUhCaThlMmpHUnFXRlhVRlBwckti?=
 =?utf-8?B?R2F6SHM2SEpudFFGOVR6K0VmWkhzcDJlY1I1YzhKemRtaUtCSlczN1Zic3do?=
 =?utf-8?B?RXRNYmR5dFA5Q0pFRy95eXd3WHhoNGFKSEdQbXZnbHE2NDZKNFlWazRFbWZU?=
 =?utf-8?B?RGZ1b3VTRDhXeXUwMjNyZVhrS09rempCWkxBOE5CeHlzTVlzdldkWm5TaGp0?=
 =?utf-8?B?c29QZ3BhMXM1TkdTV04zdFludnpWbXdBNDllanplM21tYkwrTzJqdFArV2hk?=
 =?utf-8?B?R20vZUxWdnJaclZTTGx5SjdBWi9zbUx2MHd5V01lRzFZeERhTmp0UythSjF6?=
 =?utf-8?B?MHJhQ0ljT3FvYysya3A0dUxBaUpCZlJnSGNwLzNhTm9mcVdoU1lQb25qd1pq?=
 =?utf-8?B?bitpQ0pWd1ByekFpUEpEbGdaOE4zNndOdWlEZkdPOVRoVTJaVEpwblMrY2xw?=
 =?utf-8?B?VDZqMG5TeDBXWjlINlFsaWVCTHMxN2phVWhmeXZaVFdXTFpGMldKOUtkV203?=
 =?utf-8?B?eHdXaDg1WEt5SFJIY1BhQjQ4eEFWVGs5bVFPb1FsRVhJMVprbEVmQlpRQ2hQ?=
 =?utf-8?B?VkNrZDRwQVBPQ2d0NUlvaUovQnFKSFNjUTRDR0JuazNOazVQZHVsY2pYSTM2?=
 =?utf-8?B?VlBtQklDa2lPQ0tkekFrblROUUMwc2dCcDRVQTQxL0xEWUhncnZ0VFR1QVNH?=
 =?utf-8?B?ZkhEU3Z0Zkd3UjlwQUNHakFMS1RUZkplODZPM3RXSlFGWDlRMHo0MDc5S0lV?=
 =?utf-8?B?dE50UDFoUndUQXM5bXFta0kwbTB1Nk1sWWFlWWdLSUppMEVTM0UxU2ptSFdO?=
 =?utf-8?B?clZGeWN3VjI2T0dsY1hKR0lncUJZbWNwaE9ZT3hSb2dNTGNMdGRFaEdtQTAz?=
 =?utf-8?B?M1VmNkI2Rll6dkFCci9kSDJ3Z3drNzVrSFBkQlV5NW9hbmFMQU9rR0RDK1hW?=
 =?utf-8?B?VFlvR1NBdjY3RGVkMmZnWTNGU0pNY1BSdXB1clc1bmM2Ym82eU5ZWlpPaEJ3?=
 =?utf-8?B?cktDME5GN0l4bHBPTzluUVh6Y3hLNlh3a291MU5HT1dyRFU4S1EydldGTE41?=
 =?utf-8?B?OWlRZ29ER09xVm5rM3Q4L2t2azI4SkxVU2w5ak1sVzM5OEVseU1vQ2xKZHQr?=
 =?utf-8?B?Y1oydXVCT2hXOXNlbDJRNDNkYldCL0tUZldjS2NpcE9NS29wa1VibUFXb3Ni?=
 =?utf-8?Q?2KAsHG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(7416014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWNRNWxJNjBCV3F3bmVwQmhwTm85R2ZTd21FMWYrYkZrWTNWcjY2dHdoVzBL?=
 =?utf-8?B?NkNJNjk4SC9aWUNEV0JoNHd6OEZJRkZISURiWXZqZkpzUTl3NjVrcndCQ0Rr?=
 =?utf-8?B?UTBpWk4wYjFMLysyQXFOTTlCYndTTjAwakZxUzBFV1BEdDZuRFQ1RkxwYmFN?=
 =?utf-8?B?SkVTdVU1bkxsVUxyT3FsRjBwTjJIYlRFVUorY1pvR21DQytGVUhReGFYMVQ1?=
 =?utf-8?B?d2RybFRZUWU0eE9rM0ZjV05MWGJpSk1hRjRWZElPdENqRnVhbThESkZjN1NL?=
 =?utf-8?B?MVJ4dVdtdnJpT3FNOHF2azlCdXpiVTB1c0gvY2VSYmh4VnQ1MStqeTViYk8x?=
 =?utf-8?B?VHNyN2svYlRWcndydGh4OTBjMGRNZ1lkTjk4aS9sZk82UWNCa1NBaWM1YS9C?=
 =?utf-8?B?dUpENm84T01iRmhEVURFVHlka2dERGMyZElVR1MzbTEzYm8wcWd1NHJFMnpD?=
 =?utf-8?B?UWFrRHlMT25mTHBPU2RsN0pnMlVyaXhiTzNuM3c1bTZMUFZaUXREZ0FYOFpJ?=
 =?utf-8?B?RkFiS0NBY0J6bWZ0UTlqVkNoWk53aFJXV3Nvd0xQVUh2djNOOXVSb0VLYnhU?=
 =?utf-8?B?VDY1dHRuc3ZUaUIzYmJVSnFWa0l1SG9UdHdwbWNBQXl4ZGhSQXZwRDF5eGo5?=
 =?utf-8?B?TDVuNjJFNFMrUERwUzc4L2M0N0xud1JvRnJVTTUrOUJ1Zk9DclRWeS9mL2FD?=
 =?utf-8?B?d1J4M1VMbVFrNk5hWUgrVEZDRXFxb282L21BSG5HWktBSUZveElXeXA1Yzh5?=
 =?utf-8?B?bnRITzFSaWllaENGSm9PTG9QNEZqcFBFMFhUVUxWNVVtREx0M0hrTmlmRGEx?=
 =?utf-8?B?akRHTmQ2bGZmQXFGT1ZLRUt3N0x2M2ppcnMvdElRaVJVL3pNQk9BMGZIYTV2?=
 =?utf-8?B?N1N4Y1RNMnVrMUlqOGZrWEpuV3U1bWNYNThkNm4vZWRBQkhrUUs5WS9WRXRS?=
 =?utf-8?B?eXZIQm44V2YxUUVaUWFyZE5ESlZHSHB1c3p4WVFTYlQvc3IvVkwycHdBS1c2?=
 =?utf-8?B?V3hiQ2tHc3MzNFlVYjl1V0JQR09Odi95cFV6UzBxcEJYNFZkQ0ZwOXdSbEhL?=
 =?utf-8?B?QWZob0dOaVJDRENrZTVaQmFUQnRNa0RoK2pPUHZIM202MEU1dEFrTVp5YlZh?=
 =?utf-8?B?VHBzU01yS2Z0YWEzNVRsTUlVUzJGZUFUcHV1TUQ5dHQvMi9DTGhrMG1RQXhr?=
 =?utf-8?B?alRQTEFvMXlVOTNFOXUzOVhLdS9MTGtSaWhmU2MyVTVyV3ZGMzE3c3hYeXo5?=
 =?utf-8?B?YnhHNE5GeENZUE9XdHlGQjNxNGZhbDZNR0NEdEpISnVqakxiTzVZTVJPd0hu?=
 =?utf-8?B?Z0g2N3NGRTBGcDBFaC9La2hVRWo2Vld1eWM5SUNZLzdBWTZzRFN5cWp6SVhj?=
 =?utf-8?B?OXoxazJwQnhhOWxES1VXNWUrSzV4cHJYOE9PeTNUdklJQWdITTB3MzBsS0U2?=
 =?utf-8?B?eHRZMXZjK1ZzSktVL3BZZG1ubEdXWlQzY2RnTzcvU0xvU01CZ3MwSmlxT1VO?=
 =?utf-8?B?b0Rnb1ROZUxNOERtbzFyQjNPcXBSVTg3di9ITDlFNVRUVERPY2dtOERLQytM?=
 =?utf-8?B?REtnWVdkb3R5MUkzOGFEcFpRdHErdkhpS2RuZHpmUVJFa05JVmgwbjY2bXIv?=
 =?utf-8?B?ekJ2eUZ3S3JYQUVhc0VIL2J5TDA2L0VqdzVSNC9PTG9uLzgxcFFjREdNUjZG?=
 =?utf-8?B?ZUdlQjV1QTVJWkdhSTZFdzRNaC9vdG0vbXdNN2IxcUpkTCtLRUQ1czdteDNr?=
 =?utf-8?B?MlpUNDZPbDhNQVlzdHd5eEZTSC9OVENDR1Z1ODFpdHUrdFJ0aXk3d2RWN2FN?=
 =?utf-8?B?NU9DaGtDOUUyYlNNNVNQYjNBY1B5S0xWTDRIV3NRcnU0TzQzM0J2NTRpUWtK?=
 =?utf-8?B?UVVtM1BFTHpiZWRRbFRTeCswZlYzbTlabTdyVU5hWTF0QVlTRmZ3dS9vZk5u?=
 =?utf-8?B?ZlZIYWhxNVJxeTRZYmlxSzliT2QxK0EwN0VYeVo4YUxPbWpCVWplb1lab1Ro?=
 =?utf-8?B?L0FKY3BXUXd3dWxMaGRkSHh5Qk13WFNFaUt0MVcybDVSZ0laVnRtSFY3ZVF0?=
 =?utf-8?B?LzYxbGh0Z2c0QnNudVIrZ1ZwU0R6T0haMVFCQjRRazMvWWhBQTBISk8xM2ZV?=
 =?utf-8?B?YUV6SG9ldjFxK3JOYlVyQTYvVFlKbWk0WUNXYjBPM0oya0cyV0NXdFdPRWRS?=
 =?utf-8?Q?IzzhCUXeeI2nh10k27Dldtc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb24ba4e-1a5f-4d91-02d5-08ddfd18a832
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 16:20:50.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDQiDrMVy9ugHdJ9BM8fujjX19dsTrH1v6DD40p7ope/QzStuoeo+AkcWmq+SzW6Z1mtJXOM64OSwgH4qMT8yDW5pSQPFBf3IPn6v7FpVL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7066
X-Rspamd-Queue-Id: 12F4240013
X-Rspamd-Server: rspam05
X-Stat-Signature: sy544j117u7rob89gw3smib5t64i45r5
X-Rspam-User: 
X-HE-Tag: 1758903652-41208
X-HE-Meta: U2FsdGVkX1+svpPmnmkFRe/88wqXfSuxQH0Z8IFVZQmmQya+iMTBWwJZpslxQwnlfx5cKXD+QQTg44UufJfeEwy5IJFbfJiWASBCjQYvr0XilJk0NieAzI8fnDYI9ruOhtrxrs9PuJhb0Vyx78gEeQvZx+yf8/b+ZRFhmACZxC1U5B8YNBqULYW3PYWZ4hk9zfV/oIbDPXNDPo4xYjEYnQik2ac6RGHxVx5n5Q14o3ZOYR2H+aF3m8RXYz0b9xk7aW2CnL6zUFjqszYOSB7rP+Nm92PJQXAb4EZL8ndYhNVgI8NotF+nrqcrOXRIR/FFaJs0+0Qg1goYgwkm68AOEGET9HKkushZRC6zc7YX/PicgcXPgxejWH2vd5zL7JjTojQ5RHhjvnk3COMKlVTnnuf3uGHh/GDeLA3OfF1HB83HU13IAHjhDF/BakeHHuXAIcFnZ364japYO0uHziOjKqeyHXfDiboaeUA4BCR6AjL5JPZE9KLAY9yhmK2saHpVCCHSZH6yBed4a1X/FfDLfbbpcpKA3/xGobD5XMVwd1GuRgePlzrbJjGWox11JMB25UreMMX88qRTI8Ljpx/R4hpGXYY9XRfLn/CTtKMzfsDF2qJbr1zseqpzdO8eBnjE/rUD1gI4jGbsXoPdZmHL5JX6fi1UzJhFtjbIonnFdpSP/AJM20n92YgvuxlYGLmJLruXh1Bf+TpscEKBXfcpFQ/IZUY2TtGgzDta9u0QAIC96Loe2Tvv/cePdoJyOOVbC0owyJxv0d+Kr7L8fci6ZgMrn68ls+1ZsbNekiNMCRXFggEanoIrIRfRuGIsQLl3JDZxGwJfggkoWrsbOnhZqKLwwMo4174L0Jyyh3MPSZV38Q0MKP4MtKTS6BaKslZteCye0VeW5PmiCPcRj0M6rCEgOtdO0YjG0MoQahJuvZbJ20t/8hqQftnwYobByab5Vvt3lmbZ/XUxF4XzQFc
 GmApQzkE
 VRBBX2hS8jpROmUSMcm/pvcmxRCyYELkKSA6mln5x2GN31s7HUrbjOLVS47k8zvPkl+HwF3zodnG2XpW7VPCcSfDyUQaAr4sx5O5Pauw4l/CjpIkbKX6fG/2VmIX1vUXXl5tEOQnwYRN244E//YVq2ZeMe1Vplm9B4SN5OcqYTrx0wY9QBoIIJiQcJucK6N9qTM9Yrp0S06CaygKl2R3wrI4ctZP7p46KdFftGiWJLwgmMMOZRdVYqdfwBSR0GdFY1KbA/55TJTK7R9Nblm9C4f0ERr45jP4L8wRABEvJLXHKumtWw86ziiVvxKVZ0DdfA0Sy7NzCNHNGsDxcEOHxcRWQ4QKGsOMpzqjYXCCaTDagCQiErKfgdr1QekUCo7mZa8qf0iHHpaj/PW9Y1WMHdLsJhHJH0gDgsd1T1C7kkaOIx+4NVVQq0LXoVV1ODYfCobzGn2NKyLthJbK2Di0RYkz2iddIe2XD8pO06moHNud/+6lhc3DEnmgFTNoFnl+jpbaeO67VhxZloVtrpCQfqpAI2/dKihtSBCBRd4cjph/0Pn4Uf6ow3G0SOeMQJ6HvRpwC+gYv5TLuXVMdbNo6VjgoFlsEjcevBa0i0yycosADMRimlgsMThV/NXdNc9TfZ9sJ48HnhHAASW6lfVucs38EikyguuQa6vYu5qmmn2oCmRpZuzbfJPkfMbpKxioxQOhMQsfcb1mzbhQy+ZOnC+WR4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
for every single page in the affected area. Soft lockup was observed
when doing this for large HugeTLB memory area in our customer's workload
(~300GB memory):

watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]

CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 5.4.4.1 07/15/2025
pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mte_clear_page_tags+0x14/0x24
lr : mte_sync_tags+0x1c0/0x240
sp : ffff80003150bb80
x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000

Call trace:
  mte_clear_page_tags+0x14/0x24
  set_huge_pte_at+0x25c/0x280
  hugetlb_change_protection+0x220/0x430
  change_protection+0x5c/0x8c
  mprotect_fixup+0x10c/0x294
  do_mprotect_pkey.constprop.0+0x2e0/0x3d4
  __arm64_sys_mprotect+0x24/0x44
  invoke_syscall+0x50/0x160
  el0_svc_common+0x48/0x144
  do_el0_svc+0x30/0xe0
  el0_svc+0x30/0xf0
  el0t_64_sync_handler+0xc4/0x148
  el0t_64_sync+0x1a4/0x1a8

Soft lockup is not triggered with THP or base page because there is
cond_resched() called for each PMD size.

So add cond_resched() for hugetlb to avoid soft lockup.

Fixes: 25c17c4b55de ("hugetlb: arm64: add mte support")
Tested-by: Carl Worth <carl@os.amperecomputing.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb5c4e79e0b8..fe6606d91b31 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 						psize);
 		}
 		spin_unlock(ptl);
+
+		cond_resched();
 	}
 	/*
 	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-- 
2.47.0



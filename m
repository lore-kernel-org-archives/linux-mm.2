Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB81CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447976B0011; Mon,  8 Sep 2025 21:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7FE6B0012; Mon,  8 Sep 2025 21:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF7D6B0022; Mon,  8 Sep 2025 21:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5F96B0011
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:14:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCD8F13A633
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:14:05 +0000 (UTC)
X-FDA: 83867940450.10.CBE7579
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2080.outbound.protection.outlook.com [40.107.102.80])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23608180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:14:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mT0RLcCt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757380443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Atlta8IZWQ5ju3AtCunZTc/L1b+Ko7EU/ZvPX+qnyo=;
	b=KxKTfvRQJSV/ild9tnBIR2goxjR3IIDjugS8iBZlIFhFwYnvp3uErW0Hob+sq7VWYOFXDp
	AQUwpdupB9hvlMqXk1wT03oqweLuHuJ04heimNjySog4dUjzrLfAETKBgBhVUoweb6EuwV
	aoNMxmwdSKXEPibAlqSd7cSSS/A31NQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757380443; a=rsa-sha256;
	cv=pass;
	b=ibzAnkYpr2/vbH8BIaz8aSRt+zydYAYZWJ/4yQzOB7Zu4JmHGPjQ1s6TcaSytS11HeqRl6
	WMvYWu+WEJ372qOxm15DPyrd//COzz9LUNKKq4XwghKuYn7DvFI4MORWsUDNcCse1lj7GI
	VAMn7F0J+jRxKJexM4ill6QFf7XA0yQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mT0RLcCt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSAluim/IMQy26ZQ39kg+6tEAVKtyzwIIn10lkSGjW1/rT/Cd8E10DUISxOKWZzdADlwPn92R5995t3S1BYUOz/9/ZdSTom9jriPnh6j6baKYeB9knLpSpgIyKwfvJgAGmrnja1pNFaI6nJ9GSNu69K6dI6v2tG4b75CwshXGMkMD0yUEtCDvJCbu0eJ3buvwMZwgM6iuT6bfiSQSkSKNGMZq2wIZNY0YdtQU/UqkwQkHty3GKIPaqPedWJYN0JGL6cjQ+gXuc92173olaBhfE31rDeEKO96Xsq6Kj8wZh3e+/NgM8cVG4NAqAzPqshouYR72luT2A2DS3itEGDhlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Atlta8IZWQ5ju3AtCunZTc/L1b+Ko7EU/ZvPX+qnyo=;
 b=uEnEF6Za7swVCCwtyiA67O3ec9D2B/AKatojEL431riD/947ce9ghTKfraKJJ8piXF5aOiKR68TrJ9QgWSI2I+svpcDlN2LmdHpPwWXFZPV50YXZRzfypxkiPymrCgUde7wv2icjHWBqqFVopFhgNawp2BUG1XShArER8AD/ZOBTV/zgvwf05467z6rwVt5uLWtItdjFbzVtg+mLJ+476syQMWScYtq0vwbXuBb5rnXKf1NCSl1s5yh5kO1tAdl/FxRd1stDC9hFOPerQPZWOhq+4gC6/R6dQO2HgZXpKZtJ6+hUZN8Ki+cUm6YYEkNPSrmsV40yVWoR2TFkBrO+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Atlta8IZWQ5ju3AtCunZTc/L1b+Ko7EU/ZvPX+qnyo=;
 b=mT0RLcCtCaAcg6evun0cat3Aj4yhgdHZQ4OFV2QlCHMOcnosNRKSSvwCPfHAEm9FFvrNzHYyBgj9Elcc5DJzDCfg5uG7VQkG1boKcWZgzVjg8zhTOlKtV3wwHI/47jWoUXX+gfq9sRd9KX7+Ieq1TeNt6Vcx05Q65BasJZlf0vK4IO4S7CO9ZEGPgD1r88sMRIWMul6h9Kvw2f+YFY4ilcUEfyv3+GMRzO5B5UdTBQl8adtbGkgy/o+z4JWwzf7tJs7Y7FoFYfzBFjxpgksd1WIgy9A3q4jw7tQ8x9JSc2z2DigqQAx3EkMIsASKA+EX5/ek/W6vABJWAVNZ05KwCQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 01:14:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 01:14:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 4/9] mm: hugetlb: remove struct hstate from
 init_new_hugetlb_folio()
Date: Mon, 08 Sep 2025 21:13:57 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4EAB726B-B360-4198-B840-04C3E8152398@nvidia.com>
In-Reply-To: <20250902124820.3081488-5-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0281.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f5dd48-31b5-4d89-5b6f-08ddef3e2843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzhsOTFDZTlFNDc2WE8yUFYrU1MwalhGQ0plRHhCWHpBWEk5aDAyOVVOK3I0?=
 =?utf-8?B?S2Q1Wi9IcUMrR1Y1SDZkekZFdUhPdHR4QkpZcTBNdXBPVkprV2VwSWlvMXQ0?=
 =?utf-8?B?THBVemRNdHJXZDR0eXVidFowZE9VUzhEK0tWdG42THg2b2IwOTF5NjEyZ012?=
 =?utf-8?B?ZlVGS0dJcXMyNnVRbUR3cHhIdFYwMDd5SUs1aFZ4SFJmYWkvNjFDVHRqZUFq?=
 =?utf-8?B?RjVlQ2RpajhhTStMUmtndVBzK0MwMzNRbWJiV0R1SGJHWExMaG9ZbElIVlNB?=
 =?utf-8?B?R3pBMmJ0OHVraUhmNVBpekJHUW44cnczTlRsMFJCNjkxNkpDcElNdklOQXZY?=
 =?utf-8?B?b3Zaemlxb1Jvb2pza0d5SFppRDQrY0xWZk5RM0tvU21raGphcXZKWjI5MU9U?=
 =?utf-8?B?dnc4SmFZNEV5Y1VzK3o2UVNqY2V2Qktka083SEw4L2pLTHFJZFIrYXZHYUxn?=
 =?utf-8?B?Q3p2YUppS3lhNlhpd0lxVEQ1WnYydERwNmduaUZXTHFlZFVMcDN1SEpTNFB2?=
 =?utf-8?B?VlMyWFNoWnpmQTdzL0Z4R3BGY21XY2RkVDFXbTZQOUZmNG5rSFdKU0s1bnh4?=
 =?utf-8?B?OHRoR0cyVzdPQk5pSGRneDhRV2JHeUVwalp1S2xvMGNHc1NiZEZzelJxODl2?=
 =?utf-8?B?TWZab0Q3Mk13Y2c0MERWZGlXSFp1cHpZN3l1d1hBWkF2WVFLd0Ftb2dyTWth?=
 =?utf-8?B?M1ZEVmRZUUFhUlB0M1ZvbTFJU3MwMzVtSkQ1L0JPVVFxeVpCdzNqT0dFa1l5?=
 =?utf-8?B?WXZMRUg4aml1eEJaOVFLdjRwTnp1cW1jRUVOTlVmY2ZrUjB4NnZlMjBBMjYy?=
 =?utf-8?B?K29zZlVaVEFuOHhJNnFKVkUyNjRnaFJ3ZC9Ucm5DazAyanYyTUJmRWY5SUU1?=
 =?utf-8?B?akw3TWVsbmtRUXNHSUZvamZ2VWsrcjYrOGJHalMvS3IwNVhRUnVEcmJaWk80?=
 =?utf-8?B?TDZjcnpZeE1iUkVpcnpzRm9qOUJrZHRxVmp4TTlmV2NHaXpiUElDclhrOElk?=
 =?utf-8?B?bS9OZWFveFR0b2p5UTcvd2hoOHk3ODBJOG55MTJuMEIvWFZuVjcwKytuT0ZN?=
 =?utf-8?B?N2NESm82WjRpODQ3RUU4ZzBPMlRVMDNrWm02RnhxWlVSQk5hcDkxODJEOG4w?=
 =?utf-8?B?aTZlSTJwKzRGRm9oU0lzUmJwNXdnR3FxeGoxTnpRSE9SdlNMc2VDWU5aeWRp?=
 =?utf-8?B?VHd5SFU0RUdibE5mNjlISk5zbysvVE5aT25HUXpJc2NrcHZDQ2RNNTNSc1Jq?=
 =?utf-8?B?ems2ZDlNalc4WlNTWWRlT2g4cW1sY3NSUXNpeXorNzQ1cHp2SnluK201QlZr?=
 =?utf-8?B?clJOOVgrTGcyQlI4N1UvcVBxVWsyT0tDcHVzaXQ5cnF4WU1MNnc2RGs2b3hZ?=
 =?utf-8?B?ZVp3U3MvQUpMQUQ1Q3dwL0RuQWtVejhtRHhIVWFmUU9CdVFkMW5Ub3FuaG91?=
 =?utf-8?B?ak9ENTVNWkNKczNXL1JWNjF0UXZ0bFFYV04yWG9lOHNCOTlUbmN2OW1Kd25P?=
 =?utf-8?B?RXF5L2hpMlpidndOeC9aWE1VNUc4NHFWN1lBdnpuZng5TXE4R1JnMVF3Q0Ra?=
 =?utf-8?B?ZkU1Q2UwVFVibDB1cWI1WVFPRXB1cGUremY3UGwrbENlQkpTM0NwNG0xaitH?=
 =?utf-8?B?TWQyN0ZzdXVycDNGYmxVUmswTEZ3YkJ1aGtRREkxdWIzOVN2U000NEJTbGhR?=
 =?utf-8?B?VldLME9nODkrNnpnSjVVQ0dJMjBiV2dJd01YRkNMM0Z6aFcwY2xJdFlaOFVO?=
 =?utf-8?B?UzNWWUJvbEFqUi9OQ0Myd29kek83dzdPZGFCT042bGVmRlZaakR2dnFNNnY4?=
 =?utf-8?B?UEIrWTVtaEhCQ1h0by9yYnBQTGhhY0MxRDhZU0d6Z3hjNVZiNDh0UFNXeHk0?=
 =?utf-8?B?b1dqVGpxOWJ5LzlnZld0L3N4Z2JwYStBdEUvUC9HR3BvSE5MNHZYb2tVZkw5?=
 =?utf-8?Q?ANjekaUc090=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmErbVF5dEMvdEhmdG45OVR1QzNxMXN2dnRsSUN4MFZaMGUySjZDRDFKS3ht?=
 =?utf-8?B?WUpmMEUramd5OUZ1Q0ZqdkwyZGI4ajBpdzBvd3JlZmFFUGoxTG1pZGV0Smkx?=
 =?utf-8?B?TU56QWVpQ2twM0IzbGxmUFJIZXJNaXE4SzRubWRwdzJBTnlHQmFhUWE1VDJN?=
 =?utf-8?B?S2lncTJJZDJ3VUhxYlk2UVRMTUNkcnhvNTRRTFVhdTRuS0FDN3JRbGdEbXRZ?=
 =?utf-8?B?VzVLbkZxdTBoUld2T3N1ZUpRUHpQOHp2UTFJbG9ZL09uelgrblJQZUlVM0Q1?=
 =?utf-8?B?bHpvbWc1ei84QmVpZkdWcW1pU2dQL2lJcmM1Z2NzNERxSEl2RldEbDNYbEVi?=
 =?utf-8?B?MkhDY1kxNEEwYlpaNjFvZWdpdEZvMkliSklpV3g2WjFaN29ySlJtVEJTVUZy?=
 =?utf-8?B?R1FFVmNUUnVST1ZtNms4OHZKZm9ESTJwNkw5UURtMGtJTWhTSWRrYkQ3NEww?=
 =?utf-8?B?c3ZKVnMrUHc4VTgzcGRJeE1abGx0YUJkT3F4Ui9QOWJWSnloY3hscG9mdlNQ?=
 =?utf-8?B?K2ZldzMwRmpxUnhWVmtXNWgzaWgwekdsZjIyQ2huN0ZhYWNDWEQ4Rjd1TTg1?=
 =?utf-8?B?UzlJWlBnanZzWlBDZmdGTDd1SnZsUlBRbHlqKy8xOE9hQlBvZ1RCamNRNHIx?=
 =?utf-8?B?NzNrOVVsKy9URnhKOFhGdVd2TVFKdjRBS3lqeklWWkUyam5UVlZGTEhtK0xy?=
 =?utf-8?B?MytXQUIvSko0c2pvSitEZWFmNzFZRkYzQnZsbHhLTlk2T2ZzTkJJZ3ZGQUxF?=
 =?utf-8?B?V05ScFB6ZnVveURoVURCYWl0WDQ4dWZjRGs1dmlucUpwTW9oQi9vZmVWVlhX?=
 =?utf-8?B?ckpNOUR3Y0NFcURjcDlXVnU3N205aVMzaUFSMWVJQ2Y5clh0WFFZMExCdmY5?=
 =?utf-8?B?OGpob3B6NzFtcENsZG9aVWNjdGVtaXN1bmFqSERpQVpzSGUweWUvaW81U040?=
 =?utf-8?B?bnNLbWQ2WWNJLytTM2ZGTlhCcWN0aGJiSHQrVTdIam5Cdml2bDR6eWE3SEU0?=
 =?utf-8?B?b3JDRWt2ZTdIb3djSy84dmJqRXFtMzc3aXhhVWNqbGlTQTdLeHhPZzgvcXd6?=
 =?utf-8?B?NURHN2ZOQldld05hclhiR2pvaTA5ZktOK2JIUUFZd2ZFWWlBOEVoVlpqeU1y?=
 =?utf-8?B?MUVKdE5TdHhrcUhwbmg3VmN2S3dFRXZaSUpDcE5CSGNjOFlIN1RLS0c4UC9l?=
 =?utf-8?B?QjMvaWsvV05pNjZEM2YvUWExc1VQSFZGM0kvYXhrbEZVakxoWW9yM1FGVHZk?=
 =?utf-8?B?cGVCaVEwNWl4clI0VVEzdHVrN255dE1sTk4ybzNZSURHcmEwdWNDUjd5d2hJ?=
 =?utf-8?B?WGZIQndHUVV4cjE3TElXbTd3WFhUOUJjK3IvMC8yRHpMMzFwWjE0cnBxZ0R4?=
 =?utf-8?B?TE4zSkNSdTdIUU1VcnJxc3BjeU9MaW5XR0R0WTRiM1V3L0JaeVVIZlhQWDdy?=
 =?utf-8?B?RDVZUDhHMkw5WTNpbzZkeU1yWnVHeStTWkV1LzI2dUlPTWRZMWt6NHlKTVlY?=
 =?utf-8?B?emt1cDVWWXZ0K3hrZ0JkbEdhcm9YTDVMNmRhcFVTamo3VW1oaWN3RkdDV1NW?=
 =?utf-8?B?YzVVSHAxNDBadi8zYzNwOEhSVjUzTHM2K1pEN1lOY0I0b2dKQnY2R0hsSVlx?=
 =?utf-8?B?eHlHYThpU2s2WVB5VnJGRHlMZFJHQ0lTS3pLWmpSZzNsb0FhS0s0RW4zK0Uv?=
 =?utf-8?B?OE1FS0FUcml0WTVHSUZkUnVqUHZRcUdrVzA1dkxDaENoZGlHMkkyU2dIMjJk?=
 =?utf-8?B?TGQxSVhXZmZ5enNwaTJSZUxneExQUUJNakJTMnErZ0JkSXVVRFg4T01iQkE1?=
 =?utf-8?B?RTllS0wwZnY0c1Z0SFVkQmEzeWJIRmdsWDdyV3E2LzFrTzNJQlJ6UjBTQmhw?=
 =?utf-8?B?WG9lUFdLQmVKQlVwSDh3QnhyKzBEa2xRdWRvakJZZDNCenp5RXpJVldBSC8z?=
 =?utf-8?B?MW8zaDdzZThGT3RlYXNoTnJHUU94WldJb05lL1BDOEF3bUZIZ09Fais2eWVQ?=
 =?utf-8?B?R1JlR1ZRZzZaS0NOZE01L0t5Sm5uY2RWZGM2SHpaTTJNUVppMVNSL1FGRDBx?=
 =?utf-8?B?L05pNUM4RmVZM1UwbSs1TWYvVVNrQmpUNlVLK1JIK2VwYmRDYmhtN0txaWNu?=
 =?utf-8?Q?ZGQn6YjfedzWjE9AztaYNTo8i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f5dd48-31b5-4d89-5b6f-08ddef3e2843
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 01:14:00.0065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Im5BHO16ezcXeDeTSXqsoOHFzdxz+BMLYQ6rNCrJGVmW6bUzDAny+GzPqu16bhNJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 23608180004
X-Stat-Signature: 5gb6igw4f9pemzz7htx4dn3s5c9gqyk9
X-Rspam-User: 
X-HE-Tag: 1757380442-338938
X-HE-Meta: U2FsdGVkX1+oShdgHSELY7E92DXjqhFEKv+iiqIuAyKlVy2mAZo3lgJ1P93kVPnN6BUy67Q5LT/cGOvW4zn/q/9045JQe2l70G4lq4qR09pACMhvmvogQv7h8mF5EnBDv1DUTU83wRdGC+md/PbvqCxvNpk2E8FlDQpI7RttmkfSdzto0Ubo0GA+CkNbGW2vEBY6Dv+V28ITIu8jSjl9ZT4FBSNXQcUnN57kiZCudmgpIMDFIGYL8UYQ6bhR/eFY0Ekf0wTDeoXNJVCv5kZQcbiePMvtqonMkG+1RnBqG99djdGogz6JOOY19oM0/ViZh+u1onAv1UbGiivnFZnhqM9COeenvnMK9wHiTKZDdNVPrKyikAVm6NE2d7yE2gmqyBnd7NuvXMBEb06LFjpTwhfLHq8fro5Laa43PqezQUnV0iwnQ2bR1AyvCmJOWabm/mjE0iazHtAZlCAqtd8oJUcg/MRqfdDf2XRVoLmbiPw20wTDu0sdQLyjAGoqTw0KJQwgTcZnhftrUxrVpmXlqpMzqlxOwV7DCCCGfFkmmaXZLIYvBA+Apgpv9Vzt1taQEzxEx4YJo4fHIfY4NYEbISwUopWBQsF2dlos+en5NZXPIgQLpKhFSfxJtA2374DiHVqozatz2xDPHAW5SYFhqI5lO8A2utQRc+bXa9tBLSgBa5B4JTyuQKg5L7TPyfFgiMB/0xfypcb9vH/7paGelsl5w7d0E8gIFL7Psi4JCSgoK7+z8dK1Jxe9efxUDufz6n0hZKB/qT2Y7zdd322F9phxkMvsFGIirN+v3dkV819R7yB8iBvBJgkC1lhB1KJV/qM096dd4QqB+K63BSIw8My11gdPghNm8M8ouOvulICeE+IP4j4ANRfrsDOMHIG21K9klZU+mJPZnd8YmzXs/IVQYoIfdSqLJtYbGd0cKaZSPx5Byt4UKdr/4P1ZETVdb9uJUSxkz00akLLU3Rg
 Vem15GNl
 6h3OtPi1lzPGvd9UfNrX7VO+Yp592IFFMUrr3MjDo9AX+6s+JMe8XjaIGMH0VlMO1it/E+8/5YT7LKiAPRskgwtg1PyXx/Y/ZvF5MrMRjK6HvK1rF6ffUFGFlLhoQzm8LA21cmE764OhKVHJmc79sRh7iR6Z3kjFR3H8BqapXZPbxpNP76nTV+10LEBQECJo3b9fysIUzY53/wndIYi2Kv3+xcUG4ypJxYCs6866/YFdH6x4Wt8n7grVMZFT9Za6blcUok+im7Bowns6AlIYOHs+ojG6PyFNkM9KcDEw17oCZ5vWRW876ZFhZNxtqyCbqy6a5d3kGLf6SE4MUmUpbl8v2wXrUE28tYZGTSUhQBIwSWY1GbLUJ4p74B2z5isfuIUGEGWKC0m3cCbDZ2J2+cfR4D2OtnM7cSgoDzSHRhBHouByqVlhJ77C8aCERTprebsR40fJSwNFZfsQ9MCjkyk7JpJwLbET4ubnGxg+AlgCRbQSVZrCXTWVQ9IYMAdufP/c0lsavsZCoyNDay4nj9S7EGRuFBTQDiKyJkimVgb56BaOHfQP7qdX7vZFfopFAGscGFOJjU736ald+PQ0RLE409Edj2G7QOsVe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> The struct hstate is never used, remove it.
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Yeah, this was since commit d67e32f26713 ("hugetlb: restructure pool allocations”).

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


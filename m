Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D2FC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9136B0092; Fri, 21 Aug 2026 15:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490CD6B009F; Fri, 21 Aug 2026 15:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7136B00A1; Fri, 21 Aug 2026 15:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15C176B0092
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:53:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF7E8801D9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:53:19 +0000 (UTC)
X-FDA: 85126325718.15.C55C6AC
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1519E140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:53:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jKdOUDaN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xViayZG1OnDnSkfJ3cGi8zRY4ikVts0q1bVnizX4ugI=;
	b=jgM7UUaHINl/tLM8hT5mSXdmbIGSQICYKs36vhpSCYL65Nm0ug4t20+1gaOEvt+FOCqu8U
	gxNeqcQAPVIfenr65RX75gzSxVn9HwAk1EFBS7uWjt+G9qEgq2ZWg3xiwJNZePUsC+seiX
	OoCoaM8cthh1pGwYEeZvKxTLuFdMcQQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jKdOUDaN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787341997;
	b=PQt3bgnQJcPWY7W+m/L5ygJJ0cgAot8IMrsmft6LxduqXIFiouG73IMOaHxWxAP4qrEZCm
	BxY+fyFnCbspoFWiSwvjJ9Lcy7ED8ptzmvePuenbGWoRlo/OR/zjrBfY2y/ZjV7Qm6dcGO
	lAlCXjA2YsHCwvWjRtosM+Ubxk6NH34=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJJ+uGDOmlIYRL1Uhj4GUJGGXZiRRTVhBQeX9/aRFj0eFGK/4QRn0wmN7+l95r+3YOR6sKV2vhEdFoHcBm3BXXrc2BsPbIfeANKtP9E8fL4uyBGR/AbtCk8FFmgojNJ1FmyBqOLuI0d6vKUkgIc7XJdLhuZBPzz3Lbzvz7ynvAgl3mZsN0NjSjd5oc5Uwlk9GBcMUAteEc+PBt1J7YV9eVeLCohzIWnt0fG18K3E6SlcU+N20r7iJGJL7oHv2BzSzuZhLtUWmIrO1kdidfLygX3J84TrwxQE/IIxfjOCtWl3Jofypy9C5iO7kUVa+lnTaSPTgVDLBmZejUlUuCN7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xViayZG1OnDnSkfJ3cGi8zRY4ikVts0q1bVnizX4ugI=;
 b=asyQsN7oegHFxVxs7kqbm8iD98gp55ZBod/LFJq+P5bvWDCMtJGltHMKhyNf0/MCmYm5+ZP9+icEnVBRSqRZfG/51NrclEN0ITBRFnJ6k5MlV6qs+Gb6zOQvT+h5m8NDpou8BIlTxV+67v46mtIqWq46Vc0OpD1wVwJ6MlXDcGHeRqUS4hiqFFNgJtiien7g3igdmp2iMWs8aIRRyoFa1U8PvBHJjP6Ag+crZ9CdJM0gJpXaQC7SAyv8U6vJVln27wyKWO8aQ5rZDebchrsbtJOROH/iT5SV5UnRXk0VjZ76IW/ICspRkzkkVAj31R/2hxjcWqGPjmGYdkgKDVNQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xViayZG1OnDnSkfJ3cGi8zRY4ikVts0q1bVnizX4ugI=;
 b=jKdOUDaN2x7jqSLy7ldRCeslqMVKjOBEZ4ntdRI8h3aeJt6y3/r5qg30ZXgmA2NEK9WNX1IRz5xWP6eOP6rgPGlWkTFhwziTolSkIeeDbR8EtwM/6scjoM+0HG2849Zk6g8QkeQk570AH7eDVuAUJRD0bott7c8zfGtJJqMVKcV1JU55jRjXTrbjR/71pqiIUs24D4sCGOtpmreRMWiZE+MFBlzdBCVHRhidjAyaLgPXCz5guvn2//HGFszIBxkZYX7jj047QjMQxdmYhv0Np0NfZ1hHokUVHyK0hjwQZ+BIgtKbT89jUbVAgda+cImzebVa6BrFxVJtiv+kHUlJCQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9093.namprd12.prod.outlook.com (2603:10b6:408:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 19:53:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 19:53:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Aug 2026 15:53:09 -0400
Message-Id: <DKUVUULJAX9Y.V99RHS4OYGON@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/page_isolation: fix UBSAN shift-out-of-bounds
 warning
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
 <wangkefeng.wang@huawei.com>
To: "Qi Xi" <xiqi2@huawei.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260821025501.2752563-1-xiqi2@huawei.com>
 <20260821025501.2752563-2-xiqi2@huawei.com>
In-Reply-To: <20260821025501.2752563-2-xiqi2@huawei.com>
X-ClientProxiedBy: YQBPR0101CA0273.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9093:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4054f9-c82e-466e-f77a-08deffbdd448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	FC0qX1DygSdcIxsdFj61OysHyoZdE8UB+0H37VyxoZlhR4Qp4RdnrK+dPlNyzvlHY9J+I2EUlPk6SYgIcWBNLmdVm1o1lyTIYEzrJ1QyYdFuuRb5uu8k6WP60gsbwdhRG8RjNxSmsyvYLNwGCi20Ajjg16bcfRn+n5RGZ0dfaN/W3trQ6omOA2cZkjayuE0YLFq1AcNkZHJShU2vCcSs2ymPfgmOaM7YH3hqDgWTv8B776qK1CPkrCQxLD4u+Wnom1ImRv2sLqLnur7kIE0SVCsVALfLrIrWyW7PPc9+NZ2X82c6Hw+AsAktvRFEzxSpnZQnZd5ciyyVkq+5JXHuceFigcL/IJ7N2Nigrpwl5sP6lK6iXZblMzOudFtQNhwmZK3iSFwHoVBLq4pnJS1j2tzjNTHuuDUu35pqYYYI08YiEJEPfbOuaYyDckiV+XAIyXW8/ItwuJH4ff6VLRBx/TeEAA7jdLrATXuJdz1ep+yWz8KxBzxleYQXnj5rs1If9UTxM8UumPRu3CUtFxzOc4HP3EcKYU8lwaUngKtlnU8mr5jbwVSmujkNvat7geDOolu9szujfmlJhEvJNonjHvNweR93G4tQIYTsG+4JhArayGP68jUgjITKVvMvP8cR+ebCqMlH4yKhPxKCpBe/e7B52Dw0IuyQNBfB54Auj2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWxCUEtPRU9TVm42dFJLRVEzOWdMeTY5aFRuUThRcGMyM0Y0cUhWbUJOekpu?=
 =?utf-8?B?R1dweHcwZkhIVFVTQWozUjRuYzUvUEwzdkJ6VkJITnlHbjM1ZXRxcCtPVGlW?=
 =?utf-8?B?VHZiNkx1V29LVVc0eGg3M3h6SFpTU0RnU0tjSDlucGN6ejVvVTcyUE1QUDdG?=
 =?utf-8?B?QUx3Z2xVMGhoZis2MGFXQW56Z1dRUE1QQ1RSd0dyZHJHR3ZJbWRqdHdrVk1T?=
 =?utf-8?B?RVFvOTRzMUZoUWU1WDlrWHV1ZUpmV0lZWDgxcU1MWS9udmFUZVVMKzlkdEx4?=
 =?utf-8?B?Ymt6V2FrS1R3aTNheGFOWnBFNk5KYm02Y29ObXI3ako4dGxUNk1WZUdjMWpG?=
 =?utf-8?B?b3NHV3RMa1J5UDVhcVp6RExUNmV3TVordmNOUHZoWFpxRURLWXVKUjBQSHQw?=
 =?utf-8?B?WlY4S25pL29wdUluMXdQZ1l5VVB1LzNtYm9UOUdqVXYzN2JiMWdiZFIyS2d6?=
 =?utf-8?B?cTdHdTlFMXVQcCtReW9QNlZhWlJ5cURnWnE3RVR1WFo1UkFQdGMzUDNLWWE5?=
 =?utf-8?B?N2Y1WVlyUTF4M050VTBmQ0N0aUdyNGNIcmY2QWhXRFJTMExsdGk3NnQxdmdW?=
 =?utf-8?B?emNyRW9LRi80S1NTS1JnUzMwWmZwNE5pS1BBSFJkNVRqanZ1QU5iZ1hDcEo3?=
 =?utf-8?B?dmc5ZzZ2anpKeU1xVnpNeDdSZU44NW5hN2ZBZkxLZDZQNGxGd3RBUDE3UHdj?=
 =?utf-8?B?cnNzS1V3K2Y3aWdVeGs3TG5HQVY3UXg1S0RySXFzVTdHVnhJTGRxNE03c1Qr?=
 =?utf-8?B?dnV0WEs5VTAyTEhnY3J0ZDZBY2g2b29jeFlTWHYvSmZ0eWY5aGdMS1ZjaEdE?=
 =?utf-8?B?NmxkNVZiSjkyNEU1V3E3OWFjdFZqdTY1RHlsZEVYeUk4WUFsK1RwWGZXK3o4?=
 =?utf-8?B?WWU0enZNKzBDQkxJRDRLYTRpSXNFbEd5bEFGbnEwSHMySnJ2cHNBdmt5U055?=
 =?utf-8?B?ZDlqNFJ5WmF5SnBKVXZ3RzE1T3RKU3FuNXEzUjdqaUgyMGdQR3JTNkw0QTBC?=
 =?utf-8?B?WW9EdGtSNmVkaVNwWTN4RDdrZUZ1SzNqYWdEbmZiZ0FsdVNFS2N3QmZWTGNG?=
 =?utf-8?B?ZE9zUkhacDFsT0pPajRadnozd0JNZFNHTERvamF1b3dobjlLZlgrbTdWUys4?=
 =?utf-8?B?bUNxVFE0bU04bDBGTXdkUlQxY2Z4UWo1bk9BeTdsV3B4RlN0akJKRmFWVzNm?=
 =?utf-8?B?VmRieUcwVU9QTnZFdkc0K3ZpeXpIbndFdjJkYzYrdGJUU1pxMk9Tc2pzZGJQ?=
 =?utf-8?B?eFViMEZmRVJuQ0ZpMVA5ajRvRG1MU1JuQXBMOEJnWUEyeFBZQzNxbmlmd3I5?=
 =?utf-8?B?bjloZXhWNmJsbTVoOFZWNHlvNmhnMmw0S0p5UzUzclAzb1p0dTlWR252SHZx?=
 =?utf-8?B?TjNJd08zVkE2bzdUVDRUeFRlWHBEU0ZEMWpxbUFnZW11dnJIKzhGR0FiUE1v?=
 =?utf-8?B?Vnl1NmJZT3ZUc3VmdTZaWmlRQzRIZVYwNk1sNkp0eHZHdDZFWGg4V2hiWDg4?=
 =?utf-8?B?NHFHRHdMZGhhb0JHN1pGWGVYNGxlSDNYemFKWUlidjFMTmttSGFkcFUrQ1dH?=
 =?utf-8?B?bnU5anZIaHdZNnAycit0L2liRHVCbUVtaTVxRG1YY3ppM0MyM09lR29NcDZP?=
 =?utf-8?B?R04vb1pKQUhJejByU3U5MWJ5QXVGVHVGb0oydzlBdkZlSEtqbkd4eG5oRHRs?=
 =?utf-8?B?QXdmNWcvRVZDS0JQdTN2Nm4zdU1jZjZSblg1Q2JhdWgzdUEvaEJSdCsrd2xT?=
 =?utf-8?B?KzVycTdaUTFaRHd0UVNrdGQxNW40RzFmeitiSlE1S1NYcmp1cWF3Q3ZNQ1l1?=
 =?utf-8?B?TjYrdTFMdU0rY2hmT0E5Q1I0QVU3UWhVRjIwaFRNNjg0UHRoTHJobHNYbnZy?=
 =?utf-8?B?ckhnMk1NUitsRUJMSUYxWkRnUXJLd2wybEU3L2U2a1FLNTFwSGZZbUFwMFdl?=
 =?utf-8?B?UDF1Qm5oT2NvakFoa05hS3hud25qZk9tY21HZmp4cEVIb0FEdHBiOEo4VkN4?=
 =?utf-8?B?RHN2dnBmWEk5Ukc0YzhQQmxaZDlvSzJ2SnVwSnE3REFZRDNpRCs4MmowZEhr?=
 =?utf-8?B?YXozQlltOHlDaVRvT0ZORjZJNUo5WXhoT3FTcThtNlp4KzJ0cElNM1ZkWEQw?=
 =?utf-8?B?SUxsdXpCakpDV3JiTkdPYStSK2J3aGxmQUF0NWhFZk9XdjZxamxIR3B6UDlk?=
 =?utf-8?B?Q1g5eG45NmxtdmZmOEZtM1NQUXAyRGJ2MGs4czczVllTdnlJOUF4cWVPdFRl?=
 =?utf-8?B?L2w4RTk1WkxRcVhtSENTMEkzeCt1cUZxaXdJblkwSHlhaWZaQkdZc2lYajJB?=
 =?utf-8?Q?GvsLYs+KhHWla8dc5m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4054f9-c82e-466e-f77a-08deffbdd448
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 19:53:10.9856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kenByn0e/bLfggZery2kWAL5erPR1SFqvRXCpAdD3MjzbbqXazMphYcbcjjspPT7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9093
X-Stat-Signature: pu9u9fzyk9b3xhb554huxg4xe47dcfgc
X-Rspamd-Queue-Id: 1519E140009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787341996-118512
X-HE-Meta: U2FsdGVkX1+8K8E8fE2JgQTIDKOdVJN29YUAjg3o2SWbpaHqojoBdIHf/JfQtNU8Zh9f4bhQvprn1kyIDKLs/UFHNItB4fWgAKg6zsJuLbzrn4J/wTwva/0sV8auM2v/ylxhM63ai/vb30oGILu9HCbZSZr/SArAZsBW2Ovp417qJap+fpFApS+SgINRZ1zsfaZuFR1rZoQ138jYBCH3uYsjiVlguSMm5p2B007GcE1reIa6bfY0NhICNVU75m97Ce9JdXv16DNDO6GWvMOG6sOTtaEl5dZwx7gL7iiS7DdTYNBuqJFrus4xElhGLu2G93qVE+h7DruBBv+DRpokiZKKgFCe32pysH926zzaa72nt7FItAicU40EOdZTMW0FOdJGLztx9m+rGF11L5rUA0g1YB0R5GbAVFpQo+7H48HTZ08xEYPcgZz/2SswCyDtXj7fYPMdsF8JkdH8pctFPZ5kzhBBVHCNymRMbtR84+QyuzrUFLRVu3Zlmn10Zz6TVrdnOdqatkdN8kDHmatRgqllp5PuatqHbATJnv94BkZUEJ3GMEcPkT71TmfJSQibmRWWJPdcEq8zwkEdPLyS46BFC7HQGyXy/6az9fx7pCdMYASBA5DBHmThMLtqZcNdzkDYr3vbRAlWut6Ycdu6+PvQL3k2txuCQnsTEjffKPaLb7+h1xlJHXxC1OJApKTO7O4ul9SUhc5q94Kgb1dMAHL6VqEYme/mm71nqA7DAtz+8VDeIjULDmMVwyQhLwLrVQjf1F2NmvUrvZOOWgUrfnYpDwflLtrZE8MCrxkgz/JSVUJAgXdCzAM6qe/12LOnz35JgIFj2gOYlnvW738CcsvBLqkf091E90klVSUa9rEFqJ638W8A5Q9MuCWPCO5Sl4JboUFhv9zKHLdgs7tX8Bc1p2RCaPRjIjGp5ouaPQWCbC7oQIaKsVSAxAdBLTH0VnFAr9y2WQBe8f07yiG
 CVKpQj2O
 KlHTdU16hVxZeJjA2tr8XHuJMClmbvsctzB0lKu+9UOtsVEom8zB8N366QXBaB+t1Y1GKNmr7Jy4rXejKesLjCskIPs0mczsOrqg8a4+PgQo8UP4b5DVoTbICecniMz3QrDo3viku8WE/sBI909YWdel1fcsSuPzURer3ybyE6/Qgk9Du7K4kzDpIY+AGFNxSNbzLDMR5QM6LP9DhIdaO32u1BofHBglWhU5p54xaR9M5bFmf149leqtmwjD1u4ix0K2oFQgtT8ByYHH4HRme7JmtvmMkZRlM0hjtg9iOOPH6GRX1BS9ss0GP2A8jK03LoYPyjO2uZDRkEhBS8ZIWR4BSrXc2dxXN91tF2bQQEqKeg2AEGO7PM0VPppuDV1QJO81GHZ0dl58HojL1k98YlOGH/XtcrY4DGx8rdwIN446yoBw9CeFZ7W8tpHoLQDQebjDPa0Y3Nj8BtQoj0eB4drK+DPrGGNhoKREd6gT1lI+ADUZcQKSCX1DgJ8MHsDKSA96h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 10:55 PM EDT, Qi Xi wrote:
> A contig-range allocation racing with buddy allocation on the adjacent
> pageblock can trigger:
>
>  UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
>  shift exponent -749042176 is negative
>  Call trace:
>   isolate_single_pageblock
>   start_isolate_page_range
>   alloc_contig_frozen_range_noprof
>   alloc_contig_range_noprof
>
> isolate_single_pageblock() first calls set_migratetype_isolate() with
> zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
> free page straddling the boundary out of the way.  Once the lock is
> dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
> boundary_pfn) locklessly, only to skip the free pages already handled
> above and to detect in-use pages straddling the boundary.  Since this
> scan only reads page state to decide how far to skip and returns -EBUSY
> on a straddling in-use page, it does not take the lock.
>
> The window also covers the adjacent pageblock, whose free pages stay on
> the normal movable/CMA freelist and can be allocated concurrently.  So
> after the scan observes PageBuddy(page), another CPU can allocate the
> page, leaving a stale value in page->private that makes "1 << order" shif=
t
> out of range.
>
> Use buddy_order_unsafe() with READ_ONCE to read the order, and validate
> it is within MAX_PAGE_ORDER before shifting to prevent UBSAN warnings.
>
> Since pageblock_isolate_and_move_free_pages() already handles free pages
> straddling boundary_pfn under zone->lock, bail out with -EBUSY instead
> of VM_WARN_ON_ONCE() when a PageBuddy page appears to cross the boundary
> during the lockless scan.
>
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granu=
larity")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  mm/page_isolation.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 32ce8a7d9df3..f2b648a68531 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -387,13 +387,15 @@ static int isolate_single_pageblock(unsigned long b=
oundary_pfn,
>  		}
> =20
>  		if (PageBuddy(page)) {
> -			int order =3D buddy_order(page);
> +			unsigned int order =3D buddy_order_unsafe(page);
> =20
> -			/* pageblock_isolate_and_move_free_pages() handled this */
> -			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
> -
> -			pfn +=3D 1UL << order;
> -			continue;
> +			/* buddy_order_unsafe() is racy. Validate the order before shifting. =
*/
> +			if (order <=3D MAX_PAGE_ORDER &&

Can you add a comment like below to clarify the check? Thanks.
				/*
				 * pageblock_isolate_and_move_free_pages() splits
				 * cross-boundary PageBuddy, verify it.
				 */
> +			    pfn + (1UL << order) <=3D boundary_pfn) {
> +				pfn +=3D 1UL << order;
> +				continue;
> +			}
> +			goto failed;
>  		}
> =20
>  		/*


With that, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



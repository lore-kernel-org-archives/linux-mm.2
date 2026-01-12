Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C79C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F320B6B00A8; Mon, 12 Jan 2026 10:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0296B00A9; Mon, 12 Jan 2026 10:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63336B00AC; Mon, 12 Jan 2026 10:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1E7D6B00A8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:58:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74572BA3B4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:58:00 +0000 (UTC)
X-FDA: 84323767920.29.9C0901C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75F15100008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:57:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cvj+3EY6;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768233477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsgEEgAgYxo+xO/mEgBHFRbDSW6eSrBZJo7GB1p+yUg=;
	b=CRMsVQFqQqyu/zdb36IjPJvWynERMzy0F8pnsfufzYCbnKi801yIGoMnijdjuHOn7jSKq6
	Aen5CQbE5khLf95Sf2Njm/kpDoQOWzeEJZxiDhQqyl8koSjG7JKclKonFG00eEVqC3tZF4
	eHBUkxHULjhFFhKJyeWa31Cx6WwC690=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cvj+3EY6;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768233477; a=rsa-sha256;
	cv=pass;
	b=Ohip+tceF3+7027L9vr/P6gZWM7qQgs45Hw5AlcQ7BZf3F/YMydqPXHFrQuNebPYLHtMsb
	Q+RT+GC8JPm2H8+9SkvPKgNyrBoZY9x0Au2soW+Qxd7b/fdUGD+/wNQ4g9qvb89Q0ZF3YG
	SB9yj7AIn6x7PetIaAbjw//zI0fxuqQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh0PSBjRFq5NQ2/BJbyRrCOGyjN+dTZ/iv0xnNMlDr7QwqFjVqNM/0r6xx26fGUXCTfHkAr1laPTe0JMQXYfdxdvMyDjswvDGsv23Flch1mmP5DAZ6yjpjWQcgTMCPREZ+CDHRqN4XJpqF9rk3oaQyyMIyL15ki0BtEfRZ1yLk0f+pJG4tRBO1zhUbb0XenIS/MVN4SIxLyKwT6hhZYa6xpcW615gA/E/kzlj/9mSz0+WNbl54/kCg//hWSLS45JW69/kn4lO024ZbigJSDzmSNAUN4XXtck9w3HShcXHaZ7wUj58UkHrsKwvTN9HvgvRH8vwd0PFAW92BHbrpwUyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsgEEgAgYxo+xO/mEgBHFRbDSW6eSrBZJo7GB1p+yUg=;
 b=vwXlLhXzPfw4Zs9kcwl03vO8eDtNgzScVzb1v7ItuL3PGiZUWzuZYhmED4tOU98lB3aLL98BhN2gBNrBqJiIzOSNNtfpPUwb500oaGNuXW6gISJJNGBmP21vJyI1H43Ff9CZB+EQoLSQOR1690++3jepnbzkTdnqltXD5GkaJbYzMhr9NaS5RSUiqhWmfY6Dywi1sGAq67J5AVp/9tVAbxoBYGDanSaa2OHElB5iEQwN0NZV1cF5wlqDW1zq77v9NCFg19b+22yRZlEBG5BWGr7Ka6ZQr1EKiOKTCxePtPMUKb91BoPOskLV2AGzCHZMtvPfcqqbY+3MlMKEWHv7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsgEEgAgYxo+xO/mEgBHFRbDSW6eSrBZJo7GB1p+yUg=;
 b=Cvj+3EY60DaoqlBKWHoAjOIgiAxd77KSSDOCt9HCFLskOnLAmjhpFXZBkbdfYyIZ//pjLSOxXxVhTJuS6RtVfgEjWoNCdC33wLLB6L2lTQEUaxYkTg/vZvV2Iv/itEtALoxTBfpkw1jdzB2PBk8VwyyFbYdXf0f/4udRDq8adzij33BMXm8FPG3Cbdfa+GMaesbIiQvugBJVTs1oRNV6IRkrqCjb0bfJk2rkk/uda4QfxGZ4phbNHgRrDYs6ZCf8WU2bpRx12ocR6hMl+Ljoy0UmNh9fxI9a36DJltuz4ALzE3P2tENqqpHXuCisD5W58DEPUWT/x2Bo/WvoNiTdig==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6653.namprd12.prod.outlook.com (2603:10b6:8:cf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.14; Mon, 12 Jan 2026 15:57:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 15:57:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Date: Mon, 12 Jan 2026 10:57:46 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <21E14DB6-DA70-4F7F-8482-12DFED81153D@nvidia.com>
In-Reply-To: <89dfd2d0-cf28-41c7-be9f-b49963e77aa5@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-2-ryan.roberts@arm.com>
 <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
 <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
 <700A6B2B-9DD1-4F8D-8A38-17FC8BA2F779@nvidia.com>
 <89dfd2d0-cf28-41c7-be9f-b49963e77aa5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: db5b3a49-38ea-43ed-f27c-08de51f357d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ME5QVWp1aTRreHF6R09DeGY4aHpxeWV4ZTROZGpSWnUxWFFLWkRSVG5ORXlx?=
 =?utf-8?B?dWNTaFYwSS9Pc2VxRklyTXFqN05wOWhxeWR6Z2NlT2Y4Rm5ENDBnRi9zTnJm?=
 =?utf-8?B?YVFNbktGNDlXWGRBR3hTdWhRYm9QL0E1RDRHMDZ6U3VXT0l4eDZZWE9iQ2tz?=
 =?utf-8?B?SVdlQ3NLczV0R1VZUkluNGxrSTYwODVHK2hRL1l4bStjMjYrQUE4T2t4Y2Zq?=
 =?utf-8?B?ZkQvUkhUSjFUeklsenhzSGhhME5LckNOcjR4WnQxemcwc1N0cUIwMFBLQUdY?=
 =?utf-8?B?TFp0RjJFejY2czZlbHR1dFlHWE1qT3BnTUVCdnRhQklqRHhHdlNveE5OK1dD?=
 =?utf-8?B?WjlSZkhMMGNMYkN5WlRNRmpXVWtpaGZGVWF3WnQ0NmExalJybUcvU2lmbytD?=
 =?utf-8?B?THptbExQY3MxbjFQSS9QOUNnSjd1YzIveFNyaVB6MnJkL0RBN3pnT29zNjZl?=
 =?utf-8?B?Zlk2S0FTdW5LTFZSSVZWN1FZbGRHbk1ZMTJPaW80QUt3RTZWR0VRWmJ3eDk2?=
 =?utf-8?B?dkpIMTJwcGQzYTB6K2ZQdE5lMjIwc1FlRkE0d2JKTy94Y3JBVThNSmlzUzJa?=
 =?utf-8?B?YkR5cG9SVHJDUzk5QjFsYmV2MVZaMjRFT1BVQnUzWDU0K3lsRnZ5SjZNRXBQ?=
 =?utf-8?B?ZzYvQUpIY0JVaUlxb0JGZUROT2NiZkxYY1BrMHVsVUM4OGZHbDN2NVNlVlpM?=
 =?utf-8?B?Wk85S2FNd2pmUXcyZHRTeCtYc2VmNzdxVlR1TEF2MTgxaHA4OXlBU0ZsRVJJ?=
 =?utf-8?B?SnJYRDJBc2tUQXZmenJNMThvNXRMZTgzdFJEQnpVaXplczRaSmROZDB6SGxG?=
 =?utf-8?B?TUkvRGJaZEVUSFBPQVVKSDE4UlhnczlxVis1V3Avc0UvQkhrZlRtK2dJd09i?=
 =?utf-8?B?KzFFMS9RVmtiTFF4dWZRdXdzcTZ0ZFA0SG05VUo2bjNqaG13QzNicTBhNUZX?=
 =?utf-8?B?TnZ3eDVTVWRaSHZsZEhMUjkyZHZha0QybUt0MDJUUjJab29uYTJKR1RoazFq?=
 =?utf-8?B?alJta2w5bTl2K2xlN1QrRktMdUkxSDlYNlAzQ0tQU05uQlBxdzZTa1lqbERv?=
 =?utf-8?B?dUsrcm1WaUxpWXZrNzhvM1hZUEl3RXpiUXcwQXlMVVpPbEd4L1p2QmFVWFNJ?=
 =?utf-8?B?MWxmQ0Fsd255UVh6MTJ4bVNEbTFlNEd6eXBrQm5Rd2pDZC9VUWVKN2xvOWNN?=
 =?utf-8?B?Wit0d3dPQmhqSVpRYkZNTGhPbkd0MVB4aG5CdlJxZWQ5K2JXWTBKREJiWUVJ?=
 =?utf-8?B?YjdtdDgrUkU5NStWV2lKQXAralgrK25waGEwS2l5U1RaM05NeXJBK2F6Q3B5?=
 =?utf-8?B?SEpLbmI2dVB2cW5rT0czaVM1U29IU1I3SFlhbmZqdVJlME5xV3Y5OUlMcUpR?=
 =?utf-8?B?NmZQdWVIM25ZTzlyVDNhWkpzU0lqUFlaV1B2clRhOC9RNlRQd0FPdU02RVd6?=
 =?utf-8?B?L3pUdjBoZG5KbTJUU3pYSkhhNEZ0WVMrUWFFc1g5eElEUm14Vmt5amxFZzRt?=
 =?utf-8?B?ZWdqUHRzakNacWk2L1U1N1pHeklEY1hTbkppY1NIbEk3bVRiZ2lQYkFaSTB6?=
 =?utf-8?B?OHlXNDRacHRjclNtRlFISS9sV1RuUDQwV2V1TlBIRENLUmNEcTBNaHhHTmxG?=
 =?utf-8?B?bXMyZkxXUlZwWkZrYThQYjF5T0ZsRUZ5cnpvM1dNeWJTRGhtNktOWklxVUxM?=
 =?utf-8?B?dkNZRXlDWDgwWUk5MldBSUtrVEg2bndQd0lhL1ZjeXdyZGNxVkRzRzZBR2w0?=
 =?utf-8?B?UUduZ1NUSENUYWQ5aGh4b1YrdTZiZXlWZ3BpUjFudUg2d0E0UEh1S1hDT1dY?=
 =?utf-8?B?ZE5MSGs4ckFRVEVLMnBXMXg4UVNNTExCcWt5Zlg0ZGtnTUw1STFsYlUxeU1K?=
 =?utf-8?B?dzlaWVFzL2RlcFVkYmFZK0NZbGxuUldsRWtjb0pMTGsyVDdscm9QMERjMytD?=
 =?utf-8?Q?w2USpb1owcY7nMdx/dAOmdlh3zcKi8sK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHBUem1iTWJTc2RtOUhiKzN3dlNzaVQ0T3plUkQxaHJHMVJjWTFZM05KMlFa?=
 =?utf-8?B?QmZhWDZKY1pDS28wUUdXZitOdWxLWkRJVVQxSDFpQW43YTdvbEExVmJ0dzdr?=
 =?utf-8?B?aEJqWHZ1RTFKUmVIanFSZ2g1UzRMbXVJWGVGd05iMXNhczJnU2l6Rk9OMGM1?=
 =?utf-8?B?Z00zKzJ2cVVjMzJ0eTNiaXhyVk9EVGFEcHByVGtYSm1Xd0YvVFEyQnJMY2tx?=
 =?utf-8?B?VGYxaklCZ1o0QzEwek12THJhVkxyZStiQ2E0aTRlTUI4dlFWa0JHblNmYUhF?=
 =?utf-8?B?ZVJ1RVFtY1NZa2tIM0I1S0xDVUhLV2YyQ3VzeVBUMmlQd2lLcXBUc0dqYyti?=
 =?utf-8?B?ZXdoSEFaa2YveU1JQmdHVS9TZE1FRGdscGtCZVlDR0tENit0OHU2bzZ5aHJh?=
 =?utf-8?B?R0x3RWR6SThGOXNkMlN2OFhWNWVKUWVnR045Um54WDFNeUVhQlFLNzY1YzZM?=
 =?utf-8?B?aktTL0R1UFJRaGlFTUhTMVNzc3RxZFNDdVJMUzZ1UTlrQVFZYys1Q25CMGFy?=
 =?utf-8?B?RVhzSTFkNExBZGtGTGJJeG1ZYWhsK2pHY24zWEpYRDFxSHh4YkFhRUJoQ3hu?=
 =?utf-8?B?emF3NTdmVEsvMGlCQ01TSlVnd1k4a2pINDFIMHhNekRsS2oyL04ycVR4dm5h?=
 =?utf-8?B?M1JPUkg4SXpOeCsyeWQzbm9ETlJhc3ZvcnhkMXNaL0I1TnhnSEpPUGhlbyts?=
 =?utf-8?B?WTQ3cExmKzJCSFRpdVI4VGhnaVVTYm1IZmdnMC91SjFjQVJZY3l3aXNMdnA3?=
 =?utf-8?B?ZmNTekxFWUtJeXZnd3FCQTRVWnQrbDJPYlRKYVhhQlc1WVBLbjJ1S3lOYmZW?=
 =?utf-8?B?Z1NkWSs5c1JzeEhRMDIxL08xZVl5OXZQeXczR2pzOGdrTXQyRFFLa2dkWUN3?=
 =?utf-8?B?YzlPWnNSVW14SmZRNHpMWFhibEFkSTFNcXVjNmk3R0VRT2hnVUFQTHNZOVZv?=
 =?utf-8?B?b2RhSnBXOWJyZmc2RWdMK3cwSmIvUTFDcUdHM241ZkJrRW9KSmxQMU5RbUlN?=
 =?utf-8?B?cDZJcFdWQ1pOb2hsRDgzRkJBdDJmNUFSUmVUQkJnUXp1SWRsK3VmS3A3b2ZL?=
 =?utf-8?B?MFZyTEwyamZZQXU1cS9UK2Y2YWxIUlBFaXhuTm5RYWU5cTNsZkppRGVWNWxW?=
 =?utf-8?B?NWYzVHgyeENsaGxPK2NNTDRjUjJJV2JzTXRKSTZNV042MkJSTko5dGFBOUda?=
 =?utf-8?B?SnpTeGVOMm5FVVhkUEhOTnhiQzdvM2Zqb3V0Q0Nzd01RWXMwNTBta3VKaHYv?=
 =?utf-8?B?bGVWSGpTUHVQcHg1WXZQaDRwSTFpYWE4cHBybmJITmc3OStEalYwMXZtbnpp?=
 =?utf-8?B?ZkdKMDBTSVBBVVV1bU14bEg4RUJ4MEVrVXgzMEhWZ3JYMlNtUEo3QWRPRjFF?=
 =?utf-8?B?ZWFmYWprSElBNFBxb3N0UEo0TjYzd1VVbDZyZTJTRkdPbnFteHFCSDl2VkVF?=
 =?utf-8?B?eC9pb3pjTzJqZktNMXF0eHB2QWRjTDY1MnN3bS8rTDVRMS9rTVU1WUM4QjV3?=
 =?utf-8?B?MTdlNDlYc2xJcXpESFVDWmp4M0MxN0wvRm1QQUc0UklQMTRXM0tnS1ZLc3pw?=
 =?utf-8?B?ZTJXejl4cWZSSkFGT2J1NWZ5UWQ5VjduQ0NhZnJrT3hLZUF4Z3Z3RGY0TmMv?=
 =?utf-8?B?YmsxeEdZcUg3Z0NoTVlqdjRPVDVtN2plS0Z3WlJlRHc2WGtmZko5TVFZN0dr?=
 =?utf-8?B?RWRFRG5ma3k2ckhuYmFwaGhvWWNTYmVaYXBJMTlaQkJSUGhGS1dDYjZBT0h1?=
 =?utf-8?B?QzhYUHYrclRKaGtwbXJZVUR2cGs3UmRoMFMxdVV1ZUY4eWtiY21DM01aT2pU?=
 =?utf-8?B?aDZabWc4SjVSa1ZJNWE2SVpOVk96SERXS3Z0eXN1SVd3SGRXUU45Qk5QUmFt?=
 =?utf-8?B?NEVubXhxQkgvVGZKK1QzdUdsbytpOGYrUHA5d2d3K1E3dW5FdFVBZnJFb3Iw?=
 =?utf-8?B?UzV2Q2Q1UjNPNVZQOGtaN205bnN5SjBxRmdUSWxhTlBFeGxISUFKVk56WEgr?=
 =?utf-8?B?NlNPcEFrTXR2NmMzcm9oOEIzSU84QllwMHVDOVFyOGoxNTE2ZDlIWVkwNC9x?=
 =?utf-8?B?K0s1M3BGdWs4WWFDMldqSHcxMGFMSytwWUdQbDQrem1wdUlrZ2R3c08xSlAw?=
 =?utf-8?B?L092blFzRUFFV21Sd1Q4OWxmNlBqSHlYbVY0RUdVd2lmYVZXWmFwZ3hvV3Vq?=
 =?utf-8?B?MUlQenVudkFFZzFHOXJjcTBQTTBOL09CRmtldnpLdG0zRCtkTmpsU2FrQzRl?=
 =?utf-8?B?cU1jZmc2Zk10eVRyd1FoTExrV21NSytpNEZ3RFZyS1FUYjk1QlF6U3dvNnkw?=
 =?utf-8?Q?7mTZVLwECPgVKXpgf3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5b3a49-38ea-43ed-f27c-08de51f357d2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 15:57:52.6759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7z+FED0E+QS0twWIXqWOteKMJEyCDMfEwM1ZqqECKf5eyUSmi/8/HlSvbaYsa6j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6653
X-Stat-Signature: 1trgwnsqfjit47zmymwdq6kybirduiac
X-Rspam-User: 
X-Rspamd-Queue-Id: 75F15100008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768233477-924070
X-HE-Meta: U2FsdGVkX19DQAs48nooCsvjTdciJGmk0cxeASfxmrt4rI/jOJd167VQH64ndn6NsTQGo9oX0UDh2xMnk9gsERnjgOnXCqFDitPH/0/pdmK7UVfmopJ9oqjQNrj6HI+ieCMbgeMyRX8qMxnbtFD5PJk9DXIl9b/IHsmkTFdakMHJ6fYVL7Qf0Fpg2uvmlA2OoHK7TgONEU3SH1DnBcPYS2ZPRxz3wMbQwxgcGg/JpG7+yuBLrDMOpn7LzfwnPZqN3/bW4Z/iAMwVYeekEYqLDn62ogtNwupTShqNToCuCuTOJ4C38m2zEYwqf4k86j6PVyRWC2uDObY1IeFiuBRYDUgvWT/WUOOd8q7r2C1Su6C7pyx9qdsFtx298CVliSSSCZ/s3DJu4WXDjwMqNe0gSP9EfElzizqWGMifpAOHduzDTHOD+8ocfbTwbfnwHyLdczNpBOUE0anzFLKWfxY0YbFiEcABOlp00knB8IZPDxzI+1c0ZhLJwA7ICQXoxZx8+aEaGtYZoQOZqQnWxCsNFGGDnToLJCdSUOTVt4r0PXAIRnp+NJ//Txq1LcxgmjVfBZNcNmvwrmWFIN/gA8m09w6jZUr86qnbeNXkqvEwqvmjP8i/xeElSwPYjWDkgpSCItrhP5gxFn3vN9Umf87wYgm/FEJktnee55Gr5TN6ZZNuz5G5RgOW9vtdya4tcnGPK74g0VVendDqVlFievFGlF+OIh5hl1zGJsXUlLjyS5DhLWjXLsAomyK1gCkKAkRS9jtw7BGcVbYFCgvt8Sj/2/J76lBZmv4I5VO3beIDy8wvHVEmz/Dr2ospcDG3Uh06k1sKl6Py5m/wcxGt+K76Kp2hVsshzKoOXAgR6FDqS1ZdbKw53ynftSijcYrC+WLxVPKWfTAYp0Yf/6qPAOJGxd4HKpqciabr80YOBJkS8C7Zzmxgkse6R6muWvFi9ghWcenAZx4NsIytrdUJCyJ
 f4O/AQBt
 jSMPDgqg06fFuPnjN5anGn8d2PPQtNub3qSoj5iUHu6+PvwyM1o6jTaAxAMisF6EdhqxeMSmZKkrwgBt9dLbC0OdXtHVReHvVelB7CkeuhbfLP8GUAdP0rCqCx2YK5c1Gtnfvh8vTGKq1x59ASP2D/+PvTrfoC2uYHQi7P+GzzqHbMk3JKmCl5wsj36drVS+aw9Ta4XPcjHOcCqrfmRVFhf73a+o4LYZmNQ/PF6F1H/R5Hfdu4x298kldrDWdPf2Xa52/mUWcqqQ553Cm55wBJDp6wQ9KMoj78I9xLgpo2YknKn5EM59wdV/Cv/usNTD3ekizY6mY4WOLSR7M7VcnzBC+Hd3rtx4EqEjtjCs8JceasgsqmCzz/eLxGjvWqxB4PZHrakE4+Gv8BTvKv33E357vrRtSz7deMlvc84vb2+99kI1Eeemwe+fm3ngoajciQoFJJ1jeCReiT37DmCNWZ0+pYkL6EmtzBLpwg1AB3Z1Urk03Gp5JbrcsNURggeaXKiw7w/W+OTOcceWZXfhdgcwnj0JCXQaCGAJixmIrdfLndiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 8:24, Ryan Roberts wrote:

> Hi Zi,
>
> Sorry for slow response - I had some other high priority stuff come in...
>
>
> On 07/01/2026 03:32, Zi Yan wrote:
>> On 5 Jan 2026, at 12:31, Ryan Roberts wrote:
>>
>>> On 05/01/2026 17:15, Zi Yan wrote:
>>>> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
>>>>
>>>>> Decompose the range of order-0 pages to be freed into the set of larg=
est
>>>>> possible power-of-2 size and aligned chunks and free them to the pcp =
or
>>>>> buddy. This improves on the previous approach which freed each order-=
0
>>>>> page individually in a loop. Testing shows performance to be improved=
 by
>>>>> more than 10x in some cases.
>>>>>
>>>>> Since each page is order-0, we must decrement each page's reference
>>>>> count individually and only consider the page for freeing as part of =
a
>>>>> high order chunk if the reference count goes to zero. Additionally
>>>>> free_pages_prepare() must be called for each individual order-0 page
>>>>> too, so that the struct page state and global accounting state can be
>>>>> appropriately managed. But once this is done, the resulting high orde=
r
>>>>> chunks can be freed as a unit to the pcp or buddy.
>>>>>
>>>>> This significiantly speeds up the free operation but also has the sid=
e
>>>>> benefit that high order blocks are added to the pcp instead of each p=
age
>>>>> ending up on the pcp order-0 list; memory remains more readily availa=
ble
>>>>> in high orders.
>>>>>
>>>>> vmalloc will shortly become a user of this new optimized
>>>>> free_contig_range() since it agressively allocates high order
>>>>> non-compound pages, but then calls split_page() to end up with
>>>>> contiguous order-0 pages. These can now be freed much more efficientl=
y.
>>>>>
>>>>> The execution time of the following function was measured in a VM on =
an
>>>>> Apple M2 system:
>>>>>
>>>>> static int page_alloc_high_ordr_test(void)
>>>>> {
>>>>> 	unsigned int order =3D HPAGE_PMD_ORDER;
>>>>> 	struct page *page;
>>>>> 	int i;
>>>>>
>>>>> 	for (i =3D 0; i < 100000; i++) {
>>>>> 		page =3D alloc_pages(GFP_KERNEL, order);
>>>>> 		if (!page)
>>>>> 			return -1;
>>>>> 		split_page(page, order);
>>>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>>>> 	}
>>>>>
>>>>> 	return 0;
>>>>> }
>>>>>
>>>>> Execution time before: 1684366 usec
>>>>> Execution time after:   136216 usec
>>>>>
>>>>> Perf trace before:
>>>>>
>>>>>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_fro=
m_fork
>>>>>             |
>>>>>             ---ret_from_fork
>>>>>                kthread
>>>>>                0xffffbba283e63980
>>>>>                |
>>>>>                |--60.01%--0xffffbba283e636dc
>>>>>                |          |
>>>>>                |          |--58.57%--free_contig_range
>>>>>                |          |          |
>>>>>                |          |          |--57.19%--___free_pages
>>>>>                |          |          |          |
>>>>>                |          |          |          |--46.65%--__free_fro=
zen_pages
>>>>>                |          |          |          |          |
>>>>>                |          |          |          |          |--28.08%-=
-free_pcppages_bulk
>>>>>                |          |          |          |          |
>>>>>                |          |          |          |           --12.05%-=
-free_frozen_page_commit.constprop.0
>>>>>                |          |          |          |
>>>>>                |          |          |          |--5.10%--__get_pfnbl=
ock_flags_mask.isra.0
>>>>>                |          |          |          |
>>>>>                |          |          |          |--1.13%--_raw_spin_u=
nlock
>>>>>                |          |          |          |
>>>>>                |          |          |          |--0.78%--free_frozen=
_page_commit.constprop.0
>>>>>                |          |          |          |
>>>>>                |          |          |           --0.75%--_raw_spin_t=
rylock
>>>>>                |          |          |
>>>>>                |          |           --0.95%--__free_frozen_pages
>>>>>                |          |
>>>>>                |           --1.44%--___free_pages
>>>>>                |
>>>>>                 --0.78%--0xffffbba283e636c0
>>>>>                           split_page
>>>>>
>>>>> Perf trace after:
>>>>>
>>>>>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fo=
rk
>>>>>             |
>>>>>             ---ret_from_fork
>>>>>                kthread
>>>>>                0xffffbbd55ef74980
>>>>>                |
>>>>>                |--8.74%--0xffffbbd55ef746dc
>>>>>                |          free_contig_range
>>>>>                |          |
>>>>>                |           --8.72%--__free_contig_range
>>>>>                |
>>>>>                 --1.56%--0xffffbbd55ef746c0
>>>>>                           |
>>>>>                            --1.54%--split_page
>>>>>
>>>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>> ---
>>>>>  include/linux/gfp.h |   1 +
>>>>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++---=
--
>>>>>  2 files changed, 106 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>>> index b155929af5b1..3ed0bef34d0c 100644
>>>>> --- a/include/linux/gfp.h
>>>>> +++ b/include/linux/gfp.h
>>>>> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(uns=
igned long nr_pages, gfp_t gfp_
>>>>>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_nop=
rof(__VA_ARGS__))
>>>>>
>>>>>  #endif
>>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long n=
r_pages);
>>>>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>>>>
>>>>>  #ifdef CONFIG_CONTIG_ALLOC
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index a045d728ae0f..1015c8edf8a4 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>>>>  /* Free the page without taking locks. Rely on trylock only. */
>>>>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>>>>
>>>>> +/* free_pages_prepare() has already been called for page(s) being fr=
eed. */
>>>>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>>>>> +
>>>>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fi=
elds */
>>>>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>>>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>>>>> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page,=
 unsigned int order,
>>>>>  	unsigned long pfn =3D page_to_pfn(page);
>>>>>  	struct zone *zone =3D page_zone(page);
>>>>>
>>>>> -	if (free_pages_prepare(page, order))
>>>>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>>> +		if (!free_pages_prepare(page, order))
>>>>> +			return;
>>>>> +	}
>>>>> +
>>>>> +	free_one_page(zone, page, pfn, order, fpi_flags);
>>>>>  }
>>>>>
>>>>>  void __meminit __free_pages_core(struct page *page, unsigned int ord=
er,
>>>>> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *p=
age, unsigned int order,
>>>>>  		return;
>>>>>  	}
>>>>>
>>>>> -	if (!free_pages_prepare(page, order))
>>>>> -		return;
>>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>>> +		if (!free_pages_prepare(page, order))
>>>>> +			return;
>>>>> +	}
>>>>>
>>>>>  	/*
>>>>>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>>>>> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigne=
d long nr_pages, gfp_t gfp_mask,
>>>>>  }
>>>>>  #endif /* CONFIG_CONTIG_ALLOC */
>>>>>
>>>>> +static void free_prepared_contig_range(struct page *page,
>>>>> +				       unsigned long nr_pages)
>>>>> +{
>>>>> +	while (nr_pages) {
>>>>> +		unsigned int fit_order, align_order, order;
>>>>> +		unsigned long pfn;
>>>>> +
>>>>> +		/*
>>>>> +		 * Find the largest aligned power-of-2 number of pages that
>>>>> +		 * starts at the current page, does not exceed nr_pages and is
>>>>> +		 * less than or equal to pageblock_order.
>>>>> +		 */
>>>>> +		pfn =3D page_to_pfn(page);
>>>>> +		fit_order =3D ilog2(nr_pages);
>>>>> +		align_order =3D pfn ? __ffs(pfn) : fit_order;
>>>>> +		order =3D min3(fit_order, align_order, pageblock_order);
>>>>> +
>>>>> +		/*
>>>>> +		 * Free the chunk as a single block. Our caller has already
>>>>> +		 * called free_pages_prepare() for each order-0 page.
>>>>> +		 */
>>>>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>>>>> +
>>>>> +		page +=3D 1UL << order;
>>>>> +		nr_pages -=3D 1UL << order;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>>>> + * @pfn: Page frame number of the first page in the range.
>>>>> + * @nr_pages: Number of pages to free.
>>>>> + *
>>>>> + * For each order-0 struct page in the physically contiguous range, =
put a
>>>>> + * reference. Free any page who's reference count falls to zero. The
>>>>> + * implementation is functionally equivalent to, but significantly f=
aster than
>>>>> + * calling __free_page() for each struct page in a loop.
>>>>> + *
>>>>> + * Memory allocated with alloc_pages(order>=3D1) then subsequently s=
plit to
>>>>> + * order-0 with split_page() is an example of appropriate contiguous=
 pages that
>>>>> + * can be freed with this API.
>>>>> + *
>>>>> + * Returns the number of pages which were not freed, because their r=
eference
>>>>> + * count did not fall to zero.
>>>>> + *
>>>>> + * Context: May be called in interrupt context or while holding a no=
rmal
>>>>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>>>>> + */
>>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long n=
r_pages)
>>>>> +{
>>>>> +	struct page *page =3D pfn_to_page(pfn);
>>>>> +	unsigned long not_freed =3D 0;
>>>>> +	struct page *start =3D NULL;
>>>>> +	unsigned long i;
>>>>> +	bool can_free;
>>>>> +
>>>>> +	/*
>>>>> +	 * Chunk the range into contiguous runs of pages for which the refc=
ount
>>>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>>>> +	 * free_pages_prepare() fails we consider the page to have been fre=
ed
>>>>> +	 * deliberately leak it.
>>>>> +	 *
>>>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but n=
ot
>>>>> +	 * vice versa.
>>>>> +	 */
>>>>> +	for (i =3D 0; i < nr_pages; i++, page++) {
>>>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>>>> +
>>>>> +		can_free =3D put_page_testzero(page);
>>>>> +		if (!can_free)
>>>>> +			not_freed++;
>>>>> +		else if (!free_pages_prepare(page, 0))
>>>>> +			can_free =3D false;
>>>>
>>>> I understand you use free_pages_prepare() here to catch early failures=
.
>>>> I wonder if we could let __free_frozen_pages() handle the failure of
>>>> non-compound >0 order pages instead of a new FPI flag.
>>>
>>> I'm not sure I follow. You would still need to provide a flag to
>>> __free_frozen_pages() to tell it "this is a set of order-0 pages". Othe=
rwise it
>>> will treat it as a non-compound high order page, which would be wrong;
>>> free_pages_prepare() would only be called for the head page (with the o=
rder
>>> passed in) and that won't do the right thing.
>>>
>>> I guess you could pass the flag all the way to free_pages_prepare() the=
n it
>>> could be modified to do the right thing for contiguous order-0 pages; t=
hat would
>>> probably ultimately be more efficient then calling free_pages_prepare()=
 for
>>> every order-0 page. Is that what you are suggesting?
>>
>> Yes. I mistakenly mixed up non-compound high order page and a set of ord=
er-0
>> pages. There is alloc_pages_bulk() to get a list of order-0 pages, but
>> free_pages_bulk() does not exist. Maybe that is what we need here?
>
> This is what I initially started with; vmalloc maintains a list of struct=
 pages
> so why not just pass that list to something like free_pages_bulk()? The p=
roblem
> is that the optimization relies on a *contiguous* set of order-0 pages. A=
 list
> of pointers to pages does not imply they must be contiguous. So I don't t=
hink
> it's the right API.
>
> We already have free_contig_range() which takes a range of PFNs. That's t=
he
> exact semantic we can optimize so surely that's the better API style? Hen=
ce I
> added __free_contig_range() and reimplemented free_contig_range() (which =
does
> more than vfree wants()) on top.
>
>> Using __free_frozen_pages() for a set of order-0 pages looks like a
>> shoehorning.
>
> Perhaps; that's an internal function so could rename to __free_frozen_ord=
er(),
> passing in a PFN and an order and teach it to handle all 3 cases internal=
ly:
>
>  - high-order non-compound page (already supports)
>  - high-order compound page (already supports)
>  - power-of-2 sized and aligned number of contiguos order-0 pages (new)
>
>> I admit that adding free_pages_bulk() with maximal code
>> reuse and a good interface will take some effort, so it probably is a lo=
ng
>> term goal. free_pages_bulk() is also slightly different from what you
>> want to do, since, if it uses same interface as alloc_pages_bulk(),
>> it will need to accept a page array instead of page + order.
>
> Yeah; I don't think that's a good API for this case. We would spend more =
effort
> looking for contiguous pages when there are none. (for the vfree case it'=
s
> highly likely that they are contiguous because that's how they were alloc=
ated).
>

All above makes sense to me.

>>
>> I am not suggesting you should do this, but just think out loud.
>>
>>>
>>>>
>>>> Looking at free_pages_prepare(), three cases would cause failures:
>>>> 1. PageHWPoison(page): the code excludes >0 order pages, so it needs
>>>>    to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].
>>>>
>>>> 2. uncleared PageNetpp(page): probably need to check every individual
>>>>    page of this >0 order page and call bad_page() for any violator.
>>>>
>>>> 3. bad free page: probably need to do it for individual page as well.
>>>
>>> It's not just handling the failures, it's accounting; e.g.
>>> __memcg_kmem_uncharge_page().
>>
>> Got it. Another idea comes to mind.
>>
>> Is it doable to
>> 1) use put_page_testzero() to bring all pages=E2=80=99 refs to 0,
>> 2) unsplit/merge these contiguous order-0 pages back to non-compound
>>    high order pages,
>> 3) free unsplit/merged pages with __free_frozen_pages()?
>
> Yes, I thought about this approach. I think it would work, but I assumed =
it
> would be extra effort to merge the pages only to then free them. It might=
 be in
> the noise though. Do you think this approach is better than what I sugges=
t
> above? If so, I'll have a go.

Yes, the symmetry also makes it easier to follow. Thanks.

>
>>
>> Since your example is 1) allocate a non compound high order page,
>> 2) split_page(). The above approach is doing the reverse steps.
>> Does your example represent the actual use cases?
>
> Yes; vmalloc() will allocate the highest orders it can then call split_pa=
ge()
> because there are vmalloc memory users that expect to be able to manipula=
t the
> memory as order-0 pages.

Got it. Thank you for the explanation.

Best Regards,
Yan, Zi


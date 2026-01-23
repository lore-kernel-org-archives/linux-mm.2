Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B67D72372
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AA66B04A7; Fri, 23 Jan 2026 05:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527646B04A8; Fri, 23 Jan 2026 05:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFC66B04A9; Fri, 23 Jan 2026 05:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9D66B04A7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:42:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2F7D52D60
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:42:20 +0000 (UTC)
X-FDA: 84362889240.21.B501F9C
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC2FF14000E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:42:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sYPf+Zug;
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769164938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02hlO+gU/RfRxZyVq2bL7ywdHosxEm6naRALWXR3cDc=;
	b=pQbkrJu/CJofQ/0CpGcWVgThAJc99Rxc/2f+T6lUXtdTNLU4Dl1c6NME7qehwNcnSXxrR7
	Iw4cHFC3n0epWZGcU5JVZqdDRLrRBOAs/KsPnLnRCIG5Sm8WZNpfapfGuLbxdKVAFY8b8s
	+VDI7IlS5g2AooGiXxw058lCf4hxbiw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sYPf+Zug;
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.56 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769164938; a=rsa-sha256;
	cv=pass;
	b=eQNgFf0J9ZJlzLD0r0LWpovGq1moz2clvHp0dzQS49Nj5wcoNBSwv7L0QJ/UbgDOWOSqoe
	ALiG0PGvbpSxqJ5A4SQsESOpNQGOwMiqShnqJ58AqQRik+Y9nzwZlODop9JBGkXwyTxVbK
	BYbd9HECYkY539kKQyS3FhPoXKVQqGk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KF2qp6oI0/ahc2MEKQVOQxFdmUw4UC69MZWFfVlF4rLAYmxOgDNltIEjGhDljZZIjuWAdOeE67KyoWz3uR8F2eyaV3ou6Cb8ZwO4Q5MnCrri/ygaeQR6iXB6baQ9KUWlnK/FzV9dS59U6od2bh0tBsVH/sdTkJkb1CC4iTyMGid0ugw+KRu9a6joECb9ECr8wLre9K9YUqqP6BuXP6wfSMAFbQGjd8Cf94ESQiEnn/Hm+evNIweXWh9r3X5Pijj9rwV0riQ8Jg6IvwkWs058eDemt2C/sAiCRwj0zrUynA8Hhl1hRk0SXisWLm+k7R+3c3uUPIFvyufMQsBuDPOOKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02hlO+gU/RfRxZyVq2bL7ywdHosxEm6naRALWXR3cDc=;
 b=ucLISERc6EBHlz/NNB/dI/R796Knhsoi5yUb/Nou1QONfek3OAK/BJB+1LN6PnImXUAQDtVA+FiX5PqkjumGvhHuOzyjjmfDesErCksDQ0t/ohc0g/azLNWDEoXVvZOyvnfKodGSou2GS7nSkAGkJa1aWUoKqqJYi0Tnb1kMqPdWChY/W+K4Nk5+UDecsay2Hn3nKAoDWnhJvjiK95Fg/FkKbiDtq5bRyPLHzhHvT/b6OZYp0Y/2rC5fNXoJs3FffuFXopJh5NGIUZpqv8yMUmFjfqwQpl83DEk+rzRTXrq+Or9isvS+zn7o2FMnVQ5eI/R0QADXV/Pw/S600AsLdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02hlO+gU/RfRxZyVq2bL7ywdHosxEm6naRALWXR3cDc=;
 b=sYPf+ZugIott20GFnRFvg1xu1F3Z4qaITOtysvE0kP0ox4JwSL8uF8QkORWz8E6tW0Wb00Il5vMEIooOFgikM7vOO0VEHXbf5TJ/+uk5VWHrNrT+j5Pc6vqXmDLQi6icWROmCtPqI2qqQnfOruDYYlhfz6DCHjL3G4KF30xBT4I=
Received: from MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18)
 by MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 10:42:14 +0000
Received: from MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::d8ab:cadd:74a8:5132]) by MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::d8ab:cadd:74a8:5132%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 10:42:14 +0000
Message-ID: <836669ac-473f-4c30-a368-c05bfa86c306@amd.com>
Date: Fri, 23 Jan 2026 16:12:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
From: "Garg, Shivank" <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-8-shivankg@amd.com>
 <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
 <d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
 <7193b89e-ac2d-47c9-8fa5-68e35c57d4b6@amd.com>
Content-Language: en-US
In-Reply-To: <7193b89e-ac2d-47c9-8fa5-68e35c57d4b6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR01CA0148.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::18) To MW4PR12MB7465.namprd12.prod.outlook.com
 (2603:10b6:303:212::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB7465:EE_|MN2PR12MB4093:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f545f7-ed97-4aed-e2f3-08de5a6c1270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmpoOU5MTHRsU0lNN0V6TmdLeHB0VWZSZ3hVUDNEYVBrU1ZZWmswQk1aL1c4?=
 =?utf-8?B?bXAvbFQycGxBaThmKzBxc3hjbEtmZFdEdWVpMmovRXhwbmQrWDIvR0pId01a?=
 =?utf-8?B?M21SVnRmUFJWV05DT1Q4S2hJOFFLd1BjL0thOWg1ZXQrQmdjQmJ6SGNaaVZr?=
 =?utf-8?B?N3NuS1ZjOW8vNHVQL0RPQzJIdng5cjhxUlRmTERaV3pKM3J3Y29wYXY3LzVX?=
 =?utf-8?B?QXNEQWFuRjFuN3BrME9vRjRIY3hjTlUzWjRTSFFka2dkeUFuZUFGNlB0N2U5?=
 =?utf-8?B?SHQ2ZndNR1QzK0hVT0NqaFRVWWNPZmxWNlZBck5CbTBlTjVjVlhCYmVkRmN5?=
 =?utf-8?B?b2Zpc0xua1dhOWdvVWtueERRYWJRRFV3eFp3NFlrdm1JOWJVS3FKazhPb1JO?=
 =?utf-8?B?QnVKU3E5UGFVTW1NM2lOSHBCQkhIM2pobHkyVk1ydCtlK1pUQUVmakNWdEZM?=
 =?utf-8?B?eUorR01PZytLSkl3Y0lqWUNCRkpCeVpEbkdyZHVpNUVLa3lUN2pIdWZ2ZXRZ?=
 =?utf-8?B?SVQ0ckJXNW9lZ2dvVWhZNk5ybWYyODdoMjNwR1BINVBReUhyY014ODNPWEYx?=
 =?utf-8?B?OG1wQldGSFFzcTRVUWpIMXdZcG95VjZvY1lydFVpa3BNTmYrdVRYMFUzOWM4?=
 =?utf-8?B?cFN3SSs1U3NpdndrWEtMRVpsQzQ1c3JZVUJXeFkyNk5tS1BLTENwQlUxVFVL?=
 =?utf-8?B?UEM0cHozWkxQOXBRUVk3OVhxTGFwSGhRTVlKNnNCY0FrNFNzVkRKZGh5TmpO?=
 =?utf-8?B?QXZiUmx5c2kxa3pjOHpCaEVRYTlORkx6TlVwblYvU0g0c2prdU5zTXd1OXda?=
 =?utf-8?B?ZlNGRm5jRzUzZStROVpHeU1LTGsrdEV5OWM3SkVabWs2aWpGTVI3WVE0Mk9E?=
 =?utf-8?B?STY1Ukszckd6ZW1hTUJWc3djL3FzanZCQ0NOS2l0S3hRWFJNVDlWV29yK2xa?=
 =?utf-8?B?Wk9OdVNLalRUdEZtUnBxWU1pR3pXd1MwQ09xbUNJZ1RsdlJLcmtVc29tUy9k?=
 =?utf-8?B?S2ZTbVQ4M1N3OXBURzNwejFzcnF1R1JpN3RYblBDNjVVbHBkRkxsYU4wVVVq?=
 =?utf-8?B?bUZiODhCTlBMb0RITWJXS1dsbnhuM01TM29OVGRFVkNoa0QxUnVpbkRjSEwr?=
 =?utf-8?B?UWdOeDVqNVB1eVFXZDJLQzYxY1ZQRlBqQ09YWWplVnRXbnl1TU5hTUNsZStL?=
 =?utf-8?B?ODhIVkFvZHhncHJ5ZGx4T3pLanQrU3hnS1liaTh2REJzUjZUMVo5WFVPVFBk?=
 =?utf-8?B?Yy9QWTQxczM3djJBeEFLRng2S1U0MWFxbnNXUkNDWXMweW00bmk5WXhPbSsr?=
 =?utf-8?B?TlNNdFU1dUdUT1B3NEQwL21SL0gwLzJ2eUlpWDNjY2ZiNUVacjQ4T05DODB2?=
 =?utf-8?B?aHFFL2tjTkVBS0lMam03TTRaVVJWYmNQaTlIMStodUdXWGVFWUNtRU5EZzZH?=
 =?utf-8?B?cUNVUDNoOGVlajk3cHQ5c1Z3d2tHRWdBOUpyMWQ5TVF2bnBPM0JGTDhBUTNv?=
 =?utf-8?B?YzRjdnhiU2dTSFkweUc3V3I1bmU0MWhrLzNpckFrMjZxa3Nna0YvcndmQjhU?=
 =?utf-8?B?MkE1VGRvYllncStzUmxpT2xLQnUvRk1uYWhlaU9zSlpUQUlSbXphbk1TRmRH?=
 =?utf-8?B?OVo2RVd4ak0wTGFHaEZmdTRWWFVTMW1kZkFNSUlrN3BnVE1DSjB3Umpld3Zn?=
 =?utf-8?B?WGJRbFBFend3UUlFOW8vQUQrTVFhRVBudnNocnhTQlpIc2hidGw0VU9LdFRx?=
 =?utf-8?B?NlkzZlVqdWlhVXBBSDI0aWZXNnRLZVpENlkvZHVjWW9UcFpBUTRvQnJlbFYv?=
 =?utf-8?B?TTRIZmp3aTZXSFJXdm8wa1VBSGlYT2pGQUozMGsrWWY3VVEzdi9iZEtTM2Jp?=
 =?utf-8?B?NWR2TThvS0ozbng2OUN6eFBPbWtFcHRySTd6VnZiMCtHTDFlQllMV2NMOHov?=
 =?utf-8?B?WlVTa3BwSjVXTno2K1ByRWo0QlM2RE1xNjJKSjlzM293dGdRNlY1aXNoalcz?=
 =?utf-8?B?WEk2THJTemFFVFlSTUtnQmZ5ZjROb3J1VUYwbWJjTVltNC9Obm8yY2Z4enV2?=
 =?utf-8?B?eFF3UEo0WFJKWmlKRjM2Mk1xRmhQY2UzRzNqbHR6b1VLZ1YzdkZXZncvNUt3?=
 =?utf-8?Q?QVdE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFRRaWo1L2NuSVJCZy81bWpiWkJSUXpaQ2FoK0xTZEVNTkpiMXhBMktCaVox?=
 =?utf-8?B?NXpQSzJTK0hwcEp1WGt4aHZFSGc2elI2OG1RZ25Zc1ZnbDE4SFRoMVhKVTBx?=
 =?utf-8?B?VnVkdExqUVhVY1hVMzlFYVBKWjBhdW5tK0RncWhQWDB6SVZvay9lcGtLYnZj?=
 =?utf-8?B?THBaTk9ia2w0K2xZc3F5OHNsUEJGWTAwWVJvajdEdlNnbS9ORDdHU2RZcXFa?=
 =?utf-8?B?ZnZSZlJhaWo3NkdxbjJUeW1iU2JwRWNLeGx2RmVvdUF3c1k0Zm9Dd3lJbzY3?=
 =?utf-8?B?YmJGeEpsMVRlRnBzR2RsZ0R4THVZMnBoand0T1d0SHh6K0x1MkxUQThOWnlv?=
 =?utf-8?B?OS9FMkFPK3kzQWJ1K1ZnRVdYOEdEV3BQeDhHOVBkaVV3Vnp3WGdxOFpTMTZT?=
 =?utf-8?B?UlEyUnZyMTYvL2FNVy8wOVZ4OFpkTnZoUDdPeEpQVFpKL2FMSzk3RTExU2R3?=
 =?utf-8?B?di9KYnBraVlFS1poMnNlRFRZaWRPM2hwKzQ1WC9qZCtlZngzSy9ISjFhT2Nj?=
 =?utf-8?B?aWhuWU13YzdWc1FOb25ZQThBTE42Ni81SWl0ZWtSaVhqbFdWNTNBUFduam5i?=
 =?utf-8?B?VVRVaGNFaDdxOThZTkxnRGZxdXpFVDBic1c0dnpIL1dScGFrOEtTdWZSeUZR?=
 =?utf-8?B?MjJmam1WaDZCajdEZkFKOVBZZ2FlNHYxejRGN25uMEVSdzEvL28vcXNkQ2FM?=
 =?utf-8?B?dWVxdzFiZ0Fsdk96VEFjKyt1UzFrK1VyVEo0VG1uSURwNVg1b0dkc1ZLT2ds?=
 =?utf-8?B?NUI4ZkZFM0VkWGp3QXhPdE5FSzFUMzNWa1h2SW9ZWFRhV3RoeGhENXBuaWwr?=
 =?utf-8?B?NEx1akJDMXBReEV4QXlZME94aTY0ME56M2EvL0FpSTdHWlNzcDBBTmVHZ0hS?=
 =?utf-8?B?K0JHajVDa3JqVGVnWXBFbm1hbU5rWW1BWnBJOGdneE1kVDJFTi9mK3B4b3Ew?=
 =?utf-8?B?NWg5M2tqTVliK3g0UXRyUTlhZnczNHdZU2tMNnl6SFVPMEZZei9Oak4raWdX?=
 =?utf-8?B?SUIzUTB2RXVWb1daZnRkNWV5dXlvaG5KZEduK2hOTnBoNGVCVy9oaW1SSTRn?=
 =?utf-8?B?UGx5YXZnb0xuYXNwaG83VVN5ZTNkMHBCUk03RkZjZE10bk1XV0VTVGJ6UHBX?=
 =?utf-8?B?VzVldG1WQk9NaVRJdENjRXoyN0N4UlhkbFdycEFFSkwxNDV5OVpkS2p1d1pq?=
 =?utf-8?B?a2dRSDdjd0Y5Wnora0VlRHdMMEMrNEZQdDd3eEx2WkhVOXVQZ1d2WDJ3OVJk?=
 =?utf-8?B?c0hBYmlxOEI3SWNWN3NMeGkySzNBalROUzVLTHFScno0WTZ2bmdkaE9GTXdx?=
 =?utf-8?B?eTUxTnlGckpkLzdrOGJiZjM4N1JTeVNJU3A3aCtkMURNTElxNHplTGxnc3pu?=
 =?utf-8?B?WkxrajB5MmxHRzZDejEvanZhcWN2MHkvNnFqYjl6SWswWXg2eCtuaEtTL1o2?=
 =?utf-8?B?SE5sVjhxenR3eldONnVvQzA5aHk3Smp4S3NZT3hTemFLeWNHRzgzMnUzTno4?=
 =?utf-8?B?aVgyZlVNL0RlQUNwbk5OVEtVWlVhVHh6RCtxWVVZL0lXQURFdysxQVJvcWxP?=
 =?utf-8?B?ODY2ZmkvR3RXTitRR1JFcE1ZSXFDVHpkSm0yRzhweXNOZGRHWHY0RWNhUGl0?=
 =?utf-8?B?QU11Z0VBNHpsc2MxRzd1VllpRnlFNmxXOE1ua0c1bXU4T0pER2JOVndzQy9L?=
 =?utf-8?B?ME9KcmFtb1VsS05OL2M5OGRRcDJ1MlpVeTV1TVc2Vk1iMmlJYVNBWmpCRXdw?=
 =?utf-8?B?YkFuSElyVkNhWktCQTh3MkFtblRDY1AvSmI5dUdiak1mRVU1eER4RHZjcXQx?=
 =?utf-8?B?TFpiNy9FT1Y2QVY2SFJia3FqU0UrSWJyUzB3TSswTXpXTVdLakF5R29FRlp0?=
 =?utf-8?B?c3NqeTlPUEV1WHFSVjhPM1ZrbHRGMVJzeW5lTjJROGNQdklIRkdObXBTNzRB?=
 =?utf-8?B?eXJLNFNQMGVvT2Vvelh5SFpsZXB3QzZBOHNLM1VjUVlrNUdZNms1Tlp6aDkx?=
 =?utf-8?B?L3Vid2JFOWJyWXRzY2xuZEpONm5FTEhZL3JtQ0hKUVlBUHhjendBY0x2TUNB?=
 =?utf-8?B?TDNhMGwrYm9GRHg2Nmc1SEw4N2o5UHoveW9qK1psWHdmWmJWUGdGYXBTQkJ2?=
 =?utf-8?B?aWVLK0lycmFJSEYyeUFtdERQVnorekdGZ214TnFSbnVENE4yb2xvSHhKUFdW?=
 =?utf-8?B?Qll4Y2tBcVlMMDFsSHZ4UEhCQnc4QXRRNDEwWExwWTN1THpQV2hadWpYWG9n?=
 =?utf-8?B?MDVrcXo0Tk5EMEFPRmJmMml1MnN5aGhGVEpRc0lKbkZwSmxYMmtWSFVZS2w0?=
 =?utf-8?B?NjRWOTFlVkJjdk9OTHhNeXM3NFdqMFNoNnNHZFhYcXBreklDT2NIQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f545f7-ed97-4aed-e2f3-08de5a6c1270
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 10:42:14.6897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqZw/OWN7I1/Fj+qhfkiNcOULFjGwAcmncShAQ3jdTy3UoBWeADS0zHyQaWVizr4IMgr+o+iqNVYE8gQ4PIpng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093
X-Stat-Signature: bqrtbb8nx3uerjt9c86kw18ocpr8r563
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC2FF14000E
X-HE-Tag: 1769164937-417224
X-HE-Meta: U2FsdGVkX1+xM9oRARC7F4Vcp4Gvdm3lhXM/uiDtnp1PzYP1V58sFg92IFvP8wZDtBwdSg6EMlg7gK4zJWVyfepP2STLTpeP5aHOVl+rDlqzMMdRAzmyrQde22VKt7iMvnCTyFRBMm5TN1+y1T+3fcrexjuiuuBudWjuZ04i7PSqh0baKK0gckd5wSPz8pftKWN32niDs+qBNqmmdXTy6sC8cqc39v2uOt4fa7XzqM6lNIxKrIF+YeY2ymZ0KPKiYzWfSGx5S2AtgCuoqBvhuXvpkDK7nZPEWgHz5/esA5pGIwy1Vdv/gdRsGY92VQ2+Kuuj9YTa2wAKvVVDQtR/SFMT6p+UjxyTVDsZyaRSG6YXIw7hiKvo2UO+SxCZusyNg6vCMVGrJWOlPwheSei6tnxUguClAXOOSFFbAF7TMQSZ1xaVIRw9v/KMu/kLCROWl9Q2yX90wFAaFwhNa3LAV7gjnge0xSfEVeAQF+ZjS6n/jKaqFi/+GtkGDTl4yTXXSC1OG54HOcAWpiUvB9TdZnmEBeVlT6MTqbB+eezbY0833pzD19Sa3rAs3+EYIBxnM7jfeAk3GWthRt2MmKCQaai773mI8Ko55uOSExDpuij54Q6Gdct0hm06TDbXCW6UrjFJ9xVHPHibGqX34xNdXQ57h8P68wKH63S5j7v5GSBfAnNXBPetuD2UCXMw/3qUQlunrwAOUoVb2F/GgyQ1+TQ3LXY0DTYhFa6CTk+ZM6kJUsLIDwRm+xf0ij0XhHRIod/UU0p2USGBKNOTrCPcpfhsFK06dPr7zLYL3/5DLWkFiEpwjwTAiw7fdo9tQoxMcYGb3HNcVWqvx90/Noda8BxD1sy3noJ7FHluWCVMt1yx/1zEqm9f1cf90x8mnWz/fh3LoB03nYXN5n3SLEeCEmBHQ7zqL8DxsvSsoKZmH+zGBwzK5VuPrkp2UdhwUVBb9Ouzufa08fn5EMqdt5s
 JjKCs5p7
 TytH3gF6mOB70oUMqLmxkik2XhtG0nMRfOe7+KZbe7mMG0fuhy4RUgJT43YK5XmQXpl56mohZl2GaQZcfS8bt+fOOiwJvbNIFWu0TqkmUl09K7xP9g+lNFd5oFkRCoiuynSex7kLHmeCeRnkVikm2lhJGzK3BE1puXqu5x/vL8p9etQ8f9+9qb+GmdSR7KuA4dVQTkgXblsx2x+RCI1VOIjHlM1eQDd0BkC28WfR+JKx+M29x1h2NqqhyhljZPPC/Qndx1J9+gyDkHaIWq5IpWsm7Zsx17mRqpf1hlrgGXroyTqyILuqxRJHcNAJpMyIIh2Bl/tPrWAnSce8cPd4aVMtWDBNYufHxlsaCd6xrf+Gf1osvYyyEZyqLUF9d6ij7GpfTy+1k+Gk2pKU8O+FiYcOAatS9A+g7r6ZSNNfLfF51pjV8YWpHHijDE8T/tUd4IXIYtpTJok9OSmqveml7I306Za4PFBL2/nY4E943jc8dZkIE/36n6xHzxlf4t8RikcTo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/22/2026 5:56 PM, Garg, Shivank wrote:
> 
> 
> On 1/22/2026 2:14 PM, Lance Yang wrote:
>>
>>
>> On 2026/1/22 15:32, Dev Jain wrote:
>>>
>>> On 19/01/26 12:52 am, Shivank Garg wrote:
>>>> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
>>>> amount of work performed and consists of three components:
>>>> 1. Transitioning to a new mm (+1).
>>>> 2. Skipping an unsuitable VMA (+1).
>>>> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>>>>
>>>> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>>>>
>>>>       vma1       vma2   vma3
>>>>      +----------+------+----------+
>>>>      |2M        |1M    |2M        |
>>>>      +----------+------+----------+
>>>>                 ^      ^
>>>>                 start  end
>>>>                 ^
>>>>            hstart,hend
>>>
>>> Won't such a VMA be skipped by thp_vma_allowable_order()? That internally
>>> checks, apart from eligibility by sysfs, that the extent of the VMA can
>>> map a hugepage.
>>
>> Ah, you're right!
>>
>> I was worrying about a case that doesn't actually happen.
>>
> You're right, thp_vma_allowable_order() is taking care of this, making 
> hend <= hstart check redundant.
> 
> Thank you for catching this.
> 
> I'll drop this change and send revision keeping only the unsigned int type 
> change for 'progress'.
> 

Hi Andrew,

Please drop this patch.

As Dev and Lance noted that the hend <= hstart handling check is redundant.

The 'progress' variable to unsigned int is not critical either.

Other patches from series remain unchanged.
Sorry for the noise, and thanks.

Regards,
Shivank



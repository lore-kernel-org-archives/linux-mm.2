Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D415AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF886B009F; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A30C6B0099; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B036B0099; Thu,  9 Jul 2026 14:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0948C6B009E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:07:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E25D168E6D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:04 +0000 (UTC)
X-FDA: 84970019568.22.D31B412
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	by imf07.hostedemail.com (Postfix) with ESMTP id A002E4000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:07:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FzSa12DR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5rSVRFtO6VKWjKa/BeeBvOXBnl5ZB5KTp9xgY9Yp4c=;
	b=R2279ZyBu+PIPK7U+Ca0+gcSYT46dnEN0wAcOEKFoRNPkINQyjFGrL6NKhaMMjm/RVu4LT
	dPdkLFZFFv81gy8uPnW9BHBGmZ6Dsic9vKGJWrDV5GZsHO4Exg7yVUrnbLM5wZXqvmn7ez
	HdvDqM+oll7aiW4PKFc30V+2pJFFcbQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FzSa12DR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620421;
	b=3QRP7nAlmLiC9kGemk7BhlsVPrdQJkYJ121XhKwNvMu3SrI3r+E55cUGQ0YaMyMAyYPDWg
	Ger9yaVKAHf0UQZCc7n2tqVzDEYIQgWl962iImO8IBzVy4dljkArnCS58bZjiArY1L1WTc
	TVOv9Ve/OyOkFiwzOPMewBtM3XmtPko=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QYRpiCc/amLGyS/opK1UnhrLn3Q7K74clNcjL1qhvqM3aVMIPiRh2S4QqWJwojKLiKRHef0JgB/BEIm/17FM9UiIPubpe/dWQVyH6qerLxUXrWGGaQaKAw52yOoePvMCPX5QQbMDWRdJIaEvS9teAcuiz1O6POIPxAo+kNUdyU0QytRIOic9lDTFeUtSZxNjwZuZVyYZx3cv9pcPgLnVj3Ruin1wjRzH7duXmdY7oHLOiVTp7GJcaVA9ja5tPKbbafFQyktUkQPt1qE9MQOFsuNHW/Bf1FaG817ju9dYf7gS2KMNLfI/lr8SewIN81pRLIGmVZAl6DaOciRwY3O4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5rSVRFtO6VKWjKa/BeeBvOXBnl5ZB5KTp9xgY9Yp4c=;
 b=rS7t4KDqieHGtKcykW2Qda65dmZUI61kL9yntBTvr8we5m0LXi/0GGTuxz6kXqYB7MA7K/N7yyTKmhnqZV7f65ptaYXWgS66IARkafFaELjEj3dqCRVAo+DqIFo0eNVO8AFt8rBhqFdaHACaNwezmirxtFwsF/RP29ri8xUMTtePR3oEKo36nK9xHWkxqIG0/pZRCPcwUX8rSSru7gWD/5fDvKEOaRAyX9U2pcwtIMwlK7PabIpHgzJlNi6k0ThzpWjNuhD2nadXEZMP+jWDBBdSJPGA3ou3BmuFVTfOjks30ivEM+8aUqY1L8KNPB8/Z9RrC9d9O6T4wNBhuGyXQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5rSVRFtO6VKWjKa/BeeBvOXBnl5ZB5KTp9xgY9Yp4c=;
 b=FzSa12DRsPxCMtqBst+diMQWBCNZCclKvSF0HagzJ3+RSgnxKY3obmmIA78AA8Ul2O/SbkqF2mJgWcuM0ACKDC2WEZEgUYhHPVhn8EIPuxlfvm0xrhMUCicqwrLu7D2Pz+YTB2JYWb7KfBUu1GxrU4KV8r8C9H/0m7NCC7YGoH/bzrRfD0tLdteaEVS7Gkl8dpfbmQov2d8DMTT0n9olYZWELM728WTB3Soh82dzqIS1Grj1+UjaFDPhGk0u+/t6h5zgh4E7pDxKwM6SbK3pj8Gdo/yBGbTOHsci4iyQTSe9mAGkLPahQLKmtpV/Nlmaom7DLZRDHO2Bvr1NEoPbBA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 18:06:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 14:06:03 -0400
Subject: [PATCH v3 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-3-7e4fe155f5b9@nvidia.com>
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS1P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:451::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d712607-ed51-4668-32bc-08dedde4d94b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|56012099006|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	UyYkc1lvU/nnObLx0PbQurV2ua1lGpU5T/uWXyUTljkImVWI3nnMcOsOPkcp2g+3en3e33fxXSHX2Zvo8NhDEzEDP8Rx9KD2oW5GQeS2F7al+rwSX6m55svNyqhiBc7W42vj2BDxBsnvZovnMRIsxsyf7jcDVbH+2NmoA7U5MS9tzzA1DjesT2bdR/KrvQdXkopjkWhEndJWLTGytzd/xX+/26FZi/fPkz7NzWGHIOkSh1FI2QqUZ/TF55015DmM/cssZaN/BQzU7gLZxHkeISr77XE/ChVAEOiR9vwTGlpNngbuJVtfIcEdkbMCdgAyCcrv3wyAqZ7bHLK9qwioZjB7+9uSzKd98k3v8lLJBV6d6zclabYkJesjD646XSblHy8DPBYT4aRD1R2VXbxkx7rznZUT7A2Ki29v9e1BQPFOSQBqihjAokeIy0UcWka1kYMnNb8J3GLEiUx3ORhkTnNL42tKWX16bgZn7ct8+0DnoqPeTLC6iI9/OI14cVFudi82u1ULppotogR94LieEXdmIuTcoDjnHp9YeReppszobUPfDXTGWNtn8UW8ZL7TfaqfWW48U3WkNZpZ9m4gt8GZpiqOh3+2A2AgeQOQNWwf4J7G3vuftHMl1IHpIApucynPqSSzp7UMvLVTrrEe5Uhiz2xX7ivsSHoBbjX0qZ22FO+w92SpBL+8L9ofzHmIhTIyi/jy3n55piXLPNoToQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(56012099006)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGJ4M1FwZWxlNkRGR0FlNEg0ZGN2cjVkMTR5cUd6NjAxcVIrSmEyQlIvT2RB?=
 =?utf-8?B?SUVTVnozM1ZKbnhtcTlZa0l0RGdsL2c0ZzV0YWVZMXFReFhZOWtCRnF2emJX?=
 =?utf-8?B?U0xPOVJPa2lvNFZCY3BLdlFvZVNzcTlmWHhLZlIzRURiWDIrV2lkOXF0NnJ4?=
 =?utf-8?B?YXZNVFp3dmU2U3ZSM2RQYmYxVGNxVDgzUVRGVXltb3dKMGtMdThRbzI3L29G?=
 =?utf-8?B?eDR0SFlkQ2VlK3B3NzVIWE1GclU4N1E3UDUzdEtTWHl0d2hGZnpkU2NFRkRw?=
 =?utf-8?B?ZTltUmZ1NndmSWc0bWFwbjNkaityaTcyV2xHZXZsWDl6cDJBY2lSb2l6UnVr?=
 =?utf-8?B?aWZ2ZXZwWitSRWlpVjNVSHVoREl6VG5rSHZCUVIza0tUNGNaOWEyTWlhQ1lw?=
 =?utf-8?B?bGllUEZZTGs4NWxncWJZQ1VDSXgvaVF5bjgrV0c0ZlNUM0xCc0pRR1R5cCsx?=
 =?utf-8?B?eWlCc1l5cWVoUE9ta3ArbXhHS0x3Yzg2MzJieHE0Z05VRW5IcVRUbmQ2U2xJ?=
 =?utf-8?B?bXQ2VTBudEVIYWJTWUZtNjNLUmhvQktwZFFySDl2dDdoeU1XdkJWK1pmSE9L?=
 =?utf-8?B?WTdaeTExUkxGZ1phOVUxR2JLTTJnRHhodmJ1Qk1WZkhPUXVWUnhVQUltY2dk?=
 =?utf-8?B?b2pGTmZOVnJGTVgvYzlQOGZRWGdGY0hJWmZHZGhaNE4zanM3Q1NuTDNCWVhj?=
 =?utf-8?B?NjZ2VlhEaDNOaTJtME9BZWs1SHFNd0U4VmIrTzMyRk9rQ01CeW91UzZKbHB2?=
 =?utf-8?B?amVXZXIwOGVXWjFqSTJValAvKzhJKzR2NFgxcTZtUU0xOVhuUDZtOGlrL2FJ?=
 =?utf-8?B?dFl5a0tHT1NTdVNqdHU1Ni9UbFZDbStVVktwN3RWTktCWk1CbFB5SHZ4c2VO?=
 =?utf-8?B?M3lYSzJSVWJseU56WEhEREpEeGlVbEhJd1BMc1dtUkVPa00yRHN3cDQ1R3BB?=
 =?utf-8?B?WDNzb3JPbCtRWlplOFZKNXFhbjlvaDRjTnFlcC82dXdnL3pyWkZQelJzbkpm?=
 =?utf-8?B?blJJUFBOR3VTVkw3OTJLdXB3SnViL2s5NzBRa1VZeXRNZVdwUUlYZW5URlBL?=
 =?utf-8?B?b3R4bUN2amJsOHE5VjIvdVBvaUcwcktLcENMNHI5NmdRekNFSkowQWY3TzdQ?=
 =?utf-8?B?M1U3UWdOQUJPd3ZMZ0VHNXltek9md1VhcGN0VjFpOGxOdk5iUFE0WnVEazFq?=
 =?utf-8?B?VUpYQmV0RTNWNnNPdTAyNDdxSS9ocHgyTkNTR3JSRitUT3hGR3VpS0E5WHdy?=
 =?utf-8?B?bXpUMWJqaE1JcFc0UkRWWmREek9SMzI4QjFVbW1aUkdQbGtVTk1oRkdwMmxm?=
 =?utf-8?B?dXlTTGhVdW1ycGJLU1l5b3pHeDE2Q0N0emtLNGk3YzE2ZXBQWkVScENwdDZS?=
 =?utf-8?B?cmk1Ukh0ZG9MeW1OUjFqRjA5TGZvWmdScmFFVkFzZFYvYVNIcXZlcXdSeHVq?=
 =?utf-8?B?UWNTTUNuQ1J6SUNDN0RFNTRwcFhteDZtaXQ4cjZFei9MVGlaVkl1ZkwrYit6?=
 =?utf-8?B?NGl3bHM4RmphbHU1SmptQjNEZ1ZPbm45QlNiSm00Zi9OWjgzMFlwc2lFN2J3?=
 =?utf-8?B?Y2hEMkJnY21ZWVlGeDNad0wrM29JSzZrQngxdmZGUDY0R0tKUk1oQ2xodHFB?=
 =?utf-8?B?MjRaeVZqcVJCTzRoTHRMU1l3bXFGQ3N2eGdCS2pGaFVDZGVRSmpkNkYxT1o1?=
 =?utf-8?B?QnVMdHkyT2svTEpycnZjT2xCWEVTUDNBcm5sWlBscXRub1E2enNMZ1ZKbU12?=
 =?utf-8?B?RkMvaUg1Q0pDanJQZXVxLzNSMThldnV6ZjZiWE0xdW1IejhqRVV2UlNiRXd4?=
 =?utf-8?B?b3Urd29DZ1VNcE9HM0pRRDlMT2V6SFJwY2dMbHJSVkpQa1RPbFE4UmF1eXU0?=
 =?utf-8?B?YjlsaGNOb1dYd0czT1R1WnIvRldBcDdISE9pRXFKZ0ZpWlg3RlV3bWhuemw5?=
 =?utf-8?B?bEoyMFplaTNpTGVTblBmcitBVk9HSE9LaXV5ZzViSE5tQVY5b1pSWGVHUzBT?=
 =?utf-8?B?Uk5pQ0xaUDQyTk9hazc4TXA5OGJLdmNZOHJIYitTVWFHMFBBa0VQQ2o3ZWNp?=
 =?utf-8?B?RE5GbnhmRzNvWS9VKzk4S1RSU2J4NU52WWVMVTlQTWVSNWhCT0xvTXM5RG1F?=
 =?utf-8?B?T1h3VitucFdyMHJuWWhxSHFhUnFTME4reXNZR1cwYWFzZ1dad2ltakQ4YkI1?=
 =?utf-8?B?SU13YmVPQ0pnbkRJWVBPc24zd1VXTGtjZFFUR0x6MWJoQUpuM3Y1WUxuL3kr?=
 =?utf-8?B?RVNWeDJNNmVNcGc2TjN2Sy9ySGdwcXhhUTBUZUJReWpZSC83TFBWK2pTNWFl?=
 =?utf-8?Q?8vdMGOWe7mkq4yYR1T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d712607-ed51-4668-32bc-08dedde4d94b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:50.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVp8WTErJE/jT1iRJ19DRsv4GD5HKBl+P4zHARY0O4fQvOkhyI3euF3TEUHanfU3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A002E4000A
X-Stat-Signature: uyuj76fbwpgkojk6jz7okdb4o96fukjx
X-HE-Tag: 1783620421-162687
X-HE-Meta: U2FsdGVkX1+I2SzjsIo+ZWbX7B0UwW/jrQQAg0HWcE5bOQEssQlSFkhivmLh4t7mQd6Ws0JDH4897C8Mx+OxMiAyWTfWWiCUMJMeDCFcqVNIQZOSPv+lj1sL6dKnYMtvNBM7/LdjUOnnytK9+CCUhZv6d4SQqHLxpIhdx2a9DRbDBcULplGhHWYsqczRCSdNs1tn+m+WyQmadWnzCr4STBLc6vyse0rIhIjQcv6mI+5lChyJ4acjM13xEwauSlBgbXZBVjpbheefs63FoVeiJOw69bqdB5w0vrR3tQdm9U95Zu1A8XFdzrHwc6eue9qKH6cRuKCtWqdfbi2O1Dr7tiGojHfFpwB5EUbQDwhwDXLxox0L+U/uS/THRaA3sKRmnMFUj81j7PWVW1DLsXisSHtFq3xsKQ3EHSKeVAWhqpviD785BZW4j30EyNkhWSwAWff63Snmdespa1rxyLNXEtR5tXRrHTQwYqzGF9mASdnvvMKxxHp162I6iOfnlacfA/QZyzu6RwlIT/g2ZSzjM5QcRaggOKZ7opCoaJ6PL6wYxs7d02Ymj63LRL5dMLgArPZr8ZDeBrB3igFsEF33397B/EEqsRiawEmhWltMGQ4ilKWu/BV2EIBXDTrOwX/vwmtxatmoxXqMRSid3EqpGhbvqCH3eSjlNEKn78t+sxBez+SMoOZePVT8BzFuKhUAyrC72wogGmmNfADSJs3rV74WbkDrxidhiPsxCgAB5JdeFZOoQ70slw2kD52gbi6AI8aeBdzEdckxTsMdLFN/4eCaDOvtayC9jjmrH2xE7VsENdHzd7XaiRS7m/7PMRfH7Xc2Yy/ILWnXFF3R5WGAKNcmrMwEvfZCIcDJOaBbT44Bwe95pNVyGA/bCPQgJ82NQ68Pzysa4Vs66uqnhiHw5oIpXXz5zayWqtq92mL74bUglUKl70BKxdq1gpMchV1gfOGvXceqW7Bb8GHaReD
 RBcJJt4Y
 CLSXBV1QuIQcWEhOovFfpyOh4IX77YcgKp1SNIXHx7ETrVz1p4DZPD9aN5j7Xahl5/M8ZQCaljqzfN1CnzGQDpgcR8CIR5nbvhUCtq2zhg/C5bXeX81htCH0LwghZyxmDQXHnGSpy0qbcMhiCJXM92ieHVkcm846Apvv/35hKGAWqKQEXfjo6jdX1cJ/7AbSvtn+0Yja2aVuCt8xGFlO5xjigQ22cESSQuLrJ4/LmdhSoSngPn47Rh/J9sJgWGt8dTqUfZcxtwp1C7oVi+MnkThuar+ZUzpmG8QTprlO3/Kv/wPNM5J8Nb0VOKvvpJcqXVSVMmX1SUhwZRTQO6HwXlPZ6jpsInAgBPRFiHVSoXpDCHhRTjFUhE0yeaUCtiD91XveVlzQTYvgb57S1leho6y/gKcn5ryHIpi5fpMVaX3SUnfIXboQuyDFlyC11WJksMKGiNNuvMzDdt/gzrdCmo/XCFzogS0YiVQ91TWxbaFmhLY5NznrprceJYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->private should not be set in tail pages. Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed a
DEBUG_VM check without a proper reason[1]. Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fb2d7dd17de0c..ea0445d6c17f0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3591,6 +3591,13 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
+		/*
+		 * page->private should not be set in tail pages. Warn once
+		 * if private is unexpectedly set. Do it before swap.val assignment
+		 * since private overlaps with swap.val.
+		 */
+		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
+
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 

-- 
2.53.0



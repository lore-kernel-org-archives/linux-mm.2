Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CDC9CDB463
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AAB8E0012; Thu, 13 Nov 2025 20:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72218E0002; Thu, 13 Nov 2025 20:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A615B8E0012; Thu, 13 Nov 2025 20:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95CEA8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:26:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6508A86DC6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:26:05 +0000 (UTC)
X-FDA: 84107471490.28.11671E7
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id 901B61A0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:26:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cVapk+fK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083562; a=rsa-sha256;
	cv=pass;
	b=2NM4djfd+0mJgLJfOWMRRWOjjvkDmERbAxfpKx6E3+6bGARw2jMEBa1K7vVXQgbarKZVZ9
	eVEe3A4Qx4fU5T+LycHvgRMnRmvjAWWwiIixPvUmN3LiacGwxBYHKgVEvfnz39A/1U+cCx
	aRNSOBmUoyshT9ib5wDcM6VcP6PaTv4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cVapk+fK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.68 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzKiWmSsjRgAkL9qrCF364CucvgyAe7EDMa5/DRXQUk=;
	b=fJ3BzIzsrZ7MxP+QyIUO9YW/sSRzhdjeMo/TtqGdijTDrxBZf/J+R1SKxhcSIA0/fG4F9A
	ka8W8F0+1irppeFvZw3hoptB9tlqi9FySGpVGF+t4zWBEEao1gefkBVl/7KI+PYvWpGoqc
	g9AiyJlBuVA5cYwKx7lmbnEIPVmQih4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpT7GdbeeFlKAPJIRqvrTy8g7bQOYesIC/ElD3Lv3U+O7wAaVxSi0lsRklyQmI8HzzI04Bfm97pJDwiZH/eaqrQfwqf0XyuhtXJoaKWwkeOILigDOL0JBcJ1M7Fks47KMNg3x2XNyYdIwTFJzfxi9/AtuumoONxtbMSjtB+mcuJLjpiYlmUSRZ7zW6bN0W0MSJAGDSxsPXAf/ha/l9IL8wYn0xDIwbU2huMvXuEr+E/26obHwx3uD/p+EYjEJmXZehb898umZC5uXQzAbEcl8rk37UU3mpv+l+PSL5K0mWGt70+c9Ys+xVSKyS7bm5sxLNrZDVkPNiNcNpkLVCbtdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzKiWmSsjRgAkL9qrCF364CucvgyAe7EDMa5/DRXQUk=;
 b=HyiHpvhPy+KYopMYSvVrFwDY8MqB1djUeTR7ORmN7qQ4gQLqm8hZfFSfz/twDIDvWMFozV1ipVqJScgrPdeKv61ATR0g0VX2bSpz6UMVgXNl8TRs4rHO5buBI9+OJv34svHeksJMoI+pMCU2aQ75FZgzB6J9FYL8o0/sPcVNVtJF48A7HalpAGakFoiyyL04l0775fCazD53g/Tw7cWPNT0+Vq2fSGVeL+SrmnJI4W8LsgNdGqY/9YatpVN1vm04SurXyPkuuHdsjlzhkljW9KXYsK6ohgXwJQrqimgqdpZwnR8/VtURlb8DxuWr4AGx8Ip0Q7+3PoOtCFKpodeOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzKiWmSsjRgAkL9qrCF364CucvgyAe7EDMa5/DRXQUk=;
 b=cVapk+fKo3GmSPb7YPJ18emiGTafITbIl1vWUS/Jjon82PvWw5VWlCPFkebXQFlLMIuQbjMV+ohaFopK2YMfpRg6MdGhrnHCHIEJvupZQDr3ps//SCF2tRJh9HFEbvSSnNqoc1HCqYETaT+bbCFmiXS6pwYCj5eO1mbuc8kyJCBi0zTrs5aLvk36Efzou7jRAVhc9RHr+7sR9dqRkhmpgMJscerCbBb48WRaEorrIrMBzQVA+l6SAf6GbzNTrFVN3PGKjoNjvIZ3cu0nS+dXpxxfyOOIZAZh69MNPYS+zCpq5lBFc09NSkNEW0guLh/kTLm14UxK7+tMvuqjTZ3gOg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:25:58 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:25:58 +0000
Message-ID: <4f8b1c55-95c4-4235-affc-131f4c75c9ac@nvidia.com>
Date: Fri, 14 Nov 2025 12:25:51 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix up softleaf vs thp device-private in
 remove_migration_pmd()
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012153.2634497-1-balbirs@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251114012153.2634497-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::20) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 33180e05-0758-4e99-5232-08de231cc3b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVF4MmVWbWZ6UERyZW5aYXRjaUlMMVVPRS9yNTV3QTIzNU50d3VQcWRaVkpC?=
 =?utf-8?B?WEx1L2REQTRTZmx4N0c2ZUNqYmlyekN3WmhQazFuMzMveDFEcVpkQjlwNXhj?=
 =?utf-8?B?S3JRV0Y1YjZWL1VzK283N0toRk1rOThxMWRWUHo5SUcwWE82MXppcU1yWVh4?=
 =?utf-8?B?YU1FVk91WUFSYlJTYU9TTEdyK3RCNkdUaWNRMW5hNkZJVU1ad3I2WDNsTDlk?=
 =?utf-8?B?TkEvVlpSbS8zcXJnVzhNeGExQUltd21BdHlGYUU0L0xuRXVia2JOYWFkSFY2?=
 =?utf-8?B?QTJQK3FITGU2MVJHSnoxcnNWQU0yZzRHMUR3QzhiRWdMaUJsWFE1SlhLUnRy?=
 =?utf-8?B?YnVmQlRVUGFuTkJyUVM3Q3B4S1hjQkoyYVpNZ3A0em5iRk5tM1hRcFlDTFdY?=
 =?utf-8?B?VVBrYVIvaVYrQ2d4ck1SWGNabHY2UHllKzUwRnpTME04cTlhRHhRRzhOelUy?=
 =?utf-8?B?a01Ja3l3NmtTQmpNaVBYTzhVeVZVOEMrQXFZbm9QQlV2WXhoempjZnN5TzFz?=
 =?utf-8?B?NUNybzYyYXVHVnB5M25WMGpsaW1qRFBqTnlLeGxPQy9ybkltcjMxdjZvSTBv?=
 =?utf-8?B?ekp5M2JuVk4wTU9SaFpnT0l4Y1ZaaHd3cHJWQksvQmRSanl1c1RXVHNtNnBh?=
 =?utf-8?B?MmsvNWtBNy9WVmpZd3o0eVFtMzRqZ3dnRi9FMjUydi9HOGliN2c0eW5FM2kr?=
 =?utf-8?B?bkVoNXhjeEp3ZHptRXhnZXEwS1ZmREZ0Z1JsYXR2UUc0NllHWEEyczJUQ3J1?=
 =?utf-8?B?eXh3VmFGNVA1R3VqTXRYTnBORVFQRit4Q3Vxci9WU20rRnlLaFhTbE5XTnJZ?=
 =?utf-8?B?SVhQbVZFcVl6eHRCZXdoN3J5ekZGeDdFRnhTamVXRUIweHl3MGxkUDltQjR6?=
 =?utf-8?B?TTkyMlE5YXFYaGtPTVpFYjYrV0FVRXE2cUEwdWxIRFE1V2xhcHpzbjNNdGVC?=
 =?utf-8?B?M2FlTlV5c0Uvb0VFVXF5Vm02VEM3UXpJTHliOWlnOUVMMWRDYi9yNms1cC9t?=
 =?utf-8?B?ZURKbmdrOW12Zk5PVHUxb2p1Uk5FWWFFRzNSNkxUdXdzWktQVTJNNStGZGdt?=
 =?utf-8?B?N01LVithVVhrQkMxRG8wcFpGSmx6MG9EQ1NXVnRpcVZ6c3FqM3o0cEkyRG1S?=
 =?utf-8?B?NTZ3R2ltSnBIeWgvWVd5cUVXeTl4ZEVCc0h1M1RYa0FPTXNKVERaa1llVzRh?=
 =?utf-8?B?VzJLYTN2Q1U2anJnVXNyY0g5eS9GMUxZQ24xeWJvRzN3SE1wdU5zZWNVV1d5?=
 =?utf-8?B?UjdCOVg4bzBDaGRwdEZ5ZUpXZVJxc3V1SFdSVTd4Nk85OU5Nc3l1TGhxYldY?=
 =?utf-8?B?cEV0NWt3b3VWNVZDaW9NeFduaW1nUlI0YVMxYmxCMURZTVZOeTc1aVgyT1RJ?=
 =?utf-8?B?RmNob0lzNGN2TFlGekxoYUhROUIrQUs5RDBQdFA4ZFRod2tuZmJ5TlYrU3pN?=
 =?utf-8?B?Z0NEWjhzRWNRVk5WTHZsSVh6Z28yYjQwaGVtTEtCM0NjZTMzYUlyOThDbXBa?=
 =?utf-8?B?SXBoaGQ4Z3h4Skh1Q1RleVdCMmZvNGxSOWRGVWRtUktnT3VEeUxEQW9FVCtV?=
 =?utf-8?B?UnR2Z1JYcWxJYWx6ODhMTmxVd0RaNHg5NEFiamJqVElLcHd4aWxITktrdUVz?=
 =?utf-8?B?a1lVQWpmbGtHZ3ZuYkVUOGNvNThUWmd0MGJ6aCtsMWJCcmNsdWUrYmMySzBl?=
 =?utf-8?B?YUVRRFlvRmtNZ3hCSlpaMmpCcUd1a0RMMDZEeXdDSGxBRlNvYkxvMFZnNEdC?=
 =?utf-8?B?aGUrNDc3MkpZbTlUcDk1VDBDc091L2pJdmRXMklmMlB1NkkvYzZaRlBVamJS?=
 =?utf-8?B?ZGpEL2IzRnprZFhmQ2x3TDIvWnNuZ1NwTFhqRlBWeU5OT2V3YVdoMWhvR1hh?=
 =?utf-8?B?ZGJCREFmZ0ZqSUdUT2h0OGRLQ1ZTZ0JPM3hpQXJlVXVZQUo5YndMR2cyR1pX?=
 =?utf-8?Q?ZLKBNSYeiRz/38tdDM26vluJkBdXabYf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk9YT0RkcHdQZVBGZjQ0WHJpcjg3UXBrMjdGYWFScmcwTTY1OU0wUTlORG9J?=
 =?utf-8?B?ZmMwWHpCOVlGUWY4WkRRcUpFS2JkWHFsdzE4MGwxNUx5SjBiWVJqUW04Q3lM?=
 =?utf-8?B?Smxia2lvWWxrNi8yVFNGSnlNLzY0TnRaTGZXbkQzUnloMW9IaHEvSitCWU1r?=
 =?utf-8?B?cWFlUUxDemJKNWU1L1VNMmdsMUZXKzg4clNLUlI2SERGeWZjTWtxL2g1bklY?=
 =?utf-8?B?aGhqK0VxVUNHaXV1WkI1UGthN2pjT0NyZW8wcmRkZzJlajBQTVhxWDZqLzZy?=
 =?utf-8?B?aytlaDRHenQrS254bVh4VHpMMk8wQ1ZkaFlSc1F2MjU1VzNaSWEvR3FyTTV3?=
 =?utf-8?B?K01INHN6UDRqeXBGZkJXb1ZKUlh1Sk8ybjBMTGpUUlNhcm1pd3pvUnJtRFJF?=
 =?utf-8?B?MlZDMmdNcVNnVGZoODg4WUpCcWIzbVdwNGNMUE1tVG5qaW03R21ERGdtUXNp?=
 =?utf-8?B?Z1Q5QzRaeFdpM0RIcUVZaGFhK2hSZmFtZzhZRTFaOXJvQ3BzczNucXRTMW5G?=
 =?utf-8?B?cFo4V0VvdCt5K3IvUUZFS2FLZkRHZHROTG9JbXowZTU0aEdkRCtTS2pmbWkz?=
 =?utf-8?B?ck9PRmd0ZmFnYVRpYW1tc1huTUFNVjRTTUYycWFXU1MzZlM0ZysycjhVM3Yv?=
 =?utf-8?B?cHkzT2JJUHJGNzgwWWtCV0E5eHhiZmx4WExtTGxEcThHelFvTGtDcGFUS1lU?=
 =?utf-8?B?YUgrb1daK2l4bzIzNXJaZzRSZWNjSGs0N2RGZllTOFcyK2ZWa2ZpUGxOVzBK?=
 =?utf-8?B?VlNoOXYyNU1FWUFKdGU0ejY1a20wREtuUUUzV3N3bUxWaHQ0T1hZSVRvakZa?=
 =?utf-8?B?SDgyT3czUHpzZkw3RzlEMjBLTUhHN0lQeWVIeGRQcE9KenlnRTZxc3NUOVhQ?=
 =?utf-8?B?N2srYnhDdHY5aVRrRDQzTDBWZ2ZOVUxYSmJ6M2Myd2RJRGc3bWNuMEtqN3lM?=
 =?utf-8?B?blFMQWpJWFNYa1ZySFVtVGlwUHA1b1RKNit0S0dPQWFWOHY2K3ZvZEFKMDR0?=
 =?utf-8?B?K2Ira0wxb1c4ODgxK21mNk12cXJ3TEhwUVRZSDJiSTBWSkhVa2lvMTFWeVlv?=
 =?utf-8?B?c2toSU9WbU1RREIrb2dvWkVzWjB5MmtGL3JpdnRZYzZ1UXdVdlNyazJUMk1Y?=
 =?utf-8?B?dkpubHg2Y0lMemYyS2NMZHl6QXBJTTZaV0JqNDg0R0pnR0xjZVM0anB6NXIv?=
 =?utf-8?B?YXlueHNTbUJzcHhSdkJ4aUVyVTFhNXljVHJ0ajlTditsekNCeFc2RmVlVnFs?=
 =?utf-8?B?Y3dSc3k1Mm5GbzI1RjVlNjFmdUFJem01aXJocUxvUU1YZ0I0QlFrV0VlUy8v?=
 =?utf-8?B?Vkk0WTlER1pmQnZUOGZKK2Rtc2J1Vy9GeWZBYkN3cXR2K1REcGNEN05LZ2Qy?=
 =?utf-8?B?SU9iajJ0S0crOXM5d0dDQWJRWW1KSk9wYU5VKzIyVU41U1dwenVlQ0Mxa2V0?=
 =?utf-8?B?K3RCU1dJeTAyKzdEekRrUVpaczJMWi9Eb3lQdDNUcnZsWlhlVkRJY3UyTXRS?=
 =?utf-8?B?SkorOVFybW92K01FNG15WVl5UWRsejY1ZUJYR05sM05xZE1SYngwVUpWLzdR?=
 =?utf-8?B?bjdCRm5tNVZ5cG9JRHA4Tk1JTFN3eHhrd0xmazNtNXgwZmdqY1ArODZjNytq?=
 =?utf-8?B?N0ZBd2o3NmxJZ09hUGk4UnVoYVF0QnNJcDREbXAwLy93VnlMNDdNd0ZwRFVs?=
 =?utf-8?B?eDV0alIrNlhMYUtjNWtGNzY4Uk1Cb0FJeUNldHlVYWxiWTIzU0ZlYmJ6a3Ez?=
 =?utf-8?B?dFRKRDdNRDJWU3c1T3NoUHcwZm5zT0pCb1RPdFVmbTBIaWRjN1Q5NEZWMnZn?=
 =?utf-8?B?UC9BQVkrZWM1SmtVYlQxUkhvdXNtRDFyTGVmbXEzcXFvUzRYbTFEeDVQV3p6?=
 =?utf-8?B?TnpMS3l4L3BNZDBoRGtLYkl4d3VmbDdnK211dlVlWDdKR3N1TlU5OUFkN1hU?=
 =?utf-8?B?Y25ydU4zcUREaFdSZHdnRXlUTjBienRWRFdhdWpvdURDREpWQWh1S3VDWUd6?=
 =?utf-8?B?cG95VDhTRWtSSlZGRlE2andvSU4zTXN3MTFNdUhQbGQzcnZUbnJvTW9ReXpP?=
 =?utf-8?B?RkQ2bjR3K1Y5UjVULysvdCtRT0k4dDRwOS93UzRyMlpkeFRQYVJhQ1M5b0NW?=
 =?utf-8?B?bVROdVlXZER2d3h4VlAxTGpLU1NFNkJrYmVqRnArQjZTY2RLMlE0Y2VXMXJa?=
 =?utf-8?Q?/D7K4wN83rRmA/DFcFaKG9dLv5/wLoq+8ORNKwK9CGRk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33180e05-0758-4e99-5232-08de231cc3b3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:25:58.4548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MWo2+zjW3ndVz438EACsJh5OiiQbS5tOGu1C/pLWD4U0glvJi8nxOir1K7f7fTwmJ1VN1e3KawwIXaAMRdLuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Rspamd-Queue-Id: 901B61A0002
X-Rspamd-Server: rspam07
X-Stat-Signature: s6aw5bh3hz7k4rpics5f8jjmb75iaz5b
X-Rspam-User: 
X-HE-Tag: 1763083562-870339
X-HE-Meta: U2FsdGVkX1/4x9QcoS7mGixrl6fZEMNXSQNyHkDGJSBfVzAOeAjrcw2qlW0h8c4lEJp2Bs/L3rXfNV463JeiTr6Fzc/mQcLFPPX4klUcEboGHOXfIYbQbS844w9EhzKPMPtIrybjqHG1otyvijX1SYAzhH3xoZzWBKDXL7tD3Jfq1I4m1oYpSSLAq+CoUCMVrG19uSwu2h6UjnmQuzfammxe76fgK6+FxcX7mrDl/0MFxr9nailjnGNmN6upGVMzXJiB9rm+0PKIc6mnMB+yIxVL8fB+/tLXUCOdrkwCCL1EigcafWmYOg0UWui4J9PC+ZObPzfKphmeeAemNacib5N5LojND4zPYRge6reNEN8tggXmJkO87lzQQ/x3dGi5bbViRg1j2ZSc+WPFkY7mFeeGxc7DCUuFf6+lR6vfgdxlOTM/c0BjyG3tNrfkJIlyShDO5g1KovYdIXWH/JyuwE05S/DhXVYrwup3HdOoAF7UzIHpdFO/s+zy9XhVadigOlGYmjfEHrByg8HnCaRs7xPcS7eqZwKb79/E2v6l7eVPT+XjQaA1W0tmONDyweXU3p5lM4h7ugq/Q7//huE9GKh8QX140gnCD9snY/2/+IaP2C/dAbjm9acWz2l0BuVVm37K0xmLxQSjbzfsjisqRItjpSA+eXtubCMfmLX/jdDD6ZSOyVcixq44xC+u2FtkpIUiicZJ1hhv/zSCrkRMQjvQsVqSdHFONN2UEARPDlPITBTYHpvrM2l6v96A/NsXr4hUHaVokc6bHR5cdfP6BUdpmuc6k/7/+4JnlUbPlLg8lQ/6wwvTR09+je5keSf25vVhgB/nF7re7tnRrlaQcsRXHU/hFdgGlI+O/L5E67j0eDP21JGVrcS+CKQZ6dq37RhRG9ZeyWQxmxkGuMGsRXu5eJAZrcbqxQZk1GeSJtLVd7Fyn4jwLF1xHxmTxbqgcx/CAku0BY8zn2Sqp3P
 VwwTcCVm
 j4Y2r1RAx+8i5PnIPUiEyADRCCZn+LudTrKETGQysJVB61KwXDyv/TJ5J6DaOlIxp58GAFt8LCMQEVsTM83yjsU0rZJoslA3HfFhOs0vSHwd9RbYmcbmiPE4cV6TKkn06k87iXeLr7Lnm8PRg6c63js6PwPYQXyhYHguGKEX7R8J6BQaqc8FInVK23NAPWc8XPwBeKv05nq890ez7Q0mDodtE49QFDvRyHlPyfJu/GvwaMmNeeYPi0D4UDFzarXPoq2paMwRlv3kQpmEs0F5zcLYUvNxfRcYZ+QDz2BeoRiHXGtuB2joHr7N9mlUY67OYdyzVthxV5UVa0IWEMPG7SsVUOF4Y9Hl+MWG7OzCa4d36PS2ErracVgCVwPDnsbqsXT6VOakWyeG4aE70yAHYVkN4+KTbomvNMIE6U5jrLiQd1yPXlOnmWGuxceEYILwG/NLdzG6XLa3ddgnuGHepu7RCFqjfTABlH4x9QyX0F0umCXMG7nK8Z55MJTm2A34yC9B4pfP9bQD/vAVi0Td+nxnq6Iz4b7XNyHw1zIVT40s8p6GskSJr+mkbvPfWkGmEGMn5YkOWMuFIaF6rW2P4Wfruj1x/Iygl4s4uifEQYOmergJWC9cdoG15Tpuqdvv8d40Yi6x0wDVIQ7KV9wlSyayhRRxQ1O6Rh1pfmTviRsnC171AieepL76Dc2iCYK3F+K43YYC7iCeHgRIRODG15szQ4+nsFqBwQKc5kpAL4NcUDDsGt0QsAe0MrrCpifKwtN5Mlar7CFHTyDwWGL4jsELrWrvaf+jkwIFNAdVrCBHRlp6q1gjEy1PlTULYdBw2OJ5IY2CYv9N5/ryJyUnh7YN7aecnQ1nndx2ezw7MtMtuSKvi7/ZiL0UPLQYnlheQj+J0F6woCjrCn0EHXCp3lz4Ht5dbA+QyCK8pHxt1Gj+4ld5UwGusR2GR+m773TEW71lB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 12:21, Balbir Singh wrote:
> A fix-up in the thp device-private patch
> mm/rmap: extend rmap and migration support device-private entries
> introduces conflicts with the softleaf series, this is a fix up patch
> to resolve the issue
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/huge_memory.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3a8f0c4143c5..4d65c51bc0fe 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4760,7 +4760,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  	folio_get(folio);
>  	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
>  
> -	if (is_writable_migration_entry(entry))
> +	if (softleaf_is_migration_write(entry))
>  		pmde = pmd_mkwrite(pmde, vma);
>  
>  	if (folio_is_device_private(folio)) {
> @@ -4777,8 +4777,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  
>  	if (pmd_swp_soft_dirty(*pvmw->pmd))
>  		pmde = pmd_mksoft_dirty(pmde);
> -	if (softleaf_is_migration_write(entry))
> -		pmde = pmd_mkwrite(pmde, vma);
>  	if (pmd_swp_uffd_wp(*pvmw->pmd))
>  		pmde = pmd_mkuffd_wp(pmde);
>  	if (!softleaf_is_migration_young(entry))

Hi, Andrew

This is the fixup for the rebase issue that might occur after applying
the previous patch to fixup mm/rmap: extend rmap and migration support device-private entries.
I've not done fixs up rebases as a separate patch, but I resolved the conflict
in favour of the existing patch and applied this on top of the series.

Balbir


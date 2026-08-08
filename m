Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A556CC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 18:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9F46B00D2; Sat,  8 Aug 2026 14:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64236B00D3; Sat,  8 Aug 2026 14:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C028E6B00D4; Sat,  8 Aug 2026 14:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6709E6B00D2
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 14:54:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A1B5A03EF
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:54:08 +0000 (UTC)
X-FDA: 85079002176.24.4A2105A
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id B746C4000A
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:54:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AsoJCWeD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786215246;
	b=XxRTgOKxJuE891+PtTi6wQD47KwlHukyh1RUSvXsdtNJ0Q22twbGBx7ohTsPNO9/t9mgtc
	NVXNuGW+DMJDDPQz/5hZe2nc4DpiLla6pMosJpIwnjavFGdKa5Uu02YiaLmEUmqHn1K/I1
	CqBlHiLkbiUFmTWAhBj+lyALtYccddQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AsoJCWeD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786215246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBqSLQ9EGERG79RlR9lDOLqffmLpepjQBcH9eruO1ro=;
	b=3GgXy0elcM2Ouy6qwS1vPhPzwdCuHBdAPfDd96XhX+0oJOrd+Sdh8O6oeHMFHHzzoZh4hQ
	RWcUDa7mW/2vE/g5ytnSoYfEn7MDp6cdlpbQ8gysjMv15p0q9VPHWQbDVGV8v2PJPU/2z3
	+Ehiy6Yq0RXnsdUSgbCZpvL4cqekH7U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yscwGKQsxIoafavNe7/FdmDrh7mz5pM0j4RnpJ6xh8YPhxXs43yAMtLr8rWCOPO20cE/2odCqjesvbX0tu00/YBtGY8UVZcZ8Nf5QsvW36ygxjTbqHufT4J06biG8Oiw865wPi+FWMngRmxV1FLQUX3GQIcYB9THIT7y+yBFnhnAHXbzHhpdcX3vGaZKdJmt0AZLx6mAOybjtaGNwH5DCofPWEVbO/6LmugoLsMceoVPabQlnU48mFLTLitt3ah2vFXIqP9aT33VbBpRNqiwxe4zTlff9mpWKlhZUTTYtPWtkk7XCwA3IwoeFgb1kOUIKvbBskhFQ8iCWD7aZxcN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBqSLQ9EGERG79RlR9lDOLqffmLpepjQBcH9eruO1ro=;
 b=awnSY4rTMLIcrp0itvG16UodhVlXUlej4v4z6UkkxuLIo0L2rbJQQ/YCmG3z+3rBlKWQQ0FMU2s57zf3WNmVausfxGqRD6QHoEO0qStKSdNokMhIW2JV8+P17L5pAl5TxpMwgVsf4Dlg6erEbfYRzz+RJm9ycuvmGU8jOHd7/I5IqyhXZ+ffRbEQnMuWENlcsE5IrufLtI95dS6slXB4IVUuLvsQCWnKiuiUFZnHbdxp+LMFcJNXOIxxPQDxlrDYqdPu4LHMdXZ1bSdLqRJXZ0cbWlcNDuQtaGftCsL93XOD5X9qerYsjTKVYCaYJY2mUgV4kZXnPAxmQbs1jOv+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBqSLQ9EGERG79RlR9lDOLqffmLpepjQBcH9eruO1ro=;
 b=AsoJCWeDSNyxfpbkvQ/0xC1i6b2T/tXpfRRCxoqaQkQLYBpZJ3P3ZtM4o95Vy4KfAOnR3wh0CX2VbOLs448B1K7gVeP9ysISYP2uo5Jw4Al2KeXJTIoZGwf3Fpn3X+ESmDBoE56JQwJwDVgaxuj/6mv0KrvJJUwFQEO8s+r1i2ZQ1TkdItFCuNTCpveW7sS4PX2oKSYCXJyateMXYno1sm5jm1/d0ZptFRWTWnIXJAd19268pCXMGbyJDduCE5Q5M1bx30AN0a+SSRPEtvTHUPsQH4Q9o+XuukNsvRDnrJmhubwY828/8jGEkXt5zJoUXptB9z3ten4Lu3grPrks3Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sat, 8 Aug
 2026 18:54:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 18:54:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 14:53:58 -0400
Message-Id: <DKJSGGIVFJ93.23BV94A3F8JIP@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 02/13] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: "Kairui Song" <ryncsn@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-2-689939a7ccc3@tencent.com>
 <DKJRCHRR9H73.X5JV4PU1MF7X@nvidia.com>
 <CAMgjq7AWE0nvoSqBvyU3id9BxLb1NRXcyPV_0yV6t_OTZ04V4g@mail.gmail.com>
In-Reply-To: <CAMgjq7AWE0nvoSqBvyU3id9BxLb1NRXcyPV_0yV6t_OTZ04V4g@mail.gmail.com>
X-ClientProxiedBy: MN2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:208:239::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a417843-a4a1-4fa6-3dd8-08def57e685d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|4143699003|11063799006|56012099006|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WnaKoicvaD3khUIC0VpJrrwC/G63PT31B7SVt5S/MqUznOYS3nq/J28lSLUPHurESix5UgazoxP1W8EzlZLCnLc/Vq+5YTUmfU+tKdOw4MBdT2YUTcQ0XuNCIzbApBaAUNpZyy+6iMxHR7Z/F+7lk/r0SjqFx2i0E+kwgzqsU+FpBW4vk0dLG6F/BJDHa46GP1jCWcZcqHN29+H3Wz6g8rjUyfTX9WcPg5/ELn+lXqpwoEhwnIr4SsloHQcA+ZpTlAwiv9eWGScweRgwJSGp7AXjesi+cintsx6u8AtAzcLCOelNc/TEB9zPs0esFCWb8d9HK49ZUfzEVRCpJ3/q7o2kBX6izXyrpq9AJjEKuQ4rzkoGXNanLLpS/MQ80aL7Dvtq76Df5w9HjG/6PiASwubHe/r4YahXy0yjtVC/Xe47UxzRu2veWLml6PG43to6A0xd2D3YW2rvpvl8wWzGCAm5JWuQOS8BgbTduY+5ONiNXp5PKgE0Rbhqx4a5WaeSbcyBTEQSrjl9eP9i+xffu80Y7fWsfBnKOYx/akvSnBv2ijLr4WjTPYvrlv3+6mOWe+nK6LTcjDsUV8tHHAk/k8LbCfPALmQm+x5Yevfgayl7bjqyQfTySVtWYFyC3mUYhd/eIyURApOMlXeoLADZp5jKXfvmdPlw23Hxhizg4ik=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(4143699003)(11063799006)(56012099006)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1lkNG9OUXJCS0FFckE2V2pqOWpydUwwYlI2d3VDbmpteHNFclc3elBWZ0Nt?=
 =?utf-8?B?OEdiT0VPS09ESnU3aDh3UXZVM3h3SjJnLzhTWkdtOEpsRjlVSDhWNzJlNzZF?=
 =?utf-8?B?YnNqMnVESXUrd25ZNGE0UnYzMlNmLzROSFQ0Z09qNE5yT1JtaG41WVNwcW03?=
 =?utf-8?B?WS9LT2ZhaUxGRHNnTkp2N0lkRlR4bmJ0Um5YYVNCVWoxRjRzdWk1Y0toNGdM?=
 =?utf-8?B?cDJrcTFVb0F5T0c3T0N5ZHdwRTVrbEVtMEZNMWtjSVN5b2JBaXk4WStrbEVm?=
 =?utf-8?B?ZlRlZ1hSMGlaSS81RTVpY1pPVW1xUGxmQ0JkTEhnOG5kMEVtWE9LaGx5RWJB?=
 =?utf-8?B?bERRbGorUEFBUk1ycHZEamVjUnpYREhwS0xoaUxWcW9sNmpkSlpxV2xBSTNi?=
 =?utf-8?B?amJYbHJNUG1BdTJrYW1oV3NBSThodXZkVzhIcisvYXI3S0hINDh3YVBhSEw3?=
 =?utf-8?B?Y01tZ1VrbncxUUYybXVVMnVzTENWUEQyUFhxQ1lhTnY4Q1FnTmM0d0RWbmpn?=
 =?utf-8?B?VmhQcUJSME43a1lYSE1RZzBqNmVzekJ4V0RNQVhTM3pOQ1JXSEpROVE0MVlI?=
 =?utf-8?B?OTNwa2Z4RiticzZWL3ptVkthckRZMTh6N2pXN2d0dWg2eGk4ZVpEaGZ2bkNv?=
 =?utf-8?B?QXZPMzR5MjZUSm5QdlFBVXZhZjY1MFVuKzVTZHJ0NGpDTnZJUWQ1RHErbjZ5?=
 =?utf-8?B?WXdPRnVWYUljS1ZsVFJ5R2x1Z0FndFo3ZTh1YkVWMnkzQVJvQUpKUXRXMUwx?=
 =?utf-8?B?RmtORDJ5RnV1a2lGSHVBUTRaUmVsZDV4VEp0Mnhrd3dManYxV2YvVlNtSTZF?=
 =?utf-8?B?RlhqbWJoOUhXK0R6WVl2QUYyMDVRL09CandjOTNRbWVZZXg4OWVldXUvMmor?=
 =?utf-8?B?d2cybVRCVjdKTHZuRGthYk54bUsrRkc4ZHZFc2dQUzYyMkt6bTk5Y2dwa0xQ?=
 =?utf-8?B?N1hlZWZzWXBwSXBRZFRQZGt6L2JxOXJNa2xTNUdUcjdIc09GVFFyTGcrZkNp?=
 =?utf-8?B?RWNNNzhHb3ROSFVLT2xqTldEcm9VMGpXM1B6ak5OaERsdlVxUit1cXNEaUMv?=
 =?utf-8?B?blEwM0ZLT1VaUGFtZ0x0Wjg0UW5BeldPeHdaR0xlNWMzZ1l3OXdWZGh3cVIz?=
 =?utf-8?B?ZEQ2V256alJncWpobWYveXU4djlKOHkrUVBWVmttbXRxOG9LL3RsUE43cEUr?=
 =?utf-8?B?TTN0MCs2KzhRSWZndXFvTHVmRHp4aXA2OE1ROUdNREhvVkhjeWtjUnVYTXlF?=
 =?utf-8?B?YkJIUTFlUU5WK010ZmlMNTZPa1NXNnNNSnJ2M2tob2MyRDNodW1yQ3BsQXJ3?=
 =?utf-8?B?V1c2Ukk1d3p0RXlqR3hKNnhXMjVMNURBRnl1RzRWcVdyMFQxNG5UUkQrWTdW?=
 =?utf-8?B?WGJBY04wZEl1MFFjbnRnQVhiZ0huM1NjektzSkZtc3FRU3ZzcEIwOEc3cmZk?=
 =?utf-8?B?WS9MNjRwK2xNUjZrenl2QjJMY3BoeWQraUpjbS80MnJXTXRrMlJ0WGtOejN5?=
 =?utf-8?B?ejNqTHhOL1lvZEMzSnVOa0EzbzdkV1NkWDk5VG1CaG5CVGxNRjZDR240M3VD?=
 =?utf-8?B?L3VKRG1GTGI1c2tYSlFSUkxrV08yb2k5dENyUmJ4ZG1mYnhnaVU2Q1AvRmpj?=
 =?utf-8?B?VU9vTUZrMk5jNFNEdVhORjBaS0NGL1dpWnlXWEpldzNXMk9yby9EMHl6L2My?=
 =?utf-8?B?YTdSTUh2V2ZDMW5odU1CQzAxM3dYYTJVc1dCR1JJTVRrcm9IekJ3U2hsL3kv?=
 =?utf-8?B?bjVqcHpLY051cEJjMHgxeGV5WjgyNzQ0T2UvTm5FYnduT2VsSkMvSDNQN0Nk?=
 =?utf-8?B?byt2S1VxbkVFSDlFMW4wWXU3cW0rRmNLc3pMN2J0am5kWjdFMzJBc01JK2h0?=
 =?utf-8?B?K2lLV25udCs2cnpCSEJJbHB4NFV1U1prSC9hOVFFVjdIdEVxbUxaVWE1UlZh?=
 =?utf-8?B?b1QzRUM4ZEZ6YVYxa29TSDZZTkp5YnRYV2tSclFyT1BROHUrdm5pbE4vS2c3?=
 =?utf-8?B?ZVUyaXZmbk9IQTdVclZicWhudDNrYU0yL0kvTnFPNGRCbGFwYVJTOWh4c1VK?=
 =?utf-8?B?R1dYWExjSWpReURSeU1TRmliR2hjU2xKQXNUN1JDU3lwWEZheFZCUGY2NzY4?=
 =?utf-8?B?MmVnQnZzSHRXZDluZE9od3VhS0RzcFlnMmd4a25TMnlzT0Z2RnVoVTRsbTA5?=
 =?utf-8?B?S3VsckpCQ2NWa1BpYnMyMnRLNzg5RmRhYkhkVnpENjNHRUQwaW83NmljUlli?=
 =?utf-8?B?VTlDUXBVVDNOSXI2RXpTcUlkOGpRdTN2Q2ZHREFTc2VSYi9xcnVYWlhtNW9t?=
 =?utf-8?Q?nLBOeMcglEAYXnI7Hr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a417843-a4a1-4fa6-3dd8-08def57e685d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 18:54:00.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJxCWy89OW/Clr60HmA8lyfegrrrtHfxhzVQazIJUwJwYmcviudxoHDlh/AArdOb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B746C4000A
X-Stat-Signature: mm9gaoarzc8jm8uwb3r9hzs87smztn47
X-Rspam-User: 
X-HE-Tag: 1786215245-284154
X-HE-Meta: U2FsdGVkX18T+GRiP21OcGIeDT7g2zcb8QkgHwTXOiwYjEOt3gFG7+vy/P+xdXxFR8/jWQD6eqduTc5Lx3A//OPKQvsl0bZWiFPFOmuoBMknAn/jeIgEO2rvqOms+unvaND8LdlZNxYXnNPrwTIUBwyF2oAeCRZzYmksN5Qtxk1gkjvc2x5C2doUnSVVy8OvWoAeBN3+Wp93CC5YXnK4y52FG3LJv+03z5H6gsap5qJOxAxoQLv4GM4g+FgyAhicsO+V8ySlcWsvb2/ChG8s/RghG4We4khOOyOt59axywD5sPFnuxkUj1k3HUSDgBDWrVkEzXPhy0rdzi1S8k6z5LdcNvOg9LS+jYZ/be/TD7AQsx67KOsMVR4t8E6k6PklySTbuIRIDMeP+KxnD3MiaGyYbyEFx3HzuPYE87bfoXhJxZ7fVQmLU1Ud3Jy+1VkxaPzudVY9ewzRkGIyVxBttW0afBm1t09L7fokjI7+zYDwoqMT6w+xTS9K/G9gUXEIn4YNqjsTPxPFZaJiLZ3AQQu02U4c6UwpXsJfzY4jjJFqcMVznYIE0WesMptrnc0B0TEkvHMdOQPEZzU7cd88YGu31ycCIgZUt8qFQ4jOGdGpmRjm+tmf72q6LYm+pSXf3rkDcWC8GkleF2JrLUiYOyt8TWdkcbDOdF62dD/qTSTuZQtQ8/F6x4EjSLDzJWYcp7OI8HWk/zTo7bNffAbe+sqAeraL6EgowIyce8zY4qR5/6kbisYul85w4WGdGgyRTGY+OWeYstCSM87qhgW8eSzmzWDlMepwKwOy4LlM3b2MA/ALWBeMSHlS9IlXh8xV1gTDQjiPIwucjaCFKAr1TW79iynnXv+vZPrFG2geh+0nlj7LD28u5yg+3TQ+743HxeGWjweVHdCkekc6UgVoSCRfKW7SsJdWaZxG4lqFrBvgxJKIKrz1K5WjIKInhL8QKLjKDkgYFITxpnMp/bi
 /7jBrYa2
 9vCVGgOP09sQq8yAIEWTNV2PR887RSU/svpKokJchy77k5XHd7zmkTdY3bszWy7mHI0b0qIsEf5d/Sj/i01fc58S0nnsqYt7pE2jL9nPj4DrUWoGdKcPRdagsZNKgR55VEWRcTOMC+fea0ZX6gNSAOcYwD1iuTCowaSTNLo9wCz/AyL02jJ3Lwsj3+0mQ8rwjqdwm6gmIMZHkzGBfPtMnwHmOwQ2XDy/CwCOJLfSbE5/jCVUwsM+7FcpYiijSzWEL8MXp+4G60+CIktq42dM1iDeuSe2OSOyHVbD03pjpx7Opgl6BuP+ePtO5+opXLh+ZLV1eW8A4AaUnG8hK5ptcC4XJXuYTQfvUPICgWIrBniuSfLGnYH/xAh4erZhGDwnjnBWcANvGY3kIfAc6MudiaJI3mIknlHk0OgO5V4nTf3HGsSh5SFNGy6D7HX4BDn4apmg49WVGQ+xUraC7z87yFXCMfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 8, 2026 at 2:14 PM EDT, Kairui Song wrote:
> On Sun, Aug 9, 2026 at 2:02=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
>> > From: Kairui Song <kasong@tencent.com>
>> >
>> > A folio in the swap cache cannot be split if it has a mapping (shmem).
>> > The split code only checks for this in __folio_freeze_and_split_unmapp=
ed,
>> > after the folio ref has been frozen and the NR_SHMEM_THPS/NR_FILE_THPS
>> > counters have been decremented, and returns -EINVAL without unfreezing
>> > the folio or restoring the counters. That error path is fragile: if it
>> > is ever taken, the folio is left frozen and stuck, the counters are
>> > skewed, and the VM_WARN_ON_ONCE_FOLIO would fire for a state that is
>> > actually legitimate.
>> >
>> > Check for this case up front in folio_check_splittable and return
>> > -EINVAL before any state is modified. Under DEBUG_VM, the existing
>> > "Tried to split an unsplittable folio" warning in __folio_split
>> > reports the rejection.
>>
>> Should we return -EBUSY instead? -EINVAL means the caller should not
>> split a swapcache shmem with a mapping and the caller needs to avoid
>> that. The Fixes tag tells me a caller can split a swapcache shmem with a
>> mapping, so with -EINVAL, we will want to add checks at callers to avoid
>> it from happening.
>>
>
> I can drop the Fixes tags. I meant that there is already some

If it can happen, we want to fix it.

> defensive code that trying to catch it and return -EINVAL, however,
> that defensive code itself is flawed. If this situation occurs due to
> a bug or future misuse, the flawed code will causes the folio to get
> stuck in a frozen state. The defensive code should at least not make
> things worse.
>
> Fortunately I think no one needs to split a hybrid shmem swap cache
> folio, returning -EINVAL here may help catch any potential future
> misuse.

Sounds reasonable to me.

--=20
Best Regards,
Yan, Zi



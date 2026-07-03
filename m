Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2195DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFA26B00E3; Fri,  3 Jul 2026 09:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7696B00E5; Fri,  3 Jul 2026 09:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2E96B00E7; Fri,  3 Jul 2026 09:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 497116B00E3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8FE514016E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:04 +0000 (UTC)
X-FDA: 84947594088.13.680E43C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB3D910000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S+P3ZJ08;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086482;
	b=LQT2G1mJoAGxghUaYimI3sY2kxQa/WOhXbSFvMJ27/ll8lr3Tc1vuTgx4aTXz0uV64vt5z
	Dx1wDr412y/3KKiou1x0JN4LH7mcJSMRk3rI7Rhvqc1a6H9NYBqbmBQt7giF0sFxnx9VEh
	kiMKHujbYO2GpX0GW8MWlbma7DTsBGw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJFA38cjtIJGuCrskbKyv0vfVVXn8W6YGisUZxiLLRQ=;
	b=nGcM+EY9LdqL+Pyo7GbKybfzGHlEd7JXGKbqEdcV7obWSDuHuXcPbxpZ1irQWPH4o7oo1a
	cEuuw/xMCFD3l/hItz9bFF4ypbq3scgWOlarX4xqHLRaHjxDoOerKAijJ6a+GSOpLCyFTb
	h0yNzgiGfXEl3bDtRgthbCExam2mUaE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S+P3ZJ08;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOSTYf8HjnGFl+UiJO+/E7qYeTPD7/W2VrH8sjpHHG1MLxZ+huV4gFE2FkkWv36CuiwEgIXd1xfv9VphK3xYcx7RTboV1nQX2wJbRQZ12fH+uimLki4l/2CVWE0psWdhYRCe7Fu68epQmsUNv9YbK5oCrwAvvBfileATSnA6EEwmPAkctyjOTuB+vpFN9S6oLBsQh2AKqmJT3caZMmykGXUhrMNNJB6CjueezcPqeAap/u+cAXxHkSroZqzuKhYwkiT1hu739OE+MlQr8cj/kHKYaKus94KBBS9oeucGFcPVl+ufp9u7G8YwYA47EyIqRF9KbG8EjouGQWoWHFtkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJFA38cjtIJGuCrskbKyv0vfVVXn8W6YGisUZxiLLRQ=;
 b=xOYCH8JXIg8qBXdWIcnOkHM6b/2XKmvD//4XWn3eeTi9C01ssO7j3VTIdX6FJThTFtUTLcqStUo3m2rPRGtnBeOHn2FbaZuV1cQ6XvnXDXm47eAujXSNWXKIaD2vntfnBKdoBGzwJCix0I5CdQ2legfWoX+L3JT7p9R49Xjkl0xlO4JEnCB9+k3stiLKwLAHFE4f2jrDrbaCRfp2W63HhpJYcFQtf9dlibJX/vVpWpTbJPbMRIG5tSk5eIfkT/J10OYP3185UItj99pK0OC3Nc7mAKbUYDPzyjYOyASnPPUZKnJX0oZH/XepLcTljxXOmmRhSTmRTh9XligL2Dm0ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJFA38cjtIJGuCrskbKyv0vfVVXn8W6YGisUZxiLLRQ=;
 b=S+P3ZJ08YZJ5ovpRsBlvt/RwB/CPLvQW/lSMSlVyuIjCyohmXPuH2QI3k0tZUAwtIh2BbV6zxHRV827mWiBmHL6Wj23PjhOic2IA1KgGrfsWus/WJzupeupjd4rhOsyqsjqdTL9aCdGVgZD+tGY5IP/JQWl1c6p2jV9J5EjtNj1hdGFLiWpKGiyexXvgiryYcYzGmkZc9ZOHqUIHLd06GYzW9RjwRntavgU3H3LwQf7D96irriF/D5EGd1ba+Pjg1mupbTWbM0UbpUlwxwU2JshLpmb9fA1WLO1epWmMWHj9QjI4X+1A9dP2Z2DBpQdvZJ33UVELModUdcKAFS2Xvg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:52 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 03 Jul 2026 09:47:48 -0400
Subject: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
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
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DM6PR02CA0137.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::39) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 8228ebeb-acf8-4b09-5c00-08ded909adb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	IiRq6K4WsICFgxPxWMkucMlsniyuhKTG/i2uCiR1HFIMuisbeoIHvdJboD3XnLRWkPrZj2osoVGPkg3iH9Pph8h4hpTP7dpEQHgLaQYRGP+9Al5ubdv6XE99M1pUUxtEe6cFRNGu3+DvYk2J5CRaKR3/PFb3/FT0JBvhUVlYLeOE7Sxjs8iieKf2mZf19TPR+XrfjHm4++jkfO9oDVUELw1KXcm7DD5phVCUlISIZHrrVg8th7ZcfmVWXNpgWT0JA73ePluvyK4Kz3l/pSXtM8h8M55skOYa3OPsDPV9lqn1alduCqb4W9ox+Zt30L6HFsCfiPpwtrzBuud7keTsV88/ZAeqszqeQ52IvszjB2h4bdFz7OfibnyB9EEwXFr1tdL+S3QnmxG8GuKIfXtQVgJBgndwMJ0M8p1v6JW+rjrr2rIZrEbZafQSSLP6aUzPz03ieoujLCFKjvOCDr7k9F/RIKcJfYgXG44VD6K4kerrw9v2J5XNTk4uc9qP3lzHGfmROzFP8XbCpdQqkbcAkV110PKFkOnDJQdMRMEvmgn1vj9dym6G/OCn9KzeydCcT5yeusGGSnL886C+BlxfgRWgygNKdfvlmndYMi28ymzKtyU478VLpdkg7m6TWvKHWeM6GJBcjV4BNq40VSnxQvq4u6llYHm0jaV/EFgKrgjZ2+Ymbm9Yo4a68Pp9aLoACCtDeD04LR3TvpqbBkOmEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjUzOGIyZlFCaWQrekpPM1JJWVpVMnZzbUZUcjNpbnd5RzhzL0pkMG44cWFl?=
 =?utf-8?B?Z0R5OUMyUVhZNnA5WFpMNlliVmZ1dmRXVHk4SmhlWWJ3MUdab2lIV00wM1Fy?=
 =?utf-8?B?RmQ5VzVNZGxEMTk5bFZQV2VZSy9jelpvOGlqWklteW9BT2tJSWhtamVvTXY3?=
 =?utf-8?B?UUx3VTZrQ24xa1krYmliS0xIc0l4QmVuYTRUTE1rZkttdmZFS0FRcnkyWmJN?=
 =?utf-8?B?eGR4NWM2RnBBdld2Q3BoeUdWZGlwQVlJQXZUTWlqR3lOZnlZQVNjeDNsTTUz?=
 =?utf-8?B?YVd6dENRcUt1WjlkejVHdXQ0c1U1T0s3dnpmVVg4MC85Tnpldmh0ZkFnVzhp?=
 =?utf-8?B?ZytXYXJIWEd3MUhwY3R2WXRJK01PQU91YVJ0bGY5aUJ2WXlELzNGZ0U2NFVx?=
 =?utf-8?B?OHZHZmE1dGY5OGt2WmRmK2JQbHUyTUNVcTJBS0ZBb01KZkFTMjdXVUNYODV5?=
 =?utf-8?B?dEhsRkNqbkdjMGFaREpPSzkyaUQwNlVjUm5UQWhyVHJzQlg3bnp3ejRudWxs?=
 =?utf-8?B?REJvYlVGSG9rZTBuUGV3cHI2aHhncVFuMTkyWjM3RlFibTNpZ0NtTzV6NS84?=
 =?utf-8?B?ejJuano5eVo2L1FtMlkwcFhFY1BsRXhNYnQwQ0c1elNDTmtKN1dPSmUzQkhJ?=
 =?utf-8?B?VDFWMTNZZFN1WmIvdi91MmZGNVpSSEk3TzFmYXJud3NnZEpSaWh1ODhiR3lT?=
 =?utf-8?B?QS9HMkJIY2xmNVljVHpYMm02NFhjeFZydm40U2VaR2ZQZHdnRmJ0eFFEd2p5?=
 =?utf-8?B?T0Rta3VBZHZVbXFvdkJ3M1hlVGwveDU5b3hLUnpqbjJsNkRkYjZkZmkyQ0RS?=
 =?utf-8?B?MEdwR2JybTNHczFHeTdoTlZpWnZNeTU0Zk9naEZSd2lxZ0hYUklwMWRBZzNF?=
 =?utf-8?B?MVBSblVNNXBqQ2xaNWVVUnBuWHQ0RUhTeWtsanNQUHZ6czRVeTI0elA2ZUhy?=
 =?utf-8?B?Yi8wTW95Y1pPQTV1UWFLaTZkN3hQRGR3SExUUlE2WExDZ3VxUG1hbExYdDg3?=
 =?utf-8?B?ZXVIdkJrNFE5aENqcmxoRmsxWGVqeFN4TjJFanJXOXZHL0NjTFl2RWhoQllU?=
 =?utf-8?B?dW5XYmhXU0IydnFYdFh4SWowdktTVTcyWTVyNWhFY3MxcXZBVk1RK01NOG43?=
 =?utf-8?B?UnU4QzlJTGUxRXpPVXg0WVorbHBhWm8wajBqOGt1Q3N4MGRIQVBPQVFrMmJz?=
 =?utf-8?B?alZQYmw4ZUF2dUp5M3I1Y0V4K2JFU0poR05LblRzUlFueUhONEFqMUdzSWJO?=
 =?utf-8?B?aEhUUmxOQUVCNXBVaWZGY20xYXNxcEZsSm5zYnFLUjQ3OXNSSHZlTEphdHA5?=
 =?utf-8?B?eDdINTRMdTd3Ty91ZnFkd0s0OG9wRnFsYW4vTTh3NllOS2l0STdaeVI4WVZB?=
 =?utf-8?B?WnlnYlk0ck1UWDhoNHdQZmRnYjdWRm16ZkE4b2s4VGtXTXlhRjN4aXk4YnE3?=
 =?utf-8?B?WlVLWGVSTWFkdjlmNlpQaTluUnZyTURtQnZLM2dlak9sTE1VVE9YRnc5RGdk?=
 =?utf-8?B?TGZyM1NKNUYrVm5wZzI2eHVmL1o1RlBvTWkwUTBPV2IrS29pQ1ZRcytkbkxO?=
 =?utf-8?B?VEJWMFd6UDlUb0Jud05HVVlJTDhyclFZWWRxWFowTjVXbmxUNjlLcStBQm5m?=
 =?utf-8?B?NGRDYXArVE5nbEJMRmNibnVvVzFNRm4vSkZ1UmY2YWgzNnhjaUdLK0E3R28y?=
 =?utf-8?B?OG9pZitmMm1VQXFwRnF3cHNGYWpaa0F0aS9kSndIRkdpTXVjRm9iN0hYSVJV?=
 =?utf-8?B?N1NUb01POHNVd1dWVS9mT3pUVUFqcUlPL1Vmc2szOEV0Q0RuL0dueUk5bzh4?=
 =?utf-8?B?Qk1pSFBIY2xEUm5EVUdCcmdZQjFUOU9DWU5lZUdIaUd4NlFnNXJIQTdpZU9j?=
 =?utf-8?B?ZWR4bWNUS2dUbEhJSERDSFJIakVHcVBEUTcyMk9FQXd3WkNSZDgrOGNLUmFB?=
 =?utf-8?B?c0ZSWFJSRFF2YW1tN2xsTFNWNzhMZU1NMmdRKzdwb25nQ0dqeUJtSzJMK3hC?=
 =?utf-8?B?MGkwc3UwVTRKWTE4d2hVSlRUWXVENXJvWFVRMGVXZUV5VThtTE9TV1BxaDNC?=
 =?utf-8?B?b2o2T3BLcmtlTnVHamdmMWZPeU5VYURXOW00TytBbmxJaWhoT0lpOXVMWTg5?=
 =?utf-8?B?aVpERGt6a0hpS25WRjZTc2Z0T2lnanNIUmlqTUQ4QTNTL2Vma21MZ2NZZWtl?=
 =?utf-8?B?Z3lMTnlvb3A1QzJUajFhNURnbzg4UXROSjJBbFRIZmwzZGtMZTNwWVNXbkpu?=
 =?utf-8?B?UE5GMlh1OVRjaUhnTzNPOFpUTEpWVm9paDJ0YkpGVGZLbTN1UmV4VTMvVG1H?=
 =?utf-8?Q?dSr9junXA5B6nP7zJt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8228ebeb-acf8-4b09-5c00-08ded909adb2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:52.6766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qt8K6jCWn6dj7HFw1jSf6nannWBKmjGQSOw6IupCNVn0Gv9DFuDVHs4m2B642ID9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iemzqqff776pbz8hj5q47jy8c7cq5oom
X-Rspamd-Queue-Id: EB3D910000F
X-HE-Tag: 1783086481-65894
X-HE-Meta: U2FsdGVkX1/3wX2OHRuir68Dd4MsLHqn0T7UNxUbbzAHwjwxcdyyax5bGW1z90rRJBiA3CMpAf18cK+jeGn8dc4F06TNzApEiFKSaEE5Na91QVmKn35ivX6iYm8OtxIcFKXP4535uRIbDtO7Pzy8J7NivfproeVIr5x4xdj+q9HvdpANa2g52lgjQCLFJJ/PmYg8zOm7KR1cutj/ugAZO8dMXlLXbxj3JAuXrBqXRRwTatDJ5hH8qe2urISiQSX3Kx32bxs9nz9Xzjv7hmfEAhWM5tPp6NKWmV9tZtefHE26794ma5dc4msThqBOXJUjxQFP4nOIH67xmay6MeIjDnzAGpKTQZzgII9biXqrX9/B4X2Kdgoeu8e5DM9aYeaY2Svsd2GfGgqDaeeV2PCNe/y4K5UJFo3vflVcona9OVZ+h1aslZsJYw+zsRLjRJZY1eR18Rad5S88cBmMc/zcaTGGis6QaRz/YNmgdqTzcrlUr2fdoR8qT2OYvOirFRKYCACKUWA0Os79vBLMOUR2lkvUYjw/4YuLwWXaIARvUiCLsC32faGD/caA67m0KVzsVrOXCWUT6OKxoopP2pWCL4K7ZJ/rb+c8K4TLEPlTUKi3hzJqiB29CGZecDONoEaAzdbSUpo6y3BCCzJs3gFKdaD+4jNVcht5qrevyAAacwteDN8Q0scSDzx5M6Xb/zn/ZSzPGE50pfe+MdsqJk5rbtMozsE23YBPl1Tg5a6a08OGIyveDY4nb4mLgIcyYoYU/82ttqo74wC2k7KdtEAgJQG7IhnDiwn0UIpTktyDW3aEULEexC3lv7wa7TzauaiqPC8Q4MJIAvGG1REAumn9Va7ENrAElyjvJ4IZIr8PBp6INlm/cEbQ98X7e2IEgYWv7LzyyqrZT69T/KFRUIIDexsMpFpwmhMX0apDWj7h/IvJK7CWhROcX3AVUmEnO0mYV+ouqQ69A8JdXz/iFpd
 jYvkH6Up
 8H/ZMzRbjIjTyM00sqWDms8k31b+I6JBMwYgPt0NaZBcVxcz0IDs3GqLVSCyvdVH7O0HYi1LPy8xzhebXmSn0w2kmLRNA39WmIrlJrEUKDJ7USnF/wN64tx78TMs6y2wqV/siucxnQy4VQchHxztGNJXG2lRoFlQr0uTBEqYwqI4X8Nzu4O4I7tBesa7WMro6hIn+ugbDMhKgLv7eolYkzeCCi0EAlhE/LPf5snDKxihpGGoOR0Q4z6bnLZydvGBNX30MJuFbNNMxKEVngQLrgsw8WnL6V2KZv18x1D1eDJL8fhMrY9nQ3qdyjXMGobG2OOvtuEMvEj242LHqOHxvQRr5HIO4hsuJFnt6Gl7x9p0RFvEzNay5BajFMWA9xil0KNGgU6wUReTiPh7hyigfFFNYkhKtCd/5GwWNWTZ9WVKd33wr/dXFvl+ImeDR6ESNnl6P4OvZ8n5SksM9flmv1tFkTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->private should not be set in tail pages. Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed it
without a proper reason[1]. Add it back.

Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bdd8635922f96..06d0671cff899 100644
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



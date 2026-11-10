Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0B460A261B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XoLxVpkF
Received: by kanga.kvack.org (Postfix)
	id 352F96B05BF; Tue, 10 Nov 2026 16:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A7D6B05C1; Tue, 10 Nov 2026 16:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4236B05C5; Tue, 10 Nov 2026 16:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6AA06B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:05:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 736BB140108
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:05:45 +0000 (UTC)
X-FDA: 85420441050.14.3519C0B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010007.outbound.protection.outlook.com [52.101.193.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5BE458000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:05:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XoLxVpkF;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fh4nLdYYOi6eOOFrUqaRJtPGQ1ogjFk8+bLm7C4b7oQ=;
	b=cniPX6mnjlZAqjgU7NBrYuIotm40tjdK3syEo0nevVfXImTXkWesWW1FSLI/WDgo4oXR/W
	YFrzzFsQonMISyF9qYzt/Fk5PFq+IC6PreMuLsdYgmL+5Qd1b1BdSBdAZrnTdh70LFhVy4
	dsEEPIG85rOAXQey9bQrRKnrqOchiV4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794344742;
	b=HCD9vkOrcJOA2i7rN76uDh2i1SewKaaJZmFdoVUph86GHDfFk9EajmE6w1EWyTeNFfkRls
	arI7QNJwLmCwkSMaEnHo5vzim0PozjYAIftIA+Q3AfgZtr9uc5BoBD4DwkoDTJNER+ObzJ
	jqYHbVrP4ImwNlC8Hlnk5QL07PHt3/k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XoLxVpkF;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djbu+OBkJPPpHKS5Bb3NOJYwxrPbgmdn3zFCBBHUha3u1Z7NEeRB2JQLqPkz4UnlodGg9DjsIN2F0cGw/piZ85DvYJkR6N9swEpeqIyyxtxyj5qWa+JMikNofn+azOhvuf1H2SqVvkYe2sWyU+tqEVmWTURpuoVZQpdMCFhvLPORxrAV735/biOwBBYG2xSEFXZ1JXCYg5LPC5pwnRaYHuIy8aO+dzumy9huZwpJrId0WrR6mpFZ0ckAha9qTuVH1ULCrTMUcea8NY5g5dpHpF9qzUasWG2VUEWvsYFcYa68Xtddbgvik+kFibv+Oc7axce7i11sSu4G2UCQYv5RBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fh4nLdYYOi6eOOFrUqaRJtPGQ1ogjFk8+bLm7C4b7oQ=;
 b=lUHaIQ1T7ZGHYHwWjjVBNgDNCynmU7Nx6yjvfHm5GdNTy73eGxrGq2VB4jzpXPNsJCZeEvxFZfGN7XbhD7aO0q8gcqdvXAQbsbx8yVJ+Ro3KjWq/rAakTydhxno2xJm6B+9CltpvvfRgwHAPRxkNOIMSK0wXOq6Ce3zriqRIUtg0/ZeIJ4LoUZyDhIKJXnW9Og2OZ6n4zmnIhAMIn1mwRDxKz9NA8zVObTtWmAgbJ8BR5u8lhLegoMFGw8T3YMEEcoF+cLDJK6CHdcUno5gBr56pioIfxO3AwKz6Sk+LDAQpq5Jl3xqG7p0hslpz6b23w694fISocOFwGtmpFgrZOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh4nLdYYOi6eOOFrUqaRJtPGQ1ogjFk8+bLm7C4b7oQ=;
 b=XoLxVpkFzxOHQiwFP6B8WO0IwHN+wglrZS6IjQocNOeWAP56xT2lwBu3ckCNYzl9LZ64Bduj8kSq5nmfoRGLaWyUX+5Zh54SFzitxcAuIZ0Bji2vsWKpfVfU5edAE0xBJbNkWUwvIFqdPRImgDf5xZ7vFpNMXn3ThjZtvheyZc8gO3BlVU4jd12qSKGXJJT+7b5PaDCMqWsvHMPJchS9/9qF/EOiPyzSCh0r0w6My6B+u9+gZisd/XeF6j68MoAuvojLMyCGl8tyhmVjXWuKIp8DpMScTuzveqJh+fWsu5S7AWuoLtPCzasjQ8qNCkDJBqo4YQFcuc+c+vLZW+GhjA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB7234.namprd12.prod.outlook.com (2603:10b6:510:205::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 21:05:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 21:05:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, SJ Park <sj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
Date: Tue, 10 Nov 2026 16:05:29 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <12D9952F-7AD0-4D55-8E74-603418C4C29E@nvidia.com>
In-Reply-To: <520a5027-8c46-4111-b6f5-44ee15c1a267@kernel.org>
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
 <CAJnrk1Zn4xvO2ySmmgk3vqXUKwz5TPHMWtRdKgma8icWsug9Vw@mail.gmail.com>
 <520a5027-8c46-4111-b6f5-44ee15c1a267@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:208:239::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB7234:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd2a31f-6df8-426e-a9ad-08df3f6e5a62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|261026121527099003|4143699003|56012099006|11063799006|261028144727099003|261021121427099003|261021123027099003|261022075727099003|261022115727099003|261009223027099003|261026140227099003|261102123227099003|261022105027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	dLKf91Pb96UcYTaFs6qD8yaH1Pp86u26OavkCQ3HnS7DHplAr32SKE8VKJ9oy8AXDHa8Dt8RJs9JtLuQHYnE8iPNwqO3ehKkUVdbebr7ojA+ycJDEAGRlL6JzsZ9Vt0lqL0TJ8nSK8/cR/gpXa58F34ZvkkJCkiu99/DjBL02j4/OwGw1WD2kRSszDpjz774BiqXHfpl0RKo2E5yIUSd7fPX9msCggqHYBg1WNhmiAI/65XrdcyT1yLPXs/gOhXCIaX0uDDIIqlGnQaclXNwiRtK3fMZylh/+Mlnb0306xx4dCkUtdBVha2Q7ldXBuKIPv8/CknEAEtDx0zHpjOZcOGN1efuhRoVzjQY36Reji2Wl8VR66P289KvEqGeelcHOdc7IVC4m3lEQs1IHmOE0Zv6QU3/QwryZMfo9A63zRIDCq2AvIx+rqOKiTNckJ0AFv+9R7T11W6XtQ8nY+PacVGU/ElLQEDelrNNPOUayTgy0MTFC/bVuX/Y2kpF+JNjAGWkqS4uVB8D0y/3izXdso++NuLUSk0CpSKumP/eg8+btD1SVIhKRLIC4zku1tsxicPSLELLm0Ctke3ya1HzBKUyfQMp4NARtd1DtjnJ0BkievzPgBRy2RUh0HDh7806CCBF7OE/tCzVvMOI+073qUQqC2DRN+k71gdsSGMe0NI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(261026121527099003)(4143699003)(56012099006)(11063799006)(261028144727099003)(261021121427099003)(261021123027099003)(261022075727099003)(261022115727099003)(261009223027099003)(261026140227099003)(261102123227099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUtDL1Z6RVEwZzdvVDBEOCtuQ09SY2JXME4rVzkrcFhzZDcvUmJCWnR1Sjh3?=
 =?utf-8?B?WkxLOGgyU0RBZUxpcy9pL2k1QTAvT1VKVm0wQkJkVWpJdk5WTEZiMWhyVjlk?=
 =?utf-8?B?d0pTR1AycExqRUdpaWNob2dhUE0vL2dkVGI2WmZWYlZGNWxBdkdtVWxncFlL?=
 =?utf-8?B?ZXFycDJScjRWU1p1c3JBSXgzNDNEOTRsVEp6cmowQnhxMHY5TUZySHdrby9M?=
 =?utf-8?B?KzU0MEMxNTB1V0hkb3NoaWtZTUR3MTJxd04zODhxUEdyMmN6VlRhTERqUGJs?=
 =?utf-8?B?VGwzYVNUcjVCVUtBbnVFOVZPeXRqaEF5UVNIdm02ZkRVcktzYUs2ZjFKQ1ZF?=
 =?utf-8?B?b3J5aDgxZ2F3c09sYmRCL2JKY3krZjlZZ0Nwd2lTbVoyQjZWTUxyZjkwNXdT?=
 =?utf-8?B?SUY3anhzQTk4a2I0cWhkN1krUjN2VEVERmhjcENRTWNobGZrbm1LMUttb21v?=
 =?utf-8?B?UnVhdFBlMU12QldQSzVheTFmKzBKSjhjN3ZuMWdFTUJxYkhXa3RSZnJhRmRu?=
 =?utf-8?B?YWdnWVR1bHdBNS8xWUl0Q2M5RTUwOVgyZ1YxT0pTVGFIUnk0R0hYQU9wbWRT?=
 =?utf-8?B?UFBocWJwY0d6REhpR0xKc2JLYis5bVA3R3dZTkdNUGJBYnpNUTJrWjVGZlJB?=
 =?utf-8?B?Y3ZsYm5wMDNBYjVHYlR0MDVKekFrSnlBRFhPY29ldElBREpiWXdNUDhCUzZq?=
 =?utf-8?B?Ti9SMHR5cjlWWERzVFlVWUREQXBNRXpKNFZMZUl6ekRrTjZLblhpdmZRc0lt?=
 =?utf-8?B?OGxJY3duK3p5Tmk5VHFnWVhUM2Z1VEh3ZzNEWEhtcjZ4eVdOYUJwalhDL3dL?=
 =?utf-8?B?Z3VDYmpPUm5MWk1HTXB3RkFSYy9jOUtLN0VYZWkzUGM1eFNvU1JiaWtKSGVF?=
 =?utf-8?B?MmN1KzlUMnhLMmhGZ1lXcGwyaTFqWHQzMk9ldDRNYjBYWXVHVDUxbVBFNjNS?=
 =?utf-8?B?aEl4MENlSHM4akluY1NFRlNpYmNuV2pNaHoybElQQTZLaE1UeVRXZ0RwcnFO?=
 =?utf-8?B?SEl0SEZXODFjVGVRaWc5QzY4WjY4Q2U0QUE0U2l0L0g5cStpN21lUmhkQisx?=
 =?utf-8?B?RmhJK3NNVkNQTFNKVlBhRUhIdVpMajR6bUFGdHVEZkhJQ0pOYmVMalFUL3Y0?=
 =?utf-8?B?cS9mc2szQ0l6NVhuNjN6dTJJOWI1b2dPNnkxYmhPZUZzcXo3K3NSKzl2TFA5?=
 =?utf-8?B?Uk9FNlpuS0ZCTDNXSnhETDBobHA1eTI4ZnlESHBPVGdXVS95RERwTHdINmZo?=
 =?utf-8?B?NjVzK09jN3FFWE92ajgvUkN3aE5FU1MrTGVuN1lWcUtYZ2ZYQ2pUS2tCeHBj?=
 =?utf-8?B?d3lBSVJ2eEh1THlZVDVQaUF2ckVUWm9qSnNhUWJsTjllandtZWpoZGNWc1hk?=
 =?utf-8?B?VENsS1o5OXR6M2FtQ04wZDc5YzZ5N0hQMGVhVWk0WVZOSUtDczBLbmZ1R3pU?=
 =?utf-8?B?UEVTZEFGSXNzTU5SVlpkeW5KTnNiS3VOT0p1ZHA5QVZ4SzJiSnlDUExIeHJm?=
 =?utf-8?B?UnlQV0Y2TW1YMkU3MnFyTFBLUTlxY3FzNHB5QmFIalNwc05hMEd5aFNMRFRR?=
 =?utf-8?B?UFpjZHlERGFMS3dzeXVrYUpGUkNhZTl3dGM4M3FDVE1jRTBHb21Ya0Vhb25j?=
 =?utf-8?B?Q0duWGVDdWR1MHJTNGEvdUwxN0dNNTFaNmQ2U21wME81ZmxDRUtZUmdHVXB4?=
 =?utf-8?B?OG4rUWpSa0NPNnlsd3A0NG1tRVptRGJ1UUhzVjlRcWpnNDNtMDhFQUhkbDcw?=
 =?utf-8?B?aDF1eU9aMzdJbGFRejZJRnUvZVNQV2g4RzNJVW1IN1FSK2xDSlZTVXgrWUdy?=
 =?utf-8?B?T0RvY1ZMbjNYTi9LU0JsODdPb0VSNDQ4bm9ISHVaUy9OblVsVG1CQ2owNTJ6?=
 =?utf-8?B?NUxTL2xvUW9tMHBudmxTY1ZjMzhPbWhpT0VXcjFXR2Q1T0JNcHZCRTZuNzkv?=
 =?utf-8?B?MmQzYklnUEkvL0F2V2d3OGo5U09tMlhSOHNYTDNyUEg3cExSaU1yZ1RGNUlK?=
 =?utf-8?B?c2krV2IvRzhYMDhiWFRldEkvTGhpcjFBYVQ0MGxQVStvMGs0TWN4eThpZ20w?=
 =?utf-8?B?c20vSTJhdGRjQTBRTHhDdHAxSFU3dWVKblZjMGkwbXBYSEo5OEk3bk1MWk5F?=
 =?utf-8?B?UVFoUi9oWTdkRk9wbU84Z2RVVHlvekI2UzArdVlDbUkxTVowdmxsWExEdWZE?=
 =?utf-8?B?YWN4VEhhWEF5NHFIaGc3c3BrVDdCZExFUnZxb2hXSzUvbHpZQjhObkxGTzZo?=
 =?utf-8?B?UVR2ZThob3V0TG1qRlRvZzMyRWE4cDBsWmR6WWdJaVVGVTlvUmZDTytHQVdD?=
 =?utf-8?Q?ELxWtce+DODM4jJmPb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd2a31f-6df8-426e-a9ad-08df3f6e5a62
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 21:05:30.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBA92SJS7nzgjAs0B9mA4Yjb3ebdnn/eagL/hvkdl3++r+lz7MNsF4NmaUSIniPK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7234
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9hx54syy3cpixdsoibiyjsfusqtnmh7y
X-Rspamd-Queue-Id: 5BE458000B
X-Rspam-User: 
X-HE-Tag: 1794344742-450960
X-HE-Meta: U2FsdGVkX1/OL+ozQGDjIl90QercYjwNvikNV75jTZ3uVzKfyL+5fZumE7umytiRvLa5qeHsfHLn6TOt/MEfdne9rhN2MARzWcdXweQfhyMbXzBabgFhCGaKsHyPM0dOABzmcF1VVXXRsk0nbwXF0Rl9si1bjcg/hvC6qryZBke/ob2uaeyOKENX4MpT1Riv1BL78IbuWL55jg7sQRn8/ahLyd2HKRFCMyx66DZMtd7NevoVijAfZORjMBdI6ljDZXCx6tr4qkfUFEbGeJEcaQxIoxVMVf7ih+iZbbYFbiyZ/DJ1DaghjS/VnQT5OOjxhLaaH0h3Id7gdeAbBEMbr6ehXHGwyCwW8cZUEYLLpi9QcWLdG5CHucRTP9Tj0sbvcxXn8u9PzRZVoHd70/G1CYORGG5i/ZCdeGAwjFDv7Auhsl9AVApOiYaGunFfhaqmaFNBsfahLl2XYrRUUrluqaVPNrXIS7MLc5nL23D/4Qx+6EWKsM7dAgrW5P5CyoOtO5oFJUAFta/LHaLGxe5j5AX5nnBh44Cq0WL3eX/xyxO+a+wa6gEfn43/CcOmpg6l94yyDtExQxx418M7rFEqanKL/bxevqKkOiCFQ42/3kilihj4kiHqPmI4El+PyvP6VjO4hOQi4SKklEltidb3pdc0KSd3D9j8BmmTeRLwbDgIF9mRsEQtte5lYSC9jlPi6xVZGAAAlW8Ud7af1uKRUYKCuWrxXNxy2qFJ42SAEtklJrB75QCxSGUIJb9nzVYeHPi1LNdf873R6mdKi5AkjaKiHUJFjbtxZHjSKaL1LwXMvz3W2PKvwpE4kFXRz7cZ8xci/NFMMCpBh+jA1Ahudrch+MfuKFOC14OPrtYwKf0PhAgpH7K6RGW0cGxrdscDTN7KWA5XsJupMx4yeWPMhSFt0jR7hwbzEQSEbgWfGSVLDnouiudrbej4LWbv75zn7nUBmStYMHf1PGFOMnZ
 pPL2/95s
 Z9SVGwlN5xs4oaL29bbvYembxNWfw05O4dnJy1z1vr7467U6bP7bCnmtrnF/N634wZ9iWXQN5AE5yNki4KFeXmj4lZ1Z7pg+wKJE5qCOBlncw/P27FIB7Wcsu+2/iW9fTKDevpfqd9R/R6HVpmV8jKqqpDovmcmgvhZRF1MuHEpJhbOQi2ywPpMrOJPasWY+p6dsyl4ZLoQq0J8DZ/pQjOruwOGKUS+OXguHgAl5tLVYv6LIfmfsuB0rshk9g+dP/E6yVtTCzaK68kZmzEGI+H72bxkyk9jYusG2ZKd36g0eJXZzdX6464sWxrZZ0KpmjKmV/Mt03gHMqrR6cipPd4JG0iEDAqZyMvolGzursw7yxfmtSO4xqIBdt3EmXMbGG4TsWq+XwpxFDsQa1PEO60+biOoklZ7HFZ2APG2/m1rm8TYadNgYZqPvk/OJ+QYy0cS88R9SlICVtvPEh/Tr9gTYXhnyDZTJQjPfuIbkRcsXXurOGKRZlHGa3U9npwm8wrDVd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 15:55, David Hildenbrand (Arm) wrote:

> On 11/10/26 21:21, Joanne Koong wrote:
>> On Tue, Nov 10, 2026 at 3:49=E2=80=AFAM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>
>> Hi David,
>>
>> Thanks for reviewing this.
>>
>>>>  - A folio whose split fails can later be split for no reason. If the
>>>>    split fails at folio_ref_freeze(), the folio is remapped but stays =
on
>>>>    the deferred split queue marked partially mapped. The deferred spli=
t
>>>>    shrinker then splits it without checking whether it is underused,
>>>>    breaking up a folio that is fully mapped and possibly fully in use.
>>>
>>> This is a similar problem I raised in last year's LSF/MM:
>>>
>>> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=3D&files=3DLSF_M=
M%2726_+Deferred_folio_splitting.pdf
>>
>> Awesome, I'll make sure to add in a link to this presentation in the
>> cover letter of v2.
>>
>>>
>>> "
>>> 2. THPs erroneously detected as partially-mapped
>>>  * Failing migration/split/eviction after stepwise unmap
>>>  * Remapping the folio will not fix this up
>>> "
>>>
>>> The news here is that we now copy the state to the new folio and can
>>> consequently split the new folio.
>>>
>>>
>>>>
>>>> Mappings replaced by migration entries are not really unmapped, so don=
't
>>>> queue the folio for deferred split when try_to_migrate_one() installs =
a
>>>> migration entry. Pass a flag down to __folio_remove_rmap() and have
>>>> try_to_migrate_one() clear it for those PTEs only. PTEs that it replac=
es
>>>> with a hwpoison entry or discards because they are unused are really
>>>> unmapped and keep the current behaviour, as do all other callers.
>>>>
>>>> One consequence is that if part of the folio is really unmapped while =
the
>>>> migration entries are in place, zapping the migration entries does not=
 go
>>>> through the rmap, so the folio is not marked partially mapped afterwar=
ds.
>>>> For a split this does not matter, as the folio is split anyway. For a
>>>> migrated folio it means the destination is not queued until a later un=
map
>>>> notices it, which seems preferable to queueing every migrated folio.
>>>>
>>>> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped fo=
lios")
>>>> Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on deferr=
ed split queue")
>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>> Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org/
>>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>>> ---
>>>> This bug was found by Sashiko in its review of the mTHP shrinker serie=
s
>>>> (https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/). =
The
>>>> migration / rmap code is still new to me. This patch is a fix with the=
 help of
>>>> AI, so I'd appreciate a careful look from people who know this code be=
tter.
>>>
>>> Don't we have the same problem for try_to_unmap() in some remaining cas=
es?
>>>
>>> See below.
>>>
>>>>
>>>> This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 fully=
 mapped
>>>> folios through the split_huge_pages debugfs file no longer increases
>>>> split_deferred (was +64), and migrating 64 to another node no longer l=
eaves
>>>> nr_anon_partially_mapped up (was +64). split_huge_page_test, migration=
, and
>>>> khugepaged selftests pass.
>>>>
>>>>  mm/rmap.c | 29 +++++++++++++++++++++++------
>>>>  1 file changed, 23 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index fa34e1ccbd8f..e5d17481c0c0 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *f=
olio, struct vm_area_struct *vma,
>>>> +                     /*
>>>> +                      * The folio only looks partially unmapped while=
 this PTE
>>>> +                      * holds a migration entry, which is later turne=
d back
>>>> +                      * into a mapping. Don't queue it for deferred s=
plit.
>>>> +                      */
>>>> +                     may_defer_split =3D false;
>>>>               }
>>>>
>>>>               if (unlikely(folio_test_hugetlb(folio)))
>>>>                       hugetlb_remove_rmap(folio);
>>>>               else
>>>> -                     folio_remove_rmap_pte(folio, subpage, vma);
>>>> +                     __folio_remove_rmap(folio, subpage, 1, vma,
>>>> +                                         PGTABLE_LEVEL_PTE, may_defer=
_split);
>>> We will not add such magical boolean parameters. I have a patch to just=
 pass the
>>> rmap flags for a different purpose.
>>>
>>> But the whole thing is rather ugly ...
>>>
>>>
>>> You should probably look at
>>>
>>> commit 354dffd29575cdf13154e8fb787322354aa9efc4
>>> Author: Barry Song <baohua@kernel.org>
>>> Date:   Fri Feb 14 22:30:14 2025 +1300
>>>
>>>     mm: support batched unmap for lazyfree large folios during reclamat=
ion
>>>
>>>     Currently, the PTEs and rmap of a large folio are removed one at a =
time.
>>>     This is not only slow but also causes the large folio to be unneces=
sarily
>>>     added to deferred_split, which can lead to races between the
>>>     deferred_split shrinker callback and memory reclamation.  This patc=
h
>>>     releases all PTEs and rmap entries in a batch.  Currently, it only =
handles
>>>     lazyfree large folios.
>>>
>>> Batching resolves the problem in the common case. For the remaining par=
ts, we
>>> should likely just check in the deferred split handler whether actually
>>> partially mapped to then clear the flag if not.
>>
>> This sounds great. I'll look at Barry's commit and rework this patch
>> to batch the unmap, and I'll add a patch for the check to cover the
>> edge cases.
>
> Take a look on the list, we might have already had some attempts to batch=
 in
> there (we just lacked the capacity to review them). But maybe I am daydre=
aming :)

You mean the last patch from Shivank[1].

[1] https://lore.kernel.org/all/20260813-migrate-rmap-batch-v2-7-3c5424c555=
c7@amd.com/

Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD545CDE00C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 23:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819E56B009D; Thu, 25 Jun 2026 19:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F18C6B009F; Thu, 25 Jun 2026 19:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA766B00A0; Thu, 25 Jun 2026 19:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3F76B009D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:02:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B82AF1C5DFC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:02:51 +0000 (UTC)
X-FDA: 84919961742.06.97C58F4
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id DFB3A1C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:02:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hNfkFRkn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782428569;
	b=N9Nifws2ba8GvL/+wNlD9WpEiATIsGIvCZxkd0ZAPTVR1Rss1LEtS+LNEhYjz3wZZOk/aI
	tLbp0ShHalpWzVGeg4u5NUW8/KAk7oMgeu+21dkFs58epK8ZKBkqtLxyU/I5NcqVHBkAea
	W5YDi5IvB61ScThkHA8ZW6ptEnQ0i08=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782428569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btlqMejpYBCI3bCm7VNACbgyTKCPhjjAfDklf4YdNXc=;
	b=oQgTAnWHcVUvdHuh6mKESCxZWCi5cA83il8hfIrv2qixXmZJP54ctLA5KG2HxwPZKdv15q
	AL0nmXwNv22wMhPzugcApYwWJYkFvQMngG+zBwwpcth0JRwCo7fTZmib8k5J99NWgtrSbA
	lCR1AzibR1CDvZdjtmnjjTylMAfm8nk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hNfkFRkn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3GExJVbvNk5nZQdA8f5ckrVFaBFpFiEQv15NBmrjU6uXBQhQiia76ZTg3iXEcMN1nNr0Vcq+CgEF3yG5PIoYh0qJ0ip5MVgMBSMjojiOdHLsAwQ3/hswCA2SvsLkXd1Ltko12mofxs4qVM7oDDyywCRq9IxEO2bfTALe+ZlgXXRPl+/SDFVnNOxIEz3TdC+0f/0AtexraDVINySMz65WwzNFfnC3/P3An0LeLS0NnWFwvWqm+CLPPP4aiZR6/EuxfgPcT/FTtenDoM8LrPOhHa1aI9QT6EguQIY1fFxlJ+QQ+AOBz1CeztO2l3xQcqx65Y/6afPeT0nMOmoV9TVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btlqMejpYBCI3bCm7VNACbgyTKCPhjjAfDklf4YdNXc=;
 b=uUB7/kV4yEqOdqwpxLgcXK/bpYI/Tq/bWDnlF0qM0JvLHG8vaABkJ8SUTCo4AemYppn26qxXkB6BcCl+UobjQkn6nV1s3nwQGyYtN4EGZvjAnP4+iWz51u9SqiNf/dL0KWlEY0GtkI9c6hpEQHRZT70iOf5mfcDz9uzazw3CTuBNAfzkyrOWpgHfWgUG8LDURDXGhaFVZ/yAK76px9h3tsxD7s24oFR6uPoTsKQ/P7zjL2+p+9JhtcYEIExXYuKTF15S2oOCmGgDjz5AZhWkYu1u8Q6uDN2wKZTxe8O67m4ga/z4CrDTUvwwelT6UNLOZJSDlsZOu6RJgeby6KFCsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btlqMejpYBCI3bCm7VNACbgyTKCPhjjAfDklf4YdNXc=;
 b=hNfkFRknUV7o6D4jMBBsaVa+sA/gJ1BWEgEiHDMFg2Yzbn5fe7MKCiOlB5LhA19ewh96/1iA0puaZv4uCUhNLbb49fVpzINhDXCXXz5bg2h4KKWQ0wlOH7IzY8bu/B8LxfElh7rRV/2EXqRBj5JqxgfqGaArMXuAyv8LREHRgQLdJElfiSkgtLJLGUyosNh7y0yU3yeZV20Xq10OFCow6y1CvZHT1LHMcdrwk/6UdbcNtbsU+UJjUTd3ImiDn8TpwLkP+xjzuv2LwEY0mU2U5r92Gd08VNM8XOjIjEZxz0MwQlmmdz088AOi1Oz6Y4giICG5PTe1oqSFzG7fPwqeUw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA5PPF06C91DA0C.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Thu, 25 Jun
 2026 23:02:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 23:02:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 19:02:43 -0400
Message-Id: <DJII6XRAZ7K1.26C7HGGRAE5IW@nvidia.com>
Cc: "Brendan Jackman" <brendan.jackman@linux.dev>, "Brendan Jackman"
 <jackmanb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, "Gregory Price" <gourry@gourry.net>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
X-Mailer: aerc 0.21.0
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
 <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
 <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
 <DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
 <DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
 <fbe1e70b-2a33-4db0-b390-3841c1a84522@kernel.org>
 <20260625155045.b1e2262c552e5a5e0116f884@linux-foundation.org>
In-Reply-To: <20260625155045.b1e2262c552e5a5e0116f884@linux-foundation.org>
X-ClientProxiedBy: DS7P221CA0035.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25e::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA5PPF06C91DA0C:EE_
X-MS-Office365-Filtering-Correlation-Id: ca1bf71a-d262-412b-a34c-08ded30dde35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|23010399003|1800799024|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	I1Wu8j4m8RYhoy92iJF3ng/Fax6HBi+/2s6keEM1NFHdklJDMG1RRv35BwrTXdiWdorxG72MBMmh9DUYTX9Jsg7TiPo46KSBocwO/zPn64ts6CjtbpNR2JyAC/ez+a7KHx2MYd+O5xAE79P1C26cSM5DCROdOyv4u61ZtFZeqOkdZX8lrwRbEWJ4grglxhFhq7uCWgRzfIPXEQhPERl/X1zrUzPZOL0rtADpsAadnhO9QLCMCHVeKbXilTGB8tLmbAbTmHxU/ZE4Sg4HDQfFAWN4jHn8CywNwUgOsXiyChdR+q/cqXPDFUb+2M4ceS9yomevSEFUHuO5yVFoH/kofLSPhkQ48s/r6Bl0GjAeTbEwkYTABSP9xk35RNyO1zV7coaobrsx0/HOdajP5uvU4Ny6aMqWX+omv1k/pyZJUpkBU/JAaNu1m9WUI+MKmLqqCAWbpTarKARJXyKLyTp6sMfIDW7gyh6emT43iOt+WjpAvMd7RPQ1BxsswpAc/Ge5P5Lx6gAECRjpMxm91xAtsaMRB76dsIOvJi/MyP2fl9B8SlKmOL41Xun4DMb7QSCYU45tJVLSjq9DDNC0WMj4ezbw4os0ii8NWEjFJs59JVpBwJvw14yzOIbpvfWmab9ukYqBCrfgEAaprTG5B2DCcL2Udq29saHejtLyXqUEYsA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(23010399003)(1800799024)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUpCQm9sSzdWMWFHVG02MlpnY2d3djdaVE1jQng3YWRiL2Z6cDJrZnF4a1Iy?=
 =?utf-8?B?aTE0T0k1aUYycktWeTUwRlNQTEJ1TmJRb3Y2bTBzYVErTzMyVnJjdC9Kdkxw?=
 =?utf-8?B?VG8wWWZVSld4R1ErT1RNTW8xaFFXcXdBeEJuU25lemJpNHA2U1RqTFVJNkZo?=
 =?utf-8?B?M1M0eWc2eDV3ZXJ2T2VIWVF2dms2RDNCdm9OWjg1TlhyUXI4NTlYZ2hVdUlY?=
 =?utf-8?B?a3FHYnZMWTJoLzliVU9GVGhsT0tZTlpTMmpXVG05ZWhsNFl1ZEhUVXFJclNQ?=
 =?utf-8?B?ZTREWmRRZVhEWW8ySU9WUDl4a0pGcXM3aytQWmR2am1uZThuQUhzc3I5bndT?=
 =?utf-8?B?L0lseUdYTTZIRk9EbnRHU1dORlBTMTlZcldXaUJabE1iYkFXbnp5MlNCODRP?=
 =?utf-8?B?eG4xV1pVY091Q3VaTGZLRWowekNtaFFpa2lwZjN2ZGI0WkxoZ0VlN01wS2Zs?=
 =?utf-8?B?eERlOHo2bkVaZ3ovZmVYTENJUVV3Wm9IeUV4a2REY2RsdG5sYWJHNEJUZGVm?=
 =?utf-8?B?ZWlwM0ZZT2RQaWxNdG9XaDhmUVNIUUg2YWxDNFA3MXhtWXViamVUNGVKUUVY?=
 =?utf-8?B?RGZqUVNiOVFhU2J3bDVIYXlESS9HWmQ3cGhXUHVLbkpmWkNkdmJpTFpkcERw?=
 =?utf-8?B?bU9pWmNxb1lHMDdUT096cFk5a3hpL2pTN3VvWU8yL2RacnJEQnhiTGFoVHl1?=
 =?utf-8?B?d1l5Nkx3UEpkaFRibmFidUpXWlpaK0RHTXkzbGZlcEg4ZE5vZE1IQUpWN0tr?=
 =?utf-8?B?YnpGZCsyUWRRY2VYdUVlbE1SZ21ZWWd4YmJjWG16UUwrN2lEY3pCTEJRZGp2?=
 =?utf-8?B?RFdyVTY5RmZ5L2dWTDdIMW90cUJJTGhmYVYxMndwY1ZMUjVLZTZ3ZDhnOUVl?=
 =?utf-8?B?anNWckdzY2ZzRWlORk4ya3VBc1RXUU9wc3B5N1ovbWYwdThycFdDaklTY2N2?=
 =?utf-8?B?TWl4SUVRcnJPaUNTVk5SdzdWZC8vQkd4Wi96eXlLWHh2aWVzNUN4Y0ZtWWM2?=
 =?utf-8?B?bVRhUVhTa3Ewak02T1VQcVN6NTI5SkNPRGs1Tk5Jd3I0dkN5U3ZybXhYVDB2?=
 =?utf-8?B?V05Rczg4YWkvSXloZUFHVmh5L2tpUEIxQ09kV1BaemQrK1lNNjBzOGJHdkZW?=
 =?utf-8?B?VTlsQnpkNGJ2alkvcnYzek1VN0hjYlI0NUJabXRZUUdmNVdRbEVObHhPSHZs?=
 =?utf-8?B?UzFsMlVHSU1UdWU1SkM5eE1VZ2hlMTlQQWdJRW00TWkyaWxxbUMwS1oreEJ4?=
 =?utf-8?B?cUFjMVErTEM2ajdwNXRoVTRCcldUeDB5QWJiSkVoMjVHNVhMUmt6WEhISUFO?=
 =?utf-8?B?MkgzUVZDNmNJNzNZMGZQUVJnU0JwTkFEZFBvdVJFbTc5SkM2WEhyYXoxVFQ0?=
 =?utf-8?B?a0lFZlNFMFBISWhuQ1lTZEhTQnI1ZVM1Y0krYW4xeUpqVkZ1OGhDcm0vUHk0?=
 =?utf-8?B?QmNReGdkK3ZpaVpMcG1VZml2aDJET1djbVoyb1g1MllhM3lRU2tGYTJLMWph?=
 =?utf-8?B?MjIyc085UUo0c0VHYzJ6OGJwN2YxdXZjdlhsYkJTMngzWDNaZm1UemNHeTI5?=
 =?utf-8?B?OWFCWWp5djJSQlV6RkJ2TGppRXozTGxRUFVacHNHV0dRN2ExSUt1S096N2Ra?=
 =?utf-8?B?OHlLUE9uWThwZHBuNmw3czRJMyt4eE5YTm91S2VSdzRWdDhKVmVSOGNqTmFU?=
 =?utf-8?B?SEpoallvUnJHbnQvdFdIU2lNL3k0UGUwOCtOM0JlSy81SWN1UFlUS0VuN0lh?=
 =?utf-8?B?NUF0OUNON0NWOHYyZDdzbGtkcjhjNDREekNyc0RIK0lpRGhjU3hxbzVFWUM4?=
 =?utf-8?B?S0xmTjFwamp6NHQ5MHpzSXRWaXhrTmkyVjA2VTJiVC9UL2xTWk5ZRFJHZGFl?=
 =?utf-8?B?aE15N05aZUdaS0lubFBjVmxUWE5ySWY4U004ZXQxZmJMN29OdkZNV04rQSta?=
 =?utf-8?B?TXhSUVZ6NENqVE5OWmdvSHNXaWdDRzd6NmNUNGw4ZWIwbWJOeXVZc0xvL29v?=
 =?utf-8?B?UkFEazhjUmRWNjJPSW96aGtNYU9GUGMvWHJCOTdMdTExNit4Uy9GemtXVnBH?=
 =?utf-8?B?SDJLU1duSUhFaUNtb1QreFRjbWV6TUZjcHJOZEFiZitZOTNJVHkvaENWNnNp?=
 =?utf-8?B?UFQrakVmYVQwNE9CR0pTOEozZzd3WFBFb3dpZm9jNERPYnI2YjdiUHVOVmRk?=
 =?utf-8?B?SUJnd3ZpekVwaEZ2MndaNGErcFc1UUNtWFgyTllkRHZweWJwY1VEeFN4MHhB?=
 =?utf-8?B?bWlQcjB1RlpLSitKSlppakN0K2p3cUJ3cUNJV2dQWmdzbS95cy9IUys5QmdP?=
 =?utf-8?Q?b/38OZG4b/DbnmwP6S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1bf71a-d262-412b-a34c-08ded30dde35
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 23:02:45.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TL5iWjG98uc4+phLKKv6D2OPGz7OftoZw2nGbehLdiR6Jqvl2euXHHzbapA2l0Rb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF06C91DA0C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFB3A1C0005
X-Stat-Signature: f1q7fqu3wwo184hzab4hrkjwdcimwkfq
X-HE-Tag: 1782428568-87333
X-HE-Meta: U2FsdGVkX18zgBijbelZwX29SlzO2RjywiMLFN/FWqPAANCPZMt37iKQqMG9k3zJZ3Lw7DC6GSUrkhXQGs3nFHbLtEXkG/B+9tJKwHfX0wM5D9IKev9kkDgcXaAGCZkHZBB+eWtDv9jM4lu6pIwe/9mJsLDYbVn5bjwVPS4jJbi8UVxxQqibKyYFK3cTCWnOw2hswf++x2PbDZpQ6/xzpgVqHbr4fVbpL+o2jXWsoKa1Wa+fmp5bB7Qngsd5Z4G4gdh6QFStEzLCeWTABljt4efRAzJBiqBiNv2q83JP3NVHqo5ow916g1AOILTcjnVAorm1jkwjvSmj/879AlbO1YJuQqGrhoAjdLf6P5a0bnBNAOouRGcTisZnVYWiBDbL5Oxg3uOaekqauvBqvZJs6qjeNDbLKel4AOtNUHEKgG0YU5gwDxUO2HrWPnMVWWBbAPrBjHVDmC6ZUMh9Dn2/OqDiUzvZ6FvPvkZ9VCR8nmAM5uoOHzwUc1PJyV4tumpgddY1pgtRfQaLGneRDqtkVVDI9IT2InWsLp+UyWPemHD7FXsfH7RS0ZtVvZIT2RKV2UsWuOcln56xVe+gsoXzUYKUCukNjmU5xQv2bjZYcUjK8Eqa9IKMSPZnUYqLR6YQRUBOhaTtyrZ3+REedPzFsAIDd7PNA/bfu43yzDpGoX1RmZFiwQtIR5KJhn5RtyG8GfI75lipwks9b0I5Rc2PiBAwFGrTkJc6hTU2BdwnJtYR5Q1Q2e1F7s52C2GVmkSYAKt8s/Dl59l+hKye1GBGIwEG1OUuWV6Zz4Sz+TIOfZHtqQo/POgb80kfd4yO6y9FjW+UKXjayrd2hp+YnTiBexY4Cq981ikUpRiXg6a2iSp2HWlpQ6sqjeULpMd38u+UseyCwBpbbeXmKnVvVV+1Tx4IMa73Bx6zCkW7J/gi9fUfwp55JU+QGb6eJL1zFmLq3BEAf4UEnHHwzkR2jK/
 k9b540s+
 oneNO9BUurSmewK3itbSBXbi4xLqxOhAZmAn5cM8hwoyix3u+GFpsFxa/5QmJW8bNz1uI5YKY1sat625c350nWlp3iPpzIm21wTkJ9kuc3t/VwjcJAvPkNWJnLWpryR5bJypjLeL2/g3xPChkqGRwRkY0+A//mBdwnr+0B2MA7GYKSJE2f9lB2gTF8b/7ANAF27/kTFWzs0fveFcInVYSAQFfkxwHk8AWPs3cRQDvpCNBFRmi4PyrjPDIT/6dx/E3fJlzoYmr5ByB9Mu5LDEXnYalDVN81tbZa5ZwpGyNug9W+0N2l0mXjF7+ReHTHWOrLX0PZkY7vXRJPitueULzFhT05ZD4vd+vrbM863aZ2g4xw2Ir2FXoXTrNx29GHGw+36uZx0c8lkQm6RIenrKrSEF+nRw1tudZigoI6VS/VVD1OS8oYyPRje4hIP8WOWxd2ka3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 6:50 PM EDT, Andrew Morton wrote:
> On Fri, 19 Jun 2026 16:53:41 +0200 "David Hildenbrand (Arm)" <david@kerne=
l.org> wrote:
>
>> On 6/19/26 14:34, Brendan Jackman wrote:
>> > On Fri Jun 19, 2026 at 12:27 PM UTC, Zi Yan wrote:
>> >> On Fri Jun 19, 2026 at 7:53 AM EDT, Brendan Jackman wrote:
>> >>>
>> >>> Hi Andrew,
>> >>>
>> >>> This one didn't make it into any of the latest mm-* branches, is
>> >>> anything blocked here?
>> >>
>> >> It is in the quiet period, no patch will be picked up until -rc1 is
>> >> out. If yours is not picked up then, feel free to resend it.
>> >=20
>> > Ah, I thought mm-unstable didn't care about merge windows. It got
>> > updated 2 days ago, but now I realise that's probably just coz Andrew
>> > was updating mm-stable and then rebased onto it?
>> >=20
>> > Thanks for clarifying.
>>=20
>> We're targeting for mm-unstable to only have material that is already up=
stream
>> at the end of the merge window.
>
> What they all said ;)
>
> Officially (and for good reasons) we aren't supposed to add new
> material to linux-next until -rc1 is released.
>
> mm.git has the mm-new branch which isn't included in linux-next so
> after MM is all merged up I start working through the backlog which I
> accumulated during quiet-time and merging some of it into mm-new.
>
> Backlog was ~1700 emails this time.  Most of which gets skipped for
> various reasons,
>
> This particular patch looks nice to me.  Code is cleaner and the change
> reduces page_alloc.o's .text (x86_64 defconfig) from 46571 to 46443,
> which is a good sign.  So I'll add it, along with a "needs more review"
> note.

It is actually well reviewed[1], but Brendan forgot to add tags in the
original patch.

[1] https://lore.kernel.org/all/DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev/


--=20
Best Regards,
Yan, Zi



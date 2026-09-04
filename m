Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D469C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 01:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98FBB6B0088; Thu,  3 Sep 2026 21:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967EF6B008A; Thu,  3 Sep 2026 21:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855FC6B008C; Thu,  3 Sep 2026 21:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5286B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:34:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB547406BB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:34:00 +0000 (UTC)
X-FDA: 85174358640.06.F54F60F
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF78F14000F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:33:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sARWcZ9X;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788485637;
	b=Axqqcei3cHGler0+mZGkO27guV6geqAD/C1mTxSQ7eTI7Kk5j01IPIfhrV2P76ZpLCUL+Y
	RSUq76qdcCOHIFZQS4i4vstc+yILEpjDZk/z00ySxw+fgWInsggrzs5FzWs+fTyhFAie0C
	3Pr5AEYr+utKxtYYw6Sm0WCy8U+6CRQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sARWcZ9X;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788485637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kvs2DC4PpnNTSHlKG+hkRG+tfZgOrvbvyIFVn2/Og1E=;
	b=jwZB9kUPq6zSJ3QU5rtNR8aQ9WhVAJEQkwaAvN1Z4P8cSn674WVCSlbuEWjCAprdsja/Ty
	JHGI7Z3/AzSUBP+n49NNZrKc/q54yslRu4ttYXDCcqw+d2TEVcjH1xxSjlCmUrP5JHmo+S
	2wSK2ABDmKaQ434G5x4Je5/rgZ8fve0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nBQX7ibuVjMWx6ThLgVW4Nclo4LuWy8aSjKdNhW3Xfxoq6JI5DmnwbjmLwW2iXsjjZwXozUQzuBfXXink86ExQ3ATSH3+zGG516QzxKj6g0NpTccJhMIMlKQf8CRloI4fwoPAnJBXjq+BOqbZC9Qxbvj4R+TBHUwALIILZ4FgbD1ZUIx5NxUzFzgXyYe1JFZld07vRq/+LuPTOnuWgKLx0K1+QgBl7wyL1Hwr9PLI2MCVEM7NKxfVnrIV0GnqivwxKoI4B+eFmuMUwcdagHTKMNLGqLehle3xij7gD2j2lW4Ge505uVhZudfhs9/uLZikxC1e0kJl9Xer2aTYkQaxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kvs2DC4PpnNTSHlKG+hkRG+tfZgOrvbvyIFVn2/Og1E=;
 b=gbe3ahaouVAQ/ynMhMcP5zP3yaMpu9odRD7Exi3Q+MLBaZqCGddQjHrC5gskL+x7oP1CAoH5OKu4G/A0GtDXgUJ/LTXEYwbZWoMNYQlP8dieNqOh1ouvLYOlyhtGPAAR601x+uEKYw4m9vkb7jdeRE4FItfAYycxI1Wcs0iQ1chpWP0cnrwb0vb55XWjMFXXWFqdI53GMgm5Z+xSvdRBkebmodGcZ9qJGHOg4lqU6Bp+Er/+ArTAgIy5pGe4KO3w4xK5shjdV/9yNPKzxAbkfXdjLH02eoUBmgPIrckhRVMJHra83/rsseT2fNAgW5x0f1bykwkp0WdIW/POLYTq5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kvs2DC4PpnNTSHlKG+hkRG+tfZgOrvbvyIFVn2/Og1E=;
 b=sARWcZ9XWHfp2bJClt/p4lRy3jYi2dXKU8+Qkv3Ac9uy3drl1a6abDXT3Pi0HIX6mZu+h3/0UeG2yOrSWIRablAlVukUDq/pPyLD6bnEV7o6/G9EKyRDBlwsSb3zh8eyTxZP2857x6AQeL81p/Sy47KdkfvfxeRp75CAf0y1H1KtJkaAZXPSbF4RXbYCp+IyTmXmGZjZC6CheMW5ZRtsh7zenNCcP8aBHwN/meHgBd8sUx/lDB7O5pUteMaeqVtikUmoIlvo0w1iDcGnJmt86/T4mJ03Puz404aHElLX2bpPnzauz+fNYK/9X64NYNcqk2e/eNWkRNNmwj2vWyMJQQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 01:33:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 01:33:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Sep 2026 21:33:51 -0400
Message-Id: <DL658SMH8PUM.36G5ZQK9M9RP4@nvidia.com>
Subject: Re: [PATCH] selftests/mm: remove unreachable returns after ksft
 exit helpers
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <shuah@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
 <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
 <lance.yang@linux.dev>, <usama.arif@linux.dev>
To: "Zenghui Yu" <zenghui.yu@linux.dev>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260903135251.39593-1-zenghui.yu@linux.dev>
In-Reply-To: <20260903135251.39593-1-zenghui.yu@linux.dev>
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: 50304d27-71d3-461d-e4c1-08df0a2493ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	89bSqYIsm8ud5cim8lcAEyMShGoxKIfdKztg6pyhcyt/VuRcnF4pp+NE+ZXNUIFSWPp9I7cwMjo/xLWbYIc0TfRbXOLBkHQhBAD25lF33k7/pGsys5IAb8o3Tm3fORd0j+Te/yiejb8Jk2rM2AVH2Snp5+g0x2SaLNww0DnW3rJFeZNB1W2YA4Dl4u/1x5tqSdBBDchE8/4Tm2XhyvMjEiYKBC35V/Dg1TRh4TNZ3opgpD8uPmBkQoSXDNj/Tc5Mdyne6tQgUAeuQRB7SWMZVJYVZ3TdUNVbBGPWrka4F3KuN/reOHFKe7LQ6yVrhiTXgclZ5J2YvNDdUSRDbObVfFLVjJMnFHHOpHDBouAKarC0m+fEsMHul3fDSsyGD95puCcvNaLEClOjZmbOsvGwyk+ICWS70gFuBmTYTCtxstAgVrV1AuNqIU1w1m4hzvJT2dFdxBr0YlkF4YiosLfsKrcz2TetaZbEMhmoCxSBaUa0BXslB3/HiQNYFZnbUBKZ0SjrazeCyFDGKV5YrViXwjdNFvOwmKdA7sd5RFz5TJbieR77ppoBUsLIh4M0RbJz+78Jc6jLoNuEgByD0uqgCDIx+mcPnYYqpgIwLNeU9dgm/LMBROHM4e5//BYx7sO8ku6ILU1ErDBaWFCnQOZkDK9sh5ZDVnYFW0YA+3kw268=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0I2Y3lwNmQrdVNxbUxvNmx5empPZGl5SmszQitZYXBaUEZiR0FneFlVUVNo?=
 =?utf-8?B?VGo4Zm5SNklOYWdrY1BlVGlibFZPMWpLL1JwaEhpYVR1TnNjTkFVSW1IQTJx?=
 =?utf-8?B?VS9VWkVya1U2YXAwYkNuZU1rVU5qU3hjcFR1b1AxZDVvNE1DZ3dXUDVmbDg5?=
 =?utf-8?B?WktNWmdxZXFWYzZrYTVSWW9nKzc3Q2pyWmFIQmtGVlNEU1JtSkZkNlJHMThJ?=
 =?utf-8?B?dzZkaVd5djlaQVlIL2NHOGVUakF6YnVNdjhaUVd2KzVBdDJ1VlBKZEpmOTlE?=
 =?utf-8?B?R2VFNnVQUTh1QzN6b2pqM3NyWW1La2hUaG8xVjdhYXdjMG5XN2NuZjhyc2I3?=
 =?utf-8?B?YllUV2kxemx5c3NzS0VsK3M0L3Z3aHdFSjc1clBuNzZDbzU0dmMweEtSYnFh?=
 =?utf-8?B?dUtLd2VadkliQ3QzeGQzcFkrbG1UcWNVY0VDQUtZUjJIMlZ0OGJjTUhZV3Nt?=
 =?utf-8?B?dXJ0K1QrK3c5NEt3SEpoWDNtQTY3My9WR0lWNTNjcWNocS9yem16cjRtNnEw?=
 =?utf-8?B?M0laVWR4MTBiMHpvQUZHWUpkRG80ZTlHRFk3SmNnQ1ZQOHJMVUROaE9IcytH?=
 =?utf-8?B?VExCdHNkQ1kxNFVQa1htSHFxYmtCRUZwbjhKMU1uWkZrMVVpalZMNlhnUkxO?=
 =?utf-8?B?cFlZUmxlQTNROXhkL1o3KzFVQlMzS2NYZGw5azJhajBOdlowZFR4bFJSUVVD?=
 =?utf-8?B?akNOc3FPZWVpVENzR1RmMzVISDRaejlpa0VsTFFmc1RWWDVxdGJFdmEyWkNY?=
 =?utf-8?B?MVE0S3hCQzN6YVJXUENoSkdqV2ZUR0xlZUxMQTRZSERSSFFEQ1V5Y2tCUWNW?=
 =?utf-8?B?VDhLSmR6WGgyekVzQ3VIOGdkOGdhSDlZc0FvYmFkTng1R2FBMkdhWjZJVStP?=
 =?utf-8?B?Q0JSM3IvcmRCUVowUTVmU2F4UHE1bXJ1b0djZU54amdXa29GcWJteUdRRkZl?=
 =?utf-8?B?MkE3NTBTWVRwMSt0UFBrbE55ZUdDV0NHa2dyMFk1OGJrQnNhV3RXT2Y1SWtG?=
 =?utf-8?B?eDdEeEJVZnNhdVk4WFA4WUptVSsvRFVmaEpWMGJmWGlOb3o3TUxaY3puRDNI?=
 =?utf-8?B?WDJ0RitBd1JyWnA0RFZXWmU1aDMxMFZ4ZnFOMEtRekdKTWNYN2ZhbFpuUm1Q?=
 =?utf-8?B?K05PUlQ0NytPdnBvTHdBcTNyaW9hb2NIdHZPL3dLdVVNNjYzdzBuS3hlVzlJ?=
 =?utf-8?B?WGlIZjFTMlRIYjU1Q1orQzYzZ3ZJOUpDSGJHYWRic0taWkRNejY4UEg1ak5V?=
 =?utf-8?B?T0NYRUxaQktiTWFMWXdieHBLV2RFZUVyMlQzQWJKdEQzc1VhaVFlWWJ6TTZL?=
 =?utf-8?B?Yi9mZFpCQXp2UC9NMGlLK0dQVEU5K3daQ3pyWmdJeXZlYTNHT2pFRTdwUDhm?=
 =?utf-8?B?K2hHN2FESDh3OWZsaWxrVU1TL1hCbEJJTXJlcHdYY200cW12aGpZZDl0TkNH?=
 =?utf-8?B?em4rUHpTUzdKMzZMbyt4bFZTa3VtUHdBbG82NmVXUExpcXlwamltMjV2akdV?=
 =?utf-8?B?SlJ0T21ZMjI2RkZOdXhrNXRsZUVNYVE5aW9ZZk8wdnB3V003Z2hiNWVmWHd2?=
 =?utf-8?B?cXVhNUpDWFhmanJIZU5QYllFNzVpeHZSVjNVc3JYa0VxMkpXVkR3cmNuSlIy?=
 =?utf-8?B?TWphcUlOeThrSUlzOUhod1RXNEc0SDMzK1pmcitaYXZoVGlmMFZGeXVmRUtU?=
 =?utf-8?B?elE3U3R3WG0xM2FucXhySEgxYUIwemw2cWluSkNOaHZxVk5XT3dQbXhxaW5r?=
 =?utf-8?B?NlIvL0hQaWtZRUtpOEdyTmJsK1dURE9EbElSMCtBZTlQMm5xamYwdmw5WVgz?=
 =?utf-8?B?SmhpSXZKTXo5dmMxVmtUeC91TGRlZU9qS21ENHJ4YkR6UlFaR0xEUE9BaWZx?=
 =?utf-8?B?cEo2VXJKcEFiVXhKMjRQRW9TWDNVLzFGZGgyeEE4NHBTYjhqZnF0TlZJVjlG?=
 =?utf-8?B?K0FuWmw5ZUhFWHhxWjJtSEFKMWtqYUVSeFBqd2Z0YWoyVVJwRW5nYzBFamRa?=
 =?utf-8?B?TEdqSEJoaEI4UVg2bTFNemEvMXRuZlZzWGI0Z0hMaWFiMDNGRVo5c3FwSUdI?=
 =?utf-8?B?L1BGNDhIaEN6YjExSXlnd0l3M1RJSGFsbURmTUFSYmRYdmxOTjdtMGVrR25v?=
 =?utf-8?B?ZGdUS3lBRDBhVm5za2UzeU1TQjB2RDk1bjRNWkZ0ajk3TjROMWsyUmVJL3hl?=
 =?utf-8?B?b1BSRHZmWmNSOUpiSlc4WENQWDZKeTZFTGVQOWlSaU05bnlzNzFPaWRKSXNW?=
 =?utf-8?B?WW5od1cxYW9wUUN6cHV2TmZ2TGdzc0JOYXpEVkpJOW5Qb3h1T1hQemVqMGls?=
 =?utf-8?Q?n4n0z5KmEH4MVyz8Ll?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50304d27-71d3-461d-e4c1-08df0a2493ba
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 01:33:52.4958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PK++oBuESuH3I3oskPFutiKKnUBcMW83awSg9U9NLHpMb67MPUqL0Fp0N2ZLjlPZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF78F14000F
X-Stat-Signature: 7atoe5qoe61umwye3czc419myo6bfuq7
X-HE-Tag: 1788485637-365681
X-HE-Meta: U2FsdGVkX19Idh/xT6Q1EXUJXLoYDAFHeBRVx2qc7qSH3L3dX0YfrdlT8G6qA6QhHZHVbr5U1pz2wS3iYy4nGE2NEoDj9wyEAQKmvhCYl++yNjAYOQn9xyc+B2NdK3ixxzatN38aL7rDz1Rz6nU6GTh5sYYToaOF+IIqqYfzBA9vEnSA6pfYLoVeg6ICcDDGad5U6/wD0dPX1EOfkrXuz4ouV+Dm/rJmmbdB0pnUNKcxWEHTtK0z+7GYeDyhXFnvhGRXvsh1xTp4QcyKSdciOcIM2Remhwn6DHEwnMgH89WwSb05A/d+QjJQEgTXCbY5YnJUWhw4xH8Z4S4lazLYOnAPCl0KP4MlbZJbdf+mY3D0X3zHqvXyH4tyTo5Z44vADoVkhcE/sFMPWQz8SRky0GEsLTrkOh9BexeoC+rARvpMX8v63yJASrWdbDlnX/b62Ux/H6V9VE6YUTN19CHUA2kUFwwami3VgdbqobdSv3eCg0BRc7LRbAjvXYhtdpBk9vrWKkONGMxWORiez+ISeZgJc0sYXFtjdHKNN9KRnHe5BOxyLIZ5doRoTD8XcAcUMMaVWwkF4bipyEymrEDPx/XGS+sdL/bMvzexOpbtlOWbzm29MCbhKm5mgui7n9ktCfGde5GiAKxg7u3K5+8ApmsMsF/iXBsa3VR+K1vCPUJx8gXaEEnN+AmFKfC2xVzP/TVd6waV1V7gp7+hbWGZD6IX6QWAYw6hCMe1fxo72ZpjBKc3LNXH7l9SxgAPEnestcYUFdwqWI+PDQ5WNOuAw0BOUA+pbkCGmlH+XcMpEOH/RrQT6uZOVLY91u2X3Ae8/PwVCytWU9NcO+sDpazAartRBhTCXmJxtLjBDQYJj4nnub3AQGMtcOaKS7ZZzhgf/En7eZI51hkHzbPQ9cNM5nub0TMF1PFlQkXDauhhMOFT+zzTnIamL1pQKWGuQ8Sfdagek3rWkO+MKQ3HkzR
 /TlbQE9t
 ILQIKJWryNQsGELpAoBocM3unH+Q7FVMW9cCuta6RnmRYJlafUcMwk9sFwyf8BQuK7XIBJTi6Fa3Nz4jMBa5AXoiHCFN9UA37iKnwaSPUCxbV+m96v3Rbb97lkU0okgR5/Z0qBPJgu54l2yXHpDoOH/gK829SWqkSfG9jC1Sr8q7IWDawQnpOhD6WMjMIVJw/9Oav52YEchljZ8WOn1y0ZUqsx9t80I4sKbOLQqKWrq+iAJJQAdJP3rLDsEbFcMt2es1JO6n5fdV6TqHPwHcj7lA6xOhmblgg4xxC9x52yXDz1t8PRVLqUHt/xJoRof28QO7NmNp6M28RhHo/kYdZP1gl2Sx32p7DwDFwnb1Do5vxtvapEooCOb3vdE1BZeXzI8wlfiuaaR95lEKbm/oRQkkrKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 3, 2026 at 9:52 AM EDT, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>
> The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
> __noreturn, and the ksft_exit() and ksft_finished() macros expand to call=
s
> of them, always terminating the process via exit().  Any return statement=
s
> following such calls are unreachable, both at the end of main() and on
> error paths of helper functions.
>
> Remove all of them.  No functional change.
>
> Assisted-by: GLM-5.3 OpenCode
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/folio_split_race_test.c | 2 --
>  tools/testing/selftests/mm/mlock-random-test.c     | 1 -
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 1 -
>  tools/testing/selftests/mm/split_huge_page_test.c  | 4 ----
>  4 files changed, 8 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



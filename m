Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA3BC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31D86B018B; Wed, 12 Aug 2026 22:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A6B6B0364; Wed, 12 Aug 2026 22:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8866B0365; Wed, 12 Aug 2026 22:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92986B018B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:14:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACD05A2A0D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:14:55 +0000 (UTC)
X-FDA: 85094628150.23.D3A0ED0
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB333180008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:14:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bA7Fb6g4;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786587293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PyQB4wCg5aCi5g77Qi+BZ314qUF0gDklMTrqzEnfZU=;
	b=ZI/v6q7RDfOGqaTKp4nuO6gibzI4GiQ79wGHl34aqdjt55LHl8bK2LLPNaO/D43qSX1KND
	Wt4k1ss7Ieigbs6RU6NgbKzHjIAgAeZCYcC+irz5JJ+z6j/B7hvl7EwjSY28fyp/1VFuSY
	LO/zZezF8rYABGs1TxtKm7Do1dYdPEo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786587293;
	b=tEW/zDogbwxROXGuXbBBOIPLskbyn9iPj11U9k6xwn8SdPsOqoAvipryg0y7TFGcEtSnBQ
	iR78btCywwm86fxFK4EcPZt34ppcTeKoTdZTvK9CIpbzPksY9F+ELmnYHei6CZZWeLhU9X
	uNkqC1ZQ/F3qScliW51vV7crTUFhdC4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bA7Fb6g4;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtY0Sa5BOr/WkJtixQVQpK/LFodxVCZQ5bKhhfygPUe5Mxf4/dCRwP1e/kUwoouVWbjpknXIA7qdT8Uvbbx4HWrhKiiyrtuyx4/pl77NqcS+PapHEwIW9UjxvCUybSzCpoKuXWymdTJB9Ob6X9NrQcdzuOjA+UE/24jUzIfyj7mm3CXX4k9F8jNsiEOMrugyMTrX7/YzXH1tMnml0+LAlYYTCZZKSb08dS9IDdzQjvdyoJGLEDE7dLHfUg9MD5F13G2yJ8VuW2Vh/L2Np8dKhrCeIeXMqI97nIuXoNyjNPVe+ixi/RANCfgc/U8j0T/EWWUCbsIr9gmmwZkYBiU7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PyQB4wCg5aCi5g77Qi+BZ314qUF0gDklMTrqzEnfZU=;
 b=cCqxyOH3k7vpoU08Yd3ewFcBpVeoj7Vwbdq6XW35mCOkTD5vc820idPJkUOftunmbgrB7AQ2rgemLD0gjC/1uHWmXcm7mep9hKRNJUk0hVC3DseeN5CE/Kuv14scFg9ujcCsa74BHVp3qcX/mD5TUhg2KGMNOAzud3g73LDgFlKxAZRe1+6qZFAnoG6fTvWPnAC4mgIDN33Fmhim8/TUtyCEuQmPJkQqbQjRHRMAXBMo5qQJVwiEVXXxde9YwBprNPt6fKXDuSRTT9LEMCS3bVmExosG5m68BmgUmWfPwCnO4HALgrB/mignMJkVv1sLMXHvkUW4e2Obg9lCnQxOqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PyQB4wCg5aCi5g77Qi+BZ314qUF0gDklMTrqzEnfZU=;
 b=bA7Fb6g49bTblcxc5mGfFu13P1Plwi/gUjAHutOTENiuIB3FVxDyI0RUYKmUYkJbbX6z3pbEgcJIkzhRRa3RwGFyim+dU2tiyCmhHRXFuAfvdLDqVTleiM2Hv6id9jhMQWFTi5y+YZCQtkjm1hZproXG2qkcPlcJ50CjQRQvJWWxnHKOFnWaNddJJQgXZCCRZnBBwy5W/QcbazZ1ADysJXIjniiUsrPLBS4nf8afkjYjPYT2LAryyqsmrnsBEpcCIy2tjHShAAbyAXV7v6yJCemFKvrnQ5iuY8myR0taVAvgOn+HDN0IY3sUyt9qz/tXAwXUXyy05mwhfjS4lolC/w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6210.namprd12.prod.outlook.com (2603:10b6:208:3e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 02:14:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 02:14:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Aug 2026 22:14:46 -0400
Message-Id: <DKNGC4X9V83D.268DMWU0WIILG@nvidia.com>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks
 into a helper
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan"
 <skhan@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Nico Pache (Red Hat)"
 <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
 <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
In-Reply-To: <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
X-ClientProxiedBy: MN2PR20CA0060.namprd20.prod.outlook.com
 (2603:10b6:208:235::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6210:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5022a7-6f18-46e1-2a08-08def8e0a5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|4143699003|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JpZQQuMIspgtaJj65geJAc2VMcQGr2QPR2Rzfnl6+OKgUA6zQxjgNebuLjVOgXGK+JlwiaB9y+wjKPOL4vIiKUmi/jgG7Nvl/ISTB4oeRDYb3mh/92Hbf93HFS9FYx54azJnmBiFRBxuGDA46C8aKBa2zeqE6hNr7IVgm+FKbXjNFW7/efkdwTGDOQBiu1ZZK/KkeMXJMWmKhFzLqc4ojJCklSWmXmiowsOqAuW0rTG5R5pcW4ggrN8E3KaqbYkMWojK5einopSi6hzHYUBiXdYoihN3y5c4MVsKfszuyqNo4DM4lcIT8Ptf2JLGq7F/ggF2r4VAbkvCENqTTeZSzJvk9OeBHOvP1DtFq+I057iLT0pOrxgVlppEKJesYrKOE1C2c9DX4PhIVCdM2+3p0X2EHIVi3qQFylTAJVr8AUdSwT34k0zK5ngy6Mnf3D/zU+HCGHxkvy1ZlwDyGj+O1ZUuSp2lS+N/fFb8XRXXquXoWf8IFT7pubCpeKTzWYWudgpdfcU7iqh8R8Vlh1cr/DrOhVOdefQBHVCCOPg69ujKto/jV8oampo5p471BvebyKlPIoADbO13JJkKVafaBwDKFZOUalsZyBzkbAX2lUA5Jn//jXDyTQjdp4pyMWLwkOyAy+lei1cJl01WQXblwzQBpWcXyQ6txOIXU2DtaXM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clhvVG1VNDgwZXkvTHcwbExvUzJrTjh3MDlITnRHSlloQjZ0TG9JWHkzWkRF?=
 =?utf-8?B?Wm05bklMdStYcnA3WWJ5UFovaEk3RWhUZGlDa1FTUmYvR2dFR1RxN1R3U1Zi?=
 =?utf-8?B?RzByN3FKWjBlOVYxZUZwQ0haSC9iNnRlN3pEdWFyNGx1Qy8rZU80VGFOODN0?=
 =?utf-8?B?S1FiczNXdDFpT1o1OEVFSVZwSkJoU2pXa2hlZmZYcjBJN0diZ2E2Y0tiNFRW?=
 =?utf-8?B?MkZaY1VYMmR3ZzlWR3YzY0NzaWdOMHZIZ3NLN1RCclBhbS90TTlWaWJaWUFW?=
 =?utf-8?B?Tlc3WWdYTFBaM3FOZTJ2SkdsdlBCZzhLUlFyTjRDTXprV2hXY1ZPL0RvZmhQ?=
 =?utf-8?B?SHhXNEo1c3V6eWJFWmRENTZ6cGtrdkJpRGJyQzFPckoyRG44VGNma256Ymdw?=
 =?utf-8?B?S0xnMFdaWmcrcnY2UGJ5NDNPbGF1a3dXMmFJVnp0M0lod0pSdE4zck9XUFRL?=
 =?utf-8?B?NDZoY0hrNHBZVU1hcHovaG5uNzZGd3h6c2liM04vSGhEcFNmdkRCQkhBcUhZ?=
 =?utf-8?B?Vy92dENFWmxoVGp1aEQxckx0Qy9FMHZSandFNTM1NHQ4SlAwWUdOQ0p6Z1F6?=
 =?utf-8?B?c21rUWZWRHNHS3M2SmduTmVmSWgrdStGWUVtT1JlQkRjZ2JXTUo1dk5tTnFF?=
 =?utf-8?B?em9QY1BiZm1FVDgyTEM2V0g0WTdsUEQ5ZzlvVWxHQzdBZENiRllJbS9xRVlN?=
 =?utf-8?B?ZExGSVBVbkRVaVFvZGpGci9OYjQ1RGZpQWwra2M0NDQ0RElUNTBKNXhQMGlQ?=
 =?utf-8?B?ZCtJZHlzMmJTc2RBbENTQTY2dkJ4cCtUSHBVRVFuVEdnM2podnhqK0dKR3o2?=
 =?utf-8?B?N3Rhcy9FNDk4YmxGOHU2ZXBNTVlKclpTd2RvSnYrVXhHMGVtQ0JXYlJrNkVF?=
 =?utf-8?B?emlvYmdXMnZNOG1rdVBtQXg4eUxDWFhpRXQ3OGFUdHp6UHNMaDB4RVVBN3Zr?=
 =?utf-8?B?a3FxWWpGNmsyaEtnQXlwZkhKM3VteWZLOWJqSUd3TWpwOXlzb1VzUzNJRVNT?=
 =?utf-8?B?bVhzMjVFU01BQVJCNC80MENsVXJzVlV5UGRkT0svNG5OM0VBdGYxSUZEUDFW?=
 =?utf-8?B?cEcxM05UTWNyYzgzNVBTT2dVT2hma1R0K0MyN1VucWJQY3Y3dWtidDU5OTZ2?=
 =?utf-8?B?YUFtdHFYMlZNdkVJdzBvdXl3Q1RnRHR1WlNyRzVhUkZhTWJGQzJRUnpVVlZF?=
 =?utf-8?B?WlF3YnNub0wrcGY2UE9meDdMQWhjbHVNMm1hSnRSeFRTajhMeCtCU3VRTXFp?=
 =?utf-8?B?M0NwbktuZGZlNTBqOGx3aTRwd1pqK1QvenB1dUdEYXYrUFpYVlhDamtkL25Z?=
 =?utf-8?B?ZDlNYkg4QVY5SHZTbDE2cTFGSFJLM3ZXZWNmVG5HZFV2Ymc2MVIzL0RFYVJ0?=
 =?utf-8?B?aGhQQitqb2hPSFI0VjJhbXI3V2JqRUovZHNqR0UrM2R1eHZRVjVIUHZzeUpM?=
 =?utf-8?B?T21CSk93UjhPTW4wZjFjV2NVTk1seEFoQmZGNFlkM3FLdmdWVUwxT2FjNVl6?=
 =?utf-8?B?cnlBeUI0RC9CZGZPN05xdm1sblpUL3lobW8wWFdCRlEzRjlsSUlmbFJEd2M1?=
 =?utf-8?B?QTZtNWRSUlY0dnRSRDZLVERZUkl3cXFOc25ZcUluREVQZmFkSk5HNG81RlJS?=
 =?utf-8?B?dVRzbUM3U245ZXEzK3VIS2VGRHlPbkU1cmRXU0QrdUJlM09kTVAzRk1hd01x?=
 =?utf-8?B?ZjdYY3ltWEFWVGpKMC9pajcrMC9IblJEWlZud2cycW8xM3FxK3U0VWx2azJH?=
 =?utf-8?B?UW8vd0dQVHhlcXZ6T3NJRjVNVGYxRm5QemI3OGtGeEFKcGNOZ1JzNFlZRTdC?=
 =?utf-8?B?UHNUdytia1VtOUxmdDJLNXpuRGZQeEJDZ3VPWE5HUVFxSS9UR1JDbzdGakRP?=
 =?utf-8?B?NXVNWHpGREJaa3J4ci9HMy9pcVZXVTRkODdhRGNoU3hESUt4R0oxL0dtNzRK?=
 =?utf-8?B?eUM0WlRiVmVnUXltUGJQL3VhdndkVHZkNDJub1ZWMU1Jcmw5KzZJbXJTaWZj?=
 =?utf-8?B?SnB3ekRVMGVId3ZjdGhZWXc1WnJ2VjFFYTY5elJWdDZ3SStoeHhOSmxaWGox?=
 =?utf-8?B?SWVlZk13azlIQzRuTlJVaHFiekR5cndBWHBHREVuZENqaCszekhld3NnTlVR?=
 =?utf-8?B?VzdtckZkNmRnN1Q4SGtKSlU1VWljVUJsaGJ1MDBGbWRKT2NZTExoSmpaNU4v?=
 =?utf-8?B?VEpzWmZLVWpHRWEvRUYvNzBKVVFIT2w0NktIb0o1T3BKN1c1U0FwQkpRbEll?=
 =?utf-8?B?NDNkNkl6TWNGMGJUaTk2dkpSNTJxcDQ2Z0p6d2dYV3pTSDFLQi9kY0s0Sndu?=
 =?utf-8?Q?86JBDZR9AKzS5B9P0W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5022a7-6f18-46e1-2a08-08def8e0a5f2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 02:14:47.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GLLQvi4mGlgb8WvYRpNaQvuAkRvsaJ95It/gQArYf4ER/RbI6gnLRKsN/KbYn7M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6210
X-Rspam-User: 
X-Stat-Signature: h99wu74qdzbop39arob3sdu9r7basbds
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB333180008
X-HE-Tag: 1786587292-721110
X-HE-Meta: U2FsdGVkX19JOxezZAjQCAIs17GxeZDTHwPL86utexedT8kreuqa9/Qk/tYyouQjIklxSaU85N+BlZG05Bagvj24UdcugMBMorQTc8zvfoXlUrUvGgaKdqNBrKw5ieVgKjmniG0PND/KXhg5Njb1CmxUPQyhjQvbLolmGDgl4hHbycfo+kUXXHA72LOILWUrcOimghVwEJpIJ27LeIuoFAkOh3rFfkwJrA8GVi0NXLnWHl58fTTqYcMEPzhQ3cZ/jCyXZIK1J7XAvpfRIcmMzuxoSjbCmEU2/SBtUqdL6w1PZW2lYgX0ZZJnMM54ewO1mQd9Y8ljh0Zoflic94mLZERyZc0z/kR0z0Kx6Kdf+5MlE5k9jbw2iESBya0ykgGUHWIaODi0s0p5eJPT0HHeBciCUurNo9AHP7d9+Oylq6ML0+P2xE1k6PX26Fqt/4op7NzmuBbxfRcGF4GnDzt8Es3Cue9oQDdBIuajMjNQ4vhwoKAIwfrSBR7rxp8AQjyAFLn0+UIh2XbD86s+OB7jXqduha2s65EyRRqWdZmJ6jQIWTBQOFLTr73aHobEN1nL8HoncEjR4JmbC+eDOI5mWof8Kb1jb6YMPQlO/QI0OdyaK/qFZCvRuCqOypn/hLeUD5/szIoD7Q9OfL3QRJb2zmw9oVgX0My+nPeGbQ2M6KSBNcCrdlnU1nPElrlv7R2wEb/ehnWVOhHqaOV0CWOK7dZHMXz/C18VEc27pkpZQ/2G9j/8gQckAwlFPsVpknaMQybe7FqQ/fTNH5oGjpo4IxoFdo71LYt7u3AAeuQyYyKz5WMVrvvfADuHuK94QVrpJlGZ2S/gPPRddWT/exzL1Np97FzgIz/3qzqRzDanOEzTvxA0jxUvC18GrVxczf6PmE9i5EUVuK4hxWubGP1ZtMJ4GDZmJhFG/7m9cmds6noSa9hplsiX3OaikC5Js4xdho1yrAnRDvRA83OU3LC
 GNITiL7l
 tYnzPeYcEsEVqJg6m5Xwh1OPJ05qG9VhrkHsLhVUArDyIrgVZo2tUqhbox8S3MBjgJlQ6FM6Kwz4aE2QJaogsOMaG3Eox9N6faTkHd+F/SKu0V1LqtlDhSL95GvQjkbZQF18xFuWAGCCQKgGnfySlmXl+3klPC/6jnG91beUBKjEXSWP+Pxlg1Rn4Oo+ULWy7Kkx94NcE7amcOjuyIXjUVyXinpm5AbSPqyd9rCsR8g0xOmEdpueCv3aKML99yCI16v2wRqppzxWCLrRybxfPMld92qiqjLRfX+x2/Z9Q0b/ewYh+SS/kLoHzkJxGEkfSK+O3EJ6i1MWRkSNulVYCyY+eG/dCwpacl+wOuWO7GgeAVLvHycL1hTQUjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 12, 2026 at 5:51 AM EDT, David Hildenbrand (Arm) wrote:
>> Huh, that looks odd.
>>=20
>> That should just be a VM_WARN_ON_FOLIO(true, ..) or sth like that.
>>=20
>> But in collapse_scan_pmd() that warning never existed? So this raises ey=
ebrows.
>>=20
>> [...]
>>=20
>> I'll play with it to see if we can do better and will reply here later.
>
>
> Okay, I think below is what we should do.
>
> There is one behavioral change: we now longer trace the last folio, which=
 is the right
> thing to do IMHO.
>
> And I think there is one fix we should pull out and evaluate first: A zer=
opage with a
> uffd-wp marker is not checked properly, IIUC.
>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5a06e3942e889..8a223659fce2d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -119,6 +119,18 @@ struct collapse_control {
>  	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
> =20
> +struct collapse_anon_pte_check_ctx {
> +	struct collapse_control *cc;
> +	struct vm_area_struct *vma;
> +	unsigned int order;
> +	int none_or_zero_ptes;
> +	int nonpresent_ptes;
> +	int shared_ptes;
> +	unsigned int max_ptes_none;
> +	int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -696,74 +708,104 @@ static void count_collapse_event(unsigned int orde=
r, enum vm_event_item vm_event
>  	count_mthp_stat(order, mthp_event);
>  }
> =20
> +static enum scan_result collapse_anon_pte_check(pte_t pteval,
> +		unsigned long addr, struct collapse_anon_pte_check_ctx *ctx,
> +		struct folio **foliop)
> +{
> +	*foliop =3D NULL;
> +
> +	/*
> +	 * Don't collapse if any of the small PTEs are armed with uffd
> +	 * write protection. Marking the new huge pmd as write protected
> +	 * could bring userfault messages that fall outside of the
> +	 * registered range.
> +	 */
> +	if ((pte_present(pteval) && pte_uffd(pteval)) ||
> +	    (!pte_present(pteval) && pte_swp_uffd_any(pteval)))
> +		return SCAN_PTE_UFFD;
> +
> +	if (pte_none_or_zero(pteval)) {
> +		if (++ctx->none_or_zero_ptes > ctx->max_ptes_none) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
> +					     MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +			return SCAN_EXCEED_NONE_PTE;
> +		}
> +		return SCAN_SUCCEED;
> +	}
> +	if (!pte_present(pteval)) {
> +		if (ctx->max_ptes_swap < 0)
> +			return SCAN_PTE_NON_PRESENT;
> +		if (++ctx->nonpresent_ptes > ctx->max_ptes_swap) {

So max_ptes_swap is actually max_ptes_nonpresent. But due to
khugepaged's max_ptes_swap config name, we just keep the variable and
related function names that way?


> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
> +					     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +			return SCAN_EXCEED_SWAP_PTE;
> +		}
> +		return SCAN_SUCCEED;
> +	}
> +
> +	*foliop =3D vm_normal_folio(ctx->vma, addr, pteval);
> +	if (unlikely(!*foliop) || unlikely(folio_is_zone_device(*foliop)))
> +		return SCAN_PAGE_NULL;
> +
> +	/*
> +	 * If the vma has the VM_DROPPABLE flag, the collapse will
> +	 * preserve the lazyfree property without needing to skip.
> +	 */
> +	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
> +	    folio_test_lazyfree(*foliop) && !pte_dirty(pteval))
> +		return SCAN_PAGE_LAZYFREE;
> +
> +	if (!folio_test_anon(*foliop))
> +		return SCAN_PAGE_ANON;
> +
> +	if (folio_maybe_mapped_shared(*foliop)) {
> +		/*
> +		 * TODO: Support shared pages without leading to further
> +		 * mTHP collapses. Currently bringing in new pages via
> +		 * shared may cause a future higher order collapse on a
> +		 * rescan of the same range.
> +		 */
> +		if (++ctx->shared_ptes > ctx->max_ptes_shared) {
> +			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
> +					     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +			return SCAN_EXCEED_SHARED_PTE;
> +		}
> +	}
> +
> +	return SCAN_SUCCEED;
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_stru=
ct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
>  {

<snip>

> +		result =3D collapse_anon_pte_check(pteval, addr, &ctx, &folio);
> +		if (result !=3D SCAN_SUCCEED) {
> +			VM_WARN_ON_ONCE(result =3D=3D SCAN_PAGE_ANON);
>  			goto out;
>  		}
> +		if (!folio)
> +			continue;

SCAN_SUCCEED + folio !=3D NULL means to proceed with the pte, while
SCAN_SUCCEED + folio =3D=3D NULL means to skip the pte.

collapse_anon_pte_check() probably needs to document this? Yes, it is
straightforward at the call sites, since without a folio the following
code cannot be executed. Or you think that is self-documented.



--=20
Best Regards,
Yan, Zi



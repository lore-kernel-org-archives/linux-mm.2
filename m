Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E048C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E216B00A6; Tue, 30 Jun 2026 21:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF106B00A8; Tue, 30 Jun 2026 21:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60E66B00A9; Tue, 30 Jun 2026 21:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE406B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:52:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05599C0BE4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:52:43 +0000 (UTC)
X-FDA: 84938533806.09.7A535EF
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E47A40005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:52:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VpAoAlDb;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782870760;
	b=IDDYgNltzJzzzA/9/KAgvPxtgfFgE5Muf8oVWJUlGaD7J/r3rI9M6U2ztSJUQqZEFers26
	tyELuGSStg6+GPEoyxbhaxde4rHoRIcLrZs2QzjTz7sxiqmArton2a/FU9z/2/OoX1iefM
	9ctvnHgWNlWTET5IIsBBOu60ZRl0GxU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782870760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZiuWKFL8UM15C7ziMPodoCoPhhXQEiWgX8zQTIADIA=;
	b=3yuZ6MyaaTG7aiZS1tuijevPQmMCglU0Oo5gBxP25CTLYep59naPJrGGk7PVs4ihwQO8+e
	fTO0BqN1bogGUZuU1cLWeLrRiOeOmNws74SztKNRcuqd3ppnOY84RFudsz8P3A6pCaKK88
	naVyD5fGMZ648uFcgzq9WJs5dpAL9XI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VpAoAlDb;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSlWi1FyKX+x7N3cBmwqg7sXupJtR1fMFInwpzbhomk6z4bhNw9442K+s0X/aGIGINNxOH85ko8WH5wLNwgeQaf+T9LnIlpB+FNJ74Ava29klorE1M0aIas6Bsyh+fWzGDMNDQ8GTNJe3lMm9ga8IwJwNgnGt2/p3AVXfQq/iQmiWd16DDeyZGs6btsfi93VYUmp/4hNCPB8w4ZsJoQMJXKe0E6byDhM7wPjHVXM+BIz66Psdv8tJa6RqV93UZfi7pmUCRiWlFX3qCb8hnoKw6c433vCJANFAHo2ujOucfsJBXZlAL7VmUhn/dlQD8pZq7hzj9G6Z4ifQppry4u1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZiuWKFL8UM15C7ziMPodoCoPhhXQEiWgX8zQTIADIA=;
 b=V569zNvpPgnomCKRe4c+eoqguLx9i4HjViBNb96KwOfmVM8iu+W2OtChN6JIkPxm+UljTm/qv5Se1dluUYtGrMngCnQ0QKjzhX2eXuKALts/jnqHVkNYeESftAcpftDbOLC9j7kzqPQKeYSqEKJ7kdgTTbjqZJpbTZdLdrYHP0bG75QqMshKo1FFeNv77zsHdg/ZQkvBZs6E/a9Bw4ynpafHGtkr5oqADPYe0qfAb2BQSl76kz26bYyk9hP95RHfxmTjk9AhZr9vGs2WZfs7OQd1e+/IsquRYiZMKVbNL4rdFhiG6Om7g+VU+l7Evv2sZ8rVwuFw9d6rHVI/izdI3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZiuWKFL8UM15C7ziMPodoCoPhhXQEiWgX8zQTIADIA=;
 b=VpAoAlDb0/zFfsAcebyhqSPr2JsAguCBfctd8D/OVwpzE9syWjcy+umvnT0jx4kCQLEfo/KI0LY/mJEVUxhxbpxjmgwz6A3muAU5TNRTyOY3dwg5Fp+wOv0getjNuRCiKjQLK2cb0w2O6rVIGCi7SCe8v+n2ENbjdt37TY9lcLDetUPWYKZK52AaMEKASakHbj2K3VqkmU2f+TjT6fYhAwrHd1r7TIesMSLR7t4hoKQXlpQe6Lh6b0M7FxHb6V5UhNtBToZStgHAZIrQ0Xp29/rk3uFQkq3lekojJ8lOqkeW2KTAPdtFQ8YRnhKymcD5S513yv9hRuFnAnHaB1u/lQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 01:52:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 01:52:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 21:52:33 -0400
Message-Id: <DJMUXP39GQDH.1H6FYYIOC7TNM@nvidia.com>
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand"
 <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Brendan Jackman" <jackmanb@google.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
 <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
 <DJMAWIOIOII3.24TMC6HTPXA7C@linux.dev>
 <97e35cad-20f8-46cf-ae37-18fecb978e2f@linux.dev>
In-Reply-To: <97e35cad-20f8-46cf-ae37-18fecb978e2f@linux.dev>
X-ClientProxiedBy: MN2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:208:23e::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 898b7ab5-6a7f-4917-586a-08ded7136bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UqSAtv6h+PMFY2VSfK7Dyq0LSLb6FW7W/2F5GAYT21MgsctfhUfCRUodiAKzBjwhZqtTgUfofxKvj43/ysePd/ZoXE5ePQkmXRJFZSioYCIbK7MSE0YC5hg7gnpLQ+KTk6wqAHs3mocj2etjZ9hyeJasYU5EowVXVygMLfBqIBUy07GAqWy/Q4ReiLTbV0b0QLmY5Hnf+99y/QABPUMo7z+yE01ZMWYYKWhE0K6Lud4PeSbGZOP/GnsRv0ohHTc4cM19eNsJG9AURgswkHsXXX7ayQX/jqrXGDXQuR90U73jBXdfHBDEUPCggEox9uUjH4vwa4GZTtBw1gmal+SlW1VVKoLH+0S5DoYJ1WvX9l9OP12lXYCk60fJbD2U8OAruEEhpBI9v7NGYYq/PAKL4E5bezOVkm1IrIH5g5ECUXN+lJwafaN6sYPYlL2n2FtsV8iG6x8/sae76dCYKeyQZBt2pIm2yGzpSDO5oVb5ozYSbA5+MU+IABxUCvnzHQHH9QTGvdDhqWf5XfvDItha+Pf3WyHms1l3SALJ7MwTzCq2WbF2OWsvQASHVY+FKNWn8r6/Z/0sl5LN7pLIn/wCoPL+pSIkzHO6+n+eWvv4zfTy0QfjukyOvI8Gz+HYIHC7Xixl7f5nLk5GIqIqdDVrxEPzWaX5CRhOBsBgSsgX2P4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm1DLzhiNUxnSlNwM0RBRGdlTlNXaFgzU3kzZ0pVSFhnQTRlV2xWcU96UWow?=
 =?utf-8?B?d2lvdmtvSDdEU3Zrb0lsbHFTNGpmanR0MXkyaXVZWDU4M0cvakxhQmhGWWVC?=
 =?utf-8?B?aGZ0L0F1M0lGcEQzeFRNVm1uc2ZGS1pBZEVoUGFlalgwNkpjZityd3U4Q1la?=
 =?utf-8?B?Ui9nSGhjOTdseHp5ZXJTTHN5OUE0aTdPVTB1bFkzN1QzT2QrYXJOdzhENDIx?=
 =?utf-8?B?cDNMdzEvbDVqb3UxTEdLc2RGZjVvZlhWZW45cWp3L2pDdkRPMTJNY203NUxP?=
 =?utf-8?B?Y0I4K1lEbHRZVnY1Z05YWmJ5RUpxdm5OY1VzTVNacHF5OXZUbzRQL0NERHdE?=
 =?utf-8?B?RjUxVVM4NlJRV3FBTUxPb21uZ0s2c0Z6QjVoSG1HUVR2SlJ1OVJDM1hTNFJi?=
 =?utf-8?B?eDRTeTdSNG5VbDNvdWxtRE1HMnFkUmYxWTBBdzFFNmNEaWpFc29yZnkyZ3gy?=
 =?utf-8?B?Y1dHUGFCYWFkUDNUSWVpWU1KditmTFJvY3E3dks0NEtlT0h0QnNlYWFqNmV5?=
 =?utf-8?B?WW80Qko5SHkzR05zV2pVMjBTQ1F6cXNWRzFzMXRoSkV5d1pCKzg0aFZlVzVM?=
 =?utf-8?B?dmFtVE5WUDBuckhwYjhaUUFaN0tyUW1RSmExaWIzYTFMa1BmSjZoRXRIbXBE?=
 =?utf-8?B?eDRoOEYrQ0xyU3FGTmJqaHIyRXFZM1dOMm9QSGgyMWk4eE5tZEJMM05rdEFz?=
 =?utf-8?B?dWdyODJmbDlrbWFVYkFRQjNuNU1Ld2FsN2lZZWNwTTJoWFVPS0xIUFpiOWdx?=
 =?utf-8?B?c2VET3lGbWVDRlNOTWNoZXNyQnNIQ3ZteWw5c05ZdXc2YzNGNkgzNm56VEFj?=
 =?utf-8?B?ejVYNC9CUmEwaUJIdCs5WURqOTM3ZDNKUXJpZVpTaFQ2cW5IY3hicS9KWERa?=
 =?utf-8?B?TDVwbWppWU45MkFraVFQanVKMWpHaWdBYzh4T2p5RUlMNElSZmJsWTJxT0s2?=
 =?utf-8?B?UEErb20zbDBOcDBZNEEyVTc1b1JQS1RldnMyVFRVYnlIYmpxeDBodGNpTmNH?=
 =?utf-8?B?R1p3b1U1Wm5pckRKUTV6Mnl4bE4vbHpmYUdTTUJ4NEZuMFJqOTdleGZDY25Z?=
 =?utf-8?B?S1NSdElvNVBEeFE5YTZlNFhHVlo2M3BJWmR2WGJMNkUzOC9mWlJZUVlyYmVn?=
 =?utf-8?B?MDFMeTNJa2tIRGJkRFliWjVOaEdzeEdQRnoyMGNYN3AzcVZzQ1p4cFJLZVhp?=
 =?utf-8?B?czVrQ1lNb052cHBSK2VqVTcyTjladU9GRUxrdXFBV3lKcUJGalVXVzdUcEtE?=
 =?utf-8?B?bCtXMEtuY05TOU1MUTNTM3RFTnFqZjhSMDhmRm83Y1VMbDI0a1RRdzBTZzlC?=
 =?utf-8?B?ZllvRjVpK2t1eE1vaWVrdjBobGhnN2tUVFRtYks1VXlpbkc5S0pucjMzdXhO?=
 =?utf-8?B?eXk1alBwcUZFb3BmZGs0emRaM1V4ZE9EbEIyYjI3ZDRZMmxCVDlhRVdwMG5t?=
 =?utf-8?B?L0taQVN3aG5aV3hpSzVGT0U1cDZmNGNOQlk4S0NpeUdkelNpdERXcUordnNu?=
 =?utf-8?B?M3c3WEVjZ1FMZ3RvM2pxdENJdDlKcC9pUTkwTzhiaUNmNGV3QkVEaS9xMmdo?=
 =?utf-8?B?UHJCNTdYajNFOXI3aGRLT2FMMzYzRUVqdGtWMFgwbVZqdlg5ckI4YWhjY3M2?=
 =?utf-8?B?L0RLMzNvZCtKelpsVjQ3RGpqTDUrMHRjVUhId1M5N3BaRTFEVmx3VXAxOGxD?=
 =?utf-8?B?bjZLYmIvc1hyK3hoNlpkRzNEWE16UGpjT0RaMVhEU0s3TlY5aEJsT1dQU3Y3?=
 =?utf-8?B?UGlrR3hNM240MXA2UElac0xqNTcyRkRvRlBVb1J6MmNUelpHdE96TVRXbmRX?=
 =?utf-8?B?WGhUc0pPRGxtNWNEVzUxaGRPRjlHemNLZlpkeEphYWwrb3NrYStIcTRlVWV2?=
 =?utf-8?B?b0FyNlJJMDNZRnJvSEFMVzREc2o5S3RzdnJKdFhhR016T3B1ZEF0NC9BQ2V6?=
 =?utf-8?B?ODNoamtSU3Fvck5VSHZyMjR3cTRURTRNckVoRWRTMzlEK1JOaWlHcVpSQWVI?=
 =?utf-8?B?NG5jK2k1TVQvRDBhWUU3Z08rMllMNUQ5eWxpa0xQQmJacHFDeXQ2ZU9xL0pl?=
 =?utf-8?B?bTRCRlV6blJJTWhYRWVZa21Gb25rc293SzB5ME9Uc0dSWFMrQnZjeDFHekRo?=
 =?utf-8?B?WndaUk1iQzZQdlNlQzNQTHVReTUvdUIxMnNSS3lOOGxUUGFsZTlWSmhTVlBM?=
 =?utf-8?B?alBNRVRCYmJUWkF3VyswMmo4eTRURDQ3WGd2b0tNTTZvSTdlbFo2MUJVQ3N2?=
 =?utf-8?B?UkZJS3UybmdwUVFxVkpjSWtQSnFTbTc1SHl0OEJKNC9pM3A0T3VTSUh5OGZB?=
 =?utf-8?Q?JWKQMlh5DCtbF6mgI2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898b7ab5-6a7f-4917-586a-08ded7136bfb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 01:52:35.0878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04uex6MBE9a9+dKlxGmotYfuUAU22LUeLk2sptHEFJTfhsiNG2fIo5WceyITV9Z1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907
X-Rspamd-Queue-Id: 0E47A40005
X-Stat-Signature: nywktazjdozamjnmhcwkhn3w1xjhwxfj
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782870759-783329
X-HE-Meta: U2FsdGVkX1/uNPToCNjdM1sCnL7TpAO17jAW8d2+wLfwMyuPt4GlslJQSizz0QCCMweYK0tlhNVBZYWMp2fDE35l04PujPFuS7+QTJ0rTlqR6aO0JEj3U+LQITcfIzurTs/KQ/SY/sOnip69ZghnInjLWMyS5++m+ljInKTidZks10RWod0r648UVzJxs2jI+AiNRe+42KbJ+6KASk4lY2eWMqSPjhl07hRCWiV98XyChAM4fiPaApLnsJpvEwcVdjEqbRdPTDYQ/W/4XEd1BKArfe5tAcGP2j/nLed9Y03/BNFMQEBD7G3+SICDLmbMHe2jcoU0vOG4UbZsM8OiaFhbWLR8A3Xg9zNgRlpWuFOvY07f52wPCKgTnN4Qs8W2YuAIcD2BUHsHhS1A3HA/qhELnDeo7p2eq4lPy3MTxtTOX6qSiymYg/ObuM5vc64+EAn8tXfmpVo7hwpr+lPfbq0hJ18mukrqkjs84deKy8VoMtKpQvydnGu/e4z0so+Gd8uaLJFaZ8mPbBxq63QQw3UeAoEMBzbu/rT9U7edsBNURFIAup47loh49/562WFA7lSQAkxRUV9yr90gu+Fg5bE5fww4kFADFiK/iqP8H4FvM5jINaJIEE/sKbSHm8yfppV+rgIki+7YPTjvVuLXRiFTHLxw2nnYSq0lIiiPWIChxukLalFTfwrk/OJcZVBhHvlviwyJjYwme+7tip6HiNw2gz6jPqrhEZsXELjuPpWH8iRCow35D5nTYry8jIpDWMRTY2d2vaiqoBFxUJ+E+5geDfHz4CMdUJZ0AfMc1PX9hkig5xJqzjU1pAKMzniUOMJa/kSwakZg8WQ49HFnERv9ulKxJOp9AGry3jDNR9RWgUedCn7KTMdRAzh0B7dSYNZ8F3DSsRIpRwIbSXvmjOuVCMm8HUDmQYM9IXVo9ZA+S93mrLLtkVRebdi7WPq7swUGwJGS6ggN1mQZXUL
 nzzpZTc9
 lcJC+EDVjRuLYNz67dP+cb5x9cZLS7K2Vw7SkblKayVZEUjbBxTaliDb9tXD7gtWwtSj28ajzrAgs59vmHo6pcvh3Rpxk4s+9pp/jGxuYSJ5Unk2qVjpGilSxN8KGEvdXv6/l/81jGcvSFYxM1jMc5YIGkGGfBcmb/cCjhrr94nMJLaDrDWzAq8NUz2hz9cgYndTPgFJGg5M9Vju48DHxqI3+t2+FvpLaSdZidXek2D7Dz1DHIrskpCVg0Fe66K+ecOxDx6x+Zt8bql5PYZ5tufb2qV1n+O3CDNHsXQzH15Zdwm52zBK0c1ZqzRxB/rjCmD2FRL/RvVw0jhm0VuXmX0vYxHcLUnXogznGiMxktIGW39U8/iq7xs6emElCSTKK/qldyeo8uApF3dC6scolrfCKAQBgWOpuM73683mfmmptrAm5HzWw+ug06YXwtUnNMV8+RSM/r1FHMtDXbB96LG8RNtToXKBPixG5uTqcbNgeOnQM4Yr1Lvs4OZ+NLLMGBryUdP1nikY6P52jmapgCDMLj4Cv6X4b+/+e8hLa0WY1G9kt85vJKkxRh/SONxt37Blw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 9:47 PM EDT, Hao Ge wrote:
> Hi Brendan
>
>
> On 2026/6/30 18:10, Brendan Jackman wrote:
>> On Tue Jun 30, 2026 at 1:55 AM UTC, Hao Ge wrote:
>>> Hi Brendan
>>>
>>>
>>> On 2026/6/29 21:12, Brendan Jackman wrote:
>>>> Now that alloc_pages has an entrypoint that allows passing alloc_flags=
,
>>>> we can take advantage of this to start removing GFP flags that are onl=
y
>>>> used for mm-internal stuff.
>>>>
>>>> This requires also plumbing the alloc_flags into some more of the
>>>> allocator code, in particular __alloc_pages[_noprof]() gets an
>>>> alloc_flags arg to go along with its callees, and we now need to pass
>>>> those flags deeper into the allocator so they can reach the alloc_tag
>>>> code.
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>> ---
>>>>    mm/alloc_tag.c       | 22 ++++++----------------
>>>>    mm/compaction.c      |  4 ++--
>>>>    mm/internal.h        |  1 -
>>>>    mm/page_alloc.c      | 42 ++++++++++++++++++++++++-----------------=
-
>>>>    mm/page_alloc.h      | 17 +++++++++++++++--
>>>>    mm/page_frag_cache.c |  4 ++--
>>>>    6 files changed, 49 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>>> index d9be1cf5187d9..a32a94e759b94 100644
>>>> --- a/mm/alloc_tag.c
>>>> +++ b/mm/alloc_tag.c
>>>> @@ -15,6 +15,8 @@
>>>>    #include <linux/vmalloc.h>
>>>>    #include <linux/kmemleak.h>
>>>>   =20
>>>> +#include "internal.h"
>>>
>>> Should we include page_alloc.h here, as we call __alloc_pages later in
>>> this file?
>> Yeah, there are a few build failures due to me not doing a broad enough
>> build. From now on I will just wait for allmodconfig instead of trying
>> to be clever with my build tests, sorry about this.
>
>
> No worries at all. For the alloc_tag build error, it depends on whether
>
> CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
>
>
>> Also, this suggests that I have not actually re-tested the alloc_tag
>> code since v3 so I must repeat the test described in my cover letter (I
>> just manually enable the feature and check the kernel boots) for v4.
>>
>
> Thanks a lot for your work. I merged your patch locally via my=20
> automation bot,
>
> and verified the basic functionality of alloc_tag.
>
> The alloc_tag feature works well so far.
>
>
> By the way, you may need to rebase your patchset on top of mm-new.
>
> This patch has been merged into mm-new and will cause a minor conflict,
>
> assuming the mm-new tree has not made further modifications to this patch=
:
>
> https://lore.kernel.org/all/20260629-free-pfn-on-alloc-contig-range-error=
-path-v1-1-496ff9ca22db@nvidia.com/

Do not worry about it. Based on the feedback, it might be
dropped/rewritten soon. :)

--=20
Best Regards,
Yan, Zi



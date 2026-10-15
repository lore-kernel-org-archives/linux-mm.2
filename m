Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0840CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB236B0088; Thu, 15 Oct 2026 14:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875156B008A; Thu, 15 Oct 2026 14:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEC06B008C; Thu, 15 Oct 2026 14:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 374446B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEE1DC050D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:24 +0000 (UTC)
X-FDA: 85325657928.04.2F687E6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id C593AC0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ppVv/hww";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r62QDxJjs/bZ6HRi8QX1jsoxB9gTi5DuKimgnnCtrfg=;
	b=BJpuCcSNWvaljCzg1bk6O9aWmbqTgEr/i9Q0tDNvRAaKw9KCk5fTmvSflBgfg5K7vPQbxL
	0S4sIOCKMoHVtz/uuafTY84sji4XdYvaa0peJc1TCkVW4ziWvLYr8BezzoFzBwdj7SqeVz
	B89kX+hkudzTmPvlI6hLw9ZCsSgMQQA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ppVv/hww";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088001;
	b=wJooF5225RF8BCbzpKqH5G+zUwZhYrVZ1DmTMy0pScQJ8jJ4AlFMG6+THYiW1mzpUGbXMb
	ir6GazyJKRkxs3WpF071n7tVs/JwNAx69eiXF92yysmiQnT8Ehet67y0oUGkxoKMhX559O
	LTpyn3UJwJhHkMUR7MHLdxXb/6ylas8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xdRq4ZnwxAHr1sytVPALh3vwbuu1OHbIIe4s8iC3hIPdoGtdIMiyB/SesB+DcqqftZwAIHfoOLaElrcTvFTKG7ZI6Z8NsikGpuPzNIXadR3prnfwKHXN24D9xJ3FMpBgPalULmmQ9X/20+QgWz1ZXp4/mYGJWhI6h/LFQf4Nq6Bcqy0LBE5CTHMV4CRIUXUF+e+eS4E+GOgUr6M6cl+Q+SymClZlrykEpVUP6Vo1EwDQ4oI/wumJelZRarcQpRj2VxIksJFAEwQ2nkLWNV/7cAzgzcafjOLq1wq4mPYu94OpxOLRaCztY8l63Jdx5v7g/chsuikYieRrpMwQZZtK1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r62QDxJjs/bZ6HRi8QX1jsoxB9gTi5DuKimgnnCtrfg=;
 b=uTQjX51uxUF50lcmFg38JhUX6ZzklYX/yfigTLa+Dyju8Kn2lSmj6/8LY4lrmA7YpwbvsNi+d/zdB/kYgQ3L9ZV4nrxdkYrGp12pcIczwGpqALjp0X+01nhrNCCTW7EWXO9eFcfSbM4OkWHnjhzCuCf+oJFOwXXq7nhSAGVDcr72M+Vo0dV4gaAF5YJjdAU8pPU68eDfLt/WWzwN20UuII1fvHffeJvQjALIZoDrwLj7cOkVk3OFoFd7W0YucK9jYC/20LFLRTdQ/zyGhKi/uFrZ+cDm0rMM9HL5702MiLwBS1GOc4Vb3u8bzWLUI8hodn71OSbFdyR1v432MBryFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r62QDxJjs/bZ6HRi8QX1jsoxB9gTi5DuKimgnnCtrfg=;
 b=ppVv/hwwnXK8/0uHhEpjoycrYUVu4SlV2AfZVYffJKkLIdP1iVNTW/Z+H4luPliTPb/vy4t2WwSxqVj2HF8f9dvXK3nAtGObQe0UJ6Q9BOmWhyOFv4eV0LOCOd0yiK3/GB09tWc+bskQogo/gpIPpS+NPl6L15F/1syPFnGg9NmCu3tEn+T4mdqs/H89amP7mKzJjfxtjlSFamfAeGUrgTKcCYQIt8yMngK2E3AjCIO/daId2malEhM/n5L/1bwPE9g1POPi6i9mQboO36OwNzpIi3XHuUW2XstpkMJMGS+5EWuHvZ+IreOm63Af7gw4zvrNtzYYanGttATCIftqnQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:09 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH for 7.4-rc2+ 0/7] Re-enable discarding lazyfree THPs at PMD
 level
Date: Thu, 15 Oct 2026 14:13:00 -0400
Message-Id: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2N3QoCIRCFX0XmtgyVSOhVYpFJxzJIa1yXhWXfP
 Wu7PH/fWaASJ6pwFgswTammkrvQewH+jvlGMoWuwShz0kpZiblkNz3RNYwuplmSRe+DDoZIQ5+
 9mLr9Q14gFhb2cJTszQ6GLa3t+iA/fqn/PtO79edxGw3r+gFYzlxJlwAAAA==
X-Change-ID: 20261007-anon_vma_uaf_fix-e7accd1d2ee1
To: David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Kyle Zeng <kylebot@openai.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
 Rohan McLure <rmclure@linux.ibm.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-riscv@lists.infradead.org, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: c99581a8-91b0-46ef-3379-08df2ae7f7c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sR8jpc59mlpQ7HBJZQv6JaVxJHX+PXyfkTvtIETSzZelMVNxSVeAkS41diswnPgBRl1iFO7zFdtDesslk6HiTx7b61xnzob/qnxseD6J8k0SdmJZYrQOf2Sh2ERjMasGJ7GSIFhQS1Lk+pR07rm2C/DliResFcH2NLKrC5zbrTU6Nxl5PwW41XyuInmWi+ixVDTcGbz4s1jmf6bc6AkOmVuHiGnXYtbjhl+qgI9GvBUtbuH4TWpb850GZGSta4DUWPSao5jYi3N/8qGh9ClAFS+oJSrjSjcvPTnVPklvhrhE0T17UNPH3RHVaDrok1oA+3TmnNl/dBvWZAUFPMMOROgW7ouU720HgJlU1uYcEdZl0VLp4S9g3zGUJj258wxMYkL1HcJSu08iRxqE7sITirmJ5ugMr5DGhZvX2XcKviD1a1ZFQ7/AC2n7UMjDuCxsJk6FPHnJ7kFrk3Ley0HlM8zAsnSsDYBqmV0WqqknVP2KKCJxW2r5tgnCYJixyFZ8WmYSuOUDi1kRBGpHTDfCA0iQOSqNG3MoLdO5rB9GY+4NUmFawP5huCEvJPd/WkenchHoeGW4b9FOkWKStIMilSUS3ZnlhrJ7s6kXrOGw6B3mxKFZhD3POV6hTqftdEFoIu58Kylh2yPHYBv4mex9gyUCrh1s3gIkP6aKJEtrmmSVY2uyVPDol9bsi6CNOntSGFzJUvVU1ukz6yGn7SuJvw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTcrTGxoK3Ric2t1NUJIcldreU55aEFhY0NWbnA1TUV5Z3hFcVpudThjMlBC?=
 =?utf-8?B?ZjF3RmN1SmJ6UjNjNjlMNGQwdTdZUUg3UjJmQUxpa3gva3NDWkgzdlRxN1ZI?=
 =?utf-8?B?RGRwbjlrY1dBWWM5bjJaUUdnK1M4WmtjbHBvbDZKUGpxT3FWS1piUmVncGpZ?=
 =?utf-8?B?bWVVWC9nQWliZElUamVDWFkrVzNJTUJ2WXNXR3lzYkpWUkZaelhVWkhUWk9x?=
 =?utf-8?B?eTRQYjEwVkVoTFQzeUdaaE9Qbm9NWTZwdnUvb244T1lndUNLVnZtaHFTakNu?=
 =?utf-8?B?dFEvRDJpei96V1ZEMXZZUnN4dkxURXNSeHNLRXVSVjY1ZVA1Y2xqOFpMNE9P?=
 =?utf-8?B?QlBuRytCcGtlUUdKV2JGSm9GZTFFQ3EwVkhpSkdzWVdpbHhyc1Y2WmNmaW8r?=
 =?utf-8?B?MTZFSm5HSGFjSzRVdnd2eUVUckZHS3J1TkZTQjhIMHBBNW1VaEdvNHk5WU1H?=
 =?utf-8?B?Z3h3QWhHVm1WVlRRcGhLbzl3RnFydU9VdjdFc05sRHM2ZTZQQUFhOHN3aEU0?=
 =?utf-8?B?bTlPdzBGTTBtNEV3eFRBWTRKVUlZUXlQRnZzM3VEU0wwUmlIUHROUjJPLzMv?=
 =?utf-8?B?YkE4SHRPSDgwTnVKT1M4dUg5endSbnhFbzFINk1aNklrcTBpblhVZW0zK25o?=
 =?utf-8?B?MGVJUGZjNmFpYy9KWHo3UDBKbjJvUWFLRDhMZlJuUTJmWEFoU1RIWHhOSXhM?=
 =?utf-8?B?dEtuTGttTGhjZzA2RWs4YVVTaWQ1Uy8rc3V6cVhhcWdPYlFpSmQxQ0NwRFlz?=
 =?utf-8?B?QTM1WU93V1pGdEFaRktKMWVyVHl3V3NDZ0xCV2FQbE5ndVlCbit4Q015aURu?=
 =?utf-8?B?YUFhTFRhQ1hWcnFqcGt5SXd1UWNzWEJEL3JYWkRnSDI4dlljNVZGUDBlTFhK?=
 =?utf-8?B?aGVWSE5yZDVHZHdBL2MvcUlacnV0S1dEb1MwK3kxL2hXMnZrNHA1cDZ1Q252?=
 =?utf-8?B?anVKSmFSVnVoUWg2SEJkY1l1ZGQ5T3JnenlONjhPc21vNktJY200akZXbFdW?=
 =?utf-8?B?ZWQ3ZTVmRlBET3dRN3FLaGZUOXhPSHZQRVc5bFNUU1l4Q3VOZ3RlZGtMa0FY?=
 =?utf-8?B?UC83MGpHMmtqOWVYNmNSQWVVQk5iWFpzWVYrQ2l0M21LL2pZekZHNGthSGRN?=
 =?utf-8?B?cU5rUXYvK1k5T1RNRmRrOGpkMjhtVmxIVHRoZ1lES2t5NFI2alFrSlBENWRG?=
 =?utf-8?B?dnhzMlZiNVRMZUU5ZHIzbEhJcUU1KzR3eVpTYkM4NkpNdTUybDdEdTZPUVZv?=
 =?utf-8?B?elc3MHBpYUI5ZHhzRkd3UEhhNWJ3KzNYN3pSZWc1NUJ4NE5ieVBpWU9SWWV3?=
 =?utf-8?B?MGpRRGdXVnFveGV1NE5Pd3ZQdzVmQ0QvR01KSmZhN05ZRTBFblFCOUVPOUZ5?=
 =?utf-8?B?RWtTL0x3RVFqeXluQTNTSDVteU80SFBBMWZ6Y2tZRU1RTCtDTWdUWWJ0Q3Na?=
 =?utf-8?B?R1d4bmNMMDRnS0U1V0xrSHZBV0JkeCtYczlhcTFJbnFCd0JxTnltVkFWRFdw?=
 =?utf-8?B?cDdkOG9RTFJMdzlsOHFGN285ZDRZeVdmMnQzQ0xxZytZOEl6bFFYNHFVbHFS?=
 =?utf-8?B?Nm1NL2oxWUp0MC9DaW9UVDJ6TGR5c09PRnVDSVpmbEp4bGxaOVBlbVNCUFdx?=
 =?utf-8?B?dTZzT1hFZi9Yb3FXcmdtZy9jUGtNMGVKb1AwRUFoR2ZpSW5yZUZhUlc0cEx0?=
 =?utf-8?B?VGZJRE03NkY2cWR3RGRQZGNwTTlaSGF5YVlRdTM1RStxeWpiVFZHSzlhemcv?=
 =?utf-8?B?NWF5ZEhMdGpNcmY2M24rMVF4dUNFUkNXSXdPZWhCK2xDM003MWNoRXdEV21M?=
 =?utf-8?B?cGU0d1pZTWMvSnhlbzBwWWV6MTZNbm1mTi9MNFZ6a3lBRW9CeW50MVRmUVRm?=
 =?utf-8?B?Mk9UY0Z5Z0d4VmpTZnl0V2dpWktiWHJ0OWZKQ3p0Vm1lOHVJZkNpU0dtV1VP?=
 =?utf-8?B?MElyN0k5RXdDQ21VTlYybm93bm01aFRXT3N1SlhXVWtIbGRFemxKc2RSWkFn?=
 =?utf-8?B?alExays1LzEraCtpMjVxNTdzdWp3eitjRmlPL0RTcUF0VERIUTV0UjhwSjc4?=
 =?utf-8?B?ZWlpL2V5d3lSTUdqNCs1ckVFd3czV2Y1ZDVwTTFFa1JqWGUyanhnZW1RR05K?=
 =?utf-8?B?OHpZWG5yVmdZd3NEeitjVm9iajZXR3Jjcm9XbCtUVnF0ZFJFTGNRQmZZaENL?=
 =?utf-8?B?bGxsTGJ3N2tQTU1TaWFQM0QyS01ieWJ6SVZJckw0a21rK2NMaWlUelVmWHUx?=
 =?utf-8?B?am4yam9jY3hpdHh0RFNOMGx0Z3hSazVOV29mbHFnamgzTkJvZzZHek5sdmdm?=
 =?utf-8?Q?yOh8WTaruGtsoUPWrU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99581a8-91b0-46ef-3379-08df2ae7f7c3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:09.4216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edNPBf+zw3jPTo12oMtNTHcVz7b/51nIRidGdw9Sjnk3QhnO9J8wWD+dZFTWV44R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C593AC0009
X-Rspam-User: 
X-Stat-Signature: hu9jgfoqhp1sfi9u9jnu5h8p5xgrjazw
X-HE-Tag: 1792088001-737793
X-HE-Meta: U2FsdGVkX19aK+I/PGd6CU1RrAi3T5oKfDOv1aZgVfQEIJPL7nAMAnZLTfDM1mXDPSN1j9uJalWL1Jhjfy4ZDkZp72erUhQX8G6UxVzdhxs9g4dUHYdayJhbodfaDwmnuYG6nSPZsqYulGNmF0RYo38DOkzcnljQWEOCMrcu4Itr+dzbVhSmyI7E91p3bKVMjmbegOFe5zwGQ3GH8s/ioi116jIvvNiIhFKHaTSmsTF+QSb3IURGrZiz+GXmTy7TNuTNo/sNm+XQ30g4NUIMclwl/jCQuoWkoQ/JB26OJ+Z9ycu3sEU3gW1mJGqxyVEgIsFkzh3VM9ApY1VWewWa9SW98L5q6gNcpjlYlhHCptvXGZlujdt+yBnMDhV5nT6ybdFOqDBvW8+6R5mZ6uYI3iMpUuSFe47Ra/T0kyp0PDnkQb9az6hEAFuPOPRxknjyZuhMOYNyzvZHkhiiy5+M015mL37oBPrECsyGtLqCWCgK/E6dKwWDA0+hUYAS/58kW670pEuaTRqmjzUjHBlVbBb9oJyNUJv8Qdu6ENlDh/9ry4fkhgcVgzl6G09lDlgwoxQlCVlyF8vZKjdSZdEZxquU9H4YKm6FTfTxusj1/bRBIUPbYmPpIya9sUnNnYSkObrnRG9IAyst11psJG2dk4DMv2DbEUcUkR79Njd/g3v6V0/p0mBomEnMTh7oWrEsD8asmZBImW61XN88Hl0aymi/pjU0T744EmL+HOpR14AdL1Q6RJv6OaGnXJWuZkTsBOrjURGfS+pC8np/4xwzYibgZylbCQxKm5o93Osu2ep0NuPpm5iWeM199yw25QbX/AHKSjd111TBks3/zFNVjxvI0TxQ94tuHwXeGHbDdx/ljgFf7qYu6TkpJWi60sSnK5ICT+1GdMuJLb3dQZUkdXVRhDJTGnD0Y3A2DyHWJZRhBIMWqwSkL4qfnFFvD3GWP417JizIKw+yAQqEBnO
 sTuiErsg
 hHMC5lOxNDsOrA+K/ASjCwacuHA6mHKaYl5pqgCZDOC/4L6Ao+1odWYe4MMCCetC2zJ70+AeNMXa+5gWWHADx6wZiY1F7Ppmw6VByzIp91yW5C7fzPHJnPi67GA059pduH8Z8EFmh6pVcYBwpxUr3qiw7/jCrELZOJSj97Efg+1ZqVyeGstywuE0kijpeHUDN0liklrZ4Cf4cy+zhqY/fVZuRkRo6yA7ymKuh5Bnyk8ls+3+r9kiQ0Ck20ArBf0KTA8gElno+u3aKkvrlW3V4PKSyzITipifXN3RcQiYgEBF8VAeRDFgfxqv4Emv6fQL6b8wHERuwKFyNQm2OOqYfp7UQljB94hzOOGGMAKaZ/IqkbaJbiHZD0wRQqVEFlySkILHH2yXxeSMMfkkOQg8I8oG+lnkSzAbV961j2VYBKgOnRZVN+TOGebRI9CxRWKDQIY+H3TDGJmSdz759f/7biiLFmYfbsGdWR1X5u3VafZMRriH8Bfce4kxZjTYIaQ+4mfdMWx1PmKakcNMsi85WQiHaO48Fxai4dzougIVbQm9D6zXJ5HTluxT5sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For maintainers, Patch 6 requires first 5 patches to work correctly, so it
might be better to get ack from arch maintainers for first 5 patches and
merge the series via mm tree. The patch disabling lazyfree THP discard at
PMD level has been picked up [2] and would take some time to test, so this
patchset probably can be considered after the merge window closes. I am
sending it out for early feedback.

Motivation
===

A bug was found in the PMD-level discard of lazyfree THPs [1]. The
proposed fix keeps the PMD invalidated with pmdp_invalidate() instead of
clearing it, but that does not work on every architecture:

1. riscv, LoongArch and s390 let GUP-fast follow an invalidated PMD;
2. powerpc/book3s64 page table check counts an invalidated PMD as mapped;
3. sparc64's thp_pte_count becomes unbalanced around pmdp_invalidate().

So the PMD-level discard was disabled instead [2]. This series fixes the
arch code and re-enables it.

The discard decides from the folio refcount, so GUP-fast must not take a
reference through an invalidated PMD, and arch accounting must stay
balanced when an invalidated PMD is set again or cleared.

Details
===

Patches 1-5 fix the arch code, patch 6 from Kyle keeps the PMD invalidated
instead of cleared until the discard is committed, and patch 7 enables the
PMD-level discard again:

1. powerpc/book3s64: page table check counts an invalidated PMD as a live
   mapping, so setting it again or clearing it decrements the map count a
   second time and hits BUG_ON(). This is already reachable via MADV_COLD
   and mprotect() with CONFIG_PAGE_TABLE_CHECK.

2. riscv: an invalidated PMD still passes pmd_present() and the generic
   pmd_access_permitted(), so GUP-fast follows it. Add a
   pmd_access_permitted() that requires _PAGE_PRESENT.

3. LoongArch: same problem and fix as riscv.

4. s390: _SEGMENT_ENTRY_INVALID also marks an old PMD, so GUP-fast follows
   an invalidated PMD. Always clear _SEGMENT_ENTRY_READ in
   pmdp_invalidate(), which makes it pmd_protnone(), so GUP-fast rejects
   it.

5. sparc64: pmdp_invalidate() decrements thp_pte_count assuming a THP
   split follows, so setting the PMD again loses a count. Count only
   valid huge PMDs in __set_pmd_acct() instead, which keeps invalidate,
   restore, clear and split balanced.

6. mm/huge_memory: use pmdp_invalidate() in the discard, so munmap() and
   mremap() wait on the PMD lock instead of skipping a none PMD.

7. mm/rmap: discard lazyfree THPs at PMD level again.

Note
===

x86, arm64 and powerpc already make GUP-fast reject an invalidated PMD,
and sparc64 has no GUP-fast. 32-bit MIPS would not reject it, but it
cannot have THP: _PAGE_HUGE makes PFN_PTE_SHIFT exceed PAGE_SHIFT, so the
BUILD_BUG_ON() in arch_mm_preinit() fires, which is why Ingenic dropped
huge pages in commit 69b686ddd579 ("MIPS: ingenic: Remove
CPU_SUPPORTS_HUGEPAGES").

Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.com/ [1]
Link: https://lore.kernel.org/all/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/ [2]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Kyle Zeng (1):
      mm/huge_memory: avoid transient none PMDs during lazyfree reclaim

Zi Yan (6):
      powerpc/book3s64/mm: don't count invalidated PMDs in page table check
      riscv: mm: don't let GUP-fast follow invalidated THP PMDs
      LoongArch: mm: don't let GUP-fast follow invalidated THP PMDs
      s390/mm: always clear _SEGMENT_ENTRY_READ in pmdp_invalidate()
      sparc64: mm: fix thp_pte_count accounting around pmdp_invalidate()
      mm/rmap: re-enable discarding lazyfree THPs at PMD level

 arch/loongarch/include/asm/pgtable.h         |  6 ++++++
 arch/powerpc/include/asm/book3s/64/pgtable.h |  3 ++-
 arch/riscv/include/asm/pgtable.h             |  6 ++++++
 arch/s390/include/asm/pgtable.h              |  8 ++++++--
 arch/sparc/mm/tlb.c                          | 26 ++++++++++++--------------
 mm/huge_memory.c                             |  5 +++--
 mm/rmap.c                                    | 11 +++++++++++
 7 files changed, 46 insertions(+), 19 deletions(-)
---
base-commit: 71a9b024444eba184335b67867897714e4da143c
change-id: 20261007-anon_vma_uaf_fix-e7accd1d2ee1

Best regards,
--  
Yan, Zi



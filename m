Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB9ACA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78426B0092; Mon, 12 Oct 2026 22:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D3D6B0095; Mon, 12 Oct 2026 22:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1076B0096; Mon, 12 Oct 2026 22:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 770B76B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:20:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C606C09F7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:20:35 +0000 (UTC)
X-FDA: 85315999230.05.EBE0C86
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012015.outbound.protection.outlook.com [40.107.200.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ACC71C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:20:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SwvHGSXR;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791858032;
	b=qNTeSSWOcbHascpTKoLCl8UzMR4vgIQ7nnXex/XcFNJcgHNJ27/TQz1DdYz0po3ns5T1FD
	mGCyKqQ98uoYOkSPQqOC7jGmQPcLXOumGU0XiZBW2KSb9VtG0OgNIPTmIweMX9pqAohXnj
	M4qnQ936WEXRWHF/mzZHrA7jGkx6leE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SwvHGSXR;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791858032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j/MYfcO8px+Kk+I9XlnpNAZEXFBhtgezUT2Jed5Mal0=;
	b=6DaoIYN71lq7zT3f0HNT+T2WvskPKynnbfWG3Dmkasl1oaOFYA4+YS2qxrtI3k4SgvBO/t
	VOuC4sR3vbk3C/sJHV5Is5poLwv9C+HYrVIc3s8kWHsIecZVKQ/XuPohjsUa5Q7+9WJbTl
	rhfhUl3s1KZlyD7BTLLquPaqHmnJzz0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0fHIcG6oygHUz0yhUMgaNb2GC59WdoX7LH8uz9A7PtkjtG+kg/KP0pE+u4cDhla0oI9QoRUPX5XtTENeqI8fGMgYh8X79785RFQW2b8oogVOor7cEiC5g96ogj7tOdrfVQqVQ/cK2zMT9qItFbUhkSI6mIfX9zCbOBcXoDXHSu/cAjeoixRKKMlcjIm4IzncMUP4MHeKuzVVLP8rrUJrq63g9/bh7+x9OKTaFUpK4zNSOR/SfB2bCPNXdfwRHhPJ2nIZJNiH/Yo/5znvT14pqElk/oMsZyVnsnWIsIVKOdw6wOm3wGWIGUTFXonUEGV5/KxnDp6PfkKSEoUqeiLrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/MYfcO8px+Kk+I9XlnpNAZEXFBhtgezUT2Jed5Mal0=;
 b=PAPtxp4DalAh1laUUk5GggwZnACtWXWDvAqbENP6qe5gymbiCiLXGXPOue06H7IC9VyZb+r02U7wAG4QpP2NqSMX5nK3Hj/5G/w/9jxjhB9GYWby/0ESrwlOfMPDAyZl21HCjKdqLs8P9/80nmqPiWzyzRL3vqnrXJVpgMOVnLDGeT3cXy5DCTJKkc3/zHfEMcIj/QEpfXiCGEgMwfzU2n8l51OIBTbVEJ/JvK8rgUGbbgLRGnr7cNMI+Zt0/pkQCGei8RDe73rLN/5enUOs2nXY2DrpWTjp4shI+du6M3ZOdtyUuTn7CRszBu91uJ4GC0K6M8jWqHQZAsT7v4umSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/MYfcO8px+Kk+I9XlnpNAZEXFBhtgezUT2Jed5Mal0=;
 b=SwvHGSXRbwqB9HyS0fftMREyZ+9hK/cEtwdES7L9CqnsARPipes1nBCFMni6w+LCG/uRlLFSt6U8Ld8SDUcIHPqaBhTqze+ByuifJ6pVHlm9z4V6W9o0txFUuA8zOUtQA1S2V38XQ3Io0vFQiv8WXEoJWxVENIGUiENsheUOw43DHF/aMJw2MIZacOkz8GusjyGcpuA2dCYmKS883Vf12tePd0jGcxsQA148KlY1SoHSqUtk/ef5ugX3I5yGPDKh7ttOld1kojWa2a7IgWWYJE3bSpSyByzST991oWfK6zPEbnETBnvy7wgCXMMli15XBtp3JPNXlOh0tOhzxzcQ6Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 02:20:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Tue, 13 Oct 2026
 02:20:27 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 12 Oct 2026 22:20:16 -0400
Subject: [PATCH v2] mm/rmap: don't discard lazyfree THPs at PMD level
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NwQ6CMBBEf4Xs2TVto5R68j8Mh0IXWYNAWmxEw
 r9b8O7xTWbmLRDIMwW4ZAt4ihx46BOoQwZ1a/s7IbvEoITKpRAGO/uZG0+EYbJVR9jwG3Otpaq
 UOBnnIC1HTyneX2/lj8OrelA9bVdbo+UwDX7etVFuvf+GKFGiFsZocy6oKdy1j+zYHuvhCeW6r
 l96tfFQyQAAAA==
X-Change-ID: 20261009-lazyfree-stable-fix-67712b2049dd
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Kyle Zeng <kylebot@openai.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:52d::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: 67812a53-d226-40ab-30b3-08df28d08bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UcW0LmQXNqlJIy591e14WXI6ZAflwahsD3A2fpMBmnWX9GwiuGAGJlSKCneeR1p69/YgrPpbG2eEmqFlTph9q8K33vHgyKTTU14UVLPagTRoI3VEhNvrnUQPe8XtdvA21gTZCJT+D1LZvi8FS00rtXHUJT5smVCUUWCqVFTcP2hL9qKybbs7LXCSYxMGPmvRREyfT9O1AW90MR2jtWJvFT7pvF9ca1LvsltO6aWoGC0BtRuL9posW7d2IfsL3XIGGaaETOo0DRpuaS1Ym42J8Lbeavzp3ZMLbsm8KpyOyaS9MhPV/sroOf+xcK/dsV6e1bSBSh94oJmKGSWDHCdZV0+DKaxLfuiBeh/10Yt9d5WwFUwNY/mmpSUqdkDz+GHzrWJU3en+RB5Wpf3aqoY7x+BsnGfwPgU5/9z5uIW/k8vvSDMuBdcQj4OcnTO2wvd8/2IetvR3dDzlcjPQud8PPoPSDGi5hsgxyAtwh4KtDqJN5oRyw/Z/mSLtoyPUslLOg0JKI+nrRO7OR1P7BNBMkdYxQ6pn7jUkiHIh9cQRUpXnbHJQXhIjO+HjNq1Ir4T4zIFOltZwDt+Lw8C1Sav/ZFviCQgysk8imRFSXF/OHmJRxrnh2qVF1PYpl2hH2g328VhTOLJM8CzJ0zUd05eSkuYHUno/q38p6I2sTfLuD8EeFkeAECzmr261B2RyO/Fm5yuf30ocumfz0317rSnEnw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkJ5RVVBS1lrVk9Pai9TOTh2Mm53Zm5MV2V0V0FtWEE4Sk53MS9uL2R3cm44?=
 =?utf-8?B?TE9OVGRSa2FqNmhQcHZGdnlKRGxjUFBJeFVTblZuTXBDYmhVV3lkd2hVK24x?=
 =?utf-8?B?WkdvNXp0N3lhblhSVnI0cVdsRkpmbjJHMkZDbjBRSFRvQ1kwQWFpdm9CS0Ja?=
 =?utf-8?B?VklBaUpUQUlHaTNFdGlxbmRiWFovejJ2aHc4ekFML0loV044bG1aa1ZtRkls?=
 =?utf-8?B?cW1mR0wwbG9yUTR3a096UWVpK3ArcHMrKzdGdEFYeHY5Y3lpRUpGTElXUk5Y?=
 =?utf-8?B?djNxYzNVaUJDK3U5bmZlekZOVkJVNTZzRE1xeEVEMFVBNUZhWFhTVW03QWxL?=
 =?utf-8?B?NzV0WUR2dzRlME5zRGthYWp2aXg5QWp0WVhoT1BhZW1sK3oxM2g2OFZvVHBs?=
 =?utf-8?B?VkNQd0JjcjNCNGlVY09OSFpScDFlODE1Rk1tcHVJeTM4SG5BczJ2MW9BeTFT?=
 =?utf-8?B?Mzhjbk5QYWpFeldDQmM5akpzd2U4OTcxZFRBRHlTNTFZRkgvUUJEWVE1Ymkz?=
 =?utf-8?B?KzAyMlAyUWFNdmtwQjJBYmJpMUJGTWRLSlFDZHRncXNMQnNGM1gwbTRVTlcr?=
 =?utf-8?B?N2c3WFk5MU9yZVlUQ1c3RjRqTXAzMEIwcmtnaTN2Vkl5S0JNR2xId1JkcnNF?=
 =?utf-8?B?aWZHWmhzd1V2UXZVVVg5azVSZDBRdHAwaXQzTlhFK1doczVraU9FcVpFR1Vh?=
 =?utf-8?B?eVhCMi9hSnNpYkMvOXE2ZGx4RnI4S1dZNzRVUlpIZmNkb3RYaGJwanhqMVV1?=
 =?utf-8?B?aXdzdE9rSUo2Njg3VG00YW5xVDVKOHE1VDFOWjlndXFjWFNsa0JyblJmZEFo?=
 =?utf-8?B?eGt1MmRVOWFxaWxOQjArZlZ3RjVpZ0hLTGpIbzFmNXFNWXdmMDRuamUvYlIx?=
 =?utf-8?B?c0FRbWVMWCszbnpLc2ZpdERkYlB6Y1FJUWpKd2RDSFdjcEZxcUdNaTJpQStu?=
 =?utf-8?B?UFhmaW1DZW5tNlF6S2luTWhUcjc1YVpsMVVXcXdUSXJlZlFEYXBuVWszNnph?=
 =?utf-8?B?OXNXc0ZaUXF0QjhMMG1PdGM5UWptNmVoSmpyTmtGQ3hCdmVBUmxhcmtFSWdO?=
 =?utf-8?B?NjBFTmxNdHVJdjBUenZPQlRDVnlzd0hkTWN4UmwvVXBQWm1EM1YwSTB0Ymxy?=
 =?utf-8?B?d2VkMmorOW40T1FndVFIaWptdHNHOC9pWVVBVy9Na0tvSTgzemYyemRXU0pu?=
 =?utf-8?B?VzZnYUx0MFZVWVppYjBrQUlXbWM4NWFhckVuSjN5SjI5N3dFM3plL0NaQU1r?=
 =?utf-8?B?Ty9UVjJHUmxiSE9CYmJsbUxwUlhORmRlYnBaSktjeG9MbFg0NzZhNWJHcksx?=
 =?utf-8?B?V3BvVlZWNkYzT08wN3IxWUV3N0tCZkJmbGxTd0xRWThIWU5SRjkwbGV3aGlh?=
 =?utf-8?B?b2hxRkh3WE9kbUtTOE8ydm81L05PbjAxUzNZR2xUNHNoSlVZaUtWRlF0Q3Zk?=
 =?utf-8?B?UHVUZE4vSFJibTdrMHBuMEx6VDB3ZFFPcHpZTVZ5bHlyN1VpdGlXcnhmdW1H?=
 =?utf-8?B?UFBjd284dkZWeEVaS09Sb3dFN2FrWXMrakhrV3hEYS9mNFJBK1h0NnlCUDVs?=
 =?utf-8?B?N1BacExaMnpRWUowUE8wM1BqZGVzUjZNVW5Hem1GbnJwS0ZXaml3d2N4VWJE?=
 =?utf-8?B?MVY1VEQ3R0tnUlVzSDExZytwSkx0WjZrT3FPM2pqdk8vVHFnMUtINFVWZ0RV?=
 =?utf-8?B?aW1ibTlzd2poZzJEZWhLamJWM1BFWFpyWHlrZzYyUWRXYXpxaGJmcHFPcC8x?=
 =?utf-8?B?M2V6cnVTWXBkU1Jra1RWem5uTjJtdnB3M291elBBdHJ4R2NLalp0cmNLakpE?=
 =?utf-8?B?djZuTG5DQUo5OWdtZnhObU5OT1JmL3lMQjh4c1NkK0NLL0N5djJKblhiN3Jk?=
 =?utf-8?B?WkI0Nkw1Z0NEVjE4NzVMUXZUbXVRd3hKa2tQTkVzNE4vQ0NPaEEyTWkrMEJr?=
 =?utf-8?B?SWhlVVlqM0Q3ZWlCMXRMTjhiUCtsVTNlU2VaRFg0RHdlZklYT3I5S2pmQVBM?=
 =?utf-8?B?SUZjdFY5cnU0NDRPQTNuQ1lMUHVMYUtpZW1wVzIzSm90K2VXeklsWUtDb1ho?=
 =?utf-8?B?dTNEUVhxNlFpUU1tYjgwMGFHL3NldWk2a1lRTUl1Y0JtU2lZSnpiemxPSkYz?=
 =?utf-8?B?Y3dleEFOVitqRVF4S2h6RENVNGRSWS9sVFlBWi9KSWt6cEYvNnFFSWtib2xC?=
 =?utf-8?B?WGFvc2kyR2JobUhsZks5ZEFzZ0pqY1o4VFBibVJodVc4TkRWRUUrZXdmU0kz?=
 =?utf-8?B?NTF6MUVQZy9nRkYvMldPN08vMDJmSlB6MzZGRCtIWTZBbzZ4bWlvRm1RS2F1?=
 =?utf-8?Q?DpbBtHHRDjCTToafTO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67812a53-d226-40ab-30b3-08df28d08bbc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 02:20:27.3705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeA1G4TYiUuo2cTLFX+4EI7lmQ6FQR7aG8ZiQ8hO3ZHzYxcczturFWsXQAtR/h7t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8ACC71C0009
X-Stat-Signature: iyqzzn7rk8fknu99pkwy9udu4nxefdhg
X-HE-Tag: 1791858032-992865
X-HE-Meta: U2FsdGVkX1+yKyEGUeFXBGQpZjAqDeDe0IVY27gEBumzmPOb42uX6dhPKugyXXGeOAM3JwKmKbkCqdDID6OmBXa0zGWrZGQFwubod1Kx0VrY6OrV7ORJ4U1TGgcqQEP/FwfNMcvDvGIaKRkcHYsgi31psUVJEqF6Aqp+Bni6/1n0Kw29teD+g1coq3J/2SCeSSlrQhYQFAJ8KDztL8yHpfmUPYTvmHkPTXcAELLzFhKmki+JkVTmoWP5ccoPAftkfCM7Ys0EUhfKoKKCCPwryxqS7Gy21aU8ELBVSjdgJrY6tlT3WS1jdJyasExfPDYeFVNC544Gi0h/EBGPu0ZgN4+sR7VPzjhetyss0i+rv+sWmT7NUlaTyb1aDdxxVM2I3thtKhg3l7lxLupEszqG8s8KP1sBMyHzo2My0b+qx14sSaNyYSbcy6qyEdZmuyOR1uGsLmDTtvYQoXUWeLBEYr07hO29BjE+6dHynI6pbP7b/yer1u4hnmXRLufQVm0ZSbZTqLIlG3baAtBmwa8uhNcQwm9mZlR0GZKY93zjybaNQ7oRgu7htEwvtOm4zNxWZdY33nTw0COIKyvq2Mh0nRJQtK4Ad46UZ821xf034Z+sWqyt6hTou+pNFTyq/EwUqDU1DtKqG1UEjcWNLlMXQHztdYDlVJcoQaH18BqDjziM+UgKECuK4FFDbdve9NioeRVBRpGPBKA7nHrQMcUTB20yGCgoCYLOSlrFpiSmehV4O5RWaove+nw94fYSkgTZfxQlyTujADZD8qhrb1m5blMsxHLM2t0//GU2cAuthpie0xw5iGqEcLbB45+Z/Vw16962DtPbya/+btfWglcuw0m9UvdIyStxGWnn+ZVfshz7wZEMbMTPp7Gl2FY83FXEGHb/2h17rZAtb9Bikq57cCDKqJJr4fSfReEuLmriaUjUDVxl6y0A1iyVFM8w2Hwh1KJtah8vOqnAurVQnID
 vN3ydFSJ
 phrub+MXjlAZj2Gy+1MLDmrVJk6sYFyIKydmunNJvFIYtbKKXInuIQLBtFaH8Zr7LrjTimH1sij4E0wzMKBXSq+6ou4Q20torI95sn5/QQf0GMjm6OStm5M5u+CpgDparKWELT+rj4S6YrcYfG9ZmxWXkmwSDTw7IylpAy77m+NwaPN6PqpiLn8ZnR3IbdlhpNZp5U3pVxHrdiYMxE0EI274UUfE6xPwlObhhPV+RHWw8on0LtbMaAQddD3MIVjymFTyNawPNKliEsfa/1WPeEfDc9/Vj1ZX+Baz4x2gVV1GR0zdoC9sfQXKkX2ixVX6i5PZqRyLU6uNAKGuwlysUzeBMefwg19LxUEpNHN+o6H0i551ga8Ai0d8JA6sJOyOyp+jXnRJl3twPYYJVT0NmrSkQdSDaYHyic7WkUlK+TPUZuJdmLA45HWT/Wmi9lCDghvGtMD90zBr/05huIbZwrPbThCaYmQP8AzyCMxahnsRqqbaXf/ZftA3rf7WF9E/d7fKmHNhF8piuLFdr1HEtzm1FLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__discard_anon_folio_pmd_locked() clears a lazyfree THP's PMD before it
determines whether the folio can be discarded, and restores it if the folio
is dirty or has extra references. It is done under only the PMD lock and
the anon_vma read lock inside try_to_unmap_one() and no mmap lock is held.
The temporarily none PMD causes UAF.

A parallel munmap() or mremap() is supposed to serialize with it on the PMD
lock, but zap_pmd_range() (called by munmap()) and move_page_tables()
(called by mremap()) do not take the lock when they see the temporarily
none PMD and skip the PMD. There is no more page table walk after the none
PMD is restored:

- munmap(): free_pgtables() waits in unlink_anon_vmas() for the anon_vma
  lock, then free_pmd_range() drops the restored PMD as bad without
  removing the rmap, so the folio keeps a stale mapcount.

- whole-VMA MREMAP_DONTUNMAP: dontunmap_complete() unlinks the source VMA
  from its anon_vma while the restored PMD still maps the folio.

- plain mremap(): the THP is not moved but unmapped, so the THP's data is
  lost.

In the first two cases, the folio stays mapped, but no VMA that maps it is
linked to its anon_vma. When the anon_vma is freed, it is still reachable
when one rmap walks the folio. Racing lazyfree reclaim against
MREMAP_DONTUNMAP as an unprivileged user reproduces a KASAN use-after-free
in folio_lock_anon_vma_read() as reported in the Closes link.

One solution is to use an invalidated PMD instead of a cleared one until
the discard is committed, but it needs arch fixes first.
1. GUP-fast still follows an invalidated PMD on riscv, LoongArch and s390.
2. sparc64 miscounts thp_pte_count when an invalidated PMD is set again or
   cleared.

To keep the fix simple for backport, stop discarding lazyfree THPs at PMD
level instead. try_to_unmap_one() splits the PMD and discards the folio at
PTE level.

unmap_huge_pmd_locked() and __discard_anon_folio_pmd_locked() are left in
place, unused, to minimize this fix for backport and the invalidated PMD
approach is planned as a follow-up series to use them again.

Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
The proposed fix[1] requires additional arch code fixes[2]. Disable it
first for stable fix. The function will be re-enabled along with arch code
fixes.

Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.com/ [1]
Link: https://lore.kernel.org/all/DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com/ [2]
---
Changes in v2:
1. added more details on how UAF can happen.
2. provides more details on why the invalidated PMD approach is not used.
3. explained why unmap_huge_pmd_locked() and
   __discard_anon_folio_pmd_locked() are left unused.
- Link to v1: https://patch.msgid.link/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
---
 mm/rmap.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 805db93fe0428..1131b76bbbc28 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and

---
base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
change-id: 20261009-lazyfree-stable-fix-67712b2049dd

Best regards,
--  
Yan, Zi



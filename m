Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2EBCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F0E6B008A; Thu, 15 Oct 2026 14:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8CF6B008C; Thu, 15 Oct 2026 14:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0D86B0092; Thu, 15 Oct 2026 14:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5C36B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56DF8051B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:27 +0000 (UTC)
X-FDA: 85325658054.22.134C0D0
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id E28EEC0002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JIa9G1Lj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nQRG+P0Cb5YJVXcWEOM09eq9a7157aYbKeMOoFYutM=;
	b=BBdfJrsXjfv5JqmHn07k+7vBHVu2JM6duK5CbRYLsUGBe/jgM38we1tvnx0YeqPh92Iwvi
	zCgBHx6RvUD8RoDhtsIPIg25UCyg+Bb7C95nm0Ew+v9Ax+2OdXgKlDWlipiLhGCalOkkK0
	NrFiCu85AYFPROOVK2JKA80FVkIuxGk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JIa9G1Lj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088005;
	b=dwPfAJj202BlwiimvL0ZVfJ3JFlP3XbULIOeKG2e/9h7qX3PuNQ6yccpPXdbl+mrfFIzYo
	EprneRbHzKmxTsZ19kAW+yx6DlgyEUQhc6GcZ0O8snSYAXuyASNOYjVqD3wFHlrTQBR8P/
	3U04OtPfXP7j5bJZ+W8vQKcqzF0imm0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWhxSSXdnn4AQ0FlAFUr+9WsaB2YbLysjBOTEeahA2/wQcGh2PW0FjY1IHKmf32VnmD1Z8Y4iJ1zWkoiAajhSv3SUG6ge3SFllU+xi0aeFhKHiN1XahRPODIIGZR4rHOg3RRrQf/6GQjwOUEvVk1fHs6pwtkQwHUykYqKgR9f9R/j+Mklw2Y1jO+6HKOCQ2nJLt52vU/DclRHPOfTSdqYo9n8mm6UjSF8y1Y9aCwFN77KiuK3s5uSI+4SatCIf450y15g1tEkn9F0uQzfGs0+b7x+SZrCyj0OmYDfYnTO2zWXXhDRYDsDh+Luo4OdTej2QVA/qIznT7Z7ukgZyAVpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nQRG+P0Cb5YJVXcWEOM09eq9a7157aYbKeMOoFYutM=;
 b=VykgrT3j4CUprB0Ipc5Tby5Nn9xSecrFk6B3zYOcq0Y1kd/XHXmfXWfjCw0qQ7TYUOndKd4MijhWPqx2HoLhqSK39QmsJbeSz0wPbhnE0q0l4clmycO+aK4Bkx+ZWnFVJ7pd4dcymr/TDJmClcLr2fQC9wiyzsIlz5Qnlfsv6aadfQ6MJlbfeFk1PmWttKA9A915Ho2N7gnOYWxi71T6q3D3mgE1Ljl1DyvNhfdzHoC2jnS889wC7hHpm7pn2ADZ2lK04qqDezio5kkFyU8qKrGK3FQe5ZuBdhV6WuwB5NeifkLIa/lGkKXyscWl0S2j2qW6rxGBLYrIL2cmfyupmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nQRG+P0Cb5YJVXcWEOM09eq9a7157aYbKeMOoFYutM=;
 b=JIa9G1LjQTyoJzxSkf0UfcfJVMr41d5nJMSdM1dezYNK7It3QSCInlx207MuTj8WMOz4bTHcuNgunzH2Okvktm3XnlEBon/s8tG7C7FjuqRokBYb0wvdJHtfGmUyWPrBmu/J1J2QOOg7lPL+QM9xGFhuAcU1m/lox4LT/In7M0FKZJWWHB1tK3S7l7o83GXZACS5EZkJFo0gsKHy2DCYOwfTUOHBHGTPy6Peka5itSGuBrSYhA+xqcNlOZhd+/v1bI/VCiAXyE0xuB17Y22iipqUbOtWxl2refIBagyzox9Vjf+h2P36S9kporlE7eL1/ruIGGhd5qB8Y6/7lHyUtA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:12 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 15 Oct 2026 14:13:01 -0400
Subject: [PATCH for 7.4-rc2+ 1/7] powerpc/book3s64/mm: don't count
 invalidated PMDs in page table check
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-anon_vma_uaf_fix-v1-1-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
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
 Shrikanth Hegde <sshegde@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: 62527d50-ff55-48b6-2f3f-08df2ae7f955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	w0d5tzQhOwY6iSSgqyhAYg2J78Xhv/ZrYHuiGIHwgQEkJtui6nJCmb3F/fIE6Oa7uCju/elLcwT4w7Zk1mt26g+ZiWEt4Frj8br+VMEPc9CBvhWojMErB8YPvy2fyp5akm32+eV29grTRJynhnoDDrTDRl7uUZxYhu6PrGnWvS6YFZUFBGEF2CVLOiumDfms1NyS6HSe6RaCM4dnEIQRN6AW4Zmc3xZzgIOMesrPUrguZnWdj/QrkAa96YEuS2qGeFETJS2HHxZ9uIphPgeIXsYOJIWVS0IorID4LkO8K1LGbst6W9/pBNhSpGx6DldBmt0BZ5fAeKnBqVxeSrHa/+Dzz3acG65FTJkEUrptMJKG3Jut8KPS3e0NTbuV/Igc8mipRQS4+aWvSkbWQzXI0HN7x9qUstoUdF51U2TRRnYizSBfUqAJMIS3d07awditqJEWCOtS8273GywcBwkjo/lK34xFK8x3uTy5E9CG3L+yNsNDeZzm3UWEdMWqqyrLMgaWuN7m96iI9TFoP7BVcOScC+oDeAU484Jrsb6rz/0ETucL2Z1KNXCDYj8m/v1znfnyCJVOGnzvzjdHhntvlJ3luE0Xy24wYk07oQ+mL6iM/vRRGcz5la1GYzfvfKLp1Dqq6K+S+zMcdK/WH9IzlFeCU14t/DOCAalop/pikw5UkNAb2FtV5K4vgeRKbuOw/ODc7cn8874fUNM0K1XYoA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHhsb3ZiM2lJYXlqMndULzBIK2tiQTk4Rlh3MmZtRTlUU1NjT1RVUWhKa3Iz?=
 =?utf-8?B?RStuTWVSTFBtN0txY1c1WWowdklLcUpmZ3dPM0hkanF0Sk5oM1ByWHh1S0Rv?=
 =?utf-8?B?MlJQa25HeHlzMGxKV2hJMDc1QS9iZDdZaVhoV3NUN25MQUpoT0RHdlJxZXda?=
 =?utf-8?B?bGhuVnArODFSdHVhczE5ODI2bU1wc2Evb3hxYzR5V2lweTVoMi9LaFZEY1VL?=
 =?utf-8?B?b2UrL3IwNWM3Mk1BdWRwbDVIbENtOVRRUXdDWkR6MFVjRkNXRHB0bnorUTRy?=
 =?utf-8?B?VUw5c1hKM3lQU1hVMmFzSjgvQjBjVFQ4WFRlT3FVVVlxVGwwSzNsTmc2TmI0?=
 =?utf-8?B?bUhSQTcrODdyczd0NHh5a0NCMExKa1RHc3NMMkw5VXFVbG9CZGRkamwzckxs?=
 =?utf-8?B?TDdMbFZoVVliWC92d2RyRXRlTnAwOWdHN3VGVHdXbmVnV3VsTXNwdGFBTms4?=
 =?utf-8?B?M3l3M1hWVDR2RjcwakNxM1dGRThPK0cyUS84OU8xdGxyQUVGc3VQWTYwVDVB?=
 =?utf-8?B?SlpqMk9KUDRkMFVrUHZLbDZTbVJvS1k1a0JMRHlVVE5NT29BVjk3QlE3T0t3?=
 =?utf-8?B?aUJKM2QwOWFqWTFjVHUwZktPL0hzaE1CdGFFU1kvRTgxeFN6Q0V3R2JoMDhD?=
 =?utf-8?B?R0VkaXNPT09EZTNteU9XdEtQYTRYZDZSenAxQzdDbUtDczFJOE9sbElpNHdx?=
 =?utf-8?B?bWx3MDVhMkIwYXd3ZXMvL1U0MzR2Vms4OTFsZnJuZ1VXVEx2RFMwd25FTTVU?=
 =?utf-8?B?STQyV3NVMHd5RDE0MGxSazFPdDdqUERnclpsekZVTkY2K3l5eGR6T3hicVla?=
 =?utf-8?B?MXV0YzlZN0NQK1ZNVmV5M3VDNDRDNjhDREQvRHE2K0xxS3Bzek82bEhCcDVq?=
 =?utf-8?B?VnhZSmx4N3N3YmlBaFZ2THVoT0FGSnN5QnpMcnNWa3dJS3puWFRGanZ2SGpt?=
 =?utf-8?B?VXgyRXlyZ1RQRG5kNE1BeTloOTlPenY0aUt1Q0tWQllYTWkzUnIzZHhDdWxL?=
 =?utf-8?B?WXZJZHRBS0duTUNBRW1TMVJjMFg2U2hPV3pDR2V2dWZUcE5aL0RXZnNqRnNl?=
 =?utf-8?B?YnAwa2VVVGVabFU2cmVEY0lvRllpbFVIaEZOREtoZXhJdkRJTm5EUnJYUURn?=
 =?utf-8?B?WkV0VVE2SWt5Q2ttK2RqWm1CZjY3WlVRcURUc1oxRkw1cmJrNEJ2ME9Pek02?=
 =?utf-8?B?U1JETHNIdlZkYlZodzdFamwwMHB3dHp4RFBzMDQ1Vm5xaU4wOGwvUmtleDNo?=
 =?utf-8?B?TWRSV2VROUN2ck5wUC9nemd0VGlvSzFQWnBNT01XNTZzUmQraXdZcDJ2NWtW?=
 =?utf-8?B?YU01LzR2ekRsSFpkNklxYVZRTFdDSitWTlI1Ukp5clhuUnF6RzRFaTVDSXdv?=
 =?utf-8?B?R1JsN0tjS0ZyUk1KVUF2QUZyd2M1ckNHam9IS1JjSGN0OEZublovOElGbWYy?=
 =?utf-8?B?RldKWE0zZjdPMk5oenZGUUpJV3QwdzhQRDU4Y3R2WW1ROEx6dFpHTkJqNUNG?=
 =?utf-8?B?TTVxUFZXWUlIWEFreU5UZFlvRk1rdkZBTUJoQW4xRVd3b3A4YlJZYmtWWDh2?=
 =?utf-8?B?cnVIN1haMStNVDcvVTN3YTFieXU2K3dDSlJpY3RGcXRHVm51Z1MvTzlHSnJS?=
 =?utf-8?B?dnpvdlM0MlNuQlBVTUUxRk0zZWZBK2wrN3NsNVJheTlvOHQvdFc0MnZTaFlY?=
 =?utf-8?B?V0tINzA2V2h1UlZVUkMrWUhtZlJ1dTBwWDNMSGNHYWhPMlR4dW9rclNIMTBL?=
 =?utf-8?B?VjFKcUZSZjRxd2pOOTAyeGJwWHd3ZjJZRUVtNENiV2RvM3o1eHRsK3d5UVM1?=
 =?utf-8?B?dEhCMjNRa0EzR0tFYmZQOXc1OXFhNlNuL2s3aGY3dzQ3ZCtKTUZXKzdJSHlO?=
 =?utf-8?B?WUEvU0FRMEtUaUt0M3JzWjJpYzVJbFg1anVBL1lKWGVCSkhiZVFQK0xlaXhL?=
 =?utf-8?B?ZWI2OElyWEpxUzBtdFM3T1JnSjVBNnpjYTJjekxITkJ1emN3WE56R1pTZ21T?=
 =?utf-8?B?NDlRbkpWOXpIYlloNDJDTDBGWE9VYUFPRE83OWdTVk9yS0o2MWlkdWdFY1VL?=
 =?utf-8?B?OG1rOHZSRjBPd1ZIQ2FOeER1V1k0V2d4dHpqU0xuYXRWZW5kSUNFUG83R3F1?=
 =?utf-8?B?Yjh5elVrdGZIOFlyZXpJOFFFTjJHMXZSWkRQV012TldtVVgzQmxIL1B6QXN4?=
 =?utf-8?B?UkJoOGw1aW1Yem40ckVFMGh4bDI2TTYyaHk1dUNnM3doUVg4bStqZGVMd3F1?=
 =?utf-8?B?ZWNVelJiT21XZVFDdHU0bkZGWStSdWY4K0VQWFRWUnRIYUNxbGs3SnV6czJl?=
 =?utf-8?Q?WJvJ1aVdlfz39BlY3S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62527d50-ff55-48b6-2f3f-08df2ae7f955
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:11.9775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAJSY4HiRsI0JFy7QfG+HifWNUwMHC2SsmYWPk7Tizs6E/5LlT4U/uF6uJV1HP7b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E28EEC0002
X-Rspam-User: 
X-Stat-Signature: pyhysxpkqt9hsbb4w65q67ahrfjepjmj
X-HE-Tag: 1792088004-102703
X-HE-Meta: U2FsdGVkX1+/G4McskLApBttmwBqZ6xgUzv2q1+7Y7bNLrZ82MBa/dP8bqakp3QLeOVtK8cwVF3ZVmQBfEt+h7QYjCjMOGeH0NQNjhY8Ho5cL88blWGMVDWRtBLAnX1jCAJV4JtdNOly2DWhOFJ2BHOiOPCp5+wnzHCXVZ+0HTNrA90aPo57+WioM2pg8PE001YXO92C4cYNOYLWv//iSv9Fi4YhH1mouQ70JMRQnqEoBUDfV2fgcrue8cxEhEufv8zm2hnKOHVKJqI+29qazt8N/S1KJpLpw+td1Q0BAFPe+zTKgD2QGKT3GohfdVYnVJhSF+FIDTxu2IvZ5u65DjyHLFGzg9Mgg/n8Zz7YncdE8jVSUl3j8mcgjFqlfBXcUqbIr+hjiYkmC6zxWcsydC2H12+ipzqFdR8GjMCnkqwsCd8Cr6C3vlqIwQpvP9unc1411LS9QEhK6j/Jvc9XhjZRICUtINoKoTnCrpTilIkq03zvKgViAmgf29wMrOTBMURktXkiFmDeiIWWf9szLZVdZyg7YfSWgHV1TGKDX5zRIcYT1kGZJoXyT7FgZuzXHs02L2UHMTg6Li6Yr82Cgf+6eDMd37pxZ+kwSQ2I1PsTs2Oc+XmWWYy6TcZK8oJyKDwefvhQtvU/pIHhQXPDXbBUrOAYminWpjxMIxP4aJViKpjXXt0/SAgUEvhTb3dXknZOhgUzb7OAOQk53ARM1G4OhtUXocN9vlrmGEQTpaK03NYiu/hNrnAFEmUDyrY755z5S5his6E5pokecZCJ3maD8ROnf9rDuwIf3mFaMzIcfyKvUIhYCH2jp3UJtZ28gLYNYfrQBEFQeKMXSycxH9qi986zq7nbEkWI1tXGx35xL9OuBI5WenT43NBb1jtjunRiFrf0a/oh7TD6gqdlfbPCFdE0hcrM84x+ScYsH9dHVxEQS+cSsWrUeQ1SYL1h9IhD+XltxNUvs93sxf1
 VWSLioZB
 l+xWWPen2xxFcirigYnlp/iL3C2unnAfCgjyKRR3u+TcS/8rRl7VsvGlhgviHWH1f+WZCnbriHtcQqDOZH309mW1RO8xF4vLvuLSx4fJem677ITu2oI0vUFQZasjR6vnmc+8mIwTQam7cwNht3S7ozDQfWKCQeXYbQOnoYd1r1G70ZdkbU1BfTNg55IyaoajV7SjjkZqWkkceRhqAvO7fyM+Xxh0+zvzWDn/mAK10by6XIRKLJsG2Sw0+2IJ2YrhuFXvzJbTbYnHryYmHB55ots8wgMA+ZDna5NbW567Z7AUKL2KT5QMe9RXggLX08aC4FrMuws1xsOeuXulPPkwAc47S+/t9s4Ox0ppP/lU/hQUZ+77i8luBkRKkPyvXJW1zU2tKZBG/rpwQX5ywnY1eaqR9XyJRy2HlJvoQA5eixjBwL04WIxCJkP6ox01TvJ+2AcsQhHn8aksAXwje7ICAeZghBgesfb9ylo4wa5Mjca44m1dJVqyXe7H8Gmt4sUy9GuRX2CuAc0DxmYB6yxC5AFJixsju9sklSVt9Qqmr6MQDrzBs3ITA7eFFoFnkakMIK3s687tZ/DSVx1SVSiQAQdAZZYCXnw7HYpPcUQrKMafUZNyTs1WKU7hEb4hWs6A888ZZtSw1SObD+yChrb/jc6C3Mk/vKnEmW0KZwnpF4G98P/Jqm3CJ1kfT8VOnMACSMl9JJBwVZXyevMO/DfGViS9ztZIiQSmxNNQqL1uWhmUzLiG5zSdpf8PMKrZ0OJdoG299
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmdp_invalidate() replaces a huge PMD with an invalidated one
(_PAGE_PRESENT cleared and _PAGE_INVALID set) and calls
page_table_check_pmd_clear() on the old entry. This decreases the page
table check map count. When the invalidated entry is later replaced with
set_pmd_at(), as MADV_COLD, page_mkclean_one() and change_huge_pmd() do,
page_table_check_pmds_set() in set_pmd_at() clears it a second time and
decreases the map count because pmd_user_accessible_page() still counts it
as a live user mapping. The same happens when it is cleared with
pmdp_huge_get_and_clear(). Then the map count underflows and hits BUG_ON()
in page_table_check_clear().

Found by code inspection and confirmed in QEMU (pseries, POWER9, 64K
pages, CONFIG_PAGE_TABLE_CHECK_ENFORCED=y): MADV_COLD or mprotect() on
an anonymous THP hits the BUG_ON() with both the radix and the hash MMU.

Fix it by only counting entries that are hardware valid, so an
invalidated entry is skipped, as the patch "riscv: mm: exclude invalid
THP PMDs from page table check" did for riscv.

Fixes: 641d47d4c963 ("powerpc/mm: support page table check")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Andrew Donnellan <andrew+kernel@donnellan.id.au>
To: Rohan McLure <rmclure@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..392474972777c 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1091,7 +1091,8 @@ static inline bool pmd_access_permitted(pmd_t pmd, bool write)
 #define pmd_user_accessible_page pmd_user_accessible_page
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	return pmd_leaf(pmd) && pte_user_accessible_page(mm, addr, pmd_pte(pmd));
+	return pmd_leaf(pmd) && pte_hw_valid(pmd_pte(pmd)) &&
+	       pte_user_accessible_page(mm, addr, pmd_pte(pmd));
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE

-- 
2.53.0



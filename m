Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62425CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C166F8E0033; Thu, 16 Oct 2025 16:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6D28E0002; Thu, 16 Oct 2025 16:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5B88E0033; Thu, 16 Oct 2025 16:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 980988E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:56:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FA4058FAD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:56:34 +0000 (UTC)
X-FDA: 84005185908.05.3854149
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013022.outbound.protection.outlook.com [40.107.201.22])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5053C10000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:56:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VCmcWrdu;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760648191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyjY3E/3V8XI0E2RdKSwYPQuUMKvvij2cD7tX0aZ/F0=;
	b=40c+hZ/ay1tTkLDnmi58TpXW027C4T27+D2xf7Tfl78obHalmmGnA2bTtbdQWVZG4BFtdG
	L15EJskBKp4oO0XdCqyEStlPeccaB1412huTkv/TG7JndIOjnQ5dmahPPRk8iyvnDcXuay
	KtESei38ifCJJZX2UfHtPCIGembS9rU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VCmcWrdu;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760648191; a=rsa-sha256;
	cv=pass;
	b=VNiu7wHBZ1/8dYnTZB/RJw5MsQiAUGChx2swSmiXr7TnNYDyswyUmjqV2yDZMpmtZOckvf
	SEonAUK4pWAUcdnpxFh15RrEkYREUwWrFVZ+mvsn2Bl061JT8cBnwTwgSYg9GVVtLpuro9
	O93acmx3r0TNYw7CUAe+rAy9lRZ78XU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBwnO0WLNN7YnURtHN25dIzmyf5G3tvBOLbD8njJlBMmmxCobXqhcWxBywvvxfgfY32V/C0lHK+GdPFheE6pIQgFmKqTE24/ErolZ6C+kCxLHKBJpzydll+l9Bd4y8CdCrY0OiPxmqVaQq5Dpd20qSimgT8NyV+1hjdgxeFMk4Fsi0+ieSeekMw3JonH/yM+kgw22fZiub9xLX6McxTxX6XjWef0Xsq/bFWznHpRk9kpIq7aT9toynsh1pWQxeBChidUTJe4Tipr8l57N9+Lz6Ag68pQjtc84yZ2CmS4UJmgjRDW27wc7xfBApjlIbSawepWvAOSlMeVtpJ/IadT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyjY3E/3V8XI0E2RdKSwYPQuUMKvvij2cD7tX0aZ/F0=;
 b=bfPxMDMuDCaRN2b9SLFtS4TjyEc889OJKlID9gFivO2K8oBZrBTzHi6+3OR+MgdkOutz6a6hZSB6c2ijuG0tZoX+Si0MfMQCdgXpwLrwMOicuxz8Ae0MOu4LJ9U9bRncEHE7L4uQZAdC82tBxwhovrXBIB3gVqOabcreti9IUZH6+j5SZ8mr4MRnUhvN8lyFhNdIzczNwfdk1dR69EB9nJVDdd9hh+mq4ttC2/cEWLc5MrnWxY4NjvPRyMnkkYBPqt/Y00V3hEek0r5FDgIF4X+RFh6Z8WqlLUFXXT9aiMA14Scvp9qvuhnlJ6su3XPoxLrqQlvhVWkeisZPTX835w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyjY3E/3V8XI0E2RdKSwYPQuUMKvvij2cD7tX0aZ/F0=;
 b=VCmcWrduaHychXrw/fNfPhILzHFxCsUUGKm4r6G4QDo9acr8XOKxswQbLIbOTh2aR90oCzamnIaP/sKc7JDIXWobWpv3ziFdKBLxfz/MgELQ56uJ5PFEV3pMlvvRUjbcitpBwr3BzYIfXXWkwR2W0nXwQ0nsbxdP6+3BLNdjalENgLNrTNshiV60hy1Pv1wNgtoPZJp+90GTIyxFMamysGIifV9jeKT7xjQ4GawDHCJcb/zqvXMJbQPxvt2jTWCPJkwlEgs0cklXii5T++YeFVlHQ4qt0okoF6YuuLgsUOPONjW7DyUEg+bZY2GEuqc+7MnTO/iXNeSaRnovt47NCw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB9065.namprd12.prod.outlook.com (2603:10b6:510:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 20:56:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Thu, 16 Oct 2025
 20:56:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Thu, 16 Oct 2025 16:56:24 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <A4A8FCEA-D1E4-4FC2-8734-52A7CC4B6294@nvidia.com>
In-Reply-To: <518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <99d5c245-3b0f-4b33-8d44-bc2b203a5a51@redhat.com>
 <BE1A9E45-A304-4A54-AA4A-C8ACF889262F@nvidia.com>
 <518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P223CA0038.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB9065:EE_
X-MS-Office365-Filtering-Correlation-Id: 314bebc7-dcb0-41c4-bc40-08de0cf6792e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTVhby9SQ0dLQ0liTmgrZVh5ajhORDc3ajVFLzV2OTgxSjcxSVZsY0xOdVFJ?=
 =?utf-8?B?ekZ1Mng1MGR6RWFoWFp1V3RnaUhySkJtNTFNSGNnU1Y2aEJnTER1eldnRnpL?=
 =?utf-8?B?amtGd0ZUT24rTGJ5NDh1dW8yQWV0bWlWNS9Fc2RMU1IzN0xEdXJYQ29wcW1K?=
 =?utf-8?B?dmI3dzRUdS9yWkRXZG41cFZMaW9YaVV4ZklTR2lFeGIxRXg0SmFQTURLVGJo?=
 =?utf-8?B?YVlDZU5lREV6MEtibnR4Tkd5SHFhTkMrc2dOeW9kSXZ6WDdkN25hcnlLN3Fj?=
 =?utf-8?B?OHlFSGN0TmVlZSt6cWJHTkRBSjVRR3NTbXIvTjlmZ1JHdjErUjRqNHNqQkpr?=
 =?utf-8?B?KzZRUVF3azRkNUZjZXJ0MmNBSkJ0TytvOUdGOEdPTy8xWFdCbk5DdWQwVXNK?=
 =?utf-8?B?YW93dHIyTHVrTE91eTNCQWV6T3MzTXhpeFkrd0hHTWNlWVRMTVVYQUM0TFRR?=
 =?utf-8?B?UjhWMVE1VDVVbGNZdVBsMjMxMC9vMWVreEpuVlMwRnAzaSs1RlE5cGZaeGNl?=
 =?utf-8?B?SlRhYXJVR1hoOXAvY2N3bEdHSUtVK2kvaE9naUNuUmZMREpkb2FJS0tuYWwz?=
 =?utf-8?B?NGV1QkRKMG9oNGIxK1BzcDY5ZmxBMGdHVktsY1NyZXYwcTNFOWFpY3gvWk5v?=
 =?utf-8?B?SnFYSk5iSGhzTHhUSERyMXJSQi85QmtSbXo1ODcrM3hLZkF5R05LWEZkN2dY?=
 =?utf-8?B?TTFndDNhZTQ2OWRFdHlaMGVqZmhhYWJWUUs1TEVHdm1OK2tueWRwdDdYWWNX?=
 =?utf-8?B?eVVZMk9RUlZGcDB0NG84YmFlSWZabVRqUlNHQ0RtR2FxOVZHaFFMa2FJMUpB?=
 =?utf-8?B?S2JEek9acmNpcE5RdlljL0w4NTZvM3JuQTNGc21OZWVPdWJDYzZrS0UzUFhl?=
 =?utf-8?B?R3FYQTRiMDVzU0FFNW5aZm90ZnByaTZ0K0xrTlFaeC9tTmt6SURPbXc5clVk?=
 =?utf-8?B?Mk9DUlpoUGtRVlQ2MTBvR3h1cFdKQkVuTGZlUjUxeGxOUHhqNGUwQnJJMnQ3?=
 =?utf-8?B?c21QdXpPK0h4S05rTzRnZzRidFpDbHFRMitzdUsreWlUT0RvdldzcnpKVDAw?=
 =?utf-8?B?SVFNcGowSWZTWERCa0dvMzIzeVRzWWVkMVh6bW4vOWdRUnVSaXBSQUhwZFBM?=
 =?utf-8?B?OUVJck9mQStNbGVJSGc0alhwWEhxMmp6bWNyaGZWWVZOUFBrbC93eXI1YzFx?=
 =?utf-8?B?UlNsWjJvMW5HMnlQOVBHclYveGttZnZBUkdkWGc3Z1Fpc2xIVG91bWtOSFVo?=
 =?utf-8?B?VDRnMUlWeGZsMFlXR2d1YjcwOVAzNmh0Mi8vWWVCWW5xQXU2c1VucXRDUHVI?=
 =?utf-8?B?MllRdm5naHd4WHZqTHJyVlJTWmFaclU0TzZ6NS9YZ0xjbTlGTUdvZThCaWxH?=
 =?utf-8?B?T05PRHVVb1NxWlo3aUlaSVNLN2grWklodGdnUkE0cDJhTTg3KzR4eDBkblFD?=
 =?utf-8?B?eW4vdGlBSVNkcVRKMS9VMG5QL2dvSE4vOS9Pc2RLYzlMS2FPOVpwaVBCTWN1?=
 =?utf-8?B?b21qR1YwSG1CckJZdGFkMC9WYlZ3elEyWThNcXg5R1BCdVJoOHdXOXVLcDZD?=
 =?utf-8?B?Si96Q29VWmIyMmJjQkQ2UUozYTRJQmsxODVQSEZwNU1zcGV0dS9UR09Fd2Uw?=
 =?utf-8?B?eHBJVlJzMFVyR3JkZXdZbHZLZlV3bFNwaGdKVGlkNXcwRE1MZXA1RmxmVlZj?=
 =?utf-8?B?Mk1MRHpxNkljaVRIc0VBcTJ2NUIzMVJyd0E1Z3VCd2xRTGMvRHhLNi81NEc2?=
 =?utf-8?B?aWxKRjhyVVhwdXhqbUVCemd6ckR6MlRQN2tDbGtydmFralA1RWFqSGtZaHpO?=
 =?utf-8?B?bndBS3V5MmRrQ0hNcnZFRk9rbzZwb01FdTltVHJQN2k1eTZMYmFuaEN1YURk?=
 =?utf-8?B?ZkczUTU0N1ZMWmpCNGVvcno5THlGcnpCSHJrUGlqendGekJvWC9kWm1RT3ds?=
 =?utf-8?Q?aPUoBNVZC9xLka76KEoo+7o/mO/C/EU2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S29BVVZjK3VWRDJGSmJ5T2NUY0RiZCtOdXVuZ2NON1RGM0hnVHo4aG1ZUmRO?=
 =?utf-8?B?WFdoS21JeUNnU0JNVGF1RzdJUWRHbGFDNDJSZlBERlIvclFyNnBvUTBENWhZ?=
 =?utf-8?B?VENQMDhmbHkwQ0tKSVp6UXNGTUVvc251RlRqdWZQU3JqcHlHVFI4YUFtcHQr?=
 =?utf-8?B?RkN0aUNSYWRuMjh3Q3BxWk9uNGZvTm1kRElMOW5sMTJpRld3eDkwSFZ6T3hY?=
 =?utf-8?B?dk1KUE9pTFhOTnJZeVdMNklQVUMyMHg2R0ZzUVJFcmowSnlHbzBkOWp3ZTc0?=
 =?utf-8?B?YlBRRWtIWi9Hc2dYcy8wSTE2RFdiN2RzeHlSc29CbjRWbWQwNTlKbk5jb3VS?=
 =?utf-8?B?b3FrWDZwdGw5b05ZTWRXMUxoVGc2M1BrL3IvajZBYmkzWExmYnpNeWlWVzlQ?=
 =?utf-8?B?NEVUNDdrSTNINlBUTG5LSGlzeTNlb1lMUWxlYlE4U1FEdDhqa2duMEhYczRt?=
 =?utf-8?B?dStjc0hTbHBNYzdmZWtGV1RRZDJjdDNWN0JIMW9uYy9DTXBmNitoV0dBemRk?=
 =?utf-8?B?MC9ZS2NEU0Vxb01ZSXJleXlpZHNpYlVOYTZOKzZXek5Odm9uWStwS0VnN3pN?=
 =?utf-8?B?RVZCMjZsRTJzMWhEbFFUOVdQV3ppWHg3bEw2TnBWKzVWY1gvdE9WeHdxOENE?=
 =?utf-8?B?dUFPbjloc25Wc1lUQ3JTL2JxMm9PZU1vQXFSNmFiMW9zVGVvUHBsZmVXVk9J?=
 =?utf-8?B?elFpTk0zckluQWt1YmM3QWJSU2tnN0hmNExYT2pPZEI5cXdQR1dYYWIzSkVi?=
 =?utf-8?B?eGEwMHVhU21scFNDd2JhTmxUWVBZbG9HZlVMNitwbUR0eDZNdGpEVDgwTmtJ?=
 =?utf-8?B?VzlsTXN0eFhPZjFYc2F5bU1qTkg0MEJhNmh2V25URTBEcDd1TUd5b2FJV01P?=
 =?utf-8?B?U1QrMDhlN0VqR1pXUmc1Q2Rya0ZrdUhtZjQrcVdDOURaUlB5MkltVnVRYVdi?=
 =?utf-8?B?K0pMcnZVWU9yVDhHZ29aTTk2MUQ4a29KdldyU0lpNmoyc01pQ2dxc2FFcUZX?=
 =?utf-8?B?UjJhTjRDUkdhMlZhS1h6TGI1dTVoVE43VHMvME5KOVdDN29xeXNhUU0vVUlJ?=
 =?utf-8?B?djJHVytMRGhybFMwVE1RVHZXeFludFU2ZklseklhZGpkd0xKVEE3YTR5M0NK?=
 =?utf-8?B?NlhDTTU3WkppMlNJK2xBMHR4QWFidVh1aXl2dVpjbW5mU2Y0WS9JZkdLOGFC?=
 =?utf-8?B?a3JRSlZMWHJESlVFZTh4bjBiWWRaVXpqV1FEMVZhTmQvN3cvSEV4OGJyUDgv?=
 =?utf-8?B?ZHVYeEVTQ1ZicnBOc1BtUW5MOWlSZUc1RVBzVFV1TG1SYjFOM3hiWG0xeWh1?=
 =?utf-8?B?SHl4VHRuRHNrcWF3Tk9kd0I4Qkdjb0NWVUZ0aUJITzlieWFLWjhpL0ZrWlBm?=
 =?utf-8?B?RVkvT05FK0Q5cWJmN1hPNC9MaXRSVi9IZ0QzZ2JuREpFZHZWcGp0WUpvWW5L?=
 =?utf-8?B?cnVnekV5NG9FUVhocVNnMWhEVkpVdE14Z1I0TURXcldsNTN3YWhUN2dRbitM?=
 =?utf-8?B?QWljOTVkK0xGNUw0K1BXWFVyTUQ1YzZ3RUZmeGZkd0F3WDBuVGU0eDN3KzhK?=
 =?utf-8?B?Y0VuaWordmc3VE1jSyt0SVd4TUNjTUZKemNxbFhWSVRxalZTRWlVOXhCcURN?=
 =?utf-8?B?OHdWRnlibGd0b21FUk1WWWpUOWwyS3VJMENFVFQ2bWZpWldEbTI2U2tyOXBC?=
 =?utf-8?B?TXJiQ1c4WGNrUzZ1ZW9WeFlKb2J5V3RzcWxmbk1zclBVajhVN0FKTFhtYVJD?=
 =?utf-8?B?dUF4aktndys5c2daTnU3cVZWUWVzdE9IR2lwZ1J5ZkZxaU9wQUU5SU53NVBT?=
 =?utf-8?B?Zm40YmplMzl4Ym1WOWN5YjJ0K2UxN1oyUlY2dnl2bWZhWExaNDQwRytpRG9s?=
 =?utf-8?B?aHlQT1VmWklBVkZKTEM4S1RvRi9oMVB5dGtuUURNSmFGcFNUQ01NQi90OHpt?=
 =?utf-8?B?VTF1L1FUejNSeHo2OFRmdU5Jcjk0c3RYL2twNlNpNm51MCtHdCt5Sk5TT2l1?=
 =?utf-8?B?clN0TVZlT1d5R1BuQ0lXaDdaWmQrSVpqZjQrOVdXdzhYSS94UGlKTjFBWC9h?=
 =?utf-8?B?UGtmeW43a1FaV0FpMG5IbUtQV3hZM2NBYjhqdVRnKzJERmoxY1NkaUR3Rkk4?=
 =?utf-8?Q?Kl3NQ4XP1CZvfpqeijtW5yDZQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 314bebc7-dcb0-41c4-bc40-08de0cf6792e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 20:56:26.8892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CA9YgGMxjbkeshZTm8mQL08Ctjjxpj6qdzuK9oMf0eORVJGgNRIJBIBXUW2lrwLR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9065
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5053C10000D
X-Stat-Signature: h9mggocs8sjm6eabcmhtumkgw3ozrfea
X-Rspam-User: 
X-HE-Tag: 1760648191-77248
X-HE-Meta: U2FsdGVkX1+UoGLzgUrBWYdoKDyN2gSNeOLAvrgsaxt25Vzf2cJ5eyiyAV0xvzizaJ6HrhVdM8loKRTCOuyAYQYf/ScWeiicXywPrAIURYcB7IZR3SEUMc5cNbZrUfI6B4HR6+eKt/i2lpyvU3SqWGNoVOjc8zVxOuhDpzXCWvg7SED8CBLJ4SZEV2/in918EQHs2sDujd8jLt+umfajpHoXn+hLekl9DehBTtDXwXkg8GGIPnc/OGdEea++zYUOp1hEGdAGVf1M3QlDN/2QFg/JxlCUoQLbGtqRjC6/wbAQHq+gCK9WiOmWmWS10EwjB8ngjM5VLovpDp45kLCgwOuRnbXMg9gqWPRqQFK+gbpIkKL5kp/zNGHaXiPVzMx4D/Tfya+4kpBwARl1dXHw1xhymznzeu7FtCwqiAcQLm4S82XQ7CZpVZ96WQS8MwPYiAtyPZgb/qAKf5h3O5Ow+0IiAE6Vs+3tLF6/m64ZwhGoAS0sMkfS3K3FJcess80O7Wz+g9p8ecLfnEE5csKkyDqqm/57Sn5cEUAC9jmhtTs7AdXFICgH2zuohSGtVgQwoEDJnEbIsR+L1WHpcQubC5NIrl3eC7jjYLFJxTh75nT78BpDMMLFy66h4Sb0uDF3f1X7k/BfmSo61/ggd7jTrxWF1zxO2m7K14qD9qS45Aw0QakqdO47wmAshrATAxbFZCxWnc9rKhjCHbZN8IzkCnR6yDxEy8t5/jUTHfvPDW0FH8XZv+zkFa3iyaNTKhPFU7tiFhx27AZdnlhxIaTNzIrRH67pFwSLK9Zu2NPDJ8TbGrKtDqyBTgoQi2qAx4Q7jwQ54wFpMc8KaFfvOHWzTlp+EB6xyZVU4s2osgaW48unIw0xtUfhBRRxzDgaEHjkMY4x1zVPj71dLz4vDwsMXydNwVvgGleNrxtssjzPVqKoKzFDKwj7oXE5YJO4DLtRMg+SSsSX4XEDT4LWYTg
 UEy4LPgw
 iW6t6SjkSLb/c/w/YUIxElxB6ec1sKelMv343e7e4PRX6CqIwleSnbgSt4gN7sk1Q0wAK+JVcoftn6q1TQ0EcXAMg49U9QzEuNxvEn2Eg10SowHaIR39uOv9iIeZd+Un9MyCMRfdrkjvnB6wJ/kKHVI+vCa1ElSj8Mvls+0E8192/2qbnB7xaDYnNAM+lQjTAUF3XoqUGyExIrC6ikrViwc0cP2KQRfeK8EXzBD+Ki18Bg57nwfdRGxMdoFMFZiSiTre8mrVYxpM4QTJb/wC0sefv55/enFCNUXTQelnfD+alU/FSWPeUeYex0L76KoWYGp5UznOEmGj9D1N9CvdRdtg3ZmNelBChMbRcYpWo26k+nxv1EHC8Y1V9XwHP7TDiARZO0J+ilqM7LpvGIl/jnzflSxIWE4gTZ8xQrNqfHPNEeq0TD5AzwnEw66KbD9oHe7SZ2D40moNBSjA11/6p/8mKKnct+H4WGJbqXpfZT2RuOupSoEZiQsGjhCXMtxLSr9uhzbVqtGB5v8GuJyiCydLRYYJUfjrXJKcq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Oct 2025, at 16:55, David Hildenbrand wrote:

> On 16.10.25 22:22, Zi Yan wrote:
>> On 16 Oct 2025, at 16:10, David Hildenbrand wrote:
>>
>>> On 16.10.25 02:46, Wei Yang wrote:
>>>> Existing __split_unmapped_folio() code splits the given folio and upda=
te
>>>> stats, but it is complicated to understand.
>>>>
>>>> After simplification, __split_unmapped_folio() directly calculate and
>>>
>>> s/calculate/calculates/
>>>
>>>> update the folio statistics upon a successful split:
>>>
>>> s/update/updates/
>>>
>>>>
>>>> * All resulting folios are @split_order.
>>>>
>>>> * The number of new folios are calculated directly from @old_order
>>>>     and @split_order.
>>>
>>> That makes sense.
>>>
>>>>
>>>> * The folio for the next split is identified as the one containing
>>>>     @split_at.
>>>>
>>>
>>> That as well.
>>>
>>>> * An xas_try_split() error is returned directly without worrying
>>>>     about stats updates.
>>>
>>> Why is that change ok?
>>
>> Before this, the code decreases 1 for the to-be-split folio before
>> the split actually happens, so for a failed xas_try_split() the stats
>> needs to be fixed up. Wei=E2=80=99s code updates stats after the split,
>> removing the stats fixup for a xas_try_split() failure.
>
> Ah, that was not immediately clear to me.
>
>>
>> How about?
>>
>> * Stats fixup is no longer needed for an xas_try_split() error,
>> since originally stats was updated before an split happens.
>
> ... since we now update the stats only after a successful split.

Sounds good to me.

>
> ?
>
>>
>>>
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>
>>>> ---
>>>> v2:
>>>>     * merge patch 2-5
>>>>     * retain start_order
>>>>     * new_folios -> nr_new_folios
>>>>     * add a comment at the end of the loop
>>>> ---
>>>>    mm/huge_memory.c | 66 ++++++++++++++-------------------------------=
---
>>>>    1 file changed, 19 insertions(+), 47 deletions(-)
>>>
>>> Skimmed over the rest and LGTM, but it's all a bit complicated to under=
stand.
>>>
>>> Trusting on Zu Yan here :)
>>
>> ;)
>
> "Zi" of course :)
>
> --=20
> Cheers
>
> David / dhildenb


Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA4BCD98F7
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB45C8E000E; Thu, 13 Nov 2025 19:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BDE8E0002; Thu, 13 Nov 2025 19:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D536D8E000E; Thu, 13 Nov 2025 19:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C28908E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:23:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 721A286FAF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:23:57 +0000 (UTC)
X-FDA: 84107314914.22.7B624D0
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5CE3140003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:23:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="GVU/6dr3";
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763079834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX3GLuFQzmaS89g5y/4ecplEqvkQGqhbuq86h3XY/9s=;
	b=yNYkJ4vEYEZ8R+PDMeQ6cE//ImVL746ScBFtCSBAvWn0EgB3gW6FXq9AJ0Z47N3rJOA4Fk
	uncDP3vF5XlRtvm16Z/jcU0glbRCvP5PuYxom+obnBpd9BPV6RuXa76+q8Ul7s9g1Mx16M
	BcqGGWhGSQXBQcgrjyzqOHFCzd8Jo10=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="GVU/6dr3";
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763079834; a=rsa-sha256;
	cv=pass;
	b=LsP8yytJqDqLNcHWqXhRSF9V4X7BjawKuaN44k+okoUL22u+DDFTln64zK3R6PNZsrWm7Q
	6ZUZMS/mR3SpY+9SpmlN6PIMJ6gc+NyhN4lgScvEZ7mJ5L981F2j2p8OS5BBUMtyHnR/Z+
	YZsBDU3jRFDlJ6yUHqnrlhIK7SBcSlU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=En+Pba1ZhuuPhcGBZBdZQbhmy+aLpHahVymgSJYmFBTRQ5S4iRLvO4ug5Mx4dK6jYlb7JzHNG5BM2vzi0O3nTzCtDLvEbIZ5YPnjdmn0/fERulYTunpF0vxndOGS4HdB0agz2inHFXXuhNlaXtIiKrsvN3D0BLUNsZPeZHeNio4O4jB9IzPYAVIl+eAL4f1we0E8eIYdVUTnYE6veRtb1scgiFkBrwa3QI4iTeU5aV8r/64xq6dQyX4iVklSrLLo9S+xqeLwo1tHTAaF94DsPhXeoSO1Vfe+RwGy1WKoaWC9oOh2fgs9PVzRdTQPFJGc6ZxIuCj5nikU23EIsfSAwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX3GLuFQzmaS89g5y/4ecplEqvkQGqhbuq86h3XY/9s=;
 b=FObxYmaED1o+JLjyTr0X9u8l4TBWRX8V0L4k9QFA53c3FlznGJG/ugYJ6bRiR+NS/knRbLIs2ywPlHIvsjBQln2bFEQ7rgJ640FqiWuVkZhVJGc/eEI9SYzXEMVM7OdaOJksw944iyck41hwTJlKnf/6j7bxtjBWL0pn8zCYUQmrzKsA1XNI5vNZb0BuutSlx9oq0ACWLOOhoZqvZIhay+njWpBsK4rAENpK9vEu3zi5tXnZpk1ptGGjr2p6qPeEXYEXhjpeqm7/gytusW/5hlS5cL/Pz00fLmP+iQiouGPowbNENLzdux84xrSC8X2WenJha2yFr2BHtARmbXD4ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qX3GLuFQzmaS89g5y/4ecplEqvkQGqhbuq86h3XY/9s=;
 b=GVU/6dr3SJE/qQAg36G6AnKMN4DokuqgpV2/Vo95naWd0oen7Pk/SG5ooOAlDFoQzTFBZf0lu5jxNi4Bq3hIqC5n/zBslM39Tk+vRREOJ5oiKNf7CRMI4LFtp8hGYmmSg725aFk1QxvM+bogC9R4R8UeIpIC/vnr0MJF9eeRyWLEVDIPotHYct/fW46xVbQds7V65UC4mxDLpU3RhlFBxBJfUN/394oeA58WihBQBIVT/8yr/NwwQ2Xtir6rlEOf8smkMT4EtdwF6Y6HmrVo/Izf7eZG4RbwRtmmKwsJ2QqXYYnY5SfsFyvP1LYJbNvYDLTlWTsGZ8AjMmM04vd/Uw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB999082.namprd12.prod.outlook.com (2603:10b6:8:302::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 00:23:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 00:23:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
Date: Thu, 13 Nov 2025 19:23:48 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <56BA0323-C976-40D3-B61C-D698FA0720C2@nvidia.com>
In-Reply-To: <ebdf1926-2e9b-4226-b80d-4f9975f72f7d@nvidia.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
 <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
 <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
 <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
 <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
 <EB4C7FF1-8350-43FC-B879-20EA0E733F09@nvidia.com>
 <ebdf1926-2e9b-4226-b80d-4f9975f72f7d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:208:237::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB999082:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a651536-cc64-456a-9286-08de23141652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0tsS0RDQzhZNjVCMGNudmFKV0JWbnlCT2dFWUlWMWEyU2Z1bmE4SGY0dEpx?=
 =?utf-8?B?OU15Y2o4M2VramQwWCtrZGpsMGhFS2pmbzFXMkdyUlpTS0R0R212Qmd0MWwx?=
 =?utf-8?B?T2xRUzBONVVmUk1pdEdJYjA1elpuckV3dU9SWjE0T1MrM0dBa1NyalNtMVE2?=
 =?utf-8?B?SjlFQjR3L2wyaDE2dEVtZ0lvbTh5RGI4WVhnMEU4ckRjOW5ab3cxQ0JpUDB5?=
 =?utf-8?B?NnJkeXVSWE5nVXRvQXNDU3hRSzRnUzFHZzFXSzM5ZzNqS3ZJNWNmWjU3UkhT?=
 =?utf-8?B?NlA2T0RGeS95d3dmYm1zSjJ2TkhHeWovQkMwVU5BTVdJVXNlVVZIQ1BKVkgv?=
 =?utf-8?B?NEhDYnU2VENEVitNWEZxY0FnYTBNOVlGV0tXZjhJdmgwQ3FDOSt6bmc5Sm5I?=
 =?utf-8?B?ditZbkhHN05WczhZd1YvVVdqbXlMbVJCQTZQSjZ4WGZXbWZTd0kvWTRzaDFP?=
 =?utf-8?B?cWd5WGtRNi9BblFVMU1xTFRsUUpYK29VeUZUQ1dXV0VFOW01cWFWend0VVJp?=
 =?utf-8?B?d2lrQ2haelRGWW1sVnExczlham1nUU9SdlhBM0tZVVR0M2tnSkorRXpNNmwv?=
 =?utf-8?B?RkM5NGhKM05WVlY0ZWpMelRBTHdBdXNkbDB6VFZBRXJjYXl5ZTB4NEFtOExw?=
 =?utf-8?B?b0wvSmlkYzRiMzlrbCtHK3pTK2drMXo3TWVDUmpJQXE2NkxTcjl5aFB2NXQ0?=
 =?utf-8?B?WWV0NUlsRnJnTWVVSHV3STRwUDcwZmxlUmJLTGxNY3czVGR3aUNWMzYyRXhW?=
 =?utf-8?B?a1hiVFA2akVWblcyWENjOXpGVVlKa2prWm9jMTA1MG10L0NTN0Y5ZitYY3hK?=
 =?utf-8?B?bmNEZWtZTDVKSGpHSkVRMmVCTlpyY1NWeVppSWgvWkI4Sk9JWmkrMGkwUUpX?=
 =?utf-8?B?K3ZGbnZibjdNZ1JTTFZyMWJGOGlLaDdTRzZNUDN2OFAvSFpqVTVqZEh4bUlC?=
 =?utf-8?B?azA4dWppajJsRC9lNmFLbXdwc3J2Uk5BRFAwWDFlSG1ialhrYUNHQXlyVXIw?=
 =?utf-8?B?VTdkYmlBRjVnY01UMVhtMVRVemdEZ25STjZmc0MwQ0RXSFhGdVgzU3NDRzlr?=
 =?utf-8?B?MFkrR2dBWTlPQ0RhdzRVbUZ5QmQyRlBDRU9MWFozSk84RSswUWtPOEg5em5Z?=
 =?utf-8?B?N2J1V0V3QzRRckR6QnBpczIzSW51dHppQ3lSOEZYKzM1YUtFYjRQRjRjbWQw?=
 =?utf-8?B?RDhkS2ZPZjN1UDliT2xkMnpXMWNrQkZFdGhvcTBNRXFOaGF1ai95YmNVRHkv?=
 =?utf-8?B?ZncvdzNoZ21HUHhBMVp4ZytGNUhxQmFkL2tPTGswQ2NPTFRnUnAvbkNuR0lX?=
 =?utf-8?B?UnEyL01Camx5bGF0MWhURGZDM2pLZ3lYWHlIMk9HdW5peWwveUVNb0xtZ0tC?=
 =?utf-8?B?UHJjbW5Zb0Q5ZWVjK2hxMUZVUmtVV1lXRmJhbXZsbWZhU1BQeU9rUmZIS01E?=
 =?utf-8?B?ZnJqOTVMSlp5MzdvQ0k2RXRCOGU3SFR3UlB2ZmZLVWVXQzZEQXgwYytpdEFH?=
 =?utf-8?B?VUZQSkt5cUR1T2F3Q3BRNG1QZ1kvUE1rYnBqR3ZrNkN1UWdUWExKUnU0ZnZE?=
 =?utf-8?B?d2RIMk5nd3BYRWdVSXJ6SStSdHh0SU9idEJJMmVFVnlSV2xjMVI5TDlHWjI2?=
 =?utf-8?B?bDRxQTREQ01FWVdhaFJwQzd4VW80dlMxZTFmTURITGJtbzhOMzJFQUF5UHdi?=
 =?utf-8?B?aU5ndURSS3NGVi9Rd1RnSVo0bU8zcU9NaDlPWTVjblEzenhUVXlxZWJDMXRi?=
 =?utf-8?B?b3E4eDNtc2RLS0trcVhsMVpmZVcxK0dHL1MybGZhVFJGUFhqUFVMYTJ5a3BJ?=
 =?utf-8?B?NXV5d1JQV2xyYk9CSStpRlpOQ3BFZ2tnQk1OWFdFUHZFeUNXVzJsTitsNSsr?=
 =?utf-8?B?d1hwNjM1RDVKc3p3RE9PSjZYTXZScEkxNXdaNVdXU3BnanJiYjdQZmtLc2hX?=
 =?utf-8?Q?UxkKq5GuV2rHOUrAA8JFUaqPDG0OFKd2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THdmU3BuR1d4Q3c0Z0dmaHM1SFpKMDVZaHg4NkdyWHMrVGV0RWswN3pVcW9k?=
 =?utf-8?B?Zm80ZmtueHhpc0h3K2NCK3d0SGozUVp2Z1BoSlZzQ2VhcXVXbDFhdUZGQy9w?=
 =?utf-8?B?dHlEL0tjR2NLeFpibE14YVZITHozVTRhT1BEOWxsb3VwclIxbnFFT1ZIMWxX?=
 =?utf-8?B?K0ZUUHh5Vjc5ZnR4TzdpbW1BYUdCUWtxbHA5dWMvUDhlSHBndzZuRHlubFRZ?=
 =?utf-8?B?TEwzN0RkbnUwY0sweEdjZlpzZGFSODNRZHMzU0V4d0FsNVNmNkNlRFpLbVRN?=
 =?utf-8?B?SWppNGRkK1M5Y2ZLM0FjQzVBelVPcEQ1NEFCZHRLVWNQekI4c1RPUXA2WUtz?=
 =?utf-8?B?OTI2VXNaVXdHUVFPdXVQeGtReWt4QlZEMk11YWNKOTUvTEVXYWdCUGdydmdU?=
 =?utf-8?B?QXphSzdiRDFra0tnbUdwaGVHa0EwOU5IQnNGcmpWQmFKaERnZFRRcHVYSzJw?=
 =?utf-8?B?RWYyUW1hbmFvM0RGSXlUZG1OM1E0bkhFMWcyRTlBOWN4SVd4b2lSY3YvZVNQ?=
 =?utf-8?B?bkFtUXM2dzRvdmxGSUNTYklkMzNQN0gxMTRGWFlsNnBZMm03YmRHWXprRjc5?=
 =?utf-8?B?eUZrZ2VUbnVJSnhXcXRIc0hnelFlNEl3enpwWVN0RWoxdkZvdWY3WW1FR3dn?=
 =?utf-8?B?djRkQS80ZlVyeVZGOG5mYWN5dXlyeWNQbmgvNkREdWlnZUdBWEdWVnFhQkg4?=
 =?utf-8?B?Z1U0cFlUTXI2UC96eWpBR3NIcndsVmpMSDN0OThBRWV0UHNMeTRyci9EbE9i?=
 =?utf-8?B?SHZrNWZuK3J6TjJNc0FSRWVsRlhPa0JINjc3dk16TVNqSjhNeHFSdlNQZm0z?=
 =?utf-8?B?VURaZEhxUVVmYXFkS1NHSkE5NzNZODc1cERTZDFLcXU3OFp5cHZuMUtyUnk2?=
 =?utf-8?B?Q0lWSHFRdElGL2crazdXdlNKWmpTN2NBQk8yKzA3Y0xlNFR4MWZmR3psMmIw?=
 =?utf-8?B?UHl1Vy85MUxOR0tEUitlQTlodU00SkNrNmVYMmVFcnJBQUp1L1c1UG4yc2pX?=
 =?utf-8?B?OTVzc2I5MXZyTkZnb0dLZXZnOGZuVzk3cE5EWkRrMEthWmJvNTlpeVF6Mk1v?=
 =?utf-8?B?aXFxYzdGYzhCbGhWU21HZHB1V1dPUkpsQlhWSFRMR01zdkpPV3ZFSDNPMEsr?=
 =?utf-8?B?SmxSVFNHQWQzV0I0eVpUeVhQcnZkY2xPZWRLWXZpdnlnTVZlZ2JZZ3VnTktC?=
 =?utf-8?B?dlZSSytENmg4ekpWNG1uQWJtTUR0QWFmQVdZNEI4ZStlY2hkYXNYKzIrNTRW?=
 =?utf-8?B?ODh6OUszQ25CS2tjM0lKMWwrQ1ZKWlc5N2JBSGpjSmJmZndmUXpGSjhRSlIw?=
 =?utf-8?B?RlJ0dHJpbzdPd1pIcjNBS2RYM1RsUFRpRzJSUjFTdU5nZUNKdzBiNFpSRHI5?=
 =?utf-8?B?MGJjVUcrQjZ1TERjVXQzU3QzZ0Npekg3WllJUXZvbG5yRzVOcjNWb3JickF0?=
 =?utf-8?B?UmlvNkVES3BvRTkwdWZ0UXJqUjhJaHNvK2dvMUZ4YVVnZ0tRWjh3UVFwL2ZL?=
 =?utf-8?B?bDYzMHllNXBUSVFtRjViNG1jUlZqSWYweTJUMDlKN2VZVy8xNVZuNW9YNjRy?=
 =?utf-8?B?RjVNakdISWM0NmdXNGttYWZ4RDB2RmhOZFNaK2dXVmZCUXp1Sjl6SXJLblc2?=
 =?utf-8?B?WU9wRVRXNkFsZUduYkR1R29jeEVVWjFwTzVRNXJoVVdHeXlDUjIwRmtiaGlD?=
 =?utf-8?B?YXRkTDRYWHFFaThUT3BLVGlYY250YlUyMW5SUkJTV0JxMVorQUdiRnk2Z3FQ?=
 =?utf-8?B?VEtmbUgzSVJ0MVNKYzhmc1NlQkVReUYycHJMRjJnbDlKYTNmbzhrMEFDc2pE?=
 =?utf-8?B?Q1BFYllGNXdHRk1zakh5SElKUHdpQ1ZJaE80emcyeEhSZ3dJM1NUelpkUEFj?=
 =?utf-8?B?Ykp1dHNka25OL2dnOVNjU1JIVjV1WGNkVG9JS016ZHdJSWZjekZEaXFtOTJy?=
 =?utf-8?B?MWpUQzhBS2RIeHFER3kzK1hKT3RXYjNzUWtRTU0xc1h4ZDF2bk1wN3U5NXdi?=
 =?utf-8?B?S1pic1FLSGNtd3ppdzE3ZHFvMFIzUlgvdzVWaGxCa0YvKzdsWHg4dEROZmxh?=
 =?utf-8?B?R0JCekRxbDhMTkpqOUtnWVhsYkVRS1J1YWhjVUlJTC9uNmVpdWdXMTVub2ZW?=
 =?utf-8?Q?gT8uo0dG3tAfA1L7nWiaOkN68?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a651536-cc64-456a-9286-08de23141652
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 00:23:51.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kSUNlJ/SETeXZ7t1RBcDQVsP5ji8kx2c75yF54UX4QYfpc/dYdwyKEcs8F9pY21
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999082
X-Rspamd-Queue-Id: C5CE3140003
X-Stat-Signature: c4jpkjeijpk9hx7ixo89i6xggunzyqri
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763079834-536071
X-HE-Meta: U2FsdGVkX1/C+JYCIY9uww6+TYiO4UmYdeHurHqUkA3uDiQBxugzjo7joBNoHM68DrQf0XWXEKlifht3LTiWdTWJZwFfL1pCjH+5wYk15J1ifPtqJukbVtzCnl5nLvh3b5beu0RB7hDIL5UqTAgsuP6bjpGyQ3F5xnRA8iY2Gha4rZmNhggnxYxn6Qi5deAhBkrT86eIDYElnGbXqQsLuNOMfMVSKrov3Hr1BBwplMrrrEfXLq86QLIDq9PHphDLQ1CZso0nWNxEWAD9s2+T0uz3PInHaQ86FtVrKI+ElnJ2ucPQUEi764l1cNp4sdm2hitJJgRk5LOGTsHRwAEFUn7naBYKzKX93Y/1K3EJOLO81yYAw483hjCZziPFEHt9Kovd92iAsa4gyXiPW8CaLxtiT0kzxzocRASJtk+EYdvheuh7szBfnSdGnsSKWZmLU2D6HxHrr2FvNJbE90FFkZqMuRY90GlqLW+sPKwJZyaQjieRlroUHZSpBeKbM6VbeNYmHnmvLv/XFQxOwWNbihpB9gjnIYxWSqLZnFbdD3s8FIEEjrwA0CfAZa4hu9wKDDSm/dTMaWFHZsvymZwBDm9A82SA80pnRwyNqru94lJbGcnBPpyfX+M2kj3s3gHQckBvEFSC/QvDfH3SnRuyyLseIRYxmADuRNBlP/60+MNlhc6lx+hUE87TjCR7d5Ys66iMZxnhM8wSZqYztBv1i0QCgqts3GZJlcuaA/QUkNqJYQfOmuTuDD1bDxWpIBConJFadYvCFA+oPI7HgMdutt/iQmCtHv1V2MjLUqWAgPnc0M9mhko57IVnEtLACiwRsPFfFBVUhDB8+4nGQQfFSkXMr0tP9jLmYi8ufQPgF+Jwv3rhJ8MF6RdMTxPCDQOwR8LpltjxxYJ8/3HP5oH6jDP3uIgL5vkGbeVwwXtXxHFK4pkfNILOfpU1CEcE/HLVve6+AV1QGFbbYX7Wt8y
 jhwXptZH
 oogXyh92X/A/Ybeg2zQItaDwFQKL+eZ5S1OoMpWNmEQw9F98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Nov 2025, at 16:56, Balbir Singh wrote:

> On 11/14/25 08:45, Zi Yan wrote:
>> On 13 Nov 2025, at 16:39, Balbir Singh wrote:
>>
>>> On 11/13/25 10:49, Balbir Singh wrote:
>>>> On 11/12/25 22:34, David Hildenbrand (Red Hat) wrote:
>>>>> On 12.11.25 11:17, Balbir Singh wrote:
>>>>>> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 12.11.25 05:46, Balbir Singh wrote:
>>>>>>>> Unmapped was added as a parameter to __folio_split() and related
>>>>>>>> call sites to support splitting of folios already in the midst
>>>>>>>> of a migration. This special case arose for device private folio
>>>>>>>> migration since during migration there could be a disconnect betwe=
en
>>>>>>>> source and destination on the folio size.
>>>>>>>>
>>>>>>>> Introduce split_unmapped_folio_to_order() to handle this special c=
ase.
>>>>>>>> This in turn removes the special casing introduced by the unmapped
>>>>>>>> parameter in __folio_split().
>>>>>>>
>>>>>>> As raised recently, I would hope that we can find a way to make all=
 these splitting functions look more similar in the long term, ideally star=
ting with "folio_split" / "folio_try_split".
>>>>>>>
>>>>>>> What about
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0folio_split_unmapped()
>>>>>>>
>>>>>>> Do we really have to spell out the "to order" part in the function =
name?
>>>>>>>
>>>>>>> And if it's more a mostly-internal helper, maybe
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__folio_split_unmapped()
>>>>>>>
>>>>>>> subject: "mm/huge_memory: introduce ..."
>>>>>>>
>>>>>>
>>>>>> I can rename it, but currently it confirms to the split_folio with o=
rder in the name
>>>>>> The order is there in the name because in the future with mTHP we wi=
ll want to
>>>>>> support splitting to various orders.
>>>>>
>>>>> I think we should start naming them more consistently regarding folio=
_split() immediately and cleanup the other ones later.
>>>>>
>>>>> I don't understand why "_to_order" must be in the name right now. You=
 can add another variant and start using longer names when really required.
>>>>>
>>>>
>>>> Ack
>>>>
>>>>>>
>>>>>>
>>>>>>>>
>>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>
>>>>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>> ---
>>>>>>>> =C2=A0=C2=A0 include/linux/huge_mm.h |=C2=A0=C2=A0 5 +-
>>>>>>>> =C2=A0=C2=A0 mm/huge_memory.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 135 ++++++++++++++++++++++++++++++++++------
>>>>>>>> =C2=A0=C2=A0 mm/migrate_device.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 3 +-
>>>>>>>> =C2=A0=C2=A0 3 files changed, 120 insertions(+), 23 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>>> index e2e91aa1a042..9155e683c08a 100644
>>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>>> @@ -371,7 +371,8 @@ enum split_type {
>>>>>>>> =C2=A0=C2=A0 =C2=A0 bool can_split_folio(struct folio *folio, int =
caller_pins, int *pextra_pins);
>>>>>>>> =C2=A0=C2=A0 int __split_huge_page_to_list_to_order(struct page *p=
age, struct list_head *list,
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int new_order=
, bool unmapped);
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int new_order=
);
>>>>>>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned i=
nt new_order);
>>>>>>>> =C2=A0=C2=A0 int min_order_for_split(struct folio *folio);
>>>>>>>> =C2=A0=C2=A0 int split_folio_to_list(struct folio *folio, struct l=
ist_head *list);
>>>>>>>> =C2=A0=C2=A0 bool folio_split_supported(struct folio *folio, unsig=
ned int new_order,
>>>>>>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned =
int new_order, struct page *page,
>>>>>>>> =C2=A0=C2=A0 static inline int split_huge_page_to_list_to_order(st=
ruct page *page, struct list_head *list,
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsig=
ned int new_order)
>>>>>>>> =C2=A0=C2=A0 {
>>>>>>>> -=C2=A0=C2=A0=C2=A0 return __split_huge_page_to_list_to_order(page=
, list, new_order, false);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 return __split_huge_page_to_list_to_order(page=
, list, new_order);
>>>>>>>> =C2=A0=C2=A0 }
>>>>>>>> =C2=A0=C2=A0 static inline int split_huge_page_to_order(struct pag=
e *page, unsigned int new_order)
>>>>>>>> =C2=A0=C2=A0 {
>>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>>> index 0184cd915f44..942bd8410c54 100644
>>>>>>>> --- a/mm/huge_memory.c
>>>>>>>> +++ b/mm/huge_memory.c
>>>>>>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *fol=
io, unsigned int new_order,
>>>>>>>> =C2=A0=C2=A0=C2=A0 * @lock_at: a page within @folio to be left loc=
ked to caller
>>>>>>>> =C2=A0=C2=A0=C2=A0 * @list: after-split folios will be put on it i=
f non NULL
>>>>>>>> =C2=A0=C2=A0=C2=A0 * @split_type: perform uniform split or not (no=
n-uniform split)
>>>>>>>> - * @unmapped: The pages are already unmapped, they are migration =
entries.
>>>>>>>> =C2=A0=C2=A0=C2=A0 *
>>>>>>>> =C2=A0=C2=A0=C2=A0 * It calls __split_unmapped_folio() to perform =
uniform and non-uniform split.
>>>>>>>> =C2=A0=C2=A0=C2=A0 * It is in charge of checking whether the split=
 is supported or not and
>>>>>>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *fol=
io, unsigned int new_order,
>>>>>>>> =C2=A0=C2=A0=C2=A0 */
>>>>>>>> =C2=A0=C2=A0 static int __folio_split(struct folio *folio, unsigne=
d int new_order,
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struc=
t page *split_at, struct page *lock_at,
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head *list=
, enum split_type split_type, bool unmapped)
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head *list=
, enum split_type split_type)
>>>>>>>
>>>>>>> Yeah, nice to see that go.
>>>>>>>
>>>>>>>> =C2=A0=C2=A0 {
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct deferred_split *ds_que=
ue;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 XA_STATE(xas, &folio->mapping=
->i_pages, folio->index);
>>>>>>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *fol=
io, unsigned int new_order,
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * is taken to serialise against parallel split or collapse
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * operations.
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 */
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!unmapped) {
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 anon_vma =3D folio_get_anon_vma(folio);
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (!anon_vma) {
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EBUSY;
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 }
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 anon_vma_lock_write(anon_vma);
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 anon_vma =3D folio_get=
_anon_vma(folio);
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!anon_vma) {
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ret =3D -EBUSY;
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 goto out;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 anon_vma_lock_write(an=
on_vma);
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mappi=
ng =3D NULL;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsig=
ned int min_order;
>>>>>>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio=
, unsigned int new_order,
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto =
out_unlock;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 if (!unmapped)
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unmap_folio(folio);
>>>>>>>> +=C2=A0=C2=A0=C2=A0 unmap_folio(folio);
>>>>>>>> =C2=A0=C2=A0
>>>>>>>
>>>>>>> Hm, I would have hoped that we could factor out the core logic and =
reuse it for the new helper, instead of duplicating code.
>>>>>>>
>>>>>>> Did you look into that?
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> I did, I ended up with larger spaghetti, I was hoping to look it as =
a follow up
>>>>>> after the series with the mTHP changes and support (that is to be de=
signed and
>>>>>> prototyped).
>>>>>
>>>>> Looking at it in more detail, the code duplication is not desired.
>>>>>
>>>>> We have to find a way to factor the existing code out and reuse it fr=
om any new function.
>>>>>
>>>>
>>>> I came up with a helper, but that ends up with another boolean do_lru.
>>>>
>>>>
>>>
>>> Zi, David, any opinions on the approach below?
>>
>> Looks good to me. We might want a better name instead of
>> __folio_split_unmapped(). Or __split_unmapped_folio() should
>> be renamed, since these two function names are too similar.
>>
>> Maybe __folio_split_unmapped() -> __freeze_and_split_unmapped_folio().
>>
>> Feel free to come up with a better name. :)
>>
>
> I had __folio_split_unfreeze() to indicate we split the folio and unfreez=
e at the end, but
> it does not reflect that we freeze it as well. Looks like we are trending=
 towards folio_split
> as the prefix (IIUC Dave correctly), I like your name, but if folio_split=
 is going to be
> required then may be __folio_split_unmapped_unfreeze()?
>

OK, if __folio prefix is a convention, how about
__folio_freeze_and_split_unmapped()? __folio_split_unmapped_unfreeze() soun=
ds
like folio is frozen when the function is called. Of course, a more accurat=
e
one would be __folio_freeze_split_unfreeze_unmapped(). It can work if
it is not too long. :)


Best Regards,
Yan, Zi


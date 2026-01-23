Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A671D6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74096B039F; Thu, 22 Jan 2026 23:27:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A836B03A0; Thu, 22 Jan 2026 23:27:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9556B03A1; Thu, 22 Jan 2026 23:27:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73FFD6B039F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:27:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3F10C2897
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:09:54 +0000 (UTC)
X-FDA: 84361749108.23.D4F5906
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011014.outbound.protection.outlook.com [52.101.62.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2367B1C0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:09:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pmk7QDmu;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769137792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMRaaueU64RXWPtbDxqf25Qe0llFU9MlwPcIheP9gZE=;
	b=da1r22b/yRCEHB1ox5P0DmUpNK4buGmgf3cgamjHofJDcWZ6CjhTZOZJcTx1loKCdb07B9
	HHzS0WnSmbrM8Y+4/OMnYDQRIRW5VTw9SzL6dqs2jZvOjSbZiaf82y0BraqegQKNh3bB67
	u2zR/nsB8K0yHeAz/Wwv+vHNuIuKeAM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pmk7QDmu;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769137792; a=rsa-sha256;
	cv=pass;
	b=u5fxBnUdfQrMiZeQW5Z0yZ/WhkWpx4oiHuGm/Tow2v0NMGpkC2yXEf8mXIzJNBCZIPyRck
	eP4LcaRAeNwN+2Smyz4pLgzzEXrsd6cR8Vgu5uVZUKhiv4d9YEy/N31HA8jWKmeMcgfFiJ
	6BWQsRWS8iaCgl6OgCP+bEi2N+i7uvU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HeOPbkstp28HMzqaMAKmOlPVdnzWhOSF4OvW+v2usS7kelSsAIKu3V9l32l1qXbTuKyn7zLXVD7xQbFKqie+R8sNYd1ukkZN8yc34rVOYn0MiycaPGah5wY18lfh3/AW2m3BhC0X0J+t9L2Hz5J77A2kohHWCs171K7b11YWftb/Qxgz0ZhYrG7AS7vmZvbSgZ/IVjiZUlQ0/cs5uu03uClguutV2onsiRbI77XvgGIutM/PM2X9LIHD1EmaAT91Z7lrIfdO+geVw4b7UYcbHUdOyUZCCHTIdp7/Vk/zOm8JByzu4vqSYDMjGsOXc7QBzEM/WZJKvERLD1yXRGLEow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMRaaueU64RXWPtbDxqf25Qe0llFU9MlwPcIheP9gZE=;
 b=PB95TuxhSYJNnSenlMovbmWZ5HwwznjlbB1SeNp3Sqr388siAzGJvHQniKh3Se3tF674hXDOInbTHbEQhxYi/QvP70WUtvxhi45mUYbQTkTuGj7YPjE9RGqgRAUcRv177Y9PD+iKvsceLrp6iUTewGCbgT1wSnKK0iGaPsNt92lHWRkHgd7dCqkIR/awjJXJX9KK8Q2FvBeRO5FY7Q0eNtr76nd1oB82N/0ECce6zNo9XpYvuAMgFtteDurY90R72auFwVJWHA+67uqTN0kY+yghraC1rsaplsvbTADHZEMlIbo87rsYL0mjxNUoWbcjqRJiwjNwmDL4wVPlVZwZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMRaaueU64RXWPtbDxqf25Qe0llFU9MlwPcIheP9gZE=;
 b=Pmk7QDmuKxMP+o7czJfqyJXRt2OGQJirT68uuThzgD84mgXra4dYz8HJe/Gl1nSuK0llrIiOeegSjaCPCf9NgqU9xbiMeiKGG/Nh38JalgklnF62GlR42aZqTE1Gcw3cpjXajPfvOTTLKA36+wodWPPfUWgym/+w2lU21IrV6Kc2bTcT6K2RJrD9Xp4DbkZWCvLvwn/JvJO2ZRnrnw7plJm6f7BZ87km0X+HT+ZYWbROQEXUBLokZWlHzErrAVNYaXrDj4fxsxkQpDGEJy5rd/aeRSCfSXJHmLpHV3hWp5BBJMsiNVk3UK98w4fJunrH1sVE1ocGsHTuHC9TZhyhKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 03:09:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 03:09:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Jordan Niethe <jniethe@nvidia.com>, <linux-mm@kvack.org>,
 <balbirs@nvidia.com>, <matthew.brost@intel.com>, <akpm@linux-foundation.org>,
 <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <david@redhat.com>, <lorenzo.stoakes@oracle.com>, <lyude@redhat.com>,
 <dakr@kernel.org>, <airlied@gmail.com>, <simona@ffwll.ch>,
 <rcampbell@nvidia.com>, <mpenttil@redhat.com>, <jgg@nvidia.com>,
 <willy@infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
 <intel-xe@lists.freedesktop.org>, <jgg@ziepe.ca>, <Felix.Kuehling@amd.com>
Subject: Re: [PATCH v2 11/11] mm: Remove device private pages from the
 physical address space
Date: Thu, 22 Jan 2026 22:09:41 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0C16A79F-5A7B-4358-9806-7F78E7EA8EE6@nvidia.com>
In-Reply-To: <DBBD65CA-A8F2-40AC-AFA0-FC95CBDB3DF5@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-12-jniethe@nvidia.com>
 <36F96303-8FBB-4350-9472-52CC50BAB956@nvidia.com>
 <c9afedc6-f763-410f-b78b-522b98122f06@nvidia.com>
 <6C5F185E-BB12-4B01-8283-F2C956E84AA3@nvidia.com>
 <fd4b6553-3e9e-4829-a12f-51d29a5d7571@nvidia.com>
 <16770FCE-A248-4184-ABFC-94C02C0B30F3@nvidia.com>
 <sezye7d27h7pioazf4k3wfrdbradxovmdqyyp5slhljkmcnxf5@ckj3ujikhsnj>
 <DBBD65CA-A8F2-40AC-AFA0-FC95CBDB3DF5@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: 845717da-657a-4369-39ef-08de5a2cddd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUZVZkNha3NMWkxwY3ZDZCt6YmdwalBkMEJaQVliK0pORzhhc2JRK3pITEVh?=
 =?utf-8?B?TnJscExMdlk0VGEvNExRWkFxUlVMYWJ1M0J1K1dlUHBRMEtRQUs2Z0NDL1Yz?=
 =?utf-8?B?eENNVXVUMjM1N3lMRWNWTHRJVW9hOFFGcUZWaDRLNVUvRHQxRVAyYVpTdXVD?=
 =?utf-8?B?UUUwN2k5bytmcFI3VGYySlVIUU15VW9tNVFEZStJOW16cFdtemVOcTE4Q0dm?=
 =?utf-8?B?ZVp0ZjhEQkRWNnA1Qkg0czhFdldqOFloNGt5cFF4cllLUTZEWDRFb2c2anll?=
 =?utf-8?B?RUxwdjRZT2k3VFZBN2k3bmVIdGtXNkYwR0p4ZlFqUWV4U3ZER3d4bEc0VUJt?=
 =?utf-8?B?N2VWcUZOY0tNaTBxNVZrT3N1YXdrRGJNWDhtVkhoa1FIWjlvK0dsZVhTME1P?=
 =?utf-8?B?OU1Ia29mTFFuSW93cFFkUkU2YU1oYzFOSDIrc0R4eEhrOEtwK003NjV0STRx?=
 =?utf-8?B?TW9oWllQWHZ0SmhhU3c0b1NoYlptem95VHd1ZE9rMGlvR0FkQXJOSWNpeUVF?=
 =?utf-8?B?bjNuZGhiK3czUXNDMS9Vbm9NYmNtNWJnWXRjZ1ZzdXBEZFRJZzN0cHB2alNo?=
 =?utf-8?B?TDBEVVNnaDBXQkdsR0NOVk56QkxDTGR3eFBBVEY0cUcxN2R2Sm03d3RWQUE4?=
 =?utf-8?B?b2JEcms3cys5Z3kxdldGMTVjVHpKd29OTGM3cEFKZHJ6eVN5VGV6L2RUQzkr?=
 =?utf-8?B?SFpHVDZ6YmNkOFRXazV6citOT0kyMnE4K3VKRDJGOSs2SWhIMSsyclkyNlNy?=
 =?utf-8?B?cDBVMFB5QjJRcDBFOURwODFNRUIxZGNldjVXM0pNNS8zV2Y3eGV2RlordDNq?=
 =?utf-8?B?WGF5NkRvdWJSWUdnUTMzeFVTM3NueVpBWlBrMlBldmY2MlZDS0RtME1tODY3?=
 =?utf-8?B?Rytrbm9Yb2NleS8wZ0ptU0Z3Sk1tazJGZG15Ry9jUUpETTZvNGNRQzAyMndM?=
 =?utf-8?B?aHhXSzlBdHd3aldoQThXSTVTdm1TNGx4SnVMVEREaktCUkpKdUJxRmRCVm1F?=
 =?utf-8?B?ZGlFK0NGV204blF6K0dLcmZFaFZrSWJqZnp6Wi9zWkI2VWI4Q0lpNmFaT3pz?=
 =?utf-8?B?c0ZnQWE1VC9xYkp4NSt5TVVHbzFBeDBzV2NEc1lMTUFic2REV1ZUS2FyNy9K?=
 =?utf-8?B?bnhnQ3NnQjl0Lzh2N1o5ZXhseHgxSG1jL2lqWXd1MHlNZFlJWThtck5FMG53?=
 =?utf-8?B?SUxER1RRK2tGWGdUOFVXR3JLVU5HRWdQbTFURkRKOThqNURQREtWM3Q0SUJv?=
 =?utf-8?B?SDF4d2VPQzBkbTh5d1RWcWxuWXJoSm5wWXZOWVlOdGVobDVXQkpTQW1IYmJu?=
 =?utf-8?B?ekZaYW94RW85cnVSczZuN0hNY0hiUG5MRkdYbWhydkt1UGdZSzlWYjhMamNu?=
 =?utf-8?B?UE9VNkFvUUFvQzZCWnpzb3ZjN3NvRXhNUzcvNTFOWVA1VU1nSXZ0YkM5RERS?=
 =?utf-8?B?TldFZzlTT3grSytld3RoTTNxaVlZWTVTSkFnbDNXVWFkeTJNaExjbnN1Mkkx?=
 =?utf-8?B?a1dFMldSQUttbEpXbUE1cE1YckdOVHQxOGFtOC90VVdQdDRJTGUxSkRRUUUz?=
 =?utf-8?B?N0REclZUMkpKbTZEbkwrQWxkSlpISUJGSXA3eGJKSkdKRnNyY0pLK2NMTWVI?=
 =?utf-8?B?ZCtSbXg4RmdtbFZZelh1ekVsQVpQTDJEVmUvenJuMUlvaVpheHlmOEpEQ1Mz?=
 =?utf-8?B?eEJsSnQ3MElIVi9ZdUVBNytnVkROMUVXb3NpVkF1eWRxeVlCOUwvTjV2L05R?=
 =?utf-8?B?V21XOXFUOWt3WWZwMUg4NkttVWdJdVlCa2F5R040S0dFclJEc0MyY21lbHVz?=
 =?utf-8?B?bTZITmthc1FvRHB0SVdKUUxtVzVrYmRwNlEyUys1TFBQeU9pQlBaS2p3dEph?=
 =?utf-8?B?bFZjaFdTN3JwVmJGNDk2clJBWmpUOGhoNFcvT2dUa1VmRnRCUUdCdHlEUlNE?=
 =?utf-8?B?WXpzRE53T2RJNlczN2Z0aWxZOGtEbTQvSCtlcy9McURyZ21pUk5qRWJoNndO?=
 =?utf-8?B?U3crUkE0ejVLVGpHditSRW9nNVIyNXBsMVAwTjcvRkFrQ2c4OGlVK25MVzJQ?=
 =?utf-8?B?SUNMZWhHaEFMU29RWGdGcWlrRXJ0dDlWVFM4eHpwSUJCdEM2ejdkMUI0K0tr?=
 =?utf-8?Q?adgc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVoySHY4a3JsVUFydklHZVE1N3MwU0ZOeERFYmJYMlFNMEJwL1F3M2hyV29D?=
 =?utf-8?B?ZXFYanJKVjZuU2R6dkQyRVFydWREbWJXV24wdmk4b2pLczFNMmVUYU9NNzBp?=
 =?utf-8?B?eExuY3k0QUdlaGx1NmxueWQrd0xLRmo4aGUxSVpGdEorV3pNdVA1ajdVYU1y?=
 =?utf-8?B?czlTN09yck45Q053QjIycjlWc0hEaHZhQkpCd3pYM1BsNktZRkVrR3d3RE81?=
 =?utf-8?B?N0JxdDRmZ0QwMkY0WGFPL1UydFNlWUhIaU9ZYWRFUTFRMHZMeHlYYXdHbnFH?=
 =?utf-8?B?N0d0NDdja1NoMHFZKzFtSGU4ejlGamdsemFjNUhJcXZwMFZXTjlabEdESGd1?=
 =?utf-8?B?RS95cWRETk9uMVBNYU5rblVmUk1pRnFtOUxSZ3N3TmJsZVJWUHd6RER5R0Nw?=
 =?utf-8?B?SUZLbWpLL1hQUVRnYXZXaTcvakFYUlo3M3BNQU1IUG5BM0RncUcrYitaZjNy?=
 =?utf-8?B?akdKUzV5ejhGbWlnLzN5SWxtU3Q0S1RmYTFXc0Zza2ZwaEhiNTUxbW5hMURX?=
 =?utf-8?B?ZU05MlpWbmp4TGJ2VXZjQTFDUTFLY1NZbHRtV0xXV2ZXZUtWRFFkYjBVWFB3?=
 =?utf-8?B?dHZjT0NYZkFNamorN2JIYkNGR2MvWmJQK014NVZiMHZGUUdYdHFTZUVybWp1?=
 =?utf-8?B?aXNlVmFkMUs0NytITVFYZUZaOVZDS3N2bnRSY25tQmpyVW45TDQ2QVFmcUJk?=
 =?utf-8?B?TGZKcmJlZkNjd1Q4aFpFaGZjNE84TW5pR1d6VG5OVG9mNkx3ZUZFajlHa2Y1?=
 =?utf-8?B?ZHN2eXVtUkpGS2hKQlN6V0tjMFZUVW43ZHBCd3k0MmZhU0szQ2QwTVRFY01L?=
 =?utf-8?B?R0NnckFBSDdNWE16dHpkc0EwNmlrNm5VUzMybmN6endjcGRacTFva09Uc1Bp?=
 =?utf-8?B?Wng5TElVNVRPSjZ1Ni9UaGsraHFtMHovWUJiMkt4L2tFY3ZVOGlYZzlCS05k?=
 =?utf-8?B?aGFUREpkZEhCUTUrZFdaV1JEV2JKTkh3YjFtQXJ2MTVFRWd2UmdKOU5ZZW42?=
 =?utf-8?B?UzFKTm11MXRuOGEwWHlKcDhweTl4aHl2Wm1haDh3NjBBN1Z4eTBQQ21IYk1m?=
 =?utf-8?B?bnVMOWhMcU0vbGVYMmp5OGk2Z2I2VG5VdERRZDVEUUN2MzJVeU51L1o3NTRN?=
 =?utf-8?B?SG1ZZlNKSEpnT0p3U0dXbE9JVERYQ0NUZEFtY1dubHJ6Vm9Hc0h1RHcvRDA4?=
 =?utf-8?B?S00wSGo5bzNTOFRtS3pCMWI1SmpWZXVmWlEwVWM0bzM2ZTJseU1leDdoRjBE?=
 =?utf-8?B?ODY1TU1XYVp6K3lzSDM4NC9RVHdHaGEzSjNYNndqTGJncks4Yy9yTS82RHpB?=
 =?utf-8?B?UnFEU2ZQUEI0blYzYVFUck9MeUVueHZxTDZJZDY5RE1qdzFqT0tBQS9yWnpw?=
 =?utf-8?B?YUdVRHA5ZmFCOTRWVjlnRVlCMitaR3ZnV0ozMW1zcEtHQVBzL0tEcXVwTVA1?=
 =?utf-8?B?SW80bmE4cXRSMllZTE9uc3ROT3RreGVTeTR5dnJzQ1h5d1poaXV2OFhWTkxN?=
 =?utf-8?B?NnovK3d5QU9Qem5UUnZySzV6cU5qekp4dzk1eVh4WElETmY5d2o4MnE1QVpU?=
 =?utf-8?B?eWZKTjVVSXZLWGNxUWowSFJJWE02dExGbEg5NU4vQ09sYjhlK1g5SGR6WjRJ?=
 =?utf-8?B?bjZPTzluRE90UGRRblF1TldlTC9MUHE0eEtJanpNd214V2FRdDBuelpFUVph?=
 =?utf-8?B?cUI5WENhSXJ4ZDF3TWNnSi9zdkVxZzhMYjVERkppdlpUZllwRERmckJIVnQz?=
 =?utf-8?B?YnhUR3ZxUUVVT1RMSnE0SjFOT3NEVXZoY3JvdGdZNlluODRNZ0lYRnI4VDNC?=
 =?utf-8?B?UkVYYWZGN2VnNDdja2JrdUppdDJMVTBLN2NIUTQwRkdnU0hDcjdQaVBBZEd3?=
 =?utf-8?B?ejlRbXZmdU9yRy8wRjRVYU9Dd1lJcTh1YW9LR1B6czNSR2NGc0QxQTZ6dEFG?=
 =?utf-8?B?SjJhZUphL3lzSmNhZk5razZMZjdudG9uR1gyenpKazJVRmtOOXhzNG5Rb3Rx?=
 =?utf-8?B?MjRxZmNicUJNamdRTHd0encwdEUydVhhS1U2S3ZiQ3MzRGVra3lUNVhBVXVV?=
 =?utf-8?B?aXBJbU5IK2o2Y3hDOTdRd0p4RlBCbGt4OVdvNCtXTDFpUllaNktQaXhDUTN2?=
 =?utf-8?B?UUZ6MEZIL055NUtlRE9GN1haTEIzeHJvYk84ZFZGaXVOTVc2T3dMdC93WVN6?=
 =?utf-8?B?VXE1U1hJZ1Z1THNBendtZVY3NUZTc2p4bDhOTlNjVWdYeGVVWUxnNlhZbjFN?=
 =?utf-8?B?S3daemxiOVdCVG1pb0xNanEzUWpub2VRSXpDN016MXZWcXBINjV0c2hEYVh5?=
 =?utf-8?Q?bz//xDpnKM9fWPaz7h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845717da-657a-4369-39ef-08de5a2cddd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 03:09:48.1776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7MYBcC2NAcFIWh0RY88Mxum+z9zyc6evITVs1eqBTs2oFTbdpIZ/qdV7WVF1+Fx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665
X-Rspamd-Server: rspam12
X-Stat-Signature: asmgo8b88yg87tdnnxjfe5ffh5s3bs93
X-Rspamd-Queue-Id: 2367B1C0003
X-Rspam-User: 
X-HE-Tag: 1769137791-396167
X-HE-Meta: U2FsdGVkX1/0cLNoGjoYui8q2OaGLdeGOpwIqcqEgaywh0IbPQ+mzPIvOVW1QluwcAOpstKoX2bz8YWvl+0tuXRJfe5W4wILGf98YBHNOtEiKoe1lKlAXNGIj8cMlbL1NCvLX6LUu+n1QZuy5UMTHQUsuyUsmfyhkRk1uwrgIuAwdjkZHT2/AooUn15GpblmzU/ng2koAq1/CO75HwLskoFAhxH+s0sfDfo4fBBEv9+Z61Z7TFIHOFJxUQwZ+qNwuv1H153/sw7/YJafMOd7LqlHEyVR1N0J1/Avpk1LKFM11O9WhWP0mXwWQvXUT7IFpbgVuDCrh+pGVHQGvxFDQapbuvxAlwl9pF/q+Xp3IdcR1F0/7706rC7ckkhDpio55WGA6/DbAERUnWkjLklLyVtiHdMaocGnUvTiEv9l9rEIljln9GwUAr1O15dD9PkFEUUj1nNaQTSQNKR4vRO/MgaD7LgrPqTB7zgBuMIChLo7rpLqZB8jIh4rKFsPnjzRIpoJDWN1EW1ikaBTv9FnoNuK/VibX5nNZxMd9vVLHw6nxw+md+nX4m01L1ccFqX/BZzlZ/uJf01/dTYUe195pirImGyTDHrivoJ8cGMzC78n22dWtC5EbAkTlrz7KJNux5nZnvd04ymeu3Y/7xKk5u63nJNio3HxTPdX3vLVUfUbCoJ1o789Mz1ZxGDOZXbI4DGnf+IW9yNMenYTt8vge5awsHNoixhYgL66NT/sRIVD1r1ADTZVyZ9yikFINI1hUSuzHWUS5FvfR8LXXel63iHDzgBJWwHJ1Ln/DC2xjTgQgV2Le4gPNYTNk+BXBKUI/WA7RVGvtSnYpxBgvy06/id4l0LVm/U5wD94+GTKpZzXRGQjxv1JWt3k1WIulhJy9OKIsc3Ghz428uKX4jKQp5K0LP8WM6uP6Nb+LJYfvs6BcGpNNN7X1rRnFgeydJNVwWtx493n5cvLEFJDHse
 7/MWmIYT
 yKP3kRdVOMgz3OS0thEIDld/cZbKWGSpni5UBsqqcyG32g9TPfv7C8S+9GGoTc77gX7e5l1+DIN+eDpBJuUQ/898rdn1Im5x4AXWcXNXYW/9s8Dx0vAImKwyUCfBSyZVmIXHAGHI8HpLH6ubIb/AluJXLfm08sO3qadit0CLr1XGOB1tbp7tB9S7Xi3Tp6rg2pa4Bpn84ugZwerqUVSoMmcvpEUZmKaQmlKa5yAMvRB5Mm+36teu8bDJItR+7fV1bg+uT5icrJNPHIspl98qNXTpbP5NCCYJqghyD2yvx6FxMGPuHCZ3dFOQdQqJnLJ1L2Nif59AoXbidpw92OZphmfdmgZoVXHXFU0Gg9mknN26+wRuXlfj95DmSajBO8fkVuFY7cxnqAQ4+/kYqGAV8Z3sCjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Jan 2026, at 22:06, Zi Yan wrote:

> On 22 Jan 2026, at 21:02, Alistair Popple wrote:
>
>> On 2026-01-21 at 10:06 +1100, Zi Yan <ziy@nvidia.com> wrote...
>>> On 20 Jan 2026, at 18:02, Jordan Niethe wrote:
>>>
>>>> Hi,
>>>>
>>>> On 21/1/26 09:53, Zi Yan wrote:
>>>>> On 20 Jan 2026, at 17:33, Jordan Niethe wrote:
>>>>>
>>>>>> On 14/1/26 07:04, Zi Yan wrote:
>>>>>>> On 7 Jan 2026, at 4:18, Jordan Niethe wrote:
>>>>>>>
>>>>>>>> Currently when creating these device private struct pages, the fir=
st
>>>>>>>> step is to use request_free_mem_region() to get a range of physica=
l
>>>>>>>> address space large enough to represent the devices memory. This
>>>>>>>> allocated physical address range is then remapped as device privat=
e
>>>>>>>> memory using memremap_pages().
>>>>>>>>
>>>>>>>> Needing allocation of physical address space has some problems:
>>>>>>>>
>>>>>>>>     1) There may be insufficient physical address space to represe=
nt the
>>>>>>>>        device memory. KASLR reducing the physical address space an=
d VM
>>>>>>>>        configurations with limited physical address space increase=
 the
>>>>>>>>        likelihood of hitting this especially as device memory incr=
eases. This
>>>>>>>>        has been observed to prevent device private from being init=
ialized.
>>>>>>>>
>>>>>>>>     2) Attempting to add the device private pages to the linear ma=
p at
>>>>>>>>        addresses beyond the actual physical memory causes issues o=
n
>>>>>>>>        architectures like aarch64 meaning the feature does not wor=
k there.
>>>>>>>>
>>>>>>>> Instead of using the physical address space, introduce a device pr=
ivate
>>>>>>>> address space and allocate devices regions from there to represent=
 the
>>>>>>>> device private pages.
>>>>>>>>
>>>>>>>> Introduce a new interface memremap_device_private_pagemap() that
>>>>>>>> allocates a requested amount of device private address space and c=
reates
>>>>>>>> the necessary device private pages.
>>>>>>>>
>>>>>>>> To support this new interface, struct dev_pagemap needs some chang=
es:
>>>>>>>>
>>>>>>>>     - Add a new dev_pagemap::nr_pages field as an input parameter.
>>>>>>>>     - Add a new dev_pagemap::pages array to store the device
>>>>>>>>       private pages.
>>>>>>>>
>>>>>>>> When using memremap_device_private_pagemap(), rather then passing =
in
>>>>>>>> dev_pagemap::ranges[dev_pagemap::nr_ranges] of physical address sp=
ace to
>>>>>>>> be remapped, dev_pagemap::nr_ranges will always be 1, and the devi=
ce
>>>>>>>> private range that is reserved is returned in dev_pagemap::range.
>>>>>>>>
>>>>>>>> Forbid calling memremap_pages() with dev_pagemap::ranges::type =3D
>>>>>>>> MEMORY_DEVICE_PRIVATE.
>>>>>>>>
>>>>>>>> Represent this device private address space using a new
>>>>>>>> device_private_pgmap_tree maple tree. This tree maps a given devic=
e
>>>>>>>> private address to a struct dev_pagemap, where a specific device p=
rivate
>>>>>>>> page may then be looked up in that dev_pagemap::pages array.
>>>>>>>>
>>>>>>>> Device private address space can be reclaimed and the assoicated d=
evice
>>>>>>>> private pages freed using the corresponding new
>>>>>>>> memunmap_device_private_pagemap() interface.
>>>>>>>>
>>>>>>>> Because the device private pages now live outside the physical add=
ress
>>>>>>>> space, they no longer have a normal PFN. This means that page_to_p=
fn(),
>>>>>>>> et al. are no longer meaningful.
>>>>>>>>
>>>>>>>> Introduce helpers:
>>>>>>>>
>>>>>>>>     - device_private_page_to_offset()
>>>>>>>>     - device_private_folio_to_offset()
>>>>>>>>
>>>>>>>> to take a given device private page / folio and return its offset =
within
>>>>>>>> the device private address space.
>>>>>>>>
>>>>>>>> Update the places where we previously converted a device private p=
age to
>>>>>>>> a PFN to use these new helpers. When we encounter a device private
>>>>>>>> offset, instead of looking up its page within the pagemap use
>>>>>>>> device_private_offset_to_page() instead.
>>>>>>>>
>>>>>>>> Update the existing users:
>>>>>>>>
>>>>>>>>    - lib/test_hmm.c
>>>>>>>>    - ppc ultravisor
>>>>>>>>    - drm/amd/amdkfd
>>>>>>>>    - gpu/drm/xe
>>>>>>>>    - gpu/drm/nouveau
>>>>>>>>
>>>>>>>> to use the new memremap_device_private_pagemap() interface.
>>>>>>>>
>>>>>>>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>>>>>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>>>>>>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> NOTE: The updates to the existing drivers have only been compile t=
ested.
>>>>>>>> I'll need some help in testing these drivers.
>>>>>>>>
>>>>>>>> v1:
>>>>>>>> - Include NUMA node paramater for memremap_device_private_pagemap(=
)
>>>>>>>> - Add devm_memremap_device_private_pagemap() and friends
>>>>>>>> - Update existing users of memremap_pages():
>>>>>>>>       - ppc ultravisor
>>>>>>>>       - drm/amd/amdkfd
>>>>>>>>       - gpu/drm/xe
>>>>>>>>       - gpu/drm/nouveau
>>>>>>>> - Update for HMM huge page support
>>>>>>>> - Guard device_private_offset_to_page and friends with CONFIG_ZONE=
_DEVICE
>>>>>>>>
>>>>>>>> v2:
>>>>>>>> - Make sure last member of struct dev_pagemap remains DECLARE_FLEX=
_ARRAY(struct range, ranges);
>>>>>>>> ---
>>>>>>>>    Documentation/mm/hmm.rst                 |  11 +-
>>>>>>>>    arch/powerpc/kvm/book3s_hv_uvmem.c       |  41 ++---
>>>>>>>>    drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  23 +--
>>>>>>>>    drivers/gpu/drm/nouveau/nouveau_dmem.c   |  35 ++--
>>>>>>>>    drivers/gpu/drm/xe/xe_svm.c              |  28 +---
>>>>>>>>    include/linux/hmm.h                      |   3 +
>>>>>>>>    include/linux/leafops.h                  |  16 +-
>>>>>>>>    include/linux/memremap.h                 |  64 +++++++-
>>>>>>>>    include/linux/migrate.h                  |   6 +-
>>>>>>>>    include/linux/mm.h                       |   2 +
>>>>>>>>    include/linux/rmap.h                     |   5 +-
>>>>>>>>    include/linux/swapops.h                  |  10 +-
>>>>>>>>    lib/test_hmm.c                           |  69 ++++----
>>>>>>>>    mm/debug.c                               |   9 +-
>>>>>>>>    mm/memremap.c                            | 193 ++++++++++++++++=
++-----
>>>>>>>>    mm/mm_init.c                             |   8 +-
>>>>>>>>    mm/page_vma_mapped.c                     |  19 ++-
>>>>>>>>    mm/rmap.c                                |  43 +++--
>>>>>>>>    mm/util.c                                |   5 +-
>>>>>>>>    19 files changed, 391 insertions(+), 199 deletions(-)
>>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>>>>> index e65329e1969f..b36599ab41ba 100644
>>>>>>>> --- a/include/linux/mm.h
>>>>>>>> +++ b/include/linux/mm.h
>>>>>>>> @@ -2038,6 +2038,8 @@ static inline unsigned long memdesc_section(=
memdesc_flags_t mdf)
>>>>>>>>     */
>>>>>>>>    static inline unsigned long folio_pfn(const struct folio *folio=
)
>>>>>>>>    {
>>>>>>>> +	VM_BUG_ON(folio_is_device_private(folio));
>>>>>>>
>>>>>>> Please use VM_WARN_ON instead.
>>>>>>
>>>>>> ack.
>>>>>>
>>>>>>>
>>>>>>>> +
>>>>>>>>    	return page_to_pfn(&folio->page);
>>>>>>>>    }
>>>>>>>>
>>>>>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>>>>>> index 57c63b6a8f65..c1561a92864f 100644
>>>>>>>> --- a/include/linux/rmap.h
>>>>>>>> +++ b/include/linux/rmap.h
>>>>>>>> @@ -951,7 +951,7 @@ static inline unsigned long page_vma_walk_pfn(=
unsigned long pfn)
>>>>>>>>    static inline unsigned long folio_page_vma_walk_pfn(const struc=
t folio *folio)
>>>>>>>>    {
>>>>>>>>    	if (folio_is_device_private(folio))
>>>>>>>> -		return page_vma_walk_pfn(folio_pfn(folio)) |
>>>>>>>> +		return page_vma_walk_pfn(device_private_folio_to_offset(folio))=
 |
>>>>>>>>    		       PVMW_PFN_DEVICE_PRIVATE;
>>>>>>>>
>>>>>>>>    	return page_vma_walk_pfn(folio_pfn(folio));
>>>>>>>> @@ -959,6 +959,9 @@ static inline unsigned long folio_page_vma_wal=
k_pfn(const struct folio *folio)
>>>>>>>>
>>>>>>>>    static inline struct page *page_vma_walk_pfn_to_page(unsigned l=
ong pvmw_pfn)
>>>>>>>>    {
>>>>>>>> +	if (pvmw_pfn & PVMW_PFN_DEVICE_PRIVATE)
>>>>>>>> +		return device_private_offset_to_page(pvmw_pfn >> PVMW_PFN_SHIFT=
);
>>>>>>>> +
>>>>>>>>    	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
>>>>>>>>    }
>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>>> index 96c525785d78..141fe5abd33f 100644
>>>>>>>> --- a/mm/page_vma_mapped.c
>>>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>>>> @@ -107,6 +107,7 @@ static bool map_pte(struct page_vma_mapped_wal=
k *pvmw, pmd_t *pmdvalp,
>>>>>>>>    static bool check_pte(struct page_vma_mapped_walk *pvmw, unsign=
ed long pte_nr)
>>>>>>>>    {
>>>>>>>>    	unsigned long pfn;
>>>>>>>> +	bool device_private =3D false;
>>>>>>>>    	pte_t ptent =3D ptep_get(pvmw->pte);
>>>>>>>>
>>>>>>>>    	if (pvmw->flags & PVMW_MIGRATION) {
>>>>>>>> @@ -115,6 +116,9 @@ static bool check_pte(struct page_vma_mapped_w=
alk *pvmw, unsigned long pte_nr)
>>>>>>>>    		if (!softleaf_is_migration(entry))
>>>>>>>>    			return false;
>>>>>>>>
>>>>>>>> +		if (softleaf_is_migration_device_private(entry))
>>>>>>>> +			device_private =3D true;
>>>>>>>> +
>>>>>>>>    		pfn =3D softleaf_to_pfn(entry);
>>>>>>>>    	} else if (pte_present(ptent)) {
>>>>>>>>    		pfn =3D pte_pfn(ptent);
>>>>>>>> @@ -127,8 +131,14 @@ static bool check_pte(struct page_vma_mapped_=
walk *pvmw, unsigned long pte_nr)
>>>>>>>>    			return false;
>>>>>>>>
>>>>>>>>    		pfn =3D softleaf_to_pfn(entry);
>>>>>>>> +
>>>>>>>> +		if (softleaf_is_device_private(entry))
>>>>>>>> +			device_private =3D true;
>>>>>>>>    	}
>>>>>>>>
>>>>>>>> +	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
>>>>>>>> +		return false;
>>>>>>>> +
>>>>>>>>    	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>>>>>>>    		return false;
>>>>>>>>    	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)=
)
>>>>>>>> @@ -137,8 +147,11 @@ static bool check_pte(struct page_vma_mapped_=
walk *pvmw, unsigned long pte_nr)
>>>>>>>>    }
>>>>>>>>
>>>>>>>>    /* Returns true if the two ranges overlap.  Careful to not over=
flow. */
>>>>>>>> -static bool check_pmd(unsigned long pfn, struct page_vma_mapped_w=
alk *pvmw)
>>>>>>>> +static bool check_pmd(unsigned long pfn, bool device_private, str=
uct page_vma_mapped_walk *pvmw)
>>>>>>>>    {
>>>>>>>> +	if ((device_private) ^ !!(pvmw->pfn & PVMW_PFN_DEVICE_PRIVATE))
>>>>>>>> +		return false;
>>>>>>>> +
>>>>>>>>    	if ((pfn + HPAGE_PMD_NR - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>>>>>>>    		return false;
>>>>>>>>    	if (pfn > (pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)
>>>>>>>> @@ -255,6 +268,8 @@ bool page_vma_mapped_walk(struct page_vma_mapp=
ed_walk *pvmw)
>>>>>>>>
>>>>>>>>    				if (!softleaf_is_migration(entry) ||
>>>>>>>>    				    !check_pmd(softleaf_to_pfn(entry),
>>>>>>>> +					       softleaf_is_device_private(entry) ||
>>>>>>>> +					       softleaf_is_migration_device_private(entry),
>>>>>>>>    					       pvmw))
>>>>>>>>    					return not_found(pvmw);
>>>>>>>>    				return true;
>>>>>>>> @@ -262,7 +277,7 @@ bool page_vma_mapped_walk(struct page_vma_mapp=
ed_walk *pvmw)
>>>>>>>>    			if (likely(pmd_trans_huge(pmde))) {
>>>>>>>>    				if (pvmw->flags & PVMW_MIGRATION)
>>>>>>>>    					return not_found(pvmw);
>>>>>>>> -				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>>> +				if (!check_pmd(pmd_pfn(pmde), false, pvmw))
>>>>>>>>    					return not_found(pvmw);
>>>>>>>>    				return true;
>>>>>>>>    			}
>>>>>>>
>>>>>>> It seems to me that you can add a new flag like =E2=80=9Cbool is_de=
vice_private=E2=80=9D to
>>>>>>> indicate whether pfn is a device private index instead of pfn witho=
ut
>>>>>>> manipulating pvmw->pfn itself.
>>>>>>
>>>>>> We could do it like that, however my concern with using a new param =
was that
>>>>>> storing this info seperately might make it easier to misuse a device=
 private
>>>>>> index as a regular pfn.
>>>>>>
>>>>>> It seemed like it could be easy to overlook both when creating the p=
vmw and
>>>>>> then when accessing the pfn.
>>>>>
>>>>> That is why I asked for a helper function like page_vma_walk_pfn(pvmw=
) to
>>>>> return the converted pfn instead of pvmw->pfn directly. You can add a=
 comment
>>>>> to ask people to use helper function and even mark pvmw->pfn /* do no=
t use
>>>>> directly */.
>>>>
>>>> Yeah I agree that is a good idea.
>>>>
>>>>>
>>>>> In addition, your patch manipulates pfn by left shifting it by 1. Are=
 you sure
>>>>> there is no weird arch having pfns with bit 63 being 1? Your change c=
ould
>>>>> break it, right?
>>>>
>>>> Currently for migrate pfns we left shift by pfns by MIGRATE_PFN_SHIFT =
(6), so I
>>>> thought doing something similiar here should be safe.
>>>
>>> Yeah, but that limits to archs supporting HMM. page_vma_mapped_walk is =
used
>>> by almost every arch, so it has a broader impact.
>>
>> We need to be a bit careful by what we mean when we say "HMM" in the ker=
nel.
>>
>> Specifically MIGRATE_PFN_SHIFT is used with migrate_vma/migrate_device, =
which
>> is the migration half of "HMM" which does depend on CONFIG_DEVICE_MIGRAT=
ION or
>> really just CONFIG_ZONE_DEVICE making it somewhat arch specific.
>>
>> However hmm_range_fault() does something similar - see the definition of
>> hmm_pfn_flags - it actually steals the top 11 bits of a pfn for flags, a=
nd it is
>> not architecture specific. It only depends on CONFIG_MMU.
>
> Oh, that is hacky. But are HMM PFNs with any flag exposed to code outside=
 HMM?
> Currently, device private needs to reserve PFNs for struct page, so I ass=
ume
> only the reserved PFNs are seen by outsiders. Otherwise, when outsiders s=
ee
> a HMM PFN with a flag, pfn_to_page() on such a PFN will read non exist
> struct page, right?
>
> For this page_vma_mapped_walk code, it is manipulating PFNs used by every=
one,
> not just HMM, and can potentially (might be very rare) alter their values
> after shifts.


> And if an HMM PFN with HMM_PFN_VALID is processed by the code,
> the HMM PFN will lose HMM_PFN_VALID bit. So I guess HMM PFN is not showin=
g
> outside HMM code.

Oops, this code is removing PFN reservation mechanism, so please ignore
the above two sentences.

>
>>
>> Now I'm not saying this implies it actually works on all architectures a=
s I
>> agree the page_vma_mapped_walk code is used much more widely. Rather I'm=
 just
>> pointing out if there are issues with some architectures using high PFN =
bits
>> then we likely have a problem here too :-)
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi


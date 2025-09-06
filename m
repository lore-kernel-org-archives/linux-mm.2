Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500DBCA1016
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 03:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3CC8E0005; Fri,  5 Sep 2025 23:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883AA8E0003; Fri,  5 Sep 2025 23:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C048E0005; Fri,  5 Sep 2025 23:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 626B58E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:27:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2DC2160146
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:27:08 +0000 (UTC)
X-FDA: 83857389336.30.E6F74D4
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	by imf17.hostedemail.com (Postfix) with ESMTP id 030E340009
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:27:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P3PjElwo;
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.94.84 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757129226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NZq95Dxek2ACTXZ/dVV1YBRQS+bOa+Ru8QZatFm01E=;
	b=r4JExIFnP491MABYn5stFA4BAC7fRf/p0vbOnosWD7lzRxbZmEiu1AzCFCjj9dxZkh/3+Y
	wgh+elmer8A+d1M9ZSMRclgQVBAE7To5Y9mMTMp8hgHKqehtPhJkPOgYGj9Op5ZOEG4qqo
	VZompfF/2yhDG9cuRa4uEbEnq5c1wx0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P3PjElwo;
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.94.84 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757129226; a=rsa-sha256;
	cv=pass;
	b=s6SyxyZBaTr87VRWupso2MuKStvJ2RY+Hu5Gqfc6jnasjz5vPkp395RhIs3OfYtNlCLHhL
	aBMngCcQYs3MLKqDggLYlCitFshhHdVtAVbiG+3nWfho6c5C23MSX4SF+iIrMPllIA4l5i
	M4VXwKbnIXyhZ6ZNLm/Xg8c2hfCPIZI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzobIGJVLkx3uC26rXQFZN932CYYhSz5qUoBXNZHC7NB5P3RkbvmY3LGGOp36QZ5veOssU0Ykp8HiRks4tOQqBwv8N9V9ZCtcWq1fltStTUj5/qCALfuzCoVZqrEJiZuMr+PWOj6sWwtg4RecV26pTlAJMBDnie9etOJZuXKGVyj+efE0faC0+f3OV4o0w0G4XJqy+q6peRFId+2i/4cGFaeF2C8ljux6jETPl+4V9q6oUEXk1BvcF13SI92NEghgFuS9npl8StxMEy6OGybyIufDEZOXW1EnpQICxP27itKKloU9TxBlZHtj4VTPSpSS7VSCVhxvSbhkwP3FklsQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NZq95Dxek2ACTXZ/dVV1YBRQS+bOa+Ru8QZatFm01E=;
 b=g8Om3fF34cvVgOhK0TVMhDyYhqVLIeJ6yaXzKuVOtJxVdpuJxpt+0jotS/fXEx5uZA/0Dnur4vOitfHPbvxHDdBCgotyvBe59wwTUfKiyEXtpk2KyjPW29+J/CDCKacae7OFKi63+KtS5N4+qDNddN4ht4Wuja3fEmZEHKHgyLtJNG94PMC5Y74JneAj9Zc7Cx/PteOQ65agRRvyBZNPyRP+ihhTBtzCPUvK3ehiqk+ox4wdC+YezQiVcvuG9QaMUyk/Xx88Bqd1KrVuSKT9U1cn7FVySFA2USJpSLALzYrVYYYeOxNLpMEBEzWL9cFCrgelRzPD5E3F1vq5MNiepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NZq95Dxek2ACTXZ/dVV1YBRQS+bOa+Ru8QZatFm01E=;
 b=P3PjElwo9BVymJAB/k05ty+704twi3So3CL9EuLYPGi4RMmzfpetsiGEWA6DODt8RNhh8GCW04LqixsUi2tD2CtkP5E5vKQi9CtZDU3fU4Q7xfthnn3JxO/dY++4rpIBPCTgHrM/nB1YEKuzbvsWp/9aWqcu0oTtMhIK7zt8Co3dPNxES/OJceVyjT3kVDzpdsS4NjCj37a9Z2vhRsY6wlNX54uIEUEWMUBTfS1ru43O82Y+gNXJ1yl/2fMw+q2W9HbdAJVNQ24FvXq01sgqCTZzPU9iEETK1U9qGY3AWAG88v6bNF08x4bjs5RmKxitxPf3oqUwqVjus4h86EpJeA==
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by CH0PR12MB8461.namprd12.prod.outlook.com (2603:10b6:610:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Sat, 6 Sep
 2025 03:27:02 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%6]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 03:27:02 +0000
Message-ID: <1ffb22b9-98e2-4073-8399-217f4ed4d9d9@nvidia.com>
Date: Fri, 5 Sep 2025 20:27:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/gup: Remove dead pgmap refcounting code
From: John Hubbard <jhubbard@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: david@redhat.com, osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250903225926.34702-1-apopple@nvidia.com>
 <5f3b6bf9-1762-48b7-bc36-705055c99ce8@nvidia.com>
Content-Language: en-US
In-Reply-To: <5f3b6bf9-1762-48b7-bc36-705055c99ce8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|CH0PR12MB8461:EE_
X-MS-Office365-Filtering-Correlation-Id: 995e0192-b407-4a61-c59f-08ddecf53efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0N0TzRpUE96Y3NtU2FMak5CRkwxc2dMWmhhUmRKNnpFTlpTVWQ3S3dKSFZE?=
 =?utf-8?B?S2FySDMxTFFIZmNIZGRaOW1BcVIwaWMxVXNtSnF5NHRkbmI1NW1rS1E0SnNx?=
 =?utf-8?B?WTdUdVNXWmlZZVVvQm9JNGVlVTJUVzM0cTdvMlU2NzIxUnQ2SWR2Q1ViVXVM?=
 =?utf-8?B?MzRrMmUrWWkzb05oaCsyUVpsbDUrSjNRUUR2Y0daSTRza1VwMVBMTy9jdzIy?=
 =?utf-8?B?SElidEVwU0sxWEtsKzhXNzRqdHpYVjRIcU5NU3VsSmFJK1poZ3dnMWZIdGpy?=
 =?utf-8?B?VmxEWFk4OEtHTWpPd3duZFU5V0IxVTNRcmdIOEdWZ3E0S1pnOVVOM2s2dVNa?=
 =?utf-8?B?aG1kaVAxWWVtWU5yTC8xNGdJbG9ma2M5NUxFUG1NaTU3OGpCZEdMcVpqa2ZR?=
 =?utf-8?B?V3dZNm1OYmYxemo4RTByWStrb0Z1RlJSODZmZXcrUUFSWTRkM0pQajJWdmtE?=
 =?utf-8?B?aWdrU003Z0lmazM3SWl4aHBsQk9OTmczQmpPK3pCeXpFcm5iZVo5c21zdmVy?=
 =?utf-8?B?UG9jQ3J4NHlyMzI4cDJQWk1wODkvT0JyYUg5dmx6clJpU1ZWNFBwQWZwZmRk?=
 =?utf-8?B?NXI1b09KUHZLVDVQeUxaTEV6R291VzBzUVBvNHlGMWdvU2pOZUJuWWJtRkJt?=
 =?utf-8?B?bldHUFlrbGRKYUxhSTBYNkN5aUF4ZkdRNFZxUEpBM3BKZzNyczJYV0hkOWEr?=
 =?utf-8?B?ekNHUWhJK3N5Tkpxd1BMaFVmVUlGdGZZbDVWazl6bVhyaVZiSStkTk1GaVBT?=
 =?utf-8?B?cHNXTmZOWDFuR2h4N2ZjTjBUUEhNRXNrS25xa1cvYWJKdWppSkpKVEVZS3dX?=
 =?utf-8?B?RVFJSi9QWlVDQ3hzR0JrRnFMWHJ6Q3NESHF3TDNvSmFiRkx1WEE2YmRrTEpq?=
 =?utf-8?B?b3liT2xyckRDd1Ryb1UvVElWd0NwRDNvd1V2ZU1wQXppTFRJV1UwMVFUdjIw?=
 =?utf-8?B?eCtiaGhlTmtzclhNdWw5U0dqVllYc2Y1QTdGbDNjNVB2RHBlY2pBWHZUbjZJ?=
 =?utf-8?B?VTQ5ZkRwUXFJRnR4Z2c1akRaSXBQUjR4Rmg3L2h5WWprS2xkbm54WnZtNDY5?=
 =?utf-8?B?RDVWSlpYcDVCeGQrOUdTTFR5RVYyQmF0M1lPWmp2QzlRY2h3dk0zTVM2dXE5?=
 =?utf-8?B?RUlIbmNockJiMzZwYTRzald4QlRKSlRwMGR1VEdKMHpScEw2UllBZ0thdnZR?=
 =?utf-8?B?TmJnayt5TVVRQkIwVVRPZlhSdlNsWjY1SllaMEc5RGpVN3F2bzkvQlY1aWFS?=
 =?utf-8?B?ajJpdFFGbk1mKzUveTBSNDdjMlFUeEZ3blAxVU1RbEZ6dk5Bc3BhZmxCTEQ3?=
 =?utf-8?B?Qm84Z0lqQjlCK3ltdUJHOTRnd1BFTVpjWGNVWmVzVG5YMWRKSkJFWHB0M29I?=
 =?utf-8?B?aGRwdU05MUR6MGNiMzZPSmtKY2dJVnZMa0s1WExhdURubnYwMDJpV2tvZFV2?=
 =?utf-8?B?WWtqcEFVbXBwcUEzOW42c0dyWjhsWTJjOGlrM2RDT3VSTmZCTlZmMTB2U1pE?=
 =?utf-8?B?OHdGTDNJMHcvOTAyeFNySURVa0FURVZuazNUdEN6WnBVdFZNTUQzekhBVkNh?=
 =?utf-8?B?b1NzOVhieFZnNldEZ0x2a3hWcmx3RURDcTBLUmpBQ0x0YnNuNE9qVFdIaDJL?=
 =?utf-8?B?dDFKdmc3OXZjTXB4Z3VwSEp4NUZNRlQzcXkrZmVmcjNsRUtOUlY4WjRGUWtB?=
 =?utf-8?B?cVBBN0h0eU5IdmU3OHlWMUFoSnEyU0E1alVmZ3hWNnNmbEtFcC9aTkhpSWZs?=
 =?utf-8?B?R2FlaGZpbklFc2NSWTVwYjUreEhENFpIcVNkUlZlM1RrUEFNSTFPQW00Vld6?=
 =?utf-8?B?QmNlL05VRk5CSzM3YWV0OW9vUCtCWGw5N09zQmtjemx3Y25Kd0xST0JYbitv?=
 =?utf-8?B?TGJwdlNOZ0dENGxsZWJ0QmxUYWx5elhNUkZlRmNwS1B0dTZwdlJLT29ZZi84?=
 =?utf-8?Q?UUAn5uzq7tE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlU3b1plakRtTjFKOVFwVWhVdFdreEpvM0sySVhKMHU5Z2huUzZkRUJZcUxs?=
 =?utf-8?B?WCtBblYxcVMzaWJLaFNsR05WTVRJaHpQUCtBczJpdTNrNnVBVjFIUThoWExo?=
 =?utf-8?B?dEZPQ3p0YXh3eFJ3eDAzY2hWNkJsR0loTitNVFZnVTVKSHVNV3hMOFVwMkgx?=
 =?utf-8?B?SEpMQVJuSk9xZTNqaXdtaVhHc0lQUXpwUTRkc2JoOW1ydWttRnJ6VXBXbzJk?=
 =?utf-8?B?T0Vwa3N1ZHFFZnFIemNSNnZSSzFsanRINFh5RGJNUmFJYithK2x1MEdlbURD?=
 =?utf-8?B?U3h5T0VZYVBnL3FTZmlIb0pyQXMybFBMaWkxWjBScmdjMUZiU2VEWUZBTzJo?=
 =?utf-8?B?R2lWRGwzbHhjNHJMdkxjWjZqRUJoMTVHMmMvYnJJUzZabzZEMm8yWUFmYTMy?=
 =?utf-8?B?Y093KzhWY1RTVk9hYU5iMHRGdE9PRXFRVFdlVFNqR3BZeGt0V21CdlIzNENO?=
 =?utf-8?B?SG91OCsvN21aYW12d2phNnlQUDUrRHlPWjJiYVlPeEJlMnVrbUpMTTA5OUV6?=
 =?utf-8?B?SkZtUGI5d2pmV2c1OUxSYnpxZHUraEhITWpGNGJJd2h2c2M1SzViK0RWNnIz?=
 =?utf-8?B?NG5KSDNaOUJxS3R1WHlad0tTTklYVE1CeHQ0eVIwVmpzV1E2ZmFUcENzZDQ4?=
 =?utf-8?B?UkkrMFdKaWxOWUJKNkRtWFRlOEdPNWg5TFJJTWhnMG1jR3p2Q0dGVGRkMUFY?=
 =?utf-8?B?dk9DOUdKVjhEMlVTUlYyUU5jU3dWQ3c1eEpXdE9VenFDaUdRWjJzNUtRMVla?=
 =?utf-8?B?Wjh6ZWVoNXBQa3NaYVhoZU9hTkN5WU5jRUx4eVhZeHl6b2N6Nm9qQ0VPTXV3?=
 =?utf-8?B?WnB2RitCa0tEK2pSVS9LRzVBL3AzWTZneGkvOCt5dGdiczVNRXFha2lxdGtn?=
 =?utf-8?B?TWluWlp6SVBWdGZPSXB3SnExblpaS2J1WmV4SFlXNVlMYjc3SklGUW9abFBD?=
 =?utf-8?B?aVpTOUpQZHQvdHY0VjNzYTZnNDJ0dm0wUUN4c1lIYm8zVTcrbU9QZ2NKcFpr?=
 =?utf-8?B?U0V2QXhwbWpldVJOVkFyaWhOQ0R6QkJXcmlUR0FxS0lEQVBvR1hpWlgvNEU3?=
 =?utf-8?B?bUZscU0xNmdBYUdUOWtMTXl1cVB3c2tKOWNhR3ppd2pNdkFsWHlVanlxd2Nx?=
 =?utf-8?B?TnhEejFiWUg5Y1laT3FEelh4TGVoOWltVFNuRHh4WVAzaHRRcWhGWlBpS2tN?=
 =?utf-8?B?b1B4K09ZaGNXVDc2Z3pHaHhrTlY0UVY3N3QvSTFoU1hrQ3NxMFBwcm95VU9X?=
 =?utf-8?B?NEVQSmtkTlJWcjliYWNPby9FbFJrbjNPRFZVUmliOHVFcmlFTm9KUmhISUtY?=
 =?utf-8?B?OTNZYUVUTkp5akdyODNGQktFWVkwUDhuYmw0VUJ3VC9UNWJsaWJPS2xjQ0ps?=
 =?utf-8?B?ZmdYTXhwczM1aHVseFltbzlrNlFTQkJJV1l4MGsxOG56Smp4c2ltWnQ4MVRZ?=
 =?utf-8?B?QVBjMmYxbUJDOTBtZExLM2tNbmlieDBBMlViM1JHRXZHMUJQUWwxTE9kaUQ0?=
 =?utf-8?B?Y3AySnpEWUREYnpUd1MyZjhXSUJtRUdrMzJLQ3BOemxLOWJyNk9YRUlIYzRu?=
 =?utf-8?B?bkcrUDh5YmllcnpXZGNEL25aYUp2TnR6ckVDa3A4eUF6b3cra3BiTnkraVBy?=
 =?utf-8?B?YUN2YUVPcVFhWllGYnNQMWpBMlRicU5ZaXJlakh3WVNqK1dlRi9TaDdIcWJs?=
 =?utf-8?B?VThlQXdoNjRFYTVaVWwxSnJ3dmJhbHpIamQyZVRZbExxVE1EZHp0bk5IQTYy?=
 =?utf-8?B?aCtUZFdqSGMxaHBtVVB1ajc5SFZvREx2aDl1UkFHeUcrUFhJODBhdElHeGFa?=
 =?utf-8?B?WENONFgwYitwa3d2RVYwckZrTjJ2bFFSOUYzRnBqUDZxbjA0Rjk0aVVnK2lU?=
 =?utf-8?B?eUpHazJTbGw1THFFajREeE1vZngvejdaVmlvaWNYVjI2LzZzQXlBZVcxaXBy?=
 =?utf-8?B?SGo2a3FTY0x5MVNlbzBjd2JWMndHdXFack9mZ1ljenhDejEvWkJkQ3dNRXFp?=
 =?utf-8?B?WjRZcDAxd0pkbFJCMTdzUUNHdHpDV3ZOMTUxWTBYRm1SamkwMnFjSVQzeXIz?=
 =?utf-8?B?RnlLQnFPTmhlUXo3d1hEdzlZRmdGcmhXZlh6WllUU0JoQk9uRlRuL1hCclZV?=
 =?utf-8?Q?Hf+PQmactWbIykD3hMWRryagO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995e0192-b407-4a61-c59f-08ddecf53efe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 03:27:02.6851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DNcx8T4/r+jruWU6jLAe4TJ/0QfBWH5TWyijWn/qmiqOLDF0QdiSuZ5gMHG20tMmwVhPd0UgVcjPm1TIFRluA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8461
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 030E340009
X-Stat-Signature: jhb33d1aw5xbtaxdta8fpe75uqsmb3pf
X-Rspam-User: 
X-HE-Tag: 1757129225-357956
X-HE-Meta: U2FsdGVkX1+fQp7LCjvV14rEffzt3krWt/i6J6QvktTtRtGgtRPqD3ZBzEdzJGSuL+vGw/1rqzq7ZOI30OWQ02WTq+w3jiOAxkSJHwNjwc1AVUKGquTP8QdrGQ6l8rKyj4lLoQ8WvBLEa3T+kSPxocRVVTUXzbKUTWdbaLZgzYX9AsNRnz0CacPi6IbiBWWuGwopo7TkCbPakjSVsTtfC1apdp7Y4aKsufvmXDeybHjKpAmS/rlyxe3u77HngjaXx4jxORZHMYtG8zTnTJgABCJIzyl7boi4J5pPK4F4/5bb52DazcMhDWcaKlm3Iy+l1y7mKPHjglBIKs3H3lQBzlLU7+RqrvN3cHSAvAPUh/UfrRoztzucPpISDMa75O6dHpVdpf136QLhzBT6O8pgJ3h5cCVtsOqMs0DYCPkAmC3G6xMBa21UeTrMqaOFUmmFOKP2mCa8sRxnoGJFOSM8KK47foANshbWHIONHj6qeHonub74FL2/iWZsxx9cdkNs4rFdt3UuYRagZJIpoHxJyJ/XfDFCUSW7RJxRm2q0eep96B01tA3tN5CIYubl7YznC535Ak2GXgtggwq+GMTPRSweI0dNIJ8C2Gk2aaEANBvzFHWCw9thZJn6tlXf7XogIrOAcQnxTNGhLbBi/r5BU/pjQFZCg2bydSFz2ZSw8zqx5hGaL5DXrd7Zozg4A07qjDvxlV1kGCVBqDrYkecD6wrgKAg+vkCQQURvU1MooR+uCrQCefB/Mr1ZJxkXwlDBV/VX2I9jhXc5sgxo5IqA6iVpAXpTwE53wTFbnf4YNy2ZsqH0le0OcClNnSlY616rwWTQe7f4QO5uH4xAFewSf9xgv7Hduxvv9L21dXreXCF1bPeAnQvIqku8eAT+hqFgBeWnKELLahagWkzFQhdAxyP72Zi4AFfSRqGARMdONcgSsJwis0mZm4okKUv4L9D8L32fMg/1I+6aaJ0ZoZR
 +0U9lKdf
 b4/1B775omqZ7UO9cUeJ9xBUUy3lrhsTZ4Ip/IvI+PGGqmwrtSFDp3kdHNCUU6o/AdXlRNjYJORq0rY0g1E6wQcgIaPcNavHnfF9ELdgNgY52qGN8LJ+Dy4vmJHPhQjK7wQV9kv1BG7NQdYFw6pE166BRiX6aVKg0fm27oeiHLN1MckfH2iDTTRz/ILc1CRiaji8ubMEpiisLKs4vuRbrDKqDxwLugi/P5f1oqTgguTKwg8ZVQWukPDdNGqKwZixzEvChFVxHPZFFExcdtRoZP5IAiwFSbRtm48Or4kfsfsaHX5WgCQ5zZsbqm/gHyT/d7/R7r7yes4xgPDLM0GayVkAISmRbh/Ls7+jkQpMg/gModyxsf+V9RmEDgp4QO1BBL7r2+4unwVc1urquGFYhhZ7kxnSxTdGa5b/AGh1WC53ycW9qbZGlUAXmFOpt9sbQ2mxvP5UrQyBNuPWnLuydLjg5pUuP939HEcxznBfPwi20s+GTwszL1KOuwNaztniYGSM6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/25 5:56 PM, John Hubbard wrote:
...> Maybe I'll post a quick follow-up, in fact, to remove page_mask
> as well. No need to pass that around all over the place, I think
> it can instead be computed by the single place that actually
> consumes it.
> 

Almost, but not quite. The problem is in the -EEXIST return code
case for follow_page_mask(). In that case, we also need folio
size (PMD, PUD, or normal) to be returned. The page_mask argument
does that now, and as long as we are in C, it's awkward to do
anything else. 

oh well.

thanks,
-- 
John Hubbard



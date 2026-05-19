Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D904CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C9C6B0005; Tue, 19 May 2026 01:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DAC6B0088; Tue, 19 May 2026 01:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15526B008C; Tue, 19 May 2026 01:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2BB76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:43:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A4EC8BD87
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:43:36 +0000 (UTC)
X-FDA: 84783077232.02.3B5B538
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7587214000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:43:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3ILnfdyw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779169413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNvwWAHFRRyOIN3YgxuM9VRcx9Xjlmv05mckuAfmW3U=;
	b=6ZMgxuNfjoNsxJDwawfFjfpQbm2xfLTrBnj+hOsJOiRwRjmLzrmHx/dy0+3WftUsCdlOO1
	ZlqhSNJRNHSNlzG58uDVnzBoyFN6primXNW6YwUOYRrLrPRMXWnOknJqMSkyiUMpGZe5wz
	Wxz56WtTPfWgKFbtaepZLWNm5onWsWw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779169413; a=rsa-sha256;
	cv=fail;
	b=m/uU3OS1TikgIGvw2rgYLoCd4EZbQ/fPq35uw12Id9ijB68NsSYf4ZsbEUUn03BefWjZTP
	oxK7WCLXT75FnimjG5+b3OZbJJiNoZES7QWLsFttQSFaluSffWZ3BZxt8O07CglgtAOjjs
	vXAratny+Z7BP2PHUOA2UezWTFmStWs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3ILnfdyw;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IS3UEPqQXyR5atCS6ULGXrpo5eV3tX8CPXajpPvOaW/2mlwoejy95mjTEEuxwc7xjwxyLrSDZzFqn/YLp8EMnHpYePB1fYQlmtr0QQCNheGbtDVyQiCU3ug06c8u70leJKmRQId3f/facLiMHfK3vZyNMS9QoYytjth6PUlGu1mrvO+1sDrpD3h8hkmtLEr8REeK7XZRfhcHKckIYIvb/XVOIoo1pcEmC8Dem/+WTsOi9/OIO4/egfJxEde543FazsbzsdPmc6V39r+b5GHSwEXJZ6VZnT7wIcfjBUSYyX2NPShzGlFDBMa311VJV0OlhURq3209Q4fk5fJ8kMYPEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNvwWAHFRRyOIN3YgxuM9VRcx9Xjlmv05mckuAfmW3U=;
 b=gGaiWx5/GwrZMd1iHhmtAu2oJRtkRmWilIW/+WNqhxeu/m8F/JoGoKpqXcsXy0/0Rxo1ZWkXnEWS+ONWAn06BiXwsMhN1o5zdmKPGGMpYhAFNYsIDpbta1sbyBs0Y0E2z7LAD7UHqqReaYxUB4unMkZcEb+R03WTPLiHh4i4JOsT2ePZUS2umllobtTgBg5+rQ2WsJDgfqrgkPaWBDKZ0P+b2oech8Ys6ptSk6su1+o+gqubvPl7D6I9vGzcW6QlwbLxvvcE2mvSS0wLxcxOpfMiLD3kRRDRcdRiS02yo7RklYY+kD3028Uj+XcnC2xhU5FFUOADE2yfE01PGrTxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNvwWAHFRRyOIN3YgxuM9VRcx9Xjlmv05mckuAfmW3U=;
 b=3ILnfdywQCnCs513y+wrIqcnW8xGKeswy1kVHsjmVaXeNsfuNYxBs9+BIFJb2YL0BvP5sbZelUezIbt5OgpDqiHQpfoLz5KTSgQDFJfgYfJbNKSQdM8c1L7LH5ydFqFTCOT60mYqIv9qeCCacShbYoByx8YjAtDaWB7EsCck7eE=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CY8PR12MB8313.namprd12.prod.outlook.com (2603:10b6:930:7d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 19 May
 2026 05:43:28 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0025.023; Tue, 19 May 2026
 05:43:28 +0000
Message-ID: <5753f479-e3c9-47bb-8549-b87d217d93cc@amd.com>
Date: Tue, 19 May 2026 11:13:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and
 folio_mc_copy()
To: David Laight <david.laight.linux@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke <hsalunke@amd.com>,
 David Rientjes <rientjes@google.com>, sandipan.das@amd.com
References: <20260427142036.111940-2-shivankg@amd.com>
 <20260427142036.111940-4-shivankg@amd.com>
 <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
 <6a5e794a-a608-4126-9abe-0d512a57dd67@amd.com>
 <60fb497d-a35a-42b9-8bf1-7f9ccbde8ade@kernel.org>
 <20260518152038.7d959f39@pumpkin>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260518152038.7d959f39@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PEPF000067ED.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::29) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CY8PR12MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fba7e95-7ef3-4bb3-228d-08deb5698d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	c4bobtVVTcPpr5FFcreiWI1sHkQr08UXitX8vczhRqijh8ZiLk1y7c2bg36dnECC1Jg1Vg+DKFfKo6UP9e4BOQszYS/4EmY4dNUbgnBvA3Yz49RRaZNEgr82dmwkRIE0921Y2W4JklkU5nESqvqurtGVKhgAi/Ru4X9zH7j/v6HI033yCixfXdbuTsILHT8dm1uUpc4ckyn1z7WlM2LhQZG8NjQ50Hi0eQfJea0EK05OPR17hycFMejhWrbctOWmHeO9h2PEcdq6ocMkb2ovU6F41VcU1ed57bNFLZz2BsBenNpyCKyhMyG7xypQq3irz49rq9E9g3C1+QCkbG+/+jhPxK75/sIV/zzO5IaxLybX5mfKDMlpDM/UOconYgr4hT5iaJtCOkODNFLYpptcL5hOzxDrqe/MrBLM/mkWgsNZjHqEY8MkyYag3CGhyKlqAVz0XpmsN8tGCE4hAlZQtZjj0ItXkKLkbj6qNk4iFHL55tH545Y67kyLfme/Ux9Q2DHwXYZbWne+rafIm+yCa40eVPke/ngoRYoqOqWLKrenCQbOSeuuTQVGS7SXx33QnrvkdUBgHsP+DB8qOZwBTFs3p7dXWiAK83wJ4ONINPG8yBJenQhWqZdOapx669GwAN0DtO5PHkPFtwWM0iAomkniOE8v2/3bVFS+9FWiPtKCAx7KM4tu+cjJS30PhOY5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVJUcENzK1AzRFlWN2lYTVR6S2p3MHhOVTdYSGhMVTNDV1Z2SkkvbVhCVDQ4?=
 =?utf-8?B?OUN2di9lZ1psdHJweEZ1THJkV0gyN1NUWk1MY0MwSlFxOGtpbWs2b0lCWm9v?=
 =?utf-8?B?VlUrc0ZEUHBGSHNyMFF3ckd4WW56Wk1Za0VFT0VlRUxRVHc2T0pETGx4ZGcv?=
 =?utf-8?B?NEtCbU0rOVZUVURieEJnZ1pUL3YwcjcyUUw5K1A2Y20zUGpQYzRUQkxETGJl?=
 =?utf-8?B?Smo5RU8xSXVOcFZkN3FMOVJYSGZabFhEVjY5cXVVdEU1eHJjRUdSeE02QVQy?=
 =?utf-8?B?bDZsT244R2FWYWUrcXRyb3RWWnN0U1F4QitMRTNUS2h1RG5OUHg2aUh1ZXJB?=
 =?utf-8?B?QjBrV25NNHFueExBWWJDazBnei9Id2pzaGx4d3dtNUdDbnZrNWprcS9kUWhN?=
 =?utf-8?B?M3ZQTFE0NTdXMWd1cTdseHRXMmlVVTdzR2pobTltTnhWT0w0d2RjaDZzOUJU?=
 =?utf-8?B?RjlVVkJDcE9xNTE3Q1hJSFFjM1B2bm1DU0lZbkluN0tnTlMvWmpxbzVGOW1s?=
 =?utf-8?B?T0tnK0lLVWFTaDZsYThQREhVV0I2WlBCVE9Oa1ZsbVhzeDFkOWxwcmxnbnU3?=
 =?utf-8?B?MEQ4c09ONFhGc2FmQUFaOTVoM1k4YlVIcWt0cUVOR2Q2dVRoVEZjWkVYVGdl?=
 =?utf-8?B?emlJa3Z5RUFOd25CL1JQbmVWNWE2b29NcDVDMEVqbWdEY2RpRDNIYXp6VFd4?=
 =?utf-8?B?T1Z0empCY01OUmg4azliczRZWFZNaGY3TCs3YTl0TGVXVmZtMWdmNU1iella?=
 =?utf-8?B?UHBlMkxobTlBVzBzLzFWTlIzTnZhMWJXdWE3TVIrZ2NZZW12cTk4L2VhajRq?=
 =?utf-8?B?b0IzOWFLR1gycmwyT1pyMExjaktYaFhiZEZDeTB5K0ZiTHZqbDJUSWJGcnNN?=
 =?utf-8?B?RXJlQ1FTZ3p1N2xKUmJLZm9kbXZra3hDYlpmODdJUmR3ampRZk5wd3pobmUy?=
 =?utf-8?B?NDdWcTN4OW9pNDR0ZjRDTHVJUE5UWU5MSUtMY200UEU3cHRJSEVLN3JFUUh0?=
 =?utf-8?B?VWxXcndRUk9SWjZlazdrMlMrOUliM1BubTdLcXpXTDlFM3gzajNjNUFXN0VM?=
 =?utf-8?B?V3NrcTNJSzh4d1NkdkJnZUo1SnFvNTladFVKWWJhV2E1R3pPUFYwUTJvb1Zv?=
 =?utf-8?B?VUdBWHZOR2kzdTNjTFlHTzRDeHRVOHBybWh0NGNoZDVPQTBZeXJTUXJ2aHcz?=
 =?utf-8?B?TXFPaDhGMlhJY01ZenExb2gzU2lXbU4wRlFlUG1pRUhIeUVLWklOTUNWaDd1?=
 =?utf-8?B?eElvY1NwQ2MzbkFGems1NDB6SGZob01uYlJ3NnJQSk15RDAvbXg5SENiNEUr?=
 =?utf-8?B?Q0xkQmZJb0ZUZWtMeXhBOHNrZC9QOWFwS2I1eC9hVWVKWWVzUmRqYkwvUWZ1?=
 =?utf-8?B?S1hsbW95NGhvRlB5NEphbzJtN0phT2pkVFl3enp5MmltVy9RNzNWSHFucmdr?=
 =?utf-8?B?dGtBZDVPOE9EUU0rdUtFc3NEZzFUbktTQjVuZ1A4YTdPRU9oSTJaZmcrTito?=
 =?utf-8?B?U2ZvWENmK1lQRElPNlh0bnIrUjhQdk40cGNLbmpXd2pNK2NmSzgxTk9POXJD?=
 =?utf-8?B?QTdsM2FFSjUvVmdjN09rL0dpNGh0SzVEVnNCamZ3ZEt1dWNsYk9iaCs5a0or?=
 =?utf-8?B?MStFY1VmUWxwbGlyRFo4dEVoeDcvUEc5T1krNkp5WHlmc05wUXVqOUJIUXdF?=
 =?utf-8?B?YUNTYXVXTEF6ODYwaDcvUDhTTGxaUUFsZHBVYkNmWWxFczY5VENxZ0xJQlIv?=
 =?utf-8?B?Vm5GQXlHYUR2Mk8zdC93QmZseHE0Y203RStTRnFOcmVyVTlpam1wdUxxemY0?=
 =?utf-8?B?RGp5R1MvM2cxdHU3MzQ0M1N2NEdzaUpKaUlhYXdDQ0Q1ampmNEw2aC9xWTly?=
 =?utf-8?B?Z3dPaE5ySEhzTTZrWnZzdENQb3lERm1KLzRrMmpJa0liUkMzVytRWGE0dms5?=
 =?utf-8?B?NTlubDMzZE5lSWNZRThUMTBuU3psZWlDSkVFa2lQYmw1Nnl5MkRHUmVjbTRG?=
 =?utf-8?B?MEZkNGgxZTBVc0pGN2xxWmRSSjdqSXRPSzNnS2xrc3BFekhuWFYvaWRNaUFr?=
 =?utf-8?B?M1c2VTdleFphSGNRVFdUSDcxYU9uRnVUVWpJOVdOd25vZFRHTVJsaVB3MVli?=
 =?utf-8?B?RHppYzZud1Q0YnBKU2NkNG9nLzdRQk5CZ0xYRFlYSGV5Y0ZMYUpVL1lEbHZv?=
 =?utf-8?B?NUE2K3ZyS3NRdFlmME5oaXRZdFU0WUxZZGsyYXI4TUVqZEd6Rkk3UzhOcFIv?=
 =?utf-8?B?Z2NaYXVVMmxEWVlWblpJNWNwY1d2ejdCbkxqK2Z1WUFlR2hheEVnV3VZMlRk?=
 =?utf-8?B?Q1p6MUdpR01vZU53enEwaUpuS2NrM0ozR0ExL1hZR0VVYVduTUNSUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fba7e95-7ef3-4bb3-228d-08deb5698d51
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 05:43:28.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32KvEs24lg+jb/IGmCKM1/R7SLXImo5iklFPrjbSR73c8ReBIZaevLKaiVRo5dNU+HALOJy6iXpgqD9g216v0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8313
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7587214000B
X-Stat-Signature: sjigbrifdz8ermrna4rtjb175mj7ygug
X-Rspam-User: 
X-HE-Tag: 1779169413-753606
X-HE-Meta: U2FsdGVkX1+yZv87guj6KCcgRWE/ppWS6NsZZOrI+l+aXnJ7mGwrBCkhvRteQVtCio5iiSvom4Ma5exlgdDD70fXksoGgHutdH38WI+VJGLhAvfNiWjaSt6JwFMWeLkpAk6SZw/1gfVCUV7hiTrse7VRKAFdQDmqr6ZB5/dBdYn9ePIPBTQVOzqWKKssnfj/Ul4QHAcaG9i2hpcSmnJN3ALK9ROrK/Ulq8CvmyOQxW02G6jmGnm502A3MULIvw1xp7Yws/GufAP5nGmTIpBX3dU1DH2zSCXAQuzIvBabvd6P1+sB4MQ7a51qGlIeB3d6Rc3t1eWSm1/qhjEVqYmRR8fePge9vXvs1RA4sm+G3ekP9tBd/BpCSkLCrJe4ucGYtVraUpX6x6VP77XBd6W/CKo7uC3l9VKE5xTHVrYV4EKllDFNt0pPtIAM+fUMj0LOwgcKNiksw1Pbw0ffjKFNPqyeyH1D1gnRxrWk/cEq2mo/sKX/DJ0eAF2rAiDANbIBzl3T2zhD+XvH73CIJxIBBjn9cl9ZzeEUd0keYBgZpjzfHO56I4f3Rfi9yt+MgbXBgLI+3H+swfIONt7tPx6rcpWCeuEdB8U8yCPi9LptqeWprRfi8cV3lnkG2u2hy3XnSEHUxhnFwjQzz25aDBcCrZ8+f1boDZyrOThF4ZT9gbtD0Nn2HgiC4nOhwkc1bRG8B64jDoc6QX2hb0a24OLwZxY72c4eP5Dm9Dpe6YKl/OMh5lFK5iFL9sBlX40a0WduDMjRNWRat6/KFjgdYVMrnb2gR3v1PBaKwY/Q8GuckIeNyttdcgGd91R4PFcWGKVgh+ydkjjGreWg4I5tOKT16liOhYBNOS+EsgNCOucd1kTf8hc0ykltoVOftGIP22o6dCFiCejtUd4WfJgnp+h8S4QJi5ZEML42bYBTusPd9s9SK44J9ez4wT+/6mN3csgWGP8IXUmm+IqQdqtNlBB
 n72jMRsT
 4ghZde/69FIVwEtZ7YZf0WQDjKuSloKC4cQzNSiyM+rFtaZPcf/Civ79V3xsQZ4KrSOaUfoprGQ9COtcGZX6HZTJ6mU/q4zygR+Fa4nbF3uTl8CXFCDxWjsLKhd4hVkr2ArAqYS/KmUfyLnO+CA43d6oQCuUKa5qJKtJXhoYsr8PIniidkza8CECJnORU4FcF8lZ87szdCjnBoMtlLXLbQz5IBCovciB7a8KC4G/5i7qeIurc+QNLEskFjbj1mHLT8r9nxoBNLuqcXFJwpSV05Asz+iFvYQDvV5EjX4ToiJRH0lQdbR6DXse/9Nvr1358q4xM8e5ICYGjCq0a+M8ExLpnlU2SvS7xEy8XVt6E2LhR3IqtElqNNHx/FJ0GRUuplXhak6f7tetcUuN5nMpUmm7SZAFQC8LEGrAnArFsGidQv0k7gLpli9DVN7imPcvDm8HPzrDiPxWYcoHhtAJZdjF53o1x2DJuCRVnIwfR55jA5DRkCeIQ/X/MRTAC/RQNkAndjW97JcLbTr8lKEQjUIwiuz1kzNP7om6BmkQ5k7evn99iei+ASc0WI1If/ILZjccwRO6iOO0xKr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/2026 7:50 PM, David Laight wrote:
> On Mon, 18 May 2026 10:43:22 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> ...
>>> Another option is to leave memcpy() untouched for this series and add
>>> a new copy_pages() helper that the folio copy path can use. It would
>>> use ALTERNATIVE_2 that picks rep movsb on ERMS/FSRM and rep movsq on
>>> REP_GOOD and per-page copy_page() loop as the final fallback.  
>>
>> That would fit the clear_pages() design we have. But if that's avoidable, that
>> would be nice.
>>
> 
> For full pages 'rep movsq' is likely to be 'almost the best' on all cpu.
> The fixed overhead is amortised over a lot of copies so has little impact.
> (My brain suggests a value of 30 clocks - ignoring P4 netburst.)
> For Intel cpu the aligned destination will double throughput.
> 
> I did a load of benchmarking of 'rep movsb' on my Zen-5.
> (I should be able to find the results again.)
> The real oddity was copies where (something like):
>    0 < (dst - src) & 4095 < 128
> when the startup time was a lot longer and the copy ran massively slower. 
> 
> I need to run those tests on some other cpu.
> However I don't have any older AMD ones (except a piledriver) or Intel
> ones newer than an i7-7 (Kaby lake?).
> (I need to get my Apollo Lake N3350 into the test set for comparison.)
> From what I remember of some earlier benchmarking (which failed to
> measure the fixed cost properly) even Sandy bridge handles 'rep movsb'
> and 'rep movsq' the same way.
> 
> The problem with memcpy() is you want a hint from the source about the
> likely length and any alignment assumptions.
> Otherwise the costs of the conditionals become significant.

Hi David,

I have not benchmarked the specific case you mentioned. I tested only the aligned case.
If you can share your benchmarking script or test-cases, I'm happy to run it across the AMD
microarchitectures I have access to.

Thanks,
Shivank










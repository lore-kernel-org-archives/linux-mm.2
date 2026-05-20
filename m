Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E62CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA356B00E4; Wed, 20 May 2026 11:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2386B00E8; Wed, 20 May 2026 11:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A14F6B00E9; Wed, 20 May 2026 11:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17EF86B00E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:22:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B79FC140374
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:29 +0000 (UTC)
X-FDA: 84788164818.24.74E2529
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8BB814000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=e41nh0nX;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8mX2PjBicXkBslPywg1I4hiqxP98nvYwtWEvdDiZPQ=;
	b=zA9v0NaHWdcyg29b6Y45Gi5i7J7uupql64JQChqaXnh6umN3M2nVG/4pJM+g41hIAbBIX0
	obNw1UjQsKOvsM8HcqjC5EaHxsJAtGJ9z3p7dnzvFoCrfSbw9dpwA01J+yq/B0NlBNdwfA
	8sLtFFOEnh4iizstPvnRdFA8IThPU2w=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=e41nh0nX;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779290546; a=rsa-sha256;
	cv=fail;
	b=Ih4TRSAg5kyT+Uais6oxZe9MsLomfBIykBMzOZ9pgY/1+ZlL+LV/7RczXnEG5aHvuDzJTn
	FtpECsFTejfO+62FkQWm9jsfoOR3lIS6ceqiYgEG5PwMOfH1SBYm032O1jnDnRwpTd3woD
	t6WKmhPtdx85j9yLFGS6OCc5xWerMps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhHlcsCIYzZaAk+TqR1kZihCVkRdOjUIpcHhX8Bt8lYMfqGULc/n9bQKmQaBaSst4xzQxns9e/8Llv68lFxFe7tDy7xiZQdeJ4si6PNB4L9QahHa1RKJh00ssTcjljImnDskxfmpF+nNkm+SKD/nDwQmirSAcYjj0udXat4nRm3mALpQKOlw7pJNLZnSwjjrVhGxT4Nm7VB82T4oZ2mwlS6DyJT4pCejH5FJO9yO66sF6Cjnmnlk95IMOBo+pwEd3VFrKaZuyvORL8RV0zUpGo6DVdW8dowuowiZfURFu+t6q6l+GW3M3A+0novxgfEL7mXmLBzaocQloaa2NtdeFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8mX2PjBicXkBslPywg1I4hiqxP98nvYwtWEvdDiZPQ=;
 b=CdcR+rPc2J40jVTK1QNpDA+2pMZsRlpaf1BUhjkemWCvI0DHjWRvd3+VsBvb0glnUDJgr8dgYjgSWN4kjlL0lygajvpy5btL0fwnAyEjnqRk2WRsZDHwDFZVUNCmx3kdtoncdk+tsv7qy3DWAq2dR4KANjhgZdFbvmhCnAg614foMpc0H10C082GF8A1VTe1zdbdPPKP3f8HKzjgwZTNV9UGBU1pOopx4loD2XBUM01VNUKiA+hnr7KvExDq2UWLc0s1HYTHIc0a+kg+sQtcq/4GhByYivNFUOLFPj3Oj1L0kNxS0zgOnkemieYtWdqV+Mp9gEGbvPia2nQMVU+0fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8mX2PjBicXkBslPywg1I4hiqxP98nvYwtWEvdDiZPQ=;
 b=e41nh0nX+1PqatoPCfxUYTIFe/fP3TMvtjmsbJwfMdSX47xmuR2jAwgekZ9nG5lIeZUuZ33a+CFAtBaTkmRJHW/JjTZLCoAl5NBjAGmVaj5OgA2M2keCGHhcbmrkGUQaV1cHQHVwnaThJZebU/qWJKCmKHfDCvq2yuglPSMVYc8=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 15:22:21 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:22:21 +0000
Message-ID: <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com>
Date: Wed, 20 May 2026 20:52:09 +0530
User-Agent: Mozilla Thunderbird
From: "Garg, Shivank" <shivankg@amd.com>
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-12-shivankg@amd.com>
 <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org>
Content-Language: en-US
In-Reply-To: <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::27) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 239e4249-1613-40ba-609a-08deb683968b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	xEyjjFfaRs50UZ6cl9Jy/IMlyLOeiFfXCDP6q0e9SRetmPoO2D8sCr/siR47sXFOKgqYACENiwcbm3wUOqF5csWBTgEVT8ALYlMAWqvala4GunZKURtz4hjwcBu1oNmjYJ8BxyKoQ3BGroyv1Qf3r73kTmk/b3tM5mEoV9owvi+wtzmvFejKZFQZEKpo5j5jN2MPES9tHkaxvF4zTM/gR7x49hdHeG8+vMVzR/HBz4wv4auV0g8F86eXYsZEFfd1pYa8tpYjF4SQW+bFWPWJuLB95bqe3UgHJei0P12EZbU/g/hi5KChmQnZ8uDEsCLczmM1xH/RTOAOohcrqjCjVnqYn4pkX0TEbGEwfnHRxSdnui5Evccp7hphFLscLwZCXCcW1IkCTADjUS4X26Oam5T6bzneyGKhi9fBqwBsTv/EoTmqQO210y8K0mAsoFBCBoPq2+wUqfQtQe0nrlv06GpKxlw/QCsJ1KeOmvcK8tv/uRKfTm8w/7r30zeDsREQMQKxUzAEBdmdUjwcbjmYtDRKwBl7dKXD6W9OKDZS47CSpp/eJmpl2vpSuHJGas+Wdy6n0hApmEFaq/95ET2KQ6a3Bmf/Uoc5jTC8jaD7snBn+gsd7sIu+5tF+D0JNfP0z/3LMSuCioCE5uNpwMDmd8ag81XWRR52EVTeAXNv0+skBQBqXGgWD9GQlXEqxByu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmU3dHdNMDh0Nk90VHNTY25lQlFGd1dXMzBBcHBQM2J4MitCWUVJNnNXWXlK?=
 =?utf-8?B?bk1PZGcyWEtqRGd6ckJCbUNGd3pxT2xFWHZ6ZlJzU0FGNC9FVE5CbVlnQ3hs?=
 =?utf-8?B?ZHAyZzJSamg3dldnRXF1bVhxQU9WTm5XaWc2Y0R6K2VRUnR4T1RZWjhKZ2hq?=
 =?utf-8?B?bHFUM3JhZ21zYlJVRGZBMnF1ZndTSW55UUI2SVZYWTdmTHYyZGNhWUdOR3dm?=
 =?utf-8?B?SG5pUFJZYjZxMElIam9Wa09DM2pnTlZIbk13RC82MERiRHRaV2hpSFI0Nmx0?=
 =?utf-8?B?SS9FcDNaMUxEdzQ2ZnZUMGtaTEkrbzFFOXhoU0JDMVdabTNjd0VoZGRFWXE4?=
 =?utf-8?B?MjBxMU5lY1RGVWg5VCs5Tm5wUmcrT3BuTk12MFpmc1BlVG1iaUs4ejBRMWFE?=
 =?utf-8?B?Y2FjRjhsYzd2ZkFBblVhVjRsUjIwZjJGMVBBblZpOWxDb2M2VWpYZUFlQ2J3?=
 =?utf-8?B?ZXVvSWF1eTNWQVdjcG8rMnN5VVd4TFRTaFhBK3RtUWcxdC84bStTRmQydDJ5?=
 =?utf-8?B?ZEg0cXpJYjRiT2UySTZQM05iN21xeXl3QlBYOVBYVklqQWowcm5iOVlOc0ZT?=
 =?utf-8?B?S2h2OE44QlRpOXIvdFFQMUt6blpEaGRBT1puRXp5TnNCUXoyNzRPcjU5TWRK?=
 =?utf-8?B?d28rdEUzR21DZ05sMlBCRUd6RldMK011UGxtY0JubysxeU9ha3J3V0grbGFr?=
 =?utf-8?B?NU1XQkRpVnVJcCtpbDVTY1JLL1R4MHorYUM4RW4xQm1ZNE1TZlU5QW8rZFBN?=
 =?utf-8?B?V3cyN1IrdURYaDI1bVg5MFZDeUNtT1htanZreUNHUjRHcnV4OEQ0YmtIZFNY?=
 =?utf-8?B?dGx0VVB1QUV0ZEw4M3U0OU1xaitiRyt3S3crQUlNZ3ZaZVFlVklqTDNLZFZC?=
 =?utf-8?B?UE9lQytGb29YYmNKdk02Y1V0dUFRV0h2Z1AxQnNVanp3djRXcGMwaG9QTDNt?=
 =?utf-8?B?YnB4WVgyZzV5SGJjWkpkcEkzUHJ3UU12SnFUMHZSbFJSZkM4Smt4bHdxK0Jj?=
 =?utf-8?B?TE80dUEvVVkvN0lGTC9QcVd3ZXViZGxtdmhyU3VFeFViQ3ovZnd3aXFLZ1Fp?=
 =?utf-8?B?VHZhTHRvL1dIbm1mQitGZndNZWhvaWo5d1Y1U3owalpFa2Y3V2NSN3BqNHNy?=
 =?utf-8?B?NmtVckNMYS9JK2lmRzcyVkUvM0luQTgxR0F4aEtnMXdNT255YWZmU2FhdlhP?=
 =?utf-8?B?UWY5b0pqK2kybWI0dUFWVmF0TEJURWFqYnhTWk1JUGVZTmpSNHpxWWEvQ2VQ?=
 =?utf-8?B?WnV1d2tRTjNJNnpNRnNTUUVkUjllMkhsV2d5d21FN3pUYzFEN1c3S2s1dk5p?=
 =?utf-8?B?dVR3ZWI3M2JiMjJGWm15NlZRN1FCRUgzem9EZllGSjNod0szYXYzODNrWjhC?=
 =?utf-8?B?SkRRY3N3ZFM5cUhyMEM3SmxVK1NrN1NoV1c5Tk1sTENwbml0K1FUQy9xL2ZT?=
 =?utf-8?B?WDQwS3VGSkRNbVdtREQ1ZlZzMWZEa1hvSWExM2lvN3V4SWwyTWFJNEpNTzBW?=
 =?utf-8?B?M3gwZXFDdmtkUit2ZjY2ZStudndJTFJlbkZHKzNrQW5qNjJQQkY1Vmwvc2th?=
 =?utf-8?B?QTV3b1FNZm1XU0huWTZ3M2ZoNWZZYk1ydlBkV24xUThVRDY3Nm83azdOUFdi?=
 =?utf-8?B?T0pQditRUTEvNnNCZUtmRE9DOU5sbitBTURjOEFtZyt1bVIrdC9lTndBNVBT?=
 =?utf-8?B?dGdHL2lId0RXcXRCNm9jbFE3Qm15b0pLMXNqeHNpcFdMWTF0VDJkaVVJUTRV?=
 =?utf-8?B?K2tQTGVCdkJka2Npa2ZPSXJTZHVHSWFEMWVUYjVsb3NRT3JWODh1K1pyVTh6?=
 =?utf-8?B?cDF0ZUxvSFFDdk9XZzJzeGhYWCtBck9FZHRoU21DMy9lRkpzeWNoQlB2S2J6?=
 =?utf-8?B?R2pXZDV3Mnc5M3JjR0sraWxTZUNQd1BQL3l0TjRoRFVaTDRQMElIUGxBdExx?=
 =?utf-8?B?bzUzM3N6WEwyd0NCS1BZbGNreGFZeE5kZThtRFk5SVcrZzk4eGNGSk1QYVh6?=
 =?utf-8?B?OWZNTHIwdnluMmV4ZWR1L2lOOHVZMTRrZi9oSndaRTJsbmxackd3Y1VUNmJm?=
 =?utf-8?B?NVhhc1pQeHYxK3hva2dTbXpsR0FUK1p4VnVQY0FpS1B0cW96eXZuNEtaRGk4?=
 =?utf-8?B?UlN2YVFjNGxDMXRkRHV3N1hvS1FoYXdHTTAyKzR1dVAya1VKeUpFSkVEY0tJ?=
 =?utf-8?B?WXpJL1VFd1lUN1ZacTZ1OG52Rk9yVnBxODZLL3RKUzRuODcwZHJKeXgra2hx?=
 =?utf-8?B?NjVQZ2FPdXlrdWxXZlVVeGFEdDNMczRaSzB0Rkc1bzFvVkVqMFoxbm1uZndn?=
 =?utf-8?B?cnlqdU5pOTdPTVArQ20velJSN2daTzV3ZStOdEUvT1FmUkhwamtPQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239e4249-1613-40ba-609a-08deb683968b
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:22:21.7011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13vr6To/YJcZ5j2mGm+ZmT5B/AyYJjB2ABSaI4YUoER8ctMrXGE4fM8IVuheXOJC8NTDi+IG59kPvxqa4N9L1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8BB814000A
X-Stat-Signature: n3zrz8bz78a8gcha3yaydhmbhciguirr
X-HE-Tag: 1779290546-861639
X-HE-Meta: U2FsdGVkX1/SaepZhrLzUgVPIONbribtedlcwCTgHmS+0ODrGn0ik93jiPJ8n1KrpIU+AFZn1LR780bvKPJukFBp0zyagH5F1JI5kT4edkcUzZ9YWV217fIF1UZxR5bcNJBTsGxJaeKfNS4gzh5XvDh3ZhuIkvIBRU7RTZcWuIqssfCj0JLDwmGVIO6chXGAqyzhGM6bNI+QMus9rUzxdBPPhYFaDoB1F669gCfFnvu78XldKsXWbFmAnUb22BNB6HAV+npwKckf/PS/Z1GBatPD6zQHA54K9BQdWwNXtU/lV+3g3+F+4hYik7ew3riqCPq5BMdOtrUBr8othTgPrS6ZeO0k8iGAvBO6A1MP7lXBN0DOeX5YeXIK8IuPzU/alJZuFJYKh3DxH8dUG+qLH734FzXm8kYsTxV2Mf27Z29iRoymZDLltrK9cAuxV1mpendU9VbIIbyGyvT2jmKThYA9c9FW55fw86DX+yrDC/CtEIEX2NnE1+tORfhdC+lNQYrtEgQ+JQJ8sWan4LigpBLKuW3PqIGCcSkFKv8o8RKIJ58vC/WmXdjJkNSK5tbfPk6FNlC77tJ/rFdBWfmqeJWCUFRkkiHlb0GWSgah+G5h1OP5T9L5vjwn47iOyjtXhVApPzhyTQ5Tioxu7F6PzeGwf+lMjLCmGUq0Mu3TudWllOPMSifYSX2fNKgmAlN6Uk3u04UqY/Hy1aAllGhpLYhR7bgkYlDSQLmoJMYRQbZgmRM4RuohlDp/HNVl2ZWmW+3YSRhJUkNb+TMN59YaWFdhX229Zz1DmwP2MTS2ZmbtCZEwL2cARx5zLN6nwL63rHxNDeSwHKVStElO+EWfe211K+qV1LoH3U1GEMFQ20QoPnIkH8Y9QqWBDb3evcTsiQH0ehW2G837YqCCprt6+gE47MODY6Z0oC3gt17pSszXZdOfLXva4pYkQM0xaPixHhFglFtuLUPnVTlBefk
 s9MCCbG/
 CREch9ULM0Pk8RD2/mt6cnBO7rcTC2BihnXJUWQO7HBGBZ+ceRDk2iTYPwSDVxpSwJ2C92p6zgsPTYmghZxezgJ02SeAFsSZfKBS6Sz+TwW7hdhF2c2ja4GzJjJ4PhUptaG4vd7k7n10klqF1LxWsHrlJOBsGJQHbVrTmozqieOl511V3cHA22oXb2TMLakKOgJqPGW4BflpAR1hGHddHCy1r6JZ7csjjc7A/9tBquhfCCuCnEIeLE25CSKqWmgX+rfu1dkKCnfIttVE5EXVYpVkpMzVRIxjv4P0YgbujoQcz9bXqLBY3XFMtcVfCxe7OI1mHR4R/LteHwEX8ZmxjlbV+FnM+AE+eNR3vSdiWWOwBfkMDhQSKKNHazk4ATtC5BIqqZjW/TM11eJPtiXhn1sMhaY+tVzZtcxEtp8FtqcNKH6LZCMkUTp9wbi4XDOVxphqWYfJbjtauRiyJZqA6Dmhhrk1TOob9yikCdin/YECqdgWT84LdEsZAaGSJmhEMub+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 9:20 PM, David Hildenbrand (Arm) wrote:
> On 4/28/26 17:50, Shivank Garg wrote:

[...]

>> +static bool migrate_offload_do_batch(int reason)
>> +{
>> +	if (!static_branch_unlikely(&migrate_offload_enabled))
>> +		return false;
>> +
>> +	switch (reason) {
>> +	case MR_COMPACTION:
>> +	case MR_SYSCALL:
>> +	case MR_DEMOTION:
>> +	case MR_NUMA_MISPLACED:
>> +		return true;
>> +	default:
>> +		return false;
> 
> 
> What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
> this depend on a reason?

Reason-based filtering could be a requirement for some users who want only specific
use cases to go through DMA offload.

For the RFC, I introduced a placeholder to enable further discussion on which use cases
should allow migration offload and whether offload users actually need this control?

Your other point also makes sense: "If someone migrates a handful of folios, latency is
likely more important (and batching less beneficial)."
Based on this, we could either fully rely on batch size. I'll think more about this.

Thanks,
Shivank


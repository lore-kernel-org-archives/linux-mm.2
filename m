Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E197C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB326B008A; Wed,  5 Aug 2026 08:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D316B0092; Wed,  5 Aug 2026 08:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D896B0093; Wed,  5 Aug 2026 08:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C05436B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:58:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20342120447
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:58:58 +0000 (UTC)
X-FDA: 85067220756.08.4B7ACB8
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8CA4D20005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:58:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eXPjQmI5;
	spf=pass (imf31.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785934735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9msKueQ8HEv0XwtIedb6zmnyTvoYJnx29irE/03m5A=;
	b=Wap8x/jZyHqLQSju5NXC2pxWGv9Q+BWik1olnY07n8KzUj57ki1WlWmW+3dSSN/9LziYp5
	TqwOhoCqKufGr+uajjcELfW91e0PEbLQF6j6mDUxSuibcBXE6iBix3j2Y/UVbb0yEu7OQI
	elx5vsGtVqAHRmPyzQ+MZVH/a6E3e80=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785934735;
	b=oQBM5ElqYJbyOI8YkSGpclxAw29xjc9LkRedBJEIu2T4r2qxEh/s9dAMurVUqZMnDgIBvs
	7OVjQaAR+YP9k9wC89WWqUgQoXuMtkNRcXVm0BZg7qrcRbdpToS0tIq2TkaRzUfinTXQ9L
	EmSA5fZtoqNyGls6Hq3SeM+PmYZLaTc=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eXPjQmI5;
	spf=pass (imf31.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moXOYgho5naY073GoF7MC2p06iEzGLTlG5mqnflPMKqJqw1y7PPVi4FxzKTAprBN+Nbl3gZ64Bxmar3I73dwwePd5yN5nC1tjBj2Xei0bjvgAawBBE7G/FkU0GQkhIV5GeF6Bhe5WQQzpdlMHEntGwHP0o/1PqHy9Klvrjf8BbMzwOp1OSTGuv2GiUIgVRaZbR1Bxy8+yFIkQZ85eIe0ByzpxDb77Jb7pRs5XLaCVZ4Lit95pJHmKedjNQ9DgBKmTjNxjpb0RY6k4qYitUcvGgS7P8f5Nu1Gc9304Qck4UKInYWjidZ22c0uj5lJEDdfb8lyWJLGtumetIOWJV6IGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9msKueQ8HEv0XwtIedb6zmnyTvoYJnx29irE/03m5A=;
 b=AOs6eCSs6R37wdlx8PsAJSSjWcatbAZ7/Zgk6bB15xHGnrxQx4oIa7O42ESWPQhdO+E8XgGDv+o5YC0oyv5Dg4GbfRUKaiw0gSUFa2byNlilVPqPFsiNFq+sMAEC6fGbxeVjU/Yl24USm0wHdaPGjhU5LVS0Ou1O3IY5irnfRhP78sKtEvon0Cyx2sUhSIvvZH+J/jzCZBBWOsTEsurFRe+eiyKSCJ1JZye9BCrMvJUTiD+UzB9tyZzoFs/9lI6yJ9ZoARIi2WmfGef5uc4gdZeCkjM5RoFcrqXX+YYGpAmfVl8/am5K5fI491VKDKGvwSEEytRRvoUi+vmv1CA3bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9msKueQ8HEv0XwtIedb6zmnyTvoYJnx29irE/03m5A=;
 b=eXPjQmI5smoHGO9QIbLfblMN09zLXkM2HUiMGprSU+RJOw91R4R73l5FN84D8wYca8Z6wpkR+7T3tTWiGTHJKAS+hGU0BiZ0qaOaBM47zyw7OylUdi4H1Bw7mnD2V+hcktzUrYHYz1dRNei4zy+DtfgdEwk/OoEGlJCgEYgUzyw=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS0PR12MB8319.namprd12.prod.outlook.com (2603:10b6:8:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Wed, 5 Aug
 2026 12:58:40 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 12:58:40 +0000
Message-ID: <c1652ce8-0b0a-49a1-a842-bf1a5290cc1a@amd.com>
Date: Wed, 5 Aug 2026 14:58:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 3/3] drm/ttm, drm/vmwgfx: directly create writable
 PTEs when mkwrite is in use
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Huang Rui <ray.huang@amd.com>,
 bcm-kernel-feedback-list@broadcom.com, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <20260731164341.1109827-4-pbonzini@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260731164341.1109827-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS0PR12MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: b5382a5e-c26a-43d8-ccff-08def2f14571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|6133799003|10067099003|11063799006|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FM0SfpFUtNjp9GLh5M3FgsReAG8UpRvqcQXXAC+cY1/s3yz73mtJ+pQNbNGyUeS8De6lnm9c8yHN9pJYK5+PQE7sXy8rgpWLSavA3W2ZewjgUhy4bPYMcqiskSN4bYEquvuJD8AyuD28udbtAgs5jEGgFOkSV8WY3E5yYPwKj5FC2dqrRq+eniKEtI0j9AWsDldTMA4hua8OZRr6dR+XH49Recc3zxrTZ0k3550AGTw055lkiZ5uLG6NsnXatp7QTibD8Q0VTXx37oMPHLvF8LdWcbGwRXiieABnYjAm8k3v5bL3urqPU00t6AFNmJ+SB0EtOj8fDAxaZ0zVM2DDK/o11JD8rhPBp1gdGDx/Gk1hPk0Ggm/hAE2oL0o0Ki63SnsYiQVSbd+yTCcPteOXBRTJjThxdgE5qRQwKGMuyJJ5fBCIOPvL/Tq5HyPhckmtI8TTQ0a2dUzi2u307nJMFz9B3vkA6EKEa59K1YXeq+RkJF8nxDE9XppRrtiN6cxlr8ZO4Ckgtxjsp5OQsU3nQ9osZTbXIXYVA/OmF6avDLOVZ/+a5VWyG0JiJH1NZuStJzEWc1uOHqPrDNbgLZPJOnkTto7c61ep+yN12HxRvzzdONCVz4RXZIhCJSLGBPt29dWMOs1Qo8eYNPtVJg9E7zHEGicDQDU1phKxpLhXKd4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjlkL21obXhJczNzMEkrZFUxUUFtQ245WE1VUGxKYUpQcndFYkU1Z2llSi8v?=
 =?utf-8?B?SnZtZ2R0dmt0cW5oMHBTOHRBL1pNVXhnQVNJMVZEaHRGNkxNQ3lHbzdCTWhN?=
 =?utf-8?B?UE91K2xDckwvNlVINThFdDV4dTlPeXgrUnB4V1FsbWhsdVVlZXZHaTl4ZHU3?=
 =?utf-8?B?ektRZ21lVmR6dmdhTGhSVHlRS1NyY2NyTkVwc3RpRnZWa3hoUDVOeDBQV09S?=
 =?utf-8?B?VnZLRDY3bXBHQU5oMkQ2MkF1NjFlbVFrYzVuU2dDMytncitzbGt0YWxCaEpr?=
 =?utf-8?B?clNuTWE3WFE3d25QTnpzMUlqRmQ5NUEvV2dILzZMODhORkwrUTd5K2tUc1Y2?=
 =?utf-8?B?VkpQa1ZWY1BmaC9GdWJNQmdKSjRzbW1rUVc5MXJ5bGMzWFQ2Qk1FRUJNd3du?=
 =?utf-8?B?Zm40S2UyZitoSldCMHBZRlVncUZhM1NWSEw5V01JdE1oSk1admFVVEtRakVm?=
 =?utf-8?B?YlN2dHkrblN1T0g2aE1EMnhkZEIwcHd5dm9aQ1RET1NWVWxkb3R0cUJJOW1z?=
 =?utf-8?B?Y1d6eFhHOTZ6a2N4T05aNjRCdGNiSHdjZ1dQdUJ6dDB1M3hVU1B0QkdMRFVh?=
 =?utf-8?B?THBQSUZ2VEZ0bml0NVAxdnNPNGNPSXpjenc5R0JBTmhxQkhyNkE4Q3NtTVA3?=
 =?utf-8?B?NzZrU3dtdnNzbThxVC83OSsyTFhjYnAwdmZReTF6RlNqZlYzdUZGbGZrQUJs?=
 =?utf-8?B?Rm1PU2pneCsweHFqSDJUZWhxZGp5SStmN1BsQzQxS1EreHFVd0EvV3Q4YjZH?=
 =?utf-8?B?S0htRm12dWQrWnF2NVJub3FTVXE4MWV5NnM5cUo3TlNhTUhvNDNCZXU3elpo?=
 =?utf-8?B?YldBUHpGVWlNTWdwSkl2cm9QQmh1S2ZqeFRDSGYwU1Rmc2lsRlZ5RUxDRU5D?=
 =?utf-8?B?ZEw1YTF4OWQ1TWdoTWN1SUFXejl5WEFnV3J4VGpTL3pVUVNpSUNDemVBQXVM?=
 =?utf-8?B?QVV6UUd3WEx6TnN0eWtUcmxoUWhDUS9idEFpb0MrbW9mRkZ5dzU1UTZJVUdV?=
 =?utf-8?B?MC9PUnFEU0dObm5xcHd6ZFQ0UWJxSVdEc2xyRkwvbjdtNGVmVXpWVW44dnNa?=
 =?utf-8?B?aC9uano1d0N4WGRzRmNzcGlvNE93TG1qdFZEWUlyWUFXeW5RTUhwdDhPSUFa?=
 =?utf-8?B?WlpNNmJWS01LYnpkTEhSV3JNNDhiWk5rVStZa3p0ZGJLSEFVYVlBd2ttUUpJ?=
 =?utf-8?B?TkV4UnI5RWtUTU9vSUF4SEE5STZIak1DMGVEMTc3M3RoeHFTWEp3WmtyRFNS?=
 =?utf-8?B?ZVRIU2hVcXdkcWJjTGNUZjJkQ1RjMlAzNEZVMEl1YldZUVpQblYvRXlVRWkz?=
 =?utf-8?B?cVFWcTFXckZTeWxIVUl2RkdQemtMOTJkcHJoRmJOTVhTaHI3djl4dHFOSE9Q?=
 =?utf-8?B?dTJNb01mZnFiL0xFeDFPdE5pZWVNSHBQMiswQ0Y2bUJUdi9nZE5HakhFSHNo?=
 =?utf-8?B?WUM4bVlkSFdjekY4UmxDOE40bHRsa1FDcFNmK3BiWmY2bzRzT0liWUpkTDht?=
 =?utf-8?B?bzlYR1NISVl5Zkt1MTZnYjFIY3FXM0xpSGtlYW5CMksvb0JwaXA2aTU4RHBy?=
 =?utf-8?B?OVFYNGZSdGNVdGl4emp2bS9EMlNubmU3cHVGWXNsRnFRcGVDNUpqRVZpeDNl?=
 =?utf-8?B?eGRXZitvRSs3S2RWTENTaUdEeTFLTzhWUGpGRVRGeVpUWllRNHFMTTFqajcx?=
 =?utf-8?B?VTFTVVJaZXJGTTQ0M2JzMkw2Q2p0RjQvQlQrNkc1dmxJZStLanBHUytORHJD?=
 =?utf-8?B?Tjc3aXZRTmY4U1pvaWNzWE42MXpuaHNmREhyN0cyREFIK3poYjloMUFiYnJI?=
 =?utf-8?B?bGtUeTRXY0xJc0xTYlN4WGZxRzVTK0xhbGZaV0N0VWJiazdibW9Id2h4K3Ar?=
 =?utf-8?B?QlZYVERoSWxnZk05YzFZYmJ1MlpkVmZFZzZrdU9sam51dFl4UWliOEtsUnRU?=
 =?utf-8?B?MGNkSng1MzA3eGVUcUZPVDhIQTBobU0vaHc5ejhncFFxRnhSTFN0VTY0RTkv?=
 =?utf-8?B?RHlyQnBESVU0Z00yL2NmWFUxbUpaRjdpRmp6K1pBWDgzZm9wb0JwdndLQlNG?=
 =?utf-8?B?Tkt3VWl3dkhGb01HMTVBaTloQ0hXTUpEK3FLNUIrampmTVRtajdQU1I4Tjhp?=
 =?utf-8?B?bFB5MFlTcy9RWkFXc3hoelZwd1JtMTZkUmxxSnhINDlUQkZhekVJN3JXMHBU?=
 =?utf-8?B?RFFsZmZ6WTFKV2U5VFRraFI1aTRKcm4zSlhjMHY4bW5pa1ZoaDJZdHNCeFhz?=
 =?utf-8?B?azVyMGFTM3VVUDMrRnc3bDB0ZHRNNkx2Z2hlam1Oa3FUWVhZT1BoUm1WOVBa?=
 =?utf-8?Q?puQxVgdnaLagDTtxY+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5382a5e-c26a-43d8-ccff-08def2f14571
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 12:58:40.4099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5vaASJE957nyichUXpmq2sdCVmJ7x98c98O1VwXymV1IGtueSltiwDxOy81moQ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8319
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CA4D20005
X-Rspam-User: 
X-Stat-Signature: tg7c9f6acrsaqr9uxs7msi8rsnzg49ih
X-HE-Tag: 1785934732-777654
X-HE-Meta: U2FsdGVkX18YRkJ+wAhrayRc/+uLpvTNqPEUHUAPaxoVVMRSvSZkehO0n0i0FBfsBAPIOZ1YLbUhmvIC1kmy2aVMfWWbstXVmzMuF4GhDrONwiw2nyHVI4syoJ7EH39j3tJ7O0GmAC8pKQWlwlh9+uRDDooWhZENN+TRGBK+riZIac+jT9KRvMeBVgd8jmykat1dmobd6nef4CJj2D0gu+XV2CiA4D9tJ8Qf9Hzo/tPLfqcvDle+55ybsRQ8K2IG4KVZkysXtXyD78lzgEcn/I6PNq9rS6ttTlfQCByq/iEESMSapgvew9cGGA8x5QPAv26rU+3BOfrRMFkdjlj/zBiRPybi2ZBP062zLLI8R9MGk3b0NGcHmw5xvascmXdOwv7AIB/K7U9bVCJXuCi0ll23ym85iNSWFWC/A+MMHe7OxT+9FYiCwq6AQsOoiKYtwThEDjDDFb07Z+LShEYLeB1jVs952TeOtx7OSPWEUMOFGU9YGm4koljnjBZBSvyB3keBRt+t9WoBpovEjWbvN3Y944O+MYQ1aATqrxWmaCa1JdS2+tGfDgEBvk3icue30G4FvviKjxUWY7SQZXwPGi7i+3IKxm4CD9TXrbCx8rnnKbtfyOAFYoI98EntJcIc2OB7Aw4oWrYDYlmjxDXzwECsfTI8F03+qS3KYW55Pyd4pJE3n14jpd3jp3OJa3TBlhndIwPGhdDIbI8AHq+EHeTmC64zp2ZQTl/oHmLGx43SyLQP7cQVMlKA8y+2s9Se0zatxe4ZsMILpAzn+0nxfCJnRDHfQoSauhXhHim9VAui1Kw3JqWx7tyrgrPZImbfYpUy9eTvnNdgr0WTi3FGcnX0ocTTJt+RIrH29RurfE2voy089Ka5m/4yKBivPIeH1GKWRV7oG2/WhSrlI+NXoVEL7P+Ah2HNHiJa31YDsBuaYGEa5fiRo5pqsKIvdzMvkI6CPm9notUalYtCr1p
 WTa8K17R
 bcB7NGXifTWNj5oDwozPZYMJHhWRHaHrXXXcn57wv4U800Me0xskbarSeMhpPIQQ3wmWV9DU1o9ZS1luYqinggj1DigsAyZwZ8RR3XRiyrR1Xe28JTsdwN3tYxGxO+UVAAT9imGBnzG/k4s77+kIv8aJghMlJdS2hP26ySRfOv1oZuDYSbTb2GD+WXBY6cvxSngXSFTBn7vNXUo1Di+7Oa1VQwqxSc62Qnv9/aY9jl/9zIJhTAHqcnn/wASHNFGB1L5J0mKdM/a7pO4lZOX9qLJBU0lWncZ7u0glDfxnwTi5G49DzwqPb9ipYTFpM2KL1rM1OMIYKORDxxS2duYgTezbJ+5iYL0YNZmgunBRKr7F4ZvmX0Jb7MNMC9eVtT4PTUZLRC9z/m+82Rw0QRE/oE5Tsb+a1CBIM+vvklZeLJd5PP0/EZTyY4uh2JgOtA7VYT6stTpKbG4aycPLBwZSRHJu5NfQjrj4nTnwC09RMGaquR5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:43, Paolo Bonzini wrote:
> This ensures that fixup_user_fault() users see a writable PTE when
> they request one.  The flip side is that vmw_bo_vm_fault() now has
> to record by hand the write fault, because .pfn_mkwrite() is
> not invoked.
> 
> Prefaulting works as before because only the first entry comes
> out writable, while the following ones still end up executing
> the .pfn_mkwrite() callback.

Please split that patch for TTM/VMWGFX. The TTM part looks reasonable, but VMGFX is a completely different beast.

Regards,
Christian.

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_bo_vm.c            |  3 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 42 ++++++++++++----------
>  2 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> index a80510489c45..ef27a2d7afc0 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -263,7 +263,8 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  		 * at arbitrary times while the data is mmap'ed.
>  		 * See vmf_insert_pfn_prot() for a discussion.
>  		 */
> -		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
> +		ret = __vmf_insert_pfn_prot(vma, address, pfn, prot,
> +					    i == 0 && !!(vmf->flags & FAULT_FLAG_WRITE));
>  
>  		/* Never error on prefaulted PTEs */
>  		if (unlikely((ret & VM_FAULT_ERROR))) {
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> index 45561bc1c9ef..2cc490e7d758 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> @@ -398,15 +398,33 @@ void vmw_bo_dirty_clear_res(struct vmw_resource *res)
>  		dirty->end = res_start;
>  }
>  
> +static vm_fault_t vmw_bo_dirty_mkwrite(struct vm_fault *vmf, struct ttm_buffer_object *bo)
> +{
> +	unsigned long page_offset;
> +	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
> +
> +	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
> +	if (unlikely(page_offset >= PFN_UP(bo->resource->size)))
> +		return VM_FAULT_SIGBUS;
> +
> +	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
> +	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
> +		struct vmw_bo_dirty *dirty = vbo->dirty;
> +
> +		__set_bit(page_offset, &dirty->bitmap[0]);
> +		dirty->start = min(dirty->start, page_offset);
> +		dirty->end = max(dirty->end, page_offset + 1);
> +	}
> +	return 0;
> +}
> +
>  vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
>  	    vma->vm_private_data;
>  	vm_fault_t ret;
> -	unsigned long page_offset;
>  	unsigned int save_flags;
> -	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
>  
>  	/*
>  	 * mkwrite() doesn't handle the VM_FAULT_RETRY return value correctly.
> @@ -419,22 +437,7 @@ vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
>  	if (ret)
>  		return ret;
>  
> -	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
> -	if (unlikely(page_offset >= PFN_UP(bo->resource->size))) {
> -		ret = VM_FAULT_SIGBUS;
> -		goto out_unlock;
> -	}
> -
> -	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
> -	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
> -		struct vmw_bo_dirty *dirty = vbo->dirty;
> -
> -		__set_bit(page_offset, &dirty->bitmap[0]);
> -		dirty->start = min(dirty->start, page_offset);
> -		dirty->end = max(dirty->end, page_offset + 1);
> -	}
> -
> -out_unlock:
> +	ret = vmw_bo_dirty_mkwrite(vmf, bo);
>  	dma_resv_unlock(bo->base.resv);
>  	return ret;
>  }
> @@ -484,6 +487,9 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf)
>  		prot = vm_get_page_prot(vma->vm_flags);
>  
>  	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
> +	if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> +		WARN_ON_ONCE(vmw_bo_dirty_mkwrite(vmf, bo));
> +
>  	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
>  		return ret;
>  



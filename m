Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D86CF6A89
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDC96B0092; Thu,  8 Jan 2026 04:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E9A6B0093; Thu,  8 Jan 2026 04:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C5D6B0095; Thu,  8 Jan 2026 04:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E514F6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:10:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8510EC215D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:10:14 +0000 (UTC)
X-FDA: 84308225148.18.8F906C0
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C2FF8000F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:10:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GOv34sYr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.25 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767863411; a=rsa-sha256;
	cv=pass;
	b=5ReTXmG/JlUAsyqAT+tiUg3bC/qRuUt6Dg9BkXNz7qms2V/ngdnKYUZsFsKVtclwFiRcjd
	Oc+FXEsaej8TvbojkmUPeokQuslhmI2Q1iE8F581bcI7XNVUxrVuyCp4oDLrk/5obn/YpL
	ayVgGKCP3a9VVRkmashWdMSY0uELRQU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GOv34sYr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.25 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767863411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGrRfgcmrBc01uUAGb3zMapejI1wkidVjZk1Oz4WJ3g=;
	b=JeNAuRz83lmff2jmQyDuLEVcs3bEMEe9deibUjW7u4o37dMe5GRiJUyG6GBndnUroWpbxr
	ODRFJT3MpFn9Cs7+VWgStYNaawpG61PK8A+sdV6xG7ti5IuaOgdJcaadUIjhB4b6ZBR8nD
	UHAe3+kYgkFgpbsDt9liG9ZUko9o1uE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euMO3AMRzxb39VpRU4wodnQ5z9PSzFd74xEG5A0fS/KtJ5sMZwukTqDiasNACJXiWwUEqVVGxVsWGGh4I8DSzmsprdDQcIHA0LIc8uTP0pvpUXTJOdkHk4g5dnfQXxXmLoJab5G7ixU6xe9aeSn6EzMhJLR4CARpknweCvJR74md9RKurhbi95n507MVKOMaaIaLozoSh/YgYeEUFJVfEhauoFbvjO8Q2qpJh9XK8FbODeek/5TfdB0aTi/Ke2qFIw2KQJztp2QHhY988LF5XnQ83CSggRsdkTe3HVQoezk+6EqKQbEW+V5autgJcXZ/+WkOOZ1oozhLBfblqWJl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGrRfgcmrBc01uUAGb3zMapejI1wkidVjZk1Oz4WJ3g=;
 b=eu+7zev9qQyVIp+wklDoUX+QhBLGDboe605GfwW4A6xU0KFBb5/EmsUpu74TiVipaAo4lmYn2viOmudpwsDM6WebnhLr0c+DPHkmGsK68sz0gICKHnS0BNNlGfisLRk6OweQKs47Kao6yMSe33z2aW39MWi2ImeFt8gClCOkh61wo8ojghyfguGydmqnBVXjzDxIXCMoQFIDYnA9OEq17aL7I4ghLyI2crk+7QPechfcrbG+r/8bcM3nn4SulZBsizdCFAh6P05BBjuq2GIg8RUeLU58JY0B3NUyIVA15jHinSz/FNLu3mO8rRV8ZFnRBOfPCLhLuo1LsoVXIzKgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGrRfgcmrBc01uUAGb3zMapejI1wkidVjZk1Oz4WJ3g=;
 b=GOv34sYrCv0tqpxf3/d3P6jHZ5EgzrjVJyjDVhjrpKZ3MYi+YLtjLrFRaA0RRc/RV0983ltaZNJM+2o28b22ZxV3d9j/VJW+bqDnroauEtkyT9OpsjHj98zbMNQfCBArM3Xc2XF1nZmb1YRpYatJjiJyQ+67cAwykv0c621PSK0=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB6975.namprd12.prod.outlook.com (2603:10b6:303:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Thu, 8 Jan
 2026 09:10:08 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 09:10:08 +0000
Message-ID: <d9fa9b92-c4ac-406a-ad05-8942056088fd@amd.com>
Date: Thu, 8 Jan 2026 10:10:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
 <vaq2ys4tsyggohbbypf6l2eobp22t47rtmgjl53zu7p2xgcezd@5wtd7q3wo5ng>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <vaq2ys4tsyggohbbypf6l2eobp22t47rtmgjl53zu7p2xgcezd@5wtd7q3wo5ng>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0420.namprd03.prod.outlook.com
 (2603:10b6:408:111::35) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: 482875ad-7f7d-4b21-13ca-08de4e95b814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWo5VXRycnkzZEdScDNkNGJWQ1k1ZUVnV0phcDlwVXZxYXVHZjN0S3d6bTEv?=
 =?utf-8?B?OUNHb2tJcFJsRjQyQW85aGdiSWlXcVV5amNPcGNjVFUwN2lKSlRNaFNJSXh2?=
 =?utf-8?B?YWVoM1EyYnpBdXZwQTNBcEpsOG9qbWhpdkl1Ky9hdG95SVcxemI0VGlNeFBG?=
 =?utf-8?B?Qmc0b0JlN2N6Z2hZT3ozcjExakZwZ2puekxTZ1gwSFcwOWF0RGp3eG1rQVNp?=
 =?utf-8?B?WVVuQ2NZZ1U2V3hrZEtPLzdybCttaDdCeFhMTzc1cU9NdTJhUHNUOTJ3SFpE?=
 =?utf-8?B?VjBWc0xvYi8xbVM4WFBweW90d3NrTmNwa2ltNWwxU1pwcHB2Nk02ZERLRHlo?=
 =?utf-8?B?TGhxajRDcHRMREFsUnNlWjF5Y0RjVW1CSXAyUlYrSlNrTmFxa1loMlZPWUQv?=
 =?utf-8?B?M1M4UXIya1pQcGFCRXpablowazVLT3JpaDlIOFNOMWlpTnlQL3JhUkdpaVNJ?=
 =?utf-8?B?VnYveVNtU3pUZjR6NXhBMXlWa2Y5VWxmR1JqNm5adXUxejRNMy9qVFQzSHpN?=
 =?utf-8?B?N0w0V09wb1BxZTRRMEZNNGR6bk1Hb2c5bFJ4dGJTSzlqazdINE1Oa2lPRXRT?=
 =?utf-8?B?TE1MdlVEc2IwYzc1Y2o4UWNnZlgyUnAvVTRHNU5YSlhoeEtmazF0Y05nOG82?=
 =?utf-8?B?MVdYc3FiOW5LZllXa1hTVXhSWktmZ0tWazk5Ukw1cXpuMEJSNHRaS1lqTkJ2?=
 =?utf-8?B?V242a1Z4VmUwQXRIVDl2SWw3d1ZxVmlwd2JvbG5jcWczNGZibUExb3VFVThu?=
 =?utf-8?B?eWNZaGZUT3hZYUdsSXFpcEVRS2tiTGVNS0h3NVd4V0RMZjZueHdCdExneGR0?=
 =?utf-8?B?QWpFTGczUkV3TmtiNGxpVG9CQjMzS3dNSit2UmNjaWJTOXBCQkwrRGdlbVBT?=
 =?utf-8?B?bTd3dXJjMWpLbFlHUktweitrS2NFQ3ByVnpSTDZCNThWZ0xESS9mMjhwbXl0?=
 =?utf-8?B?b214ZUExQ2RNMkJWd0JaRm8ySW9HK0Q0WVhHZG4ydW13by93d0ZERFpMdHVi?=
 =?utf-8?B?T09tWndoZFJVUFQ0dmdzYUREd09mNTB0RXJWbUVYK25tdit3UHloMHFsZ25N?=
 =?utf-8?B?dXhJQjZUbzNVclRwQkdmZWJ3a3h2VWlsZkxtYzZEa2VocUM4UGwraXlBRWd4?=
 =?utf-8?B?bzduRGtsSkI1Y2pvNll4VklNSHd3TEtjNEk1dDhSanlDNDczTGxTVHhXTlZC?=
 =?utf-8?B?b2Nub2FwdzBENHFsenNuTXorZUtTYWNXZC8wWjNrcDZoWFl3RGFyYzBTbTJO?=
 =?utf-8?B?SEtkOUhyWGhsaWk2WUxBSi9WQ2tuQ0lUZFprSUROMi94OWNlazJEc2p2eUNh?=
 =?utf-8?B?QitleDVSNlJZOXRLSGR5TlV4OFBYd1J3OWZOSXFyU3d5VXBaU2FPNHM2VlRD?=
 =?utf-8?B?OVhhbDF6UHZuVHNNQy8wUUYvU1d2azJ6VWVXZ08wRERCU1ZMQ05ITGhXc1Jn?=
 =?utf-8?B?OTRNSEdGU0FHelh4MHlPUmdkNFo1cVBSbmNHcHN4czNRclg4eFZ4WVQ2cU1V?=
 =?utf-8?B?TTNKdWg1cnRVMTU2eDlpeDZ2cUJqM25HOUwwQzZsZktuYTVvbUdiL3BPQStn?=
 =?utf-8?B?dlNSSHBiQzVTS3ZxbVozMHhxdHJDb2kzRkE2M0tzYi9ZajlnTmtmTG1oOFhG?=
 =?utf-8?B?MnBuN2MxRmROc1hENmJmdUN4RCtCWCtPT0Rqdk9qRHd6SWFDYWwyTzdOQ0hu?=
 =?utf-8?B?dDlpQi9wMkQ1SE9SOVNycHpxNUdXVUxobXV3RVo5NlBwR1NrOVY1c0h5YUQ4?=
 =?utf-8?B?b1J6S0h3eXM2YUR5dUY3VUFMNE90YUl1bW1YUFlaa2hrT1JJUTFPdUZ5T2kw?=
 =?utf-8?B?RDF5V1phdGFpK2xDUFJPTEVvei9ucXI0TVBIZG5xdWx1NUR2eTIybHVkeXRj?=
 =?utf-8?B?c2hjc0xUdkVGVWJReXNjWmFsZzhWRUdSaFcxSXgyM29tZkgzZmVYaHc4dit0?=
 =?utf-8?Q?Fh3QJKdrPZQr/3lMjPPE+Z3NauKBsbjb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWxHeWcwcFNjbHRPUjl6OGxyTms5Zkd4cmxsTzgwemVxL0NtZWNxM2RCZytU?=
 =?utf-8?B?S1ZGM25MeWFINHp6ckk2TUIzR3lucDBHUFp2ZG53Q0JWRUtEOUhON0NuYXR1?=
 =?utf-8?B?am5uWnNJZ1Eyb2N4NGRmVjlnTmZQaUpTaXFOcU0reUE1QU9vRE9KUmo0NHhj?=
 =?utf-8?B?dEtKQnFOeisweWU1WFlITlNWU1pjTHJxMDkzeTVWU2l0ZnBnQm5TVDdjS3Jy?=
 =?utf-8?B?T0NtQnY1UnJlbVEyelQzMS8yc1RoYUVwVkRVWVdPNUswVkRUZHdDTUxiRDRw?=
 =?utf-8?B?aFBBQjJBdXByRUJjbUJHQ0RTRUNaUENEaCs1T2s0MDlpcXFjSkRZZVl2a1cw?=
 =?utf-8?B?amxQNHpFK2tCb0EyL0JZeEpjTUhrQnpNRVphMlpWdFgzWU5hZUliMG12RTl0?=
 =?utf-8?B?YlhCTlhQb0NwdW1FbXM2QjJUKzJmcSs2QzFmd2t4QzN2MlBwaDZXdEhFT2tR?=
 =?utf-8?B?VWhOQndTN0FWd0FLQkROMmtROXFPL1pVODE5dE9ZQ3B2cEJCZFZISWU3TEFi?=
 =?utf-8?B?UGRMMzNZRFlCM0l2aEFoMkwrdzE5L0JDM0hRRmFpRE14MWNHaG1tRWxiZ0pL?=
 =?utf-8?B?V1p5aFF2SzI0SGFkYlJlS1lBNTFrcWRGYmM2SzA4WFlTVE9qdDU3OFo5R2Z5?=
 =?utf-8?B?N25RTjhFWFA0OW0wSFN1MUM4TlhuR01QMDhCYllqKzFZQ1I4cllLLzF3RHZR?=
 =?utf-8?B?RUQyS0xsV0NPMHA5NEpCNjBVTjUyY1RDeGIrVXFEMWl6dCtZN3gvUVJnckJP?=
 =?utf-8?B?R1E1U0RlRVBTWlpIbzFyeE9ORzJuYjhjZVNsNzdYQ1ZVVHlzNEo2U1gyN0FP?=
 =?utf-8?B?Q3pPR2Rpb0NDYXBqTVBuZmFiSVNJdEFyZGxGczFtd1g4MEhNc2hsWU9OclVJ?=
 =?utf-8?B?UTlPdU5FREpKZkdUeVlkc1dNRUtiOTdPUTRkWTZCMEttNGRwbXlYSlNmNzhv?=
 =?utf-8?B?bGM5a1RUUVQwektQYkZFQVpOdHpyZzU1YVZwNTF5YlhNSUN1dTNDcnBQVE8z?=
 =?utf-8?B?MHY5ZnE4MlFNTGtNRnlMMGI1L28yNDFUUGlNV0IrMFZVdWpWQzJ4M1Y0LzBh?=
 =?utf-8?B?WExOTXRhZDlWRTNnakJ6aThpSE4rWE1ocEZGYzhxbDVGNWhRYnFDK3VuVmVm?=
 =?utf-8?B?M1AyTThWVGdlYmdxeTd4YWI4UUlQcEhKbW5LYVNYRFZkRmpya0EzL29uN3lL?=
 =?utf-8?B?ellLQzRWUlBNMzJsc3hVbjBLQjlxbXpMWllDQjREenhkV1pJZHZEOEdSOGo5?=
 =?utf-8?B?Y0RmRzFMamJ3RU9pMHRtTFdEZ21QKzBSNjVGVzloS0IwWGFwdXd5VVlLWlE1?=
 =?utf-8?B?dTBMUk56d2tuRWFXZ3BVdzhObTFqamdOVGdFSHV2b0o0MkxhSkpLUkVjRGpm?=
 =?utf-8?B?dVp3aUFPSzVmREU2WHBFaUxiQVFWMEJTbXFjNHp2a0UraUM1TURwRUpFUzZp?=
 =?utf-8?B?d3ZualMrMVFKMzZoVGpyWFIyeG9nTzJibU1YRWloNDRrK29ua1VsaVJLN2o4?=
 =?utf-8?B?c0VkM2JJdmxnYnJlTEIvdVlWQ1VsaDBaV200OHUyVVhpVm9DT2l3YmJJRGlC?=
 =?utf-8?B?czZLdGRiMWwxMHovTFU1T01XTnpIU0owa1hjaEIrQ3V5RkkrRnVqSUpSN3FS?=
 =?utf-8?B?cVpjeldHVU9XakliSXV0YzArS3h1eWljMGxsdnRQYWhEaFVTSVcxQW1zOFBn?=
 =?utf-8?B?ak9MNlp3Y3I1M09DTDBSSzF3b1J5VkNodVdOUGdxM3o3UDVWOUU0NGtJakY5?=
 =?utf-8?B?V1c5RTgxaWNRUkhFaGRseHN1VlVXTjFhY3FkUHgzcCs1QXdqcVNZTXZ5RnV5?=
 =?utf-8?B?OTZYd0Y0SnRpS05uemUwckhvUlJ3UEpWejVmSVh5WmcwclNINzgzdGZqZTBH?=
 =?utf-8?B?L2hjZ1VlcDA5UEFVd3BSRTNiTFZyZUlncVh0Tll5WWFpT0c3MW5xa2NuMWZ5?=
 =?utf-8?B?Ky9aK2NrM1lBaVQrYVkyL2hwRUdMSEhGdGhlTjgvTnhoZjZ3c2pSK25CdlZr?=
 =?utf-8?B?aWhuR08xTHRRUTNSSS9kNG5KNTNvMHFsc3JCMUR0YmF3QU1YMmw4MU1KcUpJ?=
 =?utf-8?B?WUx3V2E2c3FjcDJTRm1XYXEwWjBVTmxrK1VMS3lCSkR0a0NRVm0yRmQzQm53?=
 =?utf-8?B?cDlBeC8wQk91VFVlMzU4YzBpN1h6Q21KNjNlL0ZEbG41STVFeW9mcmdrQnFa?=
 =?utf-8?B?ejlNTDRUbkNvM3RRNEE2N0ZVMU1JS0JWSFdqUnV0aERacG5zcldkMnJKRXQ5?=
 =?utf-8?B?QmxKZ3JQamw0cm4wcFV4dEVLTThQVXpvZ0p6MmNXUzZFc1dGbDFCUWJzdmly?=
 =?utf-8?Q?m4RkXUMirgXEsD0mSB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482875ad-7f7d-4b21-13ca-08de4e95b814
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 09:10:08.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehBr1vjIi/7BYBCysaDWrCqDOErgcG3lzocNH8qTak8DGlqv3cmzqmLWnkn8spqi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6975
X-Rspamd-Queue-Id: 7C2FF8000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 55su7b4fcwrcoubdmykt1jwqyoi5qq3d
X-Rspam-User: 
X-HE-Tag: 1767863411-181608
X-HE-Meta: U2FsdGVkX1/UrQ4puHoKvFX0rW2MUTl11hJ9jQlQH8aPjLrasOTrC1ORo8yGfkpILx+tWGV74bT/iguPOEpEFNi+Mx1kayOykQ90nzZBrtRq0VJbQNIqpyPeyuzfNa0EGfYr7/OV1pBhTOdhWCHgn1DvKLNivl8NuwCAWJIv13I5aTJ3eeQBnl252AZnkys1FhgwqEtNnGGKXJD+1xlmQ9mrmnbilxmmmX3hT8TAPpT63eJ5hw5Rlio7iQp0SB4lb43xOfUDq1F62Kny+c07HX0IRFN67tjMfmI1byR6Kv+A+nLdpf3/euiEUKhYgkk5HuNPw05gnrolh61UJuO873xnH7o23bZWUeQdZDKXjk/cHVj9pubAonuJh0u91n1gE7Jjh3dYIzKTZXYGWbmiYnil6n2eVmGlaCndJ86m8zJ/Dk1Kdd1VCXm0jLEysdM5Fdgx5F/fWFaQgaFuG+ozmvq472nodP31Wart4mw3H0Bi/70OUoZUQchqCnveE4Jk7j1kgGJehIOwVcH+uLWGBhppdCiJf+qTfRY/aA1ZQIKUE/ndqqtoom2DbAr6oUxBpbeMqsEn1cv6tOfoIWf9/OW1FO9GV2yYkAjlvu6Wltkr1rwBTdGW6mUJmZxlZoF+UoFnZJnYIi4RJ8qtPGAXj9ZBlZjrcvcmiYcyuNb+SC5bJG+ZZESWEjgrzpDVMjiNtAi09+FcSrxt9PtJCc6a/Uo6WjvVxJjexeA1e9j+NHSAZhMTcr7dWi+p7vMIgcPqjQf8ny6LvXF8rMW55ewL4nmPP/DhmDkDAervQwrsPH6HM3VTD8PhHJmmcuXryfZT0hExDqO0vJASj/chqAIFOnJsFL3wslwgyrZ1ftBmRff6425AEIsZzPWbWkaOqv2oXQ2oVUhJQ36PyFoNA6388RW2+ensDPaRen8ubGJ0UNnqPN+zLE8Hn9hhAeu/YEZpTucY10ejQ/BM0jnaZ4B
 u0jEHXQF
 A9lCFFUdtKLSioHl8sujgGEyQAqAg4kdLzH6oTcvVyUiTPLc3+K/w9j35RuWLNvCb9c1/31Bwdi/MLMaHOBvCVjFflZ+PepWf+ocYWZ8o6HmUtnpdWEWVn/cILDJjmOrTnk3bp5rmtlrfJNjWNwo2iUsUASJL9rZWIxbYMopfXIW8NXvCdit+29VJ7etOrJbaQTOaVBUpox2U2Icz+qw56qkai2POWS8RjyEJem9oW+wGhehUDk6FchHtWbAJYqFXC6BvL6ASKElORiBl/w63fnrOhugx+ybW/QSBc3EZ+OUXR3evJLEvIKl6EtQtJF0d5hhM9NHl8GTf1uMysnf29cL0zG5dpzfGp1zy+GOBjaki76VelfbXqRYpOLm5Px/EoVQnDZ8aX2itvEt8EQpWwb6hQhkUGZThEC6Qux7dftyA70lMzdz/to6jAX28VSfDryL9m54DP1FbkyYbDnStKpXuSgZtxCO56v7IzLa5+Yi78Z8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 19:20, Liam R. Howlett wrote:
> * Mikulas Patocka <mpatocka@redhat.com> [260104 16:18]:
>> If the process was killed by a fatal signal, amdgpu_hmm_register could
>> return -EINTR (the -EINTR comes from mm_take_all_locks).
>>
>> Don't log the error in this case, because no error happened.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> ---
>>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
>> ===================================================================
>> --- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
>> +++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
>> @@ -1070,8 +1070,13 @@ static int init_user_pages(struct kgd_me
>>  
>>  	ret = amdgpu_hmm_register(bo, user_addr);
>>  	if (ret) {
>> -		pr_err("%s: Failed to register MMU notifier: %d\n",
>> -		       __func__, ret);
>> +		/*
>> +		 * If we got EINTR because the process was killed, don't report
>> +		 * it, because no error happened.
>> +		 */
>> +		if (!(fatal_signal_pending(current) && ret == -EINTR))
>> +			pr_err("%s: Failed to register MMU notifier: %d\n",
>> +			       __func__, ret);
> 
> Masking off error messages will make the message less useful and harder
> to debug.

Reporting errors on -EINTR and -ERESTARTSYS are usually considered a bug since that are perfectly normal conditions to occur.

> You could also change the log level, which might be more desirable for a
> whole lot of the messages in here?

Well I agree that debug or info level is probably more suitable, but error messages like this here are just a symptom that people doesn't know how to properly use ftrace.

In other words when you have a message in syslog that userspace did something wrong, even if it's just a debug message, than that is in like 99% of all cases not appropriate.

What drivers should log is things like HW conditions changes, global SW condition changes because somebody requested feature X, performance changes because of I have to enable workaround Y...... but not system call is interrupted by signal, application is using to much memory or giving invalid values etc....

Regards,
Christian.

> 
> Thanks,
> Liam



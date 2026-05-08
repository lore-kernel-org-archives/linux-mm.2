Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FE7CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4F56B0143; Fri,  8 May 2026 07:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EF06B0144; Fri,  8 May 2026 07:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF506B0145; Fri,  8 May 2026 07:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 123C46B0143
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:04:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA9911407E7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:04:45 +0000 (UTC)
X-FDA: 84743969730.15.3F3D0AD
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	by imf12.hostedemail.com (Postfix) with ESMTP id 899734000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:04:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dxaLpR8h;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778238282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6Oml/Y77YfFRidmE7CuLR2cj1MFG4uXiftA/+o9Ms4=;
	b=QtnyWbexUjyre1gAclL2QTzlPNxzoI4DvHFFLl7nlRXt6SM43HRp+I7rtxFVQQ9Ev0dXjd
	Kfs6eQ0CXvWyRe6CISS/24pCacyAauENSPua3ujbIMk/Sw6mYssKipK4wMIthdwQFIWKjM
	dDel1aNON4uF23XGwdvIOE+RZzy+MJY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dxaLpR8h;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778238282; a=rsa-sha256;
	cv=pass;
	b=d/khos+QGSa2CY0Ape0u9FAfbJu52XRi5/e9cJD+NJ9Jsyayi3xpMxsyt+aeTO4h5sdk8a
	znJz9ZyHT0lv0fVV/eCq8wBRcIMbucJHPqtcoNHYVhzZlgRd3kioci+e2v9Ty0CRq2ZNpy
	84Xqvxiec4dTfyVeXcJz3doleOIaNnY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDdD9egOxA7vFwo4THOBdptJpC4bY/I3rnsNkZRS1XRqxJ0oLrcScrqSRmoFhHWTcHCzeFZ0Dkcg9c0PZlf2q1NY7AEXX+WIiE9MnXnWIOufgdX3YlgtKg9o5p95Qg/nB77qR0MfWzQHhUiHbNuTyiQtmZcf6VhVXQQ4MfzpIpnYhuHxC9KaHSOf9QkP1cJv2XmoP5xJ3ysSN3ONIiVt3dpCj+CfswE04I2Kmkjg8iFxFCtZ3/nN2aq7R26P0lqiWdMyCWsOOIcf7PcBPGd5rVMCRq5/lpAd8V6Ij2fNuxwt8PlkUx6J5qPIDji/vjZdjwhYc7ACAgxYkqs2KFPQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6Oml/Y77YfFRidmE7CuLR2cj1MFG4uXiftA/+o9Ms4=;
 b=ABt19M74Mq3onN8rS0VYKX2eySSJtnaP4Q264Gs/pK1gH9pInFFFbVmi/L7vIxtm1h2lwDJ+6z5C/Yk45c/Gtm09xJP3PWrFfWF+U7OtWKuwepiLNYKHPbYoNDkm6aAzvWzW8qn0Ra0b/0BAMXp1R7nVch/f291LJAyB6Gd69cIVQpFD5riXyc5srewfwOkstbGwbKQ9XVV6rZsDDK8tO6M9bq/ldpSOEfeSvPyLDOzY69dFbpc2/VucLCPXEMwlkxmQ8dKxrNKVnunAYrC+hNhN95DDwkBt1pEwRAbJ50tzrVQn/KMvWCTqksXN3x766p/l1V7oQcFYNME9SWp80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6Oml/Y77YfFRidmE7CuLR2cj1MFG4uXiftA/+o9Ms4=;
 b=dxaLpR8humk8Bzx4ssWi0JWsBwcD9rX+m7WukogZcl4atyl0U9hFH1EJt62Oan0d7UBzVEjCy2KUFcRiVIr74tiYvrha9AUlF/Fgx9bNv+VnYFzuUZ/HItmSbWOpS4TYXcoDOy7tao2bQVLKt25vW6NDiaSIC8ULPlyMjr1ls8E=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MW6PR12MB8868.namprd12.prod.outlook.com (2603:10b6:303:242::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 11:04:37 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9891.019; Fri, 8 May 2026
 11:04:36 +0000
Message-ID: <152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
Date: Fri, 8 May 2026 16:34:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
 weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, willy@infradead.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0056.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::14) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|MW6PR12MB8868:EE_
X-MS-Office365-Filtering-Correlation-Id: 25c5c584-4847-4022-01af-08deacf197a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NeYvRnSSnJp296k9dZsFvKgHs3MObR3TogkQOHB9C6mSQdy/xvRNp0xc3N115Ye+ErE6+yEUSFw89xA6k3kaOAOPoSrYXA8WVXbBdoGg0jXr93fgRQ19QshoWNdNdNHn7Vci2lNqepdnUkyDeAxTuPOOMPz3J73VIY4Fpuom0u/zKeDLb/M6eOAYFxf4XGztufP/LTBE6oXLDG5IM1aJQACEI9LRGhzeHg8nswnLQwP8vkvZFXPDD2Aaz0ff/RZjf9+/YwsJAm8TeOfVQD5BGvoPbuVPKF/paloKKpfClMjO//WH4gheMRTdjrZ/4xCR+8n+brNNkV392+/OOAAy7RGfWptR8bBTGqKfCjsb2dra1I1mJ4qrN7GAnDVuIcvj99mmLVF4D07M9dDFi0ciarolXCwb0I110Hz/W6cHqIG9UrlnFw8hPk+SRsOl6zMGl/KWc1f4RzDDBxOvRW39pWc0WPE6rWInQWNTRLX2L4lVl6c+wmIQyUq8LguuMlQ1InvHoEIE0toJ+iLKZv76pOaCegEqqGADcG5jzBkM8a9fNW2DZpdQ2lUD2qsMTANwfcRpuOxT0GtHu4LB0CkfBGNrT1xpy72GfbgR1Boi67d/fNF32fPJAaTuexAtAkQhWP0bvRHcxrLxvcXMNpaD5uUv8AhuEjMa5mGaSHA8cKjHELLecobvxdCbEO3+z6rD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mkt1L0g5bmlYOStyQ3FGNjQ0ZkdYTDFCdlVRZXZqd2JpWmwvaVN1UzFPa3lU?=
 =?utf-8?B?UnJiOFIvMTJkUWtzMHFVcnIxdjVMMjlDZzh2aEx6R0dYSkhZU3hBRHp5OUZv?=
 =?utf-8?B?REUvcGdLSTZSSEVycmVKVnZoVnU4N1R2NTVRZkxQdzNyMHB3S1RhUUpxY0RT?=
 =?utf-8?B?SCtDVGRhS0ZJamJuK0xQODB2ZHV6MlFoSVV6ZTRJSDg2azRQbmE3Uis4NXp0?=
 =?utf-8?B?MC91QUtScjQ4K2dZOFpiSGlVZzZCN2VpcWtvbEtvSjlWZlRGZlJQU2ZSS2hw?=
 =?utf-8?B?L1Q0cGFHclRJK0JPM0huY0xPeG4va25mQWtmZWlMQm1peHhFaXgvdnNoN1Bv?=
 =?utf-8?B?RXFPc0RXdkVVS00rS2pEN0o2THNkdFh3VzNNbVVSREw1L2FoT0VjUUZ6N2dV?=
 =?utf-8?B?T284bXErYjZLaFNLRXdnK1lPbU5lNUpLWTQzZ0VqaXBjdnZTRlA5YzJ4dERD?=
 =?utf-8?B?VGFYbE9EZFJ2SjFOcFp2cjB4WWEvWUw2UE9lUTJjU1l4RUNZNW53aUllQ1B0?=
 =?utf-8?B?WVljaWVXOEN3N3Y4bW9hYzNHQklsRVgwMlpVOU1pb3I5MEd5a1dCVStsdmk2?=
 =?utf-8?B?R1R4ajJPb2dIQzJDUTRVeStPZjR6RWJsSHJDeWlFQzBpbVRHUk9FTTdPNXdW?=
 =?utf-8?B?N0d6NnRDazA2SzR0SGlmT0Zqc05sS3gxQTNvOGk4azNnMHJZNzdXa3ZQd2Ni?=
 =?utf-8?B?bHRJOFNPK1g2bWdXQzM1RmpSZ1l3STI2YUNsYzV4OXM3RktjMG5rSHpKWEM5?=
 =?utf-8?B?Tk92YnVwUDdVOG00YW9ZekQ4ZXVmc09PbTl1V0dqNzlKdS9iK2UvTjZ1M0d0?=
 =?utf-8?B?RTQxWWUvYWNSQUpjcmZUVHZpOTVNRmZPaG5xbXFPaHNPSDJsWTZGaXQrYS95?=
 =?utf-8?B?OStOcHNoU24xK3NuNmw3TUpCRlFuRXF6eU1mYzBJU0c2SXl2YmpxZ2NEL1M3?=
 =?utf-8?B?OHlqU0xmTG1QcjM2aWFnVWNBQXdoWmZYK2FPRmt0TmVWMVRIM0YrZmx3VXFh?=
 =?utf-8?B?T2o1SStubHYzdTR3YXFzaUhZTlVaNi9wUm8zSHI2RitXYTVSbnZ4NVovd3ZM?=
 =?utf-8?B?TXREYUp2eERWYndaa1NLdEZUT2I3TVE3RTBsNlBMWFZ2VVpZMDlrTFVyTEZy?=
 =?utf-8?B?TmdXSzg3ZHNBTmRzUW1SbS85YUgzTFk0QUt5L1JsOWplZ1F6ZjRFRFJKZ1NT?=
 =?utf-8?B?OXRvcG5xdWZvU2FidVYzZUU1cE9UbGpINGpLVk1JY2xUMnJVVnlQM1BDUnZ0?=
 =?utf-8?B?NjVwZEpqOHRJOVI0cnk5R3UzeW45Q3FHWnJCa1NWOHprdm0xL1ZXSE9sNG80?=
 =?utf-8?B?dUViaEhGZDFLMlUwQUJYMDN3MnlsMEsxQzQrUXhHSVpsYWEzUnNHZ3dYT2xW?=
 =?utf-8?B?VEgya0ZuTU1RejAyNDRHU21hUnVGYjhnVlVCYzBVOUhBODBNY3ZoUnNWNmpi?=
 =?utf-8?B?Q1BrbU83RjhlSU1YRDI1cG85aGpBaHYwM1Y2ZjMwZnlwbEhFd2pwbEFkVnk0?=
 =?utf-8?B?MFgzZHZNOW1mdU9kaGpVWE9lZFVsd3ZjVnlsZm9Gb2FOUWFBdGtzSzUyQkhU?=
 =?utf-8?B?bVNPbVdQNWpxZHNleG0yNmIzK1o2Q29OMy9uY3ZFc2VhTU9KenJKN0FvY3JF?=
 =?utf-8?B?L2o1R0NpREJlNzZiaVRrUVZQKytQWCtUYWpweTFjeUFQTFI0S1NNRzYxYUcx?=
 =?utf-8?B?ajlMMkZ2dDVxRFdhcnVvOThtZVJaSmxZL3FUeHJLQ3JFS3FaV2VXWDYvTk1Z?=
 =?utf-8?B?RXBCYk13c1JwdlNJdUsyZ1ZDOTdRaWZabmYyNWZ1Wmd0QmFuN0NwRFF2NS9h?=
 =?utf-8?B?L1p6d2V6NEN4VitvV0NHSTVmNGhpWlVOTE9yb2IzSGZsOGRBWVYrWXBoL2U0?=
 =?utf-8?B?ekRsdFhNVCtmdTJNOVVFNW1iZWhtek0vdWtSUTg2MlpZVGFld3JjdG5tS2Jn?=
 =?utf-8?B?UmVhTS9uNzZ4Si9aWWg0ZWFPeExYN2JFN1h6U1JSOGdKTFVtekZCcWx5NjJt?=
 =?utf-8?B?MUpFQy92WTFaSmUxbU1oU0tDT0UyMFlIRGMyMFdGMGVCOHZCRlVnM0k0anFv?=
 =?utf-8?B?OTN0cjI5Wm5aUlhxTlFmUmR3aDhZREJlcFRBSFc4c2xNWHdUeHlKUVY3dG9w?=
 =?utf-8?B?dUw1L2NIejRSUUxydWt3eU14dHlheGdEOTBlYm1YRjlXdUlVa1M3Q0hKYVFL?=
 =?utf-8?B?dVZCajA4My8wdzlvZzg3NGt1dHpqQXhpQ1FJMVJzVDB3VlQ2c25PUC8zSldS?=
 =?utf-8?B?N1M3QUpLTnlJNWd2ZWFvRThGWUpERnNmWmlad1Y4NFQ2dWJORlBiRm5zYlRs?=
 =?utf-8?B?eHBUT0VJZnVsZngzSEVNS3F0R1FwRmQrRE9DYktsc3BFRHFrMWhsdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c5c584-4847-4022-01af-08deacf197a2
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 11:04:36.7647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weh+3QKl7wRp7C/zTL6vWIYXQLRobE1guRue1tSQUpl/IBVYXWNwxGETRxjFh0APOk6Rj1oATHKNiIdHxizYPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8868
X-Rspam-User: 
X-Rspamd-Queue-Id: 899734000B
X-Rspamd-Server: rspam06
X-Stat-Signature: p15dmob7yx77x33588bgakan749sse85
X-HE-Tag: 1778238282-358904
X-HE-Meta: U2FsdGVkX1/eqzhVi8WTO/tbcft8dPGKDgf+FNpcyBSjgfvdI00v19flB1JCEwXkyUMaCCdL1zlGE8zZvYLl3xCMcowki9TcgtJ9lftmPpbI69BYzY74GstaI+h2U4jUQUz0e+qXXbYv3/5BlLcJ3yiqB0WP7g02JxhY/STPg0ZPOGiaLmDmFsYDQu8SmIKy2GY5UOMjFR9JQBENbqEmiEsB5erc9wO9R4yeIwsa4+rFseaOpIl6AAgky8gh30JcLEsX3hvqVGaxBzYkA4VSFLe5+RlvH7vRcUH32zvOerPXq7s9fC4fUIqraDNC5a0fYiIUOeD4uF7C5yE732p0bKdOpOFUqqYtGWU4yhBZNRuw9QBJMag+CfNnPB/obgrKquyQwRei9XYWbW7KcJ8rfV6Dou63v8DzbFieYfXZR2Bwy37D6m1aggiWtoW5qMM06ZfkRjku6oYl91v4diVpYKQPMhuOV+cO+5L02nuhnWIRGXg1lVq9SZCY9OkVUpj5Qb1YTs7tjz7W/KzecmrRRdZmFkEzMBElkKRhbLSWe5hzYvTtBg12qzGD3639HnQHoPs/HVU8JrlangBcd8TFNsiJC3loH5+rav8Eq/Anwp7bWEfRX7nhnwoPU2syRXYgNGj2vJkC6XepZXhWWo4MK3rGTrITahkIv93fjx8dfvHRTAOSWSSyOi7Q22imnp8q7C9/SX7gZpMjJ/jE+JF2SzJY5mjqSDBkv3csJqjyEQwEJMBo77+8LAK8CDOXjh8Ll4uLCVh7vC8ZMRWKIxbxH4jUUEe/+dthSrWLb0yqwJSxe17+mYhqkbnbiYesCqZ/tEOn7LKuktdw8eEVhjZjhWPlQzTuqugfEO0EH5ljgUCsgt9Fl1Kt2LYy47bRIoAwfGU+nEEE2aSU0XETae9WLt6evcvpyOKxoEXPNTFGx931IigRVtWx4iGi8ZlP7SsJaNnEvtzoT5KdXo7XYC9
 W25xN+kd
 RwSj+m1lIwBUUOSLLoRAhAXiy8elNzGZzQIz6c2pcTtW+0zxIsZs1a1V3nD++xlI1z9SRK6ffqekeBSbnI2EoU9HSGV7yzjxdNwTSKqW5gr+vmslxGXwf11DF5j30VCtIsJbPZkuWUDRuvl5sdVy/7PEYiGk4Uwo+LAh+VP8dVMTZMhWP64MSsO7bcZrPbkuEo9skDYehITbTZR+fElPc2U6vret0swhprhAocXrwK7eJm8GZCXVcHbFKxvgU/DqssKKnjXEwaxV9x/CalbID3R3yDNQZERYRsMhrAaclHExqOaF/yxawvXnZMMs0XrLYQcjjzi2Ipst1nCcAHQ19p+kfLud2IOr9IRiBfRiF4I1W4pLsHuxCB81J1O9CDA+H88/v05N9b/hIv4MPbQdaQDieUQhQvUZr+IejJLcbFB50lfMD54yGQSavxA1MVl5L6I1ANkl/Hv4v6C8+5eNnM5ya1cKsu3PniLNi3PNz1zZNLAPATltWqXXRZBpL/DPpkU7FEOA/OrOZEsIYJTSG9DWTsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/30/2026 2:17 PM, Huang, Ying wrote:
> Shivank Garg <shivankg@amd.com> writes:

>> PERFORMANCE RESULTS:
>> --------------------
>>
>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>> change in V5 alters this picture; please refer to the V4 cover letter
>> for the throughput tables [1].
> 
> IMHO, it's better to copy performance data here.
> 
> In addition to the performance benefit, I want to know the downside as
> well.  For example, the migration latency of the first folio may be
> longer.  If so, by how much?  Can you measure the batch number vs. total
> migration time (benefit) and first folio migration time (downside)?
> That can be used to determine the optimal batch number.
> 

System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hardware.

Benchmark: move_pages() syscall to move pages between two NUMA nodes.

1). Moving different sized folios such that total transfer size is constant
(1GB), with different number of DMA channels. Throughput in GB/s.

a. Baseline (vanilla kernel, single-threaded, serial folio_copy):

================================================================================
4K          | 16K        | 64K        | 256K       | 1M          | 2M          |
================================================================================
3.31±0.18   | 5.61±0.07  | 6.66±0.03  | 7.01±0.03  | 7.13±0.08   | 11.02±0.17  |


b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):

============================================================================================
N channel| 4K        | 16K         | 64K         | 256K        | 1M          | 2M          |
============================================================================================
1      | 2.16±0.14   | 2.58±0.02   | 3.00±0.04   | 4.56±0.28   | 4.62±0.02   | 12.65±0.08  |
2      | 2.68±0.09   | 3.69±0.15   | 4.52±0.04   | 6.75±0.06   | 7.19±0.19   | 14.38±0.06  |
4      | 3.07±0.13   | 4.62±0.09   | 6.47±0.56   | 9.22±0.15   | 10.24±0.47  | 27.01±0.11  |
8      | 3.43±0.09   | 5.40±0.16   | 7.67±0.08   | 11.25±0.17  | 12.60±0.60  | 45.62±0.52  |
12     | 3.50±0.11   | 5.66±0.16   | 8.12±0.10   | 11.97±0.19  | 13.43±0.08  | 61.02±0.92  |
16     | 3.54±0.12   | 5.79±0.14   | 8.50±0.13   | 12.59±0.15  | 17.21±6.40  | 65.23±1.70  |


2).  First-folio latency: Instrumented with custom tracepoints to measure latency per migrate_pages_batch() call.
    Result: throughput (GB/s) and first-folio latency (in microseconds), median of 10 runs.

A). Vanilla Kernel:

Here, n = workload size passed to move_pages() in folios. Move n number of folios with move_pages().
NR_MAX_BATCHED_MIGRATION is upstream default value 512.

--- Order 0 (4K folios) ---
     n      vanilla/cpu
(folios)    GB/s | first(us)
--------------------------
     1       0.04 |     24
     4       0.16 |     25
     8       0.29 |     31
    16       0.54 |     27
    64       1.15 |     68
   256       1.86 |    162
   512       2.21 |    264
  2048       2.62 |    208
  4096       2.74 |    182
 16384       2.73 |    173
 65536       3.28 |    166
262144       3.20 |    167

--- Order 9 (2M folios) ---
     n      vanilla/cpu
(folios)    GB/s | first(us)
--------------------------
     1       7.05 |    194
     4       8.78 |    186
     8       8.47 |    188
    16       7.20 |    193
    64       8.23 |    191
   256      10.51 |    180
   512      10.88 |    173

Takeaway:
In each migrate_pages_batch() call, folios are first unmapped, then try_to_unmap_flush(),
and only then folios enter move_to_new_folio(). So first-folio latency is bounded by the
per-batch unmap+flush cost, and then plateaus once workload is large enough.


B). Patched kernel:

Here, N = NR_MAX_BATCHED_MIGRATION (in page). Total migrated data is fixed at 1 GB.
Change N with a knob to measure impact of different max batched size.

--- ORDER 0 (4K folios) ---
     N         offload/dma1          offload/dma4          offload/dma16
               GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
------------------------------------------------------------------------
   512         2.13 |    639         3.23 |    290         3.27 |    253
  1024         2.17 |   1261         3.44 |    582         3.58 |    536
  2048         2.01 |   2769         3.09 |   1360         3.45 |   1083
  4096         2.10 |   5059         3.13 |   2737         3.58 |   2115 
  8192         2.21 |   9320         3.17 |   5015         3.75 |   3617 
 16384         2.15 |  18689         3.31 |   9623         3.87 |   6937
 32768         2.12 |  42692         3.38 |  18893         3.83 |  14255
 65536         2.09 |  81956         3.38 |  38556         3.64 |  29003
131072         2.02 | 169563         3.22 |  81082         3.63 |  62236
262144         2.21 | 318424         3.12 | 170174         3.50 | 129413

--- ORDER 9 (2M folios) ---
     N         offload/dma1          offload/dma4          offload/dma16
               GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
-------------------------------------------------------------------------
   512         11.66 |    160        11.68 |    160        11.65 |    160
  1024         12.16 |    310        13.67 |    275        13.64 |    276
  2048         12.30 |    613        25.47 |    290        25.48 |    291
  4096         12.48 |   1215        26.19 |    566        42.59 |    335
  8192         12.56 |   2424        26.57 |   1118        58.72 |    470 *
 16384         12.61 |   4839        26.77 |   2218        61.94 |    896
 32768         12.60 |   9667        26.98 |   4422        63.75 |   1748
 65536         12.63 |  19318        26.99 |   8838        60.66 |   3543
131072         12.64 |  38935        27.02 |  17935        61.06 |   7178
262144         12.66 |  77694        26.85 |  35871        65.06 |  14129

In the batch-copy offload approach, DMA copy phase is inserted between unmap/flush and move,
So larger N increases first-folio wall clock latency. Throughput improves but with diminishing
returns.

For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=8192-16384,
because a larger batch allows the driver to distribute more folios across available DMA channels.
This is where we get most throughput while keeping the first folio latency in check.

This optimal batch value is hardware-specific. Other engines (eg. SDXI) and memory tier (eg. CXL)
will likely have different curves.

Does this approach and experiment look good to you?

Thanks,
Shivank




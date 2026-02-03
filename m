Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C87AAE6E7FA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5CE6B008A; Tue,  3 Feb 2026 05:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FF76B008C; Tue,  3 Feb 2026 05:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D266B0092; Tue,  3 Feb 2026 05:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0D626B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:47:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AA2A13AE53
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:47:08 +0000 (UTC)
X-FDA: 84402818136.11.C1E6E70
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by imf20.hostedemail.com (Postfix) with ESMTP id 459EB1C0006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:47:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Do1sMxPi;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770115625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjt0vyEZWEoZg746FQE7I8SncFIWw0xuUWxASTdJIA0=;
	b=ddAh6VRvB0VSZFojVVNLSiy/RQVuL2PIxIClMLD96gOt3Ml6AhkcogcoM8nkSKA4QrEXKj
	R69XoQWyaFY3Peyvs2ztfVHLWyf3S5Z6CETt8Iryrt+HyNxVUJkleALgOtIEQarcp5FRNQ
	JTG73v0f2WcqMR/Xf2Nut53wc6XfpZk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Do1sMxPi;
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770115625; a=rsa-sha256;
	cv=pass;
	b=A28Mnf20sK5x1RKRRfLl3Uq5sF+HgOwlOxM9l1H4lBx+hpiMTzntYfgthiiTVSj+59k4oj
	RAgUrU8C/83oRd5PPwxTwErRo1FTci1F4V8NjZJc5/CM7Dfx4MRcHSOztBB6eyX8xybyZU
	3OgW0tjezF4GutwjrQmjY79XC7LSQgU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhRBiK3xgb0LYA0N8X45C5tBV8E5H5zg14Ke1YU03bNewFe0F1NeR/wO7YrcCS005EdTrcUkSh51Git9Drhes/KyDiFPhMO0bagLYwJ8tPWgmEpb0u66Bt6sBnxcHdvs2BdRQrLzXkiDqjWFjL+X3wLAQDJdNiAkfPXaMCZkOjBhQftoNxlN4ey79J5WB5wo8oAF1zV1S0UBx05U3d4SAgcvpU5/hLWiRKMr3YhrOafcTlMoVE+9iD7CiWQQfldyh2dlqfwcsIzfzS1EHjPGP9qvYXosWnaPaA63ZX0E8lUQcGj2srknts6oml/XJRBYlNCXu3CIvVR89QTi1vcRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjt0vyEZWEoZg746FQE7I8SncFIWw0xuUWxASTdJIA0=;
 b=j+DQ7MuxAh0DtSvjKAirBrI9OtoAd5FOs7hqappwxxkj2KAFT/ynCE4AEIHakqPCJBxbWShyPb4oC7azlVUWO4QH2OmbZy/bvIYHomVdhFP+XP8Qdn8QYXCnKaHVQq4byYulLYsnIkWpwEfA7xDVKRHVFLw5oK6hpRXLNItxeIB1/lMNVPK94gpxo02regG1CvVjk5qiB7Mkvd+jL+/TJnQ8GkztbnrOjUA5RUfHzD1hGkvn9yPcFO7M9GKsHxTCMdSkw6Dz01kGZ0QuGgqJMWzRHF33oVWL0X4xB0AZ/TkLKINFCMuEkDrvHZm5jzdFV4PgZK8GLR0aaw10Dpeqkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjt0vyEZWEoZg746FQE7I8SncFIWw0xuUWxASTdJIA0=;
 b=Do1sMxPitTuU4XxAdWoqhvLI4xAJhHgnLWRjyMnwRIDha3XxYzh6ftrqQYxXCHn9eIjIJfM5QyNizB/UpECCtsdqcWHvHHKEegf+jS9GvrIONS8bYkl49h7QEzddTU1PqT3OLfI5PCLEFlaroCQzQxK3NLpnfOVA/q5xAikgZupMAmgzju9+bvGPvk2aSP4zC1APHXHOxa6o7Hyrl3H/HtDGCuRDvvk19trtd3cvCqxQ+IWgcihWi9jK3/GdfA3ZzsH33hdNiRp3+J5Akl9SYGLiV9tTlnoJIhtT9InDV8kNrzQOVT5HLEYgEXMCifLoUwU590OQuRSqn7VtONvVmw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 10:46:55 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 10:46:55 +0000
Message-ID: <779d6e58-caab-439d-9bc5-c996896c51a3@nvidia.com>
Date: Tue, 3 Feb 2026 21:46:50 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260202112622.2104213-1-mpenttil@redhat.com>
 <20260202112622.2104213-2-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260202112622.2104213-2-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: b5253dba-3e05-4795-7acb-08de63118c41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUxIc3hkV0lGNWpkVzZNQjIzcTNFRjNkSlRDUk9yV09vSHdHcE9QcDdLN3Fz?=
 =?utf-8?B?bG5ONTVGWWRnSzkxNVhCSGNTQ0FvbEc1NC9LRFdVZExPVy9vR2RqWkt5VTZ5?=
 =?utf-8?B?OHc3cTJZMVY3bVd3eTVpZXJYNHhqK0VaamZpUno0QlQrU1dHV09IWnVuUDNi?=
 =?utf-8?B?U0dveXBJYzdvTTJOVWlvUkszcXFQTW1WZmxFNEhnOHQwY3VwSkNOTG01cHFN?=
 =?utf-8?B?OUFCVDltVGpzUWRTTjNtQ2VlMDAxQndzdWdYSHhpSktyOXdvRklRSi9TTjRz?=
 =?utf-8?B?VkR2c1hmc09ISXh4ZU9oekdJY2NHSHlIY2d1MFBUbEVLWkhMVkVTTWovMk9i?=
 =?utf-8?B?ZmlEMHJzcDM2Qk9tVW90cEpjdXM3TU5OVFVuczNmWXpsRTFtZ01tNFplWmdI?=
 =?utf-8?B?dTdqWE5WSnRkWElSVlZZaEhsMC9rRXMwc3NQVUZFOEFVMjhlLzJKeFVGb2Nk?=
 =?utf-8?B?SmoyOG4rVEMvb2UxdkRJZUtJQVdvSU5rNUR1aVdtVlg5MjRrUnNvMHJldHBK?=
 =?utf-8?B?dmFZOHlrMDhCeGordm9MWjlzMkxoa1dWSTI1VkY0Q3VEMmRkOHc2WFVicTlM?=
 =?utf-8?B?b25nQnJNWVNRd0ZtRUFmYW1sOXEwVTVzTGs3Y1ZBNjJIckFCSlI0YXhIZmQ0?=
 =?utf-8?B?OS9JbHJXeDlBcVlzaUZCY2ZHMzc4Z2ZGNzVURTZ0L3NvaytxMXUxSk1SaCts?=
 =?utf-8?B?QnBCNWlMN1krWXBFRWxKRllMenZTWFh4TWZyMU5FbUxtREd5WEdxUFZaOEh3?=
 =?utf-8?B?NFhaUFZzcXJJcG05SU1rK21ROHc1Z2Z6aE14MU1SNWkrOHJPNXRSc2FIam5F?=
 =?utf-8?B?OGMwRy9WbC9MT0JUV05XYXFFR1dNMmNqNCtMTjNKVmcvdVl3Unk0RGVUZktM?=
 =?utf-8?B?S0VFbTVTdkR1bXhVZnJCdWV1VzFXM242SjlxRHNLSC9SOHMvZzZnay9IV3Fo?=
 =?utf-8?B?aFNtVC9MRy9abnY4MEFwYVhQUkVOZnFTNU5KZVF3d29lVTY2RjEyWTNRUCs2?=
 =?utf-8?B?dVBPQXVHcFg2TThoOWxnak1Od2MyTVZFZ2k4bUZxbFN0WDlUSlR6SU5aZ2lQ?=
 =?utf-8?B?TCtDT3Ntc2RPRkdWMXhxanRSTHhtelNlNmxsMWJ1VG43dmRWUTZyTUFWTUVR?=
 =?utf-8?B?bytvVW13T29KTWhtMlRKaHlTbzVVUXZJRXdsS09aUjlVSjlNOVNqZ3F0Z05U?=
 =?utf-8?B?UnRoUk91a2xBRjczVnNieTdlTWtHZWtZc2RzYzNUd3M3UEdLMVF3eGp4ZUJw?=
 =?utf-8?B?S1VqQ0crWlFxZklLN3lHMGZnbEpobzRGOVVSd3gxYlBHQXh1U25EQmhpMlJP?=
 =?utf-8?B?NHZJUHFkVkpOWlI5L1R2TXN6Tmh5U1E3ZjBwWXFaSU5BWGg0VkFNUk95aS9i?=
 =?utf-8?B?WVJscklneVFOTTR6d1JRU0plb3c1U25GejQxY1FrRmlpRnhnQ2JxdzlkelN5?=
 =?utf-8?B?UTJnY3c0Z2ZNdXBXVFREckJOeXZDWDNUM09xTEJKVXFMQkdGakxzWFVDeG1z?=
 =?utf-8?B?VUlIaUhvdS9va0tsUGVDMjY1MlM4VzJMbXlpRzRPRHo2WEFRcGRvSHAwUE1Y?=
 =?utf-8?B?S2pJMUxtbDFlTzlQMkFmSkIvN0QvdHdXeDR5MzNpVllxMzRhbUlWNmJDOTlr?=
 =?utf-8?B?dGZoODQ3KzNacXp4b2lVOC9PMk5xblY1UjA2UUI5aEtwTlBLaHhFVENsYUVq?=
 =?utf-8?B?NzZIdFpEcWM2aURUV0J1TC9MZ01TZjJTR3ZUZ2VxNGRkSmhoaUZUc3FrK25q?=
 =?utf-8?B?TUNmaTdoWFJyK256dnBkQlpBY3laeXdnVEV1eGRCd1lrcHZWcTAzQ2dtTkdB?=
 =?utf-8?B?N01QL2phUlgydS9oZjV6dkMxVWt0em5NR0dqQWdWZTU5RWtSRGVIRWVSZzgx?=
 =?utf-8?B?SGd3OU13Wk9zQVRKdFV5VUx1WVJYUVpyMEt5YjVEb0ZEUHdXYTR2MmJiZEVL?=
 =?utf-8?B?QmdoRFB3akpyVWJ4dGFsUjZJdUgra3pJWlp0bFlIQ0tRV3FVOGhieGxHaTdk?=
 =?utf-8?B?Zjh0bmlkOFJubXhxTDV5Tjl0OHNOZStqR29mOEpDYUc5SXljN0pTWmJFeFZ4?=
 =?utf-8?B?UGlXYlBiY3JVL1hGNGhiSHR3L2NGUGVnNVJCd3ZqamJacHd0Z0liREk3REFk?=
 =?utf-8?Q?GNZM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjEwckVVblZkZkZYOUp5dDEvS1hRbzBvQ0gybFA3QU1ObWQ1UER2SmtURm53?=
 =?utf-8?B?ZWowVFdxN0Y4aHk4UEx4dzhRYWhQYTZYN1gzUThKY0NIWERqaXU3dkRVMzRQ?=
 =?utf-8?B?dyt0Y2pLWjhWSUpVRWZzMEMxdUdoMGpuUTdPcUU2b3dNY2c3VitoZGhRUTRj?=
 =?utf-8?B?dG9LS09zeklBQkw3ZXk1Zmt5U2hwQmRGemJkRHVHUExyelVpNlZlTTFnVGl4?=
 =?utf-8?B?K0o3aHFoTzA5QVZiWXYzeXduTnI1bjJ1VVJJRUhhWjFFYVczMWZVcXJyQ2Zu?=
 =?utf-8?B?MU9UM2NxaGE5TExLWDNwQ0ozME9idHhpb21OMUJUaUswRUtiWFcxNVFFV3lO?=
 =?utf-8?B?Y1FTVklVYVF3aXJCSE1qblpqLzZXNmdsS2MwdHR4aXRkZFZjVFROY0VWaDJE?=
 =?utf-8?B?ejlGUDFqSFJtcHJmeE8vT2lyRVMzSWx5cVlTWGNrcXBVNkNMbFMxdzRSV1k3?=
 =?utf-8?B?UU82UVRKNUJBTUFRalBTblp3SmYyWGg2ZlBJV2xaaWNNYTdPWGgrNXdaUktZ?=
 =?utf-8?B?Zm1lQWppZzYrSld1b2NwT3NmSXZGWXltYmt0TnM3YmExUFBTU3NrVmxMZ2RI?=
 =?utf-8?B?NEJ1WEFNdURVRWttNFF5VkZidXY3TW9lOVJpWkpNUGVudklBcEhpWGxhb2Fs?=
 =?utf-8?B?dEs5RFdJOXZlVUJvcndwejRoaDdkcWNYVlcwVFUvMDIyRjBtWk5KUEYwUlhK?=
 =?utf-8?B?OEw5ZmM4dlBxcmRQdVFNTU5WcTc3a0FaYUtVOTBLVGtRNkV2WElOL3BFYzlz?=
 =?utf-8?B?MDgrM2hDZGVMckJhNkdKWVFiWlQwMHEycUxObUhzZVNsK2JJZWhaNVpTTG9q?=
 =?utf-8?B?eWRhSncxNGdNVkpMK2ZGeDlRNnZkY0U1aUowQVNLVSsrOFNDNEN1WHc0MTFK?=
 =?utf-8?B?MWZ2ZzRyWWhjL3pEQmJ0S0h1dkp5czJaVThFZ0tQQUJZaXY2bXJvWFNreXZ1?=
 =?utf-8?B?UGdXRmNxRnJqY3R6NldRYnhMSlZuMmRSaVo5OStYcW1XaGVJcklLcGVZNTh6?=
 =?utf-8?B?TUYxOU9RNHRDbzMvT3BzYkZDVzNPb1VTbFNFS1VPZ2E4QVpHUis0M2hnNGlJ?=
 =?utf-8?B?Nys0cGV6VVBhcXdKT3NseEtzdEMrb1BKbnd5Unc5SXM5RTR2cCs2WUc4ZjF3?=
 =?utf-8?B?T29lSlFlVTQ1MWR6ZUM4Vnd6eHE4ckdiYmxSMHhFNTkvOVp6SVNUclhXaVJG?=
 =?utf-8?B?RHI5VjBzQ29FZkJPRmF1RkFHUFNaR3dKYm9LcVR3YXJkcWxvUEpndWdHUStX?=
 =?utf-8?B?MWRieXVpRlpNemJVMXdEdnRpbmdZeVVEWEVSWXlxQzJZOUVDRU9KWE9XcDZr?=
 =?utf-8?B?ZmpaY0dRakpkRXE1U0E3b3JZRWpQdnlkNGhNbEh1VGpRaTJvbytpSzNhOHRi?=
 =?utf-8?B?R2Z4OCtvSC9lNU0wcUd6U0dCVnN1RmJ4Rm0zWVBxMXhMQ0pFZWk4WGZKNGxD?=
 =?utf-8?B?SllvUjl0MWQyeE8xRGUxbXYrN0Q0ZDAybFVkYnlRMjIrOXBIdXdPYmR5a2lX?=
 =?utf-8?B?MHZZWTJnM2l3elFNclpOYktwTmpMNS9IZ21uRTVxa1hVYWtnZno2MERXSWZv?=
 =?utf-8?B?SFUvT3A4NzNSWDlVWjV0U1hJVWZZWFJZMUMwdHF2SXZldVV2STB6TEZiOWJy?=
 =?utf-8?B?cDR2ZUNmWGc1Wk1TRWdjaFF6RFNBcXhKUDVlOUo4akx6cHhFQ09mN001dkNG?=
 =?utf-8?B?M2lKMjg4TDBtcG9CSVJ2UjlET1pXWUFXOGovVGtxSllBeHVyQ0IyWlcwdXZz?=
 =?utf-8?B?VXQzVDJ1NlBtYU81WWY1RWI1NGNGemd4YmsrRUd6R1U5NUhPMWpBZUlwK0Z3?=
 =?utf-8?B?anIxaWtjQmtLMU84cFBubEkyRnhTZWh2TlAvK25ZQUVPRy90bFkzYkJ1ZTJ4?=
 =?utf-8?B?K1VqWmVmaXNVSzU2Si9XY3FmMHpTYlpOOUdMVEhUM0JGb2FWSW1pOHJjWjlh?=
 =?utf-8?B?MENsWDN0THoreWRQVWcwN1Zsc0sycGppZUt2Wld2OWVubk5JdGdkcklWbUNv?=
 =?utf-8?B?RjJGMUdaVE9VT25DSFkwS1lURlVYM2o1b3MwOCsrNFQzWUVGWUR3VlJVWkk2?=
 =?utf-8?B?VXN4Q0pjcExQK1VLaEhiVU1DcEVvL2M1VnQwanRJRnJRSkxrVXZQVC9QSEZu?=
 =?utf-8?B?WUxCN0d6VXFldG8yYUdEYVk4V0s2NGxiVFY4dVR1Wk9FTGFXQ2U4NWMyOVhB?=
 =?utf-8?B?SEFGWVE3UE42cFdDUUt4cjVrZWZjNGpSMHpsQWMvcnY5c2xZRmRXaTVNbWIr?=
 =?utf-8?B?RDdBOEpJajlFcmZqcmxXY1ZJcE4wczhkTlF3ODdNNnJvcUxwSDJtRGNncENJ?=
 =?utf-8?B?OUcxczgyOHRXNDJkUTRwRU9qamhET0kyRmhkUzM5YVlicU5GNWRkdTE0YUZ4?=
 =?utf-8?Q?Yq9d3evG0li8qIZ5ks142zfNbyH7kcMpq1m9POzNS9bsH?=
X-MS-Exchange-AntiSpam-MessageData-1: wI4MhE63GN98xg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5253dba-3e05-4795-7acb-08de63118c41
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 10:46:55.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UoZ1LBpteSbfokI9ZEXHWsR84FAoTuDzOWDKt622OPIGW9Asx62pyOeEr1AP+pp8Tq32OySgkyMnrZMa+UcVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641
X-Rspam-User: 
X-Rspamd-Queue-Id: 459EB1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 48jm6bjnoqpmkeh6ybdke5yxeq5e5stz
X-HE-Tag: 1770115624-229677
X-HE-Meta: U2FsdGVkX1+wfJepl1lSS6k6uSitllnVQrIzfADGBu5JrCXf/ryEPC+rKfERcvcqBR2LEcbYTKc6kgXepT8ccng4oNr0kSqlYIiAcRe/2LvyV9JEQGUihoH4R0vbl1ugUqBDfxFAZxB5MvC5G8yYcqL6c2XLwCSxdNEkk781ghvaCKSVpVMnssRckeBlAO32K1iqdB1h4qxeAQ0QSiYeYfKHja52bVuP8k1/LFvatHNgVXnRqsEr1DG1uyb/YjsedrTkjjvmDFtPJLhKX3N4QuhX/Xd31KW2EA7qArb7gA+SvNifV53yRZL1LmQGP4A9USHNWAg/nBxI8WzSQ1zZUNPNp2YoNiNknjodob7hu05udqpPa4bGdVBJlx0R2lb7wkLfQGiUINoxk/2AfJ7wKKvKkyKMyI2MxT/4eE6U5GwmX9XZf284h3s/aGU5pYgesBYRH7m/meiCj5lbWkFHeftrd1mauOtuURWKiz5URsicxa8OTIJf87cNrVawzoGZ7TlVpK9K0k+lBWZr+vL6z5sWPUs5DrsOcJpgwSn3TbE6yleVD+BBntwCA4THc4py0DuwSzgKMkYCuAIGqATa16Q2Kbk1GDrz7PJ1IiO4DExokH1Fbdix4/XceYDhphkMkR7RV4nZ045/KF7JJdGQv1Kl/4C7MoE6g+5GSkExbiRIv/hsMgEf4ZFHpesUmPeKd+XsQCZ9p9hUADgIozNUhPJo/PYN3ch8AIoW5g4hoBZlsS3yUtK+KLF3phgGor1NSEp1PyGlsfm+IaLQoI9dT7AjDqOzrp8IX8KTo/9tkUDpICSxFG4qwpghkliFlz3vdkYSxgtNwiJAvyhYi/yH3/X5c6QkoZr9ZfZcIWFiVffb4FMGkVyO5owyc1FE0Kw+NBrRwQaU2MFM3/1AvchL1ND3Qc/9GhOK4upQLU+tF2+tHI+LTVHVkOx9x3LaneYfmFi9lRsqsq4Nz0MXr82
 jmyIwWs0
 pYTxqsYTr/JrTeh6v8YqkffmbHESkmqjOaXe6k+ZpnodEYWqVSK3BedpMVWVqSl8irtET9Kv1edsyV6HsVXmGp86HTIVXkqtSLa6NYAQqQhTLBDQD2myfR+R6XWs5z2lDzZiTURWEd1zhBEfB4vYrbX3/Bq88lXsmZm6O7FXAP0H1EMNt36U9RpUT2CcBrF5ibIsXLtXcQcUmPV57Zn/0/zXinAYee69oKeN5FFj5UG22/UI0kHMdyEgpX0B0hUIwXpa6dejHC0drQW0E4TV9NN78zlKDHYZtJP3p7qmB7EY00E94FCohEfe8X+V/Hbl7ML5S++xiexyliXioPslAxo1vHJl2KiOf+04sR7I6zUsNIxj3yID51BHB6g+QpQpeudwTvd3SuoWek/ZaqRFRHpwf+6SO2zSyBgFIinE4UHwECeJYoj0g7s8UAbQyLYn05mpimun5HSOdPQvGL1ZlqnaSIJEv5CBRcZCxqaW9KuZe7Bni/jTvg+9XVC30eo1YMxgL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 22:26, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 

Do we have performance numbers to go with this change?

> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/hmm.h     |  19 +-
>  include/linux/migrate.h |  27 +-
>  mm/Kconfig              |   2 +
>  mm/hmm.c                | 802 +++++++++++++++++++++++++++++++++++++---
>  mm/migrate_device.c     |  86 ++++-
>  5 files changed, 871 insertions(+), 65 deletions(-)
> 
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index db75ffc949a7..e2f53e155af2 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -12,7 +12,7 @@
>  #include <linux/mm.h>
>  
>  struct mmu_interval_notifier;
> -
> +struct migrate_vma;
>  /*
>   * On output:
>   * 0             - The page is faultable and a future call with 
> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>   *                      to mark that page is already DMA mapped
> + * HMM_PFN_MIGRATE    - Migrate PTE installed
>   *
>   * On input:
>   * 0                 - Return the current state of the page, do not fault it.
> @@ -34,6 +35,7 @@ struct mmu_interval_notifier;
>   *                     will fail
>   * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
>   *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
> + * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
>   */
>  enum hmm_pfn_flags {
>  	/* Output fields and flags */
> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>  
> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> +	/* Migrate request */
> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),

Isn't HMM_PFN_COMPOUND implied by the ORDERS_SHIFT bits?

> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>  
>  	/* Input flags */
>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>  
>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>  };
>  
> +enum {
> +	/* These flags are carried from input-to-output */
> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> +		HMM_PFN_P2PDMA_BUS,
> +};
> +
>  /*
>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>   *
> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>   * @dev_private_owner: owner of device private pages
> + * @migrate: structure for migrating the associated vma
>   */
>  struct hmm_range {
>  	struct mmu_interval_notifier *notifier;
> @@ -117,12 +130,14 @@ struct hmm_range {
>  	unsigned long		default_flags;
>  	unsigned long		pfn_flags_mask;
>  	void			*dev_private_owner;
> +	struct migrate_vma      *migrate;
>  };
>  
>  /*
>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>   */
>  int hmm_range_fault(struct hmm_range *range);
> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>  
>  /*
>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..104eda2dd881 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/hmm.h>
>  #include <linux/mempolicy.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
> @@ -97,6 +98,16 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>  	return -ENOSYS;
>  }
>  
> +enum migrate_vma_info {
> +	MIGRATE_VMA_SELECT_NONE = 0,
> +	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
> +};
> +
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	return MIGRATE_VMA_SELECT_NONE;
> +}
> +
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_NUMA_BALANCING
> @@ -140,11 +151,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>  }
>  
> -enum migrate_vma_direction {
> +enum migrate_vma_info {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
> +	MIGRATE_VMA_FAULT = 1 << 4,
>  };
>  
>  struct migrate_vma {
> @@ -182,6 +194,17 @@ struct migrate_vma {
>  	struct page		*fault_page;
>  };
>  
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	enum migrate_vma_info minfo;
> +
> +	minfo = range->migrate ? range->migrate->flags : 0;
> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
> +
> +	return minfo;
> +}
> +
>  int migrate_vma_setup(struct migrate_vma *args);
>  void migrate_vma_pages(struct migrate_vma *migrate);
>  void migrate_vma_finalize(struct migrate_vma *migrate);
> @@ -192,7 +215,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>  			unsigned long npages);
>  void migrate_device_finalize(unsigned long *src_pfns,
>  			unsigned long *dst_pfns, unsigned long npages);
> -
> +void migrate_hmm_range_setup(struct hmm_range *range);
>  #endif /* CONFIG_MIGRATION */
>  
>  #endif /* _LINUX_MIGRATE_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index a992f2203eb9..1b8778f34922 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -661,6 +661,7 @@ config MIGRATION
>  
>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
> +	select HMM_MIRROR
>  
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>  	bool
> @@ -1236,6 +1237,7 @@ config ZONE_DEVICE
>  config HMM_MIRROR
>  	bool
>  	depends on MMU
> +	select MMU_NOTIFIER
>  
>  config GET_FREE_REGION
>  	bool
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 4ec74c18bef6..a53036c45ac5 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -20,6 +20,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/leafops.h>
>  #include <linux/hugetlb.h>
> +#include <linux/migrate.h>
>  #include <linux/memremap.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jump_label.h>
> @@ -27,35 +28,70 @@
>  #include <linux/pci-p2pdma.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/memory_hotplug.h>
> +#include <asm/tlbflush.h>
>  
>  #include "internal.h"
>  
>  struct hmm_vma_walk {
> -	struct hmm_range	*range;
> -	unsigned long		last;
> +	struct mmu_notifier_range	mmu_range;
> +	struct vm_area_struct		*vma;
> +	struct hmm_range		*range;
> +	unsigned long			start;
> +	unsigned long			end;
> +	unsigned long			last;
> +	bool				ptelocked;
> +	bool				pmdlocked;
> +	spinlock_t			*ptl;
>  };

Could we get some comments on the fields and their usage?

>  
> +#define HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, locked)		\
> +		WARN_ON_ONCE(hmm_vma_walk->ptelocked != locked)
> +
> +#define HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, locked)		\
> +		WARN_ON_ONCE(hmm_vma_walk->pmdlocked != locked)
> +
> +#define HMM_ASSERT_UNLOCKED(hmm_vma_walk)		\
> +		WARN_ON_ONCE(hmm_vma_walk->ptelocked ||	\
> +			     hmm_vma_walk->pmdlocked)
> +
>  enum {
>  	HMM_NEED_FAULT = 1 << 0,
>  	HMM_NEED_WRITE_FAULT = 1 << 1,
>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>  };
>  
> -enum {
> -	/* These flags are carried from input-to-output */
> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> -			      HMM_PFN_P2PDMA_BUS,
> -};
> -
>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> -			 struct hmm_range *range, unsigned long cpu_flags)
> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>  {
> +	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
> +	enum migrate_vma_info minfo;
> +	bool migrate = false;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (cpu_flags != HMM_PFN_ERROR) {
> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
> +			migrate = true;
> +		}
> +	}
> +
> +	if (migrate && thp_migration_supported() &&
> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
> +		addr += PAGE_SIZE;
> +		i++;
> +		cpu_flags = 0;
> +	}
>  
>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>  		range->hmm_pfns[i] |= cpu_flags;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -78,6 +114,7 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
>  	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>  
>  	WARN_ON_ONCE(!required_fault);
> +	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
>  	hmm_vma_walk->last = addr;
>  
>  	if (required_fault & HMM_NEED_WRITE_FAULT) {
> @@ -171,11 +208,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>  	if (!walk->vma) {
>  		if (required_fault)
>  			return -EFAULT;
> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  	if (required_fault)
>  		return hmm_vma_fault(addr, end, required_fault, walk);
> -	return hmm_pfns_fill(addr, end, range, 0);
> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>  }
>  
>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
> @@ -208,8 +245,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>  	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
>  	required_fault =
>  		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
> -	if (required_fault)
> +	if (required_fault) {
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;

Could you explain why we need to now handle pmdlocked with some comments? We should also
document any side-effects such as dropping a lock in the comments for the function

> +		}
>  		return hmm_vma_fault(addr, end, required_fault, walk);
> +	}
>  
>  	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> @@ -289,14 +331,23 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  			goto fault;
>  
>  		if (softleaf_is_migration(entry)) {
> -			pte_unmap(ptep);
> -			hmm_vma_walk->last = addr;
> -			migration_entry_wait(walk->mm, pmdp, addr);
> -			return -EBUSY;
> +			if (!hmm_select_migrate(range)) {
> +				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +				hmm_vma_walk->last = addr;
> +				migration_entry_wait(walk->mm, pmdp, addr);
> +				return -EBUSY;
> +			} else
> +				goto out;
>  		}
>  
>  		/* Report error for everything else */
> -		pte_unmap(ptep);
> +
> +		if (hmm_vma_walk->ptelocked) {
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->ptelocked = false;
> +		} else
> +			pte_unmap(ptep);
> +
>  		return -EFAULT;
>  	}
>  
> @@ -313,7 +364,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	if (!vm_normal_page(walk->vma, addr, pte) &&
>  	    !is_zero_pfn(pte_pfn(pte))) {
>  		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
> -			pte_unmap(ptep);
> +			if (hmm_vma_walk->ptelocked) {
> +				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +				hmm_vma_walk->ptelocked = false;
> +			} else
> +				pte_unmap(ptep);
> +
>  			return -EFAULT;
>  		}
>  		new_pfn_flags = HMM_PFN_ERROR;
> @@ -326,7 +382,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	return 0;
>  
>  fault:
> -	pte_unmap(ptep);
> +	if (hmm_vma_walk->ptelocked) {
> +		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +		hmm_vma_walk->ptelocked = false;
> +	} else
> +		pte_unmap(ptep);
>  	/* Fault any virtual address we were asked to fault */
>  	return hmm_vma_fault(addr, end, required_fault, walk);
>  }
> @@ -370,13 +430,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
>  					      npages, 0);
>  	if (required_fault) {
> -		if (softleaf_is_device_private(entry))
> +		if (softleaf_is_device_private(entry)) {
> +			if (hmm_vma_walk->pmdlocked) {
> +				spin_unlock(hmm_vma_walk->ptl);
> +				hmm_vma_walk->pmdlocked = false;
> +			}
>  			return hmm_vma_fault(addr, end, required_fault, walk);
> +		}
>  		else
>  			return -EFAULT;
>  	}
>  
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #else
>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> @@ -384,15 +449,491 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  				     pmd_t pmd)
>  {
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> -	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>  
>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  		return -EFAULT;
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  
> +#ifdef CONFIG_DEVICE_MIGRATION
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}
> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		if (new_fault_folio != fault_folio) {
> +			folio_get(new_fault_folio);
> +			folio_lock(new_fault_folio);
> +		}
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> +					      pmd_t *pmdp,
> +					      unsigned long start,
> +					      unsigned long end,
> +					      unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *fault_folio = NULL;
> +	struct folio *folio;
> +	enum migrate_vma_info minfo;
> +	unsigned long i;
> +	int r = 0;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return r;
> +
> +	WARN_ON_ONCE(!migrate);
> +	HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, true);
> +
> +	fault_folio = migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	if (pmd_none(*pmdp))
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (pmd_trans_huge(*pmdp)) {
> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
> +			goto out;
> +
> +		folio = pmd_folio(*pmdp);
> +		if (is_huge_zero_folio(folio))
> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +
> +	} else if (!pmd_present(*pmdp)) {
> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
> +
> +		folio = softleaf_to_folio(entry);
> +
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +	} else {
> +		hmm_vma_walk->last = start;
> +		return -EBUSY;
> +	}
> +
> +	folio_get(folio);
> +
> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> +		folio_put(folio);
> +		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +		return 0;
> +	}
> +
> +	if (thp_migration_supported() &&
> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +
> +		struct page_vma_mapped_walk pvmw = {
> +			.ptl = hmm_vma_walk->ptl,
> +			.address = start,
> +			.pmd = pmdp,
> +			.vma = walk->vma,
> +		};
> +
> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
> +
> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> +		if (r) {
> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
> +			r = -ENOENT;  // fallback
> +			goto unlock_out;
> +		}
> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +	} else {
> +		r = -ENOENT;  // fallback
> +		goto unlock_out;
> +	}
> +
> +
> +out:
> +	return r;
> +
> +unlock_out:
> +	if (folio != fault_folio)
> +		folio_unlock(folio);
> +	folio_put(folio);
> +	goto out;
> +
> +}
> +

Are these just moved over from migrate_device.c?

> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					  pmd_t *pmdp,
> +					  pte_t *ptep,
> +					  unsigned long addr,
> +					  unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	softleaf_t entry;
> +	pte_t pte, swp_pte;
> +	bool writable = false;
> +
> +	// Do we want to migrate at all?
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return 0;
> +
> +	WARN_ON_ONCE(!migrate);
> +	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
> +
> +	fault_folio = migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	pte = ptep_get(ptep);
> +
> +	if (pte_none(pte)) {
> +		// migrate without faulting case
> +		if (vma_is_anonymous(walk->vma)) {
> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
> +			goto out;
> +		}
> +	}
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry = softleaf_from_pte(pte);
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page = softleaf_to_page(entry);
> +		folio = page_folio(page);
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->ptelocked = false;
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		pfn = page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable = true;
> +	} else {
> +		pfn = pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> +			goto out;
> +		}
> +		page = vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap = page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner != migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio = page ? page_folio(page) : NULL;
> +		if (folio && folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->ptelocked = false;
> +
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		writable = pte_write(pte);
> +	}
> +
> +	if (!page || !page->mapping)
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio = page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio == folio || folio_trylock(folio)) {
> +		anon_exclusive = folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte = ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		if (pte_dirty(pte))
> +			folio_mark_dirty(folio);
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry = make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry = make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry = make_readable_migration_entry(pfn);
> +
> +		if (pte_present(pte)) {
> +			if (pte_young(pte))
> +				entry = make_migration_entry_young(entry);
> +			if (pte_dirty(pte))
> +				entry = make_migration_entry_dirty(entry);
> +		}
> +
> +		swp_pte = swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> +
> +		if (pte_present(pte))
> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
> +	} else
> +		folio_put(folio);
> +out:
> +	return 0;
> +out_error:
> +	return -EFAULT;
> +
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *folio, *fault_folio;
> +	spinlock_t *ptl;
> +	int ret = 0;
> +
> +	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	ptl = pmd_lock(walk->mm, pmdp);
> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
> +		spin_unlock(ptl);
> +		goto out;
> +	}
> +
> +	folio = pmd_folio(*pmdp);
> +	if (is_huge_zero_folio(folio)) {
> +		spin_unlock(ptl);
> +		split_huge_pmd(walk->vma, pmdp, addr);
> +	} else {
> +		folio_get(folio);
> +		spin_unlock(ptl);
> +
> +		if (folio != fault_folio) {
> +			if (unlikely(!folio_trylock(folio))) {
> +				folio_put(folio);
> +				ret = -EBUSY;
> +				goto out;
> +			}
> +		}  else
> +			folio_put(folio);
> +
> +		ret = split_folio(folio);
> +		if (fault_folio != folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
> +	}
> +out:
> +	return ret;
> +}
> +#else
> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> +					      pmd_t *pmdp,
> +					      unsigned long start,
> +					      unsigned long end,
> +					      unsigned long *hmm_pfn)
> +{
> +	return 0;
> +}
> +
> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					  pmd_t *pmdp,
> +					  pte_t *pte,
> +					  unsigned long addr,
> +					  unsigned long *hmm_pfn)
> +{
> +	return 0;
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (!hmm_select_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma = walk->vma;
> +	hmm_vma_walk->start = start;
> +	hmm_vma_walk->end = end;
> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;
> +
> +	if (!hmm_vma_walk->mmu_range.owner) {
> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +	}
> +
> +	return 0;
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -403,43 +944,125 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	unsigned long *hmm_pfns =
>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
> +	struct mm_struct *mm = walk->vma->vm_mm;
>  	unsigned long addr = start;
> +	enum migrate_vma_info minfo;
> +	unsigned long i;
>  	pte_t *ptep;
>  	pmd_t pmd;
> +	int r = 0;
> +
> +	minfo = hmm_select_migrate(range);
>  
>  again:
> -	pmd = pmdp_get_lockless(pmdp);
> -	if (pmd_none(pmd))
> -		return hmm_vma_walk_hole(start, end, -1, walk);
> +	hmm_vma_walk->ptelocked = false;
> +	hmm_vma_walk->pmdlocked = false;
> +
> +	if (minfo) {
> +		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
> +		hmm_vma_walk->pmdlocked = true;
> +		pmd = pmdp_get(pmdp);
> +	} else
> +		pmd = pmdp_get_lockless(pmdp);
> +
> +	if (pmd_none(pmd)) {
> +		r = hmm_vma_walk_hole(start, end, -1, walk);
> +
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;
> +		}
> +		return r;
> +	}
>  
>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> +		if (!minfo) {
> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> +				hmm_vma_walk->last = addr;
> +				pmd_migration_entry_wait(walk->mm, pmdp);
> +				return -EBUSY;
> +			}
> +		}
> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;
> +		}
> +
> +		return 0;
> +	}
> +
> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
> +
> +		if (!pmd_present(pmd)) {
> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> +						      pmd);
> +			// If not migrating we are done
> +			if (r || !minfo) {
> +				if (hmm_vma_walk->pmdlocked) {
> +					spin_unlock(hmm_vma_walk->ptl);
> +					hmm_vma_walk->pmdlocked = false;
> +				}
> +				return r;
> +			}
> +		} else {
> +
> +			/*
> +			 * No need to take pmd_lock here if not migrating,
> +			 * even if some other thread is splitting the huge
> +			 * pmd we will get that event through mmu_notifier callback.
> +			 *
> +			 * So just read pmd value and check again it's a transparent
> +			 * huge or device mapping one and compute corresponding pfn
> +			 * values.
> +			 */
> +
> +			if (!minfo) {
> +				pmd = pmdp_get_lockless(pmdp);
> +				if (!pmd_trans_huge(pmd))
> +					goto again;
> +			}
> +
> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> +
> +			// If not migrating we are done
> +			if (r || !minfo) {
> +				if (hmm_vma_walk->pmdlocked) {
> +					spin_unlock(hmm_vma_walk->ptl);
> +					hmm_vma_walk->pmdlocked = false;
> +				}
> +				return r;
> +			}
> +		}
> +
> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
> +
> +		if (hmm_vma_walk->pmdlocked) {
> +			spin_unlock(hmm_vma_walk->ptl);
> +			hmm_vma_walk->pmdlocked = false;
> +		}
> +
> +		if (r == -ENOENT) {
> +			r = hmm_vma_walk_split(pmdp, addr, walk);
> +			if (r) {
> +				/* Split not successful, skip */
> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			}
> +
> +			/* Split successful or "again", reloop */
>  			hmm_vma_walk->last = addr;
> -			pmd_migration_entry_wait(walk->mm, pmdp);
>  			return -EBUSY;
>  		}
> -		return hmm_pfns_fill(start, end, range, 0);
> -	}
>  
> -	if (!pmd_present(pmd))
> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> -						 pmd);
> +		return r;
>  
> -	if (pmd_trans_huge(pmd)) {
> -		/*
> -		 * No need to take pmd_lock here, even if some other thread
> -		 * is splitting the huge pmd we will get that event through
> -		 * mmu_notifier callback.
> -		 *
> -		 * So just read pmd value and check again it's a transparent
> -		 * huge or device mapping one and compute corresponding pfn
> -		 * values.
> -		 */
> -		pmd = pmdp_get_lockless(pmdp);
> -		if (!pmd_trans_huge(pmd))
> -			goto again;
> +	}
>  
> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> +	if (hmm_vma_walk->pmdlocked) {
> +		spin_unlock(hmm_vma_walk->ptl);
> +		hmm_vma_walk->pmdlocked = false;
>  	}
>  
>  	/*
> @@ -451,22 +1074,43 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	if (pmd_bad(pmd)) {
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  
> -	ptep = pte_offset_map(pmdp, addr);
> +	if (minfo) {
> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
> +		if (ptep)
> +			hmm_vma_walk->ptelocked = true;
> +	} else
> +		ptep = pte_offset_map(pmdp, addr);
>  	if (!ptep)
>  		goto again;
> +
>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
> -		int r;
>  
>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>  		if (r) {
> -			/* hmm_vma_handle_pte() did pte_unmap() */
> +			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
>  			return r;
>  		}
> +
> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
> +		if (r == -EAGAIN) {
> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +			goto again;
> +		}
> +		if (r) {
> +			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			break;
> +		}
>  	}
> -	pte_unmap(ptep - 1);
> +
> +	if (hmm_vma_walk->ptelocked) {
> +		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
> +		hmm_vma_walk->ptelocked = false;
> +	} else
> +		pte_unmap(ptep - 1);
> +
>  	return 0;
>  }
>  
> @@ -600,6 +1244,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
> +	int r;
> +
> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
>  
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)
> @@ -622,7 +1271,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  				 (end - start) >> PAGE_SHIFT, 0))
>  		return -EFAULT;
>  
> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  
>  	/* Skip this vma and continue processing the next vma. */
>  	return 1;
> @@ -652,9 +1301,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>   *		the invalidation to finish.
>   * -EFAULT:     A page was requested to be valid and could not be made valid
>   *              ie it has no backing VMA or it is illegal to access
> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
> + *              is too low.
>   *
>   * This is similar to get_user_pages(), except that it can read the page tables
>   * without mutating them (ie causing faults).
> + *
> + * If want to do migrate after faulting, call hmm_range_fault() with
> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
> + * migrate_vma_setup() and after that follow normal migrate calls path.
> + *
>   */
>  int hmm_range_fault(struct hmm_range *range)
>  {
> @@ -662,16 +1319,34 @@ int hmm_range_fault(struct hmm_range *range)
>  		.range = range,
>  		.last = range->start,
>  	};
> -	struct mm_struct *mm = range->notifier->mm;
> +	struct mm_struct *mm;
> +	bool is_fault_path;
>  	int ret;
>  
> +	/*
> +	 *
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +#ifdef CONFIG_DEVICE_MIGRATION
> +	is_fault_path = !!range->notifier;
> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
> +#else
> +	is_fault_path = true;
> +	mm = range->notifier->mm;
> +#endif
>  	mmap_assert_locked(mm);
>  
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
> +					     range->notifier_seq)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -681,6 +1356,19 @@ int hmm_range_fault(struct hmm_range *range)
>  		 * output, and all >= are still at their input values.
>  		 */
>  	} while (ret == -EBUSY);
> +
> +#ifdef CONFIG_DEVICE_MIGRATION
> +	if (hmm_select_migrate(range) && range->migrate &&
> +	    hmm_vma_walk.mmu_range.owner) {
> +		// The migrate_vma path has the following initialized
> +		if (is_fault_path) {
> +			range->migrate->vma   = hmm_vma_walk.vma;
> +			range->migrate->start = range->start;
> +			range->migrate->end   = hmm_vma_walk.end;
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
> +	}
> +#endif
>  	return ret;
>  }
>  EXPORT_SYMBOL(hmm_range_fault);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..bda6320f6242 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -734,7 +734,16 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	int ret;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> +	struct hmm_range range = {
> +		.notifier = NULL,
> +		.start = args->start,
> +		.end = args->end,
> +		.hmm_pfns = args->src,
> +		.dev_private_owner = args->pgmap_owner,
> +		.migrate = args
> +	};
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> @@ -759,17 +768,25 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	args->cpages = 0;
>  	args->npages = 0;
>  
> -	migrate_vma_collect(args);
> +	if (args->flags & MIGRATE_VMA_FAULT)
> +		range.default_flags |= HMM_PFN_REQ_FAULT;
> +
> +	ret = hmm_range_fault(&range);
> +
> +	migrate_hmm_range_setup(&range);
>  
> -	if (args->cpages)
> -		migrate_vma_unmap(args);
> +	/* Remove migration PTEs */
> +	if (ret) {
> +		migrate_vma_pages(args);
> +		migrate_vma_finalize(args);
> +	}
>  
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have
>  	 * stable content and can safely be copied to destination memory that
>  	 * is allocated by the drivers.
>  	 */
> -	return 0;
> +	return ret;
>  
>  }
>  EXPORT_SYMBOL(migrate_vma_setup);
> @@ -1489,3 +1506,64 @@ int migrate_device_coherent_folio(struct folio *folio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
> +
> +		/*
> +		 *
> +		 *  Don't do migration if valid and migrate flags are not both set.
> +		 *
> +		 */
> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/*
> +		 *
> +		 * The zero page is encoded in a special way, valid and migrate is
> +		 * set, and pfn part is zero. Encode specially for migrate also.
> +		 *
> +		 */
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> +			| MIGRATE_PFN_MIGRATE;
> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> +		migrate->dst[i] = 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);
> +
> +}
> +EXPORT_SYMBOL(migrate_hmm_range_setup);



This is too big a change for a single patch, most of it seems straightforward as we've merged
HMM and device_migration paths, but could you consider simplifying this into smaller patches?

Thanks,
Balbir


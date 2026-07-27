Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF12DC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 02:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4C66B007B; Sun, 26 Jul 2026 22:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5346B0088; Sun, 26 Jul 2026 22:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446C96B008A; Sun, 26 Jul 2026 22:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE726B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:25:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F8824060B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:25:03 +0000 (UTC)
X-FDA: 85032964086.13.84C3C7B
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8725C14000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:25:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e9egp2xQ;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.7 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785119100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwGQKh6GrfL4U7anv6+KTZhZzY30v1m6bAokHQMFgdI=;
	b=VV3HueTyL0dfPFK2haMox+Gj2bf6r2dj5HGAenyPjPdQ2xjyk8Ny2h8c9w3fywnZjCKbbM
	6FxVjh8nn0Z4TMqBepYeDWG1i+LrjucSAdQ9t+KU2fOlNCcPOtdQovpU8NTfMWpjHybFH5
	Nc+tcn5F/B3I9zXmpBtCe9vS71QE8MI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785119100;
	b=xUWAdRP2tVdiQo3w6dH/1JYLNTRJDxkExYjstxjuzhNe9QlK93r1EjZXlFco4Lz9JlSSyq
	wYmtz10zS4oYibaAaDcfJIzbxmtr1YbWxkT6kf8B9MLl04B5R8lM8HqLYa2M5qTlmlelc0
	074r/gHAlvtDH41ThHGzdmynD3cOm1A=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e9egp2xQ;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.7 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJe1LPM/ENpA7hCXwF0Y9mfjUYHh/D33NBvuMMDUzlrGdYJj+A5mUbMY8StC5U6JETq/H5tiJtNQXv+6ZXA9C5SohDnIpAACS1Od7MhFuazEFfPqLwUB7jhmQdj94GK+Iux61kdOkO667XTSaZ1FP4L+8AS4ewB2R30Ch0eNHoKGg3NnodBEZdZqJSgPu2bg4ghj/CI2dlEJhhV7gocj8cN9dcZMQ4n+hl49a5XAXyZ6SQJciLq9OlCzaaP/SdEK7JDp1fgb6zu0GcdK1zF1bpDYowjcxkSu4GYZQpe1milwZ4jYhpe4eu5XdqxVerUU4IwmQ9CFyAIBldNRS1bwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwGQKh6GrfL4U7anv6+KTZhZzY30v1m6bAokHQMFgdI=;
 b=v3E5Qzx+woRUeAWTgIqqxwPossxg356YvuOLR3DMf64udPl62koGBj0UngriLtkKbvP/e3MeKZJE2etTaNP+uEF43sCqxeuBDmDwW+52zmT5g7zO1VKpbyhyi972saV/81xAGsCqDaZ9vdSF+f3YAybxxqBYPLUAd9Qskx6Q3Os3lWNJVNj6pK2GpKI3c31+/u1MG2GVHjzVTZNxxmo9J3Yx+8hYc/NVJ3AqfdfgqjLgP6BPMGww0W8sXzLJMk7PVFz4l6qe3if7zFw0KA97rHWLqmnJoq/VOMz5qJqztSvLUee9vX45sbEzCUld7ajcBKRdfgYAVPwpA40UdyyOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwGQKh6GrfL4U7anv6+KTZhZzY30v1m6bAokHQMFgdI=;
 b=e9egp2xQcIAlAJXp3Ykei/evceDpiYlXZ+yWtJBPQXuwpmxMM8PnZ95pCCOZk02OicQX7GR6ns7KXH6KxutpgY+CBNY00p76M6b2hU8M5d5EGTwN5qcGU0VwpsqwFn5ozImqkE3jyPArVO8pBX4SyLxuq5HnX5zLX646LnDAz/m9NpZ/lrUVaxYdML9fI+PdxfNxT7IyvjoNd/PhntZTdqAplbkPxhQNccT6cQX9NNLO4rpE/XLNebNO/Uouov3Ie43k99OkYV+hzRarC6M5SHLx2u7z0tvnSAtHH3rKvJtLUFJ1ek1bAak7bsmiXpLTi50P0PgnT5J8CWcGEG004A==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by MW4PR12MB7286.namprd12.prod.outlook.com (2603:10b6:303:22f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 02:24:56 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 02:24:56 +0000
Message-ID: <2ed297b3-d1ed-4a75-b85d-c95f831f1210@nvidia.com>
Date: Mon, 27 Jul 2026 12:24:47 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Arvind Yadav <arvind.yadav@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
 <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
 <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
 <c3532789-6b6f-4cc7-9d4e-cfb05cc88264@nvidia.com>
 <DK8Z3GD8IX2S.2GMOCJYCT3BAS@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <DK8Z3GD8IX2S.2GMOCJYCT3BAS@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3P282CA0078.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f6::11) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|MW4PR12MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c390e76-123c-4f4b-4e2f-08deeb863f83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f8bYqDjCxxfctFNlMx+pA3mk4f16LnukGT/vhGJAjEAw6GsdIoFnsXtoHtQbigGX5tTAPNcik8HI1isCulUf9A9eL6OeAQnfilnwrg5oNQoM8ZHUaS8If/h3B+v/mU2G2Cmul9O1xbsZPgXzkpVTb742lpiQ8bNS+sHDP5C98TxaSRiqdLcj9dzBdP0b/wrA8YdL4j45owfG3yX9o1RSo2k36yxaM1VjY8hxOWyEVdTTPMF+g0i3Rfm5YGKwp3EHu87KNd1Fr5Gm0SRCl3krOC5+Vcr8upFp4KD4RhKjIf7q2hIei8AZBAWxODlQojEErNdk2j/oFljcetcVYCbhBZG0QTZU+8AOMv1FSDkNzgaRYV5yCIYdZB/IuO9jMDQEP7NbyPgmcZp/22IFmsnw83DnQYJ+bmpv/mUBwGrOyRTfm8n7znhmpjI5svrKMalaXVWBKnZLIHxmbiTMJWFDbI294cram41zFSf6z/rfrPK2aZG5DCIkxbTW4f8LYDdhmG0cTFLwevYnnosz3WANQHmJvpEMq3oqDsFoDEnbUrAJ1bozkh1xC4igdgKDQrs2TiWyPfGcFQ77r5MjIdLwYh8i0dYQxtoe/uzm+RPBXX7w9onVFPxOC4DlqDKB6vTmytFIEfzCW4OIMO5hfaE/Coc17Fun6YCtCoPBGtC7zUs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTBacnJ6d0VxSWhYbUVrY29Wcng3enhiUnJTMW9uWVM4L2Vmc0VQM1JjZDhD?=
 =?utf-8?B?a2dRbHB5bUtNa2pnUm9uU3d6cHRweXdpNjZaOG9IbndYMTBQa2ZveS9kRWdF?=
 =?utf-8?B?YzhCZFBUZy9CcHh1dTF5aThEUzc1V1hLcW81Q2YxUVZoSnEzR1AvdFNWbjNV?=
 =?utf-8?B?WWhnME5XVE0wakVFam8yaVhHVWwyRWYzbWFxR0EyMDJVOGRYWHRwYUY1NFRJ?=
 =?utf-8?B?cDltTVJsMGN0cEtULzkvWEY3V29tTE50U3ZtMnN3TGJKOUYrc01nVlgvcjJu?=
 =?utf-8?B?S2l6OFVVaGZhVEFKTWlaMzdSMWk1K3lTSENIWGlSN2oxSkNXQWd2TVE0RWd0?=
 =?utf-8?B?Z1lLOWxNVVR0L2NuRHY3eGI2MFI3cTdEM2pXbU04TUs1cDNDMDRIQVlpR0pE?=
 =?utf-8?B?WTljcVRiYkZLa0t4aTBwM243TXRmYXZlREVEbnlvd2YvdmJyclJMSmxUWUlx?=
 =?utf-8?B?RkNrUk1nZlArZGtYaU1hajdNbG1taGZtWmdMaGJLWDFmUXM0ZFRxN1pmN2dP?=
 =?utf-8?B?TjBCdE9Va0pmcXFZaWtwS0IvMnJWRUd3MysvUDRpWkh5bHRuVks2Q05zOUgz?=
 =?utf-8?B?d1YrMnB5UnNPQ3d0SUNCeExrZWkwRzREK3Rnc0FJVTd0b01Oc0xoL0xKRTB3?=
 =?utf-8?B?azZxK0hVQXJYbmpYQ3J2ajVTYS9uRVZ3dm5RT3VrWkdBZzlxRWVHMGQwK1Jo?=
 =?utf-8?B?U2w4cjEyaXBXZUxHSEwxWVI1a000SzZCdG00b0Z2TFVzdVNvbytVUXV0RTdW?=
 =?utf-8?B?Q3lsQU5FUklPTzZrcmhmZEdaNTl1K3VTRWkrdDBWZHkzU2FUa2NwY2JDQlBL?=
 =?utf-8?B?WEIvN2JDbTFtQjlGQWxrYkVpbmZaUHVYZjVRYURSOE9zb2tNNFVzaDNjbXhs?=
 =?utf-8?B?UlpsREFCdDYvcEVmWmFqM2VFS08ram8wRnB1dHcwR0hmbmYzN2ZXVVVaU2Y5?=
 =?utf-8?B?QzJoM0QzcStHd25KQUhUeTVpUDBqWHYyWisvOCt1WGRJRmxJb1liL3hNOElt?=
 =?utf-8?B?ZXRWUGNTZ1hQeEhOL2FMVEtncmtCaVBGY3NNbmdlTmZpaFJBUUxjMENsWlNO?=
 =?utf-8?B?dFRybURDMlhMaXltVGJGK0lBZjVlb3lRQTdhM3F5d2NnbmtaU1B4Y3Nub3Bx?=
 =?utf-8?B?MVZNaDAyaCtWVyt4dzhUZU1ydHFNM1ZXczJ0dEZ6ZTh1eDNFUnBnZVd2MUYz?=
 =?utf-8?B?YzgrTWZ4N3lJVVRQcUpxZC9oN2tTanRINHBwZ002MEFoa2JrclQwRll6SkdH?=
 =?utf-8?B?TldRTGVzMXNZNGYzQjJhYzNvL1dVZzhNZVIyMVJHWVpsYXc4dVNVckVsU25x?=
 =?utf-8?B?QXQvSlZaY3pqUmQrUVFYVXBBN29KZS9naiszK1k0MEE4c080NGhRNnJqdlZE?=
 =?utf-8?B?UWZ5eXVpVEhJaDlUblZNOHdab0NRUi9sQ3d0Y2MwOGcvSGF1MVRqWmQxOGdm?=
 =?utf-8?B?WVJJTHFJc0hxcXoyQndDUTJobHkveTFmdnJhNmVGclV5Z1Z5WG1ZVEdmWnZh?=
 =?utf-8?B?Rm1BUGJIbjFrZUhFek1SS0N2cGNXWlFpOWxTbEwrNW9nUWFDYWU3SXpEcGQr?=
 =?utf-8?B?Q1gzdHUwVFB4ZTJsOVU3eXFrZlV4Y3p1UGJoZWR4c1pRZHU4Mld1bFdjYkZs?=
 =?utf-8?B?RDRQK0t2YjdJYTBEK0RaQVZzZ05qYmJsaFpaOXRGTjZJdVd1cGpxbFhrd0pV?=
 =?utf-8?B?c1JuVkxpRlFsMUMwK1lCQ3ZFcXBYeURCbDBDQ1JndVNCeXMwcDMxNjYrdTR0?=
 =?utf-8?B?ZmZqc256YzMwc2RWS2J4aE9yYW1kNlh1QllTQndia2FQQUt0UGhnTDFEbENh?=
 =?utf-8?B?cjFGejVxenRjT3VrVzAxMzNWSG1yMnZmQ0JKTGdoQkt6M21CTnRjNjBwTTdi?=
 =?utf-8?B?VkczV1FLVi8rTzFWdUgyc0tmNUMreXhtUSt4NXhZdS9yS1owUnFSQ0JXdExk?=
 =?utf-8?B?WDl0bEU0RE13ejVseFJseW5JNExHNEUxUlFUdlYzQ21LOGZONlFUcUorbWYw?=
 =?utf-8?B?MnIwaGhMZTlzei81THZRRFlWeW93bjZMNERnRzNrbFR5ZXhLc1B1dG9uRGc3?=
 =?utf-8?B?TW9nRGZNQmQwaHloMkl4dzhqWFRzWG10cXJmREIybm1wQlIzMXRtWnVqTHJP?=
 =?utf-8?B?Q2dHWGYxR0dQdExsY2ZYL0FKRE10OHRWbVFBL3BNOFBpZTJRQ3gvNEtJUlJY?=
 =?utf-8?B?eWIxQzVEblFzRWg4YndiNWZtaEZQU29UbldMS0VMM2xCTFVpVytTLzF6bzRw?=
 =?utf-8?B?K0xJdjByR0wwSGFrd0hvbHp0eGNCSUFqaFFIUGlFN2gvZlVub3F4bk9EeUxQ?=
 =?utf-8?B?bVRDRDVhT1JEa21qWkE0bzBwWjZhd0UvbThzLzZlUzdjb0RJZnNNUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c390e76-123c-4f4b-4e2f-08deeb863f83
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 02:24:55.8365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p18QFALZQR/tsnYip+kRx/v+c1ICCEV39Gcf8l3YUstSZUhoErtjPMpgPLdnvPiRI2WfRkZFRjgqI0Rha6eQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7286
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8725C14000A
X-Stat-Signature: 1h9h8x4uq4zfmf4671deimg4yf3tbj17
X-Rspam-User: 
X-HE-Tag: 1785119100-845028
X-HE-Meta: U2FsdGVkX1/q8mr4q/azRT53VHXdGizGodAIBYMgayoVEX/xZ4ZTWiC01c7TJ/1G3G7GoDhAWlvrdjCEKnPFC64jtlfCGxvZv8v0a7HGoBZJDGxI26w1nXn9hR16ighGwEu4vGQPFbxpuWVg477jelS4FYPgU/BLzKfi/qXcEUvie9d9O0wdCjkoEjTWIzkQ7CrbY9XefIzsl4UfGJQXC03yyLkX8JllmHMgnhfKZ/HxS2wZgcFUVQV7lDlPYYqCtkCqFvNCIlDuhjIPif6/K8QVyXy5ag8yAWrSQkgMaMfqT+vub74V1zUQ1xw66cie8vGfC0nLu0pf7829DU6Vie3iYukDe59ZFB8Vn3m16xy3D5ThKHncMSdHghNG4vUEviNFxGTnYc6vXZ8etyQfMwBwPf9RgYjX0+02Cj7B9TmX+Ew2Tp9+51ZnJOIC8vvOPNRTs9uys84gZo+aU613jVzQ09DCy3MkAyxoulybFvYmtxXpUC4r1AIosUExobJH06d4NhAxKIfI4ufcAKlfO1a4NhhPwQQdY95CwtXyvhJFMJHOMpnO/rxv3DEYcGRGXn39m9m60wbjGpoaoqV7goh28JyzHsj/QIRhnP9vzPE+TqG3rJg5VEoLG4kC3WKRtalHr/qlKOBFVU4wbPKA4X5rIW/YB3VVPp6Ly2qW8PaqnR3/Q4SYT/9uhx35PMFV7bVXk+d7p/zi2vhQRjuf5/XhHp++8Ce/NubR4o1fVAUJPOGnOqidnZ3dMFsUgtClX0ig3J/a2QaVA6MBPstYgNtryvD/4LxyHScLGdhQ7+Ay9+RNj/Tsw2pR+PGWjazq66pu1L94jq6aiP2PUgQOZh7cYSyoTIxnB3Nv5Tl0YgJzOzIHDqc6JvdRWrhBZgENg2WY8MQ5roc/DTxn0Zc2UK3iQkJyfdZvRPAteDc5ABuSFjxlHumCFGsNw2JF9Tg/2X9D7otzTV1uOiKKQiq
 aloYcxTP
 BYAcx1fz/lk7z4KWfP8PR6k96BOjXibynTF/JP3c1+KXIPrS5VIf8ehQJDzFlcODHzrqeyeIKZYk2qSSrNBTSTvaxgRv5y/628SdJhgSOiQpxHDOA51Y+2HiFCIP3wUcpd5ILLvwQpdd59+cMuA2SLpxOdXGWyGz3WgEMebU763eemqTAP95fyseh7dLpw8E877gm5uhVJO0Hdd8Yks1pZDdXv9n9Lk6RiFUwOf8WyH/jFCRBxfscs27vM4w1pnUPxFMzC/bJjkwywxRmMSka78sci/D/dXPehaTXUg9u/YvMLWXy3kzdcxOlOYf4rd8qaijzsqFo9x1d4O+FUkt3txInQVKyTXcDdohcITsdVaHsPbpxRPllao0ERQ21BkP65Qq7m0NieRTD6Wb+NKg9PEenrShAUWbO99DFcWtEhUpilBbt2AA7UKDgQG+1DBq7ALVX/8wlVgxyq5B0BX9R8tua8Xj5rATnLG3wIySHUpqUQIO525f9XRlFJzJgvCqDiE0WIHAKJFwxdIczLxt95bjKfMFHv3mse0v1Q0DLJ7HwwCGSBJDdEgerrEyRYYhxr4JdagBAceJR0YnFR6Etle9EHay0YBp3fJtFYSnjioiTUQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 11:46 AM, Zi Yan wrote:
> On Sun Jul 26, 2026 at 8:38 PM EDT, Balbir Singh wrote:
>> On 7/26/26 7:05 AM, Zi Yan wrote:
>>> On Sat Jul 25, 2026 at 3:36 PM EDT, David Hildenbrand (Arm) wrote:
>>>> On 7/25/26 06:43, Andrew Morton wrote:
>>>>> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com> wrote:
>>>>>
>>>>>> __migrate_device_pages() reads the folio mapping before calling
>>>>>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>>>>>> from the swap cache, but the saved mapping still points to swap_space.
>>>>>>
>>>>>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>>>>>> mapped-folio path after the swapcache reference has been dropped. This can
>>>>>> cause an invalid swap_space lock access followed by a folio reference
>>>>>> count BUG.
>>>>>>
>>>>>> Refresh the saved mapping after folio_free_swap() so the current folio
>>>>>> state is used during migration.
>>>>>>
>>>>>
>>>>> Thanks.  AI review might have found an issue with this.  And one
>>>>> possible pre-existing issue in the code which Alistair and Balbir
>>>>> worked on.
>>>>>
>>>>> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@intel.com
>>>>
>>>> Yeah, this might need another careful look.
>>>
>>> It seems that the pre-existing issue can be fixed by resetting nr to 1
>>> after split is successful. It should also complete this patch. Something
>>> like this:
>>>
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 18d097c388530..4a77b6c86ae4f 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -1193,6 +1193,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>>  							 MIGRATE_PFN_COMPOUND);
>>>  					goto next;
>>>  				}
>>> +				/*
>>> +				 * reset nr so that only first after-split folio
>>> +				 * is processed below
>>> +				 */
>>> +				nr = 1;
>>>  			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>>>  				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>>>  				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
>>>
>>>
>>
>> Hmm.. I don't this error condition possible, migrate_vma_split_unmapped_folio()
>> will VM_WARN_ON non anonymous folios, but the design contract is for anonymous
>> folios only. The enforcement comes from the callers of migrate_vma_pages() and
> 
> folio_test_anon() returns true for an anon folio in swapcache. So
> migrate_vma_split_unmapped_folio()'s VM_WARN_ON() does not prevent anon
> folios in swapcache.
> 

Agreed. Rhe warning is in folio_split_unmapped() it only works fornon-anon
folios. So it doesn't exclude the swapcache case.

And the !folio_test_anon(folio) || !folio_free_swap(folio) actually
handles a swapcache anon folio by dropping the swap, which is precisely
where the stale mapping originates. So you're right, my argument there
doesn't hold.

>> migrate_device_pages(). Also __folio_freeze_and_split_unmapped() checks if the
>> folio has a swapcache and mapping associated with it, prior to split. I think
>> this is a false positive
>>
> 
> NULL is passed as mapping to __folio_freeze_and_split_unmapped() by
> migrate_vma_split_unmapped_folio(), so the VM_WARN_ON_ONCE() there will
> not warn this.
> 

> None of the above arguments is valid.
> 

Agreed, mapping isn't passed all the way. The split still resolves the
swapcache correctly from the current folio rather than mapping - in
__folio_freeze_and_split_unmapped(), ci = swap_cluster_get_and_lock(folio)
guarded by folio_test_swapcache(folio), and each after-split folio is
fixed up via __swap_cache_replace_folio(ci, ...)

> One thing prevents large anon folios in swapcache from reaching to
> __migrate_device_pages() is migrate_vma_check_page(). When
> folio_mapping() is not NULL, extra pin count is only 1 +
> folio_has_private(), which happens to exclude large anon folios in
> swapcache.
> 


Yes, agreed - that's the reason why it's safe, and it kicks in during
migrate_vma_unmap() before any of the above. So the condition is not
reachable today for large folios; it's a false positive in that sense.

> Regardless, adding nr = 1 here still makes sense, since why should the
> code below process the old nr pages after split is successful? It might
> be an optimization for current large anon folio only case, but it is
> more like an issue in the future.
Agreed, and we could add it in as a correctness check. After a successful
split the inner loop still runs folio_migrate_mapping(mapping, ...) over
all nr after-split folios, but folio_free_swap() was only called on the
first one - so folios [i+1 .. i+nr) would be migrated as swapcache folios
against a single cached mapping.

Thanks for the correction!
Balbir



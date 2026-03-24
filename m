Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D21F532D5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CD56B0005; Tue, 24 Mar 2026 01:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7972F6B0088; Tue, 24 Mar 2026 01:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6379C6B008A; Tue, 24 Mar 2026 01:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E72A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:04:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2873BEE3D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:04:54 +0000 (UTC)
X-FDA: 84579766908.05.0F44981
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id D92D42000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:04:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=spFwmvRo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774328692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYC9rZfVzw1FJyxVOtyvGAXoz9Xg1vSL+sTNRKHlHtU=;
	b=8V7gi0Rfd6boOC8ufO28UzuqsG+Pi7DcUVXb51fXv50gThJPIxZYKagQE8FEGhxOvb0bxA
	YPepNrHzwzXyXic03gld3riGv/PDLIhoUGIrXTTYlJFCoLY66+3F0oAspYNH6yLjsJwEuh
	3u5taAuEgNEp7qbmhOLnf8w45N5gjIA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774328692; a=rsa-sha256;
	cv=pass;
	b=hUO6xjJjHAeUimccbP3ODqzh2M8XRVnYaHAats666RYjtlWlrrsW9lg9USBmeqC45pxyIs
	Qcviyy5H0Nbvrr8/SI3SO27XN/DFClUNxU3P0ro1WwiT1pjqBp2iAD+tyrI0AMnWyOK+qm
	GUXNXrNLxoy7Zcfrq2fYmkgFDmyhHRo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=spFwmvRo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9JNbrcmXw7mdXvJe7p3U6Z70zoFDI0YIeFs2Aw/LVLpHe18MRMlAnhRESUqhORzjHHK2oHx5REvub+vv3/7cBGFqAQmlJ47ev24MpNsEGkgtHJUWHHhciEEpa1sFRSNBdDHjqX8nr7w8P/8Y3xOaxaFXjAo75kcixsXbzRtvpnmQUk+X4kyYfpXB6YxuJMygi8Z5F5cRsjfo0IUnAXrUYC/og4jx3bUf16RfG7rOs0o2adbPjoscGWdkJ7zUzVg+s06bDD841nHQNXazdVqjVrzXdaQ9/m3RkQv8TLTgp1zc8eULjMyrmXQvyrfJcymx9z27faczLizWXKyQ25zqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYC9rZfVzw1FJyxVOtyvGAXoz9Xg1vSL+sTNRKHlHtU=;
 b=TufXI7T6LcS3dwVfJV1xuz2m6r3WFQC5T5Kus+IcbAJ6HWw1e8Lx4B6ZTvRv8IJ23PoMUhOuvxBmoWrbjCSfGDefRcAPj9yqJxwtkN0Eu0FdNgG+Qi8HpS13PU/gAX0QmEOfLs+bSIZMFwq1tUKjmylN07lFpewXYDZ8KqLvsW2O5ztAS4ftzPJHAUhrbz95yVmUTPcvAABFp8627gZQ6W5cSwwUrDMJpzPlO4nGY8BLMMyh8WzIGmSgeBiCaWAdB6SpJDrAcDjJXPVqvlvp3n7Nwfph4Ah8ucHwqzARPhMpsZFqL48IB3o2EJlCw4LU7Q1nLNWweJzCRZjC1i0HgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYC9rZfVzw1FJyxVOtyvGAXoz9Xg1vSL+sTNRKHlHtU=;
 b=spFwmvRoBZUjPZxv+mb+Z6IsFAALbvH4ooPpCeBCHqcv0ZxekJ/3Z4Ayr6zhKg5Tw6kRTntzxmRqP+W92OjhmFvwLqHfqIge5BnZXEaMcs/Kv0A44pfhNeUPw872nxXeA4schwdYEuEo2bLhICuBljOwe6BbHoZsbrUWuKJTR24=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB7804.namprd12.prod.outlook.com (2603:10b6:8:142::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 05:04:48 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 05:04:48 +0000
Message-ID: <a55bbf90-2373-4b17-a1b0-928823e3de20@amd.com>
Date: Tue, 24 Mar 2026 10:34:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260323141935.389232-3-shivankg@amd.com>
 <acFSTlF0epHIrA5v@casper.infradead.org>
 <a6f19c86-4c6a-48c8-9dc6-26f66bb6dd88@kernel.org>
 <acGNG1T-4UBdvgYB@casper.infradead.org>
 <7095112e-465d-49bf-9cbd-98e6e6ad2aa0@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <7095112e-465d-49bf-9cbd-98e6e6ad2aa0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0130.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b1::10) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DS0PR12MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3ced9c-9f76-4531-7a29-08de8962df77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	SY7eSTS0sY5r20pPF7vFXLz9V0Jir2wFM6lkhKvtEtZNiYMu4c9zNb/0ou6+kuPnVkMfftc28TgpKGro0uHnyqHthmemJt/9qqs0CIV3Jazy1X1BtEzIzysWi4VCl1ElYtM1T4nDl7UgSybfpOLkdHEKO9Po0ZcRqMwvaizmqUbdoDHX1vfnzUCY34CCy713WhsSJXsxqdZClkIHkB7UnEqvnuxtJLLIWqdtfbtCNakQSwTOhM4I9SXno8zx2vFkyIPlaNUYtqqE0BWieRLmT84SZ79IbN41gWVRooXjkxAqRq7HsenMeO8XT1WLajTDt8cCNnOeHHKQZTyqUQGqyFaCWNvGdGcWPa5y7UAlgoQEY+56zN0VIOGS/dS8ro757T7WIWVR5tcASjaqFP2new4Aq8ifH2QnIvlU6HCoWUbz6GDK5aY0XR1Zf7YpF5VdMvjVSYEw29iY+Fd0Eto64We2THYQ3btErXkYP8H+JG9ZGyAJvqT4XHHvs0ObYBCHb6Cg2I5lu2fdHtCFz9V5xo5a6dSTTqgqv08ivS6Qo5+NI254NklEzC0rj7Fa7xBehkgQK7Ag8rsES2EUiMRzV+YL2Qvec5BtQIg1HVCx7cmfdTciHud95/0G74fs63Pm0Nc8PP9I4GLZ669i5ZquTOW8HSM1IOgM/YqKqf8U88zkTsLHI1WtTbXa6hEL3JyIphFFxF2O+1JWMn39m08VggSElZCaLilVmtZf6Tyu3nc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkR2Skd3eU9USytyRTFHa0VxSW9jeFZyK1F4UXlJSTN1WmRUQlh1bUZRV2Ix?=
 =?utf-8?B?UXZmSXZkMllKbFlQVzIxN1dYQ01rSW5uSGNIMmFJckJrY3prVlo1SGpXQUNX?=
 =?utf-8?B?QUVYTlUwZUtMVzBscFhvc2MvS3RZdzE2TVk4TUx4NHVXZEx1OTlYYURlS0s3?=
 =?utf-8?B?UkJPMVhwRlZCZkhxNzdQWVM0U2hndXRmNXJkUm5BRUoxeFE4VWFEV1p5KzZw?=
 =?utf-8?B?SFBodDVCZTJwV2tVLzkxTDlZRU5yMjZodGtMd3NLVHg3Z3U4bWNuSXd4LzNT?=
 =?utf-8?B?ais4NjJzWUsvN1Bwc3Jxb0p3WEx2Rmg4UzRZaTZ6a3d2Z1F5WVZGY3BVS3BZ?=
 =?utf-8?B?UEIzNSt4eWljRUJreTcwOW1hMXRjMSsrUDRoZkVPN0RHdnRWT2pCWmo1Qmoy?=
 =?utf-8?B?ZDZSaUtRU3I3ZGhPRXNLVEQ4YXFCZ0czTWVsOTN1cC9ETFJhUFROT1VWNzBY?=
 =?utf-8?B?REpTamx2SlhNdDNCa2tma2R2aUtRWVVKczkwcXpjakQwSmFpV0EwaHhuMldX?=
 =?utf-8?B?MHlKdjYzWUhiTkw3aDZvNHJkUmJXWHprWjdGY29obVMzd3J6NEhORk8rbXFU?=
 =?utf-8?B?QTVwWmVyclBBVWFQcEZQRjI2bXpOTU01MXIzUTBsTG91MjZicmdLcVMvV0Ft?=
 =?utf-8?B?TUMwWGUvYlVPb256ZWVJUFJ0TXhQUzZrKzMwU2JIQlVRczJEaStiVDBBM25N?=
 =?utf-8?B?Y0hyMFN4VWplU2tGMllTVEp3QSs2MkpzU1hncGFwR1dlY1MrWHN1SE1YNGpS?=
 =?utf-8?B?Y3JUQ0lZdXhSbTVqMk5OQS80WS9QTUhJcEdRaUR1cWNsaytmaW1xdE1FdEFa?=
 =?utf-8?B?SllDa1FGRmxTR3h4V0NqV3hncWlNU2xWRGZKS3VBN3EwQkFyaUhrRG90UVVw?=
 =?utf-8?B?ZW1VOVZKNUdtTWhhd1pHdS91dlU2MnM5VnhuZG9aWEx2VWNmMG5yUC8vdGEy?=
 =?utf-8?B?cEFycWlqSFpOZVgzc0tPUHd4dzJmcXRCZnBKQVhUMXNzbjl2bXhaRkZvZmgr?=
 =?utf-8?B?bXlQVFdvSmlvTmpzZjgxRFVMZ0doWkd2bVk1R0hndEF2ajAzK2cwaUpUaVFX?=
 =?utf-8?B?VWxYamlraDRROGYyWlM5aFVKMnphaWRNN2lmTEpkN3ozd1RKNzJubTdlZnpa?=
 =?utf-8?B?TFFFWTNRSVYwOElXeWdUUHcxUlFORmhlRm5DeVVTbFVibUhWL3JUWXJJaXgr?=
 =?utf-8?B?OE9GQ1daUzdETStYL3k2aXllRmVBUFFZbXVNMnVrTjlvWnlhSjYzbUxUNmpH?=
 =?utf-8?B?TTNOTEtmWlpIRzZUL0Z0RzRkSTRURmRuVGhodzhqV3pPSnNWTkJTYWJsUmlu?=
 =?utf-8?B?ZkF0cC9VczNRY0N6UmN3L1N3UHNSU2xvM3RJUlNjYzh6a3ZGVjVHalNtaDRz?=
 =?utf-8?B?RFdrT3l0WlFFZXN4RS9Mbzd5N1I3cjgzblRvM3ZySVl1NmZab0pkc2lQQWhr?=
 =?utf-8?B?S0t1dFdXdzFUOHZ1Y096U25TVVpVbGVTKzM5YjI0UWFPSXZrcUdWN01VRGw0?=
 =?utf-8?B?Wkl6eTJLSmh0UWRSU09KWkpZMDlMWXpTQkdPMkVsQWZ3aHI4NWFOMFBlVWJt?=
 =?utf-8?B?b0Ezb3hJdWhVRFJuNlk3eFlQWnJFSEI0Rmw2OVBtc0pTanpkSFV4emluM3Zz?=
 =?utf-8?B?dEhUc3h2MTNtY0h2bGVBYlA2a05kSTdtSXRhcDFldkNZcUs1K05lVGN6VDZO?=
 =?utf-8?B?MWxkR3M3S0FWb2U1akZDNTlyT0NPaHBrKzlLcTRmVFJKMVRzNkRHUi8vYTdq?=
 =?utf-8?B?T3FnRUs1Mml2QnhtUk5raldzd2pWUUZ0N0d6TFFubFpYaHdWYyt6M3pxMy81?=
 =?utf-8?B?N0w1QWtGNlR0Y0tBcnhhZllPaVNLR0x3VFQ4VFFyWTQ2UGFDME4wTlR2T2Iw?=
 =?utf-8?B?bkVmRU9aS2hGNW9GZ2o0a0I0VE82cDRZVVdrem51U3RFNzFxaXJRYURlL20v?=
 =?utf-8?B?WTk2RGpZY3djNFZNMXBiN283TElEUEIzbWUzamdGSUVQYWRMcFV5MHQ1NVhW?=
 =?utf-8?B?aGVFS0Y1UTRLdjZTdTQvbDgzQWt0UmpvL3RuTG5nYmY0am5mQTBXQUJHNlo4?=
 =?utf-8?B?REFFMW5NNUh4VkJVYldITkE1Z29hTkFIRDJRcmNmc0FRZkt5dWx4QjlhZmpB?=
 =?utf-8?B?Tk9FeERoQngwUFZHQ09lWHFKZW5QbmpOQ0hzM05ieE9NZ2RCbnRON3Mxa1dz?=
 =?utf-8?B?c25VMnJ6bHNsaGpzNHNtWGFlYWZyd1hvNnViemErRFFhTXhYb1hUYS9yb1Zs?=
 =?utf-8?B?STRSTUY1RXM3NlpnVXNlMTJ4THZjSHFkVXU2RmNReTZaQjhaZlBSSlRXU1Fo?=
 =?utf-8?B?UGllVVIrL3BuZGdERStGbzBVdExSR0s0a3lMWUhtU0pZeG4xQlRWZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3ced9c-9f76-4531-7a29-08de8962df77
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 05:04:48.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkWPdF49TyoEb9W6teBEugFdhpZp3sSgxoQVlvyeFDiEHMTHRg6XdVPVNKkR8T8JCH21F6VvSJW+t8VTYVHH+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7804
X-Rspamd-Server: rspam12
X-Stat-Signature: hcmu34p86kgnaqrjst75ptotrofx1h67
X-Rspamd-Queue-Id: D92D42000C
X-Rspam-User: 
X-HE-Tag: 1774328691-391148
X-HE-Meta: U2FsdGVkX183Z2zf+aBykAGRbia8IYG45tmrFpU7LArwSOLCmfGkpq/7uozzy47rj/Dr3YAaWE9ABpfXIT/XEpltW/pRl2jV3dzVqIFOsEPhr/OsVr2fzyusLLG23rdYZgOerj59VIx+zCgmei9kZ+ovfgTBEdzeBUeI14l1DiZw1adcgqWd9Rk3Oc6SfJD/iY6bl7uwG7QqpZTPNYZZEXYXwNL6fpimyOHUygLmic/MlWDvlwRL1x9iZuzzF/39usU0LxSMeZDvTXG6/J6PWj86SZCkGk6FukcwYu9pqL+hpcRP+bKLbY/jq1uNQe9ooK9nKGWbyzIEAhRKv4yBtDAEE7nVMBNdKjiBv9W2LI6deQ2NsSBQNFoXHz0PL6w5MfbsUSpRCiF1+u+yaFS5jix2QvRUIcAeCHslIphBUfSiqwaVfGKQBg+hAk8oJdxYHK9qlwhVEdQO4fHBlGSapXOVb2wLv4N/rNRLM2tFT5ZPQzRTNj2S2DHoP+XgPe7DA+QJtXcjVRuZ2k2pb+2up0Gu9Dp7PiTxD42x5FWla61RskpQbRiAe4yR5NGLqXzCgwV5OzkGjy4g7eO5mlayA4+Wp9lAC7ol8jElByvaNcmJtEIW0eWaW4ca2T8TdUuhtk8ux2o0jFPuOwPosuQOVzeMSNJYWRB2PA2Pfw5aoMsENdj+qzlZ+YQVZvHKKdcRNtnlGae1HyQjqCFJmKP/1UujI7GR6+E97P7F+o1fxF4X1eg92tbqoIVXK7mDUUkxf6EotlLLCFE3ypM/NL3XpGhD517sX1tl6KxI1FUcz7nPtxlSrI7jyMVJwSxePoT1JUvVZ5RLP32Re8Yo7c1+dAalksFN+8lDMte6SmuDW9lYmKWEGF+egjVz9BQx2MnZJowA3O28rA1TfQ3Epxezrbe8sWcXN+mkKzSMaxIendSrS9KndsSHbwV9imFwhTf0Bs33eta+CpOxh9QRQDL
 YLYLrfmk
 5kPLymnM2IlIin7DJrkJtSsiDRIsty3hTQqqnQ2i79ZLdXwqEr5gaClgDq0CgQK0dzVI0dia8npjgMLZ6vvscb1t79FQDw8u6OrlecOjTmDjkq7m0ntOFWHRPCjx0RUWs7ecIzSSLfDrPQjI/InsQxrn2TwiiUiL0t7wspYIJCfD/hRqUUxrJ6W/kqSXLpRXh2dpyXd2OLQ+ycQ4PXhJoq4fBCjH0hc9uR8h9c+8k5MIZwchsPjM6gRnupV1/uc/qlYbM1rpo/DapXeYal8GpnnR22ND9w4ZcO2h1yTKAAczkQ4Uc5tC379Ml6cJv7yLqsLnr0icr9GmE3DVVv+7mPm4mIRTKpFKVaJ4nr57ZtOapESOzh2/Dm+6k2Ob2pEcRb1fXmfALtisl88hsrCCaFrXWDkKD4kO4pb1mDScnCVy8tBhOrv5h0e9kQ0Vu1z3R49wyqo7aeBK3yoRaGB1NN7IQu1DxltkRSNJv2Yd0PMX/cMuA4mbTsKx6mLRwySy2thasDeiaVhgnAQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 12:51 AM, David Hildenbrand (Arm) wrote:
> On 3/23/26 19:57, Matthew Wilcox wrote:
>> On Mon, Mar 23, 2026 at 04:36:38PM +0100, David Hildenbrand (Arm) wrote:
>>> On 3/23/26 15:46, Matthew Wilcox wrote:
>>>>
>>>> I mean, this doesn't make sense any more.  PAGE_WAS_MLOCKED is a
>>>> sentence that means something.  FOLIO_MF_WAS_MLOCKED doesn't ... unless
>>>> you imagine Samuel L Jackson saying it ...
>>>
>>> :)
>>>
>>> PAGE_WAS_MLOCKED was suboptimal given that the names overlap with things
>>> like PAGE_SHARED or even PAGE_IS_PRESENT.
>>
>> PAGE_SHARED (and friends) are misnamed because really they're PTE flags,
>> not page flags.  Then PAGE_IS_* form a namespace for pagemap, which I
>> think is fine.  These are PAGE_WAS, so a distinct namespace already.
>>
>>> So using some prefix to indicate that these flag belong logically
>>> together makes sense. Even if it's not a beautiful sentence.
>>
>> FOLIO_WAS_ seems like a fine namespace.  Especially since it's local to
>> this file.
> 
> Right, given that it's local to the file that's ok.
> 

Thanks, I will send V2 with FOLIO_WAS_*.

Best regards,
Shivank


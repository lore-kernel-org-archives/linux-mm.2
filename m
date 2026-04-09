Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B29410FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E488A6B008A; Wed,  8 Apr 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20846B008C; Wed,  8 Apr 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EE06B0092; Wed,  8 Apr 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1D0D6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:09:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D26BB824C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:09:43 +0000 (UTC)
X-FDA: 84637386246.25.6E955F9
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011055.outbound.protection.outlook.com [52.101.52.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8962340009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bfha08vh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.55 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775700580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BILZC7mIieHwFAIL9RQn+iHYSQr5uVUk/llOmB4mWX4=;
	b=1Yh3WKbn0BBDR8VrB5WjPxXvAMEp7ChAGmEJ1cweE7ldj4fKz0EgwXGj7iS4LzupES4kib
	9xtDyZqHkOnVtFlnmELxfc5Etm9tG6ONP3FQAVybgLBveD7/5adahLF0tIGwudUBoHBzE1
	xgCkFLc9UnHArSMjVFDZGXjxhSVr5N0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775700580; a=rsa-sha256;
	cv=pass;
	b=kxlPl8PIyA5w8fEzemfuROys7bz8FgmcLqzzA2ZX1938UHueqYshrywqUG8P55XdqReg0C
	zKmkpdGJalAcN3LHswW9QcSg07lb1R8yNOfunQQODTLXQOX6lLJ/fbgXAIRmw1DJuVflS1
	rBBEJ+uJiu/ngNaMN9Fx5vPHHMJgHGs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bfha08vh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.55 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaerpzF5jOwRQrd4KPSSPt7WHBRLxl7oUDeJVgk2H/do63jivWaVOrJ3VbwrW4dUSk7u6M9yqn0yzSP+qrpGyllnEvVLsR5GDTkRyZ+QwIFF9XlOh6fHSkyqY9Enw9Vpg66pqdgPU5/FsnTdyL7GJORDBGh3sD4skC1yRQAtbWkZJfai+uns12EUTuPamc07DL8ItQdYOexdoFjgA9rzKTRJkm/4lOaiIiJy5V7ei/beTpFRo3LfQCxw6yzYKUhZYNDME08uJVXscZ0/BK3GxuFfXXeopQ3D7YiMG9NF6/WLRARlV7lj0+LtY/sND7vmYxO9o/gdkOi54AHpY6tZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BILZC7mIieHwFAIL9RQn+iHYSQr5uVUk/llOmB4mWX4=;
 b=JFwBks+anEdmvsg+E8aiYGKXXuUplp/zq4yAKCbTDwMCBxhZ0qEVsiyMG0UwZCHe8oFNNiV+7wHU5bEePns43VRLttIJfqAwuITXUlp9zRw3t4sJA85L3Wq87xrPwHhb08TWPrXm2+ehV1jVLPCAv3HslBpdVnb8U7p/eT+maXAR8G/vbiHu0tjajzC/vbIwnAEVnwk8y5hdC4NyU9p2vsXxB/XSOvvTEw1OS/Ggs64tGDcIcsb+6XNcdRoppEkY+vk0/gW1oVHUbCLp+xcSxr95lVLgt5XYUoPLxYeIqfl/x2PrijNi/ZAn0Fj8psP0nNE6YnsdOaSXJmInfpZkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BILZC7mIieHwFAIL9RQn+iHYSQr5uVUk/llOmB4mWX4=;
 b=Bfha08vhHyA2s9gC7TL96CyVFg6nank/RMmJ0ZmGgpkQCbzonHSjr4EYK7j+Jzn497JZoL9Jd51doDNN3xhtIzX4Qy3UBIho8XRj8qyLrjxPqQTUYdxKBuu05n/MFOXDDrtESgoqTYNl1d6Z0u06qIVAX+8Nf4eEjw18v2NUwD0D9XUC6Ohic25/6lqLrpkJtyocSI5O/2qSPnzuquzmrJpcqNj9huK/0Bb15Y9gPU8/lQCeM4g2pZxqBlzU9JXJ/3IgWPmgrRy/IFuDn/syUAnlAQgO538BpQ0WSLYjENCtvM6C9uN7NMjKEG/Kr6JMo03UZq23B3hvRJIe9etmjA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 02:09:36 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Thu, 9 Apr 2026
 02:09:36 +0000
Message-ID: <d957b695-3caa-44ce-9853-f0f221fa0e88@nvidia.com>
Date: Wed, 8 Apr 2026 19:09:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <20260408190745.40f0c0231a475e697c970fd4@linux-foundation.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260408190745.40f0c0231a475e697c970fd4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: 7359dc66-d150-4d46-1272-08de95dd0c2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l0LJkRc72u/+xOiJgRh1ZX6utaovH74dH9W9Zin9t+WZAJiEFes5GqVXRJkD1OQIbD8VfYO46SqK4ScIQhsP4QOCSJ9TYTkfIAtj8/x5A8l/FgemVRb6l9mGezgn2cqc7hlqcKEmCQzZH2cxrA7H2+bL7gfgXtM2bWs+8bSSHDMBXQfEpXc3wJHdQ+9Q/QCMNhFQU9yKjd4R9br+uZBIcVNuR2KT5Kb40O0ZMisj07YL80ahS/gsFvp5D6TdCc1c5CcTxM7kg0fpawFVTB6RsEX2BLV559868uktFyl3kfE1TkacfP8gqttxeVdxM0/SNP4Aa1B4/d9sEWWVVgtrXzyYj0VBa4v+wejkSyWFAIRkonoF2V6FGIr5HYSneMt5Y7z9+n5tmDjPJSw5pj4iDWt4r/h2pobUgHJEwA3gkO4ni6T+G03JbDSojc96HaXZxx0Xp3XKyO4JQ5Ml5wCHJhJRPDNYK+YXWnGkoq7lPGdLIUR6WvNINWG1urO0T6S83TWgAVMOzPABFs/vJg36zM26PUbf/WzrIPYMKzLWtSWOHjgNp6UFSbl/z8tVBHxaNvRY6nkbRrcCSzTAz590hNfJC/6CrVnHVvisM500ddh+mXwhos1keFHj7DvmYNCdcP17ooe8CArVKvqcF8jYEC3tqAb5RB0w10gwqcwLu/vguHkkL7CvEYoiQ1vVdjbfcQJgiUh8e3UZRyN1n3xc2DbW3Rxd6C3PlUyc0wmPQVQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXVvVVBHWmp2TThDN1RrZ0lSQldRa1J3RUlCWC8zMWxmZFlXQkpjd2pQdG5h?=
 =?utf-8?B?bXhOUm9ZVXRXZitvRUprRG1oUVhsOHRuSDdLUGJYM3p5d1pFU1VLd29SQUFw?=
 =?utf-8?B?b0d4eUdSYS9oQWhHOHgyQW5rTVBZWGpaMmxQRW5NM3c2elRBTzRyYjNYMjVm?=
 =?utf-8?B?eStiNmdqYkpkZUJCTTU1WWlVRnNWSGw5Yy8yV1duQ0tRY0kwbTVyOUZoNkl5?=
 =?utf-8?B?cEV5NHY3V1FMNVFFQkVITWtvb1BFZCs5SjVoTi9ERHl4SENTdzUvRmRlbExv?=
 =?utf-8?B?UFpRZmtQblJSanNDaDdabEs5OUZtWS9COU9ma0pIMzRnaFRvN2NHREdVVjVr?=
 =?utf-8?B?bHpQSEdQOWwyUGV5SHNDcWY3QWRaWGZZTk5Fa1QwU284ak53REkxQVEwemwr?=
 =?utf-8?B?Rkd2TjNTNGxwVDNTWmUzdFNycytISWZnWUQ2TmhnZjFaTER1bm05T3loelVz?=
 =?utf-8?B?UGw5ZFhYTGZxS0d1SXlkR0taM1NRNlAxWTBwYTB5L21ZbGlTWlNvWWNpd0Zh?=
 =?utf-8?B?T2xJMFFXQ3hQc1hlSFpoRGIybDZlQTEzdSt3VGRFam9DaENOUGtBdW11ZjQv?=
 =?utf-8?B?V1JsV3hEZjl3NGVrTjdEYVFwTSs4Q2hNMGh1QkFTMmNEUUh2SS9RS2VqalZS?=
 =?utf-8?B?QjFrWTdCUXcxM3R3L3RTdkRnaXYzK3ZLMk1adlFzbWJUS1VHNDEzUGMwUmJk?=
 =?utf-8?B?Tkk4R2RrcEpXYzlOdmM2cWVBZWhEUXBUOGZNL3FqQk1WNE1meE9XZGs2MXRO?=
 =?utf-8?B?WSt0TWVKVzJnbTBMZlpFSGNKSzZEZlNDY3FPb05YbmFhUFJ3TTBCRjNOMnc5?=
 =?utf-8?B?aDhvZ3c2azllVHB4UkJCRnhVQnNCbWpkeXVUckhaUE5SMkQzdDBtcDNiME91?=
 =?utf-8?B?V3dRN2N2dTNYeUNNTFFXMXhrR0lwcThWYnVGS2FSWnloVDB1bmNBQmVxdDhT?=
 =?utf-8?B?d25QZmVrUFRsdnFYTWRjVDJhbWFiRnlFZkFFemNRTTBzSXJsZUo4K0N2L1B2?=
 =?utf-8?B?d3lkZ3BUdXFtTTlMSkxidDkvOTNKK3FtaVRSSFljNm5ZTkhib3NMVlJKdWxw?=
 =?utf-8?B?K21CUkpkN0RFbHYrakswYXlQNXJqdXRQZFlYck5YbUpDRU9CVlRvUE1DU2Rm?=
 =?utf-8?B?SldwTlE2N3IxSy9zWmhQVVlMVnVQTk9oMVJPcitxVnplWnh1ak1nT29EcXZE?=
 =?utf-8?B?bWw0MkRRTXlhWDZGVDJYQm9tbzhUdXNyY3JkTDd5bXJFc2ZyT2w4eHp4dXlN?=
 =?utf-8?B?eEZkazh5Y0V3cHB5MHlHTXc0U3dPU0hQYUFLQ0h6bE54ZWx3dVN5dnFLMWlP?=
 =?utf-8?B?SzRoSkxXRWpPSEtHOHlscUt3VlpNUXl0M3FNZ3FENzY4dGc4T2pIS3VUWEVJ?=
 =?utf-8?B?c1lLQWNHeGg3dVNRWEQ2c2hjdVN0a1NsSFhTNjdoM3JDTFA4NmhVYW4yaXIv?=
 =?utf-8?B?K3VmNUNYL1pRaU00Z3oxUlQ3ZnYxOG5EYncyQm9zZ2hXSG1UaE04WEZZWGFT?=
 =?utf-8?B?OG1oUjFnekdEYmpNQWRWZXVQMFV1SzdKRkdtKzY3RVgvRUc5SFRQci9UVUQr?=
 =?utf-8?B?MXZGck1qdXpuSWdNdm8wL0VtR0VtNkYyd0U3b055MjhkZ3Q5cnBYSDM1VGtr?=
 =?utf-8?B?ekdIM3RLejd3eXpwdzZLQ3ZuMlkvSVpNQ1BCQlVDZFZLRkZqRkJwMGtqOFo3?=
 =?utf-8?B?cEFkTGdvclVRSmxjZnN2djJWQlREMWpXOFBYYytFNWNKMDJjeFZ1KzVQZDhq?=
 =?utf-8?B?K2ZCTmJtNStZbmM4dXFOZkdQdEM3VXZCek5rbW5adTl6Y3BldEtlMWh6WVQ3?=
 =?utf-8?B?NFJOYnp2VEFGUEtybm9iVFlGZmlTekdNc0h5dS9uUjFlcEZmUEhMdzczQ25s?=
 =?utf-8?B?eDVZbnErK0dDdlQ2bGRxaGZ2TDhRcDhhalNWazZaVWtlbEhtWmJnR3AvclN6?=
 =?utf-8?B?Q2F6ejhiRUdkTC9iOTMzeXl6RTNKYUJYSE5XUlJwZ3RHWDdBTXlnV0FJVklB?=
 =?utf-8?B?YmFIbUhEWEtaWWZ6NmllcHBIOUI3cXdDQkR1Q0RiTE5wU1FkdWEvdmNlem9E?=
 =?utf-8?B?YmtocFFRZk9aYkV4V2l4TngxbTJFSVVJTGRCRHVtb1NKMVVHL0V6UVlQOHgy?=
 =?utf-8?B?S2M1Wmp3SFNqeVRMN0JNNGZpbDFDSno2RTRldytpK2V2d3hMaTdZNmlDNkpv?=
 =?utf-8?B?ZWE5b0x5U1ZtUUxEUEg5SHJ2bmg1UHNVRDZJd0l1d3VnRVg0R2tQdmNvbUVY?=
 =?utf-8?B?WjVCakVheVNQcFNnRXY0eU45SGwveVIyRGd4YTFkMitFcHJ5ZEJqMkFaclJx?=
 =?utf-8?B?dzdvTFpOTnF6Qm9lVGt2dFo3a3ZzZzJHcmo4V0tVM28yc1VBKzgyUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7359dc66-d150-4d46-1272-08de95dd0c2d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 02:09:35.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbbP435HDQIIZW/1gSJjX9Nhcz36mjq6ZZr/5CFrnW5fN5gnEu3X2XTBtEzs234f0+kMY71NTDItwXiGsQMZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847
X-Rspamd-Server: rspam12
X-Stat-Signature: ttfq5pnd6ekp7qki4grkmy71ycs8pm6n
X-Rspamd-Queue-Id: 8962340009
X-Rspam-User: 
X-HE-Tag: 1775700580-400064
X-HE-Meta: U2FsdGVkX1/5NF8NlC9N/Uu/mn80wKWSgeTb8b/iqYjpv9PXwskVe9gEY26rbBSGQuJK8PqjVRCR075HHVj5HQ98vnxrOapC6nqlxU8YHB2B7JJLNe0vA5bUO2NIeiciv4LvvCt3nGu/2/ZpQSiBKW12mS+pEm18AlBvgGwyyezt6nq4NZR79ASLiubiMj/aNJZsoFdhphL4oWMQjsVaCzab8XVUamFleht0rwQrrh9vXZI7yfeoCGinM8Pbfm3FD80I+gLZZIDiYmtXqvEzMXHG8FClT60bB1amPM4iomSCDn+dqXPeE0QDiWQMV1y9gQLdYv0MkYl9Ii3F/UMP3evQQ7vv+AWjuzaM8ciobl4SgzCgHoK6LGuBx+99zPl87IJ37xEGItaFYh/3r/idoF2dAxthm26ms2D+05GsgsRepNP/LpRUrvxwnIuJX3UP2fw9V+6YgqD7z465bmYU1NpBSKdB9I3yEXhXFP6RmGluaUcNYrUOyUr51GBY0oU92lWk+wr4uE8GT00De5FwA0XuY70D0UvtjHDk20LlWKVm/T7OKRD6bH01blnw+EldKooVKhtBP20ZAgKJ+aJ94VMzd/hzCN+U1VzQypi6sHDye909iSsAQdO0GIYUpC/edOAVZF24a21vXqpimri4SNSIe9fc4wbtJsp1J82nPqCaYT5BoiGI8XtP+VBHCjoQa7U9pYrsbuczJDfEscvpZOmFqiSr1g3SwRsVj53AYD3/RuJbTTSB/zSa2Uz1xrEMbkhT9LZrocTGSueqU7shSIggkTUdOV+wQnNPYlkFEYQl2xbUxMrAfYXBbpezDx/6ocMJzv+5cVmbShBiDnsdqNe5JqXvXEA+jB3P0QblmLswJ3jWOUqLZr7Vp5Gt5hKeViPGfnPtag+zZIE8PdVgwj+dJjeKE6kiiTjYyFiNcM/omLIOPs9MRn3uWF2NmineDm4O6t6vzy5WMEkuWvk
 2l92nNyv
 U1S603tsIpRK1gLs0FXk+k3PKt7t0JCNqwKpC1g//mDvYtYAfGNYbfp38lOPzTrHEQS0o8D0uOc3A8TyngQudD7v1Lx5m1HUaqdz+d+9ymvUumwaeSOKtGakMb6FOLXVMGo18t6dOLbShWkOqM8VUM8HLuDFfTD1U0wlpxhFew4EJOfLe+PmfY8hkEHvN+lD8ugzBtRP4xlbqE39FdvLUp5phQ3aoPr6R0iJiPOoc01R/Ct+/os1SwRND81RZgi+bP8fsHR2mE1SzR0QWowKYIxhRwOxLXF0K76mRfIvp0umKCkuh9JQoDjQ7UWkAKYVSsfjT1KCQn5Gl82qZ7lrDEO59l2sftvjrOfI06JCi1x1JgcoLJg9s9EYitrMUB/wwqZaSu9E6UCsSxEoS2Q6PQ/ZyG2huWkrGVwT0lo7mFYVBOlNJAHvU4LrfVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 7:07 PM, Andrew Morton wrote:
> On Wed,  8 Apr 2026 18:46:47 -0700 John Hubbard <jhubbard@nvidia.com> wrote:
> 
>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>> gup_fast_folio_allowed() falls back to the slow path for any order-0
>> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
>> performance regression for drivers that allocate pages with alloc_page()
>> and insert them into VMAs via vm_insert_page(). These pages legitimately
>> have a NULL folio->mapping, but they cannot be secretmem pages.
> 
> How significant is the slowdown?

About 2x!

Sourab has a bunch of peer to peer IO cases that use 4K pages,
that he ran.


thanks,
-- 
John Hubbard



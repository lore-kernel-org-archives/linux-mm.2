Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE885606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TNHjkcWd
Received: by kanga.kvack.org (Postfix)
	id DA43F6B05C6; Mon, 23 Nov 2026 21:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55DB6B05C7; Mon, 23 Nov 2026 21:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D2F6B05C8; Mon, 23 Nov 2026 21:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87B3A6B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:44:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FD3C1406DD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:44:37 +0000 (UTC)
X-FDA: 85468469394.13.9D3D113
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	by imf28.hostedemail.com (Postfix) with ESMTP id C497DC000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:44:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=TNHjkcWd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.6 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795488275;
	b=gCGw3Q4VD7glz2nBlzPQZZMI8yaV6yuhL+r++CNDaEYFI5C9JQbUs+Bo9VveN24uWyxkBW
	TLlhUUFdPhaJ2Q/aRoPnPN095lM/tMKHji0YgLhn+T5B58BTs0TUe/sqwzIK8xPxJ4LUSF
	fhiPeRTcbhz5hcB5bawGJG/0yZR5ce0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795488275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BcQaUnyGDzAw1/W2pkYmjbftcQm9aNu5vqjFcAH6D0=;
	b=54fWJu5y4gKYjgU83z7roK5LRnDiDoGZoOAjPMYUMG9YVxrgPEqSb2Y4Y01WwpcGRF1W1r
	RsKnUrCUxOvggde1x5Tx9jLaZ+9eK7wW5r/pgKw8nIXSobsVkod5NY12kGjS6LHrmyTEbH
	8Np0dXaWF4fj1RpfUqTjFizO/fLFEQw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=TNHjkcWd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.6 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jc6Mq2z6ZD6zqGgLCheZlD/s+Teoyy4lbR+IqJi/d3WPUp9islkbAfL+axwsJUNR6xlDbAiRyMHpZ0QHfaJuZ5uZEDx18ZCZbyxosImSRiIkEBO+0Zk8aGbHdBVBzUW6F6hfp86CWUPYttnqReV/EcKDv7jzxrVICnzNIzxk/CXYdGLPmKG9Gvtb5OGIYALQUZ6dLmpAW9meK85owU+Id0RRd+cLOR7b6YwSpDq3s/navcwGmk/c9zVWWArjRHClkuNmbQ0lRlJjnFNcSns/KcJXKd2T2iMW/Cn2zSu3TTpB558dd2iCyO4C/WlAy6xTxYsnvrMQbKaHYLdXJkgOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BcQaUnyGDzAw1/W2pkYmjbftcQm9aNu5vqjFcAH6D0=;
 b=yEwqW3Em4uXv4LFF4kC5AvlgK0ipGP1s/8XXUNhK/2R83MvAlCDq8Z5LyORqFu7twSBrzuxfZ/F36B9Uatrj/amQcrqnkLU2zuu2MWoNMyV81v4RkE4dCEHdggfdKjm5oE6W19538N+lzTyekS7HJ+ezg8cIvqdhh/uDVB+B46uLe/1PXxQ9FMhUtVxGjBB0+g5DWzMSV6bvAujKiqqJ0skp35bcj/0ZWLNOol1+PkKh1bCl2r6IEQ8KtRRlkxIOpZuw/Fd6WR+Vc5KPDXVwFZ749YX4yPrmwtfFSkCpr8P/OYluaLZZutSk23KFDfpJgEBWDCf9zfgPXx1vRiTFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BcQaUnyGDzAw1/W2pkYmjbftcQm9aNu5vqjFcAH6D0=;
 b=TNHjkcWd4k8QrABM9GlhueBjgYR4RktL3/kRIW6YfKgN1vfrxh1zdn+i46jwNfVbK+J2zvl9KaPk8+mWBwQBRFHMZt5LF1x1Y22w1WCIbx7WXjBw7j+cxJm1jm3kTtQrtQD841cZD3/qSIseSk/IX+Y48skHbK1it0/T9oGTFXx+A8H88Pf1hmX48DbAUNFKmFSNLuQyDngvgYAbqrqDlwaUiuzUVwbWancPsAkASgULmn0ujIfHtlVI+pv47Ny5QBBrGFdjIybxyigIjvN6hDy5osHOR2H2ODn9MExNz0SmdCgCbdVaYaAt1r7K+tlD90DMeMXRgUvt9rC9IUCSMQ==
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA0PR12MB9012.namprd12.prod.outlook.com
 (2603:10b6:208:485::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 02:44:29 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 02:44:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Samiullah Khawaja <skhawaja@google.com>, 
 syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
Subject: Re: [PATCH v2 1/2] mm/gup: add file_is_memfd_compatible() helper
Message-Id: <179520777404.1164516.10497141662043302326.b4-ty@b4>
Date: Fri, 20 Nov 2026 16:49:34 -0400
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT3PR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA0PR12MB9012:EE_
X-MS-Office365-Filtering-Correlation-Id: c5a6e63c-a58c-4e83-ae61-08df49d4dca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|18002099003|22082099003|11063799006|56012099006|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	EDSpzqdd8baKo8EMdroLNXsMb8yhmy5CPvhZbZuEL7j9MAxQ7PQ1P7NXp6sEC1+uYLoTPedClUKtXGhiNpZ5hQHYi+Wz1t4UDyNvXjVv/C2S/M0otFP1dlN0wbrDFd4gfXCWkBl6gJbckYT3VKdIharTR0hez19W5unWlaIOl48fUniyWzRLcQaOQubPKJGJ7W3sh6+RXDbcg3/jWFrylxoVwE/etKdHC/vRZXmXMwBkaTCuQLMJjbE/U7rOkgs3wgD3jdf0cBxWoEYaswGMdZwwMaWJoKTMzedR9ZpDtSevSkmZgy56bshiuWIGmMIF6mKA5eGfCRxd4HksSCLwuisFAM9r/0vrDyPoaOQPWpPO4D5xnX4A5PHRb2JU2F/0DTGlmBTdGCD54gYO9f3rv1yLLUYS291XGK6iyHqTE883BExBlLsJ6KePfXZdIB8EQ6Ket6TRQYJUKdL2y2kdIIc+AiWHRrHx+/FOBL5c1VnIfLwYXxW2nZ7/16a6+FmjFvXJDuZAE1xCNI/5m3fWXOw6VuloxVXg+EE5nDr9ygNPjcSE9/fagGPfid+fTAFMgV2XaTIgoFcPhhgngEEEsr83gwjSo8d8Iq9pxbL4BRXoQTYd6TuyA5x8oIKAyS1imcktY5dwLpZOpuCB8vmLcGckc3Ni+N+Yvp+VQfylQ44=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUY0RlZveUNFOHVIR1pVWjlBckVkVnJ5WWtqSzl1OFQ5Qm1RaWcrS2t6U28x?=
 =?utf-8?B?bUdOMytFMFAwZVhTczNXRy81RnF0WVVPd3BlSVNYRGhOZWE2dlFBOTl6RFJI?=
 =?utf-8?B?ODNLVHFXNk1ZclE1RTlOMXlrQlNhSDkwK0ovM3BBOFlTc3VsYUpXNDRWWlc1?=
 =?utf-8?B?OUpiTTNuUmJEMzJpVGx5ZWVHUnJGZ3ZRVVFWRkdCWmdRSDVUN0JTZ2w5OFF3?=
 =?utf-8?B?eVowWVVLM0JYN0xTQ3cwaU9PSWpZUDNRaEhmb2dwYXFXSWtub0ErZUZTbTZy?=
 =?utf-8?B?ZUE5UVRFQWRoNWwreEJuLzREYVFzS2x4bmQyUGdvc3k4Q21IQm9iMjVEYlpG?=
 =?utf-8?B?S2hmS0pRUlZxVFVqOHJLV3c3dFdJa0ZKT0pNbkNjeE5vV3BHc1daRHYvVHpW?=
 =?utf-8?B?TDdyTENpODFWcmRwYVQrWHNaQlFCNkhqNDhsNk9hMGRFTWlzcFNSZERLeVl0?=
 =?utf-8?B?R3NIRjFqMkxWTFVyL2RuNXBYZTVqL3Yxby9DQmFoNDlEZVJKY1BjNEk0V3Bz?=
 =?utf-8?B?YzYrZGZPdEJQaVpheHh3YVdpb2R5cHU3eUFTcjNLWkZzbTN0cVBhbitLeEl4?=
 =?utf-8?B?WmZyWmZSQktRWCtXeWtJejZGWVdhcDhIUkJkZjFHWDdXbWM4ejdQT2s2OUVU?=
 =?utf-8?B?NEVsanlRYnNGQUlnWWx3U3dLdjlSeHZOMVRRQ2Vrb1c2S05sazUxWG5BdzMy?=
 =?utf-8?B?NWNmb0ZiSkliMmx4R2FIZHp3b3plU20vaWwzRnFYaUJ5UE9adTBQcUVxcXNK?=
 =?utf-8?B?STZsdXJ5R1R4c20wY1FxcW41SFRoUG9xczJiZjZkUkZVb3JYYVRyRy94bkMv?=
 =?utf-8?B?bFNJazl4UWtaWXRaSVRoQWJJYzU5MDJ4WGV5UXVqS3JLSHdtMlhUZUxZaXRq?=
 =?utf-8?B?ZXc5Q05FT1ZodkhyZ0hMd2JpaVUwdk5DU2lpemE2Wm5QVC9UV0Rwd2JWeTBQ?=
 =?utf-8?B?d3VpVzYzR0FTWGdoVHpKVCtBSHNlOXZsc2NnUVA1cU43N2QwWUdISnIrVXdZ?=
 =?utf-8?B?NXdUMFlJMWtiK2pVNlUrRWk3dFRTTnRjZnZKM2MrWmJSblcrN0NaMkN0RHk1?=
 =?utf-8?B?Tlp6YWJxSlh5QlhWZmNjOXBOdTRZTGt0MmFQUWhlZG9uZmRyVzEzQ2RGWWVm?=
 =?utf-8?B?MHRDaVY1NnU0cEUrT0FvdTJvdzUyV2Q2ZGl2czZvOUNXTjM2VkN3S0szVGdD?=
 =?utf-8?B?RXJHTUxoUTlPQWozYkk2Sm01d3lnd2lENVp3a3c0WGw4azMvbjZKRGpWR1dz?=
 =?utf-8?B?ZEpZUjUvRWgwa1gyY0NLTkZLWS9KYnlvbHhPRVdMeUJycjFMSHZlMjZhVHJD?=
 =?utf-8?B?bXVUR1JSMW1BTHM0M2pLeHVMN0V6N20vQ3lRRUhKVDFMdGY3SGFRSng0aWk1?=
 =?utf-8?B?QUcvMkpZUm94NkYzZDBFelFBRXpsS3hkMEExb2tTSnBXRU1IQjFwU0t5N3ZP?=
 =?utf-8?B?WUo3M2REM0pGUWY5NGt2ditySUFBZ0JUandPM3FoSVAreElOVThIUHBVZUly?=
 =?utf-8?B?UCtJUkNxeGZNZ0RyTkJwRXRaRG1raFl4WTE4dkpGdTNRWTR4N2VtQ0N4cjJw?=
 =?utf-8?B?WEZ1MmpCVWlFek1VRzg2bkdueFd2bjBIMjVWRVptb2tOVU9mVmIzU3FQeXE2?=
 =?utf-8?B?WVp2cFhwRVd0WDQ4b3VWSTZxeEZXKzEvbWN1NFRSZGJUV2tWbHErczB3NE8v?=
 =?utf-8?B?NWthZDYxUDc5ZkY2Wk9rTG4yMmE5dWpjUFkvSFF2Zzdhd0V0MUpyK1AzMjRV?=
 =?utf-8?B?Qk1GZkwrd0dmNUR5UlI2cDBOTG9mblptTUhyak51NHZUakJaUG9JckIzUkUx?=
 =?utf-8?B?RjJOUGNaRnlzQjRqNzBaWmJ2K2YwMXlYNTBtZDZ4c0YrdFFHZFkzSGtRb09G?=
 =?utf-8?B?L2FRL3NyRzh6Y0xDZ296bWdJaFpRTjQxVE85Y1dEcDA5cGJnNTFYRXVvbml6?=
 =?utf-8?B?TUdmdzJ2dGVPSDVKSlIvZ0tFUFNjOUw0SURpN25BVmFJZ09HS0NQN1ZhTHYr?=
 =?utf-8?B?THQ0WndRVDlrU3dadXMvZWh4dHcrOTZLVkNwS1VUaEpScURhRE92R0tRT0RE?=
 =?utf-8?B?clQrYm1FUjdZL1FoS1R0MC9pOEVIUTYyaHlZYzJ1VThxaDdUU3lvQ0h4YjUw?=
 =?utf-8?B?L3VodTArZkUxbHZpUmpDWmw0OEJuRytUVzFIaFZkeU04d1k4cXIrYjNKNFRo?=
 =?utf-8?B?R3IvUGJMakh3N0kwbHg0bEFmTjdtWEQ1b1FLQ3dIQzR5TGpMQVBPQi9yTk1W?=
 =?utf-8?B?SlltQUFnZWl1NTJDS1RzT1Z6RENrYlZMUElwRDBWUXNUbkl0S2x1YmJxaytX?=
 =?utf-8?Q?cBR959vuaenSlaIeaj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a6e63c-a58c-4e83-ae61-08df49d4dca9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 02:44:29.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dh4xkfhSgb8HySCcmr9DrhtdgfWZijIrrUEyv/901J0N8fW7ffEs0X4KM6R3kE7x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9012
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C497DC000A
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_48_96,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: t67w6yj75gkjx3xceg64dutt4egz4gu9
X-HE-Tag: 1795488274-346049
X-HE-Meta: U2FsdGVkX1/G1oAwvnhtg8/5XGzRsjyeTTJnwqqpc7LKnBasqQx9nyuemDDV8HGBNh/rsbtHli0W8EPPMyRNlsYzJfNgCHmf0l48VVcgremUPNaom2uuX6mgE3KQ9HT7y0700uyE6G3N4Rd2waUzQZDm2mA6AR/xMj0R6pCm5hDlh9EoweUgTtUyXOuO0G3ag8UBRLT6wHlo45ix6iFPkEM6ckcGu+/XwbdwmQZQEK/4HUbcwzHpFEUO8WmiLugFxUNN1Xys/KtJwYYkR+sJcpfal6KDwX/iVESWmBNBCJj5TTIl2wWd7irfo2gGFsRPvmmokdiKofQPn68do+GktjWladkjnPRn0GJETRP5BFbCIByhedaTtGi2iW4fczlp1C7nNHyBmVAvnS95jrL71v/UE95OYoXV84RCZjP6YPLREN+ZnPpf0sGBmrTrs7I+GW0tipuXfI4hC88m7759ZvetT9BBWHQ5jiIVldHhIZOsX+jzGtiJetXAt2Z1vgxeixzF5yixX+zGBP8Hj6bra2LHT6Cv6no3gCYR3pxAgSbEkRqDt5sC4Wz0MSsmz+uEBvvNtkA6ZB2syAz5wWNpFMifznIvUUaSAjRNupOeS05M7CDvAtK8PUA0Dz2SnjIRt/80Lw5ehMriPqm5ERbJZN/4ZcKr70YDgHN+DKFingxf050pT737YwSNsxSn1RgdB2mtrNS1P1CNVSCYDwQEEI+6FzC/GYsT4XLl6LzogYUioy6I9SJlxKpbqLiz6d7j50Uc93pAGoXJdvqDvCiJ1BVYkbdhFwNyq3ZyCOVb0E1Bl4n8rhmFV5Ilns7uCNWDT6ifd3oVYPK2YWLQlDjxR1mjUTjN6NwUrkviRltkD/IPVq+9dD9Kzwdt7BdmC+pBsnpeHHLWjq/m8T1hBRYJmi2S5q46QQEGC/yZjzBf9PbNU0CcJVDRu7wXHE7zo9Px9JN4tlShuitWjZfGk/x
 ojfjzjKr
 MASjYUboTlyCGae+TphYYVfY+KXxvMkZMJN/0A8gwVlcs+dMhaAsq3Gv9Nue4tg4zZgJGwl2LHvkuxS1k/o++hbBCfyTNssU5oI7eq0m+rImvw5nwiBipI/KJpVeQgPtt5rnELzYk2nS8Pqnel2JmjPa5XudacBzEONr4MMNTzrUd+T8YUgKfCVqxrYm0G2rB9Pi0ekCo0+jy666pniWh1cjBXetA0Msh+ks9wegU121EgsOAP5BRqXxhHVfY4SAqSnG6XwB6LdHbkVxBy5NYd1zHXXZBgmDe97xab0qWLuZNXDHoi45cUlIaSp8r7+hDiQJKOKfVOUOJjbLbAIrbAhUDNaPxjyqlTT3AfhNapdcLY/Ngy0vMmhpTce7xMyMC5jWBPaazwxV02S+J4AidcdzCQAUShYslioZjur9q0OtSDR+gj97UK+AdtAK0QmbZgvTYIecUkAImqLPfCcGbx0kijCZuru8uBYCDPLxUzoCzMftIJYqxSo2N9T8JoBB86ddZAvkukLOIDpw+xbl0pd5BKpiYPHgux40mXpZHFboHk1IGVdo0F+W1TJnLUpL5miahe47cHQxfwD/0BQCBQ8VcdSbUussJFNjmr67n3VbwInGBBTBbN9pMjDVAjvD0Wjt9AfrMcFLgb+sTTtP7lAtMWuA6UAmPZx2La0WoADNWQM3/GbrT4xc9wkJwZMnDAzqjdEmE+tnpoOX+h+JPDm3i/QyrJjiq5CJd+dOY+jjBko7rNIx9A6iMGvtlg36lw1twzFUDj3cbT9OlMaXgzzzn9etVCLGDMTkWdLysSx12emWNYAWz7jcNsVaVc6F3G6PqfHO073RnE04+d5JEMxah6in1slCNRWYS5ZCCZiORTeyg4bVR7U7/bt+lJNOXJ/BqHpooFL6I8jNvNSXqUSZtBCYm8TEgdfjiHo2wK3QcQqC6Co+RMdbX+JegiIBWES8FsbQ2QkotuCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, 19 Nov 2026 16:35:31 +0800, Jiahao Xu wrote:
> mm/gup: add file_is_memfd_compatible() helper

Applied, thanks!

[1/2] mm/gup: add file_is_memfd_compatible() helper
      https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?id=94494921b628b80c5dbaff8905966c68394c51bd
[2/2] iommufd: only hold references to files memfd_pin_folios() can pin
      https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?id=5b370585dc72fa7caa01b005557b18649d77cc6d

Best regards,
-- 
Jason



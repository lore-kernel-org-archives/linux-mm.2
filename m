Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C37CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701A68E0020; Fri, 14 Nov 2025 12:15:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B27B8E001A; Fri, 14 Nov 2025 12:15:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1058E0020; Fri, 14 Nov 2025 12:15:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49FF88E001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:15:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF90E1A0441
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:15:47 +0000 (UTC)
X-FDA: 84109864734.19.86D9D19
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id B2BB680012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:15:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JTmh7ZvY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFSM6BQkLF3SfJ2KaFjA3+nsXO30gyj6v5Mrfmz3z3Y=;
	b=FujxmiBR2rKg8ooLTRUzMgHsR7WdQoG2v1OifB6LaEOgHZcJtZrdPvjk8z3JrOgsIdRt4h
	bPVyK6I/dfR/ktCaBVGjAn4wTrbQ8/f44fkpTTUNZRki1VLIr9UQVsGVLlsUl5c1JfuJo2
	DrteXWfTCA4IZ3woZuEk0/K76QSm3qQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JTmh7ZvY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763140544; a=rsa-sha256;
	cv=pass;
	b=2zYNHivzgJNQPFmndpNv3psNfBoj9ruOfBx96DzB+JTfllhcscd5DCz7r3d4zb2zgfZ46a
	YhwSOAre7tRWNNtGTKfrIlLlAFEIS8NQTdDGevureZlsN4DHTVkGZBsQesdJVERoizvYM9
	80hB2c88q8RNYnLcsyFXSrKeF0TvbNw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3oFyuud9U/c0JqbAgMIcDSgbKiYE07pQHZJcmVEewEa9FFkZZahXID++FE5l4rl+aRsCXugVrsoDxqa0r3EqJ5+FQ9xft96oLxCELG9trrsjjgLtKJAC6d2dkurC0IwQv1+Xoxe8E0v6aAd9gQEGAOs6oZD+5Ochc9RUSGmeLObKOQUqOzY7Jw63lzuV+EUSICtDKhCikeWZA9uxSohNCmz48NkkBMxVkIud7wdagdCfPMBKtXN9OgsH5jhCdudcGSVjkMpBRTnyn03gJZhOx8queN5L4UyCbf+3tcjygpS+Zdw6LapNSFQui9bQuZHoCrS3EXV1NGkslnBgmUzrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFSM6BQkLF3SfJ2KaFjA3+nsXO30gyj6v5Mrfmz3z3Y=;
 b=pk3upNQsPVXlFiDiVOB7OSn5afSSOIVenPEcjaGjWhtYLFsXHdhnGIOMOdkICYKX9WNuN5BilQRmOkbqBqONqvQ+DYR9Tn0MuolrdyseGI2P4+iqKfUBaEm2VQj35Y4UVDkN8eu2LookKHIoOCV7aXqHtYmJtQitkCS1erTLh1GT7MiEvG2v3H6fdK+Fyn1cNNBWWwnacsccGZbvqkoWQwiLhmuXZSKcjm+wBmxRbzFwNaKOhZBy7beHYj/jgHHkX96uIZC4qs+2sCkl5bb5YBBMF53D7PVNyJpddJOdXG5nNL58C4/8jAYYIhz1ZDTcmzLd9y8YJBeD+bzFClAhrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFSM6BQkLF3SfJ2KaFjA3+nsXO30gyj6v5Mrfmz3z3Y=;
 b=JTmh7ZvYYeX43lsQ9dI/VqKvB2i2kPzUCyUugF6MIDE50SN0ZkIAMAmdbGiFBeMe2ltl8TlcqlyWJSGaADPhRLtMbQI7WtpkIIHg1IboTuwyxrhwR9RMdd4WNrmiSkwV7MyMUNetnKg98UpPYTmmpI6YXDihIgMBChmPwRhJKI+h8bzzphQbBmWxAzwFq0NxjP6EIqmbe/+paYWxR3yfp7IBilTyo4oNprq/GCNgzlK+5K2SMZTbOOngos+NzMzATM/f4z/KY9QaWFaQAJewrXUDsSr98Zz5WaiLRKHu9dEa4UoTrdTToiiof6VS0YDevBK7XLJV3C6XZ8vwetw7lQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB7896.namprd12.prod.outlook.com (2603:10b6:a03:4c6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.18; Fri, 14 Nov 2025 17:15:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 17:15:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Fujunjie <fujunjie1@qq.com>
Cc: Brendan Jackman <jackmanb@google.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using
 monotonicity
Date: Fri, 14 Nov 2025 12:15:38 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <718D7B69-8261-430F-8EFA-1B3304AE58EB@nvidia.com>
In-Reply-To: <tencent_DFDA2D92B8F69FEF149FE7593DBC47B46E09@qq.com>
References: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
 <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
 <912CFDB8-6374-4428-A0F2-29FB00E6ECE2@nvidia.com>
 <tencent_DFDA2D92B8F69FEF149FE7593DBC47B46E09@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0605.namprd03.prod.outlook.com
 (2603:10b6:408:106::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e145931-437b-459d-7abe-08de23a16fbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WG9DYVN1MkdBLzVHWG5JcXpJbGgra3YzekdOc3U2THRQRXlkZWpISDJ1T0lK?=
 =?utf-8?B?NW9yZlhSQ1pHNHdSU1kycUpGYWdsM3NpajIvdE8rQjJNcmVCNGh4OXQ3MDR4?=
 =?utf-8?B?aHlsVElTb3hUeWtEUXpsM1RxM1NmUThwZFJNaFUwUTNBcVdjQjNKRm1yRzBJ?=
 =?utf-8?B?WnZESkVvd2hpNmkrRGdleDBaaU05ODFhS05hVXU5cG1aK29XWlpVYnVFS2g5?=
 =?utf-8?B?NFBXb1V1eCtYVStWVWpZQUc1YlhqVmxNQlZ0T2JvRmVCM1pwaFhiL1UzTFBq?=
 =?utf-8?B?a0RnT1JCR0c1NjBLdW56QmR6cmtwb0dyNUx4aVpwWkpKV05jb0VmbUxmL0pW?=
 =?utf-8?B?OXozQ2UxMnBBZkdRZVgxb1FUWXc5aEJOWHVybGYxZFFoYmVKbTAxYkRDY2x3?=
 =?utf-8?B?Z3hXZHBDVitVbGJqVmd2SGNpUVJST2p6RXFiemRkMVBLYlk5WkNwalR2ODBL?=
 =?utf-8?B?M1diYS9zR1dpcURzOTFyVkJTQkhvNmtXNE5TTk1aRjNLSksrTzFtc21zVHZJ?=
 =?utf-8?B?UjJyb1ppZGxVQTM5QVd1MXFNNnFHcUNuLzJ4MWZIT1NadVFZcHNoMmcxZU85?=
 =?utf-8?B?OHlIRGo2OUhqSnVteFRONkVuRFBVT3pSS1BSQkd4U3ZTcDR4U1phSERYZHdW?=
 =?utf-8?B?elVPYlRkR3F2am55QXFXb3JEd2cyTkd5Rk8zOGpRWnZJeitPa3ZsaFN0b1FS?=
 =?utf-8?B?dTMvdHBtRS9jZlFwZ1A3RnFvOExPVnhETXA1ZDVZWGE2ZFg0TGx1WU1LbEdx?=
 =?utf-8?B?QW44T1hhN0lqSEd3VHVVc29oWHNkc3FkUUhSVXBwdGtvZjd2QVlvRXl3aXkr?=
 =?utf-8?B?L1JUUVVIa0ZMQ21leFR5SVVTOWtFTXB0RFp1bDl5Y3ZCK2M1NENPaXR4TWl3?=
 =?utf-8?B?cTAyN3ZKODU1Y25IMXJtSkcwN2pyYjMvS0xEN1RDUmVTWkFiYzFjMmd0cCty?=
 =?utf-8?B?YXFIenVJbVF3Vkx3MVJJUnZkditKOFFwQ0I2d3RYM1RxSUMyaWgxeHF0RFdB?=
 =?utf-8?B?cHQzYW5UT0Q3UElOdVVmaHNNSW8xSjhZUFREOTdVdWxOR21vZk1pMzJFNVJC?=
 =?utf-8?B?SlpYdmsyVDM4STdmeGk2ZEVmMG5KV1VwZXgvZEJGM0JYd0RlUURBK2k1U2g0?=
 =?utf-8?B?NjFZQVFibGVpaUJCVWhxN1BRS1gzSUIyU3JCNzBLaHMvTnJWWGNDYXVWcTdG?=
 =?utf-8?B?QXN3ZDlGWEFIcGd6aExpQnc1M0pBRUZ4SS9LSWxXRjEwb05nbjl3ZWtQOEsr?=
 =?utf-8?B?SmxhTDJ0WWE4eHczVGU0UDNkdEp2OFliVUo0MnFxRkhaWTFnWkZLdndjMFN5?=
 =?utf-8?B?aTF0Sy9jMDJqWCtyU1lXLzRLbjdBNE4yNldscWkydG1Ic2FJZ0dpdVp1Q3Jh?=
 =?utf-8?B?L3M5VlZoek1pYUYrRDdaMXhQNHplOU9jU1c3Sk9xOWlMblJjVklCUFd3UWdS?=
 =?utf-8?B?ZUozTk5peXNzbUJ0NG9LWWhGNlNJaGduSFdmVm9hVnRMa0ZvY0sxQk8zTlBi?=
 =?utf-8?B?Rld0SFlwLzVsNlpoSWJUSFpMVXljUkR1MUtPWEVNUy8vWkcxT0xEQnQ1TUFk?=
 =?utf-8?B?SnBJekt0ZFYwTlYyQTdoSFhxVUh6N0VCRnJ1b0FldEZNOUx0MWJWbkgwcWdz?=
 =?utf-8?B?SXA3ZlhqdC9XYU1udlNxKzhmNkd5S0o2OStvNE5iV1NydVZkdFNuN1Q0UmdS?=
 =?utf-8?B?NGd2Y2wybC96N2xtSmJnNFJHTHBlNzN2M2llMml1bndEd2gyMzlTZmNHYnlF?=
 =?utf-8?B?aXpuRnNIUzNpNVZWVkRDUEFXbmllSEVud0hsZHg4VmpGSGtKK3gycSt3dU5r?=
 =?utf-8?B?dFgxbDBQL2l4RncwSVlRLzAvUGMzNHhCc3k0ZHJnd05mK242Ukg0SDJndW10?=
 =?utf-8?B?TTJPOFAycXJDeFkwSUx6NWg1eHFxTktsR3FvTkcreC9XbDErMk9PdmJER241?=
 =?utf-8?Q?KFjUnNs0nlBBXvRDjFDUabXBsFql/gh+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHB4eVNucHQyTW1oVDZ3TWRJT0JKelZoVXZ2eFRna3piaDZDL3Q5RVE4ZGtX?=
 =?utf-8?B?aDJtbGU4WHQ1Mm9pSUYzcDArZlJWRU04NkNDb0gzK0pnQjB0OHdHaitMQkQ4?=
 =?utf-8?B?QTdXSDFCWjFXcllpMmV1R1JGMFJKRnlzbkR2UkRCcmtlazhHUm5sUStmSDJF?=
 =?utf-8?B?YytSUHFlOG5nM1o1Y0ROMi9USDlvNnYzR01ZQ3pzcStVUFV2WVowMyt3TkYz?=
 =?utf-8?B?SlhiZExPMG04RlJmNGJ6OWtnazlhQm1raWUxb2NVWHU1eHgwbGJta3lONER5?=
 =?utf-8?B?TmdVVjhzckxOZVBqVEx3WEtiOW9yeFVCMDNObkxZZ2NBU0NETXl3eXZsRE9h?=
 =?utf-8?B?ME15a0ZXbXdWSEVBT0JvWEpFOFN2NWloeGtjV0doNkY0aEJkeG1PUm90aFd1?=
 =?utf-8?B?ZzlOdXNlWE92ZGVYcHM4Q2NLMlNBQXlaaThZMXhLOXA5RVJELzU5cm1DaTlv?=
 =?utf-8?B?S1pySytOc0Z1bStGTlVxOWN5TkQ5UjFVQzFHSUFPOUM3VkdGY21ObEZwWUIr?=
 =?utf-8?B?QXpNT2J5bk5ZUkJlNTBvcElwUnk5eWNYTjlWTHF0UEI3c0VoZlNyejhVS2hB?=
 =?utf-8?B?L3hoQlRHemN4aVlKZVpLTnc5bmxRd0RyYWowYlN1Z0x5THlrYWpEQk53bldX?=
 =?utf-8?B?U1R5VTQ2L1BSV1kxN2MyRUgzRGN3ODNIMy93eXp4aHF5NnBYSzM5RTRvNzBr?=
 =?utf-8?B?MjBIcHBrUEdKU0R5Zkltdy9sRkVvZVFEQmFlVlM0Zm1HamZXbHA5dThsQXZH?=
 =?utf-8?B?L0pQNXVheTNlK1h3R0hycGtaZmYrd2toS3NiTHE3MldHZmpJSFh0ZzBGSlly?=
 =?utf-8?B?elN4TXJGbVBRUHoyYkR4VDJIM1Z6WDZ2aDhoVXFQWFhZVjhiRldTUzdPR2pS?=
 =?utf-8?B?UHNkWGlpQTJTRzBuMFRxNVA4UERSLzhMYzQ5YUE3cnFvcWRyN3paUmh3TlE0?=
 =?utf-8?B?N1lYcUlvVGhucGJGU0ZKZlk3S2JrUjVyVmIySFNHSUw3b1FDNEJ5MFVDQmcz?=
 =?utf-8?B?eitZaFMwSGgxQjI0eTR5Q3I3d1hSbmI0SGVwOHY2eXUvQUF5UW5PdE5WbGx4?=
 =?utf-8?B?YTlnQS9VLzF6bWc2V1UzRVd1aW4yelN0NVFGOW9pSTl5VVd2d0RYYlNXZzNm?=
 =?utf-8?B?S2FOVG5wYWk1dWpzU0ZncVpPczJpMnVTbnVqWXJBY2tIRVgraXlkSDI3OStz?=
 =?utf-8?B?WmlOK3pVS0pTZ1V5SDV4amNWQVFiZGpGU3AwYzRIdFdmWEk4K0RGbHlUMmw4?=
 =?utf-8?B?UjFmMzlWVHYrL21oQXcvWUdRTngzbjBWWllKWjJSRkd0UEMvV2NpSUFKNit1?=
 =?utf-8?B?V1lJVWFEV3FnL1hDSVEySGtqckVRUzZzWEw1eVhuaVovZHlxa3RraUQrUGU2?=
 =?utf-8?B?ODdsdGZ0c2R4eTZBZEQ4SDh0ZDl2Wi9Db2lON05WRmQvVDVmTDNWNG5GZENU?=
 =?utf-8?B?THJBREptZDBuVHdldnN0ZFFiclI4d2dVcmUwWXIrK0VkYkgwNUx5Y2YwQWtr?=
 =?utf-8?B?MnhuaUZzOGlUU1A0MFBKNlNRbDc5YkJ4SkRnRG10aHNjTEdvTVpvcnBhVmRE?=
 =?utf-8?B?MTZEQmEvbTNObjNnYjczL2EzZHJKWVJ1Mzh5UzdYTHBBWTNNLzRyRC9nZDRM?=
 =?utf-8?B?N1p0NW0zbW05ZjVrcWlubXFWY0w0V2VFZEZldlhUQk96UGFuaEZ4TjhNWWxZ?=
 =?utf-8?B?TmdMUjlncmZqUFcxdGNxUW1rdnhCOUhkTE85NFVPd2U5U0lEakw4ZitKZXdF?=
 =?utf-8?B?YVB0UGVLVjNIUVlKRUg0bFVLb2wxcmgyTG1rd0QyRFFMTXpvK2t5aVNoOUJK?=
 =?utf-8?B?YXhvTlZFR2RLY1l1MGFzU084UDh5VjZyN0QyVFFHTXNETSt5bnFKcjF0RXEy?=
 =?utf-8?B?YlR6Qyt5SDUxKzI5ZDBCRlRVL2tQRHdlcTNIWHE2Vy9RN1BxRDFpUGRPanZI?=
 =?utf-8?B?d3NDWm14Q3hJOGhqWmVKU2ZJWllMZVBhMk5YMlVITC9nSTlXK2hiUkJSYVpv?=
 =?utf-8?B?UTdpOFdPQ1h5K1lxaURNeGZVSVMzUTZyNi9QTEJXNTN6VDhpWlRSVzlEMUtw?=
 =?utf-8?B?Tml3YlloRFgveFVubjdJV3JzODNzQXRZZW9nVE9vT2NXVXBkR2hSeFJqb1Zy?=
 =?utf-8?Q?R5vGX677ePsBu9x+eGbz16CIE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e145931-437b-459d-7abe-08de23a16fbd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 17:15:40.5584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbnKC/yWvQy21mkI1mWcqDsiWRk7TFvU0rCXPUL6iYoRuif63AfwqHFYvJxiNHbT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7896
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2BB680012
X-Stat-Signature: hm63pusfcfpdyfw61w4qxhg1koq6noxx
X-Rspam-User: 
X-HE-Tag: 1763140544-31495
X-HE-Meta: U2FsdGVkX18lizJy35/x4JlVnb7EYMDj0gEty3Jkr3j3Y10QzBAh4OjjLJy4tAMctHvPye3p2He2wyCZqLAnJmhsYRrjUl7a1rbR1DPAdQDbEhJcUsM8GFrfsmvUXBWkXaw/OTd9FmFE4TWAWLDCUzqPP8bWfGiVEe39CZYEkg5jfZGmvzWy4vYjxFu5vxC781g9FO6E3UpaGebm7monNA7ZjWWlIZN2OChcmyKAtVv9GSaqMFJaPQB8Pr8jLbfTWtJv/i1wV+ZYFvs3eGqXqCYc4W8xxeaTVnXVmSzcaFZQhBaKfhcfS1Hf9oQXGC0zGlLeAOn3sf0DTshWtXscdfZZtJiljkUGPdTykC7HxPv1jt3lJk4FpFTIW9PebLtqFofvAy96x6S29XNTBEq4iZBbb9SgBMzxTvGTnVNMNZo5obHMoPb9Q6HFapoe7zpcHUmnr0VlKxPLEVDoRaQ4koJlOcZ2tw0WxSgFHVylHf3WpdnZPweB3mmJz536ZvWYCx/Rurqmhm8ZiNpTVe/rgwrsD0lPzBAGdf1vNKn8G8p+LIkN4lOWuxxfrp5zpxSGSLUp24yDKNz/o4/38YbgHffZsHxYPEwqXutGr5faEJ1vzlCHA0BDy7WEUbNPxGgMIfJ7JvjMLUTS5m70phgQnpDKoffqt+a20wHp586mqhWxIgtMh54Oibq07GZuMR3IwJe1H/upy80wiQKXyXgvlqyhBUHsKLXYGy1p/VyqRg7d0H9YdsxIfnApkkvgVES7p2SQ7GxxZV9yD59IAhDvRryQ+QqBEujfyp3tZ/XuqpOFFxybZptpVmIAW2Zi/sqY8w/6gjF7VGm/zH7EVzDSErjAiR1B8HKLuvQ+QehdWvtjnW9FSkaiB+BvpisNpa9xUksCp6jIRu81ysUciO0RmIPdbCI7NXokENi6+tO483QH2JCGvlin8fMOk/z4iOqwfYOBX3AKmGHFJ8brV54
 PsUPGaFV
 lUo3nt7FSWnYCWeecRwj8+j/y/BwWZIMYWpDM9QwsMlZwGeoXryf9yKrfpFD6lc0H2uM+uHw2L0HFHeXtdEW6+/TAq6zQjjq1OZY0XmSzYm3zWo+VBjnKqoRR8aGBpRlxV4DBmg33oP5Lraqof/ntyYOmhe3xBZ/sbSAiHWyiy2ddfdk1wm8i70x+vodrb80Ppc28n0NtucfEfKKTtckV58IYG22sBjG8sFxwgLRuYD7Uoph5Hy+1hj6A7tykSsRyTN78DktgCpxTHaYpW9HXk2OU4mPWO+4h7RMMlt/2e6/fICDPb2wJzro5vAnFGuKC3Q33vbyGlnWblqCGUvX4Tl3/qTzfR+Y1dINV70wkLu6luw7PwhCeqhp2OqUiBBuFuD+EZW6IIQkDRJ5lVt8hAH3gFjQz/kHB2LqxiD5AmhomTM/HeeJ1NcDBt+6DQIbYCJTk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Nov 2025, at 11:34, Fujunjie wrote:

> On Sat Nov 15, 2025 at 00:12 AM UTC, Zi Yan wrote:
>
>> My concern on this change is that the correctness of
>> calculate_totalreserve_pages() now relies on the implementation of
>> setup_per_zone_lowmem_reserve(). How can we make sure in the future
>> this will not break when setup_per_zone_lowmem_reserve() is changed?
>> Hoping people read the comment and do the right thing?
> Thanks for raising this, Zi.
>
> I agree it would be a real problem if calculate_totalreserve_pages()
> were relying on a fragile detail of how setup_per_zone_lowmem_reserve()
> happens to be written today.
>
> What I intended to rely on is not an implementation detail, but the
> semantics of zone->lowmem_reserve[j] for a given zone (with
> zone_idx(zone) == i).
>
> For such a zone "i", zone->lowmem_reserve[j] (j > i) represents how many
> pages in zone "i" must effectively be kept in reserve when deciding
> whether an allocation class that is allowed to allocate from zones up to
> "j" may fall back into zone "i". The purpose of these reserves is to
> protect allocation classes that cannot use higher zones and therefore
> depend more heavily on this lower zone.
>
> When viewed this way, the partial ordering in j comes from the meaning
> of the field: as j increases, we are considering allocation classes that
> can use a strictly larger set of fallback zones. Those more flexible
> allocations should not be allowed to consume more low memory than the
> less flexible ones. It would be quite unexpected—in terms of the reserve
> semantics—if a higher-j allocation class were permitted to deplete zone
> "i" more aggressively than a lower-j one.
>
> So the “non-decreasing in j” property is really a data invariant implied
> by the reserve semantics, rather than an assumption about how
> setup_per_zone_lowmem_reserve() happens to be implemented today.
>
> setup_per_zone_lowmem_reserve() currently encodes this meaning by
> accumulating managed pages from higher zones and applying the configured
> ratio. If some future change were to alter that implementation in a way
> that breaks monotonicity, that would likely reflect a change in the
> intended semantics of lowmem_reserve itself—at which point consumers
> like calculate_totalreserve_pages() would naturally need to be updated
> as well.

Thank you for the explanation. Now your changes make more sense to me.
Like Brendan mentioned, at least add a comment in
setup_per_zone_lowmem_reserve() to state this monotonicity requirement
and mention the correctness of calculate_totalreserve_pages() relies on
it. And also please add the above text to the commit log to clarify
the purpose of the patch.

Thanks.

Best Regards,
Yan, Zi


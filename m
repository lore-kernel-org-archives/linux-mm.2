Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8E1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 21:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8ED8E0002; Wed, 10 Sep 2025 17:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2598D8E0001; Wed, 10 Sep 2025 17:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1487B8E0002; Wed, 10 Sep 2025 17:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 016B28E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:54:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CDA71A02F1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:54:32 +0000 (UTC)
X-FDA: 83874695184.25.1E739D2
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7DDC180003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:54:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QK35nfKy;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757541269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6d8BudgP3mW0BjjLux7f5xNWWq2BxqHvd/zHqw6ksqQ=;
	b=JrrEFuJdW2HH/1VoWiZp2URA2lTZYBfCBstQoqcZPNOA6H4tPNqgPgYrO9SghUxDgjRa42
	CA/7v20jm5O2y+QpspQ2egbTcGr1tfc3VaNMSQXfRCgUffCSPw11M3T8ztdHRW3EuczVJS
	pj5Jvg2lcYEiMig96aJUaklDY6c5/sQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QK35nfKy;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757541269; a=rsa-sha256;
	cv=pass;
	b=3c9HhBiFUpuSmJGKcTAqQt/mBgKJqjwPKYNKnjsQT2xHx8SmL0USz7VNVlbeaniJhvbkZ1
	Z/IwhWOVbF5VwVFG2ePP2JBRfmkuFPudzyWDto6gVz0R9nIdqiAYb3SUbTf722jr16TwnC
	DbuHDDThewvZlxApt+7EelbAvJbTCM0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l2/2rorZWPke3LzO0M/5wWWu8kZcTpoBGtWFI2gg16n2PR2zxQTLY1ogj/1cv3apq6Q0VvsnDll/zi/CzXYoyqbuLpm/dy2AR1XNaMyGr4YTXfc97+KItOYH2c3hTtD1zULAYPNLr/FQQJMznW2rwziNTCYhMIa1aEKjxkPHJKRpRvUbqbieE+BWTF52bmcXvykyzymQYHs0FeWExXU4vBivzJilkBm8nn6sVfNnct3oq08qcMTDYjjVjFMPqeiSkokYPC7JAZDs4w+JcdBrd6SufPZtLpZr5dVy3q2gDP75mMcUGM2vWVRUTYRgb409+ocv2tDP6nAC+VMP60G1WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d8BudgP3mW0BjjLux7f5xNWWq2BxqHvd/zHqw6ksqQ=;
 b=DAt3thO0ffa2Flpafn0tlxiTDbSLLhCQH6ayCSbiY1g+/asmhJa3LB5YfHf+gVxTw4hiOHM91qOcntZWG402BqQVBbeIgRvOte4sPu5FmHQb59kQ9RUARGoLJv+5atz9v8k1p/7q/QEOgTErW50DyjpFeL/MiCZKGVUnuqRDmtNUV2DOP0gh8+4kZTrJNpOZGAkMBQJ8Ma7TzRsw75w4ESAwcMwxxczQED22+j2YgnAdtzNEgQhvTOWJ7XYkho1Jtxy5EMz3dLpWQJzIImXp9tAyUOjdvWyU+PlA1HHZg/rs0UBhAaCqnYyQG8CUIaTLB0KH1kyO/mJOEQRZNLALDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d8BudgP3mW0BjjLux7f5xNWWq2BxqHvd/zHqw6ksqQ=;
 b=QK35nfKyxiNX+cYz+CIJ3/a/QjAeYePZric+dKc4Q8hizc8o+k/9YbgIuUIrYDpHQIqycFPel2+WW9BEcqAU3OlK2ZgKV7O62BeeJCNM0iEfSnKY8DjD2khnOIymk/RMvKOr+LK5Ji1BcUwrfLj6sgKtlLdsB7I0MkCiLo32JQDrNav3T6shUDs8U95W0ijIkbMh/S8rezlDS4WfpoWJpmlKx0XLmh5odhUgqwl9ybxuwYHsnnFZtU27vWIFVzKUimhpAz/aBVZrMiznJWavcJosP3FLlao+MCgYxJkTzAkXyCAHN8rpWdmeWj160zBv0ccEH7/kgzv19+aF3QQulg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB7947.namprd12.prod.outlook.com (2603:10b6:8:150::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 21:54:24 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 21:54:24 +0000
Message-ID: <88f160fb-0f84-49e2-9139-1fba1a21428e@nvidia.com>
Date: Thu, 11 Sep 2025 07:54:20 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 398/411] mm/huge_memory.c:3069
 __split_huge_pmd_locked() error: uninitialized symbol 'write'.
To: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202509101756.jkC29gja-lkp@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <202509101756.jkC29gja-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0042.prod.exchangelabs.com (2603:10b6:a03:94::19)
 To PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 436ca446-1656-43f8-9e49-08ddf0b49acf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDVWWW1BOGQwV0p0Nm1qMmIySW9rWGQ3T2lxdWUrWWovdFJHK050UkFMTUZE?=
 =?utf-8?B?cHg4NFk5RWNUck5mVXYyemUwKzNKS1dIaGxEcm1pTGFSSlZ0cVdDcVpQcThE?=
 =?utf-8?B?VHBocG1CUTFLNEgrNlByUG53N3Q3cUhKejBGTlBVOXl5YTdpNS9FeFR2N2Mv?=
 =?utf-8?B?dDEzTWVQUEZ5RHg0SUZMS3k4ZmwvdE9QWlhJRnFYd3BLQTAzbUJsVjVUakdQ?=
 =?utf-8?B?aXZNUTlTS2tjNEt1R2h0MnJzaUI0dXEvRVc0KytFbnNaSElkU2tsbm1TdlRF?=
 =?utf-8?B?bUJQYnlMTTdKVCtqUEljUllVNHNqNXlMWUtEaEFaOVpML0ZTTnk4QXVNS1hi?=
 =?utf-8?B?TDhqRDdPVE5JMFMxRG83ejB4T0xUWlpxcnBJbXdoOU9NVkNqQy84Z0JOSUox?=
 =?utf-8?B?M1o0MnFoRkVWdUw5Q2Z4U2ErdWZCZkIrUUhjNVF6UzR5VGRLbVdhRmpWN2lZ?=
 =?utf-8?B?QURLdXh5eU85WjlFMjFjTm1WbmxCS216Y2xKdWJLSFNvT2RJWEdlQjNZMnZS?=
 =?utf-8?B?VmNmcUVPd0NPMmR4WGJqVFJVZi9jcnVMckR4UzFhSE5QNEVHWXN4cW14YmFU?=
 =?utf-8?B?Wm5JdVp0ak5KaWtCNnkzZFVjeHJFajNrZ2NrdEQvaUY0eThBSGpVM1AvdmNP?=
 =?utf-8?B?UGU2ZHc2Rk9CNzJDOVJmM0phcVBMSEZCWlZFUExML3FOM0U2cFZJTnl0djg0?=
 =?utf-8?B?Mmh1K0JDbEd4U0FuUm9udEhTSXUzNzQ4bkRtWmpoek55WEFWTjdNTVlLSy9M?=
 =?utf-8?B?Q0JkRGVycVpacUtDTE9qTjdKVGRoaDUxMWI4U1d0UzVNR2c2ZUV4aFZjbDg1?=
 =?utf-8?B?ZDdhMkZNOUl5WE9DNXkrWU1DRHgxNnppY09jVWVVdFhZWi9KNXB5SnZPbCti?=
 =?utf-8?B?TjI1cVFwZ0JOMEpRd0NmQ2FoQ3g4OVdDU1pyS1hNa3dOM3FqWTJaVEtqMGto?=
 =?utf-8?B?NnRCZ1c3Zjc5YUpnbmFPUGx6c0VFSUlMelNvcDBub2VKcjRCMjFtaGpna241?=
 =?utf-8?B?MU9VeVBDeTFCVGppZ2FGaXNNNnB2YlFSaHkyWWJMazBGTy93WjYxTGM5ak9M?=
 =?utf-8?B?Qnp5aHBmQ2VWMjdzUGo5NmE2Z09qZGQzc2ZZM3BFN1ZhZGpES1NzVGFTcWxU?=
 =?utf-8?B?MU96REtXWGlpZzNCdnZ2Zm9hMmNCbGVhOXh4T29sWnBFd0lONWdSUUVSNjlB?=
 =?utf-8?B?RFBKRXU2d3poTUVuUnVZZnlyZW05OE5qL2k0U2tXaFhWSm01dGViR09HVnN5?=
 =?utf-8?B?SmZneVk0QWZiSmlwOHU4bUNMbVFaaENERFRuNXNTV1Q1MGVrTFBNdENVNWpv?=
 =?utf-8?B?RDA4c25jVkRublFMTXhFbkN3SDd0b1lBOHA1VWxraGk2aE1UYjV4bGQyQ0Zs?=
 =?utf-8?B?a2psYno5dU5jWkxFczk5ejZsZ09wMlYvbnYzaDRTWHlpb0t0WTVDVXNVMVEv?=
 =?utf-8?B?alg5TEN0cFV0bzVraWJvM3lGTm5HOFd6MjBtbWpaaWtUbUg0ZnBZa0NFZlZM?=
 =?utf-8?B?d3k1RXd5S3NVd3JZNWFRbVdDZkhDUVJtenpGb05Ld1FJK3JKenNPdHd4dFdO?=
 =?utf-8?B?RlVHRXdIdEhDOUJ1WHhXVlBtWXM2MEk5d01mQjlENC9EVlgyT1ozdmpoYUxO?=
 =?utf-8?B?cjFUd09VR016L1R6KzdBU285dGtDNnM2aFE3cG1pdXVxV3g3RWR1ZFdYOFVQ?=
 =?utf-8?B?bE1Sc3E4Sy9xZVNNUnhwRXU4b3JTcytNYWpNa0dYRDFCeXJiTFdyRzhJa2ZO?=
 =?utf-8?B?Zms0NjZuUStUclZWMHBPYXdwZUtGcVRMQUZBZk81RVNaYkNJdDFjK0djL1Ex?=
 =?utf-8?B?NXJNZG8zV1RhYlVuNkhYbUlWU2p5RHE4bmRjVXJIeC92ejBDcDIzcTZCbXYx?=
 =?utf-8?B?RkN3K2N2U1Y4cjhXS2l2a0tKSmYyTXdnMmQzYU5JeXV6NWMwbVJSeCtFRVpS?=
 =?utf-8?Q?aU1DFHqYupk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1ZFRTBwUzRLdGg0T3dtYVplYlRMZGsycXdSOFBMdFBnSzZZM1JHckpSc0Fm?=
 =?utf-8?B?ZkM0VmttLzhWZ3RVN0V5MC83MTFselAzUWpXTGZpSk1mR1lZSnJzTnd1dlEr?=
 =?utf-8?B?bXlabTlRWXZ6Zkg3Yk0zK0FtZHZ0VXE3MWZQTjJuekNrdHp4eVIyc2s4YzZh?=
 =?utf-8?B?ay85U3FoNkVvNlVXRUU0elJ2OTBwNDlWNTRCdTZFWExMVEdXaVpiK0tTSlpJ?=
 =?utf-8?B?Z2F4K0NBOU94ZGNVc2lUb09UNm5mRHR3cm1MeHZnUFI0Y3dJWnNNNGZFdEtj?=
 =?utf-8?B?dWJSa2lTSVFmTFdhemVuTCtDM1V2M1lHZU1FTUcvTVdVQ3Z2aXdnamFXUTZU?=
 =?utf-8?B?MjkyMFl5YzIzc3YxcDNvYWJSR0d2STk5dGtvOVFkNFAxaGxZY3BTQ3Q1VUJm?=
 =?utf-8?B?WW5qZW01TFNjUGZNZXp4dU5GNnBaUXJhMnc1TzN3MjVJZktGUk9ZYVFIVXFZ?=
 =?utf-8?B?Qys1UW9QV1BuS0VnU0lLVk5sY2h1b2xBN2hGVllybG1pbllzTnFJSmlEaGxY?=
 =?utf-8?B?L2MwM1NkVHNCd2ozUkxkT3dHZFIvZlRMamU4YllrWFMvcStONTNROEI3TDl0?=
 =?utf-8?B?VGV6RHJHRGNhVVRWa1NCajlZbkpqaG9BWmNiTTlpeEh6QjJ5Ym5zMTlCQjdI?=
 =?utf-8?B?bGE0cCtlZTA1Z1JUMHdURjZ4YVlWTHRWQjczUnYwWHR5eU1QQlNXby9LWkJO?=
 =?utf-8?B?eHhUeVV2TnJmeWtqTTgzN3A2UGdzSHd4WVpTVzBYLzZOWldkY3VVZjE0VUYv?=
 =?utf-8?B?WmVnZGtqd253azczV01jZVVYYmFrWjNDVDd3SFJLWEdrUk1SVytxb3FkL0s2?=
 =?utf-8?B?SHM1Um5ZL1NQWXg2RklBZjZZcEFKMThjSUtFQ293eDgxcFFMejl3bmhmcmcx?=
 =?utf-8?B?OWhRVlVad0NDOXloeWdweWZYeUs1SWVSZnA1YkhqbHJnNkZwMjZEdUlBMHVw?=
 =?utf-8?B?MzBvWlc3akZDQzFneVVYOU5KWUJFcUVjalBHUFV6c2tJTitESUk0cVNVdnVs?=
 =?utf-8?B?WjI5LzdYMEordC9FOXU3TFR5MG1oV2hhVm9Kd0dpSjBiZm9Fd0FvazJMaElJ?=
 =?utf-8?B?cXVldHkzSFBBRXF0REFHQzVoUk41aUROZWx3QkdYOStoTjRIbTZITWJhUjlN?=
 =?utf-8?B?MmpRTjJIOHpZTUtHR3FvMUxXZVgvL3VjRUwxWlFISjJpMjQ4NDFaT3R4RWpk?=
 =?utf-8?B?eVlUUkhTRXJNWTRmcVN1VTBuTHlYeGg0MFdzZjRtT0taamEvbk9KbXp6ZXhJ?=
 =?utf-8?B?ZjlGQk1QVnJRSDB1UTdIc0Q4djgxNHA4dmZTMkNUTjVFY2FQaHNMdmJuMVA3?=
 =?utf-8?B?cDJNektFZFh4U2gyYmVuSzdHc2tZMVJiYUR6Zk9TWHJPZFZrdUV6K25QVkJi?=
 =?utf-8?B?SDNzVmJ3WGNpN1ZEMXZ6dXI4TWNEYnAvdHlaZlY4SGZLSmFvUHR4dEZXN1Mz?=
 =?utf-8?B?SlVKWlcyZWxKM1JyRUxVNExXUXFuSU1rM0h2dTMyZjhPRlYzZ0MwOEgyU2ZJ?=
 =?utf-8?B?SThsMGRBSTdKOXNFSDFRZkNLZWh2c3hoR2hDUHl1NFFGTXRpc0pNQ0pkckVB?=
 =?utf-8?B?MmlDNDhlUFBxb0IzZTRKTVpGMGlxcjR4QUszR0dnTWtpb2tKR3FnYVJKYjdx?=
 =?utf-8?B?bm9MdXYyN3V3YzByaDhxcmtPR2xwa2VRRXhtSlVONTMwNnNMWExzei9FUTJI?=
 =?utf-8?B?Qlh0Skt1Y3BHd1FjT3RQS1cvU1cvTmRWcXNCdnlxclVLMTJZbWcxMlhKaFB0?=
 =?utf-8?B?ZFdpYmU5c2kweS9SNlB5a0l1d2psd3FGQTBzRmpWY3JQVHFBZmZPSXkraUVI?=
 =?utf-8?B?dUFBS0IzbWd6L3FiUHBNNnE5RU5VTUduSXlvbDJjbHJRTjRZRjcrUmZTL1ZZ?=
 =?utf-8?B?ZTdEU21GY0IySzM3Sm5MWHlVeDJ3WVNic2h1QXVpdm8ycnJZcEJlQUdhdXk0?=
 =?utf-8?B?Wk5kZS9aTStFd1ZodVd5SFFSRVVDNlQ4Rk9YWVV2YlNLZ2owcjlVK0dTa0dx?=
 =?utf-8?B?bVJWaXE4N3paRDZTNEJhNTJGSEhPRFIxelJRZ3ZZM0wxUlRmbmZPdkJ6dTA0?=
 =?utf-8?B?UFpseGtNMlZNemVxMFY4cFB3aitzc05ycTRkSWlHa3d2aTlJUnRhakVYQjBy?=
 =?utf-8?Q?Z+Y9jPmxz4y1fPJ13/84RVu9x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436ca446-1656-43f8-9e49-08ddf0b49acf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 21:54:23.9777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEO4Vv6wnzM7Sl+xwEonETg9S1SYfriTtHBxpBT0kWHfEY6nWPOOgUiKRs4OZhUaWHOfmxpc4b3eOCAE4GWaKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7947
X-Rspamd-Queue-Id: A7DDC180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6swrbm4z95i1stjdrefnac33smi1p15a
X-HE-Tag: 1757541269-333591
X-HE-Meta: U2FsdGVkX1/fgpcvrz1puLAR8Pq7ambe/2zeXUaIjt4UWntS1PgMzZIxONzXy4HZiJuivOWhCI+e8GKkqQwb/jSdrMMR5SCV9ItbgBcPaUM7WzfzSQAOR1FzaKx+yc3Egr31l+fkL3SvHIekbO+FDBeaRLuAAzA0BYd2iAJF0F4TwtrYY0H3EkNNLdxFlwu9BuUkdSGLgvxub4GiAJTzPyZZuR6YE0nczNcGADBi/HKlJX/9Njk+JtYjXshxjsUNaEzRwrj/nDya7zUPs7AkkvdESOWhmxABkPlv8z1VIcWAsZyKUxTdi5RE7PXvN7X4tjd0l2A+VXqO6pg1a8U2ESxyMakcY/C1FwLAK6ok57nXMec/OFdOKgykapPHz8ZUMxsaBoK0TLKu5+a8pATecS5p/hRXJ9pwAzo9IdjYDCp1uYKk57FCGzXd18uJo20+IxAknZit3KZes2hMlKXK9Kx0EJfcaUqB82TCqj9Ed2Vq8qGIaqO8gBzp5BLMq7iRYNG+LeSdmmZRSB4GxVepGFwrGk5Yfts8D8TipFig3jsprf2tyf3Qcx3sZASCcYZaNbg2klaWsPCVcubEgR8VEPHc9DCyJlc4xs7pc3PnBHpSYdvNPxIH+WPD+zZgYki0u0fXgyczTsNVIISjb4nA40GX/tgWIv+ll4fu5/Y4w/LCGwv86IE67JtIUzqvGStXzrfRU53omcwfD4/AXSTtkBGgKHRtwZqUAQVO0mjdrfc+zkMA291D4+Iy5QVYum80otAzNB25HRFp4oeLMigRTtiUKYxr5lrA++6wzTw71DBT1+ZPNruePbZXR8IdUGiy20cOrJYjU1DwyNXEw2HoZJCeYSHQeEO7lA4TJQ1jFvXDcNXhjTSxoSL+iwEJxG3aV0xdMtBeLjR6w9UpFciIXYogK76O0xS1LtSXVW96S01YyflqXywRcGhI088PPRBBPl3ghAWMh+5B3m0ILoY
 Si4zSpkE
 1E/S0DZyY5xr5H60OWYzl7AyFGN7w+5oXsW16Bp6Tsq/6+g7s/LNIOeEJEijiksVsmSyCNnpb0y80L7F/ta3DvreSODLLMkP7bDOABOqlspRG8sFGKuwGz+Vk9eV5PX/em0GZIlZBVVh4eoCWDqH1juyT7wmTqh6KYrwOjgP5W9MAE1C4QPk5zuErMjYW22Fzmypc4/LH6GqUq1MHlZYkxVQQBLzQ8RqxmkiRP7J9yJleXkqadhINdzlhUm5trNNx//JVZ6UPHbMFyYm0DjcUdVgvEH7lHvJFVJ3vd9H49rZd4UZ14ojSXA/goxgh7wANcT1d/Am2P+iyIqVJbCUvZe/yeZqJH1xWwVj7ujYWMiryouf+ozLyOOCUNU8QBNpDLjFJyMqREQXY0griP4UgzW8rpHv2och3dhS3akfWmQcPoUn2uw9K1l5J+f0fThPwCkjZSKjZWFzV/At5vHFQ51tGXCnx/vRadD6+VJQH1wXEu17t6JTbr/ZLhG4HE7ohBQOMr3gY2WASMztZqONyKqgNMaZZSWaQ3vxdDWkFnqqAJha40giW829J+C/LsvMxvbfaDZXEhCxcThRIItlakNoViIbFRTozWuF+PVOG2AZf+/6uZ/6dzLTCOyzwfAgtaSpglqlPF9b4wLfhrjEVqumg7s37JSM1GELz7Hg7D4oej23WzfFdHxMbX72/hAKGNfgStQmf4lQErNELB+NYS5lxY7vyUYxf093P7/3MTJJ1NvaLfG3t85bnSMaVMgF51K5Z4dNqjLOzfGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 21:52, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   3a0afa6640282ff559b6f4ff432cffc3ecc2bc77
> commit: 825d533acfd9573bd1b99f08a80c42fa41fbf07d [398/411] mm/huge_memory: implement device-private THP splitting
> config: i386-randconfig-141-20250910 (https://download.01.org/0day-ci/archive/20250910/202509101756.jkC29gja-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202509101756.jkC29gja-lkp@intel.com/
> 
> smatch warnings:
> mm/huge_memory.c:3069 __split_huge_pmd_locked() error: uninitialized symbol 'write'.
> mm/huge_memory.c:3078 __split_huge_pmd_locked() error: uninitialized symbol 'young'.
> 
> vim +/write +3069 mm/huge_memory.c
> 

If the entry is not present, it is a migration or device private entry, so write is
set, I understand that smatch is complaining about it falling through the paths.

If freeze is true for a device private migration entry, young needs to be initialized
to false.

Andrew I can send out a patch to fix it or I can wait to gather more feedback
and do a v6?

Balbir



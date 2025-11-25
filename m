Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4837D10366
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 21:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45136B0005; Tue, 25 Nov 2025 16:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C216B0010; Tue, 25 Nov 2025 16:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD366B0011; Tue, 25 Nov 2025 16:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A281C6B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:48:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 299B91408A4
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:48:09 +0000 (UTC)
X-FDA: 84150467898.26.E9FDD45
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 662FA80009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:48:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pedUnfvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SiPHGXNS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764107285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQIH7AnNqKCzJZy/bl1dtGjlWOA46hFyv7V1upl1bYc=;
	b=vYnjOMr2OtvkI8vBn8+ehmPpOg9pWNqZUZdGWql+gu6COKjY889w31T19Hakf7Yx2/fixg
	q+OhIXEvs5Ywkn8dFE6TNzRbniEPxeTRSOY3EGh2Qu8dvYv/2g0KxvSOB+c8k7IDxp+i9F
	p57SoXKdXz+wsxF0YqWXVxMwMLxDFsY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764107285; a=rsa-sha256;
	cv=pass;
	b=L2TL/j58TfuJ9VZMywe9CsMlk19nwcr6ozXqYjfwVKMOpoSPFsRdHw9vHXW+/IWJ1NSruu
	ysocZhzys51IE+ErGoU7JRbGXWf/K/g8YVAePCau1b5Gvf9sf5WLoREykUfPEGYvUwDnf5
	YeNBXmn37uJWlNAt7cdzKYgKz8enlms=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pedUnfvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SiPHGXNS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APLKcpX4007331;
	Tue, 25 Nov 2025 21:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LQIH7AnNqKCzJZy/bl
	1dtGjlWOA46hFyv7V1upl1bYc=; b=pedUnfvkiG4iEMCKqRj99UfanRueN7osJb
	a95uMELyOrMWErDIjvxRjBq9baqjQ+nAXmmi9bq36P6ozk0KQ90QE0vOMS921aer
	5qd/SL19oewLLrLC9mkp9mm/CIJAM0OfZDEqKusss4r7IA4YwN1le7u63Gw6H1RW
	SH/DT0zM94NhdIfbd9sjK4Un/g8dsybXyspVi1tQGbi84plIPEv+Q/b2RxCgJVCp
	OS+80Xu+SN7Kf7LCjCeTPiJRM/6bGmuhFYvryS8glKl0WOOh8MWGkBfj/4AGlfCj
	VkvxY+Rv/TUU9TrN1Eg8fKZAZc3OZk0psXn7cSkuOZkSqmfg7Hbg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fkggn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 21:47:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5APLUBn9023147;
	Tue, 25 Nov 2025 21:47:15 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mm5x08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 21:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/14DnYooaPM0y9WjYrSVKoIbdpUKbh6ilbM+NwAysmsNy/Bp05HL9KJkzCE6cEmBg18N7HTFarUbxycNw9LhsBxo+CgCWp2e0fH2B3Y9p1G9nIQlAPWQu0gWUYcZmm7yBLkYokgzw37MXJlQlvsnTyUf4HXjr59uccBuZR5oZ5/Qb1DO5D8dSZSclylrMhAp2+CksZDCrW9n6BuFgB/OnYciR7+FnZIZibnIga9D5NxkhKwGwFaOuSBaC/07IAvtlPa1xhwEV8VZXiBROmoe6rZCFOzLcFxJwH0F/afh82uRC3wXNuA5tp2cSWJO1eWg4s+QiTG2/VAoIkpteDH5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQIH7AnNqKCzJZy/bl1dtGjlWOA46hFyv7V1upl1bYc=;
 b=NC6OKOqF2J9Y3p72cS0Tg5FAV7+UuAMn5XbUPE79kP6laSK4LCDCFWxa7sRlZdmpZrranAlk64zkA1n8E5YJysqjDCmVGnC3UrCLzCbGtTo2zIhQgI3kXSfVcfwM9FCvj6VQ62BTfm60NZ/7kCeEcZMI74F+7BSfFcdZECUlhk0ekK9q69J+pr4MxCT76hAhXR0tqIj3UGYoJBde6jEEuPJcHwBiMax1hhWEl/KZoo6oiz3/apWmTY4pPVMAL3i42lWnFTsmWuU+4q5A27oPW8eaZOfMcoSO8khkAB0gatPlCz9yU+KQF6hkYsmBU/K1bC6cCKn5fKT76Qfwm/NomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQIH7AnNqKCzJZy/bl1dtGjlWOA46hFyv7V1upl1bYc=;
 b=SiPHGXNSHervtRsm5VxsKMVgfYxgrwzJaafBIFxhiPQOEdQo81ZFiDT1yOFHkL1T36lSqNo4X/4XR/PVpKSYmnzl3CuPgjx7dRGmE8NWYbsrdCAbLVyN50Q8XJEt0xNG9ey8ukpNvM3bqDGoQi1nWYKh44+HbAJ7BBJmxcwpnX4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7282.namprd10.prod.outlook.com (2603:10b6:610:12c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 21:47:11 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 21:47:11 +0000
Content-Type: multipart/alternative;
 boundary="------------E2FdWEJrG4s8bPT0zDD2C068"
Message-ID: <2230909f-b36d-43f6-a0cf-e4365b10b830@oracle.com>
Date: Tue, 25 Nov 2025 22:47:05 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v2 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
        linmiaohe@huawei.com, harry.yoo@oracle.com
Cc: tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
        jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com,
        sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com,
        dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20251116013223.1557158-1-jiaqiyan@google.com>
 <20251116013223.1557158-2-jiaqiyan@google.com>
Content-Language: en-US, fr
In-Reply-To: <20251116013223.1557158-2-jiaqiyan@google.com>
X-ClientProxiedBy: LO2P265CA0098.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: 23dcb548-980a-4814-8e12-08de2c6c2fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|8096899003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUsyKzRSbXRaYmg5OGVraEREeHFrQzdFMUppZEpaci90SWNqRlhxNUFrclAr?=
 =?utf-8?B?YXNBUG5veHhyclRPRHg0dHZjSVhWdVBSR3NDZFhDYmV6ZERuNVQ2dDlSUTRz?=
 =?utf-8?B?VGthR01RY1lMRGl0V2daTllTRnZyWXlHK2R4MkRpQUFBYmVqSnNDenpiSWZI?=
 =?utf-8?B?ZGRFMHRjZzQ4QURmYjRJNHMreG12NElBSjFYdDRUTlpNNUlJK1hqNHBWL0Yx?=
 =?utf-8?B?MGNPdWtjeko0RDZhMkZLMkowTUFtbjloek1UUmp0bzBib3p3YTVlSnBRK0JD?=
 =?utf-8?B?MkVvb1Z4bEc1d3YyOFBOckg5cmVqNEl5N2lHSm5PN3VWTGFBcEt5c3ZJVnZz?=
 =?utf-8?B?dFNsVk1sU0VXaU53all0VGh3R3lmaE44WEIxanpvWFZTVXJZRDhPMTJQc2to?=
 =?utf-8?B?V1JPVlpOWktoVFA3eDdHM2tBeWJvN0x0WEZUdjdrNnZMV0gzZFhjOXd2OXVs?=
 =?utf-8?B?TlZBcHlZMlZsbFpEVm9qbHI3SEY5aDU3Tm1PdDRkaklNWTc3VTVFcmI1R1Er?=
 =?utf-8?B?VlppUGlVZG4xakFWOWcwMzFjZVdrNHNNVEFrMkRDQWg5WXRsb2ZPZHZGVENI?=
 =?utf-8?B?aW1JcGwyc2ppMXl4VmxXL3ZVSUI2UWFkamlUSmFCSUtBYTZTWG1rS094dzZx?=
 =?utf-8?B?SHNXQnhOTTM4TXE2a2grZEtjbzh1a2U3TjBtY2F1ZXJzYmNWdEhlaWNnMU96?=
 =?utf-8?B?QS9VblBOeGpGdFdEdk80ZkluaVVjY28zNm0ySThJUTlwam1sbHVXMjZrRkZ2?=
 =?utf-8?B?VGxSdm1iZ3Zzd0JyZ3NCYWM5cEhWaU5mMWN4MzRncmxEUTFhQzZGaHhhSHU0?=
 =?utf-8?B?dHo5WWZBeUVuVFZuMFhrWit0TU9ISDNvYklNRlZFbUdJaVJoR3ovV2ZPRmJj?=
 =?utf-8?B?VFIrYzFlZ2FBWlZZTEhQNTEwYytPZWdhMzNsRkQ1REFYbGFFS1BHbHZzYlpv?=
 =?utf-8?B?ODBqS0F5aEJRSWZwM1dWWDFxUnBaVjMrc2NmM2NEd3pGWjFqem5lVzBRUkhk?=
 =?utf-8?B?NEsyNFJUS1NYS3IyNjFhWWttWWJON2x1K1lwKy9jUGRPS2xVczFZQ1RhT001?=
 =?utf-8?B?dXFXcEhWOGI1SnE1OUlHSVo2Q0ErZXhtb1ZYd2l1UEwxUkZBUkkvUUkyRitR?=
 =?utf-8?B?MXYrbmg3cDhXeFVlRHkzM1FIUmVGZHdid0I1YjBzUWZzcC81SW9Fbi9nSlJQ?=
 =?utf-8?B?d1VVcUZRdE1GUktoKzMxZmxoSTNzL2RXUTE1cHVQTkJXWFl5QUVKb01KNENm?=
 =?utf-8?B?NWQzdUN6WngwRXQ0WFNYREg4MDV5NitFYzdaTW9RTnJMRVFPV0tiSndIMUpm?=
 =?utf-8?B?TXMvSjFmNHlRVWllbUFhU3ZuL3Q2eFBCUUlZQnptL3R3QjBjMGsrcEpwb2Qv?=
 =?utf-8?B?cTFoaTB0SU9TcTJkMm5PdUdEWXRZNUZ1SGNEcTJOOGNya2UrRmFvY0VsL2Jp?=
 =?utf-8?B?clJsOGZ5RHZVTHFjeEI3UTE1RFlPM05UK2VRRHFUOHhmZFN4cHZibWJpT3lq?=
 =?utf-8?B?d0hhOU8xeldRT0MzeEV2QmsrUEVrc0V1UmFUT2N3R3dEdXNYQUZTUDc3VXJn?=
 =?utf-8?B?dllkUzU1Ukxndy9yV1JEZFFEemJONlhnREw0N0RxeXU3d1ZtcFozaE5iZU1K?=
 =?utf-8?B?eFZRNlZleWUyMUdxZlFIc0JRU0VMVlJUTUxkeTYzSXhobDFFZ3Y2QmRnK0ln?=
 =?utf-8?B?YkRGbFNIR0RpdFIyTXQzaUlkdjdvczFqU2IrNk5yQ3VFQVJHUmdrNU85a0RJ?=
 =?utf-8?B?UGx4dWduakxtRi80c1VSLzR3YnA2UFdXT3FJdnFFODM0TEg3aWZ4cHZPWHc3?=
 =?utf-8?B?QjdLZFlJNVNHcUpvQ2Ztck9VOW1qWWx3YytCWmlzSmJLREpYUUUxemNaQlZB?=
 =?utf-8?B?bmM3N3prNWc4cjY2bTl3eWdTWW1LOTNXTFU2S05ZOFZLcWZxWGExQkdSQ1Z5?=
 =?utf-8?Q?Up6EMcrDsWAlnoAGequnIwU8/P4OuUbE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjVuZU1FNjlsR0JLTFRYTWZTejVVWVRDRVpLdGpieTBZMnFsaStjRzQ5ZWlF?=
 =?utf-8?B?VExzT0diZmpOMmxLTUIyandRUUJ1K0RjckJoREtOYkNTUCtpU3RkQVlVbEww?=
 =?utf-8?B?R0RKMUMrVFdkNlFuMk91Mml0TEpGOXR0amtHV2U4cjU0a0ZtenVhUmd1N0kx?=
 =?utf-8?B?dFhQVWtwK1RxNUF5cFBVMzgzUzJyTjRuek5TU1lqbytKQjYzNUlUUXV1K3Q2?=
 =?utf-8?B?YVZBUEMvTVhCdUtZOTcvNlNFYzU0WjFpSitNMHpxek4yWUtiVWxHRllRYTU1?=
 =?utf-8?B?QlcybDNjdnJOZTlyN01lS2E4bERSWHJWbDF5RnpiRk95clB6UGY2TTVzYkJz?=
 =?utf-8?B?ZHJwNUgzelQ4UktsK2dKVFA1ZTFDR09UQjMvYmJsVlR4aGgvVmw0TlQ5ektH?=
 =?utf-8?B?SjdXRE9Sb0NFVUNvSDNzWXZDc0xPQWRXTEFlZHB5WTF1TFIvV3VsL0tPTk1T?=
 =?utf-8?B?UHpZUkV0RGluUm13TUdjVVhoQlBzY1JrZXp0SDMwd1FvdXl1OVBPd1p2SDE4?=
 =?utf-8?B?T0dPWERWc0F4QWFSOTlmb2U2RGZObThsUFU0dlFIaWxnQXVnOG1GaG5FV1JN?=
 =?utf-8?B?Q0l0c1dYcG9odkFCbkxFd2NUMVgvRXNKbUhXK3hiVFNmQ0laZ3NxaExYQUxk?=
 =?utf-8?B?ZklWMmg4OHQxd3MvMjhtelIveFJaTXZSbmUzSmZMcy9rQjNybWxBQWhncnA3?=
 =?utf-8?B?cHRRRUNiUGNrTFlMYXlGS1ZueDJidU0vREhuUklKTHpBZnBhNnJSR0pWRVNX?=
 =?utf-8?B?UkkvNzYxOVFveWJkOE5kU2JVdDhCUDlUaGRhMWdOM2U2bjV4Slk0amxXUGsw?=
 =?utf-8?B?bkNYNW9lenVRNEMwYUZpcnhkbVk3d3V6MTZaZTd0RFB4WElxMFBQeHdKd0xo?=
 =?utf-8?B?MmNOb1Y5WldTZVBFQ2ZHZ2M1SVZHU29aNVdOS09PN2d4b3R2Q3lnTnJYVjFM?=
 =?utf-8?B?aGZrRk1HV21mR0ZHMGNsL3dPSHZJNlF1Y05jcU5VcXcveHhFR1IwT1l6MXZX?=
 =?utf-8?B?M0tQS0dDRUhnV1NUUVpHNlJaU2pZSW4vb0JIQ1VCTGRNakFENTBvblJsY01J?=
 =?utf-8?B?THg0bGtUc1BrVitPQUJVNkJzckdzM0ExK2F3Tk5lUkdwcGRFWk1DdVhPT0Ux?=
 =?utf-8?B?U0R4YllhQk5YVFlRZnB1RFk2WmpORlllK1Y4UWE3cDhvdmpjWHlqWWYrS1M5?=
 =?utf-8?B?b0hNNE5IZ2lEcjRpUFE2Qis3UmkrWEYvZWNMeWsyTXFjWTRoYjNrcU4wNzdG?=
 =?utf-8?B?Y2s4WXdBWlkrY0hDc004Rkl2Nm1TZ0h3MEg1bEhDOXFIbXlvRWhnQU92bFUv?=
 =?utf-8?B?a1A5WHlya2Qwdy9RYk0wMVNxYkFDQlU0TnA3UGlvYmxLWExPRURVeDhjODJ0?=
 =?utf-8?B?Yy9rUGtETno4SGJQVXEvcGM3NG9iMGZJYVlqYWNlT1kyWGlnUUp5VkoySVhU?=
 =?utf-8?B?QWQwdm5XSUpaVTRKbjdCTmZuZ0piSmY1cFZScjAzUSt2Y0t3eUtYUzluSjVl?=
 =?utf-8?B?NzdtWnU2bVQyaEFXb0VRWUFTS01DRkF5dldvK0NOS1UyZU1oVmE3ajdrSXVl?=
 =?utf-8?B?ME9zWTA4bjlTQ1JXclM0a0lEWDA4UGRvMTNFeXl3NkplRDhrTys2TW1WdTBM?=
 =?utf-8?B?MTY3eWU5QVNzczFDUUptVWMvdElZOUt4TXh0aVZUK3Nrc014Vkhma0t5RXFN?=
 =?utf-8?B?MFQwcTBPOWVIZW5kMmV3NXBWZjdJRzlQbmw5Uzg4MUh1dzVvOExFcjYxeGlh?=
 =?utf-8?B?ZGxUNUpqZjRaRmdpdzV5U0pLMnYyaXJySDQyUmVNWjFuZkVOV29kY2phUDA3?=
 =?utf-8?B?djBOZG9XY21CTkdoOHVEb05Cbk9mRURObkdzOTlxYUI2SnNxbHA5SFJ6OTNv?=
 =?utf-8?B?RXh5KzJHNFNFTDhvdmw5L0NUaG5DdHlFWjc0TWVQcUs0VjJCbkMwZzdTUkZX?=
 =?utf-8?B?YndsWjFnZGhCSWNUb2p1aGdzbWFrRkkxQ0pmWDR5S3lvY1pVcUlDMDQrdVov?=
 =?utf-8?B?QjQxczVzSkZGT2wwNVVoU09mZjJ1eDJSSkdGbGdzRk1qVzl4S3lHRWZHU0Y4?=
 =?utf-8?B?Q2NHd2Z0RkJQeU5vallUWGIzQjJqMkRsNEp4ODFNa3h1dzh4OGl2RXpWbHVL?=
 =?utf-8?B?V0VCNGJxSzN3YjNmOFpiTE40VGpsOFVkVkRyOW0zUjFBeHhYK2E1eEJIazly?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SKr01YCqRaML16u0NSRg0/8D0nRa2wyFMQUOSAOH1ZY4pqvr65pKHVI2NuuuFVUdM+b/umQ+sJyGPf/nRlYOhD638Hl01cuJk5e8NgyJd70ZiOPojua1R4RQfkHNBsVqZ1wvn6dTUY1W1t/BjkHtSAVBGbTBuAiqAIdKNlLZ58UCuqsx7FuG6E17tRgaL0cdj7BU1P5JyKTfX3d27Ca2qJ8JJd9JZc4J0VfkU9wuNaSw7p2hlpCtQ/EY3jIhxEbUQWG+eA21MrohWncO9tQIujIspq/jtZYHxyV/PTlvzMdT/EIT06ndgH7bqKSbVIbwmNPnD7AXBxo3ElZo+TObwcX0QI6Elpy7kOofs4/rebwRTe+3AHa/qb3NVEvB9BWFcMMZDb8etF07zDCnmaQf7178EchjJpBTiyMjQhHsvM9q4iJmGQoDWL8/CXJdyH1MuRsiuVIC3XrkQ7vUUKjqmXmHaQ6e8c4+jouIUV7bLenUlucuoe1Qa16PybpFhJxJqYRRkBydwHc8Ked+V+R3Qg/XrHcxOaxHWOtWmrBN9BFHAFXkMhcxxM0i56sTgYZRpxNpt9SPtR03oU39np94nLXyOTgIJPNwR9Whga1xDtY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dcb548-980a-4814-8e12-08de2c6c2fe3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 21:47:10.8438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sW7pbV3gFiZPjQVLZj+3eepmYGUpZZDHw3qqN0YYTmDXL02bMT8Ry0O1tDkJNs09K1QWbS04ySj+V+QRxk+T4eMapiTPFADAa5Ws2zFSEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7282
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511250181
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=692623e5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Qvi3HOdRTzR8wQmjmQsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1XWaLZrsAAAA:8 a=qyOo4QBYaRfHE1Ld5TMA:9
 a=-TBpYD-CBqXjKW1i:21 a=_W_S_7VecoQA:10 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE4MSBTYWx0ZWRfX6KsZfBpZETgM
 hPe1lSjv/XFtQtwa9641RdrDHO9OjkOH6gNYEXNB4az6LgIadcgJb308RdZswnjXgjIlaLBKRhw
 vAfGD8uMV4neyLNhdGPj/VuTFRmzg5/pqbRCZ+q65MTeIoUfAh8vnqvNPzHY5qgblLiGwaEA0nm
 8AUSHmhkqP85er6uOo7J/1HZ1w19+5OdAas2nxSqwBej/X4sGPJr8BEOJap0zEKrupbUtFt6xS6
 IZqCBUIeQ4/l2FEIoRmukvcQDzDuc2od+0ubLoG0B1/9fSSI2iv87ylhOTQQvPnv3pOx42loXMz
 x5uHQdxBYukowlC7Y/sR/Xlrx/C2E9UIykwmTQlmHPhfx8vYEeEyYiFBfRRLw/hQJeiLdC+rbPs
 qxrQ6ZWKOt7WhSeUC/sD8GCLqvzsYnAvo90yBgeIWbdt/N/7dDM=
X-Proofpoint-ORIG-GUID: Dokjg9BRulTuVtMvM-W3zrhSmJCK4UE5
X-Proofpoint-GUID: Dokjg9BRulTuVtMvM-W3zrhSmJCK4UE5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 662FA80009
X-Stat-Signature: wg96x7fqksd7xnyt3niad65ohkwo96gd
X-Rspam-User: 
X-HE-Tag: 1764107285-307002
X-HE-Meta: U2FsdGVkX1+gpXqbFdpKzFG4TxwPGBVF9Qpxzd2Se7hg/t2bzrjkC65GrS1p9wS9DIchJKlwkVGnW85BD+toMPRtCQjWNyGWmk2Vv2Mj1s03H0MCm1rCOolqSflJ3LMpMIo8qrpqFr8Z0iJJ2y29cfMHXpQlkmWAsQfN8vEnhUlQMmOj0MMmfWGG0geURD74svIYIiZQKQoHIKArLeC1TsBpiciX3ToBmrEqVVZua3rGLa6trJjQsbvMbCzHYMotHK6aeEBr1Y4h+NIxozVMQHM4tv9raXXECdk4cmmrvjyG9OBfwdgrT10EulhWPqjiM4YlLOg7VAt1OuOGqoNh/LdkZ1TV+swMfo2DgZRppWXNLPL+V+006g4tLfkdC0pnekDcxt38FHEApY/mtl2rLDCnxc4v3r/CnUzDAs3XaVMppmA5UGl59m6ZREnujTiNRjAGAgzf9NQr0q38Bt/mYQlkAI6LNQ0QQK4etAVcsVxt1iU0sqJOMKk5duEJf+zwR/n2ju9omEd39WiTiLTAhW/ijJvv9Kk9W4eIEJOoQ85BuAe4+Y6Qb+cR1kYvRSFpNsUri1CcsDpNkQoJ/EBhO704B+tbkftF6fvZAwGsgmqjeB3Wm+CMV7N0heKCID0aCcUQFVvU5z38wvCW7JuOadGl2GBNgpMir7T8WGrNCN/reSEl9JGb1LzKL8Uzvvx1ckYDGNPmkzARTrTQPk4BKk7bWrqi4IHtdeeEuwUxreM+30i56xwxZg4qkPZPNz17kP+TKKaCXYs+lgvDW6xqc4X/vRWU/1LDTCgDnqmVEv22poPRA1aE7DVxz5B1bNAq3b9VgwX8YypmR85SCtUsgI7Dj52lqyfAuJBMm3WIFfChW7HaImdo++M4/jRiTNpNOYeICQCfXwjub8jVmBVZBsjtnjMjw0pGy91Lc49JM9v4AFMNfrMXxQm2XEnvSkXniqSCm91iKyxxrFtQBci
 ru+egPLM
 XvvHwIW28cpQOpoqH51Tx5+1SYuWmiEVdLeVOCS2g0JDaQebo4zKW6Iv0CmQoquKHRfR/7usbJeR18OIUSUdi7Yz3uUPsxmriXWZbbjoam/3jPXLd+1OEvicRGUcAw/NJKjHqpjwk8icVOr9RwT7j4gGlKpH6wv3V4SyhAcIn0tfrci9DMnBkRWGFbvHG4drOIhmH89e7MTAyIp6OXiRxWAEeRXc79lIxGee+VlBnpXdkkaTEaLOvh68jy4hsrK5JFzz2RqM4x85MScdl0t7Ca719sorKoztnQIg/lA60IwqnVdMR5C8IkxXWeybuIaC7e5htDnyjbiUP2GrlNsQ/VgnqgdGXLrLjBg+UDEKwrIcrKZD5dVi8nJZecMWdV4xs2vxxRYlQQz29U7vo1z81/dS/tQOml6HSY53Pcgwq1D91TrGDdr6iZA7UsNYdognEVvECYQ0oaWg5eqgX0Trf05x09/QwpSb5Fun4RtY2qMlB+Ogzi4dugc+SPsNkWGsAzY12Ujm1aCiPjTgBYbULf0+p+uceSNiGEN7RO6/akRjO+SHd5clBqOtnM/wHGmvcMkyzhlkqR0Zc6svZ2GLFnD6vs+bdaUrmfZoQmrFRAe1tFLaLtkiMJZctoVWB2V6oODAX8QKO0/8tliutxpljUrvcQnI6rXk1cixqXll48bjefLjxHqyNH86f76ypoelhtOQ0CD7Z/DMueumhJQeA4xXLJzfWsQd6/Cg48IXvVIAW15yuNBnF7qcK63cujKwTMXXsiuxSjadmtdw2G3sL8LxfUVwLuw3VSZIBfPi7lV2TCApyiXSfaVD5ec4Jg8B7UcYVtrMGcEABaIiY2qQVI7PDbndCn79jHBhYVxD9fRk0/oxJArcPct6+VzZbZ2kYL14VQ2HnNKMNnRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------E2FdWEJrG4s8bPT0zDD2C068
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Jiaqi,

Here is a summary of a few nits in this code:

  - Some functions declarations are problematic according to me
  - The parameter testing to activate the feature looks incorrect
  - The function signature change is probably not necessary
  - Maybe we should wait for an agreement on your other proposal:
[PATCH v1 0/2] Only free healthy pages in high-order HWPoison folio

The last item is not a nit, but as your above proposal may require to 
keep all data of a
hugetlb folio to recycle it correctly (especially the list of poisoned 
sub-pages), and
to avoid the race condition with returning poisoned pages to the 
freelist right before
removing them; you may need to change some aspects of this current code.


On 11/16/25 02:32, Jiaqi Yan wrote:

> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 8e63e46b8e1f0..b7733ef5ee917 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -871,10 +871,17 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn,
>   
>   #ifdef CONFIG_MEMORY_FAILURE
>   extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
> +extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
> +						struct address_space *mapping);
>   #else
>   static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
>   {
>   }
> +static inline bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio
> +						       struct address_space *mapping)
> +{
> +	return false;
> +}
>   #endif
>   
You are conditionally declaring this 
hugetlb_should_keep_hwpoison_mapped() function and implementing it into 
mm/hugetlb.c, but this file can be compiled in both cases 
(CONFIG_MEMORY_FAILURE enabled or not) So you either need to have a 
single consistent declaration with the implementation and use something 
like that:

bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio, struct 
address_space *mapping) { +#ifdef CONFIG_MEMORY_FAILURE if 
(WARN_ON_ONCE(!folio_test_hugetlb(folio))) return false; @@ -6087,6 
+6088,9 @@ bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio, 
return false; return mapping_mf_keep_ue_mapped(mapping); +#else + return 
false; +#endif }

Or keep your double declaration and hide the implementation when 
CONFIG_MEMORY_FAILURE is enabled:

+#ifdef CONFIG_MEMORY_FAILURE bool 
hugetlb_should_keep_hwpoison_mapped(struct folio *folio, struct 
address_space *mapping) { if (WARN_ON_ONCE(!folio_test_hugetlb(folio))) 
return false; @@ -6087,6 +6088,9 @@ bool 
hugetlb_should_keep_hwpoison_mapped(struct folio *folio, return false; 
return mapping_mf_keep_ue_mapped(mapping); } +#endif

>   #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 09b581c1d878d..9ad511aacde7c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -213,6 +213,8 @@ enum mapping_flags {
>   	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>   	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>   				   account usage to user cgroups */
> +	/* For MFD_MF_KEEP_UE_MAPPED. */
> +	AS_MF_KEEP_UE_MAPPED = 11,
>   	/* Bits 16-25 are used for FOLIO_ORDER */
>   	AS_FOLIO_ORDER_BITS = 5,
>   	AS_FOLIO_ORDER_MIN = 16,
> @@ -348,6 +350,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>   	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>   }
>   
> +static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
> +{
> +	return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +
> +static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
> +{
> +	set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +
>   static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>   {
>   	return mapping->gfp_mask;
> @@ -1274,6 +1286,18 @@ void replace_page_cache_folio(struct folio *old, struct folio *new);
>   void delete_from_page_cache_batch(struct address_space *mapping,
>   				  struct folio_batch *fbatch);
>   bool filemap_release_folio(struct folio *folio, gfp_t gfp);
> +#ifdef CONFIG_MEMORY_FAILURE
> +/*
> + * Provided by memory failure to offline HWPoison-ed folio managed by memfd.
> + */
> +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> +				    struct folio *folio);
> +#else
> +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> +				    struct folio *folio)
> +{
> +}
> +#endif
>   loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
>   		int whence);

This filemap_offline_hwpoison_folio() declaration also is problematic in 
the case without CONFIG_MEMORY_FAILURE, as we implement a public 
function filemap_offline_hwpoison_folio() in all the files including 
this "pagemap.h" header.

This coud be solved using "static inline" in this second case.

> diff --git a/mm/memfd.c b/mm/memfd.c
> index 1d109c1acf211..bfdde4cf90500 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -313,7 +313,8 @@ long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
>   #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
>   #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
>   
> -#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
> +#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | \
> +		       MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED)
>   
>   static int check_sysctl_memfd_noexec(unsigned int *flags)
>   {
> @@ -387,6 +388,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
>   	if (!(flags & MFD_HUGETLB)) {
>   		if (flags & ~MFD_ALL_FLAGS)
>   			return -EINVAL;
> +		if (flags & MFD_MF_KEEP_UE_MAPPED)
> +			return -EINVAL;
>   	} else {
>   		/* Allow huge page size encoding in flags. */
>   		if (flags & ~(MFD_ALL_FLAGS |
> @@ -447,6 +450,16 @@ static struct file *alloc_file(const char *name, unsigned int flags)
>   	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
>   	file->f_flags |= O_LARGEFILE;
>   
> +	/*
> +	 * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create; no API
> +	 * to update it once memfd is created. MFD_MF_KEEP_UE_MAPPED is not
> +	 * seal-able.
> +	 *
> +	 * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
> +	 */
> +	if (flags & (MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED))
> +		mapping_set_mf_keep_ue_mapped(file->f_mapping);

The flags value that we need to have in order to set the "keep" value on 
the address space
is MFD_MF_KEEP_UE_MAPPED alone, as we already verified that the value is 
only given combined to MFD_HUGETLB. This is a nit identified by Harry 
Yoo during our internal conversations. Thanks Harry !

> +
>   	if (flags & MFD_NOEXEC_SEAL) {
>   		struct inode *inode = file_inode(file);
>   
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3edebb0cda30b..c5e3e28872797 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -373,11 +373,13 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
>    * Schedule a process for later kill.
>    * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
>    */
> -static void __add_to_kill(struct task_struct *tsk, const struct page *p,
> +static void __add_to_kill(struct task_struct *tsk, struct page *p,
>   			  struct vm_area_struct *vma, struct list_head *to_kill,
>   			  unsigned long addr)

Is there any reason to remove the "const" on the page structure in the 
signature ?
It looks like you only do that for the new call to page_folio(p), but we 
don't touch the page

>   {
>   	struct to_kill *tk;
> +	struct folio *folio;
You could use a "const" struct folio *folio too.
> +	struct address_space *mapping;
>   
>   	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
>   	if (!tk) {
> @@ -388,8 +390,19 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
>   	tk->addr = addr;
>   	if (is_zone_device_page(p))
>   		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> -	else
> -		tk->size_shift = folio_shift(page_folio(p));
> +	else {
> +		folio = page_folio(p);

Now with both folio and p being "const", the code should work.


> +		mapping = folio_mapping(folio);
> +		if (mapping && mapping_mf_keep_ue_mapped(mapping))
> +			/*
> +			 * Let userspace know the radius of HWPoison is
> +			 * the size of raw page; accessing other pages
> +			 * inside the folio is still ok.
> +			 */
> +			tk->size_shift = PAGE_SHIFT;
> +		else
> +			tk->size_shift = folio_shift(folio);
> +	}
>   
>   	/*
>   	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
> @@ -414,7 +427,7 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
>   	list_add_tail(&tk->nd, to_kill);
>   }
>   
> -static void add_to_kill_anon_file(struct task_struct *tsk, const struct page *p,
> +static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
No need to change the signature here too (otherwise you would have 
missed both functions
add_to_kill_fsdax() and add_to_kill_ksm().

>   		struct vm_area_struct *vma, struct list_head *to_kill,
>   		unsigned long addr)
>   {
> @@ -535,7 +548,7 @@ struct task_struct *task_early_kill(struct task_struct *tsk, int force_early)
>    * Collect processes when the error hit an anonymous page.
>    */
>   static void collect_procs_anon(const struct folio *folio,
> -		const struct page *page, struct list_head *to_kill,
> +		struct page *page, struct list_head *to_kill,

No need to change


>   		int force_early)
>   {
>   	struct task_struct *tsk;
> @@ -573,7 +586,7 @@ static void collect_procs_anon(const struct folio *folio,
>    * Collect processes when the error hit a file mapped page.
>    */
>   static void collect_procs_file(const struct folio *folio,
> -		const struct page *page, struct list_head *to_kill,
> +		struct page *page, struct list_head *to_kill,
>   		int force_early)
No need to change

>   {
>   	struct vm_area_struct *vma;
> @@ -655,7 +668,7 @@ static void collect_procs_fsdax(const struct page *page,
>   /*
>    * Collect the processes who have the corrupted page mapped to kill.
>    */
> -static void collect_procs(const struct folio *folio, const struct page *page,
> +static void collect_procs(const struct folio *folio, struct page *page,

No need to change

>   		struct list_head *tokill, int force_early)
>   {
>   	if (!folio->mapping)
> @@ -1173,6 +1186,13 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>   		}
>   	}
>   
> +	/*
> +	 * MF still needs to holds a refcount for the deferred actions in
> +	 * filemap_offline_hwpoison_folio.
> +	 */
> +	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> +		return res;
> +
>   	if (has_extra_refcount(ps, p, extra_pins))
>   		res = MF_FAILED;
>   
> @@ -1569,6 +1589,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>   {
>   	LIST_HEAD(tokill);
>   	bool unmap_success;
> +	bool keep_mapped;
>   	int forcekill;
>   	bool mlocked = folio_test_mlocked(folio);
>   
> @@ -1596,8 +1617,12 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>   	 */
>   	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
>   
> -	unmap_success = !unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
> -	if (!unmap_success)
> +	keep_mapped = hugetlb_should_keep_hwpoison_mapped(folio, folio->mapping);
> +	if (!keep_mapped)
> +		unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
> +
> +	unmap_success = !folio_mapped(folio);
> +	if (!keep_mapped && !unmap_success)
>   		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
>   		       pfn, folio_mapcount(folio));
>   
> @@ -1622,7 +1647,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>   		    !unmap_success;
>   	kill_procs(&tokill, forcekill, pfn, flags);
>   
> -	return unmap_success;
> +	return unmap_success || keep_mapped;
>   }
>   
>   static int identify_page_state(unsigned long pfn, struct page *p,
> @@ -1862,6 +1887,13 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>   	unsigned long count = 0;
>   
>   	head = llist_del_all(raw_hwp_list_head(folio));
> +	/*
> +	 * If filemap_offline_hwpoison_folio_hugetlb is handling this folio,
> +	 * it has already taken off the head of the llist.
> +	 */
> +	if (head == NULL)
> +		return 0;
> +

This may not be necessary depending on how we recycle hugetlb pages -- 
see below too.


>   	llist_for_each_entry_safe(p, next, head, node) {
>   		if (move_flag)
>   			SetPageHWPoison(p->page);
> @@ -1878,7 +1910,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>   	struct llist_head *head;
>   	struct raw_hwp_page *raw_hwp;
>   	struct raw_hwp_page *p;
> -	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
> +	struct address_space *mapping = folio->mapping;
> +	bool has_hwpoison = folio_test_set_hwpoison(folio);
>   
>   	/*
>   	 * Once the hwpoison hugepage has lost reliable raw error info,
> @@ -1897,8 +1930,15 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>   	if (raw_hwp) {
>   		raw_hwp->page = page;
>   		llist_add(&raw_hwp->node, head);
> +		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> +			/*
> +			 * A new raw HWPoison page. Don't return HWPOISON.
> +			 * Error event will be counted in action_result().
> +			 */
> +			return 0;
> +
>   		/* the first error event will be counted in action_result(). */
> -		if (ret)
> +		if (has_hwpoison)
>   			num_poisoned_pages_inc(page_to_pfn(page));
>   	} else {
>   		/*
> @@ -1913,7 +1953,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>   		 */
>   		__folio_free_raw_hwp(folio, false);
>   	}
> -	return ret;
> +
> +	return has_hwpoison ? -EHWPOISON : 0;
>   }
>   
>   static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
> @@ -2002,6 +2043,63 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   	return ret;
>   }
>   
> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
> +{
> +	int ret;
> +	struct llist_node *head;
> +	struct raw_hwp_page *curr, *next;
> +	struct page *page;
> +	unsigned long pfn;
> +
> +	/*
> +	 * Since folio is still in the folio_batch, drop the refcount
> +	 * elevated by filemap_get_folios.
> +	 */
> +	folio_put_refs(folio, 1);
> +	head = llist_del_all(raw_hwp_list_head(folio));
According to me we should wait until your other patch set is approved to 
decide if the folio raw_hwp_list
has to be removed from the folio or if is should be left there so that 
the recycling of this huge page
works correctly...


> +
> +	/*
> +	 * Release refcounts held by try_memory_failure_hugetlb, one per
> +	 * HWPoison-ed page in the raw hwp list.
> +	 */
> +	llist_for_each_entry(curr, head, node) {
> +		SetPageHWPoison(curr->page);
> +		folio_put(folio);
> +	}
> +
> +	/* Refcount now should be zero and ready to dissolve folio. */
> +	ret = dissolve_free_hugetlb_folio(folio);
> +	if (ret) {
> +		pr_err("failed to dissolve hugetlb folio: %d\n", ret);
> +		return;
> +	}
> +
> +	llist_for_each_entry_safe(curr, next, head, node) {
> +		page = curr->page;
> +		pfn = page_to_pfn(page);
> +		drain_all_pages(page_zone(page));
> +		if (!take_page_off_buddy(page))
> +			pr_err("%#lx: unable to take off buddy allocator\n", pfn);
> +
> +		page_ref_inc(page);
> +		kfree(curr);
> +		pr_info("%#lx: pending hard offline completed\n", pfn);
> +	}
> +}

Let's revisit this above function when an agreement is reached on the 
recycling hugetlb pages proposal.


> +
> +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> +				    struct folio *folio)
> +{
> +	WARN_ON_ONCE(!mapping);
> +
> +	if (!folio_test_hwpoison(folio))
> +		return;
> +
> +	/* Pending MFR currently only exist for hugetlb. */
> +	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> +		filemap_offline_hwpoison_folio_hugetlb(folio);
> +}
> +
>   /*
>    * Taking refcount of hugetlb pages needs extra care about race conditions
>    * with basic operations like hugepage allocation/free/demotion.


HTH

Best regards,
William.

--------------E2FdWEJrG4s8bPT0zDD2C068
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p><font face="monospace">Hello Jiaqi,<br>
      </font></p>
    <p><font face="monospace">Here is a summary of a few nits in this
        code:</font></p>
    <p><font face="monospace">&nbsp;- Some functions declarations are
        problematic according to me<br>
        &nbsp;- The parameter testing to activate the feature looks incorrect<br>
        &nbsp;- The function signature change is probably not necessary<br>
        &nbsp;- Maybe we should wait for an agreement on your other proposal:<br>
        [PATCH v1 0/2] Only free healthy pages in high-order HWPoison
        folio<br>
        <br>
        The last item is not a nit, but as your above proposal may
        require to keep all data of a<br>
        hugetlb folio to recycle it correctly (especially the list of
        poisoned sub-pages), and<br>
        to avoid the race condition with returning poisoned pages to the
        freelist right before<br>
        removing them; you may need to change some aspects of this
        current code.</font></p>
    <p><font face="monospace"><br>
      </font></p>
    <p>On 11/16/25 02:32, Jiaqi Yan wrote:</p>
    <p> </p>
    <blockquote type="cite">
      <pre wrap="" class="moz-quote-pre">diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f0..b7733ef5ee917 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -871,10 +871,17 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 
 #ifdef CONFIG_MEMORY_FAILURE
 extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
+extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
+						struct address_space *mapping);
 #else
 static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
 }
+static inline bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio
+						       struct address_space *mapping)
+{
+	return false;
+}
 #endif
 </pre>
    </blockquote>
    <font face="monospace">You are conditionally declaring this&nbsp;<span style="white-space: pre-wrap">hugetlb_should_keep_hwpoison_mapped() function and implementing
it into mm/hugetlb.c, but this file can be compiled in both cases (</span></font><span style="white-space: pre-wrap"><font face="monospace">CONFIG_MEMORY_FAILURE enabled or not)
So you either need to have a single consistent declaration with the implementation and use something like that:</font></span>
    <p><span style="white-space: pre-wrap"><font face="monospace"> bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
                                         struct address_space *mapping)
 {
+#ifdef CONFIG_MEMORY_FAILURE
        if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
                return false;
 
@@ -6087,6 +6088,9 @@ bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
                return false;
 
        return mapping_mf_keep_ue_mapped(mapping);
+#else
+       return false;
+#endif
 }
</font></span></p>
    <p><span style="white-space: pre-wrap"><font face="monospace">Or keep your double declaration and hide the implementation when </font></span><font face="monospace"><span style="white-space: pre-wrap"></span></font><span style="white-space: pre-wrap"><font face="monospace">CONFIG_MEMORY_FAILURE is enabled:</font></span></p>
    <p><span style="white-space: pre-wrap"><font face="monospace">+#ifdef CONFIG_MEMORY_FAILURE
</font></span><span style="white-space: pre-wrap"><font face="monospace"> bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
                                         struct address_space *mapping)
 {
</font></span><span style="white-space: pre-wrap"><font face="monospace">        if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
                return false;

 @@ -6087,6 +6088,9 @@ bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
                return false;
 
        return mapping_mf_keep_ue_mapped(mapping);
 }
+#endif


</font></span></p>
    <p> </p>
    <blockquote type="cite">
      <pre wrap="" class="moz-quote-pre"> #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878d..9ad511aacde7c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -213,6 +213,8 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	/* For MFD_MF_KEEP_UE_MAPPED. */
+	AS_MF_KEEP_UE_MAPPED = 11,
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -348,6 +350,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &amp;mapping-&gt;flags);
 }
 
+static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
+{
+	return test_bit(AS_MF_KEEP_UE_MAPPED, &amp;mapping-&gt;flags);
+}
+
+static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
+{
+	set_bit(AS_MF_KEEP_UE_MAPPED, &amp;mapping-&gt;flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping-&gt;gfp_mask;
@@ -1274,6 +1286,18 @@ void replace_page_cache_folio(struct folio *old, struct folio *new);
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch);
 bool filemap_release_folio(struct folio *folio, gfp_t gfp);
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Provided by memory failure to offline HWPoison-ed folio managed by memfd.
+ */
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio);
+#else
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio)
+{
+}
+#endif
 loff_t mapping_seek_hole_data(struct address_space *, loff_t start, loff_t end,
 		int whence);</pre>
    </blockquote>
    <p><font face="monospace">This&nbsp;<span style="white-space: pre-wrap">filemap_offline_hwpoison_folio() declaration also is problematic in the case without
</span><span style="white-space: pre-wrap">CONFIG_MEMORY_FAILURE, as we implement a public function </span><span style="white-space: pre-wrap">filemap_offline_hwpoison_folio()
in all the files including this &quot;pagemap.h&quot; header.</span></font></p>
    <p><font face="monospace">This coud be solved using &quot;static inline&quot;
        in this second case.<br>
      </font></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">diff --git a/mm/memfd.c b/mm/memfd.c
index 1d109c1acf211..bfdde4cf90500 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -313,7 +313,8 @@ long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
+#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | \
+		       MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED)
 
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
@@ -387,6 +388,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
 	if (!(flags &amp; MFD_HUGETLB)) {
 		if (flags &amp; ~MFD_ALL_FLAGS)
 			return -EINVAL;
+		if (flags &amp; MFD_MF_KEEP_UE_MAPPED)
+			return -EINVAL;
 	} else {
 		/* Allow huge page size encoding in flags. */
 		if (flags &amp; ~(MFD_ALL_FLAGS |
@@ -447,6 +450,16 @@ static struct file *alloc_file(const char *name, unsigned int flags)
 	file-&gt;f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file-&gt;f_flags |= O_LARGEFILE;
 
+	/*
+	 * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create; no API
+	 * to update it once memfd is created. MFD_MF_KEEP_UE_MAPPED is not
+	 * seal-able.
+	 *
+	 * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
+	 */
+	if (flags &amp; (MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED))
+		mapping_set_mf_keep_ue_mapped(file-&gt;f_mapping);</pre>
    </blockquote>
    <p><font face="monospace">The flags value that we need to have in
        order to set the &quot;keep&quot; value on the address space<br>
        is&nbsp;<span style="white-space: pre-wrap">MFD_MF_KEEP_UE_MAPPED alone, as we already verified that the value is only given combined
to MFD_HUGETLB.
This is a nit identified by Harry Yoo during our internal conversations. Thanks Harry !</span></font></p>
    <p><span style="white-space: pre-wrap">

</span></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">+
 	if (flags &amp; MFD_NOEXEC_SEAL) {
 		struct inode *inode = file_inode(file);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3edebb0cda30b..c5e3e28872797 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -373,11 +373,13 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  */
-static void __add_to_kill(struct task_struct *tsk, const struct page *p,
+static void __add_to_kill(struct task_struct *tsk, struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
 			  unsigned long addr)</pre>
    </blockquote>
    <p><font face="monospace">Is there any reason to remove the &quot;const&quot;
        on the page structure in the signature ?<br>
        It looks like you only do that for the new call to&nbsp;<span style="white-space: pre-wrap">page_folio(p), but we don't touch the page</span></font></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre"> {
 	struct to_kill *tk;
+	struct folio *folio;
</pre>
    </blockquote>
    <font face="monospace">You could use a &quot;const&quot;&nbsp;<span style="white-space: pre-wrap">struct folio *folio too.

</span></font>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">+	struct address_space *mapping;
 
 	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
 	if (!tk) {
@@ -388,8 +390,19 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 	tk-&gt;addr = addr;
 	if (is_zone_device_page(p))
 		tk-&gt;size_shift = dev_pagemap_mapping_shift(vma, tk-&gt;addr);
-	else
-		tk-&gt;size_shift = folio_shift(page_folio(p));
+	else {
+		folio = page_folio(p);</pre>
    </blockquote>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com"> </blockquote>
    <p><font face="monospace">Now with both folio and p being &quot;const&quot;,
        the code should work.</font></p>
    <p><font face="monospace"><br>
      </font></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">+		mapping = folio_mapping(folio);
+		if (mapping &amp;&amp; mapping_mf_keep_ue_mapped(mapping))
+			/*
+			 * Let userspace know the radius of HWPoison is
+			 * the size of raw page; accessing other pages
+			 * inside the folio is still ok.
+			 */
+			tk-&gt;size_shift = PAGE_SHIFT;
+		else
+			tk-&gt;size_shift = folio_shift(folio);
+	}
 
 	/*
 	 * Send SIGKILL if &quot;tk-&gt;addr == -EFAULT&quot;. Also, as
@@ -414,7 +427,7 @@ static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 	list_add_tail(&amp;tk-&gt;nd, to_kill);
 }
 
-static void add_to_kill_anon_file(struct task_struct *tsk, const struct page *p,
+static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,</pre>
    </blockquote>
    <font face="monospace">No need to change the signature here too
      (otherwise you would have missed both functions<br>
      add_to_kill_fsdax() and add_to_kill_ksm().<br>
      <br>
    </font>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre"> 		struct vm_area_struct *vma, struct list_head *to_kill,
 		unsigned long addr)
 {
@@ -535,7 +548,7 @@ struct task_struct *task_early_kill(struct task_struct *tsk, int force_early)
  * Collect processes when the error hit an anonymous page.
  */
 static void collect_procs_anon(const struct folio *folio,
-		const struct page *page, struct list_head *to_kill,
+		struct page *page, struct list_head *to_kill,</pre>
    </blockquote>
    <p><font face="monospace">No need to change</font></p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre"> 		int force_early)
 {
 	struct task_struct *tsk;
@@ -573,7 +586,7 @@ static void collect_procs_anon(const struct folio *folio,
  * Collect processes when the error hit a file mapped page.
  */
 static void collect_procs_file(const struct folio *folio,
-		const struct page *page, struct list_head *to_kill,
+		struct page *page, struct list_head *to_kill,
 		int force_early)</pre>
    </blockquote>
    <font face="monospace">No need to change<br>
      <br>
    </font>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">
 {
 	struct vm_area_struct *vma;
@@ -655,7 +668,7 @@ static void collect_procs_fsdax(const struct page *page,
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
-static void collect_procs(const struct folio *folio, const struct page *page,
+static void collect_procs(const struct folio *folio, struct page *page,</pre>
    </blockquote>
    <p><font face="monospace">No need to change<br>
        <br>
      </font></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre"> 		struct list_head *tokill, int force_early)
 {
 	if (!folio-&gt;mapping)
@@ -1173,6 +1186,13 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
+	/*
+	 * MF still needs to holds a refcount for the deferred actions in
+	 * filemap_offline_hwpoison_folio.
+	 */
+	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+		return res;
+
 	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
@@ -1569,6 +1589,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
+	bool keep_mapped;
 	int forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
@@ -1596,8 +1617,12 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 	 */
 	collect_procs(folio, p, &amp;tokill, flags &amp; MF_ACTION_REQUIRED);
 
-	unmap_success = !unmap_poisoned_folio(folio, pfn, flags &amp; MF_MUST_KILL);
-	if (!unmap_success)
+	keep_mapped = hugetlb_should_keep_hwpoison_mapped(folio, folio-&gt;mapping);
+	if (!keep_mapped)
+		unmap_poisoned_folio(folio, pfn, flags &amp; MF_MUST_KILL);
+
+	unmap_success = !folio_mapped(folio);
+	if (!keep_mapped &amp;&amp; !unmap_success)
 		pr_err(&quot;%#lx: failed to unmap page (folio mapcount=%d)\n&quot;,
 		       pfn, folio_mapcount(folio));
 
@@ -1622,7 +1647,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		    !unmap_success;
 	kill_procs(&amp;tokill, forcekill, pfn, flags);
 
-	return unmap_success;
+	return unmap_success || keep_mapped;
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
@@ -1862,6 +1887,13 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	unsigned long count = 0;
 
 	head = llist_del_all(raw_hwp_list_head(folio));
+	/*
+	 * If filemap_offline_hwpoison_folio_hugetlb is handling this folio,
+	 * it has already taken off the head of the llist.
+	 */
+	if (head == NULL)
+		return 0;
+</pre>
    </blockquote>
    <p><font face="monospace">This may not be necessary depending on how
        we recycle hugetlb pages -- see below too.</font></p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre"> 	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
 			SetPageHWPoison(p-&gt;page);
@@ -1878,7 +1910,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	struct address_space *mapping = folio-&gt;mapping;
+	bool has_hwpoison = folio_test_set_hwpoison(folio);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1897,8 +1930,15 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 	if (raw_hwp) {
 		raw_hwp-&gt;page = page;
 		llist_add(&amp;raw_hwp-&gt;node, head);
+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+			/*
+			 * A new raw HWPoison page. Don't return HWPOISON.
+			 * Error event will be counted in action_result().
+			 */
+			return 0;
+
 		/* the first error event will be counted in action_result(). */
-		if (ret)
+		if (has_hwpoison)
 			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
@@ -1913,7 +1953,8 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
 		 */
 		__folio_free_raw_hwp(folio, false);
 	}
-	return ret;
+
+	return has_hwpoison ? -EHWPOISON : 0;
 }
 
 static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
@@ -2002,6 +2043,63 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
+static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
+{
+	int ret;
+	struct llist_node *head;
+	struct raw_hwp_page *curr, *next;
+	struct page *page;
+	unsigned long pfn;
+
+	/*
+	 * Since folio is still in the folio_batch, drop the refcount
+	 * elevated by filemap_get_folios.
+	 */
+	folio_put_refs(folio, 1);
+	head = llist_del_all(raw_hwp_list_head(folio));</pre>
    </blockquote>
    <font face="monospace">According to me we should wait until your
      other patch set is approved to decide if the folio raw_hwp_list<br>
      has</font><font face="monospace">&nbsp;to be removed from the folio or
      if is should be left there so that the recycling of this huge page<br>
      works correctly...</font>
    <p><font face="monospace"><br>
      </font></p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">+
+	/*
+	 * Release refcounts held by try_memory_failure_hugetlb, one per
+	 * HWPoison-ed page in the raw hwp list.
+	 */
+	llist_for_each_entry(curr, head, node) {
+		SetPageHWPoison(curr-&gt;page);
+		folio_put(folio);
+	}
+
+	/* Refcount now should be zero and ready to dissolve folio. */
+	ret = dissolve_free_hugetlb_folio(folio);
+	if (ret) {
+		pr_err(&quot;failed to dissolve hugetlb folio: %d\n&quot;, ret);
+		return;
+	}
+
+	llist_for_each_entry_safe(curr, next, head, node) {
+		page = curr-&gt;page;
+		pfn = page_to_pfn(page);
+		drain_all_pages(page_zone(page));
+		if (!take_page_off_buddy(page))
+			pr_err(&quot;%#lx: unable to take off buddy allocator\n&quot;, pfn);
+
+		page_ref_inc(page);
+		kfree(curr);
+		pr_info(&quot;%#lx: pending hard offline completed\n&quot;, pfn);
+	}
+}</pre>
    </blockquote>
    <p><font face="monospace">Let's revisit this above function when an
        agreement is reached on the recycling hugetlb pages proposal.</font></p>
    <p><br>
    </p>
    <blockquote type="cite" cite="mid:20251116013223.1557158-2-jiaqiyan@google.com">
      <pre wrap="" class="moz-quote-pre">+
+void filemap_offline_hwpoison_folio(struct address_space *mapping,
+				    struct folio *folio)
+{
+	WARN_ON_ONCE(!mapping);
+
+	if (!folio_test_hwpoison(folio))
+		return;
+
+	/* Pending MFR currently only exist for hugetlb. */
+	if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
+		filemap_offline_hwpoison_folio_hugetlb(folio);
+}
+
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
</pre>
    </blockquote>
    <p><br>
    </p>
    <p><font face="monospace">HTH</font></p>
    <p><font face="monospace">Best regards,<br>
        William.</font></p>
  </body>
</html>

--------------E2FdWEJrG4s8bPT0zDD2C068--


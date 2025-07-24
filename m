Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA8BC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 04:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4E86B0191; Thu, 24 Jul 2025 00:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985CB6B0193; Thu, 24 Jul 2025 00:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8266A6B0195; Thu, 24 Jul 2025 00:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66C936B0191
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 00:40:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF20657C20
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:40:29 +0000 (UTC)
X-FDA: 83697906978.15.44C1CCA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0906640002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:40:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QSyLs66I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N9JIzSs7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753332026; a=rsa-sha256;
	cv=pass;
	b=Xf+zNE8mQ4f0QpCq/9ekJw+g/z7BOH7Nhs646H8rgennK/rb64EeW7Sn3UMBrNPnxy5WGj
	wylV6JuZkeynsx6mHnS5DvmZjqcfmGErbgJUBRbaoeSzRKkxUhSPDHf8+ERg/Joxm6Z1mu
	gnyhFTmCyE0ZJPO9MaqejYJ5VaLerLM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QSyLs66I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N9JIzSs7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753332026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pg7TB1A93CE5T81Ha5pysQuLWai8v8C1LPJTxy2hUNs=;
	b=xRYMHR0VPBYw+Tnb4NA/HhMuXX4M9F8tsK2Q9ok8sWBYJYRCLlI587KZ7aC4aeekJQw/oM
	/3JiP1YbkxF2+ymQ1/0l+57+oHGRfTryY2FPtLgIrYo/pwrC7eJZSd2EKzew9NDJa78Wbi
	JP/cCYC7hVxLxLmH+PqfJPoAoSnxdVs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NLQpTU025170;
	Thu, 24 Jul 2025 04:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pg7TB1A93CE5T81Ha5pysQuLWai8v8C1LPJTxy2hUNs=; b=
	QSyLs66IGAPDQKxr9vYUsFPXoMCQMVmcg/ay+kLHZv78k3uAc6UJZ/oeY4qToVou
	6Z/v4YqgWGJfASOYhVIvRYg28mUrkGDpOlkx7fGoDciRA3ru9JeNQNXrmYmE5wTk
	qWgPjYLKg3gl3cxUszD+0thid7LDWK+6zgn5yX16orybnWH9xl+xdt3DgT89DE1Q
	rBb0wPq32CK451YNxLgRaOocm/tLrNvWJ6oD+ZftJT5tutG2MwjAty/lDdqhHoYI
	WTD354kKe70akHOE9Z4AhS7a0JGgp38ks/z4kCo+trLNBD0bNz7hltSO7GZaNLj7
	Ge1r+zz2ibWlrA4swiGz6w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057r0yhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 04:40:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O21rNW014366;
	Thu, 24 Jul 2025 04:40:23 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801thq76f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 04:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2iCsJxu5WaFrMhyd+Nhj6v643TasL+WaFNtImm1f+j5ML9KzzgCTW4slfv0hvVPm1qa6ozFE+iQex5a2H+3UNw1qjpnYDuzie+ZZdmi1LVoljiBAyUEgMJlUsGx1Zh9vBUhfnpxW5N5OlD4c0TDPbnppnZX3qrm7V6o1nNW5E3Y98BOacZVAN4RZ3NcaIsAhD+urY8bumfPux43ciyTE6oe2FqVV6Tx4+Iqqrtmbp2a/cLN3wAwkvyzL4jkrV2T2p6Eqjb3FY9ReP/7Sp4lRGMYgX5dLxVTWUSwD/sizvsIPjAxsi/jMC+OmIulNwl7eHiFaCBxho30NLgPHKFmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pg7TB1A93CE5T81Ha5pysQuLWai8v8C1LPJTxy2hUNs=;
 b=MUKPSyx4qOgyIahN8XKrnGvfRVVBHfarP35eaVj5le4uApqpMZpoZ+SSzHEe384fz8DdNE96w8u6ioEBzdI0iCSMtZBDyCu1o4xj4e0Xe13kCUf8TPqUh6NRjYXcTbjsArb6zlnD2i21GXunkPKby3M4q7OaJ29rgGHBMvDShhMNq1lZH9sSetU0W63YY08Z8n54SM9A6DAcNobI3ReeS1RtcowynVi8OEt7mGyCKKIlchz3QMTJMdjT0H6YoJ+kqCFYzc4WweGlOyY3I2L4iahnPTGfpBHpWVuT0phsfT7Ie+2fKVEJ4/MqVIH/Fo5Yiqjp/AtZW7BO5sxisTz4ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pg7TB1A93CE5T81Ha5pysQuLWai8v8C1LPJTxy2hUNs=;
 b=N9JIzSs7vUU3HLQiNFOVJk30CORnxSy+EazhkOeleTYLy6WnM8ZtqHO/qZx1rDew66aFTzRLa+/DXdTJ+OdwjWl8gfb2jaeZpk09lKIYQGzc/bHpME1YEu1AGOIp/QyGoBra9lFnjEhQwjWxqRz4/uceukruDOt4DcqHaSPdMCY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7944.namprd10.prod.outlook.com (2603:10b6:408:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 04:40:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 04:40:18 +0000
Date: Thu, 24 Jul 2025 05:40:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Message-ID: <f485f72a-c034-4a33-9f41-c2bb59e7c37c@lucifer.local>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz>
 <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <CAJuCfpG5VeW5+GdceeRCLDgX4CuFm2xQUG6UAAoLwF7oW8aU_g@mail.gmail.com>
 <e419e15c-7bfc-4fc2-9089-e271a3b0576e@lucifer.local>
 <CAJuCfpFdyiXFuxoNMQHj6jkVYkJMzq67rHM9400NoUBS1TJtyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFdyiXFuxoNMQHj6jkVYkJMzq67rHM9400NoUBS1TJtyw@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 81a41b41-37ec-41d7-4ad3-08ddca6c30ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUZIZWJKTGY0WDU1aXEyWGtLNk8yanpSM2dqRVh5bi96Y3Z3ek54RFRRVDRa?=
 =?utf-8?B?R3o2RUVoNGlONWFGUWFXTXJtNlovNWx3aEt1ZGI1MzZ1c0orem9wWmh5U09y?=
 =?utf-8?B?cnhaeCtxVk5kblI5RFZBWmJYVFJ6R1cyb0NSaGNBWEppQnd4VnBIRk15MEdi?=
 =?utf-8?B?cVN1Ly9wL2tFdkEzclloWnJiQnlENnRCbG1oc01WZUsrcW1uL3YwdFpvNGtk?=
 =?utf-8?B?NVVUZ3BNMUhhcEdsOFd6am1tekdxSW9Qa2E2alFVdzEzUHlYWFM3OWF0Uk1a?=
 =?utf-8?B?QnhhRjk0ZVdTeFZpdmlJSnh5YWc0VWlTUDN0bGZFaWIxMFk5QS93QTZoaFBt?=
 =?utf-8?B?K21RSXhEUXVFOGxjdFlObFpIaFVjaS9MQWxHYXoyTG5xdW1SY1A1ZXJpOFpm?=
 =?utf-8?B?WjU1Qm1Ec29STEs5SGpPdGlHUW1XUjljOThqNTNLK0hFUUZuRUtuWGhmS1dU?=
 =?utf-8?B?Q1M3VXBpT1FLMmxMeExud3ZFQ0lXVm8rSkVTV05WNDM2WDJDRlZiWnJRV1pj?=
 =?utf-8?B?QkVNVCtmVWkrQ0lNZE50YUFqbXViRXVvSC9EV0hsRy8rOVFzdjJldHlFZGdm?=
 =?utf-8?B?QlJkSmN1M1lVSDk4SUxhUWpWK3BxWk5PZURlTXlvM1diaVN3dWR2WDY5OWN1?=
 =?utf-8?B?bDZtTkgrMG4rcDJYM21Sem5GMy96aUZQQzNyYlUzU1NMZnc1amRLbWpXK0Fz?=
 =?utf-8?B?dTdXTTZabER6QTRnb1pua0M1b3pRNGtGb003ZXFxUUYvbzhzb3NjaW16V29C?=
 =?utf-8?B?UHJmVzlSdHFBQ2dVT1d4eGRhWUJVVGdkaG1NR3FsNVkxVC91QWo4RStjRWpw?=
 =?utf-8?B?M2w4dEt5aUd2ZkNJN1kvak81YnJtRnl0c0NHWFZMRFUvNXAxcFM2Zk9iazcr?=
 =?utf-8?B?NVRMN0RhNGRKVmZzNkZqMk9qc28wUlhsbW9WSWJlMGFWckxISFByNTRKUnNC?=
 =?utf-8?B?VTQzVk1JKzZoTVVoWWdSZjNxbFZ2Uk5IQnVYaGJwMXdYaWFQVVpzMTFzOVdB?=
 =?utf-8?B?ZGM2RGQzcjVGK1o1T3NpQVoyY2Q0akdSS1pudEIza2ZjNDVWRFlhSFZvQjdN?=
 =?utf-8?B?MnpUZU1FY0UxaUNIV1RGNTA0aXFaMzBmWVczSytLV2JsMFJqNkExbVJjb3B1?=
 =?utf-8?B?dHVaYmRSekkyU2c3TVd5S1Fsd2ZNSERpUE5QbDdMbGR1ejRVMW1mSWxMRXBP?=
 =?utf-8?B?amk5K0NoNlFuTXh4TCtrTkRRMHVaWE83SEJDbnp6OVZJeVIvVXQ3bXBXOEVo?=
 =?utf-8?B?YVpQdy82RFllSUgzcHFZTXI2Nk4zaFl2dUhSRUNDd2VRdDdSSnFXekd5YS9a?=
 =?utf-8?B?U3ZXQXpMeEhaL0RrQ291cHkvL0JZUEVCL2s5RjI1Z0RqVGFhUzcxNEFyVnFw?=
 =?utf-8?B?TS9uaEVTRkZqSVZwNHlaTmlYa2c4V1pkOWExVXRlazYwOEZWeHdubmhEVVRl?=
 =?utf-8?B?ZzVGakE3UDRlbDRUNUFaRmI1R2xXUmFDSDZsMmkxdnBHV1U1MlpTTWd5ZWow?=
 =?utf-8?B?ZWM3eGd3bEZTTjVMcElzcGVBYmcvQmhjMDRjNldyY3hyV2N1bFRtZU9uS1RD?=
 =?utf-8?B?S3V2cktkb1hsT2MzWUlkMTFpTEVJSEtsR2lGUm11OCtIWlNLMlE4a0VuTFlW?=
 =?utf-8?B?eHBpNTJlbkRrMUJQUzRqb3IvM3R1ckdXZER3NGkzVHlUREhyaEpOSW4zbFZr?=
 =?utf-8?B?VVQvbXpIMkJISm1kNGJ4TzZoTUMzWW1rT3JQQlRlN0c0SVRoRWVkM0lMMEhQ?=
 =?utf-8?B?ZWQ4S2ltVEJCZGMxbVgwWE5ZWmRzdDVTaWh0QmRQV1BBeHg0dE1nVEhTdDYy?=
 =?utf-8?Q?rAY7P3QZjnz1+cOPjayjhtu3czlSytQWYSWHM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1I4ZFRydlFMTDVCL2c0eHFaTC9DK2d1Z3pvdzR4RFF2VEgwbUliSFZNYmhV?=
 =?utf-8?B?WWk0YzJqUGU0MGdVd0pOUkkrbzllTkhFTFl4eWxkaW9RREJnanZIMXFuZURW?=
 =?utf-8?B?M3hBZ0xabmpXdW9jZmRvcjE1N2duemFqTXV4eVdEeEdScmhUcmdDUm03YXRJ?=
 =?utf-8?B?eTQyeHhTSmgxWkk3dzdDYjBxV1RCdHF3WFRocXhxSW1nSU1IUEttb3M4VWZV?=
 =?utf-8?B?c0ZBdDVlc1djWlhiVEhPYW02aGcrOFNrMXZiNXhvcWJjZFJjNWF1aXBBaDhV?=
 =?utf-8?B?dGJ1a1pidTZ1VzVCK1NnWFM5b2tyZlB5b3UxUkVTVldaSDk1Ly9Dd09pVzBu?=
 =?utf-8?B?dUNJekxaTFV6NFFOR0tJdkZQK2YzQ3JrNTVTaVcyQTNBa0pEZVhmSjFGdU1k?=
 =?utf-8?B?RlFqaXorTktTcjV0ajZXV3FTcGRnNEdYTC83Q2NFV1ZEZEo5bCtrUzBDYzZP?=
 =?utf-8?B?d0dRbFQ4dVYrTDRqdWdHT0tnTUhwOUFUNGYxV3kvWTFTNjh4anU2WHl1eU4z?=
 =?utf-8?B?eERRSVdlaWNFOWN2UHFLVEVBb3E4Z0QyZWxGQ2R3NVU3OXB0c2JmZ0FQL015?=
 =?utf-8?B?RmtSclRyNmI2ZFd4NThZTXhzQi81U00xdWFQQ3FhV2FhalF0UnZrTTFtZkRp?=
 =?utf-8?B?V3gwc0xIOGZhUUg0b1FsZ0h6eHplZ1A0akNkdTNvbzRZeW9BeFgyZXhrNkFD?=
 =?utf-8?B?aTh3eGtQdTlCVG9Jd2c2aDZyVkVmSmtXeWFHZDQwb0lxSC9PWUVJYTVrNm5s?=
 =?utf-8?B?NUY4aDkvdmowbDhWdDJzaWlZMDhnUEN4Rmpzc2tOeGUvYkxDbzJNS1Y0bmw5?=
 =?utf-8?B?VElGSFYzVldRWHZTcnBxMUM3TFRabUw2OXBIU25LM3FrdnZad3FFZ05IdVVi?=
 =?utf-8?B?TGR6eUE3MGF3ZHIvWkFNQlNLaWdmTEdZMS9qMkpXU3ROcWhQZE00L2EySUxC?=
 =?utf-8?B?b0Vqd1JxQUhNbWdheUd6M05XcGRlNnFZaFl4eDBhOS8xeS9CU0lRak1RclhK?=
 =?utf-8?B?MjZzelNjTVE5NFB4VnowZXR5eW5NMWE0ZmtyQUVWZmVhbFlNbElUVENSSmZx?=
 =?utf-8?B?S29iSWNFRUV3Q1FIa1YwNU9uUnUvZFgvTVpuSHdLczZhQTRNcUcxSWlXdWlq?=
 =?utf-8?B?ZWtaczR2VVpOZS9DOTFNKzB5dlh3SVZ0RUdLVjJDeTBoZllFQStNZFJSZ2d5?=
 =?utf-8?B?TUFOSEZpSkhWNHhYTitwdWF1UU9yaGlTTXg0RGpuMldtb2VXdERYbm9WNk16?=
 =?utf-8?B?Vmk1M0UrN0F0UFRoWDVveDdlTElZVWV2YnFMckVtYXB3a21CQlgzWmhSMDlI?=
 =?utf-8?B?QlZpS1JJaStpTklIcjVzZTZUZHExQWtmd040ZkFMcE8raEhGUUhvYTNua000?=
 =?utf-8?B?NFdDMXU5dHZnanl2RGJrVGNiZWdHZVBPOXlyZkxpVzFkWlBDNDhZNllSZ3RY?=
 =?utf-8?B?YnQxRkRIdXlxWE5xazNpTkdib1g2alZrQ1pkYXA1K3BwWUxnM2licVFUdzVv?=
 =?utf-8?B?ZTFrRHZPVlVqeWE4RmVDTDU4eHM4eWV4cEY4NXhINEFSZThqTFZqcmZaVGtx?=
 =?utf-8?B?cnVaT3lkRnZtVE5qSmVvRE5hNzhDL2xmaDNDSHJOY2haZEdyUjNvSmo3emc3?=
 =?utf-8?B?eUI3Wi9JdVh3N3RkK2crZldkYStMZm5tcWRLOGpZV3VzQnNFK1dZeXVZSVlP?=
 =?utf-8?B?VzNwVklXYWs0VmxqQ2Q2SHhxc1Y0amxHdFdhM1QvWDA4R3JOWGVMSG52Rno2?=
 =?utf-8?B?RTdkay9uOFpxaHliWTdoMFdqUjN4TnBieTZrL1Nmd3BZdW9BQUtPbUhvbzlM?=
 =?utf-8?B?clBTek55TUFrMzNoV1V1Y2krdGJSdW5PbUY0MEpzcFR4OEZZcFVDbHdLY3Bm?=
 =?utf-8?B?citKTnpna25xZzBYWE5FSjlRQTZDcFh3V3lNdm9pZkNqdW5QbkY1UE50d1lE?=
 =?utf-8?B?YkFEUzhUaU91cjlRRlZCREhXaTdlTjNObXJsUXFMUlIvTTBYUksxN0hnVDlV?=
 =?utf-8?B?YWpCT1krRWxhODhiVHBQRHV0YkxjdXJncXdrMUp4MVAwMUc5NGx3L1JUVjNt?=
 =?utf-8?B?ODlhYTBEOWpBdHFFb0hpVG8xRVVjSStpNEJXMDZUMVZnNVNOdnhXTFpkQTRD?=
 =?utf-8?B?dU9xUDFZM2NFSGVTMGJCYUQ4YmN3bXdOOVI3Nm81K24zdWZCTm8zcTlDb2Zy?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I9p21MnYZD3H5X7LvdhEz3JaQ7nDAvp8bYlKBmPLEM+oTPy0xxL+BakjFM8fiyKVxdJdZQWry0gTHy4ScDLW2ClP36eXnuWZs3Kw2NRHdnIKcmPAF+3DQJdw1AggqviqlM6OfWS+JwCD0ogOr5JeCkQbpO9iHUSB2KAKCoM0nGvYBYuyqPnBf6cgmh3ZqXY3SbRA05UbWBqxIRVy91GT2Yo/rwJiEu4R+YbbHJtnClcGL8+jwD1e20zl+Tykzfu/dgpcQNREHF28f7QK0exqdJwcYPw+/vkTTrfPM5l+JhYqgtH5I6HW/r2psuDDi5wHKSyLnADUhLNPsCRtGQ89oGl6DIKhLAR9YMqP6aBUch7aJYtwL75fORHf+gX2OSAuOoOQ00mkDzwCB9OIQRg7MGCOc2URJrtO2oJraVWzW/abj68Qe6jByNNClnH+txtmL4p8zU7k6HzALSFs+zbIbICZN+FLjGRET5dgU3F7Z9nX/b8NrraP9lRTu9wb1QYnWNDh/oKcc7/sbjAo49s4lnsZciU+cJ/6N0TSy2c/EjsP+mw7MGJy5H69h/BlqegZy3eAPaMJiiYiGa8mURUVJnYQZVeaEJqJidxUvmOUY30=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a41b41-37ec-41d7-4ad3-08ddca6c30ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 04:40:18.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bv0iZjE76rKwQdggr5sV9Q5meu/ntfZxFhrNGtVifgeh9z8rdbNuQ2rkC0hym1nfj5UqgankLOliK791Ldw7o9aGsRoUipTiBrydUMtxWD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240026
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=6881b937 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=P-IC7800AAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=C0WgHfAMPc6w8-A2ol8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf
 awl=host:12061
X-Proofpoint-ORIG-GUID: m3HQrvHmiT--Lj2BCLXK3IFk9079V00J
X-Proofpoint-GUID: m3HQrvHmiT--Lj2BCLXK3IFk9079V00J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAyNyBTYWx0ZWRfXxJyv6DK77WFw
 CW4B0WDn6ndoiIV+Pg2i+/74mfIRZZzOQ23rFHQP7eCt9+Ds2q+CRj1o1GsuWLDcVXOY2nCx1o8
 QsBLD8X/WBu/DOqghavMJrO/XuQTer8FTyLpt55pUr7A/a2kVFr3H3JRU8GZTt13H1IzQXZIpbG
 JgXiKp0UW1W/ysW3m8xWV/rlU6CHsJ12pENcFxnQ/Goxswj5xdVJ2m9nTocV4JF/L7qVuKSzQF3
 GS1x9cxTRFQ6ExgmModrr8O1jlO/9w5ocRXcJ0nAw6yb1FJHIySs33k5jTKrKvWLV2I/lXTERQV
 uKN+X5GOIfLO/wyTWUezTm72iO8PSfYk12Mm26oivn1efwjJmA3O85zxPtM46W4mL3oS1SL+rQt
 6kPEnlEXUvR7go1amrMnkpZRUNyXwWfImxqA5Cdj/YZe1ihw8+6sPtHJz/Matjx60QOOinmC
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0906640002
X-Stat-Signature: e53dqqy38ebwjswyas6zywp466fb33y9
X-Rspam-User: 
X-HE-Tag: 1753332025-444163
X-HE-Meta: U2FsdGVkX18K3jS3L92lTQ1sTR2ddgIe/0s7IKqOOUclExe+g/lPxDNqS4GFOoGZ4Iv2h/zViRcgT/CrNAwh1xiGCBbkCFtxQvuil5MhQj0CvbxmTc0FFjG/WRWWhifrkKumjZQHORUvhQIep0GEl6XooBFdTjqHzQ9oAQuYHtWZ16hXfKFURqxfQog0oVGKoPjuBaWrkwprFlQJ0hruVPRyDBPVg3z9UYzHOfBZn5dpmAwl/jIdcNdJpvqzScbXV2PGRGNu36KdjbJrPUSCryQs5wT63rtrXZv3w4n6PhciEJPN9RndMdRM6lyljtCWhiVUUtdwu89M/ImDDB+PjnvAtzdzHUp4/13rNQQKsQa+aDkHqo+W4CQiveNHBTpnz0ShxwQE4Giwolm7sIxWG1kbVU9AAXf7nZTVhP8BilC0XrWnYSm0FU8i1GA1wE4p+HS8I6lB5bngu2lYHg2YoR8bB6GElipbaRMLPj2WS6pbR7tBJP9n2w0aaIEMEnNL/FpRMj5QO1MXJmPi2EwJcTECnscL7OT+ldTJFnf+4OP615SpWU7yzXm5WtCp8BuqdqFxsHIGmlEWjGuPrj8I/rCpqDVFYgnxKKSyBsanRJyhQm8aS2ywpVIYgySW8aJ3Njf6gDSi5PjlqoECalNNqLUBp0nHPcZh9w4EG51ISwdLYcTYUrG0HsLUBgVHYEkU1tXflADa9eIbQjrOMCutkbBSiYT9wU3jaaalY8fc4j/FKzYxCzHLNhTx/t9lV3/4N7xzYaD6ZriUZDcLYMVlN9uvA1QeMfoporRMBath8JmKcpoGvfgZ5G3NqGX853Q0fOTuZPvRrl+Ab3STxmFrDd/HFxhaiNC6/3H9mBI8O7wFOO85CJjsn+JapGaOr1FfI+9LHTfDlFl6uo14VWuGiNOWP3xVc9QRLdJmEHJPdVos0oYA1cT6G02T2wfPDDKm2+9xSVv48nVRORIFQy4
 TjbLE8AS
 aYRL4pQ2U8n6rwLIoIDYmcaJILF9s2SI0HiuJPpL15wXR97bWgQvm/Gqyhcd0zeufKgiJLPyCB8GE65MgGI6F4H/PcLMWZyfVCdZjf7bxyrucyXUhW/kNytE+Xns8fSYfmKghCWwHi97AANatMCMdf5qsf9WQarRdp4275FOLP9RuAiBjck9YwrnGjzcpqSAAZfCOF3n2gY/IdPaA6VGtYnor6zJQwS3zywd23L/QzzWP3/xgNDXnIGCkaB58qQdtqaMbuQW9h6PA1mBxE9Ez/cXGVxgXpVOc/sR5+SYfe7v6nmAyvo6Q4CtlESBqBEJ0DSmizer7W82LwPtuF1AbnW/VP9t6i0gn4ZjZQfmEN7oz6w1zDiKM3P+FEUMw9Ri0hZ5E6x0f99Hj4ELoNmESbLIpCB22OiMxarX2c1x2xMBPhK1FKtSJHx7rS4+ecrUzy7o9DMhswwgFvaAPbxGppN5tOcx98sa388Red7QQ2bUsp3xUVudu0MH2tLpJBIWvmgCEaHX7FTG3jQYO9BcYeIXj6eAhoXUIIsvVR9ElsP/S9Dlig5dNL/aBdUZVpjpwOIwemZbc9hbMvkvJvaJL3AUW4KFq3ZdOevpaYelZWgAJpqVFWg5E4RqaPTbJTIm7a9JxR12PL4JA5uQV1f+4u+gvSR0dlVmSKqAmP9Df84dOpGZmV0GIkLGo7LY8gqbTAYwgkspAqgA9UC0yTle1+2P7zNX/LYPXhbVxRlwD+i/idrwL6zpmucz/e2oK119mIbcEAficXckcmOYw1NMjuLjEolZIBhyJEBAK9gPzOO07sLwrSOl62SinJYqkyMkkI91mCsWHE63RspR/X1arDi8zOni+WJweD6vI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 05:13:56PM -0700, Suren Baghdasaryan wrote:
> On Wed, Jul 23, 2025 at 12:01 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Jul 23, 2025 at 10:55:06AM -0700, Suren Baghdasaryan wrote:
> > > On Wed, Jul 23, 2025 at 10:50 AM Jann Horn <jannh@google.com> wrote:
> > > >
> > > > On Wed, Jul 23, 2025 at 7:32 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > > On 7/23/25 18:26, Jann Horn wrote:
> > > > > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > > > > without sufficient protection against concurrent object reuse:
> > > > >
> > > > > Oof.
> > >
> > > Thanks for analyzing this Jann. Yeah, I missed the fact that
> > > vma_refcount_put() uses vma->vm_mm.
> > >
> > > > >
> > > > > > I'm not sure what the right fix is; I guess one approach would be to
> > > > > > have a special version of vma_refcount_put() for cases where the VMA
> > > > > > has been recycled by another MM that grabs an extra reference to the
> > > > > > MM? But then dropping a reference to the MM afterwards might be a bit
> > > > > > annoying and might require something like mmdrop_async()...
> > > > >
> > > > > Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() and
> > > > > mmput_async()?
> > > >
> > > > Now I'm not sure anymore if either of those approaches would work,
> > > > because they rely on the task that's removing the VMA to wait until we
> > > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > > think we have any such guarantee...
> > >
> > > This is tricky. Let me look into it some more before suggesting any fixes.
> >
> > Thanks Suren! :)
> >
> > I feel the strong desire to document this seqnum approach as it is
> > intricate, so will find some time to do that for my own benefit at least.
>
> I think we documented most of it in your document:
> https://elixir.bootlin.com/linux/v6.16-rc7/source/Documentation/mm/process_addrs.rst#L705
> but maybe we can improve?

The whole problem is - I wrote that document and understood the locking,
and then you radically changed the implementation :)

I hope we settle on this one finally...

Anyway, it's entirely my fault for not having more closely followed things
at the time, esp. given my M for VMA locking... in my defence, my workload
has been crazy... but it's clear to me now that this implementation is a
lot more complicated than I thought.

Your doc changes in commit 795f29616e85 ("docs/mm: document latest changes
to vm_lock") provide an overview, they don't provide really anywhere enough
detail to understand the implementation.

I should have reviewed and checked that, again this is my fault.

Anyway, in the interests of 'catching up' on this I'll document these
details myself as, at least in part, a pedagogical exercise.

> This issue is a result of my failure to notice that vma_refcount_put()
> uses vma->mm. This is my oversight, not a conceptual design flaw (at
> least in my mind). We knew that lock_vma_under_rcu() should never
> dereference vma->mm, that's why we added an `mm` parameter to that
> function.  But unfortunately I missed this indirect usage.

I've looked at the implementation now and find it generally difficult to
follow, so regardless of the root cause here, this is complex stuff.

Anyway again this is my fault, I should have scrutinised the new
implementation as closely as Liam and Vlastimil did, and should have
reviewed the doc change and told you to write a lot more :)

Let me fix both of those issues.

>
> >
> > The fact VMAs can be recycled like this at any time makes me super nervous,
> > so I wonder if we could find ways to, at least in a debug mode (perhaps
> > even in a CONFIG_DEBUG_VM_MAPLE_TREE-style 'we are fine with this being
> > very very slow sort of way), pick up on potentially super weird
> > small-race-window style issues like this.
> >
> > Because it feels like debugging them 'in the wild' might be really horrid.
>
> What do you have in mind? A specialized test that simulates some races
> for vma lookup/allocation/reuse?

I mean where we introduce validation tests and check expectations at key
moments in a debug mode similar to the way CONFIG_DEBUG_VM_MAPLE_TREE does
this for the maple tree stuff.

>
> >
> > Or maybe it's even possible to shuffle things around and do some testing in
> > userland via the VMA userland tests... possibly pipe dream though given the
> > mechanisms that would need to be put there.
>
> I think that would be difficult if not impossible. We would have to
> inject delays like Jann did to reveal such rare races in a repeatable
> manner. Maybe if we had an in-kernel delay injection mechanism that
> would be possible?

I think that'd be a lot easier in userland.

My point is that a core part of how VMAs work is this locking mechanism
now, and for the userland 'VMA' tests to be meaningful we probably need to
recreate that accurately.

>
> >
> > It's sort of hard now to separate VMA locks from VMA operations in general,
> > so that's something I need to think about anyway.
> >
> > But I'm almost certainly going to document this in an 'internal' portion of
> > the process addrs doc page we have, at least to teach myself the deeper
> > internals...
> >
> > Cheers, Lorenzo

Thanks


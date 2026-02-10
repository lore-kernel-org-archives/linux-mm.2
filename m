Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69121E94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C486B008C; Mon,  9 Feb 2026 21:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03AF6B0092; Mon,  9 Feb 2026 21:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E57D6B0095; Mon,  9 Feb 2026 21:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE156B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:12:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21DAD8AEC3
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:12:36 +0000 (UTC)
X-FDA: 84426923112.29.0CCCC6F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4667EC000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:12:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uoigNpcA;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770689553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtgV9pQo7Rp/QAcOy5d2lbjUZaDce1z+4k0dDKnRRg8=;
	b=wbMP5a/T+0Ge8e/9iSQcXUbUGabyrbA2RH2U/4mvrWcvZTdFnfz6onffzrIchLYuuscS+w
	EXtJsiEl8bh5r7Vxvhwu7Cuwvxbm4I8RUepcUm7XpEusm5VHXPlEgIsTBk6hIey/snA66S
	ud1le+EX8VEzc1agKi2eZUfMqTf3eYk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uoigNpcA;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770689553; a=rsa-sha256;
	cv=pass;
	b=TotvMOtQ1hXl2EQb6g+ewnNwZBOMsD9P3G52j03B3gXHwm9Hbp4mmIsP8C7GxPvWuBZsk+
	DwPxMtzY17eMWNylCdEh5WIb7YVFL4cW+H+7n1TcrHrfI8B9rKiGLmPfohhZZwtu0GMMEs
	OEZnF3Xti8ZEzFI2QXRDHOtI1jDj2oE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXXBRGxi07xLbXXDU4CqcHcVxQ9L2iUkDCTJJireeIhCKOvrsTVWFJ6Qaayg8LaSOj+5Qas2QA0tOJhZIhZSuR7jf52Pd4SY82cR2bBL5runQrrtVsUT4n/f/bOjYxISoXVxbWFz7adR5L5/bMnt7dkxFDi60BcsmNPYzadTjks0rYf4deHJ5JkNemmYcdYly9D4OaUj0HG8l0P1wLCn6ZZhG3ZpWCoGB2pBXzxSmznLo8S9VVgM74c30crRxMY/xRQbVlbM04xwtX2MhpQwLc8e7g/oOY/YlA4Jj4Om5J8Ry8NUJMFMpxIS5ELpn5m/aVdzVkYRBDr+L3vB1KbiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtgV9pQo7Rp/QAcOy5d2lbjUZaDce1z+4k0dDKnRRg8=;
 b=O2cuO0Oj9O4Y1+tU9skDNPhGtHcYSvnG/SJgMOT5wpWmKzWeNaaBZAUGl43PsFjsYTHOooePb6TLZ75IhnxL2j6+E35D6q/N9juDysEuus36KlO8agTVocCn64ZZdZMPQtcm6LbEryXKfFa3qvoOqn3kP01L1B4m35oRuP0lVrx33sSCsNIl2thxj0jNai7V60nUL48mar3uC69ACS+QvBL2BGxhURDqrPP0WshqWkWxL6vXIspW6TzPcE1G40SBjWzoOBbMHU4Gl/TSHJShluQF/0mbL8iWL0FXDLDnoi+YEHAqi3g11am1FuZSfrvs0HZKXSWvOVMja5UwWkjbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtgV9pQo7Rp/QAcOy5d2lbjUZaDce1z+4k0dDKnRRg8=;
 b=uoigNpcA3z7teKntvMfDIbVTrQAsF8Dc6TpKqgidKu8AtOpl5tC2SVlXwwQOY/mPk7nDyxgv2RpbGmj8u3mF13h8brBF4VFKW2xISvFaJ/vcGmIc/jLpcvGQBiNeOcVV0iDuYnMY2Vr4DaW43TNZJG+h5HktLXTn146aNnMNPyyZYqrgk9psJ/V42kXJ16KZcHyBby8Y6OAUdsGTH7D8Nx1GasOggaQd8sGmmhl3WLaLLn9ZKfdItd3pQB4g1a9GFcu0AX+DSe1e1tAg1b95cILRcGpyG0+OFC642lm87JOGg6bab/re4jyw9iQ4aUqEr5bFRxuHxb6zknv05EWxKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7738.namprd12.prod.outlook.com (2603:10b6:610:14e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.19; Tue, 10 Feb 2026 02:12:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 02:12:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Mon, 09 Feb 2026 21:12:25 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <71370B54-A462-4F72-AF82-8E076AF112FC@nvidia.com>
In-Reply-To: <e69270cf-dac1-448c-ace8-3f789e5cdc6e@linux.alibaba.com>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
 <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
 <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
 <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
 <e69270cf-dac1-448c-ace8-3f789e5cdc6e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0020.namprd14.prod.outlook.com
 (2603:10b6:208:23e::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7738:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f9e956-fc37-48f4-04ce-08de6849d6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1dPR2dxOTMxUy90QU1NOUxlWm9BVk1FT0ttMFJJNG5sVHk4djFnaHdqTTUw?=
 =?utf-8?B?alNTSXJmTFdrOEVtNFA2bGpmMDYrcFdLUmZIY0xUcG1GQkREYmQzVFFOVU13?=
 =?utf-8?B?akRDbHNkN09BN0c0VGZYV21BSXlrSjhDZmlaMy9RaSsrODd4Sm1rUnR4cVR5?=
 =?utf-8?B?dGVnanNvYW9hMklmWmwwTkRVWVV2YzQvaEM2VUZxc2pobGpPaDRhNm1VU2pU?=
 =?utf-8?B?Z1M4SHRTSzZMMVlIcEJFOVdqRmZseHJGeVV5MGYvMXpRUXk2NnR3VkQ4d1lt?=
 =?utf-8?B?d3RxUWRhNUpJdE1yYldxU3JRMW43R1d1eHk2dUFHT1JyWGVqQVJubDFMa0VC?=
 =?utf-8?B?cFVlOUh1Vlo3eVdmdGQrc3JaN1JCSkg1bjBpd1pFOWhPNitKVVdJZjdyOFA2?=
 =?utf-8?B?aTVCT2Mzb2x0Mk4vQlB1dlhDMmJSWnJtWERWUlVUQ0VtZERxMUxycWtxdksv?=
 =?utf-8?B?TUpLLzI4RGpDVnBxT010WVNNdi9GTEsxRXFaNitJS1g0VjJJaVdLMmtOL210?=
 =?utf-8?B?VGZJcWltM1V2YlVQMWlzY0ZISHkzalkyejhwb3FGcWpsUUhOSVlmSFhVc2pw?=
 =?utf-8?B?eHRqcUl2UFlzdG1PTCs3SXRvVHh1eldUaTZPekN0OVN1VWhwNnVMYzdSMUxj?=
 =?utf-8?B?NHNFK1cwaG1sRUZoY1YzU3lBLzI3YTB2RlNyMnErLzdCWFNTOFVMZjE1b0VG?=
 =?utf-8?B?RWZZcVpSY3pnRGNRb1JJKytjSUJTSnQ0RUl0TzJVYVgzcXFPSnlHdUlyYW1u?=
 =?utf-8?B?cGgrSDBHaWQxWUVxa3VkREdtRU9FdDgvbmR6V3MvL1JmOWZxdFlTWjlhQjJk?=
 =?utf-8?B?SytweDVtWVpWWHhnL0dYVVdySTd0MHltbmlDNmJiWU9odkYzU01tRmtlSUtG?=
 =?utf-8?B?RitTY2JML2ZMUHNCVmIycS9xMSs0M2hWaU1zemdiV2k3elY0Q1E2LzRRUCtt?=
 =?utf-8?B?TlF5bG02Mm51TGtjdXZoVVE5UFoyTzdtVGwyMmVpVEE5cVFhSmxsbTRkWGh6?=
 =?utf-8?B?SjFnSVR2VmVQODhubld6REEySGVZYytrUjYvaFg4QkFDZURtemhTSGszSEdC?=
 =?utf-8?B?d1ZCbmgwcGhPNTNVNmE0aTU3RzZDamJuVS9ScFV0Rk43SU5temV5MEZ1dFBl?=
 =?utf-8?B?OWZxUVZBM1lvNkduMW1Vc2xheTl4bmJsVU4xWTk2eERsOVlpckc0UWI3K0tH?=
 =?utf-8?B?MkdGQVZLbG52eDFhZmtBdGppbnBlSGdlV1BKUjBnOWwrVlk1ZmNOd20vYWs2?=
 =?utf-8?B?WkEvQ3gwNjBieGo5ekdkQ2ZlL0wxZXloRXpkWjNLKy9wL1pWMk0yMWNSRWlX?=
 =?utf-8?B?aEpMdGRpY0piWHFwREEwV0NJRllSTnZCeWoxaTdHSmZ1aEdraEhmSDh5ZFgv?=
 =?utf-8?B?eDcxN01oRWc2eHh0TXUxZTk1ODlkRTk2dHJrRXZsa1drWWw5WERwZTVyWHBF?=
 =?utf-8?B?OTlKY1ZVblYzQUZma2xEMDJjUjZlOGx2TXI0L0d4YUNzM01IR2hDQVZCVkk4?=
 =?utf-8?B?TVh1RTF5Y1NSY2JwSitkclRVR1RiVUx2dE43ekVnMzh6YjA2KzhLbWliUWNK?=
 =?utf-8?B?Nm9DamxoNmpLRGtRZlNEdzN4ZG5OLzdtdEV5SlBQbHNsYjQrU0g2TWRwMWF3?=
 =?utf-8?B?UlYxZUVGOGhuOGduK2RQVHlhaXBxT2x3S0pTZVQzM0kzYXE3RVdOeVFlTWpC?=
 =?utf-8?B?YWNXZ2lSWTRrY1ZHbWVPVzBJZ25YcTdlcmx1Q0YwbTJVYVJyMlBIaktSTHly?=
 =?utf-8?B?bllvWGdaVzFxRlJCaUoyK3JDUDRyVVEzLzk3UEhJd01CN0x3NEsyMmRCRkpr?=
 =?utf-8?B?WXJqZDlWMkxod3M0cFlDOEdVeURtOGU0ZkFmT0R3eDhoZ3pnTVRvaUJaRk5x?=
 =?utf-8?B?OUpxbmlpYU82VXdHay81UEhrVlovQVVOM0F3dGFlYjdpQkJzMnd5THVIdEVM?=
 =?utf-8?B?TlNzSVJGRmN3MTVqL3pLTVhtWHlZVFc0RHBPcjd4MHBBQ2lSbWlyY3h3aGlJ?=
 =?utf-8?B?TWpCOGZCOGpvU0N1NFNETEczVGlNSDNJZGhSL2lhMlFNd1p6Y0M5R3hWOEZN?=
 =?utf-8?B?KzdzdnlLNFdBWStLSzdwWHJxOEFFVUpPNUcrTngxWmNZWlJvNWI0QmIyK2Vm?=
 =?utf-8?Q?4zTQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3ZzNlZEVk43dERPenBhem43ak8rRkpVK2JnYjhRVG9qYXUvR3hxN240Y1NE?=
 =?utf-8?B?UENDUnNzNERYTHlGdElpTHVlakFkYUZqa0haa08zYXB3QlNqSFhPRkU3V2o0?=
 =?utf-8?B?SUp5SEFKUmtoUkJteWJYb0poSFZ2QmllRXVFVHZTSWk1Q1d1VkE3NFltd1Bt?=
 =?utf-8?B?UnB1RTE4aDQ2b2luWEZjOUs4L2tLb0h5ZHp1Wm5JRUllUXdVUzFjakg0ZEl1?=
 =?utf-8?B?a1lnVC96SWxza2xscFJmVjNSa2dRYzBlR0RtUWlJK1o0M0cvcEdvcWFDQmhP?=
 =?utf-8?B?WXpLbk9GeDNpbmJMSDBGS2t4dGEwRjBSMzZIQjlRSjBScHN1Wks0RlBhVk52?=
 =?utf-8?B?a3dESjFtSDNQb3NUbjFnRTM2ZnZEamZOenBRUWtyYTdyVkdSR3lLazdKQUVX?=
 =?utf-8?B?a21GYjR5THViQ2ttQmZ6RlBiSk5sNjA2WEpkSW4wVkVnaUVwUVh4eHhEeHov?=
 =?utf-8?B?cVgxeTRoajYwQXJFSTI2djNNVTdZYzYzVERiNmErNGtGV2hpc21MWEtMTFQx?=
 =?utf-8?B?NC96Z25WQ0d2TStISzRKZGdFczBiTm9TVnNJRklpQ3ZDTFk2QVM4ZTdsYmhs?=
 =?utf-8?B?ODJjUVdPSHNZdGJzSkpvTEMzWitnbldNbTNFdlllYTlNMUMyTDBXbmVRYU1N?=
 =?utf-8?B?akxmWmg2YzlpWjduUXY0cEMvc2E0R0pGRkl4OXZZNEFTTGc4RFFVMzJ3S2JE?=
 =?utf-8?B?TzVBYVpUVFpSdkdRSEJWTE1MemdFWVZpQWdROC8yRVY0bVVFaUJHc1BhZy96?=
 =?utf-8?B?OUNJSFhFYUs5RlBZNFFKc2hQcDN0Sm8yek5ETGlSaXNRSFk2V0FNeTN0MjRy?=
 =?utf-8?B?a3RCWDlBeHA2RkxEbjRmdzhLOE84R2lseDVQb3JRdGJQT3I2WkpBSmk4SU90?=
 =?utf-8?B?M010R3ZIMTVqZE5VdVJqL0VJbGVDUzN3akZKQTA5V2FsMGc0aVBvWVJIbDVS?=
 =?utf-8?B?SVBGTEE2cy9PRjFBWmdjNGw3TWZsKzZ6UHNhNnU2N3lKSVl6UjFqNWpNbTJq?=
 =?utf-8?B?SDF5RHg5c1lObmo5RDNGb3NXZzBDaE5WcGIrMEpjSjl3ZkNHN0lNSmExVG9Y?=
 =?utf-8?B?R0pZSUZ5a0lQZUkwYUlhVXFONG5zY1dwTFYyTXUzdWphSDBqbHc1SkUvTDlZ?=
 =?utf-8?B?YnNhNWdYbWIxMTcrdGx2aTUwNEpPdjFHRkRoZWVGR2lXeGwvYWR0ZWZVc2g3?=
 =?utf-8?B?OXVackJwNm13TEt6Q2NqUmxMYXlZcVBHNk9VTEM4SndHRmtuSHNJSlVRVkYx?=
 =?utf-8?B?OS9rUFNBTlAxQXBvYkd3Vk54ekZaMnBWeWpKZUZqZnorV2xoNEpONmNoUm9m?=
 =?utf-8?B?Q0hYZlJHQVNhSG5DWlY2WlFoTHBpWnBvelNHcTVseVFEUFVrZmlBeDJkRm1x?=
 =?utf-8?B?RWc5VWs5eUFQNjdJSExFWVFsTFFEeEdrSHhWRXMyOWdCdFc0cTdQWWk1QkdM?=
 =?utf-8?B?cEcxWFpSZDBNWks3WFQwVUdFVHdkZTdEWnhiMm1hd2xKQ3ZPTDZtRXBRZFc1?=
 =?utf-8?B?WFBLOVZmSnlTWTRCNjkrekh2L25IWitMeWJ3ckx0c01LM0pSZHA4bDZ1YTVn?=
 =?utf-8?B?a3ZMM3Z6dVpJYmhlc2pZNE1YTUZXZXVrMUI4Vk45MEdDclJocUlmaFRxRDVX?=
 =?utf-8?B?TkJETUVFL3FrdnFrK08yS3UzOGdsVWtpUHpQckRLemZkV0FCSDdMY2NER215?=
 =?utf-8?B?bjVLMFZsdUg0YnVxM2drQlQ5YzJUQWpFNkJraXlXV05RNlNmOVFhL2hSYjM3?=
 =?utf-8?B?T2xkMDZGVVI5S3BnNklYZE1INkl1ZU9wSU9tWkRjNTJtcGdLTmJHZzlZZXQ1?=
 =?utf-8?B?dUFHMDN5eU9PQmN2bWcvcmF1MVhxTTdhWGpRa2hBd05qRG5sQ0RraUEvVjZt?=
 =?utf-8?B?TlJEbHhrTXRxb1hTaFJQR201NlNtbTJobGo0VG5PWC9tK3c5Z2dqS3cvTEsw?=
 =?utf-8?B?bW1ySHNLU2dMbS9ZMWd1aDNqTUdicThCeEU1RFBsVjYyNGRaSFNKZHh0bWhT?=
 =?utf-8?B?WnZxemJkeUkwM0t5bnUxY2I5dkN4U1dRcEpLMEdoalNCVVpXZ0c3bjRocVR3?=
 =?utf-8?B?Z0FVcElMZk9tZ0VUdDZma3ZjTTFlNjlLdVFFR1pHQlRTTlhpRGtWNE9hdVR3?=
 =?utf-8?B?cG1vb1VMc0dBVjk1VHVMczMvbzdFZnBnaE41WmVmMmx2d0tMUW5hMFpaUW51?=
 =?utf-8?B?Vm9XWWc3RFZEYXlocjlsMEMrNHRlVS9KcEphZVVsMXhYUE0zZTYzNE41RzNB?=
 =?utf-8?B?MDFRNzZuU1UvV0JLdmFERkxNYjJVVVpkOXJpZmE0SzdBRGpSRmtXNjhCbm9p?=
 =?utf-8?Q?gngucnczqt7Or1LCLh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f9e956-fc37-48f4-04ce-08de6849d6c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 02:12:27.9362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1vJvcy5uKRnYaR6zQjp2eeJuSRcnnFW1WaAtE0GXblPAWEkMbclXVRsHxKfyzi4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7738
X-Stat-Signature: gintg8u1taoi4ksgr3ohe177piyxh9ky
X-Rspamd-Queue-Id: 4667EC000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770689553-575139
X-HE-Meta: U2FsdGVkX1+3W7bu86leKqlddDdIaDb3GD1jsXGzFBH7a6/wZxo5usUYEOI9Edd65z16TSCj7Aw/fglWJ5zjjzBbA+pnRMnVSEMfHUXFsC11UJ0ymJHceEuosT357Dr6ZBwSLNbHeREwUjvcCg5CxX//GZveYzTfO0oAraqEE14utcZ8OjAq7E8laHf+bGJr31LtAG6/srDTk05x2gT6jCSyPCQp+w0SMWhKWvTjBON+xZwHbenbU2NrSWv2i8keOnohLIizV715Ko9cTho1y+fS55pdkXjfD+lF2QSqA+NZzA6kawZlgYGeEZVdkkCKLbsP4EXfP9ZUnUVOMzmEiPbdR+AoUFo7OnztWEO/1op4C+Qe/MfRxM0JysCPlQigUtao8sss9xupY+xYiQQcce8uXtQg2K8ZCx4XgGczFlDpdv+q1SEGPOpebGoTV1hXk5S/nBUqRFqAqXe0sUosNHvNzQbH28/GaO7jlt+d+PJtauSZyR3H0fKJEPHTFomnxBGn/CKFFrXoTdu2Gju/KbAwgjUFriM6YXRtkINQPuUMUtHSvurgWxj1zPsYS/u2JmwWsgezEFtU1SVV2uEYAZnzRI/BRmcsj67kt9m7AGp7anLpGyCyYoTrkSm9u26Ccl9jmahtUX6roGD6JKiEjP8tdGG4msKJXKzauwb5Aco2N6KC3uHVEBRtQ+dV6pdqChHVS++Y8AyEPthV3KaJW7FwoXgFCS8QVv7gmYdAo/AABzj/AQep6kdEkSbbukTLjkG9Y8fxSC6FPnY3vWm5/bXYvyiCFmBkY4p+/h2wZpwgWwaNSb7O8bDlBaB3ljxG5GTGa0uiDSCQQOHiN6aIscjup4hIqE8UF+8qSz/XH9tlEHVqKldPBa4Z+HQ8Ew4C8HqHiZRhkBeHmIyXxysCO0IS0ZI1PiaCssYTA89JVdSvm3VNgWjA9f82g2sSQp6rtQK2XSnAM0KrIWXCs5g
 HGrRY3+t
 JuQ9edGMb9ClKJrJd7cxfRQDN+ftyJFFAb6qyVQMpIiBQmNDgXB61UT1YElGCBF/vKj87YKloP0Vv20nlp9wZHUJTLSsh1ywz1Dxo6bDZTmfq5NN0Ab/ZXFklMv6Hs6tpbiwXZaw1BuL2kXWHC9sZKacxHKEBlFfyrswufXPaiM3shzpaYpRukV7ZC/JsboMospIom1WplGgdjbFCpjQ1XZdaowz29w47wb/ZlkuqOCta0+uQbDKvZEnf6NGk1pzJfGuZ7JBP5kxmF6oTDb6Suwe+/9TNAYL6mZ1kNjDvKRTCpeVwHN/SWJ0BXmQ09mcm9KrYMTPtcdnypFrmhx4HKYpG8I0QOtf1xXLVFd1JkFE4xfT9S4TiDdqiFt5kkthJaAHZcFJF/4HR8A0l0tNOK8wGl9AzfAONVabigsORUF9v8CL+Bx8vpvkizoz/CAv1PNbTmqSVPBHc1p2pb2B2p9HrFbbVF81awUJ4jsOVRwsMUoI86IjMEKMd+YnlhGQxku9oGVRZBC9SYqABjdMp0CMOEaObwWjhJhbh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 20:20, Baolin Wang wrote:

> On 2/10/26 3:42 AM, Zi Yan wrote:
>> On 9 Feb 2026, at 14:39, David Hildenbrand (Arm) wrote:
>>
>>> On 2/9/26 18:44, Zi Yan wrote:
>>>> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
>>>>
>>>>> On 2/9/26 17:33, Zi Yan wrote:
>>>>>>
>>>>>>
>>>>>> I agree. Silently fixing non zero ->private just moves the work/resp=
onsibility
>>>>>> from users to core mm. They could do better. :)
>>>>>>
>>>>>> We can have a patch or multiple patches to fix users do not zero ->p=
rivate
>>>>>> when freeing a page and add the patch below.
>>>>>
>>>>> Do we know roughly which ones don't zero it out?
>>>>
>>>> So far based on [1], I found:
>>>>
>>>> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overla=
pping
>>>> with private);
>
> After Kairui=E2=80=99s series [1], the shmem part looks good to me. As we=
 no longer skip the swapcache now, we shouldn=E2=80=99t clear the ->swap.va=
l of a swapcache folio if failed to swap-in.

What do you mean by "after Kairui's series[1]"? Can you elaborate a little =
bit more?

For the diff below, does the "folio_put(folio)" have different outcomes bas=
ed on
skip_swapcache? Only if skip_swapcache is true, "folio_put(folio)" frees th=
e folio?

Thanks.

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..546e193ef993 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2437,8 +2437,10 @@ static int shmem_swapin_folio(struct inode *inode, p=
goff_t index,
 failed_nolock:
        if (skip_swapcache)
                swapcache_clear(si, folio->swap, folio_nr_pages(folio));
-       if (folio)
+       if (folio) {
+               folio->swap.val =3D 0;
                folio_put(folio);
+       }
        put_swap_device(si);

        return error;

>
> [1]https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/T/=
#mcba8a32e1021dc28ce1e824c9d042dca316a30d7
>
>>>> 2. __free_slab() in mm/slub.c does not zero ->inuse, ->objects, ->froz=
en
>>>> (overlapping with private).
>>>>
>>>> Mikhail found ttm_pool_unmap_and_free() in drivers/gpu/drm/ttm/ttm_poo=
l.c
>>>> does not zero ->private, which stores page order.


--
Best Regards,
Yan, Zi


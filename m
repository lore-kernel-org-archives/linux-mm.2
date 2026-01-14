Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5513AD3CC87
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA406B0005; Wed, 14 Jan 2026 17:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7E36B0089; Wed, 14 Jan 2026 17:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F806B008A; Wed, 14 Jan 2026 17:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40FA46B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:56:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4D621ABC9D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:56:56 +0000 (UTC)
X-FDA: 84332081232.03.77F3BA5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id E1EB5180006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:56:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5QcP1K7F;
	spf=pass (imf16.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768431414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGerPrnmxx1FCSVCCOhjIjBslaw2FZr2xbtgxrAED4o=;
	b=CPg5ubBK15gDC7YJYK9Bn8wSqcGWZ8T2B/B6nq4cTop4bP6F42flABn3jy7GuRZMUyLEdF
	hae5YS4ptkQSUeZJDB1Inw7QLwqhfS3zFU3Shvy5qsLq/E5EDB1j8tXtuX8XUAuqSDGZoa
	9SCEYgnhyCgF4gwXpp00hy1/nDDMI0M=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5QcP1K7F;
	spf=pass (imf16.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768431414; a=rsa-sha256;
	cv=pass;
	b=mQ3p1XV79n9iw1nIacepSbTdk5ujUBT/r0rqgCf12kotoSEAG52uSjkwOqiUq6VEYmd4zo
	NIqQZwPzNe+yiL3Xi2RXSwquF3vN20ZwjV4aw3rKmmYyP3XEBizgUPw5oWEygJ/P/u5u6q
	TYypGmU6l1RSJsSq9s3Pxl7XmP6l2ko=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2cG5gYoNU3niMjV7VSkGLO3GCzDx/OgNu4si5cgXfHx9kd51FJVvsZtr1iMSPL9Uuo+La9/JwYOb+hdlZJnIyoyFhO50kRL1pzQYqPzXNoslJCGpem5fAku+Nnf6TFEbPyglp/2WdrbDBojHyUXAn+UVlQX/VGsv7bOeCpYBcikFkfsGvMqq0fuqi7iTmeuLfLwCQxdmvUfEft5HlGCJ71sK06u0JxpS9TZ0V2DimsSViLQUgcj1ZRZeHjSIyitwb6Y0rUj1ORYYyipTlP/rVpafAcs3PXH2HY31EIMGhaazmVxdICrq0jNyqSvgh/eLojBjyWI451BhwOqZ1kbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGerPrnmxx1FCSVCCOhjIjBslaw2FZr2xbtgxrAED4o=;
 b=jihNuxmgqfx13ZSO4y4+1JHj5IgVkdZGj1DI901dLB8w6W0YELJvH+pbruncVMGxr6wsU9J+GBJ6yN/QveRnbbgVZkstNv8w74QS0cyQkb+Vwj0Io5qedOuUEuPW3hnTzheeXWfK8M99LPq4C01NJKiKQeKbQA1eoY1ll4k3NpSQFd5nf+X+yi2CtAOQOpAEEFkJ5IuW0VQRYF+blWLmhNxFnvUv8iRrYlFDbO2x05+xjfvSRM2mfmn8bjJ8JJ14SP7Ltai5W026EwGjAC48OEcwB114oHn/ocGJaDmiXaa6Z4Ewb6bq1gC4j7TxPk5ujWUUdh2lS32mAX5bQUa4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGerPrnmxx1FCSVCCOhjIjBslaw2FZr2xbtgxrAED4o=;
 b=5QcP1K7FRClMtsvdtnxYDacdyjMTak/+bpULey+x43YoFYd+rdgyDkaumgkUGSEPL6wBfwXTLaTiO8lu3AvKKj7cYpNyGuNPiQa9pGCgYlONqHnCDZTt3lfucGGRQJ5xDsy16GZYAdORptaLJBK14jX/Fs4RHftK0sCMxw38ZFM=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Wed, 14 Jan 2026 22:56:50 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 22:56:50 +0000
Message-ID: <13ca9404-1e4c-4035-8dda-5b628aec3a28@amd.com>
Date: Wed, 14 Jan 2026 16:56:48 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-2-prsampat@amd.com>
 <4f2c6106-9cc1-4196-8b20-83b297ae7195@kernel.org>
Content-Language: en-US
In-Reply-To: <4f2c6106-9cc1-4196-8b20-83b297ae7195@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::21) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 63cd7925-131f-4f21-ab6e-08de53c033de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODh0KzFqZUQ3dkgvQ1JuWTBhWTVTelZscXFuOGFBeGxCWngwV1ptNy9EZGo5?=
 =?utf-8?B?NmRva2ZydlpiTkp5OThKcU5hOVBoN0xzT3BzNjgxUEZSMGpYaUFPc0pWaDRY?=
 =?utf-8?B?U2pqb1JvN21mZzJBN1R3NHpRZmlROGxHZzdpdGxFK1B5UmI2UXlyWWJMajBl?=
 =?utf-8?B?WlJhWlZhWkZWR21LSVErRFVwYzBIWkg0SmNoY1pXZzFIU3FEbCtPQjdtdGJ5?=
 =?utf-8?B?NVhlYTRyWGVRRGtVc0F0UTBwdHZVRVFwNWxJeHcxWmRjSFhmT3JxUHFFUS9R?=
 =?utf-8?B?RExXS3pZYTBrUzFrUG1VZU9Mazh0REhyZzJ6aUlqMDdzaEhRQmxoK0p0eTdE?=
 =?utf-8?B?VG8zcE91Y1FWaGd0Y3hiMG5BajlNRk9VaTEwbUIvaHpJT1hjaWk4MCt3MWxs?=
 =?utf-8?B?RExGTnU0eTl4WEw3bHZrdExWY0JDckNud3hwNHZwUFI5QjR3c05Bek56VU9K?=
 =?utf-8?B?L2NsM3JkMlE4RStHM2ZRbmFFYjRxOHdJNjBsQnluWWMrUWQwQ29KRXZxV05O?=
 =?utf-8?B?UzYxeVJFckxpalhmRURKV0g5dm4rWlpSeUN2eDBmdWtrRkp0akdKSFBpT3Zt?=
 =?utf-8?B?Wng1Y1pEUEtnNnRwVm9MczZhcDEvRVQ2aGF1Tnp5cWdUaTZqR3F2NHprTkxu?=
 =?utf-8?B?dlp5YStodTFoTi9BOXR2Zll3MjNxYUlXR1dURm9UQUxtWS8zWVNReXlIbjJT?=
 =?utf-8?B?RnprbTZuVHJxaWVGeW5wSGFjR0s4SHhlSHNHbFNSbkhhMnE1NVpSQVFnVUhF?=
 =?utf-8?B?U2kyV29tUDJ6NG1NeWhuajRZSERKUUNjNWozS21NUDhIMC9yMVRoU21VN0Y2?=
 =?utf-8?B?aXdieXhaQUVFeDV1MENZYmhqbzNqaU4rQkZ0NnFHQWEwMUhYQjJNM0FvMkxv?=
 =?utf-8?B?c3o0NUc2YzYrb3FtRndPRnFTeFlMd0RjNzBuekNOMmtJOW0yaVBRa0VZamp2?=
 =?utf-8?B?NitGeWU4VnV0bGlaUER6RzVXREcveHJ0UzBacGw5c0NCMUxUWWYwZDR5RE9n?=
 =?utf-8?B?UEp4TEFvYTRpc0ZscUFUNFJERXQzL25BVVZXV0FYYXdHQVVlK2hnR1NsYmNB?=
 =?utf-8?B?SWErYU80bVpwVmFSVTVrVGY2Z0tmMm5ndlVGVWVYWlF6a1JrWkM2N2dOSzk4?=
 =?utf-8?B?RlYzMzBDQjlBQVFGRHQ1NjN3UDVjeXZ4a3JmQXFyeGprNUk0YytYY005YlRQ?=
 =?utf-8?B?VU01d3EvSGFvOHpNaCswZFFld0FPa3k5S0ZNSWY2bjJzMWdPMkFwN0lsZXBB?=
 =?utf-8?B?T2hBQnRSMmVXUHdwVXVuRkg2WDlwaHJNTkhFU2ZpcjZhL2VSQURGWjRaUll3?=
 =?utf-8?B?TDg2aS85L3lOUDhRMTBkY2NYS0RtYVJ6eGVBWCtjcEpHOWlJcXN5UENxaHpW?=
 =?utf-8?B?OFBqL2ErdTRLOUJSZ2VzamVDMmM5ZlhoM2xqT1VRRlpZVEFiR2h6Um9YSkpl?=
 =?utf-8?B?aFpHbXU5cUYreW01bGZMbXU1dElhd2t5aW1aZ0NsSkxpR3VCeXFMclFFVlBT?=
 =?utf-8?B?Y3NNNkJDTkRwdzZiY0ZDdkFGTUlndjBjQkM0cEQrVGhjQzI4VHFPNzBkOUJh?=
 =?utf-8?B?Z254Tk5WVEUrNHhWUnprdFZyblU0dWNXenk1dWwwNDBBTEZRSldDTWNHaC9o?=
 =?utf-8?B?aFNRVUgxK2YxVkE5dkRSMmVmcnVKOS9EWGJhVS9jWnFjTFVyWmthMUcyVlVU?=
 =?utf-8?B?MFI0K3ZLZ0g0ZzRXc0IxR24zTWxzSXJXaElHb2NIMFdnT3V6cHJsRzRNR2VV?=
 =?utf-8?B?aUhHVXM2TGVJUWlIOTg3d2JLYUUyQnM1L3JRblB1dEFJRXh0KzhKQUl0cXRz?=
 =?utf-8?B?eVg5SnhrRFBrSXVQbDljU2ZpdUFBaU9SaE03VjF1YkE2Um1Dcjk5TTlrditQ?=
 =?utf-8?B?d2hEVk5uajZXcVI5bkxzWjlwMWk1R1kxYnk2U1BqZTQzelkraFdmSm05bWd4?=
 =?utf-8?B?QVhETTJXQ2tpUEU5UDVYTGxYeVFaNzEybWh5NllUZ0JVZDltM1lXNHBUcyt0?=
 =?utf-8?B?LzNacXlaM01UdStac3poTmpCUlFlZEliakcvR0ZXVWNoTHNacFpuV1J3VXZK?=
 =?utf-8?B?QlBEWEZDcDd5STNybzJSOWZ3M3RDY1k2a2hjTG9vLzZ2a2k0SUFwUWZUSHBE?=
 =?utf-8?Q?9lSk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjNXdGFiTDdEQm9EMnNHdmNEUE1HZjRkU0srRm4xU2tOWUdRUG9mb2VPcEht?=
 =?utf-8?B?ZTNvZldKRUs2Q0Npa1VkSnJQKys0NHR6NWZvYmRvUWtKQyt0bmorVWNJZFJY?=
 =?utf-8?B?TVltMkg4QVh5UmRaKzNtT2NZZDl1UHZFREhsREpJU1pjNUNjUEl4c0N0UWFs?=
 =?utf-8?B?a3I3RHZyMmVldGZZK1BCZnZ0aFllSmNJRXZLd2VEMWQ2cXNXMmpZMGVaeXh3?=
 =?utf-8?B?WUNGQnQrOWhvSDZ5d3lRSEFvMmhRcm9YZGo4ejY5Y3FSR25vUitCQ0VZblFB?=
 =?utf-8?B?YmpmM3pLS0p6akpEekE1VlhRcHF4eTVBSXpTVHFKcmRXbEZQK2tOOUJBeG1n?=
 =?utf-8?B?c3lZUEZtaEhnVVpOU0lFa0VEY0FPdExyMlQrdVM1ZDFTTG1mMEhSNFBXd09l?=
 =?utf-8?B?NVl0dVFSRXFZcy9mcDBUL3Jpbitvemg2OUkxL0wvam9pSUxhVUdiWnphRHNC?=
 =?utf-8?B?bm5hMXdiaUt5T0pQWGFxRlpxMnNjeW93em5vS0ltZDkwekhPc25WODYzQXFE?=
 =?utf-8?B?M1F6elU5RFE1V25VbzVHY3dINkM1eDBKOEE2Q2hnZlY2V2VXZDJtcWp2SFpH?=
 =?utf-8?B?bEd1TkVHd2VpK0lHY29xZS9GT0gzTzNvaEc2K29xMjBrWmRXYmtlTExNVVNS?=
 =?utf-8?B?YThpRzdmNmhmMzMwNUhQQS9GUGVLSUpRVmVVa3ZON1pRQmgyKzVFdzRFOGN6?=
 =?utf-8?B?ZDR6UmtZZS90QzNZMVZsTTJpTzdoMzFsV3JXNG50aVhoR3g1MzYwTEgyT0RH?=
 =?utf-8?B?b1B2OFlwQWJseXVWL3FGN3F5MWVUYUYvam9NTHdpS2tmTlVEL050Z1FCSUtE?=
 =?utf-8?B?ZXM0Z0xNbDBwL3ZvTkNLYzE4QzVmU20vUlVOVjBDa0lWMGliR2FLZy8xVFIy?=
 =?utf-8?B?V2I2NlR6U3k1MDNCWjZLcVBqYU81VkQ0MDU1bUJaUlNxY3pKeGJOSm10d1c4?=
 =?utf-8?B?dWU1ZnRCMXJOTUFBRU90aDVYYUhZL2hibmZ6RmoxLzgxa1ZLMnpRNDJVc3Y2?=
 =?utf-8?B?QVJSSkNFaHJVL29HNDhrVUpOS3I4RmJiVFNkeXF1cEhqamR6bUJNSnNWNnky?=
 =?utf-8?B?T09lTmtTVGxDYUhHTUtjeG56MmQ2VDNGVCswclVIcjJqbUZaZHFHTnphTmQ5?=
 =?utf-8?B?QlpOdWVmWEwvc0JkaTVaZUR5N0MwZ29ISzhZU2F0SXNJdzNwMDQ5cEpFSGQv?=
 =?utf-8?B?dFBBdWZsMGVvQUpDTzVBQkh3Z2Q3dy96Mms4alQ2STZmUnBiZ3dyUWhOQ2hE?=
 =?utf-8?B?ZTNVbHh1MVhKaXp5em90cmlWc3ZlaWhSU0hRSmxLalNvdTM4MzZ5bHMwL0Y4?=
 =?utf-8?B?RzZDS2tSVFlBeEZtNXZvTzhNeUxzWXUrVVlGZENwV3dsUDhLMG1jbVY2RnIz?=
 =?utf-8?B?SkwvOVF0aDJPaEV2NWE2ajcvblpsL1NZVVZBSFUxcW42NkU3MFk4V2Z3S2x2?=
 =?utf-8?B?eHM3bTk0RVFOYVZTaFh3MkRKSCt6QXhRSExJNnpXMDkvZ0ZZMWpxTVVGWTlm?=
 =?utf-8?B?eXRDMkxjeEhRcytSM3dac3R4SXNKKzA1WFFvRVRyM1FiYjZhWGhqMG9uYmh3?=
 =?utf-8?B?b2dRVVF0Q2krb1NJQTF1ZXZQOE9BZ05pL0lyUVoyN2s4M2syekxKckxOeFRG?=
 =?utf-8?B?SFphTjRDS21mSEwvaUIzN2Y5YUdwclV2REx0MzJUMW5RZER5VnVoVjBnM0Ru?=
 =?utf-8?B?S0VrbitQSGNZQStKS2pZOWJzOFJOR3RkOGxOUDB5bWt3NGtibVFKemVEOUw3?=
 =?utf-8?B?T1ZZMmJnQnFmcGQrOHR4QzRaVUJKVVJ5LzQ0bmZaM2xFdEVzcXNDTENKaStY?=
 =?utf-8?B?aE1Id2xsY0w0VlFkNC9DSmNLRXhYeW01THlGR2NFSDFwT3hoZm5MbUFib240?=
 =?utf-8?B?UWVkZlcxbE1vQ3hxbzhJaEVmK0FhN1ZyMEhMcWdPOVhseXB5SGdqa3kxMWFx?=
 =?utf-8?B?bWd3TWxwaTJpVSs3Um10bzdZbUxLS2NPUzRGZlh1RG1xaTl6ZmxReE5WYm1D?=
 =?utf-8?B?L1RJOUFxNE1YTWFHbEdnVjdINlg5RHRqL2owOERCamVZaWtYcnkwK2duZ1cw?=
 =?utf-8?B?ZzRoeGU1c3VpL095ZDl1TkVTMFVWdU5ZMStnWlhZYllVVVFXa012azB4djFp?=
 =?utf-8?B?TlBwakVibG4xVDlOaDJmZFd6ck5FYWFid2RVVnNRUC9Obm9lNVJMSFovY0Ja?=
 =?utf-8?B?TU5mOUwzazJiLzdZMmQwazlPOXVXUWNENDF1UERiVEhoZ0tiMEViNkVmOVJk?=
 =?utf-8?B?RG16VDJldFJQUXpzS0EwLzZ3TkVWdHFLbGZLMTFhbC9WbmJoaEFMYVUzZ0Jz?=
 =?utf-8?Q?Cij174JHvVjEHLx7yO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cd7925-131f-4f21-ab6e-08de53c033de
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 22:56:50.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hV0cSxO0DecKy1OgC86umAyCGdjlHA/9aXpwWBb0qUVlp6uvBduWYVqavZOA+hi4ZXD3NJFnqb1w8H2e8eDXmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-Rspamd-Queue-Id: E1EB5180006
X-Stat-Signature: jm64uw7u11qr9864wty5trutrxdu4zz9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768431413-469462
X-HE-Meta: U2FsdGVkX1+tZERHuWSf8wQYxg2sM8JBHHIOrDmAo01UDgOZegOUWAZnuC5eOAuNOq71OKjxPecQQGZoXE84T/8DSX2cSfhUbHxDP6XrmPFMlN0fApITJAqJLDKaISQAs27HRUEmLvvCtR9lFZzDRAAJx+yT6miXX2vAMt5ssrx7itA/y3Da1lo4GO2WtwHwPbRmWqGoiVl99zd+5YBpM9XY6SObADJUv0rdv71TQZPDfKKH5LFRxnxC9Jbk+UfIZpszviHTWA7AJ/+c40N4RZKAMr9vcrSxMHfF/djwkHjQaxC7xnizqm6fE3uEXu4IHDOrX3crv3iX48anyzFNL00CHrqCl0HviS1NPZXWVebu8Yy0i3K0lHX1/L01cNsoG+a9RONKV8tWxCEgLGjKXf9VXqoP6sKZabHIOo4QpqiJffv4YG+xBFhML2izg/0OiBDXubuqZW6je5zlX8Fe7WhINBjd/O+3UaCefYYQB7FjOv4+gr3BpbL+7c7mjgaotfCb7/yLOW2T/NxGGqcPGvmCYit6eKkMYAX9ClvhGXFJjqn0bt2N3p+68l0vda7BftIqV10nku3GQ0VoUh48kXa2c9uHgE5LUd8vCfw0eyl0gzKKAryD5e8p4SsREpkBcd74AJH3UoUT19iZVvKoS29Mef4IeazVU9oWClHPLZ+hxoBk22AfakcnTacHP5hzHI6rIuh/kQ16FKf97rBLI6fe6qHWn3IvdacxfdVmqlpY1VHffji62LJRwbaSlTUvZwE6g/ZeeimL6boGPCGrqAgFL31Lo1W2STbux/NKbwM/X6U36WBjSCIFnxmMl+qx+urUTcNN2vGXSuLABwE6tGIXrqWeNdsNlTYSzwyj7UWTH47ejBFKgVy3q2KrWLdwtZOPgo84hboC3cDvC8AKU2V0UCxXk/sIqLUqcEEqL8DEln5Gqq1XXxMnrvwAJ2tEYvXzDryMjRwJNl/tEh9
 /gslRX1x
 mA2hf3WOvgmR1WLmcdHxCM5rHH0p9wiu5cgcZ69kSnogGjAJnw2HJXhzgM1r6fYQnkUb3eCre98x6HF8Fx1pOca4yKXGnaib1CFKNPazyqsZYhdv77gGdc2eXQSbBxtppToCbcAic43eZa0gr2JrG/stSf5C5wTU0yLRWV+oYeysHvxxJfQ0FvVVuOhZ1n3Se9yNnAZn9rFVqZUGveHFgvZmTg++jHQL8UlQ6ijMSua+eNjGMQXfkesJKWkm5oa7Uk6AKK4/T+CXHAP6NXwHA9Pe/A84vrzChxWch6jXGSDQj/lQca+dHTpZCPsvXKHZg/ApkCaXCxa+a/pmav+Oh4obIQwpUOS6TCmJyU90mAUiLo/C/1njnJymSXcPurBmoHOwnMXqaAahRlgy7Y501T0nnmcnxuRXJz/qzsgG19iX700X8H+oM+ngADCuYhEoujBPA/Pij/zcRAJxLY0re6X4zuAZB9q9uxPDU/3WgFpfy51bFeWamRk0dk9MY9rpkv8SrkG4FtCkdIetU2ulXbt0REn5q33Ow+pKp9Jw4HT6xaJIlDCTQ9JitJfUT5sY7feEywE/4MewTUdta+0oL0vovbFEL0HCUwdyj4y5voW5NyxRgwaok0r3je4SWoThS/+1UO0vQBGjDqAqEuJqv7P/CzdHsqeBAGB2OQIKRX7XSiFEd5Bvnu9nRew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/14/26 4:30 AM, David Hildenbrand (Red Hat) wrote:
> On 1/12/26 21:22, Pratik R. Sampat wrote:
>> Confidential computing guests require memory to be accepted before use.
>> The unaccepted memory bitmap maintained by firmware does not track
>> hotplugged memory ranges.
>>
>> Call arch_accept_memory() during the hot-add path to explicitly validate
>> and transition the newly added memory to a private state, making it
>> usable by the guest.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>   mm/memory_hotplug.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..8cfbf0541430 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -38,6 +38,7 @@
>>   #include <linux/node.h>
>>     #include <asm/tlbflush.h>
>> +#include <asm/unaccepted_memory.h>
>>     #include "internal.h"
>>   #include "shuffle.h"
>> @@ -1567,6 +1568,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>       if (!strcmp(res->name, "System RAM"))
>>           firmware_map_add_hotplug(start, start + size, "System RAM");
>>   +    if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
>> +        arch_accept_memory(start, start + size);
>> +
>>       /* device_online() will take the lock when calling online_pages() */
>>       mem_hotplug_done();
>>   
> 
> As discussed, for things like virtio-mem or the HV-balloon this might be the wrong thing to do, but I don't expect these mechanisms to be used in CoCo environments just yet (and doing so would require enabling work for them).
> 

Ack.

> So I'm fine with this for now.
> 

Thanks!


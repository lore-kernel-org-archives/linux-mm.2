Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D144CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117346B0005; Fri, 29 Aug 2025 18:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C85B6B0006; Fri, 29 Aug 2025 18:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED16D6B0029; Fri, 29 Aug 2025 18:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC7F26B0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:11:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EF80BBF5A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:11:24 +0000 (UTC)
X-FDA: 83831192088.23.CE3F760
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8170640004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:11:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="Sqd2/1zc";
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.101 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756505481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMB59pMOOUKrtw+f6n8uSoIV7MrtbzoGdzscsB72pec=;
	b=h8hUVIcOBGbps6bDib6DOH8D/Vn4bBm+1u9ctBW5pRQ+fLcHJdzYbTO3cVM6XOvotSYbfG
	oEgxpQDNs0/wdMY4cgJ9/76qdt+7g3sfhhkdMt0HWWexqwZSnh6UO/lzw5hidH25qWf2f/
	2USEDQJXPxtgNsyQCogh7BZZnQNh4uI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="Sqd2/1zc";
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.101 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756505481; a=rsa-sha256;
	cv=pass;
	b=rZRVkyy7Q474uq6hq4nNpm7GqzfO9N4Q3FLG+mVSuoD+XTqeC/710m6lP3XT7rr3u83yvx
	Yfhw+rYAnanfAag+VlaVaGYH7WNYNkFMGp9UZNr1MpB3tMCwfO84TEahwa5G3g7i4PEo8Y
	pH0pINlGcwwzGoIAIq8V51SEp57D8gI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQz8elbsxsnLR7x11ouHLxNPRQ+YwN+wNDSiu+0Dn9MOV3J8oO3Dn3SiN3FNYFQKpzGu7+kRqi26bHwqETbGyZxmA7YWpdCw1KMER8GmBSS4MbIK3OwPhukLAuzmDReaJFtpcQIc0gtwDO9LYq8JIXVq2WPATza026y6DXYtBBdqktSsFImd6EBYDZHvkW41Yp3yrl3aB8JH/uGlXwu1wZ1QZrz8Dmncb5emGCTa1CFgCQG9RpLtmtejnESeckNRlhZmseUtKd6M+q09bsqBUhxFI8FrKN0f+W2+aVjKOxCt19K+rcjtVmZOQVlQ99yU6pOGZxVRrG/rXI2L35nc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMB59pMOOUKrtw+f6n8uSoIV7MrtbzoGdzscsB72pec=;
 b=cNKE2zo8resMsGwUCY8voWBjFFVXFxc7gpBOIgcs4sxSgF4yGpBbInb+HWYc/yl5pLZDAhAzfNwTQQAX02uror9NJvBEb7cQPfcvVmlHxzg8bOR+V81fgyv+1CABJ+V/v4+HuWb1jXyiyFVhANMmg8zeM491vOkz8LvzuZMLznn9cEAHd7XGzVE3nETUlEQnosggK/so56QmVAtRnm2YFHwgitvl0lN4wXrZj9DJRK9iCGyyzm6eN/oiJLkCtSykF91v4ioJL0KjO1egQcXNlPP9T07iBuHUet90rS/hS8nmDRXaXpyd7xxuV4xG3AjYgUNHGVjs3mYd+ZdNbXApFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMB59pMOOUKrtw+f6n8uSoIV7MrtbzoGdzscsB72pec=;
 b=Sqd2/1zcICHVretgcQiNyj/UlS8MIlDlX3axv4PN2sw8JC/9vYFpr9fZYdqDQeFalD7aHeZ3e3nIpZHOj0iUl3WgkCg2HV4eEe6nXNLakfBaRb7F+xAOSlIjuQTOzAxOXN024qwN6bLu0IHpkSLh0jKGrCJ0fTJ4ejEkBikfQYg=
Received: from BN0PR01MB6877.prod.exchangelabs.com (2603:10b6:408:161::22) by
 LV2PR01MB7693.prod.exchangelabs.com (2603:10b6:408:176::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.21; Fri, 29 Aug 2025 22:11:15 +0000
Received: from BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0]) by BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0%7]) with mapi id 15.20.9052.023; Fri, 29 Aug 2025
 22:11:15 +0000
Message-ID: <e004718a-52af-401d-8f22-c425948dd3ee@os.amperecomputing.com>
Date: Fri, 29 Aug 2025 15:11:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] arm64: mm: Optimize split_kernel_leaf_mapping()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-5-ryan.roberts@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20250829115250.2395585-5-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To BN0PR01MB6877.prod.exchangelabs.com
 (2603:10b6:408:161::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR01MB6877:EE_|LV2PR01MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e7d43f-bee0-4564-67af-08dde748f824
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2s2Mmt6Wk1GODN2ZHRaT2ZRVmZYNFhSdnhTK1dTR29yYlpoY1k0QUhCTFJM?=
 =?utf-8?B?RTVKamFneWoxQ1ZUcXAybGpMTFBBWjBQSi9DcEcwSUp4RjNUZ1BCUnlndkJY?=
 =?utf-8?B?SzZrNG1Gd0JVSGdOZ1BFWVQrZVp4Z1QxakpWSkY5RURwMTc4SXp3K0dtMWZW?=
 =?utf-8?B?Ym0va1llc2Z0WmlLcHFqVWZCaFk1S01zSGlZcDJKZVR3bzJyQ2YrV2crc0wx?=
 =?utf-8?B?cGFsQUtGQmRpaTFhYXhyRzNtRm9lTU9HWWMzaDJWdWEyQnh4YzBPUkM1Umtk?=
 =?utf-8?B?RXlUa3Z5aSt3cVJhTGZ0ZzBsWHA5ZGwvbDVwMGlyMkovQWtVRkZZeGVBbFN4?=
 =?utf-8?B?TDh2am5iTlN4bzgxaFA2bGFzbXlkTU54dnBQUEJhOEEyZ040WG15ZHpka0Jl?=
 =?utf-8?B?ZVppc1FZYlpWTkFUN0FHbC8xeUsrY2RnRnQreDJPWDNjeUl6NnA0eW0xeU5y?=
 =?utf-8?B?THVPUE0zVGYzbzRIRlVFakM4d1BVNEc1bnRwQll3dFlPSjRrL1BWMWhpNGJD?=
 =?utf-8?B?a3NEK3djWDEydE1BLzN2QWNpVnhNSGQxQ0F5NHI5SDQwak1ZOHJVUlZJbnVK?=
 =?utf-8?B?U3dudVl5NlU4TktPYnJQb3hvQ0o2c1NkSWxuY245VGFaODl2RFpYVVJ6a0th?=
 =?utf-8?B?OWJ4SFhqK0gwVVRoQk9kR3UvdVFGOGZLRUNXMnBOZU1oNm4rMXhlSGQyZ0RH?=
 =?utf-8?B?d1VyYThyQzJZRWhmN3JtemFWLzluSmducExNRHBZaHBBMkdJenR5NlpXK0lN?=
 =?utf-8?B?cVFIT20zQk5HSFBldGtXalROdlcvMmcrRUxUZnlPd09DaVg3WEhSYk04aHJp?=
 =?utf-8?B?Ui9PbmVOZ1ovMHNlRjQyRTNPdmFsVEhUUXR3MHVUNnoyTi91ZW9DOEFENmla?=
 =?utf-8?B?ZEtidkVwdEhmT2tiejNGZXZpZm01V2ZkZ0E2d3FjZk5ycE8vTEswTVJzMlNG?=
 =?utf-8?B?Y2ZyTFlySHJDUVUwQmNRWDFOY2RPbFdnSFg2YnVVTFhmRWRiSFk4NEMrS2xx?=
 =?utf-8?B?S3JEdTk2bTVNODdaalpSdnNkMzA0VjdLdDRPRllVR1Jsa2N6alRpVjBrRVFk?=
 =?utf-8?B?emJrMS9LV2ZxRHA4MnduR29wRlA0Y3QxYXZocEQzMVE5S2s3anFVcHp0TGZV?=
 =?utf-8?B?RlYwc1FTRGM2dlU2Tzd3VXlCZTlYZ2ZvU1kzSjl2UWExSi9iZlluNTJLLzRp?=
 =?utf-8?B?ZWVDckVNcktoSkY0YVIrOEJRQk16eUVwSzhCUEhWeENjSUJzRzh3WUM4ZDRQ?=
 =?utf-8?B?eW5JZTBiRTdEMUNGblBxWU1yUGlIUUFub3pJd0pnSkc3UHNpOXZ6VUY3L3Iv?=
 =?utf-8?B?UkRZSG42UWJoNW9OUWVqK3hQRWJtc3MvVkRjZU41MXBFMzlaZEN0UEVnNWFT?=
 =?utf-8?B?L2tDL1JrY2dhd0QyeU5wc2tkbTRVUURxWWRKRFNkaW80bitvZXJ1L2hCRHhQ?=
 =?utf-8?B?S0NBZmFrVmVzamhkc2FJbU15ZERqUCtRWWNwa0xTY0ttSGZwUUJvUnloaklN?=
 =?utf-8?B?QVdjNjc4Skl0dVlkRnZlWEEzcTdNSE8xcFl4WUV6VkNxekszWnh6SXpuMmJz?=
 =?utf-8?B?UDE3Q1M5Um43bjRFaHZvYnY1M3dsOG8wYlFUR2RQS2hTL2s1Tk5IdlRSa3Rj?=
 =?utf-8?B?MGRuTDVkOWZBVGVzNTVScVREemZvekdHbmNFcGh4dmRQNFBwN0dJZHZqaHRK?=
 =?utf-8?B?Ry9YRm5OQU5PelVsSExhY2JlRTQ5bzZnVllxUXlYRWYyaDNHUXhFY25ZRS9I?=
 =?utf-8?B?Tld0NUY5V05zcEdIRUg2d0ZaaVpPamZheEhxYjYwdDdDOVoyM1lLeUY5dVFy?=
 =?utf-8?B?eE05MjYvTzlVTzJIejBXa3NsVklmVXpnV3BSb2J0U1kvOHEyZTljZG50SWVn?=
 =?utf-8?B?NHFIUEFjZVlvRUV4T0xudlNEbXdRYit1TS93NGwya1ltNkcyc05qcWRXTkp6?=
 =?utf-8?B?WjRjMlRzWkZxbDc0UjM5YW00VVVvUko0YWYvZ1JnVW9TdzMwVk12cnNadnBw?=
 =?utf-8?B?TzdTMWdFekFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR01MB6877.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFFSMC9kK2FBZFVCeDRVNXlYSzY2cDBRZDRkY2FNLyt4Q2R2c2hjUVpzU1FX?=
 =?utf-8?B?NjZncXBSaFdvbzhJNEdlSTllL1N2T1FRT3RlSDdwMmloOElqWHBYeGJRRXA0?=
 =?utf-8?B?aHRSOERmZENEVjduNE1tZ0JUaFVnYzg3SHlsb3JXZklSWHJkMTZYNFlWR2U2?=
 =?utf-8?B?TkFlbDQ0Y2g5V1RFVGFkVXd5aHRCVmxQUTVwYmdkSjB4VjVKTkNVaXk0bnpo?=
 =?utf-8?B?bTcrcEhtbmJ5ZTVKQ2hjSXVOZnB2dy9VdFlWVEFVSDVnVG1ObHlWQUNKRnBq?=
 =?utf-8?B?UWpWdXRoSlloNytlQ0MwbHFxRjMyLzRnU3NublZXTFRXdFlWZmJIK25JU3Za?=
 =?utf-8?B?Y3BTTFE2SUEwUFRzZjFVelFGMWNtZ0paMURaUzZMLzBYQ04vM0NSdlM0NUpX?=
 =?utf-8?B?NERwVU1pOFBhVXlFdWhJUHVMdjhYdTNjRE5uYkhWWVdOcVZIOHJYeFdrZWJv?=
 =?utf-8?B?T2UxSkdvRUY3UEgwaVZ6eUFXaXVsNEFUMmlTang3eU9jRnhQWlBrYVUrcGhY?=
 =?utf-8?B?R1JiREVYVGRHK0FNQXJDTTVmVFRIaXRUbWZXbm5GQUlmTlZJc0tUTStFdUds?=
 =?utf-8?B?b3JDTnJ3RjdwNHprWmY0K0pPZE5nN0dGWlQwN3NJOW1qMFRvck5kOVp3MGp1?=
 =?utf-8?B?S2ZwUjdscis0Rlp4SSsvVjJHWlJFSWVrcXFNQ3k5NXpFY2NZTXNsYmJ3bGpi?=
 =?utf-8?B?NEI5QmczM1dhSEE5Tmw5Rk1vZWdzekZEYzIrSE9BbE0vcVpvNnBRUnkxSjFV?=
 =?utf-8?B?ZFZlUy91YWdsNTVCbzlRME1TVjg5NUxpcHVqMlE0WFVXNUwwaGhreWpzekNa?=
 =?utf-8?B?bDFjTHFQdmdnNThsYWVWU21BOWhBTDdxTXZYU2NxYzlwZEhuREdPck4wYUtW?=
 =?utf-8?B?aG85RVVVZ3JGVSs0cmlrbFF6T09EVjBGSVlJTmE5Y3RybTAyWUZydTRWbVZP?=
 =?utf-8?B?R2FqUlBkTTFxRnNETUtsVWx1MlRlTDZBVUF4aVRWcUJPU2x3QW1CQjJLdTdR?=
 =?utf-8?B?blJjSExkdUp4eU1vZXEyVjlvSVowVC9wamZsUDlHTTRaS3I1Wk1EMkNGL0VR?=
 =?utf-8?B?RDhlS1ZYdC9XdENxZUtuRXc5NVArT2EvYWNPd2hva2g2MytGYVZmMFZ3QlZH?=
 =?utf-8?B?RzhSTXcyYmg1b0l0M1VoVnJZUEs5R3pKYlN6ck5EcnkzOTNFUFNsT08yRFpr?=
 =?utf-8?B?Zm1Uc0xlRXExYzVrZHhSYWhKeEErRVZSaWcvQzN5R3I5SDYwa25jSWZBeTcr?=
 =?utf-8?B?blZ6Zm9PekpxT2dMalBJVUQ1R0ZhQ3RabGd6c21GOWZKWllXVmVtaURkOTFW?=
 =?utf-8?B?d0FqMUdtNm1sQm9aenhSTWE0VlgvM2VUNU1Na0pibnQyMk9kMjZnZ3duTExF?=
 =?utf-8?B?M2FNMk9MYVgyb05PVVJHT3JMRjFnTUNqTnBUd0UrTnNuOUdOUnlkLzB0ZTdS?=
 =?utf-8?B?OEVIRVViNGVxdUpjWk1jWXpKRlBqVnpMeXNSMWZUa29ySlJvS3ZqeXhXb1ph?=
 =?utf-8?B?dHdWQ0hzZko4NDhCd2srWDR2U2FKUURxYUlxWk5jd211blVzdXdncmdwekdx?=
 =?utf-8?B?N0xBQTJmMmpZV2tmTUFJVWI3NjZDZE4vdmRxUzduTzF5YW5RMWRBeEpnOUpQ?=
 =?utf-8?B?Z3VLT1ZheWtNUU5UOEEwUmYvcURWNFhvZ3JUWWZmWHR5a1prbUszVkhic3o0?=
 =?utf-8?B?L0JocW5RVENqaTVycHF4aHFpNGU0bVRPaUlJUE9GVVhEMHpkUXFyQmhFdHJj?=
 =?utf-8?B?MVpFNkltM09kK3JsNWV0d09XTHdQSERmaEl4NEYwaHYyUDFsbE42SmNPblhL?=
 =?utf-8?B?djg4cGVzWVJnVnk4cnAybzFpbkZid3RsMjVuQjN0OTVjWXA0dDBXTXpWVWtY?=
 =?utf-8?B?YmZNb1ZTQis5QXg0NWI0b2Y1bVJSQzlrTlFIOUNSbUozL0FYQ3oxd28wQ3pB?=
 =?utf-8?B?QS9RMERxYno0MWMwK2pTa2k1N0x0ejNpcTJoNHY5K3gvVzEyaElVQ1VQTW5Z?=
 =?utf-8?B?QUxweC9yQXhWNFk3YkdITFNScG9LTWR1Q1BoakVwdnFhYThXcXZjd2dCNkxp?=
 =?utf-8?B?SFhEZ0xTL0ZVVTk3VUtPU1oxdGduMGhFd3A4c2plNXB1c2dCV3B5b0IwZ1I2?=
 =?utf-8?B?VlRZUFNQcDRPRnpQWDRRR2wxelpYa3NvbGpUZWg4NkZPOWhORHZoSmxxUHJn?=
 =?utf-8?B?elE9PQ==?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e7d43f-bee0-4564-67af-08dde748f824
X-MS-Exchange-CrossTenant-AuthSource: BN0PR01MB6877.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 22:11:15.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHhacqlxvJoiB5BJiCXAndbcUZDZY40bd6wuO79nB9sB6dkfzTskXR9eikNGUzwiax3yVL2g5vYy9WPMVDrHVspKUV4/g0JOUoGZl+kbEA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7693
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8170640004
X-Stat-Signature: y5yd7ke6hkkaxn1inphusmn149nnj79i
X-Rspam-User: 
X-HE-Tag: 1756505481-554195
X-HE-Meta: U2FsdGVkX19jrHeI+dCGIibm8LEKarg4AuKBF0tMROhw9vHCh9FIbZ4dS8Xy7V1Z/QQI+8p5cbizw4WuABSbC4yWtuxtiDy3+XHp8zFATA3tSkbPjB95XzGbRz4i7fegN0+iotypmx76SbiCBf29njDEdTaSol5na9YK5Fkxky5l14Sq9mzuLjTHrDz+6oo4R/lae/R0jNtU1jtXWHxXWBr3qP8mjxpjTvvvDGNkLEVuvITAdbtSH5Sw3pSSHd+d+YREClSqMd/qHAVXeISnQSYGp/6N34fBdktUBXCNtDOLCc/USk6aJw3PaLvsed6rZ55Z5ZHDBHR46dnx2MAqhb68y8kCtnqMiDzRVAl7dvXAJ8SXWOWt1/oQp62n58fRfd+KNs2MiXe25INJn5ez00DIeDo+5VD7Dw6VxfqFuOPl6ZEVS/oE2Ye5wRdP8JkwuKlWMDoKpMaZCerwWIvA1D5gTELolihzCtQoa6CnAA6JjsuO4CLCt7R+7ZmSCBMezznavpNicQEhhI8g+JjNWlXbNeWlNF8aUWpJPsWGDSF8wYIAK4WnDtsReq1QvYefltRKwWA2qjAhzDaHyFU9PbwS96j2low9asPmEjlB8wCvUCes2oEshM5iRPXfHxsaM4T9UfCFY6pffQ0BJSzWUszuSbJFVmpzaaRq01xxPALWeXb9IKUXLwavqvYhSIPnhXXiVAdXLF8gcu3LiJw2PfLD5EDHNNFc8Zkwt2LFT3xAZg//uS8wQUbV4S4hfBQdQFwYasNpli3RaB71sFf/2ekWknOtT1nx/AFJ3vPof9uUqlQhy2H66V29V1kBfWfp1PT5J5KsnOxbSIwlrglYPsz4AtSE4t02fAjxBuJEq9ba9JF+O44befZf1ZtkiALbmen2kJRZvk8e4DqJhsGtugUNxDspDXtZT4n30T/qft3rQqs/U3TAFCCHDYvHrfI9oBirWn77js/NDIdQQY9
 SbST4CMn
 yJ9eKEN+J54NlLuZsM6d+ppNV/+jhagc5rn/LVwGt4Ourpj16GmFg08Qn2G9gcjTuzb6ez4lQwRk8kl/tsaHv4n4P3FeRcKEceHcg3OrPacC0moP2e933mZDKZyJnOEX8nFri3MO7Bep4qpzJLzjtlxFR4KQOVMtX7Q6OUz6bfHhJwQMBoo62T12Kth0Ph8Hm3kBoTwcG80wpZ2CCCBVyJsXDIEsApplUj9Plv1Y02Pgpqb1cyBMNvTqEel682x42Xx9W7ize1x31wAaqpwabsNVhuvwOq6OFYj8be8bgADmgfWmY9ltRNtQodpmr5noXCubU3WgcYuo035i8gbyX3J0V9WxZlL4tn5I6wGNelqTbPkCrRnWgBUNCvYqxmnGh4LVF2MX7tyJZDGhmDdY+1i+13vUd0c1Ru4KwdahIFm/bc3NQDldcwwdG0DV2yG36QEU4f35Rm3hTmaz5ibhtmV8oq3JvJ16CDAKcoCJt/Je7daB/HZlJLVMidcjKjyxjBmAZ+ra22K8T4MNj+Q0GE5mZUy8xXK3zHumSYsaKE4E2gUGsRHx1Dqpg0bOnX06YrMpX+GIuB4WMzfrflJZTQLyC0aZu8Uxglj3tQPjT3rDby+UlFqWPLBjGTLbuVrn+4DQ6A3UgSjvzGX8wnEKPAmoObysKUAYjWny+PQbvf9za1FeMRaUSBzPblz28AC0kCHm9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/29/25 4:52 AM, Ryan Roberts wrote:
> The common case for split_kernel_leaf_mapping() is for a single page.
> Let's optimize this by only calling split_kernel_leaf_mapping_locked()
> once.
>
> Since the start and end address are PAGE_SIZE apart, they must be
> contained within the same contpte block. Further, if start is at the
> beginning of the block or end is at the end of the block, then the other
> address must be in the _middle_ of the block. So if we split on this
> middle-of-the-contpte-block address, it is guaranteed that the
> containing contpte block is split to ptes and both start and end are
> therefore mapped by pte.
>
> This avoids the second call to split_kernel_leaf_mapping_locked()
> meaning we only have to walk the pgtable once.
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>   arch/arm64/mm/mmu.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 114b88216b0c..8b5b19e1154b 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -740,9 +740,21 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>   	mutex_lock(&pgtable_split_lock);
>   	arch_enter_lazy_mmu_mode();
>   
> -	ret = split_kernel_leaf_mapping_locked(start);
> -	if (!ret)
> -		ret = split_kernel_leaf_mapping_locked(end);
> +	/*
> +	 * Optimize for the common case of splitting out a single page from a
> +	 * larger mapping. Here we can just split on the "least aligned" of
> +	 * start and end and this will guarantee that there must also be a split
> +	 * on the more aligned address since the both addresses must be in the
> +	 * same contpte block and it must have been split to ptes.
> +	 */
> +	if (end - start == PAGE_SIZE) {
> +		start = __ffs(start) < __ffs(end) ? start : end;
> +		ret = split_kernel_leaf_mapping_locked(start);

This makes sense to me. I suggested the same thing in the discussion 
with Dev for v5. I'd like to have this patch squashed into patch #3.

Thanks,
Yang

> +	} else {
> +		ret = split_kernel_leaf_mapping_locked(start);
> +		if (!ret)
> +			ret = split_kernel_leaf_mapping_locked(end);
> +	}
>   
>   	arch_leave_lazy_mmu_mode();
>   	mutex_unlock(&pgtable_split_lock);



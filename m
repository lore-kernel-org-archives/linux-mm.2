Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6803ECAC5B8
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 00:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF758E0007; Thu,  2 Oct 2025 20:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596EE8E0001; Thu,  2 Oct 2025 20:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485388E0007; Thu,  2 Oct 2025 20:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35F728E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:25:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5EA644EA1
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:25:06 +0000 (UTC)
X-FDA: 83954908212.08.1A0122E
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3AC21C0014
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:25:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVDeeeV4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759451104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV/s3QpCW+HV72dr3ORsItz62d+xRHuUwzT8ez15XzE=;
	b=i5yL3OVmCQxpMtniLi1Bi49Q3VAHbCqfEdBmqcmfUxDnPjZMiuH79/KcWUXCcbLpmSqrBU
	N+bMA1n5fcM4ZgGgQrqnIBXEBoPG77EymdLF2WILWoauymWsi+/ALtQwVe01QkQvufdX8O
	4aeR1y2IrUpeOB+rbWJG/QNCkDM1u+o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759451104; a=rsa-sha256;
	cv=pass;
	b=zYK2CuYDvxiBwoxMkgwCiQwfcyxfGqOIpX3LvrFt0nNm7MBr+xXyS4PnlHitV2XDbey8Lg
	SCN1lPQp9ntvQfpv4uZEixxQaBpMobOa+K8hyRWnv9qd/wVIFaxyz75hxNy+RNO53sMvKR
	b8DplztbbRpYecXq1nKz9kuZr9YMf3E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVDeeeV4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9BG7puUgqelUfKpEDAz9b6Ik8oWKGAx1tV+czwm0Nue7ASydDk9SJLT1UkS+US+YDsI/fPn8aZjyKawp/YtJeHuRas1kmbyc+miuFGdjQIWtfH+o4EppnEB1MYnnMVz1w13tbVCHEG0mm1JeyXpc4D4luvJyktMsCyhu7NvhTTGbWE4MwqN+bPL+FBS7E8v7sxoyabE3dwjajdg2K4zzitwJc1lSTERMXG6HmShGDfD3axc+GArHH65lBneZ7mvSnFkl/gt8epDAU7PVRM05P+wNsvzkcG1A+IumSP6CUf3O0ObdaCPpfyEXxbK8Uwb0F9QGH7lXIuid+nVQPTEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xV/s3QpCW+HV72dr3ORsItz62d+xRHuUwzT8ez15XzE=;
 b=V/I6hrsL4er0OwhkCLaBMwjMs6xVkFVfyh1DihAwXqjGc0vH3eH2zFy8ZPlwv3OU+hLwWVViid0noYI/LUMYWZaOE5Pn1vyoD8ugqUuMOxOuBZqEm+A3UXEDmGjJ/t0/ndPGEe0PBK17814KBwQn7oVorpwq0gRi3WdF+0UYeAVqtxxYbfCvIp/S6sxCNpb/X6UZu7bHYaeIeyWsTUSLSdEbmPXB5jvYdzPRLMOhmSa2u6lNQU50uf2XZV0eGhkwSdSJHAghpFtoTFbFwL+3aJfWd823JR23JecHIGbsWGQuduh3t67t0Xf+PJvL3ewOMaSniUxM2ZdVl5FV/OgozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xV/s3QpCW+HV72dr3ORsItz62d+xRHuUwzT8ez15XzE=;
 b=bVDeeeV4/+c4YvRPg1ysVnZ8ysa0jx7l/9qVpzI4Bsp304i7BSSQV1OeLFQdpT1XBLmcRvPF1HrC0aQsD1oB4uWV6K9cylGtICwh6e1bKFn1pS9pNX0t8cP2sKISSjUSEmvX5z6rfPvP/zxnCA14Owbmf8CmQqRKmrMAUmqXGFAzt77Iv6pCeFKvBjQ3Sgg2EBaVAji2uanOtAGM/W7a5A+QrpgM7cQoy03Pks7pySQhh/HHInszWKPcJmsPtYPKe9hp1B4kNz0AGLJKZHyKgX45ZF5W9NRZ5zo+9ixQ7HaJIE2N6RGukA+VHqREp5rRZ/zcRXWrhB/yXqXaw6PDaw==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 00:24:54 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 00:24:54 +0000
Message-ID: <cd2ea7d4-6b12-4933-b1ae-cd4db18d3671@nvidia.com>
Date: Thu, 2 Oct 2025 17:24:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 rust-for-linux@vger.kernel.org
References: <202510030449.VfSaAjvd-lkp@intel.com>
 <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
 <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:a03:333::17) To BY5PR12MB4116.namprd12.prod.outlook.com
 (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|IA1PR12MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: 16d18686-4591-428d-e01b-08de02134682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1VySTBLMWhSd2hmMURwd0NPRjBMTVRqRjROUDVnbUhGbHVHNE03MWdnNzN3?=
 =?utf-8?B?eHFmd0U3K0RiQVI4d0NhOE1NM0VYZU9mWU9MeUp1NnFYVkVDYWxiblZzMUFH?=
 =?utf-8?B?Nm1mN01OMllERHdEN2s3aWttc3JJTlNkNk5lS1o1RmFNMzhSMnhDNVNZbDBw?=
 =?utf-8?B?MWNaQ1UzRXZ2TGxsbytUR1NidXVQMitPTzYrTUp1aThEd0tjVHpXbUpuTU94?=
 =?utf-8?B?bStiRmlhTXpEenBvODg5aE5SZStiQlVxTHRXa05hU3NQQ1ZINUtUSTh3K3V2?=
 =?utf-8?B?WmZGTVU2Rm8rTTVCQjhBend4VG81Rmh2Y1pSeDNQZjJpbDdaZXd0b1BiNlZ4?=
 =?utf-8?B?Zk1jUUJuZ3U0VWpaaStaRnVqV1B3RTFpcWw2TU9vYlIzRGh1czVkcC9aUmRx?=
 =?utf-8?B?MUNGalRtWWxTT2Jaa09ITEdCY1N2K1VVZWMyUXJIU2ZQRTZSQ3djV2lBemUw?=
 =?utf-8?B?TE90RmFWVzBrM1FqbTJodCtKTVA1aEh4N1dhdDBmSkdEODZBb3ZMR20rcUxN?=
 =?utf-8?B?d2c0NFkyaGtDZ2xyODZrWFV3Y013UFdIRHQwVUJMdHZYNGZvNVFCd1hnY2lu?=
 =?utf-8?B?d2N4RnV5ZFlSWTVGbHlLTUd6ZTVxaW0wVFE3Njhpc3pzSFFBL1g5d0hpTklD?=
 =?utf-8?B?WUxIRUZtRXp1Z084ZG00T282S2k2aWJNVWdZWVZVN1I5Uk9haWNxcDJhYlIw?=
 =?utf-8?B?UWYwcURoQjJwcUY5bnZFaVZnR2ZRdzhJRXAwNWxWSmh5SDVmQk52QVh2UkZn?=
 =?utf-8?B?TWEwMkdIYnRCbFkvcW4wYm11ZUFCak0zU2paWkN5TklwdkxNa3A5UHVxS1NX?=
 =?utf-8?B?ZENVdGVJWlExWVFmY1pDeWxuSUloUHYwKzRKOC9CVm1FcTc5cWFhbkdrZWNp?=
 =?utf-8?B?bTZlM0YvTWw3TWxxQk5aNTdMQTd3K3ZVN0lqVW94TkVSQkVuZjRua0VLbVli?=
 =?utf-8?B?cy9lQWY3WFIzQVBMakFnUjMzTXBKanozbURxNlh3LzhtS2d1TVk1YWk2K0hz?=
 =?utf-8?B?UGhzVUo4ZkhQQzhSelpveCtrWEFpTXBVRzEzcmNEU05hbFhNTnBMVTNtVzNK?=
 =?utf-8?B?NzB6WDA0V0llbFdBc1ltOTYxWDBSTTZaeUhCaGNkL3FjSkRWYzU0OXZUWG5T?=
 =?utf-8?B?Z0pBcnU4RlFZWW8zc2tQcmVDOVFZNUowWTlnOWViM2U1eEplM1ZXWTFKWUtw?=
 =?utf-8?B?NTVneXhqbmhCaDBEZDloQWNoL1hUVmhJYW5HZ3dzMFNLb3htWldJL3hiL0M4?=
 =?utf-8?B?aU90MnBSdDY0VTQyYWhjUUlXRmsycUEvS0wwdng4ZXVsZWNhaGhGRlZIc1FJ?=
 =?utf-8?B?ZkVUQ1hMdmRqeS9aY2NySkxFbDJ1Z2s1RUE1dW1DQnYyU1NOZDN6TkZab1Jn?=
 =?utf-8?B?ZVp5SHI1YVRncC9QRnZVUFptSnpPTVNTaElWYkdsUlhNM0FxdWl6K25XMEJi?=
 =?utf-8?B?aVFtOStkNHM2R0ZWWkk1S1lxYkVQZVBObjNhNjlLSk9vVjV6Q0RMZDk4RDZ1?=
 =?utf-8?B?R3ptTWNvblBGV1lhTVFuQ1RxMC9mRWEyMWFOSEh3YkYxMnlUYW5tSmxIWG9V?=
 =?utf-8?B?NWhWZ0JsT0JyWjJNM1libkpBUk5xZjkyKzNFTlVkSStZL1NKSG5DT2FNcXY2?=
 =?utf-8?B?cnAyaVlFRlhyVEhxZ2FHM1h0bW9Ea2k0NGYwUUdxQmhHUFZkRnRJMlBtenhY?=
 =?utf-8?B?OTFjc1BPOEdwYlRoT2wzaDN6RDAxWFFINmpQc2VBNWMzZWlQTUhFVjdQMDJS?=
 =?utf-8?B?THd6T1FQY3Z3cnl0VXV4SUtMTElZbDhuT3lJOCs4RTFPNEUrMmVzdS8xRU5T?=
 =?utf-8?B?Vlh3bklRejZIQXV1SkthUHp5RkFBZmo1SHFXcyt4K3R5NHFrNWdvbk1ZRGRN?=
 =?utf-8?B?ekpYTHQvVWVHMUpva2MvbHdKa0huL2NWS09ST3NaLzVKYzhDaUJSZGl3bDFy?=
 =?utf-8?B?cU5oZTZYdWhseS9RQWEwU3EyRkRzRGh0Mkx0KzVGenlTYWpkUHJKVk45RUN0?=
 =?utf-8?B?Vmk4YmVVVjVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWRBamZBc243Ym51WGoySnMwRzUrUjFSVDdRV3dwUWcvZjZOUDdVQ0lmcnhn?=
 =?utf-8?B?MXhORmFmeExmaW1GclNTWEJmY3dwbjlSS1FUTU1RSnBiRHRXeVdpMWV6ZFNI?=
 =?utf-8?B?aTR1bTAxa3VvNXEvQjQyMDUzdE1rcjZLeDdCemRrbjRZVUs0Vm5nVm8yazFT?=
 =?utf-8?B?LzFwZEdVSHowU3ZzeG55cUJoeDk1ZHZNbXZkdm9ySW5JeXJKcjFmSlFFNy81?=
 =?utf-8?B?UlI2eXRnVzc1WjkzMG4ySk1NbGgyaFh2Q0ZlemkzVUdvRVgvNWg2aXYvVnFV?=
 =?utf-8?B?eVk4NkJVeXRTMHZIbkw0bzJidVVvZzJUeWNsZUM3NEZ4bmlpSEFEc1VHODdw?=
 =?utf-8?B?YUk1aXIwazYxYm1sYWdTcTBzNmErQmJCTU9ZcWZqb0tTVmpPUVpFdmZtOWd3?=
 =?utf-8?B?TDhxWXN5K1gzeVl3ZnVYQmxhbW4zaWNXUy9MWExiOUNZalRtWlN2L1RpdzBY?=
 =?utf-8?B?aGJINkRjZVMzMVhrbDdOQWVqY2NjN2lGUGliOFFRbnIyQnFQemppRmdBVUdp?=
 =?utf-8?B?T3JoNWRBNmgrOGw3V1hCZDlvWXZjbjNydTQvQnc4enJ0d1BiOUJrV2prd2Jv?=
 =?utf-8?B?KzVKeEl1M2pDblB0alpDYVgyQUVxVnlpL2lQQ0lWNUE2am9GMDBFUTI2bEpN?=
 =?utf-8?B?Nm9HMnhYSi95VDFJNk9rdVBFbEhlVHB5enlsYmhmLzF0TVVzMFA5M2VnTTVP?=
 =?utf-8?B?ajdmRDcxSkw2NVVsZVVhQlhSVjRueG1JTk93aHgyUXRSTmQ0eGlObFVHQmpW?=
 =?utf-8?B?K0FNYUVPaTB4emE1Y3RMQXhpbjZrdXl4S0l1V3dpc0MwS2xUbUpSTFI0Q2dt?=
 =?utf-8?B?WVNWcjEzcHhQdVM2RFNkNTFPelBmalpyQ2F2R0FvdXBvM1N4UDdHK1g0Y1Fa?=
 =?utf-8?B?ZXBib1VBRHp1K2hOaHNFdGhQQTYrRiszZU05VDJCNWd0azlPZlBhR1phVmE0?=
 =?utf-8?B?SFZhWFF1dDVITW5NR0lyRU81SjQ5bS9nYk1BUTB3dVVFcmV0UEliYjRDNVdD?=
 =?utf-8?B?UktFL2JUMjFrUnlTajRyYVp5bmViMGlvdjJYSjVNQ21UVm9vblNqbTVzT2Fy?=
 =?utf-8?B?ZXRyNGY5ZStVeWtodnVlWWNJaHZXWFV1YjViMWN4c0hxY004SmRuRi8rM0Ft?=
 =?utf-8?B?ZlZ3UUszMFprMXlvd1gySUNtdDU0OEN1Zk5vckJuS1NOQUlqNDRvaG1WVk1j?=
 =?utf-8?B?Y0FuOURxSXFFQWxadE1wdEFmbndyR2k4WGhKMCt4MmpLUVZTQWdzdGU4dXFk?=
 =?utf-8?B?VWd3Zm5ESHJOUFpsNnB2VjZDb3k1WW5NNlJGdWZQSjNwZlZDS2JId05lL2x6?=
 =?utf-8?B?QXprMjVyTk9MUGdIYUQwbUdNTmRITm1iV2gvajEwR1F5WGZNbVlRZGhKNVZ6?=
 =?utf-8?B?bUpwdVcyeThnZjZIb2xjZTh5Skx1ZjZsQVAwMFVKVlpKRzAvZGg0QjgxZk5N?=
 =?utf-8?B?WHJUZ2VXeHIvR3RJZ3BhYlJKTjFzQ3l1Yzg4b005SjFOemxTc01BZ3hRd3RB?=
 =?utf-8?B?NExnaXNJZ1hreklxaUFmdXNmc00xTW5jamh3S0xBd1VCWVVYY0NmUEhjWUMy?=
 =?utf-8?B?c3ZrZ1QraFFrbjM3dDRZTi8zL01BMHdnWFFHeUVMdEpvby9oZXZIOWY2RXRq?=
 =?utf-8?B?VkFVZENmM3BwSVA2NjRYK0dIVFBUbU9YcHZ5dk1acmUwU0ZUMEtvcytLQVhM?=
 =?utf-8?B?WHNUeEI4aDFIZmE3enVKS2lKb0pOWXdtVXdhUjMyZ1Y5SkhDaDl4NFRaZ2Nm?=
 =?utf-8?B?cVhRbnBTYU5nWjRlRnhXZ0Z6OGlWSDREVTRrRFFzV1VRU2tURzZuVmluY3Nv?=
 =?utf-8?B?T1NHUmVrYnN3LzE2dnROQnhnZEMwVGZ6Q3NaeWhLa1YxazU0aWtFNVJma3Y5?=
 =?utf-8?B?Sk8zdHZuTFpFTTg4S2c0aTJRMkdaR29XSFU0blpUM0NNNk92MmlTNkkyMzVM?=
 =?utf-8?B?L2dqbVVpZU1LM1JXTTNpMk9jODdoMHFNLzlneVdYbEpVdFA4czBGcHBNUUNL?=
 =?utf-8?B?a0dFb1RYR1N6QjVZUmN0QkZENkI3SWlxeDNMWUNhSDRwaWlHd2ZoNVJ5ek8y?=
 =?utf-8?B?SWlySkRxL0RaV1lBK05yeStRdHMyV3M1aEx2UUIvU1FYekROTVJBbEp0Tkxz?=
 =?utf-8?Q?IUeMx+2LrE1oI8MnQXBshnSjE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d18686-4591-428d-e01b-08de02134682
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 00:24:54.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0dNnUrIk3TikYyGCZyXI+nP1FjF6EXojF+u1puaKlPetM2DKjAN9P1wfHNSX3ieOUfcAsdKyiNl6X9HSRsSXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553
X-Stat-Signature: 6rnjo7iroywkkp6bsejnrtipxu4s5hoe
X-Rspamd-Queue-Id: D3AC21C0014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759451103-205219
X-HE-Meta: U2FsdGVkX1/4T5SRReofk6JgW+1Qfv4FcVwRdP+u1kEjVCx8fMzbAqEoIyQe3iMEbOAa4kJ9f8sb3xonVCrGVeLTFjjtvegs0TPPB6+rXV/Unc0hj4fYxq0lDWF0wleGth/PvReHQUjVLhM7a2LwRVNNVwW4xx1DXrnoVItcCX3d84h4eyydJRqrOqYi6tCYSUhOcsmKcWv5cIHOOlOWTtM69HMiRCmXk8oaTx6ugm8cHB0fN72Kal07ixVSrDqolNVSUxTRgQOk2b9MxVqImA8UEYzUR9Q34w5QI5cRPUIRzgEHtAnjyOHkduVDbbZrbvHFs6jnmbheBwecFU4cB2n//AsF/9sjMPIO0y+7XE8Zg9U7DnJE0ilLE0MM1x2brmWFvQnPv/N+iIOu6JUWAWC6mmaDDtVCMHgVB0Wy/MA5H7qyxU1wermNp3FmBw6cNL7KekSfsL/tNRDPGUDLWChKAco6MNGGdGtyUCSed/wAoKrMH9c4PzbRaOvBu5NcljjcdsT24jt5pp8+Kj/1Tda9iXoNm3AQ8ZaTob+IqFU5SehqlQvqMtJkBpEOPC65rl4JuzmvOQj4fGig/nO6gZ9JvEiXHJZFqFmDOPv+cV8z7mWrF7L1octJ9nsi1FpAxqeWUI6nAuUmdxVEu+H8dnEZ3OuDnuSudKrsBlbC6OAaqWXVqSp+nEUFCcVuNM5crjNby2/0W4xsc+x+BnSW48/h7LTImmUrjOGiEFGiHUhBjEfev82pw3k9/srebUpC6CTc4+rEgYERX4WsOEpxYtD0lI45MeozDoOsVAtPvydew11MRfsx2XUzDwvriNG6D6E8kb01pQcV+kQCPP7pJT2CvkJgfYIgJa42vowT+4+QhrncR2wWEqBRrgXNQw/WA/1G5F6hXqoweilWcqTHJeaqvlAqGz4IGpA0xtnmO55vSPk0g98CXhS9hTc5x028MjmRfs/XsUGEgqaWo8t
 upI+WQol
 p8zOZ8BVQmmg+ReSwmARdUZvJSpIaZpPug2Jig7pKK+s9sBR5P1JFi4VgptJQ/iLJDYQExL4fWDsUB4aaC/zvuqZ2BZxKvqQYwkktgnWs9WprVZozG5s/YLD/Xu36LAosOQ3bZrXF8e5/kG9eNWhXVd7lTSQQCw1hOH2Zzh7L5dQJJUfhVm3Hfe/95OcsBGJaCvmgU2ZZp9O3Xg6Od1F712FY22wcUlvtn1xhG2mTgcqA7tQ7YJlLcwD7yo4ut8hSX3Cdk415JWPd9MlERgmDTh50CCDlziKUJ/EFZERa7a3gQYYoTfmrNltNSpRvCuJrmgyA9nHxpFGUVMXLcgHtoBeffZNtVJVKLtKvpSGQffB2P9M0jpkArcWnXxwBJHj3XHlSKewAz32f4zkFtu9SDnz/u+uqURkmd9QnBPxXXCysu1ZGqWF2S4OPi/6OrLu40LsZUPXejGKUJc8ucJ1z88ay9gXgpoQheLPwrhiReYkid5yVPDW0M9BivDdk3jquhb4mntYwd+6UtITgdP8152QU98S7sO26RN9I45NKMzEEtH04sb1NwvOozpZqch4aWOSXVy+6j5qRB3+c4NMHJzblVBsJM1oFXFfqPpd4lJ6a26mU8+2ydBeuIvusTAXoysnwlvts58DRRyi+bXhv7k6PX2IUJ1csNGWjJT2z6U9J47noTs7M8B9rgapRYS6/xXSqzoKixscaFJt9sckL/aezynp6b3SyNM8h5MRh3ohYum2Boz6trjTmyarjrL21J3t5JeFOpPw6+QE29bVcIOXRGDX47Az+og0W8T2qhs5fkJwOSfy4c9Ev+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 3:43 PM, Andrew Morton wrote:
> On Fri, 3 Oct 2025 00:39:16 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Fri, Oct 3, 2025 at 12:27 AM Andrew Morton <akpm@linux-foundation.org> wrote:
...
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
> Date: Thu Oct  2 03:37:47 PM PDT 2025
> 
> Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (from
> Miguel) to fix this.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jakub Acs <acsjakub@amazon.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  rust/bindings/bindings_helper.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
> +++ a/rust/bindings/bindings_helper.h
> @@ -99,3 +99,4 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
>  
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
> _

Yes, this fixes the build on my system too, so:

Tested-by: John Hubbard <jhubbard@nvidia.com>

...of course, we'll have to undo this later, as part of the fix
for the Rust for Linux build system, to handle BIT() and similar
macros in bindgen.


thanks,
-- 
John Hubbard



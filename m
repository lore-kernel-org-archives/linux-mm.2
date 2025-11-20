Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9BECF8548
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316C46B002C; Thu, 20 Nov 2025 02:03:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7496B002D; Thu, 20 Nov 2025 02:03:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168FB6B002E; Thu, 20 Nov 2025 02:03:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32036B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:03:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 505C589B71
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:03:56 +0000 (UTC)
X-FDA: 84130095672.22.495F226
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7DA4D180005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:03:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="hfrbk/an";
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763622233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SfkkoRCEOwaMC7ReeVNzaXuvFPXYVs30uu8MW8yWuE=;
	b=4/fSBV6POnEaZkvHtM44ocVytu1eUtwEaWBOHQH6/NsHozN0qtfQt3ud0oeP+V0POcXYnK
	xlBNGZykeY/qSO7hIDl5GRoSYp1ybZghsLf3iD7WAnAbyySJwqRE4Yy5IBXcsF7JyDEP6p
	lPFF1y9yF+ySRQvtMRPH3HsbLsb65eo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="hfrbk/an";
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763622233; a=rsa-sha256;
	cv=pass;
	b=BVQbcJo1in5byiJzY9tPFokRjNmX9P28vlixeR5NO1XJYTDYrieZ5En/y6qDQhIj2zC6IB
	53l1w2uNir0rofWzQAkTEQZnCZBjIs10AOJ7bOafcPIcB9/fgShdcrsEt1mckKzxIAm6p5
	Akeoy/eFuh8B59jYAdBQawu2rkYvxG0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbfiCb0bipNq1yBOAPXaPhpN1+twmcuSTS7PkGId8Qd+eY9txfUQgYzPC8r7lsGYOUkV1MYgVQjeP8899bqKRaN8xGoPXAuVj4pZWn1cYHzkc76t6Ta+IUAyJn9258jITD6QqX9yz4ZbKPaP6rzIL0A9EW45wY6IS5V1wjZw5auWqjh1tuPw/4u181MW3bAr1EX4vhFFqpT3pqdCuVzTjnllenJW4Sl+25UH40A9TEGA0O7E2pRK2s4vybmyJ4A8flL+gGoTKQH3+tNlmauj59nozVhIBA6tFHkpM1lm0wIUMOIXuYv+QOAl2aZyYKlGZy5l1V8jzxMkT9UX5zT9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SfkkoRCEOwaMC7ReeVNzaXuvFPXYVs30uu8MW8yWuE=;
 b=nVoJA8bIA6gCxJYncZjh2dJJEQSdtG3l6gEA/uHFUXLoUBR3/SjaY07Oupxdm8MSZkp0s25ZoX9Kvob9riong0dxMPEuZ6T4FqxnfRjPuxvn+YU/rF8hl/XUay2XQ+VdHlmz2H4p9W2B8eVNcY+cE2FNSoKOYQtrxs5bssy9+RIKEF+eVafzskicAdlK1eXs+MSOUuiQVUvQzYq4QCyJa0WdP2dQFFQ5ZDxWXfAOiguM2AQjgQtBA2VyJelB9IC+KcMDB7OuRxgl7XsMw1Exap3zx3XlE+V5ts+jI7x1BP2j+ofj+J6/F0k3Sih6h7jHxNwWzO6wzaIDNRYxXomKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SfkkoRCEOwaMC7ReeVNzaXuvFPXYVs30uu8MW8yWuE=;
 b=hfrbk/anHouTDfyBpdPXMSOP540OTOZG+GI3px3RAJVOaYg79ssm1IlqrEalJYpVPNibyFRBy216RepetOUSp54zjKlzn+BIJpxebFpcbtFx0lX89sTAoEajvrMHEgIadOClXxavf28/R/SSZ0vvTH6fm9MgBTlM16Zan8EZwwc=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Thu, 20 Nov 2025 07:03:50 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 07:03:50 +0000
Message-ID: <91b218db-a9b2-4560-a946-3236947f228d@amd.com>
Date: Thu, 20 Nov 2025 12:33:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: return EAGAIN for transient dirty
 pages in MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251110113254.77822-1-shivankg@amd.com>
 <20251110113254.77822-3-shivankg@amd.com>
 <67325651-b7d5-40d0-a9f1-3009b61c8d3a@lucifer.local>
 <a2770a50-5732-4483-b958-4693f0f08c7e@amd.com>
 <0efa89a3-2080-4daa-a190-2ced8e14ed9d@lucifer.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <0efa89a3-2080-4daa-a190-2ced8e14ed9d@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0082.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::17) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|DM4PR12MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: 95952cae-4b12-482d-8c45-08de2802f529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzhMRmNwRFU0UE5BRGZ0cldmSU9ERHIxdzVhMXNSdEVGT2JUY2ZYVnlIMUVs?=
 =?utf-8?B?ZTNNSkNLQTVEWjFZR21lRXVUTFRnY28yTnJFNXFHdDB4S3dlbjBuUVFQN3pt?=
 =?utf-8?B?RHc3cEJJVXJLQ3ZaTFBJN2kwREp1WER5SEMyczV0YzdtWmJYczVBT0dJeDFw?=
 =?utf-8?B?c1dhNEliNm9rNndabHV3S0VBWFB1VFJwTCt4aUxqcDhuM1F5M3dQQ2d4Z1M0?=
 =?utf-8?B?OTNpUzZOYXIyOGxVVDNxZ0lYYlZyMVJuOW0yZytmVFFCMlQ2VXF3Q2JGTjNX?=
 =?utf-8?B?WXJjcEgyZHJyUk1GOEtPQ1pqN0tsNXVLa2lTQ2NJbzhUQUJsMFFaQjAxdTJL?=
 =?utf-8?B?V1NscjJ5QjZIT0NoYm4yMmh3TjlydHNpMThvWkoxUEFFOGJYLys5NU9DWlhu?=
 =?utf-8?B?UFZmdngyU3Z1TmhGa2VqRGxMZ29sRUdCVWRscnpaVmN2MFdLWlpTRWczbE0r?=
 =?utf-8?B?TnpLNWZKamZ1UjdsdDlqQ2taMU9yaDdPdHhOdWtZY2p3TTRPRm1RdWxSU3Z3?=
 =?utf-8?B?cTloekVNdzdmMkxTcXZjNjlUTFNXKzZiL2k3QXNsMmNoWHZidklabGw5d3F5?=
 =?utf-8?B?c3hTSVA0Znk1UEFoZGZteGViaENGbWZ3ck00NXczNHBCYlNaMWdhN29WWnRP?=
 =?utf-8?B?ZlZleVk2ZWxKV0V6alg5SEd2anJTRE1PTHlMMVZCSGw3M2pOalZUYzNOVFRx?=
 =?utf-8?B?Vm5kSisreXBGMmZ6UlF5TE9HSWNGb3ZraWJVZjMwaTgvaWNKTk1DYWNoWkZM?=
 =?utf-8?B?SWxFaXBoVmdxQlFyem5ZNXZCM3p5NEVoa3Nha1B3SUxHdXNndWhwM3ZjNWdp?=
 =?utf-8?B?bUZ0SXMvV2ZIM2p5cXVDNmU1dTltbzJoNmh0Zm92NzJ2eGtDZ2lzc3c4NjI2?=
 =?utf-8?B?RzIxcm5JRGhlanhabExkUUxydXg1NXUxaEJsOXpVc0g2dko3MVYxeTY1R2N5?=
 =?utf-8?B?WkxWVW1TRjVnOEFRRHZ6RlZ3OGEwSjdRbFd2OThySUY2QVZWVlVHYVh6Tysv?=
 =?utf-8?B?K2t3UFNXa3l0UzJvUzhYNkNPcFM0VE42VWx3RDhMNnhTZHRFMU1CWFAwdS9J?=
 =?utf-8?B?bXZiVEcySE9iTWpvN01HTE9nREpZNTlKOGVWSllHR1Bqd1c5MlZZRlBDNGI3?=
 =?utf-8?B?RjEwOURpWlBaMHJBQnlYQVUvcm84QkZLR2pIWktaS3hrY2pMV0pUbGhuU2ha?=
 =?utf-8?B?bDY1OGRsRktOUE44YTN0MTNIVE5NRVJhWUFsMEVZVm10Sld0Slptamhxb3hO?=
 =?utf-8?B?ak81QkxFNjY4Sndnb0pMdVJ2WGlxTmtrYzdkMldSYnFqeXNDcFoxVWRwbzIv?=
 =?utf-8?B?eGVmMmIwbnFmKzRoWWhSOElVTEloSy9WVW8wZ2tjME13N2xKRjYrc1RpQmNJ?=
 =?utf-8?B?L2k4TmxMSTRKWGVGdlBrVlRvNVN3c0hJV2taUVBMU1F5NlZGSGFHTElZZ2E1?=
 =?utf-8?B?ZXVnVzJzNE1uS0NlU0crSkJYQWJ0WG5KN0dRa3I0ZXJqa01ZN2llb1JYaFE3?=
 =?utf-8?B?NkhoYnJ1K0lPcDZXaitXUDZySlZjc2pZRUpXTnVqam91VXkvM01IWFZtbktS?=
 =?utf-8?B?U3dMYkxqSnJCcEZBUzRqcWh5Y3ZJVG1HZ3MraFRkd2o2NVVJR1FjOWFUVURS?=
 =?utf-8?B?SXcxQzlBcVNzK0Jid0ZzU3dpNWV6RXZqakVVaWxtQndZWW1vcWVpSTIrYVhs?=
 =?utf-8?B?TjRlNFlhVnp2dFpibFJLOTI0TGhlczRFbDhCbVhQSGY1bEFORzNMU0t5dTJP?=
 =?utf-8?B?RFV6Q09ETFl4OUNBd1ZDR2drQXIvU0szU25hMWFwT2hHcVMwVWFZMEl3N2dG?=
 =?utf-8?B?c2pRamF3ejB5YkVsd1dXUUc1MHUrVTZSa0RlZ1V1MU5WWjMyUHpwdGVtUGpk?=
 =?utf-8?B?QXNyRmpwOHBpd3N6My9Fb1FUbUtyQk5mUzZHMnZnMlBLdGtUalRYZ042SjlN?=
 =?utf-8?Q?zYhNj2wEWS32VUBy5hqw+b9dou9/8F8K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXFOWXBnMWsrNnl4amlMWG1na3N0ZkEzcUl1SllRUU1SZXQ4ZDdLYnQ1ZXNF?=
 =?utf-8?B?bFQwN05Jc1hRRm9vUmJ4K0hiRmprQTJjMVRYZDlXYytJeTYxcXpaaEVjQnIv?=
 =?utf-8?B?VWU0MkZ6V1RSb0F6Ty9nck5QbDZrWTBXMVRnRTJhWGdiUktOejVMS2J4bmFC?=
 =?utf-8?B?a1dldkRLSE44WGhqMGR1azRKTjBVWStFa091dDI5OVM5azQxUWxZc2VsYXZW?=
 =?utf-8?B?NHRFWVI5M1F0Sk1tRmJTNUs1M0p3OXQwVUhJMWo5QVNRWmFTT2s2Mi9OSjRL?=
 =?utf-8?B?U3A2MFR1Um5kZzR3WjVLU3FBd3FrN1BOdmtKMW1aVm5PdHpmbmI1YnRBajR0?=
 =?utf-8?B?MFJpaTZvQVYrVGtZcTVmR0pZNWxibzR2dHNaVll6eWNtVEpmTldqMlVRVThU?=
 =?utf-8?B?SStYblF2TXZ1dmhINWNaaEpveE1SeFJhQVFIdXRiczBQdyt6TGJic0tGSnpG?=
 =?utf-8?B?YzNlL0dnS0hFNjM2QlpYSlowcTNmK2VVV0RQSTVMUUpJVk1Bdjl1VDFaNjNz?=
 =?utf-8?B?Vk9lNG1MMWtiZlJja2Mvem01bTlZUmFxdnVVQlBlZ1dxRWI5UnJhN3pOUjg5?=
 =?utf-8?B?ZUxBNFdKY0h2SlFsaHZBWUVGa3BIQUhWdEVYVS9hOFd5REdUVEQ1Rjl0YWFD?=
 =?utf-8?B?TGJqWGRrVkM5UFIrM2laNjRrMTVmbjhJam5pWEZhSjYvTnhLUkFhNWQzZk0y?=
 =?utf-8?B?TVROSkVBa1RGQlRPQ0Q5SmdPMzJHbE4xK0VQME9LdFBEMWhtakRXQm1mbnR5?=
 =?utf-8?B?VEFFb0RCVjU2RkZxbHhCQzFzdC9kRG05aDF3cnptOWljL0hrcVBWK2NxaUlY?=
 =?utf-8?B?Q0dDUzQvell0LzZValplRE8rVkxNL2tuZzdvU3JIeEhyV1lSQ2FIVnZMcVdZ?=
 =?utf-8?B?WTNuWS80MHhWWkUwbEcyaHQ1K1hWc2NFL2lzVGpYNnM4VVJaZmVpbUw4ZmRj?=
 =?utf-8?B?Z3JsMXdlQldKVjRRamVOTXc0Wk9Na0ZmQ09rU0xYVDNROC9CenNaK2hDVWQv?=
 =?utf-8?B?MDViUmFrSFpjSGJGMG9aU3BKOEovMG91bTJOcUIybmRNdTNWaVRhZmxwQ0NE?=
 =?utf-8?B?TzlHd2dReWhGaFN0VmttZUV3cXU0VUNmeU5QbXFHTmsvKy9zY2YreVJvdmRp?=
 =?utf-8?B?bGhyUmNPSFhSVEZiVGk2SUFCL3FqK0JQTFJVLzlOZ0pWb2hZL0RvTnYwK2tu?=
 =?utf-8?B?eC9rcGxwL1dtNjcrY0hIYkFyaUhuQnp1aUZaOFgrRlgrZTlkK1Q2VFBMRFJt?=
 =?utf-8?B?dDRzekFYcFFCV1hLa2liMjB3d2hudGdNYUxsVDBhN1FjdUx5UlBQemJwVkwx?=
 =?utf-8?B?M0VGV0dIdGZ4bjZVa1gwUk4xalU3dEp4WXFoTWlNQm54RmhmSUhHNkg3U290?=
 =?utf-8?B?MExmbFNySDNER0EvY1QrTThvM3JYSDBDSTR6dzEyUVdGc2JTWS9aN1M1RkpJ?=
 =?utf-8?B?bmZSNjd5ZW9DMVRPbHkrbHNnajNpRDdEMVh4WWRVL29CbTNlWCtveE9DN3dE?=
 =?utf-8?B?WlZZTE0vaUp4YW14M2RLWXd6dThCUE03eXQxcFBIYmhlTTh2V1RLS2paWkhX?=
 =?utf-8?B?Mysxb3NCR3ZDYkhRNnV6SW4rMmFKQUNFSC90OHlqazhMemxZdHhUSzRSdUc2?=
 =?utf-8?B?QWFod2xRK1hyNDR1Zk1ZNEJhTDBvU1hML0Q0SXJ4RGFWbUFnZkJQME9OUnVZ?=
 =?utf-8?B?SnRvSWtETWJNL3F4UHNUT2ZMdVlVZXNEYVNiZUxqcjQwemg2RkdteTJ4SmVt?=
 =?utf-8?B?ZVpzL3dianNWR3N0SnZ3Q1gvM3pxdTl1K1NOdjBpb244TFNFNUh5V3BLeVhn?=
 =?utf-8?B?ejkxRUxsYmM5WFB3VnlpSy82K1VrcnNyNCtTZ1dob0Fub1Ezb3hMRklIM0Nm?=
 =?utf-8?B?eVNVUXhHeEpFdEJYdjRWaGtaU0NPMXkrU2IraS92bENnTUpSQmRTdWZPZjBP?=
 =?utf-8?B?S1MrbTVHZXcxTkRJR0VGY3JjZVJ2N3ZMS2F2QkhUMmNRdEhab1J3M2cyazZQ?=
 =?utf-8?B?Tm9NV3ZlUE52TTdTN0pTZUJ0UndobXBmMkovYzRGSjhuNTNDdE1yWEppZlRX?=
 =?utf-8?B?a1BCaGNaanV4eFpEWWN3TXFYdHhIczNKaUhKU0cxUmRyVzZnMU1YeThCdGZt?=
 =?utf-8?Q?zjCk7mlLE+AlsvCjFezzDm9D0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95952cae-4b12-482d-8c45-08de2802f529
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 07:03:50.5111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQCtM4hsKOra1HLdC2JH2wvRbPKZ3Os4oMgLVdbK3jqq1boc0BJ/ISGheG7Yw4aHeN/xEON5aQIZ9650tRJl1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DA4D180005
X-Stat-Signature: z635rej938j5nrchqkzh76gem7zojkii
X-Rspam-User: 
X-HE-Tag: 1763622233-57833
X-HE-Meta: U2FsdGVkX1/2pcIEKWgVav+D0txm2Hx9OYgHGl5ZS84kz2Kjh6EysPMeXPhhJDLpqKe20UI+HVwDUr9oZCTty0ylnDHZf1e/qfGIwHToFaZaZW1L/Mlaq8d+tJ7eWOyajsIYLXTJscY/R2I6GVd4b1dMZOejUjGyfSN3Gq5puZ+JDwJ+svS9V4gUyQoNtJiOFl4D4HqUTD72nXB/WQgcd/ul9PRbKaV2R/qOkiwgAZEZfTRwCuLRuEaPQ/2ZQQgbju5f03Mo8a6jQUWoG3liu+V7FpqvV0AdW0HWTVToC3MgtCO1XCxhiXup4+B5hQI6ArZc/OL7tg8uqRzGVHKvAB1hnB6RIYRPtrdNiIbXp4vhXhVwABorQ9W4SjVdRlDByjYyNKCqce5jbGxERwSTyIeb9CAkVM/PiI8zZk5HAhNBsoKZ2Jl9++IlaWp86NHt5esut29XjipgGlLRbykwfIrubaardykNtmMoOKRQiBLedsFtOeb4JA7by72wxoYEoQCwCt7gh3VWkA4JFh2Qsr6vljKBmKBxKcIvBIxftqO3+yUvRjkbuGgjJU+PEALwszrLUCtSSaGdxTy/bAFS48zB3opjv/S2dtPuYybhI0hh5T7FUr99Z/xegwq3A4MuZwQUfQPZMVJTUcSDHMW1r4B3Ljb6RKkwO0hFRIz+irHK644RMuKgc2BY9hXOUsuk2YjRS90VhU0YcRkToU4/udek9WFk6yheLeIGxX4js00WSUxz4MbeGj7aqq1hvz00hTHPkjGODLRKW7AhFJ0jy9hay1VpAp/8A2UGjHDBANq3jt3uFDv8J3vC0uHf9KaGDtisZY0ZdVRUx1J/wxur3+qbCcVluW1crW/kyOVN4PYaMZrZYgysKOpdayCf5sChbf65eUx6vR/OEH/CBhJ0sSIV/LITveFJyrRf8LfApMxQuU2JPElcz8e7USjzBVqQp4TD4ehCgH5kwz+xbOc
 Exq3vsAG
 AZxeOrwRuGsXIWrsGxQDDqVmOiKVvYv4AguI1souUKOPSqg5wfpUDfM5k7mbgOpkVaaqVsJnQJqwFHeMeuyVIXqO+sJrE5AfiZYNXH+VueKuZVF8EHFXdLe12Gl6G2Y1bOAYi+POEOPjs7z5DzR/7EpD2Ybfe4jmEvizX44Zto1KUw0TnQf/WYFMDx13s7QbV+Pqzx0+uqpVuT0/pYzZlmsptsmLKNWouNA0o4zkZ4WI4RY/TEba9GFF+E1x8gN+qsOpPoS1qLZPN8nEybN7MJDE+/Q4L+2Z3Ds+9+6MtlYklPc8qxGzmv/cynmen0RbggJWNnccKaMP4kSW7V8iUAlrbjve34BEjHRcA4uZJD6Isbd6JTl3El/DcFrVjSrtyOerqID6IxPzKaJ8s+LtVn6qjZ5cXUaoTgA6tB8tAdIWZ4WbxmYyeLGRzpO0e6T+c4fMIiix89eOHtru9tjgYfdDIjVaKhyl5QRMx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/2025 11:46 PM, Lorenzo Stoakes wrote:
> On Wed, Nov 19, 2025 at 03:55:29PM +0530, Garg, Shivank wrote:

>>>
>>> With comments below addressed, LGTM so:
>>>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>
>> Thank you for the review.

>>
>> Looking at the code, the dirty/writeback checks where I'm making changes
>> are all in the !is_shmem branch, so it only affects regular files, not
>> shmem.
> 
> Yeah sorry I think I was being somehow blind to the fact that each
> dirty/writeback test has !is_shmem, esp. given I literally quote it there :)
> 
> So err ignore me I think here haha
> 
>>
>> Should I mention in the commit message that these changes are limited
>> to regular files and don't affect shmem?
> 
> No that's fine.
> 
>>
>> I'm not sure I fully understood your concern on shmem. Could you please elaborate?
> 
> Yeah I think I just misread the code after a long day :P
> 
>>

Thanks for clarifying!

I held off adding your Reviewed-by tag to v2 since there were some more changes
from v1. Let me know if you're still happy with it and I can add it for v3.

Best Regards,
Shivank


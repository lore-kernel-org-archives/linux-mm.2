Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0794D41170
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265826B0088; Thu, 15 Jan 2026 06:09:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2364B6B0089; Thu, 15 Jan 2026 06:09:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4556B0095; Thu, 15 Jan 2026 06:09:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFEE56B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:09:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B635B1ADC93
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:09:11 +0000 (UTC)
X-FDA: 84333926502.14.FB6B5BE
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5C64C0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:09:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K2IszQd8;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.57 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768475349; a=rsa-sha256;
	cv=pass;
	b=4sr7ohFEYZHQRfhCZb9ZyR7UfzQP15fI5WvZYzd+LZqK4dmH3y7ZB6AwtD6yV+N50dXCVd
	KP4WjLe38fvamkPHG2GgqfP7zrau0/j8MvjlT94Bc7tO1GkQPhjNrAN6TNBMNDXAx5c7N+
	eV0REWWRI0NMVZKTY1EL/o8P5QyTALE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K2IszQd8;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.57 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768475348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzmFDVE8hMtGGXeDax0/Q8LXD8brv9WGdlh+qMt6E98=;
	b=pkQTC4fU1JthJPg5U6qFTv6FpIo3iMiPE3KjJvtyBdZjtA2qvVz2W/9zmGjXbUIBEj82mX
	DupCdwZIwRwUxlpTPhEQjvV/uVPkY9kcXk3aPsxCPn7nTyz3+16CmXFaX0m5aZW0A2AEVf
	+y/9398DmCfx4tHz1QkXExfX2X665XY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWjZi/6Axjco0uXZKzHyyQP7OLZyDrAeUw6aVYOdE9AJuCf0ZEaL8onUHyYuIV3OrP7OJJPiHd5XcOUpI736SPRpYV4T7Qgn6TfD2rHsqK7hF3icq2NrhhjCTKCJZMu7OFOJRUuC+ZdNybDj8kgAiQZlFpmhVNoSX4sHrbnIg4dY4IOf7fuE1v11rM0pKgKOEkwmyUAlRZPr+814t2am+K1bg/DU17K8e03QTxeyh/UATlJBuJ9rSVQlJTM9t7bVw7lK5L6x0gwY/urKDSXTYGob1ymeHfJijm6kNJjDPG5HkyPOSV27cEuixHqRghQD4baEeO2TPC1P+Bv8otJLJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzmFDVE8hMtGGXeDax0/Q8LXD8brv9WGdlh+qMt6E98=;
 b=Mg8RF+nlE5fbIHexn6npnnSbw3d+GhQqeXG4nKdCwWf/3hc9BQJk5aDQX71azVtSw8aNe29zfjf5yyY8N7r7oSxL4yQTlQ7c12HtISyNd7pAEtu+waymCPpFYiN+H2xU9HCNPDuQOwBNCe6ZenG+2qr7shkkYaFNVjLuWzTK+xWhZQ2rRtO2pT4f/V1p6PzqsRY1mCjLz1tggiGdH2yvIV3eyqGLTdazPqYQHvQEfBY655Y9v0I+E5HXEmZKZRPANmIR9dVp30DLpHXZXsNBgr6Mw+xFb8owqn3whvD+Zn23thkgQ0j6ALkwcOfVCN+/C8/4dkGNFIocWxu/4lG1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzmFDVE8hMtGGXeDax0/Q8LXD8brv9WGdlh+qMt6E98=;
 b=K2IszQd8oJnyjrQPS6c2dg1ClwsNtFp4x349IDTxBgKGkilts3J1SmLiBzb8GeH50sGvAJ/grWIQ5KJ5nN2N/s3NYqHR+8hC+x5a9y5+LvhVlc9Q+ekPT04etLIw2w1P5xD/QZqxggIm6Q8siPQgU1jU9SKzX4rWkeZ+8JRwOyw=
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by BN3PR12MB9594.namprd12.prod.outlook.com (2603:10b6:408:2cb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 11:09:04 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 11:09:04 +0000
Message-ID: <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
Date: Thu, 15 Jan 2026 22:08:32 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
To: Ackerley Tng <ackerleytng@google.com>, cgroups@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
 brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
 corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
 fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org,
 hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com,
 jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com,
 jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com,
 kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev,
 liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
 mail@maciej.szmigiero.name, maobibo@loongson.cn,
 mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
 mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com,
 mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev,
 nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
 palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
 pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, prsampat@amd.com,
 pvorel@suse.cz, qperret@google.com, richard.weiyang@gmail.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org,
 roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
 shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
 steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
 vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
 wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
 wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
 yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::8) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|BN3PR12MB9594:EE_
X-MS-Office365-Filtering-Correlation-Id: 891a5408-a48e-487e-909b-08de54267eac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2FBVFZlSm40TGxBL2YxZUR5THdVbnZPY1Myd1pNNmFrcXVEUTVISWdTTkcw?=
 =?utf-8?B?WExsYXJrN2RnNXpqbTc2NjNZREF6aUxtdlJYcGc0dk8wbWFidFpWcTN4QU1s?=
 =?utf-8?B?RzJaaXdsbXZoYm9jUWxXT0hjaXJQRDJvTkxnd0xsM3F0c200MDN1M2tIYlEw?=
 =?utf-8?B?QW5EdzI0OWg3YUZVMUV2aTZJa3AxZ1lacXpLL0hORXdEbGlMV3hHUTNVODc5?=
 =?utf-8?B?elovMUxmOTlRTzRYbzNLT1MxQ1l6ZzdwSUxIOFNiU0NGNEh3TU5CUGlld2gr?=
 =?utf-8?B?OXc3WURCQ0tkdURxc3pTenFSc1BiendvT09YMnBUUUpETFcwUjJrWmtOTGlD?=
 =?utf-8?B?TmlMQ01wUmRNZHYrZFUrYnVGRUxCeHhYbjZzNUpNMzJWVG1qU1VvdXR3UUNs?=
 =?utf-8?B?UEhJdEVya1lwL0RwUHYvRk9hZnkvSXVOK3REd0FsWGFDWWluV2g4U0ZtS3Bm?=
 =?utf-8?B?ZHlGa1VhU0JYcWJJcXVVcVU0bmo1UEhCZGhmczBIdDh1ZmFFaTBvR1ZnRWVU?=
 =?utf-8?B?NEs2SEpWSjJHUlUrYlM2cmFqMmZ1TG91ZHVUcmJhTHVNdFZlT0UzT1k4bGR4?=
 =?utf-8?B?c2JIRWJXSC9NandDaGdBajdtdlhiaU1aaFVMczNtaHBQSVprbkJxR2dObjBs?=
 =?utf-8?B?T0JZV25Gem15clU0YUJ5ZGlkc1BKNzBMVHNtZ0hFZlQrYjEyQlFkWlFTQW5h?=
 =?utf-8?B?ZXJCNTdCczFWajJxcGRBdGszODVpc05rRmpNeUdHblczdWdYT1BjS2lVNmU3?=
 =?utf-8?B?M2JqZFNyRkxhTTZOVWYveExKeVV6TTE2RlhOY3FBK3lGS2xCdk1sYXdTMWdq?=
 =?utf-8?B?Nm9RUUZaUzVoZm5jTHJYVzhSTzF0UTh1VlkxS3ZzOUdjajdkZTNOV3l2VWFI?=
 =?utf-8?B?K2JycVJhbW9KWkU2cndqRDZYZ3A2SU1vT0hlRm1ya0ZWQnA1Z1AwYjAwMEZ3?=
 =?utf-8?B?bjg4U3R1bkQ0MHFNZlA2Q3A4eVBtL0c1emlWTnNzT0FGNDZZUk1rbENMLzhU?=
 =?utf-8?B?SmtHZHAzTlk0d2E3Q1ZLM0dxYTdNWWVDb2pSd3JtNFR1OXp5VUtXaDJZR2RN?=
 =?utf-8?B?bXlwS29jWkMwaDRSTTZXSHRxYXNqL1JndDBjSk53bGxPb045K09ObUhaMkVS?=
 =?utf-8?B?UmFPWnE2UmNZY2RQM1VVMVp0c1Frb1FHdXVDNkZPcXdvQkZ4Nk1ORmhDMlk0?=
 =?utf-8?B?UkZ6OGQwcVhCQnV0cnk0YUZTa1NqWUF3Q2ZkWUNmNzllQVNIckVSQk90Yk5K?=
 =?utf-8?B?T0R4ZjdoWDNXd0lMbUlwMjBjc1pEak9JdzRwb0liNmpDdTl1R3ZlbVdxZXpO?=
 =?utf-8?B?R2dpZURKZTJ4QVBFWWUzSzdEQ3VRbHJpcE5mTXlyZlByOXRTRE95dVlJYVlw?=
 =?utf-8?B?Y2ljVUtkUmhOZ0U5VTdVaHMrSXFDU1ZsUDhSaUVDUWtJUmk4VkVtOGQrZngx?=
 =?utf-8?B?SzJ2OG4vZFV6NUZQM2RLK2F4WHFwNUhSK1BYdXMwbms0NndwaUxCWUVYQ1Vv?=
 =?utf-8?B?TitWY1ZhVHpDbTh2ckxEMzY4UmJWWUZpaCtFUHlZc290a2tBMEtvd2dsWEhS?=
 =?utf-8?B?RlZ6V2J1U1gwRmwwQ0FYUnl4MFBvdzg3R0lXYktWUjNqK3NQdGZTamxGUWx2?=
 =?utf-8?B?S2VZbW5vY0dMaC8rdUNyZ3UxdGtqMnNzMkErdzM3N0Nlb3FTQkZ1TmZjeTRw?=
 =?utf-8?B?WXQvcldMWkNNTnJGYkpmNlFkK0c5TWNwTjVEbGZ2VjlKNEVja2ZMckFQckdz?=
 =?utf-8?B?ajJZcnhocldTU000TjRFSS9VOHFPdUFRT3BlY1F6WFM0dWV5bWc1MTd6d0pE?=
 =?utf-8?B?N0JoSVFRcUR6V1ArYUxlN0pudGxMQnVHN1hMR3A0SVMxeWkxTndkRFJUUVha?=
 =?utf-8?B?Y2cxUUt0SWZGTks4QlZ6VUNHVXlQcS80TVJUbVVVUHdydEdaem12Uk9hNVht?=
 =?utf-8?B?ZVZXRHpGN09UY3dxS1RTZG56YmpPc1k2dGRyQzZiYWZyZUhxdzJUWmNabmlD?=
 =?utf-8?B?c1ZpSXg1NGNZWGFWZGttNkZRSE5LSk9NdUdEcHNGNkg1RHIxc0xUNEU1dHBt?=
 =?utf-8?B?RXNRYy8zSmpJM2J4a25xUloyQmFUTDhzLzlNd0Z5VkxkL2ZaVlhOUlFjalhB?=
 =?utf-8?B?MGt6ZXZOeWhGUkRrZFdkZWhHQWhURlRSSk1FdHU0N0w1dFlKNVJmay9qWXE4?=
 =?utf-8?B?SHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnVnMDF1djZqdUJtSC96QjZDeHR2WTFKV2JuWkRkeEhQLyt1OGRxVnV4SVdV?=
 =?utf-8?B?UlBpcjJIOVh1SjBxQnArL0dIQUlkVTdkMGMxWHhDeHB5OHhSTG00R1lsdEZv?=
 =?utf-8?B?YjhvUi9QRWkyYjliQ2I5OFFLMGlSMG1Ea093dGxzOWNxdUZ0WVVLNjQvYVow?=
 =?utf-8?B?S2thQTd1czMvOU9HWU1UVUZPazJXcVEyMVAzdzJTVFQrSzRTTTBYcGxTWTlK?=
 =?utf-8?B?aFRoV2dxK2x3Tm4yMG9ob0hDY2pxRmtDMHVwa1IrWnVGMjNkdEROS3hpc1pV?=
 =?utf-8?B?Y004Zm5DbGJ4VVVsVnFyY0tXeTNQZ3hJbW9LLzdibWZNT2krZkZodGk0cWVw?=
 =?utf-8?B?SURtbW1DUlN1cHlkU3hvUWVrNXkxZFVhSmN5TGNBR1Jta0VrQXZPN1NRWXVy?=
 =?utf-8?B?Um5iYXlvMlV1WmJVdHVDRHB6Vm52dGZXVFBFRFpWNUdkYnZTRHArV3AzbE9T?=
 =?utf-8?B?RmFhbjMyOUpnWGpOanJ2UEpOdG1leVJvREFwMnhQblI1RlRUUzRqaWM5Q0Vr?=
 =?utf-8?B?RFJ3Tm03dmZpMkUvOGlCV2ZvOS9PWFRqUkdjQ2E4Vk1HeGFKVTB2Qjh4MU9v?=
 =?utf-8?B?ekJuNnpTd1lmV2ZTdXdQbEUzcWFpRVFpeXg5QWhGdEFROFpiVnYrdXZsbWpY?=
 =?utf-8?B?K0gyTU9jZXVTa0s4NjIvNnlkdXNSN3hvNGtxUUs2OUZGVXBwRWd0QVp4VXhn?=
 =?utf-8?B?Y0k5ZnloSFhFUTNHVVpHeGhKTi9FY0tDdWNOWlV0NVNnVFo3VkU0WXhaVDBu?=
 =?utf-8?B?SGl0UXhCcnRSdys4WkpHQ3J2Q3VxK1d1SzlmZExwemIvaXV3Q0s0d3JRZ2RR?=
 =?utf-8?B?MmhidnNwRERvR3ZqZFlZYytXQXUzWFE1bksvQ2VoVXd4TDIxQnM4R3FZbVo4?=
 =?utf-8?B?d1RVV0YveEFlRktBZmVseW1YMjhRUkVBU1F5TGw2OGZkNitaRDVGWTArVGNh?=
 =?utf-8?B?Nno0WDI1RzRIbGdYSTluOEJkZzlXWTBPOTRNZGhKaStQRFFaM1V0WUFEK2dq?=
 =?utf-8?B?MS9ZYXo0cTZnRXFNenhvZFpoRUN6OW11eUpPRkxTQ1VsYVh4SWhoaHRJVXlS?=
 =?utf-8?B?eXlCMm55QmcyWGE3S3BBYVQzUVc1SHNIVTFiNTBZSEI1MTA3VkZpNU9wb0hZ?=
 =?utf-8?B?dFZZUWNRRWlTMkc5RVE2WllpbDNKSXdRNUVaeFg2ck5WZUJFcXdlSjU3Ynlm?=
 =?utf-8?B?YmJBVHFoOVFsNTBRSkFtak9ndjhmYWtORGp4L0xBNTByaTJuVGJmYUhWZVNQ?=
 =?utf-8?B?RGR0YnV6NjQvSWxzY2M2Tjh0blZ2T2lRNlNybWVwYWVoVmtMRHpqdzM0dEFj?=
 =?utf-8?B?cHJ2Vjc0QVhPaFhzTTlvZWhTbDRJNFlnWCtmNGtlV056bys4K0VXRzhaSWdX?=
 =?utf-8?B?U0FwczBXQ1R5Rno3L0M4dTI0Y1ZydElVU0NlZmxIRjQwMDR0VEF1QVlXWThT?=
 =?utf-8?B?aUlIUmNrZkpERnpJSWU1Y1NYZGFzTXBveUFxRVB6eGRkMENES2VsVjB3Q0ZC?=
 =?utf-8?B?WUovYlU3dkFmMTMrQlZaZUIwZThDN1owY3ZHY3VOM29Ja0k5ZjhrSlcyNkVY?=
 =?utf-8?B?TUtXbUpVcVREb05wMzVvL3RZWUZJLzRGb1FQMlV1MlA4V0c3MTRjdDZTc3ZJ?=
 =?utf-8?B?WGY3dWhKVTU5VGtRWGpPOVF4amVwcjlYemNYWW5Sa1FONUVqZGFVMEVqZWFD?=
 =?utf-8?B?MEwyTFlLL0dLRXMyU0I4QVVZZUNQQnYvUG5Wc3FaK1d3ZmNWcmsvSXczUS9v?=
 =?utf-8?B?a0VNb1hXQVFqeEVzZWo5SnJYYTVhNVljTm5hbG56cS9JaU5qS2VQYzdKN2Iy?=
 =?utf-8?B?RUgrdG5UUlQzOGRPamttZ2dDbndjNzdoa29wSG1oeHN3U1dPc1ZFK2hDUUNy?=
 =?utf-8?B?ekN2bnFES2xNMExkY24xTjZ0aEVnQ1I5Y3UySWtoZk5ET3p0ZFlqNVhsWmZy?=
 =?utf-8?B?SS81Q0haekxlNkJRNlU2eXN0S1dONkxtYkZlZ2cvRERDZDhLK2k5OFhmRjd4?=
 =?utf-8?B?Tll0a0l5YmJHTGZjYmVXUG11NXVSSnpZQ01LM0VWbGJJQ1RWck5MNWdzaUND?=
 =?utf-8?B?eXZEL2pnaXc0MDZXT1dxZ0ZxVkJJMi9PSlBnem5QdGIwOFFBdldaZ3RTTXhs?=
 =?utf-8?B?ekFQeDFlYVpQSTMxRVBFM2ZVc3RRODl6Vy9PckFoUFR2cXp5WW5SMWFsdm5O?=
 =?utf-8?B?QUVncEZhVUpwMGtjOXdUbGFGS3p2WTgxRmVweXVqbTByVTVUNW40TmRTVUlq?=
 =?utf-8?B?OXl0QmJLdHVjUTRlaWcwSktNcktYWlJsSDZUbUtodHhHd1BSZ2tzM2ZvZ1JL?=
 =?utf-8?Q?VxIJ78geNyL1jupf82?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891a5408-a48e-487e-909b-08de54267eac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 11:09:04.7283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBUtq7Yfia4Qgn6XMNGL5F6V3IBgu6iwFpTh7DAALkBTDUdFY7LzpdRaAFdPTsZICuQnvEDWCiJrIDPym9Pd9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9594
X-Rspamd-Queue-Id: A5C64C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: x5tpiomiyh7x7jyni4goh78qoweo9raj
X-Rspam-User: 
X-HE-Tag: 1768475348-157821
X-HE-Meta: U2FsdGVkX1+XnyNTpkq7bpDKDXjsAE8qe0drOpfhTS1Rl0ejYCahdODWe9br3vSIqtNrLydL3QKV9pgo3njXonLGDTOPjAccB7wz93zKnrFsM+TuUAcobnt/1acJkTAdAXSGOMWHmmH/iZU9I8hhe4WWAhJlyXCb37pUEDme1CfwfPkR66Knr/WMLwYUKTAiwe6Se0UXuYoq/nt3nWtpjWgoUYeINH/wsGDbYgcVlG+IGLqc2g4NA7sp+j/57wzHi2TLfKb7pkotlEjJHzuy+aTYAkoWcyMZtCK83x/CYt0PdakqFWeXMiPm7Q4s1H3J3Mr6Pp1tK2dL7dTd9B24gC66AfR7UzYo3kuvWM82LrfmNgfj1RvAeu8QwP5byNJhDzTggx3Q8phV7rq5XTqdABsSNbHXqjlmVnoKfgQL7titpvBOJUDZWnGrRmXGOmWg8lqRnOusRCA2+RIFY2SFB8rasOWTXJdE7W8eid4psmwv6QXbZDZVRfWvX281Rd3YfcyvZdQMEd2Gi3P3RxUUGh9gsHWtoYLu+CoZq4+BWzXoqIU3NBZDyRBFtnRnu2cGwytd7DMQyE5dTPNsEAyyNVGJTOrE0tHyH8RlJ+CLQw+8cvwFes0mrqvpyJgW8UrPQZj0GxCdS/6gGgrTK9VwYHhdJNBeZq3GSrEx6fb8AsyeOCo4XP6GQrUcDA1CPeTsK8Mshw2ShOit/uYUBGUfI18x2j732IkIXG8hkg7pXFebDm9d7qCw3jX1Abe6XJXT+rugIk8EfvG8wp7IKHvxiPj4ir+HyA+sMXkF/doiBVWk+OfTjBTKoFGYohroce14M0uXOnoV98RZbdkGvFxz3bnkHDP02hKeh2qqw3g4VBanrLqkIotDLR0cVidjjaO/aEScyVTqfotSVTx9mPeRyd64WNBs7X3wLN/W/27d0B8y0Qg/rRHoVBVg+hQJ5OP4XS+huB+0oAAc8dnITgn
 IItyFyN8
 nN/7KA6lO5PpICqnKmMTSzuzrb68fTXZ1nEFMkKegWFjwFRHeLs4KWcOgmPzaieg7DAgc4rZ+ofhC8Aiq2DWSfpOIvP5CLrExbngtNcwB1YUcrkxtSvAuy49QFmAYH5RzIl60UNJ7r2dFmrbpUMbo61VGtML2Fkehz+OCQ5rTM5iX7RtIow2Seft+t3XaKz0lHIfYg9ffOb/bczaNo6HThQ9M8XZ3E/DPGJ6/YADZtP1BEZTVGYrTzlYxQMHhVJkJR06YCg6+FvzL2Kj/Kf4fkMAt0G47BYiwrVTaKqkA7KI2XKY8s1ni7+75TsKUGIL0royCAmyOE0V0hubWwRPK8Bqo6MPbKaw7TCnF182fUIoet4XBJLyDlQx/66Nw6PYS+5EHtbJ/AGfAJTObyN8WOSTYovKD5ehJLCgwcuEbWXDo85++QLq3+yNfWW3GnVBoKueiDeA4hTJkT9qkn9892hWmscHM50/ApjczeuByCJNbIWBQJsA/kDRpM1KFl/vFGyZ5JvD0amSevfoKf3D6I04fD/87BoifVvYf0qiYTiW2nHtHtvur3Vd1FUNxi5vVMo3eJRJnJW9RFGhzPVrtWL6txMc/YsS9Y1Dj8e3GzC3Hkz6RfDzVW8vddh/4YlnBqkp8PXROdp6lVZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/10/25 07:11, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
> core and architecture code to query per-GFN memory attributes.
> 
> kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
> queries the guest_memfd file's to determine if the page is marked as
> private.
> 
> If vm_memory_attributes is not enabled, there is no shared/private tracking
> at the VM level. Install the guest_memfd implementation as long as
> guest_memfd is enabled to give guest_memfd a chance to respond on
> attributes.
> 
> guest_memfd should look up attributes regardless of whether this memslot is
> gmem-only since attributes are now tracked by gmem regardless of whether
> mmap() is enabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/guest_memfd.c   | 29 +++++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c      |  3 +++
>   3 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 512febf47c265..b8418cc5851f1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2543,6 +2543,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   					 struct kvm_gfn_range *range);
>   #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>   
> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
> +
>   #ifdef CONFIG_KVM_GUEST_MEMFD
>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 26cec833766c3..f62facc3ab776 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -518,6 +518,35 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>   	return 0;
>   }
>   
> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +
> +	/*
> +	 * If this gfn has no associated memslot, there's no chance of the gfn
> +	 * being backed by private memory, since guest_memfd must be used for
> +	 * private memory, and guest_memfd must be associated with some memslot.
> +	 */
> +	if (!slot)
> +		return 0;
> +
> +	CLASS(gmem_get_file, file)(slot);
> +	if (!file)
> +		return false;
> +
> +	/*
> +	 * Don't take the filemap invalidation lock, as temporarily acquiring
> +	 * that lock wouldn't provide any meaningful protection.  The caller
> +	 * _must_ protect consumption of private vs. shared by checking
> +	 * mmu_invalidate_retry_gfn() under mmu_lock.
> +	 */
> +	guard(rcu)();
> +
> +	return kvm_gmem_get_attributes(file_inode(file),
> +				       kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_get_memory_attributes);
> +
>   static struct file_operations kvm_gmem_fops = {
>   	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c29770dfa7c8..c73ebdb73070e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2660,6 +2660,9 @@ static void kvm_init_memory_attributes(void)
>   	if (vm_memory_attributes)
>   		static_call_update(__kvm_get_memory_attributes,
>   				   kvm_get_vm_memory_attributes);
> +	else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
> +		static_call_update(__kvm_get_memory_attributes,
> +				   kvm_gmem_get_memory_attributes);
>   	else
>   		static_call_update(__kvm_get_memory_attributes,
>   				   (void *)__static_call_return0);


I am trying to make it work with TEE-IO where fd of VFIO MMIO is a dmabuf fd while the rest (guest RAM) is gmemfd. The above suggests that if there is gmemfd - then the memory attributes are handled by gmemfd which is... expected?

The problem at hand is that kvm_mmu_faultin_pfn() fails at "if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn))" and marking MMIO as private using kvm_vm_ioctl_set_mem_attributes() does not work as kvm_gmem_get_memory_attributes() fails on dmabuf fds.

I worked around this like below but wonder what is the proper way? Thanks,


@@ -768,13 +768,13 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
  	 */
  	if (!slot)
  		return 0;
  
  	CLASS(gmem_get_file, file)(slot);
  	if (!file)
-		return false;
+		return kvm_get_vm_memory_attributes(kvm, gfn);
  
  	/*
  	 * Don't take the filemap invalidation lock, as temporarily acquiring
  	 * that lock wouldn't provide any meaningful protection.  The caller
  	 * _must_ protect consumption of private vs. shared by checking
  	 * mmu_invalidate_retry_gfn() under mmu_lock.



-- 
Alexey



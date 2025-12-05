Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F1FD339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C7A6B0206; Fri,  5 Dec 2025 13:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCFB6B0207; Fri,  5 Dec 2025 13:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E006B0208; Fri,  5 Dec 2025 13:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E3A6B0206
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:35:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8972A1334F1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:35:46 +0000 (UTC)
X-FDA: 84186271092.25.32403E9
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45ECE14001A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:35:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fPwtZpYO;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.200.16 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTLWPDomSbV8KcUoZ5HiuIUqAC+3vLa3KCByhOBS6sg=;
	b=No6V4auT6AMmH98cJW7QZaPE5n2zN4Uht8Csr4GDqNiQOSAsBjPb/7WDTVFdfIF4Uogi+5
	lV+bGiL02kOMhIFOE1EjK9BUgURoLQ3GPOvC/jAbaYYbHuah8J4gvZKQ1a6c0lclt+Jf1Y
	wwbKeURXzq12/zY9GYcl2xsVUN7htsg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fPwtZpYO;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.200.16 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764959743; a=rsa-sha256;
	cv=pass;
	b=Q0MLLTe3wjmrlphtMfU+SGD5euUH0ERek+ejXd1mwQtocfDUMcYETyeAT7plujtMGnnJ9K
	/5JXpvhMFJUPcKTiBsglJARd5tGyc/mpWixqAg1HU6VqZz7XfWYDsH7l3/CxRtQ+h+f3ou
	fGA0gxiiYVj7TVOfU96tRZSaRTOyGbE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fIoeXeiReJNKknpYv0TfcOKZRJgVvM8uLnKDa+5wKsb9l10ctRrXWhavusH9y3BqhhhSapyRHX5TEQUHtgGl2FPdRLAemaYU/Qb98pL9gPY+KGC/63QtQ4kJJ5OIfEBJknK/Xpk8h2DMhzYv67WooS6np7sNqAztwF+xyZ5Xs77rE9pXq2FvYnVWdb2gNNNn/mQTD8u4Chw5a8p1MvH7t8Wrfs6Mgn6DFj9n5R/wnyl4UzIDZtMhVIgfNZuH0fmF5nJzp6oCZK9oVodVWegzWTGk86VmIiSOH/yLnorVekGZroquQ08xGCZqVzDA6I7g8ko9CIT6Yn14lImE4RQLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTLWPDomSbV8KcUoZ5HiuIUqAC+3vLa3KCByhOBS6sg=;
 b=zP5lyJmBb/kUhQ7mwLJQfQb9RUsL8O4XMv3YERx9EBhZR7IRo32kme/2PuoK64sZEy6OBCZ+P6ZCOItRlap3HQ0cY6SauHVHNCT0slAQv5w9GXkVT1U8sXzidxGdayRIGhfV0tkNI4J2Zf5s2Bw6Vigsb1vS+dIBASiai8nWYumkmS+UXjFXBE058RMyAr+5KAvNi0Hg4YW8VJFC/E3Ky3vYMkmhCfiPSZq/AaQYVTEZ9q+0svktgaXc/vXKhSqNteYgbaHp2PUGNUmTFktX9N4oIGLwOx4vS7FqQH+d9lO2MgD2BQHu4kkPFVqoArTjvQuqH8de2dC/bO8w0rlrqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTLWPDomSbV8KcUoZ5HiuIUqAC+3vLa3KCByhOBS6sg=;
 b=fPwtZpYOPqA61rhpBt29ggTJJS/U/P1se1cSojs/NbHHzHzPIFpvuBTdqT0kSuQtYtDqkbGU5ueroiYjO3/b6vArRV+8WXzptziHq5S0jbzBsvOfSEVFJtpsjwcrDPm+j7yZqtONSStLNrG7Gr4ZzRR7pMs1UMxKOd0ZoKUy2KS6aWwHch/8GWNplyCWzKyX9/qdHX4QBc6iodaD0iBS6qES31iiHe/iNnaIZiW90awPwXWoUG5LRSX3ROm1UiSCtMymH9ba+8nsMUD3Z1O/SxfI6eTNwxRVnQSAlq3+pImYMZj6x/Oei1pM02G8N+HtQWkGFV8B2gg5LOB8U3kdUA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.12; Fri, 5 Dec 2025 18:35:35 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 18:35:35 +0000
Message-ID: <3d26bfb2-2c82-4625-a371-96879ff43c3d@nvidia.com>
Date: Fri, 5 Dec 2025 10:35:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/13] mm: introduce AS_NO_DIRECT_MAP
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "baohua@kernel.org" <baohua@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-4-kalyazin@amazon.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251205165743.9341-4-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::11) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ad7be7-dde8-4b89-d776-08de342d1479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emFnNU9pQWRWcThHU2dUMFF1bXVVK0wxQmdTTjF1WnRPVXNHVURPRmVsSzFi?=
 =?utf-8?B?UEh5aGFwdUJKRlU4V1RzRFFYNGdudWpuUGlWUVgzYUZQcitHSDBXc1pjcjlr?=
 =?utf-8?B?cGNGRGVIQ015b3hoMWNtaW01L1BLeWF5Q2M3TkQ2Qzd1Wkc2eU1YaGJoRTRm?=
 =?utf-8?B?UmpKL1pYNjRXNGQvYTFiazVwUnVCenRhOGlLd0tiMjVtdSs1M0ZPMlBRNGxI?=
 =?utf-8?B?WHZ2N3BDZjJ1d0xOUkxodWpQYVE2YnFqVk81SGJXVUMvSXN2VUxvVm1KZmdS?=
 =?utf-8?B?MnRoR1lQQzVzS2l4NVRSK29qb3BMcVNIbWhPT1FjdFg5cGZmejFicEZ4L3ls?=
 =?utf-8?B?QktudWNWZkhEODBtZ0JQRjJpZHN0alM2djQ2Ri9HeHlEamRFajZvSTRLMWtm?=
 =?utf-8?B?NGlRSUpBdENGMkhEcFZ0VEo2MUg2S1JWWk0zbWIrQXJnckpwMEx0R3RQWjR0?=
 =?utf-8?B?ZkxLVmlKbm42eXVhTUhDR1NWYmFuTUtmYWF6aHVHdUdvZGNpUDVkZHg4SzlK?=
 =?utf-8?B?R3o1bWp0RUxrQ1lKa3ZYQ3o0ZWhhUGxvcEs1Y0MzaTg0R1hQaHRtOXk1K3hk?=
 =?utf-8?B?d3VaVjJvMGNDOXdYREU1cU5RMmk3WUpyRmhGdjI2aGtYMUZzejVFM3J1TUpU?=
 =?utf-8?B?alRGbEZXUG9NREtieXhyckVDUFBjZi9yVFdTZkNwM2lpQmdHSUk0MFY1eHJj?=
 =?utf-8?B?UWgxd1lUeHc1M0c0MlY1MWF2WlJwa3NyT1hyaWEvTGpjd2NHWFM2eWwxeEJF?=
 =?utf-8?B?dElkaFJzZmhGTTJiQzZhN1ZuVTI3VjY5TTgzaUtVRzJYOXRzbGVoeVRxNDNE?=
 =?utf-8?B?eGNhVGw5dWY0YmFjbFZMSFZyeHhBZkx5cWZmWnV5SlJHbEJWWGgxbTEvb0Zn?=
 =?utf-8?B?cy96K2RpRkVWNUxQWHFiWlZpQ2RuT2NlSkxTV21GcFM1c21LcGhjblRwZWQ5?=
 =?utf-8?B?Q29oWXNvazh2R0k2UzV1L1BxZzVPaEZNK2hTWDk0bWRJMHI4cWZza0pIaWxC?=
 =?utf-8?B?UGJXYmx5dGs1dU1tYzcvNjlvWHdGSnpMekRROE5hK0NZd25DRkkzVDQ1V1VH?=
 =?utf-8?B?aHZ6S1U1cWNPRVRuVkNFZUlPZGdxdDBQOE1xaVVuTTdLeHoyT3RuZVNjeU1i?=
 =?utf-8?B?MEcyaUhqUnZGTzk2dzdKM2I0ZUxTU21nVTMwR2ltUk9KL2tZeklXVXg3enM5?=
 =?utf-8?B?eDZZb3FSZ1FvSDZhUU5HVytPWlkwNUxqL3psaDcrdkd2WkJUQ2ozc2NQMk1T?=
 =?utf-8?B?Qy9YYklmd2hIN1B5aC9RVC9ZeDEwRUxHSVFqMkI2cHgrN1Q0UDFzblFCOC9S?=
 =?utf-8?B?QUxqaGppdC9yd0lhZ2ZKTWdheVhxQW5reFE0TzBrWk82WENoSmdTSHlmeWc3?=
 =?utf-8?B?Q3NXRGk1dHZxeHJXM3NWd0VERktUWVppbzZIY1ZscjdGYkZuRVgzMURXNzdm?=
 =?utf-8?B?NU41OXZUT29DazhpUjdBQVQ3Mm5CdkdkVzk4cW1iSllKT2tYV3YyQmNJR25s?=
 =?utf-8?B?SVZIZTlEeFFONlpaYnRKMnhac2ZvRGJQbWluZjh2UExqWEJEVmV6VkpOdVpN?=
 =?utf-8?B?eStSN0NsRSszeGp1Z1VmMXM4cXRoNHZsamRGY2d5RTlZR2wxZmtWL3dFZ2xI?=
 =?utf-8?B?eEVVYXZJODVycmFsNHdmOGF6SUNjNVFBczIwUEcwOEVUWE5SZy83RGxISm53?=
 =?utf-8?B?cEwxMDZ3RTZDWHhaVXR0QmdiTmN0U1cySTRFaTBkSHBRcVdmeXl6R1hUUkdZ?=
 =?utf-8?B?a1AzZVJGakl2SXdhUEZsTXBtNkZlSFYyMGJoWTRUZmNtZDdVcG1rOWNnVkUr?=
 =?utf-8?B?dW9SbWdOZU9LTTZXSXE5dERRQXNtOC9yMDYyZGZLRHB4aFUvaHdtK0dDcUpj?=
 =?utf-8?B?MkMyMGNCc2pobDdKWENpbzdYU0pHblJLcENzTUliYzVnMkd5eHdkTDlPc2Q1?=
 =?utf-8?B?MWYwVE84MXpTMngvOWUxb3cvK2IxbUVheTErUDU2Mk5ENzEwTHpkRmRoOFRU?=
 =?utf-8?Q?cnKz5jPwMS8C7yzHw4sz4+F6FhA2L4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEVmUTJPdmxmazJGOVZHeXZyMXI4ZnBnemFiSU1sNXd5bE9UNnptcjVqZEVv?=
 =?utf-8?B?Mm1Pcm5HbXcwTU1XelRlRGZWcnlacDBLOElqVXFOZnpaODFhd3dYcHhpTE40?=
 =?utf-8?B?bWxxTVVLd1NiVkF4QjZzUmExUnA0OGFnQk54TzhXVmFic0syK3VFU2RIVGs0?=
 =?utf-8?B?dUEyYkliL3d3MTZzbXhYMVpnSlFQQklwaDhDTjV0aVhmZmhrWUFyYUdwWGE5?=
 =?utf-8?B?RTlPanZaVmNyMTJhd0RMUEFjTm5sMXRrRm5tNjFEelM0MmR1bEE3YnA2OXNT?=
 =?utf-8?B?RkRrQmk3MTlBWE5pSzdZTW43QVU2L29Gc01ya3JNRG5RT3NjczBERzNMK2Zh?=
 =?utf-8?B?WDFqbzF0WGpPTTVHKzZkRWVJWjdlVXpSWldiQlpHMUNvRnhqcFdtZDhnelFR?=
 =?utf-8?B?RlR4NjFqN0xGRitKYVNHbDFmd2wveUFIZGNUNEtJZzZDN1BxVFNjOGQrUGsr?=
 =?utf-8?B?d2NucjdhcmVMdVZEVWFsQXdqU3Y4aW5ySDMvWCtacUtpclptQ1pyWktWODM0?=
 =?utf-8?B?dXp5c1BNUnB1SGNKYXZrSldRZDAzR1VDdm8zZGRIRURtNTQrczQ4V1pLWHI2?=
 =?utf-8?B?OFJ5QVo0aTRFR0ZOSkFmVkFFNUwvVE5FTnFMZm1mVDFYeFZEczVRYVhrVXpj?=
 =?utf-8?B?YVRjbHBkeDVPVjIwaVFscVhEWFd6U1JiNi8rMk5Fc1MvdUt1TkloTDBDc1Fk?=
 =?utf-8?B?Q0Z5QXcvbDNTeGZvd01BczVYa2lBMEhHMm9HYjB5cHJraG80T3dqT2VDZndt?=
 =?utf-8?B?NHFHNkl4cjBaSGVyVjNZM3U4ZUY4OW9weElIc0wyVGIrd3pGNEJwdGpsQUpO?=
 =?utf-8?B?SUZpQVM0QldvMithUytOQXJwMnBnQ0lXRGYwM3FCVHVSQ2syLy95SklPaUFS?=
 =?utf-8?B?YWRUVDRyZE1UUVpHMXhyUGljcWFxVjlhNUNiRWxsSWQwbm9NSlRyNXQzdnpZ?=
 =?utf-8?B?amVDQlZoRXRYMXpIbEhsZllSZEs4alZwOUIvRWlQYmVUVUYrRHMyVU0yN1Bs?=
 =?utf-8?B?S0J6bXdwS3ZaTEgzT3VuM25CMnlUaW41M1NVTGNIUnJQY001MDBNR1pqVEQ3?=
 =?utf-8?B?ZVlOTkd3VDJORlpsN01HZUZuTHZSOEJwNDYxbDM4NUNJdnMvSTV0OWM4a1JY?=
 =?utf-8?B?cDhjbU9NK2ZSdUx0dG9QYmVuVk1nSFJmNmpBR1hYTWt2UENtU3IyS3AwSUwv?=
 =?utf-8?B?T0dyQ3l1anpnS2JnVkNQakgwYlcxN24xMkdtWUw1a29GanZuOXFYSmM3Rld2?=
 =?utf-8?B?TDl6OGdBOTRJT0xRWFhZS244NWQxZzNvRms4ZGZCTk5uRERlUFBRekVDTEtB?=
 =?utf-8?B?Sm8wbDBsQ0o5Y0JzNFVuVHROQUlvZ05VQkpPaVdQNVQ3bk9jN0Y0YlFCdzJB?=
 =?utf-8?B?cGNKTUZuamVUeXNaaWhOUlZEajA1bWlnSHI0dDlJdzhFUnZmUmI2M2VDbng5?=
 =?utf-8?B?WTNOVWFwcldGVUJtY2NPZEN2MDNIWk5pQUNJUkFzdG9Ba041ckJzYjd5dEky?=
 =?utf-8?B?Mk44LzlyS3dhekRFTkdoVklPZUtHam5VR1d4S0E3U3l6anFNcDRZNm8vMVZ1?=
 =?utf-8?B?Y1BRcHVEQ1ZybkhTd043bHA5cmJwZ0kwYmFoQUpxVEduc0laVUk1SzlneXFK?=
 =?utf-8?B?Tkxsd0cwN2sxc1RqYUcxUDJGbmhGajFpVGlxb3VrVDdZTENETnk4a21WT1N6?=
 =?utf-8?B?S1RWaVBwVkgvRTAwSXlPdzJkL3k3STRjeUZQOWNNRXVwL1hsbG5DcXdlYTdP?=
 =?utf-8?B?YUYxUC9nMDFTSkIrUVJMTytKYnphalZLZUVuZmFDTW9DUWJLUWsyZlpYQ0Yx?=
 =?utf-8?B?QkJ5aUgrQmc5WmpuNGRxNUh0WERueVppNXZBdEFmZDV5TTY2Tlh5bU9ISW1E?=
 =?utf-8?B?TjdRVlVueTc4MDRGTjBkRkpSamtYSm5WWVM2c2kxNXR1L1crR0x6TDJNTlZE?=
 =?utf-8?B?QTdEM0pLb3BnTE5ZdWd1c2dPdHNrazNScVJGbmxpd0M4ejMzcXlDU2pDRWVJ?=
 =?utf-8?B?Z0w2K1FsaitTOER2S1lEazhSTEtyckttR2NWZnk3NlFYOW05OEZEdm9wMVF5?=
 =?utf-8?B?dG9QMmNwVmkwMjlKbmJBRjdGc2tsOUFBODRCQlNTZlFhREdNcGp3ZUllT0Er?=
 =?utf-8?B?dlhDV3NST2dXT3UvS2pYWnRLR2J6eVJpdnB5WjE0dWUxNlBBSlF1aUt6akpz?=
 =?utf-8?B?Mmc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ad7be7-dde8-4b89-d776-08de342d1479
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 18:35:35.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghMqfjO4aQow8trsEcsHwGff4kQjm8T3kYZa2E3JEp4VIOkTN2Gr3bAWN3h7qmc3KRq43YOzv58ao6rSS5pH2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Stat-Signature: c4sxwbxcxxgzyaq747j6n4ituwy4ofrm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45ECE14001A
X-HE-Tag: 1764959743-280390
X-HE-Meta: U2FsdGVkX18GTf+xasOYtFR3qTVGWSqXC1a96MzMHisZrPpSrB8vKQmBTvucvHq7CI1XR9D5ZLcDAda6I5wT8/ZOv2x89Sw1c/K4wd0hYhrdSliuLKjysximDNEa5WJPGvtN/WMc/RJMMKLGXMu+QpPI06EyGgpLXc+Y8kWbmRYfIBvgr3a+bxKSHFw5NvlEOpBdf6oU/5oj1LcbYx6JQlFIL4YF6GjWhIhP5WkzexKCLaJErXSPxOjOIzv4T/K4rJ4sr6c9Uz3PXkR6A+PCVLvpZbdMefba75K1Yd1p3vVar6TDUdAVXGflDqZ24nGxJFpVIT17axSx6FpwUVX5i6LAllmoo8MKyzAjsqkGaJEqBNBtyORhVd73vZvm7lgqz97+X/S8DPhnpmyz1stmk9Yb3Nx47qmrK4ZVikjU4Gxru8PS+3O34k2oHDhqyMG5DIzfQLAxmnzVCeYXfgYo8xZmrYSK7F5KcvdhKa7qW0IFLvXX0WMM7cWEQ9mwV7DDrYZFLoLca2BzMPXJkCUgmDoG4FVPbxzMMm1PPsbwBXSMDjUI9agRPe1sGjD5MzNGOKpcmS3OKAklFtkQwW+NNQBNhbx7SU9/2c5SZGHiRWLO9u/M4DhDoh2QyV1Avc6PGwJAhgUXw1ZNi0cj1tVD6mY7jU4sUFwWO9SkBDoCH8tyUHprt2iUBCfqA+E7p0doyuitO+B0ETl67ht+vkS8vslcTzgUPUt12SfGr29FcgHmsHP6jDu7cABHgebR3cQ0AAyoS6X6jnhel/nuvsYsRenb0ZMMxq6CowAlF7LdcV6pzX+2ixsBKfILJPXiy0fP9Aij7ucB2ZUag0u6UMOF/iyG7mrdqMTHm3nS65u0CUt28b6l54cGTN+y/bWpqlUjcbILLYtO/Mv1vuEgPOIylY3UeZ8nJ1JAcmacQ5BUxCwYXd3E6kfFl8MBgVyO98GrJwBrtUfw0Ly6rvLiut/
 aAkfNc7G
 BmpOFGs/uDShByuF6JzhZaeUVFmAzwjxRUNaZU858getxCKh/J7YAObEHPhYvfIBp46cfDAKkkBFVePN2PvohhnTLb+85lLdOu05QV/1u3pKtJzpjP4EYFRyghZcO8ZFBAjeAvRjjkXtCRlaZD3eLjotLEXV1/7C88GIYhAwEfBC/bfUuGF29uc0uJXrPuFIoG+jJ2QwWkoK3DWyhr0scDKsrzsPXBFW3T0UBtvUqlc0MyXlscSPsJb4LToEN1W22IZsnVL+3X7Umo1AoPOJ92QSM9T0jtkCfuO78YVAo7YKuXeBjiiHXiGkl0f9djPUpCmOwdb6gT/iKXg5YUB/EtciBAajLf5de8iijza4JbstwgmbyjXwvOQh46nyLgGk4WnSes8VKTPN+Gy+zABY2dNriJKHVLtrMaIWAAovY/d8SS3e3MJQfU2dwxFEvP6+9evQiupc8ea46LqmrUDZaZC4tzIuty1dd0l1rANu6ucTnxgn1DYWXnn3YrQ9u88Qw6YgwtiUO07Vr/RX4R+xDSFAr/JyDfKfLuNbvBj2EnJtqIP/TYAiBwIbNj7iSpxjgtd77k4Ld9LxztV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 8:58 AM, Kalyazin, Nikita wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.

The above paragraph can be part (most) of a commit description for
a separate patch for the gup aspects. Let's split it out that way,
because it is a distinct change, and the diffs can stand alone
from this patch here.

thanks,
-- 
John Hubbard

> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>   include/linux/pagemap.h   | 16 ++++++++++++++++
>   include/linux/secretmem.h | 18 ------------------
>   lib/buildid.c             |  4 ++--
>   mm/gup.c                  | 19 +++++--------------
>   mm/mlock.c                |  2 +-
>   mm/secretmem.c            |  8 ++------
>   6 files changed, 26 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index a17fabbc0269..d51e0c0404e2 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -213,6 +213,7 @@ enum mapping_flags {
>   	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>   	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>   				   account usage to user cgroups */
> +	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map */
>   	/* Bits 16-25 are used for FOLIO_ORDER */
>   	AS_FOLIO_ORDER_BITS = 5,
>   	AS_FOLIO_ORDER_MIN = 16,
> @@ -348,6 +349,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>   	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>   }
>   
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_direct_map(const struct address_space *mapping)
> +{
> +	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +
>   static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>   {
>   	return mapping->gfp_mask;
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>   
>   #ifdef CONFIG_SECRETMEM
>   
> -extern const struct address_space_operations secretmem_aops;
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return mapping->a_ops == &secretmem_aops;
> -}
> -
> -bool vma_is_secretmem(struct vm_area_struct *vma);
>   bool secretmem_active(void);
>   
>   #else
>   
> -static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return false;
> -}
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return false;
> -}
> -
>   static inline bool secretmem_active(void)
>   {
>   	return false;
> diff --git a/lib/buildid.c b/lib/buildid.c
> index c4b0f376fb34..89e567954284 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>   
>   	freader_put_folio(r);
>   
> -	/* reject secretmem folios created with memfd_secret() */
> -	if (secretmem_mapping(r->file->f_mapping))
> +	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
> +	if (mapping_no_direct_map(r->file->f_mapping))
>   		return -EFAULT;
>   
>   	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
> diff --git a/mm/gup.c b/mm/gup.c
> index a8ba5112e4d0..719e4dbecc09 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -11,7 +11,6 @@
>   #include <linux/rmap.h>
>   #include <linux/swap.h>
>   #include <linux/swapops.h>
> -#include <linux/secretmem.h>
>   
>   #include <linux/sched/signal.h>
>   #include <linux/rwsem.h>
> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>   	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>   		return -EOPNOTSUPP;
>   
> -	if (vma_is_secretmem(vma))
> +	if (vma_has_no_direct_map(vma))
>   		return -EFAULT;
>   
>   	if (write) {
> @@ -2724,7 +2723,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>    * This call assumes the caller has pinned the folio, that the lowest page table
>    * level still points to this folio, and that interrupts have been disabled.
>    *
> - * GUP-fast must reject all secretmem folios.
> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
>    *
>    * Writing to pinned file-backed dirty tracked folios is inherently problematic
>    * (see comment describing the writable_file_mapping_allowed() function). We
> @@ -2739,7 +2738,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   {
>   	bool reject_file_backed = false;
>   	struct address_space *mapping;
> -	bool check_secretmem = false;
>   	unsigned long mapping_flags;
>   
>   	/*
> @@ -2751,18 +2749,10 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   		reject_file_backed = true;
>   
>   	/* We hold a folio reference, so we can safely access folio fields. */
> -
> -	/* secretmem folios are always order-0 folios. */
> -	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -		check_secretmem = true;
> -
> -	if (!reject_file_backed && !check_secretmem)
> -		return true;
> -
>   	if (WARN_ON_ONCE(folio_test_slab(folio)))
>   		return false;
>   
> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
>   	if (folio_test_hugetlb(folio))
>   		return true;
>   
> @@ -2800,8 +2790,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   	 * At this point, we know the mapping is non-null and points to an
>   	 * address_space object.
>   	 */
> -	if (check_secretmem && secretmem_mapping(mapping))
> +	if (mapping_no_direct_map(mapping))
>   		return false;
> +
>   	/* The only remaining allowed file system is shmem. */
>   	return !reject_file_backed || shmem_mapping(mapping);
>   }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index bb0776f5ef7c..506452ee8cad 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>   
>   	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>   	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
>   		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>   		goto out;
>   
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index b59350daffe3..c1eafe29c3e8 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>   	return 0;
>   }
>   
> -bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return vma->vm_ops == &secretmem_vm_ops;
> -}
> -
>   static const struct file_operations secretmem_fops = {
>   	.release	= secretmem_release,
>   	.mmap_prepare	= secretmem_mmap_prepare,
> @@ -156,7 +151,7 @@ static void secretmem_free_folio(struct folio *folio)
>   	folio_zero_segment(folio, 0, folio_size(folio));
>   }
>   
> -const struct address_space_operations secretmem_aops = {
> +static const struct address_space_operations secretmem_aops = {
>   	.dirty_folio	= noop_dirty_folio,
>   	.free_folio	= secretmem_free_folio,
>   	.migrate_folio	= secretmem_migrate_folio,
> @@ -205,6 +200,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>   
>   	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>   	mapping_set_unevictable(inode->i_mapping);
> +	mapping_set_no_direct_map(inode->i_mapping);
>   
>   	inode->i_op = &secretmem_iops;
>   	inode->i_mapping->a_ops = &secretmem_aops;




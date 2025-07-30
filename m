Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501B1C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0FE8E0002; Wed, 30 Jul 2025 05:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D621C8E0001; Wed, 30 Jul 2025 05:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB49F8E0002; Wed, 30 Jul 2025 05:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A604C8E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:24:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72CA4588A7
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:24:19 +0000 (UTC)
X-FDA: 83720395038.22.4552FAB
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89B82180002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:24:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jeawy/vo";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNEJkd9PnAOXAZH/Bh5OduT9auidsQHT2LX4zjrs968=;
	b=lf1aaLxBE22twzwTxLV+gkEgaeiUN0glhVOGo2vK71x414Xub5K0sx7WmVweGwstVvlpIB
	Wz2yXRSuQxrGqkpSc4UrLVXr6/wVoprSqOgT3cNC7slkxyFhK+LbtSzL/Zy6pCitlob0N0
	+sGQTY/Ec9CEpDLtQW7o1riRGVlr3c8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867456; a=rsa-sha256;
	cv=pass;
	b=1pm8SJv0pWDYLIM7Q5JSIKI/g+hwwVNWlux6FBPjiKo2McGZ1yvjpFaHRAFsvxpH9hhIUg
	gvNvxVoHqX7AzNS7CyfwRp6phRmyFSVPQY0x/03s5U43Salpf3Vr3BhbcnGHuSS01aGbGZ
	GTGVPN9uQu+hoxd1d5bZ3k44OscrrNI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jeawy/vo";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TuBvj+SCYaGkf5jqVVWrgVrmVy/ODqM9/KAdseQA9m7OtjGROWYeMuW11QbSNpzNeQKLPgPOslACduS1Asq9Prh+U4tqY2zS02nsXLBjh5c4zgTfThfnBRU4TkFCbvNQjT2oW7RY2IG1LFdEeYU0duyKkadv1z7bdk3KYbE5QOX8HIt5hqFr6DvIdDrDK5qGBhpyYWKb1sS8EptkjSrp6wsrKZSfRNx9dNTIbWvirgytO1cMM/+1lDaJYeO3Rpg1ifQw0zIfIMwYa3DvT06A8GbD/W+xjnw/bI2IHu5uNh9wCgT4e+NC25XmtEXDmRquOc2dw+jM2TTa24nZsmEhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNEJkd9PnAOXAZH/Bh5OduT9auidsQHT2LX4zjrs968=;
 b=SJ5U62xQGKUBnQAz6/uEtt4YC2WUtW6iZmYfPbBk9MxDUR4ERtSE6KfPB9QaYlDrawYiRzSXNU3QnIQgdRt4Aw9YVH6qoqY17FilN+/LTd40WlL8ViVKb0v1o7IN2B6Hn1iYDuByTencG96lzYkqJ3fINhMDACpTqi2KmzpalPdMeoEKewU3vnUCDu4n0fDtYTgIeDPiPlWd7dGa81ozMImWQ4iAt3PRGdVOS9NqEuybYioY6Pwt0B2ZICZAcn5ujEIHFMFeblCiD3bZNC2ubbj5NIjM74SFd+YgQH4MwyOXHAtgOduS5OXeww5I/noOLZ3d7mkZERUpg5ROgNgfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNEJkd9PnAOXAZH/Bh5OduT9auidsQHT2LX4zjrs968=;
 b=jeawy/vodQBS2qEfSP1vo+4SCOMkjIXOSC+nKUjqupHFuLsmA8NVMX/BtIZz7iUDa+WGdblaeffIBMTrqIMI+Nx+4HNYRzwvHa7eiLeFx9PNoWRdbo2m1eubJ3Ly1S7lff0ssEKcgYOXBHz8Z0GPjHSR2lw9wBfJBfWh86CBevDnW2swZ6AKBTNFocvW2PYSOFY7it8NnFcwuORHjv28PTJmMUyNu3GznPmzGjnNf3foWpRXJtYMCYPgkbH78nR94RAJdqlJw2uNquipWJ/dLFCxkzGYWsYilk6VMNYjMr1o0Jst3vjVH5ZQlaFcy8aygP1EeJyrmBLsQp54eMFnQA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:22:24 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:22:24 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v2 10/11] gpu/drm/nouveau: add THP migration support
Date: Wed, 30 Jul 2025 19:21:38 +1000
Message-ID: <20250730092139.3890844-11-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0040.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::8) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f5b1b91-ad72-4f58-d756-08ddcf4a97ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rks2a011THpaTGtDVEZJNklzMzRaTFNaR09kTWlKRFNSTmpCTzE5RTl4SGRH?=
 =?utf-8?B?Nms5N05mWG85NnlNZ1lwd1czWEVDRXB0bEc5aEFRV1FXdnN4bENSbjVLeElu?=
 =?utf-8?B?SWkyYVlSZklOa2xWVWhVdVhoQ3V0RVF4UW1zTUtCYVNKV3pNK3poMEdPcWM3?=
 =?utf-8?B?Uk1SUmlSV04rZzZqZnBjYzFFMHVsa3JUSTFsQWl5aE9jUmRUQmZ0NThXRDdI?=
 =?utf-8?B?UnBVWXRVaFkyM0xZR0pybHQzb3IvOHhOcHZSaXcxcGprRm5KRjBOa2NFNXVP?=
 =?utf-8?B?WkZkNmVQMnNFNFRvM3ZTblI3TjQvdnNVa2lMMmtONktNdkNvdTJDbDYzUHVI?=
 =?utf-8?B?SkE0bjdpS05RbkdQeGRvWEtPeE90QWVRR0NzMFIvWFNXNldpV09jRWhNOWVG?=
 =?utf-8?B?Zmk2TURQVmluN0w5M2YxZ29TZmMxUlcrcHptNmw4aGh0YWl4S1lQdGMzRmE5?=
 =?utf-8?B?MHl5ZDZjU1IzN0FvTVgxMVpwTXdQSFR4ejZkcU9SeDEySFpaaE9qR1dZUm9u?=
 =?utf-8?B?U01XZ2lQYk16NGs2K29RdkJMQTJ4S1l4YzZ2K0hQN21NVkRuZ2NNSmczLzdr?=
 =?utf-8?B?VVJMVDdTUFdlSEk0aVp4SHVkNk4rYlowcjh5VThTNDRlRmR1eU5zU0dyU2xi?=
 =?utf-8?B?anRYM2pVUUh2SWd5LzNDakVDeHNaVTMrc1pFdTdHUEtHOVRsSkVjdVFrL1lr?=
 =?utf-8?B?UzdLQjBUeUI4bURKMzU4SWVaSFJrTTBrUTE1bEY1bnFibzN4UTJiakE5U1F5?=
 =?utf-8?B?VWdac3JZOTFNUm1hWkJWUCtRcUdnenI4bWlCTUVoaE92NDdvbGp5WGk2TTgx?=
 =?utf-8?B?Zlg0NUorbWRXRU1xQnlTK0x1MnI2UG91b1BCZmRvZDJzRkJ6WW9KaTM3Q0hX?=
 =?utf-8?B?c3pHWDJLRHNLWDFMV1h0eVZDOG5tTlB1QWpRQ1c0SmlkbFFMMERMckRVUHlz?=
 =?utf-8?B?aGpqNHNaWDZnRWd6cm0wTEtyRm5NNjFhTFl0WmhHaDNkZDFjMWo5QnM1UG9V?=
 =?utf-8?B?R1JVZ0IzdUhTOXB4MmFKSysvdkZsbTdaZG81M0J6Qy9HZ1dDZC9veFlKRkV4?=
 =?utf-8?B?alFKeHVyNGRLWVZrYk9zR1ZEdk1oZzVSckVVcERpSWQ4K3hHLzVtcStJSjJv?=
 =?utf-8?B?K2FRcFRBUHU0K3dwYk41OXRqcVUrT1QrRmpqeEI4RFNWTmgxeEpya2pHWUZn?=
 =?utf-8?B?c0F6YWIwZE0vVHBQSlBGVWRHTW1tQ0kwOXJaTXBiYnVIZ3BGaGx0ZUZwbFFu?=
 =?utf-8?B?UXhoTm1BNG8wblpWeTl5U2w5Qzl2TjhKNWg4YkZlNHpoWThxdmxmQU10Mkp4?=
 =?utf-8?B?RDc5QVA1MlN0N1hBOTY2TkdyZlRWVVR6ZzFhUGpxRkZ5NGhvY3NVQXNBY1N1?=
 =?utf-8?B?eWJSOE50VVQ4Z0d1OEJiZm9CVzAwR0hpQWsrSUMyRDQxTkZxWkFqbjZUMVZY?=
 =?utf-8?B?TnlZZE96alZYOGF5U2pJNUluTW0waXpXWFFhOUZmNlliMWk2YXhBM3RxSFJG?=
 =?utf-8?B?RXk4R1NvQ2JSUnppNCtsdE5sNG9HMjV6L2VHVmNkMWFjWmVlZXBjWGlQTlJq?=
 =?utf-8?B?OVRybnZMRjlFLzV1TXNmYmQxOGE4eHFEKzhTS0dKNGNteXI1bHpPWGZOeUdq?=
 =?utf-8?B?SzRZRTRGNzdQK0FuSlREQnVFdGtGMkwzakJvaytyL1ZxTFk5UnFzR1BnVTNu?=
 =?utf-8?B?VGlaZ1NxS3dnbU5ncG9DN1FiZ3ZpM2lCTzI3L0t1elRsSGpOYXJweUl5NnAz?=
 =?utf-8?B?K0YzMVNmbWY3Q1ArWUxRKzdtb28zM1hWRTZqVU82bnpsOS9IVzBPU3lTZnZX?=
 =?utf-8?B?T3hkT2djVWZWMjR1RjE3TWwrdHgrK3RHQ3hOV2ZRRE9jeThmWWkxQjhLRDRm?=
 =?utf-8?B?VHlBTDZTQ1FwMFVYOGdtR21DTmZRWFJOZXpMK3EwckNFcHpHOEdQR2xIK3V2?=
 =?utf-8?Q?UKDwvdWo6S0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm4rd1FzbkhUUXA0UWZMYTR5UkpzSXBlK2F6c0xWeXZwQVhQckNaUm5VMm5F?=
 =?utf-8?B?cklCWUhxTTNBT2xibW1hUGpMcFVHYjZkU1BSbmMwYUR0NTBxUmJUVTJtVEls?=
 =?utf-8?B?dFpLT2E1OFJLVHpORVUrcjhONGl1Smh2ay9lMXVuWjkyaU5ldXdvVnZ3TnVL?=
 =?utf-8?B?WTB2TitONml6Wk9QaVZMQnFLWGdZSGZqaUttck82eG1jQUo1TCtKdUVjbEYy?=
 =?utf-8?B?cEFJVStnNis0b2diN0ZqS1hQcG9ZemZwZ2prSEpmaWZLVzU4cEZOVUxBMWpX?=
 =?utf-8?B?Nzdma3F1a2ZYRzFvcGlQQXJCbHJETmVlMkF6Q29DRWNWZDJpckgyZGpzSTRH?=
 =?utf-8?B?U1ZySXZUSnZGbmMzdFZ0TWtJYnRxa1NRamZuWThQRk53dVdZSXJWUEFjTEI3?=
 =?utf-8?B?Ny8wQXhQT0NVSjVRV0dEZlJjZUtKZGNxWHFQZlljTk40N1QveVhsN2p2Z3dy?=
 =?utf-8?B?K0xCSnAvd3hCTzlwb1JzbXBFcitseWphNzZ0S2tFV2VBQnVubTlXajc3NGhq?=
 =?utf-8?B?OGdvckV0REhzRFJFMC8xN2ZPYXlyMkZZZ3NuVVVBZHo5am9vWkM0OCsyTnMw?=
 =?utf-8?B?Rit6WExFVGpxeVZzOXh0Q2x3SzNZWCtvTTRob0VpOU5kWHpCZHRUMjlVakxC?=
 =?utf-8?B?bGJyU3FrNjFrbFg2NU5iYXBIak5xc2pNY0dOdU5kZnRDNmZPZnl6OXdPdHNq?=
 =?utf-8?B?V1ZYN0dsbHdKaXpINS9OcWFWVW1ySjQ2RUQ5YkpkZXNDT2FzU3A3RWtMRTJF?=
 =?utf-8?B?c24vN1dHQ0Z2aFk2RDV6am4vQzB0Z2p6aHF2aTBBaXA3aExnU3JHOGVKUUcv?=
 =?utf-8?B?MG5UZjFWVlRMNm56dndNNnJSMG1hTzRwM21xU1JBaUZwVmhPcjU4Rk96MlNJ?=
 =?utf-8?B?RDRrM3QrYmNVSng3N2xLZHVtUHU5VEpBdnkrcEFIdEhURDBaRWRrTFNQUU5u?=
 =?utf-8?B?Rk5CTWd5aGxqbTNqOXhLWm5oSFFaT3BncG9vNDZuVTZUcUhOVkR4MldKdExw?=
 =?utf-8?B?TzZkcDUwM3NZV0tWb2hhSm92bFVucVBJSk14RFdxaFM5R1pIT3RMN3JMOTZY?=
 =?utf-8?B?VmJjYmp4VCtWcDRwL0pPS3REeURORXl6MXlqTC80RFFEbVBGTlNra2xqSEhU?=
 =?utf-8?B?dTlGaHdHN25IZzN2TG43M2tBMERhTCtER2hGMXBmQXdaRTIrNlJWQWJmdy9P?=
 =?utf-8?B?bzI5OXNTSXhnYWdtNUplZGFwOWdQOG5NaSs0aTdsWkYxNVc0WUJUSHJHTDZT?=
 =?utf-8?B?VzQwRzlscXU1SnJGeSs2OVpvcTBqR0lpaFU1dkF5cHNBeEU4dmJiV0VnWEhl?=
 =?utf-8?B?SnZIL0hkMnU5UTJId1BzZUFyL0dJZGloY0t6N0tpSGlQVVpmalVXQVp6VzZD?=
 =?utf-8?B?QTZsZDB1RmRKVnJOSXBJSnFkMEhTUDA2ZXNnaXFOYVlnVkNHWlIvYkNpS282?=
 =?utf-8?B?TXN6UDJmd1lpVmQ0S2pIK3FNRXJsa3h5ZDZkdXB5cHpvSWxZbW1QNmoyUzBZ?=
 =?utf-8?B?TVQ4QVluYjFIN29waUR5Q0lJeGRzcWRWWWpoUEZXL3F1SnJCTmM0ZmtpUjVF?=
 =?utf-8?B?YTYwY0FuRXpodk1tOEVNSTlLV25nejg0NkhqVTIvaG1abTRCeTViMktTUUNk?=
 =?utf-8?B?Z1NDdlRXUW8wVHZhU0ZCNWpVWTZXVnVwY2x6MW1WN3JoN2pkNGx0QUNXc2NU?=
 =?utf-8?B?RmhnYUxxNjcweXIrZXo2eUp2WUpjcVNCVkU4aXN0K2hUOHc0alkrVDFZamJp?=
 =?utf-8?B?c3dvU242Slh1U05hNUxUTFU1ek0xZnZQRlQyd1FvRVBENkZMQWpDRXlkaHBw?=
 =?utf-8?B?VlM3Z0YzMldhUUNhRDJYQWtIVEVmckptV01YVmd4akRYSWVaVlhVQ09QKzlG?=
 =?utf-8?B?NlFUUnZEcENsVzZsZ2QreFdrdFUzbm1Jb1ZSdjQxNjdYUnpaQ21Qa3AvekdX?=
 =?utf-8?B?aG1YNWp6OENOWkZmVCtqSU1sVERWYlFWWFVRdGVhRzhHSUZ5VTF5QTJwR0sx?=
 =?utf-8?B?Z3E4QjVSb0Z4dzlXTTFPMndOL3krOEp1MXgwYW5INW1EbUlPbVN0aEFqVitm?=
 =?utf-8?B?NzlUY3UrR2lscXVQVGpTNEN3S2VmV3JYTTZqcllCa2sxekpMRHN3ZDNyV1RG?=
 =?utf-8?Q?CDPoaIF4Y7MhnZLFUD2t/nqsc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5b1b91-ad72-4f58-d756-08ddcf4a97ba
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:22:24.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3dwDwizLGelVzKwkCygJW+2WvSv4BK60g4WAOUkHsNJoYY1FvoLlPp6YudspEkcW3st3cNF5zBUi2LO+YEjvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Stat-Signature: ptqa7nmhfk35kaefq6cxdsaqx9a3zkd3
X-Rspamd-Queue-Id: 89B82180002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753867456-991386
X-HE-Meta: U2FsdGVkX1/aSC/QRPtVamG1VIK+Rz+pVkxcVw89CHeyEthcDeGyzEBzHFPhmuBSKEdeK9a2qdfdOk0GNd98EbKzcQq/OSrsfvGYFFudJ5LO38HGiPcEasVLuo6XIAUT0FE7MESroW7GwxnhTe6zYY1ZI5N6TRtuFgSJBCAu/uDSueXRv9VJCcdgPeAaBDOJPa+dufA50MWxsJ2NVsjdrO5CPHi4yU28x0IztqNw3TENbb9UDpSF/gy3wWp2cp3L1Ys6qGi+if4nZ2+VCNrguE9p9pSw0B4unF2YxTWKbCE8N0Z19YwI7cljUrDZUAflfBcLxKRPyH7SCESkNjJ1qyBQOLbudt6GKfS/ARKa0EPHTLqMLvRPG6dg0Txutt0rHb6QmPN5uTpDKgKvKJOby7PvI7f/lBZtxuP/mYlWVN4mAglaMbyX2ppTEYq2h1RJp+TlbRgsvdxgJhg8TktU+CH6oxPNO6NM5vAnuDfZs4Mn53evBf2wlHFPwRVLh/0NBEHFN/oy8ZUcSc6QjGnutSXBYfGHoDMUy2aN1shAF/CkZYtikAJJZ+7QTEx/92gTw6JRdU/C+WyluGSuY1uiktVDfL56kNTV2Fkg5jf0BBQm6yEHY9HxN2pj37WrCxedHtS9zFDmGkMm0/ik5nMo4fkHb+A2BcostQXh/UY8G5KkZMjW7BN9hcrT4zBhnRDszTU/RLQiTXqzyph1lzulE2D3XSm06VDSJGsDdzAyzCUwLkM3KBWpqeYyoxvXFix0OUXLwu5A+JE1+B04XhgB/90O0/s51469oVpQwXIkcZyPnQ/JnUi6L/oTHDOWyB1HYKJgg+FG4AGDgciD71JKC4JQf7eGYyJjC7EkwMR8ao5vQ6J6AGvOsJ/DszEifNs+9ANnXUFQGv7ebbGxANwAXj2ibOuW82Wn4ij/9Pk4lJwZaTTaSjg6QfIvOzvRPKy4nwc2NCwbBUCbILhwp2u
 bLBE5WBA
 kHwbEVfpbF3SwV5ahAMVWwH95us9+UT2iLJsYnvkglFss2gz7OmfZx7MUvLmTSSJEMWtdXGcNPEjTM2bLrcV7RjBHFTV+vtOo6nNeKjlU8EPtx5dTXCxpOSpPJ7NfZOisMjyh6+3hG/EhpSt2hQxG1w+UNKn+8HOYo0Ahox/KAOuEUtx4oI5Mb0AnQWF8d5s7cX7cV2j2krpzy5J117hJmnsguY0tt7/4a1oS9YIVjDBPFbck1r7VrEUG+7qNndohRultkND3V5VH53qHUGH8gGpNqBKFG90W5gP4J4wxJXOjSacR6uHc6CDiMTqz30bt18zg5dzbE/06ed8m8uk0IiyH3fBtq4vCQeHruq83ByxL3U/JMzwXUJA3SKg38RXYNmMg65LtSEXSwgjBnAW85IrMHWg8tNo079+ufTrn2f9QTtdtPKh2eYc1BPzc0/YgPB53acZhB+fNPMhsWsCTJ9fxNZvxlA5wa3ub6F7gtS3jTlDD54VH5eypZqoQAUwZq4fPPYqn97CCFT3wYFttBUyZlep7MkOGX7UXDjUH49Xgdimr+HnMlUTK8mczXzqJolk5nWJW1shGbQQ6530Sc19wSI90Ilo0DxTlbNZY4+trH1l0WHadunQGxEaSThv13Bg41MBQlsV5NoSka6QGu1vADFhf0ZvaDcC0S8aQEFJ3Zw46v0ll4iXBRiO96FLns+OfJc6HItceWEVUS49xkQ7iYA8r5KZk/sk6kKwrJGLaimVABNW2RoUxpv0cYcNALwD6BtQsYSooH2dSCNCQwaix2r7IRXKMVYzrcNCIYu7fBLfKdcB92gP8JTB3rnQTcx+e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the code to add support for MIGRATE_VMA_SELECT_COMPOUND
and appropriately handling page sizes in the migrate/evict
code paths.

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 246 +++++++++++++++++--------
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   6 +-
 drivers/gpu/drm/nouveau/nouveau_svm.h  |   3 +-
 3 files changed, 178 insertions(+), 77 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index ca4932a150e3..d3672d01e8b5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -83,9 +83,15 @@ struct nouveau_dmem {
 	struct list_head chunks;
 	struct mutex mutex;
 	struct page *free_pages;
+	struct folio *free_folios;
 	spinlock_t lock;
 };
 
+struct nouveau_dmem_dma_info {
+	dma_addr_t dma_addr;
+	size_t size;
+};
+
 static struct nouveau_dmem_chunk *nouveau_page_to_chunk(struct page *page)
 {
 	return container_of(page_pgmap(page), struct nouveau_dmem_chunk,
@@ -112,10 +118,16 @@ static void nouveau_dmem_page_free(struct page *page)
 {
 	struct nouveau_dmem_chunk *chunk = nouveau_page_to_chunk(page);
 	struct nouveau_dmem *dmem = chunk->drm->dmem;
+	struct folio *folio = page_folio(page);
 
 	spin_lock(&dmem->lock);
-	page->zone_device_data = dmem->free_pages;
-	dmem->free_pages = page;
+	if (folio_order(folio)) {
+		folio_set_zone_device_data(folio, dmem->free_folios);
+		dmem->free_folios = folio;
+	} else {
+		page->zone_device_data = dmem->free_pages;
+		dmem->free_pages = page;
+	}
 
 	WARN_ON(!chunk->callocated);
 	chunk->callocated--;
@@ -139,20 +151,28 @@ static void nouveau_dmem_fence_done(struct nouveau_fence **fence)
 	}
 }
 
-static int nouveau_dmem_copy_one(struct nouveau_drm *drm, struct page *spage,
-				struct page *dpage, dma_addr_t *dma_addr)
+static int nouveau_dmem_copy_folio(struct nouveau_drm *drm,
+				   struct folio *sfolio, struct folio *dfolio,
+				   struct nouveau_dmem_dma_info *dma_info)
 {
 	struct device *dev = drm->dev->dev;
+	struct page *dpage = folio_page(dfolio, 0);
+	struct page *spage = folio_page(sfolio, 0);
 
-	lock_page(dpage);
+	folio_lock(dfolio);
 
-	*dma_addr = dma_map_page(dev, dpage, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, *dma_addr))
+	dma_info->dma_addr = dma_map_page(dev, dpage, 0, page_size(dpage),
+					DMA_BIDIRECTIONAL);
+	dma_info->size = page_size(dpage);
+	if (dma_mapping_error(dev, dma_info->dma_addr))
 		return -EIO;
 
-	if (drm->dmem->migrate.copy_func(drm, 1, NOUVEAU_APER_HOST, *dma_addr,
-					 NOUVEAU_APER_VRAM, nouveau_dmem_page_addr(spage))) {
-		dma_unmap_page(dev, *dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	if (drm->dmem->migrate.copy_func(drm, folio_nr_pages(sfolio),
+					 NOUVEAU_APER_HOST, dma_info->dma_addr,
+					 NOUVEAU_APER_VRAM,
+					 nouveau_dmem_page_addr(spage))) {
+		dma_unmap_page(dev, dma_info->dma_addr, page_size(dpage),
+					DMA_BIDIRECTIONAL);
 		return -EIO;
 	}
 
@@ -165,21 +185,38 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	struct nouveau_dmem *dmem = drm->dmem;
 	struct nouveau_fence *fence;
 	struct nouveau_svmm *svmm;
-	struct page *spage, *dpage;
-	unsigned long src = 0, dst = 0;
-	dma_addr_t dma_addr = 0;
+	struct page *dpage;
 	vm_fault_t ret = 0;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
-		.start		= vmf->address,
-		.end		= vmf->address + PAGE_SIZE,
-		.src		= &src,
-		.dst		= &dst,
 		.pgmap_owner	= drm->dev,
 		.fault_page	= vmf->page,
-		.flags		= MIGRATE_VMA_SELECT_DEVICE_PRIVATE,
+		.flags		= MIGRATE_VMA_SELECT_DEVICE_PRIVATE |
+				  MIGRATE_VMA_SELECT_COMPOUND,
+		.src = NULL,
+		.dst = NULL,
 	};
-
+	unsigned int order, nr;
+	struct folio *sfolio, *dfolio;
+	struct nouveau_dmem_dma_info dma_info;
+
+	sfolio = page_folio(vmf->page);
+	order = folio_order(sfolio);
+	nr = 1 << order;
+
+	if (order)
+		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
+
+	args.start = ALIGN_DOWN(vmf->address, (1 << (PAGE_SHIFT + order)));
+	args.vma = vmf->vma;
+	args.end = args.start + (PAGE_SIZE << order);
+	args.src = kcalloc(nr, sizeof(*args.src), GFP_KERNEL);
+	args.dst = kcalloc(nr, sizeof(*args.dst), GFP_KERNEL);
+
+	if (!args.src || !args.dst) {
+		ret = VM_FAULT_OOM;
+		goto err;
+	}
 	/*
 	 * FIXME what we really want is to find some heuristic to migrate more
 	 * than just one page on CPU fault. When such fault happens it is very
@@ -190,20 +227,26 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	if (!args.cpages)
 		return 0;
 
-	spage = migrate_pfn_to_page(src);
-	if (!spage || !(src & MIGRATE_PFN_MIGRATE))
-		goto done;
-
-	dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma, vmf->address);
-	if (!dpage)
+	if (order)
+		dpage = folio_page(vma_alloc_folio(GFP_HIGHUSER | __GFP_ZERO,
+					order, vmf->vma, vmf->address), 0);
+	else
+		dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma,
+					vmf->address);
+	if (!dpage) {
+		ret = VM_FAULT_OOM;
 		goto done;
+	}
 
-	dst = migrate_pfn(page_to_pfn(dpage));
+	args.dst[0] = migrate_pfn(page_to_pfn(dpage));
+	if (order)
+		args.dst[0] |= MIGRATE_PFN_COMPOUND;
+	dfolio = page_folio(dpage);
 
-	svmm = spage->zone_device_data;
+	svmm = folio_zone_device_data(sfolio);
 	mutex_lock(&svmm->mutex);
 	nouveau_svmm_invalidate(svmm, args.start, args.end);
-	ret = nouveau_dmem_copy_one(drm, spage, dpage, &dma_addr);
+	ret = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
 	mutex_unlock(&svmm->mutex);
 	if (ret) {
 		ret = VM_FAULT_SIGBUS;
@@ -213,19 +256,33 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	nouveau_fence_new(&fence, dmem->migrate.chan);
 	migrate_vma_pages(&args);
 	nouveau_dmem_fence_done(&fence);
-	dma_unmap_page(drm->dev->dev, dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, PAGE_SIZE,
+				DMA_BIDIRECTIONAL);
 done:
 	migrate_vma_finalize(&args);
+err:
+	kfree(args.src);
+	kfree(args.dst);
 	return ret;
 }
 
+static void nouveau_dmem_folio_split(struct folio *head, struct folio *tail)
+{
+	if (tail == NULL)
+		return;
+	tail->pgmap = head->pgmap;
+	folio_set_zone_device_data(tail, folio_zone_device_data(head));
+}
+
 static const struct dev_pagemap_ops nouveau_dmem_pagemap_ops = {
 	.page_free		= nouveau_dmem_page_free,
 	.migrate_to_ram		= nouveau_dmem_migrate_to_ram,
+	.folio_split		= nouveau_dmem_folio_split,
 };
 
 static int
-nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage)
+nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage,
+			 bool is_large)
 {
 	struct nouveau_dmem_chunk *chunk;
 	struct resource *res;
@@ -274,16 +331,21 @@ nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage)
 	pfn_first = chunk->pagemap.range.start >> PAGE_SHIFT;
 	page = pfn_to_page(pfn_first);
 	spin_lock(&drm->dmem->lock);
-	for (i = 0; i < DMEM_CHUNK_NPAGES - 1; ++i, ++page) {
-		page->zone_device_data = drm->dmem->free_pages;
-		drm->dmem->free_pages = page;
+
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) || !is_large) {
+		for (i = 0; i < DMEM_CHUNK_NPAGES - 1; ++i, ++page) {
+			page->zone_device_data = drm->dmem->free_pages;
+			drm->dmem->free_pages = page;
+		}
 	}
+
 	*ppage = page;
 	chunk->callocated++;
 	spin_unlock(&drm->dmem->lock);
 
-	NV_INFO(drm, "DMEM: registered %ldMB of device memory\n",
-		DMEM_CHUNK_SIZE >> 20);
+	NV_INFO(drm, "DMEM: registered %ldMB of %sdevice memory %lx %lx\n",
+		DMEM_CHUNK_SIZE >> 20, is_large ? "THP " : "", pfn_first,
+		nouveau_dmem_page_addr(page));
 
 	return 0;
 
@@ -298,27 +360,37 @@ nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage)
 }
 
 static struct page *
-nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
+nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm, bool is_large)
 {
 	struct nouveau_dmem_chunk *chunk;
 	struct page *page = NULL;
+	struct folio *folio = NULL;
 	int ret;
+	unsigned int order = 0;
 
 	spin_lock(&drm->dmem->lock);
-	if (drm->dmem->free_pages) {
+	if (is_large && drm->dmem->free_folios) {
+		folio = drm->dmem->free_folios;
+		drm->dmem->free_folios = folio_zone_device_data(folio);
+		chunk = nouveau_page_to_chunk(page);
+		chunk->callocated++;
+		spin_unlock(&drm->dmem->lock);
+		order = DMEM_CHUNK_NPAGES;
+	} else if (!is_large && drm->dmem->free_pages) {
 		page = drm->dmem->free_pages;
 		drm->dmem->free_pages = page->zone_device_data;
 		chunk = nouveau_page_to_chunk(page);
 		chunk->callocated++;
 		spin_unlock(&drm->dmem->lock);
+		folio = page_folio(page);
 	} else {
 		spin_unlock(&drm->dmem->lock);
-		ret = nouveau_dmem_chunk_alloc(drm, &page);
+		ret = nouveau_dmem_chunk_alloc(drm, &page, is_large);
 		if (ret)
 			return NULL;
 	}
 
-	zone_device_page_init(page);
+	zone_device_folio_init(folio, order);
 	return page;
 }
 
@@ -369,12 +441,12 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 {
 	unsigned long i, npages = range_len(&chunk->pagemap.range) >> PAGE_SHIFT;
 	unsigned long *src_pfns, *dst_pfns;
-	dma_addr_t *dma_addrs;
+	struct nouveau_dmem_dma_info *dma_info;
 	struct nouveau_fence *fence;
 
 	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
 	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dma_addrs = kvcalloc(npages, sizeof(*dma_addrs), GFP_KERNEL | __GFP_NOFAIL);
+	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns, chunk->pagemap.range.start >> PAGE_SHIFT,
 			npages);
@@ -382,17 +454,28 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 	for (i = 0; i < npages; i++) {
 		if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
 			struct page *dpage;
+			struct folio *folio = page_folio(
+				migrate_pfn_to_page(src_pfns[i]));
+			unsigned int order = folio_order(folio);
+
+			if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
+				dpage = folio_page(
+						folio_alloc(
+						GFP_HIGHUSER_MOVABLE, order), 0);
+			} else {
+				/*
+				 * _GFP_NOFAIL because the GPU is going away and there
+				 * is nothing sensible we can do if we can't copy the
+				 * data back.
+				 */
+				dpage = alloc_page(GFP_HIGHUSER | __GFP_NOFAIL);
+			}
 
-			/*
-			 * _GFP_NOFAIL because the GPU is going away and there
-			 * is nothing sensible we can do if we can't copy the
-			 * data back.
-			 */
-			dpage = alloc_page(GFP_HIGHUSER | __GFP_NOFAIL);
 			dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
-			nouveau_dmem_copy_one(chunk->drm,
-					migrate_pfn_to_page(src_pfns[i]), dpage,
-					&dma_addrs[i]);
+			nouveau_dmem_copy_folio(chunk->drm,
+				page_folio(migrate_pfn_to_page(src_pfns[i])),
+				page_folio(dpage),
+				&dma_info[i]);
 		}
 	}
 
@@ -403,8 +486,9 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 	kvfree(src_pfns);
 	kvfree(dst_pfns);
 	for (i = 0; i < npages; i++)
-		dma_unmap_page(chunk->drm->dev->dev, dma_addrs[i], PAGE_SIZE, DMA_BIDIRECTIONAL);
-	kvfree(dma_addrs);
+		dma_unmap_page(chunk->drm->dev->dev, dma_info[i].dma_addr,
+				dma_info[i].size, DMA_BIDIRECTIONAL);
+	kvfree(dma_info);
 }
 
 void
@@ -607,31 +691,35 @@ nouveau_dmem_init(struct nouveau_drm *drm)
 
 static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 		struct nouveau_svmm *svmm, unsigned long src,
-		dma_addr_t *dma_addr, u64 *pfn)
+		struct nouveau_dmem_dma_info *dma_info, u64 *pfn)
 {
 	struct device *dev = drm->dev->dev;
 	struct page *dpage, *spage;
 	unsigned long paddr;
+	bool is_large = false;
 
 	spage = migrate_pfn_to_page(src);
 	if (!(src & MIGRATE_PFN_MIGRATE))
 		goto out;
 
-	dpage = nouveau_dmem_page_alloc_locked(drm);
+	is_large = src & MIGRATE_PFN_COMPOUND;
+	dpage = nouveau_dmem_page_alloc_locked(drm, is_large);
 	if (!dpage)
 		goto out;
 
 	paddr = nouveau_dmem_page_addr(dpage);
 	if (spage) {
-		*dma_addr = dma_map_page(dev, spage, 0, page_size(spage),
+		dma_info->dma_addr = dma_map_page(dev, spage, 0, page_size(spage),
 					 DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(dev, *dma_addr))
+		dma_info->size = page_size(spage);
+		if (dma_mapping_error(dev, dma_info->dma_addr))
 			goto out_free_page;
-		if (drm->dmem->migrate.copy_func(drm, 1,
-			NOUVEAU_APER_VRAM, paddr, NOUVEAU_APER_HOST, *dma_addr))
+		if (drm->dmem->migrate.copy_func(drm, folio_nr_pages(page_folio(spage)),
+			NOUVEAU_APER_VRAM, paddr, NOUVEAU_APER_HOST,
+			dma_info->dma_addr))
 			goto out_dma_unmap;
 	} else {
-		*dma_addr = DMA_MAPPING_ERROR;
+		dma_info->dma_addr = DMA_MAPPING_ERROR;
 		if (drm->dmem->migrate.clear_func(drm, page_size(dpage),
 			NOUVEAU_APER_VRAM, paddr))
 			goto out_free_page;
@@ -645,7 +733,7 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 	return migrate_pfn(page_to_pfn(dpage));
 
 out_dma_unmap:
-	dma_unmap_page(dev, *dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_unmap_page(dev, dma_info->dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
 out_free_page:
 	nouveau_dmem_page_free_locked(drm, dpage);
 out:
@@ -655,27 +743,33 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 
 static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
 		struct nouveau_svmm *svmm, struct migrate_vma *args,
-		dma_addr_t *dma_addrs, u64 *pfns)
+		struct nouveau_dmem_dma_info *dma_info, u64 *pfns)
 {
 	struct nouveau_fence *fence;
 	unsigned long addr = args->start, nr_dma = 0, i;
+	unsigned long order = 0;
 
-	for (i = 0; addr < args->end; i++) {
+	for (i = 0; addr < args->end; ) {
+		struct folio *folio;
+
+		folio = page_folio(migrate_pfn_to_page(args->dst[i]));
+		order = folio_order(folio);
 		args->dst[i] = nouveau_dmem_migrate_copy_one(drm, svmm,
-				args->src[i], dma_addrs + nr_dma, pfns + i);
-		if (!dma_mapping_error(drm->dev->dev, dma_addrs[nr_dma]))
+				args->src[i], dma_info + nr_dma, pfns + i);
+		if (!dma_mapping_error(drm->dev->dev, dma_info[nr_dma].dma_addr))
 			nr_dma++;
-		addr += PAGE_SIZE;
+		i += 1 << order;
+		addr += (1 << order) * PAGE_SIZE;
 	}
 
 	nouveau_fence_new(&fence, drm->dmem->migrate.chan);
 	migrate_vma_pages(args);
 	nouveau_dmem_fence_done(&fence);
-	nouveau_pfns_map(svmm, args->vma->vm_mm, args->start, pfns, i);
+	nouveau_pfns_map(svmm, args->vma->vm_mm, args->start, pfns, i, order);
 
 	while (nr_dma--) {
-		dma_unmap_page(drm->dev->dev, dma_addrs[nr_dma], PAGE_SIZE,
-				DMA_BIDIRECTIONAL);
+		dma_unmap_page(drm->dev->dev, dma_info[nr_dma].dma_addr,
+				dma_info[nr_dma].size, DMA_BIDIRECTIONAL);
 	}
 	migrate_vma_finalize(args);
 }
@@ -689,20 +783,24 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 {
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
 	unsigned long max = min(SG_MAX_SINGLE_ALLOC, npages);
-	dma_addr_t *dma_addrs;
 	struct migrate_vma args = {
 		.vma		= vma,
 		.start		= start,
 		.pgmap_owner	= drm->dev,
-		.flags		= MIGRATE_VMA_SELECT_SYSTEM,
+		.flags		= MIGRATE_VMA_SELECT_SYSTEM
+				  | MIGRATE_VMA_SELECT_COMPOUND,
 	};
 	unsigned long i;
 	u64 *pfns;
 	int ret = -ENOMEM;
+	struct nouveau_dmem_dma_info *dma_info;
 
 	if (drm->dmem == NULL)
 		return -ENODEV;
 
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		max = max(HPAGE_PMD_NR, max);
+
 	args.src = kcalloc(max, sizeof(*args.src), GFP_KERNEL);
 	if (!args.src)
 		goto out;
@@ -710,8 +808,8 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 	if (!args.dst)
 		goto out_free_src;
 
-	dma_addrs = kmalloc_array(max, sizeof(*dma_addrs), GFP_KERNEL);
-	if (!dma_addrs)
+	dma_info = kmalloc_array(max, sizeof(*dma_info), GFP_KERNEL);
+	if (!dma_info)
 		goto out_free_dst;
 
 	pfns = nouveau_pfns_alloc(max);
@@ -729,7 +827,7 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 			goto out_free_pfns;
 
 		if (args.cpages)
-			nouveau_dmem_migrate_chunk(drm, svmm, &args, dma_addrs,
+			nouveau_dmem_migrate_chunk(drm, svmm, &args, dma_info,
 						   pfns);
 		args.start = args.end;
 	}
@@ -738,7 +836,7 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 out_free_pfns:
 	nouveau_pfns_free(pfns);
 out_free_dma:
-	kfree(dma_addrs);
+	kfree(dma_info);
 out_free_dst:
 	kfree(args.dst);
 out_free_src:
diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 6fa387da0637..b8a3378154d5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -921,12 +921,14 @@ nouveau_pfns_free(u64 *pfns)
 
 void
 nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
-		 unsigned long addr, u64 *pfns, unsigned long npages)
+		 unsigned long addr, u64 *pfns, unsigned long npages,
+		 unsigned int page_shift)
 {
 	struct nouveau_pfnmap_args *args = nouveau_pfns_to_args(pfns);
 
 	args->p.addr = addr;
-	args->p.size = npages << PAGE_SHIFT;
+	args->p.size = npages << page_shift;
+	args->p.page = page_shift;
 
 	mutex_lock(&svmm->mutex);
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.h b/drivers/gpu/drm/nouveau/nouveau_svm.h
index e7d63d7f0c2d..3fd78662f17e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.h
@@ -33,7 +33,8 @@ void nouveau_svmm_invalidate(struct nouveau_svmm *svmm, u64 start, u64 limit);
 u64 *nouveau_pfns_alloc(unsigned long npages);
 void nouveau_pfns_free(u64 *pfns);
 void nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
-		      unsigned long addr, u64 *pfns, unsigned long npages);
+		      unsigned long addr, u64 *pfns, unsigned long npages,
+		      unsigned int page_shift);
 #else /* IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM) */
 static inline void nouveau_svm_init(struct nouveau_drm *drm) {}
 static inline void nouveau_svm_fini(struct nouveau_drm *drm) {}
-- 
2.50.1



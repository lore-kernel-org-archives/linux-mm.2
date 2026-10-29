Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F5E606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=iVm5d+io
Received: by kanga.kvack.org (Postfix)
	id A61106B05B5; Thu, 29 Oct 2026 06:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11BE6B05B6; Thu, 29 Oct 2026 06:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927B76B05CD; Thu, 29 Oct 2026 06:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBBD6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:53:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1082F80312
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:53:05 +0000 (UTC)
X-FDA: 85375351530.19.95C4F98
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31691140004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:53:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iVm5d+io;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSYkK+90hzPOpsoiEF5WyiAXldC3nmK7+4GvNVaGdYA=;
	b=roGvLB9s7gD0sOaKaeP/HXB7SK/qiXYLI+BrtSlZRyEHH4L7fH/8ikhZFlnAD6f/abe+bR
	NHB5eOBdbzfqb6iZY3kTCO006B4KKfze+zhbgqdt3h2ChYrJpGKO3zQaokcjtY/UTz3cPZ
	SRRklFt7Me3VNz9TfnoWGZyOdpwYDFU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iVm5d+io;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793271182;
	b=rYjkujtfqAqSf1xBpRqLbZpfR4uRV1LaDHb1xpzxtrOh40yOCXUe9cxCqxSf6KbB1BRdJA
	BKcvUKWMDRNE6YxMICI8NirzucXPxgKL7GChyAI+CpNhIxhUlqTs7n/QVrQbN0I6fdghhH
	/yqS+Js0gjwZqezEHBnSDKTpzIUyJZ4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1BYQyscBrXZ3DbryPc8tAiKH5sPxeVEYJlSSwqIDR8y/nxiWqJnofbrq5h4LbeaLpNq/r2qB6eG0XjCHZyqiZAECYbeX07hbNA/OpwyTFknG58ffYtOfyQJm8e/r0XHIkPH67edCWAI1Lp8KqAnQuf9w+9idO5OgangT/pqpqce1fwMVVRyP0NUFMTcEmRsTf7eusqM3Mcf2xBps9TR57a+2EyfySZINw16Umvzj7Xc72ancxWSX4DlLYD73cYCGg4x8n252haz0R0A/90veEeZOaa2Eh3KQ7F7My6sGCxx2ebazzkBGjewhVCNgmUA2yNqNcK2Cnm8BmKApA35pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSYkK+90hzPOpsoiEF5WyiAXldC3nmK7+4GvNVaGdYA=;
 b=xdsi7bXOhYpxL+6VeHrGqrt5qZJ+ykPZCrCtvh4+N+4qbA/I2L6fAm1h0BiBzwtcVHSAi9ud598J120q7fj5c3+iW5WakZFJYGWwMFpEwWozOPwbZDjOxQTdgVJzBeGyzgyZb95USYlIebd9x3qdOnPSxr6V7UVgx2aZq3m+NBozB0nkK2J/OxiWiPch9vPKOYZW/Td/hWT/fs3yBmW6DuST6IYXCbZxkxAYB2eUdcLwh2MQ173nrRTfAcNmGQhbj0mJILuEaEZPcgbyDkigKdojVGe++Y2oIvzhVMHc8VAN8Q/lRXIV1B0V4c8pjh4kbily8NcLmQHpfPMYxahVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSYkK+90hzPOpsoiEF5WyiAXldC3nmK7+4GvNVaGdYA=;
 b=iVm5d+iofZI0Z5U2UfIzP4xF+P0t+Sb4KkW/8/CrGbYshHKWlgxxvL93k8BiVeZgUahjp5xgLq/8oQ5c2O8ANCO01etad7owFxEpGQP3Wf7QxOyMr42xG8Fga9Nxk5O+JaFOoQQFvvXAsWQfKSccZf7eYhLItf1uvrMp+qLdqdY=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 DS8PR12MB854423.namprd12.prod.outlook.com (2603:10b6:8:446::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.9; Thu, 29 Oct 2026 10:52:58 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 10:52:58 +0000
Message-ID: <a25827d8-83ee-4e05-8c55-4e6ca8a498ad@amd.com>
Date: Thu, 29 Oct 2026 11:52:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/cma: accept memory of multi-range CMA areas
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::7) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|DS8PR12MB854423:EE_
X-MS-Office365-Filtering-Correlation-Id: 9248576d-5230-429b-5d74-08df35aacb44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003|261022075727099003|261021121427099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	7kSve4YT7/PJ+g8cn3LrgLztAvQi4+yfsZA7ZgN/gVzQI1U8Yx0piLgF1rEkvpx9s7L28B7sfeIJ+jyWwbMHx1GrJVb0oYFmfbmKJchklT6NwcG2QG4fUFlkp90E6sqlX+Nt/G45gXbPNsdoh0Il2MCotSgsIaN51iGZIcj8cl67EqU3utRyU9pQUZOfgIGGNJNa7GudeRB/cOZH4TyGUvnVeb089/kVpfjHdQGKiEUOFWXmbB00Nr4ggmHqY242ScN5RtbCIRHY6QdyRzqcU7s/6eXBuffOGiDYeIBZ0ssYbf571bkU2J/ignFYi6hUX/puyp65ahrOGP2uzgtOUG/6Ij3NDfz6/F5js+Ghxvcw+qCeKvjK+1llCr9VTMG5gHHdHjygHnMCqKS4NLCRmx5w2P2Y9iHT5B8Jz6Jz/KhOhSYJZeHmbE1uwOrF+VI1RItLLhIBEnXGigBFjjHY250IxRbzR99TcVw9AQzYCc3oQolOzoCbFebf6hYYqrdIv5OcGLgaA+zehJ1Si3gvdY5wVFbChkO/tIqQETa3vR3x2Pvv1Fs8eA14rpGzJ6d5/udAiK9Sr4/p7D9Q0RB8Dqlo98NgVQ/dpGq2T73rUINYqxuEgFpFuQHucR94+i+dO+UOcm2qXYduNyoRU7OTGC8ndA0PTvzceJ1biY1wNGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003)(261022075727099003)(261021121427099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzNxaVJlY3NlYjhWdUJJd0tmdWFySHBrQitpdytJMEpWRWtEc25Da1M5UVNB?=
 =?utf-8?B?emFINlN3ZkhmYU5lcUQ2R1QvZGRHNXFKUXpZTWgwbk5tbmJ4WW01UENKQzF3?=
 =?utf-8?B?MEw3cG1Jd0NGcHltRVBodzRrYjgxcEhKZXJMd24wVGdCOVhKOWhRbTZ0V0w4?=
 =?utf-8?B?dk1yL1NNV0tySTZYRGNVR284cGdXdkI2UC9Wd0JwUmtXZzhlcG1sU21mOWdn?=
 =?utf-8?B?eElMRWN0Wmg3OEZZUUExdm5ibmYxZWVhTEdvR1NoY3VZbUwrSFJ4aUIzdm1J?=
 =?utf-8?B?a0F3c0F3djlGT1JJU0p1Yy92SUtkNWVwTHlveUFhaUVWNWppSy9FQ01NSy92?=
 =?utf-8?B?SEQwYjRNMjBhLytMTXluRjQ2aUJyc2dXWFhoRlJEMzIzVHQ1MUtSdWhsem1M?=
 =?utf-8?B?OWhNaEgvUk5Nd2NWSEhFZHlObHBMZXltMy8zeFZRWVdQY3krbmNVOGxVSTRZ?=
 =?utf-8?B?QzhMc0ptZng3RWVNY2FWOXZ2eTg0anh1S1NFOG5ZenN1RmVpczc1SjRya1pX?=
 =?utf-8?B?aTFJeVc1OTRtbjVZSWNCZmxabFE5SGdVQXRIRmpmTVdWdnlpMVR2WVlxVjUw?=
 =?utf-8?B?MTF5UjhxSS9GWmgrSlRvOW5FOUZ1MEZxcVRtTlRKaDFPWi9nYnpmLzFyNlI5?=
 =?utf-8?B?L00rV3dVdDFNSjE2NHpwYytod2xXREJONnJ5T290S04xdlE0NDNTeWJSSVQ4?=
 =?utf-8?B?M3dLb3RrbmMyRmg5Mkhubzh2bzRVaFJkT2VJMnFndFJIWTYvQnJibjRoSjc3?=
 =?utf-8?B?ZGcwTUVPenRoTXBHbzFyME8wczREdEoxcHU1Q2NmWFd0ckFwNnZCV3gycDdP?=
 =?utf-8?B?L3Q1RWVHa3RBQ1VhZkZwbGpMV0VCU3NkUldHck94S24rRTNIMXkzM1Bra2VK?=
 =?utf-8?B?b3ZFQTZqYlArVlFFTTdsWGlxM205dVVrSXFhc1hnVmZHYi85eXRDODBEVk1a?=
 =?utf-8?B?SlBDb28zZmxaUGpTYitXN2NWeHdHd3AxcUp6OVBQUTBPc2grSnZueEdxbkdl?=
 =?utf-8?B?ZEtVYjJ5alBVWUZBU1pvN0lHaFUwTHgzWkx3eDhCTjM5YUgyYitpdHFJY3Ev?=
 =?utf-8?B?ZytWZnZncW1IWDBNVTlsb1NZUjJGcTdScTdQMUVOcHczaU9PMmVWbm1TK0tL?=
 =?utf-8?B?S2NCS0x3QS8wOWNtNlgyZENIV2hrcXQxVkEwc0U5VjlxajFiQkUxL0xwRVZU?=
 =?utf-8?B?RS9JSnVXSUpCZFlEaTVrSnV0TDM3NFZhc2pEK0tGaEh1T0c1WG5XYnZETmlS?=
 =?utf-8?B?ZGNCeUxnT2U2aGZKTEhkbExlSTZ2VHNGUkp5WGlvVENjdWtqeFlKQTJuK3Yr?=
 =?utf-8?B?NXl2bXRzQjZtYTlXbUc3SlNXc0docW43OWdkVFlLMGJ3QjBpV29SVUJyUlVh?=
 =?utf-8?B?WEdlclN5a2dDeEZUVnpzTE1XTVFSOTN0bGZjL20vR0FGOXJwTEkyV2dzVjQ4?=
 =?utf-8?B?N1JtTkJNa0VyVzZmK3AzbVR1Z3ZCU3NXM2pWRVV2VW8vOStzNlk4VGdjODNM?=
 =?utf-8?B?MVBpOFZVUUtNZ1Zva0szbGpSZitPUkdJRGtHVjNrRU41eW1PUVJacXFlaC9L?=
 =?utf-8?B?OTFLNk9aaXlqdkxSandlN09jSTlqbmNJcjhxY3p4ZTBOaDVzOXhaR1UxM29T?=
 =?utf-8?B?cnVkUzZoOHpBZkNXUHQ2cEFVb29NOGY2Sm42ZnJkSFV5YkFUMmlpZVpxaERt?=
 =?utf-8?B?QWRMTmU5WVR1bDFONmpjQTZHRTcwLzVFT2hMcXE3OUxpQjVaSExLSERCczYz?=
 =?utf-8?B?ZEllTm0vVlZXb2NFVVB3UnBWTWRWM3FIczNJZmgwZEdHeXo5TFBjWFR3d3Vx?=
 =?utf-8?B?MThmYVo5amxZTHRxR2VMNFZwNEZPQlNTSlRmN1dVaEQ2YUp0NEszc0IwSmpU?=
 =?utf-8?B?cmUwR3BxUjE0YlNUUHpRaGZlbHM2ZHM5ZnoxZmNWbHltMkNxNGl6RlAyaE51?=
 =?utf-8?B?Mkt6bVM1ME8xcU0rdjNsV1hoQWZrZ21wSHlUQU5zajJJNnJIbDMrSUwyemxI?=
 =?utf-8?B?dnJDK2dZL2JaOGhwempTWXFrZGlHUEt2MjVzaEZwSndJaHhwbE94UEcyZE1K?=
 =?utf-8?B?UmVoM0RjekI2K0VEeEhDRzBoV1NMdThQQVJXZDRDMVUzRkxLaWNKMGczckw3?=
 =?utf-8?B?L0s4STdsd1pFMDh0QVQxbzNYdHlpajkxQ0V0VE9nMlk3MnJqT2RYdjg2ZTZw?=
 =?utf-8?B?RlFOa2hVMTkrZ1NBY3lOVWtjK0JtRXVrTE55RWhwMnhUVGd2Wk1za1FDamRL?=
 =?utf-8?B?dFJPSDlPMFBWZXo4a2pMUDRIdksvVUNGaWNoSTlKYUtuWFMxS2ZROXdDQU5L?=
 =?utf-8?Q?c1eqlnFyWQBTWjJaRQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9248576d-5230-429b-5d74-08df35aacb44
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 10:52:58.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNC2lPs1iXG+PPmBwCO/B3XljNK4hq8cp/V7AEE2H50Jn/xnEyBIH87z2kwtq5km7LTq09getDqDuS9ZUIp6mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB854423
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31691140004
X-Stat-Signature: th7ugmk5r8epcmat399dakkzxa4ttync
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793271182-661605
X-HE-Meta: U2FsdGVkX1+ro7FKc2HUF+BSlV48ZGW/xXhPLiBMS5eSUYb7neHQb/b7nDs8wVpctJeLys+jz98ms4zd/1/wUFmYFpkMnSQzr36zKQDz7AayH1COOXBrH63shoSnNxv/SQVCHZZYewV81Kulzdw85aitpP4cgpwv3gJjqPqSfqhrGRfYUxHAi+tJWT4E9zT4UfAkjnnybKlBbXqLCs7laszVk/GKjhGx+KdOl+7AdtdEhoIOI9Ugh2bFXDLucrSzXKtO4h02fFyReWL3LLa0SuKUwG/ttLCAWvehbzIZsqVPuV95VGNIoAY+uvo2mOafNakF5jzhtBdETc35+qL9Qg7LYszGk3MMG7QPE7yZxDiBjEW1tTI+SQkBtkJH8QU8yCWNV3cSEvdOo0yhz/rRBsWhEDAvsALOHROFLLBzQQKIqzZ729xvDVYFXBm/pripGNnmmEdu2a3acDqf5cb3dMzASir9FYM94Z+8ZZvDdRTj7R7wknV70urOdljeJ+OiIfdoEYcR9fgTWV8e4txH0WvgrTjpMaA53+Dfb4dhuqjxeWJUtv7qnLbqZ7RoAiAcFh25aKF/ORcbnV8yVkBB2UsxpMaToq9nEa6ppkWu94gQ77a2Q324gTKo1QA+Kwofarvatiic7D35wIrtEpofi1g1I8AL73SNE1GPGYS2T1LaUlAMJbdFIhL1G1e8RaW+52Lg0SW4LNJqFC34KyOrkHDfp6NUtyS5o20rP/Bhxr7ktkA+WOO8aaGkmiuT/EsU3AFPh+geIKvnsk3BIs3NeIBQYlbTBYo8DhGMMHDZzHy/RK1m4RRPsOZlKbHpGub/K6AoqRMHDbvAG8mT0zdZg0J5EXRFC+mIfenP68pN8zfuVJEqC6fUFruBtiXC/3KXB/edBtJGQ06elSoLRDyDCoChA2FoIwpbMHLnoM3MYWBNhtwraMDJn6R7qsWuiHATL0p7FW+ot/Q410SG3nt
 AA0kIWh4
 bGdxrNNTr/ABmaeNh3yIRMRfQic0sN8jAI7e+mDOdZLAZc8p5VzldAIl0Dya/hwKH2/SCNmSFoLu+V7xfQU/MqAqRJBVF5NKhLnRepKPwaxsjqQgJ/FOp2DBMECD04lCusn9H1rfNhBpK5DL3+DVkfTSG5GmN2OKhRKrPeQLM2YIsg+tkojGlAZOim+rS2oiRnPhkvsfSlz6BrtpNKvtuBZcmBUBz6ZsPavzDpER23LCHveDRdbTskmcKTR3r5xCD28G3AGw3r3SJRVEQ8anhr+zWXPYNbKEDxtLrJLzS84oDPN+xH6JmvKgRW2CyMMe+HuVvHCW2H7PiPo03d4AM5zeIhMpppMT77nL4Yk3Q6e7M4SXh+U70IM/xavVzvB8RGuzXFNgqFFs7loM1PO9GAiQNOhe6HlNZUmH8o8JZgDRA6i+2fXJ4oETCrI7whU5L+/1JJ6lMSQjLgmD/RqpAnJmQBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


> On systems with unaccepted memory, memblock allocations accept the
> allocated range, but when cma_declare_contiguous_multi() uses open coded
> allocation of multiple ranges, it reserves them with memblock_reserve()
> and they are never accepted.
>
> These pages are released to the buddy allocator by cma_activate_area()
> with __free_pages() that does not check for unaccepted memory, so the
> first access to such a page in a TDX or SEV-SNP guest is fatal.
>
> Accept the memory of each range when it is reserved.

Fix looks correct to me.

Any easy way to reproduce and test on SEV SNP?

Thanks,

Pankaj

>
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   mm/cma.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index a10ea37a261da..0035efb1130a5 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
>   			break;
>   		}
>   
> +		accept_memory(mlp->base, size);
> +
>   		pr_debug("created region %d: %016llx - %016llx\n",
>   		    nr, (u64)mlp->base, (u64)mlp->base + size);
>   		cmrp = &cma->ranges[nr++];
>


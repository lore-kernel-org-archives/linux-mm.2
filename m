Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3A2CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 15:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852EA8E0008; Tue,  7 Oct 2025 11:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AE28E0005; Tue,  7 Oct 2025 11:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718EA8E0008; Tue,  7 Oct 2025 11:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3B68E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:05:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA7BE160207
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:05:28 +0000 (UTC)
X-FDA: 83971641936.13.6E05BA9
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E03F40019
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:05:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s+tXSzvY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759849526; a=rsa-sha256;
	cv=pass;
	b=GTF4zdKo+CHOHg1K0miIXFCBvIQuu38EFmYDwoLAOJqw8i2xphEMxwwxfFLfESJZNJ9pST
	Co21k5+0+LIT3Nm174VBZ0tVHyPgQLtY4Z5wjbWkhpcDMYvnPjhgIKmMmJlCwO5RkZE25N
	IbaHvnHfVHIQCm553ttwGJyMXZQ1i8s=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s+tXSzvY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759849526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbQkE6NFgjfqh92LVizqb2MhlX2uQObyfM0nnGAQFVM=;
	b=Yqk+m7y0/M2ziYG/YuG/U/hMpdxO1sqpgd99Y0sQB7bCMNWSSaW7fdS9hgVWFzPCwRlr1N
	orfx5m/wKXQzqV6Ba3T3+Ifz2ShBnKAcpdRH+98DO+3cw+f1zt2sL10yYic+63IHtEixj8
	/CYrwsn5EkCrao9mw7Cf44Sk17+6f8g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UND/20IWHQQOK2VjME7zD00IA+su2ob7hlDUmARCcgNUrSMJ8qyFGDX6M2vOnYGDOOifyS7rCKFUcCnjWKOb3HJ8HPSVN7IUN61D7mHbvoZSa4SQ79fwptLr/I6y3jCXgIuPQhPAAB80f97rStcCsvZb5/mV1/iyDvARjYdRMwuXj08z7w3+dAoA/TPXnH9PWT+yr5cf9S6f6qZRtHbSzJ6fZkNR3729sKio3mAlStyWX8QncJqXZWbbQth7AjX5Gqp5VwGxeZ47g5QsfUkwyPiMW+kMo1v7hUfFKVj9UL8CZX2HwMHLHPegld24Htba6i9BihvFS8EdPHj6xksJfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbQkE6NFgjfqh92LVizqb2MhlX2uQObyfM0nnGAQFVM=;
 b=l7oc70ptwMIY6UN2smfaYHFDz88GiwU0PLdv3GLrVfVRBkuV5TzynsMo3xObzpZkB5HJ7Ol7y36PxbGS41QVvDBSddbcJd19x/ukbbs5WX4sgTwMpvCjz3y3qrMe3OFEmULJG+k9/DJao1SnaBcbMuKlBE+g/l56uYcPEQIxWnGbSCchr+Ak9pO444b2YA2myPyBJ2F5mssSrlnBP8UId2J/ltNF0fr+EA//qH1+b7K8H5ui1l1q1/ydpRu4MZkwShZ/ri/XcXuQF0zMEgqIPLJ1gqLiBp2C0Ig/9vy6lMj/0bbgR5CpmkUdrR6YNYQ8iB9T8W6BicR4RqB5HGA2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbQkE6NFgjfqh92LVizqb2MhlX2uQObyfM0nnGAQFVM=;
 b=s+tXSzvYDHtudKroWSMB8+MpT6r3DdEmizT8uIL36rzqXGvTUW/0cluZ799DNIi1bsSugpM46zTCtaqGVpeaKPyHMeRjh8GVEnZODVi6pABdDZs0V+meA8enTxGUJSYiglsAayiNvJ0Ef7le1vD3HWS2inPiQuOHmFvuH5Kxm1CBkxPfDyUYTNYiyyAS4dtXvyPDNQaXVQ8uPoGUtDNhB80VC3FlaMQ8GR/8pkn6Zh+tkJv6NZI5T58pdn0iAjokLN5U04sNTz/0R+9ezsBq7WCvlbs4UAPqw7noD58kAA0N6WW2zIcc8dgqa4OoB0EWb/nj7w4FMWXZdU/r6UOjKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7583.namprd12.prod.outlook.com (2603:10b6:8:13f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.20; Tue, 7 Oct 2025 15:05:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:05:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org,
 Usama Arif <usamaarif642@gmail.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Date: Tue, 07 Oct 2025 11:05:13 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <5A9AC065-0CA2-49F8-9ABA-7238C20F1B06@nvidia.com>
In-Reply-To: <20251007005022.24413-1-richard.weiyang@gmail.com>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:408:fb::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7583:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f0a22a6-a76c-4d14-3511-08de05b2ec18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1lmVXh0L2NWQ1Z3Z0JyR21aQnd6UUN0MkhIMGhQRWtOTjRDWjFyZ3JMdFhu?=
 =?utf-8?B?Y0t6SXRwd2xmbGx1YWtRYjBHTHFKZ2RWZnRJa3ZDUm9PQ2JqVEhpUDBVTEJi?=
 =?utf-8?B?d1dzczdRZnhMSC9wSFdrOGMyN1BQUkpUd3hQTnhLY0NJOVBONUFTMFhBQ0Zv?=
 =?utf-8?B?RnVHbWs5dTIwUEo3Z0Y1QlB6eGZ6ekI5THd5SjY5Rjc5dE8zaTVVb3RVblgw?=
 =?utf-8?B?YUNuS2NUVnVUK0p3UHNvRTNmTmYrWXNxOHdnUW1xUXRlZHJPWlF5KzhuSC9J?=
 =?utf-8?B?NlBLYU9vRHZ5UDlUd3BjeVQ0VHk1ZjBBSFd2VCtxa0NDNVJEQnlZNmpZT1FQ?=
 =?utf-8?B?TVpGTHBiQVc3M2JyT0xQNVNocFU0T2p4TXVQTWk1OWFHalg3QitSc3lRb1Ni?=
 =?utf-8?B?bkJEQlgwQlZOeHZpS2kxTjlLUXN1RnNqS0NNL0dZS1VkdkwwRG5vdVoxWHpU?=
 =?utf-8?B?R3kyUEk3VkpyanhyU0hIU1g1YVZDL3hVM2VGR3FvOGlLazdkZlZpd0VMSTd2?=
 =?utf-8?B?U1E1bzBjLzRNUFFXSkxqVzRwbCtYSlBpdytmenN4SDg0dy93YS9WLyszNkx4?=
 =?utf-8?B?VWg3cGM1eHFFVmdOVENibUlCTjExYXlqcitUOUF4ZXhuS1QyTzVEY2dmNTE0?=
 =?utf-8?B?cDVka1lTSEViTml1QUswRUxqN0dBUStGTDM4Y3VwR29oNWhuRmxndnVjVnlr?=
 =?utf-8?B?dEtzZHVwUnBYbndUZ3RMdXVwbGZwKzQwbENidXJXYmVEa01qTmI2a2wyMTBN?=
 =?utf-8?B?alhoOWY0eHJQQkpja00wN1ZwdWVPZ3hCMkZ0cjRQVFZaRkhNR0cyWUNnNmFl?=
 =?utf-8?B?L0lxZm50Tk9OY1dkdVVPTXJBRlN3NExUalJZUkZEZTF5ejN2TTNFOSs3Q3JG?=
 =?utf-8?B?Vi8xeGJuWVowa2QrSTNpKzBZSTdHOVhWbFRVN0ZaZnBWeitoLzF4WGEyVUpk?=
 =?utf-8?B?OStFaFJ0MDVMSEhVNTUvVEx6bmR4NkxNK0w1WktUM3JuVnhWZlpLS1VlaXFI?=
 =?utf-8?B?OExiM3JZbFN3MDVaT1kvRjNwNnFoNTJMY0JNYkdsQWJNYncvU2NtL09hQlBy?=
 =?utf-8?B?b2hZVTFyeDZYcVpxaVhuWndDbTNaWlFsU3owN1JtZ2lRRG9IaUR0eVNnZ3Ji?=
 =?utf-8?B?V1d1cnFQUlFwMVNOMXF0dTU0ZlZhOU1ybDVFNFZVUGU5aStaYkVMc29QM2Vy?=
 =?utf-8?B?V1lCRjkwWFVaQWhMYVhEb2RNNytKQkRxM1hOb2FsdmlsY2hsZUhyRUN1bTBt?=
 =?utf-8?B?SWNpbFpyRkVFUjBCaHBraWF4UVdsdnV2Z2hua280THVOY0piTzhsUkY3L2RF?=
 =?utf-8?B?a2V3YytGUTh2TkhNdkhRM1JadmdPYWZVcW8xWjl4Z1J3RGlyeHdJeXNyMzNk?=
 =?utf-8?B?ZDByMEg1dUZQU1ZYUUlldHpqZnVXYXk5MGltVlNwR3owOW5ra28yZnlDR0hP?=
 =?utf-8?B?ZXRuR1NxVVNycGRsbmRtWWxqN2twSVg0UzZNK281VEpSK3ZRY09QWkhqQThh?=
 =?utf-8?B?aDVRZ0R0MnAvMTIrci9sZUpUTU1FbG9pcEZmTXZrQW9hczU4UmhIZHJqMnZr?=
 =?utf-8?B?aDF0MDdDcUtDWlk0SXZtNFI4aUhBS3BlNEM2cDlpa2lxWjFuOWJXYTV3N1Uz?=
 =?utf-8?B?KzBFVHlOZS9EekxHbC9YM2p1L1ZHak12UEtyRjAwdkd3N21IU0FXUjA2OTdN?=
 =?utf-8?B?K3c5VGFZNXp1a3dic093YVhVNGIvK0JNQlFXQ1o5dW1OZ0ZMNkpMWHRoNXJp?=
 =?utf-8?B?TDQ0VUJuYzYzK1RGTEZCaWhPTSt6b2ZPWGpvN3ZhcVdUcHJxSTQ4YkI2Vmdr?=
 =?utf-8?B?QnZaWm1hSVg5UXRpWTdSOEUvUng1ejlvdVVRTkNMOWs3amlQOXlHeHhqK3h4?=
 =?utf-8?B?NjlUSFdQTE45cjhMNzF4OVkwWitDbnlGNTVIcmFYS01XeVlEMGhzdys4U0s3?=
 =?utf-8?Q?QIUsc3OpLTeUPm9q4dMIvpWDNF0ZSf11?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ak53VGxNQi9BSFRtRDlKYk51cDFZVDlnMzJNRzVIYmdPdzZ1ZU1sOStiQlp6?=
 =?utf-8?B?anZSTFQ4a3k4Z0FFSE9hSVdab09vdGwzNitoRC9nTklwRU96SGxsSUpqb1NB?=
 =?utf-8?B?SHgydW9EVnp6c205M3N5ajFXL2xqNm9EN0tEOExEckxSTWpFOFE4dWRUbS9O?=
 =?utf-8?B?aDVkN2xjQ1k3SGxlTnZPUnp2aDg1RFl2VDVXbkVyNExKVTBYRlNFUWEwQVVo?=
 =?utf-8?B?SG44aVAzMEpLNE9hMlhhYUxhTWo5WStlKzhPeEtoRXpzOGhMeUdJdllnTVlS?=
 =?utf-8?B?L0h2eHliYlUxVi91UndHZTl0VkJWMVJUd1BaUyt1MFYzUVJTVHdqNTR0bzBn?=
 =?utf-8?B?ZGZCL29CejNjL0VwQlZSMk8xaHVJL20vRWxhc1llZ2h6TFVqUEV1WWlmYzd0?=
 =?utf-8?B?cXZza2tmMFdjQWdDdSthZzM5dUFhRzVTWjZzZm9DbXM5cSsvemdCaDd1UHd4?=
 =?utf-8?B?YTJza1B3WUo1Z0R5THVTdGFNbXJmQWxmOGg3Q2oyaUM4NlZaejlZN240cWJZ?=
 =?utf-8?B?dWdYbzMwTGh0MlVrVGRSbE80MW9MQTBJWE13OE41ckU4eVJJYWZjNm40SGJR?=
 =?utf-8?B?bUk4ZEpEaXR1UUFHTlpBQmwvbnExVU1qTnhJRVhReHVvUkJYVm9iT253aCtV?=
 =?utf-8?B?cXV0MnZidm1LREhtNGd6MnhDS1duWmtvZkVqQ1ZSdnZ1OGJ5K1VXR2ZvNnd2?=
 =?utf-8?B?SUZYYWRMblNRM3c3VHAwVm5ONjRxeFlzemsveE5hYmxDM3hLTGVueHBIczdz?=
 =?utf-8?B?a0FzazE4M3RGM0IvM2czcGVJL0dyc3RyZVlqYWEzandxUXMyc0JxVHNtUVli?=
 =?utf-8?B?bkxVMU45bGs2R1U0NEVTL1lFSjk1TWs4L3dNMG5hWnV6MGJBaERjbTJEeWh2?=
 =?utf-8?B?TTNyTER2bDVPR3U1WGFLenpvSVRpZnJTRHRVNGx2R3RudWI2eURHcTV5Z05n?=
 =?utf-8?B?U2pyK3BqaXUrUHZ0S2YwMjdoaUwzdUhNQU1hZUhMd29sMGNKcjZSWldlVnNy?=
 =?utf-8?B?S3hGQ0UzQ1lEYWU5dUkvVnlEM0pybWhjb09CdmRpaUE2djlwWTh4UzJsckox?=
 =?utf-8?B?emlWMlBxelJiNWxMMFNNTW1uUmZKVjBjbnZla0N1OWdINU5hQXhTemp4TUl0?=
 =?utf-8?B?ME9YR3U5UGI3THM0Y1BJRThDZDdnb2hHUk9RNlA5Tjg5WWxWYnFZYmlmU0JL?=
 =?utf-8?B?UmlQeUMzZDhNUGVJaGFJVkdYME9RZng3eWxFLzNJU052OTZja1FPRkJoMzRB?=
 =?utf-8?B?MDdSeVdpODVMS1g4TmhGS0M2RVg5ZXdnVUs1SGRpMHl1ak1IK2lobkRrQ1o1?=
 =?utf-8?B?ekRNTElqQkZvbGtvVk9wd1hJR2JsMStKRy9ZWkYzSzFQMXV5bUZSR3BjbW1J?=
 =?utf-8?B?L1Q0ZklXdG12YkRLbVBNVXpnM1RTRXErd2JZeTRTamExYjd4bjlOU0FvaU5S?=
 =?utf-8?B?UmxuWEozY1pPU1Ivcy9HR3RDWkRBbTJYZWJwT0Jka3U4d0hvVVNCL0NSdXNR?=
 =?utf-8?B?YWFMNVVITjg1SHpHbFZNT3dxZkFWang4UTlYTndqZFIzb3h6QWJ2NUg1R25l?=
 =?utf-8?B?UE1ndDRhUlI1VUN1d3FsWXZoUkZWYlJrRVI3RzloTnZGb24rSzFYRExnYnN2?=
 =?utf-8?B?VElVMmlFZGhqOXg3SWpDMjhTSFhXRm8rL3Rua1ZrOXNkd1VpRjdGbUsyUWFk?=
 =?utf-8?B?eDVkVCtsVmk0djFlU1h2cTNyb0pQY2d5TWtxSlZRWE8valdIbml2dzFGN2Ew?=
 =?utf-8?B?bDBsQW9JUFd5ZUwvZmVreHZoSXROQVE2Vm1hTHJJbXFoNGc0aEJoVWhFU3pW?=
 =?utf-8?B?VWswSnR5Q016SEcvR1JTdVVUU1NRdk0zTE1JWVhMK0JsbVk3UXc1MlJsMUFM?=
 =?utf-8?B?MnJseGtXQThaZ3ZiNHJCQ1NsZmt6MHBHVFZ0THlTR2JjaWgvY1hJRjc1L09k?=
 =?utf-8?B?RUFzVURlOGtQNEsva3QxN09MN1dnVnRjQWo5ZnA0MGpmUEZCcHlEcEZvejVu?=
 =?utf-8?B?bkxiSkNad0FrUXhXM3QrVENlRlhlYzREMENSL2dobUw0M3FzbmwweFNqN3Av?=
 =?utf-8?B?d3g5MjZVamRxdHRQZUxvWUhqc3pEVERGRHMyakkvYmxNT0lBeXJIMisranF5?=
 =?utf-8?Q?jZeZQqRe4IFGQ3j5rP7lj3yhN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0a22a6-a76c-4d14-3511-08de05b2ec18
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:05:15.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJlO1YUi9598HkXxxafvW0o+ZyBnpe+A6zNL7khttBpT0aTDWZM4HtmCJbgbwB1U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7583
X-Stat-Signature: ksyfizbf8genisik5w8h3m8d3d86ru9c
X-Rspamd-Queue-Id: 1E03F40019
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759849525-644655
X-HE-Meta: U2FsdGVkX194sMvs6wWc8orie83w8AuISaOiMs67dHMdNDT/wi2lr/zP7rB4M7DJlJXrjkqsnihJGsQ0m3nbN7qEMiKsz4rQfuPywkf0fvCEDNrFW/4gI/tbK+SIC38QKt7yiXvOzmhHXBfPeypKFe4+zuAjPqBWoLJGCbn0wKb0VWaVmxS8ITjAJ82l2oMMkTHXtXW5z6SOn/wkmQnsLKenCRYZp5lwbYXVCk5XUdi3o6TE6pIA7V9y1m6MId6dZ56ay/W4vKLaDMxf/2b3NMUUr2pUHDF6shxrGE+U3O3xdRbjuBBDzg7GUKCA+NSowdW2ycPHKRT8yuKMmmFc6YxQzuO3PMG5O+QZKcZnugYbphFA9hjp9I8w3ujYVTscYzeUeFS7xqJ6435wokD6ZhQ3RzKm54nYiYrbpGB8KO5h8OjK3+T113lgfSpeWTgtSS4PaIjSO1VTJuPt7ZMFHk5go/gfxRKOm6Ck3VMTQrcuWahrawOXfeZ5GOfCF48w4UVHfp5izGh0ub+38D6XZgRNuN3jv/m4ISjG50xm+Ca32Jx6oq/tMsXwGsSnttrByb4OMBJflleyYr+X6DUiVqy0y2jtljdvRNbwFqcMsNSELaoHSAu5x+Pd7XfPttSwnKY4x9yjtyMYS1zYI+26KmbznDXX5ejqyRUU7eKR6lLkU9X1IhR5cLt7jNS51exFEGzF5y40OrmUyYacJfBt+RewlBW4btUsJg69tY+vVijIfbnsVvFoxuaNS9HbfXw60nKwx95o3gMxe9GuNk6Ey9qv1lJEC5f+78ehiALLKn0khMF1jGOXN7hjdgFjKwVoHGnb54llCWeYYzixXElBmEgfjHLRHjLLSKGmcmZ5rKEIlOb7UW+gGoIsv6k3iRTwRAM+X04kqj3hPR4BsG1yR8LPOEmCKztGErIO92EKJVDvB3/ZTEPkT7FEjIqUNrOeMyOUkUNZzZw6eJSZ6U2
 pAA2ESQT
 Zrbfe1I9WcGggjsrk1bSsYNeC/rFnN0374OUg5veRv5l9P4XAAN5ni9hTT+1+sfGf2Z4nBgVvAlGhg8nOLeacxl+G6M8mTB7RZBo6I6Nz6QHqQGI4oH36Psumy1blCkqn4N7iih0l6q7S+nDLj4DqNUF+3yzUZIyz4/C9sL+kiUZ7IGDpqx7Llk+fb6ZioXIYy+fWqiW4vC3dfjoe9RURaIMYJE+ExHZTfow6Xg6Qt81W/hgRAT25ubP3G9P4vbCMx+rVz388diwiRnacN8ZCFknc0Z68WiiOrZ0XUjcyRarVpZJDrEuZGhUOEgnXziIO2KlDO9AJ2Pfh25p7uP7o1Teo3rcZc+a5yXjqjiT5CiiWthkuZ0eWNf/aOg3LcGWcE9I06RcWecNuqhaza3lL1CTLNcOboCrzSb6ktSqp9FIaEljvXPnt7NOB3aWWWIzDQ+3fulRRMet5t9YpRgC1+AaGa1kgI4hEO9e75U3NGX65qwaI8VhnTWXp5Sp4y8uLeyxF4dvG7OQgXGpr+p24BDGmF6NBfjJToY9bZr6kQ1RObY44MDTvdLlqcpwOFwskM2z1gXFUe2oYQDUY06Y83qPc1nJPVKKOU0jd37LoAax3zlN5sTCNvYYHeVVlUPKe+cUuNe3EApg9qvuExrvalRV8+bd5p3sXnPX0qqZ8Pf+NFoSGCjUx2FNAKX2TQBadlvsKBH82Meh6Cqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Oct 2025, at 20:50, Wei Yang wrote:

> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
>
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
>
> No functional change is intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
>
> ---
> v2:
>   * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
> ---
>  include/linux/huge_mm.h |  6 ++++++
>  mm/huge_memory.c        | 14 ++++++++++----
>  mm/khugepaged.c         |  9 +--------
>  3 files changed, 17 insertions(+), 12 deletions(-)

After addressing Lance’s and David’s comments, feel free to add:
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


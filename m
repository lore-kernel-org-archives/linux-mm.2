Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF0CC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD896B00CC; Tue,  4 Aug 2026 17:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A67C6B00CD; Tue,  4 Aug 2026 17:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87BD6B00CE; Tue,  4 Aug 2026 17:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0B66B00CC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:04:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D517160295
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:04:51 +0000 (UTC)
X-FDA: 85064816382.28.9F0B82E
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6404F180008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:04:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aEYcbBTT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785877488;
	b=DVuY3izWZiMbkv4LabGJgRwby81y5zGSA/B/38lNF1vhqxsqwd6m5u/ynq/zyWLyUfZhXu
	w/Q01CqE0Jc5tE9m2uosa012mr/zhkyxTWhuHM7dvbChPDuIH1Z22igDIu/yQrcGgsz40b
	yuNy/16fZFXS6BTcPvtUQG3FUS7KYsM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aEYcbBTT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785877488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4S+m23xlBKvBqpZsZ91mt2HRpKesyJrx0XFG6m6+Q0=;
	b=WC/MTc6NXKw2N203BQVYNaId7tjHfEPSZwHROpclQfzR1lKGh6TveaeiiCp2lwT/dOsUya
	QlXdj5uKxMbH/PkAqeUeBG5m3Mkz9aMM8KULzzPvg0uEZhpZKNTRiDw7fQhN63ZnrIkviA
	pJlCpdM/Uu++7dLsMu32KLYcNWfchVU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nvpe2i9+5yPXn9U6p9Zm1lljDDSz41Y/1kYdJdR/dwx88LMgcpKz94qBShGgh5TfSvli3ELB5WQ8cWOBbuoHa9gLpw+OAR1fDKY+KYTshRnrEXC5dZwsbJ2nfSnpYp5DiEhObmegQwRhxjEkk0aK07j2vKzHCdhzl0Mby66fGH5fbmSytq3euffe7FbS0ZwVvET1hcZVoVh8ItiP1eYQhfVVTi5HaIk0WVLDR2dDKAsbAjTJXJTE0xrGdb+HUh/Ubu3CssK5raBivu1o05NJHmB1b8b2J+QwyAGH8vgQCA6qAwWbfPpvQ+goq5ISJz++ts0Qdl9XvgzrnOskX3RJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4S+m23xlBKvBqpZsZ91mt2HRpKesyJrx0XFG6m6+Q0=;
 b=HSmHe9oaefi3/fhI4Q36IXz/naEnmRUCc8zLHxwHt6Mo8RieUgiecwomxfoSvL6GhMabD8RGPVYPHKV/1Y4bilTcWRp5OPZWkdcWy5EsiV1w2zlRjyqk0rjwMX5MioLqQxkS+aWHKv+/E6Kh4LZXxXEfKAjtrF28IDoLywNqZGEzCQfqrQMtKgtfHcmjz3X9mzuFfbircbd9MPZPiudxMrWEMrosc9eXTPueIceh+4TNdsHiy6VCQy5A7fzHmzOkaXSHh9ZpzU2Ma8OpoYPJA86m939wUf9bLgkan4nJswUwZ+EtrN6+YDPYx1YAFyEGpYgR/flTQicFlgX8Gt4D3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4S+m23xlBKvBqpZsZ91mt2HRpKesyJrx0XFG6m6+Q0=;
 b=aEYcbBTThNovO5IS3qamnIERsJqVpoNg+9iKsBruk4yn8Fyr60fmHnq58dJWCUNnd7nc3drNG0YPsCELEhmit1+4oovASu4g/Zy3x63mJilwe99X3ALoK5TYIzBG7MthAz8Q5s2jPv8iwIicL3wRn6HVYvokxEk4OJnuBohU4U2usbir8bnnRyMPjm38s8J8WFemcGvz1G99D8Zkr3ZoGaR+U/YzjuXJFIpPG81GdiYnmac8p9F3ZQ4jfuh4Py/l5sD6M/PsXwjh3xdIUCMWCIlWfUMhxHK0zNiECnKHgBaB2UaQuhf8uIDO+7Uqro7GulD1Rwcmmi6qy6q/NO8SxA==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.15; Tue, 4 Aug 2026 21:04:40 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 21:04:39 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Tue, 04 Aug 2026 17:04:28 -0400
Subject: [PATCH v3 2/2] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-add-gfp_account-to-xas_split_alloc-v3-2-38cb3ff325c5@nvidia.com>
References: <20260804-add-gfp_account-to-xas_split_alloc-v3-0-38cb3ff325c5@nvidia.com>
In-Reply-To: <20260804-add-gfp_account-to-xas_split_alloc-v3-0-38cb3ff325c5@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS1PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:8:44d::18) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: 78792e03-1aef-4d52-5aa4-08def26bff6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|56012099006|11063799006|18002099003|22082099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	L16MSbewyQDXw9fl3ANAfQLDrJjSdKITRJcz41EKmrU3AhTif31Nefetql+aJaYkjPAbAMJ/Zu8yC0NsEWTt2b9gLXmkY8cg7LqGFYKS8kln4KtlFxdZlZKkPEJ0aA12073XfDmGtXB8+l5MuRZmq/4hIFKZRFgg79EIA6l8QjLnjuS/vEMWNzeUmkGUnhaZuOgrhjV1UbZ3u1c7G3K/hQ6ozX34HaBaDCvqjIBwlzTI/htuH2uCPVBFIgd79LDHGHdDwdAP/LagLw0vok/TezjdGq0dzJpsoAV1Plo1qi8D74T0c7T/gVkEEHJXaSd59+vXmetAlbEKvWnJM5Ct4d29ud+ZTgcdQ6xW3YZ0yn9wLbqfxdSk+fqCZLuz3arA39XSy+kc7vKunI7bTIRn4irbThZEsrl/pzFvSvxhzIKZut9fq8NmgGb8MM6RP4d9eAOIumM1PBX9Hq+CG3YZWrvYZ2Ilcp7qGYeBTGUKk6fkRFwXjiyguCvYeLkIHI9OpQA8GTKWUuHpjR/4nj1RmO9B+5ozYrU8mBoZoHrCzXYpfRTnrWjlS0kC+yzhuf1RNCM/oYMzJc7d+G9q/qjwUgV4Caz6FDhSDz8OzEtH+8g4B5dbrUYrX6QbKpw4egK6UgPSCIv4x7XNsCzAoTj50uP6hQnnYwM0NVZUZ9i7l+O2+T6nLmPhIwVHqUN9RUnjuBBEH/oOMmwf2/9yd2q3eQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3pvdFJqYTk2aXNDZ3Fwc3g3ODRVSlFrL09ScDg3b25URkNlY0FxZld3NE44?=
 =?utf-8?B?ZWZJdUhMWU56RWpNNm91WGROSWwwRGhUNlhhRHF0OU9RSzBiOEk2UlNLSGhQ?=
 =?utf-8?B?TnJueXQ0SzNLZHNBNVh2RnRiR2JzMWtjNkRWc1BVQ2VqbkV3TFRtNlRGaFR4?=
 =?utf-8?B?QWJ1MjQwT2kvM2pIS3N0b1lRMnBkZTBqSW9YWXJEN29qN1JHNHRFOFkxd0Uw?=
 =?utf-8?B?ZXpOL0E5b1dDVjJYYmNVaDF3clI2UjRpMW12NXcwNExEVWNHUEJUaTRkODVB?=
 =?utf-8?B?YjhxZjRCMDJaSGN2L0hYM2poUHpIRlZ3djMwamhUV3VGOHBRSkxOUXRHNzNU?=
 =?utf-8?B?Y09wZlNYQnQ2V2N2TXBKc1RvUEhNWW1yeDdvWm9IWkJJbUYxNlMybENSQjhG?=
 =?utf-8?B?Zm9BaXJ3c0syWkIxcDlZcXpKL3BYUWxoS0p4MmJpaGx6OE1yaXNhOVhyb2l1?=
 =?utf-8?B?VEIzd2ptM3NlVHJRQmNxbUNuYTZjayt5bUNQVUFWb0M0cklxcm1qWjY1K0Vp?=
 =?utf-8?B?d3pxS2xrc0Y4Tm1HTGdrVzE1eHVaM2R1dTh0TG8zUWlPZUFCQjBMT2ZzTGJs?=
 =?utf-8?B?bU4wVlBKZmNNVk8zVmtxTG84L2lWa2FqMkhONEcyLzRNMElNZElKaXUyeVJh?=
 =?utf-8?B?TURYTnJuRTg4RWhyRno4c3F0cjgvOFB4dDVrWVd4SWQ1TmpXYWRJOTlucmZq?=
 =?utf-8?B?V0tYcHNpbXYwNjRzcUdqWDYxR09EdUZFZ1N6Ujlkd2dKNkNlSVBDcWRCMmM4?=
 =?utf-8?B?TnBxbVpSNnBXbjVCMHk5NnhBMzdXa1cyVm5jUmVwaW1YSjEzNnp2YU9hb3dv?=
 =?utf-8?B?TTZtVDY0cXltVytQUGRxcGc3YnZVcDBBZ25JVVJ3UStsdTUzSE9QUlV0RFVE?=
 =?utf-8?B?TUtHOVIwKzEvQjl5TExyL2Z0R2pSaHVLY2lUU2ZPSSs5RjNUYzR2ZDN1aXMw?=
 =?utf-8?B?R3RtTkc4cnpFL0s3cnlqVnptQUhxV0xaUUczNHJpOVdpSmpzWXhaK3ZMT3BV?=
 =?utf-8?B?dUdEZ0ZjUHZtaENjbExOeE8wWDhkMDNRQnhFbVp3UjVsM1JjMXNXSUNlWndJ?=
 =?utf-8?B?aTJuMmxkZzIvYitrOVFUbWhQcG9zV2NvWGJ4UWJQRTJmU25wbmJ4R3FIZy9o?=
 =?utf-8?B?MDNZSUpUNmxZUkIrR0VLZnZ2ZFVnUjdwUXRzTXRnNUJLb082NGJ2RHNIeDBJ?=
 =?utf-8?B?Qk1sWjVOc3lOaSt5eEgvWXYyR3JJQlFQL0R0aGNHMjFGL01IaFRKak03TzM0?=
 =?utf-8?B?bkJzbnRWN2N0WmR5RzZxRjBTUnhsQXYwOVdkSHFsdjBpOEYzNTJPVWJ2d3pE?=
 =?utf-8?B?aHJLcDlZaUhhd3pFTzlZUjQ5dDRSUG9JTjloNlNtZTdKdlNCckk3OHRQZzQ0?=
 =?utf-8?B?c3BRZWlHU2RxLzFsczhRZWFYN3VINDR4MDNJMTBQWWxURHRKK1cwQ2VuclFL?=
 =?utf-8?B?TjVSTUJiNzBkSW9hL0RETnlEUXJEdGttblFUcFRJWXo4YXppRXI4MmFPYnFD?=
 =?utf-8?B?NGJPVlpjSThOZzVRaUZTcHlnQkZsMWZnT0NzSXE3aytWbUVqaWx3Y3lsTUF2?=
 =?utf-8?B?ZTNJT1FXekg3VXFycVc3V3puVVRPRjR5MGFFRUNuOFFGNDRTRmJFM2VyVWR2?=
 =?utf-8?B?SVRnOXRMb3VDa25LbzJUSTIwRy9ZVEswTEYyMFhLRTYyN0tqSHU2cVhHdFBm?=
 =?utf-8?B?NXd0eFdVVDBrL0Q5NUVlVDdVMVoxQUI1RUt5R21FbGlNQTVwcW1TS2x3Y201?=
 =?utf-8?B?YUxPdWxOcFRrMlUwc2VCQkdTWGhyR202UFYrRm9vTFBqMWlpZHg4ek5wNWtU?=
 =?utf-8?B?L3ZPN3BvU0MyOFhRNy9mMW9kL0g1SmlqT0tKSnpqMFlkcTI2bm9jbVB0a1Rt?=
 =?utf-8?B?UzM3SElIb1dXdHRUci9pbmY5cUxCS09pclV0M3J1T040UGx4czViZGN1QkVW?=
 =?utf-8?B?NTJoNGVoRTd2Z0dxeHpYdG4rUm9VQmZlYjFBQmtmRHUrSWpKZmdKNEMvOUFM?=
 =?utf-8?B?T25iZ1haRU5QSTdEOER1ZnJZK3VZR0VnUWRNazhxUk1UYXhmYVRsdm1SbXRW?=
 =?utf-8?B?bE1GNnBEc0s4RTlIRGw1NlhzMFZQY2NxcFdkS2ZJNW8xNk1HQm5YTUp5c2Vl?=
 =?utf-8?B?elNRYVhzcWU2b3BiVlJ2YWphRVpYMnJRbDY1WTBqQStFWGlyWkxZMDBmdHBm?=
 =?utf-8?B?WXNCVmljV0J5Y0cyaloyeHVreVZLOHpJYWVTZ3B6dWdIaU91TDZYZkRjb3BB?=
 =?utf-8?B?SUh6a0JwMXg5Um9PdDFBUnZnWkR2dTNpdkI0R3lyU3ZMZ1dsL0hRSnQ1aEx0?=
 =?utf-8?Q?RBYReJHLhWlT2IklwY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78792e03-1aef-4d52-5aa4-08def26bff6a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 21:04:39.6925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kSOPH8loiAR/b9pXdmW7526DRZxJabwoAJWEOjya5EVHnOVljN9TtA1cVPWJHWAv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6404F180008
X-Stat-Signature: oxxpifmpt81nhu6qyuu5tr1xkrse9czy
X-Rspam-User: 
X-HE-Tag: 1785877488-545529
X-HE-Meta: U2FsdGVkX1+GtUrYqj/pjoxqysEEfMUCKrK5GHi7vX2Z83h92Xk1Pgs2opZlu8eb7Ow2MVfTBvVdR6ymYJYpqZKSuUQylK7oI335PVqUZOP8rQ7j9NAT59a4OC1HvPA7MjRUdjYcMKIu1FJRdpksUgJdrm0P7Td59pNXoTDM8d3wgZ/eIRhPbS+9tg/pCHmj5c4xHh2pipfDYFT8pIeUovNMutIW+sKFhtm6fC62QcMhsL/YrgeieMi03NfWV4HqyfVArYVMB+MINohHRwnbxcUUFADN/vILGiBoJkinih7CVMKuE7g2Q3HSmSdYQO59N4VwJcnkxGM+RRUezHAdmnhAfk5bgzZR0B7qnXs/YOzX60DJdUfU3dvatuC4YmfzPjwow7tgMiL5B5nq/mUQDWoNNhi1PdlFBSX59DHIR89RqPTdljg9WJ4TqPDRFAI8WCL0l9QK+lm4X1/RkEgmOJYZJVdFGaylRB1nKg4NLjTtvspJoIqaVjaIa48CEVUbmokhMn6hAEFPvmQ4LNDH8zoUK+ao2F9l/95+YXdlmRkh31s7Fx6E3M31InhgGNFjOenRRaFKipnTYWyC5wuJincygQcnLx9zL+R7jEOulLcFlBlQu9Gsx5yvO/vxktpwgM+6HYgRKJM1WrPUvOdALARyI/QQmqAzXM4YfOREpE2177Mhmb7QWgBNis4Q2VKQB+IwzRQSwOqvEVK+yCd1HmRIJD3wpjGphepSx4meftJVPTBccZqPouB5wemdLfDf3vE87t1EVXc+G0IlZJIJuL39O8H7bPUu7HKCBi0wJF7BKJjo028ZV2AtyRfSfM0voho2g856j6IUPyVACUrLnhcuz9HdeoVzkNX1SLOyFVkm8KzrESVuOoqT8gqLTONjv/PzX9ksRSAQ/e+NQiF76H6DOE5Ooh94Fx9v1T/0fW0n7DN2oEqvYChdljdR/3LhUqESL0cPc4DOXM5HiWl
 o6KMQZtx
 9NqQ2/gauYIrp2U4mywSvzo2eZxgAFBgpNVHzmIIsvfG4aqzhKnQ2qnrpm5m5sH0O3p4KJYP/NGkym8v8sDJyGTsBw6oFfLnGWewqd1KMYx5td7NR6cBHZujzaFoB/pWPVADmZCILA2SFudiuI5POAjw0y3F4JyRBagk3qx4DnKb42Qf6ThlwIRe7hnNc+7+F6afVyErkdOVxvLAi+X/x0nciDwXsV67Ct8cw7+9uMwJuZ1vq5VcH4AkL9Qg/InNNN5TWgpvoW7jQi9sGKFsGnKI7C0iPkBQqO7J/gmMtXoLZy47jdgqa13DIRLKSSqECm3WBeKqOM4QyNj5eg3hggA5Ea8PqyPgVP2EkD+a575WrXrME00ma6Ndvbxxc5zw9qHR58y5kvbyOK8y5vLh8TY+yhedV+vxpuSSc6oG+k6kTrgZFoEw8uIEr1heUD9QQYNTEZGPhNhPavoBEkJKLtICM6pqwQH7KGti3EZY1/iuBo3RWVP+hVSNYzjdHdoFkLJBJ3Ia5L6LMKjMl2FbfTYMwuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not add _GFP_ACCOUNT when XA_FLAGS_ACCOUNT is
present. Fix it.

Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org> # depends on mm-hotfixes-unstable patch: mm/huge_memory: initialise workingset state before folio split
---
 lib/xarray.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540cf..bfe7bef80f34e 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1053,6 +1053,9 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		struct xa_node *node;
 

-- 
2.53.0



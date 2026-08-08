Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FE7C5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 18:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2866B00D6; Sat,  8 Aug 2026 14:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979DA6B00D7; Sat,  8 Aug 2026 14:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A096B00D8; Sat,  8 Aug 2026 14:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4434C6B00D6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 14:58:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEE7A1A0440
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:52:48 +0000 (UTC)
X-FDA: 85078998816.20.EF74E88
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id C6DE51C000E
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:52:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IRbBKymW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786215166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfhOXQpIslRCUdxnsX4hedGvEo/SPT04GQG3p+Q2aFI=;
	b=OuDc7krF5ugoNjEGfvzB4WLs9yM2nqFwNNauAX/4GJ8Hs77Xxo2AMvrdaeizUqMviRbbC5
	i3pV+VwanPY/uqpUBR/BmUC95WQE/FofxSdwLPXIxBaqgs+io3PwUB7QuFGGvHvrRtm/qe
	CXhrM4rLgBaIYK0b9TqR7dchlHZ7sgU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IRbBKymW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786215166;
	b=I+EoxkfMvwwrHiQBTlnxHh+P0MPSL60r3niGVYkqqOEREEeoxcwYYtX0a/OPl5TA77CciW
	/jLE48LkP8CqhP6oGGYjEkMM/ylwrBHbTMbufXecgMSt8zknrZ9DpBy3baQ9l9sL4JduNH
	ZkgeLvOH3g+RWqvcRASIWIK0ChQKa8k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DmGtSEdim/xzT3Oy0wtP9z4DwVa5xEChFNmAoggu6pJjzHt0hQQoUBpkixUIThCAN91BZkhR6kzfrs4HiJ/yWdQwsRq50OxYvdkFsIASuKUWHaUNooFYiGjRPlGdpue/RcnImgjtPN2RPrCq2P5mCv6xIdSSMuvgMzI/T2ezEMmUwrh8DOa2g7TzAeItz82NGDA2jSg2a7LWE0VXrXozIA3Rk9aGQMBcX3SLBBSyrqn8JaFKxDg1DhY6FfjYOy3YDF9pAoeb46SNJga8wrEF6D8FUuEP7x/aBiPEALTgHAHJN1yMb9wzRoQiMYcVyg7mlp8TWDOXin1A71UHhwkl7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfhOXQpIslRCUdxnsX4hedGvEo/SPT04GQG3p+Q2aFI=;
 b=G1iBk6cPSMUUy3tbgLWMglCLakM0m3N91T9SlcDoxFNiWed9f7AWzBs7Zqo6R+mqa+8/v08J4q/RD68FZxk3br6b7V/Uh/TGy/8IolwUUFc9VUuThadjKuwaOdhBeYrNIoIGqJfid+6RGYuG3GVHqPhYKoMh4nmPGOH/00dpNyBa5HnSSX41MD+HkwEYuM/FSJGbpj4AIdxpxypUvEO75oVSHJsjJLfMc5ybMDlc3ColztHLdTzHnA4Tk13KqiN7VysfqNyRwgF79GR/KHezwO1YnewTeB0RPPc0OFGZF0SLkhEBDUvoOs0VbfBJRQ6Ne9t/4lQEs3IKCYOv81UIoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfhOXQpIslRCUdxnsX4hedGvEo/SPT04GQG3p+Q2aFI=;
 b=IRbBKymWFNtfZg/5iyfiAzTIUJpkHc4bIwnKQoOlSk3U+42d+WYqX/hWGyiG8xbgkmJwmjBx+gBKf+vZnuESFAUddIQUjuH3W4DLoMXBs2xpgsPnGJAceHa/50ga7hhffhGXwOLRlxUL9GbRmbnnjO6mIaqBYzGvWGpNyAMZQF6rqLKmIkXjWnXm6mRqxyMJ1IitjKMj1llX4foc8jULr20zFzkxPmbsuJThXHpDrqmdxc1h8cY3taRG0dJJ/6RlhAh5x9mP42yLeua6e28P2EupJiRp2RNSYq7E9y/ukojxCD9XsrdHY6/Xt3cW1CGSimyCTMzcwS8c5td/Yw2vHA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sat, 8 Aug
 2026 18:52:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 18:52:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 14:52:31 -0400
Message-Id: <DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 04/13] mm/huge_memory: split the routine for
 splitting anon and file folio
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-4-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-4-689939a7ccc3@tencent.com>
X-ClientProxiedBy: MN2PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:208:236::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: fb21f981-396f-4f81-53f7-08def57e346f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|6133799003|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Id1f8/qYwsIlUaz1ZjEOW27t2T6xREdCvVXCKWvcul7XEOh3E5H2ryH0mV6DFUHC7Ubx3y5RXthSnraYET6+cNAcPq1w0sxFrzy2l81ZBi1ZnZ6OrX0mI88zYkmJ75LVtQTzxLEMroy0gqyiOkSQNYe5xz/gEWc13Zp4F4HIA37z2kpFELvsz3BeBnqrNVy2jTTbDfTERyNaejX21UVeYxmCVWaE6uUQJ5YDD2BmJX2lFl314wfNeB+Rqy7T/GmbwVchGOkcMi1ZgM8Kbn6tJry+AyJNOo5Paj+tK8QeVtb5kz7hUex0XUV/1LwWR4CggQGA4sR37BJzzjOl4VVoAwdBjlu6ErfYGeBaDWpk5y9bf9riy578334jHwJTts1E2/y3t+A/tQ7LM0lbMreymzqASbecgrYVYouToPSqItM7o/WcTfQjLGxo+mQn5+HBED0hgVbXPMMInMzVMNtqhwMBJiKfFgiaWxyJ3QegpR3dnpQcVuxyJKu9/4cmMIqOfciPv2LRa5v2tKbYiCcdt/lI6q/Sfw6t+RfgUNJRLzXPi0bOc5e8y1Q2knDL7IyTHCN2hCtLHbwEsrGHdxj0IN8sn9Tw3J/rf+MPUmFK2V473fWauwirOz5oEl7zEPsFWKrGazIA2cTA26uowTq1PR6EKd7l8VcJO4/GLOPUWcM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZCtqVFZOaHZXOEVteHZ2RGNmb3ZPUCtra04waGd0SlFGWXh2U1RDaVlqc3dv?=
 =?utf-8?B?UGtuNlUzNkt6bFZBeDNkem91a3FhSTBIamQydXlyV1RwSDN3cDA1UzRmcUpN?=
 =?utf-8?B?RHI4aHRXcENXbUNuSWRhWXc4T3BxbHJlM1VXbGdCWkNVS0hpcjZwL3lNWkVu?=
 =?utf-8?B?NWI0WDloWHpzZ1pldlpKLzdwbzJMZlI4WU5zcVdiK05yY3dTSjFTNFlCNjgz?=
 =?utf-8?B?TVVYUUlnb0tCNnJzNWtOMDUrTTFrT2lOdHV6cnI0WEhKNWFWaVFGYUlkZ3Zi?=
 =?utf-8?B?dml2WUlua1FyWHU3VFMvTkJuQ3JYaG9HKzRTTzRRT2g2MXM3NHFqR3NjVW10?=
 =?utf-8?B?ZE1TaGVhbHFIdHAvSVl5QUZkbzJ2dk9mSVdkQzRKRW1lZGEvNmZoYndjTEhP?=
 =?utf-8?B?eUtSTEQ5WWx6RWZsQjhIWDkrUVRkSnBtZmlrV2g1YmFPTHI0V2pCU0VPSE9Q?=
 =?utf-8?B?NVg0bTZwNWgrNWRVT1RZdXBpditEWFhmRG1WSlJWRWhhc1VHVTdnRUlISEZW?=
 =?utf-8?B?SXJtQ0thNjdnenVHTklqVm5IQTQ5RzhzbG1xZXQxVGgyQkQwblA1MXFuMisy?=
 =?utf-8?B?UitGY2RxVmJabHdDM0o4V2tQZk9zTWdQeFpuMC95U1lLOHhCRDZjdXZHMS9E?=
 =?utf-8?B?UUVCMUNrVm41c1NMY2RqSWpFU3J5Y3FjKzZNSU5mclNDc1M2cHF2eEFQdENt?=
 =?utf-8?B?NnZ4M25YYmdrYUhCQlZ0QVVoOTUxRHAraDVSUDMzdnNjWlVrK09kOHY4Y0Q4?=
 =?utf-8?B?R0lUa1podzFnT2VPdzVBSDd6RmlNWHlkWDNKbXpvQWV5KzZUdmNJVzR5QlZw?=
 =?utf-8?B?S3lMQVVNeEdMcDZQTWFjYUFqSFd4S3NGbXFlQk1UR3hHSWU5VUozRHh6SWEy?=
 =?utf-8?B?eFhoMUg2KzdHY2pleVQzaHp3d25TSnRPNmUzR1MyRWtzQVJwTXFCU0M5VmVx?=
 =?utf-8?B?d1hiOUZYbHB6THgvU3dXdTYwUUR5WHJTZmc2ejJmQ3pHZ3JxWUlCcENpQ0lO?=
 =?utf-8?B?cjFlM0RRdXZhdUlsZXk4WnA3eXZLa3dVNVgxOTZ0a3p3ZXhwMHZBY0tpdVM5?=
 =?utf-8?B?cm05bHNiVmJVYkFSelE1TTZTN0toTEhUcjA5OU5wbWJoNDcyaG92blFSQk5X?=
 =?utf-8?B?OHZuU0xlTjhZMjF4TENCU1I3VFYwTnBMYjVNUFRqdkNBV0pRejFjV1oySXlm?=
 =?utf-8?B?YVhSM3RnV0ZkVTIzeEkvU0tOUHZZTDRqNndJTFdFaHRMRzcxbERpbzVWNHdr?=
 =?utf-8?B?Zm5tNmxna0JRUUJaWlgvb0srcFMyWEhUUCsvV1RZN0VpbzhFQ2plcGo2eHNU?=
 =?utf-8?B?RkRUd3ZnVXJYTkRNTDI2RUxhbWdyVitQU1lQaDJMYVR4VmZoS3ZoR0xQVFAz?=
 =?utf-8?B?em91aEJMdGMzcjB2b3VFcGdWM0lXZk9MNkFuNlROYjI2T09DaHpha1JPM2U5?=
 =?utf-8?B?YzBSY2tZZXBHa2s0MVBmNXNuLzBKSngrVWEwc1lwMlBLa29OK2t0ekgrY0po?=
 =?utf-8?B?YWV5VzJyeEl4UEJPaGcvTU9MU2gxbzk0N0FySmRDc3JXQ2NZV2dxS1N6Q2I3?=
 =?utf-8?B?UlZWR2V2VEZ1V1IzMDBmb0xBdnU2dFkwWC9ldWl5Vm1IQ0dabjYxQmNrb21i?=
 =?utf-8?B?SmRnT1FBK3Z4MFR5WVN2R09QYjZ2dGxkcVR5M0RyTzgvUWhmNWJ3ck1oSnRu?=
 =?utf-8?B?VkRjSGxuNGhUTGF1cVJIay9iSzFmeW5pdUEvS0dhRG1aclpwck1kcVVCTUVu?=
 =?utf-8?B?VUtIKzZobEt0dVR3dEpVWGttb1JEenlyTVl1T3N4aFBsRzNoWHZKUWdyTHdB?=
 =?utf-8?B?VFBqVGMvYXNva2dzZ25vMFFTTll0aHlOMUVxa3h2ZHNERjQrbmg1ZWdOd2Rs?=
 =?utf-8?B?VEwvRXVJbVUxNFZ2YzVQSS9PYVliTGw5d0llalZsSTlYZXFvZFN1b0hRKzhD?=
 =?utf-8?B?TVVXMDg0TytwK3N2MXJJaXAvWGtzaXJXZXFjSElHVnNqZHVFUlBSa281WUNu?=
 =?utf-8?B?Z0ZEd2pUenNVYWVpeUh5TWRJQXEwdml4Y1FnRVE5TkZ4K0pGcTRQeE9BaWs5?=
 =?utf-8?B?Q1BiU3d5bFNZWmIzc1d6SHJ0c3I1cWVEblFWYWRXNFQ4bVBTTktmWFE3ekxB?=
 =?utf-8?B?Z2txb0dSY0d3dWI2ZSt3bVVyT2U4eWp0WXdENE5YLzVLMisvTDk5WlVVN08x?=
 =?utf-8?B?Vmg5L2J4SlphZUtIeDhpTkozQnZmRVlSZVpzVGFnSGtKR3htcy9BUi9QaTdm?=
 =?utf-8?B?OXBFaDNvVm8yTVRYeEVWZ21EMUVabnVjMDNIS3VqUlRpdGxxTDIrSXZZUDAr?=
 =?utf-8?Q?7oOkZ0CDMqm3+BnPgk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb21f981-396f-4f81-53f7-08def57e346f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 18:52:32.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RquSYixgSVzYSSksvvqtG8ZQl1NOcTHU7sFOhm+OGLjIAtb4YI/ZeXKPqQwun0v+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ixmned43fzsbtmj4477zw68r1pmoo5ei
X-Rspamd-Queue-Id: C6DE51C000E
X-HE-Tag: 1786215165-124459
X-HE-Meta: U2FsdGVkX18nmkEmOGW/DPkxxCkhJUgeOHpw+zUlOhBC9Fvtu+owdnVFMSBX19Iu6NUE43kQd0DYQ68VwhKxk3oV4+G8acE3s/UnQdhDz6ym9c5ZkWmMwvHXhgCWEy5UGY+ChSiH3HtfTh4A9N0Q2uiWzfeOs+q46n4pXtRIpI7S+BthrsEzeMi3ACaugVfcP9MLTXRtaAtFHoq1uJrVOPzG5vs2M+Dbk/xSZghaP59nuQKToZdgeeRcAg+8HvZ7uHvOUABUX+cWcmI1qhmBWvypwkWtj8GqTTydH873kUTcV4Doi169k7VteAiu8wMB4For7cQCZ+oXH1DR3bMe/32WNtZx6v4L86Se4yBrIZhZOmuZnDgRvg/pIJ2F1ED5TQglszbMwi68E3Gd+ufQSX/a+rsIcSBp0C8lsGy9K0vfgJxcvsueqw28PaCAS7u6bALKzjZefLVmm4rXPkclhNwvtaW6LWAtN9CuxYczpBQQUxM/CBPoE5RZt9CIBbmXhyFcv5Dso0KO1lg39mWz4eiuw3fef707mrz+v7ErNKhO/4ZC386kpzESkD8U+O6AOHyR//FclhFF5CX9i9oDu+DQKAwEuzAzEmLkf3ChRA6oW7ZRK1xv22JXtMpN21B2Wk6oZH/N1FAIxTO016z7cpqDm94DHhkjCLmecdQSkgqPlqBLZ3d4gC5pI6qY5/KkZ8og6hQ7O1dNMEdmfLD2pg+Rv/ljXPHrCDv7wzdNhKjDR47aifXMuRLXDOLMDmb0oMQQYXHzs8GGY30B+wCKv1i+NTN7j6pz2xZWuNlpbHZqMxGZtoU+hJo4Anqomq9Hr3xIZzhdyTZuPCu9UytszTE2iXnCeKPsiwC/uu9WiPUQcDa/TT17LpQziAaIFMxEcCSyUwdRN8ZcxYFllJVSKSS/SoPy9aA0OSwFKPeeC2b1kxFv82jB30m6tRlkdSliS68BjpM2xf38zzj+ac9
 iZKW2+zZ
 /bf1d0GI4RuQvMkvgXJdx+ymwdXPtkM96RGqcrUtvrAXty617uYOIMkJzFqX5mfhNmNTtUbCADdRmKf/YjI5xROe+fNe6xYQTfrFBGU+9Ku/RdH6u/xDfZUTOM//bSImm5jEa8kM0wG+5r0ncuc1n0u9xcdqHnLMLlmPDCiQ9xvSVf5Y451NvcnrFU94AvCZLR35nHeu9J6fTMWElCKt6o3yz+lJev8EJndvbY5lq8pST9zEP07dZlXdVLk0oShNnJ3ouzoo9KhtPydKMu9qX14xXkRzeeCCzBY0LFmnqi9+sl4fDbP6Ec7ExavqAEasuTDhwH95tml0I+hDUdDBAoEdkpGieuwkKjHcV2hqeu5j6SwtHBAs9wiJ/8yAu4R1oM0vVCEAAmrloiNO1yMjHf6mCW3C0F0Unx5ve40xK61hxNMSwpQHD4DKxjNGYETwGd9oahqB0pfynzynRM7V/ZjhGDKnZDfOwsyMyZlrGbF/VKAbA20WkGZJp/MYP2NHd2z7bE2mCzFq1bWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> No functional change intended. Before adding more logic, split
> __folio_freeze_and_split_unmapped() into an anon and a file variant so
> each path can evolve independently. The two paths shared little beyond
> the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> differed in all other per-folio bookkeeping and routines.

While at it, can you rename __split_unmapped_folio() to
__split_frozen_folio() to reflect the actual folio state? It is causing
confusion and people tried to use __split_unmapped_folio() on non frozen
folios.

>
> While splitting, some cleanups become easy to apply, and helped dropping
> a few now redundant checks.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 121 ++++++++++++++++++++++++++++++++++---------------=
------
>  1 file changed, 76 insertions(+), 45 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index cf8f90b94e42..56a356c30f30 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3934,22 +3934,19 @@ static unsigned int folio_cache_ref_count(const s=
truct folio *folio)
>  	return folio_nr_pages(folio);
>  }
> =20
> -static int __folio_freeze_and_split_unmapped(struct folio *folio, unsign=
ed int new_order,
> -					     struct page *split_at, struct xa_state *xas,
> -					     struct address_space *mapping, bool do_lru,
> -					     struct list_head *list, enum split_type split_type,
> -					     pgoff_t end, int *nr_shmem_dropped)
> +static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsig=
ned int new_order,
> +					      struct page *split_at, bool do_lru,
> +					      struct list_head *list, enum split_type split_type)
>  {
>  	struct folio *end_folio =3D folio_next(folio);
>  	struct swap_cluster_info *ci =3D NULL;
> -	struct folio *new_folio, *next;
> +	struct folio *new_folio;
>  	int old_order =3D folio_order(folio);
>  	struct list_lru_one *lru;
>  	struct lruvec *lruvec;
>  	bool dequeue_deferred;
>  	int ret =3D 0;
> =20
> -	VM_WARN_ON_ONCE(!mapping && end);

We no longer need mapping here, the caller already makes sure mapping is
NULL. Great!

>  	/*
>  	 * If this folio can be on the deferred split queue, lock out
>  	 * the shrinker before freezing the ref. If the shrinker sees
> @@ -3957,7 +3954,7 @@ static int __folio_freeze_and_split_unmapped(struct=
 folio *folio, unsigned int n
>  	 * lock and must clean up the LRU state - the same dequeue we
>  	 * will do below as part of the split.
>  	 */
> -	dequeue_deferred =3D folio_test_anon(folio) && old_order > 1;
> +	dequeue_deferred =3D old_order > 1;
>  	if (dequeue_deferred) {
>  		struct mem_cgroup *memcg;
> =20
> @@ -3987,24 +3984,73 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  		rcu_read_unlock();
>  	}
> =20
> -	if (mapping) {
> +	if (folio_test_swapcache(folio))
> +		ci =3D swap_cluster_get_and_lock(folio);
> +
> +	if (do_lru)
> +		lruvec =3D folio_lruvec_lock(folio);
> +
> +	ret =3D __split_unmapped_folio(folio, new_order, split_at, NULL,
> +				     NULL, split_type);
> +
> +	/*
> +	 * Unfreeze the after-split folios and put them back to the right
> +	 * place, keeping the head @folio frozen until the end. While the
> +	 * folio is in the swap cache, the sub entries must be updated with
> +	 * their after-split folios before the head is unfrozen, so a
> +	 * concurrent swap_cache_get_folio() cannot return the head folio
> +	 * for a sub entry. Keeping the head frozen throughout also stops a
> +	 * parallel folio_try_get() from observing a partially split folio.
> +	 */
> +	for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
> +	     new_folio =3D folio_next(new_folio)) {

Please keep the existing for loop pattern by using next =3D
folio_next(new_folio) in the loop buddy.

Hugh pointed out an issue when I did the above for loop pattern[1].
Basically, folio_next() reads folio_nr_pages() and relies on a stable
new_folio input. In my old code, the input of folio_next() can be freed
and causing oops. In your code, that does not apply, but it can bite
people in the future the loop body changes and new_folio's lifetime ends
before the for loop finishes.

Maybe add a comment to explain why next =3D folio_next(new_folio) should
be used.

[1] https://lore.kernel.org/all/2fae27fe-6e2e-3587-4b68-072118d80cf8@google=
.com/

> +		zone_device_private_split_cb(folio, new_folio);
> +		folio_ref_unfreeze(new_folio,
> +				   folio_cache_ref_count(new_folio) + 1);
> +		if (do_lru)
> +			lru_add_split_folio(folio, new_folio, lruvec, list);
> +		if (ci)
> +			__swap_cache_replace_folio(ci, folio, new_folio);
> +	}
> +
> +	zone_device_private_split_cb(folio, NULL);
> +	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
> +
> +	if (do_lru)
> +		lruvec_unlock(lruvec);
> +	if (ci)
> +		swap_cluster_unlock(ci);
> +
> +	return ret;
> +}
> +
> +static int __folio_freeze_split_unmapped_file(struct folio *folio, unsig=
ned int new_order,
> +					      struct page *split_at, struct xa_state *xas,
> +					      struct address_space *mapping, bool do_lru,
> +					      struct list_head *list, enum split_type split_type,
> +					      pgoff_t end, int *nr_shmem_dropped)
> +{
> +	struct folio *end_folio =3D folio_next(folio);
> +	struct folio *new_folio, *next;
> +	struct lruvec *lruvec;
> +	int ret;
> +
> +	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
> +		return -EAGAIN;
> +
> +	if (folio_test_pmd_mappable(folio) &&
> +	    new_order < HPAGE_PMD_ORDER) {
>  		int nr =3D folio_nr_pages(folio);
> =20
> -		if (folio_test_pmd_mappable(folio) &&
> -		    new_order < HPAGE_PMD_ORDER) {
> -			if (folio_test_swapbacked(folio)) {
> -				lruvec_stat_mod_folio(folio,
> -						      NR_SHMEM_THPS, -nr);
> -			} else {
> -				lruvec_stat_mod_folio(folio,
> -						      NR_FILE_THPS, -nr);
> -			}
> +		if (folio_test_swapbacked(folio)) {
> +			lruvec_stat_mod_folio(folio,
> +					      NR_SHMEM_THPS, -nr);
> +		} else {
> +			lruvec_stat_mod_folio(folio,
> +					      NR_FILE_THPS, -nr);
>  		}
>  	}
> =20
> -	if (folio_test_swapcache(folio))
> -		ci =3D swap_cluster_get_and_lock(folio);
> -
>  	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>  	if (do_lru)
>  		lruvec =3D folio_lruvec_lock(folio);
> @@ -4014,7 +4060,7 @@ static int __folio_freeze_and_split_unmapped(struct=
 folio *folio, unsigned int n
> =20
>  	/*
>  	 * Unfreeze after-split folios and put them back to the right
> -	 * list. @folio should be kept frozon until page cache
> +	 * list. @folio should be kept frozen until page cache
>  	 * entries are updated with all the other after-split folios
>  	 * to prevent others seeing stale page cache entries.
>  	 * As a result, new_folio starts from the next folio of
> @@ -4026,27 +4072,12 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> =20
>  		next =3D folio_next(new_folio);
> =20
> -		zone_device_private_split_cb(folio, new_folio);
> -
>  		folio_ref_unfreeze(new_folio,
>  				   folio_cache_ref_count(new_folio) + 1);
> =20
>  		if (do_lru)
>  			lru_add_split_folio(folio, new_folio, lruvec, list);
> =20
> -		/*
> -		 * Anonymous folio with swap cache.
> -		 * NOTE: shmem in swap cache is not supported yet.
> -		 */
> -		if (ci) {
> -			__swap_cache_replace_folio(ci, folio, new_folio);
> -			continue;
> -		}
> -
> -		/* Anonymous folio without swap cache */
> -		if (!mapping)
> -			continue;
> -
>  		/* Add the new folio to the page cache. */
>  		if (new_folio->index < end) {
>  			__xa_store(&mapping->i_pages, new_folio->index,
> @@ -4065,7 +4096,6 @@ static int __folio_freeze_and_split_unmapped(struct=
 folio *folio, unsigned int n
>  		folio_put_refs(new_folio, nr_pages);
>  	}
> =20
> -	zone_device_private_split_cb(folio, NULL);
>  	/*
>  	 * Unfreeze @folio only after all page cache entries, which
>  	 * used to point to it, have been updated with new folios.
> @@ -4076,8 +4106,6 @@ static int __folio_freeze_and_split_unmapped(struct=
 folio *folio, unsigned int n
> =20
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
> -	if (ci)
> -		swap_cluster_unlock(ci);
> =20
>  	return ret;
>  }
> @@ -4231,10 +4259,14 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  			ret =3D -EAGAIN;
>  			goto fail;
>  		}
> +		ret =3D __folio_freeze_split_unmapped_file(folio, new_order, split_at,=
 &xas, mapping,
> +							 true, list, split_type, end,
> +							 &nr_shmem_dropped);
> +	} else {
> +		ret =3D __folio_freeze_split_unmapped_anon(folio, new_order, split_at,=
 true,
> +							 list, split_type);
>  	}
> =20
> -	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, split_at, &=
xas, mapping,
> -						true, list, split_type, end, &nr_shmem_dropped);
>  fail:
>  	if (mapping)
>  		xas_unlock(&xas);
> @@ -4334,9 +4366,8 @@ int folio_split_unmapped(struct folio *folio, unsig=
ned int new_order)
>  		return -EAGAIN;
> =20
>  	local_irq_disable();
> -	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &folio->pag=
e, NULL,
> -						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
> -						0, NULL);
> +	ret =3D __folio_freeze_split_unmapped_anon(folio, new_order, &folio->pa=
ge,
> +						 false, NULL, SPLIT_TYPE_UNIFORM);
>  	local_irq_enable();
>  	return ret;
>  }

There are some code duplications but overall looks good to me. The lru
lock, unfreeze loop, and the last unfreeze are replicated across two
functions. I cannot think of an easy alternative. A tiny improvement
might be instead of replicating unfreeze comments, changing one to point
to the other one and asking the code should be in sync.

--=20
Best Regards,
Yan, Zi



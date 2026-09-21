Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C05C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5246B00E2; Sun, 20 Sep 2026 22:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EAB6B00E3; Sun, 20 Sep 2026 22:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFB26B00E4; Sun, 20 Sep 2026 22:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D66E86B00E2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EACD1C2929
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:42 +0000 (UTC)
X-FDA: 85236186084.06.4E72C8C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E59A1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uKVASf74;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957719;
	b=fiMKpK0E8Gi/kDH4IF56+a7T0KuTHRxBLXWC/Uh1kRT8kIRY3+4+yAo+FCyy2+2PAWIxII
	q3wDK5djt0s8YPb9Uu7XrNrAiigUQEnlrihR+QPgZroirLTS3oD0t801LVI4GLoRnG8q6D
	dtPvRdPHag/G7qDirSTqdrmwvMKl/kY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uKVASf74;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b96eSbyk6ByBEFjiSyHVjmOBfJffseci+FgonfWLP2s=;
	b=1nDuktaBwhsvxMJzqEYPd9qmYTEpSkoT1piijhsw7WFoj7kMlfArSKhHz31eqs0rQxaZij
	IUY48hpbDQ/Np8X9lNvreqIw3c8a4QxI+zE43OZljg9WJqR11MhcBqgMijv66QkGaStobp
	80PLn3SeEjC3BdrQlutXjE5EQLsUdSs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9ZNWrK81UBI27U9JxVfYGEX8o6eqUW5AwJt9Muef1Ii03LUZMi7sgMFl3HAqlapEb7+409I08HM/SnW+FPTjmF6Seyy2O29tiNQEVdkASLyMpwWyVNYJ6Nvww7HkhyfJuJTxMTsWgtQACOIRLF7uB+BE9ZdpZipy1xKnQaUymiVVL8L14a+CFAYMI4BIwo3lc79jkMizC55Hi6wPJ5mJA23ReH0npyUJazBcYMinq4G9r1GivAbAn/0J1iaxhwaxqGQUb1lPHbkaFFCHNFD1QxW7uMPYLv1943EnuvgwfraF1eZxs9WrO+pNMjYli2h5Dt5rYAZxLF2YxoutHp0bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b96eSbyk6ByBEFjiSyHVjmOBfJffseci+FgonfWLP2s=;
 b=seSyEqzhCgQCrv4SKMe7qLB76ZXGZUBnHspSeCPEPBtm1zgj95VFOXxMvKPMZSfENCDg+WkruhGiKY2jVrYIvR2MRll9cU3Fs2xLEAckts/k2xJSP5JlXMUf9hxkVS52w4NQttahBwHdxALXno3039evldIJ6avXsa/yeVAn60E3SOIP5zAZPYBCvVRl/WUxQaRNs57xj6+9tkVmp8PG5F4YCbpvXOmUwokUGxpHi9gJPKQxtvc7ZF64IYDrMhJYuZ+YuLDz8TfjCha83RAx66wdqdUVcaQx3gpIyWPCG9HtKpxhgrdP6njkG4aX/XSqzDW+cyxY/mQmKWitBKt5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b96eSbyk6ByBEFjiSyHVjmOBfJffseci+FgonfWLP2s=;
 b=uKVASf745hdK1DNPBbT/FvDy1bWJ/BgpVIsT1EyPZdmfVUINyfZSFpe76vxjmKQCjjAEszLUHkoDBIzTD01/qxS/hsMfXLmtjUBGZcYPy6er8vGYNoC7PnTsQK2yzz3jax3mLpgsVDVOdSJ5628jKVpZ2lFW8Cc2BpC7N/J0znmSC2IWsl5S3QxgI30bgZmBNqGZuJ/ssb9f6QW7Cwsrrjcwgc21zKgFe54UTYdPDwhsjHHczfzXC3KwB/28j9si4EbaTalXtU6BLXKcd991JDsOF7h8Butwv48CnMKhNLoQ86vqmbTlJMRVAFZVFyjQcgdbn/D/QqT4iEDioF064w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:23 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:00 -0400
Subject: [PATCH v5 04/17] fscrypt: stop setting PG_private on bounce page
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-4-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 linux-fscrypt@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BL1PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 5048ef41-e55b-4897-98f7-08df1788029f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+furh7sVT2GXsurDE5DCMXnBmxhOWh0ZegVKOcfVuGv6LKB3IVqP7BBUaeWvQunmbixt5nV0Xl/nGZGmKrDh5MoRBjK+TACgNEbLzmWfLdR4mysPaQsVZtK3AQJeDhzm7KcshU9wgIYYUHWbWqSUnm29+iQYcodc1opjlxLeuxVRyD18/f8k5Fu0j5lbGqKVVCYGN++8I5OcPzZJiPNWjRC4csPm1j9XcH2yVCwlKcTFKNwnHoaDRvg0CfheZgvpkow/rc0nYO3mAP7PnNkJNZjgMShXjxb4hGb+VTuA3SIgRbEducdSfQswyGWk8X2T7J4REOYNKba3z3GBruJWG8f1Ug1dpb9O93Ni1ECE8foOQyBvrzPu+wbOHD1hVUj0jkjuYBFeRNPEaHQ6VzDmYvCIGg3o9MVNXh5zlFB2bG8XoFXb4YGse5ftEBFZ5sVmpJiERMHSsaeywScLZBwIfKvhL82xdpZ8mKQLrVJH/RZG4nnIZA4Y641KKp1iaSiG06ASsbva/INgjjTdoxf/+huK6boCWLXiOLBj0PmxujILQs398dDKUxxClZaWqqvyERZ5Bu+otOEGn1d3xbEj9nhIoMiTr2PBkHCWAcipU+Ky2QtbaYDq9zIA3/4ARJCywQ5594xCNNZu8goOOq5SbzpJhUX7tVVpRt4XkyYFowVSu1tUKaBHfWvekcXJdB31A5PZovgFteaMmcmHV6UjMQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEFYcVlkMHhEejZKOGt3YjJtK3JLb2VnckRreDhOa3pKTEMzY2Jjam10K0g4?=
 =?utf-8?B?ZUxpSE9ITGE3ZlY3RGk1TWVySkJoV0c5MzlBSVF0VmJFVU0xMXc0V3VyOHdr?=
 =?utf-8?B?bFdSeWxkMHNRR0ZUUXFNTDlScTNDYy94am11ajJMT2l2c1BUaWVzaHp1Sks4?=
 =?utf-8?B?WWJ4ZUZCQ0krZjdzOEZEVkJkVTZ4UHlCb1lXcU1nR1lRT0paK0dNQjZpcVF6?=
 =?utf-8?B?d0tFTzR6ZFdFd1RoeDZJSDUrajdhZitXSGhUTDFvQkpZdzI2MFhBWkdtZjJJ?=
 =?utf-8?B?L3RMZnF3SHB3WFJoM05DNmdIQXY2L1NOMnJvSytVWkFtK29oVkhlUnYwa0tL?=
 =?utf-8?B?QU9YTHlJZjB3N0p3akUzWGV0RjNCblZySnRMUjB1b2V6ejJrbURSbXZ3SUJ3?=
 =?utf-8?B?a3B2SnZJVEtRZDFwVEMrKzhEK1pLN0ZUMU51WmlQQjRiWk92cHRzaGdVNTZO?=
 =?utf-8?B?UWo2SmgzRDhwUVN6c29NallVcUZ1dC9GVDNuVnpiMXVYblZvSVdibk1KL2tH?=
 =?utf-8?B?YVVjRzNEdVdBc2JpajJYT0xPa2NYUEk1YWZiTEJZTSt3RFZvNXZZSHNXbnhx?=
 =?utf-8?B?OHlxdHVlc2FabHFSemNlWHVyOWxvSHJNbzg5UDdQZ3JVR1NpZDJTdG8wMGpE?=
 =?utf-8?B?ZERxeU5SbzhsbFlxdEhoZDVhcE5HY3QrK1dkMmxCOUJsZzY0algrbFNvN0hw?=
 =?utf-8?B?RXVJOHNsdVc1Slp3Zy9kR2hQNVJZd3FrcW1NWGg3TDkyb3lDMGxRaEhpS0g1?=
 =?utf-8?B?cDlseXpRemNaaUp0NUkxZ3Nza1F1Z2N1eWVZcVc3VFRBK1FMUGsvbUI1Yk4r?=
 =?utf-8?B?U3pCQ0ZIR01RQVZpL3NJR01iNFd1ZHo0MGFyU3VlZkJvNktwdmF4QmVHNkdo?=
 =?utf-8?B?L254OTY1RHhhN0NFaFJnZGk1Y25qR3U4azFYVVI2c01YNXJuRHpxdnV6OWN1?=
 =?utf-8?B?UE40ejQvaHd4enBzazMyNUE2c3ZKSnZiNmNYQmtEWGRVT01LYlV2bmo5UG1V?=
 =?utf-8?B?RmJoUDltamxTY2ZOSHNvaU9oNUhOaDB2ZGl5MG5DdnkySjg0cWVhbXdtSHNy?=
 =?utf-8?B?TnJtWTVmMTV4TEZkdldxY2E0TEFaU2tQMGdyQUdsaFZHcEdOZU96R1R3eGwy?=
 =?utf-8?B?bGJkYmU5U2lTNmVzeHBqeUcxNmFHclJjMDBrS2FSUlBxZkNvUDVxS1N0TGhm?=
 =?utf-8?B?ZWZyajBFMjRLazFqMFBFTk1nQkF6N21PUzJlVU5iSC9rNGc1cmNJcXR1Z1B2?=
 =?utf-8?B?cE53WUFFcjhCc2NFeC9ETTI5K1B3N2l6SnNBVjRCUktpdHNsbnYreFhEZW9n?=
 =?utf-8?B?NkZzVTcvUEVTSmthSmxhZE1WTnhVa0U2T0hKSGhuaFYvMFF5YXZJVjZDZUFY?=
 =?utf-8?B?UkxoUnNkdHF2RytRKzVlNmpQQXl1WGFJczFmVS9KbzYvK0x6VFc2ZlRHdDlQ?=
 =?utf-8?B?c2hFckdKQzByODBkQUxXOVZrOFArWjMwRlo4K3lHQzhIR2VINW5UTlRzVk5h?=
 =?utf-8?B?elp0TXpSWWtya2ZhcEMyaVVaUy9JcG1TR1ZoV3o5dkJGcHNVazNkYWZNV0s4?=
 =?utf-8?B?QzlTWmNwbGhNbEhvcGpCQ09yeDBIRXoySkNVTFlCUkxOV2d6VVlmdUQ5VUI4?=
 =?utf-8?B?aEFVQzFJTGE4UVE3dFl5aTBvMHJPc3RFVVZGd0JBS2l5Q3pkalN0d2pSbDdN?=
 =?utf-8?B?bGtDQWtrSHRHb3NMUEprRWxKRTJjYkorbS84OVcwaEVaelo4WHo4N2VqSUc5?=
 =?utf-8?B?UmpJcFhTc0hwdTBHZUxxbzMyNWNXaDFXcVZxSWJUVUZ0TFlrbi8vaFlMSUlo?=
 =?utf-8?B?VmF0UHJMZHh0UDhJYlIvaWlZVFlwMjVzQnFCVHpoQVJSOTFwQTAzaVNtRTBD?=
 =?utf-8?B?T3RyOUkrb3cwQzh1cXVteUJwOUVmdXZvbEJXbDBRZjJhZC9RT0ZncVNQUDAy?=
 =?utf-8?B?Z1k3b3hJaW5PL1Z3a2hvM3VQODdueFBGTWRBaEN6bHAzWXNHdU94WmFJU0F3?=
 =?utf-8?B?MlA5M0ovUlJZY0t6UHhlMHhkUFFXVU90YTBoT0dTU1QvZGZuUjZzVEdrZ0NZ?=
 =?utf-8?B?YWRGVEIvaHlpUDJkSC9yR1lvTHN1bjh1N0ord1lFcHVmdVJ2bHRXRDhlbWRz?=
 =?utf-8?B?L1YwUzZHTEdJS3QyczFFS1RPRzROcWR3amtrVFdWVlc5TjVqbkU2MVozTWh4?=
 =?utf-8?B?VS90WEUwTE5PQkF1UzhPcUdHb3pEQ2grRlVaT2Y4L2xjV0NYdDAzY0thWnQ1?=
 =?utf-8?B?OW00TTFadVQzOFRsZ2JNanh6OWwwamtWbFAwS05VbytVakNVZDF2dDNxTFlX?=
 =?utf-8?Q?BvHO/TX1/WDPuLDt6a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5048ef41-e55b-4897-98f7-08df1788029f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:23.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxfQCkDDjyr//nuSptKYoQhXpYeyunNpA2zqJoKn7Fh62sGC035lLsvKewNWCtsy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E59A1C0002
X-Rspam-User: 
X-Stat-Signature: ghrxuutm8f9fk9qjmtgte4txycsstfm6
X-HE-Tag: 1789957719-573305
X-HE-Meta: U2FsdGVkX18Xh9L14FGB5C1rcO/i+K9Z9Y0lR2Yk2ubL9exPFZjKawh4Kg5hwG5xX/KwweIcrab4Rn4krYtk83E+9CeBDhgqZw0sXBDEGmlsCARK+M6fGgcLIr47YFRCgOVtfOwMmN7Dp/lrE8GfosMEUaLZFxUr55w9QjJEtBCIOzCRPzEX9YODakVMks6xvHG+4DHyyIkm9auP0nBCw/0YXfrOnoJjwXRX5WuNR7itiCJw15itOipAoK9R1iTgsC+ZUcBshCGKkOhRSPkWWMVgqwY62hP8StO4joPCMhQNcb3bryprBDdjiCB6VqqFL30b+dH5gKWJsqy6SD9SnTdwgY1Jlzv52yJ6FXxPatY/0cSO7waILBWFKzLo4PcjKYa7ffroqnOmN9WP1frU/OsN8KtZz9MhUaDE60NpWFLuGAxp6Uyj2JZIyES64QE6DGL1OHRXXgOLEXyoErppF1g00T12KtQFCfFPDQlJvfuJZP9Hk77B0LSWxWVqcb+8wEr3C8phVLNm2yrGCcPfy7Oi2OwtttUY+YfWJrkfj2HI41116SFn+9GRqMD7H78VyXJf9dmvg5hmqLsOMPyIBPQd2M8MKBr+AWYpRGoyOFiPGnSFKh07jlxAqerelY4K01X84ZPW0fv8ZrlsWilGaV/gzCGBrnDXON6uI+RF1gO+UoCoftZRvwRPRdpZlSNuhT1VgUgXOokVqjN+ayYzjLTpfLAQOGUkiw/dog9XaVf40HBseWpHzq51nEyzVH1f4KzMy/23FRsQejvw6DYH/DMeouXRaQIlMLzJ4/7A/vosxBdWePwcPRRdoQyq02xIc2TLVF3D9pUgbvunJbSFJsfV1n25veL1QzARzNIPFyaznY+oz9dGImOCJBbFPLQVquNT+huPKsu3ry2RBSDJooPQ+NY9aejuROf9ethEzOINgggDEhj1lGTOeFDo51nDb/LI5u6PqpdJJ3+WTul
 j8S5DXvs
 i2wUAYwNK8B7XI6aVRLnuKFx9jY6JS6zkhTG3w0aV6lzDNwMwJ65N8kMlGMEFqz0UlVIfmOXUzzr9CgsAnKyC7NqfOAv0l/MFkA/F9raC7/5IQ6AityxxbtWXhgcp3LQ+sWLkKt3BCOAFt5NO/9KMroTQK/LXByjr3gjcKHOKRZoFHxLGHzaU46/zUQpjSSOBc2MDGhYTrCvEHwLqlqoowPx2Zlx4jvGK5v4pTjhJB8C5oTgYLty5NV5miln93tldhwh5TAGdxjAV5FrlKFvjFMN5FS3XMc7p+2ivsYpJsXCAMC13YftSI6iovWmprOumdMgDBGd8yayWawInd9JiBkVPWP2+SZN4Sw5EQh19n85C3kqrPaisR2WjtDUK7m4B/JCxKhKnMO27y9dFuDTn8lQbfbqLu5o+eHL94e8JJky+BjCuBn5evUJvmDIg+Ts/LfNAqQNTq9FnEjCT94rFjlMVMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pointer to a plain text folio is stored in bound_page->private and
cannot be NULL until the bounce_page is freed, making PG_private redundant.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Eric Biggers <ebiggers@kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/crypto/crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 5286a124b0d98..aced5c50a4601 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -65,7 +65,6 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 	if (!bounce_page)
 		return;
 	set_page_private(bounce_page, (unsigned long)NULL);
-	ClearPagePrivate(bounce_page);
 	mempool_free(bounce_page, fscrypt_bounce_page_pool);
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
@@ -210,7 +209,6 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 			return ERR_PTR(err);
 		}
 	}
-	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)folio);
 	return ciphertext_page;
 }

-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7AB6C624CF
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CA76B0088; Mon, 31 Aug 2026 11:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903E86B008A; Mon, 31 Aug 2026 11:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD276B0095; Mon, 31 Aug 2026 11:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF4F6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:00:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6688CC0186
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:00:25 +0000 (UTC)
X-FDA: 85161875610.06.79796E0
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77D00140018
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:00:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EuLvXSeE;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HHRqB03Fg0M+k1Kf7w/caIHvfPbP4LJSNsEpXawW4s=;
	b=F5LT+luEAmrPuV3YL0QaguNvgtuA8nn4nocSpNDaANdAv24nPvErepY3Hx/IjVDs1J+xYI
	o5941emAWBBDM4EBLhpXQGLK6dAEXa7um5DksI50cqzcZjCViyQFkwSTu+CbNQ8z8pH3Ks
	pQ25P7qiEBr5RMRsGkAAFhUluFtzqQQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788188422;
	b=cOTLHhiecIn7I+XlLps6uVlJbI17MFXj/bGx/DT4Ug5FE1zONGK1eySidHmaFEb7gv7mVN
	qMd+riCU+eBxvsUFP3s+qaT8puAMpxT4dlkr7lqzcrY+tRKA0IbKMfW3NgjEJlNNhVsWW7
	AWEIJ2kuV/6xW/1Rr/rU2v5PZq9hHPQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EuLvXSeE;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/HvUzdR1uRyWWx+/2bejk72DoalsQj82IjUq6ichvw46eS8Bb0/CkZgK7D4Kfz/cwyPBWHG4NoXV2ynddCvrz/XzfevCwVD/67hUcyraAVREwxvMjzhpCZ7nkduvpUEw7zUuyEbSavlaZmihxgDjPImWViAqpvkzS9nh4NjTdNxs6npslVYVaUqwtGq2Gka0vZ75OvVBeJWsq0QKq7oYqFZe0dj0xl5GOaIwRhcosKsMVvxotAnlKTBAXYn3Qz6EJlfWnVcIu/Dj8/TLiLnlaRQcTJWT7ioEkkVQhhf0pwhOXjSUOeoIpvEyl//5ESZOsndDcttk/v4n/OEoQMP1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HHRqB03Fg0M+k1Kf7w/caIHvfPbP4LJSNsEpXawW4s=;
 b=OX1gW8EME6Xd/cPeJosOoOYNNMYOOprNIs5ddnDkzINt80SdJriz2IpSt8NfOSHhxS51f3ajMrAi+Exe7EcqG4uRRdUedW0SZkoNJs+9uVA7FtkolkANPJn32ndUZ1r4HihaxCzamtclAcDuEoYJbhGdKaZ+3N/G/3kMpiMn9U/+n/g7h5t/KvxoYTKZzi4fp4J2u3gMhY+jDhFAEMvzskFbbRq/yFNd9Nn2J/o4aVj/7j0AAmNqD3OAP9ADjHjoKg/qgFHh2GZVsHSMyPvXm7nEOLdHvNEvMVZhZxfrd75WsupkF2e4lTFk3/zxAyIVeZ8pvCQKUeMLHb0LP85s0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HHRqB03Fg0M+k1Kf7w/caIHvfPbP4LJSNsEpXawW4s=;
 b=EuLvXSeE7fbdBLpcMknR8iQyPUPZqcbsGpxw+doxpZbv+T2CiIjom5CbFKfXiP9CLy8e5naUzANfsvfg/M9teYo/L7Sai8Z1FvCkcqOH1BarDzKXdLohowWNQhhpzumtiMBOzP495GPAjKdus1lcr4v3qOI8LWp6pUz18i/8JXjoLCtgZdSNuuICppJqp61qhfmBiShOmGGyFZoH/WJxxNQ3YYmSG8S0mPON8jePzNaN4CYYyDy1tXsnA6qNplHkePpYYVFe40J8yjOsfimReo35KWJY6TOrm3XvPK4/Yqp8CdKQKu6FopEU2UMIbKDF2zXIVB7BdSrrPNKpkbYDpw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS8PR12MB333896.namprd12.prod.outlook.com (2603:10b6:8:447::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 15:00:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 15:00:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Nimrod Oren <noren@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
Date: Mon, 31 Aug 2026 11:00:13 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <784BE9B6-F891-4DFE-A4C5-D1986CE0F242@nvidia.com>
In-Reply-To: <apVKf8FgTG-l2EU_@gremlin>
References: <20260831075635.2244437-1-noren@nvidia.com>
 <apVHXmSljK8HrIuA@tiehlicka> <apVKf8FgTG-l2EU_@gremlin>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:408:ec::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS8PR12MB333896:EE_
X-MS-Office365-Filtering-Correlation-Id: bab25141-e792-4231-7973-08df077090c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|4143699003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wec2zr9ppJobO+8l4ZsEoLamBJ1Se14n79YqpCULM0Nci4TqToTO83Nq8LpSW8D5JkQ+DmbpiLm1FKAucKGtbedK/CVi2v8fTieJwJifhh0xsi+ySqRxDL51JjmxAw7e30x2xUw4Inwb75JErZ7xPhztyGg6/TZT/RMY1HfQAiLl6weLiUpEV8bF5FIp87gtOiCHsYWLBGgN8rVr+Vt9mGEhPJas/hdevsojBtcgqcjVPphGnlnESOrVWggkQ88MzgjViIjPcAKqFvhNiBWlrcjM3Wz95iOuBdLhN4getZ2+JeIp+3sVQEw9z3akZ6JjaKmi7VLFSBEXqZHBsfaDTntYNPGBgnoS23G7m5kbENdbvHTRlswm3d567HKsmrram+dcf7GyAq8yEeIMm06eMPA4LV95Xl4xTqNzOeJX6epnkesSJpHArFOjjsATTMAM/DPBIR8JdRWp62kMRCMxWu2wcp5A9m7NYW7pz269gnlwvv80ZzWl5jXvZHwXlXzGgSoNmw9VR4UtKKVlbi3GvW4eZcRzpn03mN3WfSh45qVi2La+qpu64v+8qcH6osNuDN+wdm+5sDPsBrZTl8U30Nlzug6uEy7wg/oW+DN4dn8tqiLn4rRCqqhpybM351JnzJLgFX/58m8A+N32lSbaj8QP4iykV/J2s3NlDqn/UfU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DY9ZISJznPhGSJ8zBPGpIiSfkgHaV+EnwPpLbYm27VPN8IoPs02jWV+pftlT?=
 =?us-ascii?Q?4p3hhXPkivQBXsmyUSmUPGe6DYDOzPpY4AMaZAF4ykAh8Vmlb1gxjs2y6uoS?=
 =?us-ascii?Q?tx0atBgh1RP7YCfbMlr0qPHELK7VT9nQnYWIuHcwORk2be79XxaxwoQIyqYU?=
 =?us-ascii?Q?sR49bEOkQw0I/JzwU/4xM2he1KsCFMsnd/vA4iFQeWBStJ9QHCkwrdQf+f8B?=
 =?us-ascii?Q?91F3xmeU+uOWNNQSD5q3wcgXnpRo1Jx0sBOyh9yX3bjSKrWgnoBQvybMtdCS?=
 =?us-ascii?Q?am/7v1ej01h/GUC0X8Hrhl31TX1mEQMVZh9He4ENm0ZgAO3dH7cESiKrPegW?=
 =?us-ascii?Q?2cWRmC0RVmSEUn5vZATHeFpow7+YvJjKLm3jEsKU4JUwoGlWV7ODKHyK9Ppi?=
 =?us-ascii?Q?DBRoCGEnQNDoxlci7+bg3xw1HXyuCfwbsSWMfyFJylh/itJ73w76o/gysf9P?=
 =?us-ascii?Q?4oQprTy2UBb63t7PvY6CIf3DZLblWvtnblA7zAi2SnSYiovv/qd3gFbJXHL6?=
 =?us-ascii?Q?K2AVOfFDzatZem/NpuvihAkvyOg+SqcsP6KbhCk2KhgitkPaJfEE2lTQYcM8?=
 =?us-ascii?Q?OIPmZDoDEv9Lu28cEzLvizPosEc08RoWKHQChBhTa9gErFvFVnGkc5ZM3zqw?=
 =?us-ascii?Q?mY3H7+hUeczj0R1QHGh/doIAkWEskzCeuI9W8Lk/7qojsRKw0K5NwTtoeroU?=
 =?us-ascii?Q?KLPLUWXkhbaMnKMl4jFr+ncefImHnhrTxCSj2JyLSI8vcTfl82/1scpOcKp5?=
 =?us-ascii?Q?Qm+azpnK23AK66LRqPZ7qgN2e0rFiYvxdVJSlHA1+kqFqMGDJtYt00EmXbnj?=
 =?us-ascii?Q?Rkh2afiAgN9Cp0x5iUvNmv6RSKHdaXbr9nT3TThwkJec8z/lABICEx+GddWt?=
 =?us-ascii?Q?LL4wPd1flnJ95LD/AQP3SDv/FW+nk4ADTVvQzsWP+uX/c0GW2ViM3BndMGUx?=
 =?us-ascii?Q?60BbAPam42zzny3QbGKaQHHdivz71rYyQRLn2US/E7TMvhN7PqhubDt0YvN8?=
 =?us-ascii?Q?Wm96RFb6D8H2LYGE4WbT5vjkoORclaSG+ZVq5Kh1mwoKldlbDeNAG4mZJybm?=
 =?us-ascii?Q?/GXqGSai+lRD74yQ+ySobcJY3tkZsDnQH0v6/Q51PW2HFYlPNrg+5IhFJ2Y6?=
 =?us-ascii?Q?pNQ8x6dLMzJR+obUqa2C9aB+8KHiXIddJku1CxSdLZOmeP+3lAMJwt3fr3JA?=
 =?us-ascii?Q?6k5LD4nFU6lzZfvmHlQh3D/l2wJf6WM9F5Bwjj6mhII/dFBIhl53AnsYOF3h?=
 =?us-ascii?Q?yomRDBzGdclkLmg53UMSJySBW/DwbPvMIAw3vMEmwH7LtYkvANuDf9Hj5Lp4?=
 =?us-ascii?Q?D98RDlMk37SaBrx7Juu82QQnHrgjHsD7YREmsovezmR9dDDNQ6G1np3odt5z?=
 =?us-ascii?Q?R1ImXnlj+aRSvLeW6GlYWXsgMgMOUnmyEAQMBixIiAm9LshF5XCKcgke1vgy?=
 =?us-ascii?Q?5djzNRI9rBF0m926SOEm3yCIb+Iiu3msnwLGfP9dp8Vde9ce1/JPyG5K0V6X?=
 =?us-ascii?Q?FNedwK+WUd/CNQmeYXu+HwfL+e4lfnOjUKI33f9N2tBdNvu4gfl95KxBpemi?=
 =?us-ascii?Q?maqrThTx2TL2ySQmQPcv7TJ53HOahuNf36jQsnPcWaobU/vZo/D/a4IPNON8?=
 =?us-ascii?Q?1V7QbAttaTj24Nklgbkm7X4ekuVmaBBsBtzdVI6f07gy1lKsXVwkaSMxR90u?=
 =?us-ascii?Q?48ZSuhcnpBNu6FmjHQTEi3d0tAhtBElqCcamM48Ou7BoB+aC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab25141-e792-4231-7973-08df077090c1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 15:00:15.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhIU4C1HGr+1FrP+daVcJZ0HGiGeAw6QgA0woRhsZ5V/tpTOqXSfiBIi0hD58/QF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB333896
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77D00140018
X-Stat-Signature: efme6oh7asj88bnqmqaynj7wd1imdxnh
X-HE-Tag: 1788188422-601683
X-HE-Meta: U2FsdGVkX1+J6iF1d3rQs0H4VsLFO15f8yJH30VE2jkcwMuGoABrN8YWf6AQsFkr2pm/6B50ycacfHmIa1Ya05No6yZYlGD76MKxSpnHCuqNAzyffHZ9/zK8D5SKF2+iNtjuiJnPi3L6mrvR6zmGZDdHfZbHKu3U4Psq+F/kRukJ9mYiAsjFD5Vsba1KMLU01YuWLXmZNrydloHaWP0+ZluTa1wxuf9KQVZQX/gWfMnSvcc4sAdZLMe+nvHlULlpx0ciqVQsEmlVTk+4rIAqelBwtkD6Wa4wGo68lt83IXdBRoa/sAWmYouXB62uR9yfu0zttSse+5T1Ecn7phYksfMl+uI4+6/fOrPLw6S9s3/NIQuB32CWEeP/g0zIudTW2fqQzmnQ1sLUAUV6s4+YF0o6I1Gd97cidTFDXckYATS728tinr7UoqOdqbcz4SNuifo/4TxfOqEaYW+duo0KUXjIAVuJ3gdTqUGzimOCbR9LbFaVkxKg1nhQewP2zmRwDiCjq/K9tpfn1UNMxNVI5wUmM5jPsXPruRdGJ9f4CatAlaibo8jFRTDkebsEQXd10pbHqEx545yzRVK8lKw2uHoarU3/JGfqWR5soKeIj4Cpn2sT0aw0fUzGh/I4CXh5+x1IzquaYIVjs1JcXJHM7Pl6asf5ImzWLliiSBkr4s0Fpv9YdXX7rRoTgm/2Gutr3JOCwr1GxYLb9JmJc3V4kCXf4DIwR2zcli2nzrED4yEbaLjeJ/ypfPUlMjWKCjEu5q1FD5xVF0VlhJuHl7yLdXDjaMG+OaTQZK4SovdqZ9eABnmGE20NZZdGI1CDepbIei9GGlGcmz1ujoNDm3TRjH0Tofrh9V75i4k8LVrNMNqoYdd9O8FRlXLhQNu1cOil0aySFzkj82LSu7vDTyOkxE6A073WLR8dEnF2c+1NHQYhR7p8p4HLWcDsPcy4bk88Y6NVbMz6BLo0GW8xWiw
 /I82Wlry
 iXXxAMZ71rnAP8IMCSJtjJb7cONlHQceBZuANE+AiyDDq8mDhqmDIYm9exNw1BJli2OA0xlm4Nj0irIPB/eA212XSuJ44vSH3ySKknz+TCPkcJ8GMXxgMRp7FsWYBhB1wzlO0L+iasXr0wVUC61t+s2kyLnbgSiyKvpUZCzqC/6PZLI0C70Ylnpq0gwd6CPGV8LA3KDHg5WrqdWfcq4X/d3+qwcc23yPcBYjorRgDcijnc7PKl6JiJavVxrpF91Pj13g26MoW2aPJx00EYDuXnxipzD77hz5GXZ8aPkRfvIGIA7X/rD+PyS4gZGL6fkFRbdrDe9f33Ua87wnMB4/Gp8qYHzfVzQLY3IbJ+7Dk7O0MpMNPuu6L4uf6sqG3pju4oYFOBUTCGJC/+ElCjGTTotj+v0oyFnYU5GRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Aug 2026, at 5:34, Lorenzo Stoakes (ARM) wrote:

> On Mon, Aug 31, 2026 at 11:20:30AM +0200, Michal Hocko wrote:
>> On Mon 31-08-26 10:56:35, Nimrod Oren wrote:
>>> When THP is enabled, set_recommended_min_free_kbytes() may raise
>>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
>>> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
>>> pageblocks for every eligible populated zone before capping the result
>>> at 5% of low memory.
>>>
>>> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
>>> configurations, but scales poorly with larger base page sizes. With
>>> the default arm64 pageblock sizes, the contribution per eligible zone
>>> before the 5% cap is:
>>>
>>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>>>
>>> Consequently, min_free_kbytes can reach excessive and unwanted levels.
>>>
>>> Add an absolute 1 GiB cap to the recommendation, in addition to the
>>> existing percentage cap. This bounds the automatic recommendation to a
>>> sane value on systems with large pageblocks while preserving existing
>>> behavior for typical systems with 2 MiB pageblocks.
>>
>> I would argue that the whole model of increasing min_free_kbytes for THP
>> is wrong. This will trigger memory reclaim sooner and make the THP
>> availability more likely but this was at times where we didn't have
>> pro-active compaction and many changes in the compaction. So is this
>> actually needed in general resp. only large pageblocks systems?
>
> Ohh even better :)
>
> I did find it strange that we increased accordingly.
>
> I'm more than happy to see this just die altogether if people agree that's
> a sensible way forward...

It sounds reasonable to me.

My first reaction was that THP generation might be hurt due to fewer
free pages. But probably the extra min_free_kbytes just moves reclaim earlier,
like Michal said.

After removing this automatic min_free_kbytes bump, user can retain the old
behavior by setting a higher min_free_kbytes at boot time.

Best Regards,
Yan, Zi


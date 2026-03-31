Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE25FF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F84D6B0096; Tue, 31 Mar 2026 02:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF516B0098; Tue, 31 Mar 2026 02:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697D86B0099; Tue, 31 Mar 2026 02:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7E46B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:35:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F25431A0B66
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:10 +0000 (UTC)
X-FDA: 84605395980.30.E4EFDD7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D6AB4000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JtUO42ZE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.21 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774938908; a=rsa-sha256;
	cv=pass;
	b=eLt5sgEpu0sACLQ0opYlFOsRFjzf0flQlJ3ZqBqEmwkrSpD483i2tir3dwOHMJg0okBw52
	Ro2Vk1MwUiTOjeLy0UJTY6E/Wq7Q5SQkxEgNXeLm6wtt5j1Zo9On8/PTbMlxcLy7j13YBm
	7kxgMtE/SWU5bQnlplX0ySp54BFCb0Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774938908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5KA5xRrXhPLMq5ByEwUlaaWw9eH8cuqVwCshKHb+Pg=;
	b=WARgsMZEQFRCssAJfk8sAueNg+MUIS9ps19+X2SHePL1pzXW+I97OiVjcwWfraXL8JI7iM
	0ACItr5WeSUhm+ExPc/TGOLoabrLVYlk7ikJj3meykIn96AEfgWDPuktbWLp8ffXsSLJ/M
	wc7SGPTH42yZ9WQDebAdCK+vJu+yRJM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JtUO42ZE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.21 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwf+xvCUrEneMQqAjvRtGGqv4cwyNdZtMg0qIjriSdQyZQJBESzjX4V9BGmKnBgijN1fQCvE9pGfLDmN2uP1jgQ1A37OHoVp3PmNTR3m/Rz9KpnJhwLeOQIXD+hPR2tnzEQvZ76xzCABkpfLx+JXvcyBjJRdOsUQGbuj8Hb6arcWeHwFGN0L8mWrWxm8ZJxVnCc7q8Y5urmXKSdvD5GW1Pj97TA80JX7J8pJJmVZ0YmzIg8nXQ04EM8adf+mB+4kMfyyrxOB299lHc9RhvLl28Wa5RYltPLhyhctLJQq0xVLIVMiBNzkg3nEQe4656aVnMgjx2l6vNvOg4jXRf9bRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5KA5xRrXhPLMq5ByEwUlaaWw9eH8cuqVwCshKHb+Pg=;
 b=ueuv5/wyuSQ6N+VJGavDYSER4ewCfXTnVz11DQ6ZtjFDTeIP8WxBmeAfv4kVwL9tydz6+s2F7ZleQ6DXuB4Zv8p1tnLsI7cMOEn2ih3eJ/mUVXlu9/KE373BtxX+5oqSzAN7nFmMz0OUMw9NGMAgucfFrUfU2AdQDV/h9Xjis5MF4pjBFCs92yEc5L4ezpMd2IvjDUuaSid3SMARViL5KTQSWMFrCby/mASWLrpVNifARrh61DIuIbquKF3CSOZdAvjQZbvrKo/dj/JGNBwoNOWphpFHENjjLA+VE0Vet5WEVzdraK+hRizYP1lrX4TRIEidk0hWaSAht0w3Tjg9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5KA5xRrXhPLMq5ByEwUlaaWw9eH8cuqVwCshKHb+Pg=;
 b=JtUO42ZE6HCm8Z6/ssyoH+rwn0Rbo4WY911PBgS4J5r9EKNZMyqp2GGrK55e/sdKaM1wiOPO6/RUCgRJi9dObqOprEa+boaEO8WvZpRj7Fxtl0+PJ/cqzxbcCkDdaXe1cq21ftxNN/NmlRtn7RvPLYBpS0U0MN59nLM7GZllI4hwxFz4lui2UCB4W4Qc6tgtE3vzNjbbQgclCMeqUUROJJEZrNS2mbH5UCKzWcikmgtWgZlpHyGyw2zv6bhRz4PfJzs86cM1GtHyRZxxGmAsUAMlpO4O/r5gJ8PBZbjxyZ8wbHTmq5QxW/rzDod4YNBXPMGUzudzrgECgB5115qvcg==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 06:35:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 06:35:03 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org
Cc: zenghui.yu@linux.dev,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	dri-devel@lists.freedesktop.org,
	balbirs@nvidia.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 2/3] selftests/mm: hmm-tests: don't hardcode THP size to 2MB
Date: Tue, 31 Mar 2026 17:34:44 +1100
Message-ID: <20260331063445.3551404-3-apopple@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331063445.3551404-1-apopple@nvidia.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0153.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::13) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e22adf9-5d28-42b5-d837-08de8eefa421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rL/IsbFETqLIxWJ6UdW62yWUZ6CBZvsJQ8c1+sv/GxDdeXJ3Vs07HcmYIWsJTAakaA0IgzHNi3jL4KNxVCrb5Es+pGfONBTs861IwtN3uUrKibZgnO9xdfCnNjNKufTz/rvNRiPpZHzxc1pF1YrvSl33WBESu+Mm+CNtP9LpIeMz6AedlpEPhI6qYG/KwHMtHrl2CUDB+ebFVB4aBDty2+67ppVMWyED38I/qxnL9yBar3rCfBum0qnU54TC9/Uc2/yzkG116zo9hSbw3xRIJVbVK5eY6crUVatSlimSoFX7X0//UELAOHRwXWH8+RcnLxSxceE2ZhyOTa0dMjRdYlUHQzW+rrebtlATTiGCJNHbUBMEJ9vshAv8tWoKzhJQDeBAGT7WhUttxgcSi1/Xi5ih1N7WSz0P6Agu8ZmDnhWeC9AEdh6XcP6Pe1QRGID43mG6P3kUAAhmO7hBPf6AGQSOnfNksTb1y6Kohxafqxa/Tg/SyU8tNkshxVmZx5WCclBF03dqsJ1G+ch/Npegw1OkCzHprGowJYy6vo4qI84ilQfQVsvAN/hJmOLVwV7vA9UtYBMiJz/mgB0cOrtRYnZCclwBioUhHxA4VxzaTMZQyH1gK8bkznPbesKuyHoA/wAu5KNnQNsvdeoM7k7ar3PKek6MLwyk0Gs6QSbho0yh8YJy563WX2QH6ODfNLtHVBa2TUNKecfpLgqIxKUZeVkAeEvql28duaD3/Jbgkuk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yPTQlPFtGpSpMEBFU48Z90iYGzU9J0V5YKrhdcttaj4W/1BjZVJ/w9ClULEH?=
 =?us-ascii?Q?idDlxDYSLAryCpQQSg/ERfsiGbzeUtw4vbioJytsdVcjQP9H6N9Nqpbmg6Ah?=
 =?us-ascii?Q?j0Y+fq6IvSCMLtHQT0eCfB8lots4A2K0XMATJZ48hNez/oie238BKI5qBR2A?=
 =?us-ascii?Q?0qWphBtqLx9E1eppJo4SWDdnYTj42mzsXir2utkFOAi+DuqU3D3XSalOx95O?=
 =?us-ascii?Q?UMcJ6x86aJ0V+Pxr8cwnc4hpenEWmFK7emb7+0Lpw1TjfrvWQxC50Tpq7025?=
 =?us-ascii?Q?rOz/611ADLc8Nbd2R6/Il5Hxdw84OgMRXObxeXYTsCZx363WHjKScDMpn4ck?=
 =?us-ascii?Q?duzVdUwAq1C7l/OkPialldWbq+qy6mTvXRKL5DvAQmtDKZwyKJf5yl6acPvr?=
 =?us-ascii?Q?c6QiNWRv5Q7LVVnqhRlAaah94n8VxPrUbey8A19p9imygh+NnwM2ADlLrZAa?=
 =?us-ascii?Q?3Aof9/wdfQgTtZX81UVCfUtBIQhueNwggBybQCbydR4ybU6FBX5hI0oZraPa?=
 =?us-ascii?Q?C5ekqypxN7RxE1EvDAG3ck1WtILXIZ0lVQ7EEFgBa6A739R3Y1r3w4SKX1u4?=
 =?us-ascii?Q?lDsqD92dPjiEhTNL0ChbGO9izmcxz29YX0Vf81Tsityf2UEfmSmcxGFAnWPq?=
 =?us-ascii?Q?BaktpoLw+UXGw8mw4j7D5RyiMxphsR3KJQ6Z5SPEAVatsznHKO8WU7duRep7?=
 =?us-ascii?Q?WIHIBqEGSJmx/RAXcvbuVU6NdiKfkYkWd/u7XQFNZR/TiLV8HSsbUN2bAvxD?=
 =?us-ascii?Q?ZsTKZWokjizzpMBXBJyNWfRkJUrFFunR48uQGJPOloWXrPCz0g4kcLV+34R3?=
 =?us-ascii?Q?DSCbriqbvoxsnBFKmEncUHF/o0+1/SDly43SZWUMVjzUzo/Rk6ZwWFVvdipf?=
 =?us-ascii?Q?e4ha59QEZD55BVNAaa6yVzejnrIHBuQDKNRPw1aMlLVP6OxnPYVSp7fZUTdc?=
 =?us-ascii?Q?XD/l7QGNux0zZe/IRy8Y7uH3U2B3xNSaFghzbgPmIDwjlWpJs0LVZbNZyJAK?=
 =?us-ascii?Q?kMdoNKLpsk7Ex2QWkeBAOco6LX8oWBfnKbjJxgGer4lcZaNR+BGYLLhSjuQV?=
 =?us-ascii?Q?Hnf87PrFl3Nz64t69SR/xMu7Ggh+4GP2iE3Xg1NnXCXKb3D/4+OKd2W2339E?=
 =?us-ascii?Q?Fo4txE5wrEWvbxF7WXT47plHQCyseBn1gffqkmClFjcrmfRC+cpmO0aMu5nX?=
 =?us-ascii?Q?K3Vn0yuDA+DU2lO0QTGqNJ4OdJAjjUk3tRd/430DY4qPEPTnE8YcgSWQu0eR?=
 =?us-ascii?Q?bINSsj22Gq06ypRFCFhy63538oMbctCGuyJQBy7+Anf9r+eo/KwaYcQIc8TV?=
 =?us-ascii?Q?GZ2INYM/cg1sP1cN4RqYuK7q5ErEVqXYjIj/P1KWI1RglWBMWfib0+YZ6rfU?=
 =?us-ascii?Q?UQKvRqsGtROL6Tja4ckqZGthrOsI7isFaK5ZdEqFrIV5OhppCb/pq2X+Zblx?=
 =?us-ascii?Q?qC4U1vv+1/MuBio1kzRRaF1p8UOgn8jsxNOd11j4n6FRSQsqurDHIm1G3mhT?=
 =?us-ascii?Q?K/TjiSwHdSw2WpFWb/w8UgfjpQtvHRahYGrxIqNbRle5nwJqHYZURciJ5RUM?=
 =?us-ascii?Q?aHEub5v1BLDRBvEOvQsrTv8mRVIdyt2grqZu4tGIoNqTQ+XNMHwu/U2wOvfu?=
 =?us-ascii?Q?adysaP0lNcUeD1QpR4zJOYhpMcyQk+NpfcrzQ0q4FuZZGbu8ztBojdkI7U2Q?=
 =?us-ascii?Q?zqDi9rLjh5v3RjKmG2OBslstfLoA0WHkj8HorDT0qC5yJQ0AAkEcYkg/iulB?=
 =?us-ascii?Q?6ZJaC4xlNw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e22adf9-5d28-42b5-d837-08de8eefa421
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 06:35:03.6706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXP2+KjIo7ILoSryiYOR0y6XMUdHpCUY67OZD8O+Nq6C/CmiG4IoKM3qUH7Zi1U89J+jJ6qYo4VgsllyxpOK/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D6AB4000B
X-Stat-Signature: 9orcftg6axom9zy645mqs7zed7gorjgi
X-HE-Tag: 1774938908-248412
X-HE-Meta: U2FsdGVkX19MOf18iRisFFFgpBfnnxAk2Gf4w9/JTMzLU5UjJ/Z2j/zPbpgCC1+jiAwFNptawWpRpUX6lbZKF7/w/kL//4AT+0QivW1aA3yTtYYQVYzcRpuMMFRbOnSIKJqZ9RxKyNjXVNHiY+I7+tm3gVHYDAd9/u0xQj4J7p/bLNZFyGquIOpbp2Ry8aK38JWMVhldR0aX3+DgL4rkVGv3YImCAYJ+FILpnnFtLuu1F9gU75BCtTKrqa2n8ZFd8NXKpLv+ecvJibiiaB4UzK0Li1uV1GBIiHpN4YnWfd3Sk2uDR9+HVR2a/1Vb3d7cIJ/2/1wGKeQqFyT4qPZVL7nKiZWvV5cmveVa458Kc422IDdz1PphlQSTaRLihdo/LxwxzUxbA6ZUnqSVZ2YN4L6ZqcbGzAF2zQ3lt1O7C9/GwvtO0b6Mo7s61YEXgrk2AehbmpCfMPeGPlAuxpQGrcw3s/oxKRrRQsP/XAzmYjO6feS8WAQec5NICf1jrxVuOy8tmMXlcRUTvigMJREz8jfg5LNa8is627h1rIIg6vVdSFyYf2csiEG6d/YFjAq0wBr213K8ij7Jawnpf299ar8D72wwo1cEWXZ166X1sTJ+CaTT8/shRNCC8g/E3asvwigBywv1YwsK2ICldpt+RdSRwrt1KzRIac+2jWispB08Ol73DNvz9+cQowvdli4UYgMl6JjtIYs4VHSg1q5yfdlvPOOmOB25AsAejI7FLAKt/ZJKubGwIwsz0ngNaeyYWvBDo4JMGZHBPxkenwGzVxiiTD9xMtK79N/SO5QhqdGHa6Utv6s3/rlI2Ml0/uUDbPEqAT1SM9BZONNE1a0W6tpaH1UqwEPaIY6Oee7Eff5W4R97cPRDaAEd/MecMk4m+VTkRYR0wq20livTp3iRCpPjBf5c0JfMbPCVhT4Y4czvNzpRA/57Jd0NLC20vZOj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several HMM tests hardcode TWOMEG as the THP size. This is wrong on
architectures where the PMD size is not 2MB such as arm64 with 64K base
pages where THP is 512MB. Fix this by using read_pmd_pagesize() from
vm_util instead.

While here also replace the custom file_read_ulong() helper used to
parse the default hugetlbfs page size from /proc/meminfo with the
existing default_huge_page_size() from vm_util.

[1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/

Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
Fixes: 519071529d2a ("selftests/mm/hmm-tests: new tests for zone device THP migration")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 83 +++++---------------------
 1 file changed, 16 insertions(+), 67 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e8328c89d855..788689497e92 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -34,6 +34,7 @@
  */
 #include <lib/test_hmm_uapi.h>
 #include <mm/gup_test.h>
+#include <mm/vm_util.h>
 
 struct hmm_buffer {
 	void		*ptr;
@@ -548,7 +549,7 @@ TEST_F(hmm, anon_write_child)
 
 	for (migrate = 0; migrate < 2; ++migrate) {
 		for (use_thp = 0; use_thp < 2; ++use_thp) {
-			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
+			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
 				       self->page_size) >> self->page_shift;
 			ASSERT_NE(npages, 0);
 			size = npages << self->page_shift;
@@ -728,7 +729,7 @@ TEST_F(hmm, anon_write_huge)
 	int *ptr;
 	int ret;
 
-	size = 2 * TWOMEG;
+	size = 2 * read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -744,7 +745,7 @@ TEST_F(hmm, anon_write_huge)
 			   buffer->fd, 0);
 	ASSERT_NE(buffer->ptr, MAP_FAILED);
 
-	size = TWOMEG;
+	size /= 2;
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	ret = madvise(map, size, MADV_HUGEPAGE);
@@ -770,54 +771,6 @@ TEST_F(hmm, anon_write_huge)
 	hmm_buffer_free(buffer);
 }
 
-/*
- * Read numeric data from raw and tagged kernel status files.  Used to read
- * /proc and /sys data (without a tag) and from /proc/meminfo (with a tag).
- */
-static long file_read_ulong(char *file, const char *tag)
-{
-	int fd;
-	char buf[2048];
-	int len;
-	char *p, *q;
-	long val;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0) {
-		/* Error opening the file */
-		return -1;
-	}
-
-	len = read(fd, buf, sizeof(buf));
-	close(fd);
-	if (len < 0) {
-		/* Error in reading the file */
-		return -1;
-	}
-	if (len == sizeof(buf)) {
-		/* Error file is too large */
-		return -1;
-	}
-	buf[len] = '\0';
-
-	/* Search for a tag if provided */
-	if (tag) {
-		p = strstr(buf, tag);
-		if (!p)
-			return -1; /* looks like the line we want isn't there */
-		p += strlen(tag);
-	} else
-		p = buf;
-
-	val = strtol(p, &q, 0);
-	if (*q != ' ') {
-		/* Error parsing the file */
-		return -1;
-	}
-
-	return val;
-}
-
 /*
  * Write huge TLBFS page.
  */
@@ -826,15 +779,13 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long default_hsize;
+	unsigned long default_hsize = default_huge_page_size();
 	unsigned long i;
 	int *ptr;
 	int ret;
 
-	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (!default_hsize)
 		SKIP(return, "Huge page size could not be determined");
-	default_hsize = default_hsize*1024; /* KB to B */
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -1606,7 +1557,7 @@ TEST_F(hmm, compound)
 	struct hmm_buffer *buffer;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long default_hsize;
+	unsigned long default_hsize = default_huge_page_size();
 	int *ptr;
 	unsigned char *m;
 	int ret;
@@ -1614,10 +1565,8 @@ TEST_F(hmm, compound)
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
 
-	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
-	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
+	if (!default_hsize)
 		SKIP(return, "Huge page size could not be determined");
-	default_hsize = default_hsize*1024; /* KB to B */
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -2106,7 +2055,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2158,7 +2107,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
 	int ret;
 	int val;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2221,7 +2170,7 @@ TEST_F(hmm, migrate_anon_huge_free)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2280,7 +2229,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2332,7 +2281,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = TWOMEG;
+	unsigned long size = read_pmd_pagesize();
 	unsigned long i;
 	void *old_ptr;
 	void *map;
@@ -2398,7 +2347,7 @@ TEST_F(hmm, migrate_remap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = TWOMEG;
+	unsigned long size = read_pmd_pagesize();
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
 	void *map;
@@ -2498,7 +2447,7 @@ TEST_F(hmm, migrate_anon_huge_err)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
@@ -2593,7 +2542,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	int *ptr;
 	int ret;
 
-	size = TWOMEG;
+	size = read_pmd_pagesize();
 
 	buffer = malloc(sizeof(*buffer));
 	ASSERT_NE(buffer, NULL);
-- 
2.53.0



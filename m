Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6978F36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 03:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3ED6B0005; Thu,  9 Apr 2026 23:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BCA6B008C; Thu,  9 Apr 2026 23:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A796B0092; Thu,  9 Apr 2026 23:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E91A26B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:25:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8C67140313
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:25:17 +0000 (UTC)
X-FDA: 84641205474.05.DAE708C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013044.outbound.protection.outlook.com [40.93.196.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E4AF1C0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:25:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N2eBtbQc;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.44 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775791514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eG4BPIT3Iq3yNkbWj35bBFQlENiBQkEWmiN3/iiLSdA=;
	b=Lu2AMPaIaJVaKuqEG6alTCOpgficml1BEEuuXTDJcW5mKQnOYZXseQWOFFWqkIKoZh1/YN
	4VmcG1ZRjQy0YYdv7kTr5eifvtKmcFBBu3fP0morrpx4RZb9WqBWun/5i1Fq8HDrw96c9l
	0RvzPHkKrQZ13YEBi5D7Z3HeF0y+SC0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N2eBtbQc;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.44 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775791514; a=rsa-sha256;
	cv=pass;
	b=lyMiDVnayuFpmyk+nWIvas32Aa4pvWv2hBusOEfwO/XclBIzQ+IKj0Mu6VbLlNnj+NmwkR
	9vi1GWsUfRhBjnwhs2IWBq6o1GPXcrwDeXq22cgNRldylyp87C8ka2MN0UlkHc5ROMJxVB
	tpUQH0hUNkYaGefx8yYs2l+n6bj2Nkg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLLZGrkqpboDqWigmIBtQaDeg6AhiM+dV0URSpGZsUpMKVlfY04vOppnz5B7MR3+wjHC3D8GnYRWHOVBTb4txSKLD1sswiHIwujngDCLuFmTj2Qcz+J0QxdcDWlQF/SpbLR1EHosPuNmqdYB4nCoh0D0Y9koYmM8X7UbEzt1rcBwQw1qZaQ0oqVYceouvqGYyMs799frMJjBKdsbAluc/t7xFEjWEoLm3xx/QAKwI7YREgR29kYcmItEPcnhNMT/TybBj9xshATykZoSfVEJzK50Vdp23hQoFXIRqRO+hnFeoCjvZp67lCUgmrp94sbeAQUnisNqNN5ltrt9Ns29PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eG4BPIT3Iq3yNkbWj35bBFQlENiBQkEWmiN3/iiLSdA=;
 b=tPTYGwBB+tWj5Eo1xmAgGRx2Wu9BOl2QR7KPwK9lxZ9A11Thuvl0gX1VabxdETHDdybxzxeX+mJ7vhFuCAvg8mecIxYnmXm7je6PqlLkRqLr5kJSecYWcHOf+MVZ1jnVdW4WUgP1R/6bjRuOBVH+kCTQIj/JVKbljIEQo2mkfYSoF3i/cgdVIOdlEbfWpQB/mg3mRdrjTMOe32kZn7kSgIuvnnA1PCEhnFB+D6cYSFAxAIwG34g0WpQTtuxEy0ZHWazgPJ2K+1DLPcfR++fKZQaV2rTKJ+jCdQRZXNhugHsI/IEzqSxrErPo+y/GYO5wvTsohVCbj0Z8OtS7nxz1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eG4BPIT3Iq3yNkbWj35bBFQlENiBQkEWmiN3/iiLSdA=;
 b=N2eBtbQcqFDjLaWumAlryAXNZ2ZPMhGVwmv37PQNRH9U+KuiGUUx7EuQD52/irBrAzvTQ9bE+4zXcKt3HKkR/TRelt1wkW6I9MULFLLfLT4Wd0857lFGYDYtpLVaI+/dPDX0JFpdINnfF96pA2XyU1EA6RvudIaZasIagtTE8doULrfdVDdttR/PhwI5vHcXyP0yLuDpn2ev4cYr4A9sclAYKXTig5qOOMgldPJlsw465C5biBfMLwWwRJRbRPNUeqtAuYLVfcfTaRNcDYeEHQlwR/7ISB/Po8noPlUB0JRN7aUsePrspAkVvpQegHtgB57L6LKvUScGAS7YisWfIw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN6PR12MB8472.namprd12.prod.outlook.com (2603:10b6:208:46c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Fri, 10 Apr
 2026 03:23:38 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Fri, 10 Apr 2026
 03:23:38 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>
Subject: [RFC PATCH 2/2] mm/migrate: wait for folio refcount during longterm pin migration
Date: Thu,  9 Apr 2026 20:23:33 -0700
Message-ID: <20260410032333.400406-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410032333.400406-1-jhubbard@nvidia.com>
References: <20260410032333.400406-1-jhubbard@nvidia.com>
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::35) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN6PR12MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a36020-959c-4860-5d2c-08de96b08e49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hVJxPm3NIRELMuD5P9gwBAGUBt6fUUtfXJODxv8lqUmHRjoy4HUt9MDR3ksXtLyYlCAfBdQMQXtm6ApRMIsF55RiubCKZlnc6s/tCwmuL3IYNYWb9LzQrYMA4oaacwOyPGVbKmYW1g/LBg4UcVrTmRDwhB2RlORLga6Iajiy91wgmguQ5mXke3+FBS2vNoMCz7Ep7wYQSu27Cscg7fLxydgueJRTc96Bpsp2S1BPT3XgZIo2DragI7PtIzzja1XK/el0grkwpHXi1fNoHQV6m3wKqICHgUcebc6QETAF39T5jf2j0ebQO9pKOPRTvHsG0tXjhtDiz7OZyYu772GWLBwuK4+0MTEjDaRuluVweJy2OG0hSXJA/qHOLoQPwN5NvqYGLlo66Ev6WPZ2/uC6WBUWXwPDlOVkvLi543uMmvbu/b1SLAUkFAnZhU9F8YMhSTyhiigOcH65QpRGHs/1kxTXJBD+951yCqMcw/odR4wqDIk/R1PifIjj/EQo47VJIjiHzTbdHINDkUq3+Pp0UNKUnC3qqCLscCNlIXvOywvfvlAj3tWUwkfnyLJAlcYt8JT/eG7oimYfd1x87zOWyh3WCjRwuL8FDh4rt7w0N8+FB4L6lJOa5+FU5LkjxTzOFsd5z1I6leu56XfMwoIL2esM2fNhzIYVAW032X3MV70QUhXtJkWvoCrAizJL2IvXF9HKBN8H+PngFuyAYjEkOUUiQNe91LJ3T1q0pxpsp5M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sYOUECQvK3Cfz+3cdSnPUVdhyEg/R5cQ589SnbRTKOqUX5dy1DQHbnANeBH2?=
 =?us-ascii?Q?48DvsNV2ooZoY7nQjbmeojh0NZMSoQzyUUJnmFtWKgQNLrr/Ld5XK85krtVp?=
 =?us-ascii?Q?SCMM82mwrAe3xs5QZq1giumB9VqiastarKadIL7FM2frT9V3IjTzS7smxBDY?=
 =?us-ascii?Q?LwMsrBGY0o3q7TDYXoY/XBZ9khHS+smR73YBq8FNWWuES/VcmBrUa+KblIZs?=
 =?us-ascii?Q?WYcnblhS+DDrLp1pDKt2XeJ3eDvPikDcBulIxx6fe6sj2TNTVLh3v0kxjFxk?=
 =?us-ascii?Q?0NS73wUbcs7ODBBsKhwtTuMm5CA0DRaNdAUQnKy0fTJ1w8JGt5hns8YlgSSc?=
 =?us-ascii?Q?eDb8lqC4QgXeas1TSNllVLlSGQ7Qx84P3vKhymlpYykGWbg2+I5xC9P7ucnB?=
 =?us-ascii?Q?D7r8l9mHQG+LDcQ7WF4da/lt5agMTp+rtSKh/kTMM8uUURP6pp9+qipI0j11?=
 =?us-ascii?Q?PcHoFrBgV9sNCAXg6U1TEE627b75Mn2mnJDwQ5yCs9yfIr3ZeYbpj14d8cIG?=
 =?us-ascii?Q?xOS9KHFAhMgUAnEV2ZzdqJB/gc5a5PQzWS7Ig89sOx5hQvKSDruJpp6VJh82?=
 =?us-ascii?Q?OLgFxQ5u6mQq1auspkLWZJe5R75fM5OKXUfv1vDa2BUgNL2L/hdORw6T8JQg?=
 =?us-ascii?Q?0PacoXTs347cJGmgr6CUx0l1FzzdsHYvwpeYgWDzUqeMt1MqiyL4ypidzruC?=
 =?us-ascii?Q?KL2mH5f0Sow2pq1hH3WVMuQTJve5WruFL3cgf8zEQvSUvgWSbagnOY2drV1s?=
 =?us-ascii?Q?kd432FK6tfCqURXpOoITIqswGi6hG54xf96xOj+eHfcxSj6Lhf+YZXJ9qChW?=
 =?us-ascii?Q?ZLkDDem4QeznBSDQI2o/7qq1ijmQahNK40Mhds/nKffv0G34WJ+PN5zfqCwX?=
 =?us-ascii?Q?s9UeQIrfdMgxMWvXr+oFB0quuYOs3O30KgjIWZZjBAe15BDU1FekI4woujyj?=
 =?us-ascii?Q?ddSJ+SFHrNK1PHzHIuhUDjfcyjFAVrq5IoDeurKKXOGvQFQXB/zHdY/hzsEr?=
 =?us-ascii?Q?CRReFQCL8cdITZUjUSds/fxVTOgtlb/jRtSdyf3P+n48jwTw3cQrvt1vzb7g?=
 =?us-ascii?Q?769Ir7XTPLrraKjn41ri0iSj3IfepkR1A4l34kUVPVeQgSAi3PrIq7FX0hOT?=
 =?us-ascii?Q?9VmFlDOZjkdajAvJ0q3KXbJUeWI0NWHPqZeLT9C0eREpUvj4pEEh3TOXk89P?=
 =?us-ascii?Q?/uOY9TvpJQ5+xuBd1k48PCUuSoqI+wJlngzuczMP2Ied8dON60N+qOgI9GC5?=
 =?us-ascii?Q?wEkTzmjp4Og48GvikpDvz2llWSzJI70XLt+OJw+s+pNo6FeNzYdwxoz5Y1zd?=
 =?us-ascii?Q?U7fCL2pUPK2VWkiuzOWUtKLtuikWHhElkGTForwJoLdc3+VZ1QZ1HgXcSsMZ?=
 =?us-ascii?Q?jCPSktVM8r9AuPLT8yEiapoJIvIBsmTgkta0iLofUcCUOBNCV6nKWtdlbC3Y?=
 =?us-ascii?Q?PQZWOec3h9YzKyBrKedtjQIq4qAu+TYogUpLFfhVD6Mt4cNccmaco4BclL4M?=
 =?us-ascii?Q?mH5/Z/IS/lYOJLuGh+ttZM5p7SfSHCGZd4O6O3PLutAlok3ZgUm+kinjQnsg?=
 =?us-ascii?Q?tix0cwVt5kHGuvoPBgcm+qsZw+B0pwcdGsHYXn+q1wrnmPm7/qVIt39LWS4B?=
 =?us-ascii?Q?+JEaK0hG0UWS7J8AR4bEsYnKgr6pQ+qNPMqcbVN1zEeFKKTC9n5x70xKfRBb?=
 =?us-ascii?Q?k86KW/PNutqphyDX8weHaSFezqBlzTnmuXFkqgoSvUpk/L8mwZlg5u7gjnCb?=
 =?us-ascii?Q?c5yQhikvRg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a36020-959c-4860-5d2c-08de96b08e49
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 03:23:38.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IK9dNgRD4Ueti3sZVwdxyJOgQvEFBZqlnVfOZ5z7X6XXsmWT+/bDkqUQh48Oop602ha2KO22O7mZ1FNpuWjgYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8472
X-Rspamd-Queue-Id: 9E4AF1C0005
X-Stat-Signature: gmdwwcgyxgd9p4kdxnxaqq3dz6k5fbgq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775791514-97208
X-HE-Meta: U2FsdGVkX18UxVQoYbjUDYrxPt1yeYynQ1yooOMgBfKaZC8wC1CxaVUeKv3jMtkzf77lszoCYtP+6DNymcWY5qaAp2x2LDkZdYtpqTtFB+EIJiHx4YU4aRJkVjqkk7zIwws8uhgdrvpbnDCpHAwBaAnFBEfCdyQCEZAZKKhEKBFrpYVYbQn3xfDtgCoUfDqN1bE0KHzxyeOPHpzMxLgwI9C/4RC4CCTnX8tB+8a1CY4u4V7++RKXHwl4XmCmjqIPKOudkzdVk+VHz8fxll6G8Xj+7WXo7dpS5xhlEsETUWIuynMFOcaGXv1RBvf1VHhfIWvdloRVu6l6oa+UmjVM045oKGo8RVag2bVgeZb9ctHvU8wnPz2QaBeHG8eCSetQgeN+cEyDv7KkdIq0UHy8KzyeAGGIo36tvJUEYLWSL0QM6gyq2fV9tBnfx8hJjqXsp0GL6PifY4Q9++OxWvdm/Zvn/hPdU+i3LYrzVISJ8BSVZfjNv7GEQ4e7d+NgcFcqSKNOOQorq+dUqrwwGN/uNAytIJTZ3z4ETcCFSLyIPvCr8fBsf8mXSStf3LzCvUuG4M6OLS9UxbxUbELwUkwYlkp+bbmg0lXmMg4/J9ZUlowFTKMHUivbRWg+EHVye31fSBF3TvR9GOGJb4umyAMOmoIjm3wFZO095fYID0my2Cmhv1hROLmx40OUfdl03KKAy6+UmcT+U698ObwPfYtLhCqvBqIQVv5kVblysdhqGdndR+1E5f1DKUp2U9QUHbNWxJU0tPxCCrOwhaaZXG46pOWYDdOUuhY96vXq6m2b6vmST0FzOqFJedtDaXL1HOVvEXwRasUlgKUvAUuHil3A5fwp81qnHeHyjHXv37zqpwhz5V+/GMXihO+qOx0haZ3U/soXhH0k3w4e7dcFhCGeDUrWvU6CXB1pSKlPZZ43JqctM/ag2mB6zsTpizlcRC+8/qyRVK4n/gnmTgJfEns
 q2lM9zrj
 neS6ILmmwDDaq2DUo1MzEEzshXrxi4vo/XzQ078CHU2xV7IJADV+A8pMGTkcJxy/WI/ozpv57pEAg9rVoLeAwfUsGt2/GMMheums7SOFJQ2oCS2qKHFY0vJGZmILpCMjFgody+X+1pgndbhnYb6MvvRfsXjDgTifKlC4SMi+OYJBHn9JOCbCUBzMS619Ip8xVCIVONouNH6iAiuzIIf+Ug6pSAm9xRm+wWFGlq8vcHqyp52szJQ3fKu8/Pg055emfkYRXZyWvMs/UrKVuSvstI4Vl6+94knpXsEUHVwtAQFVzaHi//MsEylq4+sTbF4ZM2AyouJzSpwrDWDZfyVHrBCc11GABBukL4KU6xub/NcghBRv3c/8AhSfmVqLWTIaYITpJntBu21I2gZrhpCpqYVKFubsY4DCn7KKdFC4quRkgrPn6f4fhy+wdFmnYKCbR6etHLglXNm/r4W0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When migrating pages for FOLL_LONGTERM pinning (MR_LONGTERM_PIN), the
migration can fail with -EAGAIN if the folio has unexpected references.
These references are often transient (e.g., from GPU operations like
cuMemset that will complete shortly).

Previously, the migration code would retry up to 10 times
(NR_MAX_MIGRATE_PAGES_RETRY), but this busy-retry approach failed when
the transient reference holder needed more time than the retry loop
provides.

Fix this by waiting up to one second for the folio's refcount to drop
to the expected value before retrying migration. The wait uses
wait_var_event_timeout() paired with the wake_up_var() calls added to
folio_put() in the previous commit. If the timeout expires, the
existing retry loop continues as before. The folio_put_wakeup_key
static key is enabled for the duration of migrate_pages() so that
folio_put() only wakes waiters when migration is active.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/migrate.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2c3d489ecf51..a5d9f85aa376 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -47,6 +47,8 @@
 #include <asm/tlbflush.h>
 
 #include <trace/events/migrate.h>
+#include <linux/jump_label.h>
+#include <linux/wait_bit.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -1732,6 +1734,17 @@ static void migrate_folios_move(struct list_head *src_folios,
 			*retry += 1;
 			*thp_retry += is_thp;
 			*nr_retry_pages += nr_pages;
+			/*
+			 * For longterm pinning, wait for references
+			 * to be released before retrying.
+			 */
+			if (reason == MR_LONGTERM_PIN) {
+				int expected = folio_expected_ref_count(folio) + 1;
+
+				wait_var_event_timeout(&folio->_refcount,
+					folio_ref_count(folio) <= expected,
+					HZ);
+			}
 			break;
 		case 0:
 			stats->nr_succeeded += nr_pages;
@@ -1941,6 +1954,17 @@ static int migrate_pages_batch(struct list_head *from,
 				retry++;
 				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
+				/*
+				 * For longterm pinning, wait for references
+				 * to be released.
+				 */
+				if (reason == MR_LONGTERM_PIN) {
+					int expected = folio_expected_ref_count(folio) + 1;
+
+					wait_var_event_timeout(&folio->_refcount,
+							folio_ref_count(folio) <= expected,
+							HZ);
+				}
 				break;
 			case 0:
 				list_move_tail(&folio->lru, &unmap_folios);
@@ -2085,6 +2109,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 
 	memset(&stats, 0, sizeof(stats));
 
+	if (reason == MR_LONGTERM_PIN)
+		static_branch_inc(&folio_put_wakeup_key);
+
 	rc_gather = migrate_hugetlbs(from, get_new_folio, put_new_folio, private,
 				     mode, reason, &stats, &ret_folios);
 	if (rc_gather < 0)
@@ -2137,6 +2164,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	if (!list_empty(from))
 		goto again;
 out:
+	if (reason == MR_LONGTERM_PIN)
+		static_branch_dec(&folio_put_wakeup_key);
+
 	/*
 	 * Put the permanent failure folio back to migration list, they
 	 * will be put back to the right list by the caller.
-- 
2.53.0



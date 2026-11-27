Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AC9606A6B9
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QuKPjYnZ
Received: by kanga.kvack.org (Postfix)
	id 08DAA6B05BB; Fri, 27 Nov 2026 18:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065C66B05BD; Fri, 27 Nov 2026 18:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48BD6B05BE; Fri, 27 Nov 2026 18:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDE36B05BB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:01:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A915FC0574
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:54 +0000 (UTC)
X-FDA: 85482423348.08.E53FAD9
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB2628000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:01:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=QuKPjYnZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795820512;
	b=fnfpxKLwrSZ3S71rDZdkHosiKGbUSgv+ieW/JuJosBFO0dz4Xl1WJJ7BM941ct2gQGPn1g
	4HB90k2nCoRiN1NbuirqQdjxqkuo6A/aDjP8X9wIoYZhGAA6Z5NxN3YoriiOHzNsmbcVY0
	ubvWmzqd80rDLZGFAfPi+bdZtoe322U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795820511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qx4/b9TaPJYgc0NHouCo3H2YDZr8zP7ZhcpSdOp5I5M=;
	b=6ia2TDwRS1eRcaD+tQooFobgqRVdE70U6GCvXXglXu3u8bBVANd4HVU+UyOdRPhMcdDAyC
	CX2NcFm+GuJBNY0Sqmrn0Qzt3x+xCGr+O3JgPUrg5INLvjbcx9GzlHNDHNCLIfUIILnb1u
	m2lnPL8Kc1At3FZWA1TRfnC4jV37aIs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=QuKPjYnZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.57.44 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJuhyM8SEHsQJAdNqr831w0+obNA8pfNnZq+UPA+ILQDj4vFl54DZ9kVMtnot93QHW0+FjfovOnnLdIqppjGVIJgDUaqSgXmC+yAf5MtzTqpnhq/I7jVoYB5/GMzcbTddPl5s6UBVsB+WFd5D01dkqMAj0HmAa4FhFB98lU3qZ9g7FOJf+88xhiZPaQnKewdOoY4/kO8Uq3FEY1jsW4pYypWONJpAI2ybhOkgCKtD80o2YrJMiYvakrnidzscgWkPmduOxnK3djV+08sSVlYQM7yV5URRmrQVuedNfoFi3GpLwsI90HfNuJU6s/bkR4LjjyIiCB0e4k0WecHSc4psA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qx4/b9TaPJYgc0NHouCo3H2YDZr8zP7ZhcpSdOp5I5M=;
 b=uq0uKL7/4Rm+iMkr9/gQSOPyBDu85RiBg+0AdJhNkmYlb+vVuEb4EMt7wZaoCOvPip1V0P1St5vyU4fDsl7LhE0oUJR8wssQncDpxKRbkK6CTI9qLpbdEHMCZRICEVfc6bhp9hoGtZkAs2x0QdCS7Lt6jktGLtM18cxTkei2Rm+t4MVGDce3Qd4PLnYKwG4pCZlJxVRrrMNqguD4MV76mn88iOck4pZj6gKCVcW1l369W6LYnxCYGCW2303f8SNMFQmd4idtYWO24a2S75vmXv7K3UYDo0DPmk1IWLXPUQayo2XnqxO25PQtyQHvUbkKFiqFtbdZ4WJ5HoiSWu9sqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qx4/b9TaPJYgc0NHouCo3H2YDZr8zP7ZhcpSdOp5I5M=;
 b=QuKPjYnZ1701HLzWiTrSZtJ5ZwQVfVCd4cM0799u59y2XA3NcWJlgKAbZnepILUp7JdbkmkqxonVmK1lHN4Af7QJv9mg3p3I11yI7jUOziJ+k3BV3JH22GT0OFkUBZ83nrVv/O96Pg9qH6spYJLdOFFkRHm6BPBYQLDv+TIWf/bPofk4DF+xGfuUCrryO0V7VmIE+GMnXpnoeYkZM3dqpB6FJ3dFTYfic7Wl0n6AnpXX4kHMKDQITbqfqw60pOt2++fb6F/ti622OMWSo5duYjr0rp8uiqdoNQaP301IX9LVY2C+wfsNVCKPq8DcNTht6QBAqXlBwcMEXKmwu11cjw==
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by IA0PR12MB7505.namprd12.prod.outlook.com (2603:10b6:208:443::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Fri, 27 Nov
 2026 23:01:43 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 23:01:42 +0000
From: Yury Norov <ynorov@nvidia.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mips@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 05/11] mm: switch to runtime nodemask length
Date: Fri, 27 Nov 2026 18:01:22 -0500
Message-ID: <20261127230128.111933-6-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127230128.111933-1-ynorov@nvidia.com>
References: <20261127230128.111933-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0688.namprd03.prod.outlook.com
 (2603:10b6:408:10e::33) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|IA0PR12MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f220da-170a-4944-5a77-08df4cda66ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|1800799024|376014|7416014|921020|10067099003|56012099006|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	Kish0E8kW62eb73HNrEZqCoZGPxw37RxQMkgxYp6nN9x0Fva55AGNByyYiQJxxLrMcMCGGAvWR45czw8nIe0urRgd0jDTTuxz3JL8FcFk1tMar77cVZ9wPJK25v+wUGSXCP0NjNdDEtbJ8MsJ5vSh3RipO+gBR41ufL4I5g2rBkWIOFNJt6woEbA+oyudQV/2bc+b5iFLiWHBKgw0dZQphdQLkblTMn7sWUYZoha+uiD+SiGl5Hk8D+qyeF3DBytLHGTB39wQNmkxaBNg6JN8x2gcEmnNXcas19G+2FGhbsEAyw1lgygmUroOJya0U3wURioHHdLZAT5C/42kvghwzW9TkTmR61MBcJ1RA3PpRTTrLh9z6F7sR34FHLvMfYzEU2+2mhZH9YXJoy1tyUOaVs8tRlohnuDDctxmAOC5+MxlUZFvzyX2xmBqFaqMa8myIwWmVbMgC0UxCnNjhgBwLHFqKXEgZgcVYf8jXi0Tyz8CalAiHEmS4EL7McbK83ffjLdMSGNILPAezC7lnHlRnMwW3w6X61n7GtgZQCa5oad2yoABBmYb1JpB423q51tZDCupvbwnoqzWv2eiYDrq+2puPZjT7MvcLVxua8Mr1p0LhrlxmpwjfA6G5oOCg94u5/aN48x3hBeaDgtPPa2qcd1KsuGijVI1Du+lOrzLDkT0XKI0mcHxbCf2WguuIHTyACwDtRltProTkN3Ui7Tdg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ANkSIt97N/9Aqsp2ESDBjzR12blIo6wLac8Ei8kh0Y8STZNpFAyFuIopx/Pb?=
 =?us-ascii?Q?8lVuBrmMvo8OMGx9/2XFvako+7C1GTd2sl51AsUZbvR64+Jjm9X7PZ+aTVW/?=
 =?us-ascii?Q?7xB5Tr1qUDmsuawD2WllXElUwymOxE/zL8j7u3iUFdaMWsoyRQCkWmDfzUMg?=
 =?us-ascii?Q?JOFwcxernU9aPnML/Lyda7ulcNZEKnVRjMMBT/VlIIPBf4Umi2J4gZKve35s?=
 =?us-ascii?Q?/+w8eAfWT8LsuTZFMhv2O1Y/Hv/cFx2UiqCUFFHQeoSHd/J1tdD1W6ZL0D9G?=
 =?us-ascii?Q?hdDfHXmduQ6jg7EH1JF2vwppldB4tjH1m5MJa2vHjKgWgn8xCtuQC9JFK+Nb?=
 =?us-ascii?Q?6sGX+d1UwOmvs7u3mvzXRDcnKVuM89aJ9N0mQNIzERaOKf8JapV2/YZ//Skm?=
 =?us-ascii?Q?iiN9XA4WLiJWpjYDGKIN0oyZWDBbjc+oQtBiOOTxw162jrK6M+rIwIFohp3N?=
 =?us-ascii?Q?IGUDCCL7dflSSRCDimQdSEmKgjmuFz3koOdEMf3Od7TLLve/8fMdTsWeVMGa?=
 =?us-ascii?Q?fbzPVsrgKvohrG9pV/LeaKXmJn8BLtf/k4gLgXsa1Y/N9jWJL1dk9s6xKsZt?=
 =?us-ascii?Q?vjilhgnG2lFqBOMzSaVV71X+KKPmrI2SPv3XYvoZwA4fOrPzVjnRIflGVFfT?=
 =?us-ascii?Q?rNeiAfmUI6ljAEaz5rEpE1bmQIg9EtyqyIoMZkGYXYnI6XK6NPNjZupeyOWg?=
 =?us-ascii?Q?qOClOiHzypKwTqdxzGQheRfXTZdzfP2tqPJS+gUZ7kGXt2qQaDhO0iMwGe3D?=
 =?us-ascii?Q?T4shfNLQ2sHhhARWhMoJbOgsvvDD4ToTmovrGvMSLW/i8+bq+jBvYAQhRZH5?=
 =?us-ascii?Q?5RAXx/pBSV31z0nsBc72ELqDnWNSLixdnmghTgIw9CgoSAZUtXS6V3ucL/Jh?=
 =?us-ascii?Q?Y+Dzg/fuLp6MXr0YSo4HOIgMFPrqt+fSnnk27ESzM4j0cq+3T3IYs6yMLiZZ?=
 =?us-ascii?Q?jPn5PUTswUVvDvo2rSrL8P/qiFK1enqeeVl0eKXNVRodFViPNO9DihHOuF8k?=
 =?us-ascii?Q?A2zLmNwQQNxF2maxXFnsb/RNJpz0N1Gkw2PhVCQNlbk3omg8LQnmOV9KW8+i?=
 =?us-ascii?Q?RKnecvn53SVDxRXQkyESLXbKrtVqgyNhI62FJtrUZZZjP1mABu0OR6l6Ll9W?=
 =?us-ascii?Q?1vVIhyf5owEa0Sc9AO9lqZR/eMnuiv0qEXKHJpXCulIg0Ynoo5waZ+Wm0T7k?=
 =?us-ascii?Q?xhQ+cAX5IJC4uX7Rt9NvTnJ1a97JMNnCScVc3JeyL0Ybs1grV3OZFhv2cfbu?=
 =?us-ascii?Q?1mLL+P7TLltR5XTbpMKPnyPeqtcUKF1YA5HEge1s4/W/mRy3J+ViQSWWG4BK?=
 =?us-ascii?Q?seI87qpHvl82JmL+3PjJv8LI4mhAzIEqygjOb8AAQUxm0btiGsP99HcMsnNA?=
 =?us-ascii?Q?31kv+as2/9rX1UKa5edx5nVgr1RvEdtfr1hxJYHZZT9MKEKWYVi8rrVBDURp?=
 =?us-ascii?Q?F6eMcOHECn1IsJuB1GL67NbCi7h/N9cdfKk++CL5GZnusWW3RHEwdX4svNkz?=
 =?us-ascii?Q?ChRqX37hryG1mSmOo+4+ItsGmSiddqXVvapHp2N92pMyL0y8pNt3pR2Bpfeu?=
 =?us-ascii?Q?v0WvDv1f8DOx7nTVgzlHqRh6qm1BDHrPhFpkp0kKpnISPyFOW5EYACFD9b9Y?=
 =?us-ascii?Q?ViGdBOIeyzKKDAiBPnEHyVocKfBgrrFCjDzO5ittTBdBoLkoSsQSVE4urBF0?=
 =?us-ascii?Q?DWVgjwl35a+JhvUPCfuXVROodikgq9zZm2krq+yb8+UA19QDB7pnoUA5Nnu4?=
 =?us-ascii?Q?v2r7RiGMJVc5g7RakG198yPrDq5fEAoF7aTYLTb2tqk0D2H4mryB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f220da-170a-4944-5a77-08df4cda66ed
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 23:01:42.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CG9ruaV2uoj4Q5Bz2EoIqx+lK0M0lqY24kC3vxuY4sr1nx9AUAnTB4nVGFiOoEYqjdy9sv/8eCOmso+4wsqiEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7505
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB2628000C
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: f71tpj7tkts91jjy3rf5wksngj3yw75d
X-HE-Tag: 1795820511-22268
X-HE-Meta: U2FsdGVkX1+GFxg9y2b4dD+Yg/cA3MScqbePabH5OjmX2+0K2v1BxBsHcrOhWkribHiROGM9cOKNvIDJ83hAbaB6H+ln7hQgH7cQVR0iJTOKKr/BHg4pfSKsi0EAxq9yPqqr5iNGh6oP4wgR5rCC3KNTk63jumanFIp2T+FNdvt2Z5jTsQzaIqAgdfCrccigY0ky+aTp24f4a1xOhQdvMxmB2nKmPn6y590EhJc5xR69I5ukPr9m+7OePTom1EoWXclj4URSbkbcDJwZFCvDCO//fxuJBvx3BViTp03DKuC18fWruFJFH6FqIKOnulsCTTQ1ZWeyPHxvK+AQchl+Hn5PPnwWWznPAZgdhaP90O2p5wcW8x3VYZd8cOCo/bjQvbHOM4aqlXNkLAycxgKFC2YbZSi+H6ZFbguchx20ZW+mYbDl1P1WmKoTVtcMiN0PXXkCdHExmEEpoHLMY1f6sHe17JyxvmYXZaRf/xXF4D0M6ccvkVwL8rIRVLYXseW9oIhuJfKy3owrxWAeytSW+NdasZGMZqeItAzrmWIRZPXG+8j3Iyx55f08Gwf/DseBrR+TU2Bp1Gjj35qHw+rjfWKSFT3oi+thmDPRkhVo3ppRgFksy4D7iOPqZ+So/j/sHsKhMuSg71I6Xr2f4e+TSr3kZaAwIVfO1sDWQtnj5f2IJg0Ek758uJXIpnc0fSyvJ9IGcy+n7SiFe8k4BedHOhmomIFTAENLatn3lgNACcqWsFttlxMBsANReLAkG4wWRfjceH0y1lIMMs73W724wV59BQn7febCM3BVmBb7+GuRNoySDdLsfCgEw0HkNDjoz2QxSQXqGOeseXt15CGdBqdERCoorH2Lhe1BDw4yyo5/TAI3x+mQpTJJ5o94HtZ3c59IR9vzdw2ldScUCVMlg/n+UIGgPrOaBIjAVfQWAlmgVUcMbSjAcaMoiDHvontf6r9qln+c6htA6MWaLOe
 hMsB2wne
 Gus1EH2YeNEBiOi9ypcWVoRv4fUFpEOVe/2eFSX2ZqA1lvTZ9wOC2DyzC9R2HX+hmcfnKNZZKWy+svfGwi0opZQcYdIPTYJoETGhMr6BnvqU8OQ4ZCrl+ttSxYNWUg2zt1JU4lGKRrvcAs9xOb8PAVnweOaN9QKcj1Z6X+KRCGi3i4NE6ZPlmGdGiN7bbEhtnjh05z1peP3OjGTGvDhfsrvH1r66Sl1eZzIdN2CLzXXQHZ2D6TnKxgXSe9SNmhm9PGPXz7aRZhcLTbMKh3ZrhA61YIiLFqGLng/SSH8ov356G2sIu5yj5oWVqhZhxKLc+hQTdOuMg+4k01DxZ4tPq+jEF4kdwErhnGiG3zKx/KONyHAHL4SnBkjqdrE3khOOyiyBbvslPsDs4Mr2z3CJpphkeXEZeVTbxowh4bV+CPUpnJ/BxSvwn+/yMm4iDHBAynYBzOV8hs3JdcT3IPVDMA2O44pnDPhypk2sLowRqbxakmWm7dbi045n4M4GsVuJp34lrZvZbZgjMPm2BAq+j5h/qU37vW1bbxSF2m8gPQRJ6fd9rPCBZoZVyjUnmM3MyZwQ0foYW5TtEj/kRttFgeTekvDWeUdXVmBvfdro64trsYyNutcNAAv0tDDsnHBb49V8Ydbxpk2LY1GMac4HrnUaS/sJBok+KM0kfdqzEZLTzLQPyeBd7EiGvlkkUkqVbzIM/KjDLwPshFDODRZL9ymneN9PQ35j8xzy8L2LgAE464eaf3/C2bYpRu+vupCP6OmUqucr10wc0p9YFACOser7uzc2u/83/dZJ/g8YLtLE0a5ZiZAbzhjpeZ96ZdAkXfkpJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation for switching nodemask API to runtime nr_node_ids,
update the boundary checking conditions.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 mm/hugetlb_internal.h |  2 +-
 mm/mempolicy.c        | 20 ++++++++++----------
 mm/mmzone.c           |  2 +-
 mm/vmscan.c           |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 1d2f870deccf..bcdff7485c8d 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -31,7 +31,7 @@ static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
 static inline int next_node_allowed(int nid, nodemask_t *nodes_allowed)
 {
 	nid = next_node_in(nid, *nodes_allowed);
-	VM_BUG_ON(nid >= MAX_NUMNODES);
+	VM_BUG_ON(nid >= nr_node_ids);
 
 	return nid;
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ed8b20b27753..d64d3e70a82e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1123,7 +1123,7 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 	current->mempolicy = new;
 	if (new && (new->mode == MPOL_INTERLEAVE ||
 		    new->mode == MPOL_WEIGHTED_INTERLEAVE)) {
-		current->il_prev = MAX_NUMNODES-1;
+		current->il_prev = nr_node_ids - 1;
 		current->il_weight = 0;
 	}
 	task_unlock(current);
@@ -2141,7 +2141,7 @@ static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 		node = next_node_in(node, policy->nodes);
 		if (read_mems_allowed_retry(cpuset_mems_cookie))
 			goto retry;
-		if (node == MAX_NUMNODES)
+		if (node >= nr_node_ids)
 			return node;
 		current->il_prev = node;
 		current->il_weight = get_il_weight(node);
@@ -2162,7 +2162,7 @@ static unsigned int interleave_nodes(struct mempolicy *policy)
 		nid = next_node_in(current->il_prev, policy->nodes);
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
-	if (nid < MAX_NUMNODES)
+	if (nid < nr_node_ids)
 		current->il_prev = nid;
 	return nid;
 }
@@ -2261,7 +2261,7 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	 * Clamp this loop to a single pass (nnodes) to keep the walk
 	 * bounded by node count.
 	 */
-	while (target && nnodes-- && nid < MAX_NUMNODES) {
+	while (target && nnodes-- && nid < nr_node_ids) {
 		/* detect system default usage */
 		weight = table ? table[nid] : 1;
 		if (target < weight)
@@ -2272,7 +2272,7 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	rcu_read_unlock();
 
 	/* the mask emptied under the walk */
-	if (nid >= MAX_NUMNODES)
+	if (nid >= nr_node_ids)
 		return numa_node_id();
 	return nid;
 }
@@ -2295,11 +2295,11 @@ static unsigned int interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	nid = first_node(pol->nodes);
 
 	/* A concurrent cpuset rebind may cause us to see an empty nodemask */
-	for (i = 0; i < target && nid < MAX_NUMNODES; i++)
+	for (i = 0; i < target && nid < nr_node_ids; i++)
 		nid = next_node_in(nid, pol->nodes);
 
 	/* the mask emptied under the walk */
-	if (nid >= MAX_NUMNODES)
+	if (nid >= nr_node_ids)
 		return numa_node_id();
 	return nid;
 }
@@ -2697,7 +2697,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
 	int nnodes, node;
-	int resume_node = MAX_NUMNODES - 1;
+	int resume_node = nr_node_ids - 1;
 	u8 resume_weight = 0;
 	int prev_node;
 	int i;
@@ -2759,12 +2759,12 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	rounds = rem_pages / weight_total;
 	delta = rem_pages % weight_total;
 	resume_node = next_node_in(prev_node, pol->nodes);
-	if (resume_node >= MAX_NUMNODES)
+	if (resume_node >= nr_node_ids)
 		goto out;
 	resume_weight = table ? table[resume_node] : 1;
 	for (i = 0; i < nnodes; i++) {
 		node = next_node_in(prev_node, pol->nodes);
-		if (node >= MAX_NUMNODES)
+		if (node >= nr_node_ids)
 			break;
 		weight = table ? table[node] : 1;
 		node_pages = weight * rounds;
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 65880396f104..2c96341ad7e0 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -19,7 +19,7 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
 {
 	int nid = next_online_node(pgdat->node_id);
 
-	if (nid == MAX_NUMNODES)
+	if (nid >= nr_node_ids)
 		return NULL;
 	return NODE_DATA(nid);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..7d78181946b7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5751,7 +5751,7 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	++*pos;
 
 	nid = next_memory_node(nid);
-	if (nid == MAX_NUMNODES) {
+	if (nid >= nr_node_ids) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
-- 
2.53.0



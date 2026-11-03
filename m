Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549BA606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BCD6B05B8; Mon,  2 Nov 2026 21:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64E06B05B9; Mon,  2 Nov 2026 21:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D5A6B05BA; Mon,  2 Nov 2026 21:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64CCF6B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:45:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 641F91A02FE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:19 +0000 (UTC)
X-FDA: 85392266358.07.FCECFFF
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020088.outbound.protection.outlook.com [52.101.195.88])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85AB010000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.195.88 as permitted sender) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793673916;
	b=k8YJTXYN0Ev+gITWVEc1lf9OLFSa4Xymx5BDsGk4q+FE72Z3exvF3BfZL+xuZK5+zfy/0s
	w/aiS/PQEO+Tvp3k/9GWmpaIenMhGPjtAvxsq6o1egm0h6XyjJ9KU26B+AznhzX4+z9otj
	dowXAlxA3C4UuudrVq/WdMPw7IBYbA8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.195.88 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FpVFQ8e1PJDHQiin+SzHK4wSa7oGdWib0m+YrbhAu7o=;
	b=tN6mB0lgl50/ehNiiUftbleIaorCfuCGtuqCeSj+3hgyP3ub+Egcr/p/5ua7axPTUKESAb
	QdcNAV4Tpsk13yTsX2FUIUEUdwTbZa2YbuWrgwIXz/fgFI/2x9BWelSqQhgp5n3ZQhmcdU
	oEyWkmi0bznGdXpX9coB38QvXze+vps=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYjh4WsiGUCPy369ZBetS7rPBUy7k8SmYDcFyZsJJKJe9934Q8TEnLYAhehsFT4vxz+GMXjuaF2jw8jmZpDwQS/mBzxqY8I7xtgSar0S8N4i5EMMDLsWFTpBPwbDV39QOeAC6YI2DSBWeXvoWkYWUxGyRs6eVUg1x8WFDSx3T0Qm/55zbic3nRxjGM5dPFB/RE+6bsdisnabPmZmIEFXVwV+EvIEs30oxpxtCpABmuv8/YJrELPBJYwuQsh0qqrv8JVjQERgkMGt1b8rvNCDYgI3MaJRFf8EpzOF8IZDQXSY77pl4p6xAkVfYrBDx4EsPVnGK2Qp5axonR/+LJxGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=FpVFQ8e1PJDHQiin+SzHK4wSa7oGdWib0m+YrbhAu7o=;
 b=a2OufrHVnJ3jGDpXih+GjuatXlpM/ylrmXYkSJ4DNKCvQWes+oNFIOS3YpU5bNsc/POxeUrBpdDnk4WLpqtTpYfyHE7x0A0B6gphHNhTn+L+xJJGigb4+7Lr3NWwf1GsMRhFdoWY6T/ELkJgAE9AJKbR+q5Pi/J//Sq9y2R2jDHgtu3lSKuvLhvH+4zYoEEE6iDItbGeB9oMQoRKwpPETh9JCmiwtkRSXL+TMa8BloRpoLVlyMSpYmkAIRlfPih++fy1ElWtxRGikVevwloOjixdCLuIJk72HKM0VApibu65t08Iel30xVBCTE10gevQsfpR3zvOsMUiQ2SbP9rjlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LODP123MB490682.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4e0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 02:45:12 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 02:45:12 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: pmladek@suse.com,
	john.ogness@linutronix.de,
	rostedt@goodmis.org,
	senozhatsky@chromium.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	anna-maria@linutronix.de,
	frederic@kernel.org,
	tglx@kernel.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [RFC PATCH v2 4/5] printk, tracing: Support console flush suppression and tail pinning
Date: Mon,  2 Nov 2026 21:44:52 -0500
Message-ID: <20261103024453.922373-5-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103024453.922373-1-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:408:ee::34) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LODP123MB490682:EE_
X-MS-Office365-Filtering-Correlation-Id: aaa4f8c6-1a27-4bf3-6d85-08df39547b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|6133799003|10067099003|22082099003|18002099003|261102123227099003|261102130727099003|3023799007|56012099006|261009221227099003|261022105027099003|261026121527099003|261022075727099003|921020|261026140227099003|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	8WE5TeV1HSF2K3frH4zYlQnI2HGYWZC9wa8LbaUtHsYh84pFGz1XlFRlzrkqGpDZu/+jpaP8d5Li434IONm4uGwBoquLIzWrZM5oV09xrP7xUNDQVY0/WeoCoigT5gFphTPC4gkQamcjjMItK+61bxIRyIune5bJRzeHN3s5pu9WOYGtKfzbS0z3CY1Z2L1onrxTNDsPYWvl+QcePgRVKbTuygW8P5KPuvM0jDuX2A+mAq7B87S0YR6wrDrjrkfqYOwCzC6IqpCw25Oo8QJ/HN47QyUyLcVHAuomlMPd3bQSTsxirAXixeL2+/Q1FJFQ4Gab5C2LCtvpf1Pj0QQANvHybXPgpCjmzTDaZ1SV/+8UM9X8UyY4kqRpo/CPalO+QCRkhZ9ypcAw79lUjHXlT3FU7rpaR/8Ewi1e+1zvPC9BQNLuhkH+P+hTwqK4AbuxA09R9cHKM3tN2zkknCCXS4zojxEFOl39Tr389KMS/vbIHA/EY4FRgBpNYsyOQEo6oz4VjCgPlX8CzdddjADrE6Rft8ueSxbYBu2UrT9VbjYxWcLDFYCyfC+KwdZ1Xkj0TyUzkYmh1RMfuloIwht4tArx6RwtSv/OjM+l0ObVNWKXW2mpju1LVWPu8nWkCMKOJHWqIFrofYm+eshAhyYdW1wILwfUmjvauuvAwIjdvDq38KfdoX0Ohy8emc77YCksYiDAvv3p5PCJV/tonhr22A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(6133799003)(10067099003)(22082099003)(18002099003)(261102123227099003)(261102130727099003)(3023799007)(56012099006)(261009221227099003)(261022105027099003)(261026121527099003)(261022075727099003)(921020)(261026140227099003)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261021135927099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/GsH+1vLcv1GGkHIF/4hii6T8ht/sEowsjC6L1wcu9dCtGVBQs/h7EXsPXSK?=
 =?us-ascii?Q?SzNLMON1xNDXsjqcdcZg240vr2F6Ow7O3Yy+RZIaszY8p4wLg7F4ChJ5r8Ss?=
 =?us-ascii?Q?Lz5xs2/XeTLPGXOjIYqcvRYGEykDO3pNllQUCv9gF1fYSt0bILmJqodfwsm6?=
 =?us-ascii?Q?DpZB+VHq7KQH+x7saKOTNbqsezliajrpm1l07DgQ7EXZZWW7SCYMVuEYfmoy?=
 =?us-ascii?Q?8Elw8Z/JZWwV+ku2PR6sV/MGSo3gkk1Jet3aWIDLIKsaxIPLDX1pqqM0GL/t?=
 =?us-ascii?Q?0WzwZRGrjvEO8kSVeHUJggqqBAbyC0SiqhMst1qM9o7e9F7PY9BNM8DYCxrw?=
 =?us-ascii?Q?QBMeEpDVYDAakNMu9sMh74JxsMcDz31bF0+UUIBWFpxUIGNu1JpwU3J22+xO?=
 =?us-ascii?Q?3R56372SWREWBnhT2bSwipsCmVWXV4yxaUedTGtQqBF6XnaAkALxqxfQ4dCt?=
 =?us-ascii?Q?Xod3kzbC5Zs9tGMkvgOcweArTKsdbkEW7wYDt3c6Hs99cQYpmN5lyXEmUnqF?=
 =?us-ascii?Q?TX0iDFc19Glwvm7TAPNl1y1nMNiPSrxrFnZ4Xq2mAc9sVhiVEsR3p2TvtPcv?=
 =?us-ascii?Q?gg/xSj9atiCRG9yMMP3hj3Qp9DXNQY7bHn2HG6YjXZL34w4O9bldRpY4sPGC?=
 =?us-ascii?Q?PaLbWv4dVlyhNJQNFDKTFsjtrxLgx7FUiv0vF4DqPftr0HCaR87lOaLpV5BR?=
 =?us-ascii?Q?peT3/qZJF+AUuVJ+qG9xaZY0GtILsxGZBYtgLgmzq8ljF4Yd9DRf71BFGpJw?=
 =?us-ascii?Q?9o5+NLZwe3inNgiWG2wdNz12f/yYPhakpoNqyWQmNpwDCP/00MYK7M7vWRMM?=
 =?us-ascii?Q?ZTUD2c9tV8JUTz8z7TqozbQeOSSmlgR3IpnV9PJzghNl90CGmfCi9cY/PSRq?=
 =?us-ascii?Q?kTQniWc5QMA9RZXXrLlz5Rinn8mvrZC3ID6+jdO6R9ivIEpXDHTSwvub0bFq?=
 =?us-ascii?Q?ciJm3hr2R3+sYUlrpdzk49LWLv+d49Gh66ZAyh+J+gVT38r9/pXszAZcIgg9?=
 =?us-ascii?Q?pk8b4rYxPVOT4S87D3jc8ZdnIi69gwjkPprhhZpwRlg1Ebpy4Zoh5O0Y2KKf?=
 =?us-ascii?Q?CJYqqh+7wwKDGkZbiZ3BfJDq558bSWDTm4rzrkz5glC2N+mSVrUjHgXLX7CZ?=
 =?us-ascii?Q?OkM7bqcg1KinBJkfDmrla4sn0SzDXzb6YYUlyLg932kKLluS2l9V7sGiInB9?=
 =?us-ascii?Q?BJPw8mEwZFj/TxIN/sf3Q4MYKlKT5R9uBobJw3NXGHPATaPOKVPh/NUoE6Zp?=
 =?us-ascii?Q?6sH6kDyDjDF8w4pUkbgeF18uJARy1lju7D5JEe7ycD7aZkzcMA3Mby2Kbmit?=
 =?us-ascii?Q?ukeaMSmfQ3Y8lR8UiL53i9qABNWPyN3IWfmo/0Qf0Gg6JWzDxIXoNGL+s25J?=
 =?us-ascii?Q?pCEOXEHwmwZzRngBBoeK+r1wxxJX1mtpapNqsqP0YP2JeAbx4OjkshxXoWE3?=
 =?us-ascii?Q?Nj8QnHjAHxZvzUUQc5fmfY0E5Ly6SRmFuWROTmH4TqAPPDi7iIYfyAUDCfz8?=
 =?us-ascii?Q?+e2TWqdR2tRxwvkGiAUNcnoV2EPF1s+Fl9u4Eo9hpX6Z7GPvX/KtiwHi7lNE?=
 =?us-ascii?Q?UHF18KhqaYBSoQus6mdZ3KAQoGQnuGAEtGN0/H+AVUPa3uk+rXmaTIWnnIlw?=
 =?us-ascii?Q?cC1fIVg9QqLceV9Y47PDIaPsndjiFRm6c5kTv+GIZbVyqpyvaDj6z06zKMuF?=
 =?us-ascii?Q?+W5vamCbdbkj9hvIf9Yq/+OAR+7s46U/cdzr1Wq9PdqY470BG1Lw9GTyHY4O?=
 =?us-ascii?Q?0n1KKNjyXQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa4f8c6-1a27-4bf3-6d85-08df39547b46
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 02:45:11.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHGdTMJ+aCy79ZWeWy1vWnhSJN0NCnDL1vpkXx+GPnMF10zcpGoR/SvF1ldb1uA+wvtqNXBk++fm7XejjKbABg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LODP123MB490682
X-Stat-Signature: p4cn9zr1kikwiu8q9dehudffg3y4sqhg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85AB010000B
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793673916-329761
X-HE-Meta: U2FsdGVkX1/6iyRIcG/cglBWnZWs3slqVeXLiVoH8hpTM9SfYhlR13Po2JbjhH6hdrbctGlfsNXrNEK82SAYZCCAMS5Vof3U55l7ZBvbbIYb1U7CIsPdf4OOp5+AV/QjQ3g2le3WYghQHomNq8Q5eRmMHE1P7ljarxkUphyTJg9ZPSuMVFvVi0XbykjchcaROkMOxp4N906Kbwiwmdloxyx8mkPG+tWOl5rQ5hEsqjkmL0NpHcjxBNQ4bNUg/8L59t4o3yrMFzd9EI9CrnlkeDCNdVjdyNb9IVxe6u5UMowWdXx7+qadvEThaFzhXBVoeEe3xZ89sqU+FErqysMm1kyFvkpTD9yBa7TNqTLhfGt7whu6wIPDjCtDKr+mszebBwzyzUE6pi207UOTsn+2yLRFimlF3FjMY3Pp8tUKxJl5QLEXzlTFCelbGodEp1aiXeFsla4QouMQKpdpXXacQsg2YlRH4P8dU4/u8moQEqOUJGI4hirzqmKn6nW57CW/v+8jEHHtjPiPHloQW3tIVnNhm8v5sXh4jkUNWcB/Gep1OAyw2XHVqbkjOxeIrHtgAR1uzo2MjKZIm4l7g/jMxbgjHVw0VJeLodHRfXPcB6nI5KyrACGUSs5u7RHlw/fmFFV8iywWV1GqyihbevzSKRLR8a0Uza2yB/wB2ckoSigVtavozhxvajmsCJ8VIJ9w7i19CwWOqPsL93uyHCBFJI1wyDPY4dR8FBZxu2Ppmh0cpNkqr+uGLwbe1P7vSnICz93qT7cuExG3/sO1uThLtMJnmZ/aLUuihCJ6i3OngXjlhMXvh7Ow1F2VNXl+oVxpL1QdMaGBTj4ngtg0YC4rk5wjs+qmC4juRIgfR/7Hcq6LV0AP6OYLH0d8v5xT4YBg5prbURVanDeP9lK6qV+VQVJcsbEO6fwRZ5pM+U23mBsbIpuIie3suEpNQv2Np2VpoKRXdz5kN3Rl8+2snS+
 7kg25NVp
 YLRCgrbYjWgm76L8FjQP30JiEqxYFNXvVRI0BoVlT5acTUbBYNnD2MlZQ80qx3SFMEdxcHNhv6LzknH9nM6VZJTroLoQ/LsYubN6CXemYrOYmaa/vcfIgy4IwHeDlBqbZOqF67tPi3NchCGWhHW4ne+CSdkL6uliXNqwJ+qRPDfQQXjFPUDEsxEUYRpH7UzhrZxLT00AwrUBGt2IY9C88rK1fOn9hydNYy2joW+/oH5BnFHvRwqucyzPDeOfw8XybHM3M6lxEhSbN3RU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When collecting high-volume diagnostic output into the printk ring
buffer during a kernel crash prior to kexec, synchronous console
emission can stall the panicking CPU for tens of seconds on slow serial
or IPMI Serial-over-LAN links, risking external hardware watchdog
resets. At the same time, uninhibited ring buffer rotation can wrap and
overwrite the initial Oops, faulting registers, and primary call trace.

Introduce two scoped mechanisms for in-memory crash telemetry
collection:

    1.  Console flush suppression

        Provide printk_suppress_console_flush(bool) to clear the console
        flush mask in printk_get_console_flush_type(), guard legacy
        record emission and kthread wakeups, and suppress
        wake_up_klogd() in vprintk_emit(). Records written via
        vprintk_store() are stored in the in-memory ring buffer while
        bypassing synchronous hardware console emission and kthread
        wakeups.

    2.  Ring buffer tail pinning

        Provide printk_mark_panic_start(), printk_clear_panic_start(),
        printk_freeze_tail(bool), and printk_is_tail_full(). Recording
        the next reserved sequence number at the start of a crash (or
        clamping to prb_first_valid_seq(prb) if the crash output itself
        already wrapped the buffer) allows data_make_reusable() and
        desc_push_tail() to continue recycling older pre-crash records
        while refusing to advance the tail past the pinned crash
        sequence number. Once the watermark is reached, prb_reserve(),
        prb_reserve_in_last(), and ftrace_dump_one() finalize the last
        record and stop reserving descriptors or consuming trace entries
        so the primary crash context and remaining trace buffer remain
        intact.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/printk.h            |  27 +++++
 kernel/printk/internal.h          |   4 +
 kernel/printk/nbcon.c             |  11 +-
 kernel/printk/printk.c            |  29 +++++-
 kernel/printk/printk_ringbuffer.c | 168 ++++++++++++++++++++++++++++--
 kernel/trace/trace.c              |  20 +++-
 6 files changed, 244 insertions(+), 15 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index f594c1266bfd..17806c515fe6 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -205,6 +205,11 @@ extern asmlinkage void dump_stack(void) __cold;
 void printk_trigger_flush(void);
 void console_try_replay_all(void);
 void printk_legacy_allow_panic_sync(void);
+void printk_suppress_console_flush(bool suppress);
+bool printk_mark_panic_start(void);
+void printk_clear_panic_start(void);
+void printk_freeze_tail(bool freeze);
+bool printk_is_tail_full(void);
 extern bool nbcon_device_try_acquire(struct console *con);
 extern void nbcon_device_release(struct console *con);
 void nbcon_atomic_flush_unsafe(void);
@@ -309,6 +314,28 @@ static inline void printk_legacy_allow_panic_sync(void)
 {
 }
 
+static inline void printk_suppress_console_flush(bool suppress)
+{
+}
+
+static inline bool printk_mark_panic_start(void)
+{
+	return false;
+}
+
+static inline void printk_clear_panic_start(void)
+{
+}
+
+static inline void printk_freeze_tail(bool freeze)
+{
+}
+
+static inline bool printk_is_tail_full(void)
+{
+	return false;
+}
+
 static inline bool nbcon_device_try_acquire(struct console *con)
 {
 	return false;
diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 85fbf1801cbe..72f0a5d154ec 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -186,6 +186,7 @@ struct console_flush_type {
 };
 
 extern bool console_irqwork_blocked;
+extern bool console_flush_suppressed;
 
 /*
  * Identify which console flushing methods should be used in the context of
@@ -195,6 +196,9 @@ static inline void printk_get_console_flush_type(struct console_flush_type *ft)
 {
 	memset(ft, 0, sizeof(*ft));
 
+	if (unlikely(READ_ONCE(console_flush_suppressed)))
+		return;
+
 	switch (nbcon_get_default_prio()) {
 	case NBCON_PRIO_NORMAL:
 		if (have_nbcon_console && !have_boot_console) {
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index 5f8afaca8866..36db1a8abe94 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1194,7 +1194,8 @@ static bool nbcon_kthread_should_wakeup(struct console *con, struct nbcon_contex
 	 * ownership in the middle of a message.
 	 */
 	if (unlikely(atomic_read(&nbcon_cpu_emergency_cnt)) ||
-	    unlikely(panic_in_progress()))
+	    unlikely(panic_in_progress()) ||
+	    unlikely(READ_ONCE(console_flush_suppressed)))
 		return false;
 
 	cookie = console_srcu_read_lock();
@@ -1253,7 +1254,8 @@ static int nbcon_kthread_func(void *__console)
 		 * mode. See nbcon_kthread_should_wakeup() for more details.
 		 */
 		if (unlikely(atomic_read(&nbcon_cpu_emergency_cnt)) ||
-		    unlikely(panic_in_progress()))
+		    unlikely(panic_in_progress()) ||
+		    unlikely(READ_ONCE(console_flush_suppressed)))
 			goto wait_for_event;
 
 		backlog = false;
@@ -1642,7 +1644,7 @@ static void nbcon_atomic_flush_pending_con(struct console *con, u64 stop_seq)
 	 * is not available do it.
 	 */
 	printk_get_console_flush_type(&ft);
-	if (!ft.nbcon_offload &&
+	if (ft.nbcon_atomic && !ft.nbcon_offload &&
 	    prb_read_valid(prb, nbcon_seq_read(con), NULL)) {
 		stop_seq = prb_next_reserve_seq(prb);
 		goto again;
@@ -1659,6 +1661,9 @@ static void __nbcon_atomic_flush_pending(u64 stop_seq)
 	struct console *con;
 	int cookie;
 
+	if (unlikely(READ_ONCE(console_flush_suppressed)))
+		return;
+
 	cookie = console_srcu_read_lock();
 	for_each_console_srcu(con) {
 		short flags = console_srcu_read_flags(con);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9a205f94bfac..cf60bcd5acfb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -467,6 +467,9 @@ bool legacy_allow_panic_sync;
 /* Avoid using irq_work when suspending. */
 bool console_irqwork_blocked;
 
+/* Suppress synchronous console flushing during in-memory panic dumps. */
+bool console_flush_suppressed;
+
 #ifdef CONFIG_PRINTK
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
 static DECLARE_WAIT_QUEUE_HEAD(legacy_wait);
@@ -2386,6 +2389,23 @@ int vprintk_store(int facility, int level,
 	return ret;
 }
 
+/**
+ * printk_suppress_console_flush - suppress console flushing in printk()
+ * @suppress: true to suppress console emission and klogd wakeups, false to
+ *            restore normal flushing behaviour
+ *
+ * Context: Any context.
+ */
+void printk_suppress_console_flush(bool suppress)
+{
+	WRITE_ONCE(console_flush_suppressed, suppress);
+	if (!suppress) {
+		printk_trigger_flush();
+		if (!console_irqwork_blocked)
+			wake_up_klogd();
+	}
+}
+
 /*
  * This acts as a one-way switch to allow legacy consoles to print from
  * the printk() caller context on a panic CPU. It also attempts to flush
@@ -2482,7 +2502,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	if (ft.legacy_offload)
 		defer_console_output();
-	else if (!console_irqwork_blocked)
+	else if (!console_irqwork_blocked &&
+		 !unlikely(READ_ONCE(console_flush_suppressed)))
 		wake_up_klogd();
 
 	return printed_len;
@@ -3243,6 +3264,9 @@ static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *
 
 	*try_again = false;
 
+	if (unlikely(READ_ONCE(console_flush_suppressed)))
+		return false;
+
 	printk_get_console_flush_type(&ft);
 
 	cookie = console_srcu_read_lock();
@@ -3665,6 +3689,9 @@ static bool legacy_kthread_should_wakeup(void)
 	if (kthread_should_stop())
 		return true;
 
+	if (unlikely(READ_ONCE(console_flush_suppressed)))
+		return false;
+
 	printk_get_console_flush_type(&ft);
 
 	cookie = console_srcu_read_lock();
diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index d38e7c2f6887..60c8bd2f6490 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -377,6 +377,90 @@ static struct prb_data_block *to_block(struct prb_data_ring *data_ring,
 	return (void *)&data_ring->data[DATA_INDEX(data_ring, begin_lpos)];
 }
 
+static atomic64_t printk_panic_seq = ATOMIC64_INIT(U64_MAX);
+static bool printk_tail_frozen;
+static bool printk_tail_full;
+
+/**
+ * printk_mark_panic_start - record the ring buffer sequence at crash start
+ *
+ * Pin the next reserved sequence number at the beginning of a top-level Oops,
+ * fatal warning, or panic so subsequent tail freezing can recycle older
+ * pre-crash records without overwriting the primary crash output.
+ *
+ * Context: Any context.
+ * Return: true if this call newly pinned the crash start sequence from
+ *         U64_MAX, false if a crash start sequence was already active.
+ */
+bool printk_mark_panic_start(void)
+{
+	s64 panic_seq = atomic64_read(&printk_panic_seq);
+	u64 first_seq, next_seq;
+	bool pinned;
+
+	do {
+		first_seq = prb_first_valid_seq(prb);
+		if ((u64)panic_seq == U64_MAX) {
+			next_seq = prb_next_reserve_seq(prb);
+			pinned = true;
+		} else if ((u64)panic_seq < first_seq) {
+			next_seq = first_seq;
+			pinned = false;
+		} else {
+			return false;
+		}
+	} while (!atomic64_try_cmpxchg(&printk_panic_seq, &panic_seq, next_seq));
+
+	return pinned;
+}
+
+/**
+ * printk_clear_panic_start - clear a previously recorded crash start sequence
+ *
+ * Clear the pinned sequence number when a warning or Oops completes without
+ * triggering a kernel panic.
+ *
+ * Context: Any context.
+ */
+void printk_clear_panic_start(void)
+{
+	atomic64_set(&printk_panic_seq, U64_MAX);
+}
+
+/**
+ * printk_freeze_tail - prevent ring buffer tail from passing the crash start
+ * @freeze: true to stop tail advancement at the pinned crash sequence number,
+ *          false to restore normal ring buffer rotation
+ *
+ * Context: Any context.
+ */
+void printk_freeze_tail(bool freeze)
+{
+	if (freeze) {
+		printk_mark_panic_start();
+		WRITE_ONCE(printk_tail_full, false);
+		WRITE_ONCE(printk_tail_frozen, true);
+	} else {
+		WRITE_ONCE(printk_tail_frozen, false);
+		WRITE_ONCE(printk_tail_full, false);
+		atomic64_set(&printk_panic_seq, U64_MAX);
+	}
+}
+EXPORT_SYMBOL_GPL(printk_freeze_tail);
+
+/**
+ * printk_is_tail_full - check if the frozen ring buffer tail hit its limit
+ *
+ * Context: Any context.
+ * Return: true if tail freezing is active and the ring buffer has reached the
+ *         pinned crash sequence number, false otherwise.
+ */
+bool printk_is_tail_full(void)
+{
+	return unlikely(READ_ONCE(printk_tail_frozen) &&
+			READ_ONCE(printk_tail_full));
+}
+
 /*
  * Increase the data size to account for data block meta data plus any
  * padding so that the adjacent data block is aligned on the ID size.
@@ -591,6 +675,9 @@ static bool data_make_reusable(struct printk_ringbuffer *rb,
 	struct prb_desc desc;
 	struct prb_data_blk_lpos *blk_lpos = &desc.text_blk_lpos;
 	unsigned long id;
+	u64 seq;
+
+	*lpos_out = lpos_begin;
 
 	/* Loop until @lpos_begin has advanced to or beyond @lpos_end. */
 	while (need_more_space(data_ring, lpos_begin, lpos_end)) {
@@ -607,12 +694,20 @@ static bool data_make_reusable(struct printk_ringbuffer *rb,
 		id = blk->id; /* LMM(data_make_reusable:A) */
 
 		d_state = desc_read(desc_ring, id, &desc,
-				    NULL, NULL); /* LMM(data_make_reusable:B) */
+				    &seq, NULL); /* LMM(data_make_reusable:B) */
 
 		switch (d_state) {
 		case desc_miss:
+			return false;
 		case desc_reserved:
 		case desc_committed:
+			if (unlikely(READ_ONCE(printk_tail_frozen))) {
+				*lpos_out = lpos_begin;
+				/* Pairs with data_push_tail:D. */
+				smp_rmb();
+				if (lpos_begin == atomic_long_read(&data_ring->tail_lpos))
+					WRITE_ONCE(printk_tail_full, true);
+			}
 			return false;
 		case desc_finalized:
 			/*
@@ -621,6 +716,15 @@ static bool data_make_reusable(struct printk_ringbuffer *rb,
 			 */
 			if (blk_lpos->begin != lpos_begin)
 				return false;
+			if (unlikely(READ_ONCE(printk_tail_frozen)) &&
+			    seq >= (u64)atomic64_read(&printk_panic_seq)) {
+				*lpos_out = lpos_begin;
+				/* Pairs with data_push_tail:D. */
+				smp_rmb();
+				if (lpos_begin == atomic_long_read(&data_ring->tail_lpos))
+					WRITE_ONCE(printk_tail_full, true);
+				return false;
+			}
 			desc_make_reusable(desc_ring, id);
 			break;
 		case desc_reusable:
@@ -690,6 +794,12 @@ static bool data_push_tail(struct printk_ringbuffer *rb, unsigned long lpos)
 		 * data blocks before @lpos.
 		 */
 		if (!data_make_reusable(rb, tail_lpos, lpos, &next_lpos)) {
+			if (next_lpos != tail_lpos) {
+				if (atomic_long_try_cmpxchg(&data_ring->tail_lpos,
+							    &tail_lpos, next_lpos))
+					tail_lpos = next_lpos;
+				continue;
+			}
 			/*
 			 * 1. Guarantee the block ID loaded in
 			 *    data_make_reusable() is performed before
@@ -787,8 +897,9 @@ static bool desc_push_tail(struct printk_ringbuffer *rb,
 	struct prb_desc_ring *desc_ring = &rb->desc_ring;
 	enum desc_state d_state;
 	struct prb_desc desc;
+	u64 seq;
 
-	d_state = desc_read(desc_ring, tail_id, &desc, NULL, NULL);
+	d_state = desc_read(desc_ring, tail_id, &desc, &seq, NULL);
 
 	switch (d_state) {
 	case desc_miss:
@@ -813,6 +924,14 @@ static bool desc_push_tail(struct printk_ringbuffer *rb,
 	case desc_committed:
 		return false;
 	case desc_finalized:
+		if (unlikely(READ_ONCE(printk_tail_frozen)) &&
+		    seq >= (u64)atomic64_read(&printk_panic_seq)) {
+			/* Pairs with desc_push_tail:B. */
+			smp_rmb();
+			if (atomic_long_read(&desc_ring->tail_id) == tail_id)
+				WRITE_ONCE(printk_tail_full, true);
+			return false;
+		}
 		desc_make_reusable(desc_ring, tail_id);
 		break;
 	case desc_reusable:
@@ -881,8 +1000,11 @@ static bool desc_push_tail(struct printk_ringbuffer *rb,
 		 * not in an allowed tail state. But if the tail has since
 		 * been moved by another CPU, then it does not matter.
 		 */
-		if (atomic_long_read(&desc_ring->tail_id) == tail_id) /* LMM(desc_push_tail:D) */
+		if (atomic_long_read(&desc_ring->tail_id) == tail_id) { /* LMM(desc_push_tail:D) */
+			if (unlikely(READ_ONCE(printk_tail_frozen)))
+				WRITE_ONCE(printk_tail_full, true);
 			return false;
+		}
 	}
 
 	return true;
@@ -1428,6 +1550,9 @@ bool prb_reserve_in_last(struct prb_reserved_entry *e, struct printk_ringbuffer
 	struct prb_desc *d;
 	unsigned long id;
 
+	if (printk_is_tail_full())
+		goto fail_reopen;
+
 	local_irq_save(e->irqflags);
 
 	/* Transition the newest descriptor back to the reserved state. */
@@ -1505,8 +1630,11 @@ bool prb_reserve_in_last(struct prb_reserved_entry *e, struct printk_ringbuffer
 
 	return true;
 fail:
-	prb_commit(e);
-	/* prb_commit() re-enabled interrupts. */
+	if (printk_is_tail_full())
+		prb_final_commit(e);
+	else
+		prb_commit(e);
+	/* prb_commit() / prb_final_commit() re-enabled interrupts. */
 fail_reopen:
 	/* Make it clear to the caller that the re-reserve failed. */
 	memset(r, 0, sizeof(*r));
@@ -1664,6 +1792,12 @@ bool prb_reserve(struct prb_reserved_entry *e, struct printk_ringbuffer *rb,
 	if (!data_check_size(&rb->text_data_ring, r->text_buf_size))
 		goto fail;
 
+	if (printk_is_tail_full()) {
+		desc_make_final(rb, atomic_long_read(&desc_ring->head_id));
+		atomic_long_inc(&rb->fail);
+		goto fail;
+	}
+
 	/*
 	 * Descriptors in the reserved state act as blockers to all further
 	 * reservations once the desc_ring has fully wrapped. Disable
@@ -1672,7 +1806,24 @@ bool prb_reserve(struct prb_reserved_entry *e, struct printk_ringbuffer *rb,
 	 */
 	local_irq_save(e->irqflags);
 
+	if (unlikely(READ_ONCE(printk_tail_frozen)) && r->text_buf_size) {
+		struct prb_data_ring *data_ring = &rb->text_data_ring;
+		unsigned int size = to_blk_size(r->text_buf_size);
+		unsigned long begin_lpos = atomic_long_read(&data_ring->head_lpos);
+		unsigned long next_lpos = get_next_lpos(data_ring, begin_lpos, size);
+
+		if (!data_push_tail(rb, next_lpos - DATA_SIZE(data_ring))) {
+			if (printk_is_tail_full())
+				desc_make_final(rb, atomic_long_read(&desc_ring->head_id));
+			atomic_long_inc(&rb->fail);
+			local_irq_restore(e->irqflags);
+			goto fail;
+		}
+	}
+
 	if (!desc_reserve(rb, &id)) {
+		if (printk_is_tail_full())
+			desc_make_final(rb, atomic_long_read(&desc_ring->head_id));
 		/* Descriptor reservation failures are tracked. */
 		atomic_long_inc(&rb->fail);
 		local_irq_restore(e->irqflags);
@@ -1725,8 +1876,11 @@ bool prb_reserve(struct prb_reserved_entry *e, struct printk_ringbuffer *rb,
 	r->text_buf = data_alloc(rb, r->text_buf_size, &d->text_blk_lpos, id);
 	/* If text data allocation fails, a data-less record is committed. */
 	if (r->text_buf_size && !r->text_buf) {
-		prb_commit(e);
-		/* prb_commit() re-enabled interrupts. */
+		if (printk_is_tail_full())
+			prb_final_commit(e);
+		else
+			prb_commit(e);
+		/* prb_commit() / prb_final_commit() re-enabled interrupts. */
 		goto fail;
 	}
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e8c4efa8107b..35a56f04e9b3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9519,6 +9519,9 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
 	else
 		iter.cpu_file = RING_BUFFER_ALL_CPUS;
 
+	if (printk_is_tail_full())
+		goto out_enable;
+
 	if (tr == &global_trace)
 		printk(KERN_TRACE "Dumping ftrace buffer:\n");
 	else
@@ -9537,10 +9540,13 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
 	 * and then release the locks again.
 	 */
 
-	while (!trace_empty(&iter)) {
+	while (!trace_empty(&iter) && !printk_is_tail_full()) {
 
-		if (!cnt)
+		if (!cnt) {
 			printk(KERN_TRACE "---------------------------------\n");
+			if (printk_is_tail_full())
+				break;
+		}
 
 		cnt++;
 
@@ -9551,19 +9557,25 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
 			int ret;
 
 			ret = print_trace_line(&iter);
+			trace_printk_seq(&iter.seq);
+			if (printk_is_tail_full())
+				break;
+
 			if (ret != TRACE_TYPE_NO_CONSUME)
 				trace_consume(&iter);
-
-			trace_printk_seq(&iter.seq);
 		}
 		touch_nmi_watchdog();
 	}
 
+	if (printk_is_tail_full())
+		goto out_enable;
+
 	if (!cnt)
 		printk(KERN_TRACE "   (ftrace buffer empty)\n");
 	else
 		printk(KERN_TRACE "---------------------------------\n");
 
+out_enable:
 	tr->trace_flags |= old_userobj;
 
 	tracer_tracing_enable(tr);
-- 
2.55.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561DDC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABEDA6B00A9; Mon,  7 Sep 2026 22:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F8C6B00AA; Mon,  7 Sep 2026 22:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9906B00AB; Mon,  7 Sep 2026 22:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 627906B00A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:57:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E963DA45AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:57:01 +0000 (UTC)
X-FDA: 85189083042.23.B26057B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 253181C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AfoIAkaR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/a8D+bFtx0HUA3t19qonoIIEgpEm7wqE1QXKariwwko=;
	b=OxKPF/iTF0FRYfxCu25mnkBUFASVxezIkjVsksTAyir6pYUOCO0o0kcI+YHMWXQIRTZLjM
	OSDNqA1RJGo+5T4OivmF4IjaNILGA0Q6wTY9z5Zw9tfuQo/7Bzn7eQ2Ej15fSCnNn93YX/
	GUvGeotIbVxWZhHhBeRsIy8JICd5BYc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AfoIAkaR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836219;
	b=NdLjp+zixZtmc/ntUZsONVmGknpoBDiumywwq/j1cnQ2RON+BFrJUE977iuoUFUcFLb2fp
	9E2eY1xqJID/fZnDNmK+RX7FRGU8/QTyIm0JtFn2cw2v58eq9TO5KlpZd0aE0tfzjOdCre
	IegXpSgwOc9r/LYMe2nmA+gKL0CNZLg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mg6AdhQtKzb4KkBJbbZXUIViVZuSYg7pG1vGBehAaeCmyroT1u9O/5icrrmV96N1H/sE8DnheC+jL4Y+xEV2ibiLnpXxvld9gQTBWKjlaF7LmCqLci9r82LRsFc6KB91+TXeqqWwLWMzV5j730nZsVjHjq8pg8NiTQL7ZE53XnRoYVluojckNZVBJ/AaOWmqznyO00rwAE/s3SezoeneAAWqSzdYSNJi9YgG86++3aNmsHdprMArUhUMweIQJgPO+SyYyCDUeh7SAL+E67F8YeGF2Bhvy+epLSbvKh8+Xy8IS6+6Cn5gkTmTrc2pjxfrbz2pD9GupCrFSOItc1owPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/a8D+bFtx0HUA3t19qonoIIEgpEm7wqE1QXKariwwko=;
 b=BX7We2Sak9x7BlEV0H3oFavKEOzjfLg4Y685w3lfOKBkTjD2rYVUtOXFBsQO82S7/k5lFy5/u6adAtMXHvznW+QU6zFMnsm2X4iPq+rRLlrVWtq4OCxhhZZd0xpNSzELlrZDKIRsmx3Jy7vvImDbjl3PAcecZcqpuNCr1DPEoY19ro1gRNnQNP/U50n+sqHY8zWivVqxo+Xy5/RZroY3NmZjRE8+7u8eah8Ldmli7WO7FJM6bXjEIxdQgZqi2EnwCkFm+RjeOuXMjGdPZjRfEQvi5qW9+1Q7P0olAEzmoYm82n6E0631pzCPKLSpq8q0/8t3Ai36IMKHcHFrAW+n6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/a8D+bFtx0HUA3t19qonoIIEgpEm7wqE1QXKariwwko=;
 b=AfoIAkaRQa5v/I3+Myjzqk+AQb1YEdXyYGWW7Ipw4L/I4mM3X92ZpR66doj/sp09HH0uiOQyUyUCjCQ6dG3xJAcBzXvjTA0aw5OJL5zdLyWHhPSvKbDV2m6m5n4aZIKbGbvfAysHsrXYz6ylIlKaPNo66O6unwPLhP3afkmO/HVHG0o3JPrhssuUn/fMRIuxCHTiOuXFIS6QH3vRAJ/BIoJTDrNtNUqJYnDiZT37NoDDszHJs0oqrALihu1PWX/RGHUVaxdqyC0oNny7t3kC5tk8PyrlloMIlQh82oeYbjoumtLAngL6Ql1xqB0Y02khqXEO79lr6s0bkWHhvnnwOw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:47 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:21 -0400
Subject: [PATCH v3 14/14] mm/page-flags: remove PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-14-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 26bc9ed2-10aa-408d-c825-08df0d54d2bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|6133799003|5023799004|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r8ig8Z0s8zks6rz7cAkiPPXjse5Ms9hqAixaivp2StYdcD0W+y8E60G5huITjb5VV9aCvV9WoTHo8CN49Vn5B48f/JbaDaKS7hMh7+twb8GBckh6SGo7NFb6PMwjA1JmEKBH4K9+Ykae2cjYCHWX7BUpBD9Nzy99o8VHYiHC1f0+t6O1ZsuM0zXYUdMGYlN6GRbpuYJ9XtD85ZqGh5jkNd64n596LRkHqYhbDtYmZsmkSWTfRNXwYzHe5YptC30FxPPGOeFDmLcDfHT1cp4xXFOdcz57biqWWya8MzBOvlWU3iK9q1g+/2w/4rWthHNJgBzo/xVCkO3mjKst74NHJ4Ql3TqSU2AkjUFTYZBPWzHwSaqGp0BYV4hqRZoXRfd2aybnbKYjik5/uNvvx8HqIJcSfUQkMqKsadBqkQ4uuOttDw+Dw6brmFp9merfXHEJnHk5Mxq8us4VcxA19/tpu4q7oC0bOcbogTAU3PjBcCgITrrb1NOS+dNQBaFHejgueWblFnLwdMw/2OhxgkJ+vZNplks4THqCfFERknzkQCXid3MX2YOZmlXxeNCXsJOG8/Jl3Q66AG7/aE0XES4tdF1OQw19a/vnuDt2g8JyThJXc2Iz+xQaOE4Cg2KtoA/Be9VMV4JV4IvcEozjrK/3aeDY8VIvvAQqlW49lSdy9HXeshm/2OEJbESKhaSci8WynWEfRHsE6KVA6JVmyKNHTg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(6133799003)(5023799004)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUpFME95eldhdmxrVGhlOFRjOGkxQ1BpbmpLMGlSNW81YklpTUxOZ3FNSjJi?=
 =?utf-8?B?aWQ4TzVlOEI3Vis4bEgyMjFGanJaLzZzSERScEY4UDdLajViQXNUZzFoczVC?=
 =?utf-8?B?ZGlqOUxJemhQcGV6ckFjSkpEaGxJNVlhemNRNTFjRFdmMjVVckZMTXlTemFM?=
 =?utf-8?B?S3JrZDg2WnR5Sk1rVE9wRDdwY0d5WHpyOXVNZzRJQkVoRXd3NUZmS1dCbXZm?=
 =?utf-8?B?TTIvSkhURERiN1dtVjRrb0FVQ1J4NVREdDdnOHM5dWNBQmJJUzdZU3BhYnRz?=
 =?utf-8?B?a0p3UmJEbVhvZU9aUk1hQ1hwUVJIbjV5TlIxVmt2WTk3M2Flbm9VZ1BHTG9K?=
 =?utf-8?B?bkRkaUtiR2t4QkE5MzFvL1JuTGgvV3Z6RVAyOFY4ZGRseDVwRGtGUnFUY0Zo?=
 =?utf-8?B?VHovM2RhTWplSlZVN1F2MFEyc1dDalVCNkFTTmRMaGZaZnJvUlMrT2ZUQWc4?=
 =?utf-8?B?SFVMZXV5WFFDMEpEM0pMZHNHL0thVVh4bDU2TEEvTXNlSHBQRlJ5ekorZnl1?=
 =?utf-8?B?UFFJbi9ORGtacG95N01pQU9ETFFURkhaT3lOeVc1UXN5Z2E3eUtrMVhPTm92?=
 =?utf-8?B?V1FTZWNlMm5aYXhtQk5XMHY4T3pzMlJ5aFl4T1RjRTlHamRYeDZ3OEdSbFdE?=
 =?utf-8?B?TTM1YzVYR3ArRFpYNVNXNGVoTmtxRlpoVDMwaWxQWERyeUJvbkFJVWF5SGk5?=
 =?utf-8?B?Lys0dEw1N0lPYk5NQW5YbEVnT2lTcGV1MGtvSm9qbWwrckUvNk9XUHBFdGdm?=
 =?utf-8?B?bHZuQmJBSXQvQ0lKNW5TcjN0d3l3RWFyaFlLVDY0ZThJa1NzazZVd1haUWNr?=
 =?utf-8?B?SW55TDRhQ1NteExNbFRTZjRRVTFTenlMczJOeVlFWWlIdVp4SjNHV2RNeDU1?=
 =?utf-8?B?OEFKMVVWN0dCMkVPcjQ3a1E3eEhNWHZKV2hhMmVBV2pVL0dGZDNpUUJsallL?=
 =?utf-8?B?SFZ2aUNyK1NOS3lSOGFYaFBNTmc1S2RLdDBSK3lvUXZSa1c2OFZkS3BWS3Q0?=
 =?utf-8?B?eEdaUTdrTUtIelowMUtKdFpmaGt0T3FJT3BlbzR2VnJHV0RkeUdoQmY3MGFQ?=
 =?utf-8?B?RnRDZkk0cnc5UCtITHQ2SitXNmhVSUN3UXZjcFA2RDNvKzA1ekpmdWFRQ1ow?=
 =?utf-8?B?cTVWSE5tVGUvaU9GUTlScXJkSTNXUUtnR0R3WEJiR2Q1TjJMRDMzVDlMZHhN?=
 =?utf-8?B?YS9nV0FCVndpbHdIVG04RDREK1BiaUVwNDlXc2hMdTllUFpBaC9tTTlkbVUr?=
 =?utf-8?B?OEExUUhhTGJ3UDIxVHJZUTd0R0RhZEhBbmNrYWJTdm1KK1Z6akcwNW5ZTWhG?=
 =?utf-8?B?R0hZSnFKdEFsOS9VNVhDNVkyc3MvSWs4TmdRRmljYjgydzAyallYRjdmVUdQ?=
 =?utf-8?B?VndsbW4xelVXcDhpZTBnc2plMytRQStRUk5abHFYWDExR2grOVIwUGtDU0Iz?=
 =?utf-8?B?Sk45cWpVaFR4b1M1dEZ1WWRvV0ZjY0dvZXlPVmJUNkZUVjExWk5vMEhVZmNm?=
 =?utf-8?B?dmhsazZoWmorcFdhS1VDa0NOYVZyVXdyY2hPR2dObDVZT1lEMUZVdHpveHRZ?=
 =?utf-8?B?bWxORWl0T0VLRTZGM1M0YUlGUEdyS213YW13ZnlSTXV3VDB6d0FsTU1pUVkr?=
 =?utf-8?B?WGJsMVorZndxaGVHUXNZeVFEbm9ZVVVxTGJDMG9pcW9KRHhGanlkR3h1aWdt?=
 =?utf-8?B?U3owcy9jNzlmekRDV1dWWFBZM09uM2dBUHE3bmZBWmVweklQaVorelFSbnZK?=
 =?utf-8?B?dmp1c3EwREE1SjhraEs4SUNhZmdHNHpGbVp3bmdQMmhIN0tTSVB3OXpjclRu?=
 =?utf-8?B?d0xmdjVzZ1VZUjEyUXcwRkJ3UzZBTlZRR1g0SVBtS3hRS2NMUDU3d2JnbTdh?=
 =?utf-8?B?ZVhnQjB5NzJ0M0p5UHBVMW4rN1hPbDJEb1lGUW44Qm1Pb2dzU1hrNDlsS3Ay?=
 =?utf-8?B?RVpEUzdiSkhlM3I2ZXZQU09JV2xFa1JONlZZdW9qRXBSK0hxYmtURC8vS01W?=
 =?utf-8?B?ZmJJVHJuNEF5Z0RjbUU2RmJtNHAxLy9DQmRBTGhuNk94TzVVRExwbHB3d2to?=
 =?utf-8?B?MUVVcEdRazFDd1BIMWNTL0xabmZWaUFLVkVNL3JXQkMzUUluSDNma1llck04?=
 =?utf-8?B?L3lRaUZJWGRkV3RPdW5JbWx3U0R5VTJzQk1IZEpRVE55UXM2bzRBb3RCQ05H?=
 =?utf-8?B?MWVqS2ZDN3dCUlQ3eEZTSFJiSENnOWRHY1UzcFJzUFJTdHdJL3Z2M1hHZlJH?=
 =?utf-8?B?K1VPRmEraWUvRXMza2h6Q3djVG5XaVpvUUV2TTV0MUtkR1pFS2p1bGV1SHMz?=
 =?utf-8?Q?5r0pXtOeReH6qVTa+B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26bc9ed2-10aa-408d-c825-08df0d54d2bf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:47.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHXnXbPsI3rSGoTfTxuNgXB7QGWuWPz6iEbP3NFCQ8TeNobD8Rpcy2C5VU5NPl69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: 98wz4j5chxq38wk4swoet9h7ittppbgj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 253181C0003
X-Rspam-User: 
X-HE-Tag: 1788836219-1074
X-HE-Meta: U2FsdGVkX18+qOKqA/xRGjiLu5cUOiQ61z+/V0B8xPebUcX/pT0f28AHLiDfBpXQOl/vQySSjRWDxOzhc4vdBKHzOF4HzZn7hDya5+CrjJ3ZARjvP3AaIrzjUqZkra52vKwg5d6/p6NRWaBj8GKb/9pbbVyGUwFLtceJREOOrGClsoTZBmohUgXrQipc8ou1TYuQLl5cRmixbMHWDY0CA9ZbesP9i12knI+F14K2jM7P7Ige22GasMGRU1Di7RlUcvANq/18yAlCcIXjvfnl7wEsaix3vqZZrjqnz7LNOyW/CrPGI/kndctptpamw7BMJNi/10VwTeoFbh0G4or60B2T2Fls3Ex6kM9NWIQIHQecQBXKYB1CbyJ0iVbpMkN6dYVh82CwdxpMIea1wqNyfGEsdLX4CWWY06nneJc2EXh1xrBNog9BYS97wlzIzKEjsncnpnQp+E0Ypo9AkNO67i3CVrLFNqVZwUoZ3rut6mwDMLWHxG6kV703iciVxjvkBd2VXh1RfhF+MM+5oB5pwx18xsa10X0vaQAzt/u7i69PWyfsNLx2nOB95Wo3uQPBDrDbX5f2rxVf3rXAnrZY1GuHEy1/Pjby2lbr3hmr14bV0VTn0onRTlOZGi2iyjHTGgtLR3BPTqaIa3nW5UFAvg340bkPcJ9F1kh93K8BRN3kOmr8UgUI7ZDUYGd9GEIiHLMy1MTxctYLv4rKiItp9+fB9f2HvEiIJn3+VovYSzoH/6iOKmuNMbb8wkpDGNFKWgLKejgHiPGCnoOpKSBgWMS1uoWbEwzO76ZNy8x8So256Ld0r/tqm648+49de5HHmxw3wIDrOguv01Fs2wOkzmzOoMx1alqjvZCmZ3zRNmirE/zF5Grn/jFsyEjH/TML4vucU9Wm9P1XAF+E5cD0G+PePcNz7o7qZ/JL4UqvMeYRtm/2vFoeyIrPpXznSvN/FIyHYYxYNceLyKaNIpA
 xoToCFCT
 Z7leSz/tQYUuY68iVucG+vkRcmvgfCm88K9f2o6n/Zpm8cawkM1mw+aCN+dACXrSLTF4S7VMjnrS1l/la5mJcSK6NVE1HsCBnFlEdwiFevfNZJhYI+2YliQNv4MDjzhLWE/JWTelefh3Sj8QZOfnA5kFfPUsE43Xt7g0vZbuOhB0aXUf6dob05mm1MRJLNav7CDbRYRGPRRDXQ/9NbrdZjk4EdONiHDULVWyrHnDPtF/VCRgVJmrTPFZSKMInhRuyPH5DZjDCkq6qdbEXFvPqeVnI0eYld+TfBrDBRFqBkGFs4NcdwO6krODv+NFIZH3BlgGZShLdljhKtL2VjddQxbx1GXkSYs/Ukz66X8huezG/4LOSWdL1o/3Z2ldXS6y/nIfBIuRY4LNAPTKl+UqloGVJpWVasYzWSxukk08cKBLiraFHnNxiwFT4YyB0/Mx/DksVRvUCDNWSabG+lXfOI/gQ7QzqtV/Z4b1BXEwazAGbuM8Xfk/HYr9IfG3o5LbKesUGfKVBVKoK2eMD5WA0U7Ppd9eGpocr1Wlxgir7qviGEBaT4cPZdOFRtC7VhENZqCLB6GeC+YNXHvVozBpqRlZ/y5igMy5pVgQ1T/xJ4rRLQF9Bzw7VHwkG2RiswXfvwmlXgf/KMTBSlxq3CFhC25gVDdPbeYps4ZJBvxytSYaj+x7ILUBhsDpi7H70v+tOd2D2nV8Yqc6fcJBc8uI/UStjLpgG88m8/aQwCs2i5NN/CeNJGvg0kVYcQQNAWMA2Xx4dAYaFSbJiZT/QG7/UlkvuwYqSX2pCSYvBpkGE4o1kzv81uz5KTwF859Tm/5urQmfpMZn+AzDwChpmAa5VRAsVtxFhzkvPdZicnnKxmu6JRezdtWxpJiGezFBMCkpDnth8UZw9DGkxyPTWEnUnvBFeZ5cNqRYAob+oEypCyIqF5b6kmJTcFoUgAAwdaVySqmqZoh4fUoZ9tfxzIXKPug/GBpI7
 OcoFLC1a
 y1Ft0XYzYThzHbILwd5glMKqLjPhbvQxQkLVumPOEtqKww3VmUE+8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->private != NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as __PG_folio for future use.

__DEF_PAGEFLAG_NAME() is added to show __PG_folio.

Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
left unchanged. It should be rewritten.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kexec@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
 Documentation/filesystems/vfs.rst              |  6 +++---
 include/linux/page-flags.h                     | 19 ++-----------------
 include/trace/events/mmflags.h                 |  3 ++-
 kernel/vmcore_info.c                           |  1 -
 5 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index 7663c610fe901..5f1df6d080508 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,7 +325,7 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
+PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
 --------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index d3a93eec3945f..dec7816303c6a 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -649,8 +649,8 @@ Writeback.
 
 The first can be used independently to the others.  The VM can try to
 release clean pages in order to reuse them.  To do this it can call
-->release_folio on clean folios with the private
-flag set.  Clean pages without PagePrivate and with no external references
+->release_folio on clean folios with folio->private set. Clean pages
+without folio->private set and with no external references
 will be released without notice being given to the address_space.
 
 To achieve this functionality, pages need to be placed on an LRU with
@@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
 
 An address_space handler may attach extra information to a page,
 typically using the 'private' field in the 'struct page'.  If such
-information is attached, the PG_Private flag should be set.  This will
+information is attached, non-NULL 'private' field will
 cause various VM routines to make extra calls into the address_space
 handler to deal with that data.
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ce7fccd90367b..7b7783c0a5216 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	__PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -576,7 +572,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
 
 static __always_inline bool folio_test_private(const struct folio *folio)
@@ -584,17 +580,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
 	return folio->private;
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	return !!page->private;
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index ef9aa388b84f7..38a2d30230443 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -130,6 +130,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 #endif
 
 #define DEF_PAGEFLAG_NAME(_name) { 1UL <<  PG_##_name, __stringify(_name) }
+#define __DEF_PAGEFLAG_NAME(_name) { 1UL <<  __PG_##_name, __stringify(_name) }
 
 #define __def_pageflag_names						\
 	DEF_PAGEFLAG_NAME(locked),					\
@@ -144,7 +145,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	__DEF_PAGEFLAG_NAME(folio),					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212a..5a417f8a922ab 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

-- 
2.53.0



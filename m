Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88481CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA53A6B008C; Mon, 11 May 2026 10:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CD86B009E; Mon, 11 May 2026 10:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C746B009F; Mon, 11 May 2026 10:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A81B36B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:36:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D47A120154
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:36:26 +0000 (UTC)
X-FDA: 84755389572.29.6D7B74F
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C603120002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:36:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uiU99MJi;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M5veXEF2hMAR1nBiLdcto9FKD49bGQ7eP3aWkPIW5ws=;
	b=na90seyqEVnEjtcUfDPbXmLM0otJN+B8Wnl/tdiHvXXszOX8VI8b1vSryneszvgfcq9dC6
	CulZGCQ8BFsg4YYWADHBXOcONxDsRIHaLM827lnn1+xqEOe90v3OhATfAXydnjO6aqlkvI
	+52tM5+ASpqNX0P6XXNDC/cxxzdqaxQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778510183; a=rsa-sha256;
	cv=pass;
	b=RbWCUW2mfUrbc8CNvcx4aA44qBmK68LbJAUYJzSFVxnxXpKQ43SntIHLIyVZy00u9oOZzm
	qz5+/M1g6HkO2A89U7dyZ8uVvgtvXeAOy35JZsw1sVaOsRf2NZVtzK12FFkwu5Glmt9yPx
	JtcnsXlDETYg1HQ0caDYyZFAUF4yFck=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uiU99MJi;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvKtRDO/nRjlhqiqfC8sDFRMGXUlRb2CC8ml+Lp/3HjdUpj92LTlT7slssIC9SkB7bUjxGcqrkXp+LcjxX8GXhBPuqNvad8g9/zerm54ANCzjkMTh2DowICEV7KuaNIe3NDPBfoIu0TqEG3tyAk1UkfZMV377bbHbyMwGLPlVdiw/zZicm8q510sHLNMsQl1AgiEY4YWdFjSykBi8iqRLej/iw9mB0bS/5nISQcW+26hmxRFYJ3PHKS/JxI0k/YniCyrmq1XoqO0XzKhHhZz9W3AMTbnFfcim1G4H2iHjglbyz8fMPzha6OlXrfo/RKbTzMhhKloxPTQMpQv+wUtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5veXEF2hMAR1nBiLdcto9FKD49bGQ7eP3aWkPIW5ws=;
 b=xF4vi8B+FcUvhqiURJUiAmhzjtr7cvpIQbjWDsN3YoC4jKz+nfb+Pjmz/Ul6Cbe1pw/VQEzQi4aGx6fvid0XibpkQA0M6kTDozHAaUbL25OJBnJ/nV6YJoLwLema1UmBC0s0scXMLliAQvkVDx1fjv+xnmCU9+r7cpqAtbkk1DAP+J5+m3sbtl8N+vPV4/mYq4fYLRuRDtHQs4UDq2HjYB/hI9aFPGZgq4gY4DmaELwNHZp0scOKxps8HM2UfB9OwgQPYAS8WOvmkb+v90JINa4Pw4ex2KtUNqYhwHY39J3OZPGR9hUzzlIwe47wDw7mkItPZv2hUIg/y9tNQqL71Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5veXEF2hMAR1nBiLdcto9FKD49bGQ7eP3aWkPIW5ws=;
 b=uiU99MJiQqikpPL/u6uxAFwkTymEhKoI/Far7EgIk8ozSgDVDWirBDruLIdXbSZTCji4yr7FAGYOn8InGapemETAau5tCqWTLQ5aOUoD57ASbacwZs6xhBDreOnYU34hWYTrzfHqkn9PcJruoPHZ9OepsrCHpFHQpTwU8bBQsyoIR0+p6hhkc/hZny/Qqd8dabbH3xX0T5uxR+dEX6ubDRjcIx9bPIKQaUy/fKHubfyeDDHA6ynT37UWWr3yx1wvtEDWr+zo/Jo0V2XHuc+JztoXrGnO33eI+I/L1QM+mOH7BwSC2VBPWRl9xEEE4+9hnpM8Y+srSw6UShrZH7VZ8A==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 14:36:18 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%6]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 14:36:18 +0000
From: Joel Fernandes <joelagnelf@nvidia.com>
To: linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>
Cc: nova-gpu@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v3] rust: maple_tree: implement Send and Sync for MapleTree
Date: Mon, 11 May 2026 10:36:04 -0400
Message-Id: <20260511143604.3848176-1-joelagnelf@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:52f::9) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 144f8d82-de83-45a5-b979-08deaf6aa99e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|11063799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	koOqwkcihJKrwNDK5rLwn8G+qANQFNEpqrbpGC0LGEpHnhg6+2kQjpajmyEmWJdBDVEolaDgFeMNAXRlczMA57KV/+XZV97OtNNSGk38aCwipRvy0x2t56c0kJHVn/BJnyCnUxZ0F4M3zuw7ilYtejcOTQlKQQzd1sWzNfvn00PLCClWs7jLGZE9qWRK6xG5sxBrj9K6NOUBjH6k5Nz+f7B2jPKBlpVcEV+6lackjNlSLijem3E0jzdYah+TAllQCEneUynPZWnx/40SDQwRKJyi4zf0ehMw6//v/FDOVVroKSGIkKBqVI6W7AHx2D4icjnLsK0LuHVDLVrGpvI3JtIb2pWxIDqHiithBP1BGi+UcAogGkhRVqD27jsCFVSSCRiNEKSrr2YnnOEpskYKAOd0LuLCU/QaZdH244rXOMDNKA3COCTnHBCtYnUFgBb+9SoEKydhjcX7dtRA4B68qx/xm8dFa0p56h2OfekQjbrqqZNBmQLb9cVxZt50Qysyb4DuWC8Eqw+vCCU1vSFXMs0KVpkg3OwJyWoompSGwsDqjXUOV6i2JfFz7XC5mYA3dCQj9+cuUVyyxqh0l0zcJbyFrzpKAinDoi8KBc6m4o/+VYvweentOfrc80PYOGsaCQ3TsqskZS+CV9eGLdBBhdwR65Fmq4hYnSeCkoRvvDySn2fhupYLugcxrDT5Naxc9azzOMI6BBrDq0R50wl/+toX5bnN5KAILGIbcWJHSUo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(11063799003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uCysW7TT+CbPv39pkG8lqtCQWdlaZuJ9siOzrk5MDYZlxm9qcv3zxgjtUOhY?=
 =?us-ascii?Q?cU7AKP9oKGhbe4+Go/G//N8W1uos4zYNK2cU9dwb29OtDdK8sWr5XcRAvslT?=
 =?us-ascii?Q?Y48NeNJxamw+pASx8lozkeKN89XJmF4NyylAlVMAK4dmIX5RfcygG4dO01ed?=
 =?us-ascii?Q?WPhmPJupwq/ttY0unBfG7/Iu/X7LhJo9247LDcu7KCkxdehm3jn2+F4zEZSI?=
 =?us-ascii?Q?4PvnttU9ALQP1Iyd21b3AWrqOel+DIAyBKj9Th1nklHYyypQjX9vr44NbqOJ?=
 =?us-ascii?Q?cnH9ejVlGHVVm5fMkF8suql+VhG8Il5VvNNgl1Dw0PDiOpWguwy5y+iLENT5?=
 =?us-ascii?Q?nmx/bgPSHVpA3tZtzb1Vj89ojSyDxD3jTVOPNifbylzLvVJUCwmhkKM9MO59?=
 =?us-ascii?Q?uAQT/090+ELihTyMFYJ8hwHqrR5jJSEuLOL57KZb4b3MTC7Q8zJ2zN+Hu3ql?=
 =?us-ascii?Q?aDAG5zt4m+bwZRk3OemJiqfZGEwx6IllEa0X16N6wGl2XOlky0nODdIGHaNA?=
 =?us-ascii?Q?DPkqm4KerVOlAbbDg1PW+Rr5GXY7HbvTCJeiXwydXC1dIQbkYKtEuXeWQdc2?=
 =?us-ascii?Q?RFxrYHhbXBR9Q8HRLdU4V1V/fDcj5GAEmKG1hcuOflD8jjWiziSXNT4MjWDK?=
 =?us-ascii?Q?DgnzlcVBU6E0DxS6dSSTtsssbMqj0GteqkNnJ6nJTl1jQp6Hm432YRSd5oYF?=
 =?us-ascii?Q?+Kfq1GuhgFU0WTQXDneOjXNY2Hyh4K4MHbSu+VGs6ASQjuyjA7dien44H1ml?=
 =?us-ascii?Q?7X99qWH/M+cZd3QE14PRD7iDbQ9j8NtngHJ52zusho5zyd3xwEpdBUiJY8Wo?=
 =?us-ascii?Q?GUNhRvKCN7D4COA1EZ0pUZVK8x9sFxtGKqMj44tUxLGZaO9FOMzy6+HBnQaV?=
 =?us-ascii?Q?33KN791v3Bash2ginolekiJxr0rxTZx3wfb9RJoD+BqKFSgED+bcZNR0kn9O?=
 =?us-ascii?Q?1EHj8RFKStWLJkw4zFD8IJ4qrsdW6wk+MAQo4y6v0m6QiPUMrs+eAWbszYV/?=
 =?us-ascii?Q?tsJV87hlSHc/DXjotwFB5tJFQsGBJcOaf4eWJUXlNYRujBwTjOY8B/PQ3QYf?=
 =?us-ascii?Q?Sk1KuP7KUrqhSYlO1c9NGeli7cEWk+ZRzkTcZdFK8pIlf2d28qa5ZT2GF0r1?=
 =?us-ascii?Q?JOy2ZYKa4p3rMhmkJK5JCcOsHT4Dr2LbImi0xAqKeoIUxnCh7OwtWRxEIyQm?=
 =?us-ascii?Q?VNs1IzYRZVnMN5fChiHQQZLG9zqFKj3YuQl1Ium2FmOBingLhyfBfvjteWzi?=
 =?us-ascii?Q?wUWKD8/SnIZK8whR23iiWfajTqs3OQOEbEX7dz8EeqKHrz9wUEjkHURZLT7D?=
 =?us-ascii?Q?K35NEiXoXAqc0EcDhikhXAomxfp8/6P5i77yn5Doy4w8ygkYQO9eSLbilaYr?=
 =?us-ascii?Q?GJ6Q4TR8dPFCTs4qU4Kd+9+xA4XlQioVnNX2aL3Id8Kvf+NfjbcSfQb6OMsI?=
 =?us-ascii?Q?K8m9x/xjfVR5/CFH1vvYnxLFKYZ/59iqqH/Bw496x0aC0FxLQC3WnGoLC6OP?=
 =?us-ascii?Q?7sE4nGfJ8SIr86atGODrbrIke1XEWpK1z8sO/M7ySiEparK4BBa5jKOG9wft?=
 =?us-ascii?Q?yD3aAihkhmqJYjDParoTfXCiVbPwwB7fv/nOqdapnOJAt+I17hxGop3jrwOj?=
 =?us-ascii?Q?IVH5dL8AidG0UAUs/YXxRWonHDmGrMfMuTvX3bH0OeNtcRqpt+7cWgXe7KEC?=
 =?us-ascii?Q?p3WDX7l4ovLDZ76JwaxdVSUPrzg4k+63UmekjdE2Qha2Ia9njC7d2B8huqVk?=
 =?us-ascii?Q?4rDqaCFixw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144f8d82-de83-45a5-b979-08deaf6aa99e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 14:36:18.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X2+O61LlwceJBUqjQngtc7YNxWmnkLijbURx3td1dduFmn2E3wceDdi2Ty48Ait7I85QJwSG5x5ZMNuA46AbeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C603120002
X-Rspamd-Server: rspam04
X-Stat-Signature: xi4fypzb63z9r579j6y5op8zoq7wwwn1
X-HE-Tag: 1778510183-505726
X-HE-Meta: U2FsdGVkX1+fXPmbJ50sn9kpv5yMrdidcUVQjy8MhUqDUG4Mw0til1SnK6SQTjHavaNAVDXbzek1RHKqZK5OaBvlTwpDMIpcaoneG5xng+jE9ybS/dvJXnao0Lylld+p4/rn93fXtpFmIXH3O6GgaHPJKAUCj15D9GKmuAof2fYOR3M3iLYFvcDZDlkbJ25CiCIC6uq/SiFOfaR6wyex10cO9OMWRPx81b7ONRwj1y8XUm1VH6L4GGN1ShWZ+SvM4ojcmHEV2I38W0toWFIWvcUd4DJ/sYzk20bLYyAMgKJkdMAUyXoCTc0nMAkQpBD09qJSjKmgGdYJZfK33K4DMsgKPEmvKkrS/YrwSXtwNhgKIk+MEWs4z3LAMYGlNUp2cBtCBIcW6ausGbnpuZ8JPJadWiOMHsqjTDQRXr8OH0LXLP5AfAF5xi6663b1IQptEv0v73wa5FIX8kDwbQ3GMLWW99s8xSRdSGqC2PZDRJQILxldNJDBGykJxcUC67C5I43x8kscRYHaQN7qvandgpFuCcwaCTOd/eFpJ9D9iYj2aZjuvwSPzr+tqFxGmoh/HVp85vsaKOJ9nS85x0xsIh7HuY3mhqUyiehODY9khTQKEToJLMIzTcCrFdwHFIX6zFODSaSDRLqSDIyXaONXIOzo4nVKRBTLQBLw4u4dC+HiDdYAXGkcqM95BPujZvx6XEVtX7ixXeoycbRuNGDlmv0vcL4z9U7wbyC0x2AG+ThRJv0va2v3v7lrIgCoHOfmTI8Uy5a8JocC0c7RuIKzaerJ9id7djyZYzRLWO0/oc3/2iLxB/xfTWeJh7Ux18huJQD8u5Pgd5u/KPfUqci5Dp6Y8uhu0gYxObruaP/8QTTHU9NCRyWmFDB1pLJQbrnebnsNimMe6XMMnsg1EuNL6KuWJulZowPI3fGCNKYz9oIQCkDwdCB+ILu7UfuUgBZxJVE7U5Jz8TavmfCNVDF
 +ARZ/cFj
 HbNaECo4gE4Ah6QOiPOLn2O71kay9H9RM52jkZPc9YKxkKVaFj6xDCx0m8l1tPCcJoDHQuIFbp/g5HR+YAAfVcUyzo1pelYLgrli7L2nz9EbGGF7ODmDKpm743NJ9GVjqvfKIcIViJBDjuKOasA8HduDWqmwbV+8nPmwta0bzytjL0UzJeWLlj//aKc/+EC2uKODA/DmFaXc4VXyYEN3yNLnZcckvKYZrJ2VWI9y/fmHdQHJf3ZaMIoT9pV6c/3Z4qFiNLCO1hcGjiKIo0M/+fdHniC20fRKdrV7IJn9OEjwOfCvseulhPHt7gJSpwgPj7HDiVga3h4rXZvirZ8bS0PX3Yn3sVUln0UXJIQoGdZz1Q90V0bI1EGLCw2OXvoc+6n2vhFHXyHD2Lu0IUf5xERsADjcNt+5nv0HOwWxRyqDBZINzWwCFvIC0nsEyj1i2ZTSYVPuBJC4wJTag+EQn6T194HBpZihkN8nNVGxMvUqM34Br1aEhRoRSKzJEgUmBxiJaN9VUEmvVwNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The C maple_tree struct contains a *mut c_void, which prevents Rust from
auto-deriving Send/Sync. Following is an example error message when using
MapleTree in nova-core's Vmm.

This propagates up through MapleTreeAlloc to Vmm, BarUser, Gpu, and NovaCore,
causing NovaCore to fail the Send bound required by pci::Driver:

  error[E0277]: `*mut c_void` cannot be sent between threads safely
      --> drivers/gpu/nova-core/driver.rs:77:22
       |
  77   | impl pci::Driver for NovaCore {
       |                      ^^^^^^^^ `*mut c_void` cannot be sent between threads safely
       |
       = help: within `MapleTreeAlloc<()>`, the trait `Send` is not implemented for `*mut c_void`
  note: required because it appears within the type `kernel::bindings::maple_tree`
  note: required because it appears within the type `Opaque<kernel::bindings::maple_tree>`
  note: required because it appears within the type `MapleTree<()>`
  note: required because it appears within the type `MapleTreeAlloc<()>`
       = note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to implement `Send`
  note: required because it appears within the type `core::pin::Pin<Box<MapleTreeAlloc<()>, Kmalloc>>`
  note: required because it appears within the type `Vmm`
  note: required because it appears within the type `BarUser`
  note: required because it appears within the type `Gpu`
  note: required because it appears within the type `NovaCore`
  note: required by a bound in `kernel::pci::Driver`
      --> rust/kernel/pci.rs:294:19

Implement Send and Sync for MapleTree. The tree contains no thread-local
state, and all shared access goes through the internal ma_lock spinlock.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
---
v2->v3: Added tags.
v1->v2: Address Gary's comments about the comments.

 rust/kernel/maple_tree.rs | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 265d6396a78a..74cfd5c0fb2a 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -16,7 +16,11 @@
     alloc::Flags,
     error::to_result,
     prelude::*,
-    types::{ForeignOwnable, Opaque},
+    types::{
+        ForeignOwnable,
+        NotThreadSafe,
+        Opaque, //
+    },
 };
 
 /// A maple tree optimized for storing non-overlapping ranges.
@@ -240,7 +244,10 @@ pub fn lock(&self) -> MapleGuard<'_, T> {
         unsafe { bindings::spin_lock(self.ma_lock()) };
 
         // INVARIANT: We just took the spinlock.
-        MapleGuard(self)
+        MapleGuard {
+            tree: self,
+            _not_send: NotThreadSafe,
+        }
     }
 
     #[inline]
@@ -302,19 +309,30 @@ fn drop(mut self: Pin<&mut Self>) {
     }
 }
 
+// SAFETY: `MapleTree<T>` is `Send` if `T` is `Send` because `MapleTree` owns its elements.
+unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
+
+// SAFETY: `&MapleTree<T>` never hands out `&T`; all entry access is serialized
+// by `ma_lock` or `&mut Guard`, so `T: Send` suffices (`T: Sync` not required).
+unsafe impl<T: ForeignOwnable + Send> Sync for MapleTree<T> {}
+
 /// A reference to a [`MapleTree`] that owns the inner lock.
 ///
 /// # Invariants
 ///
 /// This guard owns the inner spinlock.
 #[must_use = "if unused, the lock will be immediately unlocked"]
-pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
+pub struct MapleGuard<'tree, T: ForeignOwnable> {
+    tree: &'tree MapleTree<T>,
+    // A held spinlock must be released on the same CPU that acquired it.
+    _not_send: NotThreadSafe,
+}
 
 impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
     #[inline]
     fn drop(&mut self) {
         // SAFETY: By the type invariants, we hold this spinlock.
-        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
+        unsafe { bindings::spin_unlock(self.tree.ma_lock()) };
     }
 }
 
@@ -323,7 +341,7 @@ impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
     pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
         // SAFETY: The `MaState` borrows this `MapleGuard`, so it can also borrow the `MapleGuard`s
         // read/write permissions to the maple tree.
-        unsafe { MaState::new_raw(self.0, first, end) }
+        unsafe { MaState::new_raw(self.tree, first, end) }
     }
 
     /// Load the value at the given index.
@@ -375,7 +393,7 @@ pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
     #[inline]
     pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
         // SAFETY: `self.tree` contains a valid maple tree.
-        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
+        let ret = unsafe { bindings::mtree_load(self.tree.tree.get(), index) };
         if ret.is_null() {
             return None;
         }
-- 
2.34.1



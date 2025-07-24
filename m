Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19852C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38726B0257; Thu, 24 Jul 2025 04:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1F36B0258; Thu, 24 Jul 2025 04:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A99E6B0259; Thu, 24 Jul 2025 04:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3FA6B0257
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:48:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F03C160247
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:48:58 +0000 (UTC)
X-FDA: 83698533156.03.E42138F
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013034.outbound.protection.outlook.com [52.101.127.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A14D180004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:48:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=D7drhvkq;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf24.hostedemail.com: domain of link@vivo.com designates 52.101.127.34 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5wtyTBDpuAGN8oAcnPrIIqyr32bmkuPgplcfTwT3i8=;
	b=x5rAOKsEADqODmcILxyn85Fiv5vRfmc6O84EuPkURWY1WgfLXFI+sclQbgGX1Fw0c5HZeI
	Wiws7/za8a6j5ZJqjI6UnN96MaXDbBSIYAJPSS1kLP24Obk6HENzelrpDVTd19rAhw4a2u
	javfRxgN1peTsqEGOl9HC4tiVG7rBFU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346935; a=rsa-sha256;
	cv=pass;
	b=HQdi5ESJXF4X2lyu7/krs7w3BBl8Can1jmfrqqY5DAWQJl995k3l8PmBsoG6FcsaJnlNxn
	/3iOXZPxXZtmQ5FsChw4zH6/7/4A1/70/Q45WmfL8ClYDyo4vNnPWIz5WSVFkOyQM9uKuv
	P7IaqGZKjAbzheH6O2//yM9jWCpPYqw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=D7drhvkq;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf24.hostedemail.com: domain of link@vivo.com designates 52.101.127.34 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPXhluA6rOleEIVv+/7OEoOhbiZArW3W6DbqQeagxAMVKdmFSh4hquavbU5gBoiK335BL1iVJGLOuKzqgPZb/BP53Cx9S/YW3+2LakruCENmRgbB4KCU9oqmOFliNu+iJRcp3uKT5SFUfNxz+/HbBA1nKHrtbKHKGLZAh364jaX/BPCY+uCKFp2xBHvFIsKR5ZR6Vj6uNJF5VGXKWLzsWyrOUu/FonpVYNll/lAAFthtIfPK9v59UOtwumkSuho/d+48HzRts+dOx8drIqs3Xy4RuNj1zqfOs4V8qq86O+mq/yx5QuG0VhpTnySdm3W6GDhtsNv1hqjGVOTbAOxrtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5wtyTBDpuAGN8oAcnPrIIqyr32bmkuPgplcfTwT3i8=;
 b=nXcb0FGKZKRd2AZ7nYS1xvfFgySUYuLT1f197UyjPycdYX8c0PKHQQuW5UWKIqnEPawOPvf8oeIXwQQ2JMqsbdCUAVP0sxrpShGUqIEx55qosY4zo8Y6yj7HVytZhUKBZahoSXc1OF/Ghqamp6DGGO8zMQkNoGTTwB3/cGWW6bhsKX6l1bzKfLuBGM5XfhBWUfQAWrgHjCG6zYvEaVhZc+qFNWPgLM8CBn+X9mTQr+Qi1WnRUfZVy5RyPBp2nBwkWYGihHDFLnFhBKoLvmeUoIocrACVu+br72LcjZXVnvb/+Luv6ZGVEWQqp2tsr9oh4GuHbvBG49l5CCQLP2I6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5wtyTBDpuAGN8oAcnPrIIqyr32bmkuPgplcfTwT3i8=;
 b=D7drhvkqCIIZkEFPZK8gQ3ZWMZMfrgBQvD5tEJqOkUm2GP63Pc4agK/czJkoH/e7e4xO8g3/in36zEdKi7pKdg4ldNZqHT3Gdes43li1YhH3Ml9nOaeGPknigH9OkqwlVoT0z3IJH90h8poCWEnHnKUVMYJnnbqLZW7v0WzBlqBxj0O+ItzlsYm9A5/gDManrfWjdtf46A0JLLUHzmN3Hg+bGeWpkeQT5QfsRJ6CwG8f7UuQrGdp+22VlbTy/rSQOEOnbKIbwPWvCvBU/npl3UhHmTrOhJa3ziq0HA3m0Uxyf1V334345peBqqnek1p+VTdQMA8ZzxARKIyoG9Njog==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:46:15 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:46:15 +0000
From: Huan Yang <link@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Huan Yang <link@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC PATCH 6/9] mm/rmap: introduce migrate_walk_arg
Date: Thu, 24 Jul 2025 16:44:34 +0800
Message-Id: <20250724084441.380404-7-link@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724084441.380404-1-link@vivo.com>
References: <20250724084441.380404-1-link@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::16) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|PS1PPF2A261C07C:EE_
X-MS-Office365-Filtering-Correlation-Id: 95dbd8e8-d89b-47e1-a113-08ddca8e8ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LHjnWUn5RMeGaYlqsmjPsnxKivWCEQIXlsrjz8CJmF8CSmyDZyfN2pFt8Urn?=
 =?us-ascii?Q?GhrBVuORj2554GGjIBWdHYSN8GhoGS7QfIgtu5Z2lCQgyMUnPI+J199Bjn9E?=
 =?us-ascii?Q?qeXixvS0M1dEKEhhCXu5LT5Yc+TCso96bYwnGuqoTfC2OwqUa/qncGR1DXvR?=
 =?us-ascii?Q?IvHSUi/s6iV7aAdUIwGIwawgOAeh7vSA/VCNMl31OGa7Jfr3wNRsz4+d2bDC?=
 =?us-ascii?Q?23pNhVhML+nMlsu9KFomd3Ok8Bvn+GDESl+xEnfbv/T9A2kZeGS/Dsh/NQEo?=
 =?us-ascii?Q?4GZPoGSxCWrAL18nouWkcNvsUhqDFbGwbWr+sm27Bk/otWGTVDcsGn9lLczB?=
 =?us-ascii?Q?IOYXu8VHWUHqkXmTIxTNUKtHyzE5dzjySGFBeA33IIa68DXzQnoIYkKetnMC?=
 =?us-ascii?Q?uD4Od4avXYajzHs65UFlKQND4UcCkDsCmcwBsYpwrZG3hIDf6oJlwF1+y3FH?=
 =?us-ascii?Q?5Sk1iJKIVPLGx/9yJ9K1p40xogRoIl1LCgbuenTJvZ3BCMRZa2proLVIuMjE?=
 =?us-ascii?Q?rsuiZgYbdL8slsEV+yEotTdO7KhTQfsBkKSG8OzDH37BYJd+RxLXACbk7CDv?=
 =?us-ascii?Q?BHBIOJ6J/1HZ1uplgg1KSPKhvwLryyAhPElgwU0FP48y54ZRxSISZeWSyv8L?=
 =?us-ascii?Q?xo7AMhznRE9swORImJwsDlSlOPfp+clbgnHU0iOZ+HKtjBEgK14oD8rMLHOX?=
 =?us-ascii?Q?Q8PnUbtRE5pyK33bm9Z/T4D3Tls0Yh++q79YCXHSoqTGZxIE+ENHESMNft50?=
 =?us-ascii?Q?yeuWbeqXkci9gJcLbZQaesPgofjXq/oYthiTRJj/ct/t0e2AS+62qaD4cJwg?=
 =?us-ascii?Q?tgA8/zv6bugvjrVNNZSi4llj18vfcWQv4PQtPRn1MxG+b/js/JFjKlh7qT7T?=
 =?us-ascii?Q?PZxDwScH9vT3Z0DJugzDXK42DYow73UqcKdT7kM987lOCuH9sprwy2Kai4j1?=
 =?us-ascii?Q?qF6zmmih/9uguRWIFZ7/yFjiRpfCP3hH8zTRmIUbyH+0JQfDSuY/T6S45rzU?=
 =?us-ascii?Q?pZI+6J4V7dqv6hLcpW108kc5iC/1Np2lG1CGApr47sd1xjacpY0t5JYrMTSZ?=
 =?us-ascii?Q?GXi4OO+HyZFKBbqH4ei4TEfop24U0Un2BlEc6L/KxaHl63VEQS+L4wB+TLqp?=
 =?us-ascii?Q?JNKZm5qF3CDx6ipcujizWXGUzKSZpbBDRyuC0O3jWSAI+3CAlSgPDCrRIUsE?=
 =?us-ascii?Q?zZqtdp38c6widQAalSw7LhszlJdWX/sj3QAvED1RpyiaMi0TKgInmQGDkQzI?=
 =?us-ascii?Q?98BL7Ds32WKJKMM/vjfgPXp/nS53EGXFJBUuDlOzrYUA3zqe638/CAhQBoRz?=
 =?us-ascii?Q?HcaAay+WBYSHnQCyzy8rKd250/lz8AMmv3xCMTj5mV3y97wO6ukbwBP+qAsF?=
 =?us-ascii?Q?wufS2ZYkqOwAFapKz+Qlp4/7GCtuyqjyJ9bpqQCX4dZq6BhADlTA51tmlXa2?=
 =?us-ascii?Q?3yIyBtasi0iVjGptoiwx6pnx/Y2+R9VYfXYCvk8Wd3p60u2KYZTrqRAcaQii?=
 =?us-ascii?Q?oKvEi+oxU5dMTsA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lQo4rC/Trp63SJ2iQlUX26W6+cCUJhhkp6VSiXEycQKn3k70ODIvxuZ8yBvE?=
 =?us-ascii?Q?uMW4aRtCjwf819IOlqO6+dKla6tt3peNLVW9OlokBXBJMrQk4shHEyyVq4LK?=
 =?us-ascii?Q?JkI0hLiNEvHwiPZYjMPK+m++7otFuXFt2kfBpTT24eKLWT0yLzzZ2EIHPM0d?=
 =?us-ascii?Q?sQ9iM6tJaYrqtHAyEKTKxID5bNtHWYlLWz/ewN0/b3DaVoUPKFr4o7MCCUJi?=
 =?us-ascii?Q?yqX5Y8Q1qXL2xrH1PhHGRnfETo+M/K1F/Ku/AYOpsPHVdzqXH9noSzb4MDXM?=
 =?us-ascii?Q?m9BjcV268Lsjy9ELZ2bGbXv+JbpjT17O3zCFAwRVaEdccjZiejFcXRDchtcb?=
 =?us-ascii?Q?CDZymzDERpbVAxKkTbldM/1lzTeIMSuXDYf5GgoTkVoTqqGrK2hIAFrk/eKa?=
 =?us-ascii?Q?cF1LJE+UX1GftCX87KfhRVCNIjE14bkQATVxT7pSrc7zkG5XlMgssmfoLK+L?=
 =?us-ascii?Q?DMKFVNdsvaNxizu9YWMp5ObG5kMEZuhPyl7zxYanxLxoDtBejNxvys4m4Vuj?=
 =?us-ascii?Q?s1CS1XMegLXYNc10KV6x8OwNWT9a5zoRaecq3GUwMjSq6dsr0OP4TpGvL3Np?=
 =?us-ascii?Q?BRBY/a+vzmvjQ2JeqRd23Txl9F7SDzVlBcHxnQEIBmLH6zZqMHTuum3cQLjy?=
 =?us-ascii?Q?PoRjc0vrjfQZqyrzvz8zSI1mV0Epe4nBeMa82Em9d79Y8qzEkSsLzgTwLV4z?=
 =?us-ascii?Q?5X4ix9CG5y9QR8NJokkqazZvyUR0zZyewdrJGq/rl3kQuE5Thiq/iqTbwunG?=
 =?us-ascii?Q?LpN4mDs65QdcpibY21Xy86VxsihAfOi9r2La80voeDlJXUTSPJU8moJJjD01?=
 =?us-ascii?Q?VEaprN3VgxghT2+TbLYgs9m97V/VyGcrqcLYV1RxEIbNKRSm3kpF3kiYDTE7?=
 =?us-ascii?Q?NIaROIrl+uJDgww/POjTNPkXAFnzQO2sL7rQvvJuWlGytNk+lv/EogwmJzoA?=
 =?us-ascii?Q?tXIkYThISC+EeVvfnAEXIEeGoJTO2GDRIesuirP9SCXu/v+hVtdzma0XWTyt?=
 =?us-ascii?Q?ACbhz4rHHUjISFtCBgCOpISh2z+MPBQD3aE5wCsCSOUIDfU5HThjI5tFtZPg?=
 =?us-ascii?Q?K0WW4LlL23A/sfbXqK5lXGtilgh5k85kTx1BQ91tysud5fNj5EOfjFgyZ5uD?=
 =?us-ascii?Q?uoBRRBRe3NT/kgKavh9Z6QE9YpC0Eylz5Pvf40LDyq4qVNUPUp9NzT3PIyl3?=
 =?us-ascii?Q?Dy0RyVpcVVDzvcEudkxR7ITfbttz9uo2GJA5l7X0adBxS3edtX4/meDsFKOG?=
 =?us-ascii?Q?5vSmCFltSdjNDBS9udynv+NHGVYn1pNBBEM4ieEHP57ETa5XJ8PihGhMdSH+?=
 =?us-ascii?Q?bm7B+bWuKaq193zhaVS3AtAdQ3LD4ZPBYRlv5cfXwI1xkMMV8MXB3WnDGDK/?=
 =?us-ascii?Q?0PBluIEAEIj2eoHK1IVTmTw7ajELXHEoSpaIkS30rE8r5tCUhlWnWdbsgzCu?=
 =?us-ascii?Q?abtpB2vlkp5Gvm/xwlVJf4kJZCEm893ic98EBl1tbgyEG+VqMQrLIjsM709J?=
 =?us-ascii?Q?Ff84JnyMxnulyiVt+CM+gmwfdEw8RYzo3l6t9e6/vJ5GAzstlTLUUz88A0WM?=
 =?us-ascii?Q?cpGNEqc6+r/oRKIXHa3oOd1MlTrS82thKPcXO15o?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dbd8e8-d89b-47e1-a113-08ddca8e8ca3
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:46:15.2081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bmh0JuZiUiUeb6p/W7hO2rsnxDnHWo5jizMgg62toXVINuZ9KbIY+hQ+5erdMuCYwJCl0JmfrCCXYcO2RmvqbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Stat-Signature: f83mx9x4y186t8f46bi46pwwa9cq1eoi
X-Rspamd-Queue-Id: 4A14D180004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753346934-854327
X-HE-Meta: U2FsdGVkX1/v7ZC+2cqJxeCyA1CmlhLnxUYIqN2tpGDpagXGKk8tZx5VEcQCMyws6qfknDL4lerRMlgK5G6ecxD+f0iWGeoOXCZxRL8IfA2YdiH2Xl9JluhcsFbSmT9Pk0JONG33SW1WNvl0PDG/263tIcQjBGZXXhCtj5bzcmxI88VTfQWte5zGN6jb1/5+5j3v4MrEjVJYDllTilC+N4Oois0GZc7Z35iOG1fwtQPjlXp3aVSVpsgKjAWF3RKTXxiPgzy05le2GThIS44iPg/yQ0Lb8OSBvCY3rfpG3sIwGmtmX87mA0ahE0Of8i8DHptrXjrWLPM1X8tCNgHiFeoF9rcVaiFC7VDsZN9/0owG/RqW/TjO1fcKlhOSuOUjkFX14fCI8Khszh9Iw/ksLoRNmTljBS61bRZ7PJSf1ZKrW9GfEze1fJwhF2+qFc3cf/CE+jFHW4I2+2d+u++TLuCziMMk++qtcIJVB4nzaCpTnVdRarSxFUztkEUFeuG3KrHs7e7y33+tFGN5qJDQm9BM4XkbeFvO1XHDE3HGwXosCUYU1I6KXKBOmt3yMwZUxomYApnOs60EWpCGhXFBS6eoMXKjsGrBn5fhqXs+Yy2oMmmaIZDjpUy7jFFu9d9HjvSTrvyT0Ezkwp/1ylAfTwatZs49ZnJ11G02HYy9ovE33Z2IYbqed7KuZNAAF7vFcZMfzv81a/jybAzZg4uVvH8rEfxwguVmwokGQFBI0C86Picx5nqikIZT5DfyXLGBHiRK3sIEt1ktFKEArSJHfmOxBuVsmKrpfLqmDwKxvp/pFcrgUB68h/ChRPWUpFXzNkgHKNYRbWfx5RXN/fK0uxySxW26xHW2v7v/yx9582tOziBJb18PO/qs3OMsoP4ABtoZYu9Gn+2CiybfxGG72Pt54yZxvYOMgBHNHsueKxWRJYHn4W89V+PwC4KPo8grFGvumO0OT5jEnrnocKQ
 VCXFmubB
 y1HON7wl9Sf8PhbwwZCT4zDnPP/QWciQ2LSzcymZ/uTD6p2otCbzEh5RQlKiBF7JcwR6IsP0kj6J3/niCbgUQGbaTc6B94SjN2sz5YMSyoPXfhea4SCkrQyozOKeU6GlnvVnI9rGBfeMpGxi9Iw50F/Pvf/rY5v0X07Q7dbCGv/qfII/ykhLWCIj83eY9nbc1ggKMsFjUUmNMGoRp7wz9uZMZD3FoG+CGNcyu8ZAted0mCKmS2vnb2aDU28hoOxPUmoN/IxRo39EPgePQA+QBaHIUoOLPNr/t1qzFw/gAJKJaTczkaDQQDYKbcCm4v2f1QNFtVYF81UZuJpIPWIftncKzPOPMWh2sgv1kYWAKoG6XPONnqprA8qAHshQD50++iP3hlG5ypka3F7V2446o5jri/KsNiFHMHVFhAcbgHRqoMFxs3Ny+v2GC6Qe8G1fugtShw560ZiosyfQnKgYT9YMBhndPY19bI/TTfdLdcQRQGTmMNVjNsyFOkY8q6GYV5krYZU41IMOP3HmL5AZi7jyrfmiNCNM6iw7Pmusqtz3fsVg0Yzw8lpV5LWMazgHFxL4SzyVwbnXiYdjRZ2+RJmxKPMEgRagbtN4V+Ywr5XbM8LCLKO8OjWrynRFyMy6htbAoSNTCxFzwhVDdARZ6ECtaXnYw0dW02HyH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_to_migrate, rmap_one as well as the done and exit hooks may
require more information from try_to_migrate to assist in performing
migration-related operations.

This patch introduces a new migrate_walk_arg structure to serve as
the arg parameter for rmap_walk_control in try_to_migrate.

Signed-off-by: Huan Yang <link@vivo.com>
---
 mm/rmap.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 66b48ab192f5..2433e12c131d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2261,6 +2261,10 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 	rmap_walk(folio, &rwc);
 }
 
+struct migrate_walk_arg {
+	enum ttu_flags flags;
+};
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2276,7 +2280,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
-	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	struct migrate_walk_arg *mwa = (struct migrate_walk_arg *)arg;
+	enum ttu_flags flags = mwa->flags;
 	unsigned long pfn;
 	unsigned long hsz = 0;
 
@@ -2575,9 +2580,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
  */
 void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 {
+	struct migrate_walk_arg arg = {
+		.flags = flags,
+	};
+
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_migrate_one,
-		.arg = (void *)flags,
+		.arg = (void *)&arg,
 		.done = folio_not_mapped,
 		.locked = flags & TTU_RMAP_LOCKED,
 		.anon_lock = folio_lock_anon_vma_read,
-- 
2.34.1



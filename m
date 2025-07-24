Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1BEC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B16D6B0168; Thu, 24 Jul 2025 04:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588DD6B016A; Thu, 24 Jul 2025 04:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4517A6B016B; Thu, 24 Jul 2025 04:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35A226B0168
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:47:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DF891DA1F3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:42 +0000 (UTC)
X-FDA: 83698529964.02.DC53CE7
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013046.outbound.protection.outlook.com [52.101.127.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4BCD8C000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=MHig1tkN;
	spf=pass (imf10.hostedemail.com: domain of link@vivo.com designates 52.101.127.46 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2Dq90EgzDzKGh7Zr8kmf6dOAjvyPb8DO2vog7rCgno=;
	b=CQ8QKJxwLUYJM5b8YIfgIFs4lU1ir8P1Ietn9bgYAVy9MmgBhN4FzhDJ9yFCJrh4d5uvfy
	Oketj2p3gQ7ozWaKGuLH3etrbLZFtD0Gnl7iUgWl/7Xnvo/TN05NUvevMgDgDme9aaozXT
	qwqDduwOWpf4MkVEmdttOfeF+zUORRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346859; a=rsa-sha256;
	cv=pass;
	b=wTku3zBPMs0Px5MBE4iIJSWNTI6xgYuExo7aPmoERpKywczK1yLbCWF4N5lAWtfgwTGlVk
	3jiKslBqw69VDwdQBP5nYXmOIMfQssZ89PQVvQb3/1FbZBZQ3l4ATSv7moK4S+Iy6gWCE+
	3l4UH34a5VXxLR9Pa0LqrRv+71m4AK0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=MHig1tkN;
	spf=pass (imf10.hostedemail.com: domain of link@vivo.com designates 52.101.127.46 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiOROehli7+/U2bTFBQ5hBEqiGwAuM/qVqo9qTjO1VT6/rz2hUULWLEZXeHEJOm0v4yhlc0NRm6Rtu70Qn1N4u8Q5YOA2Wk+uFCU2Wo76EDnKzCxLIgm2LZHLPIQFRKd5dnpu4j+tg/m2AgOgw8s7gd5qydOcFJ81z9EtGLG5Q01pcg4/lqBM7etLpPGjgek42lFILd/s49uqBgoqjt31rupxkcDa1eTaNNXxUQknlEC2C83mO3RXc+z+90g9qS+dGdyCAAGFE3CMBTxyhhCmj3m+dhh+8mu5i7EFX2Dxmew8wkLPkS6yCDyZBqrbfsMTiFvCvblJg/lNbP+9yVkbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2Dq90EgzDzKGh7Zr8kmf6dOAjvyPb8DO2vog7rCgno=;
 b=NAliPpJeyaw+JGL74f5VituZ2jgd5kkfxQ1od2fdsENDy3JjoqhTozS+Ubgu516xt8qnNuExu/A1tvDbGWKY6KOQuZesVfAU9r6nCtiTST4gH6mzHTxto3w6vkw8B9e8eoQS4Xsj8+rYimZRPFi5fiQmFiEqKUXAmHWFe+kkCLdQP4yD0AjDnXMsAUfx62EdBfZTpStgg72UW3Fj63MjomlOBoOrej12jIRHB8yOgHgNXnm/jqNZGEG10h/xQrouPDTJiMhXu85Cc+WOckYAWbdUmc8WS8bPfXvLe+LUnsDc0cVaGA9A8aH5pmIlOxWbcG4qjPED8bgKq0PLpkfWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2Dq90EgzDzKGh7Zr8kmf6dOAjvyPb8DO2vog7rCgno=;
 b=MHig1tkNLeXk7AA4MJTTKAfgMwAw2n+KLu4FFLA91nrvS5q8MVAXj0e56UqBS3Z+NeoRqqui/PvYSQ1y1PpeU3ZwOxF9Mulgv2aQ4oksW5ZLqjE0iGQ/ddN9mdhGDJgj+/9KaJIE1Q3HgPCia2E+yaS3ef4Sqmd191F/pPObjxB1q9PfL6PyQGnl76S2eMygOotrOFNKajPgTHR2KgLSYT5hAWd0iw8Rl7beKgpO0b9xuVc1VCsI500VBG1DjuWVzG/iiDjTZVGnC+9TRTMjqir5AmqFafgMNCf4DuYblll3beH+HmAJ3fV3OK9H8XWnXwIQAssqc91KddX9KodgLQ==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:45:46 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:45:46 +0000
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
Subject: [RFC PATCH 1/9] mm: introduce PAGE_TYPE_SHIFT
Date: Thu, 24 Jul 2025 16:44:29 +0800
Message-Id: <20250724084441.380404-2-link@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4c575e92-59c6-45f1-75c2-08ddca8e7b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iQhyJZD/LnzlJNoQixYXlsYxdKmyjgI6YuC1Bs4a/rxHuV89MzjrgIPTPTa9?=
 =?us-ascii?Q?de7DSoVdLMj7xrH1GgaceDQRUzJVapzKews2570vK7sYPk6LZL16vnLdrCj5?=
 =?us-ascii?Q?Rc49M7nh2+mtJD+1xDTsFxQcJFkMTgWhlzx4jH+ZmLdHIbT6GWjWJ5e2IdbT?=
 =?us-ascii?Q?5vOybkkER7ziOVMwaG+T0dCnFFiOQTW/97TKxYIEp8U4dflAFzxH1m00SQVm?=
 =?us-ascii?Q?Zp0QrxeNoxgMyWWUjwomQnEe8uPCMqwZKQfAXcpH7vb3RzN0z/ow1gTrX3tQ?=
 =?us-ascii?Q?tqbt8KyXAZktc+V9T9kbHf++4ErFKzneP7EmQmNugdqL9plgSmq2P6TRHgN9?=
 =?us-ascii?Q?/0vbyPhV41Cm5ilUGgVRKVf9c9sMfmlWqeLZm/w/T477gKrMQ9E+k5lqsbPU?=
 =?us-ascii?Q?c9nmRUr61W0dTV4ydDJlbvIXkCS1VQAmrABDZezrj9z5KBkWnPmx3AsuG8o7?=
 =?us-ascii?Q?evc3bHwFRLkNg7b/dGPLF8a5Onerd0qeErp8M6PX2Z5tV7m+WzUNuuj4ltF5?=
 =?us-ascii?Q?yNBfreiS5MJGbreLZKcxASl0kBjLxnDaU1QWaIkHaxG0xdwQnTR8+RdhsD1q?=
 =?us-ascii?Q?oGwzPcX4CGUZfpYXi4zIgUfHofuku+Z3b+r+qse02KgvYtERSRmM6g0vCwKO?=
 =?us-ascii?Q?PlvdTZd/5VK6MCVIZ7EVbFBfBHf5bF0PUCaNSbmMw8QYcj3qLCqp2K+MN1qP?=
 =?us-ascii?Q?tsFm67ydczUW3qXIqEFKxfkcOdRfRFpRfK6q6R5r/ewadzJRjisbtwo7bDbi?=
 =?us-ascii?Q?bEkkFuvi0Jig0aDPyuYA+RApeinwAFvGaL27M549Ds0SyG1GJZKMG3EKKag8?=
 =?us-ascii?Q?cjSwcWC+wy5vtmHRba8ohwJEyjpRJ0zTBzC+YLMiM8ZVAxPpXa/zG6d13ewW?=
 =?us-ascii?Q?ZXeIFfnsqaSuv+lxzcg072DXOlMbaCE206CpeqpisKKnmo0Lwg3cT4+vE9W1?=
 =?us-ascii?Q?yHeCoqzkB362cNmQ3W8NFUlAS0DPjrqBMA1jdR0dM3dcPnT0ZGikOOWtJeWB?=
 =?us-ascii?Q?CZ7MMYt3jFm7DXOho3ctjjwS7fS5llE0EaPQM7pKsEczL4fU7xnjz/DhN+Yh?=
 =?us-ascii?Q?YzRww9mywPvRikPGKEs+bbrp0W3MKId/AEc2kexN2I2tmUQ4Giv0MMIjV9Kr?=
 =?us-ascii?Q?QqVH86t8v4oV4LcCovF65NRFo8VAg2SktN1CUZbQaLFMj2lm1vUIse9RK5Wk?=
 =?us-ascii?Q?jIk/U1RFxhyA/i2abE+M5L4946f/piyQkZ2euaeVYHCSkOdOWKWlPsH3HySk?=
 =?us-ascii?Q?mGNiV5I3+P+uIsdRW9Y8db4KetQTpVYtMVMxrzrbLDkH1HGd5dDLSTRBpz/3?=
 =?us-ascii?Q?7okyAQK7LxVj5ILqbcjz8fS50V4hFeWY6eFnzGc8AkZu4S7/xUhjmjmljKfa?=
 =?us-ascii?Q?3hGlI9V7tMLHhQtD07ucXG22hZ9Q46VgxdSwZ4AojNMSyhI024dquzM0axBi?=
 =?us-ascii?Q?rIX2OFejzAFuDrgHcyLobxIKIyHLHcTyNLkb6ZFz7IaQusDeHbZYCfb+bGGz?=
 =?us-ascii?Q?oD4OhNbscdy8b/8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QBuatK691xoAliKuxKLfDYSv/fL9mprG/d1rHK5wF1FSvFsxT6kei93Ye/14?=
 =?us-ascii?Q?AKhw/THRUT8EmTr2+5GZvp1wo/TLC2NPm0Lhgcis4bZQ+ajrr4ochsMnUyut?=
 =?us-ascii?Q?5FoPLdxtSSNajIOG+LwiINYYduKFlwMUYqPX7J8ZnDv+A/Ac4ZRNByN+3mUX?=
 =?us-ascii?Q?QtccdnlTBNbfZwcDRSjBkvjuAvn+LUPbNITAxaHnTcLX0sIhcgrA1JTVsTsa?=
 =?us-ascii?Q?2lD8QfXPbwVR9v8APxTbCFvvLnSc9Xv8lJ0U7AbcnlnbMCyKz6nS/3auYPNi?=
 =?us-ascii?Q?5zmEc1POkdC+8cbN166MjjN8KjGREFPv2rZDNcrSw2ag3g/HJcBhD4JKEQHP?=
 =?us-ascii?Q?+XujtLty1FjBjIHhFcHT9UAaPBojahyqt3knxcg+BP9jTmBq9pEmQqXa+jgB?=
 =?us-ascii?Q?sX0ZbTakcCHxptu1BB+cHMJ8IeYPXEquTLb5Pso6JY9DZj6PSfbZtKSua+Pr?=
 =?us-ascii?Q?Kk7u5YrcF9E9ndv23RUt9aqZPX8gVAW94bPa4gB2HI+0XtdepTfBuk5voaya?=
 =?us-ascii?Q?MoGtU9Ket208jGnoQxextI47uMJ1lcXMgGmp0oJRFe4KqSoD4uoGjaIkDqGm?=
 =?us-ascii?Q?2AXMd+Nt+/2Ob3Nnf7+PYR15cWxhuGGPqY6PsrS/c1rrpXLL8+RACfEYpahV?=
 =?us-ascii?Q?EWoDncP8cLVL2tkWCo6hPE9BGeLNBhIhvVHVAzVW/UdJMEfi3RT5HSM6RoOE?=
 =?us-ascii?Q?2fmzQLkziYp+qNRc46no77oJFoboItvfKaMJ1W+Co/pkbnfUGtRGbcGxKguC?=
 =?us-ascii?Q?vRkXeSRLZIXL9WqHf40b+hBGdtREVeXFXe2AMeHlnAi9e0+dFmexkwaBvLiv?=
 =?us-ascii?Q?erwPqzFYMCbc2LRf94X+8R19UvojYm4kyjhz6c5ctRwgosr8cfoSFEx3BGAb?=
 =?us-ascii?Q?dySWyLdQ9PQHGze/PEbODT10X6eTKbVbcfvEErTNZfOVS1r5oAsYzT9MNUr4?=
 =?us-ascii?Q?NVMFeo4DANYfCq1cst7SqO2AEusgXXFi4NZD/KtzNKFXolMvOQ8mh/NfucCD?=
 =?us-ascii?Q?ZLswXwZbwd0rXVv54YYXD5qVU+l1YXBwRqte7diF+MC75MUCuTcD/7Gtrjc4?=
 =?us-ascii?Q?MYIl0Z7BR/Oc9mQYWRXjLsPwApNo368nVq1oS0Pzs+exgoo3jn4+Yv3hM7y8?=
 =?us-ascii?Q?BRXBrCKehDlNBcvQ6RVZTQ/t4dvwhq65I5WWFueZnEtYB98z5uHrfrWTU5so?=
 =?us-ascii?Q?MfENs3b77uA4anClaFQEpf8dWNtY6mLxr7O6rRrbWpnmyI6to97TuzO79ZLf?=
 =?us-ascii?Q?TwvGNFQTMLP3E2UQqWMWkq5VQcW5zdNKKjhAJjGQLYqZoKF98THAjsn+sUqB?=
 =?us-ascii?Q?XZqlkQ9FyYmmUUGVGn1+e6OqaIAUezPx6PPZmO2gIFfYv+K1F07D06hSeLYG?=
 =?us-ascii?Q?tc90R97gHelu9A3yGPrDeOAyO5PgLCHVfmDLSNBv9fAyHFZH4utQ6xs58lsI?=
 =?us-ascii?Q?fsjaWNYdTx2wGNG3jkNzitSmqwl5KiM6Hgg3uEvItksIRi1/BBQi5a4886Xw?=
 =?us-ascii?Q?vdlavj7pjdNT7C9yxfdSYKxir+tFrQtlRdJqVl/dG5Esv8eHAI/N/xlKhXpJ?=
 =?us-ascii?Q?b9YfnbStTD2sqeaDQwuoONumc1SB1FYWI1sfV5d1?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c575e92-59c6-45f1-75c2-08ddca8e7b37
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:45:45.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qig340DZ5cq6G+bHwFc+daupBAwtCvjC99RTGZYAHCbfTpbO/MUfAV7iwBNlXOmpttltZH5qJFX9YNUGCA5vdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Rspamd-Queue-Id: 4BCD8C000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6pew1acqhfwrpfrhp3hgm9ym1611wxyi
X-HE-Tag: 1753346858-787626
X-HE-Meta: U2FsdGVkX18sg20N17dFPNCOV4VULod6Du41anAdXJ8HJoLPzP19yq/NDjUTnHdwjvGVBL9euO2TcHVyQHozkwxb7ZW4Vjzh50W9Pxb/Nmp2xileLPkLlysfydB4kmJKp21XEZ6XLXTuxj6jMFVzu3NT30JH00TyEe3SWFOckTjZxlnjAcPD+7Za1ppT5mMo7hW1SuMM+YUVPvbvXjfCbOgb3YOXtw8ABs6RpsUV0JiH+o9AuU4X5vqt8X/bGTtNxlDbb6aw+wolrG+gY4tKKSY5WkXiDDwMVK75Qe8dWnQK/yX+t3tm56boAt86IixJIKJWEmJJTJsx+DcgcHrijR83zcYFP2hXBUk2c/CNKyeLPzt7uLSS2Y0u2yUTvcgYJLJVf3CfQy7+5BpKOlLP1jPtdseXZuXJjpYapf7w5AZ5lt9x25fV148dsPBwNeZeeRVuFIgHiJZOnMJQwSI50mjzRBif2WOIu0GTC1A4xXhOgkXaYWsRlaO5UAAKskv4jyAEOTrBmFQ7RpOGHSry8yEnIr3D0hYm223HzAZkGSEzTdX9yLcGX5F+6ErgF2ntwh5UCXpUjKRn6yzgHB3QSfpIRQnJCo5v8G/0IH34rNva5SRhZVx9RqkURiipUPoQ9EBtums4r0Kez8rIOXkfvbLJc30Rg35Wq1iv9Z/vWdBsqruY+3YM45EDUJ0iUfvvtfUHNiCGooImxLPvkj2ub0XjEwShlGQuodyEfIJdkqatatIg20JEjatUpeTQM6YxPHhTaS7AALXRcDHOx2Ms98/Aau7j6uQhStM2sJIKJu4Sw9tYG38IuvUa388SNzPRPEjGPbzG36GIIf6mtb6MQV4dZTPrDyvLa2loL4aDad3fgfRT2hoIMYiIdol/v1zowIgB//4Ax5ejUBaHnXWFdMlT23qQx8b7jths2ZYnSB94C85TFaO9uAOjnyNCN18WU9qjLJ1a25yYGrMtiuc
 qaJJY3X1
 zjtbU4877LhW1dwn3xF9MgJ5XlpUDVtkgSUCcc0e1VjRSXU9WYc5j7KFsChx/8j6843TnQpNP7UyGLPsKxDUW9B5XVBT0fzFTEaMX5WSOVPeGt4Zrhm/SesWd2BRifBcGKGGFe0y05Zzh4zhvM5/nY9qsafIXajDuaTZeTD7UXy7xIqtHY9DREZQKfU8SGa84uDhinVsBGaZTIArmYEvD6s1KaAARUaJqi7VhcKET8xNvt9ZbOBNl740mpXHm3enkmxzdAIX78BySN6UTEOewycg4jcCKYX/A4xIPs+9tucDDa6ZC5EMDjOkBM6AO9/Wg9JnrOHEbEcfJCjS2FEkYJW/KT5r+wl9bXze+UjqCBBeLbgERDvUJOC/xPMHH7URVgq1aUJA8yJq+GjdNuHvhvxRpjQJ/xyhcsXfUmMFlzzqT48LZmpkmRsMGp9HhVl/QR+DULoyVlyO60IG0/+0zDAtruJvvUJRCTHd/x2OZ3FrAeiz8/grseAXNYgXs8Bcpw1T2snL5pU+zIlgjsBDI6LknsKMVchhYkqyNsBOHJnojzk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current shift value for page_type is 24. To avoid hardcode, define
a macro called PAGE_TYPE_SHIFT and PAGE_TYPE_MASK.

No functional change.

Signed-off-by: Huan Yang <link@vivo.com>
---
 include/linux/page-flags.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4fe5ee67535b..3c7103c2eee4 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -961,9 +961,12 @@ enum pagetype {
 	PGTY_mapcount_underflow = 0xff
 };
 
+#define PAGE_TYPE_SHIFT		24
+#define PAGE_TYPE_MASK		((1 << PAGE_TYPE_SHIFT) - 1)
+
 static inline bool page_type_has_type(int page_type)
 {
-	return page_type < (PGTY_mapcount_underflow << 24);
+	return page_type < (PGTY_mapcount_underflow << PAGE_TYPE_SHIFT);
 }
 
 /* This takes a mapcount which is one more than page->_mapcount */
@@ -980,7 +983,8 @@ static inline bool page_has_type(const struct page *page)
 #define FOLIO_TYPE_OPS(lname, fname)					\
 static __always_inline bool folio_test_##fname(const struct folio *folio) \
 {									\
-	return data_race(folio->page.page_type >> 24) == PGTY_##lname;	\
+	return data_race(folio->page.page_type >> PAGE_TYPE_SHIFT)      \
+	       == PGTY_##lname;						\
 }									\
 static __always_inline void __folio_set_##fname(struct folio *folio)	\
 {									\
@@ -988,7 +992,8 @@ static __always_inline void __folio_set_##fname(struct folio *folio)	\
 		return;							\
 	VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,	\
 			folio);						\
-	folio->page.page_type = (unsigned int)PGTY_##lname << 24;	\
+	folio->page.page_type = (unsigned int)PGTY_##lname		\
+					      << PAGE_TYPE_SHIFT;	\
 }									\
 static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 {									\
@@ -1002,14 +1007,16 @@ static __always_inline void __folio_clear_##fname(struct folio *folio)	\
 FOLIO_TYPE_OPS(lname, fname)						\
 static __always_inline int Page##uname(const struct page *page)		\
 {									\
-	return data_race(page->page_type >> 24) == PGTY_##lname;	\
+	return data_race(page->page_type >> PAGE_TYPE_SHIFT)		\
+	       == PGTY_##lname;						\
 }									\
 static __always_inline void __SetPage##uname(struct page *page)		\
 {									\
 	if (Page##uname(page))						\
 		return;							\
 	VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);	\
-	page->page_type = (unsigned int)PGTY_##lname << 24;		\
+	page->page_type = (unsigned int)PGTY_##lname			\
+					<< PAGE_TYPE_SHIFT;		\
 }									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
-- 
2.34.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C5DC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8B46B0166; Thu, 24 Jul 2025 04:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEE86B0168; Thu, 24 Jul 2025 04:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477686B0169; Thu, 24 Jul 2025 04:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3744F6B0166
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:47:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3944B812C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:38 +0000 (UTC)
X-FDA: 83698529796.22.BD16B83
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012035.outbound.protection.outlook.com [40.107.75.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D8D31A0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=CbGvmHvj;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf19.hostedemail.com: domain of link@vivo.com designates 40.107.75.35 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346856; a=rsa-sha256;
	cv=pass;
	b=lWKVDw+uQFfr6/lnDI8gL541QZW+eGOHmmPBoPBtKa979He6XBtzvB73VCTvQhTZoXgGOk
	Us1wONuME0joAU789lHCkkZijQ2AXUU093A1UhFpv0rZAArxGQAPUZ9Kp6UmBg27aKhDUH
	UJFE40iVW1kmRggeJ/MHLmTw0ukbbT4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=CbGvmHvj;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf19.hostedemail.com: domain of link@vivo.com designates 40.107.75.35 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kn2GaycyyXzgFMT6FCRYwpVY16Rm8fBrN+3KIgdEQs=;
	b=N87PWl34SZk57fCyBxcnlkDtAqu0HDa2K1PYU6JgjDaBAVUJ2Pw37FJbh0wOwEcsv8Bmn8
	KroH4OoeFOPnVgI3xbrnxoQfNX/nAQwSCPZU1bVRC2wSFX7mtgFHdaIw3+X4uWZULMBn+o
	p15/Eh5eLFokWoajV1lNPymgaVOBy0A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uehbQ6Okh9r9S5RLHu19xqtNQEYYLzQE66kMTKl/HH45zgVf4tW0/mCBt51OZEZRx1oPaBzhxN3WSpoSchWlYlJ61JE9cUgCyf79WKYS9BJ6L+ODZ4k60nNUIg/zZDJ6asTxXshd4wuyBdnPOlGqzC3jNQh0LEZvaBz8fctgFjt3QDO9QvtgTsYLvZGhtwWq9YrIOxLHuMxbvxIuXt6K9NGit3opXL+GT22ObTqC1nKynZhBenVBhEfEPFy3w1LGFB+fLRu0uBoVS274jwadZW4fN8aibldkyONnqgYnT2Yl/mhaXnJ51WLHzzs7XsY2Mhvnu57g5SW6vPIkoAcEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kn2GaycyyXzgFMT6FCRYwpVY16Rm8fBrN+3KIgdEQs=;
 b=WdM5BhlNOWFubjjifxr1NgscjVYy16dMOEtW2Cz+hKcKl/XhdtwrFTFEsA8gdPaF4+CgSdVbAceqZMbCc2d37t2rJMo8FkcAskdJvRzRUT347/zpCKGwr+zA2xCHFL/qZWJmh09XI8NmegTohN8JEucnPKX60tu05myDiBEwIs62tMRFUQkH+pPkGv1LiSONIUKmyOOLhOuLbcguENfGB6JRJLgquk82QH5CfgVjzFQdpnGAm2CBBFMNHF4zLWRCJuNCR4VHH2GISG688/XqFtsFIY5ZVze3I5KLLmW4dZFSMxmK2k1RW9CHwtz8JV+zjh41GKKPCa/nmJ0a8K8lTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kn2GaycyyXzgFMT6FCRYwpVY16Rm8fBrN+3KIgdEQs=;
 b=CbGvmHvj2EpzP8wS3uKBMlnNm428w95IvgRGZxlM+oJg6qMSgHoOHpBHguS+Orc24eebf/wJSU9XQz/qak7odfAgH19J+kZZ4OqiNyAGh4mIMm2xw76l+iY+YxgEc+SmPi2z4hSR9ug0Hzvs/LEf1zMN/nNh7gV61/71AUG3wvpOgrqFQPAG5n2FE3S7SBzIGac5PRF0UYDnXX0gHw+MzM55YtrS1OroUtYjMK3sjgUBNLB77l3bF9Qfbla836otwm4ZUzwrlT/IytH8NZA+Z2qhhvVpwuMwslm8yncbNzDzGPK1raLoPPW9WcwNMj/hyLbhQOSuTHE/o6nPYWQMuQ==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:45:57 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:45:57 +0000
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
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/9] mm/rmap: simplify rmap_walk invoke
Date: Thu, 24 Jul 2025 16:44:31 +0800
Message-Id: <20250724084441.380404-4-link@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2a195ebe-ee42-405b-1d37-08ddca8e8229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?60ilzuUtbYYs3P+UqQU2OIEO2KHcklwBYhnejQ6Hb88nf5hDQ80VGM6NoMxo?=
 =?us-ascii?Q?piNOcqyCxOgfeTAaerBDReNyjXiFafBOgJM9yNfAjwwxCJ+CAwXpLXwP+tYD?=
 =?us-ascii?Q?mDANOFMJHslbAQ/IMn9vci5HS1zcaonnt8fM1cgZMDAeZEuMeqxmwRIz+kQF?=
 =?us-ascii?Q?8QX6VfM847TJftHk8VHf0W00jqEqhpvuzO1CBqhX6vYjpiN0AXVVSvyHMEPl?=
 =?us-ascii?Q?6OQLh9tkOmBy8hMkt2iNjXXkNqn7DF0eroi4SGBImQC3/6BqGJhMSrFYPn85?=
 =?us-ascii?Q?Kqv5Ae73GwsF+Il62RscABtJhyIUIOhdIUj4syQgHuJHotqdAbfF2uIZngco?=
 =?us-ascii?Q?cdNhIALceLbzNrK/P1EhalAnfQPGsngNoVo3pZ4gC22IXKREA9lYal1c2Th/?=
 =?us-ascii?Q?bU1V4RGld708NiwxM6CQARDqo3C8GYd0pWZyQYsqFGalJrO7rfKhnr5sCr3O?=
 =?us-ascii?Q?4p8SoF4PLIW1jngNMPBtf/LHEgLQybQmGE8rprsFfWBeIidJvbuzb7Xqbb9f?=
 =?us-ascii?Q?Qx2dfV+LpyaKMVoMt50IPOKFjhyDvljzYeIzU+j/BL8X71c1SrjM9uZwQu/3?=
 =?us-ascii?Q?jhKEvF+/4RUd9bo+aZtldVFRetl2UrfwLB8BdbxQ/zrFL2fWE7MHQUMeEBJe?=
 =?us-ascii?Q?oyNz0redsQLo6Y/lJ481ZxllDNppI3iIYUoe5x1+8c8MJas6FXrStEgh6j4p?=
 =?us-ascii?Q?yGQ3mLqdqUakWelj9OFiwPyQpgGY+2MQf1JkHfYlrFWLsfl18p31i6CW9JT3?=
 =?us-ascii?Q?STVsAKOq0dwvwIJXGkDixMbF578B56G5FzKgdgwfMGV/S1Q/OB7OFK4LdwWi?=
 =?us-ascii?Q?xS9uCLNbdY2Ont2wHtbfMUwbX0HJWgY6ZcUMI7Jxv4uySvzFL8G6KslC9h7k?=
 =?us-ascii?Q?CfHuNz9jQHWPYofqDR1/ijcexj0Fs4tXv4y3XxvX6aufKT2/fOPsayGsatTn?=
 =?us-ascii?Q?aYvsvnlSJSWgeXgJsbOC1y0Pr2HQuIoj2oTJcdlMifvYJZ7prLMuCzT/yRJ/?=
 =?us-ascii?Q?8KUeq+WhLC1CXCuk6IM2Xfj9LUXzdSevVO/lqpOZwYeNDXuzcFHR5Mrz+9Mn?=
 =?us-ascii?Q?qt4hdSX4Sl1LMHf9AHfZCOoZIwTcDdaJ1rT88lO3QjLrs9FD71kVA7me//qN?=
 =?us-ascii?Q?nYDJIveKnKhGG9O7E1vimDQn0KigzeKwN1jDw8dW61TwpPofn/VRxRlFm6tB?=
 =?us-ascii?Q?fsvQSixywnfsULa2MPsE2es0GCHmIBiAmCFY4wv0PXa52Bokqv2/VccNxF9N?=
 =?us-ascii?Q?Deyih0y84ZKa6PuDbLYJW5LYWr0SYvcYdH9d3OEypfEEYO+skeCPMklJGFka?=
 =?us-ascii?Q?De3/YofU6EiVb3W+DG9kjYcA9BN8K3iZlNjJXmEq1IUYnwkX7KXhfztOHtOx?=
 =?us-ascii?Q?zjscYWwKKA8bkoDvVnYpSZznWqMmAmu3z+Y8R3ordklL99Frf/MfIrjGaDq/?=
 =?us-ascii?Q?DNsbPXXLGPqB7bN+xan8i6PAf1lybpZxFOErYrqppKMoBu05j7Vmx/fzNobc?=
 =?us-ascii?Q?6RsPS5cdz27MBCg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hp3WvDE9XHiMQDkqnIr9AHTpaR3SPE7hv+FQth/GCssXFfMePDlA4qCkKajx?=
 =?us-ascii?Q?QmlfpSnRs2htwNAGSWMLra9XGOA6QXI3fUhIu/JZUydb4snYpXY7beapBT1/?=
 =?us-ascii?Q?Mlj+lvVpzVC1yGPXUSSSH+PcXqm5TqaD4AReBBA6k4PNX64vp9HScbmZXE/H?=
 =?us-ascii?Q?i/mwhvfoelPQAgWSKmFc/DT/92YNKGZwj5RZvdQueGhCMr1oPSuyj9/rhGET?=
 =?us-ascii?Q?pYXONHxh3ssWxXQwMCRsOVb5MmgK11ppCnRzBNaXsB7I1jK/a4xuXYUSKSJM?=
 =?us-ascii?Q?u929o22mf3UBxMz1OvAI4C6pwW83tJF5t5kShxdwU42dKjFgqc7ZiO+s63uL?=
 =?us-ascii?Q?qekT6FVKvU/8FIU9YiHxTG2VR5Vp/5lleQKZFZfQWRbTVaN7kNZhIHyMNgvi?=
 =?us-ascii?Q?/ybRPWMf81rX2FTsw0caSAoxOIceDZNY7THKTqs6tl6IlK4AOR+SVmnb1iD0?=
 =?us-ascii?Q?q2fd1us3Nz4TsA+QlxxrBjLMSBHlBgi7LNkcwUh776PkaugWyhCu3ElgjsG2?=
 =?us-ascii?Q?L5QypoW0iz1fMdqApPIgypQzYh9j+VOBww/Q10R+7RAGgBo1jB8k5y1LCIwF?=
 =?us-ascii?Q?QNH6USbXG5Mg54Yq036zhzXgwmsy3Z8AJ0UHhdZUy+jqE0XySlyXrEClnc6y?=
 =?us-ascii?Q?EmhUJ5myxa89HpMRDtktE27Z6TA/MQrwoO+Gh14u+Vwhp36dGP9I76kZ6183?=
 =?us-ascii?Q?B2uCH3Pxe5UVlKaRlwGlOjKKj77PQDHtPKc6RiS7CMT6NH/4cqrN2CXc+tbe?=
 =?us-ascii?Q?KzahAGocFdSJ5ctOjgL+cavofB7ddHMl0t9RkDrLf+5vqKBQDeAPru4uwWEe?=
 =?us-ascii?Q?mV1mNef+q0HGfKv7FmhDm3L1gtw3zv6d3z5LrcGK4662mREFYm8konpc7vN/?=
 =?us-ascii?Q?4PcvPFyZazItxkSjO1wNsPJgOUQwroVBSHUTgq4SH+yc4p9hO4Dqliylo7fn?=
 =?us-ascii?Q?RLCyuXF/LXNHSPU1M7sl45YK5Zc9+dI6WwR+EqyQO16IZj82t4EZZCW40kTf?=
 =?us-ascii?Q?kcQA8O/ZBWbZR3hqtAnR1Xza1/cXDHT/+cjpGjrxjfRkEfj5etDmXJV8bQ23?=
 =?us-ascii?Q?QyBdTqnh9DUDt5vo5Xca+XclePnaEiV9nAea8fqT194lxhudC9grT5I5Mte6?=
 =?us-ascii?Q?r4VbA1XgpzZWdqB3Lh0pRWWTp2RZkFbj0gFRMb/V8K4xcj7v6AJd1WLlVQr6?=
 =?us-ascii?Q?wqa+9EJ+kdhic9kuB93rGT6Dlz/JTd3ayn6KHTf1qTv9vmRr9eHfhXJEC6nk?=
 =?us-ascii?Q?xEDQ9W53VEjJFHWtiKYw5M/ood71XsawER+Z9uaQf+7WP9qCgdSsBQ32w56J?=
 =?us-ascii?Q?XfLj90MtV/3gF7oSmSLbKacxQlRdht3LzgFLJtU7Ykrb+tk9Q2s0WaZoLpRN?=
 =?us-ascii?Q?J+O3i8Ly7NpXwBWmpYceEyqhJb+a+yks4jAmVYIOkFmKvoLSH9+ZBTS791oQ?=
 =?us-ascii?Q?kQYen8NwUas2Tyo9idWV7tvto9DEnki6x4Pb5lG2mom4Qeli+SsIbaQXCrGx?=
 =?us-ascii?Q?QRrCYUJttg3VyzeRQTdqbHvJjbNQStz73fGMz5Vq7GCjn0wLaXL59bKVymqV?=
 =?us-ascii?Q?NBb1YMrFj/X9bvzxdRLWXmzRBPIvfq+Goip9VVNV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a195ebe-ee42-405b-1d37-08ddca8e8229
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:45:57.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnT+Wcet/HqaKsV3KQGgC+hRORCLSpBh0FjkSxuZn1Ctfg1wnfdt1I0IAKquhA+BFDTW8BD6p55eyvqJQKuSQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D8D31A0007
X-Stat-Signature: 34cjsiqyf7h9jhpuq9xz6bhipqb61t7a
X-Rspam-User: 
X-HE-Tag: 1753346855-494147
X-HE-Meta: U2FsdGVkX1/JLZwkWfXIUIKauLF+9jlFNs3qxfJnoPPhIWhQHEdDXisXeUIgGeFwtenFlengAVo0DFD/msI6363dcy0eM2xNn+AGG14lplH9noviMGB+BAzfh3w9w/3h6DrJBtLiC3Q59izwXoFdaGBGkEUZoN4+lGSbuG8uhJ/b7+3Yu8/WCAGiWBoxwEpYFo6P5E1DBU3IUYMUrocooFEQOwFwXB5fKxZlE+1RP8GukwZBodOtWTFVIToPHHYKpMkwD01wadQpqcQP+R+SJ2yK2POXb/UpktWbU0WUyvPheFhsPcM8XznFOx1s1HhMQaxQZERWAUx6R+hh4nHcqso4rMYXtO4nDYbl8QdtpbdPbLjmA8FrK7OtFTgb2mwymjbC4qVKiC8Va52BtkWooyiAmdqeWRaEZUW2D6Wl3U00vVCOAzDy0+blPalJq5yc3l8t0QcmSjtcIYcoZJfO97vjo2J39uUmERUEqx+dhNj53yt5yo1zNIe0qCaPh49lKNiujRdUSnwK1wC9PXVZwdMscke2TK1K4dwI+VH6JztfCQcauI7Q8xK8GTWXzar2jwguqNNIfOrsM76iv9ZWNUodm9IUs0cvu+JWvtCB+cwCvRB9ydTQsGWtbu693Vq1wVrDZ6PN+OuKrpZy/e2NHS9Jzt+OQPY3AYIUehWYfmARMI/V+O1h7sCJ0fJuYXRpfs86/qWxk82pB1hqUQVM49Nz/5diH9Mn6/U0SWK96YbBx9ptq/tEMGNtU38QQk+Lvr4iS7m3LKJ4bGSZxGqT/gAc4uKtXtr4uKNOLjgaYfmYPlfEWTRq47W2LBsOr/4/iTIn//9XHtIu/rpROvTCDY08nQMomNHk5De8u+5p4Wt/s0XkdJ94cQaq9E8RWX7LiQn4U9WuQEljccwG0NKh7YkWUD98+TxqVx+pPKV0LU5W/2/v78oQEBkIOS9s4i0Np30/FKhaElttWqj57g9
 IpeLF1BD
 CUp1rz8cvRlvfvCmJKnRk5lEhkEoEHoTFOtj7wT6BXfwNuWZni/BHecuv5W1LQYQcf/aG3u8z1T/iIVRPx8LztqnufZpI6dcF1Cn5SgFM9Z+zwwxF0buoymzmL+ptZyk/E6zW3Abd2t7BBuWH6UhKa8fMWYWnb3pRzJBQuinx4xCek2Lhstsec6fWb9EdweFnbTf2nP+TDmfIpCrZtBCtHCbza1gIpWSqSkR8qVf2A4b1342AAc817w0X9DBkBHOPQhTJs71JTramiT66DQo950sccUdOKiP6qcvDpOjna36kzaY3Ojxbj+M0jGZBTfobix1ACeOOlngXCOqbKL/od8n0MhRpZDW2RJFksD0UxHa4nbywAfsbxnn+qFnZldW/IHWoNuHAbW7JQk/mVAI3Qk9oUPRVurYiT2A89O3wnVFmUDqikdxg5PJVgnMVlezVzMv1aauOiAqatsvyoBRHu/6AZjnpXP1T+0RfIqXtvoZ5e8/4CFf0dy6gdpi0jgDh2oaNoWoNcTpTk45W8r9q3d0PDviIXehdVoMt3fVqHdvGNAAqCh/NllRytY46hQP4r3ublUOiRnGzZkBqbhCYViG3P2bCoDyMOGS07hbzfOwSBp9BQ1f21HkqM5+w1i1bDJypJESAFTDlxzoDWKgxv0lu/bWxvWRu8C0u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the rmap walk is split into two functions: rmap_walk_locked
and rmap_walk, but their implementation functionality is very similar.

This patch simplifies the rmap walk function and moves the locked
parameter to rmap walk control.

No functional change.

Signed-off-by: Huan Yang <link@vivo.com>
---
 include/linux/rmap.h |  3 ++-
 mm/migrate.c         |  6 ++----
 mm/rmap.c            | 43 ++++++++++++++++---------------------------
 3 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 45904ff413ab..f0d17c971a20 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -996,6 +996,7 @@ void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
  * arg: passed to rmap_one() and invalid_vma()
  * try_lock: bail out if the rmap lock is contended
  * contended: indicate the rmap traversal bailed out due to lock contention
+ * locked: already locked before invoke rmap_walk
  * rmap_one: executed on each vma where page is mapped
  * done: for checking traversing termination condition
  * anon_lock: for getting anon_lock by optimized way rather than default
@@ -1005,6 +1006,7 @@ struct rmap_walk_control {
 	void *arg;
 	bool try_lock;
 	bool contended;
+	bool locked;
 	/*
 	 * Return false if page table scanning in rmap_walk should be stopped.
 	 * Otherwise, return true.
@@ -1018,7 +1020,6 @@ struct rmap_walk_control {
 };
 
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
-void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
 struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 					  struct rmap_walk_control *rwc);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8cf0f9c9599d..a5a49af7857a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -355,15 +355,13 @@ void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = remove_migration_pte,
+		.locked = flags & RMP_LOCKED,
 		.arg = &rmap_walk_arg,
 	};
 
 	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
 
-	if (flags & RMP_LOCKED)
-		rmap_walk_locked(dst, &rwc);
-	else
-		rmap_walk(dst, &rwc);
+	rmap_walk(dst, &rwc);
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index a312cae16bb5..bae9f79c7dc9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2253,14 +2253,12 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
+		.locked = flags & TTU_RMAP_LOCKED,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
-	if (flags & TTU_RMAP_LOCKED)
-		rmap_walk_locked(folio, &rwc);
-	else
-		rmap_walk(folio, &rwc);
+	rmap_walk(folio, &rwc);
 }
 
 /*
@@ -2581,6 +2579,7 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 		.rmap_one = try_to_migrate_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
+		.locked = flags & TTU_RMAP_LOCKED,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
@@ -2607,10 +2606,7 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 	if (!folio_test_ksm(folio) && folio_test_anon(folio))
 		rwc.invalid_vma = invalid_migration_vma;
 
-	if (flags & TTU_RMAP_LOCKED)
-		rmap_walk_locked(folio, &rwc);
-	else
-		rmap_walk(folio, &rwc);
+	rmap_walk(folio, &rwc);
 }
 
 #ifdef CONFIG_DEVICE_PRIVATE
@@ -2795,17 +2791,16 @@ static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
  * rmap method
  * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
- * @locked: caller holds relevant rmap lock
  *
  * Find all the mappings of a folio using the mapping pointer and the vma
  * chains contained in the anon_vma struct it points to.
  */
-static void rmap_walk_anon(struct folio *folio,
-		struct rmap_walk_control *rwc, bool locked)
+static void rmap_walk_anon(struct folio *folio, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
+	bool locked = rwc->locked;
 
 	if (locked) {
 		anon_vma = folio_anon_vma(folio);
@@ -2908,14 +2903,14 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
  * rmap_walk_file - do something to file page using the object-based rmap method
  * @folio: the folio to be handled
  * @rwc: control variable according to each walk type
- * @locked: caller holds relevant rmap lock
  *
  * Find all the mappings of a folio using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
  */
-static void rmap_walk_file(struct folio *folio,
-		struct rmap_walk_control *rwc, bool locked)
+static void rmap_walk_file(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	bool locked = rwc->locked;
+
 	/*
 	 * The folio lock not only makes sure that folio->mapping cannot
 	 * suddenly be NULLified by truncation, it makes sure that the structure
@@ -2933,23 +2928,17 @@ static void rmap_walk_file(struct folio *folio,
 
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
 {
+	/* no ksm support for now if locked */
+	VM_BUG_ON_FOLIO(rwc->locked && folio_test_ksm(folio), folio);
+	/* if already locked, why try lock again? */
+	VM_BUG_ON(rwc->locked && rwc->try_lock);
+
 	if (unlikely(folio_test_ksm(folio)))
 		rmap_walk_ksm(folio, rwc);
 	else if (folio_test_anon(folio))
-		rmap_walk_anon(folio, rwc, false);
-	else
-		rmap_walk_file(folio, rwc, false);
-}
-
-/* Like rmap_walk, but caller holds relevant rmap lock */
-void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc)
-{
-	/* no ksm support for now */
-	VM_BUG_ON_FOLIO(folio_test_ksm(folio), folio);
-	if (folio_test_anon(folio))
-		rmap_walk_anon(folio, rwc, true);
+		rmap_walk_anon(folio, rwc);
 	else
-		rmap_walk_file(folio, rwc, true);
+		rmap_walk_file(folio, rwc);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-- 
2.34.1



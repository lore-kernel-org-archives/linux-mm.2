Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E27C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E82A6B0149; Thu, 24 Jul 2025 04:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0146B014A; Thu, 24 Jul 2025 04:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEEE6B014B; Thu, 24 Jul 2025 04:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC416B0149
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:47:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0750F1D9DD7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:24 +0000 (UTC)
X-FDA: 83698529208.07.A0D81B0
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012067.outbound.protection.outlook.com [52.101.126.67])
	by imf30.hostedemail.com (Postfix) with ESMTP id 303CF80002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:47:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=Ok2DuZGl;
	spf=pass (imf30.hostedemail.com: domain of link@vivo.com designates 52.101.126.67 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346841; a=rsa-sha256;
	cv=pass;
	b=HO855fiGll6nX+WBpQF7KZhQVBMr3FkW6Bc+cR3SmlEi4dSkj76Yh7vRe9praFrbE43++C
	metvrXBdSqRgDcFjsUoWxdOJhz/fUt8qqStFNL/fUUOExRlpzrpHZCdYGvo6UW/NHwwMR/
	HapT4+ZFC+8OgJ2iJ6dKQK4fGwoNoRY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=Ok2DuZGl;
	spf=pass (imf30.hostedemail.com: domain of link@vivo.com designates 52.101.126.67 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8vNQTxEiBGsHHcBYGEaSLVl0jn54V4X6W24zQBAnVM=;
	b=kKE+cKYuJlgBpjbic2sMOjOQZrTzaPciHFJ/iXHu9m1NPbldpjuHBJ9gF2A3mcuHPchPHG
	pWIJPIQ+2+vj4vzlu8aCfGW26tgosUdqEFzIuqUXAZuw7DhpgioNxP6QtdLJnhJ2Zdff27
	I4q1I/WdXC79pORu1PSqXPSFb4EA2/U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxMnukXvjlDkflzWm2lzH4lMZjx7kfy4aV5j9SbN2uKAFK56gYtZ5Wlx+5L/tXAok1LbnWzN/J6ZHfWc4PO3z6E00QQAwphauKZbboZe99pY8FbFgym5Nfh9v08zcat53ijVKhSUB9KyRowFToEz0vTeVzAHsXG1kgutrK+60FJpejcQJQ42Lny/LTlOA9w6d04PlFqjYaj6+qJxidecgcg2u5Q11iqL+fxI1wjtODa+tf2/jq5jJTqanjMpeihvNcWPZuxQhMyN96zoyoJetJnBch+tR8phWnUXIy0cRutfMzy7gZZBChWavinG8mOB6+UHY0GU0TlIQZZC+ES29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8vNQTxEiBGsHHcBYGEaSLVl0jn54V4X6W24zQBAnVM=;
 b=iyCJYsGD5YlNHBnIUb1WGFAAazxezQedXcryYGlHNiTSqlj+a/CLCKNDjlqwU8iIany2jJA1iPBtQpje0T2QsG0UyqWbNWHexp2v6pVB1fl6vrTTAavRiD2dFjBm+6sGsWp1dz0iQRWNoy2U40TPArfVqQhIlMoPEj4KzF5h15g5zAleLe9FHW2XCLzPdm5udH9rCq9BNZXMBPqRQVODJqMvSrKU7tZRpHANgt6E1BRmtqgV7cTH/qyb1ieT8s18HB7BtmovfqDGvDZFiunP5p9AKCwza22d27qx9NnjIuwcr+C3TsWYpHr3GZPcNN16F/KJnZOEQrVDYbThTdVBtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8vNQTxEiBGsHHcBYGEaSLVl0jn54V4X6W24zQBAnVM=;
 b=Ok2DuZGlCPsbloDfKDT92UGrd3Km6BD1pNapSX/zafSmHI6RjHHoR7sEr5tDYPeZ9+m9xr2LNO2GnL6oM0xgFspww2nrvVeTsxEmgd85AG36o6H6UKZSoyxKVNoYWUBKJUxkrcTyEaJf7BVdOfLQwbncbZJsAI0Pphp90KSxPWtP1r7mdI4tRpaq4cXg1Nz3rI74mIwI2NvOFV1AGxCNtc1I+Gd7yzs2nh4FlhVnDW5ST1lvvlHMP62/ArYhVW2O5NIStb4igCkoE1eqYqA9nPBQ4c3QcQMGI8bAt4HIGH/F58OGCfP02eULJzSZ6NXByqHdX6uJxeyJuiuAfhJgxQ==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:46:03 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:46:03 +0000
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
Subject: [RFC PATCH 4/9] mm/rmap: add args in rmap_walk_control done hook
Date: Thu, 24 Jul 2025 16:44:32 +0800
Message-Id: <20250724084441.380404-5-link@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: d183e51c-7cee-4c71-8519-08ddca8e85b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/mk8Pl1J4w5kYorFEYxfDIsY2FtGd/4Prk65Ms3W1PKsrR2Y6zzcenEysLBV?=
 =?us-ascii?Q?BGhgkh6hhSIrlQndvhFemj3UjZaXhigBthFjl972aYez4FEW47I5lod9NKXu?=
 =?us-ascii?Q?ZESLq/QTXLXHXJqbHiVC/pXo4F6+Zqgq58RlSaHK+VfCne1DUWauRe0jqvl3?=
 =?us-ascii?Q?tD5hIm4y1P0gTDuJTvju5t1tYCBw1FbNPVDhUzTtdqEuDK+PKImiNTQzwGW3?=
 =?us-ascii?Q?ifwVS3E73dG+T79Jkj9c7SDqAIxT+hnk/rSJ6X4fNpwVKqCg8IKbOCmUgf5h?=
 =?us-ascii?Q?uy/0nGXOdO4ogaJ7qBBBBovM2FC+DSHhSdQ9WKrxeqBYTRIn2eGmhV8/x/z+?=
 =?us-ascii?Q?hvyWx26w3JtYa8nKOweZzkkIPk4pFfm3nG8hlUSkm3BQFz3kCrmD8rEndxOB?=
 =?us-ascii?Q?QNmGXPzCDfugJtGo4spj3hLyc7/Nz02T/98nIqR/yVJjbR5l2M/3ReoVQMwH?=
 =?us-ascii?Q?BqnpOHnYll/CrFJ7dM431xuz8xaPH0XoKkOhXcipphy9p3vjs+U3WGOAtJ/Q?=
 =?us-ascii?Q?92Jg1JjpL1gsXuPW+y9Gun6R4rJY0UHHA8lURSw7Yljr23z7q6dQQlmodlky?=
 =?us-ascii?Q?CDu3u9Lw7shMv6WG72ave4xlO9eIcCzIZCq3PwNL9HArdW4Mztl/ZZvU6ANq?=
 =?us-ascii?Q?yf701oXAiXVrxI+MfNZPRisBvVIF0O/YuyE1opSgWAxmie6MObGLDZ9Q7/Ok?=
 =?us-ascii?Q?9lULxPScvddSk94fPdhcT8ppPX8l915qUzhIv3JaIR255CLn7lDe56qECTTL?=
 =?us-ascii?Q?JUOzBt1Q/utUA1KgdMaUld8NR81U29LUwbhfu9ZxTLP0fhJzlyYgqkSjEtpv?=
 =?us-ascii?Q?ONMwd2w/fwAQ3Z4W6ZGsy2iIzxOhguFkidxXNGrShgkAt/3oANywWvg35fqA?=
 =?us-ascii?Q?f22kjzm3su3/Zekdi71Y91phSNuHkm69dI3E44qEO5vHrS0ZtGuTCOwhPwwS?=
 =?us-ascii?Q?0YQVf4KXRjr8U+ZBXw7T5O6sk1T6RjempWN5NITnfS7PnFbLCtg16cfWy+kZ?=
 =?us-ascii?Q?3NCZzfTzhijeQxknvfc5y6HybpJQ+2BJUY6F6eoqI9ALg/igU86gV4i3MqnL?=
 =?us-ascii?Q?ccQNZWJW2whJRownuNAoSuct/AcHkV9BrukalZ5BPmpYToad0LUbmJCHVEK0?=
 =?us-ascii?Q?/LpP/M+2Vh8aFCS830oblVCj7GIwGOxpkeF3etVjTatPAQ2QKZMtcoGezplU?=
 =?us-ascii?Q?lbFTd46vR6xh0QbO8fWfxksy3snB9uahxUVH852KX0aKI0CfiV4xzxWEGeKX?=
 =?us-ascii?Q?5i1qQqNjuqowfbOKryAEURoGGxELFnw8maT6goUiU0mJFpe+8TmaBNkhKZlW?=
 =?us-ascii?Q?Oya1J5BfNW+j45ImTBMwsqeVvPKGxmvfLbM/35WuyCInET/9tMaLPOhjC7Ng?=
 =?us-ascii?Q?k43kkrcm5Xc11IQF9hFsZCeSmskCHbBcCU866piSYgEgXLRzhwLyM8zexwtf?=
 =?us-ascii?Q?m1s+Jkoqwm5fkbRY0A51uBhZ8efQrQ8sd0VBvJCDIdFOsmBmYyRIy2RSuDNG?=
 =?us-ascii?Q?1K5JGZXtjQUkIMk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9hNSVi4irf+Kp6C68XbqqOzdATIREJn0CrnuW16r9wkHrqFLqL4xbPdR9ex1?=
 =?us-ascii?Q?oEq0iOnQF0xV1K9HSKbLRXf0mBCecZmAp9SX+bN5ES2Ivh6IQn6z80bTnMgM?=
 =?us-ascii?Q?WwHA0PwSBTSKPRC1sPyHCpUPHWLsh+Zod4XIyIcxnNTnPwkmblJLSjF5oJGS?=
 =?us-ascii?Q?6K6ZbkkuVtsB8UdiLiQ3jUujZz462dOfd1XLkSSBRSMDQrMU3jBTNqlNm3Gu?=
 =?us-ascii?Q?tiAGOGxkH+NVANqzBZ1pI2Py6KSSCKxCnDkbW0mpTcol7fwyrZZzBXwqzRcO?=
 =?us-ascii?Q?ttqlv96iBOzMzRhzip6XNzxdQZ2Fz1a/PXTU7Im5SA6l540/M9Xv7M72uAAq?=
 =?us-ascii?Q?4UO1ObA6hnDk6voKiG/gO0HJQIRe+mGACj9zXyyW5hG4KkZCcUD0nLxu3iZ9?=
 =?us-ascii?Q?GQB5ntAKbadQ7yIoeihdYfSyNpGLCVms8+t/s3jln5104DqsbFwj7Idb+wTA?=
 =?us-ascii?Q?A7pAl16W7dBgR9MTlBWmQzU/LLnPctGxa//gGCvw4pOejJXZDyAsRJoTl03K?=
 =?us-ascii?Q?jTreFeqmMMlFm51Wvcg4bMDb3KQNEMuXZ0AOND3RvKp0YaRP5ygekZ7ICS7m?=
 =?us-ascii?Q?6HbZby8qCgfDDE3/NxI+QSf3qlrwykbD+S8skRPSDv1NcRsDdBeZs90XHTMV?=
 =?us-ascii?Q?Vrf/Z81KgUzFRn1cXgJeokGNv43IcZ7EoaglZ+/d39F/niGVo0wKq2G51SkS?=
 =?us-ascii?Q?JLTfnO1xMSTVyOE4ozG6LV7E4LF2ZCBtPfRO9GquzAjss10k4Ckf7oZUCMIB?=
 =?us-ascii?Q?rImftFMl2DU7VxTsvdWmyEuT/800IPMh9tdgpuhNRq6noKlQ+AMGGYDiqEQt?=
 =?us-ascii?Q?H/ZcxskbjHaEJIjeEIbBBOfQSRUbkUTrOMkwcthvfSY7rwAMBpgHZjRcirBO?=
 =?us-ascii?Q?ZlH7M0pzQ+SDU/xp7Axvvw1hiQ0FkAGKt4j71S72AAcnwdUuFTGfhwzjkaEJ?=
 =?us-ascii?Q?kXtXM6LXddmYZdw36DyPHoHRjFYywI71+FKkvEidLp5pUWbTEklEow5QSYQq?=
 =?us-ascii?Q?Qa7gF+2eMYRKhCNjvID/mpglvmQGLqngCBbTS2fFnDm7B9MsgRQe5BorG56S?=
 =?us-ascii?Q?91trxW+QRxek5fIVofuNIMTHYLpKQnPgz9VkqaMlP8ugpQHJIjLa2cVy7J/Q?=
 =?us-ascii?Q?QmskvqikrJFyghn9TTibsU0Az0zFnA5rU3j5lvKdYlYEDMy076YaLxUUaAuB?=
 =?us-ascii?Q?u6wNUsmAC2fn0E5E3m/m0GHyeB7bvJib5CwgiK24k+kPS8N3oU8UKxd0as1J?=
 =?us-ascii?Q?ZWumi4ybdMoax8V6+eHDklNNR/lkv2pE6Lw5kJDHeJiGJeHkgxcY7Zo3X1fe?=
 =?us-ascii?Q?wVlimTljVwWtubUdAbrWE0j4TARmloSBGQS0gSSrBlVW5mJeF9XWE8Y7NVWU?=
 =?us-ascii?Q?oC2DAXWIRtCE+U4jv9hAEemswpGq4ca/n+au6O0CZmB7gbRZvmpsm36Zhg+c?=
 =?us-ascii?Q?cWW7PTVlX80e4pdlTWscBqYF/GHNnABcoGaUWPTtM0OMLLM6Us6XHAs7l81z?=
 =?us-ascii?Q?wcLElPmbh+Cc7NqIY+2Z+9cgzNV3rCwdcsudx5WnBnGPoeGV+XvdHWbZ0Igg?=
 =?us-ascii?Q?rut0OITfW+5O+31w9iGdsnjXQKbyOV/3/ODtJHmK?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d183e51c-7cee-4c71-8519-08ddca8e85b6
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:46:03.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTWFXfafncaAwJrHO+omnMZkO5PzwKh9+A76IrwpPmGZ8TIbMkdBhcg41xw0b/SKzXOJLKSdeCSd7+CAert/aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 303CF80002
X-Stat-Signature: 19pzbf7gep3u7dnopq3y6ed8bjgg1q6b
X-HE-Tag: 1753346840-267438
X-HE-Meta: U2FsdGVkX1+86RJEkQ3pPiduncemZISNUkDlfYEXNgsnDSys1ZBWKnA5eqTum5hjccOsttJsbbfNg0TriDRHzMhoLEPyKkrWDgNMg+CtUL4KrPasI2WNJcTwz1OS2KNih2jqYD3N+36q6laBQExRbXi59TOM+w+Ad1jkX7NAY2bybw4+4aXnMII/jcBgYyqVbbDnPkwhP0yMX7BmV1QRi2F8ZXwKe1egfRMSQvLcsjyZajvKI2gZB3dNlZnMnSUG+eRC2qNQzeYCFNl8dMwSHovFZNnZELJnYCE35hKG4gB7ztANp4PuOwYwEfsQKIl0cYHmBvYfbZN90qBPQlwV4wBa7vBEjosEFuOAc1G7gyd+uf+78uwWSeov0AT39pt5wqKQ18loEdGijy6+s+l8R7VWyOC+BeRv6ggC0F+MTPTasnWuWU2rUt3VQkwriKneB2l4rrl37us/gtsrBreT7fy/QqMU0Y8qUaFj1dHRC9waKAT39C3Udg4gXCu6Ev7Iqe/wenb8FFjctQ7yQ3f2RkZ/wOfYqMHaJsBU48mv7IEx3aVvl8fYRF2w190srBRsoEWhxlj+X/0ThW+tc/yKOG3U7vhljMmLG76TPV/q3Aqrqwf6Kk6/2ip0yPLoamyrJIH/NsOaGKqLOswZZzdL1hfXvRzkUrn/H1AZz7iM0hB8fc5BDIlLecSuYqVtdidxNjqr02cijccHeuQSU9jhcImKVAsI/8kv/u+Cwzys1iXZk+1zEEiBVJgtS/T1UOewGddw97UMxqw57FVeVGyvPytuSaZfDn8edjlcT6di9O4G79Qerfy3FaY3N3no+XXebA9hEDbbda02VJK7SvV4jdglGAUKmFujRCMEQbYQDMnrdAAHmIhhow8VwD1B7+QTqRtAH/zqfOz51Ho1kb90OIauUEpfS/s21T8uZVih6iS/AEXwxJO9KVlzmJf8T0VPbfzFLpI9q8M2UHt+FzH
 aEDyWQBB
 7oD0rEfwxaa0PEvPrlLnxBkdJbHZbTtMqiQC/VNfMXh3ZiFR8vvQFFbTFY98zPeDZB7J4ZNMkPmWkk+ljX7ENFJHlhnCYCO7hmLXmZEnr5tQ7ZJm4AP7Zarp4s83cB5ZSZQcWCHT4CW9FzHnkKtsC+ZQfSAbGe3El/40eAylVr236RzZtqgWEnUegEnrDvMLb5xmClkaa43Lh5FFGFXmGPPOe/fiWLq099FqWsPqqiAsMpOCYSFrzATLMgzKsD+JCdDiAkyIMhjX7z0MIs9ZJLfkSojrbUnjlopJxIVCQdMUTvTTe5DP0Od5h4r9WghW5ab1MSPcHy2ef3uuv+FVgDrfHp2Sv8KQgAo6x+UsOm6SrZWyrqmj6jGOQ1LEg7iEzrLmtd3y8iDa74DVsgQwe9mqe+TdaQOny4e5k9HxYuuMF+Xfb+Fr5JlWfKJSdpUpp8wJ4141gCBXVOJQCRGDxb0sOFIVPXFgVIVkJkEXZsst7QFIfmrwvkO0eX2KOtAvTOUu5f3APDbxiyw7K0qLmGYtDGLWctPeQxHRxWan7rrsRTADAIHRHtvzFJPm3X07C0UEQy0+hKlOIVuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the done hook that determines whether rmap_walk can terminate the
traversal early, we may need to read parameters from rmap_walk_control
to assist in this decision.

This patch adds the rmap_walk_control as a parameter to the done hook.

Signed-off-by: Huan Yang <link@vivo.com>
---
 include/linux/rmap.h | 2 +-
 mm/ksm.c             | 2 +-
 mm/rmap.c            | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index f0d17c971a20..a305811d6310 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -1013,7 +1013,7 @@ struct rmap_walk_control {
 	 */
 	bool (*rmap_one)(struct folio *folio, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
-	int (*done)(struct folio *folio);
+	int (*done)(struct folio *folio, struct rmap_walk_control *rwc);
 	struct anon_vma *(*anon_lock)(const struct folio *folio,
 				      struct rmap_walk_control *rwc);
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
diff --git a/mm/ksm.c b/mm/ksm.c
index ef73b25fd65a..635fe402af91 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3072,7 +3072,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 				anon_vma_unlock_read(anon_vma);
 				return;
 			}
-			if (rwc->done && rwc->done(folio)) {
+			if (rwc->done && rwc->done(folio, rwc)) {
 				anon_vma_unlock_read(anon_vma);
 				return;
 			}
diff --git a/mm/rmap.c b/mm/rmap.c
index bae9f79c7dc9..e590f4071eca 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2232,7 +2232,7 @@ static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 	return vma_is_temporary_stack(vma);
 }
 
-static int folio_not_mapped(struct folio *folio)
+static int folio_not_mapped(struct folio *folio, struct rmap_walk_control *rwc)
 {
 	return !folio_mapped(folio);
 }
@@ -2828,7 +2828,7 @@ static void rmap_walk_anon(struct folio *folio, struct rmap_walk_control *rwc)
 
 		if (!rwc->rmap_one(folio, vma, address, rwc->arg))
 			break;
-		if (rwc->done && rwc->done(folio))
+		if (rwc->done && rwc->done(folio, rwc))
 			break;
 	}
 
@@ -2891,7 +2891,7 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 
 		if (!rwc->rmap_one(folio, vma, address, rwc->arg))
 			goto done;
-		if (rwc->done && rwc->done(folio))
+		if (rwc->done && rwc->done(folio, rwc))
 			goto done;
 	}
 done:
-- 
2.34.1



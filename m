Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B13C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD1C6B0093; Thu,  6 Aug 2026 04:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38626B009F; Thu,  6 Aug 2026 04:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD87F6B00A0; Thu,  6 Aug 2026 04:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7484E6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:27:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 052FE80669
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:58 +0000 (UTC)
X-FDA: 85070166678.24.7CBA76F
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012053.outbound.protection.outlook.com [40.107.75.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 926A5140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=bQhyVfwL;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.53 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gp9F5NGSy2+0ZFFFOGUUfBr98jB+MrtKGia/pjq5E0k=;
	b=X15Q5gH7fZCzE4lXUbXtPtsyUePa/lqsQJ+D39upDC8lWWZTI0c+kDJwYXxFF8CbBmAZnz
	nheeiMvN7/9PkFqWFm49wImgzcti6oR7yvSck0d4jemwoaBFvUhj/MiTjRA7XTSUkyire1
	hGYFwIV2QqQyon++LazWshXqbRyjVUY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=bQhyVfwL;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.53 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786004876;
	b=11qU4MP+PSEMI1qDJ1RkDVglihVM4e0bvmkYMvqCjh2hIE4qSlllxEAmYn/IDvpg0Q42Qa
	PovkQEnl2WZeuyEeshdxXCnXIOC1uiuE7x80mwO2Ug27dchvY3a7Z0FLp4SEnDsvEe40fy
	22UBeFESZffznn5MA5SjIxrhHjFbVnU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WPXPq7nPNRCkYQZ3ElEutY8u93t3ar+0FQDY6r0oDEyYbQ9R07GYmp9DqdfSEmfv8yhhSbfU6J9hM2vfv86yFMNMtmtgjnuGgXhwarPP2a9jShL8hmoVELtFjYQCF8zuC6S1AQt8UAQcCucKkPVPdVBwur9ulu10Cdekx0y1jGqNpNWntxGL6sm1BjHJmojODBTeGWoNqR/362ObJ71YisilN8xmO9qxuR8tjL8ZDT5OTNRmGznQHczIu45MsSAom6NufgjQfSEz2uzP93fpbEqS9W2lPuzH3qEgYYlGTqSd2v2HKPyf+Y0n7N7oHhi7TSC3PfY6Ft0yWmLxIkgiZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gp9F5NGSy2+0ZFFFOGUUfBr98jB+MrtKGia/pjq5E0k=;
 b=R8q6jMwOZjyo2Wxn3/Gx6jGxZQxzD4D24FbOQ0dRbpi2yZr1uysA/+r5024kMbMMv1CVkcwVUkvEpLy2eIS3dcy/xxFSG8JFckeU8ycq3jo60vDhZiWIArTr73WvuzHbp5duod4Csrz+IroyrD6sSA3R3syhIJilGFishC6Jr0Z2DwPzAkBieohVWq55Hxl2+bgYS4XhTc1AGF3lhWXR1o8FLUdNamQEdoyuSE8q4O+KrNo4FdwyBK4hKnO2H0Nw1LTz5i9B6DnJvamgDzH+2OkIyi55ar0DwKql2wrSfuia3yRbWas+UFEra37yBVF611vtiPy7RPeuBBajC1d8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gp9F5NGSy2+0ZFFFOGUUfBr98jB+MrtKGia/pjq5E0k=;
 b=bQhyVfwLKikscsLvOtQhT73+4CjO/x+4xArY0YXzSaWRbqzQCqAKO9CTTstDrfChx0v7P2YOzfyfG/BkvSdOOycURRfYELzI1L7OxnylZetscq8+1P0FNYvhHgZO7q9zwuw0WL2h6tHndPCFSTaSVDB9p5x/CT0wRKIVQKNz/G3/4BboKlBlEXuRweBcjjL0m51pgBNac8/0uEufNRgr4masYXAa4wCpDBQ8lSFCFy87Zi7/Yp4j+eY7KHeafrbHI/8MbRloRJenvZa85krPqabN5TxLvH2cBJWMtVPQN4DSyWjnR70lp+lDYbrhtyp73jYfIgSejuGtA78DQ2b9Rw==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by SI3PR06MB9209.apcprd06.prod.outlook.com (2603:1096:4:2ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 08:27:49 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 08:27:49 +0000
From: xueyuan.chen@vivo.com
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com
Subject: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
Date: Thu,  6 Aug 2026 16:27:34 +0800
Message-ID: <cover.1786003779.git.xueyuan.chen@vivo.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0181.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::13) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|SI3PR06MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ac19e4-de20-45c0-1dfa-08def39499df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	9DtFvUavnrIkVFL1xVRaSG9E5hbenQxRK14M4Vn7H+C38vYmcpYVASCTpR0cPepmycwrvYyOODVc6N36MYWwMlmL2+AXNCBDNkCJSidG+fpkM52jDSA2Wt83gxdOURW+ELry5XrTho95tHe7ytL1mQPnIO/jIq8vhxZSL1t2saGprLHA65oYtcqFNkpFLWZstqghzRXYL4U4VOpI6S+Y4pP/zPtFzuhyJwooaYmeb3Hm8E1w78Xhcd6GyAVOdoZRybKsPxotIFR1RpksItnSns/taBp7RsHhHl0dUSxigbS5hAkAZE80QU+nJPIHNaibWbmfAkVin7MA2graonPhIlwvwsdQjmWNKxUhloxplVNXJV8SUMlYH1Qd4woCqPLRLtV9/n5bjK6C4LT9LxcsvOpXFg2naQLfyFBpiwEdJb0y25KHRncgYqJ/rR9JJJUgMb39C+u9uEB1o5mwF+BFs1kCDTefLr+AUZ+3EIhWg0UKoW8pI1GQKQ143dxF9DZwYt6bsB3+9EtKOLrpelazu51j+moNZOMTEzhEWMSZbIOYUDpRlN0HvHMjGlst+igCAAQ239t6b4Ms06PHiikqEo0t2EpMoXiAf8PxL8g1+07isd5aW/H7hqS56/roU1C/3m0+ijhUKrO+fb4dL4Pg+/qC5DeXvAFssTBLJJMqSfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?foRC2U2yRSv8IqiuS5BuUF7SyDiQdul3txQtUfBt/ZsNe8JbDufNigtSUCTS?=
 =?us-ascii?Q?InH+QGMs2Pa90qgnnZr9OqSTnIu/AINUOc1OB0c8l7SbeUiaPq4p166UW1M0?=
 =?us-ascii?Q?WODzZ1NwNCvASA8mBsK3bE/8lijo7xS7El/edlqQ3S8py4BU53Ll4WbN7uy+?=
 =?us-ascii?Q?UYkOXPpn0Jg70hMs4rjHYJRiRtcRMQBuMDmnbwxXjcvL000J7a2UcyInlBq0?=
 =?us-ascii?Q?3SlF6JHFn4URAxFU+pYBhq3itaIgwZYZZ/QIyJt2yeXwzPjbzRr8CBsu17Dn?=
 =?us-ascii?Q?DNATVK+cLygYOPBQgA3FSFsHnFHDjumliqJsiL8CmSY7tAtT/poYgnYA2wdB?=
 =?us-ascii?Q?CeCx5P6ft1cnclYazAFhTTNUhs0ZyvOeyYb2wVKZ57QuXYVKjmEDMPoWkfbY?=
 =?us-ascii?Q?d4fRQ5tiSQjGMz/niUiTFW2XkomG/mhk96sGAq/qpo6qP5aKJ6JGqmnRgWqx?=
 =?us-ascii?Q?+mgj5GvjSFXBYN6i7/xNunMjh4QgbzXN/gLzcSjDxnn1rV3wSpzpSqlSqyeZ?=
 =?us-ascii?Q?X0JvSLaJPfdHrZ14He4H2e2Am+/hjZD1G5Hv3qM0w0qhocPtJyXXevPdY6CI?=
 =?us-ascii?Q?5XWh7+ZRNzH6ATjcqW6tkmShGWcfVx3dcNy7i7rlgghhOXeNQXsqu29jN6co?=
 =?us-ascii?Q?BY799+vF7fWkWE4Xe21vf1eb/aDC3BHdJR5N9dOFW8NtiIgwk9bGIZyQ8I+1?=
 =?us-ascii?Q?XJ6O6Oi4izBt7Dm1Gdt25jfByzUY2jtgUwedY664c0gjSYskEB1alGfZlvs2?=
 =?us-ascii?Q?NSgcHcissBNKXmhXmoupYT0JiGiswluHVQqgzvM7Qy1f0/CrcgHyO48xFecX?=
 =?us-ascii?Q?Oy/43UZIuZfWEA9BhrVBfN7Rz8/bI4vIXSoXIl/Q0xx/shtE4UUToTN1E3g+?=
 =?us-ascii?Q?UJM1wFiAHUu38hwnuRn/oR6pvh1kzU8fBs7LRe0ynlBjiLWST2gz6n70v1CE?=
 =?us-ascii?Q?hUqAm5+7vJVInBVbXtRw5xr3GdfvMn6SYYLzzs5SmiTTV9M66nYr5cS14j6l?=
 =?us-ascii?Q?JJA1KvxIoa3uWdJzNM5NvSA91E/CXO6Vg39D81f69KQTURb9IqQP0kIfaM2j?=
 =?us-ascii?Q?Ufu9qIhNzq78sQ87Vyq9elcYfBk+XbOwB5ivUGdRWcmSGivihR1BJOVviqyF?=
 =?us-ascii?Q?av0W8VabLjErqm8oK24+8cZKeUCVrLe1n/Ra3lrEtktzx0GfAmDC1W3Zvc5u?=
 =?us-ascii?Q?dltBfe7607Uk+zP1yIxugekzSKiop/pqVC0NA++aQgNV19xt7iNulgPQd0F6?=
 =?us-ascii?Q?Fxke7DcKNyX9Nvc8+40e/xxq9qGrajby1tJ9IrCkSsK7vEFNl2O3+XqcqWKv?=
 =?us-ascii?Q?rmxoc7BdMgzBDcI59EPlr1sgN1XR1GZZ3ds8URR2/Nr3OMYVSMyoJ4uXKzEc?=
 =?us-ascii?Q?gFaFEOr86jUfvQXIK2E1orDsps88G0Kl1tH5nD5P/776SYlHihm4HykMmQ7e?=
 =?us-ascii?Q?zG4vn0yzXDURththrU6pCqm879tpqccdwWsdcMoh+ECw1XZwt6H6qHLeg3/9?=
 =?us-ascii?Q?XuWiS92oZjPaKitsoc0ydFiVjs3D6TZhRAY42EdYKkRZy60L3CNBFrzGyJn1?=
 =?us-ascii?Q?Wff9vhFDtJq51EsaOool9xdHlX9yzQl0X4sadrBO4kBTrsUVANKJoDdzntw+?=
 =?us-ascii?Q?uiCS99Too5v2559X1HvUWir6OyvUtiuUZAB4d/OYxOQz7uPO8C0ijivhfrHo?=
 =?us-ascii?Q?0Tcqt58YMqXWhKyfmMNHztkTDt5J6EDUOgOJ+OPozM4QS+wLKSTdTb9xSg9w?=
 =?us-ascii?Q?pIBDu9yiBA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ac19e4-de20-45c0-1dfa-08def39499df
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 08:27:49.7148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AaHN278S+rjHkWBDaH2c3FHUJ4BolzgUuNHg30qDE2cLNBfCn0Iw3yf9v5TYgVIFNmUBBb7YIbZ0LsUaTg5Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR06MB9209
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 926A5140004
X-Stat-Signature: dphwkfjnf9udkookjmt4getz4fekcs49
X-Rspam-User: 
X-HE-Tag: 1786004875-957351
X-HE-Meta: U2FsdGVkX18B6DsVaybU54gowseikiTsoxvmst2KNkSymSqIYFpjg+NpYeZrOf3N8q0DuHFFy9Ip+icT8FUB09J40YnHv1RpVCtPFCzdS3bz94CJ7da5qsKzZlbuayRrjjewNwxLYGv/5O5VEjY4eXWiLGw9jWQ2WjhotLdz3g0vUUR275vKATnTkgfB71jkwYv6hWOJ25tLzr2GpSoOHTorWRmZDeZPXud1xyL8RPdYq6INenp1rmUBxrq/JuEzkJu4H0oSlxNgbn7BDu21k+D5FuIxsvBbGnMz+Qzr2JiA7feqzaRXHCnu+UCfN9JKpfSyzrp8iQvvSJmDyg/vgEDy1bqlu7XsBzjFkRDL1WkPKwWByuId4QgAY66oh2JjQ0WT9W4p1N9Lc030Zm2K17GH37nDjth9zLMvbzqWO0hCJwjCGL6mQGcJaEwfGIx6jTFJwxRpiH43/R4Lm8xpTS4rIxDa0HIA3sTyv4wLU4qWSbZagSq6xI8BwzPsWqiZDiAW91uPox5qV2+nYUFnfZLe+RDZztKttX23OeS/rlHhWE604dfjmu843eRpnKNcwtpPYg3TLk374I/pEb7h9ITtBbaI7Fph9ackVLZZqof5lgGG0QVpXBsW6ldTbc8AWev2G1td6babOnZp7bcmEu097mR9N8/Neftn/J0VT4rlI2UuNNCQyxximB3Fr5R9OX5CRL3zskEbHQUNXhfbmTiuFWM1njtl/ARWtRAFcVEbVdwFTICAjGBqvS10FKMovJ6+rkDwIdOxjB/W+QpYG6Pzbu2WQCabvbV0FTO+5z7fi4oT+ng8I1wpetzB29WsxzmGny8uBsCw9+8dYtn6wgf/riBFyTDoL9NttkgDothi/9JFuRkaTywXCKBMrn8P+LcBxmYAore2Fi/cGJ0FNHe8hvJiVCBcW2uqG1pRCQLT2hZW0/D1gQhg8/ERPlRWzshfxqYHOmPzzJfM1UY
 cgCbYtGg
 9IMNVQmvHJXTfmf7vQKsZ3EMgjMbDUgOiDcxZ448skmjmn+dwYsSw3HOBQJVX3R3a0g0ZufadNE+2AmnHmGKw6+lQUP2bAcKLYV9kXl9b4CVX5HCnBcnoFMq5KpIG+u1MwlmM9quvEz/FeB1g5zmKRe+Os391RnCVPgUE7SjvLreCLZAcnSYJridW+aOBBkFySvyIk9vhRc9gj5SqMtK9XkyWvw0KBfqCpBT2hiCKWWpVDGduqaTyE7TUOfx6z6C6qb3pE2bc4TqhIiuJfJKp8GBVrMJyt25DgBjRxz+b18eH+JDEySOrEauT54WdyTRCvlUqxNEnx8rloQMiSnPfFCt8SfQna7j+R2aTmJO/si/M+EZ5pVUsG5VeQLAYfKYpLJMFzBfxcHOUfGQ8NonUG3z5DTaScaVmaTRWjV1ypWjKtJj7ogr/hqTsiTRu94kHplpqvFVQKHtq7lzbgBttFeRBjbmKAyI28fY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen@vivo.com>

zs_shrinker_scan() currently calls zs_compact(), which compacts the whole
pool regardless of sc->nr_to_scan. A single shrinker callback can therefore
reclaim much more than requested and spend a long time in compaction.

On an Android device with 12 GB of RAM, observed zsmalloc compaction
durations had a p95 of 38.86 ms and a maximum of 269.68 ms, motivating a
per-scan reclaim goal.

This series uses sc->nr_to_scan as a reclaimed-page goal and keeps a
per-pool size-class cursor so later scans resume where the previous scan
stopped. The existing full-pool behavior of zs_compact() is unchanged.

Xueyuan Chen (2):
  mm: zsmalloc: add a page limit to pool compaction
  mm: zsmalloc: use the shrinker reclaim budget

 mm/zsmalloc.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--
2.47.3




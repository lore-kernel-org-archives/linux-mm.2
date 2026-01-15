Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E982AD4661D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4032A6B00D6; Thu, 15 Jan 2026 14:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1546B00D9; Thu, 15 Jan 2026 14:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A21E6B00DA; Thu, 15 Jan 2026 14:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5076B00D6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCFF4C1D51
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:40 +0000 (UTC)
X-FDA: 84335207880.30.CFE5939
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8097D80007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n4ezxbX5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hdZyXPiG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhJXAfeIUDKUJRyV6rbMzeOsQaHKiwPaFULjDCQZPPs=;
	b=AgECDUY7L16tP/RbbJpvZe8fiGqjEnEJkVcxE4ZYHeqqFXr5UDkv/we0oYnd2GG7TRrEzy
	QRqcxIhMqgl7LCLSOO6bpcYIVwBUkiNuBYullCDsWKS5kSahcg0XPyFLqVcZtvTqL7oXtm
	qcZkG4IP/f5ZWWbWYk+TQj5B8TgmTOQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n4ezxbX5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hdZyXPiG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505857; a=rsa-sha256;
	cv=pass;
	b=XyUhe7uYahsx6aFzSqdvtlyNifsZYYPQrrlFnXhP3xmSEpqE8xSmU/1VMN9ZOPVZIVtPcO
	7ZNR8nR8HXwQW8ii4z+CscSHGNJnxMt1bZCpdMwZvuyeLgHtQbCOXp0KCNkfMT5qaTadu8
	VJTI88vQIHIcF8ILmF0LOgzUic89iaI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGC4J91360856;
	Thu, 15 Jan 2026 19:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WhJXAfeIUDKUJRyV6rbMzeOsQaHKiwPaFULjDCQZPPs=; b=
	n4ezxbX56vLxuzCGvbXmG3t4uf1k5bO3DdAs+cAjv0W8fBdhsp+wtGdbv9pGVBC1
	xPRVw2BangrQFgvgY14El7RKiHfGlOyIyk6PaRCYCfJUE12D2afcbSPOICg3FQlR
	5CTtQAOwLSESMjm2+CUh5sx4cKbi9q/tLlTvQ+x4IiNO0EDdmhucMUJJqntfMrds
	2SKWvrbk07EnGKiUmiRbvq3GhqzrpQu8qiq48sBlxfYzM2436LU9+2OTOcOloukw
	FCSf/0t0kda3FwDYgRB6XZGnzBmoioEA+0oyQEok6SZW1yqpivuAYLiHkN8oVYEb
	k9GSjj72ro0Si4pOmdKxTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp3s4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJP28M004237;
	Thu, 15 Jan 2026 19:37:29 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngucs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/vcm3rxg9smcW/QmAELpmGrXHi2ekq1MiOU3jvfqck2WVi64l2txvGGlUjCvayHP4u9wFVZWuw06/lCdFnymnk1dSZRISqav3GRSBzjKuZ2cdHY1WR36s9npfJwieEI76o44yurWc7S0qXYRfoVAR5mON4CKtgeZ61YdLzpmc0WoKneJxBpruVo2NsYmUvoneYYjAksXykKbL1c3YkkPEIAU4JXweRjAAwAuc2D87n4DDts8/R5LmfSEFEoaK9bggf/tZzFKYEOeudCzwM7ZgKNLqVIn2ul2XphAmscw6V6xUf4BqBTfI5xvjmEZWnJkMR3I8nZbsGzGGXOi3Jg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhJXAfeIUDKUJRyV6rbMzeOsQaHKiwPaFULjDCQZPPs=;
 b=uOlABJsDIB3iesdWAXwf16mzOgAeuDwT12A7kqvPznTnvPXFz3HM0WZhl2LtvmpHoIFIXbUioIylzpCeI3t2Wqmz5y83WupDobeBFV+EOoOUDYaLqFb9QLldGwndykTgxrphBqPSGNw9/Box7wFND6DiWM3MI0aqKN8lXDuPZIENqA7XCKJAHUZoylo6sQIVlK+Q0kVys1TtM23lrOW0hIs3p3wyHysuJ7iByiraZF3R9lqgAeHgwSJffopZv9q8Cmo71lV8fIaI+SHmoN5pS10MGjwJ5yMffZoSaoahTVTzYkcpSljuh5MsLc+Z+UYH8FZG1eFuAt6NyRzGjzq7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhJXAfeIUDKUJRyV6rbMzeOsQaHKiwPaFULjDCQZPPs=;
 b=hdZyXPiGZuD5mTRiHu7sZTbe3e7ANIr412DHW3OBqBQxPBoJod/YrUXDQnoV5307rSO4Ccr7OwS+53KaT4sAthEjee8bMO1E0bHnLoDwFTXRR8w0hS4l+PlUDLHW6HTZG+p0ApYEB+PVebFIg9/bcusPXb8jTdv51pAkkV7Kxic=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:24 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:24 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 12/28] maple_tree: Inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()
Date: Thu, 15 Jan 2026 14:36:31 -0500
Message-ID: <20260115193647.1695937-13-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c4d51c-9e62-4bd5-694d-08de546d821e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RoI/FHMN7+y2KTUl0PZy4mIW8WU9Y9KtlMzK09cIQVRZ7TsHF3WDqiavptKq?=
 =?us-ascii?Q?2O+GXlX/mxww+7MvW7HAQAsxa2dkaHlH+wkyQBGKu4tfG0aG5VnM2HraoR9E?=
 =?us-ascii?Q?cLGYGVKoRS9mE8DOZ3UZlZzHoF0/M3GC0vIeFjc9I6CAWh5GMjfkkVB+CMjH?=
 =?us-ascii?Q?xAzBT++4GmNgJdVrK+JTm18dIWqmtmiGvIjcr0pYEEonYjDsyw1Ud7upb11y?=
 =?us-ascii?Q?inJU3fGH8SGtc/RZB8Wu+4Dn27KUlJMZQyHrY0rISfVBIzJbqv2SGGLxCX1g?=
 =?us-ascii?Q?c6SIpPTmIJvzGe8EbLCl05HrJ2LoVbBxhunXvNh2rjSBQe3C1/sTUauTbSqg?=
 =?us-ascii?Q?btEaHKHWZ+6EybybPkA5NmQ5y72yyxc7R04vW+wH8FmF6emvkzMoey43pZ/s?=
 =?us-ascii?Q?XmgqcOr+W2J3rqErTCGRnJrRjj5PaTLft/SfDQNYFN3KMSpA/Spsv2sczRXP?=
 =?us-ascii?Q?ZJFMbRAGrBi2SSx/DqaueTAxnLqtq/Rx76Ua4gADLRuHZ7QbgEzy1hP/WMo2?=
 =?us-ascii?Q?z/kHJTEIDK5UmIrpvb46Kxh5tUD/k66yMysnKHl8KLpP6ao/1HSa8/pODLN2?=
 =?us-ascii?Q?x52ETltcUcLwiWqZAy6TgwkMzS2raCKdjQ82GWU0e0hRmY2y00JbKWhVDsia?=
 =?us-ascii?Q?zsd5QBozkukxIoeXhTQX0/VG014jNyQwLjPfePgc/nURMa4WtTHy6eO61wf2?=
 =?us-ascii?Q?DGKsxjkeWGP0dobeIPupgm8/A5xXU1W0qtawZlkB7OS45YlKimqks4Jp871M?=
 =?us-ascii?Q?V8XxWxHQWvckhm3zETHf194IGny9D0gq169hOhxGWOUMMyHLMkJGvWepFkNZ?=
 =?us-ascii?Q?zDGU+22AmYUGoWGW5d5/loHu++R2KaiE+2OKu6p3YX4pH4A2c4agAGusVEmJ?=
 =?us-ascii?Q?b7BGMaYVqwXU/++4isEuA6vvwtBnMiQzW3rAsURUGkORm+dO6fxSc7LDhWSw?=
 =?us-ascii?Q?woAHKjDNGKg7PDs19KGwUC5TupHUJgV7UDtoReKX5s0TkGrHHcwvBmhHtlMt?=
 =?us-ascii?Q?jn944OxIV/dxPdHdHbuxhGB1pDV5m7oU0wdNJ00cR/3+Msj1v6nFom5cm7nN?=
 =?us-ascii?Q?Mt7vnLWH76pb/1b8M01hiA5uecKFiFcoEZMDGnnaHL56M3QYEj5+gi068YDf?=
 =?us-ascii?Q?yHE7jCsm4XtYMhgw7I1PpZnlGZwSVYKbbed+6JqeV83/KraUBfQyyvVVict9?=
 =?us-ascii?Q?u23eUCMB8drBS12BYwr3JZEndriGdCgUPB5WViHYN1va68yk1W44Rm4erZxt?=
 =?us-ascii?Q?EGJkFr8g4bePhTfudJC6ADa4xLHfTdQE+/cXdo2n4QStvzY8sR+sSnkgSFKx?=
 =?us-ascii?Q?eZa2qvV0w18DNKE5w+DQDs68nj1RlOb6x8R8dr04Y60ne6FM96stnTr7JFVl?=
 =?us-ascii?Q?u/Fd9iw/pFIa0HBdKZXgtOIHG3XuaRyPQ7xSzpU2wGMROiWA4WYyWN+A0yad?=
 =?us-ascii?Q?NKcgYMIzb+6frekNCHhB8sJWl3Ozn8V4m+NgHYw7DQ+U921YAjnU+WRsWsbX?=
 =?us-ascii?Q?VgFNegA5LxVbIlQz8c4/hYJZuQQxxSDwu/zAQr4iPZzxxOOaUAkHyKgX64f8?=
 =?us-ascii?Q?Ptvi1C8j2G6dYQzPF4c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUtTUYxVQhWjyqbaRbUbcm3XDTgTQB4waToF6og/55SuSPGtAHzOlRHNbC0E?=
 =?us-ascii?Q?0LqMwAh98Ikmai4+t0HGGOAgHeYVBep5CaOqYDy9U7T7J3RTU30bi0CoBRrJ?=
 =?us-ascii?Q?ZPBjhzasOfVVskXWH46lrvujgp/MXjXDgAcEcsBP7ZafqEc9DmKhiqd9+7Rp?=
 =?us-ascii?Q?nl/ewxCU8+HlGPMkcLhtbpqgzGOhzwEqNb++9AMIm2C1xPkx+/x/7UrqvmhO?=
 =?us-ascii?Q?aBvGy01sItZ7R9esodX3Mp2IStWPK9dIQDXbjbgnxMYrdpr7hgNLP/cYY4N3?=
 =?us-ascii?Q?6YSNPHytTg8Cb5+5gIdirnaepfBEGYEeyLmAhCQsCVbXvnDkV+EbJLvEndTj?=
 =?us-ascii?Q?GmKyLsen+0VBF0XVyvAPU952nO2D25fOjKslxFXYwwdwsAz1GSFeO/NFkEAn?=
 =?us-ascii?Q?+n3sODG5ZJQaMsF5zmM078RM3Ktl8yWsQkmhQnREVwLv5pQpDvgCIhUpQWW9?=
 =?us-ascii?Q?wJMuatPiAZnRzfCJq2HU8rSDIhksi5xM5M1JnyjCYGgO0wOHMiwOxbpOukvE?=
 =?us-ascii?Q?JcZVy6TAJhIcU5GIovxWeAYZ2Nl6e8oBknqhhI+wpH1jcVel5GmrFYrvxZdb?=
 =?us-ascii?Q?Xw3ZTPrZl01V07S+LgT9Vzl/fjrvMNe/ossgyUFZEwOg8acSnXKelFVNkVaU?=
 =?us-ascii?Q?mNryq6/MHIgo8Kn0XaPyrq9uK1DNqmGAadSLO2+096jSSouGczarLtoGJXVo?=
 =?us-ascii?Q?Ym7M2E/VwkRZ7Wceff2QzkXbSIAgihbjGwvLEe6M4CrngZAAVpTwxs1kAjbm?=
 =?us-ascii?Q?iNsgN3FlVSdDsNz7AlTuxlmr3ml9Fe6vpzQjYzKUTVIbyaZK0KE7oToTxjiG?=
 =?us-ascii?Q?HtOYe4QAVBiQwCtwUuXbPsBE6O+RC+Qo1puRwucAI8YApSmZQ/nVKyiy2jTS?=
 =?us-ascii?Q?IcgPFIRrngCIp+Wrrki3ndbGdwBpL6tGLosTp1+wk7ciUgNJpAtVPRO3ffL7?=
 =?us-ascii?Q?2WMbe1Gl/Pd/RJilzTayLISEZf6BJh4TkgaZ1UMj7uusq4TwL2mxbP4iaiv0?=
 =?us-ascii?Q?zASLRBkQ/M+QfAq0A63jcYRNAbjz0PB5/BUb/a3nq9KyqIxDMZ1WldtLheHf?=
 =?us-ascii?Q?C6ZeTAD2+PLp3vb9rnWWKbRADzIdgaOVRKydzuyiFN/MznZLM0bgnTzxd4lM?=
 =?us-ascii?Q?O/mk7E/iYg6+d7OXrm/4ao/U7YSPmGE7cQtQUCLrtl3FBEK3SYB/Uvp+kR4+?=
 =?us-ascii?Q?m7MKq2hAXOXxal5Xp6kJmwpjkyPUj+UTEvSLTODUzVj1IA4ceuOI4RYv+9Zb?=
 =?us-ascii?Q?4kArfz2vUHrobbcpIux2jM2wTrdRzf1B34TjNFdQ7wgbuQF/3HTO50ebcUfr?=
 =?us-ascii?Q?Hxf7Y+Go5VNqtOpQf6T79Krm3c4QwFO80+jKjGtYa/TjBj8r9Y0p9gro+4uw?=
 =?us-ascii?Q?Yy67pVR7Hpu+MESAqtHVoJPK7ryD0FHpURNN1NMnZOFFXDLpVIooJ302jt40?=
 =?us-ascii?Q?35ifu/F+sKu3WsNAZTRfIjDMFt4xm9FbHsA5yj8eOhY5+NXK15LgNLgX78Ex?=
 =?us-ascii?Q?6H7NqT9GuQXjRKza7K8Un8/jE/1ucrv4TKFG0JY7Ov2Uj4OzUIp8ZFfy4YfX?=
 =?us-ascii?Q?V3cfYtM/jiAnhe+6eZHDd4/plA08DjKFZ9z/Tqik9bcUBQ5d53HxlaVHhRLf?=
 =?us-ascii?Q?HLOce4yJHPjf3XHvsPLa529YxQsgHTpqlPDBprJosAwjqAQqcMsPwc7HTsPw?=
 =?us-ascii?Q?uTlHF32o3z7ZvrNk/v3yJi1O5lM4FvYcxIOGoe8qTr9u64xMhWYIbG39xZkn?=
 =?us-ascii?Q?H8MgBFJIWw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TVNS5nO8R/lSuYMXtdarw7D6LUfFCkIhfE0FP8XbZOLfRW7Wi/9RyUV5Db0uJ0lYfxcLZEp02RigXcHV8cS3jZzyIg5XfRjHtGMATPVmCLFcax/2rDIHEMRrLQWW2qfV45xNxIixEygGcIuyAvZkcjjB2s9MpQ/HIqV+8nQ2H6SErNXUeSdSbQJjqR9vk6sxFkqjSnvw5NTcAuRd5qlL8lPhMcDkWdzIZm75rd8D9pJcYwq1iR1oPGl6DMnZ1bUzwW8qKtu/AdZWVLHYLcQdr8ZhbBdp8VwavOWbjj/6/s+6062MMjnKVdC9smiK4OLs9kry6+BjXla/loE/R/wcpsz6F9k9tkMR666ZYV3kYehMugrYGxePWeNbNsztuA03iQEci/isWDHfiy5YLfR0gEZoiqDKAaJVk1X39RpXlfimWjILfR3Mipd1wsIEqWroTQMA0Lpcqg1g1f73VPNPFyHuMdIi1ejRLOT2H4BV/73MfQtxb4jlGUPubgZ9uSMncgCEgh2u7h+CjAsZ9sGlbOsz2m5GVANy01Pd/WXdT1fXLUkEX8VcotjXR1+I0zJ5kli1KQsZJ14f/YAIdfh6QhW0ZN6h5IAqp9MGMMGw8I0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c4d51c-9e62-4bd5-694d-08de546d821e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:24.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKmavrldJIfdz4QRT2I1WgHC/2Or/zxpfAVJ8BHDSsJlbLFGLKbbAZ5+ZVcOl57gqENvF2X/HV/XNtAcAsE+qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX1eBdfEiTU3BG
 BHiUKHd4+fC6dLFtxhSNQMyB9y7ciaU+9DFl0tVW9W8GpI5glesE3CzrCpGLTmiHjhBiAIdTVg1
 hWcIYxDSKyO3kZb2lEMCe8T+Stu7mFHlma+itIJ0RvJmCI31iW+0oDJhbU0lnC0h7xv+z4BuiXx
 wCFfSiMHIQ/Osa5ElrWwEL2hbdfPO6bwIpc33y1AZYKNPXF2vp0LdQ2rEGBrJcpGqJozte7M9zv
 VL6coO+Aiqo8vbObmOg9EDAGDwpTvMtAOS7DROf9xwIGxc6uLDVGnD8tT3O+xF8bAZOtP0pXZxg
 LqJ5hhFHh/qV2c5DLuc3AsDCQ7VxmAIfmpqO/qNFzLD5o700yoyA6ZvLtC9x11JJMuLvSVogsty
 lcScsY0i013ArAOKIMbAuPf39PA/tY8uqwpXe1CFUAwz89IGQr6v+mJ/4PwPq7kDUeHMKctpZ80
 VAAlxY9267fK5TQgJY2qMc1GzVtLTiOr92+1SFAk=
X-Proofpoint-GUID: hH9PhNNwwa8WS5sY40Ohws_7uXE9mcPb
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696941fa b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=SVrgk92_VGy3w6ovwu8A:9 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: hH9PhNNwwa8WS5sY40Ohws_7uXE9mcPb
X-Rspam-User: 
X-Stat-Signature: pgiq1haiic6e8tdtr3wigsi8ofnobwqu
X-Rspamd-Queue-Id: 8097D80007
X-Rspamd-Server: rspam04
X-HE-Tag: 1768505857-622153
X-HE-Meta: U2FsdGVkX1+es1XcvUm99/fYV/v5X++8uB9RIEkIla9lsik4/j77jbyUkyvZ85oEUpKpTbH8EqMb57R5+OUfNXO1mrO+JA1V8hD+uWmBaOuZfjFQaCeYxFvlp+ZavMWReEJcowTHdZBzqX5JV3yo08HZz27A5ogjmLZ8pF9NMVu+0VKWBW9+hBMdxsb/FTgSPl2P9Si7feihEM5BOuD7hf72h4reWEH+rYVDpji+RksNXS6MSYEPMS4dN7j58SMALzCqN5d/3RxyanMZN9+z1ku3Xl6Pe5cl5FfyKIObry203Y7ZE0MFFxskLqHzy6v7S58BUvyNLZgmtogHvXd6/1STyu/96LW+3FXqNNK4VMzu/izVfppmsHxBWsu+jtte9R/+/wEdLWt/Zo2DtFl7lN3PhyLnvjp2Bv2dziz3Vb7fVfDOqzu7sBsIrAzkas+dkR+lsdMoQ6puejerbt4GF17+K/W/fXyykFS/krJ0cgmxf/92zkwoLMCE4UU0bqaimj5gS4bLoQjtWUxsXV4Pzv+LGbSaSDb/R+PyZ6rpK5Jgo5QHSqcw9B65G7lk3NHZgJGKDD0+WbG3SyTBn/s+fon6o/VpEY67oUFC3Coo4V3B+Rp+c2BbbcHmk2urB6X4shP8L/FfT9giRg5Mdv5VzxpjHt89exn+eu+mtOLBVjT5rzL1ZLoRfNkM8qMJIMMCNdti83NpVnQ+pB2g0uMgDc6bQjzO8uCKlGTOIVfVe1oi1ZCO+B1cboNGYgYl7bmBwTQL2t7C8evReGqnSs1LmCC2iErKNOnieCHZKTVY17IVChpMQ1g3vk0KAEx7+SuRi9LDG5YFAEh6PMWuCEyDZb0UJO51y6zIMr6A2Wf8ubkzLfCTmZPeR61arlkB2j1tKitCZjxXOgSdWJDaNjE3YdVMm7YAsMMSOa6Q3JgFWlo/ZpavSaQdv8F9IiL5zJH1MDfW6WVsjtfatGiT7i/
 CF+VLsv2
 9pndDeu+/TGOrvnzbR0DBQdfb5dise1D4bA+XQxjiaz0RoiDsogYUn5vxTD3lr1AVBwLnr21eivLYHnV11lyXimEqFL/KHhKNbCgCPHAWclTpLSLjUHYaWCG3Y3ufeZW9GNsG3Wifl/o07Q0MAETzZlmBALFEhk2yh09RBXps6nCCtO/8eUmjJbv8dUX41At7AQfb/YkDOO4UR1nxiev7ksWKvyVdLLS1TNB5tp6rji0yUmFhceC4bYSo5lLd1aqOffagFXXpjavE7aQOV2jAGRoArfQdRgM4VRtp+BgNgR3lUzmpj/D52ojA9LeYviEjmRnBwHIso2SH6/8aWsGnX8oQneDrsR3azQWbCzab9oPP4cJ86jVC130WMCbiwsvH3/NzTrYjWBD/00dVe1wyNMvi+fX+F7DzpsPOmw6qG2MfBJBLr3K34yuOLOMkUtcJlEd9GLUoJ/xnFPL39m/cOIFVp/CH03JOXRyvhOTxABVcZpWOGbz9t20OfwbbkvapDnrnJIQYL+RuA9UU+OKC0Ipv4n4eaEYkM+xbF3yL+OF+eviNVMZYTamAMPISj7m8JKNQ1U2ihMO6Fdl52ldYGMvgQXSTgC4SDyoatGOCuxktRwMsBFgXIw4uoHh89QXi61NSC95/1VGWVg6Jmdo8on/WqSL/fACu0C93edPJziYVxghOKMJClWZrql29A0psIBdx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just copy the code and replace count with height.  This is done to avoid
affecting other code paths into mas_spanning_rebalance_loop() for the
next change.

No functional change intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8927e8e1b8012..969be457f6df8 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2855,6 +2855,13 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
+
+	unsigned char split, mid_split;
+	unsigned char slot = 0;
+	unsigned char new_height = 0; /* used if node is a new root */
+	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
+	struct maple_enode *old_enode;
+
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	struct maple_copy cp;
@@ -2910,7 +2917,106 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, &mast, height);
+
+	/*
+	 * Each level of the tree is examined and balanced, pushing data to the left or
+	 * right, or rebalancing against left or right nodes is employed to avoid
+	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
+	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
+	 * will have the incorrect parent pointers and currently be in two trees: the
+	 * original tree and the partially new tree.  To remedy the parent pointers in
+	 * the old tree, the new data is swapped into the active tree and a walk down
+	 * the tree is performed and the parent pointers are updated.
+	 * See mas_topiary_replace() for more information.
+	 */
+	while (height--) {
+		mast.bn->b_end--;
+		mast.bn->type = mte_node_type(mast.orig_l->node);
+		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
+					&mid_split);
+		mast_set_split_parents(&mast, left, middle, right, split,
+				       mid_split);
+		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
+		new_height++;
+
+		/*
+		 * Copy data from next level in the tree to mast.bn from next
+		 * iteration
+		 */
+		memset(mast.bn, 0, sizeof(struct maple_big_node));
+		mast.bn->type = mte_node_type(left);
+
+		/* Root already stored in l->node. */
+		if (mas_is_root_limits(mast.l))
+			goto new_root;
+
+		mast_ascend(&mast);
+		mast_combine_cp_left(&mast);
+		mast.l->offset = mast.bn->b_end;
+		mab_set_b_end(mast.bn, mast.l, left);
+		mab_set_b_end(mast.bn, mast.m, middle);
+		mab_set_b_end(mast.bn, mast.r, right);
+
+		/* Copy anything necessary out of the right node. */
+		mast_combine_cp_right(&mast);
+		mast.orig_l->last = mast.orig_l->max;
+
+		if (mast_sufficient(&mast)) {
+			if (mast_overflow(&mast))
+				continue;
+
+			if (mast.orig_l->node == mast.orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast.l->offset;
+				break;
+			}
+
+			continue;
+		}
+
+		/* May be a new root stored in mast.bn */
+		if (mas_is_root_limits(mast.orig_l))
+			break;
+
+		mast_spanning_rebalance(&mast);
+
+		/* rebalancing from other nodes may require another loop. */
+		if (!height)
+			height++;
+	}
+
+	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+				mte_node_type(mast.orig_l->node));
+
+	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
+	new_height++;
+	mas_set_parent(mas, left, mast.l->node, slot);
+	if (middle)
+		mas_set_parent(mas, middle, mast.l->node, ++slot);
+
+	if (right)
+		mas_set_parent(mas, right, mast.l->node, ++slot);
+
+	if (mas_is_root_limits(mast.l)) {
+new_root:
+		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
+		while (!mte_is_root(mast.orig_l->node))
+			mast_ascend(&mast);
+	} else {
+		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
+	}
+
+	old_enode = mast.orig_l->node;
+	mas->depth = mast.l->depth;
+	mas->node = mast.l->node;
+	mas->min = mast.l->min;
+	mas->max = mast.l->max;
+	mas->offset = mast.l->offset;
+	mas_wmb_replace(mas, old_enode, new_height);
+	mtree_range_walk(mas);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3



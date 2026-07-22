Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE21C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74E66B0093; Wed, 22 Jul 2026 09:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25256B0095; Wed, 22 Jul 2026 09:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED626B0096; Wed, 22 Jul 2026 09:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C77A6B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF23A80187
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:03 +0000 (UTC)
X-FDA: 85016427846.08.1A0E91E
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021121.outbound.protection.outlook.com [52.101.65.121])
	by imf04.hostedemail.com (Postfix) with ESMTP id F11324000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=q+cEWH2y;
	spf=pass (imf04.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.121 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hU9N7RJro1EafdxIieaP5pTIaakVSS68ZAvN4R4veso=;
	b=0P/woFZTSvIsfCTP/wO1jeGiPlnHWpVwgTD+NqBQf3w+AWEzigNoWf60cM5e9b4s9Opx8I
	cXbMThBzDTyGxs00US0Of6y+RmMR0Ak2+Wrx1sidnRbGHtbC8dGKtC2VkV/1MFE5oAO63g
	7nz56LyDZHaZVbx4CysNH0V18oAEDoQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784725381;
	b=H1Rs990mK9HNJU8TCZsSINgn22UV1chkUi1c84JfUHtQlXgg4gZcOSAYaUtSwsG43URwA8
	eJDMMF+2y1ZaPo39UeZYI6VSYmd1Rf8QezEdVYt9j+5Ajwth9Xwmj7yenWVETHE5zEf7ZD
	B35pWYlCyJXpAf7jrYeP9ZuzaZbwQ8U=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=q+cEWH2y;
	spf=pass (imf04.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.121 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6q5mnsORMv/CWAfxwsFuHIlUdLpD8C7I6ORv2GPdFhWV6NULXbwYyUa+tawxI6rjLd9beguWBBBC7heLxEwCI1Xm/PbLI3iJDn/0+ArWuVwjSCWhrkEgYNHudu/mKyykRLRdpLg5C15SDCaPatoViJgoi50etg4TFNAoXTXj9dvnvgXuZLAurkY1C/DfqWzKEEwHHA4PexwJEYy6JnMymbhZ4/6wGJs+DeMKoonnXr5G3Pxwgp9I2SWQYjYN6rLf5EbfXZeG8n9aQwYUsAeZHf/uDy16xDxFdu9oj5+SEVBv5K1s0Wv4AdPUe5DwoEuytXmx0GXfknqF2HslWZfaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU9N7RJro1EafdxIieaP5pTIaakVSS68ZAvN4R4veso=;
 b=w9Pz/tEe1KQU1c9QLn6rwSPFPgZgBViecoqqhJLOChM5FrxfhCJhrKEXw2y+3qUufys/wYAzwde4aV4dUjuy3tlWvjcqj2efPFxhqS54uZA+2nLFtChhkpa3bLByrCFnK3ZbQe6DtgvZqE2byRdSRBPVuw5eAFADULskCKHGxcy1MVRKFHa3I5kuGKtFPAEw97ddeGT7jiDYlnreWz2YrvMk52iZ5ts7M1TuMoEupB8VkhZ7rqURi139Ttt5ouBQhARTVOeZfn3O29+d1injfbLwLlRHD6nsefyaBz4hZiVoPepOuE+TZc8nV5hWpystK0ScWujvJ3ooPpocADpZ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU9N7RJro1EafdxIieaP5pTIaakVSS68ZAvN4R4veso=;
 b=q+cEWH2yIK9tKOjjchm1qyrqcrivBxtNYopMACNHGwIDZ2qwyOfCzfzGoC4NN1a7GD20QZZhMA6hpLMBoWzg9+rLI9W7Xw6VPMrSEqe/lMDNCImqbGYape9v6oC9NYvdUa2TvL3OoczYY5DqGV285Rxy6zkSXpQvwf6drJUNmZcGkpod9mAFykAvTNyao00dUcR7TbmLBbETZf5lpyKinM2sXNVlkkKxBRcRyT+kf7SjmLsQTqhqvPf2tFDj4OeAQ19fFTXIrv5UDcKlE7ytkQRQOcE1iLN5IJRTn63BOUXsno8zGAgy+nqlQT1o5rYjtoaK+Cdb3eex7+cNBOOL0Q==
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:17c::14)
 by GV1P192MB1739.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 13:02:53 +0000
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3]) by AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3%7]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:02:53 +0000
From: Chris Gellermann <christian.gellermann@codasip.com>
To: christian.gellermann@codasip.com
Cc: akpm@linux-foundation.org,
	brauner@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] selftests/clone3: Fix wild pointer access of getline due to missing init
Date: Wed, 22 Jul 2026 15:02:45 +0200
Message-ID: <20260722130246.2135563-2-christian.gellermann@codasip.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722130246.2135563-1-christian.gellermann@codasip.com>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
 <20260722130246.2135563-1-christian.gellermann@codasip.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIVP296CA0126.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:358::16) To AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:17c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7P192MB0787:EE_|GV1P192MB1739:EE_
X-MS-Office365-Filtering-Correlation-Id: 82cb2554-b706-43f3-60e5-08dee7f18ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10070799003|6133799003|22082099003|18002099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	SFOR+lzzhdjQ4xJ2tHu59S2uMYcNuHZhTnVVEi/CCePgjQx1IwJWVHGK/UHkppNGqGYZZv6+68vJLnxXBt8kjdhcaN4WUHw3XKE7IJexs2/CYnC4leReMysn2n4yaUdNmsd/N9KiNwDGWfgmOwOZnT6X8pumxTu6/0eiLwqS5qLRuJQ56MtM0kl/NWtNCiH2LYaoDKxtZVsAPTfxVFYrJyyzmZ22fBlng4U2ELbxmS/h1i8wRrsxG6zLZkSsETkd2o4eJVFairZrBDIszCRIwIXuyW2kua4s5/fHMMzQUzU8fFfi1sJb6c6QGZGdMwi8PbswG6668HNkmmjLF3c+bayl8IRGDSthb0LKbNGw+mf7T6TATgTPlAWbQVniLX4vPVGFaF33xAW88c7U1CsNKaqrzUswIiVN++/mxht0i4WvY8Mgt/2hBZf7GkZJWVEZhnhhDsGBX6/URRSezzN4oVil+pKhILpg4rFcHqxlBSab8qBk+dLuacup+DqALhG7h8UEpzMEHueIA//lktNW/27iTFkNualojF+9XxX5mS9G3HvG7AoYAZz9PdGNvgmQ5/2ol61E858dRrSGt8vI3jy6cb5zGSZkbhbQt7Nn3Fg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P192MB0787.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10070799003)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Eyp5B4Mqgseq14BEzBiSvZwu9F+CrDBHH8RypXOBdDbyRARQJhHf4TvB1Vxb?=
 =?us-ascii?Q?7J4LjtHf8a6RVqGCFusx3Cy1tc7LUmMjSwKxChaofZuhJx73c2lreGGZYVHJ?=
 =?us-ascii?Q?rmnqhwwP1dkoDMVnmDOcDaNT5YcPNz3HOnAjmUGnB5OUDJzaKZ6OeTToJpLu?=
 =?us-ascii?Q?uy9QFqcQtvPdi45Awoo/eLh452yLjHil3/vG20XyPsv9OB2n8+dY+HxbtjSa?=
 =?us-ascii?Q?1T0m5F68W/2pDh4WHjlnM4ldxR7j1N/hXHDK767n11TviHHR0l6gibX3/W2Q?=
 =?us-ascii?Q?scFvp7phRnKXU7EPwqcG7U0/ffOv68jXtnvLQuXGsfCsKpXMQ8dlCdh94wfN?=
 =?us-ascii?Q?clcttJsqCYB7PzUXbV6uGoEZBPaul32w/j6pGfc0p0OkvJo3PoQy8z2EBPxR?=
 =?us-ascii?Q?CdSd3hh+bSWDoXjhbnHr24i/XX/BeUKo5031b9tvyJOYa2fPdz+bguE0okWu?=
 =?us-ascii?Q?N3xPNCQEl6esO1BcjLAgMG15SvdMVc1u4CbhjL3U1jDG7VyfSV0uDIezYSfV?=
 =?us-ascii?Q?qj7E/IiK3YO4j/cFF4s/RnTIompQFj3D87UXKPy1LQUFp2ehnXuSSYSOxWqu?=
 =?us-ascii?Q?gah+3e3bRlKXr9S/tWYc/N2CLSHpABnCTnDCoUs4aUhoana7Z51UvbVwTmFJ?=
 =?us-ascii?Q?yuT8xM0yInGvu0T5zlq/L3VTsqmfBbh/Ze7k3GzB01mWjdJljFflGqfKcF4b?=
 =?us-ascii?Q?W/7EkmHkgwCp+Ek+IAS1lcQU+7QUKTz3gbC/KwDBaXzW088OfMcCBqj49dtH?=
 =?us-ascii?Q?8+dW6sSToHE1UQ2JMP7IEXv/AeXKg+LUSGJCD9wUR7qKLOmKQ0GSybylcQbD?=
 =?us-ascii?Q?9Lmz7PDtAZx2F9Vzrz8/7yKI4Gl6pGwLHUhzhfUaFZqe9HkDtl1tFRdy0AIC?=
 =?us-ascii?Q?cy+kbNwQW/gvg9rcL/iK6kLzqibvZ9lXIDZBI4FP8lo/ntHxMgIifpWIEvX6?=
 =?us-ascii?Q?6uwC+EZNXAioN0KYbH8bz9bozMb/1Gsqjfd7EBafsnHr8/lFe0NVYfb+qbcU?=
 =?us-ascii?Q?76OTGjMrOCpRrAiInu6GWUZkKgyzvASXPeCott9Il6oZLpLKvGJvFR5cGeFQ?=
 =?us-ascii?Q?TQNqc2jmZbg/hsnJNsVU0EuM66NduiqaVfTPrNs849T23jcVg/sJwSXBCkT7?=
 =?us-ascii?Q?aAc6hpS5jsBr0zlNi5nUc3bcb4G/JMTFjJhJAnDu8a+18uynjF0Ff6BfEAAr?=
 =?us-ascii?Q?NcqW51pOjTKzvWk+Fr/oHUFGV0O5YUTwVz7RZbb3Yd0nM2ngVgHE8InH+VfA?=
 =?us-ascii?Q?F8QKR3KBWnwihqKAKKkhaKgwIL9dwyBtb2cc/3eM656t9tWN97l1IcFUZNe3?=
 =?us-ascii?Q?GTtJCbyWxvCcuW4IQ20IEH8odIZuQFB6NGdwkWYyMLnNUQuKFv8kiyK19H60?=
 =?us-ascii?Q?MjI9KPicmHGs/PGjk3GaylNurxZPrjrLfi5SX3tuNmGngz3Sb7L6V+TMcBsR?=
 =?us-ascii?Q?SCT4rHIf/ROP24EeKLtyJBhe9Rb9Jjn82rhAMe/MqxhpD8YNDW0Z2J1vjBuD?=
 =?us-ascii?Q?qo5RGsnbBnGahIoODbDAcrJbgxkTifcQPLIZZ7R5dbJTdgxEoqvxGl3/oRS/?=
 =?us-ascii?Q?gg0tvRVw90XOEao/yhL5XoOPsUCLDyTd7dZJZk+bXVbPn+zMhMjqTR/FZu4x?=
 =?us-ascii?Q?X3l/kEYDSVsPHBXe1kn/vYF+ucmfLRFZmJQP7w6sBIW7lXoUlks5qwlE/sqK?=
 =?us-ascii?Q?cjHEtdiRSn18Grbe9EVSQxOKu2eJn2RKnT/RFqp6ICCLzSx8MOP4Rkv3seaX?=
 =?us-ascii?Q?NEqtXlrc2UL4K5h8GVEvJ2sbnz8lfTkopct5XwKm0qdKpa1CWSZMKAu5dmge?=
X-MS-Exchange-AntiSpam-MessageData-1: FRZ7dDFDKVty/wiPhUHOfWoyIO13lXA7378=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82cb2554-b706-43f3-60e5-08dee7f18ab2
X-MS-Exchange-CrossTenant-AuthSource: AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:02:53.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QE1c+w9u5jTuTUBik1uBQCI5+fBJmvAK0CLTa5Kfn5GcFOObyvtbf3tlQQiiG1Xet5kCKsPFYuP/gRLV+njILvTz1B/s6hRTCgKLY4ixdQ/eozSI9QDydcCgjPQF41b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P192MB1739
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F11324000E
X-Stat-Signature: o16hqiiez7dqezhmb7swt9ez8dpjrzmy
X-Rspam-User: 
X-HE-Tag: 1784725380-932776
X-HE-Meta: U2FsdGVkX1+sgWOKqIDSCuOQJoIIUr/b2v6GxLtUgk3qjl19W0Y6PwyLe4S88jujQtk2IQDNUP/9IFDtny+RkfXP14iuyvmHQJ6WqbYbJFFcsjnHsZr8KS1DqlLi9m9RBlaQ0MZ18MuI8NJZYKlubcqBuBYmj+XZ303+dC/gk9g9+4RqXTgBlSnMelsZmtTFPJIxZOnRIiZjRvinJMftDEy1IfpGfftAk6g3sjqK/blFa7vx0xFinYOp1XdphbT1ZMmv/vg4mpO73T7p9mNQRY5xTfDv6UGPoIzal72u25bV5hZ07aKjlwgTd6d7rOUGp9SKT7+FUlnYVwdfPNDWqLLkfXnk9mHv94TmYCKF7DeHmSZ+PTAXA4TxQxcdlKHFUacVJVxWj70FpzWcDLaZlek3zw23kn01LvItvBshNMebwUqyFXlGU0doaKJPixR3KcJ9ynWhoLU2NCggQAmr0+ClL/pEK3NgZkaU3KvYLRcuMwhRrNbIH7k2XaMZwraLnKaLoTJHe+Z+XyaYLsJogTJ+UzD64mGnaCjck05w5tQNbsWEpjsoEFyJY8IdmggU/CvUkIDSAYTyuPMWhRFknix5+AfSEOnNMWvtzhFh554N8m6PYESo1OrctT7yB403+C1IA09cAD2cnULC9UqJT/Mdo5aOTbJarZ0qsg4LSIZpW5PwO5X2IrqRgvKW9+i7YIDF6yhN7MMA/0kG0gh5UuoUZ8n+/M6DDX4ophSK9RdXUozwaQvxYOs/O6CbJNhUVZIIPRxsalG8pBxA0Z8SdxOuV/t2Ex7JYTCUMEj9+2w0l9Ss2eP+XYxRiUwkcyEZHlwZIPCC69mmkyN8sPyrGIcYUT92TjwPRpvek5PGAfwRXHbus9vpzai273wckEyBDoXvvUtNief0Pp2gXUwd/EXNMuHaIM8CLJFuibkzKrBfyeJT6qTkOEge/vyDept9vu+0jz7SkQW9FFmOyss
 rQUKyzsc
 kDT5gV+qplFqmVB+hO/fFsZXJcoqvr/7XQ3CMoYADL3i+NZv1r0NH8e+RoFABOgquXqFSSg/UMb+bpEmbd6mL171uXa7LZ16c8+xeQDvCsNL9DAeh9uioDm11wK0lFL3AGCykxYE9NzWZP3ngpGq+qINgiRb7ymP0uf4NCBBPuEyYw1hoN5U5COZVrcNyN5Meaoa3iAks4W63z1eE8MSsyySDkbxurMFU8pmeQvcIUSCka8GVlfwwLTfPkFY3zV+sJDf6CRFY8CDT21AkDOLXHHZJY/n158waFolJ9efFxrPbH2rKPLpK1tTWGbboI6d6WuAoNGbNc88q5RhLJioOD8MrYtCBH0j6VE2kj2vFI72pg69Abk82cmPEHJcEXDeUzMN/ewG3eriRzg4lJBNfK82tMckvTgzuZdWV9FjFX8gK2MstRhFMlyiiP/TkxfluIjZA6eZfOoe8bpYhuHix+evgfu7O2W6AOZKMTmtLvlMIyrnhle5RzOOYUdVir1B4VCkwu4iOC5pjRkdBd5GadnlnSo3mBbmPRPdXJQ9Y0rt0VWgsSp7iqGYKcg8dXWfPknrJlLgmYv50FocT+GxIypKQrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clone3_set_tid uses getline(&line, ...) in a loop to read the child's
process status. The code expects that getline allocates the buffer for
the line on the first loop iteration. According to the Open Group
Spec[1], char *line has to be null pointer for this:

> ssize_t getline(char **restrict lineptr, ...);
> If *lineptr is a null pointer or if the object pointed to by *lineptr
> is of insufficient size, an object shall be allocated as if by
malloc()
> or the object shall be reallocated as if by realloc()[...].

However, char *line is only declared, leading to an undefined value
that is potentially non-null. In an example run with Musl v1.2.6, the
realloc call[2] of getdelim, which implements getline, triggers a
segfault:

./run_kselftest.sh --test clone3:clone3_set_tid
[ 1366.165898] kselftest: Running tests in clone3
...
[ 1367.799244] clone3_set_tid[811]: unhandled signal 11 code 0x1 at
0x0000000000000000 in libc.so[68184,3fbf69f000+4c000]
[ 1367.802808] CPU: 0 UID: 0 PID: 811 Comm: clone3_set_tid Not tainted
..
[ 1367.804188]  epc: 0x0000003fbf6b0184
[ 1367.804188]  ra : 0x0000003fbf6d4664
[ 1367.804188]  sp : 0x0000003fce5f2e40
[ 1367.805314]  gp : 0x0000002aaab0dfb8
[ 1367.805314]  tp : 0x0000003fbf6f14a8
[ 1367.805314]  t0 : 0x0000003fbf63d000
...

Looking at the realloc implementation, Musl mallocs for a null pointer
memory. But for a non-null pointer, it assumes it's passed a valid
pointer to the heap and tries to access its meta-data. This leads to the
segfault we see:

void *realloc(void *p, size_t n)
{
        if (!p) return malloc(n);
        if (size_overflows(n)) return 0;

        struct meta *g = get_meta(p);
        ...
}

Fix this by properly initializing the line pointer to NULL.

[1] https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html
[2] https://git.musl-libc.org/cgit/musl/tree/src/stdio/getdelim.c#n38

Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
---
 tools/testing/selftests/clone3/clone3_set_tid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/clone3/clone3_set_tid.c b/tools/testing/selftests/clone3/clone3_set_tid.c
index 5c944aee6b41..485efa7c9eed 100644
--- a/tools/testing/selftests/clone3/clone3_set_tid.c
+++ b/tools/testing/selftests/clone3/clone3_set_tid.c
@@ -141,7 +141,7 @@ int main(int argc, char *argv[])
 {
 	FILE *f;
 	char buf;
-	char *line;
+	char *line = NULL;
 	int status;
 	int ret = -1;
 	size_t len = 0;
-- 
2.47.3



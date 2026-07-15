Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB31C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5066B00A5; Wed, 15 Jul 2026 14:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DADDF6B00A6; Wed, 15 Jul 2026 14:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D9F6B00A7; Wed, 15 Jul 2026 14:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9237D6B00A5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1897A140297
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:11 +0000 (UTC)
X-FDA: 84991790142.07.593B070
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020078.outbound.protection.outlook.com [52.101.193.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36DA1180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=hi47ZyJZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNNyNTfsOG8Ek82+6Ao7fqrhzwIJ/uNOESZvwBJE5oA=;
	b=wrY/83jF3bdRSI9FAAS6MKN/D0/BNd5sd/pglOFVq88lh8Xh7FanPGOREpLgZnT6+av1AY
	KDiiDIWNHHUv/4nrHX+oDcyIQApra/rATZ4/WBrxVW6tnI1ZAc27B3K7LEwsH+pOqqTY6v
	b6hdeSOo+5exaLwZoFo6lDQGGhcLnSo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=hi47ZyJZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138768;
	b=CJcQnFuqLYZRZHtdzWUdNhvMHJ4N8lvSAKa/eKnNcnYfOzSXtbXew6WO6oonzsZxHpt/jb
	1a+XcYIvNqD0bkgXqckpKboAjdUBvD/jqB7FMQNLyqSwaL0Lp1S/CETDrGK00agLQZtzDk
	zD/Q4uSmrE7cAXIFAza+A+6wlzomFQo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxaGw3mOBZa3MsKXfTHKuXoBKuOFCD1qbdb0sG6I4NuSV/FhmCpdLKZSIZdW9HcpKqW3vjrHGXZ0xVu0X54AugAoYVPY2jKxv9sQz2dRXS/ir0SX6CF2db7PASMNqs+Pf21fDCH/RuBDxdZjk0ge2fm85/paA91UWmlXttJGxRtv+195wx+O86SYhfYiyzGZEnd/dqwfDZs+uHX7RN/HPO4dRL/IzpJrogGEx2Oo57cSHyyDdMpdM1qW6/qCqy1d/4Q/QtbbWJiVjkiiWRBYmx6UTLfnuwXliIHUzpvfTBrK4M5qFesZqoLYqJsMxP9UI//k58+LSQMZsLLH1z2kdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNNyNTfsOG8Ek82+6Ao7fqrhzwIJ/uNOESZvwBJE5oA=;
 b=gDqy/DAePtXq4IK2T0GikM35GPEgG0cTeo1FS6taXEKKuWhQpdSkymqcJObV44OxylLajPJwefJoWpPu//BHk2LvajH08/rHZ+kF9HdQ4wSFGGWYFqz1b2OkVkcIIrDrOyKFDHl4uLoiwyYwIlazNqHUV1G4bKbneviCUuwSWMAlrgjIY3oufbmTuw9OF8XntY7pI7CNsWhfmeDYIQb3gfHoADoizwiFe/JOKd6ZWEPXbIgLsdt0hmkoT0CdWNXnUDH90Pw4nyZewmMBtT1EIfyg7PVB61n+/2UjNAXzmio2PQFQn4LYvLefvi2aRej6q1ddeLZEx+xaEwNgfajgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNNyNTfsOG8Ek82+6Ao7fqrhzwIJ/uNOESZvwBJE5oA=;
 b=hi47ZyJZivknmFizomT0fHWJB8r10WKH7qsNxJ5oOBriZ5YNO+wNYVOouxRsv5OhEjs6vxJm38WKiTyKzG4QSwJ7fpuOcsBT+An58E8fU3ri9xo1J+VhwElaWrEahaasNaliO6Jgbv3YHFMYGXdhs7UD9YZ4jRlta0rXh6bkOhc=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:53 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:52 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] arm64: percpu: use local percpu for this_cpu_*() APIs
Date: Wed, 15 Jul 2026 11:04:18 -0700
Message-ID: <20260715180455.515692-17-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: f2e6bd10-9355-443a-96db-08dee29bb58f
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	L9R+xQx5kWDFPcFDD6qFkPMWZ400S+0lBFNfpLAFsF7JHHEY4S8McnpQB6OQIfyahqySFtgO+dEZ5gl5JE6WKLVg94a2Cjl017cvNk6AeQK+LNAw8suPT3qwgp8xxKv8gpJBhqVW/9rq46cRuUyAxB7I68/7aNBEcOYaG149ZMedA4y44CW2fBt5Zq6EwzDFH+/grMc7fLF9u6fgqmEhaL1cG2Sm53BaZ3DKd9jYzX4gCI38mlGsV809EDza5cIEgSrhjkHPeQH6OHoOp8h1PP8bcVAcinm4G4EK8ndoK4VDB9EIXECV5NS4OjFYO5q4awb8j5uVACAhMi/4egJkIly6RPeNdtFYskK+EqkCohpRNPqtJ304AFTYqmWxRFsxQDoayrKxfK8wGeJzjicsqA8Fdau3kG+vGSZA6dU3Y5XxuDH1tb7sDWutug8xOq2ZnhngDowbRc5qcQYa/qzJcbpiMFKQaVXQXsCh9uJ1taa5WA7E4ClNV7hCI3X7Fzsso7PoaXHBS3PgDxiT0Cq2KLHGGarOBC22EtDHpPUCeVBDemXM9W8GGn58RULPPcHPnytxDRC19ZrOAAVBdUba1WgJnei09G+dOmUlwB5XzH5YGNIidoADkYzWk2J4uEKwY+TWxtxaFsZeg8a8AyqBsTI2t/EXzKUQ7XZxvr9hzxp/7PKqx+zuBY/F0OQsfaHAmiq6GtZJYNaU5V+N/5xnow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kRBCXe1zfDpwzag8m9k3KlHDh9kQX0L8el2SVhvcuufrw6SYpNVtub2ZxdI1?=
 =?us-ascii?Q?Y+K7NxUfDi9+68DtCP96bFldxQjr/d7KSIC8mcQtemDm/ybdRiIVH0WBfT4y?=
 =?us-ascii?Q?rAtZSD+9wh46yyuU8tqga6OlWLCBm7AjLxmZiEA+ieiPsK8ziMse8ThIqL36?=
 =?us-ascii?Q?5ACJ5661bhQrME7jcrrm/mDIMXTa0CtOO84RZkHe715SqaDdzz9c4aAaOXwb?=
 =?us-ascii?Q?tQNVnAdB8sMopPybbiVNf42tC8r3A+MsDd+hyXbmO+Phn1tRAZKTkKgTeLbi?=
 =?us-ascii?Q?sR4ArrcpZUhjwZfRrFfTG4rSRIfdO9sIeyxjOZdXv48sXBuavMZp7z5uS5E1?=
 =?us-ascii?Q?INPLfOHIIWLjjK+UQJ9g6xfs7bVQ/P+xU2SgK21F1VAP0auOVLJZp1w9Pa2d?=
 =?us-ascii?Q?iqAafmKziWW+7j6yD9nq8C3Fd5FNYyyXKczztvi5iNFg3gRLRM6msnznEYCI?=
 =?us-ascii?Q?rQpHuFJN7f3dUpvZ3JM5pojP/Nd2IkbaRCDorZoNhKTMNJcJJCxxcw7f2LFm?=
 =?us-ascii?Q?yccFjb137mt05Pd4CLW5gV5chRFrB7vcCK/0Q+KGkm6ZDs/hncb7XfuO7+lv?=
 =?us-ascii?Q?Wq338BgncAgE/28HpqvIqL0WvJ9ceTULu7CGSbznkS6grZH14pDhNcYqHW4k?=
 =?us-ascii?Q?WMUOFLa5qmbuHAt0DTDKRukoPxzIldMZZ10Mhq3zKVaAJJZk2964w7iNrt3A?=
 =?us-ascii?Q?SlUgVZ2EmsHk9JbhOtCFcPdFIWzp+9A5u3O+LW+Q/eAR6vzKxEgScvKZUgCk?=
 =?us-ascii?Q?fifoENid+7FWvoNDhtrfcfXeOnrpgv7+AyMDPayUhlfhNyLoCJAZX6hvREdP?=
 =?us-ascii?Q?njjgYkX77x48HvSu17HjVIB/ERGmyqXPdD4Wzd1btDCUlwSmtupOxSAmTlXe?=
 =?us-ascii?Q?7oniM72Ga1T16qrEPeTAEt+lqEZ4h2YBHZkRO/UtM6cQNPHeeo0JI/iI0JkJ?=
 =?us-ascii?Q?uuTxR7MbLeyCivxol3Nh0c0ywFjyC6BkZ1ApdVhOLFyliariaXe+V8V1UpjY?=
 =?us-ascii?Q?bqAR72LyLClgF+Ab6DMKKPhUi+YkMWEnkLIQv05ll59ebR5hYUMtM4Xsc+fq?=
 =?us-ascii?Q?ZBNCCkZpxUW+4VIDLO/rbshbpa8v4RBJlowdGWksXFCZwTyx6fIM2dE/Btia?=
 =?us-ascii?Q?FOzCh7e3jlgj74B1q5R3zR4lwr96JIplDzRwfjLtjH8as14S+N5aZyq4964h?=
 =?us-ascii?Q?t4IWhN0lTO0UtSC1edyJ2XAFJnGAcgSp//HoDu4pYOHkUAJPLLHS69mhEASi?=
 =?us-ascii?Q?ahFO27A2wP3RZ0u2DfmufgSaE5OzmqxGvPAYYymv1huercG62nj1QUQdD653?=
 =?us-ascii?Q?Y/WRHr/AKwRE8bV8u1fbnLqQRBBjBYx8SvdWgo2LcPau+sAdH8xhQEo9BEqz?=
 =?us-ascii?Q?vI6MWwhtK2cGdHpn6bO45RBlw+CMmslJGhAAyz3FGK1OtxWpdtHuNVorhroq?=
 =?us-ascii?Q?DJFMzQcxMRwNPKohQFyEzeTwCV4OlGeWCsLCbU61URK7RAKY8c9WndEtoYL7?=
 =?us-ascii?Q?7GR7xpAoGkKsv+zXNhHI4w2TRZ9OWrkA5eWBtyMVjRs4YJ4LE0Uud6LVbpgt?=
 =?us-ascii?Q?tQLfo469WoDsAyzzm1biuV6ZW5No6p+eSnKQHAiCs6k0ZfRUZYmY01GX/oae?=
 =?us-ascii?Q?fOu2VAGGAiVc+71X8KOPoxq/MumXmBeVfCWYTIckcRdLZm1F8jqkWtXtT3mI?=
 =?us-ascii?Q?ykm2dKsan3aQxDSVTPNOKdWZBIDgKcZmv9G5AjgtpOeJPIklRhIlYeUDH1vf?=
 =?us-ascii?Q?bqTxDKnnRsqTiMZwocuzgTwnlOPZVoI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e6bd10-9355-443a-96db-08dee29bb58f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:52.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ti8PNjmsQafulMW1Ycr4B5cCUE51/odRdr7LQ2HQdOwkoeCjdE5I9WXRKuGfkYsVAD98YgOX4eBDXWIsQOv46LbRQFzDSENNPIy2uF5bMIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36DA1180003
X-Stat-Signature: ptd6fzcu9mdtzhbm4sczfjqqzhx9b7c8
X-HE-Tag: 1784138768-662981
X-HE-Meta: U2FsdGVkX1+iEgVqB1776GljnE/ASzDp3E/Xi4Ns2nzYfySEsaH9x07vvVSJafFLTdDYwpv5TdKg0xKmJsRzSv/02g2Kvq6ruBHxjTCTY2esCctiSSdV5XQp0HscAXF1IAPfVLlvHHJbFgNsjHeFn4saa/cW7b3iMxaziBkbCAl2KTdOEjh6IcXfVm0cJxfTMebgUQwPm20nRxVtZE0qRGYOc+OxMhbVprMhrRsh/3a40iyAvtcF0C0ig7WZM6L/zmb5uiFsOlvAtcYIoTGy7HRKypSDavdH52QEcc/gqrAUqrZrczo5A2498rZVn56L4FaeKJr6BfZUlwQVbtgAhPsqUjWjNacavu3etIfOQHBOSfWIhZo8FlszJi2aRgMCTRRMNuT2UxsHdUG0gajZrYdXb+XEN9K07i9o99P4tBqTdvu8BeiEB0Yy3bZp0tguwAKeQBWctDojUGHbIVn3wwjhfBZlevkI/aSlQE4x2yUEdYN+4gLL802dldMQecSIKzEvfZNexfkeAkWhcqPEHtcArSzHfeR/fWV4939uapdiHwldMslg1Ow1igWyIrNOjqg0fryAfcoKrhfKgLHtHdgp3xbupYwHUuPEPSFJGL/bwmrMOyZ+fLuHOygTM+cgx7SwmKJ6PVAshpD/bcPg4pduiPnu+JJP+/s/0CAW53m0L1CZNp1p8Vb/JDAr8u50+uobhnHfCu/1n3RrTugoU02BieuqHyRA5s0g1VY6r1ekxapy/C+5E1tv/Cw6Dj2WPtcuhKEAt3ofOf7OyhiRFk8V2GadHwMNN7yPUrffr0GNoqsrHf4lPtZV+4ZqhSLUxXO+KPV3hmWkqdMoA4i+7iFUdV4OmTjwuZuK+tCtF0+KVqkrVOh5BsxDEAiJSUdO/y6U9AnQSx+b8Sl8DqxfIB8TgXCDCbJSYoKoJ+H8A0xj5rDh2s09m4N+wGuGFwq5i9e8nCwVo786nC7TBdl
 YhVWFC/c
 Ftc9iqaguQczPMEAyAwSC1juSYuIv7OU6uDrAqWj5WELODV1Wc4tEbbRecItM5yZO7HPGPnGR3WphlaG8mtLkJyhtgfmvP0St0HgvLeZzFJeZdZpvIprhX1HQGNlte+EaeB6MDf6b0qAFh54cBYTLoXS45HypAbJK6mT+FPQ2+BoMv1JMhnivLtlxtZto0eAl3xQusI5w6PZokKPaJ+14G5KhmSNpvrJ11/hqNLUwNRRapusvAztCzkaddJH1r9se2L3ZezR117wSJ5IVvrZ8qN/RdSRjwRiOCG7hb+AqJ5gZbT1Ji2ErvwyslFkDQq6NL5iDNXh9MEF5nlUOhDHH5PvTGUW7O5/ox1ErAIaMLqjiGrcYL7vVPHwyl9shVCr8IRWov12OQR3sDjReMuUfeswAnu38zOPb8IDvPqSCJL1qwfc8pLu3zBbEgf/fRJABtnopxBhC4U64auAgAAf+cFwefJlDASIqUQbTNji0A5zEQ8GN82qAtewRtQzLpHgIgdtHM1cJ7puH7XZJ3mAwYlI/T1RIJhZYkdOIwAIzDLodvQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use local percpu address for this_cpu_*() APIs.  Because the percpu
variable is mapped to the same virtual address, their address can be
calculated by using __per_cpu_local_off which has same value for all
CPUs.  So preempt_disable/preempt_enable is not needed anymore.  This
optimization can improve the performance for this_cpu_*() operations.

Kernel build test on AmpereOne (160 cores) with default Fedora kernel
config in a memcg roughly showed 13% - 15% sys time improvement.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/include/asm/percpu.h | 37 ++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index b57b2bb00967..03d149f9177c 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -142,6 +142,27 @@ PERCPU_RET_OP(add, add, ldadd)
 #undef PERCPU_OP
 #undef PERCPU_RET_OP
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+extern unsigned long __per_cpu_local_off;
+
+#define local_cpu_ptr(ptr)						\
+({									\
+	__verify_pcpu_ptr(ptr);						\
+	SHIFT_PERCPU_PTR(ptr, __per_cpu_local_off);			\
+})
+
+#define _pcp_protect(op, pcp, ...)					\
+({									\
+	op(local_cpu_ptr(&(pcp)), __VA_ARGS__);				\
+})
+
+#define _pcp_protect_return(op, pcp, args...)				\
+({									\
+	typeof(pcp) __retval;						\
+	__retval = (typeof(pcp))op(local_cpu_ptr(&(pcp)), ##args);	\
+	__retval;							\
+})
+#else
 /*
  * It would be nice to avoid the conditional call into the scheduler when
  * re-enabling preemption for preemptible kernels, but doing that in a way
@@ -152,7 +173,6 @@ PERCPU_RET_OP(add, add, ldadd)
  * preemption point when TIF_NEED_RESCHED gets set while preemption is
  * disabled.
  */
-
 #define _pcp_protect(op, pcp, ...)					\
 ({									\
 	preempt_disable_notrace();					\
@@ -168,6 +188,7 @@ PERCPU_RET_OP(add, add, ldadd)
 	preempt_enable_notrace();					\
 	__retval;							\
 })
+#endif
 
 #define this_cpu_read_1(pcp)		\
 	_pcp_protect_return(__percpu_read_8, pcp)
@@ -243,6 +264,19 @@ PERCPU_RET_OP(add, add, ldadd)
 
 #define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+({									\
+	typedef typeof(pcp) pcp_op_T__;					\
+	u128 old__, new__, ret__;					\
+	pcp_op_T__ *ptr__;						\
+	old__ = o;							\
+	new__ = n;							\
+	ptr__ = local_cpu_ptr(&(pcp));					\
+	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
+	ret__;								\
+})
+#else
 #define this_cpu_cmpxchg128(pcp, o, n)					\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
@@ -256,6 +290,7 @@ PERCPU_RET_OP(add, add, ldadd)
 	preempt_enable_notrace();					\
 	ret__;								\
 })
+#endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
-- 
2.47.0



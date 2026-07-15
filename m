Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6A5C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4378B6B0099; Wed, 15 Jul 2026 14:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373206B009B; Wed, 15 Jul 2026 14:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B076B009D; Wed, 15 Jul 2026 14:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76C36B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 420181A02A6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:56 +0000 (UTC)
X-FDA: 84991789512.02.157C1E5
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020078.outbound.protection.outlook.com [52.101.193.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 602B118000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ErYp7ioY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5u3Ui48riKUdMAO/FmOhP2DfS5AnkZBgM9oG/Y3LyM=;
	b=Zg6I15AJKuPQq6WZUwuq5/87TVlqLNbB61cq2wZUkkRpKtOzxHaMm6MPxXWcLnASOYE2y+
	nQdIT0JIf7/K2LeeGeney7VSMzJYGLYgHHy+620TQ3NKKGWva48PW/Dz4RrdFkIXlLLmJ4
	kAJU3tQQ6sTN9+zVboBXK/wcoUQkrIk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ErYp7ioY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.78 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138753;
	b=C6SUOj9/oaVqmog8oidx2UhIJ5j/5pD8eM351xK5TKnHKz4QvbZ/Utq2aorn26jsQ0E1gR
	KU7Shll7vTWWFlgXi5vZe3DkHmwsF/j/DuUYDlwgsqASkjIvjKYvq5sXdraziC3vV47DlE
	xEEXZdnpOGtJOadYHj03gyGyTPLYd/k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rx65cVkxA7MptQmmJhZAV5bex9athqgAdRRG5ZIVIf2esZJjnZmsRVXoo8zV/ObmarlwYm5iSVFOXj3Eds2krLiQob/BFEUokK03hCAFufs1SBCV+FmtCNvePAoE9ZgTbVzYQ4VGxvN9UDAZjVFUGmbXZNvh/RHFDjgvQcNvajCMK0HUXvTnWyzfoywP1rvONpfVXjuz7NU85ErSE//yhyQKt1U+weaxNJbtQFWAXOB2mXcM2+V5Of6Rm1N1wMwq8Ipd9hSNO+sC8SqP9PUP3riiTb7/kIi859YwTIFZfEX9SM0Q91EveCc3OuuzzRhO9/652yvViGsqYx3b9P7tpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5u3Ui48riKUdMAO/FmOhP2DfS5AnkZBgM9oG/Y3LyM=;
 b=vgJkfanLXWh/+pAroU7Jw3T2mG7UN24m8K9sIEJNKSppLzN/HXq3lru8/lgTpp4UYZoWim4l0vXY7I2u0GacgBy1ASfOWFv4+QEnLBzPD+lJicfCFmfPs5uBc0el8kihDSmVFtpKC1ohh7aQUk1NNkmT2t4joio27d2RwgLA7ZQd10KxKAq8yQ6CYoQHA/CDvPtz75AepyznZfylFASawgOlFpw4zWbE37NN1bTQV8PrvM4mXJIJ8dci2nu/46yK85q2w6aAcKpGRhTZ6xMKxS/gPCEMN9JMbkv7AbY5HgX01DM+Lp4f9wLNInzdK6mC1cl/iTf6oa4MCD9tzVGRRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5u3Ui48riKUdMAO/FmOhP2DfS5AnkZBgM9oG/Y3LyM=;
 b=ErYp7ioYxq+epTH8IZCyneSZopH58b2oo3+Eni3/XAIqnxid1AFZwnGbFtNkMuf0PhKjB0ZgJ7uHZo8ezVvYSIIw0JiWziyGMG2CihM/uV1UzrvA64uB5gRfPDh7wUaorAb/2VdPONlRp3oxMkxldJlyN2N1ogbsPNIdojJ1Fyo=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:42 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:42 +0000
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
Subject: [PATCH 07/16] arm64: mm: sync percpu page table for memory hotplug/unplug
Date: Wed, 15 Jul 2026 11:04:09 -0700
Message-ID: <20260715180455.515692-8-yang@os.amperecomputing.com>
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
X-MS-Office365-Filtering-Correlation-Id: a7f1a099-35e8-4495-fc6d-08dee29bae80
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	Byry+Fa+vQBaAwLGgOjBW5Bp7bkPRZWRpQ/+jjbuwktMlW7x9yyKLz7xkFGctt89SlvfGi4FZRoYCnscyCRh6/5EYaOSWKA+zCUrEGD0CZ9LKaQ0IbHQPhQhbIrY09Wy+E3/0QZTcA2GWz24PzXeaQeNsat8ATFiarx+u21dPbSU6I/yz/mLTKlnCH3v/Omuub3LtwVyYohecZEgLlnpCnsWhxHwvn5ffpvSd7qAFovSgsVoifWP16X28yeXdJgneE8sKGIOxqUuih9snPB4LpmkfakGXX5JqXNXhyDZipAqrdeN1/OQw0xWNqqAoRzrNyGn95sHd544uhyIQTF2XY2ffqtVy3/S6YomX4KEerbzfrBvAOTBchp7rR9Fw2cUzQtao/xqq07G+4fh3DfiGjgmvwpJFBhic9Pq3fADQc3I5z91mY2kYkrqUeHQRQJrobgaAa18jJPMuStH4o836BkQxGiDF81rouPHqnrC3La6Lq95hP/r499dTiI+hRLFly4vR9P3i5pna2+oBKgcu8yzmGgxrciPADZPhPeKMNGNnrDhTBR+vOMIjld0NrOfy4qQjAkLOgK+yxMpibeYLDCsPAkfqYK6AdgnlC4tESd3CAs6YvLTc0N6dt4T423+LPdORaYgBilCXEUMs47cRTpOGbIfuksZjXer7ukcDLMUMb6Eaqy2sE5W6l3Sk222GUG1oNyaLK8GiKUTsMSN3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fus4iSpsDqTMRF3snIBqfKxcvFC9irtMpadVcOGRKYCfqXxSnkWFzJba9j43?=
 =?us-ascii?Q?j5Bf2q1zCROn/XiWDB4KttS3UDL4ezRkDHpQFBKhwcwNCxrbE7clOe38+Fru?=
 =?us-ascii?Q?ujqsETPiFKpZ52gfZfxUvcoYfucM0QiXxLrwQsCXsoWT+ywMG3fitKln7ew9?=
 =?us-ascii?Q?1pjU3rlp7MRxYTL/rRB5ppCeSjRqxvYYvkBTx//vXGx/DFLcMn+Jyf9yU9Tl?=
 =?us-ascii?Q?i0HoiOgvM9Nu4NiKZ2ZIZF6QIGpkjC/7RKgKAxEszZY9ribhHexrOnUk8jfX?=
 =?us-ascii?Q?y/PYizAjag0jmlK19SjlAxuD7y4WU0oZ2wZL7xhHFk/60GzrNgbRydnng+Yt?=
 =?us-ascii?Q?AQHPjJzIbz2FmnCBBPbUQMhJhooaJHJmt+pghO2p8Pjrgk0euJCGh650WKOQ?=
 =?us-ascii?Q?nIXYnq8y1X0XyOq/kbXH+F0xkdQ/uBnuz8ub5r3WEaRFs2TzKdcKV0oRdiZP?=
 =?us-ascii?Q?BpfM+/plhIOXtQRJrsOJa/JAJD0CJJJ7Vfilc3g6JlL+EK3/8rcwzz+nLtmC?=
 =?us-ascii?Q?CxbPk2DC+8y6idG8B5CUeNHoDaevggYymWvz3TU5HeuAzbCy7ZB6MFBSKfSW?=
 =?us-ascii?Q?AnWToDtHp5P2QPpRKFT8fbd7Wq0mMk3Zy+ACGwacwwUwITixhxfkUOfU+nGA?=
 =?us-ascii?Q?dnxRt8PWhLS6Xc9Dl+UoKUDedOXV6lSnQCQLpm2VseKc3JTIMO4bO2ceEjk7?=
 =?us-ascii?Q?LaSEonZcbc+M2W3Eo/FEB3oZJgETl29Ustzv+eGP/PsGRbRduHmTutfswH/G?=
 =?us-ascii?Q?yboG0PtMHBQD0rf83gm0bCX15jNeGPCuagOadYclQrlgg1CzBhhY3R+5nDb6?=
 =?us-ascii?Q?3f7To+MSSPNftu5i9h/9t4Z6URyLddNXGLU39HnZ0QnyDLus1hLGS4RkDKni?=
 =?us-ascii?Q?tV8mCUUCoxwrmnl9wRHHwamtyGc6I9ChYLYPrBJB2FaI/2S3XJYjpaDeatGU?=
 =?us-ascii?Q?T2CvQVZINQmlYtUC0FfmGpkmSeG71ECjKjAbK46BTd0SEFXBOiIAHdDfknpD?=
 =?us-ascii?Q?GGt23+RUv3jCnlTq2qeRL3+7nSNsS1ZvDLeJNZeIThliIVKfxxVZPJWrKie9?=
 =?us-ascii?Q?2B/CHXip5z8wq3RsBZ+jY1bQGdJh9SAYuuD+0LK9ii/oSxG74/jAaheGN/lx?=
 =?us-ascii?Q?5PZpglE6Lc7IDHXPX3duvkKKVwcRk06qxT3rtI7YOMCz0QKbd+Mitw3zXWlC?=
 =?us-ascii?Q?tKghYLQLALX8HQPdIGjiLsy/vEZ80Kj6zFBqtBfrKcSSmF5AMWOLb/WOip9V?=
 =?us-ascii?Q?tDFisa6mv0TGcJNki9MkOCFiXsLLX/Q5cfTEo3R+ZKnDvo7VBnR4nZ+Hd4aX?=
 =?us-ascii?Q?l3TR5aoBqBxAYaTHNLXfN12naqRDUD5O0FCGntSvIEggr6JHr6DPygKH1oBs?=
 =?us-ascii?Q?8esoDs3MUb76g9KZNl3AV7JnN5KvFb1IZA2ndFz97Jvn7M/yyk7mfGhT4rvu?=
 =?us-ascii?Q?jap8BwMURxC2uPeGbQgip14r+FZY2OyEtgDinh1ho/wQEh0r5G+eqgzIykfX?=
 =?us-ascii?Q?B+V4eWRwnz1189wcDCh0cyECs5HEe5xMZZr2RIMng+YiJqQGST3dZYS42f9f?=
 =?us-ascii?Q?tp2PZkqKsWhDIxJ1zqxXJ3PJzY85F+LHAccMnl18UoH5IYsUNIjTm/15F9Vm?=
 =?us-ascii?Q?ssXJtqrYxnEzUSX64x8ZcVwha8GKQ+eCunlDXM6M4gIC4ltPjK6EDwIErp7f?=
 =?us-ascii?Q?6HCEYAC+Nu0C95VpggfYfDGdVBdiCVI3WgCGfBkPLI9jU2smqbX3XcRdvvR9?=
 =?us-ascii?Q?x47eQ7kFwBuZ71FfNXxi+1Rq7fMOHGw=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f1a099-35e8-4495-fc6d-08dee29bae80
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:41.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3TsiLXqp5z/1LGO/i0O/8fghtlkkn24kEHm4T71gO6uA7QEzCCvUNRqv2PUiRpSQh/udoYhRTsYIT9rpeN3ki/j9VKJ9003rDFnkAT50cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 602B118000C
X-Stat-Signature: en93855r7accw75rzezneauqscars4zw
X-HE-Tag: 1784138753-970657
X-HE-Meta: U2FsdGVkX1+VdWlYaWA7ephhdiOVhFjONElzQTB93O6b8lsTaBFi/IY3JgFnmIsZWxWyJ1EsBG3CPjy1A7ix+cNZ9sekKRWG11RDtp6xExsfaSiGavQvpFhxqlWnVZEdkg9WHvfnlG+psqAzUj1gtyqISo3VLUK1B7EJpulEjbMLoEdyhCibD4TgIg1TkZeA0463pnZsWQ2VybOCBg5038LvDBlhb5L7Hp/tlI7JB9SPneol/H5uJdpWXTmVdd2VZBMr6WsFgjSfGqfWamKasMDbD3XPghp1gVIOy6D3AfNlwv4q0OZuOlGAvlaVh8LcScqTEGF7rsUaYM5DOxTbLreBuyziak4wmJcsKgzZU+QxoftwTO2lwu+t2ItHS8LaUdKpqlXzme0SEXJeEpzHpFTy2TSWG83mdMEi9ik+QSzjsPidNjPKbDo+j21L7vGiYjziISE9DWkgkFEzFvcmTmJ0suoJWnGuznpJVNwNRtV/uq+GHEo2OwXSkgV3dvI+JSNw3GmP1acoxrvOdpjN9PrisgOnqBUrIHSJ1sN12f0c9wNHtii/o8IuA8CvpsJlNdLitqxsgK6vTsQYnTNorU1JIJhZ8G8OjfrhTe9GqmvmCsn3jMQBVSDC9qrC0UxNPb34kdJ+AZi/wxWLnUrlsMPWQeQ+QHiMFrkq9o2qE1zEhqB9AjQoEZbt43Xquz52BzL4Ch2ndQdeFIAdhor/7H65f+GB6fEEgBmPOSr0Ba3Zxe/SU1jI79M/dyYY3kqjCU3kevDzW4yd1DPARASVGFO1sHKMeA+9EHGF2Ckuyhtf16f5k/J8smEH0C3qQpxRofWdfaesGS5SyTgaqX3+5KpN1Cr9KiY4+/3SqkadE3AC54pwdZfWEhNeQvjZgBdhE6w0YOHKroTDQwYa1B0JnVkHZeUOw/8DMhGtSHRuZCPc0Baf8fQ2RmXhKqoyRjKLrIWkhJzbg9K9/Fw16I8
 KWFzbB+R
 P+tPtXDshYPNDLXiR4b9pA9oMFdGwitKtyaQC8prvC1vyo6PiVHLxD/yi22F/77L+ALbdQtWKI7RvJsRVn1RVePJZvk7vG9/ZIeQpUSVud/ENB8XaysU5Dm9kYNJEVlhQaBZWDvUKudNnX4DT/riNPDtkyexplRB8WYYx82WwPZttCdzYO8aSKULpP2sSQAswHJGrevYWMf0T3yADzGBS+0Ey/L1sd4Fv5r06NN6avLcuswYY58EIRwMKS7/dIbYLtQpx8gwiX+ZMKJgIihpqg2tCTPMbquCFRZ8xK+/y6GoICMQXsLFdR8TRxnW21nZNrzwdvHs+ndVSqgfs0ojsyEsI5JnFRtftQq0+de10uChsRhGPGUCOul+kj8b2Wn6BNWcTPRQlGuvjYxfxnvAlWf67NaaARtvdOO+f7ew5Rgqtths5aVpm2tLeLm4BEwkp+DTFKBXVjABYGEpiRx2Lj1AKy0VVS2l4aVt/JzaVzBlhFItT6qGFoQnPjVJbwijNs3rZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Need to sync kernel percpu page table for memory hotplug/unplug,
including both linear mapping and vmemmap.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/mm/mmu.c | 85 ++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5a235491f268..e1290ccaa5be 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -214,7 +214,7 @@ static void init_clear_pgtable(void *table)
 }
 
 static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
-		     phys_addr_t phys, pgprot_t prot)
+		     phys_addr_t phys, pgprot_t prot, pgtbl_mod_mask *mask)
 {
 	do {
 		pte_t old_pte = __ptep_get(ptep);
@@ -224,6 +224,7 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		 * are deferred to the end of alloc_init_cont_pte().
 		 */
 		__set_pte_nosync(ptep, pfn_pte(__phys_to_pfn(phys), prot));
+		*mask |= PGTBL_PTE_MODIFIED;
 
 		/*
 		 * After the PTE entry has been populated once, we
@@ -251,7 +252,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
 			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-			       int flags)
+			       int flags, pgtbl_mod_mask *mask)
 {
 	unsigned long next;
 	pmd_t pmd = READ_ONCE(*pmdp);
@@ -272,6 +273,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 		init_clear_pgtable(ptep);
 		ptep += pte_index(addr);
 		__pmd_populate(pmdp, pte_phys, pmdval);
+		*mask |= PGTBL_PMD_MODIFIED;
 	} else {
 		BUG_ON(pmd_bad(pmd));
 		ptep = pte_set_fixmap_offset(pmdp, addr);
@@ -288,7 +290,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 		    !pte_range_has_valid_noncont(ptep))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		init_pte(ptep, addr, next, phys, __prot);
+		init_pte(ptep, addr, next, phys, __prot, mask);
 
 		ptep += pte_index(next) - pte_index(addr);
 		phys += next - addr;
@@ -306,7 +308,8 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 
 static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		    phys_addr_t phys, pgprot_t prot,
-		    phys_addr_t (*pgtable_alloc)(enum pgtable_level), int flags)
+		    phys_addr_t (*pgtable_alloc)(enum pgtable_level), int flags,
+		    pgtbl_mod_mask *mask)
 {
 	unsigned long next;
 
@@ -319,7 +322,10 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
 		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
 		    !pmd_table(old_pmd)) {
-			WARN_ON(!pmd_set_huge(pmdp, phys, prot));
+			if (pmd_set_huge(pmdp, phys, prot))
+				*mask |= PGTBL_PMD_MODIFIED;
+			else
+				WARN_ON(1);
 
 			/*
 			 * After the PMD entry has been populated once, we
@@ -331,7 +337,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			int ret;
 
 			ret = alloc_init_cont_pte(pmdp, addr, next, phys, prot,
-						  pgtable_alloc, flags);
+						  pgtable_alloc, flags, mask);
 			if (ret)
 				return ret;
 
@@ -359,7 +365,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
 			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-			       int flags)
+			       int flags, pgtbl_mod_mask *mask)
 {
 	int ret;
 	unsigned long next;
@@ -384,6 +390,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		init_clear_pgtable(pmdp);
 		pmdp += pmd_index(addr);
 		__pud_populate(pudp, pmd_phys, pudval);
+		*mask |= PGTBL_PUD_MODIFIED;
 	} else {
 		BUG_ON(pud_bad(pud));
 		pmdp = pmd_set_fixmap_offset(pudp, addr);
@@ -400,7 +407,8 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		    !pmd_range_has_valid_noncont(pmdp))
 			__prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
-		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags);
+		ret = init_pmd(pmdp, addr, next, phys, __prot, pgtable_alloc, flags,
+			       mask);
 		if (ret)
 			goto out;
 
@@ -417,7 +425,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
 			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-			  int flags)
+			  int flags, pgtbl_mod_mask *mask)
 {
 	int ret = 0;
 	unsigned long next;
@@ -438,6 +446,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		init_clear_pgtable(pudp);
 		pudp += pud_index(addr);
 		__p4d_populate(p4dp, pud_phys, p4dval);
+		*mask |= PGTBL_P4D_MODIFIED;
 	} else {
 		BUG_ON(p4d_bad(p4d));
 		pudp = pud_set_fixmap_offset(p4dp, addr);
@@ -455,7 +464,10 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
 		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
 		    !pud_table(old_pud)) {
-			WARN_ON(!pud_set_huge(pudp, phys, prot));
+			if (pud_set_huge(pudp, phys, prot))
+				*mask |= PGTBL_PUD_MODIFIED;
+			else
+				WARN_ON(1);
 
 			/*
 			 * After the PUD entry has been populated once, we
@@ -465,7 +477,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 						      READ_ONCE(pud_val(*pudp))));
 		} else {
 			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
-						  pgtable_alloc, flags);
+						  pgtable_alloc, flags, mask);
 			if (ret)
 				goto out;
 
@@ -484,7 +496,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
 			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-			  int flags)
+			  int flags, pgtbl_mod_mask *mask)
 {
 	int ret;
 	unsigned long next;
@@ -505,6 +517,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 		init_clear_pgtable(p4dp);
 		p4dp += p4d_index(addr);
 		__pgd_populate(pgdp, p4d_phys, pgdval);
+		*mask |= PGTBL_PGD_MODIFIED;
 	} else {
 		BUG_ON(pgd_bad(pgd));
 		p4dp = p4d_set_fixmap_offset(pgdp, addr);
@@ -516,7 +529,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 		next = p4d_addr_end(addr, end);
 
 		ret = alloc_init_pud(p4dp, addr, next, phys, prot,
-				     pgtable_alloc, flags);
+				     pgtable_alloc, flags, mask);
 		if (ret)
 			goto out;
 
@@ -536,7 +549,7 @@ static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 				       unsigned long virt, phys_addr_t size,
 				       pgprot_t prot,
 				       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-				       int flags)
+				       int flags, pgtbl_mod_mask *mask)
 {
 	int ret;
 	unsigned long addr, end, next;
@@ -556,7 +569,7 @@ static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 	do {
 		next = pgd_addr_end(addr, end);
 		ret = alloc_init_p4d(pgdp, addr, next, phys, prot, pgtable_alloc,
-				     flags);
+				     flags, mask);
 		if (ret)
 			return ret;
 		phys += next - addr;
@@ -569,13 +582,13 @@ static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				unsigned long virt, phys_addr_t size,
 				pgprot_t prot,
 				phys_addr_t (*pgtable_alloc)(enum pgtable_level),
-				int flags)
+				int flags, pgtbl_mod_mask *mask)
 {
 	int ret;
 
 	mutex_lock(&fixmap_lock);
 	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
-					  pgtable_alloc, flags);
+					  pgtable_alloc, flags, mask);
 	mutex_unlock(&fixmap_lock);
 
 	return ret;
@@ -588,9 +601,10 @@ static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				     int flags)
 {
 	int ret;
+	pgtbl_mod_mask mask = 0;
 
 	ret = __create_pgd_mapping(pgdir, phys, virt, size, prot, pgtable_alloc,
-				   flags);
+				   flags, &mask);
 	if (ret)
 		panic("Failed to create page tables\n");
 }
@@ -1332,6 +1346,7 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 
 	if (!cpu) {
 		int ret;
+		pgtbl_mod_mask mask = 0;
 
 		alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 		kpti_ng_temp_pgd = (pgd_t *)(alloc + (levels - 1) * PAGE_SIZE);
@@ -1355,7 +1370,7 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 		//
 		ret = __create_pgd_mapping_locked(kpti_ng_temp_pgd, __pa(alloc),
 						  KPTI_NG_TEMP_VA, PAGE_SIZE, PAGE_KERNEL,
-						  kpti_ng_pgd_alloc, 0);
+						  kpti_ng_pgd_alloc, 0, &mask);
 		if (ret)
 			panic("Failed to create page tables\n");
 	}
@@ -1661,7 +1676,7 @@ static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 
 static void free_empty_pte_table(pmd_t *pmdp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
-				 unsigned long ceiling)
+				 unsigned long ceiling, pgtbl_mod_mask *mask)
 {
 	pte_t *ptep, pte;
 	unsigned long i, start = addr;
@@ -1677,6 +1692,7 @@ static void free_empty_pte_table(pmd_t *pmdp, unsigned long addr,
 		WARN_ON(!pte_none(pte));
 	} while (addr += PAGE_SIZE, addr < end);
 
+	*mask |= PGTBL_PTE_MODIFIED;
 	if (!pgtable_range_aligned(start, end, floor, ceiling, PMD_MASK))
 		return;
 
@@ -1692,13 +1708,14 @@ static void free_empty_pte_table(pmd_t *pmdp, unsigned long addr,
 	}
 
 	pmd_clear(pmdp);
+	*mask |= PGTBL_PMD_MODIFIED;
 	__flush_tlb_kernel_pgtable(start);
 	free_hotplug_pgtable_page(virt_to_page(ptep));
 }
 
 static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
-				 unsigned long ceiling)
+				 unsigned long ceiling, pgtbl_mod_mask *mask)
 {
 	pmd_t *pmdp, pmd;
 	unsigned long i, next, start = addr;
@@ -1711,7 +1728,7 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 			continue;
 
 		WARN_ON(!pmd_present(pmd) || !pmd_table(pmd));
-		free_empty_pte_table(pmdp, addr, next, floor, ceiling);
+		free_empty_pte_table(pmdp, addr, next, floor, ceiling, mask);
 	} while (addr = next, addr < end);
 
 	if (CONFIG_PGTABLE_LEVELS <= 2)
@@ -1732,13 +1749,14 @@ static void free_empty_pmd_table(pud_t *pudp, unsigned long addr,
 	}
 
 	pud_clear(pudp);
+	*mask |= PGTBL_PUD_MODIFIED;
 	__flush_tlb_kernel_pgtable(start);
 	free_hotplug_pgtable_page(virt_to_page(pmdp));
 }
 
 static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
-				 unsigned long ceiling)
+				 unsigned long ceiling, pgtbl_mod_mask *mask)
 {
 	pud_t *pudp, pud;
 	unsigned long i, next, start = addr;
@@ -1751,7 +1769,7 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 			continue;
 
 		WARN_ON(!pud_present(pud) || !pud_table(pud));
-		free_empty_pmd_table(pudp, addr, next, floor, ceiling);
+		free_empty_pmd_table(pudp, addr, next, floor, ceiling, mask);
 	} while (addr = next, addr < end);
 
 	if (!pgtable_l4_enabled())
@@ -1772,13 +1790,14 @@ static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 	}
 
 	p4d_clear(p4dp);
+	*mask |= PGTBL_P4D_MODIFIED;
 	__flush_tlb_kernel_pgtable(start);
 	free_hotplug_pgtable_page(virt_to_page(pudp));
 }
 
 static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
-				 unsigned long ceiling)
+				 unsigned long ceiling, pgtbl_mod_mask *mask)
 {
 	p4d_t *p4dp, p4d;
 	unsigned long i, next, start = addr;
@@ -1791,7 +1810,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 			continue;
 
 		WARN_ON(!p4d_present(p4d));
-		free_empty_pud_table(p4dp, addr, next, floor, ceiling);
+		free_empty_pud_table(p4dp, addr, next, floor, ceiling, mask);
 	} while (addr = next, addr < end);
 
 	if (!pgtable_l5_enabled())
@@ -1812,6 +1831,7 @@ static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
 	}
 
 	pgd_clear(pgdp);
+	*mask |= PGTBL_PGD_MODIFIED;
 	__flush_tlb_kernel_pgtable(start);
 	free_hotplug_pgtable_page(virt_to_page(p4dp));
 }
@@ -1821,6 +1841,8 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 {
 	unsigned long next;
 	pgd_t *pgdp, pgd;
+	pgtbl_mod_mask mask = 0;
+	unsigned long start = addr;
 
 	do {
 		next = pgd_addr_end(addr, end);
@@ -1830,8 +1852,11 @@ static void free_empty_tables(unsigned long addr, unsigned long end,
 			continue;
 
 		WARN_ON(!pgd_present(pgd));
-		free_empty_p4d_table(pgdp, addr, next, floor, ceiling);
+		free_empty_p4d_table(pgdp, addr, next, floor, ceiling, &mask);
 	} while (addr = next, addr < end);
+
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
 }
 #endif
 
@@ -2039,6 +2064,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 		    struct mhp_params *params)
 {
 	int ret, flags = NO_EXEC_MAPPINGS;
+	pgtbl_mod_mask mask = 0;
 
 	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 
@@ -2047,10 +2073,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
 				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
-				   flags);
+				   flags, &mask);
 	if (ret)
 		goto err;
 
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, start + size);
+
 	memblock_clear_nomap(start, size);
 
 	ret = __add_pages(nid, start >> PAGE_SHIFT, size >> PAGE_SHIFT,
-- 
2.47.0



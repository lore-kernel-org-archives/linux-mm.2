Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC141FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EC66B009B; Wed, 29 Apr 2026 11:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE6B6B009D; Wed, 29 Apr 2026 11:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486D86B00AD; Wed, 29 Apr 2026 11:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 316086B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:39:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5080C13EF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:39:55 +0000 (UTC)
X-FDA: 84712003950.02.E431B35
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id F1B791C000F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:39:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XEO4HWND;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxeVY3HB6jui8kaYjTKV6F+uc/wnZxczk0EhmB1sAI0=;
	b=Muq7li3g6QGuU+aQKGnAuwUTTjdUjgotQBV/g+CZYe7WlTo+dzWEdawn2/XAVGzc5knKn2
	UNDXbHs+0Dw0kzaYpB1HFxLvU9JdIwRlkGknNWh6m4tpjQUo5YKsvAYbhVTIoXmKfMePTz
	ccSwnKXSS674dPS5EVF0esaV6DsiqkI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XEO4HWND;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777477193; a=rsa-sha256;
	cv=pass;
	b=rY45RrM59QDZFNdPJoaH3+Y1n20ThsvY2ETtlpwPOAxGW3mEmde8OztOC/E7xj8d6reKbw
	sX28fMa9DDUaklh/UhD8pgkVGVWkTHERqoNs38kgNsMJQyPGekaOF071mGN05nCIHiO5KC
	5PXarnwXkm9SVlPf6pqHDt94VquTsF0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqkfGSSD7JYN91Dt/T7kQZ6IaInLK9PWlJshcD3Feqp/n25Xtb9e3D3XES8CP4ssDRU7m7JBRUsy+9BjUYAm1TmROgHc87Ip67wHOLuzyb9iMKg25DCCli1YhOpCVImymOjhz459ia0BHxjd46WEa91+3T3bFsS+5hm9QP6MNQjofCebvsKo01YuuCJiiFuwCshZvdeSa33/IJP+Sk9oOP1dPnzJtxGoimRtmk7APUKILUWmXn8zGAXf1IeAYd94Naw1yFjlD+r5zSYVWaWNTcDBo+SqMaJEwwl+qUP4kx+EmazIobVkoo0Cz9FKTNatNqPxEZRE5ryfFpN+O8EnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxeVY3HB6jui8kaYjTKV6F+uc/wnZxczk0EhmB1sAI0=;
 b=xv3RKFgqA/AfntqoRnZBrcJMG75H5eIHfd4+9bKQiOWLzD4MC92BCEih7TU6lnv2XAfwpFLBCaaTFeN+NRWamFansztje+IPtLQnVL5lrfqsJz5zoGNoAyg6j25HP8BlXX5gmhrp+xlxEEIyHmypFQogo7foSluhWM/VdHR139pC040s4WRTC+j6zhugrvS74xJEYsup6+LaTplixgzjMVEHOjMz+Wp7LjKpjjAMU4+5qfTcOpIHdJxHsXZGyscmas1HXr5Wfjr8pvmqm4/P7UVm7orPPD9cP34jNQizCtekWzGNrLobLaGCbAe0Qo1i+B9IXJ9X5BoSWaabgK/iyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxeVY3HB6jui8kaYjTKV6F+uc/wnZxczk0EhmB1sAI0=;
 b=XEO4HWNDiBBJ7aB7OTlZ48x1QBab3Zgi4rmksb2y/i0XF7pe42Qb3JrM5bnJuXwyJ2bW4l4RKnNlncu/h7Xt7NBFMJwAzTU5DA6mEpQUaNLXSuympayzCh3jKYc35eByJ/JQ/CL5Q0yFR6qGlKrPjuEPU/jLWoioFd+ro9wQb/krBzLnz4cM6b08Y1jHXVWfi4RX8LPPmKM7sF/a5aWlEyZj/AEQJaCJe1odbVgA5VnhhGokIGGiIqS2b2kl7ahEM1oY3l/JsqR6dVYp0bnrVK9KLw/w24QxfDHlx3M11/qZ0/W4Da3kdi0piLnCcHATkyW1Dzor3Qdpv8I2TcUTsg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.13; Wed, 29 Apr 2026 15:39:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:39:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 4/8] mm: use zone lock guard in
 set_migratetype_isolate()
Date: Wed, 29 Apr 2026 11:39:45 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A4975BF9-AA25-4C0F-ACF0-46B4757A5EA4@nvidia.com>
In-Reply-To: <6883351ad7f74d20875fff30e0e3214a089cea97.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
 <6883351ad7f74d20875fff30e0e3214a089cea97.1777462630.git.d@ilvokhin.com>
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc3d61a-0cf2-427e-9bfc-08dea6058b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PULV89pj0BlXXPh9WgEXvA5fn1iyytSyXEMa8EUOZxls+vHmCgcWCamZ+WvkdRYmWSlc9SW8gOADU1VwwdgtrrJf4blA8rMDsg0cXE7YkAARrCbUqvYnlIqjtppDNIzgdH6YY439GNughZXXw3Qa2BBMC7l5bOzOgX6W1Zk8IpPzSh4htqyKZSDNIDKM80l79+6aUIP/ygy4bcrt4y9F38rgxcNajIf7pcRNXcvapm2mvmod7kaC7PdIziBmvxNIXFWTCk959FXHzWCWpWL8Tph0eDmGk22OHl2NcyQ3D40Oxdpi6XUP2W/SAl7DmcZKdwjOw2Ry86HZMsOxwvR2lmb44KYACInolzH+LsJ+BIU8sEdpFmMGzYurwBlAHJcxA1pl3j27k3BgAAS7S4PNzpKa63ICnGgVs71TREKZAnatiLz9amPH32XN9xxKDOs0Ag3dtjI1JRt6TaA2JBbpoUalcr7Z695a0b6nf1T5K6XoHh8l/CfmoSG+lxjTLkskOkp5owPett3Kq0/gHOLu+iJxaIbXoTAt3zqSsZvkbK2OqZj1IEhXr5sbVB0Tz/9OP5GSjjw1EgmKUT3dPEOXy6vHIEwhRNxN/DyA3Q0727C6oqNdKEMe+CtpWlyZrABpOYKnV/3RgcaPYkc3gXEjhPABfxeS/ez4cJXAzUhsslisDPh+1vdpC43EG3hPlk6Xj6PL9uM6On46aIgK07fUc9HNSEQ7mrxoQwzuGD01AMk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I1UHTTH4hbhWPvnfFKjE541hGDQtxUgA5gh9FQDdblMa5uCLhLsbhCjLjyTu?=
 =?us-ascii?Q?qKCgnFg2bB+PXl0DyX8pR1rVp5XX7bkNIIucfw4yaRJ/hrDRiy40AMdKKvwJ?=
 =?us-ascii?Q?NHgtG2pvD1vhahobpjo/iIKuzmJ5KOvcvjtgAKQ3FmqO2ohO5k/C1KT9aWRq?=
 =?us-ascii?Q?YqRcZvfzTDMUX1Lp04BODRQGoudlY5+xqAuJ/MiZlnci1Z6aTXgn6IZGPn0w?=
 =?us-ascii?Q?LXR3SjIvEml2TFakXkoY/BBO+U9VYQX4mOndEqyzl1Qs8l2WGh/ChkCG5A8Q?=
 =?us-ascii?Q?4CYwPMeSNgpLzICeqmSaClSBq/gCdrgkpj8SoePHBKR4seVZEcnDiQ8noScc?=
 =?us-ascii?Q?f72M3rxUoM0D4pVGBDdNYINlUZ771Jt20p7s1qgNP454lprqeuw5ghHGDI/z?=
 =?us-ascii?Q?PoCkgv6Isr516I2Dc07hQJOF2IhMwZxirdAZhwVOddRTwdPxfIzqCCM+LQyI?=
 =?us-ascii?Q?poeD9GrBsU6Q7JkEPUIqI9rzobLCHmkQBwk1sLHMhidAoh5BeSZQLpRiRwdW?=
 =?us-ascii?Q?ynCPk5ZGCjykXK5ApIvfJsPkU9gKzYAusO3q93pIhYWmaahO47HUZqu98Fw1?=
 =?us-ascii?Q?SVQ1XyQmsD3APa4ghp3cewZAEltPQNqH5v6dUYP8Pcsex645CvdCxFgnuPlX?=
 =?us-ascii?Q?2zqS2temF0m8dju7+iJV27TEzpEQq1NbuTSczyMOG2TdNXEsb6lJeqSYZNMR?=
 =?us-ascii?Q?DVLZmScXBQc2YgqaG8flWrfDn1BlP6G17rif3jpFfuf3dEbsLb5LWxFNFaqF?=
 =?us-ascii?Q?oy56hwBHdGsZyd8NPn45NepTWiNgRb1g4dM2Wq51uZF1REcemAP6Oc0P7CSd?=
 =?us-ascii?Q?YcoEzqHRkioLgz86i6AUFsXam47n60NRY69rmyp4rKER2Y07nA2hwFdR9I2e?=
 =?us-ascii?Q?7xNEh712YrKuNc/2XI7fVg7QG+2d1IK6whlLYAb2SejXVBNypal872jg2Bzc?=
 =?us-ascii?Q?f10asqHeA2Iyqx0GzSTzZ7As56+iO2NHfdyvJZKCk2a6gGvPxqGjY0kV5tH4?=
 =?us-ascii?Q?BKtqk8FQBj1h6RIQcjdEvgSFggwSUDEEsIH0VQpfqY6BMvuzEM3sFW5Yxilu?=
 =?us-ascii?Q?azGZyZ/EA2LCJEbcxMq+Cdx3iaD7BU+ZD2jZEeWu8zLDImGrAXn3AfmTm9KS?=
 =?us-ascii?Q?yyHLB2cpxqvVEPQ/V1mVieObgpTH2qD+Y/gWNiQIke2tIifttukG5KgvuiIo?=
 =?us-ascii?Q?XKBcOCZgebgWXZSrsjWSWY3z7qjjWYKV2nuzyucRqVMWE5DNSzVvIUiEchbB?=
 =?us-ascii?Q?oOJNNWaDPW/7hT6tt+/UYwigAc9mmcaW0m4vVRxfV5sqM2xFN2WL5WdlNsAy?=
 =?us-ascii?Q?grC+1SdALddhCacULRqD61t/Up/RNWw1MUb+aTg+gIIJMhg1c/9NQv2KYN5P?=
 =?us-ascii?Q?bWm4ypyEsGtBujkT5RTAtrxQjvst9ziJK9qRD6uPoFnJVyHx/Ez0xSoCYEPC?=
 =?us-ascii?Q?elN4RsgJd8hqtBYaFP+NBaM/xP3Rxna8Xr3utmjOE4doWGLg1Tj9rIT4PteJ?=
 =?us-ascii?Q?5VxHetL9a/TS2+/J18FbigKYNwk1yADN6mw/4n5wZ5bgNxJmKwAkbBf5gqF2?=
 =?us-ascii?Q?452ybl3e/JQTq+OPzcHnJFoCBloHeVO0MU4b4cIhqbG9O25S1AIthOvfip9b?=
 =?us-ascii?Q?SwEqH7sX/lXQVsSL9qzOJ6moBUXUFdWGZfaO+RdvhhS/XmUsEwxEt4pb6tCP?=
 =?us-ascii?Q?wL7eqwxEN5VQL0FqznenkfdPqxTfpvGvOVPUzpPrOKELl6QH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc3d61a-0cf2-427e-9bfc-08dea6058b56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:39:47.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pJkBfgzkv8iyOlQKN9K4jH/6qg/ROplmW7Qg9J4B/rx0hV6iJgns5+CN0/PQGEJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230
X-Stat-Signature: z3cieud51e1p3jkouxindz4npg66zm13
X-Rspamd-Queue-Id: F1B791C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777477192-647975
X-HE-Meta: U2FsdGVkX19R5H+aQ/cWRJuXzdoqHWw5av4hckPo8E/t//0CSkNbvxa+vxwPlV3lALEmgS7R+BZU3AZLjSdc2B5GfrL55HhmfL/MhOhQpQGHyJoSgZEofh8bumAzhXKDlKR1aUk6d3HGzsspwc/uF448CKQfCeFzIkLWinuzcHz1wXKHIlFDwgaPl/3Q/ct9kTswC3CIG05QR8Zq+i0ora6sTWbv7GA4p49VeXAIMCh5PfNchjJUphd0bLR6GyO5ecy75WSXAriUHI5kzkpF1neeaZ2Hakm0Wa37o+gPHxXrzfdx89/XGk2+t2Rxwcv+Z5W7mSDLg37LLOR+yC/Gu3axjM5sDh9FQ14PL/bFNmzMrW2dgk+N09fydg5e4K6pIMQfvHjIMXlA2IJW5wJjRijc8XBc9Sdtyk0lxMRu2Wpc4ogTyyRUPnO/gJhb3i/ASZNZDtBcNa7Mx+mDzD55D9cw4Tb6QikSfAeIuKSAytKWSmCo4Iwo9fyCCqWdkRSguTEBl20O0nTeP4B9QhIUrL2JMSXbFc9anKX8RbmKaTjZhGevcmoqhHd+w6AXEeEqR6P76hlIESrcX2/F+8LxR2+4T1fNCZm5jUgXHF+Yal4Jsoqu3speXSbQmDbbtrt//b+JS9vGm+h8OUZaSqUTjIzt69QZqD09OZndLjJTEFco+Hpccf/wX2ZPC8EgMXun6bxAoolPkMt8EBVCtDmhKRI2VbKgyGCqDJXniJlXwBZ/eoRDGXDOcXaCivGt2myeVJR44DrnWe8n0wtDf8kcEZ2F5JdbaRbC0EtzFhjdIPWtLnTjm7WOxjSwobQ611zuuFqyMkUsLEpkOSvPL0tu3bF5nVUvIQ+8LMDfgJMceMyp7fnQUdFhbcZaIarrykP/uZ0pZ5pzPy0dAmTUR6g1DJ0atrRujlxU739knC03tglPlWzdMFCbn76o5gH2k59LQvCiJFH+bEDLPTCRImN
 uFd4hN9C
 ANTu/hL/JvDHtJstSX2VV2zpcHxXyLVu4iyJo9VqdLgA1wkM0reCEUIdA3S9r/REuUM8AnV71bD3KFYlsehdB5AOpEX1suwoEYwG+Mn0zS2CGKkk9kz3a8VqMcJ8Kdgo4tVcAiiU3FSeMFwteI6/jn386iDUByIvfzpiolimKiKfHrsM5yrL3aYcb2Flg/+fnAi9PryRUd0TMzZQR810FJcUxWW+j7YVQ/08rTSYBxe8ZHzP6gL1bTSz7BpWVRBpaClD5AmM6G0kan7mTWPce6fHozDS/aqBuQd8atLigzxo6hPDwT36PTKhS9LlT8nRVUXPWyAQ3GS1tecBS785JB/SyArBw6+gQpFyZaQYidkKwmm9z96qEcni9LCS9PqErQ2rumXJnEj7ELb+InR5Qee04NJbmNelXGkOfbO2MVMbnorHyxmUsPfKuazd3tYKLzh7CcCtvKgNethiTL0ffySTNgLHtBIuN5A031hY2extFMdjeO+WXS//JmgvKXBxlCUUgV45Djqv0IUjsabxWTfNJBjAX6ED6PqvzwKa1PBwBxtEEm+4tlnEi61N/xXKvqBxcol4RzkbQ/4qdiM3O+rlWgP8lFcCkUx5aeJfJ/2582Uu+nlA7jmgu1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 8:02, Dmitry Ilvokhin wrote:

> Use spinlock_irqsave scoped lock guard in set_migratetype_isolate() to
> replace the explicit lock/unlock pattern with automatic scope-based
> cleanup. The scoped variant is used to keep dump_page() outside the
> locked section to avoid a lockdep splat.
>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/page_isolation.c | 60 ++++++++++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 34 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


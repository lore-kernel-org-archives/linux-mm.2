Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A318C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACFC06B00C4; Wed, 21 Jan 2026 11:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE096B00C5; Wed, 21 Jan 2026 11:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DFF6B00C6; Wed, 21 Jan 2026 11:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7486D6B00C4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27F72C2B4F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:23 +0000 (UTC)
X-FDA: 84356576766.20.0B35330
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id BDCD1C000A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QejbUO3C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bHhgXR0F;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
	b=C2IIm1MGD3OwD2VyI6ilsDLZsotWdmb8V+8aTS3IedL3XbALsbAdrCQF54a3Clc/7LwNcI
	s4X3KDcfUdKUor8P1qtRaa/9684o0QMX06+LbMdIK5LunarZF993Owzi5LVwUAoiqcfdyO
	l7knzNeqNlUxE2z23AOBtFQ4d3QDsnk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QejbUO3C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bHhgXR0F;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014639; a=rsa-sha256;
	cv=pass;
	b=MZjMSC87Ey6fEKP3U0V7A1g5gRbH/ndt8ZuFqP4FP/xI33QCFHp9q48zzekT8Zuk5EZIOw
	w2LZFirNkw2QJ0Rx83urCPxRYwCNKvFZPGS0MoAZrwIQcE/DTdVreXEisTn+rqKVAbp//m
	TZ+Ocb955nv+F7pwTTVVBGh5SmsMCAA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LAk5ZB3418986;
	Wed, 21 Jan 2026 16:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=; b=
	QejbUO3CrdROwIWcjF6apl2KnwVc8LXnnGxF3EAt1oOgkbKnBypPg16ztuNLxqpU
	pahKeKBWvgKZzPQ/MN6Y4eUsEi+AmH6R8zXbcMjX5Fg6qwKC+CUsG7ai0pk9C5Xv
	uDJf3fDMo69TR/DN+h+2TTnLSS3oacDRR2sMveSsh0x8TXi5bV+1ngeiEx7KmWNR
	1LtMu6SOFWcVcrqqz4Q2dBKD/dfN9zT5C4OSCbfVA3PrmPgvEWDGLX+uhY9lJVnO
	mmJbdgfDkpVXaM627hLq5HnL9H7zp/hfUQzRJFYfRihg72Adi4OtuFE38DcIkqFx
	aotiQxCpuztpdT21QbDTHg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFkkhm032159;
	Wed, 21 Jan 2026 16:57:11 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfammt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MLAjRNnI9WL1eSFGOnUpZWm3i7MU5Oy8uEyoIXuc8HNJcHzPZSTQwp6NWa/k9klJQNARWx6r8sjvcQroTQtCbBv0A73AGmF+NcAfJd7SsKMRCzFveVJneFusmkliViana12UthPVJFe5X4AJ+HK36s1a9CJT4t/bh8tsBuJxk5pFkEWSLygBu3RGFU0lDWCHWPoh4V0cBiVGWCsNU+APUXnVK+BPdZ4rL91IjzQzqpw5VM7KeqYqvXSpjL1UG7NiuCp5HMyZR3ffeRYhb79/TiCeN2nwvwmgDvvOjYHfj7UqawPBCa8pVIbZL0vkpJEl49VMUS8cTCxAorNfIVAPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
 b=HUPo7mF153NT94TM2y6ylnHQLQUeYo1OynrK4ZyOvMXGF6VC/JPofbkr94U6p/8Gho7RlSzk9rkNjXk4KQYnhQCDP+B/4LPrtzr65ItzT0TUjO9r+zua4jj+fkQm9njkbYwIqNU/MbiC997x+PE8O2faRYGPBKdeOf9LRciwv4H1zjJvE9bwWrylz6Eg5lF+2nlaDKzFA1E+AIUmg0+oHrBUDkEvE/dy5Efwc75xLnHvA/z/BLE4UWtZh6u1wQD300H7p1Z9g3iH4ZghzzTy+bNm2nAtG6/5e4LzvjW6RoWAU9KNWGWl00YZrT/EoloeazIwsjooJsKyBTUt9QnsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
 b=bHhgXR0FM7Z2YXRvh+ACS9iCJQKZ+8XfbBAPctmems3tLSVKzBh9yWJzAOvDr3okPL5ubFQmn0mmYjG+pO+T+x0BYqmyZqUdaDWjlwgBhb/EFAaBTq7jDVeRSIRJFfRxSHa/VA3O58bNeJJvPliAg/Jyg6p9A8pkYywMMkRgalQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:59 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:59 +0000
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
Subject: [PATCH v2 08/29] maple_tree: Don't pass through height in mas_wr_spanning_store
Date: Wed, 21 Jan 2026 11:45:05 -0500
Message-ID: <20260121164526.2093265-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: da4c73dd-3bdb-4591-2c0e-08de590e17ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sEqMAXxn4MECHrJJ1v1bWjNAKtqqn9aBNZXlNdgkCbLghCr/sy8YVchmfemB?=
 =?us-ascii?Q?oGTZG/irU9EFWPM/XOgcN4mK32o1E42AYwErha72cBj7GdTtnD6Ku9DXeao0?=
 =?us-ascii?Q?aI9cM+SoaIEZn9Q6QydcskcE34xgXppaGf9/uz13pbDelnc7uck0yJ9Az/tF?=
 =?us-ascii?Q?KdtDIQfySLcq+SAn40+vynIoNZegwl92u6rzUzNtuAJmmZXDutzzK42uXIOv?=
 =?us-ascii?Q?uyCXpTGIsPgJFn0nL/jvGi7379gOPnCk80ifyINiBxSuAFOz4fRqo+GL6qQg?=
 =?us-ascii?Q?n0ZZt1YWMNI/EEgFk2hrueLwNCKD0Z4Ved6OeqAANQbmlCP3zRVY1rYnGjYz?=
 =?us-ascii?Q?V5k9Gx0cWeoiHDr2xPEyPIrlKmth3OEV1ddwl5HYR2Ufmme7jNHwWHxLYusO?=
 =?us-ascii?Q?6wlh0HaBXjI0HzE9hyjuAnjcRzaQV42fzgJIFl5QPADT3kT/enJCZSVlycGL?=
 =?us-ascii?Q?n0V5k2SDwD4ojwlwnF5gZDw/L27HroU8PjY/MP/G6YXI2U2P98wteeP3P13I?=
 =?us-ascii?Q?4HqPmMGCgt/ZM9cSifFUj8lBVrg1l4iBIz2OUgMx6y+AM8IkjgWWa/eqUybT?=
 =?us-ascii?Q?2eV2NC/dbrDj5/gbfOpIOSrIc8l12Ff3VDvsuxEUHVNcviLmbsd/eO9QEvtB?=
 =?us-ascii?Q?IR8ytZrl229H0Gw9zRXBLPS1PNaJALObnLtkkRGc9VXT/TempcTqNbImuIct?=
 =?us-ascii?Q?cX33gnYlJIb36oPnkKeCmdXYyF1mQyNdx8bj9RkXIHRi/E962BS7W/nNfWo3?=
 =?us-ascii?Q?O04uBjbMlzP/uU4PTGzoG3ALb0PzQiMiGB/GsURLuRoucNItLx3tIjHm/8cb?=
 =?us-ascii?Q?MSddftpQGjMPkkCS1sXU5y77+EvcfNGAU741KB5ieWLmdVTG+XuiwSktim09?=
 =?us-ascii?Q?3XgAZNXmUlHVkwKVz055cRYwxcmQIgEigk+P2urdz1SdeEaO2Iz78/Mn/U4j?=
 =?us-ascii?Q?LOX3waeL4uknO0L3H8cVu+vv1dGIdcfvqGRVjDkcDrJ7xaE25ROo29/HxRKs?=
 =?us-ascii?Q?0td5U/DML/GPecPQbcoG3jyVnbrTlQHQ/2HztOgtV4/GfBeqwBOwnksM3odl?=
 =?us-ascii?Q?ZkMoKyOohVtBFkIoIu2+LIlFlJj08i308uDyvDbtP2/FeaMvkscxi05jVRvZ?=
 =?us-ascii?Q?C6HW0cDfzxRjpbgp6hTChkOEkp6a7JVMq73PJIz30Ak4lpIfx73hQbNcuK0e?=
 =?us-ascii?Q?kZng4OzmwJkjKOfD+OuTfSGoQqP3rZ6IlgsbyFy54dOFtiwM2y51QPoXUJO6?=
 =?us-ascii?Q?Ebov/Am292cp9htr7sgh3pTQM2vAGMR2giGjiDXwD8DgEZV4P+RbB8jUg9d0?=
 =?us-ascii?Q?RH2JrwuAPUsYUplCNeMRFQdPYelENxN6MMfEpKUrpN6bvl5Fu1dRD9fCjpIO?=
 =?us-ascii?Q?gekajF5tqsuVgNNG8G9zt6+drvbTxUYYjCp0nZFIMQINjTzyh8AdxKjUzDv1?=
 =?us-ascii?Q?yZVx43dRTobrD1rEP5abnEcJciBK9t+ydvHaLMo9/q+C5xoDrGgyBV1AD70M?=
 =?us-ascii?Q?GID9YiK7ISGZA/y/0TXdKC62lbkEVgEpjjpAzrQy9tMvcHI16oXUcrwd6WQf?=
 =?us-ascii?Q?itKNzEgHmKA4DETxeww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWvy2K+66ncj1/7bK1DRLoLjJQuKDyxeYCm2HM8uY8rIhYFcd42/SeCTcSn8?=
 =?us-ascii?Q?BF0RHCxpyI6gcRsjEnN1Z0aE+bTXldWTfFggQ16Hy93IIpMOunAflkpXR/HQ?=
 =?us-ascii?Q?xvOdLsYyZMGYgKqVcEimyowKLaEQQrD/4f4gAibbKwFiPssQ283P/T6Ev9cy?=
 =?us-ascii?Q?q1Gs/nhEBLB1u24kaaInwY31wJwDlSBQjAsIH0bVfT5THrkAfk53nvGDkFGe?=
 =?us-ascii?Q?p++sWStG8Ec7C6AAndyCK5ahmB+4/2D98NweKpOgLAb5YFvL9AgeV2QIBj9m?=
 =?us-ascii?Q?wm6IezSTtFVI52DDtZUNcJ2IOIOftKAyKwzWVpml8RfIjy/0tZQpKUpaG/sq?=
 =?us-ascii?Q?ScNdKjmT/A1R986k4AWMMtrPVcflS1JEjiJf8K4XT2NeC7qnKGTBvVAWKL2V?=
 =?us-ascii?Q?kndKONUICTG3zmhi4n5O8hJbU1K/cznFL6KDoj/ZoqMljVLllWb8giKs5PQI?=
 =?us-ascii?Q?7spFqang0IUFBreduYfm/tg5pfOkijrZWz335M+rzqYPM30lVF3GLmMPnT/v?=
 =?us-ascii?Q?FTMGIajODRaCOAM2m4+vvKsoD3s6qXX+vsg1b0IMWjlQZMpG8GM47bjm21Iq?=
 =?us-ascii?Q?STYPhdc+ydq207QDPhookBoMZphGeSBIr43idsOfrtHfc6GkjQu08FTCsvyR?=
 =?us-ascii?Q?FfQccoPVYeScXYlYl2dgC/dIrXslgBMzjdKJEG3HjDqA9EWcxhRJ2F1epfad?=
 =?us-ascii?Q?QMAwbRXuIolzUQSHQLZiX9P0G6d0urnUwCWU2rXc1P7JZHyXk0Ny0cPnzRQZ?=
 =?us-ascii?Q?LCgIP77+j69XKt+Pq7hcUM8ZCoo9IMkaqk8igBY1wwq4HiKnXZ8k8h1JsvDB?=
 =?us-ascii?Q?4yEmCXHrjoO6A29/Z6ViF0J4HrPU9qy8FFDLjaSJm3Rr2NtHUq8K77JHxnTD?=
 =?us-ascii?Q?rWzk5qDRb5xVwqI75bLLKWjDgxZoM0YWm1lwwnhVXJVcDV8OOD5Okad0qrdy?=
 =?us-ascii?Q?2iA9aOttQT1rYog9Q0Z0eEo+cM85b+2NO46a3dmcSm1z9rALO9hYK5MhvUEx?=
 =?us-ascii?Q?PZTt9otvgFT1t3XaTWtLgPcbVHr2awvrFy+omKq8iUyC4bmzwUjziztA+5DS?=
 =?us-ascii?Q?k21RAzWBCQNzq7JmP72KHc+Ax389GMmnOxLR5aPkUlqs2FDDSZhdCN+yyPDp?=
 =?us-ascii?Q?oR2mzf1Ec+ANbXmMyxWjM+fqVuTTWYizHhvnpc9D731Uwir/FqUnZX3EiaDu?=
 =?us-ascii?Q?dJNfezcpas+E48ddsA9zd+WoDK/2UK5+Nw9qimIE0owUI10RBvMG98A1BjTB?=
 =?us-ascii?Q?rm4KZ4yRUDvXm9VEJ7c4JkXYFi8Q3ePvENVwraadc+TlTflDaCwuGKhjXTKd?=
 =?us-ascii?Q?RQS5xq+nrGcLHCt/kh68zF8DfrHaT5Jp7lHYQ+JvH0Z+KaHkTilFApms2UbJ?=
 =?us-ascii?Q?+4z6W2thBRt8pNmpcaW2dDMWDTCemLHccvevGK1ena9Z2c8Ht3fYm/EXGhTO?=
 =?us-ascii?Q?zAQVzL1suG6H1liSysefnjqZ9E6M1HE4mh0LjGLteigAnnOg8w1jvL9ru5SH?=
 =?us-ascii?Q?cDjrVIePiTiXE4GOnxB2ghv5Kvea1eLAg6XIPE1uariqc4pyYJxlf1XoZl3g?=
 =?us-ascii?Q?JPCQyGp+M06+mkZsJ4SsWi4B2PxAlOdXBIXpXwnHz0espPwMsbLHc/HEwg5t?=
 =?us-ascii?Q?w+mUhfDw8WiZs4CgKiyJXJMwakmt/7MTF5J3h93pI2EaUGhaJuu7E7PBR/9Z?=
 =?us-ascii?Q?gegEDo1sAnimCwuRdoaMFFKj7AmWoeVUdbSj/wFNuIoOZ7xs5tNEn7Fc1GJh?=
 =?us-ascii?Q?N06FNV7CrQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d5M5E/J+SsBETI7neJPmEPmAhnpamqn7Tatb5e4zWDa9x3yh8FJY8KZ/wOP5A//rXI7YTlWTyg/7A83GvPRfZALYVj/IAz2MWxkkPGWl4kXakhZ9exOSo+tp13T+u3YVUAs9uxAIIUVwUvfWh4KbG19UOwlnM6wj6telu7/Cggw81MERidGpXJ3nHPCeWaXvwm2RflRNdag0upkCJLzGJgsoYcHhao1ULofPa+dmhnm9kHTo96hWU1AOdJvmb2IfU1nFlK7spJXHmLszAUGDygXw4KwHgEcfyjdhi80IprhH+umotLAg4ZmAVzL7B0pFxSDph6oSL3vSOzrOs1sB196Pbl6QmZNMKEP395kDTxoBrfkvQ9vIjaHRmiOcN4jPHBDSOhFhK6BO931+Axp/YORkv9tkbiLJefQZlmUp6Nq+DL94aE3xdn8qumbr5wLyguZd4IUhwALn2eqPqhTI8NXN1ZGufy/Z1hCEYVLwkHTxtJuy9o8GQMNSKoxy5b96TLZQDVNA1CtbHLk6uPmghtYptIiWR5Y0VZWrgPiFp5/84F5duawYGfs1waeCg7DPupjlJ1zpjUt8hoUh5rrYy8JGHasDL2JGQvhk8MwOTec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4c73dd-3bdb-4591-2c0e-08de590e17ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:59.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 810RzN/U5RdxQ1m+V4RROQLWSpkMqJbpz/mWIS+GmJ+0qBlESNxt1V5fask8ZqC9mpDOq38j7/Eg+kU7O0ywTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69710568 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=OdRVoOdji5KT7ucrDR4A:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: Z1PnF4RqtiwZ0HRF_83rt2CZeIk4Hk_o
X-Proofpoint-ORIG-GUID: Z1PnF4RqtiwZ0HRF_83rt2CZeIk4Hk_o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX46iyt7UktNeT
 SS2Yz88Xpl6O5G+sJQxjhBvlZjrKsAMqkTh+sSm79I/jFD8nxFALHFAy8s8flnAJEHDmyszk8HJ
 sfi073g/TaIc1Yzs9pBTmvCLcDiCwL8u1FQwU19S7iOsLhONkf4hyyMV902agabJ2yaZV3LbLjB
 IqYd8QVI40HRuhqCcAE1hi8mH2b7tkYVvovG2x+mwHzfa6t9RCQeqHenm3gG2i2s6GUk5Gvqkfo
 Iq7M2nhMreDqLFxSCTr1OOBmDE7eNTsVYNT87IoSgIIBQgjQTJX1oKt84CtBtfQMpaxlskswjV0
 JccJSta26AT2TgmpAgNDRTqKXA+5dDdWem8zkJ3pDaT2YYtkhwOSbfz+tanpnReFLVXjdyCXvwp
 OaLToioRhwVnoPoKqXFjOHgcak//xhn85TdXcaOWWht8GQ55ywNlVWlHdzafcPNqKfTUiLjwa2Y
 5h5/dTNswF6/y8hVqlx729kRl723ZROMiOaqkpBA=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BDCD1C000A
X-Stat-Signature: mk1j9ig64m3mewaczydpik1cpu6ncx5p
X-Rspam-User: 
X-HE-Tag: 1769014639-909316
X-HE-Meta: U2FsdGVkX19ZZiEk8+t4GeY+jpT2YKwOZhtVDz0o1KZjs5qM1Agx2uNmfjEx6jHH75V+8rBwAtw3IWE81+AzzkIYt22aPLSPY9hAZp8JJwFwQ+R0oDbntcQrMAqBQMy1SNl1u8Qdsl+JgP9HiKKpoACeurBCKcsphkp9J7ANsNvEuRKygEksmZAXqI9lieCswkOqUXnOtAh1ItvbJtNbmD13vxZUKQQJYg9PNiErbfZy0g91puR/sz9IAI8VhH9IqszL95RxlU831DT3ETreUdemgcIKZ81MwnitcfRynuOJGhrp71odRReMMWrCUoDLRzwy0uTuBckMe3K2dXpGRo+JdFizYUFuRj2Stk4DY+TVOnJlUCjogOQFq3FCC1vMXy3XgyZ1lDL8QhNrfN9nw3WFEyEwWmv/+dja6SlMTWrwmRuBU8S1V4wsrVaOEXAAhrzUguwEfNEtpcmRFNA/pJMby0Lrp2c2HKsEcdR1QUH/Q4qQNWXJvvfkeKXw+THx4GWoAgV+ysU0DcFKPUICD+rkK/be2q3FAEPJeVmtV9bc7HtaOzzMRyySrdGZiLMUvlZ8DYbGgzxf56WZJXPBQYa1DQEbYWykJtjr3MKVXcAi+hzsWTCIjcyhqy93ZbSHcksQsCz/FeqBiLDd3i+KyvF4L8sWOb0/m1bXR40X3fKrd4NustI6CNW+VahixFRoU+6llYIv55/Gr3paMFBREiMTY9dto9UAWeMIQRJ8B0CvkV2qZFiXyvVnkKpg/4pvTbJMh3e6IppvLOO2Bv2dIYt7hIQiTrL7ws2dIqHowJj3wheC+BO6Q12Dwi940/ZwCPAsUn4+Iknmvx9x5AAFoTBvPr9rkm3stzVYWzm6dJo0wgf5GsYIPi66+YL3OGvoGbb8c28RUH9bYLbiHAPxS/m1/zj+7eI6PH9KaboHBHrBkApjj1S5uZcBCph+FjyGHualQlF1cxTUBeFoLku
 PZYiQ2H5
 1NauajPqEHXhc/X79tY0tMV/Lj8oYhNaGkeFAgFNf8/2RHyKYllFO5/VryN2Z8IjXIbYG1E3Pzz/B/Zt/XXlLuasK4fBCIbSe1zfDKayZvjhUjESDH1922QsCfRCTbe2pHCz+oz5oStTN6B1Y+sE6zcwuwDsV0NLxJc9/clzuYdH/5FW9NyGg8JSePaeor0VeeS1wGLnPTpAynK7gwSpvIXzV4vR3SImG5R5hlHdBZf2UcV2Kcs8pAYNMIZ4ERIhG7eYPQwaas25ci9ez4vdz/gaeb7oJDC4m0gaAPIzyU4JWcoxNJKZZ8ThLbsF+4V/r9/YmtZmWo3d2JjWWEo/v8zbzfNtupOrxcD9c39Qdyife2AQxqYd2OCXrq22JW7AnKFKvlPI4BRbxj7XqLLHzV85DgOVfSZKatwC2x6TfjaZywAR68WGVZeIgdo27tkqqZZZlIq6DjV1eN7I59UPpqq9pYihMotAuQ4rT1YG6oqAmdpUTt3DD4qjArcjjyOdQLFjvRmglqq3S3fMCwbO3yi2Q5NUhOVEMxLNXJso7xbroXQdik1YZrxop9DwmxUOR+Spe8PybjoFzFLI89FspHJnQkr1VJAjBO2MnIQhaYFVpx3YfV5yeLOyoKZQe4KUbNYv1V3o3G4+WntMxGdSUyH7tv4iaQSO63b4ZRXnifJXUQVRzKQnrXHoT9xn8Jg/H2ZDv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Height is not used locally in the function, so call the height argument
closer to where it is passed in the next level.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index afa39bbd687c0..91d3fb7ac39c5 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,10 +2750,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *wr_mas)
+		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
+	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
@@ -2788,6 +2788,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
+	height = mas_mt_height(mas) + 1;
 	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
@@ -3448,7 +3449,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct ma_state *mas;
-	unsigned char height;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(l_mas, NULL, 0, 0);
@@ -3476,7 +3476,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	 * Node rebalancing may occur due to this store, so there may be three new
 	 * entries per level plus a new root.
 	 */
-	height = mas_mt_height(mas);
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3509,7 +3508,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
 }
 
 /*
-- 
2.47.3



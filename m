Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B70CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE16D6B00E3; Wed, 20 Aug 2025 05:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9306B00E4; Wed, 20 Aug 2025 05:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59F26B00E5; Wed, 20 Aug 2025 05:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 901836B00E3
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:14:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E84258F74
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:14:29 +0000 (UTC)
X-FDA: 83796575058.19.6E074BA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3486C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:14:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SgzrGyZz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lrgUCB+8;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaL/sQXF2AlBkCYvMEPjcfTL1rDEs4wFosBNOJjKFNQ=;
	b=kWi9yjqhTniRzKdCFksMTfsYbBupCM4bvAAIKA04QZkTpCqpnMrI42ARS37mnQu1jUYu0r
	cKvuAoTq7HbBgGBC0sZh95idqIx38SzIrHEPbHyBctYtJ+uu5zvsWILi2NFuARd2oBiXgU
	SAgE3ytGGbvI9vaWRXO/q9v+DwFJdyI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SgzrGyZz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lrgUCB+8;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755681266; a=rsa-sha256;
	cv=pass;
	b=p69XU5smbE1MvmGAZz93UU0sBj/cSebFWmDG2J+kpZaQ4sIXahaiyBiDWvJGXcldgcwV1X
	zda4hjIThm9U1FSp+R9s+PjRNzRPu8fzp0TN3klHlaD2kXndRYCLYDQeE4umO0tD5AbPlo
	SaX80MtEx2p58KpiX7Ax7tzWTpyJKZA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57K93cBK017128;
	Wed, 20 Aug 2025 09:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iaL/sQXF2AlBkCYvME
	PjcfTL1rDEs4wFosBNOJjKFNQ=; b=SgzrGyZzcx2PxvUVPYJwZCiFBwDutTkNCu
	GJ3oFa2wYFM3LJupHXkMZ3K6R1U3THaw6vqwfr3n9wYy3s+zgTRqDA0UeBt3Ldod
	quublZeBETLWuQKyvC751aJEYkrzIODwk4S0LKyFsVrrpKXwp6AeUBZw4n9qlpZk
	XjfhzpfqPcgalOUZAzxF1yPJc9iEKgfdFCRuQrC4KMNB/KcN2xpuxKjwda9OzAEL
	X75OfK/2eJ2+TQm1JEB9g+yOywBwyfyXFPBeA/jyJxl40JOpOYaixEXmO+Fa8TGq
	ddHuUhG4Buu3WuLuceM4m/DTScscxm4utyhC+rvO3ngHQcvt/yiQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqrvbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 09:14:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K7bhsJ007394;
	Wed, 20 Aug 2025 09:14:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3qgqdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 09:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRDbS67DApKAiGzBpUM67Ls+5ovtiy68zy2woFBUf1/7ZqHz4P/BYWj+0bnH/bJR/unJ4c47j/n5Uo4snxr1B5GiwUCnx/j8BFtE8Z9c9lciyre4X2KXFR1PniVaXqwyyMuSVwa0Hu8hp1NH/6uul0aGySkHLRiehsndNxMeMWSBdDO5+A0NzghUid0rSsgmn6kHBRdI6AGPKQbso5tp94DZxwgXYF5k6ebmNsW0xs7T+ovGlS2slvf2nEdgPW0Vm7zvT9rJue463r3gAb5NNTTrP7n29rZ6IRlBXZGcLptpmdI/kEcv7dzz0OtCIaXuSE4xZmys1XKs9IrnsBeqYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaL/sQXF2AlBkCYvMEPjcfTL1rDEs4wFosBNOJjKFNQ=;
 b=lXDummzVmaVtgrTFJX0J+CS0vuxAIxr8eiG9ySqghCSf4q+CbAJF4ZFnGs5rrOLJJX1ztVPCsp1ik0Q4wUQPqiE3a/velWGnJKeFsUoTIDbEI2fb4xnav7igDfWqaQ0aB43zU9gofDCZpXpcDowxbRTe4Y31LUPQ4frsc7RBNIjHB5RBSP92yNYW3bvsMAFwy24VsVBRFM/CwN4m4KQ9yizeubp2k9wISl5uuozA2VIbnk4OGNlEzCCS3CDnkiqQEXrz2tZ4hNyTWE7kec9eQBto8rQHtpvtq5uH8qTZdf3AoLFAnxwdAu+qOwrM4mKNV/drcZ8iKzZ6aaJEHioV+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaL/sQXF2AlBkCYvMEPjcfTL1rDEs4wFosBNOJjKFNQ=;
 b=lrgUCB+8+H4Po8yA3cINz1sMd9lWaRs+spK0BmnHiQoPGIWxQhKQI96TWf5kV9Nn2/Zd3pX+JPtqBgKtTTNudLSzF59JQ0c+AUH4S4yiA052KBcMQ8V6o+8r6csHPOCLLaPUfsQ1N7mzwLArivJePgZMfGkz0O5+WjmCtt7VJNs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6315.namprd10.prod.outlook.com (2603:10b6:510:1ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 09:14:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 09:14:16 +0000
Date: Wed, 20 Aug 2025 10:14:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com,
        stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH v1] mm/mremap: fix WARN with uffd that has remap events
 disabled
Message-ID: <4d00f16d-1e8f-48bf-8fcd-83f827c9928e@lucifer.local>
References: <20250818175358.1184757-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818175358.1184757-1-david@redhat.com>
X-ClientProxiedBy: MM0P280CA0103.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 84f2a826-17a7-4e7b-c798-08dddfc9f01f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AHnucImpKq4rmvmXtF3h1ujgJGgVcO00JSqTdwnq8rNWgdnAIJTCNeYBaFBL?=
 =?us-ascii?Q?5Ghie09Tq2zfIAQmk5FX1FbnGw3gD5IOqVlZGI7kWO3US5nHAsqnZbjFx+m9?=
 =?us-ascii?Q?ff2fb1X+vgSEpJokOXddDdmzZeCZFL1spuZemtn+jCZE6ZdEMebVJl2tENZO?=
 =?us-ascii?Q?ODva5b+wkoQmg1ChCODJnbbcrGoy9kncWO3bjz8IOj4BfzoXWAxJkncGryuH?=
 =?us-ascii?Q?We395C3b6mToGemeyGC2uIxR1i73PxUKnvxc8LcvrolkvrpD0EIuov9oNHZK?=
 =?us-ascii?Q?1KnRIQgzz+i0dvPhYixz620s9FGdPsiS4zBeh6pKf8ovqvORUsHHgexINTOc?=
 =?us-ascii?Q?LlvGAQDyDNRUNkxENmw5G7CABccJJpYdcKlxChDC/yPrBE+JOao1/sQMiY29?=
 =?us-ascii?Q?OzlMqNvjUU+W42t1c+c1CCspQqtHttg2GkdgQeU7yVMoy40CWsg2EATW1mru?=
 =?us-ascii?Q?WWKElM/ShpAl692dyJawkRIwWFFC/1DY+NxMMfyA3pR1gAll3fDjtorGiivo?=
 =?us-ascii?Q?y6juY01BinaD/KW5c6wqepjBJ1zyN0GGF0qxulGGVZIvrSIksWvphSnCIFEN?=
 =?us-ascii?Q?uHzct5yyig7iqJUFifnkjXTBihg7ZhWailXBXN8LR2FOtyDdIgy+eD+OjFWm?=
 =?us-ascii?Q?h6HLo+hlLZrNwbyHfbBI6YVXHDZUYiPA0klEvGv82cVzR9MNrRq5YSgLvAA9?=
 =?us-ascii?Q?1dRGaoJ8LVRlDnmRw/TpLc9niCij2tE+vh4FW4e+6RfFzyCRzpjK56dwLKs+?=
 =?us-ascii?Q?OwyQG6KPdYM84geMRccCcHXTJjTvEHNT/9IkxzCpeBo36L/81ZuZQHNScxnn?=
 =?us-ascii?Q?5zN5KN9wAIg4mGnNnuebC3wHGwvGiGXSqwSR0pbsHs//K0cxoJyaICSck9rN?=
 =?us-ascii?Q?/q6G6mZ4PcFN32oz55Q7mQ85Vyx8qB3YDLTiRqzfQX3NTPOsjC7wPjf7QLLl?=
 =?us-ascii?Q?Bfw6Sr0eOULTOt4rjJVJWrYa+lfZvuTGq2VvPZa88FLQQH+09IEUEcH8CONs?=
 =?us-ascii?Q?wTWTChvUyfiKB2gou+H9jiAZ3OGSM3FMtco1VlmWtE3P57xVObSURBf4cwtD?=
 =?us-ascii?Q?+1UJiFcpurhmxm3Awp3hotNH6qdmv2xqrUaJjbdr2NFF9Bny9MBUqOk9lTYO?=
 =?us-ascii?Q?zc+gC0xkTQ2jrNLfNGomPbswtAa0liIfKaWyapNkdB+aBenxKeayNOEQDs9G?=
 =?us-ascii?Q?O6IztGMoPytLeslklnA7ptvA0MkqlRUkgk31wjVoPS6rZ+i35wsKvyI5krsI?=
 =?us-ascii?Q?gCrLp3tfiwuaF+UCfjNZNIXY3N5gmREO+vU7lrx6agHxGpeOGjXH1PxuSFiQ?=
 =?us-ascii?Q?PSQD/VzQrJ73R3PnQ7YSRyjtFLeTnJL+HTR0vx8VldBRChAEoD3mThmtvvQL?=
 =?us-ascii?Q?n+monZDzEZcXWPVKoSqNKX+cmW5owReFIVm+HBrPHeQEIeIsgEE+gQZUJHat?=
 =?us-ascii?Q?crbvrNMrt/Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KfdnU92V9w/x1aTDrlN6981hpUQ1v0xalYYxw+qehcVHwyc2x5Blxwem1F85?=
 =?us-ascii?Q?JP/7Sqevu2XlDTawmoEkWKIt7MrGGGaVrtkMQd4vDSEkVhm2yCflqxuG7eio?=
 =?us-ascii?Q?50Nf0VUnh77aV6qhsMG9xVIUz4BUdl1iyq6fBSY/NaCa5RdcNDYi1LCpAbAt?=
 =?us-ascii?Q?qH/nC/Pxq5WHEC7wSmHxacugoku2NbTbCWNWRZI2NuqFOR/dZP8c1TSUQqro?=
 =?us-ascii?Q?d13DOJV2Ppx/suB5tFlWz06IhkjJxsdNLY4OfMgOsDNLEojAs4p+Bd0JryfL?=
 =?us-ascii?Q?NBH89WRNib9vD+bJy694v5E56USAuDwuOK185i66mvg4mYfCYc2rROW3tYo1?=
 =?us-ascii?Q?cwSxZbw2ogWwxLYkYCSf9CjoB89ruSEgzp2yXceslczaruBVkTUvUXwUOUhF?=
 =?us-ascii?Q?NmXQRIq5d1EtxNMfBO4I4XZLn1ZylCgWxbAWEZQ2JZp1+6rq8oKyfbbe0ghe?=
 =?us-ascii?Q?g/rwVpAR0zzQk0aVuzIf67W619dY1TrOhrP9rnxlyt5qCZ/ZFdIdQ2Rs4eTK?=
 =?us-ascii?Q?qa/M/YReQAPFM2aS9XQqFvQK7CAnLU2JmKmubHdp8vZSQUOdc3w99+6HDWTe?=
 =?us-ascii?Q?GG8D8wKWskxPs9HU3PdlROJJzYQwrx1zcy3erISaZUJ5KY6b/jMxFrKXoca6?=
 =?us-ascii?Q?joEq0A1BhuVlI/ypJKaaUGLXEsS51DSsLrbkd3QAbLg1yUe4A0TV3lY2MBZK?=
 =?us-ascii?Q?hxzo/+rFXoXdLWTmd/ztAw+HrliwK0W35Ms1hG1OJkRTyX9svp40TDLK7CJE?=
 =?us-ascii?Q?KzS8AW4vj2Vcs/UAcEAWpoQr6guuK3taypfQyMOxglWhyntVN1GL+jKVhwuQ?=
 =?us-ascii?Q?fLW3479MTXvmmkoYnDqVLTGXyMYt9T+gR9em+ui3K0WG4/xLs8bF4CqvaDhW?=
 =?us-ascii?Q?/Es4VY64oPB5BFNxYUMpLSJzYWzrPHLCsIwoI5EfxUN1Lf3ZH7CkOVAMT83s?=
 =?us-ascii?Q?f+IfToaJjG8mCHpvtwfIWpFJRT4m9c6+/RB+N5EsocnwnUcjbqZnWcRdZ8fa?=
 =?us-ascii?Q?ovCMNCTPbz9fp/tUN8QeUopQ05AkrA0ryod1Z6ldGuCJ6Vy4XW5GsIWYZQBh?=
 =?us-ascii?Q?eUVt9wRBjqA48vQ1PuH1ka/fTQBHEo2Ma9VA12J3b/uSlcxzDHrOLFk0AeDV?=
 =?us-ascii?Q?+r3szzBcyGZq1m4/i6IY1T2Y2pbnx0v85mvrhYqlWOChozMfjbJjj5BPIBD1?=
 =?us-ascii?Q?+al3/0J0ZL7zeDXKeS8W6DNFEuCps9Q2L98GubkqDwrxk6neN2TX3LM7GMUr?=
 =?us-ascii?Q?q7H+roPqBOWHiR65GAahIN8Y46rT6dxwOKRDk8V8GRN7MEP5PgZUPcDfHZhP?=
 =?us-ascii?Q?bw2E2j64oS65FnwfwD5aStHDbbBBvl8Q8COMAyRl2DgoePuU0W0CU6rtXiB5?=
 =?us-ascii?Q?euwHOMNZXkeUFF1xsDRpdTY91kph73CIcVRPMhrzc0XYZye66l+p3jmU9uMZ?=
 =?us-ascii?Q?TGNzplMu1/oZAUZhbrANpsN//ae775GNaPrskgv9IZEnxo/rEZ3+ApysXq9b?=
 =?us-ascii?Q?haqeoVSU12112sTZU4fGzFI0Uq34AVdZSV1x+ViJhKioH024o4U6Iry+0pog?=
 =?us-ascii?Q?iT6W0/0/dC+J/RVDEvxLTxNlxEQ9F/PK+6zoltIl2jUZkuXAll9ilzZjJtWC?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bS2cI616JNLDOCDTbYlkmIDTWuDGPzHCHAnLXCsgevgn+DtpNhIVXssURuksKi0p00v1TR1rEOMb6IZzKXlBOkuHCXd+Few+2vl7/eWzTC7OMyugANP3mtrfMu/KCw9HRnUbjHrRaZfVaKIqnai1uBEgBDQ72w+QpqyDQdIO8x3tq5Ojo/Cvie6YXN6/1x+PMJRok+HAEPKVOzc2W3Rws9oudvEZu+YYkmKyDfEDJrf3Do4EZBP057wdBN/RVCAAtvTlTA9WImdbmdyM0B0lZYOBn+Ilf/CBBZOnEN0oEozLt5e7X2scmPlMkyeP2bFBiyQS0qrGntJq30Kn0bC7RIefjmBTBo5YivR5T9WRJe/9Eamsazdgq343Hm2RUn5F1uG7cFnSdydOGRMLXbudPnYkc/jEL78ad6AH9wDklxFUjPt/DWqWmyqxkVfWEhOwv8Pj+NVL172uWynqAA/T/wDdjDLZXjgMZcsWgVEJoDpvLPjoanNEyjRjmClRD+YyDz1DP3PBBIy8o7DF8cB/TF4+zO1OeOaQOUCzA9e8YKL6QM98OHQljtyimsiRCCvB61HugPJUN827MH1e9+2clhQGVofm4XWO6yQbZFVc9Qc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f2a826-17a7-4e7b-c798-08dddfc9f01f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:14:16.8333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhMqaYCJ51Dx8NCcMlDEgjIdFgHlOgdybeNiqmTC1CuDCqv8zAi3TwWiFCgXlSDAtNB4ywojLlIbwESmwjH3X16j+lgTS0TKeCdRw0oIZT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6315
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX2qXz3L90hy4R
 idBYs+O6yqyxEgPQj/qADSRjxKRLDxFCAvCmmKYndcuhP1LgDsfKw6xFvuVzeLSXeYjEMp3KItl
 df1HRwB77B4uIGydeMPAB6rxmzqTHaEBlIqpZuoL+BdySesf8crncGKPNFc59m+qQF3fhlqZJPG
 ZhxDKzgfV/V9MCCwz0JFoQ//qDWD93ONi5yjyMGDwQoArxN2FOaxHKSzF6ajVk7KbUv2xgoK3Hh
 HsvoFCCA/S36yqUGM+CyYcjnVBemscLqrT1iTUzqvCjQZXiuPcSmKLH1AXaYst78p3FXHXBYo1L
 yMPuR5ZeNGuWfcvkLCvp5Dapbuwz3OLk63Fg4mwZmu8uzCZGfBmIvoF1P8E2Qe8Iwtu9QdJ5IEQ
 pVhVp2D6btsLVbZGHDLZ7S+3Axl0Lg==
X-Proofpoint-ORIG-GUID: W3BKZdK5DJOFOn6rzNwe2zQ0HVJML0Rs
X-Proofpoint-GUID: W3BKZdK5DJOFOn6rzNwe2zQ0HVJML0Rs
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a591ec cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=hSkVLCK3AAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=j7-1BgRk78S91jMsn-gA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Queue-Id: D3486C0007
X-Rspam-User: 
X-Stat-Signature: crk45iwi55ma3du3etsaankep3fx8f31
X-Rspamd-Server: rspam09
X-HE-Tag: 1755681265-161623
X-HE-Meta: U2FsdGVkX18r2/Vpo4/wk2rLiobkxvebZKPx9BAV5nN/Ze7jq7dC8WaNpq4plS4dToNeCe2rBZEMCc4Za6vO3uB2/i+bRdUVmEL71Clzo+7Q/BzD/Bc97cVMGiIgzUN75ufXJ0xKYu9EzNzRuRNXi2SfT9RFFe7mhOoLy0zqYmoh12cmDoBNjl19jloxFKGANkz+QxS8C7EYTo/wb8tN6iotvs6hn7VH1N0+w3yychjKOgTHMRmSKcgfw+WfIh+eXCR41MVzHgJ+7vU9I9+cD+1Gun1LalY5kbgir5rfhxedxcxzKEWFa/RIiSzeU1rlM34Cv3NAPtJAOaY2wjEwyVnzH9TsKiVpRukRIli5IGrEoRidnBF9V28JRyhAtSx0C6fVQoqq/sQHiv0LVy/dUDnu9Gy+y4fSANxo51ObTpvW7Ft6lugLTFxDtox2ATPBrnUP5bcscF1mwLMsPJEAnaaFMduPy3cldEe2NoAzLJA3UC0m+0psHKWCDDIsMe3eu66LZeUAKcnBd7W4RR12p/pFkJXa1xtfYHNGFOdcmF1ZmWJIL5C/juCulS9MyApEbk3Yl4JqiyO3AVz7vL3g48nxDUelAdtHGqfimzNGLifGhMvLHY77bJEGvfvmMRMh/OQ86CTjkZta+BViEiiqblCLdkF3liBfK7wVRtqa250Qgjv7+j1XxbK/OBpKaB5ySqhRnCS4rVk9ml3B8///8FMjyQFoP+5YfqF8yrjdkeQzL97X/xa8lFSKf0s9oFaLHnIK4LD3S3BPvAgB68Sh8xJvzuOkYtenkJb/wRUTRW4Z/5CJvFo1BDtb6Ba6pHy7A/yGJXXCPiR5yKFQBSOrgyPTJyNqE2tcjxbJ8+fDigsfYzmuADFYoWTr9SErJIDSUuKLKz7x0u1qZ0kUk+U+ZX7e3JRaZMbtJipAzjoKtZUxFv3hlENtq60fTeevm5rMxa3pcvTqqZfoTj0Zpw1
 oRrjhARs
 sZJWXW5rHK3YIL/rnY2uLo9VqntYOB9WwFkf0jXcgP93e72adRmNF+ZAz4SEXHFtjm80mQp7dOxXOHnaZc/zeMsiUNOBXzO8UCAMoB39V2FhMJGi5e6zix3wgDo8n5cIhaKZl9CXJ563CcT/GkxYlMVa6gVvoHiFWlpv4VH+BT+4GuaL4fLV++vcvhORb+Kfm2EBWYi/i+bxeevdwg+fmBxX6P0xzGhWUs+Ec7MjyEumEB/NDnE8kiI4AKV2EZ1jIwHC5h+Ukjz0bNQZAXhGOfZpeT+qZD/waEJS5fpfPSJ0MIl2rz5JlDpjWfPV9tQfy7UHGougPWdcUBsLlKyUFYkhMOSKKXLg/yhTXowMAXlluqDlUkKMU2c9ILTFvDEzI+p8JMh/E3sbz+5dximmXsxZDr5YwcC6n6gw2rB5snw0gNTqKdr1k5IzAT7hmhgdiebLXmgqfCBn3mDwM/KxLggh9Oce5nyRdg6EKxghUP8Sy1lbe5ZTn7NTOpDE/Ar1q3kW5BxyKavtaKl+3d9xHwVU3yfsowel6X5mWH4ZwBcACVV5v7yvsB7/ponmRo/tCbX6MWFbI1qLA/v66dEb7lfKubXTXBeQ9PqWWygI1F3LlzxP4HJwsMzVv2znpUm0t+9PhFajxOk99RJDRKrv4SKPCp+QupYbLV2u4iZDgjtYX4WmNoS9miXXwPAujskJFVd+BEtR5YbLcv4f+Dlf+CH6VvI1uz8H3x2o5m6V7IdRNXuz98qdEWmf+0yNx93XNQbr4c6wdrbjeFaoJVRrbFvN8H2/GgSpYkEZgTspqP/i1H1gaiApxryAGi5PJRTj/BAae0e1EmnomW9gBSNYQ9oRAgYNNBtWRqqqscLIeDsg1Gk60omzQuk84nuaDVbkRCMO02p0lXk/+nAP6+V5xEJtXTATCwFtB9QIOEIRsD4smPbKMLPjMCNKGJOvGaMgGZd7aiuP8yzAjvudpLn+ihQSl4OkX
 M4yIQLYj
 nqpM3wjxJWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 07:53:58PM +0200, David Hildenbrand wrote:
> Registering userfaultd on a VMA that spans at least one PMD and then
> mremap()'ing that VMA can trigger a WARN when recovering from a failed
> page table move due to a page table allocation error.
>

Am guessing this is a fault injection thing?

I mean it's good that _in practice_ it's almost impossible to observe this,
though it doesn't mean we don't need to fix it.

> The code ends up doing the right thing (recurse, avoiding moving actual
> page tables), but triggering that WARN is unpleasant:
>
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Modules linked in:
> CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
> RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
> RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Code: ...
> RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
> RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
> RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
> FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
>  move_vma+0x548/0x1780 mm/mremap.c:1282
>  mremap_to+0x1b7/0x450 mm/mremap.c:1406
>  do_mremap+0xfad/0x1f80 mm/mremap.c:1921
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00d0b8ebe9
> Code: ...
> RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
> RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
>  </TASK>
>
> The underlying issue is that we recurse during the original page table
> move, but not during the recovery move.
>
> Fix it by checking for both VMAs and performing the check before the
> pmd_none() sanity check.
>
> Add a new helper where we perform+document that check for the PMD and
> PUD level.
>
> Thanks to Harry for bisecting.
>
> Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
> Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com
> Fixes: 0cef0bb836e ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Cc: <stable@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

This is great work!

And major thanks to Harry for working hard on + pushing this, we chatted
off-list first and I asked him to look deeper into it and he was able to
correctly identify that the optimise-mremap bug recently fixed was not the
issue (though syzbot didn't help with a flakey 'fixed' repro).

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>
> Once this is queued, I'll send a patch to perform a
> userfaultfd_wp() check, to skip any uffd VMAs that don't mess with uffd-wp.

OK this makes sense.

>
> ---
>  mm/mremap.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 9afa8cd524f5f..87849af6682a7 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -323,6 +323,25 @@ static inline bool arch_supports_page_table_move(void)
>  }
>  #endif
>
> +static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
> +{
> +	/*
> +	 * If we are moving a VMA that has uffd-wp registered but with
> +	 * remap events disabled (new VMA will not be registered with uffd), we
> +	 * need to ensure that the uffd-wp state is cleared from all pgtables.
> +	 * This means recursing into lower page tables in move_page_tables().
> +	 *
> +	 * We might get called with VMAs reversed when recovering from a
> +	 * failed page table move. In that case, the
> +	 * "old"-but-actually-"originally new" VMA during recovery will not have
> +	 * a uffd context. Recursing into lower page tables during the original
> +	 * move but not during the recovery move will cause trouble, because we
> +	 * run into already-existing page tables. So check both VMAs.
> +	 */
> +	return !vma_has_uffd_without_event_remap(pmc->old) &&
> +	       !vma_has_uffd_without_event_remap(pmc->new);
> +}
> +
>  #ifdef CONFIG_HAVE_MOVE_PMD
>  static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  			pmd_t *old_pmd, pmd_t *new_pmd)
> @@ -335,6 +354,8 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>
>  	if (!arch_supports_page_table_move())
>  		return false;
> +	if (!uffd_supports_page_table_move(pmc))
> +		return false;

OK I guess this is inapplicable to move_huge_pmd() because it doesn't need
to recurse PTE page tables.


>  	/*
>  	 * The destination pmd shouldn't be established, free_pgtables()
>  	 * should have released it.
> @@ -361,15 +382,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
>  		return false;
>
> -	/* If this pmd belongs to a uffd vma with remap events disabled, we need
> -	 * to ensure that the uffd-wp state is cleared from all pgtables. This
> -	 * means recursing into lower page tables in move_page_tables(), and we
> -	 * can reuse the existing code if we simply treat the entry as "not
> -	 * moved".
> -	 */
> -	if (vma_has_uffd_without_event_remap(vma))
> -		return false;
> -
>  	/*
>  	 * We don't have to worry about the ordering of src and dst
>  	 * ptlocks because exclusive mmap_lock prevents deadlock.
> @@ -418,6 +430,8 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>
>  	if (!arch_supports_page_table_move())
>  		return false;
> +	if (!uffd_supports_page_table_move(pmc))
> +		return false;
>  	/*
>  	 * The destination pud shouldn't be established, free_pgtables()
>  	 * should have released it.
> @@ -425,15 +439,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>  	if (WARN_ON_ONCE(!pud_none(*new_pud)))
>  		return false;
>
> -	/* If this pud belongs to a uffd vma with remap events disabled, we need
> -	 * to ensure that the uffd-wp state is cleared from all pgtables. This
> -	 * means recursing into lower page tables in move_page_tables(), and we
> -	 * can reuse the existing code if we simply treat the entry as "not
> -	 * moved".
> -	 */
> -	if (vma_has_uffd_without_event_remap(vma))
> -		return false;
> -
>  	/*
>  	 * We don't have to worry about the ordering of src and dst
>  	 * ptlocks because exclusive mmap_lock prevents deadlock.
>
> base-commit: dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> --
> 2.50.1
>


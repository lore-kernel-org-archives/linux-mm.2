Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACFCCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 12:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BBA6B00E3; Fri, 22 Aug 2025 08:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2FF6B00E4; Fri, 22 Aug 2025 08:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAF26B00E5; Fri, 22 Aug 2025 08:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3F5C6B00E3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:08:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A004C136A3B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:08:32 +0000 (UTC)
X-FDA: 83804271264.22.76ECB9E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 421DE160007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:08:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QzBYjFNT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xgv16Efm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755864509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAqh9NpEvjnNeKaZ8EyS79OE//9rhN+zY4vsEO9iEWU=;
	b=l0zVSiU1pfcDfYhBblwlX3v/1MwQq7I/h4ilK8Xd+yu2rdykhSFj7C+ZQ0hDHov/5n5Vje
	vwo9sdYaJi1pcIlZmGo8a07aPbQ2mKWtReHFE+w/GozUZL6hg7UKt/6IhXXX0DJPR53ycR
	0t8wCelTVTcSDxTeJxJQY6mwwXaDr2U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QzBYjFNT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xgv16Efm;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755864509; a=rsa-sha256;
	cv=pass;
	b=uTxBa+uAkKo9KF4ffmk9vm5lCzRAn/YSSqQQOoHlnnSi+kKNRUr7EibHI4XZlj920knc2u
	MU8+QamvMTyE3GDwLZ9aWZVzEiBooD3alajjQiXiPg6RA4lbpetDk3pTiNHNXqPCYeyaBv
	myIyXsQktiOz9guCMpJV0X5DpOT2/AA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MBQOUY021545;
	Fri, 22 Aug 2025 12:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xAqh9NpEvjnNeKaZ8E
	yS79OE//9rhN+zY4vsEO9iEWU=; b=QzBYjFNT3eQX/afUSs0no5Hg+72NjoL3GI
	kP82CupmwEpRVok/684Tl9MRfMDLYDrDuGFIz4U4QH7GzVeLCE/PEaij3KOhfsEI
	LJJ/R8zDtjLhLNLhMAFuFqLu2vsGYp8PRvJAutEgIFTNfPdbbLO4r1VHbJcYAdVm
	EH3YQ5n8WpRJ3XMuiquWR0JSH3Z9uKJZqgG794d21KsIhF6u4sF1QIHvacA2Lw48
	HslGdfKxlA4fMRuC9S6uRZtj95QLMY5H6aedKnnqJxAaSzplWTLLPm3qCbpYo2J7
	IQ5dxeig9onA0SKubu52ug0fb8QkSGINuVXZL4le0IYekFrpKfww==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr5bmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 12:08:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MBAx2N030335;
	Fri, 22 Aug 2025 12:08:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3wkuw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 12:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ep9WNSGuVufwmbvMYBU5E88Xj1VTb1Rdtxzt1FZSK4XM3E/bOA7Cwcr/2YSza2+0BQZavN/4F0Lc2CnWUdqrOSqEso6Sn+IbYDwoR81CKAAZgPKG+IrGnMEjsLovdKzU+WC40b/bGBKgt5xcZYopfcsM6lyeL/OSKkBi1fOtxx6lW24peXohBsyUo8iYEorM/2tA8YUyu7iKWJ94OIPg+Wr9lmxvyd9hDKRVD9Hamd35diIXP50dWL2cQZKyt1fmBY7X0qFKwl6vaEIZTSHxLgc/XI+JKeS4q0cweWX25fVUKKSlgFJD3YEK3lhKCxQxnOIXJB72QvDO22E2GcULiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAqh9NpEvjnNeKaZ8EyS79OE//9rhN+zY4vsEO9iEWU=;
 b=IxmuNyYLGknI7dRXcj1PRQ3msmHXlgCQ3+TWlNqFtAURY10Y9qMfUf57F9Bh0OGC5xuupq8GOSPcBsPIPLg3chFIRwwQBHDDdUovxR36hAYyY8L8mtN4yBavWTaWH5H8S8PuAzINQ+d+op+TwfxbfOQzJl+Viw5svC/u6gxORw+CtqD+8HZscrDOwyzZEIkOOXNz2XredYUodSzXaaPaSvtHMMoY1HzG1m8dGvJUHtPE0V2Dvfy5lH6S9HSBeBzdqcC4UNVj/SMcNnGgSLMrqWdl3wUBbiGeT86F/KIlcmRn6SnckpCYgPqdmFeg0V0velqc+nwIeC4V7tzHU+Rvpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAqh9NpEvjnNeKaZ8EyS79OE//9rhN+zY4vsEO9iEWU=;
 b=Xgv16EfmvTJ0qnI81fOEvLute03bMvz5BG117Q1erC1mcUY+SauG/E9R1tWkR3MHFMfVitVsAAMTc7Pv3h3HqWTeOK0xArhJ7X6m2+CFaezFtg3DBDFrKpX1EoqrDM71qn2CI3avqDLNo2O9eRFsSwZCL/YdOkdZ11CkjgAAHhg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Fri, 22 Aug
 2025 12:08:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 12:08:05 +0000
Date: Fri, 22 Aug 2025 13:08:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Message-ID: <2d1297ef-5df3-4679-8e38-05be188f18d8@lucifer.local>
References: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
X-ClientProxiedBy: LO4P123CA0550.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b01797a-30f3-4f6d-1784-08dde1748cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XCArDNU1Yq1kQTUW6x3GWqEgm6qSJ9BHML9ztSgO/V/cuarO7wEey4MY0aAS?=
 =?us-ascii?Q?jLN+lpBokjW0uZ7XUjqK0xbu+rMUkvCuJLT9+oCd7VZ6J3IvW2GDSj88f7Gj?=
 =?us-ascii?Q?beiArbhYN1SRDbXAh2azdRTXqgTSEoCSC5TRXHf93VkRyOB1Z8Cgyzje5HwH?=
 =?us-ascii?Q?fLKG+VYcMgq+rzdUqgFJkUMQQHmb3YU361AS+V5VxkI+0/g3nUObynZUaGbw?=
 =?us-ascii?Q?zFkmFLfKf1N1gRLs3nUN0XdbKjzHgNaPSxqzTUTK/WgBrAWem1fifensrlZO?=
 =?us-ascii?Q?+6NpvmQE2I442Kn0hXDA37YG6sn9CNN2L389Naprej+u2tBGp943b8KFMD+5?=
 =?us-ascii?Q?5Wip556Uzu5hLmkeRYhygjcaeKjgLiIlqoUyD/gmnHrQewLkwKZB5oOjVj8f?=
 =?us-ascii?Q?G6Yj0pLYGhV19AP/KF5NSpc9DIcS3/7nUIb1fRccYvx+pbMiogWykCWmKFJh?=
 =?us-ascii?Q?PXC8V/wQHJKksqSuhtnpgwZPLsh6g0Xcr/iAHL5d9oX/PvRIldcnS6OhVwO5?=
 =?us-ascii?Q?j2i274M6MtVBAQJTlU1LQC66EkKAhCRsSq/kOi8NiaFKaWYCuX8FkB054Szf?=
 =?us-ascii?Q?nr0bNoILLcP5RYmuCgi9iwS4hotSXajDxDM13NXEqFi3EXpnilikxZcFarQE?=
 =?us-ascii?Q?uY6VoD2GSMPTri+qIDJ1TO2P2P4nQPKAyZkcfL23sK0foReTORtXqbeav7lC?=
 =?us-ascii?Q?e37IlAtnvjEfQPDWMY0AZsp1+CEXWr9nTCSyU8HxGt/mmifGsgarsYgsBrEa?=
 =?us-ascii?Q?oJeqbR1HV1Hfr6RGwMWVKTgDfBRBfq4ubU/hvimMOgaiMcxnIWIL0kzI9TMM?=
 =?us-ascii?Q?vePtNn96eN0zOr/tqEF9KuNmOsdZPRBkYSWPggMawsMm/IpP0i0bil2mH5+J?=
 =?us-ascii?Q?Y7D903Yy2PtSn7xa9p0WaViuH72pTNd6/Mn+IPu1sONYJMeaOX8LDw6AEe+I?=
 =?us-ascii?Q?WEwvxDpZS3AX1WA4SYmTG8QrpRLGoYVVDmWkJNKlnq/crr1CJOT2XWUTNMuK?=
 =?us-ascii?Q?SObDw7dkrYF0uoHrqr2bbUvFaXypPb/Oi8f449/Omh4rlNc+o5JnQtNq3biT?=
 =?us-ascii?Q?D+D34nXV0rzfdqOGMg0zcbK7kJ3uKoBleU0jeabDrZmLYcLwwHU9mYXVBTJq?=
 =?us-ascii?Q?Dwf0ZRl3izImDVDOniFphxjDK9PpzR2PjuJ8WGLu/XXVlQ60g+skR6NElZG1?=
 =?us-ascii?Q?2KOYMmicetkHRB7eFOo4T1ITKFf0OeFeLy+cWGMFxOf3JjoMpcXCtavYJ+cL?=
 =?us-ascii?Q?ZZkwcSG+sVG0GUxNwSB8NEmyBGigzgz8Ve9y1AL8wHxGT8eN2qR3OQ8mkyyg?=
 =?us-ascii?Q?gtpHpGpkAs56Gc0uwIekU0RCNReT6XxRJF6rko4p8+ut8M13+NswexGDnGq3?=
 =?us-ascii?Q?bQ8tq+CtL6kGXP2a5wjfHXsATMUY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RqQwiMm4vt04sdHRvrbRIJDo/WehwDuorNjZf8w3FpULyqWL6a0QIsU2NdS/?=
 =?us-ascii?Q?qJO6b8Z0jMt35/SFXrjvzJ7uSUwQwK9xOn8bW1kZs3AQ0N4fA6UVZFoQwinx?=
 =?us-ascii?Q?SrNnmAjDCQ+JtwM7iSdCcRgZEbUfk8yPFKDhKBP6+ZH0Kiy/odSvt62+93zb?=
 =?us-ascii?Q?xifJl1vySAlXJOfDPXaCs+pcX6Y81yl4vGGwYywfw92LQaoobBtU50fDUKRU?=
 =?us-ascii?Q?cRJ/NfS/QkK/Oc2uZdWFc5omGDnbvE0gu/yTnojXtlulf6bLsOtXwr0IknK4?=
 =?us-ascii?Q?CUU9P+WBmKj0Si1dB+d+tZr3dsiGRC2jKmal8pDN5NtVijFU88TzKy4OAiGG?=
 =?us-ascii?Q?AnSBmO8igWAideikmDVMYeCLDypsfXgRf54eQRHfuyfx/81Cfc5yyolse/Bm?=
 =?us-ascii?Q?LXL8XTlYtVHabAKtR2/aZp6FibZsc9vH8azIpkurfjgS5j+MITR+Aasj6k6c?=
 =?us-ascii?Q?EdP+1EVwShEnLG32yOshQY4qv2BQLkRF7oUskF/6fvOUwraekmqpbT57e5sb?=
 =?us-ascii?Q?EpkhXMeda0YmSRia09qKrH8sTP/6tfFcjJA5DFDHM8zRPlOSTfDRL1/szhPS?=
 =?us-ascii?Q?MPL1Lp556nO6lxATVKZqGpJKsU6i/4WmvX3AYcW2NdB2wVQ/VGG3fxRsFQH9?=
 =?us-ascii?Q?jQld6xn93HqNOfzTqdru5XdBi55mWZkdFDFTX9xhC72Y6woAItrbvwQc0Dyv?=
 =?us-ascii?Q?PQVQ1yCd5nxocN+60jBTRgS6z7Fi+dFi4cQATCWlZqKRRmOiEJZsPVHOv/KX?=
 =?us-ascii?Q?m2eIZbLvBNY5n1N7Ow52VtWsg7SbdSmwuuXsLhCQaOdPKOWqASGJZBE19EvM?=
 =?us-ascii?Q?BXOeVRlToAf32aWXN8KrD3S0Scxx9RuPEag86510xdqSxee/mBYEQk7tXxks?=
 =?us-ascii?Q?Dc0EHqZoNg1v5Yr0xl0ik+m3TyY9wZZV7EwgTDAMCJzn4Ji3w2dprS7rO67E?=
 =?us-ascii?Q?zYvizCP1idV17VdJyNXUf3cRuQpTv89eNlDStkUpF4NM9VF9C7GjCTd1Sjt0?=
 =?us-ascii?Q?FHbpMidCb5nHy+Xyu1n7prG5IijYsyVRNXN/lnOrTGlWKTz1x2euaWfuqWs1?=
 =?us-ascii?Q?JtvgP6t/T+RoitLRziR2Yi0OIlaql5h3twbpiL0stJaJKZm9SFxi6o/BVjYP?=
 =?us-ascii?Q?0y9uItW0k2hNvoR5Fpk4B1cIW+34ulCIyOaPQD9LKAtlXvPOHLg2xqVfTt0e?=
 =?us-ascii?Q?JiWZDIoOgNYZ3DUMF0KeV51VycZSvI3v8yDEILnMvex68tcY6PyyeqrHYMJT?=
 =?us-ascii?Q?ui520omY5UPkZXlzNpa445g+IuFAtXayY8Pcs8c7/waYSGwrWeDKWZGIeiWE?=
 =?us-ascii?Q?cc4SXaK/qcLMAU1qhSiJLayTX1kXMTZ6US5QzTGR044+3oRxbzwtU2w/9q4o?=
 =?us-ascii?Q?GM+gHuFVDMdg4dQG+gBJ11bDldWtqrJLu9Bys9fdTrmJIHPSsjvGOUoRZFT0?=
 =?us-ascii?Q?zC2seAOYRoqvW3BTelP8fsn2tpoPFvyrtFSnLQS7kOoDZXNg9mmT/7yqObnM?=
 =?us-ascii?Q?N3nbhC+k4BuGe0F4CiRhei3j83nLCE2oOrtgbH1QwLYQKLFVX3qout5whMyd?=
 =?us-ascii?Q?Zr4ebDRUqJ9IRIQOdnTNKbWDQHAAAZAMRZXTBJ3Wlomph8FJsvsc/OTCsXb+?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zXQdXZ4WuCtiPzVJwuRU+xGPm0B7aV+rfH9y5wHqwSSwrMKMI/hzUsUMB9a4e+k4iXKp3UrlFjTLMk9ZHWPIGaZMFI5MM0KFeSujJXO1szcxp9wd25Z0sQ6nQxG6bYg8UyK/aByOxs4mj3x48Yi7DYAg09lpxK5dFb2q4AIV7RsHvio7DmzV3Kuvn9BZEcGSSdPYZEkU0Qjtxwdjl1E/yDNQU/K5BnRvHkawEmaJtr+njuwKNyiwivgnagQwQZGdN8xeOdC7iMeqYoSM+o48+/7odxcNYhSXy3gAuFVvxjWe7nmPCPbTnR4XKhRBQ3IKsjV5UZPZfY53SQRJypVbnH8d1augBW/8Cwlym+P7JMRHs17s5LQT2uJhgz4E+j/bLWBMDki64mMNYCQv6aCt1ayFhVxDr0BXBmi2va8nUYBGhPHyAsn5u1Vf4QigUcPm/jQld+0Ph4p0f80Ub6SDvHVQ59wU4n6rQcgPARMCjFIKILKr1TOF0oRn9YUPac0LsK35VCOTDCKajaH1H0b/xxMU4JDhbodJ6y2WKt9jkQabyBNUfib4zBd9IJjX8gs2NtKWIUSb53nwb90XHhQu4zb+TvGGlMuL7h1PDf9Y5ug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b01797a-30f3-4f6d-1784-08dde1748cd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 12:08:05.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wgcozBIJBJyTdU32hY12Pen/LimX9FFPrknsOg4QJ2ubDikSo9Zs5Sx3+ehNZODO2BdRyLl0mz7sSKUYn0sL72Xq06CVffkaVGoX8F10Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220113
X-Proofpoint-GUID: ExrCvwEXHh7czV4eujiMgJVkvgDg4GBE
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a85db9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=8OpYBUzI1sY5vQz1pR4A:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: ExrCvwEXHh7czV4eujiMgJVkvgDg4GBE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/XRP4Yem72Ni
 wMPMmDK3Knj3SjtcZ4VTejqQUAMaUhpNunfdyzUgrXhLyrjxYqVLo27xRrMgHa+fu9TS/NRZon7
 ekidGyM8m7+Qv+ONrsFfpyeTFu6s8iUk4sbgQ+D7IB22JijGTwELVDxHLA1mq/OHdcBa9/dnjDz
 bp8DkHWkuZnF4vI66b25XVBquItndj7Lrfp2y+su+dEBSq203oLhXCuM8xtIHnduL1m/w3gOPJp
 Me9K2mZcVacAR72QIWj8tcNJbQV8XTX0K/R5jEinlf559Unotg7dgm5ddZamxsxHlyY1injB4qH
 aAKksVyx06bdQtUCw4uNW4v9HV67Ld9dCRYyPPmjbImxl2Eg1igEKlwmWN8O2f1HoJFBt9hHekf
 y0vZ8DkvdxdawElFqeonFq/YciiWuBB6cvIabAJwIt1optlgcvA=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 421DE160007
X-Stat-Signature: jcxckaocta4qizeof1sx61ocyesajarm
X-Rspam-User: 
X-HE-Tag: 1755864509-8901
X-HE-Meta: U2FsdGVkX1+zIy5Dca6/e7U4q1vTaP9+kpcukAwJPBFZAhatqmJo+yG4vkeHSzGryA0CYcAiW7yxKe6A4tlZASK47LP4b+Uf2Rp2Q7nezixk726DtuAPKReA1UJFecFmvTGRbJ5UMG7m0A4ok147yRfPRm8afc0XqmaQ39PVemeA9QchPWrKOcwflj4MpjyoqK62S0Q2OTfR+t26EKUErSeQL3pPDa0a4+r/jqlFUxgPQt88BY1siRsd/1Aa1Eotwz4NeaeXh2P2zYsC3kYXL6fMvSH7cBwuL5/1IFM8uwymyznSdmNu7UlqN2L9Q4EGouIx/dcmos0YAyz59vB+nQVNC8AlPKSSREdpy35DR4GN0N3BK54/X/unWg53CkTrFMySDf9LYb4MOIsGZn0qk+lCqNGtm48mxueNGv3ibiXLM4nVYXrmhw6LMGFQOyeb8NTJUql2DDv4exWkQ5dl28UJ1jDUx+x4qpNvZDLjplaNnoplUJwYylSESYyeHjISpTS/BOKdFtstEYOTZ8Zg+eTs8hivvQLFtyKiDsm1WEZupJyBj2lWqITGjlaxZhzEW3YdW9tQ5gGRR3aOaMTi1DS01izhWrU/ZIzoEfOOZVyzJjV+lQi4Ckp4eDsVds0TzUO7uduuZdS5+EPh4g3OQCsl1RGFrhhFGrtwmtKcGoOdidtxCu1PEnaHmCF67TYWooqihR+ju5gcnazFNYxVfenviDbjYLigesaECcjJdB+SQIch9BFWFheNfZYcQ6kCPFCpZSazumLJYXYZGP+YD1vqKsACJdPOcLLKyJo0X0h5dMSMDo+MBjwoTyh9YQmhllN8ZuLWAoxCfM6XrHsMXJ2ylbBUNy+76sbGsPnUubdlgAYlAe4NsRJpjFV50ekb9SOHS4o6Ym6jgNSnv0nRn7qi/xoP1j+hJROKdALa34MH7W8zNSK0j/dSVTTBvcKuYHEwhlmkYI1WuclxkSF
 5FuZ0h7z
 YrB27lSwq5DM0Y47S6OkJFZ5+W4vt9vHotCdGQHGd1QnJ4/bduj7MO43ZZbiQF0Db206DBIica/CMh5T0AzdgcdEh9jB3TS/L0PoSm5rWtqPbnBcBNLjvhPR1e+qXTbIwSt+ozgi2cEtTqia0Rmj1Ku92lWW27uDnwJzrgVFD79iTIIfx+LFPbNwWc0MBWbzxZ4G/rlPRF5nz6sOmj67s46dagmU76C25v3xrneqZkVHMoFmAasP/P+gLhDdiz3T4VCK3x4YLPVhlflU+oDRfgD9PzASHuUORTdvZgKK3rnkh0OaFXr8L2Mj9X4R+sojtIgdLpkm91XVLfMoxVzOVApV9X+anlW4Zh7TpnoyRLU4JRWFD4ABa62wwFejy5pmygAXj2xa/ay288XrrZaVo7M2h/KRUW2eothQpkvZSQ67PkiSZ5srCwBKFHCo5QPzUJkCOM7VvcS06LJ//q2LaeM1q6Rw6F+j6U5zTnSoZMdCgMpzL4Ny4Zr6pXgOI5Bm7UpZ4e2h5OJa3o5fyMCOhxz7P1hHVWBwlo/e+KRcBNGmkQsj2nTv/Mkbew8jKXfrRgDpGoUhU9VwoMy9KdDFGlLnRbfN11O/Hu5TkXY68YlMqzBVf4IIbHsl49ksrcbTp10ew8HSInEbkqXin1NyCLipPxnlkqx9aqcW8yU+PR9Ee93lcdoJUPPU5BKTWN11sx5ckg0XgX7Z5u5Ewf6/JOJKO64lbd21tB+XJMNbM4f5O7AybJBfmbxx7fp1og9SmG/W69Yor6K9ZqVeTAhA/M0JgvzYoPOJYORziefSKUjlbnakCnwSpPh4MVJW2bODK1nEWLlYpO5vYhOQRVnteFe6PFQ70stWpK/tLERpbWvdI81xavpBwn8F1fdwEUg3Vsdmw7wQwxo92huVeOpmVmqYYdQgwy3FgDVFb/9wt0DlCVc8c5Pm7jd4st/QyPiOeI7uWaJsy2IV8YhfN+i/0bZkTEFlM
 u+bEaGQg
 peiis1xejQeF4PtlUNkO/McPML9TOfumbZOcqiS7IWdlNza55SstpzoKP9+tdmt35fBQmNpmXgqFTjR/oaa6qz/wph+X6/h+viEXClVi1R+RpjQtYkV9FiH48597A9cg80ZVelzSc0R+FymCpPyJAPqSSOCYmflWd3KEzbUcd2KhGql5KnizkiMSJsHjPFT9m0HxTfYA76zcc1+vCnl4B1M4xHg0xTNje0TLu77AfiNTTxEktH6DUCoRsExf0EKI7SEJMQVxp/vX6fO85B0u+OLOZbXc0kGbkYVeOm5Gbg6gcpeXeEmLfIwK9FcfCxxHp91rItcuIVne2Q6IjU8U4PgkS7/sBe5OW3NevrOdBKCY1SlCzA9MdCaCAMOOH1v+EsdvOaD3b+09Unxx0TP02lC2t4DIorE8ZFDvOqLaoujcE3y7qEia4eob81XQTy7ioVAWnoTVjaXCfpT1v+DwdNTeVxrH682pGe2Ca7Tc3Bs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Sebastian for RCU ORC change...

+cc Harry for slab side.

Pinging Jann for the CONFIG_SLUB_RCU_DEBUG element.

Jann - could this possibly be related to CONFIG_SLUB_RCU_DEBUG? As it seems to
the stack is within KASAN, but no KASAN report so maybe it's KASAN itself that's
having an issue?

Though I'm thinking maybe it's the orc unwinder itself that could be problematic
here (yet invoked by CONFIG_SLUB_RCU_DEBUG though)... and yeah kinda suspcious
because:

- We have two threads freeing VMAs using SLAB_TYPESAFE_BY_RCU
- CONFIG_SLUB_RCU_DEBUG means that we use KASAN to save an aux stack, which
  makes us do an unwind via ORC, which then takes an RCU read lock on
  unwind_next_frame(), and both are doing this unwinding at the time of report.
- ???
- Somehow things get locked up?

I'm not an RCU expert (clearly :) so I'm not sure exactly how this could result
in a stall, but it's suspicious.

On Thu, Aug 21, 2025 at 09:15:37PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=136dfba2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=142508fb116c212f

lockdep (CONFIG_PROVE_LOCKING) is on, so I'm guessing there's no deadlock here.

CONFIG_DEBUG_VM_MAPLE_TREE is enabled, which will cause _major_ slowdown on VMA
operations as the tree is constantly being fully validated.

This may explain the stalls...

> dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a43bc580000

No C repro yet...

>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/24fd400c6842/disk-be48bcf0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/59146305635d/vmlinux-be48bcf0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b3e5f65cbcc8/bzImage-be48bcf0.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6029/1:b..l P1208/1:b..l P6031/3:b..l P6030/1:b..l
> rcu: 	(detected by 1, t=10502 jiffies, g=6285, q=421 ncpus=2)

So 105s, or 1m45s, that's pretty long...

> task:dhcpcd          state:R  running task     stack:28896 pid:6030  tgid:6030  ppid:5513   task_flags:0x400040 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> RIP: 0010:unwind_next_frame+0xfe7/0x20a0 arch/x86/kernel/unwind_orc.c:664

Hmm, while the line number is not pertinent, I notice unwind_next_frame() has:

guard(rcu)()

In it from commit 14daa3bca217 ("x86: Use RCU in all users of
__module_address().") though from Jan 2025...

This is defined (took me a while to track down!!) in include/linux/rcupdate.h:

DEFINE_LOCK_GUARD_0(rcu,
	do {
		rcu_read_lock();
		/*
		 * sparse doesn't call the cleanup function,
		 * so just release immediately and don't track
		 * the context. We don't need to anyway, since
		 * the whole point of the guard is to not need
		 * the explicit unlock.
		 */
		__release(RCU);
	} while (0),
	rcu_read_unlock())

Meaning it's equivalent to a scoped rcu_read_lock() / rcu_read_unlock().

But since no C repro this is likely a race of some kind that might be very hard to hit.

> Code: 85 80 0c 00 00 49 89 6d 40 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 56 10 00 00 <41> 39 5d 00 0f 84 10 06 00 00 bd 01 00 00 00 e9 de f3 ff ff 48 b8
> RSP: 0018:ffffc90003cdf6a8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90003ce0000
> RDX: 1ffff9200079bee3 RSI: ffffc90003cdfa70 RDI: ffffc90003cdf758
> RBP: ffffc90003cdfae0 R08: 0000000000000001 R09: 0000000000000000
> R10: ffffc90003cdf718 R11: 00000000000121e6 R12: ffffc90003cdf768
> R13: ffffc90003cdf718 R14: ffffc90003cdfa80 R15: ffffc90003cdf74c
>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
>  slab_free_hook mm/slub.c:2378 [inline]

Invokes the CONFIG_SLUB_RCU_DEBUG stack trace saving stuff

>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x15a/0x4d0 mm/slub.c:4782

Note that VMAs are SLAB_TYPESAFE_BY_RCU so maybe that's somehow playing a role
here?

In free_slab():

	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
		call_rcu(&slab->rcu_head, rcu_free_slab);

>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>  __vm_munmap+0x19a/0x390 mm/vma.c:3155
>  __do_sys_munmap mm/mmap.c:1080 [inline]
>  __se_sys_munmap mm/mmap.c:1077 [inline]
>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Seems a normal trace for an unmap, note (inlining removes stuff here) it's:

vms_complete_munmap_vmas() -> remove_vma() -> vm_area_free() -> kmem_cache_free()

> RIP: 0033:0x7fb13ec2f2e7
> RSP: 002b:00007fffe10fae78 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 0000562bd1443510 RCX: 00007fb13ec2f2e7
> RDX: 0000000000000002 RSI: 0000000000004028 RDI: 00007fb13ea1b000
> RBP: 00007fffe10faf80 R08: 0000562bd1432470 R09: 0000000000000001
> R10: 00007fffe10fadb0 R11: 0000000000000206 R12: 00007fffe10faea0
> R13: 00007fb13ec42000 R14: 0000562bd1443510 R15: 0000000000000000
>  </TASK>
> task:syz-executor    state:R  running task     stack:27632 pid:6031  tgid:6031  ppid:5870   task_flags:0x400000 flags:0x00004000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
>  preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
>  __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
>  _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
>  spin_unlock include/linux/spinlock.h:391 [inline]
>  filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
>  do_fault_around mm/memory.c:5531 [inline]
>  do_read_fault mm/memory.c:5564 [inline]
>  do_fault mm/memory.c:5707 [inline]
>  do_pte_missing+0xe39/0x3ba0 mm/memory.c:4234
>  handle_pte_fault mm/memory.c:6052 [inline]
>  __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
>  handle_mm_fault+0x589/0xd10 mm/memory.c:6364
>  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

Faulting path being context switched on unlock of PTE spinlock...

> RIP: 0033:0x7f54cd7177c7
> RSP: 002b:00007fffb79a5b40 EFLAGS: 00010246
> RAX: 00007f54ce525000 RBX: 0000000000000000 RCX: 0000000000000064
> RDX: 00007fffb79a5de9 RSI: 0000000000000002 RDI: 00007fffb79a5dd8
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 00007fffb79a5c48 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> task:kworker/0:3     state:R  running task     stack:25368 pid:1208  tgid:1208  ppid:2      task_flags:0x4208060 flags:0x00004000
> Workqueue: events_power_efficient gc_worker
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> RIP: 0010:write_comp_data+0x0/0x90 kernel/kcov.c:240
> Code: 48 8b 05 db b4 1a 12 48 8b 80 30 16 00 00 e9 97 05 db 09 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <49> 89 d2 49 89 f8 49 89 f1 65 48 8b 15 a7 b4 1a 12 65 8b 05 b8 b4
> RSP: 0018:ffffc9000441fb50 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: 0000000000040000 RCX: ffffffff89ba2a52
> RDX: 0000000000040000 RSI: 0000000000000433 RDI: 0000000000000004
> RBP: ffffffff9b2c41ec R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff9b030610 R12: ffff888031800000
> R13: 0000000000000433 R14: dffffc0000000000 R15: 0000000000001770
>  gc_worker+0x342/0x16e0 net/netfilter/nf_conntrack_core.c:1549
>  process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
>  process_scheduled_works kernel/workqueue.c:3319 [inline]
>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
>  kthread+0x3c5/0x780 kernel/kthread.c:463
>  ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> task:dhcpcd          state:R  running task     stack:26072 pid:6029  tgid:6029  ppid:5513   task_flags:0x400040 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:80 [inline]
> RIP: 0010:__orc_find+0x7e/0xf0 arch/x86/kernel/unwind_orc.c:102
> Code: ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa 48 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07 83 c2 03 40 38 f2 7c 05 <40> 84 f6 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39
> RSP: 0018:ffffc90003337648 EFLAGS: 00000202
> RAX: ffffffff914e0dd8 RBX: ffffffff90c5215c RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000000 RDI: ffffffff90c52148
> RBP: ffffffff90c52148 R08: ffffffff914e0e1a R09: 0000000000000000
> R10: ffffc900033376f8 R11: 0000000000011271 R12: ffffffff90c52170
> R13: ffffffff82127173 R14: ffffffff90c52148 R15: ffffffff90c52148
>  orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
>  unwind_next_frame+0x2ec/0x20a0 arch/x86/kernel/unwind_orc.c:494

This is also RCU-read locked.

>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
>  kmalloc_noprof include/linux/slab.h:905 [inline]
>  slab_free_hook mm/slub.c:2369 [inline]
>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x142/0x4d0 mm/slub.c:4782
>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>  __vm_munmap+0x19a/0x390 mm/vma.c:3155

Simultaneous unmap?

>  __do_sys_munmap mm/mmap.c:1080 [inline]
>  __se_sys_munmap mm/mmap.c:1077 [inline]
>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb13ec2f2e7
> RSP: 002b:00007fffe10fae78 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 0000562bd1443f00 RCX: 00007fb13ec2f2e7
> RDX: 0000000000000001 RSI: 000000000002f6d0 RDI: 00007fb13e9c1000
> RBP: 00007fffe10faf80 R08: 00000000000004f0 R09: 0000000000000002
> R10: 00007fffe10fadb0 R11: 0000000000000202 R12: 00007fffe10faec0
> R13: 00007fb13ec42000 R14: 0000562bd1443f00 R15: 0000000000000000
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

Cheers, Lorenzo


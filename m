Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F079AD46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289B56B00A4; Wed, 21 Jan 2026 11:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAF76B00C7; Wed, 21 Jan 2026 11:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B906B00C9; Wed, 21 Jan 2026 11:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E151F6B00C7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3716C2B57
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:32 +0000 (UTC)
X-FDA: 84356577144.27.295D4F9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36356A0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Iz61JBY7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Aft8jwWG;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
	b=VIdJHsz+t4v+kXuHdkNrqBYcJIxGtTm6GQ54rX2OaL4zJYCHSaopPTwfHIeHYu1e99bjL/
	LQnMzDgPdEQgyA1xUwtq6OYTuWXyBF9YMh78r1kXBrUw2HItb62Cm7S0OxrLecOiItScDN
	GTPa7fEPqo+3QhmfAkusTD1H0z2HZyQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Iz61JBY7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Aft8jwWG;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014649; a=rsa-sha256;
	cv=pass;
	b=Hf2xKCrGR9E8wM3iqoe+V4Q5IYQDR46ffc9fJSte8qar0w2lhXVKGLCrjhRnGOSV9JMjOC
	ZXz/4xrcFOBFxGJfCO6DgMlw+c6xX6wYmgSektEwPTcYmOIvpX9bi0kEWe3Pu6xTMp/pT0
	y1QMZe1qzGUQgnignVSlz4iYo+Myeyc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDEfgq3031860;
	Wed, 21 Jan 2026 16:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=; b=
	Iz61JBY7V/TXbNn0gxrViIw+fTcOy3yClBcjyAFfhbwz2mmtuh+EqJ0r+17SIrUr
	JnZEU1rjCdLmWd/yDHwhd5xUGIDVjo3Gid2aexh5xh/yWhphlaKUPCoEzi/GsG8C
	WOpSQFb7wJ6F402xL24ZK4t7x9Fhzt39KCxw7w5kH7cVOuSyXUm99iBv0EYi9EM5
	A+tk7ed/NaFpU/44Zr0S5G7sy88Xm3YDPGLegxzE92gYBDdg9WWhK5yAtQoDTe70
	1na2+kodT0EfNchC5t49PgUAfy6iPAmUMPNOf4of+ekxceewgaf8rRdKapfYVKbG
	vFPIBwC38L/BiYUxfoqUNw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypx5aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG7dnp019003;
	Wed, 21 Jan 2026 16:57:19 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbw6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpkRmSsdiExvgUek6x0fcFbLGzAj0e/GruD44M8oyD0OKJDhKoh/FjPoLspGh0JrDl5eyayOg+pk1XPwiwiOMLmuO8mHLILoZA/FA7UVTT9QYP0mOmfs1pKGQ4bJWkecEyInM0LlveXyRZDWh7z+UZKD3S1vPSJ9GD8npnu98S36JkJgwkTodtCOL6papiJDk5y1w2RfXMfuA0LO/DvsjRlX2yq630k2K4pW0h8gA0VCopCvLL865tImHZcJmq+xGc9xBmmi6wQDP0D7MCLgMomZeg0y/H0XNbrC//fnePdpbixIFDcMVKO3zaAVDLi1EhMV42UStXwMVd3AJuJVbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
 b=xx9jSsUF14tYP7NVZL7rRs1LSKXenSUGebhseCUToVFZAUOQJBYjLnbPJwfGVP5Q4+jKrcA8HGKbXbbHJyjAktFhQjQAZhCWGflmdzI//taMnpd+wNIQ16I+gg/jxEAQhgUXYzDp+0/lMN2ndy4ooUssuexkoLNep0fEblfgTxuRoGLSnSh8whQ/cX6H/npHgA50N6IfthBP8tH/Z9oktWefFXigpzyPonXhQPOsulpKchHfksy1oO6KSi+/Ne7NrrPjur0bEyfYGEvv9MlWSvKoBSC0xH1I/+wNL27J8dmmXiMCthBEbldMFZPqV65Ayn55TxoudcciweOBFWHNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2fiLpzpBEZoZ4g87VtBK34J8dF2qLs+qFx6Rw8FYEU=;
 b=Aft8jwWGOjhZ5Oqjns0C/InvfcK++TqGgx7taccw8W89O8pxCHxRrzd4uy15fKaFtLSMa5YThxCna20D1Ceg7KP5isPQgK0CJEkItByOfiDlmlJYo8H99cR53BIcX9KFMpPd/dMzPY/t6esPF1NIaZguhObl30g25IcaumN6PKo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:13 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:13 +0000
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
Subject: [PATCH v2 14/29] maple_tree: Change initial big node setup in mas_wr_spanning_rebalance()
Date: Wed, 21 Jan 2026 11:45:11 -0500
Message-ID: <20260121164526.2093265-15-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0305.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: d7cd682a-1dc0-46f9-0fd1-08de590e1fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4iPjtACBrWCzvC0U0Ovo4IfzRsAFsofBndW8RNJFpOZnA45kD5/ljCkWudY/?=
 =?us-ascii?Q?xpYxwn0cOHjzcomOesRfs4TjH/RX6EpEMatdT9wWWTay353lPfbMIAIvRxVM?=
 =?us-ascii?Q?wPpSlfPdUsSTA/dv+VsXmmaHivquAYe0sptABm6jpEjRqcMJvTB6WVJmCRyS?=
 =?us-ascii?Q?tpz5brmtQHZKVtlBd3MDCqydWFGG/9hi1TuPKK6ZECZg7esV3kAK4alYVOQZ?=
 =?us-ascii?Q?mRlNH3zlgy+3TKV6F6Cmw/Hp6rJ4XM73WdJle152nhBZGiunjd8jUbf5jgVa?=
 =?us-ascii?Q?p8D/dKIgGFmhPQN2xtBPWOzoJCvvH4HP45YejJvrZAuhRtx3b2s4Teastg+J?=
 =?us-ascii?Q?8XTAwuR4gyVhcnehcNxQO5pxwd6WGEHsDzYdF2zVrWeCYJMGndNsHEP1Vm9t?=
 =?us-ascii?Q?oJ2h5O4dlMMrNOdkKqouVNPDYVXq7E+bjDaRMfEIrmPQbYaxgXUtwMr3gYrU?=
 =?us-ascii?Q?eul0VgGknDhLvWtIPr9+Hsvkl0QUF41XXuc4F+dUCdlh09uo2n2E4wW8whEq?=
 =?us-ascii?Q?vGqBECxAcdpmuT7OkySy/J5SGL8JPV5oQmF7Afbu6GbrEJnwllaPHm0blluR?=
 =?us-ascii?Q?4XMQvCQtWy+8rFae0K6xbPmticfd+6eccqsSzME8hbmamyr5aA5Srm+n5+mG?=
 =?us-ascii?Q?fzFKU0c2SdCeP6F2MBnD087yL5cX1Pi2DfI57zhb7vF0nRiAgKLPv4KZjbtd?=
 =?us-ascii?Q?swcwW0H0XdwN6QVabX62d6voYIyZldCTyq2LZH5zqixjqqk8IoFrWihqYqpd?=
 =?us-ascii?Q?YbHtJ7QpBeFhbr51f9syy3AP/OrVo0pNUlvWyYvqnBTAtt+2xytn7JGY8mIC?=
 =?us-ascii?Q?MN45+ZVZ6FSTz8DvDxRDDvwebuEgqXAc18gaCR3k3V9j4Muxp/K4Jk4n9i+B?=
 =?us-ascii?Q?DMSz9kiO+dIG9zAkq6MldAqT/MmYaFM6RaRtNIMb77xRzBsidQb0wZ+l1Lgr?=
 =?us-ascii?Q?otF3zCCI3ubmWfpaj+zzWX+nT6d7hTV92DdqLWVPNyv6fizyKjioIOptFvjM?=
 =?us-ascii?Q?Qta8CyUpcdcdqSz43d7FejGenNCEXYJ77Rc0pvd5OavG2wG1/cKhjvS6IYK3?=
 =?us-ascii?Q?Kr2O1tIqdNsYfNNgGKy57REoOdwkCeHLWjbrnsriAszbpi9uhV3kJkn4vPid?=
 =?us-ascii?Q?fWnQHXKaBNdyqNnOI/ECPFEGQYkNKcEP5t4Sdy8juzuvD9BriWAZ7Hxf0jY8?=
 =?us-ascii?Q?oMejyEuDZKHR1nw8w/lyrzz+8BGAIe7jhiyE9AKf+Lj3ZhCI90jImF2O+goe?=
 =?us-ascii?Q?Lvdk33qqf/7t1aG80QfZIj+7cksc6USHSeLeOd6/jRgPiqtq4cUf7Sakioer?=
 =?us-ascii?Q?GRf1sLWnn78xCcYl7oUM3B1tfYlJSv6bFysLAF6WsDSO/N+fiPpifJkJ1Cxd?=
 =?us-ascii?Q?98ly5hySxIwgZqkiMQyDZuNNMXJvz6rgTSle7tKBCwqK43mz8T6rw8VUMTKv?=
 =?us-ascii?Q?7AHLoL7Z1IAbOVs1KnfV2WapwF2rLd49amUgRVEGvto0HvtrhSIgkVQ33WUG?=
 =?us-ascii?Q?oXmgGKS/vzNVFjA/jZHvY9e9EvZLlejl30kGMcSvsX4LpiVrfaTUUwExM/EQ?=
 =?us-ascii?Q?4+OBSF4Fn+QPioAh6Dg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SMV5vkzdKbyD9ROz8kyHqLxCcjjcsWHQmB0/FST/84w4tUJaRaQkPo6FSwF6?=
 =?us-ascii?Q?Rumm3QPT9hdTNf3aRVeSZqlMeApNzgWk1D+bZbBy7Nt/c7mfWGAlcrhVbYK8?=
 =?us-ascii?Q?eedT6z1UmAePdYVmZwIFQc115+f52ZGUye2+HwGeykMhy268eNRY3v/fXfnf?=
 =?us-ascii?Q?qZZVvkYPZANxgpVx2rQ4+Ceiey1G3DcKyTzYrmpbeSozsU9plqadsXLONnlF?=
 =?us-ascii?Q?XCny1uPnbFm4Vi3CnNbbnNt/BkrgecfA9Aj58GKWIGWQGpDpNlNJicWsxFT5?=
 =?us-ascii?Q?/Ig5QmvBMtwTRza5X2ZQcrUyICFDN1FRm0V1GojnbrDVTxQUWckCPPFu4Fwx?=
 =?us-ascii?Q?31usarkkpt8HDq49pdwvL/C5ysUzX+g9o/aD2d0LCZn/2WgQR39B7hoGhWbR?=
 =?us-ascii?Q?DkvbE0THTxZmfexN3nupZn81I5iD36BkvYUZvrPIHn6E9VVQLKfN8heccgss?=
 =?us-ascii?Q?gxE2G/JWxk5GnUyfsI0jONijxsKY8Hmr1RB8mMrXR+WWspmAbWP6RuZ3eeWK?=
 =?us-ascii?Q?T7CA/+jvgipO0QmEcmPMuTQi57L/u7LhlvCCbcyAFuciGqlAB4F9V0GSpWSV?=
 =?us-ascii?Q?SFMhnkNfBLJ2kA1KeUZtrSDom6cRaaN/k+DpoAAY5XA36dGu5qerxeLxCEU6?=
 =?us-ascii?Q?0sVFRUlA0AsyiTI0VBOtVt9fsYvBnoXZ4Gp9yDXaotgSc7W8TQ5c1fklNWbL?=
 =?us-ascii?Q?z24Kr4V0QlQSQp3kMTkpCRvBmclz+zHEQZwzdqkOqz+7P80fjVDDgUQ2+z2p?=
 =?us-ascii?Q?6+iJ41cDDLyt6XTIUdUxcGJe/XEr8C8HaH68CDrIXzTBwkxI8qCfkecrG1O1?=
 =?us-ascii?Q?M3WRNk+eSyQr0FjSbQhf3LYMk09urdJ0KqbiR5CIW+KvogozCCeB4qkyYbwi?=
 =?us-ascii?Q?tZi+sMnFhoy4l//5fZq7syPp7kNZgED79O9guPm1hHFyQ5tU0sFjB7nJgDQ/?=
 =?us-ascii?Q?G155UEpRkeumbWa/1Qq/6Uis+vZ6vSFQr/ncoOGo117Szt/wGCI0Ce+kA5s+?=
 =?us-ascii?Q?I4DDCfJ+IQbtzzac5DsCYsb6VHjE1LyXQ926wacyYJ8m9J0xKvr5h0FEFwYy?=
 =?us-ascii?Q?mvroiHFT+3+46Rpmm2Rz0gnOyrt+Ool3AOfOEKKt8MGA9vRwyNaSMAwSw35N?=
 =?us-ascii?Q?BAItEwZMtdgMhkeFM7XUJHS5e9WVXqH8DA0YzmwFwekrCsOr+capJ2uf4eMi?=
 =?us-ascii?Q?BKhY3Dk5fSvXtu0I96dWSRBfzOBs65RjUys/OTxfADYSq9q4FWM4iMbno2Ka?=
 =?us-ascii?Q?VgKuk8zpHFj+wCW1t7HnYPTrYdbjr/lO+pSRtRnZ8dMDCgcUYmkN7iNg+zoF?=
 =?us-ascii?Q?7O1kKPGQDAYy6v7Y8z90lDe+FXuLm9ILZOjL0JIQI6FEs0Lks4JAndvuAC9R?=
 =?us-ascii?Q?RlmyMLeM4G94CCg8qyAh8qfaG32PTjQqPBVBVkbZiNYu60FXJvwznRZgiV7s?=
 =?us-ascii?Q?/IhkmiPmg4kF9z573UnT0gGr4oj9wpzMOVoYeSVbdhv5bdP72riOiW2kvEas?=
 =?us-ascii?Q?2gPGAAFJ6w1nHAkJG80Fa73B8zgHYLQIcC/IqRNhw96iUfcOmy4K3cqkv471?=
 =?us-ascii?Q?dbMP9rOsPmCLktHEXEkhHaEXy/kuHkKToorEayb8qZ3jtQukOGpotmFdI5rs?=
 =?us-ascii?Q?nesFkJO12whnYx6Aho4aTARHA7/EXoNY3CCbMPnb8UIVKnQ7Gmj2jEQSLVIP?=
 =?us-ascii?Q?nqxs/3FebdNqIDG8yuV4B9XcIwgmDOzCr02OGsDNNXW88bZUY/fce+IoMpyj?=
 =?us-ascii?Q?rW/D4UaCkw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+9ZTuXAyM2KmFkrxqaDomOi1ltY/+VRxW/t8vUW2K5jYSyPUQQPFSu1tlm3352JXogekRb0Rwu1yomlvLg+OH63q84JUZKRnfW4rAWdlPFiHj8QmWHAjXitGRwKCnOnFNaGIqps93dBTu5ZeGH7hUkaCjaYryebkBgs84efdXfnWPDYYbZa8Wcl0ijcj98u5XRSM7Xhqo8GVyy732sqTrh2j7hC+UnEZ/vhBOfgxDD/i8jl9aBmmHC0U/qDOnNe13LqwBfFxjUF9CVzgpcpuWl8ejH/AQDWdGr0Tt12L6SpbCaiXDVMUuW5teYDwf2a3MGgYig9N+T2kn80IQhLYhbKsBTIG1ogqkfQvstMMiVzIO+vw3YZvWZk8pZcgfzsWZ+UnpJhZ2lMTvWNmznYhTysDlagwshKSK0i8loY5BSzKfS9UEyqniVRM2KyrgP2dwmJi/V6R8OIHPJeHjMRpcmnM2MP+zPlNaKsJyR3ssyj4qndYu8BNbAdRgtjITPfFTEj9A+keShgxhrN2msjFMPczax02/xB2eFGmmN1hNQ+IV0BUFAg3Vc4Prguyq6lDomhqOey5fYhHFUr36xccF3hvkEX3vjQUxLLHphVrIbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cd682a-1dc0-46f9-0fd1-08de590e1fd4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:13.2711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RyrsKXGL90JdQR096ZdbyaXbCnbKn2jAcqQL9FY4wMWgWPZbF6dxC4L/b6fygyH9QXLWkw664Bbbb1TByoFPWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXxlyzaIbFvCOH
 ZBXbKv3EzDIH2IKAZcx1mB8nVqDFBqbuIYssWkvLVrn91OQZfJUfR+Y6fBvGWR8oF/Ddy/SVw7l
 Kv8luMnQXm82Qi+G1a8aJq9bKv8X3WqUhsFZlKUpz4SNpgVgHiFR6lJb0eM9cIqQ4iunkXfu5V9
 cE97b/UWIoYtXWnBSR9g6NHRY6X1PEj2MNq0MCPuEGFE6/0qaSS6BwvNTs3kq3E3o5c1bRRa98V
 1dcfUQmVzA9qmh/KkZ4iNJEEO/JVaPIpdai4y7SPayvrZRzvtamy6/FZUb2VuKqygYCEtfjZR+6
 01U2RytWETkkDs1J4/NQ9Xowf+VRPM5ZIPseiyYDtWnnNKMPBWDezAZAhXnuGxY39LVHnf4ogoo
 BeZccsRLy/EYTNuNarHS8YAIlH5uPz7V6r1mglF1c2sn4DmgR2fHpxCf3FVqYghzMBDg8/DfebJ
 yIaoKjsn9+bUv1Wd+G9HGF4dkpxpGxmyAsIHL5do=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69710570 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Dk5oX4W92Jz44JyhfwQA:9 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: uosasmDj4u3YHV58EPPRNmfLvHxy7i3B
X-Proofpoint-GUID: uosasmDj4u3YHV58EPPRNmfLvHxy7i3B
X-Rspamd-Server: rspam11
X-Stat-Signature: gamw4mx1oz6m8c17qp4mw7sx961e915t
X-Rspam-User: 
X-Rspamd-Queue-Id: 36356A0009
X-HE-Tag: 1769014648-374476
X-HE-Meta: U2FsdGVkX18MUd33GgzQseJZTAla1e0B2LHK4HL/d4GCe7DFCYivnYyJcd9SvxaGSFwZKb6w9ojFyrMnU6nXeuLGF9j5nsASJdtOJ/9mCSj/oC1LXu4aVwzVAEL9raDZuKcFlBgmvlrBRszK3LIWm6lrCLvEL2JURWhKBDUsPySadxRKd7chjj1ysg2NZ7WQbOjGcus7qps012mh5KrTK5z5MP6rhgrpf05dDoPO+81DN/gcK61inZX270tGuFoQgORry93eF+BZj9nVFvL+bUR8vE1ANgFf2oBOjthxLSUqV+lw52tYTjM4o1/A6ihcxIA6LMox1z+mAY2ZNxPT/X6mM/CZhd6dpTSI+ow3by6AaJIjrRAzenEOa8clg014ibCGJ6MuCth5+FoYVdHaWWNI0v38/e/qebf5AbciVLcN4PS5T2CjRB4p4BsrWxShDHT8cg38AK3jYZyRF94yMK2QSwSdvJzWfa8dJPUWq4YykJ2nwOR/BDOYDxRQq7bxd9H9OEG5wlGQGuIjShGVejhupur5swdVBkFuGkmg2njTzq6Jk+CkJRmEjGvDxF93p1XZ27I+IyomYPUC7kCkb69TRfxGDALtmGuJNXSaZawUWSDfrfov9wrgSfB9ASLOKU0pD3m2moCn5b/S7gw36Na/g75IqVOaRXBiDEPQF6yI310u4sxYaQD4vp+BZ/diE22RENONHxnUcmdNvcYGrdTT8p78TU5N+SYF6yNrjaJiNnoX8TTj4HS9c6y1BjqIdmj1syVe+tgCWfJzO6cfDjTwy7b2LoMAhxgd8/9T0azFeeYiCFdpvQyelXKyL1iXFVIB3UZjiSiri6Wq2BsrO0O//YQoG56BLVCRrOdetYKJNyWAbiloNnlvW+sWJhef09fVrMkPV58dHeMVTkc1+QM7qrJQrYDvOLp/7+3boAKVzMNZOMHWrFxRUX17HWQXXpjCZXBOEtVleQPA9HN
 Hrj8J8z1
 HegzjRVtgepuVmZOZ5RqktiB3nLOj1/puMN3WxBdRUcJ2MLgk2jVgtFG0lD1y+g88pGbndNFXJn77fS+HSvuJAp+TEOLuSX6xrVk3gNZqLpD+0mNuN7017axMfbh/9GiMxH0tEt+4ioZ1e6QFXPxEbSPBwTIfLoUbsAiSFJDNtglQue7V8Oua71b8/HzWYFl+GMPVePwYSySOMw/hUROWxZxZsgAj5HCIXYN3F2Tk8rlbrpC1+IOtwfWcpUDB2IHQp+8YJNrqK30O7GZcIb/UNvVm0jSrWK/DpKdUyxR0t7uKZm1GUAHGFfqW4f+vVpD6pjAvdhS0AkqUm462ts7H+hsnuJON/P5cuEyKdk+jsHXSEIW/QFzdJvTG570+rrNM1shLzie1b/M8G4Jc+P+v8g2g62Zo1/GS1NnTra80o3dzMnTAb7sHxMwgXXO94RwD0oBBVtYHXLqlaNKwHesQnvVek/4o1d0w9y5KN0sHMhFyA/geU4crT4cYY+k4FC224Bx6rX3vPe0zlwGVluHrpe60bPi+0opSH2xz54z/Jygb3c5p1IDQBAfLRH2s/4CYD2DXCfjiJ7FWHaP/AQJ9yCBcRZgKiwwIG/aB8AF4hXGwjOBNGiIT7AZMERw0NYtO/Wnqho3f+vx72WWIhXQI2jXNh/wln02D0MgGPBdFcW/IpO1XpXSXInwi4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of copying the data into the big node and finding out that the
data may need to be moved or appended to, calculate the data space up
front (in the maple copy node) and set up another source for the copy.

The additional copy source is tracked in the maple state sib (short for
sibling), and is put into the maple write states for future operations
after the data is in the big node.

To facilitate the newly moved node, some initial setup of the maple
subtree state are relocated after the potential shift caused by the new
way of rebalancing against a sibling.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h |   1 +
 lib/maple_tree.c           | 175 ++++++++++++++++++++++++++++++++-----
 2 files changed, 153 insertions(+), 23 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 9bc7fa89bc2ee..e99e16ac1c6da 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -177,6 +177,7 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char data;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a9b7e398c7dbd..0d6f810a4a1fc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1304,6 +1304,18 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 	return mt_pivots[type];
 }
 
+static inline
+void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
+{
+	wr_mas->node = mas_mn(mas);
+	wr_mas->type = mte_node_type(mas->node);
+	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
+	wr_mas->slots = ma_slots(wr_mas->node, wr_mas->type);
+	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, mas->offset);
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
+				       wr_mas->type);
+}
+
 /*
  * mas_leaf_max_gap() - Returns the largest gap in a leaf node
  * @mas: the maple state
@@ -2258,6 +2270,44 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline
+void spanning_sib(struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
+{
+	struct ma_state l_tmp = *l_wr_mas->mas;
+	struct ma_state r_tmp = *r_wr_mas->mas;
+	unsigned char depth = 0;
+
+	do {
+		mas_ascend(&r_tmp);
+		mas_ascend(&l_tmp);
+		depth++;
+		if (r_tmp.offset < mas_data_end(&r_tmp)) {
+			r_tmp.offset++;
+			mas_descend(&r_tmp);
+			r_tmp.offset = 0;
+			while (--depth)
+				mas_descend(&r_tmp);
+
+			r_tmp.end = mas_data_end(&r_tmp);
+			*nneighbour = r_tmp;
+			return;
+		} else if (l_tmp.offset) {
+			l_tmp.offset--;
+			do {
+				mas_descend(&l_tmp);
+				l_tmp.offset = mas_data_end(&l_tmp);
+			} while (--depth);
+
+			l_tmp.end = l_tmp.offset;
+			*nneighbour = l_tmp;
+			return;
+		}
+	} while (!mte_is_root(r_tmp.node));
+
+	WARN_ON_ONCE(1);
+}
+
 /*
  * mast_set_split_parents() - Helper function to set three nodes parents.  Slot
  * is taken from @mast->l.
@@ -2642,6 +2692,49 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 	cp->end = end;
 }
 
+/*
+ * cp_data_calc() - Calculate the size of the data (1 indexed).
+ * @cp: The maple copy struct with the new data populated.
+ * @l_wr_mas: The maple write state containing the data to the left of the write
+ * @r_wr_mas: The maple write state containing the data to the right of the
+ * write
+ *
+ * cp->data is a size (not indexed by 0).
+ */
+static inline void cp_data_calc(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
+
+	/* Add 1 every time for the 0th element */
+	cp->data = l_wr_mas->mas->offset;
+	/* Add the new data and any partial overwrites */
+	cp->data += cp->end + 1;
+	/* Data from right (offset + 1 to end), +1 for zero */
+	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
+}
+
+static inline void append_mas_cp(struct maple_copy *cp,
+	struct ma_state *mas, unsigned char start, unsigned char end)
+{
+	struct maple_node *node;
+	enum maple_type mt;
+	unsigned char count;
+
+	count = cp->s_count;
+	node = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	cp->src[count].node = node;
+	cp->src[count].mt = mt;
+	if (mas->end <= end)
+		cp->src[count].max = mas->max;
+	else
+		cp->src[count].max = ma_pivots(node, mt)[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
 static inline void append_wr_mas_cp(struct maple_copy *cp,
 	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
 {
@@ -2670,6 +2763,42 @@ static inline void init_cp_src(struct maple_copy *cp)
 	cp->s_count++;
 }
 
+/*
+ * multi_src_setup() - Set the @cp node up with multiple sources to copy from.
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The sibling maple state
+ *
+ * Note: @sib->end == 0 indicates no sibling will be used.
+ */
+static inline
+void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
+{
+	cp->s_count = 0;
+	if (sib->end && sib->max < l_wr_mas->mas->min)
+		append_mas_cp(cp, sib, 0, sib->end);
+
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(cp, l_wr_mas, 0, off);
+		cp->src[cp->s_count - 1].max = cp->min - 1;
+	}
+
+	init_cp_src(cp);
+
+	/* Copy right either from offset or offset + 1 pending on r_max */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
+	if (sib->end && sib->min > r_wr_mas->mas->max)
+		append_mas_cp(cp, sib, 0, sib->end);
+}
+
 static inline
 void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
 {
@@ -2873,36 +3002,42 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	struct maple_big_node b_node;
 	struct maple_copy cp;
 	unsigned char height;
+	struct ma_state sib;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(mast_l_mas, NULL, 0, 0);
 
 
-	mast_l_mas = *mas;
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mast_l_mas = *mas;
 	cp.s_count = 0;
 	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	/* Copy left 0 - offset */
-	if (l_wr_mas->mas->offset) {
-		unsigned char off = l_wr_mas->mas->offset - 1;
-
-		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
-		cp.src[cp.s_count - 1].max = cp.min - 1;
+	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, &sib);
+		cp.data += sib.end + 1;
+	} else {
+		sib.end = 0;
 	}
 
-	init_cp_src(&cp);
-
-	/* Copy right from offset_end + 1 to end */
-	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
-		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
-			       r_wr_mas->mas->end);
-
-
+	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
 	b_node.type = l_wr_mas->type;
 	cp_data_write(&cp, &b_node);
+	if (sib.end) {
+		if (sib.max < l_wr_mas->mas->min) {
+			*l_wr_mas->mas = sib;
+			wr_mas_setup(l_wr_mas, &sib);
+			mast_l_mas = sib;
+		} else {
+			*r_wr_mas->mas = sib;
+			wr_mas_setup(r_wr_mas, &sib);
+		}
+	}
+
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
@@ -2917,12 +3052,6 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	mast.m = &m_mas;
 	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
-		mast_spanning_rebalance(&mast);
-
 	height = mas_mt_height(mas) + 1;
 
 	/*
-- 
2.47.3



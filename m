Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD44D715DB
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 10:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7903B6B05A5; Sat, 24 Jan 2026 05:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E446B05A6; Sat, 24 Jan 2026 05:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5796B05A7; Sat, 24 Jan 2026 05:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 485ED6B05A5
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:46:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2DF61A0266
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:46:38 +0000 (UTC)
X-FDA: 84366528876.08.1FD727F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 484341C0004
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:46:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pvnCq5mn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DFKis0d6;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769251595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IIGQHz4cvvxYnF+Z5oey4yYRPdOy5yTHM0ed+T8HzCg=;
	b=an9mIK2HEQCX/8mvkDzi3MnAWvydK5MtZiBzSfsOPRSIZysTAU+hoTG+h4q6sbHpB6CxPu
	ru/4Mm94ZGjtmc+XKKnT5/2TPcqOGfvirM3QZDzvyHSOg1VftDk7jZVoVI/F7otnUHrTcw
	ETyU4cBUDS6ixunp6pf41DtkD2o4TwI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pvnCq5mn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DFKis0d6;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769251595; a=rsa-sha256;
	cv=pass;
	b=4iNMKNUFStPxDym86Ycuxc/f3dL2TByaM9eROXy5XU9Jzqn0ImvtHRRwHHSuXeB88sF+OR
	muE+6PjwdpFPJzBjVfm1yjzBp717sujsbgP+dBwB/6pUBd8flcIub+ON07um7ctiS/GTlG
	8nLoNsiI+WEyINvO3GIBItPyHpl6oc4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O9o2Cu473785;
	Sat, 24 Jan 2026 10:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=IIGQHz4cvvxYnF+Z
	5oey4yYRPdOy5yTHM0ed+T8HzCg=; b=pvnCq5mnxVDprHscwcx4/0kWRtKQE4f4
	dzhAhw9DlKGKDfpkiY1HSVgm5+mxh/htwSEulTDm3ayUusDOgqMmrDkRIEidoRYW
	t25P12bC+nqA1pSdGjvzOhs+Y85l8oHj5INjSdF7A1EZc2euv5GaF/6+5FsqatjC
	Cjt90ZGWBEyrNsFG9RTqLZ9KkTozMFvLkmQ3WybvU7sDW9gJZVBIZL/HBqiTwVJR
	3UzNNZ9JTtCpaa37+a9PIKZ4gMuMeezAwXND1rSNpucciar93ABN5e/aSOtFHna8
	NjdstCko+JPqK6VfU50Lpzuo7qop78rINhskR9PDhJ3we7iHZL2ODQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny06pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 10:46:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O8IvnU009991;
	Sat, 24 Jan 2026 10:46:28 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh6bk0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 10:46:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PF7aYo3u+NZyow7jm2rkrWl5adFR33G/QIQ8DHzEcRQUeDniipc6vXTR0hcrvzzpzC4F0YblK1P5PvoG/9aBTKcl5Y+fkjEdE8oJ2dqL1xXpUbiy3tT8YL6JWtyLZVPlmFyc0PI9Gg1ouVuXvVIu4nFtEYAr6vXnBeZkv0ziNHaNCqxvuTdRUQaZjCDMkYn6V7pG2vT+w10ClYCoMTvTTExjVf2QBGpkdzsdznwoIAr1cxJmNTQZ+meIiZTY8Vg83aTlU9T2/OenCqPl0I4fl5yLnoMc8p9pf7t+nIch0uKrZpNzAMRauIW05EcWWahG6kzOiNS4aY9Q1Onqk9tc/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIGQHz4cvvxYnF+Z5oey4yYRPdOy5yTHM0ed+T8HzCg=;
 b=pHUSq9jfiCXVgHMK/xgI1KZFyeyH5v2ng732fDXgDLLbla8vT57yuD2mspaPZ73PmBlv6eV2EbIqrQ8KpUNC8mPcGSnJYzOkImZugaMf4Hd/8/FZtfrKvtYLEZ2kqY+1+3lbVh8/xNeWJYfcEem6LxJfvWuYW8DjdlczJpcgYXmp0Lmwv3MQfdHW42L9pHkmynrp8seG4WRReXeeLd7oaJgQKMoGZKh8lHkvPuze4KrUfaxu0NnBA4JP+96YScRaYjqUkkrREOm1Bcvqrc0hfFRdc2u0ztAoEWnvB9qOhzvzHDdKBI19FMhjjgQLa8V+g9wEYIyIjSQ3bO0lE/NoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIGQHz4cvvxYnF+Z5oey4yYRPdOy5yTHM0ed+T8HzCg=;
 b=DFKis0d6iaEaxrzmQ78z3QBLTy88fskyhMxhjnJsXHTt46iKK0ff6gx3u6SJ4h3+cad9aJXZduNPbbcoVFxNevushMisF2jM2oy2TLqJRlCiiteJ4bWldjp7LIMC8fFX3GvFxZtowF0y13sm09AdaAxT24lYr4uRtesdV/WNYYY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7331.namprd10.prod.outlook.com (2603:10b6:610:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 10:46:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 10:46:20 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: linux-mm@kvack.org, cl@gentwo.org, rientjes@google.com, surenb@google.com,
        harry.yoo@oracle.com, hao.li@linux.dev,
        kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own slab
Date: Sat, 24 Jan 2026 19:46:14 +0900
Message-ID: <20260124104614.9739-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0183.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dbb762e-1bcd-4ca9-a01c-08de5b35cf6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ToUhb5PO5nFVCZqxCoSAg7ZDQecF3R5N96I6Q258FongKp92vX13IFSi48TW?=
 =?us-ascii?Q?K0y5UMtXssASkH7se+ZQ1XemqLwFQzEmtvRuv0P63umUPws8QNeJ2DbKcqPX?=
 =?us-ascii?Q?nOPPaVrXOTJtpRApGDoz20RLOtL8IKad8PaQmpEDSohK9a+KGks3R6mwZR9T?=
 =?us-ascii?Q?pLS2QUi0eku6oPbybwgpwFhOQM1a5469ocUItI07b145q4nhXLj288GeVyHb?=
 =?us-ascii?Q?DP+YNi7IjDW4dm6ZYy4RiNKr5eXeoa48dtnmKAQbt+i/Do2s/I3W/7MgAoBN?=
 =?us-ascii?Q?OFg78S3CPm5m07Z4IwxcdsjYzLBnU9/hU2T139KzN70D0k+sL1svQg1VBBqv?=
 =?us-ascii?Q?3Tsv4nhT29QEtm4eZ9Q7YHCeMoTqzBmw7SPTnSX/ql0muG8pmdwVX+GR6kb5?=
 =?us-ascii?Q?DWxz+CsetbSVK3wsjycLClvJG7RUDJGH7jNXK9pGXqUR9stZehZ7sXayH+E5?=
 =?us-ascii?Q?xDMsDtNTSFybvbuggFYahxkSDljrR/jc1+Ll+K4hzijuUJRIvp8DhYpgPer7?=
 =?us-ascii?Q?klGQkcA27kq7t+HjeRIbE+lBi07crDd7rdbMU72D3RiwkgzmJBCf9Dr4QUlf?=
 =?us-ascii?Q?GVZ/0YNOI/QJlQOnMpzAyWo3FzrzdL4wYVQwyW5UflaA5wl9kXkQ952ZfQx7?=
 =?us-ascii?Q?0IjFU22rprcleBDSzTcHXEIH8sXbEbafwg0K1yIoTryR+aWQR1t3pKgUEaMB?=
 =?us-ascii?Q?H4KpERvuhRrKP6Y0/0IQJCbyJiFHxqwRLCGxhsj+9U36LwKDIklfNY2PNci+?=
 =?us-ascii?Q?XA3JGhdeL1O50L1ODre3dOelb846ZFLXpq2eeReNKTlLRkxMAQc8w25OlSRV?=
 =?us-ascii?Q?1GI653+gXTdpIcfq0llN+rFs+oKKx53uu/+avJHQgLpa2cAeCknJw9qf0rZj?=
 =?us-ascii?Q?4JqPNIyJ25T20y0A/G++PhR8SeKZ81xwtT5S+wgd9QAKeWstHDQkiFIWrGHs?=
 =?us-ascii?Q?8ijcE9QKUCUwrQnNw7tChSv1TDYZslN14OLRQdi2t9U0V3YwvTSD0Mlb1Ih4?=
 =?us-ascii?Q?VBV9OahWtEl/cTe6mXlNy5UE6z+FjZxnCfHTKPXKik2fTSC5v9QVF7A8WMkW?=
 =?us-ascii?Q?ZFSN1HtgCx2LY0NxGovOTGLQRptqC3gZN/oKwxP1sk0xb6/2FcFcnr1q8yr7?=
 =?us-ascii?Q?A1/OMi+QaeXhiSrWmlQPoRQDMNNUv8EJNqC0/XjqkTiKgjXWFiSQ3ytshRzG?=
 =?us-ascii?Q?D6s/07uarIhMbW/WQCgQ3l5lcbwlqqwI+O3UYsNJMQbyZr6q8WGJRNxZqZM0?=
 =?us-ascii?Q?DgaVtz+lKkBfN7Na8x8qsJdOj4HFQxAV8QeV53DMkApMoD6SzdeLuMf4TVqC?=
 =?us-ascii?Q?02INpc7d8nuvZ7ghdh1A4gFsdRdJgZmqcB3kY1+SdtK411bJBH4ieCFAaBnm?=
 =?us-ascii?Q?0xWzLQcsp5bz8ileyggOLOTNwaYwjmDUNh5DiRrewroa9iZypyAyob9aYz4C?=
 =?us-ascii?Q?2hEyV4w9JVIS/mzHg8gOHUzmLPGccQ2g3+cGijlS2x7xFt0FHuIE/f5Yr0FO?=
 =?us-ascii?Q?eOL5u0jBVZBY+XVa7FNEg8l9f03PVHw+pSlY2BPlbFFreR1AeewLReyDMSdx?=
 =?us-ascii?Q?2UJbjwNaldTQUZnAqBB/5fvav7Uq4QVxjdmfn473?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WQE8abW1ruSVCn6KlHaXtE4XS1PDLkrjKdPYSwjqAqjXIec+UdusdO+19lGp?=
 =?us-ascii?Q?jiTIB1CeqOOZDjTUHM/CHyjDhgsJv9EO0h6MrJ6l1I+pAbYZHy2aH+pNroqB?=
 =?us-ascii?Q?tkGq/imQufYsUGemTGVoMquVipodR+kcT10Jkani/bd5r+Ew5zDUVgSMNWVO?=
 =?us-ascii?Q?GpNTN+EkZRiSIYGPvJar3Le9iRqIpoHaXIDfUJ3kiGJuKVtz3H/0Dbh5uqz/?=
 =?us-ascii?Q?Yw0/138SDkcJnXiR8nEhXUPbRbzHBwPvTkWJTorUVRsApeXZSCeAipBdAuj8?=
 =?us-ascii?Q?wgK4PB+HRibpXxTEaaCwTpZ6EUAAcnvBwyze+OW/F2TKGxQ9Id7gtT6dX1oE?=
 =?us-ascii?Q?0JCc0gZ6kRQWbLBxggR5WdIpzr15Tn8qgdFRCH+APyxKbW2F4JhFI+oW33ko?=
 =?us-ascii?Q?hLdDMRiXhhXs/mK0KAAybjiV7SS8i+IyhMURlfTTv1bQHYPaErJo+BbCNPeV?=
 =?us-ascii?Q?XcBCWDRSQzwt3aQq6fSwvsxseNekJjfXI1jlXL3oMBEH+qyDTZXXaoJXIuaM?=
 =?us-ascii?Q?bSf+QNFICmWKFilQx1nM1JLaiQSiYgxki9c6vivnp36UdBufj/DFr5o1a3QE?=
 =?us-ascii?Q?q1U894Ic429qZUh7axdiehDJlwR/ZkXn5+jZth3I5YCTo3+psuM3h6X4/byv?=
 =?us-ascii?Q?gPqWeMF6QHuMl8IgA4Wo2dhE8j8FLNsHC8109Nxt1CHcdzLiJmg+JCAA+FkH?=
 =?us-ascii?Q?X26cr/vgd9DwJMHAyXwZEFo9WHUsmMdM9iJLj+yFIDA0QlDa9x8A5nHkvklQ?=
 =?us-ascii?Q?8QWeE0yToUD1wauWdSNnf/St96lnRV5th4ElccqQQoVw4rhsBVQwelLte7zQ?=
 =?us-ascii?Q?XCswYMoBbM8e/q6RXgtzyvwDbseKwd+Pshr6DLBPHdtB5yNnyEVeQLgv90Xa?=
 =?us-ascii?Q?zSgTZuG/5baHR8IjupaRN2wG72Q3Ug9O9LAlCWEzB9GBNnGddp/KP1ZS8q8z?=
 =?us-ascii?Q?rukAdsPY0jnpYcOiGIKtdY/xuxrvmp8d4q/poyLLHItxFkK7/rPzOoe70rGp?=
 =?us-ascii?Q?5xsu9Au93cREzd/wJAFF8JE/gzMF6XLSbaULxwQcdGHjEbJW8iw6Sxbp68DG?=
 =?us-ascii?Q?qbrjQWoW7wkbBv4PXYcyBAi8y95n9rIPA2Rh2jP6jpD+O2vmFyxAWGvmZbiP?=
 =?us-ascii?Q?COdH7dngq3kTYiHCEqi+4YE4yTPFa/8jeuiRq66PQrh8/nZSNI3u6QHbQ9ls?=
 =?us-ascii?Q?HRcqI5jOEjOGE6iaoYQJHTBxH4k1qMXx/6h3ErxunafQayCHmAdkP9VpWaRS?=
 =?us-ascii?Q?hfadQ7Exso2nAOX1CyaGOKJKrPjt+CQh1L5DhOcWOHSlkwmTQP3uiZaaKceL?=
 =?us-ascii?Q?xezA5Ad2XsSvhdVaDLwd82Qmnx5ErfJQdGwB6ICq3LxTLF/lALDFMdzJLxY6?=
 =?us-ascii?Q?bk5UE3h61uYMeHM/fHKIl+EnemP+SRFRxJBmeEzibjhZxnSKZ10in2Tw7bup?=
 =?us-ascii?Q?Frzor9E94nUCR/0vMZ22Tzm7EjB7l1eIVRvtaVWxMPNiOSzRGqjXnmYN0dJm?=
 =?us-ascii?Q?a9GyV7PQ+PoQS7oy/KpTfG297fMxIChpfC83B9FsIwb/n05q7Ua11c06FohJ?=
 =?us-ascii?Q?bRemMuTHhLUyFUjbTKTp3ST5nBsz4CObhlBkstHnNc6iFiJ8ic4wxn0nwxv5?=
 =?us-ascii?Q?cy3Pnwp9Zz5GMKio+9Mmzla+pmVzb9xZ/id/plZpvT+6tdgzaNqr8wEmBlVT?=
 =?us-ascii?Q?k8/OTu3s/DPWOD0Z8SxWq+Thzkg5Bol5QR8PGw4dWYq8ekagvGp84iMcQ/k7?=
 =?us-ascii?Q?pumf3uIlgQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2+xBElwTKvEbWKjjEset7z09ni9BiJzg4iIWWbWP6yUZL5fqlJzpxCJ5jui+ZgTxO5cHrbpFQmC7Zfa7UyeFSFGkEmTOy2e+gpnydI4Q9xDcgzUhLN8dAo34anpjq0+zNW9ARK4oqLCJHJGlI5H51GlVVFaVTjYqCav9bVEu4CXVOG84/R3agjY9+9AKcBgvB0hrSovsRHdOEnorY3AvudVUXvMIGY3YoX2d2w6RuBQK/T6F0FrgsoBVZbX2X4W8rAD7xNPtMVcp1BMa4aaB90Y0coSxDOk71iEI6VuqKDPxVgizPS3EBoLFX+P85KAxAcHKN/UoqecK0q4FBT+XOLKY+NjeKcBwoOusvBPVRy3U6urXCr56+eyNI9AJeVJPTXT4idKVvWU3s4XjdFL6mv5pQCW5MAmzWuOBYTHNHqCK18ph2Fsc6wbATU25FLaka1pZkXkhRbP7a0NhzPJZmhuwZec4Rfmfr8UK3K2llwVK3tlgMqSxRfuX225duoHYwylGUMoauMfNE2ObsKpVtrU0UGc+ozMP3Di0gOztbAJ4dLHhsP/Ova5eh5kus0MiPmwf2rxh/C/BCy3Qd2a1bCIgFEAmrvel06+xs23O2uM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbb762e-1bcd-4ca9-a01c-08de5b35cf6e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 10:46:20.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXE/1pPUoMdESQnkzFtQ82BMhL9gGBuA4H9NWpfGgKRv3lxtmjKsBaspeqMfv1jfw0qAVgkeiUTPIOieD2+E5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601240085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA4NSBTYWx0ZWRfXymts1lY2PRPg
 8gcQUmFRFruty2KM+chQ6UAbyNEHdXvnOf4nH8JjzUAkSrETZklvu1+q05XMHe6r8VcoMrM028p
 q6qpMgqPJ61zovv1qw+5EGTBKitxuO2J/YgxsZeBrPvta8S9s0r23Q/4CKn53UTrueIcW+nZtoJ
 m7PG6KuNw5mbQmRc5qcfLOZWOlJI0QtBR5TWrpeA4FK8cNHdS9zNPa8EbJ9wvmG07krUlGdsPxs
 SmYYM9zeQvaCJ7LqioXmU/iG81DrmvX/cb/vluaUEpqK9Sh5kg4zgGs8AtZvzoJQ3ezOntghntQ
 kLKjpGJyMEpVxTXsFNVjJ42z+317smrjetn2YeESoX7Q8GhcOoRXN4iWaklq9HZSpt+IbQzerRm
 kQIzS1VyDKOIS1UeGNIYGNgfpMu9tsKaRdhKs1MPXWHUUesLARO1Vo59BHOs1CaEFbpAukXs/Vn
 xrWCQrg/6933rHH2yyg==
X-Proofpoint-GUID: Ktn7bgcgGfmLboufAU-17Ll7qQNt4Ipl
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=6974a305 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=r9yMGVhzXb-e3HBZQ6UA:9
X-Proofpoint-ORIG-GUID: Ktn7bgcgGfmLboufAU-17Ll7qQNt4Ipl
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 484341C0004
X-Stat-Signature: gqb74oi71ytt9wdawx6err5uaw7xuu39
X-Rspam-User: 
X-HE-Tag: 1769251595-142477
X-HE-Meta: U2FsdGVkX195k5hVE0AssQgG+Je1zM97sRzfwWkhXNK1KJNw7nKt1VKjzoZhVZt3JfLavESpRq5hFd//ysYHywhWPnrQPj4lgLGGkDqEO7pBX4CgSmS/5vMGOhJo2CfvRGOInX51KMQCZGf/4zCMU8UjhXb6AbrgZlvfXv1kzjSsPPiMALnB4J9iIjM/i5AII/VkC1jjHtwbK7L7vsBaQDYKhkcbrGLl7usRY+Ic/Hc+SovhT+IT7qeCUwIKUJV/45wfOwEcpAfnLBxCRiguWXrfcXOHEtY66wrkyMx5Q58/KbHIXYnYnHv31X4LtHY96ZdDOdd+DDCbpURy8xuZJ6zuSFicFO1e3UsRO7lWL1VVcedduXIELADzdRLce3zzf+9EQOoihQFSma86bXG/wMe+xp3LhzdetQu3GuvEVxfLs1tPA2IsAcWRgLQHMMVQP3JnJfybPbVR0Avv0wPkQDGApTk1f3N8tfVcP/Y0GfdtQmDpVI81wy1UiaYIoh52xk6EhTr1A9zwyrAAd1/rmjhhTq618rqTOr7aQmMr4oCQ3u9i6xgbFcLaX/EQGIrfuU8lQ0DmaxUKz81zZOO7HVGt5jkekfajftgZWKoBTRa7lwH07mZQdmGJYgtdGJ8awaqrFcyeAqduCRCAPH1X8Pjy12exoJkzp6CadRJWwhX3kRtrvBUZp6IisWxLj5iE3gC5JqjF/dAa3Skmdgj2qeIF8CMFTsm2CiyXNuYZM6irOucV/bTxUJf5FCHsNb3mOd5ei1Hs5uU4wpjyS1miZhr1+Xi8PlkmpFJirBr3O30XCDdZOQ3ZEL4oP9YvaT/EP00523GLLCK8IOdg8Vj/vzKbAC8OIDKDfpqDqRaG0kAmhS97hV3aV26XZYUUpUvALMb+aNZHdEitKCBrieESWLobBuxC/E+d27ur3T9qBTvbo48LACmvzCTa1uypYel8gIjKsi4HjKZdroj/16G
 G9r01orq
 5MVp6f98QaMRWQyyEknGXcoYF700jY2rR+4jKVSUX37xKKHNygFvaAFUkexn/f4UGfY9nF4yPgmhmswHlW9AR9vTHRRRAN5BeVbckIebrBkNUnDD5/4GG60izXLBqjkgdR5jSYVpWcs+MQgEpimKYJk+Q4goceg1zZSpn9DwFrhfGLJC0hSP64e1OxN34DWjZ0AZEFK/2fti7vcif3fGd21TommAFmXdUrI3AsEhYGSCuUXO/xEMAerOdhxhL7TDChBOwP6fR0C7csjk32T1buLfyDqDUvGvfYqtomLE7SC6HMywnhjWI5kxEYMIKibvYsJnqdNR3fqxuolzbs1GE9pr6aa2iOOi1g5hPm+S6SCFlXA38O2fR34rbLdsetRfjH3ocF9EgRHXI13OEZ3tTjWilOwxtrx+nnrnQJfU1ElouN9iBOoP4nMtO1p9wHpvG7Jx3AwSVjClJZ+02ugqgIXUOc7Rac0nS7713fu/KPzChmGgtl+MkpEYPCmhhgVObfrsBYmBBkXoT8qN0HcjrD7AnB6BgfvIoUeLgqTbE5kdq3pp+u38An/ujD4GN4+1n2tT3pnX9+LMxlZn5yggIQLGWEWIWhW9jI10kUQBQvVVAhwGicAC5nTixNPeD3G4gs9QkI9B7MwhMB/ou+2Levt4Q+frZBfV4vrxJhm+6HNo8bJ+SX+Li7/94iDmK0mDg6ATx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
can be allocated from the same slab we're allocating the array for.
This led to obj_exts_in_slab() incorrectly returning true [1],
although the array is not allocated from wasted space of the slab.

Vlastimil Babka observed that this problem should be fixed even when
ignoring its incompatibility with obj_exts_in_slab(), because it creates
slabs that are never freed as there is always at least one allocated
object.

To avoid this, use the next kmalloc size or large kmalloc when
kmalloc_slab() returns the same cache we're allocating the array for.

In case of random kmalloc caches, there are multiple kmalloc caches for
the same size and the cache is selected based on the caller address.
Because it is fragile to ensure the same caller address is passed to
kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), fall back
to (s->object_size + 1) when the sizes are equal.

Note that this doesn't happen when memory allocation profiling is
disabled, as when the allocation of the array is triggered by memory
cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
Cc: stable@vger.kernel.org
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3ff1c475b0f1..43ddb96c4081 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2104,6 +2104,52 @@ static inline void init_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Calculate the allocation size for slabobj_ext array.
+ *
+ * When memory allocation profiling is enabled, the obj_exts array
+ * could be allocated from the same slab cache it's being allocated for.
+ * This would prevent the slab from ever being freed because it would
+ * always contain at least one allocated object (its own obj_exts array).
+ *
+ * To avoid this, increase the allocation size when we detect the array
+ * would come from the same cache, forcing it to use a different cache.
+ */
+static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
+					 struct slab *slab, gfp_t gfp)
+{
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	struct kmem_cache *obj_exts_cache;
+
+	/*
+	 * slabobj_ext array for KMALLOC_CGROUP allocations
+	 * are served from KMALLOC_NORMAL caches.
+	 */
+	if (!mem_alloc_profiling_enabled())
+		return sz;
+
+	if (sz > KMALLOC_MAX_CACHE_SIZE)
+		return sz;
+
+	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
+	if (s == obj_exts_cache)
+		return obj_exts_cache->object_size + 1;
+
+	/*
+	 * Random kmalloc caches have multiple caches per size, and the cache
+	 * is selected by the caller address. Since caller address may differ
+	 * between kmalloc_slab() and actual allocation, bump size when both
+	 * are normal kmalloc caches of same size.
+	 */
+	if (IS_ENABLED(CONFIG_RANDOM_KMALLOC_CACHES) &&
+			is_kmalloc_normal(s) &&
+			is_kmalloc_normal(obj_exts_cache) &&
+			(s->object_size == obj_exts_cache->object_size))
+		return obj_exts_cache->object_size + 1;
+
+	return sz;
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2112,26 +2158,26 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
+	size_t sz;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 
+	sz = obj_exts_alloc_size(s, slab, gfp);
+
 	/*
 	 * Note that allow_spin may be false during early boot and its
 	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
 	 * architectures with cmpxchg16b, early obj_exts will be missing for
 	 * very early allocations on those.
 	 */
-	if (unlikely(!allow_spin)) {
-		size_t sz = objects * sizeof(struct slabobj_ext);
-
+	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
-	} else {
-		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
-				   slab_nid(slab));
-	}
+	else
+		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+
 	if (!vec) {
 		/*
 		 * Try to mark vectors which failed to allocate.
@@ -2145,6 +2191,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
+	VM_WARN_ON_ONCE(virt_to_slab(vec)->slab_cache == s);
+
 	new_exts = (unsigned long)vec;
 	if (unlikely(!allow_spin))
 		new_exts |= OBJEXTS_NOSPIN_ALLOC;
-- 
2.43.0



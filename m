Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07114CFC504
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643FE6B0089; Fri, 21 Nov 2025 15:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB746B0093; Fri, 21 Nov 2025 15:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FEC6B0089; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 944A16B0098
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E7DE1DF33E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:31 +0000 (UTC)
X-FDA: 84135741942.05.8B8C95B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id E430BC0003
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Spv76U23;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SbIxR6MN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ip23kfzOxDbJW0mpobiucf6pAsOVNIJD0dc5RTfTj8k=;
	b=YM/qIcbMe5EFiboY/ZQSzVYzlWFwQvrMmcqPWf713TJornMgO0maZ3VibXGdshtUdSgLle
	xRKqvYyVaWoAapBBG7jADv9lbfgYAAPyOdbTv97eEysJ476eTNRbkpDC+LVitW96lilasA
	kY+5EA4y16Cjf8eJmpJojnoUlfFKuAI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756668; a=rsa-sha256;
	cv=pass;
	b=iGbya8F+A6sxSse8xChKKat98HO//j977jqg+046SStP8WPJBhstDzRU7Yhh9vz3ieVJ+k
	D34uM+aXGFQ35db38OKj4S3JEbjJxI/03lgjcQLInv120PyXMl8FAZZtFgWo6ot9d/9LTA
	JDvVof9XDMmylF/R1L+LjDRvLQaCrg0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Spv76U23;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SbIxR6MN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEgmL1009398;
	Fri, 21 Nov 2025 20:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ip23kfzOxDbJW0mpobiucf6pAsOVNIJD0dc5RTfTj8k=; b=
	Spv76U23ueVtfkN+UGjz7I4qHYVapv/PzlM8CJdXXn35ZP7AWB2bxeA8UwRy7fKB
	4Dv3mqlirqehSX91ncOkSy7D6t6B+ugWdaznBp3MwN/f927Wsn6ZqcnynlkyM9HW
	GFfLRvC+ycMXx4J+sxJqVN0b1v3M32Sf49fA3kVFtwYjG/TEPO3zhGRiygOBvEq8
	ROWukHlxGRAYziWIIHRYq8Gjenn8a7Jr0WynVZannK6jiHmAf4a1bVCzEEwtLekY
	loHMZw5DVYD9vLwkE+3VSMXJNuIzzk4mp7YpxI2USF122HjxbnMH4HJkM/8E0Afb
	LOx9WrKGWZ+ku1Phv2vWoQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1md0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJY0Mo004449;
	Fri, 21 Nov 2025 20:24:08 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefydufpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IcOzHpeMyM/QtE5Unlhp02KDo1VmtV5m2qaKD6gI3elbFtGyTmhS/IMTb9ofjmiyBjZ2LBy7SGMOwFqjU4X6pMoJgeHb5XGn0lEHN+dgJriAYrONAhE8H5BkNrT+xDJuFBkKG/NUEinBARAPAX5tKUHX8YL64vU4S9dPN257MXU/OLAYc5vERgwXPbfZp92mTnh9Lnbb5xG1x7kUKS32dIRGDzo46FYWCpovnpEOQSexDSg+0MZrr/Yy8YMuCDcGpRWdvrb3/6d1n9tJy5ird6EuW21sWOKy5KCiVnx0VvUjQF0esqLGAHaMIJUtSPgb40jDQlL6oeb6eb7QfgCEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip23kfzOxDbJW0mpobiucf6pAsOVNIJD0dc5RTfTj8k=;
 b=J7+6De+xWUT3il0tKagE9ukF/0nVtqiEPWQxZsi7B4p5GTMCCjIwZmjnjC7yPhSnuCCTitUHoIgInCVyPZQ78tgSj4/q8Yw25UW6cUtBfCmupvVLO0KAzvEuE3yhHuwr2jFoMpP5I+/SMAl8/r1/RMIjd588ZPlnqvPMfoL2v4izWUaUg9y1ok7WfgM09m8rTUWNFrG4wBcnyOrb5AhJVDNSPQMXO2ETkTBsPdGDurIrgFiN54X+KhK8fEXeBHyp6/lsIFdI1Ena5DDN0XAPTMd9HVVLc7QC+uCs9wSQb1uWOelPKMgwgzJfRzsgWIhpw83NZgJYZ7IA0jmUEkbQAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip23kfzOxDbJW0mpobiucf6pAsOVNIJD0dc5RTfTj8k=;
 b=SbIxR6MNple4nHCOp8E1RdUxjsFV7AkM9Zud5PL5WrtMQvGh9dP03sHYlZ3ipin/82boWqqNFXMCrJvNDibdY6HqUyAB0U5NPPYz+wTFZVqQEfQ6Y3n3rv5lYeHe6nGzeJShRQJaZBOFpq6fiYJ1xpmWjOPsuZt+QKH60NYEdP4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:24:01 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:24:01 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 3/7] mm/highmem: introduce clear_user_highpages()
Date: Fri, 21 Nov 2025 12:23:48 -0800
Message-Id: <20251121202352.494700-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b04b722-6995-4464-ced7-08de293be856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RNdWkw348EYtupRE2gwROiO2/KdgcbwD1w6lYdsNO7m3HRhtd/Je71JX2pzq?=
 =?us-ascii?Q?5gZfGiQlBEWujwKJ5oGPS0C4U+Xh3dmXES8kRYRmM9nvfGdznv2qhzTPs9zZ?=
 =?us-ascii?Q?Yo6YDwh7QD0s3EuCkX1CbcLTAu4kdfv1Ny3AkFgE2P3Vw5C5Knpcf/OSlUUB?=
 =?us-ascii?Q?PGd8kSWnqL0d0YRqUDFm6cVBQ83m5WpNXVfDbYD2gurNJep+NtTwNGjSoVpw?=
 =?us-ascii?Q?y16q5cZCckpRxW6R/gRUhRbdGLOMOPAuIh9C/YzsNBj/aYh4LGQ6BUxJw1cO?=
 =?us-ascii?Q?/QAmjOZd10bi2BK3b5JPLIX+ut9MuFBVx2PP7AAm6fV0FrVFYE+IhXAEM8h3?=
 =?us-ascii?Q?QaW7CutZknsWdejW4WsJ4Da8Eh38zpN8DCr/UtTckD2lH3eEyKydNWST2cI+?=
 =?us-ascii?Q?qKFiUfce9j0lSipEaUkSybQOlOBTvePshF/itWF8NqNJOS/wmAcOP2a8s5qU?=
 =?us-ascii?Q?u6LlPCLJ7n/oVr21LhANRD7BNgKpgwedgd/KbwHSrVtN2cz7yFOiLDxcWZ+q?=
 =?us-ascii?Q?HTHcxvZRugQKvesEVFfkFHbAjjejIqzm5Db0bmheNaaLVpfMf8/N9jcfQH/m?=
 =?us-ascii?Q?5EOoEfD6X7sEfaE+UVd7tBXnIYf8ecEj3QLbIAamyRuvJ+fEMNsBj1vF52YN?=
 =?us-ascii?Q?/alaANL2s5hkyIZlb/fNuWCYfhDZJY9jJdjhkmdAzBqr5ITfJBYjAd+IAqgA?=
 =?us-ascii?Q?02Qx//jLuW/TtlscESa+cWY8ci9gsfz94kiFb2O4Ae5Q6dZtvJrm9MOi00dA?=
 =?us-ascii?Q?dqFc4FIdieh2VgJZoSN4tn6aAVc7ncuG6sgA2cYYbOzeDqntcuN5rguvkpQm?=
 =?us-ascii?Q?zFiJ6n7whVrF+TTk4VcfL1SCd0EslP+UsKilBHLIVWKqurDADCMa8Wh8MRyW?=
 =?us-ascii?Q?40+T8X4tL2wG7HfU6SlKme8fkr+AZh2CngNc5vzRnrM5MWBkiLJMxiKMNX2G?=
 =?us-ascii?Q?zmn1EarCnDCYhPsuX37nPcj3AeRQk/PS/3Y9onoOJTKseqvdjFchAPKLkiQJ?=
 =?us-ascii?Q?MvyXEIcBOWCbQ/MD16YMJESkmqCE0b54t5Fubo7XBC5Y6/2UwGobS6z4fm32?=
 =?us-ascii?Q?inBfMrBVIrESvE0xYMvD3iC/ncNThFHiic/5kS1SHR5AHRolmJeYYOtvzm98?=
 =?us-ascii?Q?NGS83xR/IqH8o22SLd5ccrGMwDH14bIWs06jcdZbL0ELMI++i7jRyp40DBB5?=
 =?us-ascii?Q?ABx0Wa8UCymn4rKVzGm5d97btc9QLD0tXTP00UmmnMbnW61N5qutGX3KaRlv?=
 =?us-ascii?Q?gBtVaF/SWse4YKAyEh6/KTMLwazuv6lGOrbbo1oTqMQusaXK32nzFKAtpZBP?=
 =?us-ascii?Q?2QMCK0tP45+JqrkY1WR6K2dwrXtXo0UO/kWZRY9E4PnJpc0fwftTIzkdLXkh?=
 =?us-ascii?Q?l6O2KRVdI2LBqM7vWmcs+ub2PHXumA06BQG2USiEcZg1Kyv6VNPzSx474p84?=
 =?us-ascii?Q?pJl+dhVWWfxK7Ere0PT/01vCBX2ZexU+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqCvoNfnhBPztSNEPuZoC226Dlzdta0pLOlPchQGL+QOKOUiRdmYLePL/dbN?=
 =?us-ascii?Q?GaCdKPwnZgzSqp45f9RmI2R3mvoMLJb69NMRvTmW5y4/yfDvx1CAg7yFP23W?=
 =?us-ascii?Q?UrOIAJthdTlc4wwQ3BG4kQ5KfOqWGrWBE7eSE4zZBxak2i4t5B2GMdMTVSsW?=
 =?us-ascii?Q?Q93TVLnmkVGL9tch5DoDh1k46gl3QY7ZyX7NoNDYQNUHgIBfVOV/SC3x1WEo?=
 =?us-ascii?Q?/R3ypUhep26mzm30T1PAoV+mwF8pF1VuOuQLFo4Kscrgr8VGz273lThevSGv?=
 =?us-ascii?Q?FBEojDNrVJZlb1JTVAtxU51sIsXGPYDGRmKRZqGk2UB8C0VQN5grcNTHKN2A?=
 =?us-ascii?Q?nWx+3l/K9P/sRZoCxxAyujuC+6MJ0Uy+Im6pS0uD/j+UFupJAw5tWUOg85K5?=
 =?us-ascii?Q?HzJS05cNI1kus+0RCXrwFRFRGKKxORoFmJoyWfNzGmkZkjlTUNYQhWWKA4lZ?=
 =?us-ascii?Q?vmuLyGurg+92aq5cS1xbyblE4snQ1+IIvrysLI3160Ewgcdxm4gs+OntMi2D?=
 =?us-ascii?Q?vCvu3gH43pVJUINN7bisICW3rbJZrJaXT9rO/izE6g5OHF6m0SefwiJ3UUlZ?=
 =?us-ascii?Q?KmHtcd7omisI3OZHQ++qxxYufeixe4PI6vSmuSUamNLyMOmdn77Ry3semy6T?=
 =?us-ascii?Q?cnCOFY4CiUDREzhWE6Z8npvEANBEffZv5+s7fyzQsUgsOSM85PAj4HPvewgc?=
 =?us-ascii?Q?xmSk6UTG+YEL1XljILUk7M8A4lnwXU2awIMVPp3nifTtm89eGkLVnCay4iov?=
 =?us-ascii?Q?pp00RiTcwhsZwF16zJHsm/cyD8FvD+0MsEqqC9dvEEXGtUKbjlO6fqWJkqTF?=
 =?us-ascii?Q?SagnoE1Tp4UqGslu5a1gnYv52E67gy8ozRE3ydwhM8Y629D7GJ6ODvtFrLdt?=
 =?us-ascii?Q?fl02+y8Yy9gTAM2POMOPllHQcNhBn5ijqMeLZc3nOF37xyoKSkkRqJZGKIol?=
 =?us-ascii?Q?xiTi8SlUTxKfzMrw2o0xtIQ1ukHLP1mGSPOV/BQL4vyS8ezd6KE4/2d7y/fP?=
 =?us-ascii?Q?D6IEPMoGmDNoEjDJEEHFR5PTURL/Glt07iHsT2JPTCH4xaQpcVGBIRn9DjRi?=
 =?us-ascii?Q?0R7oLlCST7kJyoJ9XKWEmQFt4bBLCG7ihGCx083796zNcFU4/Wc+/y/HVqcs?=
 =?us-ascii?Q?RWIpVp7hhHStkuJuM7XWlgI5OzXyWtxyFJLrh21GMtsWAgsVTetTBPbap2IS?=
 =?us-ascii?Q?dRKZWiUmqzYoVGq/abL7wkcMvEO+mxU1kuoeUfL39M6EEBb3PpTmRIkj94yf?=
 =?us-ascii?Q?Tpgm1fAVmuUFrlkMt6zC4rLlui0fWyYwka2ed3BQqx2pp/nl7zpWjIvSd1n8?=
 =?us-ascii?Q?kQ8M0GNPuouj+3JiNiGSeJVYGZ97hJeegXI/aWBe220suxbosciBAMmeqe11?=
 =?us-ascii?Q?MBY5S2nw090aYmFuMsfSd8AMMlw6U+E3NdG/HevE84B0NR2Y5o2qqsJjRYHW?=
 =?us-ascii?Q?O+1vSsE6YcE/R9fT5DJugA9gLgFwHWAZpJYJfpbQtKDYJK1YDqkH1vZUgPtM?=
 =?us-ascii?Q?MaL9F6v3Fk8PZGQZMDnLPW5SA1PVUSRamzlvTViouMYXD7cnweVsgtf66DFe?=
 =?us-ascii?Q?Nee/ghOpwrEHPYM1MdRDz3vk8LMsTzpMMgfAsbLKfWP483zmQc1lPQYA91xW?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TfWam+wsbSPOLWOnyvde0KGEQ+/0TyymWHbkJMsyJQDqDq4X68oC+/iaDSTKnCVVUYxdgcLCQpQnQInfGMx8EZ4cRHLU5SZaI2weHhIL+/kp+ScnRcS5y5Z7YfIhvgeh5aXKQV8T/AesAm3qfO1gMd5ppq5f2VM3sTUYbir1mouAsbdVC5CQsJ5Mdc7GchPkkmIdoFJ7vyHzRgIiK9NL0u5zoO4wLQQaVu8pE9O5eingkF4yfngHRONOmufVBRZp4IkAJB1igvyjzuczToZTZDh3S17sJFtqwSlHroJiQuojNLn3/+iL53W9NFJcH0QyybJ3PVl+RXi+QRQFYye2jz1i6kY2xQPeXPxYeq1vzRN3JrFw6UPljFbcyXnBoQehkzK2RkTiOOtaT8SnQouYrGhXmhNq1lT5UnVRxZtsB08X++dhDFxURY4fz43Km+1A1/m5/ibbvhb6UQRLqSFlmkjPRPkhbh2sv6DTj7NSY/g3AyHxF7fmZokcB9W62oqmEpTQ38OGOGBPowolBqgAWHyr25Y1DKh3g8IUVMeksy5yT3ZkpWiJfY6rIyEAw5z2dJldV3H/z0WlWYjMeJ96jhUV46QKTOrEg/Z+uUQYH0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b04b722-6995-4464-ced7-08de293be856
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:24:01.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtoTFE1Yp96pgepx1D52jBDTgPj+on7RU+Uvf0Z40Y4lnoaU9y28PnVjpbI0hnztD3kQXX+V/lJI/VeNndoactc80jM8tJGr4EqzxYAbEbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210155
X-Proofpoint-GUID: zcYuEvCrBVTPoLB5kw-ivDx37lph-NnH
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=6920ca69 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=d0Ruhql17P3IiE_7rwkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXzV90tZr2ggLz
 UWEecukV9UH4T5LDdWRjbxU38EuUKK0OxTJzX2GJwbdnoDEKBEQLfsLxBqBInBPiX+uPY4fRA6R
 fqyIZbqXXB4B3652DeYcN85VlkvUt4xqtEClVTRIc2oEa/EDgwgjwa2hMRo01ZVwjYu5Fl1DFQf
 Nbjnz0iINNIRFlKdB058kq7Ohij+Ekc+YZaTi8CQ5tEY56cNwp66rsTTmMiSJIN+YfB0LhN5hU8
 wmi6Mn8iuuIfn3nMlTAE7IW8jRmDOGbsyUMnYzuAw4exny9BQFvYr9GoaGmRQ9bgccjcmkw7sR7
 TaonERpUYlrwND1+NQL+QKrz0aLWICvO2LjV7nTTyAML+funMeh1RDjG9i+4EQldiAsFwXA7uA4
 eu+QAawl8zSUYw377aDEFi/CdECUZA==
X-Proofpoint-ORIG-GUID: zcYuEvCrBVTPoLB5kw-ivDx37lph-NnH
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E430BC0003
X-Stat-Signature: 5ahrgo7yzrpqbry5ag7on7ffm13j3c1b
X-HE-Tag: 1763756667-15573
X-HE-Meta: U2FsdGVkX194yFCqD/vGmOlXm3/nEaG7eHrPpHDEu3Mmk53o6hgpDEN0RBmtf674yMbgBKdChVXifrlG3dj/+O5usos3y4OSNKbgH1YJCKmqTLnwdnJn/Djr32ES4LXJnrdFnvC4+93xtd+LF+YnmfDrh2YYSCxZWzdJBA/8COuFR/TI6kdUcj+5GYEhVRDgDv38yBSYK3nGMXr+J4insmVRfMhYaNxycyl+yECRZMWWAqeTJejcQ1U0jBWlxrWrVlp8P4EcoxS6IllQ1m/AAIRzeCpySrnBcnN0Xp263hjMvdiDXvIZXEqg5jMsfQUBmvZ6ict13QkcPjE6f40vSSrdLk75IN8H4se2gEoNH+RRPLuHkHn6TsBkZtFgwBzklbUWu+cg6RPak6kog/LtY+rTQoKSTrmCjfYMttJFK8/5hEZeZRrEXw5i5QixiEVFcQ2RHqDcU3gaFqXXvlAc5R246bVyiQ7PFTISf0VRoxJdcTIjbVUgIZ7+FchJJvdOUMGCw7HGVh9loy9lgQ3PVJiGW3Roepe9a4nJ/JOS4bcr3W4cqXYRIbDhv8IPCH6TgiWELOJVQfKOHcDdcZHgK2zcCgfyq5eES3dPDA7+eb0HNPaOcvnl8XA5LcvezwPxMFHQOnOree0o2nd/02/MqEWfnfMujbteQhw6whi4CSV5ptH2A7jRCQTEDzxGQ2vk8EwYJuhJvctE/mTZjrvazsNsIFaD3MrMvI7hjLSNsFL4/WH1j1YLxfeeXnOfswWBgfY4c7rYiv4hX1D+a4M8qlkjYgGmi3GQSqkCI6sv2yRi67Z0Gu46EWYeDX7J3XTu2lQ10pETu0F3r7J29CtoW4AJgJFtXsGD8/hfiQN8ZEya7sVqCTdOM/CoQopNEDUVlMCXqIDBGEAsVCu/IAqv+dn0GvqqoJ/sCUxPpUaKwj4pxUjNGOHL9nrigxDx1nr0bRXngPQHM0hkFYKmvEL
 4KRxRu+T
 Jz+jPHTrijeRWvvrOhC/HYHRjb2tchqlwcGHg77yE9KT2J9iTfo4P8ThF84h5E3OI/MFcMVBFmJ3utk0YbzxR+O1JhunbJ43nVXCCNRMytoIf780RDH7NXsiiqTHxaCQjkcEh8YoiFM+Qw2m8iQev8orEY/0rLlpoLBailTMQoDBHuRl36O4dWM3Q1tkc8PHagrGdYenxY0zIRaJuvBCIu4ZWtKuEheTWpoJ28mWCGVijumj6urdhMeYycELPmJ+NowGcONglsQcjfr8hQqcvsHBFSOXjfMRfM2+LOhUcz9scgYuQZHZgEfrRM5PdoU1lc+hunc+ryVZq4DtizIN7aBU5sYKyIJoej4WKs+mxbLd1bs9As185bSIJGmaVroKFZ9ypoNk0BGvZGvz6FUrTUGw/fwK6yV0LMt2hP6xsKffXVNLL1B24R12SJwKs4ksWetU3EJujidWcyt+fp7H0cJji+VL+vm3YfqiCLcabt+a2p7KiZKUyHCAH0fguN8NintgBWBWok9tTxY/P0H1DIlI3ZA9uoLD8SZOdEKfdo7DmPiCyjoEyuijUkYJUZoBrg7q5W9vQUzNPulajOoxElBGrFbt2otit8xJrGFmjmhTAq5gS4Q4FuIXfrREAUrO+hWXrAp01zloId4DsIGAhHkvNMHmbi/WBprhQY6I5IPJYD6PFOEsI7ZLhZSssOPaw23GKrBlt67JZX+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define clear_user_highpages() which clears pages sequentially using
the single page variant.

With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
primitive clear_user_pages().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/highmem.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index abc20f9810fd..c7ca88ce9937 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -199,6 +199,11 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
+/**
+ * clear_user_highpage() - clear a page to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
@@ -207,6 +212,30 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 }
 #endif
 
+/**
+ * clear_user_highpages() - clear a page range to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ * @npages: number of pages
+ *
+ * Assumes that all the pages in the region (@page, +@npages) are valid
+ * so this does no exception handling.
+ */
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_user_pages(page_address(page), vaddr, page, npages);
+		return;
+	}
+
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
-- 
2.31.1



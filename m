Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB5DCF6BF0
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A996B0092; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE04C6B0096; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B966B0092; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942406B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27DFCC0856
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:52 +0000 (UTC)
X-FDA: 84304320744.15.3543163
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id C857120003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pNwldVXq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zoraxUI5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770448; a=rsa-sha256;
	cv=pass;
	b=EWjI6zMlDGmcoZ5EpF0qSxz21vuH4WJdXNkE3b+c23o/kmGna3j5hD1Bx60/k0PIxgZ2W0
	AhvzQzR10dBw95EMjE19XrR2XwJ8zy65UNFFIXngGpHgw/2tiIqB+3IvAhg5vbpnjfgJxj
	+zN6vsAFN10ExkCTkTYManNF2+kcj9Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pNwldVXq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zoraxUI5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTECbSgidN4ybcP0pKoxlI/lQimYMRbohG8r48YcHTI=;
	b=1REt9FUG8RsBwMk9GDbHLlFfewaKP6ZrdF9IsHhBy4sDWL5pFpIoWbTfxElnU2bln+CbI3
	7j+gPgSa5vLyE2PdSo1c3PN0jvE9V24CZvDB6pnH+w+N1B3VKD7OSeAYGJpgdiLR+Ka1kz
	7qH8URtTkf/pOtHr+LtGrPIGyTiBfQg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6077AN4J1392572;
	Wed, 7 Jan 2026 07:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aTECbSgidN4ybcP0pKoxlI/lQimYMRbohG8r48YcHTI=; b=
	pNwldVXqP5WcINKBWDDvLJi/jBQD//4pgiMn2vOzDkmAvASG10Me7siTHRweQRXu
	6wGJwRO+dAz+q9HfDiq2jgRjSIaKW/buaiAin4bdTrJMGGVzoeeH+y+6hGTkEyFn
	JIhdYgfLDzmhcU2AOB7T7HTL7bJdvVc3Xof4x5AFV5MX6l+aEdWRVp4Og+mtbHBl
	xWnKnTbcfVyvzv9XUdjIsQQbK+JZzQequNcGlLDqH0OB4TUPlLAneeZeVcdtP8ZY
	pdx7mb3eL89lhbNiJzYYwrFBDEcUVyUTfPXbPkqGCP4Okevf4yAe0DEtegZbQD1C
	77juBjfRAwyx0Nf+g5Er5w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhjv78084-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607517PB027437;
	Wed, 7 Jan 2026 07:20:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj999kc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CCaNKLjERuv898OEikxTHC7NsE5B8+bPMH0w1ck6uUlK1Jd2ABkidNOVfMghb02+PQss1+KO6ln8jyiDLFcE58A98pen6ovlnt7yC3qabHGKa94wiwI01EBJbUBNxDAn69/ABHq0kmtrJETEjZ6HhAjjxBVt9nutcNwLch0jEP4vV/Zrf+lh3OxveNoU7PeP9qGy2h89v/Ob+qZoMG096A4F18m13HaZUWSoLQU9LPLwWuoAMEBZcwWhWcf99xA0cek4ITf0ezyKiPJGmYK2gZhDJJsav4h3RneYVBrHvbtvP+DczK1Hyds4PNN5vVrDH4hVPpceWDVYZVURyuZCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTECbSgidN4ybcP0pKoxlI/lQimYMRbohG8r48YcHTI=;
 b=zVWTXxwGHXp9kakUCvu5eJ6T+nVL3VKOgsel9QPR43rsENNgDMNqkYSIvm5cDcc0LUCDNx/SSdcxp5KqJbdNsk9ZFj5seUuMowUmG+9wxdxoiM31NCavOEJOAtIXlmhQM98qGFoXBnzuzj7z2TXz40taF/iegerTqQCaEHE/YBYWXV3xfmhzV/4ice1XZ4ojsGU/XYVkTZJYCrwvTUXHdPvx57jB4tHs2rKDFBgSitT0yRKYeTIL0ckx7Vc46NJ0rgPzYx7xl+LcjGBf263XBf3j2r+rd8TlLVGCfXglTNtnyDWcBmDsD+OKd78gvgqidkt1TlMIhVxa6RuecUKxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTECbSgidN4ybcP0pKoxlI/lQimYMRbohG8r48YcHTI=;
 b=zoraxUI5KRjPv1uiv9nZf8BrzTRSIIZH6xgmPM+veQ9gDMO/4syaeT36yder4Uc6cMqvF062mtTE45KaoYWdmmybLsrnpvXOkU+wHOACks3o7QodVOpwV/d5K5E2vXXIPu8zw4mg49B/U9RqrjAX2I6aZJOP+ksDT1v9Sc1TPRw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:15 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:15 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 2/8] mm: introduce clear_pages() and clear_user_pages()
Date: Tue,  6 Jan 2026 23:20:03 -0800
Message-Id: <20260107072009.1615991-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0014.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d561d42-af28-42a3-5e2b-08de4dbd3420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ApvSLdrl48qibH7pIcZwCHO0pFaogrQaa6ivSC+6dM+S9zt9rwjafN4TTc+v?=
 =?us-ascii?Q?/w6x1fd5HcP3uaLtmEUUKznMvK6r4jmdZW3UVegFMwv2uXS/IVPD4XtRalZd?=
 =?us-ascii?Q?AmMQ0EmXAonTL5LQHOqY1hqe8UtsNsIFYa6JBXkyoIJnnMrcb/z/8AkBtpad?=
 =?us-ascii?Q?A/i1ZeE9gBgLLfDGakaR02Y+JZLDXyDAqEsFYXBK44OdkgCdVEhVjbDKjGtf?=
 =?us-ascii?Q?jZ1FQPs4TtcKvZsKlq2RuFZvy073cInMMHhV/1gWJrsrVJgCy26p8IGkswF1?=
 =?us-ascii?Q?J8uq44UrN+hyCuVOLiyF0lzmzfUCsEXDXJDIpuqpEuecJMqVif0zoNAI/AJ1?=
 =?us-ascii?Q?dF//lcqdfEU1hs8tPwM55XizzS1ZBWiSwD3Ie8HQr1qFaozRxn5GYIx1AVVn?=
 =?us-ascii?Q?TwuWw86W3d3gRtEwL0HbTSXPP0+Iw4HBrgjmqvT2tbetM47BIlHQdFuqx29W?=
 =?us-ascii?Q?xwIDcGf9CTP5ETOiYxAKet+ubJo04hyRUWRCcrRFvLiPNDiIneN9JHkw683Z?=
 =?us-ascii?Q?6YerKcG/Udi/j8Lv4YdLWcskSnoKmZZ09gCoxVkHEMk44RXeE7vbsBKER7hi?=
 =?us-ascii?Q?BhxH2CRK1Ir9MFx0mjL8MwhLWWg7EFUQPPO7bxkAqb7zDvvO5J/oalbtdoKl?=
 =?us-ascii?Q?Ib2B1gWT8nsZLjK2vN9rXhukcFO0IIk3EhKnNZoLVsolPrV4ap0cavvD4Aji?=
 =?us-ascii?Q?Dl2KKYrEVBR4RHrOCqLLjjCOdflFY50ragSETLZqqG6ipTmv7NdHxSB3Bm9I?=
 =?us-ascii?Q?e2goPlpdCE4CdUfmBePDcBF14kFv66SiYlbnJue12K4zrz7mw0Z9+Otux8Uq?=
 =?us-ascii?Q?hS2AVbr1cQQw+B3mUJrBvio3FpBGXUxfib1jo29MwGD0h/aNmDS31aWLt4Ls?=
 =?us-ascii?Q?pS2by3hSh9S0L/jWtY6t9nnXSvsV63paxDzghm5HOftOvNSrrunUM2QiPvd1?=
 =?us-ascii?Q?9q83lYlXLf2n0vZTYsBdbrBjXFd5BdYmN14wi5xoH+JjBxk2tpCAkXs5/rD2?=
 =?us-ascii?Q?qXE22lOozkde9AdWhem9Hq+y1UaHV2IdHNGbOXNhiiRxpbyn1v6hcvPoXRoj?=
 =?us-ascii?Q?h6sCX3ktyAZJuOLtgw5Ulx/Wjnv8BDlheDLRmOGr1xjuSRjUT8TiHJU482Ra?=
 =?us-ascii?Q?4QIBsalmVhcjTHbaedqbKMFczETMUPhcKcngpC72Wd3kbN/H3iOdNiVqMVBK?=
 =?us-ascii?Q?Hsmjl17sE1NORPevTVkwRTLLQSpC5iqBpZ7HofBDUpzXProaFTmaexpYNRKy?=
 =?us-ascii?Q?VOcig0hPORi7rjapUYtcJIYC3pLHukOOzclLFmm0xS3dtsGsZcHzSXCAPc9h?=
 =?us-ascii?Q?+2d3PiJLGot7PrNtDm7D/uajD03NunaxWFoJNJwOPGy8HghW7ioOJQOuVim4?=
 =?us-ascii?Q?P4cRf5Zdm+44U//RHoya2I5UucyrpnTqmGNLp93cdVXbU/8EcmSExBTjZ+WV?=
 =?us-ascii?Q?LCLX2nEBIJih4TqEdTBD91lLWYIgb2nK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t9j6TOPwDlep3mly7bDOGgRsg/GVtcN1BZrwNkPfwFEvkbkZyiI3q75XbsZ3?=
 =?us-ascii?Q?DEaad8pZvI1enwOFzzpJOanfxIoMVlsHyGDMogFc40hfqWmki1avw3hGKLMa?=
 =?us-ascii?Q?i4K8WZ8WreHrAfou6Jp8WWWl+EeDc8v94ev2RocykDfQbMUSd+L/kMtxx1bV?=
 =?us-ascii?Q?GWImO6ksgM5XldA9ryOV4NLtx/6zCKkPMByjjl5cECJiRq5Fzt9OFCAj2Gqi?=
 =?us-ascii?Q?O0twnf+rKzF41NxU3+joAv2NpfH6o8vka8Po1I5gPiKdgG99mSGQ7hyEBcON?=
 =?us-ascii?Q?6mlKmiAfjsFr14qrB2CsMkOPR43pUTt9iRrPlIg5cxILD6o9TCn2kgcVRDlj?=
 =?us-ascii?Q?ZsHoRsjER5ClayxBNMycbMUmJSHH2MMDVR1d4YV/DLSR5IwKKn4IDGFeHLX7?=
 =?us-ascii?Q?gsrQTUDCHXuVjm+PzgA2GN1h3/lCIVpyzTmQrWBlNiUJdu/ceCljRwi3OV1t?=
 =?us-ascii?Q?6XsWyuzUL3fKJIDKdEHSpCnBC8yN7MG2tiDmtJdVpbgLVczn9uSx8jyeF2+U?=
 =?us-ascii?Q?BTDra0qc2u1DYBMp5v2b+qXJcCG4OLRpO2rVWhxes0EWop33FG7s4KEIpIOH?=
 =?us-ascii?Q?JnA0UXQ+BppQgTIk17XlnpB3DQf2yHMUfgAa6FdBmd4sAs6+KdQv7m3e9F1+?=
 =?us-ascii?Q?Ra0gdrnSyn0Z5G96tyWN14SP9SwjqQhCfnb84teHk7td1++QuKzPcyiApzf0?=
 =?us-ascii?Q?0rwGmw0GBNNmr74EceITv6c97aJoVhDU7HC+g5ICJ3pq3k/n3w49DEvAHBm2?=
 =?us-ascii?Q?J/m31wpcwwQcfoQG/e+ISSCNAhuZnuWlQ718pptoKRyyZzvVLGl2eJmN3S2L?=
 =?us-ascii?Q?GY786Rq3KbwMAoelAeoXaorLR6Nie9y2jLa/BmgJjrdQ6c6cirpCmBn+ud33?=
 =?us-ascii?Q?2cpsFZkifXSTJYXZNMsIHVkDqb+o6sS5opWG/jgS1IwuzXcN3BfM9S7gH0Uo?=
 =?us-ascii?Q?CQot81eZXAAFNKwQRRVualpEkjVbzWyPmIVmU55FU+CWP81c3j8wehtiFNin?=
 =?us-ascii?Q?AXdv+xJKbFGulp7qqnSB4/xGy/q6cGbGmADpEc6S64MA105Zk1Q9RojAS+Kb?=
 =?us-ascii?Q?ujf0q6ybgonVfjF2uCeczu1FmBTOk4hwgqJBD2adDaspAeiA2Mwr43aTvZNv?=
 =?us-ascii?Q?bO8KsLGFjqyLkk4mTQBM6Q+5P57lYdysIlIDMolaaUkNQahWBKlBEmlE/rPj?=
 =?us-ascii?Q?A+pMJJqHaPRT+uHbR+Rvk5tWD8LKrAqq3ceibrF2H1duic6NuJ2VtTEfXNom?=
 =?us-ascii?Q?4hSwfYiKgtQb9BGhUs6GJ74DdJ+l8umjF4Ftg8NSS+XVK1QpangBrb+imyeM?=
 =?us-ascii?Q?oFXAxwNZDFgaHvTmglGmridYskwxoNGXCrKGf7kGdUMJyGJWTPEZb8DcfibN?=
 =?us-ascii?Q?L0pCvAq13wF+nbAicJGWsIIcC+RpiMKkAgQ0U7HmffTfNu7wUSXbYKKVfx7y?=
 =?us-ascii?Q?8DGVG4NqIzhMQWAv1K5zTK7hyByVZjvOIlk2j6RdIOAa2IPs6VWaUpibC/5p?=
 =?us-ascii?Q?jJEH8UnUj8UtqDgZ3fPGUSnilAgxgafH+v1vKoi3ILeEiPHH0v47Sv/GqJcX?=
 =?us-ascii?Q?MrEKui2mSce0YTflwxNIvxB84En944lUyjcrXGFVMLQR+UBGDip0uT7SAvkL?=
 =?us-ascii?Q?O/pfTZ+LSV+ZNgvLJ3Vsuny9IEjJ0Qf7qRqa/oWEct49MoRKqDhn81aFslni?=
 =?us-ascii?Q?Wil6614H3fQsj50443EyIoJs7a/+pba04xn6vnHAo0Sjjh4jL3/L/+DXn3oK?=
 =?us-ascii?Q?OqZnOPjFfD8Y92DwrAFAw2QFPJDT8OA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OYohaRilUdZXHf7TroXpJF0UkW52l91c++K73QwpGTw5GEBG3VmCPNYbqjlQXFQhsTqqQF7trrj+gahqt7H0AdOsBQ9J7zn5B11VWYrt1AROjcYdDDv7L3WBYsOGofickf/+PjJowr1voCh2vPWEjVwj21CpxEKlOXyxdnTlJ80ckj5DlcXD2mX41SKZX7hR+5f2phpyX2xMzbdntbbWnW0IFvnaPZ7D2c7FnhQR/WT1rSM8iVGYVowfD9GS6y450s32IZ8FQm6dlhKwgzpiI7Iu/sCVLTDuczNIC+n4CzrvE01o51oaBYYEBCK6F1CO1OR4QtUb7hOrYiHbg80HWnkHLRDdXxqnROjUaccEomOcQKJeFiaGIDpUhwReM1SoGgz+WfRKEynejoA5vws+T2IhWnLwV+2bZesz2ETbhJZSN9hDya/7qkCm2CSkb70G8pekgUxZwQjt2I/h/gdHc3J1I4nCUpDf0sj0AmL+JdYFXFkZ9CfumKgoO56wV0YPlaBJSIKr149eu09G4S5eoNrjUFJAmZfttoypqoZdgw0Z4yEnQYec3jQel20YLQm29Q1oGr22aFypxHhtvVWk7yGmUYmbnIVnx/oD9uVGOxo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d561d42-af28-42a3-5e2b-08de4dbd3420
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:15.3060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDf1j3VrPU2n6aJp+LRcP/WpWkQL1mPhL/Oaboz9E3J5M9gnXseDRvX/kLZmRnR3zI/2HpBZZlPnNcynCdPidKt8RAJmcXCQZkwItM9QAak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=958 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1NyBTYWx0ZWRfXywq7Wju8gm8u
 7we8kHEtxYH89GM68BCm9NxVBlynNR3rv4qarUIS7XpQc5WbdVP//xL0V3wriJ1KCDw3QjLUQb7
 6+baFCbL/wtXP8moDwpvdYENYsqpq9Q62oZ2cT9NAJF4AdiM0M0QKElaAuoh3Royn3LDvTCZlfx
 JEl9tXqmZutreJxq4gqQ9JIMzDu2iiYcjpBmczQFtl7MJpKR94b4u8vEUBJRNf8K1t1UWEBWoT2
 ZeHiYo2kOcdyofL3nQwrqVt5R7o40Odo6brtPWHlC2XSwOOpqkTbZow8LuU5S6BDoeIq4BUbEw2
 nQsj1oIPjKqH/K1uO3Q7dP5dK6vBN4gFc+KX3r01decwBFIBzAGWjfB7Ruh5en7sN5nwFggHhK/
 yUVpQY6SMYb4/0LtKLPx9aFGybTZmbaBreVBElb17WS5g3XUpJNDIG4/OG7I1C6pUu62fNmP+LA
 ZV8cQPk7otQ392RLvBA==
X-Proofpoint-GUID: 5UBSzj0ne32KF0_pJx9Fetl7qmynhJoo
X-Authority-Analysis: v=2.4 cv=aLj9aL9m c=1 sm=1 tr=0 ts=695e0935 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=YbsGKDt_2YbWZ6r6MXMA:9
X-Proofpoint-ORIG-GUID: 5UBSzj0ne32KF0_pJx9Fetl7qmynhJoo
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C857120003
X-Stat-Signature: oi1tafosqz6b7demiqppahj1ishbx6sj
X-Rspam-User: 
X-HE-Tag: 1767770448-234641
X-HE-Meta: U2FsdGVkX1/2ptRfqc65lMr5kPa6NhohyxixGPOz4J3zp4Ag2rKs+pZ9ruoPxKoxe0UB1jOWQN/Ai11jND6xFJ5FwI5teXGwGYBZ2hZhnU2jehgJj8SKxYTDm3hoWbjTuVpdp5+RrpdL2KryEY5aIJ46frpUcCeqNpun+WLvD1bTdKuUTmejw+4WUTeCaVeBOHp7xEopbHtM5YUgN0mQ5j7SgwBUgwKOTrYalNhCDeyfWQl8WJsml7jxhmM0wwxrBKTEfNSvixyexTii0GfJ8i9pfki3w7ezxcX98GdQNzsQBoSWTXBAwHp9yEBF3rzCoPk6xktTRxpi1d1VTexUHvvKLl4EI0X44kJnjNBZTGyDeszmkArm/0IDp0EVpOtqGyeC8xvfc608JjHAJsqBKTKRL2tCc9TLuxPx8FAcmneEDbUWmgpzSCm1Ze5boaFvolM2+JOOHzc7tvDbGFdUIQwvsysAgvQdYn+SpN7zUCsCCUHnKX+l87GjXK1YKQP9NoGEguIwFbFeiJGOWu/jjebbZfuCOM4MJiPAsQwt+9Jlv5kD76q2tTPUC8BVnaXap9iwPDGZBwmN85xrTQJGw3CR970INGpqUTFJ2ANcDiJlSULxQaehkufTJw1SD96JV6W3iP3/lNdRAmaqy3FQApMTmZBkZ2NhwJfK9HJ86ubZFeo8tVrKL94qaW5LhgnQIoAtILgcABgxLH5fnrtok0Tgy6bo+e1kl4CY/NA6oGJ7FnKJj/Ros3Vq3UusKA6F8VQm7DSX7kUd36qMclvmX1asJoBsYmvUSbxojKqukhHt5DL0YU5oy3sp8hhBhxy9JBtY5L/CIn5/oIRpNgPcCAICqmXbJ70B4sGy5SFzXEfCuwTTtk6n4QLqPgZp69P2vK34eumkY1FPMoB+0Tjw3lhIlXab+Hgtwz9SQ1HwDEt6oicY/a3dkz7HIY7EKL1WrH2EYeN8L0tukpwWpNr
 cHlelkqe
 vi5y+KbwdNpWr7LYuoIlCvhfoZX3rmsMARsK3DhCqDjmRoV8THARgyjww6T44aSSWhP352OZbgPM6IYNsAwCsjPdng3LM7iUVesYrc4OnLcB6PBVTPbMbMnbd595OwSkSxu5WxwSquGoe/a73sijydrgzsd5qpsfkGGZhSVJhZO/rILKPXvyWlPbdvO72WGEi/EsBxJ/VJNln1gi/VO+tD+7JGrvO4BCh31BydHmI5qTaazUui69W3xAZBe93sY/njSBnXTW94PVYBeNoUsV8hTU99R0nWL8jYqgCdTcdTyZAmN7n+W+sNm+ybrocpVHovOuL6OGdaDADg9GmuAQdsi0vuMgQRwcSMk9kw0jGHUu5nb6TNn+TTzkMvnQAPI68T2bmQ675qv47pPyMH1SlJV5r67AktudSHle1L7Zr4eIvzN2W3oDXOPc/hiN6N+w4Tf86AaH78EP2ldXkeEJ8TTghWrCZ4UMVLBmgqI7ltVAnXYMULZLlwtc/DuNWUYCi8UGY1tLK9jD2iWydFDpMzZ/foXl0MGwwdQ4XltuM8GfwUUN0cqEDvOODFFmBgV9I8UIBnqcnUs03LehZIIAbZNYp5SUy2C5BnhTqi+LsDLM95j33Q9wNrwr/mIJwjp/YgGCYwfotjHzkqaSzx7nM9Tj0J8SCaeTFYI6IvqXhQUTpg0qcAPBzWveAbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce clear_pages(), to be overridden by architectures that
support more efficient clearing of consecutive pages.

Also introduce clear_user_pages(), however, we will not expect this
function to be overridden anytime soon.

As we do for clear_user_page(), define clear_user_pages() only if the
architecture does not define clear_user_highpage().

That is because if the architecture does define clear_user_highpage(),
then it likely needs some flushing magic when clearing user pages or
highpages. This means we can get away without defining clear_user_pages(),
since, much like its single page sibling, its only potential user is the
generic clear_user_highpages() which should instead be using
clear_user_highpage().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/highmem.h | 33 +++++++++++++++++++++++++++++++++
 include/linux/mm.h      | 20 ++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 393bd51e5a1f..019ab7d8c841 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -218,6 +218,39 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
 }
 #endif
 
+/**
+ * clear_user_pages() - clear a page range to be mapped to user space
+ * @addr: start address
+ * @vaddr: start address of the user mapping
+ * @page: start page
+ * @npages: number of pages
+ *
+ * Assumes that the region (@addr, +@npages) has been validated
+ * already so this does no exception handling.
+ *
+ * If the architecture provides a clear_user_page(), use that;
+ * otherwise, we can safely use clear_pages().
+ */
+static inline void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages)
+{
+
+#ifdef clear_user_page
+	do {
+		clear_user_page(addr, vaddr, page);
+		addr += PAGE_SIZE;
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+#else
+	/*
+	 * Prefer clear_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_pages(addr, npages);
+#endif
+}
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..a4a9a8d1ffec 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4194,6 +4194,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_pages
+/**
+ * clear_pages() - clear a page range for kernel-internal use.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Use clear_user_pages() instead when clearing a page range to be
+ * mapped to user space.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	do {
+		clear_page(addr);
+		addr += PAGE_SIZE;
+	} while (--npages);
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
-- 
2.31.1



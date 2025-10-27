Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E510BCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB12D80099; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A198009B; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFDD80099; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8511680099
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F7C057C03
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:49 +0000 (UTC)
X-FDA: 84045015138.13.FDA2A1D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id D096240004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j09O6yrH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YeKaag2E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596506; a=rsa-sha256;
	cv=pass;
	b=mLARBIbYontLvXxN7LS6k7Dnri0v+7EPBu4V6A0EvEjyeW+URVQHyZwhpZsbL3SglIlBwd
	4b5RXd/WruZx3yTjHxtjWDmpYEFfLg67v8Q7jBNzDZf/1WvpJaPBrKJzQTi7eMtO0IXsga
	Mgx33d5QUWaZ8gYYS/J0veqMS7FXKOI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j09O6yrH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YeKaag2E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uorIVQfxp3X7RMauaT5o3xHyDCGwSeme+kQmDulxPgM=;
	b=55cSwd368UIlSK18hxjsHek1JZ8eIqczAuYrNehqUOFi73A68FbKEtOAh0krJ492qI0Ik1
	l1SRgxYhK54CXGDzVuxGXvkelOxMNgeKWuQmYxmnW7xw1ZJiwqi3kPoaH8UV7aUll5FGPl
	qmnibZzHHuyfvLxt//4vIsFl8ppBjs4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCX5U012653;
	Mon, 27 Oct 2025 20:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uorIVQfxp3X7RMauaT5o3xHyDCGwSeme+kQmDulxPgM=; b=
	j09O6yrHFmwKBIFN8Hwh9FeeNdm3H0Nr0OWtbCTiNjXN27ni09cAf94NQuZDMUrw
	dIIN4+LQ6cQFhuydbcUck8Yvj0qKCjvgcC8LN4H3Q6zIexlWtIsS4Fbcn/jN5VZP
	hnl/ylRjr8B077kmiISyvdwyycc+THw2SItT7jQk18JKsy/IpSL0fXN9rioea8b5
	f+U3dSoBEDNp2TfhMuyXNmd+nzCipsFcep4u2pSkY0B9l+BWCZcf8DKr018HiBca
	zYXQFF9QyzmPnHKulSUIX3ZF4y764OrOraY5IYFCX50CwFX998L+VFH0zs2BAFw+
	hHq4HYMWhEHhIz4/dZSTCQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0n4ymgu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJuHBw025023;
	Mon, 27 Oct 2025 20:21:31 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07h7sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7WiCSFFeMPaepA79drrlUNsf/xU7avPVogkrigOdkwwDgRCMaAOsdgOuOVxTI+r+OtXR012t95cu0Voi0i8XZaPPPXNUnI/UpPhGkDm91jpoCU2nEQcVn3KWfATIdbO2uDWoSCbS4z+VxjcCGhWGq/kyeftYrdMyGJ86rEaYhUoBryZ9hkm6Ex3inv9f6hK49YF1QlMR6PyhwuTZvMVsqytm1tSkwMgC3r2flpzVbY4PNZ76mTBMoXw72TufL8N1aQsYhRF8mhTo/ocpYobLbhrxdd47ScMZs8skloEVWBRGkfiN5P05eZhqClgqMO1Tt7sfKNgiw4U3rwPslRKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uorIVQfxp3X7RMauaT5o3xHyDCGwSeme+kQmDulxPgM=;
 b=ODeNOvfy2iTpHMW0wO5Hud8OZKg8Dc1/fFGEURKFinwsHnxW2zPrf5+4fl6nGJPoLOEjVRh/OgEmJk/k48YlAF08P2pfQhLi2EM0gkFmukNKcbxeKZojkeVa72Al2iUfppRK6Pka8K5p1JPVXmlvsw0pk1qZGK+qkcFqw+VELj/Q/8izWiOs5HptDI+ArRNE+YC5s54cVaUoX+Gzp/3toHL+uuvT5jLpaCc2xC+caEZ4YY3sFnIbBkpHVFopDguFA091/lngTUK6PJMxbSH/7P1ig5DMuIhxO6ceJ8ulO38VUI1UdXoaaROP4w/Jek0I1hCF0K7KXh/h45agO+qMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uorIVQfxp3X7RMauaT5o3xHyDCGwSeme+kQmDulxPgM=;
 b=YeKaag2Ee2p++gGHxFSukaAT8YGRPl/RS1d1EvK67kDqynr2yF+2UyPwy1eNYK4vfE+LuLHvTbHPelZA8S6HSRCblWaljdWTz4Dcftr2VJMHbSK9N+2y09v0tDCe0Q49aSBYd4bv0SZ1f3NX+51RxZTGfybafIgeOl/+8mRojko=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:25 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:25 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 6/7] mm, folio_zero_user: support clearing page ranges
Date: Mon, 27 Oct 2025 13:21:08 -0700
Message-Id: <20251027202109.678022-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:303:6b::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: a3341514-9560-49d7-a097-08de1596671f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W7wumAmsxuiC2QgxqiZcvRNx1J9EMkcnkf2r41re1r3G29DoFSjYM48iqjMj?=
 =?us-ascii?Q?gA9FxunRrlUlfrS9k4rKRwF76d8iCe9Np4e2wZGMZb+dUR5stzjfC2Si3wSu?=
 =?us-ascii?Q?FogQoVaFUVh6lBi9jHYGaKsEdl2+oLy8zpLhaP6RLaHNu+QPXn5zmiT8SyWX?=
 =?us-ascii?Q?vY7fhG3iEZ8ve9cCDjSAsNDWgaFpf/46vj+2KfXhJGc88NXjOBCvTAG9RVxv?=
 =?us-ascii?Q?Bo7qe/NtxLEyV8uZsV357w2KXCTedJEtdeIYvHp9qnVwBHcZ0KB+OaVD8X+d?=
 =?us-ascii?Q?cUay9TS1pfDvCP6budILThVNtKQGm9TmBpdkK6FSiRjb5pNvwJah1TwsevGP?=
 =?us-ascii?Q?c7icPVo6RgKWsc8LgeK2EjFgCkQjd58dOL9EC2JtUNJo5dNk5Q5GjX1IIAoh?=
 =?us-ascii?Q?P9Idfd2QMHDGwmRXo07tILnTIMr5kA5DEoMIvBB0TAZJ2glIjT7Q9BkPKhx+?=
 =?us-ascii?Q?cOhxuAD+oUwqHqibaCUw8X26pqBy8KrEXQalwf993PwmS3cSudqfZwlS7vEE?=
 =?us-ascii?Q?QrV1kxKFhcy5V7K7i5oue2Psi3F9BKq7qczoEFc4EqKKeioVEU8ONZVKFsQy?=
 =?us-ascii?Q?DDaw2a+SLN/f4d3lmeZFCdvwKHqeZpQCmSrGWzjpgwr94kilS8DYPwZ/wN00?=
 =?us-ascii?Q?RihCZzQpjyTGVZErgHFnmKDFtbfe6eRwwjbH6nIA/28A0tROIbYp+qgqXlq6?=
 =?us-ascii?Q?lpifkpEFHwUQB/rXYDkrraaHSdzs3of9FfFVe7wVZ014Rb4t+GzqVB2wfyDX?=
 =?us-ascii?Q?IxKcRZ2f7GsGKEOxdUODjDs1AGyi3kmhw9cifEC2rXwTtXwlfU1chqlu8WnE?=
 =?us-ascii?Q?MulBmcrfZm/gWhGFzt/t1OJ0ymaQwHpZJBbU3Cujn4NEhrC59FdL86XO2afa?=
 =?us-ascii?Q?6vQ4yWg1EwQob4Z2bc2GMy3/5pUtXMaT4eOKZqMwnbKXeaVGY+3FEfAcnjaP?=
 =?us-ascii?Q?wplBslhIq6qlRANHCYfUhGltOOn+Z5YZnU2hMfVXQgTNDd8SY713tCb1ABEv?=
 =?us-ascii?Q?5pT/WLUnFFHNwablwylzAjulkeskVmz7i6tYl9TkyHZV6pp1cnZU9MAMMnL7?=
 =?us-ascii?Q?lQhUVWAIAI4Eq6MZFyVO9rzNLuRLG4RwH8OWQMGV1Mj5xZnPsZqKDPz+6LWU?=
 =?us-ascii?Q?EaI+tsHv+11lrscLH5qHplgacEeFXL7z6B3YPtoF5Xgr95d1ixe90TQyl1I9?=
 =?us-ascii?Q?pTFgmi0gHcZLvt1OppPjmbWN2i8J01bR+bjDBHrGtMLfIll+LYUT7xS64vlq?=
 =?us-ascii?Q?0n+FOyLcma1HmInBIelMjEgCcteqdQFS7zee3A+80jAJvL62PDaus2m8OdEf?=
 =?us-ascii?Q?zGD5S4Y/vUMqkPOYBAy2aStP16xx1vLlevUMJY1mH3NeqMMDIemskChpZ8z2?=
 =?us-ascii?Q?5tJ+tZyBPC9TwQVaTZdUPRstFi5j+KOjtR6r6TzSQxbj0p90UIRCohML5KwA?=
 =?us-ascii?Q?1xtp41ishMKzzKvtc/p3E0mbHh1YKK5X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ftUB+QUgtG8d49BDVeM6N8Qj0h2HVadOxn3U3mQfQbFulLdjK4iHQYqU6jzz?=
 =?us-ascii?Q?sDUPMpnaW7GnE8aE3HPrcaa8pzAg8QMwSVtI8rKsk1e4610sq3XwU/pZMIof?=
 =?us-ascii?Q?I58XC1jQ01HTqd5NxfmNmvXsiPu/XwatWn55c0geIONDTAPIzmBchLKClM+C?=
 =?us-ascii?Q?HhNDOGCZZ5TC/fBfUkvgBCWJtboZsKHPc0PLdYz9BdHSZMweJ7sF0CQgAHcI?=
 =?us-ascii?Q?3lLJghhcM+8jEeoatXD9eToXDN5lhzY7GDiIZsyB/G67mgq+ImvsRyaa+Zs0?=
 =?us-ascii?Q?lJp+oVoKRCN6KODafYFvnDhtvSK1vQDEPGtGxg5gfJ1iOJChtsRlyl5H2q/S?=
 =?us-ascii?Q?QNJ+9GeH2sRDwkjx6L68yXIm3sWtk4V2Yda5aJ39rLeQO2jB81LegTJCrDsK?=
 =?us-ascii?Q?8yNLrGbQkUEenJ68qdPzcoL1POSX+dYWvxr/wyj8TbjiBnd4/7bkf1cVshdh?=
 =?us-ascii?Q?TfZ/sjPpBIEUi8Kuh3nDjCCTR8oHv6NPXL2LwvZQ43XoJ30z49CRvmLP1i4i?=
 =?us-ascii?Q?LDmCLT+n4YIpAUWepBtbylQZNr1wPB1urKzCo6kqbwRtaxYwPup2d1Q0V7IK?=
 =?us-ascii?Q?YHxHX7ARxmTIdWNTKukBhkVAwRnagwEWTJfid3Th6hhKANnnzSpq7anDpUf2?=
 =?us-ascii?Q?VpkXk75stKvcsWIV1orsneD9fWEUVwNofxRwZsdemi1JXy8loc4zWR+z+5lF?=
 =?us-ascii?Q?zbpigXLPRX+K9c8s+1Nv/G0Ky6RuH5SmP5hhLw4u/q8HbSY2Itl1RG2ExqBD?=
 =?us-ascii?Q?aQcMxeiDozhPWWl/j9tMJOQvIbWDcd4GL2EyL18Qsy/xb3/7oypGlGdPFma5?=
 =?us-ascii?Q?iMrnl145PG6tpTEc8/6Nr7HDWsXR+clFRArT3zmAyj63xlUyM/ctGtbvomGQ?=
 =?us-ascii?Q?J1YdWS3GHgx1b1FiQ5XTyDB/m2DwbLTKjI0lFNbJz4b1fQCPvyzrY4mEIZaw?=
 =?us-ascii?Q?qJNNfFEO490hGtsF9phS3tUsGiMDPpD5q4z/imh/3fZ6gC28bjO95m3a7rz1?=
 =?us-ascii?Q?+JeALRFpTZKnB5CRB+sX8cNlVSoB8gU5jAkrM8n7TF/jgQkPM/xbG8oOFUJh?=
 =?us-ascii?Q?wW2k/I9xNKIHNzFS/ZHMLnUAdCgllRDbn0t6ldNf2q+n8CI81+BVYWm2gPRV?=
 =?us-ascii?Q?GgnuKMjoROOzeaFIb6Z6OSZrG4nWJGYB3g+8Ork9FeREBFHfvx1kUWK7fSKF?=
 =?us-ascii?Q?bmRWACXv4uqyKMEpe4ezLu+8vm6i44sh/Kcm4c61FeqBkb8MUgSNXca6TT+R?=
 =?us-ascii?Q?+Ekpr/8ZQ+JAJX2qS9uaSqL7qFsBKO3wPEdvlYjnSa6d90PrOSP7+E3fgLBF?=
 =?us-ascii?Q?faRCsdWvXKilWwOHTX/AhGejAtMb2qpfCAFGY569zG/2tkzh+W3ovR+0H540?=
 =?us-ascii?Q?f4sAeI4TTYXnx7E8RYSa+JOdEd14n6t1r1SPwcefRSBE1ArPv7na9NimcR8n?=
 =?us-ascii?Q?i3huaqZ/uwy/4XHG/De5j8rYdr5xPoZ6DfAq6xz8uYD/ooJS5FL1kPCTqk+f?=
 =?us-ascii?Q?w8DYmwdif426xpfMVr1BivhRdIDou6yO0Fa2faDCJJImElWNQ7Ht5rHolvom?=
 =?us-ascii?Q?Ua8nc9yoF1wM0VKR8c+/oZ3nJ14OPgXeQiKedCInWs9v8lj+1ZmlDIgG8lqH?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BKEv5LaKadB6hisWFQFebUHTTmoZaQq/Xfs+CUJpNU2SlMU5TqQTY4sbC4G43PJtjdY+knzRB3l6dlCtmuBZ2an1H17MYiea8IEZkpRSrQ9H+5qJirMJo0AirhjjbYvGmWIYQ9HxmM4+Wi97VawjFkXkLOHhshhyUx2RCsq78DIuzPCrGlT+VQMIzR39s5QK0KcXClgxJkWEJG8djvplpoRt4kEwwuMenzedu6nq7SW9ThA3a4v3EFrZb095GU0opK4WPcFDVEhbEbCCnuXZjRV7fiT/jo0wPQeDOsso0YmfwUeSB9nLymgovzqlFUA+j0MiMqfEGHIvpMJHM1MLsBDw9Y55njuaa6Ph91HDTiexPIIwwMQgB/nTx4xLzg7ik4FSiwsK58RRG10JWeWhTnmHIcgyf3nXiDLLmHEMstjEwYWf0DVhNaOIj1WvfjD1zivp+lklUOW7TENBL60kcwUmx2jYpLizdugxkXx8o6S9qGxRAZOj/4UmIAcpRAncHQ+nbPlS5XdXkZg6n+9TelWORzadupBJtZ1cnU070zZ523z2JxdN9S0yoTbz7YDeXP2SHH1AIQ3vN7gSxUsRXvtBrwHDf8hEkJE1d2OwBUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3341514-9560-49d7-a097-08de1596671f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:25.4712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuVNZmuFSxEUkLawSaPdPJGVqcZY3kIR43qD/cvilx+P9vWFWMKZ7VMzG3HHM8b9CsdHxhEyeOE04FsmgTIzykB+QunnlSEhECmMa10CXbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMyBTYWx0ZWRfX5Cv9pZqqkcpx
 Dm4zkH8nF3U0lCAL58o6QKKy78CkoogL+mBW3vWEXh9mImpnR6Ig5wNxhfvqX+JExJpaCh78FiQ
 F6JEx7lFpKesUZq2zV/uuxcKiWGzlcaI2f/LzhltAwAatImcOn1/mYrRc2Bub4Aq70RvMh6i4Je
 kQshj70x7rDLa4DpjeLu9C3eRE4F172RJGMqFEePt5jYlAvWGywmSQaoRSE2HuUCK2xMz7lWiEs
 ngVP+NqIPMC+KJbZ9ny6URzMv54jJfw5hdeJJHZWyxiogFFeOkCkEdMXa2F2CBhwxDTAGSsxcvV
 7nAgtTYlhOZ0Vb9kk1fanYhfneCauKpQMAzaPHWS2w5z5Cw7Srw7D3A5JEs47wKath5OFa+VgiN
 74bz5w7rY4kvuJJdPNOpRycwTifxoQ==
X-Authority-Analysis: v=2.4 cv=Z9vh3XRA c=1 sm=1 tr=0 ts=68ffd44c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=emMqWsvGGE0KfotJViQA:9
X-Proofpoint-ORIG-GUID: GJRbnyG1arblOTjHodaHhhbjqVSyOlwW
X-Proofpoint-GUID: GJRbnyG1arblOTjHodaHhhbjqVSyOlwW
X-Stat-Signature: hd3qm5oefsw7scmw6zzjfwuhb7xioahk
X-Rspamd-Queue-Id: D096240004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761596505-958226
X-HE-Meta: U2FsdGVkX1917jYKjzqbJ2n1xUSKqULCXFphmSnUZtS1RpQ3J4PB+npIJ09BZg8PLmmVGP1EUy+8le6fsnG4gg26HBxMhQjEYaNknYcgZQ0hF7HpqX7/397ykmpV+mH7nuEdTtCDN0gRcnKdAfqc73FUNNbWHP+hdHqX1BzP2wATni1/T/NmFJ16fJTuqbz1N17eQkttYRkEMMeoKRxRInsUoGRUsWc2B3psGj0QGAjcvl9n0F3Rf+rtI1UBWah/nk/2IXeSsnz//a0bjgnDmaLA08DD8PtyeDoMDCLgPOqWNhXUk3YfJdS3cAFw6SeIFy4sGpWhsHpelK9/qZakIC9DQEYXzSlUfACKIHiT+G0g+QEGnPDNmj7PGg5Rr/6lzoo05qtNnnhwZnvs6cjaY7LQG8kNWl9wL72bATB74Z/UGXAD/DwRQkcN4VZgbgrmbYvZNiAuFYQaGfBNOZ0FMbNUAzw9cYtA5vo1FNFFunxlpfcxAVVT+MfjRuRR/IW/wGADxVaNdaupdQ2QHtI+Q1cMVzbkuAAcg0rBzpkm3Lc7CBUpme/R9s363hnXpEGjb53eSxjZNnWfDAYoDKOxPiAIstzSj3Ojps0BI7AmvGjFkkjTx6ZA9xYPQ8/GU1ztsIMljrEurYAj9u5uPP1P0bVIW46ykdjcqfG0G3gZw0hSjucC7bj7VmQQpkF+i1FEnxoKLEHHO5ejph8qhVazYO4GbSM7gNoPXsqeZkzBOVWckHTN0UHXBsy500mQwty4dKgoGjp45PbHHy55Pv9UwLaffd3TR25QdqIJ8W8vNytABhbyjiYUR6m6xs/h8lIjWBFEmwBfwZ8zuUdtYHOHDN9RFgOYLNth/H4ofaq02v+3aF/+RoTP+T6TTtPTqlhg/j/4Mmscbs+1BUllzJIJ70+uFun6twZQ2DVICJsA430Pe+ElZYgDFgI8F46dIkFFRZNtNbT0pcaO4lX0wQv
 rKfF1x8J
 vBEDeNRff3GgFDzLhX14ACwDrVIMswD5zgzAjTFDbB0A3XiuYJsgpcOrndq/4KdlfBKzyZUfyGGdWq5Vrx2vTDT6N9ctuKHEPGRIXCk9vTv56qx7tvD8cS1LX3C4hyl+fI1EzdbvNk0amZAAJNi4Ds1ByJ3ZiNbexYR2ISGFD9lP08ITe860OLpGCpPzctcYZoANS8eT9pvlteh2zpZLdWIP3DQcLyC5p8wFjfvin999mFu+BAsRUEMtb+yaqOMdbshU3X8ECTYdTwcgb3/xJX4DQ8qqzV5fINTk559p/WsjBjaSRs9hJSSZrCxo8pgNKCiP/v8PQEA+fQZHLnOlB6HgP6S+t3BUBelYeDBwzPiZmqzihEOQvQTFENPWQFInZz8gO1W8eLUNW78KKx8svExnZKmxRLw8DB/z+8BuuSCGdjfHT81GnjfZd1MHOTi491uClNX9n3ti1oUxop8rzjzkXiOjvCPpAUezFJGca4O7KnN/o0VvFw22S6uKCKDUDD07qN+Tgs7OFg7y9DAPDe5pWlkXSpEQZ0Y000FpVldXfUX13+R1Himy8ZHMntjiyZc9l6q83e70Tz6DZUs44ZeuBMyS3+1oF0kBPjzyGRGPBS4i86Hky4/2V6CBKB/UfOJqJ0qD8FFoSxR9K9dmClR0+LxxvAngH26gubY/PVwaVrQOGkUg2ucbDkvF2EWa7D+u340ue1K2GIwCFHLN1OFPuR3yBR8EV4CGE4O1bk7pP4srKJCVbDboRqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clear contiguous page ranges in folio_zero_user() instead of clearing
a page-at-a-time. This enables CPU specific optimizations based on
the length of the region.

Operating on arbitrarily large regions can lead to high preemption
latency under cooperative preemption models. So, limit the worst
case preemption latency via architecture specified PAGE_CONTIG_NR
units.

The resultant performance depends on the kinds of optimizations
available to the CPU for the region being cleared. Two classes of
of optimizations:

  - clearing iteration costs can be amortized over a range larger
    than a single page.
  - cacheline allocation elision (seen on AMD Zen models).

Testing a demand fault workload shows an improved baseline from the
first optimization and a larger improvement when the region being
cleared is large enough for the second optimization.

AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

 $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

                    page-at-a-time     contiguous clearing      change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy

[#] AMD Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
allocation, which is larger than ARCH_PAGE_CONTIG_NR, so
preempt=none|voluntary see no improvement on the pg-sz=1GB.

Also as mentioned earlier, the baseline improvement is not specific to
AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
improvement as the Milan pg-sz=2MB workload above (~30%).

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/linux/mm.h |  6 ++++++
 mm/memory.c        | 42 +++++++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecbcb76df9de..02db84667f97 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3872,6 +3872,12 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef ARCH_PAGE_CONTIG_NR
+#define PAGE_CONTIG_NR	1
+#else
+#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
+#endif
+
 #ifndef __HAVE_ARCH_CLEAR_PAGES
 /**
  * clear_pages() - clear a page range for kernel-internal use.
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..7781b2aa18a8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7144,40 +7144,40 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+/*
+ * Clear contiguous pages chunking them up when running under
+ * non-preemptible models.
+ */
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
+
+	for (i = 0; i < npages; ) {
+		count = min(unit, npages - i);
+		clear_user_highpages(page + i,
+				     addr + i * PAGE_SIZE, count);
+		i += count;
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support for clear_pages() to zero page extents
+ * instead of clearing page-at-a-time.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	clear_contig_highpages(folio_page(folio, 0),
+				base_addr, folio_nr_pages(folio));
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.43.5



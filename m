Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8C5CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D028E00D1; Tue, 26 Aug 2025 08:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DC68E00A8; Tue, 26 Aug 2025 08:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5B18E00D1; Tue, 26 Aug 2025 08:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3FBF8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:44:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2184714064D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:44:01 +0000 (UTC)
X-FDA: 83818875882.04.5783B5F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id BDFA6C000F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:43:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IRmp0trE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JfCkg2aF;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txx/t8y93bPgzAAL0d7VUfD4PFdvD4lgZiWF2jpXu5U=;
	b=o2cCELT5gs0dQixjMXEF/c1Yp9SVW9ZfvACCW8oCd4yRXM0abSDz6QekxOTSDf6sNZ0WKs
	G+1zurHczF7vIsx5v96i1g/ZuVrCNp1PEmU3eZzcqSZRPtrFlQvfto0DQ20mn9sYhsXJzN
	jV1p1Hmzs3MfvhxiilQhutBkqTeMtoU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IRmp0trE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JfCkg2aF;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756212237; a=rsa-sha256;
	cv=pass;
	b=clmW6jtLYzW5Mz++yk0AMRd7bV99s8BkmleZUGHp6rO8DIgR3yaB1Sp5T9BIlzseHZM3sC
	5Mfq789M5STOFYXcGXDv0+iiLc2MVpKboU98Q/1dIUcku0Job2hYGl7D6MFPC1pOcYwbNc
	oIyWDqAl0p9YFrNPak6kt0FK26lAUNo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCIOus002932;
	Tue, 26 Aug 2025 12:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=txx/t8y93bPgzAAL0d
	7VUfD4PFdvD4lgZiWF2jpXu5U=; b=IRmp0trE72ZSkSmy1fhxOQWXFXMKWJ+nzn
	WG5GnYAp5WrL2opqA+TaHf16DIUJ1mLHaLib8+IWSmfFp/GSINxdcyRAgRlcj7yy
	G61kFI014ZA0k2fEyVltBYA234iTk8AY2O8GwUPGCem0T6o6JUh7nFTKB7j2Foua
	jL/7P7YPmW9/gfkIzsdPod4yX2AjiLQdQDiGpw/DWTknxsS3W09wBY4rbugjX0Jw
	Q/bosFBH0rwIjbaiPrrbWjlVu8vNLM93ZGokgo3biRXejILOLjwYxjLMPkUGVoie
	x7rW4qkSem2r3YQ3IY2XOu6/GIJtQkLefEUz055YHNoa0Hn1eGHw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e24de7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:43:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QBGsJu004981;
	Tue, 26 Aug 2025 12:43:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439ntu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:43:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+f5jeUOAKabQMR2QSyqyYbM/9u60qpXFnyWWmthAQW261ZeizlajCpeYjK327LvHP+HtakeS5vbcxicWfVch8/jhqwBY8VuHXXNru0yoXImWAA2wbdgQtIHSA1bNhcSgQTksdyooo1OBDqvFWDTIqaO2LpEbZpIzoQLGdIXb9n6rbJcKiTj84crqQ7ROutvMS2CAJOJVftSdg5z9rXJj+JlzxBe1ZR/e7plXZ/PFoKsDdKfxNy7QZ2VmFq5h1mVJJEhhCgp+89qw4SaCTa+Xfh1u3sFDkX8mM5gnd0AcmumvD49pnWiDrs5SX5bI/SWHe2m5XJ3HW5Cc+RoomO3dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txx/t8y93bPgzAAL0d7VUfD4PFdvD4lgZiWF2jpXu5U=;
 b=iMfdtv0qvskaqWbpDc7h/XsjttQ1uQp6zCIzku56tgoCgEbCQXYL8f3DhauqQqkrdsnixdAbfEQuCHRa5p+8NUbXGx0qhZlCGd4YcfRTdylA/MJCTa3YCDUrTUpNcCSXYO4Md+2ZXk929+HFVX7Z+rEH0yGPkDZbfEe6V2JlipHlBvMrmrU3lsjpzpXZ5LyooAJhiE1hs72mPCP16lAd6T+r/ZZacaOzMzokTKTNuqYl6XhJ0g2gLw/QeTb4ytAlO52MkTovM1rthXfK2mA1/rF9MUk0DCvflLtwemWkw/OzR1Tkk3rGdHBPok8oXrgwFpjKZvqsJpTBK284vlxS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txx/t8y93bPgzAAL0d7VUfD4PFdvD4lgZiWF2jpXu5U=;
 b=JfCkg2aFRUA4EurFXukvPHPoj4//J8j+jZh5sVMGCiiDVmsJU1WwHDyZOlsXVNTgRw6z9lvcreiQ1a0l84wjcGG9SiKpXXVARfR5m7DeNKEZ7jd+W6dRq6qJ9TsbB9R2bPxx84lDGCCEOBkgaLOpCo355YYOBPAyYj1bwBZigs0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 12:43:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 12:43:10 +0000
Date: Tue, 26 Aug 2025 13:43:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        liam.howlett@oracle.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <af4edeaf-d3c9-46a9-a300-dbaf5936e7d6@lucifer.local>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-2-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825133855.30229-2-zhongjinji@honor.com>
X-ClientProxiedBy: MM0P280CA0084.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: f34a778b-5858-47d3-d813-08dde49e1d5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YpC4ZSS1rHDzlBG0QCEW7jV03FPEjLwQoJbklKFRuC+dChAM7ky1sqbMtlDK?=
 =?us-ascii?Q?7BRTHf9P/HTZvxPmv1ECSKCVWPEL15DH6QNA891C+7Kr3RLtUDF0tp1CUoNT?=
 =?us-ascii?Q?NmHw1KOc/fFuZwfhlP1owHkUL8owbBFRmHqKGoOju9FYEAnd1IkXnr3Pr3o/?=
 =?us-ascii?Q?r7Yh7uwnUf9cf9HmMyLyuNQ2kLgvM9QUij0hkke2Hfz4taOmOnndaa0oNluT?=
 =?us-ascii?Q?RLQg2HqAHc8k2EHLJCF0cVwAFZZs8WY/jBP9TCJQH2XNob2+pBuyTHOk/IkU?=
 =?us-ascii?Q?zOk1q+T5DnLCNiTzeh/VsHmfhXKIJPZZdWMVev7+eKGoqMlUoZ+DEDGDpyG2?=
 =?us-ascii?Q?WMDf313KHChudLHsRyvP3BIJRrlA65rayz7gfb5SwUBzOEKwrAB9jWe4jkPf?=
 =?us-ascii?Q?P30MxE2JZsJhOxGWVFXUCehY6b86a1OeRiZ8r6MjaDnl6m7Qi32kav2IubEo?=
 =?us-ascii?Q?1csYhoN/4eRIyKpt4YEmbzGX1yE9vXz1gi3/oi5iScGAyHn5jqM1BRq4yLcz?=
 =?us-ascii?Q?hFHXKOtk8Bip0OykabXzLlBmlQwzeiQLguvdaOF6276svXiC86Kk8/sjq61a?=
 =?us-ascii?Q?txHKElrdNVn4ZkGCP7w7utxL7HjmyzWSWciuJLK7z257WLK+paLWoKangv6m?=
 =?us-ascii?Q?3N1Ni9+t8ShhpmJSR7VB0fLdIenINVEGk3qHWii/DeWcuHFynQxyRM++qLOj?=
 =?us-ascii?Q?yPmQN+KHKv+D8JT+VZmKJRbs/eSMchf6yMxXVBgE/s9YW37o6CzhC7YZzAi/?=
 =?us-ascii?Q?Df25J78PAMvsy3F5QvoYVg8L8IyDxsG84DfrxPPIa7l9NBt5I7av9EedKTjx?=
 =?us-ascii?Q?DKGK5Rj1R13SCqtjW/YlEx5V9uRJ898ueVtMwC4ST1pPGwtnKz73Zyh4OdeE?=
 =?us-ascii?Q?qwN0RmFJPfm7Fdfh29teCzPhGVgs/3o0aM4MP+DQMcBDwqBaaqnt+nTETtP7?=
 =?us-ascii?Q?/JXjZi++WeNuUZbkFCk0+NByIPHF/6Uxl5kEdJJ5xu2dROiMc9sF3Z7SYZC6?=
 =?us-ascii?Q?EuXgI8fmVs4Woer0L5tcQ5kJ3c96hbkFP4cvv5whCQD1DF0KDJ5UXJM9BwqH?=
 =?us-ascii?Q?IzijBagkE3gteCIVOQ0fIXE/4xfLnTW8cvKWWtw2Z7XU8qoQhxje9XhzQFP1?=
 =?us-ascii?Q?bp7edTwfsfhP6xiayhizi6vPutUVvaBntJ+1Bvv3ag3IQw3vFiw1504YaRKV?=
 =?us-ascii?Q?qH51n08fKR4OKWzVNV1x0T1gJZLVgT5W9AFLu06REUQx43dpMn/iTOVIbija?=
 =?us-ascii?Q?wg/F2wNyI0KaexeKrQKUmL7DyYcixvPE3tUdiP8DSGK2FQ6QExf4ErfYxboe?=
 =?us-ascii?Q?CQt/gD2gZ//606xHCVjdrowPmouijHezjuNDKH7zcDCXh3mE+6q2PFJ4rEYR?=
 =?us-ascii?Q?PH3vFAn6BUSV9rvP2MBDIRMfhkFGq/XyNhEG5VBauEMntrypt1dkYCWe5nRg?=
 =?us-ascii?Q?sUsXAw6rrAE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bzy0E2PLbRr+9PXU5g9kXBXl6pn7g+gVlHN1KuDHhCXcOqHc8LC82vQPP6km?=
 =?us-ascii?Q?jKL5jq3zuv0mAsmYQZe33tdzGmdZn0UieBldohnHpWBNaHHIy/j0hWKFjeo9?=
 =?us-ascii?Q?9SrrwqwG4VDAvWyBG9aNnBjhxnm0vh2N2YUqPy8fPK+vdQfzUxYjbg5EUrTK?=
 =?us-ascii?Q?gQeMb5G8RsYWk2gR2nBxI2XGcMD3043XW7W5BH+mC328H5c+j/db55fzzYLs?=
 =?us-ascii?Q?Ox5tc2xPkRirL0WXs/exoOu71HhbFeYdHSdEE46iYzRhOncDFdiRFJj+Keqd?=
 =?us-ascii?Q?y8HZAn4F4hV3f9pepkQ2Pgx28W4ai9g4J6PWo+wFHzSFfcx00uW8vgx3MZFs?=
 =?us-ascii?Q?5XThSEzMIOxBRPM+SWRfzY05yab7vUHvj1PrDHkRxoK/E3DlyoovmuXwqMwt?=
 =?us-ascii?Q?R4WjHLrZ/fz5lZ2x1Na6Z/KYGQPP3VhP9itkOV+fj+5m1TkBCeEftWNxW8om?=
 =?us-ascii?Q?Cw7adB9dv8yJBy+j3auZsh/NRIxrv7NOg92tlZFJRQKE4ANJ5gTTSnDhYQPG?=
 =?us-ascii?Q?iQPMdk8jOIbcU88CMDUyM7PQG7S+ktv7KZMLdwmnADCVoEth+wLoRyTacb1r?=
 =?us-ascii?Q?e/FeNfCzcMXTkfKs3bRpv9OJbFVpA/rwL7L/+8WZSD9YsVOEsfrUOLdYWD5Z?=
 =?us-ascii?Q?snWxT3p88hq7REHGaTNZQTMPg4iLTIc5VdW+yuSAQF+Eakb2MFVHBn/N+nbO?=
 =?us-ascii?Q?ilmz2RRV+M4rNCpqymj0LLpRuXvRp4Ulmhrl7VhjymgFS2KLQkxebun0Tpfg?=
 =?us-ascii?Q?K+WOaEDO1wjJjYIuUHizYQzHYfgF6J23PSWkrG4Hb/Yy/x07CE4MkPPmw9fu?=
 =?us-ascii?Q?JPqbt7GYcQTjx8ZYEU7ZJXnEzSS2V9yuXzhPsSPca+Zcu9esnigqFTBOCwTG?=
 =?us-ascii?Q?E0l6aDiKaxPJz5O82lO/BEK0cbR3Wy+D2JwWfkvWsqCMh0ahre9Gr7J0kpm4?=
 =?us-ascii?Q?YxgMB/GPm6NnoBA71hLAys1CvlBMmEMQIRT4bT9S3cN1KzuT106djZJgaNnn?=
 =?us-ascii?Q?6s+u1bJeYZ+wvzaqIydO12PzzYYOnmkuUMWficii4LvXasUCeuO2dGXk9GBK?=
 =?us-ascii?Q?Ohs++UY8mDFFrFqyblrjyiKAGxr4GlGN3kzLkf3ZiLYiulSQXglhuk0Zxq1r?=
 =?us-ascii?Q?frTgc8252mbr/PA0glT+gSc1HIrXhuVfGUP+qR9a96L7TDV/qpMEzu1jM5bd?=
 =?us-ascii?Q?qSpZgVgKj4KSJOMb808iS+yQdGuUumWskd1MA4n0acvA9TGbXldhknSfEv8H?=
 =?us-ascii?Q?GrDxBaWKKaygxDVDcYPKgDSAMOrhLibjkkRlIBlGln1uL/36vcAbcW1ayqCo?=
 =?us-ascii?Q?mkoQXHS2pAyv3WG6W7zqDpEnXp/35J/MMe8lNBzuKLhc9HN9J04CJzz9Kcvv?=
 =?us-ascii?Q?Zo5YlEYcKdPfoJovbczNS2HFpKhDlKLSun92sDxMLpcaQKq931ZeHs7bK6IH?=
 =?us-ascii?Q?pgbjFgPaK7+yXHqiCnRGnoTXDNgRKJplsLchBh5LoIUdAxpafZurZ2Gsjvqx?=
 =?us-ascii?Q?WaAdb6nxnouy78uGXn7kKR/DmqsFidzp8sN8wUlUPUxNdW26ra2GqoqYFhvP?=
 =?us-ascii?Q?Ytpu+BQR6C3naw40aKZYPQljlmBN4zsEu1rZs9v4DOn1jz9tf2f07JXzS7IF?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uoiwf1zuupskI+voNkCmUPcm2O830M7VKEzkCpOrHUgjs120Mem2MzCWKVxwbWYsvm7y0x7Ryb9hfufN4eFL4+3juGJ/y+ZQYUTVvn1Bxv9IITfNfmd3sNJ5yCNDNi7ev/On39h4djWBNdX8OIUUGrbM5sVfjC94n0Sxtgd/emjRQvEtFiEpZkvZSVJJZlcAktVClC31ntdFX3aUR3zAGpBdzj/uF/OWaTdkZCaOkh8rFRUSLpY7W13bhE8SwLKEjeys7RZ1Qv+o4KV0AUCCBZQu5S08EDpxGQwG2L3GUCcy092Ae/xFuO2TRITT9U9Ms/vhSUSJLJF33UJpbwQp8/iqxAcHGFI8c4tjiju2ldWxZ3neFOWuQVu+S8BH+slHRB5AJxorlIb9Z5O3dC6lTw4HEWo9EUFFKV8W/4qqMGbqkM8srGYCBVRZLpYIlP/Xgjha5mTN3k5JLEDr9j+a78qT58obmWabFC+sjeUbFhdF7nHRDPcSFa6jd+uOl5vvsSW10/S6Gub+Vsy1CV3t0Svha/8hRBKGynZQRSNaeWzirTm7gw3lRSytKfPVVklY+dHsZoNZ6dO5gHpldFZu0X5EX7VpnUmmIkIf/fXfALE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34a778b-5858-47d3-d813-08dde49e1d5f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 12:43:10.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LfytAC9vzSHOxsQlvgjSv5xLHKqBdOUm3A/G4V3NIYb53IDrQJoeK1J3ISdKrMQGA7RV6nnl+iwR7XNl6dY61IKgSCWH1k9jbvpe3CQq3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfXwnOIiI1sLwIA
 6/yF28qKaEphckis1ju9LPIrwLkH+dMWtADt7GQUIpTlV3DTeZQJEtpHwD7tHE8ctyTXqrks3yV
 H8jb5NVAKHmb3Z4oOFuHgWSpJYDK4ipWmT1lD6Cr6OFWZSqlYr37ep3VUk/bkH4UH84xaew1UTI
 N2Z76vyHFrPp03D152Lk4U38qMAbACnzZbLwmeDKB6s8JSGhjk76YCfDtGsbq1Q0lOVI5GRVOWe
 /amJn4D2SF8mMaVS33wpTI5xNZDV2x+H8KMOEiEpFX6szlLinTy+UOa4t3hwJ5AZC6hvgwxOg+j
 ajdWjoiEBp5Hvj/wSqTdJyYTs6E5Y+vcn05riFX/BG5Uqs5YdvsrdKpy7dvzCAs/XCvOXqCL6sP
 Ap+RR4nv
X-Proofpoint-ORIG-GUID: _EbmELCFk2br-nw_VtIBMlCG1Qf8DJb4
X-Proofpoint-GUID: _EbmELCFk2br-nw_VtIBMlCG1Qf8DJb4
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68adabe2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=lgicOfLSj8L8v3xg:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8
 a=R0CVSYQ2BAEg1iNY8hcA:9 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22
X-Stat-Signature: wt89hwxrppnpxxkhohfgsj8jku744yg1
X-Rspam-User: 
X-Rspamd-Queue-Id: BDFA6C000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756212237-968659
X-HE-Meta: U2FsdGVkX1/y/lQ8t/LOKcnBmi7zm5u09QOjxR6p6kn3AxmxGGpWGr75Ez9P2zjMzYrkKhcwdaT1XFkJk9oGTZFQENpBo8n/6vRy/HW6AhJWncs6kBN2RdDkSuWUmT0CEGRFLKAUdkiETTZOudC/0pTKvcBMYgdc72/FbxTXef5eAMwIvf0NArx6DLbU4i1KZBVAll0Xt3Fp6BP04fXkLaaSCW0K0uxF3sE1LZzW/+0LZLhd2Oz1UgKwStQhfB8KoxqK/TvPFLmkXmldDc+VF31xTdWP0WO16DffA7ZwlWIFd8zovgYyvbBOkywYaMgcGq/W42kleNyiU6gieIzevx5UgURqckw5qWzynmUvSvJbEgNXI0ikwQqqRhdokcBnoqeLJnqpnirqvVIpkP3/Gr7KlqCQZgnnXyTnAdDD/Z8tlg8OBQ4Ns4FB10szFw3RYpqYSQVoLw3RGe/dWdGhQPZqherfk7moQjyw9ifO2HQBN+Wwb7LqtrKMLheGj++UODmm+bjNWd2kbKQU3d7qTk6GHD8kxgiE7kRCleSglUWjT2neuI75ETN7IXdTFGY2InmiY+3WSY4YlzMnixAe/DjluJzBZ0AZPiVS8KtQO/Tey6FVlzliEIrvdOi16dky9kzpLEYJzc7vB0eIQ0UkYx5B0YryBCU+jRzWCgjdVA9UPTn7BwSCyFV/iXoza/bQjq1HhPBOwUvMB+IKV6C6yyR1esjAEAGJ8kUcP59NaHms7PnEOaH/hp5RGZgAerxzw3hiUtXGTygVIX4FffxTnBQFgtGE5egLHn53jRC1XKfFzIhGBNlBx6oHOd1StoyGhTzMR6qkPNmb8sHLUwGvkG4P4MfLNcuDMakkj+FI6Ox+XsKHMCnqYjujIcZmtpKxt+7Lak21tIoOVw04IWhMPf/lBEEVKK3xEz4fgr2Cyi3MIGAyuIm10G0TqTkC4RjYqFAhx8o/zHRlwNR0qRR
 VpzyYgz6
 GaFOoQc3NHXssQrpr/+8BCiUI/nPgHvou9Aj4mBshgAN7OoQvM2Z2ZpErhAZMoprCDZjwXPL9u4YlxBtCVrFpCT5NybCXCHGzyKitjXdM1PpENG6MIpturRKKZM2CqaWfOQqzjvj1aH97/Tw94GHufBJ4MjXLEeGGgeZqWSFVcbTz37hJqquFzuXvd1sZsEKCOV5L7dyyInrjVbEgEINvqYKAJuGpz8sF9k7aYNhsbv5tSFueJkS8cihW4k0oxBMJOGt6Ysji/P7rWdk05SErTDDyuhPgmcYF8x72QkzKoFjxvkCCx2J/380pwYOQ3RKDD2HxF+tQMhjwJZw6/nIxfrmvA+xAsCRb8hFPwiPFTADCECpuGrjrszGQaKI/PMU76Ek4Mi35xvQZSCEN+ciqW+pgaqjzNSg+RsXDbL9zwdvzzj8Mw5osx399keibnHYPIytRR++Nxz7u/H2a+MNcNihRRxwhoCREXFM+mhijsQC8eqB/UwgYr2aia9JvreGxb/KZJa7s8Q0Tz/hMcuW/CCEkSgbFsa5XSUXQtX8OgaijNI7k63pzxKw0wpgvpxVz/mw4pRloFxh/Wt8u7JWEArhvumjv4Zl5ZO9e/ggxkHzHSFJTLvvh1VJUjLiDqElB4SXqvnJ57pe14nVI4HR/sXDN/pWChrTcACODAey3TN4GakXEEV/f8Kg2l3K0nDfnKvLc5hnbHSEdIQFrlDtx4+Bt01EjveWkZt1RRFTdqUlmHq68K6ypEjMjdZoq5UU5iYUSK6VotD1pqykXysaDk5iJVzrHhLdaO9eXqlNa/UlqOliIioC5zxeXrT2qHxcHCo8r/g7PbXC3FYiPThDIabCH/SmPeRxKoJwrFBkw1g6UXX2XQJzf9i5rd2ZPyacFF34v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 09:38:54PM +0800, zhongjinji wrote:
> The OOM reaper can quickly reap a process's memory when the system
> encounters OOM, helping the system recover. If the victim process is
> frozen and cannot be unfrozen in time, the reaper delayed by two seconds
> will cause the system to fail to recover quickly from the OOM state.

Be good to reference the commit where this was introduced.

>
> When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
> will keep the system in a bad state for two seconds. Before scheduling the
> oom_reaper task, check whether the victim is in a frozen state. If the
> victim is frozen, do not delay the OOM reaper.
>
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

This is a lot better than the previous version, thanks! :)

> ---
>  mm/oom_kill.c | 40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..4b4d73b1e00d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -683,6 +683,41 @@ static void wake_oom_reaper(struct timer_list *timer)
>  	wake_up(&oom_reaper_wait);
>  }
>
> +/*
> + * When the victim is frozen, the OOM reaper should not be delayed, because
> + * if the victim cannot be unfrozen promptly, it may block the system from
> + * quickly recovering from the OOM state.
> + */

You should put comments like this with each of the predicates, so e.g. this
comment should be above the frozen check, and then you should write equivalent
ones for the rest.

However, if Shakeel's correct, you can vastly simplify this further, so
obviously in that instance you can reduce to the single comment.

> +static bool should_delay_oom_reap(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +	struct task_struct *p;
> +	bool ret;
> +
> +	if (!mm)
> +		return true;
> +
> +	if (!frozen(tsk))
> +		return true;
> +
> +	if (atomic_read(&mm->mm_users) <= 1)
> +		return false;
> +
> +	rcu_read_lock();
> +	for_each_process(p) {
> +		if (!process_shares_mm(p, mm))
> +			continue;
> +		if (same_thread_group(tsk, p))
> +			continue;
> +		ret = !frozen(p);
> +		if (ret)
> +			break;
> +	}
> +	rcu_read_unlock();

This surely in any case must exist as a helper somehwere (bieng lazy + not
checking), seems a prime candidate for that if not.

> +
> +	return ret;
> +}
> +
>  /*
>   * Give the OOM victim time to exit naturally before invoking the oom_reaping.
>   * The timers timeout is arbitrary... the longer it is, the longer the worst
> @@ -694,13 +729,16 @@ static void wake_oom_reaper(struct timer_list *timer)
>  #define OOM_REAPER_DELAY (2*HZ)
>  static void queue_oom_reaper(struct task_struct *tsk)
>  {
> +	bool delay;
> +
>  	/* mm is already queued? */
>  	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
>  		return;
>
>  	get_task_struct(tsk);
> +	delay = should_delay_oom_reap(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);

I mean, unless there's some reason not to, why not simplify to:

	task->oom_reaper_timer.expires = jiffies;
	if (should_delay_oom_reap(tsk))
		task->oom_reaper_timer.expires += OOM_REAPER_DELAY;

While super spells things out and avoids the other noise.

>  	add_timer(&tsk->oom_reaper_timer);
>  }
>
> --
> 2.17.1
>


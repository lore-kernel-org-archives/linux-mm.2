Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BF4CF857C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690966B0006; Thu, 20 Nov 2025 04:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668116B002F; Thu, 20 Nov 2025 04:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530F06B0030; Thu, 20 Nov 2025 04:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4006A6B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:53:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5B3BBB4ED
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:53:48 +0000 (UTC)
X-FDA: 84130523736.02.3D882E7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6037140010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:53:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CkgUJtU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qsCckoAk;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2geHyyN66o/E9yeU085xXn9+DpUDDdsfcBchuee4/Ps=;
	b=dcbheMmxaCT4Cr9BfcffWnVShBLWYaG6xpyCdcDGLr8vDXeMgYe/LOlTpgU6iZwGfWs+/n
	kkGbqq3WYnMcHm1S1twE3IuP/alVPnMcMXMAvLli10Nfg3Qlwa8oSCSLq+eOCAKig3jYPr
	RChyNNin6uvDtf6eGPqqBtUkabIKrd8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CkgUJtU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qsCckoAk;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763632425; a=rsa-sha256;
	cv=pass;
	b=KFedSJWtGgvLoYrIyF/3+489+/XCqR0Mk2ENnq8RjJRVPOnqxcWBdJZ4xyTj/4Be075Wkb
	l1hxz1l8i6qxzb9xX1Ss6EaTrYJ9a5bYp/kUT8NytHVaTLno9jZnG4HvwkMiKWO24PVgHC
	pcmw6MJOtEqr49xhb411gIplg/oMrcM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK9Ha40030727;
	Thu, 20 Nov 2025 09:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2geHyyN66o/E9yeU08
	5xXn9+DpUDDdsfcBchuee4/Ps=; b=CkgUJtU77/nZJeTG1CEUe9VyHkW9gFzfKi
	LL5Jaz0McnK9e3cx/k3ec7t94zcsWkZfj5x4NfHDYr8GZe6azcnOnTVFQ9xNfWQV
	UjKNmml3lsspyu37iX6bcCXKLdC0tEDdV+mbTzPQDFjPA1hyv0VBkAXrXWQPXSU3
	NL9eKKi0JAXwPfgKQwCiPSnQLkUhISTA46DDyQr+xm8BKSpQh4PJ9+afmUS1P3+P
	YA9/Ac5GX5aH1XjVv5iAv/qVF9BppNt2zR1ryY+NQ/QeDeQs2qcZDmRXE6VaFeDg
	k1KK4lNfxYZwYDsFsubKm76wKUyAYIg62RNe9uspkNuvcq7EFuTA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968s1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:53:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7faPh035884;
	Thu, 20 Nov 2025 09:53:26 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyp3rcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d36eSlP1dvapxOT34o4wr0WGjkb5bvZ4+WC56YeFvO3/lN4n133FJWlQ0S7WG1JiZ0Q+17FDZmYN7NF/sX6jb8Vi6ZIl7FDQz3TGpe4T4g7U2wc4WvbmovekbYl5YjdOuGY+Ftm7M9ABSsOn3qwerRjv6LQJu1/bvOxArWUd5Fs/Upwn8IhbSL8QWmvFs1bjMAA/lNa94ZcyvNrY54NkkaX/9zi0GlWOEZ+UiLWwO59rZphlfpYsZTudnyCoLZ4V59kc233fnWS90mhiPsHj+UNCoz2AdRotqFx4tKufzkEynygY7LYHUjBbDpIlqTc6BU14kOZQNN73xQNT9HLZ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2geHyyN66o/E9yeU085xXn9+DpUDDdsfcBchuee4/Ps=;
 b=hsyReSjuraqkJF0L7p37guXquHB1VpdkJd3y9Gs8ybCxo5tqPY79zIAoWyZrVxL6rWQzpIS1KXKlzKhk65qMH9V23+DI+69YUYVSlHqQrwblLWK93FniKtw8cutZhh4K33qljX5oVQIQV4r1fTxaod9SqdMU9l5btGkbK/hs98XuCgHpJsenqEnj5zX412OV1cFZlGKc7g3ITsVzJusAxbJj74pDecYcoRaYOEHB1AQpbed49YRmB90xHa3NjmsM9uTxEWSUjYY6qRFHQE8YDic9E7QXu6Yblj7Jh2eNd661yfdypO0gZlBL9iAs99ED9G+z4jYIcTbLFB+t5/TyIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2geHyyN66o/E9yeU085xXn9+DpUDDdsfcBchuee4/Ps=;
 b=qsCckoAkDHh7hwdWAmdstWXjpyAmgB5YBX62VONta8G/KP47YqJWM1tdwwNLyZDmjkneTvhVCvqTFdB9nfY+5YiOhr1V+8bOyFR4ltLp1pkvOj7EWYGmPxArjY1guwEnQ/61I8ds1ZaSEjfI0FmWyrpBk8eyck6uqs49IE54X9c=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 PH8PR10MB6291.namprd10.prod.outlook.com (2603:10b6:510:1c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 09:52:59 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:52:58 +0000
Date: Thu, 20 Nov 2025 18:52:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
Message-ID: <aR7k8oFb_uZYj5bj@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <c8b190b1b4f2690f12dee0e334e4c0b3f94ad260.1761658311.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b190b1b4f2690f12dee0e334e4c0b3f94ad260.1761658311.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0096.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|PH8PR10MB6291:EE_
X-MS-Office365-Filtering-Correlation-Id: 12b2213a-df5b-43db-14c2-08de281a95e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VgK8ZuZgrWvok5CtKamXjJKPRcj7qNgNYOZEupJCIjz7a41A+oIOgQyn6Cwa?=
 =?us-ascii?Q?+kOFmAwk/c+jkGiGTdpp+p0h+wcVv9FKTC++hiccAApUZ1u2r1ahvK/KfkkL?=
 =?us-ascii?Q?waF9d6YcNXslvYULaQAYABGL12QmzADZ83dxWLf8hMkD2WUEf7c2cEGU2yxZ?=
 =?us-ascii?Q?TUCfa1lSAAz439nVLOeZBvFhD9BhhhzNm9PT/AFxkRLDDt1DrBIqSFRXHtjG?=
 =?us-ascii?Q?PGds3cA9AJA15erCaJ8ETO4JuioQJq01ZuGcfAqBi4eclNd1A+1fdLn6hXIm?=
 =?us-ascii?Q?BBRd5jPeTbOzY4Ms0Qpe5IW/13kcgb1gYue7L0jWhvkCxN2TVqERwnACdH6b?=
 =?us-ascii?Q?RFNpBjk3RotSegyXZmzcaCRVfXKvV7gec8f1ypDMsaEeukEiYU5jvKzDd+sk?=
 =?us-ascii?Q?NdJQIb95zvlsFGcVMiqHFdnY46QxAvRGzCAfIhsqypIuLBQU60gNLBadfmp+?=
 =?us-ascii?Q?7/qLIqtpcMcBzcBLlJdpmJr4eqJANqFBvditwDjxK13J8mXiVRZq+sEiW4fC?=
 =?us-ascii?Q?+gVkp5xLXCTNz1QKluDLT7SNcOyS7JSUyyhGRSEKkuTZ0eaw1BHb92xGTd9R?=
 =?us-ascii?Q?k+rQ91tUlokeTNFULNDU1RW5kX8UNVCdsGhMtQStdMygMHUaDyCx98/PhTv4?=
 =?us-ascii?Q?0DlpafjE1MgNCb6oUrm3mLgnhdoRGi/eYCqDrZzSTCo84gqkoEj3kL1T86Xd?=
 =?us-ascii?Q?gpYZOZZD4t55cudTPMf2c5saUwOSYQjtcQr72Jf+FPQn4+TelR8MXwQR5H/V?=
 =?us-ascii?Q?/2BazoQ2hQu5Dd9WPdq1NqQWsNIK8MzE/7Kb6054WhTJW61HNk7teb7/gG2D?=
 =?us-ascii?Q?q5+Ael5m1Dvy420kqiE2imDV2LCGnuGZuW9fge8nJfedBmr30R+C8rr06/7h?=
 =?us-ascii?Q?sVukEOn7a54IN67z9b4w+2e0nvLcLDnnSczR0hmu3vtjXshPtKETWZAP1H/r?=
 =?us-ascii?Q?3nbjXO9GH97PK2NfE5YxP85UAT/e/s14MZdyZIz6M/vETMz41vrpUmVIfn8p?=
 =?us-ascii?Q?ppHt/SmzwQmprFXt1SpuZdLcxV1Oe0BS25abS+IpntnYVd/PTsqGWqzkiL9z?=
 =?us-ascii?Q?nfNoBwtFeEZENL1Nnxj3RHOLkPg+7kVa0AFqJYilQgQn1La02rF6MZTZ+MB7?=
 =?us-ascii?Q?RA4Q208HaBAQfJqBHt73XzAvO6nnOPqMmgxkbInBD0OuZzjW7Y97/7IsKN8x?=
 =?us-ascii?Q?OIroqc7AdN1jSGrIardd+PARnu6OYiLEo+vrSYh0E3nNQVIO4pnkJ5xMcFzX?=
 =?us-ascii?Q?XKMYVIM8h6MxbaRxeVoSLvr/206tQSQWBFHgrOS3Vwzk0d5ldQgUNux/mKlT?=
 =?us-ascii?Q?w5pjpXzxVfpjmAttfIe/e8vW0ecoB9gEaI+z9QFgZnJTXzdzY3Zah9ez90F/?=
 =?us-ascii?Q?ghXFEph7uUf9mJ97DpJkynAq7zFd8oJv2v3WE1HYwJFJHeJP1GuIEgnQw+KF?=
 =?us-ascii?Q?N+26HAL/hzc/EGam/YcJcw1yd68W59OD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M7prznHJIVUalvqQRgs6/oXfQyeHUDOpk7nau66GDASmNtps+b3aHT86IIv+?=
 =?us-ascii?Q?ddOZ/OOlOHP3WAe0rxui2iN6WbO9TihlSMqvTfNfgR4aR1957BqyYvcxOzJe?=
 =?us-ascii?Q?aVwQNR2pKzZuvbsuW4jxONDpyY8daAQOBtYzyOWQ5ZIboHzCncFqDKkiQYEN?=
 =?us-ascii?Q?eCpUe07pHlytIHfi4HquV5V1SlOXrN5pTAT2nHT3EVK9f+2ijugfQvpAbV6D?=
 =?us-ascii?Q?n1aN1dV+1znDM0CWrLbqsQLoEdOB/dQT7kQhST2YKTvpMdRYBbuXPifND0vz?=
 =?us-ascii?Q?i1ITNRr9OmZHF6JNGe/TN2lD1EefL64Sf5MFg1bOWnbyqAVJ8PqD9IQBpByN?=
 =?us-ascii?Q?tW9GmK4mOlCoiO0TiLjPMOoqNWxNmU9HzUgvqtmxdWBsUtScFWbSfgdpMsCp?=
 =?us-ascii?Q?XGFY/XNRaKGoBBUnqRrPGcIWwwJepeoW6RwZqVrsDj2cnjc6UrldT7wfNIwu?=
 =?us-ascii?Q?GIzmo2AssL1ddQyHwTG8lWVh9SmV2FnWVpqDVp+iGgECN7YC0KLjn9khlZrw?=
 =?us-ascii?Q?1sjYScVs4rpSCC782mx+CqEP1Y0aWggLH3QX/qpYh7+eTIz2hMj96r0wotkr?=
 =?us-ascii?Q?/wxOLdSuRjfjXqRoebYEbNUhrgIyk0tGYHtp1dPfpoTWp7yjEsHyVQbb1IPz?=
 =?us-ascii?Q?dYU56auX4UozVKDyTpGApWtOYEJeDU03PUWr/u+hLMhsSj2cCb6RWAKV3Jbb?=
 =?us-ascii?Q?DY2E95RnjuEgmiUjhEq5blZQCkeKo7kfal6HDYm0M1wLd/3qUtKeDLHDFatj?=
 =?us-ascii?Q?hMNSdTLfN+xgNhd8kgycIW0wIWrvkQ5jX6R8bD2KohRJd9EFl9LqQCt/Ag8Q?=
 =?us-ascii?Q?xrXXdWkhIK5rgKW3dCTm7UuRJ9oo1r1A19E5MadPyUy9c/JxmuFZu5VnvxJ3?=
 =?us-ascii?Q?HrQh5TCgEyvD+fG+D5YTL6a2+/6zG1nvHiViByJ6DzKP/lsgLihTBkA1eaAx?=
 =?us-ascii?Q?sJ1ffs3Er45FS6aQdjcowKprbev5TpQnDpxduQOAEehkSqw1tR14Pkvuvavw?=
 =?us-ascii?Q?u3Bgrqwjd+ZfQwXEMzfEBAT9rFC+W8sO10rAknhXS2U2Te6afFmVvDKYp+WP?=
 =?us-ascii?Q?C5774I17fexsJIuTdKx/Ogg3GIgu+SAdULb79EpU9eJmd9VsWeUqmYWxw4jl?=
 =?us-ascii?Q?XanK8L9HpW01jKKxB0Gc3HmdUYNlUacsg9OCeSlfzB63Guet5mB/yRzbtjge?=
 =?us-ascii?Q?naUMLPiSutf9drxOPkWswaKiSIuHmX2YfIVhYldvz6OY+NTyl05oRBR/iS9T?=
 =?us-ascii?Q?AxI4ueelBmysibyXFA6OUn4G517PuyzB7/6xGRIHHypwbZ334bwIJpiclpKl?=
 =?us-ascii?Q?CQFPx6/HRqSc2om2SnaV+DtQVNNWrx89MXQWww2q0WHZ5gFoz0KZKiYrYDtc?=
 =?us-ascii?Q?Pwyt/noZmVBpjP3/Kg4zs0FHMRBPVj1od/AI4jCp8OneDVyAN/tDZHPK0cPK?=
 =?us-ascii?Q?zXB5D28WFd0D3EvLXVbpUg4jN051/8loftVZ81gQ2eFenmlkjz4J9pXBPOmA?=
 =?us-ascii?Q?tyblP9hLq8LMsT5lkHBbGkixlPZxTCQccYF5meIeuoHvdVFt2iBFHt7nWXIZ?=
 =?us-ascii?Q?+ImoV6V9bJvowdRzqiu18WX9bbJ1LBWIjjUVynHT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VNz1n2rQs94tw4U8iXhjcqlvCP2P7Rzswm9ArLbjdLgR4STVdmT3SE5MXN/BBJcugqpYB3RXLjOGoCWQpI4ynLDGALccf7fCIkUDC2uw7aV59JXV+c8TGHQaorQmJ7heOuXUi6UvbHCgaaCz67g47NE/qBPOQ5Oad+wu8lM6eIB84oXduvk+zrMSZxxu7c0Ox7VKDBemaPr80Q3CZHZAx5dpGMcYWKb9q7lD1Spi7nhcVtbrdo5+ypL3Yo6NYH65F+jIuo9xjgJqEh9OHAhfNggor8lRgDDTlPuYdBliQll/fL9rnyd8XNdJhzgC0tiCpsgB/OVFfqSj8s5ZZa77KvYynGgk9H204q/Dm93ntWOLVGKWWvtkN6VgthYmFk37v+LQ1xgPLX/wsMqR997hmYkqb+xmvhURWvKTMv+aW5V8KAYN/LITH6bMT+ac3vONX+KN6WwDEtnpOhce0CoShxatYxYHgbiOlnDazlzOJ8IGrsITKFoVxrndKxNMGzC6fAuVgenBRbWutJFxgFSGHLb3mKuH+wWjD4dFXqU84dLO4j8D69wrhF/9zxSsGJuIUI5P7Uh1qvRa7wZb8n75CuaH484NljvviV4mkFKxQfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b2213a-df5b-43db-14c2-08de281a95e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:52:58.5154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnsthoeS19hVka7iPSJ5Nn4vwbBx0tlCGm7lJibSPHPfw8Vq+A0w3egroroP/8rSn+KImx5/gEoSjCQXxovy8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200060
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691ee517 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=W9BqLgzXg1EqYeH4nf4A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12098
X-Proofpoint-GUID: vsOIh871AeeKr_FD_hBXV7R4J6K9qdUv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX8HU3xlo4PHSH
 qSTaTfcDpUU8WkiAVyF7s3KjJSdzNxpPQJdEe5ZAG8NfC08gFnYD8/dfIBpujgOVeZ04evob8ys
 /V70Q5vhKAzc/+l9nIN7GqQQBb63UvI1jEJRKT4Dq+QgOgW3AvThhLxw1qR9VsX/uRfN6QIO8Cx
 xvGuRgHsVF9Zz8tuMEEOCAg+wP7ypWfmm2yPOoV6hcL6j2gTnrxl3UyY3/VxjXMvAY8A0HXbNtp
 +/HxQrVVj/ilrM5RFI57KSg0xXmSHVOTpiPIqIq4rLg4EEDHL1KAT+MXEWL0XwJevftkQWFzaiy
 qXPP3VXe/gvhtladRRq+jYDLyXTwS6WATg/VBFeEBQ3VT01xj4qy3+ZHRHjqsjydHXxax74cjWi
 VI6xaGcuEb+t3m53v1H2sb53Y7Y4Q+y6iUzynNN8IAqvDKA/9ts=
X-Proofpoint-ORIG-GUID: vsOIh871AeeKr_FD_hBXV7R4J6K9qdUv
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6037140010
X-Stat-Signature: zhfd71oamsky6wbmr5zzfm494yffcju4
X-Rspam-User: 
X-HE-Tag: 1763632425-644317
X-HE-Meta: U2FsdGVkX1+6pVX+DuOwhFR7Z60F4lh7C1/d04f1v8PwXQsL+WchtRUX1jfSNnS0uwxQT4Cwr2S8FEzhTgFppLWdAjPvluhpuOJ4Mt3lknvvQc/mClOZBNde2AQtmWUZQh093Dp4vfquwftwCN58RHAFCz1mtQyG998ph9bQ9aYy3ZeX1zSkj/vh9WqC+fm3jioZFpjEeFyuzWrDSJcr5XdDkhfwBm6ZGCybyGye/klGxbZe3F/cuyf2FtPKku7WrJZKj6LY5aVEULw8kiarPOLX09hp28iCjFoLPRWvcuh2CwBN8Qxd1Lh5sii7pdicVXb7tZrHmLSnQMGysiK4APVEQss5ywv4eprpPVH+eCbdeK4IizUf+4SXbRYzKyLWUcVzQIiIa/Aj9XNhOOk1Jbv+vHM2OacG02LoFkIu4H+RFaAN6vNf4qnRAu3tSUX8vlfu8GsKh75U04JpOvxxc/f9fSpdWnxcXlxmexbUtuQP9V6DlnyllI6iU8yaf+t3UoNepPhsLCxkCXlHdvWl/VlI7cfTIe3SOxmtu9DuNdsQNvuwbDTkzSQx0MCDM221mUxSpARbAGPLOAhPzqNTs/y/nu/OZbPbZYjGt6rtOMCeFLV1FBDskoEIwEpiQll8rpSK0wxJC4Rn2D2VILx8+vbrMfvwZgaMPv1g1ZzjcNrtScGif3bpKKjoou1fJY1bKPiAsz/3pVzca5HZ0cevd5A7OEIA9haQSIxmMpaDS6UDKwROngMzR8zVuV29h3uAO1AWIOgi/wjsP42+HjX1NtitmYpf4C52Qzo/0NzVBlqWVPZkJoanYVe/lKfuSZwTg+YMHwLtgahwgC4+WAV9t6b0lHbbFAhvm6g2+rZBkUTmv31+W9vhWVs/AIHuwXRpMVrkAJHIHfshcM2IFEsX8TvkJo1BfbLBd7QvXXbUsUnI3Kzc6JgFpN8nHEAQMx5GqlBuYcHl2vEqgStsMcA
 qY4skxCw
 d2Y/+ABCb1UfxKW9V1NnHp6f1+RRijkKU/WiW6yQlHhThlvezkrDRPtJI5TvYdG21rdIIAbLETyXoo9A1gzQmY3HgU6GORuudM1530o13KQuqdnz6AUDjUOggI5qALYzCdytxXZ5MLSlWsW/F+dEuJlKQOqgrZ4ke2JI9oYjbxECmrAfhemp2L707sjdxdIUhDH526CMfkMlNYJHpxBfNe3CUGFi/gMlZOUQOYVRB58IdLPor//uNKTI//WOcNeJ0SaBW4EgiFJuELjqAmb1DINpOOfNBM6DYvtJ/JjwDxOOwgsoJAQeFplwrpYmPGpeixg2VWjFWqkSt5Wb9iS0YDPK0S8COnSvv+BKcFeKLOy+EdjQhEo2cCOb+8AED464DefFleTpuG/Y1SrkgK9S4el82+clyH6w16SZXM/k4bZ1BmRbPz+T9wCw3jn0WgIxysRODN0J7FghDuYPFdKy2/y7MBMn9iqEEZZ+2cCtaGKvfAo8Tk3H32oDmb4/JZEI2ECewiIsXgfFxGObQ2BzqA8INov+cWue+oUcVD4G7oGYsdIzdD35sG4uUsuIkaTCj3q8Ue4+w2d6rL6ODDeYz8IeTbKRB6pZ+O6ixqknyS/vZu3VWYAs/8PqHdO/R68j1ISWX25qQmYRbtcTjZYZlZoaIbmrHFvWGmdur2xpqMr4kZ3qbu2jp1QKucWINwCXx7HJJe7ZetAfO/PA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:32PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in lru_note_cost_refault() and
> lru_activate().

nit: the above paragraph looks incorrect.

> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


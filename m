Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78BE6CD0431
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF13B6B0005; Mon,  5 Jan 2026 22:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC21F6B008A; Mon,  5 Jan 2026 22:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78BC6B0093; Mon,  5 Jan 2026 22:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B16266B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:16:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CA8A1A034B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:16:17 +0000 (UTC)
X-FDA: 84300075594.28.5517FF3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA78720002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:16:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Km5VvDPf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m8q8lAt3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767669374; a=rsa-sha256;
	cv=pass;
	b=21pVFWQVGqb+7K549YrduUPO7qISSyDRVocre3u0aoAAu5ZUjXqt94DqtP8boh2A76KBZO
	nACfY0hY1ffDd+fLYe25foLraq1FUQc8fXJfhL7BNdLFT09Ch3nV0j2RySi5S81xHsQ78f
	TcYq08VENVsIzKY76JeM3vj9mZ43Yts=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Km5VvDPf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m8q8lAt3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767669374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/50lRB/XAkSglrS1ZTpW/Zs/HONw8fR+4BILNacqNw=;
	b=MvmsPMGRnBbEpgZuNT+Tg0jPOqgThzQhahfQj3odizBDgghb9mRJ9rbQoyqIHWUPJRZrJX
	D7GebdrJ/1cA8PrOUDxS2Z1YvyBJd1STc7VVqMlrQCYXTzhCBCxWmHIW6488MWhZlZrUki
	9W7id2O8bbkEnxisGcR7Pryw0yByy+A=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6060rKVH2667997;
	Tue, 6 Jan 2026 03:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l/50lRB/XAkSglrS1Z
	TpW/Zs/HONw8fR+4BILNacqNw=; b=Km5VvDPfEDVT7IeztmDWt1X2cbwmIZgvnm
	cTCYx2zsRcCshdbfjR52ldvCiK4p9hiApGvrSfQhhXqjvQTmPy8iNKHHtsq8GJia
	ElQn2GN2PTL6rfzZTX7+jrKxDE7J+LmbZVnoUQ8ieUg9MR4MGHBZttj8U6w79jmz
	CqxV36YEjhbkiQoXkDFYKG64QV44cWvtDc2Rl5O1Or3NK9lpfwtN7e74Pt0U7uMU
	EBPOVsD1TuVeOzcWeb1Emq1YBYv9NwJAPr2eQT+LFD/U1X52VBwHI54eY0nfPx+c
	iL+9xUsiiroB0vrb13lDB3pey2K5rvMaWtxzXC6N+K+s/fBD8cfw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgr82r2wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 03:16:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6061AHK1017556;
	Tue, 6 Jan 2026 03:16:06 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7updd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 03:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeHhsymCMKI6wutJ3BKb1NMH982ooxKsWsmkx+F97gsUcQ+jvwJ5qTcC2atgFJPPhIGeywClA6frJZSudKROONaLCDl4wwAYpvxbriDGPxY/ersnnqn7fKO2+FOxSaB3Pa7JQiJO7J0lEGZnMf+BsJU81mTbIJlPZ4rhm9DsI78Z0yWyWjskoaneZoIOxTPgyBwiqRLTb+FL2rMCpSt9XnnwVJRduPeFhBEsRXrE21cARzk2x1M+nP00TmyT4WA3OchqxaTeqwvgsPNhJmS1ZrgEY6MwawWEac3u/zSpw/gRmf6pWZ2qZFYa4e6tld91jU/rBTizvGfHhQZysK8vrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/50lRB/XAkSglrS1ZTpW/Zs/HONw8fR+4BILNacqNw=;
 b=xU88sdDBLej3ywiL/GFRH3B5hI88hsLkk+zeFHF/XRdqQ6HiuSB8tCS9mTucb/ctuXw6tD8igu3o5hYg0iylNPPBkO2ZHgyKZGhDKbxiW8yueoF/hG4Np2Bt+3osv2z5hpd9/XQLNv99JqFCebuQ9/2DUGk8NMhCD+f8217pEzKc49wJk0BSj7dRaUh8V5DHGjIyJ975+ZOqQUtk+xlknKWMKdxLgs7Z/PTzDuyXYPKqWddgeAg/7rE+MZ+6CXjQzcGgBMbT3pwJQ55ataGpT5TKdxLs5py0teXdnLoYkSve2lW0AdBUZN3o0STjymUjWkuvSUoldTijKZeJa2m9Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/50lRB/XAkSglrS1ZTpW/Zs/HONw8fR+4BILNacqNw=;
 b=m8q8lAt35BpzwLPrwZc/NAB5TR6WhKvnnkwk/298htUnB+nrI9P9F+mOFvCZc2HDNjnvKBga7Dw0M91f8nS5lpuRkiXKVScwDh4ytLFutcoxxr6UE9FRTS/9vB4DnIEG0W5AP4bzq6f1GNWD4TdC7EjctdeCGZn0zdTNZK99uKY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB6829.namprd10.prod.outlook.com (2603:10b6:208:427::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 03:16:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 03:16:02 +0000
Date: Tue, 6 Jan 2026 12:15:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2 1/4] mm/vma: fix anon_vma UAF on mremap() faulted,
 unfaulted merge
Message-ID: <aVx-aWZZBMvMMQy3@hyeyoo>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
 <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SE2P216CA0178.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd9a19e-9405-4d31-7cbc-08de4cd1ebc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d+ZNrHRSX9PYbAQ6pv3CONMs80+vHzo4maQKMoVXnT26Lt1NTnp2Gv/I/Q9E?=
 =?us-ascii?Q?ruxboSVsYXNU/rCg7F19eAeIktovOMQsIRl4HKDI7fWPNHFsecMkmorQPMI9?=
 =?us-ascii?Q?U23pQBxkVoQ1nODkBv+Hdgxio3l/HTPFx0rHWKnAMryV3uXKR8cGtNRU2sXk?=
 =?us-ascii?Q?S1VQ6CPpUTG2CxGFTuFNHaK7tYPPqm8GUTfrCauN+T3r4sT//9oaUyXJ6aJU?=
 =?us-ascii?Q?Lwf+Sj6y1qUYa7o0Pl9aSFUivcv2qnQ6iCcTgBmrklGxGawanNkePstOjil2?=
 =?us-ascii?Q?MlVzVvYSYchmwjQjcNIMnSyToWjC+rdREYQmD957cN0GiolZGlCv6cnsWRWQ?=
 =?us-ascii?Q?jYFVg27wYTesxSmhhce02GdX/j/fMQohpvQ9ABZ01T2WDfo3jkkmsGHnlbqA?=
 =?us-ascii?Q?a4cn2t4FGHH5kwtMz3EAhNaNErt30yE89W9YjWsxcJ7QlrqU+2Mms7ozokqL?=
 =?us-ascii?Q?3psFFTa09KOpQyyeW4Qq+QQji8Z96B5d7XhADGPplEsRJ8QAe0+ITiKUE1FY?=
 =?us-ascii?Q?8jP721A0BWN+7Rn5ZslXByZDjoCjo9dVqxtTAOORl0a+HquCBJSxJN+3dv8h?=
 =?us-ascii?Q?kNH9z9YBtJDWOY4C8Gj8AF5WEIJSZUp4y9n5lc3yJcjfQmNppLcJTSvcTf+h?=
 =?us-ascii?Q?cbxxfZXFoDAXLSV6KMJ7VnJJvikVsKO2ZQg/kHTxJ16yiDFenXhCuYHGWo6O?=
 =?us-ascii?Q?5bL6zeXaFwS9jzMM5et1X/jAPhC56uhh+5j6mNJVnG3K1lm4PrgGFiHqiWRn?=
 =?us-ascii?Q?TSlT/NOAVRZWENEm+0zIqt9SOOo2QpYJ4OM+wmkgyDWpu3bpJ6fndBrScKYF?=
 =?us-ascii?Q?Hr8uz5nuAH/+JAlUGGBrxSjC4VJALeKh97URJQNPsfzm+VWtEmYUoSdwgyuK?=
 =?us-ascii?Q?xY4tENao1cUR5DxrheKL+gU41eZo60nZas3zcrwB9Wdvc69no2716cb2Yhqn?=
 =?us-ascii?Q?m6xTlOKQfGOO9DdTdS0i7SPhhYO1K8iDcqQrpnEmOyiRIxk/i466CTWHwHun?=
 =?us-ascii?Q?ibxTVyOkL+eAGMff95woaWi/H3j9sVLE1vJP2pB7KIZvlX8hKE72ivMW9cAQ?=
 =?us-ascii?Q?ei+WRzt8jtp7CRB6Xq1fFPbEgE9n+kc0j+BDLTQqI7AztwJfxjhaUCKTzk6B?=
 =?us-ascii?Q?rnR2Ws+L65jtEostKPMp6Ic7H3QC+DwjDJei31t+FQRUmaP3v1wEx5DOT6os?=
 =?us-ascii?Q?UmsPau0tU/RXdmJhg8cTWR578TINQ8DN1vOJ1XIMhNxFpeAMXXyLLr4dmZXq?=
 =?us-ascii?Q?iNOdpDNJ85xqBlA2Dnfo/QQVRHlk94Yeat+fRGOUt09pbGoeQzRqvkZE47XS?=
 =?us-ascii?Q?qdLjm3NlGuy2bxzyaWuMuLsqsuCnJLYcHQhr6KNg8brTT10XKHowb1enOXNH?=
 =?us-ascii?Q?/mlM0zIhtVpkm6HnLV6AvFFe2X9ioairdgDtlU99YIraHxHFIH02d0lExKMi?=
 =?us-ascii?Q?OwTUUWCbMh0jcwgvHEsmoxIDpTd1LuV0gQYTX5D5+wRU1ngCfxACzQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jh/AnTTSKVktmZVRIHw1iWRykhFMKlTs/lmtkc9jfk6nM02LNWP9MapslfOQ?=
 =?us-ascii?Q?GCHPtrpoVMkYD6bqUWThh0f5sCO3Q9D8EpU0Vp8v46xIZM2k/69dXvl6bo/Q?=
 =?us-ascii?Q?wu0ZC/4uoLExAUfviJ4naJk9hcNjU5XFbyIGtgzrZN4Zl/4sKSyfz5Un17NN?=
 =?us-ascii?Q?viRSon6C6aJvmaLAyWhFQWZ7CVy/0OnRXlCLicwjXBnEDrsNSr+5bzbdJRU+?=
 =?us-ascii?Q?w6SgtyFXLW0pnZoyGTO/1Dp+pgJdFSPcKiqKI4tKctWP9SfhTIlUQmzLXeaM?=
 =?us-ascii?Q?ZCIls3nyrWNeDeGQKH1EvIhBl60pEFYzUrc4HtyLlL/iGRoxMSCXih4aQlTe?=
 =?us-ascii?Q?yIvYgtTdtQYhC6zKskratO1o1gTQivkfYd4AFE/lgnPbeYKJoZnhLiUh48UU?=
 =?us-ascii?Q?sL8iobVWg5czTYRPfGLpkCaiJGUgcVMsz1UYDkymnjIKf3pPDE0hU1LSe7FM?=
 =?us-ascii?Q?DgoN91SaoUhHx9SaRW9/QQ2vI9QUu7A47OFS3wC1THUGMFVLCL0MFxA0JOQP?=
 =?us-ascii?Q?tNQgDcDddUn5aFq99sepZv7SQGV31fMCj8oFclrvSnKJ8tP/+kfEIxwYSYK6?=
 =?us-ascii?Q?xjpWqssIYXjGYXHCewPhqGHFXPcgh3ernRzqxs22pawIc+t9PgZHRb7OXiAf?=
 =?us-ascii?Q?NjTgUvXcPvV5ZCAiIZUT35Yair3jiDW7bxozEDsYGhpJOJswUWWY2K3E63j9?=
 =?us-ascii?Q?JEq3c8cFDlQ+zsuajFXMAs22MY8duVzG3N9tFWLVCFTGzUtGDu/836RyKpp0?=
 =?us-ascii?Q?NZBzm4lCsjWmR5CpXejs6ZZcwBELV6zQfJTW8/qbSrwVSZmFMtcfWsxoG0Ss?=
 =?us-ascii?Q?VWIsoaaZQbnI6Ptm/0lSgAhrLD+9rSk13SXBGqmtcSmdNyY1G5ldas8MuSLi?=
 =?us-ascii?Q?BkguTLrq9EyCgsvxd5TuzS8H04dcosB4D46VGH1MUpxrCHr4vbBHWJIUxLwj?=
 =?us-ascii?Q?+lMocZ6LSrqL2E3DFx8ho064dTzWYw9DTBZ8tO8G09PgmSvrdZ2jtBLAb2O/?=
 =?us-ascii?Q?vRO6Yku99DJMvVmNdp3V6Ag+6bL+WULIMSa4OVPnXi/m1NQiZLUnEz60xoWe?=
 =?us-ascii?Q?z1gtntGN1otCPHLioftKzxprVvqLxHmqsNair/f/WLOujof8qj9FhG71UrVQ?=
 =?us-ascii?Q?dHllfLBJT2aZGQF0kAhJ1AknflNzUl7ky1/gu+t8zPF3kS1iUVrezxtsHEhk?=
 =?us-ascii?Q?Mx31lN/j2SSB8JjG/d7/SPmMV1CKy0QnyjK3RLILJ+qd5rtg1E915sgRY4H3?=
 =?us-ascii?Q?9EKgsxf7wt/BqyFx6O7YsaP02Jzy6xDmHh7eoB6K+jzJToCS/jWdJ0bTn6rl?=
 =?us-ascii?Q?z3x12qKhh3DzHKzatFqkwxX4hUI9jlMY10x5ljzcOLBMyIjm+ZdXFV6vnrTZ?=
 =?us-ascii?Q?K7Z/NFjJlRQzrfPmCIpwFeoAD+uWj+26EInYgTNR2RxtUv2mf1ypmpXp4h/i?=
 =?us-ascii?Q?Yi6+5cCXW//IIwennTLwifR5NsaC+c0jG58Re2xMk1tDJXZXuoA9LQxqAhF7?=
 =?us-ascii?Q?bfXfijG2I5JNzJRY7mwarXp6lCd3T3Y0aUwbU+Av+bSnzv1bi3R6SL2XVtbE?=
 =?us-ascii?Q?BQatYMER/N+EoMVK1uOLBUwFJSRrkhi6eWchH7/rlQc9ey/vVMf9OokGLAqe?=
 =?us-ascii?Q?1+SEJUXUnUaCmWGARu9kwms6X1a+R2Rq4O4rFSmu76/K6iewNSqwaqq4AgAg?=
 =?us-ascii?Q?oXrL0eiWBcyMy8GHD/iDOFayfffsyTVREV0EFHxXdb324qBFw3ubRlQLzO9g?=
 =?us-ascii?Q?TUxOvPsWLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	On9KQR5tUMvonZKUiLjWQS8lh3l0wnIdhmz3ScuFoM93lsbJPdM7MPtpUzVOpN4pBG/8w6WmzfIxTphYK3kVhrbOijlMeHzB26uiZeatPTZOZxkop03KFVGGKjHlEyh7FOh+P2EzfzdIWdy1Yj0cEobs7kKp8P7Zf7UR/C4pfgQyS1blAezqfzHc2vgYW6Y4wPu3UL38UolkH6qL08UWly7EIDJuTft9j9L/ZyEsoaCEXAkGVEcojP5JXDUdgkMSZtuDxHFy4vGKMQFqTMGLjFXpszkfbUurCB6F+esfStOHO+nSM6CKjPKX0QxDtbn6sBItIl6o9l/EdhY141LDLkfC0gJFoKWWipN7MSMgOXVVb79wp0qzb4C47Hr+dA/cdxcMJgLAMO7DRSEHMmYyhtR9JAuIyh6GDQ5ANicxoj1EBYYZMaqr6DiTglNFz05cIYIvhOC0Bds9UpFq05VsYVBHWt1FgroR6eebxPAPT4dknP/X6pKsPNUBYY2BUAHWtfkIXAwEiqXl/yRWtBlJTRtl8Lwv7HvMFIsbgS/hQ/xths7VpAK712r5S7dLPdcM66U71coeUyywR5fqDmCeGRqUmet1AmAWI22u9hxDV+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd9a19e-9405-4d31-7cbc-08de4cd1ebc1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 03:16:02.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwKZq5N1vV1Apvtf4mdnrzikMl7ErXntdqWqok6iuxBlcBEvY4DA0poNlWL9OJErsapgD1nmHejOBATEREYVlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060026
X-Authority-Analysis: v=2.4 cv=J8unLQnS c=1 sm=1 tr=0 ts=695c7e77 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=xeph-Asdj1850-s88wYA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: 5Budbs9IXT9FxSjQWFXNawB4NP3hgDg5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDAyNyBTYWx0ZWRfX/LsiD1I1QSes
 VOiR1kGHxRcr6h539YcCJrdfDcBVo3BdtHXHNCvbqPGqlXdRXueLqBFdF6oA1iPZeziBfF8vwVd
 otyq+Ribr+RqwNywM1N92RUyWftnqCKUsXZuXB7UHVGKXTEk8yamXhbdIPuMSJ1gmYgPO+92F2l
 /ULqC+0tNvMgR4OBi29u2+xP6Ve+qgEobzNeuv/Emz0ZdrQV78cqXhpeeuZ1AdJBsi11rz6/Id1
 iHVJPoyGl4bbzuKWsfn5/FqhBYaBg7gF5LjYvc+VC618tYrObERtam65d800sWjwn0ISC0SexpN
 k3jeLqZJqBuMVV6vsX9U+6yjGiGhlarGyD4U8XzAu138YEOueMuvu6GW7bcWEv6G+i7EDRr5nTu
 P1V+HabTLoDMZJfVvyrbBlAmKrC8D4eV3muG+Co8GbX2OAXIuw19Wql/xnKRVitpUcCpKAK8xOX
 81s10EYczxSTtG+BLHw==
X-Proofpoint-ORIG-GUID: 5Budbs9IXT9FxSjQWFXNawB4NP3hgDg5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA78720002
X-Stat-Signature: 4x8ikowsb1z5q6pozeh6ww9hg6prpps3
X-HE-Tag: 1767669373-821160
X-HE-Meta: U2FsdGVkX1+LkJQRCTtPSbHF624irqQS1i4ROVkEIwfawH3r85UHkhyl805zdW/h059EQ9BBoo0K9emsZpQXLIkAigt1dA1WwBqMLhd/2JYVvI9UXDqf42wLoMwyCasqcJlEMaAjvHKeMt/tE482k6XQiM8xfvcZSFI+msJwaew5//JhzyVT1DNKsEKswVwxtleze3ksLdzGyf19LyxHRSUu7a8Udij0Z23J025UvjUTgnWUH3K+QcyF2BRkwg5R2joVz5RqB0KFbVJqoMiuXFQ5ajCa19zcXICnMIaCLGoutq3R1YaXIZdkutcKOZuv06351i8VlJpAq8cDdmNaiw0VsUgCNiSghanez8v1KN1720lKkIhXcBJORyE/HIwvc3mOuVwP/wAEhNAP1T9GM49iOyIrxha4HKKbGdk0y28ikrXVDcSakI5+slOTAKyfTQH4hU5xet4/tbpQ/GKWsuuBe1eCY3YQHqsyA0AzPPGfT/feBw9mmPNT30qPC7vqY1oIe4qhOciMcV4y3tarVXxEFgTzhsK+O1UuwZRm2Hy0J4M2ysKOKjZ+3FfENBf3yOs/Nl1ReoTS50eiKurhiP3SGsuOyfB2b0IEnR7Wb6LhKj4Rt+EStHJ1WhEK3ss6+5EXKhozYVdVJASLl0ZiGP7zpI3aYK8BY9siSiCHgW97CHOHGaxFdoxKSvVnamL3IyESOqB3XL/+0YT1Li7S69d/+gWkNGJXIVrsnZBYKrOiXVKpyMNhhBG7gs015SmLyWM3oByN8bplNTigsomu9dX5ISaSNw/jky6fIvjkJpRdJadXlA1GTgEsI8WTpoVg2rqSN0mDwI8I2ejfzCNVOKT5p2u+N1FEiU/dq//UzdFPomPxSShSZMMIKGpyOB/WyARHC/FkaBqG6VN9sf5iH9etsOLpM/HU3BsqQafX/R9wc+CyvCtq6SnSNjF7XMVJtkoBVIQAueR0/HAN3tr
 YsYKeCZc
 kX+sIYNErW+dF1rPzKHlG+5B0Xa7bPH9gzkRhaxOervsReiaWxp+CMmkbthwOVKUGwjUV19EWwwjSgohnjOlq1cr9RTHatTPxaJfK8D32529WhmRV1wfSqwdsH1u2jVlzY1zm6UkuHcEcPiYUvSIJO7XVC1avTq6UubLI8NDpTTI/6ne8FRM8PEYM6SLTILpomzjhCo3SKiuFdWDOkUgY57J5F2lmq9XS924WFo3vFd9Sda3oqlkSVfOd10BFhbFZJAvVT6xmUOsAyqcd+IO3fXXGqvel4xfqwPK7vhpf7iGIGMEYU9P889yRWsoFSM81EWS/YxiNGddWrAK6G537NBhUDqhQi0UTFbCnHvWJuMTm4JOEMaLfPHoC+0l8bWd7H4L0pUoBkLL4VAj5hk6G42tp4n1AbEI7txF51imd0Mr+ZzanPkhPCQhzvjHRLMrxAmHLUGjseWEFU1NrlpiaIC/BwUbj0fa9o7GwGecefPtulAZeNxsHzgHiefe11sRTd9utbcdI863Hc35vBI7GX2+1XnoC2yBUBx5g+uk0/Cd5pUxNrWew8IaOOD5H1ln+PWQiF/HrRu2iJxPnOd3zET0P0wbqrMD8NegsHHo7I5kfiPK2UYkJL6JFmrIV/V7RQfgqUiw+JqAEEdS9SwCjzoCePxqWMzziL+Z935BhawgeCKDJp/FMNrDkHkULEPe7yuKZv173OgOJnPt+NJJclJmv5nQ9DYeAsemqOTX8V4tyGGiTCZnTr/YJxryQ15R0pPNRt6DXHFXg2ipCtKssdnY/TbjoLP9mVQkswVC3HLfgXMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:11:47PM +0000, Lorenzo Stoakes wrote:
> Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> merges") introduced the ability to merge previously unavailable VMA merge
> scenarios.
> 
> The key piece of logic introduced was the ability to merge a faulted VMA
> immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> correctly handle anon_vma state.
> 
> In the case of the merge of an existing VMA (that is changing properties
> of a VMA and then merging if those properties are shared by adjacent
> VMAs), dup_anon_vma() is invoked correctly.
> 
> However in the case of the merge of a new VMA, a corner case peculiar to
> mremap() was missed.
> 
> The issue is that vma_expand() only performs dup_anon_vma() if the target
> (the VMA that will ultimately become the merged VMA): is not the next VMA,
> i.e.  the one that appears after the range in which the new VMA is to be
> established.
> 
> A key insight here is that in all other cases other than mremap(), a new
> VMA merge either expands an existing VMA, meaning that the target VMA will
> be that VMA, or would have anon_vma be NULL.
> 
> Specifically:
> 
> * __mmap_region() - no anon_vma in place, initial mapping.
> * do_brk_flags() - expanding an existing VMA.
> * vma_merge_extend() - expanding an existing VMA.
> * relocate_vma_down() - no anon_vma in place, initial mapping.
> 
> In addition, we are in the unique situation of needing to duplicate
> anon_vma state from a VMA that is neither the previous or next VMA being
> merged with.
> 
> dup_anon_vma() deals exclusively with the target=unfaulted, src=faulted
> case. This leaves four possibilities, in each case where the copied VMA is
> faulted:
> 
> 1. Previous VMA unfaulted:
> 
>               copied -----|
>                           v
> 	|-----------|.............|
> 	| unfaulted |(faulted VMA)|
> 	|-----------|.............|
> 	     prev
> 
> target = prev, expand prev to cover.

Oops, I missed this case!

> 2. Next VMA unfaulted:
> 
>               copied -----|
>                           v
> 	            |.............|-----------|
> 	            |(faulted VMA)| unfaulted |
>                     |.............|-----------|
> 		                      next
> 
> target = next, expand next to cover.
> 
> 3. Both adjacent VMAs unfaulted:
> 
>               copied -----|
>                           v
> 	|-----------|.............|-----------|
> 	| unfaulted |(faulted VMA)| unfaulted |
> 	|-----------|.............|-----------|
> 	     prev                      next
> 
> target = prev, expand prev to cover.
> 
> 4. prev unfaulted, next faulted:
> 
>               copied -----|
>                           v
> 	|-----------|.............|-----------|
> 	| unfaulted |(faulted VMA)|  faulted  |
> 	|-----------|.............|-----------|
> 	     prev                      next
> 
> target = prev, expand prev to cover. Essentially equivalent to 3, but with
> additional requirement that next's anon_vma is the same as the copied
> VMA's. This is covered by the existing logic.
> 
> To account for this very explicitly, we introduce vma_merge_copied_range(),
> which sets a newly introduced vmg->copied_from field, then invokes
> vma_merge_new_range() which handles the rest of the logic.
> 
> We then update the key vma_expand() function to clean up the logic and make
> what's going on clearer, making the 'remove next' case less special, before
> invoking dup_anon_vma() unconditionally should we be copying from a VMA.
> 
> Note that in case 3, the if (remove_next) ... branch will be a no-op, as
> next=src in this instance and src is unfaulted.
> 
> In case 4, it won't be, but since in this instance next=src and it is
> faulted, this will have required tgt=faulted, src=faulted to be compatible,
> meaning that next->anon_vma == vmg->copied_from->anon_vma, and thus a
> single dup_anon_vma() of next suffices to copy anon_vma state for the
> copied-from VMA also.

Makes sense.

> If we are copying from a VMA in a successful merge we must _always_
> propagate anon_vma state.
> 
> This issue can be observed most directly by invoked mremap() to move
> around a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> specified.
> 
> This will result in unlink_anon_vmas() being called after failing to
> duplicate anon_vma state to the target VMA, which results in the anon_vma
> itself being freed with folios still possessing dangling pointers to the
> anon_vma and thus a use-after-free bug.
> 
> This bug was discovered via a syzbot report, which this patch resolves.
 
> We further make a change to update the mergeable anon_vma check to assert
> the copied-from anon_vma did not have CoW parents, as otherwise

I guess that part is in patch 3/4.

> dup_anon_vma() might incorrectly propagate CoW ancestors from the next VMA
> in case 4 despite the anon_vma's being identical for both VMAs.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org
> ---

Looks good to me, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


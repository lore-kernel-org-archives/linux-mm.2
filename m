Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95AC1E63C8D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072606B0089; Mon, 26 Jan 2026 08:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0208C6B008A; Mon, 26 Jan 2026 08:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10136B008C; Mon, 26 Jan 2026 08:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD3746B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:01:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87D17D39FB
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:01:12 +0000 (UTC)
X-FDA: 84374125584.03.9B63468
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id D77511C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:01:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=alObnc8M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VxQVIGRK;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769432469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MS8RxKeRWhV69Yj/VtUfJxRcOQWHBde2MHDFsukZe6E=;
	b=Z7nO0erP3/NKrcakYzRmZDhYtkVwI5DrzFcuCpuIgnas36ZYut6EOcflst+xJ94Y0cejWB
	cLQGM+4wxiDSRmXarb6dq893coX8B65fm586uAtB0DbV84EyYfKOPx944tf32asrwilW5/
	lp3lk2+MFC+6JSa2wuE2ty+2e6uerMs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=alObnc8M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VxQVIGRK;
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769432469; a=rsa-sha256;
	cv=pass;
	b=5LVFy47I8NyNmvsSE6fytL0bZ4vqjnQN+yo6+2t4cGwFuPJIGJIi5hhJVTP5DphiYPRHf4
	Z99EhrZdbPaNFiGE4F+/gfAMBWmRXt6V+DyotXgb+pq57lvMbrNqQ0ilr/g56CNBEUUcH7
	+gnUSpk0Run8eRoM/mE41DDkdv0iL4E=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q3CtVs871441;
	Mon, 26 Jan 2026 13:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MS8RxKeRWhV69Yj/Vt
	UfJxRcOQWHBde2MHDFsukZe6E=; b=alObnc8Mc5AHpfnnUhmNatmEiGQC2rK7MG
	FfI0/PkXg63l/3/7iprfuFL0GqStfyFB/cZHh3aJX+lTdIoSQE5j9GOCBptOMKAA
	Ffgr1zYbLmXGAxrhU7Ouy8Gg+ZdnlYLP3UrLi3I2do1gej8KExOL5/FCP9Uiwt8C
	Bu/oGa3MNqbBvXKsRn9UKyVGBZNzXz6Wd+bcWW33pgCTXNaJxLcUmyXgcZGzT/og
	R5mzwx1rxwJ1/Z4Xuh5cnqyVoflwreVzJKP+6rtIb8xz2dT4IP5730XRCnrAGNT8
	FUzMCBA2CaVJLQgDWgWX8zcXCRIraaaofqFrGCB8Fbhi8P1XNoRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnps9s5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 13:01:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QCEc1a036089;
	Mon, 26 Jan 2026 13:01:03 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhm62ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 13:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJTYeh0Bpe81No5H8+Dr9yinFvsEBFiKnSe5V/OsdPZzQOlsRNTlbeTvhuZz0zR5ghIxYIh2rMhd8I8m+SO7jlZOvx4m2acuiRfraGzrb9GK9a45fw4cGRCbiqzeuT0vWxkeY5oGaJ/jVBFYnUEqGTRlpx1I8/PsHduRAr+idSDLUZkDEXnJvK/Lol4/gRBBif6RwvoYPhWxlVlRLrbAz7nnldrnSvlX7YIk9wiJDYmD0LoabktzUQgjMKggkyZ7TMmIbIeNdJTUfxIxDkq8EV9EvAuAj04nVNzaswFgaifV11HsMqC+qAmbj8FkApL0r/yFlm/bBsdXXuvXd2Wo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MS8RxKeRWhV69Yj/VtUfJxRcOQWHBde2MHDFsukZe6E=;
 b=R+ibPnZTxMflJUdAlVvsG1ndWHm0irizbloECzZ/pBgAPRxe61oRCA28mlJ9yxG3QMPXgqwWNkIfP+eA71eoAfx0y0KHxOsKoUDwgMFZRXbRaGxMt0v/457iZ8bdRggLd2+a0yu379yHAimP2kFv9Er2pBRmmzCZyg/C1tfiSjeYEP1TqdLAPFn54TrARExYYHm1ZsdFkTR5yYc7zknmVA2qahVQODsMgmk4KPkLry8/xX5kEVxVXGApRkOUB/v0hFxnBAYxCeTgRYKFVjml8dYlnbGYCeyMkZlhkO+X2+WI1SMLvkLFS7/hrJPNhNKg1oQaYgvWmOAHfilhk1uvqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS8RxKeRWhV69Yj/VtUfJxRcOQWHBde2MHDFsukZe6E=;
 b=VxQVIGRKgRUIC31JUUumbIOFulr0PhoqycMYCjk+FLr0ZgNW7Hw/s4upcedXRmc1zcSTFkld0fwmVS2D2Zb5Qm0d7l5ChIwTVR3HYzDDzbPp/Utat49FGzgPJTBBsLFRHSR5umEk20yFrHWfhULbuTNKWv3QTEnBaMWovzKnyr0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ2PR10MB6963.namprd10.prod.outlook.com (2603:10b6:a03:4cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 13:00:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 13:00:55 +0000
Date: Mon, 26 Jan 2026 22:00:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org,
        cl@gentwo.org, rientjes@google.com, surenb@google.com,
        kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own
 slab
Message-ID: <aXdlheky-H2a29Uk@hyeyoo>
References: <20260124104614.9739-1-harry.yoo@oracle.com>
 <bbhrcvqbwuvf6l4xwv7ax6w5iwuixaivvuknvlgutnavxyllme@r5zkvsh7mwtw>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbhrcvqbwuvf6l4xwv7ax6w5iwuixaivvuknvlgutnavxyllme@r5zkvsh7mwtw>
X-ClientProxiedBy: SE2P216CA0032.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ2PR10MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7c156d-f37c-4915-50e2-08de5cdaf0e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8k+8VHdE73jZHarRqnTL65bVDfiaSFL/11WhsqACUsl3rCsN+HD2EFQT5bvD?=
 =?us-ascii?Q?but3lgmMWCQvk4NGYAaYgId4mI+kzkt7yz/0MrWnvm8b0v78tBco35yrfurr?=
 =?us-ascii?Q?bjvvexwoDxyH68CgCDdFtBXnuZq0AASjJ+hao6Akol2z3e6NOJEkdS1RpVco?=
 =?us-ascii?Q?PahgOP4RqHblrSuI3/7vf6PsUPYMPpglXj5+3LHNDmY36r3z6+PNfNnCbqiJ?=
 =?us-ascii?Q?qd0zjiD6TxGRGhYnDH745coif5CTuobmSDsHacLAaM3HxUhrq7I4RTxPa4h8?=
 =?us-ascii?Q?+pNdT60S/dvk+5gE7yaoJ0QwmbgqQ+bPB54jk+dv7bULRQJzVgEadGjYkW0E?=
 =?us-ascii?Q?YTAChXKAYbbYxvxUWvoyL+YV3y8o5ov2+6NQCLMLCLnA3yoA6Zoh/O6hLv99?=
 =?us-ascii?Q?LPlVyNbVmk9s+2bboFAzEKs0HgNWkKBOHE6gb8Z1yxcNHYYQqy1GNAUpIXcm?=
 =?us-ascii?Q?CM0kvmoyZwdZj+TcCKWHTlrt+qbGPRxNmQ6hKpOkHex+McmP96Q+i7b87Ysq?=
 =?us-ascii?Q?XfyJP4nE/PlRv5XMpqDKboRTFV6SKJx4s6kxEEH76lp5qwE/4WCgbWyjar91?=
 =?us-ascii?Q?UuGt5KNv5xevih1n4jw92kI9tzV5EluK/exuQyyKNjwBvjCwI88kvdrOrgu/?=
 =?us-ascii?Q?7aFy2SakcoK8gsaf7sBDi5TotGH4oNAx4fR2GLMGY2UazFL89+GoATjbhjyj?=
 =?us-ascii?Q?E0JKGgaVOZobQrMI84l+p9TX9+pKGwvuMt7ds7Djd13fBVlCIAVHxmnlvmdg?=
 =?us-ascii?Q?zEtMjxdQuWQ+fu4oH+3QxT+GUwlMP4cjiwPiaBavqPVg6+eDbGE0sikjKLs7?=
 =?us-ascii?Q?PUhPoNuPIJdVZI7o5d+9ZGbumc7eYe8/TY50C0Q+V2ejnEZMCbg+S0Z7Bpnc?=
 =?us-ascii?Q?iyeBPeKDTIo5KrIWmfWCNvrbcdAt6V0SIzTgbu3l7YoyOHslpdQU9xsVCOKd?=
 =?us-ascii?Q?OkumG0i9NUAPBGojRCd6Zvks2O/K1CHhtPwmp3InqKv/3dEAxeEW3J+LjbKz?=
 =?us-ascii?Q?6/yVJ1bg4utttTaHbncguwlxi9QRDcg7gwW7gledgxZLkbZ8NwJoIWM7NPrM?=
 =?us-ascii?Q?eu82v6xyjqk4Mu8SqNVNXWyVEEJZFJTaRhRU5bObPqH3Oadvv9Qe1yglaeSY?=
 =?us-ascii?Q?y2hcuuPrkOIH5+r6XmrGJyGZRZGHtNZyQ1VNJY0I9si2NihILhadCukU6vsX?=
 =?us-ascii?Q?nbWxGrn6xoju+lzWKf1Sb3GupxC8UO1rVmr7JBRSsWAQi5DVDyttxgGZ7tUD?=
 =?us-ascii?Q?rnlQV9KtvYf8pJyuXOJV1yuQnYwmzF/Ry+yMCqKRSwgfE3BtiQLG5xDCqCpE?=
 =?us-ascii?Q?5zv4x9/tUAZUukTv16QNZY0wW+/Mcj+IvG3CWHe3Xw/WhhsV9OLHaYS9GXLn?=
 =?us-ascii?Q?kbouyxe2ZP+J2W5+ew3qzSdtyhRJZBA8yINDjALRRQ5+7LWQApanqzpfe6JQ?=
 =?us-ascii?Q?X/fpVmm2jrrsp4OVwqG4aZ2B8DgGvZZKesorzljmnWuevt4zqAc7qAJsxvfm?=
 =?us-ascii?Q?BIZ+RHETKfgOZJKYqDWstqQkFQUo17VKq0P/LJGuQROSqjsEwCxqDS2myMfp?=
 =?us-ascii?Q?IWnDkLHj9zJmZt2t5aqvyVXx5+r4gNv+qmigzX82?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0G4ubQ59xP1jF8/0DPJHsgoX1spxcfBWhu1zq9ds6ljqdNubVSlEVmA5mZmg?=
 =?us-ascii?Q?Aoouioe07m9oUdumoxGOPQM/4A6O5UCerN/d+wpT9jBLmxq/vl/JBh5C5Kk8?=
 =?us-ascii?Q?3HjJQNyPyRI5BIwXEGsCZXZrEABLlC3XYSk5ddxTDAL4JQCVGW5zhesEqMZF?=
 =?us-ascii?Q?kIkwlDxutqZ8qIp43ToP4jVOs07pStxtIFyLlZ9l8SacI21tfUBSLuwhv19l?=
 =?us-ascii?Q?HkKB9o0ltLeWWAjBgyI90GGsaFDjxDSWtKPMUK0ZxJH2TGVk4Sj6bc+OND+c?=
 =?us-ascii?Q?LBlVcE4Rb17cuLn7kZHDLjGZz4CgnslnvAup0a0f0gG6w5qp9+LigkPqyr8B?=
 =?us-ascii?Q?+EiW439f2yy7jCLC32N6wGDFbYRVi3V6j4V1Wn1o8mE2xbwWivsT1anODGV8?=
 =?us-ascii?Q?JmH5e3aHrAg8NcGz5WKrRPrhfV7MYGKtJENRL8bayNXtGmFcSfc40W2d98l/?=
 =?us-ascii?Q?e0aEZ5qzP9VsW3yyVF6bPaDfYa7h0hPX4qkltbx/LHTDscWNKcG74fedX44i?=
 =?us-ascii?Q?LfOt1uiYU2oS9iQCoEnUjzhPyhARUyDx4arU5dIBSaJEPcrIQqvGwy4Wrj3e?=
 =?us-ascii?Q?3vDwAlwRSTc4kjrlmuX8UxcFNCN95CgbtVLObRW7ZOZ2q/jTJSTPmKON/U9z?=
 =?us-ascii?Q?NB48l8Gt+bMB7f6ZD+WUvw5m+iBLEhxeZqoP4TnBhZD7zCthpH4X75HDurpo?=
 =?us-ascii?Q?+Wf39W2godlmBtwdxbgG0q/HHuydA8NgIYAgZNSO6977wSm+pR47Pzc+WUPz?=
 =?us-ascii?Q?H/AO9l2y86385GTyNNtgSODgKtEfhuVcXsFmX19naKKja7eWWHjaRckS9MfK?=
 =?us-ascii?Q?2q2J6QCh3lPwyAaDYTF/NvI5YJDgmGC4ugsAB3edKf5HEqLfOd7H5wwrzWeW?=
 =?us-ascii?Q?EfoxqeCsczgdHRW+E+EOZfQFaMAPZP4HStgq0LoL5gNj5gcZLpwJGOL0YB3t?=
 =?us-ascii?Q?TPyWMB7NtIaiwwb9GOUu9No55lEe4fKJAePn8miy6HpowyzO8yyCaRUs+T/7?=
 =?us-ascii?Q?n6M+QuOC8yO8OtL9cIVBXf+PbGbIu5VTvY4gSECRhoOE26JJCt5SPV7UILuE?=
 =?us-ascii?Q?7vZ/3bgbGguMEB4qqW+TXqOE1F1N5l6xe3FH0JEgbtD/CoP5qlkwl+ArN+o0?=
 =?us-ascii?Q?v/jPt8SdJT0bQnKmJt81eSN+Z6jDtc7rnQ0CyOa/zgPpP3R1xHE6ySYDp0Dc?=
 =?us-ascii?Q?rBYYwtpqe2d3i3gWG+CwvsA4BZjMP7Kj9z8C8ha+dxg2t4nomzzztq0FcKXD?=
 =?us-ascii?Q?K+cN34uvvxpXxEiVvRluMYcsYvqK7CQm96SqAjbkRagEYCsETCMfc0iKypYW?=
 =?us-ascii?Q?9RWMrt4aq1BQmLLLBHu5BYGP09DqiJnSW9totT8tcgK+Y4O5/EQVp3PjKMZo?=
 =?us-ascii?Q?S3gALE2Yvo9JHKcljFCAt81W/Sjlxe+jhQiiKcsvZR0AA/kU87OGOhvjTQIx?=
 =?us-ascii?Q?jJ35ks1LXcFYqn1FWGXUnYpvPGv9XCchYQj8b+yb9fTBLM/88fypYiTks3SM?=
 =?us-ascii?Q?QqojH4w6zim/KRyenXP27V0JeyKxLRRNnleNtQdOxN3eKnDKOr/ZPRnkKYJX?=
 =?us-ascii?Q?1paAWrxrv/8KOJq/HfPuAStOJfe2Fm+cn3bPGLs7GV7iQA5mNOmGe74LdCt1?=
 =?us-ascii?Q?J5XVytFd6Kl4AGO3A7KUv9s5m0jKNOZn6LDHOmraF1JUowWfgCxJk4gCwFGP?=
 =?us-ascii?Q?HYNEygj7cFQZ/v5EDzuVunB3ixtKWVdWAx1huaOJCmpnG7M4zBJy8lpYn9dL?=
 =?us-ascii?Q?3aGLgP1l4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	umMTI9vb7GKTFePXkXQsZyyEBBJtWqxT0xl9JnAS981k7c7IlGgwSWy0qetgEa4dpVRHEOxR3Bg1YKV3MJkRqEfO3/fXJXd/KVHT+EYJv2mqSFsY29rcJBtA90oDtj5uCoK2a+/AkXHMcUXomAPnFKFrbTGr5gSfqH9foZGai1EqwhdVHBzv+jXuwYk6nQsuLMbEzfeZqcIsgEvgUOxP7REXp8aLMO7h+3DJVukPB1wlOL+JJ5i177dqtto66M4WVHj17p1fycKyP7CYh/hfO5gWff/VRkmwAzmoCnuh6tq+oQwnt9TZfPLp0h+V3Jc9WKMroNh8yWBieJvelgOQw2FtIVYI6oZcZEiWzGrT+o8M2Gyld6ldWhZ98Go++xraad+XLJi6k+VgO/4P5dXpJnWO3Kgzulx2Nd8sgxY0dpLfw4fsa5Bx/dOp+oz73hOg/7Tw7HpgY4VFTE/0qc5FzTqFEgkKmnfBMttGyZh7d2FqxvIX2MhClmPIbtgcoQTBurE3LRgc3cfmLK7oqICdn507iyS1ZD3zpgXd/TYkXWSsiyxBAHwv8cC85G6vMWOC5X2bNU6JomD9w9f4Jpm8c4wsSe6ExxjDpbOlp31Y1hk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7c156d-f37c-4915-50e2-08de5cdaf0e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 13:00:55.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZHuKWpTE1pfi23A/qT8EaqMKFRJMCTXg6sXKo2S9kJ/JccbYca9gtMGHIcPQEZSiYWT0vYxO5wScEe5Jek3mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260111
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=69776590 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=3gxr2GW5v6rFuv8lLXwA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12104
X-Proofpoint-GUID: pXt80Uy2bMOLoMRusRA2IsF7sdCtsIjP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDExMSBTYWx0ZWRfX9rPemdAc+tlW
 bqweq97Mx18bk3rrlfGUJcOCXofzLRPu+Ct2gQ/rDsyvl/GTVZsU6AKnKhHhgXsvjxHQVMDSZaj
 yClS22tiv+wCqPjir3dK02mxi4VuntdYFzqcd7DUJ2KB2Cxwfs7j8yGUBBwXX5uknNR8e0Boy3l
 ESGCOcEURxD3O7oGX5Ysg+rjoJjNH0gyVup7/UOrQY3+683Qk8qbg8GdCG4IZix5TCkRaYpsr3V
 0G5KlTYwxqhX5T8S5u2Xs87KnepViOLDrHABVXuOt4+FM8WBJv9edVLa0OPOR9DpxyqOnu08i0C
 x4QcVjMGyR/buzKufZqnIlW/6tp75QSUbf7wepl5gokldNQAQdfgpE23TKLgL9TFQAg8D2Zrb7l
 fR2JpGVy2hs8wF6VwkVJu6jKAsgaNx0y7FSMlJx2Sl9uo92qhGQqYiFs0QI3a01hHAhEhBj6b3e
 JLVo/51TKt/qnzznz4QAakxOyKQj123UrkBmeksU=
X-Proofpoint-ORIG-GUID: pXt80Uy2bMOLoMRusRA2IsF7sdCtsIjP
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D77511C0005
X-Stat-Signature: ozx6ue61ixobrgu5weh1xi9wd55q8tzs
X-Rspam-User: 
X-HE-Tag: 1769432468-571987
X-HE-Meta: U2FsdGVkX1/JDbx/CcqdEjdOHYTH+fU7q7n6sRCz2WRcgGKWzA8S0Z6OFAhEFH8Wze9XZwtUABzk6jnXR1FTZuOQ13PwHx94FzT5EQmOKcA8oali6MGydAm7/NoupKcwzgPs3ULJs0K7t14peFNySV18rWdyzZ1sOwWutKTqPpNLHabq2q562K/K5+R2nkfQh0rLzEZzqcuPpqJuFJ5y/xXTBIZ1tkQZTk8i4tU3GpHyCkbghFwYPbY6ViavZtxoFTrmBxlpGLi3k0lqSX2CPP3Knu51lTyk9fSRZh5UGyHhSfFGHiCh9RTFUFPOL+CeKww1K2PZN+EOvuuKkYYTM8NpBwQgRZr2KYOfcJxGWEIeZoEB4HO0vd9eyH6ybn6CLCkfkzToANh+hracaT9mST6+Tr4kxXac55pUdMLgbT3CK+GyuzMWpQ/934gRdZWJS6co2dmuSZY6pdtDgakuzfl5xxnLIr3p+A58J1xcP0dLXcMchDYm4rB+ljDBLalmfepuOaIzebNTSJ9oG+OXgt3nmxve4yHw7j+iqckXun2LQNBIHD15q5urURy3pCApu8kRSveNzQsPyUa9FZmluY+fTjafdLpI9GrXeyNob0AVuYRZuyD2vvI34o9ueyYlpv9bSKwT0FDrO11aTR0zZZc+coHN7dgvp5KU27krp9MOuBn0pNdV7aCr0O+YjxdCB5P5fu/yd92bAVD4YHl80Rg67TF2mcx4tsuhoP9GJiWjLXLyS/oMo81DlIsQDK2YY5K+eEoTxfbrl35qcI1m3ByrVXt65c3zmNpb+v5VQ7gtN8XJDoChTZ2RoZFFewLGl8Z23nOfXxUQCPkvXToxjbg9oGlq+Vb8gv2OGx8A85V+W5G9XVebOmLXuEum/IChPFSiLT5rYsGUx9DIKq7xEM1as/9GsaizeOkLAeNI73l8SRavZGK5+6JNcaZeHL5cKIfIHXoDZ6QXuHl6CH5
 yj7YfPz2
 Bkh+Vm2KgdA4yLn9JE3zt4htaESkH+uqAr2lYd5nA7DAgpT0n8DAcKHtDkm+0NV59lPJg4zReEeo82rifcuJqZxdyGIny/Hub4OkVyp9RgR+GpSmmcWxmpfPSoZ8phvV5AWh40gK8lpQBw3xiirHixkqmEn5VLqFmLTn/16k7QQusPowc2CfVEprC1B6uQRUDW/wQm6d5hCLDq18UWvupsbHeF3Em//IypYBz12eRWSQ8DcBowmC6NTW9m6CXn8jwNp4yPgFNF6FRKtCIM0wsgOb12UZvicjL8QPdCCDUyiQ20ePaAjYmmfbAtDj2zdpNXEEOm2ZnsCm74K0a/TrJMcMVQxu6WqvUOncrLyNnaVWK0vfIfegkgMzVm9YXEU7ZvbHHJedUWaikmEMvWqjgtg9H51U9+Bv7tZj6ZyfaQA/zUylHN4pVnZsL+P+D8XGObRiZ4bFgaIiHWIrvO/4XI05uHMcxgdMR0ZhMuBCcfOWD/N5mlkt0VN7ubbJQbNaLOc2Dgajc8Fv8+cS2zcbRDDrYBcPBY8p5cGEtLbmEVfogq5Lp8MiRPJrtrya30acckey9MhJfBUUA5Sq3JU4kjgaTyVZMAAixh1Scen7WS+YBg2ZTHRmOPFzgjT/h3mYimMBwEnWo3vQjYS8CJzt+TVHj+P2iBA+9KuxlRL4DcxQ4pdRCKuDd+bIPPW8ZIe/HZzhw3J79sK+xGcI15zoKa+fG1Yho/G3SLlbZiuwA0LRMqDEBvZdp2k39cJtHV9MonxxYLWuH61GXQMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:51:10AM +0800, Hao Li wrote:
> On Sat, Jan 24, 2026 at 07:46:14PM +0900, Harry Yoo wrote:
> > When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
> > can be allocated from the same slab we're allocating the array for.
> > This led to obj_exts_in_slab() incorrectly returning true [1],
> > although the array is not allocated from wasted space of the slab.
> 
> This is indeed a tricky issue to uncover.
> 
> > 
> > Vlastimil Babka observed that this problem should be fixed even when
> > ignoring its incompatibility with obj_exts_in_slab(), because it creates
> > slabs that are never freed as there is always at least one allocated
> > object.
> > 
> > To avoid this, use the next kmalloc size or large kmalloc when
> > kmalloc_slab() returns the same cache we're allocating the array for.
> 
> Nice approach.
> 
> > 
> > In case of random kmalloc caches, there are multiple kmalloc caches for
> > the same size and the cache is selected based on the caller address.
> > Because it is fragile to ensure the same caller address is passed to
> > kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), fall back
> > to (s->object_size + 1) when the sizes are equal.
> 
> Good catch on this corner case!
> 
> > 
> > Note that this doesn't happen when memory allocation profiling is
> > disabled, as when the allocation of the array is triggered by memory
> > cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
> > Cc: stable@vger.kernel.org
> > Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Looks good to me!
> Reviewed-by: Hao Li <hao.li@linux.dev>

Hi Hao, thanks a lot for reviewing!

I was tempted to add your R-b tag, but since the implementation has
changed a bit, could you please provide R-b again if V2 [1] still looks
good to you?

[1] https://lore.kernel.org/linux-mm/20260126125714.88008-1-harry.yoo@oracle.com

-- 
Cheers,
Harry / Hyeonggon


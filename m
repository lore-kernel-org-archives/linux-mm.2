Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBACCF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E046B0093; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C366E6B0095; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01626B0096; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93BFF6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:20:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 374E21401A5
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:52 +0000 (UTC)
X-FDA: 84304320744.13.8C19162
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id E36CA140007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AIG6+4OB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dhoxs1WH;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gl3n1yUsibhRyMHEPi3YxDMkVeOvXVzWRO7WKBzy01s=;
	b=OIg3HCfM2OYljGLvd3OXvvhVQlQLo03omQWbFr/eYGpW2tYn3wUfGe/ZKrFTIJpu9Q5Te1
	OH2FMUxg8JURuqwLBZ9ryMdl7zPR5suTfWmE9DgIqg4nZtHMzHcDl9Cx304Dzv/bOnzhS6
	AuhKaqCNh9u1ilFoop5SoL9adJ7QMbQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AIG6+4OB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dhoxs1WH;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770449; a=rsa-sha256;
	cv=pass;
	b=J9y19vf1sc3MGjso8uHlAlv8CfJZT0Jx0g0WdXPAwSp+VcFGL9IsWH3bAbKc1ZsIPV5Epd
	arR4QXhyODFIkleYCNa8OY05V0yNOSbflBg+Tb6muGvWBJrZfe5J54hT7Q0Yjzvg4x9uo5
	EZKZs/yv1lsXoKNEfOUh3sdfKdLhoRQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6074KrDP1674164;
	Wed, 7 Jan 2026 07:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Gl3n1yUsibhRyMHE
	Pi3YxDMkVeOvXVzWRO7WKBzy01s=; b=AIG6+4OBzzoT3U3ST7n0k7dM9l/Q2ZyG
	GfJzrOH2tJLKTu+95C4aNX9LNPPWAageChBh0e7/79PSaFCIr+iWuo6obnyKS8Fq
	wqZtkw34jEs1lRt5Cb8tIH0n2xGKPVlQLpR92glEU+PHQ4LeRSxECXmTh34r7tNr
	WGyWiwTBQMLh2Z1jXhNfaOFSs0Dt+pIqTHBJTZ+XF3muKKi2U3YUsorlupE7SPpI
	0WhgHbNU4jR0Gcjuc+XtsCw1l+5lel3NH0eOxalGFwWgSvUuyyz1p7zmf0UhTgPW
	RkL+MnTbQnRdyPAjnVNckIzmLrhB1cNuPqRtWQFWGt4+NEXCr0Msxw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhgcf045d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076AJrD026342;
	Wed, 7 Jan 2026 07:20:15 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkt11d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AbAEAsLx04qEM9oMJXUHBs4AXy3BgHCOiqHdQqcNEoQLY3loZLX2TgaC4LhsBq0nQ7qSos8tJNlj6w43tvOTa6gBoJ6DQUnU2sJ5xiIBvGsUNodWmwq2sApDnflJ0RXtRfOG8D0Fr0hhfmEsAi7Q+k/AGXlgu1tjymhhGVBNNjMp2TPhD0MoaduqaSt/PzIxFdHmTNszDxAYpxavoUoVyVUlHuczezYs/6hDImEbc3AsSC4Q/eV4PCh9u6h6LOrpCyZouiD0vS/BDLHJTRsF80lUggzIl1YTc0XRf4fnGWuxkelDfVxvM01nrbwNELZKRa3YKrX7d4KbJHUrze83Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl3n1yUsibhRyMHEPi3YxDMkVeOvXVzWRO7WKBzy01s=;
 b=j7Bk23ZPUD7vTja9AXoQt3qXTL+7/+6nqXi6eu1yfec+Ua1kaGpXdiKDJPxBaa/Ap+g/YBJHB8Vxv5CMeHrDzdWaK6+C9d0siQ/MgA7iL7GazR9LrGA9eISJI/TPj0p+i+Pr51j/Viu20R7cCT680Cl00dlRvkAOCp95Od8XVw2xWfFlRFWhgCR08jMVChahI4yWhMuvDGVjZETxd/P/Ju/EWrKlRK2CXS8SGoPQR+eMWZCf5aEQbP5kR065V4Wibi9IYILRmmzfrMqv06hr1bersWv+gBqmJMJqtlr+sGc3p6CIYKY0cg4AG+B79ZJSLv3rqb/qR7qcLeOYULfG6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl3n1yUsibhRyMHEPi3YxDMkVeOvXVzWRO7WKBzy01s=;
 b=dhoxs1WHmp6mqTOVjzyMtJwj9lj3ocjANrBoFD1PIJqoODJn5gmNJqz50AEEXZvcEVQMkyVDlYaN8MBY15KWoqqHMlsQ1+iIiH5RCf6hlfu5ePhxgZbMBlGCp43mGtZVeZYrIrFSRq4MnxfGR954Bf2QkNGjQJEm2R7iASmmdCo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:11 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:11 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 0/8] mm: folio_zero_user: clear page ranges
Date: Tue,  6 Jan 2026 23:20:01 -0800
Message-Id: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:303:dc::32) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 580dcf99-4fd1-40a6-fa8d-08de4dbd31fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g40S0ljY4YMw6IdamGOwYoEGxAl8qX8i/mC14Zajv4quGGboP6ga9M5a6oP9?=
 =?us-ascii?Q?G9OVXyXkbnPme0sPzhFUDF6wPuqkF9lI6AQmIt7JAurlhNL1BRAw/yPSTdO8?=
 =?us-ascii?Q?d7qy9Dd/c5Obisy6t2j4qo4YfuBZfFEvYsfYb9RGn7hZSbS2kVWgE0DWp7W+?=
 =?us-ascii?Q?S/XMTDLRzLCnYzeusDhgHeHmPt2bkLOeRMYMZiG1wfXTl2OGCyMxb1Be5Uao?=
 =?us-ascii?Q?QzDW2Gf6WBsaZMfPNAIRA5jREsDc2NumyKxqerL5RIdZ8OO65ef/tgvh2Pxs?=
 =?us-ascii?Q?Cjg6ajcObsC5GdI2OI4DL7r97RJBB8c1DV7b3FPcMr82Dj3m7I878cyYmsm4?=
 =?us-ascii?Q?WV3Xu8a3lSVDzEA/Am2ZYcp1z8RnyX1SD8dzfAdnJSJikUUc+JWgcHxJ0CAp?=
 =?us-ascii?Q?hsTNZGqsB9/ZKo70ZtduVy08pwFp20A4D+AsYt+ifrgCwXNehZlcFqdDaI3l?=
 =?us-ascii?Q?g8Wtm7uRuZlt0mWs0czhD2Dhb5e3zFDzoJ74ZUwPFXw7YDQap3R9ISM0+2aP?=
 =?us-ascii?Q?/r+q0LxobY0wJ/6A1/t8i/jEUjoykX+bTvXb+qRAMwSfP18DtKqY3naf9SQU?=
 =?us-ascii?Q?UQTZl7pDxYEtl7INPzgq13IVu123p75ca+baOiPz8uoqEpixCllvDuOf8dA+?=
 =?us-ascii?Q?+GHkJ6mH3q8Dq729POYxLQr0soMuWMeH0RQ5p5RWyYuyN0b/ORnx5lysL161?=
 =?us-ascii?Q?pflV4nUMciKXbK1zzXOXb1tWFybgZMowGvv+wa+vFv/10KpVwie6DyWqbiRv?=
 =?us-ascii?Q?bto7oAeKIiFmdvU5R7oYjK9008TGn3zbznSarRqhT0y3dPnyQ9ROrZDqoKd0?=
 =?us-ascii?Q?GPlF61ZxtD7sWaLuXLNJKTSqSFvIJCSEh1IbO6hSvX4Rx8iQwFPZrurnKKxc?=
 =?us-ascii?Q?g4MgA8fKUiLgxN7YM2jV/qPfk9ywPsKEief6NdzE0CVYrTT1nchvMG304+Vz?=
 =?us-ascii?Q?4TDqeo/27TEFZCsA6PS7Lh7QhKa3Bug1IVTC687BmdrLAtXCyBY8YfQunBFr?=
 =?us-ascii?Q?mGCw2xjNXgcpiM/lta+nLITiMKk4aHHrhLWTt1WT03jAxfmHQHYOWvVAEyZI?=
 =?us-ascii?Q?kv1Pa74Z4BhTrUPnWfw3UAoBlS0LVaWFS6n/BISo9JxjZPJA3Ke0zJ54CmFG?=
 =?us-ascii?Q?I9ebQvrCLmV9c0lcYDJWjd4R4UPz4yoNa/bgWamta3RzF2JUupKLCiITDH4f?=
 =?us-ascii?Q?ZGEUS6QOyw+xNuHhLaFcaCrc3SMufrzb/KIhbv4ChwMfucIVm3zfpQnoIdIZ?=
 =?us-ascii?Q?qJxPffVGgbW2vKcAIE1JG4d44Kj+C0317NaPsi9WrM+FSx8NRs7fjCRvWYhD?=
 =?us-ascii?Q?NgGmx2UBwb/ChBYopPeY6vJcdqAl654g+FjfveUa9m08YkdlEUDMVYHkKUz9?=
 =?us-ascii?Q?mQzEW4PRggJWUR5tf9QXTto1HptHvTw3w7KUG+ypGKhsY0t3RNTSHmWg0cWd?=
 =?us-ascii?Q?hygBhf2xNMj6SL5nzP5cEPSSt9GEHd9+kmcXa8zgPrwHlNmhj5NP8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vcMqSDXtXzjMs38Lfy8UBaLCT//WiTTlrsuZxDJqWtp49UiJvASXRCB0NTtT?=
 =?us-ascii?Q?rfnwvuWu8wuXwrPuAg2Ss4MAEax4yYE/PiVrhxB3v9FX6ZXOabpKYSSi58/C?=
 =?us-ascii?Q?o6ptmVup0NjoEh4fZ5vI7yjdzTgg/WpmHV51xKqvocO1HdaQVgDNTJcq7fTG?=
 =?us-ascii?Q?bL7mm65Ws0bXBSTC1nOoXDGHW6V9g8oCmnPof5ey3HYiNCedvhaO0W0UsSAH?=
 =?us-ascii?Q?Rv7xC0VEnS4KYfPKNKvPjf7v0udLgiSaB4nZH4NuM0uKuocN8ZeJPQCBrSpR?=
 =?us-ascii?Q?sTrYv8EIUsZMblc3YyhMHtmBq963UWmyFvcBRoe62pg0fxq1EjEImtxaDBti?=
 =?us-ascii?Q?pwuqN/xO6GJ/z/hQWjoxy51Gb0EB0muV4XDL9/Sw3oLImJja5ADYhhT1jR5y?=
 =?us-ascii?Q?8ym/KwWnvrX5DamXnzC+tckSwmRyziTCFbiN90F070ttwSfbRavLn+LQrvGk?=
 =?us-ascii?Q?fRHuH3uHo/W+NNSPJSVk26gfXKJjyLw1DEPjjcGQAazFt74hpj7FzF7Sia2A?=
 =?us-ascii?Q?K+KwfxF8EsYEDImOUM9lbrbb6xVm8TquhQ51fMiWQ/NrDFsPaOnDu2NnZlwn?=
 =?us-ascii?Q?MvJXEwPxpz/AB2XeBs3kU57CCEJh341pF9CrFpXtA0CvKLFKAJRvx+Q25Lhy?=
 =?us-ascii?Q?l1iN1tKrhyCkCLZoyNYaE9juh9SC8XHtRO/ciwoToIPfFBNMtukTgpEWfHCk?=
 =?us-ascii?Q?7WWRYsspyJB9ixurcAXZDIc5CsdrihZki4xDvCKxGzHXVBDZey27Zi9ZH3L4?=
 =?us-ascii?Q?WkYtQPeCuVYT2otqo4/f+9NHV+IrOjuael/PS4a6Epdb8tZSsGQwps382QDd?=
 =?us-ascii?Q?g+axWr9h6kXGqVHAKVLGYfGLW84DBT9Rs6xXUGNsCTKL/1WobiU4/XpN2JPn?=
 =?us-ascii?Q?iDHXFGNH2qzuDPtbzbvvAEdb/OlxQF2hFgaIUnt0Kx1b0L/JAv6MkLLp/zrS?=
 =?us-ascii?Q?b9Sg3sx0M3F/xn7D+2mveBYClPLNWBlTDupAuZU8IbddnrhVp56LPh7FVarS?=
 =?us-ascii?Q?a/dc/lN6sdmiI5D36VszCFz8IbcpymVgCh6F2Vh8cFuOhFlOHJfjSfRpTP7T?=
 =?us-ascii?Q?OmA6OkuJy4XbHbajLRz6D6+os73IM9ih/UQGPKWQnSs1Q269iH8ueNg1D9VQ?=
 =?us-ascii?Q?XQPaCoFhsAbnxjryydaAKmseVknBkGxIEw3Yq0boGSlJ6nlXjXpm+Kco5QRM?=
 =?us-ascii?Q?YVICoJNIv5m+m3oWLERuwgo7RtM2T6JV/CvXT4v8/9Rkc3QxAf7JkY2qowRw?=
 =?us-ascii?Q?gOBPCUD9xbHRgryxHj51mj+pX+TDqSzaL3tqFf363Zjawset2rw48DF2ftEq?=
 =?us-ascii?Q?t0w9iWhvmfabbXwx2+ymCS8wtjyqgbitlnxNGqzg/+o6AwCSi1xa4t4vuf06?=
 =?us-ascii?Q?gp4b+ik7Viemvo0mgKn/89meyFQ2VasA9Z/YFmVtlOwzesPqgxV7Om/04wRC?=
 =?us-ascii?Q?INHGNgG4+YF8qLzp/p7ZTqdh4wVoTXl9un5B5Pdnn0L0/qJYXQHVYMLECbF6?=
 =?us-ascii?Q?Jy9vcUKSADkiCi+wt+IirCl1RmIPX62+qsBqoRsY7aN2lQ5oDqtUnFI6sx2N?=
 =?us-ascii?Q?QJCfNEXTJaMc6ba7qJb47g2ZJB8cWa0hDHRqjKmT2go9yH2uZgkFQKQhtzkl?=
 =?us-ascii?Q?vcKk8HNniNrDxfKC3TcMPLVDoKkzSgKm+2pwL3LPJHAqfwO/DtfY8/xqRQc6?=
 =?us-ascii?Q?REYq3rIN9lHPXZySMKzeDoUthiOcrllF6pO2JDzULgGnV/Ed4XTUuxKIcvVO?=
 =?us-ascii?Q?0F/0Cv1n7hwxXrv8eK/O8W22QX4YEK8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c4lNPzGYvifQ+2hKHuX2o1Pd7xtu99PUlZ+aCvAyL/Cq62bH/XQRiLMb5dwULAWP6q7uR+broNrcGiPZXNweOnKx9adBB0VWuCH3V0L+2py1DYzjNR1F8quQ5v5ZKqYEBqDY72w2r9LwJBniVA6nliU2YqM+xwFPFe8+ICP0ZdHzZVcFjPDhmMRqQrnNgYYLBhpu8SJ1Pl6Omltg6WfKDAf8U5Ue5SBFhxtxXj2ZRPzVUA5d/RApbdxzsHNuLILlnAWuT92pUX9TD8MhQpstGkj5MR8CUG8kNJo5wNTPt9PvaaYI5Szj4at+08CGu5g3eIEVxgn5zCzyEJ1c3+Gif+SXhEmNYV2y3nbJTPyjKb0gIQvbi3chzDeVg9sX2gBFDMN7dcBAvD3ws5i4qT5zIvXxSSDXNtEWwkeiyaVL/uYIXTohMCOv8vfx0khLGNjmZNj0kzyqSwei9xWW8lSevhYK8rl1sVksshaSmDWxzooKSD9fAuV263lPaMddWCaHiFQ2BGWd57JTBAKmCzfnIlB4tUTl6Sd36oQttKGXfjbkPzIVn825Vl8zhqngA0y8Lsk+DPz4qnGZm131A7wxn/qdZ9nOSerdZBC25SNfhVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580dcf99-4fd1-40a6-fa8d-08de4dbd31fd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:11.7512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDUTomFzK6yW/6L6tWsLc6GcjLwFUizPFTkiADmfq30RFyWrgP7CjMP6FqRCT5pr+F8M0ITtz0t6vjcE1SO2yDshdrM4t/rjsRX0ZF2HcbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070058
X-Authority-Analysis: v=2.4 cv=V/9wEOni c=1 sm=1 tr=0 ts=695e0930 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=NEAV23lmAAAA:8 a=-6nbBwkHK-Ji3O8JpMMA:9 cc=ntf
 awl=host:12110
X-Proofpoint-ORIG-GUID: omQAiaJ4TuEC0NTYHySPqYYZzhwbfuwO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1NyBTYWx0ZWRfX570nrxb94pVD
 3bBYuXMa2oodSENldnoNOVGlMTI+UOnJdm7GuhsPhih0wq8F89Wv9dnDa6+TPyWlItHBqbsOdih
 +kjl+CE63lt9XdaOx+bkr+MFhFlNW5ENifq6phgbwPv/Kr6zDyHpsn6ACfmj1PAc14iloOGUjHr
 28PS4Pb2gpB3D9qaCXYXo/aKde1C4jHPYZMwPWWmCkRgrAm2CI52Yv6KaCTV0rW1Z4R4/o7v47E
 rRopbDvOwfekFGTku7jWWvpH1Ub3qWOSQZIMID0vNK5mmcPVR+kmANf/oZXP0VQMMjF/HlIp2Lu
 +n7IKlqbRKsHVoHIduUvx+qQjn0zz7J7tjZ226HHXRaXKWvnVDHQvJBjLbqOr2ZwTRMegsRC1rm
 dgc2z2aQQ2xAlGtIdJz5UsfBC3SdELenbod7VI0n9GBBHKpt9hpK02P7Dj2VrzhP625OMKXva/9
 r+Fd7LtKyed/GPolzn7pC1fPD4nRDUItOq41GL+Y=
X-Proofpoint-GUID: omQAiaJ4TuEC0NTYHySPqYYZzhwbfuwO
X-Rspamd-Server: rspam02
X-Stat-Signature: rcm5ebq4mrx5sdoody1uuxt3h1csyq3p
X-Rspam-User: 
X-Rspamd-Queue-Id: E36CA140007
X-HE-Tag: 1767770448-993369
X-HE-Meta: U2FsdGVkX19uuG6/LTVUxhLd5usQvBZ9qhUgcxCmkZAUGl6T+t8lmZTsXGvbSYmoBxAswYMRTMrkeJkkrpKQF5yioHFTxJnpziWyhiYHZNmlniCkjg6hx+6eEaXaKbZMvAhxpHxHyR+qbp+BIni08Zu4KedP7Iao6TuATuTv+9NNC1jh+3ubxeJOwgq5APHFmTMA74DwnlrWgVE+KhdFXrOhT6+BiYAkz9O1vx+t7ZLfAFxrtAyvBnf6Tee2ZAmZKB+NqyNmJnh0znI4BfdMksaIF6j+Mq4g7VJcrGLSOCbVOTrOUbAieQSYaQU9l7Pen7iwtbc/53BdS5Dlnfcy6Lyipcl3xeyfyGe1i6uwdCDDuRry4xiMiK5t/Tv8oRI79UZC35t40eDjnVzLnZv3umCqVOIwLcYdkMw/0r90cBE9XY7k+uy7DRqRkZg0Ftn7DQ2RV//Hf2GpYoDBveZFHaFVZqCcP7Cx6MqmyBUol9mysgAWxpbU/8VQGyFM/yhtLo1Ko0BnF74IlCcBmGskBxqQeoum1oKLLKJVt4kAP15vsMtg289YECHE8RRx6Rm7Q4p5uXEJkgBYaDVuy3bBlzTgK1sT4dJaSxXVo8JHqFm9HevzVflx8rqdhwzI6nI/DT/XoPOhKDWoWqcXLllUm2jjQswzpVXxx+mT+hBI9yIjrrKVHY6lT7wMObvu4Gp+Fc/BGcpB+CC5/djUPyPm73sM5c4vnPZLnKnx45MXBU46rj8CKxtRK0EE4ms5qDW9H3zpKVMVwKy/5GX7jchfIWkhUx9iwooR8ImLTUG0ZFMLUhJ97yDW4eiJFyCOAEsLYUb9jHXcko4MqLZwHVNcSzDSlAKN47irz+Psg/5GwxCPRwOSInqM5k3WgIsjZ32XbhSQfBKHFU0nokBYLLsi+TcyUdRR7eAFp/u0WZxfKZeTAWXVJvhP9vbcBi7hW/N0ud1kXbNG2XvSkxI0xWx
 C79elCnY
 p8Gr6PJ1XAsqlqOgcO4cKshlMvSVsErMprWOTGZJHQvBXd4J3gBueTJ9NrWkX+z6NCtAajs6bwYB37KsgO13zVz3mx8MsCbguB91izQ6jQPYcsPRbEEYwX6TiC1I2as9uLnWgfOVW4nG5otKyIEk4t8D0S57al45nm9uxhWxD/IzUdKJB2Q8l4LEQ91XJjYwfWvvI4Jb9zENA4fWnaUy151n5UiTSrfWI/+osEYUyT3Gxgsh6J5ph+A0dTCvcN/pqAPVBXHzVeo8tkhUpwN9dhf3zadwOL3JSBVQfxL/OO0XD/yx7EfZg273Ez8H99YzLEXA4D31EIYkBFmkp5QKEcFIDGS9YqpHmCKjwaJF1KVbfTAetxxKedImNIf2XmhuLkgKK25sFtojCzOh89NgaWKjhDglJkq8s8S03QFDufutLjPJixlaSaw5ZNaVry6N1FQJL8brG1AWM7d91aC8IOIsvgFIaOODZGjhoxNOalKtfrSkdIqKQa2cWLQsrDmTcsfpYyT0mpxAxublpaMYtoA3f26wUOC4WOn7WYGUiqhj61n18TQ06+FgSqiZYnMGf4eiwQRxNmFs0x+SsW2ckd573uepqlmcnSRZMICnJEjTH/pmMevP8oi1Z2CkhyAfD6DRFDN24eHUzPTj0NKEhF17jOAMTMoEefkkDfIwXIzYI0k7ndsYVDN3dC5afcruQb5oq0yqJqVqiKAKj1xtjqco0Mwn6SIh/3rRyfKEVF914z+GaraYr/F4Tg7w66vHAiF5M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series adds clearing of contiguous page ranges for hugepages.

Major changes over v10: no major changes in logic. On Andrew's
prompting, however, this version adds a lot more detail about the
causes of the increased performance. Some of this was handwaved
away in the earlier versions.

More detail in the changelog.

The series improves on the current discontiguous clearing approach in
two ways:

  - clear pages in a contiguous fashion.
  - use batched clearing via clear_pages() wherever exposed.

The first is useful because it allows us to make much better use
of hardware prefetchers.

The second, enables advertising the real extent to the processor. 
Where specific instructions support it (ex. string instructions on
x86; "mops" on arm64 etc), a processor can optimize based on this
because, instead of seeing a sequence of 8-byte stores, or a sequence
of 4KB pages, it sees a larger unit being operated on.

For instance, AMD Zen uarchs (for extents larger than LLC-size) switch
to a mode where they start eliding cacheline allocation. This is
helpful not just because it results in higher bandwidth, but also
because now the cache is not evicting useful cachelines and replacing
them with zeroes.

Demand faulting a 64GB region shows performance improvement:

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                       baseline              +series
                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       11.76 +- 1.10%        25.34 +- 1.18% [*]   +115.47%  	preempt=*

   pg-sz=1GB       24.85 +- 2.41%        39.22 +- 2.32%       + 57.82%  	preempt=none|voluntary
   pg-sz=1GB         (similar)           52.73 +- 0.20% [#]   +112.19%  	preempt=full|lazy

 [*] This improvement is because switching to sequential clearing
  allows the hardware prefetchers to do a much better job.

 [#] For pg-sz=1GB a large part of the improvement is because of the
  cacheline elision mentioned above. preempt=full|lazy improves upon
  that because, not needing explicit invocations of cond_resched() to
  ensure reasonable preemption latency, it can clear the full extent
  as a single unit. In comparison the maximum extent used for
  preempt=none|voluntary is PROCESS_PAGES_NON_PREEMPT_BATCH (32MB).

  When provided the full extent the processor forgoes allocating
  cachelines on this path almost entirely.

  (The hope is that eventually, in the fullness of time, the lazy
   preemption model will be able to do the same job that none or
   voluntary models are used for, allowing us to do away with
   cond_resched().)

Raghavendra also tested previous version of the series on AMD Genoa
and sees similar improvement [1] with preempt=lazy.

  $ perf bench mem map -p $page-size -f populate -s 64GB -l 10

                    base               patched              change
   pg-sz=2MB       12.731939 GB/sec    26.304263 GB/sec     106.6%
   pg-sz=1GB       26.232423 GB/sec    61.174836 GB/sec     133.2%

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v11

Thanks
Ankur

Changelog:

v11:
  - folio_zero_user(): unified the special casing of the gigantic page
    with the hugetlb handling. Plus cleanups.
  - highmem: unify clear_user_highpages() changes.

   (Both suggested by David Hildenbrand).

  - split patch "mm, folio_zero_user: support clearing page ranges"
    from v10 into two separate patches:

      - patch-6 "mm: folio_zero_user: clear pages sequentially", which
        switches to doing sequential clearing from process_huge_pages().

      - patch-7: "mm: folio_zero_user: clear page ranges", which
        switches to clearing in batches.

  - PROCESS_PAGES_NON_PREEMPT_BATCH: define it as 32MB instead of the
    earlier 8MB.

    (Both of these came out of a discussion with Andrew Morton.)

  (https://lore.kernel.org/lkml/20251215204922.475324-1-ankur.a.arora@oracle.com/)

v10:
 - Condition the definition of clear_user_page(), clear_user_pages()
   on the architecture code defining clear_user_highpage. This
   simplifies issues with architectures where some do not define
   clear_user_page, but define clear_user_highpage().

   Also, instead of splitting up across files, move them to linux/highmem.
   This gets rid of build errors while using clear_usre_pages() for
   architectures that use macro magic (such as sparc, m68k).
   (Suggested by Christophe Leroy).

 - thresh out some of the comments around the x86 clear_pages()
   definition (Suggested by Borislav Petkov and Mateusz Guzik).
 (https://lore.kernel.org/lkml/20251121202352.494700-1-ankur.a.arora@oracle.com/)

v9:
 - Define PROCESS_PAGES_NON_PREEMPT_BATCH in common code (instead of
   inheriting ARCH_PAGE_CONTIG_NR.)
    - Also document this in much greater detail as clearing pages
      needing a a constant dependent on the preemption model is
      facially quite odd.
     (Suggested by David Hildenbrand, Andrew Morton, Borislav Petkov.)

 - Switch architectural markers from __HAVE_ARCH_CLEAR_USER_PAGE (and
   similar) to clear_user_page etc. (Suggested by David Hildenbrand)

 - s/memzero_page_aligned_unrolled/__clear_pages_unrolled/
   (Suggested by Borislav Petkov.)
 - style, comment fixes
 (https://lore.kernel.org/lkml/20251027202109.678022-1-ankur.a.arora@oracle.com/)

v8:
 - make clear_user_highpages(), clear_user_pages() and clear_pages()
   more robust across architectures. (Thanks David!)
 - split up folio_zero_user() changes into ones for clearing contiguous
   regions and those for maintaining temporal locality since they have
   different performance profiles (Suggested by Andrew Morton.)
 - added Raghavendra's Reviewed-by, Tested-by.
 - get rid of nth_page()
 - perf related patches have been pulled already. Remove them.

v7:
 - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
   clear_pages().
 - fixed build errors flagged by kernel test robot
 (https://lore.kernel.org/lkml/20250917152418.4077386-1-ankur.a.arora@oracle.com/)

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.
 (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc
 (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/

Ankur Arora (7):
  mm: introduce clear_pages() and clear_user_pages()
  highmem: introduce clear_user_highpages()
  x86/mm: Simplify clear_page_*
  x86/clear_page: Introduce clear_pages()
  mm: folio_zero_user: clear pages sequentially
  mm: folio_zero_user: clear page ranges
  mm: folio_zero_user: cache neighbouring pages

David Hildenbrand (1):
  treewide: provide a generic clear_user_page() variant

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 +
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 ---
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 --
 arch/x86/include/asm/page_32.h     |  6 ++
 arch/x86/include/asm/page_64.h     | 76 ++++++++++++++++++-----
 arch/x86/lib/clear_page_64.S       | 39 +++---------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 98 +++++++++++++++++++++++++++++-
 include/linux/mm.h                 | 56 +++++++++++++++++
 mm/memory.c                        | 75 +++++++++++++++++------
 27 files changed, 290 insertions(+), 93 deletions(-)

-- 
2.31.1



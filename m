Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD60D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142466B00C4; Thu, 15 Jan 2026 14:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2836B00C7; Thu, 15 Jan 2026 14:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E312B6B00C8; Thu, 15 Jan 2026 14:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C61846B00C4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96761C1DB5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:25 +0000 (UTC)
X-FDA: 84335207250.14.2877A85
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0AC8940018
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K06UXwlq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjrO3iVL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505842; a=rsa-sha256;
	cv=pass;
	b=TlBSIgpCWOB5T3MzLH4ZUao+8WcfhZ9KYfayWlYoOXZ3TL9aN20DrDjKWezRA4SAMAjSR/
	q4oNBUYUC3lCN1mQ055f/uina9JAbEPFvD3r3BEUbUtWKzUW/wye7DoAmZAXQOuZpTf850
	CNkr5PHPzuM1kREVpOTyPS40W0Scvx8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K06UXwlq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjrO3iVL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DEb46ZIpW2DIec3nbexXwZYtuMKJJ7ps0/jHhnMY30=;
	b=I6pIKnkfAkOWXgdz1wXpmYJHkCkR5bKmuvNPi0iY76vXFCxcRNImmNhBXov3sVTFc7WqFW
	/nMofzu/PHqRHmDzcZRIa2KgoqpOT912F+j7Bs/lEVT4Ae8WaDxWY+dPOEwCCLRgroKcTa
	MjximMDTummOmyyMZMzgcfQkyx7CWn4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FF3x4W1295786;
	Thu, 15 Jan 2026 19:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/DEb46ZIpW2DIec3nbexXwZYtuMKJJ7ps0/jHhnMY30=; b=
	K06UXwlqxSrOVOERE+uBf5jCrnM43A4dWoCJ1iQi/c3jy7SgDVHcBYPkdE44qtPo
	XlfpPJ2nPQiO/m7YDVKSg3ss4HMSkr1/P41rC8yMFk8eUQUT/QQz5TkIVTyyX9hq
	99OqELl8urC8ODCFlrmHaCe+vCuAXvprB7dFN+jY6GM6w4oZC5uoMtcQ2/KZNfFB
	6dbNvfGCMQ6QSW0smxMnopdsRftUA/Pk+JfhsQ8DXWPuOz3sreBVM/51Fmp07oOI
	jwTEWjZXjGNO92o1C9CNquI+GsKQScTptIVrf2lBA2aImwilhvZho8hAViv1gHX3
	cF4amVLoHZbJTBLYiVnsig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI1wMj001833;
	Thu, 15 Jan 2026 19:37:10 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bpuaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQRoHV8Pf/NL2UxtIBP/W1sJXcRwuF5O62hdhYIAzMkvd84gTvXGPoZ9Hgwq+AT1QF8RyclO0sB/hfueKfuvT40I+vD2hOTuvT9PZw6LP5Dq4rzX3rZy26d0RMtwLvx2a0EKjzq6X7cnifGalv3jRXscjRJBBWfwl37w3la++gAoVYpY8H8eT5ZgQUv8xyXxxWF+2ZiIbQkgRQFSUrd0c9XigT0FjRR+AMJ27mHkSMZs4/pVKqa6k/VYZeSsdy4+MooSv4q0AZ9+eddT/XvlStFGbp588DtDgpHPPEDUWJYj8BxFC6hCOPAlEvxGu/hVzOTRoEtlskEUkcbtBJ13ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DEb46ZIpW2DIec3nbexXwZYtuMKJJ7ps0/jHhnMY30=;
 b=b2UeX3nUQystSDdoNUZcT8aHqv6BhiG1klXeIMbCQCL8M2ruDlEzRxvT/NmN3DVqeNf0jYja8DTD0uVBJA8Ck9M1Cw/CIemHZtBVgCIyPLSXw2d+qZVHzzdIzomhT+yYxx5WAWGhwEKOEeks7o+HqP7aCBFBbbFwhfMaGjFaahO4HEvaNVlt4/u3RpHJhryQPfVQV4FzY0xz3bPLSxLXJH7EUaLW03nDUMifr0kHdX0GDiFzQG/NiP8AcNmVWXppjtNGfjUiRLu144xq2Gi2zIYJB+0pWUIdqqA/VJqp56dtOrMLITydDoS7EDeFK84PzD0wlM2VHx3IkkuD54+woQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DEb46ZIpW2DIec3nbexXwZYtuMKJJ7ps0/jHhnMY30=;
 b=HjrO3iVLdL4mN2HzOAQ8ejQ6PeCuTdhH/qfv1PGptaTpCFolHOFIVBH2XPVG0c8AojqsX3s5tRJGX9vwB0290EYnaq61ekQWkoS80a4rDxP9TfZuLtxBN4mDo2/Q8jxtkwWmWj+jJOMP7HNtm3rWB6WOaPPQVg1wAQ/H29qAX3w=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:37:08 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:08 +0000
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
Subject: [PATCH 05/28] maple_tree: Make ma_wr_states reliable for reuse in spanning store
Date: Thu, 15 Jan 2026 14:36:24 -0500
Message-ID: <20260115193647.1695937-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0181.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b4902c5-373a-4160-7ed3-08de546d7851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oEgnT9KRN3g+dF9wmCTg1FGYvg7LwZHx5ybJe1983yrj27WGs8m0sd4EYYqJ?=
 =?us-ascii?Q?+umG9IeWGjSUmP/69o0LrJJc0iVmUF3wdv3bPvVFIfPZ0rV+NVgoD1ma4MDn?=
 =?us-ascii?Q?2fwmLqUqr8A/xWtAfPFlzt7HMQXEH5jmW7AcXAr/kvIle20dyFgjZC8lgp7r?=
 =?us-ascii?Q?rp3EnnkH/PQAF1MZqgU/zsPqWwpfP6zZ3qzsWOUTKFnbeYK8nsa5ED2ebAo5?=
 =?us-ascii?Q?FnCXNTylfWLK/WlOMMy2B8KxxnSMObx9nFIzTZJ7ZB6iqKzfqBL3/su6kD5P?=
 =?us-ascii?Q?XIUeAhK36P2Jd3ahSytp541AmEfQ4lAhChF34LexNRm8rQwIRaDBDWkQQb+U?=
 =?us-ascii?Q?ZU4Eli/FwNPaZWVo1sHfFhSDuDBaRC6bKl2GfRz4e7f5WxPrSAGsYwqiwRFU?=
 =?us-ascii?Q?jNk/Bcu8DhwE+LQCpKgyK5HmNMJoRosVoF9KiqDaJfhBg3d/sRxHUHEtMj6l?=
 =?us-ascii?Q?MSLP9vwPiSLEEuXKPrII1I8KfwENlS445vO22/p00Ug66oxgAVCFHjgEOZn1?=
 =?us-ascii?Q?nZ4gDig3t/WwzjhTGdIvMrzf87r1+oj1ieZFEe/XExss4TuQ7x/ygXHLg+m9?=
 =?us-ascii?Q?mDdJ260tYuayrmcwYbud/fadokTpxuXHTFMFNlnrvytQIeJMOtCi5sOXToPc?=
 =?us-ascii?Q?sakyy+iopEm8jtrERyYNY+L6uGILBz2xUDVY+zJOyiclCBsBvQtej28w9O9m?=
 =?us-ascii?Q?DgHItI+s9hQFiXPENQzvYIcH0L8Pf1P87DzweaJ3iOvUBQ1xOinXFjeQARBz?=
 =?us-ascii?Q?nFM/BAtUf0W/kjo3MKDKcxKBLK3hsQe7/OhDj+7hJkGIg6bRevvR6ZAZ4yrT?=
 =?us-ascii?Q?5W65mrmW6gLtgvw+dU0NAk8fXfAGTXuxKUaH5xZ/Kd3wmxh2gC+Pc0nTCuY1?=
 =?us-ascii?Q?Cx/XdvYiCaW8Xs0SrwdDcqBtp2bWS/D5JS8drCGeQZeMuxaDv15iRsf2k9TI?=
 =?us-ascii?Q?YMM4hD5Tmoibbp+IuQ4rn5J8dXKt/dRSB5UP58O0iTdLe7WUhHCWpEjnVu60?=
 =?us-ascii?Q?94Hos0j8DabnBR0J3yjEydIDHwhOx5DDhEstsHvosZfrTXXxEH/mot5eNrGG?=
 =?us-ascii?Q?GFAnhPlvp/8eMkcV1+0GlYhVu8oCnccowmDLs+oExwwnzFkOMS2qntHbGuoV?=
 =?us-ascii?Q?XXTtBbaut4Cr1qxx2ahyq57P1aEfJv5XdpxwAOGjguHq4amYjJWXbt5H+xOw?=
 =?us-ascii?Q?FISzsG8jEUK6JzX/8qIf1QyQbshi1DH+0uDMYz50NBio1303sy2yRmevnPu9?=
 =?us-ascii?Q?hlgfVTq0YdAYIkF4gX2DRMrfq2X+UtbSxeWYn7dYYl8dTcFGCOa0LW1nLvoY?=
 =?us-ascii?Q?ZoIMDaYctUFvN0Ttk7gmy+7wiLsPrQqb+/BKojyrBuZUJx6cLi9lv/lWdU18?=
 =?us-ascii?Q?OZZnBx9SzfHaGeFYqplrZ/q5XX84ya2lMWHAYfH1mFvjH0CHZdTzzfhBLfMm?=
 =?us-ascii?Q?meP4wIs6EYOTRN/CWzD2F89TrfPHqqVVBl45qvYd13kleQcp5jP0gu7B0dhP?=
 =?us-ascii?Q?yJrzGMbNsiOQv4o9Rqu0gQMTzoLup6t2/K14cUTSjc3oWvBhXqB43zs3N4LB?=
 =?us-ascii?Q?EEt3jSuUs4ob8UK0fZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ykeyZbbe5RdE1do0i2h0xVYzkCp3c0b7AKH1Upex3q2CBBbUMrLvvtkOzHXN?=
 =?us-ascii?Q?uFEXou7kNel/x97nn1TounwN0ns/4GVO7AACyI2lL03JdPq5cqDfcc0v+EuM?=
 =?us-ascii?Q?/Qo8MWHG6rCsgnZs5kBgcYWcEaOxwIBxHXqDB8VH95QmYTMt73qFS6LHhOYW?=
 =?us-ascii?Q?9UrYYUljjRG5qBsPaONmG6Z08iRu+RWhEmB/NVdxQjoiNbb9h4pCsVBlhj1c?=
 =?us-ascii?Q?y+NtdzA8HKp7eCzs+2X5l8RT5SH/uOsHMhdbTYXGxQqsXl91cKe/n9G5WG7I?=
 =?us-ascii?Q?PmuKvg+VUfxI3xhX156X7gEieyA34+QKYQPvuN6x6uTijcWxAMx3u52K/13v?=
 =?us-ascii?Q?Y/rO+T+u94LEERbWdnCpVWRRtYmKwohnB0ZVx/0HGfHJMSa4lCc+Ur9UqvGQ?=
 =?us-ascii?Q?+sFPcgQeRij10QVwWZ97Sm/BVislSEivq1JUfN7FTEkNOvDIQaCsa0/CIYR5?=
 =?us-ascii?Q?wn74rhNkF/EGElka50b7h68y/goXHSe8tMNcmMF8JL5w5wM8Ea15EIgHgkZ+?=
 =?us-ascii?Q?GtR3Bgaud3Dixr28nn61rYd/MPLKXJgHaEpaR3BqPn2ne40kL7LG4zuL3W3L?=
 =?us-ascii?Q?1JRZMunq0sriyvAFHj10ing8kmIwg7No16t0ArpL1dt/+lzYE5OmJ/1QqZZn?=
 =?us-ascii?Q?CArBbGnbSo/PZfWOsksKIEiVrA1Ml8ywpTp3wy6chgD2ztz0t/501LakSniW?=
 =?us-ascii?Q?jmObuq2WBaIIpRxn4uEj6QxUQ+lwBnXxYg+rKlauRc47cIsSKBHXuVR5YORf?=
 =?us-ascii?Q?wiQli+n+iRWmaDv9W6aQ8UGQy1VmyTCqnKFWsR2W1A0QPXKyaL748EFutgVw?=
 =?us-ascii?Q?kMWC/vHJytzkb9JnBar89i0Mv5h7/G3ArIJJSS+7leL3Vo9qAdqbyIU/RPC0?=
 =?us-ascii?Q?k7D0ebXe7x73+AJRihrsCEPf8P6eNqrr2XHIF+vgacm+Yu3oWwVVfZgm5/zR?=
 =?us-ascii?Q?39zS38JE+EINCHdCB0LcIGFKgFyeqyw3wVBtgPnDfq96Hvir/uRK+LErqUga?=
 =?us-ascii?Q?QFGx8xkZGpaTRo0DD+uHtZaTpkJu5LZ4YzlQYLQI+xk1CTQseyg8wp7UZHsS?=
 =?us-ascii?Q?Q3vK1aJFC34PkK/bl67xTGKh+4bV5MYuiEVcxL1DgcmyV8FSS7zfeJYrR1hX?=
 =?us-ascii?Q?meFtNbtKgTAjiDcg/MwLF52iXDa/FHAWaxDBejVYXLKJWfaBZougaQpl8uly?=
 =?us-ascii?Q?Q72sXeHPR9apK+m4lBUA2ScA+EyX9zHZ21xY0OulAL/M+DBcjsU8eoKCThnR?=
 =?us-ascii?Q?TWbolqpYVvqDbGeguDGvexDN4XRf+Di7g1j9zjUD2eTipiUUQFT1tjmAOGOy?=
 =?us-ascii?Q?9gyOcHKISPo/t/Z4yGm4KXUQ1sXqpLizd8XNqAPgZVZh1ALiqrSOYjUeF1VA?=
 =?us-ascii?Q?LeVOIj7tUQoIIZTNMb2BeyKIN1XkMnhr/ZCa5Khu08nPw6Iah0N5jZu6kJRj?=
 =?us-ascii?Q?6YOI+CSPyoQeZSylrvPHhWto6FbjTr9jxnSBrPfYT6787wH6ISFJcgsPO+Rd?=
 =?us-ascii?Q?WxyWCW/RfUB22LtFPr5O5m1Hk9d3J21uxlfAYQqLPZFd5ngPaBL4cqorcBH+?=
 =?us-ascii?Q?ZFFjAIpI/eaNDKe6Bz7b61hJUgdHO9S+68IKVLI3SeZ5ouL95D5em86KgrE4?=
 =?us-ascii?Q?Ewcm1r3EQZxr8LDkbXNTqqN6fKsjHBEJc5zvj3O440fJSQlcBOWI8zsIe8kQ?=
 =?us-ascii?Q?D2zrR7czfQLs1OC8T+SvBQH88FqVBaAEsQ3XsfSx+voyyAWhpgIfoqyFrDfv?=
 =?us-ascii?Q?LaTGyvZlog=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6sTGWgLQ+N09fLV2IuFn4Gya/ay7YdroTU/zxwAo8eGEe0c4TVdMGf/KeXYn0EMIIFmWD4+NYLZXQG4YhBx5u4kaDTP811dll81yemehQPP90HrWvobYRfWtnXNELDpkPeym7JQL7LOC47guhuli2YOFUk/Jgfx8vnyonHi5Tw484+xQuSXDEk3j4VldbSSVy8YbR7y/Sg2wm9l811VmN+mqbTfRIfJoBStZhyosM1UgWBBDdgZiJ0FueV+zpLcooXdUcJueoc2T4BMZFTf0Ll79RL5avzWhxdsjhVUFr70jt9ianzRyZ2mcto/HRu3uRVCBDmFKA4AiUk/e4CS9y/TaFqR9jddX3z3dGDMcvu6CMOXY4ktKf39JI7xflMb2kczpFXCg8QO2nvftZX+rRJB5PwSG4Kv3HRBx7bwVHCkjBIcJ83Tszo0GeLJvY5OFaEjrOjuDvACXADZVTpieVzMa/NvxGrBp8Fqh6AqtcpjO1zWWWKEPhqExrzUxqfiWArhS8hO2fhPM65E3VAY5X05iDAGzmppyBPedNmccSO6m0xUPVGzaj0iYueRJj5XPFrdisD4aPnal9BfsbhbHEawEgNFqNSfdb7kCeT4WCMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4902c5-373a-4160-7ed3-08de546d7851
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:08.1408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4U2aD1iFLc0zZ5DfvgTYOfx77JP2bH8x1H+iamDl9xnarBAXPvZ5IMo0r0k6jX72VNydTFcggbzmvL9XLiOLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696941e7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gTX0PQgR-87UWUccDAQA:9
X-Proofpoint-GUID: aVSJvAaGzjQ-AuqNCoqNexPdi6vYjFBx
X-Proofpoint-ORIG-GUID: aVSJvAaGzjQ-AuqNCoqNexPdi6vYjFBx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX6gSfhjZsG60Q
 x7oOkmbPzlIPypHmyuA/CLwiR1+qULrSQee9gPwyqigIs/qdFxKWoAqApby/NN9gt5lQql2eJps
 p00SRzet2kBCJGH1CUV5/mtzziWePfdkBhcz/zUCICvuR8QjmQ/zyGeIcyku9XSjBSxQlHpk9PQ
 hCQmMMJsFAI7TdSFenLM2+srSBh5P242COv77cXGLbm7yl+DJCp0k5ZdPpjaqWDgiwbP/mHO1mp
 EJbLzI2gyrGTozJ/NO8o7fNJTkVHMDtnXm0LM0DAh08C9tGylp7s1IowO8pets824+WCapxl++N
 O5MmdKZOGfqNHMQje7GkAuSkx7tQ89jCe52HAb/OpCdSu99c+aq3Nh5Qb5/61OQD0TeLoCDfFf1
 uuqEdD8Ro/1lUW6iuAv5QIfZ3p7WqjfB4BMnDUJFBl3kK15MiUadei/KBKRhQpvedQAYPZOMjmj
 T3JJdBBolBg7Aqxiw3g==
X-Rspam-User: 
X-Stat-Signature: 8k3wma5g4kmjeq77ug37nqkxt8xs3ucd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0AC8940018
X-HE-Tag: 1768505841-72561
X-HE-Meta: U2FsdGVkX19blAOp1fytfkeo6jvT+I96lYezF4uEdRGPI+29yPZM+F8DFbHVYK7hX3MWPYD/gPAXlb8JfxDhlc9fcfincABMoXVch9YX4x5NXzPNgoJGDh195uHV6orcl40q9mUJUQUYVP0ZSKxryiTOkP8EorTQJjukakveorX8zOohPBH+167b9CdkVktOS7JxnrkmlEFzQ9bowswahxHaYXaydbWoeAtiIreKDkDu9AWmzG43T8C0tlPbECnQZ1VVGG3t5I+vVekms/EFFjQ2NqAwtOI6ousW1KFn3GK0+tCZd/RNMiu5bujSsH4Lkc1mXrsDn+Ph1t5XNPSDjKzlBq3frtSPJjJFwrp3FU3cedhRMW/9cld7Ii0hBydGTAY3DzO4o2GdM+3MRgtDXcdJ0twd5ydzv1MUxI2vbjOyHJuKoDxYhqPQEaA7a3/eHZ9Zlm0ii6EPrVkEfeMwVL/FlDdMdD8nfaN0vg6/pdIX4oMsnDHXN9YitPW85aFRcET2saT/41aHU3BmO70tFS/eY27Twy1xosC76dfD8rzuEz785YdvKOGCPWMiLsGFvFAbiiKV2RnPU+WjTyA3cM6MOn4BYnjnTKJBSJepcc/BvQfWlkLJXeJ5IoY24YOemdCak77cgS+jQ/R4jbm7Ufzdv8crLvfm5HyzwY3ot2h+FEFSlHzNRagUdtqLsyJ9PWLPW8mDPOc+YAeURiu359S9kShFSqP9NJOgV3Y5D8QHBx0/NXL8smHhuZcpWykOb3XocXWN4hvRv+nH6zI5v7IZWi7LGqUpvCRfg4YqQ3jWIL1CZjlV2R5ocLpmx9BECUmY9JhOQyZigqKFgDNNrmDojo6xygVirekVPvLijtpRYfwNeHkJiK3uvJz6d201DZPX+IaDuaxyg5eJ7U2ww/3c7Ko7JCXqVkRfy23IYrzahgNp5yWdW5yKoutPg4/TOc7zsbFwOH8tirUUIyF
 0fzpUHPq
 x2JamGjxszKIsjt3pPm0uC0xuJNr3pCc3hZVmX9pk2w9BeQhfiJ7tKz1PWTSuHV2hV5nt4tpSx+JSWcpR/lt9bxd1sE3Su45cxjH+XSIQf3cG7tNYhCy5iv3xfwtTcTZAv2404ly3vsj9EE1FhJRPm8jx7gRYz5uP1/leAbuEVsXLRj2QRbEmpwN+UgvabhjAuL124NnsGfTQFK87zgLhs5M87Mv77rIhcbDDclskCBzsyXdxeCQ6+lTGrpNXNCqHayQu2jTae6qegqHYgkBvmK8WcGDg1PuuZ9FfIGo/3Pu1styiITJu/Iz8Jyiko31J8xH0+lXsvwNiLg7NThvc/r1W6c/Ge/n8cqdt+LhgkcpWmZ8x27d4Rkinm5zYp1XX6KNm0ACaTEzavdGiwRv55DwqoQAmQVfFsISnudaFsHQAl3BrdCCIOne4MICqlOuBzFzovojX9lr1iNA31gHtfwKSTQlLBksUrILHAdCyLRJKRP/LQmvuHCXczw7cCbsTFRiF0BwvNeP52AAQqUlUJMaUEi2b1uUGr1YmUrCkANAYJPtRCaO+kWpG/HT6bHni6UMfI0HMdGhA7LL56VPh+KH6mROdKQrivQbm9dbZhNnfoIm44gkzxV0G7WSNLL4duJG/ZRMALE8KBhj/nYFObMkOHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() was not modifying the range min and range max
of the resulting store operation.  The result was that the maple write
state no longer matched what the write was doing.  This was not an issue
as the values were previously not used, but to make the ma_wr_state
usable in future changes, the range min/max stored in the ma_wr_state
for left and right need to be consistent with the operation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 67158eafc1d2b..be855f204bcf7 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3319,6 +3319,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 			l_mas->index = l_mas->min;
 
 		l_mas->offset = l_slot - 1;
+		l_wr_mas->r_min = l_mas->index;
 	}
 
 	if (!r_wr_mas->content) {
@@ -3331,6 +3332,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
 					     r_wr_mas->type, r_mas->offset + 1);
 		r_mas->offset++;
+		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3



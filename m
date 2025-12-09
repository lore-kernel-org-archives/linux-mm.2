Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762D6D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44A26B0005; Mon,  8 Dec 2025 20:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE706B0007; Mon,  8 Dec 2025 20:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EF46B0008; Mon,  8 Dec 2025 20:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4526B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:39:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0796458A53
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:39:23 +0000 (UTC)
X-FDA: 84198225006.26.05BB174
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0750180016
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:39:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mDosgxYG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ng1vsc/a";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765244354; a=rsa-sha256;
	cv=pass;
	b=Hsnmr/2AUQzPWgGc/xNSlzKkQdFoA159b2UY9FZXP+c8AFdzajjfI9aDSRPAdpVPASUGl1
	dMN9XjkjoZGitm0fiPUyn0Da4Lhbev7++bAhm1kB2pfB6ry5TgEiJWqxTvyg9Tws9g2iWr
	CaorBv5omojGFBe2wQmxC8iiVPy7d6A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mDosgxYG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ng1vsc/a";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRiUKkZ35ZTxtoltmD2BUyy09Aq9pK68u0oaCReTIgA=;
	b=KxuM0CX4COFJXVzavB4biIORh9j6Tc8d0qejByf/M+BmoRyYksHXwxXtMcpfkT2sR98dri
	UXT+kR8BLH5TzZDSPgcSHkBWG/1Udb9Vrfozzj+fuAKRDhXaaSr/jdVQK29cae+D+Ws7QX
	e7WdbAGryNNKhJWOPBAVhwCoIX9l5SI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91at5R3880162;
	Tue, 9 Dec 2025 01:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zRiUKkZ35ZTxtoltmD
	2BUyy09Aq9pK68u0oaCReTIgA=; b=mDosgxYG9fgD8bwbH3RIFwX02NYQiwVicT
	Ik4t81z+EaP15XAz4BoeqOspL/5R9TaLygSFhD6oKbrvDA+Mz9C2LnoiMbR54ud1
	9dd776UD1RUtSrApuCe3SdayxYBRDyYJcwEoMpAv1ouQi4RtLLbFTpDDAQTfNWsc
	tx+fw/LbNWa/mE4EkYu9ZPkyab6NfvcG2YmEt91VfVF8SQ8wUT9c8BDqHk1l8Bag
	TommXx+7jqG7lXipIhXCDzqNgk8xbyXagez732WTcb3QfgkEx3z3Tl5a7iPwD0Ly
	13JiyOHJFN2VlN0YkYPOBxwDJsXdN6X5pPTI+P9/VX6qqg9+peWw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axa8kr02b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 01:39:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91QIxt021113;
	Tue, 9 Dec 2025 01:39:08 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8fxur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 01:39:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fm2E/knogtEv9CVyt41rOPZRkDkXMFdydIzaIdhhm5n7XaKUVyN5mZS9Jtsv5NHdn5WiohUOTLor/kinTHsD6QDQdS1nj1CHqw+EaagTmSpiAU1ind2s8zBGOSWo6roF7H0ZDtVGzn+EEdGOkugWPQu2VknIEHt+aJDsSYJ+RsxIrLWnYsCvwrh30n+BmAlfi9SDkjvVwHjMB+BfK65p4tRV2+crlAXxCYiU1/CUJJyzBUEKepBJXJ1DK5EMTInxnvit3L6pqMCeGhQDk9VfS7JfoT9KZxaUWrD30cz3hT94V7RWFpbZJnzxpYOJE7TSjHgwxoyd7E+yR8ciStDttg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRiUKkZ35ZTxtoltmD2BUyy09Aq9pK68u0oaCReTIgA=;
 b=VQ4gMSkTfvTJvuotvgZbtluMJ8RsIxzVahoDuXAjwX4xUYB37iLgYViunXLR4aGlDn0M7uVX08idWKXaUjKwWReP7UaS8aIUeMZ7U4e9UQjDedKFpVSbkmvGwNsu9M/bpwe35EJib54Ty6MvhjmtEcCD4GUUkF5kP2sGGKlLG22KLO0IefnZWl/gBtgL7+qa1SoFb7XTb0q1RmdJmhvbt9R/fe8qI/yhOki7M10qD+r1lHwBTa+YYI++gymIwA6ypp3tSr9Yr3FF+d8BnbfS1BWvqNrzyO2k7rViByF+EDTeEfpXDnzws/gk+wW2K867zq7GZAWY5aPeJ6T3nDwCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRiUKkZ35ZTxtoltmD2BUyy09Aq9pK68u0oaCReTIgA=;
 b=Ng1vsc/arjeZotvDsxWZ05UMWCIf8778eUL+TW1aqCGt3nU7r4EtQzffq72neGnxtnv8sFmycoWCU73aRDB3REXC8ECJr+KyoTdITi3N1LXXTkn3TLVnTndxn8ebw33o29J4XrvvdeYFzs8iCS5YaVjL3Q1Ver6EQsf319OlaNA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8442.namprd10.prod.outlook.com (2603:10b6:208:57d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Tue, 9 Dec
 2025 01:39:03 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 01:39:02 +0000
Date: Tue, 9 Dec 2025 10:38:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
        Alexander Potapenko <glider@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Feng Tang <feng.79.tang@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, linux-mm@kvack.org,
        Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH V2] mm/slab: ensure all metadata in slab object are
 word-aligned
Message-ID: <aTd9rNgjahFZRbEi@hyeyoo>
References: <20251027120028.228375-1-harry.yoo@oracle.com>
 <1bc9a01a-24b3-40a0-838c-9337151e55c5@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bc9a01a-24b3-40a0-838c-9337151e55c5@gmail.com>
X-ClientProxiedBy: SL2P216CA0118.KORP216.PROD.OUTLOOK.COM (2603:1096:101::15)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8442:EE_
X-MS-Office365-Filtering-Correlation-Id: 154c0bd3-052f-4a31-a13d-08de36c3bb6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zkjP5uVNIkA6gve64Ryi8xNiRp9jyzTOBxMvnfltmgbM2Gdqq0cxjDMpAJj4?=
 =?us-ascii?Q?BSioiEUjvpM0+VJpkf9hfW5n573hDSsGPypS0GybuDeaXgLB5cvvMohY3q+5?=
 =?us-ascii?Q?zLeL55E+q+Mm8cutXgdTaGwW7bxw+UHt5fepUruiSIu2wn6bJ9hO8hxSgakL?=
 =?us-ascii?Q?+EQTxNDNiliwVrgFR94SVKDc0OEMNs7QgCm3T7k4r9FrKMjTL0urRsu8fZKB?=
 =?us-ascii?Q?218xdOxYV1DXAIiLaFo2EzRVNZM0n3myKys0EaQ+JIdw+MAn0Sze+Kjr/5UC?=
 =?us-ascii?Q?b0RII7T2Ln2AX3M6RZG1xb+jej4PuRJMP+TutkiwE47yAx8+RiiQjU78Od2B?=
 =?us-ascii?Q?3iBUg9AXBYiT2zCe8gV5mVM4PeI6gBVYPgCDf7Qx2zrvU12mh89sIQEk6WCK?=
 =?us-ascii?Q?fnrlo7BBDuVCQtRk7bd2vAFe51prQmT35MtetwnABfiggcoWKAs67VDac3tm?=
 =?us-ascii?Q?o88sxKg3NvSH/ksUgRYKsRzDsI0mwNqHZuV1Iemrw7FNUi9DsXIL2xdk8oc7?=
 =?us-ascii?Q?fyVD3J45mKdX7nIStohgAsgkmCNtxrVRVJgU8k8609MIDdnzqTkFlQK39t8z?=
 =?us-ascii?Q?OTLgX4xkNhRP7/dBWfuMkbk5RVxqTfBHbPlN2eFw2Eh4bst+GEa0RNPo0hfs?=
 =?us-ascii?Q?203av0OU030aOPoKNqHnJpsoQI5up9j6whY878BDxjMnUnQ9CHy0rHDmaTlC?=
 =?us-ascii?Q?XDGwDUiJ/M5VHVj2lr/41l39mAVVvYHgSrqjN72SVLSoq6WahI4BNZC/+ioe?=
 =?us-ascii?Q?/sP0IjR/9JCz60dn82pJBd7MGKkCzTTH6t9rfDh3PyQHBwPfLgDlaTWo5Fua?=
 =?us-ascii?Q?1vDtczCzKeSu4NYHYRSTxPBQhwAgTErOZuW3EJqex8SV5wB6eGm9SY3k3i6N?=
 =?us-ascii?Q?txkfC4Di0e9nmJum7R/Ux4f2MheaP8MRCO8r3FG0taJNKI5pgICTX72GAKRn?=
 =?us-ascii?Q?6HtgqPog1l9NcO/oAW8P2vXF2n/+vj9rnfhDkSyHDh7tsc0p9gNZzWC3Xgo1?=
 =?us-ascii?Q?+nhZNLxVnjkadpCr42K/BJXkFFOFNViR7PCGEmS9yabwFTakDp9s9i9KE/KY?=
 =?us-ascii?Q?s0u4Vk7F/o+uGcLCP21cGLlUr7h8WtFWKp0G66hH8Sxrzio8o+rtnHPKQ9RF?=
 =?us-ascii?Q?SYBCJT8FVnV8YpFpb4v4DIp3odr9K1WSAyR4hB+YXfwzVlp9k6x2zh9AhGQk?=
 =?us-ascii?Q?raO9+p8jM0jGDSA7X743DKW3wHQ/rlFURJXq4H8WTUs4OWTcUvdBSthV+3Fs?=
 =?us-ascii?Q?QK3kGHCGPqfRCmX4uaE/5CHjHBzL3hXetH/jUC2qpj9zPmusN7y20bmFk3N6?=
 =?us-ascii?Q?Wd8Ix87WHHvbKD+BK6A8FPqur95RNaiQHfNiTNacINhHBK3V4HqWbq0vDrqi?=
 =?us-ascii?Q?OxqZlubSOufG/esQ/vkjzvBbKKpm9Y+78C7IzdvB/BP2/HsCCzxOPSUti9Pt?=
 =?us-ascii?Q?m3RMLShMwz2BFWMtkX9TIsLaBhaT+QnH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tvovmrcMutCJlFgP5mJDJ63SLXc2tlXSFPFxR5TQrewAT25DnRB/dIHM5+i3?=
 =?us-ascii?Q?w7ziEwCLzjEP4VHyBKpzo7dTSCrvuPsslSf3VstsnUmAVZscfqBLj0X8UqeU?=
 =?us-ascii?Q?zpjMY8vMxNuG1qlfClHhGX8z3yAyuDFAMwEVQbXEskg5UA13BTTJkF96lWc0?=
 =?us-ascii?Q?HKTsn5YLt9fjA6fHwC1uwlMrx4tHfp/fXfmNTErFG1BwvkBCxt2o4tY39Alm?=
 =?us-ascii?Q?q3RUdmy1z5Ed0x11RkXi7QU14SwV2T8EUGjzB90FNak22mTZW6rJK4s++0yo?=
 =?us-ascii?Q?akPUv1LAS+6oC4MDLiXNtC0x1fCXh3ZCUj+MZ0H5n3Xu7bWm32HxxMFD4dkA?=
 =?us-ascii?Q?eFo7cklT4dFMJAj7itG+71SdaxLOO2+gIhbj8JsYdZLZ3w0eLw9yVPwaSbgc?=
 =?us-ascii?Q?HvmVEXjkSlPtJdiuf9Cd+Ti1U3A3/Ph/Z70Cc9Mrza6xLnibmG08xBePyYcp?=
 =?us-ascii?Q?uDbjTZ5WK5GSxB9szJIp5WzRcz6xB2PotJnBDUwPQ1rQKMWqamh4mY/tUtaw?=
 =?us-ascii?Q?voWq5mv+MDRvF0NNWPYFw9X2c0Eu0xnSsLc9eLl5ImbJQJlzts8IWHb4aCJv?=
 =?us-ascii?Q?s2v56qL/yVEL0Z9jcx8yMlJgluQYa9PHFFEWeigO0/Bs6Yh/rjs+iH2J3UWg?=
 =?us-ascii?Q?DgznCrmOfFpaY4gfLfVqdXv+0rTvHpgMeRT0uV21Fm8vMkUg8JZyNvFmOH8u?=
 =?us-ascii?Q?3a+UH0r6c74Be8leEEcdDSYsWhvuYyipUJBNL3LISOu74bxXdg+ch4mnpRWa?=
 =?us-ascii?Q?BYk2kHxKMNP0oTMKbQYc3pxkLBhMfwnE6SYgBF8e9XuZI2PmDteRh7DE5pEL?=
 =?us-ascii?Q?9az37nkmhrG9f69aJwEYsR6nZ1LHPZsndAQswpqThWzLOmGHAImveCI5v9Tf?=
 =?us-ascii?Q?IAgodLF3kZF1jyKO4X0FCLIoP1zbnwiAFWoLVpc9Jh6STzGNxuHK9Z79sjl5?=
 =?us-ascii?Q?OuNpYdfIvAUcoMMdiafMjvt08x2pZ1b58nMtV4RNzXe+rea6U07QqQmLj8mw?=
 =?us-ascii?Q?F8eicPXokChVHSQccNsOnCLMDZbwS314R66OLCW89ynLfJdk0VgdDlO9ymiV?=
 =?us-ascii?Q?blkTe5i5qhFYqOVl0H2omxZLfJ4B6O7wsTuIlL/5MHc/m80qV9FSuHSQvPQb?=
 =?us-ascii?Q?rLY9gjRZNCK6bCKfvJhAOzkFEKlrS9YO4fR8IwxhuvXctpWoaB39z7Wbati4?=
 =?us-ascii?Q?2ttpgi/0MgJIktOFsiy9flhuyjw1QWRHe38sXB/cRh8dPdigIHyILXpoYCcE?=
 =?us-ascii?Q?cIxkkVpTtPWMr6m+e+b90WX0JC1RA78KowsWCMfuk76HQN6iHnfr3eSpj6hL?=
 =?us-ascii?Q?GsMgDoOD+MKvvLoepkYID8S0PSUU0EZNY5A9BvNetdtbspaFfSvYBuga9jdK?=
 =?us-ascii?Q?CudSou/4XEyW3AyZ7kWacgOBQXsm9l6T0DosnWGkKE9nttF2RmkiIuSPmq7p?=
 =?us-ascii?Q?HIi2eNvF0eJ4VPpdXf4Wcj02lZXSPxscdhGIxboJDWaP4VjoCh8KL1cOh40H?=
 =?us-ascii?Q?rebrumMy1hYu4WmdDZxYm2OOXE4kU/eTYhYhRlpvCTd4w2zm49iSS7mIY9q7?=
 =?us-ascii?Q?QS8/W/8f/IHHnNsktMktTtVArdOHg1QMNpQ0hiVC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gDu6QwfAdJsH8SrmzAJQ36Iifl2jAt75bND64RBU1B+qUJ/+jFwu4wrfnnmvhPNDEKsOIrvfQ/xEGXWx8tjEA6O6YqGmRi7UlyQYWx1dk/yFCNmsZExg0bghiDHrFAtdmw2DwIxR4SmLmrHekN7jkG1hPQ+UffP8K7Tt1XGQ+BIdLZLK0qA5ag6+nnu5deNpbW+qYbA3lX/ggRAS8m6JYsMkSzEZt1GI4HIh2WgwEpQtpziRR56fGAk8hje0UXJnRu7gQcWgrU/y4misfZbXOF84lYiVo38mBribW1Dua5G9yx+YCcHa1ZEBUyCPUurfvly3LmlomZOUyR+ID6QbftvXGF/K5xHrYbnnVmyI2YbqWbDQvsNbuSQAA8vTKZoVKeC3qaGm99qYOLJStOPczfKqiTrvJn/RIw4Pj2OXp458TWKfo8qvTTr3vguC0RystzfFV2xxQMJu7rtwjMyS0FFQJdbMdhXyCQGBo7G55gKHEmoe7g+JOaFJqD71RsyKxLEw73JLPxREsN/6XIVRWT4zR65THGXjMFjtnAI+OMoZrRrSG2mNKmjnf5BIu/gQmHrMjfM3UMLqf/CylnDJzq7Ofls1Bv/9xQpCPLrMmJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154c0bd3-052f-4a31-a13d-08de36c3bb6c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 01:39:02.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZGyTECmhRq+SvKExONk9btkVMdwigVOHvP9TwFeDqHIYqkzlKzVw6wJPuIBtU3NqQS9JLiglStriVzBjRB7gqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8442
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=996
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090010
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAwOSBTYWx0ZWRfX5yWW5iBP3O2a
 Q55cQJx3bdVZiXUYmglckTlKVjPKy6WijmZPKIePRbnXX//yvO9L7/esWYHQy0pfxGnhyztujZl
 44wiELX+5lJPp6eTaWK5vHRXQfB79P2UMytHiyyeXTiBlGXSy8Bdb/FMuoAmRoFS4oKP1t7jszp
 YXaCucBnHqCPIW+9atY0i1jaOfAawXAJyO9K657ii0gfkpPHIu9ZTGisPx8ATieVimMukTWUR6I
 fRE75HaZJ7IXES5wVNJOh9PKHV0YuzoRI7Gu4Sfzs8kJnBFPoN+jgN/fKlTU/vkKvemVkI8KOkJ
 W6z/ZA2a8aNClptNv3SqQvncO/V+FlUvOkqz447YwfA6gHAWNJo7R2GuNGnN48ty5TggOYO9xhp
 3wnWoTlXLjnLLct7iL/p05o9IUidJQ==
X-Authority-Analysis: v=2.4 cv=ebswvrEH c=1 sm=1 tr=0 ts=69377dbc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ddmaWls4HE4ikYURDQgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 1J-tujrjYMZ6Dtr4MIM8OzvYSQ39k7T9
X-Proofpoint-GUID: 1J-tujrjYMZ6Dtr4MIM8OzvYSQ39k7T9
X-Stat-Signature: wwhyak5o4oh4upbnchoouhi77zh584ko
X-Rspam-User: 
X-Rspamd-Queue-Id: B0750180016
X-Rspamd-Server: rspam01
X-HE-Tag: 1765244354-137688
X-HE-Meta: U2FsdGVkX18JE1nO33eFXS/8HaaAKIjFEOaXkj//2J/E1XPAP3UujuObOIO0MC+gaTdEdRZVv+fg1PEDL47rZmLzNVRINMfbXVMb0PyVr8p5HpsY2AgOna26vbGPzzMta8KLONw3mzj67TXVxl/tcgCePLQw5449fZqRAT26S51/BzYXir9PI+ZR1P66hkFo892lillIesEr/VX/BbgaOtLtpMxk+m3majBbRvb0akwmNvs6hwD7acuaBQxUOkcS6fXTN0FH7ugBj8GZ6t1IeWFg/KLsFwz8preMNvQUXYF7CMCvbI1Zg7q8ZDV7rSWekOF1zCeU8B3mF5vpjtDB9ZyCmOX4P94uDrne95+Vg2wmjq95Dafs3YQlNO7wWkFYP2rZg6SzenmwLl+vc/rw2yRbaaZJvxAjjf6pjFBIOKIS3gWyRwGANoymggqAsDI7nTIQI9rsBX0Ub5druSVV7fLQEZpaZxJbnLuhOyCdQuUNlfLfZ77E5EM2agAgRxBSEJ6Ca+TSuhZQlNyYW/laydeqZKqr/meTsCxw4vvf35PqOiIopIvM3FeMUjjUOPqx3gAASGUAkliemxJHcdYqX01EqJRQ4vhden0uCw94clYNpJrSF+EMadb8VInINIUu4+tLM+bmJTLqvcce9zZz5AczvEWC1+e/SGvAhW3myww9a4SI1q+mQTR/+S7W8KLgxfSc9slw2xKLITmopN/ESqBBb1nAFU7i9OJyW2vgGE6w7rqqXHVTRcdKBev0tAvf4gw6Jdsozo5iz3leTrClDk8FYLZXx5bSkDagho91o4RjqtEqG8kf9OWBoSSnDvjj+6ysFKhsXj48rLmXgOyVVm/+Z9vlFzjLwBePzOd7wcYxkSSUV9qc9Uyw11ZPSmah3EdWrCWot8/J05YPfoWbB5tVnXsEIK58HVZhbfTm8cbOztYrQyp6Itr7nY19IaCTDItik1V+13zlgPdw0Cu
 +e94K5kd
 EufZNTXlWL4aPXH8Hg8ztev9lVvk7TcbW70M4qjfjZwvYDKiGjzyQGbJVBXYx6TAeTxFR6l4pjBC4o1ZBiGku6xIfGNKHQBghj3fJ3L1ydS/IkeHKpPvYYDjEwKn47fPpcLyDfXgxpelOOWky5FZdyTTsXivVke5BAPCQfXQ6rIlSUJ6jTNYJxREliEWOVQQRO1Q+LaI+meSBoaPbo7fC2rnZGFluglnsxwILz1hUBIAJSYNHtXBS1Sxq+Ywq5hC3J8OyfXBnnPMwdVe07lSiwYjMBUySJPm+hWT1RbiSNLWOEPVGfkMvZ1Sqp8zl/UeO3DBjRhPizJcGfawFebImfmCm8JSX7IsOfknKhsoNsnOjt6UEQOOFPFCbz8wfZOIm+JCHyMBAUc5uyIim9iQuTNKsgmmxlngzY2SpOiKZuZHHlxovEYuPUjuiw9H+GNWlTMeuiEsMvPMAtlKxN6yXj4io0p7t9M9et9TV/owVYKIfRZOn7u5er0svdSnhF79bEVcUjxPBZBUmCBu05hb+7994sk/3cVu4QKXAXXI4TQnwaoi1wZDH2a+GiWCaW6gTNg1f+oCs/0KhiiKFxVFAA/UmPBVDEcgI7W4Nz0aBVDWXg9ILCkVpldZgIV8QvZ9pao4Xd7Z/DtX57MALhc+LmxRE5qMoD5MjFaZ9zgqpdAAt/XztPJsZYV4MljO32LrJqzB4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:36:28PM +0100, Andrey Ryabinin wrote:
> 
> 
> On 10/27/25 1:00 PM, Harry Yoo wrote:
> > When the SLAB_STORE_USER debug flag is used, any metadata placed after
> > the original kmalloc request size (orig_size) is not properly aligned
> > on 64-bit architectures because its type is unsigned int. When both KASAN
> > and SLAB_STORE_USER are enabled, kasan_alloc_meta is misaligned.
> > 
> 
> kasan_alloc_meta is properly aligned. It consists of 4 32-bit words,
> so the proper alignment is 32bit regardless of architecture bitness.

Right.

> kasan_free_meta however requires 'unsigned long' alignment
> and could be misaligned if placed at 32-bit boundary on 64-bit arch

Right.

> > Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
> > are assumed to require 64-bit accesses to be 64-bit aligned.
> > See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
> > "ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.
> > 
> > Because not all architectures support unaligned memory accesses,
> > ensure that all metadata (track, orig_size, kasan_{alloc,free}_meta)
> > in a slab object are word-aligned. struct track, kasan_{alloc,free}_meta
> > are aligned by adding __aligned(__alignof__(unsigned long)).
> > 
> 
> __aligned() attribute ensures nothing. It tells compiler what alignment to expect
> and affects compiler controlled placement of struct in memory (e.g. stack/.bss/.data)
> But it can't enforce placement in dynamic memory.

Right.

> Also for struct kasan_free_meta, struct track alignof(unsigned long) already dictated
> by C standard, so adding this __aligned() have zero effect.

Right.

> And there is no reason to increase alignment requirement for kasan_alloc_meta struct.

Right.

> > For orig_size, use ALIGN(sizeof(unsigned int), sizeof(unsigned long)) to
> > make clear that its size remains unsigned int but it must be aligned to
> > a word boundary. On 64-bit architectures, this reserves 8 bytes for
> > orig_size, which is acceptable since kmalloc's original request size
> > tracking is intended for debugging rather than production use.
>
> I would suggest to use 'unsigned long' for orig_size. It changes nothing for 32-bit,
> and it shouldn't increase memory usage for 64-bit since we currently wasting it anyway
> to align next object to ARCH_KMALLOC_MINALIGN.

Sounds fair! Patch soon. Thanks.

-- 
Cheers,
Harry / Hyeonggon


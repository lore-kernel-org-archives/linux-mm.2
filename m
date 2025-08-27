Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA978CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034D16B0025; Wed, 27 Aug 2025 14:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C076B0026; Wed, 27 Aug 2025 14:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D536B0027; Wed, 27 Aug 2025 14:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D42FA6B0025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:43:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A4B8C07CE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:43:32 +0000 (UTC)
X-FDA: 83823410664.16.747FBF3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id E8EE080009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:43:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OSdbOR8q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VOJyvzax;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756320209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zOkgNgakgA1LRuZYpvO+BlHSo31DbDw9PBfJhgIGv0=;
	b=0VY48YrvdNfOUV6MXHblJmxiKZZNdOCpxEEVTIRMFjQGDDenIrcur/00ypt2olm1sOWJCJ
	I9jUdwq8Du+ce4CiOJYcIjxbgmaPVue0oM/6Ig75/5lzhPjvRIkR1aOh+tU6xM6DmYbiCG
	xXCJENXoBzXbCfnoC1OuBzwxtOugVuA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OSdbOR8q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VOJyvzax;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756320209; a=rsa-sha256;
	cv=pass;
	b=3ygHRXeZn9nQ/ZwiyOOVMuYil2NYr77mLDfWNLc43YilKTM2vlOPfDeg+yvGhnrCxtyGmt
	aqzefCWSBNY93hXPWBNEXVI2gYlO8RCsSD+TPb/93ShYgYtYDcydGePHP5u3Aec2l9DwRu
	mTL/te3B5beMruHdC7UvkXxJVr1fUu8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RHY6m7010234;
	Wed, 27 Aug 2025 18:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9zOkgNgakgA1LRuZYp
	vO+BlHSo31DbDw9PBfJhgIGv0=; b=OSdbOR8qgJPqT82PuqniwEBqCh2OSzUjc6
	Ln90laHp3OW9h3iDkjDRlImBBGDdYDah3CIqG654A9EJQ9/WUun2n0i2t9SiObmq
	U9Rp7FdMx6Cq8zVn0cGddn8m2ay8I62Z6z5UvXXKAHIHMKop2rjIMfN4jW33iaP+
	ib8T49hbK7LXGRJHne7KcqQSg7enrIeG7FR8Ttz7lyhZXFZD6umYBwI5t6n2ur0L
	XVhEY0pKENMPlnGVlLLzDYyoR7V/z3GcWklM29giSeb/xnz5TXRYcXcfYKikE81i
	AmbGM4R/Pdhk+5Gs7DVW5F7zx0ubiq8c892BQy1uM0ova36HrpDg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twduns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 18:43:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RIVBmY019707;
	Wed, 27 Aug 2025 18:43:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b2k9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 18:43:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIxN0r9LyxlIWqqG/jq9ejQ9+KegXy+jKRUMW7yp/u4U4siQTOE/rylHch0N1VOQXQVFlnG4IGCaMPfkHWSSgvFifJ4KA/fnFpOxzTpo4NgB1NsZMIQ5mAAS2P9QuVSpg8XI4xYKiCUpTo1PMoPzI2L63Vq081nD8l5Prtfz/tG/0EP7MivbdCHCDQ5B0FRtZxmTk1n0rdqUUDNuDzGKX/ZtDeV/1tFHdwUgnStaBekFxALkKuyG0WmUGC2TtXIcuXhaQzXlqYxz8cd4u6V26pOKDQTOhcKWIj1tKhWxoFRLErNmHz2F1L+T8h1vs9W2pPFJGv+aDwrVizxHb+Y7AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zOkgNgakgA1LRuZYpvO+BlHSo31DbDw9PBfJhgIGv0=;
 b=EGjoKfVP+jA4aA0f6tMG44CJCBu46N2p/MfPxQSOPIC8KT9gZgcajY0fQg1l+fL6CwOLvWa595w9QiI8FzEDVHWTeZBy//HHZmHJuCq4uwfmQpWtnGvngdA8FRdsSPPy/bYDcUls1ohTUEYqaeF0IXqw2DugmTEuyrRFqGyZhZuxisy7CqWaYtkeelvu6RYmAldgVUaT3WDQMM4Yjp/8P3t/zOM928991MjlBbaRU5TulYt9If9C1FWb8vnLhOeOBBdK0jvlWRH25KfKBC40cTOjslTYwUXy4m7Y0skJ9LgluKF7zi3GNUtOCTs5R3Aqlkb6mUBGUf1LPjIfay7/vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zOkgNgakgA1LRuZYpvO+BlHSo31DbDw9PBfJhgIGv0=;
 b=VOJyvzaxhrkjLegOurVJe3ir8lb7KGQzrTvKBFpzkVaQBaZcOFNJxUk0F48AxS29Ble4NK83H9HTu4v+13XoUt834nASZbyiqzidom33Rn5SxzTrZ7hEDOp2xv+f4UhLDXfQ3Xybky56LedxjQoTWPPpB5PF1ccsLfDnWEn9PfQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4413.namprd10.prod.outlook.com (2603:10b6:a03:2d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 18:43:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 18:43:19 +0000
Date: Wed, 27 Aug 2025 14:43:15 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in
 shared.mk
Message-ID: <zfp32vgyidkytvbksyan2fwdoenvvbte3gbe2ndcuhanfwt3e3@rszlbrta4yw6>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Brendan Jackman <jackmanb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
 <j2vfxy4sr6wmuovlynvljvmy6as7esevp57hyqkhofxnxnjldf@ul6befrh7eqy>
 <DCDAY7MCS3CS.2QJ54F8Z86WN6@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCDAY7MCS3CS.2QJ54F8Z86WN6@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0246.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4413:EE_
X-MS-Office365-Filtering-Correlation-Id: af233941-9d0c-491b-ac00-08dde599975a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FdB8mdPqtzEE/6MA8iVZzsoxTTAx1GeHxpt+EA6BOwCfT3scFKJKcJIacDkb?=
 =?us-ascii?Q?xKc9FYMb+pUl0bq6SAmWj2IroYj/xkIhyH4iOSHsVLKP2aODaSo81OB+0mfo?=
 =?us-ascii?Q?DmkMG//OLR3mUeGA7rCeFhRFw//nMj90+4HeamH4NRriZCpJM3BVir8LCICn?=
 =?us-ascii?Q?PvBFhOAFGLP1i2EvoTRKGX9O2TZ8tACyPXmeHAKQN6Q7lRzEDFUjzEQl9BBR?=
 =?us-ascii?Q?tXcNBicJD8FOwUGeDzexg+vvDzPNGhBU4hzPAgDPMTUCnyHU+96JwuWSt4cZ?=
 =?us-ascii?Q?/MNqTo1Pyk7kXkTk9vyqDDcjpRIywnjG7TLf/ix7Pis1+l1v6ydNV6e5empA?=
 =?us-ascii?Q?2LWw1hQi08fRnMYLynWAu1TEHpR3eZyDsoQCVfesJfiizQ5qDGreFUfTouXG?=
 =?us-ascii?Q?nH+IuHX+usJH6LzIZS0qMrbCuudxVGYweundw0IfzhIguc1fFlWPL/HNJkgU?=
 =?us-ascii?Q?GNpwNU68I6cxCVJb3adfDlwHMXPmMroLB+pqShzUga43f67D4Drc3NGthvhO?=
 =?us-ascii?Q?noAPntQttWRkO3NZFyhJEKN+gCv/4XPA1o8675RWLQYMSuJeB22VviVS2GJ6?=
 =?us-ascii?Q?AdytSeCnTSBtt/k7ZKTN8iY3i6yxh5YSbJ25EJ+uHR0+fnS0iu8ZiFvoVzfT?=
 =?us-ascii?Q?mYPnPQc3iF9OV0Q7dEI3oCLklyb9VjYAX8XeN32E2fPc9toWAIayNPku9xOa?=
 =?us-ascii?Q?hhRFG5O/W+gXu/tkeP4LfZoDT4oxsr7ZfJ+Covnl6x9lqNRwayEChDemyQ7q?=
 =?us-ascii?Q?7hs/qvlBxc9qzazKxke+JvREeFzihHh/LaPuslpnBYPETNUPd2QjgYQZWfxp?=
 =?us-ascii?Q?63Y+Dx2rhoffw1WuOu9cJDWbuKn1PZ2P2AZ9edahXPBve4K2HwWDAKrsNGXA?=
 =?us-ascii?Q?MmxsX8TuwdwL62Eo2647Sf3OHm3IqSEHush6mMMV0A9km9l2BTCGWZRNiAbk?=
 =?us-ascii?Q?9AEEabnzXpZ9qMK1cjA2i5JnQyWYp+NUtaJ/lC6r2uIl2vHbDgjPPPd3sm1q?=
 =?us-ascii?Q?IS7C9+LvHCRkyoeMRMtLV8DolsOPw9h3cPEvV2FmMLPPujCPvQSdYyv9lT1n?=
 =?us-ascii?Q?8ddDqgG8JGokB+m9WWw0pXXsMBYSgq/pFXfH7FohwUieVV5IGTSYVUCw7U/B?=
 =?us-ascii?Q?dFTFt8bNRII1p7/XNPi5B+zKUJOzkGepVuMVEFqytF7nV2YWO2X4d5JVJUY3?=
 =?us-ascii?Q?rYSXfjOoppV91oveg9yJCO0HupojZL/UgVhnugXGEVysRyfaTGSYH5BkH7NU?=
 =?us-ascii?Q?RRj19oIocLsR09+tI3d1ek88Ym//4wYWpPwU2RUL6QM5S1MQekllMqiQBX6M?=
 =?us-ascii?Q?naw/5e+e5l2jpI7o2txzStLDI7qCsb3aH2mrBSQwnqewFT1tPJvaNePUcdfj?=
 =?us-ascii?Q?XcmCE5c8vaiCSOkIzyDSm9bfAQBfA3BiaybYt4i1RF8P2gT3B1cf3Oj0X+z7?=
 =?us-ascii?Q?RggUfWWnZvA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hHFldiSIz5xe58RO52TSRpo1eBjszxOhr4FPCcPuRUDUnCJ8OXL3vjXkAtW0?=
 =?us-ascii?Q?relyg083Fa2ql3x3Z9rhsR0CzG9ymTAA0T+MB/ATrCqg2JvxAkkL9Zp3NUTc?=
 =?us-ascii?Q?r0DyPfd97fYj+Fz0a0lFArY46MMEnR++89DzZREr/3cPdwn0QJ4fIFVdYByr?=
 =?us-ascii?Q?sJQOj+w/RgkXDZb+8OtVy6GXbApo+8jtiypEgPIXvO5wZTKOfEUWx+bJv/zB?=
 =?us-ascii?Q?t3+TDBIGOJyquO4xqyQPVZcnQtVgZtnK84SbQauKbQkBp1InwkX3h678mEij?=
 =?us-ascii?Q?viZA8UblAvE54lB2xFz75ILQjVFwtig0QgwFGNNNbfwg0ed5rb2tCuYIe8zp?=
 =?us-ascii?Q?3lEmNzZ6Qr0hTjPZPcJkMzVtPtF9Lx7btsxbFU24RuB6LtZq9xaMc2JPBUhk?=
 =?us-ascii?Q?tNBVEulrJ6tJzNiTD4hA4vE6aEakBgLYhOb61wIiRir5grGRquMz+qa9IHEY?=
 =?us-ascii?Q?LOuKhckwrMDJ5O0CUv+E+Iimb8w4EG/7rY27oCDBFDpDfyBFxQf8tlL8SGh1?=
 =?us-ascii?Q?bS1Ok5aAYM1Vr2bxpmSTTuQg6pxDCuoodeeWZBptnZ9cnIx31ZIv3HSQ05vY?=
 =?us-ascii?Q?iWXgWkshQBdFX9K95g366mJzbJgWZp/bE7YH4ya2DKE66ZovCCiZ/dU9Mb1U?=
 =?us-ascii?Q?rdnIGWn1IYKbfU/83N6/6cgNKsEZwv0GAh+IlBf91xSAR7D1denF7UtQQWEH?=
 =?us-ascii?Q?NREQrY41HS4oWfeqR1sgKb6/t5ANyLUdQuPDHfQnX4X0mq1QOw0zHNlt6W23?=
 =?us-ascii?Q?zBfPN8yZxydXbvkCcJBCEM7kXgfHwMJkSdkbkNXJSuVd1oa7wOtqPR/kZFjg?=
 =?us-ascii?Q?U0oTDSICCZqPidMYU/Z9SX7/7OlTJWBXlcQfyaJHnUXHXfmKHuVlrbbqnC+D?=
 =?us-ascii?Q?alReo5tblE9M6A2QgOVZQXi4g2yDWNnyo8/tEe5RLZ90+Cfe7VVixAHJ5B4X?=
 =?us-ascii?Q?nFEjYULHkPzR54CRTxPWZHBGpyFY70iJ1/YJP9Juz/ks3fRyvuySz9pe2/D/?=
 =?us-ascii?Q?69SSH8dOOX7qBWDKvzrsi/Lb32z/r07za74f37hMfVu12skpJacxUN1vdHCM?=
 =?us-ascii?Q?pXRTGQZtsR010vx8wOmL87g0Cyc1dHKrSJ6ziqbZQGOp4kmbk2vYHUGhafP3?=
 =?us-ascii?Q?3X90ILnUgEQGJCcnJMHjKgkza2xuR5HzP6irDUjDLbwrUt+NAkY4T4RLUBMr?=
 =?us-ascii?Q?oEgqty0lVIQ/8Z36NTwhwTaFOD3AHLh5w4XiEuAVNyIzMQ65msT0ziBfjbye?=
 =?us-ascii?Q?ISTOBGggEN64PrT2G9y82nVTNskLAK6Wfn0vnUXeeGEX0GGsNzwILVweDn0E?=
 =?us-ascii?Q?UnIo8GmlwaN1FCH+LeKf6yQdWSdFhLIiRVlp1osY/5HExC1fMUA67C0g8CcF?=
 =?us-ascii?Q?5LIwQQ9mTrEwfvi09vVkwLOsGRrt7onsX+cWi+sfslwwgXPj9f23Yq1SSRSX?=
 =?us-ascii?Q?r1sa47BkP42+5Wrqh8f/e+MKxxqdvWi17Qckl0h6fKJfqckZjShHGZnhvJHT?=
 =?us-ascii?Q?Sn+QRjFuPUkDRFgvDKtVIV5QxR2N1cbC+w2qlwZnS/FDKg/3wfZSOtN9ZP/3?=
 =?us-ascii?Q?7IEEjD7XhYj65iM+nAaie/6VYAzqrmYBXPPaaxjN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TI9FBP4eZ58KJuA0PAnjEwf/c3dx7UAukIdayF5HBNXQj33pEGXbtSxV+nllUeKfJMT0f0M4TttzkY0FprrutEq+/tLcCBkdjXr8Ph4GbqCM0Q9s/f+6UJl0Y9308pTDC5nUj7zRPk6GE65lqFJVLeXTrWSdKMepBe4zZTXG3vkfLcuy+ezGXiSWGaQ5twsfvmFfMb4gO/N+a3dIRYz+NDp1zFJqkQqBP7yGJE6I3gD/hrKzAyN9pYwvins7bGChDsgqWbKdK1kt08bfFaUqlyUmoddSwK5UJem1FrlGwdHmIbnoqjjwFzsjez5qx0WbGQx//r8M68sx+Rv67GbmNZSuVm68t5JjW/8ys/Nyq3hGRRIIeXjXTLs5ilncYg2GYsyJezVDQxzCzC25PiciuA6KtcyjGW9vQZwCBq98ZrRVlYdAveqF1hUPIgRTsUulV8WnJt7ALFvliidtQg/0hmb1RrHrMXQ/BpN/FdotHyNt8fqUQ1x6kAEL8eXv/5ebW35Ie8Bu51edQwWQCnyOye+wqRhBq3O/eOynzJLrXhy2vVF3LeXly83Ls1iOTsgaxktCjpPn+a5Jijx39aewUkGZgn4iXziKpjN4d/YYmz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af233941-9d0c-491b-ac00-08dde599975a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 18:43:19.0003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggR6Zj3dgK2AnTcXBG9VY5eOR/kCIOuosoPhbi1bMC0HpgowmRPWzN8Xeplab3TwjKpF9kAvevYv2//Oy0KK9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=762 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508270160
X-Proofpoint-ORIG-GUID: oLecg4PgQ7aJI75h_ECW1fvDAM4rwxET
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX8/ca6dECxx9E
 UNxvT9k/ZkG1tDcD3BZFrT0admz3+S+O53YVFD/zyvV6PZFWIZHRrL37D3z/gIa4c+grUOmlLfB
 ESNEOZtxlX9CvsXf/Vv2pb14P69nMdv/LNJcCnnZBLrARtfXI3kw57Kl7SkF+f4zmP00gu85iYa
 gbwjvtK2WWnn+LhVhf0os2/UC+z2U0R3kzVizLhIfLPZBzbL1eFtc8i6apf1L7jwQ63GksxVkB/
 BOaD4vON1cgqCjzfBR3UrlILIAnPOd1DuOD4hrD5ZT8a2p0yPjjFyVSpvuX/G+uiFSn/CTsaqFw
 g70Sir5l8JKq0G+AN/iCaoURVrXz/zLJXS0gjWpRisSemtGesSjkpAXRjWgXQh3SX1Os+90LeQJ
 ZGemT/6P
X-Proofpoint-GUID: oLecg4PgQ7aJI75h_ECW1fvDAM4rwxET
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68af51cd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=emU5qnhr00u0jwUU2iQA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8EE080009
X-Stat-Signature: xfrexwchnw97x3jsadrsqk8ap1r3xda6
X-Rspam-User: 
X-HE-Tag: 1756320208-9648
X-HE-Meta: U2FsdGVkX1/WPgPtZfFr9rX7anidbSXko9O+GPt1jo/NMtDYts6wLra9yTnHTMDux3KH7ysZ+qvEz6sawf4Gs3tDgUR3g4Q7Z9w0InY0Pq4kvcpB60c4oXWENQZ/Zd9RbMcjbnribixKvdfDB/zg/DQbbvDv9TMQ4oA6kPr/NZU05RyTIKN1AeS0g+M81kKuwhMWrmnKLilNJ4MGrUhxtI4dMut4tF8MJJzio7MiwBGsEtMMXPKcAMLSjiqoMWum9YVA+VZt2vybR5MQuvovV+9WXunfql7DuPRPcc4u1MaqQcy2RYkrgiKP8YPQcrRN9g84uQdiI4zXrDHhvBR73+B0KYGVeOQGqOm/eyq4fd9L5llkvB9G/rE4Xis8X+SQG9LYiAvqupshyCkOZxPKlagw9IW+BaaKI1sPH4X/8b64jlgJWK6pSxYioU8pvzqc9sPx0sNX/WWOa9ltFjDPHqyGLHT+9MjpRsQQCvoAsJhpYYwiDxEm2RZJUg4rnzG2WXuOy+CczIMNu5o4LKz7QxpaU1GyRGGLW5Y6tgib2BbD3GvcvYHv3DhmBAPnq7axSDhBETtllt5t/6E7Dhs7UcqrkfNq8rxO/klaTjvFeOHBXzJnrJJWh5A7X55JHdObHd8ifQBaWaA/kJWUSjUWkGpvpdFiV5Uh9FqwcCGp9fdz7EmusbU7uaDj1Y6Erp44OtUlQyVtvAVUoifllxf3V2+h7PC3zCt7r0dPLYLxsgoE2fU9m+szQjUqXMkv5LtBd7J37On00lWpN+rgS+MUWv0g2RV/EP6nLDYVOUS2qLo5SnofGC9hSc9YKxVKJO5Ipvwow3riYORBienGuZWAWfQWAdcLdPz5ot+FIYT5WGAgaCDTiLhSoRZ2S+Rlo9VJ879ZR+xI5mXRrImiO8xzkvv3HG7EiWgZjgKqbp6FbcZLyJ5v7zpwKkjgHs3Kjb/dUgHj6DTEEDTWAR4rA7T
 PKo5+2He
 LCNwoKolkNG4YzY+5wRDpnPcVwulwUXYcgm+9+FnsLVkUQ07Krn/hxN+9V2T/kBMfb3ec4HZusxICl9Qk5M5sKshp/bsZMMx1MUHbfeCOkGjlkkJ2t4JQzj3/NaexHZVRnyQmlfkVvMIOXF4UEeEJuCyPnEhFGYETb4ViM1C6w3yp/g1xhcI87i/UK4Bxj44nkVl5yAFiFqS7Tma6zUsn/w3IokICqA6YTy7/Wcnk5rizuMYfdm5vrS8pn5BfjkE8qbpITDkjXku3fzeXb4k3bHJCrQ24ckg3otY1PSoOJF75l0BGKYmfCOnC9ikA+Do07TgorZLBVme38wXmqs7kJdAkrPhAuMitmUuuJToFc0jfpMOSPuu21lut2QvcO0Cl/otmue82xf86KdqJiNxiQrTWQJOswjkLqXyMQnwMJm++rvOqW9lAvUeK88yBh5UcbnDXFG3jQqofXUTlVgb7CmCvyOzQk6x5bfwnpfcLrsy6R6bpKPAjiPQjsBOQQiwIJpfSK/piTdXxPxygEN2+O7Vw3zWQbZOYMo8dgeioLzja/LCYdUmoCywkcapRPvcrc61WmiOeFGsOzXcQ8ZKostJCBiN9m4lUCciUEEO/FT4yhpGGncRtQIp9F+IoLBfmEHbnySekfs+t7vVzCSVc9TVlYl6IVsJ7e2qepRuAMNZInrXb9wePVrPrJNY/X5sEGNuVFcIPVvDHZaU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Brendan Jackman <jackmanb@google.com> [250827 11:07]:
> On Wed Aug 27, 2025 at 12:50 PM UTC, Pedro Falcato wrote:
> > On Wed, Aug 27, 2025 at 11:04:41AM +0000, Brendan Jackman wrote:
> >> There is an arch/ tree under tools. This contains some useful stuff, to
> >> make that available, import the necessary Make helper file and then add
> >> it to the -I flags.
> >> 
> >> There still aren't that many headers so also just smush all of them into
> >> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
> >>
> >
> > I was a little confused as to why this patchset was safe, and - yeah - i missed
> > the arch/ under tools/.
> >
> > There are asm-generic headers so hopefully those fully take care of !x86? 
> 
> [Confidently but wihout evidence] yep, without a doubt!
> 
> > Did you check?
> 
> Um, OK that's fair question. This doesn't support cross-compilation so
> you actually need a non-x86 environment.

btw, BUILD=32 works in the radix tree directory for 32bit testing.
Although there appears to be some warnings right now for it.

Thanks,
Liam


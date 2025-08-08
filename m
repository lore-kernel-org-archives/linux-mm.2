Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C3BC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FC18E0002; Fri,  8 Aug 2025 09:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977538E0001; Fri,  8 Aug 2025 09:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866278E0002; Fri,  8 Aug 2025 09:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7780D8E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:24:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED4B61A026B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:24:45 +0000 (UTC)
X-FDA: 83753660130.02.010712C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78443160012
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:24:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LxvH2wCD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dJgB60Y7;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754659482; a=rsa-sha256;
	cv=pass;
	b=pK4ilW11peKl5gSpuuHIo9FV4CC7ebYYYtmh7sMTfHo0vTGwcbi/aczIo68zFyPpeN7Zoh
	3V5j7gHsHYsiNjS87RoVFyO2kIiPqoQLYx6bXvJFjDGOOHOuI2QMLJnBlQovlxyfYBMniQ
	liB3D5AzN2+PP08rbFtpjHEyFZk+m1Q=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LxvH2wCD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dJgB60Y7;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754659482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKFj4d9qNF9HKwdQdtFw5LmUx9zXT5iDHN6/7ATYRqw=;
	b=h4A68DlLJNfPqMH0434xZmbgM8mHZGtZAk1e1AtpeBbZ8ro8hGnQoN3/h5i61UmZI+EDCB
	NpY5f2HXK2Q+PGrTc5Rw4QyWNwr5xjWWD4xana/ES+oNVCci1CIc/PnCfwCnAKkpNqCN5+
	NDYAxzQmvKKySyyx8BMEIJzQ/5RYHns=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNUOw000780;
	Fri, 8 Aug 2025 13:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hKFj4d9qNF9HKwdQdt
	Fw5LmUx9zXT5iDHN6/7ATYRqw=; b=LxvH2wCDDr8IhOoxWEP2en9XPhuC7+2vzY
	RfD0pU+nPnJ7jKvPMSIcFAgyRJMhUGIGAlF2Twxm4ujfy0kIv4jP5yv4FURlSDwl
	+6BXzBZ+IDwqby7QJkMNawK7G5NbIJiBGiY+ES1OinbE4d6TYckd/vzLERdOVtnL
	1uydNDosKBZCliZ+4xviEjrMHJF1Kwe/71ue84qQxMEXoGTQ+0SP0FoddKQdOuS3
	ficgVNVkqZ8L79LhExkra9b6DITuY2CtoR6y5fG2tF2Qhy6+xAkCdmiv77fR5OSw
	Q5n1qpS+5N+ngX4+1u7ptve99tDJ+lq6v3KvxgyT8ZtxM+VoblZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy6e0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:24:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578D8ovB027150;
	Fri, 8 Aug 2025 13:24:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqr1wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:24:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvIyhy5WrcVxG3bX4KcUUqcs5lINzYf0nilWvi6KxL/4d2pnRcZfKTmdmrqKqBmRtv6lVawvYCRSMwMoGMqquz+js0u5SX2Z9Dze9g8DPQxdiZnH1eKKmvTjrhVn1HS6FjRsaSUrtZ0cc+as9K6aZWmC9QWUXa7hphavQ6K3kM9FjPxeBY2wFybtek9lhsvwINSpVTPqB9iNn9UW5+fnqUlbwYHKlQxcxFQT4WF4X8W36q33B9QTnioU3dUVfskptvvKObE+tiippaf9ThCcDKyrXS8sFwp/tVdiwbR9+fojP4UHzC47vV9OA/3S5/JkSxdY/YPx7FVDvHzCxG8G9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKFj4d9qNF9HKwdQdtFw5LmUx9zXT5iDHN6/7ATYRqw=;
 b=IR9AU9ncJggjX/jiJjdwYG9jToyvdc4ju3KRKSua7OPXbEMFh8PZdev0bI7qWyOSwaBXFTrRtyzEwcxg8FiETd78D+6Vb4N1FeoD7VeXl526GqVNs2dartTC+OWwlxQ3I/emUfIP18RRcuFLXZC7iKREfN/1mvRQFskoHv5Aqdtwf23nnCGbJt+vbTSGVMh93YXEJiiO/s5Yhmgdbh0bT1A9YfClRXthcSfI3ru/YVKDVQNGHnzlabT9QSkFI4pvJk/xn0oCHOwiNI9B5p0M8U4U2/GJpaXv5sPAKB5vAAQhcUYW6ogpj+oH36WdHg5Y4ScJ3H/fiRA6uoas+DdgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKFj4d9qNF9HKwdQdtFw5LmUx9zXT5iDHN6/7ATYRqw=;
 b=dJgB60Y7ixfPjkfsSEmqqz3zhKK209+STohYioGrNgswpacO4aJgrkk0YSA1nXE/96GaA3wG4bA+BuEx5tA91lXm/L7y4S18oDlxASETgM41OqFtq7XGJBLf00C0CnqLE0g24VrmigamQu0e1YMGVxJqQ8ou8QrR6i+cDoP+r34=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5993.namprd10.prod.outlook.com (2603:10b6:208:3ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Fri, 8 Aug
 2025 13:24:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 13:24:23 +0000
Date: Fri, 8 Aug 2025 14:24:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baoquan He <bhe@redhat.com>
Cc: SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, ryabinin.a.a@gmail.com,
        glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <b5d313ef-de35-44d3-bcbc-853d94368c87@lucifer.local>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
 <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
 <aJX20/iccc/LL42B@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJX20/iccc/LL42B@MiWiFi-R3L-srv>
X-ClientProxiedBy: MM0P280CA0014.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 9145364d-52d1-4b17-e933-08ddd67ee414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W3gsCjInfKhLfQ4sMQqe2bbpFSL674L3JOH+qDfUz/iUu0cP9DjxOce79jLE?=
 =?us-ascii?Q?y4ifbwYaERlMgvn++wo3EhfxaMsKtMuRD+El+A1ooD+NhivpD/y5KuJnKkTI?=
 =?us-ascii?Q?bfK9M2ozVKj4y4h2dLfzHIC8lOYmYiQa2/FSDSx4UZuTr7M5RtGgRSWjO1VY?=
 =?us-ascii?Q?v9kkHcK3juNnXRlFBizTHSnzgVhil2GX+T+1EkIPu48H5yX5XwB1c9r9uVom?=
 =?us-ascii?Q?JvTfpwMHCJfkIvOFLHWtQa5aOL512TyhO5bnhMrFNXl/hVgbSeeaUU8KisTn?=
 =?us-ascii?Q?cNmYgpe0D9sKj6GfBMtyMTRQLJllhhvAa6iwxF1zgISgYljjupilj7B4hfG+?=
 =?us-ascii?Q?hLVEaACWVCn/m9b7pGNSyjr1G3RoFCwj5uWU2uv9FxAsnmFk4rQyRvWgwFcv?=
 =?us-ascii?Q?MTFBNrGuD8ytg3KSMrX3csNTqQVn1HZuCaEr8Uwl+/FSFrU17Z5gUpKi0V5L?=
 =?us-ascii?Q?DmmO6bAd8DGmjxE8spt5mU9S4o0h+FZq51HQVfT4Pu4Q7tJ1nC8hWhHbzW2y?=
 =?us-ascii?Q?jjuBoD+agEiy3OyvZRDQfsg/K0WJx6qvvFxxAYoVPqeyTO1Iz6qksnCkHRrW?=
 =?us-ascii?Q?Nd10zXth+rVoGc3oWXb/l15k5zZA0t8TPnTc/+UAOK8LdrfvRFSFrs9mq4hZ?=
 =?us-ascii?Q?LN75GsbIvB9KIfPQPoekmV3SKzYfA6GHGaPDu1MimsY37+kwU8P0Xo/JywjV?=
 =?us-ascii?Q?aOO1ZvSxtBXVyHUDHhr5bgC9ka41d7w/GEIH4T0UAvnnxHqXvMuKd8Jm213W?=
 =?us-ascii?Q?RYJUCusi/qe+j321rWpl4AqI+oa9MhLv1rnFIOsAKMDf/7+IoiWPaSnBTeG+?=
 =?us-ascii?Q?pvsXiX77XweaqrefFkVaHkP20ai/aImlQnpb2PKT3bCezkrrfkLESjN1JypJ?=
 =?us-ascii?Q?CyMAn38/uIcmvasoKf/8/gs1cXyqDl1rC3I/9IPaV8eLoBB/3vOdamC2wrLd?=
 =?us-ascii?Q?CCsgtW69GrjK64nZWZnrVtO5VT11BUsPN32eR8nR2CN/mcRSRRRFaV1DlstA?=
 =?us-ascii?Q?zRnC2p0MTVTSzsEo7C62lHshSlSdA959nDAdAI4Se8N3E7s9d38PYMXjIaLl?=
 =?us-ascii?Q?5Uhce2FY3JJ4aISXvXllVqE+WQVyGBKP4aE0Tb/2kBbDXR/3eO5EV+l0Gttz?=
 =?us-ascii?Q?XyOcDtl9gZEqieeuIlA33qTKmVG1QnYSuPde+o3aP03rVUwNPelSEKu3R5iT?=
 =?us-ascii?Q?x7d/5ZNY355wWhGZOVr1dz6PqNCzEJr0tiJX9FIWzk2k5z9YAxp0DxS6xAFZ?=
 =?us-ascii?Q?bATEavw/caJmtSlneejaIUVzGYDS2TDqrzHIN6nVTKDE9WBVhUWb6vJ+1C70?=
 =?us-ascii?Q?KBUGLhkbD1JlmxZbkMtPIIrRGMCz/SkW+CCp+t1u9jVGQIPUFclMe+UjErYn?=
 =?us-ascii?Q?6TLOlDC/y8XqSq6eHP4DFf9COUgWaMhiJPi15hDnCdYcuVOacR8kBDwHDKq+?=
 =?us-ascii?Q?BLGjZLzzNsk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2H/jcLEayW3zNyGgSchTU4gXPLb178ieJMejTSNpuo/MNN014GEV3c5oxgeU?=
 =?us-ascii?Q?YlUxsrWgsq0jg721yTNSEM9VCEleDVR2gkhnyrUu5ULtzDjmrCGapi14A9fy?=
 =?us-ascii?Q?8dSpEUVp/qCLtL9MGGfZrw9E31OMLeHO20pT31NK2XtuTV6uqCYLPxTCowgq?=
 =?us-ascii?Q?OxuEXOqRtC7EQzVHyxL5A+rJUIzvKoz+XxnumUMO5pjFjwcpvehuRBkZSXSm?=
 =?us-ascii?Q?Wf4cgiw+/hgME9LznbiQWKqMPIXbLv3RYGt9QonA+5df4oJIBgmIgFk6a8dI?=
 =?us-ascii?Q?W/w782zInGskm7EC2tCX3opA+e5SiowxViplenXqT6r03WrJ8EIpwoqwa0N+?=
 =?us-ascii?Q?n/qzaWmaDOGdJU0bNYdCPmF78VgE2qwMd6deYry8LfokShC6EyeVuE95qwSO?=
 =?us-ascii?Q?6wUlNrEjm8YajYXAD4QRP5yPZwep8oWLBbyxtm8Yij0NIn6V1/v8/A2APFLy?=
 =?us-ascii?Q?dwlKvY7iu891PladEH7ghp8x8lD567BFQquHdyVz6m27RIqR80P7k1J4Vy5D?=
 =?us-ascii?Q?paOU0V8O7usL4MvbWFAyOG3QTQZ6htApgLM77Ik2qIFNuZCTRQ9EqooNuBp3?=
 =?us-ascii?Q?IHmZmSi1EH5RLYzLy+qcVsUP/Fh8lhhDoj3RfZXgHzxeqw8VJyEe6rW++vNC?=
 =?us-ascii?Q?DUl1JXJgcebHU32Id7TxKLSNY2HScMUFPH5b1eloR4Eh97ktfhmjaJp7GO0t?=
 =?us-ascii?Q?W0cWFXGSm+CIP3qhYsWgsstRTC9Igv/+zrEErFQXZvO8j+ZPTYhcG8Vrnvj/?=
 =?us-ascii?Q?5CpYsWmbmavfJZDrOcl/nO4sdYyETzeesJP0V8SXJO15NwmvpOcLRVLcXLXg?=
 =?us-ascii?Q?zJWoVx6Z2KadAHncR2phVKKDpYauZwCuNlZJIJ7CHl1TSZOFOtIK8p76z0GL?=
 =?us-ascii?Q?Xv5Abnh9y0VW4fKXfXKUcxd2pV7aEIy/ztSPo9WS04yo0Pn4014AyG+w7jSw?=
 =?us-ascii?Q?Xm7AHbfarq8fp/RpI0h6DZB7Geh2JqnYAfIeAcsnNzTj/UldxLIyTFPGSejo?=
 =?us-ascii?Q?tGM4ufpx3CbatoGzGrHE3ubdDTszMpuitwN6F3MITAR3+AZwJkKdq6IMN7n8?=
 =?us-ascii?Q?OTE5FRtd4y0XDYBqzoMuBS0wvkA1dsa2u4qI4Ssc6XQXNyKOtMWaoziztvFh?=
 =?us-ascii?Q?D0TXrJUN4MV7RKN8CFdW11WP3AHFE8iqDa2kfJMw2ZqRmzeazJueoPOKb3uC?=
 =?us-ascii?Q?lxRZX+Vf1YpLQRp4C6L/+Jliak5Sj+wMbv+40VTKLT6XpGDYEWsTlwKPzpbj?=
 =?us-ascii?Q?5ER2GmBuewONW7mn2z9ffqva04jvIpUIcBD7huA3hzNLCA4bCpB3a8ePoosu?=
 =?us-ascii?Q?W0jbK+9CrsjFBkJ1iLFHUzyYlSnaB/pZ+JlaaUanhh0wZmHzaGrEs4a8auGd?=
 =?us-ascii?Q?abx0Wos7aE0oG7XKLpLlH99x4mE8oQInYKlKiN8DeesZ98uDm70Q0jQa4e+A?=
 =?us-ascii?Q?lKe+znRPUwuaaArG4yCb/2d5mxbf0UwzgsmrKSXJfKMan0XpOC4xKJL91IEq?=
 =?us-ascii?Q?uxVb4ksaoCWVixvByePf7j2CO6errflzMIiy1oiOrxn+gxpZbsFOMD+8QPbN?=
 =?us-ascii?Q?9Y1JFBqsOyofcNQENfb1vrVMytKvV2uTyPC8yzKyO1COjmx1O/B1Dy0gdLV8?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	53qC+hor1ZNPh9dS4SqpMfcMKQa00C4w2soZAzsp/Dy1ecTxv3YFx3mqp0FrvKfVzVi98aH/pMKXXlb+tBmyGfGA6o5q20iO2trLKcJHX4XQ064Jjy+rv4LH1PL+zxkqbHa5qKMe5RQ59qJo+UmddeTl+N7ASFPqnwO3XW+RKqGrrvlc8s3rF9YUaucky86a8yTyBVqfXYykStqiLFMP/38Z2HFaNenU+Yo/c8aoE1r7iVeK8JXUT9yUQSC8mtJKV5WQhVSXFou22sLaX4i4JCnlxsT97/g18xlndGETvaf6lFmojFtETYOZwLX9vNcLGmWczniVq6yONZt12kdhU8PvhtJC1Mnl7iYt0MZcpu8Y2tEFdDKKbzJXyeF1toirlX+e3uf9kP/Mc3Av9598ohcsJMnnEDuAUDytViuzHh/VUWnC32mEL5g8BciIsvUll+P9+pd6XJJRs4YbYvTzE8ZlOy+AtvF5q0iuCML3CdVBhbYXHjJaX3QO1zgmIegYqfHhzOMpFM0sfunsV6dE/LWrFS6kDPZdQ4k1Lc40rSRZe9CoU+kdysCjHGoRm3R+6wIybt16pMh5hQu4s97Z8jadyxc3SqFWSfiCH5cbeuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9145364d-52d1-4b17-e933-08ddd67ee414
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 13:24:23.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTkr8UcChvIYyMrgJsrenW7++I9UomR5yPgAp2eeFc6JG7kLokhuuDWsG46w+UfkeHHMTVdFFymmQocZx1az4yiauL/qJCuw8U9+4v7w2Qc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080109
X-Proofpoint-GUID: 5UY0Qza5ZX3vKrQ0-U-loajcgMBoEjNd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDEwOSBTYWx0ZWRfXzOWXshkYvAVl
 iBK/HvSQV7SECC5PiNUoFPdnLIjY78gmwvAHXE1H1l8duJ2/vwIpz2uXSdHu5DSUpVtGbFnpJg3
 ydfvgchBsqRu0lBrBymrpfyG0oKzuMve9a6szpDkjNxkdJKdW0e8lI5wm0chaU9pcdO0i5Ba+YE
 NpV1foqs+H+2zymFk9oQBPHFLcOl5869/P9S0Bdx5fsXY5d3CPQVc8DjJpOs2Y2VaR6Bcw4B/Q4
 yQGo2h63bw/yWujZJCHHF62vcWDg4+GpHyPfjStADY7U6wAz2JPcCvyRziwaPyK9oaKb5QfRxb8
 dz75GptLJgndJuIAW9bU0jYAF+2DyrCHmjIYQ38i4GG6FoufH55XxQolCzBc1SJysfPyxnrsclE
 2xYWqq5F5GVdb9jW2rXUAKTVG1wlEI5fhU36265uQsDLeXpYzARUlNLhvi8C4AEkbu8eUXzz
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6895fa91 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=3NcBxTQYnx3wGZEPvakA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 5UY0Qza5ZX3vKrQ0-U-loajcgMBoEjNd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78443160012
X-Stat-Signature: kkmbaa75kkquh7t8ymh9fhgqkp1iotfk
X-HE-Tag: 1754659482-431493
X-HE-Meta: U2FsdGVkX18SLdaBiyRGY5TOcz/2undOv79vtcKcEItxz3e+KGIMKAiak5CAMaXI0keDpt0TzrN/AUu1No5Cy2QMMtUft5dHFkD6Im2JcRLnNHY7CK677p3s2YkZrDrDkuPkNS2HtxwYAgGWLVcmzb5VBgjuVhg96YxsQt0S8xFHAGDBo/Am1z9BRnwLPY+tEwlu/B8EEkWcNoadd+puDpE0mmgGdqFlBMtPYvqhIed2QVPEGDaeqUAvi8Q2Qe1jCrbXUoA72ue2R1CX1mOi5uUhGNvqY+5tJsPBUVQF6YBM4bi++squVvHJpD9NCZS6QedqdWR/46EtnBtrCpgU2TfzN+dJp5GmO7XmM/Y7ZFhOrukFaSkp+AjXPOmFTLI1sRkOc74hZvfIx9Ft9T6+O1Jos5Tja6zRJqeNiO/L90hGl3O8dp+BycZrSegr7Vck6T0zgH8bjGwNJ83O6Hu9xpsNesa3/YF6gAJmAisGfYKlYbZEg0dGAkFwrmYLcXPkfFtqJHsUkYhKo5r6Kw1/XPZW4OB1mHb/Me2NrC1sgdQiDfKXCCPt7IvgdXepbrqxm7k0RGdICpAmjBC6iNKfSdm0T29YKOCVks3QagNERmIpPsiVnXVWIUorpel49ltqZgCQoPduOIx0Rf3telCwztwdlmrdpGNpqn/VPRe8uQUTCq327ntUzXKFfSfD6qWtn7hFvJKU68ooMpCvHR8+GWwb2u2djNbVqvJ84RaZnXOTlg35bKsKlw0V0j9mFiSTPKh4JqeFDpw9Vp+YwH+uaG1EGXTajFcRsyJYFzTrQAzp1lY1j2C39F4ZXpWDkrOTPefgNUWPt2M5OjAEqy00aYTSE168IU40A+leNsSpgPEHJcEulEHMh0bbmzDsGzgN6GPelS7BWNJRSM904ixwFAyNXf/X8TWp39GP2iOqA3HkRBlWyNGQP9DKk46BNyPDtc6uIrpfqGBlxu33Iql
 RvlzXdx/
 FijZotnCs9A52ASPnGIJXdt1fgubM5QsT8dg3eKMTrM+pFq7cY/sEMWE3/wrC1Q47LSdWlsZf+39XJsclyEq8hD+mwL0lA0wbGR0cmSyQUqYwU6HMEIcOfE8tYC1zh8RBe//eCHwhaxnCCU8ti4qeZQv024EaWb/qcb32h0qd8TwkU05/viOfzKj52mfXliH/MeFdDcDIxkQVJWAtUJ9U5O8x37ZYKIqB/BGg8WjbIFOReU5/tbhpzGgiEbofVkE4Qk/XFREEwpeU3QbXKsezsiAxd6Uuc9G7vFDgBN2PMFCzl00ISB7hl7QISWeHfI0bzacde0mDIvLotbFNwm2mDOo2Xiu4VKTfLPkgdgMH5Jlqn8OCfoAmtzVTj+QGMza1ExIOv18s4XTZeZ70ujAtxtDqb8T9elx62Re57pFWyM7FpFJL727rbzYZvHltzjAAw8yIbFb5McAWqBzvro75H/FR1NftT+SHlY0kX1IvK550NDOjKH/HPXVgU17gYyTyMS77TYUQfsxN68bFGBnFXDcpygCoIbxcUhyMCn/mHObbuVtNOVAhSXDB0c9BtKc9c6APMcxICEqy8xkHN75WsC/vL9s15HDbaeHwXycDJq+o+auO4/X1FFE1I/QyVpNGzcwTwnEmhjqKEjitkTv3lEvQTS4Q0gVUKdzANjzNSc7VtdsZzRLen4iMACBQEHWAw1Aa+6MLOBaIlJUjWj/Ol9yWrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 09:08:35PM +0800, Baoquan He wrote:
> On 08/06/25 at 05:26pm, Lorenzo Stoakes wrote:
> > > I found mm-new build fails when CONFIG_KASAN is unset as below, and 'git
> > > bisect' points this patch.
> >
> > Yup just hit this + bisected here.
>
> Sorry for the trouble and thanks for reporting.

No worries!

>
> >
> > >
> > >       LD      .tmp_vmlinux1
> > >     ld: lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'
> > >
> > > Since kasna_flag_enabled is defined in mm/kasan/common.c, I confirmed diff like
> > > below fixes this.  I think it may not be a correct fix though, since I didn't
> > > read this patchset thoroughly.
> > >
> > > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > > index b5857e15ef14..a53d112b1020 100644
> > > --- a/include/linux/kasan-enabled.h
> > > +++ b/include/linux/kasan-enabled.h
> > > @@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
> > >
> > >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> > >
> > > +#ifdef CONFIG_KASAN
> > > +
> >
> > Shouldn't we put this above the static key declaration?
> >
> > Feels like the whole header should be included really.
>
> You are right, kasan_flag_enabled should be included in CONFIG_KASAN
> ifdeffery scope.

Firstly I _LOVE_ the term 'ifdeffery scope'. Fantastic :)

>
> Since CONFIG_KASAN_HW_TAGS depends on CONFIG_KASAN, we may not need
> include below CONFIG_KASAN_HW_TAGS ifdeffery into CONFIG_KASAN ifdeffery
> scope. Not sure if this is incorrect.

Well I don't think CONFIG_KASAN_HW_TAGS is necessarily implied right? So these
should remain I think, just nested in CONFIG_KASAN, should be fine.

>
> Thanks a lot for checking this.

No problem! Just ran in to it while doing other stuff in mm-new :)

Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92592CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1998E0135; Tue, 14 Oct 2025 10:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9258E010A; Tue, 14 Oct 2025 10:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81328E0135; Tue, 14 Oct 2025 10:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1E328E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:39:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72D9747335
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:39:36 +0000 (UTC)
X-FDA: 83996978352.26.7FA20BD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 409AF4000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:39:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dz5jYynz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EU7tesTf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760452773; a=rsa-sha256;
	cv=pass;
	b=i5n2mfVJS9s0KiMaoiAN7k85lFG1kNcJhJPyGo4/7WPaqjQ2uoltLfy/lf7kXMbs/ZQYTa
	jZbXCQwxruT862SE+1frwzsahFjqNGRV00uZtNCVSXxrsqN4aIhVBcTA6BYIOW4yc8mbCC
	LU/AbE4BMksXGett/1yPBpG1z0cd5Ps=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dz5jYynz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EU7tesTf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyUyE1pfmxxYea08Z7HLDBS4bYN0NnVXtHaRDY8W6Hw=;
	b=XW2xinVR0LE+hEBrDsKokZbV2dRVpKpFjbBVQbF0t035++/W0r5cjMkeiDQw/wfq4BkiwL
	uZ+rxaF8vzoKNwgVQyWTTtCiDCAydDGWg3kF79EPzLGLdULEmnnrCyNmy1D7Z3hhtAHCzZ
	eW/YKK6XXdLpSt1H82UQdDrZ3quxArA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECu67g002040;
	Tue, 14 Oct 2025 14:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qyUyE1pfmxxYea08Z7
	HLDBS4bYN0NnVXtHaRDY8W6Hw=; b=dz5jYynzVnPNiETDd5UzP9KcTWdVSnMGyQ
	WLmshKg6EVtIwoYm7dZ67yIdtRWB4GpETXlo0EYEDUt58zvkwlpu6I+DQzyN5WB2
	aIDB/QvWX0IxMUALizDKNKhlBvCBk5HahGqKAsK06Ui8xu5zlPePBpxZSxGzubLF
	Y6bwv7uV2go7VniqEWleJFeBP2omlbmmxs7URMJYey5QSAcnzkMYkWugwxgh9LbB
	cFeZWNO5ly0I+qEWNPZUThK7WMdgPnj56xfnEzX1slLSVSKmMh6BKddMo+CI3NEW
	Zy8WMN4XmPtfMOydigkiAlxvxmMmf00OapOrnS87Y2A5CisoGIRw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qeusvfn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:39:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ED6wio026337;
	Tue, 14 Oct 2025 14:39:25 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp8s22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wR2t9TZ7QA168ibO8Yl9PxBz7IlZ3IgQmKCfyPuj/aW5Lx/kRjfRNoAqtkVYYII4w7iw2hvBuSHZwIf1ZisPskYiAlPqT0o4DqbKi/8mL5v3DLdmvDXTWCHTb4UR4YCwmaHoKzoiFjstHgOYVtFRx4AwfktfAyc1qeycf0NfcHqh73nDpt+Qxhq3OCcvIWOLgTQgX3uLipxjunka6JGu8Gva7LVK/6VLwWFZgHs2W4sHax/BznBjfmVBC8H7BaSUdDWv4P/i5gJ8tpWDJG+yjOadD5ch8YU3MQ9cqScK48t/kNPo3KNl83t+BNqoZ7mcPti7jpDKVederowxNGZqlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyUyE1pfmxxYea08Z7HLDBS4bYN0NnVXtHaRDY8W6Hw=;
 b=MUX0mxzVR3Kpq4Ktv42E+bfTSu6RT1E9cXH3msRiJDwfAHl54ZKxoywopXeKBzBJthRPVgSAL8VDmF99dv+yE3uUhl7qOf4qXVnMrDQyWw8EZgRD+9FkenvmyM8cctCa6r5f4wDVDx+hEqukbtG1p9yThFphxEgXJ1SnU64+AN13oijqOCtyfKRkotA+j/BbzeCEme9+E65tPhMqhPUgAmsZxCKLk0MAnJLL6RDPPHzyBm6PfLq2mZzgp47iAgrAYIem8BSs6EXZyaCdIs4Cq5zHVOxSWdi5ReM4FVT/B2r7VmsH3NIjfwKBzVpnkXDYFymeQjippJ8IYLbgMOZHIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyUyE1pfmxxYea08Z7HLDBS4bYN0NnVXtHaRDY8W6Hw=;
 b=EU7tesTfaYmZuDqmOcsVwdnf6nCvEiaWoTbalPjItIa5YBUNWOtU88HQRBEXvvHJiKXsxj3sYfllpREDp2KdqPP/ZdClqnvIFaEwW/eqp3T6SWNSBBag1YKcEN9oBGlP4lMUPUE5mOVceQI5COtp0MedZcQ3CmBOWIrsKa0x0eI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4326.namprd10.prod.outlook.com (2603:10b6:610:78::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 14:39:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 14:39:23 +0000
Date: Tue, 14 Oct 2025 15:39:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
        hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
        npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
X-ClientProxiedBy: LO2P123CA0069.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd6a59e-2357-42d4-2bb3-08de0b2f7789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?09GhLYNP4B1wSK4BIDVlQ64M8e6XlQ4hqpJMlcr36CEvSlhWM7yyD20VX2+n?=
 =?us-ascii?Q?1xavVml/ESgINieRt436LoMHNS4aiLHZKm7vOYQ+Ls1YqeZ0KgN+U2RAOBFq?=
 =?us-ascii?Q?iN/b7fITSRMeq1nbYfY37Rcr/7EKZqMB/FtWOPt2x7D/pPr9R7fMxD6kUwgI?=
 =?us-ascii?Q?pH7Fz7SXQ978JXe8xJlT4qd5Wb6f7aIb7hg/e+rkGzqlCWYP1DXPAdzueSCP?=
 =?us-ascii?Q?EruB3NZZRw98AejZZCFu43X+oioVBLIdKcZ51Cf35f4CLNWj+TCtNO8S7mLd?=
 =?us-ascii?Q?iDfABrc5w8uOAE8R18tHLylx05s3gkfNjeRww8ZZVHGIhb7eqHFO/c+BwGbt?=
 =?us-ascii?Q?Yl/7uxfsB4i+I5ZaRmJ/EJUleXxCM4HIUIoPRKACNubYzxX/wEIWtfwD7se0?=
 =?us-ascii?Q?GbbaJmNs3pFLGWv1aHulSz3p38TL3vyzlGxrAo6TXiti5A3JGNBcq21fDxB/?=
 =?us-ascii?Q?Oroa5tohQ6L9DuO9fVQJ0jJrIAs/nqfCmZaigREYAs0BlkpfpTDN1rO0BM1H?=
 =?us-ascii?Q?jdWJde+otf6zBTWRMchBOtrPGU01UrHu3of+m1ckQ/M8lAM+505vTJnjnfVz?=
 =?us-ascii?Q?7FXb0QqtMk8yGDf97ZJPGiz+rFyjlLfp1L38LLUuwaCsJhRWxPFa4HnPT/37?=
 =?us-ascii?Q?BmAcwP/I61pGas/CGNE6JrXTQN8rhIocbnI6do6BmthVXAUPQ7VA7XDRXvVD?=
 =?us-ascii?Q?PqnYg/DzYoYPnrPgO5/Cc/atTFVTg5Kl4rxJLXgQA+lSidu9OwPPURXJgLEw?=
 =?us-ascii?Q?QBcOVAAuNicVXY1h5dFyn6ZzQtW91ifxDu1aFjPnZIvkXQEeY4aHa2UpATO+?=
 =?us-ascii?Q?lW5804Hpkd0AJiQDCU6A4cHZafK9A9rSSsYDD2poTcr98r7RY6HYDixuRxql?=
 =?us-ascii?Q?iuP7hQ5OfStIWAlEyc1BQxa6iIy5mN8QdENMHUctcA0FlBqT7J6HGvFaql2n?=
 =?us-ascii?Q?EBCAZmDNoHgYIaiYqBDbCGwO9C7TvplBTcKdn5fvMNQuEF6adSNehcGg6GtB?=
 =?us-ascii?Q?MRQhCu4BtiWbJQcpuoG8ZTMqBrcub6vUVKFS4ReN38en7NppzgDftdzypBX4?=
 =?us-ascii?Q?vKAQgf/PSGyZuiRz3jA/z3hsDJCnSdgON3KssnItzSmYTvurv3tTayPlEe2N?=
 =?us-ascii?Q?3zI1TDDQadOehbpbMpHPUI2UVYrVL/+f9S+NNB8TBNzNF8cQL+TKXndg67tK?=
 =?us-ascii?Q?ZzE91oL0xSM5GCIHMD3UASDxq885vp/O+8kcMnYhpqHsT1T9ng0d2gcbSZzd?=
 =?us-ascii?Q?Wmi3RngKS7m2eCYsF2hywQAkcW4a+kAdEd2K2T9FPv0TBncl/Ckzx2NvyIbW?=
 =?us-ascii?Q?jB0xiss17w1KEgvWANM5pCkfqymilwH909vBGY9Ut9z0aIZkkXjEa/hdbOns?=
 =?us-ascii?Q?RUlPPNw9Cw9PMhZ5oG70KfmSslWvjSVFzCKOh38vtaQAysl5tSXTtxfi0EI2?=
 =?us-ascii?Q?Isc1J3ZGhtP0mphPAv56kYM7fieK0yM3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gsustzWFOMuCx/mnlzM36vc6xlbIobOYqvGR0QLI39SLVYdpV1M/4X7lGcXC?=
 =?us-ascii?Q?ODhGKO8Zjsls+8eV+2YDxuewYp5QEUlSbUZtNoDiRbZz5qbHSN36Ve47UVy1?=
 =?us-ascii?Q?CsQRKB2B/MTrBVvbX+veGgPlYC0HypBqq2/SEbKulPmT75AXWGtk9gNohJUL?=
 =?us-ascii?Q?j9KQn7B+4EajZVUM4rcl1ti7Xd6GlMn2d8Kj9iKh2uPRMvfvPldq7+h9509A?=
 =?us-ascii?Q?or4g4qyQUars7EqMfDBhJ1IjOhnkPONt1vTBSHT8D2FNix382si6g9ENTCes?=
 =?us-ascii?Q?oag4FExVoQedZgg//dxp7heu0VVSHKP3CjR6wsD+JZiInNjZyyBODgXxdRZT?=
 =?us-ascii?Q?YlQtyLPWY1wPJCH9Lbgo2ot1NkH2YK0EZ+0iYAPoCwVqLSUUnVrz8ikXX0tI?=
 =?us-ascii?Q?S1NU81ZNeqWsiNvgn1EeuveTTbFYvYQxRAkKwQknDG1XvISFgKqKEliHBgxV?=
 =?us-ascii?Q?M/617NM0JcHpXGE85mQRxgs1m8UPf/rocqFo8/xK63u7Ra6bLP0ZQP+gLTBs?=
 =?us-ascii?Q?LTHy9JEb5ydt2Pz/tX/QrG68LJr4jJH+aeVB7HsdzVlhOwcZtlSkdEzDf9GB?=
 =?us-ascii?Q?Zyd4c2lXzFYXpDV9xmBAfvzbpApLOIJ71MjIKHGl+QaPoBWbcY9nRiFKJ+ZC?=
 =?us-ascii?Q?l2hu5fZvJbxlDLoJZ8WMskt9kNGt6lbRXk8kNMLW1BdTDFhHDmI7ibjn+zyZ?=
 =?us-ascii?Q?duosSOsGv5o2Tnwxrq1IuiHpUn2nae5QA7GizZTz+g6tuwXPflZkw37+0kcG?=
 =?us-ascii?Q?dEbOJWlpr8U4iYNbO/ZWWXouq8XnMP3DKjj7OvhDSZtTG0DxLVHKmoHbZPsW?=
 =?us-ascii?Q?gKH+OlcOEac4I2TtVvEu1XIze8hvkw31hje0fWnT/MI/gACB6L3Qxjemsfqc?=
 =?us-ascii?Q?n9z1Tr/wAYZnK+NX2xydqAbuKJfQuUAnp4tbpMzw48ZB5rZI+7RvaVHSN97T?=
 =?us-ascii?Q?un8X7WhNqa2+onUDIp1ObCzJbRdao+cy1g4QXvWt38fw44Ki0ORgm2azpXJ+?=
 =?us-ascii?Q?Qsr8sBwKLOIJg7z6oPTmh0vdK2aagjC+++TDbdacOofKYol8bNw0bw8xbkY7?=
 =?us-ascii?Q?cQ1E3LC7dKDlJeqdkd7qPr9lcZTwT/PLmmRRi/auIK3Glv9sfg87Ux2uniwA?=
 =?us-ascii?Q?dfB8V28gloe8cTT8J4oZgK5TJa9DUyX4LqWOx5ojFFb/PUYglWNkhKe9CmdD?=
 =?us-ascii?Q?q03wE4FT2HY+Ht2+XHd7Y87W6r/4BInEFsmdHO/0tvb9DV16IcdLetwOpOSs?=
 =?us-ascii?Q?42wV8pk37+gm0fHMhtfT3LWdV4tiLUoosMbl127SGf6VEm7HgsWnTrLy9k1E?=
 =?us-ascii?Q?la+3f+bWmpXms3nqqDk7vwmeZSWRK15UsShRSPC4Ai19zZkqtK50HzQdE+FC?=
 =?us-ascii?Q?xuRQcOAFk+fRqWnL41QwyofG7s/TKiqDcMVWOaXe4S884sH6nNbfHwBq4azR?=
 =?us-ascii?Q?O7Ein4MTy/MCt51lWy+znxvwTrEfjZwq2PkxkV+NsRu53HVVy9L1jJUYtiNH?=
 =?us-ascii?Q?nSe1U9kVIE1hxAnuqV7YRb2eUyd7hZSQB3kAkMewqYezdzrkBIMJweOGt2bv?=
 =?us-ascii?Q?2a3lkb3yoI1zq/dQA72EmWM6If37r/uREtTkrCtsqqGKqQuZ3RisOSQSMGQp?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qrpaOdNKMCLwldInP4JB9BT3DKJrZAA+xaUwymYIzrVAfvXm/+60NfrLSkZ2vuFJQTm12X/3zuYJxRA4ZiITLYK6MpOnWqnkfCe9MLVexJFY3oXb6uj5jCW/yYIULWCCVr7JAGjAYBoQK0i53NhS98fQ6RenPWlbp2V4Ec8cmlOISEqzT53mV+7GkAl7ZcH/hUg0OLfw5C1q01qqxBvHfZMoNTTOAUe3VL36DlS8yNOX8C1HNa4NZt0/YczIP8S0gTLC3fw83Bsm7mKxbUhFdBi7ck1A+M2vEHiFqzEMzK95Sm9rsNuC9grqwY+BUQE7i8nGwVjEGjSDxoOhtK4l/vw6j2OmmNxiCIR25ZgQKhMIFUklAHk7kezS+8LER8YWEJRc0Qn+/46L9tT4vaHlWatE8kiFdz1oFHaw4jt7KseF0zuz9+lCy3nBQC+sz7Uc+FnJ8SM+edRlV3peq8RgKzD2Jleua77GMUAPDsCK5ab5K7gSpZOtPQsHlFAaYqPn76Vq7iRFDYHBGrue6r1iFY7Zo5aM915AZNgFTQYyYuR51QGuaJrRQLIZEGk5PhWUI2uvb0pDrz33npUJr8gPNB3tBPLSfL1wuW5iyGDGQFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd6a59e-2357-42d4-2bb3-08de0b2f7789
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 14:39:23.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnewdNruKWZqFV1gAQGOU3IZKjqiNirjy0pu7X2cgsJFfpPfMCUyHwnVc2ZFdZ72KB7RHP72dh9IcJVXZahXM/pG1ZOsQKcNgZHhf6CNnmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4326
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140111
X-Proofpoint-ORIG-GUID: wLpkhinpzEHkfM7ZDYdIrkHCAZwycTqZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfX2r0+fDLAXvRb
 KJ/Qq2alljAIvkJsuEc6cmAcAMHWIO7A9k25JO7q/xBrvUbbDNC8//EOJGhsj/VdlcgIJL07p7J
 M+Gr+2Y4HRjplSWZq7h4yJGmdUiOUgsAxwq1AteE5NJ+sEnxk8WLWZD/zgNd42Bet5bebPd0bBw
 8A58B6eo/C7Ffcqrm5ad41DBtiJIkKCHFS2YB8QINwVOx0P96cAN1SUh7Wizza2Y1cUTSrSy8QY
 2zVyoGEMThSn8WBvjjjGdV+dNfYA2G930wbvtFmmXtuq0a4xpiOhZjwugM7/MBO2alFYc0MRjTd
 vp0TKwo+OgRuymLaCruZFlKQylw/PUOyZwJr7MDJ0YqJWoo1cm6NNTgFWjNu81jQn1g9yMW8Nwu
 Y3T5LO3uxfij0cEhSnttwueXyvSYUnfNWQtWFY9Qi4C7CNjKC0c=
X-Authority-Analysis: v=2.4 cv=E7TAZKdl c=1 sm=1 tr=0 ts=68ee609e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=-YAAULnR4JkCnbWCRFUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-GUID: wLpkhinpzEHkfM7ZDYdIrkHCAZwycTqZ
X-Stat-Signature: eajf61in4mgwa6ipjuap3y4ia8fw4eyf
X-Rspamd-Queue-Id: 409AF4000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760452773-164915
X-HE-Meta: U2FsdGVkX1+25QmMqF0U0Q6q3OvQN5mRz8cwl69xMrjnbEDvxn2Jmc9RdNBzXhbKPyuwTLuNyBPvu6ZjtuZRLURKDCmONHHK4ejE4XiyIB9SvNiax/T2baCMd3Qgs6frM7AIdEy3IybHxEfSDPi/R+BaiT/1mRO1whXCUtdw2Es4sChkD2kDv9F64MP1idGLn6g2kL8MYNHj1/ypVkDQ1dq/TUk8pSnUr8FQSJdEfCj84QD2Evdms+dQMaOYU407NPpIcPQm1+PV56mRlONstBI0UCJ/LZVcbE5FDWe37W6BMj2nkX3/JxqH0rwiDG1avjyBdBgZ2IErchxAhSoIi5YVRKAyOlO/t/M57tVE0wi3jir1CH16MmdQP6RAootjQAA9gOlSmGVjWekbn6F9jDLdKrjEXrjtQYVFK5aNhwEOGJdRr78UTLE5YEF1cVpIoYiy4matNK78tQLmeI6QxIzL5pbzk1+wy3F4H2u4kJ4HbzcgO+W8p5TsA023Vcc5lIDAo15AFX+fV34NdmTLjKkl1luGM0IGEJrnJHgbsLR490ih79fVf+9QSXB+mvG7JIOJ/HZDXWL9xhx9oQZ6PwZyVC6fLiQvI9uXB5v+/37DkyC38zPvrPJBGb0gztJJuB3p4C1gfWl7ljgIGsFoYX33KqdGQrXxLJ5mGCNBppbzvjcW/scySs0CcPurIiKheQmv9JvHdBZLHvhnV2nIUiPiAOoNhWgrggzbRTAv5zZeRVZ0CPeZJQc0qT0uT0l4nypi5YhaGA84oS/X1S1bDPAdVnjnolZI1eCoKERLVVeV8yLssMR68/jiBs1lhHxoo3xRcZ4OtpI/IhMbVTlbmLdSlbgfBhx1VWH52JeynS0TOMgRDjIMsfy5iykiPeXpGq/MFecuMHD+Xw3D0RhiHhNBA+kqUnkOlmvywVmyfex4LdsZzuWc78XSoMBLs1LJ9pNxB+nlTelUphkPErh
 1Tc53Rqb
 DW8TFQHB7BmnzVLNUW+VUrmDfXHiR6jJ41PMA/JaZPVcZTjJdsFGIgfjKA1ByAkYytU6hyPllTopdBU56rhp5wtkJXzLm/jpeXd2yOCQ4TcDctNDhVuApoGvERw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:26:20PM +0800, Lance Yang wrote:
>
>
> On 2025/10/14 19:08, Lorenzo Stoakes wrote:
> > On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index abe54f0043c7..bec3e268dc76 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
> > >   		if (!is_swap_pte(vmf.orig_pte))
> > >   			continue;
> > >
> > > +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
> > > +			result = SCAN_PTE_NON_PRESENT;
> > > +			goto out;
> > > +		}
> >
> > OK seems in line with what we were discussing before...
>
> Yep. That's the idea :)
>
> >
> > > +
> > >   		vmf.pte = pte;
> > >   		vmf.ptl = ptl;
> > >   		ret = do_swap_page(&vmf);
> > > @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > >   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > >   	     _pte++, addr += PAGE_SIZE) {
> > >   		pte_t pteval = ptep_get(_pte);
> > > -		if (is_swap_pte(pteval)) {
> > > +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> > > +			++none_or_zero;
> > > +			if (!userfaultfd_armed(vma) &&
> > > +			    (!cc->is_khugepaged ||
> > > +			     none_or_zero <= khugepaged_max_ptes_none)) {
> > > +				continue;
> > > +			} else {
> > > +				result = SCAN_EXCEED_NONE_PTE;
> > > +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > > +				goto out_unmap;
> > > +			}
> > > +		} else if (!pte_present(pteval)) {
> > > +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> >
>
> Thanks for pointing that out!

You've deleted what I've said here and also not indicated whether you'll do what
I asked :)

Please be clearer...

>
> > Hm but can't this be pte_protnone() at this stage (or something else)? And then
>
> Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.
>
> ```
> static inline int pte_protnone(pte_t pte)
> {
> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
> 		== _PAGE_PROTNONE;
> }
>
> static inline int pte_present(pte_t a)
> {
> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
> }
> ```
>
> On x86, pte_present() returns true for a protnone pte. And I'd assume
> other archs behave similarly ...

This was one example, we may make changes in the future that result in entries
that are non-present but also non-swap.

I don't see the point in eliminating this check based on an implicit, open-coded
assumption that this can never be the case, this is just asking for trouble.

>
> > we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
> > fact might not be?
> >
> > Couldn't we end up with false positives here?
>
> Emm, I think we're good here and the code is doing the right thing.

I mean sorry but just - NO - to doing swap operations based on open-coded checks
that you implicitly feel must imply a swap entry.

This makes the code a lot more confusing, it opens us up to accidentally
breaking things in future and has little to no benefit, I don't see why we're
doing it.

I don't think every little 'aha X must imply Y so just eliminate Z' idea need be
implemented, this feels like a sort of 'mathematical reduction of code ignoring
all other factors'.

>
> >
> > > +				result = SCAN_PTE_NON_PRESENT;
> > > +				goto out_unmap;
> > > +			}
> > > +
> > >   			++unmapped;
> > >   			if (!cc->is_khugepaged ||
> > >   			    unmapped <= khugepaged_max_ptes_swap) {
> > > @@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > >   				 * enabled swap entries.  Please see
> > >   				 * comment below for pte_uffd_wp().
> > >   				 */
> > > -				if (pte_swp_uffd_wp_any(pteval)) {
> > > +				if (pte_swp_uffd_wp(pteval)) {
> >
> > Again you're assuming it's a swap entry but you're not asserting this is a swap
> > entry in this branch?
>
> As we discussed above, the non_swap_entry() check has already kicked out
> anything that isn't a true swap entry, right?

This is a different function?

Actually I'm mistaken here I think - you check in the code above:

		if (is_swap_pte(pteval)) {
			...
		}

So this is fine, please ignore sorry :)

>
> >
> > Also an aside - I hate, hate, hate how this uffd wp stuff has infiltrated all
> > kinds of open-coded stuff. It's so gross (not your fault, just a general
> > comment...)
>
> Haha, tell me about it. No argument from me there ;)

:)

>
> Thanks,
> Lance

Cheers, Lorenzo


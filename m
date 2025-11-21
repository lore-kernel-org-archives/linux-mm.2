Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC879CFA47B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1714E6B0006; Fri, 21 Nov 2025 03:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148EB6B009D; Fri, 21 Nov 2025 03:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A46B009F; Fri, 21 Nov 2025 03:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2A566B009D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:03:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8860013B17C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:03:45 +0000 (UTC)
X-FDA: 84133875210.16.C577BFC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 22DB580003
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:03:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="M+7//DRr";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=trlP5DhS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763712222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9d+A0RArW9GDLgp3qiBMouhyi4hYGnXTcKYREbtTU+Y=;
	b=09TY7bLF2wCtKUUhXgqeadB7Ty/dp6+JqZHw3OZbwLd5pASiiJ6jbPatZJI/XkGpZA6I9f
	oPoTUT59Jrf7HcXWFmpqJzFLwDPiNtpllUzth6ApAMzXEulN/5SkvaCTijf2TgvqH1HE/4
	9Iwhv8V3/65q2qta9MWNVCM8M91TfPk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763712222; a=rsa-sha256;
	cv=pass;
	b=vTqmBirWNWQrg90KDGj4KZpARjkfbh3Lqc5cjrQjHheCIfqreG/MsooIZQt6xw1NBq2Xzc
	tf0xVsbXryDiRS8dJ0m0tWmgElfwkyCB0ygZfw8Ah+MGXzeH+FV+aJVgoqdj8OSyJr9+Nc
	e3/1qMQcP6uUk4ZtqqsNsjRGvA8iHYg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="M+7//DRr";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=trlP5DhS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1uraq031045;
	Fri, 21 Nov 2025 08:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9d+A0RArW9GDLgp3qi
	BMouhyi4hYGnXTcKYREbtTU+Y=; b=M+7//DRrFTONLRfFuTAuNQjhO65LUeQnox
	2YiE5omY0PlnJ/90WsSpgBen7ObmrpQSmXZJo9doPkAf3nvTkGbaZMIs45yBVb9X
	k/Bj0lzUy1PP/rmkRMccUmVMFZ/Ca+psLBB86reVJu5K2vCDFJXfmGdQfgVxzUO/
	79qbafriqzhsbrd85J82NkJk7qmL9cSY2mBftEM9P3hzNnEqvWmr/cpVWFYPGHxm
	a1aH++XFEwJWznEdYAhyQm0+20oxYcdLvsfdNZW9mUODrelpgrzWM0jVaoV0I5jR
	lxebjgUzwl0Q6sgLVCM4UDIkhePO+jSLwKUw5Gdg27KByVmv49sA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc2fsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 08:03:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL70GkZ002514;
	Fri, 21 Nov 2025 08:03:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyd8jxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 08:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SK3uwHpEKCmsZhBBV70EVd/VJ3K1tbS7GP2e3C++36wX1tG1T/k0pftynQx54ZzGbSYASFEoJu2kAimHZRjs7eTp1AWph0bkML5rWlP6DnuUQcBREFFon7BpMLA7c5rJdzIJscPToRPeDhAxQiR7hpIRWzsrLUs6eu77UKERLlsK0JpIEcsvnilBvFGgSLU+tFg4nbyx8S9Tx0pxFvYNGUG0xnrOV7Qi5ZKfz+tmOXLsf6ZhIvqWnvy5SH1ZZi7oI3QXarPyGji00le0Z1q01BZ6nNQ64IgZnZD1Un/pOUi2fAFZB5AVnMiSQW8QHEJ1znpaPV0AFYnVL48vubC/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9d+A0RArW9GDLgp3qiBMouhyi4hYGnXTcKYREbtTU+Y=;
 b=w0ePPbgY5u1YaFNWJ1QSANs4DSPLYFZeP4cLCIALFwlUFQsHbpBWtCyuYRY70ZgE1BNop/BPYW1BYKkGHSTKxBY05CQftEBm5e4UkaP0JW20ZNgLbTkz0IEKB1h2JE9mVBcHKFzqQYwkkkZj6eg7iLOuTR1I5+CsKf0wfKmsFoP1xT+al2vBUq6EQC2PQgdGhdDG9J8qYd7eKihnv18q0gnrBcOUyRcjjPlsjy52pNrWfqSAX81sL8yfoywic6CvbM7P0jU2dl+4hc41VeBZAmkm46IqmpzG/ZiTt7im7D76mrnuZBYiJRmeVMQdFT3uVt2pKId49KTHiJa7wfj5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9d+A0RArW9GDLgp3qiBMouhyi4hYGnXTcKYREbtTU+Y=;
 b=trlP5DhS4IGelh+UV/+xBcZS/5NFfdGNasYqqBMvIXFbi2G1QTn+swsflmNT6cD9UdQ+3FdfOdRQGwbClTFsI84hND2xyz1ovXNugg7jVxk6+VaEyzJ1dZ2gc+rsKxvR45TuiAx6uXoG7Kww3Cx7NdQq7Sh+j7LbF0xwhG+AwJ8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4577.namprd10.prod.outlook.com (2603:10b6:303:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 08:03:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 08:03:26 +0000
Date: Fri, 21 Nov 2025 08:03:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <9bc7573a-ab70-47c9-b6c2-4269479bedc6@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
 <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
 <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
X-ClientProxiedBy: LO2P265CA0169.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4577:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ea39c7-e170-4a4c-b04f-08de28d47367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KkNhHoAtYaZil1Vf+brLQOUyvf/+8cV2Hu0lZWlufrzc4dJ51UzL4bI8kxnE?=
 =?us-ascii?Q?XdtCMnxoiJqxXQF9gsKmsqxOstWX/0yLND4lbSq3up3kB3tDh2lhz6lpxrKz?=
 =?us-ascii?Q?j2y5fUsrDq0RDDKKVHpdGeymHM8iExltFyKJT9wQ2Lp/DXH7OJ5KAKaA5rhg?=
 =?us-ascii?Q?lqBuYRYXRn3Lt+yOVvYQVfAh8YuQ1T7XWpEFfSHRGYx5zoJGu9DCO5pblLJR?=
 =?us-ascii?Q?f/6pCQD502+ox9V4uTEidcO2glbNCBz4w1zxyRtJLseBYvhhV0eSGSaDyau2?=
 =?us-ascii?Q?rkQ1KyX7bviEtNMpGP3ns27B/GTXd9xQMx97+Yt+HHlcYBsClQumlyvmZcJ9?=
 =?us-ascii?Q?8UnuVvOT9nPacCKthJ3xtrzivhLmfF1Xg44k2Y4uZdK4xLMTfPQzR7o2f9Z9?=
 =?us-ascii?Q?apR5Mk8SgsyhBy6j/kd8xRidBH1JWS0j2kL87WMpWBdKesbcOdJ9twpx6XQV?=
 =?us-ascii?Q?EqkdT4FDVUu+QaR6jrKGTlqUJKxrzKLUq5rdXINzoSG5XmFMXrsZFec5/zMP?=
 =?us-ascii?Q?fore6aBBN11UDYa6Oy5Ws8492shaEG0xNMCB+ZPG4vtje06HSmxkL9jlLk0b?=
 =?us-ascii?Q?mYQs8l9bPncxhCjHLyJANYzLzB65khEr79oih0QEnkSyF84DVPLtvcJzdamP?=
 =?us-ascii?Q?axlukVwNjaiJXD4st8ejChnpQfubTJ9Zo/ZR+rHgs2kEmwMZVx9ohO+Sbb0a?=
 =?us-ascii?Q?c7xs0oBaqclW0r94UoDo6w9QSKi5S/xcJIVdcG4Gnqedlnr/3QgES7rMb4Rj?=
 =?us-ascii?Q?9/iM/jz37CKnqxYRQPDuGyXLhhrqxn+CdQnD4bfe0RF2i3Z7pSTNpZlwuwmC?=
 =?us-ascii?Q?eoSv19L4x3fmjKq/4epSUBy3UBlEPwoLuO1L2nwsf+9hbIJptY25whs1rgee?=
 =?us-ascii?Q?yHJxOgsFAcOpRpLezaEgRWkLtZUrgx0iAYBbjgRnkPgKQJGZC7sbbU9WIZl3?=
 =?us-ascii?Q?hdSzvl2sKJjr+D5dXUPEYce/e8ShlWOp4z/TLLkAnex03CjAnAweZTUcNyE6?=
 =?us-ascii?Q?t/jiqpA3MefWRLV26kzpk0IVMJTiNuOfArQdnSQsCxvEqvrIGcF1J8Hn9aek?=
 =?us-ascii?Q?JduEX/fDmgMoGLuQHUwmQRs3YxyZgwllXhntFyX0itO6XvnjF4S5geMkedNy?=
 =?us-ascii?Q?pCSN70XgeWHMJhaVhOxRVfGebVN5glbUfdIF2zcLXOMj4Orl4yWFrc6+I7W0?=
 =?us-ascii?Q?q1FEemoRGbLRK4wuAxOWFqqdfMJtGwYPpjPJ1TPqvTgOzPHYNeYLDy98AzJo?=
 =?us-ascii?Q?5hel00wkLdw133v1aA6fQ5YBVJ/wweK6BTRv+5pozpJ9+5WK0E7Jjyg3gCfI?=
 =?us-ascii?Q?WPLrb/FQ+XtCVgei4mEuIahJ2xW3P1PV7Ot6UpEc0pzcYUS0IYbl3QADTNAX?=
 =?us-ascii?Q?j25vsAQd0TzaWTrJimdtRsNi/ekPuHJxmhQlH2xzzaO2RzAZyoauuvtuyLL0?=
 =?us-ascii?Q?7xVqyi5WPKa2SYGtx4qlKvzjGYNar1xm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8V7Pk9VW8s4V5csmdheIX5Xgv2DMHOBFKHDYeyj87Mkslw5vyeg28Hp1dD8r?=
 =?us-ascii?Q?ogyW1DcuqFrfknZupKdFR2QIubgChaxpjk8bCPHjuAHgpRfGYD3kt2nkaPhA?=
 =?us-ascii?Q?K8d130VoDuTE35qjpLpJF8Gpsyc19DgkToWIOO9ABl8KCJsUVHZbQoaCAPGO?=
 =?us-ascii?Q?+tkjbzlNUd95pNrR/1FDKs0FeAFNzRcwAl5FPuR84S3hoecrr8EMcDxJsnoU?=
 =?us-ascii?Q?btQhHcQ9YzPX6+rJyM/hLlxYP1IuRjAjmMn9wd0tHdSpexisXIDLQ7CLb6z3?=
 =?us-ascii?Q?2j6SzGkLSPorslx6BFhajip/sGF4U7/0FnOaUSaqyjdNAOL7S1CHSJ91s9Yb?=
 =?us-ascii?Q?1+eAXyDgXeRN0v+Y/0jt5ZzjHwwUXRLSibUDkvDzAjX9HCAHGN1qc5Uo+qsR?=
 =?us-ascii?Q?XnI3cc6MHSU4D7cqkqzt756M6P5TvCpb7r4DrO2XAxMmrSdQDQotKVHYNmne?=
 =?us-ascii?Q?cC3tqX1drtaWJjpGWlhY+FwHk0B8uqmM+ZjVuFVilY/SrblyFeCICpHDtGqj?=
 =?us-ascii?Q?nuZOqT0/h4aetXz+A/hS3MsD+DIQyykJicKufSGHVvBaBbuLbqs4r4KaNhkz?=
 =?us-ascii?Q?UkPe84Y39/HG0AnUlbKLzR404YXOeKgj6YpOh0yq0JQp+xFAakflrUvAmk9W?=
 =?us-ascii?Q?Pk2ElayEbM8tReYV2X+ZPcS2CxlQ3vSkUPR1B1g2Wl+DKBlMEIaOXaa6/J8D?=
 =?us-ascii?Q?b+G/lG3juCMks23oCqPKFuRs0Hx8dzvPBq551ZHbLWkA7D60IQWI0yjc53HS?=
 =?us-ascii?Q?YmhDMTikjeAcjd7t/MtgsNmcbaNp9SkiJaYoXgKa77uXOw5BWP3O9aO6Vd0X?=
 =?us-ascii?Q?MiO4asa2bYzC20DyDe7c161DUjgTBAltkO6H4x3cgIKvPm8pshdjP6jfFTLi?=
 =?us-ascii?Q?inMsAL32RDxMXUPJ/3ed06Qe7FRl92I5utc901j1HRS5UTQhm5+6h4B1cVSB?=
 =?us-ascii?Q?ZqA5ZTUeEdRqzWgdCSfyClbMzibJfkHq4ZSdNO5TgqBEXQ4x3t1knK32+WD6?=
 =?us-ascii?Q?uG+cdXElxAdqmwSPh0F0gylLIYoYb8WwP3JFVE9AEO2yTvHmlMUQu2TAoelm?=
 =?us-ascii?Q?ZXQS+Mmev2LdtYeob1LJYJwoF0BiCHgWr1JQ3R3dx2enrK9Rho/Gial5CWF5?=
 =?us-ascii?Q?zXaT0oPshZieUCz6xiLe7Pih885UHBTooqdCSM+xmh5M0Oqh/LLpAqc6wNA+?=
 =?us-ascii?Q?K8UKCdDkXpx/OyfXoTngZ2+FaFXzNYw2Vwo2bTy8WjBVrtaqYjUZSNju8cKa?=
 =?us-ascii?Q?xZ75TlFnfe4AW+QcT3+ZuxCW5Dnw8IQor/ArvQth6DSc04Qed5u6PF3SrbL2?=
 =?us-ascii?Q?giRGep0nT0+Qcwwy5a3y9dtj1EOVyXsbUTWjuxykIpidkt+7Ct1tcR0g5qVA?=
 =?us-ascii?Q?eKN0eNXGkRDuqIyKZ98jVdE781Y5aRblMOm/Nkc3e2JLfOjZrHVzUD61gaKz?=
 =?us-ascii?Q?J+I1EWhutLezGDxF3kUvmvAbIMAPlEVSk/XVvPWO4ZQj4P6g1ea+mLT94NdE?=
 =?us-ascii?Q?WSPhidfcPrqC0ppy0RfGWQnf8h2wMDAbmSyOLhIYOVr/qsFy4MSrsPwlATEZ?=
 =?us-ascii?Q?RIq21Ku6hTKVI3W/ZG7cbUZ+ZXKZNJqSTJ5qr1OH/PubpHjfOtabc7vaz+is?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NJIANzoUiSyz6p2TD76Dw9XjFQG1T+ZPw2xHmNJdNeGvPV9nxRhDBsCn9NOve6AxFY9nt/HTYp2URE+VTVl+y74d9Y3hwjw8RGqQXGbBFwIQ1sRLaF1okGEIEQ2+OC1md2Bxq6rw+xSRU4TEzGgXuJ8s0KKLSX72iCeNvsghQDX3YPUIpUvGpuVwsptj2m3LQi/jSDzVSb3Fg2PdaakBBj0fZJto0hD7iLsI+tQJPdwUscqFDW+gbmrnCzZDvqZwE0GWISGHox/sfrYBc1ddEum6eSkbu+HvyxFjk9wKZdk8gUo2ZegPyFGF2/NHA2HwsZ6tdhTOsGBS9Ys99Ev4lm/zK/UXGnI/XI8i/q9nxt4GDaYHZjEL40LzbdIeLJXVodwtSbI4qz/CdhyssmwY+RWR6lu266Kr1V9wwwQKqBgKz4tSaeGhCLdI07q4pTP6C7PzQOsjCPxqN/GG5FmnxjbhQcZTAoH7pSvL2ebC6oYmsGZoOm3bZEPr7tTzD3w4gINVAw3a6mgWMLxqKVu8wSjfHPvqBXDrRePfImtOBRUtChjjOVY7NGXe+bbjR+7eXTkVKl4X63Ce9g4ujLaOuow6j3xPsOCpigUd1gLb4zI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ea39c7-e170-4a4c-b04f-08de28d47367
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:03:26.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SAGLknm+Hk+rnkXfjwr01y0XseBuq10Fs1BM+D/FrQhoJPCt8YCL8G3Hq3IzSoB4FtV2lAwcsEAoqncgg7u2zSzuXowcH5pV0cD2VEJwAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_02,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210061
X-Proofpoint-GUID: 7RErysWF4EqV9w0R4xGU2keAOpR3zkey
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=69201cd8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Cx5oDbLwwgQE0Y3nk0kA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 7RErysWF4EqV9w0R4xGU2keAOpR3zkey
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2sZNnq6R82cp
 SoKGslJ2Yp87i9f93Rm1QTgj3P27EFr3Gr8NgaXXp4FJkayWQL3LUV35Kfaf+2r6YoyLR0ghunm
 i83bxFKfDnFI7+u0eH7Mtst9xyJ0EoLj0GdFXVRxfrkS+F/pKSWo9LkqKuadp3PG4dILN6kqUnd
 9oK+F/iSr2g62DMU3GRkzwSsNin2UJ4Sj4KaONY1Jue478/R/cN5MiP/hP0FCQELG993H2WkGSV
 b4mrf/+7a87/a8iUYm9ZWQ1+wqCcL+//jHA/JmPnKDhdzOG3DyMG7CAFx7ILd7ObmvAI0Gt8zgv
 rACe98MMucuCkkjiStxvfHpyRPWHPa4mVt/m3Jpo+qFC/R6yR6TuttIWx85iZ7lJ2kGa0iQgLdc
 QPRXA7WnkfuRDA7vurnnjqSkYB9G8A==
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 22DB580003
X-Stat-Signature: b6ocwysdpg174fbeuzrug98k9axdee7u
X-Rspam-User: 
X-HE-Tag: 1763712221-838790
X-HE-Meta: U2FsdGVkX19slcdCbzbDYUHU6twgb1ruwd5EYpmchXz0hnk8vXefS1137lDasfeZ5ZwIZb67vlAzqMRZJ4maURpYAgLcZDaBPpnrTfwsVaqtZ+9VZGtt7s/75wWqtFTOwR7CMuraSG/Z3rPYkS0w7QpibpnLSQPJXsZof7Ra2trP5qBITx2/6r0a+gijQ4MW+/lgOr+hMaSRv1vtYWP8tMDOQqFKkBNlZhjNRXv5h/1uzgnTMOYV72lFaJD8LjaJ2kwLOxxcBR1Bm4cns+rS6J06T2oLhDdfEl5hx8zaymgl0LUtsckFywdk4/VcSLuGwqdTVbIVoH+B0UAk17Go7GpYVbWmIlf/D/JRi8HpEVFrRYHC90avHmtRWadwKudwy3kua6aIZpMRp/rCeDcDQY6AT6Har5+vUt0ChSOpN0BcySg8Du8lDSWFbQLqKlK0HEZpdhwgYfpqNGnSARDgXGFDo/lKuPnOgR+KptpGaHGcrlBoja1xGOG9uidTZugapqSBm/OtO9mbtl0/oUVeGZjBWS2XDcdK/c/MM+MrqZ6UtmN4HyfWP34UmSeUIsNN7nlGzvIxC5DRxDDWx+d2D0x29Qel7XtQfNSM/9E3u9tHX1JzLwxaK1YaPgAIKiYOFaMy0pOOI3zupWTq/HHG+4ahvZRCO6fWlw3FPMo7uQijgx+IEB2BvqlmrncfCXkGIk/L1r4M7q2iVj8wexVOu7fPn29YgjyssZ8MZ2/d0nb9EwMXiJnZuvHR3Yzih8+u1M4yZDSoO5PA9HjEMKO+JvgeTAst7wImYEyFuWUw0nl0hWFW3dBkUx6pdMYNev4fO7xBCiqGftK5qOnSGDj/mBIowqQImPudUNAJKOTO3sD5l/s/f4TIEN+kBsAQ5CI9Q3TNhsv4IP3jTWHriKBxhpS1RQi8vE9UiVCtouqyGXE37ZFd70cICl9feUo3xYFkQiQMTV4VK/SvMek1Jm8
 2z1ooxFf
 nx0uKVpC9rGcEJn8Ni+72/Ul29OS6TNZyDqtTP3XgTTekf7Y77xkM6xjGPBFVpnd6r9rjXF3f5ih6LrdRafmczhpKSDnbE8CJRcRISuUlpGf++bUc82vDfV2as1nX1FzsF3kbUsYvu0f/rfjzyjU98q2YAEEdS2USWhumdjJJg6jizMYsj7HTknLljRZEuo+ch8ooKQR4T9CHsntFXEYUUug+ST0PsXzyLQfFNx/lWq8bSHsRzWRVCMZC84dDJhxwgEOOpuBmyU5WUIk/NxZ7DjCmxZZ97Fdry27SAZtUBfPg5kiNSqi2HtKyV5m2ZnkzrkOW7yGKjcgQnua6fQ1u2lQX/0cl98QZXFSH09ocoAaL03azK+/vbA3jbQYYFo3Bit0UqZdXo3V6kbCVZYbrztTWHGNuAg9d83DwS3bu+GeZIX+hgLm5/5165QLebzt6p6kcenbZCUzy0hbH3ojvScUaB7nTKq+E+PPR0ER3glZ6HHg1kJRVTR0OXtdsD+caErUMC4qmmAT1hFVBaJTop9Hb5hQFqP1ZEKuOubt9nA7Z3t6cGhvZiPUnLLQihCIfpmEV/UseOtmQngteTMA2k/7kwAPNAqLgYXYA92JZ5jflNUAvQJznJ8y1xUwE0qgvd6rrhwkT3YgnakmlN2AbBJf5Au9hN8gpLGnj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 12:05:56PM +0900, Akihiko Odaki wrote:
> Hi,
>
> I'm another QEMU developer who have been discussing the problem motivating
> the mremap() usage.
>

Hmm for some reason this mail hasn't appeared at lore how strange.

> On 2025/11/20 18:58, Lorenzo Stoakes wrote:
> > On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 11/20/25 10:35, Lorenzo Stoakes wrote:
> > > > On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > On 11/20/25 10:04, Lorenzo Stoakes wrote:
> > > > > > Hi Vivek, thanks for the patch.
> > > > > >
> > > > > > In general though, let's please not make a fundamental change to mremap()
> > > > > > behaviour in late -rc6. Late in cycle/during merge window we're really only
> > > > > > interested in existing series, series that are less involved than this.
> > > > > >
> > > > > > On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > > > > > > When mremap is used to create a new mapping, we should not return
> > > > > > > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
> > > > > > > the old VMA would neither be expanded nor shrunk in this case. This
> > > > > >
> > > > > > I guess you're trying to be succinct here and 'clone' each input VMA using
> > > > > > the 0 source size input.
> > > > > >
> > > > > > However this can't work.
> > > > > >
> > > > > > This operation is not equivalent to an mmap(). It may seem to be for
> > > > > > ordinary mappings but in practice it isn't:
> > > > > >
> > > > > > (syscall)
> > > > > > -> do_mremap()
> > > > > > -> mremap_at()
> > > > > > -> expand_vma()
> > > > > > -> move_vma()
> > > > > > -> copy_vma_and_data()
> > > > > > -> copy_vma()
> > > > > >
> > > > > > Essentially copying the properties of the VMA to the new region.
> > > > > >
> > > > > > But this doesn't work for PFN map.
> > > > > >
> > > > > > At _no point_ are you invoking the original f_op->mmap or
> > > > > > f_op->mmap_prepare handler.
> > > > > >
> > > > > > And these handles for PFN maps set up page tables, because PFN maps
> > > > > > literally do not exist as VMAs which have properties independent of their
> > > > > > page tables like this.
> > > > >
> > > > > vfio-pci is a bit different, though, as it uses
> > > > > vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
> > > > > insert PFNs, not at mmap time using remap_pfn_range() and friends.
> > > > >
> > > > > (see vfio_pci_mmap_page_fault() )
> > > >
> > > > It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
> > > > bug there:
> > >
> > > Yeah, I am all confused about expansion. The example code looks like all it
> > > wants to do is move a VM_PFNMAP mapping.
> > >
> > >           if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
> > >               MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
> > >               goto err;
> > >           }
> > >
> > > I guess the expansion is because of iov[i].iov_len is bigger than the
> > > original VMA?
> > >
> > > Is that maybe a bug in QEMU or why are we even expanding here?
> >
> > We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
> > of this VMA at a new address'.
> >
> > There's never any moving, as input size is 0 :)
> >
> > It's a cute corner case way of using mremap().
> >
> > We're basically asking for a _copy_. But you can't get a copy of a
> > VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
> > to get something sensible and you are bypassing that on expansion, even if it's
> > a 'clone' style expansion.
>
> Apparently fork() copies VM_PFNMAP without invoking mmap_prepare or legacy
> mmap unless VM_DONTCOPY is set, so I wonder if mremap() can use the same
> logic.

It's because it's literally copying page tables in the exact same range exactly
as they are to the exact same virtual address.

You're asking for a _brand new mapping_ of effectively _any size whatsoever_ at
a _new virtual address_ while _retaining the original mapping_.

Also note that you're copying the VMA exactly as-is with _all internal private
metadata_ duplicated, but now in another process.

It's entirely different.

For better or for worse (*ahem*) we've given huge flexibility to drivers to do
what they want with this stuff. Which means -literally anything- might be stored
in page tables, whcih means there might be alignment requirements for the
mapping, which means that page tables may be established in .mmap,
.mmap_prepare, which means that internal state might be tied to the VMA that is
only correctly set up in .mmap[_prepare], etc. etc.

So yes - if we exactly duplicate this with everything virtual, metadata being
_exactly the same_ in a _brand new process_ - with the driver _knowing_ that a
fork might happen (and setting VM_DONTCOPY in cases where it doesn't want it) -
then we're good.

But that's something very different from 'allow arbitrary copies of the VMA'.

In terms of mremap() this is very simply an expansion and we won't be supporting
this kind of operation there sorry.

I may go work on an idea to allow this behaviour via a new approach, but it
won't be in mremap().

Note that I replied to Vivek with some ideas as to how to do this in userland
(thanks to David for suggesting btw forgot to say ;) so you _should_ be able to
get what you need here without needing mremap() to do something different.

>
> Regards,
> Akihiko Odaki

Cheers, Lorenzo


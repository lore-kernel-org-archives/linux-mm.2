Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837E2C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54A36B000C; Thu, 28 Aug 2025 06:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C6C8E000C; Thu, 28 Aug 2025 06:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4088E0001; Thu, 28 Aug 2025 06:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABBAC6B000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:23:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C02313A3F4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:23:45 +0000 (UTC)
X-FDA: 83825780010.09.6987CFF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 36835C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:23:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PI5mdZ3E;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rNWg4K1a;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756376622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dr2BbdyH5qb+su9OcBiuqVYVbLcJDHUFNQwCew9whlE=;
	b=wAT2lZK+29eholi7Q2IdSoWycxRsXqipo7tyOT07OSp0cAsgVO27ZvjBik4ZREdnLUM2ak
	IlLgFFiKOnq721cyyP9dB3YZqQ6DbB+GCyVeyQrG8OPUb2+Uy5+EzgNF111g2cnzdNqRzz
	vjh4XpYRPNOoD65boMff+q2ksVBs3xA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756376622; a=rsa-sha256;
	cv=pass;
	b=JzDUE4OoRs8gjGGzQxREArYCczu55dDBV6z2JstLnELetm0f+/QvMmQpyRSoYDvFy1xDnF
	/gCxQQ6er5+045l0CndNXsZ1M5owHfnGQt0JU9gaw0IAuA6m14c85bM9L3HOKRPF+vCYie
	wxkFU2yCmCEyH4J8A53IwOJM6XJJr14=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PI5mdZ3E;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rNWg4K1a;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8ttot021702;
	Thu, 28 Aug 2025 10:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dr2BbdyH5qb+su9OcB
	iuqVYVbLcJDHUFNQwCew9whlE=; b=PI5mdZ3EvB/grWhonS5kzsfmcGjUYT/xlM
	oTvtWOK9Afsnbsaxb6d+58Dm+UG7LyNFns5jlVnpbWrwvzK9aVjJRDlt7dYEWwiS
	p4cpzs2J3Q9psyMd69lykxyfWBi27E9ulMVa1DMfV8QImFaxBjBeZ6pm8fkLooY+
	qftMJaqbbS6GfV6CsedovHayJbvQzkIuljxHmOq0DLV+6ildghj74Fuyg6H3hdIs
	SXX29LXr3ysP9ztrX3/sg8CDPI7b+nsYegtn0WvzS7eW8lb+T40jhnVzJld/2IVx
	cHcVZEHmYwyN1gfjP9lJhecghq7oGO6Ysnl5OfWmOgFy+uUmTxfQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28acv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 10:23:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SAMRA5018987;
	Thu, 28 Aug 2025 10:23:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bt4ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 10:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZiojmpWEdEWwyBZeHvyoVSp1yCGCTJSxOdMKjIsdSa3F0cBTNLpLJSQ/90daQ/JIz9uffBaJ3J7LoqxqgSb4yVi5nw32Krh+lhiwOJGAv+N2Y0j3g5Jhv/ZrsbkoGqzDLqKfaGIQ+kv3bkmeKWx6tkpfrGDTR6mkpAtwLXp0vAbSUdBokbtbxTujjntH9n7gNos2Tzt0bqTVHfVCK9xU7oGDOFh1zPDyZJxYSw7cRHgNJxQSTO7tCQVswOC2LEbjrQ0SP65Selfkz4h3z9mcEsNfjjdb1nBIEFVKg9fQjdOvrB+h6Ep0Iz8OZEObja48ZwxELoN5YSCddpT92nyoHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dr2BbdyH5qb+su9OcBiuqVYVbLcJDHUFNQwCew9whlE=;
 b=wM2AiAG4Y3A9M8a8uvdRsp+ESSvyM3jR5dVanqz/hS5PnJR5FQ2ARnPB3NZ29/zHSwpOTWggVRoPesny6UBB6IGDdnZonFuAmIWgXfTLVw+DMYEUPt+br4QOlSbnQZaxtURVsgNR08Uz0p4dOBQP3CqqoEVVvRLn9Frl7E/NL5R/zcBp9nZg2dQUeqvpw4nVXojnTuhNqMbZMnmKK01sX4/2cyp0mHKqunLqDFVuM8TU7sTl13XmosVS2iAt97BW5FlVZ3laakJ5nRUNPCByN237bqF49BGvPtAfn+bntAlegJOmGdAvyEs1PGiJOuWzGaK3H0mEtx7yGdL6Cp7F7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dr2BbdyH5qb+su9OcBiuqVYVbLcJDHUFNQwCew9whlE=;
 b=rNWg4K1au/anfkXOkfYTz/Orciwu+cjrCrmXtuXOV7g1dWUGevY5c9iBjqR9fcHaZ0flnlG7WH0RqAbzvH5l6sSLQxf6oAtWww3qnFqrIPGZJojGBhTsHGOc7rWXt2vKAd3biQdPKa1PIKSS0h5DhmNCuvWPuc+JR4/lZPLOuP0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4600.namprd10.prod.outlook.com (2603:10b6:510:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Thu, 28 Aug
 2025 10:23:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:23:32 +0000
Date: Thu, 28 Aug 2025 11:23:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in
 shared.mk
Message-ID: <f9713ea8-4e3a-4039-8cee-bf64edf2aa99@lucifer.local>
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
X-ClientProxiedBy: GV3PEPF00002BBA.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:6:0:14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4600:EE_
X-MS-Office365-Filtering-Correlation-Id: 667dec44-182b-4b35-44f4-08dde61cf0b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J3iaHiKv5tEPtM4eozAlCIAi0DbntDjX1SMYSu94Mx8uVFC+uRUVJZDJ5Nvm?=
 =?us-ascii?Q?TcvQ5doSqyetRB8vFDS39YDnfEm4Fgye0t2OCLNSUr+4LJ+oDI7ERC1eZ+tG?=
 =?us-ascii?Q?1hbSWwTj9ee3OiGcj94F7AwpbKA9qHPWZWm4seDIwUKQq19MvkM1hBrM7q4l?=
 =?us-ascii?Q?Ra0Lwkjkijf/okbLYEAvXZJo35gcjN2s1ZFeCWe8c08IL1LGSTY0loNDsiyv?=
 =?us-ascii?Q?ljYu1mDIYILFG6pyrWXPrkuzVw0tca4vjjTerhQ2MGir1HR1TAu1m14WEuFB?=
 =?us-ascii?Q?FZbb+ug32NmVKkSzG4nabJoR9q85gBdnGSW6zjxMlhkTyDNIO1GTLoaPoy8n?=
 =?us-ascii?Q?V2+L4r1IZBY2sqgUXw6qyxMs5/qcK8WJ1pDv4aDxevj5+YHN4cIQtgfNCn0F?=
 =?us-ascii?Q?OYAeuzF97uLepENkdvnLG1D2RXCLWBdnmrYSzP3UyDUYpKm3V3dY2+C+/N6/?=
 =?us-ascii?Q?H/aCtFi1sp3PSieav3u4NKcNm3t+mAofp6RwmGB2aSSSXYjVdnf7OLQ4jYiK?=
 =?us-ascii?Q?MjW2eJq8OlJ17T/RYeq5HgXFfAFfZUDjhTT6SR8QmXM2K/Z8ue0mcGs9Qk0L?=
 =?us-ascii?Q?PBlmWAHTP0qGW674QKyu3Lmmsocujb1vsmrSDhzKplhoAd2pbFi5VidG9mwN?=
 =?us-ascii?Q?A10Gg064+kcTHJFrmq9BqS3qg//CLR+MVbD295uIW26+qofMGwt7TKj7oKsg?=
 =?us-ascii?Q?s4jZf32ef1STqlJfo9j8GF29XajIgw+F2KrTgQJLSJ8F8dj7q0xXViBHS7MF?=
 =?us-ascii?Q?2ocxnLMyuVxiQd+0r87zkREze4RS3Qp2quk9BPsD0nSOu9k+pCJvSOHhHN6o?=
 =?us-ascii?Q?huRutG7YP3RNbn1WBSJCILJVDMiJYKdURn39vNn9TqlGAf2oF+dzccJ6H1Jg?=
 =?us-ascii?Q?NM+Xt7LI3b4oGz1OUFNWl1NDdHqnsL6xkUOpbddxKUjjU+oY65VMv8Ih5RhP?=
 =?us-ascii?Q?AoyP9QwM7KmdmPm+kykSgIxEUohJoTEiJwxJPdPmd7baIA6caaR4c0wgHdnU?=
 =?us-ascii?Q?fwOka62l842xSI96bEL8bynttQgkIis14E+VVVxbLfTMNRcPqm3XfdfsnvEZ?=
 =?us-ascii?Q?xSLWz0dhv9HesEApUiZsw/DGWJlB6FGUYygu8/pXUvQCffzPLcxr34n+LbJx?=
 =?us-ascii?Q?14jWx3C1ymFnnjD2WACoFI/0eb+B2bTGbnlzGLO1DWc5s2ubjztFL7Nlud+g?=
 =?us-ascii?Q?8uNnlAStAYFr1geeBqSQ9Y3I1j/v2vBOmuost6msKdpcWlaP0cdf62lPDVH9?=
 =?us-ascii?Q?2nWIu/KvvHtwd4YeMWnkPj6WrqxSPWgtRZqJBFBdz8wxZXRLZdkQ14Uy9YcI?=
 =?us-ascii?Q?4ToZNYivoLeBg8nJq+Pr7qP88HnUxElPWSZpTBR4DJUeJY/xtBydyU+KqVWB?=
 =?us-ascii?Q?3BQYxbuZRAac2dRUVSdMf7zu//s9NzVCF2uLB9uwEL2ScEUoSXJCBxm1/lE4?=
 =?us-ascii?Q?B4PNeKmd2Xk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cwET8CmPXjjvB1ZAEHI2U9XIGIq2wrwOia/Soj4dW+qT3VJNvp6C4pOPfOsp?=
 =?us-ascii?Q?ye3ykc35/Jn298/SMKIYo/7/lTDxncxhm1I4zJTujwm5hF1nbd/1kA3RQQvF?=
 =?us-ascii?Q?oe5whIVaJk7wJTH5QRJQDxGTMfRUdbOxe24/RAi7FiyIRAjK/ay5pAOEpL0I?=
 =?us-ascii?Q?ifdNulUjTbNqdRuQB4/iyQ+ZKZ4mqyp8/iI4al23aSe1ezxb/wLgDZn66E+5?=
 =?us-ascii?Q?lBLjXBCe7QViakwDWmsugLWIK6oSB69MwI8E8Gh0ONCi58n27Q5VIaDNLg+6?=
 =?us-ascii?Q?Xq1+TPYVyGoDRtk7uSPgGkhIjJ5JwTFaaMEtYOkxQihZqaevK3wIZpBrnEzm?=
 =?us-ascii?Q?eG6fj0/hGBl9aX5DRSlNkLzEFIPxXuzCQDliS1EWG0ig00tchduIuQC/e7B/?=
 =?us-ascii?Q?R4Ymeon8/F9Lh+dZ5K/PtdNMY4Q5yKjVd99ZzPYoV1iAOqqt4H++dPzRfpJj?=
 =?us-ascii?Q?eaH432NmURNuxPbOWgwoHb5KxQpTzES/0V3VwppgUw2sn53ZnGFEKhKv6jZj?=
 =?us-ascii?Q?OL2YeuJaMOS7qEXa2UrGEIWTLt/h/CzwNzwejQvvEUKXz1VviciHBMW2/Q6J?=
 =?us-ascii?Q?7vbBM1sruK8nkRwJ+tKDdBTXkTjwGmJ4XaN8IkT5PlejGp2SX4ixOzh6vO+f?=
 =?us-ascii?Q?xxDd24/Cn1Sxk/xOxLQjn+EJwM27yUm2b4YTJIb0yXg9k0DsSqmmRkGeiTtv?=
 =?us-ascii?Q?8iju3dbBQzVfG+nEkRue5CL+dsCteBNGD+hbeZmgGmvz2yChQvEC/ZY9RBBl?=
 =?us-ascii?Q?Llk3d61XAmJmgYLUW1Ti5mgXeMQScFidUPLS2wpQqOMkjbqQhiEbnMqohFk6?=
 =?us-ascii?Q?otpDP2uedD+PFBzUmnJFv2LHqK4DOb2kGUcAvcumHZrOMLwRll5dLXXBtBIR?=
 =?us-ascii?Q?D3UmxgSOhDkTuVUrjlFE4grZAYY4BdxUl3nFlaZDI8cIHQQBuvFlSPPCkqi1?=
 =?us-ascii?Q?Qg8c1PYf5dTSfTK88df4ypXc1+cIG3p8za5nqvoKkrmbhrHrB01R9hetw8fP?=
 =?us-ascii?Q?LfkYwTqny7sFgkh3U/R8/fEcGuOnzAW2AYGSLDSwJ4eaOmHkm+/r9Us+NIiP?=
 =?us-ascii?Q?zi/QXp2hrtvxvLAiHsjPwHGfmdwJZSUb/2DIg+MQa/L0CGya4IyBdBFKR8HP?=
 =?us-ascii?Q?vJMZHyAGsd35oC+Avpx71ObboSZsvrKchiEgZU8t9VmWjAEVJ06uf9E3SIv0?=
 =?us-ascii?Q?u8gvyo6bZ10pYIfT9cc9/Nr7om40bblwUbQ9chxIPEd5wLLWpOk1a5gMNKhV?=
 =?us-ascii?Q?pXwdG8B1LU/fdENbB4xQ6hjHNoap4Bd2BPVQw403FfckviTgv59k5bw2LK5c?=
 =?us-ascii?Q?clvgM/t4+9S4FnKEpXjSb/+OWk/UeEDXua5xcc8EEHHLbtT7mWVdUBeIbsoP?=
 =?us-ascii?Q?r67GMaEAt73ej7zGu8u/dmjHbLv7hjOVRYMv6ER/7qohGT2TAczNqIgrr9vm?=
 =?us-ascii?Q?4+DM4DdGAZWuvOSWKiggWGPhgVO9G3m4WCA8DgJ/2GKe6bTJj7IrVxfSVJND?=
 =?us-ascii?Q?7XA3bFh4G5mAPl8xbcgD0sBR8Hq2PlYajnwtHg9j+aYDM7DJz2uEg2sGtfx4?=
 =?us-ascii?Q?mXZFoMBpYe48VcFAxlQ2HoBCsZMZkwYe+C3OHtAig4HJHv17HhAWNEr/Lfqs?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ju0kklCs6al95knkuQEe4gOvEY6UpgNoqYKsscSkw+dgU3EonNpK6Rgh/HJ7U0K3AsG1Eh8RKVBFtoL+Bb3TWklaFIbIVpYRcYy0va6Bll9TqsjJFmlsAiqcw69KryDB54NeW85h5BLBmB4i5V9+bO+KAm4Ta0T1G/OsixL1b/w0Jwv2z5Bi8FspxmPscpLUk1OgxWZatl+qKJmfRdXRs0DPWrXhsuQKjTPeQDEjmmiNT+9D0oHnv/XQq2f3G/uk1gXP4jjZXgE/Lgxnl2xepJm6eyccZbcVD07yHl5xAHaaq34YDPhBlPMzm6vM/U45qd5gwBIfu2HNdFW876+bnhEIrRDAIFF7ANcoHl1Pok42A/+ebqZhQUR3byyUSKAXDhsalb3cDsxP2birv7LeaunfgFYRoWTPd/xs8iJQm1pfD7ttWQ+SfDW3t02V23wHnMSBX3NolpRmapzEbzNxVtsBoJ91afU57xcTBJJFJ8eab0bbtg2J6PUtTUrnX8UNcCRn00c3DCx16Nf6ZOKvK5PjNebhvXE/DsCln0c5zTKagm4iC7UsUWVGHW/h4yptfJeo13C9YK4jO825+9RhiWTTxAzkjJukYn7AT52jMXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667dec44-182b-4b35-44f4-08dde61cf0b4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 10:23:32.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8AzZe1GI3A4q6SN7Q4vbjosSqEiY9YZdJWoghiNRitZ8rmvXiE1BIASOwpBzZYX8c/GhzNJWkV1f4m04MI+PZATunh91XnMEY4CUFGw9BM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX3cPMAkvSvsz0
 Pfb+M3biN01LzXdXVzc5XZBdaTM8Cupemq/4kgpY39JQw+pKtj5CcJvnsrobyFEJOlMWazyvOk0
 SYuZh4MLY9uuZ9IxYTkBwsqTbjqWEDP2UlXfdMfBiR2TDqk+E2UoMjXYKkrDM9JjLr7u7fpOcPu
 pxcMm7G4WFA+eGRY/d/K3bfogdI3fX2W7I9IUwOS+G4m+wCTo09iPCK4OmmCZ6TRhAyqkkWBAem
 qcGsfXrglbnzwZKTTrPUJQkcd9VMWsEqE27T3TlYYi0G3iBegt8HtguGCxRBh1gUBQ664TpPuR6
 96qZjPDmiMSbV+oTnEgD5FbHpfU3k7mwfWQZCFuOyHWlV6msKVBVfKDwiKM5c7G7IncRKjXvMNG
 reFrbMei
X-Proofpoint-ORIG-GUID: 8f0bDin6K6EwM7-sDGH8Gk6a9vwtY-zN
X-Proofpoint-GUID: 8f0bDin6K6EwM7-sDGH8Gk6a9vwtY-zN
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b02e2c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=NtbMQGNDvuTNBqF1xGkA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36835C0007
X-Stat-Signature: no8m5ne9z86wncjyazqx3r6zszuzr6di
X-Rspam-User: 
X-HE-Tag: 1756376622-202267
X-HE-Meta: U2FsdGVkX1/nrpKEquNMggw90Cd7sxRXxRf8Ihb5ILcNEYNmW3EyZpOgUn3YEbbrg54YDFWTExp1K34cBwmunf0KtEXUKNV/7iHZ85/oXfDy51Hglk1nyt95PJg6UpASVguA0S9hSTMpRVaPF03dXV9M1qhWNQeu67R4P/+lKrt9l/EQK9NuwIugXX5cBspEjJfB5HEcugJYplzG+Cu+Xh92KT3KQsPWhKnNwqxnPivenvDQhrqDR7wnaREvTesEVJcMOEv+I4g+5n1O+KbtaaxXulY2rVq/cgmcLIvObh8tKiPLN+GkJBRUG54TWp8+zpxBWZNe5oYB+P1yU+TRzM3NyQBHbqCva4acjASrFt9TyKwJgfc7mGu+3CAHcSUHyJTTBj4UMFfaQS589zm6Xyr6Xg0v8fTEmcZluG0q5SPFHDzy7yqolQMS/Wme2cE23sLtc7cxNaOda1p/+SuV4q0HEoGV/CwO2H2xmdxtjmdU2uvxqeIkJpOEsJyQqAg6bK7qPiwQMxClWJJJajV+91EZaLJ6ZQa3m1tisJ70QjfQrSAXWd4/rrSFYMjZpotlXcmfRMMJsoJCsWdS0C24m+VLYa2ttfsE+pEUCEM7m5qSV9tRi02augdlfIMa80H6eUW6SSVlv2hR5qPNshuXVlmyDP5MOmDge8ck4/3qxBj31tT5fyOnPHjwfD19fe6iJIsS7wMqfEr3qTic/NMfrf9ity8uGYv6Gmez0zsXrO23aGCysb4SKiQkeq9paRSshqfzM51WP26x9BYKkTmHvYC+tD33L2Nne+fiGpN7xlNCHLWQIgBOi6V4NmeRJO6v/ibfyuTZovwDSAAxiSx7G+OeUHZ6HyqIIKl4bHcXSh8dZbmS+4kWSUuMvUqa+C7mzR4mwuVZL0icLjpy1Y2foeh7aoKTBi2zukWX770K2Jc8TSOG92W0xzi/+9KfRDGuu1ptlnFWhStKdYyjzmx
 Bba4MUeN
 Sg5aJrRvjIzske17NmDmlZgeolveVoUHBdcfvP7V9IRcwZVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:04:41AM +0000, Brendan Jackman wrote:
> There is an arch/ tree under tools. This contains some useful stuff, to
> make that available, import the necessary Make helper file and then add
> it to the -I flags.
>
> There still aren't that many headers so also just smush all of them into
> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

LGTM, + works locally so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  tools/testing/shared/shared.mk | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
> index 923ee2492256b693c5cf16cc014d9d2410be5457..937aaa7623320da1085a8e0f43f6a728ddd3ab1c 100644
> --- a/tools/testing/shared/shared.mk
> +++ b/tools/testing/shared/shared.mk
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
> +include ../../scripts/Makefile.arch
>
> -CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
> +CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
> +	  -I../../../lib -g -Og -Wall \

We're also adding lib! Very very nitty but maybe mention in commit msg. But not
a big deal obviously!

>  	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
>  LDFLAGS += -fsanitize=address -fsanitize=undefined
>  LDLIBS += -lpthread -lurcu
> @@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.mk ../shared/*.h generated/map-shift.h \
>  	generated/bit-length.h generated/autoconf.h \
>  	../../include/linux/*.h \
>  	../../include/asm/*.h \
> +	../../arch/$(SRCARCH)/include/asm/*.h \

I'm no Makefile master, but I'm guessing this will always be defined _somehow_ :)?

>  	../../../include/linux/xarray.h \
>  	../../../include/linux/maple_tree.h \
>  	../../../include/linux/radix-tree.h \
>
> --
> 2.50.1
>


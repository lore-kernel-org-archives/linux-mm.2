Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F58E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7786B008A; Tue, 24 Feb 2026 06:31:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281AE6B0095; Tue, 24 Feb 2026 06:31:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139576B0098; Tue, 24 Feb 2026 06:31:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE8BE6B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:31:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B587140536
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:31:49 +0000 (UTC)
X-FDA: 84479135538.01.9CCCEBE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CEC84000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:31:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AgM5bj3Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=asLQVm++;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771932706; a=rsa-sha256;
	cv=pass;
	b=fG93XRbxbRn0pCwc+Ha2yYFYpYW8+iiUuxFLtsKTVOAS0In1EBAs84uUXo0ftGiOa07ndf
	SAflz/hL7Cu004i3KK+Cn6ZXRKBPN4f3spC4PEVRywWDAmYOjMtgAOvA2f4BEdhhHzfqG6
	xc9T4pZh3LX/akBOQ3WnRI7lWHy4KLU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AgM5bj3Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=asLQVm++;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iq5DwCgxlD8niZijGKwGBfP6U+tPxOm3BRk3Zh042KA=;
	b=As5/qK3XEVZ5APgZtCrMTDwnbBw7Wu2nWU0azJ2NYoqTo3BjwzCeh9R+z+G46+BvwZXrYS
	FeCUdmSnp6aRZv8NLJXNDP92GwBauZlwztrKdquz/fa2fU0fqyxTqh/Sbr2HmLf24SYYL/
	LFCeWEh7w1hg2IKLYprYZL5LZ6mr7Y4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMvcBa2949080;
	Tue, 24 Feb 2026 11:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Iq5DwCgxlD8niZijGK
	wGBfP6U+tPxOm3BRk3Zh042KA=; b=AgM5bj3Zhne7XuhseCh9uyUCzuh/2dULmv
	6ReelHlvPsYnDgAULoEZFQubL5lIQ/2IzQJ00eaeQan8X1O32ff4Hme2dueuNLE/
	IG48fyfiALQL7YvvKQvNVJ/530CWsbavFTb6dwvcxckxLGo58O33gYU5yeEzpWSt
	DD+2zCU5P3T6bZqwyaVsWeyPSoFX/LI4WQIqgqWwlMuq9qT8WapHiQWzX8GFY9CA
	v8SKHUhXv6UWCAO44G9qSVb0rClKuvpV5+rF/qR+RaEm7ohzIQE+7OZ1j4Zsf0CZ
	btkopSODFh6Z8SSF9A9YC2Gn07VG3pyG8TPvIdE/KoYH4u6av9iA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b434t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:31:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OATu6J027834;
	Tue, 24 Feb 2026 11:31:32 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ekvys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILI89SgJFz5VARfAcWTZFBKtwWISz959LJNEGnOerLQS8pPC9WVJXmMUqECais1mT985YRVujU63/QyS9vEcs/iyXIDFbvJvdhbRU1M4PV/xv8mKFSc+PeHZErJBevXpY1trxO5/rZKSJD8FsBHhf7wqU8BYgHLm8DhG9Z0A4DD2JOrBjBPrDSbsf1oV00uLVDYmk/wfrOMDGsGBmKA8OzvBuqyJ8ijRRoJerKqg6ZWToro9eUdkxfw3Fj+g+jaHBYzJKfJSzSyBXZl5pVc5D6AYrkbDeKYEHeJLkwRtT6AnfRhcuxw9ikL5igMZmttwi+8XqeLe4HH9Nj4DAMlItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iq5DwCgxlD8niZijGKwGBfP6U+tPxOm3BRk3Zh042KA=;
 b=uf5k1Ao3uoS/y4Ywuhrk1d4T1b/Cll7lXfizRLtuXpkU0gW1B1VJTgmYZv73IV65tiiUEHfbeyGntq0lPpyqB4xpIk+1LUXX0hEhyrmsh+59AY9bOkgXygbB7mzRWdU0mipvr9FjMxkeuE6LTfdNjr1Iice2jbkfl/W+MorjwjOhZxqdY0+nkX59n57yluZMKEH1hDcA5qlZ9zJL+RIJ9X4dKTvkms9lEg1FVVfk+ypCHbHnXqHFXDROc4Ri39vs8Zc4NZTdvZbxdD5cOK278sZNLrhqfCGE+UsGnRVjiNxab2V654YsjNCTeNK8DVGAxEqlkxpyfOalAQ2Izc6wfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iq5DwCgxlD8niZijGKwGBfP6U+tPxOm3BRk3Zh042KA=;
 b=asLQVm++heeFEW+UQ/lB5HnOFH2fZlb+8F8q7pB+DxnFDD5zo4absPyndrT3kMkTncgXuXvjq2xVvLheaQzrF8kfCEyngKkNZRzlTzpVzil9eHaUkJbFuiog/acnUoVEaJ7VUjVooK2pDSvY0Z6ZZ0bPDqSgVRykstlgmAh2DMU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7990.namprd10.prod.outlook.com (2603:10b6:408:207::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 11:31:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 11:31:28 +0000
Date: Tue, 24 Feb 2026 11:31:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
        jannh@google.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Message-ID: <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
References: <20260224110934.881360-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224110934.881360-1-dev.jain@arm.com>
X-ClientProxiedBy: AS4P189CA0046.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: b643ea73-81eb-4d4e-e923-08de7398404d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oSgOXWV8g81iCq6vd1eJRbB6j1R4TECNbVVS9vjRnX8cPTYPvQ3JZgWZxTsj?=
 =?us-ascii?Q?vmyCid895bT59zmU8+6MsoUI2+cuSf2pZYIcuhT3T/iQASZvTxJQGPrwYz7T?=
 =?us-ascii?Q?cL9rR6SxKRFYbapp4f2nhsAwAd9sxYd2NGBO69Lu8/4BOjyuQywpHFwtDyTt?=
 =?us-ascii?Q?PsBlM85S03kSLF9PybsNCkNQbctr1nTyMVnbqxczwEHUajo8MAKiLo+iJF+w?=
 =?us-ascii?Q?JwhXbAiM44ERxrogcx151lVUy61eXyI8YRIStGL0A675CVWlH0AuAIsNoWIK?=
 =?us-ascii?Q?1jWzXw73GEntpHGGtoJ/rAVfA0Wgyu3oW8RVXCL0VZdsTzM+EcVef3gv1I8e?=
 =?us-ascii?Q?OPpslgzHZdFAP6W5QnjdXe6LspvToAKQdQuws0B+Hu+sCaFIREqv6ku/LpIt?=
 =?us-ascii?Q?BetrAyJxdioVoFFVXj3AxDVB/8vbN7VVD9Ff41E8dTy7WrwObsyRlHhEttXO?=
 =?us-ascii?Q?wKn2WO+Sb/9FFLPSCmWQFuBKySEVtXR6ZZGNq7Cl6Y95YmRNLn9q86FDwO+Y?=
 =?us-ascii?Q?hLwtexmp4g1rONUPwB6QFqdVSeQhBD6MwFBMeVJw09PvDGt9Ne4WOh5sAQm+?=
 =?us-ascii?Q?YM63KDFw/qLWIn1UdeFH4CthvcrZHmpzqJ3YcbnjQj+1jThI3a34Y2z7pmVd?=
 =?us-ascii?Q?79mh++UZtwpsvxL1FtGTW/hOS38ycLy0isYxsXwXHSB5tMJhOFgB+dywcvtV?=
 =?us-ascii?Q?8UbnXALmQ9tAypCZVUMrSR2tXa8l3jdcjdErloQXe1nrc329hD+v0kPAJ47V?=
 =?us-ascii?Q?GBcuFfd9yINSZj8vXn57UyMECd1efScVVsFZyi0iwTIi68he/mtYye2BZc+Z?=
 =?us-ascii?Q?YuljaOv2Z8JFAFIjHfP7vOnlDzlup4vHGIqZChrOowG2q2Uhl0C+70oORMgd?=
 =?us-ascii?Q?31XLm3VDU3h3K9DAZQO8fz1nviStXduMBsIZCKK3HQnYU5FCr1H2icdSv1/H?=
 =?us-ascii?Q?VkM7h12//nNDZ7xMiBo8KjBFbYc6a6NB/2ojQcDljA6VFqDg5xhCDr42ex8j?=
 =?us-ascii?Q?vdDtXQA2iGAvP0Su9X5wF01e6qq62+J/WQM5gJ/LjFDpbNJiwGW6njD5O/g5?=
 =?us-ascii?Q?r1BsKpD1CqFzE+uHxhNf/MYfMRiWAIlfnm29Se0XPRI7GZyxlcK9kCCuRGqE?=
 =?us-ascii?Q?Y5kGRhvuAmUdLSJJeuTzXO9fr62onvpTPDvKbgTIc/fNwd84MCH6Mh7pGFnH?=
 =?us-ascii?Q?e7EG1l7UWLRVb/SwkftBbjHyGp+jTSUZS8H1TjzjhaXQGWy9uLMAD+7Li0Sp?=
 =?us-ascii?Q?sZLnSDT8JSdmQ/NLf7hZEY2+pEPvRR+JXH80dYDv7lKN68+XjOyuqR8jJRrA?=
 =?us-ascii?Q?OHxakMTQdBsNO2jGp4KX98Rh2ppPv0TprrBd7SVgNgSNdw0PdXmcznM5eVn0?=
 =?us-ascii?Q?QoHU90dOFcfqJGpbyiihnkBi8CPxVD8keD5lqj5yADgPKOwvuZNcccHcoBYr?=
 =?us-ascii?Q?U4njzSup0hxiTCU74YYnlrHTClqvBllXQ5pclSK5Y2EAvc2uglm1kEzmfPcq?=
 =?us-ascii?Q?qb7gZYNkzXOQYrNbG0czQ5+1Q5QF5LihvLAQg4RxPsgoZrMrnSixtTmNDgVB?=
 =?us-ascii?Q?sBE6ImPql1GA1dm92cI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xml2J2lc33Kg1WkmE1u1snPMdTvA48/kY73cADp2KjchPae+J8+FZ+1sl86s?=
 =?us-ascii?Q?zunSsiyfC71sEfNODIf5guDYNd/WawVOtxaST8f57ewZcn0pWbXyYOUtguOR?=
 =?us-ascii?Q?hLRoahIoTEUJTO+6mepHgIJZoD3fuIKlRISqIBDJFpMdN+mXj986K3iEwrVP?=
 =?us-ascii?Q?8Im7K1FUw79oBZSVm64OVjZllgGuzkZvY6DLzSTvcDQJKbA45V2UCzLquwbV?=
 =?us-ascii?Q?5vDo3vv+Ps60GPex7G6Yxv68hxSGJ6Z3gniKRyd0esi07PMfqNz5hHRvSO7u?=
 =?us-ascii?Q?SGfVE5cKNmw2HTSTuNudwFMKux1HT4u1Q9RrXoCDxtb54iMXRg2P0NmzwhZ7?=
 =?us-ascii?Q?IAQ2O+rSC5vmBkBd5hMR0f65w1bkn5WnIHwLM/lqes38aFuS6J4KUc52JWXY?=
 =?us-ascii?Q?4a20XmniYsg6lQJbbnwt5DrRQ5MkvF0tjz6gTSMqm11VM1BkD8subI6kQYU8?=
 =?us-ascii?Q?Pj+iMO/v452gzmJkrlkJDSusk1JDGsWs86m0AZUj41wpRSZwa40LQLm0YfE9?=
 =?us-ascii?Q?K9GoEpI/KWPZF3vsGKSandrLo1l7BkXmAfAsjPthUeKcS24+aVSSpqFXW+gS?=
 =?us-ascii?Q?up3lJinU3Itx5inGa4z5yccJkpvUu2Q0ME4aDCKxDM1fcPHmCVDazs4WZHQD?=
 =?us-ascii?Q?t55NCxpJbpwAqmiF2LBeGbSLCYarrmyQMATyI+MAyW3UfcDCrWeq6pzp3bvV?=
 =?us-ascii?Q?0z3a9k6+B5KT7LRAaH7GjAYaBJ0jiEmnNR4d4nxhKs4AqRHMmxU13plrogus?=
 =?us-ascii?Q?rrIV1a7R0RKMEKhL3du97MKpzLPH+kYqlY9Lvcmyf/dPg6wuIFQEHsr6jqjI?=
 =?us-ascii?Q?o8ESYtaf/rbKDsJTNed0Qew727cnT61jraj+KqXNbjqP1e+DhqUG4yr3sqfo?=
 =?us-ascii?Q?nsFZtaVHc0cFqdNNz9dTU33KzUsRKF2RGnqYqVMHenGseh3BSzNcbBqJCz82?=
 =?us-ascii?Q?aZOlnexs77Ifm0V3x9DzmrPKInUkUIOlFT6Sdwr7NCQ2LPQZ3tfXNKj0w1bt?=
 =?us-ascii?Q?Cy1vevz6b0Rqh6gbj7gKUBQ5CmFD29gSAhxQ+NCc3LleQnJnBPcWNWayKljg?=
 =?us-ascii?Q?rx931NFwJ+yWs/kTPv2z7He5tIZPbd+Cb1Jx8VSSLFBKWlgi7rWAc1hcsVIw?=
 =?us-ascii?Q?VI667FVmIhkR/Y1K91uresxnYCrJ5mhJHxGY+3i9AGfVUT0/NWeblbLHMcAh?=
 =?us-ascii?Q?mD592Urt9z/qmQrjZtIv4idfB9Et3qkvGfPnopJgzBAUOpsiMSd9EzrCBYZE?=
 =?us-ascii?Q?h+LNEG55Pa1vFWo0PZrcfwrrYjSiMqsEb10BmuyISAX+pyA/XumB0GOPJh4d?=
 =?us-ascii?Q?zruKQo9l3RxexL3GqzT0NnTeboA8nCtdjZ5S+ozW2fCSncJk0v3RFfyjTkIw?=
 =?us-ascii?Q?uZQ1OWutq5+7WignjqitHaKynkZOuvj05DdI8lFmb6bwWQQZNfgkbXiPgE0d?=
 =?us-ascii?Q?RjVGLImLOiviB9Mohp7jhPFexizR85wy+jjXnTByb7NzDtFavgbNRlyeAs3U?=
 =?us-ascii?Q?5pL5X7G45OhGG75rdehBjdP7mFgoJzHdlP/oPvL+xauvDtmun2IGaF6NiwC0?=
 =?us-ascii?Q?WD5aYSyXSTEXYbVQQUdJOgAwh2Y4gWfQop8R7adga/3auYOWDAQu6NmTkLJU?=
 =?us-ascii?Q?JBthOsmc2OZIvNvVrOemCjcFrNr9PeADvklJRCf0foODWTpqb/Lr/1fdTc6Q?=
 =?us-ascii?Q?aZvV8BRRsa8be0Jkl2lg1sfC7tz5bj/npv83VBw9dH3pxShlGYrqQ+Ipv0tN?=
 =?us-ascii?Q?OsRCxyCRx+IzhAqxBXpZ11nU0ne2AOA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fEkz7jRKp+lQAA08YlT/n/vt0z2QCAl4U8e24WLwrJqcW8Zq6mIsT0ijbdrpRBNlgqk9lQ3i8ppUTufyE0Jjb2vzwoEw676Zmw3wD8WMTghp++AvXrOHe0YhdkAKchKzTJlOpMndnKO53nYuXlWbn/Insx9Xu8o0vhx9wS6EbARwr+SHAGscCBtMu698YyYvze10QwBXMXPddNnaaxABuh4LwW2ARXojiAxAxkOaDBYJGdtqtg/bODHisMbxKyg37S+iIOSqV1k2sEPBER+PMocuQoUV7WT0QYfiW1p+z4ajBtbsfuxrzYDD8EYKts37PX5dgxjSfZWTr8z9EoZpcABNsX6P1I+I0PnmJ0VLtREGCPx/NGMSDFnyhuNdv+qMJtUtk/nj9DbTOSVfJhvHbIGRl2o97NB3qsys35rQpMXubukvAzRzptZSpKfxb5dEqVAlxAarENapG8dF0hB+tws/Q2VbK/4ifGo7lO9o+ncH46HQg0CkmwfbkTw6RyTwuacPXH12QVi+HSOwku5cooubE++yFANQqXs4WE3e93waEIWajVsNZCIpo7Ry89haf+Zfirsx1dr2kU8f40R1g9HP96wy5omvcMHXeyFKtFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b643ea73-81eb-4d4e-e923-08de7398404d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 11:31:28.5734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rmyIKrSGIHr5JFO/aqgo3n1rM+eyrKWoayr88Dzb9n1iqEpoudpqfh0BoZJJbkUWaS4YlCdTMdOHanwkdkH9zsxA+dburm/ecyU/CnjK07A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7990
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=834 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240091
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699d8c14 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=sBcEIfeGmRTWXoTW6cwA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: j5xiXwSbwcPU8bopV7yomG3JRruGmFGB
X-Proofpoint-GUID: j5xiXwSbwcPU8bopV7yomG3JRruGmFGB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5MSBTYWx0ZWRfX20cQC+XCddcQ
 fRDlmLijojyFwZnACQ/9v5DoJxbI/I/N0FsN3NKFoSOSxpQuV3DK0uNUzyVvToUIt8QmB4S2oOX
 nWiHM0jpoi0Ytsux1gNPm1ihVJ0M8y/TpH7HBwaka7c3MEdVqDY2rcomj3cXmKIrMsyV2GR1pFc
 MXBdX9HhpQqZLL0TZoM2ngYNnfjZ4FBj+TZiSTovdNzBGVCqTqXwagDIUNbgLw2ouNz69Mu38DE
 IcTspdS/cWvw5iKOFrvaFGIGyQglwjBNljXFvAiyC6ftKZCByp48oTRJLFDT6ryQaTO7v/qkbqz
 cOLwEpynG0z/v3Lo8iK6x+Gxh67ZDaR8SoKmbeR9znA/nq6KjPgHsS+BS7G6lrjTJII5GRUgBkH
 13FymN0oQUlNfJdHqxQSilGf2136cE8okDlitXpRU6CmpVAw5YfSPsXvcf3Coh8gFzre/glfeFN
 sEj/RwxbGf88hxqduiKdLIZnJyfS8xXK+kFkY6RQ=
X-Rspamd-Queue-Id: 1CEC84000C
X-Stat-Signature: trngppet5fy9kfi8xwagi5dcnjgj9hfb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771932705-413216
X-HE-Meta: U2FsdGVkX184RJkS4NLWpMEP7h524gBv9mMX6LqctwjbOhnLUEKaO1LFgOi4s8F8VGZ5iEQ5D+W9CQ76gWvrEP9e9DCXCLxykekZAcWLtMCVF1Stz6+N+xAMt+dmU/LuHIBAbFpHUdKzSTUaBFl9K4JD4+iGw9QHWQsWRh5pCCP4+kKnonoOWXdO82pzQp7wF5jhioLkLTjqsXyfBcLUh02X0+Guw8PdVmziySmRvpe+2uhMAqqCnCw8fzHOx0eaJwcZJzWFOZwlneOd0qL7oR2PScmnWCUMjvvNHV8sTi9VKILIqecXOAICuhrnlHHwQLzLQfB0U87xisXd9ouKvmQ8zpg92UXGSw7qah+LL9zGeLCxgF/UMPctBZd43lK+BXDnyHyw9OcFRn8ouqC9u4MHwi2yf3VqezQTj2p1cJj9CHPz97667sm/h1xRFII4ng5n/RYArNHCZR8bWnd+UmJEiyCVSvEOIlyF18gciW9wF59sIMi7t8FhTSejpZqvglL+xgcrpvmZ0SMuCDc/lyjoIM1fBMYPpgTeoXZuf9kJ63C/IKzIStQk+SwkNVxJ2MJLpZJKpfsPPL+lDvatvbNU7C1fqZkRATyEJoJhsy1yF9Nlsrtu/YBL/31PnxZyHTyKSSzJrLCEYrVMzTGhuCVvp7G6Ri4jwKuFimfbKx6YFy35opGQ1xaBt6j8MJC4J/7SYAdL+m+IJ5QCYozXSO4vC9g4f7w06/uBiutOEdt2v3tRsUYC2JCAAsuJn2VK2islcRZHFmAdD66lw473ZlvFYi3JEL/nhtDsNLfGvRtUXvy2xEwgj2ziZf4hGhEOxFZA/2MSPxlq1avdRDICDbuzg+z4fIjvyOGdhAO8W9xB3paQsSc7WsoWouWKL0icNo8E67/PBt23JYMtXcafFK6cNMDDbDOQm9ffeD5ety1RTaDvw2YHJZmDmvTWW8vA+uN+4PKv7cHozU1Vrmx
 1jh43ZKK
 V0voMA1ZNtXiGJO13zrMWegX0z2ajGDeXu5rCe+TttJjYlVHQ3A0/ShMJOJ23rMqTaPBaAyDyGsjuEU1odo4e6/4wgz05hdU59G8oK4JuPOQTWJYDAHFtYhxeJXeGD+g/WAt3tElCIGz9KK8KniFGJQWf1ovRpl85lR1AAA48MaQAdCfTEl1dv5GcsGkr3qK+O6yARvm5ygcYSMqNCzTlkAgk9x7eGF58cpX27GWYQArtInAu3lPUWNWCt27OrhIfkTLiKFe2gRXfG4mCzBYKrNK5LmcwUguovXDdidUAH1ytGINpDgtljdejbAm0xPV2JZ0dKYIX18KrdihwV4+tm1/KFJhn2NS/C1ZhWwBpw9hu3ZsPVtsWj+AKU2jyBjt8sJWZE2TT2LH1eRNR9NaKSjI2x5lnRHVzDz59jd2RweYK7J5Fzh6iJy+N99hX6Sbp2RBV6+JcmA4RsmeJ644q21iwi52Du1gxa64HvRlYC9X6Y61ouDFQZg1n7lE9prQZ8NA7iMrbmd3AD2wWLGahhuW05+ENzXHlvlSJI/B3WjICGsIsMdl+6jXrZ3V/IwDyp6C5OdEzRs1dUjMH4HSIQ5kIwaDvczFh79+cnZDnjYl4WUd0WA8CSLIbcdXPOnqXPuXF2C8MA8QwdDUw+NEOJ4c+FBp5625R8lUeHYY5cS06oEX9NVYC+Dhp28GOpi3xlPZh2j4/WRACMe9PPnYBBjFpGDvMhhliVLQv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Dev.

Andrew - why was commit 354dffd29575 ("mm: support batched unmap for lazyfree
large folios during reclamation") merged?

It had enormous amounts of review commentary at
https://lore.kernel.org/all/146b4cb1-aa1e-4519-9e03-f98cfb1135d2@redhat.com/ and
no tags, this should be a signal to wait for a respin _at least_, and really if
late in cycle suggests it should wait a cycle.

I've said going forward I'm going to check THP series for tags and if not
present NAK if they hit mm-stable, I guess I'll extend that to rmap also.

It'd be easier for all concerned if we could yank stuff earlier
though. Waiting for the next cycle isn't a bad thing and avoids this kind
of bug.

Dev - I wonder if we shouldn't just revert 354dffd29575. I don't like how
the original patch piles more mess into an already HUGE function and it's
clearly adding risk here.

On Tue, Feb 24, 2026 at 04:39:34PM +0530, Dev Jain wrote:
> We batch unmapping of anonymous lazyfree folios by folio_unmap_pte_batch.
> If the batch has a mix of writable and non-writable bits, we may end up
> setting the entire batch writable. Fix this by write-protecting the ptes
> during pte restoration in the failure path.
>
> I was able to write the below reproducer and crash the kernel.
> Explanation of reproducer (set 64K mTHP to always):
>
> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
> the folio as lazyfree. Write to the memory to dirty the pte, eventually
> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
> restoration path, and the kernel will crash with the following trace:
>
> [   21.134473] kernel BUG at mm/page_table_check.c:118!
> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   21.135917] Modules linked in:
> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
> [   21.136858] Hardware name: linux,dummy-virt (DT)
> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
> [   21.137607] lr : page_table_check_set+0x134/0x2a8
> [   21.137885] sp : ffff80008a3b3340
> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
> [   21.141991] Call trace:
> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
> [   21.142766]  contpte_set_ptes+0xe8/0x140
> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
> [   21.143177]  rmap_walk_anon+0x100/0x250
> [   21.143315]  try_to_unmap+0xa0/0xc8
> [   21.143441]  shrink_folio_list+0x59c/0x18a8
> [   21.143759]  shrink_lruvec+0x664/0xbf0
> [   21.144043]  shrink_node+0x218/0x878
> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
> [   21.145056]  reclaim_store+0x3c/0x60
> [   21.145216]  dev_attr_store+0x20/0x40
> [   21.145585]  sysfs_kf_write+0x84/0xa8
> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
> [   21.145994]  vfs_write+0x2b8/0x368
> [   21.146119]  ksys_write+0x70/0x110
> [   21.146240]  __arm64_sys_write+0x24/0x38
> [   21.146380]  invoke_syscall+0x50/0x120
> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
> [   21.146679]  do_el0_svc+0x28/0x40
> [   21.146798]  el0_svc+0x34/0x110
> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
> [   21.147074]  el0t_64_sync+0x198/0x1a0
> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
> [   21.147440] ---[ end trace 0000000000000000 ]---
>
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/wait.h>
> #include <sched.h>
> #include <fcntl.h>
>
> void write_to_reclaim() {
>     const char *path = "/sys/devices/system/node/node0/reclaim";
>     const char *value = "409600000000";
>     int fd = open(path, O_WRONLY);
>     if (fd == -1) {
>         perror("open");
>         exit(EXIT_FAILURE);
>     }
>
>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>         perror("write");
>         close(fd);
>         exit(EXIT_FAILURE);
>     }
>
>     printf("Successfully wrote %s to %s\n", value, path);
>     close(fd);
> }
>
> int main()
> {
> 	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
> 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	if ((unsigned long)ptr != (1UL << 30)) {
> 		perror("mmap");
> 		return 1;
> 	}
>
> 	/* a 64K folio gets faulted in */
> 	memset(ptr, 0, 1UL << 16);
>
> 	/* 32K half will not be shared into child */
> 	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
> 		perror("madvise madv dontfork");
> 		return 1;
> 	}
>
> 	pid_t pid = fork();
>
> 	if (pid < 0) {
> 		perror("fork");
> 		return 1;
> 	} else if (pid == 0) {
> 		sleep(15);
> 	} else {
> 		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
> 		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
> 			perror("madvise madv fork");
> 			return 1;
> 		}
> 		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
> 			perror("madvise madv free");
> 			return 1;
> 		}
>
> 		/* dirty the large folio */
> 		(*ptr) += 10;
>
> 		write_to_reclaim();
> 		// sleep(10);
> 		waitpid(pid, NULL, 0);
>
> 	}
> }
>
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Applies on mm-new (commit 018018a17770).

Thanks, but please base on mm-unstable, as mm-new is for now considered a
testing base only (yes we will endure merge conflict pain but I think
worthwhile).

>
>  mm/rmap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e4..501519844f290 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2235,6 +2235,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				smp_rmb();
>
>  				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> +					/*
> +					 * The pte batch may have a mix of writable and non-writable
> +					 * ptes. If the first pte of the batch was writable, we may
> +					 * end up restoring the ptes incorrectly by setting the
> +					 * entire batch writable. Avoid this by setting the batch
> +					 * non-writable; this is not optimal, but improbable to
> +					 * reach by virtue of being a failure path.
> +					 */
> +					pteval = pte_wrprotect(pteval);

Is this really a good long-term solution?

This feels like a hack.

> +
>  					/*
>  					 * redirtied either using the page table or a previously
>  					 * obtained GUP reference.
> @@ -2243,6 +2253,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  					folio_set_swapbacked(folio);
>  					goto walk_abort;
>  				} else if (ref_count != 1 + map_count) {
> +					/* See comment above */
> +					pteval = pte_wrprotect(pteval);
> +

Again, feels like a hack.

>  					/*
>  					 * Additional reference. Could be a GUP reference or any
>  					 * speculative reference. GUP users must mark the folio
> --
> 2.34.1
>

So maybe a revert + a rethink?

David - what do you think?

Thanks, Lorenzo


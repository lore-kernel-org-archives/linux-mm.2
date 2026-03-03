Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC10BEDA694
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097E16B00B4; Tue,  3 Mar 2026 11:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045716B00B5; Tue,  3 Mar 2026 11:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35C36B00B6; Tue,  3 Mar 2026 11:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D088A6B00B4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:29:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7105B16026D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:29:22 +0000 (UTC)
X-FDA: 84505286964.16.5FF81BA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C204140012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:29:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jwo1TuuX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wS22jIA2;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772555359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4t71SsMA1jr3xdeOZe7DQ7Q5P19ijXIooD57QVnjIM=;
	b=ush6N/KQ2P8ejpIVAW/DLNlldObF1DiMKkncIIroSBrWQKes/O+yKiIlwIjHk7eWQMthiY
	+c1ghs5IxslfO09HIbVHCza7FHtfNo6/g34hNu4lFv+Y8XmxOKcQRgGmpGmT1q5nS+c5cF
	gMSIR6X7hjaT6SIjczQ6LqPpiwETa8E=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jwo1TuuX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wS22jIA2;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772555359; a=rsa-sha256;
	cv=pass;
	b=ze+CD2wsfKhex/DreYgKy3Odow+TcQZE0nFm1GpjJDVebn3vSPsYn+whl9C5AUvnV2cDrC
	gQ9VXiT/caOXrhIRFfonJKo3RDjkMaUdIVGiYTG8tXmaEgtAkzB+eTa3GrIcaNE4ARmv33
	xclWcVX6dyrS9moM/+nfp47fB6PG/xU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623GH3dI486431;
	Tue, 3 Mar 2026 16:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u4t71SsMA1jr3xdeOZ
	e7DQ7Q5P19ijXIooD57QVnjIM=; b=jwo1TuuXsMVK6zyDoauvigB8AD6V0Pb7AE
	3yvztVbPpBm1prplf9obIfom9eWOYiy+rnzaIKkhXSmzhBb1qNEwGWPY73VuELjy
	YKqAmPthPlNg7d1lvygn0twDAYpopyNItsBC/WdqolpBT3eEb/gH4ebx+kUuxNPs
	SoXjrJcecNEaKDWugABrtX1+hmeyXBI3apNwl/xXCdBwYxeg+vlv3de6EqsnZcBm
	+udZBVE+0JMKukINGYnhkb5vbyLsxOnGSkmTrwEt2FvIcyFdw7ewbzOVRJk2AeLZ
	MCgh1PDE1znEcZ4+7XGJaXXlRADYaTTwkbEIsi0T3luJvN6+2UJg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cp31br0ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:29:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623F12Zx023030;
	Tue, 3 Mar 2026 16:29:15 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpteu7ck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PkjCMplB1IrekV/ZuwjM2rTx6TJ+beO+b6Wa/LjfojodaB/zaC41zCDl/znDPNr90aKt+RrrBqBUKFNrEOXVToc7poj0rCOQNB9n24KobgtFiQoG1IzMoRhzXZqwM0pkSixWjjs7c3la/ipVJX9e3NF4Rs9sp81DshWEWEuNOIOZ+OGWBHjnn8l+7xnuygXhuCMr6VENpw8V7ZkBJ8iisHiBmSEUhZzj9jO2vNOSJTGM8SrKC2qPfCaxmvZYkGwPF9Ub6rkvHYYbtURVmBUnpFz0Miv5Fg39qQLiyIinG/60gJjXy9Q6J7ITCV2yjkbk2UCKpUPGT3l29JnTpJZ4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4t71SsMA1jr3xdeOZe7DQ7Q5P19ijXIooD57QVnjIM=;
 b=ymCaoNdgZOKfWXWfNptE4RBWdoIn5ZAffEU6IvHLQ1FAt72ToMM2gbjEmqNlUDFIm8OS/2ww5WHxRocVdsvMVj0UOyKidNR42KOaogcej0A6F4Aw7T528ZqOUD0QtITXIXXICDfC0c67TfUHloFvKj6G8+zAF+WOtP1Yxisve/dwEeuLiHYiZPhQgv+ZxPOGJhLj+AtzdTvKk4lwx4cFXT+cicHe4BEAKRqBXQzF3N3ftKfmmxHvG/Q/rAPUcmsz8MM09jAndl2U1g0tX9PYjzrbLfU3CL/wNfpyA+PKdZiStACNgt4P3rCnF6rfRMYka1A91IWApZeXKji4lueQIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4t71SsMA1jr3xdeOZe7DQ7Q5P19ijXIooD57QVnjIM=;
 b=wS22jIA28T/PmTsiJN4rq1+/iPYOetAUhNdEc2r/fwe8wUdo4UZJnWv5ySM5io522PeCw7HDKfanCN6/P2wLTc5a21g0OndsDZthgIrPEZi/XaVbB+iSn3KiKUWC6avC5eT1aBsyW4KWqc7LO8fHPkiWwDijZJFQXyQQ3jNxTjQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8302.namprd10.prod.outlook.com (2603:10b6:208:55c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 3 Mar
 2026 16:29:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 16:29:12 +0000
Date: Tue, 3 Mar 2026 16:29:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <3a4e2e44-a3cf-4966-80d9-2ee34cf99e23@lucifer.local>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
 <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
 <aaYFpEmiH99dryA4@tassilo>
 <72667151-816f-49a7-90e7-c68db3ac3390@lucifer.local>
 <aab_izbib9GzSeRc@tassilo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab_izbib9GzSeRc@tassilo>
X-ClientProxiedBy: LO4P123CA0304.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: a19bbbf3-f865-49e7-a7bf-08de7942009d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	9ja7rbM1QueB2d2fUHEVWWnDJOCbiKehzixYM+EdqF3ze627BwOsOnyOCsk9sRq3AuHrs0GYY1cbD1Z5GcN7NvjaQhQr7YsluWxAC+iJLD54QPmvfCRER8+zTn9VV6L73FAeE2uaBlJLYOpPwEl/rp9Cm/T2sD/KQLRITDea036azujaeIAaiZzUzJXgbG/NviJ+3EX0VwFpJknXr36HY+kiv5MEFgpDZ3WAauyLsSUdrXQUOWFnR7LOSiPSvuWiolUTbD57tMb65NY6DQOL50HHcxbe+RlgAlumGveywSkhoEXrcdMEbXTD3M5RRPZ61C1MtAB4w784mjbR4iSnDpZMIjbs4LDUU7n0TUoLFaM8M0vAZ23Pw/VQgWidxZhXdJT4bRNUQzuhd1OyVpucVkJTAnp+aO9P3JjvTZmOhkWZdSYQESMupYiIH+yWFJfQJv1v4VC8oYhefiFpxokH8CG4CDbkmAmS9B4rgU4gv30EAmGri8uxwiFMQpeYDEyhfAKmlwaV2J/0AgOklS+a86J1332q9p1rMeJeR+h/QpHqjEkxgoM91hrj5+DLBzD1lwtTDxKkpKhMv5WI6HumrHbSvot/U1HOGNAlum1tYGE/7Oo2fvqIHpff2oKI/icnepdQVSROXbVRL37u5gt0plv+EKS76Xcx67mGMfoaNicXxXaMytnzBOtpnAwJ6M/HSGy4Xt18MqipEwFozF8Sp0VT7XQoroxB3ZhwZ7EOnwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZRTdH5ZyKamO9MMpY4a4rElQWbI9PoNkDaMXmqy8LDP6B/OOhlpKFzbAcbkP?=
 =?us-ascii?Q?rTt2dnQKsxHiliXdtXg6Vlp9YYiyuKmeXRs+/F5O5p2bPIVrk++5rGjKLgWi?=
 =?us-ascii?Q?u5bEPWXgU60BX6jqXFTpKibO782yk4t/g+taiEGZYolqQz18Pmq1yXYn677R?=
 =?us-ascii?Q?OmfhhodnzDRb+5dGudrRgYurRLULQkwd+DjyAon0DyLXe3XUmCj6FHiftaz3?=
 =?us-ascii?Q?SfmnayDJOR75lZmyUGgG1kG5yqVgU5XWosGrkZcm2oD2yAfdt4IUHJbrK99V?=
 =?us-ascii?Q?of7Khd9kqYfyhonrC2du3fo3jA/5WvQ93SkTybPIlwa2mikX4bsWWK80YPWV?=
 =?us-ascii?Q?ccwpIy9FA3Xs98vf/N2G9QaQoAqfJTT8uclZFLjQIVdlD01a2x7/P5rS3wNb?=
 =?us-ascii?Q?7mrbmpndYs8rRR1pYEa7Jgv8qe5W0hvLgDigaN7KZk6eaDsn8RVL32hkY5Lu?=
 =?us-ascii?Q?OqnK0EGACEjHk/XD+paiZI/rvuK83zcNeOO3iWkUtmihkLac++BXCT57sH2q?=
 =?us-ascii?Q?SAqpP164eRLGGsupQTdpoRefAYM06vS58OTd/uNPjd963Y+O5orpeibvj1fo?=
 =?us-ascii?Q?Jts87paR/t8rZZxuSklENV1vfdx91RV+x4spPxOvh8IPKPw+/pLmuQxLle6B?=
 =?us-ascii?Q?V4XbuL4gKdoIhM8eElNR0v/KMAfMuSZ/7jZMj7/FvX/ZyGQgof1Nong0cKYz?=
 =?us-ascii?Q?XWnbA1AbSljeQwkJz8Z6cSRNos+96WTCUvssEEMj2VsHgnw78eqO/DezLzTT?=
 =?us-ascii?Q?r2mgYZbTaZPDippbG0R1keks7LMaUf+whmd5/ujM+vhhBlCGgcnBBmT5XvlG?=
 =?us-ascii?Q?eGR6HXsGzF56oR1GJcY/yt6K18oPthBTvVjEjVHBoWD8sQKrOKy/hgm21C/a?=
 =?us-ascii?Q?wyadNoeW8hUb5hxoQuvL5lTS0vMznqBCooewGRl2axDnR7rZfNLT3d0o6IOg?=
 =?us-ascii?Q?/snbodiEG0AD06p8dYO5xEyT467NhjtavKh2d6Rp6oUIEr4Ws7hgFA9S2qnm?=
 =?us-ascii?Q?xHOB+F1BDz7UwR7qqqTvkLwIGAfzsOqNLEfZSUl+aIopyUxLmL0zffe+83GH?=
 =?us-ascii?Q?MAo37GKiMv7oNoqpRUUfD6nVFXX94aUTfNy5b4h+njyjzuj2599qbWLwJ6nk?=
 =?us-ascii?Q?EHKLg9+se7dhp/rVOOckhZcj4wGAEZamQ5dJiA7Wv8PDmIaSBxwRLLS4cMJE?=
 =?us-ascii?Q?mwczsdLFJoG+9DQjf6m06Ox/MYevQu73sPOlP3u4DMdgbriNTClyeptimson?=
 =?us-ascii?Q?wqgikVaDWnj9y5rGP5foX4Wpu0r1YhYl0pfyxiNwZi6JxpMIOBHJ8OQ0XHK1?=
 =?us-ascii?Q?W2+dYQCy1SyGxOarikxyX+6V5p98BBg17fGFFcF9C+A59PzLis1MLwDAyQLz?=
 =?us-ascii?Q?JMDUwy9kmv+chMUYWAyDcYv03F+WVsPwZhvQ/1bhXFGY7b1YMEM4vWlQGKlL?=
 =?us-ascii?Q?V0a30ixYf9vH41kSedOvVf5l+j2tmtaNBv3hpGY23hKfLrlumJxPYWBCbp1D?=
 =?us-ascii?Q?iCdYDF0CuQM3jatUEYynQXC1jrG30nMvz4qFsX30lcH1H36CzonKs6xPfUbv?=
 =?us-ascii?Q?5jaiKLpbwWEMxKwLdRYgXRIEHxZjrFFdvvWwNI2/dp/3PJFjATvCUKBMJ9e+?=
 =?us-ascii?Q?mUWYTJ02vWa9dQQcTy7BqSblQUF/iIkpFfZ/N8RedoqtJoWnAoHVBhoFUi9W?=
 =?us-ascii?Q?H+6CY6gih+xVOryVSXbsetbafmhn/QoVbamlms1t21bCkVsxTaEvp96RjQig?=
 =?us-ascii?Q?4MAPMLvsBmwzarvmXhs7VmgOAEmdiB8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vX3B+etrOo4aVqgGkpcE7KWaRapuufxGqcJpsmtLcmC9823U5JksWJQQJGbekm8MMFYk0k+YSludmDtc1xAtu3UnBOY04qvwhbDV3RvE0tMrd7NEbYrvqjhvlt9jgFJgQTrERbXQXwfHNFJ1DkTFymCbVmiP/f3zGFTPP4JL3YOvtQuEW4z97Szk0SsLFpig6BGzU3iX7C1XC/ZKBUIaiNEtSChfwdXUQ2GL5/4oZEKy3E81sr9Gh5uBDEvoOvTiaLSrEJgbkksAp1L+Zl2H5nGZPbTaXoDJbU7ZJQg1KYSyHaz8hmhcXwV7qN2CoSx9j3HRbzlY9u/UkFrhOKWw57U1POtR0YbC//3PsQEsYJtX25lw6TihFX4TYuwSvR3dGFKz8wITovbT6MgXSvnCy7nIpek8UDdsuLobS7VL8bo25VkqqTfOtVVKKsfb4fACzSYFy0K0ah10QR0fe5VM+WnMu3y9CkX3tMQJr9kxnefa6r/6DQfNt/SS2zTqaBH7F4bHLRpFPgCe2bB5n7pd7j3iXckxar0EJPTvtq7UEur7AnSD1uZ5Y05s+E4XWr6fO02rRXaLt0j4pOwb6P1sqZXlPgte4uJ6Lzk+U1u6eNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19bbbf3-f865-49e7-a7bf-08de7942009d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 16:29:11.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6GP9IG8l1Ab4JCtZo/LvskrdAiL2n/td8XSdf6Ud/lIG3QVbmeUElYeGbF+VezgsdQ5/7Nx6949I7FoJlFDnkFtlAVK11Op9Hr8k95vDaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030129
X-Proofpoint-GUID: 6kkqDDUkSjj8pvnGlpkYJ-3C1y_Xc9HR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEzMSBTYWx0ZWRfX7Zh492MkCqsj
 pZLQ67iy83HXRolEKNmu6+fEe7Xq5TwHJLkaxo3/146g02Vq3E++HR95/ch/rXM/0RkoZNF7obQ
 15U1zquCdF1gSJJ8U+/QFfGTplPpCU4FNXJaMi551EWCdqAYz+fVQA9Rb+bNGsRxEi3cZmGaZpI
 osHC4ulW3DAxwX4e1BsvRlv2Fk7wgetFOHKe0oS+2N+vH3A/okpjZwS9zDVMTgJ6zoOUPLr0SG0
 6jcgjiuQMXiS3NX2Q5OhpYR8K0nEFGCS8odIHJPuY6Cif5IzngpMyx5d50vm4ZFOyX0gYCsE2Dm
 1ILS10uJNo5GWlEgcyClQyVddzCv/v6oSg+00Ka8kgkcaHDHaZbXsefS/lFkkMP8usTJajifZH+
 jiGS30ElaJVKkFaQJ/J6NcyC9/NuqmquWfhtNO74g+zyjHWfIdLPi8/4u89/jItID8dEny3Fb0C
 CCaOPjvlnZdnDmjDtUE/deBSkroRFvhMGiH4y40U=
X-Proofpoint-ORIG-GUID: 6kkqDDUkSjj8pvnGlpkYJ-3C1y_Xc9HR
X-Authority-Analysis: v=2.4 cv=O8M0fR9W c=1 sm=1 tr=0 ts=69a70c5b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=Whs9C5hi1pgmHJ8Kv3UA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12267
X-Stat-Signature: iu3dwcz8sf8rcwzko1mqfqa3sqhtjwry
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C204140012
X-HE-Tag: 1772555358-709788
X-HE-Meta: U2FsdGVkX18KTP8xWbct6n2GJDA8GCigdL2Qyh3qddinFZJc4qERSov9DEzkiKJwEYE+uEowPQyqa49WbBDFGadNso/vCiMmaaPQsntoF272cKgNUPc55U5EkCUuY/q35E5MnMH3wB/7A7RBJbsiBPbqRJM1FnpMplQ0caYWR87Ec1H+r4idA792TvJ+cxoVe/4VPaulLXJ8jzUX3FKE9aRTI/sScqVxmrZ1Zz9AKcgERo5AkNlsDgEN1xHgF2HwbaPog420YC8CgN0upjiCbPJ/U69r2c+080tPLKTf/dIMBINxpno5l1Ys5apyV2ynG6GvOTITztakPcyYxz6qEIdBFgdk5nDiLT0wUhWSLcGThmRLAIs3vPdUF4a/t7HgLaXbK2kbOy6HcOiICftmBUeYLEus/ANncDt74uaE/cw3o1JAlsc/CzbQGloutyH17aNvwm2opfYDYcwvhgkVOIMAyWYAIUbKtZFl4rLDs5gPctWb+j/58e5Kb4UB+s2s6pM4ZHfg0cdEqEnMRCKaR0nsQaHJjsEhC62w8cxdjNptKQxYPut+xffSTMYBNbvsmKH+yh+hpzhKBYLklUapkJcoyAZQnQpUB1UEqH6xRFkedaAWU4Fbhk/sVhoc9AivgzT3QdBUM/DZvIlFJ9ryvDtpr59KNp6CRFHyYou06kKp3ldW+9AwBKO5IfMHxp5s0DFGcGvwPf8jzpr31R9OlVZEQ7DqgnNTWzTMF2Zo2UCREJ/MJVtgHmjc0UqTFP1SXXE+6cVTp6jujBuCNDqgEVZGi0wonSuOMcAGkTFvOesL2JHo9b4C0Oo1HnpOF1OI7UaxArCutyA83H/WCBK2Navu9ytLSKLVRLQ6nB/NAD5TR1rd6aKyO66wf+8f2jei1rIZdoNkGWED3AjkwLQho7EfpYZjbgDi0a4qmgLMf/PYdlbffCGijaDg4BI+WOHCAf5gFcozRlpOjHlyhtN
 hwGJz5m4
 uk7/e7pwIoG3x3Jkt25VdCowh9NlzYmZnpjgz+FG9mYTADvbKyBcUFhqz4GUmGH2OdguIf/w4joDl4+kxk6BQF8IbDQf2bNlgz2drHu3NPxipWAjUW0mMd3l/CYn9NJLhMJARyXlER6Mgn52/PFWX3b4jyFuOXRo50xdD7TwHdPd4r7VfPBAm1zzeTl8yTmUojDfFS3b46iNmBO2nk+An3g6do16/T93wi5NHmUqWPQfjETIbmUX+h8pNOlMVarzVZkWK2AcNEtW8jYxDJ1Z3Uf7/5JPOi59UzyxmVtj/9QDQMEqV3DXeIuBmWncnLvJhRNaYUbRladniXwp74/k2xbjKBJAawklDPCx7APXsVhpFCn1IUiPFb1NwpOGxXV2J4Xkj6SP/TB9Dtq7UUczoXUVUD04shXBmidl2uTKAFa72WqI7eAzj/OPcqWEixCmgWH2hMIRG3/zZVT0dmGQmRDYwH9A9i7v2Y8Oa6DQwUmt/SRjVX3fwF7bnmCNlRUaXoqLBOHjJohZz1QVUahBhePBA5TOmXdWGG15KRnu/t8raJn5dja7oFSi9nLijvqOPv4jfCcZbS5FSAdbEr9rNrTGMNjOL4ktjHKRteLVpv9Eq1mFKFg1F0Ry+8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - to be clear - NAK this patch and anything like it from
Andi. Thanks.

On Tue, Mar 03, 2026 at 07:34:35AM -0800, Andi Kleen wrote:
> I would rather call it a legacy user-facing lie at this point.
...
> Thank you for rubbing salt into the wounds.
...
> My goal was to fix the old interface to not blatantly report wrong
> information. A new magical interface doesn't really help with that.
...
> If you don't like numbers I guess we can spell it out.
...

This is just rude and unnecessary, if you want to engage in technical
debate, make technical points.

Anyway, I don't have the time or energy to engage with people who behave
uncivilly. Your idea is broken, NAK (David and I have already explained
why).

Thanks, Lorenzo


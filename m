Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFE8E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 08:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79136B008C; Fri,  2 Jan 2026 03:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBC96B0092; Fri,  2 Jan 2026 03:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89246B0093; Fri,  2 Jan 2026 03:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1D5E6B008C
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 03:14:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D66AA8C07D
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 08:14:35 +0000 (UTC)
X-FDA: 84286312110.07.FE611DA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9073BA0003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 08:14:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rgmG9cMA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9eUANRr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767341672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHlx4HD7KfdBdJQBp0cVcOj2hf6cqjxjTW3Yj0tzhGw=;
	b=ptf97E+ASPMf2LQ+V7pp/737WSm7ZuBT1DI+z748biHA4bcpBV7zMyzZwFzYnUKi3Qm56R
	EUVvEWoGNuBTp3LhtQ96hzH000oFzFySEjDkFs1wgH3hirVWD2GPVHUnd9rPJeTWrDS0dz
	W6PODUwxG4a9SDvB+O2T6EXBUSpuYHY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rgmG9cMA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9eUANRr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767341672; a=rsa-sha256;
	cv=pass;
	b=wxmYmBD0Ttwn5Ay2lvukWpRl/DWAHw/waNZerq/BDpRiEY+5d5Q6+lN5f/FvnsC45Om+TG
	oGQm+KNMlNM1Eu77rHF7Urxv674ahau8OzjHCqXcOXWhHEucGIIRXzFDqDCzDUk0m+60nI
	FqbbmlEBQH2t41byYitzKDj7951LzhE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6023kTXq2273958;
	Fri, 2 Jan 2026 08:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LHlx4HD7KfdBdJQBp0
	cVcOj2hf6cqjxjTW3Yj0tzhGw=; b=rgmG9cMAIlQKmYWTo3e9OlBCjQj0RgTk0w
	iUxPi7VXZUcEnUX5iHww9xTj/voT+CK5Z0W19vV/b7IETGDe7hNVwU0dHLr6OtCb
	0GEn7/v1mxc3uXji+Sq8kOZ2xdeVxwgkSf7u5nfW3qsuzRXofRnJreN1111jRv0J
	Ibo0mLWBWXO1jjo5pmMD5Y8p7ZrcIgsesfy3fUF9O3T5DwFsydurA2DOykJhsD3+
	7L4ZIZbNuadzUQsmb+Wc1bGn4WWdbVw0lIqp9VjZnytQa+Ouowkq0qjIHj1qNhay
	O1Y0wJ1NnQECzWbQEJt987H7VXx+knNriglB8vif0q4lW9Lr49GQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba72qmtq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 08:14:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6025nX1t017296;
	Fri, 2 Jan 2026 08:14:20 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wdnsq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 08:14:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYcdL5i1NPnl1zDAQyVwph59/sNV0vgQ8EoOEZNt8hbG0c4XQg2rAOukM2DooAFYiO6dw7VjSenHF3X7iLmr1wq8M6CAzNNh45ACGpj/J13vlZwgn8irjqgdt4fRlbx/eMh/Cx2DZ9l5cCd8zTEq6RFdZk3Sq5ZaDQ5MSw7F5wrfNgYiCpXU9KfAlJwcJWNwzZHh6xQsehYax3OfSMgaUWiNuManQrqrXykWCpR/1u3lfrMkhCnuwrtGDZ7dzqx5v2Xlr/Jocl5EWFC72zOENPmIKU38MJ9tka9Qmsa5EfKZvFtVqqoEBrOu+qJ87nVarY7dbWIAGYCMjRi70UZ8Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHlx4HD7KfdBdJQBp0cVcOj2hf6cqjxjTW3Yj0tzhGw=;
 b=uaLLScFuu1o6ihcgHRW0GffbGToXbBQlC9cZsajiGFA6tbfSuxcoUlK7dXUqEwLYUP7siC35eOkiEVa/96hNRw1e86bcM0jFwTR0y4I1kf/gSndkaqyYaCi4VIXN8bb5p4D7Md47k8TMrd1xNFNQW6gXhKpZzz/UAbONiL+oN5Fasi5ShVczHkln1H4eEC6KLN/WKXkO6PsrxrXxjjVe12Q0AhUeaLGiueMkPO4isFuXEJounj0b9eDRgHZ6QcWD2Kok3QpopsbB2iDuoi8ae1++Cvg+oh4ETxct1AD0TVNcG8Oy5YJGDtJ0VEfxaV79JMYDMIB1Jpc4uxl3qlqerg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHlx4HD7KfdBdJQBp0cVcOj2hf6cqjxjTW3Yj0tzhGw=;
 b=U9eUANRrlBLsWuQ+A7osTvpR1eUF+K5u0MNZRKRt9rVOO4En7r1Ch67UTfpuPhVJt82u+PstKl4py4Wjn9MjFNp/Ex5PVYhNokHFAf5E7ma2scoYbrSn+Nd7Y70pfKmCGWPPgpJFb5rNPCJmgBaDsz4JyCT3rbDGiROtSZRIGn8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 08:14:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 08:14:17 +0000
Date: Fri, 2 Jan 2026 17:14:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <aVd-UZQGW4ltH6hY@hyeyoo>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
 <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
X-ClientProxiedBy: SL2P216CA0210.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5622:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9272dc-419b-4e77-eacc-08de49d6ec47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TNpOmK/ZvURxBhAu7gvwAY91y+MO3vELUHD7B6VW7Zx6BbdDR7XG5TahEedd?=
 =?us-ascii?Q?qptje3xLzlrRa6k9m/XRzWEuf3ZMQQeeMf4DOsIvBX5ZNGXqrBtderhFIbSK?=
 =?us-ascii?Q?A4VoK2zqS1WLgftZyfWMbhLkO2LCSgJbuCnJFEw7BU+EAzDNAwjjEC562nwC?=
 =?us-ascii?Q?RGpYj0Q6BTXinxIr+sJabKwlCON5V/Rp2+juUrl81lISv7fGgE6AS+0MApKu?=
 =?us-ascii?Q?+nyw9k+wSwe6+j4rw1RkTXlWoWfr3gETV2zp3O5bqi6aD1UMS/kOgkqa1tUF?=
 =?us-ascii?Q?dpGsxOVEHPpgzmfdG9NXUk/3PXI7sY5SLYtvqOLpXktyOIhbDUI7kit/GhH1?=
 =?us-ascii?Q?TOegJXCpo8EpggBJdJhKWIMUhFBvHLmxiTP+SsGqFg7Bt5abTII6y9nEdW3r?=
 =?us-ascii?Q?I03n8AhNesQ19CxyugWKYRGdunsQm5/MARhYtFJe+KKnBuksS1yBiz0wEgCA?=
 =?us-ascii?Q?5brnDedoqV12v3eiVdnUKBjtCAVTnT05AOX9/qtI+YKroqc4aiY0PtskajBI?=
 =?us-ascii?Q?JKr9Zr8EEl2QxnPNelcaY/zYYWQhm9w+xbm9VSb/1NTvSeK54fqVJU+U1y1r?=
 =?us-ascii?Q?xdHJGh8BnJAEVZ4Tc0LuTPWBuH9hJabBcmRi0omPsQNDOFjoLfEdwZHMc0lB?=
 =?us-ascii?Q?UUCbf0ISRCZlVV7pA0Sz4txwgm3vHM9e+kNUd1aJnEXFtl9S45jdn+ILONZl?=
 =?us-ascii?Q?lg1T4dqWjGdIZQoWj1pNLx3vqJU4cx7hGEouvvgnhxWEoucrobD7WfRF2O3k?=
 =?us-ascii?Q?c+lQ9gcGv3KpBvToVu9d1PkyzGqbzWJthEpWEqvWhiRwQGEfRu6L1pwwf6Hp?=
 =?us-ascii?Q?OEP8Q5mSyyU4rYtGM3k+7XJu4E17/vkojkw60b9b+8naS9etFHiwsgQo4v7t?=
 =?us-ascii?Q?e8CdbkllcRkaOpfIqEPi2Dqiw0H7W0ceT13dIYKFY+fdWZ8Y9jJr8PkP1E2E?=
 =?us-ascii?Q?gcf57txp+VuPK0LP3hCoHQMlPHHTuyEYmo3X4VwEWc+h80Qamp3KB6JRDszu?=
 =?us-ascii?Q?tYSBcvOj/HA3Rr4HtEAQqqPLkZWysjlQVK2IbbTCityckjSrho/GqbGnkt5g?=
 =?us-ascii?Q?gupgoBYHgNCoqOa3IdfyGUVCpeiYy9KVg+3T51jjg445VB1aK2IiX5PL7osO?=
 =?us-ascii?Q?fPkIEAxCuzV4KtaqS9ODR4KS10iBhM+VMVx7MlIhuFz0mrzmnyvmb6arQfHn?=
 =?us-ascii?Q?UZVD5EGRwX43TSyHZ9q4csdoK6bFAp1UW34AL1/BENgmmuSzQjx4z1ycOAuN?=
 =?us-ascii?Q?kcTBMB7KiqnaC2qfRh9KruxJ2sw31Ua58oW9kLSJiS4HIPSaRzt1xKu5xrId?=
 =?us-ascii?Q?f7Ih0ppLttwFY4tJPCPHCpLZve+H2007n9imOujk+2nmRf7dJ0gsOOh8c7MF?=
 =?us-ascii?Q?PsUgrDvxQnYnfERdmStHgabk84ukI4OwQAPz1HWGvQtOL7bFslTjfGnLa64/?=
 =?us-ascii?Q?n2hl32ivQQUCI7ynB7wEdp1gjYu6D8di?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uYIATYCbw+kGR0gxqlA3oigRFeNz68mMEIWkAPYbY9vhsNCLHrkhJFinDTBK?=
 =?us-ascii?Q?qnN/EucWJ+C5ieCUHCpF2unyhBiqzwJ6fY8ZgWW0EpnJoahC7KVUHwZVY25O?=
 =?us-ascii?Q?6WIfuVkCugHdls1rL9d/U51Ln+EMsgbxyXlNTppbNFxzUA3OlPQA4bFEq0Ef?=
 =?us-ascii?Q?4rZvNkxdlwBYiB/C5hqSrRpGxf/I33hoIQ1LYbhmfE6N27WhjvWhhciUQ28j?=
 =?us-ascii?Q?iWggHZgguwBIqStx232PpeqFF1GY2UAmhomLNB78YlwjtFsR2BFsExPaQLg1?=
 =?us-ascii?Q?VZUHQwzHlEkAchCumpC2ERdYUqMOn4ga/ermReo/sF0xsud9XpWvSC2Eg2n0?=
 =?us-ascii?Q?tJ00IdSJOJtQts+sBUWUHnvbUynoU8Kbdsj1xpjoR2/Go53glAzZWUYzRv3A?=
 =?us-ascii?Q?UlASTjR62ZfCkq8QOJow/W2zaeRpeN4lqcVqSwsYWC1Jhwscb3pawUHVKwSq?=
 =?us-ascii?Q?kK6yBpYInxx/YQTM5YizTP3nksKVqYVXbWvCIdI4kxUmuWJodbZgnh5hgsmv?=
 =?us-ascii?Q?ssD2e4V5VHcVWBw/gsxsopQZnaTTVNTJHrjusggI4UYUcLd6YVa/SQeak41A?=
 =?us-ascii?Q?Gk6r3Q5S9Z0OUZ5/NNm2l+5szrq/C0G2PHpAFCF8LuUbpPj98kAtQjvk5F9w?=
 =?us-ascii?Q?04kkPd9387DZ3nKiNVRWjyRHZPqtPlYM71VQULvhrtOGvIYiRP61UaO1eqes?=
 =?us-ascii?Q?w9PXELq8KF1pc9JUVHRjTxB/7QMum1I1bBJm1xiZaunoECmZK/I4MKhVJrzW?=
 =?us-ascii?Q?j3Lit4NzHsqr1JmARLbJasnMwmGuA8DTweCTWGNy/nfPKhZ4B82K0GhC4kfY?=
 =?us-ascii?Q?2Mvy1gZa7Q/alnK/lZthyi3vJ4dNRaGdx5xjj9Gj9ZT3tQ2Eb5OyVsUhvoFh?=
 =?us-ascii?Q?cRgwQbXLZAUTR9NVk71kqqK+aEWI/AvjgrQjOv1xgU0yMUVz1bEB8mHRI2Qf?=
 =?us-ascii?Q?Ddz/JwE4RV7/IjtmAo/sY9gWbQFJNYX67xHEUErBSs7nx9/5pf6fQPicVdjB?=
 =?us-ascii?Q?Ul/v3f0+RK5tregpOu5tCqeBMduHJQSI5N2h1Wbv0ra43gEhqJ9sNB9ysV6I?=
 =?us-ascii?Q?Jnk0XYQyAh6/A9CTl3XLWBO1mTaw7Hdq2gKmrEIEUf391TuGyZi2a/1E6nKT?=
 =?us-ascii?Q?v9k3JPMdIY7KT8n/oSr1t2PviZ4QXcGb/KwO0TW7v3W3u2Kdcy1EzM6DwLYT?=
 =?us-ascii?Q?+Ux6dFMGplVPAsGjruMFwOnJRhepBIX6iYkkQI5DpBCHklDxfrWLc1k88zhe?=
 =?us-ascii?Q?THQiU4q/eiujfW7Dp/ybNQN0rkWZnr1+WX/+YN6prRSvQqLpHnUK+6x31YVO?=
 =?us-ascii?Q?0/CU70beEK2hQIRkthS8S/BjAo3vfkiIHFJo3vFxQJQIpbJfy1EbPvvCCvke?=
 =?us-ascii?Q?V2HNF990KgZgTL9KHhETqye3/6QMcJ4kauQOqQfmEOfub3nnqA5gGIXeCm7K?=
 =?us-ascii?Q?Fnv2MkFFgGUmm8F7VyaFBxPFoRipjMMn8luX6RXXGDv0m3gXXKVSdEu7bUMW?=
 =?us-ascii?Q?cmE/36BD0uMPGEHZJCMHX0oZmWBGKhh4AqDTAUICqeSXDxsZlR4Nt59QAADa?=
 =?us-ascii?Q?m/LNTCir6Le7RzLdg0OgArxLJfg2xKIm+U/ubebudjIlADUlXnobl5sRFh/e?=
 =?us-ascii?Q?9yyaG/3BiKp5fLmQ/3R6L3AC2Xbo2oyZaQH3mUq2tYOgh8r8V5KAgMREmaUQ?=
 =?us-ascii?Q?GN6NfXiLziIjLxp+7eeDttsaAYzIQQObthDI0WcHypwfkaNlN/S9M+c2QqJj?=
 =?us-ascii?Q?2c4SHg09qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ElHLSShkfmtac7c2uN97Y8MacyJEIKeSfLFA4QlNuJgiIwjB86LcE2D5HfHrwY4B5ydquJRznlACNGP/0EKIUFujG8+LTN3aaLytmDd6/alzhDla1rUBzEAWM92KYyPOEKLjxnl/+sw0yC5GXe0+cncr3xoc6kLdD4yWRVtfMTB5BXOGYHYtG0SCQEJdWLcF446P76+GhGBkGZJjM2PviizJku8Z1TZAVlQ08Vsvpn0Jbpo9M3/34oxR1H/YJPCzd/I0c/5DdctlYTL4VnmEhxwfmZoP1QSiORWP4cPFVg7N1c7Jb7jyYobZtkEa66kivtZX6a1K+OvuxBJNQwEBuVK3i076bTIbtODQ0YIS0TJP2AbWmQdAc9g5xl5et30VHxHh2DwRjkMu9D821l6jz0VqCuvBLEWL6jphh8N05nLTcNiqtPYmhwkG1mBfHajXan1LlJgtusKYkXSCGA/cN0XlaObMd0+R6M7x2Ngf3Cv8D+eJ5buNNb3l8Hd3fRhV7OJaNHaKs1+8QXuYQJbyQ/BhAwg0RbPleqwDjisNl2gr3hb0q9CjthWSk7N1WLxaf9gUGdEwqxlxp3XcZzlol7VF+sptyUuMVTT5bm0sxBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9272dc-419b-4e77-eacc-08de49d6ec47
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 08:14:17.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJgKXNrpnFHovBgifmTBVL4aRU5MMcrMsl9QIgXe+PcfRNJT0f168o90detTd1ugz61YLJ6NPIJyI/GLIirfSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_07,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=859 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020075
X-Proofpoint-GUID: FDXJ4AV8la5RXpFHVyTmcQcZ0iX1hL5u
X-Authority-Analysis: v=2.4 cv=MqBfKmae c=1 sm=1 tr=0 ts=69577e5d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wJ7CdwG0gArsw4Bg33cA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: FDXJ4AV8la5RXpFHVyTmcQcZ0iX1hL5u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDA3NSBTYWx0ZWRfXzKJsy4XK3irC
 shx7DUHeBWDf0+9aZ/Fft1zG6/s2ca5SvufdS7zykOJvu9gcx/ZTFhO6iLGw3jbnVTjqKo+ptHy
 7zPyEgOypshPRkWtB10Y/SQ4kLKmQzsNeytbmLYUpReStOl49R1+nGfCpwUM4PQwtzIyZmhAXMc
 Fum8dcJuvNT+N9xxeYCBwxHb1X9n1bWhErXHFQfhfDzxt+d5ocyR7NI1CZbT1E4BQH0nTN0EoLW
 8ia8G4hE0MOkyJ1Ztf/S3r8ycEpZ13a7MGccPAxoxG/XM0n1HZcjShCliiEr+P+SPq5RGaNkfnX
 gbr2Qz8zP18BSK1fTds4SbmcNcLv9dX+Vs0idOl+fP8MzLudksseUYxQGL7FqLUIubenA5AudVd
 OCIEL9rqu7/9BbwhnOJEl6gXm9vcoDdnn3CBo1CaQLdk29SxXwaSeynimGY/2EmdfVjgLCFU4TN
 CwhV06E5DwgYmrYWEkZlKFYBRWzUXQCNohRIx4A0=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9073BA0003
X-Stat-Signature: gsgtngop15ioz4wz18tsngxdnsq6gyps
X-Rspam-User: 
X-HE-Tag: 1767341672-381559
X-HE-Meta: U2FsdGVkX1+EBaN89EHEGFHKUSoAASmZus7hPsRHhZL0H6lgOlX638BJb8sNyI39SjL8sMFjXFk9VQYDG7Q4AF3KK5xdKjn/oj8k5/m1QuhwZJmHJqY1P83HPrM7bNoK6Zckglb6gCQRsnB9VmjmXXl78g/3qFkDQo9LDRX/0rBkgmCs90MYRK+XkbyVklqp4/K5miLj/3pIaWlIc8iJ5k18/FaxG0/E1jdkPz2z1Jq3PTnINR8VAXFjiBivNRbzxGF/ezTrGtuRD2tFkg1mJOzaUMqGUFSu8ys+oKvLCP7sDD5SSOSeNG8R2grJVkCdT3Vh+IfaOLWJrzQLfcVyLWz4kOzWLJF9f+C0/+g7+owG4gnE9mnIiKbL274JxtMhRStuu7x5DizNmbVkIOUKh8f0WSZpq3L60eZ1syId10yM3DIYkzt+uKtBNaNn9mL34rCZOjhDiposjQGziOU3hprNwP00JLS+vvefjXt5oK+VfMkKARx+/aUGx7Lx6lPnjcEuNFarydrt3/zrovtVPJUcG/Y3G62ozO5AjdHt5a8GccxHnCILJJq5AsrDJsyyyGrO7cXXdH3mQ1RGIl6Cq5mdTZVxJjgs+cPloFrIefIx5BL2nE45cfiL0j8go/iDFTFrJcDZ2TjcPHrB+d4d8cvlsFNhwAHHRmH66j1MjWOU/J5XvYQB98aYrlfVCVHyYvXh/PprGK0fDdpYb0xenqE6NEkPafWfwDMZI2yGr/IktlFIpRH5Kv+3HZjRX60AV3Ynz4PZFvM8uHH4Cs4keglzJr+r42BSiImC+AUvXvF/KvL9f0IGISxJiJUsz7ymcJqCAcpZbiGqq5Kl5JRt7D8rC8J6r1IzzF6CkABe/TYb2Qv/nhkvb98j3BaohkGf3KmcB953MKaxr/GfCt8CjkMXHJ3KUdENtqQF2BoQsfYBN2qXSnifahgKJ1Z0vrOOb0ttduRjI5vZVQiW1lO
 8wvTEpKt
 jI8TtZTX65yrRaVgT13gQVAkjCceqMEVKyjo02S7iRXSUPXgRs6GVfWrAx3YkkRmfGkxvbG8cE3kI4FG566fQpE4wgzXw6PhpAAB+sZ9MYNjfKbUI031ZGuK+ZX3mkitAKY2tEKO+QaINzxwaKgq3QXYZQjIy8FwSZw+HY6+Wze9mxgvzR2c6YaCe6wY/r0KJc3CZXJxKzrDGWxCOXGS00q31AAX6Tcy5xxIrkO7r+CknOOHVCdWXBT4sHJfSSPlRlmrKRlp6XT7zVHONR6nsG00pPt98m0HCmOhyJjBKUibJ9cMJ82aUpMxiv4p5UTIstcgO7UWJ8u/Ye95A43dYj3shF1LnzePGGZ4fn5za7l581eHVu2LVr5cXe5Tt/9o/fiA3LP+J2Fjk3rwbJp+9Mc47ZPLI4uCz0XFPCBlM2Gjc9eO19eJdbMgv3Mv3eoNXVFOfHZRcHfecmJS9T6NxIcRYj13FV9YLGXzqVqzKq6WkRwCQNc+xTEUFKb/dQs7BhfP1revAYgNzRc+xb3MpyK4UVy8lKG7FwZki0puZA6QY9awaKuauqZKddmimTihA4CBAFxo5nZhCsv22WU5pH6dBZjoDoaTrJfYBd8RuJUqaUhiZr0b/aTO6c7rO0wqMQOS5+ZsdEk4P+d9IV9sd8THrnlrZv3VXYqzOKWObCmCP5kW7YV3LGK9lY71EfbNOLKCz76f2S9ietzf8eFS+p+D3k77wDpGLt+qFZVWPsCPGRVqCDl63j39tQmNj6zAZoj8JOgWbK75JgyKQdvnY70Qhy9k76q6FV9HAtuiJ7VwS0/7NAycZq/vMjnT1v9LcWnoCLE8TKzidBYXinmtwu1qNivWDsQLslaGJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 09:28:46PM +0000, Lorenzo Stoakes wrote:
> On Thu, Jan 01, 2026 at 06:06:23PM +0100, David Hildenbrand (Red Hat) wrote:
> > On 1/1/26 17:32, Lorenzo Stoakes wrote:
> > > On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
> > > >
> > > > Based on my testing, I found that the WARNING starts from commit
> > > > d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
> > > > which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
> > > > populate behavior") in Lorenzo's mremap-related patch series.
> > >
> > > OK let me take a look.
> >
> > Trying to make sense of the reproducer and how bpf comes into play ... I
> > assume BPF is only used to install a uprobe.
> >
> > We seem to create a file0 and register a uprobe on it.
> >
> > We then mmap() that file with PROT_NONE. We should end up in uprobe_mmap()
> > and trigger a COW fault -> allocate an anon_vma.
> >
> > So likely the bpf magic is only there to allocate an anon_vma for a
> > PROT_NONE region.
> >
> > But it's all a bit confusing ... :)
> >
> > --
> > Cheers
> >
> > David
> 
> OK I had a huge reply going through all of Jeongjun's stuff (thanks for
> reporting!) but then got stuck into theories and highways and byways... all the
> while I couldn't repro.
>
> Well now I can repro reliably, finally!
> 

Great! still not sure why I can't still repro :P

The most viable theory from me is:

When we call mremap() and move VMA A into new range that fits into
the gap between two VMAs:

[ prev ][ new range ][ next ]

Let's say prev and next don't have anon_vma, then
we're supposed to link prev VMA to VMA A's anon_vma.

But looking at vma_merge_new_range():
> int vma_expand(struct vma_merge_struct *vmg)                                    
> {                                                                               
>         struct vm_area_struct *anon_dup = NULL;                                 
>         bool remove_next = false;                                               
>         struct vm_area_struct *target = vmg->target;                            
>         struct vm_area_struct *next = vmg->next;                                
>         vm_flags_t sticky_flags;                                                
>                                                                                 
>         sticky_flags = vmg->vm_flags & VM_STICKY;                               
>         sticky_flags |= target->vm_flags & VM_STICKY;                           
>                                                                                 
>         VM_WARN_ON_VMG(!target, vmg);                                           
>                                                                                 
>         mmap_assert_write_locked(vmg->mm);                                      
>                                                                                 
>         vma_start_write(target);                                                
>         if (next && (target != next) && (vmg->end == next->vm_end)) {           
>                 int ret;                                                        
>                                                                                 
>                 sticky_flags |= next->vm_flags & VM_STICKY;                     
>                 remove_next = true;                                             
>                 /* This should already have been checked by this point. */          
>                 VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);               
>                 vma_start_write(next);                                          
>                 /*                                                              
>                  * In this case we don't report OOM, so vmg->give_up_on_mm is   
>                  * safe.                                                        
>                  */                                                             
>                 ret = dup_anon_vma(target, next, &anon_dup);

For 3-way merge, here we're passing target (prev) and next...

>                 if (ret)                                                        
>                         return ret;                                             
>         }

In dup_anon_vma():
> /*                                                                              
>  * dup_anon_vma() - Helper function to duplicate anon_vma on VMA merge in the   
>  * instance that the destination VMA has no anon_vma but the source does.       
>  *                                                                              
>  * @dst: The destination VMA                                                    
>  * @src: The source VMA                                                         
>  * @dup: Pointer to the destination VMA when successful.                        
>  *                                                                              
>  * Returns: 0 on success.                                                       
>  */                                                                             
> static int dup_anon_vma(struct vm_area_struct *dst,                             
>                         struct vm_area_struct *src, struct vm_area_struct **dup)
> {                                                                               
>         /*                                                                      
>          * There are three cases to consider for correctly propagating          
>          * anon_vma's on merge.                                                 
>          *                                                                      
>          * The first is trivial - neither VMA has anon_vma, we need not do          
>          * anything.                                                            
>          *                                                                      
>          * The second where both have anon_vma is also a no-op, as they must    
>          * then be the same, so there is simply nothing to copy.                
>          *                                                                      
>          * Here we cover the third - if the destination VMA has no anon_vma,    
>          * that is it is unfaulted, we need to ensure that the newly merged     
>          * range is referenced by the anon_vma's of the source.                 
>          */                                                                     
>         if (src->anon_vma && !dst->anon_vma) {                                  
>                 int ret;

I think the "src" is supposed to be VMA A that has anon_vma,
but we passed "next" that is unfaulted, so we don't link "src" vma to
the anon_vma because both "src" and "dst" don't have anon_vma.

BUT we reuse the anon_vma anyway, and by the time we call
dontunmap_complete(), the anon_vma gets freed because its
rbtree is empty (which isn't supposed to be empty because
we should have linked prev to the anon_vma).

Does this theory make sense, or am I confused again and my brain is
misfunctioning :)

>                                                                                     
>                 vma_assert_write_locked(dst);                                   
>                 dst->anon_vma = src->anon_vma;                                      
>                 ret = anon_vma_clone(dst, src);                                 
>                 if (ret)                                                        
>                         return ret;                                             
>                                                                                 
>                 *dup = dst;                                                     
>         }                                                                       
>                                                                                 
>         return 0;                                                               
> }        

-- 
Cheers,
Harry / Hyeonggon


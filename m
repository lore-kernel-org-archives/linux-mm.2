Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDD6D358F6
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 10:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3B36B0088; Thu, 29 Jan 2026 05:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961C06B0089; Thu, 29 Jan 2026 05:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE7D6B008A; Thu, 29 Jan 2026 05:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 682366B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:56:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 247311A0277
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:56:38 +0000 (UTC)
X-FDA: 84384698076.07.C62325B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC2494000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:56:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikpaMtbj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mMjLq0m7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769684194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NK45DafQe8fLsFXm+hUWq3Cnc/Sw6ktFp7wZYBdiNU=;
	b=wk9l4lopdC1BL70t6hFpRSw92IvXIR1GQK04NV6Dj4s8l9HWkGE8z/xHXRiKHFmysjN5VD
	Hr/K2Iv9C7jTXBLPfnkJdY4kOzGeXZxYjaNuoUocJttUdn6EFhYGhbRmpl99N16YDBPwNh
	SzvTHXcbsXKPIrqf4ZqdnbtQB7c5E6w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769684194; a=rsa-sha256;
	cv=pass;
	b=w+G2sFkl9O/4hLWRGO0rUfxwpy3gB9uws4YNrAcf6w10+eWjsHgenlbKJHosG8ycRsj601
	hJAbSWFI6wijNdljOjQrwlIcoks2O72LbpfuFr6x7F1rC4A9dnIAfhp3IWmH4IVcsuS0mI
	mkYa4SeV3osZ6ahyoq7GWYw5fTyLwQw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikpaMtbj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mMjLq0m7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T2f5q73795419;
	Thu, 29 Jan 2026 10:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0NK45DafQe8fLsFXm+
	hUWq3Cnc/Sw6ktFp7wZYBdiNU=; b=ikpaMtbjV9RxSl3uRSPhluWmEDWeRZtHuY
	FgawHoUPgDtK5sfClEHbT9yoaQSuX6+pRxBBEr2T4ZL1xuehrsgeYyf5CmkPTAQ2
	m6bvmEcFD8udR9m6lU2jC6XdmKtQmyZW81A/9hV+fMkEv+PGHd+HvKWNcIxDoRf1
	Nz5V802avFrjBl7exRfyAagsDFdu+9iL1qcKPsWn+3XOeASFQUsWCzLtWucdrkVJ
	50maA2PHFsng8DJ2JX4pgaRPolO7iNZA353FHwoy7RsqeTKBLaUAVZssEqq3v211
	Ka2sa6uRigdljS1+MVUHM6BedIYzmh/MWrTkknTfxlg+RLRLt12A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgk2je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 10:56:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60T8lnsJ010031;
	Thu, 29 Jan 2026 10:56:29 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhc69n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 10:56:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ohpp5PZ5I/87slu40x26q5n36osmAvCtrogJmUq9FeC/L7XN2XD4fDkG9ZKHo+vuMINPQFWtqhRnJByB2oI/ayxrfT1uT5cyyU4zEwZgJY5PfrK/lmYuH+mwGuGw7RLcalI44BwWoJzWHjVbIjEpAnj6inBmgyiysV+SGwr27KUIPTFhUpNEEmCZAnv0HO4ZJ91nXLbh4sXeX6dOOO4xCE8E37Uh9EmobJMf4CIqqzURHj9WAW9/HlUnX7FErYTKtGMapf7W3OmtuH7xDxtsFPT3LBLbR3BU7JZQTrVUXVgjbxmsjErNFhunphTR87pLZacbF1D7R0pj5D/CIbIlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NK45DafQe8fLsFXm+hUWq3Cnc/Sw6ktFp7wZYBdiNU=;
 b=oHVSzkSZ1o+3R0JllRUvBraZ40r4iU/YUTXlJd7xIesO0OXyUVEp6NARrk6pZtKspBZsvIIHB/UEOIW8X8bZOqZph1dEUQNZuBA1+/Ozu3hiGd4TWg9wuclqWkfG5GY/xOiPgEgDNC6Gm4yVlU9M4b5zeHO44TMIYB0sgCm/tioadCxhxdFYmDeo6AdEk+aAWSGwsu3OeimaGlnZ6kx8xe9h5jfrLiZ3GZjaBd6ea+SN+7pnAv4w9e9HtZaq544cRsypUlWM8hW+7hUPUISCJJ1vgjT9KB+Iv1GzOaWBHS7f1o2Op24SMUCghgtO5vawnQ/ygaIEf2KXEqUw9T7kbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NK45DafQe8fLsFXm+hUWq3Cnc/Sw6ktFp7wZYBdiNU=;
 b=mMjLq0m7jCXnwKdMu60uMQr1WWpA+BhMyU5kmEbjoyN1ezcTO/3AuYJUdfaJENQuqjSRn0r89GVfuUs8dqy9gwnb50g8lOM7ZVJl8s3UAuUAqZzewH6NmB5l+wqW9WN5dUDbwYDlRem9f+nV/Fi+uvFBVDDUHCM1ozsI1dBDTOM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPF9C7B9A88F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 10:56:26 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 10:56:25 +0000
Date: Thu, 29 Jan 2026 19:56:19 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] slub: avoid list_lock contention from
 __refill_objects_any()
Message-ID: <aXs8074bLQqz27qP@hyeyoo>
References: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
 <r4sorjw4p62mk2pvnjfrfx2w3zmwcz5yuflmcewll3jsmpju42@dniauu6pkm6j>
 <aXsoxRXloFrvmOEL@hyeyoo>
 <00e257f0-d80d-408e-963c-7962a1cef9d8@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e257f0-d80d-408e-963c-7962a1cef9d8@suse.cz>
X-ClientProxiedBy: SE2P216CA0144.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPF9C7B9A88F:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a48ac27-fdb2-438a-2fea-08de5f250c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w15Nla4LP//8AIn6oRD/M2JNxzlII01vz+ME7kgkuEt7BreQHhQV+9pwc2EF?=
 =?us-ascii?Q?e6iwJqmVOSgLkXlZJwO7IzBmnJBxqyD2aGuEZrJugTv2+GIHBjylSp2gV0mj?=
 =?us-ascii?Q?eEJ+xjOfN5sNt+CPpNraZ/AdmFXvC0ZTYVCBDqe465jo6RoY7gWpIKGDRMyn?=
 =?us-ascii?Q?gU3lZngNO6MwxBld2+fALkQduSpViHqXpq1rHGwFz83X9YQLpMaW41uSbiUp?=
 =?us-ascii?Q?QYjZIP+W6hFtRwhuK1azLiPD/rZQwAYjz3XjIrbcOEPnMhF1PH0KiUkDGYN6?=
 =?us-ascii?Q?aa5mILXNJeVqcwLVOu5DQ2rZ7+JD0eKJpQG6v6kcjqvTRo+8FqY9uC4LY1FD?=
 =?us-ascii?Q?v4EaasqSfh7zyfo4q5yLMkc3H43GSXZi93YxBI7TAeh4h7jpsq2LDdl7tHdR?=
 =?us-ascii?Q?5qGqZfg7o6JVKzj3RvTd9qtsAA7sOqtywpqH21LtOO8huX9RsOB3j0mWGZJA?=
 =?us-ascii?Q?vRvfkucD07SELjaDZilh6EHPuzefwpJ36/qt1Ze1nyeztaB6fHmUNaCHn9b+?=
 =?us-ascii?Q?OzS0d0dyb4OTm1FXw1lbSlR+h2YHP7zNIvrRB1vSBkBG5Dcf6O5DMTIdYNXX?=
 =?us-ascii?Q?JL37RHcq49FWeZYAC3VZRXRmyYsnfKqfLo8Tr1zP8zvGP9BOSiOmagPVJeQb?=
 =?us-ascii?Q?4tDzlDol6v6bWFYsTMdYFEaj1I/V4gHoVU4k+lKhHDfnbdfLWtwOanSv0tNU?=
 =?us-ascii?Q?vQazzfSnXXftWYBnnDzEz/YiOn2xzZZWYlEvh/FZb8oBTCVf7xzIZYCOIaRZ?=
 =?us-ascii?Q?7BbtKCe6NEQFMweecLgEVwNGb4E8W1ZFY66c/UQoRPBsgAh2bEFAIDmQFpe3?=
 =?us-ascii?Q?SNHZ/3OLeeSvrH+XzTigKP8eHH1JVGp8xl/9AHfSp1hMo8Kk8JQw4QfRcMlT?=
 =?us-ascii?Q?H8PdBopUKpYvQzomN4dm9Ie0uNUsbUXVsFPii68b0V//wSyLwIgCE+qXRtWO?=
 =?us-ascii?Q?hFKvuld7X38hG/8O/sfjlRbNwCfIGaLUAaZjMJM//hg8ayuEje6gs8K7iIr8?=
 =?us-ascii?Q?FqWSTHDsBQ7fNWfBVAkFXzlkxh4krFnncJ/GYPVtJf1uMjezIXrACbG6Zqfc?=
 =?us-ascii?Q?IUcirRNMq+I1GHvSkEY9kxC7r2X1tkJCipmRDMNjkoWQqMUUj36MQaKYZu/7?=
 =?us-ascii?Q?LX1DVYAQ6GXYapzKxR5SJPEoE/6yoCiMRhEftEoF/Qa47hnlmQ3isoh+mFQq?=
 =?us-ascii?Q?s/GY57Afdn8QS8ebowKsIOlGgVuH3c5/2J8lTdAiLZDF3P4tE5xJ5a35w6V7?=
 =?us-ascii?Q?KJY/p78cns629xetqXtADi4h45jZRvbwhfYqaCGXrFErxftA7EAerQa1JiDj?=
 =?us-ascii?Q?M9eLWtSmRLL04ewHDLkyy/uPi3tbugXBjJEJ7D0lau3wAltzXPWgHX7Xz3JV?=
 =?us-ascii?Q?Hgfn3UKa5QBU8NMxunBBtS9fR1ZDchLlrQ/Cs3V0yXV7ytR1V+qiEzFUR/3W?=
 =?us-ascii?Q?wJxOUFiF0FiE3Ql4LWaT1Qt2VGh1qV59U51DvEZHS1nvxjlvrVGvqPo10QhX?=
 =?us-ascii?Q?u+k1sYX/LSkhp5+/lJfXQSB1zMnpaa5L7/bu0Ds/yVTJyHRr27qmXW/1NsFo?=
 =?us-ascii?Q?qlYbAHT5bncbkqVN5qP6mEDPoSUUqKCki2oCPayN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q7rZ/S7D8YBnVYsTQbqDGqCRIvDcLZgrQhEoCo/SiUbziUQF7IPQxk1aT7KD?=
 =?us-ascii?Q?O/m5sDLyNRZY+VCHGO6iz1tHAQSnB56IUmiWMP37syhdf5h40ugv7+Ao8pok?=
 =?us-ascii?Q?Bo1N49J8sDybafzyDzun7wNnTA/gKE81GDTD9reiUuR1Ltoiqt5CvBqeEf95?=
 =?us-ascii?Q?uGnUtrHBATNZwmSF5kmR+11z0dizfg55OOEWEKdhURbM0ZjTu8d8ot3n0fj8?=
 =?us-ascii?Q?QdHdgXgaiWcfb5/z7kOxm2GZySQ77tTalenrJs3H4+3llxYzEogFPaf+YqlX?=
 =?us-ascii?Q?A9iKyH0zJFWhp8PH4BY/Fc0r5HQ5KlrmCZXZCByPMrsuZNEocYOznNJUclqd?=
 =?us-ascii?Q?hUcNHQS8hsLz+64j7pmMngV66JLcEhKgJdRjrh/DDOMbunQXongF6GDIxNGq?=
 =?us-ascii?Q?mof9/hKoDraIKSOy21mbflsVCnw3Y32tFRmRtdH2CFXVkAgvRGqv4LE6TsgC?=
 =?us-ascii?Q?YeK5TvfxXlYYMAR+F4I1XZHF8/U0TA+uQGGg4fp0AAVTNEzKGNhPgQY9lc7R?=
 =?us-ascii?Q?0CP/KnLXyX2KIQxlET92HoFV51eCP5ORnxDix4DzSugIlGp3oqfQLWYeuAWo?=
 =?us-ascii?Q?OD1fquuqYG20QWF9KcTDW8GXs56rhZBycSrTHngiP9vTu/oDVUFw1epxYTdX?=
 =?us-ascii?Q?WAMnEntbrSytkSBPS4EAMiF5fEM+v9LqLOwmBPzHnVcxIbrg5rPyRs5G0Yr/?=
 =?us-ascii?Q?qWmjD9eivoTEtXynH9niCJfdF2YSvBgAWPVnVtgRcXIz7BktRUAmldRa6F7d?=
 =?us-ascii?Q?tpAPnSwXyiewP8rkBApfhovb179aOpbtB+9anjsyfS1m9oiV+yKCdsQ3ZDUN?=
 =?us-ascii?Q?nRZEV/BJh1GI+clzCNOHqlUy9goJ77tSZ2jdvPQyDIlGV+wLgCVxXUghpbBx?=
 =?us-ascii?Q?aO7wEsmVIP94ErdnuJZ+Qq/T8yxz9Pmj5S/nPECYxov5KfS0tWHyRMpqW/le?=
 =?us-ascii?Q?gFVuGdEQFYBNXUrYwCo7nlvjtFmDjVMMj0PUl6HQaV3TxVJUdm1CXTNTcERA?=
 =?us-ascii?Q?Mquf8p+A9mBvEjajp5c9dvxJR/lWdoDKulkbFFIZGB46UZqnGznV+fCrZuUZ?=
 =?us-ascii?Q?qa9a21KR/CBrxyOB1qQ0hBt5VTLj6ywRjLY40XTQSDAJKn0g+ecZ6FwLcrS1?=
 =?us-ascii?Q?sOCLEEz6+DXUfsjbp3O3J//HrUxgWJetro2EUEA9ydb/JNUCNK9skaqN9INB?=
 =?us-ascii?Q?i/RUbqeobzYfARU8jeCTHKHkpLyWYNqLVDz2MkTXnCHrenkD7NP4sj0vB0cj?=
 =?us-ascii?Q?YAlqbu6gNtBnTOKGEyjH1O3uBeOXLoaJgUZjPzQb2ZPNQoY3q2JzXLNR4v1R?=
 =?us-ascii?Q?9N3UQlhxNhPZ+azgHPgdn9CM85ymJJ5ieOoiANd6RU588cjo4ZqvnoD6agU8?=
 =?us-ascii?Q?fmCpGTczJKwEuq6beiGjY4cwdNAWzlBAbJcxKFtmG4B3b4qmT9rh4+B4N7uo?=
 =?us-ascii?Q?Jhlde8nU7Hyxxr386Q64fT5ZjFLEatZBeCoWiPBY8YkUPQp7MOpRhrZRhbxr?=
 =?us-ascii?Q?uJJKU6FcPTE6jsxhG2AXW4swHPrvZA+Nrz3nmS5+UciBBMDU5xlfr/amTm63?=
 =?us-ascii?Q?YOWpDKWTpJBHpO4/qgb+GDQGUjDJ5FdsWVL44QYxppvyNohos1Ed51it/SU0?=
 =?us-ascii?Q?H3QxZ47Nefdt1pSS/Iv1RozzQro44tD1maAqSlFXIKv5UqmQs3LT/xzGdehP?=
 =?us-ascii?Q?Hnf3fnvkfbt2nZGCNF33Q8WEnyCdxJ+tYFyshmgONgMWOuevM1tH4oA/2rTL?=
 =?us-ascii?Q?Nr439ZwcCA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YuXDpzFWNSf3Z81evxwcngDAbVf7zm/SGICgzPpgtZM9xP2f35hXyJuvHXrGhIm3Shv1gm+BGqLGUZ7oo/GnWwXe+vhWgnhgRMjp2ljXn/Him1vlDleAVQfp+HWi4kpVZCmJriCXTQCvjTIEVtTB2GO4JkPopKlWtkgdYToy5NW/StAM+7UKzdvHhjWf6V88RAdm5Fr34lO+Km1f+pTFBve9LzOEKP+pFNTSKCr1JfJa4IaTuziX6H24DWLODCbwkPfLGe+OzicVaXXSqdE7fTlqRMt2cA5A4rGRZ3/Tm+d6owQWHRI4LWvWNd12AK7zbkQTwMvl0FIk36OoDNKbQm1AQC3KG5Mz6tlfD+wXRbg84dJOxc9AhiBHiKqSIdoU98/KfVvemuSl2BxN02fh5yEkwCqR0bYEjfIlHgIEfh0AJeir6BfBRPz9x5RFGz/Htsa1jnn94/rDGqA0s8PUDTcvaXpFl17MyFzprWGBBBSsU8wVIg1vRKKMxR3rBSybtTC6EGwvnWn4HDsErMiBLUjH27ooptzSIQaeHcuQzYaHuQRuBAVpVBP4uHyKzAu8fEzO4/J5j3RIbEZsz42Cej9suiPWSxCzNhiMVPyqIIQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a48ac27-fdb2-438a-2fea-08de5f250c15
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 10:56:25.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zW9T3ZQayU39/1JRWtWJ+IgwI2+ztgfwEDErPFq6/Q2n182i02fCy3F17cPogZzKwvRMdNv6+1uMwA9IWxj5Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF9C7B9A88F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=725
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601290072
X-Proofpoint-GUID: VyX1WVF3nefT7lmV087UqnF08orfK-qK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3MyBTYWx0ZWRfXw/+dGvaHlHwY
 HeFj+Xc9FN43HALzUOt0XR91DVtTwTqWf9tUXnSDJ6N+6YJIkcKmwshSbhnYf9ZYp9/hBl9oG9q
 wgO4vhwLj3dWJD5LWJ9Gbnn9GuwyI599LnltPQh7L0x+4K+BaEacRLExSvJgbtF5MKIwG7PLkGT
 iyiqXWpXOpkSEJ9Gw1zCAih4ahjv31uZTBLPW1qUfOgq6jZMD/1aUl4yMTzR6TrU9YfZ8FpvKPu
 a85RNTdujpdN1S7eh5rvELIg5kipXg2lQO0HOBrwpodoibhqTlp77jJDQJMt6KDUe/OlU37Bli5
 pIOVfqta9GGP9dA8IQZSYTriOe0pC8ffMuAdOm112/cJDikAq9ozRI0q66PRePY6kd/g0XBdRY8
 uTzIGF6AuhFovbeGMthYlk3PsrpGwD+s98Bo4xva/kHNPTsCzgwVN7ODI1bjaQJhHp0glvBWp5H
 2j5XV3rU8hXST2wcLpg==
X-Proofpoint-ORIG-GUID: VyX1WVF3nefT7lmV087UqnF08orfK-qK
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697b3cde cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=_KtXmXD-uptmDMhrOUcA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: BC2494000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: on8tybnhi7iwo3yrxw843fmdrted7yxi
X-HE-Tag: 1769684194-323224
X-HE-Meta: U2FsdGVkX19vGtEhtyKgl53uAB/ZtIephlbX7oY5Nq/ArpA5frnvNDHR3zV0mfXaXxaeEmIBn2+QfimcwYPh+RqUDfSSLIC3CHVE7Kr2rH6Sad+aRR8oRgUT0R9hYS5Cb3qI0PJH1IXgZHmdvcF34kmtQ2Z+9WrK1WTiwDz6ON0mScK+qy4FYnxJJfsF0mKMHh4r4HAZBzDHQX2Q31EjbKAmrWul890JeuAwpxTyymDUXLB+m/B0l4QxGioz6gol8RuRixCmJiIMR3tryxw9kXsSTT21w3AXhyRv9CEwOUpcy6N+mHmEUDS5johKTR6fbwwpph9jP8fVbGkvGz0u1iBBv2v20SUvVeZuQcqYlBJlv9kNSektFeVhCEpc9S2qwRm4reaV/wg0/t1CX939ya2S80B9jPbLb4xVKczKsa2Stg5CCb3NxGiauGsvKgKSpnj4UJcq0HXEcXuxsHwpDD/nS15akYQdPRI0Kqpd/uVi+IZIDzjhMaG9badh+zb+7nC/Ds4bqLWW6c+SrZzHEF4j6Bo/azlTHP3mawZeB9G8Jt6SRumfc3mXXI82KqXkg+WMBe5vArEChhdrjJd79cvBAHkkkKREHEnrfFAFDN/t+ms6STUyLlR9i74wQki+JydlyU+9iALD4jpW3UPoxHvyWzLtoZ5esYyhELFj5bjYdP0HN1CBt7xepCmacNunBeH6srby1105y0lF48PXy+v3RgvXUtBr4UaAbi57pAbK5MCs2vUWRXr06mOBfug9eERv22zGF/B38gam8l8J0FECLBMnsaYAPEYH+tlB8G1XN4ve34LSnGz87IKKwBo85OOqDY2YLsNXNpaaGwzCl/go1/H1clyTzxFOS7RfSfJBVXq+A1K8bq9qUmSuumlHfjbMnlZfwwGq4mX1p59lybVqIP6aZ7xxhvSVD15tAFo755YI0KIxfdqdrrTGjdSNFDyyoDtR1i01Kw1CAAn
 wgJ9cZQh
 75/RU1/Kas0LKSGmIX6WbI2/oCuBjXZdS700vxZDN98X3fvCIK0rjdlHNPoxhyqYK/jrcm6NTkDxTDjPqTAxqzTDxaQtDGMLRumikBe335LHSH8jbk0irk+5Oeu4BBBzcAc7+5/ZaVBxCl105ztEVONVRRzbAi7o6JqXSHKZUPrDUHekn36lAPc+c7Oya5uOs3Wv8fHGrnJussaBkUPiUVmZQieeJfUWoXoU7ETjbEOWFDcmGKFGrNnqDuuhKvANBGm5P6UBH3stzCE/xjHwDMzRMYXlTDreP86NcVobi6twLWXquPlOkjZuoq4WtmAkGZGB4O7pI4b2i7lem1AQOgIxURfIsYEkK8LC2f6K3+goYWzfLKS/0I+cZtVsikvY/Xahjh54a4BISlqssfhuPm3ljYMEvoCztTppTdQi6Kn7VuTgZ40RBA5C6gJ4Hn+Z42pplkUk7dqoqC1ENIOLJCBLFavKO4+u9Nx9AYBBmySK6eoAk8fzgjoW3zo+CMSS6QvLQ6uMiXWjSeNfRDpoSEfJHnv/sH0Fgp8Fqw60Kq0ckzal7r4UYMYoke9XLyl6P091pVtMZBl4mrOMvf4tiis9TuIPy7UCMhz1xEMiBO5XKJ0WsFPCrMuPs+x4GO+gOu7DKKzune7dajhq3BnNsKh31D1HM8kHNygVnGJ2AbEj1FfApMgUu7WyBHAMoSbRhIjNm6kYrxqe2Nkvrni5du5tATQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 11:39:04AM +0100, Vlastimil Babka wrote:
> On 1/29/26 10:30, Harry Yoo wrote:
> > On Thu, Jan 29, 2026 at 05:21:21PM +0800, Hao Li wrote:
> >> On Thu, Jan 29, 2026 at 10:07:57AM +0100, Vlastimil Babka wrote:
> >> > Kernel test robot has reported a regression in the patch "slab: refill
> >> > sheaves from all nodes". When taken in isolation like this, there is
> >> > indeed a tradeoff - we prefer to use remote objects prior to allocating
> >> > new local slabs. It is replicating a behavior that existed before
> >> > sheaves for replenishing cpu (partial) slabs - now called
> >> > get_from_any_partial() to allocate a single object.
> >> > 
> >> > So the possibility of allocating remote objects is intended even if
> >> > remote accesses are then slower. But the profiles in the report also
> >> > suggested a contention on the list_lock spinlock. And that's something
> >> > we can try to avoid without much tradeoff - if someone else has the
> >> > spin_lock, it's more likely they are allocating from the node than
> >> > freeing to it, so we can skip it even if it means allocating a new local
> >> > slab - contributing to that lock's contention isn't worth it. It should
> >> > not result in partial slabs accumulating on the remote node.
> >> > 
> >> > Thus add an allow_spin parameter to __refill_objects_node() and
> >> > get_partial_node_bulk() to make the attempts from __refill_objects_any()
> >> > use only a trylock.
> >> > 
> >> > Reported-by: kernel test robot <oliver.sang@intel.com>
> >> > Link: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com
> >> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> 
> >> In my testing, this patch improved performance by:
> >> 
> >> will-it-scale.64.processes +14.2%
> >> will-it-scale.128.processes +9.6%
> >> will-it-scale.192.processes +10.8%
> >> will-it-scale.per_process_ops +11.6%
> >>
> >> Tested-by: Hao Li <hao.li@linux.dev>
> > 
> > I wonder if using spin_is_contended() or spin_is_locked()
> > would be better than trylock by avoiding an atomic operation?
> 
> I checked and found that spin_trylock() itself implements a non-atomic check
> before the atomic. So adding a spin_is_locked() would only help the caller
> bail out a bit faster, but this is not a fastpath. It wouldn't help the
> cache coherency traffic, AFAIU.

I looked at qspinlock version of spin_trylock() and you're right :)
I just assumed it will always do a CAS but it's not the case!

-- 
Cheers,
Harry / Hyeonggon


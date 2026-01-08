Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677DED14882
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 00:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC3B6B0093; Wed,  7 Jan 2026 19:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA64C6B0095; Wed,  7 Jan 2026 19:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B520B6B0096; Wed,  7 Jan 2026 19:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E59A6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:45:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FA231404EE
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:45:21 +0000 (UTC)
X-FDA: 84306952842.18.CBFB28B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id D55CB40013
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:45:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=niFuD31+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZPoEsytL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767833118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysomho3lclI906jTv0DNvrp/QzTR+Pf32Jhgj9HZfbI=;
	b=F1RIp6KSj5OU5keV/RbizC4oQdVheaCu0dNxWpZH0JrhFppvYOht4OnfskhAbJdJ/S8PUU
	m9o1xhO7r0th6DR+mahXQXGzV4oIIBUUoZ6Hz3Bnw6ZrzE5wPLntB7EnClYJFkLSvo7aZf
	v/aZl3NjDvFEZhSomFlGuGpiYzk9FB4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767833118; a=rsa-sha256;
	cv=pass;
	b=WFTRaoDdRZa7+K7FqDC0CO1itOahn24I4XmvrKsmbm5WBb9QtEtkMMO2D/aGNHGuJ075Yq
	UtNu1c7yzpHsHc7LxK8PZ/iNlTQFY5BwPIIbbMb0UeXyWFsWVhtaFe+ELy/2adTBAfkaof
	qr3Nn/kwak+aQ4BtpHBePVtAGAmk50I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=niFuD31+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZPoEsytL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6080ZfEW3229572;
	Thu, 8 Jan 2026 00:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ysomho3lclI906jTv0
	DNvrp/QzTR+Pf32Jhgj9HZfbI=; b=niFuD31+bdFk6bRbhsbAz0AEKtS8dpdUkV
	tAvr27RXEAeeSensLmp2hvP7CglphpqAWnyBXlNqvehE3c3veuYEF2ckHy7UOIVB
	ki9zBW7ibQ3zoZwP0l6RM4/24qfY/p8IuGMTroVnrEH8ESYhqvkjRnTjL95fe6Ne
	iWXfADuJCmY8h5Owd5J9xpH7I86kuYKeeXJSKEJC4eTxS+7dzYMXc1QKNV6dqMM4
	//VOsACSbPQjSec+GKgv9OdX1KO5lrZbC7NBIjcit8z2/O7221diuUTBpvCeW1rC
	b0HK9a0YYjs3AWC0fgINC5OWpU9EjdB5q5yPJnmxqT4LQKyyRxmw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj263g0dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:44:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607Nh799026294;
	Thu, 8 Jan 2026 00:44:48 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjmrrpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:44:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebhWdUnp+71WZqujHl/YAdW+dL+6iVqEQqxx1YOnHAXHSM+xHxX6mROjq8hMbaenPjAHMcbs/UwzjySurqsZ6/sqFrAuOIoYkI6F/lTuJlRviJMgKibNiMbvfKZUOBMfpnrI5CDt2HtaXiUqKMH7QsJLaCG7iH90Huc6FxvedgKg+TMGNTFpP/mmPLrTDRVBpuItn9DLf3U2wpI7GjCRmW8qU+9XRm2Yrlpds52jLRlREb76+sKRmwAPEhNUTTGunV91lrjWl77p9llyM0oq9VbivnDFhgB3tZ58dsYD8r3J5mkDie0YiNNV0dJ1Dy6K9TOdAIQoGrpPPi/3/Js2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysomho3lclI906jTv0DNvrp/QzTR+Pf32Jhgj9HZfbI=;
 b=XM1qMOBSI1TAMQTbrc08EHtrR4/IXZdzHHXByjMduU81eR1RCz6xty6sry+NrulwrwBvn8Dsd/DgKlKcYjGayKw3GYhgrf2Oh5jFvsm38DwQfLjjpN4BGqyTJI14n5TiO6Pi/gUTvBTCeTisX9eHhd2qqw2AOsH5RuRBl3AxIzOsuADQlTEJ3f/U//Xq5RFrSety7X54uYS/jc9SahqIkV2Cq9XgxaLev4zs+tZV0WWpBten6F5bEmTxcBSNYP8IRscP+ct6tlF+QRuHJ+cTyaT7WgntMsAkM3XPviDK47u1FUSwuAGNMfCdIl8euW308zSf7D4FUm8gJjglcqu61g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysomho3lclI906jTv0DNvrp/QzTR+Pf32Jhgj9HZfbI=;
 b=ZPoEsytL5wNxrq1cIxCAXtSCZCGF0Q3dVZQFmuHq6IRDef3p7CqtDGNQ2BJi2RNrLT5O8pTYV5EFzZvpBFJkZmuvZ4nAbWinlCPs6rQLbuHrzL4LFAdePFbKIcRE3OUrDax15Gjda0Zl2YSg0cvGYs8mksedcVFQRwiIot+q1Do=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7448.namprd10.prod.outlook.com (2603:10b6:208:44d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 00:44:45 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 00:44:45 +0000
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-8-ankur.a.arora@oracle.com>
 <409dc029-ad8a-4f7e-931e-8044b61a0295@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v11 7/8] mm: folio_zero_user: clear page ranges
In-reply-to: <409dc029-ad8a-4f7e-931e-8044b61a0295@kernel.org>
Date: Wed, 07 Jan 2026 16:44:44 -0800
Message-ID: <87eco1rkzn.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: cc192b79-3790-4bd2-4669-08de4e4f1e49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PjwSvamgRlOPQBr/7/sD/25rmlKpgT77ujeDs44iCbgLR3upoCfe5/Vs4SWd?=
 =?us-ascii?Q?TViLsOzw3Zgfgtw4JKXJ+LBHWk1wOlcTDtJUt9L2fpoyyb+4Mgd4pG3ofVJz?=
 =?us-ascii?Q?5h4hkqOwk9EKbXHoPslKh5PtdJ7AyDKA1R33+dTPj628e8VhD/cKXh+b33CC?=
 =?us-ascii?Q?TBKdAKdgKdsZJiNE2SBLihiLgftAygwOXGOzSdUgI2q94JaCatCaC1Cge7FS?=
 =?us-ascii?Q?TRV3CRSiGXiAsIleWEPdOxVotzxuXuTMxKOq0CbbEI1llmd+Pm0NtPITNOtf?=
 =?us-ascii?Q?eq0Xc3QL3bmCcLZwIycnCt0K5agyddhavURPpsrz/44po0gY//z8hIEfuoUq?=
 =?us-ascii?Q?MGmE4fAAHPp6+xMPSaiupFMFpaxlmDTjLeEPtUxRxFp2/mGHBDzuFB2pu4E9?=
 =?us-ascii?Q?zJepCfjn/RKjagy4RWQ1JKl64gDZA6wqoupyCAdMrd2o3DbJg2vVEbRi4psM?=
 =?us-ascii?Q?NqWcOpr/KN/9OYRQpBSmpwF3Km1rD9BS8X0ds91O1wyo9oD75fCQonTv7PG7?=
 =?us-ascii?Q?jP5pQLaTsLTezY3czixCTRt4JfIhbFW5xL+aD+EYqmHKcqyCza4PhaTlCf5C?=
 =?us-ascii?Q?UVPSYm5UyTFIKgekUrLd2MjSEcDlt3KijNNA+VXlQDbhu77zuWwrMhIlBPuX?=
 =?us-ascii?Q?okfwRmwxw91lQzKlfFa8263b1QU67nF7H6Mn5RN4tWSR5eX0XiaBMwaKoNuM?=
 =?us-ascii?Q?ZZ43336ebBVjAGwaYPiPDnxsOyzCwoKI1W9PO3rZAsp4UUX8q/v8DhMIN7nG?=
 =?us-ascii?Q?mBWDRATKSJJVSXiwkY6LJ5fzI+yCXyb8YbUjHs3B49fhUuyCKE/7k1zr7fUG?=
 =?us-ascii?Q?PWJXrmmmNaGmpIMjv8eiy4KJQtJTWtFg2BGutkcwbzrQJMP1rWyuw2B5sc7a?=
 =?us-ascii?Q?nncm5A1d41oNzi354IZqET+mgRepgk6iG/FUeCMbd2MHmtVU3gKE1YegJx9l?=
 =?us-ascii?Q?+wksWGIspHVT7NSC93qXzhZM8FYPbRleOqHbwfi3ReMo9VemsTF2hXxh3tJN?=
 =?us-ascii?Q?zRWHWo5QU14YEgACqy7gZSMn1QoAZqeINqfhhF0EP02FHpqXec2abnwuhakb?=
 =?us-ascii?Q?hEbKz//i55DTX/ZgGyRsIISFkjqAdXA8sf+zsU7+T5gZICcLANoDo2BtPFb2?=
 =?us-ascii?Q?cBDzCVI7O1y7hAQGW/wlzh9uKhFf7GKrfG5ZGDmiLiFk4d4VKVKBVNspTJ6D?=
 =?us-ascii?Q?owfPuyL/0QNB9nbVxkDT673BNh4V2jWZFYh2xx28VWdSf/hLel95y8/tPXoS?=
 =?us-ascii?Q?bJ9cj6iUZprnAvgBpJQ5x/kHOcrGZdeu2ezxFNalcV4YxtFzOJNL5acHDOsD?=
 =?us-ascii?Q?Ts05bZf3XnIdzOHzTupPPLgMAFIhGMgqNCU6dUWvA9G5WXC8g2lMeWnkDALz?=
 =?us-ascii?Q?D21AaxXffBQsQZxyITl56mkZ9dwKwiPbm7mWjXYG0PHDdV3QzYwJaZuK8/yi?=
 =?us-ascii?Q?W04nY4XM0+ViqnznXaH7tYFw4nXajMJ0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z2HVuUWR111/0acN9uTDabGia3PponXHL6ir2OfYcMaINe3WoMqP6gDm50WE?=
 =?us-ascii?Q?Ph8GKZJatwd0FEqYRVBaFqHdW6Y/gKwJcUtXwZOHhRCH4GubxqbjH+/3CA7g?=
 =?us-ascii?Q?iqzXuU9x4Gc65tXFIRyIX/89iBOQxD9Lc64tMFvYw0HOxQ3L+N/F2r+ibHaz?=
 =?us-ascii?Q?IZu5GiuQdWXAW1diXGluYBoHeh3smF2pflanhrUXa72KxJzF8W3cN5B4TUgg?=
 =?us-ascii?Q?ZTnfNShu/qpp9H5REt5SmSSy+Ck+b17YYpZ1cxGFJ4capng1f+rpcSZ4MDYc?=
 =?us-ascii?Q?d/a0v0+/f1GDsf6mpbhZa79iF+XJZKtI0ivGCrObtE/wZQDZVqfMLFgfD9B/?=
 =?us-ascii?Q?mM2XuekLM1abGD5BulmgdEqfIv2Pm21h+D1XcBUSxq4eAgBqfocY/7ae+QKd?=
 =?us-ascii?Q?leOoiS9bsPwlLhbfr3IxnhlDu4cIDVEORPrpqpAWruT/aod5WlawTEmJuelW?=
 =?us-ascii?Q?kxooh+b/wdThTVin1r8g6EUJfgGbzdG6xKaaeHdv0eBWObOkFNeoqyTW+NEL?=
 =?us-ascii?Q?D8jP/7qgAb+217EOMdmN8F6bXT4J4L8uEHVIGRPqxUAfHXYJvLHqjscuPa9v?=
 =?us-ascii?Q?bGQDy7D+t4h/Xpf0Pukdbw6whbJ+jEpUofb1cCBRo6h9WRgwlEm8hewQSSB8?=
 =?us-ascii?Q?A44OT9Wfpu36vHp37QH1mmafQvEe2PsWSDAy9aRI1WHdT+Vrr4wcEji6bvxW?=
 =?us-ascii?Q?IehSBSbwHNyd5ZrAgnj8nxffAxB1nO7tDFPyk+W38mzibIja7xh79yBWvbZo?=
 =?us-ascii?Q?gC5G/vIlR1d9gQ9KXccH2uD43TE164VDHE6UhGga7gywmkOjlO4rowsObQ91?=
 =?us-ascii?Q?a9zJ2FcuXl1iLR4Of+IzWSPKb1SxdLrlxts12Kg1MLxXHkcMgYuRnU0edBRY?=
 =?us-ascii?Q?KJCA4vp3IVyPqdb0o2Okpv/M7bP2mmQf6xtDzrogNvLpN//JfZjrnNSm5V0P?=
 =?us-ascii?Q?0qojhY64EDknS/QcKF2gEGRbP3Qwb7ZOVADfk3A39lHTHmhxOVIQl+1OVTOk?=
 =?us-ascii?Q?RL9aqwQKQop1TfsahUjylEXwjTt+YbtySJwR0BmLgmKZNe/Ov5eKXVd2H4wu?=
 =?us-ascii?Q?qcmFbGiEU3KDZ4Hb0phojAARpyRN4QxI/lr8XRXRCjYQeVC323fr8lj8imFx?=
 =?us-ascii?Q?C336Sa20QqJDfaPlLteuCDljtfBQOD3DySKHs88e1eAoKcEKoVUM43nYL0/g?=
 =?us-ascii?Q?kAYDgMN1u2WHVwJ9mgidtHZCvDZnIm7e3JxD0TYUDo4gQ0/R6KrXKayIcCOu?=
 =?us-ascii?Q?9pd3mvmqrVAdArhhc2f3e47xkSkXVJ2KmbovV+lPK8S3FDD4YUaaLc3k5eYe?=
 =?us-ascii?Q?DIBvLUReu/94NUiQyRJDlUzdwpwXJ11GxWdGq0NtW/1zWZ0s2fpM9o9tTdmb?=
 =?us-ascii?Q?EbKcsVK8HwyAZVufhsF3iZw3NH9FviYmmqtBY3Wi8JGRg7EfmCK2D6YwfEu+?=
 =?us-ascii?Q?wHNa6n4Ro6D9W2d1WPD9QhOYO5MrAeRAKFjPaaGBvA775Whr558FBkXPPAtr?=
 =?us-ascii?Q?Od7HJdyqhI6a29hNqOkIiaXts8Eg3f5jjpMRUEuheDUUGnj+nNsksDVy+3yH?=
 =?us-ascii?Q?juA7tPiuWBEDeWlJ3mzaPndqywe/Q1DMutddhuIzniQz1OhHdBsPXpfshjQ7?=
 =?us-ascii?Q?HWCBB5PHvKdkQq/NfbeH2O8pfN4YbD8GYa0wYcES74ARqXz6kk7areVxS44X?=
 =?us-ascii?Q?JKktwnHQMsR2cGHQUhj3jXA3o4puO2QNZbYH0I0w98s5PuH/kms1GqT74fzF?=
 =?us-ascii?Q?KSI8fBJ5AIOHiwSlgSUqUDVY+mRSqBY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	an/xshzr3p8sbLwK8d4ADYMSCKZjyTbaseSECabjUSaeue9A6VjNkeHjcc80q37sjNLJw/oar4Qq0RRYstYRbpd5BM1Sy2v8Vu6AVm3lBQqI2Ry42x52hVBLEEztrbn+ZvPtbZxaAjgZ3UKKHyegwEN2GELnErd3dV5yd1CH7DJpQVvF//7S+psUeMUbvOJvXhnsi/hBc4gfT5thcjbumWsXJIQmWqdo4ei6Yux+Bmyy9kpbpMTsipRpNMb7BNlAbf0aW4A3A88DzdTBRDPtEG9JsefcXAaQr+6AVSjG/yWaXy+JzlWZaZRo6EXH19pP0aedITt+j16OtEigiDI3l1fkaqg2WW8MqSZd0Kt8UFsHIb3UptuaycEaAgj4nX9tQ9vSVeUmK+phADdoTVNPLnPIqieAAgNvoto/9qDKXAafz1Uodn/HfybGxlr4BVCPBpm3U4AC2rrsC2FWHGaIcPsdf9Qx9RVdP4kZ09WaCl5Qzttcp6Jsu9G2lpR7vnaSYkCGrNNDVHDV2kqELhrLC3QYqFyiiPQMPbEGW5Zkqf4fyt2QvXhzoaZ3avhEDVI/Si2OAHIeoqYQy3ewJukqKcHaVu/ALaSlkL6bML5adTs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc192b79-3790-4bd2-4669-08de4e4f1e49
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 00:44:45.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHQS/ghxuHNa1DgVTx0rKr+NC8hoBLOkGiBN0xjAOqI58bheTFcL9U4tSdaqprxG6dQBUQK93n4x8XWHa0HLT8l9Wht9xMHtVuJHvpB9mnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7448
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080003
X-Proofpoint-GUID: p9KVG6y6k4IEHmC3Oyek_ViiHR50Xzcn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAwMiBTYWx0ZWRfXwyLvYDnmmCYB
 Vr0+r5Vhll5Dz2XeIH3S+1QqxxcY4EVXYJxlLs0R6vltxGH5yjY+0mm/C+xE2cfVvB38BgNsQYo
 hymv+hFEpP41dPhusoVCE9C22/AvNBKjYN6hZ4NOAZbcDE7DCkG+sr7vT6ODZpl7k03CFzJaB2n
 Kn9o457DaRyortMZmNTswPsym6XUMy07deaOg1bG6UhW71WBWRSfKU4l91MvsPWF9ejgRCsjrAZ
 CD6pRZmpQtFyzo39p2ZY10X8GhuCCkLW4nGJBHxU6Iw2IDPGzjzmCsEghp+ikTk2JAJciqjkO1r
 aWi2KH/G21AB1mMQB386nDrM2Dkn++LfMfhkbL6CiV7t/DgcLrFZy70G06rz/plFb/WbnMb97qY
 uNPkDmtRRBFEZ4uQQZi8rAvt+fzyhSb6YgeOv8HOORcgyvPHjBCtRkcD9rnRZNPy0TlcKA1bw9E
 epAMQNmtL3pM1U7JRcu+ef3FwUrzE3H1+SZhnAv4=
X-Proofpoint-ORIG-GUID: p9KVG6y6k4IEHmC3Oyek_ViiHR50Xzcn
X-Authority-Analysis: v=2.4 cv=eYgwvrEH c=1 sm=1 tr=0 ts=695efe01 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=ioVFRKi6CAGLhe_xN3UA:9 cc=ntf awl=host:12110
X-Stat-Signature: gakjfkdrkcyymxp5iitqab6uiqz5hpoo
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D55CB40013
X-Rspam-User: 
X-HE-Tag: 1767833117-895332
X-HE-Meta: U2FsdGVkX19GqHpNkLuz1nsUpX1wj2S3VGSDAeLODk8HCMw/8Kxn0dHN7qZ0ZhyGcJZqNbFmioX3j+ba0J4B98L4mDtG2dFw/HEvwq+UNH3LIldNhGXbFDYAsFIfFqtvYUPVrFH4l6Je09ElYdC9Fmx/nDyClxy9o6tQQ5lG9aS4le7TVA6qf6dm8X7sRCXjOzkRpRfgy2POYpZS/zrlCxnBwhDPOQ6fAXjlhJZoD0FHnggtWTW7C077SMab5Y39YOtv+JvqtjAjfm0JsUgiaN3Bju9Qrm5r1QObcEuWIHHbRWwTy60gwtvkYQw50vZQ5eq4V9jePkChvoeklhocA++iU1LDfs70SfFeJuurigodV2+u3h17Cwv957EbcY0DE71rcjCyIgTJuYuorWR6sf2MSar/1E13h91pr319PHbYSqh2Mwj5JlMAfWBb2X1FxA/rwFa4144IcwpMRlVshGb1SrtJYQrfRlX+xY8BZGa7icnZZfa6cF1IB87P9ZWcnnsPvE58iBOkY7kugguWSm0easKNWf4GcYoAmA4ed8e0aSX3DHxIRNVMvxneDkVdL3wiEi5f2uXNd+xr0GWBv+QZZJsOaQ15TrifJydtrDaO0TyeDP+D6h0MlhPnL4Yw/1sjS2d9p0mRTqLfa326S1A7P7RS+DTbGbREUPYJKJ5XP/jVEZd65bydGkw8vxPlBVY39GrGCkeQId3z++tNqIyg6n50XtucHJZexmMdN2R+7Z6eIwf/itl0683sipF283r7fhbz5mT3w0uY8HIPtDV0FLLJWtp/MUFnJIn/9MJrArmi/OQCsMPM4ujkAE/HNoVZuTSMGnEPLk/+CfLxsxtKxl3W0TJhRxiWeRTJ/rHhw+DV6ekO3/IcEHYsOGZLxyL1xHeMwHmlz1UEq59ycteSCkeZ9TG77Z2wYJg12nScVpwECjnnNUymvjA+ce1nrKoEGG7EwcmTlYeNsFj
 BD1Wvyex
 ht927WCz4VL7fLlI3VesbZ0+AM/qew21WVBHETDRfgJIdDu2o+dZqA8urErWMaoRIBAnxEGMoVMogBiMIcMaocL+MF5wbUtIGN3d+AKUD9hKO+lotx9afrJEegTE/0DOjVOyyDIPxiiEM1Kt4y6M8prFGsNore4f70EZ+JEYfSHaxsQwOnzZWoHq0+jXP+RRf4CmUFhipHpQFKbAhGcoJjanEqI/V5s89ix9w2QEWL7Q/P5qA5WSNswx5IW6VPZ8tmRonmevanCfaXk0FP8VWcWmKNkgceAb7Hsuu6xlciF4xckZ/3Jyf9by4E1hQfIZRji1sBcDfpnc5W6OovIzMtfwhJE/tHHpiBqv3nirj5o6T+sBu/kz3ireJKv3LYCtJ6WY4SrDU6oIUt8cOOa+o5BRbTWwZQnmrDD6CpzCZdauG2XmfvxL5sBWiHFXbS2Uf0iYTekTCGpKCtF+Wv3KmNbMzp6tS6Tha/j+OGOOGdsMz8W9CS9+Bm9AhJiWEybEAad8e+X/2QEZ47fsClWAcelYz+Q+9zqVlwqP0eUFTS3l7d0oi2aTpGPp4lqFdL6dVdTCwcbr9Cf0Z5kgtxy8a2y6OXymN/wEhrmSaj4UQb2pC/NzHU2YljfgTahUkPWmQVGOQsSk3SyOIxTDB+oQKMcY1oOt0rT7uixjwsBxPpuUskzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 1/7/26 08:20, Ankur Arora wrote:
>> Use batch clearing in clear_contig_highpages() instead of clearing a
>> single page at a time. Exposing larger ranges enables the processor to
>> optimize based on extent.
>> To do this we just switch to using clear_user_highpages() which would
>> in turn use clear_user_pages() or clear_pages().
>> Batched clearing, when running under non-preemptible models, however,
>> has latency considerations. In particular, we need periodic invocations
>> of cond_resched() to keep to reasonable preemption latencies.
>> This is a problem because the clearing primitives do not, or might not
>> be able to, call cond_resched() to check if preemption is needed.
>> So, limit the worst case preemption latency by doing the clearing in
>> units of no more than PROCESS_PAGES_NON_PREEMPT_BATCH pages.
>> (Preemptible models already define away most of cond_resched(), so the
>> batch size is ignored when running under those.)
>> PROCESS_PAGES_NON_PREEMPT_BATCH: for architectures with "fast"
>> clear-pages (ones that define clear_pages()), we define it as 32MB
>> worth of pages. This is meant to be large enough to allow the processor
>> to optimize the operation and yet small enough that we see reasonable
>> preemption latency for when this optimization is not possible
>> (ex. slow microarchitectures, memory bandwidth saturation.)
>> This specific value also allows for a cacheline allocation elision
>> optimization (which might help unrelated applications by not evicting
>> potentially useful cache lines) that kicks in recent generations of
>> AMD Zen processors at around LLC-size (32MB is a typical size).
>> At the same time 32MB is small enough that even with poor clearing
>> bandwidth (say ~10GBps), time to clear 32MB should be well below the
>> scheduler's default warning threshold (sysctl_resched_latency_warn_ms=100).
>> "Slow" architectures (don't have clear_pages()) will continue to use
>> the base value (single page).
>> Performance
>> ==
>> Testing a demand fault workload shows a decent improvement in bandwidth
>> with pg-sz=1GB. Bandwidth with pg-sz=2MB stays flat.
>>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
>>                     contiguous-pages       batched-pages
>>                     (GBps +- %stdev)      (GBps +- %stdev)
>>     pg-sz=2MB       23.58 +- 1.95%        25.34 +- 1.18%       +  7.50%
>> preempt=*
>>     pg-sz=1GB       25.09 +- 0.79%        39.22 +- 2.32%       + 56.31%
>> preempt=none|voluntary
>>     pg-sz=1GB       25.71 +- 0.03%        52.73 +- 0.20% [#]   +110.16%  preempt=full|lazy
>>   [#] We perform much better with preempt=full|lazy because, not
>>    needing explicit invocations of cond_resched() we can clear the
>>    full extent (pg-sz=1GB) as a single unit which the processor
>>    can optimize for.
>>   (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
>>    region-size=64GB, local node; 2.56 GHz, boost=0.)
>> Analysis
>> ==
>> pg-sz=1GB: the improvement we see falls in two buckets depending on
>> the batch size in use.
>> For batch-size=32MB the number of cachelines allocated (L1-dcache-loads)
>> -- which stay relatively flat for smaller batches, start to drop off
>> because cacheline allocation elision kicks in. And as can be seen below,
>> at batch-size=1GB, we stop allocating cachelines almost entirely.
>> (Not visible here but from testing with intermediate sizes, the
>> allocation change kicks in only at batch-size=32MB and ramps up from
>> there.)
>>   contigous-pages       6,949,417,798      L1-dcache-loads                  #
>> 883.599 M/sec                       ( +-  0.01% )  (35.75%)
>>                         3,226,709,573      L1-dcache-load-misses            #   46.43% of all L1-dcache accesses   ( +-  0.05% )  (35.75%)
>>      batched,32MB       2,290,365,772      L1-dcache-loads                  #
>> 471.171 M/sec                       ( +-  0.36% )  (35.72%)
>>                         1,144,426,272      L1-dcache-load-misses            #   49.97% of all L1-dcache accesses   ( +-  0.58% )  (35.70%)
>>      batched,1GB           63,914,157      L1-dcache-loads                  #
>> 17.464 M/sec                       ( +-  8.08% )  (35.73%)
>>                            22,074,367      L1-dcache-load-misses            #   34.54% of all L1-dcache accesses   ( +- 16.70% )  (35.70%)
>> The dropoff is also visible in L2 prefetch hits (miss numbers are
>> on similar lines):
>>   contiguous-pages      3,464,861,312      l2_pf_hit_l2.all                 #
>> 437.722 M/sec                       ( +-  0.74% )  (15.69%)
>>     batched,32MB          883,750,087      l2_pf_hit_l2.all                 #
>> 181.223 M/sec                       ( +-  1.18% )  (15.71%)
>>      batched,1GB            8,967,943      l2_pf_hit_l2.all                 #
>> 2.450 M/sec                       ( +- 17.92% )  (15.77%)
>> This largely decouples the frontend from the backend since the clearing
>> operation does not need to wait on loads from memory (we still need
>> cacheline ownership but that's a shorter path). This is most visible
>> if we rerun the test above with (boost=1, 3.66 GHz).
>>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
>>                     contiguous-pages       batched-pages
>>                     (GBps +- %stdev)      (GBps +- %stdev)
>>     pg-sz=2MB       26.08 +- 1.72%        26.13 +- 0.92%           -
>> preempt=*
>>     pg-sz=1GB       26.99 +- 0.62%        48.85 +- 2.19%       + 80.99%
>> preempt=none|voluntary
>>     pg-sz=1GB       27.69 +- 0.18%        75.18 +- 0.25%       +171.50%  preempt=full|lazy
>> Comparing the batched-pages numbers from the boost=0 ones and these: for
>> a clock-speed gain of 42% we gain 24.5% for batch-size=32MB and 42.5%
>> for batch-size=1GB.
>> In comparison the baseline contiguous-pages case and both the
>> pg-sz=2MB ones are largely backend bound so gain no more than ~10%.
>> Other platforms tested, Intel Icelakex (Oracle X9) and ARM64 Neoverse-N1
>> (Ampere Altra) both show an improvement of ~35% for pg-sz=2MB|1GB.
>> The first goes from around 8GBps to 11GBps and the second from 32GBps
>> to 44 GBPs.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/mm.h | 36 ++++++++++++++++++++++++++++++++++++
>>   mm/memory.c        | 18 +++++++++++++++---
>>   2 files changed, 51 insertions(+), 3 deletions(-)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index a4a9a8d1ffec..fb5b86d78093 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4204,6 +4204,15 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>    * mapped to user space.
>>    *
>>    * Does absolutely no exception handling.
>> + *
>> + * Note that even though the clearing operation is preemptible, clear_pages()
>> + * does not (and on architectures where it reduces to a few long-running
>> + * instructions, might not be able to) call cond_resched() to check if
>> + * rescheduling is required.
>> + *
>> + * When running under preemptible models this is not a problem. Under
>> + * cooperatively scheduled models, however, the caller is expected to
>> + * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>>    */
>>   static inline void clear_pages(void *addr, unsigned int npages)
>>   {
>> @@ -4214,6 +4224,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
>>   }
>>   #endif
>>   +#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
>> +#ifdef clear_pages
>> +/*
>> + * The architecture defines clear_pages(), and we assume that it is
>> + * generally "fast". So choose a batch size large enough to allow the processor
>> + * headroom for optimizing the operation and yet small enough that we see
>> + * reasonable preemption latency for when this optimization is not possible
>> + * (ex. slow microarchitectures, memory bandwidth saturation.)
>> + *
>> + * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
>> + * result in worst case preemption latency of around 3ms when clearing pages.
>> + *
>> + * (See comment above clear_pages() for why preemption latency is a concern
>> + * here.)
>> + */
>> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
>
> Nit: Could we use SZ_32G here?
>
> 	SZ_32G >> PAGE_SHIFT;
>
>> +#else /* !clear_pages */
>> +/*
>> + * The architecture does not provide a clear_pages() implementation. Assume
>> + * that clear_page() -- which clear_pages() will fallback to -- is relatively
>> + * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
>> + */
>> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
>> +#endif
>> +#endif
>> +
>>   #ifdef __HAVE_ARCH_GATE_AREA
>>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>   extern int in_gate_area_no_mm(unsigned long addr);
>> diff --git a/mm/memory.c b/mm/memory.c
>> index c06e43a8861a..49e7154121f5 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7240,13 +7240,25 @@ static inline int process_huge_page(
>>   static void clear_contig_highpages(struct page *page, unsigned long addr,
>>   				   unsigned int nr_pages)
>>   {
>> -	unsigned int i;
>> +	unsigned int i, unit, count;
>>     	might_sleep();
>> -	for (i = 0; i < nr_pages; i++) {
>> +	/*
>> +	 * When clearing we want to operate on the largest extent possible since
>> +	 * that allows for extent based architecture specific optimizations.
>> +	 *
>> +	 * However, since the clearing interfaces (clear_user_highpages(),
>> +	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
>> +	 * limit the batch size when running under non-preemptible scheduling
>> +	 * models.
>> +	 */
>> +	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>> +
>
> Nit: you could do above:
>
> const unsigned int unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>
>> +	for (i = 0; i < nr_pages; i += count) {
>>   		cond_resched();
>>   -		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
>> +		count = min(unit, nr_pages - i);
>> +		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
>>   	}
>>   }
>>
>
> Feel free to send a fixup patch inline as reply to this mail for any of these that
> Andrew can simply squash. No need to resend just because of that.

Done.

> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks David!

--
ankur


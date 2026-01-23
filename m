Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81E4D778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881686B0555; Fri, 23 Jan 2026 15:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800236B0556; Fri, 23 Jan 2026 15:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8AB6B0557; Fri, 23 Jan 2026 15:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBDB6B0555
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:12:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEA7E8C0E7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:45 +0000 (UTC)
X-FDA: 84364326690.13.7B33C7F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE82112000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sPJIiEbs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MCwHBHBF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199162; a=rsa-sha256;
	cv=pass;
	b=bZtsNd7aft493ujFe3TFLes83oNSGZ5FIit3KGj6qyWPEfr9uPhJQqj/kH2BOUCPku80ZB
	eqoDrVpQ8dMMzfoXcfuWIw0vVavxvKDLOYwvKqGotuZrqkcYe7rOJ9W7m+Opp1MulO/njh
	msBKN8MwvmmjaM+RcRuN/NZr8cWDLsg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sPJIiEbs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MCwHBHBF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1qZEj4V0j8DrZtu9wEf52/caol/HgW66KdTGjKsKHc=;
	b=LaGcV3mOEX0FfgcDVhf2Ydfc35lYxXUI4y2Wv92tmLIu+Yk4CZeUaKWQbB1lL6MhWPd3PX
	MytOe0Eva0HtHSIVTInBS6Us1GM2eR4WlrJrgFpoGIkuiN+XwKez0bYWpkocGBXHLH4zWV
	nAzTQdIpYrgBoJ7gF54axvPUq/YpyNk=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NDuYi71631761;
	Fri, 23 Jan 2026 20:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k1qZEj4V0j8DrZtu9wEf52/caol/HgW66KdTGjKsKHc=; b=
	sPJIiEbsBsGJx6OtjrSYFiw4fO127nhDlrbFWC3ZZ8S1bmBNTJLzNdDl5w+8n8DL
	iEB4Hjtowo3JKSTyTPo2DXjvdc3NyW/G5GiuRSMCU/HqtqLw3FA49gISdvS+yMB/
	gcID6wAfRT49M0mFqI++O8YAW8OelZtHb17G7FsHY2NPvZRRTqUN3pSCZJbr9Ayy
	uLznSLm0yPaATvyPmZuWOfw6HQbIwbHHXJCMBfAz1IAbXz4UaoJRoO2uVp2Dey2E
	/bjUkr1/7IBjk8nUANR9seyhZ6M7RkNj1j6Ak2noY9LTbYgCjh0KsuWjqSwugm+2
	yvRJcFuhnB3m58v6me30vw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq2ysh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NIYFT3015062;
	Fri, 23 Jan 2026 20:12:31 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4butv0w84j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1dwrKZAQUUN3mCRp5syf1Xjt+zOXxeCKN2FVLmMwuDLqprCSsSEUtoBJoS5hCSDZPbY2HX4kIECmQaCcbbW/olEZTUZmppihdFQdIseEmse0RuJFIvUVTZrR2+gWqDQIXLhb2HsCcnAQ+DwfZT48H1S769qJlWAHUYhPJ/kMyawKG7HtExl1nvLSexmiKnTK9O49lqMihlyFTcn7ZGCfKkM910zUbvT51fM89d8YldBL0cfgTW11AdXbIyA1ZujPgN1v7r1IYXPz/mSqszaL7G7p0xk5xN6RuES36Cz2M4vpeiQokYY05LR8S52/0H06liGiuj4Nmjf3ZcxJiowiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1qZEj4V0j8DrZtu9wEf52/caol/HgW66KdTGjKsKHc=;
 b=KMd+G/K03SrhsadMBRjUtvDCmz9AHyLjsOovzFCQzaokQ8xxXYE30ek1qTdhFCVlzLwKoMTbsyP9mgLXRCyR4w9NxRB+2gOayUL+9h9h2/C4XNIsPkJSzj5qW/JutN4HNXZ3O5s6HT4JrJVJ8yPDRaCkX7uop54xB7JG5eTYXGCgsPke8AbhoFH1KmeLMcWMhbTwlEykqDmXjnJXY2hrXjeCoVIjoz9wJWcKeh0HKqLNTMfOG826oathpQuj+ydaYrNGAd9bu/zK70YqTgcyD44/PROgHVXquF8DSjR7C2OWC5yORvI34vF65p04iDmmj+YnEP5DLzk5VxYSEYdnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1qZEj4V0j8DrZtu9wEf52/caol/HgW66KdTGjKsKHc=;
 b=MCwHBHBFYscnDvUbwo/2j2cbnPYvyNZtcQ0vHOY9cFOm2Fg6+PQ/ogqxfsv2MppiFWAYDBGkh5Q1xTY7X7tDRdtAPE8CQh3/G6ofrcz7E9x2ndiSCBZEwaflQaoS8tIkiryaZlFShRQeJQwLUK+imVehkPp31fX/k6n28t9zxiM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:26 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 03/10] mm/vma: rename is_vma_write_only(), separate out shared refcount put
Date: Fri, 23 Jan 2026 20:12:13 +0000
Message-ID: <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0501.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::20) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: 12518456-3b19-4416-1ec1-08de5abbba7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ciZ8mbbummgiKv2BDXxMc3K2EBmctSbWH+wvn9co5jHnK9Ye5jh+DtesLWSt?=
 =?us-ascii?Q?lg6l2iZNPNq4O8s54LCoD4DBTn+LkoGGDXrhyEFaYFsLDWEGiR0wJS7Ou3f7?=
 =?us-ascii?Q?3cDtPCX9dCBEG3k5c6KZhx4VXlAKmtCeOFQmcvY/+bX9ZsPnD3y3SSBKelbx?=
 =?us-ascii?Q?N7DbGZ1assu6nOO+IaeAlgvRnogvWTlYOvdQweFJU4qqGZ2HTE6KesPnYipQ?=
 =?us-ascii?Q?uLTfZ01k5JaL5gzcn+Sy6ldJh8b3owgkAm9MQ6bj56LwiGnLUSJ91OYsH3u2?=
 =?us-ascii?Q?UK0t5uUPXJuFIgAS3GEKZNae7451qu3tV6fQlO8eIhyZafTZ2BpRSusMxlm1?=
 =?us-ascii?Q?YtuB2C2frsCaReqhOTCuFQzK4S2z4n3GIM0PaQ01EcEnDJcEVvIYhDx/3dqT?=
 =?us-ascii?Q?DU97WoN2b3NfrUr6lF2MwD3f0XjI1FRtzDeiJDXf3my26o3J7kKG2CsDN7KA?=
 =?us-ascii?Q?SVMglEbW7f/07o0MRuf5Xrj3z34F7pC8UJPusD5sEebxKpaVJaNOpCnHslPn?=
 =?us-ascii?Q?k4xJcBv+Zff5hF40tjVMv8TGGZdsOj3a4RpKFiv834nm/YqxRctyGe0CEb3N?=
 =?us-ascii?Q?GnbeIAWhYQh8U/p0pWiCekORho9DjLS7WQaPBWdwKGL97mTX9l8GXoBhlt9Y?=
 =?us-ascii?Q?V8ekyWSPquiwcg0D8QpJWWdRepsvfTAZfcQS40b46jyJxwCbFZbTwWBiB3iZ?=
 =?us-ascii?Q?7oUa3IvdgeK3bhodFPJhjR/jj+DYoJGgMg6hXchcOMKKsBuDldK43r1EkDPG?=
 =?us-ascii?Q?sUaMaLODgXlnXoapdnVFhCzAQPlPk5xDhhGhOf0RvzlHFQtpwhqDc7T1Q3To?=
 =?us-ascii?Q?eiYZ26J6Srs3WosmvmUMb8AS0p8YLSfOyxqNFkgMgociVlQZgDT9E2U1djH4?=
 =?us-ascii?Q?Gh7+At0u7D6v17Qr1VbPfThS/qZJlrYUdI+qbhvUeuJK7dAjgadhYMSL8nTh?=
 =?us-ascii?Q?JlkXnMLox8T1zqfjq27BVh/bwMFVrd/tAUwHIaRNdAB1Gs88lk1loK8Mw3ay?=
 =?us-ascii?Q?plc/3ZTv7ncRR7lraWhdbJu1xfV4yAuLC/lW2Lf1TRfLe69wvZYHS65xBIGC?=
 =?us-ascii?Q?dlqUAFWy0hMwTukxKS8smJPKEHvpFkyAO4U90ZRVcENvK6mpJYtcOIceDK0p?=
 =?us-ascii?Q?/HOlnts3vam12FsfgE/9XcKcKtgVjT8QfVtfgTLVq/Paxv1NXHE8adOaC8vt?=
 =?us-ascii?Q?k8r934fIks0R8OaW14c++YubaZRttEwXMECDUbMNv1BdciqtnoPr/q1S/Uv3?=
 =?us-ascii?Q?4zOYwQe9tJYOw0W+t0WngWkfD/36Tsf8ALxpxm/F4wBki4AfgwLWbQGHAIQr?=
 =?us-ascii?Q?z/hltYaoT46fOXiLbXfZ1+20qCb9zN2xf3N/4CTuf6vQYQHaSkb0KYBze3kb?=
 =?us-ascii?Q?5nJINw+P8ar/MdaOslgEQ4TccUrfSRh+NbcXwEYDihUC9DJbXBSYMopRGojb?=
 =?us-ascii?Q?5BZQsHqdBJ7uQlVJOYzUxpkd3yqhUKV776ALYpq/x68tjafj72bokLoyUB+n?=
 =?us-ascii?Q?L++vJfz0Vfj15u2UhEDqEwySZrquH4gFfUSqtVZ25EFUQ7y6tcEzirJmmDnl?=
 =?us-ascii?Q?oWGV6hIRsDuKoYwiUwc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ifg4HoSFGsOv5uRPuM2SXkQxC1kSTw+mAPmLIcL0Wshqo53pD1iukgVNgzv5?=
 =?us-ascii?Q?iEN2xjy9O3QHs9cRNcoUx5kdf1zFsCtSR41Np6woVEzNe5NJg1k8J+PTHHM4?=
 =?us-ascii?Q?2zkzfS4yD9I+V98g9WbAiq5/y+4lVCXHYP07QfqvoVc84XbhZdodN6lQ/vYw?=
 =?us-ascii?Q?dCBXIsSvuZ/osTQGQhpU0U+AmLn+4ElwBSx/+xF0yyjoknuTh+IW40pTwbiw?=
 =?us-ascii?Q?jAjQbpKK/yiyR2xZNhJimol2Z5Mcbs8G5G/P3CPg6FamB7lRiQT5bQ1QGWzX?=
 =?us-ascii?Q?vzH4vfBOTEvw1UAd/jrjYa+nacbplvkXHIRe1hrWUyl+kkURhbqoKPggR/oh?=
 =?us-ascii?Q?0QwTKZPpTcI7m491XvsjHmDK2LRdhTYh1Il6QjTKAB89AmUwT7LBevtntbYQ?=
 =?us-ascii?Q?okfCduhhOauDHroWoyp+Cqph8UGwtrsePLyWTHMH92YywGvyfMoMqjfVFlIR?=
 =?us-ascii?Q?UhFvtMwAHg6+I+Nzo/JOlwV4Cii06ZFrY1A/188605zEAIhqJV7Eku2djZfc?=
 =?us-ascii?Q?2CKgyXsFKdSZWD3pxEnOHRGmllhJWFeDU0+WTJZdOEzsq6VZfJVH5Iovh6WF?=
 =?us-ascii?Q?nX02axih9gO4CmOEU87zB7ZfF3Euf2mlywkgUmV3uynEPjoQNNXiFrCtd+eA?=
 =?us-ascii?Q?7CZMbptCGsejep3ww1ALTd0Xf39FTHr4SEG0MDZRRAKRU+AcLh4+R9TPJN0s?=
 =?us-ascii?Q?YY15Zz3K26oAHDfHBC/mTHR3sskHdFNw+kT1RCuHOv2yRxPQ3inBo6OAQXgb?=
 =?us-ascii?Q?BKzavlg6Rhbu1E+0ov81sOUCvr7U1Du7KC5X8KP537Se4DvXJbPb4WaBrwIY?=
 =?us-ascii?Q?dFrFSxUYsv2hem/PGY1v/C+z0OmUaNiD3K7bUFr7AMgYvDlJW/EV2JzIfvqA?=
 =?us-ascii?Q?vRlUqxO847lWge93FtSkloeeTVD3gqnAIIdEAwVhwgk0fici/Bc+o4Zcn2p8?=
 =?us-ascii?Q?ti3SqATzZx9gJSOgQySiPraa/k48f/P5zjDzsmBY9nPazd3TsqXenGhjx3M1?=
 =?us-ascii?Q?mp2c59rkfxqLEpMph7ZyIaw5FKh9ebUsg2jDaT5stscS2z7v0Br5aYWsLJUv?=
 =?us-ascii?Q?RUseZymNfhTsYTxhQMxWQhWE1ej1Heq4auPx7dSJ2cVzF6CNLYskiTZkxKw0?=
 =?us-ascii?Q?vUjvWCsSUtwXjauzHjxzTSuGjIAr+Qu4jSGnnpIC36zzaM8Ry1dluyS7DIDB?=
 =?us-ascii?Q?eXyIvX5JPXnsMJ5c5mnHE1DAbU1lG1FltwreQ/Ie0mZYGAgCuz7ujIwH+IJE?=
 =?us-ascii?Q?C2wHJ7BA4A8mhJCDw3rhZouYEUr8eL+wfDz8nFwxU6vaJ23s4FIgK45pjzq2?=
 =?us-ascii?Q?LB7jXTV22XOWJs/QmX9jK9uvED7i6lgDLlUbRk/HyeF3KsBdh28+4TEYKwUw?=
 =?us-ascii?Q?UBHxHVXcM2VaM0f042F2ipZgmRyID/kU8YX6D31T8m85+Dp7J6EEl7SAWAM/?=
 =?us-ascii?Q?m0bZ3uS5Fx22Ix5MfeN9icF+rczdskSDhosPR8Fsy5xOMUO9+6UC7DI3rOyv?=
 =?us-ascii?Q?m3pHByaG8YLBlnv/+sRQfqZVmqokvwYQ6IrCxffG1rSCH4ht1owsUNebaUKv?=
 =?us-ascii?Q?95vI/kaVm3oGCJmxGMYkmmfCf2KvAU4UFwHxuB2K/v/kHLhVRHoN5qxEACGM?=
 =?us-ascii?Q?N8z8qfeqqBXuT5bamSJCXWvvlApgUuMGxn0YUVqBqKZtABVg9x+/lU3xvGuv?=
 =?us-ascii?Q?KvSj81PWX6vkyimNuiUDjARTRlObaqyjG7gyvbaS8RqNIn9YDWR1JDEtQcw6?=
 =?us-ascii?Q?lKXu1zrtSqXdfYVvkt49vyMggPh0hA4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yRSXcY0M/WDzG7IyzDMDRMSJIa4Hjxl+XkNTB4UJZ4kZjG9H/wctNb9cygaPfNwogt6FY1T8lgVpyydE5vgOC5QgDCjf+AXgmZnK5TigE9AuttU3MaOdQw/axmDMcxw34sSDH0MdQYy77oFEUTv+QnT2WVrbDTW5N6CRW93EmWUHS/zgPW+K8K4Z1vBXuxTs1FR/2fcQG+79rdXlUSz0bTQOFXIxEX+aVCrXeego7M3hcyyjpl/VXy8E6N69LZKt5yonIK95QwSSmjtb2HcX0VIISu4zHyirZ4LYRFeFnJxxEmpWjv5jul542ZYs1FjpSP9s/gHuGXx0MA/NWssGX/v27u8lLsledntjLKAci6yKSo81PR/RWdIfyimcJiWZjqyLc7dP/g6+I+7tev6QsjH9GtGt54YcZ7NdvBrT5pu7Ldv6/5zA3xHAW5CyuKtEdfOFsIWgw8CyCCPlqWzosdI9NFn2qOoxjGRK4tLKiT13PB1cg+4MS85XDhjZQxd3FHkwXmOD/TYMxuHzGtoPAzkBsg3LxTf7R9RId5oPMuHzez3KMTzmaMwRrOU30l0dsPb0VpsRgOlm3mWIjGzzvv7X80TOf5v8kCBaJzf0GKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12518456-3b19-4416-1ec1-08de5abbba7b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:26.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExKohtzYJj0d6HAYB6Nyvhqqjx4v6DlxgF1YYEKBU+dGyx5NZNVrtuIRcwUpmhflLw0s1SMCYvCMcF8jZxuM+bBMhR0xQamx+rA3eABZVG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX2dzTThTH7BPa
 2ccOBxgjJIiu55vO1wnZ7pImevsXm8oZ/Jhh8NrYClzOHoQDWZYDViXmf14jfdTHmhpObSyXLiv
 +JNuQL077zKYuXeVK+fF2GhpAnIO7seOlyno1XvwS1TzEoJbJyvab2KT8pBtAXTa1v7et/j1nZh
 0T261B4KHCbeCN85gb0LHYhssdhIpQ2E2DUs3kzvuwWg9iHez/tG6jYosWGAy3w/O2D+NsWpx6h
 WlcqQLbJdfRl2D9lKTuPm/fprzql2TYcB8kpwVHo1/nFsgBsHmw8JI+IBVjXaFEVhqNBndHZYxX
 kLUPJ2nLS8NR507CMFYH2RpMAb+FkxBFDAMnQzKn2VPp1wqqzEXw6oVVH466oR1JJr3iedYmhtb
 hctbVUgegdaGZmq+UGAp6X6wpBgpfQwRkvtOS3AJJU1MiC+PIJ/TGhv6bgPVBRnqShDFBDVa0AO
 w8vwqxnLepj83JS94ig==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=6973d630 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=CKvSG63ff_v9dp8pWWQA:9
X-Proofpoint-ORIG-GUID: dalFBzzzyKY7jdGfSaQfRHyyJ6BdWHH5
X-Proofpoint-GUID: dalFBzzzyKY7jdGfSaQfRHyyJ6BdWHH5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE82112000B
X-Stat-Signature: 3zouau9cn4o68ktu3j35h5g83519w771
X-HE-Tag: 1769199162-631218
X-HE-Meta: U2FsdGVkX1/xkOdA9c2aisQNupQwzsSGohSxoKxOduBG4BJfbmHp/3bwiOczfFzVHfpZkbiQ0YGX1w0/i6AspkyAeTL+i9M2nL9fyeRis2wzTSwPeAZ6Eiwb5CllytWwhQkPnvKCVXtCwSIIZYMcW5NVj/lrwHT2Qpl3uN5WZlWITya20AF10+B2OWVdovgGVNaNH9vhLuYT+3mGKFTALPjvrxlAXxVIcatidn5JKmdt0UWhdOHSS59HMZ4kDuXHUESaXMLtDWTjlYw32XkgOOfuU91xtcypiynfG13/NruV2ptCcnTjqCJeuDePAJJfj7ki2E7GI/Ii8tQ2+/zQu39CczWaCEZytfQ9V3EY9IEfIhTxcRik/NuSGBABCXAjpcAZ2bPWsRJ5UdenrF+2p8SNVhBvjbtqSBePL/6Qnyd9tVX9aO0jkvAzQBwLFjU1cgy/K5WaWSKnDMbQEO/mBx0OIyilGEhhrWrzLb18MznQvIvyRrNQtCm6c2WOVJdRwaQ1+wHWOcyP7mnmM960uSvREQU17/tCLJBSV75Ys+y6YzzsBZBAodzIaQkSRuzJGW3UO7bpDCCmO8qH4gPX8AcoYIyExtS94WmMa7b/QEZpaQvfRGaaOe8gq7/0dI59JQns2tQy6o0py3guhCL1WYPbfSaGGFA1i3sUnugPj6M8ebjJejdpqI6R1ULzGSbajGzKFN2rVSfX6HRu8yVjjOywyYtQAujAT8X7dIeWOLQ39syhzhAM1tXlpqfA70dI1D9IoJw99SJZ2SxO/1cyxQWVpuvVYsrshffU1DCYCADiWOrlAbJYjWfjRuKS7vnsEe8lkZ4RMyeAovHkK2fKZiE8qD1zVonCZ1RPKc2pm+I7w0BuQwwUYqWsY/MEMB3Om8V1mvgCOzwYvzfpdzjG93PR58DhCeiqtJSoTvhWDJLvurWPWqaQsPMLxpUDiKY6sNsglJk1CnvvEuBHvRj
 c4bDl/bs
 WwEeIZQlw3LMnhlMf4/JgRPazb9hCQJugoouByJqF3iph0n48x6xMQAUjaMW39M7iwWhW8wo4oAn6Zyx9A7n4wWvaUgMzjLp63lLjdTmyCKkOSGl7CgLhf8kqnjIw9ZizYx6Sp6KLNoRVyKpDsnbiDyDSzVa6feE5rDKnkNFjUl6ZtDfRcHKkAbF7O+8n2ptN2juh2XBUytg+Ajo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The is_vma_writer_only() function is misnamed - this isn't determining if
there is only a write lock, as it checks for the presence of the
VM_REFCNT_EXCLUDE_READERS_FLAG.

Really, it is checking to see whether readers are excluded, with a
possibility of a false positive in the case of a detachment (there we
expect the vma->vm_refcnt to eventually be set to
VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).

Rename the function accordingly.

Relatedly, we use a __refcount_dec_and_test() primitive directly in
vma_refcount_put(), using the old value to determine what the reference
count ought to be after the operation is complete (ignoring racing
reference count adjustments).

Wrap this into a __vma_refcount_put_return() function, which we can then
utilise in vma_mark_detached() and thus keep the refcount primitive usage
abstracted.

This function, as the name implies, returns the value after the reference
count has been updated.

This reduces duplication in the two invocations of this function.

Also adjust comments, removing duplicative comments covered elsewhere and
adding more to aid understanding.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 66 +++++++++++++++++++++++++++++++--------
 mm/mmap_lock.c            | 17 +++++-----
 2 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index a764439d0276..294fb282052d 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -122,15 +122,22 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 	vma->vm_lock_seq = UINT_MAX;
 }
 
-static inline bool is_vma_writer_only(int refcnt)
+/*
+ * This function determines whether the input VMA reference count describes a
+ * VMA which has excluded all VMA read locks.
+ *
+ * In the case of a detached VMA, we may incorrectly indicate that readers are
+ * excluded when one remains, because in that scenario we target a refcount of
+ * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
+ * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
+ *
+ * However, the race window for that is very small so it is unlikely.
+ *
+ * Returns: true if readers are excluded, false otherwise.
+ */
+static inline bool __vma_are_readers_excluded(int refcnt)
 {
 	/*
-	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
-	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
-	 * attached. Waiting on a detached vma happens only in
-	 * vma_mark_detached() and is a rare case, therefore most of the time
-	 * there will be no unnecessary wakeup.
-	 *
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
@@ -138,18 +145,51 @@ static inline bool is_vma_writer_only(int refcnt)
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
 }
 
+/*
+ * Actually decrement the VMA reference count.
+ *
+ * The function returns the reference count as it was immediately after the
+ * decrement took place. If it returns zero, the VMA is now detached.
+ */
+static inline __must_check unsigned int
+__vma_refcount_put_return(struct vm_area_struct *vma)
+{
+	int oldcnt;
+
+	if (__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt))
+		return 0;
+
+	return oldcnt - 1;
+}
+
+/**
+ * vma_refcount_put() - Drop reference count in VMA vm_refcnt field due to a
+ * read-lock being dropped.
+ * @vma: The VMA whose reference count we wish to decrement.
+ *
+ * If we were the last reader, wake up threads waiting to obtain an exclusive
+ * lock.
+ */
 static inline void vma_refcount_put(struct vm_area_struct *vma)
 {
-	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt. */
 	struct mm_struct *mm = vma->vm_mm;
-	int oldcnt;
+	int newcnt;
 
 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
-	if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
 
-		if (is_vma_writer_only(oldcnt - 1))
-			rcuwait_wake_up(&mm->vma_writer_wait);
-	}
+	newcnt = __vma_refcount_put_return(vma);
+	/*
+	 * __vma_enter_locked() may be sleeping waiting for readers to drop
+	 * their reference count, so wake it up if we were the last reader
+	 * blocking it from being acquired.
+	 *
+	 * We may be raced by other readers temporarily incrementing the
+	 * reference count, though the race window is very small, this might
+	 * cause spurious wakeups.
+	 */
+	if (newcnt && __vma_are_readers_excluded(newcnt))
+		rcuwait_wake_up(&mm->vma_writer_wait);
 }
 
 /*
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 75dc098aea14..6be1bbcde09e 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -134,21 +134,24 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	vma_assert_attached(vma);
 
 	/*
-	 * We are the only writer, so no need to use vma_refcount_put().
-	 * The condition below is unlikely because the vma has been already
-	 * write-locked and readers can increment vm_refcnt only temporarily
-	 * before they check vm_lock_seq, realize the vma is locked and drop
-	 * back the vm_refcnt. That is a narrow window for observing a raised
-	 * vm_refcnt.
+	 * This condition - that the VMA is still attached (refcnt > 0) - is
+	 * unlikely, because the vma has been already write-locked and readers
+	 * can increment vm_refcnt only temporarily before they check
+	 * vm_lock_seq, realize the vma is locked and drop back the
+	 * vm_refcnt. That is a narrow window for observing a raised vm_refcnt.
 	 *
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
+	if (unlikely(__vma_refcount_put_return(vma))) {
 		/* Wait until vma is detached with no readers. */
 		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
 			bool detached;
 
+			/*
+			 * Once this is complete, no readers can increment the
+			 * reference count, and the VMA is marked detached.
+			 */
 			__vma_exit_locked(vma, &detached);
 			WARN_ON_ONCE(!detached);
 		}
-- 
2.52.0



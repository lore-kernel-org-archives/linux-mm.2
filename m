Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D5DE6BF3F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 22:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AA76B0092; Fri, 30 Jan 2026 17:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C156B0093; Fri, 30 Jan 2026 17:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E09C6B0095; Fri, 30 Jan 2026 17:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDF416B0092
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:29:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CB0559619
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:29:12 +0000 (UTC)
X-FDA: 84390072144.13.962BDB9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE8BA40005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:29:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJl1aY9U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aTtvc5mc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769812149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij127MjH/23HQH7siD1bBvxIFpCr1d8ovwaQeRj+ZqQ=;
	b=lgGwGxw6lH/7YQT3Z1uJtbdQs6BphQekW9pPZpUaNzfrqcddpMAUxhruWEeayf4D4+DfqL
	sQMwM32Gl32cnYTmLfqmUchjhvzopkJZtVgzi/m+ohnZ9fDqc9I84/Ptl7D06BSnGj8nCT
	WDNNCkMutRLU7XaqwojgzNJwOWRDaN0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769812149; a=rsa-sha256;
	cv=pass;
	b=k7okOVJKrkdGMZAdmNM63aA2gH6HUBLKkyy9rACRGkXN3IkdzQm0uAaCm/G5BZdz9MpA5y
	M2+308eJ6x1c0F3JfGai0e9r74CUnGDDs7GhWmPgp0KVXasK4LItxR7J6Umc+tr2oo3MpC
	gh0q09UA0ThGhGjv8IuB14CaUlL+qSU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJl1aY9U;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aTtvc5mc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDWSX3338239;
	Fri, 30 Jan 2026 21:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ij127MjH/23HQH7siD1bBvxIFpCr1d8ovwaQeRj+ZqQ=; b=
	BJl1aY9Uh2IYKr1OyHwd24bFhHZN+hhNP8DzgOD9D8EIW40zz+L9Z3zvzOBIl4wC
	q4lwlQs0ltMovTmQgw4SRvLiAXa+7AP9utQvX9Zm6Rkw/r/lnEuHAKEGzLy2rXOE
	HvdejfC7pK4dk039BcIN6YEWwmAOGdHtZ1ZQoqHNHgcdPGAKRKOFyMPr0bIQUurm
	97FPyg8iOozntBMKOqXsBSkQbNkE8UZ9RmYuicTpgwRRJcp7NUEmwvgPrfbRFaEz
	Bqgt1kgE61w8gdCLS7H/ia8xx47BlOTkTJwJ6QRraZbh/5i3/bgkRW/tZmuXNjC2
	/OuZCakGiyFZkhHapKCmLg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by39rdw4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIlbpn012598;
	Fri, 30 Jan 2026 21:00:49 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5h8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyn1o5shLfO7RLuHuKMZbOUtlInNr6LxdkPaFixlEXNGVXiks4LaSxrgkagYn5Gq6debfzKOpA7VFAJng/SYDDAbwUcYRiEIOvTFhsKYMj0SPDQXqcx+fV7rxQ6lBPQrp13+CSeZLe2Rg4Wd+jMbP26hqOn7WBl1l8On9hHF70ZarlQnUUqTL2W6snRSr0C8J6XZr8qAWoQlq3YjoMfQdV/iZTR9BD6UOe0If56LrzmJyDgz2ZAWE7QOqeakcVTtXLwyNDHxwZt+L4/vUKk2W17mZzIXrOIOPGhsMhiJ3VKsghiOmofgCavaCVZmgWs0iczGc7uVSSkBiDbIshJKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ij127MjH/23HQH7siD1bBvxIFpCr1d8ovwaQeRj+ZqQ=;
 b=H8Kn35fj31a4gBN8oS0U98ZfPAaNeqjj6KBMwoB52aoBduUc5EHBEfwY2JB0PUpA5OQJFxBJpa3FO8WXKAjhQow0AbpNzzDRDaFt/Vj1YcFKr75FY8MBd7I12xWJQ5btz/hx4sSKdM0J2dy0qt3OObmAMYhwk480BcInxtpAFYhGizmEJ1iEZ8t968r/rGzrds8ITVezPL0wWGkTOVlNkIoU/jMR/8XxxByT67gToJPbf2GjfprydQARSiTKR2JyrijYldSHowdWKMWcZRe/jhf9XsozWO1oJfaGmdXVGTShoFd2B5wyWxrPxIjGhp41A30TTAZDy2zdxzJjtE5r6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ij127MjH/23HQH7siD1bBvxIFpCr1d8ovwaQeRj+ZqQ=;
 b=aTtvc5mcQPbjrJ7Oe1pzWrah7EK6uknQhArvN4QRviUIbezX20MW3BvkyFUExHSor/hfZO2AQ/oCbgdYmfjYPoZeY8XoF9jF2gq6D2kwwJMatkBbTnkn2KDrdsJZi5M6CKfTCg+z+1Bp2lpMEZzpDQ7scFqISBRJSLUWDSviytA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:46 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 22/30] maple_tree: Use maple copy node for mas_wr_rebalance() operation
Date: Fri, 30 Jan 2026 15:59:27 -0500
Message-ID: <20260130205935.2559335-23-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2da6b6-e4dd-4894-11e7-08de6042a36f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qqQY5ijS1Y6lZAibZTKJ2ntkNIxPERB0hhhUeigOCyRC9vRUt7OFTLe38RzT?=
 =?us-ascii?Q?qILiWxvccbd042Lo9LX1n3VdmWC7ZACWK2Dd2cDpq8hE9rmlWJ5IBhmRT3zV?=
 =?us-ascii?Q?V4KlSmFfqhsqZB5laRvyFG3Ukt03XTC5Nw7ecWxaq5Ylbyj+THqk11/CgHRR?=
 =?us-ascii?Q?tWsK3K1frYW9SqjHs77CygAGBmH8TOHY+aC+g5LtJ0Xhpya1ordniREUlBFV?=
 =?us-ascii?Q?td63cu7IZSVLstGEosBtjcwUjFCtfCpXt7juQ0HiuxMzKt3rczDwN6iqjs5H?=
 =?us-ascii?Q?jutuhjs8wTeldl6DiRJDEDHuKfYu3Uskt74JFHS709LzK6+q96yzuQ0pnmTC?=
 =?us-ascii?Q?F0wcvYA9uFtV9zMt9guJIwTKsFiBP9bxwY8+yNs6P48iD7Ps8U+ODurG/2vx?=
 =?us-ascii?Q?zGqVg0nhGThCPAEKCJY7DfBx4YAUYpinCS4sl/yBuBVpsO0ib/LoMGy3NA1+?=
 =?us-ascii?Q?vcZPOODdktDoQoD8YNSfAHWoaNl++vPApI4raoj0inAD6cw6JEP9c73zUrtM?=
 =?us-ascii?Q?eGgfwxLeqOgroz8sWc52Fq1JfmWNStfEHu5cupRyNeM8X1wey7DZejdlhBzF?=
 =?us-ascii?Q?fw3kTY+vNUAt68Z8seYt+Yj7Dc0z9GL6t/i9uf1e/YmzDlJX5eHz/ZZIPCaZ?=
 =?us-ascii?Q?vanWu8xqtJ4Ukxtb2+xCyiLOcVMcn/v4h8NzNGTUJWDmGHULBg6su9vMm/BE?=
 =?us-ascii?Q?kJtNyF7xHAHb6URaH8ynsOJrhlxV0uQKy5MpDF0RkGrq6E6Az9At/8SO7fbb?=
 =?us-ascii?Q?rL7RK5kdFazMvT2gXKaD1f0zHWWnSn1QtUoisgPWVjhyJXREIWliQSoIAuYi?=
 =?us-ascii?Q?JGzstmek45YsFBFsRBu8Gz6ah3wV+5hMFEJYhgAhj5YovazgOThVvoAK4C6F?=
 =?us-ascii?Q?BoiTaATgL2VZ0pDRm3mc7MJKkPtUkSlEcqYPhFk7TOor6QtOH6HJmQHC28c2?=
 =?us-ascii?Q?nGl29ZmkGOQaTE9FuoWcypdSBqlb02CPapdDX48fN9NOo6cz7EsyqCJk10bH?=
 =?us-ascii?Q?4Y1599vrxn7ksisUOkXI7A7VD2M4fh2lfqB0Gwr6GThb6kq8r1ROC55LBJ+q?=
 =?us-ascii?Q?sszsrwSqvKZZwitY+2Ir5/5CvsU3T5VIu8EQtw0xu180PJDAxirYBURdUXIG?=
 =?us-ascii?Q?CoVL5Gw2lhHSHJ7CP/GK2RqpsNEx5GAGALnOPpxN5Nd8hsfidYYM53KQvJhS?=
 =?us-ascii?Q?i9wTA3cwtP2sfEBaCeU9El4PWKwHHJ99wndIJDEeyVKAbguLD028C+L9znkr?=
 =?us-ascii?Q?oIlOAUvsf5lkLEGzLJtA1MRWYouiGF7Nxb5VB98x3vV+PjbiaaKQ7EMn0zo6?=
 =?us-ascii?Q?oMfwKcMyqB1BGNvXdXUlcC/lSrp/QZmbat3PfNvdSi3Dcn4vaD/jpu7P9bbS?=
 =?us-ascii?Q?2C8zn9lqrM1LkSVFNPwQDOtxBIBFgvUeoRlECVG8BMRGliIL/6o6wLuhpyvi?=
 =?us-ascii?Q?iN7KSwuGpN8hu7/gso6F4OiFW1hfAqX5RA/Mlfbr/JlEmwiCgLHMUl5Qu36T?=
 =?us-ascii?Q?VE/KdUkDogPNVlLTtlWcQtwBSgoCgYBtiBRZGFnJT+MGkTrW6khri+BRUlwR?=
 =?us-ascii?Q?juDKPWIBsUMZP7v/zLA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6KPyFoAgp2a8e86W9T1oVygDOs+Mg7vU7DqFR+IFMyqZe4bDfKzF5R4m4KEm?=
 =?us-ascii?Q?IHXyxPYrwshnAdgbcXfVpzdLlOirnyiUzLNO+oBfxACStSBo20IxK9XxsjW2?=
 =?us-ascii?Q?5EulrQKuO5y8bhfUN7q8WzQPIE+FwtRSG18Syxff4GuxumBwEY1l0rr0Bx2s?=
 =?us-ascii?Q?Vcaexr16n527uVCDXAkkbR3TopZwy1yrIp8O4rDY4Sg+Y2WZGkCFhnCBwYU2?=
 =?us-ascii?Q?sQDPDaI/uY6azfn/TZ+yx8IjROy2p6L+l7zonSUndNzFcQ41H0j5x2q5m6ti?=
 =?us-ascii?Q?oSU0IjMYvO27/fj+slO4UkuqjaHbhyGNKhGQhj+2uv2RWp8RdH3yMxH/FzX7?=
 =?us-ascii?Q?RoJOQDWNQP45XTS70jwQmx4G3a/Tf6qm/3tVX+3DXfPzvB2MUfj7059yP+vH?=
 =?us-ascii?Q?XTFl0SGaybsbhdMguUOspa//YV+a9SZramklqvvJUYksQ15kibXq1BUibxUP?=
 =?us-ascii?Q?f7T+SxmwGqyq5H00NaUG51cOMdo7x20mEvZmJpAtFAbvrdjtRxnaor/Rjkw2?=
 =?us-ascii?Q?+QfQ2zXa2vIfYWWnCL1uI00fD4UarRqIc37OlKK/lTNYwDmhztjYmBH6nk+b?=
 =?us-ascii?Q?pmbESuMuSPJ5CaUrbSlubdlOkfjgtIASUDwI/5fsqurOFd0+Ijsfs/aB82Ml?=
 =?us-ascii?Q?NPRCCmRIRrP/jE7eQAczIFWQJsl5Ib1JdDT65UxZ+VzcP7leQG36gqJy/RSQ?=
 =?us-ascii?Q?FdQecPembFvV6ZjW//j5xhx7Io9xRONi7kPWG0bx1+nvyJKLjUQekSdbGxMh?=
 =?us-ascii?Q?McMBPSrKw466uEE6rbGjZUHGLsIancvyfWPMAANDErJCjOjfnz7Csp6NlxIV?=
 =?us-ascii?Q?xXLEo4T7DQSDPXXSLfEVLIGAr47fLEte8p4ezF9sJtT16zvrXn7Sg4NhjQqg?=
 =?us-ascii?Q?Zgqcu/fbX0DlnnH0kOVrJZ+01kKadgpnVUPXfktKaTn/YVm8aan/0SNfSv9Y?=
 =?us-ascii?Q?WLx0sjAZUNdGy9i+WmHP6f6MYRjOmd+LvKLh5XZYpZojAZSSucf5hUJnGBHi?=
 =?us-ascii?Q?2n/9lbXc/Xws0yXere4qmIyr1s59XNNJiypWCt56mGcl3q6WD2zGSwmIOtLh?=
 =?us-ascii?Q?PPjCYFr9IsLU/BzdP+NRGXjQjDILuuIf0n8ryPVmK8CNQCVYat/QKFxeXVi9?=
 =?us-ascii?Q?LCxfUMetHPJC5DQhZVYFXL2CvPsnVTf7TLTxYggz2xjj13/KTF8e0KWV6btX?=
 =?us-ascii?Q?DMOmnki3CHvlxlhisxuPagm2iK+gTB7Qt68h8maz7NK5iqoUJ/39k61m9X2c?=
 =?us-ascii?Q?wpxHtGVc828ngTo8ew4MfLV1S0jJ81Ms1Lo5Tu7mboPBb4aLa0MMbgZP8REo?=
 =?us-ascii?Q?kT0LlNL1QXjYqBIrGw+ZUr2xOvNwXw6ttpvFBM/64IuR6rJpteiU7dGuT0xH?=
 =?us-ascii?Q?vlGl6e92U8y1G+VXYND9A/53q9aYkyQHNvMDmGlBYhj9qiJbXeicobsdo3i9?=
 =?us-ascii?Q?1S/FGooVFazElFfNKMrfkjD+UhbuuFOTKrV1aB+1XasCBzcAM0bRqkhwsofh?=
 =?us-ascii?Q?KKYCQA53FdLUIjJy6UlqiWPrvJmhj3D4zi8tG+XKTTlN8JVMlMsBc/eC9oZU?=
 =?us-ascii?Q?zgCr3PAErUuLVwGHZTdZmP3MsZCnNfL9uswHH3jz1Ir8HgeWQxAO54BkU3Ly?=
 =?us-ascii?Q?Vc4WkQk7Foxi5O+HptE0Tm+28YA8JxB07VWEOBmYOeObUXgDOkg599OEoZ0P?=
 =?us-ascii?Q?/XawJvKTeDGbb4zGmXqdFtwJOvoi6IcPjc4nVJaNVgoBhogylfF02JUafQ4F?=
 =?us-ascii?Q?LtC/aND2pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bM3y1L8c7usy6PgcNL49wvDlRdBJ9r4PKsVBZQ0VYmzDuhPFQZitpwwt8OfzO/VrCq/1eV+ihLaGkPUmzVWmNz0UcmAUY7lt4b4xyaNxOuFjlQlxcyhwLvL1gm0zBUm77SZM9wB4QWHqlWXeWSaBLImCK9EYERtxCmfsoO0N/ozeh3Ba+tjDS7j8azvF1tl8m5G0zTf8WYYKsJEaL8wkxtkW0YaAAN3/OcqAYC89oLTmmIe7E5LF4EQdsAHTOLDrf9BizmwiqmW4f/H9jDCHTFZMUxwGuFOmvyYgfi4BKdVnH/c7U+wVrBS41NC7xroTvJQc4FFE7AR5tNK+gxZ09tuKkD4jQHGm9s/2WX9Q+EHAc1KLBcmYaPohBvVFhIi7aJy11xnrdb1T69ec9NzSKTmaS6z6dBo10Eb79RWjr1OwxnaYRHBsyCJ3W+PBmOH1yf8cOskPajzMYz1hmrrLzEwulNZA2EIrv85/0nMUXodY9KllSlk0DwkhMtI76uyV2zEdlnJLOTAFC6ahrHQSYt9l7DoYCECtfms9RiSpaK4O4YmNtcfXvI5U8T1stsyxu5oqCffxVpAhJUjh19+mAlzAu0LPIK35uoeWsRP+OAY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2da6b6-e4dd-4894-11e7-08de6042a36f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:46.0366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIhxwKSWd0YCVjDm93maLblMKXSW2alTCcqizL4F2tmgGLYBTetQwShRKniFR3mN+EIh1+PzQ8MsEDl/hoPQTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Authority-Analysis: v=2.4 cv=LaoxKzfi c=1 sm=1 tr=0 ts=697d1c01 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=NMtRElkMPdqfRlTI_JQA:9
X-Proofpoint-GUID: cHSYxCVG2foq3GY8DwhFe7TU-boT3VzI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX9z1WBtLyQvKa
 HGayjjzDgi+jq+FKoWPGOssT0rvuACr0bC7QDnvwEQRz6qYNWZT/Xh1vj+9qB3TokiAUU6xyJn0
 SBesbcyBRuCtzMjuR813ygk7nDLG7rjlnhSSuqtfpmkv/sHnOkeePIcArP8Vmz0miN5Z/44T7U9
 ysQiQxLNvCIoWAYAfzNcVupOOFHlnKRYsLW3Sr0yEIsMFtvftqPCZsib1t0Z3saVamL+WnOjmRF
 bw5N0LRuylq6llRanYsfBrO7wARTMZBRRFO+iz2eTT4AdKA/hGqWrKy7kovBg1BaHcLkNfGDUAA
 +B3U4xSgj1dFUAxkO3hXZoMwCWZGUAW3vb3a3MGgMBySo2RfzRkjLye3yTW9CRlKDCcuuJcB7sL
 u1xFIF9pFRjUq31kwq0NhL+U1UwcDM/uUUatGxYsegcdwn9O4eHXDPHH4mR8rMmZEZNYzvyKMzU
 EnZrTWEzW9Zxp2JMDwA==
X-Proofpoint-ORIG-GUID: cHSYxCVG2foq3GY8DwhFe7TU-boT3VzI
X-Rspamd-Queue-Id: EE8BA40005
X-Stat-Signature: 5zyaocoeci3ozuam4xhfgtx3j8ooszmy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769812148-356861
X-HE-Meta: U2FsdGVkX1/juattwT+RPNqfdA7Rj1ywj9nzyIHInF7ymrRW6WRZnAEKKCPSKBOQGzivfrMfwViW18GdZiCOnarI5hm87Fnlz4WhM6LtCmoz2v+0E/dmt3ob2m5uO7kpxjy0466C3/83cwByOD5StPKUCZlue+atlgAQq2YHYijemC9P7rM4WRGKlGHm0KyZB4SqO8hkXZcaziTFfiZq34tyAKfAiSeH/nXe1n1xlYZG0dCx/niB+/h00+/z0wsOUxRynQGRRbdPDrzaOOQlOdig1TyyImiVZkuyVoEjtF/HA6FEpdZm5abcPMhoOmdAcm8dFXDHjq73w/r2yYwrDcF+hRz8ssDh+NIrwHBHXcFYr2eztfJfqcQHBPVlv1cHnueqY1JIJgiiA/5Gy5h7oPSrw84OsXrXwtvJ7muZw5UeAso/T7FmoOtQQ1R0gislzKfTLdX/BgyYO583bxS0hDtqF5WvfK1mHmL4cLwpxxYekT6Fa4QfVT7p8gOAEh5ZG1E91JbnKPmhbrKNK8XbA0VytlsgT2ztA/SJ0050aDkLyWQ6kaOQ7oarBdds8FO1Ot0BbRekXP1SaQ6aofBdjR75ytJGxOxvU7OTZe3n+NCJrxCASzUTuzt8DJy9zlhxKKyygCCKb99xH8lkjbPFYe26Bs1NDQ65+trXt1hAfWOdvT893xHgLXCoBbHiemXuctNKKLhClSPe9rTkwElLZfLZmOasZuc8lbos9rEiB4Ra63qr1NIaZmTaVxMVAgCXB9GslP0YRE9MfV1d1n55vyGg6s2S79z/6OoONZxM7CJswEe98PpoSQE7UyXdYXCVJfuk5bsFJeYHdgql/qs89NHbmyMNHNYhFBac8rPVtiZv7HVV5LWsswDCtl6F9rQK2jlvFV2olH7Hsug8Xedi2JL8xxaWn746H6lPiv5fyK/tP22qab5R6EJeLEgq6OfNfw7VKNzvaVGQOcrA3Ct
 aDOQbS4i
 X2gEnQhlZKFU78XIFJtXYHL7YET8w8xE26lYU3YdL3Zc++d+bADkOpUHCCBRqWrBzqJG+89u6vG9sTE8vCaSUnys62AAYFSp86qKMDJE5z/k+VzZgYCWkYmHyG+lepWmsFWBpKGif0NIflDgOpzzXoXjtjcAYh2WkxMpF8Z4q55c1BZ4dNBYwJtTuaKXDGjOJKJ1kZw07cDsWdGBlt8jApFUFAMbSVjTbWrdE+OFVsNCjL162Fn7L1jg7JB1Ol/3q59IOA6PcNq4A4HwnlT3m0+iOxBQsVtvHvo5X8rYe6hrf8Uft4ku7EpFQKVhaBss8gciltNCSRrKTHXS5TCx9HyTn2gK3P/eDg3ywUkgkKgcVzxQbiOjX1NCcRY3L1CJ+nHaKXZfY/IX8dxSv/l5SElkJ3b+0zTcPKTd79FqF1Q264HJibRyZ6KcYXpfCLKXxtw0OxXQOGFaWmM9Nqw2//Zi4tGdjjYhkDkSUBtJndkU9WGKTLG91kPWSPkndR4VbkOQ3iJgEbej3/zWEjUe8oM0oEtMVs2Ltw9THF8K+/lAhVPF3M0UinDBDkIlUIDW91dz49/16tIrB9ypnxxQbYIV1da8liPXTqaODc3J1yxAhEYZegHZbB/NYApuqO7cVh0lvjyc/FlYn/dfgX5yulLxXXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple big node for rebalance operations by changing to
more align with spanning store.  The rebalance operation needs its own
data calculation in rebalance_data().

In the event of too much data, the rebalance tries to push the data
using push_data_sib().  If there is insufficient data, the rebalance
operation will rebalance against a sibling (found with rebalance_sib()).

The rebalance starts at the leaf and works its way upward in the tree
using rebalance_ascend().  Most of the code is shared with spanning
store such as the copy node having a new root, but is fundamentally
different in that the data must come from a sibling.

A parent maple state is used to track the parent location to avoid
multiple mas_ascend() calls.  The maple state tree location is copied
from the parent to the mas (child) in the ascend step.  Ascending itself
is done in the main loop.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 213 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 206 insertions(+), 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 42038e42a4c7e..0d5d68913de44 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2305,6 +2305,19 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
+{
+	*sib = *parent;
+	/* Prioritize move right to pull data left */
+	if (sib->offset < sib->end)
+		sib->offset++;
+	else
+		sib->offset--;
+
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+}
+
 static inline
 void spanning_sib(struct ma_wr_state *l_wr_mas,
 		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
@@ -2855,6 +2868,112 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+static bool data_fits(struct ma_state *sib, struct ma_state *mas,
+		struct maple_copy *cp)
+{
+	unsigned char new_data;
+	enum maple_type type;
+	unsigned char space;
+	unsigned char end;
+
+	type = mte_node_type(mas->node);
+	space = 2 * mt_slots[type];
+	end = sib->end;
+
+	new_data = end + 1 + cp->data;
+	if (new_data > space)
+		return false;
+
+	/*
+	 * This is off by one by design.  The extra space is left to reduce
+	 * jitter in operations that add then remove two entries.
+	 *
+	 * end is an index while new space and data are both sizes.  Adding one
+	 * to end to convert the index to a size means that the below
+	 * calculation should be <=, but we want to keep an extra space in nodes
+	 * to reduce jitter.
+	 *
+	 * Note that it is still possible to get a full node on the left by the
+	 * NULL landing exactly on the split.  The NULL ending of a node happens
+	 * in the dst_setup() function, where we will either increase the split
+	 * by one or decrease it by one, if possible.  In the case of split
+	 * (this case), it is always possible to shift the spilt by one - again
+	 * because there is at least one slot free by the below checking.
+	 */
+	if (new_data < space)
+		return true;
+
+	return false;
+}
+
+static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
+		struct ma_state *sib, struct ma_state *parent)
+{
+
+	if (mte_is_root(mas->node))
+		goto no_push;
+
+
+	*sib = *parent;
+	if (sib->offset) {
+		sib->offset--;
+		mas_descend(sib);
+		sib->end = mas_data_end(sib);
+		if (data_fits(sib, mas, cp))	/* Push left */
+			return;
+
+		*sib = *parent;
+	}
+
+	if (sib->offset >= sib->end)
+		goto no_push;
+
+	sib->offset++;
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+	if (data_fits(sib, mas, cp))		/* Push right*/
+		return;
+
+no_push:
+	sib->end = 0;
+}
+
+/*
+ * rebalance_data() - Calculate the @cp data, populate @sib if insufficient or
+ * if the data can be pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void rebalance_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	sib->end = 0;
+	if (cp->data > mt_slots[wr_mas->type]) {
+		push_data_sib(cp, wr_mas->mas, sib, parent);
+		if (sib->end)
+			goto use_sib;
+	} else if (cp->data <= mt_min_slots[wr_mas->type]) {
+		if ((wr_mas->mas->min != 0) ||
+		    (wr_mas->mas->max != ULONG_MAX)) {
+			rebalance_sib(parent, sib);
+			goto use_sib;
+		}
+	}
+
+	return;
+
+use_sib:
+
+	cp->data += sib->end + 1;
+}
+
 /*
  * spanning_data() - Calculate the @cp data and populate @sib if insufficient
  * @cp: The maple copy node
@@ -3412,6 +3531,55 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+/*
+ * rebalance_ascend() - Ascend the tree and set up for the next loop - if
+ * necessary
+ *
+ * Return: True if there another rebalancing operation on the next level is
+ * needed, false otherwise.
+ */
+static inline bool rebalance_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	if (!sib->end) {
+		min = mas->min;
+		max = mas->max;
+	} else if (sib->min > mas->max) { /* Move right succeeded */
+		min = mas->min;
+		max = sib->max;
+		wr_mas->offset_end = parent->offset + 1;
+	} else {
+		min = sib->min;
+		max = mas->max;
+		wr_mas->offset_end = parent->offset;
+		parent->offset--;
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp->d_count == 1 && !sib->end) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
+
+	cp->height++;
+	mas->node = parent->node;
+	mas->offset = parent->offset;
+	mas->min = parent->min;
+	mas->max = parent->max;
+	mas->end = parent->end;
+	mas->depth = parent->depth;
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4379,16 +4547,47 @@ static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
  * mas_wr_rebalance() - Insufficient data in one node needs to either get data
  * from a sibling or absorb a sibling all together.
  * @wr_mas: The write maple state
+ *
+ * Rebalance is different than a spanning store in that the write state is
+ * already at the leaf node that's being altered.
  */
-static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
-	return mas_rebalance(wr_mas->mas, &b_node);
+	/*
+	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
+	 * against the node to the right if it exists, otherwise the node to the
+	 * left of this node is rebalanced against this node.  If rebalancing
+	 * causes just one node to be produced instead of two, then the parent
+	 * is also examined and rebalanced if it is insufficient.  Every level
+	 * tries to combine the data in the same way.  If one node contains the
+	 * entire range of the tree, then that node is used as a new root node.
+	 */
+
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		rebalance_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3



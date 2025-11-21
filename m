Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6FFCFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478CB6B0032; Fri, 21 Nov 2025 15:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344436B0098; Fri, 21 Nov 2025 15:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7026B0032; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F226B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47C2B5952C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:28 +0000 (UTC)
X-FDA: 84135741816.28.5ABB34F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6DCA120006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKD8el7a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PTwWn7vb;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+PxyMZo8ESVi+g4nyH7y0NY0SVdeKKpekxdSRfEmds=;
	b=Mh29YqL4hXAI+uLrt7iA72i9Zsd5ZydUeHsB8tUPYMlTLk3lbMnbXj7vb5z9Jru26nfsX9
	PlwVxZfkRqRqPXRs+SgfCKsXvCVP/XYHB7E6xp/SUCkxEZwUNbHxRzp0zPKOKmvbSH8SMq
	Qh/x1Cz1SQNHslF4aQNhLHwINAH8udY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKD8el7a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PTwWn7vb;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756665; a=rsa-sha256;
	cv=pass;
	b=k2KMg45E8U2nFx3yAUoqs8kWOTeJ5150moEsDHI82kd4XnPiu13ANJkkSqaXpfucD+5VCw
	EtNUmbN6AVuVlTyrlucTFsY9EfpIM8H15wVEIJIgOEXBDPYE4bjO0S5EIw8vBI8CPBiokg
	RGvZ2T1i7CPMw1eQ3Gm3t/tW76YiXMo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEhFI6009701;
	Fri, 21 Nov 2025 20:24:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z+PxyMZo8ESVi+g4nyH7y0NY0SVdeKKpekxdSRfEmds=; b=
	KKD8el7ais6vqdCimCnRFYrDJiaqDez9PWEoq3AITrWliYnC92zC67VHQ/IZD5Nm
	xRVgw5pBBCk2H44wdKiaPGMPkaG9uxFNNuLjxnB5d2HMO2V5rsq0nzTFhwxEdklW
	QO5DrpT+2rkdOMtdyTVfW73entFx+MzhKjFpO6V5J37T3l7wewux37LNn4PyFRCT
	YTl2JyXyyLg5CZ6jiCBBDPpp7VHYwsYjnM3rCJbgZLt/qbGsNGcWbirsVV+Arp5a
	Ox2qVzGb0Y6TFDUahYDj9V824qkUGjpPLlK/5Iege44nu/+Uig1xIHpQRtRIzwl5
	SgBE7ivVT5tKSwpt7xwhhw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1md0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJ51LQ009572;
	Fri, 21 Nov 2025 20:24:00 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyj66qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZHHIrp+AFoAegLze13trn1hsz7CVNez7eAsv56Fo22Ww6XMbdKgf2h6OX8MpyliDANtElER4P8eD1EqApzx3aUJWHg7jMI4m4r9eoFKgSmcGB1/uFMGFC77nUS90SaWWvQwGM+LeUw+MwwbLe4UAAQSEQoydxUo+v+jHxPNx32o8eED86xIdBwPCZCSnsXaz8V8OEFHcljCJDQZWvKdzfYWhyXOMLHQAPtAySraLB+hE6iUgf7Z41Ra9wfr0fLnSzIzqWAIEjyQ2Y3bVruEtWR2KeQ+ytsU6AXwAAQv8AeikFDVfZuyQfSuG22foXN6vlo/A3zu8yPizADzD4FQXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+PxyMZo8ESVi+g4nyH7y0NY0SVdeKKpekxdSRfEmds=;
 b=I97ORNAEnaxyRn15PRM24wusr/f9CGRz2IC+eNeW1Cem/lCcykrCSrZDOpZqSj0VXNvmzlFnUdT04RAauhh+EOeq3ROQIS0GfLcet/0F8mOuuCrDeVWD46ySQw/4YGFEOkGXSlACeDFHZYY7SGj5UABlLDv4j7DVyUa2fs2WdmTbFHr7Gr6lbq3RWrDnCA+IkjdXas6RC+sNt7YAPF0E3DTLjd87HWfPinxTPyWA6CVlENn53zkvv0piGG+3/0rjpX8Wh0WR0169PJ8u+Gc8+ra0P3mfWoEoaetzbWcJZUYfA5bmZpCK/B8qGxz31gqWbYHM0Yn6rynyXpAGbsUEPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+PxyMZo8ESVi+g4nyH7y0NY0SVdeKKpekxdSRfEmds=;
 b=PTwWn7vbVtaywV6ttHAy3uelSxBT/G/2xaRNF7M221IrX09S0TzXYRHUn17QKAqbsmF3l4CPS9j4kmUrhNLdkLsCGk2KYk/y2c+vnI++hyRiHTWCuSXDUO+UziEoNwFCxg6JmlNDFX/bMz9lz4B09VMsFi3k/On406c6QOQDLsg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:23:56 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:23:56 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 2/7] mm: introduce clear_pages() and clear_user_pages()
Date: Fri, 21 Nov 2025 12:23:47 -0800
Message-Id: <20251121202352.494700-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:303:2a::20) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 76b5f461-5af4-4632-00cb-08de293be576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MNTnJlvo8mROCDo5rUhq2DaV1mv/ZzBU9CZRTVyJi5duY3zBYk6zgZK8b4PU?=
 =?us-ascii?Q?Pqb5iocg2uX7TKff9mrqAeX7m4UOPLk2Wu0Aeph1g98G03tqqOUWx24dJRpA?=
 =?us-ascii?Q?2tgZFv1OIjoUJkTidHSt5VkgmIBCXZtKzmJlVQe7PrziCPrxKzS02qN8eLsJ?=
 =?us-ascii?Q?tfKBz1/lZWLZWvlya3MY2fwrNcpWxicBH60r3d9ndFZVQW5P/j9KhfNGT5Yy?=
 =?us-ascii?Q?q38RkcZ8IXSqH70rY00sB00qVcAnQC3jfJGKgIw5ENWVCmZzGh+cRubPMD2x?=
 =?us-ascii?Q?kj0hL/Aqwj/il/QJ4SUFKAwvT4bAmyh1KeCLzFT8l6LAwNehRmZ8rBEiY3WI?=
 =?us-ascii?Q?0TckSHE96uqzih+Swo0WzEoTauOSy+9iVdyPHqWvTk3hepfYLyVVJhrkBuMy?=
 =?us-ascii?Q?qLYxvec7ET88qwlHruNHoUwR9PA2BmzDxjwPL15afe+VqrlAWqtnT9DJsRv0?=
 =?us-ascii?Q?M5ffBMKSq9n4eVdUL1l6WmWEozWilFSoiWuFZ/2S/xWrxobAPImeunzPWBMB?=
 =?us-ascii?Q?VaMjPCEnQUETQ9IVkd20MDIXJUym2n5OchEiQgpgLr1o7b1onyB6ma0toUHF?=
 =?us-ascii?Q?YbNXa4Ejf6+y15f1rqBVJD1ESaPKqJECSFBCEjPdVYt+N681bcXLLblusKbx?=
 =?us-ascii?Q?bxuDnlTPZn+llkUs/oLfVtf9pwmbIDIkGDOhxoQgdJhgryMlgmXawef9yleE?=
 =?us-ascii?Q?adWP92nwmlPUS/og24uhCFUx8TznmF2PCHT4/tyQlMofNGoRv8JlxkZs6Ufz?=
 =?us-ascii?Q?J7AKkW5pDlSbcj1n7CF50Y4LTtRRlT8Crh6IhzEItXjHnAP35KWk2NCVsG23?=
 =?us-ascii?Q?l4/RS4YPbj7ff/aXuoU8/WgEnuWjMYpxXtkM/hVr3Pwlp7lrxgfMN5G3lvjY?=
 =?us-ascii?Q?viqbVEeJqofMfnbTt36phZC9eueXrF3+5hoi6LU+Vg7l3zDgndD/muPSarlt?=
 =?us-ascii?Q?ip/jiNlyJRhG3TQ2YyuKgT3jZvG6I8PlGbWZvOAqFeYVnNf7vmB0N7ymsQ1F?=
 =?us-ascii?Q?BIdty9hJIDV7AkN4Stidrz3sjlTZ7Q3sApg9abw2hP2QRUApdkfswqG6GfbT?=
 =?us-ascii?Q?TgwT7HcSCh8EdRGTAbm2R/72hAb7WkVvQeB53NYeQfTEiCGvUXvi5rAK3aM5?=
 =?us-ascii?Q?r74R32s0swI8f+Yl44dVpYVyPjrzyu2Ho7T93vTH6dk8NOarMk2+Vd8fJZDc?=
 =?us-ascii?Q?reku/kIKpu6TUui5C6wg95bGUZzOi79I3AJs39LyTOYnQLhkRzdTVtnC71Se?=
 =?us-ascii?Q?P7AGjpGpJyDYjmjLFTSmmKRByDTk2oBeLIgrLdijm3q0kaa7c5SmQiwO3TcZ?=
 =?us-ascii?Q?FU/r6FjtkNOTV3UjqRy9lkYS17P1kIKCxpQq0ySyWkBpAmLczmqO7WAxpKtE?=
 =?us-ascii?Q?rfdwyYyBkIcrAeKrF+WB4HZhc3zB24WguZVoFR8cuemQSvpwBK+ytkyjH8EA?=
 =?us-ascii?Q?rlv3lGuD5eDL6emTCPpNOalzdA2TgYyg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ka4FHasvNIuKTjMLI6BacSWAvt1qZyfU6y392kLK80VY9Vh68GnPp5ZU2uQw?=
 =?us-ascii?Q?7/0k4GntaWkHswBojPHelldF7Dfn5ugd428jXxfupbYeav4LG35V/WSM7xLY?=
 =?us-ascii?Q?ji+TaYCxUYB2r2Kf1AOWzlW2hNuAxiEQoUBr+BfwvU5EHQYNDiYwoXA7KZHT?=
 =?us-ascii?Q?Uadne620LR42Z5XyaTapmjzMOfjgHtP2n2HPT13vXTz7a+LQLsskJA/9TSMK?=
 =?us-ascii?Q?8aopt3eIgGgRUjzT+Y75EE6mzmEbb6hE6pBfVK9WXEDbpR7W5DTq/Z0+8Dbn?=
 =?us-ascii?Q?fPUSpJJaSGE6SBmmpJcYrUD2U75D9i4feqp/TtVci3md/e/1LCx2b1qYl64S?=
 =?us-ascii?Q?mxdNoVStXJ22GBOgE+HVB1Z/EiekNsHmNJjWYGX0vw10uW8V3q5AodYwWBlH?=
 =?us-ascii?Q?9R7j3KrEr7/llkgwODi9jF3SKtwS4qbbN0yOWPpjmCzCCJnqa9+EUjbZt7Wj?=
 =?us-ascii?Q?7U04y7se99JFoaAcUo1fSrmpEmPWcru7tEJdC7B/zYXoUXDlPajyD+eEnGG4?=
 =?us-ascii?Q?AtvSVYs0H/cW2GKLagtKIXdaVQCe/KlPXwHqIHEpOYU2sHaE/Oih7Cu0MW26?=
 =?us-ascii?Q?P5zlUK5rhqPDbqgHiN/oHabawyqMPlebN/yYJKjp3hyIPscNAz0bFLRbiWYQ?=
 =?us-ascii?Q?qJbfjFMyYWK0E4fKMYbV99UHBJwVVk88obgfNYz6CBDClCiwgFVp5ZYFY8XO?=
 =?us-ascii?Q?Rjoja4HQKK+vXW0acQYvnASf9Wcvs/4hoxzzd2OEqzDIGL6kdrmc+NO4NEsd?=
 =?us-ascii?Q?gbHF5vp8/YEIc5JBB3LIKXntG+2x6BWoJPfNMRol1fH6rJq1abOm4mFgfVYA?=
 =?us-ascii?Q?5TuM/gN5leYpD3tw/xfdOpNhEfDF04tU2x32cO/a7clSw3WCYh2+zBVdG6/t?=
 =?us-ascii?Q?0DyQnZmfe7Y+xCcUnZGfJzkZM9JRrVb57mTYWVgzB0LhqKh5FR/AO9SSB54y?=
 =?us-ascii?Q?WJqtjzXrzXqeZmafwhD3PXadYfZgw148ifTO2sOj/qFDpFa2Xf6XTUaT3EhW?=
 =?us-ascii?Q?NFUb5WZJ6PCSgnwi0JGUB6ld4pFVeow0GAmEj7f9Mz9WQkc5h1XCUm2W8wVV?=
 =?us-ascii?Q?HGffjPGyE3CN/dcb/pm06ff3JASQgqicebSq8rnGVUWNlmw4irggPNuekjZi?=
 =?us-ascii?Q?ZB6wYOt9wy8hNiaqrZuKzLmA1sbFjZH1kVrWOBK1lBvUBAmr+JE00AUF/bAS?=
 =?us-ascii?Q?+WxQVZtgU+ilh1chq1H9/uQHK5W+YTyphIoq2TRBP5nqFVx/mjtGKHBgLzcv?=
 =?us-ascii?Q?0xe7QZi9HY8izSJ9YYIqqB2A5N+r0rcd/NTuCCulXgFt6nM7bcD5vw1Qdyn0?=
 =?us-ascii?Q?e2YplXh8d0O0Ir1deKuoc5tBJEDLbP6sWnUgrJjfu+p4YHPYLoAaQ//SIG/l?=
 =?us-ascii?Q?oKBFbdDKWOH/qSpAxNJO2ePJIly/k/N0sSFrfPPfCIj0S795Ba7ZbkHu602t?=
 =?us-ascii?Q?5KABTFaFRJnetAz65Le1aF/Cd57JclU7n1rHwJ1vMP/ONtlwNfZoLlme8/16?=
 =?us-ascii?Q?4vSDUw0IoSHdKfswHBjoD7rxOVY2E4EREqFUQLN6W9FgCziR8IXe8/3H8WYw?=
 =?us-ascii?Q?jZocLpwV1OVLcJwHENV0CGbqQGknbbltv5dHL9F35l5PvagOhJyAdE6x61GK?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HvPZ2APbyb2+yEOC/bINSmwK18s0hUI3kxT8mmrHaXLV14PwfmTclzU8LGvKusRtDAdQ8Ad7MjtQkXxWwf3GnoSQecYGK7akrwItZ1l9DVlLzLpDOghGtepBb6l1CVHrBVnpJUetY7vjKw0cUmowgit2xnNzUV5i+hsrwyIgu53zA4trX1j9OMFs5aMnDCaXqr4omNV360E5I5hOs9DOMs7q6il7la37uocRQsOlU6D74/N8nFWHZnWpDOFCX88Sosl6rz5Sw7ay5JP4VDC4Rr1snc8a443djzqQ0GNJnAu5HQfEovzk0g640U+4fSOaCqWa+M412WLE0hcwWaXEG1vI1RSR1Tg+tGx2wrNCD+48zfJXL1SnT2+J+6ugG6CMYjoBm8sx3uk974N9us5NuTkQJK8oWKTM6qgAh5aDtMVPLKJyHdqMlRlqrReSq7hT9jl5pVcjcfwX3nyeGf566QmpoEZS1a6IndQ+Rl0Gx+94MJskz0vPsryUj/CKezXSodR4qIh8n/ApP5UaIf8rsKgWt34WidTz+ug45ZTLpZzSt39JXxNFN7dNxdF1GztZkmQoFcfWL0oxf1Os91lzL9j3KxVqAMcIU3VJqeDY49s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b5f461-5af4-4632-00cb-08de293be576
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:23:56.4202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8bl4VnUIjJgB+IWFnwz+OYfpOwWAckJZX7cHr5MVQElFog1mqQkDScfGkgyh3ut2Xw2BYiArESAZmfPgoI2hDbF9QVfxcBu51ELPCmSzzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210155
X-Proofpoint-GUID: S_6RecttVZQzGeo9w48qZ7mDMrUOodcC
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=6920ca61 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=-4f2oCayxw7h4Rz1qIcA:9 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX+4GACq06+m0G
 6YwyvhI/+e6Zy6Z9hxu+D8MqG5j5BUow9dzkKaXdH4IRM1IRv55vROELl2x84jCw0eqBX7YdU/Z
 H8djaWPDKiVcWm2mPNB9RJLRJMTYepCrYo+95WXKbmmM81Ld/Qfmm5Dtv0nCHnmLYF+8R+SmrGL
 hivCQEpWi3X/h31UrJ+rVbig+84TkQqSmDddQpIrSh/SSsYuxTWqiAHjNVMoLHVpCYDm+W914+z
 efXAfzQDgM2tOGbtaKomhOjO2ftBIz3EXPzCYcJ3NPOqDHKPUQ3FacNw+cR2DF4r8bNj4RVjaiL
 7Go3RF0qR5zaJxg+YXxOgTurjqiBgc5//vaxOqxQd0m0jyyCmMjsOhqhzzPSYgrkfGYv7jMDj7V
 Lynp8zK7RAfJyPpZBiDPid9Bj5NsAcKIYF9jpOtcUBMJIRhVZZY=
X-Proofpoint-ORIG-GUID: S_6RecttVZQzGeo9w48qZ7mDMrUOodcC
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C6DCA120006
X-Stat-Signature: yqnjumxqd3ut6km15dx1pjj4ywbwubzb
X-Rspam-User: 
X-HE-Tag: 1763756664-698580
X-HE-Meta: U2FsdGVkX1+ut2omk4NsJkzLn+9mfaJ9BuR1HdT34dWOy8Z8c0hPJ8xjceByA/HJKwDDOtfO3PpjqE47mClxJGZLNzDQCqqfL9lpImdUi4GIrDWfzz7/tHLC1QgGhTfeZwyEtToodz204+rgzpSJP1/9fEWJtMCHBg++ZjsczBvKOZO3omPYleXKYNenSy6+RkqiRzZ4O7eOxmxbPW8KyAcO0E5rgVikGLjNGHKpE4JMRHluCl8jXzgvKk+ZAls+TD5DJVble136aeKaNAFrWQf79VLdoUySJjcwW/sClm3X1qOTObloaWo6974YR/dqeNyOilGAa7HoDRuHpg87uzg3yj/eIHGSo/jgX6d1WNS41uxgyFmvjhGBloGto73BAoSQbogLayhzYQpwReXPhigSVNfZpeNT3GetmniOs36kI59MiePm6aZbYVBvvnD0Zc/adE7kgZnBbzBukDTZO9xiqvjGhTQd1NmQaaxcnN5rzbBF8JA6DUeg/pUJ8DSeEVc2j4gAWzM9HHZ2rOyluYEbQmRbP5T553B+0ZAOtzz3USu/8VTNQiS4tXnCip2FrBqYsQUmetT38TudC27CASKY5nZj48mEfoWxLa20/6NcPSjaBMc8FnBaZpFZ3uXjjAqpwy3Isad6/h8dPXJ+VV7oG+Rti+yYBxcDtFi0lX8uhAXkWf0edlIvw0+BUwH+FgkgnPnsQRLDUK74GKPbGbCiEBGiUlFeCqsPYJ0do1a9wADAutv1jINfczfy3TW03xgcn4qIgdSqAFV4T2hcwNp2nkRExK1TEjV665mhgwxg4Pclz1tDRk8ekOxvGaF3Qlx7ikJ+P7TxLEAcWZHJeI3o5FEQl2ZnId7Fi+UGu/lakDDOewlgjV5zg+PiCxabVnG8pIm2i0StnPy9BdXtWNgx8isDFZjzlBOfRe1p4smdtPsP202agz4+7Ovw/wwn594Jo3FO7KyrGenycA9
 7zjR2fQ8
 Lhkf8VgrJIsfE35ExrMs2uFUiguLBGLGSQz2Owki+TmVxZD775qPYABMEKsIAHkoR6PMfh/qc1LK95/GQmRu1pWRJOl6ei9DXJ8WWIh7DRuBUuR3CSQlQq2TdOB3KIN/a3FUhslGXfCgjytdKz87brU3wo4mqqgBFgUNakeR2vN9MZP8V+bRRg+5cG92VOrlgRE7Ow5xrMpavaBX+wlpGXr3t11alrC3pCoVHQxU7noQ0/cOxVIrbyfj9jjqKYqdLZW0iEwCWydCx0aijijilohX71TvCFKRSuQGh3fniw3wQumsw5sc5V2xelktmsn8/ktxbLtUDuLFEimqDua3PL6caYc8MfH6uMjpWxcGopRV1p5GeqmR5jM0nJKx7HeMevy6+/NnxCZxbZ7dv70MxCVCykGPwZLodN1W3OqxRP4wczurdIuKHmy/J7JyUHIOtlx+Ix3Ew8BGq4s3NAd3r6u/RQU0XN1b7ERRQQJr/dhUwX4fcHbtbesT0YtTCaecyYm/kynwadnvRNJAEm4sKskBTg2mkrAyr9tSPujvhADkhHjq8lh7fEcpCDkXCv/8FKjF+AR47SoA7/7N8aDT4KOsesiSbrc0Gyo4rK5gAbpmerHJqD5cx/Y4a7nwWStICbsSEz5vEjlfOK0uIe9/0vTWAzbPPJ+nC2Oc/cuZIKmQBnuT2g9zTIwazJKr0Mxs1oa544VLKcUFV3Od/5vj5SaJwkhLNanHrffYJSD7tD2FelSACd5WHw+MKRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce clear_pages(), to be overridden by architectures that
support more efficient clearing of consecutive pages.

Also introduce clear_user_pages(), however, we will not expect
this function to be overridden anytime soon.

We have to place the clear_user_pages() variant that uses
clear_user_page() into mm/util.c for now to work around
macro magic on sparc and m68k.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---

Notes:
   - Use macros clear_pages, clear_user_page, instead of __HAVE_ARCH_CLEAR_PAGES,
     __HAVE_ARCH_CLEAR_USER_PAGE.

 include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
 mm/util.c          | 13 +++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6fa6c188f99a..c397ee2f6dd5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3879,6 +3879,26 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_pages
+/**
+ * clear_pages() - clear a page range for kernel-internal use.
+ * @addr: start address
+ * @npages: number of pages
+ *
+ * Use clear_user_pages() instead when clearing a page range to be
+ * mapped to user space.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_pages(void *addr, unsigned int npages)
+{
+	do {
+		clear_page(addr);
+		addr += PAGE_SIZE;
+	} while (--npages);
+}
+#endif
+
 #ifndef clear_user_page
 /**
  * clear_user_page() - clear a page to be mapped to user space
@@ -3901,6 +3921,27 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
 }
 #endif
 
+/**
+ * clear_user_pages() - clear a page range to be mapped to user space
+ * @addr: start address
+ * @vaddr: start address of the user mapping
+ * @page: start page
+ * @npages: number of pages
+ *
+ * Assumes that the region (@addr, +@npages) has been validated
+ * already so this does no exception handling.
+ */
+#ifdef clear_user_pages
+void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages);
+#else
+static inline void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages)
+{
+	clear_pages(addr, npages);
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/util.c b/mm/util.c
index 8989d5767528..3c6cd44db1bd 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1344,3 +1344,16 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
 }
 EXPORT_SYMBOL(page_range_contiguous);
 #endif
+
+#ifdef clear_user_page
+void clear_user_pages(void *addr, unsigned long vaddr,
+		struct page *page, unsigned int npages)
+{
+	do {
+		clear_user_page(addr, vaddr, page);
+		addr += PAGE_SIZE;
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+#endif
-- 
2.31.1



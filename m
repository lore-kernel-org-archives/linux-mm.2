Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EF3D4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3061F6B0098; Thu, 15 Jan 2026 13:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278FB6B009E; Thu, 15 Jan 2026 13:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29016B009B; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C70946B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E1191A0465
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:56 +0000 (UTC)
X-FDA: 84335032152.24.63DB4DA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 12D9B1A0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Wf/hsrkO";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YFjjx3WX;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
	b=bsbLEByDDALE875tjkZXXTaJjCxafmAOHv1Kzlux9SwFOrLU+JEgTfGkmzYpq0dbAMu09R
	OafWFa+4G/QoKtAO01MEuAfWlb6KYpgq+xUke4r9bsw0381bQsbTrcqCuMO7WsyI+u/Gcb
	qukMYA7evBDs1OjtbJMobkIQjLgzC1o=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Wf/hsrkO";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YFjjx3WX;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501673; a=rsa-sha256;
	cv=pass;
	b=sCXT/WSf0LHeinVN+G2exNRnSVlkh5fKMYs5a20V5BVsCVza9i42CO31CsSr+QKp6hji3d
	ZkDpn+bOa6ifQG9sXHru+OvCMLZtP9UHNfC7h6x9SbhY8+kjCsyVGcuznetSVUo5fqb36i
	7hTlMU3sivkAGJgBppmkYDCg+ACL4NU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEQnfu2395850;
	Thu, 15 Jan 2026 18:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=; b=
	Wf/hsrkOpzcWHQCC7P8LUXJyXVCJk6o5+DCAZXAGZEouIXOx5fQVqJoPtnEAJG1u
	//e1VZWdpNdmjzn2DKtt5MdIqT4X1xVe8ZSEVGs26OhERqpkt4XfXYQAvM4wokjz
	70V+JiAVvISy57PQ7g7BIXYTVVa5SrJOp6A+yfLBU0tPNJlwlwy5rkgNQu/k9ehe
	s2Ef82d+j0D9ZxaBIgfuF1BH7n+rphfQzedIYHiBTPrsv4uKQ5P/YrLAgTBaQhPc
	hxcd6DC3mru8AoD+GPNthN2JZG4O3TIc429q+ftHvU+AcpUyS/S5TPzbuW/CaqMG
	ZmtNRWy63z7NDLGZP3FEiA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq58cw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIFSbL040469;
	Thu, 15 Jan 2026 18:27:39 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fe856-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtDzy14VucVRzcvyyDN0C04md7iL8TEGD9a2iLK5v42Gzjut3FGXegnhERQ+CBggTViSnGN7BEflAkRIUPoQK3b3y25uzGuiZpyWWob6iWK1hg8VLE242zanaNbjfPpAwbqnbK9FgQueYopMl5hDH+kPF28D3E/gXjAyzv4zKFOSsyYqpuEBe5U8zftYjDFbeuey8XA2Ibbvu2xTqgdFx/DortQcCKKcgg1TQ7XgxEDz0gL199HEnFeRkMFrM1w6KSVLo/FGyDC93uwQHkrk8japBohB3MsUA21KntvxlrLVZ3M9I/cvqQEOlEMtvoXAOyxZC9FIOcwAEvTRu+aaiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
 b=DIo6Jy/Eo9GRbrbITJ2l+Z62o+5eEr81Ocw6MJljUz0xj9BASSJNPhLKS2BuO0ZWvTp8SAt7Qh0jiqrEIHF8bWCTQghaspPC+Sm9HbVGzqy4AjAcxQNgEmAAQtb7bYE60MmCshtfLBGzwe4ugVHDu9xk7wBuoKdIKvyowF+sPZFjKTkFz4nAPWatN2B/zZimthpaWowTgppAmtN5p0W0VRjXbH3pvyR1vV47bp+4vllop5vqueejS95TKUBgVhhxI8z0xRBeQWlJfuFW+XQlcOU3Lr5t35NhZJCfbiOXQxQBJTMbzA8ImAHHvlPENhOguuG0E8dpw29FDKEoi8HNXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
 b=YFjjx3WXqACQ57DAkpkvx/FVw+zCxqDPMgg19pq1Jid9FGOoD5YYz/47sbm7znD6HwyKcS6iycd7XxLlxjatQpSH8kswZONdgOPVvbjo202NSs/0jzTfvkFEYtN/jdRrweGKRhlegcljLG1VN4f4MVrPwI01SFPkSBL+V+xUx4k=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:36 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 05/10] mm/vma: Add page table limit to unmap_region()
Date: Thu, 15 Jan 2026 13:27:15 -0500
Message-ID: <20260115182720.1691130-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0215.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f8c288-8797-442b-6e9a-08de5463c18a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w46OgcSXVN7XRGuBirQ90mw1Ue1R951QV2vCVeomXjtIxDEXcc7d+sATKOaM?=
 =?us-ascii?Q?9yC8Dgl3pzbirGS0bsYByYo10suqbmmfIo8bgHg6NI5La2y8nT0mP4jaGdyc?=
 =?us-ascii?Q?JQ4QT8j4Jttqf4NV9SmpRlpBVV9RhFOa76DJFYy3znQ+kTJwTdqDY5UBCPhc?=
 =?us-ascii?Q?2VZuPUXVURqEaXdVqBplr3iijxteOeLikDme1+IqdBzWZMWzb3T/tGDy0Qto?=
 =?us-ascii?Q?qqEPSylUfoyrYAPcJoNL+ieapYUxYuKiVt66SMbgufSX8w90rNshBLLNatV6?=
 =?us-ascii?Q?ZO2k13to21k/mI8/LAffRz/Q5XuylAdx52ByHPrhOss2vVDrP6mAeyY52vEC?=
 =?us-ascii?Q?BSYjH2qEvWX30oGB6N30V8ULnS1/HimStJpo992r9aA7mqzAP5w/aC7DcR91?=
 =?us-ascii?Q?C8MI7i1US2uccpzkB/sNPuBg852z9Hb5LQ+YEYKGV5NiyUvPAxcVYJ9NE0SK?=
 =?us-ascii?Q?rgpCOUPg0Bb5pJfcTArDBtfCnY3GtytSjNlWhByreyfizx9/M9y+qJQW9bHy?=
 =?us-ascii?Q?fkd/PFuYdm1FPcDA1vi+Rtyv1W5Jo6PQpAI9aGyH/QKPDvDIjSrUd0+tVBi8?=
 =?us-ascii?Q?8F/bNn7YsKZqOyW/VmSWPZZMoSYiPLbt4cZvEooJcoeCvFL5dwtEMIYqbKsG?=
 =?us-ascii?Q?HkgXsu9xD5xmEDnGO9IdilgkBlBkpE9TtwtQxt3ignFhudKNjp6zp1k2D+w7?=
 =?us-ascii?Q?MMKVMc599zX+izzSIytT/bDRuP8zedzMRVNq8/GcPgdCnAkmUK3BMQZdDz/+?=
 =?us-ascii?Q?LUksYaG+QVlonRs3On3Tt2x+fR8q3eLsKkey3NGkjSJxsj6hi6rbxYTUwbP8?=
 =?us-ascii?Q?bOXRB63ieipDhKJVOlz5raqLKptzj5o9efQmNABJBYEylUuL8lgGEIn2TXEN?=
 =?us-ascii?Q?hWSbMC5F/vty/Cic1u3Ls5fiXUebVgcNoJ++MoAzJJVXsG3tIxvKS2c3zaF/?=
 =?us-ascii?Q?iRXH7djcP01hao+7P5BkQIqr3Yq8R/pq46hRsTHA6OWEme7t13rQgrFUsKjY?=
 =?us-ascii?Q?9r9uJ0ixetFmQQwSgeJXrGnJNTIeK5KO9Qy0Rt7Ygvz/lq7NzSWBZG1gPDoE?=
 =?us-ascii?Q?v1EHQC20NLPDfgSMerUrS/LNNIWNTLzQD8pMXTZaeO0ShcDWQu6/LabCpGR0?=
 =?us-ascii?Q?0wDEv7KUjA3GHyaqtKRRvlesKX8tiWVM7mfEu1/E7Kei4HKCxDeUhCpbSEv+?=
 =?us-ascii?Q?5nAQSi8GpLg74/KGn/XhzYgnKu1nSMZUHJdJazVS7T75anisKXWt5+EDs4uz?=
 =?us-ascii?Q?pUE3CLFOh6fdhmADQxQ9vWFtVs7LlT3zovS4LmhCR2y/xv90ds5LW9VLom0Z?=
 =?us-ascii?Q?u3qmif0DbQAjiUDwHjHktehOPLb0h+0nxCfIvUn4+pgIVkCwluEKmjV/WV/e?=
 =?us-ascii?Q?Qq6PHVod0zhyYgAbgJ1o1wVIz6wC15Noct0Q22L9eFYJYnH3vbG5W4ZE9x7U?=
 =?us-ascii?Q?cHrfjj72NwEputR/BM72WWr8q7OvW5+jD8PrEEN4rWb6KNtwe3Tip2fFV/9h?=
 =?us-ascii?Q?2iJ324gx0qiDHxrb7YDsINwf4CgEp0XK0pvYAUASumSGHp8lcsv+FT1txBEJ?=
 =?us-ascii?Q?q6kgaDAJJ2YXHh+MVfs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kj38sh/6hf92rXT6XzTte4PJ+fvKQhadpNPjqJNQ7BZWyKkfsn6GPNNe28eB?=
 =?us-ascii?Q?JPkHY/HH5M2JKGPr5sf5iY7pH2icCbGl78UkJ9FKbOXAqfg/5n9/7oUQgcgt?=
 =?us-ascii?Q?Zpu3QoYgFEPxpjCFzDx8LMzb3VIzvZgWZEtBPTknRwUGmCV+cKaKpEP1JiWQ?=
 =?us-ascii?Q?P9Vj7FiXl0ESQUlzJdPJncYI8AcSr97RdaQeFitd6rmVz77V0k2BMSyqz0cb?=
 =?us-ascii?Q?AULDm32vXFy8JibKKlorYxZUoic/vUYEPnsdDPvLqdq7mvCqPGtCjmyC2gf4?=
 =?us-ascii?Q?2//Rzm4zdVqJ7sFKEWa3QibbboNxfvibEFwRmD+rDb/bkXA/IWodq8hl2mmw?=
 =?us-ascii?Q?ZP42tLHpsx8ro63f8a0OTurUYQZFF5RlBOdydDCu5xwOAAGbD/ZMxqGM2ctq?=
 =?us-ascii?Q?ji+mTJKVMi9iABCYaLfMGTK1DWUUvccpEQ+daPIbeUYVbAU/em+xvfl1h6Pq?=
 =?us-ascii?Q?oSe3tRPeYZCLyCTYHEry/QIz5M+LFef0QkhjkbY7CHwuMlzh9YWjD2K6bjyp?=
 =?us-ascii?Q?QrX6SRV3qPwyQfY5nkYvdp0DTOC1OZh4aPNh8JYbraiSvwGyT1hvKB/ZJWw6?=
 =?us-ascii?Q?29U7of+ymUURCIuy8Ww0WF/usmVeWFJt+tXWtR9ljhz5LkMHEy88S5uXoLhk?=
 =?us-ascii?Q?vIXZSGTaV73781CGIm9F2JXQjj179Yg/QXoiK43pS50lj0s7uV5/BegccM1A?=
 =?us-ascii?Q?xG/BspnxvYges2+KcT++HAPFUDHuTWaL1PqvinTIAWzEWa7mHBBY7eDO0jWA?=
 =?us-ascii?Q?Sxzw+Sz34kwJJEKWeU+v+l8FXdllxfJ5+aT0Wm44K4DYz7pDOzLIuz2TpdDB?=
 =?us-ascii?Q?LwTL7kMDs22ylglMeCSGII/noMh11PAWtXuoecpRFAkHwVo9cz2nyTsJgZEY?=
 =?us-ascii?Q?q4PD+ZeJCKIvxp84EZYjPwYolkCAuspQliUQRUR+1n98C2QexIA/c1+eS/cK?=
 =?us-ascii?Q?Ex1mYXMX07koakTPZFJOwk6dzFyXoVZ5/Wgy5Wu3TApYZPYBMv3NyJQ1+BOm?=
 =?us-ascii?Q?tGSIk1m00vSGiLEx83Ar1YVSEHGtlp3sW4ErAKqa/q34RKKstAgMNu/r2rjS?=
 =?us-ascii?Q?SWGSiPJXb9UM1DulMM6gHk/tE2EV3qaj7eGYUmIQsXCPZgs0hnRqWah1vdwV?=
 =?us-ascii?Q?iiISynHJ/nBbXKeXmse+pBvh2MLQ9FETZHjG1HFkX99TFAOqgx9y5QKLKF3r?=
 =?us-ascii?Q?iNmvdEkyJyscD/DBL2Oh94767iSha29kskkibsNOdCkjR7kB+xi5b1vEMxcQ?=
 =?us-ascii?Q?RufPccxEyfjI3cuMwzyqLBbycj3dIdmdaRGJlX+iwcFZ0r5v3esKTUXIHNAD?=
 =?us-ascii?Q?ALcLxTcfuXhPo0V1UgqacIfTjcjmUvS2Crzs2Wlj+dkUoJ3R8IYf8bZvIOnU?=
 =?us-ascii?Q?uPE0sikyNqRGS/s43kqGckhzBWxd9wTxNWI8BRRIb4fSoW8g2WqlZMjS9Em5?=
 =?us-ascii?Q?45Y/F8ot03vB5o1J3jDLHQb6o/jGun86Qg7cB3AjtgqU6REiIw6KRRrFI1SY?=
 =?us-ascii?Q?Z+nKWvSFgw2A8VzQuAcx7UEj/2IrsETpxxtZ02iFBiMn6BAtCGAMUQcAJ1pk?=
 =?us-ascii?Q?fGRrY/fy0dQ6ygXtei08OzH6bg8vSOUR3jit2AUj1iby73J9XA1EGuxrtZKI?=
 =?us-ascii?Q?NGwfzyCEXoh6iwvSj8N8Pi8SJHwX14jLJWao8wCXkXifv1sVcjU8m3xcZW86?=
 =?us-ascii?Q?+jZO+svzR3KcXaJDm0mqOHDl8O6UcFQ789N0WXLm+ovDIp5nb/6R8UB3OnMo?=
 =?us-ascii?Q?OvChRB7TZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BidoiSK/AssAQs8aK1KuUVp++6qZLBbxqGthVxOS1ptejeANukJf4BICx29GQS6zTzu7p1sft6JcDQ6vQU6fpfIh/3nwtHAU7bUZnB4fhD33c4SK4CmSu+ECCmXTJYer0F1GE82gET1SPbc+lWaDbpkcsckf3f/R8armPGOzs3BMx+7q+NAQ66FJ2sfA9itgeJVK8X1yoJm6nmCgrRVPzAduLEjfC1+kWN38GM1ATl314RlwgnCRxCY7YmM00svCgT0e6ewGisCSiGUitFXcLoGL8syRfP5D5zA7j8uaxdMhrR197vo3RVY77dhM3BmGYhZ1tANlheA3A/FkmMA8Mf63W/Jjbc/Hbcyjy6j/VSAi1qK8NT+ffy1Hr908tR3dByJ3mkRM7lLrUKo0NylpxoexHk10TOISMuWx/OxZp/l+CHbONSIM1Eq6jYt55oMHk4lcffamRbqgzggbO5rF/Jo3BVwE++Z/LzDkqyD62/2WTueuWI/WhlZQwwiPikwdBVksDt/bUYb4KCICgUp2iTcnzta77S3UNq7XC6Jnf8nfu8pYSBtA5yRSdsuo0rZ2RWu0SLjXq7IgjY7DURPVtIJjk8YSwT/DmpQpaxe3X/k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f8c288-8797-442b-6e9a-08de5463c18a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:35.9707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdLI/wz5TVLptxZhkmi8hWzA7LleVADrftGLJn/KnrMb55KB51YUekqmX6YjH1g+2S6aO7+33mqCBFpf4oe/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-ORIG-GUID: rRnOuIv-HcxcdNBoAj7RH_zmO6uhxiuk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfXwuIzfBj5fq/C
 N/HDuvp6hDz6TE5Ca9SZJEwFl+BY1+BPJzHUHLwpHAsqbcheWK1RwOpWCxk+aeS/vc0OekYxFKM
 hTrcwRTkFu/wXeqQiDAbOvu3QlnrISVChNbDyBS7Ytou6pIjZxSeepTySBHkrIlX1If8B5+WJ8t
 RDC5OGmAtVSeMUuyItpDl7ZJNylAWysOiivluT2OA+P2aktftfeVidHcpuVbo/rOA2er7mwxWez
 UojzrDf1GPRfrVgCBp2Z6iK8yjPwv6L3+4D7L1j2wZH4daOutF6cRbOjaaXI6IYiNvctCynUmbm
 YT0YUB4JkK7caNOmB7SJMZGLIpdmW0TVQ3aRuQLUaTNwF8sSJ3gttQfEsVjKkb5aOzhjlBqYibM
 vxHqq3DeemUFT7SxdWvjU32Zp5aYOIQu84gsm8dQoWDipfOv3yOw8pE7OKOXhpvrJ7rUcUaX6p1
 9YaGXFlD6NFcdRXPM2QI/3Q3U1OH8/fU3i5G1mI0=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=6969319c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eNAQnf5BmXaFxOQR-HAA:9 cc=ntf awl=host:13654
X-Proofpoint-GUID: rRnOuIv-HcxcdNBoAj7RH_zmO6uhxiuk
X-Rspamd-Queue-Id: 12D9B1A0006
X-Stat-Signature: pf8hd4ajf5xu4ipng6o67zpncpb1c5i5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768501672-870524
X-HE-Meta: U2FsdGVkX1+AIOs0rkdhd9S9Us1bUwvjezbr8KR4UmmTmFz4bp1oSZvcbAzPoD/rDLV0MLzd/JTpwmKfmoA3z1HTZvr8Bo85B0gu1vCJR0upgKXrKkj/iOv2KXp/i9hlOEPqTZ5hd+SWBlHroWF8jXPWfpJa171ZYozEB4S9m3pTv6qfmmNx757TUWhQzRgMA/6amFOaRNBGaQUNlcAhEIMhtPdFVhzbTq8e/6X88DsjeMn+4IEMMjqFtYqJ2PAERFmRX0tMLaEgudn/ki6PIP0nnxtReZGdwdYcPY6MVdB3zyieD6epEvObnd4J0q/ud94uR/H6q/UrQUC12RrL07brl460I8UsnSb4rASSG8W4snNM8/g0C+z+1JqZyUNw2LRDIjRl1reEEXI6sMM3Fv2c3gqjjo+7a8JWuYymMJAKSfRygYrLdvSiUY5h43wgb0bcIjs66d9cNpFUsxyXdvao6oLRMg8O2mplDv9TvlZzgCpRuWx4JfS1PujMQN2hPMXpDI0YNcBs+wTcUwoRKrkAfCb+frFBxnJbbJxlzxEFOQLtUVnp2UFEt7vPVlKR5B/61jm9PV1+s3eh794VGHekF6tOSXtncnohnV2j2eRV23b1haTdm/cBbDy4C/OYO8hAqW45UE2ZGaMUDx6BFuydBSGMapVIrWYIg6mxp3eZy4Dbf+lI/4nwcaTgUt4WQJGf/3ZZFCHC6AQgel/HZBIc2sYD7+uOC8F+KPwo70WIvmmuwJHdCjIN0phACkP8qDsDKGz/gFO94+dPwLjCxn0eObx+7rBAUotx4gmh6jZnOcZXB1l4Z8UxbKmUC36hOJa/Md80h7p+Sv47jMvEO4FL3Y07kXudXD8TCQdSGDi3fp2KTzyIN+iuLPJy4vQnlvLucCG8Mh0uyx0IuDs+pdIOi5LjGq4ia7gI1MPsp2uM8iTnUOfBSw/MvyuavqUeiZuGawg//rreTLzZX2c
 +MUhHCgf
 EYdg1Kgi1webCEb7GMTAYhtnVJP9Y1y3P5bE7laEyxasfeftsoKLrEqXdDUb8zbTyEJqvYGebzOG/7XDh/hhYYYo1Mz2Du63HU1NOHDFkgw4Mzo6+JCUua07V+HTPwkM+R6oW4eSIi2q+YRjeMSgC9+4zq8rTQ4h9OIou4IgENnt+7w0OPO4v60W6/2lrUyLxK2tHMDSxNcLqPenSeaoMhFQc/tlWK+8q3XdrIGboKKqUoFz5G6HXcmnQhVRA/4bUv4/KZB37iGFfTZ67qE2RIKJs36fnzC8pa3OFNukmUTWYaXOBVqvO+WS7Th1WM8IaqzgIHaJhDfFnjLx/9vyLmaLS1AYDNYJGNATLNGmmxbDZyn9sw9b3E1Z2icsH7zx//RKuDiMpWfAZk65QzMXEGC62b7d/Zspmeur3ovVoYmwmJHJmTYQV4s53oAuJbjC3p90Tl5nApaVGnHbb0G3PDSggOIz2I6FaQjP+1NBOYYV+rIW2puNp0F0p03mJf34QbDMaa9+/RakWLcm389QLx/aPlMh47pLPK83NVg9+WOyoBXKn2gy0MTSQ+ucXEdj1hsuruDeqN3G5AjsjuOvBzIwHsxXHpjrNNvx8ynK4DU3pIdp4VWgWlAE95AZuETKlbKCtnmKdkzgw/RFpUTkhU0PEaP/ypp3jC5pW3zmixJI70WjZofEIRw6510HwuIXdHx2/zOLRgAxAC10tvRS4c7JJa90ciSSTKY0p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region() calls need to pass through the page table limit for a
future patch.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 7 ++++---
 mm/vma.h | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b2b9e7b3284f3..b92383e5eebd1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,7 +474,8 @@ void remove_vma(struct vm_area_struct *vma)
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next)
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
@@ -484,8 +485,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -2469,6 +2469,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
 			     map->prev, map->next);
 
 		return error;
diff --git a/mm/vma.h b/mm/vma.h
index e671adced3a03..7c2c95fef240b 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -265,7 +265,8 @@ void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next);
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next);
 
 /**
  * vma_modify_flags() - Perform any necessary split/merge in preparation for
-- 
2.47.3



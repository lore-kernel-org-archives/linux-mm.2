Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD20CFC503
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DAB6B0030; Fri, 21 Nov 2025 15:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825946B0032; Fri, 21 Nov 2025 15:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7146F6B0062; Fri, 21 Nov 2025 15:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4C66B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0648C1295E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:30 +0000 (UTC)
X-FDA: 84135741900.18.CC2A882
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 860E680005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fOmEU9hN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wrVExkU7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kBNuTegwwaa6hhW0PBUMbbl4E1WjRwR4GRz3L/XCqE=;
	b=lZx97lQ9a0mylIusPPjWDCak3r/9gWks3Pw1rG5LpqrWyx+P46heuZvtGkz/2eCS6jVKBT
	TncS3yhpfGCq0CVEtSLT8PoorGghALw43WRNGmdGZJYvNPXS8H7mbR8DNbtKbOUxemAPUR
	alb4XddZPuwhZXlDp2HIFgw+Yqi8vQc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756666; a=rsa-sha256;
	cv=pass;
	b=ezjeXug/RN1B/JQwCPTppS6d/+F9k68mHRwxMKkS6p1jTgc6LitJ+veVTkI3pVWEEQSJv6
	Hrbf3DQthrD3sKUtFx+hfFLhvLyebseKl6r/grACITdRUxGEL8W7O7Sb7rYNxcAa3V+OM9
	dRiq8qO5kA5Fa2RxgTrTmgK+D/ifO0A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fOmEU9hN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wrVExkU7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEgqBs018731;
	Fri, 21 Nov 2025 20:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5kBNuTegwwaa6hhW0PBUMbbl4E1WjRwR4GRz3L/XCqE=; b=
	fOmEU9hNd4tIQCqxKbJfNVZTCMKCwqDLD4VXKbZ+JievL5YnqgSpUDNJBVAf5XRT
	RkKFAcNPKZWfIQBBZX/whhY2UPKr13XF56vA8k3z9zgOaQNUFToNo6o7TWor/H36
	7nnzkuCwPRGIP/USY1cT9TJPi4fQJTC4y742TMWta1PC0fvKwPVcp/mn0BdYh2D8
	3YWSdTwjS1kCU4DGrzeJCU89VaikCZMfDRK8TkunY1ZGuDx073M8eY9LG2G8jkNl
	cUSDzfAf0ARrihmpuSWJGgoABbPXpKEbjSh744gqjR8kwxcVHYTxfOb4am69c/Jo
	68MF5iGhuU+85okw9YeUHg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbq4f4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJY0Mq004449;
	Fri, 21 Nov 2025 20:24:10 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefydufpv-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnWzwvIIeiHJecF9QYOCAozb6cEs6l0muSK3DzFB2uz6sHnZKQ6jE+0rB/eX7u/HlrOk6Ai76alA7uEHxRgFSf0tcJZsGkn6Cx9o2HG+fKTs+iRoAZleKUxGGioapDoRVldk+ctdIXDIUQDG9CBU46PtcRYSXZs4ScTSdWabZz0Q7Aji1/Ha5k0gsmujtmowN3byH9hZl4cu8e23pLMUIusQn+Ekf2ufNBsW544fXK23lv4nX2mGjEfBfKExtLT3pmkc660XTeL/3FmJpxmkpWCWRFumefgKN31nKoV92tZ1X0C4f9FpKmIc3HTj0gaLwLGAGzjK8uzC7+hyDrzI/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kBNuTegwwaa6hhW0PBUMbbl4E1WjRwR4GRz3L/XCqE=;
 b=aTiyNuJMYAXd4kdwj4CaJQ1Lt47rvVr2EdETE9mt52p5MoBWni8Ucio16ivi/Q/bKbKpisfXWKB0Rf3g0lKW57lLyHyzo7iwt0ZtyPVrEEoi3/uw7+W7TWmoPNOp82Z96ZloH+CoaYmp3Dp5O+BNiVTXuv0weWBqOj/bnZnCII+dHJc9zbn1YV0cgxR00jhr/1luYE5XpcukTK/QuVg1gXDM8AYE7yuWu7NyXwJ//fCrdzwrNyVnQ92BB+hihT+onX/kxbcY34ShiahLKbhXO+rDI9jObk+jqTVGTHL17QiTMD8QPidKAE/JzXddb8BnZLSITdnA/OrbeF8PfJlnKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kBNuTegwwaa6hhW0PBUMbbl4E1WjRwR4GRz3L/XCqE=;
 b=wrVExkU7E3zzATokS6c8G4sGEPGqfnbOYLahtGhwgIA0712CGtvqDsr5u57IVc0YMS6rCVPdj8REUW9y3U5x0IEDyu0LEaGvMHNlrCklni9AdAWng6qCf67qk2EMcKfh0850Tx2CHyP8k+PxE0tWZ1JtTXA5chKGnBRcT+GxZe4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:24:05 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:24:04 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 5/7] x86/clear_page: Introduce clear_pages()
Date: Fri, 21 Nov 2025 12:23:50 -0800
Message-Id: <20251121202352.494700-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:303:6a::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 063efed5-c227-4909-e29f-08de293bea48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bc6O4sGt/AeUdC1clGbB57iFvagQ90mZBzOPfEpKgiF/MlvUqm5KPdJYzCFM?=
 =?us-ascii?Q?jXgNKSsH4EVjq794Xaf/JIoQNf9dkIbcDRiafOgUExXe1ym5342iTbzcBNEC?=
 =?us-ascii?Q?OU14mnUtodiS4vmNV4caAWA561lAtGFCYkk/D45F4s0P5d28vuS8nhbgVWeh?=
 =?us-ascii?Q?+mg8RsGGzm3P75s/IhJeLHPVVkh9hB8yQmyUhEfPCX2x9j4OUphOl9zkWdVd?=
 =?us-ascii?Q?E19H0G0dKAj/PLyQHOxzWg9TY0HDjpPHrqFYEiGnnmNHGj0JOHxHcFNVlfU0?=
 =?us-ascii?Q?ynUxO1ZVaKlKhN7dbyVxd9/Cs7ZAo7xU7oMZzd/t+vqDEhvCvr83j/oKd37B?=
 =?us-ascii?Q?6E06pyXj1AGW1V8VyfEwGUbC4+kNpVbqoTqb/dqIMuew404F9VHApMPjgB+T?=
 =?us-ascii?Q?rPmWihYJs2T1A6jTduqAhr4T6hbGsO3NG9nvgeYV/zUYpKCTHPGNvM6cMxRy?=
 =?us-ascii?Q?wfLY68fmHxEzGGyAgV1OPm3vjKWG3xeTuDp6uQ8Xdc2yX/aPFwk/LgQ5EE7P?=
 =?us-ascii?Q?vqhnTTVjbobGzHA856dwVvEdscmwI6NzM55aCdE1z0X7BBKCprUS/OBvckJr?=
 =?us-ascii?Q?ovMlttpmJaLjJiMRQfDMPkCxAEUSAV+GwiHToxuuzBg2XKMGCufiCUr7EwIm?=
 =?us-ascii?Q?+H0b8brFVtSY/5gqNPCCwV9we5mT+zFRiCwouYAX6vfidAgzcomi5aRi4IIz?=
 =?us-ascii?Q?FpsO0hQ+7ze7V+a95AhM6BwZ+x1xdPXuL0a2RcK/bmK/daFiqkLXnBN82eWY?=
 =?us-ascii?Q?oY59gc35neCgnMzK0qpLJ6BYyzA864jk5ltTG4F4NFep+GRi8mYI269Q+As3?=
 =?us-ascii?Q?k8SeYhSYCathLpDAKR5eb9u9l9JoDK2PVxN0YOF30QPqCQY6rYolSfHBAycp?=
 =?us-ascii?Q?w/hTgJiBHx1DybPRC769hOXPIMY8aKineQ2WlsEfrtOI1AD6vGCaE8/kdjnz?=
 =?us-ascii?Q?Ad5PNmZbXIZRLZDIepmrictqw2+3XepwMkjBKQtytZmaIaPbAZnBvgA3x+LB?=
 =?us-ascii?Q?w9vNHzSCnhEFGPaHJRQKs8B20PzAya25K/K10g+YR0hdctXvkmpe5RZ9uHl2?=
 =?us-ascii?Q?9Yyi3ISxm2UUE6jU39K7w4Fy0eNauGTqXLQh9bzZgHv3tMvQGTZQ9Hxey0yu?=
 =?us-ascii?Q?ZmevfQfvyjsEiz3/r5xMtD5YFByYgmmAhAMuA/4bodTag3PIJUqNasKapBes?=
 =?us-ascii?Q?ucHE2oumiHTEbZ8sjD+wMrfu9PONQ8q/bN3MB9yxoXjxitYKwKDDbqQyuSUs?=
 =?us-ascii?Q?FYKK3QuG/sOd7n+vARY7Re3LsYAH50C3Wec1zT3VmfvT948k7AwJ8hNkHu2j?=
 =?us-ascii?Q?UdgoJVghcxgQo42kU33t2JJ2Jbie+LZtVj85laNvR4K+WZ2KFVrClfInxIQC?=
 =?us-ascii?Q?jPrIlOJiEIImgJ1CJ7hEKMZX7hLrJTO5WOcLL4yH78kWs4jpFY5sGQdU/BSc?=
 =?us-ascii?Q?cV4ZqVqEW/5lKOfA9IHErA8FQDF5c1Xv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q156aL28ftuuKu/N33kqHYhi+Q1CfVe5+JScX6PXJgaoix0f880mjlwIxqUG?=
 =?us-ascii?Q?SO62QHsA5mwRZSxY730rXum2uCEVV67Js0qFAtiGqUWHAEY8UvQDNki4HLGq?=
 =?us-ascii?Q?Q3As/0xAxsdlyqvdc8ln9MYhdaYbE2uQnxiNyPEeNjHJy4YQ97Bq594WABGj?=
 =?us-ascii?Q?SlfUJJggu41lhZz7g/FX7N86EZRzv0qoXOpdcEFFwZB5xUiBL73R8Wf8/NTd?=
 =?us-ascii?Q?9oEiSN/7sPXT2vjdEHb3uFQm5y5u4bbNm2SUXMq4GPFcpzUNWhpWv60d4FkC?=
 =?us-ascii?Q?WI5MGt6USH+Co29qZ2Qsxj+gG8/RNWo2x8ULTaF100bk+yqAWyIBfXTldrNd?=
 =?us-ascii?Q?kdB3DDWn7FYx5Sp/OKzH/62sAnK8sOfD8xX4Rrm3m23wsEKikkOD90jOEwjB?=
 =?us-ascii?Q?2vlz7jE9bTbQ9ONagaSKWL6GTYjeIbn6yT9HhCovXvIT4kON/VWO3tl1jZN5?=
 =?us-ascii?Q?/zGsYbCw3MilNhZupvgmVcBwwslZOsDlT2chrzpkRD0EFKd3TOCt0XBuo9nS?=
 =?us-ascii?Q?R0MbwBbmyx742ayCGd9VnlgDNxLBDEipPtCsvTqajfwkhrWB3nb3+JyfdV3e?=
 =?us-ascii?Q?uaYdcFF2r6YizCsyj5GARBXKEMoVrwPLfzLuKMq5RE+qutVgw9JjgA+i3gKh?=
 =?us-ascii?Q?KJySSsjKrQyMnY+p441e2rI8oW/TU5LLaPhbfp6lXbDWfWsQ2mDs7xi2EN0U?=
 =?us-ascii?Q?j69RSfZaiYBS/jK3ztzwFmF+V21gbxsYx/pmXS5Uv+vxRdZHKVu9J2CJR4H6?=
 =?us-ascii?Q?RfJwqp74fSAfhLExbSLQmpp71hfI1VU1xYv0NzkhnrvxeEIop678dyW4f+Qw?=
 =?us-ascii?Q?R93jQAxQmXeSGk6eVOh+q2MOYgNG94Q9AzmC5ojgsAjBpphw9w7Z5In7CzqB?=
 =?us-ascii?Q?WpdEx3GFO7ZhjDv2Qi4QrJHND8SCL36Jrnt5k47BxoUcazgffW4U2qM8FB3r?=
 =?us-ascii?Q?uKujebpAa40Jr2Zk3MMfCWRQl/p1BI76t+FddL5OcqydDDlsIHFHxZ4IP/eF?=
 =?us-ascii?Q?T9TAKRmAv6MjQghMsVUlR/Kl+yJ7MjNxZfl8RP7possNfQFXStZ1dmhhi6Tv?=
 =?us-ascii?Q?FPK8Elv9hLy6o8fFgJZJHUFFqkRknU5SmFIwrfguDE+9FoFlS7whX6IZGTVa?=
 =?us-ascii?Q?k9XpkqBS+LGNmerPlj9Thu2w8oKa/lpKa7ggfcZ83ofGm9Y7CWlfF/UI/yDY?=
 =?us-ascii?Q?syTjMq/9/Eq595kiAMd1CzyxfTQvA3Z5fxgL1Y/HJLNHdPKZNvrmxv1IjkYW?=
 =?us-ascii?Q?Mp5g55H2fuykZbaSJRYCUGX1LfwB1RVOYFJ+FOLj56Ib80/6v29QCZrBYqdH?=
 =?us-ascii?Q?zD6rO9FktcbV9iKlAHqVieNt0yJyOVWTjuU12cmP+aFUInx+ysVilU2JEmGq?=
 =?us-ascii?Q?FrlDKVKWXrIW7VEsxagn59dBXAxGHyQ/rDiMIHW/CuhuC+/DQbqXIvEvBHoP?=
 =?us-ascii?Q?N0XpNmvMvPFHsDuHWK2aiwjgK49yFIkRzdZiOFWeAroxinpGOMepW7US78f0?=
 =?us-ascii?Q?nSsaU1BbctQlJVDaGsZrWn028PxwsfuyUb8qMOoJpenoP+/1EHs/cYZ7y34G?=
 =?us-ascii?Q?l93JGYCOezu9KZxeq8e0i3MZvlgSB3o/0KFdCJhflXaKu7NVHU7BF+I3YZOD?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I4ha8tPQRuoBOmFy1OGUeh90bKGdTzvSihgkY3/TkAORk/UdIfjBuL1TP8hjFzayh/PxDlqV1C+JkheZGc0xye8o0Vzdy/5ptIpLuzol0Pz7zBVFj1gX9lnEVRcMg3cdjDSS3YIvQNma4bk22LO/WRwUia/53iYYrpb68ei5glqEqJlRHJnlakT/tkf/BD58nOXUGETZdFSXNkhqvPDvA6v2dK2C2de6a071NGKDgTSlTZv5g4jfNEnHKMIiGmaikWGLgALvfKkQJu+kXG/YlOOnujvJ4ktj3feolI86MPLIkWh4sHdxKKYB6DAA1XSuod2iDh0TfLl8N//ptn4uR9+/nFY0cHW4airO7fD9zWinXnaX9sqLX115R4+Sx9F3wVNEwQ8Ox6lNfpF4LObdZbTCZufDF1iQEUtXyYmx8BUOxgOJ/s0/uYgD1puXVpU7QwUyw+WcWk1L2X9mEvT0+n+QT9k0RyHHbpEU3YshS0YQ+OakMaY8Qmw1vvniBDShgMnofDs8d2iPeKVih3wdBcjob+mM/RGEjsDvL1AQYUKywaXOseMRnmoJq13+ghiyh7ifcTcBMkDIskXVMZxFm+wTrOXNx2/I8/SSxJTexR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063efed5-c227-4909-e29f-08de293bea48
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:24:04.4789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JmvZC8pqS6Z5zKlIZcXerQioDxhEhcpKcUMaeMbFVMHvyvzCJuX709DfaJcFvqeOAM/0WabbAj4EQS5bt28BRXzR5poGRG5x6TZbRG5Ih5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX5OQ5QAKjX+K7
 URYPOpWle+cRnAMq4BhZioo1iAgyxlFDaQIUXQOIX9ETRsnWPlI+omIN253QucsHeX7FL8pwQtc
 eTTbQ0JR7zvSA1e5I0eAwm0E6OrEbDYgxbxeiTuyB9VdqT3HqJzNhjIVCLR8yytAHkWfs2KIKiA
 STpANT0YzpCuEfvsBvHO2012vNvKcu1sHf096+1FMPTjrodN5IVttRXsc/rZOAnagrBGfDWUBIG
 rbbz+tA6bLx8eMKN4jJGUfrbKyoxvJhGqdiYaOSDxmf4VWCgh9/0nxoppvdsGfmIBBPy9KTP5KS
 dE+D+DjSQa9fukCVzNlk1UXX2y+gqT8MzUWiECjv/rUKrLjDIKRdBi5kRNSbIL67n1ynrdxTJkE
 a9qP+KxqnzA0oV5tqqhjmnVJNklQvw==
X-Proofpoint-ORIG-GUID: h9Pr8_igJYZATtBkeYFL_fGDqysvEqde
X-Proofpoint-GUID: h9Pr8_igJYZATtBkeYFL_fGDqysvEqde
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=6920ca6a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=iwF2bFzG8rEmHyYS_TsA:9
X-Stat-Signature: 8qtc3do6gqnqc6z77j1b93fky8cz561w
X-Rspam-User: 
X-Rspamd-Queue-Id: 860E680005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763756666-627574
X-HE-Meta: U2FsdGVkX19jwz3yWPxYxzmsnw9No/uuF/Jd+DsR7Ii7u65ZWQzrU1tr5X5TaJEWDSpW5PANFV3GfOilhkGxEW+m2pRnk2ndiwqhPy+32YOophUFalO4KvKfgrPNw28NrcDu62KMQAJPVN5wLdr7uUBujMfj+rIdEN6UsTAUb3ARfnC0x9B5+QhLn2Dj3dUkwcqEBU7BJrRpJwJKgaJpgsJOJtKaoRWqb+rXBDPt97dgt+EhnXAPxP+4usRn8Dy3GVKwuxqCnI3Awv6Th+r8oxdWDjIrcrEAFqJskDd8QWpmar3hRVkar/Y6MkerkluG1I3Hbr+eTh2a1E85GqejPaFLuA29kDXVaXQocU2Rnt9F8Lrm/IVWm0cPYPgi69rGRg1RaQBfP5B93rtAARalz4m8YGZ/gXsOG1gPlqPZxU3Tt/YDTCZ7XUHAeTnOpvFpxNWMyt/F2OiFfh+/aj4va6y6nu6z1S9ISBsFK3Yyr9xoLHMz/yiJQjtT94lsHgS9TwtaYExrBlTywnqQEY4Lai7fWHvyT79jSLZLywnU+u+dHnDDXJhVpwnOvgQRNYmnwOGZqlmy34kmyklLRtn4yQLVjwocj0QNRkd/JD8L6W9u6AyPz8Rn1ZUzdXsJ+ga0KZjuPKKtmdHppwOWW9RtbjxOkOXKfvHHy7UiEAXqeHzpAxmimDjB14gQj89+IWeeKWJUlFlali5QKD5gbJkFvsLB8hGWazwv56+8PiqzymH75DhPzzUxpXOyUVZ951R0ef1pONjYJhZw46qhuqwa8G80P3dd1h6hgL2r3BE3anTy+SuYo2eyR01i5klYDMAhD40E9g8rK7PHEc41guAiqJrZm3RzHdSN0G2APaG8+Ut6vbmgaBMaxbA6tVXj6DeG2RJG6iKpXAlCA5idpY2ZxDQ6oeukqkaE73HoW2qZdSCBGxCD0BAHVLlJ588sadL5I9HHNSdJ8iZ9IY1+Z84
 EW3ABhp+
 4IVFZdBK8PkEIsA+FXzpzOV00ZPww7Q8RCJS3nx1BUGk7FlqZtiTTdn0rDFSKnAf4sZVqCCflYMvuGCaAYXuAlgqahXtsGXcqVeXsMsCQPso865aWLXk1/84gxt8uBxiPaTgwM9bmOUJtcDEqhHyfEtrCG/AZvTySXTN3pAhfOLHoMBE+kT9op+oCCWW8XIsDVhQ19oqM4UNaYVFejN6GWY8NVGI3HP9B4XdINAkdQMSA6DCeKoovGUkQDKe2/WshjfFAyGBUtrLMs99zoXrwKFSD9j2+4AE3z0379A1Dp1SWtQzuEuXBqQk3b/Sih7b92rOK/lVOpd3Kz119G/CejxPAekW1BDWkrQY+OHXGLJGziN8QfL3C+hl4qZ3FPs90vBytDaBgkW5P8MkNed/2oDFy29H1KCVqbkETlW9z5lawlLdZd0oA8rMSyzbbHdpLirbQZHd5bOamtXiqCa5zGQoYcXiRCwZgQwqCzMrDYyAWNtbHiPdlh0TNcvzP40QOz3G8Jwwm48iEL+Qo6HRWBkjYu+5sOCFlqnz+dwh7GPqgJ9R3g2u/3gKaHBp6vOUDwAi0xbK4LlxYYb6wp8uMmMW9q01MwDHtAVSZmIqv1jPfQrruj9q5HdUob0p7MiNAXja61/rmQqg0LX8mkqqSULOzS+WKsYXht2orAHkMe86oI/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size from 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec. For the chunk-size of 2MB the change isn't
quite as drastic but it is worth adding a clear_page() variant that can
handle contiguous page-extents.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---

Notes:
    - get rid of ARCH_PAGE_CONTIG_NR. Subsequent patches add this
      constant (which was relevant for cooperative preemption models)
      to common code.

 arch/x86/include/asm/page_64.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 6157bf46590e..043e57c4ad12 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -44,8 +44,9 @@ void __clear_pages_unrolled(void *page);
 KCFI_REFERENCE(__clear_pages_unrolled);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @addr: address of kernel page
+ * clear_pages() - clear a page range using a kernel virtual address.
+ * @addr: start address of kernel page range
+ * @npages: number of pages
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -66,11 +67,11 @@ KCFI_REFERENCE(__clear_pages_unrolled);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *addr)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
 	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
 	kmsan_unpoison_memory(addr, len);
@@ -81,6 +82,12 @@ static inline void clear_page(void *addr)
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.31.1



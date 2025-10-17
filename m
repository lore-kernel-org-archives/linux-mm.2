Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55430CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD308E0053; Fri, 17 Oct 2025 05:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994DC8E0016; Fri, 17 Oct 2025 05:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8837F8E0053; Fri, 17 Oct 2025 05:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 771EF8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:02:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FB05BA3D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:02:24 +0000 (UTC)
X-FDA: 84007015008.03.D9B2523
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 96379A000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:02:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ig4YT/kG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaqsWH87;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxuJATSVYaOIznGNCP/BTyBLTTXu2HSvjJ5B0FmkFpU=;
	b=m1prE8ZVbyPNGEhy3FObRZT3bf1pjMD16j7SS5hUFeCno/EzpaO6+MWvYLDSMKvCq2SbcO
	SJ4xEyi5nGhcXE5AOwbljZh82oPtXO8DmNhaoKcRTzcFhKwwZnsZvpxbg3QJcGMd8XST0R
	p2nHE44WtHiTiU0MSOGcK9aZdnH7xwA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760691740; a=rsa-sha256;
	cv=pass;
	b=Say+q1mTXYXBA+S12BqynHEC/xxc16dQpGlNGUfhkc5ZFQuKU5lmCgxb1wt67CQNOCKxlE
	49Dxmp5tbNlveTOe0LVEU/JReh7+gyUCrJ5oyJ867snFb3j1iGdb91mbZBRg0Zjf4qCXXY
	VvEd3lz56xuvDpTtg5Tz2qgrGUEXLjc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ig4YT/kG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaqsWH87;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uI6D008160;
	Fri, 17 Oct 2025 09:01:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TxuJATSVYaOIznGNCP
	/BTyBLTTXu2HSvjJ5B0FmkFpU=; b=Ig4YT/kGv2rvSmqMxnoGLtZCFrGRLfezjO
	ALKSRgIITblRgBCdqDG2+jivFOFhRWQZrmVqHSVfxMIoQ15TmV9DOul85MCbUCvu
	cABchSRlfGdrYHPUNG8rrAwXmS6qPdwHKDSZJU7yDC1XYJ+Q4QPJGwHaWQpDbdK+
	tXvTF75O+Nv1DfY87Q3n+8C3f5XTlYLrh+w7RVY1zPaFMsYdnJ+7LDC6wgT4seOZ
	IMeA2QMpSdu9oIz6s40pmRg9cFRfYwCFBG9iPojpmvY4+6dU9JLEAwxSrqtwDPN/
	GT5MqRMZf1Zbg1PcwlvQ+dvxGRStuFrwhUmOOD+7pB1KTeQUCmoQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtytm4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:01:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H6wlMd024919;
	Fri, 17 Oct 2025 09:01:00 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpctshk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:00:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EoluOJhjEzgSADSI+q6CpMgQ4GOXC+i8I7wSLNdVR805poynFtgrrXnUy5qFi1JfpJ0YBRjbOCcbz4xx/RoxKz25dIePxpeiQW4g4vm5k+qSNtooC8uwbaJEv/IqDPpwGyrntZuLgj51LYFwG2FM8WM/Cx4Cfm4xWe9XEmr/8eNjp1uq4EdUsOshDRls6sAPsKe6NmOmPf1dmi7xEHcA2XfyLkNxfFxK8Pw4OH2KQjQ6hHE93yY0FxdEIyPXrOzFlvnH3/m+HJ+gQAyOKKMT915ht2cii+8ojRDaiiqMlCLzedrIHQ8voGBMJeRfokJBgkWV0LKV1bq5nXIi5SpN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxuJATSVYaOIznGNCP/BTyBLTTXu2HSvjJ5B0FmkFpU=;
 b=pOGg6c2pfI0oSagJOtMzsRJ/Tqg4immEas+pkaFmtAmd9a0RtMVvTxcJ/P5LrfQj7gRHMzsy4OsPh4JZ2Kglz/C+8KVdOwXFDdj6oR7Kh4ryyajc0Txgo5+RibcvCsFBS3coh7pTNODbpB6wzASLMmhtHae+ItxRj8kNjk4GwVN3EadgPeilr2dojxUvmcC/XMJqlygYOMWTdiMS0Sruf78uU+AIX1fMZChBdA2tVukIYOVyPfXjFp/Bs5rnr2h3G49s5PZasg3Pf3XjhYzqoigScOz/NWEaWVV1D+WYYQXLBhOWpQi8kH0lhUxeAL+ZCg6UGy2PgtybW1e8Zt9JFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxuJATSVYaOIznGNCP/BTyBLTTXu2HSvjJ5B0FmkFpU=;
 b=aaqsWH87sGa4QKOXuYUqmRdOmD/JZTdcvn0eJtox9sI+V9v6MwH95Y2Fs/tGEhGA1XhD7c5Ep5rhB2xAcKuS6BVs6fLbGzwQQtT8zcSbmn2HuQJh9Uje5dJJTjaVJsPFZFKWOMwSB1wIMPoE8UCPLrjg8OObimuhlSPrau9dGRQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPF3B1F60C81.namprd10.prod.outlook.com (2603:10b6:f:fc00::d17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:00:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:00:56 +0000
Date: Fri, 17 Oct 2025 10:00:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        minchan@kernel.org, david@redhat.com, Liam.Howlett@oracle.com,
        rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
        android-mm@google.com, stable@vger.kernel.org,
        SeongJae Park <sj@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
Message-ID: <bc45ac2d-abb9-4ca4-8da7-c737073aa24e@lucifer.local>
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com>
 <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
 <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0243.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPF3B1F60C81:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f18a2bf-9447-4f56-ac63-08de0d5baef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+EG/GIBYCj/hppCq/cVKzE9P0ziUFlNW3N9WSSDMMBQ339yLmfa1DhfbTX7h?=
 =?us-ascii?Q?OsI3J+wEZxdfJ5cu9y4ljLpJXAJR87tsXw1hTsifSYGngn13aMvH9aYvE5Wu?=
 =?us-ascii?Q?JOAFwFbkEbuYmwIrnhXUqS6o7+vYjrJ7vbR9HygAOEJEYquLwKKZEQBM/2q5?=
 =?us-ascii?Q?8FsaRJn9HcdjjXVzd5tWgLWYIIY+a2v+xBa+KzhtBse16t3W8MLH1iqu6ZQs?=
 =?us-ascii?Q?POcQLkqC9GuNEaomU64PrE18AClwgAR7luXMGOmKWzBMcEhbARN5lVAvnhzk?=
 =?us-ascii?Q?2gmHl1sIzVyijIMx+3QOzQhUkfdrTaYyRmvaVAwTGsmbbDygFyffSJ7wm+gw?=
 =?us-ascii?Q?o8piHUQclltQP3QHhBiohRp/Q9IZ1RG3F4VajN/5ItBfDdLBKDEzXveD28TC?=
 =?us-ascii?Q?XeyS1MdAm3bKA349f6fifGqudDp1/QHJ+iUfdzFGZbC5/g3n1n4Xrc55k2w3?=
 =?us-ascii?Q?Bw7lbLTNSv1WQOE74QwIBThV+YQSLprNYdpSatiMWq2K7evHaQWvcBJEYwk2?=
 =?us-ascii?Q?UexwVLGHSj13c37zGOAlKOaBdLsT55Ur7vGPahDhlLNRmj7Sm7vt3oC5/xeE?=
 =?us-ascii?Q?dQxv0VCaSJz+jWudVvYpt2yaAa73qp7olqZSB6tzEOu3oeWzm7blLQ3e6US6?=
 =?us-ascii?Q?AUq4xYq9iKEALTzCbYtX4AGbndq4MPi5fXxiXMU617gq7RuuBtmCjtMrehYF?=
 =?us-ascii?Q?Uox3Np0g83l35w4h8byehIvIMPN1apua3BKjqsznWpl6RDQiYvq0xa1Q3ckD?=
 =?us-ascii?Q?congENLhT8HnovhBFChaOBh4rk7Mf2gvGMgEEDJ6UlOOTMy19u7fg/UaHq2g?=
 =?us-ascii?Q?2H9pcDt/jWOAU4JvbvAv0nTAgMQcuzAdCAJMYcXfqEQnlGh1ZzdgAmUy0xvL?=
 =?us-ascii?Q?sQWOdG9ONdov4wXzlBfcbF8J70d57DIzk9VXNqwgG10LwYm6NAChcIQg114a?=
 =?us-ascii?Q?K7eM7TjvhoJ1J0F7G+nQZ9gzet2wEoElMrWxr/UlnP2Fp83tr7alqhClqmcb?=
 =?us-ascii?Q?qnc++BE78XJEC0avxvyg7zH0eHccaKHiWSPDigLSFBcchlGwwonYBD9thb/a?=
 =?us-ascii?Q?GLNPsYIOIIPo0y7PhAmtI2BNSTv7JVf2nqdhB2+HQbukhQru7IrABc7hTo2x?=
 =?us-ascii?Q?fw9tIR9+EGFGrMdrcIuM3ZtkBosDE9h3+iq00cqXBqSIEStHyt6qzQ/vKuZY?=
 =?us-ascii?Q?dGw693feAhluk7Q7JFZbmrGmY/l8hE3LPUKzjSRioG7d5ijxTEnCRgBY8AP3?=
 =?us-ascii?Q?UaNScGVhi+3ZVXzAdPANVPD+ESzZWez9qIfGcWGr4cpm2P2hNSXBXo7tQYcw?=
 =?us-ascii?Q?NOhoQvvbAxx13EK8cg1UFR42KzO6iHFixMQEjvWwXztVvnQhHuyVSmdXyws4?=
 =?us-ascii?Q?meLU8xGX6sY19OUcBPNHvcZqSabP3srsxhzIiSUQPrJwGxG9f+jKDsZlGUlq?=
 =?us-ascii?Q?vHGgPLPQDdOYV5V+WMVMunnnVW02qu2v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cp1MVji3NZoMjsrcU/BXi5vcUVcHTComeIozBeD1SDN55ry+X68p43DcOTES?=
 =?us-ascii?Q?3kp9R7NTWvpxVBdte0Jot7Nqk5Dipri3mV4hm2Ry4nXlPyisr22loqyac7Yd?=
 =?us-ascii?Q?Hrih9qMJRhWMD7RoNKlfxrxl6gE/lvY5r5RbUbRTrT3cWNK/buQk4COg/Wqz?=
 =?us-ascii?Q?OakmVwsKqgom75m+aMM51up7zn6BqBG4nMOygmYSr3BOH88MqpJKV9dxkipE?=
 =?us-ascii?Q?HQoPp1laavfuC8Fnj8UST3NbTOeQ/KoGTULyoO5og4tCgmbcfBNYct9k/hz+?=
 =?us-ascii?Q?F5Q6pTB+eqpyjWz6ce25RpdhDPJvjd0UGwU7ZTYqusYJ79nJh/SBL3/A5cdB?=
 =?us-ascii?Q?RLJSMqQt2ixXGOcrROoZC4Kg5kUf1OXyMH23/gQla+KkEOQsmmK0xFFZK1Fj?=
 =?us-ascii?Q?+Z9lOmQUssq3aRSNyMAQgK1DoEcXc0oALB5B8e5Y1caKpPr95Fjxm7EIqSBO?=
 =?us-ascii?Q?swezJpj3A9BwMBbCF2HdNqJHIg1Xbcov9+Mv5WkwAVx65U7CLLRAMWbdEApj?=
 =?us-ascii?Q?lIoVhO2gdDiB8GOOLAeW3aZ2E+ieaDXEFSm9AWgixyCrPRXO/wfEVCl7+Hvh?=
 =?us-ascii?Q?ybewHCndoLxxZTND4MJ5J1N2lR+kOH6sznk4xxnOvKT1hKFBcF1ASEcTZb0m?=
 =?us-ascii?Q?C5HPv9KU85lM7fWSucEYwwG7MKeDt7LegpbRpO7lRLmSPDJ/jMn/85RG+7ZF?=
 =?us-ascii?Q?x0zOIpphiKwyRNFXgTwaaGaFTbjWShZqltQS/y4zkU45wM193WlnEtmrPleb?=
 =?us-ascii?Q?tc2ye8pGfDrznUa/0OU3Ri0Z0X1dWu8v0JZPHehT1d+arNnsD2k2rgPwRkIh?=
 =?us-ascii?Q?q+L8poqyB6V7YNbDehDWEuogYKz2/Rdk4gm20lxaIVt/FRoNL0ehyw2qkyIr?=
 =?us-ascii?Q?Wxqc23JHho3y+VQ6OTUo3R3daobUFyhhTK+szdbL4/vSIAbekfjI7WUAWtJJ?=
 =?us-ascii?Q?yH4jLYsVXdbNbiGpLvmJsrQpv0lyN6a1QJTOMNvENoINj0f+D8644phavlkw?=
 =?us-ascii?Q?fTApPJWzxBM/GKFGokkh+Pnt6wEIcPLCERbsQt1VIFe+qmJyWcT5SsWIDcX7?=
 =?us-ascii?Q?Ox63+h5TxuK1NE1dmado3z+Xg/rsrpZb6vDfjg83V8CmPVBoTSBwxvJuW8wV?=
 =?us-ascii?Q?TlY7KLk1wfqjMetwHIEd+3Q3wzA3hACae6iR/pbqkdKNfoTKDjdGUFXfjkQP?=
 =?us-ascii?Q?bIbUXFZwP+kGI6V1p1PXtlTYUe8MrTU0A+GufaPqNYSfuc+Fxse+N3yoBQxg?=
 =?us-ascii?Q?AF7m9d5G/E/JsEFeTyqAY0/rZ5Ca4Hkczv6zmMsUicWQHOJHdbNrMYNIDs/i?=
 =?us-ascii?Q?Pid2qZL3x1pQheA4nCsbRWSRa7qtYYfmZ0r2n4fyQWjilZUUfOhSA1zegXU5?=
 =?us-ascii?Q?UrV9GmXQpyVUqRWP+1L3oqM3QHDaf82RWXJYnvea/3hS0bOvsmu2b3xDA+cu?=
 =?us-ascii?Q?I1WqqtthrLyNjEo2LOjOgcwlYoUf/fU6vn4+kx2LzBbR01SIR5VgUY//a76s?=
 =?us-ascii?Q?NAMdhFIapMdvE+HJ2Askk1b/6BH3f4tZm0L+5z++TndgFvMwNGTBlLsb9wzi?=
 =?us-ascii?Q?nqRg7ea7enOpxf98q22ylqiKRiJJxQy4bFu4uQBogWVni93C097ES0NcvP4G?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9lGhN0V0KNRdD4JcVkFFRyf5BDaF6pAVj0fLopLIukRJId/JDckj/5rQdaorh/dBoyT8122hZS9ChvrcvlYjcePp3ID7qxDZHjSiNbK19GgtUGLThSjqVtw3gxDZboEzaW+nncL1Qylu9XLxqcDWAU68jPeQwrOHfYqJmoP/CwxR5DGYzcMTGAb3pk4n+lo/w62fhBUgJFg3dbg35XsDvThOGIhskGQR7rp3eJR7gzFpDKZwm1ViiPoIHVfgJ45RSLAf2lZUHVmIYaFNxrZU2lFOw48NH2Bv45rb7SOffswYhqJqcoOIFnLZLi75MZ4UM7yqTZHX2NHk8t5+B9aTKDqVnmJ9mtta+dwkomY5jJZRNY8amCrl/s8rTxEPHGGlE5nllIj+L+T2h990wAXeGja6XV8yRRVZH5SEvqXkunja70aUK4lhFG5wiMKwAMpdi2A0Jn6QXu9+ma7jFhgma/3dy7joi4xDvA9bvSbcWkMXUYjGt1AavsP1Xx32JdFy+UPKjRbIwInV2OnjgASnIaaOVdJvq/iHtO1vBYHDz3xWPmqRuGIrAIGI3TTHF9fLF9qLzOp/E06oZ/3SL1wolzLAMZ6tVNVfmVQ0Ew1OfNs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f18a2bf-9447-4f56-ac63-08de0d5baef0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:00:56.1971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yz4MhjqzLOkXQ4WNUB3QT3loMrD5sX5esnQWLNZ0aw5HNF5pLNnhktZWqpa0qQHgm+iCI4BygOfg/x9QIHQw4gZgdIk95KbPikmMU4pbfBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF3B1F60C81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=824 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170066
X-Proofpoint-GUID: q2kR8d33d8jV7uUN0X3TfbUG6WKAfm2b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX9mt7wSkM2imW
 W14y0Hm2zzhA8+BS22+kZsHmojK1ACyWQVpdBr1YrgrpTrSA8XvmI9rG6dpWGWPnjpoP+3P8e9v
 JJkbb4fffjCuwPITXVL8zPyLfCnRGvSJ03xNfoARJL697ABG6X4bG4zKfm63avMERlc3b+9MFnU
 iG5C6oznagaEAWtg9AShaOCKq4jiYIC/e8M+Dcm1tvd750NhVuwToAyc5osOv9iDbn/GYLk2T0j
 Lo9TBFz+zuZJKi3TlN1SFjlrwE4XJh6qvqabKZHBLva/8lU3HLFyoiXrMdDsEI3pvESpua7VMPM
 rZkob5sJg4+kZbAN1RK90Hv1QomjVGqZ+Ujb1nZzKpDTAoYAWYDEbiKiTf5wAGhs2UVbz2+uTHz
 ocHOgbHV/E4o3Fz8g7Hkj4pOL1pteA==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68f205cc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5EUmVaACWUl__Ca9iekA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: q2kR8d33d8jV7uUN0X3TfbUG6WKAfm2b
X-Rspamd-Server: rspam01
X-Stat-Signature: gpkdm3nkcfptarmct4r7jy9pagupu61k
X-Rspam-User: 
X-Rspamd-Queue-Id: 96379A000F
X-HE-Tag: 1760691740-294196
X-HE-Meta: U2FsdGVkX185MhbLQVdhaH+R+XZDM00WJFFqplGeYvWoBPOP4QknQFSu1fHGSQqtEwbNd+sHezfmMLLmlFUWnF4PWjo/LtRxnTPXBIRHspn5sXgKWgcXrStahs4YtqNUtKy5XrfH/5mjjZa6V2oPYg8LRZu9Sb8wmre4vZ64+J1tXqI8lmeMyZPdKsus6VDCn2orm6cIfoEQHRCuaG6ru7D6aCa8A+oc5LNgfY/3VsPIuam3G8tHcPTKk9j1CnYiL4jNESITnHCwcX02ho1waW1PkYjJxI5Kyr+2ZMqEDTqWS2IZ9ygkcQqJJSqNHlRb9O64UY6jlgLlpEoJFS1VUfDvV0XgNMthWk+b3L6xacOi9tKa5h/Yn+YcA6VsHoz4r6yFzrlXB4x+Yb+ilEPJ+/swG4XwOADVUCmLLKtj12aRDOFo8qPm+t3IPEirV1zs5Iaac4pJnm2PLf6lzUsA+uCh/QjB7cV4usdYUVR6oUNh+P5WOuW4bzv9GfKWAXvLykJy1wgHfS0f5aaCDoXCPgqohHkUzrAjOqy6xtIlfPBtSGZ8FXnCJ5YwHYsweGDLDPKlQm3XFblelYEDXIFDVkD/wO3PHuBgUC44KFvWTAf/xCFS30i+qQF+HhtdcHdFtFh5pAUA1VApLun2H/yVTF1n8QSRkK7CEdHZ3agpBYj7MQAX0n9fGrG26YbI/26JJWdePuFzfX85Nd3J1vH9RDSgZbucte5kIrZSkYOKrTMe+RBMA8fwYhlqLSJ1nv9TcTuMJ+Va5w3crhte19i8nhoWH/YrNi5gd+HE1slH0ZbhFgfGNLOspf1jayhdysk5zqj19VWWxZKNKrWQWtPZZCPLoEvuHmRpkl3AI2peJ0s9d/GBucXQz64iNnJ0Y5SZLOiqFRCX8Ky3IGYXa3P2IAdWFvejjN08zMhMc6CPlnf3UDJWXNnst9ecyIiPyKlJXRa/78rwnfDUhZKOWF3
 jrOJbNoL
 zjv3FtlSzIR2CC6CO/gVgml2PE+jqmte5DR/TJ52a8467xf4TKVveBsL9ZBmX8H5K6RwUU9MyuluB7HhHpXB3KTTE47iUh56sJ7xGJFt0+WJ46fYD7WEwy85NnXElZbwFeAmYIFrg0384tbL7+cY0R16LVasCqvpYtu5xLSndgs+bf08/1JfUJPWiC0PmyEz9Ky0zGPtaPmqawDxbXc4dh10fc59Ei2s41p17ATbGRaPG9SOebL3Qrl9dJjwT4mFfofiCtMSFntbYGIcS3/LPbH6uj6n89mcy4Ue5CCAvSv2iKE6ItrJiSJGA0idHV9OcuQ+D1YdIU5oUdMsjKZ31pJHgUOCoOyBtrBMnRFDV3LXagC/GpukCwYiesq0seciC4UjHrICDnkfdSpzOEHMXFKorzNkyfrBu26Zcuecb+13kH929La5PZWsE6FC/bczF8y5d5/qYpplc5Cngek/RT274NHO6DUCSmKR0cULA1HMoXex324dIXtCadJvfKwYpMjALenprg77NmCZzvFbPOh27I0cFCHpUeGlzriEOvWLKGTnXd9QTC15pqVInEeIqoWhHC/SlG/wutfjamVGm8IWj9BMntCFq2xthLVUoIyD3z1XGKRQyxWn1xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 02:33:05PM -0700, Kalesh Singh wrote:
> I will drop this patch and the patch that introduces the
> vma_count_remaining() helper, as I see your point about it potentially
> being unnecessary overhead.

Please do not drop the helper thanks.


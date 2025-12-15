Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7E3D5B86E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD2F6B0092; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD416B0096; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30FF6B0095; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97C856B008C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 486595880A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:56 +0000 (UTC)
X-FDA: 84222897192.14.552ADCE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id C16A91C000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hDtrdL4e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gjc+8Vuk;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3tcWKLVvubDbCrDVR1D6EBziYCU7lTp10q3bB9VGrw=;
	b=wNpAkCuOWVoyfeD7uoKVESiByk8ygkhqomo1iR9d1Z5ohSLKim2q/tYkU7rH0qPk4I73zL
	tsENivBRTp0k7anImMkvh/0K8T7gqQkE/0kuqz5QAA/rCEHsvYdcoPA/kyVl3ZYYFhBnof
	0aaRWsswmOLUJmgwrmSWnwkt4sdympo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hDtrdL4e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gjc+8Vuk;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831793; a=rsa-sha256;
	cv=pass;
	b=O8l7FINp6cY60XUygweehsSt6lBsA6nQVFG7pVHUEsN23u+Fg1RUMgljevgHb6JBx2v9kt
	RqmUoaFDjYslDUwW/EkuUmkGrtmqJ5fPGiMmXf6ry4HR62K9g+66aYTHRn3PcGg1cL0DPM
	YzqEPGau8b5dgF7Xj1EpLd5HKQNf/00=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCNU52886214;
	Mon, 15 Dec 2025 20:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c3tcWKLVvubDbCrDVR1D6EBziYCU7lTp10q3bB9VGrw=; b=
	hDtrdL4eSdTKV2VBIRwba1l79OM9CopGTTpTvNKPDPe9kBNFkPF8EDh7PoPVl4s1
	DHbJK+NB1HZfbFCwf7nkNzM4NQaHMtYxB67HGikw+F2Lf+rW+sjbqwfzWlSoQ9KE
	UFL6fas/n5qGBm9dwvMRaly43q7w44guLPqTePQas8fBUyiX4LjUKM0eQihNPB/K
	BPYM1bFqULxIFCCiOWQejrktOTxgEFFxTf8V86uRp4+Gmm/WPkD22vlrTdGJlb27
	04X9ijuPu4nrSi0/nLgf9vX3yqF+qcJ6GJ2YIHYrlq/CyYDq0r8M7d82hxrQrf3X
	ucp+OuYnZgXahBUf/mtqIA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015tsu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFKAmZZ024769;
	Mon, 15 Dec 2025 20:49:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk9nkv7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H26equEuWTHQBS9P5eay1UXadCN/AV48lRSwTr9e1/UuNZZ+ENxZbslFvhj5XV7yU7gRCnhxefkNyJuD6iPzX5iYMH6LkVKidO3L2EQ32ryVQh4qOvq97qgaGpwI4BPEQcObh+7nZx6wGDIVlryggcMSSao1VlcX//oKaDDzYKHwsq0cdANmHyJ0vFqQKvJqp1xfss2SxpMoFAu9RzVjmafmeQ8WnPgtdkSvydAZCQL6Y5WpYC0eylGheNG3arOSfEION/K7gCyyU3LQWqPrqwZeW6G1iteRtCXAB2pwG0vcOHcrW4e6IolsNCcmhhhv1S7VEyvZOglNTEpgFUpHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3tcWKLVvubDbCrDVR1D6EBziYCU7lTp10q3bB9VGrw=;
 b=N6A79lPNoRldz4cufCMT6/dZKjZP0Bv1fwPwALg9e5L3PGDM1iBPnhUFaDW6lb/VleQg1ZOIXQEIrdrGNaKK3oqd7zlz3fUNU0SjEJzqR/ryLymV6AEsedKCF93q0EhuqGGXjTODgfADbTAY7xEi+owrvtGZg2K5zyixeee50gcae3DDw5AuUtENkjFM+Q63bQitONJFXEwyviI9eV4U6Pad4HgRzVGx36Hm6YV+aqHarsBt7xw8xZIs727e3L6ilTJxEkAYjKyTQKUlnW9mrjMCDv/l2jVv2i5IVi8w2XRn+IAMSlm9Pd506a8qXQeS/QbF58mIO2RLRpBh7X5VBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3tcWKLVvubDbCrDVR1D6EBziYCU7lTp10q3bB9VGrw=;
 b=gjc+8VukJ1q02e15YtfRnG0KhiQXL6WIbvdvXywgfEjijB8KpQGSvn6lAPkMeFCK12pyYOnD9/5gUFVPqDFg0U1gmMsmgv+wxH/wUIzHndC387l6HEpo8ofzojAAuKgtWfy3IqplXQ/TzSoAWfchuzwOifPyNtM+v7AwMygiuw0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:32 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:32 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 4/8] highmem: do range clearing in clear_user_highpages()
Date: Mon, 15 Dec 2025 12:49:18 -0800
Message-Id: <20251215204922.475324-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:303:6b::22) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c35105-c85d-4a91-bef3-08de3c1b72d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jmh1nmh13CA72eYAgfUr12dBrGIXcawWRiugsBz8EN+GFbiOyW/pyNrdweIQ?=
 =?us-ascii?Q?jm/lp0WVEJyB3wr6o7ii0CukO+uPahILIFzIvnZ+Pwx1HNOHY6/nK3TegO70?=
 =?us-ascii?Q?KWUR/XDKk6bOnx6Woa8Vsx38kyzyVJtVNXbbps8jDkTEj8IPYjU07ksSNvPv?=
 =?us-ascii?Q?iDRABUByiujAngXsPnC1rK0vrLWwgs4N3FiOSljHMsERyHJ/TJjzYxt6hc4W?=
 =?us-ascii?Q?ohJGo9SnbTdbeOa5yJSu1FmI2HOP/inqOSw7h+wYbPz3MAelVny6D8hNA48y?=
 =?us-ascii?Q?4xrgCRV/dTpVlbIjFN3d8uo5/3F68HbPmsekHiVP79yyKFXGtn68zup5J00d?=
 =?us-ascii?Q?NowMcHQzL35yDkC+8rABq37v7ZM+ei1L8VXKAXAjeEgcPRVZ5Gz2kTRoVrSd?=
 =?us-ascii?Q?AlrTa7i8PW0JVcPij6ciAJ0iFX1l+20lQw1PuGnVijHVXT3ET2ROp/OFJt6x?=
 =?us-ascii?Q?UI2RgPBm7kJrlvldZ2koqjUtCpF338iRjYz0spocg9LEZZAOgYy8+Q/4k2Ul?=
 =?us-ascii?Q?oxnrK07dPLfXiQ34VpA+nyrh8J9qEU+4UG6zfUlUTeGNvE0ykKGRKRmdVbNt?=
 =?us-ascii?Q?Vilz/OCOdpjf5tYieL4UBYaDEyufy4yzuc5LVQWrcVz1LrNbfkSAY5YPUpcr?=
 =?us-ascii?Q?KrcJCUZOrwC0qaQlnrtfkDXtigEo1mdXBF1XpBsIO48bJt/Ryolru8mGUSjE?=
 =?us-ascii?Q?B+wrTKRt/32rJh8tIRfAoINlkvrlIS2vDMOXczj650apceRRp23Kh4qoC3Dk?=
 =?us-ascii?Q?+SusXBF52xH7gUcIJXTfvbf6ovKjOCKGNjqoNccLrGux2GZ9sgRcppCqqxIg?=
 =?us-ascii?Q?Rikmg3+VuBqn1x7H5wmUy7WM4Vp6TiXbIfHu+5EmELFzF0zGOcrpcVdu/Z8V?=
 =?us-ascii?Q?XOh8WpSGqgtRYceKF/GGcmeyc9Efg3dyYpgJp4mLJjZSRlAGySOpBQecVewD?=
 =?us-ascii?Q?xc7QQp5MZ1VBStgktDQyYWOOru7BmfyGStkw824VhmdX9+DNxU0As3dn4QjT?=
 =?us-ascii?Q?wqQ9M9dkyKfgzGuPZ4z5tYOV4zuCh6ugiiVJUf5k/j6fJc6eJgkbF1mLCOSk?=
 =?us-ascii?Q?PO1Oq8OLZtC3OsbWJLTekyPl4vNK1DJUUb5T0lD+cmTcC8CftWvvDe18PTea?=
 =?us-ascii?Q?UDFs6MQ8x1F9h9DnQACwRulUexCtbJWsaKL848QYOlhWTNdZdyvQW2ztwfBF?=
 =?us-ascii?Q?q5rkTktcsmi7lkcdPtR4brFb+zoidXicqFqY7aPKll6VTabigz9NPiIDNmwJ?=
 =?us-ascii?Q?I2l05BAwhnSxSVNep6zm/581YyKQ3TQx8g9rcBl40s6z251VTSWZrZjfKZRA?=
 =?us-ascii?Q?WhIkxU8WGjlPU2K0o/RGjP4pG7XqeAxITmItrraO+eyj3YKI8d4CwR/AITUM?=
 =?us-ascii?Q?tFzb7B+OFuDimQyofkL2ULTCiEDD8BD3tEnLUuLFrZm9XdUIetbpbRSIFkL9?=
 =?us-ascii?Q?h0zXGp5XZsFbgDR/FgH1Sc9bcFS++hcA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ULCZC/d8HzlMrNurBsq8UEvzSes6IQ/+z/wDgJWUnMwE9CXKmw4+BuAjECkV?=
 =?us-ascii?Q?XJfPaCEURxz7MHBWp472KAf8o1G3bkI5jg6W2rKlbqY76mz2hBMgI1QWbQ4b?=
 =?us-ascii?Q?x+ZZT121AlWL0qZGmBvNHnfbx5RXIHyVoSBXRWnYNbzupoRtovM3C6Ka12cT?=
 =?us-ascii?Q?np2K3uTNQURsgzrWGU3m94ptAeps8V2/hAnSqsJqnpL7r4JW/xUsLZOgHr+o?=
 =?us-ascii?Q?1F4ny0rxaQvSNjDMwsN9coL+M1t3UIWswcVvjH40K0DsBP6V9r8HIzCwpEPR?=
 =?us-ascii?Q?kaa5qlabglN4Uilw3WiOWy5hHbY2fJvb8IJdXJeycujili0awVNJdHEYYt0W?=
 =?us-ascii?Q?nu5/45/+M+lTMUe/qou6WJ5Au2abeQ+Eu974tsJBGLmOe/sx2kNqB4oFmp81?=
 =?us-ascii?Q?OnXi/PSKBfDxNGiiKtD6MFIh4ujTxCqFJICzkup7YIv0zD5KpkFni2ssFHnM?=
 =?us-ascii?Q?rExoy0ln1PkxH+ySxnkvR0uTvmfDnKeOkbyA2lUJf0AwiDab8bjD5s13ZBSA?=
 =?us-ascii?Q?LGLM11/VvzTzDrOLZub1Vbp3lSwlftNRms2f3MxjQdnpeWpzOIeiPQ+5K0bX?=
 =?us-ascii?Q?gfwYDK/oU1Gy9jlbrS62ex9dFP4vCvnHKGIWkAfnE163os0fr96Z2i3AVAWD?=
 =?us-ascii?Q?2flPRoFPytm9p5+/n/W+iIOvlwOa8ENlqhfuPiYKv/K10kFTvOUpUeRpeGWD?=
 =?us-ascii?Q?mJ4zFE7ZA9v/yU4UXLLKfhRz97090LFAChiwY8QPExLtSXFgzoOOr89/ETxo?=
 =?us-ascii?Q?2opHeYU53G3h5KAKPLbdrWzzeUjA2mvhIhoHZApaOSdu0L7SQjvnNXgBIp7/?=
 =?us-ascii?Q?cALOPVCKAZp/Nn8n765mjGZxExZMe1Y8MboEZRNkNKisfnbpUir3muurt/o4?=
 =?us-ascii?Q?fwrDe4zSS7hpVu7U5yuHyoXcnxcerzyMizBXE06YaXR8S8sLQJs5eKygsCIG?=
 =?us-ascii?Q?wLst5mTzPvJZHWQmrQCU3nyZogCxRjZXHsJloxLjm9hjvnVbr+s5xMfifv05?=
 =?us-ascii?Q?+Ll9Hh7XYH2K6cNL57O8pbU+BgPIV0gGTO8qe15P65qSuE7fnFEqcrOCOc3e?=
 =?us-ascii?Q?Cf0sS0LL5HI6l0ArFz+pKcsmrcVHTbra+E/Xg909sJRkhN/SDSeGXogCVDVL?=
 =?us-ascii?Q?OMDVF3wxqlq1hz2IESGRsLG2bVq3cBjEZz8rmTddHNmphPW5DEYcq2QHw+gS?=
 =?us-ascii?Q?wybegepvBwB7Yd5MOQSXWXLhSzMsWHNcLTr8EPvoJybx22qcvVOxmSVzUQMN?=
 =?us-ascii?Q?GutD8jyqxGmytimAK+/grIQcBE3tAQBdaMnMWmfLbUZQcG9ee+b4XxsQoEo/?=
 =?us-ascii?Q?/H1XZWOIEGr2nO0YLGRhJX5EziobqXALvryLuqr5x6C18IbcxnmfJCrEh8UA?=
 =?us-ascii?Q?yNBft1H9Wc7y3GaCzzO6aHgpOJ9Y5xzfpCC5hfFIFKmPCqp/exZiO3aaHfSp?=
 =?us-ascii?Q?HK7F12AVJmfq/GiS3v/fhGcBT9dJ/yHRqnDiAdtXFkU/J2TRj+PcBbkum9Um?=
 =?us-ascii?Q?6HyQWHmcOc3fVm7ITkAfQ2z9heWmRzca0ui/zK8q/Zff8EpETc5kVsvC5W0H?=
 =?us-ascii?Q?p382gPsRmQnJd45CxcDfRU9yjkm+MW6CCE4A9ZR7mgYrz+1MxfmMSe8c0OdK?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9pGFXM+qx4i6uo3otEDMUo4h5ApHCNIYkSB8tNtCe0t1TCRFEMaycyzRclCgfYfPg4M/iAQY1otiKTEXclUmqjt5DuWk7M7TEUUoFAijtilY+7tNYKxgAtpYv6UAiZaOAfOeb0iQqlp4jfsIQUlxA1sGQ+Mwn/rQmUqES9ZRfjSdaQxRpVMItO43AMNgXZznkUnp7ZwB4SxB1kdIcOtgPfnke6jS7iTwj2Bd29fyf0PlsppmJYJ6hM8xOy1MH+7utK8GTBizC9W8hs01oEoRV4jDvV28qBW/bKBTs2zxF+/iLPi92eiDYTh3zbrP16V+FYteDohbOYuFn3NSepJ/AWpMp+3VyQLee1Dpj5qMxeZp16APUT+WGPEzzjQ3rfDFa5xBVNwc3zKos6AP5sr/VA+FbBF9hW3xsjOwfbYODpCt2LsmG0c5Ln/xbKZiQaPTeUr62TnFlZJEji11n4ntAAN0v0aXKokSHmkcwODUG6JJTtqq1f+SncUszn2sSfvFwfTPbSpjJpHqXSE4romRMo8imaEydXUI/0k0ddWNsUBtI2a4TEhcmScpVOyEJ0sxyjxp4rTAjjBgen2D4kXLaXyiCmgYSeYNC7oIDoOdxqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c35105-c85d-4a91-bef3-08de3c1b72d2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:32.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9kI/xF8lq5hVSxqM9TtwPzLxR0putdZJDftVLYqzgAmlGVpzwAIlBwfYJCC5yzvbn5lT/08uPXsq8ITqgkmCOcFHR5UIKJT6zPYRV/QRjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-GUID: PDBTjynQKgegGfFnNcAGZP99MsGQcOND
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX3EkHtjs/2j+O
 klzOvb1t2jWlRVjEhAD0sPjLDaYXrXMXMTj8xZrbzrtcxhMLpQ+a/w2V+lRCXC0bFWUSe4DRv4v
 TiFfgHbtceqC3URiwIRhdFblBjaJvBuAKgEnK0wdNSFFypAtmJENILalQO+LFy3pyAcd9Y3WUwD
 WlPuar5vUigBsXoQiofRCj4gwolMjVXfT37+DaZHD+nWwoNJu4eaI5yRjNVkSj+VIml5UBHtZah
 CZxs9LBHChgkSi9gf7gYAz/RVwYLKnhO6WBeYm9tRJ5z3HgA+tKc5gd5DD8IrYeK/KuZSCRtpPp
 aE4hwX1rm7zZ5ivjAt8ibdY/s3b8aGdOfREZJMcvmjh892wcirk87FLkBd1ZD+BTOVwfwN1t8qE
 MHbVxCV7fAjgfpM9LqIt7hcm25cIOw==
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=6940745f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Qx4JLxr_JFo8y2O6NIEA:9
X-Proofpoint-ORIG-GUID: PDBTjynQKgegGfFnNcAGZP99MsGQcOND
X-Stat-Signature: 8tpzxbo9rxd1hfuz863cwgnabzedhsi1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C16A91C000C
X-HE-Tag: 1765831792-486608
X-HE-Meta: U2FsdGVkX1+ajTQtwPw+ItmTsYT46ddbFozOPcMzvcDs6XQxIx+0hwKCrJwzgfyNVdpRCql6jlZJ5wr+vY6nrHfIg7z/rPYT3V3Rg6P8jw1ZYDH/2R+RNKdp9FoFSk5T5A1zwYLoUwICnkHETRePufcyeBnsr/SM0FMDhKiXqkvK/yHJIeRLViKPu4GF5tY2rXTqhgLAwsO0cmcOomsS/q1LRtdXiiXWzfKMN608vFYKs0aOpknZnP+ilmQHc2dQfFtpxfPPFv3gsGJ9H5l2+PqxMW8Gh9BKk1IGw/V2zUGAgRqnrXdJzDGadUSy8pAh9hBColxvcJoVqikeyyX2AaNV95FVpwz7n/Kvrbt/p3dRGXp4yOLGlDIjkmuoUHqKZckwe5lM/itTFhx/T7xRn+lIGoO8qaI6D6ADCF4zcL953+nhe3BzGuxh03bMB4bZb5MIb9BLR/s20oCVrFXD2bpZEtqZ/VY7kG9y9P1bObhCOOQS9D6PnmKWCVvpJi2fatKpGzMPsBfRnBfcoSYTAEqozc+XLsJZm5+Wk8xw4D1naSynlY4LPhb9O0uvDz1RwcSeJlmfkoLjaVUqA+fxFf9z7fjBfUyR8p3GiCoA/uZqvf5zkYjiMTH+lcE8dN5dR/4MKGlVgQ0W6pKB1sbeVsbewCT6UDFFufC2uy71HEuKqsdQihHl6OXh4TP1MyZqAbiveOMucqxKlclXUwSl+vCJSoKPSTZ+Mv0fntj3GeqLLEpQzFTTiN8fhcFrF3x7FCKSqGO5lp7GuuC3gW7L8171dtYf9NJjVF3C1GrcSXdPwfowh1Owv0K1psIkPq1Vcl5udKvC7zGFVB84wDyM1261VMwsPcXCxXZ5O7MKFiPHM/ag9EQ/w/4Dm15R75EAk5fnudNVr75kzKkhVBaPF7Sh6jJisiJy+6Wx1QZc3rzimE1Q6T6+shsT7UHCbGs3y7Q5fiKUOCO3MLSZ+8v
 Rc5DhaM8
 CC6wo9yQ9ocxQq9o2fucZ5hXjB2Wqun2ByeL/vvXs44WgsLBZC4A06xq/o5YXJMvM+mjCy+t/ofDCn1g2ekBxsYQfqe0Ep5tyOkaudXffRu8BkqDnsKtu1vOiSolNCRuK7LvoE3JZHDNRJP8tQpYB/akfY2aiGZc7TQ5HXXF+7mYy3Ni5lL0hfBvtpLnYgg4LixFKt9yMCIat+0ggQDUFuyL1/K8AHS7S6hGJ7vrEG0JcHMtLqKnsy5XCrUL5cYEen0BoaIr/fTpkbQt6mDe7WpbApgK0g9BVeuBNB20EULLPeQ5jqpREAeSwR/APIjTc0EEd9pTuO3lAuRXBPS+gD6rpad/ik9c6b4S5rGO53PEZlyi9ONbkmuplSICRTncaaK54edcyTgWrePNeqWDz+eomMZY3thUMieOvLaKOFx/UP2hNZx5nQmUADdEfYJl8KHQg3std1zpCaZffOc2y4wZfgYTJ6PMlwXMCzMvmm9sPtBS41qlUddtw98LGBTjH0Hgej42wZ/t26A+T9RRilO+n5cJMTTTMBCwMHgXFAuMaAr3opPBCwDJuxVPNMLjVLMMSjgM5NB1Rgymjr8ftrA56K4/u79eywE4Bi9ujovgMHuU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the range clearing primitive clear_user_pages() when clearing
contiguous pages in clear_user_highpages().

We can safely do that when we have !CONFIG_HIGHMEM and when the
architecture does not have clear_user_highpage.

The first is necessary because not doing intermediate maps for
pages lets contiguous page ranges stay contiguous. The second,
because if the architecture has clear_user_highpage(), it likely
needs flushing magic when clearing the page, magic that we aren't
privy to.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
Note:
  - reorganized based on the previous two patches. 
  - Removed David's acked-by.

 include/linux/highmem.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 92aa1053c9c1..c6219700569f 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -278,11 +278,28 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
 					unsigned int npages)
 {
+
+#if defined(clear_user_highpage) || defined(CONFIG_HIGHMEM)
+	/*
+	 * An architecture defined clear_user_highpage() implies special
+	 * handling is needed.
+	 *
+	 * So we use that or, the generic variant if CONFIG_HIGHMEM is
+	 * enabled.
+	 */
 	do {
 		clear_user_highpage(page, vaddr);
 		vaddr += PAGE_SIZE;
 		page++;
 	} while (--npages);
+#else
+
+	/*
+	 * Prefer clear_user_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_user_pages(page_address(page), vaddr, page, npages);
+#endif
 }
 
 #ifndef vma_alloc_zeroed_movable_folio
-- 
2.31.1



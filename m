Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42122CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B6A6B002D; Thu, 28 Aug 2025 08:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FED86B002F; Thu, 28 Aug 2025 08:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678646B0032; Thu, 28 Aug 2025 08:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5726B002D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:25:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC14C83279
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:25:00 +0000 (UTC)
X-FDA: 83826085560.03.5596A32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50C8E8000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:24:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F06Dm3K9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0ElFhMr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756383897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMW4wWXqX9vGxY4KbPVHKjMAIiRqkDOsPvSBTVB16Ec=;
	b=CwQe3h57Y9Vj6EG1auFV/jw7jMidQrBJccaZY7q1cqbhF7T93ePKPg4Mm+9CP/L4Z1P+2+
	NtSfX/e0k31nF1asV734yxfHdByxR7bzA4arO7zJhVehQjIl34PWr2SWZ2b6LjhuPEJNl+
	H2RCuT1BU+28nZ2cdR1rYYGVlr/eQJg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F06Dm3K9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0ElFhMr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756383897; a=rsa-sha256;
	cv=pass;
	b=ypJWCBEIoig2f/5aPJ/uRF4vTupH+9XNCZzDUKjbjs5pZv60/DRaoqf5FjhISPp1jP7Lc5
	b6Kmfr2yuEYVQPomKyuu5cXtKvlwdukvfnPZI/Dbo6mg0q2vFPGnnw4g9SH0f6Gp3Zo3iQ
	U36VVkx0g+y7Y4VL4WmL/aIw083W/ds=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8tw4v013401;
	Thu, 28 Aug 2025 12:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DMW4wWXqX9vGxY4KbP
	VHKjMAIiRqkDOsPvSBTVB16Ec=; b=F06Dm3K9XZ8B+H9zy9czNd+LEMcc5ZcQYZ
	0TDa64LmT3P6AjZssk4sQNyavxtKvtvLn74AhnXaxHOERMcRG5C22yy7bpAU7inF
	r57TVTqv8yPx54OLDenYUTLOzQGRTve8LQFiWNLZPZTOUYgRU6n2krpTt3T5WRSC
	7d8O3vl5dfrn1BrtQzrWZi7YoWKJGgYkQedwd+Gm7/I8Slt8H7EMT1rCgmTUapLM
	swq4epwO3vEI6sJjxIr03pUXbmRvuiVHtYFb5+HVerW6VRBiyKcLuItEmJVTILSS
	OtcfwtYwI+I9u5ufHvoVDZXkSkAFu3vVWKQTm2hOVWrcQvxh2+CQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jard7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:24:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SBqQ2D018955;
	Thu, 28 Aug 2025 12:24:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bwtwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:24:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x6P3W3vBXtIXX+HQmRP/pczNR7vPlfi3OkHeNi5SOfXeoY/Htt7mzCh3PINUbPaYfLhWiBB+VRLQkNLu8kJztdRMIXXdOn5XQmxghhH30UKP/j84+Kjwwgx2OMibBe45OgHjs0jMhTIeTILGc4ZBP368vo4+NUrakQFQMcbAMkb0+kC2JCkg88yEurUhlyza3vHiZAvuek33SXwj6BRDkTFPcojK4eCDU1B0LtsByFMoPbc9bdzssLDICoYy/96+HeOMTRDtx2WeO04kRh2jYE1dCQRRpxSOUSFe/L8FogkioDotaHVzN4/VZ5pJgDRnJp8XYRNjl2j17lp1kHJn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMW4wWXqX9vGxY4KbPVHKjMAIiRqkDOsPvSBTVB16Ec=;
 b=zM7D8/QblOoRRJP1QKZYSsc4u4IPh392JpapmoPSuFCn17nf4v0Voqn374sH6/99lGmrkPZELToLkJJ1eUo7BRy58WIxpcAVpu3MXhREFKgHpQzEk+OUILaBg1d+pmEPbY0Lut3M/PTlTHnkzy8Yn2G/1/kRtps7+yDlOT6lPvnooLZHCSNaSElct1KRWv5SbXzTN/rqZce7CN6w2Lh2qA4pjQtry0+6n6/CKsiMWgPsM9ADyHwjt8ZB0moYxVrGiStHEuSSiV/kxCK6uZGVJ+4J9uiASDZOpXyr5SoCMXWagnpzoV3/f+TuxMUx2W+MpvwwFkQQItcvdoZGp0SHaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMW4wWXqX9vGxY4KbPVHKjMAIiRqkDOsPvSBTVB16Ec=;
 b=h0ElFhMrUdoxY6MnO/v4pBGup9RqkPmBFuAokQ9UGhgp4bxGdZUfErDhE7bHBGiOLPHrBNqXtVmImENibtJvb/JU0M5MZujIK/UXkArKa0PXR+U4xVXs0a3+EI+UooLA6x4C3i7L/5nyG1Ye6NBNILwOIQ8stYvly4Mx6THJV3Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.24; Thu, 28 Aug
 2025 12:24:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 12:24:40 +0000
Date: Thu, 28 Aug 2025 13:24:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-ID: <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827192233.447920-1-max.kellermann@ionos.com>
X-ClientProxiedBy: GV3P280CA0066.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 44898a87-fe9e-44df-e4ce-08dde62ddc8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dU/Paoiq/HtmSOQZKjV5rmYpU/78WTIwqUjznxiv4v88kKCJME1UCSelEbCR?=
 =?us-ascii?Q?xJsIViUFmtXYjHjjr8Smo+6uF+a4huNsMKpdlSbNYUP43LsFm/7Sg5jn+WQC?=
 =?us-ascii?Q?K6xBX2GFkQJeHuXCS+VnoXomOFLphoGLKl+RkNjW8BaSeVNhpkl4eE8CdR5e?=
 =?us-ascii?Q?l94cKhxVdo6gakFSzIuTzUQ1ytdyYVATleOCi/7qgqroPNXrYUOmY58GVGw7?=
 =?us-ascii?Q?C0ql2544VL1Er/LdhZMMot7bomElMWcuGeWQ/xczN4//o/+ReDjMMUIXIcnd?=
 =?us-ascii?Q?ZP6+o2wJVPLp5+Fecugi2P7UNfxx89w2VIZDz71BMnL/ChiG4hTLzbr1WzXY?=
 =?us-ascii?Q?fdUU8wNFyOWM5fSoShPuOSSCbpIeUafjhCPcNRl/Z9Z5mljjfX7fGa8o3E8U?=
 =?us-ascii?Q?pXt4XnsO/gL39V7pul7JMRBJLdV+BMDMfly9K3ynawSWZwDP88/08r3dSb6C?=
 =?us-ascii?Q?O5etP4aLb2fpjthhZFg/s5YReIwJMBeudgGbFRq34RLr69HITP9m1ulPxxrB?=
 =?us-ascii?Q?PLDp5EcW9T85nMvF+25ztrRHbleS8tWhlpO5bEWdWC1txQM++ekr+/QVxRIw?=
 =?us-ascii?Q?KqvPFzUeEYgSnhoLo1tbKFTMC0zHOiCNCC5OeX1cW+ao03dDnSySmIcsGciM?=
 =?us-ascii?Q?v4FQVeG0L6XMTgktKyxRf8MifBh+dYSoGgeyMFn5TkBr6uCHsypHvuYYyFHv?=
 =?us-ascii?Q?V5znqaG3HODKWDniXaRacBfsZ3NUp74Jdx329UW/bQM3qrWFis52vefhbEJt?=
 =?us-ascii?Q?vyRu1J6WPSUCUslIqPbeydpcs2u3PqrCIK7o4na/nmM3sprZIfaYwZl5fa/V?=
 =?us-ascii?Q?iDM8Vpl/L+BCKA3sBCTTHZa9lpCNsLAkGb0Q0ynvKDTuxQbAunr2hp516Rtv?=
 =?us-ascii?Q?AHdmbpkH7hS0kJNxBkdYqhWWeg3XfdzKiKsHgGESFIOeTlF96h5sPfVTKZAP?=
 =?us-ascii?Q?CyYKaMOo7eKWIJfEfhK4hBkK4wki9JAtb8VisTgyUIVniLgOFSdzvaLcLKAm?=
 =?us-ascii?Q?cgSpXs2aGl57xW5nlemBPuHIBjw44jqxiScXmLIso0vxjZH2L2ieWBnTzDvr?=
 =?us-ascii?Q?f2VubXGR2YiHcv5SbMtcPfHuvphrLXW6bX74BOWuKwZFw8FrGqTV6VKcLrjk?=
 =?us-ascii?Q?IJbmvndaiYGqr6W960j2cqgfsQ1XJshMG7g7Gstvf+OAOE8E8xDoA/vc9pMh?=
 =?us-ascii?Q?WOqB5JHI+K2+cOsr1ifN8Iwff8OoWTjzyl3AarQ2GmJRh55zVOQoFMsvseKm?=
 =?us-ascii?Q?OQbbCEJP3yu1Aw70sno3bPUfS1VtLkb2O9xqblHIALfAMN4CCiLd7W2/RPBd?=
 =?us-ascii?Q?62TY7cN68bJFAuDPSMUwj1VL/VzJCwPeaQ+yP7ocNsjC3lwL34P5p08ENQfi?=
 =?us-ascii?Q?w2FQX1KT+CLkg0hqIKdaMrvZphLKyYqQcXq3m94FW0aX/89i+w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eGl1OPlnTWyS86QJ5lG7cRSqsLsg7tdKXwFzdXCfP46qFi9C6pefGlNErPq7?=
 =?us-ascii?Q?0/7nKexu0VTHBBXkchjH0JKL27IWgkW+mjClpcyl8Ji4usHIQ0dWWAMxhRMC?=
 =?us-ascii?Q?jBOUThkAwBI+yKJFa1y8QKtWMcjNir54+99GpM7BmxPUlCCEaNsUdN5L3Cg3?=
 =?us-ascii?Q?r4+t3ZrbLMP4oswKNT0TaZHGTtTqLwtlfx0drqu8ow62FOQziWw9ue526jrl?=
 =?us-ascii?Q?ydymHggjWqPj5FUtAY+Jb7rxUZ3OW+LxWXFDCgcGc1j8IcuQc5ruf3Y5reDB?=
 =?us-ascii?Q?+V4xMARnQFz0t/gsEpIIHsNrpJnJYzDAR5P8HYLxgGn4CX+Gexzrf81u1Ygb?=
 =?us-ascii?Q?yoMTfffysGXp8n5LZLJRp2IznKL3jPcwdrYjtDKdHtYi4HrIRRTerU340BAx?=
 =?us-ascii?Q?WysTTrjzfSTxEsYfiwGsGNyZgBrHCQ1kswgkDCJf+tTI4QFlgk2IhJznpTd4?=
 =?us-ascii?Q?ybkQHe4v20VoV9/qtrqw4l1wmqbTxroMcgh5AZWFR/rpstvToC4f6lLKHGNP?=
 =?us-ascii?Q?PcRNfk7+/o/ViOFdyBAJfntKZX1LWvedALwqNm81jHsfwYJeQsVoIc9mZDvj?=
 =?us-ascii?Q?YtQOKb8NCw7NAKJjiAF9cG8Pv/0k14WXzR4iaqKS/HXIoqb/hOMMjpi2iIfL?=
 =?us-ascii?Q?nUW2Jyjo1dadF1mlMXxxuPvwDNXTror9clgpY75psbT+/vG+uEzOc33Yzgnr?=
 =?us-ascii?Q?AKhU+rmdRjmtOHC5YF3FFlgTjiwnBYnFiGcM4rUsz1AxnuNO8HBwNWhmal+0?=
 =?us-ascii?Q?rGhv/GfPXrUb4L3zDl5KbVkYzNSJxV2VOW3xd5bmVE8aVvc7Fz1oOoDUx/7p?=
 =?us-ascii?Q?ANgAZI3guvTuitJj5n+YY4atwlwJpLWwlqmq/cDwTCGkDOqT+oxe+SX2+g3y?=
 =?us-ascii?Q?8iOs0GtWCPdr4L2iTFixyjPeQ1riLyXo0zUQJg3lcFkHnpF/04CToKSXeBBY?=
 =?us-ascii?Q?hhLFg4hCmpUs+0yc9g4Y/qLFiE3zHzdaRH/QK4apYkut/QVzE6RrokJjd9MI?=
 =?us-ascii?Q?uUxGACClEyjNX6jgb+1Qutks5/YphvQ58FWWecuc5OP8xSNEF4PIIvipmrnQ?=
 =?us-ascii?Q?PHvpftra/PUpMjBO4c8eEP/L4B1qmIhZ1Ut5oyVDdXq+8x6fwUdML5z839Ec?=
 =?us-ascii?Q?HFvpHdfbJWLkeqoYqJY2CNA5iGLsan/fr8V3bWN8admsKwAobL9nUJz1D4Wq?=
 =?us-ascii?Q?ye6XEab/xzvLEiVPXzuYb4cz8MIZwyIjb86+hmPRdrsJJzj3mZFDWewkliE9?=
 =?us-ascii?Q?oZ1T0fIgT4+Ep+yq+aCwMOzaIVHK0DkdamLEMYweJAhZ2l8S+5kIAS0GJv/P?=
 =?us-ascii?Q?BYTU+MSnrTE2Sx5OOsjNKmHc2R5FMLp264CqBpJ2Bk6gP3E/+svcWJCUNkCE?=
 =?us-ascii?Q?9xqMLR6Uf2DCx1aTJxTlwMgBNXw0y6dPUk75CCdpX4uARWhUjHjJKtK+E4kR?=
 =?us-ascii?Q?koyiMFcO0WgRSQvGAIg48B5aZl6q7Nl0vy2SNp9DGjceRnj5b+crUuGNsvWg?=
 =?us-ascii?Q?b19i/ReA3QGet/v2KiwYFPQXjYQgW8oDnD3FoncN05wJC3YDza0SHKCq4Igc?=
 =?us-ascii?Q?Rx3vmRp434uIRffs01ZswndXYpKo2cloELJfeHVXBOOkAhG3FISXAhhosxMb?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vER6gADS7tn34MFA+JdK28Ie6Ln0AQV/hy9NQOD130ptKJnCRTgf6+bNxTc0C8lxw5YHKlAvwrZICQYlwvT1TPvftpbVJXquF7SPRnMgxoi5kSo2+HQ86V1uv5qc7CSkRG74idt1aklwaJq8zLszZGZJ0SH2wduLOwmCz+1RPFk6JT3qmr6tfIbi1zVw6KkhxP4j2hzVq4Sb5kxwHtVhPxC9s3YLJ43a4wc7KGKkWU5JwPHy8kYgCNp2Ojh9vD8fc/HfrMcNAZNVaxZvLHMQtRjKOgo13wwNp76dQFH0cezAzk+wb2qLvxEN57IXOsOuk+GFGdgQOQa0qICwfL6vOoks2HXbKYb6bHEArk8TDJBOWeIzD5WcCbhqrFi3MQjWyVFhf8r+Lg4kWVNMqBglSwSl/CUPrkW7KPtxsaLRvycCCCmlUjeXsSzPgTxApUYLJO2Hq9FAffTr5y/TsCUokNXQU6Egt6Hl8zaDHGuM6DwCspC8/4bRrzvZxo2Bf6Aef3ZTfso4gkQGDzAsfDWBpL2fovXky9JoBOQ7eMElLiwIWlAa+9gaaD3W/70GhaNm0q20+2Vf2AcToPxTUNzSZWkaRz4GmdH/XZRKAzi2kkw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44898a87-fe9e-44df-e4ce-08dde62ddc8c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:24:40.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKjhw/QuPwWJppRqqqbgH4V9h89B3Nhi4dow7wRAdy07yvPulicNm8Uhw/B7ZpKbyFXFCcpxiQwTbnlBd18sLR9jHQFqFOjGtHn2bFnm/O0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX31KU0xEA4ZnR
 RbN+rDlgSZ+FuAhQT3yK7blK+40vpWZyzJx/WNuE/yYhZy0zkhYYS+2YpvMwImM32rR2I+lgrY7
 WaRkW7deHa7nFQNL1qJiQKExVosQssS35jwCvNGsZfiKpQHzvale3ez/bwz69Heh4fcid8qnMZy
 llQKBz1+KqYx2yxbTbx01TH383KBvGK72m9xff71fJp1wYx+77GgBQfXhamxuX+BD47jZzFCDIY
 i7KsOidt4zc/ru0K8Rmaq+qIJfwNup2Bem1PEny6MjOKPEjE0TXYoOjI5IzCYDaFs1DsnxvktX2
 d2c/XKkljFjimBkoUxyh+AN2F4FpDyGQ03h+qWr/xy5B26E1p1qGg3AASkGy5s/kZFFKxl620RQ
 24u1Cq3s
X-Proofpoint-GUID: Jyx-lIDXdj7D-ck_gPUwemPCAPWGbN2A
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b04a90 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8
 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=iox4zFpeAAAA:8 a=JfrnYn6hAAAA:8 a=SRrdq9N9AAAA:8 a=37rDS-QxAAAA:8
 a=UgJECxHJAAAA:8 a=S4sxpzsK_Xx2zBpkClwA:9 a=CjuIK1q_8ugA:10
 a=RMMjzBEyIzXRtoq5n5K6:22 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=k1Nq6YrhK2t884LQW06G:22 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-ORIG-GUID: Jyx-lIDXdj7D-ck_gPUwemPCAPWGbN2A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50C8E8000E
X-Stat-Signature: zahq1grnyxg93xg346ugbbi9t8z846ob
X-Rspam-User: 
X-HE-Tag: 1756383897-413547
X-HE-Meta: U2FsdGVkX187swoudkeJGtjLwMJJittjCplr1VKcG1aQNg8teDiofEvWqUXr+4nG3ZnUqFojU/AkjjiSNNq1oVZ3wmU4YMznZuj7cgAWSbFcnb7X78ehJOz2eoy5tEf2j78pjKYEsyg7xUeUIPMq4wmauwVVej4jVNmRPZBPzi941blib2qrwFiqJFC2pXCfyG1j0BrKlQJlBpN37281hzJjC4V6GBj8/Wytg8ecJp0DnmyY3CIMtoHdqrsWQTP11lFBT0YdulLb86NK7pCojm8QIvVgl5hPbCvDzlDVtyR3yQCE9WPuyS8hn5JOkpYaSEPkT9gvk36V6CJO7mZH6Os62PGTlfAceckOlJSqODX4yQnY6rppFSOJ6ZXietcsz7SHwOTInzPW7YUY79xZvc0gYZ25gJEYtymxK3kulahhaBBcIFEkAnCwGsFTyFfnAR9nNcU4foqoRwIsMvsf4NdqkElEfmx+S91MAQJuLXN5+lvo67mAqhpPIrF9DrKXSy2mWNDnjbpU4em6avP1YKYAXRBytByoA4Se5PjAYIGtzGTHVzQgS1gaYKRxIgtSVTApX6QE6b58ZXCcCqtX6OKWeHTZfqB6uXEGVvyzkqFiKkncEg+9TR3huC3pWm5pz0SPtyPqcBTbykezElc0CfVRVqsch7HcuBZVwgWT/U7UIeKNPInrs8tEA1EgMdEZAIZUfpwmQlGIq1sdEa4kX1QzdJcTFcDA4R1ybTvvvZp7fRbVR8rBUlqOdeOFIAX58H5WDA2N39oaHQEa635+UeKDfhgbLBoZNGMPchPMhLaG8aXa990Ixj+oyz3fqsG5+7prflW6sdhb7mJNyBuzDf2EKHARe2QJl8rwAuGGLen42BusNKVyFJHU0Rf7af3UpkRN9NkH5Wsu9pxOY1mrE56crWRz0lMV4vYTJdYk6vNEV6RzStODcRSonPkY7of/zqjjwYOFzdLiPbbwra4
 HXGn89z+
 QE3KnogWaTY7XpQglQAXQ6WmFAllDDYwm1miqnJmT3CinDPdgI6gYwA2C04e7pru6udaCoJxnwuvGoyyrkI7Mt6hNhhjn8K+aBBtbvppFbBtq4ksMwcD2XLFgYKzNI9Y0YKehPFB9WH15ZXFJMTjdvyAezFxVYecCvnzKM2yIAFFBo6truRXZs5n40VsY8gAr1ofERstrE8bbUSFQx7OtavaL1vOKLwCBfNHyfqJeA7oqu+K6qEvDLF4xMmjSs/3/Fb1YAuxXNIhBEVlIYisYt7EiwFUs7/NpjQNFZuhsNWS2MI/AmMWe1sVnjAzfcyFp6mth1M1EvXv66VxLkAcnWuoJzA12KZfvi3rEuoegQZC8LdoSNIaQ0HpoNO5i3p+WutG+z12zAJVz8j8c4XS0/ktYJHJQ3FQ9BE7loCPecBPHoinEz4/inLCO8H2tsHhpiF/QiHmx1sDEs2E0fQjiK+k1/88EVVNsEPq3pogUapyVK7h2ib/2PyqMsA2ni8bBuG8mcvNN1Nu5WUMvMrARaU+dwAIhcqH0sqHEUEXQNGBAr6bSD5Evm7CN2jmZh9n80wPj3FlJxQ5nNL7Om0gmF8i5CoAr3tEJvi3lIC22KYmHtxwlualr30zPzfoCFpf96anMxmZFUlFWyeDr+ybV2PfktsaSWFLM0BJaOZ+bRdB+p+w/aJSh48InhOp+zbNfDFV8+/CimjshMrefh8ahmA/317mK3X/LYZE//8qPv+8XRJufx9e+ESHk8jhnN5os8XTUbDCC+EmTgw4dVuwl432Cj5QOE1TxmJXZM1WDRy6DPal2VF54O+4FYz/WSIlX4HvbQ4HyOYlEOht+vZC3YQcC46v+JAiqFH0l8mEdtd8hTVC/NSgaBPUl3NoPyggo0u11RDzo564++45f+quX5gRuIXYFnjWeFDA5l5vusN2Rsd5fFJwzXEtgCo7ejcCfSG7I90QX/P2ZO5T1opIPWTgV74l0
 hkJgj7Hd
 6WGKeC4Gyfwbm9UvFJS/JpHaQAHEqqOtJGJHyrkkMPkuJP7ArY+vpTBxhXFU9qD2kwt4PYneM3KWN8lrSAEf0/NYboanz6xyj1OkHgNN2Bgm9f0au3Fo1HMb55laZbY9Huos05vdFkJn3q8aLoFFTE6FAwtYkb8Ax8l5/svsGiD9Ykmy1K6cP96XSnfZz4eElGZGXrhfj68=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You've not cc'd the right people here.

Please run scripts/get_maintainers.pl on your patch series and cc all
maintainers and reviewers on every series please, as well as all of the mailing
lists referenced.

For this change you needed to CC:

Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS and infrastructure))
Christian Brauner <brauner@kernel.org> (maintainer:FILESYSTEMS (VFS and infrastructure))
Jan Kara <jack@suse.cz> (reviewer:FILESYSTEMS (VFS and infrastructure))
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE,commit_signer:1/1=100%)
David Hildenbrand <david@redhat.com> (maintainer:MEMORY MANAGEMENT - CORE)
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
"Liam R. Howlett" <Liam.Howlett@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
Vlastimil Babka <vbabka@suse.cz> (reviewer:MEMORY MANAGEMENT - CORE)
Mike Rapoport <rppt@kernel.org> (reviewer:MEMORY MANAGEMENT - CORE)
Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - CORE)
Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - CORE)
Axel Rasmussen <axelrasmussen@google.com> (maintainer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Yuanchu Xie <yuanchu@google.com> (maintainer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Wei Xu <weixugc@google.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
"Matthew Wilcox (Oracle)" <willy@infradead.org> (maintainer:PAGE CACHE)
Hugh Dickins <hughd@google.com> (maintainer:TMPFS (SHMEM FILESYSTEM))
Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:TMPFS (SHMEM FILESYSTEM))
David Rientjes <rientjes@google.com> (reviewer:MEMORY MANAGEMENT - OOM KILLER)
Shakeel Butt <shakeel.butt@linux.dev> (reviewer:MEMORY MANAGEMENT - OOM KILLER)
linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure))
linux-kernel@vger.kernel.org (open list)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)

Usually I'd cc for you here but that's too many :)

On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
> For improved const-correctness.

'const-correctness' in C is extremely weak.

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

It feels like this is a bit of an arbitrary subset and this churn is going
to make merge conflicts much more likely.

I mean, if it's just that all this functions accept non-const VMA and for
all callers _from_ these functions most accept const - it's not really
accomplishing much other than adding a bunch of noise.

Any meaningful change would require pretty huge amounts of change that
would be horrendous git blame, merge conflict, etc. wise for really not a
huge amount of benefit.

I feel like the ship has sailed for this and I really question the value of
doing this in this way.

> ---
>  include/linux/fs.h        |  6 ++---
>  include/linux/mm.h        | 42 +++++++++++++++----------------
>  include/linux/mm_inline.h | 24 +++++++++---------
>  include/linux/mm_types.h  |  4 +--
>  include/linux/mmzone.h    | 42 +++++++++++++++----------------
>  include/linux/pagemap.h   | 52 +++++++++++++++++++--------------------
>  include/linux/pagevec.h   |  4 +--
>  include/linux/shmem_fs.h  |  4 +--
>  mm/oom_kill.c             |  2 +-
>  mm/shmem.c                |  6 ++---
>  mm/util.c                 |  2 +-
>  11 files changed, 94 insertions(+), 94 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d7ab4f96d705..0783c5d05d3f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -537,7 +537,7 @@ struct address_space {
>  /*
>   * Returns true if any of the pages in the mapping are marked with the tag.
>   */
> -static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
> +static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
>  {
>  	return xa_marked(&mapping->i_pages, tag);
>  }
> @@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
>  /*
>   * Might pages of this file be mapped into userspace?
>   */
> -static inline int mapping_mapped(struct address_space *mapping)
> +static inline int mapping_mapped(const struct address_space *mapping)
>  {
>  	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
>  }
> @@ -599,7 +599,7 @@ static inline int mapping_mapped(struct address_space *mapping)
>   * If i_mmap_writable is negative, no new writable mappings are allowed. You
>   * can only deny writable mappings, if none exists right now.
>   */
> -static inline int mapping_writably_mapped(struct address_space *mapping)
> +static inline int mapping_writably_mapped(const struct address_space *mapping)
>  {
>  	return atomic_read(&mapping->i_mmap_writable) > 0;
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..ad478a4afa6c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -697,7 +697,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
>  	mmap_read_unlock(vmf->vma->vm_mm);
>  }
>
> -static inline void assert_fault_locked(struct vm_fault *vmf)
> +static inline void assert_fault_locked(const struct vm_fault *vmf)
>  {
>  	mmap_assert_locked(vmf->vma->vm_mm);
>  }
> @@ -810,7 +810,7 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
>  		vma->vm_end >= vma->vm_mm->start_stack;
>  }
>
> -static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
> +static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
>  {
>  	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
>
> @@ -824,7 +824,7 @@ static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
>  	return false;
>  }
>
> -static inline bool vma_is_foreign(struct vm_area_struct *vma)
> +static inline bool vma_is_foreign(const struct vm_area_struct *vma)
>  {
>  	if (!current->mm)
>  		return true;
> @@ -835,7 +835,7 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
>  	return false;
>  }
>
> -static inline bool vma_is_accessible(struct vm_area_struct *vma)
> +static inline bool vma_is_accessible(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_flags & VM_ACCESS_FLAGS;
>  }
> @@ -846,7 +846,7 @@ static inline bool is_shared_maywrite(vm_flags_t vm_flags)
>  		(VM_SHARED | VM_MAYWRITE);
>  }
>
> -static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
> +static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>  {
>  	return is_shared_maywrite(vma->vm_flags);
>  }
> @@ -930,14 +930,14 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
>   * The vma_is_shmem is not inline because it is used only by slow
>   * paths in userfault.
>   */
> -bool vma_is_shmem(struct vm_area_struct *vma);
> -bool vma_is_anon_shmem(struct vm_area_struct *vma);
> +bool vma_is_shmem(const struct vm_area_struct *vma);
> +bool vma_is_anon_shmem(const struct vm_area_struct *vma);
>  #else
> -static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
> -static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
> +static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
> +static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
>  #endif
>
> -int vma_is_stack_for_current(struct vm_area_struct *vma);
> +int vma_is_stack_for_current(const struct vm_area_struct *vma);
>
>  /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
>  #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
> @@ -3432,7 +3432,7 @@ struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
>  	return mtree_load(&mm->mm_mt, addr);
>  }
>
> -static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
> +static inline unsigned long stack_guard_start_gap(const struct vm_area_struct *vma)
>  {
>  	if (vma->vm_flags & VM_GROWSDOWN)
>  		return stack_guard_gap;
> @@ -3444,7 +3444,7 @@ static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
>  	return 0;
>  }
>
> -static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
> +static inline unsigned long vm_start_gap(const struct vm_area_struct *vma)
>  {
>  	unsigned long gap = stack_guard_start_gap(vma);
>  	unsigned long vm_start = vma->vm_start;
> @@ -3455,7 +3455,7 @@ static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
>  	return vm_start;
>  }
>
> -static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
> +static inline unsigned long vm_end_gap(const struct vm_area_struct *vma)
>  {
>  	unsigned long vm_end = vma->vm_end;
>
> @@ -3467,7 +3467,7 @@ static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
>  	return vm_end;
>  }
>
> -static inline unsigned long vma_pages(struct vm_area_struct *vma)
> +static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  {
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
> @@ -3484,7 +3484,7 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
>  	return vma;
>  }
>
> -static inline bool range_in_vma(struct vm_area_struct *vma,
> +static inline bool range_in_vma(const struct vm_area_struct *vma,
>  				unsigned long start, unsigned long end)
>  {
>  	return (vma && vma->vm_start <= start && end <= vma->vm_end);
> @@ -3600,7 +3600,7 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
>   * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
>   * a (NUMA hinting) fault is required.
>   */
> -static inline bool gup_can_follow_protnone(struct vm_area_struct *vma,
> +static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
>  					   unsigned int flags)
>  {
>  	/*
> @@ -3730,7 +3730,7 @@ static inline bool debug_guardpage_enabled(void)
>  	return static_branch_unlikely(&_debug_guardpage_enabled);
>  }
>
> -static inline bool page_is_guard(struct page *page)
> +static inline bool page_is_guard(const struct page *page)
>  {
>  	if (!debug_guardpage_enabled())
>  		return false;
> @@ -3761,7 +3761,7 @@ static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
>  static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
>  static inline unsigned int debug_guardpage_minorder(void) { return 0; }
>  static inline bool debug_guardpage_enabled(void) { return false; }
> -static inline bool page_is_guard(struct page *page) { return false; }
> +static inline bool page_is_guard(const struct page *page) { return false; }
>  static inline bool set_page_guard(struct zone *zone, struct page *page,
>  			unsigned int order) { return false; }
>  static inline void clear_page_guard(struct zone *zone, struct page *page,
> @@ -3784,7 +3784,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
>  }
>  #endif	/* __HAVE_ARCH_GATE_AREA */
>
> -extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
> +extern bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm);
>
>  void drop_slab(void);
>
> @@ -3843,7 +3843,7 @@ void vmemmap_free(unsigned long start, unsigned long end,
>  #endif
>
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
> +static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
>  {
>  	/* number of pfns from base where pfn_to_page() is valid */
>  	if (altmap)
> @@ -3857,7 +3857,7 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
>  	altmap->alloc -= nr_pfns;
>  }
>  #else
> -static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
> +static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..c91fa1de51fd 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -25,7 +25,7 @@
>   * 0 if @folio is a normal anonymous folio, a tmpfs folio or otherwise
>   * ram or swap backed folio.
>   */
> -static inline int folio_is_file_lru(struct folio *folio)
> +static inline int folio_is_file_lru(const struct folio *folio)
>  {
>  	return !folio_test_swapbacked(folio);
>  }
> @@ -84,7 +84,7 @@ static __always_inline void __folio_clear_lru_flags(struct folio *folio)
>   * Return: The LRU list a folio should be on, as an index
>   * into the array of LRU lists.
>   */
> -static __always_inline enum lru_list folio_lru_list(struct folio *folio)
> +static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
>  {
>  	enum lru_list lru;
>
> @@ -141,7 +141,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>  	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>  }
>
> -static inline int folio_lru_refs(struct folio *folio)
> +static inline int folio_lru_refs(const struct folio *folio)
>  {
>  	unsigned long flags = READ_ONCE(folio->flags);
>
> @@ -154,14 +154,14 @@ static inline int folio_lru_refs(struct folio *folio)
>  	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>  }
>
> -static inline int folio_lru_gen(struct folio *folio)
> +static inline int folio_lru_gen(const struct folio *folio)
>  {
>  	unsigned long flags = READ_ONCE(folio->flags);
>
>  	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>  }
>
> -static inline bool lru_gen_is_active(struct lruvec *lruvec, int gen)
> +static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
>  {
>  	unsigned long max_seq = lruvec->lrugen.max_seq;
>
> @@ -217,12 +217,12 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
>  	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
>  }
>
> -static inline unsigned long lru_gen_folio_seq(struct lruvec *lruvec, struct folio *folio,
> +static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec, const struct folio *folio,
>  					      bool reclaiming)
>  {
>  	int gen;
>  	int type = folio_is_file_lru(folio);
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>
>  	/*
>  	 * +-----------------------------------+-----------------------------------+
> @@ -302,7 +302,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return true;
>  }
>
> -static inline void folio_migrate_refs(struct folio *new, struct folio *old)
> +static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
>  	unsigned long refs = READ_ONCE(old->flags) & LRU_REFS_MASK;
>
> @@ -330,7 +330,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return false;
>  }
>
> -static inline void folio_migrate_refs(struct folio *new, struct folio *old)
> +static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
>
>  }
> @@ -508,7 +508,7 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
>  	atomic_dec(&mm->tlb_flush_pending);
>  }
>
> -static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
> +static inline bool mm_tlb_flush_pending(const struct mm_struct *mm)
>  {
>  	/*
>  	 * Must be called after having acquired the PTL; orders against that
> @@ -521,7 +521,7 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
>  	return atomic_read(&mm->tlb_flush_pending);
>  }
>
> -static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
> +static inline bool mm_tlb_flush_nested(const struct mm_struct *mm)
>  {
>  	/*
>  	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
> @@ -605,7 +605,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>  	return false;
>  }
>
> -static inline bool vma_has_recency(struct vm_area_struct *vma)
> +static inline bool vma_has_recency(const struct vm_area_struct *vma)
>  {
>  	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
>  		return false;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 08bc2442db93..56766e498ee1 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -627,7 +627,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
>  	atomic_dec(&ptdesc->pt_share_count);
>  }
>
> -static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
> +static inline int ptdesc_pmd_pts_count(const struct ptdesc *ptdesc)
>  {
>  	return atomic_read(&ptdesc->pt_share_count);
>  }
> @@ -655,7 +655,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
>  	page->private = private;
>  }
>
> -static inline void *folio_get_private(struct folio *folio)
> +static inline void *folio_get_private(const struct folio *folio)
>  {
>  	return folio->private;
>  }
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0c5da9141983..cef949d6ba82 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1089,7 +1089,7 @@ static inline unsigned long promo_wmark_pages(const struct zone *z)
>  	return wmark_pages(z, WMARK_PROMO);
>  }
>
> -static inline unsigned long zone_managed_pages(struct zone *zone)
> +static inline unsigned long zone_managed_pages(const struct zone *zone)
>  {
>  	return (unsigned long)atomic_long_read(&zone->managed_pages);
>  }
> @@ -1113,12 +1113,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
>  	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>  }
>
> -static inline bool zone_is_initialized(struct zone *zone)
> +static inline bool zone_is_initialized(const struct zone *zone)
>  {
>  	return zone->initialized;
>  }
>
> -static inline bool zone_is_empty(struct zone *zone)
> +static inline bool zone_is_empty(const struct zone *zone)
>  {
>  	return zone->spanned_pages == 0;
>  }
> @@ -1248,7 +1248,7 @@ static inline bool folio_is_zone_movable(const struct folio *folio)
>   * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
>   * intersection with the given zone
>   */
> -static inline bool zone_intersects(struct zone *zone,
> +static inline bool zone_intersects(const struct zone *zone,
>  		unsigned long start_pfn, unsigned long nr_pages)
>  {
>  	if (zone_is_empty(zone))
> @@ -1556,12 +1556,12 @@ static inline int local_memory_node(int node_id) { return node_id; };
>  #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
>
>  #ifdef CONFIG_ZONE_DEVICE
> -static inline bool zone_is_zone_device(struct zone *zone)
> +static inline bool zone_is_zone_device(const struct zone *zone)
>  {
>  	return zone_idx(zone) == ZONE_DEVICE;
>  }
>  #else
> -static inline bool zone_is_zone_device(struct zone *zone)
> +static inline bool zone_is_zone_device(const struct zone *zone)
>  {
>  	return false;
>  }
> @@ -1573,19 +1573,19 @@ static inline bool zone_is_zone_device(struct zone *zone)
>   * populated_zone(). If the whole zone is reserved then we can easily
>   * end up with populated_zone() && !managed_zone().
>   */
> -static inline bool managed_zone(struct zone *zone)
> +static inline bool managed_zone(const struct zone *zone)
>  {
>  	return zone_managed_pages(zone);
>  }
>
>  /* Returns true if a zone has memory */
> -static inline bool populated_zone(struct zone *zone)
> +static inline bool populated_zone(const struct zone *zone)
>  {
>  	return zone->present_pages;
>  }
>
>  #ifdef CONFIG_NUMA
> -static inline int zone_to_nid(struct zone *zone)
> +static inline int zone_to_nid(const struct zone *zone)
>  {
>  	return zone->node;
>  }
> @@ -1595,7 +1595,7 @@ static inline void zone_set_nid(struct zone *zone, int nid)
>  	zone->node = nid;
>  }
>  #else
> -static inline int zone_to_nid(struct zone *zone)
> +static inline int zone_to_nid(const struct zone *zone)
>  {
>  	return 0;
>  }
> @@ -1622,7 +1622,7 @@ static inline int is_highmem_idx(enum zone_type idx)
>   * @zone: pointer to struct zone variable
>   * Return: 1 for a highmem zone, 0 otherwise
>   */
> -static inline int is_highmem(struct zone *zone)
> +static inline int is_highmem(const struct zone *zone)
>  {
>  	return is_highmem_idx(zone_idx(zone));
>  }
> @@ -1688,12 +1688,12 @@ static inline struct zone *zonelist_zone(struct zoneref *zoneref)
>  	return zoneref->zone;
>  }
>
> -static inline int zonelist_zone_idx(struct zoneref *zoneref)
> +static inline int zonelist_zone_idx(const struct zoneref *zoneref)
>  {
>  	return zoneref->zone_idx;
>  }
>
> -static inline int zonelist_node_idx(struct zoneref *zoneref)
> +static inline int zonelist_node_idx(const struct zoneref *zoneref)
>  {
>  	return zone_to_nid(zoneref->zone);
>  }
> @@ -1996,7 +1996,7 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
>  	return (struct page *)map;
>  }
>
> -static inline int present_section(struct mem_section *section)
> +static inline int present_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
>  }
> @@ -2006,12 +2006,12 @@ static inline int present_section_nr(unsigned long nr)
>  	return present_section(__nr_to_section(nr));
>  }
>
> -static inline int valid_section(struct mem_section *section)
> +static inline int valid_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
>  }
>
> -static inline int early_section(struct mem_section *section)
> +static inline int early_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_IS_EARLY));
>  }
> @@ -2021,27 +2021,27 @@ static inline int valid_section_nr(unsigned long nr)
>  	return valid_section(__nr_to_section(nr));
>  }
>
> -static inline int online_section(struct mem_section *section)
> +static inline int online_section(const struct mem_section *section)
>  {
>  	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
>  }
>
>  #ifdef CONFIG_ZONE_DEVICE
> -static inline int online_device_section(struct mem_section *section)
> +static inline int online_device_section(const struct mem_section *section)
>  {
>  	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
>
>  	return section && ((section->section_mem_map & flags) == flags);
>  }
>  #else
> -static inline int online_device_section(struct mem_section *section)
> +static inline int online_device_section(const struct mem_section *section)
>  {
>  	return 0;
>  }
>  #endif
>
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
> -static inline int preinited_vmemmap_section(struct mem_section *section)
> +static inline int preinited_vmemmap_section(const struct mem_section *section)
>  {
>  	return (section &&
>  		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
> @@ -2051,7 +2051,7 @@ void sparse_vmemmap_init_nid_early(int nid);
>  void sparse_vmemmap_init_nid_late(int nid);
>
>  #else
> -static inline int preinited_vmemmap_section(struct mem_section *section)
> +static inline int preinited_vmemmap_section(const struct mem_section *section)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 12a12dae727d..37fa744ab124 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -140,7 +140,7 @@ static inline int inode_drain_writes(struct inode *inode)
>  	return filemap_write_and_wait(inode->i_mapping);
>  }
>
> -static inline bool mapping_empty(struct address_space *mapping)
> +static inline bool mapping_empty(const struct address_space *mapping)
>  {
>  	return xa_empty(&mapping->i_pages);
>  }
> @@ -166,7 +166,7 @@ static inline bool mapping_empty(struct address_space *mapping)
>   * refcount and the referenced bit, which will be elevated or set in
>   * the process of adding new cache pages to an inode.
>   */
> -static inline bool mapping_shrinkable(struct address_space *mapping)
> +static inline bool mapping_shrinkable(const struct address_space *mapping)
>  {
>  	void *head;
>
> @@ -265,7 +265,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
>  	clear_bit(AS_UNEVICTABLE, &mapping->flags);
>  }
>
> -static inline bool mapping_unevictable(struct address_space *mapping)
> +static inline bool mapping_unevictable(const struct address_space *mapping)
>  {
>  	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
>  }
> @@ -275,7 +275,7 @@ static inline void mapping_set_exiting(struct address_space *mapping)
>  	set_bit(AS_EXITING, &mapping->flags);
>  }
>
> -static inline int mapping_exiting(struct address_space *mapping)
> +static inline int mapping_exiting(const struct address_space *mapping)
>  {
>  	return test_bit(AS_EXITING, &mapping->flags);
>  }
> @@ -285,7 +285,7 @@ static inline void mapping_set_no_writeback_tags(struct address_space *mapping)
>  	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
>  }
>
> -static inline int mapping_use_writeback_tags(struct address_space *mapping)
> +static inline int mapping_use_writeback_tags(const struct address_space *mapping)
>  {
>  	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
>  }
> @@ -331,7 +331,7 @@ static inline void mapping_set_inaccessible(struct address_space *mapping)
>  	set_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
>
> -static inline bool mapping_inaccessible(struct address_space *mapping)
> +static inline bool mapping_inaccessible(const struct address_space *mapping)
>  {
>  	return test_bit(AS_INACCESSIBLE, &mapping->flags);
>  }
> @@ -341,18 +341,18 @@ static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_
>  	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>
> -static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
> +static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct address_space *mapping)
>  {
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>
> -static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
> +static inline gfp_t mapping_gfp_mask(const struct address_space * mapping)
>  {
>  	return mapping->gfp_mask;
>  }
>
>  /* Restricts the given gfp_mask to what the mapping allows. */
> -static inline gfp_t mapping_gfp_constraint(struct address_space *mapping,
> +static inline gfp_t mapping_gfp_constraint(const struct address_space *mapping,
>  		gfp_t gfp_mask)
>  {
>  	return mapping_gfp_mask(mapping) & gfp_mask;
> @@ -475,7 +475,7 @@ mapping_min_folio_order(const struct address_space *mapping)
>  }
>
>  static inline unsigned long
> -mapping_min_folio_nrpages(struct address_space *mapping)
> +mapping_min_folio_nrpages(const struct address_space *mapping)
>  {
>  	return 1UL << mapping_min_folio_order(mapping);
>  }
> @@ -489,7 +489,7 @@ mapping_min_folio_nrpages(struct address_space *mapping)
>   * new folio to the page cache and need to know what index to give it,
>   * call this function.
>   */
> -static inline pgoff_t mapping_align_index(struct address_space *mapping,
> +static inline pgoff_t mapping_align_index(const struct address_space *mapping,
>  					  pgoff_t index)
>  {
>  	return round_down(index, mapping_min_folio_nrpages(mapping));
> @@ -499,7 +499,7 @@ static inline pgoff_t mapping_align_index(struct address_space *mapping,
>   * Large folio support currently depends on THP.  These dependencies are
>   * being worked on but are not yet fixed.
>   */
> -static inline bool mapping_large_folio_support(struct address_space *mapping)
> +static inline bool mapping_large_folio_support(const struct address_space *mapping)
>  {
>  	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>  	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
> @@ -514,7 +514,7 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>  	return PAGE_SIZE << mapping_max_folio_order(mapping);
>  }
>
> -static inline int filemap_nr_thps(struct address_space *mapping)
> +static inline int filemap_nr_thps(const struct address_space *mapping)
>  {
>  #ifdef CONFIG_READ_ONLY_THP_FOR_FS
>  	return atomic_read(&mapping->nr_thps);
> @@ -928,7 +928,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
>   *
>   * Return: The index of the folio which follows this folio in the file.
>   */
> -static inline pgoff_t folio_next_index(struct folio *folio)
> +static inline pgoff_t folio_next_index(const struct folio *folio)
>  {
>  	return folio->index + folio_nr_pages(folio);
>  }
> @@ -957,7 +957,7 @@ static inline struct page *folio_file_page(struct folio *folio, pgoff_t index)
>   * e.g., shmem did not move this folio to the swap cache.
>   * Return: true or false.
>   */
> -static inline bool folio_contains(struct folio *folio, pgoff_t index)
> +static inline bool folio_contains(const struct folio *folio, pgoff_t index)
>  {
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
>  	return index - folio->index < folio_nr_pages(folio);
> @@ -1034,12 +1034,12 @@ static inline loff_t page_offset(struct page *page)
>  /*
>   * Get the offset in PAGE_SIZE (even for hugetlb folios).
>   */
> -static inline pgoff_t folio_pgoff(struct folio *folio)
> +static inline pgoff_t folio_pgoff(const struct folio *folio)
>  {
>  	return folio->index;
>  }
>
> -static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
> +static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
>  					unsigned long address)
>  {
>  	pgoff_t pgoff;
> @@ -1460,7 +1460,7 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
>   * readahead_pos - The byte offset into the file of this readahead request.
>   * @rac: The readahead request.
>   */
> -static inline loff_t readahead_pos(struct readahead_control *rac)
> +static inline loff_t readahead_pos(const struct readahead_control *rac)
>  {
>  	return (loff_t)rac->_index * PAGE_SIZE;
>  }
> @@ -1469,7 +1469,7 @@ static inline loff_t readahead_pos(struct readahead_control *rac)
>   * readahead_length - The number of bytes in this readahead request.
>   * @rac: The readahead request.
>   */
> -static inline size_t readahead_length(struct readahead_control *rac)
> +static inline size_t readahead_length(const struct readahead_control *rac)
>  {
>  	return rac->_nr_pages * PAGE_SIZE;
>  }
> @@ -1478,7 +1478,7 @@ static inline size_t readahead_length(struct readahead_control *rac)
>   * readahead_index - The index of the first page in this readahead request.
>   * @rac: The readahead request.
>   */
> -static inline pgoff_t readahead_index(struct readahead_control *rac)
> +static inline pgoff_t readahead_index(const struct readahead_control *rac)
>  {
>  	return rac->_index;
>  }
> @@ -1487,7 +1487,7 @@ static inline pgoff_t readahead_index(struct readahead_control *rac)
>   * readahead_count - The number of pages in this readahead request.
>   * @rac: The readahead request.
>   */
> -static inline unsigned int readahead_count(struct readahead_control *rac)
> +static inline unsigned int readahead_count(const struct readahead_control *rac)
>  {
>  	return rac->_nr_pages;
>  }
> @@ -1496,12 +1496,12 @@ static inline unsigned int readahead_count(struct readahead_control *rac)
>   * readahead_batch_length - The number of bytes in the current batch.
>   * @rac: The readahead request.
>   */
> -static inline size_t readahead_batch_length(struct readahead_control *rac)
> +static inline size_t readahead_batch_length(const struct readahead_control *rac)
>  {
>  	return rac->_batch_count * PAGE_SIZE;
>  }
>
> -static inline unsigned long dir_pages(struct inode *inode)
> +static inline unsigned long dir_pages(const struct inode *inode)
>  {
>  	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
>  			       PAGE_SHIFT;
> @@ -1515,8 +1515,8 @@ static inline unsigned long dir_pages(struct inode *inode)
>   * Return: the number of bytes in the folio up to EOF,
>   * or -EFAULT if the folio was truncated.
>   */
> -static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
> -					      struct inode *inode)
> +static inline ssize_t folio_mkwrite_check_truncate(const struct folio *folio,
> +					      const struct inode *inode)
>  {
>  	loff_t size = i_size_read(inode);
>  	pgoff_t index = size >> PAGE_SHIFT;
> @@ -1547,7 +1547,7 @@ static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
>   * Return: The number of filesystem blocks covered by this folio.
>   */
>  static inline
> -unsigned int i_blocks_per_folio(struct inode *inode, struct folio *folio)
> +unsigned int i_blocks_per_folio(const struct inode *inode, const struct folio *folio)
>  {
>  	return folio_size(folio) >> inode->i_blkbits;
>  }
> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
> index 5d3a0cccc6bf..63be5a451627 100644
> --- a/include/linux/pagevec.h
> +++ b/include/linux/pagevec.h
> @@ -51,12 +51,12 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
>  	fbatch->i = 0;
>  }
>
> -static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
> +static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>  {
>  	return fbatch->nr;
>  }
>
> -static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
> +static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
>  {
>  	return PAGEVEC_SIZE - fbatch->nr;
>  }
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 6d0f9c599ff7..0e47465ef0fd 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>  extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
>  #ifdef CONFIG_SHMEM
> -bool shmem_mapping(struct address_space *mapping);
> +bool shmem_mapping(const struct address_space *mapping);
>  #else
> -static inline bool shmem_mapping(struct address_space *mapping)
> +static inline bool shmem_mapping(const struct address_space *mapping)
>  {
>  	return false;
>  }
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..0390e4f55ebe 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -490,7 +490,7 @@ static bool oom_killer_disabled __read_mostly;
>   * task's threads: if one of those is using this mm then this task was also
>   * using it.
>   */
> -bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
> +bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm)
>  {
>  	struct task_struct *t;
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e2c76a30802b..91abac780fe6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
>  static const struct vm_operations_struct shmem_anon_vm_ops;
>  static struct file_system_type shmem_fs_type;
>
> -bool shmem_mapping(struct address_space *mapping)
> +bool shmem_mapping(const struct address_space *mapping)
>  {
>  	return mapping->a_ops == &shmem_aops;
>  }
>  EXPORT_SYMBOL_GPL(shmem_mapping);
>
> -bool vma_is_anon_shmem(struct vm_area_struct *vma)
> +bool vma_is_anon_shmem(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_ops == &shmem_anon_vm_ops;
>  }
>
> -bool vma_is_shmem(struct vm_area_struct *vma)
> +bool vma_is_shmem(const struct vm_area_struct *vma)
>  {
>  	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
>  }
> diff --git a/mm/util.c b/mm/util.c
> index f814e6a59ab1..49ba90c4f763 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
>  EXPORT_SYMBOL(memdup_user_nul);
>
>  /* Check if the vma is being used as a stack by this task */
> -int vma_is_stack_for_current(struct vm_area_struct *vma)
> +int vma_is_stack_for_current(const struct vm_area_struct *vma)
>  {
>  	struct task_struct * __maybe_unused t = current;
>
> --
> 2.47.2
>


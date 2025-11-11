Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B126FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195868E000D; Tue, 11 Nov 2025 13:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146618E0002; Tue, 11 Nov 2025 13:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01268E000D; Tue, 11 Nov 2025 13:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3B158E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:29:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C02B139441
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:29:29 +0000 (UTC)
X-FDA: 84099164058.14.B52057B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 19B561C000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:29:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bdwGAnjz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o/qHc5LA";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762885766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1U++WbYsWfAxGRHAH86cLdHFj6vEcd3Rg6ZDLWrvLIk=;
	b=n5dLjwiN0NC+KL58RmPF8o8mzunzHHiXCk0pRyn4q7YRH5vGrD+GDIhzR7WKHXG1rzjbAX
	NUrzhm8hFWSIWLg6j+SnYqxbS+Zv41PrPgIEfwiSnfcNwJe4SYv5iFyW41ScMR0NTIYcC7
	zZFJlukvxkOVPz6pJsNqJFy+Y1tZKTk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762885766; a=rsa-sha256;
	cv=pass;
	b=PleqLQiBlJriR3PwbQjgTBWt2IpYKRoiQ/sP4gzc9v9OMQ4QjfzWSNHfVFfCyIfSESpTlw
	N2qVNaI6dyt7rklD0ajV72qmD5XZgM1xFaFM2xNeu+7DB6sxFmJCFiJNBe+MOJ9AeEwNxI
	gSpv63yVD8wh8RPuWsu1JGWM4mLO8FM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bdwGAnjz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o/qHc5LA";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABHw4K8012618;
	Tue, 11 Nov 2025 18:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1U++WbYsWfAxGRHAH86cLdHFj6vEcd3Rg6ZDLWrvLIk=; b=
	bdwGAnjznHX+PSzM2TxydXUgc6WXcJ246ISOtDL4T4q4o0k5c2Iebrwm58Dwbpua
	7pNNBYVc3Jk6jmGFmMPm44AnrFp1bf0r7cmNLmQlzWPlbPNAxhF7yfPwiNy9WG5m
	nbeNIaocozpTJXim7ITIybTpuDzLPlm5jJcmZBukp5tGF6NME8EZiILmY3wO+mIn
	WefJyLGVbvMXGJZKO8siIGyYr6cGbUGKZn1BWHuHbByPsGg2+VOfNjFRHBZ6Baje
	udVt0H7TsRa01kfjF5++ECcU+8YRlH8JVbu5M8MwE4aWxkCYbD3E4O8mO1BhtkIP
	AUXJ30MmmrOBh1Mf0kW2xw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ac95mr4jy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 18:29:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABHLA4X020364;
	Tue, 11 Nov 2025 18:26:35 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9sw28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 18:26:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6bgCYlV1BNtxtkqSEUftEpOTF0pa4Wgw0/1x1fMRtlN2wunNKAjsXsT4Ax8sXzuJRU7JgmVYOemVtzz1WZ7GYCVTuy7lJVfv0U6O6IW6spJta1HXmIVqn0OAwCiE9qMu/IyuLl79K8IUsXE9lGoixfMhDpEZgfgicnlcPcZaARiHdONJQ6mrPnYSjujbMsEpPby2KWTVF4qOcZk63AHm14JauNgNVS4/sPtRinFW/mP/bXif05VNYvqarcCkby9301l2iQjvd352b0fBq1hFfOEOpBDACmCPwuj4KPXGYgAOB62kmNxT1lFGgx3hSdGeVYolsRITVJq1AA154c2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1U++WbYsWfAxGRHAH86cLdHFj6vEcd3Rg6ZDLWrvLIk=;
 b=eM+JNk/gdoiso2h3FnWO2MMlooo4pga68r2xYJx0RMfzljqr4hd9oz6wfT+O2fxkN9vj+SP30TRyiPmgI3AJ+82kw+F/9aXSl1BmusO29u65c/XafzedRckvwA33kUbLzAA46IImjg8XMqev2/UNYrSl3d26zsIGest2oQEBHmzRxZG4QkoUZC2wsV46XjE3dDVXe6DILKCATY5uGXZkbhY1iWdeW4bKLoPNFHkGezzzbO8L+lThN+U5SKGkNrynNOauAru1rxq0y50LzT0ivCiWumWxLSol0hVgYl8a+UTOtBJVkvOzmu/mG+wyJ5nEW1IFh3RGySaw75vMBwC6HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1U++WbYsWfAxGRHAH86cLdHFj6vEcd3Rg6ZDLWrvLIk=;
 b=o/qHc5LA0nhTykTEpx066dMtcobCcRFeakChfzR5GjMgN6x7lXIZEDqSkDa/LbOA0+qeylOFV4BPLg8piC5ae/hSZNZb8qG7Zf038INyU8XsNx8W7LA/Z5BP+bLKLUNLSqQhzYFuaYkgP2ZBwmTfcnV/BoSO1rFDV9MWmhOhfeY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 18:26:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 18:26:29 +0000
Date: Wed, 12 Nov 2025 03:26:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <aRN_0P3CXDJujrLp@hyeyoo>
References: <20251111125331.12246-1-harry.yoo@oracle.com>
 <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
 <CANfXJztJZJ4eaFf+FxC=deFeO7MG0__U3FVtBDcmS7iUk3gFgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANfXJztJZJ4eaFf+FxC=deFeO7MG0__U3FVtBDcmS7iUk3gFgw@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0141.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c20b476-d161-4435-d904-08de214fd517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTBrSG51VmRYb2NMYi9sT2o1eHJOS3pHdW9PS2RJWWRESko4cUFCMXdEczVS?=
 =?utf-8?B?UFVRTEorSkNKODRsOXpmWFNmZVNzZUMvc2luakYxdlNRSzlsTGQxcGVjZDZU?=
 =?utf-8?B?MG56U01oNzAzN1RwcUxoWks1VXg4cXFhZDJqU0VlZDhNWUZudHp3NXNxTU5h?=
 =?utf-8?B?YmhKRjhsRmlsdUtETzdvSjhWRFZvOUJVWEtnYXZZYjk0Nmh5Q3pPZmJNakdI?=
 =?utf-8?B?WVJiOFlXZ0RKakFvY2xnWEtjMGZKcDJMYjZpRktDVzdZU1lSNkZJVVdSQ0lG?=
 =?utf-8?B?bHBzdmVvbFV5ZUYzbkZuS2hNbWc5Zy8zSHplYnQ2SThqR2JVYml5SXpFQTQ4?=
 =?utf-8?B?TkhYV1lVbjdlQkF3ZTVIbFFqVy9FdmpGb3lnU1dUcmkzSmFXSko1TTY5SGxr?=
 =?utf-8?B?SnM0b0ZyQlc3QVJOVHQ4TXR1a3V5bVRJVmRTU3VDMm9qVnlQdjBCeG9xMUw5?=
 =?utf-8?B?RWRySzE1MVVIbGJiNXF3elY5TmVQbUdqWlpGL3BsVHhoNXN0U3NsV2laR0RD?=
 =?utf-8?B?dTVwYVVMc3o1SHhMdE9SSHR5bGNiTC9BdGVLNmZqME9nVUhPa3BXYkZleG1X?=
 =?utf-8?B?SjA0N0xPVzFPY0NnVFBiREhzWUJKOTZodHNwSFhjYi9ZcHo4MDVoMkpLb09s?=
 =?utf-8?B?WTdFdjdwSC9JZWJNWkQySWJETWFMaGY2Tlh0d1dBaG5ZK0tiZ01vdng3bXdZ?=
 =?utf-8?B?RUNUWUdEY0Z0SmNDdk1ScER4dFV0QzkrOHo0eTNaZWsvYlNuNXZLcG1Rek5y?=
 =?utf-8?B?Q0d1cERUN3RxVjl3VFZ6d1VEbnlzdlRUUkptQ2tXNFpzbXJ5V1dXTjFWWXVF?=
 =?utf-8?B?U0IydCtCWm83cWl5RFduRnJ5QUpnMFVpZmpPZ0dGM05iQkhncEd6RWtTNUdP?=
 =?utf-8?B?cW1XSTNBQmRrNWFZWnorb1JaVy9UOHROcTdLT3BOdklGOWR5V3dSUjgxV0xK?=
 =?utf-8?B?ZWVxZ0xKUVVaT2dPc0JsTVlyUHIzKy9IZS9yTUhtL3VoUUZhV3ROOGF5akhT?=
 =?utf-8?B?KzgvVGhwbHk0QUNSWGdsY2YrQnlTSVBDRWduM1NMZnRRZDI3blprL2xZVmlU?=
 =?utf-8?B?SnQ3NmY4TlY2VnR2a0hqWUEvVGh6ZXRxWllaSUM5S1FNN0dOMXdtdEpqUW1L?=
 =?utf-8?B?bU1xY1J2L2lVOTVZVDRFcVFVa2lreU14dWswMHhJaEdsblFUVVMrcVNnVEFD?=
 =?utf-8?B?VFJsT1E0ZmhJZitDWFhRc0J2Um1Mc3hQQ1Y0bFNPL05lZXN1UEg4eWpORXVk?=
 =?utf-8?B?YW1jeW1aSTNhL0xud25EZEs4YVFzYnQ0N3dDNEF1Y2I1TE56ejBBcHhhbUJa?=
 =?utf-8?B?QytMWXJYVkU3Nk1JZGZrTDVlcTBsRTFhM1BQazhCRkNrNXhJN2xxRU01aEx5?=
 =?utf-8?B?c0FQVXA3UTRZd2cwTGhQalFHTThkQnM3RnRzWmM4L2QxZlF2eGtuQm5QQ3E3?=
 =?utf-8?B?UnhrZTFYSUdqbnBGUW9KZTJKK21kTzRGcWEzUWtxZDloaStuN0hDandObXNq?=
 =?utf-8?B?QktreU5jTFF5SnpzeitKWEtzQlkwa1dwZElPWk82N2dxYzVUc1BlVFViRlEv?=
 =?utf-8?B?QjlZbHBGR1l0THBCcUdQcDNOVHpWbWlheXpWc0xUeno2RTg5NTVwWkZlbFZt?=
 =?utf-8?B?aHBUU3BpQ0lkUWVJOU9CM01wWlZWRURydXJ1LzY0TXdzeHdWT2dEa3NKRVVw?=
 =?utf-8?B?blFWVXFMQ2w2RTRGdC9nT0pYRzdYaDhlaEwxK2hUelNFNGtTTWR0WkNmdTVh?=
 =?utf-8?B?eGVieHowQjV1ZTJVUnY4ZlJ6a0ZCT0hQRFFZeElZVlNZYWFFRGd4QUFNeE80?=
 =?utf-8?B?Rm5GRXhDOStMOE9RWHFyU2xTWGNzQmtuNmpJRFY4WWpPYnRJR0p6QkRhcjBy?=
 =?utf-8?B?a3htOWI4L1RPZU5xZ0EwNEYwcXpKaU9NTGV2ME5PcFB6aCtWQ0IzTzduMzdU?=
 =?utf-8?Q?4IXz+N2ThtE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDBEY0g4Z1VQb3dRb0ZOcTM0dDVGMDFQbStMZzJOb3U4MUZNdUxHT2ZqQU5t?=
 =?utf-8?B?R0NOcmtmY21DdzVIc1dIL01kSTdOTjBPR1pzQTk0OUVKcEtJMjE2YWt3elQ1?=
 =?utf-8?B?SFJ2MVE1ck5pM0xiOUxlTFo0OXVGTDYwWUpjYmpEVjR6Nk9qRlBCbUxtU3dJ?=
 =?utf-8?B?N2JXS0tNYU1PUlloQXVtVFUwL3dkYnpUTHl4THUrWkhaeXZFZFI5SzE4MWdD?=
 =?utf-8?B?cndkZFc4VTZaRVR1UVVHRzdCa2NiT01TN203anJ4M0M2dkdSTzkwa3YvQys4?=
 =?utf-8?B?bUlLc2ZpN0ZZc1EzN2hYSzhWdUpSSU9PWExSaVdoRXh6Wmh5SHJPMTFIL2Zn?=
 =?utf-8?B?bTRmWE9aUFlUR211OGRTdDV1VmpjOHkvb0tPejRiRVZod2VWQzF4UUc2K0RH?=
 =?utf-8?B?N0hMbS9hN2lsTXdyTVkzbmZoUDY5bnZiNUVVVTRIQ1JFQ1dhTmhzclgxRURI?=
 =?utf-8?B?Rm9NVXBOdzRZSU5RcXRXVlFkZ2dOVVBTWE9FWVBuZjlxYlZvYjNsQVJWQmNG?=
 =?utf-8?B?OVA1RFBTY3VmN1JVaFJVTUt5SmM2ZmF2NGt3NU95aE5lNmFEcDZVSnRmcEpr?=
 =?utf-8?B?bWt6ZXJYS2RXR1NvSFdnT0gwRkc2eC92RHB1VGFnamNONUdUaVFCQVh3QkIy?=
 =?utf-8?B?Q0NTTVVGT3poU2tMUFJMbUh6V3NIZjNHWEwxUUlPME53S3RseXNDc0Uvckt0?=
 =?utf-8?B?OUU0bnl0clYvWGZhc2w2KzFzdVhPTmRZbFRJMkE3WE94ZzkyNXFvOGZIcHFl?=
 =?utf-8?B?Y1NWMDRGSUVqSCszVEJROVgwU2JBSWo2bzhxeDZZQUVUY3pXSXRIN3JES2hB?=
 =?utf-8?B?ZGpvbUVQYXZPMlJrMytpTnl1UGEzazVjZEJrZitQTmlEcnVyZklPMEtVYkls?=
 =?utf-8?B?TVpYRXFQU3lXTDN1WS9mbjBsOTJMTVFPamIrYkROelc0dXpkR2dWSWkyQS9Q?=
 =?utf-8?B?SVYyMUJQT3liQnB6dEdUWEl1QzBaeVZZV0YvSU9MbU1QVng4MzN6dWtXR3p4?=
 =?utf-8?B?bHhka29kWEwxbWxNaGg4STBMMFp5MHpIUzJLNDcycUhRRUI2TSthK3pqbk9y?=
 =?utf-8?B?TXBGeS9FajZpV0RNTkZmd1UxdGgrMG11QVpzZzVHbnRTVzNlYlJkV2lwcnlS?=
 =?utf-8?B?TnpnZmxqYTVWelUrRm5wc0Mzb1dYb3JLaEVXbGRDV1E1OVlCaDFxK0RhalZR?=
 =?utf-8?B?VEZiQ0dvK0VBTWpZWmRhazV5WUs3RDNKRTRXYWVFeVlYMlJ6eU1wblZpVk1p?=
 =?utf-8?B?biszVkxoSy95Wmp4YW1qb3RpdmQ0dEVrMkNacThtVHZPb2VNbHZxUWcwamsw?=
 =?utf-8?B?djJlWEtYZU0zaFRhUHdxcnFKWDFKYWdSUktITEI2ZDhzTmxZQjdXSTIxQkJI?=
 =?utf-8?B?OVl3UHFDemNOUXNobjFsS0YrU1hPYXJIS0xMVEI2TjFHMEVSK1NCL2lsQjUz?=
 =?utf-8?B?Zmo5NmNWWXhZUkFQTlZBY3lwbGp4SnZESWtXODNiNnU0NUIxUXY3Q0E5UVNt?=
 =?utf-8?B?UHVwa084QXpPem1TMUV3TGEyLzVaVTMzWmgxa2pJWjhwTU0xQ2lwRkZHSVJV?=
 =?utf-8?B?MjlHQjRNTnNMeUFTRWtHeURvd1k5VlBxODZoTGVxZUVkbEJOdDFsMzZLVE1o?=
 =?utf-8?B?bDRTUTdXQjZNd3k4QkRiRzZVQzlDbTMzL2hERzRhRVhxWHloY1pTNW44d3Bt?=
 =?utf-8?B?RllxNXVURHQ1bmNidjRCOEVBSno3Rkh5MHZMMXdYYlBxRmZSNlhkZFBrYVVt?=
 =?utf-8?B?bXhFdXp1elRYeWpZR09qUEdtTmxvWCtrRkx4LzdyeEUxYkxDdE1RaEVsNEdT?=
 =?utf-8?B?L0Vpcm9BQ0RJVnNJQUQvRi9rT2dUQ1A1eS9oeURGQTlsN092cG5DYk02bFB2?=
 =?utf-8?B?b1ErY2VzSHNVa3p2QXQ0VC9oOXNZelhxYWs4Z2MwRElOeXlyelhwWTdLTFU3?=
 =?utf-8?B?M1EzT3FBd2M2YUZKcnVMTWY5MWZVcE5GY0hDajNaYmdEMkVjYStmaGVkZXZU?=
 =?utf-8?B?cm5JelF4aXFhVWVUNVZXYXNLL3ZCT2liOWprZFhmWFJqZytaTU0zYktveExy?=
 =?utf-8?B?ekRrdXN3aGI3TXFiYkZzUDhBem9hN0E3WFBjb21mZUxuOXpwSytIbW9EbG9w?=
 =?utf-8?Q?k5995fCdGkMzIPdC2zwjDI8wl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hb7pZpgiCaJ5l1LIOpy20vThyqenOy6u6EKfhvBUPZCv6pm5LrIN1xdEWjihFamlc9+0LgTPooX4s2MWOs+ZuGpawRkMPVMEMTP3d7Uog22ewswaV2vMrA3A4P2Rbswj1KZwNKllZ9LNYBgxG8AidxulC9NXlGE1c2P4tbtrGTUXIPf93K3h/sxRtY2B84EkyJGOhfd8mdNrDZeS1ezUeAL1KfMo6eX4Ai9IEwLxMGYSLbpORjTabU4s/MmdOkFjc8rSLIC97TAsS43aMOYjxorOpc3UePkFABpBp133lcsympn3YE9gw+YDV1gMSUFU9KRmQaaJpICLn1DnNb6vXF7UB3f5Mkt0tGJdd4uGFKe5amXIUe+DIFvrrSFniNDrv3enPQlAY5AJG2ynbzOQHdDJiez2DCdBYuEwAPeKkV0f+NRPkQk8u8hRxj+KVMKTzY7Kj9sWLFla/J8ruBGlXQq93EK+1g/QVaen1MLjxa/vJmcZTidihtDnQK3XsmX5ztG8fDRdJZheq+ZtUKy4n8DO/KgCx60PrhoAVqIDl+NTWzqfdh3/2MXsCWnOMrjnv28rrD8P70NxdFz9ukpgq9SikuIcEvfgEntarL05lU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c20b476-d161-4435-d904-08de214fd517
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 18:26:29.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4REkJOWYLKsb2amNPo2Ud1zKpDrgQ1a67eHrP/2SEWGgsnqMVzRtfl+ORD7Ers+A/KyOTYCnnhnwIOnnKy6Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_03,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511110148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDEzOCBTYWx0ZWRfX+DLLr2BK9gAT
 1Y9+bSzxduAi/fDBTdHmKtoR6bSRIgUQ6ixqjjidatPNKsy1buFcMuKEqoAQhhkXOnkU97o9u7C
 oTqlvCBDTvFo3WOucMuz7zbWlCfvHK4AAhHC2k/fYifPg129SpphOmo4wUMPkbvaA75NUdI1eX4
 DWKB3/vQZ9eiApwJgGb5Z59ygaM5seCpQw3jmRB+kLlOTpaw021Pii1J1o3bZb6v2l7kiN62MIk
 0SvbBRJzOrScTdXksZW5Ep9y48agEwbqyyl/1JaCDHMDO4gH2PHp9AXt8OoKvrQ4nu4QBHzF2xB
 fJ+DltxrUT62RYvA4TT75lJ54bI5rEs+/Y8AhJ0myp4A7jU4XLb9JnNNghFSltw5ckVvCIEqz4M
 +FNz7UTQFSZ7xee7xkOp3VCcAL/8LA==
X-Authority-Analysis: v=2.4 cv=b+e/I9Gx c=1 sm=1 tr=0 ts=6913807f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
 a=b_xSILk3BH2CphujB5wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: m4AtzXsrud4IbCChlfCLoxIeXTBGJnvC
X-Proofpoint-ORIG-GUID: m4AtzXsrud4IbCChlfCLoxIeXTBGJnvC
X-Stat-Signature: nwdm4ryng14atjchsukg5oojoa56hywq
X-Rspam-User: 
X-Rspamd-Queue-Id: 19B561C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1762885765-448965
X-HE-Meta: U2FsdGVkX19FCbkKM/veO/mW2rtnsqCOMC2R9YLDPfaoGrJSBU+Qyrj5AnIBS/B19ueEJyO6kBlY5m79n+eZdneA+Yj+dLiCYwXAucbuqqNSQCGLxMHW2rQTaAgJDpOKuCa6hE0fpNnv2amnt8mpgormkkr6yRDD28Jof2aOkIXh2MKau6MfsHf56NexUVdUZH412bsR/hgXy9cQkM6cr4iyNtiky3Ke/qb5Zq2zpxO9a5DeHR0sbovf/zD1Z3ihR4qiatZ26/wbzjOdQZQS1pfzlSsjKXwsMLjBIUJylxKPCUPaIPwjOK/amCMGeVGURjUGQTg2Pbq/1ri4E8lZmPGWzt7C1itZkiDjfwzNEsG4K/Te8JAoX3S5yxFq/j4WJ0JgGmQyFSEKc9iQT04t8H5u1WEm7hQWYgV+DqktSxA5G/mVFxtH1qtz1tILFOKNc/tQ7Ie4UpuvI4gNVaFiaTnLcqs6PHvXJgCdw0Q8Vn6/Z4vG0AbzIv9UHryvuy6bQNmMDq/LdR/fJFj7teuLixNKpUU2F9b4ZXTn558aowpVfu1RXcZSl9nVKLc6/rJZNzXBphsebIZVxRnnukV2qoysOUiI9Lr44RK9R+RjyG50ITqzTMMKSIEDxcFy96LLZf9EOKLd30hJazrydgUTSCcrXqnpKg58HnxcMAzjz/Y/UQY0PNH2kLpj1w3bBxXnq8yfTgfCvrKJQvDKjopONAXhyr7qnowOoWFYLoojMsReprPYKYCi+NxOaQY18tim7w5AGKPtaYAOpwIg47YKh+lPM8gfjUHp/aB6oIz8abF6j6ovFLq65vdk+S9TQekigQRIqcBEZgFVccgclU7nPpqH8mu6yrRqLGmslZ8J/uCwOUEaUKWf7Xpn5GIHQmQ6bjqDnv6BYQ5JwLtahpj94MvEMT6/sM2aTplv7zsl6yRVfuAvfPP1uipgAmuFmTVNfbaftuaMoImwzQXwrnB
 K9TTOrnq
 x0BZFRyqjx0mjOUwaBas4z7Yv00h41ZcQEgr2IWSkp5JitNnUwE3gU7xbBhCytt1Q057fwXXgm2N89HIlChsT7vDHTyvO3vPevGpYQdV3v7AafQuh0b1TVlZCygjjE31lBU10ocszBHH6wDc4uyAvDgviNM5wy4Zk2HiFVyjFMT0h5XReElCX9bcZbOF5blkN6IKhIi7dxRUnBHxB5WMxzXDCit5w68iijfGFXWqUUxZiPz0OvD8WVZjhfhC9T6jwpfWR+99gp6+9AaBYza7zFSVqbJAtaSblXJr4ITeuBiuuh2cCWTXb4nEvgM5AaeXmLdCF4Wa58Ps5k9Rk84gST4IOeNP2xwZKDk31NpFlPBLb3jHi2EvTVCjJ36+D2D5G9tDPvOQpAYA5/7Vp5ZAt4wOLZMTzWfmcfH1BcCQLGP59/sZXGy8GOiiNnqRwmli2gNm2YIFJcezB6GQ9V9jrGtgKibmZ+Ofdfi7LaVXD5SHDaGSg+E9YrBWqRCyRwvpekpEsl0XEgalRTwctybDiJS/wVL4cgoU7o6yzocIwC2NM0ThgEoiAG9/B+J0IZZl8ODNDKH5/eVCM78p4dg9IOjDx0zxNg9qkQL/8gtjvqdGs9isov8PdLES9NA9cCUMy3fqa/av25WQtGTWFoWHvUEvtHitvjeQl/kWOVe5vzf9V4vfXVENFvEqbSMGSTcWxAmaFJTHvZT3QMOIpheuqd+I/UiCbap1DaiGYtI2bL/ioS4mU73HQGTTHpYjWThWoEAb0+7JttbYSlDg3EG8de0I2RzJEGn3nqU7IiTe8ZlZDNDeo8j9wF21YQJ4hHu/d1M5w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 05:48:35PM +0100, Tytus Rogalewski wrote:
> Do you guys still need that debug then?
> I think this is happening only when qemu vm is working.
> 
> I can get results within 1-2 days.

Hi Tythus!

Really appreciate you reporting the bug and testing it.

Now that I know what went wrong, I realize that `slab_debug=U` parameter
will hide the bug, since we disable "sheaves" feature for
debug caches.

Instead of testing with `slab_debug=U` parameter, could you please
apply this patch on top of Linux v6.18-rc5, build & install it,
and verify that the memory leak is indeed resolved on your machine?

> --
> 
> tel. 790 202 300
> 
> *Tytus Rogalewski*
> 
> Dolina Krzemowa 6A
> 
> 83-010 Jagatowo
> 
> NIP: 9570976234
> 
> 
> W dniu wt., 11 lis 2025 o 16:37 Liam R. Howlett <Liam.Howlett@oracle.com>
> napisał(a):
> 
> > * Harry Yoo <harry.yoo@oracle.com> [251111 07:55]:
> > > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> > > skip sheaves when objects from a remote node are freed.
> > >
> > > However, the array is flushed only when:
> > >   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
> > >   2) slab_free_hook() returns false and size becomes zero.
> > >
> > > When neither of the conditions is met, objects in the array are leaked.
> > > This resulted in a memory leak [1], where 82 GiB of memory was allocated
> > > for the maple_node cache.
> > >
> > > Flush the array after successfully freeing objects to sheaves
> > > in the do_free: path.
> > >
> > > In the meantime, move the snippet if (!size) goto flush_remote; outside
> > > the while loop for readability. Let's say all objects in the array are
> > > from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> > > an object even when size is zero. This doesn't appear to be harmful,
> > > but isn't really readable.
> > >
> > > Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> > > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765
> > > Closes:
> > https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
> > > Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> > > Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object
> > freeing")
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> >
> >
> > Thanks Harry.
> >
> > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > > ---
> > >  mm/slub.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index f1a5373eee7b..a787687a0d59 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s,
> > size_t size, void **p)
> > >
> > >               if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> > >                       p[i] = p[--size];
> > > -                     if (!size)
> > > -                             goto flush_remote;
> > >                       continue;
> > >               }
> > >
> > > @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s,
> > size_t size, void **p)
> > >               i++;
> > >       }
> > >
> > > +     if (!size)
> > > +             goto flush_remote;
> > > +
> > >  next_batch:
> > >       if (!local_trylock(&s->cpu_sheaves->lock))
> > >               goto fallback;
> > > @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s,
> > size_t size, void **p)
> > >               goto next_batch;
> > >       }
> > >
> > > +     if (remote_nr)
> > > +             goto flush_remote;
> > > +
> > >       return;
> > >
> > >  no_empty:
> > > --
> > > 2.43.0
> > >
> >

-- 
Cheers,
Harry / Hyeonggon


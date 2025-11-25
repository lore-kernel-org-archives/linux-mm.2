Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA04CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 04:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FC16B002D; Mon, 24 Nov 2025 23:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57B96B002E; Mon, 24 Nov 2025 23:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FCA6B002F; Mon, 24 Nov 2025 23:55:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEF86B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:55:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F8FA5A1EC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:55:03 +0000 (UTC)
X-FDA: 84147914886.17.F152E08
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id C509A40008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:54:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ju+NIbGm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V2891Xc0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764046500; a=rsa-sha256;
	cv=pass;
	b=vZjxTmKqfKmSdMvUGJEzOJ6Bp1KpDE+fKRSSqxChXq+gTGaG9rrOsBgPzu3TVOtP4/PFFX
	AB5wBHhMg3IkQo7vfDLrrwa1Q8p191PPS+1P5nGi7ZDYmzkhxx7o4bcGb2jFU5ODc/83kd
	ODd4m8n1cMPTYsSCIUv9OXNpgcgn+C0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ju+NIbGm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V2891Xc0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764046500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xO/zluJU+jpt8u+e13ZqmklgQdTqJ+JENNcCxyCcJk8=;
	b=ta9xDiy7fW5kVHzWunqAgTTLF6NH+/IzEZTvC5Roa1fKd855fWlvi75LQ/ZYBlZcAFCchX
	FIEFr9wt/ZfsTT+xwx5GR63NKE6UnJMsIkm4YGZYKBZ46vpdmmta+zzRJxRgcPTIALSLF4
	G8nsX/Q1sBIYxisYpifLxh+iogM58sg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AP1CuOd2389010;
	Tue, 25 Nov 2025 04:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=xO/zluJU+jpt8u+e
	13ZqmklgQdTqJ+JENNcCxyCcJk8=; b=ju+NIbGmO6NUVuMCxdbqMqwBn6VWKNEJ
	fRrw0KcBk5j7VP1jOmDkne/mfpnFWdd8rNqc+6Iweq1NTjtJl1wkz1/1YyiZcLW8
	gxOTjafcgnXRDRJH1NLjGx3CMdK/bmc7sdS84bZ7WRvLtpAhwZtx/9Oe/+9YNF+t
	AAdh4EDc21Y5lonjIzEvr/54dg1Ju/HnT9D0UgfKvMmZ5P8kX95SxODme1KfM4rW
	NBvPWKGZNIFwDynj2pD9Sxz+flT1EtN3RlxH63MuV8q45XueETcY4Dq0PTha1UHI
	3sd002/vws8I5rhCWIZ0a3tNytgpGLj/tTut/COcgJ1uVGbvERCs1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yhkdgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 04:54:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP4O4s0033305;
	Tue, 25 Nov 2025 04:54:51 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m8xxp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 04:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SR2Echr+oKDC6QZEKLgr1a/sK+Gr2oaYjRJ4UTP6fA5m8RTfHsy40MuPHibqpjyWLW3Foi66RWcDr4OxWR5GVvvPi5+k4wB7gLA2veJjL9xF5siv0IdoD88VqAr5Ovw/9baUupCXq1b3PRkhR5/72rTwz0c3De5Ov2ShXhmFZlvu9aE3rTr88SyF9Xblu+fldRAg9xNHfLofoc43X9wEofmrzU416rR3PM1g0nig8WYujUNbAU8clFSehb+keLwVaZQNMlrRwmSnZUnXbeBSZSIx23rSA6IVAQpHo0t+JnHY8uGG3qPxaB4YKknL9WIMTJSZBWXbwWM/LPw+N/qu3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO/zluJU+jpt8u+e13ZqmklgQdTqJ+JENNcCxyCcJk8=;
 b=JOCGZWu7kDOxetN+wPex91Eu83aTItP8JZiCzVRQIEKu9r7z7xcKqai7L/7fuc3Bq+VvMG5g5BNI56ZDdfLeoJ26PIkTuoEw6JlzE1yacEK6kBdNujPsVAFzwgVkX2IG//hPEMBe8hU5il2tyEGo2iHJ6G5lzPTch8ilsvoNaqlxMGwA1qTzncEJqSkQD8kE5b3EerYz6xx3h2Pb5iUE63NngVS5kkrBH9WIKNq/b+ONf1am7KN5WhGm7dmvF1IX2BKaoxYFATCjin/n7KITSkMedJ3D891BzH5Lf/elATo7fWnBReG8hmnWtGTcfbP/SlS2ChfJc1dn0Im4Dtd9lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO/zluJU+jpt8u+e13ZqmklgQdTqJ+JENNcCxyCcJk8=;
 b=V2891Xc0uWSLDebiC8uKfXqtqB6WPouGCoohbblQ/v9GUqc+JFKKG/LAcoD6FCpNZFQfgBsPBq49Diu/eXsoa0q2wJ0AsoYR6iyBtfjiiviLqMvv1DP/dqVWaAms/hgv9VaQNeY+QlzhWFJS9tOyQNIGzdRbGbOHwBGjmog6Kss=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB7216.namprd10.prod.outlook.com (2603:10b6:208:3f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 04:54:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 04:54:46 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
        hughd@google.com, jane.chu@oracle.com, jannh@google.com,
        kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
        ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V1 5.10.y 0/2] Fix bad pmd due to race between change_prot_numa() and THP migration
Date: Tue, 25 Nov 2025 13:54:40 +0900
Message-ID: <20251125045442.1084815-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0119.KORP216.PROD.OUTLOOK.COM (2603:1096:101::16)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: cd390e17-830f-47ef-5c6d-08de2bdec1a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnB2R0tRUG0vNTRWak1IUmJlYm1CVHpEU21EQ3lEWXlQM1NZeDNUWkhsK1VQ?=
 =?utf-8?B?ODdpZkxaMVRjRkZieXQ5blpUcmdXUGY3ZDhKMllHME1meXlVbUhxRnZJZ2tn?=
 =?utf-8?B?NjduSjdwNlp6U09BSUFKZlRzZ2EzclcyUGFtczRreGV3U21NbTBCLzBhbTU4?=
 =?utf-8?B?TjEvNEpkOWRDbitGaXN4ZjFJR0FrL2lWMmVycFZNaGF0YXc5VTdTR05NdHB4?=
 =?utf-8?B?OXRaQU04ZFV0QXcwdWgwUUwwcEIzdkpabWRuRzZvMmdjdExkM1g5VWpRcStG?=
 =?utf-8?B?Zks2a1dtWnZqVnFJQlRkZWd5bS9CNUtBYTNKYW9mMXlFR3ZNdmh5WndMUy9C?=
 =?utf-8?B?ZGxwR1NYSTNZdGIvdGNuczI2SEdrZHJKZkJkT0g5aERrdEovZ0tjVW5IRmJL?=
 =?utf-8?B?N2FrekxPdTFXSk92U25vTjRybDZ5OVVlbDNuQ3NCci9mU1pGalVoVlc2SWxD?=
 =?utf-8?B?VC9vN0JqNHdzNGZNZ2F0OUdGZGh4ZnY2b3RVNUZxYlRvblpJcmd6MFhkTWtU?=
 =?utf-8?B?d2pFMWJSNjBXU1BEaDYwZWRFRVVPNmxPSFRTUVFMSVUxNjRXSit1OHo2U0VD?=
 =?utf-8?B?RmtzR2FYUjlsYXZTZXZFNUJnQ2JFWVVveXBLemdjYW04OUF3bnhOZHlYV0xC?=
 =?utf-8?B?aGptbUFOMHhWVUVIdEQrT2tNclJhaUpMTG9hQjArTE0rMGF0K2tOTHhNOEJH?=
 =?utf-8?B?ejN3dWg5ZHROazJIRWtpa0c2eVV5dUx1bDRURDhnYXZuSnErME1sdlEzTlFL?=
 =?utf-8?B?cWFteDhTWHo3RHl4ZzVSN1pKL2h0WFlNbVZnZ0hrTXNXamZFaTFIN2t5K3hH?=
 =?utf-8?B?S2pEdWpTaDBvdlp3TlRvR3NNNW8yVC9Xc2llZmhMMWxkRlo3azlFNUN0WkJ4?=
 =?utf-8?B?T2d2alZySVJXRnFYeWJrcnNUcTV4ZlZOZTN1OHE0aWVJY3ZGYStpNThFZ1dh?=
 =?utf-8?B?bmhISFk0Q3ozbUFOTm5GUnRXT01RS3RXbDVqNEpuZElqdTVGN1QxeEFZc3RM?=
 =?utf-8?B?ODRZYW5lZWZOdGFKem1URU14b2MrZFZ6UE1kT2Z1UkI3Q2k2VTJxM29KRVBL?=
 =?utf-8?B?NGJoSmovRjNmc0hJVEtXd09zMTRTbFMxeFp6WnZDOU5SWGtFZXNKNzVuOU5R?=
 =?utf-8?B?c3c3dXJaMkdIeCtYY0lEWWlNVGVxdmNSeDlrNTB3NDVuclJjN2pYTTNlOTI1?=
 =?utf-8?B?SnpiZm5LSm5jK0ZEMlBPd2gwQmg2aEZ3bmQ0Zm1aNGRPeFVQbnJFMVhpSExn?=
 =?utf-8?B?L1J3S216aENQOGpmdTh5RnJBUDEzV2EwVGp3REtDd01jWnpmQXZlMU94MkRB?=
 =?utf-8?B?ZXljL0k2eUx2OWhQMkRTZjlMaC9NZkF6ZG44VDI3WGdVUmZ0SHcxeThKbUp3?=
 =?utf-8?B?d0E1Z3lSd05MWWVTcXcrQXBvQmZkeFZHdndhYlVEV0FEOU1iWXhpM3Uxcjl5?=
 =?utf-8?B?ZGdESXV4dWxMR0JDdkNCRG4wMTVKNFVtU01YWk9Bb2ZWTkw1QzBEamQwSWFk?=
 =?utf-8?B?YjZkZ0FPaER2RFR3VVE1SFd4R1A5cTYzWDYxWjViZjZtZDZJZ2k2ZU9mSnhC?=
 =?utf-8?B?czJhQi9IeHhFVkU3WC9jaldOYmRMRWVRRU1LS2gxTmU2b29wYXZUYUFkTU14?=
 =?utf-8?B?OVlEMkJKQjNFNm5vZ3liODJOeHlUZGovUWk3eGVqMWlUR0hXUzJpRHA4UzBB?=
 =?utf-8?B?K29SL2xCRHYrR2djRGk1c2l5R3pVRW10TWt1dVJHMnZTNWFkREFTSjdPejZh?=
 =?utf-8?B?d1NLVEtjZ0VJeEcyWWMvelRoVVhRbFB4T0pDSG43eGpOMDZRdVdrZlFRbXB5?=
 =?utf-8?B?d3p2L1A1cTErQ2JQdElOU2hWdzk2T3FEQ3IxcVJYRnVGQmRFREMrZDdqeUYx?=
 =?utf-8?B?aGI0RTdDMXh1MGhUbzZlcGtQV3AvSGI5aWVxb2V2NmtMcEpBS0g1ZkNlZWM1?=
 =?utf-8?Q?tSioeOjOQJKkAVRE/nmYkK/Swlo+5HSt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWZmNi9oUkNrY01ZZTZldkxDaUV4N2hEMEtibTZ4WXBOL1ExRGFOT3k2emZy?=
 =?utf-8?B?bFVjdkNyRkZ6ZmtBLytwbmdlbnFyTTltaWZteDVHU3JKZlhhTHA3VlFzVTZx?=
 =?utf-8?B?bk5RTHRXa0J6VU9VREtLUFc4YU5tV1BNUWxzcGc1c0xuaWMwcHpmTnhiWkx0?=
 =?utf-8?B?cFIrMi8yKzJDb1o2eWZtRXgyb1k1aERnSjlIb3BSbVhyV3F1TnJacy9wQVVy?=
 =?utf-8?B?Ky9sQTkwTUw1dGw1STlNZE5mbnd5eWV3emg3cWgwTFdjMTEzaHl6S0NXUSt5?=
 =?utf-8?B?Q24rbVdOdlRiZkRhT1kzTTA1Z3k4RjR5UjYyMkIxWkxNbEN1ZnRXckcvN1pG?=
 =?utf-8?B?TzAyWmV6MTJEWXhpTVY0a3hML2dUa0xQc1laemFZT3NEM1RXK01Fb2pYZVUr?=
 =?utf-8?B?eE5GVlFMaExpVjNJbU9lSldkWWljMHBvaVVrTmNTNmpCa3ViUEtyeUFIOUxo?=
 =?utf-8?B?YkY5b0ZFNzNhNzJGc3NHcTVyVkZXQWtNampvd0RubmlrSWdFZTZyU2Z4OU05?=
 =?utf-8?B?b0ZzR0VxZlg4T3RjVWQrQnR2VGtRN2ZuZWRCQ3R5STZnS0xzUFlWcHNEazNT?=
 =?utf-8?B?ZHVMQTZjbWlRVWc4WHlNNHA0ajVpMjVNUkd3cmRZS2lqRG4waVdtSEpiNnU1?=
 =?utf-8?B?OTQyK2RXRkkvN0ZlS2IvSTdxdUlWeFdMc1lXYWJWTm5JWDlGeFVjNWpsbFJm?=
 =?utf-8?B?MTNsWmdNSGpiVm1UT0xqNEdDZ3BQN1hEa1ozdXBLdVluVVJzd2o0b3lXU1FW?=
 =?utf-8?B?Sk1ZNndZcmNKQWdUcHpCTXJKSlVuaVdRMjNSWDI4dS8rdE5uZ0N0OEFXRzA5?=
 =?utf-8?B?RzhienRPLzI2MFpoRXpFQWlEa1c1TkZjUjFNOUJ3bDVnYVY4d21TN2x2L3hV?=
 =?utf-8?B?TmJ5YkgvNUIyNWFGR2ZhWHNFcFdESFlydHN2RXhkZkJFTWNtekM0OHc5bERU?=
 =?utf-8?B?eEIrT3Exak5uRzVxWWRWeEJudHRIOW80cUlrdENtTkdpSHRZRGQ3T3FBRi90?=
 =?utf-8?B?UEhIQmFobEdiREY5YmVtRC9oTVRQckJibkR3NjRBS29BSlJzaFJVUFlPTTRl?=
 =?utf-8?B?RC9YK0hiRW9PZ053VzBZcENMOS9pdkpOUXJxaGlwRzUrOWg4MEpodjJHU29B?=
 =?utf-8?B?NitwN1lZaUNYWmptSTI4K2F1Q05aM2lSRGlFN0ZVZWpEZTEyK1N0YVVYM05Q?=
 =?utf-8?B?bm5sK1VFZk80WDlRRXBZOUJZTXRMM0h2SGN0ek9CRlMxNG5XTUlRN3B5ZXFz?=
 =?utf-8?B?cGJVbVBLZmxqNzhUVXlDUUF3VElMVis4K2dGUTdMazdWTWZJRlRESElNTkxQ?=
 =?utf-8?B?WWNISTBzNGpVMzZMcVd4UTZNK1pzQ25PQUl1aTJJT1FxMy9uckMvTnRWeDJT?=
 =?utf-8?B?a1BCY2FNVGlCd0p4Wlo1Q2JBNm1Cd21yd3VXd2QwL0N0aTRvb2xZdUFyNHg2?=
 =?utf-8?B?TUV5RUU3aG45dG1GNUQ1OTdkWGxkZ1lSbW1lYU40Ry9LcDF2cHpZQlQ0NEQ1?=
 =?utf-8?B?azJHd1dxUGVVeXRkOEtiYzloT2dXZU5RR01HMm9yRDI5WHR1TSt1Nk5rRW13?=
 =?utf-8?B?QnM3cVE4TlRSeHBlMmE5QjVLNGZVeC92ZGYwMnY0eUdTMjNSS0RmZXZ6aHVa?=
 =?utf-8?B?ZzJZR0VxRjdFMEhXLzFPMXdOci9CVWhsTkNEMGtqTGhCV1N0Z2VyTk9jYkJl?=
 =?utf-8?B?a0s5UkgyYkdBS1VObHVrenNDRzl3QjRWNlEyM0xmUnY5ODd3NUUzV3BFQmw2?=
 =?utf-8?B?SGcvZnZHSGV0TXo3VFVtQXgweHExRm1wRkU2SW9wMmtEcUQvOUM3T2Mvejcy?=
 =?utf-8?B?QXNoKzdHcjd2ZFBKaG84N1BCSEhHaG9ub2dOb1lGOThuckx2dGhSMXkvOFYw?=
 =?utf-8?B?bHVkd2F1QkkrOEpiN21aaUxlUy9TSW5xSGhRbWdzY0VPZG9HTVpISC9QT1lO?=
 =?utf-8?B?dGEyME1KN2syWmR5V1IrTE1Qd1NjVHREa2dIWGlPV3BpdVdVbHdxNXg4ekNl?=
 =?utf-8?B?RXBSWXZGVzlWc05Ea1RkWFVKa2RERm9mci8rZjFjUWtEZTlaNlZ6bUw5T2Iy?=
 =?utf-8?B?eFJZbzdjQ21McmNRRGl1T0UxWWpDNEswaGYrM2dFYld0NzAydGFtMFZjUnkw?=
 =?utf-8?Q?uLEEx3Pm4ra1T5yXjjUDoHzkQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1mXLpsLI67gEFaZ26tNBr8xqlkTVGOgXP7XfdV6a+vNlrG4O588YzGbPlCyB5u7eG7qb+8ODNhY1R7gAMNdOtf4IEDMruZJ8U2lQFcrPxW5HdiPyJAn07NXDbOnaspsaqTa9lRApF8mNjRX3Omr4fJZ4Vt4A1KuT6aGsZujoyee1Cq5tjxfOLj6Nm5lfQcYdSafz57MjUEOyK33wg2rLmFwM0vN4zaEYm8U3YYdja293OAWIa/NuzBi29SuZ/Y/KYVPOaJvfXpMgctVRseHEzD2w+kE0XaKfcInDPV/6wPK3B1uNjqxMVmyyiT/wOH6BPBzdshaF5ASd7r0xxbLZ03EB7bap5045viqdSFoz9yCjysqEMqgo9bFkd4j+tcrF53hF8YjNs3laDHLmN1jLcpfTOAsHzUGai/JzUWkwLnjmciknUf+lgarWJitHDo9GcnmXGpp7rs/7+ydue/wig6QqvTQvfkLG03nefmespCO/mPCzRyxkx4z6yEeVU0inAOHo8MzirbwrfsxINUN6WsfFmni7X3vhha+H/4Ma+HoUC5pSbYvuYxmdVSOxU3ud++67rW05cfP0xie/HA2r8D/+XPr2fHrsbZb9RWpSsK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd390e17-830f-47ef-5c6d-08de2bdec1a4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 04:54:46.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUaXnMKTSmaMgX4A2IClDi7AT2D0pD0t/pDNRqv0unpfOa+5nJcCaQ3sxUbDc6/uhDnOBiPnPuh/ZSJcrtHbrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_01,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511250038
X-Authority-Analysis: v=2.4 cv=L6AQguT8 c=1 sm=1 tr=0 ts=6925369c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=S0-RAjllWCc2AOp5NP0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDAzOCBTYWx0ZWRfX2EMDKn0fVyst
 hDJ3cogkI3Tzp4J9VyDyKFuB7t5+deeK2qMFC+eI8iNk5xICOCfGrZSEX5I2ViVcOJ2edPJbBJy
 DgZkhQCOspfJGr/+FY45mB3AcRQGo+fPxC0w6mdnocASeC8nZvy+8lTHFgN996NOM+s6rbUO7HL
 4Np0jC76W/PUFXX3ghAIHGf6QajzycCTuzfvm8Nc23Gu4n8tuYU96FnlbZtCrOsH+34QF8bCMjZ
 VJ9Sa/Ijf51m893/7102DfclPCLF5tWzDo1brB3nD4F77yIXqpsNsgFof5p/+s1xEw0D3uHa6Gz
 2c6R5/Xv5Qg4gAaUQaY49Pz8V8PF8JnF+uYCZrK/jYMDHaraWi6tS9rRF/7GF1i9tAPvRDqbxhT
 APkuZX+lt4Dn22liINmgJpQs6f7Ltg==
X-Proofpoint-ORIG-GUID: i7AomrChMjSiEDzUCl05py9b5OFt7sSU
X-Proofpoint-GUID: i7AomrChMjSiEDzUCl05py9b5OFt7sSU
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C509A40008
X-Stat-Signature: zdifrcfo567zdscse8yuco89x1iriqe5
X-HE-Tag: 1764046499-81954
X-HE-Meta: U2FsdGVkX1+WjLj36SrX/fmujESisVk7hzv9xXjoTI5KC9BmzuBfdlpJE66bLMrZRsu6nBbbuy5tSqposO8LID/W5MsrCgHpTRORu2Q2ZemJrRNxVNvCADpGp8toUyUaqNNC0LUx40ccn8CeyEvKUta63E0HYIv7p0GQNBH9REnjqqpaqMFQ2uQrCtwI7vb6XpN0cW1QnA3GHxbo3y9d6KeaR6bSaHnuRcozdTjwRVZutzpY0BBRuJIyKxi/gh4P9KQt1GQlIYv38RN8C26yIGY6iEzuUDiyvV38o3E0ODXO9e21CRqYiYiaSeYXMeYFAt6qLXA8WQC4M2JFcAmgwm+jcwvIB7AVBGnuY3MhwdSul8gNeRFT6XCFUGewzQd4VgbJW/4x1xD6RnUsOspzFBc1n37W4hDqmQUjvds6Gk+/PCJiVU4srP4BcCVQF54kUT9R2pXJb/bI0LJ8YG2TRLuJ8qAV2CRbKHP21GLj9eW2weXVDokquDTfm/e9R+88WZ2BjWEtb6xCisudkMB8Au79q5G9RwJUp9/VwgZNjhuua2cMi1bXWK0/6RH+N6fIX66WtFNXX0E2jrnyX39KS7iISzzHNnC+ZYBcqDljrreZRq4yv5rAWrwS7GY6lSqIlLTZV9oYr59QXiOKgvKnmME9ho6UfC5inrEpcLYPuTAVxbtzAMT0u5JB8eqIrWJMjm6ilODD9uO/0gYq4uyug+OpqvEQb+gAXUyPYqKRIKuB8L7rGjt8/ZwnDmD/N9zaAmX7rrf8gNVkf4EGWVxRTXfHTyCwnKv/zjhfDDyuD//3QeWpxTzs+zqNAHfXNqAZpMlFHF6NBxqyXJ8isMqz0z1qbrj/EVfRlnu5wSLVbnDJHJa25sBqso0XVuojHwUD5Y02TcY2jZ5NUSvqQox2lTubYiA/b+oFdvWl711sATiR1zVOEGtmTtdDSne62jaU/NX8DreUqhZfVoz4S3K
 inePXW1t
 i9aJAFF7EPsTm5nH3Seo4eSlnb+Cs/BYQ/eKNLJam3k2nSxPAmGH7S13NDRavH938Y1qq1skHpATaoWdaobJymSUc+hpzh6HKtXiQKdTasa6s1S/rZLEMTwMGi+xTUw7TjoY6yYfK2hqlRhu7dl/mdeSSsSPkYB075iK7SmaEk/rKkBwDfVVXPPPFlm3uSWnUS2fMJa91UxDhOWkQdLvcpdBp4BMBikLDLoOjAtkMcnc76cKuHkFxPwR+ywvppoMgTga/qHbRdnq7P/xfHaOBih4VI3OtRvt8rnz7QFycAkyZcp1DWuhSVpgubAFY/nvCLA1Gwr3HevBtrr+4Ew1TfCRV2d0f0q2VMJVM+IybvwJGBRw8Gc2IMtOb4VfPVvecY1pt23OWk/pN24EF1c07oRhmyZTq2DPOGlGwWGmBqq2qcFGTnwOZhfZJKYVwvGuT1Aof78z1/jyKHihJ7l7nI/Gev5cCkvrRbKu6Ex+swSIncN8WHQF218j6P+b+KwzWnTdzCVmk4NmXL+vcGNmDtqgzUbINTh7uKUicVClspZ+/Xd9v0Rka7bAw2MJjgpAPC66X+TYHr/7uMLF3QrAgUSVEDSVwk/lt+haIA6fRX1suYoU9N0eOwFvXH6qLyz+tUypXRXaZ0316U+xaM+X2Guq59SIl8PxjnIfa5uz+a0fvu2wXExVq+vyHZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

# TL;DR

previous discussion: https://lore.kernel.org/linux-mm/20250921232709.1608699-1-harry.yoo@oracle.com/

A "bad pmd" error occurs due to race condition between
change_prot_numa() and THP migration. The mainline kernel does not have
this bug as commit 670ddd8cdc fixes the race condition. 6.1.y, 5.15.y,
5.10.y, 5.4.y are affected by this bug. 

Fixing this in -stable kernels is tricky because pte_map_offset_lock()
has different semantics in pre-6.5 and post-6.5 kernels. I am trying to
backport the same mechanism we have in the mainline kernel.

# Testing

I verified that the bug described below is not reproduced anymore
(on a downstream kernel) after applying this patch series. It used to
trigger in few days of intensive numa balancing testing, but it survived
2 weeks with this applied.

# Bug Description

It was reported that a bad pmd is seen when automatic NUMA
balancing is marking page table entries as prot_numa:
    
  [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
  [2437548.235022] Call Trace:
  [2437548.238234]  <TASK>
  [2437548.241060]  dump_stack_lvl+0x46/0x61
  [2437548.245689]  panic+0x106/0x2e5
  [2437548.249497]  pmd_clear_bad+0x3c/0x3c
  [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
  [2437548.259537]  change_p4d_range+0x156/0x20e
  [2437548.264392]  change_protection_range+0x116/0x1a9
  [2437548.269976]  change_prot_numa+0x15/0x37
  [2437548.274774]  task_numa_work+0x1b8/0x302
  [2437548.279512]  task_work_run+0x62/0x95
  [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
  [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
  [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
  [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
  [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b

This is due to a race condition between change_prot_numa() and
THP migration because the kernel doesn't check is_swap_pmd() and
pmd_trans_huge() atomically:

change_prot_numa()                      THP migration
======================================================================
- change_pmd_range()
-> is_swap_pmd() returns false,
meaning it's not a PMD migration
entry.
				  - do_huge_pmd_numa_page()
				  -> migrate_misplaced_page() sets
				     migration entries for the THP.
- change_pmd_range()
-> pmd_none_or_clear_bad_unless_trans_huge()
-> pmd_none() and pmd_trans_huge() returns false
- pmd_none_or_clear_bad_unless_trans_huge()
-> pmd_bad() returns true for the migration entry!

The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
by checking is_swap_pmd() and pmd_trans_huge() atomically.

# Backporting note

commit a79390f5d6a7 ("mm/mprotect: use long for page accountings and retval")
is backported to return an error code (negative value) in
change_pte_range().

Unlike the mainline, pte_offset_map_lock() does not check if the pmd
entry is a migration entry or a hugepage; acquires PTL unconditionally
instead of returning failure. Therefore, it is necessary to keep the
!is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() checks in
change_pmd_range() before acquiring the PTL.

After acquiring the lock, open-code the semantics of
pte_offset_map_lock() in the mainline kernel; change_pte_range() fails
if the pmd value has changed. This requires adding pmd_old parameter
(pmd_t value that is read before calling the function) to
change_pte_range().

Hugh Dickins (1):
  mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()

Peter Xu (1):
  mm/mprotect: use long for page accountings and retval

 include/linux/hugetlb.h |   4 +-
 include/linux/mm.h      |   2 +-
 mm/hugetlb.c            |   4 +-
 mm/mempolicy.c          |   2 +-
 mm/mprotect.c           | 107 ++++++++++++++++++++++------------------
 5 files changed, 64 insertions(+), 55 deletions(-)

-- 
2.43.0



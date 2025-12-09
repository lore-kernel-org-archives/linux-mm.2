Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473FED3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D8C6B0005; Mon,  8 Dec 2025 21:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EFA6B0007; Mon,  8 Dec 2025 21:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7985F6B0008; Mon,  8 Dec 2025 21:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62FBD6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:39:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0ADE1160368
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:39:30 +0000 (UTC)
X-FDA: 84198376500.19.A63CFBB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id A08A8180008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:39:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TTcpJTgu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SHy58dTY;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765247966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46EHUEYso3D0AsWv2Gj6GoWgnJpjLuoB4BEdGnulKug=;
	b=L/fl/Rn/eWxRrxFx2zawSvIH5pmqX5MKCL3gz3Iu/uX6PgObybSFGVtOPfr/uanDhHkGy5
	Bm13vkGHcaY7sWmCIyjI1mvX3v2BlU7bnNzo6CnVTu/antT9HGjTvrQXewRrvIDQvEtQBm
	fb/Lgt5dKL58W17kE6Z4iljf+Zih6n0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TTcpJTgu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SHy58dTY;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765247966; a=rsa-sha256;
	cv=pass;
	b=FYMxKp9kzHjQNNElQZ+K1H49Q8DNSJrZidg9UxcvZgNLfSeyQELscQxeupS62ZkSb8BHSk
	POdzKCkaZB27Fhc//NVKAIAzAjVa/qyDtX6fUAH06tzpZy/V/0/1A/KidsmqS0e8Jp7psB
	Z6YKh2FyPvhAyZSWFyv/Lk39TNzAt4U=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91hK6G4052201;
	Tue, 9 Dec 2025 02:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=46EHUEYso3D0AsWv2Gj6GoWgnJpjLuoB4BEdGnulKug=; b=
	TTcpJTgujI0pRLjA+CvdvvApU81056dic39ySUz7MiECdxrvVeGHDm8/nYMX/naD
	jgXaI9igRbbmxgSdlPP5iKw1DuVB0QEWK1bKrmjGckiDIFiRZSOfeiTxuRo3bQXL
	SvboU3Voc9xUbxsn3R54UJdJ5nC3qf0sRnfRIj1K08h8tJRsMYTTDopLsYP/szr2
	jbwVR1QGbIbhN0dtCc8ptngNYKUaRI9tYC7QLFPJ0I1NswvdSjr7TiMyYQ5LqWkV
	BIi6zYn6EmDu1FPH2Qhs/4ufE2WIxQ8/T8piz39km++Hydh30k7raoHzeG56ZT4A
	mVUJJcNmTBGD9gMWVpFN1w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ax93604qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:39:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B92Lkkw039849;
	Tue, 9 Dec 2025 02:39:21 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011039.outbound.protection.outlook.com [52.101.52.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxja6g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:39:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i4YfAsqfU/pszCDqH8S9rMepa2y2ovWq3uvY/MqAbDGrph12yyPJBSaBw6B7uwRDgT5aqLu7KwJBLy7W88YCkunJpGoPz61Qz5qHSB3U8vKHAXw61uSAoGVxAK1p9NizPSAlOFkPBaBMQLhvGsEATvqjYm+Lxg9bjLAsGs0cJJG7mH/HVomOqyXK5iTW/lcAhf3pltDP0V0xqza295Pw9eZBvT+3ysdeqPzUZ+YanvAECghIKo7FC0+oX9OchQf3b/qJP10li0yFvq3Pvz1HQVTdkjP2ahwOUgZrGlCq0AwgfnQzKAbN+Aa9QBkxMsZH2u1EcZtyV7lMIIHlgDjFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46EHUEYso3D0AsWv2Gj6GoWgnJpjLuoB4BEdGnulKug=;
 b=H+WH16qwIDmVqEPAMf9t1apiktBv3XtFyZedAeJg04yalf4q6cEW4KB4euoyWlCARurtDy7sL1F1BfF/4lZE5MYXKF1agKAwCiL9sPBED/wTpn/xL/hwk6V8PWwk89h+ga+maqq1X7yS8UPi3H5jWP1JWs6LBGe0gknKkS9HuRorEFlWIC2kS/eRr7Xl26IiV0L+aXaC9+G6m3jMHZHhNkzljxP6Cfqz4VUGOFy8+a6eskW1nPhe8pDN6yalqIPMw6ZP3vV534YbWBJ8KwlEW1qDvWHiqzy70nHfR6xi6KpzIVYE34B7CSi/Ddnn9TyFRrPtsDZ2zCxycfP6cbHjNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46EHUEYso3D0AsWv2Gj6GoWgnJpjLuoB4BEdGnulKug=;
 b=SHy58dTYBvE2cOvaAD3WH82PJ7cy8MXLxuOCTtC5/BcGk73yotbHKtvujYVqHPIxCvsj82YuqxqLvpsaCmRk2wrgWm0orTKpwGIq8jQntyd8WR/cNqA1qcz3c9Sw+PoNngTA+5nchboljfxFIBFgMIwHHfcOi2/MPFQRn6mpOb8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6091.namprd10.prod.outlook.com (2603:10b6:208:3b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 02:39:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 02:39:19 +0000
Date: Tue, 9 Dec 2025 11:39:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <haoli.tcs@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: slub: add barn_get_full_sheaf() and refine empty-main sheaf
 replacement
Message-ID: <aTeLzFrc6EA2yTzk@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
 <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
 <aS_OrvHmgyhQzQIj@hyeyoo>
 <dq67tbm6bbvm7opvuq5vwtjjrcnrponmhfv7xwnvpv6vp3u2lv@bkruq4dtx3rd>
 <aTWIQ0s3EbOa0azX@hyeyoo>
 <8bbbaa65-2783-4006-97b4-a1628525e7c7@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bbbaa65-2783-4006-97b4-a1628525e7c7@suse.cz>
X-ClientProxiedBy: SEWP216CA0069.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ad079a-fa20-42bc-ad04-08de36cc26d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejlXNWVzRUxOQ1dMeW5UV1gzUFBKTWEySkNNYlhzOUhkSEVEaWpZeGlEWG1P?=
 =?utf-8?B?dFF2Y0ZtUm0rbWZ0SndmM2NJVzBTVGNWdTlndkMvdHB6a25aZ0FFWU1HVFd0?=
 =?utf-8?B?UjRCNmJjWnhBc0hPSWZ2SmdGNFVaQ3h1OERIbndHUGtWRHNzK0FTMjV2Mzcz?=
 =?utf-8?B?bU9tWDYwL2laQUkwY1dyemdQdTJaMS9lL1loQ0ZzcGMxUVVMY2dOK0lWSnZr?=
 =?utf-8?B?ODJ0NElkdFhxY1pwOUdqdHlpSm1tQmpWb0dJMFZ5UFpmUVJSbmp1SnVBRjBt?=
 =?utf-8?B?UnhkbVpqNU85RFowRk5tUEV5UGpyYWhqNExmbEhKOXBOdXloMSs2SG9qS1dP?=
 =?utf-8?B?K0JIVURmSUJPb0ZYWDk1bkwvamNkNDFzY0FTbjZqa1IxOGhHNlVZYWxmdDR0?=
 =?utf-8?B?aGFtWWZYaEI3QkpUeVlwZWg4d2lJTTd4T2tXNFBmVjk3TThqMm5LQTNKQ0Fp?=
 =?utf-8?B?OHl4aWxFNGtna3AvNmpidlN1SmxFNGk4RUFzVDh6ZFVpMytDcld1SGdScFdY?=
 =?utf-8?B?alJzZE9NSG82SFp1WWQzVUFxOTZmdkF0aER0NjY2MitRakhML0xWVnE0aXUw?=
 =?utf-8?B?dWVQU0dLRHBnY1Nab25kaU5Wei9RNHY3N1lIYXdOQWRySmM2dFA0dzg0eVdq?=
 =?utf-8?B?VFltOERidWlyZnpVR250QlU2eEFsemluc3c3TTIwMFpFSXQ1TkJGV3Fzc0I2?=
 =?utf-8?B?ZDdKYXN2bG15aWtwaTV6bm1LRWxLVGZnenk2Q2ZoamRHdWNhM3UyYnM5cnMr?=
 =?utf-8?B?SHJUbTZ2dlArZjhYWEszK0hpcTBHbktUWnIvQitGY1hVYndXSjF4dWhWdHU2?=
 =?utf-8?B?aUFQanlEK3kyWDdpYjJtNHdXclAycjVmc3ozTVh2cUxscHM1RldRVjdhOWxh?=
 =?utf-8?B?Nk40TVIzOTNhQmhBdUsxMnVqRjFOWnBBdHVkaXdLRU84N0F1ZlcwbVU3TEpw?=
 =?utf-8?B?eU5zZFdKVmIveWxwN2dQZDZGTFhYaWZQZ24vWVhMNG5uOEwydUJhSUluWjYr?=
 =?utf-8?B?WlJrVVJDMTk1aDBmTVkyY25HYzBBNFZTakM4UXlsWW5GSjdhQU9ZU3FrTnpD?=
 =?utf-8?B?T3U3aDQxMFBCU3hyb0dQWklwSStyZUZZcmY5MGJjcWlaa0dCNHhYa0VZTXc1?=
 =?utf-8?B?enRiRTBzNy9wQ21ybEZzcTZNbEFrT2xCZXVKSTFvcUFUcHZBRitTdkNLWkd5?=
 =?utf-8?B?TUllQXNBR1o5RGhGS2l4ZUIzd0ozWE1uS2VsMlZCeEVjaEdsd0ZBOE1ScmNy?=
 =?utf-8?B?NWNQM3JtakprUUs3cGdtN1kvcXFqMThROTlCRVhCUHdFSEVyWFhYNENKTCtU?=
 =?utf-8?B?c2dpeitXOWtjZkJWUDU3blhDZnpJZGhaNFZvYUdzN3ZMT05aMlhEaGRmam53?=
 =?utf-8?B?VGlaSGllSi9zTkJLMWJ5NHJlNW8zNkVENHdwbDFmcjVlQ3pzZmcxd0FnV2JI?=
 =?utf-8?B?Q3hqclJmbnZacTNmcmlOWGhTMDVYZTNMeW5RT2VhV1J4VzlKTGVJeU93aFk3?=
 =?utf-8?B?VXB5eHNGNEFxbDFRRzRkc3dyVzJjVGU1WDNidENGclIvSEc4V1JVd1Q2MlJM?=
 =?utf-8?B?ZXpqb1JlNTNTYXR1NHZ2dEdvK3gzR0RRSUhleHRDTVFSb2ZyR1dkT3J1ZHd4?=
 =?utf-8?B?QnczYXdtbXZyQVo2cXNCTW1jZFdjcFNQTE5sKzlpNXlXM1Q0azk4N2l5aU1L?=
 =?utf-8?B?anV1akxrcHh3TnRCTWZCV2x5M2kvSzlFUjRSeXlqOWFTMXd3MFYvZVc3dHAy?=
 =?utf-8?B?VGkwU09pNnNlK1Yzc2JjZG1ZazRBaWllWXNETW1RLy9sUUJMTWpnOExRQnpk?=
 =?utf-8?B?UlEvZm1Rck42VEVJdEZnU2ZFU3RRR3BCdDdFbTNDRmpRVkxqbkhxZ0lqcTFY?=
 =?utf-8?B?VjFlVERvTVVmUmVyZyt1NTdHRTJldjJ2V05odUhqVHNMK3dHb1ZsZCs5SE5w?=
 =?utf-8?Q?N8xGYn7Z3t5px8jvXwPjgn0+SThUhr+F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGVSVXRVU3VDbmZXQVdIVjIzamc2dmwzK1JwRWhqSHpveW53c2RqMTNwL3Vz?=
 =?utf-8?B?dzNkNlJ2YkhQWGRHUmdBQzgvbDhMcWZCdWxyMmQyV3hTakhNTTF5V2ZUUWNr?=
 =?utf-8?B?VU5HU0hrY01vWWpXalFlY0U3aUVmUFJXRnA0S3dPMm5ya3FQQjl0NGRaMzRP?=
 =?utf-8?B?TXgwU252cXpEb2tHdFRLeStmVVUyZlVFZTAxakJCSDNKc3BVclpDclFZTmxs?=
 =?utf-8?B?MkxFMkVCM3NGWXZBZEVmUzc3N2tKM0d6WW9sbEtzMW1lS0VpVXl6c1VKT3pE?=
 =?utf-8?B?T1lRUWNIV1U4L0drdjAvOFdLUDd1Qm80UXM2RmZlNStHR3RPSEQzcHFCMkIx?=
 =?utf-8?B?UGRsenFTVnk5cVVNYVBveUZHYmhDKzcxL2pPMWpVWTVIQUVMbG5kOXRoSFNm?=
 =?utf-8?B?YlBITFB3Q044UkRyVHdTZWV1a0RFUjR3dmQ0SC9DcGxkQTdudkNOdkh2OFZh?=
 =?utf-8?B?NzFBM2Y0bUo1Tzdzcjl4cU5FcEl5VzBjMHVvUWx6aUpKMDAzYmJxSDJoODNJ?=
 =?utf-8?B?dG5nL0lyK1loaFEyOGljK1RJYmhSRXBlWW1zbnl6bHpKTFZubVJyQUFONWdU?=
 =?utf-8?B?QS9pSWFBQ3hvVU9IM3NFV2FmY1dTTWxsTllDeEx3R29KamtYR1NUNDF5WUdL?=
 =?utf-8?B?d3pDWk9PNjFXOGdNOXBHMHB2d0ErSVU0bTMwMjI3aHF6SUZ6TGpkek5Vd2gz?=
 =?utf-8?B?ckFtVUFqS3BLc01ITW9SVGc1b0IwL29ubXZIeGQ4U3hpVjQwaUp2cDkzUW4w?=
 =?utf-8?B?bDkzbmxuclZUeXN1MGlJSkdiYWV6Rm5UcnhtQ0FhQzlqcUpqSkFlKzFEV1dh?=
 =?utf-8?B?dlpJeG1Mb0o5UjZ1bHdlMVFBWE84R2Y2bmVQRWR3cWEyWDlXblNhNEdmb250?=
 =?utf-8?B?ejJ1WDEyR2lHTSt2WUZWa1dTbDJpSTJKdG95d1dBcWNrdHZKL2hJZ2gyWTJo?=
 =?utf-8?B?UWlYN2pqb3o4S3pJQzgybGNSMDBCaXpnWXpiRDFFZVpOc2lkQ0p2TFhPZFdm?=
 =?utf-8?B?WkM5S2R4bm9kVEo3UlhxLzFHallCc3IyNlQxNGJ6UGxnSWlaL2VEdjAxVzV2?=
 =?utf-8?B?MFFQajM4RDlUSzZsY040L2pWOFVQbSs2R2NSQUJ3cFpSc1g2aElyWloxTGJL?=
 =?utf-8?B?UlRzd3NsNnBuMm5mNFRzT1EzUW8vLzdUejJQWS9RK0luQURQVnQzQW55R0My?=
 =?utf-8?B?YW5LUC9QUWlnT0N0dlFLRXhlazErUUhmY0JNLzdWQURER1JoK1dUdVRlNUJq?=
 =?utf-8?B?RWk4Y1hBWVJwME5oTDlMVGFvemVoRVlnOEhlRWZFcEttVDdUMmZFdnh6Si9N?=
 =?utf-8?B?SzlQNmxXaDcxanphRk8zUFVjdXNmbU1WbkdqYXBZVWRnOVdkYUhvd3VjZWw5?=
 =?utf-8?B?MWNsVlgrSVRVK3h6V1lFaEN5cGZFNzNTNkJNZEhYaWVHTEk3NFpjRHJDKzFQ?=
 =?utf-8?B?T0R2NHFxajdpa3dQdnZDNGdxRGk2enRaZzlqSWluTEpIdDRqLzFhUWN6UFdY?=
 =?utf-8?B?MkZJVmRjU2hvSGhnRjZPUUdIc3kzM01aZ0pXL2lUZzJFc0t2MFNzUXdKK1h6?=
 =?utf-8?B?VWZlMnk0bys0a2QrbFZ5UlBCUUVHa2c0eTNKT2twTFpjb0VtNmszQVlidEl5?=
 =?utf-8?B?RzNaMlJKRmdNSDMvZ3B2cEo4cG9LYXkxeXc2UEhIRE1NUzQ3OUVqVStSYk9Z?=
 =?utf-8?B?WENsc1o5NFhQVlk1azk1bGZ1NVpaNXBNamhQNTQ1bUUyNkpHMGVxVXh0S0tz?=
 =?utf-8?B?aXJ5eFcvdkZJQ25yd2hkdzJCamlDdVY0NFVoYktVRUZHNkhsWmxxcFN6Y2Jq?=
 =?utf-8?B?anRtRmNqUUYxeUFkcVRET3UvRmFXTHgzZ0p0emJyUzloTHhDV3dqckJCSmxP?=
 =?utf-8?B?emliQ2JLMlFzS1A5ajErUEpXcXZPRHJMSFNsQzJMSTVtVlYvU0c3cjk5RGZs?=
 =?utf-8?B?RW9Ucm5TS3BENzl5VVgxWXhxeE1FYkxKcTV1M1Q2QTlVK0NGeVNqZFdIN3ZI?=
 =?utf-8?B?dXg0UlFVaER1L2x4OWI2TXlpbExuTFZjWjFFZjlrZy9LbU5pckplQ0VlWnpy?=
 =?utf-8?B?MkVXZDNMOUNPZ1ptUnNQUXdBMVMrbjRZNEphQVhXS0ttc3gyd1FoRWp1aFhD?=
 =?utf-8?Q?zjbhiJUiMaLcHKXDDrcW5Snza?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JrLFuzCV9p05pPH5F5oh8ji3qdKWVPA+nZ6R1zATiAcvm+dI2DuLgPu2E490zpVZX6dTzz8YVwQjYaarowWApETG7Ful7FVWzr90lvfczrVQMszqms0VuhFORqsoj7y2luGzqE4dIoqC1NqEhpbIS5QQLaJ76U3VUqW9JW+xvPUAyyGbQ3D8HkGqbVOs5k3J1JIQfLbRdE/cX3ReNrIRf7adat1H9wNawnwPWyr1fBFD5PKppmy9LB63T+yIbWetjW9FqBfnIIZMaz2wGDNm+TFNDHsl9OHO2V4UewUHROp3wHW5Vp2dGjNZGGH90+ROKb94hSwAwClG/Ztmu9TrUKT1zSFGCluTLX4FLv7ojKhbZbkvGe+ep+2BatcCT6fx+B8U4USKMt/NvADogvxEtwDIFGQ4dFQHvrmjkjaPih9FMeF5ab0QZwAXabSgEACXHdahIl7l+QacwW2v5E9gXAJsqxcu6kG40yD69/fOL1u5d/9JwIrIxoSEyp2VwiSwjZ4nzMXeOTnMz47rQW+QZRn59BAbGT5J1p777YFEhH1oiSDZ+8uNLbZ3zue9GF94GyM1xsacX2ILY6VEHtftxnceQ/FORCWQ7I6oRF3EtWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ad079a-fa20-42bc-ad04-08de36cc26d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 02:39:18.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1E4kwTXDn+45DkWF8uI7A9R0Q5wIqnlBrHDD3bqP4AH9/iL7qD6heG+IK/lxJlwqVKxiKHsUaXKXi8v37r/x+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512090018
X-Proofpoint-ORIG-GUID: 1TqymQFpv3lACJgtGujUR59zG8FmdFxS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAxOCBTYWx0ZWRfX3Lx9NzvLHPeK
 5CSXNT0Hkke1Y+y4/CNSIcWjQaMK6FNRDvAAgjesWRUFq44XAEgsNWVnhZ2LcvCJOIqsBw2Y9XH
 cVPFOlGCKbsHoEykluN0ZNKhSSdMDLmIwIM9RizdeCWGz3TkYXLmKVGzxOVOLv4CB1hQS1RjH4h
 p7xfwks8LrTJnBDHC6oLMmu7LfJCyrMkDg1aI8DEYmkvEe+NdOrCBbTUdNK5dq/cnlONiVCJnRP
 hEV1bQwMsLGc6vjoquifXT4Qru5V17VtO1h5ydLaMyMWcYo2dizHuoBsII7InE0J1+2GriG9iqd
 ERg/zyAcHsVgZc0PcsvJodIyawCpczaNfprmQ54VMsVGqLFiJm+XDqcBgSHyOeLJFwi40MrEdpR
 qjnyaW8FtabLm7FyPu0u1+sjhjnUGiG6ftyIkhWbG2iSADuW0wY=
X-Proofpoint-GUID: 1TqymQFpv3lACJgtGujUR59zG8FmdFxS
X-Authority-Analysis: v=2.4 cv=Gq1PO01C c=1 sm=1 tr=0 ts=69378bda b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=LdfRBEMZlZnxmEkB0W4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13642
X-Stat-Signature: xegttagpybfmrh79u93g7xzep7szsk1j
X-Rspamd-Queue-Id: A08A8180008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765247966-394563
X-HE-Meta: U2FsdGVkX1+E7twRMO4vRK9DpPuJH1FUeOibCSuKJ3foaJWD7J7iQDX7IlzPUw9x0mzW6kVtxvGvad7Z/60w9gTsbFSmpQHhnTcotFmieCZn7guTB45gVbDrgD2eq7ieLteaW+WjHAAkW4CsWEiJosTuwKr6Swe2whmSrpmXmExHr5XbEB7np8ngqUgvec2ze3uLhwGHrzq/nHvteQaEdkaArwuEHADdgY6KtmyW67m6sqgS90URxnriw1eou4fZcmjj5nroB/nGNkOxGXgbFhe75sg4KO77A9uMsoTGm4fTpLLCIY3RXPjkP4XeC2r6aQXU/ghvJRLHheWQjn6eP3gxePTKVZyslr5aM+5HLPnIWUBT65jSvgGShQZnCuSK7k64AJrwHe4Un8kiW1qdnvfy5cPoEM3k4g9787O6dtJ0lCA91nTU9EtmIT4HCsBs6lVchEn9w81wFhDbp5rfRpCJkAxEZFiPcjZvsP/ZJIJrqe/P2rrkAyQCqwUwqQT24nDv+pWOYXj+FeYOGB8DIGLCA6f5v2/H+Gvj6XslDWIMwn1ceWOZMfP4WLxN6WKFtyag6/NCaV1qb0P/d9WxCqMnXm/FMv5NhUPMZZKzFyTD6YLzp0112pNp6vNbINAPQ+fQHch/qz319GAWiQEl56IKo5xf/5xWN9CqFOHQbgKhkl3A8QIAV42mHEo0fJmdj4fZ2/LoZhYxQEck7W9RUq5ciEd9cSyzXhR9/q1+R7RL5woc9f56RQC6jR0B9aJ3S+l2qKJMsSzI1uCZXB1hfQ/zXLC0T5/HsbqbfXp+25dDVnKSWTJToszf5EgFUZdf2J5dmIUd3DOsIso0z2ofBHD2EGClyPH7+Up8MLzFU1LAmF3wBT+smB2Q3Oo9thkN2HWmK+JUTlzDovbqDAy2qCbq+kzBWvdDl1cWYCpFtfbEFFZZS3fNi7LBLp121/nSGm8cNG62k2AkuA5T9SA
 eJ1JMVF3
 riWE490QfsASCFgua1W6Znnm5WQAHJLLAn5z0AliNiTvYc5jMsK+hmIzO3HsFT+mPjW52y9mFl3qgpWuFNMPxpDZjomigpBFY2+z7P+PEXWeb2/N4Qk4T4xPw/FNKbgfYhHfQIej5cpXiUPmo3w8QilR/nFqa3D0wlCfNPNB5UX1PvCE79LRuM7D5xZtEj9yVHheMvpxHceVV+8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 07:51:40PM +0100, Vlastimil Babka wrote:
> On 12/7/25 14:59, Harry Yoo wrote:
> > On Wed, Dec 03, 2025 at 07:15:12PM +0800, Hao Li wrote:
> >> On Wed, Dec 03, 2025 at 02:46:22PM +0900, Harry Yoo wrote:
> >> > On Tue, Dec 02, 2025 at 05:00:08PM +0800, Hao Li wrote:
> >> > > Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
> >> > > the per-node barn without requiring an empty sheaf in exchange.
> >> > > 
> >> > > Use this helper in __pcs_replace_empty_main() to change how an empty main
> >> > > per-CPU sheaf is handled:
> >> > > 
> >> > >   - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
> >> > >     full sheaf from the barn via barn_get_full_sheaf(). On success, park
> >> > >     the empty main sheaf in pcs->spare and install the full sheaf as the
> >> > >     new pcs->main.
> >> > > 
> >> > >   - If pcs->spare already exists and has objects, keep the existing
> >> > >     behavior of simply swapping pcs->main and pcs->spare.
> >> > > 
> >> > >   - Only when both pcs->main and pcs->spare are empty do we fall back to
> >> > >     barn_replace_empty_sheaf() and trade the empty main sheaf into the
> >> > >     barn in exchange for a full one.
> >> > 
> >> > Hi Hao,
> >> > 
> >> > Yeah this is a very subtle difference between __pcs_replace_full_main()
> >> > and __pcs_replace_empty_main(), that the former installs the full main
> >> > sheaf in pcs->spare, while the latter replaces the empty main sheaf with
> >> > a full sheaf from the barn without populating pcs->spare.
> >> 
> >> Exactly.
> >> 
> >> > Is it intentional, Vlastimil?
> > 
> > Let's first see if Vlastimil had an intention, and...
> 
> Hm I don't think I aimed to make this difference on purpose, but I didn't
> also aim to make the alloc/free paths completely symmetric. Rather the goal
> was just to do what seemed the best option in each situation. And probably
> getting a full sheaf and populating spare never seemed to be an important
> case to warrant the extra code for a situation that's only transient after
> boot (see below).
> 
> >> > > This makes the empty-main path more symmetric with __pcs_replace_full_main(),
> >> > > which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
> >> > > empty sheaf from the barn. It also matches the documented design more closely:
> >> > > 
> >> > >   "When both percpu sheaves are found empty during an allocation, an empty
> >> > >    sheaf may be replaced with a full one from the per-node barn."
> >> > 
> >> > I'm not convinced that this change is worthwhile by adding more code;
> >> > you probably need to make a stronger argument for why it should be done.
> >> 
> >> Hi Harry,
> >> 
> >> Let me explain my intuition in more detail.
> >> 
> >> Previously, when pcs->main was empty and pcs->spare was NULL, we used
> >> barn_replace_empty_sheaf() to trade the empty main sheaf into the barn
> >> in exchange for a full one. As a result, pcs->main became full, but
> >> pcs->spare remained NULL. Later, when frees filled pcs->main again,
> >> __pcs_replace_full_main() had to call into the barn to obtain an empty
> >> sheaf, because there was still no local spare to use.
> 
> As Harry suggests, that assumes a specific pattern where we exhaust main
> sheaf first and then we fill it fully back.

Right.

> But even then this can only
> happen once per cpu and then we have populated the spare and are very
> unlikely to run into this situation again.

Good point!

> Also it's unlikely that full sheaves even exist in the barn during this
> early stage when we would request them. That assumes cpus behave differently
> and some have returned full sheaves to the barn before other cpus have
> consumed their first full sheaf and request another.

Right.

> More likely both barn_replace_empty_sheaf() and barn_get_empty_sheaf() will
> fail and we do alloc_full_sheaf().
>
> And then... I think I can see an issue in
> __pcs_replace_empty_main() that's more likely to be suboptimal than the lack
> of symmetry you point out.

> When we reach the last part below "we can reach
> here only when gfpflags_allow_blocking..." and we have empty pcs->main, a
> full sheaf from alloc_full_sheaf() and no spare, we should be doing
> "pcs->spare = pcs->main" and not barn_put_empty_sheaf(). Right? This is what
> can delay populating the spare more likely I think.

That makes sense to me.

> >> With this patch, when pcs->main is empty and pcs->spare is NULL,
> >> __pcs_replace_empty_main() instead uses barn_get_full_sheaf() to pull a
> >> full sheaf from the barn while keeping the now‑empty main sheaf locally
> >> as pcs->spare. The next time pcs->main becomes full,
> >> __pcs_replace_full_main() can simply swap main and spare, with no barn
> >> operations and no need to allocate a new empty sheaf.
> > 
> > I'm not still sure that either way is superior, as it really depends on
> > the alloc/free pattern. If the CPU keeps allocating more objects, keeping
> > the empty sheaf is unnecessary, but we don't know what the alloc/free
> > pattern will be.
> 
> Yeah.
> 
> > So strong opinion from me, but I think it'd be better make
> > __pcs_replace_{full,empty}_main() handle it consistently,
> > if there is no special intention.
> 
> I'd rather see some numbers. But the suboptimality pointed out above is more
> obvious to me. Do you agree and want to send a patch? :)

I agree and would like Hao Li to try this path as he raised this topic,
if he's interested ;)

> >> In other words, although we still need one barn operation when main
> >> first becomes empty in __pcs_replace_empty_main(), we avoid a future
> >> barn operation on the subsequent “main full” path in
> >> __pcs_replace_full_main.
> >> 
> >> Thanks.
> >> 
> >> > 
> >> > > Signed-off-by: Hao Li <haoli.tcs@gmail.com>

-- 
Cheers,
Harry / Hyeonggon


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D49CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BDA6B0022; Tue, 25 Nov 2025 02:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C756B0023; Tue, 25 Nov 2025 02:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5DD6B0024; Tue, 25 Nov 2025 02:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 806C06B0022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:53:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB8EB5A129
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:53:00 +0000 (UTC)
X-FDA: 84148363320.12.AF7518F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 42465180004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:52:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OfX4ARna;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PLlE2sYa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764057177; a=rsa-sha256;
	cv=pass;
	b=XdYCL3R8DK3kFswZkmRB/C/m9uAK3iiFA4yGyWKWoZl1kLYaNlCng9+lFKk0dI1iRuUAVX
	1utBnp2qfOi6RoaGSQW/4kvZoxbnJpWmTrMKvdvCaVm1gaOQv4e/XY0INyFaB4l8dTEcjk
	jXc2RPbNgbWSovPg6/4NzaMzsDeLses=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OfX4ARna;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PLlE2sYa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764057177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1YXe7xRDV0RnLNRaODpihDidt9UjABcgftMEHriY+s=;
	b=2oVnh0D+ewV2l5fJCs1grYGMXnyfpRJUmLepwakzYVAwypjiJ/7o/6KQc/WmB+qhxEH3/b
	TotuekHPjlKyqG8NjTx68xU05G3+AXtbDqAnhM71eCq4w+ZparAlsTQ/iHWDdYHQZnpsco
	xemzwwq/UgYVH7UtRuSWwFJKKS37eK8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AP1ELVZ2434864;
	Tue, 25 Nov 2025 07:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v1YXe7xRDV0RnLNRaODpihDidt9UjABcgftMEHriY+s=; b=
	OfX4ARnaCkBsxOOWdRE8VLFYoa1svYhRhj4xrEpkXF3ezXNRUtjfQxE0KxXBdPcN
	zmo5JxqWn/KaZl43oyPcZTnZ6DaVaCuJ/+Ks2B0F74az1Dp6DA8kF+xiZvK8rL5y
	PFQCEqn1QExoH1DrjoS0EtedMsEp9tLbWr7Yucf19vGbmZrmI4kY95XlCTTCXZJR
	ghXHJ5lcolhQsd6fd0m//QACj+xXJCa6aVqCNlt9K+eelHLNy+sbMaQioUTI7beH
	gD1KqzhPG9rXTGMLVs/UXT5y8nMUbd5NvRbV9E7OwDxDdnBAGwJBxizPwdIr2QQs
	QiSKX4TSn4uQTLyYxLgmyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7ycbr10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 07:52:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP6V9Ta022374;
	Tue, 25 Nov 2025 07:52:29 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013030.outbound.protection.outlook.com [40.93.201.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mcvg07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 07:52:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+/qT3MSeiKoT2m04AB8/Qge9WoMY/EVf6NlSwc2qDIilx8LvSgI2WF8M+sB8+Lk3sWHDhauYASsGHRUui5KRIOp8ZFlBDguv33/LJayLhuf8vZc5D5dV4g/YNf7W9R17XYlMmzxGuI5Xpqe0ETFW7pi4PBQo+xf7dSxgHqj3dUsRIiA/Ce5btvuCrv0LxRMbzCi72I1nG4bYgSczgYT7zhrjyon8/7GWEMzBgsondvwPhUu+cIdge8Yk5R4Qt//186Oize5JHgO8uBaTU8iOnt1CMfr1Hwa0ReBW216iYUJ5hVHiFDUo51jK24s7wiSXUosenxAkGWlC9iBgPQdGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1YXe7xRDV0RnLNRaODpihDidt9UjABcgftMEHriY+s=;
 b=zCz3phVeBsVY1KXTa4rPo6IbErmvXcrS1UKHNVYNblMHHMGLfqyDNu5hJ2rQsCxbS8jVYqQLWwy/UP1RyU2cVDvaijEyDFvKrGF39+CqPuJ0SCu44Tgba6CA9PS88purMnJ39vlLOW0iJN1JxKgZ08JTdiSxK6o+8sJRMtt+IFgaMVsc7RlwHdbw3mU5Sqo59Q2TcKpwcCsOWi8SX7776cjpi7o32jHUBN49i1pG4i0Az2KWpX1WDoQCYvyIXWNI1sz88V1bub5arlU+i7cEmypzYSSOeUyCi4xtALIxGCoehwkn6E6Ni+dHI33xNzb3wuzpmPidOJRrQBTjDyFXdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1YXe7xRDV0RnLNRaODpihDidt9UjABcgftMEHriY+s=;
 b=PLlE2sYaHR5Ia5Q0/cLbYnG9y6ucKRFIpIpW0AEQnjVQHzEoDD0PnMZ6pc+XGu7+BKNucvHTMBM/HG/zqdPBKQNmlE/HqYamrDHfbOVB0vEberEDkkBLcoXlp5a9IBFtbib1AHGZe4dOm0z3iTrH0XH/leDt+cKChIbtCu1kvgs=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB997715.namprd10.prod.outlook.com (2603:10b6:806:4c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 07:52:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9343.011; Tue, 25 Nov 2025
 07:52:26 +0000
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
 <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
In-reply-to: <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
Date: Mon, 24 Nov 2025 23:52:25 -0800
Message-ID: <87bjkq8s7a.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0277.namprd04.prod.outlook.com
 (2603:10b6:303:89::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB997715:EE_
X-MS-Office365-Filtering-Correlation-Id: c59d2323-3e13-4d13-1f4f-08de2bf79399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjBTV1MrbGdrTFZhbkQrZ0JYSFJoYi9GRitrRkh4RVo5ZUNLNFpVd0xvYWRa?=
 =?utf-8?B?K2gxNm4waEt5VEdvSDN6WjR2ck1UWTRzUVFaYXQrbTNpRWNsSTBGeXU0MW92?=
 =?utf-8?B?dU1LU3YzcndXRXNHSlhsUmtzVHI5ejZWRE1kbEFVY0lVUDE0SklqbFpmSnFG?=
 =?utf-8?B?REcwbXZQSW1ZR2oraisrYTBpa2NHYUVkaWw0YS90T2FkUW1rdStIMHRaMDhh?=
 =?utf-8?B?U3BpTVZPM2paTENLMnB3d0xqdmNLOVpDMW1Mb0ZPMWxCbkp5Z0wzeWRPWFl4?=
 =?utf-8?B?WTJ3Ly81c1gvSjFjZ3FvNmNlMVMrRWc0QTlJN2NzVVVreC9TeGxJalNmekZt?=
 =?utf-8?B?ZlFTSWxvcUtkVUFDRUIvQ3RCWVgvSG9uNjBobmptWGhPT0prZ0VkL2F2dXNM?=
 =?utf-8?B?V2ZHbE9tNmRVT2JHcVVic1VIWjd0TWdaK3lyclo3YlcweG5YNk9yYjdVdW13?=
 =?utf-8?B?UjJOK1NTeTZkSnc1SisxTUIrT3FzaGMxRDhFL3pIcGJqM01JZ1Nxd1ZwWTJK?=
 =?utf-8?B?anA0RjZrUDQxODZlanViczR1MCtYYUxRN0RYamY3SDR2NElxMFpwbk1sWFR2?=
 =?utf-8?B?aHU4dHZMci84ejFnNkxtajNpZDhKUlFJVGhVb1Fhc2dvSkxHOHlaY0tFNHFw?=
 =?utf-8?B?am9Hb2s0UTJsbmxFbGxRQmR1VjNVSG1uTlFUQzB1NCttMks0bVI4MkQ2b3Zz?=
 =?utf-8?B?T1ZHV1lJYVR5bkVaNkRMNWN6RHZyMDc2VUwxS2NmcFRhYnRiWmRCOTdOb3ZE?=
 =?utf-8?B?a3BrRWsycEpUR2xGYTFVYVNUTE1Bd0VzaGJIUjNvLy8raStwa1MwWmVQZ1Ni?=
 =?utf-8?B?NmhtRmx2TWJFdnFhdW5yeHJMWHhsS2NKMVR0S2VudTZTcU9PMi9UeHQzUVRz?=
 =?utf-8?B?SDBKUjMxNFZJVlV4LzEzTHdBTGxLWnBDQW5OangxNEM1QXhNOGNpZGtpcUlU?=
 =?utf-8?B?L2VXb2IxNHFZT0VTR3RDYmVlTDhoa0E1UFVTbmwvdENCOFNpa044T1JqUnlv?=
 =?utf-8?B?K3ZUS1dPb3gzMU91UFFicWZUYkc2RUh2YkRNaEZtRi9zRExiSzh4aThMZVNJ?=
 =?utf-8?B?YkhHL29hOENBRzRpamtaNlhrajR2VEp3ZjV6RDJkVzJmS2tzZitySzdGWU8x?=
 =?utf-8?B?N2ZVNWpyMDhURzgzKzJNdFNXc0NhU0dia1FSZitPditnTWh5Zm84RXVUYm1H?=
 =?utf-8?B?M0xoTE9TOTdzbnN1bG1MN3hHamgycjJzbTl0UGYreG9TWGo1QXBqaEU3SHB2?=
 =?utf-8?B?dy83UVJ0UXBWTExtREFTRDVneFdVTHRORG1ONFdiWTk4dlY1dUhUdU5ueGVO?=
 =?utf-8?B?eVNaakdxS0FMVkJuViszdWlRc1Fvbm9RbFBBTkJYR0t1NFBNM3pkZ2Y0Mkx1?=
 =?utf-8?B?RDdEUFlJRTFMT2x2RGltZ0hHVTZZUE42YVVqZWlYQ0l3UVdqaEJFWHY5SFk4?=
 =?utf-8?B?UUlJOHdjNnQ3eGYvN1IrSGlNdGJrTktOb0pZWHNaRGxmVEx6di9lS3FZL244?=
 =?utf-8?B?N2c2VG10MHVzWEFBRFp2UzJUTHBMUDJqQ29NSElzOFZCYmpJMzhRNTRXbk1J?=
 =?utf-8?B?TUxYOFRSU2dqVVE4a3BrZzJuVk56WmpFRGdwbEQza2lBMzlNeEtwK3RBTzRD?=
 =?utf-8?B?Vkx5ckRmTkFYYXNwbXhGOUpMWTdFWkpJRHEycWtVTVArVXhVRXpnUnUwUDU5?=
 =?utf-8?B?ZXFIWUlYZ1dTTTJsZnlucE1vVVFDWlM4aWtQWStSTXFzSmZ3TktqemdGYjRP?=
 =?utf-8?B?Qk0xMnJ2M0NDSWU1OW5xeWc5a1NxOHA2MGFuMzI1Vk9lYXBlOHMrUFRBWmph?=
 =?utf-8?B?L0VJVDlicUhGd2MvV3N5WC9Ib1I2bDRWVEJFc0MrMnd0NERWRHVYSE44THRF?=
 =?utf-8?B?MHdLb05idmhZS3ZGYnF3YXprV3B4L0t4U0RoK3JLMVp6NkM1aW9rcWVQeEw2?=
 =?utf-8?Q?47taKsCz0RhRlbkSTRT2bcjlzCYWQ1xG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmFQckhmaWQ1MHhxSmJZZXRldlp3Q3JiemVMSllSL3c4YTMrSDJSOXlJMW9j?=
 =?utf-8?B?QW9FTlFiS2ZYanE3eUNwdjJNWk5IK0ZiQ3h3R0tzNG1iMGtLYXFHYWg3RVBH?=
 =?utf-8?B?dXZZZVhqVTlvMnpiUmp3N3BBVkkrVnVLN0J6NFhKYXFyNWZBaVcyVTg3bXpN?=
 =?utf-8?B?U055eUJPYUcrSlAxTVh3ZFNRQk5UekswbDdIZCtrZUJYT3NXQW1WcjZZMThU?=
 =?utf-8?B?N2VuTjQ0c1c1S1k2RFFJYlo2a203Tjhsdyt0VStGaFhsSTNTcURRMEN1dGVW?=
 =?utf-8?B?NFUxUjdyNDFWZXhVWnVxaVEybjZQUHkwY0RxTDBkSFYyVDd4cVd5Y2ljcENZ?=
 =?utf-8?B?dGZGNjhFVnZHQ2tFeS9lTTE1NEVUMEhLMFJReVJrSGlvUUtsd2F2UnZNWGV6?=
 =?utf-8?B?LzdtYUEzTzN3Z1MvQ2tHdXBBSjBRQWdob3J3KzZib3ZjcVliOENJVWNPdEh4?=
 =?utf-8?B?ZDMrNW40b3dKVUFPNURDU0lNclRZejBLUE5SUmNCR3NKRmkrQi9uMWhma1do?=
 =?utf-8?B?RmxrOEhiUlBqZWJpcy9yMzBibTFwK0Z3c1V2bXpMVXpZNmxTajczdEEzc0RK?=
 =?utf-8?B?Z1NaUWxvb3N6SFNRcE1wejNEZHE1R2NmeXNoWXpPUTFxa1Z2eFRJU2IvUGd1?=
 =?utf-8?B?ZnhYb2xtOEpQS3BmRExaZXhtUEtkZHpZSDc0dXR5TDYxN2JjTlhiMG1CNGEz?=
 =?utf-8?B?dkh3QjlyUVYweFJYd1lPQ0JEQjVBY3V1SkNZcXZadklpdDE1V2w2N25rZ0Zm?=
 =?utf-8?B?dzJnaWpvTGhPcHJDV1BvWjZiZjZidFhvQUxJZGFWb2Njd3h1RHVCcEMzVyt3?=
 =?utf-8?B?N0NRak9xaFpQT1puaS9sZGRYbit4MWw5R0xzT2lwbHZ1NndDaXpsOUd4SURW?=
 =?utf-8?B?WUlOZFB4a2J6MnVmdjBRbm5PRWtOR2Q3Y1VqaVJCSEEwK205Qjc1bFplS09l?=
 =?utf-8?B?UU1HQm4zQkxPVFZJM0ZWTEY4eWpwMmFPb2pUMThmRWhtcDM2eHhQMlFnM1Jv?=
 =?utf-8?B?S3l0cmhodzdZZTJNNytrT29jS1FpdzZhZ3NzSmprdElTeFJxTkFXa3NCemkw?=
 =?utf-8?B?RXhHRVlZYkwwSDlTYVdjYnJyY0hZdmtRRnUxSTZtRzdyenArNGNRd21jZmIw?=
 =?utf-8?B?dVdCaS92WEtVZnM2cmV2U050dWFvUUpEMlZMY1JkNVRDTWtyYk1KQWVpcWhE?=
 =?utf-8?B?K1k0WU15eGd5cStNN3ZvR2pvYVo4d0FGcXFOcU1ERFVNRlgyWHhaRkpuKzNL?=
 =?utf-8?B?RGZQdFpYYzBnS3dKUHkzNkVUQmFNcy91TGFWZEYrMUZIZ1YyR3U3a1RjaVRM?=
 =?utf-8?B?RGh4RUc2dnp4Y3JhTmQ0Z1ZuREJJNEUvZVNSS2tWcnlVUWRvZTU3VzdmU09o?=
 =?utf-8?B?RGxsSzhXdnRjZWY0K2t2dk03aHgwR205eWhndGh4eElQUjVsVm9YS2YzenZt?=
 =?utf-8?B?NTk1bXNDd2pXaHV4ZE5OSGlIbitRTGhmeit0VVJWQnpzMG5EMnRtNVgvejRs?=
 =?utf-8?B?TlNXWGtjMGxDUHBZaTNkcFJuRy9TZHV0TnRYZFRBU2w1K1pMa25xZFFJeXRw?=
 =?utf-8?B?TEd4ME1OVUl3bUpOWUYzWnVpN2pFaUpzbzNVOHMvL25KRUx6TGF4QWtSNGpy?=
 =?utf-8?B?cG5hS0RCamFiQU9zeXJINTMxYWhJYkl0N2RHRXhQVkwxMURNZHNQOWtKNFNC?=
 =?utf-8?B?emt3b0FPQ25qR1FHS1VUakpNV1lOV25rSEd5U2FzZGN2VWtFUkFva09IUnVj?=
 =?utf-8?B?MUt3RGs5MXMvN0RZenl1NFpJdUhFMU1BUkJCUDQ0d0N5U21VOTYzaENXSVVl?=
 =?utf-8?B?WlZSRVhrRnMvcFlxckE2RXE0RVpxQzVmQWhwNlJJczI2MXJDY0FXTUx4ajJq?=
 =?utf-8?B?ZThsNGdBY0FoakZDTDJXbjZObE9HTzJoVjJ6REVIa1ByZ1VqRWRFOVpKSUtW?=
 =?utf-8?B?cDZOMHd5L1NIWUw2RnllSGNwSGZaWGpDN2lSaWZ4Z2JabHZNYk80SDRXZEho?=
 =?utf-8?B?VURPTVNNc0FmNVVScmlDeFRKaW1samFtYmJqcTVxRVpEU1cwU2tzVXFNRHlu?=
 =?utf-8?B?a1hkZmlldDFyNlY0V2VRUlNxbzZxcGljM1lSc2ZpRENiSjJnanZkTzMvV0x2?=
 =?utf-8?B?MFA0czhvL3NvandTZFJnYjBOUVRLT2RuN003UGVLcEFSUG1od3BMbHh2QlMr?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G8GglqmKTG/TOMrdAczK5zDfBtGL+5B92ju9ATQ128NSUvF6rm3OXs9Nnh8fgFGP9wr0eNkdlfA2+TWnxXm6U/TyGH3ZFtQ26LTZHyzNF+jtV3kwx6SeduylcRELz2k+qvOXHb+dUJyHmvburXLJZxArP2JzHj3R1vBx9hFGBPmTStAbdu388gfFXnwhS+b5a0RWRbIJn90Zo1SZJzFuie4cDGpWNsVML2Y+mpKG4TcsRsr/q4HjB6cglv9Qk2A7fd+QzU4EcwT7Sp4fBruBrxGpZUlwTuxSorTDGjnV8+iKKn9K556BREI1mJ3XEDUlUgJDAdPJs8yIpQQHM6qJNGmN/2LDAybZsD44o/dulrqCZJcGLQgDe6JFP6hb3DZESv1hHF/iU8fATCh8zfi20LBjBMJNDLGlzi/iDv10bqZm+WTYk74LcpfJ1XjLZGptVZB6prngHAW3B0iKXDNiBiK5DvOz++EjCqcqi3LU/EPsa5XxdN6cTWQadZTcCODY/iJ8moVwfe0RxeYaz4IIUg7Dhd/KtV9FYlYUlWceMMNft+aeJWRYK5EK77lmHQO5Zdnx1vQRQMi/hn+QBvIPlHBTbyE0DUJ0LJOeNMOcZpM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59d2323-3e13-4d13-1f4f-08de2bf79399
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 07:52:26.9190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JU3A64ZTHm7u3x07YrDVcFRByfR+vJEjMyHHKQkW0Mze19Qed/QTER28SJ3pCuc8Ao/VsMMik1Be6kDje3+fKjlqZNhglZ/1s0YreQUbZJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511250064
X-Proofpoint-GUID: t_pLE9Vc0nmvEzkmn61hqSQtiF4LhaJP
X-Proofpoint-ORIG-GUID: t_pLE9Vc0nmvEzkmn61hqSQtiF4LhaJP
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6925603f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=ZvfaAmBHD3LUGJ_P2gQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDA2NCBTYWx0ZWRfX/eJiaWIc7xIp
 d43bYlF8wSfs1+2dQz9QP5GpCBdBSlU44B87TmMNnHJ8szqg9xQ6KDbA6isi8rSwLJSTJdnrPRo
 vweTYhy8/+DGL5VSLoW/1IQwG5EFRqERQXzniyM6Tb6u4zSTcQJVl+37YJS5LvIH+hMunDtyPb/
 Mq6ksYlHR+j61Nm2g4lMCY4zmIZf+THVQRzkMRYG+xAsmuyxuTnXTqjSjrDEx2AYGHXCiEyzC9a
 P7QvrIivGtip1aklXA/sz5mqk2ZzHsErLK1wfX3eny3Y0CBhvMVuFeZOkucO4NzvZGKpPTgJpgy
 LW6qTJz+yY0sMDm5Q1GUUzDt3OfnncI67bB4+YkYj//nhC5+lAcfsi/6KhYADpLM5NSYgk3ryuZ
 sVV5NR0J2Wt0egIWDNOu9jkTslMMI7FPYBOVtnRVJe9IyibxEWI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42465180004
X-Stat-Signature: 38kwpao3xefgexkhfi99d4mam3mz9rw6
X-HE-Tag: 1764057177-516670
X-HE-Meta: U2FsdGVkX1+GS1ENVFrmoOvflPzSs8DZmrUDTOjZXewXk1RmvS7EUsxn5z+e3UpbKYSCLgdt+0VuBEnlZ5v5ZbEfZi5Gf47GGbQrQQlZuJ5DzOaQ2I62l+q58zDweaiON18H+Eb2/OSSIPe9GnMssrGGQWZbMOJbBgNwZLpFKvHFytWVtfQs1waq388DhifeXqlbeoDl3fi/OlkD0UxSDGSCgPy0Ed/WMy7dwgjTbSTtVPwp1PWKgR45N3xpSjgT7qr/dQbyJ1WEx8awab2PHXj2X+0qhlY5ZKNJkOMR39AWuP1MoDXXPyQte9eWQKsYSmF80YTbn/zRxUxaHMeLBhHLSuYpEG7daW6Hp/fXF9Sj/gZ0uaxOXSyUWnYWqJPo/yQh7zBolxJNwyO8/66K4XaDBrL+YTVC1Zyf8mt76SWpj7HacE7s+cB0DCjJsvWtSk27Pmofecj8jzSx0BaBq2bmmjRM0Gq2K09lpYbnCJvMpCtRrcukx+3EIKjyynFxGnLkMXCLaQXCAP8E08G3/mk5ZOH+zwWziPxyMImJKG9zjsQkKmRMYmUkMbYxoOtVT1ptzjZO6leZSbjCZbNRAWTPhryDMK+Oq4YW4g5pLmAXNGFn+fGQcnrh7dAHAWvI/gBP8WMVFnaIDEu9Kq+aMHBdN0cbhHvNg0EDolRSd9Hb62kJjneV6LgDYB48uxRfEm8ke5uWPT6LdDfTfO8rRmxhNOLecxy9PrqVf212yGp9Gd7FAhgFwcegpbn2by0hqxaGvOS+BO30ThNAVWs329YV5ndIJ1K5V5lxYRSTR9s4ELEF6sjsIQHbGCc/DeumDYzTDsFhS8P/eGpujKyInIXp8Or8UGQFoGWRd+Yxnta3OWVrPRMpnOgcXiUvln55faVbOAKkVkS0yT/lHy2gsLv/GO/pwWpFtdurcLViyEQnxmM4EkZM56Dh/MTyq8ExB8x758m0xJ2mpcu6Hid
 nfbG/2pu
 ln+f5pBAPDdI/luxB9Lzb3sUE081S6w0B8FWb2XRryzh884xe3kzxOqAK/EomOXJcqmVHnZlwYs5CVZfNuW8a7B9yBD1jVEsGjpGc7/Jyq9cMvZIWL5TYxAdiixOrLHBjxnHfvFbdt2o5Z/lrGgVwMUAgWs/4potf8rlQNGiExjNeJ33ih0c0x8kM9GwIDBEqxH1weiam9Ha/AHu/qo095/qXtOqxcKXDz4qtD8Y+ACcVw/nJZvtjb5ERE5wInPW+2NwZzVpG0+uMT7WmTJYcBVJzM2/PUjHBcS+UJjaEseEcyppSyrhD96JJ2D099mfGWPRYy/RBa0zga8pDJUCnyQ56Vi4UQNRFeFsop67nFA6FRjg3ReBzZk0viPQJ613nWc1r5VAC7+5BN2cWKpJDrz7pWzKnMUXS+ezhwOyxn/GTfWN79YlNCIqaiyR60u2yFK1r15Ffv6/zjZfhZF8IMAftvz7vTziSTG4qKMr1WIG4C+2MR+01sKfQgkw/XjoCPMazIjWUZGBolLAAO98yxI6WjX+FRmgbKSyN2slHX2EOItCIFlLQzASHUY+FI+7k8W2WvNBESYsBY35Y5a6AQKxkQhvmzR5fkMOqj6apWbRwpsaDAggAFWtV5+b1+gcRBGTUgUHNXfbvFVFMXBL9pXs1tyF7nQWvZ+aRnqCcWQNNn9/fYqOMpW0mVPW+dc6JFZbk7deJdRswgTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 11/23/25 12:53, Christophe Leroy (CS GROUP) wrote:
>>
>> Le 21/11/2025 =C3=A0 21:23, Ankur Arora a =C3=A9crit :
>>> From: David Hildenbrand <david@redhat.com>
>>>
>>> Let's drop all variants that effectively map to clear_page() and
>>> provide it in a generic variant instead.
>>>
>>> We'll use the macro clear_user_page to indicate whether an architecture
>>> provides it's own variant.
>>>
>>> We have to be a bit careful if an architecture provides a custom
>>> clear_user_highpage(), because then it's very likely that some special
>>> flushing magic is happening behind the scenes.
>>>
>>> Maybe at some point these should be CONFIG_ options.
>>>
>>> Note that for parisc, clear_page() and clear_user_page() map to
>>> clear_page_asm(), so we can just get rid of the custom clear_user_page(=
)
>>> implementation. There is a clear_user_page_asm() function on parisc,
>>> that seems to be unused. Not sure what's up with that.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ...
>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 7c79b3369b82..6fa6c188f99a 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone =
*zone, struct page *page,
>>>    				unsigned int order) {}
>>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>    +#ifndef clear_user_page
>>> +/**
>>> + * clear_user_page() - clear a page to be mapped to user space
>>> + * @addr: the address of the page
>>> + * @vaddr: the address of the user mapping
>>> + * @page: the page
>>> + */
>>> +static inline void clear_user_page(void *addr, unsigned long vaddr, st=
ruct page *page)
>>> +{
>>> +#ifdef clear_user_highpage
>>> +	/*
>>> +	 * If an architecture defines its own clear_user_highpage() variant,
>>> +	 * then we have to be a bit more careful here and cannot simply
>>> +	 * rely on clear_page().
>>> +	 */
>>> +	clear_user_highpage(page, vaddr);
>>> +#else
>>> +	clear_page(addr);
>>> +#endif
>>> +}
>>> +#endif
>>> +
>>>    #ifdef __HAVE_ARCH_GATE_AREA
>>>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>>    extern int in_gate_area_no_mm(unsigned long addr);
>>
>> Isn't it chicken and egg with clear_user_highpage() in linux/highmem.h ?=
 :
>
> No really, because we make use of clear_user_highpage() only when the arc=
h
> defines it, so the highmem.h variant is ignored?
>
> Not that I particularly enjoy this way of handling it, so something clean=
er
> would be nice :)
>
> (in particular, relying on highmem.h defines in mm.h is a bit suboptimal)
>
>> #ifndef clear_user_highpage
>> static inline void clear_user_highpage(struct page *page, unsigned long
>> vaddr)
>> {
>> 	void *addr =3D kmap_local_page(page);
>> 	clear_user_page(addr, vaddr, page);
>> 	kunmap_local(addr);
>> }
>> #endif
>> And at the end this function is the only caller of clear_user_page() so
>> there is apparently no need for a generic clear_user_page(), at least
>> not when clear_user_highpage() is defined.
>> I think is would be simpler and cleaner to instead add the following in
>> linux/highmem.c:
>
> I assume you mean highmem.h
>
> It's not really highmem.h material, but if it makes things cleaner, sure.
>
> Might be that the compiler will not be happy about that.
>
> @Ankur can you play with that and see if we can make compilers happy one =
way or
> the other?

This looks like a good change (and from my tests on a couple of
configs seems to build fine.)

Though clear_user_pages() is also only called from clear_user_highpages().
Would be good to treat that similarly.

(I don't think it can be done because how the arch code treats
both quite differently.)

Anyway I'll play with that a bit more.

--
ankur


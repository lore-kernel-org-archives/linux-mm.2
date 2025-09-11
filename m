Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608D7CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9038E0002; Thu, 11 Sep 2025 07:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FEE8E0001; Thu, 11 Sep 2025 07:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740B38E0002; Thu, 11 Sep 2025 07:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE038E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:15:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB06413B070
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:15:05 +0000 (UTC)
X-FDA: 83876712570.10.365CC9B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id F21594000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:15:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="G/lOwXqw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XmT0nKrp;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757589302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1k089R4TANqmsL3guryj7rMJBLNHbjRjdtMi/wQVUsw=;
	b=M4CI6FiI4yDAKjacBN/icFVakpB1na5sK9U/wKEeUbryNhkY6TjIvXHhlMmcBxe8ritVlZ
	UxLwE8KeJKDBu5WTdo1b+0YwNazqEaZ4fzH+hr8WVANLHnSd7/9QZGV6yVusy5DvgEHcXW
	+JfPH95XPWm5NJgcaOpZXtSyJ74KpqU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="G/lOwXqw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XmT0nKrp;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757589302; a=rsa-sha256;
	cv=pass;
	b=zBPf1T0cdvjonRmsmdkyEUXO13Ou3QG2nYdStbTdCeq4bXOOUo+3MHHueU3E1tHm5sniBQ
	b9FO0u6S5YHKVJM8Xz3s20vB/agW8YLRg9y3QXRjg2ow6jlInUhgrkTmrurCdsw+rk7L/B
	8hz7aKIEeyIoT02K/aN1o9h0i+Nv6Q8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8fxbu021315;
	Thu, 11 Sep 2025 11:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1k089R4TANqmsL3guryj7rMJBLNHbjRjdtMi/wQVUsw=; b=
	G/lOwXqwB2henl9pfcxSFJdldmHfXuEyAHrjYpGAjttutKeT5KbR+msNJdS+Ow6H
	+4+N5fReWgUA3xD2oxrsjQbQQGkxo6XwBp3ip2uny/zDSm/qSWqzZc58jf0aky3K
	Tepqal9PYFWriGqAfP30rkaIXgyboWWCjh1PCsYd1uNUW4PGU/Ep1KVK2OTlereq
	UfeeP9kzjz2oTpSdWEEZsOtXSswxi3aPl0iAgAgsN0qflIUBX7nR11PUardBIxJx
	R0iZajicDL+mhdZq8tzLmI6CgdcTcHyFsLlzj/G2glSXClxnRfHFrOKp6igD8bly
	U09kQv6PTU4PmvIOKsNckA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1p626-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 11:14:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BAGK1Q030914;
	Thu, 11 Sep 2025 11:14:36 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc92t4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 11:14:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvsJkPFnZ+p3GVXFYVgqh8ddwO5OsOCCrjlFCOsQvOUHkQ4PXcLjTLYY34pvfINaRB3zd6PkZ0GOmknVHqizYIEnv0yUPh5kfwWlrx9+NQ7u8U8AtTjvKdAG84qqUW5uwYGhiHHMquPiZJCWGazEkN48XZlKKex1GCmIdMEKZCqRFzHB0hJ5DyuPq55OuKsdp/d81d+1mzSSJ2VqXA5v5NH76fA/92f1T5WxbUx3JixyyQ+3jQ/iv+Tk3tUHozOZy0zPWHNYdIjOY46BR1+ayNafKW2A6jzCBXLJhF4YvwrFjvN1al15+CPmKN4j8sY4wJWSlMUveom848AIu1KE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k089R4TANqmsL3guryj7rMJBLNHbjRjdtMi/wQVUsw=;
 b=L/CB/ZReYfZZG3fnubDcIAy0CFmMNYVwPwoBIbZySNidujzn5fNiE0TMTLP4EUtiQFPfzO9LOyFgf3RY/n24IpGPcAY7m4/tPljkYz4sRPzHpNwBovtLrm8inM8SwDHtDf/x6/wvcPfsJIZm03ULRZALEIuqWZoz++wqkDYpiUBQ7a5rVl9vVE2RTxupdPt11aX2Rsclsm7b1E3HJ2uGbJOCfoTOR93k0xKdp4kBUwiI2vxIC4Ef4MWi4ybg9lt+0zgN1t0KE2v5sBVc8LD8OIgsNlnikSAr2YptdlxI0iU9SnfJyPmGrGQ0WZoFHrfpgJdaA/JgCXNxZ/HadM62gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k089R4TANqmsL3guryj7rMJBLNHbjRjdtMi/wQVUsw=;
 b=XmT0nKrpbiT/16/2KV/3yYAoMYGF/No7629FK/zHJJ01iR73Xh9zxMFx8qaaEmNhEB3qCdg9/AUfyJ/YYmfyiT5B9t+s2kt5o7hSzSgKJJpl9ap/1I42fkkdDDO1y7LeOW0f79mqOK8yJaLfUcjOQEtJYd8clZBeiTFtp9pLIWo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6848.namprd10.prod.outlook.com (2603:10b6:8:11f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 11:14:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 11:14:32 +0000
Date: Thu, 11 Sep 2025 12:14:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
Message-ID: <d090c532-cdbb-434e-b573-c90a98224e27@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819141610.626140-1-npache@redhat.com>
 <69e9c0e9-25bb-4ff6-8469-d9137a5e5a75@lucifer.local>
 <CAA1CXcD+E8kSA2P5JchayQb5wrwmUVPRCK+W-qiD=Xtz03ti+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcD+E8kSA2P5JchayQb5wrwmUVPRCK+W-qiD=Xtz03ti+Q@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0066.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:8::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6848:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd48a22-5fd8-4900-92d2-08ddf12461f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1hPS1F0WFV2Y3pySi9Yd3pEQUJqQmVOaWU1UzFwamVjQ2g5aFpHazNhWmQz?=
 =?utf-8?B?RmRHZlcrd2ErdzVvRk9LZFBWSmwxT2ZyS3J0R3pmTUJjS2ZyS2NLTHk3UWxk?=
 =?utf-8?B?eHhQWW5Zb1JGZTNwR05zUE82UkRVYS9rTkowaWFTWmtTdU5zRzU0SFhGeThL?=
 =?utf-8?B?SDcrdHQ0TzJ5TW0xRktodGIvcXZUZytYQjVsemZrdnk1LzB3dHB2NEo4bmVt?=
 =?utf-8?B?UWhsUENZVGhxYkFCVi9LbzNka1pKS2FJSGcxZmR2WjNSenQzNFIwTFRXeFhU?=
 =?utf-8?B?NUFNb2YvMktVQzJoQjJ1YisyM1ljUzBQUlZrS3VyRVAySjVabU1FMlRIV21X?=
 =?utf-8?B?dmNnS0VxZlBkb0d3UGlOSGVKbFVxNVR6RnYvbWYzR3FLU0RwVUZQYmEvcGhB?=
 =?utf-8?B?Z29mUFZ4QVp2dEJIVmErRDRkb3pIeXlZWGVYRmRXUXhMMjllVFBpU2MvbnJq?=
 =?utf-8?B?cy9BcWt2cUxnRzYxbXQ0TDlNR0dZRzJNOGV3YURCT3ZGSFB4QnZYWTN6aUUv?=
 =?utf-8?B?ZEtSMmdYSWs5czhseC9HRGNYcEVNOEVNRHZOdThsVFlQUC9WakZZdkYvNkdZ?=
 =?utf-8?B?cWY1SnJqMy9NbGJYemRZSTdDRmlOU0haUTFVb01rNUIzWWRiSW01ellHOFY0?=
 =?utf-8?B?cTVDYjh4ZkU0emhWeklCUVU1OStRM2UzTEliQ2FucHprZUdnU0NoSkZRellV?=
 =?utf-8?B?blFYQysvd2hiUGc3cnEyY1V2Ri9WbGg4WlptZWZpRjNTOW82TU9ERDBoSnNO?=
 =?utf-8?B?a21SVkVrWXFCRUxHSWZWdVk4T3M4b2tVVmdnalg0cUhzUkQ1Qmkvb3NHV1l6?=
 =?utf-8?B?dUlyUGMvUk1VeEhaMUxEcjFGYVBhQUVOQ2VINlRSNUZjZjJJTHR5Y2t3Yitu?=
 =?utf-8?B?dWNXM2lNVVlscVJHNlRyVUxoYUdPMUhTMllKVHlPUkJHWlBZVENhZVJ4eTE0?=
 =?utf-8?B?ZU5PS3NKczNnWHpETmdiSlRZeG9RNUFySVJ3ZUNqVEtybHNvcXpIWFQ0K1A2?=
 =?utf-8?B?QTJtcWJQOFU5QkszYkdoL1lHeGZZSzkyTFdzQ2ttQXBrdmdFa2xnZUhZaU9z?=
 =?utf-8?B?ZUFpSXhwMkcwMDlVMklKa1FYemNYMWNnV2w4YUVUQ1ovc054Tk9DbXd3VTVa?=
 =?utf-8?B?d1Y4V3Q1TFNZOWYzN2FIYVZ4SG00Q0xQamlpZnlNR3dOUVhZMlQxRXlIQTFL?=
 =?utf-8?B?NXFQUklQdmhmNG03YWpEUjZYSUQxdDlOcDB5RFVaNUFSTHFCdkVYUHoyZml1?=
 =?utf-8?B?NlBXeVR5QVZqQ1l6cWNJdjhmQWhuZTJJK0pnQVF5VWoxbGl3TnRoUG50ZUdZ?=
 =?utf-8?B?L21OMW1ESlJrek1JZDJtU2h0N3BBbjY0REw5TnFtZU1XcENhb1laUGpvUkVW?=
 =?utf-8?B?QUIvTFZnazh2c0xoVEZGdzFZM3ZwenpVeUQ5MXdPMmd4dFc5YkZyNUt2UWsv?=
 =?utf-8?B?RkhYMmJQakZOZkY3Q3IyMldBT1dKZklsbG13Q24wdHdxaGxjWCs1YmNUZCsx?=
 =?utf-8?B?UWx6RnlCNUxZMFIzZEFSanBobm1LdVZuR2hsQTNvZERidjJaM3hLRHYvR3FP?=
 =?utf-8?B?eTR6Qkp0L0Z0UmVUcy9VbEMvcGh5cW1LS3BHbHdpSnB4cEZTdUZXbHBGbXg2?=
 =?utf-8?B?T1Fhc0dDQW01cG1JWG05VW9qYkVzRHBlbHREM05POG5lSDAxSDdhTVhlMUxH?=
 =?utf-8?B?U0htSG5jbVVwM3NVQUpvZjRoRHVZYVU4RnRDMDZBU3Ywekd4RXY4bFZlbkp0?=
 =?utf-8?B?RFZSc2dGYzNLNjYvM2I2WkoxNGpFdER4ZWR2aDk0OU1PM2tvR0Uzd3F5Vk9h?=
 =?utf-8?B?dlo2YVBHMnlRYlZVc29rekIrWGx4NzdxTWhDa2FlQTZqVUlWZiswYmR4SzFi?=
 =?utf-8?B?Qm5NVm5mL3NOSGVwSXBjc3FOVnJNaS9EZXB5WDZxSDRmZjB5NVRZRExSckgy?=
 =?utf-8?Q?yV28fQtI+u0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEpZZHROa243cUVhNzY5QmNsdEp2dENhaEFXeVRLTWxqaExtcTNNVDBWRzJI?=
 =?utf-8?B?cnl2M3dUL3Vpd3BLWU5NcGVoa0RZblFvSlBKQnNLMW9TQnlvemQvcmRGSVhx?=
 =?utf-8?B?djRLNk9RS0RCbmdoOFpYNm1DRW41QVRnb1FmcUFXSDZBTm1IaGNha2FXaXU3?=
 =?utf-8?B?Yzh1VnBYc1p5VXJ2NEJQU2ZvN1ljb0xvZndWSzBENVpXYWY1cVdta2FybjdF?=
 =?utf-8?B?NDRyY3VuNkJ0RjRma3RhWjRZUTg5N2IxQ0p0cEpSYm1aL1BhL0dWMXQxVWxU?=
 =?utf-8?B?OFZKRk5vRVI1UzhQODlHekg2QUJJbWpjV2FYY2pWRXlGODd5RkVpQ1E1RVRD?=
 =?utf-8?B?WWxhSDlSU1JlMlhYTEVsQm53S3ZDOUtYMStCZWFNS053bmhzQ01IMzNaM0s4?=
 =?utf-8?B?QUQ4S09RYWFYM0FYRWgyZWxMWEdkK1N6dDNEd3RpbEJFcXdpU3pUTDNxcGpL?=
 =?utf-8?B?TkJ6R0FKcU9WbXJobmtsa08yRyt1TE9ySDBHVGxaU1ZGRlFmWjQ2SkRsdyt5?=
 =?utf-8?B?TEZSSzRuaWdWTzVWalJHdGREOW5WQjJGRkdTUEFDRHFzeFdvQkM5aHhOdlIr?=
 =?utf-8?B?SVpOS3VROXBpQkR1R0ZPdGFOT1Q5aFdHRlRqSi9GeDA1N3NraXFsaHM3SXph?=
 =?utf-8?B?dUpzazJVMlJnTEVXQ1RRdTFjckVkWElqZERHbE1YZnJkeFRJak1KazVJN0hk?=
 =?utf-8?B?ZDM3RnRueTJwT2M3NG1KLzJLamVZNk9saG5wdm9wemlVc3FnWHdaMmxjeEY4?=
 =?utf-8?B?ZjRTTUk1eE9ZQ05zMTg2aUxjdDdSL3BCeDVzMzhlWktFMjlxWXB3VHVRL1VG?=
 =?utf-8?B?TUNEdDc1cGpCSU0ydWFpZW12MUxXZzNHUkx6ejRoTlhvWml3eHExTDJWb0Nh?=
 =?utf-8?B?ZWNTUzBDUllrSEp6Q21kQ3h4bTVNWmlsOGhxZVJTQWt2T1lRSEZCbnZsVTNs?=
 =?utf-8?B?WWRjL3JuTnVhNjB1QWpIeU1tQ3hRelNrQm5LNjZ6TmI0ZFRvSGhQdFlSNU9Q?=
 =?utf-8?B?NXh5b2UyMGpJWnZWak5nbFJSR1FxRlI1clFOWTZWb1JCTVJpcE9LZVBlNU9t?=
 =?utf-8?B?eGsyVEN1alNmZlBkVDc4NmZZY3FtMXJGUTNJVFZYbFpxTmFEV2xsWWNuWXc3?=
 =?utf-8?B?Qk5Fc2tObm4xN0dhK3ZadU1EdnlkdnZxMG1lN0Rla2l1RHlIN3pOY2cwZjYw?=
 =?utf-8?B?MEgrN2JlUlFVOVh1VnhZNnpiVEh4WmxRbVl3OTRiMktFdFpqR0NvRyt5WHhZ?=
 =?utf-8?B?QmE5ZW1kQzBNY1ZGbm4yNkx5VEsvNUVUL1NGY29qT2lNV1Z0RzFFdzl5aStH?=
 =?utf-8?B?bUtQMGVMSUJSVmF0TTYycVUwMER1MnluWVZNajU0TlR4R211K3hNMFdFY095?=
 =?utf-8?B?eTdpZkpRdkJMZkFJclJ5NFRXa1BRZzJlY0g5UU1WaklmY2E1Qmt2aFp0NG1w?=
 =?utf-8?B?UnhpRUtCbSt6ZlRPbzVFbUU1Z285c1laU1QrSXV0V2lwLzJ3cDhFYUV0eDZG?=
 =?utf-8?B?RlhFSFFaRlRDblRuTkdld3dPaWhURjN3RDhaazZ0UlBGYzdNZ0FDb1VDQ1FB?=
 =?utf-8?B?ZmVUNjlHdTdwTHBpUDEzd21ZYzFBZTFYVHZwd0dVaFlvR2p1ekpqajBxaVNX?=
 =?utf-8?B?U1MxOCtZWDdMdGQ3RkI5cm5xcmtOVitHVldCeXJqdnU1UklYS3lDd3Y2T1p6?=
 =?utf-8?B?Mnl4YmoyWDdwRUtLRVVONkRvTEhoRjRDVXMyT3d3TVNCd0VTcHIrWkx3dTlo?=
 =?utf-8?B?RHFaQlpDeGV2bXRYUWVaS3Z0Rmh2VlR5VnMxb2thRysxTXcrb1VoMEFyV0lQ?=
 =?utf-8?B?S2FCazRCSDYzRnM4QUxmQkhQa3VwUU9NTmRaRUxmdGFXTnNmcXg4S1RCcUZh?=
 =?utf-8?B?RzgvR2o1NlNIemJSMEZVOUVzb3ZNeVdNdVNVdDJ1ekZGcmFTeGZiK3k5ZTRM?=
 =?utf-8?B?cEFZRE1QcHc4bXJZM3ZnRmZ0bmJBWXFpRmF0aXJoVFJNMDRpZ1NmZ1ZwUm1T?=
 =?utf-8?B?QTQ4NVd1YWJxWEE5N28rYTFlclY0cmFqVjhiRXdpNENDTDVnZEY5SHFiODY3?=
 =?utf-8?B?Y09pcWpDamNIczlncW1IbHY3Skh1SmdncGdRUkRxa0REVlppZDRXMGpOTG9x?=
 =?utf-8?B?WVU1RTYwbk9NcENkR3dGN29hRGh5c3lHQ3BNSlZxMEdtTkxROG0wak8vREs1?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IK9RGohNg5J8Skmhou/8kR64HBLgXe3qKpkzpDJK1daldklGtQ2XxGp9D1d6wqh8natfPbMf3R8DUHjqL1isWTkr5FvFm0Q2Gs8I7Hu0YQdo/BISsesMiTWJwzkRcjSVQJRbw2uhD9bNeaQ8rZPSODQ9vaABYVR3SPJXMY3eKZoNolYQeOSqpCio2Yc3vrSUks5QGIfKNbF0y0oYWq0S+8cwzLgTeh3wxWYfA8kbblCVzxtxJ55zPun0OJZJhvA3fozf1hapb55vRY/tcvYyF6j5uKx4DMMzPUdgoOCQpf8mCLgIQKDxYRJnd8cmYhLZMUgT7oubxbYdZ85ynpDFdSbVzvaQvHEZoqfPhSAdvxhuhs9rbKI0keqwW3ZZWb+qHk1zZddMOchd+ICv5h9NxtMZaUBYPwHRbnZH7h2K+PizHcc4uomibzjXFSp/XnWvVc+VnF+P1GMq/905YQH+lwsfaTdWSvIayPBCn7+hcxpJ8+4G8ix+jJzM7CHDFA+wtQUYmpn+NAQrXcUJsyot8ufsXx48K1SN2O+ZpkfHGpSZZvv/JcbuZys80VrZ7tmbpqxcq8+QbO4qnf0bBQEXFrNd3/I79zgMT46XXp6Xy7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd48a22-5fd8-4900-92d2-08ddf12461f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 11:14:32.2832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofGqaXtt7pOUCi3wObA9njZAoQu0PO/n3F+JZPly8ft+/+RKlA3K0MKWqZjGZE0F21RMh9UuMZr5hw8EUWlhWH1ps3+WDtgDNA3KtrH101Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509110102
X-Proofpoint-ORIG-GUID: 6PaxCaIc-tVPlcW7PfhrBrEOhNVClcmX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX+sASE5jAuTQW
 dEStTOTkz4qgeYKFlCHoe+kvxPFXdphQ1WjaOTnMwsCrVX6eMHHzGFHbc9KwRrnUlH978xEjLen
 OYb+gPlRF527cFjCTL0q5+iiuI2ikBPtRrhNHtRnTzS+1orr9xgiGWuDnUk6DASizr9YnuUrN1/
 UA+bvS9awlHxRA13FSLAKypaRLJnOwrGaC1RgShtByMNq8ad6w+uuVyniq4lInOXcEOADSHqZU7
 S9L93cZvtBHlZ7g9L1cB0cTDpiITPmNwVU4fG8SIN3WivZJvkyJkygU3HdIQBurUJUnLgdDJYcM
 0vQppLwwy3WRLjcLov7/hBgG8F955680MJiXcy9W9+7C0DgLF+X5CdseMvLdqcRiYPrrv8DeUO2
 pjEETiBK
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c2af1c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=skXMnxY9EExHjUiplRYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6PaxCaIc-tVPlcW7PfhrBrEOhNVClcmX
X-Rspamd-Queue-Id: F21594000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: u3e5uygs9wiu3opztrpg5tjc9e3do3wy
X-HE-Tag: 1757589301-13127
X-HE-Meta: U2FsdGVkX18yG+APmBIlatU12UuXoE6Gu6ISSi7jR9AejgdBnwtAq29xV9UD8HdgCco8fc10lA8iGXHPR7ZDls5XnEeqLNqFjUYxb9WtSg7TTv+mUCdOaM6UxdiN+YPQ6+4ZqNbuL8i43NXEWSbRDxm7/dJ/+5wr6UveaygalXmlphBAXnR2ft2OW6Di50J9WFDxiYe/hMcESiiTNbg9+5/I1Kgt8QNHL//xXpdUVI5v7tVrgqandAnvpCZl0MQRn3Y1s8nCwC/2r+FR7sR5WglVr19q7m1O61Yg/SDuiFFsb9GymUJaGgIkQKZ2Qg+Kxcx/PhplMif2MVaWzsbMGb4Gyy1cNcX7kBlwns8+aR+TCBoqFytKMWJbMkd/3UyFrmkNVyayohzPE/YoA7pOZMtBoafTlgfyLsjIz8ux8Zarf81QJzatf9XuEW1e5Sb3kgVvx59X5RFPFT0Alnd80M2ccxwqNBtM+j5fA2BpUUV/P4RN9ci6OjawJq9s90BjgZsR+l91fzeTXloaAIYxQ6jBsRQeuO+4r9Rdiu0OJRB9jVUMFMcBLJ25RAejtLKqIBczv+YcFUQGHglQRMsMM1AGEWe0GHXDDpwLrUYcU4QD0X5DSSopXHyg/lnquRmqnU7vkhjvk1DFPOWTevWMsE2G78+xUsruJv/Cn/JguL8zmt215ioqvBOLEvU1GOXs/b59GLuT6Bl8R1bp+LXErzDJRymXxwNX+hN8ou4e4OIYPZvAanrLWmx4RMCyIq1x5JCNEeHIYQVcAD7hyFVPOgowz15J7qF4qiXiMGOZI+5OILmI2RkE4EmqFwp8lIcrwEIsdaaG1ZaoeGjAg3y3zSMB2BX9HGGHID1WvqVhqdJokl5S3YUVxRE3WWMXIwsVy4tY35qhk2tP4SIfx2psRXpIzzlanzrXlCiu8OhXCIzTKqSfY8Ypv5bP0qwC6EmRlZQ+fMBBdK6A7bbwz6W
 OR3Hbtbx
 evp7hjqYCCIl9HKMlUS26GLN7YRBfNgP/kcimXrZSCs7ik73+zaQZrQGdacIt6D9X+s/22ja7GfUvJkUBXUmCGx+xrm24Q8Vd1unndnbjctVLqi0vBPWONDb4SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One small nitty note - be super helpful if you could add a newline before/after
your reply or soething like this as

>> blah blah blah
> blah
>> blah blah blah

Is harder to read than:

>> blah blah blah
>
> blah
>
>> blah blah blah

Thanks :)

On Tue, Sep 09, 2025 at 12:36:54AM -0600, Nico Pache wrote:
> On Thu, Aug 21, 2025 at 8:49 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Aug 19, 2025 at 08:16:10AM -0600, Nico Pache wrote:
> > > With mTHP support inplace, let add the per-order mTHP stats for
> > > exceeding NONE, SWAP, and SHARED.
> > >
> >
> > This is really not enough of a commit message. Exceeding what, where, why,
> > how? What does 'exceeding' mean here, etc. etc. More words please :)
> Ok I will add more in the next version

Thanks

> >
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >  Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
> > >  include/linux/huge_mm.h                    |  3 +++
> > >  mm/huge_memory.c                           |  7 +++++++
> > >  mm/khugepaged.c                            | 16 +++++++++++++---
> > >  4 files changed, 40 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > > index 7ccb93e22852..b85547ac4fe9 100644
> > > --- a/Documentation/admin-guide/mm/transhuge.rst
> > > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > > @@ -705,6 +705,23 @@ nr_anon_partially_mapped
> > >         an anonymous THP as "partially mapped" and count it here, even though it
> > >         is not actually partially mapped anymore.
> > >
> > > +collapse_exceed_swap_pte
> > > +       The number of anonymous THP which contain at least one swap PTE.
> >
> > The number of anonymous THP what? Pages? Let's be specific.
> ack

Thanks

> >
> > > +       Currently khugepaged does not support collapsing mTHP regions that
> > > +       contain a swap PTE.
> >
> > Wait what? So we have a counter for something that's unsupported? That
> > seems not so useful?
> The current implementation does not support swapped out or shared
> pages. However these counters allow us to monitor when a mTHP collapse
> fails due to exceeding the threshold (ie 0, hitting any swapped out or
> shared page)

So the collapse counters are not measuring collapses? That seems a bit
confusing. Or actually is this implied in the 'exceed' bit? Because that'd make
sense actually.

But let's obviously document this carefully.


> >
> > > +
> > > +collapse_exceed_none_pte
> > > +       The number of anonymous THP which have exceeded the none PTE threshold.
> >
> > THP pages. What's the 'none PTE threshold'? Do you mean
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none ?
> ack, I will expand these descriptions

Thanks.

> >
> > Let's spell that out please, this is far too vague.
> >
> > > +       With mTHP collapse, a bitmap is used to gather the state of a PMD region
> > > +       and is then recursively checked from largest to smallest order against
> > > +       the scaled max_ptes_none count. This counter indicates that the next
> > > +       enabled order will be checked.
> >
> > I think you really need to expand upon this as this is confusing and vague.
> >
> > I also don't think saying 'recursive' here really benefits anything, Just
> > saying that we try to collapse the largest mTHP size we can in each
> > instance, and then give a more 'words-y' explanation as to how
> > max_ptes_none is (in effect) converted to a ratio of a PMD, and then that
> > ratio is applied to the mTHP sizes.
> >
> > You can then go on to say that this counter measures the number of
> > occasions in which this occurred.
> ack I will clean it up

Thanks

> >
> > > +
> > > +collapse_exceed_shared_pte
> > > +       The number of anonymous THP which contain at least one shared PTE.
> >
> > anonymous THP pages right? :)
> regions?

I don't understand what regions would mean here?

So what are you actually measuring? The number of anonymous THP mappings? If so
I think 'mappings' is probably better. Or 'The number of anonymous THP page
table ranges...' perhaps?

> >
> > > +       Currently khugepaged does not support collapsing mTHP regions that
> > > +       contain a shared PTE.
> >
> > Again I don't really understand the purpose of creating a counter for
> > something we don't support.

> see above

Ack

> >
> > Let's add it when we support it.
> >
> > I also in this case and the exceed swap case don't understand what you mean
> > by exceed here, you need to spell this out clearly.
> >
> > Perhaps the context missing here is that you _also_ count THP events in
> > these counters.
> >
> > But again, given we have THP_... counters for the stats mTHP doesn't do
> > yet, I'd say adding these is pointless.
> >
> > > +
> > >  As the system ages, allocating huge pages may be expensive as the
> > >  system uses memory compaction to copy data around memory to free a
> > >  huge page for use. There are some counters in ``/proc/vmstat`` to help
> > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > index 4ada5d1f7297..6f1593d0b4b5 100644
> > > --- a/include/linux/huge_mm.h
> > > +++ b/include/linux/huge_mm.h
> > > @@ -144,6 +144,9 @@ enum mthp_stat_item {
> > >       MTHP_STAT_SPLIT_DEFERRED,
> > >       MTHP_STAT_NR_ANON,
> > >       MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> > > +     MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> > > +     MTHP_STAT_COLLAPSE_EXCEED_NONE,
> > > +     MTHP_STAT_COLLAPSE_EXCEED_SHARED,
> >
> > Wh do we put 'collapse' here but not in the THP equivalents?

> to indicate they come from the collapse functionality. I can shorten
> it by removing COLLAPSE if youd like

Hmm, if this is actually giving information then fine to keep.

> >
> > >       __MTHP_STAT_COUNT
> > >  };
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 20d005c2c61f..9f0470c3e983 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
> > >  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
> > >  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
> > >  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> > > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> > > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> > > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> > > +
> > >
> > >  static struct attribute *anon_stats_attrs[] = {
> > >       &anon_fault_alloc_attr.attr,
> > > @@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] = {
> > >       &split_deferred_attr.attr,
> > >       &nr_anon_attr.attr,
> > >       &nr_anon_partially_mapped_attr.attr,
> > > +     &collapse_exceed_swap_pte_attr.attr,
> > > +     &collapse_exceed_none_pte_attr.attr,
> > > +     &collapse_exceed_shared_pte_attr.attr,
> > >       NULL,
> > >  };
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index c13bc583a368..5a3386043f39 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> > >                               continue;
> > >                       } else {
> > >                               result = SCAN_EXCEED_NONE_PTE;
> > > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> >
> > Hm so wait you were miscounting statistics in patch 10/13 when you turned
> > all this one? That's not good.
> >
> > This should be in place _first_ before enabling the feature.
> Ok I can move them around.

Thanks

> >
> > > +                             if (order == HPAGE_PMD_ORDER)
> > > +                                     count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> > >                               goto out;
> > >                       }
> > >               }
> > > @@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> > >                        * shared may cause a future higher order collapse on a
> > >                        * rescan of the same range.
> > >                        */
> > > -                     if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> > > -                         shared > khugepaged_max_ptes_shared)) {
> > > +                     if (order != HPAGE_PMD_ORDER) {
> >
> > Hm wait what? I dont understand what's going on here? You're no longer
> > actually doing any check except order != HPAGE_PMD_ORDER?... am I missnig
> > something?
> >
> > Again why we are bothering to maintain a counter that doesn't mean anything
> > I don't know? I may be misinterpreting somehow however.

I guess answered by rest.

> >
> > > +                             result = SCAN_EXCEED_SHARED_PTE;
> > > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> > > +                             goto out;
> > > +                     }
> > > +
> > > +                     if (cc->is_khugepaged &&
> > > +                         shared > khugepaged_max_ptes_shared) {
> > >                               result = SCAN_EXCEED_SHARED_PTE;
> > >                               count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> > > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> > >                               goto out;
> > >                       }
> > >               }
> > > @@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
> > >                * range.
> > >                */
> > >               if (order != HPAGE_PMD_ORDER) {
> > > +                     count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> >
> > This again seems surely to not be testing for what it claims to be
> > tracking? I may again be missing context here.
> We are bailing out of the mTHP collapse due to it having a SWAP page.
> In turn exceeding our threshold of 0.

OK.

>
> Cheers,
> -- Nico
> >
> > >                       pte_unmap(pte);
> > >                       mmap_read_unlock(mm);
> > >                       result = SCAN_EXCEED_SWAP_PTE;
> > > --
> > > 2.50.1
> > >
> >
>


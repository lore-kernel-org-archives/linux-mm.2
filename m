Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58489CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92DB8E0012; Fri, 12 Sep 2025 08:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B534F8E0003; Fri, 12 Sep 2025 08:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B058E0012; Fri, 12 Sep 2025 08:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4C98E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:05:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6469186D7B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:05:27 +0000 (UTC)
X-FDA: 83880468294.02.CEBED99
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04505C000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:05:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hlcYrmxG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i9TzLeFI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757678724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQrCGHtlhOZVxT7DW0BgPAVjVonQeSi5NHz2FKmjXIE=;
	b=ZuUMIMC9bLWJRfgNyr5S0hQg900Swif1VVem9vovhd8/SrUPgGVmnqNCCueInz8GyYn5FY
	MoFakI8QOoTpkIkJ6tyXaqt9N3lV92muvx8eniqvHrmGFyW5Ft75XqJi16yR17MNjs9TCM
	cW+fr9wfDa8bBdn9H/J0GmC2NfZcbgo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hlcYrmxG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i9TzLeFI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757678724; a=rsa-sha256;
	cv=pass;
	b=M8sGZYKHwHYoc5yV83GeSP5Byf5PTZdkVDw6pEN/oL2h2VC61SJfI3+Gck1PDwP8nEthhv
	zuQ8lCvx6/IVTsN3/EF+6s1kLOzRkLs4EmH8hmBQ2UGLOla/I83UMru5QJ9ZGgxbw0UJUj
	E9OSClrUL5lF0IfIc3+cp/Mon/vWQtw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1tpdU027258;
	Fri, 12 Sep 2025 12:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JQrCGHtlhOZVxT7DW0BgPAVjVonQeSi5NHz2FKmjXIE=; b=
	hlcYrmxGdfgK53Z1WZd6ur+5OTH9A7efNDmIX+8F+il+GQTMlCDX6k1+go38JaVP
	fiZNlkKgieFWJr1RBlkELlCDTxXmf0YK+30nRB/5UU++UIP5Csza67VXRJIuK8TF
	aeJ+AvDrDR25IqKSBizcG94g9hllISVdVtCzno39eHxwrrfFjDJ1/S66+o38Mhmw
	nP9GFqhLHZ2ILTXaZByDB+zvnZ9cmH1uypdzWEkbaYhNDn7X4/caTHfEJZNyDD8j
	YhT6Lpj9IrInwWbaA9bT4gE2KQIPox6fwr6TjnNwHUzBmma8QHJluzsQZf404cnj
	V77qZxMQfl1M8SJGgRn5vw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922sj008q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 12:04:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CAFS1d002850;
	Fri, 12 Sep 2025 12:04:56 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013006.outbound.protection.outlook.com [40.93.201.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdmamyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 12:04:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwX5QXpsad6UfM3tEmDuIdzG48XtPdHLJi9OF3bECgG7H/isX5PfmQGjPD96DQ7rqvcg8N4NFkJFLYdLPo6CD1H2dnCryXTu1qtd4EFHBGPBbCUQeAnDDEzLBCPn1K9FMk0S4MYyL1Ps7s3PtVNX8dQLvEb/6I8FP1Yao7/AJ700Vqbuis8plbtlA3DIYF+A/fAGCVM25lMZ+PjgagoZB81L51cTLbVCn3QgLq/kM/Vp3E08QDevY4jU7bNHXwFLAKJXMYIdhhx92DH9O3bbPowiwkHisqHKbaz9QTJH1Rr+b+4sFPba81SHMAXNtwTtWVKAgxKYxXxvmVgrddbuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQrCGHtlhOZVxT7DW0BgPAVjVonQeSi5NHz2FKmjXIE=;
 b=wHUTL5Bo68GBdlkLIi7CQrh+7H2HPFhKGlv2NR8/Y1Wz63fsv1AxEtB3s/ryN3KLt9XyU4Rc3B4ysS870uK+12mYgFfoHN2jnbI0rmrrlH7BBZ0Zh1/E5QhkEMKFcBiUGwzSjsCxuyv18nnKWkoWoLqRziyYIj/tES5LMYWgVeIF+YLHIj02EKo5fP7vzyNKz5yof0IkJQR3cjBOZ0dfaCauec8sNIAuaR77Nsr3xLSw+GPAw2dx1GLYilwxcHlR0NO3hVZU1UFVTT1baRaYMAuUvr9gycC2QRswejeBvKTiwUv9BNZhWF828yWlMEjAookERLTNiFxrtZnxSy+Haw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQrCGHtlhOZVxT7DW0BgPAVjVonQeSi5NHz2FKmjXIE=;
 b=i9TzLeFIUDSjrYnSUGcz9/bgzpjHeGLpuQto9MkjBApqnqNObcMuQDtYXKwqC6HBnZjCwPBGNbuxFXGy6Tz/hKQoi/krvYdsE/qX1ObppBcUBgZlVzCO25tGt/YukNs3K4Fzi7LKCI1+aiSWwRdALry+50Nv7uWtZIKjwbs0I8k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7397.namprd10.prod.outlook.com (2603:10b6:8:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 12:04:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 12:04:53 +0000
Date: Fri, 12 Sep 2025 13:04:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        21cnbao@gmail.com, shakeel.butt@linux.dev, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 mm-new 03/10] mm: thp: decouple THP allocation between
 swap and page fault paths
Message-ID: <ecda0e47-6193-45e2-981c-ac4bbf177855@lucifer.local>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-4-laoar.shao@gmail.com>
 <0aad915f-80b1-4c2f-adcd-4b4afe5b17dc@lucifer.local>
 <CALOAHbC1QDeqoS5Onkccsf+rMWEUbb1OEdeuLOaC9sLWhk-Amg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbC1QDeqoS5Onkccsf+rMWEUbb1OEdeuLOaC9sLWhk-Amg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0448.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7397:EE_
X-MS-Office365-Filtering-Correlation-Id: 84193217-bbbe-4a24-d237-08ddf1f49532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OW16YlhWazVwK28zcHNNNWMrSGJtbG9NdVI3KzF5MjNUZUFEMEpPMzF0M2J5?=
 =?utf-8?B?NHc2TzBtY3h5RWNMMlU1bk1SVVlIQmQzZ0wyaHNkZVBWRmticWZHWG5iSnhw?=
 =?utf-8?B?Q05MV0RTOWpHVGttdFN6WHVTMkRTczF6U2Z4Wno5TUlNTlBrUVJKdU5PU1Va?=
 =?utf-8?B?d3dvZklJaG9HWFo1S2JtWXB6c0VDbmZ3Y0FGTWYxUUVpUSsvWE8xT2ZBTDRr?=
 =?utf-8?B?NlRQenZJT1VZR25nVDlKV0xTVzFpbWFoYzVoM1piTlk2VWpJZ2ZabC9ibUpi?=
 =?utf-8?B?bjhGdFJRdXB0bkEwTnlOZCtvOVVJc1NBVnh1SHdLUFczeGYyaEVkRWt2UlJa?=
 =?utf-8?B?TlJuTkJyR29DTFVwckxBM3pWWUpjY0JCZmZSbmoxQkl2blJsZVlUU0dSMGNG?=
 =?utf-8?B?TXVIb2gvWFlRNEhpby9Tckg3c09KTlFzMnRVYU5CcTN4dmRwVUs3Q0hkeUR3?=
 =?utf-8?B?bDh6TGYwVU94VFNYMXFMUGJDZHpnOGtRMncvRm5PdXF1eXN1WmZaOTloSFdE?=
 =?utf-8?B?LzNEZnJEc3FlZ0Y3QmxGLzdNT1NxbldJV0N0dmZZbFlUKzdFSVUyYjN4akJw?=
 =?utf-8?B?WDErL2hpdlB4UUlBekRxcDB6Mm1yMmZJODhPVlB5cWZ5Snh1cXZOS3Bqam1l?=
 =?utf-8?B?ZThNdEI5YmlWUjI1RGFnQTlnNmxGdEVlVGZYaDdORm8yaEQ0YXdlMTJmYmwy?=
 =?utf-8?B?SFJDdVM1cFl4MjVqQVpLVHhXOEdQVnZRdDQzelVnaHg3a3R3RkxrV3IrbXJ0?=
 =?utf-8?B?dk9Rb1hJeXlDRmRwbWxkTjVnbmtXSWJlM1RLdEVMaloxVTNnS1ZLbWJoNzVs?=
 =?utf-8?B?c0lDV3REbHltYnpRZjVLdnlkTHc1eGtsS3JvNmRNMHFyOFJ4ZEhjNStoemxq?=
 =?utf-8?B?UUVKK0U5SHk0TDdzR3EzVXl1TG16YTlUdWFPODI5UFhHWkRjT3oyT3BFSkRD?=
 =?utf-8?B?SUJIUjhTTWFyQXIvVWZMTWFVZDVsUmU5QVhWZzAzbkhwd0ZwTHZ4VC9KQXU3?=
 =?utf-8?B?bXlCNW1kWUR3WlBhR0cya3g3bkVRazVVcGppVTJiY3ZDMkFPejZ3RjYxL1Ux?=
 =?utf-8?B?QWJEaFhnOFRHMWlMWHhWRmFkUTBYTXhBNE5mUk1meWVKZCtnUUdmSFBuZTVV?=
 =?utf-8?B?UVNST3AxbEJ2NnE0MEJjU1pSSlNhaDQ0cHhMSVFQbW43czJvZUJVSTNqVzFM?=
 =?utf-8?B?N0hwcW12dCtDRnBMUHZ6RDFJRXhteWYvdkJ0cW43OGJMSDhyTnJVKzk3bXpO?=
 =?utf-8?B?M1NmOU9DWGhDbVdHQ3VzcjJQQlVFQ1lQT3RFRTJiMXI0VFJ1WjZ1bUVFb0JE?=
 =?utf-8?B?czlsOXFTM2QzTG9FRE1ickcvTHJxM3hUVG9UU212UDluUUd5ZHRTT2N4YlU3?=
 =?utf-8?B?V2QxZEtkUTU5aWVkek5xSitheFlMTnJWRG50ekptNXMyT3ZJdElJVE5BODNo?=
 =?utf-8?B?NjFoRFBZZUUySTZNUW5CV3BwVWdMdkpING9ZaVdiZjZIRjdDbHpWbnFaV1dz?=
 =?utf-8?B?bkQ0bWtmNUJmbFpNcE1HZlN4MDlGNXV1WmU2TXdGZis3OE9sUVRqMm1uN1ZC?=
 =?utf-8?B?aHlRd0tQSG1wSDJkaE12U1FFRHBGQ2JsV0c2NXFVMVRLbUlQTytiWkdQbXEx?=
 =?utf-8?B?TCtZS1hGSzVQVDRnL3JMTWJCa1R5TUtyZmdrd0ZPUTVPWWdmWENMbHBIcFcv?=
 =?utf-8?B?TGtDYVUrb2JSeDhQZnlZTjYrUVJ3RHVyRTVVY01DN28vbGZOQTB5QW5hQTBO?=
 =?utf-8?B?VlRsLzNvR0hydlM0aTc1bndPTWw1UnQ1RDQ2aURYb2FUeW5TOGQrWnFWejVQ?=
 =?utf-8?B?UXFVd0VCbng2dFJvMTZaTDQrUjdGSnU4Z1Y4QlJNUDg0M0xmV04rYzlkTDJP?=
 =?utf-8?B?ZVF0cXhRVndYaVlGdEN6TC9xMHA2enh4MjU0T0JDWkJmSEFzKzZCVzFkRms2?=
 =?utf-8?Q?gfPP3hznrqM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDFBMHBjSll3bU96alFQR0NDdHFiZ3dEYlVQUzFWK0NwVjZZamtKMll0N2Ir?=
 =?utf-8?B?WEJKcE5hWE5neTFyd2NVa2p6dDZtMXNLNytoeWNIYnE0ZWpGbG5xSzhhK2hw?=
 =?utf-8?B?VUNjMTNTaktScEZHUzdiVU9QVmdxbStGcXFuOWZTUzBJRnR1TzhTdWNoeldu?=
 =?utf-8?B?MkgzQ0hlNFZWWHdiU1RweTFpVEdpbDM0REZhR3J0TjVrL0V0bHA0M3F4RExL?=
 =?utf-8?B?ME5meEYzVllpRnNVUGI5M1hYTGVXaTBNdXJYYnVVWStlMzRtdmt1YkNDdWVM?=
 =?utf-8?B?N0gyMjlsWTVZTzVETTIweExncWsrMzZvUGhsWTd1T1JFZGxoVEtIOUFZbWlk?=
 =?utf-8?B?R0piZWhlaDdGQTlYeEhIRzJzUzBINXVNT083WUhSOTRkRmt5OXZQMjY5d2g2?=
 =?utf-8?B?d2xWNzFGQ1FSWjJlUloyTkFjK1JUTlVEdDJtL1U5R2hWemphMk9kb2E0MGhx?=
 =?utf-8?B?Z0FJZ29xQ1ZqQWFwbFc5Vm53RDRYbmp1dlI2dFNzWk1Ec3g3c2JoaEtTVi82?=
 =?utf-8?B?dXovMHdPb3ZpQ0hvY1FiWERkSzdWTitxQnJXR3kzbnlJQlFiNWE0UlRvbFZX?=
 =?utf-8?B?WVhYdE9obkxGcHF4alVVTGcxWEJDSVdIUVVSQnl0NStXaTlXaDRJd0tqeTgw?=
 =?utf-8?B?OEhnRWdRYlFZSnQ4SDBSb1BFdC9tQW05NUdqbERwRUc3alZRZ2dDaWIyRTB1?=
 =?utf-8?B?VzBGMEdLM25VYmw1emlyZXhTbWl1VDBhR3JmYk1ETDVCK1YrZnNFTzB2bmZz?=
 =?utf-8?B?WlJGT3BWbHhYbUFRYno3YWVXMlRlSk9JMTdycm5aR1RRVS9aNlJSTTFRL0hu?=
 =?utf-8?B?UldGZlBUUEN4RVhQZ0w3WUJKbWNHMnVFMXVTRk1UaHptWWdBdUd6VWlSd3hy?=
 =?utf-8?B?SFcvL0Z6WmoxaEE0VS9XbXM5eVFoQVRPTnI4OHhIdkxOV25tWVFJaEI0bXhO?=
 =?utf-8?B?ZUc5ZFVXOEd0VjJWN2ZYOXZpUmV0SXgzcFpYdW9CQUxneEtJdzBBQTlkZ3pD?=
 =?utf-8?B?dUR0ekJ1dXZWWmtvSis4MWJ3Q0ZrOGVNSXlRSmZMOHROaS9hc21NMmg4RjhS?=
 =?utf-8?B?ZHdvdmxLdGZsNXhZWm5YQjdmbzVEelZjYUs0NWNmQU9ZdjlVaTQzTjlxUXlu?=
 =?utf-8?B?ZXlaY3M1eDNSYytJV3k2WWZZSnlqRTNFb3MwRTYvQjZWMzZ0TzFmYkxpZGRX?=
 =?utf-8?B?ZDQzWm91cTh1OEpTK0JPNnliU05STVc3NlRUYy9nQnhaaSs0bStibkJzSUJG?=
 =?utf-8?B?Q1F0VU85TUxtaFJiZDlKSDJ4VDNhZkIvU3htTkQ2bDcvTVIyVk5rK2J0WmIr?=
 =?utf-8?B?VUpqVksrQ20rVDhKMDEvSmdvZDlwY01jRHFQNDNNcGxkTkxnOGtFSE5FQW1v?=
 =?utf-8?B?QW0yMTA3RkF1enlHZkpxQjNWY3BuOTlZTm4zd3k2dmlGS3BIRWlUWEJLOGRh?=
 =?utf-8?B?STYxdUN3OXVsVVI4RjZOVDBvVHJGWjN1bVlPVEtocUk5WjV3NEt6clpwSXVr?=
 =?utf-8?B?TW13Njhjd0pndUlsRzFiNXdBbExDNXNMcWZocGdGdFRYZFE5R0VvMHEyMnNx?=
 =?utf-8?B?YXl1V3Nibi9rSU1EcnIzZEIzU2Q0U3hWa2VYUmRMOGF1SXM2QWYvdXZuLy9p?=
 =?utf-8?B?R2tpK1FrdXlWREVyck51V1FpZEZoNElWeExwaUFHMk5ocUs4SlBZaXVMbEpM?=
 =?utf-8?B?Mk5HRXlzZjdJSHdWUUE3Z2FJUkxyMjAxU3RDTHVueWpsWWUvNVVSL2ZiclVq?=
 =?utf-8?B?a296WXBVS0pMZXdQL1huekt4ckpqUnVBck5EMmZQdlBmYnplTVVkUmZDWHYr?=
 =?utf-8?B?UUlNKzIyWnQ2ZnVMM1d2aEJnUDFCRUZxZU5qSkZqUGZKRjNTSHQ5dzVOTUtU?=
 =?utf-8?B?eWhrTm9sL0I5WmVCOW9tRU1lWUhUNWRhVGhvN3k3ZXZmanR1MFdLT0E1SzVO?=
 =?utf-8?B?U1dSUDBHZDFmZ05QeHFETmpZVjluZks5VzlsYzkrTG91OGFaRDlmUUhYMXZR?=
 =?utf-8?B?QnEvQWxyY0JZY2xZWUlwQUdIT2lMSlg0WXRPTlh4ZDRNMFNTUVViaDlHWUIz?=
 =?utf-8?B?MFdNSjhxVFZ6ckdJM2hLVU4yUDNZWXVHSHFsSnQrSkZFdTE2akZJOHA0MytT?=
 =?utf-8?B?bzh2aE92ZWJmVVR5cmlxcjYyRVR6a1dqczlTcXR0SGljOW5mSlpPS1JmZ0V5?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LH6777jVUOBiDORGOscTSyW/LFarvwygoXkTHjhcSuFjmxWNgjDP56Y63s38K2rWulWbjzYogEKcAgF0k6EnFsqp+8u7fd1X4ShCUTg2Nsr8AmxG0m4Al1LqwtEGtEN9snEBbi/4dd9gl81T5N8iXR0tomwHY+ZMgTNR2ev1H0f0NE8kCt+ioLoG6p5HQlISADi8xlGZNapiYfxcbjZDlMz1LndVSNcAEuR3UwWnhNtHUW/HLSUiyo3Ibky1KVXZlPk0kp/ydUfgLNnlEuJUprDHqr2su4Wpk3Ae9+5FuSz3sOhXB4C47fksuX54Fws3LW1eWbm5e/Se1IaZBuJLa4CIIrPbnlLBs57+nCfJ0aZRnn6uTTRiPpHko2W7V8j8WWa2TmNGuHKDoHzbOhGZk+4CoHKNKUYLhsHBDfFxBtk/utQtlDFp3c+Gc4FMni3riEMKmDysyhJshXhv2LeW9DKO4Aq3lWuKbnTMAhlRbXQa7RbRnWWPzd1i1wB788rpQG2cyg3o5VdbEWUy/tbvPIds4aFzgfL7jqKPbuNne7zdAnn3/hNPsmCGnoQRFMS4Za5Y3t4uvPakJYj6Lst4PDXesVBpy+pvEzw2g1HANSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84193217-bbbe-4a24-d237-08ddf1f49532
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 12:04:53.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ra2IcHtyupc/jTDxubmqdHe65Hn2552LDws582AiMBkJd1HE5sxwrliejGQr2h4wZ1mUFUbeglCFcdOokO9vHNGAqkewJeQIk/4SOGVcNnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120114
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c40c69 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
 a=8eevGG8g60yIjQ1eG3IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX8ROQHB7hA0pT
 mxs3ghcKBnMYRv7NRNo/13GYe1vLMSekLIFItqcYw4BXHZO2WPQPxeilOn+Mb0rqkYAchqlRkN5
 rOuFgBqh6Nk4Xmt1pnNm6vGeZ+JdsQNG7704C722dbMORyVCKv45pdUqv5pCFicJZua+oYR0nkg
 BPFCJyOw0clqhmPCjAP5/MeKHZu9351Prt647O55HZaH+utae9tOZWOrF7ZKjxnxpdL+WMqvBcM
 6G4gZpkJQvbr2hSdOk06pVdwtydxEIyppYpH5cibaOa+RKRG9JAxgEMQKC2AL5HmyhJ8Thv8axf
 0EOs84/cp5CWbmYpSQaOZIrehCsUHDym4Yx4oKFQLVV0hZB8iE4EQPpbntH1DhuNaBjUqxK4sav
 F7Ym/UtdmU8V1+iQCwSZDDlugSgwQw==
X-Proofpoint-GUID: MO6BdNUr5AeDF2-mr1ySpHMYbDIidyop
X-Proofpoint-ORIG-GUID: MO6BdNUr5AeDF2-mr1ySpHMYbDIidyop
X-Rspamd-Queue-Id: 04505C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: k8im1obdybf3crjb7wo9z6x3yoyicyqu
X-Rspam-User: 
X-HE-Tag: 1757678723-115904
X-HE-Meta: U2FsdGVkX1/Fc1omgm2cIWZsDo1xkG+bB6g/tUfrwDg82N2uJIohVxKM/EJbfBz1S9IlhVgKDaaC/cftrb7bbpGFFxQH4faIQ4fSQ5ob8iwuLu6juU5QP3oLsm/IqSirmQT//zwB9SLXUoPjR4CSotyRK8l4CglSn+5pV737u524q5hdfpWITd1Hi97Y8ZX/8HEvzUr7TDwavbnGsKeYF4kvUr1HZqqHe/Wv2W77iQjv8jdTNmJDCbuQBLhvmiNCOOJKftk2ncgSoWgACcwTlIvmAEyxrZypKvFh+4KPFsHyF56NXfvPOFBP5nIaJTOr4vjIPrrgQb9d82hjpZkCRiJi1S9EiKKfZqx8Z6vs6qjLUNPkkybQrxaIf+Y+SP6OXF3tnxC/0BktVwCnHlzQDPBTlLlG+Xtrc+Asa2ISDNBcX0oSoON/GSjvXc6CeMl4YTzeXOGzH0zdlXc0ilRp5A8TVn24ari9W9hCJJ8QhAFTFsjCmhGYBfC4E7UhThqRXEBvrWKL9UTk+61WE/kyKukoXrlker7swR9yb2ZEJ3mon5KqII2f78V+Gi+uaMVx0Ob8+7NJ3BX2qmVqRqMNSKtDHopDZ2jNwQaCfgbbfdVqpGVdl942tGon6xOEjgNtr7H82pY7x5rY+EyjjJkUh44Guih0Dcxr9wdDUlL6xqYt3kOK1nRE7I73EJ/B0XE5rs//QLJxv8ooVR6e1w6PT4rGj8jB2D0Uu6vVW3VzEd9l49CZl6nsq7YgtLUwLosEMZ8mIAdUxhN04Gm0MruekI+KVw0Vp4oPKCeaTC4nhbqFRoWYEjxYp5VezmLVhz6GSW2p8VNhy3XW7wOb0EdN6VgIo9LuLQSpGSm+4/oel3GLtngN9vaqhIHAtG/cqShi2DHLclTiVdPZGXjQaZOCUdsZ+LAAtrczNxFFZgXt3pXtJcT/L49PerU/1sS6hKnOi96gQuuTcuNkerNyOk4
 6Euuh1YB
 vSEEGWlvEkVwrzuTWIUnEs7wNQ2XE+tbtVbiaqkYNOk0DI2AIYVRBWwABx4voscfQlhEDdU6q8Jq69zQalvLGlt6D4zg0r1f9H+vT+lQlIGqnYFgscL8pT1PxFBRkCNAADQgKwuvklQsx3XvUAMe+twX1UJJyUdHTCFRLPIaoPmoagJ6yzQouLpFvKB+NI8Fh3+UZ8TwsLWxxlsOtMZppbs/EJphcvMGunThhRhalQIVGqSoe9GUrWIRPazKrl0pKODlL3D2g0iUBU3ZpL+hI4EhXv4zIh4NuPUFVjxxvNGqxrnXxN/fBauWNe3Mcbp4o7WINb1ZpqAvEqY3Ra+2Qh+KywOVj7U0FaQWh8DDKAsBBhMnviJ8BYgiFHX8Nazz0IWN8AlR0bZxuPuaYLbxK6mpfDGxClk2EAuCj1E7kVAct+JkUtQa6WcarchlTFa5qe21bf9UYoIDWHik/7vTXc2INWU8hujkMKw4oVOPI2jHX/KD1L9Nkel4hJCDLO/6EbFz5w7zwsumqpVFRmwSf2MRe14Yrfe2XDoetLIWHQJ69iyQzKqVLZQ/btu28k2tdB5PFHRntd9D+zoWuRbSly30QqNt6p77prer1CL4OzbNopjIeC7tUbWPwI0maw8SMoqrPnMjm1X3Pkia1OLbYTR5SuP6zYUHghvkcl/To5YAp9KIG1KTZeolGjsS07MHu1AiloQww44dqNPNd1IyyAwFtjiTOpcFlwhteClam0xjkDJen7qiXKAekuc5BiKdXEH9FL7ytGzej7+9bhKHQod1w/y0iMhyQgIbuWsa59v5YXOhD7ztk/DvMIrtvriFcgvvRorBa+JM1KPdtpyxeD7uw3LEGK0ZuIJbnpNgcjtkubjA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 03:20:38PM +0800, Yafang Shao wrote:
> On Thu, Sep 11, 2025 at 10:56 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Sep 10, 2025 at 10:44:40AM +0800, Yafang Shao wrote:
> > > The new BPF capability enables finer-grained THP policy decisions by
> > > introducing separate handling for swap faults versus normal page faults.
> > >
> > > As highlighted by Barry:
> > >
> > >   We’ve observed that swapping in large folios can lead to more
> > >   swap thrashing for some workloads- e.g. kernel build. Consequently,
> > >   some workloads might prefer swapping in smaller folios than those
> > >   allocated by alloc_anon_folio().
> > >
> > > While prtcl() could potentially be extended to leverage this new policy,
> > > doing so would require modifications to the uAPI.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >
> > Other than nits, these seems fine, so:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > > Cc: Barry Song <21cnbao@gmail.com>
> > > ---
> > >  include/linux/huge_mm.h | 3 ++-
> > >  mm/huge_memory.c        | 2 +-
> > >  mm/memory.c             | 2 +-
> > >  3 files changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > index f72a5fd04e4f..b9742453806f 100644
> > > --- a/include/linux/huge_mm.h
> > > +++ b/include/linux/huge_mm.h
> > > @@ -97,9 +97,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
> > >
> > >  enum tva_type {
> > >       TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
> > > -     TVA_PAGEFAULT,          /* Serving a page fault. */
> > > +     TVA_PAGEFAULT,          /* Serving a non-swap page fault. */
> > >       TVA_KHUGEPAGED,         /* Khugepaged collapse. */
> > >       TVA_FORCED_COLLAPSE,    /* Forced collapse (e.g. MADV_COLLAPSE). */
> > > +     TVA_SWAP,               /* Serving a swap */
> >
> > Serving a swap what? :) I think TVA_SWAP_PAGEFAULT would be better here right?
> > And 'serving a swap page fault'.
>
> will change it. Thanks for your suggestion.

Thanks!

>
> --
> Regards
> Yafang

Cheers, Lorenzo


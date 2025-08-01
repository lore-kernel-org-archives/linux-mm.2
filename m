Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CEBC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F136B007B; Fri,  1 Aug 2025 06:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706486B0088; Fri,  1 Aug 2025 06:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE176B008A; Fri,  1 Aug 2025 06:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2DD6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:42:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C068A1355C1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:42:00 +0000 (UTC)
X-FDA: 83727848400.17.D412099
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65E4F180008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:41:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kme1mR+o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wNJ9tqij;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754044917; a=rsa-sha256;
	cv=pass;
	b=24mMcKAPHO00nUttglddweZyPM0DGnMW9HHjZn/gVrJuUPYZGftj22h/uucOj9tfZCkXcI
	1uftbqTobi5eQYFhOObiltLJTCgPYLPStYubQ8sB7iWzot2sT/GcCLoCUMNWxGWMDqheIP
	+9XbssvJmyivPfEfu4PjmdKyQi5Zz0Q=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kme1mR+o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wNJ9tqij;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754044917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lpi/qM6YLD7YWQMg2QpfTIJSahLy9kA4UyExTNQptLg=;
	b=hfXk2u8Kjqpw3IaeRcpkRD7evJfnZktl2vqT0dq4P1nYKOBR2XN4hrXwztSVtwtLaYKYZu
	MY9BGdfhOImRQM1Y3RYusvQN6tGWIpoQqNIK1lP2xK2Fnr/KfBC5tVCKrr01KxBiHRD+RI
	JqjEPccQ7rlhcQW8/B549oS18BNtNY0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5717C4Rc005771;
	Fri, 1 Aug 2025 10:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lpi/qM6YLD7YWQMg2QpfTIJSahLy9kA4UyExTNQptLg=; b=
	kme1mR+oxsrYbMIEuAAcK0PgsDGp25J8ZonVRxQFnHMXFikjnIrap6QN1kHvgMo6
	NPR6jQZ9CsqlZtD7qppgVBMjD7IAjBLjHzUwYrsPVLiUQxW+083EQyr2CuV0xFwf
	G4dDvByktQPNVeq35rXV419gcWkgZ0qcx4zhRjHgyESfsgWDOOABRn+B9AOPOG/3
	mv+dbDH90Py32ZjtzWzaR1QnJaqPAEcZtLjAQC7Xb0Qs8mvy9cRrimze1ut93es9
	QWZfQp2+RCXGerVQJaT9bixahuhRLaVGgXmw8h2piF0FOSDsO3ppkCKsDMfDndXm
	eYDKIVGeraicifEiyEikVw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 487y2p2w14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 10:41:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5719ROL0020528;
	Fri, 1 Aug 2025 10:41:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfm09rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 10:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqrBLRPIhv7WA6Wu3zMRgu21y7tIn8Eu8p+bT/mrsdbgh/njAnjiHNbdO8bmpxaa6KICF3KtpkfFHJvtf1CjLs6dOBv3eufxBL0DC5M0RcEavZ4zl6qkOVisH3iCD2FYQ6WJtypoYHQP5ftHms2gZgGnJsV21UoB+7xQdFDVP1bHdgIUOL6ddAdCPSZfYpCrzJwqwKT57ArEiOMVaye6Ppk4MAQW4k2MNfk2LpMQiLwSdU9qlicFlvcU/qWFysb8/BlmHknX1smni/ZKyLDCP2lNtDKvPsmw5QemB2r4qJbqokdvdK0zdrY3hmU68vf+6vyEzGFKqPDErhZFtsGl9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lpi/qM6YLD7YWQMg2QpfTIJSahLy9kA4UyExTNQptLg=;
 b=d9Gls2TuF6+eRk1LUT7iB3ZzcZnayHbfF1doLIRGTwda+tExPnYvf0aOEx35ngqttUsfFR3mi2VpY+5OwlSUjQb/uDUqIpkszj+3IzoT3hWNLodOQPjTOvXzFa1Isf0vaS3eKfl/vEaKB/WfLC3CQn/PUpJ/bm4+wSRFCFfbRQKMpnFTd5JV8fnxxx5YDZbqgNAaCW/YM4TZIORDE8JG2n3o1yPd75rmv/IY2Jx5I8XhV2cPKUDGDdWzQ2tJpemOZbuzx1zRz/NuZ2LAN0yeTc7d/mzHySjoXC8NRaaEj0if9pOxwrWXlcw9YIxILWnHY5XdPXofpGtkFiBKRR12og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpi/qM6YLD7YWQMg2QpfTIJSahLy9kA4UyExTNQptLg=;
 b=wNJ9tqijAlN046V25mMAKTQXFUcbYXwwdDIMnyxSEpFt6jRKp3GfFEer8yaJml49obHFYpiemQGEfP16jZhk8133nZBvXAZUxEFX8zamgplkLTVdDgrk+wOn/vodD3coKpXTzox+jxLrDH4YxZ6C6/RhvIRtY1G6AfsLXSAz1qk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW6PR10MB7616.namprd10.prod.outlook.com (2603:10b6:303:249::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 10:41:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 10:41:47 +0000
Date: Fri, 1 Aug 2025 11:41:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: change vma_start_read() to drop RCU lock on
 failure
Message-ID: <4dd77a95-1528-4289-b94d-a4da6b6975cf@lucifer.local>
References: <20250731013405.4066346-1-surenb@google.com>
 <20250731013405.4066346-2-surenb@google.com>
 <6b0425c6-799e-4ff5-9238-66d8c5d49e0c@lucifer.local>
 <CAJuCfpEyh64aHhBFkFt6_u3f9sk1RXBd4Xxy80voMsyy7Unpsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEyh64aHhBFkFt6_u3f9sk1RXBd4Xxy80voMsyy7Unpsg@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0034.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW6PR10MB7616:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c060fbe-8ab0-4064-45c8-08ddd0e80404
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3RNdURQazQ2aVFUSDZCQXVOOWlQM1JwQmdBaUZwU1FhMWF6UGRCTGZ4MVVG?=
 =?utf-8?B?alkvWHlQTytCV1JTUEFmT3FKSHJXR1lheHNiaW9ja0pOeVo0ZlpqYlU4amlk?=
 =?utf-8?B?b2Rkd1lybWRTUGhHL3R2SlNYWFZELytKTU5Za3hkZCtYaG93RWpOUCtJc1lE?=
 =?utf-8?B?dzNFZW5oVU5EYzZ0eUdja0RJSm1BbktvSllRWnhJZ2hzSE9DUTRuNHVtTTBw?=
 =?utf-8?B?a1B5NjdsVFNRRVBpaUZoQTUwTktDTUVOUlNsdWtZeUNuNHlhQTh6bzEwcEJj?=
 =?utf-8?B?di8yKzBYRWxQN1BIaHUwcERVOCtNeWZLWFN4V2ozdFEwSElXdjIrbXNCNDc1?=
 =?utf-8?B?NW9mSnpaL2V6NE9GdFQyYU9ZZmppZGd3aE44YUQ1bS96YkZUcUpubFhXMEZp?=
 =?utf-8?B?alFpeTFXVHY4M2E5dzMwejVZTW9GdEh1MUJ4cHppM3lEdmxubTY2NktibUM5?=
 =?utf-8?B?MnREbzNualBOaEQwbkhVOG15aGxEZmI3ZWQ4dWpHVFhsaVlrRE0yOGRWZGl0?=
 =?utf-8?B?OU1HOVhSWTRVQWJKQmlCS0ZHY1p0QjhBMGJMaUU1QUtjejRxRzBxV2I1aGdu?=
 =?utf-8?B?dERwNVZlVmw5T2t1c2Z3LzJ0dHdTMHJ6VU5nNTk3WU94NEtLRXJIUXpTWjFr?=
 =?utf-8?B?VEpuOGxlaTBmeks4NDhNaVBueHkrSk9GenBTT3NNZHB1RGF1WHZvcS9sVGpn?=
 =?utf-8?B?R25yVSsweHNGcE9YYURPREJpWWZPc0ZxUDVVNzBRS0d0aXhyMGxMZmk0TDVq?=
 =?utf-8?B?b1lEMzJRSzVVUnN3Nk5FWDFXditTM3FJUHFqa3h1UTlWTEJQUVZZQkZkL3lM?=
 =?utf-8?B?TE5qSU1CU010YzJQTHU5bER2K29hVzc4cDNRUEZHdHdzRktKMnF4Sm5CZlBD?=
 =?utf-8?B?WVhSdXQ2d3BJVzBoTGFlVllyRzMwZFoxMytlWW4zUHBiWFpYME9nNUdUTndG?=
 =?utf-8?B?MWdzbzlTbmNkR1h3ZFNybkFNM3puMHJzSjVzMlpxZ0VKeklhUmN1SUJ0SVdH?=
 =?utf-8?B?YkR5TWQrcGIwajMrK21qZ0NjaG1tYS84MVQwRGhLZDZwYmQxZ1JhaTI1aEI5?=
 =?utf-8?B?eWtUTjJqU2pVV1o5dmhzU1hLZm1qc1pvVUt2NkZjcG44WFdsa3U3NzhPZHpX?=
 =?utf-8?B?S1pYTXZVOW1yN1p0QkI4NDgvc2MxZWVOQzkwMitxNDJKdnk3TGYycndNU2pn?=
 =?utf-8?B?dWllYTBub2lQcHF5WUYyVTVFWnFVSEFiNjFwUTB3a2RkZWZZMWNHcnpKcXo3?=
 =?utf-8?B?QVgxRUtYNDhERkJrTTdJRCtqRnpJejRacmxhQm5GOUdHcmxuY3daUENwMEtx?=
 =?utf-8?B?dVJrVHpHZk5ZZ2JXUHd4eE5rOVBwYUdOTGdQbk1UZllGZ2RLL1Fva1pRVGRh?=
 =?utf-8?B?UFp1SjVMU1Y1cGsvaGFFOFpLNUJOai83bnR5Y3NqRDljV0M0ZHdaNEJuZkJR?=
 =?utf-8?B?eXZ1ZnBDci9kblMvVlFXQzhWK2FkU1NVZ3N2MFFNQ0MzMFlJbEpad1dRWlNQ?=
 =?utf-8?B?alRHcjJIVElpNmh6ZGVvc1VwQ3lPME01OVQxUGR2VVJOcjZBckQ0QUQxUHc0?=
 =?utf-8?B?MkhSOU9XaFMyT0l2NDF3bEpZcG1VWk82d010VXl0TE1uaHhqbWlmcEwvbXE2?=
 =?utf-8?B?V1VWNExHY3dmTHJUSzk2dmFML1c4NGZGZWk3ZkxUdzlVQnZ0aGF0SUlZQ2hh?=
 =?utf-8?B?d0ExdlljY1BOVGp6S3BwZEkwdzZVWlYrL1hIUFViY04xc2dXanhhRWxwazFN?=
 =?utf-8?B?dFE2OVNNVThrYnlIWDRBbzhsN3pzTEx0Q01ORjFjdndaZlNWUWFMc2Vtb2N4?=
 =?utf-8?B?aWZNZ0JTcVJad0FlV2JFeTg0STFWc3NtbFpsV0lBTW5DSFFsRWtveDFrckJP?=
 =?utf-8?B?anlWV25hNHlwRXp1RndSOHdHRVJxaEc0aHdmS3Q5N3Z5V1BzUmo1Q2lySnFi?=
 =?utf-8?Q?JJhVqmk2EyI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXhjWWI5QTFoVXJqeXQ4VGR6VHk5RjBWNTFOaFRHRDZycUliY0FGUjRHeklq?=
 =?utf-8?B?TTlybXpyeEZKaXpOODJDcko0NWdBb1BCVFdLRndIb0ZhTitpZ212TTNNTWpP?=
 =?utf-8?B?VlNEMDMyNnhITGZNcDk1SkJqWkR2QXlIQ1hHQ1BSOUhYLzBVQVk0cWN0V0Q0?=
 =?utf-8?B?anJpS0F2QXJTTmhtNTAyMEpZbzBnSHp3LzB2WlZQTnFEWEozZmNZNWtES2JO?=
 =?utf-8?B?bGpwaEpnQzhMcUJIWHRmK3lCbThkallpdUVITGRKZGtPTDZTUWxPeTFFRjJI?=
 =?utf-8?B?Tlp4bXNXR2xFcTBkcG1XRjcxY2lJOUk3Q1U4UktpNFFRL1NGRE1XQm9QT0h6?=
 =?utf-8?B?SXE4QWJFZk1tZHFRTkhCR1d2aFJVaUZHYkJHVTJHUHV3YS9xTWgwUGU1Qjg3?=
 =?utf-8?B?UnRDSzJ5Y0VKUkl4L1gvTjMvS29Bbm82TlFQNWpzbU96NkVYc3NONGVsMm1s?=
 =?utf-8?B?ZDlsVlNpZUJ5Y2E4TEd3QUN5M2ZOczJiWXpOS0tWM3Y3aTZOYTRNOHhzSDlP?=
 =?utf-8?B?MzF4V3BJbXN2RVNTUXRGVjNUcHh4emx3dGl1WlN5UWU0b2Rlam96M1VGejBN?=
 =?utf-8?B?anAvUE1hQ0dhaGwyOUhZcDQxOEloNCtBclFnM3Nvd0FaSW9ncHZLQ3lRYUpw?=
 =?utf-8?B?VitEMjF4eG1oRkVYaUNBRERWdEF5bWQ0ZEttOWs0QVVFOVdOc29Jb0Z3S1ly?=
 =?utf-8?B?b1NLbE56Y1h5UzFlMU1RUjhMekJXbXQ5QllxMEFuSHVJOUlQRTN1eTZrbVZB?=
 =?utf-8?B?c3JpQ2RFdXAxUXhRb2crTkNsT25NbXlaRXNYSlQwQjZjTUY5VWFsbWplT2to?=
 =?utf-8?B?WlRVcmc0TXJUVTR2Si9WMTNPUWlpYnRHbDg3ZlgyQTBDZjFpYm9TS085cDV5?=
 =?utf-8?B?KzdRZ29wdzRod3NvV0VzTnNKdkt3OWJENFZaaFBHK0VsWG01Qk9Id2RYS25a?=
 =?utf-8?B?K0RuNnNEaFZySXFqRzVtZzJoU0t4TEZwUHl2WG1TdDJ3YkJsRTV6Y1E4dE1F?=
 =?utf-8?B?M0oxMTRUblJOdWo1anV6dnVMK29CcldhcGZOUURPVk4zWm9jRDJPeldrb1hN?=
 =?utf-8?B?MjJ3dWlRNy8zL2JhWnRhVXE4NVhESnlyRDEwVW1Ed3ZnVzR3bmdnNHhuSy80?=
 =?utf-8?B?eUdyL29vYStXaWI4N3RaemJKVkw1NENZdkJxV0lpV3d6VGV4R1pQRHM5WDNy?=
 =?utf-8?B?aDA1TFlDT0tEL0ZjdUpDaVd5dkUxbFVNQm0raG9FRTExTWxnWWpoQzhxeGs3?=
 =?utf-8?B?eHFRVkpKRzRCZ1VtRi83d3AveThzQTRxTExzL0F4a2lZaXFUQ0FOS05aSGNq?=
 =?utf-8?B?RmJDOHF0UG1GbEhpbmE0Q0c3bTFYQitLQmhWU0dsNWI0R3hXRXFVdGp1OXFl?=
 =?utf-8?B?MkQ3SnJIMUhqTjc5dFpTK284K1hBUEJDUC9JbDlPZEwxY0VxQXJIdGh0YXNi?=
 =?utf-8?B?aCsxUjZRNVBSVm51ZmVmTzVSNXY3UXJMeHkzcUJkQldaRllBTk5IMmhBaXpW?=
 =?utf-8?B?NVYyUElJNXRPeGNmVGRCNnltUE1kWlBiN2lJdjdmZzhlRThhQnhGVWRLRGEz?=
 =?utf-8?B?UklEZjdiTUNCVWtKYTNDT0hic2xjQUp1d3pyeXRQUHc2MjBuZUVNMnBYYW9H?=
 =?utf-8?B?aThaLysxamJPaEJlSE5pQ2Jzcm1QaXpGN09lQkh5dUJ5ck43eXQ0RFMvNC9y?=
 =?utf-8?B?L3UzNUlBYlpFSDJBQnVJRHpHdDdIZ1hJSmRlUWN5b0VhN0YxVEV2NzJSZ0pG?=
 =?utf-8?B?R3lsclpWQTl6K2g5aUErREJxcmN6ZE1yRVRYNWYrQlZtSy9ENWZtQURmSkdl?=
 =?utf-8?B?dUt6MmdEZCtJN0ttM1Bud2oySW1mVUFDeVFvQTBqbm5zL3NmVTdSKy9vMXIw?=
 =?utf-8?B?M1pmbEZ2MGgxTyt4STFjZlQzdkpKSVMxUFZSdVlYTWdNMUxnN3hlMDNlcllk?=
 =?utf-8?B?NHRqOWVqc0NXbkJnNFlDSjBmMi9TeFpReklnWTFHTVNWZWZXNGR2c2kzd1hY?=
 =?utf-8?B?UlNWOVNsY2ZoUlVJcXJvWmlYRk50VEU3MER3bHZ4ckYyWFZHcHczeGlrSzE3?=
 =?utf-8?B?TjRueERwOGtXbWtRWVJCQlQrN2Y2ZjIzd3V4bDMvaXFkSFV2eUdZVDdpQ1l3?=
 =?utf-8?B?WW5YOThTL2c5NCtCSlZGWjdIM1dxVHpUVFZmRkhTbXkzT3liRGNGditwdUgr?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v0+oYGZmg27IMUpDW/KGroxblTgitiAc7tlD3fQejjZtrgz+xu48WZsgQJYLOXXv0K2j02+st/ViBjhrTb8VVqrepy/2Lj1N+hEEw96A58i+Ve1JM/PJUSp5j/rmPtDpH0cvr8tY+8D4IMEqany/v/td2olSoE/n/RH/fWCuOivrgPaA93kXd9gRbgd2FPS3k0zd80Vyza1peyxE3yF+JuAkFVVW+oyAv81XzesrfIfzb1x6FlYHx+TqpaYG40SOjNUdDQVLcVR6V29vckn0gbnAA12NnvTDpVcOL+65H3NYGWdJFD6MZXGDFvVbPH6E6WTINkKp8JjFXcbP5xCAt62YWqCpX17FDCs0Hb+bx8bXWfN4TwhMvnpBmoNDE+Rl8fs4fF8c/nYwlAZoenyU8uL5/eASWa46JZr4zpuXcrNYyNqHzHZ9XwIHpvIdOK2/OOWWmm667V4hlK6s3ygOjEB38tyetve08CuzVt5BkdZzFNgh3AEMYUOi7ALOMNbJZ7uA7+heDNxJo8pyxZ3ZT4oUjPIJZANyMmvwH7sZY8bVRbv8ZzLVSLm74ybY/zUULkP/B4x1npf1XEGfav4YFQp75/PAHOcP0ZGWwLg5kIo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c060fbe-8ab0-4064-45c8-08ddd0e80404
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 10:41:47.6669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txcEYbvV0ABqEKF1VnX7Q2mbxgvoTXt41PRzpl457jVsXAGY9t9XaWaeqBCvGCR/SpeLYWehQJ3b8oXKuMbflDZJbrq4i8SIC1NHGT4nkzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_03,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508010079
X-Authority-Analysis: v=2.4 cv=COwqXQrD c=1 sm=1 tr=0 ts=688c99f2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=ehJHg7g9-ebLXvxkO_QA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12071
X-Proofpoint-ORIG-GUID: s-sNzoAxJOlTXxpqGDTh_3-oNaTUbaky
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDA3OSBTYWx0ZWRfX0o5b0SN/uP/e
 9mTAtTW7teAUOQ7nW0tmT5OvYaVtM9eDixKWsgsbltEQrw630Ak2mgZVaN3J4vxwgrPFozRPqYw
 qCv6ZN97Bado0ukeqpzp0apnHrozmJHLAd5HKh64QBAZnFIHhS+ZvEA+Q+xDPD7BCO3L8tPlf8F
 8vmJTSHdLgFEBi2OOa++ZIX99oxAnEfGGTFEnIShKe9KeBfIU7GleMvWmLxPve/kNCStdHFqNfA
 hW5TiHSc5C90J5mheZOgd2jRB1Hn892FeXQWrTy7g251YmPcAtFbibpWvwQXUf7FoqXQNRfIx4/
 rdNY7qjFKuKTIsMjwExy2XbX3BztF+X8kPD36N5I4pDtb2XQbcLXr3rp914nQNXUc9nImkd0dl4
 RMjuvsgpA3BeCK0utvL2k2VlvVNNwBs8OmUMDgA6GSOw3VQ2cbdsqaKH9rrtMkhD+tM6aZ1E
X-Proofpoint-GUID: s-sNzoAxJOlTXxpqGDTh_3-oNaTUbaky
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65E4F180008
X-Stat-Signature: rphzknczbznk3ojburjmscp37ak7k8bf
X-Rspam-User: 
X-HE-Tag: 1754044917-483226
X-HE-Meta: U2FsdGVkX1+GQ6yL/O4+mOZPIGeUQbtJNsYucXJN0VOdWUyoDASvUq24gTUGelNvW6O/ZkFE8gXB71+K4HDsfhk7KU6polsefGbWfrPTjDID+r/v3klXtBfAXUfawTJtujODHpshxDW+ldus8KkAwT2ND2RAqCG/dwfHDu/JWQJGRaPmCGt0ezn7l9paHeyakssgHTuUIV+ZrdmZxX/ZTXn9AODxLNIE4HZeFUBy/dOVulwm9ZYBySv1g2bCKEgbW88keSQVgKj70WgEn+l67ZJhJxi+84mWqeR6cF51JMtfPoCgNuaM36sukSrUPXa3K9xTW+ayXFO1+Wt4DxzEbCSixIVVfuQVk6eAgBUfNGDjdZDSL7H+oYYOSRKeiy8CIPxvpQrHB+MxDx3DuhoFqNZpqSbWMINXS6WqhLKXZLE944LD4y4+iA/A/VbUFiAuG5Ok04AKbAVPe1Ody+G62LR/JQFQPY6gq3qZzH88vDgUqKIQ/7r5ubYtgX9pBE/g3uzha9XAXbdUgwasG+WTbRXSX5JwZPzrUPgB9BBzLmRp1aPkIwXWD0yWmi83zuAbvpsVH7KBQG9swYsb6MyTUSkOhrG41MWLS7eOTeq1JYFHjKtAz0t7u0+FD8mBtgyjeBwIVOMdlmKmJgV4QrIfufFMf7ozrwPaAdgRUQ9pqs39EFbQYprI6leq6PYNHG70Z9Hg6qUzVIdsmRY6gYdmL9Iig274WaD7JTP4b+pjAcHL6T650hQ9gkvWUdfk8pmmSYGH9m1+8/3AqtT5XWA3/sub/kYd61N9HQjYHNkaxclP5IXaKq/+QDUveTxo9n/vJZ4fPUGmWBfbmcRqFQhP6u6U3Iew2agJSz0JJajsK0hHQtvziIxO+s5rV9dFxM1aO7uPq8IeNVqBhb1fLUgxOKW2UCzjFePDUIm2boiuR/Y5NIfsYB0Dl/i7JyfI8fvKoG2SjddKYir+HqWWK1d
 Ph8AhbjE
 K1c0B7fs9KkJhEgH16JgQuQEEhSpgNITEiotbrlaxB8bBlX3TwFGmYvLteZVZNvOnSH7roOoh5EyJ0nnufXq01WEIgppQAcWJmAwudIrMrNyX1GSPtc2sslcbRQLhG38bS4yhKhXapDWZgw6HJlWAi83fncz3oaztXo+bMNIgg+hg0/hnQcfvgtbknUKdsSp33omWWwAAsE7FMeSyHheg9Z1HxrfctJErP73aGsv1jACxPFLaf4OXJH/3IUOh57vTOWpxfhSi0Ze7nC0z0Rd9DqWHvuWyizEzXjstMNY5diFOs+Uv5gEPUNXue0IHLRYqFIq6B4CE8pymUMcqIFvAk6Y2uAoj2dm+KE8t6siuaPbvgq58mvHwmOMaQwXr9FUGRSPG+ixOS5ICcrk3g7jeqLEfxMwJUhIwAEHWThIkMrM7U7nplpFqjf3Y1/AyUyFKgWFYZE6e/zVy1pUwOst7mMZysBZbur4ACKdRHWk6RxvUBpg0jwpiLh06rEBwlLMGD8bKPV1YOeiMM/ri7zsLBSP5sjewxtb34Y/+ER7I1Zqc+1LVyQNjzIxrn/ied+CadB0J7rjrMZNMt1LJqf6lAgly8Ox7duMGO5+P4YWi40soaMUxJnZGvuKi3Ii0qrZgDmMgypq+zUkhr0rRWCJFUWWaPoKFxiwLrxhEyotrshWYHtdZdAYIsNn6oLPhAIaPjyW1zW///01qSZbOeQ41NYZTp/6wkkU2M2y+XxgP2b9sDJQFpbFO30iciIVQtu5DilFYN5uZCxKyPr54RlTbz+HLQVlHQXYsrUiEnXPic6dI6vRQgmYdMaM2s8tuOW+BQrP2spSXtfAnInA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 07:06:41AM -0700, Suren Baghdasaryan wrote:
> On Thu, Jul 31, 2025 at 4:49 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > So this patch is broken :P
>
> Ugh, sorry about that. I must have had lockdep disabled when testing this...

No worries, curiously it doesn't seem to be lockdep that picked this up. RCU
tiny doesn't seem to do this so perhaps you somehow had this enabled? Not sure,
strange one!

[snip]

> > > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  mm/mmap_lock.c | 76 +++++++++++++++++++++++++++++---------------------
> > >  1 file changed, 44 insertions(+), 32 deletions(-)
> > >
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index 10826f347a9f..0129db8f652f 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -136,15 +136,21 @@ void vma_mark_detached(struct vm_area_struct *vma)
> > >   * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
> > >   * detached.
> > >   *
> > > - * WARNING! The vma passed to this function cannot be used if the function
> > > - * fails to lock it because in certain cases RCU lock is dropped and then
> > > - * reacquired. Once RCU lock is dropped the vma can be concurently freed.
> > > + * WARNING! On entrance to this function RCU read lock should be held and it
> > > + * is released if function fails to lock the vma, therefore vma passed to this
> > > + * function cannot be used if the function fails to lock it.
> > > + * When vma is successfully locked, RCU read lock is kept intact and RCU read
> > > + * session is not interrupted. This is important when locking is done while
> > > + * walking the vma tree under RCU using vma_iterator because if the RCU lock
> > > + * is dropped, the iterator becomes invalid.
> > >   */
> >
> > I feel like this is a bit of a wall of noise, can we add a clearly separated line like:
> >
> >         ...
> >         *
> >
> >         * IMPORTANT: RCU lock must be held upon entering the function, but
> >         *            upon error IT IS RELEASED. The caller must handle this
> >         *            correctly.
> >         */
>
> Are you suggesting to replace my comment or amend it with this one? I
> think the answer is "replace" but I want to confirm.

Oh no, amend is fine!

I see you sent a v2 so will check that :P

[snip]

> > >  /*
> > > @@ -223,8 +233,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> > >       MA_STATE(mas, &mm->mm_mt, address, address);
> > >       struct vm_area_struct *vma;
> > >
> > > -     rcu_read_lock();
> > >  retry:
> > > +     rcu_read_lock();
> > >       vma = mas_walk(&mas);
> > >       if (!vma)
> > >               goto inval;
> >                 ^
> >                 |---- this is incorrect, you took the RCU read lock above, but you don't unlock... :)
> >
> > You can fix easily with:
> >
> >         if (!vma) {
> >                 rcu_read_unlock();
> >                 goto inval;
> >         }
> >
> > Which fixes the issue locally for me.
>
> Yes, I overlooked that here we did not yet attempt to lock the vma. Will fix.
> Thanks!

Yeah easy one to miss!

This stuff is very subtle, but I hope that when I finally get VMA lock 'extra
docs' done (really written for us, or rather mm kernel devs, than for kernel
devs more broadly) we can help address some of the subtle aspects.

In reality of course, my main motivation with that is to ensure _I_ have docs I
can go reference when needed :P

[snip]

Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78EC5C47BC2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 07:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE286B008A; Tue,  6 Jan 2026 02:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B7D6B0093; Tue,  6 Jan 2026 02:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7192F6B0095; Tue,  6 Jan 2026 02:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5BA6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:35:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED4C016044B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:35:58 +0000 (UTC)
X-FDA: 84300729996.20.303A1AF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A711180004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:35:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c71q1rB8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=epVI38WB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767684955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijN644InEQPhBXkz1GKRgicqnhljsx4RYfKp7mfAvh8=;
	b=PUAP1MXWcWScCYX0w8ra1ja/VlBXHfRSLPT7Vtib32iQ2jz+0Wb/XDJXL/QKVp7/mGzgvo
	vfj0DH3e39xVsTMo/JzqGHUZUfwncRmJc0MzqHTMGFdu+99u0rLlxUjHATrRGMMLFx6rR5
	J1U36GK+y55/vU0h6Chp26GzoXLByFE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c71q1rB8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=epVI38WB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767684955; a=rsa-sha256;
	cv=pass;
	b=CERchHo0KyD7zsuXnhDXRmRHpwgJF3YF5jZUK/Hnm/BY8gkG4rDd9YYNG/WXWBWjXy5jSG
	g2m+PHtwNX79ZtwVbi7Ntch1RUlIreE94Vj4YsZRR93c+t1fNAwWXlAVf7jAffOeta2o7B
	kY+vbihz06CWEMR2/7IywLOvLqFKV1w=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6067R9iB3291410;
	Tue, 6 Jan 2026 07:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ijN644InEQPhBXkz1GKRgicqnhljsx4RYfKp7mfAvh8=; b=
	c71q1rB8a0rrUwHrLDCqf8CS5FmT47jZH19JuKvYvVVDuy+UntyuHmG1Qs86U7AO
	9TcXcAnuk0c/SoQKTUuSIdjKDvqsq2N2BJTOC8Wc1/4VnARozzSY91CIvyepPAqW
	WtrQwNbHAxuiMf6ZaK6ZFiu6ep21yNsOj4JnMhumpNmL0X+7OlD+koPDpKQi96VE
	bFYmbmScqgk5g33V2TvjVueC0watQaybZ68UmYmmBjy0kwievMdCRckZyeTLmwFA
	FJg7ob3TmcpV/LTr40thfOzBhGJo8lzMOgbylZ+jnwinlAysTUk1lnY/+87vVmoY
	mAdcyval1HXkSH6K0vLstQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgx04006f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 07:35:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6067BDQ3030794;
	Tue, 6 Jan 2026 07:35:26 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjca6va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 07:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9bRJhPKJTBqTGiuAY0i6O+QUzSi2Yp8yquecsZ/1jsLQIwrQ6Ecgr7kykS2SlxPoWMgsnMHD9IAIGNj/FiyK3smMc2BJd2bMEA50M6GkYegeskJd9TO1VYpr0upCxdJaHD9VqzqCiQvFhPUQC3y82XFldHD1llpc1w2fSvrCWuDjf3SuTRi6YFpzASPHiUH3iMQ+urK1uzJCuwHUfcVP0JoKxteSkH2yJ94QB7HFF2VwePB6kp/R9RWr/6p8pfl57f7ZiF1GKIEqRdO5tzyTu09/w6QYpu+YbNCycCEHwbJlKw/r2SzJ+ka6s8DAWXjSCEmKriBngmb35qpafdQbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijN644InEQPhBXkz1GKRgicqnhljsx4RYfKp7mfAvh8=;
 b=Iy+pUIBDMv9bDLct9AgJ/B6sbPEeqbnK1P9CQCnk66h7wc7iZtgL2u3CEzuMF9ss1wJYNJl0yzDWbCgn4bh7fhisJShc/nHTVbr8UAD6bqKrgYh6m2g8q/KGULdWS3AeqgYMJzCLc+pZtXCPxhRyjRvj3L6oiaNVKbUrZwqc18FwhZPQez3z6BJl1bUbvqjhBN7ItwS+Wy6XwkLh3+fWdFXP5SIDuOGNyE1KOz9E7dXlBKbUnHz/7abC63N+9nlhJgWj1mfrMD9yFszY7OVumsGI+7RqeaZM4HsMeqv42QdYnLusvqWBC8mI9m/oOk/mPnivYSGrS/XddDmaqxmBHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijN644InEQPhBXkz1GKRgicqnhljsx4RYfKp7mfAvh8=;
 b=epVI38WBNgYcnVsO179Do8fl4n45fS77N+C/e3+O9Ir0SvCBzqnLK1s+rO+a3bP4nBlGXlCTRFLkq1F0fw62pyw3I5deMsdfrGefeIiEsNXLaw2nwNgiMBfSdw+ivqO0iK62VAvfr3/DWH0P+5a+X5HAzUdWbvFhqwyejHr4XHM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN7PR10MB6522.namprd10.prod.outlook.com (2603:10b6:806:2a5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 07:35:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 07:35:23 +0000
Date: Tue, 6 Jan 2026 16:35:11 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com,
        david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
Message-ID: <aVy7L-3pc4JUYBEn@hyeyoo>
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo>
 <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
 <aVHWOMa9n40_8Yu3@hyeyoo>
 <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
 <aVSojEWdFPsb1fg7@hyeyoo>
 <CACw3F51ZnjaHtsorT0ao8S5K8Tvzgqb6fT9hr-WBavkqivz+BQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F51ZnjaHtsorT0ao8S5K8Tvzgqb6fT9hr-WBavkqivz+BQ@mail.gmail.com>
X-ClientProxiedBy: SEWP216CA0136.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN7PR10MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9611bb-6551-40dc-798b-08de4cf626d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTE0MFg3ZU1TdkM1cWRxckNKTG1jL21iaWplMU1Ha3dDZ0UxV3lPQTdKZEhj?=
 =?utf-8?B?L0traW96VFZLWDQvMTNMRi9VR20xVyt3c2p1YXZBK3RwUHdZVi9wQzU5MU93?=
 =?utf-8?B?VTRLbXpFcUs3RHphcDh4dW1laTBqTVRpOHIrZzBaSXpINUpLMS90SFhERGkv?=
 =?utf-8?B?TG9TTmw4WUl0Y3pjVXhlMmEwRTFOb2ZMTWlmSFF4T1BXM2RTbEFYTUI1UHN5?=
 =?utf-8?B?bkhKalBPcEw1TURpUEhkNURTOVVvV1ppRElKVW4wclZyRlJGc1VDeCsxSjlW?=
 =?utf-8?B?WVVEL0xpM1Q5MFBWaWdSY1BVTHBxc1k1dW1oWVBaemJNeHlZWlNlblFBc0lT?=
 =?utf-8?B?ajh3cmhGb1ljUlNXdVp2MGtQNWRqRGd4NE1kODhDK2t1KzU0LzVwZktrdFY2?=
 =?utf-8?B?NUs0Q01HbXErYzExZ3lFSlE1ZUpHUThhbDBtZ2hpdElodGxDaXJhVzNjKzZR?=
 =?utf-8?B?YmdKUUhFa2pHQWczMEVxUzhWMWpCcWRCeUdUQW1hUHVDOXMzOGR5b3c4T3VC?=
 =?utf-8?B?VTFveW9GRDYwMVFaU3d0dDlxRXMzRFNuTm5JRDJUeWpIRGpGOXBqcm90dC9X?=
 =?utf-8?B?NWRkc1ZuZElOanQ1MXM3amZGZ3NOMi9lK1RYdkF1Z3AzMjNRRUdIWmhCTFNH?=
 =?utf-8?B?V2V4R0s0bGgyR1NCVzhrTVpob0krbnlyOGZOOExHTzNZSWJDaFc4T2hnem9y?=
 =?utf-8?B?UHUxWFFWVTVYRm9PaThCUE0yQjRCVkNNL0JRbFY5NDB4UGc1WndyRGtpQ0pl?=
 =?utf-8?B?YU9TeVFRTjd4NUhITSsxZzFiZGdQRGRmRVlHczEzT1llZE9iM09EYVZ4N2tu?=
 =?utf-8?B?dy9zRTJZM3kyN09FREZ2di8xU3cxdWtkRTJYMWJ0KzF4N3FzSEZqajZ6RnRP?=
 =?utf-8?B?Zzc3UkNOWVVjMDN5RzYraWpaM1VWMVg0SGhrdjN6K051dklZZjhIc2J6dy94?=
 =?utf-8?B?eDlNd3E4SFZOdkJrdEtWSEtJWjN2eG5HWCtnVGNBWlpLSUZjS1BKT2p5UU12?=
 =?utf-8?B?VEVJTnFIdWdFS0pENHNuVDZyN3BQYXJVdEt0b3E3U3MrTUpRVFRVclFNdDNW?=
 =?utf-8?B?alI5MEE0aVBjSkJMODYzTnArUUJJbC9kZmdlWnM0dkc5S3lsenhGWG0wK09Z?=
 =?utf-8?B?U1BOZUFleWVoUlNSekFldlgrU2htVjhuQXp5SERENzYxTkEvVHJubXRBTXBI?=
 =?utf-8?B?MXV4cExNcGlpV29zNzNtWHA3Rm5PSXl6KzZtbUtqV21rdzJqRVdJcFBpemNR?=
 =?utf-8?B?cGgrR3VyUXpFRS8wNWZmaE5xV0lUc0VxWjN4SDZUN0pCNncvbEFPTEpwdHZ1?=
 =?utf-8?B?WE4wWkw2Y0YyOEpUbkppNFk1LzdpczhoTS80VXhrSERjRWdDaEFTMitpNFhy?=
 =?utf-8?B?Si94TnZKRk5xclNsZndrMzMrRTM3TTU4M1BEU1QxenB1UDhaQ0hvQVNNaXFs?=
 =?utf-8?B?T0ptNHVjWlZwZXNrcTI4K25XUmYyY1hDVHFQaWNVeTRXK0dnU0h2bGR4OGlI?=
 =?utf-8?B?cjl4aEZvcEE3cUExMXJNTGc0S1ZRT2szN0RIb3h6dGQzdGNPQUR1YWV4V01I?=
 =?utf-8?B?UWczNmNoUVlKbWNBanJxZkE4SmZTL3dxbm1WRnBzVFp6czNaWEJlRlRBRllS?=
 =?utf-8?B?UTAxTkh0UDhzRUxrYU5VMHMrbGhYMWV5aVU2ZFNQU2JwYUZSRTZjMnhRQVh1?=
 =?utf-8?B?bjRDYTJCcFZDb21rN2VzOGg3Vkx2RVJ4ZWk3RVM1THhoUE1KQlM2VmhRVXpD?=
 =?utf-8?B?VWU4OVkvMHBJaVRQVis5QzlidytIcVFSWTVKTUtNMXo3dTJpYzFlQ0I3bnFa?=
 =?utf-8?B?YWcrZ2gvY2VndGd2Y1o1ZHZGTlppRG5Ra1BTeTl2ZU9EaFo0ek55Q1pVZnFy?=
 =?utf-8?B?ZEN5a0cwK2lTV3NkUitVeDJoMHhvVGhXVzlkN3JYZklpelkzOVJyM0RZanVC?=
 =?utf-8?Q?AWhzhqT02Q0CNJNe+eoAxkcapbkfLhg5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzNSNytZQkdKTjhTVXV4aGcza0hMSGZKL05iVlNuRDl2SElXZGNwbmlVTk5E?=
 =?utf-8?B?TUVsdE82SWpWZGEyaHl0UnRkZU5IK2p0eVlVOG01S0hLM0dkWVJTWC85ZytD?=
 =?utf-8?B?VGhwWUJmZ0lzTlVYb2VVdWg3WDBlRkJiaFJBQ1ZXR01WazNBNWtnR1ZlNzh6?=
 =?utf-8?B?dVZiemNQa2YwY2d3SUNwdzdaeVZzQk4ybm9CZGZvRVZmK0t4Qm5FQklMcnpt?=
 =?utf-8?B?NVYzSmJUcjdZZDlzRVZ6dmZjWjJ5bjRBdjFweXdjVGo2bjk5RlJkR2dPNy9K?=
 =?utf-8?B?NnhCQjlyelNnR2pCMGltTFEwVjU5QngwK1RveTNyVnVkRXNOQ2tkUTQyM0J2?=
 =?utf-8?B?SEhPd3NFYmJSaC82VFJZcllxWEx1Y2M3aERyVVFNQ0xjMHB3QVZMOFEyMXdB?=
 =?utf-8?B?RCtqR2ZtSkJDU0NXaGMxT3l5ak9ORHg4Z1llKzNGVlZZbTB6Rmc2QWJ3enJ0?=
 =?utf-8?B?SmRYWDZlTVdmS2RXbkJHeUlFUHlaL25VMnhBRzVFdWFIYUZFMHpXNXp5cjNR?=
 =?utf-8?B?cFlIRTFKK2tTdHhVcG1uWlAzRjFyNGs1U2JrNWpmWjdvMWYzQ2x3dmpFZ0Nw?=
 =?utf-8?B?U2ZEVEczckl2YzFrN1E0RFprZkFWZWNIcEFJaHdOUUcweXFyLzQxaHdXRWNa?=
 =?utf-8?B?UGF2QU9pZTBaUWxDSEtmQW1ZNFhUQ3ZIbkliRkhiZjRjUE1uRk44L2QvMTNu?=
 =?utf-8?B?UlZvU256djZVOGNhOUEzN1YyVWJyK0ZleGNSaU1IQjYyNDlZUDBLVzQwQ0s4?=
 =?utf-8?B?TmVOajRaNTlSTE9LSWIrOFZmL1RYVVNWNDkwR29SZmxtMXVUMWFST0NkRDhr?=
 =?utf-8?B?L0gwbHlsZ3VCOGNxUE40V2puS2haZ01JUGloWVNPZ0FBQm9qSnBFUXNLZFVy?=
 =?utf-8?B?d0JsNHVVckJKWFNKWVVHVG9BRTE3ZVZ0bi84YnZ1Zzc2dUtndno4b0YxUFJ5?=
 =?utf-8?B?TERtNjhVRzIzNjYvc3o4M05XN1NpWHU1ODdJb0dqNUlxQ1JRcDI3L3FPYkZI?=
 =?utf-8?B?NGlrTVBvcXU1akNoUVpSKzN1WmNIWnBaZTZQUDFhYWxwdS9TL2ZuaUo3R2h1?=
 =?utf-8?B?ZG5iVWFmaTl0RG03dy9ldUp6MUxveHZBbFdEWFQvUWpUeXIrOWE1dzFiZ3ZY?=
 =?utf-8?B?U1B2cS9JNHdyVU9xOUVoT1RFNlVMd3Rld0hyMm43eUJDbUxwSDFGSWZIVWhm?=
 =?utf-8?B?a2luK0RjMUVrYkkzZFZ4QVlTYTlvQmc1MDVTOU44UVhmMERyRWgzTFZXTThu?=
 =?utf-8?B?QUVnalFhMXVRZUNoVXhzOW5rUmI1OFZ6ZlZMbHhNY2hwOENxMTdMQW1IRmtG?=
 =?utf-8?B?Q2RhVVhBcWVRQ3I4VUVUT2ZMdGJLbHd1NkFDdmVDK0dtdFEyTkRYWEQxYmxN?=
 =?utf-8?B?NXlrbjVxTm5LV3hWRHNHTXpkcmhmOG55V2dQNFpvNDNiaXNQcnZhY2M2Ni9L?=
 =?utf-8?B?b2VNVXRzMG9nMUFlQmROMUhldzNMdVFua0xMWmVwV0p0VGEwdUptbDFyL1Fl?=
 =?utf-8?B?TE85YjREMWZpZVdnY08xUnNvL05pUXhNeWVzN0ZCZVllSTluaXdBOHNhbmVz?=
 =?utf-8?B?cHdwaTYwVlpjMlVnV3VKdmsvTnRFeHZaaXFhblhUTk1YNUE3UVB0Wmp4OHZm?=
 =?utf-8?B?YmVaaUJadkdxUTY2Q3dUNE52TkRoYVJmb2gzbmNpRDlacHZ4cndQTDZ1UVFW?=
 =?utf-8?B?OVNib0kycFV5UTdXKzM1cE5xaUw4V0Z2Q2xRRmdQd1pvNW8yVGRIMUcrOFAy?=
 =?utf-8?B?QzBrUWhnekFHNlZzd0x1Z2lFWGYvWVJiWlRXVENRb3dyYVRNR2Q3RnJLaFRm?=
 =?utf-8?B?aGtVVDhTMTlUNG1wM2c2L0c5T2lJSmlRaXgwUmxsNWlHVit5dllWWDVoUnVI?=
 =?utf-8?B?amZhOXhlK01aclhOR1hCaUNQRDE3TG03ZHpvbTljTVkxL1Q0UDJSYVMvdWF4?=
 =?utf-8?B?K3kyYmovM1dLZ2pSK3dwUU0yMmdzT3BiME1IT3BvOThsZUY3ZjVYNWtNK21W?=
 =?utf-8?B?QkJQKzlDTWR2SDVUWTg2RmppWDhpSzczWnNHbDRFNEVGNU4rTHRPUFBlR1RF?=
 =?utf-8?B?cGQyTGRCSk5Ea1hCbHdJMCtrK0plU1FwQk9yWXl4NnVMRWN2MkdNM3ZYWmJs?=
 =?utf-8?B?QzFYRW0zS205a0NkWFBCSEZDRDhhc0I4dVRkeXZVRjJHOFZOaEhBNk1YMlZ6?=
 =?utf-8?B?QTQ1eEdrK0RCS2p3VmozSHpIWStqeW5EQ1hseTBYQUVJK0RORGh3TktzRDkr?=
 =?utf-8?B?eHFjWXFrbUdHNWVRUEliOWlaSmFiVEJmbG5WSW55SFdiZVJveWRFaURYNmNm?=
 =?utf-8?B?bHEwU2VzQ091eGZ5YW84dndMUmlwTTFNNzJCM0dQRUFiUkdvWVVwdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y+XqzgPzL0lpNB+zebm4LsDLoG5PhGsn9MjAEq1rYUIUA7rALtagAqwAWInuOzIrdFj8Jw7Nvhkwv3Ux4dgu8gJqeatEc3hRruz15qFKixO9l5XM4+5fuSrWKxUj4PscFReKlupMp0y0TTbe0QzFsAsZE5D9RhGFEo4dgEPGM8fXUh1foEq6I3JAjmmb1b12TB2mOUVKpjvOLVGgeE/PNnIQ2tpM/rXEEJDOhv2S69YV9v9IgDrDcqWR8TmbHVE1t9FaOnNtAm4XfzIrmwalG2lpFwvrSXp66bx02F+rCUsgyI+cVqUKilMVKNTYJkmh78IIU6WoQQ8fuXpdN6Fv41PpyLwR5ID452LtwgwhfnTKzmBJXkLGZcWQaq6fLsDxIsVC/f6amHEH+C0uL3y1G5qJi9bDHHGof2dSxv43jv01lxbEMfIqWSvrpe2x0pEc3KlUPzhYTuBoGfH+OCME1cY7PSTq+G+y9EDx5iAR/Gr4hKsHfKdHBfcbWpCS/OyF0zdI5PZ0xuqTdK92g3xB1B+/5oe357ITluEuiNp4IVzmkbpvh0fA+43b31sp0zJzotzU60yR1GK/G0UUXniHnGIeGpaZ6QCOJYheTtMcsH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9611bb-6551-40dc-798b-08de4cf626d3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 07:35:23.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6c4f56+D/bglyHvf9EhhYtqml9jIqpZWWG1xBbB6wujDoMhjlEDFjtUmsJ3w4iwLeDCw8a8vBkVLQLyDoS0XQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060062
X-Proofpoint-GUID: O1r2LdCV2-LreFnZZFJ95vHGPoNqeOs1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDA2MyBTYWx0ZWRfX827IBZ/SJkcG
 H8cqPg8hCTxDvdB4vxfRC6YNyXkuSL0xOcMH75DwKai0pqBNsgOE7MKZCilx7ocG/YRFv2MckTQ
 Vo4qBVXISuy3haTtzIhrsjZry7hWCcN4Ws7soJZsvAgHiWMPqyiVdmrVrcFf0xKqCjiM5PYWdKK
 /VnZi9dmMe63fSBhyUFgDIX5yzv2V3HD7GhMT4mTuEH5x4INHUu9zs+X+0fBjk4Ia/eL71kHdP6
 FNqr31SzsC5A9i4SWJl75UmdK1WMsAKz+zoF51sHB2fjyyEVR1+Mc0hBk/uItH+l3Y1qOGXZriR
 BRAqsA5iuII3R3KFSkUaoHMI3qgyk8/Yxk8C9r5n51XxcS/e6OQRbCoZtjXOY2QFy4SUsI2svE7
 +MqvLhgcXB1lLZBwxkCKFiVLSSNEamj+HMkl5/DVc9gNJjcdZnZ3ITzBqWLQ3tr4s085Vd3UzUe
 GlNdeL8ueH99FDaRtpg/gfMyvUkl8xcQZYvahAeI=
X-Authority-Analysis: v=2.4 cv=ENALElZC c=1 sm=1 tr=0 ts=695cbb3f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=ZPXyy27CxYSxdtFPs80A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: O1r2LdCV2-LreFnZZFJ95vHGPoNqeOs1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A711180004
X-Stat-Signature: 4qs5pibi63x87ebztyhh38d5a3suuewg
X-Rspam-User: 
X-HE-Tag: 1767684955-439891
X-HE-Meta: U2FsdGVkX19WkqQO7Etpf8Mw6yoiKZT6VOVi0a25PTQ4PQM2fbqvB65UFRNRF9r8xfZwht1x81fXKjw9YVjShcrF6KQuhWz+ao8FgWfO67tGV7Fbp4dImRb4q22OuzwRFLuiGeIt8v3rlnX7uJPCpmpQmCIWhKWgwC/lbCYX2hb4SgHRaxDrnY9iZRE24cBQ68ZaIZ6OrsRUYLa3OXcMjpcJH10fzMvHe0Cw1bV5hAvguenG12252A8+FBM97R/CrCWqXZ5iINe/J8QwD1HjyYu34CijPlMjoIMO7fXQ5iY4pp9OTta7H94L64j51OkgfEMTyxj2Z/z2bOhdwDu5ba0pXF/M5Cpae7Z4xUiZfn5xhoNOszaFwfXsn8smxp/6z8X/DWdrH1udIWYa805dmXzswb59P7BBqx1dKw/iA56CuvhfYyCkm1GNYb0gPBaQwEfvsJ0wf5EyWbjwrBJH76DKFKXtGLvka9KVkKJf0Rt4duHX04YKWGP2EN0ybytPfXz0q/G0Rsq9pIADz82QEQTRIkxnBrG/TKjB6b8LWL3PlAelcR5gBFW5yj8P+U64HVNyWdZIF0LWQ90SepyoMyBw8gi7FQ/wAIWmGP48XWXwewyc/ztpQcyxVWXQw99Nd+y7VtYt9oM8p9G4qHL7wHpU3mHVaETH9vHeCc1kM6TiyYu+v8bJ18TKSUOXkH0UZaE6ZuGcZNRQ2OCVsz+QbL377NfA1WiaTCg5CRmimYN7RW5yklKncR4P2VMeGEgIYoQMMSmixuG5yVke5oCzkGdJqbdJEsgoQkdPGcR8DnX3t1+KwaxMgSaU/7O3/jgPdEUTwj4Gyu2K8wlzGM5w3Je+0wUUteKXokhsxj/XATaVPgaNPligsMc3Oy0hOkb8EQeLnwU1qDNV+/8XtLBDCZET1m4o4+cYwzy36IRKzbuiZ7DnNaY29D4KCMIpkUqoVes3tYUIctt9V7F65YX
 1mmOOsSa
 1zI0+5ltBkPtXRAHufRmiunVjMkKgOuCPYUX+2gAwqN9BtZ2mLU5+jLBfmrdZ6fj3FeQZlsUZkfgMKucLE/G+u+KPISsuFrsxgPGq42V0DZ+9JZmHnR5qHclZSNqQ8q34szmx2/M4JZ8ysaI2iPIjCeON4Rhkr8J91Rhw4J8rJURCy5x//jz2OOAC9zNgM6nCufXKdDGnBRrExRfrDOQdRqb3kV0Z8HB48W198cHYS4qw5QvTf6JQK9eU3189J04Sen/Xbljf/eiFqicbzruhaoOXvxR20BwKXiN98UKVfnpvd+l2NFAbsNb+J5xLfVLdvz3wu+LkrDJ5Au0POyaLQ4A+4hpKzUiusMrPb9ysylnMZQqw7VJWaRsG25URuoBUor5z5WfOgwQ8aLWB/Sjw8wHcRwUZc5d2xzoUYHhP51W1AZf/oPKqHmM5yFlAJzAxPBmIPdaXbs4KPIs7R++pLtOiCUEvBt0ETds7VdWBMuPUpbZkcVrjLmto0QFEyPCNhh1MSM2Q7FzMK1VHk4TLK3MQ/w+NlPpHcW4zBPMP1ek5C3TFMgeSn8E/U0ElgzODj4n4rQ58qUgK3n+etZK4Iv1tBS3FM1Jxzg6V4w2RovYExyycyE401XCyWmvWHhpmMYBboN3tbBJkZEdgoevF2Y6DbaWVJWuBQwqNVHrPkfu4cFyXDiBAatDKlxRJmnQBocQrdT3lCfnMx1p25SW/pp6ufkWu0B9qi28FV+goem/JVfz3ShDD75TpAqLTPx2RHZcOZBqhCTgKPomnpD010gWOnZ/5OTo9d/3iQPtvzA5Zgqo+/cvp70JuE8XD2GD4wxKT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 07:40:00PM -0800, Jiaqi Yan wrote:
> On Tue, Dec 30, 2025 at 8:37 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> > On Tue, Dec 30, 2025 at 04:19:50PM -0800, Jiaqi Yan wrote:
> > > On Sun, Dec 28, 2025 at 5:15 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> > > > On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> > > > > On Mon, Dec 22, 2025 at 9:14 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> > > > > > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > > In general, I think they're not designed to handle cases where
> > > > the allocation order and the free order differ (unless we split
> > > > metadata like __split_unmapped_folio() does).
> > >
> > > I believe the proper way to fix this is to do something similar to
> > > pgalloc_tag_split(), used by __split_unmapped_folio().
> >
> > Yeah, that will work.
> >
> > The difference is that pgalloc_tag_split(), split_page_owner(), and
> > split_page_memcg() only support splitting the whole page into many (> 1)
> > smaller pieces, but we're trying to create only one smaller page from the
> > original page.
> >
> > > When we split a
> > > new block from the original folio, we create a compound page from the
> > > block (just the way prep_compound_page_to_free does) and link the
> > > alloc tag of the original head page to the head of the new compound
> > > page.
> > >
> > > Something like copy_alloc_tag (to be added in v3) below to demo
> > > my idea, assuming tag=pgalloc_tag_get(original head page):
> 
> Actually I had another idea for page metadata like page alloc tag and
> page owner - how about we do the special handling AFTER
> free_pages_prepare()?

Sounds good to me.

> Looking at free_pages_prepare, it actually breaks down compound page
> (if it is compound, using free_tail_page_prepare), adjust page flags,
> and deals page metadata:
> 
> for (i = 1; i < (1 << order); i++) {
>     if (compound)
>         bad += free_tail_page_prepare(page, page + i);
> ...
> page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> reset_page_owner(page, order);
> page_table_check_free(page, order);
> pgalloc_tag_sub(page, 1 << order);
> 
> Even the original compound page has some HWPoison pages, these
> operations should be done in the same way when no HWPoison page exist.

and we're not losing hwpoison flag after free_pages_prepare()...
that actually sounds fine.

> The compound structure will be gone after free, the alloc tag will be
> reduced after free, the page owner will be reset after free.

Right.

> So instead of splitting these stuff into temporary compound pages, why
> not getting rid of them in the first place with free_pages_prepare()?
>
> This is unique to the freeing path, so we don't need to mimic
> everything __split_unmapped_folio() does.

Not 100% sure how it'd work in the memdesc world,
but for today, right.

> At high level, applying the idea to __free_pages_ok (or
> __free_frozen_pages) looks like this:
> 
> +static bool compound_has_hwpoisoned(struct page *page, unsigned int order)
>  {
> +       if (order == 0 || !PageCompound(page))
> +               return false;
> +
> +       return folio_test_has_hwpoisoned(page_folio(page));
> +}
> 
> static void __free_pages_ok(struct page *page, unsigned int order,
>  {
>         unsigned long pfn = page_to_pfn(page);
>         struct zone *zone = page_zone(page);
> +       bool should_fhh = compound_has_hwpoisoned(page, order);
> 
> -       if (free_pages_prepare(page, order))
> -               free_one_page(zone, page, pfn, order, fpi_flags);
> +       if (!free_pages_prepare(page, order))
> +               return;
> +
> +       if (should_fhh) {
> +               free_has_hwpoisoned(page, order, fpi_flags);
> +               return;
> +       }
> +
> +       free_one_page(zone, page, pfn, order, fpi_flags);
>  }
> 
> Under this idea, free_has_hwpoisoned() doesn't need
> prepare_compound_page_to_free() anymore. It can just directly call
> free_one_page() when it selects the right order.

Right.

> The only imperfect part is compound_has_hwpoisoned(), that we need to
> make a call to whether free_has_hwpoisoned() or not ealier than
> free_pages_prepare().

Right.

> free_pages_prepare() clears PAGE_FLAGS_SECOND
> flags on the first tail page of a compound, which clears
> PG_has_hwpoisoned. On the other hand, we can't easily exclude
> PG_has_hwpoisoned from PAGE_FLAGS_SECOND. Because PG_has_hwpoisoned ==
> PG_active, free_page_is_bad() will confuse and complaint that the
> first tail page is still active.

Adding a comment like this wouldn't hurt:

/*
 * Should be called before decomposing compound page in
 * free_pages_prepare().
 */
bool should_fhh = compound_has_hwpoisoned(page, order);

> I have implemented a working prototype and tested just fine. I can
> send it out as v3 after clean it up.
> 
> > > +static void prep_compound_page_to_free(struct page *head, unsigned int order,
> > > +                                      unsigned long flags, struct
> > > alloc_tag *tag)
> > > +{
> > > +       head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > > +       head->mapping = NULL;
> > > +       head->private = 0;
> > > +
> > > +       clear_compound_head(head);
> > > +       if (order)
> > > +               prep_compound_page(head, order);
> > > +
> > > +       copy_alloc_tag(head, tag);
> >
> > Do we need a similar thing for memcg? Probably not, since it should have
> 
> Yes, I think we don't need to do anything for memgc, it is already
> uncharged in __folio_put().
> 
> > been uncharged before freeing (as long as we're not using it for kmem pages)
> 
> You mean the folio was charged to kernel memory, right? From my
> reading of uncharge_folio(), it covers the kmem case.

Yes but I think not all kmem pages go through uncharge_folio() given
free_pages_prepare() handles uncharging kmem pages.

> > Perhaps a comment on why we don't need to split memcg will be enough.
> >
> > Do we need a similar thing for page_owner? I think yes, although it won't
> > crash or cause a warning, it will be inconsistent if we split page_owner in
> > split_page()/__split_unmapped_folio()/etc but not in
> > prep_compound_page_to_free().
> >
> > > +}
> > >
> > > I tested now the WARNING from include/linux/alloc_tag.h:164 is gone
> > > for both 2M and 1G pages. BTW we also need to copy_alloc_tag() for
> > > HWPoison pages before pgalloc_tag_sub().
> > >
> > > > > > > +             total_freed += nr_pages;
> > > > > > > +             curr = PageHWPoison(next) ? next + 1 : next;
> > > > > > > +     }
> > > > > > > +
> > > > > > > +     pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
> > > > > > > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > > > > > > +}
> > > > > > > +
> > > > > > >  void free_frozen_pages(struct page *page, unsigned int order)
> > > > > > >  {
> > > > > > > +     struct folio *folio = page_folio(page);
> > > > > > > +
> > > > > > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
> > > > > > > +             folio_clear_has_hwpoisoned(folio);
> > > > > > > +             free_has_hwpoison_pages(page, order);
> > > > > > > +             return;
> > > > > > > +     }
> > > > > > > +
> > > > > >
> > > > > > It feels like it's a bit random place to do has_hwpoisoned check.
> > > > > > Can we move this to free_pages_prepare() where we have some
> > > > > > sanity checks (and also order-0 hwpoison page handling)?
> > > > >
> > > > > While free_pages_prepare() seems to be a better place to do the
> > > > > has_hwpoisoned check, it is not a good place to do
> > > > > free_has_hwpoison_pages().
> > > >
> > > > Why is it not a good place for free_has_hwpoison_pages()?
> > > >
> > > > Callers of free_pages_prepare() are supposed to avoid freeing it back to
> > > > the buddy or using the page when it returns false.
> > >
> > > What I mean is, callers of free_pages_prepare() wouldn't know from the
> > > single false return value whether 1) they should completely bail out
> > > or 2) they should retry with free_has_hwpoison_pages.
> >
> > I was thinking that once free_pages_prepare() returns false, it already
> > has done all the work to isolate HWPoison pages and freed healthy portions,
> > so the caller doesn't have to do anything and can bail out completely.
> 
> Does this change the meaning of free_pages_prepare()'s return value?
> My first take is it returns if the preparation+check works are good.
>
> I don't know if doing the freeing work in free_pages_prepare() is a good
> idea.

As long as it's documented in a comment, why not.

It doesn't make callers' code less readable. The semantic is the same;
callers should free the page only if free_pages_prepare() returns true.

They don't have to care why they should not free it.
(either it should not be freed back to buddy because it's bad page,
 or it had hwpoison page(s) and healthy portions are already freed)

> But if it is fine, we can actually hide the ugly
> compound_has_hwpoisoned() entirely inside free_pages_prepare():
> - true means preparation + check work are all good but caller needs to
> free prepared+checked pages itself
> - false means one of the two:
>   - some check failed and it is impossible to safely free pages for callers
>   - this is a compound page with some HWPoison pages, and healthy
>     pages are already freed safely

Yes, something like this could be documented in free_pages_prepare().

> Doesn't seem very clean with a boolean return type...

The return type could be an enum type, but that wouldn't affect
the caller's behavior (bailing out) anyway?

No strong opinion from me on the type.

-- 
Cheers,
Harry / Hyeonggon


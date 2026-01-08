Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AABD1D46F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D296B0088; Thu,  8 Jan 2026 10:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B936B0089; Thu,  8 Jan 2026 10:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB676B0092; Thu,  8 Jan 2026 10:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE3546B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:30:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7635E14018D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:30:43 +0000 (UTC)
X-FDA: 84309183966.06.912D86C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06AC31C0010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:30:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KMMwhMvU;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ONWPTVXI;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767886240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIN8OpU82u2bxf/Tc6jIJqZ8Xq5a48n1ekW47gJ90HM=;
	b=1HRL+dqNWWV6auyMJttNuXkfjfS+7H0w1wxwshZJ2KBZw41htEx9GXW/b2iPn5E5gjNt1W
	dGvmmtDxMZ2OSqg1AlyjjESqP6bGmxCOgyouz2klJvkt+4CVXaAj2NgaUc3wbk8uhMEjkK
	Js7DlvOzAUccNHbu+qkyIHCKLd0ADOU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KMMwhMvU;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ONWPTVXI;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767886240; a=rsa-sha256;
	cv=fail;
	b=Ouy5I+fM+cehqVzvbCHvn8P9xVWIxCZ+fnhMRq7GJCBvi6ZuGTCep/F924lkTsKWIsMjgw
	JYxwdDqMORFBcoiuZpJII7BLCODp/OUH7jCan+MRIOlDQUsCTybUwE40+ruvgrI4VmH+5y
	wtuUa6Oj8vY+R5b1rHegiMtwZD3XLaQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608DunYK326169;
	Thu, 8 Jan 2026 15:30:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CIN8OpU82u2bxf/Tc6jIJqZ8Xq5a48n1ekW47gJ90HM=; b=
	KMMwhMvUpo57utkR0UiAOm1Y5YsQkYvk8HC6AXR1Xy3TwE0bA5LxmlLOVjCUpl9X
	bIFPu3T90gaXzUWqIVX1S/2tW+Re+ghAsHCNefFDI+pwIM5F4RZxazMrRRtBky6t
	X0VVuRBSVq/bsltWkO5Oy5JOhOH9mfFeDLaJVFDCacp5otABzCcT4paE7V+gCL+X
	0CmVHkYKTDJY4ulYisErF6v/ddaFhqyM0Ov4Pm4zT+D78ZVtZLfvKvEaFU/bv9iI
	K40OCfiOV41B9uIYe004JeLMfpSA59PuMCQw8J0g7MwYrGazrtq0y3B6B6FsTrod
	1O0rfYajl4SlgMiZW6l7kw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjdwk8557-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:30:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608Evigp034119;
	Thu, 8 Jan 2026 15:20:37 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb6pyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 15:20:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCFcmywql0QMQ+JvXAD8x2ckNG7fDXwwhxrjBBr890VvQjPEVF18bgJJRKR2a04gXyfF3iws5io9UWCBmW5EVNIZivsezA8fwR7tg7gn6lOpk2Gqmx3+pR/s+LZcG+/A3k5sAmxJIbO2EKPpF2qqfWlgRrLcmSmwKG55iUC7N6d3ouGZ+nE0cm93sQXvEla0GkygKaKTLERZidCSe4V7rEGKxdolfYUdv+d3ZmNyz+Cjj2qql8CKDsfAvLWpXCBDvXpSu9lvOKh7YZAuYD9npxAAWAm1emGxfRl/fkTjXTb5Ga8Hszs1phXwClc0JYHkn11T7PiuB5co3uT82encCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jjWa+zKAgZ0IRJsM2spJTHgW3OzBXB7FpP+0eDZeHg=;
 b=IFrk0i2pJbiYoumuIQU/YlIwrW9vZD8pSbo5DWmM13IiDbaHgSeJ+7bFaxPht44+hriy9G8gDSpc1YIf4uJ3//F9HcQSzXwPRYVVzOwN4EyjD44v9jKCZlVm7zoEvdmvXJSZK0gzsmfD66x88fNcx2oPfLWP27f8yzOWrQ4R6N7THVbEWBIvfpyh0tcLvuI19cZIFSCCq1ed6zyL/qgFPhpKhkocl1amy5ARW8FfkPqgTN2XNWpEUDyn8/qkouU3qul/gswFCK9miZmne9S2DzLqe/3PfsJ1r6sATblkp0gaR0Wfgjg4iqaQ5EdFTXrRasSRQMP7cx1nHQMadUQ1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jjWa+zKAgZ0IRJsM2spJTHgW3OzBXB7FpP+0eDZeHg=;
 b=ONWPTVXIFxF61IDM7DSFnah78KzWiNyxqGQVcTz81HzEDRYfGBH/d6BUTrN+3t+hChKW3Mwz5b8yh+Wx9imB9B7wVGHEIDbyodMFxQWDCv1Dty+0ZI298b46zrHAkHbVC112yPW1JN71qVDw0mAqQxkAAsULqmlOPmb/TYDCLiY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB6983.namprd10.prod.outlook.com (2603:10b6:510:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 15:20:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 15:20:28 +0000
Date: Thu, 8 Jan 2026 15:20:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pedro Falcato <pfalcato@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 2/2] amdgpu: delete the "Failed to register MMU
 notifier" message
Message-ID: <abf1bd1e-22f6-4cc4-b6e5-61fad2a82901@lucifer.local>
References: <20260107203113.690118053@debian4.vm>
 <20260107203230.880324802@debian4.vm>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260107203230.880324802@debian4.vm>
X-ClientProxiedBy: LO2P265CA0163.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f8e560-b9a6-40b9-be45-08de4ec9742c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Iv5Kb3wBEwLJ0tijgRLVTwVLO0X1PWB/MXMIfFvxbmZS1d8SM08fmQbgys?=
 =?iso-8859-1?Q?vX5BDqHMQMsQHatzQ/Pjg60U5ksE7WZQk9SgZxy+boK+iPlwE5WTHlHJaB?=
 =?iso-8859-1?Q?AT9su1WEGf4+ry2RvMks2AkkFujwOXPRo1KD3nOQUM35pkTvtRBY0HinPr?=
 =?iso-8859-1?Q?L3zz22ehSe8/6UrFLFK5f/BKmREbwZc7C6ScWyVr97NRopQS9xIn77wu2b?=
 =?iso-8859-1?Q?S6lc12HYG35NyEMFEAhQHgwXF4+KusxdnWLiuo0swl4/nukVnOsWS+RYq8?=
 =?iso-8859-1?Q?gDCAtJnpg98px38I0kMRIJT8cKqweuaAzJY7PnVxhMD+D7NPESV7S90yAF?=
 =?iso-8859-1?Q?6MBjecA0jaIJbc/sUHwIcDfpezBcSLPW9NnnA/4/V+fvkx7PQhdJIiQNvQ?=
 =?iso-8859-1?Q?Whn97T5H4E14qcKb2uOP1mNlqDN6qDseldZpE80nMzHcAzRAIHEliNvmwZ?=
 =?iso-8859-1?Q?xxDxaUl3w61WH/HT+9TJBMkDXwZ7xGChf7KVGpCTZYLfDk+v5sXZlw6ekE?=
 =?iso-8859-1?Q?KqJlb5wV0W1P9HKMz/uMwebQCf4g5ml3QsXYfRMBK2xmsdZ9l2PRhyZF0B?=
 =?iso-8859-1?Q?SoR0RYp0crBkgVe09NhSrA5Qhp4TKDpY/qIYLYJAw1RyVf83Uu6qxz4A79?=
 =?iso-8859-1?Q?EHiSFRQkOwX4QDQ4athTe4dfIjLj1/BCNeuh3NVnwGBs4sioncWcFilt6D?=
 =?iso-8859-1?Q?OCrHDqpNkD6Om6cqlFRKmYL1rJfcb9d7NJ/pMWemgj3AK0NvrP7NTz33+N?=
 =?iso-8859-1?Q?7LJY6IfaQvPpwk5GrIUl3rjapQthodaISriVZ27l1N69Thu/IyoFE3vgH4?=
 =?iso-8859-1?Q?nCbGdk/tYyJNwhO9HRU075sM6tqDRqCl0DkQ4+Xh/M7ZLzzWi76fz5ICOv?=
 =?iso-8859-1?Q?aD2NZvQZWH3O/IG2oDzyFTMy2r+dIX4dTxWjQUJfNcjkP3Hqxtzpfa673R?=
 =?iso-8859-1?Q?BXu6KS4Y8mZv5gUoRqp96fAGYmWxD7q2vLaVZuLTuv2NQdFuBDfRmid5iO?=
 =?iso-8859-1?Q?VApHAYrXO5zJy01TvR0j8ZtvE63jSNRUs+WKAwO6BISVhJ7VF4KD9Tv+Lf?=
 =?iso-8859-1?Q?txTHJ9K+W7W0J1a9mrcGLP3VtT0Tv3XPVz2b21imzfVG92V/qeOphsD/Xp?=
 =?iso-8859-1?Q?5GYckqGx3NDZyDMDSMYVzwt9Zx6YJ7/qtC4czzMDYKGpYSUFYSYhPhyF8u?=
 =?iso-8859-1?Q?AMkLhlqs5hpTc8vsUHgFYASbxc8WCTlZFOZrVoq+JB0uizoaZNvUkIZaa9?=
 =?iso-8859-1?Q?OnOOye40u0fX1e+vEyVNlP0z0ubiQTuS8Cz8mQ3yPnskRge/FKAwRd714z?=
 =?iso-8859-1?Q?jP3SecIAxbabLZKdZhqGp6cgZKz0SOnkM5tTbj7rH/PHneLlUgl5NKEV4v?=
 =?iso-8859-1?Q?T/eIm8Z4B2+hfDrZMRJj5uyqf4jPxA8cj4gkAnvkG5g7mpAFUwDmZt81en?=
 =?iso-8859-1?Q?35Zq3UwBGcA+shwvgdXIGF50iEbgB2rQF9uVkg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?uqtIMWkEvB6geBFDPk60v1bk0GMYlodskiq4CrvUjVR5Xf8FVaWPdO31/f?=
 =?iso-8859-1?Q?VO2uhTtf5cc6QaVv5EUAPYXkr0xKS/bksBZFT8V5ln1p9QQDYUySSJDVFh?=
 =?iso-8859-1?Q?AvKddEf6PgAVajuwDPA4NpAVvgifqArw32gyTnbxx4MY1Z9tKxPMlDq6SF?=
 =?iso-8859-1?Q?mAF3La1/kfKxGo6KQqHGGUaU14m9O73pz/SE7SJuYgp1pt5V2PMeUciYDn?=
 =?iso-8859-1?Q?0MIfdbT8NBUNSn1QxkqAuzS13ENfWzhhR3xyoIuRHSvpYuKHRmKC3x4eZT?=
 =?iso-8859-1?Q?rTlx+FzK5PNISKN2rueeyKLnqgDO3dcK2/kkJSLgGtCIACjTUCGmY9LckR?=
 =?iso-8859-1?Q?ozQJ4id2mM6c9rtyvWPhi+euDxnEtLzOi5VipKkX0QyGmDyyXkRUYUOam8?=
 =?iso-8859-1?Q?nIAJi6az6ywniueqDL0LM1tdAFK7ymQJfwvAWFbmLHQUZuQz9PMZepzQBK?=
 =?iso-8859-1?Q?Yk5VFFNZkWHJanUSX353SuFm8k/Yrvf2cSvC6Xwpv1gai31g1crnjMMg/H?=
 =?iso-8859-1?Q?3Ii7w4b19eI31MImbu7qz1udsmEU2eI6iuPzyY9B1SjodmY1Tmf91hsHZD?=
 =?iso-8859-1?Q?AcVsVuwFQo1sIFSYVKdkN6h/BzV6uTd3HEvSsnVW1m99FQiOzR5u9Bmyyq?=
 =?iso-8859-1?Q?WaHM5uoGg30jmXkKfRP5nXGUFkTOItat87LP4yL9tb6PGCEaunCNL/jq6t?=
 =?iso-8859-1?Q?DbcgubXKiboQHF0ukzcfhvB8Teu5Fc1mEC+FZiMoQBj2zA5rBKRTOv0N/V?=
 =?iso-8859-1?Q?dPCMta4xEeH9WFuvicFD/4AN9UjiJBwWC/FcZrTAMDBNttpGPh2fgh/O6z?=
 =?iso-8859-1?Q?jjXSY6ueZF7NiWTTqtlkiovYMCSCi7GJKDZ+WSs1fxX6fXZrA129Cswr8T?=
 =?iso-8859-1?Q?qIhNUIQ6+85WsLDict9SoiV8VuAvoyIDQbLd8BHxZugIIQ8yZiiM7EKXf2?=
 =?iso-8859-1?Q?OAHCUrFXCS9Q/AMhYVTZauVLN7h5nbhaTOp6Q1nN/UcMC6s7RMvWNDDbp1?=
 =?iso-8859-1?Q?Yw3+PHVdlG7E4pgZFVMTrHZOhHfPiFJ2+9jPMGuxlRlfVg8HHmj7eMCsBx?=
 =?iso-8859-1?Q?6M2E3vHPjzjUcWo1ZeOaly2C0bIvyUvDmyK43X/U8EdNITT5VqE0TfuiyA?=
 =?iso-8859-1?Q?G+iaIRtVjAsLXr5kOY9EK2eHjFgXH1hedPfiuMvkpQHkpAwNOWwefpoV63?=
 =?iso-8859-1?Q?ENfF8COvzCevpaRG716KPGWbPx0Z5/yz2ofax4o7RlPnfNDl24PLvkM3R2?=
 =?iso-8859-1?Q?rv+/G01ADis33di47Dt4ebRQbpj0dCyeaottANoesjZs8K+nnBkWMMySP5?=
 =?iso-8859-1?Q?/rKxqGykiaBegJoGXDu6t8mNlJfaz9rr4Orr4aNaxHp7f06aJUaKpvXNPk?=
 =?iso-8859-1?Q?bXwAzIFgZpqfwE/5V9WQKdFNzk0Evp9kWhknb/yVfz/f5qIWcYH8/bgQOw?=
 =?iso-8859-1?Q?sQwByjr8EzKV/yHJ94usk2pITrwBnTNVffZ/g7fInrH7P0xk70PfSG/B/v?=
 =?iso-8859-1?Q?VYwTpvO3AxqOkFjW8IvQcuNBOu6XKijs0LhKfCaZQAe75yyCiMcPuHxcWm?=
 =?iso-8859-1?Q?C8eKxqLTmlAD3QmlG8gRyEXsvXGj1ms2shhmkjQVfCcbzD9QaCLh9QjmDo?=
 =?iso-8859-1?Q?yWogkdx+yUw3tL+N6cBjoUy5gL1h25Sqa/b1su9UAjVZlk5YrF7BhHfTeL?=
 =?iso-8859-1?Q?w9H/KVqFnK9y54aXcjAm4OZSGTLTvpvNb7fxs8E6/7gKuHaQopMblosZfF?=
 =?iso-8859-1?Q?C8b2+1EU2PgwyFpuyoVZGrnAQGLIt4+34P+AbveIH9zjbhG2xFXoxcNXs+?=
 =?iso-8859-1?Q?VpoZ43Z17BzSBgjByRZGtY9Oat6x3GE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xzN7rrSTloxF73utVL6BeeO5rwC9SxQrsBcoupUGIVDQEIrm3b6tS5MzpuPF03pNlQA+LMThftHSykI/ME1VUP32JgT/bEiytkgEQtJHIqsRc1m9/hSF3eUxUHXzXEx1iTdNBASZMXDDKulyeOnoWWPpTV4Sv74htcgg7wQnBeYQejTY/lAGEzoZH+wEvY+1fYhfRRrHzLEhbd1nOQvLI1e6Teu3RxvAbDhs5Z68mpEkdBgtv3t0rD5slHc8Agpy03YxiZKS6Wccxg3WGne7ptdPR5QJw1PV2cVH3NYxRaPZDQWJSuspl7NEOFWXOvuNAJfrTvLUK8QHgvwBixtoL7Y3PHCJ3l2i00iGuUsqv6vQFy9xhFCSAsNWqLwcO/lPPVFJgJxBI2ipJNf8+BmjlwTr2IGX+IIHee/TTqDWdPU+3ljZesOOM+PV9mRx335z278JEwESPEIXd8LbxqJitzGE/rRIOtj2jEgsely9mbdbWDpKKrVtOKv1E9pDZJVBFrJUinztqPg5EvQP8Y68THZpc42TxXnixERRBj5XYf1H1GaU80z3C6Dh3sIDarjhtVhGiaDbny4Kb0DAS1SgFHzu//M9nYx1Fdykai1uWa8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f8e560-b9a6-40b9-be45-08de4ec9742c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:20:27.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92cvpQoAuGnvi9aMoZFWevOow4eLk78NxdBKSYzhL2+bBa8AdkDui4v826+J7xPkxflE0NseWP63DwkmhzlKl2C+MYOCU+VK83m60OZ236g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080111
X-Proofpoint-GUID: hJHj58ohb8HOd0S_Z8bBLRV9KroBccqQ
X-Proofpoint-ORIG-GUID: hJHj58ohb8HOd0S_Z8bBLRV9KroBccqQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDExMyBTYWx0ZWRfX05oCV/vYw/om
 IUsf3PLuc13IOUOMGsO5zPQZXC+mr42CEcaxLNP1Dtu1o4VtzS2KYK2LMz5e+Ny2AYoS33Y6D9l
 2lyrHS1mzVDtlFj6xdeoiFeb/DyQOevKwylzexj21JSyX/e4YxVAOPytw+mfPJWNflnv0gg7h2b
 w3o0n/40j+lUOkcWJebJGVooraduGT64Ma5LX2RwF3iVeksMUAbgxJ4MLEwDA+NIbOTigpOnRcO
 y0GborpydgFlok822NgY2z2eudq67+Moz0cv/NC6yMReDMiq9+69SL8ge8Epc1dAiL+iZnvRNr2
 1O1VCHkfmETP7eVyPm/2esmh6JhthhhT/D8WCauLjNQuqLaDWb01bYN+GARHv8A1oBHv4BkTwyB
 pqaXaZZq/fUVB+BvaTGDN6RtNKTXB9Zz+zapgHGL4MgLZsxfNa5zc4ssGnYcDq3HknTsnAWklkh
 9JRPt6pwL76OUeJtjdA==
X-Authority-Analysis: v=2.4 cv=ZoTg6t7G c=1 sm=1 tr=0 ts=695fcd9d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=7gE3OW6ZS1o2am9xnnoA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Rspamd-Queue-Id: 06AC31C0010
X-Stat-Signature: ef77xs48ddq5tjp961pz1k8eaf13s6n7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767886239-331822
X-HE-Meta: U2FsdGVkX18ak7SgG6v87iDdrTTSTe7mTDag1IntiwdE/cEnWe5JeJSjg2H0rs2i2Wz2xN7gR8UMGyBM1Vqren2LXw7CGxdpVTAVReTTkBd9b/XwgyOVhuWeL0xkEAVbvfTMaZMKAqU9bqtHXQRvaBqbefd7JqGZo0IsNgtxdor2w7YKi9v5Jxbq4gBQ5HGnYEj0lctXtcCOCWfnrh4QU6GOYEG0Ml/1neWF/Nr9v89eUOJQKDuJ/jbIhALGCIw2JFxav9GfSg8tW8DD/jQDO9jXhj9ZR+3ZpqQOCDRkzT7CBxDkWMaBeQzBCuiwTxUlTSdWFaiMrO2o8vP8DmsF+rN1NE6RDwGVbb0yHHQpNmdNZdCs1bzdujzYPuEI899OgaKb+XhZD2G6In1zMipTJsIQ41mEpsN0Msr4XioXmCFm+wBlwcrf1XaxEjjBqZqthnHnA1krjKBrfMf2NYrYsXQFuPv6W5kBnKwUkCyHKxUJ+GDRvyPdfDslvM5zvT4ZyWRpdhs8f0E2XHV+PR8KIKIsN6skMc9+jdmgiJzGm1M42hhfNQ/XftIfmJl7oEMWKp0pOpbvP5JYZ/IRQAp4fidcHRKoKIAm7F3HXUoRi6i/59akrZiDK7wfQow06LBFbefRqigItUTtdK5AV0ZWqpGAJYkJNrDiZatFbP1nWueUZFRy0FRkwTJfCmAH40zFKd4sQ+XqOqlv7z0j6PwPbW5xt/3l8WWigkVvTR7zV6wtnLegfyO7CVD8Q5n9ubu84Hi+VnraNm+wN0fq6MPcw+sDf3FsdP6BEcnckex+eQD5+wikkyXrppSYJHEvnvYNoFlbTf0g36Qvg2tK4agxPDJWyXheaRHpyC4I9JQhFRjKbHlyzcAyJqd/OB0X1q4+HtKyzn2tE0lhyCAWg786L5TYhcHZYxhi+ayDZb7XZul4ePFRDI386Vm42cekk8Saa4asku49ZJMXko+FUSc
 94FpEiC5
 V43jabGHrP/T/yBneG7P+79u3U+b5Sb1pOYo/S9lLLajXhb7ldWjsma562dOmaYLq6QZwXi+2z3AL4Hp+KGxsFcZ87DLDJtwxY/HD9lTtdO1AHMr7D1FToPWTjoDcibMcxYBB8lDMd+fJ1iP1pf4+BYi7lPGFohMdfJvBT3dlTuodD2Y9kQFZPWo0BCr0FlXJ/tMuoB52lm1RevtyxiHKXeb7/VAH2vAbjcNEEhDTUzfw0T5y4uNbfVt5GDxT+UH6IwgW3TjT8kY19ZBsqlIrjeervJGqBFB9RUPIMZtkrMa1B/rZUqgKbHF645PfspI8/IJ0Lh3f2W5foz5WtSLQ3vPkaLft6aG5g1h7VdTBgQY6Nx2CjM1rxvZkUoOxPyP/JGTbX0Rf3c1qrwzaRaWteBFh/lL/MDEJo6ZpDYfsrapA/13co1IQ/TMXypJflgtCw65p3Y8VG6Ia+9eEnPwManmd2+DPVc4ZAFyVRCVkud2ZohnwWjaZHmAllSE7XJ8f/bSWKxytYybclJ577oqBm3TEzuxV0mneHcP8C8BW5hVKp/ce10dPMBZMg2XKRFxfzveinC4VSwzsCdB0AtqU9HY4VWzLO7Lfgw8d1fUnVJroWepl52t8QzsTeqIiRAlzf8nC4THFnEMdhoSV3HzTnOe0/xrDHMCEc10oS4SFTLRHVIm2BWP+5GroP+HNEs0jOE6Kx/Ol2Gbbtfg7tTekh3URA3u5aA6QcZYCeegDH2C+leyVqtCzZ/CTKiyTq2TggPYxjEwHvNWL3Go8DMmQGaEtsvH2WxTuxk3hCoQHlxQ8L5WdqgUBQi2HK2048xwIXq8a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 09:31:15PM +0100, Mikulas Patocka wrote:
> This error may happen if mm_take_all_locks was interrupted by a signal -
> the userspace will retry an ioctl that returned -EINTR, so there is no
> need to report it to the syslog.
>
> Christian König suggested to remove this message at all, so let's do it.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I don't really see the point in this being part of the series here... seems
to me a patch that could be applied any time, so why not send that
separately to the amd driver people?

I mean maybe it's not al that important but still.

>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================
> --- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07 20:09:51.000000000 +0100
> +++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-07 20:12:11.000000000 +0100
> @@ -1069,11 +1069,8 @@ static int init_user_pages(struct kgd_me
>  	}
>
>  	ret = amdgpu_hmm_register(bo, user_addr);
> -	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +	if (ret)
>  		goto out;
> -	}
>
>  	if (criu_resume) {
>  		/*
>
>


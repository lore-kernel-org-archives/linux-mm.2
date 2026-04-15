Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6406F4213B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 19:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130E06B0005; Wed, 15 Apr 2026 15:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108266B0089; Wed, 15 Apr 2026 15:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F129F6B008A; Wed, 15 Apr 2026 15:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E00096B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:40:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1597D13B394
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:40:03 +0000 (UTC)
X-FDA: 84661805886.23.F64C8C6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F1421C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:39:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qdUZOvoJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qBiMOK0r;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776281999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBEgxTs3MMsH1GPB3N7ch95ZB1p768s+lnarlhfse4M=;
	b=H8EHIlnklWkGGBhHU3FjPnczHSLBOXFWT8ZlObvoCgjtvdzGI+NxwJ0iQe17wZo6j6fSRH
	rrkxZsv3rkXCPicHKdjCpxI97/gROjN5Jmw7ObhBbtBvwBIVb5s2WatKWTy0SxHyML8iyv
	aFXscixn6pSZTVocZkpFxj5O5wHkX5s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776281999; a=rsa-sha256;
	cv=pass;
	b=eDCTtFhP4fyL0KoWlYfgLVd+qmGy3k78T6Ca8FwtfAK6ymVgE5iY/e/f1q2dKd3TgVpcXd
	6eRvQFfy/ivQo/q4DMqPnEEO9wCwKz0TOI1Onnpgyr6FPMutFygplfbzpCx+GyQSWDnmeQ
	lFjNNr33TxwVq5E8dEXzPkl21J6F+b0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qdUZOvoJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qBiMOK0r;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMTha2136653;
	Wed, 15 Apr 2026 19:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DBEgxTs3MMsH1GPB3N7ch95ZB1p768s+lnarlhfse4M=; b=
	qdUZOvoJL3MWQFV/xMnJfxSsYee8x0zuXy9AhnsLWQYzIp8ftWyrGrI3DVbl2k3b
	2cpaAqeug6EqJBy8zEeoLoLPoRNUD6v4HP8lBVij+onRsSF0qSdGMT937PSW0J9s
	D51ILSCs40K7XqE1rdz2iUUt4Z/0WGNwUT49IXLfULdlRZA06Cd7qf44q8RVETum
	IoV8KocsLwglgj9EL3317C57TXWBv/dyRH6brl59B9Cd+Btn8qZgLUJXnsUVZFss
	XMk1VHlkX3m/zONKK5rAZywbstcMvBs/4YSO0udruInrfnrwOIpBQVj7uk0mvd/6
	da6ZOhio2bOCsCvhuTeiRw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh86863ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:39:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FJdnui007831;
	Wed, 15 Apr 2026 19:39:53 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7npb87q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 19:39:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdTqFA0RjsrjrBuwUvlPgXak5i36ECz6SWmN6J7cxi3QpW9SoiDXok04ZpeBReWlRSYzPuOEvgAAGa1ttQIFvdSXhW+bo+KRrA7DzI11XCWtYpyDMYgrsV6W78KNktLQkBJ4u/UzGKvKykHrH7cdtoitp6ejlc49kkqpfdSX/2YKChAQXLaxe3WbvbdhxE2ExCdrfvIaGPoOnSQ7oK/ilNNX/qK1TaFAqtbz2GybJKKnZJj4WWtTYNuusXhT7YVieamTrXUvHZBZaxrRdZrsNW/J1ETcYDJHwJ7Xgzu0qhnJliaOzZmEA5IVQCV9TuL8JLfan5QCVoSAQ7IXqrrwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBEgxTs3MMsH1GPB3N7ch95ZB1p768s+lnarlhfse4M=;
 b=XtWzWqzDu2Lp3lALFuk4uaqdHKnf/pL9ZzNqDjcTbR6rW5CMQBhm+iyzZGbsNJ/mSkqKAGvj89crV2RyWTObHWuEURZmjBHMrlVPY2vAK+28G3ZDkmjzYW5JSNPx/AQPK9wFxIScyeGEMgU22Tzbb5UXm3S3yPwqPZoPSlEAmAB22UTZLx9uQHk9kZXg3Dohuwg2CP7lEQIBmNhZrCp1aB/nOuFbjNpPDfgAW9BaqMjOD0EJJoENZO73KR/egqkudVtM7i2WqXR1mLpOIt1Bwn5nhL/toz2YrQTmY/64OOW9bElPWqZnpJGDwBgxeMmZpb6Lf3zZlJpn9zvbWm9NWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBEgxTs3MMsH1GPB3N7ch95ZB1p768s+lnarlhfse4M=;
 b=qBiMOK0rBu0jE3p7hRjNyy8EGf5Rp2ItsmZM6OTf+EyFNxKCocgcIIiGQ3pJqHfRGeo/Ae3u9+TYOu+2LEWb6+oWxT0jThVk+/fYcnE4htm25wHhbdNckrr+9NHInhQ4liYLJ8prE3VmkZCBDLzBJRXBE6WAFZEAylCia5+X6Cg=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SN4PR10MB5589.namprd10.prod.outlook.com (2603:10b6:806:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 19:39:25 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 19:39:25 +0000
Message-ID: <e09f64e4-7490-4061-9f7a-f4df586cbb72@oracle.com>
Date: Wed, 15 Apr 2026 12:39:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page
 indices
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-7-jane.chu@oracle.com>
 <ad9F5duupm8Rn-Yw@localhost.localdomain>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ad9F5duupm8Rn-Yw@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::29) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SN4PR10MB5589:EE_
X-MS-Office365-Filtering-Correlation-Id: e72df8f0-98fa-473b-30ca-08de9b26b358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	69MXKRr65WhwsCwS14xQDfdIPVoA4NZy6bImxjOy0w4mZhV3/7q8WiFseO2BA/K7xeGmPqY6K++jpv6OFbfkyD17f6MMD8wgoT7GABEXrj/rNv6LRhbmQS4VNp5HficqPPqMaCyAe7lZ0jVORKoYUg+6ppIvkTkU1ibS+hTKqYBHvNvYAyYD0bNkGx9HiYL2JLhQ1vqm4sQ11mCio4KnWTdUDy063kH+OE7nZRRrCbBL8RZQMA2MInKr4a521zs1i82MEkXf6i6jWTFBLabFTaNTFmdQqaim14ef0RWFKSqJL46tGVUujgJmwYFp8s8J9bB4aQ4De4Qu3h5JRwdUJPKnX2bTH+7TZVC3hYXM4DcJlncxlQP4y/+w5T6ldmYC/m/92y6CukadjpM5zupBLgykRjFTw7sdZp+q/Ivhl1fxM8WzIaAuYRb41EPi6In1deGYyoU0FoQtfS05A9QE0M+N7NJ/8CdhKKy/lr0bL4RcjjFFs2e5i8aSTBynxNQwqWz+uWq3jenC2C2UZOQRK3SsMUSljEwtSEe+6Dtxy2tueUMpeZtHp6aXAlWbu63+73qhCkfSGvPfu7+kpd9dp7pAArvTVBZ9orF+A9qBLqPA9zaqk+QqTNXJhHmjFqh1n4nwdIzoEw8c9gxcKyhUa4OkBFCw7HES6xfSSyE4mMrhzcEAlO5xg4CgYH8DVH5a+4BkTO0/Tf5IBakjMyixHbE3P4jf5+awWOiPgwuiLmw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnJWTmNVSWZid3A5U0dPSmdkRnJkK2oybFg2Y0s5QzdiRWRVbVFBY201MGE2?=
 =?utf-8?B?Rm4rcTByZjBET3pDS3Jtc05ITGFlOXNRSHc4bE82cytpZVo1RW5UWXhLVlp4?=
 =?utf-8?B?WGJDTUZBNTdPSXEzYlpLNkhjY0VuT2R3NXdac3kxYmZMVG5DYTNsc2tqWWN1?=
 =?utf-8?B?SE5YKzVZOCtteHN1L2c0amtCT2FtNXp4ZzVUYktKTm9wUnFwTE9yRjg1ZnQr?=
 =?utf-8?B?a3Bvd2hHcGVKaUNrMzZIdlRkUlZOZnNSWVNHMkNDQ1I1bUVkOXdqc0pQMGZJ?=
 =?utf-8?B?OXN2a2EyeU5yakFoYWp4ZDVIUitqQzFiK2o4ZFppUWsrRWlBSzBnY2JZZm8z?=
 =?utf-8?B?UXhmVi8wNE1PNmJTa3dDT1dVa2doT0RqZnp0ZU9DaFE4NDMrZXJLU1FGbWxi?=
 =?utf-8?B?bE1qdURITE11VmdVQ0x1WDc4TzJGTzJ1SzFEd1ZZTXhwblp3akNCYitJOFBE?=
 =?utf-8?B?Y0xOYWJ6czFsUjNJOEFETUxudmttd1VhR2dHanAwWENZeDU3c3R4UmIrSndK?=
 =?utf-8?B?MjhCbVNzc1JFb3VhaFlBbXRlVTBzT2p3VlI0UnNEM1dGdEx6anAwcHR5NVhQ?=
 =?utf-8?B?RXo2dTI5N1dlR0dMa25mTTRDRGdQaGRLS2xDTjBVZjdib29YZ3RWWTYwbGZ3?=
 =?utf-8?B?ekowZjUxMGJYTVpNbUY3OURndHhWbmppL1c2ZHhZSXZscFBPc21kRGIwVE5w?=
 =?utf-8?B?VTdSYmlIdTRLVnA3bzBWQXpiMkRCNHFnS3VpU1hsZDNLSjdJUnNhVy9GYUE3?=
 =?utf-8?B?Ung2MVpxeFluNzJFVm1kYXdrR1pQWFFkeCswUE83NmdXNDBneCtIZExseS95?=
 =?utf-8?B?UnFocGNscWtBZmZsZkN0anZzUUpYYzhkMk9lRmh6b2RlNXlxYUVjeEdMQnZF?=
 =?utf-8?B?WXZrYVlsN09PSlZibnFHNUhRaG1FczVYcUlVNVFtUVJBMCtZaVU4OFV2Qmgr?=
 =?utf-8?B?QTA2Z3lQOVdrcytnNHdBR0lmUjlBV0p4ZGdVeGdOQzFON09FaFhVTFE1aEM2?=
 =?utf-8?B?Qld3cjhQVjMwd2FGbFNBZTMvUDYydXl6aGlwaEtYL09SU0FCUi9USTNKWVd4?=
 =?utf-8?B?Vm9PNG90cEZOczhzYmovVjdnYWp2UDBYcEdDYVA1ZDZjODZITTFGZTZYMWZt?=
 =?utf-8?B?K29Sb0xqL0Q5TExnWFBVTm9ZWUNWT0k5bEcyVFEyVHBpKzAranlRcFVXTzNX?=
 =?utf-8?B?elhuenI5SjFWSlFUQ25sTVh3UVBsZWhISkpYWmpaMWVzREh6RkxHZnUrZnNV?=
 =?utf-8?B?cjZUTlZwbU1zRGVqUnNEWktwTFJvdE1VVDVraDRPMnVyYTlERU1NNHBUbi9Q?=
 =?utf-8?B?U0dxQUNNdlBmWDRMTU8xMGNJRGNNN1BXSEc2M2tVYVg4bzMwak94MGhyRE56?=
 =?utf-8?B?OG4xZm1FZ1JwUUUvQ0V0bCtML3VmZy92TERaSmdKYjVFc2ZZeUFNZUFXMWov?=
 =?utf-8?B?a0hZRFhLZWRTS0tQY3BRZ2V5N2pWMVV1TkIwUUdqaGloMEVuK1dpMld1cHRk?=
 =?utf-8?B?eWpBLzVnanVURzNpNkUzRzZ5VWhTQWVhc3EwbFA5VGUrejlISThLcWJucGhp?=
 =?utf-8?B?QkVyamc0b1NHU29YSTF4aGN0b2llODBIdEs3VTZOODk2Nk9NMUwwMEVRZ2FL?=
 =?utf-8?B?elV1SUtIdEZiTjlBaG15RWM2WUZTelFBL2F2cGNFZFQ3QXFvNVM0RzFnUGtT?=
 =?utf-8?B?Y2FrdFJvbFJzVzRrSmtHRE45ZkcvbVBML1pzc1VLY1I4ajJjbXBoWG9Cb0p6?=
 =?utf-8?B?bFkvbEFVejZobmNmZkZFdzZMOGw4SkRNeFZxNldLRFhZNWRtSlQ1c3pKZ0pI?=
 =?utf-8?B?bEZvY2ZWTnAvTDR2MnJsQ0lWTXZBV1pyOGZHMERucUt6eWNmUFNWZVRVSjV1?=
 =?utf-8?B?RThHOHMzTzlDb3I3bFcyckdIM09sczFVUFRwNWRwU2E2cGlwTkREeEhFUXM1?=
 =?utf-8?B?TjkzQ0loOC9kNzRscEdnMWptT2hnNmx0eEpIbWRmZDlSY3RSNEFvcGgvQnQv?=
 =?utf-8?B?N2FTNzhPOWxSdUowckE3by94c3dkZkM1alJwUm1BWnZRNUpNYldSeTFiZFU3?=
 =?utf-8?B?d3RGWjhSUzNyNmF3dXQrVmdBWFhHM0poL2ZWOHB5SlA0eWtoa3liY3NkTlpp?=
 =?utf-8?B?cm5WV2VlN1poUnhKUjRpSHZLYXYzcU8vK1hWSG05bHNmL0dZWFRPMXI4YnZ2?=
 =?utf-8?B?WnRPVCtIUXZzNmpEbW5JeElKVmM3cXU3aDBFRVVpS2RoejN5YVJLQzdJcmoz?=
 =?utf-8?B?ZDNSbnhlS1JhZUVwcHJ2bDg5TklmNjAraVNzWm9jenNTU2RJcklReVN1U1g3?=
 =?utf-8?B?bjVnUklNMDl1VWwrNnlDYnVUcnZycVo3dC9taVBQL2Fiay9GZEwxZz09?=
X-Exchange-RoutingPolicyChecked:
	IrUzAYzVEu2aYSehzaLW7geAYLqk70YSNfnZwC8A7JZNsoYRrIDJjufaQafylgouY4sqj/910lL09QpeorzVxEbfBXK545ftThbIEif1YIR6ejw2cmCm+th1R3wcPrsPd2EAhfCKyACMc+c/vQslLc3H5TAZk0E0qVw7Z167ezvSmURonDhAO0F62bxKlrZhY/PO4w+lM7gleh24ZIy8MXPM4BGfjxJvZtIy063jRGXB+8oehlQ/PlwSOoTMqY68fWR2RTx1mWTfiiuwEFUQBQe4Ku4CRo3O6LLjGMuDH7MV9y7qCrHKQPCXlxHJ4xJHA0k7PXXX1PswzyAxEHu0Bw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lFdAUDXQVrlY7G9HzYKt3CYkxY/38bFWulMA38IBp+PQNY3cD5er51g9Gtb0omnSq4fLlK/x9QAb3bxedoZ1qHLPU/J+MQHYNJ/tyN01Jl8FNAo5OlHR7ovfD0i/hRWu4YeYQAwAJXw12YWG7c3cyL2TxivInZEWAXDP82cTpIxW9eLk76YoA0MYEw3PXwjnF9b0FOIKAwvkeq1YNfybfpYn8a59oNhy7tTkT0e97wDQ3UFyFAfszivsCu/Hl2LAxLpjiisiMWLUL2dzzsVbp4eYpUQnkMwm8haL/XabpPV/xNrzctbE97v4gQyehaldgkrcsywLspfFNWnzRZFDvl0gqaFxpIWPQ+/imstUyNO2Xg5Iz5GblNuuQZ+3EbhJHcARFQTFIcV61BWhkbV25Esv1fZS/4DoSdCkYrdV7M/ouEEO09O8Psluy6vlGLjHdQoi50DLPdkjOwBp+sz0egWlyyE6USKvVBnuW5hb9Te7O22llmxig2A2uPNdEPOb3FWcybu6d2aKOZGBYrH1N4xQQTiPqoRv5mpBSySQfHvrFuuGA5o/jrYPiBF3RFTD7jdJuvJb8i7d0kKj4e6jQo5lsQRb32kuWdhgNUBC55o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72df8f0-98fa-473b-30ca-08de9b26b358
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 19:39:25.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjHERqoYn83umR9RQygh3gen1UxqY4PpALODLSefTy+cX4IQ3bQuSNb8CBrqogbgyZgL81i/IcXRmN9UpVnBuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604150184
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE4NCBTYWx0ZWRfXxacgTt7/V547
 qv2RICvgecdLolnMOnRHBALpC5a/RhXF9N/ezDtukSen+23nXQrNfl8jH6jYKPldwSNrgBKn0Gq
 jPs/KimQBTI/nBIMSTQ4+17pBNuAKIF++sebIWAT5/RrEmOeaxItxmvKUs/hjr/p9ANNMQQuZQU
 k2a9jDcWNZayLAp65n6B56aKXPuohQlo5N9mmhaOoQC/bZs3dSZb6H8Bd6gJJW1klfl1Vh7UWVY
 HLxJDfb7Y0+fchqMpXALjoPAx3cRwCK30Di1jMpu4Kq6Fpe5mav0Q3QdCXZqynA6zYiUzgIatOm
 08sv0xejesSyGx3WAPZM8KBmSE90bgMIVFRZ4TSeL+7EknCusmN8O/3mBo41j9mtPBefetTrkiI
 UuGqlH0eNC+VBqN5QTQHcG91hmnR9mqco0Raw6BvAeMoJCnVphcnpz3+XqSliT1hVR3GwhwDjXb
 GUpdohSQFme0mfDO7QIky9IgdXzJ4kUGJ8vJTI+U=
X-Proofpoint-GUID: nEHEnDOXm501shDnqSOPxp8wVMuX98LI
X-Proofpoint-ORIG-GUID: nEHEnDOXm501shDnqSOPxp8wVMuX98LI
X-Authority-Analysis: v=2.4 cv=JY6Ma0KV c=1 sm=1 tr=0 ts=69dfe98a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=GSncxwE2VFpmWCJjAhIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Stat-Signature: qzp87ch3swo1kyxi1wc5gn48pkhaowsa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F1421C0008
X-Rspam-User: 
X-HE-Tag: 1776281999-30783
X-HE-Meta: U2FsdGVkX194U+c3Eaw58YkovTRmmyXJDO+DpYbCSfPYYMSWA6Jqm4cifn5w4ZSY623eZvwYNgfUqt02BkK0aBOPuHaphCCinQFJP2f2Dq201R0XO/VYrE0TEslkcuHRb2u0jZbPwaHeBHW9D7/VYT0js6Q6vxDfXf9vTFz3x63rlLcvhRmbldZtFwofZXlOOdAPYMJ0LOMaKRtTMRCLRm3WZo0uUbVbQH4/ykc9uGik3g3Yson969bMY7pgUJi66CoBikzrFnvt0xpP6WBQJdQKnKgUw4Zjad30BCNhFAKPTpX28XvVA4H9fKIyFXNic6vGGuYuNC5rNcwJ4a2aEDD+1OmSGW02wvT6Sx3g9q01Q6VauKT3mTx0MHFSUCYJseQqt+QESZ9CObDbMol0DEWtR36Q0XCS2E1dZ+qIynoEhSa6FehoAdYO9Q1OLVdlyU677u52plQW7CC2Rrq67K1WA2ox6KX9E8nKCbeRbA4x6XOI226S6ibtHwbii1CabIfSq08wLeSkgmN6hBKVposXCsZj/gBdsLnNEKiYgySjpd8xRZVMF5g3m2xem6nLTX75tYE9eYM8v3cTd5KWrj6Eef7L9KymTgzlhLF5b4o25YmUykAnuc10zgFpFRVuPUTeGfRDVQeaWCu+GjAarvspee/SrSxFhRHf+w8tFKII4D6ClvYeLkA3fsodBhjJkQLRq6FvAFdbbvQn+GbFcte3vBO+Ar4C5PFpumSnQKATYjmUjsT0nLAR35SX5Mr8Cm0klqpln69M9fNgArX1VQeiymLPUX9k9SLcY6pk0n8gewaztZ/zUpRohl4jAKcNm7hJf8c7zKdyvZ98ivJcSDw2IRcvum5Xk2Jrr9yfGHlD4LLsAsxW+zMIVh6SX/GFJMJRcwRjCgCXgqwF07CBLXB4zCaNMeyX/gYrqaUH/mD74crC4NWENIZL6qX8RW8NKXTMCKILBLzvx94Zyzi
 sKgfyotz
 4RNyjbqoXnjJL7/HcxpRjj6O9UlhFE+068UlVA3QSNAEJizsoc9mU5DHKG/HnTU0QJOBsEVN95mzp8MQSDPF6LgKKYF2pVMwLyv09o4YS/mCC/7oAjax/k+Ee90mDTEm1+uZlwZJGtbcJsONngGhDx/Aj6Q+yj4sIM+EnJlatyut3GzDyd98SIf4M2iSZnH1I4GFUf4babKUwXNzVf0WowKd/W4v4mAY/Qk1Idiz1JX7SE0HWIMUJ6fwE1Dozp4G7IruaK5RmtlSBrb5Hewcol71bedYAOhFekxyfXDUTF4F9sFNz0FwcG5iXg8DJLTeSNBI4WsD+7SGNR64hjwnuN1XTRkNvquVWQnX++knSHAsVsOGScQ465THBdge98YyFn1C84sMSdsD0FIY1sQOvTJrrAWAcUj2MlMvVxaCih6lPlH7I1bHL5itVnswjJxR/yXGPS+XiHmDOUywaghZj5A1ps8fxSM3/0UtuvzkXwBGF3cTAYBJQ9TwkslLWG7G397nP3ZkWOxRnbVRIZ9l1c5usMjNLhcS8uyDGhvoj4uERJfWIYT8n3U0UlN3UfQxGNz3lYA6rW4v6wfEjKwWed1xYsLKql4bB8X+tuPTjuhxNDg3rSQ2a19WZmEbU8z4V2v2acNIXNO6epcwWLui8lFpGNLR04SJy49i4s3eR2K/BJnu40gwA9ZgHIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/2026 1:01 AM, Oscar Salvador wrote:
> On Thu, Apr 09, 2026 at 05:41:57PM -0600, Jane Chu wrote:
>> hugetlb_reserve_pages() consume indices in hugepage granularity although
>> some callers naturally compute offsets in PAGE_SIZE units.
>>
>> Teach the reservation helpers to accept base-page index ranges and
>> convert to hugepage indices internally before operating on the
>> reservation map. This keeps the internal representation unchanged while
>> making the API contract more uniform for callers.
>>
>> Update hugetlbfs and memfd call sites to pass base-page indices, and
>> adjust the documentation to describe the new calling convention. Add
>> alignment warnings in hugetlb_reserve_pages() to catch invalid ranges
>> early.
>>
>> No functional changes.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   Documentation/mm/hugetlbfs_reserv.rst | 12 +++++------
>>   fs/hugetlbfs/inode.c                  | 29 ++++++++++++---------------
>>   mm/hugetlb.c                          | 26 ++++++++++++++++--------
>>   mm/memfd.c                            |  9 +++++----
>>   4 files changed, 42 insertions(+), 34 deletions(-)
>>
>> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
>> index a49115db18c7..60a52b28f0b4 100644
>> --- a/Documentation/mm/hugetlbfs_reserv.rst
>> +++ b/Documentation/mm/hugetlbfs_reserv.rst
>> @@ -112,8 +112,8 @@ flag was specified in either the shmget() or mmap() call.  If NORESERVE
>>   was specified, then this routine returns immediately as no reservations
>>   are desired.
>>   
>> -The arguments 'from' and 'to' are huge page indices into the mapping or
>> -underlying file.  For shmget(), 'from' is always 0 and 'to' corresponds to
>> +The arguments 'from' and 'to' are base page indices into the mapping or
>> +underlying file. For shmget(), 'from' is always 0 and 'to' corresponds to
>>   the length of the segment/mapping.  For mmap(), the offset argument could
>>   be used to specify the offset into the underlying file.  In such a case,
>>   the 'from' and 'to' arguments have been adjusted by this offset.
>> @@ -136,10 +136,10 @@ to indicate this VMA owns the reservations.
>>   
>>   The reservation map is consulted to determine how many huge page reservations
>>   are needed for the current mapping/segment.  For private mappings, this is
>> -always the value (to - from).  However, for shared mappings it is possible that
>> -some reservations may already exist within the range (to - from).  See the
>> -section :ref:`Reservation Map Modifications <resv_map_modifications>`
>> -for details on how this is accomplished.
>> +always the number of huge pages covered by the range [from, to).  However,
>> +for shared mappings it is possible that some reservations may already exist
>> +within the range [from, to).  See the section :ref:`Reservation Map Modifications
>> +<resv_map_modifications>` for details on how this is accomplished.
>>   
>>   The mapping may be associated with a subpool.  If so, the subpool is consulted
>>   to ensure there is sufficient space for the mapping.  It is possible that the
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index a72d46ff7980..ec05ed30b70f 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -157,10 +157,8 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
>>   	if (inode->i_flags & S_PRIVATE)
>>   		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
>>   
>> -	if (hugetlb_reserve_pages(inode,
>> -			desc->pgoff >> huge_page_order(h),
>> -			len >> huge_page_shift(h), desc,
>> -			vma_flags) < 0)
>> +	if (hugetlb_reserve_pages(inode, desc->pgoff, len >> PAGE_SHIFT, desc,
>> +				  vma_flags) < 0)
> 
> Ok, this is something that I have been thinking every time  I looked
> into hugetlb reserve code, but I think we should be really starting to
> put some meaningful names for from and to, and pass that to
> hugetlb_reserve_pages.
> Because "desc->pgoff" and "len >> PAGE_SHIFT", meh, and it is not that
> many places we need to touch, but we might want in clarity.
> The same goes for hugetlb_unreserve_pages() of course.

indeed, will try to work on that in v2.
> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 47ef41b6fb2e..eb4ab5bd0c9f 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6532,10 +6532,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
>>   }
> [...]
>> @@ -6558,6 +6560,12 @@ long hugetlb_reserve_pages(struct inode *inode,
>>   		return -EINVAL;
>>   	}
>>   
>> +	VM_WARN_ON(!IS_ALIGNED(from, 1UL << huge_page_order(h)));
>> +	VM_WARN_ON(!IS_ALIGNED(to,   1UL << huge_page_order(h)));
> 
> If we want to scream if someone passes us unaligned indices, we might
> want to do the same in hugetlb_unreserve_pages() ?

Sure.
> 
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index 56c8833c4195..59c174c7533c 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -80,14 +80,15 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t index)
>>   		struct inode *inode = file_inode(memfd);
>>   		struct hstate *h = hstate_file(memfd);
>>   		long nr_resv;
>> -		pgoff_t idx;
>> +		pgoff_t next_index;
>>   		int err = -ENOMEM;
>>   
>>   		gfp_mask = htlb_alloc_mask(h);
>>   		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>> -		idx = index >> huge_page_order(h);
>> +		next_index = index + pages_per_huge_page(h);
> 
> Trailing white space.

My bad, should have checked.

Thanks!
-jane

> 
> 



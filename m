Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D70E9D41E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1026B0092; Wed,  4 Feb 2026 12:57:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589346B0093; Wed,  4 Feb 2026 12:57:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4162A6B0096; Wed,  4 Feb 2026 12:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8496B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:57:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C73D257AA3
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:57:25 +0000 (UTC)
X-FDA: 84407531250.17.911EA37
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34337C000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:57:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="dcn/lZ2m";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wQwVbOxs;
	spf=pass (imf10.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770227842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6v30s+B6WV0jpAon7j688ojq3guo+j7p+OwkHg8nRRA=;
	b=P16QK2hXnGathkIYisg4PvVwvm+RSIEcrp2AtwS70R24c00hzAbvRrMqtSAQjZAHjTF+lj
	nd9Jms5vAqvh33OlS3oKIWdIaRmaASaNgKvO3gd9oOb88H32n8qKbncdTTpdbY/K+5x2f8
	5+e/17fJ4Hpa5n99LM/NXJyOHTDG/qM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="dcn/lZ2m";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wQwVbOxs;
	spf=pass (imf10.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770227842; a=rsa-sha256;
	cv=pass;
	b=SFAEkbl2dbfsmBnGpdRyhfxBJfwgptUbI9kNNTsEmCQAIRL1gKXJRP22Y/PXnHnOHzRfMW
	IukPXvVyQ3UP2GyLwpdYiADKpxM4jy/O1ncN4BC/9X82lzKyI6nS1A6D8Hklug0w6C4ksc
	jfyFIqhaIFIT5VYrZ9jSIIq2XcYy5ys=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614DOEtN2146407;
	Wed, 4 Feb 2026 17:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6v30s+B6WV0jpAon7j688ojq3guo+j7p+OwkHg8nRRA=; b=
	dcn/lZ2mF9AMA+ABecKOPbn4yHrl9NyX72EwmpXRIOCFHaVrISuOArf2oHsEGhhw
	ZT/BkYEVEFMnFetel2vFFpwvC791eV+Lya9Y+n54V7wNu1f+ySAaqiwjauD4QC9V
	s7dUy+6BcwzCgrs0CTn0p6LUzwBek+eInmBJ7kDzg7RrIK6bRZ8N7uS+9Q1jbnE4
	q6xPGMpJpYHI9OtWulO2gAvz3lhJOfAqkLWxRhPPLUwH5J4/Q2doM8NS9Smk7eBz
	I2q9MLYvBvoGNdYwxrtRI2NbagcdSoz1k+f2odMu7QPAa+Te4mUyE2mRShoKBawe
	Ec94I3r04VmWSKIeUN3bFg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k7uj962-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 17:57:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 614HK3On018647;
	Wed, 4 Feb 2026 17:57:05 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186pa466-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 17:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8u7ZmeefCqSXS+m0sD1VbNodYNs3DCRGffYW2AeGLXKqEZ2BKjg+WHuts2BiHvvuthLr1X4lAdE60n/c+lVBQbiR4O0F7wpzRuRD3LyWGcQ6Kl1+l3ZOvYrUTLgVrfiaGZMNjbmI8jSNInyyFVz2eSbmigR+XemxZh+EjtzWcGItkkjEdWGuiI+wa+FGazyUK8fqHigxhfe4DbeW9M6AFdP/LOHH3lnq2zbz+B0/yatLruGgVOkFdfPI5Os6OQ5YY6bg8N/maB35rD/ZwcVP/y8fTG406ZNJxJ8IyFZIj7RppFcMzObsfVkNo9AawAeD3SmVX39C9j/rsuQE6Db7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6v30s+B6WV0jpAon7j688ojq3guo+j7p+OwkHg8nRRA=;
 b=AnfMQveVPuLtZo5a1PeAnL22iA7FkMxm1A+l1KVrEWbKyCZnV1y3xO4ZQQ27On41lHL0Ccl6V3ECfBTN7YS3bKvdnm1WkOlKC9rLQcutuJNxD13f9QqHhBY7yV22aTrITe+7SNjpiYS8hmo1U2m/QNhQQoh9UtHaHdcdpGkbZ1gSdbJECv9k0/dbijK4gCsVJZJbzWgMl/IV/8FFu0pE75Txz+qnCk6CIbtZyvtMOuwMg5qkueBNdqMqnzzvAcUGsI2e+pBGs5z6nH+00jERNWCyrNSwSUfA9nMuf1Y6k7bzlHloddFFONY9VeL2WH/67LeVv3s591kcFqdhKg5CgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v30s+B6WV0jpAon7j688ojq3guo+j7p+OwkHg8nRRA=;
 b=wQwVbOxsAI8PqWPkcvL72H8qreA4g4USCvf7B4H6c3BJcS12nkJL55M3fbfZJ0+e6qg6LEgYH4gjAMoG0R8gF1OifNhTmAsAPI/R5TqcCG5bdWMnoMEWRR01tfNT4GG55D0M8mCMcM1mfGjmg20KIZwPJnHBeFiWNcm1u/rMPZI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH4PR10MB8147.namprd10.prod.outlook.com (2603:10b6:610:236::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 17:56:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 17:56:50 +0000
Message-ID: <70d27379-2b61-4a62-9b98-d1b0df621027@oracle.com>
Date: Wed, 4 Feb 2026 18:56:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] Documentation: add documentation for
 MFD_MF_KEEP_UE_MAPPED
To: Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com,
        harry.yoo@oracle.com, jane.chu@oracle.com
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
        willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com,
        sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com,
        dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260203192352.2674184-1-jiaqiyan@google.com>
 <20260203192352.2674184-4-jiaqiyan@google.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <20260203192352.2674184-4-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH4PR10MB8147:EE_
X-MS-Office365-Filtering-Correlation-Id: 35b69530-c02c-453f-b584-08de6416c582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azViNHN5ZXVwWUdmTDRYWisvc0UyaEc3eUVYa1NYSWM5ZnYzNDdIRGplUnp5?=
 =?utf-8?B?ZWpQMHpzVHc4dUsyTEt3RU5nak9FN2RLaC9mS2dqaktxdWoxbEt0dnEvL3cz?=
 =?utf-8?B?dGJNd2d3d24yS2d0NmQ1SGNvOXpmTXN3ZUJTY3FmUTZPcGFaK1RRUUxPbEo2?=
 =?utf-8?B?a0VwRTZVYzJEQjE4T1Y2ZytDR3lJUm9sd01ieGpJay9oQ0FQa2trdk9nQzhy?=
 =?utf-8?B?S2crbHYrZEhzcnZ2SUpJTm94VjQ3dlpkTUpLUS9TZkQvZEhpVmxaU1VoRXVX?=
 =?utf-8?B?dlBCRzFyWUJEUEJyZk10NndpZzYzdTh1RmVEcVJONzRwa3AyTENVZEIxSm01?=
 =?utf-8?B?NS85K3MvMFZnaGNyVUZNeWNYWTQ2dVo1aU1VY2ZhU0ZiK0ptcHBTaDdNbjQ3?=
 =?utf-8?B?ZXc1b3BLMGZyckhHQ0lWdkdEczh6V0g2WWYxRzdQRk9xdmtUbzFxelZzQmh3?=
 =?utf-8?B?aXhWZU5QS2hUdE9la0xsMmFWVFNQOVFYWHp0djlXRjM1VVJveFJWTlh3eEhn?=
 =?utf-8?B?c240YzR4U1ZKU01MZFpVUENuMGYxUjdNbTQySUIvLytiWTBQNmV4dUtmdzNG?=
 =?utf-8?B?b1dlZTg1TjRwdmZuNzdKNzhFOE53M1VpTjFZZnY5cUNhR29jRlBWSGN5OTNR?=
 =?utf-8?B?T1ZLWmpSUTR6SXJLdjY1YmR1Si9tTnJFNEtINEZBeEN5TUhyZEhqc0lLOXl6?=
 =?utf-8?B?dko3SDYxd2tqSndXbDJUYWZ3MGFadUV4VWlCMzZ3dFY1dDhtWkVkazV0cXJj?=
 =?utf-8?B?NWFZMHUrTDJINGJVQjRhZ3dlVk40amE3OERkbFpDYVN0N2w1dnBqTW9XU2du?=
 =?utf-8?B?b2s2Ui9tb0xtNVYzNEZqdW56MzVEemRCcjd5VWZnWDVNVFNhc2ZXVjRLYmFu?=
 =?utf-8?B?RGZTN1VmU2pjRHpJOUk0eWVrUzVoejBKYmNPRFlHaW5TaU9HellOak8yeVh5?=
 =?utf-8?B?NFJMaFlhSXFiNCtaTUQyTTdUWTE1bVlGWFdITm4rZGZpbjNvMjZUcE95U01j?=
 =?utf-8?B?VVRzREdqVFJqZEk4TWdET3AyWmJEVHlJVysvcWxabmZFMWZhRUI5NHpTRDBh?=
 =?utf-8?B?MUl1M0xZbyt3Y2Y3TElaYURkKzYvTWU3d0Ztd1kvU2RlRER2V0lyd3Y0Z2ty?=
 =?utf-8?B?aS91Yll6cEV5ZkRrSXJtRkE5WE10OEtPVk1EVmdSZEkxbERhRWpHd252ZlJx?=
 =?utf-8?B?c2dWTkpqVHhwSUViTndZQUliVkF1azlHVmhBQ0ZUQ0xjMndmMEVYeUR1bExk?=
 =?utf-8?B?bjkwclB4bFRkaURTOWtXQXFJbXFnZU1Ic3p0ZWVVbVlTZFZMNkY0WXNuWVVN?=
 =?utf-8?B?N0ptdmdWQnVNSTNHYk5qNFNaU1NMVnVKaS82MjQwR2MwbSsvekNOVmt3Tktu?=
 =?utf-8?B?TGsxcUJzYjErZEtnYXZYSlNRL3o1QjNGdW8xeFhXTzdDZVRaZjltTUxiREJT?=
 =?utf-8?B?cFFlQnpTNjBUVncvMUJ5NU1pMGlsMTc0YXB3dnh2R1E2aGErbDhOelJ0d2xz?=
 =?utf-8?B?ZUxHVTZsRllSSWVrbmNrbjVvbWxXSHByRjZyU2JsUEJmNXRLdzQ1WDgrNTdh?=
 =?utf-8?B?bjdjYTlEMW44Z2VPaUI1N3pIaGYrcW44akpRL2owODZiTFR0ZlhTSDJaNmsy?=
 =?utf-8?B?dXdoMmFQcmo4MmJ5Nm5uMDg1WHBYRTlaT0UxR3NzeHpORHBEaUk4Znh6aURh?=
 =?utf-8?B?a2JTY0YyYkpZTlczSHEzYkFmcFJTb1p5MndNVTBpRUVNTytUTUFBUkN1c3Yx?=
 =?utf-8?B?UTdWbWF2WjFUa2FLZHVkN3BxZEVhTFVPQ08yMkFhNEZveGkrU0ZJU1ZxWlNK?=
 =?utf-8?B?d21Xc0JZbGQvclV6bVhxZTFCYitLbnBWMXBNUnpMbmx3eHBYVmk2VTU4NE9s?=
 =?utf-8?B?ayttZmtybnh0aS9YbWwxc0dKUEl0MlNsdHZDYk80QWFwZnBUVU9tWGpoRWNT?=
 =?utf-8?B?dEJSQkNlZWlKaTE4WmwvTXFFQkI1M3RINlJBZFFpcDRyblZ2K0h2Y0R1STNS?=
 =?utf-8?B?UjBXZ1lvQVdDVFR6WUtYZVhUWnhtTXZua2srZ29TOHliMEZjVkZiQ0t1Ni96?=
 =?utf-8?B?L0hxWGQ0eFltZ05UQnZkQnRsVlIwakJIVmxvbnZmbUFYR3ZvcHVNZEs2VXV5?=
 =?utf-8?Q?q/JA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SW5VVzF3TGdiSTArTUthajFBMm42Ylg2YmRidmtsbmI5TGpOZUFvSWpBdUVS?=
 =?utf-8?B?WHprZWtuUWc5eCtUVUVFM1h5OHVROWZmNjJPYURKbVpFVXYvZHh1ZzNOcVNW?=
 =?utf-8?B?cW8yL3ByejFwSkJEMVE1SjhxVmdTWmk0K3ZiSitmd3NlMlJtSlBpZWVoU0Q5?=
 =?utf-8?B?VjdmTkRlWnRFRjZaTk1EaXNhb3IwekxsUXZ0SGs4aFRsS2U4Tlg3L24zdzNI?=
 =?utf-8?B?dUxydWxWMW5lR2dEN2hEY3Q4TmJHMldhNlRkMlBxYlNaYlJRQjVOaE5kN3FB?=
 =?utf-8?B?VmpIeVk1T3JXWUs4cVhvdmRGKzNDbmd2SFhpRTBScGpDZTJvbW4xcXpDblZX?=
 =?utf-8?B?TjNPYkk0OUFUSUFVaWZNVkFxcENXUWtaa2VyRU4vT0NCeWVxbHo1UmZHOG5a?=
 =?utf-8?B?NzVWb0QzRnY4ZjE1QVJRVzgyd1JQSndrSktQR3djbjIwZkx3TDdZV2IydVov?=
 =?utf-8?B?V3Ivb0ZjK09qM0xJakt4MWNXaDNneG9kdlUvVGhqcnpQKzBWN3NMSTJzZ3JN?=
 =?utf-8?B?cnNiWW9FTlVBSm9hd1lucTdzb3htNXEvMU5RYjdZMGdqUisyQ2Z3eE9aQjFS?=
 =?utf-8?B?Qk9obTB1UHNLS1VzUEJnZExrYzhKNHUyS1ZhcHg2T2paV2d6aGh2TUdGVWpW?=
 =?utf-8?B?eWRKeWw0QVZKNm5NVlJVMXRJbzdERjhPQnRoQ2NSbXFFbmh3K3NvVzZ2WHow?=
 =?utf-8?B?MW1yYjduUVZRc3o3clhhZ1JYamp4bU1PUTc1VUJTMEkrTWlzM0NVcWd0MEF0?=
 =?utf-8?B?Qjc1emNPWGVlQTBwbk1CbEh5TXlCUk1rSDZjQm9Zd3FpNUFLRW82dXFybWZD?=
 =?utf-8?B?ejlJNnA4RnlBRmh3UG1sYzdySmNrbkxFNTlaam9GcWcwMVVwMExQcmtGSzNH?=
 =?utf-8?B?ZldIOUxkL2E2RG8rRUtmbFNaOFhWUjFyZkhYNXFDMkdqREJQRkc1b3VkR2Fj?=
 =?utf-8?B?ODFvN0NXSmtDZzF5a1Qzc0lLaU1HQ2E1Nkd5SlZ3QzZRcVQrOEppWng4ZGoy?=
 =?utf-8?B?Z25IdnRoQThCRVdIeHVRYmh2S3R0VmdUQlhyRXAxRXN1Qkx5YnZYZm1xZ285?=
 =?utf-8?B?aDFSb0RmNlNsR2pZREIvYTdaTmJRVDZIZWczaWRTRWlwZkUvT1JZTTQ2UTE5?=
 =?utf-8?B?RGtKblI2ZlNuMXRzMGlyandaby82KytNalF6cEw5OGMxempEcE51NDlabE42?=
 =?utf-8?B?QXJYTFI2ekhHRlpqZnRxd3ZweGlSdHNuZlVGWERjMStkY1VEbGZ2UWZ2VFRz?=
 =?utf-8?B?QisxNWFLL0NsTk9sdTFUSTcyOEttM3ZHTVNHTmVobldGTzZLSUZXbHJ4MDlP?=
 =?utf-8?B?aGp6cm5sSXh2UFB1aENDbEl6NHI2c0FYM2Nnb091VENzTmtweTFRVExhSmFy?=
 =?utf-8?B?eTFUMm9wSE1KRlozY0ViWVZaZXlqc1FRY0FFd2VIMFdwaEFIWGFuaU5JWVMx?=
 =?utf-8?B?Z2tMVmRPRllQdmx2ejhGeWxlZUxJY3BxT1dPbWtvTnF2ZTBqaUlYNHA3Nmg3?=
 =?utf-8?B?dm1TS1h6a2dnZUdhNVhYVmsxeDJTK3lwbTJTK2NnSlF0dlJPYW9UQnlONDBn?=
 =?utf-8?B?NHl2TkFHNTFFankvVEpzckoyNzFabGovQlBOelJncFI4OWJDbXpNTnF5RHJ2?=
 =?utf-8?B?NWZwbXIwWk1PTlgvSCtlSXcyUzRRay9kbnRBTnVBT3ZSMUs1Q3hvTkQyYXp4?=
 =?utf-8?B?ZTNacHc2TDNCUGZndFVzNzY0Y2ZGcmlaWVhSZUpyNWdzRSsyakFaSm5vRDhv?=
 =?utf-8?B?NDBHQVVuT2ZsOHRaOEpWRHRBZmpKQXQ0ZE5jdFBZVVdVWUpyaVVqR1M0UzFF?=
 =?utf-8?B?bGdkUUJPS2JUVFQ0SC9UaXV5azBtVmwrcnhPYVVoRW5qVzhSRCtmbGJxVlpE?=
 =?utf-8?B?SUJwb0I0WFVBYmJDdVJ2R2hMaXRPMDQwK1d1Ump6SEtiRlRRNlZKSUwvMnRw?=
 =?utf-8?B?L05qa3B3bkNKK2F3N1A0UjU4eUpKK0M2MFQyQmtiOHZLTTZQWld1Z0toTVNT?=
 =?utf-8?B?bkJuK29qVHp1cm0rSDVEaFJLa1d4SC9wLzZJR0wwTkxML0VMNEFBd2I5TDFQ?=
 =?utf-8?B?QU9CaTlvRFpSK0xiZFplcHZ6YXl6WXlJemRnb2hnWDhobmgyV1JVSFkxQlJo?=
 =?utf-8?B?eUgvZWFqbjJnZ3JYMGVXdVFMQnlxbGM1WWZKNk1acC9nMlhtMnJPMXk0S1NI?=
 =?utf-8?B?c0xXdXdVbG1kM01MZzE1QllIRzRXTzBzNkJuQlRRQWh3bkhnbk0wa0MrZllG?=
 =?utf-8?B?SnFsSzFJc216ZmVTd1pRMzZmOU9FNVlRaHY1ZmxvTXJHR21mRGhSaFBTaDA5?=
 =?utf-8?B?blFwVHR6Wmc1Nld2TWZIdmJRaUU3ZzloTnNTU0RWZWpHMGpybkJzRHhBNnVj?=
 =?utf-8?Q?p4CGtw6YQg9R9hLc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mi+ZxDGWJsAmR96xlXGIBCUm5ekz7zBi5qbKFBJqIWhjIrxo0z8YjAPh5ENMmFTbP+ygnSIIASgxygtSnmnmv43tDUcFXYvmy8Vxp7LcbltS+ny9T4issg8tvXzbAmIV9zr87nUFXA9EJpthOMMY+Rp77cx+mzjFpufsvVxjhNHlpfBf61wctpqVZIFGisrGSeJ+HtbauLFPZEEq/uvU/mzA1xem2PqeE6N7O5KLY7tnA7y0nUJxrG/BLtlK+qWx7nwWDuBFR/H7qjLonaYzU8DcouUxdBLxPXM3yavPIC3DG/9/CQOFYZ7Ru5L+061Y4M6D1gPmAZKXM4/bxse27UkTkbRZTunprvTWP3gGWtke//YbPryAu/q2zvGkVc3iJQ/ToOV5RUoO0WEDPCYaOPqV09XjXsnDMEdhNhlIfX0sww64PK/qhaQKBo3eYiE9rpY1tit86oOJfahFZiHfQb3S2tQZXmK8fXWWNt7BsZmsUXOq7PvEn/lUXH8myBkZc0icxjMDc9L5nKu+SEH1sxux6rt2mbTk+hrZZERH57zJGe1xj5P4z84KraT8QEitVZYkIrYVepa61phDRvLOBl6CercG4Hs8CiahdSRbb/M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b69530-c02c-453f-b584-08de6416c582
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 17:56:50.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUrqsdvNLBNvK8dUDs6iTxXASoec7aUUXKAv/FC9CUj/Sry8gdXQkGHL2Ho7NLDWAUle9z+AX52EpGsVooslWTYg6OeYlBeTNCXSZGvzrJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_06,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDEzNyBTYWx0ZWRfX7yddCvaKBOP8
 VjQu0DnqYoxZ9VvdRnSe4GmxgsrhUtLHu82pI/u5mSjkU/wxQUBb4FVe1/S0uvx6LzOVYWQB9Ny
 QEQOIsvMxFospqo7zO/LMgxav3v1u5lzhQuTm8npcc7L2EkuG4d4+kFn6TzCsaqDDYz3S0IhSa2
 BRAe2bPR8I44Z4RWeWnKqs/qotgmSShzanGPSp6DqgmBr8SJJmxve9wLaFMYDDvJJpDlYsZGyQx
 Q0bDSYXvwIVUtK9bzcUdpVNI6pZeZXlXTw+K02GhuYt5u27ePfan9RhbdWjWWPKEvTZgdQMNCKe
 56u91hVqYkhmJEYswkMd3e6Ew4odbVp0Jm/CO4BwSEYHIqAYCcC5RQhYivBeU8dSPOlmXCBxJgi
 jREW5vgNHCfuTfQdQR9CYx9ob1p6wf8V6v86nEFmS15aeo+Figi896x1rMiQ1nPcNYNW4YcGQTI
 E667qAu/3GAYsibn9HSkILmojlquRYOJVuxy9jjI=
X-Proofpoint-GUID: QwiW8ZiJuEI6ivTFEz_5nyvUNj1_cToY
X-Authority-Analysis: v=2.4 cv=Z7Dh3XRA c=1 sm=1 tr=0 ts=69838872 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=3E4yJ9fSZk8sK3EbspsA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: QwiW8ZiJuEI6ivTFEz_5nyvUNj1_cToY
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34337C000C
X-Stat-Signature: duzupfjb34ga4qcr1xoaojncwg3koo3y
X-Rspam-User: 
X-HE-Tag: 1770227842-455640
X-HE-Meta: U2FsdGVkX19ar2uuMiO6D9Svu1YZAHNXg5M9SsFY7WHb1Ct29ku6ow1kUFDmOm6ar1z1Oj65W+y07khe1P60FE0r8Zss7g9UQbvWU2GJfW3HH34H6GYm9y7OqlIJcCZ/NO+ol8KS12cstn1TZmU+ZH4euhSiePrqUzCDUvSCqEntu18oc3uvPm46BW91y6SxOwcihzONLO/07bzJS+n8lEQm2g5zGu34cM3bGqaDJ4RqygBmNRIdma4rzopOB48ZiqdjjGkgz3cXDEKJmlAOMp0OUKH/qjlgqYPv2HBrM8THaX9n5H6qOcmSLzrdC1s3cRKIvMW+wHqGQJQVxSCzQ/T876aJ55kTuGgqSOENkXPEbXde35WgWWrTTXm9KGkNHFYgW8dVgvhdXD+ung8Z0TkRfsgigg9Aiy2T3g11YxL30bqcx2zbAag++CVZXNZxrezqKudIBoWhFshv++VZCs5aVFC8b6TrUOZcYlruMdXTRCjvyiZLZffNY+rat2Jtk4Lo2DhpANfJeS7KA76I0YgGduFBb7LvhG4+H649dVoIbQ5OyBbD8sqKclMJtFdc/Qr4t7TPrtNo0yVGyeiubbGu516axzpZH1fT/UhlutanGoRAJDgeAYeeYbG9UWU/i24BFLWZHb4GINo37F9fQcky+/jZMIeQIb71W7QEMYYfNyyAGjmO2PUrfCq+Kbp1y9V8GD3nqlHeWcpQ2lFZdMMUQAvVHsWzvUMeA4CQitF4n1aukSSJh+iPeMjTn7QYIPdg3RCTsI5a0ZlhqWQO4DaGYDaZXOJt1+GnFTwtjy24vB/qNxKMRSvUZx6zQrsG9GYxtEAn73s299N9LyXP30hNjHw01cNsLOQbeguUvcc4pRhkc0qiu4u7v+GQkKEevDyTIGgMz9h5yHGip1ASMaPPtnZm7pQNd3H9CI33s6Z4WM7tti5ZoN/kezlIxENX/IlgU0/TQT1r6RfdtTB
 xpHba20V
 0d/A6eiEzCQ8CpzAgDZK7OsNdSEABHYBNhbU/cbWisgDWufRF8esrrQxWHGZK2kg1y+7bNRjLx1x1VNwp2UCVViPfnGO6W/9YH7lbD48dRLvBlzNECz11pSZR4NnWOEL/Cf2maA1fJnwcCE8rdjUC4+4L87iBNiZxEQsOz6tJvwMQ5Mn1Y6hBE4thKW04RkKn4dboKKLjTxRFNtvUmsKq838Ug9GceSO2oJ4KaIISRpbaAoYKNwBdsqJqxGDnM6A+g3gxkDvfRafuYOqovT5QulbDgslo0yMIxfqlsJ5hywsUeDl3mK84nhyRdmMEilEJAS/lPHEaK9pVALCkc5j+8qDJBJCT42TYqcmMKgSiRwbIuVQ7dgfgm5Yvxjv9VWEd9g8x7ZAgDdgyB43lsnKMJ3sI3znygPHxcDDafevPRtx09ZauUURHsBZMulTvnQyBb1cu2sFFKlzftEmIwLCPi9/l5iEhjXY2PD3xAJsmusYLWP0WDha4qf05J/bpXJqEhfqAZTSjaEC3cLy8IY//zOq34mjRct0FS1cD/oHnPJDq4p75eKJZODrPtqpfh35aF9z0qk5jfzcuQJxh2L8b4iZtThyBFN/DHjPPrk4p3PFjqa61mDPy0VULg4qv4gFhbyfAlPRzZR6nzq44XzcTnmI9oWY9Md2BZDW5cWf0whhUz0pvh8J1xF8RsL4PUfwt4vddOrwP0lwzkKf0AzqBXmHEZJTneI8YmphN092OOXDN5mfzeAD0P2VhVjkyybWzGXUKoONMK3OI8c022EyDJMaZlvM3K04B2UucJ7sfJEqGBpJgguqq+GtGgmd/ilEKFpe/K/eBkOJ6POQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 20:23, Jiaqi Yan wrote:
> Document its motivation, userspace API, behaviors, and limitations.
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>   Documentation/userspace-api/index.rst         |  1 +
>   .../userspace-api/mfd_mfr_policy.rst          | 60 +++++++++++++++++++
>   2 files changed, 61 insertions(+)
>   create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst
> 
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
> index 8a61ac4c1bf19..6d8d94028a6cd 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -68,6 +68,7 @@ Everything else
>      futex2
>      perf_ring_buffer
>      ntsync
> +   mfd_mfr_policy
>   
>   .. only::  subproject and html
>   
> diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
> new file mode 100644
> index 0000000000000..c5a25df39791a
> --- /dev/null
> +++ b/Documentation/userspace-api/mfd_mfr_policy.rst
> @@ -0,0 +1,60 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==================================================
> +Userspace Memory Failure Recovery Policy via memfd
> +==================================================
> +
> +:Author:
> +    Jiaqi Yan <jiaqiyan@google.com>
> +
> +
> +Motivation
> +==========
> +
> +When a userspace process is able to recover from memory failures (MF)
> +caused by uncorrected memory error (UE) in the DIMM, especially when it is
> +able to avoid consuming known UEs, keeping the memory page mapped and
> +accessible is benifical to the owning process for a couple of reasons:
> +
> +- The memory pages affected by UE have a large smallest granularity, for
> +  example 1G hugepage, but the actual corrupted amount of the page is only
> +  several cachlines. Losing the entire hugepage of data is unacceptable to
> +  the application.
> +
> +- In addition to keeping the data accessible, the application still wants
> +  to access with a large page size for the fastest virtual-to-physical
> +  translations.
> +
> +Memory failure recovery for 1G or larger HugeTLB is a good example. With
> +memfd userspace process can control whether the kernel hard offlines its
> +hugepages that backs the in-RAM file created by memfd.
> +
> +
> +User API
> +========
> +
> +``int memfd_create(const char *name, unsigned int flags)``
> +
> +``MFD_MF_KEEP_UE_MAPPED``
> +
> +	When ``MFD_MF_KEEP_UE_MAPPED`` bit is set in ``flags``, MF recovery
> +	in the kernel does not hard offline memory due to UE until the
> +	returned ``memfd`` is released. IOW, the HWPoison-ed memory remains
> +	accessible via the returned ``memfd`` or the memory mapping created
> +	with the returned ``memfd``. Note the affected memory will be
> +	immediately isolated and prevented from future use once the memfd
> +	is closed. By default ``MFD_MF_KEEP_UE_MAPPED`` is not set, and
> +	kernel hard offlines memory having UEs.
> +
> +Notes about the behavior and limitations
> +
> +- Even if the page affected by UE is kept, a portion of the (huge)page is
> +  already lost due to hardware corruption, and the size of the portion
> +  is the smallest page size that kernel uses to manages memory on the
> +  architecture, i.e. PAGESIZE. Accessing a virtual address within any of
> +  these parts results in a SIGBUS; accessing virtual address outside these
> +  parts are good until it is corrupted by new memory error.
> +
> +- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
> +  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
> +  Otherwise ``memfd_create`` returns EINVAL.


Reviewed-by: William Roche <william.roche@oracle.com>


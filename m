Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AE9C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08AB8E0002; Tue, 22 Jul 2025 01:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB98D8E0001; Tue, 22 Jul 2025 01:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32978E0002; Tue, 22 Jul 2025 01:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8B78E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:29:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35A6714027B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:29:30 +0000 (UTC)
X-FDA: 83690772900.16.1EDEEBF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id B28D5C0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:29:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="S/2bIr9C";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h3OCQYeZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPTV4ukor7Fn4f+v2b4VotOka1fgZBS9vgG+N5vhY5k=;
	b=0gvcQWvaW+/YsT1qfn97AEV2N+mZvife6ZCGBCfuqkhjh8OvgOu6KP9eF2G93n8otey4me
	LFvQVyxGMmHXTJvl5C/aVHS/UWIBov803h33PtOOYVstKFVPMaNQhhluhIu/KpUexbtHPq
	stxq3gCnU15kc5AcRXr22Jdmd/eDpRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753162166; a=rsa-sha256;
	cv=pass;
	b=Bhf3GRP6NRmyEc6uwtdWM24N4JNeJpPzHmV3ypuPSSZiLLaffBGcODnOVTRepHvenoYrU1
	B6GxHdT4zsb90EQ9Zpnf0gWXS1t31pbho3/xPYnn19uyVTYjk9TptBIT5E4toOxKfB/X6l
	r1qZyhkdGH8OWQViKGIhuNvxu6jWusg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="S/2bIr9C";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h3OCQYeZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M5TCeY006879;
	Tue, 22 Jul 2025 05:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KPTV4ukor7Fn4f+v2b4VotOka1fgZBS9vgG+N5vhY5k=; b=
	S/2bIr9CfbdA571aKXdqPXmcHoJuip0UrV51SG3yWPVHxYvs3eKkfZ8LfqO8xaPL
	kUOoPjgVr1p5KwuQBLjidEY1NIHoLAvs/AOReldU/Z5VZIEWWQ412xwu8m1bQ2ZY
	1BnE6ycXL9Sm2XJzD4iKnRAOxjSyyz/w3ruWEQV+0gF4h6aw1UCyroQ6i+olTOsb
	qxF2IB3C4CgC0b950J8O4JVSZenNrX+NzLJCOaEg/M3fpmbohZfdj6BNBZKjVR1/
	KNlVgRi7uZxaB/u0BXeXePXcCDbEROgL+ES6MzbWcml5U1tVstm9cP+rPKlIvRNl
	IRPyWfW5N8tp+NvD5p6Ncw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2c9x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:29:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M3oA82038366;
	Tue, 22 Jul 2025 05:29:20 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8vuqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkH67wd5TTnfK3kfarmfY1NJm/X7YpcDocDSAKZy+XXdREfhwNpOSdBxzYYPn365Lnz/c8VZ7RKSb9mbXPItG/UKdGAtOO3AfZvdd9nbCwPMJE9nx0IHNgRt6GO8XinzcHm26iVMW1OFX2n42LQBH0AUvClahoo0wQf8InjI5dTd+Dsig68Dd1+C/0rBwx8In7JfK41NwgXcH6BvcEVryVytVig6kQJfAs/x+ARWXAGDGaHZBqtGRF2+P4R7gPFcu/PdL8yx3a+duWxUI87E+2x/qwqi+w7LdzFmoTq42EKMxol6RHCy21bvuaVKZ8cnzUwotVZG9z+gd5DfCb3gpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPTV4ukor7Fn4f+v2b4VotOka1fgZBS9vgG+N5vhY5k=;
 b=IhhNpfayXo6pLm93lUc+I+bsp0NRNbtfPwbFBYZ2MmkZrbNDrZ/+oGQQiDLxhCzc+rD12WUpDUfWHy6AfT9LOThpdLqe9HJBw3ygAdeHaw3sDardzxqfpfB4+LSEieUFNn9Pm4Mbf7o/zF7KElNejiZS1bVY2dUDOszUqrMbOYBLbjeWmwhA8Mql1ct3ImfhM13IP3JZVGLDIiTCraIU9/FC3WPPVGTgGA3YEnXFCFsf39W/5fUJe439KxG4Wgp2C2/1DwZm6wbpmv7HjLDJiHcdzvyRez6NkpBIRSVWJ2kKbRxUN3sKS/YwrLBmT7MGb7XedITzuSEGX74vXWxI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPTV4ukor7Fn4f+v2b4VotOka1fgZBS9vgG+N5vhY5k=;
 b=h3OCQYeZuDi2ESltURxq3AhMLVbtWyFM9/wJVgI4YhsR/MaK3x0wQSekZQ20DKRowB3dYnQBj5bVwSyKwoE2LLXil/7zlYbxjE2SmWjOwSndXgV8MH1w/jU5Z/apEdO97hEOK/BYyA4ZzyWM2d0kyJfYKV9zqzLp9WHAnYmKRUY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:29:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 05:29:17 +0000
Date: Tue, 22 Jul 2025 06:29:15 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
Message-ID: <c071c478-c6c3-47c4-a504-b1fa650d528f@lucifer.local>
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
 <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
 <a7062d0d-804f-4b9a-ba7f-62d67064c584@linux.alibaba.com>
 <CAGsJ_4wvWZwG6agXOzDoYBD_vnN6k4TRJjhFfR5dw5pQrk2mwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wvWZwG6agXOzDoYBD_vnN6k4TRJjhFfR5dw5pQrk2mwQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0144.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4765:EE_
X-MS-Office365-Filtering-Correlation-Id: 393abd38-9a81-4a5d-a038-08ddc8e0b42d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1IrZHAwTS9xa1M1cFRwQm9GR08rSDZuTmltWU1BNnh0TlNHUWJtZkxlZm5L?=
 =?utf-8?B?NkVockl6eEgwZklHVDUySi9qZVQwSDRsRTZCeHFzaGVyRWt5WEl4WDdqWXBk?=
 =?utf-8?B?OTRNMHR5emduZXlHaFZPRkJlc0ZpcXhvY0VoUlJXZjVpRTZMdEpSUDZ6VUlY?=
 =?utf-8?B?Y2FPUlFJNUMxSGh0a1hpUkNlaEdSM29UZDZEeVpnRGM2aE82WU9DQUxvZk94?=
 =?utf-8?B?ZnhDYklseUd6SzVsenY5WXRUTUdhdEJoZmYxL2tKRlBhSXlNVUZoTEV6Vzhs?=
 =?utf-8?B?bzFwbUtsNlNVRGhCekNKQlYwdGY4aHhSdlUrLytoWU8vRWtuOFdGZ1pRbHBK?=
 =?utf-8?B?bDZ1WFFKb2o2bTNIUzlacG9pUm5yY2R5L1BQVHFEYkdDTTZxeVFYZDhkb0Ux?=
 =?utf-8?B?VUlGc3JDNW5HM1lMcityUFp4Z0cxYS9hZ2dta1lleGR3SDVITmc1dnk4cXBy?=
 =?utf-8?B?UUNlQmhrV25SaVJZOHlTczJ4eWtvM05ETnZ1bENmY052ZkU0OUZPYUo3OGxT?=
 =?utf-8?B?SVJ0WGVQOGsyeVJxUXRXQVFIY0s1cnp3QzZFK213aFgwL1NDZkpuS2JxbjlG?=
 =?utf-8?B?ZmZKUjFMWkhRYTdLbTJ5bzVvTUQ4K3F3N1Z6amh0SThCbUNhUXBQUTc0Z1hE?=
 =?utf-8?B?ZjM5NjJsZ2lzRVZmN2NYMVcrZlIzMjcxMW1kanBWcGtqWStoSWZhYjFVYXpF?=
 =?utf-8?B?OWJ5KzQ4Q0hHMHFMcURPSGltTmx3Mms5UnV1SlpMZmdkbnFmb1l4S05XREdU?=
 =?utf-8?B?VWpiZ3dvUFJVSUtKR1hKODNGS3k1RXhRRmlhOHZTOWllSW9Rc1JvWjk0OFNt?=
 =?utf-8?B?cGdHVjIrQ1UrZ0h2QzViZlJXTG9EdzZvWG0wVytNWDgrOGVQOGZpaFVCaWRh?=
 =?utf-8?B?R0t2MVpGSGxEWndOVjBsTC9mWDZDb2hFZjVpOFp6c1lwWllzMytzWlNVd1dl?=
 =?utf-8?B?UmZUanJuV2wvekluM0I3cVp2ajZqZ0plc3FaVThNZ2oxL1BsVC9iM2s2ckt6?=
 =?utf-8?B?TEJjWE9kN2Z0S3l6OTkyeXpLS1FtaGFKNU5BSXcrdEV1Yk5HUTFDZVRWamJq?=
 =?utf-8?B?bnpYWmNrMWJqTjgvZUhFZHE4TCtUMHRkanNTWlBFTVFYZGRWTmk3RERCdWRH?=
 =?utf-8?B?aGtIMVN2Q2FWcFNsSWR3eG1ENnZGZVQyamxZSE9SMFozQlBmaGRWZVpreDNv?=
 =?utf-8?B?QlRVWDdNRkVLeXNNYmpZb3NDZGJPcHpyUzUrQnBRZjdLYkJUazBoNTd0N2Mz?=
 =?utf-8?B?aEl6NTZ1VU9GeExDWTlzaFB2WXh1SEIwT09UOEFkWm56M3Z0cm5tOUhYTE45?=
 =?utf-8?B?WVZvZVVobVVQMHc3bkVjVlN6a0lTdWllR1VpbHc3WDRBRVFESG9Yc3NtczIr?=
 =?utf-8?B?TGs4OG5iZHNiU1hDamhhZ0pBVkhIcURvZk5nRjY0eUd2UVhGMWNGaUQzdDA3?=
 =?utf-8?B?T2wwMjhyczFITEE4a0t6OWdZMUlsUVQvb1JoZ01CdXpqY1dVSFVmSXp6NmRZ?=
 =?utf-8?B?dVdybWw5cEFPbzBrM0dtRHZaM1I4Z09kYnhRdWxZdGdqRi9GZmRheE9jWFR2?=
 =?utf-8?B?Ym5zV09XZmhMYStuY0dYYUZwQ25DQXhHdGcyYnozaXdpN1hQMXM5aURyWExn?=
 =?utf-8?B?dUhiQ1hCaWRnZXdlVUU0bG9HZER3UDJUdmNBZVFPbFpZa0FXUlYycXMzeXRo?=
 =?utf-8?B?aXZZN0hSd2ZzWlMzZFNza2VzZ3pGNy9OUVltaHQ4YXJJY3hwZGdGMHoyK0JC?=
 =?utf-8?B?TWFhSVQrbXRQTHJ3RldZM0ZzNzBqZHhsdFBMeFYzU1I2TmNiektKMzBIY2lS?=
 =?utf-8?B?ZG5LTGh5RmRyNHF3RXZ5UllFYkZFNnJCOGZucTM1WEdOTDNtVGNkeUJtd2ha?=
 =?utf-8?B?Ry9vTlpmMStkMC9FWlhDTFVESndYTXVSQ0prOVp3UjdpSW96MngyL0NZK3Vt?=
 =?utf-8?Q?OS9Q3DHU0KZGTMqBcnOVGsHWjN0AJSyI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUU1MHN1U0lrMEcvZDBLMk1QUkVlbGlrM1Q3VWZ1QVUyZXFIaGtubzRyUWFr?=
 =?utf-8?B?SlFiQWpMSEM4dkJnb2FZZ1N4YzVMWlY4L1c2YmQyMm15V2pXVXArbFEzYkk3?=
 =?utf-8?B?RGI1b25hMlBRNEZOajR1TlFmK3ByS21xYkNpNkl6T3pNVW8yVFMxYkRMRGVS?=
 =?utf-8?B?Zy91cVNibnIzbWlHcXM2OGdYcE9XZzNSWlhMOE1sbHZqb2NkcFdIY0QrQzB6?=
 =?utf-8?B?Nlpkc1J3bUg4akpKbXIwWXE2MUxMZEkrRDV1dHZJdit0bHFvSG45OUtHbUVr?=
 =?utf-8?B?UlJZREg5UVFXVlZUaWpFYWppTlpQbU5Wdm94WFUxelJOeTNiU1RKdmJBcVl5?=
 =?utf-8?B?OGYrTW5HTnZhNklqeUJuRUxML293c2NOT1JLMWZPeElKeU5pZ1pZRUVjMkZu?=
 =?utf-8?B?WXZMdTdUL0RKclM4bUFDRnp0VXRjOVBwNXc0WW9NNUdJckRVeUJnbjJXOVY5?=
 =?utf-8?B?UGlsVWhNQWpHVlZVV2xrbUk5bFdkZ0VlNGhUU3Z6RG5SSzFaQ3dsdEFLUHNj?=
 =?utf-8?B?WGNEeTNpbmRwWCtTV0U3bVdXYXB5TzdxVVdSMW9XbFU0RER4aUp6KzRzOEYz?=
 =?utf-8?B?YnRranhhVG1OamJ3L2RqbmR6RDE2YUJtTmovM1dQNld1TEtHbjJoUm9FTjJM?=
 =?utf-8?B?Uk9QMmlrTmxROWZyQ3BOOWl3azhFUDUvc0pWTGNOVXdJVFNod1NmV2F5MURn?=
 =?utf-8?B?NzhSMk15YUdpRm9EaTdQZ1VBSEpwa3FGRktQZ2lSQzFSY1pENmxuQytWT2da?=
 =?utf-8?B?ZkQ5REZUQWVkNXR0QlRKTjJuK3JTWEFISWx1akxvamZWWW5UK2RlTjFsOHJt?=
 =?utf-8?B?Ky92cU1SOU55SVZOLzY3TTNVUzU3eC9maWs4K0Q1d0dpSDlJTHpMOC9RZXIy?=
 =?utf-8?B?ZlhPU2VicmI5ZEZpRlg2YTFIYnc4b0Y1c2YrMUUvRlBKSjg4bzhiZ1Z6NUhp?=
 =?utf-8?B?eGJycFN3ZXpob1AxZ09QRUNTUEhCUjZLTmFHK3NoVDlTbm1rRTF6QURpV29R?=
 =?utf-8?B?eHhldFhpZ08zMEJqRGwxeXJ0cytFQ29hbFEzYWZnZDlDeVpkWVdzL2laQUZU?=
 =?utf-8?B?K3RJdVpGN2kvMTNtSUc0cFU3N2NJRU5YZjZJNWVxeXZLTGEzNnRCUEl5cFB1?=
 =?utf-8?B?djJCUEFhN0FKT0hjemNiZlk0OEUwRlRxRUlJR0FYQW4rMHZGNXZHOWM1WWlV?=
 =?utf-8?B?YklMMXFZZFR5ajFBL3NKN3RoUmpsUDE2eVZVR1N3SmZ2S05wL29oVjlFMFFZ?=
 =?utf-8?B?Q2IwMmJXa08zSERzcmlJWXF5WThERzBJNDVxQThDZm5hQzZhNTF1WFhaNVl3?=
 =?utf-8?B?aGdkVXdnM2IyREZYOFhPVy95ZFBDdVhWSVJWZjV6VTI3R2JDUzJLSW9xRElX?=
 =?utf-8?B?cnN4cFEyNHhpTFpONys3QnBhaS9wU0hLK09TU3pMcmdkYndlK3pmZ0RpOTN0?=
 =?utf-8?B?UlloM3pKNiszWmt0TklXMEVHUTk2SlRpaHhpblVYbUlWVFFXV3pqR09FWnFX?=
 =?utf-8?B?clJLTzlHaEVIeUY3OFRTbzdORTE0MVlValppRms1OTg5UThYb0FBYnNOajE0?=
 =?utf-8?B?MG5yb0dzV3hsbER3QUpnVGd2ZGdGWW9hUDRMY3NuUGZoU2xmUnNsOFo4WjNq?=
 =?utf-8?B?VFNYZWVYanV1UldJR2JtcjgxMEhUbm1hZko0dklNeXBSa1JMMXpyYVJXRklH?=
 =?utf-8?B?eGxyY3NtNElMQU1HZUNZVzRYVjdxeVJLeGxzbk9FWDhJTzRQZUxzUUR0UmYv?=
 =?utf-8?B?Q003Yk1uclFtbitTVTJPYmU2TWpKc0ZxZzU0a0lCNk5QSHYwbDZCd2srSUcy?=
 =?utf-8?B?YlY5WUp1TklKa3NnR2I4STVlZXRtbUY0elZHbDRZekM3RVU5S2dwdmVqY1Fo?=
 =?utf-8?B?Z1h6ZWtWaUUyV09zeGFoK05HVmlweU82TGpudEF6c3N6WkJpY1ZxUzZtZE1H?=
 =?utf-8?B?ekVibGFOcy9zY2Y3L05aQk45a0ZtWVIwWTJCSWVEUkViTHFoK21BcG9DZS9M?=
 =?utf-8?B?L2JNK29tcm5NMFAzRnViNlBMSEpNekJVMWZaL0pNUkx0cUUyQTUxeDNQcnBr?=
 =?utf-8?B?MzkwQjVkQUlRdG5mYXRndisxbXQ4L0VpdlFoYWt0WVhaeUErWDZqNzhqTFhO?=
 =?utf-8?B?NHZwaEQvVjJNRDAyZnUxSlhDY0xhR1J0TkQ2Vy96WTdvVnBvTFc1V0RSK2J4?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wiNzIq/xKMjPSWwQp9jAqX57FtutsaxfQMbwLHLe7lZtd5ktHQe7OVq6SiGtDqs16sClTNV2I4//eIRs/QQfFgnbBmuLbnFYslXXzd8BJNGmtrxllNIF2P50liB+cRozhcfGDzSmb6Zo8JYLUXmFAUxW8XhmJZlK+wziViE6cDAD/80vft/b0YpVkHCxFt+QDEij9ewU+uFSmSFI2Sc/DG0y39VS7Yg33AP2ouVqLutRIHTZ7OSlx59VcwOhz05ZPPADU9RP5KRCsqzumqxhSS5js9+w1A7b+S61Wldcyh5g6bzoswrfi7gdfARM3WsfuxP12rRgL7k2L6KI60ep9ieYJrfs2vcvdOhxxer+IR74X1ltK8fLERU/7hwszywjl3lCqbyoOpqRuyym8yG7EdS1tw0lf0PqPzcVmy44CSiXdMeqFCuCqgNpooqciwLCIulVJkdPx3ZuPlHRAAPUGKCsQkmtKe5bcAQZVf5KWxx6F2WUviPr3pYlaQMeKdLeYatMMiyyaOkwwTSJeet5LgK1kiQSndPorYd/N6AD4nonlgodLZuMCE8/0onFVUZeV5bKNzPQ6aL36Xb7uSlB3X1ZU8w7Ixv9ijuShJLqtqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393abd38-9a81-4a5d-a038-08ddc8e0b42d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:29:17.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BU7dY+LEDlDJhLyCqsZaHeA5egCmGLDvmLnq0sdE/84uM6QQgJ4GAy97jrwlP8bzWM9Ct2KybH3reSc5ALMXQZv9SpfuzOyxaHc/dcHHJp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_01,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220042
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687f21b1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=MezuARCrH0UHzkXZVTcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12062
X-Proofpoint-GUID: vEthBi8jwTG01HimPlYwbAXUCugyp_c9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA0MiBTYWx0ZWRfX6M4buXq84qg3
 B4D1VFxCDAfZvKhvg2lyc9AOOG3GhV+BlVWxHc4a0o3AYd0jA2ggEE0MxkHjuZ7HurfA9H7rXq1
 iBT6KvnxzFSor+F2VJhz+ePvHMi8ukVu5DLAKw3/B8dDZArlejN94EPrfHXlQEX8bt2BLIGZngB
 8JbDX5W8xUHKBUwrmq5IV1gDJaHxwj6lHI3oeqcnnNLD8SlaOyW7jgipoHkMr94UcFA6zXKnxWS
 AvCufclM8O+WykIcBFhLmYUswLwrxOThbLbfo7N+r02plTROh5TfARzBtQGH4isfNAbnxiXl8im
 k6tOg02XaFbWEZ/HVJPRpUf59Ntnz4aoVqRKmL+g09HeBLZA4IR0JxZzbNbfGxEhydgseA/H3HP
 nOST3YgJ6D4j3+IT6CYSWxe1ZT/PljJhnv3rIhUMxO1Q9oVERSlBgzjjUUvH/6haPOvHI15C
X-Proofpoint-ORIG-GUID: vEthBi8jwTG01HimPlYwbAXUCugyp_c9
X-Stat-Signature: u43b95j3zsnjwc348cxgpj4z51rrhauy
X-Rspamd-Queue-Id: B28D5C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753162166-926498
X-HE-Meta: U2FsdGVkX19y5GtEyx97+I0UM20I2HfGOn43xfcCpwrkh6USJ8wLgZTs4RmpHTWtNL1CE/F9/hFgX6niVrCJXOUy1eJZZYbJgXL95FsDHWru7JERpniSao5xmO1NHtQ+8CH8QCC2eXpEJT+5ZBxYjQY90o61lSe2ZXgW4YRPjSNUSFAQrMmGJohjvGkMNDldod/BSjUM4M8pVmkyie/b6oqSyG+wd/SiHS4D3hiiLsJoTTEJ8KoienE5CMzmz6cCFD3frMmpy8E/Ga9TUjQgujDaAKSCCy6z68cMqmQRIy8ZpuOuDy4gq7gQNGGbWXMsitWTlnxXyOBEiruZpacBk54OTKBVbLobpcrja3FGz4W8GvZKiOkgsjtzWzSzsn0An7+CcGWSG6onTeKG9k/wFB2+LlwUimDuRXMGuv8jP6fG5Zxe1a2O6D7o3yOvMbzMn8jeyfU5IRCF19hz9w+8bpxAXeHki4U4+GD5MMrAeAegwb+usgD/YjY78GbY1JGGCcNSjyD7dIgbrUbIOnUejvmHGi5QIxknEhU8ye3vs/KxYwW+jLoGjinebqwW3Vdu0JMJFl8OTaMknRrFwlPspmbi3blIxzJnhXaQbYtQb9RSIkQc0xbQzjzcPb+phxqkMCPmBPJ5tyXUBfaqkmGlYecKJu7UOJ5AHdED1p/r/YSjqoZjqaYzw2F/X0rdc6VpWkiOlwROST3hhne6SjvRqTKV+ztWLAdpTN3FCzJUU2dcTjZ/98AFMYMX9aSyV/4xQeZxDRKumyJVjj4JahrBXoW7QGBjocpcVP+YrXG+0FVxAgOp/SATtW7CoUGvyIYY8JW0JcMEtOheLB52GVT9L/u15oPObUPauFQ/cfQG22FGYbX/QOSjPfDA/D1VdeELuP8M8wz67fKCt5uueJHJ9IOHdTC6X0m/x98uun+MY0GwDwTKxRGqDrkIdEeqm3/9zDoQo0iYTHppIuRTe82
 VB1T4IWR
 klsLplxsPtM13UsKO1XO2zUYb63SKYB1O/fzR3zqOBgyM5MClRykMBnRBE3ho/wVCeCvklP/8kIWjW4q2rypRF7gnn5ni9ClHYAYoGoe9KLxf+6Onx0OHHUkJUvLpcN6xJG31UB7ipa7yB53nJZfxTR2YS0f3N7dUjn0c+jCpaqkdqWIntfAaHfNkcu4UPI7dKW+yTvKl2JGIkuJuDWUToMaCTZelkaZ17ZoOl2KD3jwh89o7dVGPAS60KYfbBXVoaH8ahHjcKfl6qi/FyZhooCsL7XA4qXUV9NtpRjqTo+7KS20mInpG/vc6VIkbDQBS3yo2cr2B0FNP5YARVHpyjYbiqhIpCh8gaDsYNaB5uj12o57EppUUsF34RTAPX0toe4Q0f+g5qaz1Wpj4sfV25ljaAj3uwEhYP9r8uztxFMaGE+DWaEm2A0cWFxDT5/cMN2dpRItlrNTv135f2lZCjIwpEsZRDhlWlV8TuR2vHw/vPyQusQ96ymNqKc5DP7G2w5xhr64qUW5bzELDIBPNHUWJLAx7xtoggGSI+ek85vXb488ajrUhncYCdE34iHK+BE78E8fadrgDPTcCdwAthelfLMTdrgeacUhZ86yv0vc5CaC7Xk5eC0QKYmdWGdWgqQ4YVLBmTnNOQ6tGVPhDGtnoPAxCYhP8FcYuOpdRq2fk8tVxZa5Q3v+Dg+Sm/lRyFGMxOXkt9bZ3+VLemP49BDDCPyM0xHEkRzLiUFYUpJI4XgAYWcI1s5N3Zuze6CFdobxT6T8MqgOS92PimsMvIJ0af0gnoFk8IEjFpOHzAoak8RA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Hugh since we're mentioning him here, and not-trimming for context -
TL;DR I am updating the docs to reflect the sysfs never 'doesn't mean
never' behaviour for THP.

On Tue, Jul 22, 2025 at 11:37:07AM +0800, Barry Song wrote:
> On Tue, Jul 22, 2025 at 10:33 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> >
> >
> >
> > On 2025/7/22 10:23, Barry Song wrote:
> > > On Tue, Jul 22, 2025 at 9:30 AM Baolin Wang
> > > <baolin.wang@linux.alibaba.com> wrote:
> > >>
> > >>
> > >>
> > >> On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> > >>> Rather confusingly, setting all Transparent Huge Page sysfs settings to
> > >>> "never" does not in fact result in THP being globally disabled.
> > >>>
> > >>> Rather, it results in khugepaged being disabled, but one can still obtain
> > >>> THP pages using madvise(..., MADV_COLLAPSE).
> > >>>
> > >>> This is something that has remained poorly documented for some time, and it
> > >>> is likely the received wisdom of most users of THP that never does, in
> > >>> fact, mean never.
> > >>>
> > >>> It is therefore important to highlight, very clearly, that this is not the
> > >>> ase.
> > >>>
> > >>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >>> ---
> > >>>    Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
> > >>>    1 file changed, 9 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > >>> index dff8d5985f0f..182519197ef7 100644
> > >>> --- a/Documentation/admin-guide/mm/transhuge.rst
> > >>> +++ b/Documentation/admin-guide/mm/transhuge.rst
> > >>> @@ -107,7 +107,7 @@ sysfs
> > >>>    Global THP controls
> > >>>    -------------------
> > >>>
> > >>> -Transparent Hugepage Support for anonymous memory can be entirely disabled
> > >>> +Transparent Hugepage Support for anonymous memory can be disabled
> > >>>    (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
> > >>>    regions (to avoid the risk of consuming more memory resources) or enabled
> > >>>    system wide. This can be achieved per-supported-THP-size with one of::
> > >>> @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-THP-size with one of::
> > >>>    where <size> is the hugepage size being addressed, the available sizes
> > >>>    for which vary by system.
> > >>>
> > >>> +.. note:: Setting "never" in all sysfs THP controls does **not** disable
> > >>> +          Transparent Huge Pages globally. This is because ``madvise(...,
> > >>> +          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
> > >>> +          PMD-sized huge pages unconditionally.
> > >>> +
> > >>>    For example::
> > >>>
> > >>>        echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> > >>> @@ -187,7 +192,9 @@ madvise
> > >>>        behaviour.
> > >>>
> > >>>    never
> > >>> -     should be self-explanatory.
> > >>> +     should be self-explanatory. Note that ``madvise(...,
> > >>> +     MADV_COLLAPSE)`` can still cause transparent huge pages to be
> > >>> +     obtained even if this mode is specified everywhere.
> > >>
> > >> I hope this part of the explanation is also copy-pasted into the
> > >> 'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.
> > >
> > > Apologies if this is a silly question, but regarding this patchset:
> > > https://lore.kernel.org/linux-mm/cover.1750815384.git.baolin.wang@linux.alibaba.com/
> > >
> > > It looks like the intention is to disable hugepages even for
> > > `MADV_COLLAPSE` when the user has set the policy to 'never'. However,
> > > based on Lorenzo's documentation update, it seems we still want to allow
> > > hugepages for `MADV_COLLAPSE` even if 'never' is set?
> > >
> > > Could you clarify what the intended behavior is? It seems we've decided
> > > to keep the existing behavior unchanged—am I understanding that
> > > correctly?
> >
> > Yes, Hugh has already explicitly opposed the current changes to the
> > MADV_COLLAPSE logic[1], although there are still some disagreements that
> > cannot be resolved.
> >
> > At least we reached the consensus to update the documentation to reflect
> > the current sysfs THP control logic first, to avoid the misunderstanding
> > that 'sysfs THP controls can disable Transparent Huge Pages globally'.
>
> Nice, thanks! Personally, I prefer this approach as well. Updating the
> man page feels a bit odd, since it's something people are already
> familiar with and may have memorized.

Indeed, Hugh's input was important here and gave pause for thought. This
was not an easy decision, and I ended up changing my mind from initially
supporting this chnage... :)

We may return to it later, but for the time being this is the rather
conservative approach we've decided upon.

Re: man page - I _do_ intend to update the man page as I find it far too
vague on this topic currently, so that patch will be coming soon.

I will cc- the THP folks on that patch when I send it.

>
> >
> > [1]
> > https://lore.kernel.org/linux-mm/75c02dbf-4189-958d-515e-fa80bb2187fc@google.com/
>
> Best regards
> Barry

Cheers, Lorenzo


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855F7E8B399
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 04:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F89B6B0005; Tue,  3 Feb 2026 23:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6A16B0089; Tue,  3 Feb 2026 23:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425B66B008A; Tue,  3 Feb 2026 23:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 294326B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:26:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75A51D5536
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:26:36 +0000 (UTC)
X-FDA: 84405487992.30.0695FF2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7C7AC0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:26:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=COFxf52e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IkioPVNr;
	spf=pass (imf22.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770179193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8r9C+z8FBuPbodLm3LwTUceJbXN5NITayxpeONcNPw=;
	b=v8GNaMvljddWoOvsmH2Wp3b0vdH79LCwkd1nQAEcXno53ulyS/Y4FZnt7KXUtoCXR1kx1l
	y0OPpKKknIKkV+9RlcffgfrurjJZTakERiMCWtG81XcNmMZG6xb9MH976QnXWVxl2a952I
	ey5cDdOjW8W+XYbaMVcATX9yigcKv5A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=COFxf52e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IkioPVNr;
	spf=pass (imf22.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770179193; a=rsa-sha256;
	cv=pass;
	b=lqi/eCnOvHd+a7s+GyVHNUeuaBp9Jxub8ZLerNFi6o8YGTdpt8Mk1aC7BKB0zyevURlj93
	gLhz8Krl/LB5TZqdyCIukwYMtwUsjY2Yhla8JafrgwLJon3uUKu84ghvtpr9OTI9ISREKt
	R8CEx0KZCPMwS5ezJv+VtaoDlk0IIX8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuEOh580141;
	Wed, 4 Feb 2026 04:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G8r9C+z8FBuPbodLm3LwTUceJbXN5NITayxpeONcNPw=; b=
	COFxf52ebltwfw9u4GijIuMA33Quwcnm/uYrwhcFHXhYBdGL29c7rBZObjC/vp+x
	adZ8WW3XvZDu6KKCiU/9nJymt/T2lM/FmSGywIJsAAAssXwlS/3juNCuh2aw+Fkj
	wO761po4Oznh/dX5iFpRKfp7QpAhBjf+vxJlqcOAwneQcn11iglSvBDVknfedztq
	TLQNqzRTwHTMlFY82BlIrsoVzOwRLO1HHPu3UlU1d8T+sLuCxRH11If03sICFaFr
	RmHBGge5LrivBBm0RFeg27pbCD9UoCEfn2S6BXneUGWiIibAaVlY2IP2dMY0x9qG
	mxtWaWfGD8DJxR0I3zetcw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g136k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 04:26:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6141HvsU025694;
	Wed, 4 Feb 2026 04:26:27 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2579gpa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 04:26:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufwO+wLfzADwgdOfVNZ9cyNTtubRTWxw8H35T2zp3trIE7Xeio/YeizmyglAs7zLMTeFUA3iofDo1/X+Qzi1sWTIHIiGcPlDKLP8w11qWDXdx/bWx9iS+A4k/83Kmw6MdxI+F8ZzbVbpho282WGup7uMzYiKRMd+cYIT8yRpiD2nU5FCjuGI8yqLCmX0F2OXZhlRojbVMmpjfIWrcz0PPberkXjo/yrkN36aUZVcdBXasonMA1eyOWSZ18hfnK0WylLIAlS+wu4sE6S/2zCxqOcxrzQwmUHzcgwY/4tmfShM5zxNQI/XsYI4ARR3NskTlXolJxDbSQEmFXQDMkivYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8r9C+z8FBuPbodLm3LwTUceJbXN5NITayxpeONcNPw=;
 b=Y2C+kbweRUF+lrXUxZTZIWKiVfH4Q3SV4Uky6b+8L2pS3se88O/Xao8SjBGzuCnt1xOYTFju/14ySrcDjUM5OJpI1hdZVO1MFTQdXZZHxFoQuEBK067vhsC9XWtU8wLOs2sVu3curWDC8XtAaFT1Y0g/aNONLxGfT0X7Ywoa85IvLdJ/oCrH1u1LTAtqyCIV/2cJLGS1MrPky79YXkCb/sizL7YvmgYADkya+QzArysm8zIQvt+51hcDtQuWS1rczszAVIeKqja+Xq1ZH3S8hu5hXsbgpPmUqe0+B63Y790UAvYFY10gDIt8y5x/cHyxXaMIBzXCVu6eJoyG7E9pYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8r9C+z8FBuPbodLm3LwTUceJbXN5NITayxpeONcNPw=;
 b=IkioPVNr6v7Cl/TOJrr7mk8wfBOe1xFTa4qFqw7mD3hNgb/fHZQ657K1Ih5DNyff/DDg2c0ChPwJ7WUxA1ClhikaJXc82wFiWWX3Esz7VBGNSKN3qtiSADaBZKNPdJ9tLCgb3Sflt+Z/ddQilObVQsgfF8bVLv+iEKw+kwgnh/Q=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA3PR10MB8513.namprd10.prod.outlook.com (2603:10b6:208:576::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 04:26:25 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 04:26:24 +0000
Message-ID: <a4a6606a-06f7-470f-9b57-816f78378143@oracle.com>
Date: Tue, 3 Feb 2026 20:26:20 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fs: hugetlb: simplify remove_inode_hugepages() return
 type
To: Jiaqi Yan <jiaqiyan@google.com>, muchun.song@linux.dev
Cc: osalvador@suse.de, david@kernel.org, william.roche@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260202233617.2350734-1-jiaqiyan@google.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260202233617.2350734-1-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA3PR10MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b9867bf-aa96-4211-971a-08de63a58e96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y09MTS9WZzVMVVlUWXRYQmVpQlRpMHozaHRmZGdFUy96L0FhUU9WNlR2SVRp?=
 =?utf-8?B?UUpLSHVJbmNvOHFjZzkyWjk2aHZiL0hMc3plc2tKU2JjbmpBQXJhRG40NE9Y?=
 =?utf-8?B?TUVzejJpb2FaNlk5UlVlTGdpUWhOWWgyU2N1Zmw0ajZ0Kzk5TFcwWlQ5dkF3?=
 =?utf-8?B?VE95TTVrSk5OSno0ZDdnNThyRFVEWkhleXVLRGJUVWVLb1ZoZjlQK1gyVzlz?=
 =?utf-8?B?SU9rK3JvVE9FVFBSdmNPK0RWUFZZZm9WZmR2VGgxNTdRcFdXcEFQdTVtbzRG?=
 =?utf-8?B?czBFWEQ3OWlpbGJzUEVJb1lxeCtnamV1a0JSMjN0aWNVM0JSUlh2clJMLzRl?=
 =?utf-8?B?Ulg1T0k3MmJFMkZFdmlPTi9XQ00xV0szOHBPRThkTFlETlNMeHIxZytVWHJL?=
 =?utf-8?B?azZZTTA4N05yOUMrS2k1M3kzZGtvYmJqWEc2WUhqeVZwcmEvY2FJak50VllY?=
 =?utf-8?B?T1NSdkNNeE92YmcxdCs2NzZWYnM1Q0NaQnl2ejlRT24rSC9jMVF3dUVrb3Ux?=
 =?utf-8?B?THdlOGJuTmRkVng1VHQ1aUZVUm84UnJmcGg5Tkl5R2hxcjg5V0ZFYVZCY2FC?=
 =?utf-8?B?a3o4QmVRTXYzWS93d1gzOWk2WjZIRmVvUkdMTGFDSm8xa0xvZi9LWEFxUm55?=
 =?utf-8?B?MlVGandrNG1TYXlQM2Q5c3pUM2R5MUp5Y0tYQ0RpUk5CcUhuWHYwNWRYdmVB?=
 =?utf-8?B?ZFlQQVp5TlVtK1I5cjJmRGtiSzBNUGtodVpEWW9uWjRpa1hjVEs5STJPMVVj?=
 =?utf-8?B?bXZMVDVEeTVmdWNIWllWNzN6SllXREErZGNuVGUzREVYMTlJTkxETk11RElv?=
 =?utf-8?B?LytISklGb25IVSs3amFWUitSaDg3UENKeWYwMWJPbDlGNDRKWDNhVGhZUGdP?=
 =?utf-8?B?ZDM4emtLL3d3bTh1ZHBZeEFBNVVlSjJGVFFsaDJNYnFMNFVVWkN6akFOZWtq?=
 =?utf-8?B?dmFTdG13MW5Kb1FkMWpaQVJzeFpGcHpnWjRseG1yb1V5eTdyZnd3ZExPUUU1?=
 =?utf-8?B?ZkNzS3J1c0RvQnZoMlVRZ0duVVE0TkZSeDUwQWVDU05FU1JWK3p3Z1R3OGlN?=
 =?utf-8?B?Tlp6dHR0eUgydTVuQ0RQYzdYTVIxMkxYL01ieFM2RmlCbGFYdElWRmRTRzVY?=
 =?utf-8?B?VWc1aWYzaGpQMmU2cG82WkJsQVNTdDZpWHZDdm1kT1RuUlo0OXRSNUZmZE5i?=
 =?utf-8?B?Y1lCN3F2NVdkM3dvWm40Z0ZLeUJiaUcrRUJndXdhTWVybzJtZ2xYdENzLyt5?=
 =?utf-8?B?M0NnQXRtY0hwQ1pIWmVybGlzYWRWYnlGWnVtRGE5RWxUdFBaRnJlNUc0QVl6?=
 =?utf-8?B?ckFlNmdVRUdKZ2pXVHpIS0REZU42ejFKRjdHVEpodi9pMmRlVEhBTitFd3g4?=
 =?utf-8?B?R1Flei94TjJ3RjhJZXBJYjBiZ2ZQRHN2dGE5WFVEMTh4TnZvTU95VGNJL01Z?=
 =?utf-8?B?VDZ5NnVJeUdjYXJnM0gvUGdpNUVweUJaemt4T1N4TG9IVHY0QjNsYUVuWlp6?=
 =?utf-8?B?ZEMwMXc5TkZCL3c2S3FiUmI5bzA0QStxbkhKd2MrRVZEd28rY1NNb3lMcitK?=
 =?utf-8?B?VGpESzR2dndacTlseTdldWF5VmhyNXphRzF0elVvSmNaUTRHR21EUDFoa24z?=
 =?utf-8?B?YlgvMmNkTmJoWHNzdTBMZy9hSE9TUXgyRnRMKzFQTzVtdXQ5eEdFakRjQXFm?=
 =?utf-8?B?emVpY0NMbi9QWnJsRDdOMXV2N0VnU3pvYzBLNzNIVXdkblp0VmVmOUc0TlFr?=
 =?utf-8?B?cDV5Z1ZBYTM1TjNoR2FwQnI1SWhOVkhoN1BHUjI0Y3VKcURuWnQzSlNQNkdi?=
 =?utf-8?B?M2RCYVVoeEdCR0hRVmhNdlFCTHVOVVJWc2h6bk9zZHRjUVlOUkE5cmN0ZVZN?=
 =?utf-8?B?TmdpeStrNlhnT25IdkVWc0tiUlZJSzFmV2hkekxadXBwUUFjTlV6aUk0KzJy?=
 =?utf-8?B?all2WnR3ZW5OUHM4bDBoSG12NGlZd1hYekJqUkRINmo2cWZmYkFOWUFDUm9D?=
 =?utf-8?B?SE1KajdqYXJpYjhhcUJTc2orN2JBT2tQNVdxVmtEUUliMGFDbGtLRmFoZU00?=
 =?utf-8?B?cGkvUnpjbS8rL001dUVmWGRhK09oMjJZbnZIQzFZVHc1dHg4L2gyVzNQNmp2?=
 =?utf-8?Q?+/u9qsusrr6/fC4cjqiA73uXy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QStMcmRvMTF0NGN4UTNiVGd3N0toQmhTdFJVOC82K2owcy9yL0hUTDF6OFR2?=
 =?utf-8?B?U3pEcDNXbVlIL1BDMTR0Zmsza0Zxak1kNjMwcUp4dXBjRCswU0dGK2xWMVRU?=
 =?utf-8?B?Qk1iM1BBUkpucXZNZzlQYXE4SkFkazBiZnFPYXk2SE4wYnJHaFNsVUF4dXRL?=
 =?utf-8?B?WEhnbm91WmdUemZkTzB4N0thWjlQbnBSQmszL1MwZ1hlTFNkNWVqaW1nOFJ3?=
 =?utf-8?B?MVFLcVkrWlNWRGYxTWtiRS9QekJLeER4eDZJRU5vVW1wcHduTm1MQ3l0bE9v?=
 =?utf-8?B?NFBxSFlZRlgvM0ZTNDlGZEpldUppaHV0TFB3WngrNldLWThoMGZiTGRyT29l?=
 =?utf-8?B?elZrWExPdEtUZUQydXNqNEdvQWF4WXdVRmV1Y1lJNVIvZzhvVEtEZHdrZStu?=
 =?utf-8?B?d3QrbkhOQkxmblg4Q2VmRUUrVmh3WWhqbmZNRTIyUVk2elJOaDlpdDVYdHQy?=
 =?utf-8?B?TWJweWVlelNWdGI0dlRMOHQxaytSdkJjR1ZrMXlJT3NpT0JsUG0wSnZMc3Q1?=
 =?utf-8?B?anlFbkZzZkQ5VmplZ2VoQW1rQXhMc1YyZ09JajVTalhsUmttcFFpYmFrSGlT?=
 =?utf-8?B?bDNrUnBMLzdjU25xYXFEcyttaWl4R2RnUEF0eWIvUmMza1E0K1JYYnF3ajBX?=
 =?utf-8?B?K0g5VXRQSllySWFTV2xOUitaMTJxTE9NODJtOVNsUU82OG5zVGVCTjhNZFFY?=
 =?utf-8?B?VzRYaGlsMVVSOHlPeUM2dXg2Nk9DR0Z1Mit2Zm1hOG1YMS96WUk3YVhqNCtH?=
 =?utf-8?B?YVVyTWU2TVpMV3dhampmUTIwcEZ3aWVTQXg0OTFJaEhBVWo1aHRzRVQyTVRs?=
 =?utf-8?B?eGFKd3M3V2dIekVPbzlnYWd2RHJNQzFIRW5VbWdHZVk5T1pKMTVRTUhjSjFD?=
 =?utf-8?B?U0NDdmc1UTgrc2Jxa3BpVHFGNDloKzNwRTZxckpmbUxCUlZBTjI5T3hSYTFZ?=
 =?utf-8?B?blRmQ1dpaXBmeWgwNUgyQnVUUmUzN3FCcGwvdGMzbVRiajFCRHJkUDlUOHlM?=
 =?utf-8?B?UlprR0hzaXNUSVJSTUhDNHUxYUk4aXhoM1hZbmprL0doTjJiU2ZiNDBqVis5?=
 =?utf-8?B?TWlGUXRZMUREZis1R01COTFTK213aVB0ekhrWEdvSjFTenM3MkcyMEl2ZWxw?=
 =?utf-8?B?V0tiY3lrZUlkc1hNM3Q0MW5HS0NFa2xWSXBTWS83YzVoRVVxZ0tEVk5neUVG?=
 =?utf-8?B?bWNSWDRxaDlCbWlYb3R3aG5xUXQrVjdOU2JsUzRMcFNQVS9XQW9aUjJpdG5D?=
 =?utf-8?B?WWpqSUhjNXVPN0NUbFRRZWl1dVNzY1FuYU5XYndrbnpGMUJBTDBUcUE0Snk5?=
 =?utf-8?B?ZTRXQ3pIK3NPT0JseGdjWnBUNVJpNjREeEdNRWxzMXptU2FxblRUd2tUeFZw?=
 =?utf-8?B?QmdBcXIwV0JRUll6bU4xZkVZemNXZGFPaFFDZEN5a0NUV3ZsOGczdVRjb0Vk?=
 =?utf-8?B?VlpSOWRtTmpjU3A2ZGd5c0VUdEoyVGVXSFJINzRzNUtLL2VkVVdMUXh3dkti?=
 =?utf-8?B?SzBUTThnVHRLYkVaWjB2R2hyUlNTeUIyem5tNGNCaytYTm9LN3FUUWEzT1JH?=
 =?utf-8?B?eisxTmxGSkVYUDZIUGdmMnNuc3ZKamNUTU9RMStXeHNQZUNIaWpsbERkTkhR?=
 =?utf-8?B?SzRMNVFwSFhIRDEwWnlpT3ZpMmRialJzYmxBcXZzV1hybEZqSTNyRThINjFU?=
 =?utf-8?B?TGp1dERYWXdHZ0E2WUxkOExrR2FRdGpBOGFFUEUyd2tleFNwblZwV0ZUMmNP?=
 =?utf-8?B?c2c0U0taVmF4ZnhEY2pZdnhKMVJmZVVDZkRKM0V1Z0ozQWtHUTZic3h1NVgr?=
 =?utf-8?B?bW9adUJCZ29seW1qYVRNMmgzcGZFanBmYWp1N2c3Tys0RVNURzRBd2t4S2FD?=
 =?utf-8?B?S01ld0RndkNCTFJvK24xdlRTUTRQVGJnc2g0NTVnMWVNK0lQNnNTWEZyU2pH?=
 =?utf-8?B?YUo0RkpBRDVZdjNiMm9ZVnlnZVE3ZGhhTENrRVZQaHpiVjhDdFVnWlVsUUMy?=
 =?utf-8?B?VGpFUGtZUGxDQXBCWDBQQjdZaEtzWnBMdGhlV3hSMndZM1RVYjZZTlJuT2ZB?=
 =?utf-8?B?SUFFVDVNbk9yaHo5R3I5Q29EK0dDMWxMb2g1M3dBdnZjTTBUMXFRd2lkTkY2?=
 =?utf-8?B?dVhXYldNOXF3aXl6b1VRMjRNdlp5QklBRnh1d2ZoaHkxcnF0TnJjOXVZb2N2?=
 =?utf-8?B?andjTVZlcDAvS1J1dDZEeTdURGxEOHEydDV0S3h2WnJlcXAwWW5ldjl2VkRP?=
 =?utf-8?B?NndqWE4zWjRwZTZLNFErQTV0MEVIUjUrSW1mcUpHUjBhRUJZVnRwd3BlbldR?=
 =?utf-8?B?VmZEWUh5bHBaUHRUSCtBdWxBZXR0T081M29acjJjWFE3a3RyZWJnZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YdBZooSaD13PAdz24vzT/E4dQrQHcVQoTy4herUPBVOwfQi7Q/DMIormmm05t7wy5/MfPXNhNH7DCc3hiJekzVEH+6fnI3jLu0ldkxVVsgecbVLb+WvoI6QXNtbPI9g2j9hhxa2OoDG0UOasoZAX38SSbP2GMOuXksg1DV5ELSdR8S7BjOc11c+fKjpVVLR3oAQR47bYkIkRrTKaw7EncPu4YNbCrZgim0Eq/UV71RGxuUHdt0pWhdGwFp8yZmr5YxvqKieC56K1TDyzZ3NlR+ACzOZWmVMnYWRf4nIuTCEIlSBCk1P4PkNn1uEKqMgyxeuVgxWAvjWajSpRfWur1ZwJylNMQh1r4O3PccaoxW3encl958WVe33MfJIv4A3mb8ETpdduX9pt+fRbhzm+S6WVMU5nTGrsfhF5MiKvKoGka5lDQr03qkAVT2NsiTKq8I7yz0uBHcxNzi25e58cz+Kx3FQdmuzp+NFdMgaW1t+dwZv2BRnHBrmX/Ld+fMtuYTww5Q6y29fEQ6fVNAmYEQoqKVUbw7oj2hD81eHFM/52VAgY2RLjR3uPEbtVrxq4+FZC35KswPUu/LB6yEd+gNjy0CEk9PHyjQxYPTKT86k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9867bf-aa96-4211-971a-08de63a58e96
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 04:26:24.8400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hT9qt82GZRGsysyqq+UlLQVWSJ6ypFeGBvBr9ZyM89CsyCR+leqKpGd+LHbMMWB70l2NiwX+GnLlv/FGfuA1DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040028
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=6982ca74 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=HnY_bhCACcIMoCrf9bIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: wXRk_coI7Xqcr6zHvNqHIugvJgdc4op4
X-Proofpoint-GUID: wXRk_coI7Xqcr6zHvNqHIugvJgdc4op4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyOSBTYWx0ZWRfXzKyXRY1ivPNo
 AfIY1eTmUZRyXPfOG4M6AGvB43R7ujTz/9FcFA3TpFzQJzYRIH+gIDRHUYlltwyvdAEor27tBou
 hrPf5M0OKSHywq/XKbxlVSvTpmUUjsUFvBeWymdjN763AX3Tvv1bJwkoq8n4YYAamU4Qfp2+U/y
 ZjFPe3LnncGtuC5hFav29S6+CPvWzHgKOUXVIVN5sArXbkzqypsasutjlH+fAB9VV1FG1XavfWA
 g7qg9NKki2Jm4D8w/nYSOoDw+58MzXe/FVMPyhgLj25KtHfdrNU3w0qAXRkO4uzdJx/Pig57YdP
 VNP/fOeCpWLOVzU24n50gYZIKBrKbYGdp/ZczQK47Xh1bFBq+w7kN6i1/WW4n2ic0Mk+BORXV7t
 GEXHQIfOxR8G2Q/H7uSPvnlUyCOoUKTMBlLdXe+qayZhn8rxycIqwwhwYKRFP79UU76AsVmaYiW
 jBxYOtmYyacdT8f9xYYZRA8T4L4Q4OeQ+ty9Qk48=
X-Rspamd-Server: rspam12
X-Stat-Signature: b37i6jykn8wykwnaa447pprhjsp4yxxo
X-Rspamd-Queue-Id: E7C7AC0005
X-Rspam-User: 
X-HE-Tag: 1770179192-775464
X-HE-Meta: U2FsdGVkX1/2TDjldFxN09NfNAh/sNVy6ekXJbgm7PD4nZNGQFmw0vzXJRXcVIC4JcLGkA9Nhe7eOdoklMA4F4YvOPGTDdpLHJhHERyTDZ7k0ZHXUPFytsLQDAZEPFjIhuZpqKVFPRw33PoM6r0iX8SyIfmOFindjV63Wusnzwsm6dj3yhUAyaAowVl0Fw2QYeAp/g7vpPHHZT3dNwYp3QSiCUTNyJMkYUcH2z8VsulvI5vno8TYfOGI72ozEJFWC6pCrusxlBYRnpy8WRjX4YZX5M1p5SKy/sAg2D1htEZg0rgwGBjLOac1fABwoWR12V2DKBY56VDBmtRpEIxPP/T/J+WlUatnEJfRgOxP0cVhxOH22J/Jtf6tQaFrXfQD6PAmr879rDj7knU7r/z1r0F3MNzqpAkaX1mCL5MtPjTZvhQEF7sQRcLo60dtc0g3TwjARSXc3IVucv9q/tokSoYlKMOhokoptd+iZxtBCuxmmELhYTPzRRv6y9Zc/SqJTruaFb30x2ZzxADGSzYjcnBei4PBhjWSW8gHx80pLQnjhCWWy+TjaDoBEwWdC2CQjl/GIrKpxBfJNY3cRdACbso/CZjX99yU0vdsksf6wc6TqqrWaFx4szInlfk+8sdm48FpuAyWV4s9ochsh70Lr0mmHBQJWX69ir+y2Z1EKzh5g2aVjCkwDrv0MKM3yUqT8IoPQpozbUS6VGgJataL3HspDmJO0LCBJBJ08HRtiDGQoEwJ98k77TwxSMiqHBGBjCvR1cbl4je5w+dIVNNaluvsl8vCYwST5sSVczsvtC2UI38dX0f7LQtzZCitR+c43MMhwynzk1ytbEAxPPL3394V2Qi1XDgZsk2Vv2XmWQ0AINCayXP1qb3U3lTO3nBzXy7LO8r8R/1zUQH7FjkSu1zqsFZwRPRNN3HOe3T8SYQUn6zhIeGjsxhHcjn5y4yq7uhXeDK49V3f5EXPk+K
 RZ7F5iDt
 d6P9E1VswLpYvx5j0Tt0Z0KHR1NLG6USoiM9T4lpqxRVG1piEwwWVgi0LM4b3f9rZSNVxu88ERV2fMxfP2vOyu7mkFB+7vH6pdtVuO/tpNWd/NKK6B0zSJWwz6EYprQZ1M5V5qIDU+UkRSPQT9v6TwbMNxzCRAaezZM5TqCPU0oQGCoXW4VCN1fVVjpkTjoENKhdijXensDCdaQeCUFG3sDB6koYmR5f5bWaXpFtVLFbp55ZAf5Tmfkxn1sFR0RCvYdjbyZXSCPQ/BrMJOxZuTarU21cMnCtJZKogZZ6h1Tpd8KUdFvHd6EY9MNe2mwg6V53GUr69oZrfj5szTBL3KYE/B07F8B0mTYCI//lvOesTq5hsHVwesdKWwQJbbKH3LxgJ8tndQCsfVHHTNBmHlMtE29aXdqKKZp4qWS3awZkiP/WkbZHJGSi5NLBT/5kBX83fIknRE1Bb3uA+M9J+xIIUxmRm+XzhWMWw8tVso8RlUUCQc1GvEWdbM4vKd/xZmDiNGK7vk1WPA1gM8hw2tODYWCsJHIgJjik7cjyi/Q/QPch0/E7LSkgJZzjcUXrcesMdcNGDhR2gPB6umpmEf7xqwYQr/H7avuZKv1+phDAdri//dX89VpXMN3IRx9yIlzWp8rBmdHsoxnksz6nIopn9Mis5IAq/qrDV1d18R7TO+azghqRpI2AWjhcje0wMZwjEjyHP6NtRrKJr0LMQKpkQl1z1WkECYPkq6TnveLwQeVQczHhz1bfkal3/TXj7MpFJT3T9de+U34ZXZn6BA/UmbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/2/2026 3:36 PM, Jiaqi Yan wrote:
> When remove_inode_hugepages is introduced in
> commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
> it used to return a boolean to indicate if it bailed out due to race with
> page faults. However, since the race is already solved by [1],
> remove_inode_hugepages() doesn't have any path to return false anymore.
> 
> Simplify remove_inode_hugepages() return type to void, remove the
> unnecessary ret variable, and adjust the call site in
> remove_inode_hugepages(). No functional change in this commit.
> 
> [1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>   fs/hugetlbfs/inode.c | 18 +++++++-----------
>   1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 3b4c152c5c73a..83d71cea7e384 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -515,13 +515,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>    * Called with hugetlb fault mutex held.
>    * Returns true if page was actually removed, false otherwise.
>    */
> -static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
> -					struct address_space *mapping,
> -					struct folio *folio, pgoff_t index,
> -					bool truncate_op)
> +static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
> +				      struct address_space *mapping,
> +				      struct folio *folio, pgoff_t index,
> +				      bool truncate_op)
>   {
> -	bool ret = false;
> -
>   	/*
>   	 * If folio is mapped, it was faulted in after being
>   	 * unmapped in caller or hugetlb_vmdelete_list() skips
> @@ -543,7 +541,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
>   	 */
>   	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
>   	hugetlb_delete_from_page_cache(folio);
> -	ret = true;
>   	if (!truncate_op) {
>   		if (unlikely(hugetlb_unreserve_pages(inode, index,
>   							index + 1, 1)))
> @@ -551,7 +548,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
>   	}
>   
>   	folio_unlock(folio);
> -	return ret;
>   }
>   
>   /*
> @@ -599,9 +595,9 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>   			/*
>   			 * Remove folio that was part of folio_batch.
>   			 */
> -			if (remove_inode_single_folio(h, inode, mapping, folio,
> -							index, truncate_op))
> -				freed++;
> +			remove_inode_single_folio(h, inode, mapping, folio,
> +						  index, truncate_op);
> +			freed++;
>   
>   			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>   		}


Looks good, thanks for the clean up.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane



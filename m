Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650AAF34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513EE6B0088; Mon, 13 Apr 2026 12:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4D16B008A; Mon, 13 Apr 2026 12:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3654D6B0092; Mon, 13 Apr 2026 12:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6636B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:40:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EBE316025D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:40:16 +0000 (UTC)
X-FDA: 84654095232.09.F942544
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id C943E40005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:40:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MXgj/jnc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="a/+q6fFV";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776098412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dejmZlqC5XGb2LyzG1bSI23tfqV+P40gn2WRx8qB680=;
	b=Xs83/6xIomt0rn9BTGk7YDYipeDxOjarwSrgd/Qgul6auNnJGIkvAQwbz5IAL8yKC7fN9M
	l5oPEywzaDNhjCGEZRmH0TZQrEXsrKMkZ+A6X8BBL1SLwMiuqaKiMVcM5Q3ynwOBgckuq4
	6pGbrqXxrV23jdu04PCuqIPuE/ek+gE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776098412; a=rsa-sha256;
	cv=pass;
	b=pR4aSeWXBoAqTkHTSqZAzhWOSwqYh3mCo91KuQvBL8HRjVwSwDz2Rj8czrjf6tul0WjL2J
	eMKotZ++qv5+DL7FQ3pErLBU1OM7PMGnZFmvyXcRBeGtnwpwZvnT9GZo1ER66w/3tzm6UR
	8bWhMKO/tNSkrD52+BOocOqdWG62kS8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MXgj/jnc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="a/+q6fFV";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DDBhCe2304995;
	Mon, 13 Apr 2026 16:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dejmZlqC5XGb2LyzG1bSI23tfqV+P40gn2WRx8qB680=; b=
	MXgj/jncCzE6VQw0H0LiqojgoJhROk5bSTkvR0Kroc6hHFoVlpOtt02cXEATOWFO
	jLoueab6q8sAvZkbhgbvuR2xc02WXpukh3Q0oykuk2wR/8PQliOk932tOvj9fK6U
	qOHWvaWxBU3HB7mJ9Ms9UboGxqcFN3o/O/ul7H6GuTuO21nxwDm2qpLyyp0bsQMN
	F2gcL3vSWNRZPKdJ0qJFmia25NDwtJoyiDmmCL0vSYH1eicjS6xg8trR37970TlX
	UqwPaJrmMIi0pnKhD9P6/c1BScrlgJaRcJ+gV4NpcrqxkF1SkyNz6f0+fiXA4lY6
	aD5HVAYdbSOPcg4Ha2YHsg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dfebdkgrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 16:40:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63DGdPWe014483;
	Mon, 13 Apr 2026 16:40:06 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011037.outbound.protection.outlook.com [40.93.194.37])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dgbr8vtfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 16:40:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XptYkeB4d1DOD+l1SUHapsULPGS1sq7qDsVUbtXqgxD7qL/OSA+ELS4SnjCtb93li/qAcwny9V3m5QyR2Ti9/6+d5hfHDdoVH+diJ4msOURgzDJnsRNO3Z7E4xxACeTNlsnS/lyotWIzDmvdraYbDrO45N1hAjTe+ELhrNLHVinNn63diz4mukXqqUsGvDjgQUKpUyAhyPLIupvltKUKDCmQYu2AgDw6jNC+Jk6NZdRa+3zXGkm2TFyTj04S+ntzm/KA/wFdb2iRj8rv2kquUifWi9MfNvubYDdSa0fPHKrXd6szzTpoXkNzcd9EkxpTD8amDsCszUn68Cpv0XgDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dejmZlqC5XGb2LyzG1bSI23tfqV+P40gn2WRx8qB680=;
 b=ZBxHk0enyvSwCMPK0hbwbVxA057jB1iCLig4ThYvwokf8GPHlpiFX70g1UZMZR2HpkW1f1l88QuEbZ1JmmlPIZQftRFXgiv4DrT9yUhIwCqVqSXqd8MTM7R8wLUOEfZXV7hueSivWNRusnwnB6bZ/P8sBoVYO4QkyE7S0MqmhgRhJulYiI9BbKqxPwTR2k3rS5W42s0VJYfyBZrgvDPa3pAc3CTMJs4GX3T8VsPhqGKRktQN7PgJo7jm94d9SFcxMz6cBy1nUSlFp8ncJs/tZkNSTo8SaVOxdI/2FaIsOxQ4xIFDa6ap0qIVh9XR+55aUBwlqkcVKMo0ABJQ96kBgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dejmZlqC5XGb2LyzG1bSI23tfqV+P40gn2WRx8qB680=;
 b=a/+q6fFVof31HSbA3hj6nbkg/K4k604FNk99orgA4gf+Gv3+zyf4FugU9rWDYTj615fg6rEGKg9Fr4bwVFI47h2jugNoqSyQYVGTj+REV6FDPdZoCPxYVt5JxVeZipdlcUBT8GL4RTSzOgrqF92kphTAmaASCodYABxTwKw9K/Y=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CY8PR10MB6538.namprd10.prod.outlook.com (2603:10b6:930:5a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.48; Mon, 13 Apr 2026 16:40:00 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 16:40:00 +0000
Message-ID: <dbee2d38-709a-41d6-baa6-7fe82bbe5fb4@oracle.com>
Date: Mon, 13 Apr 2026 09:39:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        vbabka@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com> <adpXTeGPIKcdyekX@kernel.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <adpXTeGPIKcdyekX@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::29) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CY8PR10MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f20db57-c595-41fb-1ccf-08de997b4de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kFkCAdpN1U3ofU3SaIJ4ifLzZ+93o4AZfvK1fhdRj7sXAIrdkkKtu9gOi5eK7nn71HsV3lWHtntMV6QUexYtLH+HO8vVSvvSKBpqIcKTPDs3dZCkJixUXMS2iAs1ONvCu2a6K86QSsRnR1IY+27uV/9MLGA4duEL5nq79wsOeaUA/wzv0HsTyJ6zgj3Raoz4cwkbTfEtO/h3SA4Lgo9bTcfH7XVsefst7yg8v15vBBVCIqQfkxxdBFaMebhUgvkQ1RY0ZIKlVPuWXpiCJeBUy2KDRxPRamw9knp6OQ290zLcLctCZF3JPGC5w3GrA50pEWXBzT5ieSQDLXdDDxD4lJqORmLUDwRCcqpNkgB9Z3faCdUpPwKyIffe1FGpSWK9BkeVeiguV6/92rN3T63vxF+HzsveR4HXdy0940CYtWuD3iDx0I1I9RqO4QeScqgcq/96ppHjzT5cxKsXTJID0OqLU3VrjGK7YvnNM2hwsTsG77QXLW0z9OsMUom7uK5CtxcBiOD1rp8I4BFq9UIqAgoWhMHcSKck6vR1bLhKk4+4sntc7XnbDFkcSkxJR/nbtxCrNIueiiTIEd9nj+/uS13bSCZ1tB0H/+sT/gN5VB8pkyVoaupMPkjN+8wx+OFCGh5+ApjjThJbliDQt8uB3nuBxhzCSe0BTM2ivgstNV/oyAX8Kwxqtr7ucWiVBMzx6nIBWnP7sagzkhU16aYeIofTIkObuaTzi4lx46H8io0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1h4aTRZL01rWklzcDdyYXorajV4V1pBcDdBbUxxQ0w5dkNHdEFOd1pLSlpQ?=
 =?utf-8?B?NGdSajlmazdPWHYxT0RRTFNObFpiZ201MnRUcG9EV0VzWkNuSUxsSHA5ZE1M?=
 =?utf-8?B?b3YyR1VKTzV2NG5uWlhKSXZWSENhYk1nKzJCT3VvVTBrcys4TTRGa1RkMG4x?=
 =?utf-8?B?ZU5YemZlaGk4N1Y0eW9YcHBhUXlqQWlncnM4LzQ2amUrcER1QVljT1ZCYmhP?=
 =?utf-8?B?RHpnN3JyMWFPQ0F3ZFBNZ2xqUE5iODNnYXh5aHFvcXU3eCt3L0FxQlhhYWN2?=
 =?utf-8?B?WXg3TU1laW9STEZFTldlcGNTRlBhcFl5K1BPeENmclJub1luZ1djb3hTTWw1?=
 =?utf-8?B?RCtFc1RVMFN6Vk9ObGFvU1NvSjJFSnRDdjc2eTdLL2tBN0x3SWQ1bU44WHJi?=
 =?utf-8?B?dFZwNStZZ0tiWm41QjRsMy85ZGVlRzhVQ2NERTBKUkVuUm5EbXVickV1NzNi?=
 =?utf-8?B?ZWRJa2lodWI4YjNyei94cGNZQzVTUGRQbHhaZmpUZkUveFozK3laYlpuRnhI?=
 =?utf-8?B?TnhMVWdrazFsckNCL2w1VDNPbG1LQW03QlV2U0o3K3pick05QXlQM1BmOUpI?=
 =?utf-8?B?azg3bTNvdlJwVEswNDRtd09CbTR6R1JqWE9TWjdDWEJvdHJFS0t5c3VvaDBr?=
 =?utf-8?B?TW1NWm5id1JFV1lzT1ljc3RoU3JpUHB5eEZibVJpc1hjb0x5UlpsRExWazBH?=
 =?utf-8?B?MnlRdnJ5eEFkRjFWMEhNWWtpSWxNS2lNaEdPYlIvOVVqVlozeUNpa0M3cDBT?=
 =?utf-8?B?VC9ET091dTdpTmF4aFEwdGRYQ0NRZENYaW92WnVqSXdUeFJWMkdZQjNyZjVG?=
 =?utf-8?B?VG5kYnV5WGwwR1J3UFpoK1dvRGtpc1poSno2eFpTNEN0K2RNbWkzYWdEMWpw?=
 =?utf-8?B?TGlOZS96S2o5Mzlzdnl4SDBTOExIUVJSemo2cmlicjc0aXpqMDNSSHBIa0lY?=
 =?utf-8?B?aktjeUs0WCtOU2hwUk9QK2tVV3NjTEcwZGlGZzlqNDZLdWcrWGt0M1l4RmVH?=
 =?utf-8?B?MExxS0VkQnFsQW1oSjhVdkY5WHZEN3BHVFo3LzdwVlRvYmlZVlVXYUdZUjJL?=
 =?utf-8?B?NnVGcEpFcTNEUHh1TkFMcWVoUTZNbXd5ajhSWVJhTGx2L0loaVpvdCsrZ3kv?=
 =?utf-8?B?NnN1S3JRTHVwODZwMDZaeldSblYvT3dwNWFWK2p0SjcrZXhmZzVHNGlRb3ds?=
 =?utf-8?B?RjFDa0pET1QzTnFWWWhZTXNrQlhGMExndHNRSEJwNXZLSWNtRThLNk0wM2xJ?=
 =?utf-8?B?V0oxQklVdzJteFd1ZDczQnpudkQ0TlVHbzRQN1AxbDdYaWgzMlFHTEZaVnVZ?=
 =?utf-8?B?dEpxNzIrczRjaUxHNFgyNHVTS3AwWlN5MVlqRmhpV0p0M01FSzhSTlRnQWNN?=
 =?utf-8?B?dkRHWUlqbUVJaEJpcm4wOG9tWUVGOXZoa0RGcE12L01lcnEreVRudU9JVER2?=
 =?utf-8?B?RmgyMmZoREZTQll5ZGgrNFlTWmxRaStTTE9IL3hRNnVMam9pcHREVjNzNTFo?=
 =?utf-8?B?aXFZUHVKamdUVTFtb0VlV1JpOFpNZkRWOFN5VmNGd0E5Q0xJWjhwSEZEeHV3?=
 =?utf-8?B?ZG95aklqNlZSUk42QWtRRHpMZmZnRFBSUDgyY2JBQzZrQkxkajI0V2lOaTdx?=
 =?utf-8?B?MFEyQ0VVRGlTZDhwRmNDVzEycTFyS2RvRHJ2TVFWUVRvRldGbXcwTVJRaHFs?=
 =?utf-8?B?SldLUm9zN2Z3OFlsamhzdzZjaldLVGc3U3AwUmkyOTZuM1N1U1ZnTTk4aDVw?=
 =?utf-8?B?bTVmZk1YWC9pRFo3WnJuNC9pVENaVk1rRDFPRUkzekFpaFVFYmVnQUtsZTBn?=
 =?utf-8?B?anhVR3NHeFNFbjRRdk80bEwrdWhWZnhGdWdVQkYwb1hhNkJTclhDNndmOVBV?=
 =?utf-8?B?ZTBCeUpPT1NzWlRITkJxR1FRREh0dFp2dkMySlRGdUlXSnRBRUJXVjk4Rk5S?=
 =?utf-8?B?dHdpTkUzeHBWeUtmUHU5WDJUTmJjN2UzNURPcGdIcU8rbnRGMVk3OEMrZXlP?=
 =?utf-8?B?YU9XTlUzb0lNWmd2bnVuUjNEV1MybjN6UDRDcmN2WUlqaVgvSWNJV1FrUDl4?=
 =?utf-8?B?RVB5TGpzTVhlR0tsNkpmcWZHMWh5enV3NVNLRGJQaTJWMlo2WTFHZzNNeDVU?=
 =?utf-8?B?dVU3OVAzVnpNWkZHU1B0bHlodWpya0RvTjlhTFBlcWlKTkozc1JqVzJZaHFD?=
 =?utf-8?B?ZDQwb21rQThPQUNJczFXNVZxZytXUVlVZmlSK0lZT3I2cGxaSXI2MDk3bGZQ?=
 =?utf-8?B?SnREM1o0MUhuNlVtL281SmdlUEoyY2h3VDNYMGRraUswRXN5QkRHalJ1T0J4?=
 =?utf-8?B?elBEOHNHK25EQXoxRWxMWWF2cERIaWtyY1dHbW5aTWh6QktOZXFXQT09?=
X-Exchange-RoutingPolicyChecked:
	ILyrK4ksweZyCQl7BWkhgSqZMRj2WnNWCtB6SZeSvXxUpidluO+egkBqEsBMpx8ATEMAFzSc9FWGsvt8X7YmFvMPKIBLhxH9AegK4idaNaQsQsUKT7XgP0ymqIYQ4LACunbxNFxmCFRU28j6DrgNa+d+KNBOXeuiXA0aFPEzeKO6emNi1wAWbHcWc6+LGi08Ke1NYgN18cG6Iu+OhBmyo7X+Ftfn6npHdDiw6IfhReNlRARk+I8tZ0TJy5tSakxEBb/pXzutqiTHjALRAaTa7TSlQHb9a5GLovAHNy58rJJ6dM62tdLaXXvFnlKsO+yP6PFijVvd5uo+VYfz+8QyOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qgWguYaMf0NL/C8sFmsTZoJDTZ0gtSDPLpS7xmcqp4hqsiHFg9TEHPQQL0pBA8f58Ivib42EsXOJY9drbelSAaFbNjINPdGBikpr23WCGglDQEPSER9GSPAY7brc14jwPh3FRGAOY5hfQxcUOs7QqKVHzyHCrTZVVAnTbe6yAHhlIRDJvh2BUIlzgM2nw3idXol2Iyegp0DvQu4l6oWh4qS16peaacb3SXs6rWcklEO7uA5DaLX5iCiOioDrpd1CE+7suNTI0ImpndtPWYIPYRAriq057iDp6tNdUntJvPqtwLSDmZf8frMaGsNPnY2ZCNmT2sXLVairJ+AlBFpSiHQCfYuct6F2OiYHWC21QUbt1JpJBlbyJHffxKKbnCa4gjE0rTzAO2qeuaGUVcccEN+huOfFEZcX9lo/iPk+HhMvjJQOCAuPePk89+CpzK77AgSOQXY82Rhb91QAmnU2vusinDvZcH96SaXhBySxYiGN6byFycncAtEnPoCn1qDrea9cte87s97qJ6tPwPHvQZdMDOGH1fT6EzCVYW78jLGP2v9JxNySEvrvFN2tat3MqTQdRny7X8Yj/YHUQIeza5oSstBPOKkW8S6soWXETVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f20db57-c595-41fb-1ccf-08de997b4de6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 16:40:00.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4F/AYzCp9ZSKr+rChiAQDguxMCqUf9ktiE5Y9uRoi5M2ffYCl7b5dANHM/hI6MU36K/80GU/ZwRnuER0wBnn6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6538
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604010000 definitions=main-2604130164
X-Authority-Analysis: v=2.4 cv=aIjAb79m c=1 sm=1 tr=0 ts=69dd1c67 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=py-mNpOukuJqCzMsB4EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDE2NCBTYWx0ZWRfX3tJDw7CyUvM4
 4of9eLMIhlouU8Vs7jT4JxM4KCtUFQZJ9MG8fE2jS4W8CnB85G6LaYzmIFHaYWWR20cgp9gUNhW
 /rNfZG3da+dZIOifS5WIznHetB7VNeOz2oMRsY4chKi2NPyYfY5EIvGjt3zpODiUsNdLVWcs6oa
 0+qwexDqw6EKKbcHDFH0jXT3br5LyRWovxiS4bYn7qX72Kiag34u13T4Nl/LOvMmjSb9hHUXELF
 Sssx2U5CJcGXjdUpG+Rw+CzuTPVs6FdmkOtFtg+s7+d3KtQQgXRPg6m8vhH8wJDan+1VJtt1AAe
 Y1cO2Pulu5313M/1ko//yE0MoSP00V71cSi4Sj8rGD9XczEsEov8HXGy8VQE9cHNdPpVhVYIJE3
 I3LsPKk4767sPhA3UUCvL61yc+0V0aEpa5WNptH0iXqothmfALeeGLM5xBVe367mKpg60hQU+OU
 vB7X5gXaMuW/CAaEgpA==
X-Proofpoint-ORIG-GUID: xkb7grGaw7AqCQbQq8vUWS9H7yJ_Dfbo
X-Proofpoint-GUID: xkb7grGaw7AqCQbQq8vUWS9H7yJ_Dfbo
X-Rspamd-Queue-Id: C943E40005
X-Stat-Signature: qxgh941gjwppt15x3zwotsqunzh53aur
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776098412-678734
X-HE-Meta: U2FsdGVkX18IQ++TXZQqkhHrlb/tPiK6qh78LT+UdzjyBg8C8XJMM3zTG7VviX7qlgWVLeQ+B3g4tt9zSXw1abFO5e4PfuLYx7m+5g46yLCA2gt9L/6Wp2IoimnM+zqrLPyQFwavbL/y7fP7uTgR+EkFPdLAGstd7U6NpsXkw2GJ4DTLJvU6u9IfynLgPJOY986v//a20lnpGaRhn5Qprdv5pwris1+wcdKFaliWIDh+3KNl+BjV+jzxLTT5hetBjNawl2tAn20rRp5B7PeIUMxJ21lKePWbvfYESw01fvRmDJi5iWr6r+E3e1mtcMQsmR09gHgqWAqSZEWFhI9nZ07nvWw3gcsaU7sW9nhs+ScCuW7hU/gUB6ngb20Lcq7gu13NxRQBcyseiwN1JJPdMx8zsAbGKnSjUjwuOVWYc9lQ8f8jhINRRFPGeqJI6xuIF1PImZ7CIfp0yBmA10/+k1Sz/WTrpGPRm4orYxBB4+MbNozsUXDBQw5ApfOqu+ynMuTI70Spzzb0o6IeLdpo5662pb1Q+F0MTrejMaqnbo9YgHb9ykVM+OT5huKayjck4IKM3EaoDIw8pSy8uzp12PrQRqRixe+UARVJywzFZbxrplb7T3ual48GImJcEOxNNE9DFPBflWt26iGvmCFa6ClRAHKqQp0FAzE5sXsr1iuq2GA9GUiLCjtNaRAp/BjojLVvX4aiOv+lomj00HJ8prE/NrHbca/VW2Q+Guwokhy3PA/L8+rd1tkKe76Qdc3vFeFZDzyIeU3ajihHej8fUdyeA1uToQVx0H/NabD8mt/M+tqO+ISNZf5y3Rte6Cy80lw7Ja1Xgr1s+jK1zRgnQwaCQ0QKtFgcdlW7MiI3ZqukZc8ZFHE8M7i74RLFJTwYJwSqMnpjQUJXbrL/EpKq3J9iCtZB18l/wmJQPxBPJC7pbF7Aejb00e7TdjSISXInX0/s4uS7Eo1Do2jT+13
 VRrDjg6s
 nOt5xtnxlkRtq6r/yKunKRQtP6U/ZFgENUYjDyxq/u0Ocr2pw9mbO4bmz/wP1As2C5/X2XpP2Ert1y0VvtoAbU1b9996h9gVJEh1kUnVwCkvenqGDU/9nXDODzbm5jElQvL4CYSrckeT1F8IFYrGeyPa+lD5kevKKiTj6bnQh+0UolUA0+hfSCISw3zyn840idZrToYNenuNCcDW4rm23F9bI46StIzTuP7XjTgXsrMb40euDmwqCfaw4J3mMGtQzDvh4sKkdkD1Svh/aHgbveTzWHeaEysZvpvtBwwmvJDomEGOFOHmgbOWIH8d4YGMgcZtiGzIt8vRfxAFMiIxvzOVNvNCX/wwlSi10nWLVOeES6+mEOsPr4HOvZY8MXBXbZ9iOKFBM7NhLdq52ZQKfnbNKPtTQkLW/ETBHBuHrQ4gb1+nki4errfugnqgFdt9RWFvzFDd1jnPLhb9EGu1h5TgNjyPBaOZMHWTzgWT1BGAU8jprwzEyUWbAjuwp74VdKW5sXDU9kGef9NS2FQZHf4QQGKJcsteMb44kSKoWnO3lXoeljh5p7BOUQ8avKrIvChY9GL0PRh5w8MeASavqE5ZZUsFNRtdl96Ln4iPQA6NkpjXm9efKIpFGWwtjp+qtjCSlQACYFPXAcbU4eaFXAJ52RtX5yF/wywmhBOQk20mDMVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/11/2026 7:14 AM, Mike Rapoport wrote:
> Hi,
> 
> On Thu, Apr 09, 2026 at 05:41:52PM -0600, Jane Chu wrote:
>> This patch removes `filemap_lock_hugetlb_folio()` and open-codes
>> the index conversion at each call site, making it explicit when
>> hugetlb code is translating a hugepage index into the base-page index
>> expected by `filemap_lock_folio()`.  As part of that cleanup,
>> it also uses a base-page index directly in `hugetlbfs_zero_partial_page()`,
>> where the byte offset is already page-granular. Overall, the change
>> makes the indexing model more obvious at the call sites and avoids
>> hiding the huge-index to base-index conversion inside a helper.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   fs/hugetlbfs/inode.c    | 20 ++++++++++----------
>>   include/linux/hugetlb.h | 12 ------------
>>   mm/hugetlb.c            |  4 ++--
>>   3 files changed, 12 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index cd6b22f6e2b1..cf79fb830377 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -242,9 +242,9 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   	struct hstate *h = hstate_file(file);
>>   	struct address_space *mapping = file->f_mapping;
>>   	struct inode *inode = mapping->host;
>> -	unsigned long index = iocb->ki_pos >> huge_page_shift(h);
>> +	unsigned long idx = iocb->ki_pos >> huge_page_shift(h);
> 
> Is it necessary to rename index to idx?
> 
>>   	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
>> -	unsigned long end_index;
>> +	unsigned long end_idx;
>>   	loff_t isize;
>>   	ssize_t retval = 0;
>    
> ...
> 
>> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>>   					loff_t start,
>>   					loff_t end)
>>   {
>> -	pgoff_t idx = start >> huge_page_shift(h);
>> +	pgoff_t index = start >> PAGE_SHIFT;
> 
> And idx to index?
> 
> Maybe let's pick one and rename the other or just leave them be.

As I just replied to Oscar, I found the mixture of idx/index both could 
represent both huge page index as well as base page index creates a bit 
dizzying situation to the reader.  So through out the patches, 'idx' is 
made to carry the notion of huge page index while 'index' carry the 
notion of base page index.

thanks,
-jane

> 
>>   	struct folio *folio;
>>   
> 



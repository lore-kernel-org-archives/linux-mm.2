Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056C3CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 04:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57298E0006; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DC48E0002; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCECA8E0006; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5A078E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4375C4439B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:36:16 +0000 (UTC)
X-FDA: 83944654752.12.51AA9F0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id C821940002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:36:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MxxphAH4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="G0aj0Q/K";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCS6ZiUUKA7wvUuv3fxxXxybiu5hZyKhXxlGMLQoCE4=;
	b=Ex8bKVM4ra2TV4CgOjjhsx4J8jJiaRomlmNFrb1LI4FwugKyUbmRz1eGR0lUyJ/0xMKJdb
	ptK0jkmux6Epzcceh0mJ0su03vhUXoEM6QZD0m2eDkFwdF3WGZmgXFWFz0RwseysQAzHw5
	WJUsrdSKzTzMRg8IhmPybfWrBM5/EhE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759206973; a=rsa-sha256;
	cv=pass;
	b=513t5lguxrHa0brqTpDRO6Pixuyk4jAe40bZP/jfTLO5QC6ezI5dYHV2aPnI/Pt2bQ4sib
	Tt/JJpr3nFQs1FWQn1y6uSwDOk3ZtAlRxbMYGC0wYXlisOGHICGofn1iIoDOMDkCqyuw2a
	nOdrDnDG/XIWqx/YFbXzWzs8LRaO+s8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MxxphAH4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="G0aj0Q/K";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U40JKa018203;
	Tue, 30 Sep 2025 04:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xCS6ZiUUKA7wvUuv3fxxXxybiu5hZyKhXxlGMLQoCE4=; b=
	MxxphAH422zcI3CNEJdzzRLOvvlY1LCbH57krYC6s+qot9OIQJObDuMnvzRyEadA
	+/zuqBTPffeHsIcqOVOCxzJ7aADZvzElSgsjImF3rzGyBtPf7z0mmM1l4nptaACK
	0fSnY26vxwNQk5AZdOZpDr0vA4VIGULi1FaYiZr3/C7smiM+X0h7laTI2ZXVjP0X
	V0e77RcTKE5p9RWT4lc6ZRB1Rn/zZ9/KkqGPERhpVq8jMk0wIcgRrsZobEh/eEOp
	R8osHe9iT1ec2oRTVJMcMMTu1dsVHVIKmY7Tvkg6UWEKDJp8KdRabu3SlAozObvN
	UG3DGyif8Jt6/i+V3gvpZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g7ssg11v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 04:36:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U3b7nG008165;
	Tue, 30 Sep 2025 04:35:59 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c8950d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 04:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/F2A71m4+idfMZNbyCrnQvVVAP69N46IJXaePfe0cEcZksGFT94nu2dTUW2Mbz6eQTeqCkgWlb3gvhTS+Kn9wDhi07lGKp/cZb4/YZoOjnOqEwOpx6nXC7cS7vjmSWxCwyJ5ylrXXdumPlXnszD5jMelSOnkWMLQ6kmlE87cIpRSLZ7vNg9q5YOVtEG65eLkACY/pULNAx7xAQRe2qyPb2smLX3r+kw+M4U1Uw2rdNhaSgUNATEFV+zafK5WAe/Dhmj+7sgh7YBd1AydKMT8G8Ui0QgzopZ3NeizwtBiPEGJcuZbYHeIu1v0rUuK/zxQwKMu7jKhndGTtUnONwwaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCS6ZiUUKA7wvUuv3fxxXxybiu5hZyKhXxlGMLQoCE4=;
 b=ApI+Pd5+vY3EgaP4QG011L2R+ml6HZo8I1PsdOKyA+0qItRl5Oi/6w2R8PjQn2U+yQzfAdRQ/B9/OUep1HLlePuo9N1bYKPsZlXu/qHAq2f+ZFuSdtrYrFF6wQ2a/6NnMzmiiC+5ygoAZBVNBM9IyzmLswwUjohsmpOel1KUZ7VaiwC9YPimWdOEufAwDID3fD0Pm0Cjzgu2QAxY9Zhi8YJR7B+UDZkvEXjurNdK7poVqoKFqZPsMlI0uMc/OmTTTtqi8GZBJXSF5pukjf21nDvH4q5YWLpvMed3v2JWCprJNQta7vujBMkHehhxKTzgMgtqfZ9W/+wDAaqdw14aWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCS6ZiUUKA7wvUuv3fxxXxybiu5hZyKhXxlGMLQoCE4=;
 b=G0aj0Q/KtMa0fWJklAffQkGnzV+OvV+uTmpfXeC4p103je9DfsOzUd21NMS3SfmrfeCvxT2SoAefvC/TYujGb3fgyBMH7aS2Nqv+GqBURJEzbrLGG6uxy3qmsA7F06s9uMAFYSESVf08Kh7R0rALHemhpoJFiyb0eYt3mkm1AJQ=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CY8PR10MB7266.namprd10.prod.outlook.com (2603:10b6:930:7c::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.17; Tue, 30 Sep 2025 04:35:56 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 04:35:56 +0000
Message-ID: <8d39b975-b85f-42f2-8be4-0b7adee09dd6@oracle.com>
Date: Mon, 29 Sep 2025 21:35:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Luis Chamberlain
 <mcgrof@kernel.org>,
        syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nao.horiguchi@gmail.com,
        syzkaller-bugs@googlegroups.com,
        "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Zi Yan <ziy@nvidia.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
 <594350a0-f35d-472b-9261-96ce2715d402@oracle.com>
 <7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com>
 <c61ca94b-5b19-4c69-b2a1-d11a5301c6bb@oracle.com>
 <d15fec58-58ad-fd20-7130-9c480df43d15@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <d15fec58-58ad-fd20-7130-9c480df43d15@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P220CA0175.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::16) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CY8PR10MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dad888c-c1b2-4f1e-9ae9-08ddffdad8ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjlUa1RycjJGRWpNSlJZa2szaVFxNHM0a1dSdkN2bzhsZDA0eTRzNEhsSjVv?=
 =?utf-8?B?Y3JhbEN1L3lnZSt4ZkYwT1FLRUhjaW1EM3owanhLQVp5czV6TlFLSW1vMWZn?=
 =?utf-8?B?a0g1dEJORkZEVFdYYm1tdmphQzJGa2FiaDltSDh2Nlk0NmNQN2Fna2l4UW4r?=
 =?utf-8?B?eXlPYlhhdjU1OFFvTG13QlpWVWRhTHlQVVFWM1dFdThUcS9NVVRsbzV6SnVZ?=
 =?utf-8?B?VVQxY0JrQUJtakppODBlSlEzSnRwVmhsd3hkTzAwUmxSbi92Q2pjUUduL3Ri?=
 =?utf-8?B?d2hxTnh2L0pqQm8xMUh5Y2lpbG1qeXBCZzN4MVNPMGl4cldCeHYwY1FFYlkv?=
 =?utf-8?B?Z2ZCTk1XT2MwekZVcDgyaThwYkkxcWZUVHgzNFpzdXVTR3dmV2lwdk55bUdo?=
 =?utf-8?B?NmVNZ3pSUXREdFVseEhqWjBqRDQvK0pRTXpqdGtzaTVpc21pU0lkNWNkWCtp?=
 =?utf-8?B?ZjlUNVdwdDNNUzR1OUxPc05JZUN1NHZlL1h5Z1h5eVBxN2xaNFg2ZzJWaXhk?=
 =?utf-8?B?bHovU05JUE8vQkVPTk5ZT0JJMDRraDFUd3NwYjZtVi9lbm1tTWtZZUFiUFVM?=
 =?utf-8?B?bkcxU2ZOdzhEdmVQcGVhdXFsLzZqenUzblNCOThnQ2l5bVFNb0c1Y09tYWFK?=
 =?utf-8?B?Y0RBWWtrdVptaVFEK0NGV3FBUW1jYmV2UGIxaEc4eHYzVERZRmt2RGZkSCt5?=
 =?utf-8?B?ekFLdXh5RHM4Q0d2NUpKVnk3OHRSSmJlZXQyZUljenlRRm9CdGlJaDI5YVlF?=
 =?utf-8?B?NXhZWG9JZGdXckJFYkFuUklma0VNUnZ2aGp4OXp2LzFra3VkUnQrekUwZ1R3?=
 =?utf-8?B?OXhlYitoTjF3L1VXbklFNFd1NXpVMDgwOTJhblpkOVVIWEp3eHBvRG5sdDJs?=
 =?utf-8?B?VlVDcThKbzdXbzJOUlpZMktCSXBBRThBM0NFMFgzVTBWYWF6SXdOMHRkYU5j?=
 =?utf-8?B?U0NRbkZHTzNEOFd1YVVKQjdJQU1Lb2lsRGVIdnBmSGVvUXZJMjFwMGRlT1p2?=
 =?utf-8?B?SVdoNkdNcUtoLythV05ZYzkycFJvc2plNGdmc2JKVEI0Z0k5NFRYOWxCZlV6?=
 =?utf-8?B?ZFF5bjFqNHlyMlowc0kwK1hqcHNNRnRTRVdEMW9wRzd3KytUUUlZcGZPSG04?=
 =?utf-8?B?VVpxTG1iUlE3V1B1K0ZIRnBjS0pMbE9HazdyZHNFWWd0Y0FEd0h4QjQ1R1B2?=
 =?utf-8?B?Rjc1Sis0aWRocHk4elcvNHdROUJsK09BV0NLVzlRUXJNLzd2cVVRMXc0ODNV?=
 =?utf-8?B?T0tTUjNVMGtNRmd1aDJmVzVjenBZNFJwZnpuMTI4dTZxWVpEL2psUXhMQk1w?=
 =?utf-8?B?cUtwa01yRFhMWG9EcVdvT3M5dHVITHdMWTl1Z2ZtdmNVd1EyZHVDSlZBZ3Ru?=
 =?utf-8?B?UWFDblpielhXRnpPRDdrdk9vTTJEMUVmMXJPU1RiYzdsRFFsVTNVdVZ3SXla?=
 =?utf-8?B?Z0RzVUpyT0wyQmZxK0d6Mm1HV2Z3Wm5xK0VGVGRSOWZ5YXJPSFVmVUhVd0ww?=
 =?utf-8?B?K0Y5SGthU0ZhYTBZRXAzcU1vbjd5WDlBV3BhMm1VOUFiVkw4Rk05UDlHS2Qx?=
 =?utf-8?B?dFBZTFh6VFJUTmdUUnlYZk1zRm5oM0xnNCtMMlFvZCtaU2ZKeGhadHN1L0No?=
 =?utf-8?B?NFZTZmdNK3l3UmV1YVpmUHNFR2RjandIUk8rT1hsVW84MlczdEkrZXp2dTFD?=
 =?utf-8?B?K1d0dTV5L2pxeHdjNEd4clZKQ29jaGp5YmhMbDhTL004eGFjRkdONVBURUUw?=
 =?utf-8?B?T0ZNZk1UeGtGdHFKcUJHeWpFWnYyUkhMUnNLUzZpT2lTUzJ2STB4bHUyQWZ1?=
 =?utf-8?B?SFZkbGF0Z3ROUE5SY0k2RERDSnJ2RmUrcXI4cnBYODlUR1JTQ3NJUXNoK1Rw?=
 =?utf-8?B?ZnU1ck5iUnZsV1FvNGFoS3A1QVRESk9oZlpSMWFaRzNiM3ptd1MvNllQVVZn?=
 =?utf-8?Q?3b6YPMFpWScvnP9JM4lyuteh9y5ghGtf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkZlMWEySHUzSFp0TVpuL1VQL28rUkdZeTNnQTRtbkhFdU9McXBWVGMvS0xx?=
 =?utf-8?B?T0Y0b1pndUxzQTF6YkZVMkZhcUFkK0U3ZmovQkYwNzdpRVhmUTg4Kys2Si8x?=
 =?utf-8?B?S0hSakYrYldtSE0rcUtyZGpVdDgwcU1DL2FXSkQ5eHE1VU01clBidmx5Wmlz?=
 =?utf-8?B?SU5SUy9WL1UxL3gzTEIxRk0vdjJlbE50UmJGVGZubnlmK3hlYUV4UDJCNk1X?=
 =?utf-8?B?VEcvSUMzc2pSVUg2Yk9mdWNtWkVkS2RTamFGYVUrazFETHRsOE9ZVlVxMWRK?=
 =?utf-8?B?Mm9TcnRLSGtZU1VrbUM2L2d3TEE0UmhwMjEvdjY3UURvTEttTVAwOTdaTzVi?=
 =?utf-8?B?UHBmcVBSTFZnVnpLcUNvYW0xWjNpWXVzL2VEem1MU3F3Ris2YWdnZHFGcW9U?=
 =?utf-8?B?NjFZT0drTkYwQnJxd0phVVhJT3ZQdHVBTWlseEhYM2FBa3FTbVlxcER6V29p?=
 =?utf-8?B?aUdFaGFBWFFXYnlDR3FzQlorTGF6anEzM0YrVmN2N2QrTHFxNWp6Q0k2WERk?=
 =?utf-8?B?M3FoQld0andMV2ZzVVpaSTBDazEvV1RrUkM4TDdZQVo2MlhkdVpwY3JJQXMz?=
 =?utf-8?B?ZHBWcGlRb1NBVGxkRGhiSGo4a1FzcEdwbUEzZXhROXRoamV1RmQzUDB5MGw2?=
 =?utf-8?B?MFkrMTREbHZ0d1JVaHR0RlNwSnBSSlVldE1DMURkWGk5bE1zOXpBWXNJVnR6?=
 =?utf-8?B?RTNYNHc5QmNKaGl2TDRRcHFWSTMzNWNKNVVMRlVvVDJsOVl1OExwK1AybnU3?=
 =?utf-8?B?NngydGlSYWFlUm9DKzQwbHVTa2x2Y1BuY1FCeXFDdHo0RHlVZkFVS3gxK2hK?=
 =?utf-8?B?RkRCckVaNWUybWM1a0Q1L3l6ODdxK1FqVXprSFBBR1JQVXJQakRiWDM5c1or?=
 =?utf-8?B?TDBoWXZ6V1VORC8wWmlGMHo0cVNBWVY3UVFWU29IYTdFSWR5NEJkV29ZTzVS?=
 =?utf-8?B?ZjF5MVd4bGNaaWpRTnFBV2lVQmpzYVJFRitPOCtZY2VMMUtsVnZNZy83L2sr?=
 =?utf-8?B?cjdna0pmaTE1UGVsT3dlM0NjV2VLYVU5b2tKQ0tFMkUvOXc5U0RQNkxRclN6?=
 =?utf-8?B?T2t3Wnh1Wit6cU5oRHdmd09wUENnR3hNUWNWaGRWNUI5NmhLNEdWUzNEWThE?=
 =?utf-8?B?Mm96c1Jad1hlVzk4RUtLOTEwSlh5eHVCWGtjL1NndmtRYktPblpabjJidGNS?=
 =?utf-8?B?bGE0MUxmU0hKcmdwV1E3ZzV1RkdCTUJ0K3lFTkpRZ2VFL1lpc3N6VDFzb3BC?=
 =?utf-8?B?TkNObjBzQVB1UnBQZ01DZURUckxmeWlvMG92dmNGVWE3My9PaTlLYVJOMEt4?=
 =?utf-8?B?UER5VlNJNDlDYlNyYTR2N2RQTlUzSnZpUHRkdTBPazYzdG9vUE1tTU5IVXMw?=
 =?utf-8?B?VjcwKzJCM1VTcWhrcEpvYnNjY3BTQTFYbGtFYkVvbG1YeTlvNm94bGRwT2FB?=
 =?utf-8?B?R1QvWklqb2x1elB3amw5TklOVlVmdXF1eFVJN1VaL0ZsdHhsK1RvM29zcEVB?=
 =?utf-8?B?azlNQlllY2FJVXlKRlFLYXNVRno1NTlsR0VuWEt6RDMvckxqN0ZUemhnVmtE?=
 =?utf-8?B?dkJ3dFhSZzhMWjBvSlp1eHNJVVo4QThmM2dPZTA5Q0hNWW9aOUFwTHJoQ3By?=
 =?utf-8?B?UEFOMmNCcVgzKzBtQ21odktiTzYrNm8xVW9GR2gzM2pPNXl1RHlkZ1pianpI?=
 =?utf-8?B?bkJGMDAyVURuUHZ2Z2g0a01YKzBRaUFxQ2VTSmdiYUZlWVc3SHUzN3lQZkpx?=
 =?utf-8?B?UzRKa3lJVUNCSzhrMHdHTTlieGlTbGgvT3lZeTJUVE9GbzBtdXA3STMxVkxY?=
 =?utf-8?B?cnVtTUZhUGZlUGJTK0pJNGhBaUhXdXF1WmxFM1p5V2JWT2RCRXUxTzQ4R2RV?=
 =?utf-8?B?OUdkM0JUY0tGdjVCS1VPSkxLakhGeUdUWmNRUGpwN092d1ZWQkpDSjRUV1VP?=
 =?utf-8?B?OGRiMHAwNzRZS0gyQ202YzIxNEVGaTRZS3o1ODVOMlpvVHhITWs4OC9CNTZj?=
 =?utf-8?B?TC9tSXVzR3ljOS9xdEQ4dWtuOFQxeU1WY2VHaFVaZjhqbVYvb2d6VmdvN2pW?=
 =?utf-8?B?YzFWL3JrUHNhNUdtOVIvcXlhQzd4Wk00SUg5NlBSZnFzUWtJOFVyMDFFZ0wz?=
 =?utf-8?Q?bb/+1PdBwSMDw1hl2Bq4Xir6w?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9AkmkEQn7aWxf/U6nDRr/j7rSAFbQgNUgrkCgNMDF0JISr6N3X/xvY7DBNXgmqi7w2ESwX/O8xDmEBmuh2cfL7WxVWTo0S/20uDEXIWkZHyBNmmKolpbOmG8gfmbTCBJdYghaR4HkQQLqqNaY7oIUHaL1stJgsmzZvmbv40lDu5C3/Tlbt5d2pTr4+ZaRN9fAHXQZW+u4VO5nIrcom0yNvuGkXw3bYdJkWjiI9T8qKt0IhdT1OrQ98EZBvdAHSVZ/SgLWh/2WULlkY4KYFTZoJO0/4BzSytY8NxdvUqN/XLOwptCZaSkOEIDc5Dn2QzQVMAK65Xjdq9ViLXGwByioR+EkuBnakh8xkiU8a8Sxom+k91sLPH7JM4EOmU49xnLzHsipNU7MJDyqf6fi9mlK0wETBCTKPwNwC203NfFP89DXbj8eGJ3EKocKyJxdpqa67bUQ61MhAU1xEK0ucEYQCq1LVUMJkRj6a8Eajwzcg4UMZsXpvTPcLsMf76rAyZ7Rqw/IOpwg93K/QhV020RTQdnvrZoiW3AimLM4IHvhCu6T/Wwa1uxNF/tzjJmnBy6VRn3sF5unYTcAu49hakQpp7O43/SSyHhWgGxGm5jRXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dad888c-c1b2-4f1e-9ae9-08ddffdad8ec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 04:35:56.6483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xw5Og4BW53GPuTavfzedtpMZJyR2VtAIdduBBhVFYDblqdiYLiRdZriEWkbdJQR1iEPk9115otMd3/6+iTElkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300039
X-Authority-Analysis: v=2.4 cv=J5GnLQnS c=1 sm=1 tr=0 ts=68db5e30 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CDbxC9HEMtGATGK7AlwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: k4BfsZ0TEA_Rtvp6B9xqpiOAqCMSBIYV
X-Proofpoint-GUID: k4BfsZ0TEA_Rtvp6B9xqpiOAqCMSBIYV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDAzNCBTYWx0ZWRfX6p/h9JVXDK1o
 tHh4krxmFg9+jApAehiqflTcF2RISueVjvUbyzHoBX7xbnOV8TK1QTGdIfervi8xN2tef5jS7uq
 X63lT30Iueq93ia+Xt/TL8M1RFPnpsm9Iv5G+AaqkNtUrJ+Yx0JRWGDMPD4i4z8thlhR97ZXyVG
 AjKzX7Q7RaCb9gEbu6QXvsjB49ewJ08dHSl1yOIXOQ4x1wIINwPRLcWEJSh0+XzXt6FKYKpqaN8
 olX/Vbkj/xmpfmTl5YX+X/7tM8npjlTuPy1hGpB+wDVq/VePq7p97hlvMjPa864WeTITcVwWWnw
 dQ1Am3cl33Y0cOen5sN0MjeGPsutaChIBtpVkloKpAD1WJ+i38aK3y/Xb4uLayAMPGcgXZZFAc0
 hyyqw/VtIXnxVofNetpZvsoWUC87pw==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C821940002
X-Stat-Signature: 9php7kc8qh9rtuxdxi8gk67g7i98hq89
X-Rspam-User: 
X-HE-Tag: 1759206972-61063
X-HE-Meta: U2FsdGVkX19bmxC0y2vpZ0pD4QIUoeIFRHRA1xvwaMdmBUxhXQowQLLerZHVypli55kfrmTZ7mZ27cmJ6BXvfwjxuykBu6b/f6m7UsOqGpifg2nVcLwHF1UKzUWcWWOhCTI/TrrjJMCN008K/hc3N9YcJeQNbCaecI6AQhq4Ui9n/14SGkAv5cGjqxF5WbJ3vq1eU0s3UKrbpT+RfJUcyYjMKoYqgqR6p1/5snyt6izbCapsRo8rzNPDQbMPx1vx6p8gTs7MkNDK2O/BAC3Li+tq2UVwiKcekfhrkXJRoOJKm2mYB4zFjLNV+1Hf5tI2DC3h1rB6mCJJub2e4RfKO7V85RFw7Uh7r22ZhGEWfALJ/tekCz1AHBl5L8nCPmkEJuAYSby+QE8iXiMvVTupaDIPjLRd8Y8gqI6X74fOJ2oIdxO6lNqGebnAuesO/WR6amtl8JgOKlvg2iiDFZdiJ/tP27eO/RqpePHXonx0tcSU006fsKynMnfE81xILb9kUcqztXjdMmq9sfUFaJHhvNHIm00nvTKqtqYGXxgYDqURrq/YebEQw3lpOLZmmu6366rGPIEg57vIM2S1++QRCE9NCzmHv7BQwcjs0hgW9favYL4k47PJZDEyyRI8WLcMQf8AjjSEHOLJ8bbk9rffcvZz1gViheD/f0OrCEOwiwB+8DtWJP2xbEDvrOBuaeH3EiGZt1cDsl+VuNkfmpqCiBo6tvZTVnPHNd2PZYDrehx2v52ZATp2K9aDE/vcj+ZueypVLmQvw7yd8x/DoDNTfqc87JnkctzYkO2qFGP1xvWavRkv3kTUtlqMTo9OUI9wNj91QmL2cUpKRtmduHXZfDsMTTyKhnapJcRdb22S6Ttl2It2NCJnGL2xDbx/+XlhoTPN9viGMu6mXR9METa6WhwrFgKLPZfFgSmmmgCN5nGXVzqeFkM6ItmKE/tc5zbzj3AgzcAzLSiUK4gekqQ
 Ro2nKdgA
 H4A3ZFVr+psWHmsNjk1j69BqY2bmYh7FHl+C03P87ut30gOsUMCVCgGxBi9DrgH/cuXhSF1yid2q8hAdcnIKnpxxNEz8pOJAqMD6ATtFERm/bHHQFFa46kh6Wst6hjBI7pRED44RBD618pSQWIVpL6XQp5tjjDLH33ra7rcG2Q56fxdH2WtdX60b4FOtJYy6eR3cVvdFLI5eg6LB9OaIqqMc3pBOcW7D2+CGesJAoOkX5rv/iqwIqkEooenl5Sfjp3QDFH+Sli5X6vD1s6VUv+oooheJ76QjZaYZ0hp6b6+pCiquTuKN3EaWcDmGYOQ5ZJ8dIuZLUwx7uwDCtmQVfsB+jqZH3auWhje/gCTnmyh8P3q0Xy3K4dFUmquCFPUgDzy+sMNuIe/KIJAjo20iWwC1d96cNW2jkdjmlDyXGyYpuzBMR4GU7/8QqSt1laRIU2b1UQf8NV9T+y8cubcyQKIC+CTKG7jUe9gYNFVFxS+w0nRBTxdvtIJbHS7mFyQA1OZsA/SNuCUiPEagXPNOgFBg6ShPh3T/4jgTBRUvJTc6/GHgb+cP+JUBEqdGpTNry3AECFTOWGp0fiNlJDS+jKKo7xYL4pzyJtuoDp18ZuEdW3aWvhscL6uRwmOtSmXjczy9vaeXblLyXbC8+Cmai6tGklO3bHTsWs6PwItkS3jGRhoRuyUMt7j4A5WHU0x1kNk2gwpL2vuQj+u169YiKAO5GoDTS0SsIBc9FAzGbJLlbdEfgVZoLe86o81NQvwEr2GJcqNmgP7nyjejKIFXpsfFcrqBnNdG0tQ4oKXnlsuPKOalgEJ8w5jSQkS8p/7oSWkOvP4SllrdALA/zZMuDOxkcwU45OHOip6zmzhG7fD6yYJgwMQwOmGZTl1GwIPGtMuWoV+cETd4RGDfzgyqdh2vvoQPxQsqNj/W6/o14Nvd9J8dYO0S9JWMHQcEnKeC6zozIM5YK0YnlZnLvKgSA3omaPuMB
 IjMKvOOp
 Sq+gvynoszuDhhpLegfUrAbE5W/9FzO/LjEdXtJHctU/NRhqS6jN+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/2025 7:51 PM, Miaohe Lin wrote:
> On 2025/9/30 2:23, jane.chu@oracle.com wrote:
>>
>>
>> On 9/29/2025 10:49 AM, jane.chu@oracle.com wrote:
>>>
>>> On 9/29/2025 10:29 AM, jane.chu@oracle.com wrote:
>>>>
>>>> On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>>>>>
>>>>>> I want to change all the split functions in huge_mm.h and provide
>>>>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>>>>>
>>>>>> Something like below:
>>>>>>
>>>>>> 1. no split function will change the given order;
>>>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>>>>>> is smaller than mapping_min_folio_order().
>>>>>>
>>>>>> In this way, for an LBS folio that cannot be split to order 0, split
>>>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>>>> be split. The caller is supposed to handle the split failure.
>>>>>
>>>>> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
>>>>> function if new_order < min_order like this:
>>>>> ...
>>>>>          min_order = mapping_min_folio_order(folio->mapping);
>>>>>          if (new_order < min_order) {
>>>>> -            VM_WARN_ONCE(1, "Cannot split mapped folio below min- order: %u",
>>>>> -                     min_order);
>>>>>              ret = -EINVAL;
>>>>>              goto out;
>>>>>          }
>>>>> ...
>>>>
>>>> Then the user process will get a SIGBUS indicting the entire huge page at higher order -
>>>>                   folio_set_has_hwpoisoned(folio);
>>>>                   if (try_to_split_thp_page(p, false) < 0) {
>>>>                           res = -EHWPOISON;
>>>>                           kill_procs_now(p, pfn, flags, folio);
>>>>                           put_page(p);
>>>>                           action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>>>>                           goto unlock_mutex;
>>>>                   }
>>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>>>                   folio = page_folio(p);
>>>>
>>>> the huge page is not usable any way, kind of similar to the hugetlb page situation: since the page cannot be splitted, the entire page is marked unusable.
>>>>
>>>> How about keep the current huge page split code as is, but change the M- F code to recognize that in a successful splitting case, the poisoned page might just be in a lower folio order, and thus, deliver the SIGBUS ?
>>>>
>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>> index a24806bb8e82..342c81edcdd9 100644
>>>> --- a/mm/memory-failure.c
>>>> +++ b/mm/memory-failure.c
>>>> @@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>>                    * page is a valid handlable page.
>>>>                    */
>>>>                   folio_set_has_hwpoisoned(folio);
>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>> +               ret = try_to_split_thp_page(p, false);
>>>> +               folio = page_folio(p);
>>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>>                           res = -EHWPOISON;
>>>>                           kill_procs_now(p, pfn, flags, folio);
>>>>                           put_page(p);
>>>> @@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>>                           goto unlock_mutex;
>>>>                   }
>>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>>> -               folio = page_folio(p);
>>>>           }
>>>>
>>>> thanks,
>>>> -jane
>>>
>>> Maybe this is better, in case there are other reason for split_huge_page() to return -EINVAL.
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index a24806bb8e82..2bfa05acae65 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -1659,9 +1659,10 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>    static int try_to_split_thp_page(struct page *page, bool release)
>>>    {
>>>           int ret;
>>> +       int new_order = min_order_for_split(page_folio(page));
>>>
>>>           lock_page(page);
>>> -       ret = split_huge_page(page);
>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>           unlock_page(page);
>>>
>>>           if (ret && release)
>>> @@ -2277,6 +2278,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>           folio_unlock(folio);
>>>
>>>           if (folio_test_large(folio)) {
>>> +               int ret;
>>>                   /*
>>>                    * The flag must be set after the refcount is bumped
>>>                    * otherwise it may race with THP split.
>>> @@ -2291,7 +2293,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>                    * page is a valid handlable page.
>>>                    */
>>>                   folio_set_has_hwpoisoned(folio);
>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>> +               ret = try_to_split_thp_page(p, false);
>>> +               folio = page_folio(p);
>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>                           res = -EHWPOISON;
>>>                           kill_procs_now(p, pfn, flags, folio);
>>>                           put_page(p);
>>> @@ -2299,7 +2303,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>                           goto unlock_mutex;
>>>                   }
>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>> -               folio = page_folio(p);
>>>           }
>>>
>>>           /*
>>> @@ -2618,7 +2621,8 @@ static int soft_offline_in_use_page(struct page *page)
>>>           };
>>>
>>>           if (!huge && folio_test_large(folio)) {
>>> -               if (try_to_split_thp_page(page, true)) {
>>> +               if ((try_to_split_thp_page(page, true)) ||
>>> +                       folio_test_large(page_folio(page))) {
>>>                           pr_info("%#lx: thp split failed\n", pfn);
>>>                           return -EBUSY;
>>>                   }
>>
>> In soft offline, better to check if (min_order_for_split > 0), no need to split, just return for now ...
> 
> I might be miss something but why we have to split it? Could we migrate the whole thp or folio with min_order instead?

The soft offline code was originally written with the assumption that 
only 1 base page will be offlined.  With the recent introduction of 
min_order, it might quietly offline multiple pages, is that a desirable 
thing?  Recently we see patch aimed at not soft offlining hugetlb page 
while okay to offline 4K page though.

What do you think?

thanks,
-jane

> 
> Thanks.
> .



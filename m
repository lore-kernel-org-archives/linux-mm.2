Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A2DCD6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405A36B0088; Thu, 18 Dec 2025 14:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3826B0089; Thu, 18 Dec 2025 14:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CCD6B008A; Thu, 18 Dec 2025 14:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7826B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:02:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BD0BC037F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:02:09 +0000 (UTC)
X-FDA: 84233511978.30.48064B7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id C7DA720022
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:02:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I9lLeRxd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YlmEMhRT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766084525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7W+rI2A7isPVhza4zOldtfWe/mwjDaKXUMq1N7IeA9s=;
	b=lV0+hGGbFSKkA13WB2iP+M6Z/HIGl7GJRinKeVRO1eTfuJ6b25LqQIR6fHNscMvKaf5Ty7
	hfwGOA8ECFAXNhOKDe6KO7ezf+39yMsMZwOjfXCHUNWUNYGTit2/p4COZLkDcGXn9xnjvh
	lv982UCq+HYcv88PsfPXatgycjS0SlM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I9lLeRxd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YlmEMhRT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766084525; a=rsa-sha256;
	cv=pass;
	b=OckarMggFmd8P88VJE8IqtM8V1SIARPnPjsACj7KvM1cgUPNZTmUBxaWdWXbYorUtDFMs+
	KyI5Pgtovt6I+wokFi38C2W5Sqkco8doRSr5Kb4HsDZwquu/8fHQs0NzbAxtoiKKKAfgbH
	RgIEXWHQrseqapmAxBdB5MxdeEZrOvY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIHgCGP1668096;
	Thu, 18 Dec 2025 19:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7W+rI2A7isPVhza4zOldtfWe/mwjDaKXUMq1N7IeA9s=; b=
	I9lLeRxdDgPPYsiH1chIejdP1DexgP/rM+ADE4X6lGivnuXqs2Ar+qQhJeREQsDn
	v6fzsqRAF7HFjkwSBM79sYmG/oS5tSOF5V7Ehf18vAQN8T8BhO/klSC23kO3w3Wg
	23srPcRPkiW1VT6NDm7/C1sE0MKscgbYEmlV6rxbyouTtoizRTf3c9xD0BfuIhqH
	bsVcdOhFNM8WqrulLxrXPPwKI6nvcGqIzdETDe056tnxSvCdwxv8zommPX2OMQYo
	XuhVz3tZ4c6etsSCDFttsFk7K/aa3LkqBjdetdaig9W6q83SPnz5Je5AiWbqe/Io
	GNEQnjbOjRPZ1PXAnXup1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b106cgbnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 19:01:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIIgEuv024466;
	Thu, 18 Dec 2025 19:01:48 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkdhapg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 19:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HVhDPZ8syarO1WARnvADvgI15w0s4Cgqk2Zc12bEJaR30NuKSraMgXhqWmk8IgGHABeFYsvcGX0yTljrBMKhWB+koQn7YqSKskBBa0LruNXaKcdjr8WgzAEoSfMM0dJrvn2HUR/RW/CzAMtaJixZ+7VvFp24A8Zx3bLyFXlV9mEMkeaeh1qHjoW5T2BxGc138ZgLwFLd/HDp99l9FutAnuYVrME/mkzrpAX9pGENceyWATKWES7yAP4l4/ptvUzAdqQYz07ghfqKb4Spk6kICEyaAUogRJtxcYN1yZN6urSWZZl+elY75LANmW/8VRewOoPS/pkmZGglgARWGsuZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7W+rI2A7isPVhza4zOldtfWe/mwjDaKXUMq1N7IeA9s=;
 b=nQn0IaJD0BJW+BJGmRsAvQiGzeyjBibEl1jWSpgGZrlO7aXNomLNYYVkn+iUHER4zKl1JIBXuVoVLUTwJghjqThw4Kr1IgZKZR5u7c2bhGuMX/b+0pJLIggNIBppEjg97+VGrD7ZB0qrxOaVh32eSWuZPqY3Gt2XBZj+ITmDtTmiGfwQZYnU2T1/MaPtfHLfulkoxq+JBYt2DgxzBCp8TIxE4GvtchvH8pU3PXhiygr6dAQA21quyuMnROfeSKIdf3aIvT9jHiqyIILtSEIT4Ufd/nydqEn2eGyMnQBwa/DRz/fmW4kPYC+cXkCvk4Oln9I5/tlFKfuLKKGhIZPvYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W+rI2A7isPVhza4zOldtfWe/mwjDaKXUMq1N7IeA9s=;
 b=YlmEMhRTHY4U35kVm6FGIMv08YxMOzzHjLmbYj50E9gxTgdzqL2ypqSl7GqOOlDNzOIvn45EcC7nDtBS2Eg2y533oWqxjsnWwCUo2J3bNJ8on8fcTM6AIk/EkMNe79alPBQY/mzXGMhh85mlMKOf8vjfFwhiXuoobS/mfhAa9fk=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA0PR10MB6770.namprd10.prod.outlook.com (2603:10b6:208:43d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.8; Thu, 18 Dec 2025 19:01:46 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 19:01:45 +0000
Message-ID: <609ec743-e989-4c50-904a-80388d6a0096@oracle.com>
Date: Thu, 18 Dec 2025 11:01:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, muchun.song@linux.dev,
        osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
        william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251216215621.920093-1-jane.chu@oracle.com>
 <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH1PEPF0001330C.namprd07.prod.outlook.com
 (2603:10b6:518:1::1b) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA0PR10MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: c7083c54-b03b-4ae9-ae12-08de3e67e3c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGpQTDM5LzMwSlVqa0FYakRVZndKNWdQdVdaY0tOd2JtVWU2QnhzWmJobjJ2?=
 =?utf-8?B?K29QME9ZMm9YOUw4cE4vbEhmVUZKdXRkWFNWNjNpeTB1d3Bvc3dPZ0hGY3pq?=
 =?utf-8?B?MzJoYjU1U1F2VXBHWFE0YmFGU09KNnQxWEdCSDZDb2hPemltdW1tTXljWlI5?=
 =?utf-8?B?eDdoNkJsbnR1NTI4amRKQ1c5QTJYSEpXVElaaTdvL2J3MituY2lMOUtMYUli?=
 =?utf-8?B?VUs4SG55dmtZWFNHYlFRVUpNQjRSQ2M4ZmthWmZRMzZHOFEvZ0E1TmxyVXZR?=
 =?utf-8?B?Q1Jyc2JGTE9EUGw1bnRxVU9GRXJBcnF1c21pUC9wcmt3VUE1YzI1TTZ1YlVF?=
 =?utf-8?B?aWNURlY0NDF1MkplcHJwWTZlR1R3eFhYQ3MxaS9wWS9YbkkveWxVaTUzSktT?=
 =?utf-8?B?NE5Wc3FYMUowZFM1M3dEOStxOFVKUENBZzBzVmVCNC9FVU1LK3VkUWN3Qlcr?=
 =?utf-8?B?WFFkVVpGWW9zeUZOenhKU3ZpdTdUVmxlalhaODhvV2dkdkVxZU5lMVdCWUhr?=
 =?utf-8?B?NXo2ZXhrM2tZbklxaUU0UUsxL1FHR2ozZEpZT2htYTlKTStmYnFmQUNzWFk3?=
 =?utf-8?B?bFR2NUg4MGdDS0Z6V3lpQ0xnV0lJOFpDS29IeUEwaHJqZDhzcFB6ODlFTkVl?=
 =?utf-8?B?b3ZDQ3RueHBPL25aUVdaRjJYRjZ0aFlqWlpRWUZITUsyTFYrdktDeTF1bXVF?=
 =?utf-8?B?V2wzNExmTllOZXM3YXFVVlRmaFFwNlVFSVlETnZLcTFrQklkazlhNTZka2Za?=
 =?utf-8?B?QmkzdGFhcW1rS2Y4ajZKZ1N5M2YzdFBqWS82TW00Um5ES05OUHRaaW93MUlM?=
 =?utf-8?B?ZjgxR1I5NE52dzkrNk5YV3YvdFhyOEMvdzJQaWZoUWRPTjloNG5mVzY0Vm00?=
 =?utf-8?B?eEhVUGFRWGNiQUpHQVZaK0RJekwvQ1VGTnFwTXRtMERwZTNrd2VLTWZzc1A4?=
 =?utf-8?B?SUNzUXFXblZsL2N1VDhUSFQ0a2hsamFZQ1kxeWVyanBGV0MrR2FCN2RCSTlT?=
 =?utf-8?B?Z2FBV2Fwc0ZTN2dsMGJIeHdFWVJzazZQNmVFd1Z0L1NvNWRBSlYvbXJxUGRq?=
 =?utf-8?B?bGsyTy9xUXo1dFQvWUhHbTNRZmN0aG1VMitFek5rTHJvaStXTHZNQ3cvVXFD?=
 =?utf-8?B?YUMvc2VGL01VNFQ5MnFPUnd0QXBlaGllQ3hOZGRJZk01bk8wUnFhS0RGMkpp?=
 =?utf-8?B?VlhmTlUycWZzb0VmSHV0QnptaUt2Z25xNmVFdUlYMTJjbzE0dnE2Q2RDT2Vt?=
 =?utf-8?B?Tk84TzJwQS9VUXNrL0kySXdBSjNUTnBDc0hSTDN1ajFJVExwS2l5MHdVQ1pL?=
 =?utf-8?B?Uzd0aUZ2RjljTjJZMStyOFRidmh5Y3R6REZZelIwa1hWcE1OelZZcWFvRnht?=
 =?utf-8?B?Wjg3MEF4QU5CQU43UEhWdzk4K2puZHRveTBNN0EyUE54YkNyN04rUkRYeVlr?=
 =?utf-8?B?bGd3T0gxcWthd1NDSG9zbDRycmxjRVIxWlZXQngvV2xuTXBhWm9TeVp6THJz?=
 =?utf-8?B?eTRscWNIRzNBWWJ5SlBXTmNOc29qdk1MVkFkVzMza3FadTB0TUc1QVAwOEpZ?=
 =?utf-8?B?bTlFODgrWTZHYndaWHRVaGE1TGIramNNVmwwaTVFL0xkYVZndS91YjYvRVpy?=
 =?utf-8?B?Y0ZZRHFVTU9Ha0JQY0tzVTE3Y3ZEVFR4cHRhdENONFJGMkZaNmhwRmxVdlFZ?=
 =?utf-8?B?bWZsQVU5RFVJdmVYTVp0T2JDVTFPMFNnK0lhOERCcXVLRjI5SXpUclp6aEI4?=
 =?utf-8?B?VjNocTkyU0ovV3UwQ2dmYVVuV1VQS0RLYmlqemJsZ3dTa0oxOGJsUnlKUUZo?=
 =?utf-8?B?TGdYeE1zVDZnVWFMbXZyMU43ZU5HUmtzakgvOFJuWmpDZ2oxcVk2cE1QR256?=
 =?utf-8?B?RnFEVm1JbnYvK1pSYlkxa01FVlE5U3JYb1lLTldmQ3VvUkI0bkUzVVFQUzhO?=
 =?utf-8?B?a05aT1RFME5wUWVkcmE0Zy9LTTNlYlNxM0FXZTJZSjRQTkRHaGdTL0p1NXAy?=
 =?utf-8?Q?OCajUf7MyRsGfKqWq15rc9E9ckTabk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHFjVEZHcGMvMk01YjRlallxZHN6TVk0OWdKaXlvbVBWTEhJUHFpNHFVMDMx?=
 =?utf-8?B?RHVGRU8xNGkxUWxRQktpY0VzcGdBZXdTbHpRUDc2MVF4amh4ZHlNQnZjYWFM?=
 =?utf-8?B?S0lCR1J6S3QwVEErbzVzUml2ak1TU0tRUDU4b05kR3kvR2FtU1NJMkZYYmtj?=
 =?utf-8?B?QXFSdzBZMWh3K1ZFU2tBZVgzSi9IM2FWRkFkdWtOUE1sZTFJcXI1SHdtdnQw?=
 =?utf-8?B?NTRnS0dRanJtZGRremlqRUdOUGg2aG1jaXdOblpVeHhXZW82K2lFcWlUcFZS?=
 =?utf-8?B?cldid0RTQWxPRm1WZ3dXMTg2RjJxUTdmWjRKWm1tc3doWjB0bU5OdEhPb1di?=
 =?utf-8?B?RFcyR3Y3Q2lvVmtaVjJpa2FRTG1JT2FLNUEvOUYrZ25JbkFESkpnZFE2aGhx?=
 =?utf-8?B?TVRoWDU4ZnlQSFpRNUIvWjloSWN6c2tmVnk4c0E0ZFVNbWJqT2xZZEJUVXRE?=
 =?utf-8?B?NHV6TGJjRXV5dkErTmpFUTk1ZVhsTGhTSVY5YXBJSGR0MklCaXZLeTlrMElH?=
 =?utf-8?B?QTkwbm5zS2R1KzJRT2JxYXZ4ZmRXMTBxSjU4bkE1bnBUYXF0U1p6cUhsa25B?=
 =?utf-8?B?NmZJbzlTL0VwU1MyRDZwYm5HWWhlSmNtZGE1QkVSYWhxQmo5Rk9HMHluTkJR?=
 =?utf-8?B?RG1UYTUvd1JvSFN1UkJJTTVWOXpwSmV6Q3NMMTViVDVjWVF3aUEzVUxKZHcz?=
 =?utf-8?B?aGFQV0dkaDJDYSt4djc4d281M2dYNVJrZ0dmaFA4YmpQYXZQVEZQektsN3da?=
 =?utf-8?B?TjJlK1dIUFdISDVXbUF4YjFkRzJKZFlFUTc5RitFU2w4VkR3TVFBSy9EQ1Vr?=
 =?utf-8?B?WnJBd0dORHV1YnZZdTNBU1pVenlqR1pJQnVTTXVua1J5Mk8vZjN6Y3FHNzRl?=
 =?utf-8?B?Q3FCRlByNEhsdjBld2toRTQyYkMvb01rR3Brb3I2YmVPSm1sejduTEpROThT?=
 =?utf-8?B?bURUZE40cnJwWHRPQmlwbkV0RFdOd1NuS0hKN1pNYkp2ZTNZd20wUCs2NEN0?=
 =?utf-8?B?QkZ0SUUvYXBaK1ZJNktrMXI3N1BCaitIL0ZyWmZWcjZZc0NLWFNCRHErcmlF?=
 =?utf-8?B?cHRFRnJuY0t1WGptOXBwZWJFYlB0bEZwcW43dytLdjNnbmxScTVLeGNzbXUv?=
 =?utf-8?B?NmsxSzJxQ1hHcjlLVHBvLzBBRnRnb2drUjdrdDNHV3VQbmhvSDNuOUxCUGpk?=
 =?utf-8?B?dEJtcTZPcXNYQ28vZkM4SFRCWnU3emVrc28xa2NLYXZiSHRpV2NCVDloMGNs?=
 =?utf-8?B?U3NMR21kWWRZa05FbXVNdlBQQmhxQ0ZxbWk3QXEvOWc4N015cU9MaWJ6R2NM?=
 =?utf-8?B?eXNjeUxDRUFOZTNldysyenFwVzdSSzlQRFAxQzN5dG85MWFvTTc1a2VoVHpo?=
 =?utf-8?B?MW8rRko0T1VQaW9lbHF1a0tBVVBmQ0dXeFZZbnJTcHZUeEl6WnZBUjAydTNk?=
 =?utf-8?B?MzVFbG1VRDZzVnRsMXEwYkJEU1p0SmtNVXk1MjR5ejI1M3J4RjFtdHgzRUVi?=
 =?utf-8?B?OXdLMmlYa3VDWnVIc05HK2Q5b2pSM3JyQWZIQUxRYnV1bmlGYTZ3VkZCK3ZL?=
 =?utf-8?B?MjhYYURJMEc3NFZaVzZvVHdvTm1WcU80T3lwSE9Pc0FwbnpmYjY3U2xRemxa?=
 =?utf-8?B?dzB6MWRZZmtSNkxCeVZLTzduUDQ0K0dKRW51V1lBRzVEV1UvbXFHVjR2L2Er?=
 =?utf-8?B?MWhyRWs1ZDd2SnpreEEzaHFmeFhvM3J5Zi8zWUZHUEo2TiswYlhBZmdLeWJS?=
 =?utf-8?B?NFlPd2tSaHlDcURGVEJyOXNNOVQ5dFpPNjRHMURZMmpnNFZjVXppWXV3RHR4?=
 =?utf-8?B?MzRFS0EzT0F1bnl1a3FGVUN5ZVRYbkQweEswclFxSStvTElUTVIxc0ZJVGtv?=
 =?utf-8?B?S2JEVWtwN3BncEF5RVVhQ3VnL0NNVnloZ3VFNE5Ec0JTU3hxVHlWVkhOZHIy?=
 =?utf-8?B?QmF0cnkvblJWS0FxT0NrN25HMjJXUnhPMlprczVQd0llNS81QW82empaN3h5?=
 =?utf-8?B?VGFWTFVNNDd1V25ST0NJRGFYTndzWHd3YWhob3VuSGtHbWk5bkhGV1FyYTNz?=
 =?utf-8?B?dTFtTEpDUHN0NE1aZnZqMVRCU3BFN2ZnVUxSa295YUtuOEkxb1EreHlOTzJw?=
 =?utf-8?Q?itcXHJn2Q+Gx9G1Kqad6hjdvS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ej4IvYxSOfugPER33Tc6OkIOAg1aTdmIPIonlljoH70BNWy/V56qD5eBOp5upbnu74dZThsV8FegkH8wD2ygPFPOFK1TMpEpatbbeKWsBhHT2lb4r2O6ebE/gVxKVckkmhpdUMkesQz6TnAvbqRiNeCRTCNzDOiqbFAdYTE4/zXitv71F/Qma6surveCqLHW7XKTHTfLCBG98sfGDkw8Uur0+oOpISrKDzRNhH/oEZn8l6dRm4QoeQaQGX97biG1l7VqpQFafnZjD3rYuGZd5PIT6YC8x9ETIxdcW7mKbIkPJhGNZXC14qqqhHyYaUdeI6vimXsDhaBwtLwmpl8f0qI5BqrnzlBmlHTkxAKOwyzWQvaKeb3KrpHL0ZAKq47HqnadgzZ1d7c9ZcqIBzv/ic0MNn2X0l+rZqoKyImQyRdAukEpWOIA0KmIA2XYntNhbjGlvTsjhUdV1pMNr+ZZWD0PAQCEnDptq7tnsi8uDOxXzSLL0hCL47ovAk8sY/TqHWzszhq2HvzvHfoqFIr8UVSO33SRrPG3Nkxxv3BnInpVvhJqgSTj6cnmCSfDVmk4xThuenhvQ3cI+9xLnOcRQwy0W+rTw1z46jLwq3ngEH0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7083c54-b03b-4ae9-ae12-08de3e67e3c7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 19:01:45.8893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1quXgLr+8lecj1Th6ohyJyqR++VlwhL5NvCqyEWeBQk+9sSNs9G6FjZ9CoAlpHis3IFNlK8JJWoElr3epDqgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180157
X-Proofpoint-ORIG-GUID: gILTFWTK-vXtoiMym-uljbxSHjEkcZYr
X-Proofpoint-GUID: gILTFWTK-vXtoiMym-uljbxSHjEkcZYr
X-Authority-Analysis: v=2.4 cv=et/SD4pX c=1 sm=1 tr=0 ts=69444f9d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=HcMw7fNOrhbT0rgCwr8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE1NyBTYWx0ZWRfX3GrrSV1TL2Nr
 BiYaNDosTRZz4UsZNnuYao36pf2hY8Qc+l7UfsR9+KQIjLEuCl8FW9c5OOmLIQB6Z2SFTNbjjBy
 8VNDeMG6fkwtrgCSx2GnuQ1RkCioT1alBPvz3tZgw/1jDQ7JeGSrhswJdiBLKvipz4+aVNAf4Tl
 rJHfnces7XjSuZjeeErmJPwzW3AVTCzvUbQIoB8byQ3faz20JpWqPNxtz8fyUidZCK658ZCC0Sm
 1ubtqoPaviAEaXlgN9NFfH2EYh6/I6TtMS+/w1FpD5LLA7bUja6MlnMNeyk/+2ru1FfFyD318pV
 IVUudQ8wnV89Nx0DiCN9BtXxWxNChfgXYMHQ0h8hj33Fts/QULfye8SpbHb8wtOwql1cpjkwVx4
 LlAamLi/BaG1CY+MOryq5TFuwgLzpw==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7DA720022
X-Stat-Signature: zqk4mpfe6rft8jg4efrojcpp6cq93g35
X-Rspam-User: 
X-HE-Tag: 1766084525-150199
X-HE-Meta: U2FsdGVkX19/wY/C0Spi9MQP1qm9peWRNNkZcYafZPuWDvb3E6VQUxC3q6hzpjqhP8JvDlqVGa7lumAlv5WT4jwJKzihI0uBoVLRuR2VupU2gQ9ZRJimrcTYoft5mUj68kfgu9wyjzMeUwcWk6up8HIKwTk5O93DSOdcOhOQDnUv1kQ6pwv0s2zMeSi0qSpn9/MAq0mIBwftYwOBhFV7MttIyfaXl5glGJmvuK2UN1UBWIb+E4Rgs7/3ZqnvPZkCA8ZeFQN5o1jrTZvbkNJR5e+gtjv5HUTHPa5+NH88RrCkd+F/5ig1l1FpxXF48F3dg7/PZBUkugTtth2ytuTtS/V0qpY7Au37OY+91Vninu/Q8e9lYPQQmUEDxU/fIZnULTkPTDmfy/f2Q2yHSYKx3h9ebD2ARzzAfY8rno4VnSvWXDvZ9p4sn4Zm0Ab3fdCMbD16tmRsSqqu+vBp53F656w82dFd7Wu3vFae9g+qgvZJGpMbgxS+TsNLRlMS7gSUl146QMNW6nkhFA4Nyc37s6/x9GFkbmZ+A/k+3bsWc/dfGbp5Crbq6e+RZhKjbr+OH2XZFSGVKb7ntmkeTIBDDfu6f6pP9/Ej5Gj7wCNjOnooy4ZwOXvqC49UQABHrgpBGtzdIaFKObDS1Fyzv26tKii7VlPGFADt0o09w4/UG8+YMwpk7KM2ll0NVcYK3eKxm99bNd29zoBT9nNfB/BrxGkVb00gZHw/bn6JXZXS5H1X8dVDhK6IXO3Ifpn21mM9rKBULjiOCTaL2jg8XNZZ7ktNDDIc/hWd7b4NaWctGQOqn2Zf6t6v+/UYCeaDO4iNzmAyu7inhgpXdGAEv9L05WD5vkg4xYT9duzYGd3TGvGvcEBM4KOHXg0+P8XmPDtU7cknXmK04V/lJZDGwq9S+MWODROTIX/OsuNUGwq5Ug5t/efYduIQhW+C6JsOVhbEbbIRDqZdaRKyawcMCkr
 IMvK5JKd
 RXjX7hu3vPJt00SJE9zMG5SqTcBZvDbUnOsOjw9DvBKCUHJ634frgnMzdGJyvDLF9Y3RxDMIzrdwxjHAgTZgm7/iqRhy2sYsLdep2p6G5rq9/H/envF9OTTO9yaRQ6cLpsjYAJHAULkmazg+8ePeR8yBWYM7wdJDdObEvYWCyePzVy7nUciU6kD6hzxYa9R3+5wYuRXlkL9q355eJYvY3BA2bYhMKZeHDdfuMApSV0pBLh29qKGnj9VU19jiMh8BUvbPLL/pDgaRYCSQMoN8Ft5kdnxwIOkSgr2D411Qc43SMR40aUKcp9i60ecPXgMgcXdgQoz7An/Fh+pSPvKrFyWGx95n8iKS1ibQOU/zKF5hXE82iQd5FcNmUvLfGHeaidbwx1VgwBMuNgGYkpfGRIk1YZ8Jk2ABaPnYEHS3Hm2a8ddM6ZiVGAXg4m0u1L8aa1Q3Q20WbZit+izWRHkCsuUIuw3AkUdyQh+Mj3bNVZ3VopXZgZWL3uYERE9v9z0LbrSR6Ac5s7tcJQiaEDy7q/KKZYdElhfGtXN2xCa6cLAG032kdYgb1WoIg9i0z+6Q3aAqUbmBtCCTaV08bwxRT/XTGGYUlDJ5pfWI9km8huLnetJtAW/VmIYhVcenu93P/4ghwx8x2zJQM433fa9HUJu2sfvGHKe3w+EdYjT9dQQAXcqZBI6IuMt9onhhlQlyLck3wZoZvow4D37PvLf59MTonZicQNrCr3Oaa4JnwOHZ+aRW379e7dYrAzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

Thanks for the review.

On 12/18/2025 12:41 AM, David Hildenbrand (Red Hat) wrote:
> On 12/16/25 22:56, Jane Chu wrote:
>> When a newly poisoned subpage ends up in an already poisoned hugetlb
> 
> The concept of subpages does not exist. It's a page of a hugetlb folio.

Okay.

> 
>> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
>> is not. Fix the inconsistency by designating action_result() to update
>> them both.
> 
> What is the user-visible result of that?

For the purpose of observation, and potential action afterwards.

# cat /proc/meminfo | grep HardwareCorrupted
shows 'num_poisoned_pages', the global count of poisoned pages.

# ls /sys/devices/system/node/node0/memory_failure
delayed  failed  ignored  recovered  total
these fields show the per node ->mf_stats, that is the MF handling results.

> 
>>
>> Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats 
>> to pglist_data")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   include/linux/hugetlb.h |  4 ++--
>>   include/linux/mm.h      |  4 ++--
>>   mm/hugetlb.c            |  4 ++--
>>   mm/memory-failure.c     | 22 +++++++++++++---------
>>   4 files changed, 19 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 8e63e46b8e1f..2e6690c9df96 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -157,7 +157,7 @@ long hugetlb_unreserve_pages(struct inode *inode, 
>> long start, long end,
>>   bool folio_isolate_hugetlb(struct folio *folio, struct list_head 
>> *list);
>>   int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, 
>> bool unpoison);
>>   int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                bool *migratable_cleared);
>> +                bool *migratable_cleared, bool *samepg);
>>   void folio_putback_hugetlb(struct folio *folio);
>>   void move_hugetlb_state(struct folio *old_folio, struct folio 
>> *new_folio, int reason);
>>   void hugetlb_fix_reserve_counts(struct inode *inode);
>> @@ -420,7 +420,7 @@ static inline int 
>> get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>>   }
>>   static inline int get_huge_page_for_hwpoison(unsigned long pfn, int 
>> flags,
>> -                    bool *migratable_cleared)
>> +                    bool *migratable_cleared, bool *samepg)
>>   {
>>       return 0;
>>   }
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 7c79b3369b82..68b1812e9c0a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4036,7 +4036,7 @@ extern int soft_offline_page(unsigned long pfn, 
>> int flags);
>>   extern const struct attribute_group memory_failure_attr_group;
>>   extern void memory_failure_queue(unsigned long pfn, int flags);
>>   extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                    bool *migratable_cleared);
>> +                    bool *migratable_cleared, bool *samepg);
>>   void num_poisoned_pages_inc(unsigned long pfn);
>>   void num_poisoned_pages_sub(unsigned long pfn, long i);
>>   #else
>> @@ -4045,7 +4045,7 @@ static inline void memory_failure_queue(unsigned 
>> long pfn, int flags)
>>   }
>>   static inline int __get_huge_page_for_hwpoison(unsigned long pfn, 
>> int flags,
>> -                    bool *migratable_cleared)
>> +                    bool *migratable_cleared, bool *samepg)
>>   {
>>       return 0;
>>   }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 0455119716ec..f78562a578e5 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -7818,12 +7818,12 @@ int get_hwpoison_hugetlb_folio(struct folio 
>> *folio, bool *hugetlb, bool unpoison
>>   }
>>   int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                bool *migratable_cleared)
>> +                bool *migratable_cleared, bool *samepg)
>>   {
>>       int ret;
>>       spin_lock_irq(&hugetlb_lock);
>> -    ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
>> +    ret = __get_huge_page_for_hwpoison(pfn, flags, 
>> migratable_cleared, samepg);
>>       spin_unlock_irq(&hugetlb_lock);
>>       return ret;
>>   }
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 3edebb0cda30..070f43bb110a 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1873,7 +1873,8 @@ static unsigned long __folio_free_raw_hwp(struct 
>> folio *folio, bool move_flag)
>>       return count;
>>   }
>> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct 
>> page *page)
>> +static int folio_set_hugetlb_hwpoison(struct folio *folio, struct 
>> page *page,
>> +                    bool *samepg)
>>   {
>>       struct llist_head *head;
>>       struct raw_hwp_page *raw_hwp;
>> @@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(struct 
>> folio *folio, struct page *page)
>>           return -EHWPOISON;
>>       head = raw_hwp_list_head(folio);
>>       llist_for_each_entry(p, head->first, node) {
>> -        if (p->page == page)
>> +        if (p->page == page) {
>> +            *samepg = true;
>>               return -EHWPOISON;
>> +        }
>>       }
>>       raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>>       if (raw_hwp) {
>>           raw_hwp->page = page;
>>           llist_add(&raw_hwp->node, head);
>> -        /* the first error event will be counted in action_result(). */
>> -        if (ret)
>> -            num_poisoned_pages_inc(page_to_pfn(page));
>>       } else {
>>           /*
>>            * Failed to save raw error info.  We no longer trace all
>> @@ -1956,7 +1956,7 @@ void folio_clear_hugetlb_hwpoison(struct folio 
>> *folio)
>>    *   -EHWPOISON    - the hugepage is already hwpoisoned
>>    */
>>   int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>> -                 bool *migratable_cleared)
>> +                 bool *migratable_cleared, bool *samepg)
>>   {
>>       struct page *page = pfn_to_page(pfn);
>>       struct folio *folio = page_folio(page);
>> @@ -1981,7 +1981,7 @@ int __get_huge_page_for_hwpoison(unsigned long 
>> pfn, int flags,
>>               goto out;
>>       }
>> -    if (folio_set_hugetlb_hwpoison(folio, page)) {
>> +    if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
>>           ret = -EHWPOISON;
>>           goto out;
>>       }
>> @@ -2014,11 +2014,12 @@ static int try_memory_failure_hugetlb(unsigned 
>> long pfn, int flags, int *hugetlb
>>       struct page *p = pfn_to_page(pfn);
>>       struct folio *folio;
>>       unsigned long page_flags;
>> +    bool samepg = false;
>>       bool migratable_cleared = false;
>>       *hugetlb = 1;
>>   retry:
>> -    res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
>> +    res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared, 
>> &samepg);
>>       if (res == 2) { /* fallback to normal page handling */
>>           *hugetlb = 0;
>>           return 0;
>> @@ -2027,7 +2028,10 @@ static int try_memory_failure_hugetlb(unsigned 
>> long pfn, int flags, int *hugetlb
>>               folio = page_folio(p);
>>               res = kill_accessing_process(current, folio_pfn(folio), 
>> flags);
>>           }
>> -        action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>> +        if (samepg)
>> +            action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>> +        else
>> +            action_result(pfn, MF_MSG_HUGE, MF_FAILED);
> 
> Can't we somehow return that result from 
> get_huge_page_for_hwpoison() ... folio_set_hugetlb_hwpoison() 
> differently? E.g., return an enum instead of "-EHWPOISON" or magic value 
> "2".

This is an option. The existing return codes are as follow.
__get_huge_page_for_hwpoison():
  * Return values:
  *   0             - free hugepage
  *   1             - in-use hugepage
  *   2             - not a hugepage
  *   -EBUSY        - the hugepage is busy (try to retry)
  *   -EHWPOISON    - the hugepage is already hwpoisoned

folio_set_hugetlb_hwpoison()
returns
	0:		folio was not poisoned before
	-EHWPOISON:	folio was poisoned before

To get rid of 'samepg', how about

__get_huge_page_for_hwpoison():
  * Return values:
  *   0             - free hugepage
  *   1             - in-use hugepage
  *   2             - not a hugepage
  *   3		   - the hugepage is already hwpoisoned in different page
  *   4  	   - the hugepage is already hwpoisoned in the same page
  *   -EBUSY        - the hugepage is busy (try to retry)

folio_set_hugetlb_hwpoison()
returns
	0:		folio was not poisoned before
	1:	        folio was poisoned before in different page
	2:	        folio was poisoned before in the same page

The whole point about identifying the same page is so that the re-poison
event is not doubled counted.

> 
> "samepg" is petty much unreadable. Same with what?
> 
> What you really mean is "page was already hwpoisoned".
> 

For example, a previously poison-free hugetlb folio is detected that its 
3rd tail page is poisoned, MF handler marks the folio as poisoned and
record the 3rd tail.  Sometime later, the same hugetlb folio again is 
detected being poisoned, this time, the poisoned page might be the 3rd 
tail page(indicated by 'samepg' = true) in which case the MF handler 
does not update the stats. Or, the poisoned page might be a new tail 
page, say the 7th tail, in which case, the MF handler records the 7th 
tail, and update the user-visible stats.

I have struggled a bit about the naming, wondering whether "repoison" 
might work better, or, a longer name like "same-page-repoisoned"?

> In an enum you might be better able to describe the various scenarios.
> 

Thanks!

-jane


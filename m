Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBFEC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4A36B00DC; Tue,  4 Aug 2026 16:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56886B00DD; Tue,  4 Aug 2026 16:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF776B00DF; Tue,  4 Aug 2026 16:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2576B00DC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:21:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 111891A01B9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:21:49 +0000 (UTC)
X-FDA: 85064707938.30.B32C631
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7DAB68000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:21:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W4FSTPP7;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yz+859f8;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785874905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fU5dRl58e4XQKMbWR1h7VqmdV8YtUTmoyDX1x0xH4A=;
	b=BBMfUPcPEp7ONW9hpkYYgnngYEBDIrnZQi24Y+QrqscoBc+nncLsAeQ09Y6xr7YPtZEcIb
	a680k+QVwlQ8o5mbt2p8Za5Gey5AQpjIfQEoAza2KNPBvxy3fJcZD/NaaesMgUWd/ZxYRE
	CW3Lha6VS0EKoU5bP7GhV1yliU3hI6E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W4FSTPP7;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yz+859f8;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785874905;
	b=p/ENyTmXcYz1g1I8y2jzS9alGXWD3n/Km+I2uBoeIvGnKdsoXzjtDW2O+zIr8lcJGNB4gd
	v0OsFQfoXWTbIZxqJvGq/DWEj95Fuhp6rAQGNz8HSgTSGRWd1kkyhZYvwjYBHzabLDfWu1
	nv88ggWekxrQfziGtvSlNsjewXuPMos=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674Fu3tS1392913;
	Tue, 4 Aug 2026 20:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1fU5dRl58e4XQKMbWR1h7VqmdV8YtUTmoyDX1x0xH4A=; b=
	W4FSTPP7E0V+T+vBoCIZzx7PuoNqOyuB5g/uDI/5RG8yfwfP82coQBj6+UYQ3I1a
	rNrbFmwA2CwG4EyeyakPHRBk/TAeujGfj48/wXfBDE/0eHrwKkkxfKqcXqXdOnax
	7/jEqd2xJfuRVDGIi+irRmaSuZSk4n7aIa8rslHXP2HS/gsxPdREPec3AseXD+c9
	0zhHbc2GrGCoII9+B131Vil9UMLbstWfDN8WqgHDH0YzoU8Tfe5YuZ+efkDk+sbp
	Uj1xgabDW79P/H0ceCAQVFmbPVq2d6obnu0iUVvhz+AUnZo8l3caJutUg+Dp7c38
	nij6SXMNLnOcqE9f6DZKRA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs9bt6a5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 20:21:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 674KKi7N032747;
	Tue, 4 Aug 2026 20:21:29 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78ue775-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 20:21:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCR8iqoVZMzI4PGF54aTRf7A/9QifqF1+vcpFBxZpCCWOge/AB960CbbLst2IqTlLsJYDWZEwnS/GibW9lZXIdR466Jbihr9OxRPAAxlJnHZd3AIagijp5CBuM5Wm1RxxR04jEevWoz9Q9HkDv36UEHQbKIuUfWnYKhBcaL9WVqntt5rADJlwYWmLjdkQ7iUXnNnXd81vk0evB88JFC3ZJc0UjXmoeat+HIzRBOqf6hzXqQGGNukI4XgMyDqjLNfiU5q+MpqMfWv1ontJL4J0nDR18yATMYlJTN6WUQBLcgx0ZDvX2QVkxRDC7HJnrK2Vk6zROpgmhbpirYWdp+j/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/eUbMDJ0ZW01OwNHcgUAPb5ZTbCWNx6reB7wzS71PM=;
 b=Tycku1cj3DYsg46y5aeE7kgMKhef2WVwKnrCpXC2JxbOU9x+J4knMvKIGgx897f/PUMEgf4Xd3wr1OIEbOQAK/6bqLjYTltDq4ZtAlXDwL3fFx1tDDJgNkNbZMredwGq21wHd7edKnTfKd1WeDtuG6iIH5Ao6YhoDBJOcd0J0QIIV6S+dAG+WeAecOnx4NyN0uA3krU5TCX0gx+eOBHrMPFzXCC1tdICQVzTCuUkZ2iLSLO+udcefic65Gh1H1o+U/Fqowrs2iIXoQAA6gOCKXTH+0YPQHC8VbYgLoGaDwYTH8hZINmiHBeHLk8cyaYb0rLQbwnk88vnfyrkJ9EiRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/eUbMDJ0ZW01OwNHcgUAPb5ZTbCWNx6reB7wzS71PM=;
 b=yz+859f8CsvjZyKBBGRvjlVQGvxy5tF3CapQNoqZHztPhaYn3sGavKn8hbnxnCQMAuOq6C5d257VgX38HEsdodq1AYEPQw/Mn54623d4BehTNihDSFgB1Qixbx3xVU4QbJtZdPswHe3ACyvIZwUDP+F4IHw2sXmTcoqyZmRnlfw=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 PH7PR10MB7105.namprd10.prod.outlook.com (2603:10b6:510:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Tue, 4 Aug
 2026 20:21:22 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0292.013; Tue, 4 Aug 2026
 20:21:22 +0000
Message-ID: <89180cde-f637-48db-9a82-f8b0753d852a@oracle.com>
Date: Tue, 4 Aug 2026 13:21:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Jiaqi Yan <jiaqiyan@google.com>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-7-willy@infradead.org>
 <7a72bcaa-06ed-4485-954b-2376f754eebd@oracle.com>
 <anIJaPXquzQrnCdK@casper.infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <anIJaPXquzQrnCdK@casper.infradead.org>
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|PH7PR10MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 870608f5-1d03-4145-c406-08def265f340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	sgJholBiuHSkQsbjmH+dYKB5rjusAzEAtHpQ8Dqymw9PblzsTh159nRiRT1XfMcmNHYwGBk59ZnUNU3Vcs1f3vcoVQUSKZcnONqeJEtcYOUvKR4FP2MfmYnwiILhx+RKxO7UnA7yxvGNobUOoaqxJ9wda8e0/fnrX4rt1a8paqWZhxTIrjl1oDSRbBZEvoCe08Ja5ztXdia/PidNwXuuHMkw64r55crfdJ/Kbvlf1i23RrCHm/aJVGyUowGSfRG2Bs4x7e0kUEYuyXT8A29Aqpc+BWszTBS3YylF/Q5DdhAx804/mmQ+qlU49KYu9NaDUP9ekl8ToWpvvNI2IJkctdcQuGb9B2y32XTWIc3a4mx354iSF7FNzzfE+7exmkzg1bYViUewPUw/pd1ChgP3YXTOVrp0GLURWVSigX3rzsD2mveXmVQmVimqrfTmVQhNbIkiZVaLrLfShS4VCLtlp6B447VhGEI7cGGCiZmvr4S7CFCXRqnMV9ImjlaW6iWiyMnWx63fl3q/bL6/89cJHCKArpJEzzsZsIcZySZxCy0+oBKxDbz/D6kjkMVPi+1ObKL8wptx7ATY8JTAnChAHl8Mr+ONUAeRmzMGKyli9gy6O1fCXImzcMgzrAibOONU6iFPswMtcZKQGJPlUmahGNuE6XBRHjz9dpyiFAYFJ/s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bG1kcnFnYVJXN3c4WDZVYmdNWVlQSStiOGx0bnZxdDdQOStPZFVDVldQdDNL?=
 =?utf-8?B?UHNLT0VDUVZEcDB0WFZ5UjloOE9sNXlTajhRL2czcllDT3dQcGhxckpUc3FV?=
 =?utf-8?B?U3ZJU0hzK1BnYkJYSWV2cnpPYTVOWTBNRkcwa3JVRFVScDlQVklCa0RyNk53?=
 =?utf-8?B?UHBsbHJXTEU4YjFUaU94VHNMSVVHZEpXN3ovRHlBR0JHMnpLb29OYWQ0UDFZ?=
 =?utf-8?B?dnhZTkZrSHNOUSs3V3pTQW56YzY5aEpkaFZoenpta0VxUXhla1F2d1VRakp1?=
 =?utf-8?B?dDF0bjMxc2hrVU4rMzBrOUI1MVRBUlRJcGE1Uy8rWjNkNldwN0RPemh0amVY?=
 =?utf-8?B?U2dFT1NxU2pCLzQ0NC9MUXpCWkJna2hWbGJyUE5zOGNTRXBnb2RzSnc3VXBJ?=
 =?utf-8?B?OVhvMG9nT2xoeThUWW9FN2xESTR1b2FWdTVYRDhNbkxBSWtpWUJ3T1BFVHZr?=
 =?utf-8?B?SFV6TjFMMFUzYm43ZVB6MlBsYXlMOEZlUTQ1MXF3Z2xOYXRsSVNiR0FvM2tO?=
 =?utf-8?B?bjRkZWlIbmZrWVVXNzFzZ1doS2JYZEFNT2tjblBCUXFxSVFCenhMcitJWmRU?=
 =?utf-8?B?VmR3b3AxN3RkQ0l0aER0eTlnVGJlcG9ONFQzb3J3Z1diUW1IL05KdXluNjhL?=
 =?utf-8?B?bWpmdGk4UGVQTVdPUEdsaTMxbWx3aXVNQWR2T0N4YkFyYlZjUXZCa2o5eDFL?=
 =?utf-8?B?R2doOG4wcXVvNHlZaDE5cGFwdmdjTTlKNm05TmVPOHYyYzNOTUpuSHgzYUJj?=
 =?utf-8?B?cU5sUzdhVTl3UkVxUlVYVUE5akhZb2xDT1dDTnJtVkxtajZ1WGw0WFdLSTVa?=
 =?utf-8?B?VmpScXFiZkMwRm5RcGJ4MnRGZGxJc3RIU1pxTGFjYmhiclZHWmJLbUdUUVBV?=
 =?utf-8?B?YmdZNTFDZGp3WXVHQ2NwZGlCRDE4dlRxdlU2YWlwSndoVlg5Q0hiZVVrQjZZ?=
 =?utf-8?B?MDhZTFVHRFpnN0xVSlIzYWt5blJSQnF0S2N6M1hQYm9IeG9CRUlpdm93OWp0?=
 =?utf-8?B?YnhoSnYvSXRGckpOUWRaazA2ZGVKRVM5V0Z1bk9XMGwyL2NzRWZWc0R3djdL?=
 =?utf-8?B?TVFGbXZzUlhmdlQ5QUxwcnEzeVZTVEhMYTBESWZ6YnNNdkxIeTUvcUY3elBi?=
 =?utf-8?B?T1hlK2x3N3FlamxnbTdjend0TGgzMnBaUnRsaFhYQlFvUm5aM05DblVDbk1F?=
 =?utf-8?B?OXhsYnBKK3FSelRWQWNMa0ZhdVRzNzdscHdyWlNOR2xwTFplTmdYb2JzUTY1?=
 =?utf-8?B?Uk1sRzdaREY4S0JmMFA5VWdMSVFEaHF4NkVsVXI0Z0hCV1QvODZVMzUvV0dy?=
 =?utf-8?B?bUJvUHhXNk42RGUxYXdXNFRDbW1WQnNqcUk3TEdRUWxCN1lSVnZUbEpOQ1lx?=
 =?utf-8?B?Z0JvcjNLM0RIOXEwZzBuMmR4TitSZitDbE5tRXZlUFk2YVdaNWJjMkwrbjV3?=
 =?utf-8?B?TG1GS29YZ3pGQ2VSQXROZ1J2NU56cVJOcHFYYnRNUHlZeWtoQUFYbFVZMTJO?=
 =?utf-8?B?aEIrT3BUUEVkMGZzZW94ZkZDU3pScXcxMzRES2FvRi9LK3I2c2tDeFJTbjZU?=
 =?utf-8?B?ZW9IRnk2MzFlK0hjNGxsVVJqc3BtL3k2aFhmUnZ1L1hqZVRiZEpOMHhEYU1D?=
 =?utf-8?B?dnd2ZU9WejZWWEU3UkNnSG1SYTRHdkYxS2UxU2NOZzY1ZmZpeWtJU3J4bjJh?=
 =?utf-8?B?bkNXVmwrMWtGdDR2NjdFb2dVeVhIT0V4NDVKSlNGZ2dtMmJvTXF0Wm8vS0hs?=
 =?utf-8?B?bFkzN0ZkNldOK2ZqY0ttcmFZVEE0TXBsbHJTRStMSXc3R3hLcDU0UEluOHJL?=
 =?utf-8?B?RWpjUTc1UUF6eUlpblVoanR6ZTk4R1U2TlpSQm5xQUY3ejArWkxwaXFxZExq?=
 =?utf-8?B?MzlrM2hVeWM4Q3RGaDZCb0FveG5IS1hqVlVlV1NiaWpLNnVFb3hjTytLb1ZD?=
 =?utf-8?B?c0xucWVOVjhVY09iWWt2V1FWTHcrSFlPbDkwRGZhZzEveVloWUoxNUViaVFQ?=
 =?utf-8?B?WjNEZ1JZeXlrUTJ6N3puR2hVZk1GMmNLcmhCaHN2OG5idE0vZ1ZRMnk3aUc3?=
 =?utf-8?B?STlqS09yWVFLY1AzMG94V0xXWmtNcHZNSzFkTmxlTjBERVg5citUN0Q3bFgr?=
 =?utf-8?B?Wll4L2QzK3QramNWMXNSSE5zZmhkT1ZSeFhia2c5bVFrbWdITE9CcDJBNDkr?=
 =?utf-8?B?aDBNV3hnM3RjVmpob3Q4WTRxMkJoL0VseEsrMjh4ZkxYM1lYTWxTbWcrUThm?=
 =?utf-8?B?UFE0MFpzWDAvTUNGRS9EVlBNaXVHemoxYjZHSlNxN2pveit5QTlaUDZBUFU5?=
 =?utf-8?B?dnZzVGJiR01YNFovYlVqdEhEeHlQdTlWM043WE1tbm8zU1BJNHBOQT09?=
X-Exchange-RoutingPolicyChecked:
	B9paA/e6Zu/yvZk2SNE/TwZGsdmYACHLI5Z8ISSZzsOVPUNltyLJ7uqKcivpesFBcXldcw5SpgzI2DPSvsyQxiSH6JoaHoyur5q0FYtXa6lUDbohuKVowB0T8D98dZrCQ37D95fu+Z+6ezIEQmGSStrhUtbzhO4xlxXXQ8QphLLRPYWhu5yoifYh8qKskIFoXeI7Gi4t3ZyDRBgp4TES54ejYpeBk13IQRhxqyZehrCuw+DDM1KPWyTwZAawP447i/lhmKbs/BF98SI5Fb3vAzK4VMR89eVrJSOE6oM5aPWR/tEc0fKewjqLhBZ/1dX5YCWcAY6vnG20MmosOwG22Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RpjZsQ2jXtV3DqvR1I4MSpRkbk1Dt6gHRhzdMfHTm1RMnvrH9NFtZOZWEKX9+SgTPKoTXU4z6VidF8y2gG4bRdA0Oldiv06WdcDDr+tnP1Ij/Bb9LKubRWRdFUlOXLpQRNZlHuQLPEId7Z/asKfnQfGI6ewWAhQHQ2aookHp1UeonrHvR973AnSLceQNzvOI1MaloFtSvQpBzJoFHvbvzPA86bDpoxsc1rXJmggma/uOzWtc7UHd5XJeqsj6BCKicOLRpW6F0LcUOF6McHnc4AObjgedOmf27JJ07Nv47jp/Y77mUPD0QokR9i64gJdo9dqwnW/mXqo1C4bEiDcB9iRgxUoqHLuep4LVdPmcYS0p9Rtyh8nnZs+CaVDD+nzXtMc4f0TBNz3JDfTmPgDV3ZCjRGreZ2P2TUKMWGO6/WyRfoCofUofK3I8hp24wNnNX4wFAnvzNZK2Ogm4/DHw5uzJ+qzROhQHzzzDxUiw33rfuX3lJtf2ETWAHDz0DRCc5tXfeqvs+SE6IE6qWsTLnL3rfvcmXCbBicokKyoaRXpeCb3k76DbEPO1K+Ky2JVxA0qY4GBTb3brL2JmO2+XNppCD0OZ80AWxIC1Fmq1pfM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870608f5-1d03-4145-c406-08def265f340
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 20:21:22.1493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJlhfJ30dPpxWOqs3A878hNMM328IzZly0nE3x+1Ke+GPtPo4crndtH26nYWJq/kseUVUil+xPMt/gYXNODxzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_05,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608040164
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE2NCBTYWx0ZWRfX5phqr04KKBCp
 ZVbQ7EETysTTtah7t3Gv8fFLHKZ1ICS78M3SHElQAD90rgeYaFNJ3en4vWrVH1SDCBOEsxmFr3S
 wP92okghmMgbrrQfJl8jRIaSgYfweIzFZJAOrutTgRnTXRM/3kHljprJkAVQR9x8cDCGZtliteu
 c0Ko70QKsh8SpPFSCg5mta9bMCS1IpK5eMhh8z18BbzLXf7U2f8S9+9+uziRZ0a0JbzpWJrQQiZ
 /t3iTqDtMj5671u7fgIRvdVCFxDl910y8CkR7UOiEeVE2uAoSg8/X9kwoieocIq0F70uwyThc4x
 FMIe3ah8kHsANiMp7mdOly5k2R3qZ2QpHAqnPoQ3LVPD7fBg89EygT+Zu4xKgfMDyqcI+9mgh4h
 MMrkDQ+6rVKmjZw4SSyQ+eonCuouuBJxCKW4BDWKeUdt7KsW75xkRWtcjA+Oo8mcvvqCNEikj37
 HN6h8aoayxMxxh/Kt6Sg1Sfiv9lmW7x/3NbonXlY=
X-Proofpoint-ORIG-GUID: 95fjKyaCHN0h-EhAMugPmtZApBHE2bBi
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE2NCBTYWx0ZWRfXwdIi3X54AHQj
 FNWEUmFj3sigUtIhHwlGd+p7rqaMQTjwv522j/kSfzUovD0MKughO+hEszBctpuUe4YzEEJ2rkt
 wTHo7s4AlxMa9cUAbuVPbCSBCdHQEqfMbj/aSADxYjAF1WyBUWmR
X-Authority-Analysis: v=2.4 cv=ZOTnX37b c=1 sm=1 tr=0 ts=6a7249ca b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=RpNjiQI2AAAA:8
 a=yPCof4ZbAAAA:8 a=LlYQg72hSJEtsmc9uGIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-GUID: 95fjKyaCHN0h-EhAMugPmtZApBHE2bBi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DAB68000C
X-Stat-Signature: 55xcquiqxnymdopwah67nq7apbkkewa7
X-HE-Tag: 1785874905-404828
X-HE-Meta: U2FsdGVkX188x+v/z1Cn8rOyUGRNABS9fA4Mo7kjJU1377rreCcPxOzHmqQpZwdvt9vT4IioYaLrVAzWLDNK/+ZBN5dC6cK0QHtIlVy3cq+U2KU3Ee6J8MYITl0a1XHvuxgktqnmbfWmplhuZSWS5mIOfLPU4cQV4Nt6bzoOEukYY9xbw/feVZUvc1ZOLAo8eoLtTrmHACpnDPynyOOmZCv43pVf3rjf2AJ/o2/PqsdVwnHx9M9gsljJqyRJL46kjVmDyMk38S0atowZxdzj3z2Ut4+ykcgbFxXEumD51dEX68xrRWKy1fVeNd/umattzjk1BEDf6DmJ0+gviLFV04zMWt4YYRsz2USauWzDWOSzCMhul1GzWcOxFsxHQKWG/GF8cKElHxcvaVjoNCulGs4a1lbhGckLzbY2ydVDc+Nqll1nOxwInyjI4UtYPIPLG2xC1RSvhL2/A7dQ0/lL4Fv+k53tVvYmSycXuKAU2Uie9Vwmz0WZQbzXbRTU2BAM4Drgs1PsCburd9f2hLL3R1wiscV3AUbnYeXYkeUWAvwn6X8Q52865mcmmFlH19tHcJQy3/4bUiqWqV9DkGHqNZRWwsL5OgWgkaLRVstrBPVnKCxil5db705LuM/1KhuKcAEWBCdLTW/03GtuCdViJFC2cc6II7CCJRRjbTJGrkHMWTspFLs3RrJmBfSF7H5WQHT8vAkGDpYtG9g71xARhzZ3NZ7MrD7XFpY9SbaP3VZ0VE/tDAZML6afGAXmfoUDCM85nyaUgLQsroXjoF4FHxtwfsSIvC3P18huANFq5gunmTqt1FYGRjhSrSKvwL40gZVg0oxFCBAPj1shbCpOOfNV4ipBRZ8cyPPZocSkYkJo0BBKv9R4Id9ZWMcw98xM6yoGLoVWW+EJryLEsMrOGVc2iy3Q2dVWJ8ysly/3G4VR1PbcfnmyvcXqRgz+kxFziO61ipPyOUu5AipqEvP
 9REUoCUj
 CfeNy0Oc9F9Jb7Yue13QsWLQmD3auXZi7lWgKwqtSfc8tcrGXIuGfk1dslWcmPttdu20gbiaXVJS/2Zoo+JFmMx2zrh9y20n0eyhROZQjdFjBtSiel6ivDE2taANx6OoVArgZqiwNnEaIUUz24DAbuYk7hloXK63bQhlBbKJJfwNa2Xg7WW2HlcBPI+4YYXaAgIVw4zGY0RfTNDNQPKL4WP+YV1+fd7wNELNP1BK7IsvKCKfBEDQQsjD3ELouNAHbyexinLQTukKLXB7AAMPFsuXfmdMUqWUsKDzZWTc3OA7v1WKpOTLVv/MTIsuaKCE/szuft28r4E+4uS7bjGPjEyeKgzH3VGpHn2Tr6v/n7cD2u4lMDq2FQIm8b3jqtQICghSxu4LawtQnnP2i1W6Z5QsmvKs7aW9tFizPfaN0X8coATNF92X/Mr+jpVyeMWlKwon+TdtNehl49J+di96RTcAaFI9Yj9aZ4yhbTsHnJ+1o3rM1hFpcia57FJCZjvKtcH2a1s0hM9rSKdsJX4d7u44WSwLR5RK+VYXRlKwJH1yAt+/MSwnapYfDIdOBeWpdY7I/d4nA5w6cvqDEPkiyinNuYnG2WeYkF8YA/p9cyzR5d/ZnGcHr8jD2ZavSkh85b/yVpESlx1J9g7rZqWBBu6gmQvCYT6EbZhMHAAExYZ9nrdsEN4pCP4zwkVkGmUc3br+/+2rWe0/bfGGLq1SxKFMX+SQnWRNVO96/EJ+N5imu/vpRf4fkMh8+lozzs1ZeShaeQHc6fYY/DwSBm/3zon+nfW3soJlkY24tuKDI9QgYPJCaMP4uYHutPJMl0Mpi8eQrk0oH5H2XVLfewUfMGpWGcfDCHqk2q4RAkk/XiicUIf2Lx+1LHhpN2xN+fKQSPHp+SiWOgkbYnemYoJO9j1Dfs1DH3FPraW1GyzaT/GpOGLh7LUJYGf7cKwrLKhrFkq5L54Aipfk2gbhHjrFNzUpHEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/2026 8:46 AM, Matthew Wilcox wrote:
> On Mon, Aug 03, 2026 at 11:=E2=80=8A44:=E2=80=8A28PM -0700, jane.=E2=80=
=8Achu@=E2=80=8Aoracle.=E2=80=8Acom=20
> wrote: > Good idea, but agreed with Sushiko about the bit setting issue,=
=20
>  > with that fixed, > > Reviewed-by: Jane Chu <jane.=E2=80=8Achu@=E2=80=
=8Aoracle.=E2=80=8Acom>=20
> Thanks. That's the only
>=20
>=20
> On Mon, Aug 03, 2026 at 11:44:28PM -0700, jane.chu@oracle.com wrote:
>> Good idea, but agreed with Sushiko about the bit setting issue,
>> with that fixed,
>>=20
>> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>=20
> Thanks.  That's the only diff I have between v8 and v9  at this point:
>=20
>          if (is_page_hwpoison(page))
> -               u |=3D KPF_HWPOISON;
> +               u |=3D 1 << KPF_HWPOISON;
>=20
>=20

Looks good.

Thanks!
-jane


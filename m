Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC865C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923376B00A5; Wed,  6 Aug 2025 14:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAB96B00A7; Wed,  6 Aug 2025 14:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C27E6B00A8; Wed,  6 Aug 2025 14:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8D36B00A5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:17:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2236C13643C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:17:08 +0000 (UTC)
X-FDA: 83747139336.19.1AD6DC3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2B1B100007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:17:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O7CC5jrC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i1qJe1/p";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754504224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BU1CAYxvPgZ5IwN5C7WGebp9CfkdtxEdXdszs4aCi4s=;
	b=uZNzHzfw2hz9eWq1pL0+aBbBaW6OS7lKc3+eijiq+s9o9/9FA4NrNL2j6l9ObK8mAko+Wv
	MXi3m7uJlBj3FuuU447vSGTg3Sur0Uen2fTdYEq8vepG2UH756V1Sn6qKe/c9qS57YGkkD
	t8m7JytAlcdwlZn9hTKhkkZxRg6Kvkw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754504224; a=rsa-sha256;
	cv=pass;
	b=sFoFKvsYGBHXnBn+/IfVn7ETyuE0M0aIPr2WrAB8bCROTxl/1IF1bTBctQjPCAgHU8mj0Y
	jDEhhUeFnVtV0Ayqah4yNcKlm8TZCklDtmuQssp796gB03bw1N12uY5XhVMeqRSyxUsdjU
	d3SCLi01XAH7zbXoeh1zNu72uapt99s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O7CC5jrC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="i1qJe1/p";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRONT025015;
	Wed, 6 Aug 2025 18:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BU1CAYxvPgZ5IwN5C7WGebp9CfkdtxEdXdszs4aCi4s=; b=
	O7CC5jrC6BqazPSE5ZGb7kf4lqB0cPRPXHVQBbVgpwxFYn2Nup8gyXDFAhGi0znc
	rusCmUBSPoajOPTA4AowgqoD6c/oatlplIDBtWHwgIF6/gYwMed6Q1ShntTKSa/n
	AjRvZfepWGQfgVEYJacewFCfzaRV3S4VMuSXiFnwM3pwkFEQEiP6zw4OvkpI0mrU
	03uaAsC/PmyWBf5sOONbBRAjDR45IfyY+e5lvA/SkJ6rMQcaYJm1XfMLnzp6gtKs
	FW8zKmPBBqjTF+2vq75KqpKs2KhrjK4Yv1zj+ietkaR5dRaLytMGbWYv9GNGMSaX
	1qE8R3uni5ypNSgH0WXjdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve2byu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 18:16:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576Gj68Y018535;
	Wed, 6 Aug 2025 18:16:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwrcver-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 18:16:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4BLCjBiCgdD/svAp4B+I6okAXtdsRhMPcBYrA5EIo93s4HTIauBcovTIUvRqG/oIwmWDqpcC4PI2ZnlkmHxyXTIs8ziV1YaWTEGkGS9Cy+QIPkz5xg+Yj035Cy1lkPjCVWZZR+q1l1envFXj6n9oyXiN95Jiu59gnsv96Wn3cyty/YA+ldAFU4lf5FVdBD0U0H8pZTpiY2wOCQ6HiSDgqMGk3+rU6JBvDWTZnCanT5Gj0vhO2oTnojYtSsUUgLajZ151b/f40kocuNE521egbSI4Suhxlibl85ZzoPyHyQloMQ6lzSKHJAeLQcaiXD2bebUq6oB/ndkXYjHTMuHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BU1CAYxvPgZ5IwN5C7WGebp9CfkdtxEdXdszs4aCi4s=;
 b=nHQ+fGjwxfXjdK+bmHQGeN6unjBsiaNBstM7YsCJm8Q/Ulv5z0kfe0SujHR50S1xO/L2geDuIzBjgoq7cSRZtcrIMDd8osgjs/aANvq2CZhUX54O0oZ04JDrclI36PNIvPpM01MD9BvP32WBw5aldwoqy+uGBDFJ9HFaJk9VaZbKvFrTHmxva8G3cNRKwXzZWBPJ0GdjM2C1O0j5QoX9XoFPmk0/vIQA6urhQ9hLML/BsnZBBoqapgCTpu2/Te8hOy+umww5R/Pwl11b9hLU4KbFlYhX1nlmY2YEghj3n3aoeVb3lGfi6kOgekENKw3VwSOfWzmoq514t13RTL3rzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU1CAYxvPgZ5IwN5C7WGebp9CfkdtxEdXdszs4aCi4s=;
 b=i1qJe1/p0LBF53HilpPkeeKj0gbH++ilr9edvVOFtOHR78kATbunBNmoM2wH8X3HJTRmf4ZJcVbJguUfLmpMui0VZzyTctqOzviygTzmRGWuP6YJsopDSzTqmGu5cV2GC95oV5ehX4266EyeHyolaH5y3ykdxVo1a+du7rZCbQs=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH0PR10MB5114.namprd10.prod.outlook.com (2603:10b6:610:dd::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Wed, 6 Aug 2025 18:16:53 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 18:16:53 +0000
Message-ID: <cae1633c-3cdc-41ac-9da7-327ffa010609@oracle.com>
Date: Wed, 6 Aug 2025 11:16:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
 <920efb15-581e-4efb-be74-088113bf2035@oracle.com>
 <a8a8c674-6f8b-4aa9-befe-7ccdc66307b6@oracle.com>
 <04d3e3c0-3b22-4d47-b183-6382a8e5c74d@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <04d3e3c0-3b22-4d47-b183-6382a8e5c74d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:217::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH0PR10MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: ac663229-6a64-4cb8-c688-08ddd5156b81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmZFWjFvVzZ2NlN6ekppUkxiMGQrMWpiVWZzMWErbGE0Si9LSTk1K2FPL0hC?=
 =?utf-8?B?WW9mKzhNVU1jVkJkZUJPRzdBdjJTb1Y1Q2tmTGFsVUFLb2l4S1Zxa0RjQmdt?=
 =?utf-8?B?RDRobjFjeXVaRGRoejF6U1RKZlFjbDZWTGlCeis4SHlOV2s5SGhFM0xyaGR4?=
 =?utf-8?B?cE0vcSttK3dRblhlTzJCaFlqTVRvc0ZJMjhjMzdlOXdHVWZ0Q2ExU0xRank0?=
 =?utf-8?B?aTVWaUEzeEF3dHFMYkVBd25pMEE4WTNmckhkYnU0b2szRDVNdEZRblVncnlr?=
 =?utf-8?B?NmVwWEJpY3RZWUdKYnZBdHdBVVhaeGJYeSt0Tjk5UFpsU2VJamtZQ0R5a2Vi?=
 =?utf-8?B?UTRBM0g1TC9qVFl1eG5KcGI1OHVENytqVS9NZWRIdXZqN25rQnk4Y21PVWZU?=
 =?utf-8?B?RjBTRFg4enhhSlg5TlRrRmJhZGU2WDN0TndFbzJraVRSMWZIaFVuN0piditz?=
 =?utf-8?B?djdkVGRCbzBnc050bHFlcXdoVDRxYVA3L3J4cTA0bHUyTkVWN2U0OTJFM1Qx?=
 =?utf-8?B?UnhKa0l2cklIM2IxV2JIeVlHeHFHbVhEdDB3WDNaVUVLV3VhVXAwRFdVb2xx?=
 =?utf-8?B?SEtvMkhBaGMyc1dZa3JRVFZiMkk3TVhteTEvQmN4WTQ2NmhTS0JKZDJxVTVj?=
 =?utf-8?B?cndxWG5CVWd2Y1picWN0NUlpMlZCWVExMWIzNlEvdzBySTlkZEJHcm0vYjND?=
 =?utf-8?B?UXpoMWYrZG1USDBiR3NWRDNvcmYzMW5PTTFCRG1DaW8xaGlXTlhPZnQ4Q2Vl?=
 =?utf-8?B?NitWNW9vLzExcllpTjFmM1J6TWcydVhSS29OOERLN2NhQ0wvMmMvWFMvYlp1?=
 =?utf-8?B?bzNzNG91d2FaM1VOakc1SnJ0MVRYd0pNbGtpMS9WWkJWNG8zOGlEeE15cUhX?=
 =?utf-8?B?ZFoyWUtQdStRdFhCSjJwZ3BsWk05bzRzSFNFS3hYRGtXdTVBUFZyTElPcVNW?=
 =?utf-8?B?RWpYeVN3R1ZmRlFqVDVqM0F4OFNlWExTUEpwMTJHcEdWcFVleFJRb3Z6Wkgv?=
 =?utf-8?B?OE9iemxCQUJXaEpLTFVwMjhYT2ZlRGxZOVZ0SHFyMjloUkxjanZNbGEvKzky?=
 =?utf-8?B?R2lzL3p0RHJ4bnUvRGkyd1A5NWhMQUJnRThMejQ0V2lyVXZkbmpUUjNuQXQ3?=
 =?utf-8?B?dDVDdHVNbWdGYlZGMko3aGhPa3NQeUtRcEZFK2lGUDJZMWYzaFZMZlliWHRJ?=
 =?utf-8?B?d3NMMmRtNW54Si9lVXRJcVdIeXBzMUFhcUlRaWFRNVpOMW11ZXZENkw5SlYv?=
 =?utf-8?B?TVBGNVJNZ1R5M3JyRktZMTJLNno1MmxtdTVTOXYrWnk0MVRldWp4VWRXTTd0?=
 =?utf-8?B?bnpyWGVKMnY3YzFLYmxMdlZtelBlWUZjSmx2UjUrazhzbEQ5a3dTWVAzS29Y?=
 =?utf-8?B?S2pzdHh3djhQODJBMDZQam9hb3FkREowNVY3NGJ1STNPbmlTOU91VG9nZWJp?=
 =?utf-8?B?WTVqc1RGcGFLek8vVlpTaG9qMDJLWTNhczIvMWhUNitNc3Iyb0xMQWQzMmhM?=
 =?utf-8?B?OXl2ZGxPZ2c0bjBMNHQrMVdSQ2tlaWRROFZDU3E4S3RtTWJvOVRIdTNkdHgx?=
 =?utf-8?B?NDNYWWJnYVZPekJNZnNXdjhLMFh4aEhXQThuK2VOaXlwM2tUaDQ0MG53d3A3?=
 =?utf-8?B?M3VtQTV2dlYrbkhMTkpxeENaWXBWR2Y3ajkrYTljQmlFRzkxak9LaTIzZEZ3?=
 =?utf-8?B?Q21aMElsbHVXRER6V1B1cGZJbThSajN6ekY1R2xQMUZMeW5LVm14R0Fqak1L?=
 =?utf-8?B?NVVNQThRTHVNRllKQzgyTWJXdGIzQytrTHFxdU56TTNLeWhyYkdMcU1YMG9Y?=
 =?utf-8?B?M2k0cHJrQzRZR3VFbURaeGxZMFVVUWxFWXpKUFFqU3ZaeTNRdXNIb05yZml1?=
 =?utf-8?B?TXZwcEVGK3czVnhaL3ZTQVBoTk41N0UzaWVSaDlMcHlDOVV3cThaWEUra1Z5?=
 =?utf-8?Q?YQtqkit9P/I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU5JSVZzcHRJV1NvOGkrUm5qNFNMWGlEdnFobVZhMWhuTTdOSS9DcWlmbFB5?=
 =?utf-8?B?N2lEUmxBMWtMUDVSWjF4ZXQxQVoreGhxa2dpRm9BZkYrK3crbzZhODRuZE1h?=
 =?utf-8?B?WFRpSEJlV1p0U2lHSFdxeHkxRlFWazRVaVlsc1JoMUZLRkhxM0UvUHhPVFJy?=
 =?utf-8?B?eVc4MU5QakhvTTIrOWU5MnRCYW9FZ3R2N1hhV00wYlZvL1k1VWF3Um9HYTFN?=
 =?utf-8?B?NGE3TGswcm5HTXJ0eE54cVhwSFZpZFAweVpEV09pSEtyNmZ2NXlkUmc2VTlQ?=
 =?utf-8?B?ZVdoaXFES2xGZU5kUWkrTk1SZEdrYTJNNDhzbS9INVFaRmZmaHBWdUxQK080?=
 =?utf-8?B?eGxsaE1WaWlaUmNNSUdBK2tkc3FNWFc4OFlJTHFjU2NtNDVWRmh3RCtlanEw?=
 =?utf-8?B?blVmZm9ZSFltVkhGNElhUlBBemZ5R0NlMEgvLytXRUh6UTZJSThONXFuemlW?=
 =?utf-8?B?THk5ZWVyaTN6S0JjZUNYNlk1Vnd0bklXQllocC83Si9wSUlLU1pjcG5EV2FG?=
 =?utf-8?B?TjBmNWwwbmw0VnZMNVloejlxTmNBUHN4OFQ0cEtUVzRkVkpTMVVOWmp5VFFo?=
 =?utf-8?B?QTg1aUVVOFJYcWFFRGpDZVk1OHFXUmlKQXlJZ2NWejRoQWZ5U0c0N0xiSlFW?=
 =?utf-8?B?RHM0djI0ajg4eWdtc0VqdzBLSWZpZmtxR1FuT0pmU1NSbEJ3MTlOZ21zYjA1?=
 =?utf-8?B?clVUVkJMKzB3VmpqaEN5bERpUGVUMGNLZ0VUUXE5RzNGWnJ0MWRWcXRSajJr?=
 =?utf-8?B?Tko5UEVuUnR0Vm82Z01RdkhVTzZvdzVIc0dXYWp1SkNYMGRmeVVtVGlNLzd0?=
 =?utf-8?B?QS8rSjBjZkZLY0p3SXRsY3RDK3NCRHd0ejA5Nm1zRmxFMWNkSFp1M2NGcExz?=
 =?utf-8?B?OFFDVGJod0VvZjJKT0FVY1ppTHZaUjF3MmJ2cWQxbWRTTE8rSHFkdDJvSFVk?=
 =?utf-8?B?bkU1TzZuV0J4L1REdjhJckROM0dmTzQrVEhxQjUwdG53TitqRkdaTG5FKy8r?=
 =?utf-8?B?S0RPcnVnR1o5YWxZdkp5WUh4dkhvUnV1Sm1WZ0hqeXoycGRpaDQ2R0pvTmN4?=
 =?utf-8?B?N213KzhvSFJpNlJYRGQ5emxMT1JocExsaHVDbU1YNXdQM0wraEY1cDFqWHoz?=
 =?utf-8?B?VC93OEdUR3hQcSttUFpsYXVwcWhjZXU0b3BaV3RLUC9UT3JMbC9leWJ5ZTVr?=
 =?utf-8?B?Rk5Mc0d3ODcyTmpuRkltRk9UNitXaElGUzFZc2d3d1Y4d1BnL3l0WXc2UXUz?=
 =?utf-8?B?U0NHNXFDd2JWRllGMlBOa0R0T3NDdFoyekhMSmtKWDJ4WXNuQVh6SGJwbitz?=
 =?utf-8?B?ZW9GYmNTQmJWcUVsZm9SZHh1ZzcyOXlaSzY1MXFMeUhkQUp2eFkrSkk1bkcy?=
 =?utf-8?B?anlBa0dzQmFQbjZGektoSUYzT3hvb0xJdjdyWC9QTlBrYmxjZklZbnUzalNB?=
 =?utf-8?B?clRyRUdKcXM5NVdhMC9sTk5Fai9QZnVxRjYvNWRDOUZ5Z0xVWmZVNktqWEgw?=
 =?utf-8?B?d0lET25RVXgwV28vTW9FVThVVzdpQWNaZTU2WnZITFpyK2poWVRYc0U5cjIy?=
 =?utf-8?B?bGY5N3Qxa2x2eWE5ZzFQbGhUSjltcktGZ25iNVVubi81RFErRUtTeTJlUHdB?=
 =?utf-8?B?K1NDUWFDRmJtOTgwZHVKZlRvY3ZGUzVzYWkxV0oxSmNINjdVc29OZ0lyTTBm?=
 =?utf-8?B?cWRSNHhLajEwMXFrVGZzNTl4V2lmOU5jN1RYaHV1c05WUjdnbFU3Y1VaTHNN?=
 =?utf-8?B?SHI0NVVZR2F0MFpNNlBKckRiSTJGWlFINGpkMVVJT2svUVc5SWc5Wk9mTzdx?=
 =?utf-8?B?dUJibVYzTmtYRW9rSHBNZk1HUXdvZ045Wm5hZTZSaGRjamdIZUIvSmFoVFJk?=
 =?utf-8?B?cm8yRmlXSGk1YzI2QVFEdW1reVRCVEVrazB3MWc0aEFNeVpkeGtzZjY0QkhC?=
 =?utf-8?B?azAyV3hzR0NNdVFPUmlpalhPUC9vQmpCTVFRdUpPTkhDUkZ5YW9EMEF4TEVw?=
 =?utf-8?B?SnhhY3gwazhVN3B0YjRIYitLREIvYm8ybks2dkZKWjE0eWdicU9iblhJcnhU?=
 =?utf-8?B?NnAvTXR3WC9CK1Q0SDZDN21tVWdCcVV0RG1sNDBYaE9VSDM5M1cvQ1JsMGJH?=
 =?utf-8?Q?DUvq429PzkH7uUbVmWfalK/5h?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5FTuMlapFHX8Dc8fjqMT7n7Xz7WjRgTZy7+1UNXxndaDqrfppWAdl+1L664iDlwJrwFggXh34bo5IQLc8OJG7vX472CJAXsyTDMpnzeor45awhYUbaIiAsU9D+nyJ+zFfmb2CBlhksbVX12059TkE6FlgCCdmmUoMF7+/HObrJMiE4y1znUBglcF8BfOiUZOaveLRqXi30Io0u1cSzDt6+wso4dtEqaatSCGsqJUYRlE+oLQ3BCMPIWi8DEw2LTZeBOQo0fopgxBPpQ/IJBDVXaYt42oTDEqtb/Ejmw0FUIMPO7ANCua3xj1tfArjEVKZyM7O2Gi9dSvyyGlSHHa8SRnjf2hUvHr/+lC3TsiQHI3UdenMBBy9hURn5yH0qngza7NVVXFidSKsVAQSQsNTWBs9pFHWFA/MyarH7u1honC8nLcp4RxkLCFfosvOmfSMlBR/l/5C24rXt1QYeP+FIDgq9tDPfemRw0ygZyKx5MIoH28HXblHRgEHQpbkTbt/IDe6hS5uK6lw82RyGbpGcBJLdOkR13lT5ynxpswiKZzJ50iKjaj6CGwxdTamXTqduarLd4OWPfbRobBPJYwOom4QYa12jAaZy58dMF6KdU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac663229-6a64-4cb8-c688-08ddd5156b81
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:16:53.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv3ZuDHlcioqKVtuo6COMCeSpgj/jR2wf8TW0k9LD1RC9FZJWjJ+4j2NqP+jF21a4KwkxzUk+qNRfpjbT4NWRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060120
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEyMCBTYWx0ZWRfX8s3N6cIR0BB3
 n6cs6ZWzHAKUtQFCQn2EbYUiZgFqs5hb7Ybw992RvW9rKSLA19vJSFqF63KstYsC38JeaK/zYQx
 wSVE/67QqgZlUZ189elGy7YbLdMSJrS47RC4N/reH4PeFf2NOMcNIFB3MQx9RjHT9b/fzj0s6MG
 O3kc/N2lrfjSDb0gTi9U2PkHs4zddOxRMNUFd+Wde67TCUaN8M9dXleG/oMtFZlQUNwflmjp+A9
 Unh3CnpC7ivk6975BNJGXLqMELGmHUW+rmbF68swvlq9TXr95ZYQLvjD2+PbkP3oLifVBh6ZN/J
 erN41XSSILlpl9y/OTxWC/4X8WiNkjkJ1cuugufLWjvAdrqv2SN6BpPrHmOkA3E1L54axseT9r6
 I1fhsNXtBG+obuYT6fVxJdcipNq8z7s6HbZ8e2cUeM60Ydq2EJlUGtA6NXgcujw5YDweW3YX
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=68939c18 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8
 a=llF1VXmokOWsEJz3VdgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12070
X-Proofpoint-ORIG-GUID: Ul9Ixl_fI14OkmAzqZ0usgqlHZyFaIME
X-Proofpoint-GUID: Ul9Ixl_fI14OkmAzqZ0usgqlHZyFaIME
X-Rspamd-Queue-Id: A2B1B100007
X-Stat-Signature: 3stxdqzo8jyh34jqpkgf3dou8shcyra7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754504224-105966
X-HE-Meta: U2FsdGVkX18zAtHkLChinXcc+ZCVe1vMPRxaODi0Y2DFDb48EqBhHvBcRED3K1SFQjdp0jrBSV2cFGeDp1ouUrHL7ISKg7t+rZww4F9pq9ob63JYvkymLamcR+QpHNl9QEiZienuCbn+bI7cLRBumsXCnvTH+eT6S29K8xi/AFZAgMTj2R0R+LJCiimHcPWJ32oXYPbPQ3QrReHe8UGtcqX9ZTJsP2C9Sh9LHa3neq2o7qHjEnuvnjfafjdDdW6k3O3NuIQe+mleiAtkU6nCjD2lV+W97+J0b/d2/Z5hDqP4TZIwyZElMQ/PW//Cbsv8NNs9ZbmgD1kYeQrD8i/GBLhtHVnvOesrfB1xar4i5RaBXV/PiPrpSjg45gX5yYeBJ7C0FOqRh2jZ3W3Sw0p1Po/+1eOdzP6LsdYUskuLHqtmJeyvnvXVuImIAgpT2QmbBie1KdFNAuQ9lyPCcmtuuo98vYP13esbjdBNUBhz+ZJY8yFnoYeZJBSG2Vp3DZV+5X71BqmbjUimEAEsFYCAm8O/WbtiHFuSZMw9kOf2dTVpEGB4AfRGsBi8aEeGv/tB7AaFtRhOpmFWbopR1LN6a7xmQBfHRfLaYD9N5IHdUr+/5cy/KRaVL/vHKJdzGJcgYfg+41AL1LvcMH9bVskZmOP2nm+9oHqzpd32wcWV5LKfUWar2ulCe7g4aCvOxsMLsuOezTQGXuQlqWx9CHoJaC9iuPO1NorJIoqZBRZnPNcqzbpyM3kv25WdXNy2jNlz7+5tA8t1WQpNxNCH4/MU1nBJKE3H5MDN1iCeZyInl77xdwtMXH/G9Aacc7sAQg6jaBROoTyxn33N/U0ybZEPDMU2R9Oz5U3BjTf8/7cNM5kjXnrOMNcvA4w4R1NIF+zr/0/JlWl36ptA2D5cW6O5mYmxsm7v/yVAwLO3cNGGLcAhkkkSzMy2G483GjcZcWus5PyXCrlixaD0Ql1d1yO
 xw9EEvoI
 IasMPDQEdsgbTmmCYc1nkOvpfga7C64bkTO68j9MdXfd7pfcPmksLWk/OpmTu/ZhAuKbGlrRo5prmDROspaTkJKZxJ4Zzle++l2KqavtwGL+Vhqq3jHKY15SVpeeVYlHB4WCaui6jeN95KcwAKa3/R3hPw7UGhcNkvnwKX+fa3XaoaYxzdaGr34OR+wkjBwVukRvPNY3w/ZogemxdJZfF1qNMvhd1DZf7OiWprnT3wyDB000vVdHHdwRh2VZVpVcBiYU+H8wB+1W/SLgtgkw5u9XVKiYb8RP/5fpBLQcbap7KlZmmrbwTVvQCkNjNSQfLztQUWYOxv66Dz326D9zu0tVYMqZjIL5ucbAOWSO2Tj8p3aQsvqVfzTursDqp7vhmwu0schglHJSHPUzRq8doAuyyjxfHEPDYoE/rq8rN9MQt3e29QvfBVHtFjMyvTXagCNd7NeitMw5SmMZ+olFdLJYNerGbVaQeSJeY/h4gEKq6305NQdW8JgQVu3NEHnxsy2ZZJmurAe+MEF8cy0KMWGOJJamNrW2k8Y6se+ckly1npvGe3BsHeXeAnTsmCvuNxCOkfbXV9DSLBPBSePLAXuBQP+zqnFMIZG/jBVd6iXWlwjaQGUK+PIapOl2o3lVoXsuXrVSf1C5i0Ixc+uHpMC9TpTZlRVjp4zZFg1ErOqZtPpNsGFLIBl3f/fZwZDLpSYw8QeVTjtT/TJz59U/QEFrv9E3Zht9ry7RVXjJZvZyM4ZxQd+ngn1VCdXOJva7HfDyyBh3g5FBpuCtX7xNl5GPRv4g9xsq2UrCzOSzd9ieDqsJtzFCY7+9nth2kwylYQ0+JLPzlIIhZInqbaU4MMeRdz6INRP9B6kKtkBlGxMrlDYJX8JWP2DuCMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/2025 5:56 PM, Kefeng Wang wrote:
> 
> 
> On 2025/8/6 8:33, jane.chu@oracle.com wrote:
>>
>>
>> On 8/5/2025 3:18 PM, jane.chu@oracle.com wrote:
>>>
>>> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>>>> Now alloc_fresh_hugetlb_folio() is only called by
>>>> alloc_migrate_hugetlb_folio(), cleanup it by converting to
>>>> alloc_fresh_hugetlb_hvo_folio(), also simplify the
>>>> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
>>>> too which help us to remove prep_new_hugetlb_folio() and
>>>> __prep_new_hugetlb_folio().
>>>>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
> 
> ...
> 
>>> Thanks for trying to clean up the clunky names and eliminate a couple 
>>> not really needed helpers.
>>>
>>> The decision to do HVO is baked in __hugetlb_vmemmap_optimize_folio(),
>>> ultimately all hugetlb pages go thru 
>>> __hugetlb_vmemmap_optimize_folio(), so let's not to add on 'hvo' in 
>>> function name to indicate additional decision.
>>>
>>> The difference between only_alloc_fresh_hugetlb_folio() and
>>> alloc_fresh_hugetlb_folio() is that the latter invokes 
>>> __hugetlb_vmemmap_optimize_folio(), while the former is used for huge
>>> folio allocation in batch, and then 
>>> __hugetlb_vmemmap_optimize_folio() is applied to a list of folios 
>>> back to back.
>>>
>>> Therefore, to hopefully make the names sound a bit more natural,
>>> how about
>>>    s/only_alloc_fresh_hugetlb_folio/alloc_hugetlb_folio_pre/
>>>    s/alloc_fresh_hugetlb_folio/alloc_hugetlb_folio/
>>> dropping "fresh", how is newly allocated folio not fresh?
>>
>> MY bad, didn't notice that alloc_hugetlb_folio() is already in use for 
>> allocating hugetlb folio from the reservation pool.
>>
>> So, how about just
>>     s/only_alloc_fresh_hugetlb_folio/alloc_fresh_hugetlb_folio_pre/
>> while keep alloc_fresh_hugetlb_folio() as is?
>>
> 
> 
> Hi Oscar/Jane, thanks for your comments, what about
> 
> s/only_alloc_fresh_hugetlb_folio/__alloc_fresh_hugetlb_folio/
> alloc_fresh_hugetlb_folio
> 
> 

IMHO, the __alloc_fresh_hugetlb_folio naming style typically means it's 
the function that completes the real deal, while in comparison, the 
alloc_fresh_hugetlb_folio name sounds more like a front end. So that's 
not what we're having here.

That said, it's just naming, the patch itself is great.
I'll defer to Oscar.

thanks,
-jane

> Thanks.




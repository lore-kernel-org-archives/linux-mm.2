Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F462F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CEF6B008A; Mon, 13 Apr 2026 12:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5537F6B0092; Mon, 13 Apr 2026 12:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C046B0093; Mon, 13 Apr 2026 12:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2166B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:31:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1B251B71B0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:31:13 +0000 (UTC)
X-FDA: 84654072426.29.A6FE99A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 10FBE1C0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:31:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nBv6EEK5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OOCf+5xf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776097870; a=rsa-sha256;
	cv=pass;
	b=sNxJk2H+XIOpF0mxtNxgvav93Y9RlqxfMULiXLMYBr4Cbng7d6SJJl0P1Qu9afh4X0YFJG
	dI6dXkzUh0TCjqw+dzAzVJnLWJ28H06W6+vXh9sgC0KiYBOWmns53SXWe0SRTB5pRut8/I
	W7tdIiaab1wV4uvG2fSvtCqoN/58atY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nBv6EEK5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OOCf+5xf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776097870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3T+KSjr4Jycq1k4SaGrxzPt5Qx5TptjmtZElcFXeXs=;
	b=6l46d2BdM91/BSSTk+7TYseLcdvBajlWA64kYweJBH5Ph2l2iiWn7c+NhBR8O5SRNouz8q
	Z8PttWkTPKN+BOHzGtSafpLwS1w2Zk1GS/aDOLGN9h3KSi2nCuJrAxMhF9FbCuyyJs9TLc
	ap7BFd8RMJJ6QRJUNBsKdJJvAfuf0Y8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DDBSnk3896066;
	Mon, 13 Apr 2026 16:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w3T+KSjr4Jycq1k4SaGrxzPt5Qx5TptjmtZElcFXeXs=; b=
	nBv6EEK5Rfn0yT6OwuxWrqMzssxIc6GDWSOEARYm9nAW0vdI2JEF/pffHc2S5kh8
	OsUvb17PiuzeV7TIPDT4of+pXGgpxq1AmZCinxoN6ycWPhkhRPr/SSNkE4C1PGu7
	kedAfh6OtlVbO+I1ag87hwbIVgGtaVCLi0ZwJYk1QCErm6RKMNjCySL2fa0epSmM
	z08SZHpc8UjTqZrOlt19pqmpB9byKkpbyIdqQ+9RcJofGCFfzGct6f+7rSBy7Ymd
	tPhBAbGyeU38TootUKO72kBnw6Y6PTXn1PfadFSWuxmYmvzpENAG60XefzOnbry1
	DDofVxY7T5zRsUAdCHptHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dfe68kdyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 16:31:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63DGTXa0011198;
	Mon, 13 Apr 2026 16:31:02 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dgbse41ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 16:31:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YopmAPwnFi4vVz2dAR8NLjbrLUtf4ojtAMg3rwSU5t2acQVUc5t9NLD8gC/YMVKcEikF4LV5GF3GIlfDtTpT3lL3Z5+32l60RyCSZwUwStFjvWfiFg95DKLuZ4Aq1NLSCCBt6SPbUoAmHTIOhQMtkE3Byhx6R1DdE34ylC6kCOTtxKhurkT+73+c+CMUrpEct1kak34vjKdc1QLIjNzfvHiRwOAcBmAPtvlA6kRtJYJjQUg5Q771GGs2k3RniMHJ9NU9umAgW7gYGuJ8W0ZW279qRRlU0yu0PhZIqiDEy14XImzT0x0ZHOwY66r/3+P0IiDWzdR0I0S36PrN3ze9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3T+KSjr4Jycq1k4SaGrxzPt5Qx5TptjmtZElcFXeXs=;
 b=htitPUIDUVmOU28z71mUiU2FAvtb1PkJovUokO6IwDp6EUyvuW6TYe6FQ7OBSCVFQzv8riT/uWj6UHkWDZ+jqrMKOhpPGm2S54W1SBv6DHVfBbLE6jv9OtkGPGXIshGPrbo7hbq3n/PL+dETkts8QcjVgVjkUWUWjMz3nseUiiJ5Sz98fC0z0SbrBY6GGNCLWx1MWwcnv9mMWuh98khhwjAh4hVAxkBZqBBW1YUw0klwcHklsg25X8PS7C5yQJ3vaSDc33s6VI20DSr1pOKb8fFz2D8okOUOIe/AZv62RVOInrL3jVFEvNozRFjIloEfApjnS10GiXMCea2xLlIZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3T+KSjr4Jycq1k4SaGrxzPt5Qx5TptjmtZElcFXeXs=;
 b=OOCf+5xfhRyieC7g6CO07sAnaJmgnX+0VIzstKmvfWziE7d6Hv6OeqFhlxbv7EAUGkWWXDhvthxFAmCFxlnsN/8qWqRPjgc2V0CtQaIWrwhSraj9GB0GDcdgCLeOkAaVE7NCBP2WQ851n5vN82+TNveh8wckjQMh+bj3nmRRK9A=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 BY5PR10MB4227.namprd10.prod.outlook.com (2603:10b6:a03:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 16:30:56 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 16:30:56 +0000
Message-ID: <1f2d40f0-7b7c-44f2-9545-2c3c93b3d03c@oracle.com>
Date: Mon, 13 Apr 2026 09:30:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
 <ad0YVH4EVzi62yML@localhost.localdomain>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ad0YVH4EVzi62yML@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P221CA0088.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::20) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|BY5PR10MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: 57185b66-d950-44b6-0357-08de997a0972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	duV5iNOvOTFD+KyKmD+RGM/gwzSs3WDhfvCU3vW1F5mTE6rlio9UhDbY8nVF0AuEhDpVLGGNklz8qmq2P9is/OyXD/Oq5r4cx6a0m0AwfbFF/rcmBm22RoRMa4bV2qL0KFYAXW8hZKTCssQMfuiwTwfTqD12T5FiK/YFJFXDI8EMkSIFKhpLKnqe84j0IhkDlI5VX8fLm4y1SpZDPMvaDa+jjyO12BXE3FME3N18QNcgwW1pg08NVLJvNRYIQ8NbWMMQmEsoOYvccENLKVpIUoJSLbfLa1GXP60PUJwF9pRZXaNqKpygCtoIlVSBYPDVnOlJOrD3F2VfwPrHM1wjvXyn5VCP6MCr5Ohf9G4Wh2Zupz9I/lBgC0W9/cKDzZ4NPs6s6ZK34nAvc9JZbn8Hvrd7CKDvAQfgmAgUYLLyF6lTj3mlxv6lIuxZCJeIxRkzG7IfjVh6JTfOzPvOno297KS+6UI6ajgiHa2VHe51L8OqlQnnK+6WQwMXp8KiKLLIwTBHW8m2a2rOi1CqnF3G6wb7iDA5sNSXRW8Yb64TlKarCxqIB133kuSAiHmUi1ijqyRTsmJTrTn6OkcChPI4OluSpA/EJUXP1+EdLorNDzNnaNVescyxySE+UO3GmT0nmY3+MTf8XVb3JWiA5Y2v+ZB9Ujsd1zp42PEVC1Gv5HAgMXE57NMrBP+zovyWUhsF0gvNgBn3WnSVYkOPeu25GSGs3aGZv/wLVV8QrbwQJhk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnZHbFpqVE1oUU1JYVhSVnp5SXpyR0JyaEVjVE1Hdmt2TzI0cVpoZ0dseSsy?=
 =?utf-8?B?MndxTnNZZGhXNS9TOFVOMEdMY0M2dVhnRmV1T3FaSWZqNGxvMmJZa1lnQTFL?=
 =?utf-8?B?aDlvcXdyNGNvK1pMNDNULzZJK2xMSVVibkhvSklCWFpkREgzbm5SN0VsTFVK?=
 =?utf-8?B?NmljUGYxS3cra1lxLzkyKyt1bXFmNlFWK01UUEFJTTdTUEI1TDQ4L3dnWEVm?=
 =?utf-8?B?OHNFWjhTZ3NFcmxoNE4yVWxOUHRpYzNHejVVTlMyTm5Rd2hEd1M5S1psZW9U?=
 =?utf-8?B?bjZlR1UyM0tiMkZ6ZE9WcGtyZS81dG9VbFkxZzFVTTJsK2t6b3h0RTdQcGhx?=
 =?utf-8?B?c1VaUXdtejRjNDBhVDZHTDgwU3QwVHFUTzQrbzVGNUhKNTFlU1pIUmZiTnU2?=
 =?utf-8?B?TUIwSWdaOGdhUy9WZ2dndE5vWTBYRTNBQnZJTmRkWHQ1b2E5UHNCRHZROTlp?=
 =?utf-8?B?andIditEbWxweWFPZ0s3U0p2Y0VWWTgvM3hkNS9pTjcxMTFrcGg2TVhTbDRY?=
 =?utf-8?B?MzRUeGwyUk9RVDJyeXVNZEREb1A5ajllZEtFQ2pScVU4ZU5XUTh4a0tDREJR?=
 =?utf-8?B?bmtaNmo4OGVGUHMzTGRFTm8yY2hCWTB6eFpQUzlQRWRDQ0xtbHF0d3UwTHJL?=
 =?utf-8?B?QU1CWnhxNzNYb2YvZ3JzSnJFblA2NjZGNkFmcDlBWUt4TUJBYnFmOHBqdXpu?=
 =?utf-8?B?TnNRYWRNS2NWZ25yRk8xTnlrbms5VTR5cDJTS21wYkNkK1M3cDhmbmhWbUNz?=
 =?utf-8?B?Rmt4YUNtY3JlUXNyL3FUVVh0R1JQeVhsV043MWxhQ3IvL015V2lYSHZNcTZN?=
 =?utf-8?B?WTV0dGtYZ1F3a3BNY0VlSENWck9HU1JjSFdNdlRxQW9NbGo4Rk5YVThhRktJ?=
 =?utf-8?B?R0huOVMrQzNYUmd6SHNQVFBIclN4Vk1DSG1vWk5LRWkwZVdYaEZoT0p5OUlh?=
 =?utf-8?B?eHFVQkllQlBHVUNJeS9tRzZOdFhJMmh2czRqSHg0YU1ySlR5WU8vdjJsQisx?=
 =?utf-8?B?d3U0TTBxaUxDRUU1aDk4cUZFR0lsVUV1R01MRmJvYU1oSXF0YVJhSE1tNVc4?=
 =?utf-8?B?eXhWZFd0eGw2V0pzQ2JwbmQ1d0dSOGRrU0thUWlGd3dPald5ODUrYmZpSlhr?=
 =?utf-8?B?cDdSQ1RmSWFJS3Q2Tlp3cXZ6TUNtQXNERjljNVdxdFNtV2NHTXZQWThtWDlR?=
 =?utf-8?B?OG5wTW9KQnhVOUNRbGw0RGxNZFVQU0dtclpYZXVKdTZsc243ZnNxNUJPbUNr?=
 =?utf-8?B?YlB6ZjE3MDRmQStGZFRVOUt1dS9BUDR4UkkzR1VwM09ldGN6dWhqZXk1L2I4?=
 =?utf-8?B?VFIzNzNxQmZvbmwxRnpQU29mNStMVWZyTkZLZ1pObzV0dDhXb1krVXUzSkkz?=
 =?utf-8?B?LzE2T3NQMVcyM2NNZVJxekh1M3gvUjlZcDM2dlh2U0xSTVFqeXV0bHdMTW91?=
 =?utf-8?B?QThuVHRtQkpBWjRDcHpVeVprTUw1d2NxbHM3M0lUUnJZdENSVlB0cVoyY0Jp?=
 =?utf-8?B?NFVadWJXSzB0NzNTZzJVbGdEbGxFdUdKaUpIdmJlQUJIQkRlR3pzZkhmdktG?=
 =?utf-8?B?UU9sT05ZcVB5VGI4bkpSVzV5UzhkeFJPa3ZtOFo2T1lRRWxXdm5KTEI1T1FP?=
 =?utf-8?B?VTUvT1BNUTh5UnVOQnc4MW9jODR0MjdlQTI5aVZ1LzF3V1lkc3F6MTZFbjlM?=
 =?utf-8?B?ZTBwWGlJQ1FDVGVsSGYyL3BGV3Q0NmZJaEVPVDc0YjB4WUtNZ2hTQldNQll1?=
 =?utf-8?B?aXhYVlRST01ZQklma0V3V0hiKzBJN0U5b3NqUE5TeTdLWkJSbUJaQVVWY0U2?=
 =?utf-8?B?NzJjVHlMN21rbmJVUHc1cFg1S3pIYmN1ODhOMzBaZkJpdlQ5V011dHpKcWR0?=
 =?utf-8?B?TjBkVHNqcFFBY3BvUnNLSlEvSjRuWlRaL1IzejA3Um1WUmdOazhBS0hwZG1t?=
 =?utf-8?B?Yis2SlV2cmQ3QitLNlN1RTlIYUFjVTlORUVTdjVSTVVaRFZNWGtZU1NsY0VH?=
 =?utf-8?B?VTcyTE11YlNJUWZ3VTZtYUhxbHZKNjh3UnJ0Wm5MS3lOMUFBZFZXZENBK2lZ?=
 =?utf-8?B?WE9PWEp1NCtQaXFBQkE3bHZJbEEvL0tvczg2UjViUjByeXV2T0xqb0p2TFFl?=
 =?utf-8?B?N3I4S1hmd0hCa3BzTExsNWhkZHVrbGVmSEkzanorZ0p0MWM4MWFWWmVwZWpt?=
 =?utf-8?B?ZnlxamNRbzAvM2lVek1GK3pRRjUvYWhVa0dIYmNJT1ZzZHlLdDR6d3pOR3Fj?=
 =?utf-8?B?VEhnNjVYczc4RnJlMmw0UFJmeWltMllqWmMrT1I3Q05HUzZwaW9UdHVIeDh5?=
 =?utf-8?B?VmFscXdXTW1SSHp6cFBNMDBhKzRUYmNSNlEyNzE2NWRucEliVERNQT09?=
X-Exchange-RoutingPolicyChecked:
	GXuZ++y+fQyS05s8Y7MPyRxjhB7qSYZcJjQKP3QqduOLz77S0rAss84FQLraUMSELdFUFXGghcZTEcZFJh5lNglzTpW195gDOn+U+UmIL/nsekyUjBxgAF5Z01mT28VQlK9iQ9U0uJPmm6AfgY4xYTbhXWYftMEbpjME0nMsC/3ZJ6D7l3ac1RKxPEeTaEt2RkbIhsnmtj/qULhZAKPBJIeUyPO7EKyM/jmOm+77ic3eqjES4QEy8WUykz1QsB0s67A9y6d0AIm6kg4F0xeOCSUs6CQZQppm0eFTJkDXR4ddxH0/OH5/U3aOAnP/FZjnA5uNC8MYP8DYFpXu2bJd+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NpfvIcAEKzW2vcPCNOlaEswCcJG8R9mRtif1/sSCM4oWHasnocQEMUel4LsL7pTTBlV8qMcnJ8Bte/ZYKN/dMpXXEIMRqWSOhyrkWWGspDRH48GOCuXZR8kzcA7rDG3CgryYUWynRKDsT4sw4me1VNL9GJjeqYXtBL/wUnjVkobVCvaRcQRtydD5N5/jKu4VCfsxNobaGT7hsY8vTCjccPCU2DndmZbUJAZpzWy8Wh7fTdRHYvu0R2P4I+d7hfIsKHIYemaiLzjStT4bCtHBzAMU3k2ZVZtslz/9pjjnQXBzXjrGb+sVxyY+YSwQibUWUoIeYrH/739eUZRHUenyWJ56uOGCs4saXab91MIiPrAvXVGsVx7gMhov2ypm+xUCW/gaCN/G+0L5PBENxvZnBoIs9FIpxOO81n6uQe4s/wceu9Iu/0bkO9WyCheVkJ3xQaFkweq+TtxcIObADx5af4lJBqNuNYyAeTNVUTX7Rrw8n/Ste62A7uMeUpTpaNvxwjlAAYB5Oye02WXNReH7KmX3HNjtRBa4FwiKm0J9SQp428LKyUOW7jb8/PsajQOS0QCzcdl/nJMMxYrGqfxJGHIoGU/hdO4Qg1PxICYLaro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57185b66-d950-44b6-0357-08de997a0972
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 16:30:55.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcZYtXEoVV1KqZdR92BK+VTui5GIVKHoJt5+L046fSUXFo4oK5gKbaL4u8B8w5OLFZwtvUoudBWW6TayIcdjuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604010000
 definitions=main-2604130162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDE2MiBTYWx0ZWRfXw/8Gy3lJBquz
 S838+UCsHunSoDQ65qUh4TcS5Qr92yTx21NeWbaGJfHzCHKZWBOqCVN75XQv1VYD+tgfVCSjHrU
 H/TTKgnGJagvJwSvKAQQyGkfjMci5ZsEFE7of4EabYZqB96Cb+yShO28U1oaND9MPr+6xbbkRpV
 ASMP9Lr7qjYMEOO9PEmcH2xhaOyg6GgfO5XSVDrKsoMc9oTCShsI405Ee3CcgYPLWGWF5QB+EOM
 pxEgaEsJzJtJm7ayIEsgfP0zkM1ugQGL+lq7YJYGKNDRZF4V6ey1NeZhcXGq73xt6e6PfenuR5R
 1z47CDrhnP6pRL9rjEjfgFgniXYxb+g1ec5eCzo++Z2rTMpHz5aJIKOmMtg9PoUNXVo9+gaCj9U
 QNuODc/N1dbO2EA6yJE1mcD0Od2HMEP5ayKk76IYhIFVrdyMO+YWSCB6LFhVPg54mS4QCg5vTpK
 8IRlD6hVs2LXrK8BvldmBkEIuWGe9l8xZc3xKVkU=
X-Proofpoint-ORIG-GUID: As4CLWYOa_Ql15JFtGDkWtQ7EKVJ7Trl
X-Authority-Analysis: v=2.4 cv=Q/TiJY2a c=1 sm=1 tr=0 ts=69dd1a47 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=iiYXnXobPXXOPB1X1KoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13825
X-Proofpoint-GUID: As4CLWYOa_Ql15JFtGDkWtQ7EKVJ7Trl
X-Stat-Signature: csjpe1wiypx4ga9mbdwadsqpmun5jkcs
X-Rspamd-Queue-Id: 10FBE1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776097869-446129
X-HE-Meta: U2FsdGVkX197pv9fv8sKY9fZNoe4NAtr0UqXAC9pLU/MlZKCQ9zbn5GKOUvbnnq0mSZL5evEm4cwXIsXTIwThB6cxZRGkjxlgmpCrYAtmCV0wTe78QCN3qSOaKa9WGuv4jmYblb9HNVcYJeGP9ZKgVEaHlGnnY0VWvZZBAdJ/+3m8YdGjpxbJkchd6z0WILysbExTjUXa2VNe6b/R+hO7MeOuZHIsBIvFUjQJWW/4KeRBLuyu0v0ELO7J4CNb2BmEjnX+oUdcRmiuMFdpEZfAIqsKNYyX7uyyurWC0Ejj/rpBVIWsWFe71LKur2rrBy0/S2IpJjL4vCU4AoyFslkYRHn86wuMpaImX0MZ7vRQAHUhDj0oeUw1xF18Es4CsUQg+09VHqaGpdiHPn6CrRkTN7FxTcp287ghBElvfTnjskONzUlk9HrzjYHS9Hzw9rIxA6GIVJ81a6kf9z/qBaFUplhnEitkIBnScTEBfxBmsjCsA2UVgnv8PlHE0DmnWisP5eWiOfWvW0tzbR0CdJIiBZV9YyuwFtu8dRqG6u2HZa1uliHhzxbRYeVQtBTzny2CY66FvkJlLuxthc+NhJUa2ZQQOKz2icvJPbhfyMgIAbfbrbIB7imfzOZ0GH7A5Zq73u3jtYLbDcxvRqYhYGFVFk4SAqulP9EkzSwosMuxQ3R5LrHGkFa46SJFKAIAM74wByWO2yF0FWBS84KXCu3FMkFCHsN+C1f/7xwdealbf9CtGe2EZZgBQ4RDuL8dTINkz0cEaDn2Piw/fC8gVTwk+XuvQo6HNLx5AyMrkHgl0i+vNx9H814fubFjXaDTOrzINxfOm83WSAAaAH7hKxn4v/AUeCI7lRXCE3jvXRcr1kAaKw9Y7yqin0v15gZhJeVSdTC/Gs+yfhM0dprm9e4cGxwAAZbP8Qwl4bgjsj87muVjsrfO06FxheFDaiM7JTKSF8mvA8IjQ8BNN1/vnO
 eaFssleh
 KU0kNyer45uV+fLfn6+Tc2WYaC433TKmrggfy8kVbO05hebS1ccwg0knPR+B6AAHURQ8FznEtPUEjyiMLOYJldlhHf5CVHm8D5leAc6PqwFYqgFjH6m/PEpSdMBooiKamSSg3nRiOYYSO7ZnzpWCaFkJlQshc9LqmXumPguBbnFNgfrax/zb8KTz/5oHnLwbQAVEqIlEZDbzzATreArBIFZaUC977W/s9S+3AVT5NvYPRDXK7sTmxvVHkF809bVLO6qLRxSwFYriV89PE5gX+tbe0Pq64a47K6uWxKU0U2A5iAUCne4TUZSQAB1OaFk21gmFUQmSucU1UGcZfydSQuhX/5Ex0Q+Bp4GX3CBY1Th4FwQbe0TIpgmPuVnbgdudeS9JMFcD0/pOz1h9vdzqA/fbIw/TYgAbc+Cm8m3zzXGCL7ivqq/PQJYJ9RSfondsmaHSDQKnUTwHtq2EYClOC0hBF2/Yg6BrSUWemkIxfOlRWe3yLoWVvaxuqPD0j42Ump2018KJMzlkSlLb7nIiXomve7Eh4Fry2d9k1RLKvQmUWvSWYlBZw6LPmjNKUx/eWUsF3TSbWvgO2S+82ROgDCHUEWLDxl2eIvbGl/mOBPlJbikLV5tpz81U0UsJ5uDwIkvLyrykLFyHnR4Y1/UthKy9Lxytu9opuNaQEPAJvhvcmArLxCsHK8tGdDNVOvSvJvHwDEiRZFDZD8POYM6i+VNV2VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/2026 9:22 AM, Oscar Salvador wrote:
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
> 
> It kind of funny that most of the patch is s/index/idx noise.
> Checking mm/hugetlb* and fs/hugetlb/* we do have a mix of index/idx but
> I would say that idx predominates, so I am ok with going with that one.

Indeed the situation that both idx/index can represent both huge page 
index and base page index had led me intentionally memorize which is 
representing what in a given local context. I thought that to denote 
'index' to base page granularity and 'idx' to huge page granularity 
could relax the readers.

> 
> Acked-by: Oscar Salvador <osalvador@suse.de>

thanks,
-jane

> 
> 
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
>>   	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
>> -	unsigned long end_index;
>> +	unsigned long end_idx;
>>   	loff_t isize;
>>   	ssize_t retval = 0;
>>   
>> @@ -257,10 +257,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   		isize = i_size_read(inode);
>>   		if (!isize)
>>   			break;
>> -		end_index = (isize - 1) >> huge_page_shift(h);
>> -		if (index > end_index)
>> +		end_idx = (isize - 1) >> huge_page_shift(h);
>> +		if (idx > end_idx)
>>   			break;
>> -		if (index == end_index) {
>> +		if (idx == end_idx) {
>>   			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
>>   			if (nr <= offset)
>>   				break;
>> @@ -268,7 +268,7 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   		nr = nr - offset;
>>   
>>   		/* Find the folio */
>> -		folio = filemap_lock_hugetlb_folio(h, mapping, index);
>> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>>   		if (IS_ERR(folio)) {
>>   			/*
>>   			 * We have a HOLE, zero out the user-buffer for the
>> @@ -307,10 +307,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   				retval = -EFAULT;
>>   			break;
>>   		}
>> -		index += offset >> huge_page_shift(h);
>> +		idx += offset >> huge_page_shift(h);
>>   		offset &= ~huge_page_mask(h);
>>   	}
>> -	iocb->ki_pos = ((loff_t)index << huge_page_shift(h)) + offset;
>> +	iocb->ki_pos = ((loff_t)idx << huge_page_shift(h)) + offset;
>>   	return retval;
>>   }
>>   
>> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>>   					loff_t start,
>>   					loff_t end)
>>   {
>> -	pgoff_t idx = start >> huge_page_shift(h);
>> +	pgoff_t index = start >> PAGE_SHIFT;
>>   	struct folio *folio;
>>   
>> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
>> +	folio = filemap_lock_folio(mapping, index);
>>   	if (IS_ERR(folio))
>>   		return;
>>   
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 9c098a02a09e..c64c6e5e50f5 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -829,12 +829,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
>>   	return huge_page_size(h) / 512;
>>   }
>>   
>> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>> -				struct address_space *mapping, pgoff_t idx)
>> -{
>> -	return filemap_lock_folio(mapping, idx << huge_page_order(h));
>> -}
>> -
>>   #include <asm/hugetlb.h>
>>   
>>   #ifndef is_hugepage_only_range
>> @@ -1106,12 +1100,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
>>   	return NULL;
>>   }
>>   
>> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>> -				struct address_space *mapping, pgoff_t idx)
>> -{
>> -	return NULL;
>> -}
>> -
>>   static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
>>   						struct list_head *list)
>>   {
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index a786034ac95c..38b39eaf46cc 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5724,7 +5724,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>>   	 * before we get page_table_lock.
>>   	 */
>>   	new_folio = false;
>> -	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
>> +	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
>>   	if (IS_ERR(folio)) {
>>   		size = i_size_read(mapping->host) >> huge_page_shift(h);
>>   		if (vmf->pgoff >= size)
>> @@ -6208,7 +6208,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>>   
>>   	if (is_continue) {
>>   		ret = -EFAULT;
>> -		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
>> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>>   		if (IS_ERR(folio))
>>   			goto out;
>>   		folio_in_pagecache = true;
>> -- 
>> 2.43.5
>>
> 



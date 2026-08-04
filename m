Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE93C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7ABF6B00C4; Tue,  4 Aug 2026 17:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51EE6B00C5; Tue,  4 Aug 2026 17:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AF86B00C6; Tue,  4 Aug 2026 17:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 958016B00C4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:23:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 228631202EA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:23:22 +0000 (UTC)
X-FDA: 85064863044.29.7D5D028
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9169D40010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:23:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pxs5btcf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUgWTuNd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7OdX3BXBBFhcnO1nKbH3aUfT087vc+rokuUdBdYpjY=;
	b=V1NcQ7TxJBuThedetDRESUwHfd4g1o+RyuCQf2iHpGK8sFBGWz3kb+nXmMvSsOII1gHzWQ
	frsvejiYwc2O6e7WObB4DeHDiS9PiRBV5EehMXGO4gksLDCJVhoaatSblO9YLmP34YIMXM
	4YrwsK3a7monWgGcA5mQ6K31tXoxoeA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pxs5btcf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUgWTuNd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785878598;
	b=Ae8oqLRVDw4XU9jfvkggy8bLOuTqPUewMm8+g0QPiYjjDlH6ISHJ3aecjekQePH7tSvHyO
	CNMYOuDCNPIQ9COGPhXnEmiX35FrMzooLTEU8RlSGMmw2d0fRPkS5bEJwTE6+v0ZUQShwd
	tCv5n/2igx1KiHGXYHx2bq4OV1y5zWs=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674Fu4Q61438535;
	Tue, 4 Aug 2026 21:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y7OdX3BXBBFhcnO1nKbH3aUfT087vc+rokuUdBdYpjY=; b=
	Pxs5btcf24rT6cvWZsr53yaxt7Xdv1K+11/2+pk30OlndPi067cwvrap+ZSfLKmV
	+6y4XYbX+89CT8n+TA2co+W7jbOQ1ALBvAqCNjHyFOqez4wEiJWm4dfIRHuwRRuh
	z+WG1vZMZVHWiUVK2ZvT9h36J6V8Xly74fvrfdW7duDe0clmZ5zzHLOENLWtagdT
	Dmk7zzef/SzeET7kmFldAAGUrq6ufswWybONnGeTWTb5APVmKjxpMedfrnU6x7QH
	LLIhQ7aMngV/y7xp5no9mp7CVbJCzik57kGZ3qwoVdY0VUQd1UfrQHkvU2sCoULq
	qlxoOelJgvHAV8P+GTAeog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7k3ekvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 21:23:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 674LFWYR014440;
	Tue, 4 Aug 2026 21:23:03 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78ug02w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 21:23:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qkG9LAMEeQGNZUpjxAKweNEOWsT8ppPN5Pwuh43Cd6OVKQZw4j9zzog7bmoaj1naYbWOcb0OiRfHQduDqMNLEcHz/nck2wKTFXtqBi1U670j9+YrXRs9OwQTCM4bZ78T01PpnMp2uxlW9zwP7d0dI+gqV8cVaDHT2lGAGRF4FiGRqn7WNYILXN86lBqAc+aPjqx/lToHBliYGT5fUJ4NTzAs+AYYT6yGKRkPFtLPA3XyI6YdtptglJu1X9l6C9oS3rrG91fyREcg54CHcmbmrucTXSzkYpp30v5tjrxvC8Zja97ChhyqNDrzv0AssX18LzswisJsEnZnPm95KXUssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkxwoOYqzJKIzE9e46VbneezePC9ra+p3tzn7mhC85U=;
 b=MIQO4CgkYJ+XLbRM6GUKY2/e1PJW31WXHYRxLTMYsJj1gYe+f/iTw33K4tnxCwiTbvbpxUQzCGmPtmzDc6Pg7oBW87OzTUPNx9AFZoG8j5NQDqITFOvF8Q2RetZ0Hz1wnpcNqEoz3MzBzeKLDSJgtehmA6Gvd/ZofcpKA4M52Twd9NQX6IeFeQzmeEuaAb0fPhZ+iUop4l8dXMB03TCsE4M7Jfo3K0qMl0rPs1/G2IG2ZChWLZUyZueQyURP+q3R3xojOvI0bSVVkLq4L8Y/ghLCBLwRDyGNqd9T03rIhnskvGe5PGt/sKI9UwSIEQ33xe8XLJAyrRxB/ubRpCTEwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkxwoOYqzJKIzE9e46VbneezePC9ra+p3tzn7mhC85U=;
 b=GUgWTuNdAPWPS+bV+PUuZWwrSa7zU/XHD7qN1gAqoCqrHFNRFGnRzRKqTdlAN8NILO5cjL6orC6oTagTFmJBFezyxxAD3pI9NFhy04ziK7ZVGkIZetzfQCoj7td11MKXvj3k4ICdMQyhuRek1XwNoF6o5XaBL9+sYjs28mRVx7g=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DS7PR10MB5104.namprd10.prod.outlook.com (2603:10b6:5:3a1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.15; Tue, 4 Aug 2026 21:23:00 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0292.013; Tue, 4 Aug 2026
 21:23:00 +0000
Message-ID: <6447305b-253c-43c4-b8f0-e49d35b106b5@oracle.com>
Date: Tue, 4 Aug 2026 14:22:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/15] memory-failure: Prevent hugetlb freeing during
 unpoisoning
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Jiaqi Yan <jiaqiyan@google.com>,
        "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-3-willy@infradead.org>
 <2f5fb8e1-67bb-41ec-af8f-b4da60be4583@oracle.com>
 <anIGuLZ-x2pIb6mg@casper.infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <anIGuLZ-x2pIb6mg@casper.infradead.org>
X-ClientProxiedBy: BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::16) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DS7PR10MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 309ed62a-ffc0-4233-0571-08def26e8f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JyYe4O7PPzDtotcp/DBZkCbO5igyFaWaPZt8AHBeIHpLNjfJITUvT+cg6hkOBqLR0/Aj76ReULE94Oyi6hGViwWPWProyC1GeqwGlDBktUt8b+NxwfuSCuud4g9nfS18btyqCPULVWXex4cDtVdR8cDNnISs7nrLDiFtUUbA+43O5UoU5xdrEehxJcbOkZWoNd284JFW/vh7rm510eKk1wUQQwj89DVcyXMW0EacYPo801vLyKyV8tGcHFWuLY3rZh1GrF3ynIpE5u6YyywGMXYcR1Fm/CjwVv2sFsI2oijieIgZoMQ2MzOea2EIexzxfkGzj33R/eYfDbF9GVv4/Rm+DmCCesqL2ZZAlTLeC5ZWsjOWxTqTAT8rwD88j9A7kAscJx+zAhBT8D6NrzyW8wgxgrHtHLJtn+JmI+LTlJ65hEqK3ueWf9+zAn6G9fovoq0LIhBNxcE+W4peor8UAgXW6B31Cb30tpQbhLldYGE6nm2EdlXgFonDpUKEHzCnEEYG8fWkUKVYDWXp6/nMNiVLZKTFG6KPecoEUGJBaz8gc4V8TM8U+aYPfTsDr/exk+0BB92fyJ+5PQszi1j6ECxu3dtH5zsc+419DhoC+cRScxY28vxFcTtZZICZeNobblSTHSJPIaT8Bu0fMVLUL6X6+DYfhp4aLyNEonLF9+Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkREckpWLzk2MS9jR0RYbC9QckZwSXdvbkdNaUZWZkdFaENDU3FvaFQ0MWdt?=
 =?utf-8?B?Tm90THZvZE40TTRrVkY3eGZ5aDZYMVZJaSs0V0dla0o0REgyaFhPRkpsOEFV?=
 =?utf-8?B?R3VBWk1rK3Q5dG5HQTg1VW95UThwbFhzamZxcW9RQ2ZPRk5oSndmOWRFcjk3?=
 =?utf-8?B?ZlBxcFI1bzRtekI3UXFvNjh3clpZd0R0d09qVVIyZ1R4K201Q21uS0YxMG0r?=
 =?utf-8?B?Y2NoVzBtMEU2dEpSb2w2MUwwQVRwMmlTOGJOYStGcjJGeGp0N3pXZi8rdVhG?=
 =?utf-8?B?U3Jsc1hmMS9INjlsOWpVSVR4MUszUEFBdlRBV29YdEgxV2xPNlZ0dSsxcmMw?=
 =?utf-8?B?QWxFY1JWTkI2ODlwYXlOR1Q3b29Fc1hZV3NQZWN2MUNGbzVNcTRuMzFYVzhY?=
 =?utf-8?B?Z2dKYUtBS1RoSGhuMGprZk5PU0xoSUdSWjdxOWt3YjA2cWp3ZVNIeXFRVUF0?=
 =?utf-8?B?cjhTbFF6QTNiZjh2c3ZjR0JVbWxjcGE4VDJwblpVaENQL1JlenV2SmlIREU5?=
 =?utf-8?B?cWZFYU02dlN2TkVhenNiUzJTRFRCclN3RzBZVDgxRDR0dDdtaDFXdFFkM2ZY?=
 =?utf-8?B?cW9jZzRCbHJ5ZHRxK0Q3d1hEWmlWUmtBS3BmOFhWVFlFdWFHUlpEdXBXYWND?=
 =?utf-8?B?YzZZYUlRT1dkVE9XbndWbXhZdHVJd3hXOHUxMU9ZRXlUOUc5eCtEaHIwSmJS?=
 =?utf-8?B?YlhZOGFVT3Z6Ky9SQXBjOCtnb3BVTm5JN0hrSFhHazdzTk92My9qMDY1Nkk5?=
 =?utf-8?B?bUMzTFlBa09ETDk5TWNxTFBCUTlUd2lKYmN0WFJRZTQ1VFBidDhhWjFrcDVC?=
 =?utf-8?B?THNPN0xJLzMvMGNDSnhtN3JmZnY4aUptUUpCb0FBdnFCSlEveXZxUDFLYXdx?=
 =?utf-8?B?eTJJQTR5Z3hnVHkvQ3Fia2xpYWw5djMvZFgyZ2dXSXVsMi85NHRwZWQ3OTV3?=
 =?utf-8?B?ODZHSXh2WEpsa1NEM1JPRnZETmpZY0djOTMrVDZnL3VpMURYUXpkVC9kUVVm?=
 =?utf-8?B?R2g0dEgxaXFyYmhaajdaQlZac0hVNTdLUXpSUElzNkxFYVFuaURuYTRudlJX?=
 =?utf-8?B?NHJRQW5lNXBUTEx5ZjRKeFhWY1REMmV6MnRDRDQzUkx2S3NaSnh1MHR6bVRO?=
 =?utf-8?B?Uy81MUFSdnk5T3F4VkM5Y1JkMDQ0aVRXclNHUWdJT29hYVMrNENGZGR0NEJK?=
 =?utf-8?B?c0pEeFpXWlhPRkM4Y0hpRnFuQkZ6QUcydElyRVIrZUl4b1YyQ0s0OHA3ajhz?=
 =?utf-8?B?ZktoU1VqdVNrZHBwd0lIQ0RGMEp6bjUrdHBNcGtSMkNNTjlzTEdWQlFzaVZF?=
 =?utf-8?B?dFcxU2xoRERsQmVRc2FpUisydEtxS3FpZEFLWVZWRXRYd3VTSVhEckNRQUFF?=
 =?utf-8?B?dUlRQ215MllFQjBMRjBxOGNFYWpSOTE1OXpqYVkzRzNydEpIM2FPWmVxWFZs?=
 =?utf-8?B?MDRTZERKcDVweXB6bzJrRHJ0dmlCOVExM0J5Z250cGhRS2pnTUlEZmU4VFlB?=
 =?utf-8?B?QVZkZUNzc0pkMGNyVTVydElDb3J4Nm4xZUJkb2ZaV09pRnNVK3kyNmsxRm5v?=
 =?utf-8?B?TFRCUWViTG9kK1g4U21oMlo2d1RnbWkvSklFT1g1YjBJY2RDMDRwdkJwcUVj?=
 =?utf-8?B?TURPZDRDeXdybThTSU5ZaEtIYTVBNWxoeXllLzROcUVoYk5qNVJoY2UzbWhE?=
 =?utf-8?B?VjBQMTJSaWpzRWJMclFaUS9JSWtXaXRCWnNka3oycXl4MUUzTEJLL2dLT2Z2?=
 =?utf-8?B?NHVneFA1UEM2dkxHTFVOQVU4VEpWUDdoU1NpR1pCdkZZSFhkeEJWL01xSGUv?=
 =?utf-8?B?U0R2bWhNaDkxU1NqR01NLzVRNzk4bFNUT0duL2RQZ3JIWkxKdk45QUttV0oy?=
 =?utf-8?B?d3FxeU9zTWk3c1A5Z20zaHRnMHBIZW45UThON2RoTiswNzBYb0ExaW9odDlq?=
 =?utf-8?B?dXNPWDVqb0JmbDdhRlpGdXpyOEI3WmgxME5VUjExRytlbDV0ZHByNnhiWGJZ?=
 =?utf-8?B?K1M5dkJWRTJwOUhXczVZS2V4K3hZbDdCWWg0YVBiZTJXdGFkNnVxTk9pb0dp?=
 =?utf-8?B?cnBueVRQSFVWWXRVcURaTFJsRzEwZUFxMkR6TzNrbjRSRzJMVERpT01hMzhE?=
 =?utf-8?B?bjVyYVl2Q3NXWk96KzZ1TnJZcTlrUm5ackduU3NsRVdFUC9TSEpqaDdHMzNY?=
 =?utf-8?B?SHdVb2h0blg5TEFheVlMVWlvQkIzMTlhNDJiR1VzVXBUamxicXVNSWRmS09Z?=
 =?utf-8?B?UVFrb016UytOdWN2QlhkOTQ1Z1UzOGd4RVJLaU1za3R0d0IrZ0ZCNTV1RURE?=
 =?utf-8?B?aE9KazJGcmZMOWpsZkNOaXRINXdzWlZKNXRYUDNVbVovTXBBWDZldz09?=
X-Exchange-RoutingPolicyChecked:
	ReJRxBP+TxIlCwbjvHDtVCCPrpgXE2gr9dZdAhAanpTgikx3Rvvngqa+cJ6c65imTp95pCNg87srjvC/WHkJBJFZCjaF0fY+pf/0OOe3hNwUwCLecpBFNO8bkB1KJp104VwmqxBCwVqeB2vUjrjeSmPD+gNEuRGruFka9+yodkjAoLVatU+ohTA5v/nBII0rbNyJMf+GDLD0a3DbcDPZM5ohLsJMwS/wlXyKy0cf/7OwtWwCpXPOOvC717L3pSOVpsRxqLCbOUkSl5EVDK8XFPzVOIh+GTclI9d9iZ8jgqmrOe2fbOBx4sWPzjCu+39jRV4SUdFDmOzeAoEO3WsEyg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z3ca8oSNgEeh43legQT24GDaguOZlJiPqYKcNnGZkKmf152djb6aFslGx6M6kTRpuzInn085OTw2KMFwtzTsznW1W510wCu9yguS8k8sRNW3bIe9jIrxwNIoiCejzv4W6YIw8Qt1InUuAq0eoT5NgSz4ITpgvrqtxC9I9hRAI33UHLhkpAmDQOftjuFnY1qTBFVReyrhMYK2MJOc4jpklFTdJSrhddDmfL3/VMgWTPoBKBfwPqtYrpu6dTW8WR5BkH7JLm6PCcU8yxpvDoOpzh9Slfvm8MqGkouUzCwPWmnzB0I84F3YGWs3cuePzvpAe6ldctBU1kd4NrMa0r2Lj5ny9lIt+M/edLuF5d1i+FgpCMBXovHXR96OTpiTZ1aO/ZWLNCJFwJG2ZidIXnEl7xwPLYESj0cPfaVNnKDPjKAEL1n8NZECx20FkNg5/F9/WOoChz8WKrH/n8fK0Aw4rAE7ECIR2VQ4eG9bxoBOElyzBIXRMgkvl9E/snDw4fWUeaTO/qMDzhwYe9KTHP0x+wnND0Pa6vMoEnn2Cjv0Dd4RezIqyfe3jSFXCl9FMi6fQ9ytpnZ/62s2Pa37j/y3m/Qe7DvOWZSGjjoJzSgqgNc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 309ed62a-ffc0-4233-0571-08def26e8f76
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 21:23:00.1422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofeXBnu1XeERn1Bctrq8+nem6rsjAKAsX8Zoeum2aBW157+C5k08JnGqBo3+f6NTgjMmZ9j0vVPCZW8hKT9kDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_05,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608040172
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: pR1TCWPtIN-Cv4sqAUzeby3bSGQ6LZ4I
X-Proofpoint-ORIG-GUID: pR1TCWPtIN-Cv4sqAUzeby3bSGQ6LZ4I
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE3MiBTYWx0ZWRfX36qSDom3ffm8
 Y7OXAcBgld9lpVdtmdrkYv7AO5mrrc5fF2r7UiPC4DCgWKLumrDJYUWHshgkvEke/58jCpDADqR
 PBFw2GBkRyo9syRMSv6QAuJpj5CmX6AS23FXqoaVKdnznkfdnmLH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE3MiBTYWx0ZWRfXz2DXHEgKmiw/
 A4/SZuTdoeMTtFWRZjEXtbshCZUUjsaq9MlUaR4UoUI6o2uNJiJAIojMorXIqv+R23oUP5UX5Ak
 qiaRYO1GdMoWyf6dyzX6z4ti/ATq7JEPADffqEkXxCBpF8P8i8SRCLtLi27Yn5Qcmoo9XuN28Et
 pyxnnwssNTGhTCfjYg0zJZdW7OobVJUpBT5XgLdr2fx/NHNzpXeuYyMeeoCUFyhGwubJ52+x5BM
 0fxq+VMxc2AD4jOeKcJStKrt1RsCnS6ikV5vRkuL10OyHDAYTC5olO43DkgRplSlNtWeuYZCOVC
 VGCgFv1bRgemLFBX8znBsq/ddEqtdLIcgzzQcM8qTYN0baRgjkLeuu0eA7PWpEN0XC7emYWsEcw
 85jvws6Ee77bQBUTkXaAtHkQBX4TfBWo4575utt5wyRW6s/+fv+U3JLR3Y4wQzrpCoGrij5hsg+
 z7CP2xRgF+BXl0yDq/GBPkNZdrK/gp/+p3+tKzXI=
X-Authority-Analysis: v=2.4 cv=Iqcutr/g c=1 sm=1 tr=0 ts=6a725838 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=RpNjiQI2AAAA:8
 a=yPCof4ZbAAAA:8 a=7moai9Aca__2MZ1UBNsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: x44xgsinupiyb5jmhcgechwcp71pon5y
X-Rspamd-Queue-Id: 9169D40010
X-HE-Tag: 1785878598-260089
X-HE-Meta: U2FsdGVkX185Lp0GlTBzj9aGC55fbaaxtXQPD+gJ5XeHLCMODD8FMUQG5yABGqD0O/NP4QwCDS80waRHAA3zSci0097ni+7UkqZK+5SK51Sx2ihVSntr/4sxHNgkRADIEV1hvD5wq/1bOuOeaDzaUU9FShr1see2ulG+QBJSnvOxkmPPWmD/dF5LbE8NbfvdG1dzZMUDzrrx13YHnZ86wQxY6/lTVaYAWBVDysahLsFk+bZsJa7V4ptYnaEVY5nLtfOrFYocaxEbygjr9UIGAe9/zWr6WG0GoKeCuS8exr5iVlw8NS/SsAwKmLABkeExFB1gm075DTrIjGHJcq28Db4jD1RwnNkdbnzCVmW6DjyHKR7hhMu/btSfU9ZRbx7LnS0wird4LuiQu3Pko6QpjeqNBz52Kus6US9abQo766rPKpctBAehf3rnpCCwl+Dhzcr8eIdB0F5oSCbPJfiJEj/FKVefbg2kIhf0tao+cdf4Z9O+hLUrxEPsXlB0iMH/w6xRAcN4Ix8uGVQs2QHZv1q1pqg4drTjeFBicqtXeXm3OEb+3yFh6TJlHQezSewVWupB/bVAhpFxmP/3dXYpP/u0vjFlxxDVzlp30RXtAshc8YkIe47s3FBIzwm1M1rVh9T01B6aBM4tuNkbcIVQybOUk2PKor7nh081rHQGNgsGq1TxpU6F1twjG6lYgThcla5sIYbyQus6eAiTzk+Uq5tTmRyGq20irot56Ir0L6kfW9ba536/Sr7usF1cCLWvq9mwtVj/XCkl6u0eLy6tsywwZBWeaRQUfwyDlFMumtIbQ0T6DwaOGK/QF+XGsRsWw9hKWEjGBaZozGJF8rdgGcP2r0nMD1yRMTbR6aAoJ5aRYSQ5tCemKZoQnO9m/RMUXasVpu9Wdd1UliAhCykj+E8Z9uDuz/6ZA/QQ165LypwQj2vOZq6SJph/puUPmDAonvzC5dlRkfGycDu4qya
 ShBe2uyz
 OF66yTqwSSqDw28tPlK7gjRiKhun+ycjTF9A61rnZT4jOaOBsfuYQu4SLWm3YZFMOB3ahoKKWla4DCq+cXJbTkc+ijNoFUl2dbQMQmDtTknVMmTmwq+rq4g9/kJi9mitKyKnvJD2rGlvUzq5oxriZddBrk8bksLm10MQgtygG0cOcc9cN2KZW+racZbUGcmBoHBKhmthnxdakJcDfiJdUH6qdnjGOM+TNS2A9BQYubt/hivjiu8aeNwxLAWq12NFU0vHo2cLtLDQ2ZTpI9DLKif03QB8UwZxyocN8sjf8VIdCXHna/y1KSAzJ0g8BNsIs+teVgJU/P2vNKWXXells+BR+Uuzm7xXgPDNA49JTXP9tCOX9YbD0EldU30WPnbSptZfc9PM2w2imDwIWeErI7FYfeuy49r8tXbgPaxqqqhMNDWeld4SKgi7S4Mh0sL0xukIVNcA3EF7fXXfHuqPBSoXKxvD18rn/t6TVTFOz8uG0bcHoDKm9Y1CMPVjPbvUAMsuG7StAGM9gdfocHS8rmCuLZ8HJAfaCQmlzljKb/OfFTjb+gFEeQ9NBGGOrH5afsGGTcble/6QeX4ZZ/8ODFCSsBIguSoSr11j1w4aDtXGhMupXAtcp2w7EnCxA8etfR40fsvIwk/14zMfxHV9QXh3ThCn/DwbaBYaZoNsBrIq/lSlNGM7826L4zBufGS0BNafCGx4rIxSY+3QqeHceUKssJagZUYvb0UcIY+LxF74HVEecpuMULrCdM0V6P24oMRlqsJBdyddCniLFLM64JgeX+CioGek9a6AhgfvU40ZoczSXDBgKhdlWKYFH8kdgEGXyPWp+9bKsYUdYK+o+KCWGff5Kul1pdg93I6zxhCfQ28vdRvq0d90x8Ckpc+imvTCDe4XYibZc/zVKkqIDENX7NdLusCCwjiGl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/2026 8:35 AM, Matthew Wilcox wrote:
> On Mon, Aug 03, 2026 at 11:=E2=80=8A40:=E2=80=8A25PM -0700, jane.=E2=80=
=8Achu@=E2=80=8Aoracle.=E2=80=8Acom=20
> wrote: > Patch itself looks good, so Reviewed-by: Jane Chu <jane.=E2=80=
=8Achu@=E2=80=8A=20
> oracle.=E2=80=8Acom> Thanks! > That said, there is a pre-existing issue: =
>=20
> folio_free_raw_hwp() should check
>=20
>=20
> On Mon, Aug 03, 2026 at 11:40:25PM -0700, jane.chu@oracle.com wrote:
>> Patch itself looks good, so Reviewed-by: Jane Chu <jane.chu@oracle.com>
>=20
> Thanks!
>=20
>> That said, there is a pre-existing issue:
>> folio_free_raw_hwp() should check HPG_raw_hwp_unreliable, and fail the a=
ct
>> of unpoison just like what __update_and_free_hugetlb_folio() does -
>>=20
>> static void __update_and_free_hugetlb_folio(struct hstate *h,
>>                                                 struct folio *folio)
>> {
>>         bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio);
>>=20
>>         if (hstate_is_gigantic_no_runtime(h))
>>                 return;
>>=20
>>         /*
>>          * If we don't know which subpages are hwpoisoned, we can't free
>>          * the hugepage, so it's leaked intentionally.
>>          */
>>         if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>>                 return;
>=20
> I'm not sure I agree with that, but I'm new to hugetlb & hwpoison
> handling, so please check my reasoning.
>=20
> We set the unreliable bit when memory allocation fails (ie we can't
> allocate a raw_hwp_page).  That does mean that if we have a real hardware
> error, we can't know which page was poisoned, but for a simulated hwpoison
> which we are now clearing, it doesn't matter which page specifically
> contained the hwpoison.  We're going to unpoison all of the pages in
> this hugetlb folio anyway.
>=20
> Maybe there's more to it than that.
>=20

First, I take back my comment about a pre-existing issue, because
folio_free_raw_hwp() does call if=20
(folio_test_hugetlb_raw_hwp_unreliable(folio)) and bail out if true,
before it calls __folio_free_raw_hwp() to dissolve the list.
So, apology for the false alarm.

Also agreed with you that once a non-simulated hwpoison occurs, unpoison=20
will be disallowed for the remaining life time of the kernel.

But I think the reason we don't dissolve the raw_hwp_list if=20
PG_raw_hwp_unreliable is set is that, doing so would screw the=20
validation tests and maybe some body's monitoring mechanism.
Had PG_raw_hwp_unreliable got set in a non-simulation scenario,=20
immediately, OOM could happen, but then, we still lose the hugetlb folio=20
for the remaining life of the kernel. Unless someone come up with a=20
better solution to replace the raw_hwp_list. :)

thanks,
-jane




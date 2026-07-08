Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6A8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BCB6B0088; Wed,  8 Jul 2026 19:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D496B008A; Wed,  8 Jul 2026 19:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB826B008C; Wed,  8 Jul 2026 19:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5F4E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:32:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AA5A1A031F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:32:20 +0000 (UTC)
X-FDA: 84967210440.20.094948B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 73CE320002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:32:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XYqxiLA6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uuUXGgdn;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783553536;
	b=RrfdZoSh78ZHnFgrbu5dXYKbgN3SMWYjWUDQSP9I7oBJdQgj743zZlhksUEJehG+Vkz0bt
	UA4HYenMXooqT/oM0ISLp3uNHP3Gcjuu6Ieq66x6coLoFzVrvekNNKXnCC2WgRAKQ4SEJX
	XD+Yr1TKnzT5HWQ23EDkPyGHY7/DtvU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XYqxiLA6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uuUXGgdn;
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783553536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HrA2xx8W0nNBxVGifJ8fzG3YRKEnOZjjvx/Vizjr4M=;
	b=WuCUG4nnJ90pVjjKxwvrJkU9/DL1OOyqFSc6y+AKtJ9sBceIA3a2uktrmyWa0EcUC1zkeZ
	AnlfWD89jqzWadluoPPNAsVf0fxPQ0ZGDnhH1+in85O1Elgc9yIr0MXqM+y8lstRp4gSiW
	qKwcHn6EIyOf3DBcTatdMVMaoq1pZac=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668NRUdK097599;
	Wed, 8 Jul 2026 23:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5HrA2xx8W0nNBxVGifJ8fzG3YRKEnOZjjvx/Vizjr4M=; b=
	XYqxiLA6A9s3p7mPkTHZbSeDLSb2gTyWP/dEX7BCA4IhRwyuzsjfCivFXrwMvM4V
	MeXxtfGFWAMtI3FLzFrc8nHNj4FgdsBrw8EyEqKDMLzaSkLHOk8Bk8KwrhqCVht1
	2W5E6nCW5Q/mV7R2xhR66pQL5+LoB59ZPH+IuBYHUHV/qfYqUJiu1apywHJU8Ea5
	znm+yE9D/Lpb3AO/yygbEz4syTEYHHkrTzO1FIN18v7kUEIt9Pm1Tw1cD2CilKqr
	X9JNmGAm4aqWTmkKWbsAqipI66ipXRbhfAIoa2G9T0hCXNvZGm4nNh3VV7ltPAHd
	XRFIWsVQsYq1UOMBi4mHXA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6ry50ru5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 23:31:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 668NS8Dr015765;
	Wed, 8 Jul 2026 23:31:56 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f8wv02yp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 23:31:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQqJ67i0C3mni6o/kByT1ohaXDFLtH+BkWsXA5nNJoQ8jPLgU17rjK5jpypTwlJIUYtHGTkl9GIQmn3/gQO+jo9laorbN7aaT7TytAd36lyhf473FG25pPMimXYJ5zXsiLJLAJ0wHkFLyfQwGDy2H4KoSZyfMEa3W9YKEBllOPj/sEE+Vve10QBe1ABazGyC5fwN0uMeYLlFqX0CCilqaKRa5wwCvmewMAvnePtvI1MEwdJDCJrbED0Zy4zGg7g8hPLtD9DIV/aHsCi9kk5uDdgcwEZMsMlD1QN9Ell7OA+Je0/HtnLF/9yaJQ7ns0RNvInIHBgtKlgwpCgi/S86Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HrA2xx8W0nNBxVGifJ8fzG3YRKEnOZjjvx/Vizjr4M=;
 b=Q5y65lNSNmMvDeKene6dsLIZe4VyS1UL6DtuKQQ7GzCEZGiaPj6zu1CTiIyPliGNpOCCH0IK+BXnRum/WiodB2Tyk0fF436uikZo54H9zWI4k+SNM6bm1znIx8/XJ3Od7q2n84JkB6kD4X0xGUOcRYr44b8MDGPhi6iLAt1EfzMgthxGPY87KbHLfzAbb2RKM9RknvB1lXFYD6ivRNZYZP2wh0pqNv4kc9frI60Q6utpdWPj4LD0qgcxBxIM+CP0YUuoRwfC/XkZjxruCXGngsOSc19ee3xaBhkcbj2OI2Xo2VJr3B+BtCQ1rY8/PS8DFhxp7CNgaH+MsFnygOyuSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HrA2xx8W0nNBxVGifJ8fzG3YRKEnOZjjvx/Vizjr4M=;
 b=uuUXGgdn5hBW/SzcQnc5cRbMJ/hLyiS2WY/iWAXM68sznClYUhL9KLuMh+hqkA+QvI/KrkX+szB1xMpReXu1i5NNCdDYg8N3cgpc+JlbkVEuVaC+2VLsNIK+5M37NG1859XQq3Si0N2yICvJtliwcQeoERwW5ycY0M/kPjzA+EM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DM3PPF45F123D65.namprd10.prod.outlook.com (2603:10b6:f:fc00::c24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 23:31:51 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.21.0181.014; Wed, 8 Jul 2026
 23:31:51 +0000
Message-ID: <f879bb87-0267-451b-bfed-a3e4b475b9ea@oracle.com>
Date: Wed, 8 Jul 2026 16:31:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Use generic_file_read_iter() in hugetlbfs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>
References: <20260707181713.208282-1-willy@infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260707181713.208282-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P221CA0057.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:349::12) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DM3PPF45F123D65:EE_
X-MS-Office365-Filtering-Correlation-Id: cbafd7c7-eca9-4190-4feb-08dedd491663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l99Ccl60tgnEpzXf7e/x1oI3NC7h10QlL3MN1HJ7nk+EqLfXd7hAmpi65tCGd53hKyvdXYqsC/RgzsKzdheNMDUMHKjH8G7MsqQwxMixD1mc0yDpEwAJEjLgYVM2iaHbpEx8oOlbdWnhAGz3H9zscbSWaaMHdGqHddXYSOH49S7yhdw4FbbnVM59n/1YLBCQM3WxVc4oAcmwdHoulQUwLaWZ8sFDN5DDmXCnIgHLUhGaCiks9QrwLLQccUdnmF/BtIJWimMsK54BB5NBswbcGJiEM/Dw/voJXCjV2pEHlZa7LgC4j7wK0XMjaZenrK0D0CrJSqbM0KtB+SBfB43U3tFLo/HjP3A4tP+acVfeQ2A8KmnYMCUFV1cOElWVCgTo5aCdYJ5xidn4svU7AT6T0Vrfm1SM2El1qEO0dYbjr6CKqX7U6NVXzuRmJF0chvaOFWQMwuTyfHCXW+uyPLbg+KsHU/6lfekRwzqqkck21e1cmiKTza6+Rh2Un0iXRMbdF6pZAhqh1oUgIxZqGHEhlmxJGfIk0rbsHEQdagTL6DWdwbCqnSm/QVp1rPAqXYtAJ1XhK8lH9jxEfncTY4k0FsvJRPUOo8MI6wVxGxvyV92Sa7IzS7Rf2ISX+p24Wh2zan841OJRjEDVYSeXrv1Ned0atA6V7kXhUuOTuM/hIAI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUdKcFNFTWJSOGZHZXN2OHU1eEpyZmhUY3NPTnJJUGEySU0rbWpFWUFnalFD?=
 =?utf-8?B?b1dzY3BhUlJvYTlYeGpIdVJWMFJqblJDTjVGK01YaDMrdmwzb2RKeUlmTlE1?=
 =?utf-8?B?THp4MkVha3F1TnBTREN2VDhkemowcmFjUjlTcXBwekdDcG9yeGpFL252blpG?=
 =?utf-8?B?SG5sT3VUb3cwMHdrLzZiVlVvQVEreVVGSjJ0U3NpN0RNNEh0bVRPRUlvR3pO?=
 =?utf-8?B?NFdjaDFlZHhBSGYrTG9KMDZ3R2Z1Qk5WU0N6TWlzVTQ3Vk9udjRIM0dZYXlt?=
 =?utf-8?B?dHFCdTFhMVBrTHl5ZEhKUkdQTlhpdkhtTGdBNHBTb1VsRWZFYmZTVURiakZH?=
 =?utf-8?B?WnhaNFJDRnJYOVVYQ0dJUm96c3B4M0hnMFhBT1pCZmVneFFKNElXa0dhNTds?=
 =?utf-8?B?STVBMEUzSlVxRnVEbGQwQXlCRTM2bWtKOWE1VGhzZnJMZE9qWGltWDVhaW1H?=
 =?utf-8?B?NW9jdWV2Tnl5TklRT2ZRVTEwU2kxUWRHaUlaL1dBak8rL3U1V1lMMk12dXpw?=
 =?utf-8?B?TlFVaEQ1cWh3aWZDRFdUakxCbHNYL0NRMmNXb3pCQzJiYmc1SHNhd3dFQ1k4?=
 =?utf-8?B?d0hrYW92dk1sQ2ZoSWEvb1ZzQ3FCZjdNdnJBTkxUUWdGVzF5QnoyOGpsTm5w?=
 =?utf-8?B?Kzdkeis3VUlUZkR5R0p2REI5dzlCOVlkYWZ0NHE4emdNWk9lMWNpQzNpalFo?=
 =?utf-8?B?aWVuMnlnSE4xeCtKd0NrWlc5ZFNITTN6NWVlN2R5MER6eFdQSU5MT3hnNmNP?=
 =?utf-8?B?Zm9VUWg5UVNYOFpwSHB6MEdJOTQ0bThNQ09INENRdllwc0NFYmRldWFHODBl?=
 =?utf-8?B?bm1DVmlydy90TGRFQURibXR3NTlOZFk4RkVBM3ZmMU1hVlJFUFBvN2JzN3lP?=
 =?utf-8?B?dXlnQjFZNzFkU0NxTWxYdk5PeUVuemw1NGtFc2h3bzZFc0psTHFiUlo3YlhM?=
 =?utf-8?B?amV2S1JoMkF6VjRoaHRYSUYvRlBBZUZXWUF0akVsVlduWXVRY2xVR2pScGcr?=
 =?utf-8?B?WE5SdjVWZFl1azR6MjJnR2huK0FFZWNiTkJHVmRiMHdiTVJzbEoveGNKUHRo?=
 =?utf-8?B?VnZ3RGptZndibXZJZWk3Zkpyd3NIMWtTSEppYzJMZlliaGhsN2Q5V3lqMjhh?=
 =?utf-8?B?emxzL3B3K0lLRnF1TW1LazlIdVdKZTkwaWo5M3NveVd2TFI4N0YwWlRXYlZs?=
 =?utf-8?B?ZzJpUjdSVmNGc2dWTTJ5MG52YzBGYVRFeU0vVjFyRWUyeW0yU2lXcllQWDhT?=
 =?utf-8?B?WEthQ05jZ2dsQ0duNG1OeCt2WHBlV3hyZXh0QUkzWFQ1QjFHbHJOUExHeWtT?=
 =?utf-8?B?dVdjdG9BYnBmSXcxb3J4LzltZStxWUkraVhLSmlpUUlObWtJbE9yZ2pyRGdu?=
 =?utf-8?B?NTlkcHZUMEhiOUtvdzF5M1JFWUpPQzBJa2RYd1JrbjVLc3YzSmFaQ0RhWGxY?=
 =?utf-8?B?M0N2d1A5Z3RIemYza1E4cnFpUDJ3clVTSS9TWDV4QmJ0aE5FNi9oUzN2dENY?=
 =?utf-8?B?UDRGRTFpMzNOakdsaWZWNkwyaVVIanNMSmNWS0UvMml3VTFSYngvZVlSYTBt?=
 =?utf-8?B?aXhuMzhySXpxWHZxTUNyVEZDQjByMXZ2UWJkQWJmQUJVa2dSOVgvVHRGMDhZ?=
 =?utf-8?B?QTNkQU5EcGt4dHM2NHFXY0E4dnNMdm5kK1k2WGVScFhGTVIzdWlFWmg4RGE3?=
 =?utf-8?B?a2ZTeVFFeFRPWlN2YjgwK3JOU0FQand3ZUZjcVpmN3ZLVFdxa1V5OWplM3Q5?=
 =?utf-8?B?a0NYMTRGdVdyUzRvQVVXcmE1ditieDV2VE0rOGd0MWVEZlAySkVuUEFRRGxo?=
 =?utf-8?B?aUxZRWFyZzNOVmZPNVhBRG1FUDF4TVB2UHRIRVVWd3BYUUoydFVWbS9uTXJ1?=
 =?utf-8?B?aStkNXZUUERpLzNkYWRPcjhEMW5zZE5NVDVBNkZTdG9aYjJ1a0N2UEZHS3VE?=
 =?utf-8?B?V1JBb0VvV3o5dzFHK1F1ZE9aT3E3UlZSamZNeU9JRzhFbnNQdWVnSEpzREt6?=
 =?utf-8?B?R210WG5jQ3dUWVYrVlM4dnVraUF3TElOUUFqd0xiTWpZeFIwcWdtcXBhZ0lF?=
 =?utf-8?B?ZGtnQ3FTWFJKVkl2UkdzNUJzNWpJS3JseTY1YW5xUTk4d3liVkR5Vk0rQUR6?=
 =?utf-8?B?SkMwVE80WERBWjFLUE1jcjNrRDY2ZWgwTzBJQ2NEclFIS21VUWJwdjhITmRC?=
 =?utf-8?B?NXNGSDBkdHo5bXBXRHVUMkVVRitwSDZpZitPTk9xRUh0M2NHc3ZNbE9pUkRI?=
 =?utf-8?B?ZUJBUk9jNDgvNDExNVEwcUc4WHVnM2g0VGIzL1NIc3d4Q29JODlyMkJnak5M?=
 =?utf-8?B?ZkNWNHlGTEpIVk9jd2VRYW8zK3lkNDlhbGZVcjljb3BDaTNRQ0VWQT09?=
X-Exchange-RoutingPolicyChecked:
	JajtqqqnzxSdHueXSDZnf4XWB1nDPjMcycXDwhbRPIa+Ziv4nKXmMKtNsb5w0LNQxdNvFaht5PE106rC28bDe+2qCpAnajf2mXANqp5PeBFjwyOElARMENplhVFblCO7amkOWkcM+wlEDkw0A4K2KoLOj/q7j5oifLQrMYe516GjeJ404BImajfqS55FHVERJUM5+VhxxRdpi0D2njjdBYM4usCmh7uLN2y1M8g6Mz98gUGNJ3ZRcgkfe/UZvBiFhuFisaQk1T+oS8mc3UMyKtqlgcpP0dJkNWsZxT0eBK4uHiiQZ0cdCflEiRmT00yXjpBpS16CSvys+xuLnBe3EQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ifZOcffZ3B5FA+0InW/yN0aWCzwPEayLOHH6k/dTZ2Z2IQKEITfRmQMPZftd0Opk1OhoFuzRNRizx1EejjwTBpdsSGRAJTZfTw22uLni+qNqpnMm+2RG6K72NcxluhcbHuNYjErbYpKFYp1xlgFSVp27NrmSp/VuyaLSRIE+vttynD7rlK/CKkJ8eM+rhd6C+p17MhrJ8F3881wOaq4zlVZg3HQDRh1CUkwkC+3eIWMbbq1xpXKbggdE2ys0wCq3e906HojMiB7oKLP0crQD9tg1rly4MHn+qAqGskHfyrL+LyxCjOjEisLZYMnylH8w+keksV/yKkdbmVkudvhG5ca8FuM54FzE8eKAIxCg2Bw0esmSAQ59ipy3uzTXS3Gl7QmkSucE2xjLH/ud9j1dUmSUy7Bp9bxhnC+gi29X2FGD7u3s8Y00TIF4qj20DSKIB/KMGWDRRG2OxykVlK+dEY1QDq8h4hbxkvUz3JjUv1mM++jsT1kca/AZaNaBQvwhud6tV5UP6cCu9p9CMSL3IXsDRDAmCO+kJBLlnQAgNL6937mZTED3QjN3M4zMqVPldaYioaT+F0aAY4OF1fGO2+Nc35BR6pvCV0GogKhS4zU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbafd7c7-eca9-4190-4feb-08dedd491663
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 23:31:51.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8RFJsg6pAVOIFGGotvJEKz1EmJ+P50hQvCB/Op2Zv/qPpmhHARhCS7AaferwLVKZX6D40X1wJRhA4vrnpc5oDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF45F123D65
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_05,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607080231
X-Authority-Analysis: v=2.4 cv=UcxhjqSN c=1 sm=1 tr=0 ts=6a4eddee b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=JBKYsMcjX6F8BjdkfJAA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: KEEpfy1cF5vX3RkNezwjbCDsh3AC3hzS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDIzMSBTYWx0ZWRfX3VXWED2oAl3L
 xfYZcPaEA50L1qnEfxMYv/WKTuIlg1f2xYcB4puyS6IQF4uIbfLcrELSTHSsk6JCPi2oMzVCMRL
 qNBuFNGikC227e+S9IlkKL26WEAuzk/7nSNqiEPxn4qDfWnzC8W+8eqbL+G0Bqr98Zwa9/kZe5j
 i9js90pV5EWXnzznWrsV62YVU5AxvwdN8Ri9aCON6f8S8J9tpd0U6mDINKzUXXbBGERu5qO35uJ
 UVTxcXMxVXWLAREnlP88MC6mS055tHGSo4NwDe5qu53x4sr6GAQjeRy4flzzr9L0chSaM4sZi06
 MlPsCZdjsBsptP+Kqn1cc2zbKiLJGd8JVBd4DMCzv1FEaE2ce591pFonsEKIQqKGIP4Our0HKFP
 Zj0D+fDJGZfTfLh0NgUk0ffdmOFMtn4SfAuRNlAgkmBBwR1BxOo9BbQhiggBT6wD8b5YeRGHjYu
 mkYdgOe2kL75sl1A4+A==
X-Proofpoint-GUID: KEEpfy1cF5vX3RkNezwjbCDsh3AC3hzS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDIzMSBTYWx0ZWRfXwVWG4gkRTKeH
 EUsZ24iip5vLCWvDg/2O2aCzdqYipe4QmTKBpACSIQZTHRrm/bwtt5JZjLZWgc9pQYbDUpDTN4Q
 oDqqb/DGY6GF21EMsPdcwAhKNr1NwHrdpwcH1OW8/XhOEBXFgSzt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73CE320002
X-Stat-Signature: rfszcneuipd6b3xzfghxejb6fupfmpzs
X-HE-Tag: 1783553536-975865
X-HE-Meta: U2FsdGVkX1/KXUADY+ml7oUGo0KIw2aiw87u41l2BPCO1gtLZLXQfjgZk6AtU52Ox853ww8JDC+YVxRO2scXxEgPkpkBLE8GYoh+LJBq3yO2up3N3BdBajHcw2415beMaVNjDlMCTCtvwP19aMgckgx1hh6r6tP5s4owK1fP/DTiXyjzIU6Bqx1P1vhenRtDsvV9EPJQWiPorBo0BakxkwnyYmXtHHMG/H7KDagx4JaBM85dPX3WD4FaTNG1mxCEEpmQi1cFpUou9RryIrrX3EjDiwHp38dbxJTKgKfoD28RQAlmk2zj0D7FIdoDDeRUwp0sUKjp49SZSVmA0M5giz4kq7ZieSsT+grILC6D5kRPn93gwmGMLdhDEDZM4HOzfoRvFvUGB117/yc4gLEgOBhLtXIHp1bE69yOJrErax+hFprb1iWJ+xjZK4spNtL27wbrTwklSQkZn7xS+1HBVK2hpCyYnbeC2XC480ROQdsU76b8+bqfqCRTApcdP4z0CSQIl8jsLXGGotHdaCQM6UpYSMtXI9iBeFioDn5nOEKTkC6rUda4acW8BicCa7Zuq37TPkPolBh3FZ4W3pVbUkBj6RHHh4uPzJr1EcAUm6gq0KRTcsU0rpIyfoR1knLBddjIRQNxEG307boYjtAQwEiNP4YICeUQJe/A2qsTFPtcvZ1C8JK3DMx/odA4vkv4CdlQs/2mRd/YUxilz3nhbwDUU0E+d8D3P7eD4YbbBAuAQUQncxGhdGSfDlAm2JWwIIW+80qjjOxowdOM1uqfWQX+a57Ly1xBZd3GUM8A6H4hPE52MDBJOZigugkBiE+buDmBWYezqm/i9+6zn6nFeFxN7AFhkDh0ngEhHR+tzS3uzh2ViHt4hZYp/p7jLnO90zTY+6egV544ZoVpWyfg3ENC5Ae69AZ+AulnARpcPZzWCwoSseAKZoZMpAwyja4N1Df41C04KMl3kmoZ+sK
 W/NeaaFF
 dvEUkKx8lilTxIrzJgBjmCjHglR41cLaChoTAbw3aHPf+LUMAam3+tJg6huUy8cDEm9LDXCfdwlu9DGpBXZecHdMAHLaHz4OdxyZeqv8ckMY1stZgAL3pJ1ZhWY6Ze7jsKQQ3/5y7BQirBU/fOV3cW3LjcsANd+EJ6Q39FbdjSSBf7McTbz3ZGZGDXydXCNs/vlm7mf0lIRzxaRT2TXWISu4mlmtLGV6jCliH7Sff68b2rJ8Yi/019NhcTezCmcrzQ78V1wqptMqicBNMad+xXbCzdCh0XR9YDguSQJsI+nRNsELYanOC3KDOh8B13cSRg+b/DzU63RJrWMU4eb2itAa+3nx6Mcn5rDxVRfBPPCShcsF67oTD5/OkDT565aXgzMh2nfafmwtNkeKJBGMFn2aGgY04LdSqdH4ti5o8maesk1k3UesnB8EWysuOo8Dt+duEB5lEMdtBDPN1dq2uPUADSj3/H0WCUnKPbw7cyqtojBpcHTHwhwh3RNmbdHiVaF6PS/ohdzcQb3soUPgUdbUaoWy04n0dFmxdBo0hACzfelDC+b7eCGPOygALwSP8VNK16z8eQ6vtbz30U6z3A9qE9ZQVRXmFiWuFIhMTVGoulaN9e3CV5Brhxt9BoMI/vu09JHK4WeQDqQbjEbBx0nT9fCemV5BsHeNFolZCT2wAYxOag0uUzcDfDqkUdPzaTyBVME1ihDwPbmAB5d05nf5nOfNUvYwB2eDj/Zx0syMH6KxiJluXfGtK/eseAy+R5aK6dePsSaS86rFqyDVXtUYdNUf1FmFSi584aKu6iN01tdiHQLv5RBSAa3zc5cFr3U64IyIM/BkYlLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/2026 11:17 AM, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> I feel that they represent a reasonable amount of change to send
> separately, although I'm going to keep looking at the rest of the sseries
> because I actually need it to do a further improvement that I'm working on.
> 
> I'm not 100% confident in all of this, so I'd appreciate feedback.
> I've run the libhugetlbfs test suite against it and observe no new
> failures, but I'm not sure it's thoroughly exercising the read() path,
> and I'm absolutely certain it's not exercising the memory-failure paths.

I can help testing memory-failure once I finish the stuff at hand.

-jane

> 
> Jane Chu (2):
>    filemap: add hwpoison handling to filemap_read()
>    hugetlbfs: replace hugetlbfs_read_iter() with generic_file_read_iter()
> 
> Matthew Wilcox (Oracle) (2):
>    hugetlbfs: Set mapping folio order
>    mm: Handle hugetlb correctly in is_page_hwpoison()
> 
>   fs/hugetlbfs/inode.c       | 122 ++++---------------------------------
>   include/linux/hugetlb.h    |   5 --
>   include/linux/page-flags.h |  24 ++++++--
>   mm/filemap.c               |  31 ++++++++++
>   mm/memory-failure.c        |   9 ++-
>   5 files changed, 66 insertions(+), 125 deletions(-)
> 



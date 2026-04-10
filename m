Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C222FF459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 19:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D096B0088; Fri, 10 Apr 2026 15:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56456B008A; Fri, 10 Apr 2026 15:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04DC6B0092; Fri, 10 Apr 2026 15:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8226B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:06:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BAE916021F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:06:51 +0000 (UTC)
X-FDA: 84643578222.21.1F72BDD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB076C000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:06:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HKN50yRH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xjqu2E1k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775848007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtYGjexyzaI7cKvWsJBmjcD5Hw1VmexaB+P9bj05xkk=;
	b=r/kojgtnAHVYvk2ftwV86dxXS6vFrkJccn1b2oTi9dElhlXXw8mExamcvAS3p3E/Yorups
	OTOVdfxVyDLL9NkP3Dd6fMHGtfc+rADYFoxb9CtALE39KIYxz9XJ/3KnxAtSbre03WINCI
	XjpP6S96ay9sDArYztOpWJTb3ZWqKI4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775848007; a=rsa-sha256;
	cv=pass;
	b=bob/bflSTOQNe4yI/u+nNWJC43THbwV1X41qBw2/XBgSE92q1othXG1A4eEs55T5cHHwcV
	L9Vx5RMvf76JJodEYVQ5guk5srRwt/ji/Zmj5q9MPKkaqpqRP2dvtrlmF8UeaZqY7V1ym3
	16Va2dNuP17zFT6izXyGKGHbYJ95lUY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HKN50yRH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xjqu2E1k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AI7MfB3132727;
	Fri, 10 Apr 2026 19:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YtYGjexyzaI7cKvWsJBmjcD5Hw1VmexaB+P9bj05xkk=; b=
	HKN50yRHD+TobYXnaErL89c9/xAdpr6DMpUod5edwvL0Cbd1lk7HUbMeO5k4Uw+C
	lJqzwlxVFA8/g0mwYPFBZGj2uBZFA484bU/7ag5TzQRls4AiFmK2am0zCHl4m+oQ
	bGbDf5ABzfSew8FPWXGPnmZx+r70zI2ElA9yF15f1uxRuUKQuuVDCe+PSgZQ2m8D
	4zb62ryObHTlvAqtbToCCs0KQtZJU4a5etBFSY2sTR12yIVFSDx4+ssq85bWH8zE
	LHpYQQ27ucNm9/Q9mylCv+sNcha+QZMs+Gfmb2E9VCEQRBQoEYICFGfdYvWl9Ole
	c02LSHdaMyAI5a5kB42Lag==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbtec5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 19:06:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AHdFxG011634;
	Fri, 10 Apr 2026 19:06:41 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnum2wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 19:06:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LUg0EBRUZuJYDi2aA6bDgkL9wLZ2QgoBLApX82NE8ecAmr/G29qERJZnnKD06sqAwEJzy0RfTH3Mk7kgiUJoSzQkCmEElgSPjK1ElKMmvj35c1y+tqILm7TVS6t+AP/ovE6aHI1W/ohXRc8eUpFqdrYE243UyKkIQ5IvQW4LOcBHqmt5KZYJWtQaLgQn58FMKr2HdwQcenMtNpUVObU/r4u2IYWkaFngnpTxzfgD8VdLeBXkJ3fbE7xng/u2HSiQzfnplclzx2usi1CNfbGjmHgRJaU5+7Q9199ORabKAlK8wm/v0vP+yTyQMZGI5GpnfOHzXnSgM2QQqCk+W8UTlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtYGjexyzaI7cKvWsJBmjcD5Hw1VmexaB+P9bj05xkk=;
 b=GXdD8mH2aFsOalOsip20oY0GNZB84hqdkbhdrkgMEEzTzQfumLSWUdlt/h6iiyYeXar5N6Ii+xvWrRp0pRAmQGFNeOPg4imOI2h3fltMAOD8pM3hXL73OSi6XTl7e8d/1Gxyr2N4+8a+3Eqr5ZCvWfOgSTA1UtssyFln2v279RobWvg1QyWeHPQOTaByUVOdmULRof7RVfI6Oq5+D55ud5DhR+M9QeBdQQ8UraI1q+f3LESizFe2IscTNdZ9uF7futCRbOVyh1gi7L14/SeM5+DYgqLvBfj3Z9WZNggE/MJXc86OiEwh7sPs9dZEeFxuA8zoZZoMxD6x/aHH8Ov1Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtYGjexyzaI7cKvWsJBmjcD5Hw1VmexaB+P9bj05xkk=;
 b=Xjqu2E1kcgqPr5sKudCNd1qeZi6hxP/A4LxAX9U1gs6kyu1aqTvuC7zrNtAPqK3tUsZNGeGpTTPNve8fdxWviwn8o9JSY0l5O8AHNIMResSM3o1yxEK7a5ybcXCFDGHcoPRNkLX0AmQyO8IUYZylrbQd2EMLzXHATdW4E9GnGzg=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by DS3PR10MB997749.namprd10.prod.outlook.com (2603:10b6:8:345::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Fri, 10 Apr
 2026 19:06:38 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 19:06:38 +0000
Message-ID: <38fd3d86-f080-4b3a-a931-8ddae1a420ae@oracle.com>
Date: Fri, 10 Apr 2026 12:06:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260409234915.11723-1-anthony.yznaga@oracle.com>
 <20260409234915.11723-3-anthony.yznaga@oracle.com>
 <7a318c3c-7ccb-4f95-a416-19d09f42c97f@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <7a318c3c-7ccb-4f95-a416-19d09f42c97f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:5:334::12) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|DS3PR10MB997749:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f98dad-0cfc-45ea-dd20-08de97344aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	eHMWA8mTrfC5u8wF1VWNhUwXYlHhn5hxsWCs1e00It74GowVZqm/tJG0Mw1hLShWI4d+gWnwMZ9hqaY0826Zirv/v+Em0VqHNcWFUTUVHPjRWp+u5drrMlKbQmOTPPwJo2HKqXcoO2qD3HSzFpMoXJAGrNelctny9nuXC9dyRtdDZAIY6BRWlE0xK2mZU67kamslZuqux/A7PQUbeXTnpF3bn1ANRPg6iPLPgQVA6hldShIYmgOVIWPPstutaSF2n59FATNEqwNqzRWrkkG9/OfCzKFrmeYsm9XwJY9n7Ba+qvSf4vKhyyZLU09b0+22nZ3/dHBHrqdBMx/tvQ06NWihijUvPBeQ8GMwSGVN2YZ834NS/cqnLYQBWfmS4Cj3xQkLobnzlUWe65+UNWH7kQt8tp+poozQR0nFeQGdSFT4tL/QD76NeVwddbAP0WGqbFLIUHWY0uVGNeYr8zKnhVtMFAb6Q8Ocifh4zQ3jUnFtXjX0MfCP/FDG9PeoC4Jk/4zlts4HcZLGvg0kHmUQnmW+dY0MRYQKfCjqmwVR2gPVSgndrDu/19KsNPa+QGiyPu7aOnwFekgEVw+jioqfi7dPTbyAsK1FdslJmQJjQwgnsw/k6R2g4t/6f21JAyzkLtGSWyL1Mfzjr+aMg+vtOsK4YSfuq0Aid21i/yhkAvxBHyc+hvdv+XbO1iuC56YecO6BX5mwlQIhUvHXoL3qBQlWX48E/bkwl3VTxlGoN4k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2hyNUI5YzNLbW1ZTENqZ3g5ek5NVUNLQW1IZUNjSkRENnJ3Yi8vanhKN2tu?=
 =?utf-8?B?SE5vMDk2Sk5aQXJQVW9HN3FhVXFvVjVkZytiOFpkWE5WYXVUNmF6WTUxWVg4?=
 =?utf-8?B?czF2ODBuOUhlOUZLdjZPZVlOWGRtMTNkNGJ5RkJuY3QzMGV6MHkzUGcyaml6?=
 =?utf-8?B?UkYycmJ4LzNDMTJ5WFJTT0NEYXhRei9YbGhrRzd2dXZNcXFzbGsxaDJXNFdO?=
 =?utf-8?B?RGwvY3lNWm5na0drVDBTSWdDTVFTU0xEZW1KTEpKOEhWbEF5R2QySU9pcUJS?=
 =?utf-8?B?V3FreUwvaTFUdUY2ZXNGbzZpcW5EMkRDeURuTmdRWDJ6bTZnSVcvaTBNVXgv?=
 =?utf-8?B?NUFWYmViaUFvaVI2R2dVTHFWVWFJUExOWS8xZXBFUmV5dnEwY0tOR0VMb2d6?=
 =?utf-8?B?ZitZejNFNDV4Z1BXMk4vbUg4UDAvMnhUWUlpNm5OTHFjemNsbmZWRzR0amp5?=
 =?utf-8?B?dE0zVTdyWEZmK2J5UlY0ZWdHS3Eva0NQazhmN0toWWJDTnltQ3BqbGYvcUkx?=
 =?utf-8?B?VEdlemZZMmd4RXRpN1pqcWpQU0FlYk1iaW9LeXlFY3dmY0RURTU1ZjF0RXcz?=
 =?utf-8?B?bjFWMnRJS0dDRlE4M3NBRDdaaVl3SkZIK3pTeVZVNGJiSlYrYjFnVElSeCtj?=
 =?utf-8?B?b2lNOU1Sck5zU3A0d0s3RmJpYndVK2pEN292WmNHSzVucHJkUVVQdnVSa2Qy?=
 =?utf-8?B?dDFMdVJDeDdHYlJqWnZ3VUNxSFhpS1F5QTA2WVJ6YmV0WnpweVJCNmkxWHlQ?=
 =?utf-8?B?Y3l5WFlQVkRkem4vY2s3MmtIcVdac09ob0lPNTlCMU9sbjdIUjlza0hZa3F2?=
 =?utf-8?B?MEpobkZxTzNCZ0lpbk9laHNwVitTaHFGNGQwUkR3bzkrc2V5QndjNzFuUFM4?=
 =?utf-8?B?QmhGeHB1WmIvNDVXaGlnQUc4SWFNTmdERE5JU3U3SkJtRTdnQ3FIRWZwTHJ6?=
 =?utf-8?B?WmZUMERjMWRaK21VZ21OMWRTcTJzSGNYTkMxOXRvbGlORDR3emFqWnFDcGYv?=
 =?utf-8?B?SFVMNEZiOGszNmh1VW4xbjl0cnozRG1RZzRVWnFuVkVyYTNYQTB2TFFLWVNz?=
 =?utf-8?B?MmRNTy9Gek4rSTQ5MUFNQnZ4TkQyeStJLzd2dkxaWWUzbW5sa20zalBrMWVM?=
 =?utf-8?B?ZVNOVWppN0tIOThJWGUyenFXS240VVNDTEVpUmI0dXpka3h5dm5kRFI3ZFd5?=
 =?utf-8?B?dXZKclJHMURxRk5JVGVKanV2ckJoZGE0SGNxOVd5WFFaRVplZ25qYjB6cXhw?=
 =?utf-8?B?OFNKVnNmc3N5WGdqTXdlSXFCTkpUaCtUaTRVd3ovSGdvaUo2ZnRzZUZ4eVVk?=
 =?utf-8?B?SFE3NTM2YURTNGdaYzNFcU9HWU5lQ01tQ3dqUElLYWpHVG9TQWZRY2YxVUpr?=
 =?utf-8?B?REhDTVVuV3d6a0tUbWZ0WlVJQit2V2k3WmdXbWxsaDhxNVdHRTBvWVFGa3BQ?=
 =?utf-8?B?Qjlnb0NvbTJtL2lLdU5aYXZKVmZ1SVpScmF5QjdqaVFaU1VZVjYzbkpiemxL?=
 =?utf-8?B?WDhYUVpETGpZZEdHS2pIVGdkNlk3WGlYNkRKS1JSVStISml3ZWZwNVhZZHc3?=
 =?utf-8?B?LzRlVGJMajJhSFV2WkEzZitRYnVFbkVlOXJUSVQ3bk9tSWpZWHl1Z05XOW9T?=
 =?utf-8?B?TXUzazBWS2h1bkNuQWpBeFdHM1lUOE1HK3g0bzZhcHV3ZHdiUWxyd2FteGV6?=
 =?utf-8?B?MGRhUGRNaDBHY3gvY0prK1VVcURhRGpPY1VZWXN3MmZmZVNxaTZ3cnJBN2hn?=
 =?utf-8?B?SFl3UWxneVFuNTJmTEdMZlp5L2JCM3VyaHdDR0JNdWEwNzZMeEVVVDRwcnBP?=
 =?utf-8?B?ZDV4SEMvOXdlUXl1Zk5RcEdJWWo2bXRrSlMrbGlZSmhnN2RkekZIYklyZXFR?=
 =?utf-8?B?Q0FaR3pocktMbHhBbjFXVlNYdVdSS0hlYlpOWjNjbUNENk5sYUtxcGdOam1r?=
 =?utf-8?B?V2FwRWVKWldST3VJU2l0RS9RRjIydEpwN1ZsQjU3LzBvdHV6ZW9TWVk5Ny8z?=
 =?utf-8?B?dzlpRFdDRS9MWEhhLzZCS0htWU5ibnkvUlc5VjJWZG5oZ0Mwc3hldEdBZWlV?=
 =?utf-8?B?RzVnbU9CT2ZrNDVzVTZsWnFEUHVYdGlJSFlKQmVNZG43cDVMcTRSVVVER0Nh?=
 =?utf-8?B?N0I0RWkvRGxaVHViaGNOL2ZJZFJNZHNIdXVSMUtuNVVmNHNkTmNkSHdKSXll?=
 =?utf-8?B?QmMrOW1nellVT2lKSVdYZURxejlaa0RZMVlLdjZ2SXJDd0FHS0R1K2tweGlj?=
 =?utf-8?B?U3l1eS9xT0lDUStTdStRRjBzaW1sZDhzUHAvOVdiTHFoMG0wUkZRQ1JWSWZR?=
 =?utf-8?B?aERGTnpyUEQxZnlrY2lIVks4RGRoNm9MancwbG1UTGRvZnNUTkZ3VDlRenl3?=
 =?utf-8?Q?B3KVyIIhNTRs1LWY=3D?=
X-Exchange-RoutingPolicyChecked:
	ios+11XA5gOKg+cCGQaRnrLg1MSoI9R5PJqh5dAdVkjp6SWW0OgWnZXx0Ss2PquDLsdqtbtJmh0CEkNhSvT30f18Y+bhPwrtl6360vxa/6GA6ajertTiRDF8OGwsfdKeMis+SgrDcYM/7+2gsujJaPF2Z00OnXntOTbW+0h8e3fqGmJTHcsIYxPSGJ8sl4HkO2jZYBuvWEQHKG8hhjE/0TF83YF6guMJXbh1FWXQqe5rLPWXe48hPnlgvabbmAsyGuezE1YiVi10M9mo6WP5RDRMfE9wGRA8P4+aD4aGCa30a6Et5iMQN+54GuIeXbs9c1EYdX5otkOPS9SwJ15tOQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	buznOzrtnuLWgjzd1hIkq34J6X1y8kDYKh3jEo+fCS3AARFd7bGa3QBJ5XtK+y7LZslqtok2nv3i9BmjixqysxKj3LCV8LKJqSXFAbvTE1avXdD+MK13zQHmZR6/DB3lg4qXSKmTBAoFef2MYpnsLOoWs4Qj9wXPjX60GkD4IKyn0BuR8XxBwxAVew8KHD2nXRn+60C4scDU5yc1B1349qbB/VnZzjii133VDvtouJ3Ck2nfcDZxdoLFbWcvzDx2zc2kxWd4B74kW+4vBxw8hCn0ZBch0J+4wlCc0dDUUsZbspfLmS625yZ2TYVORebzYBnyvbUdQCJAV3AZwqHmiCoDEDWfQh5/1OeXQPe/a+HrZLQ73ZicO9T/P8XIcrrKgxfIlnmgn/HF8CoT4GLsoHJnEl051p62kKq/f5uoy+7WmtpPJ5DA0TRcYHd2k3Amd/kyPPq8FztZsxfsL8Rdf0p34iTAAQbkXgSa5WxMc8Uah0HBfjPrrkdqZLqO1y8OSQBxljT++bu2lZBD53F6sKHsoHEaECXQSGyxTjy/TkQAyQ2+nG1dnUliZMuYc0XIsGfgZY85To0OLgCM/tM4S6eoIEyRSuyfFp150Px1d1Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f98dad-0cfc-45ea-dd20-08de97344aac
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 19:06:38.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPoLtwMzBauKyit0zuFYFBh8V9UrBnqU/hJj/tam0KrMEK9Xh15M5g4g+axFL6tbK4lxSBhwmnJBIjYdhGaoRaTK4d2oeF1xsjbfIxURYXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_05,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDE3OSBTYWx0ZWRfXylIX6is7rpoa
 OZYiO60vfTQ7jDn+aFPvv0jMoAF+tEcfDetXpoNUX+fI3Axizyjs7S54mUqzeouc8akYw9XIl8J
 Hwd6kA1c/XDke0BBcrxO8LbfjO+1PRvxO8bpjEgEYnVwQ9nPXbxp8WL1148KL3w/hKNz4drU9S9
 rW/RUf9UNoKNw9GsyfasH3dL2eaK7IpC4uHHvflRKDEsMgZnAVKgIndrfNQOG8iKs309umlGUtW
 JerabUm6azFp/t3yfVbUJsmyZ6gD1Qd0v+cMPwJulE3wwlOI+Jnzz37z+sdtTIcLGdiGfB6dj/U
 WBYapEHAw77gEdBoL6mnABE4kyRwV/s26LnWs8Q6DKG9k953H+mO4fysb4A2ScZ4ULs4i0E5XUy
 m+4J+D7KIozmnqVjaCsd1RVgW5p5xs4HH0a8cstx8DvXrRh77NSnrG8n/7b6KV0aVA4pv/kU34M
 ab3ccsM1Yl71h+UilNg==
X-Proofpoint-ORIG-GUID: 3KR87sNrWxiJULrZNyPWr1K5hp96Yteo
X-Proofpoint-GUID: 3KR87sNrWxiJULrZNyPWr1K5hp96Yteo
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d94a42 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8
 a=VwQbUJbxAAAA:8 a=SSzsZHljZMg-G_jlsqkA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: AB076C000D
X-Stat-Signature: drt8wu7mrcame63gtcexmsw3f75898q8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775848007-616723
X-HE-Meta: U2FsdGVkX1/+E4ktMarBE8TJ4XYzg/Ah39F8h/0vds382Fh0UnNqdz0fUt6nbgierDYq1ICOu3MFS2HXIRazxyCfe7Dgv9ar8cJshmDfKKxMJelRmWpaTRae7/hb4MddUd3zXDvP2a98eR2c/XPwl44am1Z7W/Kx6O3DTL1riSx/WLA8irRxAVA42JZy5NpBecOjCwIrHlQ3JiStGgOj0i+16Rhcs2bf+0ya//5azwp+3BGidZ+P4MqcaD4iFQSR8i3cu1MPqRq3lTYvp++Uyisb4DQXJ0VsczAVrdqqyYkHDXAfWxNNwd1bFNAGZZ8NFZTJlI8EJUrkV7AVdVvmTHtlzCh9MXcPsDa2QLhlfsZA1OeYO+WuBHxU3asPd5nO+gLSnhNS+RTLG2CjeGkTRMOst+5vygEfA3gClDxJnM99vwFgRR4GrbqxN21OxVa/xfZd8cbxrboYTjjqbx0Lz6tDYT/ZkPEHPAT4cCBfVJkuUrYivVuzxxBEn+APddXQCh9LjTzoHu5fRq19MUMIp3CaGyDWZk2dKNUGrPW4LKBhpstkne9GPvLU6l2ZjVJpJDYd3nOr6MYv7CDafnLmlO2BsxngpsHN0dcXd2wBfKpZQNbXY38zUPJevpMTWyOyV23tsL2Ws0IXMJQgSjAkIFmYTJR19jFJyak60KUAVfePLE2L1S6DjD75ppiiQxY0jn4zQMHYsksXBxrgB2xAOe2DEx8OzG0ReO3SS0abCD8+Ve/M/O29rhkEtVjaggi1zRXMnVqiprIqhBpaHbRJ4rS6zkn5joLc0I1jW32zPfiofAhLfbgoS2EFeoSX/ionCO+8wMWUn8FUl5Bjv9/P0KET8hyO4vPB6HcBPPEhET6/iJE4Ko8+vGVCCk+hipfXcaY6NTg7wXEdEUpJSjsbNJ1NmJ3VtpImK+35GnjXACVEa3XvfuSqsRTRTDTLQFjie8Lspw5Js6nDVZt+CGy
 aWtqcQ9A
 xpYdQD2R7wr9DmJWWXoYxswkbSXPMG4Q4bdPI+H70uLWIQmM3tz0dIjwiQM//DZEJDqor9xAjSypCtzTNSWg2PjXueiKQKaTQkZKeV13DurivgG9j7R81aNhs60tk66PyBf1GJ0l/WBqaT9c4d0lGaBcI5jxUWU2eUGSRAqoYHTz1NyqpzsvlfePIVJu0ffqNmFKtPPlgQCbmYk4H79rlp/KNyiK4JbAJ8LTE5Ae17NFSCHd6zdxelbbeMtE90hkLDz7/WrXzIRM6UaeLF2/MDTpTvucLHmd/xaLRVpsquqw1WLEEmaZulx/QHMMD7epw6FPrdNQDa0ruSkxDPUUuop0K4D8FU7r41LdQ4YKDGmIBKmXX2sqxxLonwj5klCAAS/07niqT8wO6pRwurNYM3MvFKStu8ylC7P2UsZANoz+o+yX3hpYXDo2P509X5seJaKzBCwnIV+G6LopsoWiDeTUqx6ScKdXeoLGlBllTmSMWGnmOPui0oOdIgSag1RaCk+0Uxq3WEH82sgwwfYIFXLykYZLoKDcxlVFS7gtsGqyk95TO8v/qjn598Hm/lL8MqXe2NDDXWDDZMCEDxUC1XJTQUVkDUdnOOGrjT4keuJo0J5M8ig+YM9SJRv77f89yeh4hb4g0we8bPiCU4cAlPtvMrnwc/OgUiEgInTC9spXY7cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/10/26 12:57 AM, David Hildenbrand (Arm) wrote:
> On 4/10/26 01:49, Anthony Yznaga wrote:
>> For configs that support MAP_DROPPABLE verify that a mapping created
>> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
>> be locked if it's created after mlockall(MCL_FUTURE).
>>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>
> [...]
>
>> +
>> +#ifdef MAP_DROPPABLE
>> +/*
>> + * Droppable memory should not be lockable.
>> + */
> Single-line comment.

Okay.


>
>> +static void test_mlock_droppable(void)
>> +{
>> +	char *map;
>> +	unsigned long page_size = getpagesize();
> We could store that in a static global and query it once during main().
> Feel free to keep it as is.
>
>> +
>> +	/*
>> +	 * Ensure MCL_FUTURE is not set.
>> +	 */
> Dito.
>
>> +	if (munlockall()) {
>> +		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
>> +		return;
>> +	}
>> +
>> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>> +	if (map == MAP_FAILED) {
>> +		if (errno == EOPNOTSUPP)
>> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +		else
>> +			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>> +		return;
>> +	}
>> +
>> +	if (mlock2_(map, 2 * page_size, 0))
> Weird, is "mlock2_" actually correct? (not "mlock2") ?

It's correct though mlock2 would also work since it's been in glibc for 
several years now. I just matched the existing tests. mlock2_ is a 
simple wrapper around syscall in tools/testing/selftests/mm/mlock2.h, 
and it was introduced when the mlock2 syscall was introduced. A trailing 
rather than a preceding underscore is...unfortunate.


>
>> +		ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
>> +	else
>> +		ksft_test_result(!unlock_lock_check(map, false),
>> +				"%s: droppable memory not locked\n", __func__);
>> +
>> +	munmap(map, 2 * page_size);
>> +}
>> +
>> +static void test_mlockall_future_droppable(void)
>> +{
>> +	char *map;
>> +	unsigned long page_size = getpagesize();
>> +
>> +	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>> +		ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
>> +		return;
>> +	}
>> +
>> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>> +
>> +	if (map == MAP_FAILED) {
>> +		if (errno == EOPNOTSUPP)
>> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +		else
>> +			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>> +		munlockall();
>> +		return;
>> +	}
>> +
>> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
>> +			__func__);
>> +
>> +	munlockall();
>>   	munmap(map, 2 * page_size);
>>   }
>> +#else
>> +static void test_mlock_droppable(void)
>> +{
>> +	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +}
>> +
>> +static void test_mlockall_future_droppable(void)
>> +{
>> +	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
>> +}
>> +#endif /* MAP_DROPPABLE */
>>   
> Why not a above a
>
> #ifndef MAP_DROPPABLE
> #define MAP_DROPPABLE	0x08
> #endif
>
> instead?

The intent was to skip the tests if compiled with headers where 
MAP_DROPPABLE isn't defined rather than force the value and get EINVAL 
because the kernel doesn't know about it. This way EINVAL can be flagged 
as a test failure and not skipped since it would likely indicate a test 
or kernel bug.


>
>>   static void test_vma_management(bool call_mlock)
>>   {
>> @@ -442,7 +522,7 @@ int main(int argc, char **argv)
>>   
>>   	munmap(map, size);
>>   
>> -	ksft_set_plan(13);
>> +	ksft_set_plan(15);
>>   
>>   	test_mlock_lock();
>>   	test_mlock_onfault();
>> @@ -451,6 +531,8 @@ int main(int argc, char **argv)
>>   	test_lock_onfault_of_present();
>>   	test_vma_management(true);
>>   	test_mlockall();
>> +	test_mlock_droppable();
>> +	test_mlockall_future_droppable();
>>   
>>   	ksft_finished();
>>   }
> Feel free to add
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>


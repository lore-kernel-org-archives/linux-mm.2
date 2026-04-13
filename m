Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D042F531CE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE196B0095; Mon, 13 Apr 2026 17:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5DB6B0096; Mon, 13 Apr 2026 17:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547C16B0098; Mon, 13 Apr 2026 17:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E406B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:54:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5994B7EE2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:54:38 +0000 (UTC)
X-FDA: 84654887436.29.5BC04F5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38CFCC000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:54:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=awvFEU5I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GgxINzyH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776117275; a=rsa-sha256;
	cv=pass;
	b=TR6iV9qwSKEMyWHg6TWt8oGeTY75+pcWGpTBOh+3kb3A/5+wbdt0+bGDG6oavkdBYslzuL
	5bkMLSArHDLFa4eoL8yBr0mFSwTiBvzGayVjRUT5p1XF+UUc8oNm805CjjSY2Z9PFeV72Y
	OYWWJx5OwJS+jyRQM6iGr3y8n8d5jgk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=awvFEU5I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GgxINzyH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776117275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yU2dLyjjt2/5VfLNEmQyCXXYAeGwJnjI9UnoHQI94Js=;
	b=bX5aO/uAmReqMv8M+JGHn+RdJiD1TXRxN+NYlWs20I0iH6s6p33SqGJN9AR4z1QMVup4vy
	3cteRwEiudlnQwiUlnCVEO2vv/Zt71diZMqRpY5V1fZ2BJD6ktjETXmgB5rMoUNtr3uxoK
	h50/agSwW2FOVudfYalU5vUfsZJ2YTo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLDrbG625888;
	Mon, 13 Apr 2026 21:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yU2dLyjjt2/5VfLNEmQyCXXYAeGwJnjI9UnoHQI94Js=; b=
	awvFEU5IvcUkiJlmfZd6de+6C08sE+eKH0VndEq6rPdbz4DFNstmf1a43JZeMMMJ
	FNV7VExAfRgKSz8w1FAKIcGTsQ6pQuojwKTbcO7R04+XTubDFt70qI6j2lz+mJse
	0pnXMGEyvS09g+TygzBvh937KKksoX7yHnulF5ZJYTpSa8Xxppf2SiaLQLHh+YPw
	9mjoB8NJsAwz9FaPo5gLcDz1iXiGUTeSfOt4mV8cniGdGedel+6VmZjBFR3qZuEb
	TuehjM7Ungb+xlcQR/Nfy6RaUpRWGe3wubLNaloC7UT+/Dyq/9hSL13f2JA7uny2
	MEJbMLxKr5VIiRsANA8dyw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h03uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 21:54:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63DLsONX006754;
	Mon, 13 Apr 2026 21:54:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nkm49g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 21:54:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XG57MXupQij8/QSkNjxsxkCN602oKAe5luLLG5f/TjVfBYt21vPJv4BGksrF+BFYz7+oApxcFzC24gu1fcgUcKIyyR2GyWpjuhyVwhTTMMw0oCaS4pIdiaVxFJB27nCUroVQb3RMEXiCxolErc3e/GvR8s2XC5gt793fCCPE9IF+ZGO3E5xQJl+lFKs2zDqAUY+a8FuYBLY+0fFX08FG7VvgTbt2hZkBcAHjnTk5F49FRNQUPS2rddGJVQ9FX80BcNE8HdguiPE1ikx8JhNLurD35+Qq29MYIPsTZtvbzwrbnUUemM5YygNrnryWBg79+GmW3kiOyrkeDjs/LMi35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yU2dLyjjt2/5VfLNEmQyCXXYAeGwJnjI9UnoHQI94Js=;
 b=ezqYdNzNx8t48uC5CL4mtTR6p8aZh5EJ+/aGZltRHwLyZJaXOy4fpGcHmqNJ7OanwifJ8EqVSWxn4o/jcNFYhUUjMjaQK1WH73v7y23CSfwFkJtIT/Z3UZDREBqBstho3EBCDkuAHhZmYb6acXlCnEYa9oQq8Ijio71uwhwiVbGy4r6quk6MS8cKW8GyuqsIbyxp2WvL1Wod9aKjrvSPEjxNuMBYk/Z5y0dmjwbbnPSdh4kFJABQ5uzQ0HHbPqQCgRKbjU02B+yhO/OHHn63TTueU8MejZlfBZSrP/VljLrCQHhNoCbL2AfOlhrfpTqLFBCv6CdJFQsuKPYsEobobA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yU2dLyjjt2/5VfLNEmQyCXXYAeGwJnjI9UnoHQI94Js=;
 b=GgxINzyHgnVq/RgXgceZb2wGLsv4bcDYKkutw71FytJiXlNxUKg8YefQ5b+wqzNJqklblle+bP5y8BGJScrgdyYsz5Kd7z/Et1lw45Vfb83FKF+5pkeifJm6xQGPGBiSZLaCM0Cenp5RQHaprrel06jda8gP2SBL9VxELTJjNIs=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by LV3PR10MB7793.namprd10.prod.outlook.com (2603:10b6:408:1b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 21:54:13 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 21:54:12 +0000
Message-ID: <ae78cbdd-e9b3-4586-b492-89ecffae30fc@oracle.com>
Date: Mon, 13 Apr 2026 14:54:10 -0700
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
 <38fd3d86-f080-4b3a-a931-8ddae1a420ae@oracle.com>
 <b579517c-e739-4db5-ab0b-4db3d579807c@kernel.org>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <b579517c-e739-4db5-ab0b-4db3d579807c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|LV3PR10MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c130780-1a46-4c7a-a3f8-08de99a732d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	IAitnoGNRn4ciJwJpSYzqTOXEgGHJHYUbDn7iyVwaRnThhngPO2T/d9wxvK2Goee9kI9aKQlQ6qgjeVQSSc44l1Bg0HDYkqnJ0MMtG+Z/aQvIKAbXJF3t2Qmtw+0zIBjQuSffOMDD5wZrr0W0GanfyT/mdBaCsAO15NVYBKDj50B7VbJ3UZOy9k6cE2LqwtCotVUeO9E/yveIXRGPxVkRy2hN24Wq491zJi2QxQoi/voOTAaW0Ekud52ZcRWlbeZYNx3ChwfmtXBLbmjTTs0gBPxBX3TV6aZAuIrygXvZrrTQfoR/CVOLJB4CnExLAdB3IX5ruP1h59Wu2geIbYZ/tjxuEzatPcZsiTxJyl/9WNrJhT6r6QQoUMQBl0L5rtWjDBCGfNqZjnME/luEt4H4c6DTGDFRH/dEjA1Kdh5uYnW+KqCJ4eNWRf+PWHt8u2LgW0qormYVWrMg8CJ5qGM6YhLGTFivC0fzRdCxS12R5AmeyfEKsva02uTt8jePSx+Fk8tRk4/gGXqajVy/mG9BoS5A+vGqtTApk1Ecc8glWnsjAwq/n5zZ8dkiCbaqMkHZeMx6q16pMHDS0ET3G4zxxG0qHiO4XVHHDHrtWwOz/C+V5fsyM4m6s263Ene6QmApM31JZzeXUvXCgjoZuwQuxcoU0wxbZFYWNBPQsRFpVhby8gfLuKwWW9P1ZWAenVOW10o70j4a0x6IU6n8d5UyI53nyWNdrIPQCBNvLbN/J0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjFSMm13V1hxVE1mYlFTVy9BSHBrR3Bhb2pnRmRURDRXaTFXSHQ0Y0dHdUVO?=
 =?utf-8?B?SjJibC9iK0JXUTBNV3hBQkY0ekZFeGtJZ1hCWjR2WExMRzJnNFUyKytoZnA3?=
 =?utf-8?B?eXYvZFY4OEdkL0FCUFVXdjlrcndFVzhLRngydkVrVWNhSnBRWmphbjN0NTRV?=
 =?utf-8?B?VUFqUWY3R2h2T3U0emZNOFZZSW5GM0xqVW9rTEJGMktIdUNJZHBvRSt2R21k?=
 =?utf-8?B?TzFMQVozcExJdmFXZEkrUVlOcm5KQjg3Y0x3YUdFTFAxSjJJbXBRS1RqeVV0?=
 =?utf-8?B?TVlzMjJDWEdIK056RU1XMW96OTlRcURaNW4xOTRTQjVtMk9Jd2RvQVRKeVpI?=
 =?utf-8?B?bmxORkJGSHFUY1duWlR6OW5Hc0E1bUtRd28za3Q1N0kzNGZYOWNIQnhDMmdr?=
 =?utf-8?B?UjREb2RqUDhWN2lxNURNUytUNnpBcHlMUUdVWVU2VlkyOGhkNGlENWVsM21O?=
 =?utf-8?B?OERsbmpSekhTcTB2ZlpWZTJzZ0grcEdXU3pCd0xoeGVzcnRRSGZFdlB1WTBm?=
 =?utf-8?B?V3ljUWZ1RjFMbTVnWGJJMXFWaVRCczhHWU41WmUzZFBzd0Q1VVJnUlZJSXBW?=
 =?utf-8?B?UTF0b2ZGMWxaSVhzem5tZHNKQUIybzhPSTlwNVRZQ2JjMlg4a1F4NWExVzEx?=
 =?utf-8?B?bXJEdmhZQTVTRWJMNlYrWE5DcUIvR1NMV1NLWXVNZ1grMFZTOERWUmtvdlU1?=
 =?utf-8?B?KytZMU1BL0FVWDJHZ24vTzhTTy9maWxaeUpvRGh5THNRaURXZ1hqaEh3RzFj?=
 =?utf-8?B?dDQydFI4R3lNUTZIbmVPMFJIcVFxdHQ2SmNXSEFMLzd2QW5vSUpNSFRTekhQ?=
 =?utf-8?B?eDBMME5STG1JbnVZbGpDY3ZVZmNQOXJ2VHJzbHhzNFNLQkJXeW0xa3JzbDZ2?=
 =?utf-8?B?ZVI2Um1MZVBRQXFRWlZ5UnoveG1FUklaMXJkdzVvZmtuNUMzRlZ4ZmJhRVNI?=
 =?utf-8?B?LzdFVDFHV1phdmlBL3BtUFc1cmp2QjI5TTREMldyZis5b0U5RXZXQnNwK2Vk?=
 =?utf-8?B?bWgreVNkUHVRQkZHUElsdHgxd2p2cnNGUzRrZWI0ZWk3STJhY2xnS0kwbmhh?=
 =?utf-8?B?NlgrclIxZVRVYzU5U2pQdHhKZ0pYb1FHMDFSU3ZBdUhYR2sxTlVlYnZET3JI?=
 =?utf-8?B?VzNrUmY0OUFzNlEzY2VOckZLQzhBQm1jQ1hTNXBFNWFPM0ZlT3RxaHY5Tkxl?=
 =?utf-8?B?Sy9rZnRPaUtVZ2dRR1RuR0lmSDBEUXg4eW94WXJTSWtTVnJ3amZhbDFVRkVj?=
 =?utf-8?B?bTdmcC9DM1JvNS9Bcit5bU96Y3ZQeWlFUVdhOW5tWkxPa05DalVUSm4rOVpD?=
 =?utf-8?B?SzRGNlVNREo3eEo4c3VOZlhUTFlPeDJiYWpNYmJuNG1RMkJSQnM3bGV2amh6?=
 =?utf-8?B?SjZXMC9CRjRwRVBHQ1B6eFpIb05nSTk0OVN4YmVyZklwL1o1T2ViZFJjYmpx?=
 =?utf-8?B?cFRrRW1MQlpxOU5WSDdFSksraUhlS0N6d2NadExBeFhML25wRnd0SnRuOVF1?=
 =?utf-8?B?R01QN05KTk9JUTliY1ZmZ1hDMWQreDlJdUQ5QVNqTDlMM0N4ZGJwMWRmOStn?=
 =?utf-8?B?NG9xQS9sNU9qL21oek4rd3pZTXVzZ09wV3FvM3VKTDVCZTVCcCtUVEpNZEZC?=
 =?utf-8?B?UVM3Z3FUOEtod2dHSm1oTXBkejVobHREK0FTamluKzNsZDVIM2VQMHN3d2Y3?=
 =?utf-8?B?SkhZMW1Zd3BlTnlxVnp2Z1VZZnhyS1JWTVNLVFVVZTFjbFBtS3NVbXlLWGJw?=
 =?utf-8?B?d09hbGVtTSs2UlA3Zk1ITVl5Vy9wMmRILzI3Rzh6UU4xRjh5WFdEeU9PVm95?=
 =?utf-8?B?OXBOWjlueXllbHRxcnFESWJpM3JaUzJPUlRJak5ydTBNVDAvVkEwYzhtTlBk?=
 =?utf-8?B?QzgzUUZDdmgvVnZwM2JoWlFUNDIybmxKdm1DY0FXQ2tPdDNoVktsdHZVZTRT?=
 =?utf-8?B?M054V200SzVZNnVPaVlwR0tyQURmdWNFRExVQ2Y2eGU5Y2tmYzMxWUNXNWZn?=
 =?utf-8?B?US9kK3VtUlltWW56aVAxTFFPQmxFYnZoVkp1cTd0YURuK004dWY5aXVUUTNN?=
 =?utf-8?B?ZkY1R1IzS01BWW0zZ2NiZUd6VnRKUldGR2NNRE13UERIZC9YdHA5QTZ5TUlz?=
 =?utf-8?B?Y2ZQOGUyQTZ5Z3dpaTVFeHkxdnQrek55OGIwaFNnNDlnRzY3NTBEaCttMVFm?=
 =?utf-8?B?S3J5NklPRWdnVEVHRHAzdWFVNFdXTFBCK3YwbFQvMHkybSt0dlNaWnpmNzE0?=
 =?utf-8?B?bnpQMmljdDJMNmkxTUlPdVNETnNsTGhIZWlGUlRRa0VHWXV5dTRMNUFzRGtT?=
 =?utf-8?B?ZEt3QXdSVzBNQklaL1c0VDVTa3d1ZWJyMHErL3I0U1dRQkZVeFdXUnc2QTNh?=
 =?utf-8?Q?cDnDC5RLT8g41Ykc=3D?=
X-Exchange-RoutingPolicyChecked:
	ujUjaRnhOUuA25tyTU4mFBxFsAubgl23evvIeJJq0JuMYdVTQQDWppfsTZhhebn4tyx/za3FUZmTuhs6uXJUDNVAKBOS1IrWTkU2Oi5GWncDpJymDPaoC03EfbUMk0Y+67swGcWNIjTYEbbaR795KA1Gf5YXSQRjdvM8lJIE+ZtUnAeA02Ek9+hFC37/L1z5plhZu0REIjmuTiPSC/SsjVLndMONVDLayr3mJYGeXRnC7+e0aTSUcFwZNQavGpYLUPIeLhNDh4LntKMH2HUgGZc0Mi3lFCPBPY3Y18xcSXTuNn7LjpiYPvOSDbqMy0x3lGcrxwmTkV65+3CZ/LAFXQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SKBfH8XjgScyXRH+GaPPSJB6Kb5xlvdcc874ZRh7rjT7aRFrbj5rjjmT6Usjo0yIIGBVu2fY/K0L0U+ldFZvO+piB4NnA2vI306kiCOe9RncLo0rbaLQLVWBD3j1jljriRzMe8Dhqga96VgcijWvUvEyezdbILFZyKmyK08iK/N1ZR65n8ASgIBvY0LF0V5Q3VMMBFIkFVhhJ7kGGtPCVgrqXM4V4evEpYeqOxBSK0M8W1wGWFJTDJMuxkBynIiYD1epWhQLkA04p+rVt/fARLJPKQH7SbTWp/D+FO3IJjYejq68sQ3W4M/3h9fH8IMNDxVRUBzCO7+OKah1T8QkhY1dRvdsZ410FWhGVqnB1iULQ1japDIDDaM85/PzvovycCkKoPsmNqz28Sj0Se0VHdCgfGPZniTMmEuLwzaOJl/BpeueFeCh4THuj+RtCNYu7bk+e83x6RG5D3IhAYdyhW0SZbWUMetaB054LhsODXEuCxnG7jBeB4mrGF7pzcz2PxszzySHHsFhJAyUYm9uwq1Z99ZuaeQDBFLKq3y0otKvKxnOL5VZj/GBChtwDsUlo7QuVhAVcfhZHlm4yh0gNOCb8jF0deAc34SomzoQOEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c130780-1a46-4c7a-a3f8-08de99a732d8
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 21:54:12.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGvkcqx/ulu92du0E750V6eRwclU48R5gepqeKc/4JiX30kSQr0hNpLwEPW4ML/70JcowdMK45vHaM+ojQ4N5DpMkhVbp1gmOjfZN54thJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=977 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604130215
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69dd6615 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=wCZePbCpYZAVLJ1YhCQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13825
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDIxNSBTYWx0ZWRfX+tA7N0I7/p5S
 lPpiq1YMkwO4blcKFFDmHX2AGFE2vZulDEYHRNH9//zYdylQGqBmJdfx9pzLsqx+3TseExKEKYJ
 zRu5q/N7ukyIw6JiXG7zjRI+t/7MX7YdLqFMViO0b1hDvv68tu694U0h/vR1/c8cfSuErsf5UBm
 N/xZgXdDLFuejHyZthbe9rxh3zZVyIQUVtRpH8CQQz2L8/g7oAAyXTuslAVvDrT4a8xJzoHKGrp
 JDObTeNduoYNCMiTon7MdEAyAnrcreQm9qQfh9N7EP3tyJHXaglNjGsg07/82mViqGOGuV67sTi
 nPhZThxjeQkfq6kxnZ79zSOdxSrCW2nwhYkOH7TXFhDAQjjVp/K93f+6LnOrIq+FpN6SJyM7W5M
 EpRZJoO/xtQJXQBTbG2oOYls+oEYJnRmYlcJxW/VOEWiSC8sBd9hSlt+lo/Zb5PlyOqsm1g6OOs
 +mSa7LVc2lxTWvlTiFjs1Ukon3KgatUg6acsCMFY=
X-Proofpoint-ORIG-GUID: 4oj6wwiLJxeZa8V4gjMsn6X544C-jlh_
X-Proofpoint-GUID: 4oj6wwiLJxeZa8V4gjMsn6X544C-jlh_
X-Rspamd-Queue-Id: 38CFCC000C
X-Stat-Signature: 1ffpgdoxzatmq9xoyyuw55jjsfnqrb3s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776117275-781935
X-HE-Meta: U2FsdGVkX18kiZ3WegjomKpTrtBvrk/EQ8qZpRnb0epH9RsNrnWCAACk4/X4JkxTIE9HLmU4gxjdTXbIlK1UfvHPj0o61lBmVww17smixwsZmBublo5M4c6dTh99YTRRbrRX8R/ophaX/vT/llx6i5YkRsTKAMJmOVWPnxvZSfP2Q6B4OpRckozLdOtFpLwodsLSKJWtBiL7QnlIbFBNhvWdKtJ/MxDYLKODdM9e0TzLi+ImaczJnnRnxrwp1CPae6T9zXscg/681hDk9SLY+nBnZu/sxX5V9v6Ypc/SqyBcqQ1TVEqnc/K2iPvN5q6kB2EO4UJ2D4HzAlX59bZdBRgAVnVERAHJFZDx7Vo4pV/BzcWfXRmM+NAsCjW+yHIyTENMzNWNlcZIS4fz6WNJT0CURV8Y/nIAUxjnNfphuXQ5kIoXj4YASatYkGKFBLdDCxpsegxZvKfvaHbTGzf4doITvZK0tU0LR81bdUnOP7LbjJ1vR0tR+HTnEFLCiMS1ZQMwY24LTQZalF5kS1dGnj/qZ3e1t/UVOcbPhJvRwx18Jp2ZrV98e4X9KlhSm5SUqkzR91iI01MAarbFSnntd5n4KKpqQDRF/GgZCZ8NDTROjwh/unlHworAcTjTmfrdfTI/WmKoN7oJwr+mwa7v270GSIUqNTQ+HFWLhZ/hbCiIGc4JfrNT3m1rHr3u4YfOZVNQZ9g2gwA0zxQjp7RptVq9pn/W1g7NblNHeuX5fLuhUkE359+BlwR1yEJBpRpEB6A2sdkU6MxL6Shl+CpGtC/sT5ocIr6RxxWpKuz6sasE3oKxec/RANuW4vcD9amezFVj9jsyNGarFqGx7kf51IzHoRVqPtSMKebRS1RQwrA7NY/aA4C3yX4gAmkUKx1bu8IseDP4+tqzKCRwYIC1hmR6/3GAnZG36y+tjN8xI7/jHkkxyVrcVfWTPpymLUulwEb7k+5iT/aiXH1jLpg
 5Rspklbe
 t4RGwKwp1Jo5/t2M92oINNRHsS/1D+4RAZFLwz66Wx9aGF9if3u9uZ5vGX6kQvAebbqKHVGnEkeZC/JqQMQyTvgx8ow4l9H31RUQRs5ISLabZsTlURZfDxzqZ7owLdpTFWiUA4V9y+awsIRHZj7SRbAGXpl9EYdqGGT1zA/6XY6YcauXkDPY986ePG8fwTC6/v/hyG7L6onotff5tq5U0Y4zM+O3Hb6asFeCeKQaVIEBJzTZOH8Z+rJmc8uzFwk+eW/PMnCsTN3TahMKa0q2nD7FJ24/ZQrO7KuZPPZj4w5TadQlaMQP5X0r4WL0qLOzEFpFcmF0NpGHl7X9HcLYUelLSz6eXdhzhCN7esY6qcxFof0ohPBmVs2OgVkgBQadgGtP0CyW12OX0KuuLv/2ZZNxsrhISR4jzAPhNIUIs33m5nVtABeayazyf+6qBFBSVOLViCmaD8GyOVrVGC4CVMZKr0+9/EqBr3vRU7WKHcLN3pVQ2wI97NwGJmIgqwgFJI49WxjqL//iGXqL8qX5e+SBb0bopFlwLbVpSXFPEYwXMWSLXMjm19iNZvb9tqf37KMpvG2N86zOnDX4sVcYMj18ZQ3JryWqylXenudrAN0iLXfZKeDd+WB6m5VnyLupDoa+lqzViIxm9owm95D5+6iKiyBL50PUZnuObZnff+qyAXudnyPxd4mkorfi0//zZ7Vkmvh3JbpcX45nU4PvbVrqp1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/13/26 12:46 PM, David Hildenbrand (Arm) wrote:
>>>> +    if (munlockall()) {
>>>> +        ksft_test_result_fail("munlockall() %s\n", strerror(errno));
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>>>> +           MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>>>> +    if (map == MAP_FAILED) {
>>>> +        if (errno == EOPNOTSUPP)
>>>> +            ksft_test_result_skip("%s: MAP_DROPPABLE not
>>>> supported\n", __func__);
>>>> +        else
>>>> +            ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    if (mlock2_(map, 2 * page_size, 0))
>>> Weird, is "mlock2_" actually correct? (not "mlock2") ?
>> It's correct though mlock2 would also work since it's been in glibc for
>> several years now. I just matched the existing tests. mlock2_ is a
>> simple wrapper around syscall in tools/testing/selftests/mm/mlock2.h,
>> and it was introduced when the mlock2 syscall was introduced. A trailing
>> rather than a preceding underscore is...unfortunate.
> Interesting ... and confusing :)
>
>>
>>>> +        ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
>>>> +    else
>>>> +        ksft_test_result(!unlock_lock_check(map, false),
>>>> +                "%s: droppable memory not locked\n", __func__);
>>>> +
>>>> +    munmap(map, 2 * page_size);
>>>> +}
>>>> +
>>>> +static void test_mlockall_future_droppable(void)
>>>> +{
>>>> +    char *map;
>>>> +    unsigned long page_size = getpagesize();
>>>> +
>>>> +    if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>>>> +        ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE):
>>>> %s\n", strerror(errno));
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
>>>> +           MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
>>>> +
>>>> +    if (map == MAP_FAILED) {
>>>> +        if (errno == EOPNOTSUPP)
>>>> +            ksft_test_result_skip("%s: MAP_DROPPABLE not
>>>> supported\n", __func__);
>>>> +        else
>>>> +            ksft_test_result_fail("mmap error: %s\n", strerror(errno));
>>>> +        munlockall();
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    ksft_test_result(!unlock_lock_check(map, false), "%s: droppable
>>>> memory not locked\n",
>>>> +            __func__);
>>>> +
>>>> +    munlockall();
>>>>        munmap(map, 2 * page_size);
>>>>    }
>>>> +#else
>>>> +static void test_mlock_droppable(void)
>>>> +{
>>>> +    ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n",
>>>> __func__);
>>>> +}
>>>> +
>>>> +static void test_mlockall_future_droppable(void)
>>>> +{
>>>> +    ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n",
>>>> __func__);
>>>> +}
>>>> +#endif /* MAP_DROPPABLE */
>>>>    
>>> Why not a above a
>>>
>>> #ifndef MAP_DROPPABLE
>>> #define MAP_DROPPABLE    0x08
>>> #endif
>>>
>>> instead?
>> The intent was to skip the tests if compiled with headers where
>> MAP_DROPPABLE isn't defined rather than force the value and get EINVAL
>> because the kernel doesn't know about it. This way EINVAL can be flagged
>> as a test failure and not skipped since it would likely indicate a test
>> or kernel bug.
> Note that the kernel headers you are compiling against don't imply
> anything about the kernel that is actually running! So the argument
> regarding EINVAL doesn't really hold.

Yes, I see that now.


>
> But note that we, in general, try to compile against the in-tree headers.
>
> See
>
> commit 75d60eb30daafb966db0e45f38e4cdeb5e5ed79c
> Author: Lorenzo Stoakes <ljs@kernel.org>
> Date:   Mon Oct 28 14:13:30 2024 +0000
>
>      tools: testing: update tools UAPI header for mman-common.h
>
>      Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.
>
> And looking into it, I already see MAP_DROPPABLE there as well, so is
> any special handling here even needed?
>
I'd say no special handling is needed. If this test is compiled on with 
a kernel that has MAP_DROPPABLE but run on an older kernel without 
MAP_DROPPABLE, should it fail? Or should it interpret the EINVAL as a 
sufficient reason to assume MAP_DROPPABLE is not supported and to skip 
the result? My current thinking is it should fail because the EINVAL 
could have another cause.




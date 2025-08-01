Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF61C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 20:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981F26B007B; Fri,  1 Aug 2025 16:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B156B0089; Fri,  1 Aug 2025 16:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBB16B008A; Fri,  1 Aug 2025 16:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 688E26B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:18:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E65CCC0184
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:18:31 +0000 (UTC)
X-FDA: 83729301222.06.E84F6FA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 400B7180004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:18:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LGWN5b95;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MehWnvSK;
	spf=pass (imf16.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754079508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCN/xTOJ0YOq4YjT+VYCUXNKLMzRU1Kkg+mNWJQm0p4=;
	b=ziWOyYlxOBM8pGYEg4mCK/mwY+gNqJATyZY9byRGWrqjEQFGS8Gz2m5LwTO7c5LTZssegV
	4QYzxzRwQqF4m/qbcB926Whe7JZksgl8frdcqpeT7imVTRwiDVTjTbMIQNTK2LuPXOe5Fq
	girfx9M3l0LL089aKwnKzo4HmhGAd9I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LGWN5b95;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MehWnvSK;
	spf=pass (imf16.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754079508; a=rsa-sha256;
	cv=pass;
	b=Ab4fSQZl1D+79xgmKLka8hKMD3vZMKDEghwwbejhyeMKIZ2P01G8pZX+wAsNDFN5nCXhv7
	HJ/j8QG5n31eFLdVCN1NOZgj+Ym/RXFbkuKVVKGDzR8f7rNUD9MuZ7K+63tQovu2VNiVzj
	BdKW+ghoWxY0+XuNCmq5A1vJkQ8JPRU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571Hu8EP032657;
	Fri, 1 Aug 2025 20:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FCN/xTOJ0YOq4YjT+VYCUXNKLMzRU1Kkg+mNWJQm0p4=; b=
	LGWN5b95v/r8Xr3Z0fSKXsB3QUVyH63lmTje3y0wxABd4dSGWiRuDT1x8vlkxH4N
	DRFgr9SILu0O1fNv/8mGYvqmTiLCAsVGoQsUXzTjp8ZG4OIhEsa4QtVGHSrHmPPg
	d2KducvpSqyxGndFjodBgHxJpWzD2WmaE7fDUnLQldkBpxQPEvh+b1yxDlU8dM8m
	X8V63Ol5LM9EFb5hvLRRNX9cNXVOrDKyvvvELAtLzxxU//Bso5wm8uBK2Qz4ctkD
	FG24leZUv3zuCZUxMiBqzyRzOzpkgodgNa85u9IQL1WzSWgYR/udPZpWXZu2DIqi
	KDGy/cTbeqejBAM8/UCa3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484qjwy216-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 20:18:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 571IVGw2035146;
	Fri, 1 Aug 2025 20:18:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfeep2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 20:18:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DItLvxUqcqxXT6Ws4Wr8BIroa3cEdJXUAtOnJxdLogrtoCaYAZsCZqmVaZj98jqGV0cWQh29QRPblQezSZfvfm9Sb1b68jGlc83O3m3eC+sXaxPlzi2ROCzEEGQCXMT/Kj1GGH1kZ5iz9cASYkBV0ipV4UCfNoU+ZzswwqyuWVZ5GTLRdA/m54OyVa7SM86CkOfN/50DAWgv21rftlAAphcDjoSNqawxpCjH8SoJPAZVPctTaK5XffHrYrBZXwBbBN0Sf9d3dS9HYI6SNJTXoGL1RFvvdO5CiNoynelBkJhA9pg0lUEfznTAbmL5uAJlNVrjJEOrkBgKiIA5U+BJEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCN/xTOJ0YOq4YjT+VYCUXNKLMzRU1Kkg+mNWJQm0p4=;
 b=W1hmh6aizfsmkMH3BRbz/jTGyOIc0SVRii6awvzU+mTWkN5HdXeohvuzBn2bY1I5kv7EFrpW1+jLVC0XyFWnft61McwtcB2jEUUP9vqxaYgPRO54UWPlUNg6VDvHOzWvXOSKGWB8BX0c+6ITrrpQQTcToIdexRy1DgSwYd6LNpddc0rPwgUBYHAIwFO/mGZ1UZdwG02drTR3fMansWIVoVp1OZZP9Y7gsh9X3QjBllDmRZEu46vhe9Kl4j4Een+MXKzuT91tecJNEeg4vS2dRSjoDfXoH4lhBsXvI/1ubnB8AifKKb4JYdNceb9jHnj92KFwhTKxfwsiRISNxNJAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCN/xTOJ0YOq4YjT+VYCUXNKLMzRU1Kkg+mNWJQm0p4=;
 b=MehWnvSKlojhjHqzV3Vx56VQWgpZR/PeVYuA2QPAPUJ+Mj3LVAz1GUN7D5UcHAltFmEH3T2/Exs28hvfQtflXZw2awNS+UgDEtWhBTXFpzXefyQD66zE8yBxpsgBWeKMu5OOoO/Xl9n2QM2YNQ1i7RlNMJuxD34BSdan0tmc3Fk=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by BN0PR10MB4856.namprd10.prod.outlook.com (2603:10b6:408:12b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 20:17:50 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.015; Fri, 1 Aug 2025
 20:17:49 +0000
Message-ID: <23cfeef5-8e3e-4ac9-85e1-03571ec820b5@oracle.com>
Date: Fri, 1 Aug 2025 16:17:45 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/nommu: convert kobjsize() to folios
To: SeongJae Park <sj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, willy@infradead.org, vbabka@suse.cz,
        jannh@google.com, pfalcato@suse.de, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com
References: <20250801193537.1149-1-sj@kernel.org>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250801193537.1149-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::34) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|BN0PR10MB4856:EE_
X-MS-Office365-Filtering-Correlation-Id: abffde44-2786-4769-820a-08ddd1387c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3h6ZjRodDFVOUEyRjNXS3ZsTXJhb0VCckcwZjZ6MWdEZE92b3RqKzkzR1pG?=
 =?utf-8?B?dzdHZVpSVXplNVV0S3Z4VkQvNkJxeW9kcWdsdWxXbWVoUHBhcUVYc2ZESjN0?=
 =?utf-8?B?cFpPZXdGV0xJam9iSVc2MFFYeUZPTFFOQmp6NE5IZWQvblVaOG14T1htNUlm?=
 =?utf-8?B?SFc1KzBXNk14TEhmWDNCK204cFd2MzBWSEQvVXlEZ1hEcmhrcGdKMzBkNENJ?=
 =?utf-8?B?OGVINS9USDJ3RCtFclJSV1FmaG4yZlNlSTIxSFJBM09TYm80bVJUZUVLTEJU?=
 =?utf-8?B?RjlUYmlXblRkUlZLQzJVVExSb1FrOGVGYVVVVEs2enhtVnh4eFhHY0xJNzFV?=
 =?utf-8?B?MXpsQ0FBNFBrdWRJeGNndkhubjhqd2dNYjZGNHgxWkNZdDlSdTJ1VDJsZ25Z?=
 =?utf-8?B?MFVnL3JieXZMNnhuTnZZeHF4bUFJUUdoeXE5VVZDZkltR1ViQ0hTVUdzSkth?=
 =?utf-8?B?ck5rNWQrbGVwVENDZVZLa3Npa2htdHBnWi91ODJMeTIwWjhVbUhOcDVQU1BP?=
 =?utf-8?B?d0dLL1lKWTA0NDhxbjBERURxbzh2dTNITW56bUtsWFdqQnMzYVNqWkRXOXhK?=
 =?utf-8?B?cEg5YXB6d01Ic2RqMlRTTDdSZnM4dTJOc3ZEY1pyelNXVTZ0QWJiQjh3NEV4?=
 =?utf-8?B?a2VHOW1CcGJHekIrNkZMSWVQTTNxaktYRHJGTWg0Y2lvNGhEWTgrQ2hoajNS?=
 =?utf-8?B?RUYwbVZyc2xLUGkvRUE1aDlQZ0NBa2cxaDc3ZnB6S3NFdkQvZlB5c2drUzNl?=
 =?utf-8?B?Qi9LWFUvMS9iUTFhZGJacGEzT2U4c044d0hpZFFINXdXWEt0dUI5eVhEUnFj?=
 =?utf-8?B?NFgwcXJuZUFnRlplNWtJK2tXVXYxK1VrZnBmeExoYjlOaVFkdXpYcnZtOW80?=
 =?utf-8?B?cUYyR0xSNnQvSEM1cUZjYnZGQ1FnNjFPWXFVaHBycWs2dURPOGluNG5CUjVO?=
 =?utf-8?B?TnZQeGJ6NURUNVdnaWdZRHI0M213d3RqU2lyY2c4d2l1WCt3TE12TWF3Sytk?=
 =?utf-8?B?bFFvOFZUOG1oSmtMS1R1Nm5QY3FJR21jU3E0MXA3R3dHMFA2REhVTERhOUZ4?=
 =?utf-8?B?SFNpUGxjdExFUmdQeFV5QkVET3NnUmpoYUljSlpEam80ZHE0c01MNW5oRjZF?=
 =?utf-8?B?ZVdtZGRjWHFkVjBEOEVWeFhZSjMxa3JFV1Z3eXF6QklnbFZraHJjbzlISGxM?=
 =?utf-8?B?eG11VjZVeVpLMXQ3ZStDUU5qUk9SV3RCcUo5R1IvbGh4TjNMbnhZWFNudUVZ?=
 =?utf-8?B?d3BSQW4yT1ptQy8vWnVqQ0Jxd3pNZ3ZpNXpMZExvcUROSjRsZFk3V3BvUklI?=
 =?utf-8?B?UkFtV3FPZ29OMjJVdW5lUEEwSW5vaGdwUy9kbzFuU1NLYVhTU3pGWW5IT0Yr?=
 =?utf-8?B?TUNQL3ZaTHVBKzhZanJSUmlXbjJuanhTMXgvUjFWRk9LcFhsV2V5TUFxT3k0?=
 =?utf-8?B?ejU4ZTg0TG85UDk5cW8wMkE1M05DMDc5ajBSZjhCK0t4REpOUDJyR0h1dlJK?=
 =?utf-8?B?cWs1aU5oM3AvTHlzVzRNdUFKQVVBUk9pODdFWjNxTmJHdG0rNUhWV3ZxTzVl?=
 =?utf-8?B?V2UzZ25paFNOaXVDR1UwUFlBVnp3REtZd29ldEkyL0RHRXl4dzhqYk9McjYx?=
 =?utf-8?B?MDJOMzQzVmRmTEluMnp1Vy9JZ3pTemJXM3ZXOCtzbjNaMHlqQVhlQTl6S0w3?=
 =?utf-8?B?VFFQOUZzZnZTTFlLMzhMcEZkMThjYUdFSWxyYkI5ekFEMVpzdjZCQTZFQkdT?=
 =?utf-8?B?b0txS0xBS3Q1M0lQQVhoVTZ6N3Bnc2VXWW1YeDcvbWdCVTY2bFFWTmlsTXJO?=
 =?utf-8?B?QncvZ2tLeGlFOG42T2ZqUWJHTnpTODdNWm8vVE56bWVPb0FFQm5LbCthdWEy?=
 =?utf-8?B?TzdlNkNLSDdNOUNWMXptcXpVeVVGSlNUY0x4R0g3ZzdNRmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXBzV3NiTER0TTdLcDNldVdhWkcwWTYwRjRsQTg0bHV4NEhpS21PUUw0ZzdL?=
 =?utf-8?B?N251cHZwemo5ZmZFT1FFVXM5T1BrRUp5OWpYUE93QVd1UE5oOXczdHM2NG5y?=
 =?utf-8?B?K2lwalEyNVVkekNlZlA1QSt5T25zZjF4UWVPUWVJV0ZRQzNCekZyTllseCtm?=
 =?utf-8?B?SDR3SUc4WEFiOXZYVmN4WWxtNG1wQVJCWGRpRGlzMWx2bGIzTnIyWERaNlE2?=
 =?utf-8?B?T3Z3em8rcU9zMjhTQjVldTdyL0RiKzgrKzA1QURUU1V4d29PL3FmODBueUY2?=
 =?utf-8?B?Q1RKdWlmNmo4S1gxU2I4Vittc0pPeVF0cTY0OWRTWmlUUlkwSzdzZGtEWjZj?=
 =?utf-8?B?MkpXZVc4Tmpyb1liNWI5TWhrTEo2SVB4dUs4eEdKeHhuVERxYnZGamFlNlQw?=
 =?utf-8?B?a2xOQ3BveG95dmE5UFFXd0NXUnduRkdsVEk3QmZ3cDYwdTBKK2VVNE92cU53?=
 =?utf-8?B?dVJDdHJwOGhPZUgrblprZU9mOEtLOE55ck1nZjUzbVBxU2pucjRWTWcrS1dW?=
 =?utf-8?B?U1BIOVI0dmhnVG1Zak5QZFJYeUJjOG9kQ2RJRFNPMVllSU5JYTZVa05nUkpZ?=
 =?utf-8?B?bHpaS3E3QWVyc0VyVmR2ZU9Na3dOMEl6REVTTHI0RmhkWXlUWmF2NmJrbnhZ?=
 =?utf-8?B?dWhRZkpVeFd5dGJqYzRlbnRJTjFob1pOakQ0M2U0V1BzN2QrakxKVXFFRVJJ?=
 =?utf-8?B?QlYyOC8zUlRiZHBtYk9EL2p3UWhja0ZEQS9vaVRENjJWSFVIWWt2RGVCdU10?=
 =?utf-8?B?MEhZa2M5aUxwTVozWUZyZ3NTR01idm9WbnFyVG12YVFZR09wUGxCM2VrY0FE?=
 =?utf-8?B?aU9IZzNjWXFOcHFnV3BCWWI1bnJ2aGFxdXljNU56dlRnS05xU0VqUWlMbjJs?=
 =?utf-8?B?MjdHbktSZ2s1YjQrVUNtSTQ1WWZDd3FmZ2NxaXgybWYwcUh0SWFndThIaGEz?=
 =?utf-8?B?czJxamVqd1h0MGJ4a2k0QkMxTG5id2lxblBzY0p6OHlrbndiVVRhbFhERk5O?=
 =?utf-8?B?U0VWdjAvSHNJbkM1a2FtK1lTWnJlMm1RZXF3UzJPYytkNGJ0N3pJbmVuZmNX?=
 =?utf-8?B?V0dSZkpKM1JzS1QvZVlQSWp5WnZiOWtSM1ZheU1vbjdzV2lZU0NBTnFGdi9h?=
 =?utf-8?B?OEovdk1EeTgyMVZmajl3SncwRVo4QjZaUytlMXlYenIrQTE2c3cwQTN0czg0?=
 =?utf-8?B?Z0tEaDNpTDlkRkRkR1FnTFNxdEsxb2hxUmxPcFhpRTl0elE0Q1VSMS9rZDQx?=
 =?utf-8?B?TnU4dGt5cnhTK0ZQNk9GSWJ1WXlhZ1VTYk9WaXBseWV2Ry9uMkJEdkNvY1JU?=
 =?utf-8?B?Sk91L05pWEVmRjNEODZ5WE5EYzVqRVBWL2ZodHpFd0pLNVc0REJreDFuS3JZ?=
 =?utf-8?B?c3RqMVZibU9mbklUNVdxK2lKVUdSTFNtUG9DU2hIT083bGVCRWhSNmNjbkVm?=
 =?utf-8?B?L3JyQjdUai9mSERkUUFNVDdJd2UyczFYZW9QR3c1cmZRZUZkUlRYMTlrV21s?=
 =?utf-8?B?ZFRzQW0wdk1CR2s0RExSaHQzWXlycnJ6SjR3cCt2YTNFMk9uUXlPTFJBSktV?=
 =?utf-8?B?ak9WTldwSW1oZytDR0VKNW5JUGRtNGp4dHdlb2xKZEJNL2dBN2M4NUZXaW91?=
 =?utf-8?B?dmZMdW5hMVBLN1lvWWIrMmlrMFAxVjQ5cVFsL0pma2t6cWhxNFRCcnQvVlZh?=
 =?utf-8?B?UWFlQnllL2dLb1lxNUFUTVIrNllvRUNpYUphbzJ1N0lwRHNVeVRDbE5POEdP?=
 =?utf-8?B?azZua215VmhOVE1GbmhuOFF6SEtHZXVGREtuMXJzWGZKcGFyNDY1QTR1bEJG?=
 =?utf-8?B?STJFcHhFRFNzcHJ3UzNha0tJNWRjM2swbFYrYWl0K1BxRHZFN0dCUHhkRGpo?=
 =?utf-8?B?Y0pCd2g4bmVqd2pIYW55OUtGWlg3YnhYUExNQjBMZ095ek92SmVFM2F0dDRB?=
 =?utf-8?B?ZWdkZWJWWXJpTzUySzZCcDV2dFVMdDByd1dIaElheDhJSnF1eVJJN0pTbklN?=
 =?utf-8?B?V2duMERVZUUySUNMOXd0R3hwdmlRa3BCU01Nbm1rd0cyVkdHbWRkdG0zeTkx?=
 =?utf-8?B?R2FJMFpDeWxablhSWWhObVl0eStVUnpHRDh0dHZJc0RycG4vN1RGTzdHejFt?=
 =?utf-8?B?c1ZaRkFNRW5LTi9lSUQwWjhtTFZJTDFKRmxLYkJtRG9kV1JYSzJxdmwxVHpY?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lR7W/QmH2OrhB3RLXSH+94otaQFwuqSKlwCFL6KfYRCN9IwDhIKhbHkbxyMOWcbxsM86jP75luMwt1KZe+JrQB1qNDF9H03Vgzxb2TgoV05Zv57bjuTV71JvGsgx4L2FEVQ3pfWvOTe4TeKqGyosoQcYSCCB5MDmj5AQFjVQIdCHRRzYD+k9EQtvhCWvov7d6dSNbBjII66DA9huVEdCcNVThCOgNZ8ek9feaiSB2vcEos8jN8KMNwZC9n5+d2YUBKyylheVvs/11xHtkThiIpHGrvoT/9g9uimU0QR2vJFyKrb6w10CDSb2IYP3JP/zgtbCnQdBsrrq0jMJEtzvlf6i0LbjZUP/ixu48exRYlPIe/WpdsbVL3TnKK7Sw10kpACrAQGQTK1Xzm5TXGH1sL3RSCEZOG5Ogox6uGSnxc0GwycckMFUy79qPtZo1A1JTyTfBtoVFNKtIcPeDyFe+xAT5IydJFTQlhI/EbTeFXTeM+4ctzB6EwytfWgbAbB4ZWPID0FLnfuAQ9D24VYE7ZR6miwwro2umDQ+Mqjd8cflnUtAlUo4k25To8Do60u6dPF5Zzmqarpz2B/O5odBRpf5DsO0Mc1w5g2yU/2qnc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abffde44-2786-4769-820a-08ddd1387c90
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 20:17:49.8231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Za3SatQ0JvxebnIIQ/QcIGf+2jVMmT4+reiYvxrUUsuIs1Qv0Z8eF7OhfwWuyyFq/WtLSKIanC8XIdw8Y/Qm4/CtiHGZUf9+oeRFQBTd/v8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_07,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508010161
X-Authority-Analysis: v=2.4 cv=OvdPyz/t c=1 sm=1 tr=0 ts=688d210b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=t8AlY5CqFy5a7hh7ziEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cRVpzyCLvzTFcizNFAHX1_SgdgimmvGQ
X-Proofpoint-ORIG-GUID: cRVpzyCLvzTFcizNFAHX1_SgdgimmvGQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDE2MSBTYWx0ZWRfX4B7cvYhy1KqC
 7O9DGT2s9WKo4xbS2tmVSpKh0BHto9lgUqSa2JLc11KRp/rDJMckTwXdwIFgNCvMW/kopq9EOvV
 DjostTGzS45CtFF8QMnF2nKrG3wU2xkvgPlFhlItabEDxICb3UC1H+dA8Y0fC968ZJTPGnXcvgs
 Afp0Ehw6dxupRusfmDcFF7rVqxv1WLcgmxBMjdIk9R8L6Lm8k0fqkGNnPwG+0DgFjaVTpCkHkrI
 +gcGH1Okz0764i8+CkmkDNYmHIhpB9y6y2Q6KIr/ddGBb9+u5xA6qY4HU5sGHjL8763H9OLeHRA
 eeHhIdwmPRc3ANN/TMJfqZSXVgdGwtNWfBaOhoFxJktAncMPsiFAs29x2kOs38arzvXMIcvKgSJ
 S44hyh9A4fLhlqKC5YL8BCbsfCurSM6DMDSqmuy5v5RWPzprSTnLUWRZ/MqvzYA9eULRpjiy
X-Stat-Signature: msugkin33wgy5y1y49f1mmnwjk99ba5r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 400B7180004
X-Rspam-User: 
X-HE-Tag: 1754079507-818357
X-HE-Meta: U2FsdGVkX1++OecKJlpZdYIw0ucOMps7s/dTGEFKbvFpL8SUipoKT4b5ythhFoJO8bD1fAhBjz+IUbzG/SJLkYT/vzdiSSc+0vYr2T57JmlMF6a7eviS4HF/o7QLz5V9mlhGFxMcXtOfVePr59ZZCj5R/fSpUQac09f77HFASEWn52FG6lAnhLDHW4r3YAtkn8c0RSHV+/seQawhbdUJAowliV0IPkPjwNXfDwV/u+LkauQqJtodSE5KljbWsH0ZUvqAucOmpUwf10X8QI+XbbwEd4DEvYn1MAMJPkJAH9FrS01H3y0vu/XrI3WYU3SwUUG1JGGOoQS/+/vxidG0Q+rz85fcu4cOU4tPk+MMvhoBtgHul9rVv3JugEwC7ZclZ1/pjwXYzmS2CImwxRZq1mBqm1+w9xw81u+egAbcyTDLwzSIoQyMZFI4nuGMB3Nt0x+2pgYRqHPpmShB2n5q9LJj5qbu5BT1U8SdusHfFm1CvEHkyWKzPaDfvH5Tyoj8ECIfjtRV+cE0lMdgGRFQcJ7HT+v20Arwn8MFelnFXVn3mjlM3d/YHow6Uj34eMGQ90ngrkihHLEvqFSOk5FRChuwVS3ehBz+TdB5b9mM8IpcN8qK1mIqXp6w46fX2d9cY7Ft5NBUQ3cVB7LwW+yJOeF74rs1RRSunhzOJNBKoB25TbAtUR+iL9Ad19kiu1Fg9u3SCvbRhfgh8CmU6Ximr08geoozRuAzG70BKp51JmsEOUH9Q7OSpte6lPcwNblBt47WcpwSaiKibMo+JDmiVXGhAbhtO5fivSx6bNfV3T0d539DAOLZwowSbROFD1Dizf9sV4xyd1Ee0bm8/645UkGPPToPigDdTMeq4QVwY5jr6psg79wI9nt+mDitbV809MRF6uOiyJA8vv4+fJ15S2bWC+Ab//bX3u5qkWYe/1mEd0VOJ2pAmmu3XYt+FoggiX3GemFU2K+CSVzgz4T
 LAyCJlqv
 0Sh+wvbARzmMAK2Dffrk0b9ZQ2SlBR4i4Crr/q+d/3rdruHRWbzYEKGdL+7PVMbeb4xehNo75HzxSMX40HvJ4ohd3GpgIcu8ub6yikT/haYHzag8nci1cvngA/CWDtmmC7QBSI0fa9IS0MttlLsI4//RS7VETrwaxLZoHpJBKt8Lfc5U3suYDLuaQB7LS/Y9+EV1nFBLWR2Vpa8aDIbEYBfwE6VW6QjRXBLlqd6mIxs/sL9bfBPAA5KonHona1UsWQ/iIx+Hy0og1QMwrqCM2lQS8uGnsGXSioTeBiCuXmKDCQ5AcKpC6Rlj4UpzSDFqkEqP0qnKj9tYT7cXcR+Z9XnyVCijZsG9wS/Op7W2WVIR6/TTUuYQJ2V3TH++/SZ6gdpPgZkJXwjVH7sMzcU8fQGusIERc6rSyU6F1IQlkt9vkJkwMcX3/Ey8noR7vCVD2zZuyoP8Hz5DKrqKdNicJFZGFzgmSuVXlNGBSZWCcpwwe1zglnrPmD74i5faxFoWhDMCYOFLGLxs+l39VQRB3rK1Du7wT8B7PJFG4d6Ire8W8e/DTQb15Rdywwexw92fvxsfTGEzWBUrFmUA15a3ExLD9nVZFKdu80BudUZ6+TbJ0n5iP/+9T25CWtpQsmbiADYYtTJ4m2HqdNeG5lk07kVTIncMIOIoaGcMEA6xGZmYedx+aGSYKAGDlWUBQAIbQthDH0dpavczCSoPcvaP9B5yqgL1DULNOQyC1A06cwQD3BhVumOvlxQidFlTTJMvvgNYkrXA9dN4NSKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 3:35 PM, SeongJae Park wrote:
> On Thu, 31 Jul 2025 20:26:29 +0000 Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:
> 
>> Simple folio conversion to remove a user of PageSlab() and
>> PageCompound().
>>
>> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> 
> I have a trivial comment below, but since it is just a trivial one that I don't
> really care,
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 

>>   	/*
>> -	 * If it's not a compound page, see if we have a matching VMA
>> +	 * If it's not a compound folio, see if we have a matching VMA
> 
> Nit.  I think "a large folio" rather than "a compound folio" is more consistent
> and easier to read/understand.  No strong opinion, though.

I agree, "large folio" is used throughout the kernel rather than 
compound folio. I'll send a v2 with this change.

Thanks,
Sid

> 
>>   	 * region. This test is intentionally done in reverse order,
>>   	 * so if there's no VMA, we still fall through and hand back
>> -	 * PAGE_SIZE for 0-order pages.
>> +	 * PAGE_SIZE for 0-order folios.
>>   	 */
>> -	if (!PageCompound(page)) {
>> +	if (!folio_test_large(folio)) {
>>   		struct vm_area_struct *vma;
>>   
>>   		vma = find_vma(current->mm, (unsigned long)objp);
>> @@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
>>   	 * The ksize() function is only guaranteed to work for pointers
>>   	 * returned by kmalloc(). So handle arbitrary pointers here.
>>   	 */
>> -	return page_size(page);
>> +	return folio_size(folio);
>>   }
>>   
>>   void vfree(const void *addr)
>> -- 
>> 2.43.0
> 
> 
> Thanks,
> SJ



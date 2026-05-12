Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA0CCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 23:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C566B0005; Tue, 12 May 2026 19:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1438D6B008A; Tue, 12 May 2026 19:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0334B6B008C; Tue, 12 May 2026 19:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E11186B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:19:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83AB716072A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:19:40 +0000 (UTC)
X-FDA: 84760336920.04.032ACB2
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012066.outbound.protection.outlook.com [52.101.43.66])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B72480002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:19:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Msw/91GL";
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778627977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8RDgE3oMoEcFRGJlDRb/oEL82Hd4fhQeIa4vzDrIaY=;
	b=N7MaleoQMvXusC5jC0f/p0gBOBXRFZvstQkPbmHIKb45xlSu+/EZPIsZR9zxE4uPEK+BKW
	uPbjnCevOCdfIx8hIjyLECCgJqA3j51GyzkmwItXbYdUAg7rDPDkbuUl3SgOvd2JKsuU9r
	UY4c94BFiuQ09QGB+WpV4zwFIvu9S8I=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Msw/91GL";
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778627977; a=rsa-sha256;
	cv=pass;
	b=QXXaq99CnqZy3HjdxyVed2lfxoJCK6rffm0o81LWdgW288pLaUEojwrbDk4HWJJa8YViGy
	9i42ZEwuJdRpoYCkz92l0AsK712g0a3fo2hVpYTSUs8wEZ1yHYwozFGNqhP0U7dNJ/eG4d
	B+10YX624xn3cFyp/SRYtxzosmjgHKA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJvTcLh0cLJxm26ENP/W5cXwplzEBwaJJQzv8wK2zlHVictkSmCapD0q8ibkk59zkD/vs52481/uPZZmTwscYYk3KMdDGwi6mEGg8qFbf3aSk3R64jtnSRgUGNgKGTSqwd39UO8TvAHGB1La1xj/EWprsYmhAC9bEGzGbXPwMw8EWsaa0mC/+m/tpG5X0XRoStsBSlH1cmDt5I0SmOaNGGUH5fJyHyAkqKRfeR1szHCspzttvALmv0A0V3Pb5Z76AWMQQW1BbOxjumM9ISsVDi8Wn2gb4GoKlyHpEQu68KB3sLuRMpvrNI4sKGCYYosfJ2d5GUqvU1TOtyYZw9urGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8RDgE3oMoEcFRGJlDRb/oEL82Hd4fhQeIa4vzDrIaY=;
 b=KrJ2fDSq5TnuV3I2YBjQhHVv0GuHsiuAOLkIvr0N4J2dsNAdvLYi16BiCNlse3dxox1gYjNlPg9F7CvWcvohmM8UOL8Sj4B01cH6UfKHeC2nyPl4DacKT9JEBbg3R1dxf4vVXDRIgDjSL0IdPLX21Tz6SWQZLW93vCt4dajM995mLmcKGhQgXidl8BB2zvfZIunAwle51V3rBbDOHzf/MUdPv3I7IFzM5vrm2yTN1eKplaaf5K1OKJTl9/85uEbQMtJBQ+CPHpKXAWfaDlEpVYfJhPEvWSuqrM/PfNPIid+enXbL1CmjZyEHoKukOqm8PHUpsBJZVb2pzLwIL348qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8RDgE3oMoEcFRGJlDRb/oEL82Hd4fhQeIa4vzDrIaY=;
 b=Msw/91GLIQ0aNuzwunEIylCe5Js2oJrTeipz8lnjFMkV9tkdwjszAedtjej9Gpiz7GPvC/yDnzuI5JmxW8aD9o57Nk9TDZuFLEnIKBy3g0CHLupDMHH7gORwKfCRhyIaabJR+gfFHstBNe3iwalEawkfhbs1/pubS/apCLPwD2pZ/SGdcJ4F6Z3IVmzt0K0uF5/u0Xvv8gOaEKD8/rAyFJIsn9mkSojHKgKaGZWUMwq0/gyg4tYKU8RRCobCPOXfnz9u04Bh35pWSa+MJtJQ1ToQWqoguQF9AgwLwIaeW3zutxMfHQUEbStLSWLfm+G8Et0lrvWi3IEnDMdi8wwh2w==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DSWPR12MB999154.namprd12.prod.outlook.com (2603:10b6:8:36e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 23:19:24 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 23:19:24 +0000
Message-ID: <18ac53cf-72b3-4322-846e-7f6fd614172c@nvidia.com>
Date: Wed, 13 May 2026 09:19:16 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, sj@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 stable@vger.kernel.org
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
 <20260512143542.izpp3gu4iqxttw3f@master>
 <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
 <9a56d762-ebe5-429e-9fc8-a9c9e5d0d434@nvidia.com>
 <20260512231442.53qwj37fbykp2qus@master>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260512231442.53qwj37fbykp2qus@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0027.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DSWPR12MB999154:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf45b36-ebb8-485c-1461-08deb07ce7a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WZFyy3tP8is29bwuGDRkmOF0cZkOHzDG3dxLhjOvn2tVtDl4jq3OJHQfFoePZhmhxFVwcxcPtd46OaaInTbL++m0NMVdXLy9Ne65rbqFbZSDNhHf/+8YJX8+m1CZci5glYD/9oaTwT3CslqQUmJ8K8vl2yVqp1sb5GOeC8RozjjVEkeiL7K884PQTbLvuq/j0aO4elYQCQ4Z+IZ0GIKzd5uVy/4JYDXuUUK7autjmMdFokBG7ryZLQcKtn641bDENnwSUUzaDLCTFoTzPVIZSmLVb+fNPSWgouQJ6VA9YGMI95A9qycXpBYg0x07PKlb1FRzl325bfJdljxCD5mKMsvuo7Nsh360u9Cvn8wSYMZpn0ixrXvbOfjVWJcQnHutDxpbrjmX6NDCa6ldCCYENk1fVWZjw5IAhgV+kghQmsaaWwMCoLT24RpBE6dHnBhvvu74G13uUxjPUl335a0PIXCXGDHaTo7857T4uoNI9fgxHmh2clMpqOgG8dMLv9VfKPcHDCnEbyzJnSw7adcwBgKXDzZi784w7rBnSog2KiSeP86zoEe4M8ngwtLQR3aFIfpEWOTcrS7TFCDhc4Z61ix1gIYzFcYilIFY+fHFkzNdbhVb77eBth2nQb90vDofM25/Bw/C7U3hw17XWS7CsIVJZDg8g+7DN0Gc+aXyvjCjxt8D0prxsUvAsPHg+PEp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEJoUW1hckxicVlWVnExMnZQWTdYSUZ0Q3VSQWZKQ3IzajFHZEo1dmd3M0dS?=
 =?utf-8?B?MHdPT05jd29OaThnTTMzbXg2amlXMlBCZEV6aE90SWo0SmMrVzdxUUd0dko3?=
 =?utf-8?B?ejladlA0QmhGa0FTWWFKMWVzU0ptcFlxN05ZSWN0OFlBVGU0cGs5OXlUczJ5?=
 =?utf-8?B?N09sWElwOEhKSE1va0kvcUF3MnJaUUFnUFVWMmtpL1VrOXFIZnVUU2xrakM2?=
 =?utf-8?B?anRScjdLTnZSaEtsM08xTXNMcHhLUCtXM09GVmd3N2xKMjdtc3paa3lHM0dm?=
 =?utf-8?B?ZlZ5U2w3VW14NEpNUCtoVzFjSS9nQitJYzVKZjFIaTFtekNZK2JEdXp0YTFu?=
 =?utf-8?B?eFAxS1ZNZnUrUjdweEJSTWhIZHdaQlNlamZUbWxHVUR5NjNoZmJkNXpHaXlz?=
 =?utf-8?B?RVRVUTRCNW4vZGVyRFFLdWhseEp3UFZXVmRkdFZrNytZaEJrYU1GSlRYNHNI?=
 =?utf-8?B?eFVUTFovRzg0NW8xNGh3SzN6N0FKM1VaTTFXZGROc29YTXNPdUFwN0xpL0s2?=
 =?utf-8?B?VHF6Mll2Q1Zha1F6TXNXZUdEeWxEcjRMNHBxM1piQ3ViY0JsNm41UUNHWWVR?=
 =?utf-8?B?d0l1TTNBdW9YSEhMZUF6WTJHM0JUZlVncS9ub3dCVlFTWll2WmFMTG5FL2h0?=
 =?utf-8?B?UE9LdHhYdlg2M1c1eFo0TWlHUjRGT054ZHRZbjhMeVpPbmI3TmJCMVVUaEYw?=
 =?utf-8?B?a1I0NGd1bXloYUpkSXVocDA5WmFPY0Y5dG5tMU45SlkrdTBkV1l1dlU1My9F?=
 =?utf-8?B?WE43TitWVElvVzVJc1kwd1ZTQzdYU0F5SEs0WlJGM2E0ZUxpa2IwVmRZcDY3?=
 =?utf-8?B?QS83dWRibWxIRWdOY1RLWU9yMEIxK0VueVdkNkdTdTdKUkwwdEkwYUVoaVNE?=
 =?utf-8?B?UmxLV1RGTExSTUpDSWtPYVoyYmJhYjNYNUhQWEQ5M1N3TUorVklJYkp1N1lv?=
 =?utf-8?B?RXpIck1wK2lZeVhuWkZrZ0ZJTmFkUTdjcGRsREo0RXFVWGx5SU5nM1YyS0pP?=
 =?utf-8?B?ZUVRU0IzQmtvays4a3BBUnNTKzF3R3RWNXNKVW9IMmFPbGhTcmE2NFludHQx?=
 =?utf-8?B?UWJqUENzVWpYVGM5QVVhMVB3R056bTRwVkF3N1EvNWViTTA3VVk1cDI2OVl6?=
 =?utf-8?B?VlJHZXdpOUc2RmVaN0JDY1dJTlA1cWFNVGVxYVMycjdRRVc5NWp6a1JoRWcz?=
 =?utf-8?B?bkJMNVE4alBKN0FxT0hmS0s3aW1ndVg1ZG5rc2pPUktrcksyN2ZIQm12T0VX?=
 =?utf-8?B?UHJYNHpZUG1zZXA4MXRoNytVNU9LZWoxcW1ONysvQnl3ZW9jOCtPcUZDR3k4?=
 =?utf-8?B?UWFwbktZNlAvblBGTmZkUE9xVHVncmsrTVlkdXRVSy9lU3ZleDdSd2ZhQlBB?=
 =?utf-8?B?aGdCNU4vMEZqMzhPTXdiM1pFRHdvK3czazlKbUhFcDl0VjlXVHRMbk45VGEr?=
 =?utf-8?B?TlpzNC9zOEV0YkJpcUZ5clVYaEY1amlzNFZLRTZFekliSU80OG81RHROSkFq?=
 =?utf-8?B?ZWZHMVYzSzhlNlRnY2s1SjZzcFo1Z3kvWmFEWjd5RUtaeE9LN1BCYlZkZUh0?=
 =?utf-8?B?Zm9rNDB1cEVGeTZwcWFJMEc3VUZRYVgweU9Ud00vcStOR0hoMDB4NnJIUStI?=
 =?utf-8?B?QllNT2xZNGt6WHRTVXVJVW1RMGh2TFg2VnhKRVJlMmk1TEdPb3dIczZodVJV?=
 =?utf-8?B?dE84MUFUb0RXVitDZ1ZvVUlReVo4ZVM2ZWRmY1g0a3U2bUhha21CYm5xSnZZ?=
 =?utf-8?B?UWdUQ0lnMFFNdmc5REU5Wm1lMldKZmxKMG83UzYzNnM1MzZ0SnFQSDNDbDNU?=
 =?utf-8?B?Yi9KNHdRVXB0M1lJNXlTMnpmTmxzRExxa3g3S3RGR2hGcUhleUZUSFREeXBX?=
 =?utf-8?B?dWJ4cEVneXlMV3dsREFCQkN3R05zY3RHcEpTQXI0SWxtSFowc2RidVlqdFZ6?=
 =?utf-8?B?YUFGWm5jOXAxaXU1bFloS2UzMStHaDhiVy9DTVNNUnhyUDV6OU1ZTzkrbXlI?=
 =?utf-8?B?QjZMQkZxbjJvbjFKLzgrNEdZOFBKTktyK1Rkd1lSelpQZzQreEJ1RUtza3p3?=
 =?utf-8?B?aVhjZzl1QUVveUJEQ1NrVkxLUER2OVphNFdIbU9FQlA5U2ZlODVqbXZMRjFt?=
 =?utf-8?B?aWFjS0RDaTBkM01DeEh2NGtaU0Q3QWovbjRkWjhGR0N1b1hlNC9ENGhQK0Mv?=
 =?utf-8?B?SG9CakxuMmJuajJGM3pla1NjcFU2cy9DaEdZaFdSdDlwT1YyZ0NaL3VITmlF?=
 =?utf-8?B?ZnhtNEQvMkYvMitDQW1CSzJoUTNTTFJueUhUcTBZYnRYeGoyOE1HclYxVmZS?=
 =?utf-8?B?QlNzdm5GUm4yTDlzZXhIK1RHUktQSVNKVmVLZGpHOEJ1bTJnQVN6Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf45b36-ebb8-485c-1461-08deb07ce7a2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 23:19:24.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ecL9vaw9VaAxubq7DClZiGd8f+y/TTb6HFqhg1ykaJ/b+xQyR+km5s7A6SxqLt1g3PfIXdT5P/O089AwEPwsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999154
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B72480002
X-Stat-Signature: ofmzatuw4xko9uat3udnr8w81ny1baww
X-HE-Tag: 1778627977-860853
X-HE-Meta: U2FsdGVkX1/1V+XvW+vON9WffMOlBt5FO9GorivTJ2qJYnavEhAHnpMo1bSaqkn2B38Wh3jD+VVUW8k/MWS2UcDVeJvFqj/ORMzSDZoJZHPH2Bah+RF9HO6yO6/vb21OBKd8XoAv1P1O93tmnjwBMnUFnXKZN5yIStw+MCfISqzlC4sEZ0AfsnCYwHqFs3eS995HJJLNsGJ8F95ITROo/wjagC5MweVH05eK8LEA8JWIplzGld86hlT+U+02PnZpJzGNVE4c+UCygZhG1QbnR0x8IT28LFcfM84mpBVqGtlvpSpDmzwmnI5vewTz126NRWXV8zwDRp/o77U+GPvYQTdKj9MZ5T+5uuIyNycxYRFJvjUDI0rff2A9rhPpEYngYeYQXCIxFHJnr3uCZ5GmV4JmG0SbjYMgMd0A99cZDbbalpqDJt/6yQo0IwvWTyZGqhpMLGXx0ed7jel2ROQPAiAH70PjKLOVZKXO99ornVaC1mGr0Qv55wRVBzjeBK0caViDNs/M0l3+Z+ZNjZ56OpdSzKP1z3av1dmYn2tyAiwlZDXJTXrSAbU+0N0GtcqW2IqxBj0jltGB5apIAWtOgMqXMjqKZGwgtYyc2F0JokPipDWdt2p3KNKI3IwxTsyyBiopLtlRkjRHEF1aXI9D6bQvt6l8qX/Uc98Gld+lNDrOw4+FiWvOkq8gF6TPhtx5pTCBmHewmevmfrc29JlxLrycZZf0jIJPtp5hknu1WT/2wM8TtU0jQ1COq6g7nFZ2j4knowY2QGpc9ajnPDPAf7oizwJ/jBJvBVo08IObWsjS9e28UuVpnQYEHKD6YlOjULI2UgxW3cLrX09LlO3/krdvbsyOQNlmSBeKNk7czJW3P+fWeZkZHUxbDw7OsrQBEO8OkN0a7xRUUZG++9Wmki9dnttNOHB+Du7zrcMuw4YUjANZevImSvsdoLXUTcKrVcy6D8s4PthCUXNNg/8
 FuEl6ZkT
 GnYBZB1KXrCi4O6ojWrBXY64LtjwPqBKSsPNwfULX5UpYbALz79sjMFsQ6acICfXmAbbhfH3h0rwTrhPNqnbGRNJPdwcKCQLwMDclQTYwijhMk+VVRSEp8t7prV9Nv+tGhSDyvUKtCxbuxbggSqf5fGo0E/sT1BBjnmDMAYedwbMyLEyi8iMTMH1fF9UcefECcipzQ3ti+UgGJTzrHTDNORt1Y/KBC9uA+OJxRS6TeEWxnRUm0lOfzqLYMkholLr6HtFB9HZsGidH0aGvvB7/Dw64ryRb3xHcX43t808UAES3sW3LwT6OIVgbep+TnCuxVWaSrHRkYyyHgStfooLU9Wx1MwM+pVjIhFSDQXj4BYDh7UojHv4U9c3HiSQGtu4HFQCy8iiQiETMXIl/SIUkf6NpYohjC48RgRjzHeVXYtEkqqAMlsboPUneRx4zLexxXZyZTFpPPaTGlg4XW59PVxYAzZLa+utuqBVHinqW9ats7I0R+aWP1GFiacWz8aXp0nOHr8xVxPTQnwX7E/b0mXzMpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 09:14, Wei Yang wrote:
> On Wed, May 13, 2026 at 09:03:47AM +1000, Balbir Singh wrote:
>> On 5/13/26 04:55, David Hildenbrand (Arm) wrote:
>>> On 5/12/26 16:35, Wei Yang wrote:
>>>> On Tue, May 12, 2026 at 02:43:54PM +0200, David Hildenbrand (Arm) wrote:
>>>>> On 5/9/26 00:48, Balbir Singh wrote:
>>>>>>
>>>>>> Could you elaborate a more on the improper situation?
>>>>>>
>>>>>>
>>>>>> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>>>>>> lock and check once?
>>>>>
>>>>> I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.
>>>>>
>>>>> I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.
>>>>>
>>>>> Something a lot cleaner like:
>>>>>
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index a4d52fdb3056..de6a255cc847 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>                 */
>>>>>                pmde = pmdp_get_lockless(pvmw->pmd);
>>>>>
>>>>> -               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>> -                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> -                       pmde = *pvmw->pmd;
>>>>> -                       if (!pmd_present(pmde)) {
>>>>> -                               softleaf_t entry;
>>>>> -
>>>>> -                               if (!thp_migration_supported() ||
>>>>> -                                   !(pvmw->flags & PVMW_MIGRATION))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               entry = softleaf_from_pmd(pmde);
>>>>> -
>>>>> -                               if (!softleaf_is_migration(entry) ||
>>>>> -                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               return true;
>>>>> -                       }
>>>>> -                       if (likely(pmd_trans_huge(pmde))) {
>>>>> -                               if (pvmw->flags & PVMW_MIGRATION)
>>>>> -                                       return not_found(pvmw);
>>>>> -                               if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>> -                                       return not_found(pvmw);
>>>>> -                               return true;
>>>>> -                       }
>>>>> -                       /* THP pmd was split under us: handle on pte level */
>>>>> -                       spin_unlock(pvmw->ptl);
>>>>> -                       pvmw->ptl = NULL;
>>>>> -               } else if (!pmd_present(pmde)) {
>>>>> -                       const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>> -
>>>>> -                       if (softleaf_is_device_private(entry)) {
>>>>> -                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> -                               return true;
>>>>> -                       }
>>>>> +               if (pmd_present(pmde)) {
>>>>> +                       if (!pmd_leaf(pmde))
>>>>> +                               goto pte_table;
>>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else if (pmd_is_migration_entry(pmde)) {
>>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>>> +
>>>>> +                       if (!(pvmw->flags & PVMW_MIGRATION))
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else if (pmd_is_device_private_entry(pmde)) {
>>>>> +                       softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>
>>>>> +                       if (pvmw->flags & PVMW_MIGRATION)
>>>>> +                               return not_found(pvmw);
>>>>> +                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>> +                               return not_found(pvmw);
>>>>> +               } else {
>>>>>                        if ((pvmw->flags & PVMW_SYNC) &&
>>>>>                            thp_vma_suitable_order(vma, pvmw->address,
>>>>>                                                   PMD_ORDER) &&
>>>>> @@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>                        step_forward(pvmw, PMD_SIZE);
>>>>>                        continue;
>>>>>                }
>>>>> +
>>>>> +               /* Double-check under PTL that the PMD didn't change. */
>>>>> +               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> +               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>>>>> +                       return true;
>>>>> +               spin_unlock(pvmw->ptl);
>>>>> +               pvmw->ptl = NULL;
>>>>> +               goto restart;
>>>>> +pte_table:
>>>>>                if (!map_pte(pvmw, &pmde, &ptl)) {
>>>>>                        if (!pvmw->pte)
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> There is likely room to clean this up / compress it further.
>>>>
>>>> I tried to compress above logic like this, hope it could look cleaner.
>>>>
>>>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>>>> 		unsigned long pfn;
>>>> 		bool is_migration = pmd_is_migration_entry(pmde);
>>>> 		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>>>>
>>>> 		if (is_migration != for_migration)
>>>> 			return not_found(pvmw);
>>>>
>>
>> I got some time to look at PVMW_MIGRATION, remove_migration_ptes
>> is invoked for device private pages, would we want them to skip
>> device private pmd pages?
>>
> 
> Not get you clearly.
> 
> You mean skip device-private pmd page in remove_migration_ptes()?
> 

Yes, could you elaborate on why it's OK to skip device-private pmd
pages in remove_migration_ptes() and if so what is the impact?

>>>> 		if (pmd_trans_huge(pmde))
>>>> 			pfn = pmd_pfn(pmde);
>>>> 		else
>>>> 			pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>>>>
>>>> 		if (!check_pmd(pfn, pvmw))
>>>> 			return not_found(pvmw);
>>>> 	} else if (!pmd_present(pmde)) {
>>>
>>> It's more compact, but not necessarily cleaner. In particular, I detest
>>> pmd_trans_huge(), we should phase it out.
>>>
>>> if (pmd_present(pmde) && !pmd_leaf(pmde)) {
>>> 	goto pte_table;
>>> } else if (pmd_present(pmde) || pmd_is_valid_softleaf(pmde))
>>>
>>> ...
>>>
>>> Might work as well. But once we add support for other softleaf types, we'll have
>>> to touch it again. So I'd rather just list what we actually expect.
>>>
>>
>> Balbir
> 



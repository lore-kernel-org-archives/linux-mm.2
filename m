Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED17CCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD636B0195; Sun, 31 May 2026 20:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADF36B0197; Sun, 31 May 2026 20:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076A66B0198; Sun, 31 May 2026 20:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5E726B0195
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:17:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CBCAA0571
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:17:45 +0000 (UTC)
X-FDA: 84829430490.17.90EF8AE
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010015.outbound.protection.outlook.com [52.101.85.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5315F20005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:17:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ncBMRqsD;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780273062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xdmjuujdw5Tvq3osOU2KMftKkC1tXXpDqilWTfFkzg8=;
	b=yAEkCJ3PfCvDG+vQ3FNyvRNELVL8No1NpchAAX3nKndg8wnEHFkLIGLLwqNF80vlZta9yq
	EyIIPeKkvxm9RwspO+wxPCuJJCKGnMA5d8sq1hWuC95Q8ed46YwoC/foqbRwf9qJuFeUJy
	DXPI4ytk6EexI0oRxdiK883KP6maZ20=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ncBMRqsD;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780273062; a=rsa-sha256;
	cv=pass;
	b=qn8pOs2MzR6Pgp5YARH2V46Qkaeknv9POcsTaHgzoTcFLvPxXa74llDmdxo2/jxZJPNZn8
	tzC3zoNJdTJHL58RzKt/Qg2lyeyqgfj92c4CKKIHACSnEt668fEGIDyy5xhFqiQ+pmQQrY
	ie8M5vWb3P69ZYKPQ7UpvVUyevcXYbM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4TmjYNPSLqQgjnZuyq4rRjcxFqy7kI1EHlHFwfmcPmYekuAbLJQQcgbdcyNwBjBsfsmQ9mZwfeF39Pzj1C2ZmRr4Mm5DuCaNu9Ue+zsuG4REkdiq+PVOV5KKgv+4JrntSov9ldLOmM1WK5n21COTl5ydQk00BbgeaoT5bko0Q0YYHUlCRuIjUpGNs/+9pfe3yf0Wjj/YySsQNQtThpgn3bunK8r+STqPO6S5HPHHsr6VeKYCZzjVGeM0sgd6zTkveFQDgam7WW1vApbm4ZKHXzSlqkAzF9mf8YGKAFI4BVCbh4UcQfTyjFTF7esvJ3TaVBnHxZSr5CwdWu8x7PosQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xdmjuujdw5Tvq3osOU2KMftKkC1tXXpDqilWTfFkzg8=;
 b=Y245R1UMOK7NDm8lWkbh58lZkTbGQJROhPbI+dhX+Dw5mpJiakw74CRrowvNyy3dNA0ScyrX7FfePAqY93xxi5E3DMYGF4vAfMlm4d4cSajTOY1AzmKr6omW9roXj0pNyO/Ao8RKfg4Lbs608S4Bxal48cOifETeUzbjXFoKH7SrZ0sKtx6P8vRC57FYSrEoTJbkCwzd5E9trAfVSYeDrvI/kuTMnypU4a+7r034GuikDBQWO5qhHp/9rrf4jPixufBEilS2OuZNlhjH37S7bCNeiGfsjNPLq7Jraho3v/mKdYdJnpoD2z6mpe+Zs3Ca4R79G2ubD7pxWWtnQHKV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xdmjuujdw5Tvq3osOU2KMftKkC1tXXpDqilWTfFkzg8=;
 b=ncBMRqsDVcgF49BndMqlIlM+aMQQWlTaQ/RlzzRAHN0XKwSAsWwoFcLNj/OaRcYbMXgeOzTooZs+hxjGOM5OGb4wTzaEHQM/1ZfwFk+Yif8+c5bSj6PsuryjP2Bel0t3aqbjMIKVU+54uALBVUKqVFMw+UsUebgJK2Vuuzlos1VwBzaT8xHYHbIASgkb1JHCjfzZt0lV/WIOe9YoXPwZS37XAbpNvWuzqtcfk3JadpOD2rTEoFNsZr6WRUMnVbm2i/VzDJGuK7nVkngsNaWq1IjpypI3VcQvx3CU6qXrO2Hlbx4Hh+CLlWg6YK/0opHGEptxLgMsl+Sb2gCJ8q+UdA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB8319.namprd12.prod.outlook.com (2603:10b6:8:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 00:17:36 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 00:17:36 +0000
Message-ID: <ccdca325-a33c-45ae-aac1-3ac4aea77a42@nvidia.com>
Date: Mon, 1 Jun 2026 10:17:28 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/huge_memory: preserve pmd_swp_uffd_wp on
 device-private PMD downgrade
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, stable@vger.kernel.org,
 Sashiko AI review <sashiko-bot@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-5-kas@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260529172331.356655-5-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3P282CA0073.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f6::6) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: b6fa8bca-cbdc-43c6-b9fb-08debf732edf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Kzw6wK9YGX2zVKd5KlCG/ihZOzCAUuoCWOhTlikdXPc2HimcuEOcODBfq2L9rLX3bYK1IkoTrr79SSWrVE28CzFWpUy0O/DG1X1yOVoweA9MlVW69pDQtb94Ni92BqjOyyysoeTtIBDGkC/w51IfbFE8avf796n+7/QrgX//hTR1TwaPbuTqbkCeZqkMCPv5Tzcnbm/M3l0T1y4OO3ls8QbNUSdfvdw7jSNtbR4NS62dANh5qPQAp0zk6a2mLzaz1kHd/onAV/l/WvMVLKFNMX4lzhmlaPgUkuvWWeY+HeTwb0etaXaFhqYMQJKEPvQ3WqtWZp4pCOl7+m3TfWzTL2rbL5VNi2BnvfaRpS1Nz20AkQ3k9a9xUa9kRuMaFMFtg9jEZ7LLEcmlmyL5l/djMlezyDNNrqX6idM+m/T7Yocawbek7SEbbW3xc+n1AxlTTCWsbEMBSHSJ2erpdA7ltoFjv54tM7me5bv99lzyJyM2zSC5f1cBoQ/y1pmecHfxSkcteo4NjKhlRlFPN0KjNaTcADpNPVaYVZjxDl1KyHHEyEaXHuOd1xbXUiNo/JOyFXWYrLR+QWbz7qX/cgiqQ9rFZvMrIopOyU5ifD8oSpJxLSJC/YTWiYIhPAXni/bAoVxfxxdxPXUmABCuv4AGTmbLEs7QpuNHMG0fRY8py/F3D+VnB8ZZaT4/UOayoyei
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlphVnBSOGpCeFRoZHZLQUVYZVRab1BZeG1pc1QrQXZqbWp1ZE04cHN6S2xn?=
 =?utf-8?B?eE16NjlUcUdtendoN3dJd2ZwdCtUVStyOUdWU2FlSkxpTmZzMEtPa3dCMXZX?=
 =?utf-8?B?a1FFdmI3ZHlrLzVDNnVSTnlmRlduWHM0WmlxeGhaSmlOcFJuYlRINVY0anlR?=
 =?utf-8?B?MG1yYzNMM3hoT0hmSm1CY2M4bmxVZTl4NEE3aml1Zmc1WWJuSi85ditXNnpj?=
 =?utf-8?B?SXJON0N0QVV2cHhlTWFJbGpPTmZEMEx0b2xMUnk5cTZQaFB0SVpUOCtHL253?=
 =?utf-8?B?ZldLMUJOM0Vub0pSYzcwbHFYOExKRGlhTkpJbmJseEpKOTlmeEhPeU5oMUxv?=
 =?utf-8?B?Y2pvVGF1aUxBUWNkVldrcmV1TDNwK0xKTVAzWTFFRkNZM2RnaFFwT3M5LzNu?=
 =?utf-8?B?aWVBSkdLbkhCUno2QzQ2dTJPVGpYbVF1QjZyazdHd29DQTA0VnU4WTg1Z2hT?=
 =?utf-8?B?d0JwSDdTUGRxTktMNnM3SFlhOS9Hc0pJa1o3MUVtQXVkb05lTk10amFhdTJs?=
 =?utf-8?B?U2U3WUlEcDJWSzduQmVienpkcU96TFBMOUZlR0JPcnJDOXpQQjVJWVpSZ0xH?=
 =?utf-8?B?RVFpcWt2b01GeFhYcWsycUxObUFrai9WQmdxbzJWWEw3SjZqdGh4a0VEdGpE?=
 =?utf-8?B?aU4zVEZQRVE1RGV5WEJldjFHT3kxOXBoaFFxVEhzaXZWR2xaSjZ0L1lRTjdL?=
 =?utf-8?B?WG91Vm9qbCtkZldzeTNET2xka1pEc1BZYytmTGVQOHltT0haMnQ4N2dmZUhx?=
 =?utf-8?B?MnJlbnJ2b1VnaTlIajVMam5aQjdLbFJ4L2o4Mzl3RGdrMWRBNzdJSXhYOWVU?=
 =?utf-8?B?aVpTM3VSRlZXTkx0by8zUjRHUXJpcFRCbDg5TEsva2FmSVBoeUVaS2JJbWYy?=
 =?utf-8?B?UkNvYVJrVndZSHdyTWlXWmFSZllPK1lBZ0EzTGFzU0pYSzRyckpZZjMvYzJl?=
 =?utf-8?B?WHhIY2padjVVeGREeGRydXdhS1B6MmgrazZsMTNENnZKa29hUXFGY0Q1WXhE?=
 =?utf-8?B?d0ltelZXbE1qZ3pDRkd6RG1EVEUyeU0xNEpaa2Z1U3lBaDJzZjg1eTd3N0FI?=
 =?utf-8?B?bjQ1WjBuL3B1aURVaER5VE00cWV2NlFKb0JWb3NveGh3RGl6ZVlKNUh6QTVX?=
 =?utf-8?B?dFpCZjBraHhFbHA3a3RtNVcyR2RIYk1MQnBHWmRWSmdSZXVKQVNNSWs2am00?=
 =?utf-8?B?UWs5U3cyK09HMzZIRjRiaGRrNnF2U3Npdk42dEdlV3BYeVdGZUduWHBtSW13?=
 =?utf-8?B?cmpIemtpWDlGeUZ0MG5pYW90bzQ3SDgvK0VYS1Y1K0ZmUW03NFAzc0Rya3Vn?=
 =?utf-8?B?b21BdUJ6UjFLZFF0L2NzMXpGZHNDbzQ2N1Fwc29Gb1FtTXBPRW8rWm5mZ2w1?=
 =?utf-8?B?aWhJZDd2ZWtsQnRhWjVkZWg0S0hkYTltK0U4cGNPZ2p0bmhQai9nT21QcFY2?=
 =?utf-8?B?bUxnZmxSbzhUOXF2OGl3OUQ5VVFxTWpsNmJ0bnpIZnFTdlVaYjNadndDZXBM?=
 =?utf-8?B?T2x6TUttYVFoeFg2YlFFVE95U1Y5eSs4akRaMTB3N1ZJQ3FTMzhyMVcwclhB?=
 =?utf-8?B?MVJseWxsSUp6RHRnenBqNlVSZnNzWnI2UzhZQm93ZXJPeCtqdzVObXJaajhx?=
 =?utf-8?B?N25FaUV3V0dINDdWZjl3TXlHV3hmTlkxVzRNUnRUUHlyVFJYUWwvS2lwZ2NW?=
 =?utf-8?B?dTNvcnBUd2NHaXFYZ0ZzdSs0SGpiR1hzejdJSFNjTWc0NnJzRjloeVUzNlEv?=
 =?utf-8?B?LzkyZm4zbEZFTWxqVHJ4RW9rQzNzSy9vMUNQU05teGZUenpRYUh2dmRCTUhS?=
 =?utf-8?B?ZWY4S0pXangzNVlXMUdhTHhlcTBObjltUXcrbndqWWh1YVpvVyt4RGYwSkU5?=
 =?utf-8?B?RkQ5VmNSbVQ4ZCtQVWpSZWtyMVhsbTN1aWxpUnBSSFZnRGxHWmxWSXEwa21t?=
 =?utf-8?B?MVI1dTNYLzBpQTI1RUNVTW1XNkkzY1BCWmhOUzlqQVdRNjRoaG5RZGFCQnVF?=
 =?utf-8?B?MVkwM09zT2ZRWmM1UENVT1lqc1JFdDdPc2xaRHRWUWgwYzdwMzQrVlVlR2x3?=
 =?utf-8?B?b2wyR2JUclRFd1VvUWhLZlJwVVVsMFR6SVlHRW9lOTFzdnhOSUp0NzU5WDBU?=
 =?utf-8?B?aDd4UnFXOE9pZWNlWW1uQm9kaS9rZ005eDM5Q3NrSktOSDRmcTI5MnhnV1lQ?=
 =?utf-8?B?dHRWdk9ncXQyekNJUktNbzFhNGVwd2k3UmhOd1VFY2xqeFJuUW5yYzRDRnFM?=
 =?utf-8?B?VThBbExLRU44dWtpQmIxZU5LY2owWFFFYXk1cGF6c2Q4azlWa3Jkd3ZDcllp?=
 =?utf-8?Q?JM2hIADe/r5jeifRvY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fa8bca-cbdc-43c6-b9fb-08debf732edf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 00:17:36.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5y6h8GNAJ3gh/CT+vsUKKozPqTkfWAnNzOQ1s92pZjqe5Quu9LeMO6LR8tXA7Z8TOQBEBkP83BFQLeEqzfqRqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8319
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5315F20005
X-Stat-Signature: mhgt6fzngsg5cfg7jt4bgwhd34iwmit1
X-HE-Tag: 1780273062-914551
X-HE-Meta: U2FsdGVkX19+gy2J3cG7C9Bd422QENaKmbHhxVt3D7W7bSOAbAsLEIkzDihcwpuoSxHW7Y1xD757daS0anQTtYrNe7C615J7G2P+dlVSCsj6hXFWzPYLNTMc1YBOGzoHTZGRGkWNN0kZbe4Mx7gOjyl4WEuhttOvRnQJEHanP5xsgTgImrNofZibmtMzvg5NZxsd061hBqJOcSk8UQ6f9susyntJatbFL6T7sxzLRzxDwCCUj7TMvDkrdKfiqyTC3tfdVEfxckBNxECEB9BzAqQUZQfPuvFG7Xx7rz/I0yvNOilTCfZlmxE1LplR68XZsHxRW6U+PUYsBS2J77+5G9POxEaAab7eeigjO/0v10Ui/29zsWFxDV5tcg1duPrsQdB1NMygm96RvZJlas1/hLJLdttjnNBWlDUDWAmAJAS4UumNgQQSl8qhbCMf/rVe+1N3UEn4j5gVTroRLSxoG6q8FHQK34BjqhPq67bE1B8GXoXOzyOyiqmMd4igy+bapadgmx1hpip0MrlauJTmXpmFM4mLjTK4cn5gC7xm2VIeDyN0Jj2x2nbSz0blh17+eKrwfZ2YbYRBtGRv881NynAbbQ4VAacLKBRCFuA455JbZDkxnfPmLpwO8iX3cWPPzJxheOiV1DimWUF9pklhBxVQF9HxTniJiTU2BHFQS+eQ68LNWw7fC1xPiYb3R85uxrOYqGVZMxAEgMWoYx3PeeMsmu0VXeEVHdzWcrzwEGMn4kaNwL5kHpi2/HM/bHrquvMqiYy+x033VgBYAFesSg3ZrGn3NHRNQEn6DuuCBT6K3AKIqiZ8k/xUqTaiCPJB51NR5BJ8cRP6oDigfOFbt40CIutkjA5ZPFczxCP8vzIZ/wZ/nS98mc35hHkmsvQaW65ex2jzQpR+jhkrkIPw2HkzX4KXLCukPeQkbgWol20WZWIxT4Ej78CPkdwcEDMwM87StbyL4SaO5EUU7Ka
 Q4fR2EOB
 ymbNqF/xA+fPcRWZ+MbJDbTchty8PcMVHotDKpV6+0dFeUjDC3+SOs96mCKtsOsioe4V73iiAXoumNLvAzT+BFN0k+3ntpgXSda3zGn0IOSshL39mmgHLVdbV88dQldIOlH2tTJmV93GdKqtVGAR3pKFhY4LxUp5cFoL2HNkwqMnMHCl1w8ZHN2ZlSzVGCHdKSlM6JL/mUx5/iVNUGdPc/AemBcz535RXM82/69R7V49gGGSafUwTL/xAR/PNGR15m1GTcVRtp02oy5F0mggpgWSO38t4GTVwd2r3IWJMeajq+KrhDeZAl59b230GO8Rix/TAB35O9D+N4hRKbLFRzpk0ppCn9858oMaS0XgFukAqItWlP+xHfBzkExxvnMP8bqJ9YdlNtXEt+HSoZMKVNBUv/V3D21GIINQFJs1on6GqTHjejdr0U+HKeYFZdmN7TyUC9Rp8bEgt9MBCGn8qeBo+P0ehVp+gT1KwWEtOMtl08L2YzMJkEbww56a/xJGlB/2IbBivjtypSUCGp3bPFE99va/JcScaadbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 03:23, Kiryl Shutsemau (Meta) wrote:
> change_non_present_huge_pmd() rewrites a writable device-private PMD
> swap entry into a readable one without carrying pmd_swp_uffd_wp()
> across. The PTE-level change_softleaf_pte() does this correctly;
> mirror that here, matching what copy_huge_pmd() does for the fork
> path. Without the carry, a plain mprotect() over a UFFD_WP-marked
> device-private THP strips the bit and the trap is bypassed on
> swap-in.
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 42b86e8ab7c0..b7c895b1d366 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2663,6 +2663,8 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
>  	} else if (softleaf_is_device_private_write(entry)) {
>  		entry = make_readable_device_private_entry(swp_offset(entry));
>  		newpmd = swp_entry_to_pmd(entry);
> +		if (pmd_swp_uffd_wp(*pmd))
> +			newpmd = pmd_swp_mkuffd_wp(newpmd);
>  	} else {
>  		newpmd = *pmd;
>  	}

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

Balbir


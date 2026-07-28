Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD39AC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 02:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A579C6B0088; Mon, 27 Jul 2026 22:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EF06B008A; Mon, 27 Jul 2026 22:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA076B008C; Mon, 27 Jul 2026 22:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 536246B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:45:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45D81C0678
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:45:31 +0000 (UTC)
X-FDA: 85036644462.09.EACDDD1
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	by imf02.hostedemail.com (Postfix) with ESMTP id E01F08000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:45:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EIceQxDj;
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.30 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785206729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SV42pWMFi8cQZyqWb5V5OPycHULa1kz4HuGjdJa4QQ=;
	b=3nhYTCkPi5yQdr39BbExvP2nap/ZWWmuTDJJVtZDS8CPplZSK/i1Jae1A0Uu9SJHZy4zo1
	zpv2COzElcnbXQ3OFQFopg+lQch+ZvPX6J7ltBP8HoqpbxLic3wLuTQKoYQAA8vwAoPcxp
	pvJa/FOCDpqzugz5VoROok5iLpxr5Pw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785206729;
	b=blcKBadF/xyA1BclA+bPD9/ccAno5CzaHHy46rxL50W7INZAi1D+NLxIg3YugcLVHtBsP4
	w27cbcfIWdi8GjY3Dd3cRm/8Wh6mXjfP34UOqSReoOGbfSw38dusCB+O73ClqlAxTyKiLa
	0JMqhn4YTQjZDVIFWp0e2E8QNku8/jQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EIceQxDj;
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.30 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DMgIhlt4zvjtAtgTQpay1uE8t39PObzc3RY26fnqyLZOxsDfbxdtGeH1CuNMi7Uxwpx4aMk+f+o4e4+dmzfA4tPlHx6NrGZaZoWcZAoF/ihfFzeljuGFZPEM8PVTK38V5dHQ5vgNNDGrHyU7Rh0mBeBMGRbK9p4gDU+nw9qqEfnpGzZOiGwYmzOqoZ+ft2vFCTk3XWMtogVrXvK/CFFzUCEUtvq/XWgJjvmAApmAxx6f4gVx/Qd2mXMDtvJWtsdEmwLw3aer1IbGopd+B4f37TAfwSfiGeDlhDsVIx1hBaKHYH00hfuNm4r6YQitvihx/DdDJ1l387DR6jmRiep9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SV42pWMFi8cQZyqWb5V5OPycHULa1kz4HuGjdJa4QQ=;
 b=WKbWtKzDoDVpJjrTae1miWY3fVQZzVDlJ81JBwrAiGN+4o3jyhI33xNwz60emqoBZ+czzz4mAlwssAM/vQCjZwcMEeNkZyXAcd/0EuuB0pz28pwGYigZGPYABAtYHWVOBOJf+vjaD/i6XKxKEATlTm1vSmRewk6Ct/9l7QBt+qAB/h0TGuKrYZcd288ypq4ohZT9BwSlIj+nUr4Zh2DmB8nSxu42SJkocAjVKHmaIH0065Ej6Mfnd7vAWmLQM6kchAdGTC+dkJJBgiUXbdA9kNTGy1NfBNVB8v/ht7Hdo+whHXRhAacF9iuDYhsipSsVxxrxVBWoAggd94pHPBGZww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SV42pWMFi8cQZyqWb5V5OPycHULa1kz4HuGjdJa4QQ=;
 b=EIceQxDjca/go5VqkXArzdeBvkbmq5eY87fBEKdPe3TP+CMZOOJ6Jh58f60noZosU3DsZ5pMqDOqnkvLB4gmXUUQI9FASLR4hMfBpeXa0e5G77DimYua3GWUWrI86sb3WhueeGx1dLsuCiIgZQ92d6cCDteWRPzrjJYv8unjBqjbfB3E+HRe/53w7loyQh5KeP2JW27Icnyp9J9rIXRKj75IeMMJ0/hQmc4LBuEa7SFioLuRVdUNVRJpeyVEYEvSyE4Eo0ni+5reDCj2VFnqLpM4TH6V0fy8gMaXt6uuK1GxpT53vlfpCl+YwUfT1HhRU/ATbdLyvhrssMCdAIqekg==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SJ0PR12MB5611.namprd12.prod.outlook.com (2603:10b6:a03:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 02:45:24 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 02:45:23 +0000
Message-ID: <e02b3b9f-85af-4df8-923a-cddf13afb6c7@nvidia.com>
Date: Mon, 27 Jul 2026 19:45:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 05/12] mm/gup: add get_user_page_vma() to fault in
 a page under a held lock
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-6-riel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260724222934.1463812-6-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::14) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SJ0PR12MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: 12cf717a-8ae6-4ebe-b8a4-08deec52456e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	H+mJuL/wlA9XpeYKaL314kYZvYkNUV5tTz4nVPpuwZQUc0sGOmWbywgMJ2XElF6ERL6VxYB7jcgJ1ps0I2t7CTfCFfpYzMqY40aLLBDhT90Koi4I7nzPC17T9hnbyKNB5uEH5PV9xF1CpHbZSejHOFrcyQeRC4h3fPv5Uw2t3lD4ttqhm1R0NVuPJ+xRet/H+U5uROkX/h6oW6IJxynUmZzyrHDleAyJnNSdh2Nto8LbIi6kQMHPgHfEgQbH2SFLZqiyUWYNKJRQ32DIAMejxT1BkKejmnvZwzLx32MZ/eldOivJhRlwciTtMKEzLIpsVEpQiqS+UGLOCJON6aZ8RuSlqzdrEmGX6l5ZoPc4JsrEUm1QLrNw1caViD3WxyeSobwmXu4qXib0xrkyfi9nSJA3PapNo0URgA2YEujdnY3+inESjuXw8qJDEHBhZXeLRS/Vx5lXzQAaEV75vcJt7U2eEq9RlPKF5krCtwD2hCyb/I2d54TZwGgu+8C1Wlbl5BDQ+U5/isYDq5NdALvxH5AQOD9evGHrPMmryUPQE2/xJbZ60qLke462LiQWKBgzs2iwGkKEAUhw/upVwcLUTerSaJjc8EdPk5LbCiG5bLFwqjzEu4sedsiSjz5S8DxhbNhWv0KRUipqdmjHYWq+av72Rz03yWHEsB0ejmzyzQE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWdWMFlORWlKYzBKN0djT0J0bmh5Qi9YWmRJQWVUTWkxMm9Kd1p6YWVnUjVh?=
 =?utf-8?B?dmwvYkpNQ2pQanc3ZnZGSEp4cDJiQXA5YkVsRWlZWW5EWUJFOC9nT2JKMnlE?=
 =?utf-8?B?ck5jd2FuTWIwbk5NY0dhWW9yajhTYlAycVBad0t0TDh1RzIzQlQ4c2Iyd3J1?=
 =?utf-8?B?Zm9yMXVjMWtEcVp6Zk1LclpHUlhaWFYrSXRtUzVmb0VhQjh4WUNsK3YvWFZh?=
 =?utf-8?B?ZVlMTDJKTDV3WTFUdndZWDQyRjJxZ1pzRmcrcXl5STc2OEpHYU5SRitTK3ht?=
 =?utf-8?B?WVZEamt2dVUyR3JTbFM4a1lyUkxnMCtMVUhDNm9lbStLREczRDdIUS9WYzJP?=
 =?utf-8?B?ajhXSDJsUXBKZm1ZSXFBc1k5bis1MFZLaDlHdUgrdHl2a3FLWDRHaEVyczRj?=
 =?utf-8?B?a0s2OWppb2JMY1J3bWVMNWo0L1dyMHk3V2pHcFMrU0xDc3RzMkh0dEU4cldq?=
 =?utf-8?B?ZloybjlFTkRXbEtFYVF5R2FyL1VzN2hGdDgxZ0w5d2JzSE1tc21ER3dZV2l5?=
 =?utf-8?B?cUM3UmtzdHdZanFHZVhGTUR3NGE4dWtpdHU2bU5ZZEtQcHRPN1J6UTk2bzZW?=
 =?utf-8?B?QS80cy9CaGlvU0EyMDdxemxWV2FmcjVobnF4WWFqUDA4RmJMZVNEZ3I0QUh3?=
 =?utf-8?B?aGRodkFZY0huczlhd3loWXROc2VDM2xRZ2g2SVZXMlROdUdZTEt6Wkl0NDBw?=
 =?utf-8?B?aFdjNUkwOFlrSlpzblhPV3ZUWXBCdVI3eURoU1JId3Arc3JBdWZUWXhqcUs2?=
 =?utf-8?B?eVFwdE82eWpwT0IyWjl2cDEyelEza2xEUWZGa0dZaGMyVWNXUGxXaUxGYk4x?=
 =?utf-8?B?bkxNcCtOcGl6cHdmZ3VVbHhOL3hFSjlIVW8rMEdxZGFyRGJhOHcvK1BZMGp2?=
 =?utf-8?B?ZFRRZjQ1aWRJTnBnYU5YdG5kdTA2R2Z4QkY2eU9Za2xlRDRtd083ZFIwWFo5?=
 =?utf-8?B?cWRISWhGZ0tHcHpwVFVmR0NWWUhuVm1Mbk8vQWd6WDVoUmNVaGdkVkxtZ2R5?=
 =?utf-8?B?aXVzS0JIY0tYV253YnFpQW5Pelp6SEdxQTZ3WDZhc3ViY0NJOG9QRy9kU2RC?=
 =?utf-8?B?dG9EOGtQdkFPUjlKaTFzZ2txWGk0eEtNQ0YrQ0U4bU1iUS9YWWluNnhkVVd5?=
 =?utf-8?B?L1ZTN01ERU9QclBuMGJEZnBOc2pYQjNiUElNTVBORUFSMSsxV1lSaUZjM25z?=
 =?utf-8?B?eVpPV2lNeTNIc1NsUDVwYkwyRXpIQWE5RTNkbXBmaXlUczlXdjgyNGRISGEz?=
 =?utf-8?B?Zks5WGt4TlM2QUlXY21EWXYyTXlpS0RacGUxSVRGTlRSek9lQTlIMUJLOHZV?=
 =?utf-8?B?TXNDUzJxWXRLR2JWZm9TYURYTnhSeXNkS3RJTmdTdTNnSTY3ZUNHclVUS3ZB?=
 =?utf-8?B?bWp5STlzN3gvSHpsTmQrRWViNHdSQS9GKzVVL2lFZWsyNXNDdnZIcHJtbTBJ?=
 =?utf-8?B?WDRjTnoxQUNwZmYzd2piakJxZFVTbEEwUVVYWlpiNmNteEY1dFNmdDZsNkN6?=
 =?utf-8?B?KzNzWHZiU3ozTXRZTFNhSmRJK3hUT2VReUxGRnNOSnE2bWZwejBBQ041VGNx?=
 =?utf-8?B?RFlQNTRRQUtUM1NMZGNLNUw4Y3l4UCtYeGZDS0p3WG9TR2VOS0JVUzZmMFhK?=
 =?utf-8?B?SXduaXRSVHkvMVd0bUJURTJySEtlbHlsaTNxM3NLVENTTE5MTFZYMERPdXZ0?=
 =?utf-8?B?SkZaM01pWnNnQ081Umt6cFFyNGY1ZWVpUWxTTVNzc21xTkFlZG55SmhyREl0?=
 =?utf-8?B?dXVaU1hYQU5uR0orYUxDSkpDYm9KLzFqYWtWRzJ3QWcwTVRaSHI0USszZGN1?=
 =?utf-8?B?dVRXRThxQW4wa295Z29MT2FtV25MTStWbUFTSmMrVExCUnFleTJCM3c3VXVj?=
 =?utf-8?B?bFB5QXNLdmFoaWZSYjhaUzdNTFI4U1pwT21LUUkwd3hrdUpwOThBcm9VZUJR?=
 =?utf-8?B?dWR2cWlUOFdJZkxHS0lXYzJKWS9pUTZheE80WUE2ZThXaTFrekNhQjZJK3NQ?=
 =?utf-8?B?TTZVN0tYMmU0MG5PUDlMV3BXMEtBOVh2Y2RIOXVKQ09ySitiZGg4REllYlFq?=
 =?utf-8?B?UkphWlhQNnZrRGFhZWRaa3Z0dmlzV0NQZE9ReFhlOUF6bGFjRU5MZXRlSU5h?=
 =?utf-8?B?WnduRGtBckpQaEZrMndlVVJERWd4RXNIRFdQM3VYUXVISHRIc3R2L0h1VDZq?=
 =?utf-8?B?MzVvVTlLb3hXc3ExaW5BUS81Qk5aZUZLQmVXMHhYdW10Q0RuaEhOVkljc3Jx?=
 =?utf-8?B?aG1CQWJnSkJkVlY5YVh6VHkrSjEzTkJLNm5hSUsrVVhKRktmSjk2M2picFBP?=
 =?utf-8?B?TEJOY05QaTlhQWZEcmxuOWpEbFlwUjBOR1JVZGVPanhRSjEzUXN3Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12cf717a-8ae6-4ebe-b8a4-08deec52456e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 02:45:23.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPA11GQn7QGUJf5GligjAnsYTOhJAb7hE0PXMC5qcendRc3mzrVufpzo6tbHMMshuFd6fmoUCMpGB3f2rgcwXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5611
X-Rspamd-Queue-Id: E01F08000C
X-Stat-Signature: zeug94o8tncdyihb46iyz8x849t198ma
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785206728-965384
X-HE-Meta: U2FsdGVkX1+2VIQpmi+v7C8ova0kNjpgTzlUNmzAJH4fdnTjPxiGY6DIuJQnlJWMi8XaWiFnrzZK2pv2/8BBZSfLCm6wlhdn5aibOWnPCaNz3tmtEJ7KdGwyOWfMcKnZH0tQff7EZ4Eu423ckeWfWoJnm6t5zRC81cBzh2WpJ5gxi+22/Po3zN/ROv4Pt8OMNZqwM07+GOhoneiZhoxZNN4YFyzm0t1/IsCC9WLIZJ0Va/WEcw7rCz538E96KCS0ore2xI2hGHvmF4GMSKA6BpFjziY9XpxsO210kN0mSq431J4gtwkSjy9gSJJhM46+xdLdFIZ3GyK0kmE1fRRG5pabrSMBHJENFBa3PTMTI7fcsWP7Z4yoxphIhBCgrevwGIESf0wylRI9lLwiJsxfRdk+AQ8Mu8oI89XmIkMfRB56P44qqFVktuZrblr19PZOOgv1PF1aZqj+4IXlgiseD680vGq329MBVNO6upAhGVekf5MG6EAaSsqmBjcvkqGOXklU3zV7WN3HfqUBSYKSAzc2cFGGwqD098FmelLnd+INwTVqutK78JfqxNLQrvE9pAM8Z1SKDWOGHXNucHRJSP3A6D0jxq8DCGPwfOzNN6c7ztmwB3LopuiAWgnbqx73Bh2IOB9FU5lhNqFpahSB+8I7EloUP3CP5DabL5wUdmPueT4NVOV0eToW4R/mn4KwANotXtXBjmNG+Tc9LhDRngH3ysiknAht1xqQd3kYdv++etjsXr7oVAFZ33zMu5Go2k9uBOynCv1+HVVWDqLNSL/UtcCdDJcH6v8J6grgXxCEmlnNiSPjR83TKHydQhhYm731xxK2s/B1k3SILeLP93u0ClSw3lApPIPrEZ0U0av3AGbg1+WpNgyNjs3YnLi9gt7bhbodrEFSa7PlRgmBvqn7h2psMb36fodpZxgOoKZMlyVkxiiy8I+eYSwruIFEKByrD7UfwIHuirbw14v
 XPwoF48r
 SUUrMFhczjE1jGUM0taixf0lIk5dRYyLHslUlpTDFYHSjDih3IvEqdKAmUd1S75hS5/mel5bsieg0y2B8pa8FbGFWorO9jBNwfIw6cyyWtSJt7hKrMcE+UOVJxEyVVhSIfnaDvPILHgWhyJSG7vtZCcnNKVCnhDtZijc3oxAQcjeony5QPI61TWkda/GZChECSnjahxpz33siSV952VBThfxt+30dT6y01dRrQ0tRGP6gfOHF8H14Y7JUfkKrNS70H3M/yLsNc9Y//gIgEx2qS+bE1P8rIUadQTklU5XgIRkxl3W2Jx871ir0mi+TdhsqhDI3bEySY0ixNEEOmx5AG5WKc8rdPDm/LMBABdD3pMYLuVp8PVjcnbk90gK7B9IZk+p727+vXFfsU8HrDag6W8sk866aX09dxQ2mi9EdBCAst5PtIlEBTqyN9nGbTOAGvgbbEJ4CnVTFoog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 3:29 PM, Rik van Riel wrote:
...
> +struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
...
> +	ret = check_vma_flags(vma, gup_flags, VM_IO | VM_PFNMAP);
> +	if (ret)
> +		goto fail;
> +	pfnmap = vma->vm_flags & (VM_IO | VM_PFNMAP);

This treats VM_IO and VM_PFNMAP as the same exception, but they have
different meanings. VM_IO tells MM callers not to inspect the mapped
pages because accesses can have side effects. It does not imply that
the VMA contains raw PFNs!

For example, sg_mmap() creates a VM_IO-only VMA whose fault handler
installs ordinary pages from the SCSI reserve buffer. If such a page is
already present, follow_page_mask() returns it before the pfnmap test
below is reached. Patch 6 then lets /proc/PID/mem and ptrace copy that
page directly, even though sg provides no ->access callback and the
operation fails today. Writes can also modify the buffer when the
mapping is writable. Existing ptrace authorization still applies, so
this is not a privilege bypass, but it removes the VM_IO exclusion for
a driver that did not opt in through ->access.

An untouched page in the same VMA still fails because pfnmap is also
true for VM_IO and this function refuses to fault it. The result
therefore depends on whether the target previously touched the page.
The required exception is narrower. A remap_pfn_range() VMA has both
VM_IO and VM_PFNMAP, but VM_PFNMAP is what identifies the mapping whose
COWed page should be returned. 

So if you use the FOLL_PFNMAP_COW flag suggested on patch 4, and test
only VM_PFNMAP here:

	ret = check_vma_flags(vma, gup_flags);
	if (ret)
		goto fail;
	pfnmap = vma->vm_flags & VM_PFNMAP;

Patch 6 can set FOLL_PFNMAP_COW for __access_remote_vm().
check_vma_flags() then permits VM_IO | VM_PFNMAP for that caller while
continuing to reject VM_IO-only mappings. vm_normal_page() supplies the
remaining distinction: it returns the COWed normal page and rejects the
raw PFN.

Something like that.

thanks,
-- 
John Hubbard



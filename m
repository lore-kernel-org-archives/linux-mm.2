Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA0DC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220A86B0098; Tue, 22 Sep 2026 11:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7476B00A0; Tue, 22 Sep 2026 11:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E60A6B00A1; Tue, 22 Sep 2026 11:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAF7F6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78BBCA6731
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:29:27 +0000 (UTC)
X-FDA: 85241782374.12.E8F3A27
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8BDB78000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qW+Qv1Vd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUnoVLscby481jfLIaBWdEA7g93FRfehjwVF6UygmYI=;
	b=SQgcCoP+yprANneA6m1PqBPas8W5kTtvgVgSyKX3JKcC1nFeOiO3GLqT22pSpEygEqOCP3
	IybEBq/m7xCzJU6jnD4SOhJObfo+HLGYdywoC0HPUj39MbC56tgcrDZDzx2mN+8lNTh9o3
	W5+9i2Cv8s99veJsI5f8iCz10UmDoCY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qW+Qv1Vd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790090964;
	b=tFYQt4oxXN473tmu77e6F11aNoml0D4F0IYN1xtZ6fLE+p89YtzDtySKMrJxYWEWRmqiI6
	bohe9H8g+cfHN4I2MJ7EQKf8PNP/j2kl8XeQWeLpkvg3VBBwi6IESqenI9/eL9zv4YZyKW
	YsFrmeasjiDpCI3yz5ToYe1qClwvTpY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YaTCLdjhBSIyq7lG3wBVA/xB9iWFZgEKvh6aiQKkYXz0Jb/89+o7Dhh9jo8NfOWXjx8wypkJCD5qEaMVLLsXu2ueAvhyhO+UL51e2ggaFvZPvuJV/S+aJTbBCO40FFHl3ohus+mw1bWCfvWm0lpw4TvlWujRuh9Fptwt4wFh0qulC+QD7SHMv9U15nXWg0fV/Mw/dBOXHaCTE2+58mqn7YyUXi4h0t9cWz6kzViUHtQv2/dKyet9j4QPBE8fjwhdaa4sLGK39DY3ruyX0fAmPHmCfFlphQKbFJgvz39O0oVHKGObTgQu6ComWozp3PBL8T7TpsFu7fGg2MCmxRjakQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUnoVLscby481jfLIaBWdEA7g93FRfehjwVF6UygmYI=;
 b=rWWNrftilvJiFvMA6KpRZ7KZrVV7EHqjzlATJtigsLQaADfu19qhrckK3qQwFJLJiAbixM54ND6R0hWEwZ99Hb3pQxNIZBQTugh0USttEvAbNxsXatOgtQaX1wGbv5R7ZLT/oi6NDbB/C56KAQH2XZVwLTpyiJQr1+ogXqTgdbI1YJ+012ElMtJSqI3fbZLdpGNllqn6Cv3FOzTCHVpBO0Nk5RKQov7cJDJMrcvZSMttnAk14LTPjqf3WhPH4nAHvvoAJiC7+l/wuLzd8GsHSkjib+DHsAIn989LnIMxPse3ce9dqatb979WStrsOxq2CB/oiyt9zohPYDqfztaciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUnoVLscby481jfLIaBWdEA7g93FRfehjwVF6UygmYI=;
 b=qW+Qv1VdQr9J+/mx1NkyEL1Tc3I/kr/TBvl9FOW3jAiGe7FJ0l+eqIMTau5us2rtuEu7tAzqCBKLajz7yy+VcjpMxNcwwk1Y3WhC91GnWBuCvWeUs+ha6p0qv9XLvOsRRztZXn3Mw++syFze7u0Z0SvqWB7y7r1MVHqZzoTWlI49WVRuozT1NyltveX7sNhIGxbGgD0TQexqhRxXmxgI17huoErr4tnKHEc3whQoVbch0D0Oflsz+B8j7jJIuQ6gB1ryvskUS6/4r1vL8GBXLvNmDEMDTXdhcLqVjaq9tSpo14qpImzgYAqpqq+tCnzRkSyTkI+mOIOh/B70OvTHnA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6935.namprd12.prod.outlook.com (2603:10b6:510:1b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 15:29:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 15:29:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 11:29:17 -0400
Message-Id: <DLLYA97QG5ES.P4FF23PGA3MQ@nvidia.com>
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <joannelkoong@gmail.com>, <djwong@kernel.org>, <yi.zhang@huawei.com>,
 <yizhang089@gmail.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: BN1PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:408:e1::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1e9e98-2931-423b-ea03-08df18be454d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|6133799003|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	liXCwOex0MSy3aUoaqGjUqyXdzbe4erG3D7q0cl/Oj3jbjpysY8K1hbzoOGQu5wD92lUruwMo1y6CZ/Ge3Drl/9AUrRRoTals1WKgVvNj9rF3v2/ZUEiJbyPVGThU4eDLqUYbcq9zUnPMkJI9swED/Zu7YT3VOwkFnELOGiF/beIwKFgnD8lJpZn8ZTCcGy9+4BXzqZo8cLoJAQLdUDnxJ8iyjhKzfrd2HfUhrSl+yUmOcZDdddyPXGT7tyHqw4g21wyU5+JUy+CXDS1Bj49fouy/SkKf3SEhZQcvdga6kwi/c/scqIbGJeUZ4CwxyVULZjBxIlO6a2xOdf/UQGzGxF1KuhLrWxiz7LxhA5pp2BwOaJITK5tCIta+JGfEoIPPbqF4YZRXlh0VhvxEAZxS5FN2ErpYxUBwChp2bgVU8qiabj/Ai/IDarXNfXu+JSv4nqNNyQMguvF8zEP8zbjMtklUjerOLZ8BTh019sMpayi2jqF+Joj0pmA9St3jtTComU41RoV7nWXzOUK9SaG5lDsmGMR1FkZ1dmwLbYYfwsYW7oy4OnEfzx2qUMzjNpXP4d3sbXU0KTRs4mD8wk3nQHPyy2qDeMZ1s5usgqYY7cDnJODtKOmUvQonLdC5+uZZuYjy/exgN+J34xb2gBOdRbx2jtl5SI3qrfuY/BeTog=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(6133799003)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHZIKytibFpaYm40cjVidDRJSjZWV2dHT094K0Z0RmNUWXlyNHYvY3NVRkdV?=
 =?utf-8?B?KzhDN1hyQ2FGNzc4WU80OGxkaHNPZmgrOFBLb0FqOU9KMjU0d204R245bnFr?=
 =?utf-8?B?YmJJL01LbjE0NjhHRmtMVzZJdFVxK1BxMkRVN2NaVkpEM0t3RVh1VExFRHNk?=
 =?utf-8?B?ZHEvM2ZpaDBtWEVVaTNUbXZ2cjNCQ3FGUUwzRnhWS1JzaS9EUllmM0lXVThO?=
 =?utf-8?B?UitlWWVBZjhmQ1dWQ1hBR3JhRDhJdE5XV0UrbE1zS0R2OTZseHUydk1JZm1C?=
 =?utf-8?B?cnNuSHNyaFVINWRzZHJEVmFjS1RFVEk4WTBtcC83d2dVKzgwMEthUjVZSkdQ?=
 =?utf-8?B?eHd0T2x4di9XV0xFTThVek5BMDNRV21SU05ORit3SWlXQkVSUUs3OGJhbFVV?=
 =?utf-8?B?STdqeDdLMEdxZ2NpZ0lYMDg3b1ovWnpwcGc1U3RFd3MxRHFOSWJseldpdTNl?=
 =?utf-8?B?NERKVUEyY2xYUXl1aU54N21uZlpvN0c4N0pFMi84aVdjeHRqd1VVMHN2ZWVl?=
 =?utf-8?B?V1RmNnFob2pSSEFwTUZuSjVoNUZmWmV0QkFmcDcxT21RclMxeFJWOXAwalp2?=
 =?utf-8?B?Um9lR0UvdTlqaTRJSmx4Y0VTaWVQZko0RXczMzd6R2FNOVkrVEJXdWFkaktT?=
 =?utf-8?B?THlKaHJtVW8wKzdrWmdGcktncEhSc0lIczlsczlYTThXOHZ0WEMxeHRZSzJz?=
 =?utf-8?B?R25tOU1vV05idWxKRExQWExHbEloR3l0bmFCUElWeDlkcjJITXRZbkprbVhR?=
 =?utf-8?B?dlJIcjlyNlFiNmlrVm9nTWE4OUFrelNIaVN1K2NseU90akMyUkh4ZzFHOTdv?=
 =?utf-8?B?QVN2TldwK0dpQ2UyR3pFRVpGM0JrZjN2d1V4Q3RTc0pXbGZLaTJKSVhvbEpp?=
 =?utf-8?B?KytqNGlCaDU1Q2xQTW1oNHB3RHF6cGRsNXpvVEkxanlmZzRoSTJlOTRnbm9U?=
 =?utf-8?B?bHFqaVhsaVlkOE01YWJmdVJuOWYrY2lhaWlrQS9kRFIzaDZqVXBRV1VPZU5P?=
 =?utf-8?B?d1drV1pRWmdMSlJNL2FJTjd4VVVaMlVsazQwTWxNUllWV0gxNVNFZUNlZ1VP?=
 =?utf-8?B?dkpwTjdhVS94UmFmY1hCUVZXYjhsSUFFUjR5aHZFMzJWeWZQcERLRGkrTFVx?=
 =?utf-8?B?dDR2ekROUzdUcFYyc3Y5NWhhRWZUM01ZTk5ZS0E3TUVhZTF1UHNMMkxIVXhD?=
 =?utf-8?B?c2g4R3VYU2I3eDUwMmh3TC8yMCtWb2o0c2ltTlBrT3NmREtSYkRuNnFVY1FM?=
 =?utf-8?B?SWdRNEhsWmk4VWY0dW9maHA1QjFibldQelVKeWtaK2Z5WWJ3VVJWQTd4R0Q1?=
 =?utf-8?B?UExFMHNnVlFHVXNMTVYvYS9BOUFMb2tic2M0cW9UN0dqOW1BeTZTSC9lZDJv?=
 =?utf-8?B?citYZUU0SFg1ekxGOTZOaUwydDM4YjFVd3JFOWlCQllZUkpOR2VBQ2h6aE1o?=
 =?utf-8?B?cWdUdkJJV1BuWWE3MTRhckU5OUNpNXEvcjhTY3VUelI3Z0U3ck1QbjM0R2RQ?=
 =?utf-8?B?TFNzSUlCR0VScTg3ZkRLOWtsdkgrN0lEVjBuMUFLSitvSHdrb2RaQUpBSyt5?=
 =?utf-8?B?NFAySXYxK1lLR3BnS0J0SXFrVStVKzBSaW9sTmM5RHQ4Nko4aDJCY2pwdER0?=
 =?utf-8?B?ZWJJV2IzZTIyQ0VIc0dCRjROWFh3UE5SZTBjK1Bub1BUQXlpVmp5VXdiVjFo?=
 =?utf-8?B?Zzd0NjBRdm5EekRObDh6SmNPL0w0VVhSdUY5QjM5Kzh3NG1jcGRMRzRKUW1l?=
 =?utf-8?B?c0trWDk1S0Z0ZzZ1K01mMnQ1Y3JFb2xYcjVod3RveklmaWxlczJPOXpmb3Rs?=
 =?utf-8?B?UnV1alBwSlFCNkRzL1RiYm5lSTc0OG44VTllYUdaTVpibnd6SEJ4eXNySjhK?=
 =?utf-8?B?NnI0QnZ3OXJmbDFVU0x5N0V5TzErZU9zTXFOdDhvR2hRcVl4T3lETUdlUGJX?=
 =?utf-8?B?Uy95T0s4SlZoVFJPbTZtNXVsVDIvRnhVYSswc0tld3pzUlNQWStMRVlySEN6?=
 =?utf-8?B?c1pDY21oYkdIYVgwN0l5N3hadUxsaGQwZE9IdGd2QVNPMlhSQUxVOVdUMWZN?=
 =?utf-8?B?UElualZiclNOSjFwZVhSUC93SEFmWjV5SnVrL3hCcXlmMitFdHFtZmgwQjUy?=
 =?utf-8?B?amRrODNuNmJmYkJRaWNONVpwS2NyS2pyUmo3YjlkSUgwN1RqOU5HcFpmbWY5?=
 =?utf-8?B?UitkdGN3QWExNHM2WGtKQjBrN0RXcDc3ZHlzR0UxT004ZEpiMm5yVXkrOWdB?=
 =?utf-8?B?anc4dThnOU1odWU4NEF3cmYwK2RCcnRFMXdJeHNQckpoZFRxZ3ZCWkJvYzU3?=
 =?utf-8?Q?0k7Qnx/WQhtPXSn2Za?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1e9e98-2931-423b-ea03-08df18be454d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 15:29:19.6979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVRqUyc1tsqUqOJseJKEpV1+/BG0lE4DMrypl6pr9LkrsQTgomQpKvwd6Uw7hvXI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6935
X-Stat-Signature: kdonoyo5xzne3u811efsnw19uizxnupk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BDB78000F
X-HE-Tag: 1790090964-746981
X-HE-Meta: U2FsdGVkX19AS2UOmZn+yikg9KmMn4OawSU3hp3rGnrgL2x4ORzfFNa+BzNHhhS1xQKqVsasxrmCL/HKZQAoTixDJ6fUD3ygU7bf+eu2Rd/MYX2Jr3b90/RuBwsnsM4WQIOLtjKgyaDQQmBCWOWdo56uQ8hKzmF3q24fI+jeNmc1zHxIv8Dff2/EORoUQfTZTvBnQW8mE/aO98kmUM0e1Yx6yeIGWsssl3IXCoyNf9Qi95xw/BjIu/i8O3bmQFUowO5D+p+s16E/5kIj5WlZmWgzpL5jD6jrvZC9dwvQxxA9L1+D2QWgQi7BlGtN5HPW9nC+8WzKL+CTE6ZJTxaQHEjjieF5FyPMASN2V0gtj1ZR1tncTfdBDk0zLiYWcLDT3GiT9scRe2KV6T7PH8EYX9NsStW0xuqmVyhRfL6cwawqoQHhKo4sCHIApDJwSQ4QYXbDYGgbpMTJLMrjHgbqkNAS9iTfh3vSd88BDFpJfNJZ4ENkUkfd+07giuB8LH6n5HXM9bG8flLySjA0wqwKMr0Wf0klanoVHoIXPDHlJHyRr9bKJpcYjgm8+xX+zqRgq3/gZAHlMaKhh5Gk+X1qccncCctI6/PM0wNFu5uBrqHEZi1mOcIfCl30+mT+ZBQJa97l1B/OJWNJIPKQCPpZ8Xlp2ZWP/MMqpa0uoiLf8TSbYogkS0ZC8IhKN7xgebKN3DZeZ6MHLWjhNfys7iHkjC7XJyEhjAJuVZvDEdMoanO+w9pqgAbpZoBNZUiieDC7XUnHTcvHl235ZH22jKLg4qOAo/CrLnBs4PI7kFU15LF4MwyWsU/Iqm0nOFI/u3gfC4PDfn6WMCg2a3WwEO3T7HcxmjvMLuZ8uoXFU4F5Q297/ieUcFcOZOZE84BtLvREKbqzDEOrp9iOanciK1y3iIYtCZiHoY30nk3cEy6jio4G6FsqxZx/6ND1AXp4iG8gw+LLIfRdp6tcssehHkZ
 do+otzMf
 2nAtVP6b3z9qFJx2kmR/OsXMNHLH/SxUkyhwQrru/SJAtde5AKGMyRQ6moXeufXBW1tnv3C9k3CQm4ALZGBm5F7w/+2mUlus0zHpkUAK7v1LmrTFDBnc7yAqd4o24Km45TMxfzzl8gWMCUN3Lx3p5BMSCOYUcfBD5/au69NuIfltd/3NbcdxDDw8qWp4jP/Kpj/YDVGN5WDT5s3E/MTl2+8UU7L1FBIhYbjl6j6pVIwD7TfLzX5N8eDmfR5Lcow9CCjGftLbQiNIL+D3zUTPqc/efrV4R4fGt5Ey1LfecWof4XyH3uRTyxKJ+B1gb0g1NqxiGGmOBrp+i40c0bkRl1Lwa7ZLDT8DVvSRpZ9m+GXPiHKHwvi2DqHOGI+qV/sF5fHJG64oUxOb+jStMLp6pVJsh6Ye+8tgVv7IqjDYRFzWULho5OOSh0cS5xG9DxkxAqQmhEQrukh1tlrd43Dd1Ng135g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() in truncate_inode_partial_folio() stops at min_order
> instead of order 0, so the sub-folio containing a split point stays
> aligned to 1 << min_order rather than to a single page. The original
> boundaries in truncate_inode_pages_range() were based on page
> granularity, so either boundary could land inside the min_order chunk at
> its edge, and the truncation loop would drop that whole chunk, valid
> out-of-range tail included.
>
> For example, a 64K (order-4) folio with min_order =3D 2 (16K) punched fro=
m
> offset 0 to 36K:
>
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 =3D p8-p15           # straddles: p8 in range, p9-p15 tail valid
>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>   end(old) =3D p9                               # BUG: p9 inside [p8-p11]
>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
>
> It has gone unnoticed so far for two reasons. A non-zero min_order is
> only used by filesystems with a block or sector size larger than the
> page size, and those either always write back the affected range before
> punching a hole or truncating, or they carry filesystem private data on
> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
> fail and folio_split() abort with -EBUSY, so the folio is never split
> and the old start/end boundaries remain valid. The bug only becomes
> reachable on paths that truncate dirty large folios without prior
> writeback and without filesystem private data, such as the upcoming ext4
> iomap buffered I/O path.
>
> Align both start (rounded up) and end (rounded down) to the mapping
> minimum folio order so they always fall on a folio boundary.
>
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AY=
sy=3DOWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)

LGTM. Just a nit below.

Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..f9625bb4916f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mappi=
ng, struct folio *folio)
>   * @lstart: offset from which to truncate
>   * @lend: offset to which to truncate (inclusive)
>   *
> - * Truncate the page cache, removing the pages that are between
> - * specified offsets (and zeroing out partial pages
> - * if lstart or lend + 1 is not page aligned).
> + * Truncate the page cache, removing the folios that are between specifi=
ed
> + * offsets (and zeroing out partial folios if lstart or lend + 1 is not
> + * folio aligned).  For mappings with a non-zero minimum folio order, th=
e
> + * boundaries are aligned inwards to 1 << min_order so the edge sub-foli=
o
> + * straddling the range is kept.
>   *
>   * Truncate takes two passes - the first pass is nonblocking.  It will n=
ot
>   * block on page locks and it will not block on writeback.  The second p=
ass
> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_spac=
e *mapping,
>  	int		i;
>  	struct folio	*folio;
>  	bool		same_folio;
> +	pgoff_t		min_nrpages =3D mapping_min_folio_nrpages(mapping);
> =20

It is better to put it at the top (reverse christmas tree).


--=20
Best Regards,
Yan, Zi



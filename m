Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AC2C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA43A6B008C; Mon, 31 Aug 2026 10:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54D56B009B; Mon, 31 Aug 2026 10:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44606B00A3; Mon, 31 Aug 2026 10:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B35B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:35:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8841C14016B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:17 +0000 (UTC)
X-FDA: 85161812274.06.9920BBD
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by imf07.hostedemail.com (Postfix) with ESMTP id C253040004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JZt3Uptu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4ZxJq9vrRYOFCvXLVn/tnm1nGNGZfYfKAOO+2ul//s=;
	b=rqZgAh70a8pGLmj14y1QzP1HHUKe1UeBBUXZY5zq+yw7mPcWi9T+4+im/kQaXkpYNIFMzo
	RkI/764PDiFd886a5J1JnQFgvsyAbWlCBrGutp8wYNbs8x+FPmWHIBcsEBo0ieK5/LZchZ
	1esYG1AckMnjJ877/fAr54ZS9ywRmLE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JZt3Uptu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788186914;
	b=ZTu1pm6bzVWxexXphtJtsjev7AKM8b7nes43zA/qtScqIgc/f8IsT0vq8XrcAn6hdS4/qs
	rh/8g6GYODsW+1H6qEEKPvBWWwp9ntxkJKlErhcHJ1s4eIqSDqbPPjqQGRUY5YUzgA4fKx
	kMKy8XrTWkqRzB0/8YlumkeDBQKwwd0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3kP9dt8WkDk+fIQEMwXPLIsx6GpQ1szdqbZ5MK1Ra4PRG6STh8o2KXNoVDOC6VuAPeYIl6Z2KU+PjTmStuy0SvOSioiFB0dzCTXHg6ov+Bal3ZKlEUqZKGZWs9IuzYHYfBfv3pisR4cN4V2ukBrtm45DTUPUkP+XRsmOM/kiLwOv768HcR/TvLY1OfSEeOIVLwdrKsEUKqvWXSJuS33bfjesSRTFKr2fBmg+0f+0GoY6GP//4MgdlWkLJEwiwGaQRlBen+v1RnGXiScnoUFkLDfNUeZyiG6VnyKQ/v6RqcLkK8VIquF1R2ZOwC7Kg6qmStpy4lMaSuuTOpbSae4vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4ZxJq9vrRYOFCvXLVn/tnm1nGNGZfYfKAOO+2ul//s=;
 b=TKvUuj3Ilv+KobP0maMGGzdt1/vlyKIZmqHIyIC980GbBO1YgWRi+Hlm5aVxZMKgurXBt3SCHbZXNTLi5IKhe1KjN1RRQkUxl/1ka2OdbjqiVHekuHctRha83LzXElHPfx2WduC/DdPKBD7DZgWVYpomN6FYGjxkGDDOt6IDV6GLs4JlDvyLtp+NiRHimFQ278ezIVGhLU270qWBq25hEFeEz2NzVNQd/vp8QSPK+7AsOvUGffRsaIBF5BorSUqzjzSFBwm1iWA21K7VybS1SZOVNYHFiqQdNj0nNQfG7vbUeTGqKuEzwUt79pUGVoq9IIzdQSc4wq5DDiAwNyfXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4ZxJq9vrRYOFCvXLVn/tnm1nGNGZfYfKAOO+2ul//s=;
 b=JZt3Uptu+u770WuOD+8rnmnqZMNgiadqExzbds1WFDjpPgNUWGy1aipTPek0bwsgF77yH2HEekIqqYUJHwaWuhfWuVQDi4uoyhdW04wioMmgZdmdOtGRA97HLn3NRXMpWUuCTFY7P8LL5cOPkNT9SlcPEecrKfGYdgvaUjX4CaZ5P9JDlpDKf7OhAm3I3wbRdlyGkgMSFW7p76FaRx8130jBLR/S+FHKtwSkxw3Sq+IOrM6oWnCM8Wh8QAE+6S5K4uBjmPaONyN7Js2hgNPzVrjCQV1TG2vQK8AZYpPVFg33zitN3R+ISyzZb9mQG45QSl7Ub+OmDDOAcpVNj7IU2A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 14:35:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 14:35:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 31 Aug 2026 10:35:07 -0400
Message-Id: <DL37CSKRA0OZ.3OAX7A0UA8NS6@nvidia.com>
Subject: Re: [Patch v2] mm: adjust out-dated document of __GFP_NOFAIL
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Wei Yang" <richard.weiyang@gmail.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260829025847.26779-1-richard.weiyang@gmail.com>
In-Reply-To: <20260829025847.26779-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: YQBPR0101CA0301.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c8373c-5c65-46e0-1231-08df076d0eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|921020|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yAxAFilnHs5eAAYwJnJPAbgFpkSPxYvDygJCVpDNTA1sYA2beqhIB6zwh05WQ8lmo256jd2GggxS5YJt7mwxjgnV5bJeLP6AQR/w2mO5CVbw5hjt6hjmzFIsu/0SXir8U5Qy9Ugm9FV2Gk2FoNG4n/ornS2W2YxU2kAA1JRtrCzjS8l/7h0ruo5GnNajrY4OxMcLtkmTmTyk9mW/1lSAhNglDZ2xkkQe/WgPXG1sK6Z9tNvAcBmcubR23gOTe3J5oyiOfCkTeDIuEkpdmFtjxPOUPivZqKuAfnTg5c1k/kXTNPl1Wmd03H9wU+zreP25pUG9/kKfG0hGhr8vPx8FtIR1GFn4JbKO9DDciBvbJdY85nPHRtfZggLmcq2goAIBcMA8xN7h68xEhu+qhOhU1KvR3fKeDFeC8IXchZY/W5iC4CXevDoVZLhLFRbZ02DCuymQ0pNQlFanTrIcYn7UDftBZeOUh06rDUH4FOoNFu5wfBb+gqFX0BLt2Uo6hw5PtPL5x8EWamZdUr2A0xLTPlyeBgbSE689GOUHw6vdOAA0R0jjDhFicwO8dEFXU61y725BF6LyRLCMlK3w6pigKQAZQRC5kWDi86VRNmrqxld1KpMxGVq37iHwT+cmKKDV6WcY0oowcn5sU0J6vxla8VxcWfBesGAS2tcOmzWsdHmivyW3avJmriVuijbX72eNeVaaCmC+DqkYXrPS1m29Ig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(921020)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEs3clRxQzUxZVJEMUI4dEVzWGdEeHhYQmZ5bHFBd2tvMUxWbW1rY09SZUtM?=
 =?utf-8?B?Vm9wWjlzM3FHK0doaFRIc1NQdmEzZGRlRjJTWTFZUEsrMU1FUmJjaU9ubnBE?=
 =?utf-8?B?MDNqd3QyUDJIeVFmc3BpTGtSVWQ0OVp4NWJwTi9YZmFmUzU1TUFsRDZXUmRK?=
 =?utf-8?B?cmpqWFNXYm5mVXBJZ0tNNTQvdEhkQ1pWL1pZNnpqZmU5SDQzMUM4UkpLODFF?=
 =?utf-8?B?Z1RabnV6VDRvRWxnZWQxRmM5QWZuZjV1SUN5eGtwdm0yQ0doNVdkbC9YMTE2?=
 =?utf-8?B?MVJjL1k1M2tVNDhjMWZvaVJzMEY1SnplMjJzc1pvR0RmRkZaSzJqSExPYUZV?=
 =?utf-8?B?VE5sdHhrZkcvSjZUdm5HRDN5YUdhcHo3Y0IyK3pCSlNIUXpNUUJDcWQxUWMr?=
 =?utf-8?B?SU5QNWJPbVFRK2VEOTI1VnVvUW9tZlNaN0J1bWRTWitmaFpmS1JSbGlBZmZt?=
 =?utf-8?B?R25ZdUdrR3U4SDlETERpTnFrRVZtU3dIUkhmQlM4L2o2NGI1b0xQeUNkcFRR?=
 =?utf-8?B?a21WNU9hU1FEKytTSEY1cjhtbGVBVlZEWGFHak1xTUp0cFVTcGRXaHFvYURt?=
 =?utf-8?B?MDJIQ1pjU1RSc0MxRE9TUmFJRkIxbUNSZjhYTmQzUWl4TWxQWkFGd05LaWZG?=
 =?utf-8?B?SG8rbFdENWc1cmhTOUMrWnZ6UUxjZGRzRG53QlZ2UklRVTQrYkJRUW0zOXZh?=
 =?utf-8?B?VmFMdDJiUklYY1RrdTc1bGtCT1ljeXIreisrWEFXcElhVjhITTJjbHNrMHR2?=
 =?utf-8?B?elhwSmp4T0gwODBrNE9Zc0RTT3I5dmdKTW9TMVdNL2krOHorY0NaS1NCbmNu?=
 =?utf-8?B?NEt4RC9uOFlHTi9SaTc3Y2ErblhRais5SjZCR0ZubXE1M1hpcEhxdnJ1TGhs?=
 =?utf-8?B?SXppT0REUmV0N1V4Q1dEQmd3ZVY4dkpVWG1KS0E1QTRIVjVjV1hMWHhoQUd2?=
 =?utf-8?B?L1JtbDIzTFhVdTRrdDdmZm5IZ3VsSkptRzI2TkpLdCt2L04xbW13c25OdXo3?=
 =?utf-8?B?UkJJM1hocHJYRUhYQ2cvdWhic1liRi9qQW5qTWtraEFnK0dXZWR6T0RlU2VW?=
 =?utf-8?B?dUVuRkVzcytCWGdpbWpGUFVVbWp4b0FvTnIyZ1Mwa2YrL2MyM2NuZGIwK2pK?=
 =?utf-8?B?ekUxRWFWTk5leE9uWFVqQUVNMGZLL2JSWlNtdVBpRGM4WFg3bzZHY21VUHdD?=
 =?utf-8?B?bGxtbC92dCtka0FldmFmMlJ6S1BGNWtyclQ0ZXcwb0s4Vjk3dTdKa0llUmRG?=
 =?utf-8?B?dzdhQ2hZOVk1UmxobXBHRmRLSkQ1ZitVTVJQRGFncnordE9CVnhnbGk3eU5B?=
 =?utf-8?B?MDduNEVZdXllR0luMEpKRlZtYnNYTkJCMTBVUmJHS3RVRCtIZWRBNDhMSzhm?=
 =?utf-8?B?dVRqZlJOK0ZKYmE0TWhKdGkyL0NwVDlTMDF2LzFpK1YrUmxsS2tubmhzZ0sz?=
 =?utf-8?B?RVYrNlJOS1VVZTdENjFwa0JIb0NVMi8wSGFQNjdWdDRnMXl1TDNybEUwSHVj?=
 =?utf-8?B?RTVZUk5qdGEyQ3FkckdzM3pWakM0ZUMwdnJUNFBLbzR0S1Y2dXpFOWNwa1Br?=
 =?utf-8?B?QXRZc2dMSDJXRzFDUlV1OEM4ZHIxNkNiVGRycjN0YW9NbllLREJRb3J3TXRG?=
 =?utf-8?B?c2Y2dis5cTFMa1M5S2xoV1VrOU12RzIwOEJIQngralB0L1Q5eXU3RGptYml1?=
 =?utf-8?B?RWozRVdsaW5DQ3Q3ZnNqbjJjckZINjZ0VjhacURGYXFvcEljZnZiVW9TZXpL?=
 =?utf-8?B?TmFZenM5ZW9WS2hxUFZyK0F6MThNN01vaDEzcUhWQ1MwZGFOZkhOVER2SFFY?=
 =?utf-8?B?bTBzOHZ6NXd2RnlzVllGRmNUeGxWL0tCaGM5T1N3VC94WFpJY3l4bWYzRnMr?=
 =?utf-8?B?UTlQQndOT3RrRnltdE1EOG1jUldyZi9LWElaeS9iY1lqSU0vVzF4Z0VhZDlY?=
 =?utf-8?B?MHhTZ1FSN1FFUmw5dC9icFZveHhobDlObUxuVzZPRW1vNVltdkpkOFZVVVRQ?=
 =?utf-8?B?d1RwWW9RQWpPamE2Y2FCbG93cDhES0hDS1hQM3VhUEp2VExKMVdPNEwyS3Rj?=
 =?utf-8?B?TE9ucmlpUmVIc0dkclBDbTl0YnIvYWdLZTVzbzBIR2s1YStidEl2OFBaOFda?=
 =?utf-8?B?ei80Wm1aMGQ2cWV4dkJGSDBOK3I3clY5VmNPL1dzSjVPaFhQNGovMmJsMDNp?=
 =?utf-8?B?ZkRBN3NOVE9DSUp5WTlTZ3hZRitKL281alA1MjF6ejVja3FHbWJ0eU9yUHlS?=
 =?utf-8?B?OHBVNjJ1VHl4NDZHVTBndXozb2RObEl5dGR3N0lxNDBOQ1EwMnUvbmdWZ0g2?=
 =?utf-8?Q?VP7D6fGI8enAAi2K67?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c8373c-5c65-46e0-1231-08df076d0eb6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 14:35:09.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsbVqXrPCqVQ37gCL/Nwjc7UXMZoMowPFSrkdxvji/Pf6CcEXGKo4tl98TfhpuYv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
X-Stat-Signature: ar6ift69h8bog55u9an3yawg1aw9qwh9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C253040004
X-Rspam-User: 
X-HE-Tag: 1788186914-616909
X-HE-Meta: U2FsdGVkX1/mGBeQCWJOyzVGDtwDaauQqbENBOzk5svBzdu76QhwxZRChloqdNf+exwoiAo9DWfKukTxv34cZ9wXSZxQEDNmZLTEK+A4Ir31OmzPVb82tnnrNkwucswdFm02XFJaluvnpkHltAr5kAZJmp4+r0IzV2aw4U8zf4GCgpkRrsM5oaYcoPf3f31VmUmcegXuy4aaUHFKzy6+yY3BEE1bw4/SqA5DPPfAInKWJyWBxLAoJ1QZf/PfIcIT0muYZyV0RhQDz9KYsNnVM5QihFFCxu4TKZ1BrrfF39WCM0QdwftkUrhlk85Mii2YanuO+aSkB880Xd+9QUnZ6fkCf9spX9ygADjcG2VwtbCfPo2bb+/2g+xouq5S42HANbfz4fXweSnsmWvMrUjjg4g44IiQOUongjzgTEITsBchrMy/czZluY9yYMM4j45VnTgHzcpt6Jfwtcl2KEoZU7ufk9LdwA/sLUn31MKYbZqTBUHuvL9MrRYA/j2z4r1F1fiTFpx3LqxBtq//FyiPjVWS8ObJFumBct5RlTZQsfX9qd2f9e7DJS+x2XA9I8yXwpmxsGAX29h2XJn7JQCarkkE3DS8rbfvcX5PYntHO7ZMJL8JA+NwsFaBpaKNlm9I0yGohBwciODDmkzUHZe+sPHjIoDu9y1xpjpuu9D436q1m0hysUuQyHSVy/PLWmvXIHs1XQqMxUfB+zYm7/mHBNGI+oawiZaIoivm7sd24y/BZm661v7bVGLwiGVXlu6GAUFRLuimxj41s7rT3ilJnDL+lNdShBnejJrDOET9akSEfjbX2V4Dcqt14Yf61fnEM6zXOtgsjyx7KurZjwIOkOqctYMcV8bS+FOGz5YZMs/YtQRJZ/nze79M20cusMXQ0ZocoUcQRbsnGOHrltkccj9sWDQNJ6aMoqeDx2tVJZjfx8AcbgJlWGU4TmyXfr+gZF2nSnYMD9+G3AAkvhu
 ST3rLqt2
 q+BhcMsRvNbS02Tmqgdb1U7bODsFkgH4Pp8ADeUNPiQ6YBh+sdlgh9uTPeuyjoJbU2GrefiOEO/y8uIGNfn7ZYPyLXtMui2JnhUD9GCPd07F6YEppxNjzXrbGzp57aIWbtHYPDPdcy9SWjGCysWGHC7o09X+i4H/3QNIjTvbTTufkZwqzb32eCmYRtum+RlWFrpDDvJxv00EiIisqJAD0RS1x0ppkXY25DmTckrXW9trbBpMl6qy8+GHsZxlIVNUT1JsIsRgUaXrDj6U2GASxbhRNe/4LDTJeksSGCrPfqIXjxbMaDuR5x/EdHitdQDZqQIMiRuXeExyEa0cYC7YhD1wBIyNQTUfgaxiQd6LC0J9sn3o9tZcJH9he9x+ugrqWeJVKXBtR/O2+mdBC+TPdgMb7KWfCJWOh4A8Iq/W98XAW3PnFAA/3qm4mP+jlZngBDfv0zak1e2XFJzw6Eq05GJL6eKp5OgnCEKWxkDW2qPNMjLm74PPMi8mRVJjHb5uIjb+9/jx5cQ5UxnaRe07ohjyj5OSQdWtY8s088WCaHJHj4sZ3YJuBlNTVhAxb4zXC3Qn+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 28, 2026 at 10:58 PM EDT, Wei Yang wrote:
> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
> with __GFP_NOFAIL") remove a warning on allocating large folio with
> __GFP_NOFAIL, which was placed there by commit 903edea6c53f ("mm: warn
> about illegal __GFP_NOFAIL usage in a more appropriate location and
> manner").
>
> While in that commit, it also documented this behavior which is
> out-dated now.
>
> Adjust the document to align to current code, and adjust the comment
> while at it.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
> ---
> v2:
>   * s/is adjusted/was placed there/ in change log
>   * instead of removing the document, say "is discouraged"
>
> v1: https://lore.kernel.org/all/20260827030548.16631-1-richard.weiyang@gm=
ail.com/T/#u
> ---
>  include/linux/gfp_types.h | 2 +-
>  mm/page_alloc.c           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



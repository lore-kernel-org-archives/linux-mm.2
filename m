Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13972C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAA26B00DC; Mon,  3 Aug 2026 09:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB4C6B00DD; Mon,  3 Aug 2026 09:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1736E6B00DF; Mon,  3 Aug 2026 09:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E13736B00DC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91C491A066F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:54:46 +0000 (UTC)
X-FDA: 85060103772.01.ED2BCB1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 519DD4000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:54:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=a1fNdxZF;
	spf=pass (imf17.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785765283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/1gRhPoHEcaO4S1BBbQYvfz6mXmbVkM35cABLK2k+E=;
	b=1aQdQZYj9jbquPrGLqQNwn7dg1GRVsHueJ/of+MBbQy1jUwL8r7HDRSQnG7L4c+3asFykP
	3gYojtjVAoIf+zDu/v72IIcgqdIygcTt/sFbV0v0DaNAydIF67Dy+/EzegTBUTg7F/ypT8
	r14A+Ocg7keXYZM5L+M7kddJ4d5arNc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785765283;
	b=8jfzaeUzHsin6D3xEjE3GNK+hmC4X2/tvDlitdxRVKCW8OPrhHSuIG1HoyjsS4NVhibFs2
	EJnB3HjggSMkSen/CIZDLyRlXH6nyv5A8MpfzBYM2lo6u7uaMbHtxslnIDH3hE8Wl57NkG
	MsWEFa/X+PygVmsVsL4DyiRPQ/EzrsY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=a1fNdxZF;
	spf=pass (imf17.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m24s7lvF9byWb4upvtYMQ1OFW2q8PCpMQnleJoW0jB7izOLr4R8A7ZApcOBShhtVHX7GdxtPbAiQMTEGrVgwDlPOzx3JGhUNzI7EPeNHrqko0kGHFFA/gWunwG2uILJFDN2VIid1/biDurVFgiaQhmzpzjPCXYfoc1tdqREcm2TcMFHLVRCi04qR8wdKrdShXn7hQlwjzGSTY7WEstEs5BL6RQvyWjklg3cmV6FunTH8JeScFISWi3zKgJJ0gfaR8cEbru72gor9Ip/x1YG0VY/ulm2hLgr1vrvw0S/FcZ/Vgz582OY+QDD/Yz018S4jSFJ9k+VaGBOPZMJ9oa+dtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/1gRhPoHEcaO4S1BBbQYvfz6mXmbVkM35cABLK2k+E=;
 b=WFtAqnsQHZkQY279BCXF8CDs2wrxSF6FmHB/fUlxFbGv34+Ry+L9evCNI0BJamZ1LLZhY6JsgqyR7ayIYsngTX/RrMUq3s+hFDBEtc9DkEU1ca/onxUbXTsMC7NDdrb0GS0xhWGk9MzrGbApfK3uNhuziCoeq0+EWtCeCzHOk9gCCSeYgqXCtGTCh7q2Blf1F38VXosyAac1ifVe6fWvPABcANLYmXbvrMhOCt7+eemqah7xLjH5Foce7xWFfysxN23TqWgg9AF12meRMrVNp3TPDoBiOjD6VhuEDzuyAb1R3JO0K2R3ATt6HLrgDdHg3I34u3UbrTdpbafymgKfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/1gRhPoHEcaO4S1BBbQYvfz6mXmbVkM35cABLK2k+E=;
 b=a1fNdxZFqVmnyM9c3AYDlLxlhwowsSmPh89dSxxtmaDyIm/rVoLTP5zFBMWhJLrhqtW/6EPkQY8ZxN18RmTSlZ9zjKwO8cYR6+D0nG3B96jxNQtkgg3NNyfb6UpJyW722z3UQzaNFlaoFzLKbK/tDN631+MNBUStweupce14+9Y=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 13:54:35 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 13:54:35 +0000
Message-ID: <80fdf249-6f24-4cc7-bc9a-91bf23293497@amd.com>
Date: Mon, 3 Aug 2026 15:54:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] drm/ttm: allocate pool pages as compound (__GFP_COMP)
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie
 <airlied@redhat.com>, Matthew Wilcox <willy@infradead.org>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <20260722044220.1110278-3-matthew.brost@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260722044220.1110278-3-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::12) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS0PR12MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b85e231-8005-47de-e6af-08def166c08b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	X9vXXrXKA8YuzMh04+PAROAaxrm71vsWB4vstcO404CkVcsbyoxKSvJ/ZluWm+v7YL9xQEbGSK6OA81fpaoVTcsaF9Scwdk/OlYE2eNIRq2n+q1RrCth7jpv2wP1ao0q67yDgJX28Z6ZNfQdSyVHJVa+/gn8P+1RnrfdBntXWfApQ+Y9/uMc8WvbJBmGWUYNs78932E2VNqColRO9nYeD5C/dqS00EQzSYchoIVVc6HwgFil1MMNq8uBvIvlv4AhrPBANIiPOc/C7/iFBpp28yOgTbCR0Oyx6sVGE0SkUXkyrVcOLjXo7MLtCB8sxe4v03CFJioWfyw3S/GMmI++yIJBI4RFaaYD0TDR7heJTNuxuDB6B8huWlCZUDiULcDom/TIZcSeR9K8C1Ah9TOLf4bSpqhVnD+U8RvJVXWc5DhFbAdfEmSkx78x45bf0fhop/o3I/AjKK5mDv19TUTeUsVZhyeDjuVwKyXx9xa3IEBnIOyzYWBUlrTEZW3xJyNOY4b51gUdHFsmZAxvoC7Fk0jL5Ty22WmMFSo8AvZXG+055e9cP4I4+pc4b0DEu62+nqW/YYowOavqi2TGa8fVHU3hZrMUF/QtBFAR0TUIUO6+SThdrlJDpDG5V9pr7OVz/H0PZ9bdaU5DPClMF+EOnRlmf0uOkylYiSaVF7JH1ow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UURSZHdFRWgzQzRFYnV4YlpEZHg4c204bjRvelBTWGF4ZlZweUZnZGhLSytk?=
 =?utf-8?B?K3dRLzZ4alFIOXVqVWVId29mVlpQS0txK1hSZTd2Wk16a1Zyb2g4NU14YUJY?=
 =?utf-8?B?RjU1K0NCR3lyMU9uMS95Rlp0cGJvR0RIbzlFdmNXNU5oWk84Q0o5MjRDckxt?=
 =?utf-8?B?QzlkTUQ3OThtRThHTzVCSEI0TmZNZWt0WlNlOXFIT2xjSFJrcEtHZ0U2K0pI?=
 =?utf-8?B?czRaWWllQ0FmQnN6blJ1NjJaV05uU3llbzBIaUIzQVFtNGZFQ2Q0VDFtdWNH?=
 =?utf-8?B?NlQ0NFlLUnkwUTZQZ29QN09JU29HT0l4UGp6clJiUzRwUWJaQWdFMnBmMXVD?=
 =?utf-8?B?bm5DbmFNUWo5bTRMUEZVaWYrODRRNGJhY3FoaG40aW1NdEdCQm9kMm9MRlJG?=
 =?utf-8?B?NFNOdldBRkg4ZmxEVVVTZnpGdGw0YnFhQzZkUUxWQW4wU2dqTHp2aDljUUFn?=
 =?utf-8?B?bHpjbndza2lVcGZnMldGUkJBbTM0RG9lZm5mRE16OW8vZmF4MVExYjZ0TUxE?=
 =?utf-8?B?WkV1MVBJM2VpdGRGdEcxaXIzbUJWYzRnVVZDTmQzeHk5Z3VoeEttSVc3SmM4?=
 =?utf-8?B?RVBqajJpM0wyMXZ6bE8rbjJJdGxKNWdXT1hydnphaEd3K2hEbnliMndZWjJk?=
 =?utf-8?B?b1JEWnl6L3pGWGpneU9zK0IrWGthSDlrZUplQUlBTWFycWkyRWxyM0M0bnA3?=
 =?utf-8?B?ZWcxY1ZHcGJBNUQrSlV0YU9CQko2eVpub2R3NzZHN25IQjFrUkRCY21DVHo2?=
 =?utf-8?B?SjFFSEV0bzlycmY4MWFucm1xMFRHdmRhSCtTRnZibi92ZllCM29tdXpPR1dO?=
 =?utf-8?B?bVBWZEppb09nTlc0cWs1RWMxcldYVXI1ZHZrcnZoQ0RuK0RtT00wS3JranNE?=
 =?utf-8?B?aytzakRPSzRvUnNtcWVwZXdkZUlydGM2TTZGSzFHQWxuTUpzY2JpQ1MyQWV3?=
 =?utf-8?B?OCtaS2s4UWVKUE90N1NpZWFEVHhxbXVuOGZyblRxU1RGZnVNdTRkd2pxMUZi?=
 =?utf-8?B?REtVeWhHWXpDeCtlc21aSUdtYmNHckRaOHBUZTh3ZVNwdjRFbHpsNHZXNmkw?=
 =?utf-8?B?N1Jramd2blFmcWJQdFc4TVNpTklKQ0QxcVdtQ0RZTGNxQTBpZU1USHNORHpV?=
 =?utf-8?B?SCtKdWpFeU9wVlpGa2ZzQllkTmZFWTJZQnBsbmhOTW1JYVhRNFQyb2VsZ1RG?=
 =?utf-8?B?K2dRajlQYkZhNTNNWVBJUzIwTTlvcTU2WitWR3duMUFXTEJCR3R3RTVuN0Ju?=
 =?utf-8?B?alhpZFRUSnp6Z2QzZGxJWCtidDN2ZURGWi9kZEdkSElncUNOdFA5QzIzTUVB?=
 =?utf-8?B?MVlQQUo1N21ZODFvaFVaVWplUXdMeG12eUs2ZFZaZDBCaHFQem9oNmZpQzJM?=
 =?utf-8?B?ZllFMVJrTnRMMWJsZ1ZLZmppaGVLK1VmZXByampFd1c2TE9oZk5MOXhrTG5j?=
 =?utf-8?B?c3ZZTzNWS0RlZXYxd0pQOXVmcmp3bHhIaXM4aWEyRmgzNjc5VzVKTldCZEcz?=
 =?utf-8?B?NjRDY0U3NUErclZXZTArTW44Yk9PSUk5MlpZTTFVMGxzME5YWnlhQk5LQlNW?=
 =?utf-8?B?dVlHdlk0NE9MeVk5VCtOZUI5MDdpVFRlSzN1NFhyWUJwTXNidFUrdUF2cDBq?=
 =?utf-8?B?SGpZZ1p5ZHlmVjQ2L3FUOVBhNG1oRmZvYjN5YzZzd3d2U2NCU2w4S1o3ZFNC?=
 =?utf-8?B?VVZHd0d2NHhNUElhSjAzNC92QTMwVFd0c3RiNGlvRkJaQUgrWHR3amFUUDh2?=
 =?utf-8?B?M2dhVWVaekcxM3JhZmxSTktBNzlPdkVBc2E5ZVBQZUd6dGxEbXlTaXl2OEFI?=
 =?utf-8?B?MnlMaUtIZU9Ra0J5VjJmUnZxMnUwenVrT0JzTDhZNTNuL2tKZUVuWjRZNFhn?=
 =?utf-8?B?T2dLZUY0RU00QVAybnQ0dlJueERVblhpT2hGVXdsTUhGQ252enJTQ1Vndk84?=
 =?utf-8?B?SlM3bmtjVjFqYjlmMlA0K0hLbWJqZklFdCtYQWpZaUNTR2FZeVB6NGs3SnE0?=
 =?utf-8?B?UmV0YVpCODFyeWRsSExYUGVjUkkxVVBMYzBLS3dYOTVRbVhMbkQ2UTkvUkZZ?=
 =?utf-8?B?cXBLckVjNVF1TFhHUzlOUU5NQ3NhZkd5V2ZEeHVsbWpPOVlHSWIyelNjdGll?=
 =?utf-8?B?ZlhoTnRDeWNvV3kwcEpTRzVVdzk0RFdhYlN3TTVqN3Q0aTNvbDRNTTh2eXlq?=
 =?utf-8?B?c1ppME1JVXdiL1dLcnh1VjNhWkVkbEx6aStTTjV5K0FGTWR5Ris0ZS9VVHV6?=
 =?utf-8?B?SVFUR1F2KzRkVVU5STM2SHhzU3ljc1hRbG1neHBVSUVJUWJXS2docTFrWlBz?=
 =?utf-8?Q?sYKam/003KsdJoQtTY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b85e231-8005-47de-e6af-08def166c08b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:54:35.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tggL/DKIAg+mCsLt1BDFx70PJwrruSptic6x7vUAaNHbR8TdDSlWibzIVy6mSWqz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 519DD4000F
X-Stat-Signature: baa5idh93ttjqakfw11zwyohmndohwo1
X-Rspam-User: 
X-HE-Tag: 1785765283-302054
X-HE-Meta: U2FsdGVkX1++0m7NKOZr1SOXezdNM1U/QvcsE8qUy+u0Jef1LbDfiVZY2TwJELTEw26bh/GH4XSA/UVGBImBOZ3C36wxjQ5C0Catf/94oddzsgX2b+he+FXGvBzQ9VEtYlBeztcbvBMGz5+PO4/6OW9K7gnPi3RQ22t1JlAIgpqklMwR488mnWyWcf5mYDjuBU89XjUFuuh7lKy/6MHaxwytpraTFFPkGKoFBLVN4wXY5OTRaPngck1l65iTG1L/ZoLyp2B5o6UzYmhoxcSSlrH3M1yZctQBT7PaIrvf7qBweCBH2qLQvIoJa7scmJ8Ek26yTjKXZiNFsQThSg6QwP+xgIWXxdMCPZLO83hsDQ6vwZPlkS2JdxKcZRxjA6v+BaEW5DoCDMmW5s/xxGndKTaHk9YnV7fb8sG1zvpOtv5XunXcVN9ximuHsl+p9I59KHtln2wVkOq2/viyg4mnQclKNQ8IFBVSGe70fhTsVf/ftsUvla1pjZqMASFG+l+D5X2waoCpD3MlkZ2Zvm0eZL3I2o5mPs9HZVlrzORcZnBNaPfLhEWN0N0lYv9LmdIYcyWo8xTFqox0n8b8eaKqBNJDLC5pjRukZfcGypRU66c494j7qPSXSbHvuDncliqNz8LzbWF+pghpGs9Ideab8Ns060CBXXQpP9ABGIpFHTqM2OVK3arTPK7l3VMeFVQIF1cP5djXoJrWkcle3KxHlc8TjAVhaj0a6Aak28nPGLnA5yOtpkE4hXtGALAlGQ4x7tM7ORNX0KfhST5yTUDZe0hKHrpGQZ3qBcWfcJpwDxAg2Tw4twdOT/fjUFQD/f9d6y8w0jEr8tq6ZdFZhZmEAvZoSCbTFR0QtGKIykD18kd1yxPik5yn/GAK9C/Xglk+MMghuAct0Lrbz2kU1lRwUq+xlWh/vGL+oI2sQXaCA34nveM/Qot8YI8S4CClJCQhW279XNbc0RuhlBjdYb5
 ftL8yVq4
 VY9uoSYSzFEMsEfNbYiELZwypPuggGMyfZxp3rEqm2IvIvUlu+/MA0xE4VoDBXfqZzVzqeiMWfWRq4SFQCbYLUVvQQOGRvCCkjvDvSV2CHUO+gnrBNTkZLbkhXOb0nu14ZeTCYYLLtxoC1iibtw8/fs+2UiW9VOzvPikVnPwQcKRdi/gIHwQLYRYVHjoeMehygDo1t8f6Sg+qgPuIWXV1VFBVDjCZn61jsffWDH/wWAmQDNPAlIZG2i/9cK9PmtIxU3wb2kgWJiHWOh6SMJtrlayTekKEJDbML0UNQy+ZrpRTzVU5EuD2xw0/IwVIG16CF73Nc5R8JR/X17M6rO/d8NUXiQ5HLOrY3eXpiFoaDj5hz0aVZ8WdLxJ+XMm6NQMfwhN+djw0vUGrIMMOw79Ye1GkQ2WM+hBLZUjHx4V0hgLrRW5k0LIucIkjl+kmR19tEfT/eUcI+QCER2YI5a68WbRj7QSRG5TupoJ1tQG0O3pnHau7Gln6vS0oYwEXU06pLj2pyGgggbprtBOdXdzcUr3hnWFbdu9zyEouzyWbWCAeZNyTICg/cdZ14ZB2GXmTv0IX3Xs47DiB0dpwtr54cIwknva5fwrvhqIHQ7luJ4vXvswhmT0C4OBUjdBUXRp10cyvW+Awo4+B1lKeN+795R1tPSRetksOl+LTSxJGmi0HSGbYbxi/BapdsnKCehnq8Xdijztm7C7/wSBtjVCEQVRgFMb1y6z/CoTMaaiUgOFs2U+r4LUuAdUQCNYcTPXZnWdpbtbCPQWJtpEVDQQdk623uYbKghmf0fLuowYQAY6k5nxLafoqvLi7uyMk0B56YXDfa0H57+OByZsxPrOSW68E/DJZpUBeMTEk4ssSGvx0qy+uVWbExxZvsV8l/wr/0/JpuYrXbll2YDf6ZSgwe6KtWj/toecnzhFlOdm0z5pSWwHwTTDKcH1n7e0ru3ep+VTRK64o9ntuCF6//Z6/OkzEBcRa
 eSmI0Jub
 udo8OBFZhwv+HmSgb1ra/lXV9jrsHY0bWVdT4j1drKQ+X08sU8eA+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 06:42, Matthew Brost wrote:
> Historically ttm_pool_alloc_page() deliberately avoided __GFP_COMP for
> higher-order allocations and instead stashed the allocation order in
> page->private. The stated reason was that mapping a TTM page into a
> userspace process and having that process call put_page() on it would be
> illegal on a compound page, because the stray reference would fold into
> the compound head and could free the whole block behind TTM's back.
> 
> That hazard no longer applies to the non-DMA path. TTM faults its pages
> into userspace via VM_PFNMAP (see ttm_bo_vm_fault_reserved() /
> vmf_insert_pfn_prot()), so the core mm never takes a struct page
> reference on them and GUP rejects the range; a stray userspace put_page()
> cannot reach these pages at all.

Yeah unfortunately I clearly have to reject that.

This is exactly what we have thought before but that doesn't hold true. Especially KVM completely broke our neck here.

But let's continue the discussion on the other thread.

Regards,
Christian.


> 
> Convert the !ttm_pool_uses_dma_alloc() path to allocate compound pages
> with __GFP_COMP and recover the order via folio_order() instead of
> page->private:
> 
>   - ttm_pool_alloc_page(): add __GFP_COMP, drop the page->private write.
>   - ttm_pool_page_order() / ttm_pool_unmap_and_free(): read the order
>     from folio_order() for the non-DMA case.
>   - ttm_pool_split_for_swap(): for compound folios, split via the new
>     folio_split_driver_managed() helper rather than split_page(), which
>     rejects compound pages. Each resulting order-0 folio is then freed
>     individually as it is backed up.
>   - Drop the now-dead page->private = 0 clears on the purge and
>     full-backup free paths.
> 
> The DMA path is intentionally left unchanged: dma_alloc_attrs() does not
> produce compound pages, so it keeps split_page() and the page->private
> order stash.
> 
> folio_split_driver_managed() lives in the THP split machinery
> (mm/huge_memory.c), which only builds when CONFIG_TRANSPARENT_HUGEPAGE
> is enabled. Drivers that drive the TTM shrinker and therefore reach the
> split path must select TRANSPARENT_HUGEPAGE.
> 
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Assisted-by: GitHub-Copilot:claude-opus-4.8
> ---
>  drivers/gpu/drm/ttm/tests/ttm_pool_test.c | 23 +++++++++---
>  drivers/gpu/drm/ttm/ttm_backup.c          |  8 ++--
>  drivers/gpu/drm/ttm/ttm_pool.c            | 46 +++++++++++++++--------
>  3 files changed, 53 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> index be75c8abf388..771ed257778c 100644
> --- a/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> +++ b/drivers/gpu/drm/ttm/tests/ttm_pool_test.c
> @@ -169,7 +169,14 @@ static void ttm_pool_alloc_basic(struct kunit *test)
>  			KUNIT_ASSERT_NOT_NULL(test, (void *)fst_page->private);
>  			KUNIT_ASSERT_NOT_NULL(test, (void *)last_page->private);
>  		} else {
> -			KUNIT_ASSERT_EQ(test, fst_page->private, params->order);
> +			/*
> +			 * The non-DMA path allocates compound pages, so the
> +			 * order is recovered from the folio rather than from
> +			 * page->private.
> +			 */
> +			KUNIT_ASSERT_EQ(test,
> +					folio_order(page_folio(fst_page)),
> +					params->order);
>  		}
>  	} else {
>  		if (ttm_pool_uses_dma_alloc(pool)) {
> @@ -177,13 +184,19 @@ static void ttm_pool_alloc_basic(struct kunit *test)
>  			KUNIT_ASSERT_NULL(test, (void *)last_page->private);
>  		} else {
>  			/*
> -			 * We expect to alloc one big block, followed by
> -			 * order 0 blocks
> +			 * We expect to alloc one or more max-order compound
> +			 * blocks. page_folio() on any subpage resolves to the
> +			 * compound head, so both the first and last pages
> +			 * report the max block order.
>  			 */
> -			KUNIT_ASSERT_EQ(test, fst_page->private,
> +			KUNIT_ASSERT_EQ(test,
> +					folio_order(page_folio(fst_page)),
> +					min_t(unsigned int, MAX_PAGE_ORDER,
> +					      params->order));
> +			KUNIT_ASSERT_EQ(test,
> +					folio_order(page_folio(last_page)),
>  					min_t(unsigned int, MAX_PAGE_ORDER,
>  					      params->order));
> -			KUNIT_ASSERT_EQ(test, last_page->private, 0);
>  		}
>  	}
>  
> diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
> index 3c067aadc52d..9194747a1dff 100644
> --- a/drivers/gpu/drm/ttm/ttm_backup.c
> +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> @@ -72,9 +72,11 @@ int ttm_backup_copy_page(struct file *backup, struct page *dst,
>   * ttm_backup_backup_folio() - Backup a folio
>   * @backup: The struct backup pointer to use.
>   * @folio: The folio to back up.
> - * @order: The allocation order of @folio.  Since TTM allocates higher-order
> - *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> - *         return 1; the caller must pass the true order explicitly.
> + * @order: The allocation order of @folio, passed explicitly. For the DMA
> + *         path TTM allocates higher-order pages without __GFP_COMP, so
> + *         folio_order(@folio) would return 0 rather than the true order;
> + *         the caller therefore passes the order explicitly. (The non-DMA
> + *         path allocates compound pages, for which the two agree.)
>   * @writeback: Whether to perform immediate writeback of the folio's pages.
>   * This may have performance implications.
>   * @idx: A unique integer for the first page of the folio and each struct backup.
> diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
> index 1bf37023fed6..364cc7ec7469 100644
> --- a/drivers/gpu/drm/ttm/ttm_pool.c
> +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> @@ -168,9 +168,11 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
>  	struct page *p;
>  	void *vaddr;
>  
> -	/* Don't set the __GFP_COMP flag for higher order allocations.
> -	 * Mapping pages directly into an userspace process and calling
> -	 * put_page() on a TTM allocated page is illegal.
> +	/*
> +	 * For higher-order allocations be a good citizen: don't dip into
> +	 * memory reserves, don't retry hard, don't warn on failure and stay
> +	 * on the local node. The non-DMA path additionally sets __GFP_COMP
> +	 * below; the DMA path allocates via dma_alloc_attrs().
>  	 */
>  	if (order)
>  		gfp_flags |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN |
> @@ -189,11 +191,9 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool *pool, gfp_t gfp_flags,
>  	}
>  
>  	if (!ttm_pool_uses_dma_alloc(pool)) {
> -		p = alloc_pages_node(pool->nid, gfp_flags, order);
> -		if (p) {
> -			p->private = order;
> +		p = alloc_pages_node(pool->nid, gfp_flags | __GFP_COMP, order);
> +		if (p)
>  			mod_lruvec_page_state(p, NR_GPU_ACTIVE, 1 << order);
> -		}
>  		return p;
>  	}
>  
> @@ -482,7 +482,7 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
>  		return dma->vaddr & ~PAGE_MASK;
>  	}
>  
> -	return p->private;
> +	return folio_order(page_folio(p));
>  }
>  
>  /*
> @@ -493,15 +493,31 @@ static unsigned int ttm_pool_page_order(struct ttm_pool *pool, struct page *p)
>  static void ttm_pool_split_for_swap(struct ttm_pool *pool, struct page *p)
>  {
>  	unsigned int order = ttm_pool_page_order(pool, p);
> -	pgoff_t nr;
>  
>  	if (!order)
>  		return;
>  
> -	split_page(p, order);
> -	nr = 1UL << order;
> -	while (nr--)
> -		(p++)->private = 0;
> +	if (ttm_pool_uses_dma_alloc(pool)) {
> +		pgoff_t nr;
> +
> +		/*
> +		 * DMA-alloc pages are not compound; split the plain
> +		 * higher-order allocation and clear the per-page private
> +		 * (which held the order for the non-compound case).
> +		 */
> +		split_page(p, order);
> +		nr = 1UL << order;
> +		while (nr--)
> +			(p++)->private = 0;
> +		return;
> +	}
> +
> +	/*
> +	 * The non-DMA path allocates compound folios (__GFP_COMP). Split the
> +	 * driver-owned, off-LRU, unmapped folio into order-0 folios so each
> +	 * page can be freed as soon as it has been backed up.
> +	 */
> +	folio_split_driver_managed(page_folio(p), 0);
>  }
>  
>  /**
> @@ -548,7 +564,7 @@ static pgoff_t ttm_pool_unmap_and_free(struct ttm_pool *pool, struct page *page,
>  
>  		pt = ttm_pool_select_type(pool, caching, order);
>  	} else {
> -		order = page->private;
> +		order = folio_order(page_folio(page));
>  		nr = (1UL << order);
>  	}
>  
> @@ -1124,7 +1140,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
>  					       num_pages);
>  			if (flags->purge) {
>  				shrunken += num_pages;
> -				page->private = 0;
>  				__free_pages_gpu_account(page, order, false);
>  				memset(tt->pages + i, 0,
>  				       num_pages * sizeof(*tt->pages));
> @@ -1214,7 +1229,6 @@ long ttm_pool_backup(struct ttm_pool *pool, struct ttm_tt *tt,
>  		}
>  
>  		/* Fully backed up: free at native order. */
> -		page->private = 0;
>  		__free_pages_gpu_account(page, order, false);
>  	}
>  



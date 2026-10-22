Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF04A60A2605
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=pfDpesX7
Received: by kanga.kvack.org (Postfix)
	id E3BC16B0905; Thu, 22 Oct 2026 06:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBFB6B0906; Thu, 22 Oct 2026 06:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3746B0907; Thu, 22 Oct 2026 06:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1B9D6B0905
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:34:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D012A07B7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:34:40 +0000 (UTC)
X-FDA: 85349903520.17.F21F3F6
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021101.outbound.protection.outlook.com [52.101.65.101])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4AB3918000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:34:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=pfDpesX7;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.101 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792665277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LMl2BakasIgszrDbVksZBhYpaIBRwF0MnmcwaAjghcw=;
	b=la4xwPcGZbJ9mtvvs4SpO0t85mfZBAsRWPDFsFNug9CIEwJbTd6gkPcqv2n12fA8ySOAJO
	ixd9EyWB0AdBOt2BLJm6Yt1Kcisp1nU50WBguj9CyOIBUmDVN/WCU1zED4NMxGeabHIgSo
	0Z1FPcLHHX+4vVwis9Qs50o1vVQMvzY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=pfDpesX7;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.101 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792665277;
	b=Mi5HpAWwoRz7gefyK5MBkUbdC5dl7r4tRO3SLLeCFXxQ1nqrBpy+x1LBSV8Wom2wEXw8wI
	Mz587PVxP8WJXOY66A2q2UUgIkRUA7ca6YiRzQP+S8LUkxq1fS8vqVQqdacjrrnUeKonyI
	EAT20WcIiA+9OG+JlbiAGy6mUAkfhsA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQ6qsg19x31CCUkHScl7xXcDGL/6RMOWRsIbnVsR4CyNxWSh4iq9hXLxd01smhMeItU1UhmZANf0En5/MhzfAyd6WlOTqsditHgDhwsNMjO3ry7sLbsvhwfuXtBG8HOWWhI4azPXt2Wp6p5iHUEzRgRbLu31kT3hXrTp+95ZeZbSHnUSczxHeE1ZbCqaYGX9DcOBHnM2nwPCg9dJpJ7bOq++W5AzyT8LxFnSw6mJxF5u69PoMdiK5g4MlXI+JlsjoNzh/yuWyYUVqaCF9akrl6+fvMB+DyURRe+Yp9QR0Kwwqfmo/hFj0ZtJDn8gHFn3106DDVW4/Fi2GHJop79Dhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMl2BakasIgszrDbVksZBhYpaIBRwF0MnmcwaAjghcw=;
 b=kSyAqbkirP3YaMp0P4gVpmQ5Hz3cZfdwdaAqjqxNOSSXIlaw13gNFrNa3Pmqv4CRvtcHq3Rol7UtARBj81vEm6NLOvfpwEQJ+5rfqW8gdkxd9vKiSBE6Idw6/HJAUlp/9ICUTstxgPnqiC/0hVmDAALuBvWHCAApgFmDmqPUS9Co5KAyA71TENpYM/W+fUf8X//pVISCpDMIFY3+L046V7hWIhoF7vih/Emux61dYzZVYeEwOSciZ42AoKNBEmcvufJeHG33GBf1AIQAzuYKdebUbNonpPmw8IZywXsaL2d9KTBDJuM+IfOJZrZ1OnCQAgcJ2wl2VyCJzCKyX2NAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMl2BakasIgszrDbVksZBhYpaIBRwF0MnmcwaAjghcw=;
 b=pfDpesX7Pzpn0G1H2++tpZPwnieU6cBNcgA7zTzFeCxKi8d2/h9I4qfqlw9ADzFPkLyYSf4a/0qUum5i4MIf1UsXs/jdRttk6nvJz75unlqsumLhoK/76eWJz41Lcz5eje6WzgxHWG1aQ3ZZtS1qW9ykwMkRuHNu4ZYVKxtnNlG5bcVD6hkqJn6sy0nJvY9Y5C5awawlRAySlMiolbfra11oCwxx3y0boDt8uEVgArLkjDvCXxqsl7QfxhGiCBOVhWDRQ71RphYKptMQ2m1hFe6/lBdWi3/1p1LqNKcwEsuATHIkNnZg3LEEBYAFtkA+Wi4QdhD1QUkFef26WLdwag==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by MI7PR08MB884834.eurprd08.prod.outlook.com
 (2603:10a6:290:109::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 10:34:34 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 10:34:33 +0000
Message-ID: <98c1002d-ee6e-47a3-9214-2296a560b3b1@virtuozzo.com>
Date: Thu, 22 Oct 2026 12:34:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, =?UTF-8?Q?Lo=C3=AFc_Molinari?=
 <loic.molinari@collabora.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
 <8C082879-C8F6-475D-9460-DF5E3CB629E4@nvidia.com>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <8C082879-C8F6-475D-9460-DF5E3CB629E4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::9) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|MI7PR08MB884834:EE_
X-MS-Office365-Filtering-Correlation-Id: 249f093b-bd4f-49c2-de76-08df30280ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|22082099003|18002099003|261021121427099003|261021123027099003|261009223027099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8Wv+0/Bz3pLIzUrpyqqf0lN6tYvb4hsblfzoD/qkSIgkmmhL3+QFWo61nquALvlO4wffW4giEEyfLS41rfJIQp6w+O15E+o7v+NZBKQoM1q4wnk04bB434JpuJ8UX1qxR/caoRij0gEohhKt3Cwy8gtP3xmJX6/1dffKRynj0JNG8GXhhc7c5cbW53n/7ExNtvWp/WyLxwJ8ac3vricaV83cmXAGIF5DZiMo7qeemR7j8NfwRVxjAQ2mOnzqW2e0He/F41AXZKFLU7+cgysvQvi7AH69ojVbh1jmAHiDAVn6SvrIyHEnLJN6qqHt49Tri5Q8bhyg+IW0zvUtDyTNr231EXVkoSFUvBNiFgjzmLP+hAAlFZ5dYCtF1LGGRBqbDMxqEiK3sBFHg5jmUzvatuBt62UGui3ZkAefVqvbvoAF689Qmy/qsDnFv3mb/LE6tnlbEH2F3d0A4ADX9mcZRjn9GbR/ipWlXluh0MVLS4CFe7uCLZLnVoHvyprcvyAi5E+oNnMSEr/hO3tGF4lhZPoP+U+4MHUlJ1zJN5l07eOpuO+wGxMgGDFjsZqJanLFDa55WZEaRVk9cjsqswIPwGQaXsaxKr4VIas2SSeYtdNq67mN3Eh/MD5inBDtdALUasGdc5t08U3zBpbFBQVG71WzUXObIXKV0gpy1WKVAdg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(261021121427099003)(261021123027099003)(261009223027099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V21TaDBRc1dCa1NyUVlzWXNnVXVkSWxKOWVHM3JFY3lSYks0aVhEOVRxZkFR?=
 =?utf-8?B?dlMrTER2RnpTemdqZm55ZGFwRWVHeThBVzFLbjVsSTJicUErbkRUNTZJR1JJ?=
 =?utf-8?B?KzJSbXRDOTZQYUFYUUZWcDQ1NmFsdTFsQjIvaUlYRHdtN29Hd0xZRjAwVm80?=
 =?utf-8?B?WU5tZlJRb0djb2xrVEVFbFB0K1dKT1pZZjFXdm1XS3ZZdVRBM1BEK3gxTG1Q?=
 =?utf-8?B?eXZaSFpIK2gzUXFsNi9rUVdnZHo2K2l6cFlDZms4Q0JEQlM0VWNERHVGY01q?=
 =?utf-8?B?bTRTRzlPU1YzZ29BenFPSzZDSGJjai9LVlk0Y1E4VEpTcy9LRDl6Y2hzdEhu?=
 =?utf-8?B?WGlFL29YVVFpME9rTWFXbmdhdFBmUnJsdnEwK1JRNGFXbmNJb1doRkUxV2JP?=
 =?utf-8?B?bG5LOVRDY1pEQitVNmZJZXJ5cWRtaHREZHVkS0xZUU1mOGdXWHVsRi9UdUNn?=
 =?utf-8?B?VlFYSGpBb1FyczJMWFQzT0R1Uk9xUUZYS3FsTFdTaHJZN0VRQ1RSTmlLbmFX?=
 =?utf-8?B?UCtHbHY0Q3RtcVB5eXA4Z2pER1VjZ29pcU5MVk01TjZqL0lIL3NXMnZObkhO?=
 =?utf-8?B?dmFUV0ZaMEUyZlI2UG9uTldZc2tOUUdFV0w5NnpNYlhuay90NDdlZytYOWVl?=
 =?utf-8?B?NkwrU041dW43Ry9sRlJuQnpUMVN5U3RCd3RzTG42dmtEc3JTWVlsL29MVzBF?=
 =?utf-8?B?VHpDcVRmeHVuWlZzZzc0SGFaVWY2UmpGOVdIaWFKcDlXTnNlOEs1NzM4eUZH?=
 =?utf-8?B?NTdpRkI3UTlKY1lmYWhHMTV1d0F4MW5tVm9CRFV5bkxWcGdWdmFHSUNrbzAy?=
 =?utf-8?B?V3RXMndPakUyazZmNHF3MDg1SVoybXZzcXhxZzhzajNxT3VLTFdWSHlXMnVQ?=
 =?utf-8?B?RzBtaFV5UExveFQvQnlXaE1zRUhPUWZVNTQ5VjU1SjlpYkZLRzdoMFpibHBz?=
 =?utf-8?B?RnFqVU9Pdkk4cjk2cFBHZFRwd3RXTjN1bDFvOEpTQWpUTXNsU3gzdWZsN2FJ?=
 =?utf-8?B?dVA0L1lYc2JqTUk2anpHeUFQaitEVVdpMjY1cGM3U2JFTm1oVjFFNTlWbjd0?=
 =?utf-8?B?c09LdmlmVElsSWtzQ0pmaThDNUlMMmJXK2RrWFVtcVFxdGFsVWN6NzBnYVkw?=
 =?utf-8?B?RU84Qml4Z3hreUJ5U2dJTzNsRlBPcFdZQUQ0cGI4WXgrYTlSelE3QkJBY2dI?=
 =?utf-8?B?WXpsWHpUUkZjbHBxaXhUejNEbnZ0a3paOUNLaHloZEIzYXNSY3lpWmRnMHVv?=
 =?utf-8?B?dWpLcjhTMlNUN0dNT1pzTkdMYmd4RG9jTmRXLzZmeWNlZmJLTGhrM1g0RXQz?=
 =?utf-8?B?a1BlRUZzRklMR3lxVVpaclJ4OEJnK2VKbDFCYXhoNEl0YXN5bHJmZTY4QnBj?=
 =?utf-8?B?ZEpRYXlkSGIrNHcrWXo2bkVTNzAzMnBHZExqWDNZT3cwUEpsWDVrTU1MaFZM?=
 =?utf-8?B?eVhrSUZTMVFMa0NKa3l5aThkT3VVUndDSVB0eHhPOTJmcG16ckNyczRjNndT?=
 =?utf-8?B?eU16UGVFVWJlNUdTV1Z5ckdTWXp2MHJuamVzUVk5S2R4cnVJR1B1cWpSUlJr?=
 =?utf-8?B?eEdmQ0k5WWh1WEM5ZG5KaURjb2UwNVNnTlV2L0RlVGtrNlV5b2dta01zclEz?=
 =?utf-8?B?Q0QyM3NuYXVXT1lNbWN5VGhhYVA0V1JXN3h3ai9GUzhyUGpJVk1SWWVhWU5l?=
 =?utf-8?B?eW1mMytYSWJDeEx2NzlUTk1vODd5RHJpU1VkclRRaTNzWGNiVmhBckZyODF5?=
 =?utf-8?B?bW1pcTQxN25JOHNMK25wdFgxT2MvMXB4Q0dxWDNXRzluOEUvMkpyN3E4K2tE?=
 =?utf-8?B?TmswM2xVNU53aC9NSkQraldqTys3aXBUSk00dG5nMHpzYitjNWZNWFgxZExt?=
 =?utf-8?B?ekwydGprbmhKS1h3ZFNUemtGR04zd1lpUjZBUDR1Tm95UDMrSWxJRWQ2b0Zn?=
 =?utf-8?B?N0FYVkxqVVFRNThmcWZYbVJvaU5sUE83N01HTjAvRFpkWkNnWDFnQnNyYnBp?=
 =?utf-8?B?WkQzc2VQY3FjNWFMSUM4eDZDbUtGQWY1ckFhWXB4QWYyR3hkSCtxbXIzNGdy?=
 =?utf-8?B?U1A2RkxxczFMWEx3S3NkYjR2aGdGSE9mck1TQkRwRnNSdTlpcEN6L3d4S0Zy?=
 =?utf-8?B?THp2eUVMcWlaNnhnWlRvVEJYSklhN3JyaEs5UVNTN2o2Z1NOdEppaUFjWU96?=
 =?utf-8?B?YUJlTy94bXRCTmpvQmw3UENjNVJ4MTVJR1B4Zk9rRitUT25DNUxtUVNSN1lC?=
 =?utf-8?B?ZG1kVDhUODRieFNLNE1Ba21TMlpEZEdxWmVGYjhJS3Zvc2tqVXpCYVhuZ2w4?=
 =?utf-8?B?Q0k5QmlMU0Y1ZncwMy94SWZWSlRzd0ZOeXV5Q1RzQ2FMZSswV3hNUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249f093b-bd4f-49c2-de76-08df30280ffa
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 10:34:33.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmJZ0Jlgucg5QUbXojcnVRCmBhTKgkyfO0WDU1gjbqn2pRSBIhXHUJPYw11LJfs1S7CYxPlurw3X4aBOyVUgBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI7PR08MB884834
X-Rspamd-Queue-Id: 4AB3918000B
X-Stat-Signature: 6deykwcm8w7ftaxzuxe5cbj5dpwi97br
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792665277-113959
X-HE-Meta: U2FsdGVkX18dZvgxEnKLmrRo3qhazWJX+ewOEeWAxFerv6whlalSwDydPMTrZxFopSORSFQUG4xakjEsgz0ANYqJhzIEQP52cx/QcYywjqiMsSoRltswK5KvNekWwVSLDNlvpTPGe5uoe+0eLi14AWSLYW/lfr9JbbTj19x153gxHmMcfrAxFObOkrdzkU2XfLTK7oCQOeeD9Pjx9ehAYGj/eP/PFH9Py7HxuAtSJBd0Lpl4/g+B3SeXkVbiR3J6j5/18JKuswvYnSwDX5/djtWFl93DaA3wGsiXXNWLFIbpU80OwuarXiUXs0WfhiLgYny2KKfX6SidpjEenGpa++zVnmJig6qoyhxqdhEYy123v2x7D9o6ZMsKWpu9rnzqwMLlbH/swB1P6uhtJGpfS+fIM3LZDIKQLhUc5aFtwyChf08GB+0o7b+Rt49jytYmtN8jniey/KNWIF2NtKki23H9bBAzp78P6BttzFNRXbumTUIk+yGtEQpAw7hdmvLZYyb15iOUrOF/FSovhPO0cvDCV/ke2Y8+nwP4F9QP81L2c0T3lTflb1v6ltMUbP4Xsym7JSYRYNx8g0k/ZX8iix+CKcnP93o3Ywm44bZ3hSY1xItCxPs7oGc7JfZtclDz06q4t8lmveNOgvFJBQv5TTx0TWEVe5p8UOWlJtwDyRBUvIfodIYBxLep8lXXR4ylok59hTKvlDDtZ0QjO7SMY5GyZ/O8StbI0WBXyE3g7URvcnP0olfpwWXVaEeFYJ81hmPocv5aJLY76ev3amGzwghOthMxiT3pL79pwUDBQuDOKBh0aEY7larARgbL1Gcx/5rlQl4sXuVB1ZziRTdrFr+gUEjorPEP936Gqa5y3JYAY36TcR/xAyRJ1F6/PlZrxrkCwEk70C5or80bFU2s7U2wzgRL4cY7POFRd2bVNMtt0cc1ASwTTY/0GIRY8W57T6pZQcTtY5FaWm/CY9e
 f7lBKqsP
 /J65OPof0f4O7JZh6CUJLdEFDGie4a7xxKzyAxOW9morAlb2GA0z8FcpvUx9IDKYI9N9EL5QBxgdhd3UvCHNtEcF3/WkHB/pRGNHgaDEPT+aVt4KgwZvWc4JwqEBGsDAasKntdOAGVjntR2lztFOWA08P17MP+Co7XhMTLCJOyYEvUbjhS6QDKdjZR8NbWTGSdxdnY2Vbz0lcEhxV+OVbxukXxonuRW6ffJt5QRp9UpUhXHDGEOY7hdJjykL7s7TpcnqApHWY7iq3BHxLNBYwyNy3/5KD5ufcAmygUXySO/HkAORPB7Xe2UaRR3uaFsLjpxITqLKkGhJ/t4GNcgwy7YyMHJ1ZfZGoVk4dv5KeHv6+zXHsaUKM8H0NO3xdf7KQqo1cuxk/yvjTw8dbz1PYRbLYiBI5D75UvirquMBKEshRIbub+tfWpEjp3iNfYZMN/6tgBSH4KQNbUFzSwL+AEILoAD7elmRKqBUEVVOR4iN5t9LQWHKhUT5lwnKvnNc62yYP+DgZfsOLeNJHk9fGrUJygRYE3J2/By7ybtzdJ50O9kJvgiK9WCzkHTlueLp/zEJrn4QV8+2X5V6wHeDpfVjikzmwb1H7PzrrxoQWfobVZMhiH/NgyUjZ0qPsyMmaoCJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 22:43, Zi Yan wrote:
> On 21 Oct 2026, at 16:36, Konstantin Khorenko wrote:
> 
>> folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
>> __folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
>> PTE mappings to the folio instead of one PMD mapping. Each unmap of the
> 
> 
>> PMD removes one PMD mapping:
>>
>> - the folio's mapcount never returns to zero, and removing the folio
>>   from the page cache reports "Bad page cache", or hits a VM_BUG_ON
>>   with CONFIG_DEBUG_VM;
>> - the first unmap already counts as the last one and drops the
>>   PMD-mapped statistics while the other mm still maps the folio;
>> - the second one drives the entire mapcount below zero and drops them
>>   again.
> 
> This chunk of text probably can go away, since no one is affected
> by the code.

Sure, will drop it once we are ready for the next iteration.
Thank you!

>> The helper has no caller yet, the next patch adds the first one. Pass
>> PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.
>>
>> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
>>  include/linux/rmap.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> The code change looks good to me. I also find this when I am working
> on PG_folio. Thanks.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> 
> Best Regards,
> Yan, Zi



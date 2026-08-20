Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC35CC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856876B0095; Thu, 20 Aug 2026 15:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807376B009B; Thu, 20 Aug 2026 15:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7066B009D; Thu, 20 Aug 2026 15:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A78D6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:51:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B438801E8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:51:45 +0000 (UTC)
X-FDA: 85122692970.25.1E42568
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id CF2DC140006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:51:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MIqbsEhB;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787255502;
	b=wjGcNwf1CXAfDFpNFF8KfcGUl5bCZEHVOz/OAnA9ppbpjO1qeKks9087+LO8EO4DfnLfMw
	K0lFEKY2/+YGd3lUu6ef2TXv8heTzJP0YoURSkVSaaPGX+uYaZ8yKvhZeCn27gjUqEq1IR
	rzk7VWkq9+H00ikc7ORfWAeh8shQd+U=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MIqbsEhB;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787255502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLRMTQN4QexK2NqgTvDQQrXvS3ybuifJ6TIVuvkCRXY=;
	b=v4wxmtKd4O1bVkpg5Hi4d5bx9QjS0IPHfG2U63TWsDrhWrfaM1bVgtKGCNqay3AP0m5cnh
	PAdAED0UFNR8oEVzMfwchwHBw0m4WFogj88fbuuiHRMgVaSF58q6Vwhj5LqZ7EEeRCTJBU
	n1TWlz8hS5X1QhPC7F4JzP6GM5MWJNU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUMsmkfbXoUCuYzw+mcs28uma0NFR1m2U9XqkpuEkl7aun3D+lSsTXuCjbgqhUIh73seLdcMr/2o9E3Zifkh5XdHaamZbcWyMKVbxn/p0Q58SHqJkri3YnMGEO+nY6XMR9Exsn4PUNWVS8fSf8t1n/iRU4dVgqsuXko9+TorAVuuOu28AFYepEDP9JY5GSiHdCZND0oKsyKSKm2D/yqD1DK2WKOdu1jGNjCwc1TYlFUSL0EJGBkEk/XuuQ09uJ+DEIVx212RlYpSXemqziz+LrNscGsew8kdrK2jQh2thRDuWqmw+9LIwM8mp+cRKZNWqK3R5l/SvRdYrL/BlsVUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLRMTQN4QexK2NqgTvDQQrXvS3ybuifJ6TIVuvkCRXY=;
 b=vAQZgXbAe+tT3Gc0sclCyCC+KuYadL37fFb9OtKzxVQCzMXnwvlKLVr1auGePQRaDyy7V8YttwNN4Ut4zwcchNVB+Bl1bt8RZajLB/y84vfJ329MiV/DVSlMggrg2WOx6tw66OyiCSW7o1l33bn9fxDQOlpLRceMj+FeOL/sBA2elaETrlPh6TmbHPxDbHWiYXI5G9XehpUyX6PTa+eAH2+Du9RXXIrqQIG3hzvnxEOffD57S4RrSxCgu3qv5Wxl9miCsrZRI21oaXoSf+gGs6a682n97wU81+mHcT+6XDa+727vvbbrO4bdskzH/qJ5NBV7W6D0aWpOVZw1vYjIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLRMTQN4QexK2NqgTvDQQrXvS3ybuifJ6TIVuvkCRXY=;
 b=MIqbsEhBmrj8IPgNUI2nIqRrwcTZDxTtYa++BLkdHUAZmDtr4ZbdvHjTF+FhBoTdJoWTOwK8J/tFojgM9Kh7ebV5wOS1eJaGeMBa3jWNojPQg2k+KVrnBaMwjyOo+xWv6/CIJlQqkTVPp486o7gNRqXw92bXTTlQvfnz9dCvlwdyYI9cMQCmVK7gXWowghXAXn9EM/WqWUSfU+I3skl3hoy6/6TA27Ut1wdqEYaDMUSEO6G1Iy2EXWUnygc81X67ozhqhqC9/TOTgjNK/gaxrOWPkAe3IzjeH3+kvB9dP9S/Rm678dDeo739QFeubpG1rKGE7KxnfcF3GilV79U/mw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB7164.namprd12.prod.outlook.com (2603:10b6:510:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 19:51:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 19:51:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 15:51:34 -0400
Message-Id: <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
X-Mailer: aerc 0.22.0
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
In-Reply-To: <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
X-ClientProxiedBy: YQZPR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d96068c-1429-493d-b249-08defef47160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|6133799003|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	2mlgtbmf7jsI2aGHeeAZRlBZKTjbIm5ODF5fMxPAX8azCfxO5FJjyiAH+SRm06k2GrImFPP0zfj9OkbNUvEG3xHjY4/p/Pho/BbxAGWwO8/fQ7Gdl1GqR5AL7soO4gY52MZ8Q1t0D+uc+MM369xmuZQUI6wZXriFCfrpx1vNgEzWhsCPZhFc2PzXvhgZjyeG4k/ntuK2AZza/GSfG2D1myd4VuPmii487Xldezjt88phDyUYEFl5ZHorIWSz+jDnsFGHspGyAmqwsXoa0JprrjjJmU3iIJQ9RY68A0WW5grRAu1Vt3NVIRAa6uYvGu0Wjj8qqeqReR+XHsaiDfcWW7lvP0uWCN0ZEKjvVwRL5SP6tEcqzoZe9tu6pxIiaJuUxi5/L6Oi0XV/ew8YuRtCRUgBVyxtzhB427cBSnZd9OPDCA9/ALDMXDqtJg7NLfz18KZJRHYQ3RUgVDIYkiHhsuXjkdEOl+G8yeOUrFBRqQIe3N+bk5o7S1O+qWCUgfE/qHmJddX2c8U5QMAy4B7Z+YBXvnBb1LotNnZ66n0IX38SybcvlsbF/v19livjXMUhWsWaSQex2oXRKX1kZkQzyFLviCbb0fpSBH4zT4bg+7KYjxwvbfj2Yi1yOZ+ansgf5wxz56KZevOGsw0c0OHWF++2ZW+2MF+M2wtP/WpqyaZju5/Pd5l9pKjhy12Wj+r2dUzDwcNpgzEAvGsGTUKZCQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2J4c3EzZTJjNWh1WEcycEpoL1lZZnQ5Z0ZGNGkvU2dWNXpEdE1paFBML0VW?=
 =?utf-8?B?UFhQYU5YMU1JOEt0VnlCWG9zZXdLSUJhN3hraUVJeksybnZ2ODE3TkJrVWR0?=
 =?utf-8?B?MXBOZVMydk0yOW9pV3BMYWdUWE9UV3dWT3BRY0RjYlN0UFZBQ3ZSWnJ0MHVp?=
 =?utf-8?B?WW50QmtUWlRhcld0UmFTek1IL3RzbFUwTlV1dTBuU0JnL2RCSDNlTVRZMkJ1?=
 =?utf-8?B?Y0FqWWcxM2MwaGRYbkdnOFF6eXlGenhBVXh2NFU2ZVVIVHptbVFnbHhZQUFI?=
 =?utf-8?B?bG9PaWMwNElGbE5Day9NcEFjb1phMC9XYWVoQlFHRzV2UkQxdVplSHhuS1pK?=
 =?utf-8?B?OTNIckJqaUtrR1ZlRXpMQm10eXl4dVFYOHhBSkhrL1R0OTJiWndGSjBjSFda?=
 =?utf-8?B?dXh3bE9Md0pqekNMd2t4cW9UVGdjQy9sd1Q2dkM3dllPZUZqeWFRaXFRREo5?=
 =?utf-8?B?MjFHWlF6SlZjUmtEdlhGZUhnc2ZpSnBPdUFWcGNaNUxla0tlUzh3SXpiUkZQ?=
 =?utf-8?B?MnV6V2FGYStIQlNFTTZDb252aG9VMlF4L2xZRVVYMkI0L2JTM3p4V25nNkIx?=
 =?utf-8?B?bWxSMyttalN0QlBpR1BDNHh2V05PTlZHR25yWDJqdm5JRVZabFpNRi91VHVy?=
 =?utf-8?B?RXM2aGlYWFdPNEpSUTQ2ZmYwTFdUSWlqMitBRFdud3BnR2xBcmFEdjYzSllI?=
 =?utf-8?B?M2hUT041ZnB6SFpTcDZLTE9MYVR6MzIrN1F2b2RLS3J4NHBiV1NVZEd4d3k2?=
 =?utf-8?B?Q293QzM4WmIrMFl2UFFyUitHclBUNlIyRjBwanRRZk14RUxKdTVmNWdLZngr?=
 =?utf-8?B?czM0OEFBKy8wOGdzTW1QblFUdlNEMXM3TTlzYzNPUng4NjdrbTQ0Ym1adkNT?=
 =?utf-8?B?QmpYbWgrSURuVGRzZ2tPbnN5eU9VaFdtNHkxbWZmWE5ZWGx0UnJsZHlTckpw?=
 =?utf-8?B?b2kvVG5YUEdWUE16SEtybEVEUVZ3SVdmQlZSTDFNaTBCWE1PYkpTcG92aXhR?=
 =?utf-8?B?aWh1NXdRWVhrek1rQzNRYkkxeFlBZzFzYzRhUG9KVk1mUFRsQ2V3aU55Umg4?=
 =?utf-8?B?UmZqdGFYd09sVjdHWk1VTzkxVTY3L3BhY3FHekY1QTNxNnZnTVc5b2pzUHdj?=
 =?utf-8?B?Tlp3RlJqTnVTMmt5OGNhTTNzMXQvb3Vtell0QXZORit0SUtiRDk3RkdOcTNx?=
 =?utf-8?B?cFpmc0k3RjNVN21tSkVaN0JONG0rOStydHNSamU1bEh5UUlLVXgzb3h6WlFP?=
 =?utf-8?B?RkUwOVZtcVJqOEFvb0k2S2d2bU9UNElQejZaUzZ0ak9KWk1wNGYrWnpVWnA3?=
 =?utf-8?B?SnRSeFd4cTZyeW1rd0hGVHhQbjFINTZYSVpNci91TU1KWHMvUSt2d0Z4QkZ4?=
 =?utf-8?B?RWpZa1gwUG1VeXovU01NTjVnRzQ5dzdEVU9oWnRWMGhkQ2d3TVordWs5dFlG?=
 =?utf-8?B?SWErSjd6b2lGVEpRd2xJdTM4cUN2WWxxQlU2Y2YzOUNaai96WFRJNnA1eUxG?=
 =?utf-8?B?WTZyL0hidThFZE50RXk2MXQ2REdtcDBuTEFCYUFWTWhZN2JveHR4SHZQeUJs?=
 =?utf-8?B?NnZEZXVtWDRZV2VOd3J6Rkpma1RJeHhqR0h6WktmR2MwMzFVaGw5NW4zVDJv?=
 =?utf-8?B?UGE5REFHTklqeXdHWE50blp3bi9Yd3E5d25vNmtwZVNlM0RtQ2lxaUxvd3Yr?=
 =?utf-8?B?RzczdDZmSnZObW5aRlB0cUpoSHljdVQ0ZlBYaTM4TUtiS3AvU1RtRjcxYTNF?=
 =?utf-8?B?UnF3Y1crZzdQT2tIMzhGNkNNNldXMGR3ZEt1T2RVVUFwQnBQdTJsK2lqNlpZ?=
 =?utf-8?B?MWd3U1ZybUhmM1VEam9EbWRNdmpYQnZXK3VKM3JVZnBXUGpUVlJXb2g5VEYr?=
 =?utf-8?B?V25IOW5FdlBtUjNOREZPT1htcGQ0OWF5TENJTFc1ODhMeFl5eGZsTXFRTlhR?=
 =?utf-8?B?UTJsL2FUQ0NTdm0ybTJnYW5lTDdFYVpaMzJueWxRRlhBYmhOR1grQmx1cXgz?=
 =?utf-8?B?SUlySmFLampoVUdiOVhxNnhWM2VSZStVbVNnRjIySW5JQytwRDNUTmdRdEd6?=
 =?utf-8?B?RFFNZmwwSHJqSW0yWGdSNHpvRTJsdEZPZjVwYkJmNmtYWGFKb0ZoUjBsT3pU?=
 =?utf-8?B?UnJFcWd0VHc3NTM2YkVobjdBd1Z1WFJMRGc4M3lJM1Z2TnJsTWxxaFE4dTFQ?=
 =?utf-8?B?SE4xRk80Zkg5VlJiWWdpS3hsZXpiMGR6SEQzN3lpM0ZLdlF5cnFHREdieGRD?=
 =?utf-8?B?ZFRsd3UyMVI2UTl3d0xIcFJtL0I5MXNCNG1zOUovNWVDeDRxSXlsWlNUTDhL?=
 =?utf-8?Q?r/zxSYMT7+IDJ3/iAC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d96068c-1429-493d-b249-08defef47160
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 19:51:36.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqEDzA/MIBERxRfS4aamN7Thog4/i+MGGQQK4oGtvSxHJ4Tn99J9LmAZh3Z2wsIT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7164
X-Rspamd-Queue-Id: CF2DC140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4do8ibpznbapor6r8inb5dkpcodghb1e
X-HE-Tag: 1787255502-155898
X-HE-Meta: U2FsdGVkX1/9WndSH5Yi7pLvl1UTt8FEGipP2QY57CbFd1B9xks5gotTNBN2QYiuZTGNfT1af6Z0RPfKVHYnC8YB/+Q3YSnNrQxGrWhb71Mwx0E98DJG8Hlz9OChdTFnHmrVLX0TCTljl0OVF8cTFPnGmGqNLCcHahSkXqG5xv4ON91ohBTR2BfeEm7GQxyqFdnvMSRj1pQosW2xpC5k4mucXcSIdZ760RxY6GeqLp0Jq1WaOMH6x0xdNQQLEIwVnLMJpxAZKpVOVjXxfRaWKldwbJ4tvDmSL/crZBYf0fsCuvdNVuKyiH3ZNpFduooHGSDk1W3sgDbMYKBsSfDvz5a2rXymRyAtFGKWLWWbDx7o3OGs8VyNoXTl7rJHrEqw6MM+9H9JNqUIJXUUG4S7nDEkizuO0XhCVARjGPhA/9lMVWkzTRxPAoKQmC2netQXrv+buczTtjrF0AZhWfSCLAelYsEiAu0nXp9M6j5DkT+iKYT8DQT7dqdS1HOSf309IjpPzgHptJFKBmmUT7YlsD0X74WmY5mUZSdLVD+YyaBLveRMaTK0O0S40v6v0ZtBy/kFNSYoYmLJvCS1ZGpxkzRv4OybPcgc0/XcTURUUlCzLbbEW6gAQbFTmhL2yV662U3Wvj+fzQm5be0N4zj0y/ETF+Y9vYxSbLsU+HomC1bfczfs5d+mAiSkJoax4ovA5OCCQHWldmIMB9UkBPnpaLrS3dEH9iqLRU9m4yAw9v5KHagC4topv7xkhxxhjp+rM5ZS5EKFwuLVSizDnO1xLnYptsIicOg562/UTa74rIREE74I5le6UwL4dA7GnM0ILU0sxOtIEo90woTvoKszcb7OdDRH3URv2H2HTh+HEkqsICtct4IQkXiYYGSq/G6/YyFUl1eTjUUxdQhngeYRoYALixLyHYnGrDNEckA5SYyiPIA1obl/VFrWBiWFPW5BlAau3QVkeSejURvPqwK
 uU+PDWT5
 rGcNq8a9K28txnbkp4Bm5FKmGOAQxK1eQ8NbtS1SCXoF87QQGddjU39LGUPjd3SfDvf30RNA3n0KEIN8USBpN8aPVHIwy/02N2acU+RhMotMb4p8I8SU4D0iLBHOsKNjJHB2LSPal9gBJO/dBlp2teEXY4uBZtdHW/SxEwCcm4RIEfGb0ze8wQSFcXLWQQRvwq6fMHkA+/yABaoLYYgMjEc+oaeFz/64TyiUCr9ekBtpGcTOz0s/KET/qKTZ0CfrmhSSCWpGxMSI4KjdQPmz6mY7L3ItrGuKdyDdhHd9bdk6mQDPMkcQtm43jqPZIHOu9fDZBFI0VGeUeDGKT4bdSn5dQrxIOJ7kIGZRo0mg2sSnh3CsnF3/jkNrirq67SYXoCF5+LpqIDdMXjkUB4eqG43t22DL4JBI4f4RF7JT12HPGe+kOoBikGqNRww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
>
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Why not disable khugepaged using APIs from hugepage_setting.h?
>
> Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>



--=20
Best Regards,
Yan, Zi



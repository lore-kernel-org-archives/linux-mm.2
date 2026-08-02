Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F57C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 22:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78E16B007B; Sun,  2 Aug 2026 18:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A293A6B0088; Sun,  2 Aug 2026 18:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4E16B008A; Sun,  2 Aug 2026 18:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5193E6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:50:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40DB7120575
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:50:47 +0000 (UTC)
X-FDA: 85057825734.10.84998CF
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	by imf22.hostedemail.com (Postfix) with ESMTP id 639AEC0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:50:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=drD1euwz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785711044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVwWwQdKTK9HqZs1QmUSo2B0oGlTQAei9AZRUo9zB1s=;
	b=6jH2ADGNdFVLvK024yQmqaf7ZKIs5zwxcQHUO7zUy8wEaq9bLGnuxaeNHMRVGXvFABctL2
	Os6kl8zG7yr8g7dqz30OgezjVNudkre5XLONiMseqrqJhDOjaHPaebcWmeXByOR5WheCKK
	VmcbrR8GlwgrlIitRMUQt5LQHtHG254=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=drD1euwz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785711044;
	b=kCD7WmrN+iosGH+H6r/wUuCZUwkHlsn7LrP/tLRFKT6uU4YhT0K8e1pIWnaoiEc7nNULkN
	56Uv2+RAWJhnSVG3jUusVY+z5FG+UuzRnBGE89ADtwOUe/I9x7boiCKqeoUgI5vzfUt1/G
	idsbOsaOioALcuyqHvncV+8kuUNOJUA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSjXuMR6Hzv/1LrVDnMh1gNioWQidQHY2DfMjSZaiyXgWOqPUJ137YdvqqKE7w7ayMF3EVtnWschqOZ6aoxpxOnWlwiyJ6lFckhB/57UmBOwLwHh0AY7chBKbhz7GgV/oS2D0SwjUAdog5cQug0cNr4+X1E1janD/i55ZfuUoWd2eDbuRIlh5Q94UCaIiq6ZXsESxAAh7TA8CsQJYq02JZ0f1rR63fonxC3z8eTl6zt1eDH/ILgDsMhwTFTjN4fYWG1oPPP09UABlJH/YZ03r5B3XeTmQHSUrVuItXY8dPr9eHHyb69/AP78mwxG+omh9VuzFZhPi52Dmtcpgmanzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVwWwQdKTK9HqZs1QmUSo2B0oGlTQAei9AZRUo9zB1s=;
 b=R6SORqz4SQiTq+cpblfeGF7ltkwo+DWmx+RP5DcmYd9757LhdEw/RUD3yAPdhnSIN/F3+h+bdJXjKP/MtyAe9okSgdFIwvxusrTS9gSDqZ8dCl/StJoscbtKbgDw7YSxyJezEPv/tHsFIr6RnDeDiFAH1rS6+FBfITA8hq5S5myyvAOiZOJMf1MY8klt2b5LqN82Slj1Nz2+p2FQlAQNsorudtjpbpW9GY9dmpbxo5JiCF5zhDyy61Lcj12LqUNk3puS4XSKXSBbwjNqMwuGwYSDApUZmkga2OzdVRwfji03cvbNNwL5jFhD6CydZ29kyX8oCytQbkOFzPGyO+uzbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVwWwQdKTK9HqZs1QmUSo2B0oGlTQAei9AZRUo9zB1s=;
 b=drD1euwzwybUzeJLhunKMp+v52huZZQnOOmGrxrwwkqGFWLFUTxRedMQFiAvoEa8rXMfG0Ih/sWNdpWk2skgn+ZcVROdIqtjVTlvlNujMKsOKEay0jfegsNEGILduqikMdQE6QOiBo3Bnm0YOX8yad+eVQBAOdrhfydVs2UPj4Q4c96M2oe3dbrh3KMjwbFFYaVmE7gBwxvbNynqgufiegfB3QrH2NM47Xa7cI/UjDvlSZQZw7xHd+igobCK6hIoMmkVEBBT5XpTyxkDHlzbSH137o1KHWX7dpYokJOffUZBgs456fVlogi4FMjeZ9swF5YmLR8W288ekVAB8D7/Dw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9037.namprd12.prod.outlook.com (2603:10b6:8:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 22:50:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 22:50:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 02 Aug 2026 18:50:36 -0400
Message-Id: <DKETQDCO9OYH.2FDBR4ZXGHLM@nvidia.com>
Subject: Re: [PATCH 16/16] selftests/mm: skip khugepaged shmem cases without
 a PMD page cache folio
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Barry Song"
 <baohua@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Hugh Dickins"
 <hughd@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Liam R. Howlett"
 <liam@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Shuah Khan"
 <shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Nico Pache" <nico.pache@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-17-kirill@shutemov.name>
In-Reply-To: <20260802195254.1937477-17-kirill@shutemov.name>
X-ClientProxiedBy: YQ1P288CA0004.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: 227324b9-af71-4b66-9157-08def0e878ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|5023799004|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Q3z+ii1fO8nKj6aUiOMPlAfiC5cdn7CW2234u1zkqYuzue86Lyc7RpBAOWGvD2rlog86XnvERIhAEVCx09jB573vbyQrcc95yEn+8mwnVe7WNVMnj2ax7i1bJDiKQmr0mleoOlpFkzkUFaB/p4nIHOqyiJD+kKDhWACLFEEx7WV27gA77CWDJbMHhLROjku3vnPPEGzyuFKZe5OQ3heWmiN9JAac1iqSpFfQglxlftuDcQryLA0upTyR6coT46Iuaqw8tmZd49xvsxAW9tHlLOoVHow813d3rd4BrjU2G2R4nf/O/sleAVXUXDnh9ZhmyNE5FqYpsEKyzXVy3jJSCMKKRkWEAkQ4xwhb5q7P4MI+TreDZ7E/g/2c8tW5PKmA0HIgtnUpBi/KLfOF5tRW8K6Z+4THUFS8d21E41O9InYW53+MwzCR7CnCmAptulnuFLv86O15q0seGy7ycaQ+wsJZIo3BMv5RMF5dvJHCJk1C0k7f9ySCXoGMAm6BwVaWEkWd2LcOsqY884XH7/cqgk6IokWriPULjCQNq17EH4SFJ1dOIczbb06kr2jRyxFiWgA74l2HUXko3Lq3T+jrDxz/MAzFi6YDh3Ijb9ouxyfecNnKgRuZuMRAPDU8xkk+rlm86ag8reRjtVGp+jJSIuu7/tbmI78SnLqC+7sxLQk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(5023799004)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjVTVlBiNjBIUTFYMTdSRkNlM043T2x6czI5QWFOT0l0ajZ3SjdIRFo5d1J1?=
 =?utf-8?B?Sk8xeUh4WWdsY052bjAzd2RRdEZ4NWVRaW8yZVQ1Nm5pMm9abDRzU1BSam1E?=
 =?utf-8?B?SXVaa3UvR0pZRVNyWEZpM2gzQmNoeXZZWExkQkJSTm9YcFc3dDFsY0ltaWJB?=
 =?utf-8?B?U2gra0lGWGVXeGNmdlI0ejJlajdtWXVqQ2ttbW9xVU1jdExTY2w1ZFJrS0FC?=
 =?utf-8?B?aU04TDNFNnZJb3NueGVBVi9Cc2pnSjNnWmZsQ0FNT2kzOWZNek5YYkFSc0hR?=
 =?utf-8?B?cUlRYjBOcTVVL0p4WWg4cWNQb0x4MXdrYjRkMHplb3pGUy9FT1N5M0xoVlZB?=
 =?utf-8?B?SzdybGNGMnNjeExmaFlCNThnZVJMM1Zyd1RFeHMwemJOZVR0NUhBd05BQmZL?=
 =?utf-8?B?Y1U3ZUxweTdSSkFRc2hQUXBjUElJMG9EcFNmVTk1SGlTK2wySGVtS2V4WnRM?=
 =?utf-8?B?c01vUjhtOVBkcEY5WE1LVnkzbG02aEUwd3dERHR6YXpIekJscWpzVEJROThp?=
 =?utf-8?B?SFpNVUxGLy9PZk9nZkFZcXVYZzVOUUhhUnlGQi9HbGFML1RMSnp3TXlDcjNn?=
 =?utf-8?B?dkxlMVdqRWViZ240aWJJYlUwcm9ESno0Yk1xY0RDci9qYit0VnMzZ0Jia2V5?=
 =?utf-8?B?MFpISHE2RG9iVWpOMTFDN1N1dVdHWkphQ25vT3JJYWpmWjdGbWFmRG05dCtR?=
 =?utf-8?B?ZGg2bDRCU3J2S0hnajRMcFErTEl6NWpxRGF6dEtGc2VkTG1nbWJJUHhldlhV?=
 =?utf-8?B?TFlOQml4azc4bWhVRmtBRCtnemtCMGx1Y2V4T082ZjJ6RmkxWWgvU0JtTlZk?=
 =?utf-8?B?a2lXWFBVM3gvV2ErNU9MamRxeUExZjZPZ2NmVHhhdCtCTTdnTVdMdHpENVk2?=
 =?utf-8?B?VzJQV0JlN1ZMVGZwQ3BZaDR1MEVVZUxsTEl1ZHpPQWVva3hrV2tQVUxjY2s3?=
 =?utf-8?B?UWU2cjVWRkNlQjBvTUFJcmhFUFBkRFAyaTRQR0NVWkFkUnhzUklkQXJkaENU?=
 =?utf-8?B?MU9RZDdzWWZBcXl4czFFeTkzaUlpMytkcHBIU2w0MXpQMmRZamk3VVNzWC9i?=
 =?utf-8?B?Nmd6TUJsZnJlNUFFcERDRGgza21jdzVranRrRFhqb29HOVAyYVlHNlJZWkxO?=
 =?utf-8?B?OGRCWExoTE84cXNKSXEvcExQUitTQVN1Qk16WGlaMzgxNzI0eEtDd0V3WWlp?=
 =?utf-8?B?ZXZYelNKZVZVcDVTWlU0UHAweTNrVWVJQ3NhNjdpN242TXlDRnpZeEViVWtY?=
 =?utf-8?B?cmZVYjhtbnI3VjYyVWpUcGhsbjlQUTdreFdZMGtiN2hHbmhEaWNLbWJXMlZ4?=
 =?utf-8?B?VFRUT1poQ1FYc3RDNjNnczV1TVEraVg4VlRidThydFloMXBxb2Q2d0dmUlM4?=
 =?utf-8?B?Z3p5bDFJbnVFRkM5UFlZT2JLcHgyM0VacTl1anMzS1BVTXRpNzEzYUJTQ01N?=
 =?utf-8?B?OEhvSWg4SndVdlc0MUh1SUluY2xxay9VMVRMUld6dDE5bkw0UlppY2pSUzRa?=
 =?utf-8?B?UWdEV2MwQnRFbjBOM3Y3YU5wOERETzd5OG9lVmI4S2tqbDJUeFZSZVZlYUtx?=
 =?utf-8?B?L3ozZ1pEa1ViaDVvT3pMc0REUCtpNmhRSDlzSEJXWG9ERERqdk5BNFhvNzNw?=
 =?utf-8?B?YVJvTU43YnFCemdlMHZxRzNpbkRrS1M4SFdpbGtFcUZoRjJKSTJ5T0Ntb1NO?=
 =?utf-8?B?UkhYSVA5WGY4bkFycDFTOXRQUmM1QjlSN3RJNklRT1NRR3pLM25qRk1TcVdF?=
 =?utf-8?B?OVYvaEd2WitNb2Qvc29CUXpKa2lOdCtKR0pJeTZTWGpmeGhHaW55ZUpMdFVU?=
 =?utf-8?B?SzNQdVRicFFqb3J6QlBMUVVCbEUzVHYxUmk3UzFWb1puZzh6WnV1emlpT05V?=
 =?utf-8?B?VFMzTHdPMFJmNm5PQ3lrMFZGOUNzbCtKZEp1V1dUV1QxbisrSElFTmdvY3ZV?=
 =?utf-8?B?WFBnM2VUVzJoUStlSDQ2VFRUYUR5NW8rUUMxaG9EdVlVYzlLcDVaY1VWRjc4?=
 =?utf-8?B?TUZzbE8zNVd2Ni84VGg3bU1YbnRrRUVjbUQxNzFOSXNmMytaVEFBY2kwZU5x?=
 =?utf-8?B?SEtiTzkyeXZvZlpYV1d3ZlcvY081d0I2eXpGLzlEK1UrM0h6TDBQMzNhVW9r?=
 =?utf-8?B?dDcvZTl5Q1FmMmRaZGhzVnpiN3Z5QzUrbVhVVXpPRTVxK2ZBc3l4R0t5bXV1?=
 =?utf-8?B?R08vNSt3bXljdXlOYWxJK1VSemcxWFduVHhTdGVNcUJTL1N5MTJPdHRvKzFs?=
 =?utf-8?B?ZzZRQ2FIZWZCQzJXbmhzTTdpSjJDVjdDZGU2dnkzeVpCbTN4ZnZ0MUQyRzlD?=
 =?utf-8?Q?ZttoJEDljfJ57ENdBW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 227324b9-af71-4b66-9157-08def0e878ff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 22:50:38.7344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YMMA9PeSq2IeDfrpino0WxI+Ph5hokFFDi91UVFJ8zjCC0bv8L2PEPdd9sE9hgWb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9037
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 639AEC0003
X-Stat-Signature: yt9nef8z5wjcm3etnjmt3jtyuzqb6c3a
X-HE-Tag: 1785711044-265651
X-HE-Meta: U2FsdGVkX18pSo+gVmnkzFiZTK+Ueu+2fuPQCGBU4bX+hDTHUVX8QbWV6KuFhUdvOjJdjZjDc06P4NYTVVF0ZejAt7WbQdmT2RVnEt14TZVlFljVyccW/9Q/hslMlxonMJSpQXwboiG6l+OeeTXdwFQfFFlWMiJG/NVdcULgiqbnidPMbwyznrSL7cTinGRx4Cch4UiPd6IiDt5DGAyfNE5kTdngEJ2kE6dX8nlhUejKxIUxARjNchO511ZpHiIm1P1jDNgmavm+7hh4lM7dqrfgHxBTTa+1xEeiyE9J6v7100ZjAFSnQ0qJs/9H+RQi89LhWnbxYG6tVEHZRZHrJKoxav3Olo4IticTQW55A6HPq08aaHvARzz1ZWu/Wk9i+Tv/xzKVkIm8JAmuo56VQnedoVngdCNYl2mZf/5HnXzQU4fN4E/rFKoiC7451aTVeIN8ZBCTJe1Qrd6z8xblVsX4c/socQe4qV6LCluxZOtvydiRDJLVHnVMTmMK7lnWrX1Q/Hfccg93L3Fld8/ep9QUOLUWUvB6lQSpDgTOOfKM5WRyMhrBoUlSfrpgh4lz/DoRsit5zN5hZJcGem1kmcEf/ECod+M9TAfAqwRnLq9qEEMTPePk2UhEN1bcEw/+Cq3tykh+tjBKb7meH1npaekh0iDeFzrSMe/NhMEbFbqnpFgf4DcDWKR8JMAT+5FnbDGkLThbemCmeweKfI+jA1LOq90Ivu9PZqL2REMtKVWEtWGF3r5a71UsIgLqa6iQ0axqQPh1bg8ZWZvjTYfrMLqi0ze0A6PHPsDEvjyZrq+1vN7WJAqemJ8hOcqjdg9Sn62o15YGvVqfkDSmKOEutCQ36aXwvMM3BTJhMdNo50+bO4tMVfCvcc23pd1CxrBt+u07oP9ULNEgS3hRFDoIb8G4fzCI3maMK5uE+fyLlBJ+vs7qOI/4pStLQFW4WVAlGEmh5BgVmb0w0okV1SA
 O0Z3f81a
 u3hG9g1+8exZzAdc5kYUqp5F8nBF8Vy9DmgInTjJZ28Tg9t7z0xytRp6phxBma/zZkd77Jfam+zSR3aVKtwO+hcMfC/c2i/7MSCe+vwuJJKJ/PgYw8HezsfDgPZP0IwfAU8XRfhGSz3JCHtOmHIE5Vg6N3XUzKd9svcNDlCpMTTYHaWN9IOJbrzR9pPFVgDfpntElDpub/2N61Kh5ZtH97QYIg1teWj1WE0jslKFCUst93s9lQkv4n0VfcSOXotsI0yRvElmIgHj/UPUatzeutPWh1EnYRhX7lT/S/x1laupPolIHqZ3sI7N3aftyCxyT/WWdv8cJ0xnLbc513joIkdPlnO5rAy3oZVoXRdRAC58CdkYzUTsYR76YYuiu3qXgvk760dxdAcxk9CdJTflymj2c2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 3:52 PM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> The page cache caps folio order at MAX_PAGECACHE_ORDER, and
> xas_split_alloc() puts that cap below the PMD order where a PMD is 512M -=
-
> arm64 with 64K base pages, as include/linux/pagemap.h says outright.
> shmem_huge_global_enabled() then offers no PMD order at all, so
> MADV_COLLAPSE of a shmem range answers -EINVAL and khugepaged passes over
> it.

IIRC, after READ_ONLY_THP_FOR_FS is removed, all pagecache folios are
split using non uniform split, xas_try_split(), so does shmem (except
shmem in swapcache not splittable). In theory, we can get rid of the
cap, since xas_try_split() does not split more than one level like
one can try to make xas_split_alloc() split more than two level (e.g.,
512MB to 64KB on arm64 with 64KB base page).

>
> The shmem cases nonetheless ask for a PMD-sized shmem folio, so on such a
> configuration four of them fail and the run bails out in the middle:
>
> not ok 2 collapse_full not ok 4 collapse_single_pte_entry # Allocate huge
> page...Bail out! madvise(MADV_COLLAPSE): Invalid argument (22)
>
> That is the kernel declining something it deliberately does not support,
> not a collapse defect.  Skip those cases where the PMD order is not a shm=
em
> order, which thp_shmem_supported_orders() already reports -- it reads the
> same per-size shmem_enabled controls the kernel only publishes for orders
> the page cache can hold.  A tmpfs-backed file argument is skipped on the
> same grounds, and a run left with nothing to collapse into skips outright=
.
>
> Anonymous collapse is unaffected: its orders are not capped this way, and
> the anonymous cases pass at a 512M PMD.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/self=
tests/mm/khugepaged.c
> index 9213ce1658d0..c5a3c3922581 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1584,6 +1584,27 @@ int main(int argc, char **argv)
>  	hpage_pmd_nr =3D hpage_pmd_size / page_size;
>  	hpage_pmd_order =3D __builtin_ctz(hpage_pmd_nr);
> =20
> +	/*
> +	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which
> +	 * xas_split_alloc() puts below the PMD order on arm64 with 64K pages.
> +	 * A PMD-sized page cache folio is then impossible, so the kernel
> +	 * refuses these collapses by design and there is nothing to test.
> +	 */
> +	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
> +		if (shmem_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
> +			shmem_ops =3D NULL;
> +		}
> +		if (finfo.type =3D=3D VMA_SHMEM && read_only_file_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping tmpfs file\n"=
);
> +			read_only_file_ops =3D NULL;
> +			read_write_file_read_ops =3D NULL;
> +			read_write_file_write_ops =3D NULL;
> +		}
> +		if (!anon_ops && !shmem_ops && !read_only_file_ops)
> +			ksft_exit_skip("Nothing left to collapse into\n");
> +	}
> +
>  	if (anon_target_order &&
>  	    !(thp_supported_orders() & (1UL << anon_target_order)))
>  		ksft_exit_skip("Order %d is not a supported anon THP order\n",




--=20
Best Regards,
Yan, Zi



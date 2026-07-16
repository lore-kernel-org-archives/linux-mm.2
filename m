Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC9BC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03B46B00A4; Thu, 16 Jul 2026 17:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4C76B00B2; Thu, 16 Jul 2026 17:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EA66B00B4; Thu, 16 Jul 2026 17:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D293A6B00A4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:14:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AF1D402FA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:14:56 +0000 (UTC)
X-FDA: 84995894592.12.CDF01D5
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010027.outbound.protection.outlook.com [52.101.61.27])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76ADC40009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:14:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m29rURvS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784236493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiRMFU8fycemZB8OtO7Kqu1UopLQe/KJ/qkBZQfP8KQ=;
	b=4L9o7I/ZVfXijPmMMRjogPThBIicIn+YyqhXuIIt9uUamq1T99FIrk12cYtch5/QIMtenc
	eeVEnTy+2da2lYgC9h8xCbx5ffvfJRq6mQeZtpL2kJlhclV5NhlBUeoNzwT3RTmPpgr4F0
	xh89semh0BNsi8K/8igFB5j1GFqB8aE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m29rURvS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784236493;
	b=DSMnD8sfruIrbhOkT1Um2gWHN59rpU22sZF2aFvhl8tXIi83i8ADwO2kxzXmLexcgUIXVV
	uBTGvfITeHd/iwEWVcoPdtB/0z3xoSIH/YWeL+S12EyX1hvUYHEZ248mYhJkXScpZhdYI9
	3UyobJrTgRVL2UXtdazk8GCKPJKSoTM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hGNNtKpOhH+Pz9si7xTYDVHCDpbGiemLMBbPztzZXv7N9tj4iP323UmnDclLQ6EA4uQPheOz976XchIkbXvubwsV4Co4M0ju7J0KOaOnK5NasYLVqtrd/VvDu/3+sGUt94EtFGJJexcE2AnQSgFrzKe9xruZlBWU0R1LRE35agVzIS/4+OTL7yeakae2hOMj1dDe2KurzcKriKndgffTtb8inxDnSltMrSSQ5PIolPK6XwCIMopGoBZ+DNxZzga8qXtoYaGF4xF5olcGZf0URZYPWGzM6VAxQOpB8LMjUjK5+qqDwY1OmkP4Wz1W+FFB52W1OGx3YbDjjovdB+MNSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiRMFU8fycemZB8OtO7Kqu1UopLQe/KJ/qkBZQfP8KQ=;
 b=Jn3i0xdrTEkPcFelNPIapRw6bAFxkHfkOcm7RvjPGid2Y84xvQIKo1PJhmNNm1jT3y6dUO+nQKea2nT4Wlswam2kmsLvBOeJBqnKOFL55B8eVCmOvSXaKi75amiaiiJbTH9Beb3YOiWd+fNWPGjGXLkhnD8tkQoYdlHk9j8o5XV2dRDWDLdVYozRtpF0mwFeiVgwVbGhw9Lg0a5iqyJZa8BJY0SdyqEtNl/cHqSjEyLSpZDdw8z9s3WE6ypWSrwUH9NpPFp6c2NdOyi35o/zq8yMpu53EfD8EDf2IOUjxWHM9SkTwbUe//ZIu5xepvWlte213IXEVZtJyjUqOq3EjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiRMFU8fycemZB8OtO7Kqu1UopLQe/KJ/qkBZQfP8KQ=;
 b=m29rURvSKVqOlbK1KiEgWUcFHUDKkijK4+MIs1l3EL5/j03e3nzOcub4GTD+DYTdTBk7T4RynZ61LWhgAdgRwhluZ/GfYmBmiklrpuNuJ+rqeJbUNKna3ehNP/AegDC+UBYy9D2hZv+7M3hxT/1CVqxx1WN/1J3pcvnT4qPze/pO6BbRFlKgQIol+8bzVJ/a+u0ysD9K58M199Mv2YX+1xIeGelou2KW4g35iPTkoiaDBfJcDH5KdrF1ecdH+ter+cqxrdSXSIxcvO72CwE3YNZ9kNQ4pWCCt+WKnD3JgLcXuJ/voZOS0GPHQbghCxx6JprMGRyi4dmKQkDzGVDwjg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN3PR12MB9595.namprd12.prod.outlook.com (2603:10b6:408:2cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:14:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 21:14:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 17:14:47 -0400
Message-Id: <DK0B1QIHHV0C.3U6IRT4X89VFK@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-s390@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Andy Lutomirski" <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Alexander Gordeev"
 <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger"
 <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 04/10] mm/bootmem_info: allow calling
 free_bootmem_page() on pages without a bootmem_type
X-Mailer: aerc 0.21.0
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
 <20260716-bootmem_info_part2-v2-4-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-4-4afc76c73d61@kernel.org>
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN3PR12MB9595:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f50efd4-e5c5-4b9c-e8a7-08dee37f444c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|11063799006|4143699003|56012099006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R0xxK+HZyfsjewL4Z5gTg0Wuh+uQqkDsTlyoe0El7MCZ8NUnJJdTIshmLbqNpOCTdtrHGJ5i5QHqYsBe/Abo9L/3Yw3tyeo+u6M3vrU0o6EL8hxejlcO2s5Zg4fbPALkQHRr+4bgxXB+6k1UJH4n0U2kdchqygPBkOGrvEybP5zcO+ifklxnhj+5faszkWAM250nJ+mcVBP2zN/+K5caLfOAByexs5f/Ao4VFZBO1rVO3ZJOR1Wb8Kqd9FobF3G+M5WuQQtD4tFwyxiEsVABHkpr2CfG4HTHLMPPuMJvKoI8t+ggVBK3D/kQDFKNZtT6BrZwnDEE0x7oJ6QUpD80JCPJQXiLidfT+m0MEB58CozDgBPpyzJ72Zr77uVMyslu0zNpg5Oj2Gpz2913Bb2WuPuYhOsTqAvIHv/v8bILdoPIrYJhuX5gWiOdkK9QXuyqx0U3WLKciPv9t3PdTXgdDjTbvwarhcQHUVd6iNoWvAkO3v1HdW+2Nejize3hdQ3njPEGoGaaOscMT2lLlponszID1/tTquMwjuOs/rlAZZgfvgnzfAS4SLIp8kRPJMSs9a5m+H7x0jrNWzVcpybbtCop9fGeq9Z3igckOn3DTL96hP99CYCdVeH1EgPCCi3qrZngDFhfLZ1CXI9FWjLskEajIWwmT3qGZXBeuvx4pEBCTaJVdL3DLslmXkDGGk02tKLzB0roWo5NAh5Ie/hyhA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(11063799006)(4143699003)(56012099006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1hjYnZ4Q2VwOTBQZHd1ZkFoYS9KQlBrOHhJbHozZU1vNm02RkhWNExvRlJl?=
 =?utf-8?B?RHhjNTZnWUdHV1FTMjkvSUFDQ0FlbXJ4YXNNZ0F2S05yemhkWGk3RWxMcE02?=
 =?utf-8?B?dUhtMjBlVnVzT2VqOCtVcGk2VlRFbUs1SXEwMU8zTzNmRGxvdlJpZWVPdWV4?=
 =?utf-8?B?bnZjQm54WTJZWi9BZTg4TE5TNTcwYjB6N1pMaEJJbUlCa0dVcXNlOE9nUkN5?=
 =?utf-8?B?d2haczR1cDY4NnFVSTE5LzRMT3NMVkE3d0FzaC9ISS96VW9BV3JFKyt1cjNm?=
 =?utf-8?B?OU1MYmpKVzU5MWFMdCt4RW1rYy96cHRVVDN6M3A0OW5jT25VRGZHWTRJN0Jx?=
 =?utf-8?B?VWUzb3FSRWo2cjJQdWxEcCtIcEVtTzJnRmE4NWcxNi9vVjlTa0x6RmZic2JB?=
 =?utf-8?B?Q1d1OUFYVDJnTzUrL3g4VTRZRmhjSjk0S2hkajNYd0Y0V21MMitTZlNCRGRO?=
 =?utf-8?B?clZaOWZMN3R0ajloUjRoWjErUStlRTZsZ1Y2TnNZa2JqWmdCRng4R1FMWVQx?=
 =?utf-8?B?QXNwQUZrdGNWZ3VaT01sWFZXNUJvcUhFamFwc09kQURtY2hWVlhqYzExQlg1?=
 =?utf-8?B?ODZKWkRjTjFIN2dRTkZMa3ZGRXpHS0svbnlPODJEQUIzM1ljQmsrV1lBS3NM?=
 =?utf-8?B?enlkck5tbUJZMWZNdEVnbWh0TnR2NXRib1VGL0ZmRkFTOFk3N2M5aXg2bHZx?=
 =?utf-8?B?QzRDa3NVYVFBY25hZTJOdUIwZ2JMNjhZT1pyWStZK3R3Si9WOUZIT3VLb2Fz?=
 =?utf-8?B?YUdFT09yeUU5a0NMRDkrWm9xd2Zuckp5eERmYXZ5eWlVRThreXJ6VU1zM3U5?=
 =?utf-8?B?NDdjdWZlNjI5VEpscGhhaEd2ckVZNVFFMFNoOWY3U3Y5cVhydUowc2UxbWth?=
 =?utf-8?B?OTFSUTZucHZhRjhNNTU3cml6aTFqK1dDWVQ1ZEE2alREOTcyL3R5NUdkQ2NJ?=
 =?utf-8?B?SWxUOWJ0dkZ1blFWaXJRdlFjc2hvVm9SOFgvWkhKNmQrTXNyRUk0czJmTjhp?=
 =?utf-8?B?TlBiUkE0TXQ1a1d3NEFmWDNCTVJiVk9YVmxuNTJzY0E0UkcrcnI5clZrVW8r?=
 =?utf-8?B?TytSOWQ1YWxyaWZNQ3JoenIzWEJqdlV3cnBqbTZ4clV4Nkd5Z004U2ErVU8z?=
 =?utf-8?B?V1R2SkF4ZWY1eURIbnMyZUxqeTVkcG5xMGVxdkFkYlpMTENxNkdvV3ZibWdC?=
 =?utf-8?B?TjhST21ockhGb3lPeHdMSFJCOTZUYUtRc1lBMXR4d0QxK29ZWmJwaE14azZm?=
 =?utf-8?B?UlZXVEZyMjcyaEQyMVN1a2hRSDVEZ0JUYkhEZURqbXpRdHQyV0l5ZkJKMlgx?=
 =?utf-8?B?Tmo3a0ZReHJFZ0pDQmtzV21vWEtmTThEUTNZYUVKWHRXeE55MitNd3RBT0E4?=
 =?utf-8?B?QWVoZ2t2N3g3V0ZzZ3BSN05iRGNCU1NzRlF0TkdlRjU2YmJ1MCt6SGxFOGxP?=
 =?utf-8?B?QXgrc0ZBa1FKTTd3Z2pFaTFBYTRJZ1RldDlrdTRvU0FGU3MzWHhmcVZBbktK?=
 =?utf-8?B?K3czOGhiYnpvcm5SS0Q2Z2g3U0dTVTc2Q25uZ1Z2NE5EU25lZEdxeHM3OEc5?=
 =?utf-8?B?SUhKb0hGeEFDL3ljUDZFZE4zVllMcXRzK2hadGI1MlJUd1AzWVFsYzZzUTlJ?=
 =?utf-8?B?WkNlZklZZU5zQW0velpHL1VFYnRBcmlTWmpNT1RkVi9JZlhmcGhCVzlvVGVm?=
 =?utf-8?B?TGYzRVdhc1BPQWc1V0I3VlFGY3N5NnVrWHYyYVhPRGNGVlFkbldkYXRXU0N3?=
 =?utf-8?B?eGJzNW5GZFdBZURVRExIVll0eXYrY3Y5d3ZjOUUyemdscEpuSXp2ei95NGx2?=
 =?utf-8?B?UW1KbVFjamdqWnVYdTNPYkU3alh4ODhHeUoxQzhWMjJrQTFLNXNOc2FVNFkr?=
 =?utf-8?B?VWJSdUdLaTdWd2RTbVlnVTdyNm5KbzJFeGlvTXUzQW85T05kdWYxQnQyR0U5?=
 =?utf-8?B?QzRGdTM0ZVVaYTJ3U1JwTk1PMlhBd2hxWU5wQ2pYbTROZWhIM3RyaVZaTGJn?=
 =?utf-8?B?RHJJZ0taTHBaanVobXR0VzEycEtISm9Fc3ZWaC9nQ0lZVm9UeG9JRVJGU2Yy?=
 =?utf-8?B?dWxYc0FxZWxXWG51THd1MjNuTWkwNmdLRkJUVEtJUzdQMFBLRlhIc0FMazJ6?=
 =?utf-8?B?UktMZ3YwV2N2Y0Y2VHJYVnQ0Mk9seHpXQ0p5RklTbzBSckJwbmpZSUQ0R1Rq?=
 =?utf-8?B?MUd6VGdHZXo5SVZmdFpDRno1aGFPSWdQSWVoUDNSb2E1ZVN6dXc1RFRtVFdu?=
 =?utf-8?B?MENZZnNvc1JpZDA0d1AyL2J5MXRFQ00xamhiWnlkOE5CYjgxOWJXQzZrb1dp?=
 =?utf-8?Q?yEstp5Vo9ARawOGFOt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f50efd4-e5c5-4b9c-e8a7-08dee37f444c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:14:48.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2qX2txHCGLmQqztIvrlITbqZNBLaQ18+oibqow6poThfz6Wju5JAnbu55KX9GcK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9595
X-Stat-Signature: uysk9ozo1taewrk44ieyuh3weurryabu
X-Rspamd-Queue-Id: 76ADC40009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784236493-373269
X-HE-Meta: U2FsdGVkX1/4ry9ExtyLszAuvW+/ntDNvbmBS/i7STc4TlT0g7ChbiL+x9VVmRNCmmHVdg2eXiJitT4haYGqv2nfuQxaCN2CfRWulTEt2lmVQyiSNH8Y5Zk0/e7VJVZYFTXidqeitG++zagF6uXgoKdfUOeO3xkSH05HZjuq5pEVag/8BTVV5soYhHv2fLZWHmwUa9xiLnm9QPts0nTr7onVzclCEqRVHKgHgkQuXZZZBBF00QU+Ujl9YaCkKxHYJUX8xtOURK17ZZ62K6zAwRt05w2a7puqb4ERVe3C/SHAT1PnhgDKoZ5FkCead31d66RNY0lHL0gsPVqs/F1cm6QZJTCCIZkLY6fwHGuJaerNMvyrB/KLZU/AClg8d8wzvBXWCCPr//7I8JWsI7lbBPc92suQZ73DvdyIfbAtNsGr3Y2c+2dw5BVFib7I4T6W6fiPyKzhwhS1jCoDh9KhroBtqsUPnnvRjoG+Sa/F5Bd7it1uyYGYSBaAYkscro8fZdRDxKNQoahG1VcfMwpSBLeTJpGT7ajHRrvZpdNbD2dZO7H16TTXgbZXS1AoWTEg7+1LjnZWWhXHPpObkzftUyTljoXXvffwh5NQEd5Dljegpe0rVr8xgIWmvNWTV8nG6zlXL1DOfhMyBQhZFA7dw9SLfRTmDq8vS2yvczDwIEy3NyV6ylZqzYT2nPZd0+QDNDusjdf3J6YeDP8OrB43ZDS84vUkqgy9aWNWjnXlKSBftiyPGA8iB8uzO4oBvPzJiMalt0tI1NLvTyImkmhOexuaXi4wU6tmwISz4XElXgXcwtQJhV6w+JlPDcfvbBkhIfqZoq6F1t4twg3t+yb73wOkvIAcMV4qEpPcu9cAJ2QCntEaLTAASIOuYGSQHXmDv83fx0QJfJuI8xPIQCZJNPrSzXGW5qMlL8I036lGKM/ABr/m4yLUOCYRve1s4nMZqBVf0sBArSAaK+qZmL+
 Mn916pBa
 YLVXz5+uKUXkiuNXV66uAMBbBVHAZtFYiuwYquIH0TROZ6febj461PywsRf8CkJwTV5EjByYnJstLvBzpZArCj5XKW5/Cp1/zD4n+CH1q6Zi6ydH6f6N6EADI8MNCVZni3ikNuEr4zM6PUJ3n7vAJLtIAguYDBAqZmp42wyR2i93F8qiUoWSCMSer8GiYQdyTrCmciOxEhv12FeBxBlcCePr7WojIRg++cmvgM+SAoqprufIRUObP4sdEx/rBx4RvzN8cUdHB3EM2hlPr5niYO5FTuCGsXxfqNmDUQBlFtK5OE9v8SldnKalgr+ZAJlZFXG4LCafGOSMiQERzlRIr8z8mHL8F0q8H3WAnoB+cUsX9my7ewkJ4s2AzaXV2IWc5HwdGpPWVY0e+o7cpCDGs4O7taiiKjREqHThCpgp9QpbKgB8OsxSvqFM2zswcUnAiFVShln9TbRWSHUDml4MMi5kNMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 10:51 AM EDT, David Hildenbrand (Arm) wrote:
> As preparation for further changes, let's temporarily allow freeing
> pages that were not previously registered.
>
> This will allow freeing unregistered vmemmap pages allocated during boot
> through free_bootmem_page() from hugetlb code, until we fully rip all
> of that out.
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/bootmem_info.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



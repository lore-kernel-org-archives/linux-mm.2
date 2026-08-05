Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC08C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF386B0092; Wed,  5 Aug 2026 08:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E916B0093; Wed,  5 Aug 2026 08:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026ED6B0095; Wed,  5 Aug 2026 08:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA8086B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:03:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72734120457
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:03:49 +0000 (UTC)
X-FDA: 85067081778.07.BEA4303
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80ADF100009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:03:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lkKLIH6H;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785931426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GGGxmnsBL+xC+y6iPpg+l2ZXqAWscTzrr22l7BgzOk=;
	b=JKyWdVJDcjdbSZacOf4r+x/BRmxFrpHSfjqI4oAH94lDEalH+2yAYiJKc0Zm1Q/wD7vChp
	azH0yJjzlu28EcR4wDNM2ou5dajSta9w/4O9maGVFsVV+hNGZqb8bJuTIKk9gj98qEuUFk
	lgf4DobsHxHem2ExrD2lcjfyMcIWU0Y=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lkKLIH6H;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785931426;
	b=jc2FQJdp28PB2DqSmLYZa0et+JH+auiDN7a1fAytaqEyF2XWgobzIbrr4uyp9/yt//ea3u
	dKSgO1HR1nz53q44TgtOZKjXz0k8D3hhFnl9g0Fb+ijWE8qO2FL6NrWSGqhbOZ4Eq2U4KA
	fG7SzO4xAiEStlQ+gdMHjjT7wiBPovk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibWiiSAunLYiGq+PMHqUehN1yWqhF1RWK4Fbp38dS47fSspS8jaZj5YmryVUTXdPfxJnY5UTHTUZUfypdgzNoNugoVTR5PpnbrmWrUx1wZUUpR4U6uA6FW1zyPWNCfJfu0B/4+URdYedhbDzrEWP3nFTujl1nRjA31dY+nGB4QJV3klRSf7euDC8Io5t4tpvUg1QZNRLL4RBktL3oUBNzTgPVHkyQL4Q5P5OQNEbBY7KH7RHZHt1g8gFuOJN+Ey/z+pnAbudBcuFZ59O8+5gkZzUkQO0MsVCZWgPMGuGMD4JTrMx+MEIeTxjD9VG64iK7d7ckB64dsscEV+CAdk5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GGGxmnsBL+xC+y6iPpg+l2ZXqAWscTzrr22l7BgzOk=;
 b=Wam/2NNNZo+OfpU8CgUOExUrpalf8Ue5uOHxnQEj2ArF0XM7DyOz8O8tE4AhXQICrL+f/14G72FvG96yI/EPU53LHLWudedzfQxMNj58QZCAAJKkUOyEyda0OpxIvrArOYfah7vN6pfdNh9o+aI3H82iBGeorBIGuywqTpR8SSbze2AJBvZ/4v20bCN40Y6bR2cYjEtEtfXeVEUbCfAd00Bp1tV9gKDOhZi/iOxo4NYF2wIHaFQACs3pwLYexJXhCDRD0jJCP9TSlXybTnAJ9APXbDQb9fjUcBPuz8GmX/jpsGEcCQssflrlDQSQ9o06AGsRDmE444PSVT8J57fazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GGGxmnsBL+xC+y6iPpg+l2ZXqAWscTzrr22l7BgzOk=;
 b=lkKLIH6HPFcd8lxVV3cuBZOSHc8BZlV+MKYV+Va2hsHgikxjASiBYRVhkibb0jRh9N/yeZHKWKKJaOf2ie/xqm9Lh+5wSottBssGF2If1aKdh8/azFLpZ6+PgIjrmU9sBihosuxqwwBIcSYfcii/IPndLjjbrA091iMbStJknjscwjxYAiatSlfT4YurXiRJbKbHYl6nau6T4sOvnD2k2o95P7D1wWQlPDxOBQohO2dI2eZj7L7MmdnEnT9jEXtrlKavniA94+BCPKMGJFLFyWwt5Ippxbn4/G4n/e+ZSpY6eHoMjv/h4rUCz28fgiMLLTy1z5KBb+QLbcbBm+9NSA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7371.namprd12.prod.outlook.com (2603:10b6:806:29a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 12:03:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 12:03:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
Date: Wed, 05 Aug 2026 08:03:33 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
In-Reply-To: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:208:23d::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7371:EE_
X-MS-Office365-Filtering-Correlation-Id: 0059d001-99bb-4031-4aa3-08def2e99380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|11063799006|5023799004|56012099006|18002099003|22082099003|4133799003;
X-Microsoft-Antispam-Message-Info:
	rUmWr150zUAWZnKV7lTlEqrJe76Wd+rcBaBK6YL9fSWFLg94KSLjF+M9lwtSBU7rBr+DoVibuB6vC+q8StKA3blRZw2mkWf3Msg7rfF619vFncSnLtX0BCBgoYJVt5Rf3LbT8B9Ley1juQIjMZVypJDRPmivSTqYNGhes5UeQhsFuwYWXtJUKOPHGuYrdTbIB2s3bilI8qiW9DY+0BNg+VNjipaM3dzVuTZadyJniLHnBWmvjeVBBfVGRHEFTKn5a92fFJGcjZxxMrlm7tISS8OgzRRxjiUJdVwQ2r+EyktmMXEoMOorMN/YE1EjFKshM/6mf0XzFlQC3RpT3a4I3JDZEj8a37hXigUj00k147tqbk/B4OGkul1Q6Eq2XIp0Q2ZW9RVggUsMfyWrv+NF67WC4DjnP78qIr4l0gClla4qrl/CVGzfetPtTZ+JG2E0NfHO43XbJ/btnlJ4VQh/2wKmVoJmjOlfmfKVslMWNTLfy/FcNik93YzaQrSHncdCQNVxyuH5j6VS/pQv63XSUf6VXjIHje/fQcgw33VcIBqMHa/JNZMQG0kE1ELlujFume1+jo7I6uXG9SkCinhA1Hk0sna5Gz44achkoLYjJ65YfpZhjYxTuWINBaHXwbxZgKC9DwLxQwJdiL2+mpulL9RUGwL2vk3a0FrlHG7u/nY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uy84b1BFSVByeFBmVXZhaFdTMm5wWllvMlVGRm92OUlNbnF4UUdzdTRad3c1?=
 =?utf-8?B?NzRxTWJrVU1WRmhKRHc1b3V6V0tOLy9lcnZJeTdDa0FuQXBCQXgzK2wvR2li?=
 =?utf-8?B?UnBBY0Q4OVgrZ3BXTWVObjJVREVTcHJxaFNSZmhoMFRpcnJmQldBOUtxdG1R?=
 =?utf-8?B?VjVoSlBsYVF2b3JqdUJvV2pZcmxZeEFPTnFGOTFGL1hSUEFmVStlWnRDeTJt?=
 =?utf-8?B?QjUvQmtUMXNTbDN4THY2WGcySmp1c2xzUFZOMTRKRDVSVlVOSjFHZTF6bXRH?=
 =?utf-8?B?bjJlZ0tVVG9tdldFbVpLcTNnWnByb2lnVi9MSUZEbFpib1pmR1JtVk9FeFU3?=
 =?utf-8?B?SFRvRHoyTGpNdVM1dVNCK3RKQ2VXNHFYRzBtRFdETi9RQVFpMmJMRFhkRnky?=
 =?utf-8?B?ZVlZSW5menVRZURMWEdKSVgvUFpTcTBEZTJMd2FBWnF6RzZqQ2VUMGJhT1M5?=
 =?utf-8?B?bTNJRFQzMVNYcG45RDFxalZONG5HaW1WTmhvVnduN3U1bXgyVXlWVXBjOFhz?=
 =?utf-8?B?eUpjQWlTejNGR0lFRkJDaTl2T0Zic1Y1N0ZoUnFsdnRCQjdUZmpleU5SU1RO?=
 =?utf-8?B?SDU2R2I5RFVDcTJwSTZiUEJLTWt3YXhZVTJXMkVEaG92eDMxMXVRUWhYTlZU?=
 =?utf-8?B?dkl3V2VydFMxZ1Z3d0dRZk9xdkw4MTRJYnJMeFJoZVhYb2F0VGwzSW4wNU83?=
 =?utf-8?B?bExKcWdqVHFnSnNWQ3FTbzNFM2t6bHRBSDhWVHRtNzRZREcrSjVxZXFTblpH?=
 =?utf-8?B?TWg0aHhWTU5zMTROb3poZFd2bEVhUUluZUp6elJvbWpkTWNZUDBtTUdtQ1JU?=
 =?utf-8?B?UW11dTJHNzErSzh2WkllYTBlanRoVHc2NldyNVdKa0UvSmxpdU9xRlAzZExs?=
 =?utf-8?B?aVRSRHV2YzdzaDRvQWg0Rmd0cGltVUFXUGtGekdBSnRwZy8zYjN0VVZPQU9j?=
 =?utf-8?B?dm9zcC9vODJPVVhxMzhacHBwRFF1cWhGaEtqWWRqYzRpakRtN0UzY3dMdDl3?=
 =?utf-8?B?WDhHbDVLNnU1VFZXN3ZINmhQRkczejVGZm1RVkZCYy9ZelRjWC9vNkwxYWJM?=
 =?utf-8?B?NHpiOUJEWHRpSjI3SzJUcXArSkJ5dXE4eEZwTENWTFcrOE9lVnNqa2pNV2p2?=
 =?utf-8?B?SFowREkzclhQQVJRNkhZajFWZnVuUm1FS1QwMDl5ayttMGw2VmJ6U0F3Si80?=
 =?utf-8?B?QWt3Q29oSkh3aFJuUG1PU1IvbjdkUUNib1loajBmcERjK2pPYkprWXBRTTRO?=
 =?utf-8?B?ZnNFcEFoWGlxUnJ2czJPOTFqNXdtWE42T1VzVXpuT1lVSk44VkhxVFhTazhy?=
 =?utf-8?B?eWI5S2NkL2orVlBBdElKcFhCQ3I3ekIrVTgxcUsxcXpLUkgyaHExREgvMmtn?=
 =?utf-8?B?WkkxKzdaaklyOW9tQVdCYW0ya2RSUWR1NnhYWE1sZlV2TVV5SUFVdE1FVnhj?=
 =?utf-8?B?K2dtY0ZKUnpVRU5UTGZwckRJdnM1K3NkaG1ldEhiTWFiUFpFZHNhbGhVYjNF?=
 =?utf-8?B?dG1LQ280ZjhaVGVFRjhvSElIU0ZzWmNmSjRDTFZBNkF3bjVEclYyNG5xMWFp?=
 =?utf-8?B?ZXc3TFN4Y2xFV2d4cVJRYlczRU5temJ5ZHA1cWVoN25Ga3gyS0R2VzBvdXpQ?=
 =?utf-8?B?NGpwRHhZU1JmMzVUWlBTMUNVeXJSQ2hvMTc2Y2I1Q1BYZkl2aDlFc05XY0Jn?=
 =?utf-8?B?Y3FwcTdkU2tYQnUrNXk5djdETDV5MVdaWVVjWXVaTW1zUXg5RDU2YW4rYUp0?=
 =?utf-8?B?c1dvbG5aam91ODZMWndwQU04d0gxSU8xMFZRMHJYVE53SFJOaHpkNkJKQ3Vz?=
 =?utf-8?B?bFdGdE5GcUtrdndxaVN6REE5eXlEVkh0VllzQ25SUkdIYXp0cG9MdzFLLytL?=
 =?utf-8?B?cS9uUjVlY0o0cG5XZkxqRFE3N0ZiS3dDeWJ1TENudi81SGM1RXBKTDNpem00?=
 =?utf-8?B?c0daOENCcjQ1Y3J0Q0VtTlAwNUNKb0Y5aHV2b0pHSXhucWlic01wWFR2bDJC?=
 =?utf-8?B?RVBPSFFwTGI3WWRnbjNNY09XSDl6aDk5WjBXRmtqN2VKWjVoTEhnN3hlOFRG?=
 =?utf-8?B?NGQvdnR1Smw3SDNBTldkam1RUFBPQndwTnlza0hFb2tVREx1VnBkY1RsS2l2?=
 =?utf-8?B?eFZYS2xWZ1Y0SjF4ZUU3QXcwMnorRGJ0UFhoMTlUSWNJck01L0hwc3RXYlBG?=
 =?utf-8?B?bW1OU3NWQ0tkLzZWRzVZNXI5bGZLK2RTRW1QM1RlcVFsTnlTMnBVd09JSU9T?=
 =?utf-8?B?eWl4RVA0b2d6ek1IK3hkcGhpbjFZY2ovd3NOY0tSREVGNXh4NEhNcGxZMUZj?=
 =?utf-8?B?cWQra2JtMTVzZ2dpNjh2Qm9BVE5vOHlzWnp0UXNMYkZxdFV3MmNKdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0059d001-99bb-4031-4aa3-08def2e99380
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 12:03:35.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2rqvXFnpwxO+W9xPEqkCIwCGPl+RM0rtxuW7mt7ala7Oxhu4NLRb4qBPvkS0Cni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7371
X-Stat-Signature: etozxt6uyepii9kq7jzzzr3147iktmxj
X-Rspamd-Queue-Id: 80ADF100009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785931426-163057
X-HE-Meta: U2FsdGVkX19jeOUZMFb/ynzpeOYp020ueyddWUQsJ5qvxzLxGz/OF1YojkD/E8g1fHdxn288BTOsnLqpEQQNfktxljSyeb1eOuE2pSxnX2v+6zaL3aqwT1JusLcw3kAEatjnhR+21uzDm1syimjNUs87Vn0a34SqqoQ9W3WdlHnsw8B9o2NFzBSzIkRLi94HEgaeamwij3cQsHFKlnId9b+EyLWNYUBsBi+2IRsvgLuT00RzDX8l+NJ7sB/0yZIAEPj4CttlVfMPDAljYqIu5zLb88PsYY8EpH0klE5Hkx04abjF+fI9iTilqqTYkZ7c3T3RYco8GBK6UdxFmNgUNgPZ0R0AGIgxrdz5Cghud7XxvJsQp+PwolaZhjIZVGd0Lib1WOu54cpuWwBfSCEr1VqWL6kbic8zSttxz5lbhv20xrJwDmhm5Ulb5JJhivUrUYOBebj3TzL98HJZAM1q4FeDx1453n2F67kNu+dHm1pzq9NMG6Yzv5UgrMiytW/I3VUbMyhrvidfPazlp89Sz3Q9aADWdLwNRgiV1vh4Z2liZVva0iDFSPbcHK7THSDqG/8ZWipP4+y1KV6NDzp2olKW0istT/tRl967j07/Iwy/Nj3rTPwpYVH4qNxzm06+a0oK2jnGE5O5YzAiH9JcEiupJFVrJoauICaM421n53Z+NQZ1F7bQ9urNc0Z0fzArr6zacyaS+B6ElRzOWUtLjHylkz/Ba6BSJ5TrXFWVDrLy1Rnrpv65vhXTUlP61X9zsSf7Ev+2OXxd081RfC6QB8dUJ8JJwY42/RVRICRUFwjtrMvqT/LQDpWGIMmfxo8Pp8LJ0TlUUVs1jkC4MZGaiLHQW9vyawjzjLHrF4IgiZt0zFqEhzygeKUtUdcg8NkSB0lAo8gkH8C8IWA6b1HEkwlG7Ko67oI269WdypCDpmaGzSBqFJj1zCvmfA4qJrVWDItEuThixIRJwtJpRAs
 a71FtZdt
 MXYcfkRPeM8+kQT4IzorAWsQ/hrOchrBeKTSeEy/KgsWA7jGGBO7wGzadUcECEQCO67ebyJQmYpq6xL/nGEzvaMj0DOW5//oDLgqHBbhuLGRvAO6i5cjyxrdLmZ/7WpH920mSnflnVGFHYpf5LiDNfumjX9+WQIIY8zG+fX65VUn58GoKtpxM7ijYiNoGe4qr+u//DBq4/fSgT9S+6o9bLVjJwqJ8irkrQ3E/p+2u5ngt4sc+4cn9pfm2XtuQVZqi4QhemXgvGA3X9nKOFE9ZEuzARLxEUy5KIqmws5f6fYfkL9WmETrpRO4V/B/FXwNbdp14L5R3VWnaBtwnGUyOWmjeoPlKIqYUOQPj+yG4jHx6sFKc1j3Iwy4Aj3sceT91gIFxwitQqyBE4q9O8dEsbR3hVyeoIzuliKccphuyyB5ajJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2026, at 7:18, Shivam Kalra via B4 Relay wrote:

> Large shmem folios lose their address-space mapping when they are written
> to swap, but remain valid members of the swap cache. Folios read from swa=
p
> but not yet associated with an anon_vma can have the same mappingless
> swapcache state. folio_check_splittable() currently mistakes both cases f=
or
> truncation and rejects the split with -EBUSY.
>
> Implement the longstanding TODO for this state. Allow mappingless
> swapcache folios to use the existing uniform order-0 swapcache split path=
,
> while continuing to reject truly truncated folios and unsupported
> higher-order or non-uniform swapcache splits.

Thank you for your patches.

As Kairui (cc=E2=80=99d) mentioned in [1] (see =E2=80=9CA bit more details =
on this=E2=80=9D),
we might not need to implement this split. I will let Kairui to decide
how we should deal with this patchset.

[1] https://lore.kernel.org/all/CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_=
MCn2eTyA@mail.gmail.com/
>
> memory_failure() is one caller affected by the restriction: it cannot
> isolate a poisoned base page within a mappingless swapcache THP. The
> end-to-end test uses this case to exercise the complete shmem pageout,
> swapcache split, and swapin path.
>
> The first patch contains the MM implementation. The second adds focused
> KUnit coverage for the split eligibility checks. The third adds the
> end-to-end hwpoison selftest, which pages out a shmem THP, poisons a tail
> page, and verifies both isolation and the data read back from swap.
>
> Tests:
>   - The split_hwpoison_swapcache kselftest passes under x86_64 QEMU
>       using virtme-ng 1.41 (2 GiB RAM, 4 KiB pages).
>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
> Shivam Kalra (3):
>       mm/huge_memory: allow splitting mappingless swapcache folios
>       mm: add KUnit coverage for mappingless swapcache folios
>       selftests/mm: test hwpoison recovery of mappingless swapcache THPs
>
>  mm/Kconfig                                         |  14 ++
>  mm/Makefile                                        |   1 +
>  mm/huge_memory.c                                   |  18 +-
>  mm/tests/folio_split_kunit.c                       |  52 ++++
>  tools/testing/selftests/mm/Makefile                |   2 +
>  tools/testing/selftests/mm/run_vmtests.sh          |   1 +
>  .../selftests/mm/split_hwpoison_swapcache.sh       |  57 +++++
>  .../selftests/mm/split_hwpoison_swapcache_test.c   | 261 +++++++++++++++=
++++++
>  8 files changed, 395 insertions(+), 11 deletions(-)
> ---
> base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
> change-id: 20260722-b4-mappingless-swapcache-9badf123138a
>
> Best regards,
> --
> Shivam Kalra <shivamkalra98@zohomail.in>


Best Regards,
Yan, Zi


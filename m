Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0183EF589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFA86B0005; Thu, 23 Apr 2026 08:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1916B008A; Thu, 23 Apr 2026 08:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1698D6B008C; Thu, 23 Apr 2026 08:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 024C76B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:20:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAE8D1C0069
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:20:50 +0000 (UTC)
X-FDA: 84689729460.23.A6CE2B9
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011060.outbound.protection.outlook.com [40.93.194.60])
	by imf20.hostedemail.com (Postfix) with ESMTP id CCE5A1C000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:20:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NdvgyKKx;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776946847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsbFbcJkYXU3yBK1KJBpq3KQIc1ZW6JoC+QE/giMWBE=;
	b=w9drvuk0wAmro9FG8VzUWjFbYu5aD2/L3AZe7zUEiszYl1lktNOIvc34hnD03ADqB83F/S
	mDBMQHoH4kdIssLF5ip1aHnnxt6eptajpwjDakkE21/OF/Gf+lmGuX3BgTXPwJPbbi6Rd5
	7O/wTrQdviiRV3Z/Hoo+aVpBy+bdHhs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NdvgyKKx;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.60 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776946847; a=rsa-sha256;
	cv=pass;
	b=bttp+bN1dL5Sttkbq5+mzGCZyNVx99LiToxFvqxE6/h19Z1X75zzctrHQgXbp/2GHH0lVL
	O9fcBygLc1VBWA4553WuQuBcgzw7pln/M5yjGnTWQkrgStvfWQvH6DjnzvLSsxMdpFds0k
	znCUWuRf/c8qDxYsI0AFj4gau3/K0iA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKjyn+kP5LOEXb/h0q0vMc8hqNIX3qsl+8y05t/a5ZEvS0MyFknO/pPf8Luy2uNouVJCcv2CkZOKUdEUFNurgBKnO5O4rZ2krm59zSPgLrHMFeq828o5catAGivwUbvkQqHBOjLAR++C7b/GWdyxaAOiggAbGPDAOlqhuTSwg0/FVLKxxz4llFjDzWm+z4pRiwgyKq1AJEREeMPJqFFRBRQkJ9WELyguNaidUiYGiYVTBCHhh1wDP/sNSxDpPgk9a5Ys+RuxX4u/ITJ5RUA+1WsUIZbjBflLrknUV5MBJR06xr0qfdCBrFcofJcZG345O29a35x4FAzkaKM64JhxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsbFbcJkYXU3yBK1KJBpq3KQIc1ZW6JoC+QE/giMWBE=;
 b=rpI84YbnP92u7urRP5OXWFnNDIIKA0qziEIq94RXU2u5qErElniznPRoU6blXLE5vzQ3aT60OfGIeMnComK3UMRW+o2ZzT3D0j1cGMwWBkXW0IPRiJMuSv886tGlTXO8rDwRSHNi/HUEYEePi9nY/6MNt0lHz7MjArKi0Kxfgk/eTlzInt90eG7FttsTQ/5AmJsknV3d4QBO5JcNrD0+iHxYmq6goRBLUpE1OODoH37Xs2J8ASprMUWxmCaI0AxkHMRjtBNwoTQAzLikoSbpyJavMcVNsks1tr7uenvvpUXLXvNSdFn0JhGIOoFHBZsas0Pt/XbWSmpoUoiS2ftDKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsbFbcJkYXU3yBK1KJBpq3KQIc1ZW6JoC+QE/giMWBE=;
 b=NdvgyKKxBnscQR5/hEHCNz75jyzlHuiGv/IbFBxWcOt/bsqbVpKVZadvKaGkNvHGqkeU7dFFsHQpqAqbj1okU9je/8fxgN9O2fpfLEemoeMX2we0A40AMPbzEXfTIRIOX5TKOVfNBZ5Oa5cynTk+xMH1RlsOKuJT1NegnbMLoJk=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA1PR12MB999229.namprd12.prod.outlook.com (2603:10b6:806:4db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Thu, 23 Apr
 2026 12:20:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 12:20:44 +0000
Message-ID: <8da0580e-b5f9-41a0-870e-fb4c41a00aa3@amd.com>
Date: Thu, 23 Apr 2026 17:50:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied
 folios
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-8-shivankg@amd.com> <87wlz1zlf8.fsf@DESKTOP-5N7EMDA>
 <3e1f520f-e3d8-4ef2-b474-ca4e988bbf2d@amd.com>
 <87pl4bfej5.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87pl4bfej5.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::6) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA1PR12MB999229:EE_
X-MS-Office365-Filtering-Correlation-Id: 638a331d-cbd8-4309-8563-08dea132be46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mTtNl7qHLa3wsdPnAIGRAFNohaW4duvkCC6R74f4KakDOo+ufOiDwbyDTCFul5qOQORFKYLhHq//mRUnH7jilm1c6bpHeFTaNByruDh7eVSOPg0ItfeEeETTt1KDbKKbBx04Fia/5e2lXx+FjXLG0Mg3X5vEwEzzM95jizmoRFtm2tXUZaGWcOjCYOD8ElpSp2RHPEAFq7GnZckHv7MCcphFXMs0/2on3e4C0rNwe0sKb30qhiNaXnzw504xzSMNTdlArt9BpxzT9juAbGcqQ9XJg4wCWGJHKnJpa62U2QkKwzLyWJ7jBNEfZxuf/RKw1pgG74MRgTwTiC+YtjvE3dGNtQadn2ywVs5dnyGjeU53XfD6eRi4U1yz8AFNmuBUgy+wIRqhCmL9LEcBBuUNzNQe4MTgThFuYUgjNFAtDAJDXh5DGTDlHk0oI5GdjLJb0zT/H+C85i+5La7zkFWKrit/B5RqgWHp5D1qXvmusMgJGZ61QpjhMYbHbURxKD2XwatA1+lt6pr+vQbeQ0Ird2aCA7EIjwfvyfZqo7REIvRP+BmEAGU8ggfwrcIYUBi5waHViE63Coi6tPDgNn1xudvH28PhnGKiosP9qOc8N2edhNY8554zb3ONCtID0HDGHMn1fXp3oUqbLlMAkA/sH+Rx2Ms0zRDqXzA3G3noI1dRSLyaPtf1DbdkPU3xf8VT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VCtOSkFyTEFPWmg2aDZ0YnlqMGkwS0V1R3RqUFdyeHBUZ0doRkswLzV5TTc4?=
 =?utf-8?B?NWVQczIxTXorQWpGYTlGajJaVmlZay8zc2tBdEZBYUplU0tTV1BQN3g4eHBV?=
 =?utf-8?B?WHZZWkZLbnhReDFTNzgvdW5FYzVsVkUyeHoxYWxwbDB6QzhvYXJQV2dIOXVi?=
 =?utf-8?B?WFdtVFBTVmgxVUEwUlVpWWNQcmFIZ1pTNUdpRTlTaldHTGhUQVAyOUFOQkFy?=
 =?utf-8?B?eTRTbDdrK2hzekJEUmYxbzkyazhuSjJTMXFHek9IeGp4akc1cUoyVUpPZzNP?=
 =?utf-8?B?ZGo2ZjdZZjBnelRGOTAweFlzdU1rZDBOY2hjajNEUHlYcis5NHQ0U0ZXT055?=
 =?utf-8?B?akJDbU9DdGdGVHc0MlhMWUpPczhrUngvdlo2WEdjUDJydTNTUkxNOFFnTGhF?=
 =?utf-8?B?MTBwZ3BsN2FzbnExeDV1eUZVSmpScTllSWZ3VmRjNzVDM0lzZnArS0dPdE40?=
 =?utf-8?B?VGI2K3Bwb2dYVmU3bnVDVTFjeWxlb1hDWGtYN2ZPZ3AyNmQ0aXZqaHlkZmZV?=
 =?utf-8?B?MXlMZld2RlprcjlGcFN3QjJoY2xNdFppWFA0M2h1cy9XWjYrT1UwRDlISUJJ?=
 =?utf-8?B?Y3h5WXRWRkxUL2F2VTE4U3ZpclpwRWlTRWlybEdsZkNxZGtBVmVtY2d6YjQ1?=
 =?utf-8?B?LytOQzJJQTBSR09aU2ZkdFRYY1paVzZaRzR4bGJlSkNUQ0lYbjNIb09MWTVm?=
 =?utf-8?B?UjRSaWtSelZaRWYwWjk1OXNRcEp5SUN6RERxaGVTQkdmM3pGTWYxVDJiNVRq?=
 =?utf-8?B?MTRrQkhUcUpDWGlCUEpIaHVZdmVYNmFmR2RpQ2NaN3pzM2xCRmsycGkxYk5y?=
 =?utf-8?B?clBzVmp4U3RnckZDWFlpZWtyK1RSZTlDY1NUQUpLRUhQYUQxQ3BLNFlSNkZT?=
 =?utf-8?B?SERsL2xIZ0MzK1JIRWhxZ0o5MklyZWg5aW5JbC8zbFY5SDN1d1llOGdpNEE2?=
 =?utf-8?B?YnRrcEJLV1RXTzFFbGxzdVZFcmNsc0lNamRLVU90MGJCTXJZN0J5L3FsTU8v?=
 =?utf-8?B?U1YwQ2NDNEhlUXpxdnJscTZCNEdUU2ZlZDNmZlJRejVnZmswc1dhT1dhZFEy?=
 =?utf-8?B?M0JONzU0aytCeVhaWm9TRzhSSjFVeWV4OGphZ1JFbmY1UHh1S0ZaY0RERDVM?=
 =?utf-8?B?NTlOcElRSFpXUmdIWVczQmE2NFQrMlNEVmxVeC80Z0piclF4RUhuMHU1ZWZy?=
 =?utf-8?B?STZzTEJUL0ljMWx3TjFDSU1yeHQ2STJEZVJiZUNqc2hWc2E2K1UrdkxjR0pW?=
 =?utf-8?B?L2M4WWhYdlFEWXpocUoybmthSDIwVzcvQzR2RlA2YU9nUFRxYVJkcjNZNXNF?=
 =?utf-8?B?bzg3NnVjTkppU29QdjRVZ3RDSzFZMlA4K09sWVI1MDhnT0M3MldYMG9TMnoz?=
 =?utf-8?B?UHRmRFM4T1R5am9XbHBucitxV2ZnRVZkTkN3OUlWQjFlN2t4bnNkUU1JWDBK?=
 =?utf-8?B?M21VdDhrOE1RUmtoVUZsQ2xUT2piSC94dHpyK3A1LzkrTG9mR09yVEhlZG1W?=
 =?utf-8?B?RFNpQkl4d21sV3lHTTN4Vjl5V2JiTzNQazFGbk9qQXh0bkVkUWhrb3RYNTlj?=
 =?utf-8?B?OUVmb3Q1dUttVVRjdHd6STJwLzhyb3U0eWFzS1ZNQlk1UHdkUmc5TGwzcVo4?=
 =?utf-8?B?SFgxYXZ4THo0ckFDU3JxcERwU0gyR1NzZ3VFT1ZHUHZxc3doOTB6YkRyd2I2?=
 =?utf-8?B?VlNlU1ZTMVpOWTAycitEU3BOeUpKVnNQbG1WSmk4c3VaMFAxdjNYMDgyYjc1?=
 =?utf-8?B?Sk9KOXBXYTNtSGl2ejRBbTgwanpHWFN5cEZYaGZKRXhnSmR2Q21vY1JNNDNS?=
 =?utf-8?B?L1dwemFzLzZuR1hxOFNHc0hKYTcrOWNaMWdmOFU5NjdmYnhSKzhmWWhiZXRQ?=
 =?utf-8?B?azJNcHM2Z3RhOTRiT3pCU0pPSlhieWJEV215VnRTR00rb0VsTGZ2UG9DNkoz?=
 =?utf-8?B?UGxlKzJ5eW1zaVdrc1ZMaHF2QVh4NHhpMi8zNWVjVi95dzE2V1IxY0R5c0o2?=
 =?utf-8?B?eXgvR24yRGRVQWM3TW15UHBqMnZKN3Z2azBRUGN0RHNrV3ViVzlsalFCSGJQ?=
 =?utf-8?B?KzRxckpGRlpCSDlubCt4RFZGL1JFWHJmbmdSN0Q4ZnZBZDV4cUJoM05WdDJ2?=
 =?utf-8?B?TGpLLzR5Z2duSDM5R0syRlNqU0c2UjVQQmVDU0tDbU1IUkZQSUp2NENBWGYr?=
 =?utf-8?B?bENjdDFxcjltZ1hBMkFQSFpxbjk0RVg0aTF3SFZyTW8vZ0N0Q0QzRWFkWlJX?=
 =?utf-8?B?RnE0YkJwalVWNXdFc3V4dFlrVmhjNzhJalYyTDQreEJvRlAwOXE0QUpDaUxT?=
 =?utf-8?B?M0tkMmQrMDU5T0pPMFB0TGh2cHdZUmpDM0l0S25zWCtKR1p2Mk4wQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638a331d-cbd8-4309-8563-08dea132be46
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 12:20:44.9132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTkkK38PIefgTfVqdeQzcf5qZTKg+2nfWSaYC9jScjw3j7CHS2Z5OBBGz/oKCKvfMBYMsz6tJF8KHDJX0V73kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999229
X-Stat-Signature: gwbtbu958rto5bcap7hmkef5gdnd6hko
X-Rspamd-Queue-Id: CCE5A1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776946847-505467
X-HE-Meta: U2FsdGVkX19aVnzlrTj7+00/g621Rc3T5P1j0WDjEuGrwJvabf9vN4GCFXHQ8XavGngxq7Z+dOisXF8o5r1sKmR4O6amMOY1/xKUiny+AxT3D0fDJ0EtaQT3ejvi07OQj/D7KDqemQTSksaTPt3ZDKiRzN/v8T5vRITsQM7gIGA1yXujLWvdk6Tcud7W4RBhwr0Ev7lv47/RPYN5Z4emJ1Zl5SZSqzcS5Yb5n3c9CEuwpB6e2bx5uCESascQizlC1pq+5ROplcbF3/XorEfRukzME68Tq7mFyRHPofUHlAN/DeLWRXRZSQGJRYS+GxtNyesYGKh2h/2Uqks2SwEIS0sDhVH+xff4lwgLYg92aJEEGiwoQKedEBV+Ao0e9OQLgybrisNB/cUmmVVRjY4BSuJiBn978UluvdZA9R4geRPhdwgAk4zTdGb4HORGJNhzFvBZ0NSh6cMpediGTJmC0PW9/RkWK03e/3+7Ufjaivz8Fnd3w9nmnl+DOOPXKBoNw03/jGdzj039hGLZeCOfQmomycnIHgN92wfMoCepFsIal82jiytg8QZ5GHTK1mi+VykQ2ql1U3j2haGYRdt7Jf5yvB5DM8JnPdNIQBUGOYkZQ44OsjgV7hthMyRwb/lLjlmsLOAz50KHnCe13aEefQa6PUGLWf5ytkZKb8ZF/01FPqWqwst0QRlTGuUn8BlXWYh/6WgfzX9LKH7EzRcd/JmEYpPcAMPD1LPVUYbVcVEtwA6nGmIFd8irsKWhO8p4chD/YIsxwXaYoFLhnp1I5ClyDAKwvwkpp4vr4YymOKBfcTY2Cqa0y7HfMNVnOnxkSEjwh8GoXVkl9DXNUVmCM7t5i1XbywHFVDEKSDZMnbljga8VnjfVwfOIe4wffLWzGO+ge1+sYmQ/1QqGzbi7g+jgOrI06uz2UEIlyaW/xGQmkF66pleAFrJRgCWqPkuDct24KQwOEWUCeec8T3x
 jTbhW36j
 h3arLxDm1zTrmPmCOWIMId01EyMMFYJkpwqxZB0afqB3bkkbP4cAHwO3wxzZnQS6PwvLbZvji9EZq8j1lbtm+jqd1WRfIky8lGQ15NvV5yCqnaE5l6CsRhRSYfBgov/CK/R7+uYUKk0xyZcFgxfVftPzbpZeji2GjpNs5VZktXcPp7gtgBAXNiDOX6gH2HnHkJBA3zL6fYdQ7ekLjGUse9wUYxlov32LKzGjw94NG1t2bAx5OROc9zjTm5KxWpTdDBuE4c6ocNEXt+xruPGLpDPO7QylZD1N3zNMbe0ltjlSy28H4l6+YWEdD8bSjMLaclx9D0ltN2UjOwVt3KBnmvqfTojDzNtwfictPByabTPAjbkGMkwtnIfkY/OhRbWxX7Bc0N4PGy00xuzEoog9yujm5YtNvd+NbHDZ5KGNLuKwLKC13qa059xChq9mtd7zmV5uuQYur4p8dtLCVPbre29QGtiuI3Mcx6qQi77q1Z87TQzhdr63oqnfZCW+KTWLQCcoxzsgrfQxBPqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/7/2026 12:22 PM, Huang, Ying wrote:
> "Garg, Shivank" <shivankg@amd.com> writes:
> 
>> On 3/24/2026 1:52 PM, Huang, Ying wrote:
>>> Shivank Garg <shivankg@amd.com> writes:
>>>
>>
>>>>  static int move_to_new_folio(struct folio *dst, struct folio *src,
>>>> -				enum migrate_mode mode)
>>>> +		enum migrate_mode mode, bool already_copied)
>>>>  {
>>>>  	struct address_space *mapping = folio_mapping(src);
>>>>  	int rc = -EAGAIN;
>>>> @@ -1096,6 +1114,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>>>>  
>>>> +	if (already_copied)
>>>> +		dst->private = (void *)(unsigned long)PAGE_ALREADY_COPIED;
>>>> +
>>>
>>> IMHO, this appears to be an unusual way to pass arguments to a function.
>>> Why not adjust the parameters of migrate_folio()?  How about turning enum
>>> migrate_mode into a bitmask (migrate_flags)?
>>>
>>
>> Using folio->private, keeps the change self-contained in migrate.c
>>
>> David suggested adding a dedicated unsigned long migrate_info field in the
>> folio union. I'll switch to that, as this is cleaner and avoid hacky use of ->private.
>>
>> https://lore.kernel.org/linux-mm/27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org
> 
> That's good for the original usage of folio->private.  That is, to
> record migration related information for a list of folios.
> 
>>
>> Changing the migrate_folio() a_ops signature would touch nearly every
>> filesystem for something that only core migration cares about, and does not look
>> practical. We can't add to migrate_mode enum either as currently those values are mutually
>> exclusive and ordered levels of increasing synchrony (ASYNC < SYNC_LIGHT < SYNC)
>> And there are checks like this (cc->mode < MIGRATE_SYNC) or  mode != MIGRATE_SYNC
>> This could break it.
> 
> IMHO, code readability is more important than limiting the scope of
> changes. The migrate_folio callback of most file systems shares a few
> common implementations in migrate.c. So, I think it is doable.
> 

I agree. For v5, I'll go with the folio union, where I avoid touching the filesystem callbacks,
which felt like too much churn at this point.
If it doesn't read well we can revisit the callback signature.

Thanks,
Shivank


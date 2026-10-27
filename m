Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD71A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Lhv5RFbX
Received: by kanga.kvack.org (Postfix)
	id B14FB6B05B7; Mon, 26 Oct 2026 22:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6356B05B8; Mon, 26 Oct 2026 22:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E236B05B9; Mon, 26 Oct 2026 22:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F536B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:34:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B19404091B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:34:58 +0000 (UTC)
X-FDA: 85366838676.20.7E7F79A
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8459720003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:34:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lhv5RFbX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793068496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cun7plN/2wHw0gxNzsc+UasoKl4vDi5uCYI5E5Jyes=;
	b=NfuR0OiPmhBp1cE4ElJeS/Nxla5BpkdRCYBoIl+Knx0p7aovS3mUcdhj1joUIzlifDQog8
	dqRMHUBGJcCYY4OvqO1iXDtZPQMOqgGEH+8U7x6WAOTPpOCV06GF0lG6aQ1bQA/F13UtM8
	gaO4BJ9V+jT4rJ1VC3pMLct+P0rdGOw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lhv5RFbX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793068496;
	b=fpDjVm8c7vVsmKTcVNuOVIcKTzmUHRDlrokrBGVTi6A8RxZ5mQiaG9i8LsQ0hNlTKNREJ2
	v2LukTt4UjKbIHsjkyDzPME7qtOqV8K1zYAqLRMrDinDyIEAuTGrXKPY7/Lhm7VDKfZNCF
	8T9JcWsGqyfsWY59wr2VDJmgnYBu64A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMQiR59mM5AyRyQ96QdTjZ3pMrYFr0hHQ0d4wEzLmlwSRQ4Z9jklGov02ICEycC+B/cL3bnPBCJkPyDIa4jmdw62xsza/58+8GRGDms/SXxKRCJ5KLopLRXVXiy3j/Vrv0kE+rah6EOhd4AVJtjjZMCYsqbx9aaGQvFaQqGqCvsqcmlKbyhhji/Agwy2c4lc0+S+12tk56xyAN9j54AcX9y53Za+plSfBnRAYGIbaoiU6AgVpzJmAYMGSUumCdRBgfAUzXQct7p1WFpCYBhaEkHPidNw0Z7CRY44ZB/fK5K7rF42NK4HK8ykz9Y+G7WvLbbThuT4jKKuON8jiWhDlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cun7plN/2wHw0gxNzsc+UasoKl4vDi5uCYI5E5Jyes=;
 b=EN5qThuO4gE/cwtUjxFT/nUJUw2h+ovlc8+YW7PSGC82glgYorzxl1f+JxAl7hITG/QHKMrraO5f4mMW7BhmQyJn7ai/HeheVoHtzJl5fH6138EAsDIYroNF+K90JktFUo4tR5RRjqkm6GmAVEWjSqImHWnLt4ColouWWvXJj7CafTurtMRAT4Zv5e0jrmYfiWyO9gujar3r22wd4yMHw9Z8oNy84CbJhgWp+veXlBLOYioT/p/XoAbRlQH2r/pV/UQU+0Q7m+ITSod/M6x/ZEcOjOBZzCQI0jf9SHJ3JDr9BMaNxaLfkOeRaFWNLJ8x1P2n/jSy1mWgAueTJ8T5nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cun7plN/2wHw0gxNzsc+UasoKl4vDi5uCYI5E5Jyes=;
 b=Lhv5RFbXq/tYKLyxQ2mkcazwlPC+9KoJRconXyROGsjyODWhiGmXTtbCPf13MrSNqdlnf9tsZcsP+QnpfaEfuwvrUvKsbzG0pe9S2FXCxHZtCEi1ondtZRMgsgNIoSotZ9KOM4PL+0p70byM5yINVuOYu4CRLVITMlAXlt+J3DAZFpabok5JUqu34/k2Lhg7FwEglUstNh/1tuptKsOyaCWKc9Gvanpih6WNZqJAmR0NOq0IStEm72FweUmsj2oToCg/fIMbaTeJ5vvGleHvj4HHQCVDSUQXEbp+BBFuW4HEWgabdNgSt1IMKQf2w0C9qrhQp6fPwJXnaQ9bGuNNzQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9439.namprd12.prod.outlook.com (2603:10b6:408:20e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Tue, 27 Oct
 2026 02:34:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 02:34:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Oct 2026 22:34:50 -0400
Message-Id: <DMF9QCS3SQ5J.2NFHUBT3I1PFM@nvidia.com>
Subject: Re: [PATCH 11/16] mm/shmem: rescan after nonuniform folio splitting
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Gregory Price"
 <gourry@gourry.net>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim"
 <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Vladimir Davydov" <vdavydov.dev@gmail.com>,
 "Michal Hocko" <mhocko@suse.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Lukas Czerner"
 <lczerner@redhat.com>, "Carlos Maiolino" <cmaiolino@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Daniel Verkamp"
 <dverkamp@chromium.org>, "Jeff Xu" <jeffxu@google.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Stevens" <stevensd@chromium.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "William Kucharski" <william.kucharski@oracle.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "David Hildenbrand (Arm)"
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
 <at-MPTlXmfs7r5Xh@thinkstation>
In-Reply-To: <at-MPTlXmfs7r5Xh@thinkstation>
X-ClientProxiedBy: BL1PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9439:EE_
X-MS-Office365-Filtering-Correlation-Id: a08dab7d-6b84-4a74-62ac-08df33d2e097
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|261026121527099003|11063799006|4143699003|56012099006|261009223027099003|261021135927099003|261021121427099003|261022105027099003|10067099003|22082099003|18002099003|6133799003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	NZy70OCBRm696GLViIfRjI+DQW7SSwyJM0fDjPOIaZgIgPTKxtCZwj0UBG8uo9Oaj9lSQLHFnwSJ0hk4EZuE4+P5oJBHiWVCJh18uF8FGkkAxsaAMMDKIbPX4iioSwNSGw6LVheIbxla9K0D3far2rhfVDbSmThVGPXBMDEKRbu4AsFQPNKD+SkJzqtmDGg6gLhXhs+R9UeeE4OjDGdFfbgkujAobNPYxwyr+nyG21imLcND1uwUD3Eu4wUhHsH1iE7ovDeVlewm3oJO08ZPtrknU2K4+gVtg4y+pFFr52AAnW9r+VxtoIAaVg+LA8Wub/iSvrgtPdOnRKWi8rAWvgmSoePtcxBsV2VuuQWlvOV3Hc5tXNQKiJ+1Ow6j0uu6p3Dae698h3QQMiUh9CYWukSp5k/UKbQA6ovjTDK71LedqCG/AUjBdcgYOJDC+fwu332YtF2M8cipjS+Rw5vdAXyDyGlJ1iuaZmqfk6ol1bgfFGxeGE3EDXvifeRcRMMZ/CyMh6ob0HgEPPwuuVniDtohJpV7ZCUT/7wRgkzoiuTAwgekHdvUWZS8lJSCHGz++sA6otcOl2Q6ozG1DG+iQ4Xw0x5DcuRNc/F4qcuYVlzjjbVsW+pe+TGFi7nnzKVbaGIKWsNpRKiV57Fts1QI5kf0BeZ3nTsYO578edwV9s8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(261026121527099003)(11063799006)(4143699003)(56012099006)(261009223027099003)(261021135927099003)(261021121427099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFZWcGpXbGZva0xaeFUwZTZLUnVnMVJzVmhxNUs2aUY1VFU2cWN2cUs3OE9D?=
 =?utf-8?B?d2UweFBSNk14QU1XaC84SFZGTWlnL0N0RGhrQWJtTHc1SmFnSzNqUVVzSXFQ?=
 =?utf-8?B?dEpCZCtZL201R2V0ZzY4aU5sSzM0WC9kSno2WW5FK0g5UlJSZFNvd3BhdUh6?=
 =?utf-8?B?QVJxaUdlcDhycHM5T0U2Vmg5VnlIYjhMNTVQRUxtTXdrdzNyM2RzOHJxb00v?=
 =?utf-8?B?U3FVS3BrdU5OczRZd3ZUQWpBU1BkdWJOL2l2dngzVllRS2kwV3VOY29DWHlG?=
 =?utf-8?B?WTVwMUtXQ1Z1bDVheCtKaG1LNzdreGphMk50MGpuYnl6VUZ4cG1RNlRyTXZ5?=
 =?utf-8?B?NUxnMHFBWDVzYjlyVnhTZ1dGSGJkSnlNNnlMaUduV3BtUEtDUU9HTlhIVDdC?=
 =?utf-8?B?dW03d29MQWFKb0Y4cmdoSEpGT0JnTDZCUWV2YnhXbGlDZzRUSmxyMlRtRFRQ?=
 =?utf-8?B?OTlrNi8zTEVzbkRQZzZOVWtCc281NnV6TS9lM2JwWm1ab0l5amNBdmtwdHNM?=
 =?utf-8?B?MmlCRnhLVGNkYW45eHhiVzlGY2NrSlZ2elJDemVZU3ozcFNiRll1MG5wQm91?=
 =?utf-8?B?bDFFL2dKZzNNZ0NBQ0tjSVRMa2o0RTlSNmUxR2xteHpqZTdzbWVhaTg4NzRX?=
 =?utf-8?B?ajB6Mi90bkxkVzRoUWpqZlBzaWY3MnBJWkZJS0FRS0I0WTE5QjJUR1lDK2hB?=
 =?utf-8?B?SzBuakxYTDFHaTYvRjBDbUVMa0pBeUxCd2RPaEk0dWxRV2RHS2ZmWUNQWHNm?=
 =?utf-8?B?VjVQTjNWd0dsc0JwMnFsOURVZm5kVzVxWkR1YzkvdWN1YVArcldLVmpkdkpF?=
 =?utf-8?B?dGxRMnBPNlJSRUkvdEd2bVN2b3VtY0tkdWlIQmwwUHM3Q3VkL3hCeFJMem4x?=
 =?utf-8?B?Qnc0dXpSeE14a1h6VXpXbVBvNXppRUh1OG1NQjJXdmU1bzFnVGZ2aUFiOUxl?=
 =?utf-8?B?S1VNeXQxZW5GaUtBUTh5RVZnMUxwZU53NkZhejZKdXNkQmZmN2dDN2NFQits?=
 =?utf-8?B?anhxbGg0UmNUalZWYnhuTmFjdTJmRHd1Yk5lWktaQlRsY0wvdE4xZFo3Q0Q4?=
 =?utf-8?B?VEdqUUh5VHNWc1AzUDlMY1ZNZFhZQnpBbUw4TW1UQUY2TmV3M3lNMkhOajhG?=
 =?utf-8?B?QllVUm1QVXk0ODZXTXQ5a3daSG9wdEkrMHRhRWxla0lJZTlXMjhncHJkLzdv?=
 =?utf-8?B?dTZOckszbzNnK3RzNVRZb083c2g4RTA1dThhWjRvM3ArdDRaWHd4bm1Ham9a?=
 =?utf-8?B?dDVlUkozLzlVaU8wU2NHS1IrZEw0WXozTGt5b0puMzFreEd3OW1hNExRaURO?=
 =?utf-8?B?STlIbVYwS01TdE5BRjcra2NRVDYvQVFCem4vcFlOTk1va0dJQUtQSEI1cnF6?=
 =?utf-8?B?SG9VNU4veHBHQjQya2pQTUN1bXdEQW1OMDB3SHoycjZZcGo5S2FoVTA1OHdm?=
 =?utf-8?B?aDhKU21jV1R6djZubDZqRE5IWG9LbDgvUnhHbEowYkc0MFJ6S2g4U0d2bkJ4?=
 =?utf-8?B?UGdnT280Qk9hMVlQWnFwM1ZVeDJtZ0dpUWQzdnRQTHFvM3owcFE4ZFBmSjRn?=
 =?utf-8?B?RTFXT2loV2NmYlFCWjFoNHcwSDFCcFphMUNkb3JSQ2ZoVzZ0azdYUVAyU1dL?=
 =?utf-8?B?OTNYVm1oUUNyZnN3Sm9VdUQ3dFNDbFFURWdKT0JEbFJQb1ZWMEh5QWVpc1ZD?=
 =?utf-8?B?ZE1Ud05NVlJOc1FtcG1Gd3hieGVRb0MwVk91R0laVHRyQjlkMm5MUzJyeTdM?=
 =?utf-8?B?RWhWYzFIYVd6alY5dEdkcTRrVjZxMzVUYVZQQ1RGeVo2VkJRbGVEUjN6NW9v?=
 =?utf-8?B?VTNKWCtGZExSRHJXL0ZjQXV1eGR4U2UyZ2NDSGN5TVcyUDcxNmdmVmd0Z0M0?=
 =?utf-8?B?QVZPZExGdWhBK1ptNXVWd1FoRGtqeERpeUxrZnhaVmFHUjcwQ0M4MmI0SXY3?=
 =?utf-8?B?aDVQcDRvMVo1dkxDK3VLem1HY1NDQVMrN1lLRVpObjRnVGx3V0ZQUE9tMzZj?=
 =?utf-8?B?a3pKQk9STEFHZFMwT0todURMREFadDFIam9FMnlYb2JIVm91REhZdis0N0xO?=
 =?utf-8?B?bm53WFoxVFlBaVA4RWNJdzRKSlhpMEc3V1d1Z1BxMTNMZGN4Nk5zZko4STFG?=
 =?utf-8?B?WkJkM2orbStGYkRuT21SeVo2Zk5KQ0Y1OEdMM0FXSzhZVWt3K01JRlV6R0pq?=
 =?utf-8?B?S05tUUFHeTNjODNkTlpBWVRwUTJKMmpDNTdMWm1FUkFTNW45eVhUSnFwby9q?=
 =?utf-8?B?MUJMSFQ1dDNpM1BRTVh4NXd2UGxvenVuTVp4Y002Y2pUcyttQ1dCREN5cnRN?=
 =?utf-8?B?RXgvZ2RGY3hhVWd2NUNLQWVGdDdENnQ4Mlp5WHdyTDRray9vbmx1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08dab7d-6b84-4a74-62ac-08df33d2e097
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 02:34:51.5355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiKFNjln6T/gMfAnK/KucSkLSZBkgXtABKE8jp3KIKhV6mQNrfcZRrxhO97vK42y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9439
X-Rspamd-Queue-Id: 8459720003
X-Stat-Signature: 8bssam1obfmgeerpiosuuf5ucbg95848
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793068496-309180
X-HE-Meta: U2FsdGVkX1/jywa0np5j+aNNmcCWQYfJeXpFgHNwHa/k3SEYxGP5gitGZZRRIPz5Rq4/BWaOQCFxVEvSKAtNQyYZ1B2qsfd1pwFSkCEVI1HzsnMaqPKrv/Dy1j4ykbBkIPLN3gmezRrg5/lEMK6s6PBKdQMZ6FJyBGC/qIPfCOP8qqfa2M6CQ3PdEzBHkYjMbKiYNh9h2PpOsXh62THDFO7IrKFrm4FKbf3rR/XOlV+F0Y+FdwhjYxjT68k/76rRs4JkNnPTP4gc8EjG6CCs48od1P+96IdQMOnvFtzF2qSgvAeSrtppKnsVZIJMPODkoA23X4Tl49ji0YfY+RNd3qvEe/DNSLWkbTqVuzswnqb1i4yq4xJZZ7SpwbWtWGIQKtNAfM8jGOQSte/sadIl8ySWSv6LXgIQR79MGHpLdBf7G/5+NwXKrw9HfUYKjFY1pluRO3VXnSYUF/Jc8pHouqxCIMMOFfaRvFyGij0bmGwF80Q5GqfxqP/s1Ijwj3Y5L2/ERJa6jVrGy93IocDv2N8XOBC72ElInwNG2iNuv5QLCzSfzPSrcGv0sfcMWmUcj1klbeoZ5so1BpGkeO2Pt8zKDVtjdXC3hDB21u5hCU3ePwb8NoihMVxNeb3J+ThAYzrUDJNgpdA7dbsuwWBK5qsbh2eme5Sa87EnOCO4bifF+GeUrByBeDldXTsV7k3TiyYbCWwMrvtt9gSyZ0T0lNrHZYKpLrv9zS8Ya4yzZKlFvYrM+yFw7RqZW7q6D0CKRwHdt7XEYULk6xSeBlEPytswn6ag3HBQ1mm33G0lJUflJsaWZVdF3z5ycpia3Z2lpKqVMmDmVQUy6mHgeGDriVomZ5yUyj2rZAvj/pjq/dFawA51B9BABdKYgHh8NtgbYpuhu/93spMC2vzZOVN9lU3INETJWXf+txzMlNcVepPqn0wUEWp3rsb6kraTba3tPIAEH3h3004kcwvLS5N
 ZLENBt7x
 HWlWpyq9BZOsC6Gp+pAGKgbw/r5DB/nk1JVT67RF0uNXTHzwlGNiz0OZEBXp8ts+Zhk2VtJZhYmFoZTEFMBjQwq2m1FlPAqmuD69gYWJ7lLAhbNR+G4tKrkMScg4k9PnYPLPARIBnh8ad1OqYfa/pZDlyJUC2ZN9WFzK97q3H7t4TY7BzoV7rUagBHy7MxjFKvlPa0Aw1LW9mLeQ9lMR58OxBrP2ACrh2ffEammN7nI7PIxWh5kaTm0bW1cdDCFGZ54AVvd81CVcjF+c4FZ5/wJjIlWY8xrjyNOxV4kH1s3mfVNh4/OZrW9z1iDxkghuUTi+73x1/ykjdWhq3+aOc9GNbtai2P+mhGQgjxRv1Gpu3dmlNM17vbQ9QWTLwVVuEy7O8XDKNLu3AQ+68o2itqJRTyULAcWOGmNur+ZISocEhjx6jk6w1OPzlTT/ZE8f4nfc8imtLWOS3zSE+mUhdr+FwoJsxF16tVyxA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Oct 26, 2026 at 1:26 PM EDT, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 10:40:44AM +0100, David Hildenbrand (Arm) wrote:
>> The final scan in shmem_undo_range() restarts after a successful split
>> only if the original folio is no longer large. A nonuniform split can
>> leave that folio large, so the scan skips the newly created folios.
>> Hole punching then leaves pages within the hole allocated even though
>> they could be discarded.
>>=20
>> For example, a fault below the hole can allocate a 2 MiB folio after
>> boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
>> folio successfully but leaves the original folio at order 4. The scan
>> continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
>> The hole reads as zero, but the pages and their block charges remain.
>>=20
>> Restart when the original folio is still in the mapping after partial
>> truncation, identified by checking folio->mapping. If the helper
>> removed the whole folio, no rescan is needed.
>>=20
>> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operat=
ion")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> Do we want split state after truncate_inode_partial_folio() to be
> communicated more explicit? ->mapping check works, but it might not be
> obvious why. Just an idea for a follow up.

Zhang Yi's truncate fix has done that. truncate_inode_partial_folio()
returns true only if the folio is split[1]. His patches are in mm-stable
but not upstreamed yet.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/tru=
ncate.c?h=3Dmm-stable#n248

--=20
Best Regards,
Yan, Zi



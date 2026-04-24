Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88FCF589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263E06B0099; Thu, 23 Apr 2026 22:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B406B009B; Thu, 23 Apr 2026 22:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B51B6B009D; Thu, 23 Apr 2026 22:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF73A6B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:52:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87FB8A0B7C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:50 +0000 (UTC)
X-FDA: 84691926900.17.02F50FC
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id B3EE120015
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O7hM1o1K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUWPNMI43CMSi5bx25ldmPlNHdWHEBHgCa3pBe81r3c=;
	b=1wcrfMAVHZu2V6bvUi92pMJbBu+BK5oZFj0UpECG+w3ejzvLN88Azqw0LyYnyTc6IT41nv
	4VX9B/Icn2D0IlY89Q0x5sWAeO9JnU04L/93rDKnj2IXZUnS24E0RsJ8eXMnFo8d0R60J0
	Hi/xgYVPmwjgNIzVNvmtKCloPgVaQg0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O7hM1o1K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999167; a=rsa-sha256;
	cv=pass;
	b=N857+LNeudgKrKixB09/kl6pcZziWzI5rAIsH1Y49IVWLFJicdDJTEnIp3P2cCnQbS9V5Z
	BI9ZxYyB3Ez75DX9B/oTluyZ6dC2jpjJxuLAeFE8ElIgBk03jrJ8dH4J1svN51cFSY3GI3
	s/gE2SH7VSLNGtJzZa72Cltvte5f1mk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nv2/iDhN1STpYMozNWBvVzlMXn5OJfDyfB06GMqIJQuYnlSaxgKjssXQs3HRcQQi0CV2HVhMPBZ0wKQ/k5DtmIqY7HgW+FvbAvjdqnmWeC9RXByTISaWIJgCAXN6jd0eEQuXZsH9WFoPNj3hL0RpIgnFTNpMD4NkFnDrY8Sn6wb3CzmSdz9byRPwgQAWCMkw3YxaA5JigzmLEE/7+o3raJ27wAy1V4zUxvrseAf2JPQLA/aLpATeBy5r5QbUzd9N5LYOUTIcWM3gSUolf4lB0gVSw/G1dp2eFFPDFdWD+kSkhNAsOekAoplwBtwVaMuYWFejlHys+6PO9AEp8o6N/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUWPNMI43CMSi5bx25ldmPlNHdWHEBHgCa3pBe81r3c=;
 b=DqV3lB2vrktVXcalraQHY1bGzMZHktr2OAN1vg7tuWhtureW/kkxH8Ihg9jDYe1Ufq4n7aLQg/Si6rmTzahhqc6VmlnHtf+Tq/Vs7gzDrrpQqnDxFvCqKnLJAcFYglNDUZn+GXGhPeVZl0h0WBJe+ekLY4GyfhMFeKsYVJO7LKCIDDM5I7ayESpVv9JQX/w86bPpOSZgRwFNiU2ONh2Dh/NYTcEiho5UEZx2zoXSQb0dxAWjaH7SYEN5GEIcCk4e5jBqAzIx7+QkupSd/Qdynh5Ty3zQIxu+F1VHJ0/0iuc7D26tkEYoyTOy8S2emQmEaarHLb1VNIX5tQY9cZ2KLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUWPNMI43CMSi5bx25ldmPlNHdWHEBHgCa3pBe81r3c=;
 b=O7hM1o1KDwi+nTP7dZCQ3maN7maHR0gNu5w32ss+6Pi4XOEhbOsq/bt0mxoCfdVeZ0peiXaGWywOn3Bd1YGdSZfxE9Zq2ak9LWM5RudwnbSL56cYLydHdKqhnD8EuRSB4Vi6g9On+7RCLmqf9h1HJ9RFiQYPgRZVNM0aCO5zhI4LoB6WprBhiXetdQq/X8ypR+mwnLr+GFIPxtMl8LiBAFD9cmwupJyN8w57fJXHNuFsgX/SSyCF7eWrOKUsGmTUcrMz0xK0qIjQygNi0GJrZVX2z6CX5/U4zgULu/zeaVfIZH4Iy2nx1cwONaTK6b1tcl5Q7461KPgz1fPoPgqBlg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7825.namprd12.prod.outlook.com (2603:10b6:8:14d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.22; Fri, 24 Apr 2026 02:52:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Thu, 23 Apr 2026 22:49:15 -0400
Message-ID: <20260424024915.28758-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0296.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 920f2342-0a06-4957-0440-08dea1ac83a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vF0lZm72yp3xg+nV5ArKHVPi7KSa3iaglF/VqUIUbXD/8kxaPTeZgiCRjeJUO4Qh3hCXMiPC81KfC/XClxp4npElCw/8xzArr007mO7mqpvCkLOP5ABpB1UskXoUH1RfterLdJr4aG8ytGS5uBwkNLL9y/1ETquX00UTWc3URREaY/o2AmMj+yoSPqZ8lTH16G/MoQ4HtRbbbGHdJ6tm0KTQW3LO/CukWWi//Mv3WJbYS/vigV3c9Nvr7rQa4kNHa5XaVVw5Mhj6oNHY1o/xage2nbUxX60NqnciC+QJFF8q81sYw28ApMA+bthagKN3Erf38AWjEeWAXfcTANDRkti5FC7Guu0RQJ93KnqOvS0h4MwEA4uz7FIZsU7Q34MPIbuvzPZeagXpkh/Yp1Wec1M2EFhZHyWr8mgHMl7YlYt+4rB/GAuaN+RrzofvLZtmRYjX/VMprrpILzvXvMcsmvdJLAmtSzVm7C0BM8zdFlq70IXWEDEy2REuhTqrdIL4thov8YdmSrHeQ9lmmsZyPVPasHhpAxNNA6dtXvrSGqCDlkVFvP6sQbwmN+CnYaRi4hrcuBT4fT7lzYYb8GNS+ATtt8z7HgefPca9wk0sjQQ68ruld+R59rhGJsCHralutwlLpqeOmi59tzeiMLZ0SjlePTuOpG9gJEpvdeek0igLBidUd4lwSE1q6q0/W7BIxCzGpQ8o/2dQDpyWhTDpbQDNe6Two1skWwmB+qcE5bQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TOhsVOeM5K/YIpYj2A2L5NVo4aMqXxXQOSb+x0IX8yubGplyKlPSZKXUIza9?=
 =?us-ascii?Q?L/SKTyM5cgae/8nBHqDg0fMz8Kg2QPC89YhE9NjYktgOwXyORDhC8jUBI/AW?=
 =?us-ascii?Q?b9CDcmkvRx6nzgUyRjn0pTr6NYjGoZYhi4IQFVIxJnuInHrR+CRZ3sibmS9I?=
 =?us-ascii?Q?V6EXPyfALho3lT/MhlDLD7CdQG06c9bUHW9JKEl6QgFb+n81+5iFgCJ92Wdh?=
 =?us-ascii?Q?MxFRhjkRqbuk5tiCIHjdsPFoIbaNYsov5Vb+RiLyNa2rT0Hk0MAB5D+xjRQq?=
 =?us-ascii?Q?DUrdx2GFxpL+/NyuzT64RGdlZsPm2apSXjC5rahTE8Z31QtBoWEHRbuXEwC1?=
 =?us-ascii?Q?Gu3lPW5dGSMq2xYJ/flW3zIlcAdofcX+98h6m2Z5nyShR4QxH5aiqzCtQPDi?=
 =?us-ascii?Q?Rx7m5Tgh+y/QYOlpOAOZLlLucflRzBW7dSJZkQ8K4Et48TbCdDb0WURj24Te?=
 =?us-ascii?Q?g+zwZCujRo1zXQl4hx4v6nerFecBmOkZZP6Z8Lovf0QhzOjfC8PcsqwRbp5j?=
 =?us-ascii?Q?AQiA/O7Ejq2VkOXY0U2vC+oMHmvPi7A1oSb7WfZ1uh+55+QhxyZWkRRvNOsU?=
 =?us-ascii?Q?HUAHUQi5LbqBSLGwT58ktslsJihwoc2J93TS4Y/LdsNL4Te6rpsGzR7VAbCS?=
 =?us-ascii?Q?69324dphxlGLg8BqGkQdAxAL1PRAuZMsaisYVzk8Z79kRx9YnFjyaqY17BcX?=
 =?us-ascii?Q?xZ3OfYm8RYYrJdaCx4EKgRHTSCsUJivNbGSO1CfFYsbFePlBSWpuUNyptIPA?=
 =?us-ascii?Q?Y2IToAxCRnTa8LtQaAZN1LqRRulzuG0wxDiftNq+SIof8nDpvA+bWg26lFN3?=
 =?us-ascii?Q?tbLEdU9ftuP8CiA64JBtN403x3MIe7syP2HrxeZ/Qg5O0lVmOMOrtvMKTjIh?=
 =?us-ascii?Q?ec6hwowf8DqulTYcWAPJI0LnIOdvshucneg0tn+Z50RA/vGzLZi8vYs0LPd0?=
 =?us-ascii?Q?2oP4590ImOu4mDeTFnJAl2vY9RxgIoasrHXLcnpkvTR5He+DPi2Z9aAddsS0?=
 =?us-ascii?Q?/DvIIEIJHLR9t2M1An4V4zBWteVytH81C/N1CbirE/Ffg0X+tZJAJCsfBdQF?=
 =?us-ascii?Q?t9dfHu7M/da7x5FADKDtZU/f6LXJWmMQLjxMOY3rU89MNCZAf2o05eG+M96h?=
 =?us-ascii?Q?BaQjhnVV0CmGFD7pAwXxFBew4K4fcRDEXi9QIIQ1PX7cW0GB/l3ODGqZ1c02?=
 =?us-ascii?Q?wthfs2zEbluyPNIraChb3Sju7HzbSW4K91MwRCzatQIND4yYZZgHnOTVjlBZ?=
 =?us-ascii?Q?q7QzQQNvNH2kxohahugCTJmppF/m9KCp5Yr4TbrF8PxxnWMpNAYwaYSE0iSu?=
 =?us-ascii?Q?pyA+x4qJxTIlNPg4HP2/kw8Iw1H19Jl9ul5fhaAjI9b7L8gurImIzhiZB+Cs?=
 =?us-ascii?Q?nH/NHeqmB1/I+nQnHF0p0vc/x5b8LChNnWADN0vkQ9p7vk9ZjvNF4drKR4S5?=
 =?us-ascii?Q?tmX2utx4OCJV5aZFe3VWRW/LUWcAo+sauW64/FsaASHhAbNRPzsvtX/PQxD2?=
 =?us-ascii?Q?sYhf3LjzAD4Ke+uN272kqH+qm8+vTxpfwIs08XA03pwHcgSDf1Iv+AzUN6pp?=
 =?us-ascii?Q?gGFe0x8cknVm0zI9IrdvV8i/+vhQvs4wvOczDQB6mvCtpDZqgNTQB87Rsnu1?=
 =?us-ascii?Q?/5GKUY/y5DI42Aw5i6Up+8lJu3IJroC+Muls7S4fRZYFzTsLGa8eLknypIdl?=
 =?us-ascii?Q?ayNwiPS9EmSJY+oQqJAHosWK3z1UIRLApJypuX0kUPNqVZWR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920f2342-0a06-4957-0440-08dea1ac83a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:24.9182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2yhTCkuQn7STOe1ObI7rQaLrXNtvK0ojKwf3IWdOXzI0tLm4JfDSsTNfOFKZ3I1+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7825
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3EE120015
X-Stat-Signature: c5ujhbyduf6he7e53hdn79oz5uzdz8ns
X-HE-Tag: 1776999167-792151
X-HE-Meta: U2FsdGVkX19NVyumyLTkZmjeZ/ta0mb0taTh/nyccc0DeklDRcxs9+tdUOYwF4Qvt2HD+WVaOfXaMuqFFtHHa6tLtGGyToiW6UO3830e59Nv4x6NQAvvseestWQbaC7UXtRDcp2760mIXKhYWSIMUNitVfGXIzu6fkJNZo1LJ2hgEnnAO4Iq/omM9bGCfRBg5bFjrkyY8zDMMTTqZai4bWCxYZ0LrqEmjCfcQl9djNVPh+simIhzwy9uq9+0PXMFMhWmo2wW6cRissk9BVfsXKNWukhkyBeG40JGnO96RTim5tdIC3hm1Sp8eH4Njrxwg+msoQH6v1ybquCtqEa/uS8guJ1fcxpqMw62zABHspiW7G1ukz6WRTX7HLLqlmDYB4XacqsklgBflUhQugKDuKGEmwRITOWuHDW8rXG7E0srEUPsAZ0/Pr6fP2ad4pK5PkRYLs3ro+L7YeA4zyOkT+fCioAnFTADBHLVue1et9YZ7eZ6jqE9drVPJ2JiGrZ9s2JFH57WClzfCfLdqIqW34dtL390wKEEZv+c9rgkj3UQ/nmWG0Ku3g1Nl+n1TxTXaICX6TAmDUOdyBIFMMGO+BK4q9Ns6cb8sUqIKyHbxVvqTBb3eVYFk0kGg9LQThMdzRxjJ5gH5WEYewGTty+Btts1lnqUjVRTyAqJamD/d5Wy/Nib+LGLcaCNvjXiz4z4g5DnOeQ4GaFtdt5CnoCKw1+fitMAbI15VmHeyxOXrgIBQHPIpglQ0CXC2l2DeLhRpFPpRlTSsYo3MkvTyrcCzdkHjqr1jBoFo5oWKh9QfPB+akGd8NkuIMTvuO6bT4LAv8GjP6j7860qW7sqK814e6Pg9vYnAnirm9OaoZeQyJZRqOP0z8Z+kuY9a1Uwxm/TOKCx7xpAE9h7OvWO2qxjONwkX9dJqgOXWHebXGBh9TrGAbcsb5aVYMqnRMfeajkz9jh/JNkzRXCKmqF7VhJ
 TsdRUmqV
 ajHtrTT/a3fikYV/6C2dYiZLHKqB5nZnDhdMo4WqJNT4tzx0r4wo7it1p7vL+h/PIsQGm/j6ZuYKLK8yxyqlTSx0wcXCwd386gmGQfUedhfmgLDsvXbB057fb8xkpqToSw3K4wBe4SYfOuZimcZCPhH5JEKZJCGvjx11N3m1NkyAyriKcI6tbP6GGOjdO+ROzt7K9U6U5DcFzUxWW/2CK3sUKqw+/sHkcfFAufp8qZ1OoDxuycESFRtBpT82WhPNU0H7RwxR0FoCBbKcjb0dpCVK5cQMj9zBWfAoIdmXbz4uZi0KiQkk9CZ+uML3/dKttI2OB0tRRKelDJ/aeHNMqSXC0Z1BvcFuAmoFsU74PM0PqtisAcRKBHOHIKkDBjuA6WAsdPLJR04fWeMdLdLHXjrcqN9bFOIjeajHGuTedQmQDLWZD6jU/FqLm+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any file system with large folio support and the supported orders include
PMD_ORDER can be used. There is no need to open a file with read-only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..117639891953 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.43.0



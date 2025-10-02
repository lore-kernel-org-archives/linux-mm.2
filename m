Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D49CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 18:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4588E0005; Thu,  2 Oct 2025 14:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354B18E0001; Thu,  2 Oct 2025 14:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BFE8E0005; Thu,  2 Oct 2025 14:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 035968E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:33:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 985A213B5F5
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:33:33 +0000 (UTC)
X-FDA: 83954022306.29.C767F95
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA43540010
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:33:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rA0Z9CiS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759430011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRzjBHJfOArtk2QlgLoaBdA0LgzkoMKJDLrsbNm7Aeg=;
	b=tDONRSXKEUljlgwTXFgVtXEl1RIQYeW8iSX3InIVYjA4RQQDKuUxFLg4Dq/S1nTvEsELxM
	Cjcmz1AOJNwwQrquU/yXXA1Q6x0+O+ZSED1MbiVeTcJebD1UvL+Lw7SagCarkEDw26/ulk
	H/dL/7UpUgR+K8DCjGUTUGzX3rCKr1g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759430011; a=rsa-sha256;
	cv=pass;
	b=L9uGoHQr7wJTZ3Lp3mAbCFhSpnpxJtMIEswdDi8SExuhTNlvimMArRU3vjTHZeBlfiEq8t
	RFjXeuQviU7xcWbsNlHAXShNO/xKJSzXZPgilymEmsXERd2hXvH9/x0N8jvXGrfuP26Vu6
	HX+swKFwjygzNIrznBwqtRExC790LM0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rA0Z9CiS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccyHiSvwgYtPp8HqNlLgSkT/Z4KM/qZ/HC3s+8Tix6yE4Dhk6436DCoGZE4V460/9qllY75OZ4ZEZvQUyNoFliJN0wn55wq3bAy1G7FtpatPBmV2wh69Zt8+uGw7ToIkw1CcRy5FbVTj5F+DH5DspvH4wjdtvxMJfyF9B8B3i0t9rUR4XcaM4x6b5icqXvQtb5ncm/nf3s/aMSJiVel74+XB6LrZLEqUWRjhMvmi2Ih5NhVJBz2dYD69o8AkREwjbE6/kZL1TXh9oBoSGNrBZLAnM60boPEdKdnYJeN1wjDiOHzvGj1/qopmV69lrKeMR14G0aIYG8OzS4tG5geeTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YRzjBHJfOArtk2QlgLoaBdA0LgzkoMKJDLrsbNm7Aeg=;
 b=HxI5CyY4rmy+sZySWKsemIRgkCQ3OTOS84cc05XpHRi/Jwj6ccn7cLkVNLEO2X+9gyI94nab5syypcstGaNWJe1XgP8sIZ7pZ/aKoTfutLeW2or208mPx1AYHKK9VtPgSNisLjdhCv07ejDCl9FOj7trS5tuziVc9ox0fqIw5aYQDpfInJOLW2TYaa9hnSxjGHNVmq79PV0rYE5NCHqOq6HS2TCezkvh+tL7qMlEyCZQyqpSbty+38w6DQFSwFPcap4terWK2bAa2Q/gjot2894Bji7uP5/O3fTp+uSKeJpX7FXmkbDd0rMW/rQ/c6V0PPZczHy0SsmaXU/+AnEnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRzjBHJfOArtk2QlgLoaBdA0LgzkoMKJDLrsbNm7Aeg=;
 b=rA0Z9CiSA4cbZvGB6W0GXHqoS1a9nbM/FuXSXrtTMR5wf8zXM1r8y26xvfw0BK/9wdk4/11HlO7CAPsz/ey0kccSnRvlPneHp9Teyr/L+w7qwWipnPzw+y/7xxsaPx5wYt4KW4RzJhFchhEVpU+D1cHWdU3MqplzJZme/aYyZmFHlZlXb1wVwMahhBJQEGEcIR9JV5Hk4Iaoa9hvrYNT5+tZztQ42qGbrEmC/KVU6w/4nSz2S8dglNbcL9ssA1jtn9dZmV0XfgS3VRfbWpqYthxBWnO0TgbywfTEQf7qxAHRruQ0Nx6YGap5y+uxXypdYKkrfHyf3yR0Mi+aT8JSoQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB8952.namprd12.prod.outlook.com (2603:10b6:303:246::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 18:33:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 18:33:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com
Cc: jane.chu@oracle.com, akpm@linux-foundation.org, david@redhat.com,
 kernel@pankajraghav.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mcgrof@kernel.org, nao.horiguchi@gmail.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Thu, 02 Oct 2025 14:33:21 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <D66CC340-262F-4CBD-A64A-FC3D809716B7@nvidia.com>
In-Reply-To: <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0166.namprd03.prod.outlook.com
 (2603:10b6:a03:338::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB8952:EE_
X-MS-Office365-Filtering-Correlation-Id: b60e585c-67ce-46b0-119b-08de01e22cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DMtx/r9veTmNLc2A2MTDDBIVkUijLpnHF65APghH2yrN0aN+oWGcUiGEiBLS?=
 =?us-ascii?Q?TIZl0qxh+Ialio7wBLTPtFE9o8npeRQo/95ODs8dXYhNUK4BCgq8Uri0yUSG?=
 =?us-ascii?Q?f0mw/h4Y68aujub8tJ2RzUeqsTCqPqXJG3hPhUvprIjVPpygJxnnyUPJtWUG?=
 =?us-ascii?Q?57XSh2HEL3bi2pCsFlrHUk7mVyxV0xdPqv6usjJvvTaboVz0bMmmToDd3ala?=
 =?us-ascii?Q?uJ6R2TIOQ1OUytdShGyqV0b8GwGnDHtX5TVweFLsfHc246qFVMCzLOAcutsy?=
 =?us-ascii?Q?PlpiDwHalamm0JwOLycudIMndcNDyxvEDOFfRJGoYvlAOnUZ92v+L0DjChe6?=
 =?us-ascii?Q?/5YpctfzvG49KUd2LMzwxpxiiKnF4GCMKo0o3/XeWPcuB35TqyModQWYIUhO?=
 =?us-ascii?Q?6G37dsMtFPbnRnzTJklTrY/GxZ7XG3d4pawCAkIgcXJ7M6q5AxXLgtFifkaI?=
 =?us-ascii?Q?raDlcHrZ8iNt/VFQwgawzhgGUC6Knt2KZZnjvxI6wjFmM2j28s0r9o+LmkmP?=
 =?us-ascii?Q?1qMxrQhoFWF5Zy0aCj7rRfNb6CiyBPYrLyE9LmkD2jOM/MDxMEMRgo5Leg4L?=
 =?us-ascii?Q?1wDts71xdqoGdfbAvymkO4u/MRy60fKFJ6jtYtH0D+eyzNNDz4C4J354i6V6?=
 =?us-ascii?Q?5cpPc/pC+e0UDRsMaU8NitB+w95/7VZo5fU7aOJvRXd1HM1v+zmx3SuKIDyP?=
 =?us-ascii?Q?xGW8ElJDX2gG4+H0Xdxe6P0gj7ttKAKd1j50cOz7CVsDCe4izL1C7nKSR8p0?=
 =?us-ascii?Q?kn1jy6Y8iH6Lg8zAyIljXVotAPQAI1Afn40CWnAgeR1jbqvsj6BbHTxzhXh6?=
 =?us-ascii?Q?QSE9paS+XR3djYfq/z4jh7Ax/ZgWCWEM90qmbz8+91aP5/YZTvzpEl6VCMDg?=
 =?us-ascii?Q?3BjtlueWawxD7DdZAEB3OhRdoQLWwIM7Yd+rO3lKkbLkTE6brY7EeaMljqCU?=
 =?us-ascii?Q?adMGpgG2uEO8dlp4nnpOtM2JfDsyLVHTd+iC7UiqfEcFxx1e3X7WmOFkBPOi?=
 =?us-ascii?Q?j9UGVJ6MsKadpnYhiFGaAAoBbzm9cNeVmZOgoR2y1qOVPczpNrYLavdOg/Mu?=
 =?us-ascii?Q?mRVmCT03UhGlSoS2jroj8LqKFWeUPvZCJKd1+uteGkdhUxQPmVeQ7sBDQxMP?=
 =?us-ascii?Q?zmhvnXS0o9wJVVOgfYsoRnZTZI/9R53sXhDFaPudV7vp5Q6zwnH76vitZ9bG?=
 =?us-ascii?Q?XuYPywDGHcrnk3NTk18PtO0K/Gi2eEx81DB05y+9ByTnl8qC2GOzntA54Xs4?=
 =?us-ascii?Q?/d4poh+JE/cyWjwKBrmaa1W1vl2jAD9e80gnhYAjBpuHIlPgg0WZm8m621lk?=
 =?us-ascii?Q?6S6xLh6OcUtF2n81MjnN50W4lVe868lLxk0SuQ5PrUAxCrIJETA7I/S2qERh?=
 =?us-ascii?Q?5sG5xDOdN8doqXNI8N2pd2+J67w712wtbwy52d/LqLqxGnwmKTqFtdseV2ec?=
 =?us-ascii?Q?NK5a7CtaZeujUMgR3n/zhoW/p+StyDtflY71DSSugzYjcNheu271ow=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4zB/XCcUO4wZDyiBIEK/QU8RIxyv+/Ha6TSjR9kfAO9ayiUqJuWUfvVr5wp?=
 =?us-ascii?Q?yGArYM5nBQTIknQZv3WKY1lt6cdjNCDEzfp0hRA0yxevHc9Dzd7GFZrxKrb6?=
 =?us-ascii?Q?JVkscK5yWn8oSlYIA/gVwaDB70mrV6Xup7ZG23tl3laNDfjJZwjdO+wTgNXf?=
 =?us-ascii?Q?KmnVHha2DPcIE6Z5FndnloXN/IkWmWdS0+lD0VWQ8OVPIGcUwh2XqSo+aHFC?=
 =?us-ascii?Q?HLxb6/r2Bn/hPMLryX3i7cuQ7W1kxAOIwldvy+WhsayTjljkBam9G3cOgHdD?=
 =?us-ascii?Q?vpYeKlPohtdZywuxc4MHotErBdXDp2p4hOvvXDYZi+4JmAIKTRGhEg18fxYA?=
 =?us-ascii?Q?NQOSte2pojZtr2cX4lzQNkV+tFwM2PlxdWRbOf07fHvLK+krUfw0WQO+U3mv?=
 =?us-ascii?Q?N0If1KcQ/osatmnzyXkwJjOP1+fxyFnw3Y0HF+/IJKHWXrcqQUHBU2JctFe+?=
 =?us-ascii?Q?8lYz2lWlwxrqPn1Qnf28blpx+UJSzABD29t7HPDuZPmDRRIjNV2ZWl1QWNpl?=
 =?us-ascii?Q?jeaJLQzJQzqhEKjXYqxR2TVR8uIGvKulSa0XWw9T2qyApdNy99TTIZWs2Jl9?=
 =?us-ascii?Q?kcmoTtCCarDiaR2Y2QWkIoW/QPz728CyHqAGn3IVXqPnwWhQCsvEcuhDE6dv?=
 =?us-ascii?Q?bL3fMbzvdLiAf5VzYuVbJrfLJASbVH1/kdiCWmtwRhIFJYRhlZGAaJiBwnhj?=
 =?us-ascii?Q?OaqMiPjNU5jUOJvf9Mh2NSrp/e4v+pVyg5kRgFOJlvV5oGvWmgTKqzBwBOJx?=
 =?us-ascii?Q?x19XyBJXBeZ5D4eLK/fK8Kr2B6PcVDKxo5guFkdFsH57RF8ysIjkBIsIMrhy?=
 =?us-ascii?Q?5dsmUrI1hO/uwlohggDRbCeIZrWSTUzZEEui1ouFWhZtInoNDVrIkhoRy2b7?=
 =?us-ascii?Q?IixfYNVvzkZ8H0DzXj0sL17DPs5wKMf2v2EJ8h9ViRfu5CgQg1lAN2nZCCwo?=
 =?us-ascii?Q?I45rwr9cPZYdJSMdQIcqyw3aTEl1flW4JxLGDETLM1NrEs+4eQkUw44qW3o2?=
 =?us-ascii?Q?BnmkybgkcjVJTodv3b17mq9SA70BO5gDmF0J5NPJ+grIVbg/IE9kO5RlPZCV?=
 =?us-ascii?Q?SP7xcJVLn52fadZy/THvPqmFAU4y9MDj2CkQeI5e6B1CaaUlebRla2n6N14m?=
 =?us-ascii?Q?FGlGKkUhKxdpIJ0woSKUxTqlb/cwMx9ZFsaAo3oJLV4Tq8OZZ3p6LvEoM8Yo?=
 =?us-ascii?Q?RRTVH+wVqeZpCLjUDBW8gNUhLaUegGm6lKcRFCbO3z3S7M58F5ySeOO5/Ag8?=
 =?us-ascii?Q?r2sFYdPg5Ya/EfwgjS5mfDwWbXy19UEvXYdGp2UNVru5Lu01a4aVr1hYWg4U?=
 =?us-ascii?Q?K5TcQsptI9dDOzp6Ach93Aq6+SbwB+yMAHdamhv9KRorarFaC2YkN1fiu4DP?=
 =?us-ascii?Q?WQtz7KGVagqKWLB48LZ/nP8T+zvDutDQsn9toVv1uIymwJ9QgO8FtA/2U17r?=
 =?us-ascii?Q?goHmeoyJ1da/+XYlLFMTtYj+OIrAiaIFaclU6BMCYiDoa76NTVlNE6nf7iAM?=
 =?us-ascii?Q?TwIhFOcUn+BGb1OgdMMoXs0cOQnRUsQNtdbeOibLHy6KTK/wp4AiMvfJZnGj?=
 =?us-ascii?Q?HPrF4mvG44wyFezCRLs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60e585c-67ce-46b0-119b-08de01e22cf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 18:33:26.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQW9nPaR/IotUYIcKnNGlU3K/CUyGIa3MuNCPvhLn2gYMvftaHMeDsB8PWwMOR4o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8952
X-Stat-Signature: yaxju5b81a8m78bjng8nn4yc5wyaet9c
X-Rspamd-Queue-Id: BA43540010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759430009-66950
X-HE-Meta: U2FsdGVkX1/CKi/07zbuGqnbZmPtMubf6rhp+htPggyugZ/hcl+si1zCQZCMHpdlE/KfBBbFtWWrDHtPBAxog2xC/ikvPcp1IynplHc6L1iDWNSqAG02n4F3p3pbXXfHXXJ4SpNsgz3vDakh9Uvxp5qk34m2MahUhI1bSu0kV18lqVsnPD5YVOWe2GyyHzE7/7N2UY+OhiHiA2kInGygexAXwKy+7DW3b1LmmBKW2IlnlMFy1YQoiPeYpaTIkMEShF4/NLOtBN1ThN2FZ1KnRNztX+bPm9CuJeZkhzsDw6UzN25t6LgufO+GnOm1gwTdvsqJg+l3ppvhQMIn3SjCEbDWwXtxLXKaV/8q5EQFMBIgte5PFhpz8RutRE7uW/8vKi9v5FLQLqT0chrzq8j5LKAX/4k4O5NeggCCRuxXOw/jy8AdD3qc2mHKauHkyHjAYciRfJT0DTxIiLFTFwlOUkqL+fLXL6xuHWFVobV+KIlwJOjmhGfx2cpodcEw1CjBh2Yq5aPx4cHbHnk+DFEC4ypgu5d6p0WIhkGuGNpDVzKHY8Yv///QobYNxRzuBqWVoOzqkS/Ji36pclIAM/gxnfSA4fRpsZhJq1IsS/GDNfm+aZwhHSbNCErpCYzc4E+9IsEDhNQ+3jCIMens8TtcJ4d3HAQ48dMJcEA2rXCXWwZlE4DH4YhMYf+bN17z5tOw/ZRHI83Qj28bKdWNLnfJqljIBGPAIbIJR9dQ11VI7mJlcK2zkIj2b2jWjJgKYnTBQ1GPQpBUBij5lOT3HjTJDGJsV5yR5/en+Dtj+WW063gIFV0FhkTLvcpY1aaya55IisxjBMbMpgV1S/CSvfLuJZPy62L2bYFbzdAZ3y9j04ELfQ9JfBxdzpiqy33s2ZN/v0EXkbmkq5AOJG8JSv858JOuWl2UeW5WCSYH4C199RHesCWmhwPaNbKZfduLApIHK+LbJXW/0EmqvAuRN80
 YxPHxf6p
 kN6Xnww6XIBJUhM0+2jxxjhpeFO2JJT1vuEh6LsgKSuy3wdZidzvyv7s0TmCwGxvloNwyWWYlQfE06achMXDMAl+CgSQpcuMuPGaXoWL2b9NIFTF2UueRS5MuIyEhvmuTlNvLaaCrVVs4AgDofRTMG32DDrZb+H7gVJQJ0U3iFl1ln7hKEYm19om+95dkZ8d/xCILtexZGYJqjDw3+qMqnEFSq5VDyymX9jqVcriz5ZYYhR/CmZ2Intsa3hgfOZtvPed9hYT8ZwKuJ/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:

> On 10/1/2025 7:04 PM, Zi Yan wrote:
>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>
>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>
>>>> Hi, Zi Yan,
>>>>
>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot has tested the proposed patch but the reproducer is still tr=
iggering an issue:
>>>>> lost connection to test machine
>>>>>
>>>>>
>>>>>
>>>>> Tested on:
>>>>>
>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge_p=
age..
>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_pa=
ge_min_order-for-kernelci
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17ce96e=
2580000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D714d45b=
6135c308e
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea2f=
dab6ed46056
>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f9=
09b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>> userspace arch: arm64
>>>>>
>>>>> Note: no patches were applied.
>>>>>
>>>>
>>>
>>> Thank you for looking into this.
>>>
>>>> My hunch is that
>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-=
kernelci
>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev=
/nullb0 in
>>> Yes, it only has the first patch, which fails a split if it cannot be=

>>> split to the intended order (order-0 in this case).
>>>
>>>
>>>> the test case are probably with min_order > 0, therefore THP split f=
ails, as the console message show:
>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for=
 unsplit thp: Failed
>>>>
>>>> With lots of poisoned THP pages stuck in the page cache, OOM could t=
rigger too soon.
>>>
>>> That is my understanding too. Thanks for the confirmation.
>>>
>>>>
>>>> I think it's worth to try add the additional changes I suggested ear=
lier -
>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@or=
acle.com/
>>>>
>>>> So that in the madvise HWPOISON cases, large huge pages are splitted=
 to smaller huge pages, and most of them remain usable in the page cache.=

>>>
>>> Yep, I am going to incorporate your suggestion as the second patch an=
d make
>>> syzbot check it again.
>>
>>
>>

<snip>

>
> There is a bug here,
>
> 		if (try_to_split_thp_page(p, new_order, false) || new_order) {
> 			res =3D -EHWPOISON;
> 			kill_procs_now(p, pfn, flags, folio);  <---
>
> If try_to_split_thp_page() succeeded on min_order, 'folio' should be re=
taken:  folio =3D page_folio(page) before moving on to kill_procs_now().

#syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min_orde=
r_and_opt_memory_failure_v2-for-kernelci

Best Regards,
Yan, Zi


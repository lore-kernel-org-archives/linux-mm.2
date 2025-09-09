Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3AD1CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3068F8E0006; Mon,  8 Sep 2025 22:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6CD8E0001; Mon,  8 Sep 2025 22:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F4D8E0006; Mon,  8 Sep 2025 22:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 040B48E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:03:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 927FB16039A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:03:03 +0000 (UTC)
X-FDA: 83868063846.13.0BD874A
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 885734000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:03:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Oka6mwH7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757383380; a=rsa-sha256;
	cv=pass;
	b=1vJxe/yFTZllrlZRhUaRfryk5bMF6FmTa3MqnKpsHfiilfQIGZHqoDEw/HRXan0zALNfKe
	CZVWrVWXGyI9CvGSitazqFqCvyW3RwXTz8ZNkihqrIrIThm8l2rU76ywuiy0FoCn3kHfyf
	2msw0y4MJSIJ1eN29938Kq101qnjCP0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Oka6mwH7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757383380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY9MhfDo9xH6oXFA/VHHFHNEFa+ckNhd+RgpE7Xy2Yo=;
	b=dILW0xMBmKdTmHZQ4xOHAn6TH9BLN1tAf1/MniMsVAJlmfxTKZE7vY6ZBZUjkJ5kX8BbET
	KtND3Xg3diKopyLgGF5ZK3e8jRAIGkVh/vM4z3id8fyIc3LAaDaLdIGa/T1na/UlSb3Ak0
	9JkDseo9ZAavwPF6mA4SGxDKLs35NTg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pj0cRGYGx9cYqv8tX6aqZVSWzQs70mwIqhkBTMQW80Ol3RsKYSZOewNZ9jUuw7Wm+LhqCe8HA2f+uu9zEVe9uFkfHdei/+Dd9VUfD7lnTPuwMaluUT0V8oLbLxx0vfZr53wsT6mE9cYvSKTSDrvxOaNmMtkA0TMRUxswNaoh2qXa7A9NL0YI22QJ0GmlTbePDol0nX4UaZvujlNYrtDqbZqfZmd4V05atACS5MDCYxBEMoZtS2152RGju3kj+ZMFYl5UEKxIDoEN3sAtJt6iOxy5maIfMOF2X+7AksMUh3aw+Gq0eEIDUOFaf6C+q4SCiGX5S3Kjt+AwNSk0qtAvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY9MhfDo9xH6oXFA/VHHFHNEFa+ckNhd+RgpE7Xy2Yo=;
 b=VPibLAFlXnKpnSkL75B+Me+bugEylPH1JhZxz5/LrFnYHgWK6s2ifljHw/ksqfiYVHDz4Piqv5DAIrq8HhyzGA6kA5IQjLwDxntnAJtexL+YyvM6ZZir3JvWu5V5FlUZ6liaZsp2pLSVG5on//nRP21sQ08eMKnRFeZTsAzM6Kc5Od28YV2wCpCMdhfIReUujsanBvUzhJ6KHMh5YO/U1fSmTZosEBsu134wxR3PB3ak/OW1qs1DeJoIl45iPbu8dS0PAvnx2HVkaRb4FL3SgQD2Wh3+84X0OhSapg1hGHVtk+SQBFR6wxj37QsrVuXb42YBklBRvzz7rSuLGNemMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY9MhfDo9xH6oXFA/VHHFHNEFa+ckNhd+RgpE7Xy2Yo=;
 b=Oka6mwH7K/NHRK5X8bUTDEA8iLF69pz+o7+sSFAA8S9UF+bHbeIZ03QuwS/3MyJtAy5WsKdM3eTDqHIFQ9WwAd0lPttahLZiEXXNsOMf8PS5ZmKU35h1PJ9V/G+lOy/Lw8zL2XQcUoyGgC9gCcM9ZWpjQJtmyz+8kH0hWvaUMiKD2a1C4JpXKQktMA0RI3Hoq9lRMrRnqEju4ZiY0+dFRgnpsPDaDEk7Zb0r61A3dfaKVlOE2/kVOr4I/Jlp6hRE3B8p7Z14T4+Zow+ZIN/KcgSpot6F3E9JbnG2zE4EHi41LYSRE42EwiQvZSlnc9aSVVSC5C6zNwz1ACuQPOnEfw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 02:02:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 02:02:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 9/9] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
Date: Mon, 08 Sep 2025 22:02:53 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <FAA075C3-7C56-434A-BB23-973E947E8F24@nvidia.com>
In-Reply-To: <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: fef6879e-3259-489b-1fbf-08ddef44fdf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tQHf9cCZFVQVf8BGPSm1Ua5aEpqVT/1Z8kN+hyFuuOW96jHkCtFDXaB4UKz2?=
 =?us-ascii?Q?IxoZMl+e2vUcbXrAZpqRNWskYY6mM5B9E9B45v8jrLAzDqCGB3S7PoOGvfFD?=
 =?us-ascii?Q?fobiDHqcO9yw8iOc6e+Vh5Sdv1aneIaNX/ccM3P97BIH3s4rYcADw3cy7UY3?=
 =?us-ascii?Q?+oJKks4gUot/rtXxQr6+2jCdbLd446slrkNfIoQIU/iczV8+OSh1CzHw1nqn?=
 =?us-ascii?Q?B3HK/Azx0OVFX8jCsICiejpaxjOP5TMQAPt0bmdBSGeIbPWanGZXS9rQXk/f?=
 =?us-ascii?Q?Xh2xl1/e65QL4ec09N7RnNcJ/KUUUKbQ5jWeCnK3hXHSSyuee7+xHqIWRcU0?=
 =?us-ascii?Q?0GTP9vpEF4OGvvYJJeD3OxzLFHxdSbruh03QHUHRiN/df2diqmlKkWUd/YgE?=
 =?us-ascii?Q?36foo/4SG8jIAMjs5MImhejI+Okri2OPMRnwBa5uGip5leugrqmh1nDzvz2Q?=
 =?us-ascii?Q?HiwIO1DOVAh2hniQ7mY5AyhIWoTIuhIQT5n5OFGOR8+OXwnvU2yCHJGrt8wI?=
 =?us-ascii?Q?6gj8jhOWQ3cHXMNox9/zyRBEHAhDQRkGd41if6SlfSXfvsoXwBnREXm4ifSh?=
 =?us-ascii?Q?7vA8WfRyMAddLn2uXuT9Wad2JJFog508On6cJx+zksoJyhTMlL9NMR67YrLW?=
 =?us-ascii?Q?jSwyZ/PH+u0b1yOy7oDUB2HpK+Puu26l638O9mQ5ryxxjQc/q42NJ4CHVtIB?=
 =?us-ascii?Q?PjGfYlXjNSNY+uTCHtgSzFgOSpA2Qq1PPlx3AHU28NEsW7eVuIOCOdpHOmXM?=
 =?us-ascii?Q?UJqMMQJUwV6w6k6WdjZgAZm/RPyCBfti4PnDwA6O/sJ+MxUlRorjimBpynQY?=
 =?us-ascii?Q?OaBofPLSu8ek22IHNoO3k5LVakkrwQfSkED9VurrEVKxCIoiHcHeuJEJsquj?=
 =?us-ascii?Q?K3qVYVW23/arOlaK0TvFT7UGuE2Z24/JVCHHrYYtWXXppk7MjzjGnPcRuimT?=
 =?us-ascii?Q?MUeuYvMWAY9tigoDsM37dTV1PaNNlFb4oWV+AvHhlUMk0FR22Eu/DzsLwgRL?=
 =?us-ascii?Q?iQyWFrrZaIwP4heBA3DY4NlKQ3kFjTDIOJMSzbYr/NN41QZrEaoM0JEJ8+H1?=
 =?us-ascii?Q?AvSnc71eOHwBj5cYelfcflDMmL4yhXiQGXfmlRSpQ6jgwwKYQd3RoNVoY2JI?=
 =?us-ascii?Q?vXBBfvZb6UHdScNPoaiYN3fmpqq5bLH9tzlv2MAsOGnS6AzJRhfrTXJf+r8Q?=
 =?us-ascii?Q?gjMC2rdNepdtj3V9YHryZ3MHhPOmQ2n29EoxKlva/WG9M5twrFbedFDM6509?=
 =?us-ascii?Q?nuWGyTPeS+uf7om9AxGyI6zQuE8G7pwlYLlH7OAxB6oC1sCWq8eLkmOy9aLK?=
 =?us-ascii?Q?Cszntarhy5Rk29peKDU9mEBa36CkcPLi67pk6ob4un9SZxh0CNjbK0jpxc+m?=
 =?us-ascii?Q?WCnAnG26K6vTYuGQr7YfCm3utOsL3gXajqYs6icWpKLKfF6YBYc/gno+ScY4?=
 =?us-ascii?Q?jON42yFvQoA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mCZclmibVDhBt6KqWKbQx5BGc5v00LWvSxd3X3FpTzWwkI2fEilMOwDxy7uz?=
 =?us-ascii?Q?3yu4r9jMhhXjWvI9DYA4yJcDqfPYUQNIn+QvTUoZbxVVaZeV8tKW2Hu/hsrv?=
 =?us-ascii?Q?dEOZw0ADoI3E9pAuBuQZP7o/X0ogiLEAPgS40zaQPdp2w56AGbeD5s5cvoJy?=
 =?us-ascii?Q?I3CkC2iqqryyvVKEGV554nz2UgCPjxZj9LsTwVHjHpogGH09fltmCPfhjLHa?=
 =?us-ascii?Q?LgaJgKerrwmqBbMHwDpc+iY9loCxcQaEAPyTyVh0MtMVy4HWm8v1iCsfrtLk?=
 =?us-ascii?Q?7hcx9B++ST11Otmlyb51qOyErlnrvZ8BnR0bLM6W78Yj+Q3CHh2BRwC9uJ04?=
 =?us-ascii?Q?ZQHgtZjFsgG9UQi6K8thUrc65nuyqaLakPLJwRGZm3yaTcNj6laxyNLI4yQL?=
 =?us-ascii?Q?b4UNbbK9lTmzolp/Tz4StAvF+506P2l/SD6lbN3iZR9DBjf7o/uJfLI2OKiX?=
 =?us-ascii?Q?HP/faT5/7PZ1FoWc8hhR4/w7YgrOHQnlhSN5LDJgVRkyQTQWafwUYBEnm+KS?=
 =?us-ascii?Q?bhNg88ZBc9ApJ0UFYpme9w5J7Xf4am5kD5BChbA0Ffgivo4aWVwq5j8vbmZb?=
 =?us-ascii?Q?vaYvtM67IFkVaIYwOKFXbMvQdwvcKQVyYW13Ah5WdjvIsDVp45r/54JhzwVA?=
 =?us-ascii?Q?x38/ENSxnujwiq+j4OM5sLI7hrASdAq2DivvpyORYQYi8EpZI8GVK8dwXsY7?=
 =?us-ascii?Q?KeTyYW+IBElLOtrGYQyBSk9JFh/cnQ+sOTZJQg6yvKLtSfZ0utWEwf8/IDmW?=
 =?us-ascii?Q?v2Iw2hKeyWfXKIus54/Y73Fbn6m9zlcKspYyJbZ58qMuu4WkyV4fy/uj35nJ?=
 =?us-ascii?Q?GbgwEf0yWsH94ogmMzp3WbcSw0wfq5tZ1HE0OMo4iYCV0dEzGzn7qTsz7HP4?=
 =?us-ascii?Q?ujHQq48Op7TgubBAkf1oyLcwg/ZgtWedIoSMG7mlSU/ifqdOBDiQgaB5cyrq?=
 =?us-ascii?Q?0csa5bc7twhkPNWoBUao2RtObW7I3zULYop5+dnGGprjFba/BjItlZQkCulx?=
 =?us-ascii?Q?gTpw4AV0Mv+rgWcZP/+sPMCHkZ+zut7sqV11cNVWb2Vp3pf5FdpFHXfP9q+X?=
 =?us-ascii?Q?F/DNuHSumsCtLtBtjq+AUTNJecY46gG8Fnsz+2NEytmSYiDd+AyhF3vaLRLp?=
 =?us-ascii?Q?k7HKQliCPX4mVN6PDAYe/BsNahO4N+doEbIo3xHJzENIivARfb19SgKNUep6?=
 =?us-ascii?Q?DE6+nq1zmq1Ascs81iI9MNTAlNt+kO1/vkZvYDWYUYmcl5VRcaKyugXmyty4?=
 =?us-ascii?Q?VHZWlsRM9k/xYMdDdOmr135we1GLliXRHkg8EL+iQxNppBpuS3JwvpjiRXZf?=
 =?us-ascii?Q?3TPGOKgANeKwT9WVqvTIhmq9q2DGCwxeSuWVAjTnA0FEWwYVwgKIPRLX/FnQ?=
 =?us-ascii?Q?UGD3xlvgXISiK7gWEy566MMLLah45QKyt8ilK/Hxnj4fr6HbhuVjXbRsuVc0?=
 =?us-ascii?Q?GKT6m9i5pNNSKNnkX73uOAF+pq0l+uJ/k25Ov2b6euyc45WVyE3oW9p63igg?=
 =?us-ascii?Q?Vnk+t/aDxZVo1KYOeeet/so43W9gIGo9Y4Zn3bQC9/t6ocCLt/D1piafJgkc?=
 =?us-ascii?Q?/9ccPpdv2yoYln0eD4LxLmxBFLa9g96BMuA9WOX2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef6879e-3259-489b-1fbf-08ddef44fdf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 02:02:55.4936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MGcH9kFxw5u6izaW8aOQb6SWk4yK8KJsWtN3qSXAsSK6D1VwNG5xiwDNOdDHAIa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 885734000E
X-Stat-Signature: gzew3m1p1i8rtm7bpdsesmoyu8kb83ms
X-Rspam-User: 
X-HE-Tag: 1757383380-429404
X-HE-Meta: U2FsdGVkX1/yb3ZPOK9IXqqzSRXItXnC283xKD7x8ahGoaY4L5+tV96IFPDiPS07Y8umOWb7064fudRbrLWHy1GZfxz47SIXdRwqjigMWiZPXG3CBpEdEYoeZa243B7iHjhb7Y6jPpPxca/NW53LDppZOMgzAvMDp0/aW9Zulje2H++HMMF/xVnaUiTlb3Bd5gtjBxpJNjUWvoaZ18ogxcqxFvIQWY4aJWfkH1ZBO3XGpCMW3Ur0tuViu8ionGHVvoN5K0oaWDlYSxtm+Dr/sNjGp4fgiiqC6cswJ+io7Kl+n+pVBqrOpnl+L7TJMM/y+cOYhwsF5wOm6ABQptZqJJCqfVKVQ7XUV5N1aK9MiAI3j5QOfKm8aWKNUaROSN1ZquoDCB9v8WwASlKKwjekVSHazaSlfjarM6w1yD20AuUDhoDoCsaVH/UYcsCSrGALEaluKiOsTn5lnmSIQjNmdqL2q32f7/AAU6BCj4Vmn7MGa9YW8zQ3zSiRkjVPhF94j/4aNpMbfebnlLQJT6IcXRPne57J0RM9HDWK5ZtF+FiqG4+VqkCAQhq5pwbNEif6ON7tbHu8TOq8O46xcDez1Yt7qI25Cvt86yqrWOt0Th/V4etn+POdrXQtKVDXmE7F4eblErg7ynhH7aXkpfjO1IveEFQPO/vKn9iETjbtXvenySfaJbgqc2voAQqzm4fhIxLv5pttEBscQQ2pWd6mz/Y94QVq6C0/GExKJJlfH4rnEUrqWcDlQdBslefzQG7XMWF1G8GBR48dqPTMn5lO/S/XOVCjmHPIjuNXacTSwzgyL/jEGWBKlprYWmB1dvI1uNHLjBpa7E6r6w+l3tMTNuMnUA2P8lGfRBZXpdfU0/YdgJwdMEyBEtr7Ix/TDRFSSpqOn+UeU3D8053baYf0us7k+Lwza4Y8kN9AEdP6sni2cgzjZajJLhU5p6jBh5M3+dorG52pIDjoqeyZmve
 PdUlcLVd
 wfryDyWGvzFEwoj7qTDBQMUt9107yVbkm8+/mC/J5tr6aVZ0fY8d3wJy1tSgtuF0H6j8LGViZQ8lEciQZ5tvlovRy1gi7d5lsYo2WsIlGAbHOEZsQVRrUNlKfiU91Miw2odVoa2Koy5mhkgxBrSGiRkVQMaXj4/qGSqWF0AuXV+OX9rdnTFOisgTuMxhxm/s4+dxXEhdcw5yf8SgUerGYmSDxOTvfoqnMfm5+g5djkWWyn4Emu5UuG3Z/lhc6LlUwt9hOQHzOkL1P5W9MZglC2QBRSzhCyUSBVEHD3wf35MEkicrJqJMVjmewDvLXvDE4odRiBEus4TiwDMe8Pz5Z0XtPOHz86/JQGJLxFaCpOMkT/fzYcVvb0VZbhkKqp4+3enH9WAqj5XPxGvhgqBi/A7UggaMd9E6HZ0RiYFQ9vc6SZwPVVuRXdOj6qpOtquhVFf4RrQX65cb5lh+6Z4OKUjEFbsIvBD5NmIkrBwgKe6tIjWdlwlfICpxHhfhEwBFpo6qtMWSDfwwG0mVHN/6Z62n/rS3vgZWGyhysX8Jsfa3XoWznxiJsLtTnDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> The alloc_gigantic_folio() will allocate a folio by alloc_contig_range(=
)

s/will allocate/allocates, since you are describing an existing behavior.=

It confused me when I look at the code change.

> with refcount increated and then freeze it, convert to allocate a froze=
n
> folio directly to remove the atomic operation about folio refcount, als=
o
> saving atomic operation during __update_and_free_hugetlb_folio too.
>
> Rename some functions to make them more self-explanatory,
>
>   folio_alloc_gigantic		-> folio_alloc_frozen_gigantic
>   cma_alloc/free_folio		-> cma_alloc/free_frozen_folio

s/cma_alloc/cma_alloc_folio, s/cma_alloc/cma_alloc_frozen_folio.
If you do not want to type folio multiple times,

{cma_alloc,free}_folio -> {cma_alloc,free}_frozen_folio would be
less confusing.

>   hugetlb_cma_alloc/free_folio	-> hugetlb_cma_alloc/free_frozen_folio

ditto.

>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/cma.h |  8 ++++----
>  include/linux/gfp.h | 14 ++++++-------
>  mm/cma.c            | 22 +++++++++++++-------
>  mm/hugetlb.c        | 50 +++++++++------------------------------------=

>  mm/hugetlb_cma.c    | 13 ++++++------
>  mm/hugetlb_cma.h    | 10 ++++-----
>  6 files changed, 47 insertions(+), 70 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index e5745d2aec55..cceec7b25bae 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -57,16 +57,16 @@ extern bool cma_intersects(struct cma *cma, unsigne=
d long start, unsigned long e
>  extern void cma_reserve_pages_on_error(struct cma *cma);
>
>  #ifdef CONFIG_CMA
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
> -bool cma_free_folio(struct cma *cma, const struct folio *folio);
> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t=
 gfp);
> +bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)=
;
>  bool cma_validate_zones(struct cma *cma);
>  #else
> -static inline struct folio *cma_alloc_folio(struct cma *cma, int order=
, gfp_t gfp)
> +static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, in=
t order, gfp_t gfp)
>  {
>  	return NULL;
>  }
>
> -static inline bool cma_free_folio(struct cma *cma, const struct folio =
*folio)
> +static inline bool cma_free_frozen_folio(struct cma *cma, const struct=
 folio *folio)
>  {
>  	return false;
>  }
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index d0047b85fe34..ceda042be704 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -447,26 +447,26 @@ struct page *alloc_contig_frozen_pages_noprof(uns=
igned long nr_pages,
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>
>  #ifdef CONFIG_CONTIG_ALLOC
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp=
_t gfp,
> -							int nid, nodemask_t *node)
> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int ord=
er,
> +		gfp_t gfp, int nid, nodemask_t *node)
>  {
>  	struct page *page;
>
>  	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
>  		return NULL;
>
> -	page =3D alloc_contig_pages_noprof(1 << order, gfp, nid, node);
> +	page =3D alloc_contig_frozen_pages_noprof(1 << order, gfp, nid, node)=
;
>
>  	return page ? page_folio(page) : NULL;
>  }
>  #else
> -static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp=
_t gfp,
> -							int nid, nodemask_t *node)
> +static inline struct folio *folio_alloc_frozen_gigantic_noprof(int ord=
er,
> +		gfp_t gfp, int nid, nodemask_t *node)
>  {
>  	return NULL;
>  }
>  #endif
> -/* This should be paired with folio_put() rather than free_contig_rang=
e(). */
> -#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_nop=
rof(__VA_ARGS__))
> +/* This must be paired with free_frozen_pages() rather than free_conti=
g_range(). */
> +#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_froze=
n_gigantic_noprof(__VA_ARGS__))
>
>  #endif /* __LINUX_GFP_H */
> diff --git a/mm/cma.c b/mm/cma.c
> index b4413e382d5d..49d53879c1d0 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -924,20 +924,21 @@ struct page *cma_alloc(struct cma *cma, unsigned =
long count,
>  			   ACR_FLAGS_CMA);
>  }
>
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
> +struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t=
 gfp)
>  {
>  	struct page *page;
>
>  	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
>  		return NULL;
>
> -	page =3D __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
> +	page =3D __cma_alloc(cma, 1 << order, order, gfp,
> +			   ACR_FLAGS_CMA | ACR_FLAGS_FROZEN);
>
>  	return page ? page_folio(page) : NULL;
>  }
>
>  static bool __cma_release(struct cma *cma, const struct page *pages,
> -			  unsigned long count)
> +			  unsigned long count, bool frozen_page)
>  {
>  	unsigned long pfn, end;
>  	int r;
> @@ -960,7 +961,14 @@ static bool __cma_release(struct cma *cma, const s=
truct page *pages,
>  	if (r =3D=3D cma->nranges)
>  		return false;
>
> -	free_contig_range(pfn, count);
> +	if (frozen_page) {
> +		struct page *head_page =3D compound_head((struct page *)pages);

A WARN_ONCE refcount check might be helpful, since there are two
cases here.

> +
> +		free_frozen_pages(head_page, compound_order(head_page));
> +	} else {
> +		free_contig_range(pfn, count);
> +	}
> +

Best Regards,
Yan, Zi


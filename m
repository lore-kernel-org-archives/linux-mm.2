Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1A0CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2783C8E0003; Mon,  8 Sep 2025 21:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228F08E0002; Mon,  8 Sep 2025 21:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13ECE8E0003; Mon,  8 Sep 2025 21:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 073608E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:16:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9572583CA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:16:30 +0000 (UTC)
X-FDA: 83867946540.10.E834809
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2AD2E10000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:16:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TEesMDs5;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757380588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35XPJN+Fo+7aerWl7gafeSXOOd9f4kev36W59DY7Kjs=;
	b=OwjA1TFxE/S9EpbozsMT0CDSnIVLPXFvOfAZnFaEw28ET7dQnAeGkvyXhx9tJg1Jq2JYno
	2dfeCwXQTvZhQ38GE6VOIHLIPf2uhxdkCIoSbzYJ7KSK/pEqKvStWEg+hdkaI2GO7t4VvM
	iaRcKOGoyg9enqUin6yWfjviCknsD+8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TEesMDs5;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757380588; a=rsa-sha256;
	cv=pass;
	b=tFQraPFdfOSbMryoYOVeLqimc04QGHwtI8+mThjq4+rvPzXJgwv2XgW82IMfZxO76f0uz8
	5VUXhmCGBMjF+DE0l5ApqEXz+1kmqZbBgNyCjHLlsXRWLSromPg6j/7yvzBIxLwKTtbaw0
	RUDEd7eIZ0ewoeoX4jsgICcOv+5zXTA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKNoovRIGX11rnUejFT4y+T6gvrcZb9KWNd7+mx38DZovzqiGlFPYhTABkZcATLDIRnTQM+mHaPFrWaBuBbu/HOp22gy2C7syGJMS1OmIGROMxhWS2MWARR5B4x107RfiLAj1TW7DNeS+BSu32L8XrfH7rRQge1mKY3+LFHuXFT7oMnOR9SnWmpqgATETlsHbkFp3jLaqXeE0xbCLbhY67qGip5vgDtfpjRqYWNu9/nPNISNo3B37jYC1B70HxjJ867xbPA4EXlddBepvAMGiVTT5KNIbtvpmdbkmM0JITkvTQZ0CclE7G9C4E0qcrxCQJbrLmidcBWIvOu9Nei5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35XPJN+Fo+7aerWl7gafeSXOOd9f4kev36W59DY7Kjs=;
 b=CRaxyGqmIRB0QmheIwFvjXR95pWA6y3KePIxb6CHCcEKQQeXKYS7yRh2HZkmUyyNICvHtqHQGsYNRveSAHBwtNl3SpWRvnKelorHo4KGKk4KtYzYtjzbs3qcWX64z97Yib7+G6uItObGa6FVGrlA7kbJY8fbK1fjBgHB/AHBwf1s2IcT8A2KZmkF5u5J7LzvCDfDDC6T0EROGJZ32FfDU/MAvZkmz6YCJLsFJ0I0+n7Edm9xxUsWS0rznup7qQ0ipealkug9DlpqtDrUIlsYvt6uW8H7VrNHaBYTC5dvJNJ1aFRZTqoTZPqRJrR/SGeHlINKljmuPKYBUFkocDOeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35XPJN+Fo+7aerWl7gafeSXOOd9f4kev36W59DY7Kjs=;
 b=TEesMDs5xSwWpYU1YQzyv73yIzsW7sB6mGPHvZqBmBGMDqm0yzx2ZJtLHxA6qD2tQzx5TrkqOiHSVIB1H3gXr0Sq6ikPrA3mZV1/aJliZ+6Nzl0O7lhKKzGsuq0AgapPNAuDzcdOvomBwADw6qDJ6EQw/21aEIzqPGvXgNLTAj2Nhfw8fRKEbvPyutdIXbxsVrGNeyZCDV5S0J5O+nOnvL2G8Pd/10qbhvGdU6lGqRpmgvW3VcBkCYMA5FUfj8Ikp5fC8mT4xWZQwZlyOrR1D3dlW7F5Lq5DTRv4c/zBdli7NCuYJrnTnpB1BABby3MAKBnFM4Ngo9onHfXGs1oSHQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 01:16:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 01:16:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 5/9] mm: hugeltb: check NUMA_NO_NODE in
 only_alloc_fresh_hugetlb_folio()
Date: Mon, 08 Sep 2025 21:16:22 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5D61BA09-E4FB-4910-9D88-219C048DD9FB@nvidia.com>
In-Reply-To: <20250902124820.3081488-6-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BN1PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:408:e1::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ffa1040-edab-4ae7-a5be-08ddef3e7e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fF2YXz33f7CsT/JDD8psH4UAR7wFVN6L+Ri5++Oqo19l/21NoW069QPiGv41?=
 =?us-ascii?Q?91Zgy6hRy3bAX28j2hLUjrdqsGYj8aFqCWVhSBVeeFWZ3kSmdxXoIsm/wyPZ?=
 =?us-ascii?Q?t/8Jp9oSmzppYwnxw5MS3HbvG671rCAHgUDr/nemV7Bzuf0AGj6y/FwEpykg?=
 =?us-ascii?Q?sDZEzp0cMV1ozva7uI3x+hDirtZ7zJ0hDEUeAkSMjohwzLuGiVvyEbiodo9w?=
 =?us-ascii?Q?R5jSE0nK468vZQ+CCF9mj0WisOSR4X5s7GW2kl1TyIFkuakXG0PvMKQlli6f?=
 =?us-ascii?Q?Z/8sPCx4RkUtr0WsGdrRv8ijAFhGj9rkcxdXk0AOaBrQ90udAUfsP+U18Fas?=
 =?us-ascii?Q?rG6yZWY2VyQEGKbB5Y3GyBo9smGBEkXPl6UPxZEWtZK3/g9tc5kC/Ve5Upa9?=
 =?us-ascii?Q?k00Ud+N08a7Hv8RMZbVAG/6jTR46xAKTyRnjq3O41LuD3eP1imrlxgSTIeNM?=
 =?us-ascii?Q?GOoQYpJfAOh+5+Gf70bXY17FMecw0u5v2vB+QNevKKWXf5hPi8KG0ox8Gq9y?=
 =?us-ascii?Q?BoI3E9PCpX4teAQEgnxM+0uMFlH0QDNYr8I0lLPLXb0P7di0tcvFMI+Douno?=
 =?us-ascii?Q?MgH+0LjCgLGz6+KY4aJee1sO9dkNp8ANP8iOQelm5Xf8NiFuCCobCHzymvze?=
 =?us-ascii?Q?+4B2n+2rJxeft/lxP5++3YnrqGDbzJu5/OfFyqCwlHgT7x3UXUNa6jw2tNEh?=
 =?us-ascii?Q?MW57Xim+DJAmEN/ZcpK24zo/W6MJNbMe55BlXiGDIpLkEU9x3y0K3DCeDioC?=
 =?us-ascii?Q?c1Xh+TLwPb45qEB32OpARghvDrwtzYaIJPZp68NU0B3U6fH6oLbsyC20tD8x?=
 =?us-ascii?Q?YKGVPYra5onAS0YZpLOv/yBXpNrIpdgBCVO0AMiFX09+z4yq2tY5p9RXeMUp?=
 =?us-ascii?Q?NtZuWzJodqKFTCtKN+vgE+BFE7B94nsNLcQ+BZbBcKnDq3H1hsPKNIZCBOfY?=
 =?us-ascii?Q?Inp0jveGwQC5dMN7lYcryWpUipbNZMHwQdXVDWcNMZ2eb3Kt1sACi6qhcinz?=
 =?us-ascii?Q?EXkJgQDUK7h4R8xnHiIh+zWWNsHtRgU4GLxKTf3PiTWz6+fkorsx8MpnniZ/?=
 =?us-ascii?Q?YNCAVRrI3uZ39riiHO1KAMnMU3MiWgbGmhqAMxptZKyxVEzAOAuCDu4uFLck?=
 =?us-ascii?Q?p1xUeOBPc+O8U4YEVlYbXSfgKjjKS14L1XrqFT2teyzpJovKsUpkph7avJmk?=
 =?us-ascii?Q?1XzCNdLPgLtfP8XqzTkVO150HRFJVK8XzBlsE8x/aimwM8H1v9Ae5dbLwpam?=
 =?us-ascii?Q?r5xEt6XAOkWgN74PdRbYh6SDQSfp5ZOkPG+MOvoTYFGyMNlyfT+FA0INDS8l?=
 =?us-ascii?Q?RtrINLLNTJIwc+OrDMDLyIhjw8Mtz99XBoJbn0qTn8tpXI+5640VFnF3yP4x?=
 =?us-ascii?Q?5vZvzG7WZqwuWPBcSkZkrYkwQzPg8tUaepBJgyEMMqIVZer2U3p6+9PDGlzd?=
 =?us-ascii?Q?JjkzdBXqn48=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jWLIIvlAMbNn1C3lMtjGoDpJY1ysuxdZj8YuSWHc0Li3vyjC4uqM9qZ+C3Xv?=
 =?us-ascii?Q?91bQbN84RU8uL7lc6dk6vS9rchMT9IdKFhGPCQvVUHpzgPFsFgzOoJKnjlo4?=
 =?us-ascii?Q?Js94xPpIY3SMlr0M8PbVGVYlTTkGiiI7GkGP2cYEHQz/xz00Ipql/n3VXinS?=
 =?us-ascii?Q?iTDqGJmIZ+vNmttoje4uEGTe0HY1WZ/2B1bkpo54+ATVjtICCntZtmYxqMjN?=
 =?us-ascii?Q?xfXbDCxpxsVohM1/BoH+IfSSh54KaKASXI1oWOUHnlXdC4lMDqKuLFxzzSOC?=
 =?us-ascii?Q?QCgCbi6HsNuudFr4EShjpLXt7TQ+NhkgBjgLrKjM3FPQnM4Ua398tQTb5lud?=
 =?us-ascii?Q?TyiAcqKGWRfC6A9/ze2LaYks9w1BZit7JPxMeep2j9Y50IrRgEpLcZcMQIVQ?=
 =?us-ascii?Q?0CLN6MQGJ3HZt7efszf/VtfoTYP8xfF2aoAt+0+cjUbbAAKLHZNbNpWnNbN5?=
 =?us-ascii?Q?Z4OnKck4PoeibG6gFky0q/i6UcDaZ8Oj5sGLecYd/KsrHpHS1IKm5DLuFdyW?=
 =?us-ascii?Q?+n3EM5TJYj3DwnAkCCkDMNyZnDPzfzXa1JqktDFNOji7ndLILQlmhZKCeYsR?=
 =?us-ascii?Q?35G1gSsRL1N60V4Pcj4+gF1PKxKp6hYEkk2S+392RMthS+OasAyCHYSlyqbj?=
 =?us-ascii?Q?LFMDhYyUNCoaPdA6Xx/BpEct4U9DktoFWrQzdJdp1ecwCYUmef7U7w0bmdD9?=
 =?us-ascii?Q?oNm8EAUkVqIsmlVEd9oZIy0LYxwiKqrmc0iTrD46C7qIokdFcmCrvXLl7K5g?=
 =?us-ascii?Q?3gHbCBqlihhHsbsvR+qeBUgS4EmbuwSSc64TSQZSipPi+UfP0v98fSUuKIw/?=
 =?us-ascii?Q?wEaQlGDz9S7R3D6KAen/bSQ0TEcr8xBgl4xHe407xOMJkSl4oVqd7Xyq3iDi?=
 =?us-ascii?Q?uwn3/w3vXDzC3TAax/JRKyuCykmnAoeYdFopugLGV6dJD1m3L50CKTvh+Tbn?=
 =?us-ascii?Q?QaEOgZIwsEZ7QCTcI56rzsA/4JlVVN6H1oEpONyuv+n4CzXvoiEaAJgmYxK1?=
 =?us-ascii?Q?pHomImYn9DwCxBPh2QcHt1dwzeXyY7Jfj+OTmsw6kMrKEopJwE6aShH0z4cx?=
 =?us-ascii?Q?1kyzxUoEBu4gE3iSNRasQ3M5o2gC7NspwIWyUHAw0K29dz8SLAVv+XPeEgYu?=
 =?us-ascii?Q?e/uzBEpLOGLR+Z8HVxb8bNPBkmRjsI/kTRbd4kzOxXJlF8nvyR4sJUnwpAkR?=
 =?us-ascii?Q?3+ELysbJaLBwXSubCVlwLBtUrWknSy1smcbrSGg5k/H9nsq9CIg/SSh5OPHO?=
 =?us-ascii?Q?mupfEn0EVJAbAV0Vv3CN2zo4NBcOAc9R9oEv1oph2FKQX5iN73G0NUSiIh1V?=
 =?us-ascii?Q?wlbfkpy/Un8yMuA43vX1wV1jzO/l3crl8tj88lFjIDFBNEa0C7Zpc/mOpOhk?=
 =?us-ascii?Q?0b1xdEixUiXK9IFjW5J40tOB4RqrNVvjE4mXR09CKACrpt4tk7ZGB/yRpiPg?=
 =?us-ascii?Q?NE5dULvtAXarcKcOsvDZFu6JXjePl8i1pMsjWHb/x2ClbKWDBhXFC5VeJVhj?=
 =?us-ascii?Q?txsla3K4N6gtJrlldpGTcMeezrHDeR+12GRuKpErlonXA/eCyQ3EoRBQv7nW?=
 =?us-ascii?Q?yZYw7xEHGRIYPulcXVLuVSb9PcofFiqb2ULGW75a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ffa1040-edab-4ae7-a5be-08ddef3e7e9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 01:16:24.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtMtKh5wI05DdV8FraJXPrLFWZFGtJFB4wU+fpMD1/dFMj3Po5+FWjxg3vfywOhP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Rspamd-Queue-Id: 2AD2E10000E
X-Stat-Signature: z9mm6jeiyiunr9u8yx9te8ewweet4duz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757380587-25546
X-HE-Meta: U2FsdGVkX1+LQe1lFCRBXuRyJO4rCtYIhV6oJnYodp5pSRgTFyoDrLo1THZ1oJJkDrjZP9Y+7nngXCPlzNh8L6eWGhKJtJNpVZ0c66m34gPAr/fEVVC6ZzPiqERKcHea3LyjGgHoTVK2jP+ynE4kXjpBYZRAOyUodL3ExuVHpgJd9I2S+z4xb3rwXmiFY8N33pgIBWW8TDaojjmey7SStz7pF3/nBb2AyHMj2poshPshT+upvjCo66390dsAV8lMy3t9vpXIWMHQXOzSGJ47IN8QksVgSzewor0R3OLQtims+byEwqH4X1YQQiCEJzFc18SeykKVWfwz0aWT6toU3aDWKxzCx2MCu7HFlyDB5+BFea+yfYnRS4tQNTolXCXItrEyvRgjWIQ6oSIo550VfaJ9/T88XjfPy+ZKI8Y0fsAZS62l3wt0rUC75E0PBcJXxLf10/motBUNNVQGgC8H/ksJk7GPm5qdhkzLoagrMmlKwXsStiexL9o8Ub62lJdARJ5JnoXZ+vnep7YQZSf8vtTCjpYrXtCYJRIOKlqvXq7iN4+fkJvix21OM8puq/bSN8/VyoACng8K9p6WS9EWFboE2F9d+4+SxVMe73z8Pi09+xLhw7/mxD+KikA3bhpjJUFWmQabjcA2QetURFREmVZY+c1eMGs900g1dul+bEF1Jho6QWo+w2lxZz+C5aea6yFMfDxVyZN0nZQnvJNQ4IYDIjNNnD1wt1GV0az5F8cIXFqiDSvAqJvr8HzbAgSzkZXeQyzXleJI2AwAztlmJRQYVCttG32f1ytDWpF5RdNFLMJjKdSnw2CcnpoXTjZzvInfsR1IZtgbUDvAuqx89wSPmJ18XbrQhlX4BRtFA8Y+CleiZAvjGQH5I6f2+MLjIIn9aq8Lk33PtzUpjT6MLBcjUQrRabj+c5JAX0kkR86ozlrP3KeX9Nwirc4WlNKN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
> to cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid'
> to node_isset() in alloc_buddy_hugetlb_folio().
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A61D2FEDF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF916B0005; Tue, 27 Jan 2026 16:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C994E6B0089; Tue, 27 Jan 2026 16:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54026B008A; Tue, 27 Jan 2026 16:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1F016B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:01:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25A9016026B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:01:29 +0000 (UTC)
X-FDA: 84378964698.30.95B3583
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A4E54000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:01:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uVqayyQG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769547686; a=rsa-sha256;
	cv=pass;
	b=jlQHcpW2BLDNvmkQbiJuWLxihkQ0DlokrjNw/y5JMacVxhG6SoEGLTfXWAcljC5WidJCp+
	KLTkVvGmbnYHn4vST/9/0obbES0KPvMorzTh5zhmxzIkWcybAA26rwt9EQKE1hpftIz9Y7
	bRCzoADENbTHNc3OE/8Z1/zaOAOMFmQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uVqayyQG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769547686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaqI3OwIeMouuLobv5DJAeXMC69tZTqxpB+l9u8X3P8=;
	b=vSIBcKjfNw9vbkom0Vq2qosUdTyBBcs/Y00ah+ZyYkPnmx+IqxFEKDZojE3heGaThsG51q
	FxB+3iZCDf+bUtGA0WctNO7dWrr1FnSTxDU1STtvmiiwGbr4uT3ExSlP8uLt4zIFlnu5IB
	qGou5zyYb5DyOa2r9VxPnlP5IfO8O3U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ln6xSEP6txzkCu/A5AYuCYlZvT+ErIx/AkF27ThdbLl+yeaiDulzYmCLrt6TJBPmJDpdvrhCdCDKIv5op68GnTYuWGTj/3djLDrVwkwSZuGVLod2sPWbTAohntg69G40lVoFm84P1m0ftIRz/N6xnX/pUJ5jCxTx84jz1g0rge4U91F46Xj9sI6PVoPU9XVJ6xOfdknlvP5mgT2V9MPP5lc1pJ6UCZoxvw/o7bagsG6DiKFMjUIjsvj5dTw40Vp/ZM82CUIClRA3ARaFcE+X8vKHNEZXbcGgsmX+Ed3j31SJ/bo07ip7D/OXa5/YeAzirPgGQv5AlX/inLY1yFVEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaqI3OwIeMouuLobv5DJAeXMC69tZTqxpB+l9u8X3P8=;
 b=t8tAbSqAP12TkJ0VmIJP/9KLkhE2aBCOT8cfzsQfSrUk7OE2AlHibNs65zmOi35pmyh4RA0feAZPUKT7xaDJFjXzz527NJDrPxxEnaK5+XkiNbHLYh+oyzv0EXP+lNz2zyDaL8TF5gK8jiJdjweiZmLvcTK04dDssQzgh8m2icDW2gwB2kQ8MEpaZ+iX3ctT6uoX3QqpuMMw4mmghTx4DStKjZw5Qcm0JaVueIF5VAxbhqfSZHXIJlcSS/zEwSBI4quOVoz3MWOcgv1lvnrmBo1zTGCeHQwBal+h+otshC6FERgO22zLEFPmeAGVhUoUxlkUge8o8LrePqzDpQfy+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaqI3OwIeMouuLobv5DJAeXMC69tZTqxpB+l9u8X3P8=;
 b=uVqayyQGJ70Bznw2I5YiA8ViVHXsm/EAgoopPZW287UGLEzFt9ywGCSBY2kfONjzf9PXB3jzXWt+u3sR54WxhaO+OjNkVgyiOu2aZSBazF4NZdtmG+Rc6DbXmhLSCpay9EF/e8OHB/iVVZamrQvSBGkYrgro8RxhBTtIr5tG7BUyLqxdZ/HWpc/1O518Syuj/EP6xdBS0Bfj56OyAWLnwf0clcgqyG3IeiYPhu0nC+1p4AHUcbqvg1vhna0hlsqZ1Aty2CovMEnXT+UwoNe5gePsk48yTiFNzWLPbFrMtJAzx2r1ZOKILxFtfFj+l2x+WJSDDL8ojsbNpCXLck1eDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5806.namprd12.prod.outlook.com (2603:10b6:510:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 21:01:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 21:01:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com
Subject: Re: [PATCH v3 05/13] mm/page_vma_mapped: Add flag to
 page_vma_mapped_walk::flags to track device private pages
Date: Tue, 27 Jan 2026 16:01:15 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7AEEAEF2-5876-4EF4-B79C-D95E4E637A89@nvidia.com>
In-Reply-To: <20260123062309.23090-6-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
 <20260123062309.23090-6-jniethe@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ae36ba-40a8-4f37-526a-08de5de7392c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EKBBYPJR1IsNI9gMqWPlRvgZQPLLo0MFb4ez7CtfX0vKus64UhWgVNRUrU40?=
 =?us-ascii?Q?nbqXJTMk0Cq6u5DdJWqcBX9Mmm/RXdDbcYEHLa2cwMFjjNeNKsTw1KkOxXhm?=
 =?us-ascii?Q?F4kWJvWrwTaM/B++eK+aj4rCPYK8n2MG9NlCMetnByvNSLE0SEOKG8IHVVId?=
 =?us-ascii?Q?szJ1an7RmaT74X90IMoYz0gKIkjT7G1MqtI3t5VdaEpXHm4qCCpsF/M39cvL?=
 =?us-ascii?Q?sBRtGJpXwdssBa/p1Fxuc1VsNOEfC35OAeVo7EFJYuWNYFxYd5uOv3Dsl4eR?=
 =?us-ascii?Q?I7IYD73jTLACJEfl6TmH1FWAxs8F7Jl5HnRc8IIEp78WDh+efLPkuGIO5FLf?=
 =?us-ascii?Q?qFy1U9zt3XmiuylsdhE29UKQdSu/xZZZH16LvlhwudafnoTjKXycTUtqWcLf?=
 =?us-ascii?Q?53u/SyLFR5CvoHnbIB+U6Y4vWVqOK4Dd1ftHDQC8g9WcOE+wdFa+yA6jLNr6?=
 =?us-ascii?Q?6nG6uy2+0CD6C8a1K3y/suZjqPKVm+bc19cZkrhEH2KpL8rtQnvRtzVBoqoS?=
 =?us-ascii?Q?DYG7u41+CflbADSArTPJywL92Z8HjErNB05ZWhNnpkgI17fpMP69bW9IBzDb?=
 =?us-ascii?Q?j8dqTqlCcOVD5beWH5t22k0eYM57bPY/brnB3mpaR0IUxuz/rOB5ymlBhvB1?=
 =?us-ascii?Q?6hBTC5TwIPuoxsfFnl4klLL187aHYJbiiummp/kDWUL6piwb3CjQjoUoCSqB?=
 =?us-ascii?Q?kXJra3rAEVKbHeMg4zDZ26Vj/4MjJ82KcEs911mzipfPMMPYpNPjiijGvJas?=
 =?us-ascii?Q?oqUKetCzXOZHVunRsy2KNWRxJn70pOTUVSGgWJUzYM/0k3Ya4cZuxv2+3CF9?=
 =?us-ascii?Q?hipEb4rr3TDwdDCT+x7XqSNGV6YKtPCDCSyM4NWsvfKQqE78cTzRnhiMpvD6?=
 =?us-ascii?Q?vmeuiOVAhrrjmMVXrqKe/MQAR+l3XNALcS5lIhjAqT6zqGIzFggtd9K2ZAMi?=
 =?us-ascii?Q?lNaHYHqUCJfJYAcmbzNtZhJxhpnv1F/eW7qMY5qUbinhCjzdwMk6W0qBMMwf?=
 =?us-ascii?Q?SffOJVGI0SfvnYsR3Y5RVuupStszEimU9mhWibTrdppIR8RY4NYRksDHW9am?=
 =?us-ascii?Q?bgBGTcwhxkSQrG8VtYz22u8g0A61NIk8g71q9SyHvUjlFd+mjR0D6eSeAwUj?=
 =?us-ascii?Q?eBnQdBbj69Vp7cgpG6AeNHUX2pjOFBTuenisQDXINXjdJt2npCwtHM8beh0N?=
 =?us-ascii?Q?xEnZZzKbzCVTG4+5wuCddKDRcCARC9MvWLGf6ryh/vkYdkxq+WByDLTcQE00?=
 =?us-ascii?Q?p6X7jw14ilg+DswqI0GgI+CE5zY1eern9fqOx2stXionA6I6pWZCdIknzXMt?=
 =?us-ascii?Q?k7BqKv5nE0JZIxIQcg+ycWNtBuogwxgDW652PHVo8r2w7zmGuYNY6MvpS+Qr?=
 =?us-ascii?Q?SRmVOnOj8aiW1INSFT+Ox4/g4LOl81IpPQ7meLeENPJaF7lnzDm+zWAl7vz4?=
 =?us-ascii?Q?teaeLD8Kx11LOsweg0deQhCt2PrMf1Y+3M45dzuppZvrLMhRpK46jmAUNH9b?=
 =?us-ascii?Q?y8qu9hp3RoqoRSxKhRC1NE6pKv7/KpQqruOxCzDYxPut7ZqmVxhp7fTWeWSu?=
 =?us-ascii?Q?+Aq7EZyNSsBSlUfyTiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QIpyNnjINwQsIv455BZiYa8utrEZ6+diqEIIGtYiUwB+qACtnQRGz5qm6R6m?=
 =?us-ascii?Q?jKXpgDoWbDYzexEnyFdC6BliwR9WnGjyiEnKljAaBuQkSfTqwl976VKhQj/L?=
 =?us-ascii?Q?64zMH2TIeQhln3UNHJn/bKdWaPwuKwsAwHvJlySQ01HXKP5xloIKKv70+PGf?=
 =?us-ascii?Q?kxBoq51twdZx8br0/zZsBcUg5xiAcAMbkH/EGvfi3E4+Jm0vBZJW/uBGV4/n?=
 =?us-ascii?Q?LUyxkWcjXet6dtDmJRaWzDd9ZIYotDX1Mro9XloLGKUsp5oN062y+vz83A9+?=
 =?us-ascii?Q?PYbPV963wvcdGVWishI4ImmMvIOsc/KScAaMPAcxNJ+7cTwQDpioZA17oaRl?=
 =?us-ascii?Q?isl3fgkj3YbkWLmI2/ic1sA3dnOAiQs6h8q49Wqk/wASgLZ+dhtQcTBssG9c?=
 =?us-ascii?Q?tDRWmoXod0dnV468NlsoXjbprz+/6sTOeWRNCZjO9Yg990WMXGCP2dEQRaHy?=
 =?us-ascii?Q?quWFRcFDBLYpCLFZ1Jnr8iKzrWg8vt1f88zVOhJ1m9rypI7jlX9w3M7vpkff?=
 =?us-ascii?Q?o+hR7T/xpUobAf84eiVqrOjPd0sY6j/6ZwIt38i89k1H8o2S8if8tZszUlUM?=
 =?us-ascii?Q?0j0ENf1TOA2b9vjySw3m4etdXPDuXRRTBA58eSvVNzO6hZTDoy9c+xdmoS5q?=
 =?us-ascii?Q?zTLLTclXb2yRW6GYuoDOWSZBEIUhVWYz5OcXfFXXLqFkjNzHivPhgTOmYd2E?=
 =?us-ascii?Q?4ZIoYMkQkTvSU6PJ/1+M6YtMi9/1itqOMuqd+8g4/DCj0nip9BlTw/dh0GEI?=
 =?us-ascii?Q?VSzu3pGwk1zFwogq2lpswTuB4LNMOdELfFOSEFKNu/isfIyzPtQ2ZE/ORSMk?=
 =?us-ascii?Q?sL162R8dry17VeVPHGnMmksSDApClpJWvolytgMCLc+bsmda7eX8zULR3GK/?=
 =?us-ascii?Q?OGROsvj0QMpkPX77ATLfNjp0NQSzEP1LyDYPAs282YkbX3kzxk5Gaf/tM25X?=
 =?us-ascii?Q?/tPDa/MXnLJ5Vqa6wYRrn3SuSwpUJlU82jq0/KbeVE41QwTY75zCVp8UqWro?=
 =?us-ascii?Q?vtecG0YIjq/f515vBJt1td8+MRXjE3DZe3VTeGe2HOdvbTbzgYBgOHK6Uw87?=
 =?us-ascii?Q?TldMrcSRRTMoDT4pb19KJM4HahO2hklbZR6hDJ53nN/PcpB4V1GZVWqd7xyL?=
 =?us-ascii?Q?nrCji+QhxeUH0fkvXrjvY0Bw+ugRiBkln7X3kUkVAnSWa7qTEmyHKK3XbKOe?=
 =?us-ascii?Q?QH4UO+LhKLP+9VeecU5u8Mv+KxPopdl7Ojv5ANCBMOB8t5TDZcUHQymom2UO?=
 =?us-ascii?Q?Y9C0pgrenpSRobGgXxUS5NKb3lrm+n2pKi4pVyymy7oNw01nKtoGguMK+dsI?=
 =?us-ascii?Q?6G4BFPCbgiMFyqmMirXAopFagQMTeUQb2qSlqnb5seeTrtxytMN4BtKqfZFo?=
 =?us-ascii?Q?0Ds8tSWPKvQOZOxFqSizmZa3jcgtPDiz36u1Yyoueitb1MK4zIr6+rwRvdr/?=
 =?us-ascii?Q?deTqEECoeZuPT/9Mbf3ZzRzpoM7sJo+qIzMatL064bQlQwcQlUItm4sh9eTZ?=
 =?us-ascii?Q?930HTVmprQjT0NYh3HzMkjDi5gk4Yl9nX4eAEr2o+yCDrKsikM0t5vO7aVaN?=
 =?us-ascii?Q?iPzB/KEjdOf5Ok2DNJ8SberZwDLf2P4Il0bfA+gVQhe/YvWsGhNcU7tcvoNT?=
 =?us-ascii?Q?dHtmMwFGBSHhLDqqsRx0R4W+/WzQ/YDkYStsthNGHdyE8V3pRXKIM6v1d76t?=
 =?us-ascii?Q?UESARebIVjnpOmXPpKi+TTSeqUJJd55iGlYzNbIJovZn0Ebw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ae36ba-40a8-4f37-526a-08de5de7392c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 21:01:21.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8+FRpKrWXCiVupAJMMDpKOlqnPP7Bw/KUPJRl5NcZBbkQROp38gvOrGr+VsN0Pm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5806
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A4E54000C
X-Stat-Signature: j9mpxbidpaief1tsjkkq1cg6xu5kyids
X-HE-Tag: 1769547686-458077
X-HE-Meta: U2FsdGVkX18uZm7354K2EXBT9ZCuG1dy7KjJHsHWar+3SykKdU5oCgRIoy5O1+gb+RYIZGb/BeADAZfcVRbIiA3mPXmWXlJ6S4cu1algIRAy54Ebw3VcBL57VE3ILULQ1vcFYXmSV27Fl1LSAMhxz8FdiE6vruuC+BQyqI0BGKNZ1kCjdLGIs7+Q2lIjzOSTkB7YC9vqNLfDTPzmJPdQIhL04YGFIEhZQ8DhufSp8IHYBoYN/jFRaIWnlDbWbT9GMkWvWGsIluZ2bCod5lCjS6FMfydBNuJ4N7zZbf1/MbvQ1HtCBF+7P9VBvvACRTFd5s6XwqlwvtdiUXZVEYuAIfagEFZB+CRVNCLs2VFH5TAysL/TLeeLv+TwW20UlklxL0f2Mnqy0mH1Ik5ltwbj1tDKSzm4xew8JtA1v/uDSorUQE7VG6z1vmVCZ4avaz87OyK/6W9mvpfG7Fd9xjd8NfPAc889p22T4vwhSfX2/20Vz9igOgI84UmMs8hLjVbUiU8exkO+vPz4sdIhrhhUhADX1J165hLg3PaLQrQleFS3RPmoU2xEwZxdvDWzcJWvSlVqnp6IuIy+dw7OmFa+x80TWf9X1WzWXuCQCKf88P2uObJ8FPlNML5VolxpFRKqAmkpRXUnlYXw4xv52b2naNZDO6DrwJrU/hJuqoVAO4oLg2O6Y91CfNL3+M6pOfN6Wb1akh74nvT4fKMCKPnkWyD/6oI3NIV/4/9Ywac0bCa1JFT8bA2HI2PTsZtY64we8HJMNiP2rZZc4ZIlohcJsA6nf4xXANzBGfVu4972MNZfAD5VwOHYyqcmFdWNxRloc+Bx50tplCBzkg6nXiNRKiSX8Mbuit1vS50CsXSkpu8yny0BXo3INvVphS4XsXYrdzCCtTAW2ZG9qbljb+xhVXZzYw1qkqzKT+nNNoi1bRLBdZeY2W/Ean2ZIUOrpk0441jH+1gIfS0IjOmda9y
 1P7qRGnO
 b/szP5gq5eFaFpAIuBsaB67wFcJjUXFohu2PKzBg5r+3Co3lqwJmwQNJN2nsRjgVQsAMpbwFKBHyc1bQC8dr+8qWeRY29ZFI8U/kieU4f0o9AguRcIC0Q0kwrjJOxWd9rnOsDZcHoO4r8CbFvBNSqS4JUqvvTk6Mu3SKjnixhKeKkgFnaC6zBbexUjqrxuS5Z30sx3DUw2ZVbJFalhNZeJP3nCL79IuCokJtNagW5/KhvcN/K2Im91QXS4rM/obtlSs4IWmLp+KhGEcPoyzJfL1WI+xjZiXR2jhpQrixtYbbHK975UTdMfPoHKcOLMeJA4KpcJlTEj5FYJHb1FfWOQajeeLedTNT6z6R46Cn5GnroiYK4jSOwuxlan6jI2mk3tyV6QTlZLtnFQKv8gUSfyOZY6BjoI9Y0j7FVmvJk4oute8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Jan 2026, at 1:23, Jordan Niethe wrote:

> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
>
> Prepare for this by adding a PVMW_DEVICE_PRIVATE flag to
> page_vma_mapped_walk::flags. This indicates that
> page_vma_mapped_walk::pfn contains a device private offset rather than a
> normal pfn.
>
> Once the device private pages are removed from the physical address
> space this flag will be used to ensure a device private offset is
> returned.
>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
> v1:
>   - Update for HMM huge page support
> v2:
>   - Move adding device_private param to check_pmd() until final patch
> v3:
>   - Track device private offset in pvmw::flags instead of pvmw::pfn
> ---
>  include/linux/rmap.h | 24 ++++++++++++++++++++++--
>  mm/page_vma_mapped.c |  4 ++--
>  mm/rmap.c            |  4 ++--
>  mm/vmscan.c          |  2 +-
>  4 files changed, 27 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


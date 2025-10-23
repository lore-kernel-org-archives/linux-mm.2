Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA26CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 03:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CFD8E0009; Wed, 22 Oct 2025 23:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD378E0006; Wed, 22 Oct 2025 23:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136B08E0009; Wed, 22 Oct 2025 23:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE88B8E0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:05:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86D9013BFBC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:05:47 +0000 (UTC)
X-FDA: 84027889134.06.FAAC1E0
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D54D180008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:05:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I41138iJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761188744; a=rsa-sha256;
	cv=pass;
	b=Sq2yTGylfzHmvjFaOqnb0YdKLO9D17SKkR9iV9cH8uTrylWjcKFTSWReLiJSQkL4KJCeCB
	g984CnXnTkmWph8HdtaaABWyK0tnSkWzBmFFJ8RmiRM0zKnnHWQcXLpbHloB0cjt6DTnum
	xSS6GahdAtlICriu+P8B6wm5hCb+LnA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I41138iJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761188744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZHWyMUCW8X7ojbzK/5P+zWHFshBgJGZLdNvCh2kFTjo=;
	b=Rl57dHEwhRwsNEnjwh2KlUjDT0Sy+1Mnz5AXfsTTHv0yA0HBdr43RLV/U5NVU+bhM67gjv
	cO/qmJMr1l7hqrR21Og5t7oyBEvR8a5ldgbpUdqO/2RCHSDWZjPk3yo+WmZ2PFTl9PE8Un
	tdUL+OJBGJcIWc7tyFy1TfmkzIYqpQU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6v5WAZCd4bsuJr2mphLyJp+/kK/XbHUygc+Pm/25sH7PC9Ajs8mritVL8GElZm+5Ua7uvgi5DkefolO4dZQNsos1j0XTLcAhYonzs6s6beRoSHdmlyIT7ScphJmslQD3sokiSaxA8zHDJxjgfXmU/9+9Z92iwrsARXKqFI/x+jPn5qQH18HI0ueYREsh+6HJsIhRo0eYJRKkdJTFKi0zIp/P+gx4+SmNoY87nhsrIEMOlpcAge4N69y9LXIyIN6qNp2nYimws+0gJUEDyUeSom3wLysJf4dLmvCyMW47sLebAyCADRbjoYN6hoT4eg08B9WyFZGXoKmXkFvpd6iMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHWyMUCW8X7ojbzK/5P+zWHFshBgJGZLdNvCh2kFTjo=;
 b=kSBZgwdBvJTgMZ2NBiICbov1JyKuah0c+VqSfQTQSsnubjNtQSaJUTkWAa0ejZ7Vy+sifQiMAevo096CbYqsSvbfUTYNQMNC7MsbtOV4VAWoX7wXIQOLMfrNcOnfKLU5xIP09F0yBCRlDZVcztO5Ovpv4ZybPOQz71J3ysANWHzeLAPioJZf25Pv5x+Wv4WtQNIN/jfCQSeihnwbJrdNfc5fUspfD1s697RauS297xy7VgYXOd4SBaURwT+lLpoykyCYXcQ7aX1DDMPCpAsxw0W4kRL/en0TVliXylvwhuKfPKb+/x28h3NDsEMIQlUBFP0iR8/ODjQFf3myH66O+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHWyMUCW8X7ojbzK/5P+zWHFshBgJGZLdNvCh2kFTjo=;
 b=I41138iJUtzvSKUwqw+4AuSY6OH5s7Go0eb8VOB2xmpfH/oQ4t9ZAxhcBXqCfCqW3xEB0wR+38pG8/gglGEw3N7xF3ObaKuYXPfdauppp3fEWN4kUGFMmD9qKig4z/Fm0yY7dLj2cK3y7iySF+WSvGeRSlBdVTkQTHAQzLEqDY/Gz8YQ+t0me4Y+w6f/vnT+McFdwu8QcubF8FAkVRGuZfiHidL4drtm/NCJtCS5cS4TtHqGESMR5bddf+gJ5BoauWctWOSzi2AxsmscfUptpO590qJm0AYUpcS/B8wz9e8HWKM92VJgY6aCQZN+WyV19LRTnDKWuqtw/h4T5Xearw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Thu, 23 Oct 2025 03:05:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 03:05:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
Date: Wed, 22 Oct 2025 23:05:21 -0400
Message-ID: <20251023030521.473097-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:208:239::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: 11713250-4f28-47fc-d5e9-08de11e10c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SEF8nxi5NYmtdpvscvcrIafJ8nkR0KH7QVfTAnDJmirmYCsdnm3JaAfM0L8C?=
 =?us-ascii?Q?JkYxgo3TI6e4u7GjUk2L39Qs+iSGlznfDZVjyPNV85WR02PqTi8JR4dF8S8p?=
 =?us-ascii?Q?LZzYbVmrO8WdMokHf0XOiMfygqmdOp7UWJ5hhhvx5RkgWl6TkaV7mlOfgpGo?=
 =?us-ascii?Q?z+QH7tWZtP+qW3uC7D3l8sPloQr68DtNS+YPRakW5yuzZJr9H2j1xGQtBL9T?=
 =?us-ascii?Q?BEWArBj+bcru8PnEyRmZzY5Gpgy7v0c40PhjFAUAZl0LCjSab1Wf5FhxfjZc?=
 =?us-ascii?Q?Vwydi4k9moikNkjBL56yl0icYEnPk8LvdpLZOHhbbBQCEFnYHdfMSpPvS9/z?=
 =?us-ascii?Q?hrWfn5zgFOgfYfM7HGlhb1EX9r6PBKZamRCqLCrLX9EtniXer8wQqdfy5be3?=
 =?us-ascii?Q?XbfaumSOJ49/7kMB/5/FD8wWhCHPtw6ojfDQ7gpy4E+khi4lw8qPqLHh4r8w?=
 =?us-ascii?Q?9rHImonsR3zZQigE54UpbtGx/b9NaktkzG/K57SUBWiBVbqK41H7GDP4Vkk0?=
 =?us-ascii?Q?iJMxkFfN/MJTDCjGVQwGooM3bjbaPByf+Yw3UtmL3BNECb9LuNaacBBYTvcF?=
 =?us-ascii?Q?S7PQAMxXxD2uDcbjxmXqlRK8wvN3yapoZgWgC8cBEYpLhyzpHZG7Z84EpvRz?=
 =?us-ascii?Q?eGvAZEIl4xlGJ5KnABkJ9OeYXvZjWdDTdXnrvgMfiOS7F0MVbOTMCOSm9w3N?=
 =?us-ascii?Q?4ShC3zQx3OD4wY3c4vV300MRFhWpKeZgRcuD29D+3XMcAoB+BwD2V6D1AK/4?=
 =?us-ascii?Q?dcOiS1PqtqHf9vRbb969K84yubRd391XfqiId9zci7JTOP6ZFKnt0/HKfVI9?=
 =?us-ascii?Q?HYW6kYzR2Y9bnYSEqgvNVsvGnL+WN6dydn8pGuJhsPoNq79UdWYMnen80JDr?=
 =?us-ascii?Q?tYlHcFvdFbrbHQwuZzdNBOcpCJEixRmzzM86J2PaD/SZgoxeiz8ULenE0hRw?=
 =?us-ascii?Q?+z+o34oARJbb5fEhiPfYQ3yasTq9c77za5hC2a6DXufktuH7upgZq0DzdcY3?=
 =?us-ascii?Q?prWyz8PTIoUk/mOfZYiYu50JrlLq/jvOgQT5xBDGPIzAiGRlkTmPkOXOgIQy?=
 =?us-ascii?Q?7Kb3Sb4546uAXHoj0ovjnVmajRHhQpnhD6tTjaTpO00BkxjZT/7WeXM+h1qF?=
 =?us-ascii?Q?kQ3sPEa1ky0Z+cFuLxKYgbFopRT5az4yy8+Ldq4lHVRo/0D+Axdl8wfeQKG+?=
 =?us-ascii?Q?lyFM9yiy1+bjbAH699uIADCIzO75CR9ApAZGpcywGwpwmYK5PcFfGCxzv8Cc?=
 =?us-ascii?Q?dkQhgD9wJq/7pJhhj2fcYpkb2YLbmmuF3LKOF24hsUnwkSGLOueeFEa69zt6?=
 =?us-ascii?Q?Jz5FZfPcdcdWGA0ZOzax/hHQw+lN1Wv2jdA+F6So0IRpj1n/d6luGil86qFh?=
 =?us-ascii?Q?MR7qLlSDT/JFXkLXfSK4uBY07mxAxGCUOpiKCvarom4dlsTu2DM+8yHrhXwG?=
 =?us-ascii?Q?e7Xy+5UbO1KXJhP3LvKV/ZYfKrp9u+/c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?01SaxQ4Vq9JwQ/mtZD80ie1g+j6aHmGOQIb6VQwEzZD5XyWxP6mf2OjVzq4v?=
 =?us-ascii?Q?zfh+N4dJIqSkJsZAad+OH62+0fNlcTioI8HrUEpr7oVodVi6L5Ep2fLWwSeo?=
 =?us-ascii?Q?kmyedrDWrXtlqXl0q6Gm3310JKbWjp4KN+2tNX0asbeT67FmYSFkrq7XkscU?=
 =?us-ascii?Q?zlVaytUYc/xNaSzI3I9O8JNYD7p+cc5orChZp2cbM0EZqE7UstR3qcPQsm+B?=
 =?us-ascii?Q?y87tJDbIMkgGN4ZVlTWbVwoq8bVkpDuSuaLgV5EDZ+LnnEzEVG+ykga2l9bD?=
 =?us-ascii?Q?Vw2DSVg4+KCPRuept8WlHftzdW5k0zusZUhbFeCJeYWX585Ymr7xYjIbeUQJ?=
 =?us-ascii?Q?XKancalTbmpdyWgUq6aWbrDRY/zPDPLkBotjBvZZqU1bU5bqHaCmDOw6yq9p?=
 =?us-ascii?Q?pJGeFh5Wom2dyaY8fm1dIrO1+Oh50jVIyvlCns6lA4IiBEwdHmUdGeGl+6lS?=
 =?us-ascii?Q?G1lQj5xEIQzXqj1b8NhDzMKb9yjdbCTu6CAATEAmhldXbHhTssmstIWuSPXF?=
 =?us-ascii?Q?mMe5OZqOVHe8iKiFwIhAcPW6fct+ai8RN61rZAF4Xm0h8XrQDyadMDoTana7?=
 =?us-ascii?Q?sOI+BvhzfwJ8HlfZp88T8X2M3ylYFpF55dLOBryzb3UCPXDF/eSb16GDmtTl?=
 =?us-ascii?Q?KS4eAOF8NHHVg0SZk852NLsO7For8AD2x68bHIxqaQlTW826sBISNdFkUDV7?=
 =?us-ascii?Q?RKD4VDdewvx8wbbrUJV28TE/FuLI9VnDWHAq6SZNOxJPL8HfmNIWHKf/zJAJ?=
 =?us-ascii?Q?93DxZKEBcjaTKoR1EWdyJ/ZgAPDEOJHICqoXHYkFQN/r+edUYDDC4kSduL0z?=
 =?us-ascii?Q?Srg6kWuujAtGR8ixM6yf6sJ/BOl70bmAw1ONwn2C0f/ZXuWYiJHgqlE9Xkzo?=
 =?us-ascii?Q?v09W2Kb0s09f6KLZomXiu02sjqO2eW9EBA1ZKpZmSMC7MgQDYbP9IG8747LY?=
 =?us-ascii?Q?QXxu33NWqBKGuKmc6b0XOUtXYdVAij3BECON4oH6denE25lnnsshOENqPnL8?=
 =?us-ascii?Q?rokJ8IAMhKu91lnlZzka8ob0YArZbYhLlqr2Zj6kjS88B4dyvtn2PYJwFUSM?=
 =?us-ascii?Q?l9VyRulygOxR+VGCNlxUq7x9vbaat5ENTCq/yNcYW/BX95LTuz05GI7O8dVj?=
 =?us-ascii?Q?lD1sFXjCYAtbT54IrlNIJXuCpbYQPagxntjL9tXt2I58TBxbSGDFaDyQoBp2?=
 =?us-ascii?Q?rWnF7h92KhHYc9YyMa5EUxCbVQJndHtMchdR+qtGE5sd+sg266tIowmiQeTd?=
 =?us-ascii?Q?x00nFGpfO/nNYBFoXRLaHM8Ko9eu7h03toMVZj2D7WX9AHKlV2aB1yUfAMaz?=
 =?us-ascii?Q?xx+4FW7WbTDNue+VenuqqfHR1FI2PNs+2PEpnlwaml4tK5UfH4IaPVbv/LwG?=
 =?us-ascii?Q?FUuNKweOopjZ9gOHE4uPE3IAU2b5T1sEh0voG92E53LfqQZiFxAeb9Z9rvBV?=
 =?us-ascii?Q?2jqqoBdeJcI1F4d3IUeXDelo6a8RQANgqt2VgT4sKHdyBmsO3/dFMD23GeNJ?=
 =?us-ascii?Q?g13LMR12iwHz50wF2QHcxdmMRBsbRGODWN3xFkhexBp/3euSDiVHh/yBhirq?=
 =?us-ascii?Q?kieXYoglwMY/GQK2tfch75fTR+P6VWzN5cNy4skY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11713250-4f28-47fc-d5e9-08de11e10c21
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 03:05:40.3775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPk39P+WUbnWB5Ew3EwlaoGVFzUhM0JKGA1qCroYtv51sQJmvopnUfeP/KJjA2y3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156
X-Rspam-User: 
X-Stat-Signature: b51u4191mfqtrkjw9yjh8jgprfosbdw3
X-Rspamd-Queue-Id: 9D54D180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761188744-24326
X-HE-Meta: U2FsdGVkX1/UDQ0b+jI+70Z+gsJ6z/60DF22XNV105B5b16f7zUUMkefEgA6ntlGLf5sTjHMNi+gPBRk8snqz1ZOPGvE03PMQF4F2jBSTdhMTwHglR5p/uQj7lyPt9DVMPkwMEjNwjjqFeiYmmEc2mBRDyH76Acd4m7DVWUr7lVuXcQzVrzZexZ7XjHl2y3pG8WWIvD9iKO9ivIMvnHXG15EzquHU3DxWLCPMyIXlJzyNYY97Zu9CM3QGNbcIE2xjN51JCTJC7yiJNDkArrpsHrjq1Xo/gqBy7SyJ7GRB7Le2a5slfGODEJQT2OoOuAzV6c7Yvn9w0CNYnbHaepNqZJaSMIYi41PnhxAM3no3OR/X2XeZ7iWblq5YknnGwe0GCjn70uqEK2yACMW3KJuToMV+AjZfQDaciTFEp2yRGBWmw7YdC2g1qUTr4bXhCBZ79AZo3vRuN+BXtH3IWXJbeR3SdtEVgHSbH/VOTCrGv8hp6GMG3Oxno0ZG9ipT7XJwk/O+66oiWOzAFbOiCGRaXVFS0TCqQBb9I8MMLWO3p9O3qYBCgfVYoWnV+Hzzu0Dlm1ud2mIIMILRtB3zCbKQ2CDmNGqltY0mDRtteKvGUmYUn+x6/tWyD0Ix6Yyg8AAbu7UgNgMyDSEWcFTEfTzdj9aFBcPer971AL8FXb2vc7O6iXF5Nn8IUcPt8+YJS2zioZTMQDbo9LI+/AUTk+d1cPV29dLBTWc0j+ak1UyxSWcNBHO8n0JXO01pa/icIU9DFa5wgdjUXooWZaVzZiuTpH7sqC4eXp4J1Xwfy5hMGJCq5qG0M+Iv45aPJCgJtlUCExWiiINK/zhzvkRdg6UoBg55OnN8H20CqH9V3dqUemWBh09sxxx/0buHlomssD1DrfC1ovdBXxMAu8EBX09InNxjpiAfdGmsqNotp5yZYcZFUHw2RhPeKEy63LAP8p/TCaIYkyQz4qwpNC0fT1
 M7wEg0sH
 jw3DMMVP++mxwj1N3m+VYw33Q8opNAp68pBV3dnKdxl46GEwVzHkG7qhPLvvPhWy8PpF4zrApcvducZ4NyieWWZLbXiSujcSdtjMXP2cBLNZJRSWvOcxkYqNE7h2e7g+PyXkS8TIr0v/2K7gxrhOcHQ8kMSayqutAjCzXKJb7GHiDvRp7wJfxARI782l8HCjdICBfCipeUig5OT2LEnnlqzgpP7NML7NaZ4Fb9ixu5DB+aDJITVQkbTDx677nQnm0rceXdLmWkHuJzudQ4WWwzVaPmPOhlOASuk2h8HR7wsWi4SSwcxoy9P+5akmNoAZF5DPTHoQzOCoBiABAZHNWWvJMLBnj8UGcMBMyhRsockBYKDwpgr44M3mKCRI+zLQNYve4J01CSSYhP/6uvERw5zqhyP362OW/xJeXrkXcUeo4bWv0Tdejp8AI2OwK3UvajbVbcUDT1isoPZomFShb2JlQt3HecnpaxQ2TvnotqNWxsaQNe45PT1/pcYJXlMyCCPRzK+EXI6mKOSFDzY5I623Xm2vU9xtQEMCgGecYhT9gD7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio split clears PG_has_hwpoisoned, but the flag should be preserved in
after-split folios containing pages with PG_hwpoisoned flag if the folio is
split to >0 order folios. Scan all pages in a to-be-split folio to
determine which after-split folios need the flag.

An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
avoid the scan and set it on all after-split folios, but resulting false
positive has undesirable negative impact. To remove false positive, caller
of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
do the scan. That might be causing a hassle for current and future callers
and more costly than doing the scan in the split code. More details are
discussed in [1].

This issue can be exposed via:
1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
2. truncating part of a has_hwpoisoned folio in
   truncate_inode_partial_folio().

And later accesses to a hwpoisoned page could be possible due to the
missing has_hwpoisoned folio flag. This will lead to MCE errors.

Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Cc: stable@vger.kernel.org
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
From V3[1]:

1. Separated from the original series;
2. Added Fixes tag and cc'd stable;
3. Simplified page_range_has_hwpoisoned();
4. Renamed check_poisoned_pages to handle_hwpoison, made it const, and
   shorten the statement;
5. Removed poisoned_new_folio variable and checked the condition
   directly.

[1] https://lore.kernel.org/all/20251022033531.389351-2-ziy@nvidia.com/

 mm/huge_memory.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fc65ec3393d2..5215bb6aecfc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3455,6 +3455,14 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 					caller_pins;
 }
 
+static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
+{
+	for (; nr_pages; page++, nr_pages--)
+		if (PageHWPoison(page))
+			return true;
+	return false;
+}
+
 /*
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
@@ -3462,17 +3470,24 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 static void __split_folio_to_order(struct folio *folio, int old_order,
 		int new_order)
 {
+	/* Scan poisoned pages when split a poisoned folio to large folios */
+	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
 	long i;
 
+	folio_clear_has_hwpoisoned(folio);
+
+	/* Check first new_nr_pages since the loop below skips them */
+	if (handle_hwpoison &&
+	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
+		folio_set_has_hwpoisoned(folio);
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
 	 */
 	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
 		struct page *new_head = &folio->page + i;
-
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
 		 * Don't pass it around before clear_compound_head().
@@ -3514,6 +3529,10 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3600,8 +3619,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
-	folio_clear_has_hwpoisoned(folio);
-
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
-- 
2.51.0



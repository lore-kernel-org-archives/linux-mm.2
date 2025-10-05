Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BDDCAC5B0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 02:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B650B8E0006; Sat,  4 Oct 2025 22:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C788E0002; Sat,  4 Oct 2025 22:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AF58E0006; Sat,  4 Oct 2025 22:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9788E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:38:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EC951602C8
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:38:57 +0000 (UTC)
X-FDA: 83962503114.05.27A0E69
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 468E5180005
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:38:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AVF5EfLp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759631934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7SFsXQ+lbmj6f5uzzqO20xonDZ7FRQWzNwVdWAp90Q=;
	b=oOTc1+ACUKd8Wm6WcamO9ACCY3tyNjztYgK8swWmw2LTQbAXpNWIjzYfUVeHfpY1gf+ma4
	kLIljRfiEDizppKj0FYZ5Cy41iuGHq+/CjtKz6S7Q5nw1AMWYQwA1omwJLjIL0FOwIgtb+
	xv4L29yo4vLbGfTVdNPmmC2RDZA1V7c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759631934; a=rsa-sha256;
	cv=pass;
	b=24RJqrW0bgeXlGp40UO32cNTZDPH1cDeh03Z5OlWu353WNoywylKoTC6HOfqx+GPspW3f0
	HUq6CzffTcQapEoe+NvaCsfBBzQfj8Zc2KvQvKLQvNe4KbgHQh1O9p6uQbDDSscqh16LpS
	lhZ2uUQcS6gWNhO3rxVJyTTKKdEbQMg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AVF5EfLp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WW6niIwUkLmhlNBB7NQmDty/dneidZIAUIdaMqOEBC5cF33FOMMr0AwADAt1klMCLU/4yJ4RwytaILBC0931y3ufARQSj2lN5SDt5mL1DgQR3l7g/lpJcgsfpmaNVcfwRZo9N/hUskIPeMn4oJDVjuXxGgzVM00FBaJIC/5HMWzds/ACUb7Q0/XhwVVTqk0puynlXhDe+BBsT+yFsLIsIyPVvw9Cs7DZ5ZNBzz5oRJf84k2h5AAWVNhi7fhvNmy7Elrx5isp+MT93Kn6PIiBHRr+UT9Ni3jDhVDNHQfQ/jxxwmJagWaimXxGWcf2yTaAcvFnXhUmtlIXcgFeBkOynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7SFsXQ+lbmj6f5uzzqO20xonDZ7FRQWzNwVdWAp90Q=;
 b=R/yiGq8hLDHsUNoYrIS8ziGS9mNcWuOIYQB7WEWFPPH3tSMdEXgR2CUjiuSoSeCsDKmkLJpPlMY68xZv4aSODnjQ1s6XaGXJsolE0WbJe2TGHW4vtP4oweI3m/DwuhiuLLGBK65KXk9oghWWgKXmh1LQdbSE85/r4c3mG+6MuAvFZmh+ljMeOY0fj5bBI1sBa/PipwLjCnlCa9IHMkSPXhjnlutZ/2i2/pP05pDMjbQ9L2g0QmG0d/av39h/cNl0LOGlpxW+1E6vdrMMy+KQebtBPhRuXaTZCdFaA/RG5qUCMT+dbfkfvyYvW8HBYyFeNCET22u0PaxCLQoXyQxADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7SFsXQ+lbmj6f5uzzqO20xonDZ7FRQWzNwVdWAp90Q=;
 b=AVF5EfLpatN9aycB9qSLE3vwsUxhF+FcXki18MhuI72v2KVjMk4rHdWDKuZGGbEbuZofisNhsC41lIe5Sf8L+/79tAME65hICkoAmXyGWUxPlQlf/TWhsn+pom/YxeyJi17i0OZXC8oZr+0yQ/Ah2u1CgYaeFetWKheryi32d3oyI8xrDz7+PDaOICXr+p5emIHhLP8IzUsWrdazNA8rMGPM0Ulc+KAhfWNenUVpg7BVcSc8iQbQ8ppqMVqSJVZWakPD9+iMs1/4ZziSN+EKpJJkAcRqM+YMoTMpYzVQZzbzYsOxxRShOu5LXkLxIXuLr3iTIUFCqyKC3onvh8tl6g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB9162.namprd12.prod.outlook.com (2603:10b6:a03:555::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.18; Sun, 5 Oct 2025 02:38:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9182.015; Sun, 5 Oct 2025
 02:38:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Date: Sat, 04 Oct 2025 22:38:44 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8FF0358E-1ECE-42DA-AE4B-8D5A578450EC@nvidia.com>
In-Reply-To: <054ca3f1-b219-49dc-9c4a-6f648b9df7f1@linux.dev>
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <20251004094217.bah5q2zxczrqontm@master>
 <f235a557-d031-4fcd-8c68-81d9ab7b54e0@arm.com>
 <054ca3f1-b219-49dc-9c4a-6f648b9df7f1@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:208:120::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB9162:EE_
X-MS-Office365-Filtering-Correlation-Id: db273c1d-661f-4ac7-c286-08de03b84eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3byvHCW0JgPw3i4076RlSUGV6PlkdmNP1ZkPHeTUNHaf3ILhAsbRfRuOeaov?=
 =?us-ascii?Q?as8Wt9iYzrQiHwL3ZBxeszaGyX9rkHZY5HmzuIfU/CLfjW03BSUWCUAGZUce?=
 =?us-ascii?Q?7jRtk3I6BMCnr3OwPnurj7W9csMm5qQnnA8XGHefp3utzKZMSk+KgYXjCEe4?=
 =?us-ascii?Q?vn01AKU1UNYLkoAk3rmmFgTSQ4SAVHsIM2Qq4Lm6fdwhiIKbzIeeWYdDMhUR?=
 =?us-ascii?Q?cOVHtGgNzz24R38IaZXTnVm77u/8mG9VgU2d5/WTHew5veVg9bwIHi9q4G81?=
 =?us-ascii?Q?P0MlvOjAMaMHFInwFlyHxjFp4/ExQhKXBiv7QvPwOv1C3HmyRHlLRnLSNvvE?=
 =?us-ascii?Q?40XKXcPpLyCLcJNoRnBoPqy5gqiUsZHpuVTQ6mOg427MgNkVMWdaFeDU+jke?=
 =?us-ascii?Q?2qBz+jUgXMzw8C2LyUOMWaTPnlPmrJckwKFb6MvqBBhbkvogbo9hKX11M4zz?=
 =?us-ascii?Q?SxZytxTVtdGmF2s06/Kg9eCWX0o2jDvCMg5T5uIz8FdvXfPohwh9UVghsX5r?=
 =?us-ascii?Q?YX6kYs/14XdBy1RqHQSFC0XbU49NLS9ksQCjgd/N51IAOtP+6t0y/PdBdZ3x?=
 =?us-ascii?Q?nKcWAdY7PcVQF5kqFhDF8rpQBT1qLIz8EIrKzD/LF8iyLn1iTv5ZKknsTmiI?=
 =?us-ascii?Q?7sWlZp11O1ohYzk26KIetgry/zQIeUggp5LgaQDj75t5lmrh6J3MKoxfvBgF?=
 =?us-ascii?Q?HGiRIOWcB0fTskTXcKcKD8ejsC9Pc4kRLXboMuTGdwqHwwLKUAe/IT+CJJZ2?=
 =?us-ascii?Q?HUzpvavxtUQ+6TebCD+0Pda4s024TePyvZCue7mcuTpL4hy8qIPjun85xIoN?=
 =?us-ascii?Q?NUNH2mvAy1NT9aTh+AxSujCAiU5sGrCbhQo17fbUsak+I6M2J6gcsi3TZtLW?=
 =?us-ascii?Q?cX0FGUCD/MZkO5heSXkIf04Hm3W6wj2T8BX+5vSDH1ZwehNoU4Vh/C+f69ew?=
 =?us-ascii?Q?WVr27i3l+x6J+oTfn7O0MxM9fG+yLPsxABOEpoCCipCR9DSea5U4DCb8a4Ym?=
 =?us-ascii?Q?A839F3OsfZxxUiY3uHYIP/Ks5h2o4iWRZAYEbntj3a4TAMqkPI3brK/flBdz?=
 =?us-ascii?Q?/Z4tQWY/h3leYjaO7KQ11aJWFhPhsw6q07Pn8pBvtAo3xdBcp2tKR8FIpUho?=
 =?us-ascii?Q?Dd0TobkccJoXu2rp5/fGXfOjqEXpxQ9TkqzAP0etnF5c2+6TQV82RHd/jFIR?=
 =?us-ascii?Q?HXezNZ4mL52F5vE93icRek6ZE/SB8xEMQHVDZkJqBiay4tT7bYBfnM1k6LVY?=
 =?us-ascii?Q?9qZ3KaHgADS35VzsTGKNAZiRP98ifffsBBNAlr24+Dv6e+O/yg+Vw3CJnIHU?=
 =?us-ascii?Q?pCFxwCCsBLHN0Pqz8eYn3L0Xun1Al0U5+FnYNlXMiepxE4bM97p8Yrqwq9Ve?=
 =?us-ascii?Q?JNOc3gkjLi5xsCzJo875yPNLRxyfa/7HHfWsCBeIgeojrHG8JGWY6tw0I4FA?=
 =?us-ascii?Q?0DYYuCLxjMLJGIIRkcs9cpH4QsqYR+vh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SaLZRV6bgzwASy+wfCXVD/PHppp0pxQtnNqsj/uYR5g6bMDiA4zPYdXk6ijQ?=
 =?us-ascii?Q?uwpWxyN0GSoiHCr6uHHZh2aJ2XfksSB/H24bTHwkUAmaPrXkbpCpwHK0rJmJ?=
 =?us-ascii?Q?+0Zh9YGeHmbg7x0X2EgYdTI9oUK7odUFOGCqJvWGyvrdzADV/FSthKaZ9v6H?=
 =?us-ascii?Q?zmXjL7Aa6xG0C0AScWkjrO4U97hlkBl+TY9fGzGh6UsLFZG5nV8l8KyVCORY?=
 =?us-ascii?Q?GB6X1r+o1JZ7+45uXWTo64lRHWlEmi83/adKEocboATioPYZCHCtuumAzyp/?=
 =?us-ascii?Q?FUXRsyXvbQQCzoQanQOENqW7XQqH+FMcA40QqZfpewKcs0CItB55LK/doCDp?=
 =?us-ascii?Q?W5OeumTvyHFrsEB9rdo8YZzPdx6M0BkXozbuiiebD+VWPEZFQZxTKmYQ2AFb?=
 =?us-ascii?Q?bcldrTqLyoD7gM/wK0w8LZBwxGLbOAkwPqQSGXxhta9WxGuhZVUCf5zDLGXL?=
 =?us-ascii?Q?jaOaAJZrVC/B2pcWAmaXjYseEZ4L5ILYKG/63aUjhisFhPhYwf9qN8jAb3FX?=
 =?us-ascii?Q?6DUZ1hJTmoVw25J26jYhkby24ampqzYpAiD8YEqa8W3hBKBboxxGB+3++/mL?=
 =?us-ascii?Q?lqXwsUNPipUfIpDzSDyJ4ljrL/uM4GGk7GSWxjGsMFIuasEIyAo325gXCAIU?=
 =?us-ascii?Q?VlRG57oXBv9efJl+5WA4kfFJZr4CNHoGXXwSG/Djo0+y+RRc3cT1J4bVo2z7?=
 =?us-ascii?Q?Sb4nOTvBwa7bISh2XJqj9qlfH6iDHWILmSa7syeh/KdzsHn1QI0E5lhZbDzI?=
 =?us-ascii?Q?1ThYNl046MEyzC3PYMrOESYpfojfWkdzHz0DCLFAC0UF1armB/l6OV8OJHvQ?=
 =?us-ascii?Q?6adaHkZ8cHEJmaNAYqVy/CTc+/rK5RbGEQeyWKokIOg7klGbYEGR91RJ0+e2?=
 =?us-ascii?Q?btghP8Gy2Zrm7eBT8nWbFg1mCmOjso0T844fdta0sl8JwVvv0UYYU/hD4GzL?=
 =?us-ascii?Q?bXS2hmpfS23AMsFPwMLg9Ww0MWmNtDbYtrJLYKbCAVnRB0PZ9bnNmPaOsexf?=
 =?us-ascii?Q?Mqr0Fd6W8JaL1Qe3+JbZfbwd0Y+DBZiS5bS9Z0LBNTjfW/Pn7w5Q4JI8jzow?=
 =?us-ascii?Q?i7YQCh0vsnitTZAdyZehQtV2LdXdwX6pmvz8l4pzHodAjl57oV/FgzUvR2BU?=
 =?us-ascii?Q?Kix5EATIf0IXZQDaivEdTGs0vnC32P55lySfsBh/o5MQyjQDIh1rpkVRolJ3?=
 =?us-ascii?Q?hB953mVPfxyX0aMSXamFj17fJ/j5XQb9KvPkOGIPg6l0ABiD5ihTJ8pCK/jX?=
 =?us-ascii?Q?jLcrynmLkQH3q7laiIHuZ+HHA9nnG2UgxVkvAMDlhUAte9xd8uJho7aNKAXk?=
 =?us-ascii?Q?KigcxGRkszoF/XZUkFXeWsczr2NFFfBc/ZMYoJSgJvRxrK1ofUXW3suPvVGQ?=
 =?us-ascii?Q?0T8G8Jak3zdeG0WxFlFhtu3WH6/izT+k6+QfyE0kd+VAHgj6neScs5DcQImT?=
 =?us-ascii?Q?PxhckHtICaF5lSruWtxj/6v/da30nN6orpbyluT7DS3vg3jq8i9hKOuAcO4C?=
 =?us-ascii?Q?K6pr6q9Yz5YRJJ7KtZKsMIlpk8iSZUD/6xrNlNt3KZnnttx/z48dTtNbWpg4?=
 =?us-ascii?Q?zjcOKyD1fDDcwVhAiS0I9P8/Iz53iffMaF/vG9fo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db273c1d-661f-4ac7-c286-08de03b84eeb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 02:38:46.8186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0ZBRSF6Mp6V+DupxeYUgQ3hh4EWkhtjeYcjaNZcTJ6yYL63p42fYVHWSRcJ0Bw5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9162
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 468E5180005
X-Stat-Signature: 37xah81bwwcpgzacn9h79qhjj4jar7ue
X-Rspam-User: 
X-HE-Tag: 1759631934-327012
X-HE-Meta: U2FsdGVkX18y4pp1k7X5IMhAumstxq5qx8FxrAArjYwIWCcaLc6pdpavcP/YGyGnxC1A7V62mdldxS8GyyUbrBNgYuGhXNrAGK9pJKJ+vv34ASKZI29eDHNljVof5UM4Sdb8lrXNELUXp0E3bghzuLirda0nONutFu9aOUd6JxbpWI0krxQdeBIG8PjqwLvwJpnZhuwDSrTQg0wuoICKHfVne8mT+5p7Vov5IMD7rLe9M3+t8gch0mnR2JTm8j2wHrV6bIReGX2C4uhvdBpl9+Vmi9n1pzFeupaKWJ1zmtNlX2EEdnlugplTTAUTqMPydarddB3f4H1VXvqvuhw1ykXpa8wVAhph9D87SY14HOtprXOuYwkhDf+HGlkfVwJzrjEG+wg1Yi0To8pkWAeShGeZEbxnZbT/8rNgxGuLtWilDe1bEqzQErmCWiCj9mxR3Y6iDB3bdYDzGfOTFf0c7Uuk+zMPEEEh2FaUEvVY4+dTxFX0UmpcOeCxKJIIfyo/sgKvUZmmpgHywetlB5XIsKx/3UHA8dvA9MxGrhS8VquUv/N0H7txlyZzubfYLgcGWlbWYS6RwBV4cV4S3SDDZYJPHqnRjYSa5iV1m67GPZXsObhzohxXJEpLdzqgkIlp8eBYtqW6md+N+4XgFhNnKPvkW76Q7GHleO/+0ERg8ZnYiFbTN9UhGnYJsf/7IJauERKX9QodS/6KzfJMMhpZPhgeeoJYhbya1WkC7IpvgGMXbQ5fdAkMMTF3noqt+vesGB11+WDt1WhKYTrrasgv4uoaAO1AEXsh+WuHiE2rCnx2puoJ5djcXpXwZlZrY4L7fJd9NHeES57xbtGBYyFc9v0u0v93zftisD4b7ntjt5YUS52njwIeY1KcJGRqbR/LPTlWeTad6qtvRyeMuZNgyAiXWoWb+oXR95D3VlmlQRYkp1eCSx9OjwirPYoEIVIrO2H3ytemrFknwLcBPhU
 HwR6cZ3F
 Azfb3DJI5fpZzbg1siAw530B43QrHhIMygHkWX2HjkUVdzfZ9Yyc/+XqVe6UZwso2BefPXUfAlG4BQWrJOuF1TsUckH2TXIH5AijEOGhwseXR/mt7B/XA+ocGn5oAE8BhLpZbCWYSA4Q8SR/uBkMIG8THuNO7YXAxFJ+DBHiEWfRUyR7PPIxT1+QWBygETZ6X5TKdmgPiFnV/qFbPfHUGkfQFTGb0NUzqKhuwiUnEs+vGNDCdE4sJf8E3PtgzuTNxOKyQgbgvlavklVSoB4V5K6uRuPf8Iv/p3kfiObJqeQ/6f6+hpG9HyDLUAPUA8W8S0AXmRthqT4tqUp0kh1vtn2KF1s3KeLkKcmo2BbXL0s9b+hjw67Gpy35BnLpNpSd2AYDUzZFH5T6Mw2/yaVIfsIN5EKsAbpxNV8iwaZ0bDNYsWCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Oct 2025, at 22:35, Lance Yang wrote:

> On 2025/10/4 21:11, Dev Jain wrote:
>>
>> On 04/10/25 3:12 pm, Wei Yang wrote:
>>> On Fri, Oct 03, 2025 at 10:35:12PM +0530, Dev Jain wrote:
>>>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>>>
>>>>> This patch cleans things up by moving all the common PTE checking logic
>>>>> into a new shared helper, thp_collapse_check_pte().
>>>>>
>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>> ---
>>>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
>>> This is true for the first loop, but we will unlock/lock mmap and revalidate
>>> vma before isolation.
>>>
>>>> an anonymous vma, is it even possible to hit if (! folio_test_anon(folio))?
>>>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>>>> till the folio_maybe_mapped_shared() block?
>>> But it looks still valid, since hugepage_vma_revalidate() will check the vma
>>> is still anonymous vma after grab the mmap lock again.
>>>
>>> My concern is would VM_BUG_ON_FOLIO() be too heavy? How about warn on and
>>> return?
>>
>> Frankly I do not have much opinion on the BUG_ON/WARN_ON debate since I haven't
>> properly understood that, but this BUG_ON is under CONFIG_DEBUG_VM anways. But
>
> Yeah, VM_BUG_ON_FOLIO() is under CONFIG_DEBUG_VM, so it won't affect
> production kernels.

Many distros enable it by default. For mm, we are moving away from
using BUG_ON or VM_BUG_ON. No need to crash the system if it is possible
to handle it gracefully.

>
>> if you want to change this to WARN then you can do it at both places.
>
> It should flag such an impossible condition there during development.
> So, I'd prefer to stick with VM_BUG_ON_FOLIO().
>
> @Wei please let me know if you feel strongly otherwise :)


--
Best Regards,
Yan, Zi


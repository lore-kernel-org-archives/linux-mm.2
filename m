Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33A1CEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270D66B0005; Tue,  6 Jan 2026 13:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E556B0088; Tue,  6 Jan 2026 13:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A586B008A; Tue,  6 Jan 2026 13:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 029F46B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:56:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC77D5B9EA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:56:16 +0000 (UTC)
X-FDA: 84302444352.20.50A7934
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011045.outbound.protection.outlook.com [40.107.208.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id E73B940012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:56:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbH5kXhD;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767725774; a=rsa-sha256;
	cv=pass;
	b=KZKd7eNGODrr4twTtV7wIGv6gSefG/wgDPlZIsTgHxIBbxrXiwkqfo4rXYidwi23pErshz
	V2P+OkCWzZ23N1fzuyRUFBOaAsuYb4CvmuYxMBeSyw1PJWwYikpJqzFV3YTzgc2f53KPfx
	RRyj3JamVTtQHIrJFaXtrczeuI7m1Ww=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbH5kXhD;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcjTStmebVhuT5lCq+apVcQncXBjFDTmywcOfom0Zo4=;
	b=JuxCZv05yUgQSlyPG+QqpoXDhuJwWxaUPXDJYLIo92/NO+eD3yvLc2WU6VZRERmFWCId6e
	8rKBksk92A2YsoDD0iPB/mOIUP5TEREw59JXds+zcSd1pYnToztJ8SF/wxNPiKzuVzA1LL
	Sns1d49Eocxl9a0aaAySIO63avrPZ10=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBOlAuluu587aVYGffWDAVilylR4d15ObRpIFRy6rE6B8TvIE8/LC2cjGyIx6GKHrlve466Cj3xcKimY6bFLIPr4gDQ0hh8LlmDbxg5z8zqyJprpyEp8LNFdMRQ8HbCz6thK8pOYWaMR1y+eEslvWh6Kz5cpo7d29VFlDPRm/7YUS8F2mSle33tR6x0Lh1wUgp8uCuPwN63Wt7FcdqLVp4bpMq8x4LjFIoYJNinLfiVL2sD8FbO7KuYZomhvbVAE20GXlMjz1Z7po8BcgG0OYBekokKCIm/ljQUmoq17JfhzE1cj3z/qdbqn6MX62OvctjgUVY0n62K8HmChG6u68Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcjTStmebVhuT5lCq+apVcQncXBjFDTmywcOfom0Zo4=;
 b=lDM0bBzMqjo3Slda3X+/bu2uRF7+Q32gG5HYMe6uvZDjBH6hjpA5R0AjvKJ4rkoP2BV089x9d6uN49/zDicSdqpQG/qyRzp5tOI6l0uHvnjCtsQLHPa//qHtD2c18MeFRc0fkpHoNhRJBeE5uofZVv9pcxHb328H3hB33IpJ5gWuEF843QU1cIna4OEQsZQ7Kq1Uul8GmL/ryRCMzRWWI7YyLY5iFT5nCmszVCvzMxzJxZYFmjyNFHK1DXuNPDsxoOJqdEsM9UNWr+iUB2+opbnp6qanj2HLGPzrhe7d9tsRtI9Ibv/td3fVeP3bIXu73/S0ueEHduwDHrBPxOC27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcjTStmebVhuT5lCq+apVcQncXBjFDTmywcOfom0Zo4=;
 b=DbH5kXhDee1DMCGaoGl+pz8BQYTNo4r315/0/xVqq1DIIvza7/OCEZWDrKZsvr5EGGkn0vSM1M8kRk/tUtn8+V74mcfCd1/T1cOTQr6tyhr9JG3eYDL2TXlOou49dmGGjzltiP/LtrCl5JkGvIYC4/8BRmf6bqksttE3Xgl3ONr9NyVXLTTz3LjUNehjq9PVCRpnx3oywOFIcG+N7H6oaBV7N3BS8gEycUW9nwRGK7ofkUnfeoFktfM+SJntUqtm3D5AF9jT5yNpjPBG/J19qiEnvQKO/L19+narp5itvB72TcOOO6rG2agdKclCBaOyyTs1RFX1k1XsJmlQ8ulYww==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.2; Tue, 6 Jan 2026 18:56:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:56:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 richard.weiyang@gmail.com
Subject: Re: [PATCH v7] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Date: Tue, 06 Jan 2026 13:56:03 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <36001B4C-A781-4571-AE65-4C00C9D215FC@nvidia.com>
In-Reply-To: <9c807ff8-b4ad-43d5-8034-ec7fcd0fe5d6@kernel.org>
References: <20251221124656.2362540-1-gourry@gourry.net>
 <9c807ff8-b4ad-43d5-8034-ec7fcd0fe5d6@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a0fc90-785b-4eb6-95ec-08de4d5541a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hn3kBSNqYQZOZZO6Ow3v5ocwm9ax1wxdVkREePb7+of18tS2BWSnc2nHfy5I?=
 =?us-ascii?Q?wopXdHwTpOvEwbY1bl5eVor9fWZIsWshdA+/VcuEaKXqNe86EtptihMlCpSr?=
 =?us-ascii?Q?NwIv+skY8DBV2TKHrCOMVxOa+OqmISp8YCRjUykDocfe65i61qQlhbC2HHQz?=
 =?us-ascii?Q?1JB+3xD1BOog6OkGKWnwwlrxNOlm3n0MfVicgfhy7sfnqMVzcsQR/7jNvywS?=
 =?us-ascii?Q?irvO+uaTjpAAUMsClUQMFUuBz0H+/Ib5Qq4cQpSPL5oftbgEjoS0NQ+w+myW?=
 =?us-ascii?Q?MFkS139Cw09M2GRYREXAwbK/MKN0jYvd+yMoDE/lum7RXjFXwW+1jkLsK+Tp?=
 =?us-ascii?Q?ZMyHl5kA1yq+N1cFfY565emBaB/Pa6qjodIUdOj1jOkjiboojXWvjKSHsO29?=
 =?us-ascii?Q?ImnzvsTO9/iFkaJyIRWhEayMXefvD4mcwTqeQyKdj1bupHL5M1rVudfS+uBS?=
 =?us-ascii?Q?rCRkWw2IeMje1qjPz4QVX+qzkwi7k0Pb2tVJoAXvvrstTK4+qVz0D88wGF3Q?=
 =?us-ascii?Q?XgcEUHiDl5sNB4md46St87LZw+Wx3/9m+Qr+xHIiJN8R4tnDtD851g6fHj3Q?=
 =?us-ascii?Q?L8MEYeTHME/Oa95bgX6W6eRf6WAA6JND5fWasuGk2rAObUI81lf3DzpJ5nxL?=
 =?us-ascii?Q?b0/8mqqqPnJz8Vx7SccceOuCQ1K3MivIaKwh/hrxWMIbTmEpg4tdtG2RilYk?=
 =?us-ascii?Q?nXaX0NrKc8byNX6bWO7M+50axyEbnA/ckL0NQksdjKCYfumtgO/Lz61QncTV?=
 =?us-ascii?Q?l+CmEhLYauXe7pJbZ+a4AQ33JdD0OsN9n9l61Q2Ia9qpJsT+wDndSXvvUFUd?=
 =?us-ascii?Q?cEIUyz1wgd5+d3LoZjUF7woDzcTo/Snx6fGtHo3ckRc7SoeHi+TNX2mRv9uj?=
 =?us-ascii?Q?nOsgOqKpFQbdTtqyY75cMz97+IpieHc+yvIZNdPo1YZGIg7qe3BLPUb6hIbu?=
 =?us-ascii?Q?lMMZ4dvI2hOPu+w4VK17Mza0Dwj+CW9DxnruhmZTvjrNyEw+MfXXlya8AaBl?=
 =?us-ascii?Q?mgxYMuF+aIKHErXY3TnfXtz9ohT0uA+OuD+S4LECWCJXPmgZw1Mh5a+rLkoR?=
 =?us-ascii?Q?hDHpzTKOdndoGgXQHkoVHcNmuf/wuEPMHXh6rEbZr9wmDKIByFczw5mLb2py?=
 =?us-ascii?Q?SMkdBGKIhc/driG2++NrlRboD+dsgiIGjzhHJgfk+4GYhBvQli5DGmEle6RN?=
 =?us-ascii?Q?lCkBxiUq/+wMG0PoS/yqZD3bAA8Lp/edjJVLFiUNqeUJmUn+taRI0R+gnMvt?=
 =?us-ascii?Q?Qye0cPz4tFzqvc+1Yus3ukXFctBwGKBznFi/MdiZ4RIvYq/IKRVDo/jSM6ff?=
 =?us-ascii?Q?U2rLxCnw7gJnuFvjDjLmZKCpiaOgwkbzI2bHDP2zoGDz0fnsWh5yrwcDv2mv?=
 =?us-ascii?Q?3ncquvqWkS0yOv9afYQo0LggGiFrKbK06wQZhHst5WNlgTKpgOX7GTDMsLvj?=
 =?us-ascii?Q?QiCdHoWWHsJxFCsa/XaFARBf+pR1IEhxCKqu+928R48a7dqqZV91ew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c8P+FoLaO6uzN1C2edJyPpiQUcyHdp43r6Zm5oVKsfTY/yIEA8K3jan/jEP8?=
 =?us-ascii?Q?AXmXG35aEdEdJ6P8lpJjalIYYVSjAURza0aIDdSVkZ3EioPvO/zU4GVKq3CF?=
 =?us-ascii?Q?EAo8Afn3pZCYBG8ILEDuBUOYrG1V+Izz+8tkQwDc6OCL/lP96hFbhEGzlzzQ?=
 =?us-ascii?Q?jm3RoA/rabUw1WSC6voIkXLNYzn91CK5aRqyojbJyAxx8ZyMcVF/hGFafdGL?=
 =?us-ascii?Q?FTQjHuax8usK8VuwpAvrG/Jn57gW0BPrnUF9R1IB7+hciKBfhkemDixqPAbI?=
 =?us-ascii?Q?q58SNwrzh1RqvPNd19hhwuWy+Lf0dbO2xkZTJOJMmjJTAiA0PhwRNGU0UhGQ?=
 =?us-ascii?Q?OSfWbdjJ/DKboPlLuOnckIYVrOZtjiubK5zJZX3A9e/YtFGCDgQiRQ4bMdgN?=
 =?us-ascii?Q?pturOTdsi5IrZw42Ws311A8oinajLYqzzcrEo4Qfc01nuJO6dJssTUX7qpVL?=
 =?us-ascii?Q?1bZvwvfFN3sWjUpXeYlQAzmqMNs9LwgbGtvr873QGLiUdniKhBzMSCViG0y2?=
 =?us-ascii?Q?JE5rAQ08gOJLCiZWWjlE1Na7WWmxV99x1qQXCzuNvz4MXdS98pEWg0/LJ7GR?=
 =?us-ascii?Q?TB7/ZcPZvtIcsRaj6+LyF6YM3wVmUUCnOwg040so37sZQ3RNEMm4VaaVH41B?=
 =?us-ascii?Q?gSG5b1LV2i50sgvbldQdeF5xRnUARIHPOjs4pZP6vTv4N62R7hZUgLi0hT/1?=
 =?us-ascii?Q?k+ToUW/bm1KfanBTdrOyYSwv5bt4witPmqiuqaA8KPaYSx+t6vmhpVyOtmot?=
 =?us-ascii?Q?yF69K9Db8VKZQiLIkF4y4G3MqaDuZaT1akZeZTRbSQZOEJVRIo3GkjX97B2X?=
 =?us-ascii?Q?wV4g+WBeoejKUTybdspQ49hIBJ1njg5uw/svlB4EmlfqDQ4gD7+xNlAw750P?=
 =?us-ascii?Q?5veUtDuEuQNo1ba4sslGqQuV4NmF28GxLB4g41HR16DLuYIL7U7zAtdgertt?=
 =?us-ascii?Q?42CtCqC+Kk3bkwWR709jNjdJ3qqYLRLOXkzUBXNBVCU6k6ga+3WvBDx5xBkI?=
 =?us-ascii?Q?UkIxhWClaBs1NFnx0w3UslURs0G4p4hAPOCKYff0mT5mkmYtVu6QAxTlKHAO?=
 =?us-ascii?Q?6KDiaS0kBFEdaj7KFsRqW/aSJV7DSoIonpG7Yrv9sYd0SNvvti15Zmlo+j0X?=
 =?us-ascii?Q?qLI9y0xoBTC2RYJuIViUgeb3qVjkwNXOozy/LGphJrS1GmDAEFG8X0Smdklj?=
 =?us-ascii?Q?3u/2OfmUC0uMKxCvHLZThSXoTOwZMNQzzjsQBEoJ5ZPoyXY96ZZHoGsBtpn5?=
 =?us-ascii?Q?Xm70CqXUDxJUsxfevOeUyp9YSIIRCqy0fNCUcoovuUb3CJr/Qve4Lg3msDeR?=
 =?us-ascii?Q?wUg5PTAZGVhOEtjAbXmjUI6sOWOFIEV2dWS9CuYWink0TKbgXy30qA5TtS4Q?=
 =?us-ascii?Q?tOtJvgmCIApuTR2OcPYZoL/T2/zEtCtN2FtKNKc4oMNszRGAJHRz2YPMl4Pl?=
 =?us-ascii?Q?Hu7SIur39DiIToxrYhm7gvjRj3imXQUutYCXK6p1kH2Cjcve+RX12//OAQ0Y?=
 =?us-ascii?Q?hXk8gZtlklNuwDEghh9rKYeU+lu7U/RzSL9AJVpa+gXx5HVOWGwkfoHzR/zJ?=
 =?us-ascii?Q?IsIuf1LzZv96mq7bjy6U5sfqQBgzhGexIGnwdCMZzNjBOjjftpqdbsvtlrtV?=
 =?us-ascii?Q?O2Vt/ZX43/Intdvx/iR57nzpdFECWYjKR17eswry1Jqus52MB+JD15ZBOqFu?=
 =?us-ascii?Q?RdFtB6o0gMv1UiMxZgeaUiVyC5gZef7dmzEYb5ozavTwB99k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a0fc90-785b-4eb6-95ec-08de4d5541a9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:56:10.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drDLECYsK+xV6IkhXylSgBdAiDolKLf++QDmObJrNsom1AEVbZh0/GPX9aNBffep
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
X-Rspam-User: 
X-Rspamd-Queue-Id: E73B940012
X-Rspamd-Server: rspam04
X-Stat-Signature: c8cmfziq4bpq771tpbi9cmce7yhc3m55
X-HE-Tag: 1767725773-795151
X-HE-Meta: U2FsdGVkX1+BBo915Xj/5Phlqw4TJDuus5IH4rJ/P6h3kRgW3pcAxZdgj//5U1qyaLtYMjvNQGGPcDfM4mXan+gW56ISIGpfnPJN8jg1Kgo+BwWJrOdRHuQk19WH0M+Uzpp6azxU1WgFdlGNSLbD67a0ZPWECf4GNQqY11ojO3zwFGwaCtALkdOBI8I7ybrcb53wNpqWsQ++C+BLRrp6JQsrl0j3JklZHKkG+hmYslAHzb08rK0rY/SDv/mEMPb7D9NB2mIE6sIrTpYvWfsV4qv6hbN2ylYFx+NPkGyC/dCnC3OGcRy++WbCgHYR+htTp6oPvvJVo7cGTyADhkzck8OMwofwA+YCWbHXTLq3c8be0CQcK5F0GMT9yrS+6TkQtB7pDSo9cHqb+oQJR9PIhomQO1GdEnAetADn19DnfKRteBGFkaD0t4Q+5NNSGBjJzVAOTmnzT/2dx7G3zfUkr7My5Xje8mA7jk6Wveo5f1+vZZFwyQaXQn/RNtGHQvXtad8T0MnKMfMspGpZvwv9z8yr3FbXC1ZCdqYB9AOKWH/RiZME6lFJfgiAuMznJKV0JGwLntuORkjO5bbWbZURvS/Z3oBqVggQYJRM31M3zEoS4Bb22+Ds3QG4a87V8dyJWSMx2iizEaobd/uaz3plbQQ0+90jmXobRVvHaAr4TBxQPMolhdqL3aMS8SdfASuUP3n+HXew0TGrskVK/KpOW2CuDc49ntFCxrNsEGStzGGpB8tmcwq6Hp/pvCxwPW7nx1AF7+YLcweGUOzq0XjdJu3Th5M0j69V6XZ8rzfN4XqJrbTG752br1CUWR15Tj6uepG7orlMRoWRRsHpnm/x9P01yzRAuTxU+3AZyI1cTIlxuiWQZUuIbMUUWYBXizoYMfSj/LrlK8jWgYwoFEpEHyWKrjIpBjHd5+rBxgaaCWo3nkbZbea0cxy7uktqhjVx6lZUXpzURQP9YfuOT49
 YlFvH9na
 ve17dBJYDyHlSFAdC5eLBuUyVgzxV6P+MI2TfGOuk5BTZqWFACsnwN5yK9wHi1qmC33jzyND+QZk+XfgDtj8P1aeLH3rYHkcdrZUHVCqfGk7Sl9LtvvepDi8Z7CfOIU9w2gCEknV5PgVsk8SVkNPlezN5wTIG6Uy0LMb0KnwMJF7kMaP3UDw7ql7nBefYimf5TeDHlqnc6ooUMgxx57DOgpm/6W1+bI7iciE44XVNMvDfOl1d+7jzx23UBsTw0/icNJyldKoMvohfWy85aK8/VlgfIU7qPRTbrMHI0K/97D5foCqFeqZkvPN6gT/uXHOxuRaXl6WabKxvrJHEIOjZz65J2eDUnE7HbFWU7tmyBHkrHM8r/ktD8FFgMAL5GttEjdnfgVzVBJ4sgmCxegyGIsNubv5OHS5/+cq1d7hNUedrlxbZBTOq2Tokini3RlPbOiLxHWP98FWJaaUNP9svPPNF04p3DjbaYPsuoJaMxlwA2bE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Jan 2026, at 13:46, David Hildenbrand (Red Hat) wrote:

>> -			return false;
>> +		/*
>> +		 * Only consider ranges containing hugepages if those pages are
>> +		 * smaller than the requested contiguous region.  e.g.:
>> +		 *     Move 2MB pages to free up a 1GB range.
>> +		 *     Don't move 1GB pages to free up a 2MB range.
>> +		 *
>> +		 * This makes contiguous allocation more reliable if multiple
>> +		 * hugepage sizes are used without causing needless movement.
>> +		 */
>> +		if (PageHuge(page)) {
>> +			unsigned int order;
>> +
>> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>> +				return false;
>> +
>> +			if (skip_hugetlb) {
>> +				*skipped_hugetlb = true;
>> +				return false;
>> +			}
>> +
>> +			page = compound_head(page);
>> +			order = compound_order(page);
>> +			if ((order >= MAX_FOLIO_ORDER) ||
>> +			    (nr_pages <= (1 << order)))
>> +				return false;
>> +
>> +			/*
>> +			 * Reaching this point means we've encounted a huge page
>> +			 * smaller than nr_pages, skip all pfn's for that page.
>> +			 *
>> +			 * We can't get here from a tail-PageHuge, as it implies
>> +			 * we started a scan in the middle of a hugepage larger
>> +			 * than nr_pages - which the prior check filters for.
>> +			 */
>> +			i += (1 << order) - 1;
>
> Assuming page != compound_head(page), you'd be skipping too much.

It might not happen based on my reasoning[1], but feel free to punch poles. :)

[1] https://lore.kernel.org/all/7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com/

>
> You'd only have to skip as many pages as pages are left in this compound page.
>
> I think we have similar code elsewhere: see has_unmovable_pages().
>
> Apart from that LGTM.


Best Regards,
Yan, Zi


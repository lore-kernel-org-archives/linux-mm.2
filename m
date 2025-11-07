Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12808CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 00:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7300D8E0009; Thu,  6 Nov 2025 19:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707C68E0002; Thu,  6 Nov 2025 19:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F63B8E0009; Thu,  6 Nov 2025 19:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1418E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:46:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC4F81402D5
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:46:22 +0000 (UTC)
X-FDA: 84081969804.10.DB9397A
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013054.outbound.protection.outlook.com [40.107.201.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F1F2180002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:46:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s3hkyAyG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762476380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmeNYfCv7R9sta5cVPf1HQ/tJPHHmrBVOXaBWWk9jTE=;
	b=PlSVVD5BEcPn5mNPRCHRPkFXm5CsYt5wc3vwqvItcFj/cWSGaCioUFuZWjgQgtWd6uC2Lx
	lyI0NLGEp3WY9joP3Gy3eL2XD6KUHo26AIUksuaFOTl1ANtTnr0nXwG+YM+vpAAUndbQmz
	AHEpUw3ehDTX1sC7tCXz2sFLvyKK6HE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762476380; a=rsa-sha256;
	cv=pass;
	b=CIi4cNqpORNqx+7oUsMTJmz14j/gx9V7/7GfDTGALodrH/2flSd2V7Y1hobQhJP7Aw+WTs
	blmmDVLwhB1tEEE1cYp61dyfS8BHD1gfAXAdW9tQr8C6/XnXl2QjGw/kdR3P6R5XvAYqi0
	wFl+aN/FlqhKknRjblKy7NOWr1ZCwDQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s3hkyAyG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SzxQTeVWL4i0O+1AZZcHB6qVY4Hz20SWODbKkW+OePKYs/N+cTBA+IrHl55mEZxZHHJCAj0aMgZ+Qf2bD4o8pv8YHxG/RFSDypgjedxmsbwwNAnonbMOTompESCHJVYH3YmF6Ho9ihENlOxAvVIcVy9y4d5qp5TZEWhT+zEpxySfcnKBLqT0SLuw0l/cTvYYVKjW7YH56PeDUBQjUKF9yMmAM9COeXeYE73b77Hly26vSEPZBbOBgVrKCPcLidLeHkxg888PrUQq3Gfja1B31gfvCdzIPE9tzhs8WQShi0ysRLverlKUTwgS4K61f6XHLXJBdiF6b4TkIdJ8PcuosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmeNYfCv7R9sta5cVPf1HQ/tJPHHmrBVOXaBWWk9jTE=;
 b=KHJigU6j5tmRZrJ09g6Z9PKRWEkBaUybLj0CTiy7TlK6yNbcsamWOLJ4IRYOjAO9fgVIB3AEUKimqEyraGm95odHb3v5RJHhr3YNPK2nbwXy3C0KjD+GC3eoX+QDCTk9+Rpc8oo816NlvScl2ybise/g3qyEIkSHj1VxVJdXXDASUGKsoaBo2fb1iTRmTcFGHil13MD3YYrSgAEHcffemjRdnAywyQKxWnd3w13FBkZIBRaT1chgDYTYK3mletBNY3lQ+GMLlnPSgYBjYKYu0OOK0mJvh0a6eFgv2LSXyq6B5mHAyn/m1Q6xlfCoeq3vv2IMf2gJgOIk2e3RWOxnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmeNYfCv7R9sta5cVPf1HQ/tJPHHmrBVOXaBWWk9jTE=;
 b=s3hkyAyGBlooGAuqouDX55NfGmlV1+4v7UfXBPv1cDD5fFWjQZrvlS3M8FCgpv9L07DYjUcy4AQKiP9FRi2Xx0vt2O8O1NFBcMgnzosYl3ht9EELy+0CZrUiyZ71IrLKsS1WNlyEVHBM1+PUy15rWB2VFm0BSHYWM7+0yKhp/jdBRJbsp2sAjbJRT60fgqgxyQAJz2R5nEUfjIYhePNU9f9LExFGqbrVJXj9kuvpCbdnC2dmzoF219XWlZ1vy3x97oJ3MJ4wvoe7LCyr3Fw1/ie2yybG5DmITBHvGb1vw2aQx0qFKKZvj15TuTddM+s1OgTRM657GerhTB2wyekLiw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB9530.namprd12.prod.outlook.com (2603:10b6:208:593::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 00:46:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 00:46:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Thu, 06 Nov 2025 19:46:14 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <0D94CF57-A9C9-4C01-A9E5-CE47AE3F10EB@nvidia.com>
In-Reply-To: <20251106034155.21398-3-richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0047.prod.exchangelabs.com
 (2603:10b6:208:25::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB9530:EE_
X-MS-Office365-Filtering-Correlation-Id: 15d3667e-f3c0-4ca3-e0bd-08de1d970f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WnAmJLkgWjaWWymmRFSs5LhbbLHSoTk4mD/dEY7uzjXv0q4eVtCJV2LTqa78?=
 =?us-ascii?Q?TDJLoSXcJn0WhR6+WbKXNOX07JtqefbuQPSzaGnzkAsvIvAXvTRs3rKwz7VH?=
 =?us-ascii?Q?lKjhlh7BsWWmuE/VzgiEmQFZWucBc+NhGZcg+c+OP4vXC+lp9HTWoU5Gv++q?=
 =?us-ascii?Q?//ButWUyukT+lhoJCmD54sDv9gDd0RuHp7GAkwEjW1Nt4bPc0wDYduC6znh8?=
 =?us-ascii?Q?G/c8ji8nsxoqChvlEe1KnU04Ebe23wNFpYqXIys4Zajuz9FyWAW1AtCYzYUo?=
 =?us-ascii?Q?ducf+akpquXEUHxQSWP6nX73nl1yq0wJ2HG/sdtJdMXvjCwUz8lMzL9aE3ej?=
 =?us-ascii?Q?bDW6pne8EQzO/9hMifoSJSN9PEhsFZH8rGSRQsLMcP8CUROVZ0L3x+7mi0SA?=
 =?us-ascii?Q?Pjvu/tDBIc+Q/LmaZAqnD86EUZ8rUwUlkz/xHuudAp0w5oGBYf76EjPTMcYH?=
 =?us-ascii?Q?VABSUvQZJgD+cY9UB/XB0kbUXHFKedg0zXjJjEW9qQfutkh5jtR/NbL5W8Z4?=
 =?us-ascii?Q?dJjPDhZtmWQKviudsplOjwNMBB29raXYzyyqY2neeYmkwb/Mkw+ugRiXWEQ8?=
 =?us-ascii?Q?zqPdkDmcex5YdAXh8YTZ1/pyEI8YrJb6qjmuK6RqgvM889NAnRp6eAUdyn9T?=
 =?us-ascii?Q?5BmaIeZMUomRGTAfH52XhEJJnvVJjRK1xko5ilG0Y9g212dohsNlVFPHKcEl?=
 =?us-ascii?Q?odS9VacuXReZ+4xbvkmM6LIvnd93/x9f3kzlCEvuws4ujy0TOVurGZ3bpgT/?=
 =?us-ascii?Q?2QF0rUyicdmwW56Jak9IJ5tMXu4QHNFOHTFMouCh9cm6QGHteIV0xLl3CrHT?=
 =?us-ascii?Q?swNK9koyFIG4lSrRWCDNdZ5MkEnDfI0rCnQ8WuG8r34a1NW5IrDfPP8qAaQJ?=
 =?us-ascii?Q?glbegolQ/u6NIKiLrhgWAuUH+269cV0MP+FNBj0VB7tOgfkW0h+VzKmk8laa?=
 =?us-ascii?Q?eCQx+Se9PeB54oB8mZzhcgql3jwP5n7jjSpc7rzAXiUrEFKNJh4nJHaxhEYk?=
 =?us-ascii?Q?LALRu7z2ZPhm6MoB36nbY9ti5koP3G8efEbSk0pAKPstdiKUHPKoU01NfWkz?=
 =?us-ascii?Q?gIuFyFcbV0yWJIutuIfpjkPpfAKZV+aCyGjzAA6oKJk8PWLcMQ3+/o3qDfVk?=
 =?us-ascii?Q?sHqGzU4EORfNoHwIpgvsaXIf/FcC5qWTg/JsupyobshRGWjpKsQ9QeHI7EED?=
 =?us-ascii?Q?YbrzVZBmb7GEULU9jZCQd7b43PTSqOOUAVguV/8Scst3LxXWYIJJ9EPsePfb?=
 =?us-ascii?Q?6kTq8lvBPdgUVhWJ9EdZlpyn/tXMXLfNCDB/NBkDM/wd9KyroOjVBQP64d4Q?=
 =?us-ascii?Q?xBY3H2gry7m2bVa7GQGeMvt/h7PqpzOMQUJOLdaJcAsoQ8OYVwa+aA5Od908?=
 =?us-ascii?Q?+Tk3BU0h+vv0//BRAFCAtlt2XhKD2aeXdISUwBfhUi449i6x5rfhDnvsMvpM?=
 =?us-ascii?Q?8iVpd0hdwx5WlPlgcvVoDj2/9u8sMytz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EIdLOgcK/Hi9cPbenc1YwH6hafq/I7zLDqwpUjhMTc3LqeIUuZSeKvoX3d7j?=
 =?us-ascii?Q?zsPvN3IDhLFth/0Q31TreIjC3ufmPJYTFx2gwHGLzDh/ifUQGKWvalCYmoGT?=
 =?us-ascii?Q?1ovTwAbxN2UhT/RwbhT07RRsJymNEGKiWxSGp6ydSMFoENErx1nRqKY6YKpR?=
 =?us-ascii?Q?Kvhzm5DdS9O61dlShvdYLcELfP4KWQxRYIfTprn985mXtmeagHCOtvdPW9y2?=
 =?us-ascii?Q?lIXizIMEPCmGl4SJPpIuOb0ooTJsTADpW90OdV5ZZppX3yMNfV/Ro80Tr0GN?=
 =?us-ascii?Q?E+EGJGYs7zUToe+bDb6QQyoLxzddBL8u/uU7JXY7I49PjGPVDbR8IHJQEAdi?=
 =?us-ascii?Q?0Z+SrU0u5H5XPg8AIrM1CUObOmstQHZrMUUYCkl0xvLFhW6uFzFv9C9TqOyT?=
 =?us-ascii?Q?cuel8uPtFLRnC8p9sfH7TUpXF+JzKfbhwS5348NZq9TmuJ9GBjwe+MgvIwx6?=
 =?us-ascii?Q?oZmSKyZ0K3PLkzhSitT2Xjx0MKW2oYDKQzNpxPWu1e0b4zvdvmvt4CXK5jEB?=
 =?us-ascii?Q?sFWKYmgcO+33TqLK+WizPHRmtc+JAxF6WZmJKKKGjBLX0FK26UDg5YeZbM9a?=
 =?us-ascii?Q?kGS/7DKJcczAOBf6c+YMTej5Z8vRjzJc6AO5gdzqMtaD8bECwuJbCdog910S?=
 =?us-ascii?Q?n+2HLNY8h9ZydvbdGVEcfRIDd5IvMfDY2len8g3IoyPqVaelXsdX2BJh4ql7?=
 =?us-ascii?Q?t7sBerVQLpNU29frKUo20Z1b9xS933nfYCy6nGFD7jz11mZ9XotUU3weT8tD?=
 =?us-ascii?Q?UVun+5eNBjfs484PlEuz84GAy2obT78jZ4p9iaMhUOqmxESFmjyLIsDR1VMT?=
 =?us-ascii?Q?T1X2CThbVgSXMIBkBadPjwG2uiI5nTm1uW0ef2FabDZRDRH0TeUY4mhp1v2E?=
 =?us-ascii?Q?Qbeq5DhV/WF/JGOvpJ2uKPVxLySTkNYP5yueLc1RTIUziMphLSVAMNpxUeyS?=
 =?us-ascii?Q?SOMskfPx2P6072stdfNDVeQBwTs1LC+iP9iKc6NI4yTFiTohorIhJb7u5Vya?=
 =?us-ascii?Q?u7dzSxaOsbyfBtORvmJbLfo1TnoYxklRkXP9j+2gYnzAilKe+KDJ5U9DSdqo?=
 =?us-ascii?Q?cbnzr9iAqwL449qIwofj8+KSgzowC2wdepmjpKsiC+c+nNn0uYmzayHAJgCM?=
 =?us-ascii?Q?J15E6cofbJZePGfZCQaf9IifDzt51oinemc0JqjZrWhEAA+UNvOcH2FUK5Ya?=
 =?us-ascii?Q?azA1o5v+FFsKc/cuPvB2ALCfHSG7jL9+4u56Vxf6yj1QNCLY5LUWYXvWWIF9?=
 =?us-ascii?Q?FhhWk7mLkP/aByt/zulCe1S/frqe/5BRYcPECZE07t8GuBNsfRqFgmxsFJir?=
 =?us-ascii?Q?2fSuaTgeT4ixyasiY/6SpChTWGBEAFe8wOcb0Tizohuthe1N8VvCd9SHzzLZ?=
 =?us-ascii?Q?2BJGozTrk1n0zYu1f4OMS3TPVYzpcMUDGmVh+ST6DuKbRZPNQDQxXwavv1NF?=
 =?us-ascii?Q?pQdBag9gv22dofFMjY3oIM4jNybSW1/OoMhnN2DXBtFuqi0qR3vK/Xb+aQax?=
 =?us-ascii?Q?aYX9V8bFpjZm9U9oEssITDLCPFZK/fSVH8viwAjBYxt7Gtddi+WyGQU6UyC0?=
 =?us-ascii?Q?BnZbHT1+3tKR4A+BCCDouFdeFw7AdvyAz39Q7t2m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d3667e-f3c0-4ca3-e0bd-08de1d970f0d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 00:46:16.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJ01m9PAXXjzqNG7wyw9pmObEg+IaXoEB6/oUqdrKq7jjPtSkuokYHhsFua+lr3O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9530
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F1F2180002
X-Stat-Signature: gz3fsgbch65u1t1nryjgft8nn8jrm618
X-Rspam-User: 
X-HE-Tag: 1762476379-765624
X-HE-Meta: U2FsdGVkX1/Ugxm4mwRqp28PjghxXIRjd8vUvzOyy69zB8aNYTbSMxmrsmtP8m45h02p8VtcsyCJRXb9UoXIRV7InecF0Rk3WIoQ+Z4dsoLGF7IF8ugJ2hnG9B+q7ihw50t5LD7mIstQQQNfxCztJWMqDZmI1Y5rfNHWVcTZBqFbY9FOgyOwkrtpSCMfgvJswYDI1baLzMBo0Mr9GUAr4QGEeJyT11IDudSWTGYd7qDFnUuu/OJe1m2cYC2YKFUZVMc1tbsCNpY6yp5mSZxCCTR0h7FnD5JGBfK5CrvlZMC2L3y5xn2JsChu+LpBWfrk1jiw728Zm3UpSlQdT3DruVUwY+MHoUdNZZcVi/AJPu8XSIhYEvVwVNOQQUC5tulu+mXJur/ZwZDddinpA/Pj+/WiaVyho1a642nP7tiYu5Nqf89SxBQeeOaX0nwAvZGq0vAvaejl7daCVriU06WmsDB5nX4oiLsrH79NsRAp3KMTKfXLn03mEEzTyt73IZz/uN8NXtAdii89So2d3bMLPE+WE/ierJxTt+mRDuyDDFaoEkssDxwTeht2lC97h1Cxo+q8iH4Jt5SmIQ1Yiiwhu9NMT/ki8l0AaDU9LAZLbEGD0ZfDvkwWgj8el7rm1Rf36YD/+qAthPfjEUOMrI5AN8Yz50R2NPlN2/ozE8TxTzbx59TCSSTwMuUUvkh/hCw7s82y29DpVuD9cNqFV8FxGsZ2GHhQ47aOV8uKimHVTbPgt/5bYRPGPpdDrJod2VQHHuF3htQksG34tszc/196StkWRzJhjEifnGNmXlWYYyQGl3EKGRqgJz3sD5Z3b7mFoYEN9H+u+ySQtZH7TTyfD6Y0Hg+BhpO+Ezqz+gPURnAAuQ+VCK9m7jVKYtCKI7hZiBR/t/raByn1cOiQlDcC0uITDvow7J7jPmT5XVc0rLMg6ZtCP9LwnYf/WF4qAXdaOJnFTKWOgVSodCH0Xfk
 vWfy1DnF
 dj4OOfIPBlcmWLJqVSAWxLRPUJ6umCdDsBFhi/lDW4EzEYNESBdU2341cN/5f7PN/4mh7Ih6eog/bNlEll6t2n0Ec1CpCYUNTgvKgqYjmqoWEsqswC5W5DfR9r7Gj4izS9uOcsLxe6njhP+3AT99gk0x1YXvBlszZdlKvb5pXW/st/CTQ++cng101/ndfAuI+96UppcWcXRus3uXNqruV99ySEUABLVdgobBGZNk0HO8otMWpDz9iUHyBVUpy/wL5bv51ukKpMf7yL6DUAtDGd2D3k0zufZZpxFx02lKAaIUgHJ7jRitc+wyPHfwWkSg8OJHOxJ9+giWNG4QRbdU0M5Iw2IriVhBFTkX8RZeHlKrONZcIc4LnbJVXqYY6QP34nAaAth0i/SVgKlAp+z5G4dZ5yG5yMHmycMjtl9oOr7vJKpDYtZzMzBjiJkvh/ffP5j+11GhvSKEr4hp3T5y+fNsvZasZhRxZYsAQr8+FfhD9p4XcyvMLz+D6+1mhKnoSEP+C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Nov 2025, at 22:41, Wei Yang wrote:

> The functions uniform_split_supported() and
> non_uniform_split_supported() share significantly similar logic.
>
> The only functional difference is that uniform_split_supported()
> includes an additional check on the requested @new_order.
>
> The reason for this check comes from the following two aspects:
>
>   * some file system or swap cache just supports order-0 folio
>   * the behavioral difference between uniform/non-uniform split
>
> The behavioral difference between uniform split and non-uniform:
>
>   * uniform split splits folio directly to @new_order
>   * non-uniform split creates after-split folios with orders from
>     folio_order(folio) - 1 to new_order.
>
> This means for non-uniform split or !new_order split we should check the
> file system and swap cache respectively.
>
> This commit unifies the logic and merge the two functions into a single
> combined helper, removing redundant code and simplifying the split
> support checking mechanism.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>
> ---
> v3:
>   * adjust to use split_type
>   * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
> v2:
>   * remove need_check
>   * update comment
>   * add more explanation in change log
> ---
>  include/linux/huge_mm.h |  8 ++---
>  mm/huge_memory.c        | 71 +++++++++++++++++------------------------
>  2 files changed, 33 insertions(+), 46 deletions(-)
>
LGTM. Thanks. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


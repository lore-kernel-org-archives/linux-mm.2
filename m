Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7036FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9948E000C; Tue, 21 Oct 2025 23:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1738E0002; Tue, 21 Oct 2025 23:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFE38E000C; Tue, 21 Oct 2025 23:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB0958E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:38:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 568C31A06FF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:38:21 +0000 (UTC)
X-FDA: 84024342402.14.AF7544F
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8934F120005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:38:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZcOuBWu;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761104298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9Zphq60Bv87ekU8ZIHSkG1avigDuvLpJBOtU9M6jN0=;
	b=hljtBsvPAoCeDa3Gd6qnGKrZ5Gjp2ieLQuhq6hqz/EW8Zs34OnYc+ACUGhImD0rx3oKd7/
	c+0fAZGAt4Wg1NUen1q7qMTrygolAaFEE937nVudTLqh1t7j5abhSu7uB/ko6wqN+fMqSE
	6Y0D+phb1aQhTWqwNkH9t6bjAupWKgM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZcOuBWu;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761104298; a=rsa-sha256;
	cv=pass;
	b=skwi1wYr0lBvvuR720xlt6EeMmql8HxAPOIoXQlgyFI9ANB7g+DDZM2B0xGouXK3wUAToQ
	bgZAkL44ReeBwlm4fVY8C0iQakjKNA2nbWedE3OIHMq1Lyqbpcnr8kbUprDkm4UNww2Pua
	e8vY4qqqHqTmLHdMzI9Oi7C1HoeNay0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o4mIM6iAjGHlV0Czow5SGId6I5WX+4rU7YsnZY9X83a6qB8ZsnjrlpQ5+zKNGka3WKdnf8FL+B62kx+DcXBXnzIUPQ9K1SgcaGr/oCCL9Ui2zUweqr90IP+Wl/66hGxcmzP+J650A638SXZBJe0lJlAuS6s3wk8nrC7Od0ShEo6UwZDbbjWGTGAhCkC409ox7wow89WDT8pBkzDO3GSEvZjyqlHLq9/XBfWUFyf9grgV9Z9WzG2LqVQ6bA3WUsQHpS9MJM8HeEgOV5crb1dVYoC0NNVcnEmqj7TDea20VYB2t3jC9zBEIdOJqN4RM5B9uuhvBDJum1rH6F0mKcW+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9Zphq60Bv87ekU8ZIHSkG1avigDuvLpJBOtU9M6jN0=;
 b=RZGTPjR/9Pu/YgQye6R4XhSrLWYlgu4F3eudo/Vwhll+HLk9jX4CNyyVGu4Cgya/WlN3AlHxdl+7Z+R3p5DaDAK1XkbMXxPCcELO3WLoF31zj6WkU+Ktc+XXk3JPh6vsQkrZkuPpg+tf01QkJeGbqeyJBtfu5FKI35WXQK4OF2IyCul8Dv8jhGQFZ9uVs6V07/ezUi0qkVj+7GHcPkK5/iFE4+QYoS5DFaOBm+7uVLgqtK1NQZ1hnIGwDLJeWXRfehXTiULhO8YAhdMuWe2D5m+wB3lyO7OnkNSJsQ0hyhXzuYkAtE1W5qQXzE09zTnD8mqiZCoyXTFkhHdN4IPnlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9Zphq60Bv87ekU8ZIHSkG1avigDuvLpJBOtU9M6jN0=;
 b=XZcOuBWuPlO+3GdrbDo8hdZ8055KCKuAeeTgsya+/LCFK3n3tpEkCnZ+AffUEZtlR+4aZGZYWwF1AinxPtfr26n8EzTswiJAFaQQ6/S1yWfxGz267+wCjBJ6JWr+NqUV0y3xA3G8AG17YVS+ddVloFLgFM4zWlRL1UZ2rcGZ3dFCjc4G3f9iwceNM5XEuypn+YMEt+NRxt8hDSk30tSyKSaMG21pgK7NI1HxxBazW8J1boGbNSFArqXSYSjcoviysSLVNftjsUjsCwuVtGInrKKkgYYLxZsz3ztr3ZMM2nquNhe3E4+U1wmdsFhp3uOBspjLl2tw4Zq6diaqygWNZw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6268.namprd12.prod.outlook.com (2603:10b6:a03:455::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 03:36:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 03:36:49 +0000
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
	linux-mm@kvack.org
Subject: [PATCH v3 2/4] mm/huge_memory: add split_huge_page_to_order()
Date: Tue, 21 Oct 2025 23:35:28 -0400
Message-ID: <20251022033531.389351-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022033531.389351-1-ziy@nvidia.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:c0::42) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: 79af32ac-c360-4544-6cc2-08de111c3b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dk6nv3RYMENTJkzE9S8k5VIuFozAwSdiKwCz9hS//Dm/KWWJQ/gM5LZCJaa/?=
 =?us-ascii?Q?jEpNEw63YYoMsxZlANj7eDcNr+DH93vzYaGP5ije2lC2XqL2XXLpKMO0Hvad?=
 =?us-ascii?Q?sx4rg0VbGa4+UsA+IIiK1EYlSzUE1gnSd06JyfbIDAy6LAEdU0Krk0XcmToL?=
 =?us-ascii?Q?UQg0/fvUqCr7Nbs3GgKh2UOzWxMgQmTM0dQEliuThEQg6l0DOcViJsp7495n?=
 =?us-ascii?Q?Z2jeDXZtYJqu1Z8XsqW4YkPoCr01p2uQg20pVDBIEijomTEZ9CtSSUYwH9Nh?=
 =?us-ascii?Q?MTEAz5hPVY6aZs9SQ2DBnOvKPZ9tSWy8KG03S+1JYJewnLu8dWjVo+FyKvdH?=
 =?us-ascii?Q?1f5u7p7DM+2nkAFhheANx5e7WWX32Taml/wnIvAMK674b5Gfn3+hP/sb8L/V?=
 =?us-ascii?Q?uUx+6No3SVk30xvAvrYLoC5EuUtCw3QhhQe7qn137O5rddse9f2HllTtM7j8?=
 =?us-ascii?Q?+wDvz7mXkBYw3EgTe2bmR+O8wVbmJ6PoTtjX9IqQRX/uMG9LNxLGeH6amDz0?=
 =?us-ascii?Q?Ro+fk3OilLaAC1qMhugeM4EiPOumWNNi5Gk/ChKqJvuYXM4vx9Q35HoBPW8S?=
 =?us-ascii?Q?KPQUC6bj4eDaFJ6N/Wo3bRtkZzo9ckiu4iq52HH6927jh6Ejtc9WdgkvwuG1?=
 =?us-ascii?Q?scPyyO6OgL0BXbVLm+qbx9rded2PAZ6P4h0ojvgVbiUD5q23IqWq3esSyFUg?=
 =?us-ascii?Q?+KRSJQBaqQLiKXxCySB317iFMd1CzdC1YIHLxj+hng1ErHu/5tQCjQ4KVa8M?=
 =?us-ascii?Q?SzAqN/WZ9OAqLStAroYCNnrYIRNL0CI/ZvYLfhObIXXY4s/rKY6frZ977vGV?=
 =?us-ascii?Q?gmYb5w0Dcsrva0/mEAyA+k+ohp8qj7LLVRuCCiJ8YZ0i4V0I2j6FbKLjer7Y?=
 =?us-ascii?Q?1pV2tTKfwD6aVuNwsbxierdW8b92DztNs5zR7xzFUWqy+N4akXRHNSFFB3H9?=
 =?us-ascii?Q?dOPPatI1vvF4aqjSXtC1aExSOewVmupMQphQGkDXJh/0HL3ylq4iNw8JPi+y?=
 =?us-ascii?Q?30/vu6cK/6fEk+9k58vOPOasAcubYwOsaBslOp/Kk2f+wK5uhenXKySqjR/r?=
 =?us-ascii?Q?MFnlQxpjbDKpk/7oW4KU/xA3ntyhB4MoDAqyPTP4ZXCGAlmPJL/XDe48cRbr?=
 =?us-ascii?Q?RfJ7l+aXExAu2CdNSgHb9xhbpFLhYXsa7pTS6Qq4VoDwnwBP4h6xvi0N52/k?=
 =?us-ascii?Q?CXNZfDj8jC4Z0P59YbnYFE2HIr+HZ4ZS0Bt575ZViSxPMtC7t48iWP3R+Vmk?=
 =?us-ascii?Q?/UDDZDYPIZHFf7Jq+KZOwlSWzQMkzGS5Qr6e+KCg9F7M0+eUio4D+bfsFWv4?=
 =?us-ascii?Q?9YrshuGrnDcdYrL3eO3eg/lke0IL/b0oe1edjYB6MAJVs2XdIf4tFnm63Fvk?=
 =?us-ascii?Q?+iIhpWIeWFT0+UoUu75i8G5fXZZk2vqZ03yZBX43M6uDegC2esxVcgv8tm6V?=
 =?us-ascii?Q?m6UaRYfarZjOOWIO5a+AuFUGZ+HHJwOs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7OfP3tM67M1iUsykY371OP0ffntxOtMXr9S5os8sFWR7/ok2QKZ/qaCe0AWG?=
 =?us-ascii?Q?FW689G375dnMhvtXMtmMPvHrV/gOFW6sPnZZ82G1XlZQl9hWvb8kyF8bLacb?=
 =?us-ascii?Q?t0io8e5qqCy8kgTZcig7q/ytBP2fYuy8XYXsEa8jLIahF+PEqZziNrN2lftK?=
 =?us-ascii?Q?e22MPMFifHEg8z7+f1D9lHlhO6BVXSedzivnqypv5gvy184ejntjciXxx5Ph?=
 =?us-ascii?Q?qSXPUGQKL6FptoXt3neH3gJoGFEb7WcFyLcXs1atagS2CyJVTqKWSkJF9OFk?=
 =?us-ascii?Q?c5D3k4oh66jgfT21kA+CeS04PEqVyhBzmxqXpkrqfk1mEAcNoo8eb4yBkus6?=
 =?us-ascii?Q?9wTtJ+vrVCsbfBRoxPVNVYzqjpEfKTFaa/w+GPS4b/i89zfJeg9M8G4qtjKj?=
 =?us-ascii?Q?SCWIvmv7i8QzzFqqxaDPIuWfCqOueLk3HqSWTqhx08WecnUChf1xATwvAg/V?=
 =?us-ascii?Q?Ts8be1dGGzjXAnsIEF/hgHx4RzEm3Kxh1TqZVb5odUBkHeSPeTg61+XeXOMJ?=
 =?us-ascii?Q?DWwsnJzHTc6vErs9oV3VJkl1ifjV72K6PXXhMhlFjqpw+wL4IFSDpK7tm42H?=
 =?us-ascii?Q?+liXV8PROaRHONKliRNb1agF2obBYkbfeAp0I0s85gQNkrZS7kFs9Pus03On?=
 =?us-ascii?Q?39gs5hvTSS3qga5PLCBdKNDmFtR6WmYMWu0hDN33BPFOPyEKmaw+Lmz74wBJ?=
 =?us-ascii?Q?Mlv4l0RjBxeu8NQGF928gd1wdYKRvS6IURfbza8pRX4LGwrV/p5McShubp+K?=
 =?us-ascii?Q?adt/oOh2FQZlA0s8Yd6xF7EiXTTLfo99zHqo5o7iutMil9+tn9Gxy1rtYa/D?=
 =?us-ascii?Q?4L/0GMB99oZztChO/0jyBVrgOju/z0OAA4sM0PwWI51oXtNOc5pyIvRgQBs0?=
 =?us-ascii?Q?rmIbJpXyQwV9tgsV8k8yEntnzYhi6aeY9tXb64J/oqGJSvH1GOu0YLYeOWES?=
 =?us-ascii?Q?jca86mAIz36V/GXaMA+YgXHEodWtGBsZqs9TjL39Sd45C1JQEQUM+RclHiwE?=
 =?us-ascii?Q?fTFrWRfHdGBl8efGU2nDXM5SJjQ/QaAS7xnkuJKryHHhAZ/sMNBet4oUj3vV?=
 =?us-ascii?Q?HYhxL4yR98wAbKO6uQ4gwB26wwGoG57Qv9ak8kdLZ52PkPvIkTFF8POCuVwS?=
 =?us-ascii?Q?dmB30QKOeLUi1tPHURLRGvuMH7yero3zEtyPgHOvvQRyQtkINrIcMmojhO95?=
 =?us-ascii?Q?4ERkuyHx0DY9poQB/QOAW3AjlhwG9KNuUYCDG6sp7NXJxoB/ci2gx99aYyyX?=
 =?us-ascii?Q?vGNXFRuJnNLj2pqvX6ojXCixCtjnkksanWBkJngodMTaXkmpNGiqObBwn1Qs?=
 =?us-ascii?Q?f6gyMAfLvb11M4HsGtGtbu2uXigsxjO7QBojDC3u/QOJYTiDVMzDaMjdf54C?=
 =?us-ascii?Q?NaE2wp9yt+7TP68v+ekfMpq7w0s3q1iIkj/24DDCeMIoi8PJ/yg2/00wKVvM?=
 =?us-ascii?Q?+ZQGQyS8xTFjpU80s6j/dNhbpT+EZgTdbFZYhbSIhIGiCipPLYi5R5XWYTXA?=
 =?us-ascii?Q?JenYJMVk0G9JookvnI3mx1a5EJhFszfAdqdIM+wblfF58Y7+wyNfBckaaRVH?=
 =?us-ascii?Q?zORiroFC3DT0rzB3mA2nlcyuieNtJJuskilTjdi3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79af32ac-c360-4544-6cc2-08de111c3b7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 03:36:48.9530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCrHqOLbtANXlbgdJPL5AS9L4DpVB7ErTl/iOIFdEontOI76oJuMN27NPuNjq9lG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6268
X-Rspamd-Queue-Id: 8934F120005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: crrjpp8d6df8a5iw9hwywkmugkqbc4d6
X-HE-Tag: 1761104298-132362
X-HE-Meta: U2FsdGVkX1/4/4OuKRWRIGTAfbBNrDb/5MtUnFYXYCLDAMcMIYqua9tjgui/9u2X5BZDDKOZpSZyhMSbcwD4zeyR3dfXzK2PW4o+PHLAhIg/nSDhCNDZZOg3bcbmaLiewV6J1nMR4Zy4Q0EMpbArimHt2UCX/fx2bAlk89kLvJPQx2o/FbHVP9Lbm9Q4V83TZPwn0PQx9cueHY53a6ue9rXETzCb83GWb/lktGYZbfUbm09dFrOVGHO8nEjcIlv+Bn8zAPErtoekVqpisoO+r6Q2GX95qBaQcs115QrGAJcR/GGAoQV62vCjBfvxItRMn4lkRvTw3UAEicpnLbc519X4ylFBxKTChx1V05wMjDxruLR6dowNQ8vwv7znAyJmsM1tgdUhxXTJSzPhHvU97tu+pgkoY0/87avsxs4R0WCwmtpp4ulPSdPZ62B2U/bIBk187mEsPIyMNCWIMzMSlTSYN+Vlj1b5RYzhi+8GxHuvsRpDXNweYGnrr/fZTgtu9S/DF4oJHYbQxPCam2yHyqqOMlJ70yCPNiFIozUzQquMXnxk+P5XC17AWDfdB1YrBOQuzys+h0gykfVF24d/YMTuxxvjfevPGJy0jNUj72OmSy9xTgkCk6GIQqHzEAO+MKO52LDOy4QUtGGzMAvVWAbfPP7m0jAjVHpXp5I4+2TioQYHg0UDurSItM/2gDNYaKiSoSjZRnSmec9wNDCn559u70LwnrlzppeujavETESkgx30JooNNrDzSKiEZhkkaLVMwah7K8yHDS4QbIFxfoGRbIhS5hcn63YjK86Lx/5MstVrJhs1nTuSpWaBjkpnqW94+Zfr1zDS2SkOA9+h0OKRcTLNfoJMpVe8jiyqSp2q7c/iU32aYNVzyzJFrD3CF+PSXniz16hDGEiSr7mTLjplBalyYbCi7nhJ22KfbCjiCE3E+xrVRrrvC8xvKnLcIuIN2FYKj6MXdO5a7E+
 YRRa077w
 G6JF9Fmq8rAsQu5Qrwo6ARHHdNA2imAroyHLfLd7W4n4b+9Odk8+Djh8aOgU8swgiJwFVgcW3RgupbAoUno2SGfsuEhlvzYvPDpwq2Ie4cjV7H/y0lIqvG/0Hn6jQwYHW3rXRqvw5LKY9UY8RfUq/hDNN67Gwveuvw96TJ5yk9MGyVWQVRR/A4RQqy7gKntv/wovmqoypZUhMsV4M8zM3opablr8qlWorxKKTe5YvanGGC8O1zOPCbQzACHiH9DUsTyu4KQID0iT/5SYGgHRbMjY6kh/kKwVEaPePD4mP0tfbMnkkc7I5O5Y97mHNxjb3jO+6Tq551eWwK8RZvhPktTBkhf2PHpa9yLHwief6ApSUyweDQtAy6xjVAcRN1dNVEaLGlmNZ72vx/p2d8Xke5ZiIZ+F8EbWxNAT5yNnGi0sqe8jtyhCS2z6wYikTzx5rLZibqs4jaBIcYFPNodeZIWyowyGM6USGH/+A18oyhU/NsHMfbA4jZcn2pmnIDoRm+aszZCqwW9uKl1cFct7qvQ+0SSPHan0a+V05
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When caller does not supply a list to split_huge_page_to_list_to_order(),
use split_huge_page_to_order() instead.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7698b3542c4f..34f8d8453bf3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -381,6 +381,10 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
 {
 	return __split_huge_page_to_list_to_order(page, list, new_order, false);
 }
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	return split_huge_page_to_list_to_order(page, NULL, new_order);
+}
 
 /*
  * try_folio_split_to_order - try to split a @folio at @page to @new_order using
@@ -400,8 +404,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
 	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
-		return split_huge_page_to_list_to_order(&folio->page, NULL,
-				new_order);
+		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
 static inline int split_huge_page(struct page *page)
@@ -590,6 +593,11 @@ split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
+}
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
-- 
2.51.0



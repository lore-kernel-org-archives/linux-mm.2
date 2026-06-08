Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E759CD8C90
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 00:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398C96B0088; Sun,  7 Jun 2026 20:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349EB6B008A; Sun,  7 Jun 2026 20:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238FC6B008C; Sun,  7 Jun 2026 20:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11D886B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:29:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC26C1C28AE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:29:35 +0000 (UTC)
X-FDA: 84854861910.12.3950300
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4F1040007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:29:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ragSTCMz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780878573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GWhvjW3RcrjV55VEUdJev7+j+e4mPlt3iE14O8LTfo=;
	b=j2Bx6YO9r1UQIv0XqWnxB1ku6dz03OpnW5s/VmXpEcQGUkCfwhH30IZOGKYiWDXWv92e/l
	CcGEidhgtW3LhGM3W2TuPRk3i+cZA5qnqPyKuyNByGs3yQh4grmIpBToWW19kye8k34Lnz
	Idh/tahUMhvE5KoL4u+441DkfdxiUQY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ragSTCMz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780878573;
	b=0GkvM6MDNQQHsFNdXYYLB0LmNKOteP7+XbFXaYlVO1u3KHLYPthEteLw4RgkbwDKm7i8AH
	88d7tW2bYphE+kBuvGO5lhsCQdWMvv9r9s6KOivtSkQyS0AZ3AGt5v/GDTegdR+9tH0/Nk
	zKKcqECbLhlQ/ZK3OWjjRaNbovFsNfg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cfjuwlemb1HmXhW2OQoMzDD+mYaXVLwwgPDr2Sx73+WA8FhOcLyifA5Rg+NgZ6l1XqqAqpZXyGc49jY0ktK1R195+TwsmCqgVdXNxA2jWjudj7PEWv6JmYL0uau+MawCn3kogwbjwPK1tKUS6vNP9V7Ud46Djk8JLZm08DvmRCNYvMf7LZMalSzafoijRbfdeGh9GNoFUX75Go9JivZIEQ+QE1bEh2TvK8OYvOm8CNnkr3WvRAWdLAqI5DWCNmsnK/7gK6MmbRCWmVYZjYA80u4xM3geNYZV78bZ+pdLNPNW7s8IVq3bqXKoa7fVLugOvfxjEeEXooZEt3W6VnC6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0GWhvjW3RcrjV55VEUdJev7+j+e4mPlt3iE14O8LTfo=;
 b=DEUVVgOoy9TU6w53eDY2KYCvVdTK7bd7PlyE2jaspelojYIlHvEzPEqPHnYx3SIEQE7uLAJTcyTK0Aqcr1fuslnw+gPB5myq/ZdBVXOpTWPTBTfqDCVVOw9fyePG/QVikwlV8yOG6Hc946SoqaWctlsvVBSfM5jdjz1qkIWIoCMGSZHG20wK9c8yRsJNGpxVturgQxVE9etfrX47/UJMc+zjp6vlz97TMSj+kuW8w00lOF4SKwHjV6QZNLHZ9uEQ5SPo3+OMrX88FgrNmG1fMptcSnIMFXAvs/H0sSjRjYWrZiKqF+B91bRUi2em5p4oAsENijss608nyqibdC2ILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GWhvjW3RcrjV55VEUdJev7+j+e4mPlt3iE14O8LTfo=;
 b=ragSTCMzWGs0YR1eMLWgQgXvmwY9ylYPNJQdq7jn6uAkRD/2U2+rtUkTysZGkxwASkvX8D6wc+b4IvqxeCyfdSThhLyGt1kD2DeI+1bi/XRORph5/cor/gWBQ1za0NY24KZpVy2B/ZcFwLztOllxc8KDJJA5k/7SgLTpdW2KwooNPTVtPkYvbtsHrHOxi6EbS+4i88W0pzE+GfutdiNnKjNnlqmW/gkfElVE7fF8vTWDd1Jq6PEKXeOHPT4nlnmkkVIXSk98xFjPYlw+WbUAZ6NOQ7MOmI5xqjF83AmhvFwP1GYqOnumDF36UCiHaFJAzcBCMOZQ00SHN2dVDRv2yA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8864.namprd12.prod.outlook.com (2603:10b6:208:485::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 00:29:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 00:29:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: yahia <yahia.a.abdrabou@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: Add native folio functions
Date: Sun, 07 Jun 2026 20:29:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <493860AD-2234-4E43-9BC0-12A666D08F08@nvidia.com>
In-Reply-To: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
References: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:208:530::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8864:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f88dd0a-cabf-42b6-3160-08dec4f50006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|6133799003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	xMCeo94Izl+0YT0fVJREwDG2veH8p7pT4glGkTyzhuCdwyAsliNcbWUc7btiw/czmNEuw8LydSbNJdoQf0hHIJ/5KJB0pKmzBTco9Rdfpnbp232cKE7zC7dGe/j2lLLBiPYW0uZEH/C2NjUAnXVYK/hH4FONE9q+ur21/Ez931j3DNnWqgctea7QVoCD3CzoHzWxYlEUIYOfKjIMksCZA8LCJnNSudlKLc0ABctbIJenpLKynC7c/xafx3C8b/Sm0tFOK8KAEWomUYmX+1RAlHW1AzYUm7Gjgc1A521wpjcCtoqZPxNrojJIpl5uzmJ7z3BI3BOi45qJ8bwbgMCvt22Zg+UyFkdEo0m/twjnj+tg9VuxWXTExSlHM7lV06kDyLzkM9RAapQWNQ3Or/XHRvWXdsnBvrA7dQ2knoWmTMuN+Uzkz8vLJt/mLm/t+ccQylH7Ifke9+zcJygO6yh5Iu/IQMK/Dx6Umrmz5gKGtWmCkHXSXOtSbGV5dNqUS41KEIJdRkPPgz+lpYluZTAFZZAAOUl+mAVkj4nzl5pLvulIDeV5tpRQ44SPifiw0APDS3ZeC7vMbJfukxRqo/gWuKYwCVoyc3ob3e1Qdp49rd7iHQaVO5dxpooYyrjHmyXZ1+SRNDwlzQQygJBjkjblhYGLvamrY6n5R0d38pc+TiwE3+a69H2U4ZtwBaobbs92
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4sBSChNY22Xnq+VSVzvB3v0u1rN3g1lRvk5eLGOeMG29bgMRoab1zFh6vLEQ?=
 =?us-ascii?Q?ErFiqRkFMcyRTp1A7hAwpPK0+HPXA82E5LQLMjbowPRdb1GJFjx19LUs6hN5?=
 =?us-ascii?Q?B0uF76eMcKGV9uY1Y1aCkMK13aM+r+gtN39ewxa5WUOHG938iF5WfoEgFs2P?=
 =?us-ascii?Q?2I2TjlcrnNN8nQ53nzLo4XeRzlprns0Gcz3ygnyv9/QF2kg+BjomPIHr/4Cj?=
 =?us-ascii?Q?A6UZIFRXgrTRCNIgekTS7sSL0pq4jnBZA75ihTZ9Md45JUBZL2Av4GSdCHaa?=
 =?us-ascii?Q?u218jAJNcsqdLu3dlHBbHjDJeix/QiPJw7DSw78JQrSKB09Op7/oOQaKSPvl?=
 =?us-ascii?Q?szgiIazpK3rWTaD/Dia0nd3zf5CE8VtvQ+NodRgDGP7ezfJyi6SMSgKGyaW3?=
 =?us-ascii?Q?R+HY5B0cj9eEPWTRyf+9ZlBC6z9NCgp62O08hic1SS8jfnKQd7dIqzFSfAf3?=
 =?us-ascii?Q?wRf48Rs7GXmXYpUXRkiCsQpPfz31qdNx/4Nb8MjUTuMw0JLdzg7sO8fJkPk7?=
 =?us-ascii?Q?D97sMfY/Akvm+mI4OvHalGcNus7f+HHcJjgSMs+9Rikew9I3XSCAdwZlsbrx?=
 =?us-ascii?Q?idUPGP4cBvagZjWVEM3tWgoxDocfIQhn9/WeZU9HUrxXOoizK0OJI9cvuIOF?=
 =?us-ascii?Q?LXquFbE+QvRNWHbIV+iSkbghgjFdqPHRm5/CVie88b6KhxECvx6ueM1wasd7?=
 =?us-ascii?Q?7cm/hN7ek8hCX3XQxi3ksVKF1eY67RcRWDG6yOOxE377yj/17aAYPrOhRqBA?=
 =?us-ascii?Q?qelDFG0TL5BdDY7j5fmcCC3f7r8/Fd53SA5ZMonQvKmhqIDQvg4v697eXFLi?=
 =?us-ascii?Q?KAUeK1g1pUpcacQJDrHIg197g7G0boEVq+R/a08jxq80twd4oTi4P5igUDOu?=
 =?us-ascii?Q?QNJeoY/Xh3NmRdBQJ74Hf0FtaHSOiAxJ9rZzc/yKRbIkfA437DVAILKhJ7uG?=
 =?us-ascii?Q?krO2+H7TlK8xwD2fBGWJy6Ya/0tSmtXT62E9rG/jYmq04FYpZfuMy8jk9Rua?=
 =?us-ascii?Q?vwuNVtCrlryY6kzsMY864eD3w680gxSe9s9iRCXQ15Ox1CtcFnHDf/2icgbg?=
 =?us-ascii?Q?02+9QeJID0H8vmhaEjAv1CJKtICQGmKK6eTDzaTetegohmNDuj6iwHT6+u3t?=
 =?us-ascii?Q?jReA8HVCyXx1OTX5edHLCYZxS1CcsZfMXkhYrv/DKLOKBHXiw9RHun5ShG39?=
 =?us-ascii?Q?o49ukWtHUBZNceajqQK2kdlNafYSjurKocR4msvEjqjECYAH02qCwspazspe?=
 =?us-ascii?Q?ScUCdQL6eAnWJ7c35hCqNojShMq2zybmdMWL2TWKU7ADaEbzuCFVSe7Re0/P?=
 =?us-ascii?Q?u/WD133MiBPQ4L7HVH1jwHR40E+ycrtHc1A8USA9H/zsyVxvCmu+ezyJaJq5?=
 =?us-ascii?Q?CRSu4eicVTfXcx1RbW7xI/YxgM0OBTK5ZCAmehD5+I5PVx3uOBXnQQMf8t9b?=
 =?us-ascii?Q?ab+17G3hS7WbWzjpsJ+Gj5GOEC8XdipgpBbKYJVuvhHqZd2384ZrdbtcMeB7?=
 =?us-ascii?Q?4P1jncSwg/bBlePoRAe0FiT7M5OusM1692DF1DIwjV+fE7ykstGuv9ZdaxL7?=
 =?us-ascii?Q?1zxXi5MnP2UIW1xhRuHcYYBmJzpwZaL4Jlj5Lpvs7CfInHWsamOHXJckGocV?=
 =?us-ascii?Q?f2u2mK1xQlYEK2FpwNvcgQV3ve4Hqo+ibV+Q6GmO2rijIBlzEMWLl8TT/FSd?=
 =?us-ascii?Q?4p01J0sy+eBU8m55nOyM3upTX2NSeQjH3a5vjROz41BBDBZf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f88dd0a-cabf-42b6-3160-08dec4f50006
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 00:29:28.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNWAiRHGe+KfB9nJJ7in7agVKnJ3LUBCrAWX/7waIEee+HTDdWugKJ5GARyWiKB4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8864
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4F1040007
X-Stat-Signature: rtactqoh9nnwn47q3z46i6om3bnjrfy7
X-HE-Tag: 1780878572-843238
X-HE-Meta: U2FsdGVkX1/V5GvNCHVERQ1O+c+OKyJXrI5Ctq/iZYR4lFQXgPrAObMQO2WfIB76GMBRrkRU/h0ezygnBJc+T7UEJDcIpqllj9nQg+xKaZd5IoRmiAC4xSa5gUokLwtn5hWlfHYMo75Y9uO91B4TKU+C5yP7lpVb6XPUT1Mzy+V/xnN5TKAfnSmP9aSVpJIOQdQ0/o6eUdMfLyGzjvng1BgWTn7SdokK87pt4p86lQm/QpD81/8GAXGpIJ1gN/I+irLLehyUqp9t33zzId4fU1V37IWW0PY2IilbYn30mGsYfK8Xz0KT7pnydZ73KEp2NNyHT3T9Lzkknri062z5t2zhI4yY/jyV41Z+p2dTBpDLwrtLsdKLVSwhBFCKEH5YvJzJGwUKVLy+Ji1yGj+Eirznnmz0TQXG4FbP8vysMcjTcQQPrWlqC17fug25t5o7S7ZqCuiSRTaaeh1hcGnWMU2Xqsyl3L9t5jIs+9S6X/l7aFDEwDjju+DvtpihobDFRfxggTxAbeT1u6C1fQSK2Zs2rXWqlVWmAVtN5//6sHG6cUo7r4RvbBv6VDdZRePniDeb8hs+yxGnLgt9RgwItVNW7tYz64e+iYX9FQkfs6G3Io/YqVMZh/bbQQ2KL6FPCSGEEltSJ9W+4GtrMWc6lIY7jUcujYPuKJy+WJU9JH/FFZsWYl6LEkYy+5kmQfG1x5jMaUyxb8fxBYLInMpRuM50h/Hg9d5YknMnLXE79DYAY4K2uzAq9286h5K4nZyVE0F23M5rVv4rrX+pJeeQbJiTGMHa4QIwGW5lFMIMqzxCGYzLcFxwJmjp8IwZmzTlKV92sIaPYTiWa/xc8Ahmohi/7rmvo9UuuVUKpfYXAxJkAkQcfFbjvPv0xKHpsQj6GhfvhNvLnVjdKJOoedv6X20w1UdcrTd55Dxq8P6hdjiw2eauUBQzujOPuWd8ObkhyA9aAF3bm0Ml0bfITgk
 ROCOoCfo
 mJ1lUp6Uw/gctmvTFCaqBrmmHikHLspIUYzvz7XKx7raZ87a3IkL96nlK6nolN+sOPDLz97kTyG00uKb9TVNIQnnzGUbdRZc9772+6gnbDWQpQc50jYjrV0ydmk0PsAKSV3rwxOvm6Kw+vUJNdSWXvWoBfpMF5mG/tl/0JU5UGKg3txEZqmpaJ+qj/7tctEHK1gubKQHWqFYElZM1ZLz4hkFBpBfGKAdIRbaZqnRLdfe3IT4rI+PYcVL/B6ssJ/s+NtVPjOBcSviRTcdtrUyDrZviuJQBmP7RQYe1ijCETtZqBlye5BNQv157o05dUPKXz7LkDZHNAy0X2hZtUVXY794ueWmc117tSs6tcdIOvnlmgOK/IUwsrOOFA17DwVaGm0/XkzUXboEI6+yeeAhGUXkk1iseXyJRF2gdY94Pmz/fmXwBXBJe2dRikQnNA5jOoCxpUbI3wX1AXyrZsmcGuiOsUL4+844u7uuuVeMHOkKbjUlajDAi9ZIRa/I/7aeaWAck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jun 2026, at 20:12, yahia wrote:

> Hello,
>
> I aim provides in this patch to provide native
> folio abstractions for page functions like movable_ops
> by wrapping folio->page structure in the native page function

MovableOps and MovableOpsIsolated pages are not folios and they
are supposed to only be order-0 pages. This patch is unnecessary.

Please read the original patchset for more details[1].

[1] https://lore.kernel.org/all/20250704102524.326966-1-david@redhat.com/=


>
> Signed-off-by: yahia <yahia.a.abdrabou@gmail.com>
> ---
>  include/linux/page-flags.h | 7 +++++++
>  mm/migrate.c               | 5 +++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..6776cf821edd 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1110,6 +1110,7 @@ bool is_free_buddy_page(const struct page *page);=

>   */
>  TESTPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
>  SETPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
> +FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
>  /*
>   * A movable_ops page has this flag set while it is isolated for migra=
tion.
>   * This flag primarily protects against concurrent migration attempts.=

> @@ -1139,6 +1140,12 @@ static inline bool page_has_movable_ops(const st=
ruct page *page)
>  	       (PageOffline(page) || PageZsmalloc(page));
>  }
>
> +static inline bool folio_has_movable_ops(struct folio *folio)
> +{
> +	return PageMovableOps(&folio->page) &&
> +		(PageOffline(&folio->page) || PageZsmalloc(&folio->page));
> +}
> +
>  static __always_inline int PageAnonExclusive(const struct page *page)
>  {
>  	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8a64291ab5b4..817a8c0b84d9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -96,6 +96,11 @@ static const struct movable_operations *page_movable=
_ops(struct page *page)
>  	return NULL;
>  }
>
> +static const struct movable_operations *folio_movable_ops(struct folio=
 *folio)
> +{
> +	return page_movable_ops(&folio->page);
> +}
> +
>  /**
>   * isolate_movable_ops_page - isolate a movable_ops page for migration=

>   * @page: The page.
> -- =

> 2.54.0


--
Best Regards,
Yan, Zi


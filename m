Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CFAC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 04:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782326B0088; Mon, 28 Jul 2025 00:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732316B0089; Mon, 28 Jul 2025 00:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2B06B008A; Mon, 28 Jul 2025 00:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B37A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:06:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C70C6C0158
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:06:12 +0000 (UTC)
X-FDA: 83712335784.11.2E6F109
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id B72D2140003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:06:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="r0Gv/GIF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lAxMpOeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753675569; a=rsa-sha256;
	cv=pass;
	b=tBRXdoeLCZXSfaQJbQmMv7Y6xLOx10CC1yPoEChXKeC6ip99HEuXXwxyYALS5DlrQATqSo
	C1vl3NpEzcpEvhQF2FML9l2rNilWrxGVaOW0zWmJmndmTOw3V97ikfC1WIw5JwAOqVdEg4
	ycUz0mXwCGFRYxsBLVNN1lD8NLVGT9s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="r0Gv/GIF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lAxMpOeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753675569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dCPW/StbLoa9u1sOJfVr8JkDuOK3yOZR4Z6rie8c+g=;
	b=1ffpqmc9NwfWBIS1B7r6nxVpnbyA53+eCtsRwVppjjnyAnXknw7h6jJR+vN7tay8DarDg5
	OdjtGu+j7Kbh+ZzPn8u7f8eLnm+NUNY6GkQOMq1gWDHKmKhm/89spSFUYZi99kPVgBHQl7
	6RmB9KE2XRhxI3pbAT6V+hDkpUlR4wQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56RMtK09031525;
	Mon, 28 Jul 2025 04:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2dCPW/StbLoa9u1sOJ
	fVr8JkDuOK3yOZR4Z6rie8c+g=; b=r0Gv/GIFj5xULiKga7g7hdOyzA1zcwldpG
	HBPmMDL5CQYTE3SI7KgpduXLTELr7Zy7C9OxeLyLsUrSiwsWMLMKWxG/Tq1RMtmV
	18KKY8175Fg4C/7qWRzmVsaj8c3zab0Yd38JVHlgFZ/aWPb0HYWOH9zJ0Vtr/Unx
	PISQTmhUY0GVfz8I+U7f5J4BEAV6ozSpylr4CGctgm1qgZS8OJcZ3AsaL0rTT6Hf
	peyNc3vOiPEPmhLroYevGHI8EIRrd8X4zjIGV9EUEB2s/SR+JD4y/zEIqJItzWuU
	VvEnejhA5MOhyA1gjNL4Y8AgTwc6AyZWw/hBGmtrclAGrbLEw5Fw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q29jb5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 04:06:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56S107AD002444;
	Mon, 28 Jul 2025 04:06:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf80ys5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 04:06:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCcwg4WrZMjqWByU3FUf+MLMuyvOEPzQ6LnMuCBid30GdasGXNY43i4Vr/H8opT5OFFgp+wH2DCq+afNhJI/IO97AG6suLMdB9Jn4ovVtOEXfU6QsncTDW3SR/R4h10tX1uKXdcXxHtFdfU0f5+7ZLgIjL9oXC92P0wkcWUrIRVsoLOQ0bAOiTtexNQcEXN81bFqUb/xNJxrF2dld3yW8WWi0XLKuuWyUlEQba4zKlcrbbvobNXj13VpLKiQRUdfV5URkujdflNf4y/dvqAYH6TIlMw15w6bgR0VBnbXqMPw0KjJKCaZ4lNGtuHNatYvVJ2D68cB5DxuN3o8oe/4KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dCPW/StbLoa9u1sOJfVr8JkDuOK3yOZR4Z6rie8c+g=;
 b=IZH/fsxwTP0EUGBWNHfgPF7MjqtvPsjXjcMwVHpkWj2biy48c+xSnKFGbkhZPgOlPEhgUM+w6bXVCYh0ARwR8xLjf/roh644ukfAx7sEkyPyql3prXAlNZi4bIb1SUcHo1ctSQPEDKkqED6PcbSXMKUo3OsBJat6CxJveAGKqqHbYDl7B44e2Ubb3bsoUMmh8fX4wb5/HK0PYhxeNdxv91Ztm4xl88b+42CH/J6Cjud5zcne38IulM/SxjA2osdv5+IQ+Wo81UDGSVwztuW9EyGYmBPDA8V39sP7nvWe7OsTb7e/yInXjrhHL2YubgIz0KmszKvvE4DTQgQZ56BW8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dCPW/StbLoa9u1sOJfVr8JkDuOK3yOZR4Z6rie8c+g=;
 b=lAxMpOeuy8B/6gl9SVCcRO11JH44T+XUmljFa8m0EAV2UL0KpVpERlbZPTSaV0hnXOiGRemVrX8tRmPSoPNKYBsXPvxmeDsmekHBucO0voXIxOECJp62fQ2kT6gGdzWV/qCUlmdDf+IpyAkYt49DPrEClpHxzZhgxRfC3GvULEY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB6429.namprd10.prod.outlook.com (2603:10b6:a03:486::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 04:06:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.024; Mon, 28 Jul 2025
 04:06:01 +0000
Date: Mon, 28 Jul 2025 13:05:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
Message-ID: <aIb3In3G7XygrXNT@harry>
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
X-ClientProxiedBy: SE2P216CA0014.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: fc9ec1e2-7915-47d5-5781-08ddcd8c106e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SPAa03uZMQocQJjhAfnvADY6r0K6FNjXIvQh3nvwRGNzqZt6z5tO0w/kHb5R?=
 =?us-ascii?Q?PHmtGA8M0enZSMM8iNlavYEUQJ/3FwmH2QJ8R+oshPTDwC8ouNyvBlJgzGlB?=
 =?us-ascii?Q?j7uxF13AliXdm2+hyALyKJqS1cJ6KG+Aomuv2IpuwEDKHZV97C2XTieDw2yU?=
 =?us-ascii?Q?bJcX4jqMTip/C75O8nFiH4GVKpFiQktcQPdRDreKxN+XcuBsp2rvjWwn7ad5?=
 =?us-ascii?Q?J8XM3C/wYvbNxv8V8CPsz52y6VWa4KBbLRUDrBC2nvfjnkOP2HTxqmz9DXIX?=
 =?us-ascii?Q?DF/B8qt+joXS+YkchQZTrS7miBC5GBQzAe76yXhFYDS1aAIKsRNcqf2/d8DO?=
 =?us-ascii?Q?RIMVrNziIC5cPmLYzeDftQwpYXIwCydPDokC9zD84jgSO7Tx6jO9kDXg8zxU?=
 =?us-ascii?Q?WzfXft2fewkSHSuSYuU7MuprxKVWEObOI3Mvf5CiwX0/g2Bv0HNeRZs9uush?=
 =?us-ascii?Q?h/C9rKM2nGMnlxob1aaubKn7DNpkuD3gz5ofdfZ3qkdTOGSo2w+exRSiAusR?=
 =?us-ascii?Q?fT89YCUeCVM03G5QHqJ6rDAIYEa6MUtsWtIpTmM141NVfZMuculMzwiN2Bxj?=
 =?us-ascii?Q?Tt6YtKlb1FbQ3KZ/69snce9tu4lcOpuFEP/o2vR6EqJjUvnSJdG1fa23T9Qd?=
 =?us-ascii?Q?nlSHEAoxLqNN4/GVFgyQiYEYxOEtYj/0NIP6zLbLBA/1UYR6bJF6OX8DU8XK?=
 =?us-ascii?Q?0XKbWypjJeKAa6M7rNNmMn6y240578W26sZUFUG9XhZDAppXCC+X0MlFmqO3?=
 =?us-ascii?Q?6ZDHoj1jO1GG9+39MMcgvX4JXga7oWlRn1ezyzVmKLHEzzHTxW3SiTurGeY6?=
 =?us-ascii?Q?BGAFgO0GqhHnCwNlrkMEyQtmkdm6y3Bu0ShecEtC7OCRK29hu1HFwIZe9vCb?=
 =?us-ascii?Q?mJi8nMHlb4gmRtI80yY/YnjqNVQL79oF/3DvkwCJ65U9+SBAlD141Js7FvXU?=
 =?us-ascii?Q?wp7GAeijbETfLkf7e947tWJlYfTswBxee+872Rq8oAzjmcEPTGAbGj5UmCpG?=
 =?us-ascii?Q?1b0UROcb/JTFgueru/9j69+UMHvGlaKtcrF7vRtSPKC0i7cp1FvMgShMC/zD?=
 =?us-ascii?Q?2+PdWN33lDN2ijHv1ZeqLlt1nxyEfTIomOqaqkzWs7k5n5Jt1jIUBF8KrAA6?=
 =?us-ascii?Q?ZO5Y+5Ltjer+SBfsuos9hWymeipKGZTZVPtrU5PEA3/H3ANtsYeKtmwkG2RS?=
 =?us-ascii?Q?+9mgPgCSSNq3SCEFS2wNvClqa0Md+ZdXK6Jc4+DD2u6tdHAmwXqrisUSDxt5?=
 =?us-ascii?Q?cOUbjVkC2PETYg7eeNqK0lVoh89EhhmLIAeQhNKr/iPQMarZ++m8Mhv1Av2/?=
 =?us-ascii?Q?Ath7Mev6HbV3Auvi6XrluaJ7a38HFs+N3t3ejsGj/Ovp/E+vkzjHgXByWGkY?=
 =?us-ascii?Q?CJKROONj/ZXndUTVAsz8VVjaVev6zobq/+8X+qFZVn9nSP5KU8Nv/FXczadB?=
 =?us-ascii?Q?cZKrKVROVVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WFsJiPaOoiyKB/n32KoOOas3Yv4YDHRhl4ZXmW6uytPCEtviirMGAZbBy3Ks?=
 =?us-ascii?Q?B+wlhzVBDEd0x+q1n+bhKH9n2dvaqhEk1srGM9fmbzPpPndGORpcBbpI5Ms/?=
 =?us-ascii?Q?da1LtU7zpYAHrVoaeHqREjW0KXoOQhLsgIY3nbNaUGKe6Q6QwOXUmekDSnEk?=
 =?us-ascii?Q?D2GxhXRtWx0mkrjCXqyfkPsolXjXAs930+J16sqzy42U91Mk3xS1qc4Cj43k?=
 =?us-ascii?Q?UTemfbete29ckV/qUOmgk4GiGwRNABhx7abJuhPzBDLgDsolUSNUxC1LZ/Hq?=
 =?us-ascii?Q?mnXiecB2yiOKedwvV2RH41J/qTAO6IckCE0R+5hSYff6ByagzMS3ykf6p7s3?=
 =?us-ascii?Q?pWg1kWzR6tgzKAeVpFrTBbbHGGHiYjzb2QWjC1YgjOnOrixcBtYktCJhXkTX?=
 =?us-ascii?Q?CsFlYzC3EYhCXpi9WSKpiMx0LMOaOyQIqfKHVBgoXVsiS7p4PxrUCt37y3gO?=
 =?us-ascii?Q?Ol4x6p46cJfOy8dcch5ooTpkHGtHfdV8Kp5ruHv8GgLhe3wxUQlf6JmzzH+R?=
 =?us-ascii?Q?XNLgpWBvehUwKcIY2OpthpPYR729Npfc9NZKKi2W2qUijt2DVRnw5em/lc/S?=
 =?us-ascii?Q?J+oOgCRNyVZMFzlthB2u5sWmj5QkOoxV69Qr9Yqs+2Jcbo2dq+Q0yDpHPiqp?=
 =?us-ascii?Q?OFgWzYvWY7Q7fTYRV4dZeIW8akkZsCjDxqAqFmzPkIN+cosm+72F6w24qM8Z?=
 =?us-ascii?Q?EL5l39g03T9RG4Z+CT4rzjP4z7tWT6Jds9imLJzrQ0Yx6VMD/1DlzVrWZdQQ?=
 =?us-ascii?Q?i0dmpoycWQ/ejKrmUBwSPaIKF7l1aOqjSXM6r7dlY0SAXxk479n9zrldTBva?=
 =?us-ascii?Q?7q/iRWXgu1qjiTgB3vQZPTkdur1FJpoGONUcYP4O0xcMPjXwTZ96Kxr2KWtX?=
 =?us-ascii?Q?ttLTjcTG2l8U2a+zkwJHHc1Ot5wLUe54K/p0mIYwEuAqemJA5UwA5+b2NlGi?=
 =?us-ascii?Q?PENy0hLQ43OnmVcPYEEkaxndDP2MsN1V2QrOJKF+EoGst0Jn+3mcAuHOmtHV?=
 =?us-ascii?Q?C9mtfKszdpqrEdB9YwWdMwvE3gBHMi0eymjiXiK2Z1KQZkc2vuj1kP2MSNqI?=
 =?us-ascii?Q?zrwHYwlHIb0YQmutkr2bLjGyFRcViF1APcCJ6HrvvlK/40C8Mx9v2EY8i7t+?=
 =?us-ascii?Q?fofAbnhgrjviFBatD4kDG6Y1GMk3Dp5PEAocTPGokU4392Z8DIsI+Q+qtICz?=
 =?us-ascii?Q?L4n4etCqLA6sE+yJFWs59AESLSDuofR2dn+GyGFQGiCBuyLEUmUyqMZ2KEMT?=
 =?us-ascii?Q?5QyqPvcmzC4RcKF375/NOlFNqS1oMVFcwrbjpWtGoHJ8gEoQ+2THFioi6qtX?=
 =?us-ascii?Q?o/WqjUD7x6u0U5r23249h2C7riPrioCYYJEtNtwJDdUF3Lay0WgH2BtvyjoH?=
 =?us-ascii?Q?8HCMRUsM3F0gN+KcP1xwI1OwA5+GP1znud9+76gBtIgjGOlXxEn+xiGSJd7L?=
 =?us-ascii?Q?j8FnEBPT7oBreNx/qtMVZO1L80giaIyBl6zt+FprDl8xg5snFGVfCdv3bcKH?=
 =?us-ascii?Q?Yqa78PshlV0t7VZHja4GQw6wChMJIKAuxNJT0fKi134tT+kBANjF2rqZQZgw?=
 =?us-ascii?Q?oF9pzWuI8SH7fLCYBpBAfSeZXdlAhs6QYkZYQrvF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1+zOlx5me5GQZnYWQPJqAxFALZT3LqsRBdr4Nedcd67hqKcVU/yptiTvR5ayhSCJMmR+pbX5NVACkCs6Vp4HOoc7bKfr65FdliX0tVRqtZsJwXgP9qr9BT95Pb4wl/KQXoKtoAsEOqcQT3gPOoiyyvxkiKLFUblWcL7/mXgeh+KE1NuQeAMxCOKBk8M+qlHi1IQKJsAk0o8HiPpM3yVMG6SWWzwpnnOYDnhnS+pqqMfpDlHmT9ll14OLL2yU/vKo9aRjgDD6dHhSFs0SWOBCT5ebCCiz9vo4U5K7wydoeQkguv1GFeY6XDwaH2VEj1boKN6KcQMd2LCITqJ07p8ZZIsvOO1JPl7Rb//2FmHKoGNnaXrMINeqAzu2LTqExRPi+944GlxXwbwZB200o7JQ9Q1bQT+LskGdVTm7n/o5N9RYSJaL0O0enioq7nhPDbZcPNfbA6frUavRI3DGrwQnmCnsLRJ7IJEasTV9RYKKtTXuF12rlyie9tdL1FIFGeYsjyViaEC/SRZhXr1HJQWmi0xGk/Y7Tj2vmDNK57STzEsziZ+itvY+bJlZxvf20Wh0BeMZhhPww0hKr5fHAVn6f7nCfWMHy+PHGr5Xs/Dvg/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9ec1e2-7915-47d5-5781-08ddcd8c106e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 04:06:01.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DISTRRLI31cmlAhccNI36roL7C0/VybsqqxvmcxrqOcjOtNKP/EMtjCf7Aa1xLGF+3Efg8TD9vtx6Fg1AOKgVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507280028
X-Proofpoint-ORIG-GUID: KClFkpSH-jJtyBgmIIwbxXensuIh073Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDAyOCBTYWx0ZWRfX0W+T9hfwkAhW
 2TmSfCx1/J7jRGeS4eUV46N2/44bs/vOeeOgYwx0oCkt4PO3qhLqIj4dFHrM9K/Ht/S6ixsI848
 Uzihz000smlKrjc+F+F8aw9bTcmlxhH9ec5ObVlInxy9q9+/xMzh5Eus0JkY+wUgGt72yF2jKzT
 a071nWWQfywQhSNPGsUWxnQMcvlHfDStkakxQCweroAg+2IWTRHaKL2RKsb534kbXGnKI1JtjQD
 wywgxIq2f4vn+lJMtWQrCbeXTVecvWnq2/NrTwiZYn1nFSPRvNpw43W1oVTh1fiinu7NvLMpn1t
 jkqGCSwmnWJaOBOgJoJIYRgCpiOiijbR384uGYO1O/EoGWHpko0nDBYrxjUXs6iXqJwu+dCRBNX
 MK5mv2ScNz1SQcysFmJ6M4t+sMhGOZLejQIJJd17cV06hzu4wKX8yQ2MRquLbYlymCd7nhYW
X-Authority-Analysis: v=2.4 cv=FvIF/3rq c=1 sm=1 tr=0 ts=6886f72d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=GSgEKoCvxp8HDOIj5okA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: KClFkpSH-jJtyBgmIIwbxXensuIh073Q
X-Rspamd-Queue-Id: B72D2140003
X-Stat-Signature: r4emn84srn39nem5tu6djrtsfb3pefzg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753675568-579181
X-HE-Meta: U2FsdGVkX1/5sA8TTXs3q7s1zDtgmWbNshhnstesCnD/rkKnyD2y62S+xOXTOJpNSNYzwgAp8o0qph+lgQzzhrDlu+s1Q7p3gUnsq/TOCMqpsadfGFEgKSlXlLva2QUPI6Tvxq/yaL6EO2GRXoUccC6PRX3NuqK3HOQOyJeqoLFGA/5njCSQH90vN5MmAqpQVkKKB8c7D7H2lLAX5zAPleCqf9HWXETPsnp70TiSHBwPCQNwAhXVefVu+LkQCYM/ccrlSgJf+apsc7XkqblxbhAyndBJer6NCvTk3XnjBitDMMqZTJqfC8eHamTyoJraMFGxC9mRpNbCRUSW2Kr759j+CJUAJNvHh3SD/meam3LVhfW6RwWRm+pz5WPvMRJ8xfO/72PDV69SpJAA/2qJYlJpU0krNdKUMbtKe2tzSFilNcV2z42T1xu4Cjvo0hzTh9jr6+qmVp0yJXemV07HPfzinV3RciKvsd/FVXPNWEIUk3J/09eJFVPEcW/bIGhodqXPbt5Bt7g8h6jeflTBkpqOoeksHLdSfuc7Ksz5gGM36q9Qct2B73UqWRXK2xubxfzoLpVYaQ9ui+SQP68YBHLAfDvbAi9HQxOF0RazsPNPQjh8yAQ2O6vTELyhEDOQGgojJwfFDTfByrwhi49gEw/qFnvt9RoRQwSQ4YNHukGxuCuQV1QnOZSKdvfqFY17e8mSbBFcMQUyGuD+LFLCkgmvCAmp+kKcKCEBqSCOzU5GaXs/ZqwoXYJ2ap7PhNKkWxsDggBQGfoCMhd6sGvKe5/JHdDIUonKh2yhocgh5CAHYq+TkAgLVL7ne3cOsCR3ih9m2njvAz2IBYn0AjHeZP4mWgIwBW9k0Nnl4VpzyvHGq4pQPVWOLyjBOjlAc8gSQE8E2kG8rPIiQEa4SendrheWOluaSTCJpmiJiBNEiwZBi3RXeNeb7o4leKLIarUx2yaRDT7kHJoPuCqRW2f
 qp6XBx4Z
 cRxH4BcfloGO+OHLcC5ZIUbae7IrWEfdNDm2wv2v6vyjY7NCOPkTbHsCt1pFDjCbXKye6qrfXYZK+5XORB8DejZrCRPi5HLnDAiepff1GZ/WPT3OgqEHPQ3B9sW5KCuat61OY7HJ4RrP8i989nBTkA5tsPBv3/v/qSknbOQ6lSG/lO+tx72xYrB4vYRAltyio0mqTJQXherk23++/OCGTpCCI8QW7Zcqta2IXGrZ/dwvmZmohLe5r/MuHqyRzAyEaC11HkSXrAWSa797cpkBmIuu+sOdrQzds88kLPx0h2h39/+63cnWshlVyo4R72hSb233ATVphM0QgzsaIm/YfCh/W/ZeQhyFC9eeoJ/ZXTChjn3C4WLj34zgbTt33U1BvhJzvPsS6ZGST/6D4gd4+vORm430rbkdTP6xPz7pLVGfDcx32wWmBO3hSEH/sEZz9TaqBH4vf3ydSNmYURI91w8o8kXUZ/wxuX8aalu+/gYGeBOSzR2rJopvqGiM0xle04E2RjdXjeTuQzMsKXL1EKBb/p/kcLsO4aAW0+JdiKiYq3QGsBSNCjPjJYYVt/wzyKeUwOU8CFunxMt/fXVL7H/00lrR1vhsOx8FdS0gsc6b00eviQ9wB98HziD98fLVgsJBsllMWpDB6XNAz04Q1PnM4vk0HveTtzlS7K4na7tCd5Gx63BwDiJ4lET7lTmIdtRhS+f6Fd7ayCblxtCkZI8Xo5DcOvlUhguD7D2acgNr1/TJjAcWlb2/uhAaCmHcuEdMYZt6cHsaaJT3CkMexCRYb/LM/65eLjgwnzXELdPXwO/qMV5N1CD0DoLR0U5zoeksoch/ywJUZw/c4ry4mPf01FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 02:16:24PM +0200, Jann Horn wrote:
> If an anon folio is mapped into userspace, its anon_vma must be alive,
> otherwise rmap walks can hit UAF.
> 
> There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> walks that seems to indicate that there can be pages with elevated mapcount
> whose anon_vma has already been freed, but I think we never figured out
> what the cause is; and syzkaller only hit these UAFs when memory pressure
> randomly caused reclaim to rmap-walk the affected pages, so it of course
> didn't manage to create a reproducer.
> 
> Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios to
> hopefully catch such issues more reliably.
> 
> [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com 
> [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com 
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Changes in v2:
> - applied akpm's fixup (use FOLIO_MAPPING_ANON, ...)
> - remove CONFIG_DEBUG_VM check and use folio_test_* helpers (David)
> - more verbose comment (Lorenzo)
> - replaced "page" mentions with "folio" in commit message
> - Link to v1: https://lore.kernel.org/r/20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com 
> ---

Oops, I'm late to the party.

A question; does it make sense to disable reuse of anon_vmas during
anon_vma_clone() to increase chances of detecting this? (of course,
for debugging-purpose only)

Regardless of that:
Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


>  include/linux/rmap.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 20803fcb49a7..6cd020eea37a 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -449,6 +449,28 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
>  	default:
>  		VM_WARN_ON_ONCE(true);
>  	}
> +
> +	/*
> +	 * Anon folios must have an associated live anon_vma as long as they're
> +	 * mapped into userspace.
> +	 * Note that the atomic_read() mainly does two things:
> +	 *
> +	 * 1. In KASAN builds with CONFIG_SLUB_RCU_DEBUG, it causes KASAN to
> +	 *    check that the associated anon_vma has not yet been freed (subject
> +	 *    to KASAN's usual limitations). This check will pass if the
> +	 *    anon_vma's refcount has already dropped to 0 but an RCU grace
> +	 *    period hasn't passed since then.
> +	 * 2. If the anon_vma has not yet been freed, it checks that the
> +	 *    anon_vma still has a nonzero refcount (as opposed to being in the
> +	 *    middle of an RCU delay for getting freed).
> +	 */
> +	if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
> +		unsigned long mapping = (unsigned long)folio->mapping;
> +		struct anon_vma *anon_vma;
> +
> +		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
> +		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
> +	}
>  }
>  
>  /*


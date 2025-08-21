Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E0ACA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365966B00B5; Thu, 21 Aug 2025 11:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D846B00B7; Thu, 21 Aug 2025 11:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253C96B00B8; Thu, 21 Aug 2025 11:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 120216B00B5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:26:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E013158F52
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:26:33 +0000 (UTC)
X-FDA: 83801141466.03.0991C10
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F541160007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:26:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HEVbxDIU;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755789991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHTWveAXeeXqjMUb/KF+krrAe/7KF0Pysh55xyRSBdg=;
	b=SIjRNVDwBLyt7Vy9ObdgjU6js23iXRrPgoeitqQlY9blS8TIo9c5/MT6Ykclce98TDDcVZ
	1i9BHqfEBuREnt4TKaawc+NRUm2M10n73E9STJyADQ2vKqFqp6NaK1cB8zM4mGFuSfd1Jc
	Ta38oz02fF71MbjMudcr58nNGvnyfyw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HEVbxDIU;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755789991; a=rsa-sha256;
	cv=pass;
	b=zKU+TrnsW0H/swzcWEQXlfdKFi1S5q6rMywXB37YnzG9fb9X6mOzCmCr5H/y8/TWkTf+ho
	QHpf9VJUFKO0On6jCvVYazWJbaABz6K6dep7DpaWf/+0ns62RVgmkv9tb8us+bRVLn2+Fa
	Jy+5mXb8AS/aH78BX2EYAAkN3w7pgtM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiA11MN9mD3ZaRmOJzFcRnC2VaUAHIMticBLx9ywsvLcXkOBzKMhpnKj+2SGtxXy6sbAwcmQ71JR5gRmGZvU65IWSQkKkLWZrvfqW5B9xIWtVPcVjt9ji2WD5nu013QERRJG4+IGn7Vqi6DTVrTRrF/iHt3yJVXUie/+0qboT/LaF1tUU3N/6hwMbL0+FFhHFIGgAGrHhKUFP3gMTC/V5C72usznwWWNCk2Ntw1VN4p/KjRVNAEmqdSYbzx/Tx+Zw0lsRaltaB/jc3y25tds245n6WhVZYODXvvrMblppoRVh4+89zOtVEK4Sr+WvI0W0jKm83uB+nqQrjberMmydQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHTWveAXeeXqjMUb/KF+krrAe/7KF0Pysh55xyRSBdg=;
 b=ErtNEC+H9Aa3H800K2d3+KgX0+Gkfiko8mrQt0WTz8Ii8GiHxP7SFjC6B639NeOTAKNG0j/WD8K/4avn4qbaqzBMkWeY1UmSRTSXC090ha6sNHcpyytKQMAIT00yOs8Kw1d+hzpSTEnq9S4hgKDT1DUtx6qpD9YIUlHE5jGyZQcq6/5sFF9hDDl2pEo/NEdsFAhp57N1cm/Qd5JVdbBlenQUIAvBzBiwt0StiG36OE/tt/pP86+GQjmcwZ3eO/mnpe9vHV2YIOSuLYcrjvjmVS9OH4Q5Nfr3cu2+qiwhzNCJY7GaL5yVlx4wQxBsK6DsFnWA/2ZHgKPKMFKQ0plnBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHTWveAXeeXqjMUb/KF+krrAe/7KF0Pysh55xyRSBdg=;
 b=HEVbxDIUczMEiob1oy0GUszgoG1bM6FLKlDzJuga/HgQ2Qv3f9SohEh/0UYsURNLJqvASCojb0tGqAHoezSdcWM0ChHwBNnaFzvKrBOVJNH1poSuokpH2Nr5gEwFgp0cASYw/M6dT08WBMlsvO209hdaK3v1U0L/EP9XbAp+uaWDZ9lxx8jyNpCeskqIT6MfZU/41LuPjSr5C2Nd/KooFuKEHcPtsKYGOVkuEbrzQF3qUKfCoa8InD95US2FwnQ6ZQcqiisqTYsTfOuNPWDvG65fGKY24zz4JyjlREJ1CRtOEMdvuWnk2MPZVrDJq/LNW99OmgXd47HGj/605itXOg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Thu, 21 Aug
 2025 15:26:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 15:26:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from
 __thp_vma_allowable_orders
Date: Thu, 21 Aug 2025 11:26:25 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5929AB25-3D13-4FBF-93E6-E3088880E14B@nvidia.com>
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
References: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0264.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4238:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a05d45a-70e5-4195-eb26-08dde0c718e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?94hH8vA+mhTSAyKN3mYdIeSLKP1itsvZrWBZi78VPKoFUl2HniNhx8nBqXXC?=
 =?us-ascii?Q?g9mF/5IPVoNpRzIrUIKl2AIXxhZcuSJlpc6C+wKImEDUfQ5QL+oMy4XFGWM/?=
 =?us-ascii?Q?f0Vg/pfWriJfpvQtjeQy9f9tS3W75RoEz0zyIxQIN3T5xCikAEbB7nSz2W0c?=
 =?us-ascii?Q?3Snv10aI0oXYM7f3exygBZuso5nBGeOPObJodmn/hYiwtmea/isMswIZqnCm?=
 =?us-ascii?Q?aD3Nsj3vUCXvz2WI/XgMtyoSnRsrLmbeBBN9+jsXyZCgvy3V3IVxWyAEMA+7?=
 =?us-ascii?Q?BKcxD+x/Mv1qqPaTjH/iDcamoW35aU3yVgFUvcUHW1lGR7/cXdsqwVt8vQkN?=
 =?us-ascii?Q?knuQR6ieq+cRf1ZhIpk27gbgstr80PowteQ58dW9ifFE60ns0OmoZGIEGFqv?=
 =?us-ascii?Q?/UyuS/IlO74uyKNZ8LokV5ueTLaJMyv4pjWDa35gPD3cmOL+u0ixBC7NtbE+?=
 =?us-ascii?Q?Cc/jrGymD9FXeNLYGHbQ/MqPLXkrSq7YT+TBnRnSCoGwaAje6TBvDTlTPrKs?=
 =?us-ascii?Q?oOkGIgGj1y6C0ty7RduOtjP76lF0UkrYzeqsnwjInmvarc566gUFIs4bcKJl?=
 =?us-ascii?Q?pfI5s2gnX5NrgI76XJNbl+ZpDchfYZn3oJCRMmfK2ML4TyMtVsxrb1VJ07Xy?=
 =?us-ascii?Q?c0VDMorAnKArlv4TJEuwwWbrefhZLjkJzfy43EKOBzdrW+2ESCio/ASy3BC3?=
 =?us-ascii?Q?y6A7C1VKEflRJ38fUmy3JKm++WCZNh2vSTHHMQDVOkqom52UrWFYf4cCZV7i?=
 =?us-ascii?Q?4v21msVuXg8WM/s0H1Q8/Sl4e5BorLHEOL5NrI0rIutjopXoFVHUvY0AN0WU?=
 =?us-ascii?Q?hndQYqRJy3e1ZBR5zoTArD5qAoBD+eze5/oOIShD3mYWW2oofqo7QDhXozmY?=
 =?us-ascii?Q?nGlLU6BxE5FkhnYZ/rmqK1Snt9VABq3SP0XLELw8a6vUsjTgbpKlu9G+GN/B?=
 =?us-ascii?Q?Weti5y3DGAppph3WYtNK/PnuCyuR2xTjXUn0kzC4VhHcyWfe2S8DGWxr7jS0?=
 =?us-ascii?Q?aOrv394dvZIjQ3YQGdWaewhywvlAcHS97v2NcOt3rYe/u9ET+RgmMLPpPfGk?=
 =?us-ascii?Q?pi+9lRbEWK08fe4WkaPqmtwb21BnEb8mfEVck9IsluqRgax17e20/E8prDRy?=
 =?us-ascii?Q?6MA41M9fEeAPs0OhjhQ6I6bO3DZBnt4jafSXhfMyMbuAYCbBcRiuPCsuVVHd?=
 =?us-ascii?Q?nOFcW0WhfrqpXlSMJber4ma3U5XI1X27ksNjFOLivmRRzj7pgj1LqQFdU252?=
 =?us-ascii?Q?t+VsQUxQR4h9Lxadhsrk+oXJr03SzT7/E7hiUNIJPVBYPzbqNWdYe3KwBBSx?=
 =?us-ascii?Q?5h5sQuGETekkLdUnZSQe+OSd4JqhcdoZyfR6/vdSX5lDau8kcJc6O5L7yuns?=
 =?us-ascii?Q?BiZRBO9SjCD/3STvlnKqczQe1eYjXMiV4D+pfwshiC05Sx1Io+kcXfzr4EAu?=
 =?us-ascii?Q?63ttBz8JR3s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kI2CRDGpqB+/fnrKxz1VA4kyZgeJz9tGuux4K0CONdl3l88IZhGMq82qWiQN?=
 =?us-ascii?Q?OblWOeNtKwRo82mxzHbfl3tq3B1YW8p9fdYdEt3D0ZT8cr+G9YZ+Iz85H81j?=
 =?us-ascii?Q?2iqCLy0R+13Xfv3dg9JzZqXYBQOguFemyGr5I9VcvSQPMARsSkEoRSHowBpA?=
 =?us-ascii?Q?a/f7GBcC2KAHKEkdpmClZCtSy66gKhSeoMd9nXGPPUQewVKzzazdRt40z4Im?=
 =?us-ascii?Q?+sUYlj9snLBem2Cu1PKKY1PriyRitFGTdNUlKOnIGZWRVxFSSYaaJJm9fCdo?=
 =?us-ascii?Q?eCzvXqx3RhHG3SR8/RKWdC9hPNVy7jR0ZRLenl9hsBW8DbUO++2++jGBOQKs?=
 =?us-ascii?Q?kxspLCeMRB/ah0y7HQuSUO6QcOAYBOGcuRTML6ZAHRt1tiBrn6Oq+7IwVoy+?=
 =?us-ascii?Q?s0Vjts9I7nHb5bTQz/k0f/leMzvvSRaRlDhIAzQ4O5D7/v56AcMR7jlM+egz?=
 =?us-ascii?Q?2VDN06ApvnvLbLersh0M0jbZ6nPtwRaGz+TSj6CJQGtC7/lfDP9vKwJgOiQB?=
 =?us-ascii?Q?0wgDH8qH4mXj2s+NBgc1rRIHdhpe2kNfJejpuip4D4PSf8T6+Bx4p/vzXVIT?=
 =?us-ascii?Q?vHLlXYMfOVHSjXCk8NpGqzXbvYg+V6dHWSgGPhapvvMRijlINSAAz8SuTH56?=
 =?us-ascii?Q?TpcF/QmGxdEF82ONGIo36dKisC34TzHapSt6Vxs5+i7fys8AD2mEzcIf7BrJ?=
 =?us-ascii?Q?Jym8ItH4N7niYtc9xCcmJM1cTQ+3GrvVdZhVto6RoZs3K2fZn9TU30Co5FFt?=
 =?us-ascii?Q?vC7ckkaEfddaqwYNR8ivz84PvAX7P/TDoOhHmm5g4YUfFAXCPvvi0K2Y2SN8?=
 =?us-ascii?Q?+/IjjMqkCCZ6zJtmPXd6RAjXNSPudhUmhZ12ZY7ZYCW826AbwK7rjcYuHBOz?=
 =?us-ascii?Q?HL84LpL0QNtcdgs5CUdeRKK9Zlt46afbhfyFgkrrhUKMfvKhR8XWF0iqdHD9?=
 =?us-ascii?Q?ngkuPYmT+Dm2BUGbJwvSk/zHJjzFaTYfDLWkshSEjrCCqCkIhzy3Js4+79rb?=
 =?us-ascii?Q?EYzeOjRx1TPZv9bKcOxh50SVt1vEK7uDn4bil1rCB/EtE2BHwX8qXk9JdI27?=
 =?us-ascii?Q?HHov+GUNjjslQhlku12foiBDq5Vt0XgQOlBlai0KIihQiH2oq1yeQpbTqSLC?=
 =?us-ascii?Q?ESOFMiRXCuW0PQw4r528OHZ0sdbceP9oO6B0tkdkdG1voHCiMsSuOvmqreyd?=
 =?us-ascii?Q?dVvvIY2SosD+vr0hcPm1yKO4AyiCX3Q1toedlMUTb8ZObB46ZcJNVBbmAPHp?=
 =?us-ascii?Q?TH+lW/GdMUk9DKzvgm4wEk5tX7XcLGKwjJ6AWmb3NrEzIPbVGgqd3TqY4z6K?=
 =?us-ascii?Q?MdaYKBhNNm5ZEvu6ExbcZCPxCWrAI4TURxwGn06d1eNRF+LixJ3BDC40pRs0?=
 =?us-ascii?Q?EOksdK7PexRnsW9qfzKLVecywDtINdxIUp+qSkPrVkfyc0SUwmy1kAIbM5QZ?=
 =?us-ascii?Q?UNeBOzU2XxQYCM7wyQ8o9MoyC6HPqkyxxlQNYw+OGAkZk3NDpxFLLLDwQUCA?=
 =?us-ascii?Q?O6JEpSc3mkJHk4lFelJWf0SarKDAVdSY0Slbc3b9B88voQ+YkP5s6jlmV4Hj?=
 =?us-ascii?Q?4NUxaSOWUXrfa7m+7zrlK7utbn9ZTXxZ8SMg5Rgh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a05d45a-70e5-4195-eb26-08dde0c718e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:26:27.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/q82N3RGNkfeGah6z6YXpqeI7JddXlpLoUPR6K6mjPebmxzrFeWD0m6zziaosyO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238
X-Stat-Signature: acxg4ffpbyrhmknd8npz1k39ugjyfip8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F541160007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755789991-198613
X-HE-Meta: U2FsdGVkX1/H6vTMDtaQO2MlyaXUwSK1NeGjYLJ1OUNWUBdmO7dXW6yJVgM4gdTaguxg3qERVrJW3eqBdFRC9LYHpLZ6GBeUMx7no4O9t7sKmrSkm5Z4KL/rjSa2+Xg3uVDTWoPsmKBw/5X7WNZXLrXbw0e/8AbyGua2zIYoeFKem3BwiNB+A+tpw6lUrHZS6QfcVl+NAUsHfgXnZyINyKpmCEW3P0rVLEJf4ANaV4WYZe84w8OYqkgRn/sei9hdlbAAEthBSwSLu5YIjBQHVrU8B8/cTc7qDkUD+2wPcrHobkzKHMmqzoTWseZgrmXuVNREPBPMPGX99Jj3sBc03qQjwlls9ixGXKcelfpz5TU31WMJ9z/31e676DUIvhlo8DfW3u+Lhc5znx52MSxWZaiQlLXWmzC/b7xI/uFbDdwEOjRb/FRnrmTXYR18fMKMpHQcEvhVOM1nmcWqKONWj24NkeQFjgoFHym/qRzp/baBK5o3jiaRNRko1/pKS00txvZW3+tEIhpO5iRt+C0TkkMFB1pqMz5zQUz2Vn/78ay50VIon9BAKY/FdDaqHsxo1mAISl9TYCsFHdZ2bfFRIv2I6/O0NRCHLyS8075rRDAFGirb+v8i47jOtRQsG9eqLKxryQH8+GTaNP4r8jMJVGmmaO5v5oUOJVPji/MdBP2GvI7L1an4B2o+eeYjg4kj5uhCej6wExHyzWOMQBGJj495B8avTYQ0eXT1IadyysMNY2bU3IGPalhDQZY9WxBC+F5thBR+PFplBMMc2Fb9VdQT5M/EcOfWMZCSjRVBTvGid2D5Vhk9IS5xeiRO+3D8u9VX00Ee//3vf4lGaW4bwJFRTwszGUiybzzkQBZSXL335NxCkoPg+QOnfW5RzpQS1dqbAdxYWuPvL9lBwIacByCZXFqUGNVg6cixEmyyp4JZy3s1E2YRgbrG9L7NrxXh9xJTisMyFIBWDX/9iv4
 fve9rUXD
 Wb1aCYUu+lh6sLPijR4XBM2Vj1TKEsSg+6WSzsmPGUSqgqwAK5zfiiefedsEmy1sRY7lF+tRLaCa956SSUNo5q9AZpd+++bnEuRskovPdxusElzJjGI5uxFRB6bKP7AoBjYWbcQJgKbtRmQod1ffa2PMA4r5H6mnbK+u3oYxEsOlDxD9QFUSYTgN10FfRgGXEOe9WWyMtPW3kUN7kIziXa7AaJkBXv29egPbDh9NXx4JhVJBoTI/2aTa2+1ly+yaP/k9TmtHBgY7mP8+XZh1AS1Bm5EfFN1P7dto3sfLTg6RvxkAEVzNKat2FX1CryKZxgmjVI3/AIBJ39PXy0i40c0RCwZ7WlcI/n4K/UCAvDDDvH76IVvXDSsOYWtyhoPx5S9MDLdy47wSzJPTnmGpowu9wxEGun2/lG0oex/U55M+Wwlm0EuoxhHY9gdNlHVlrYugeMttWe1Q5p3/vCPhNxX0cKG+7V3W/hiJX/Gd8Zc7oQaMw8KsK5nsScan9T1NjX0+w0UtDNFa4R4WEVAyFurOBWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 11:00, Usama Arif wrote:

> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
> This was agreed upon in [1]
> [1] https://lore.kernel.org/all/cd99f0f2-260d-4494-bbf6-99daec3e0683@gmail.com/
> ---
>  mm/huge_memory.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>

LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F00CCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36096B00AC; Tue,  9 Jun 2026 10:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E64B6B00AE; Tue,  9 Jun 2026 10:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADFB6B00AF; Tue,  9 Jun 2026 10:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A2D6B00AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:43:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 254E11C2492
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:43:46 +0000 (UTC)
X-FDA: 84860643252.11.D21BBA6
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37C802000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:43:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BBIB0ob2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIeavpDGaawl/H4vVB0MqK/6XPdsRpavdD//6Zmeshw=;
	b=nqtsPyH9U8G3HzAOuBiwIrzF9hZ+xcab9/32UkWE5/Jg1pEgsd0M3e2YRQCED3v/PuaYhX
	j/iP7imLF4McO4frs2PTspAdZXhPEE3pILxW24f4jDVE0MgaYQAAwNiDGuDhOVv1O2X+2p
	lJ/mYMa//dNpWP/LjDZzjgbsvYpGuaQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BBIB0ob2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781016223;
	b=LfhznhpQ+ofN1rG+HMo3lDO19GttKBfLjfrOtVAOmhGD2ZN8lxpNdWGBP+x9t1SZaDpL50
	s+U4ZWoHzOkN43X+reF+YzuqcY7UfUSAdLd8LVrgZXXsgJ3lsUmYdofNPZ4aweFMV9REjG
	AWjpewxWmWDAj5nocaPGT4loZsCExUM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuDtTtPUUO/pfTYx07mvrZvnQXHlSqMwIzwgIIgugtmdoR268NGT+FLe7XOCdIZNr8tfZ3sghvkyZqR4R55+d+c5D0DNyPSFZ0aE3/7qedkR7c6ekeYyAl7wCYrz00EUu/AupBgiS/bxv/D17kVh2RG64/gfwRpCuUQu0hPfWY4Y/mxwzvYQ16mtEKZjGPvkVKgOKVfhQ3ZN8+TLSdQV/RuP/In+DOBKfSfrTPrOcSjJ2ux4SMKzJh3Z2oTHhas1rzPBBrwyBOR/78Bjk7x4Mjd84Jl3ciyY4zG8JvCS7DPNJ7IcHBZ8GgTFwFudrVDi9jMVH1wvcJ9auF94tkn/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIeavpDGaawl/H4vVB0MqK/6XPdsRpavdD//6Zmeshw=;
 b=HmuayrEgvR/eG3rL6q2GfuiCpLcBGGTnYWXgv5OENXK5q+j0ufjXwk6G/EGMjkhVF1HgbgIZc2WUVIrBjxXFfWixY9UN6Z+FXMYm6qJRUoF6Jb0Ez03knLRASpwrSaYIAxYJg/A5XBvsGy1fKdgdMzPACOy2wf1QdNm8CFgCdxUD9TsG7nzTq/UZPEK9vYGvGK4qLZDu6kYGcKSX8j5OoMqWhfu4dUKjI+rw7jE7cD921b/nz+Iunx9lD3urkPouVmmqpa99DZrCjfWMz+jiwt3BlXVw8HGS+/DYtN3l280ZnDQowhM6l4uKydv5kuOOzJC55InW3stv0iQApWSF7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIeavpDGaawl/H4vVB0MqK/6XPdsRpavdD//6Zmeshw=;
 b=BBIB0ob2Ella2kNKX7X4Gmq2Hy4WKrOWa/FXvYnrKJy3OxywrP/TCHhuI4bs6xbhhiUal6r/ClZr8LyxBKlBBjrBkc+NrwgNHNvbdJ7dWniGyMInlu373AKuJoz2nvmWZsqPs7h7HQZydyog9MxSqE+C2DCinpEQU79zzQ5rGFNMlq9b6AKrbBjsACL5Eed2iE/mGTca0kdU/fZsdGzKDfgztLARy7t6rNPoeMhUBlwsmUtmhticQGHlvcf770kchmztSfn4ZpPodyUKoF4CphMF5qxje59Mm2lKDdKuof0FYuBEWCxJ5Dops2IIvaLJRbd0j57iBlA6VQ2RXm/Q5A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 14:43:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 14:43:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@meta.com,
 longman@redhat.com, chenridong@huaweicloud.com, akpm@linux-foundation.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, rientjes@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context
 nodemask
Date: Tue, 09 Jun 2026 10:43:31 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E4240C0C-0A37-4B08-8764-67E806A66CF2@nvidia.com>
In-Reply-To: <aifC9s9X6hLWdKkd@lucifer>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com> <aifC9s9X6hLWdKkd@lucifer>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:208:237::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: ffe7ee46-212f-4c33-59f5-08dec6357c58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	huGkyaNJltLtIaq9WfAqm84O385yOc3fBBU4qwLMysqpbp0WU/wIoETs162f6rdkU+t3FyrgmLNzJWS3fXofxydrcY6A013Skmmv/SDkFmo1ThJQ6IrR+9H/tF4MGKWuzABlO02EU8a/OZusunxjJ5uMW+tHAkIRZ9EYBSfF78v0h1N0x7oPwUSEPwvGllJYYKr6jypEjQt4h/VmeGcOEe7xeNUVrmmYH9mFhvkiTcwVGA1lkRH5M9s04mNwjE1LUbTQVxb7D4imc/ssbkphIGuEo8MlXvAQdBNhFR9Z+Xi7Z6LgvIYi/QrFQd+InAdSqd9v4E57OLGjlAaSmSqRMHeFCef7AvkiHeT6QFBHZyJcAJUEi9W1zanbHDeGsvBfnLVsLrm26CNn3Bvm2rVjwKzgl1VDBj5LEnB/z2PN2bJe2wECvTbdtAEryNRBoziM90wtB7qi5Z5y+T5tOxBgi22HygP3ZJILXcTqZ1DxcLUtVr0xOYdKFP9RxxcB7/DA0jpYU9YLeVlGxR+BOGIYJtpENZP7vAbiUomNNClmlJb94Yce7PpPlSNotMFuRYNiy3E0yECT9Wg+2V7LfZ1u6p6mAWRcLL4h9reTQYCcQR+L5TMBCucKO564drJmfa9RdWhNua5AWPbOasMSXItvNR1GyDtJGFanysPfib2CvVMxE5joxg2DTsydLdfRrkM0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w1J1O/TFkQo7VkBcA7MSxcTc1BFrD1DZx2BD9O59feoVIiHZKRSGnLKFUGTX?=
 =?us-ascii?Q?6/aWiVElmmehtrO1OPpJ0CHcPDuLuceFIfCx5Sryiwig1Ar+/66HyU2cWWSb?=
 =?us-ascii?Q?csGIOSiE/2yyGtSyEXyfWKnTvL0QJsSawuARteK7okbRLbyyYsm+76X/RUjU?=
 =?us-ascii?Q?pazfNBeWfAC1c+b6ZsPOyxBhzKnjrf9ryqKx5ZCxTo89COi2w4qkYkQD9vbD?=
 =?us-ascii?Q?I7/1679uvKjvB2/wfSn+0jLfd1HWpTQNWY3YuQc9fmGqtPGwpMYLWJmiey7M?=
 =?us-ascii?Q?+VSKRkWd7ZoeFXR7gk7oV+lk/O8nZtPT8928JnysRNKi0oWOixYDggBy4eu8?=
 =?us-ascii?Q?n5kYtKpkQLlK315cFUZ/RUgdlPfBu8rGX1l44nEfDbdZlVpwn0WsaDJFN1Ba?=
 =?us-ascii?Q?wsAr4ksUwUZq164a+5Rs9Zy9DyMRV0pLvCZjphdx5qE8iATxKJf03eWKsboy?=
 =?us-ascii?Q?TBeCrN8wDl8cV8LU3qaol4yqbcwh/fpaaLzC9mt7Sc8cdrrbq5JBnKGYM65A?=
 =?us-ascii?Q?+m6+Ox07PMm6x6oUk1+QkwF4q7DSLOkhRX2qDkotys2WUYd6ltqKsgKZeCl0?=
 =?us-ascii?Q?/B0CwiRmZpFwhttJuOHbH/u8C15j7WEI1uB/YqWz9pxA2uoPVUQ7mgRR8y0L?=
 =?us-ascii?Q?uI6R92hWtu8/blHz3pxsTEgmhy9tCsba9xmUQd54ZHAvR8acWN0QOaT8LV3m?=
 =?us-ascii?Q?/CcP9R2kKiMhD+5/xna+DcPEzxIc/1oEdZoezulQI/Z3emfRtSZA2kl2ou8r?=
 =?us-ascii?Q?gy/blTkvR9MOCh5U9DICiVDZffEbXRmss/x9foYRYoR7G376VR2EmSCmZ/56?=
 =?us-ascii?Q?DSbE3igxqrahy0xhmizqmcBGmdoRxIUdshGapztWhf0Hvl43/cxobpv0bzP6?=
 =?us-ascii?Q?vr/d1h1g9VYNUWbGMnEw7fjdgBhjBRNhWik+3bsoU3Q3vbINcrNI6eu5q2cG?=
 =?us-ascii?Q?bdF1BkMN52W4vcQnNenma8PynuAIXPKb57D/AjdionFleGGIrNrztZTmo/nO?=
 =?us-ascii?Q?dDr+PX++gn4wnxzEneavoErN54/eH9GqYtNevYaqnnCxFGcaBFTLcRNimEWR?=
 =?us-ascii?Q?ICGgj7aqg1Ev93Fq4LT6I4JdYMte4CnzdlnW2B7NGgO3wmeadc0yagi509Ka?=
 =?us-ascii?Q?Huh6dP5JhYscvafeYfOMOYE0jlvCARwVGQ9GVYceQn2haQBV8tVAr+YHeXIT?=
 =?us-ascii?Q?c9pYH5cPbeU6M9XBgYjRwKAi9ZLEjnyYmTC5lHobhAvQk64LyOokQ50q+Bg+?=
 =?us-ascii?Q?owzpYXaccQO8IPmPj4sx47Z/hK0Uo8SFv5k60SPbY4jD28dLwiEg7UXmA5cP?=
 =?us-ascii?Q?UHM7qe8SfAYXSZcDlASNgXlosvQXR9L8qDWFEe3nRD8Pw5a/tl/ZGdMjaS+p?=
 =?us-ascii?Q?3IPPLLcJOcqEH6cMtAWKJU6vVhh3M92J4HQGItnybMUiyQgiBH4uiq213MQx?=
 =?us-ascii?Q?IP5a2/9XyO9dktpDp7J6i9kKPMZoMkXFR7OoK8NjazRdgh1xe/IHd0ibkhaa?=
 =?us-ascii?Q?Q0ZAh0rEJ40+LEdM4WWhZ+QkKbDiDCLrIq3fRP+qUPKlCcb+BTk2y/2MEVU6?=
 =?us-ascii?Q?H5B9Fw4V8EialC1F9Zzktsn46B6rAqtdj56JC5FNTS4OsDpXEDapS5V7v1Lf?=
 =?us-ascii?Q?MeO4Sf/4OQlsgoZnv+TH7rH1F1awKaMOJl0rAMXxzl5XclrUUQRcsxDSOQM4?=
 =?us-ascii?Q?e3utQlXHrRt+c2mEcfH80s4PHs3S45jfZ/kMo+riSh+4OMElCOpPW3Ax/gTw?=
 =?us-ascii?Q?mH6wwcrS+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe7ee46-212f-4c33-59f5-08dec6357c58
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 14:43:35.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5Mddx1q1nMkY3QRdilHWhjT82RGlQ+AidNVX7wdQxTGcRkU3TuL0KrAnFbd7SrO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zptpy5cq5p48mbha3geu1371ge4bqb7y
X-Rspamd-Queue-Id: 37C802000F
X-HE-Tag: 1781016223-765969
X-HE-Meta: U2FsdGVkX1/kRewmhFC/aW5t4FQh3et+CH3l+u9T6wAx7kLwoaQhryxpJz6C2xRruV1mGJIJqC5RIXZja9eob2FZkkTv2hfRHuwD+XRYxkdRYgUfWB6vn7jV+VMi/MF9MazmShc8fuF99SqgylmLKpd4NJfBvfKxZhAUj4U5/WJgBKjkZ1kIOn9Rjzz9esjvIFJT4LDUOeaYUuK3k6KpzcfwhiJ7MfJLGJag8I0Rf3UcKdDDux9W+YKoNJcbymGkh91xfkP+TgqV0kkh464fva1l5ma2gdFkzSvHfNRzAEwyF9SO6Qt8HhmnlE7ZYoWXVPDHPiubYtx6sWDZ/b+CL5ANEmIPKbOYvdMRoTQfIWwxnQbAyb1XU1G+rcZj1wLYXJK0YYz+jNNpLdHlHhI+mrTUCUd/qjZHhxwAfK5y+GzIeSNfF4S1OEUz/NYUiF0PCshe2SgOGyXxbddmfvZBJFNw+ukqnS1A62oE7jFm8ZO1Zn0oT5w0hlBHAMBcMCO4yy0DTGYXMg/EFBGz86LWny95BcLdIqga0IvLldPeftb43c5slKVkEKLoCuk9tbm+oCJ+6jlz6C6wVU0L/+8noUUE7JcIyWuvq+vg7h+nyBOeTelZhpRLxQ5VxoUEiQUgXrjgrfnOqHY7FxXKeq/XXNak729sFg/TYE+CsrlDrjtabjs89R7CDdPnl4zWHqhhxoYc7XzfZ8W7aUtX2GxIfu9Pgrr0cwkMrr/mR/+JTDKs5YR2KC8R/Rw4MXdNgiPQAxZz5vN2+XfWH5rFERrYrliPOBhO5Iz08ShnXl1kBww/EKSaAhzy64w2URCNxQQeRu0ErD1+WKyKFwUHGW0ceimV3deLI1KhGgz5rK4hPeTGlvOl1QunNwzQJn98fX24ohlS6/pM3ImVMvRVe0Hqv+DnMYYDIohCSXuZ+0QFQO9l07M7IJm/ERrHp74pIgNY1bcHsggXvfYbSrmQGft
 AWMo/GiM
 oO4hfUMhQLsI+ZmDGwFer6NW8bs5BtD/h/2eGTrOtcItrS3G2OMG4UKo9ZjyE2/3ZpP6jn8lf75UugsOIbMIU9V4Sy8NXvRdftXAUC/VQu9ngi0AgIdBl2Tf1+hh9tSaaI1in5ZdqXHz2la/kG6CmT+8xi8x49evVSuTxwZZCmWUor/44ixPb4ICSss5PqrrjCxZwrRhJEV53Utv9Wj8TDepCz5WAL0cm6mjXhCPTp/RHyPwRAn+VKY6stFLSrXsraJk3Ar6PN+yo+ZSRhZUH5uDjNH09sLQQ6+AYhF1yqTbGOx4lOHKcifwFeE/FqhiNCgobG2ufMq1TcVFK/Nzpms1TDVL8MKraNCQfIzZnv0unqSwc+vRAf/ZRt44x2jRMZJmsnoQQPM45d4NY/Ru4Fdf+mDOfcKb5g1jMgU9mPBm326AJ7NsMLupKEkgtElAc6Tba/kn3NKC6J3bAfLf4cHwichANZtTpSpUUo2NdZ44UCYf4ea2FKKY8QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jun 2026, at 3:39, Lorenzo Stoakes wrote:

> On Mon, Jun 08, 2026 at 09:44:42PM -0400, Zi Yan wrote:
>> On 8 Jun 2026, at 20:29, Gregory Price wrote:
>>
>>> The nodemasks in these structures may come from a variety of sources,
>>> including tasks and cpusets - and should never be modified by any code
>>> when being passed around inside another context.
>>>
>>> Signed-off-by: Gregory Price <gourry@gourry.net>
>>> ---
>>>  include/linux/cpuset.h | 4 ++--
>>>  include/linux/mm.h     | 4 ++--
>>>  include/linux/mmzone.h | 6 +++---
>>>  include/linux/oom.h    | 2 +-
>>>  include/linux/swap.h   | 2 +-
>>>  kernel/cgroup/cpuset.c | 2 +-
>>>  mm/internal.h          | 2 +-
>>>  mm/mmzone.c            | 5 +++--
>>>  mm/page_alloc.c        | 6 +++---
>>>  mm/show_mem.c          | 9 ++++++---
>>>  mm/vmscan.c            | 6 +++---
>>>  11 files changed, 26 insertions(+), 22 deletions(-)
>>>
>>
>> LGTM and it compiles. As long as Sashiko does not complain, feel free to
>> add:
>
> I would add caveats of:
>
> - Complains legitimately
> - And it's about this actual patch not something unrelated
>
> :P
>
> (Not speaking for Zi of course, but I mean just in general I feel these caveats
> should be implicit :))

I agree. Thank you for bringing it up.

>
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>>
>> Best Regards,
>> Yan, Zi
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi


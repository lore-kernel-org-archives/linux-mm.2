Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1D4CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF776B0092; Thu, 21 May 2026 10:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C968A6B0096; Thu, 21 May 2026 10:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86116B0098; Thu, 21 May 2026 10:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4B546B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:03:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D993C2233
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:03:26 +0000 (UTC)
X-FDA: 84791594412.11.58E452D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012016.outbound.protection.outlook.com [52.101.53.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 49B3C1C0023
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:03:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Qs+jji2S;
	spf=pass (imf21.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.53.16 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779372203; a=rsa-sha256;
	cv=fail;
	b=7KQGjbivg1Tb3nS069HAhsK/gD4oeAT2/N3A12wwwjmogGUDo+ExOu8aZd/2uGOreAy+8c
	NfWBgsahB4Njz+l9qW/D8IuYTqhC+JxEQ8zPVTWB/vusyYMiztchFQPwOda0BsbktOCHBc
	ycyXw6cuv38HO251jfVqBHVqn4DQUdM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Qs+jji2S;
	spf=pass (imf21.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.53.16 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779372203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2Z2PRpUaQk29WUzrOWqzNZsNTu4ms2layIcRwQSNAA=;
	b=4OSAzxbg/urcK91Pk+lELW/koNOnP8PeIN2hcAB7gwJI9nK3fPQ/Dd6tnwg+DB+IZNCEPC
	NeOhKU2Rq5Q0I1cJA/f5cVNZiBaNUfvVr+GtCDrKkOIwrzK+OxE4JYA+oA8DWRlqbWc73G
	bdUmHZr4DTD4rIZc05QR5uzo6hh9OpE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KcanJw1M80ly/Su6Omxt4REUuQSZZCanE62RdRTTxvpEB+FHqXd0H3f+lVzSehs+H+0XZj/zgELUbMxsNP8cWyt06fDwOaMPT8cU83k5TQWKRQkWTwbg7wPmBQEJBHBz7xgJChGqSt8NV6ieYeIkv8Rc1FeFOa4JcOUOWsWbMV6mYy3l9YQ1DeaFSwH2iOcEotAwoCIwUhcmAvyUyczqnbZPRsleWAiodOsG5B+NEltLIESaDdObGGXUT8PCyBJZRE6SsETDU1WxLewgZObevAD1Pn2TFzOUh7sG5/fHvA3MX0zgUj8O/Dd7mnjt5KyPTUBw3Buy7wT4HX3fgZs7KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2Z2PRpUaQk29WUzrOWqzNZsNTu4ms2layIcRwQSNAA=;
 b=Vv7puc5Wv3oj+CZpKlBTobTx/6B0XX+iHiEz5GqoG5MVhmTF/EH7pBadrx9SBD4V0MuHeyRzoS30r5KiLzVeSpP4pLTtJaQI+f7Q+Ul2TzJGzdqFDVuRwKrs0MkMz5oqBWEYWKLxN3vEvzCTQmDk7TY1PfA/SRU4MBYkt0cxoNRll/rHOhpYzTHZxG5aPpRvfdS2Ao/eMBD7jsiFEJiaKhLiyjzGKKpDcLgAyrzZzNZtOlqmvzUVd7ZnlZ6ndt9R0U0czwdxuQKv07Be92y+LExneubNrPMyLyOIQuh/Mh5nBlP3DkL5sM5a55YEzFtdlB9DXwqZ9URDHUZyHqUfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2Z2PRpUaQk29WUzrOWqzNZsNTu4ms2layIcRwQSNAA=;
 b=Qs+jji2SSxK0iD1pGoKoT5D3QmTWTXHyt94q08pwCpKgVf6J5eft5lbrTo/t7sUy+mojmBABlQM1fsAOK+WuJzKwd6I3KRnUp+YoX+flkyxz8FdEcZA6NIQ1kH25fuBHqimxgXlHdUXXW60CK6jeBintOhTqHi7OKAouVmxykeP/cB88m4ctYv3x8fPr8mGCV751CGlgA1qt4CViGtsQJqmJX3+uhUKIqoWEjl+fjgop6XGmXdBMDUJKOuuspvyfqrwThvVun+brG8OqcJrO4DrOxyNsiMkwoEt771L72U3pPb1F8XOjQ69t8A2ra3+9u5oovMB+fGJaZ5A3ZdE5yQ==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.17; Thu, 21 May 2026 14:03:08 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%5]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 14:03:08 +0000
Date: Thu, 21 May 2026 10:03:06 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <ag8QmhHI41OiVbWs@yury>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090655.160282-5-thorsten.blum@linux.dev>
X-ClientProxiedBy: BN9P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::17) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: d0142530-86c5-4d92-8ff6-08deb741afee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|22082099003|56012099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	UWO+YFkNpe7O2wzRUZBmikVXfkrKHJusuImbgZZSYIOEJYHyv1vKVO8qrgH81BIuj0jvvjx0Z4I/ZSYLlTnWmtVCtkaBtpZhvjZwq8Ac+FLGAEBgJw30Csc3PQguQKEyF22sltalNirbo13QeawKnpg8JPiLrCiNZkGu8oQ0l+xCzhM2p5FtrCD/XtGLWcgklbMkXc6FEDHJCZNwrsMaB6RnJlO660kQX7fWKGTEFeMwsd71MWmm7GCx+hUHp0BfrKoCe59No4hrRz7AvJFPRcgvOSPtWgXVdsvrlhemzye2wzKmZVdMEh+3QObc4SC+Jbdu4+qATcuTs7tD5mxcw9CaIKceqpHeJcvOXLHZEJd0y2z8xtiE2EdIYD3vRUsZE/OZ/WdSaZXuIExfUaXh5L8z/7kFmr9gNt2XaUBEHnbv3R6vW7sfV0yNbtUv5bPmJPz1tva8/morO7UFniKKrJvGRW6cpwIYU4tuYeKC/uDqSxQmzlCopMcd4kXjqGb3ewX+DwB/oBB1Qzgnhl4OCVQV1uv71w523rJytaocX53SInVuHVLlhg4wgM2LyRE2EyT4BXzDrB9fjiTos3k24lZLGJLfVfp4qVqv2AKxmOBrUvv/2e4CXzmqW3fohw1LQtjold5wg0XZYeU0u8mUYW7d5qLD2zF0pFN938d9cqQhwenFvOH9slfcgf9O4fAJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(22082099003)(56012099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mQwvJU4s+dNfWcEj35YKZBTtyzSzTwgsNsIzWJ3Or6C+muPXu5LacOKO/P9p?=
 =?us-ascii?Q?K3lqGjJ7wOYUTbeFOFvRxxM1cmWkc8NZemJIJ3nDWvRFiGECnW3jkHqlHSAf?=
 =?us-ascii?Q?Xltii7bmSjnRmfjQ68WK6+q9kymQ4QIhthSbi2amQZDhz160qE3KXUX8FBe5?=
 =?us-ascii?Q?NiYHUWr1Io/Yb8H7xIrr85fVlC7tQQYdyluXFa2lAyRgQmthfXIWBVa2RCOr?=
 =?us-ascii?Q?zR4aJFsJJxFUUpFic6ZKxEXHj6C5U9mEXdxfOhHFmjsubx6gmUROgZMAQ8Hp?=
 =?us-ascii?Q?KdtgJ6Rn45rDj3VV8hVpEyXhvHzjiPCKWXDUxF5r3xcTecI4yo6TPVtMoOh1?=
 =?us-ascii?Q?8FmsbK6Ywa7q1HnfD2nbqGzJ4+s9E1yZ1jLfReR4GFfz/ysUvWULh+trSb2Y?=
 =?us-ascii?Q?3JSAbno3AJOEQ43FsnOi7SJlZxtPN8J5jNQaGOBK6iph7hq2YHXKbMB4zyft?=
 =?us-ascii?Q?3zIbENUXkhqdV+oiwz2/ruk0t67CwNJ6mnef0pBmjffmmmsvbXFoO95E5B09?=
 =?us-ascii?Q?w041O6cvEzewmtLW49rSb1Bv8JekFz+9UWHYbf+WGg/CPXNi2qKKYOakIrdD?=
 =?us-ascii?Q?HCwbhOr95kQ7PAxMzgosnB9jtfZvuignul6avQPOVU9BOpHwZcOV1PTjrAPh?=
 =?us-ascii?Q?wIGExVeNL+9Cc25gpWuo2AdCzpf7bjsnj7EExU4kSy1aSOhXarcyhupF3ScF?=
 =?us-ascii?Q?+n2GO8kxhZWYH5Xp+laYZkysItzWBvbrlr0ztEpGdPK4DW2DyuUpXoSxYhMB?=
 =?us-ascii?Q?Bw7ywYBrWZLWedGd1qWOv7aM7yPDYq40XJopPE4sGEwr+vTcU228/rBcBdpl?=
 =?us-ascii?Q?fxfOkh4WWAQAVAsQGc0SmFj/2t8Ep9KxIkyK25fyOf2/Oq3pNRzjjZ9A+3MW?=
 =?us-ascii?Q?T2uP4QlWbL1FJMxIKkfAlSb7+lljVf8qEpFbyiiKx9azyP8QQUDHkHJJl9nC?=
 =?us-ascii?Q?tcxjQsH49I6j7EewFIANbYf4njV9ND69qNnnLv/WC1KXhUd/4SgzWRXv+P2+?=
 =?us-ascii?Q?xaGGs17yprSYgqCxBI1h0auUWL2LXeKBbl0W805f4OyWhzKp+N2KrGh5s5WH?=
 =?us-ascii?Q?CPQjeewrq4R8JGASieoX+WqvnuOnEUs1iIJqX7AhEhbTQPgKe8nmRgDA8Y1N?=
 =?us-ascii?Q?q/n3figFWRQC6tI7agpMF2XNxct7ms4eQExD52X/+CI7DJpcZQ1cqAcp7dxp?=
 =?us-ascii?Q?t/bHtwtFVOFPS3acl49MEljEGw9+6QrDj4QYDSoKegFDdmIpme99UPDhyFF3?=
 =?us-ascii?Q?8L6DXbTwS1yWSk0UBmAMSewIh1piSVBCWfDeHRIZXbXe1zayGtYPXzm6SBY4?=
 =?us-ascii?Q?3XkdM/LQ3fwaDC07iKYe6zRjD+yVToOjdsKmKOCQ8rs15gqBK1PPRzC4JYoC?=
 =?us-ascii?Q?+zGZbkRVHk07vLjqi4k4/u/WLeMcFxVXhjf6kQfwLB+enJobDVY5riWoEFGI?=
 =?us-ascii?Q?Py17ePU2Y/ay0NZKLpBD3F7yP22fpDxoJplcZnLrZZrTMlwWWZZV4OPte7z4?=
 =?us-ascii?Q?ib2f/G/D56nqtoKJghasmj9hjkOoKudY9s8TmzMxsf/jBgfP89RldE4ifHPl?=
 =?us-ascii?Q?hMMPgoExksrub+j4RsXRkXKOJB6+kxJAFWuBXgUU/wk6qk7GT9g88jU+cmtF?=
 =?us-ascii?Q?VuMpXa82r8Y3hL3L8CCj7USjYAI+pDyoyjpBy0jz7NNaw9/eekE0LE9Jr0NA?=
 =?us-ascii?Q?Vw9M2Kf2d0ihRlsOG70z/r82drOz/DibBT+OgK1NCMmepnLrlS0RduBX00cA?=
 =?us-ascii?Q?O1Ed/o+QbYHczKOiGtlFBMk/9GXChdDCuQCnPpQFwZ9vS4CGxGtT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0142530-86c5-4d92-8ff6-08deb741afee
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:03:08.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnQ0qZqPaTsmatpt4heO3oiVRf0ypBDIXZFBm2iWCrFoh4OTniHFZFc5aytXNPq14w17BaZBxB0jTpHW9XaQ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Rspam-User: 
X-Rspamd-Queue-Id: 49B3C1C0023
X-Rspamd-Server: rspam03
X-Stat-Signature: 3iack8ri7no68mw4mhbk6qmya4ektc5o
X-HE-Tag: 1779372202-414703
X-HE-Meta: U2FsdGVkX19p8UDWZtC0rRicOMY3V3ChZzL4La157TIIBgXXE3U1R0QXIWdw8ciP0mukx+wwXYQZGjaXSLrrcoemwx6IWDlmbokyWOMuyTz4ymGVtLm5gvLAhQITXKS/OCeKkYjpKYBaYm8r9rau3gxrDgnd9KcPTxJ8m1ZDPu5i8mFbl4CnBuIm2YmL/Q2JCKD9mySY+ZAnwlt4IB/p9sBvaRLAs+0upA8m1BL1OvXAnWFWcn1chGaxPi414neMb3DTqkJLbprGWmyAJfoTYOzsJS/mXWmEx/Ovgyo41+R8ksd8cdVuqtjXfSM8JhGiep4/R1aQbcmMpvetcVgRHSX5b5TZ5F8qvKuMiZ57IXRc+InFngXtTiEZMaTm1CGShb9US0ouw7pcrS5W3a3i8WRW0gRqXZgPiik2Eo45lszZlHnISthctQfamyXDyyMOdtmN3imOeo9S3rjB4nOdVmiRHlfaaE/dIAp5QvolLjHJrMgz7WiXZwzuuJEngbDRa61It/Otw6L44fLQOt8v0xnAi778rYhrWIot/1QsUlPdtmGsbaeN9JC7vTv4rRhbKjGQfQEjsRjGiTYFa0JV/NVItgdVvFWo335QrsZXN2/Wh1IjVYceI4MhQRZOJAa6MEDxWUDqPv45KcyVEzbZgSWBKsQdjEaMJf/iQ/ijfPKI71FJgyD4Its7UkLEvRH1k/jMgL8vHrCK0S/LxjBHEh42Zth6HmGR30vLFCjiTB4ZAzMuV3oJNR+oWFNBHzss+UO/pE9vYFb8l7LZb7kxwr6W2SqkoLO8K40+pnHEIhneLGHJxS0thTiUm1GS/l9uChLem2fnZdTqXyeYOhAtIjqZ1dAv73BJ0JC0rPB7h0Yr37/nTGfQmMPrtZlwdC8bIvdIzpypyGxgVHf8CLDZqic3jOfUCW4Fjqrn4hp4D3V9PzvhsHSaNcEk4/iV8VqvCW/qTD95fglAKrHqJWK
 t0TqA9zC
 znZ2oqEoFC57Z+j0SRll1liSzY6fhuYAJGjICDcfq+6nUZ4782nRZRGTptCjO/WJBzKPtgQ2XGJ3xIJcEG6UH2OsOSK5JfM+/1GeCGDlM7nKo/KdEOsbrb1fZsqC8R8MsrgBaRvViyNJWXhpDO3Csx7/3RdAdp9B+6yPVwKa4p5iOZp+q7npuNLGpChf0IGjRyF8LOJLECWoU7mowznMVmkCMxOgbD/gAPlN1PmnOLPSeg5RSRJmcly+dR0yVU5RkgbSSRih1UN/bQsdr2It6+BlHTxYEOcZ0VhgGkFU+Z/+LRVaDupIXwLQf0gm00s7Itu0867uWzhVTxdsPSGFwq9WyiFfRPTwPfc8gKYPyRtuyrrj7359hvHqEqIpBPjvj3qjpzgtlgBi/ZETeacE/KRLuqu2HaaC0D1YbMK8vhJ1Fa9y9OGcrccezn7TsX7xjKlpfKXhL73GlKf7gAf0/dU01O3lrDOqTUsmZPDk+BBluC8aap5M8oEa1TY8iKLDC3LTbiZSHvsvpIu4OC6NXhmoZq4Nb3AK1QuEGMcpBxHeIeydL+XeUYuonRX2TsexX5nXXrVLpvW1sBj/1BTC//aNj/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
> Move offset_in_page() out of linux/mm.h so users that only need page
> offset calculations can include the lightweight vdso/page.h header
> instead of pulling in the large linux/mm.h.
> 
> Include vdso/page.h from linux/mm.h so existing users of
> offset_in_page() continue to build.

lib/string.c doesn't look like a vdso, and AFAIK there's no vdso
candidates for using the macro. So that please don't bloat the header.
 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/linux/mm.h  | 2 +-
>  include/vdso/page.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9cedc5e75aa9..d5c7f1ca80ef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <vdso/page.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -3023,7 +3024,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
>   */
>  extern void pagefault_out_of_memory(void);
>  
> -#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
>  #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
>  
>  /*
> diff --git a/include/vdso/page.h b/include/vdso/page.h
> index bc47186c07fc..948b13091084 100644
> --- a/include/vdso/page.h
> +++ b/include/vdso/page.h
> @@ -28,4 +28,6 @@
>  #define PAGE_MASK	(~(PAGE_SIZE - 1))
>  #endif
>  
> +#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> +
>  #endif	/* __VDSO_PAGE_H */


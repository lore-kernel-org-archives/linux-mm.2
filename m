Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20334CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFDD8E007A; Wed, 17 Sep 2025 17:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0488E006B; Wed, 17 Sep 2025 17:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6518E007A; Wed, 17 Sep 2025 17:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7528E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:21:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECA671DF905
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:21:48 +0000 (UTC)
X-FDA: 83900014296.01.B2AC773
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3065BC000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:21:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xvgb35TF;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.23 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758144106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07f6H1t7ApqFDQgAvGWdfSPK4tO9+C1E3U0BMX8346M=;
	b=Pgu5rTu31rx9W0SVqQk4fXwm5QRRSuupfq7Ib8KGoAVB1fIkPkXpVWnRPWFHurx9KroyI0
	uoVrJKSCSY5HCApAEeX6J+IzOsWIYEo5ZCIW1oDwbCjp0X5TZ/Y1627nZ+YyGkktZ8hCKs
	OjGvAnh5bRAaOKFd5d0j0fa/OhR/t1E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758144106; a=rsa-sha256;
	cv=pass;
	b=B5pqsPOvj6dRsTzH69U+vv+5nAG7KRqzV90jWBA/A7z2iRyZGebGPMvHN2B2CPifvrAeeN
	RTAenyQRPrtIdOnjgGOwxLWVhMvA5yVsI97Pzgt4x7HQq2dwfxklcN41vsmoh+GN3urIyI
	Qaa+i/3GxS/umiioYgXQijNNf+Z96RU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xvgb35TF;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.23 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1eVVxJ0Sx31qI7NpFUfVCD3Ajk1hPTp25EPWksfkWz8F9dWFH5dfI6fjxXHpPUWWPkBy06waaSnBuSo5Pkj643HhjPi4whmupkH76nt83y3Bz+Fj7nON3Epn9xGHaSwuOE8f5IlIyRXWushUEAcSGUGgUU3HZzZExzCCtUhu0jGmGpmAGEAgvC1VOQUcEDwNQj53mXRx2exIVaGUfD7vJu5lbeYdxhjlZwUYxe8c5f9GaGTbMBUJSLn4KKpPWBBjKsStHs4Bnowx0xA16sbubAHHn5y0i09KSjFefwCKn5fRtY1z36njKdJrWaUQhYdqKTppossd5lAvEzObAK7PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07f6H1t7ApqFDQgAvGWdfSPK4tO9+C1E3U0BMX8346M=;
 b=kTqVFGAvkrVKE+F7wbtpoTDKjOHnnB8KeaktBqtVxbr0YVCM6qglPd4xu9cWrH2CKraee+7OZq4jrbDMI6/nYAvGs8KP2AqTX8diJnrjtIUqCZYxxVtJNy0cqOSFQOAVep1d90KNY9GN6DEVxUFZtMHXvjSxxRi2tmoymG54dJ3A/nZ9g4PharkS7zSonPQmCSXr9YiOzvere2RoB7F60H9uhUku/MeAjY72XUCWFpCCY6XrV0Gp+JQ2f1xBbYBfqJr+STBVPEnvg2WM8fme0YidQ/pgodrnMNGsIdJLmUtYk0cMFiZEXY/jLvH7Vu85ETy2lAsyrtSSnAXnGIYZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07f6H1t7ApqFDQgAvGWdfSPK4tO9+C1E3U0BMX8346M=;
 b=Xvgb35TFC1IJwSVR1/3+cPXtrP9PQwwB5ZV+P2bzXIpob7S27GtYKOl3F6/l1sIQ9BPsTJRtGpjV3ZWfcksuWtC3V8/gWvvrvIAeBjLDNDhR5e6tHHAYXB7RRxlGiRvH/hUf6cbypkRi3eQCbdEuM1DZOfb8MQuucv6ixdhif+vEO6iLPb+ON5IaNgT6+O2OoH/fZRmZU7oWLzAeglM7j6b5qhFc+dTml8yhVYPhJksN7he67XahQdYYkG9t0PEZ2eKaiKcG25r8TeylfVjpxDj0p+baH/TzMa8S7P4nrpncoXemcDVuIVreNKe8BbEGL6vCy5ySXZ/GbKHZ2BKpuw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SJ5PPF665EE4E73.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::996) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 21:21:40 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 21:21:39 +0000
Date: Wed, 17 Sep 2025 18:21:38 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] kho: add support for preserving vmalloc
 allocations
Message-ID: <20250917212138.GA2101104@nvidia.com>
References: <20250917174033.3810435-1-rppt@kernel.org>
 <20250917174033.3810435-4-rppt@kernel.org>
 <20250917141528.cd619a95a19a33d71dcc4b1c@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917141528.cd619a95a19a33d71dcc4b1c@linux-foundation.org>
X-ClientProxiedBy: YT1PR01CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::7) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SJ5PPF665EE4E73:EE_
X-MS-Office365-Filtering-Correlation-Id: e596736a-bd5e-480b-3761-08ddf63030f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w/g1Dx3G+/P4kmWNSdk+eCsHLXJ1L0gFdvLZcohBx0vjskv9MfwF1UdbdLuE?=
 =?us-ascii?Q?gPdKwRaEnwvduh20vHvjfjcSKxA55VMgqWf5ZQuiVCWG6mWL4tcc5fn18/Bv?=
 =?us-ascii?Q?y2VixgMmuPJy2XQKcNHu+BdSyQlWDmqxNvudZhe9z/xghYegfnI6jWFHsYUf?=
 =?us-ascii?Q?HMr8VLISPkqt4+ntBsrEN1okg+rLllylyPXpH0f8l3N5xSs/1vC7GcZ6mXxa?=
 =?us-ascii?Q?RcZ9ZIM+Gb5GybFR0HM2Mo3+XptRx9b8Fj11lDhD78AjLTFqBkhoPI50PQol?=
 =?us-ascii?Q?2XPQrcWD7o6fSS1WNDJji3WDphRA1MXdqbA5Te+sRGuN6NRap+dp85iQg6Oc?=
 =?us-ascii?Q?jVNB1ma975nvL+JUGI8q1Uvwam0SuXm6FywKC+dbE23c5s229rl02lm8MZqZ?=
 =?us-ascii?Q?ZuqJa+BOUNh/mGkOxCJkitQ+r6BjOrVvjQgd49/N0+vJeX1gzzZjqAakEGLz?=
 =?us-ascii?Q?3eFk+Z+9YGjS1amQWwR2WnvdytXNo5hX1/F54ajvokr+mNCuqixGiU+i8JKa?=
 =?us-ascii?Q?Y4g1h/udgjgynBQbLeD1hXhxMk+aab+8tWdPZAVF/Tai07v/v81Qdg2zKv9F?=
 =?us-ascii?Q?kDwYQTKTQq6F7bdkAvUe/U6mG+Pvezc+crjscamAR1ihpvB8bjqec3ErKE7q?=
 =?us-ascii?Q?/nmU4WLivDhdRO4BoyBo8uNQ8ia7hhEfLJ1/do4vgAPfH9FbRSrTrLb/BcLY?=
 =?us-ascii?Q?yT6He6dmYUxqymLiYwvLL2WtcXR8H0TL4HTNsVf/n834kshuqU2nwPKuvzir?=
 =?us-ascii?Q?7Oot/Q/7ygUQMGlE8fZOMoG4WNAS+P0wRRAhINv7/+mwPTiQHQPPaoyCf8PB?=
 =?us-ascii?Q?7qGeeFaMfzVZ39R4Lu5iUchug49y5RPHsdWG72QRQtM1kvQNVhoZ8Ye1PgpS?=
 =?us-ascii?Q?lsTeZbHLyEV07rKkLgQdd6v6dvXowcOcZOHRisjBtYot3z+TiXuGS/XDiTsg?=
 =?us-ascii?Q?ZgPfMLjyzLxp6a7W6kymM3Tmf1I2gh5c5U2k5yJuCOWVSqrELzLiKVPWeT+i?=
 =?us-ascii?Q?Elu+Cmundc7gLiPJQe9yz7WyLJBq/cuTBU2Q0zuxCA78IzO6feGpKKgA1Mn4?=
 =?us-ascii?Q?DEJhhEqO0w8+rdvndkeJvFDorjnOfFZqy9p6V5xuSy83evP1a6kTdO+QBbqB?=
 =?us-ascii?Q?Y2LvbqjyE0Lr6qtA6ayKHGh+poqkv/w2ejAP8EYcDn4/iTpc9V3mQEhsXagc?=
 =?us-ascii?Q?2VTGW2qchRMMR6T477O7736ViPqji9b7ScqJmI0tHZqkDQ+90upqyXX+Kh6g?=
 =?us-ascii?Q?nvR0a3umkAkz7X/8wb+KN+mTgz7JTLk7I/gwbM5hNATfUBbFBOg0HJlWSXyW?=
 =?us-ascii?Q?aBUY2sC7t+IGn2y8cy3Jid/41ABOwTKBymZ7rFry1Yj53RTV2BdK6Ri8CQdn?=
 =?us-ascii?Q?p65NumjCwaOvuJPrqh0z7fZ+0vWBYoDm6JrG/CcwkeH4Z5AjkBf13KXManhz?=
 =?us-ascii?Q?It07aqXI34A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OktslUyuxsCqZgXI9qY7R3H+Ijuu+MSthpqa1TkkA5jFa09a27VgyhENE8tr?=
 =?us-ascii?Q?K3ikxThFoBn2o4WOC913FmIF+vVyaLREqa3qykr5sD6K2UH9Z//+o8fjU6pX?=
 =?us-ascii?Q?GSDu046w9M35/ZfR3uM+Rg5NzXBx4ytOWEM/c+xagBlApMKtP2q595ET3UAo?=
 =?us-ascii?Q?6d6flIc7nzoJaSUMwnmvNDRr5Nkw+3KdVkgwEGbw9Pls06wT6MRkRIDXn6yf?=
 =?us-ascii?Q?Yc+itSUeHSlfc8eQkepF/pVhndl1rVUbpmbUIleFauuX0HtLhP5Hn31qWrPA?=
 =?us-ascii?Q?4vIyynqt5U3oZHbP9ERpdUb6E8OGdAU7qQfV1nNim5tYRCYNZ5qm3YgWv3rW?=
 =?us-ascii?Q?mXDgyf2P8ateoBXt/Hml0jChAet8ing39MtoU5LaOkn4XjpsC9O2U5pCoxcm?=
 =?us-ascii?Q?0FTDhgYuG1k4iN2ag16GFOZUZmrnZmadxnD8NXiRBa4CO6AQLwhLxnSNYgZ1?=
 =?us-ascii?Q?1FZiGcj0fgyj1uwjRoTIM1wjeU+VTV25HCR1V5PfoYM/Nv/IpbFZlQeH6Kfz?=
 =?us-ascii?Q?HU1ePRWeuwnL/W15Vo5EXKTa+agQNQIQyMNjrEp3Q5J4QgpQz83/VBkKr3xz?=
 =?us-ascii?Q?ra6+AW2lj9NgndgqIMKTNxTPV74oEM5xIFSgouNcAuJ6V4KDWCA05FaWg4k8?=
 =?us-ascii?Q?+aqs2/e6Hmkxb5xFUYfdHlai9BwJjhMBOKtJOblG5qJbun44/45y5IqDHcJk?=
 =?us-ascii?Q?ZwZDySXONHZsjdfq9agX4OiR6K7m5aaxNyQKw5swm6JRHgw2vLbAddNPaI7b?=
 =?us-ascii?Q?WHxGlZ/XveAmFIidF90O+vDQNXjwhWJbfwpdqfMg6vgv+CrtxVzs9TLOKlSq?=
 =?us-ascii?Q?X+r17xvdH+SY+xDl/3F1Jw8BHa8inqHpzte9sZr82TaBIMjOMvnEqIKyQZ6Z?=
 =?us-ascii?Q?kCExpXWcQdpteqhKZLmT/OEYJX3Q1dtYfD6mYe+LyE/wB/nYhyl3eoezKV6O?=
 =?us-ascii?Q?iddJvtg0JIqy/y420Adnrm1zmXhhvuXT6x0imUSEFqdRjCSJ/wVsrxhnhQnL?=
 =?us-ascii?Q?Mq6RmpLFgeBcnOIP5CM5AHuC/qwq2wgzgMo9z5vPeyuRt4LT67OiZN4t/Gry?=
 =?us-ascii?Q?nklMU2Xlug6W2zqviQ7REA97ZWPgmP/gPC4j8kJzbZ2MDNPH3BZqGAmA63r/?=
 =?us-ascii?Q?/1yz/gjcvtI48yNj1ZQE4AnZkERIYjHSsSH0XIIQ5UAmNRlk4C6SV3hCstCo?=
 =?us-ascii?Q?K79Q6VNq8qX+wjLnVr3UYiOEKAMhL1qqpP/SclOIGjNsIJRcc12cv1pbgDtt?=
 =?us-ascii?Q?ymNHW7holHaMnNFdT+kmlnohZJCcqof2cYCzEu7HUiRz+8eIUT8mm/h7eO0F?=
 =?us-ascii?Q?gDjY4Fc6l1slrUpCqeNEiKKWWQaisccQ3ptv1yUf9SS6wZ3BFlbbQTfT5rYx?=
 =?us-ascii?Q?EMWr33iDtppgGv2NysAAyJWfCy1JepzsQOHIKrsml8O0NdWpsXU/vfam9Oyg?=
 =?us-ascii?Q?nPLB+t4RaCTaQQiEO05NVokCLz/VLO4QiH2SArERtRQPNrssn85qJDaHvS5x?=
 =?us-ascii?Q?KxNTuk97yuU32xHfxG88EFCt+MQ6RjfH/k4bPELTrz9QuFrpszodGMMgnRrm?=
 =?us-ascii?Q?LMjcxKp0xgG7VLpglMw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e596736a-bd5e-480b-3761-08ddf63030f2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 21:21:39.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRvB9JcaREWB4HO5cRY/RxUwtnsfflnIxHTDgCiF+m8LZRom+4LjcB/v0Usp60sy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF665EE4E73
X-Stat-Signature: y8p7o8pn3qq7iwdtc8er84snwsdp6ifu
X-Rspam-User: 
X-Rspamd-Queue-Id: 3065BC000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758144105-25456
X-HE-Meta: U2FsdGVkX19MOEOQLLxEkf7uytnZJHHxgU+l7Gs80QjtPfQBk/dKQtMJDLj7qr+WafxgDa/g4mI73jjoYsjyoGYZyV69LR+aQR6/7gnrm+ZMGUJkvpPRMi3VsK1ZTsCo6DCH67BcxitFW97dAq8yceaG8jGbDOmcJYdiiK9dgPsqP+F1IE9s+jIyXpMKVe5Ke9TdDspSi+sCyBqOpv2DGWsCQo0o2iyGjOgB6GOvlZqosRhdpSVfzmtTapgUKAfMkGyv1SGm7+6RuoTh/yVkViVvgnfjsVAuKUxq8WOC1W7MkdCOyjRoMd4qY0EvfVwc0Kkirp37pj23Cf/aYvO8lSdu1Wntf96EqM1Jc5Q6Ro7N1ZZj1ArkG4yToEWtlNJSNLGkk+6ByQcmj5xDJPKHO/N+BDozzQHzNRd1mvwSd8sLMH7G0xkBSXYSsrIrlinbZXmscKQrG47d7rQNNLNfG9VhiZsJRipTRoqiDQPP5j+1rzHr02/AcJKcnhkDJCLy9hlap0ZLu+YPrQesDJb6SkcjHbgiz1iLvi15t1bbchxVUT7KNnrrvBrbJteoSbVUcknMBMTlj3NbwR1iQKLWAIUFCOP/TmFTExcIQsgB0YaJ5u1o12mIoSFia/DMRRJ+DZFVaHRS4mayY/HQeRF2aoStWAki7kEArO2X0zoszeoTZVnl6IPWEMDChhL8gN+5LWt6HBYDQlQp1GuBEjjLd4XR4qaRQMPf+OxfNBisb8hQ/s1w6zwScnBUEAKk+xi1aNVXTo3X4/4s+n7V5+zsqp4Ug/9+PPCMKV5WuSl7A9U7G4wX1reRcisHB934ieojxobPnqOU6RyPiRTHl+0gAowPSv1CdFJhDNIqOoCqzvzcC+FBAijw4QRHlrpXtcSbfl2YhFFF3jspSgj51mhUSpVwjBn8pMqw7ckTPInv6CMtPGqQHwSxt1JabMqj9o2H6uyPRALPBBAZBYu/Nbs
 2SlZSjwf
 e0x8ZWfchYzJlaWWYV95z3dtkAnADYM9aHs6WlgTwgoXXRu2Lk0bDAGlvr6TKPJ/+E/JgWqxxzQ4zO8L7XVCIS5hUxau2KVoxHtXgNIp94X8iCrohtY5P6vOh5ve5RgPgqIlu7JAR2au3ZI3DXGjsPugsmYbjpHMhS98zFLu2encD5jM60WxFEbeBfVr5Iu5qE+edigQYTLaZvw33ZNPc/vEM4DasUJjt5nB2zFsUajXE/fk1iXsH9jjf+/oEM9Eie81XS/gkIL4oLXqtnaNWcWWll/bDrQI2v68ALFlswtiTOzvjVeZrHqU9XeV/DiirPxQHWCZuzipl0Sh4M95Is1C9FihakeiyEGmjYtzm/tgXxuxXcrHeXBckl458XeJTbFqzmcRb/Kzf/rORVy8J2kVd1cus+S6/VrN6ZZ7QMb21a+oslqDveRfyZ+2Cl0DNyD6EHmhO6CUODoucczpEWCdKvBmsIHsdiE41NicODDY8humEaZRSvI/U+MQjy0h4bz3gx+lBX4IEMdEHANKONrY7ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 02:15:28PM -0700, Andrew Morton wrote:
> On Wed, 17 Sep 2025 20:40:32 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > +struct kho_vmalloc_chunk;
> > +struct kho_vmalloc {
> > +        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
> 
> offtopic nit: DECLARE_KHOSER_PTR() *defines* a union named "first".  It
> doesn't declare one.  A better name for this would have been DEFINE_...

It declares a *member* of the struct, in the same manner as the usual
DECLARE_* macros do.. Yes that member is an anonymous union that is
also created by the macro, but the main point is to add a member to
the struct.

Jason


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FA9CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB228E000A; Tue, 23 Sep 2025 11:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C248E0001; Tue, 23 Sep 2025 11:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A898E000A; Tue, 23 Sep 2025 11:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4146D8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:04:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60A25C01D1
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:04:26 +0000 (UTC)
X-FDA: 83920836132.25.142136D
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F1F6180029
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:04:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dipu7TKS;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758639863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xq62VKE0UuO7QG4pwwwx315tG/517L6WeCLY/0sBacQ=;
	b=I9/rJH4l4HL0vest/lsctMb66mdQuYBXMO3Io6HuS6S74mtLrqJV7rI/Shix2oJbT57KyW
	ftbjvUrL3iGDPj0hQ2g32V/GcnERqw2s6tyov3YvqKFeF5GFF6BJXYnOdTnpvuM7mOiPog
	QsBtSY+xwFetHOVpB19tqlcxTXDAZ3E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dipu7TKS;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.61.69 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758639863; a=rsa-sha256;
	cv=pass;
	b=idNLnu3sHh4O5y/ob90lsFN84bAxOLZoaNFTlXp1GC4xHVdF+olSljh2Xhf8PgS4oNzSdA
	3jJ3DmAIRa7o2mRKXid1EYo5wCa3MEjTQeKtpfNYkcEYXwUOTy9NmBLT9NyEnfC7tTQXqV
	44OEzQTAxLBHGkjUtNS4EHmWf00QxGs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhYEAE1r/HVlbTgqnkoFx+JLUhYpIKQTsXMt49ZY+EIUOkJzccT4+ikGBcILCP9WF9mYIwi3UGnk0qk3YRCsZutVCQA8uT6Twb+rm6hoQSW1QguyyVXEw5ovQn76HuGnK7/zd0+UMyVKzPkBN6UeucmuC4yiVVRCJhwpe3A4N1FGzWdnbhB21nEBn4BHryl1LJP5pbEr8QQ4nPF0i+T5w8r2NzQ0eVXbzccDLOC4RfSh/QfZpB2i7DC1lFZE1UjXX1KZj+PEJTdKNmS+dhKu1scEPe+m3/f0BMBoOilfV1/qz1hCDZHTZw6K7urzMO9+dndjJyc7rTiNH8bfIR6RyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xq62VKE0UuO7QG4pwwwx315tG/517L6WeCLY/0sBacQ=;
 b=Mg6d/vt1yTbspgZ+N4nzydY1n6Xy3Lhdpku5TMjC7QThT5PGDmrMEseZYdgt1+U3ktZHbix/oAzndY+kWnxZKmjLEX18XZ5VNJkk7ru4fZzUOHoOEXsPLl8kng48hOq/tp2LHkbUzcaIB4IUuCIp2OqfBpulbA66P0/VOwcPPcPXCE1SIMGbKhGQFYpWq2ruHGPX2V4dVGpIlI4JimTH5BBaSHPh7M6eWy5eUrBEEM4kOS9U2rOllUi88CxBG7Y0H2YTG5+KQB4lSllSbaXkFIZmQyIj++LHXw04n42lwCj3u+PtC4DASAUQubnWIFQWHm9jadhU3BrFO7oOpSxblQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq62VKE0UuO7QG4pwwwx315tG/517L6WeCLY/0sBacQ=;
 b=Dipu7TKSBAt+KjTfGqzDV/hIg8KxWpiS+VBtfq2e/dXWSh21B/PcmmuQFAcF3Ry+np2yNiYkelihtJyyFCsElRy/pBFZAu6jLejrDJHcNeW1AvD4DB0zlO0woRupM4WkSVg1Jo4F9Q3KmlBsSf6/8MnnO3//VqEfR9JhebP/Xi8cRyhipZmJbufJzwkBkSQ5689KmGhKueuy3lxaje/jbuoHl+/9FYQGSh5inrMEpD/dAYVE0B7ENerUgDj6aAq7gUoKF44IJabicdq0VY7ejBtE88htDfrF+W8WAa54NeJlj4XGUNFalz31RarGMNLHdg3Gp955zbl6eFGHfpbG2g==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CYYPR12MB8938.namprd12.prod.outlook.com (2603:10b6:930:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 15:04:16 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:04:16 +0000
Date: Tue, 23 Sep 2025 12:04:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923150414.GA2608121@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
 <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
 <20250922150032.3e3da410.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922150032.3e3da410.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::32) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CYYPR12MB8938:EE_
X-MS-Office365-Filtering-Correlation-Id: d9930fd3-8169-4247-a758-08ddfab276be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rr4CWuS4bJ58B5Jkt7V32zYPxy3isl9SouCyEZNIsbZP7Sa9UWg48ZyHaFmc?=
 =?us-ascii?Q?ZW0uIjFZJe0KhjfK2zO0hS+s3MeOFI1/l6M9snpTKsMpNYUfW/wZ334il3E8?=
 =?us-ascii?Q?R/6Eb7iauI8fSVR6rYACau/Hlnnp88EzBtIvEglCndKITRsUPQ3jdf48pXkT?=
 =?us-ascii?Q?pOH97U0Cu0sKr59TexUuad9zNIZLry2k3vF4mgQcFcWjbm22R7eA/ar4pcuF?=
 =?us-ascii?Q?f6gBzYpin4gBSwXtdGcL1pX/AEbvBfYy45xTbr/9P78NW9391v4y7ShL3sGx?=
 =?us-ascii?Q?+sAsjDbKewKi2Ejnz7QimtFHRqr4CcI2gFOnsPoUQI/HdxOmUCV860kSvRhZ?=
 =?us-ascii?Q?/u7F4VXDrBTmRXP858poNkd4QLfB1A0qe0GVbAdKnec1W8jeqrwdH8zi1iT7?=
 =?us-ascii?Q?cyGqSfNFPakNTUAWM3NXNaUt8/ZMWgxjqEu7RuM4MLA+PcuaOoax+bkcTZWI?=
 =?us-ascii?Q?vyDCwwRI8gcy4GkXh1ET4t+x7NgPbUPNK825Pqj/OkF98TtCXNFL3/ZUlHk1?=
 =?us-ascii?Q?eAscAjFtwcQ29QZEcGc63ua62f4uwaMsYVsYsEVrCBgchBpvzokkFukgF/eB?=
 =?us-ascii?Q?3MwXBntUyjYPFN7rJZRIGLKC4yMDLNV74OElciyKJpY8S65Uuxli2gRJ+eCG?=
 =?us-ascii?Q?07gPF7jy8sg1ODTrdYmbOWlIg/7SreXdDobIFVxHrGtkoZrKgaFF3F87JU0k?=
 =?us-ascii?Q?afkj130+QyxGVByWytn7vA+Z1nX+e/iRzqwdmxCPSiAleWiQBIhvCwbWHqz/?=
 =?us-ascii?Q?dqVTtHfzaTm0JEE8a3+oMeQ4fXvIU8kSA7IQGo9AVzNEg5uJoywG421KpC/2?=
 =?us-ascii?Q?J0I3UV1cT2Lp01nHcvWyOGqgL4HR6sP58tftvWGT0dbz/Y8fDNycZ5GSTRHx?=
 =?us-ascii?Q?m1p1/u5YiCFn8QD+rl8YgOXMaabD5HHOHC8fKptSJ7uXyk0hEOJgjWYZOtbq?=
 =?us-ascii?Q?X++yydo18z+LvOhK3XzPU6+mUhnNHipy6im/kl/YcVGQehnSqONM5Mf0mhwQ?=
 =?us-ascii?Q?FhX5QKJWefOc/RzM3fFd1uefmUTQySWvZbMCubVTHxd+DyYI23OEu2fFN83k?=
 =?us-ascii?Q?FZWjRViKzqdapXO8H/L78rUETbAjp3yOjRREG1nq71I7BQYmEQV5P24XHOgR?=
 =?us-ascii?Q?lNF6nY9zny3LEg99+4zrt4yaMpqLllbhCNz9nayZBjvobvFbPnAc140pJ+jN?=
 =?us-ascii?Q?gUeORMEhjF4TWyGWNPqy4MyFzTW+RKWH54nebrLcdEKHvHU9p7hEELrTqrQ/?=
 =?us-ascii?Q?/xFm17SLfW1QRnoNqz1pjE9brlYtntZYvU6WtzCjHftJmVcRBwDp51mcvt+R?=
 =?us-ascii?Q?r2Q31euQCV51+ZWeWTw3T5fgWXgDD0OLDZgDbUcq5l1dG1bannQFjeXDNCsC?=
 =?us-ascii?Q?qDDB4A7tILhOowPVyRJO68DzYvll576LvElYWmn7MituBaxmVXBJO9U6OIRN?=
 =?us-ascii?Q?UggjY2kI/MM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZxXI8S0BCAVc9ZVvVvntaugaWQehAd8dITHBcEJnY4XIXvWTW+uYkIOvcMgO?=
 =?us-ascii?Q?lH12dKUpk7WHbLBNVaXizn0S1MYNmxteYGTfFP+9gOfPedYOimFMasf3ZgQg?=
 =?us-ascii?Q?yihnLEPESRfyx1hNPP9l33Wm4zvJRDV/cmkhv+/91ytmjIzAKO8bh9n7g2Ii?=
 =?us-ascii?Q?wZu/aF6lBWQ91OiNMrowNlVj2aMQIZS2TVyaLdeWBMKxjvsVgSVNjsel3HN5?=
 =?us-ascii?Q?vQXqDe5VCLnmVL9i15djZhM6p6zWuZ75TgwlktYWCwGeg+qu0jJ5bl94VNDU?=
 =?us-ascii?Q?4mN+6KpmGZfd0fCecFU1CVYG8EsTH4wKIqF2z/jg3oAktNsCNbxEIXrdykrI?=
 =?us-ascii?Q?5xF1qJVSCaVhZFTP4Qi4cfmEswVG9AXtD8bPB8iNqzQNahRLS6jFuJ9a6BKy?=
 =?us-ascii?Q?+pFCBI3TLRp7i6SdIvCEU3Gvfao5TO2Y0PBnnZyxhsWC16Lu/NDpPcslCqVX?=
 =?us-ascii?Q?qC8ZUqEHOQ+v4NYFA0+Bolm2+7wRohkl7BUIpn536QU9SZaUzcDunqzJDDdT?=
 =?us-ascii?Q?t+opWasXjKkrgsOsimaskVWePwUxaln5DlvXeD0I5+AjfWR3J1DGBq2hYzSX?=
 =?us-ascii?Q?Wrx3oIvjv+W/G0/dRCzDnIxj7ywTVuAb9v+0FzsjPcxcHeevDcOTRje11ced?=
 =?us-ascii?Q?LXhpxgMmqbApAj3AJThoUEkysQvM06ljY/+iH4/H9kjPbwNg1SJ5Cxfe8C5L?=
 =?us-ascii?Q?W6YVCP7mlQ9xqIHZXHFJFzPBhzhmg/kg04hALXUfDo5XokzfLnn9cH2m77If?=
 =?us-ascii?Q?CGWjUgvO/wi1rJ8huiAmqnbEgfh6PIaNWYVjPBcQTN3x8NGUAdgW68E0juNa?=
 =?us-ascii?Q?uOwpFqUWq4rZB/tsVgrLi2lZuWKKBN7rYebzx8qbKGs3QwPlN8AWPxq3xfyK?=
 =?us-ascii?Q?dPnjJcVB3BJMVEPLulbXdfM8BUvGSra3FJRtEsNmsktLxtgwXuCuI8uOCMSx?=
 =?us-ascii?Q?CBccdg5Y02ruyZUVTRJH+3svgnB8WpZqwrcUXbcqNbwNVoNTvlwNVZuaXMZw?=
 =?us-ascii?Q?ZUr+YQ9hjX8Lkntztdaa/XTOVlbglg9hMGS25Xg1W7Cx/Te0xpjyPgAV26aV?=
 =?us-ascii?Q?IMXFTPHvFUJsWgdghFMk31jlXZT31iJ84FKhHzANh/gxDS/6gLJvJt1VFmq/?=
 =?us-ascii?Q?+AfoEl9Rp5x3u9MKDqQdug3R+6QXcE1H2kGjjgRvROlADs/LlUdnrMfV+wPA?=
 =?us-ascii?Q?07UPmATx8fMaAAIzZgnVzBZNChAo1ExS3gJqEVqtEJBCDnWo68tTlagEjgQX?=
 =?us-ascii?Q?wfxFhDBGQm3tZPow4aA7PvuebscWGbnVsNBSG9wgcHUaPyosmpCfqDivwObJ?=
 =?us-ascii?Q?WYFacDdknTCCivAYpgvCqfMchq/qztZLbOTHmvwKIUL6ANWaAK/xnSuxQIkH?=
 =?us-ascii?Q?Tmu+Bwgg+jFgNQA29Y1HasmUWfR0mmrkttluDLDXiZ/tg9+qevM5EvBH+igH?=
 =?us-ascii?Q?jivnHDkp2qCmkGIV+SJ3cyZe7dCJbvbGenPqVW5xw15lqfjuNcSCojF2bbcQ?=
 =?us-ascii?Q?od3JqW3Yg+TlqhC45k+dxEJcL94IJjUR1wjhYvVGK+zdkGeD0YKWdOV5Sxes?=
 =?us-ascii?Q?TSkhtr6dGWiiSgAhKE9TeMY1awwDo28v/z3SjrU8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9930fd3-8169-4247-a758-08ddfab276be
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:04:16.1476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hxtONvGpKFxbmoT9uN/4PUAM8svOXGdFvLkVm46AsLF8a0g8WVJSR5KPxIyYR4I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8938
X-Stat-Signature: g9y13xyqjaepmcgtecw5yha5sueuwu9u
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F1F6180029
X-Rspamd-Server: rspam04
X-HE-Tag: 1758639863-347686
X-HE-Meta: U2FsdGVkX1/+5QjDlgFDay+rDK1DhBDxQc2/umQJYl7xrrTBOQ0LJG8U3aAOSvPVpw1ZMU8HjT9LM1qgbx3VjfEKH+GDw4qob6iqhA2JlE7fBzvVgv7dPo/jkHFBazE4vB+ZMTonPiQhF86O1xI00Bm97YcewaUUopq7DkDmHUOVy9WrHhpS7R7n2Men6+CpC5k/gesanuTAmGYkgZsIvtg/YS9hDMkzGfTEBIfNjW+3diMNIv9NEnIB4/aMJgcrtTxwSc5gAZ4dxK27zW0jxpEV9go2Ly4dQ5NCRcG73ZGSUSeKphaJXdznemZgOyMFYTxlBkccMa9JmsIecTdwEgvDXzaZ5ldTblVUMMZ6LP1Xz5M+5onXQO0h9/4ch6ok4EvUEXqzJXJVy0QqwYL4WsEuYbvSgpTEUEw7mhWn5KkgxeGP+45XXgAifvTAFXo/QKj+8HH3QyVnH8kjxBYvWALbj3UnNHURGYOcuSs/12mLJz/gsKTKXXRaqHCO/cCwfaHfv76Q35+4vCbw+WeJ0KKnCo7Ix0NWnG4DlF/sN8gprKq1s7ee9LYkM9zFc0gDkSrEv8XW3l92vWGT38recQL0aKI1tUxTQkQCNSxXXXB8tdzGUfpXtMYijq+EAoeSRCaLh7MnP3aX0kkFlZhEBZIzk+CFzsI/WFnn8Kkf2DtQwHU3zxmI2SMAU3CpBBtMV1jHNfoCO3u39H62ybTS1XkG9vC8PNh6b1QQEngSX6Kw2L34JWCoubOh3httGMDBBMKn/1LR/5BadYallj5RTZPtTOtTTsjhqvAEYrA44ENGuu96S4vZ8/XLDQC6nlp0PomLQZP8Ikefnx4oufXQdhDEhLykV/Amvld/8sYOaVDxkFZ3qpbuqxyavnSkMmnLB/eo4oGvao90IIeoADBHEdFlMLj0JKp4ejZzayzgkID9LZxV2cT9mqXiKTdpIqLQC9tDa6Cxyrpk4CsJziT
 zf5BCcFX
 gr0onhzGPGsuHaRYJRB0On/tLrfb8YjA4UJ2LPRIRka/HcsWPTa/s+L/NyZyWM5vDvDwhuSvR2NYoj7EzauXgNIlv1o7X1L6E/wcw+neNl9kdlgUNpFIjFZ1EnK6zYaDwPO3Hh5CF8QR89XvzfyOs6ViMqlOhpM3Xe2iGqfKYU+9mMykmr/lQ4G8Mt+bLpqTksGvLb/azx0GBy7xXMs+mg6KUxnEOAVe0+o7pPgXqJw3zfqTTGghkfjEJbf4FKBys9JAkfq36odtYNcJMjtdw8KvkkjoDbtiu8wJQ0v/hLHINuCxBjfG4Upk/7L2GQT50EnVuaYezZ/1Nx7XqnqyqcumxxRFh8SLK8wN3twpzAoOwsIpJT5vmW0P66U95biAtotSDxfR+uNHcuDt4P8oHQtgoQkCFKbiOdmZyegG8X/Ydt10bsJEhdy+gDnLtiArUB4sM3EXWlQkG7mzagc/mTesJZJR1YwbLvAkO1opSw1yQ150WiKOAYgBocg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> But then later in patch 8/ and again in 10/ why exactly do we cache
> the provider on the vfio_pci_core_device rather than ask for it on
> demand from the p2pdma?

It makes the most sense if the P2P is activated once during probe(),
it is just a cheap memory allocation, so no reason not to.

If you try to do it on-demand then it will require more locking.

> It also seems like the coordination of a valid provider is ad-hoc
> between p2pdma and vfio-pci.  For example, this only fills providers
> for MMIO BARs and vfio-pci validates that dmabuf operations are for
> MMIO BARs, but it would be more consistent if vfio-pci relied on p2pdma
> to give it a valid provider for a given BAR.  Thanks,

Yeah, validate_dmabuf_input() should check
priv->vdev->provider[priv->bar] for NULL and I think we should
directly store the non-NUL: provider in the dmabuf priv struct instead
of the bar index and replace these:

+       provider = priv->vdev->provider[priv->bar];
+       provider = priv->vdev->provider[priv->bar];

Jason


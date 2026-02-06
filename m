Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DDDEE6B48
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8D06B0089; Fri,  6 Feb 2026 13:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96D76B0092; Fri,  6 Feb 2026 13:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EA56B0093; Fri,  6 Feb 2026 13:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C8E6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:29:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D5DEB7E92
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:29:21 +0000 (UTC)
X-FDA: 84414869322.06.85A36BB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011015.outbound.protection.outlook.com [52.101.52.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65EDA40007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:29:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="JOq+/Ubh";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770402558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvTv2Bm2FDS+41XGhOP8NbS21LEEkD6ODcAy+FQE600=;
	b=8kBcy4ZRbVm+KN37J0+8LNBbs5woXGg0HdJitmm+RBXcKSNu2KIAGjPFA355+B05H8XwUk
	8wbDFa1dY01zZ8t7GL5BHj4dazpLEx6Rl9Ufi/166uPKlcBQTHWSHvctsAt/APeiSOkdEN
	5GJ6AU/0geHsv+fxH04apI9KwSMTrzs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770402558; a=rsa-sha256;
	cv=pass;
	b=0ZZ1nz2EIztQm95fipKU9UVcTn8to0k2v3SNo2w+okV1FXVT+McDErVy5l+/NfxIhSM20y
	rb+vGgTQvUcoY53zSrYGdQ4ySwBFjsYqAgBsONcU1V4HXHpFn1qEbNOKMoJeX6s8sXq4fI
	GMfk85jz0AOcW0sa1f2M4r9BTPoiQoc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="JOq+/Ubh";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9tW1OJE43P9yfkGNNk9ChLmkt3rF91/VBYiHDFX5c4gTl6UDwc/Aj8MLmcHvAFl9MGrzeBiugEjemURQ647+6RP4/BLdT0oYpqQ4dXSiHx5JS+e7/f1T9TzdOhNNRRq2b6pnRF/bzB5TrAw19itSU5QSd527QevmeCs0v/qxRD5DTpSMYe3j8/2Mxu75rqkf3w9erTErJKqwTAHQyBZxis7QIqvxpTORcF9zZ21Bu6MFwLhn/9Jq7TOzDMSpmjTEizit5NRB3oBXptnWXlSN9ITwZ+ux23pkMFSSUGXmwfH9zZ7GkbfbXyYg4CBHQ/24zU6czjsNPH3MvxsFqB9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvTv2Bm2FDS+41XGhOP8NbS21LEEkD6ODcAy+FQE600=;
 b=faloHrgWBY3P2wmF/RIHzEGslBMOq+L3rYTOKBzmFmOWk228QxwjChbFgRTzWAtmSFMCvxrXG80eYvLlEPVbSzZCkS7pZOeFZafnQMFRgW2ayWIpga4B1JN081FGqcDQvsKXavZllfTBJmRnhqDdR1nPzwXO6tNESB4/i6CYo5NKVuowUuht0e8yDvjUkajGaTj3yZ51+YcGxpXZAUTIUIivdX3ad9BSXNq4iwMtCIg5nFS0DUoko3b16zuC3tGULFksNjZxOe5kuFxnmkaJjbuDCBHYwNKeuazYOc3rhhCQWAVq9V3ZzizbSvOt/XWAPLgnHsDwHz8TMZxslm/fNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvTv2Bm2FDS+41XGhOP8NbS21LEEkD6ODcAy+FQE600=;
 b=JOq+/Ubh/8PA4H9oo4yVJG2Z3G40DfN+ddpjHywRjOWx/Usr1V1cDVUudiO4ZDr2RsgcFmTQNJhbVGkDeDYXViPHaKcHvndXxaFx7GHAC5hx55S0E7pjB/LBRRSpGwwHiQjSVV+gjM0h2cN/MOETu7WNglKvZN9VtX+h4Iyf5TvOfSXcF06cQhJy+h+XQdVVRyhKdh2xZbR1TrKZJXaefSSKcI7YNuM1WgWfp7Ib2iB6grL4wyg/rjTi0jqxrTyK71111QpiL/cNZGU3ms36a2eBegL8o9f8Vm9QQynMhgdafXaY6vBOPkgn/I/aG9HdwId60S5iG2k0/EoQw0TFFQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.15; Fri, 6 Feb 2026 18:29:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 18:29:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, ryncsn@gmail.com,
 stable@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 surenb@google.com, Matthew Wilcox <willy@infradead.org>, mhocko@suse.com,
 hannes@cmpxchg.org, jackmanb@google.com, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
Date: Fri, 06 Feb 2026 13:29:07 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com>
In-Reply-To: <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
 <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:a03:331::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: d845e727-fefa-4e8a-4219-08de65ad9faf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YldnRnVXaEU1bDZMRFdpdW54eDQyS29KZU9wamZ5WStsZ05kVjVMUkt2cHBJ?=
 =?utf-8?B?ekpUV3U5SEkzSFFBV0ZvZ2xwS29OcHVveUlXRGcyOUxHS3VSMHRBVXJ0dWFM?=
 =?utf-8?B?T09ZN1E2RTMwY0NOcHMzS2VBaWZpTWxWdDU1MTM4Tkt4ZktvN09ieHNmVkVp?=
 =?utf-8?B?Wm1YOFY5TnVpV0EyQnVGVkVLc0xlQ2NKMHh2bDZPd3FsNW1VdGR1Ujg0RUQx?=
 =?utf-8?B?ZUpibkRTTnJJaHRXNGNXZlJQYjRWNlNmVHBsYk1vNWJtUHAxb2twSVZmb0w1?=
 =?utf-8?B?YmprUU5rQkxPZnBSNzUxamw2YnpoaGk2TFQxOEIwRU9TR3dSNkNndmtraGZj?=
 =?utf-8?B?V2Q2QlgxUU8rTDViUFdtNGZPcVNRYXFscTU1d2JXZnltbVNDUW5jbE16bWpX?=
 =?utf-8?B?SWZIaE1DSTRzRUJTQnVjc1JMc2VOMVpEQXBRZHRqalZXdGFKbzFhZjJseHk4?=
 =?utf-8?B?cUVJMlZ6NlgvdzRZcTA0Z0ZQdVdQaXpYY0psMC84OWdDRmZkNURxbTVjZGx5?=
 =?utf-8?B?b2I2MEFrY281QnhYTTRaSlArNjh2YTVsek1zbnlIUVpOeHhqR3daSkw2QWtS?=
 =?utf-8?B?cWxtaElNVW9CQlIyeElvckdsTXppNEx1dHBnL3RkbDVZeTBQVTIzWEhrNjVk?=
 =?utf-8?B?cEs3bVVEKzBtYW1zR2k3UFpiNEZzUzgxVzJKV3FZd3RjdTc5UWpkaTZKaDNE?=
 =?utf-8?B?dVh5RzV6RkIzRS82T0pjU09mWUdLQll3T1FId3VsWWtoN1diMk0vZFJwYU80?=
 =?utf-8?B?QVRyTmhzZFE5OFFkaW5SMGlpSlFWMGFpK1BCOG9aQ0E1VHJ3dGZ2M0dDSnpB?=
 =?utf-8?B?Wk1BdnNybktyd3FHN2RES1NuTVdOemg2NkdzS09zUmw4Qjk4R3lYakZqUExK?=
 =?utf-8?B?Q2cvdG10aVQ4UUJPMHJ3UiszV2VqNk9zdWJMdGFlU1dBcE9JcTR2dFAzenVG?=
 =?utf-8?B?VEtZaXhQMnBadW5yUHhyekhCV2JWY0ZyZ0VsbWlDeHRrcVZ6ZlVVSDZDdzNy?=
 =?utf-8?B?NXZmVElXby9QQUsrdTB1L1ArdWdhTC9UNm5GR1poeENkOGxjWFF1UTB2bVdI?=
 =?utf-8?B?bndQY2JlTVZGeXVCZVpZYkNhZlhuYldtWTUrbEpHNTBQRERjSlFOWnNZNVRx?=
 =?utf-8?B?Qy9qeW1DUmhLU09yNjFYZ1dOdWVKeGY1eVlNMFVXc01pTk5xOTJ1Y1NjSkUw?=
 =?utf-8?B?SlVTUGJ2SUhUOGNpRkxxcWhuaXB4WG5xZGs3bFJpYjhQVXdyKzlpTGVmSU5m?=
 =?utf-8?B?YWxDWEh3ZUkzQWNtY1dCVDcxckttSlMyNkRJKzdQeVJ6Uys1TTB2MzIyL1Bz?=
 =?utf-8?B?UGRDeHNiWXVrRFFUM2F2M3ZzbnFubXU1ek9iOUtmMGd1SUVwTmwydWhjcXZO?=
 =?utf-8?B?Z1J0S29sREtPT0VjVXpxSGc3eDk5TDZWK0haUXJ2YU40VlJUdXdaY0pjTjA3?=
 =?utf-8?B?Tm1YSFRQUUJLVkVIbWRKZWdaaWNLNlJPbmhueUdUejNvbFNWVDFKSUJVVWc1?=
 =?utf-8?B?a2RQdHo2V3JlNzN6bStHZm1SeWMramZyeXFXSDh1ZG54L3QrR1E4VkRYby9W?=
 =?utf-8?B?VnJTbUZFNHA0SnAzWFBueWJBQ0I2VnlEZ0lwVngrTWZKOU5TVGFvVGgvT2Zl?=
 =?utf-8?B?QTgvL2JUdGE5VHJZaUU3TWRORElQUENhcFkwVHV1ekV3Nkl6Z0czaldONVlu?=
 =?utf-8?B?ZnZlUVVOcG1CY2VwV2MrUXRrN09wVWNFbzFvL1lUakJaQWFSR25saER2N1FY?=
 =?utf-8?B?YllxMWxtRlNabkh0WUMzaGxMdWc0SUkwZDRnSmE3ek1tRVkwOWEwaEVqUWZk?=
 =?utf-8?B?ZUFuUlpsRmRNdmhBNmlMd0d6c1hmVVlCNzVMQm9qY2pTWmFlL3IxckJ1bzl6?=
 =?utf-8?B?VUpDV2lySCsrTGlDSTY3cGFnWFgyc21PSlFlRzZEVnYxS2pHUWRkb2dpWHl2?=
 =?utf-8?B?YzkwV0V4ZnhhTm1TS0RNQWJCQVFhZklMejk3VVpnMzFVODMyZkhNN3FuYUNt?=
 =?utf-8?B?UzNuSlBTVlJLMFYxeDF2QzZRSGRmc2ZmSk4xYkhYczJWQkQxMlRZN0NFejM5?=
 =?utf-8?B?Z3pHWDFSVWVIbW1PN1lRQTl5UGhaUS9Va2FaQkdQL0hBQzF5MFRjSER1TlNZ?=
 =?utf-8?Q?KzcdX9T/xs0oq+JZ5enGwONmF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjJlaTh0RnNEeVU1Nmt4a1F0SEQvK3crZHZ1T3dyR0xnbkV5VklHZUs3QzQ1?=
 =?utf-8?B?YTgycnV1OG1WeThXUWsyanNPdkN0V2czaENsQVVVUmp6T014SmprUXNDZThO?=
 =?utf-8?B?ckJQcUEyTzJjZmZEak52YldYNXJ1eVM5R3U2bWsxL0pnR0NCTmR3SDN1LzZj?=
 =?utf-8?B?RGtYREJ4cFJqdHNEL0V5WWVzbm5panRhOVY0QTdvM0Ria3A4Vm1qblNwanZB?=
 =?utf-8?B?TWp6a01Ga2h2TkpUd05RUktoWnRkdU1ua1FPdTlDcHVKU29GUE9BSGdmb3Mr?=
 =?utf-8?B?SE1XUGczOWRnNmlXUVJoaFhxTGJIakNvSkVnc1pVS0E3dlNXTk96ejF0ZzNH?=
 =?utf-8?B?eHdHVUtwcmZyblc4eFF5UXdGNEQ3Vm5sQThOYTNqdU5rbzFPRGJmOUJ6N3Rv?=
 =?utf-8?B?VjRTQVBJbXIzdFpGTjIxcGVWdWk2QWdpbzRSZTBtRmRtSEZ0d1hGTWVHdVdn?=
 =?utf-8?B?WmYvSXR2T0IwUlowQzBUZWt0Q2NYd3JnWk1rMU1KdkZ3Ym55WXFsTVowWWVM?=
 =?utf-8?B?aXZSN2M5QmFvajVoNm5HNFJOalhuTFNKcDNaeld5VmIzSENQdUJxK3FRTTlp?=
 =?utf-8?B?WFNwcE51b2pmRkVhNUh4eHNIbGlTSDlpYmpHcXU2cnczTWxRVWhoL2hDSHdJ?=
 =?utf-8?B?S3Z2T3ZQOW9HZzFsY29qd3hMVW90dyt5T3FoeUJBa0lmdEpoaDlpRFEyY3JE?=
 =?utf-8?B?d2ZUOWNJNEUyRE5oT2k3emFNQnI5ODN6T3kveUx4T3pzRG9YeG1OaFFSa21h?=
 =?utf-8?B?MlJEL1FOKzdFS1A3am1OeFNZL29tcTNxRW8rSmhvZjJOVkZaUVZnZjZlSGJG?=
 =?utf-8?B?K0NIVGY3VEg2YitQSCthcjlOZkJIZExzRkVoLy9aVjR0bE04TDZNbTZkaXk5?=
 =?utf-8?B?QjU2QysweDQ3YVZjNjBlUTc2Mm5rQ2s0U3dDRDZLem8xK2VHeU9zWnJjc1Js?=
 =?utf-8?B?cTE0SVcyQlBMK215cGFhMlk4bkZPbWtZUmtCM0s5RmNtcmtrc2VsVTV2SE9I?=
 =?utf-8?B?ODRmMkI5OEFrU0hyUVZMZnhvck1OWU9iNEFzWXVqcERvWEN6alpLOWdxZEdY?=
 =?utf-8?B?M3kxQm1ZWHY1RUxwSFFnQ3RVWFNFU0VnUWgxY0JlOHJBWVh5ODF1d25yYURI?=
 =?utf-8?B?OTVkbHlLbWt5SHdaYlJrMFNBS1R0TnAvODdyRXVEK1lRTVoyY1I3a0sxVUcy?=
 =?utf-8?B?V3VNbU1iOWtCRHltZUg2cWdvQkdRR094TE5PS2w2eG0xYnNPMExWSWx3WHRJ?=
 =?utf-8?B?VldveHIyV1E2NzZKaDFjUHVwd1g3elVnQ0EwakNqclBXQXRGNmt2Q0NtYnVs?=
 =?utf-8?B?M0VyZFprWkpOcFRlekRDYmtCbkFUUHZIODRPcU1NajhhcDhUaCtia2k3TlE2?=
 =?utf-8?B?MEp3eS9UdGlJUHVGaUdzMk1qUUExRlN4OWVXQnBYV3AxTE0vR215YlRodVQz?=
 =?utf-8?B?OVc1NDk3Z09MaDlFME9vYkJmZkVkR0dLR0VXem1EWVpPSU5COG11U1dkOHRj?=
 =?utf-8?B?RzNYKzEzbHVjbnBHc0p2UDB5elFNWlYxVjU3RG02SVJ1QlllY3E1SGxJV0tv?=
 =?utf-8?B?cnV6VjIwRFNJMUZaUU9DWXFJY25ySTNOWGxERXRPWVd4L09jUmNOSFBqRmZW?=
 =?utf-8?B?MzNCalRVY3hhS1lsR3IwZzd5MFROZ2hPSjZwWk9pSTQ1aDh1T3JlYmtoL2Vr?=
 =?utf-8?B?ZmR1TlBlWFZrbnorby9XSkJwdWJrZ3JDakMrQUxrVnNPRUxMODJmMzdTV0hh?=
 =?utf-8?B?OGpITmZqMk5peHlwMXJzOVFnRnUwTm8ydnhiMjBpWHorc2tTTU9aSnFmSDNY?=
 =?utf-8?B?Ui9KY2c5am83UHZITXhFSnAzVGVBRzU1NWZ2N09Ga0ZsQ2w3RU10Zmw0UVNB?=
 =?utf-8?B?d3A3NkRLcWRWS2NlTmk0UGdUcmdjQVRZaHJjMlRiWHI0YnhrVHJ3YmIwMHBo?=
 =?utf-8?B?RUYxQ3VTV3E5MEp0V1dvRG5FZkl5ejZkaXJ4M1VmWkk3bnRsNlZvRUlBUWZx?=
 =?utf-8?B?Wk1DY0J1ckdJLy9VNitGWFJMMG96MTJMTlU2YUcwaDk4T1Q2RXdrUmdIcGR1?=
 =?utf-8?B?eWcyb21VeUdFTVFsUFc4R0hXeHNieWd6MSt6K1YvU2dNWDJZT1M2aStoazcw?=
 =?utf-8?B?eXVZWGFiZzhwczV6UUpLbjhucUtRTWpXOUhxNERGU0czdm5aRTJxaFZEVGMx?=
 =?utf-8?B?ajFOTWk1VDFKTzB3NmNDY0tERzlONElFcmxuQjN1MmtiVnRnQU5TUWtjV3Q0?=
 =?utf-8?B?azd6bnlaanU3dVFLQlBmMHJma25TTEJXYTNDZjFocHR1blJXZjgwbHJ6UnRt?=
 =?utf-8?Q?bWxPVG3Bn+rh05z5lw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d845e727-fefa-4e8a-4219-08de65ad9faf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 18:29:11.7464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcLBkD8C2XvrN/tz7rgDiuvTrfAbhUn6FYdDn0NA8JZupSTF5hoALQhn5nZg4q4s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7742
X-Rspamd-Queue-Id: 65EDA40007
X-Stat-Signature: 3tacq6bnfimy1dacf46brqu1wtzkrd8a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770402557-200833
X-HE-Meta: U2FsdGVkX1+5Wd+l4zVKPg9hEzsH0CcnurgZR511CGQOb6T7oLII1Xax0PkOXmIGA0cWyyZuSnfg3sXp7aAp6/Gmi+EF9RmhnBRVNpB3TPfFB2oNRb03fjZZqWty1Nl/ZeCMPtxBghPyaIeYe6b8Odg6/oxWrSiUDRYGaBHMRCObS0uicxupKTKztv28SYIUTCMyGKcFrm2W+nbeXV/FsOCjOKoo42MGX1S84nj9slRF7iDK8//K0rBOE/Hxdm8gSse5B9Lni0CfdzSXn78FGfUsPiHKxPXg+92IlAWBJVXVQfa0UxR7TRaBKKXLA+aSNKxznWwxg+0eIl54YeP8Gr3TSCtGZIiLmUIJ+e7+hu6D+Zb9ZZ8Z9LMT+sdpD0vKonQZwha2UlHRQEJd3g4Z5FxV/C+GJ9WQAEsMXqxg1CHrt8iwulivsdO3/RjKEL2J/sVh/fmZjwicnpAS8Nl7Jx7Vlc1TLAsl25wJm5raRJkP5WoqwRvdzh76l0Nu/LWlS2WkhanM6SP63ORggGtdYjMKzBWX3k0+0m7abpOr9IF3QTLgyCLFTZq0EnqnJOm2I3MBOwWW/cblhVv+zOSn5hl+GWHSaIrpXu1DH9FqKW8HiPQ4d0GtqaTr/bmljHNzwAkqeA71aNZcb0PqmC3xCKF2zWODnruGZOyNUsBbHuVN4aOU1bCSuONtxStyN63mAeJDYjIiZcSYmVJibsTjZuqn7Ow4cUbNBNXvSpgdhG08jzm8wFT2JIdD9oURs0QNSnOOhn6OnxpWw1rbGO3zJkAHGl1OGdOOf8P/gnEzh+Sp5SEuPVt5bj+lzzBkzynTjkn+ei755upIwxaDOrDFdPrN5F2khgyHfwf2jgRRAxF07L+Wprvi1bMFugKo176WM/cNjvJgrpnrF9C67u6ymOELxWbYLKPdMOLHMoT0U0uY8t1dyTCmQjG7UhRKwF0ViL023oWO+t6VqZzqJFP
 FXC7EuvS
 QOMiFGBt7OtZEIpuydnOUE76DTy1wn6t9nepw0DOnh++kVOfAPfzg9+PhmINYRZe4CO5tiKUMG/ligymhNhFh0MMdoFD4FawD4dc++0LcSkFQBD+HPb9wSwzqzawu28mrE1x4FotnjsmvEKRgbavk5LObUdRN/1byXgrdx+Fr79oXEjSdZmM+j4XZVUJWVLD8/i1mXkjNwn+SfN758ZEA75h6lazkKzuekrRand6tGUODilizEEZli/xH5eBpTLAH/CUgxFc4aIXm7j850n7gX2c8LWO319B0sifrEQoTUIgW4MrcVd/bdbRutWxZpMAk5AQurHUX4ZY8VPCGKu4sXMKsz8Na1KH8TD4DZEZEZjvyx7OLcFf9nWskM1Rt8rHSMJrXXF2GmJkXO5IhQtuCRH1SAVo0Qe6qJr8m8HMXLwN4KzGImhbgku0NrWB0dlF0DcWyf0peq4XDZfTOfktwk5AoTKVRx9aG+xmcDP1y5iy+2nZYcmJA1LFBbC36Ell1hUl3lgUd1gvKpipP/Csg8TS3MC5hv99YIkHyVWUeGwexA9r23IybxKH1DSCSp+9PtxtROKVqJkOX1no=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Feb 2026, at 13:21, Mikhail Gavrilov wrote:

> Hi, Yan
>
> On Fri, Feb 6, 2026 at 11:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> Do you have a reproducer for this issue?
>
> Yes, I have a stress test that reliably reproduces the crash.
> It cycles swapon/swapoff on 8GB zram under memory pressure:
> https://gist.github.com/NTMan/4ed363793ebd36bd702a39283f06cee1

Got it.

Merging replies from Kairui from another email:
This patch is from previous discussion:
https://lore.kernel.org/linux-mm/CABXGCsO3XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ=
3PwP0mGXA@mail.gmail.com/

>
>> Last time I checked page->private usage, I find users clears ->private b=
efore free a page.
>> I wonder which one I was missing.
>
> The issue is not about freeing - it's about allocation.
> When buddy allocator merges/splits pages, it uses page->private to store =
order.
> When a high-order page is later allocated and split via split_page(),
> tail pages still have their old page->private values.
> The path is:
> 1. Page freed =E2=86=92 free_pages_prepare() does NOT clear page->private
> 2. Page goes to buddy allocator =E2=86=92 buddy uses page->private for or=
der
> 3. Page allocated as high-order =E2=86=92 post_alloc_hook() only clears h=
ead
> page's private
> 4. split_page() called =E2=86=92 tail pages keep stale page->private
>
>> Clearing ->private in split_page() looks like a hack instead of a fix.
>
> I discussed this with Kairui Song earlier in the thread. We considered:
>
> 1. Fix in post_alloc_hook() - would need to clear all pages, not just hea=
d
> 2. Fix in swapfile.c - doesn't work because stale value could
> accidentally equal SWP_CONTINUED
> 3. Fix in split_page() - ensures pages are properly initialized for
> independent use
>
> The comment in vmalloc.c says split pages should be usable
> independently ("some use page->mapping, page->lru, etc."), so
> split_page() initializing the pages seems appropriate.
>
> But I agree post_alloc_hook() might be a cleaner place. Would you
> prefer a patch there instead?
>
> --=20
> Best Regards,
> Mike Gavrilov.


Best Regards,
Yan, Zi


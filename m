Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697E5E6F08E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 12:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4066B0005; Tue, 23 Dec 2025 07:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AAE6B0089; Tue, 23 Dec 2025 07:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852EE6B008A; Tue, 23 Dec 2025 07:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7017C6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:50:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB45E13A226
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:50:50 +0000 (UTC)
X-FDA: 84250720260.08.2A64421
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022134.outbound.protection.outlook.com [52.101.101.134])
	by imf09.hostedemail.com (Postfix) with ESMTP id 053BE140011
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:50:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=hRv3wHib;
	spf=pass (imf09.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.134 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766494248; a=rsa-sha256;
	cv=pass;
	b=OjYNCgMwOpE4+qGJ15eI32ga5peH42JH1Zb4gtIORpgtVl8Tg0ix/EQ7+wFf4pIDBgFrMN
	IKPCV7eNi608YbbIu3kL6M7RIhGxFzU+13yjxshrmv06CpkbIHECDeLbhSyjVGj7bxQlql
	tplVKX7aTXgSF1l+aaDiJOQt5yTs02Y=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=hRv3wHib;
	spf=pass (imf09.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.134 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766494248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zh4pHA2EmqMJP7teJTkE/JhAr7VaRvfx58Lckj3ezLE=;
	b=PIBy5T4vAtGOzZ/yBEwx9znfJtQ5IU+aS1cSLg5qUs2TQnHXZEpGGSLDyUB0nbHkzZs1vJ
	Oo0fvD/R8IVZOfANkz7JCpvOD1jJCCq4ebCA/cCQZgkFAo2GYdVFLomA6rIo2USFB0Po/m
	1kdPVmbqjaQ4bWxI30WbqwJeUjQtetU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=te1LQ5pOhezQehHjUK5hFwlcwpK4rO2b5Na7cl7OsZYEgitpTBBISPvScIAayumXXstt+7tj9U/ACQYGa3AW+6iXB/Yu2zLdIgIWkOCR4qRJAxoMhzrRiCtvHoB8vYT2XwlzGUm5unnrou1LOCyX5CvxKuME9QltuOmheNoQVz6K+nQeUh564xFzVPJPsjjdZ8DPkS8ARvN2GMLmBM4QpCglf/F7388aPMjsnnfg1uU1LQsYEvvympcChrqgtYlEyLzf2cePL+tNAY5ca7ruX0J2DL1pCcs3F/mKljxnVt4dbaLe9Jhybdgb38M6qZ16t+9GCcIMmzWgYAyE53F5Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zh4pHA2EmqMJP7teJTkE/JhAr7VaRvfx58Lckj3ezLE=;
 b=GbK1t+6jJdWcPXzXp0hxRM2fFZ/CkVFi8iSrfe25Ey/eI0VS9x0J7l0CzxeRGeaj4LOFNZh9npEkSL9FiW7g1oB/DqeBTEI3LMdFCaTrUkHBRlNuG7MiLisHIyE9vvlATjcPU+9QuFjeeNQGFQEEkhaMVEPa+Kt4jsu6QQmdNnIAl+Ob0Safxd89u7wT2MlIENFptCoGQb8hBMp5jh5X/ZA0/rBxeHwrubpgBwpRaivzG5/zGM9TCCk3hLpkBHvz2hOXJU+GQ80CdKfVwOvKuRTamaMo2N2Dk2YlwPVu7IGiQmhfs6jkWDZ3qxV/R6rS0T68l0iZFoWtRiNzpznxWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zh4pHA2EmqMJP7teJTkE/JhAr7VaRvfx58Lckj3ezLE=;
 b=hRv3wHibwTGSqEa52QlDCouKmjYQ60yQD3x1UHNtyqbkLNjOOYza6XnnAHgwEpcufNe375oURjBkKAGtCRsYLj3YhQX4XF76kV3XW9+N6nn0KR51n5ti5PBCkcXOrYIqxXR314TaKWxzD+4R/WvTNiE2R1GGzBe+2g5EKQ+q4Vw=
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:27c::13)
 by LO0P265MB6549.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 12:50:42 +0000
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::a825:7b26:a82f:d041]) by CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::a825:7b26:a82f:d041%6]) with mapi id 15.20.9456.008; Tue, 23 Dec 2025
 12:50:42 +0000
Date: Tue, 23 Dec 2025 12:50:41 +0000
From: Gary Guo <gary@garyguo.net>
To: Dirk Behme <dirk.behme@gmail.com>
Cc: Kari Argillander <kari.argillander@gmail.com>, Alice Ryhl
 <aliceryhl@google.com>, Dirk Behme <dirk.behme@de.bosch.com>, Alexandre
 Courbot <acourbot@nvidia.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: Simplify overflow check using
 checked_add()
Message-ID: <20251223125041.69f741d2.gary@garyguo.net>
In-Reply-To: <46e188a4-4b74-4206-ba18-f107f45bb98d@gmail.com>
References: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
	<20251223115726.621bfa38.gary@garyguo.net>
	<46e188a4-4b74-4206-ba18-f107f45bb98d@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0178.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::9) To CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:27c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CW1P265MB8877:EE_|LO0P265MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: c01b2e6e-3e5d-4cba-f740-08de4221e211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sabSD1wIDWaNseE9tfQDxmMg7nF5SGm+iYIGEpL0QI/osVRGb9HKRdmsZ7TG?=
 =?us-ascii?Q?5cFbUnyaGAaqFbXBMx0yvP8Pm2Ud2KZatpWyxd7tB1SLO+ZOhkpydW1p9eyj?=
 =?us-ascii?Q?AnGqqyHKQaRsqE2YSJTxQGYZYQ28Jix3Gr95XRJ1URjPHt66P4LoBlCdCMK+?=
 =?us-ascii?Q?QLsOCzqxm+HnXlfY4+wJh40WLqKECgzWpBpGoGLGbQQW4kzN3cZNFTSKUJaW?=
 =?us-ascii?Q?vXjD17PXkhJ4aDGL+67Set6shM4skxD3hq8+fm4+2kz2qNdHp1CbTp1b8kiF?=
 =?us-ascii?Q?/Pmfv0UKsOeiOhks1ycFlkQytCl0++kxB7JpaBX5P2wMx2GAteedXoDp7BYi?=
 =?us-ascii?Q?G4sACyVVb5Lu4CUIRrrB35721CTC8+Z+HJl2JskQJKOV4UsIqFXqq7YHujJM?=
 =?us-ascii?Q?xQvmP112dDagqko4nvHEuZKTAc+h/L86c//zSbxTPERKMf1S2YIrZsSE338D?=
 =?us-ascii?Q?+C0rmO0WXExomIxp6HfRm+JqMwRKONApuxFaSlCBoRNLXvPLXvfWvyRiTnh1?=
 =?us-ascii?Q?bPdfYsujPtJ7ViuGFFIr2iQH/sfjSHDAEtRlpIZwiI1j+TyJ+WlMGenGG0I7?=
 =?us-ascii?Q?ezFopybHnEziUhTu5MLiFl2jGbvdRoI44+qvjkFri++g/AvX31y/+0z+dHdQ?=
 =?us-ascii?Q?WHfykklLBDAVhsTRD2JO62Oc4EZJtuVPNVX5OnxhAW6VvGNHjZTeiK+6nMdP?=
 =?us-ascii?Q?B3+P1IoGRv+CXq0dl89IrJKCNkas5bObeO7K9XcpovEvkbrMMukllcXijaIy?=
 =?us-ascii?Q?7QmE9+6fmlN6MSpH1YnDTVDAmPYUnM+I8qBFibGUngPmsN/0QN3WUezltm/d?=
 =?us-ascii?Q?VP7av5BnYS6OsCGnaFjJR0LxvAk6gL6xjTDrDVrFc8MR1vr4wzqN2YxZL1w2?=
 =?us-ascii?Q?LOnnoqLH61XxcZW77rLcrGIn2yD52kkfVCLIib5AmswJ5lgQHholI0y0xw6S?=
 =?us-ascii?Q?1n6+7NsATFIToAX9n9+DIS0JVpqDcmYpTbGVo307W7t+3fYADaChX3AWQaWv?=
 =?us-ascii?Q?2JJ7HlbtD9UfhQfN4Zb/W2R5toNC/GXMRK3jK69mKPoTsub9y2dcw+5Q+kKf?=
 =?us-ascii?Q?kG4qZsULmzahZhcnHOdFchbJ5/2iu1h2mpQBHWkHEOD6kGjo+FDi3wBiHGT8?=
 =?us-ascii?Q?OH/uq1mWasMJ5Wqg2Dl1/ijJZwWNPpvwM+LNiK75oVHX0xYhcTZ5wE+N48kv?=
 =?us-ascii?Q?hpwDTOZVtAEDTbzLOrO8RxmwalFa/KbTNGhgM7vle2M0mxzM+bBl5vkG12XD?=
 =?us-ascii?Q?AH9pb6lpvqlWPi0CN7FYsRYrRkOi2WjxEMdzF7Pc3i7h7Gtqp0ZvgHhHHx7f?=
 =?us-ascii?Q?NfxpXgEZtjn5GdKjzPpvfirjWCSF/oHB5ZxGKQqIfEpbnE6duCDrjbZu/tlI?=
 =?us-ascii?Q?t7vMxR0Ed960Z3hdm63e7hmav/+YaCkV16A2QGRRHPAY2lSLwlFT+5kGnTNI?=
 =?us-ascii?Q?YKqhyrIdbbi3iGnozRRvZSPtzuuwdSnJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8PU8K/PI6NEKGgWq4HD+x9OLQWT/L1s+77W2adlAwc+pvJrphSpLF/z3yX53?=
 =?us-ascii?Q?twE/ol+7xjD5DMLDPZ8ZjH8h2a3Sh4d/Lo1wfceyqibRd3/Akt+LdycIo2MD?=
 =?us-ascii?Q?L6qHsKMGW+0JpglBEfS8n+iBUPu+mqRTbuBi/4PpWaHkvUpXhueMjChrrgxu?=
 =?us-ascii?Q?ZnGzY3WndAHT+Fztqd7OeWhPVFBi3p7Pek21bqAnYe8H10cqW2NTJplg6y4/?=
 =?us-ascii?Q?bVSzY4g8Wbos92zK5I963hw4byvN3BxKqf9Ngb9MAodTsnpmHhY+yh//2keQ?=
 =?us-ascii?Q?d6uD3RGTQ/0lsSsRNGVzYmV1Xqqg2UeYK3I43h3QLiRRsSVCZ6jjrILsSK9O?=
 =?us-ascii?Q?YkjY0hSUg162OGyciu64fRH+i26Bwx3qPs/7qq2VCaRHRy/+pV9XWFWB0EX7?=
 =?us-ascii?Q?CjkrZuRng48IQQ/S2lGPAwFVe5Ld0tnrrN+q5WBnvmkz2WDjpW/lOEl94bwA?=
 =?us-ascii?Q?z/3R+Ma1Aujml5FH4bprvyGN78N53hh1Kil8uu+bOpCx7x3KV6iw2qeIXv1g?=
 =?us-ascii?Q?g2hM3D3KdoTTnD9hkptlGI9OEIql8atgnq62YS6h1E2J+tNcfEOQ/YaTOoyg?=
 =?us-ascii?Q?RmmngP9bWnawBwi4PIiYeWvHz2Dp5gRKGqSnZFRBADehfhZmWPb1QPRbCQcI?=
 =?us-ascii?Q?LU5rwVstYqQ5ARV0f8fGF61n8X5t1jj6kfs1vroJR6lo2JMNpB8OC2Ot2gar?=
 =?us-ascii?Q?G53hxFsxi28rgEON+ojTisIyGnb1rwyO5I6dL/KfSwJSZFLTOwrx1B+2Rr+7?=
 =?us-ascii?Q?2aYiS14BdxyYuf7HSfbhh0ICFms/wtKBaEFEuQcBo6EZ6jCL8V4cvmw/nXbe?=
 =?us-ascii?Q?sRapRW4Z80uPRwyAopmhWMO0o4oD1K/llhGrQ+y81Q3CQhh1fiX3t1f+T64W?=
 =?us-ascii?Q?j9ZyqNiiVQMlTybEFinelrQQ9y+IMvQSP/ibu33m4gax2EIO5h0RmgcvDrh0?=
 =?us-ascii?Q?aXNoEfoyLZcx0fNCO824ZISQkYSzM0VKvkxq7Hi3nuejosVIqdIiWEcuLV62?=
 =?us-ascii?Q?u19N0BsIXEFywU/wRzGWckkauXM+z0nNavCdjPqhHfRLs5CcKZ97k0m4ZZfg?=
 =?us-ascii?Q?vDzzUA1LvEyV5cj5j8QI20qfK4bckeflTi5clGOLb5YfYOnBy57CUF2oTO+U?=
 =?us-ascii?Q?jgsbP/Fs7sEMx/9reFGO8RH3vvrYycHCI6jqzFcUUDjcvwkiz/DG+VAaa/pA?=
 =?us-ascii?Q?mXylErMYzcoZ3flc6rdztJ1lXHB8XAkz9BEn8gvPWvA9HUML2zoG9KZhFQR7?=
 =?us-ascii?Q?e1J68KeVP/P7Zzy9s5OVgvCJ41eNnQ7LEy6SuuKMl5wHhzSqqpfw7cMejEcY?=
 =?us-ascii?Q?1rzZJVGCCjRy8UYq2M4RtVOxuGKygW4NNwKSPOKwQlq61NKi4QmJvuqs/I+n?=
 =?us-ascii?Q?3jl48eHtn7tFZGM/uBMMUw7CzjV7ze91k3HW70jPTxyjeg9zD7Heb2PRBKK7?=
 =?us-ascii?Q?27Qf85QoH+nvNlQhEnElwoaTFiAFmUayle6GVmTnnwZjIbU2gBDaOnpOwTPl?=
 =?us-ascii?Q?MA3ZuG7udkL3eHC3UODVVrUN8LjpZb3WdXxxG8PQT/hOfaHJSWJdPa9Pioly?=
 =?us-ascii?Q?ADU7ooldDf+7vt8mCYLloqp9hJ9TtpGk2y4sYm+JwoGY1Filg3QtCtcSIzS/?=
 =?us-ascii?Q?2Vp+jgAzHfctriWBchgKjVSeoN/mu0LJiC6mP4gHJ6mtzbQuUjPWGtEORyW9?=
 =?us-ascii?Q?P58CRWJYNGjlIg32PoDV4hEtRKrs2BT+cIdkKy5Cj2qYAs4zBXpvgGn9hoF5?=
 =?us-ascii?Q?ueA+KMQxlg=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: c01b2e6e-3e5d-4cba-f740-08de4221e211
X-MS-Exchange-CrossTenant-AuthSource: CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 12:50:42.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+8JriwXa234TdzupU1/tL5anu0RMvkFYHezyINwpVh0JYn1UwnTDKsPmqehakAXES0nRg9I5xo0OFUjwaLsSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB6549
X-Rspam-User: 
X-Rspamd-Queue-Id: 053BE140011
X-Rspamd-Server: rspam04
X-Stat-Signature: 9q1dw91aci3ri5thhc6kxhco7m4xcq1q
X-HE-Tag: 1766494247-395560
X-HE-Meta: U2FsdGVkX18St72/sRU59uiZYv6tXINUPwifBbqHc4l+Bd7O3FHIPWxYTwLNbEoYJpydGEVapTa8oK5woOcHEYmgeD15EVQPCEcFUQ5Tjy9kNiCCfynrvikvu2w0GYNO+6HJYSSIH9nX4l1SIfZ8qeIdXBYweZx9mrSuDaiodN0xgfcqEVSekrs2vcN9ysjtUGlk+MArzhy8Bgubxe/0287m0MV+jRzcj/JF3eV/tQuKIXRfyZaLh+FRCwmUZmRSEGGvsCwYsmr8tAocPul/mCxl/WwnDY+frrm/pA26O5rSGkymMGkhpHJY0IPNm2o7/MhmpfZnDiReelylJGMbSA66amV6qeLLQaZbA75DhIucWeQSDuy1YgbaEB+lGZS085ZcBO87gVoxtlTymR7/LUNLE03NbOuMAvBJ1ka+A7bm7nOq3U4MHXyorXhRk274n6HoW/OdVj3wBusMOeMpCO3kSwh36bfwyJ/b90J7CznAAAqTAkuh2bGsl5LvuDy/2YRCTvgutMzdiaHYcV2+fSo3oyWNy3KGaERcqSqgxaftpU7awFeyUz3T4Rus2k5vxcq83pukcaiM1JHNoLRjKqbSJ4OLa+qyxmQm3a/jE9ae/zjWgCvphKPfGHvfeVzVXrqE6HWfZ2HYHoTKqYGV3AL3oylcK5AzQB7wM7dqv+AX/lecfpzUfJJan6EgfFmsE7wnjq8vcpxjogKV5iOaSkIt0ISn/d2qZqKJBNa/kqg4k/RGNsfyt1m/859sjaj550LU4B27wo/aq8mKdm6WR7g51vE79A0LydTAwJKHR6ucjVdaAkvdAa3zuIO8nV19lbrD3fbZiIGvsMAIyokjk1UM8q21yJDgmTI7ncQg5hajpTyISVf58kcgbV+g6ItLpdz2S+jsZ1FinwK7atJZEcQD3eVegH57A1NC7YnnSc5Vr9ZRE3Yu8jeDY6ETovFgupON5aqfov9rf/mXgfk
 uYOpGGR8
 AQFGR5D5Vr7DnP8XZ6NefT7n7cTaCKVjBJIbm3I0kWO3Cn7cNXW58JC+DMBZueoH288NPfqE4qpqJbBQ4IB1jqPASSrrLRkxilLsibiBOjwFZF3x1W67Alab6hF5JmCZbr2lHK2c8CND6ZGpMpAXtsyf4d4r9WYhPldPiv6okZsFwjpfkrBobnMEO854fRkGjk1JWdxQ1xmbC+HsFjxFE1yhPnScFnaPJl9LSpixewvtDWWThyFxhD+So360t/t9Qw//LdJEBG+Iz8tRoflnLhbxvJfD13+Dg9qBQgpkBvbdIjqcyTA2WOdqAaVupGj1iLvDAkyAe69LUV9BI8A5YNThUU/gd5mMIgUvqESdW9A/U6lxfGkabJLKcc0sWZq1eq3iyv8EEMR209/8+0kI7zoYPRy28sIaGDvRJ/QTx8+gdqU4EVmdrSgdWbjGuNS77Pe990HA5BJxdAnOgDDyLLMDLgjDW6U03dLGY+NivNqPF3mVSf+xlPimvllkGF6Vchd8JvimpU2X0a3WZ1Z7DzSiXOQdV2nVXaLIS5/vxdmVl2QPe3R94JRD4BzMZ6uhrP4f6l3t8IOE03bzCxF6DVIEOxltCX+av5DnnSRupQ5dAvmERLwBRUCL2NaAtQWWAh+M1enKWdA6x/GM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 13:29:10 +0100
Dirk Behme <dirk.behme@gmail.com> wrote:

> On 23.12.25 12:57, Gary Guo wrote:
> > On Tue, 23 Dec 2025 12:06:17 +0200
> > Kari Argillander <kari.argillander@gmail.com> wrote:
> >   
> >> Replace the explicit bounds comparisons with a single checked_add()-based
> >> range check. This avoids redundant comparisons, makes the overflow case
> >> explicit, and results in simpler generated code (checked with godbolt
> >> for x86).
> >>
> >> No functional change intended.
> >>
> >> Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
> >> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> >> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
> >> ---
> >> Changes in v2:
> >> - Added MSVR todo (Dirk Behme)
> >> - Link to v1: https://lore.kernel.org/r/20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com
> >> ---
> >>  rust/kernel/page.rs | 19 +++++++++----------
> >>  1 file changed, 9 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> >> index 432fc0297d4a..cd2af7e4c357 100644
> >> --- a/rust/kernel/page.rs
> >> +++ b/rust/kernel/page.rs
> >> @@ -239,17 +239,16 @@ fn with_pointer_into_page<T>(
> >>          len: usize,
> >>          f: impl FnOnce(*mut u8) -> Result<T>,
> >>      ) -> Result<T> {
> >> -        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
> >> -
> >> -        if bounds_ok {
> >> -            self.with_page_mapped(move |page_addr| {
> >> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> >> -                // result in a pointer that is in bounds or one off the end of the page.
> >> -                f(unsafe { page_addr.add(off) })
> >> -            })
> >> -        } else {
> >> -            Err(EINVAL)
> >> +        // TODO: Replace `map_or` with `is_none_or` once the MSRV is >= 1.82.  
> > 
> > I was about to suggest just enable the feature gate, but turns out it was
> > only added in 1.81. That's a fast one to stabilize!  
> 
> 
> With Alexandre's `matches!` proposal I was thinking that we could drop
> the TODO comment and we won't need to touch this file again once MSRV
> is >= 1.82. Opinions.

I personally would prefer `map_or` to match. The `matches!` approach is a
bit verbose to read to me.

Keeping a TODO comment about MSRV is good IMO as they're the data sources
that could justify bumping MSRV (also to remind people of cleaning up
after MSRV is bumped).

Best,
Gary

> 
> Cheers
> 
> Dirk
> 
> 
> > Reviewed-by: Gary Guo <gary@garyguo.net>
> > 
> > Best,
> > Gary
> >   
> >> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
> >> +            return Err(EINVAL);
> >>          }


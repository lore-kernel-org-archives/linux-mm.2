Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD372CA0EE8
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF6C900163; Thu, 14 Aug 2025 09:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78ED5900023; Thu, 14 Aug 2025 09:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FF8900163; Thu, 14 Aug 2025 09:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE39900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:22:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 048B81A0549
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:22:41 +0000 (UTC)
X-FDA: 83775427764.06.AB274A2
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C8E51C0005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:22:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="P/Pwgy1k";
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755177759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONFAw+Ew8oIG1CXzz5SIebsF/MwG1iVVpRo8CHuo9Kw=;
	b=HMF07VUsz8BzWYcQiGwSfFahCYRZcmQ1BY+ggD+/jSrJupQe6e4dv/kVMYmK+7oE/pFMyu
	5YFn4fJlxIDLhNWPsRQFkymcVd0duDHKaws+NBBiUzZO60zfLm16rL0rFvufNcPd62MLRh
	HH8qAAZRxYDMXaOs7hVp7kku0Jiqxq4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="P/Pwgy1k";
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755177759; a=rsa-sha256;
	cv=pass;
	b=BKD5WwkfLAg56ppdk2rTXf1I+ibp+mlyGI5r5hrq6kdfbr4WXaYl3+QNnwx/yIghECbULj
	57a/pPww1RjwswMJAJ1nx5Xh0Dx36zWX4ifbSjxBBBdY3GpnWYICF9n/ggdG/GakyPjXa7
	kdD5bKUNOJZ/41IFXoglKLWeuJR4CHE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APTrxvHYKv69wMVAGu5LwONwBGw8pjbUiNntzy6o10Szh/3vsSG/V3I4yGGKxuJY9uzTXJbsRCRQfEHNiPzP4dg7upeBQ3XF6A4tz78dwspvNbexwWMphHHe9D9R2Cnq/faAd7RclxGzK5jeP6DnUDMhmWMbbNZw59mLaTmv/PLbthHvZfYV0uqUR/KmoQ6F0eji2Y36cdXl2P1gs3ov916z6ulxzHcocydbxFxRwK5rSMCH8PcmaKMqXbhB0jcWkZWiurn+LjOWEg+42fT8xKHincUWVFkweeiv4dR4Nb82XBQsvK3WQh/j/qxqiEdH6IqQBPyL7s+vLqUcuAPMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONFAw+Ew8oIG1CXzz5SIebsF/MwG1iVVpRo8CHuo9Kw=;
 b=AWsBpEtcjHOjCn0BRJblSytYy6kYbuB8sldmQRWmfZaZA/ried4+NfMCakoicWRMyj/l1kmbHxzL1oJke/FskUPu2JyYl8YokPa75JKEsebGV+onRmOhSwUn7sZCYocmNP4aTmEzlGkzt5BLfBThOLTSR80Bb67iVqOPXAuyuYuWqNH5KN3QN9/HEXCo++2T4nzIqFWeLVlcGtgg+dVM7LfW6ZWkixJkUH9c00DxJRCJ9JyElxpd8QrECnmMmNBlDYgtCVpaQzgFoNHOeeGl9Er4UxdJ9JbaLx+hpK+NEgr5b6tkHeAWx2CgqZPIgDebCTV9D0dh6A7QCySKutcnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONFAw+Ew8oIG1CXzz5SIebsF/MwG1iVVpRo8CHuo9Kw=;
 b=P/Pwgy1k18fYPU6f9BUsTk1QqkRsggf1k6Vi6ZVs+gTm1k+YA1nVQ142svxdXZq3DJGXt4iZ/zZae1tr9gmG1tQADlll3WHM+gdqdzbwsBw6wPunLRMOL8Os+n1iCfv2yQaMlUoRmiakQReMH3TRokoD76nx/hD1exHcE6ia2L+KdkyRujWiKRSrnX/3m+ouqySVJioUiEFUxEsXHUiQ9D2yW6JgVxaOeh4zeM9AsZpOCq2W/XHNi7rkxw+x7nT6ay0mWmHtXpLKm+paqHmrrCJx/S4XrBI5vimtZQ/ry5RqOYq33IL8wCklkTNdQAuNIRS6HHzElUmnts0+7uiSig==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 13:22:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 13:22:34 +0000
Date: Thu, 14 Aug 2025 10:22:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
Message-ID: <20250814132233.GB802098@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-8-pasha.tatashin@soleen.com>
X-ClientProxiedBy: MN0P222CA0007.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: f438fe84-7be9-4ab7-37f7-08dddb35a17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N4xFyf8udXoRyvgmtRv1ofWmodmtJYGb8awhK1GMkR442Y9Julqn1KTXQ+jp?=
 =?us-ascii?Q?7EpZrPsxoyldyw0u3dMFeIwaJCnbTQnbCF3OsAYWfNK+wesJg09rF1SBfJBU?=
 =?us-ascii?Q?zCrpkuJ6YY2LDVyWbvRN72u2N78lNYgkkKLEa1PIj19v6YNRoOwj22got1Q0?=
 =?us-ascii?Q?kEa4LK/5NZ9/Nj/eBZmXvsCjm2lxMLUjq4Skxz2g58BkfKlTP0n9RxrjKAlA?=
 =?us-ascii?Q?9nvTkKgO/WgOYYnKsptH4jJXf8b124lHVrtmXaH759iVKl/yCM9+cxCDr+BA?=
 =?us-ascii?Q?uPgmrUZA5pWW5DLecBjz+CigSAeA94lJUT6ZO+dyiY0GlkWXI0tKkyAflFal?=
 =?us-ascii?Q?K0evhtVhGg7D9kjid4i6/blAjBu9z1+ukQJQjXiW6X/RFYtEMTWivV9rbmXD?=
 =?us-ascii?Q?+nns/N/x4ZxfOOwYjP2ejyAhVfIgib2BXLQDdeijt8BZHkCVOjx48Te4auQu?=
 =?us-ascii?Q?GFlYo7cpwC0EE/X72QPB9hp8HRSaao3gmEmGRCxtnrg2aRH9LFw80Q1mWEVV?=
 =?us-ascii?Q?3cJO1D9XtkPKteA50M8IhXiD7aUVeVVktr/4yfdcBlJuWqMasrMxGmrBVnFk?=
 =?us-ascii?Q?7KHpIXleYOj56CsUIEtRj5GEDDEilC5IfPrklbdK6q0gY9AS0EIVNQrV1Bnk?=
 =?us-ascii?Q?2HcyC12rbvdSSYHUjANtoq7RaE8Lpv0XjttfRxiEHkwcM2fs84B3lkZzRATx?=
 =?us-ascii?Q?OsPD9kRhiGXryMh3OBVC3TZ9gzfWFuTZztv4NUzHSdJwNvML6APygGTN1tTU?=
 =?us-ascii?Q?Kh67tlVoaKw3Q/4JnKBMKhIwsJ5e74KR9ZxD/hBSAskNr207uB3heOqro58P?=
 =?us-ascii?Q?fDMkzBqaDFmGS11UTKBZ/OS4u1r4FRcTPtUA3VE5sunTdwOTRlHmuwcwYXys?=
 =?us-ascii?Q?rBhqREn/mUxmbuZ7iHeiYZMCu4DWEMJ0DKtnQxiBH4XR7oMVfO/z33pm2Zlk?=
 =?us-ascii?Q?20bQnqmyhGQ1XL09u+DgmRg6hWR+xPaEcBC2e5+AHCsoaxBLcovyStpQzeD3?=
 =?us-ascii?Q?WoeXrEgUvKbD9KkTygMRIKvOytMP47cr9OY4Nr8+5adyBrkGHp89uWUTL7+9?=
 =?us-ascii?Q?HQV7ZFJnHNfGXAUaJ93nejj0iVIVyKhHQbMF13w8QXvDbYMareeHBkzy/60g?=
 =?us-ascii?Q?vKWSaW9HvrG6DDamVpfvuqblpOHpvFLwgZ76JA8XR1DZRu46Xde/SP66SneH?=
 =?us-ascii?Q?eGqqvdEwB4WpoWRfctKN/rAv8TK0NkjboFOsI5r9OIX11bcTCAqSfTbk6doQ?=
 =?us-ascii?Q?odNacQd7s/gGO8C0L9Kf4lwFL71kKlLhjlyqMWyUUahjQZl9Ss49ZnBuEi/O?=
 =?us-ascii?Q?piiGxDNLpenRq5vJ1p0Y8+dLYEfWnhcLDBkQuMkLs4hLptAC49l3YGBuh/ek?=
 =?us-ascii?Q?FRrzQdXK5kTsOlOsF6jcKDX6C82nL7Wkh6px0nr2whKgS4pgSH8MqQDGKgCM?=
 =?us-ascii?Q?tsx6BJurgbc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zcse3LPGgQNrAqgkotP+Nc4HjPk7ZUr8Do4lvNImnerquOxyKiy6iS94JpNE?=
 =?us-ascii?Q?F5d+yf9g4FgRZW0BMwIK7ZZ/XfZliTQo80hECxO346b3va2/zqw1KQivJUzN?=
 =?us-ascii?Q?RN6H4RuG4naQnIwg9j33gscvmyo43CWCZ/lM+Fn7EC3KPE77mP2erTB1/JEW?=
 =?us-ascii?Q?9AWCURljaDqbOagNLZ8i3NXHaTjxPJKd7eRBb+tVFzJss7GEsxJ7k1fAVkAE?=
 =?us-ascii?Q?sI7lD5cgwGLdl37+R3zJ+amxGUvTkbKZycxJZPqRFTH62y9sTSKHAOyoM8Mz?=
 =?us-ascii?Q?3+iOC3Yh50HVBkHO9nLRnFtKDBakPVmxwpNZE5y/OTzgldWLBpUJUbM2BMBh?=
 =?us-ascii?Q?2qBotNwjgYlA65jJWYN4WtNYPtRDuFtd6Zwqqvc4dR7G5srtJJprUxXxivDm?=
 =?us-ascii?Q?U0ee7ZUednuAm2vuiErLBn8eK2RnGInEeso8Ok+ZvRtftHwKILDi+u/iN3js?=
 =?us-ascii?Q?+EUCqvEzow9v3cr8K0y2wIuxZctrLFgOv5lnN2X4nei8dPGNRGRZ+3ZJMfNp?=
 =?us-ascii?Q?HJ7OvyNGQUyO6Ll0O/twQbwObkkLrOwtguB8wALGW2BMBoCCZgvMzSCiPFPx?=
 =?us-ascii?Q?i4BL9zRhpR6BxzzA8bxET7Ne0lT+4+vCy7G6gGIZSPS6Vn1DYLlHoVamsRfz?=
 =?us-ascii?Q?6dM1lBDCfYHxMrDcEhRZTPNYu8nyHsLJ4hD8wtBSlH3qvmxfSt+I2Eg348Fk?=
 =?us-ascii?Q?9Cmgifx4TV3IdFq8+TliNtRrGGC2R2ZnF1T0NYQTYse0Vgu3DNYFRFRqEjnO?=
 =?us-ascii?Q?lAeOO3JdlO8iGadvV7/dr2Z+1owSxV7YawKyBXC/R3tjeqLOJO2SbTLQiq0x?=
 =?us-ascii?Q?qo+RyUciU/8iuWFtsI/MKMLR8K2BLYqhpl5XNmaqbc173dTu8QOs3LWp4ebR?=
 =?us-ascii?Q?SD9rBu27+LWDUgB00GwoT6ZO8UoH0Ta0Wni4UGKs7VlJ1m1qKu9P3PV4V0b0?=
 =?us-ascii?Q?86pbVQ2sopfasRxMtYt5EvWnqZT86v5vzvFhDAlU6hfJk6Q0HT9qDHXYSZqF?=
 =?us-ascii?Q?D+2Wf1VuR7VYS8nbJpNvwU7Kov1BRwEi+hFEJHjtr/sULPhVTkAz6vcg9oYd?=
 =?us-ascii?Q?UEbgKmTWoXhTM48iKMjSsnCvNpExPfdIZ1TE1cg64Oomn8Pl0cCbalS9pPlz?=
 =?us-ascii?Q?mS2e3dl/h0ECiRMEP+Ie1DNjSidNZuer2tI7SnJ4v/Rc7oIJQbDRcVKgwrIK?=
 =?us-ascii?Q?EJtjaxs9QgH/qQp91zxbTy9eUp6nkR6YAm3+EqjRPbX08zICo7KmEO4GBwbH?=
 =?us-ascii?Q?4H/9PE1ziMhGN0QeIdjcwzVZ7Kaz3nAOybbdKYxjPiLsv6Rqktjw2zflD33H?=
 =?us-ascii?Q?SocoE43OtG86xfmFcv+vAQPBv+TXRQ+NNsXPLwYA8S0r4Bwv/sAwRHEqqDYb?=
 =?us-ascii?Q?CAzmgydGswZQ2O3uRedalQbvGrW8R8z4wlVex6GcJ8jn7js36wEP5SOb2rkY?=
 =?us-ascii?Q?L843vUvZiQ2BhvExoICKptsuDIwAjgFzMnNflY32C27ge/9x2DUPZLutUoHb?=
 =?us-ascii?Q?8MQJyDbsZLQcIj9x7u4fIJGncg6vwi82jUbxipcVXNZaYF82dswAgMEBIug0?=
 =?us-ascii?Q?3FQafR1hKuGoJiXqFcI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f438fe84-7be9-4ab7-37f7-08dddb35a17d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:22:34.8071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2By4MfPAcGjg9PnTkE/zfaNqlt+irEo9XRYgHW/TPuwIfR5m44/tFrl3t3ZXHLCq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
X-Stat-Signature: fmndudtfwhua4d1nu7r89apma7fbuc9d
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C8E51C0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755177758-361400
X-HE-Meta: U2FsdGVkX19TYMWvLNOiQlR3kVtk75HNYNtkYeA2eh2mow3NLChdhgtrQ7Rv8nXyO9HGsIQiJ6ylYqwJXeAaOew8fm95VJQUKfHOLu1u47Ew9u89uGbGec2wed/IiK03q7DVvb1PbJYuOlK0pkcXmq9azSJ54BGscxAbIuVlMUUQ3I/+cr0geSRi/wtrd/oP85GHtkNHYRuPL5skXTT1BAPPJE+WJoBc+dmDrJW8BPhqhemUIRScINk0e5uMpbgeH3HI6mGzvdLvxR0bjbvu+uaGxC5W2inyg17G0mZWt4KUeONlWEAQ98qrcKCsc6fJ7tlbOlDZb301RgumEdSLdFRwgrJrWYADSAtIdJT3xHiXCKvox5sPg+PGFaOhK80tGS4vJ8y0flYxh2pjnLXEHBIXrN6MLeov4BfuablrmAv4SWDIucUtmntNzDYwtjP1FZSb0Cl47eAbV9V12E8Okgdts7W4LFPUW5xugf6unrVShr+VHp/l6zMxtUJBpy2quIVmaDlL6ScM9MRgmkFLLl/ekmX2FSzsnkPlp9si47vc9T00ZiqBVaJmD/6PYMBMJWkusJyiCyrDH1xvh/+k/7l0+tSJUod6+TtlGUEw/rU1Rr4YBrJqy/IQzSkqE9eK5wBi3blehR9AkzMSx2YN35NvgU/bEjsdHEojrZiAqaKJfezAkIJ0mFmNaJwcxma4vFVZ7UwmC+PMsqhN2QxPiXSkUV1aMoXk666iDDNAkHiBK0+3pdKgkeslC1gjWXPaAADPZ0DELKEajvritdmkma2OOh1qabD8ZxoGMpq7RrPkubZx69gYopi4CXySmaHVLrpg0IBoVlXCCJZruroerLFLcMCGc558yHYK5t96OIRv1RbvYlPgrt4oOxnmCDL9y0hiTxHu2MPPMZOPmE8LEmw+Qlp2Jby8kPVdHHvDK6T+lbpCOQDy8YZXaP8lCh2UOsZFLfvh6O7uEAa0F97
 qDlVMJxs
 G1Tj3pw/iOXsSDRCMmkrxC1ESxkifUlUtoutp7nufVnjKC4yw9MRyqHcb+IXW9m6DiSHbLwkEuauuoz80H8CJrlOSvOoRX1MDOt8y55qtDk2inDqx5pBZCGRnAvM4XLh6af9CiQjFfbTkR8DJGOrB/rT956//B81ZQnuLXKZmnKR/WLIARSjwa9sBS9E1dUM0T5MEozJcLdj/iXWxgfBuFNLEGaVCcDJ0aa6xSo475MOhSBAOHu6otDTZN/OG7gLHbSDI29l9QnpORtgBXn4MvWMkj3D1J4aJkVWvemz9YniTNTupIAU6DCmASDym5KG7UWkJmirufHazkeAbmxHD7ZPfODcS695zZgHFltlLlwRGCwE30AR6sFuXFaxdhSxnSF8PiFcn26gSZWbLZ79JsUzKoy7lmkfJnhtxbAIVDEkw4a+zgqxv7whuXWdjJ9dE1aDwBU2iYtyemsV7sX3wRsCrGFvAVaZ6e0CosfxrXjzWG6nIwn9igktdgjFXvhVMdYRUKdYezL1rIk2cwhI75uqqFIuzM11lIVzai4dE8HHH1T3lhPaXRA21H57Kv3z1DHGm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:44:13AM +0000, Pasha Tatashin wrote:
> +int kho_unpreserve_phys(phys_addr_t phys, size_t size)
> +{

Why are we adding phys apis? Didn't we talk about this before and
agree not to expose these?

The places using it are goofy:

+static int luo_fdt_setup(void)
+{
+       fdt_out = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+                                          get_order(LUO_FDT_SIZE));

+       ret = kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);

+       WARN_ON_ONCE(kho_unpreserve_phys(__pa(fdt_out), LUO_FDT_SIZE));

It literally allocated a page and then for some reason switches to
phys with an open coded __pa??

This is ugly, if you want a helper to match __get_free_pages() then
make one that works on void * directly. You can get the order of the
void * directly from the struct page IIRC when using GFP_COMP.

Which is perhaps another comment, if this __get_free_pages() is going
to be a common pattern (and I guess it will be) then the API should be
streamlined alot more:

 void *kho_alloc_preserved_memory(gfp, size);
 void kho_free_preserved_memory(void *);

Which can wrapper the get_free_pages and the preserve logic and gives
a nice path to possibly someday supporting non-PAGE_SIZE allocations.

Jason


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289BCFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 19:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF966B0088; Mon, 27 Apr 2026 15:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D66A6B008A; Mon, 27 Apr 2026 15:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06F96B008C; Mon, 27 Apr 2026 15:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0B396B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:19:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F5771602BD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:19:53 +0000 (UTC)
X-FDA: 84705300666.04.F8A6E35
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id B375A40010
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:19:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=YPchTHpL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777317590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bn1XEoBn5w70ry5cKdhd7NblMGBJeki9ISIgbMZwS50=;
	b=0My4g3MUpnNPILiyS4/J5Az7n0K+L8OeSngrtj2N0Ls0IKZoPc7PcDgaDyzkarwDs0hwsp
	2rkpoOnKbriNUDNEfF+aXveJfHiWGHhUcvtsdlvYLONMxu7h9h27vvoPdvC/L6gb7u0Kty
	O8vVjU0stZFU5QS02fW3hw/K/3uy+No=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777317590; a=rsa-sha256;
	cv=fail;
	b=7cQCkexlFam9Mz0I6DoklOWsESCpNau16TRlP8yLK7CDY+aPuNgp/Or05Iuqj2Mat0R6G5
	TAy4UIrelQ4jFtIWA8jPCVJWo0oQ0IcrdlbfNR4z2UOilqhyVvFHxE1pKv04iR5qA1ms/Z
	8O31qoQ4ysFsZIagQwSmtB/sFqI8Vnk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=YPchTHpL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVhEHbKse9FapnN2cz2aJUX+HTxcItqfquBUQFwLCiP5WPrtNQiNPTnGI4MIon3AgmkAQl5HhYuSQnuQt8IDeRYhgInyB/AOQdBwrpUiHITV3f694UVLHuUrOiv9b2cfG6r3+auR6MSVkkcLuQ4Y+tF/rhfDNeBCXess0F+F/TkXrV+dz92vsSLlL5tn1Ynl2fbpcNoIAef0KBxuv6gcdjE4t82LvHJAaDNASNUKyKFm7x4T0BsLAz0/sYnIg36y560VeNc7zOL4T4Ud5AI185ZovsKb5e37aJIb1I3/TkqG0ULl2gwnmAIb6WWT/tvMtVulTJ6c/93Ndgr0CuF4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kehAw/qIO6D93HVE5am8hZKsLTTbdaFhcjGhCC5rQk=;
 b=barriPy2JoAhTOU2YWoiBczra9jgxyFIS6Vn5fMeLmZuoQbamS7hXIudelNBWOJlYCTT4fz6sLrJvnhUdW9BOtoGyJggKAsOzpYbdXTAoZYuiChGWVjjK4zj5T6ViLKFtxvsysAksVjZEfM7DJVmWiyYI9e45cpEy9i20IgZjrl32t2DE427qEOO5vlB9eYx56Yl/nXGgL4VLYapDOlIgCcuJftQuYsdND79AhJHc1YvPlUNuHXQ+n3CfukGLrY/uuf3W2l/Yujue6iK9C39RkCuvxgHmU04+3GeYVYQvrsxPBRvQZHz5V/LPu92hWZsyj93vuK0RwQezDTTJlGlNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kehAw/qIO6D93HVE5am8hZKsLTTbdaFhcjGhCC5rQk=;
 b=YPchTHpLT9QyaGFbz/V/HaxoYwml60CPwBCohwTGccSxQF5xp4aCWy87+9L75FNFxG+fxrmiBfrijK9S2U71MhRFySlXZXPcGWovjvdfkNvvp25q1PAB1mr+HmzjdR2xRedKx7NR5nzOddAsQnNEGyggXH0WqDfgUQo8MCzVvhQJIRQ9THI7KbDluLzImajEqpi/FOh1jFu/Gzsx5Px0K5iD8tBWuFPua2hJduhxINK682Oc8hT1rNV3ppOrrAFmrK5A2egSfIVt/1zbLX+OPjABfYsc675DnlpFoxG5tXvBSDdEGGHoW1lpS7Myqc3PGBqojvAzWyzSfMH/AHuVBg==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by CY3PR12MB9678.namprd12.prod.outlook.com (2603:10b6:930:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Mon, 27 Apr
 2026 19:19:39 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%3]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 19:19:39 +0000
Date: Mon, 27 Apr 2026 15:19:36 -0400
From: Yury Norov <ynorov@nvidia.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
Message-ID: <ae-2yLWSGnfeTvh1@yury>
References: <cover.1777306795.git.chleroy@kernel.org>
 <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury>
 <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org>
X-ClientProxiedBy: BLAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:208:32d::6) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|CY3PR12MB9678:EE_
X-MS-Office365-Filtering-Correlation-Id: c742778b-fa9b-44f9-51b3-08dea491ed5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|10070799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	shZ1u0REr6wDLRLPyyEdIcR7HSBaBLI9bkPwQrtikVH2FtKB2JxFo1blEpu1cI3NJl8SRfbhAKLYIVGCuUMzmvBnxw+FuY/TWQm+eDHPdr22c6rn1JUuzt3nYVxIbuuLTVTRWsq+e+SUyzbYaEEs9iTQJbTfJiMIr1QcnMs7HyZ09hEYM4Y4qXo4Dqr7nhb5zdIkE0fiLtqy/Zisxe0E2yKOvU4HmFcaFOiR7Aq6DJwZzTG+BR733bn5EC71RBcWvOANFgJM2znxVv/dOuQYufc4G4dUHtXgydGyNUS+fngDUjvyX5MkmDLhOMznjZqXlYqgeu5lMUCpG8HffRFHlOXhBcrYgf+ovMMHaCYbFuDT66UC1VDFvb4rz83Hk2Lnl6vSSpPTv8rxpTSPpx4cdJdNmo0Mn5Mi/3x46vGIX9O5JTAct5Ir50zvkKLZe7/Kp1qSfB39msc26Lzz7LD733/o3mPnQXyAGLurnHZgJ5jM3FLt650dCqhJcZlPMaXHq6+AjtwJTG6y+mX2JUt2792E1LYJn7KjXVu8/xqn/7IpL5oC4IQQUgghT221wDL3lrh3xCL1IuqFJShNLP2kKxWwgFBJzIfU0pnScVGPPU9YsipaXNEtmsuD5RQqnXWq43E7KCoMjIP73gvWalBIhJkqTKcX6NUkX7ot5JSYyuNq1A833Lgaec6O0C//zC9ubi3rz9CymfV/P6BrxHZIhmtQ5semmv0gY0c6C5hRnqM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(10070799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?T8W6XhUXwT9dv5kuj9kFMa1Pc+caKbpom/7i+ro0mWLEx/WsMCf7Uv+yLt?=
 =?iso-8859-1?Q?gAyF6hz8bSDC1bWR1FTEkkI65aMUmC7iyx7e6/xfNDa3Fqe7SiC1j77stI?=
 =?iso-8859-1?Q?LrG24onu6fFBF8DWYf6MIuIlkdgrbAd2EiVVGxnofgYgHTQhw5136OB8qO?=
 =?iso-8859-1?Q?CnzmyDAwjI33B1CjeJnNBBJkCzrksdZvxIcHW0uIe6E0PZHf537RLpIETM?=
 =?iso-8859-1?Q?s+cBh7JvH4GNxPjZACl7GXrozKiFqXSwFIzHaU9Zd4jSjyzd0KPJpIHPKf?=
 =?iso-8859-1?Q?8h/I+NEnIGw4Lnjlmh9mYKMwd0qS2GIHpVaOy1bH5MCjGmjowRaXjQ79be?=
 =?iso-8859-1?Q?jGRLn+Oomml9guRrsFzOQ7DbbOlFy8pqy9R+D9ZnGVn8wEgYSRw75xgmry?=
 =?iso-8859-1?Q?2ACNauoKPoUzpnRmfqW3sPF9JS/tvt2t2PPNVTZJLV6vuJBnNmyWilx/9u?=
 =?iso-8859-1?Q?SrlYzTyazTZWIZbUeG2soKD4eNVokxFYJQoBgEsGEV2njiNv6HUubbi0pF?=
 =?iso-8859-1?Q?Vqp14jJqz5sSfFayA6WZcArZ+USE5vjanuqRtNQfdkNsKj0R4pEMc493o0?=
 =?iso-8859-1?Q?NCXeFBw/ojt6aGg8g6h7tHIHZcYuw7ohhZUMOvg3ffhlK9u79tO7oKpC3u?=
 =?iso-8859-1?Q?wiPOjYl6brt/0GKfD3iRNbrV6TRbbioNcjuDS7LZqgWxe6vMy7NndX+woA?=
 =?iso-8859-1?Q?uRdr5blnc5k3cJWHAzCHgJ5WF2JWGApq1uyN9UWgvqNw083HRffGg6P5ix?=
 =?iso-8859-1?Q?cG24FhHq+kscs9DSxIC+Aujk67lP+3jqbld/7XWy8cKm8qvSHwRqhWblhk?=
 =?iso-8859-1?Q?2okcTJPbDNOuvYYOSGTPE+vmAEFbkK1UHPvMUY9ATxehETfXPZs7yjb3aq?=
 =?iso-8859-1?Q?w3hdW7xtyg3/7tDEWG7+fOEy9FFT/gEBpvxotxF6oySrb2HXqp/fqrjhbq?=
 =?iso-8859-1?Q?+CZwwgugua6eO4UL5qPz9hiIFbMAfNaGqRykJRiykn+pL+t1YHattmJ89+?=
 =?iso-8859-1?Q?zMjzPmRht5LCTdelXGsXfPIKJiFXD3T9vDfN3lmWj4Ts7wlilxpgiOpMaL?=
 =?iso-8859-1?Q?p7E3h5ji6cLKiR9cNwmzJTNOGBx5zvsEG4+PNQXhBDGMpxOVgOl+EeAV9d?=
 =?iso-8859-1?Q?2s3FGgMUZVYPP9cV5NsthWoh6iNfuRN7NkopE2q3yxMVZlN6dt7HdpbO1Y?=
 =?iso-8859-1?Q?0fu25Ra/a3yy2XE0TtJPHqDm12P85rdM3CgNkUv822FbtecXgL64Qkuo5p?=
 =?iso-8859-1?Q?bU1qrEG+LOPjM/jMvPhwRHc5ppnq/gaXYhFU5FH0G3K5d4d0ixkRyi37Wv?=
 =?iso-8859-1?Q?QFsdW6QrX/SrL3DsdbaAqQnL1rxC0EQG3YCsMUYGRLPRYd9ad5xPY0x+Rq?=
 =?iso-8859-1?Q?pi74xEsiw9PrH9X+6nGn6Y3d7VcpnV6Av8/J+hqLZLRt6W9B7IXfCaTIAV?=
 =?iso-8859-1?Q?8KCRWdm4ExrgkDdvMYea8olZLEBlvgMeZtCVoxZ810+OR4vZKUUMbB37Ha?=
 =?iso-8859-1?Q?gwC1ZTD4TpsWjGJNj5Ry/c9tX5RkpCdCKRBegPQIrqdU1WX41QArSPS9fb?=
 =?iso-8859-1?Q?xDEYSUCFDpxyHnIl4mh4MFcUHTIxFSpQAIB1z5w75JzJg+rYBE9y0Z0uA2?=
 =?iso-8859-1?Q?hx89znOZLi5+tvIZldfaxSE1Dk0RrYzkMtqQuuDh61/I6rksRc2kt6jYug?=
 =?iso-8859-1?Q?hvJgjrdcklYMst8NSnorft9iaeq41s5Z02Our3r1w88xwCK/RrRq8aIdSR?=
 =?iso-8859-1?Q?gpisMPDwKRAml31b4cWNg8wz9VF+bGszAp5BtKObcEufaeReWjiKmyXNV3?=
 =?iso-8859-1?Q?qbI4euw+Po2OswoqiwgiX8xIAeThU5sXrO2JRJTwu37/nYFGOi2s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c742778b-fa9b-44f9-51b3-08dea491ed5d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 19:19:39.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40kb2lLpGDA1U6OK1K/FxB8sAmuWJ+U6w4mJNOJ6ae5Bq52M+Y3YVxXlUqHMzI9liQk01DjxzLicYADua7DWLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9678
X-Rspam-User: 
X-Rspamd-Queue-Id: B375A40010
X-Rspamd-Server: rspam04
X-Stat-Signature: zqooyhyzf5bdxohf4i15n5mp4a1uije7
X-HE-Tag: 1777317590-237624
X-HE-Meta: U2FsdGVkX197BaQ+XGC1E4Elsd01WfCJsjiYwik5uvft0+xl98Jch8Mhs2u3zlZrElvLzpEadhPsGLG/2JrhC9v4NxmPnRCRLO7KFvrqW2pnieQVwz11NSaJ0sVKPqDdw60j7r4Bqxec3FYoTo6cslnj9mgdfSqfT15nbgTYiRqXUfT0kpvKnsloVUy1vMmHmxSiCsc/A4oTOJ4zDqq1w05GpE5FLtk3H0DDAWKE4pJPoQyu9RZ0XnDKtfve9iT5/BmH5ORsf280QRtnSVsdHhSANQ6iGGUd8CdcDKICaeDKJfEv2H3xL93HE1V3sMYJjt3qXJnoQeaK4b2nxkqb6PTOWr2tVlCZVNvvowMTieiVxYJxB9xOG5vt6P9N6xcZwhcGhClJ+yXU4ULm+3GLUKMfq4T4Jn7KzVjNcnvbWAdbbxG09IPPcz5i0P8a8r7N4lcxftyHtAIlBFQQJ6AUG1SgFtL+hrpIshoEOnRF+OvxeOxtKI+JxY/m8ULf5CMJ3tYPXe5v9XxKe2pzhXWPhiV1CSQumfhTfEhHG06O98cOQzxlGWUErDBVtVCesz9JgfLnYyrg9YrZNQ8j2Bma5ckr3kXnUpdvztwS0VduIKihgJFzxe4hMkRx2lWBjfPI0DapkmSdymWOiocXb+5rRLIt8f9tVlHkNQXdST0vh03T5p6APkoP0sgppopsnbm1e7FEMorBO670ARbWnT2gmUX0Vx+PE3jgMjBQ4dyTChUi6bVeDkXX+78BQ24G9+UFdean+CN9W8ptWhSmxaMPU6G6rlqI6jMI4jjw0AONywqrX6u/SU32uT6o1sDOSm24eQU1NhWveABeG8I39PVoCnpBQRTF8bAvWa0++JavdMtfzqnVfWQ+RtU0BYYKcS/9288PznuJDWVLve4OKPPSdsikB7G9Qx0DcMW2v3fwoiHq7HgLALgrmGnHHCRQY0tVgv6TkXS89fPvgk5JNJV
 59aCAFPo
 z9yuYGZsaEYZ3/J6L9RR7JONYjecuyrqCNf2amqATNFuC6eyPsLgsQkbOJ8uxrYh5WpBa1Wy81iYGcqjJnqU1XAs1siHA72VDW9Z9RPkuWLDBtSdj/I+UABd/2cazhQd8Vtnhb2LJjqa9b6XX71V9ufJrHK6TnDvWHqyyQeX7td9AXiQZk84/0TOLqMba9Rb/DEzBYkEnsa5cdA8LbnaWrXL8UOVH4Usd9p4bLyrs5YOg+mlY5UrXYFH1Q71gXxFK2vEfSquDgzPnhW0BP6C9lCP5As3heQhqARzZYafs5RwqOltMdhEnqov+BCHqvN/FepOve7Uiu6AKN83ZylUidhyROJRAzNAiwrfZMiO9jVnNYhttwwyPHF6Nf/EH1uU55vQ1kDyCQ5bDMPduDqQUMXefFlUODkmswufjiGiUlK8gLVoBoQUMhWTsdqb9mdyZLJGuqg7jrytIJk+44tP5pMzOtoP3u+WWmBxRrCsHX0BG8RKB01FKPZBk+hlTFtY4sX+YvFlArqE9e52vuCbFp3OYT3sdQ56Qs6ijc60GnfXYhwYbQLHOtMjJooHiUq93vFjikUANEs71Ag0dBVixUpF7oswhqWCy4oknslkHW8anASIWBM41M5YrCk6VreNs0YPXvvKoMhrlXK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 08:20:38PM +0200, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 27/04/2026 à 19:58, Yury Norov a écrit :
> > On Mon, Apr 27, 2026 at 07:13:48PM +0200, Christophe Leroy (CS GROUP) wrote:
> > > At the time being, x86 and arm64 are missing unsafe_copy_from_user().
> > 
> > No, they don't. They (should) rely on a generic implementation from
> > linux/uaccess.h, like every other arch, except for  PPC and RISCV.
> > 
> > But they #define arch_unsafe_get_user, and the unsafe_copy_from_user()
> > becomes undefined conditionally on that.
> > 
> > So please, fix that bug instead of introducing another arch flavor.
> > We'd always choose generic version, unless there's strong evidence
> > that arch one is better.
> 
> But they both implement the exact same unsafe_copy_to_user(). What is the
> difference here ?
>
> Should that function become generic too ?

This is what Linus said when added x86 implementation for copy_from_user()
in c512c69187197:

  Note that it only does this [arch version] for the copying _to_ user space,
  and we still don't have a unsafe version of copy_from_user().
  
  That's partly because we have no current users of it, but also partly
  because the copy_from_user() case is slightly different and cannot
  efficiently be implemented in terms of a unsafe_get_user() loop (because
  gcc can't do asm goto with outputs).

In the unsafe_copy_to_user case, arch versions were justified. Just as
said, I'm not against arch version for unsafe_copy_from_user(), but it
should be explained very well.


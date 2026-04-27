Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAB1FF8869
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764806B0088; Mon, 27 Apr 2026 13:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715456B008A; Mon, 27 Apr 2026 13:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605186B008C; Mon, 27 Apr 2026 13:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA4C6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:59:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D68F416026A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:59:09 +0000 (UTC)
X-FDA: 84705097218.11.CFECB5F
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B90540002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:59:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JEzvcYXQ;
	spf=pass (imf27.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.7 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777312747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWBdJXFvUsRNS535pCc24v4leweSht+XdLI4YB0XzRQ=;
	b=Dt/hhu0HaoJ/M4kriAVFRSueHje1lvqMWfcTf2/Q88EPKfXNS43R4BKPQVGtYjK344VgOu
	9vCTX8188qJwgzOSGBIPqS0PMv/a0CHznYwCuS6XXcMKExBmzRMEwKrCr4oCkoIceHFyfR
	Faw01bVnrBRPZlTSROs3BL1p+wWtYAo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JEzvcYXQ;
	spf=pass (imf27.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.7 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777312747; a=rsa-sha256;
	cv=pass;
	b=hECsB1e4eejdiV45kl9XfidLg2UtVHyE0m++0jKyFQ8mlQJLGsPjHa7wo4yaK+NgM1VyxL
	s/Hhf+zVCrkrL5QvN7sTdgv6Dgn8ipLqr2zDQwiyRD4PPmqAkxJyv9wF44wdcBTgvX0rXi
	jwk/G/xDdBKQiuNki6l3R9gO9J2d1r8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dwpVDJgRLpkyPrfWdsCpP94nHFQqYhYYfzZrq3/Y3eNMNV9kiDiO/lbPQcnh84Kc9KV6mYkk8nn970vbv0+7s6iPEYVW6K4EoChbQ41Qt789Udh9qXYG0iRgkAlDfrPUTQ8sayrAf1ja/JDhQMouPOkZWD58nKWYqpFBMo1DDNj8wVNgDK9FxRdlDaJopLZdzHGxZYNJ5taZ4f+3AlBWDxckohAjQSiNvLpxdNeatx21GsEOk2kuIxck61/13uzdWjKAIWRN7lHpHYgB1JwAWYdhnI0JhIPLSMLkKBOcW0uKNe5jsqRdVec4b90SQh3bBTkUz0ka/PlhmT5JsiSnTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWBdJXFvUsRNS535pCc24v4leweSht+XdLI4YB0XzRQ=;
 b=JzUtnzYfifHT4anVN/U1LZ+ey7uTRcx8Nn6Nm2hS9ao6k8XZlQLiaLdpmpmADTsoF0ln9yrZ43mTgzp40gS4qmCP3SHZse2kmq2eYIeYuMuHwoWEH5Vv7fhlfZ2f/diNwlwlNxlMKsTb0izAMGGMQ4cYn6SIIE/MJoDjMtlx4eVbTb6wUFNjAz0H8mGu6ee9kYZLwb1h4NdHsUxdFPnysIwTjLgK6AvD73khRL2k8fi7iymz8mICE66X711dcKdxGAaSE87cWJD8y89JkEkcX+zpl2DCijx6ZDalEAkq61Vdd/L+W8dfRfgTksTcDbvv+E+khdr+3nyDPvxgL3L9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWBdJXFvUsRNS535pCc24v4leweSht+XdLI4YB0XzRQ=;
 b=JEzvcYXQdwVjYZQlnStgbJQRfUGE245OkUv62d/erL7f0QOnr7fp+plL1zfa5mv2O11r5j+JLE5qQdINthQPR+Bj7wYWw46AWrQu/eYz6ED1n8xbwCAyvlDxh9XEzqZC2g1/3KWQVSH/DH18jJwgAfYkttpt/Blmd/pUHyEDc3Wkd3edhlrvX1h1qaZ6ZPmQk/87myHHQ3TrQ1ak0Xvkilcg5V0KT50UAZqYfZ39xcshyA39b5FsO98OY/S/YtJ/myHG6I+ftEFEH6NVP/B7k+6+4RVku7Lrcmp3zsQ+ArtGrvl5bXoyxfgJj2OT6m5rwYJbHAOe8gpGdj72kjww1Q==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 17:58:53 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%3]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 17:58:53 +0000
Date: Mon, 27 Apr 2026 13:58:51 -0400
From: Yury Norov <ynorov@nvidia.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
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
Message-ID: <ae-j2_QirCySZD02@yury>
References: <cover.1777306795.git.chleroy@kernel.org>
 <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
X-ClientProxiedBy: BN1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:408:e2::13) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: 33128524-511f-440c-0040-08dea486a4e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	T80DamO5jzLhtBsxTULWy0efzaMbF8i7bT0PZKZ+UW4Z1vXusNNCyeFtPNKLbujbu9HADo2BygF39wi6lx74qp3NIinqoXF6o8xZWMAAFsZmucFOM22V5xO7kTuoG3Q6DbZQuR99ud23XQ2FkmrxQgMHmfI3XdFsqYAVjCS9aGVDF45G53+B/x+14PhezRjA9hqQvcw9EvJb6nHARdhsgHJSbcoZorjI9T48oVUEponu+eLNKghANZW7qOCu576IfZ6NRYzsY8ql1Bj8uCnhHA2nhVrKxbbZHG6LptctXV/l6KubZ/U3ZJxrPqPY1X92d625k4fagqEvx268olGcNZDaxDxTtIunEves9hFv+KACk+0uW+ma5OsqtlX5HthzXN6Acbz5tPRPmIKZ/YCyosbcqxLc7ZwX6TI/oKUfq/0tyKExxJEp/Vfc/ZG4cPWp456yUxuQQ7c0zO0EIJ+8b2gQDonWZCvn2KJzNH3N0drPOUzCQcDDQjndG2yh9Ke573Rkt//8VoZT4MTwoNB6z6b1QOagadBkLNDtxDt0AE1XfaIibN7XpAHe5nsEIn2aXs/8ZEHWz0Zv0D5+n5iwRxATzlfDoLqw+IUuN8nm7pwCMHkXF52Sms8QQtJ2rJZUXeJqLYfMQUF/D3X8mn4B7tCVxc1mKoVLz9/1oBAf2bseKRBX0rfB9ZeVX7GBdP+qZAYwkxdtBveQtq9fZ/UIGHDRO8YYxr5lavOVhUA40rc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6ev31P6fGlLQLOmFhG9wf+2ZENF2CJrasImnLdTMkk4B07wVpIqdqcEhUwVr?=
 =?us-ascii?Q?VcuKpfWBww+Qglw6NKPvrbqw/iKodwZS6hoQ2ezn6gKQJTXowcVzIMKKmPVI?=
 =?us-ascii?Q?CaGe2PzzTfbrd+1/kBuQd5inX41eLfMXGSMB4El+/BGeY7LidWaO2U6MXIZl?=
 =?us-ascii?Q?To5KMHCCmaxaSW+0abx+uHxslGaDNGAxlD0ajEnVCyj2PyGw8gfavgZvUBeC?=
 =?us-ascii?Q?31Pn2vGdNJPTEao0o8nkBbqzRysmZBZFRsyFAwtcHiF+LMJewEDkGWcf3C7D?=
 =?us-ascii?Q?MhvHUO7rY2T4Gp8yOxYlhdkCQq0m4ykawDCJw9P3w79tbrFqeU7DKZcc6Svj?=
 =?us-ascii?Q?gpUdDiMP1u+wbi6ktqsa2/SBsCawL8yd85/gdX8JeS4P5U//2zVMdqlbS5oF?=
 =?us-ascii?Q?Om8kn23qHMWd1W0xp+L9zqhhURuKBI3C8K6/P0P2OiLTdsZ7lPLULvDBkdZf?=
 =?us-ascii?Q?UKjydMyY/3pcrF3sadi8xEKK6PbOoyabovH4OGdbUvrwD7GG4qRTd8pK59oC?=
 =?us-ascii?Q?snIKpVz1xKnwCa6xY5VnFP5/u/JjDPLADrD/WslKg8YXRFtCzAtBrdImcj0f?=
 =?us-ascii?Q?8yOAh4lyWUDPVX2WM00ySuZhGhvO+v6NJ73vz9XlsUfOsWyYZ9DOEzjUfhbH?=
 =?us-ascii?Q?0YLtM7C7LxhLfanXFKSW+D7acdbl8uANIv2lLYjkqPUxgpfNe8f+7W2LB5Nn?=
 =?us-ascii?Q?7Np0MclwQhDcY1GLCNhmF+qQmAOMVCLRhyHjLhLWkRHgj+alwIysbQ3EuYLN?=
 =?us-ascii?Q?5yHcsNNjsFo0wDyhRUVx5wyCMlW+Z4NGoPr32ydxiktuCQaON6kbvoanfM01?=
 =?us-ascii?Q?VM4/fS2+speM2tcePSAnjiQa5qjOFuYZ0VtZfeGTBIZ1yXD2cHpN1ixZN0Rz?=
 =?us-ascii?Q?L/dQY0op7e/9Yk5F3A4lFGTivTaixUSEIjTezh3qI+wT/tBYEl0Z0XCO2hjU?=
 =?us-ascii?Q?sFOU7EJ1CIL6HbyGijpDH3Yp4I8rMW9VuNbKDzbyWnaJJg9tVdo0/XIJrdAh?=
 =?us-ascii?Q?vVKIJZb+31gwlMVE1kXLTM4rt1jmj4rcA1rNCuw4fD++YKU0KqxirVrsn6kC?=
 =?us-ascii?Q?lZa0X05s4hYIlo7g4DALYttelKqcNX1HEGU6vO71rQrVfydGtRIQzA8hZ8rQ?=
 =?us-ascii?Q?O80VU2eqMYB7eYpBItWytqLFV33JZ/cuulFCjhdnG06CQcNI6/4ovyhT3Aa8?=
 =?us-ascii?Q?PiZXBZphvtTKhhJqQ1c7RRKZs8niebQgxVT+NqLMFlyPhkta2YjjpBXgNIIx?=
 =?us-ascii?Q?h+iPSpkL/BZ7G18/IWgE5T5t9GEq5s5xWwSmey7027/BRYe03neS8L78GvQZ?=
 =?us-ascii?Q?5ceRI/ymV7A6xiSGKp4h0GdJvHPIvbvLvAXTNPJXPyEy/lkYzUg06m/F5Ppx?=
 =?us-ascii?Q?Ucqpyqpi7uPkJEjc3424leqnNg3d1TwAm//hlnXAadNRP0K+njbmTw4CpTe2?=
 =?us-ascii?Q?4HHWlSZ9YpBEw+Ohv14Uf9RwjiFvVAghctOlWmh5sz2AhDjQMGMs8VSWcPgV?=
 =?us-ascii?Q?CT54kkzGd7BsoQ2aPoLVEhjPxQJKnRuZKDOQB6HL77e6jo+Karv0u6QI8scU?=
 =?us-ascii?Q?/P+zWIUoY7Vp26Mnav/FMyG/vDm64Qhe7JrRNaXxdZN6cKMY0RccPxeEvM6K?=
 =?us-ascii?Q?cokd+q0bbXdS3sEK+pM8MrC/A2+EernBjELOWvLW6UNcdosIRiZXx3jxfYAW?=
 =?us-ascii?Q?NoTKA/lHF00/AFzSuUQZeA/Bt64WCRihJQrbIN0bhLrfQCWWaLbXoiNjdnxt?=
 =?us-ascii?Q?OgQB96s+EfSA5RhJu/4bwnEHg5Lb6TZfXmPjZN7/WMw6zB/yunPn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33128524-511f-440c-0040-08dea486a4e3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 17:58:53.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFLDrWxkcKDSdWjcRZ0FWTXyKov5/udW2ySQZAiU/0h1WJYCpRdFgW8eHZBY8qsOSQ9+hnLtwBfn4bjMnIR9OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B90540002
X-Rspam-User: 
X-Stat-Signature: kw9zkje5m4pkwc7iiyijbu8h8ibncceh
X-HE-Tag: 1777312746-675127
X-HE-Meta: U2FsdGVkX1/GtH5iythZxDmfA0CMwxaaTux9T30+wIRIRvA0eYVaWdwllJSch35TN6Mg7D1d69zKxEplXBCebeYHHIatPBoEQFJq4k9uSD1PGysmC9+z5w46L5S5MMJcFgkEEU2jBx/JyVB3c2qW/KeIcepirt81AVtIMjKq99BFlSxIKNfZgMZcO2wCLeDES62HiIWc0Cc/uDdHpdTKZ1eqmkfpHN90a4Q3CU9DMMY3v83wzBtLo43YAhzxyX0E/WSObtbDzR2DGaFC8FQcqMNTMCIktY50/P/lelY+KDxpZbvChVezHIGOQduEE2YCOhjapZk78dk22oiupIiHwSF2cxeVN69igsv9ZuObtA/S/ibn12Tg7FrXfG16X6QB7wE3ZC3EjJr/JHAdXamDzHbdHhouDvfZO0ypTpBxi7uDQpGjvAOcADNX0aAhH/x2hiVpcl9dnyJUlyeeAC1lG7XBgR2d8GbEBJE2YfoWfruid9xlkWgb03VlS8i3i1Awgc/QY22I3ZuG/TF1uPniCObg7gCwvXRDXQ4rD9WpYcens4po/sQkghArkhySDah6d89dARGfhKnG/IdIkHCM5t1KaCn6N7Cl9jpTJ+45Uets09MT6MGjA7RWbvDt9Sj1m9tH0vE+kPKvGp4TuVy+gbxklH92RplLUIqnNV98jgI5VLfsZhjd/rS1NAJLzgCIxqt5dk6XkI7qYXCm5feAx8Iz0q00qvhPnt3SiJOM5S+8NDnMD2AdWYUn55TAd0lNsV2k6h8lbrfYPFnot/kKGk1OSIcSGQx9gwry6nwu5l/+2PSB4RqVerVYtEnr1IGxUa6E9GdiO2Hvjq5AkzgPxlX5rdPPjp5PlUh+pe0uQ2uUtRvRn9LNqGnG5d/km5mSr1gwjahw9Fsq31TkSm68LdYo3m0V0n/8LR4+6Kjm5peyhm3TbgPqTrWscxtyM0JX/zAPOsVfWKit97lf0PP
 l7YNhVur
 6n+L/YPLk8BUq08+GVRhLMHJdRtJaeoM9ATh/+3/vU+weYpemhNBuwYuMbXt54JtbOLc0x4l/JQOmSkOWGJPx58D+jqrdVpLfSPoIZZWf4rMkkswuXDKr4fkfWhFf1rGxM+pOwkbM0S9CCNT8j86WUSqgqHFsioQyKTeYV1rCV6rnGJ5GthcjaYxxJLE/Pvw9KSAgXCZ3pMtGJga1bZIb8gbf6UBzThz4d+R2UsDURS/7KZtcM/SfOk0LOX1XFb2s1etT7kOSnzVY9GfxrGPvd/HzjWeZFXJEG9Z55opZY93xjBE0pDlZUAKBxlTOatmqH0KsSY2MDjRbTArEgCHP/Z1LmJGcpapsDPFHbnAPC1onD7cvO6PTiB+WfKgJiKtHvmWe+odN+zgcodop7KmXeGVgUdFFXEeOqExTkPIIEaJZ9xjhNz770eoqH4++p46BBYxx/8pyXhf8XaONc73jBo/be3t8c/vBMv2Yk1zMaLIu/V2bRxqXI+X4AYw+3sBqqfuYU4RUEHpdopXb9BbKeSccjunD7RkGLdmSj+DEWycMPr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:13:48PM +0200, Christophe Leroy (CS GROUP) wrote:
> At the time being, x86 and arm64 are missing unsafe_copy_from_user().

No, they don't. They (should) rely on a generic implementation from
linux/uaccess.h, like every other arch, except for  PPC and RISCV.

But they #define arch_unsafe_get_user, and the unsafe_copy_from_user()
becomes undefined conditionally on that.

So please, fix that bug instead of introducing another arch flavor.
We'd always choose generic version, unless there's strong evidence
that arch one is better.  


Thanks,
Yury
 
> Add it.
> 
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> ---
>  arch/x86/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 3a0dd3c2b233..10c458ffa399 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -598,7 +598,7 @@ _label:									\
>   * We want the unsafe accessors to always be inlined and use
>   * the error labels - thus the macro games.
>   */
> -#define unsafe_copy_loop(dst, src, len, type, label)				\
> +#define unsafe_put_loop(dst, src, len, type, label)				\
>  	while (len >= sizeof(type)) {						\
>  		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
>  		dst += sizeof(type);						\
> @@ -611,10 +611,29 @@ do {									\
>  	char __user *__ucu_dst = (_dst);				\
>  	const char *__ucu_src = (_src);					\
>  	size_t __ucu_len = (_len);					\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> -	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> +	unsafe_put_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
> +} while (0)
> +
> +#define unsafe_get_loop(dst, src, len, type, label)				\
> +	while (len >= sizeof(type)) {						\
> +		unsafe_get_user(*(type __user *)(src),(type *)(dst),label);	\
> +		dst += sizeof(type);						\
> +		src += sizeof(type);						\
> +		len -= sizeof(type);						\
> +	}
> +
> +#define unsafe_copy_from_user(_dst,_src,_len,label)			\
> +do {									\
> +	char *__ucu_dst = (_dst);					\
> +	const char __user *__ucu_src = (_src);				\
> +	size_t __ucu_len = (_len);					\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
> +	unsafe_get_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
>  } while (0)
>  
>  #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
> -- 
> 2.49.0
> 


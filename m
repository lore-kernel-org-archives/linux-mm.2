Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C69CEE327
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 16:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20796B0032; Tue, 18 Nov 2025 11:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1676B007B; Tue, 18 Nov 2025 11:15:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71D66B0099; Tue, 18 Nov 2025 11:15:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF9F86B0032
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:15:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7706D13B5BC
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:15:36 +0000 (UTC)
X-FDA: 84124228272.02.2858CC4
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B3221C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:15:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hT3rKNUI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763482533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZOXU78pUNrXsdfF+i/4ssaai+trD/rjhS4AYl482dQ=;
	b=mewa1csnQJa7CwPKEqN5mDqjeIDW8rX5w2HPI+F98ZTXYHv1V2p7ZxMCZrDklKv54S4fSN
	Facd/DgTvJwxaGjitNRgMUX2/LSDTwPcNC33PoC0tI4PhgujIPeDp/JRVSGIrmRlZSLmj1
	lbZlEQhcT++sJomumyfX0QeHprohNUc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763482533; a=rsa-sha256;
	cv=pass;
	b=kL3G5L/DL9S29yvW86cd/6o+9VnbvXna5Jh8TDt2/7B21jIzHjF1/VJKhIYfy6nOEuy81n
	6taHc8L2v6L9eEGB1j/HsoiPRn9A1qVfml1h7IL0P4esqQKvsz8foXg23xTLRwuHoLyOXU
	5baXxk1rZQtHwInuYBVTe4DX6GU+E9I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hT3rKNUI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=laM5dSKrUqwk5kJHv6W7sLIE/EPNE9itexSeQgJLEt4TgE5YOPHlylFa1wRGQ6iss9sdtQ7WDcOJq/gfPYiqGPMIceJ09NbBQPzJ8QxgOJrWrZyhcZBOQ9mYc1Jjvs0xEL5X4UGYdJYci69aZ8MZx9dmVBVMibLbMSHFaOCE8qkubG8eOqFDHgbujb2k4/PxfOS9Y65WvxNWWLGFYWgbzkz8poBUfCw0yTsyaSopv/6KZqYQjdYg697M8S7BaaU903P5JxsODyleqCgKXpU6bvEA78NM9aHy9e0jvkjlEH8rQ4dAqBu0SuNG36N7hSLyvcZnG9W2adGTAUio1FdLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZOXU78pUNrXsdfF+i/4ssaai+trD/rjhS4AYl482dQ=;
 b=LId6mayDNm1EPCQW1dM4HIQNU3IHjZBJRAXJXQPW2iBDsFFWRqmkFpfEoE+JUO79OvD0DIwk68SatCK5smOEU+mnhoaL2ot1d5Qbyp+GlcPd3bu3ZVZWAn1rh9eVmItZuBMsEllDliC2bF92q7J11jepbTRxB9V815iEAncDMW1GhQUbE3EOJwDQneKrV8oafiHLwPQTUGeubuM4bfBi0sHppqC7y+qVxqzyvfi8R3oq6ON/fDyIsyzUutJKrVTbiPXQIsD/ok/2rQwTVXfD6gN7UUWG2u7a7r8PGMaMSQ91Zhy46LiH5yhAqMPPexSjY2vNxn4kPqNHcOOxYw27JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZOXU78pUNrXsdfF+i/4ssaai+trD/rjhS4AYl482dQ=;
 b=hT3rKNUIqsVcJ5N0JUfdIqozVcMoxGx2UMm1a7jVg6aYsdPo2soefsn7uYLczDJWzx9JT77/sZetihWOajg9T2rJnT+UVVSn1Gj2mTmehxQK2Q3WDKcjIzOFnYw+3Jc8fPVxUt1T2HxMQqiO+hCWa3HuTlKDDVNV5OVMrl1JqrskvOjbDP/CR/MmQbQXNB2TYnqvyAwuNvpDQVkbCt+2gdlaeZ4Ei+lrFs4s9mY9h80qjXCa+0HosJAJuB42pBwzHTt9OOTHVWVX2xQlcWyuKx8dIbUcZ+oRK/psWYFQR5nghCU5F+8i7um11uA/6fsAb0crfTpzx84H6kB+1TppTQ==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.22; Tue, 18 Nov 2025 16:15:27 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 16:15:27 +0000
Date: Tue, 18 Nov 2025 12:15:26 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	witu@nvidia.com, hughd@google.com, skhawaja@google.com,
	chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <20251118161526.GD90703@nvidia.com>
References: <aRoi-Pb8jnjaZp0X@kernel.org>
 <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org>
 <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org>
 <20251118140300.GK10864@nvidia.com>
 <aRyLbB8yoQwUJ3dh@kernel.org>
 <CA+CK2bBFtG3LWmCtLs-5vfS8FYm_r24v=jJra9gOGPKKcs=55g@mail.gmail.com>
 <20251118153631.GB90703@nvidia.com>
 <CA+CK2bC6sZe1qYd4=KjqDY-eUb95RBPK-Us+-PZbvkrVsvS5Cw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bC6sZe1qYd4=KjqDY-eUb95RBPK-Us+-PZbvkrVsvS5Cw@mail.gmail.com>
X-ClientProxiedBy: MN0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:52c::6) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b1a598-9470-46b4-8966-08de26bdaf77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fUoc77QTa8KQvk+VCgqLpBdeBCpLn/OO5pXB3Jnl/1MNB82Qv1FsYYiwa6ax?=
 =?us-ascii?Q?klez9Zmk9dRbMV3udMQnnfrV9tZ59bvd4UicYlBedtNRaVgygIdHfBsKPsBp?=
 =?us-ascii?Q?oL4WM0K8id4L2qU+ubgcUZFbipexufe9hbQrlcdLOK2cQUUJHWXieHZbOdqX?=
 =?us-ascii?Q?Fs8VMJaLe75f+XysVPBS8HE8U6qLcFMd7rBuk+jZN7GpUZDsvYJnjCGw8HJ4?=
 =?us-ascii?Q?48jQ7EwJCRtPw4IaaUh9XSW0q7wxfcZNKTG3p67mR8ZHgty089RD5D//pyj3?=
 =?us-ascii?Q?qpWp4sKjUmv2N3zq0SyrSK7JKQQCUG+WY9Lfc+JBWVmXDjB9CqSrx/ZGb8ag?=
 =?us-ascii?Q?NZOSmeJyB2JCkNDXGWnRTPjR1a2ovtr5RZ2jCj9i8MKqGgTaesPCWcRbqYz3?=
 =?us-ascii?Q?2m/14xXzYAnyqaRCHAAKAFloUjP6S8f/t2QfseUUWqbBVLPyQQdQ/Oqjb6vX?=
 =?us-ascii?Q?qchBbEWNW7nqR3mymhNxUFZ6H5oiaie5jT6FOHPL01jJeWQerTjUeRzkD7nQ?=
 =?us-ascii?Q?Ou9pthIitfV8putNqMTesH6yIFMzf9djy1tllvdaTsi0frXamLOpxUSAEZxE?=
 =?us-ascii?Q?f7TmDwHbPp5Ucku07Cv1i/8nML4f/bcXtILjwGIBgbjjdED3yEhcngT8TkG3?=
 =?us-ascii?Q?iIZfPYxPBqpXbXKFyaX1L7KOeRFmrDGDsxVCeX7JTMH/DzIN4b/HAFn7es7O?=
 =?us-ascii?Q?HW6sEty2q4Sqn9JgcvNAbEXHS5FXgoMqI6gVKnDSkZes57CuIFJd+Ji4g/h5?=
 =?us-ascii?Q?cxQgp05O/XpUsT6sYoulqjrUuTStui66+bO/vrkXeCMdWCt0E8lSXn1yi0DB?=
 =?us-ascii?Q?+23/xA1N55NMlFN8Ld7keizvtyXa0ksaOyrWkSjPHOESOESRDbgNZg5oqFJu?=
 =?us-ascii?Q?ekXRlI1M0lkX/HoOxGnrfo+isxQIRDFw4bS+1Gk3EWN/cKlM5cP+9ND2Vh8a?=
 =?us-ascii?Q?fdZVwaOpQW/1guPHGr1uvLZ58oWBDZF9HO7olMCFT/NuFjBEypPHkydu8Vjk?=
 =?us-ascii?Q?qpc0btlvk5QtoxXLboOA9I4Rqobd0n3ulOidT5MMjU2PSx9ddXoOQkjs2R2o?=
 =?us-ascii?Q?8jCBeB1xBFkeAXqmIOWmTiJGcrGd9wfN8OHccmJKXFQ25n0VMKAEbls447ad?=
 =?us-ascii?Q?8FhfBcajUTup7WAFrHCEE9tWdB2EVi2vgkMiAujUpkqOWSnbYAbeoA1JHVq/?=
 =?us-ascii?Q?D68CugR5qnBmT8Y9j+BrfXH0JFjSU/PF3AKv7/iPlXxzh2K3FXQ1tk7Qpxo2?=
 =?us-ascii?Q?Cp+6M9/k9uAEvP2ZmhEkZU+E3C6iC+axOOhSiYEvp9xa+u49Ie2j8UU1NMvR?=
 =?us-ascii?Q?C+q8wFFrmJ+f2orkIhp8LX0GQIssgt0kuJiLgP4zW+p559mLrmhp0FJ9my6K?=
 =?us-ascii?Q?HD8AH4uYy2h4kLP2x0a5COf/ZecXP4vq9f1g70jV+OuAUP9komg2k4GT185q?=
 =?us-ascii?Q?8bR6khwiCp4cpyTxAuzA1i1QTWN5AMvT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HXETKLIktKEW4ITcVJrOUThQzULT8dmngkuMknxxd0g+aTlfeJj7nakNcU5T?=
 =?us-ascii?Q?4M458wOHzUEAFFlo8kjfbVyC1O8oqOqvj9EmhrbFC6POwWqJK1D8V2IEcmAz?=
 =?us-ascii?Q?EHJWYovhKuZhP66McqUZhYfTKKuLdX1I9kiBYxtQGO1/DL+DiWt+n2u+7jgx?=
 =?us-ascii?Q?ebLsMZoCfRH1RXAjFK8GDuNBxO/fDm5qg52QuiB1bulmVfXYz0x0N9BEE8RV?=
 =?us-ascii?Q?uI4hoEMBQPVyM19Oha6MvW1H/9oiSOYWTru3zzUlfAmnq+thpQmefqjEB7eM?=
 =?us-ascii?Q?ohpHlwI4Vdgh1DnbxzNfoQTFmSg83ODkCn78JDTaNMi8nZ9Pg5gXdE8oVEXj?=
 =?us-ascii?Q?k/1GDjqrKRX8y30OIIbRPV/xscbGXm92pMRrNVmO1IF3YfCPlGpzymxsLHIE?=
 =?us-ascii?Q?e9RyH5QY8U2tNmVxUNBUNB2/H23toI8CU5jy71mGoD/7MQxs/bBqmDhvIx1h?=
 =?us-ascii?Q?z4Gv/lQhI6tRsd3cNzrejADAr6bRZs1g4NJ0tw8BM4brj4NYCc9HPyLI/nRI?=
 =?us-ascii?Q?9OvgR2q6oPxf0mx60wnNJ5RmGUI6RJiLqS2nzMostVR919E1AM1QyCNHBRW5?=
 =?us-ascii?Q?+DykF3jaypqK3PWPcANVtytUpXzahslOfFy6fvtSEcJxZ+JqHjW4yLT1CJ9i?=
 =?us-ascii?Q?Pchz4s070nBbMwnKIIU2PafnsfVQhNI07F7P0M7qA1qwRiUawAwn4bdfgjh4?=
 =?us-ascii?Q?tMgEqrts464aO4xeA46kfzKPVXbeLVIIqD0+6GpV68n9+sfIPXWdRilScky+?=
 =?us-ascii?Q?wm6LbRZQS84zkH4m1YDZrfPdIVweltUT/fi4OPuBWqC74375OMjKyJnbhuCY?=
 =?us-ascii?Q?2s0XsdVNvQTGf9hL0O7RBn96s35r/a2mANxZ08AO/53f9JbyZi9WXy68VIKg?=
 =?us-ascii?Q?Dxbvy7U1JpRhRz4ZHtgpBWmUDh5L9nz0KeJHSnupynVhAGCDHV110Ag6XK95?=
 =?us-ascii?Q?pG5kVVVfNSd4XU5T5wTm1xRvvgrN4MOKqK7YYL254U7XqrxqGZAkkKfp6Ixf?=
 =?us-ascii?Q?4nl3VkmkiUjMKbqEcGLRZIEy63mn0U9cKkZX8JqQDjNEpouS9f9DAjOv+c9c?=
 =?us-ascii?Q?w0ieXEJgjrHsmDeZ5AR32SftaR025IhBwju0rbPXlUgKSG8F7GT1fB/ULeB+?=
 =?us-ascii?Q?dr1XUbKoIMpww3WhPiH+duayFgoMEdr1a2Eb3xjnAVijJWnldJyYt9MzNerB?=
 =?us-ascii?Q?UQBUdb7GgOV4d0UR6y52CtpjMrXYXnXJtIDKeG37dhO/j19ymiwxVm68v4eg?=
 =?us-ascii?Q?YUhSGI/vSUoR5J4RaVKzYcJCAbY17CfK9it6Ocov0nXkxY6I8MR596Bp9vmM?=
 =?us-ascii?Q?27VL3sEXserqBvblSoEH8cP7yop8YIs0xMnVfJdflkXdq9Pn3UW9qQGqmnLR?=
 =?us-ascii?Q?YJHjKmyA6yuDM83uqTW7WACXiWMrbJIyM38MCvdZ0dy1M6yFLr3a2d8vO18k?=
 =?us-ascii?Q?jLsbSTTQ4NbpAL/7B8+RUwRWAnj/hZjOxR9kRGw9afMyADmx4MCVU0UsGvmK?=
 =?us-ascii?Q?4HjCRZCrLbrEhe135fz1LEG796xX2yOlHRp3iE1R1M7v1P218wBvMbSA+Mtr?=
 =?us-ascii?Q?unNjIeZel5BMG+3VZxY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b1a598-9470-46b4-8966-08de26bdaf77
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 16:15:26.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1BPQAXQHyOthhRZz1XwT8uX8h7Qw6yDn/RuEY/ml4na7r+MeneDPz3xHDZBMdBr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543
X-Stat-Signature: inzr6fkzeb117mu1ae5zkpboeife8scu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B3221C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763482533-786048
X-HE-Meta: U2FsdGVkX1/juEOwzPL3yzwgH8iquCsX32QHclyd7KKq2kCNEfnp2VPlP/nizdrRuRvqVv0EU1ubxZDPYH03jB46TL1+CoTBgOCIlm9Coz9UYn0MD4kQZaHD72zLwXnlJNEc8uj9ExSZqdQY963psK2LHKL9oLGzh8lyAv4Aq6hvBmlO4TpaUwPOeT9fyyuw46Y5HDykcH7iu0psFE8SsEEin6danLV8VDHK4qX6WUYUgLm91qdYC9VgOmHZdVOQ/94lt6eC20O3wg7Il7grXs8H9ZQLEGbn/CMumTCEHbhqMK/SbbosCcTTJHogM1yDx09ar8gRRHGWilnEFSgECz9xN0CrL6WFa93I1bWOCNAlVBNrS5CWf/+SQgDHSB09j7FjjAFb4Ufxi5GDHqC1plCqvgHQ0i2esRpH0qSRziFqCS72ZvQU2WjcWaYRHIM3cvxxhFowWxVtrSA+drTOkH1Anoxll4cAirn3WX2PWuSMjgCVbPVHXRuyQiky0Z93YObWgdZD52OHlqDlzuiM2/EJINDsQJinp4Br0xjjIYrMaoP0SrvhMn/3fQcwEN0qio25yWJ9MBnYHIbCfh0aNjrt6RYhwA9uNTtd7jqd8KRosw1vcSEhQ+2hcttPWISfrw3vKU3HGYUAe89vJ8OEfCi13IeQYWCYbiJCk5h5sjrKbSbDIvK7v/OMH2vu6Egndpa/jb0D+qt8YYVw6K/rr4EtCOeaRnIqM8GKPTDKx9YP7tm9zrzWjVFVhU43pHarYD4y0szc5KeUpb2x701ZSLK04jHKfuV1UuD2B4hv/b+oFAPMb462Os4d25O6a1HoB7qau0czgVQOQZAlvQTiZmmnm6j6dF5vwiKFslc36XNM1zfaNUh6aZNBqxQBPof0jEIKBYkPqijgiPJxWKtLHbgbHFJ0Q39G57yydV50NJ4XopCYT7EIyI1M8Ptq5lzM1y7sCoS6ryGnifzYuxq
 2e38OXfO
 EIwtsOoOJ3cXZ+IzTi1/wguYo6noRmu/OwDqpTLZd9CAHDGxtUz3Y70PN1JvPAjA7982RVZj8MAD0uJ/F7VPwMCzuad2JpGWlsHY4FSX28gZF9PvWTgG0s6V7zYZyt/cFJY2stXPskQIH/f0ghtRcM4n0wgiDPY6tgWvCTxhrsToFRUd22Qn22Wc2DfuobjQ6ypX15zvpQquzWWYmNKPgWKvqeZQJ36VpHSZ6ClgFketOJPdKYt6KqDAHB63+kuxkvLvmgz7hpYD13FONyM8waOPfghS0NvsQiqp72DOWwhYnMDnqEzxDjZDkSXD+wmSZXXVlTWzqKv/E/qOQWhJk2aJMDpekF8dOCPb3GCpt3wxxPpDaXI9+CbW13Oita316IAJop8cgHiuf4+v3nDhqDdQtDPSUHr18IMgG8H3dYHQ3TlH+I3sl+0qzNAR4q9NMGjKKrZt7wIddeseJkrwd3hVixDKuMJRVX6uDdAyoHpXXQjOdYF53vzLTgR5f460eJuuXEij+N53m/X0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:46:35AM -0500, Pasha Tatashin wrote:
> > > This won't leak data, as /dev/liveupdate is completely disabled, so
> > > nothing preserved in memory will be recoverable.
> >
> > This seems reasonable, but it is still dangerous.
> >
> > At the minimum the KHO startup either needs to succeed, panic, or fail
> > to online most of the memory (ie run from the safe region only)
> 
> Allowing degrade booting using only scratch memory sounds like a very
> good compromise. This allows the live-update boot to stay alive as a
> sort of "crash kernel," particularly since kdump functionality is not
> available here. However, it would require some work in KHO to enable
> such a feature.
> 
> > The above approach works better for things like VFIO or memfd where
> > you can boot significantly safely. Not sure about iommu though, if
> > iommu doesn't deserialize properly then it probably corrupts all
> > memory too.
> 
> Yes, DMA may corrupt memory if KHO is broken, *but* we are discussing
> broken LUO recovering, the KHO preserved memory should still stay as
> preserved but unretriable, so DMA activity should only happen to those
> regions...

If the iommu is not preserved then normal iommu boot will possibly set
the translation the identiy and it will scribble over random memory.

You can't rely on the translation being present and only reaching kho
preserved memroy if the iommu can't restore itself.

Jason


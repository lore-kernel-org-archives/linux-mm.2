Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B877D0D163
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2666B0093; Wed,  7 Jan 2026 13:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76666B0095; Wed,  7 Jan 2026 13:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A272A6B0096; Wed,  7 Jan 2026 13:55:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 914386B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:55:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37029160486
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:55:03 +0000 (UTC)
X-FDA: 84306070086.22.3A0EEF2
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75E4CC0007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:55:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PS8sjblm;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.39 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767812100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6L3QvaDzkxifxCtAms08ALjicfkDe8Q0xYJH4wy0ys=;
	b=7Os9oaCARsm6ICyrB3aTthu+ylYuldXGPuXwN8633xnN4sChKCNhO6eUotCxTkl/dq8W+E
	ViiJqrYtNDu8iAkLTYD7cPFLyUEGeMINNOFplnkkS+9cSqm+RmSocqnRM5PVd09H7HbKc+
	5jenYJGYXzOrIKC9WjVouWuSN/8aWdk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PS8sjblm;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.39 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767812100; a=rsa-sha256;
	cv=pass;
	b=ClZkzmD23IEHmLXKwiovlgbR6SWva2fz6lftswBOaN8HNtYpPIQok1upyw9aBRXtxSVNxE
	8v2FFcOghi6elRC2Py2jepWFq28JrjxLDM7m+oPi8qFuY+vrmwdh+ujBJ5R5/cH/mT53iR
	OzQL6XYgOfxRZGwoo2ACcDxL5fd2V6M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zaz+72AbJEnkpN9w9gdA/3yZ1tzSbUpNyzKjNq6CpLBUK+wWB2t416Z27twgu00B2n/Jw60oweQBk9J/tdMoZdWKZ6OPqqUaqP/on1hpDmplDrtkTEv6ZP+DiueEHMQCGrAQjBCszz1CXiqPiXkbdpbPxwvWv+zNwXyUMRoYKF5GZVk9zkFXXFDI57f1qc8rLAg/tSNewVBZmW9gRiDm0WrxTXJY9KaRxCXLAYgx3pS5LfCMtvhAfWP/su819WmVnq/b5OS7dWwEC3qhnKGgLlqW+x4CHIhtbYhhcwLg3HuQ/EeybM8XMJ+qDyLMKERu1uYXSOtuVumTtfuXLFSeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6L3QvaDzkxifxCtAms08ALjicfkDe8Q0xYJH4wy0ys=;
 b=Szm/K/lgDO0NePQUYKz/41r7R9gj8QKIUWvNyH4r80qmtX1DWmZz1Thw0pecyfDW64ln6EjG5Wm6XevXLoNkrI0GW0Z8pLX/5NseJ8o5N7TOEm8PZuZrygg7RNpZnSrp+0sOPtUdxUT+fZXmCqolbZkF/Aa6YKEn8kwsvNYCTa/5CRTnUXD7T/DTXV340kYJSrqM8n7Ma08l+ln443ugFBJzZ5Cv4n1b7aRIMaOPzzPrHy6G7z+f/2g9cUhnQ2Zd6jiMxdlsKOq1ixE9axWRuMsEJggtu019DQA02s3seQqfRWZPDg96hMVQgEhavbVMttPkj4+TLShQeRIJpGov9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6L3QvaDzkxifxCtAms08ALjicfkDe8Q0xYJH4wy0ys=;
 b=PS8sjblmp5LPfweDIGDuFuaV7LqzqXZlQpgud6bIsUweJ9sONzmtw9k35ZbASjf0U7F+gfq5E3AlJ6vsWszNtHWJPLolkZ/c6K/eqmh1BVJZT5pGoj6A5aQBC4+LTL5lQPKjkxn2NUEHxDeO9THum/3P+lOhyrjVpfyOb7FwTf1PFbIzJDXRVeSB7yXErdi6GaM+GvVNfHcROKg/XVqxwrywk8KHj2LM/EcWSlUupkabXWW9W0kqB9R9VXOlNxZrAdMZv7WzVlJD3o7xtaPZAk4SsddSWQHKGbSCtCZ0Y+r8f0nwJWaCltY4U2STc+feGiP8QGWFHSE1Xs0yaJHdXw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:54:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:54:55 +0000
Date: Wed, 7 Jan 2026 14:54:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
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
Subject: Re: [PATCH v8 00/18] Live Update Orchestrator
Message-ID: <20260107185454.GH293394@nvidia.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 63be3ad9-2476-41a4-41d1-08de4e1e3f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oFuTuRjp6i2EfW5vB7bhzX/wZLBBshNTll+8RDiu1Ts8xTyOIrCQnjUxSZqs?=
 =?us-ascii?Q?jpvtxAaqzZN/dx9il92gjy9tdxtxV36aboAvFTE7FA/diVWBtWVyDTnWn6mp?=
 =?us-ascii?Q?WqAfwfvXRBI/JQEzrryqoQmIkvKMSwmTmxx80vE7lZW6PgEfgcmgffxnCH5K?=
 =?us-ascii?Q?1KrRxqaIKIbr/0IeIyt5zLpdOYqpTTNRn9f6bRoBhHCfpAS6esD9e4H2a/yL?=
 =?us-ascii?Q?Ldp6DTvE169MF/pxGHmLNpi7/qA5gLNf0ezEQfuKc9MkLyaAMZbddK4emfc9?=
 =?us-ascii?Q?6o2dBZK+Lre9/lQQ+Ki/p6DppHphLBW4bqBRBK+yLKT/19b2XGm05IRbt9BK?=
 =?us-ascii?Q?+tbHzrcwgi4J3Zz/jdB8JyqW9ys5Zfx3UpD82LowCmJ2wNevzd3mKdYrKAF+?=
 =?us-ascii?Q?dd+QhjMdJLT8k1Nq4qSI/W3gy1PG+dJJA+6ekv3F2rmqUu4gmuEzyGIRtzzg?=
 =?us-ascii?Q?enbHgbVwgmlvnfpnEgetjuYDh6AiN8BoloCbmoDL/p97cODBY6g20LahimeZ?=
 =?us-ascii?Q?UFZW1Drs+W3sjssdXN6mFQoGkN2M7lKaJA1ebmscofiO7drIujrMwmnaEikc?=
 =?us-ascii?Q?3Fu2QykbcR5Iaw+K5mrEf8qYuHgnqamg5pVot5LStfEOJuW65gWT1JrvToJc?=
 =?us-ascii?Q?OyaTrb++QkkJsCiL5pdfjOrAlXZlmWXBScXse34UGBouqJPlG3aWYUygicWj?=
 =?us-ascii?Q?kPnIgI4F5dvmjR5KEIyaYmzUFLkiUf8noGtpAB7O+IqqwP0pVbAUgEv3Lwm0?=
 =?us-ascii?Q?va0yUXXz72gxws7lbqAGo6nLW0uNbmLSwal4QfvUFehTURTkTGJAMEjAMx5T?=
 =?us-ascii?Q?nU78y8FG5PrNJw5ASv1V1EvgGxVW1Rx2SSYvJ3HUeFaE6Wo24kJFapiMsUNZ?=
 =?us-ascii?Q?7mrmyxCzesAZYukQBBDCpMMOi/JvokFeqC6gkR5vF1UDmzNwuNnuLWTctU5r?=
 =?us-ascii?Q?6PJpz54jQZdsnNKaH0b1+1JtW3q2um4mSCPm9uQf9m8vdn9Dc/61wfUYM5Mj?=
 =?us-ascii?Q?K8xD/2wgrHB3TJgqaNt5Nyls6cOpmmnyVcGIFacqYJLQfnpasPVKyIlvW8Z3?=
 =?us-ascii?Q?Whvc0QHALAdqV4btaGptRjBoHHPsDjaoM8dM4xd7ZMzHBNz8sOeMLtwLvn4+?=
 =?us-ascii?Q?s5xmdCsjlWsbdqOhHlaUwS60OL5U4VSysBhLNn+bz0VQMspoB9hn+7eEokYF?=
 =?us-ascii?Q?h/lpGj9GTNv/j2+esoX7MJO1GkSX4lUgeodhKj/m5EeKtZdYvUfaqJwLNiDX?=
 =?us-ascii?Q?eUuKHhRoR+3N6C8BnJRE9TVlwd1vYc0QFuEMr6lXBsnta+dUVf0X0NyBTD9P?=
 =?us-ascii?Q?6x+CzVBbYnWKKRsvOADrjv+KEWn6yeez5qi1inr22DAFwuHi8NyLn428V5fw?=
 =?us-ascii?Q?+3NWjovAExQDu6XrrVvvLT/ZD6ttDGhhKbBlepC2RJhXBcWEd9YnLARQIk2u?=
 =?us-ascii?Q?FkcZnhqko2TM+WsT08EJ49lsbpZwmsgN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cdLE8nmCEyynsJ4/7t1kL1JeltnL0gmbSHWf+l3ET6pz1j+bhUaiMJ+pS86S?=
 =?us-ascii?Q?8/H8wYYPtVbNzv1/YJGYpLCzJTprniiXrk2FhrNQVoVURaqcag4qY8UnIMbi?=
 =?us-ascii?Q?QaW0PTkVymoaqLq0ZD//MAnjrqbXddxuL+oRsQ5cxCYpZTZhC23JyyWW6hi2?=
 =?us-ascii?Q?qSO8ek1X4zKyIknN3m4ad4+B3Z/ihng1pTfwGr3fy+5aGGf+E3nH/ZEuoi4K?=
 =?us-ascii?Q?giv2FmHgPVj2i3koHoK2jTrRMPt240Juw+YOqrvzo9QDPamoo3B9omNhORYm?=
 =?us-ascii?Q?10WQvbRF8HOoQPcvMJWXY6J2zS/OSrVEtVkBulI2w19/rnQOQQU6/LrQmq20?=
 =?us-ascii?Q?mHyvehMuCa3INqS+e/cJbsrqglNCo2qsgVBcpLiXmv2b6PDBeHn2BX37IitL?=
 =?us-ascii?Q?BLw+05ThfoTqV4twajW8JEJsap4D6hlb8aufva2w3GjYnM/RtCnsF176ZK+b?=
 =?us-ascii?Q?PZuSK7LydTbCJr8rppNGB9i2+kxyoIkB+w5ckTag/DoYrB0s2w5s4PoRebLR?=
 =?us-ascii?Q?NyisLtM7I604v7SYY7dwIfC9z7+20kSg/ofgxkX0KbNWzCZEF+uSljofUcBp?=
 =?us-ascii?Q?csLxYD+f5fBiShUCsfv+K9CrXVsQj0Go7GC6rJvB93at7jwCdUnv5VhLzM5e?=
 =?us-ascii?Q?sas6kevGTAgBpwGSBQJtMHYnsHVWEmoCgLF2FgHXGuL+SfdkGsbP+zujnqpc?=
 =?us-ascii?Q?r6G7DRwFradlqNc5uRhR+S/kIe2UiZnQm6FwSPpdCHK5+pvA1tx1IOTg+M+3?=
 =?us-ascii?Q?yTfgrAo1NwCX4FVtc8VNl9Uysn7gGWycb3InQM5p9ELIW5G0kyDmxOb1EwFG?=
 =?us-ascii?Q?4wcIL58vI1oGp+4oo68ANeAJHQ6bIp8ObFZ9qJKmgFLyVqZpqrpl4XJdRr20?=
 =?us-ascii?Q?MEV3EVKRV1lcmXilyum7VsrbM8rSN/Tw9ewQScW8/AyqjG6AUuAM9+0nxe5z?=
 =?us-ascii?Q?hbHygvMtQdIeSzJLnpvPKpEj4NQM5zy55trMUiqijv00h90Sj/lUGz5HWOgu?=
 =?us-ascii?Q?R9wRupARjV+qcKWT0G4JZNUtG/jeFCEOxH2DQ5OIL6u6PPXbJBtJj4zOtFlH?=
 =?us-ascii?Q?JGIYz0Pend2tELeLF28eD9B781gNaKKm0/DzUghm7aAsFNecsNq+1InF78Lt?=
 =?us-ascii?Q?vup2w+fkEIEhOg+SD7U4dsX0c8G/mGlbfUNaCz09oSJgyPNOLBsnjesP24eg?=
 =?us-ascii?Q?sn/WL+Pix/NsYiWGNkmeeWfaHHEOYzyQ/hHgERvv84Gcats52Yn3MAnfJUMh?=
 =?us-ascii?Q?WEdu4jO5IkBo5LSUEt4m/ii64Tzozlad94vrzOcZBgzI7+oB8r2biwOFQI+b?=
 =?us-ascii?Q?h6909lyRv9KpARQFfJDMCQ//qr6X3/tr0qT04VSRkrhHKSEVXfCalh+lgj6T?=
 =?us-ascii?Q?xz2WVtHXeV7uxMo1DvZsfDls63ltVCaa5ElSwS8XXNSi9lEaq8XCSy0VavpK?=
 =?us-ascii?Q?qnc7MbakPzumN3E4IJrsTdhk27V+2zaB4zGac+ZBypJjdO32S7/lyxTvGHZ2?=
 =?us-ascii?Q?0XyWHRDscp+oypRmHq2xeEmiE0SxEEWJLSJTbEtN6c5NfMscZxPiXmEYU3ax?=
 =?us-ascii?Q?Aw5xNpJUTpJH1LJR8VMdSVXI5Dy6rIr3fwAvZruH4ZbF1HzVqbltgi5UB3dD?=
 =?us-ascii?Q?dvRS54OsV2o2n8OZDEbBMPpTZ2PXo00g+HmVHStyzxSS3mtz16jJ1X7dBHPm?=
 =?us-ascii?Q?KDrGqLao/Havo4uhI3Z+Mns7gRv11c+uWVjI2kyedicLZn9Jj74C3QMNmfQk?=
 =?us-ascii?Q?qyLYLITEuw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63be3ad9-2476-41a4-41d1-08de4e1e3f5b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:54:55.4377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJcG4XHg70YXR32AO0mCJsmbz6YzAniSDLUuE/J73+BGDrO5101NRIGn3ob5qTv1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75E4CC0007
X-Stat-Signature: oz1myu1wwkei7hrqawgj7gfkdi5iwfj9
X-HE-Tag: 1767812100-310290
X-HE-Meta: U2FsdGVkX1+nXfGvLdLg3rGpiKJfpzQ4hPwUNexYsAWnHUtlK0hyrya7sRijX6klMdhwX5b/fLBjNkhQFfDK2floYkV270AHgIcFNdpsTsgpsu+qt0OxXbBl0zpBgoLc9tfd3s81zGILC5QcaOzUMGAll1lRJKksfodcCX9cOv9eOErkOxPMnI2g3m9c8++iIEJWHTspWwJgMxbwKYTMgTW9QSHnOPJAtCl2VjR2HlrI+TZyHztazfY4zP3NS64u9+MTXROLLXt1pT262Bf2FNufnj1K8UYnh82uNjb/tsgW1MJ+k2Ts3ajTzmNYHJXBtsEv8LBl+9sqrBxgzR7AqUkPQxWgvZCtmHy/7OYlsRTnz0JRqmC0vipH/kq1vb2cxSJZ1IoA3FiDh7bpSoBssQda/zUE2LDfO77xW2cMDsi2Spxbrh2tUSzQOUHkEZy5FiT0DuWMQKlyvHFakyUKBzRkNJjM1oyM7zwL+RqMQXK37qXnjsFZRkRHL1X6FER/7+I25y2I9Y94sCaeZwhHtBSuvMDj3tBgu6+h/PjOB0neDZEfjAzraEyctbCwprryntofSeejV4Dhh2vxXDTjsvMEUeSUdA84DeqcVGBlA2GRVBhScCuZ4SaJOb95x/Zf334ke74B5kVKReb3gpIjaitW5OACXkaGIe5hCJQdkueD/ptxOVieeuaiLVH3zm1VNZPD4enTg8Tgn7yhYiCr9dyc/FAG8K355Ni9rorPR+fxb+kdLuURg9A0+/LqSt06B1uBWJsQDyPJY0tYLUTtHMPWWeXFUdhMcMZllmlunbsQfvurul7brp1zc+6kevZEC8eVVdxN75ikHibLlIpA3wrEaIeRlgl4sSIuppr5HrpWAps8jNkwl+MzeEKziaShHcdvmFTRpTAR4A1B8GzYkt2WDOAazrCucdsWbtqqUgrD050nHRpTIDRfZH5qtogm9fshht8qgLf8xnjqhNA
 CV4xczl+
 7/M6DVshEZOyFNlCP/XOpxMrCW1gm7yMoBRWjlaeYtRj0iNRosoSO1IafVrBsgZ5Gt9+nvTkud+YmJjMhvuLquPBD6G8VHOpmDC6EHcFi2fbO4B3RW8IFagB+BiO9l6D+LUWkL5UBOHYCOVj7o0PVuwyqoZhb2t6bjiiun5JOk028gXP9egVcRIg3n1pEGVFwdI2M+ysuj7AnENTuerrfMui/YTnVEfpzY4hoUFwZqE3pxCsqNYMsIfm//M3QPDOjIGxgt/tzzjOvar+aTz5Pu/pd2rn2dmQ5cOxWaGXS0TRQ7FeoWa3GVz7dHvD06xYEfgEdp+scxqN68aIMAFRzAjQxeSa8LMqDpEO52NjLhTzOjDdT7zYKbYWTOuxxxxvEQjpo8gHNHdrLJl2JFbbJfF4/DIBgphBEKnhlSBKkoLQH6kH35z2q6lBCxP6PntTUnHQNZ99og5HRLpNmHIZw3fodhM+lIIGn0oN/0vgoRlvvWaTjOG0oRnVHsiLUJUk4eV6D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:58:30AM -0500, Pasha Tatashin wrote:
> Andrew: This series has been fully reviewed, and contains minimal
> changes compared to what is currently being tested in linux-next
> diff between v7 and v8 can be viewe, here: [8]

I didn't closely audit everything, but the overal design and operation
looks right to me:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


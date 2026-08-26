Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CD5C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DE76B008C; Wed, 26 Aug 2026 14:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DF26B0092; Wed, 26 Aug 2026 14:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218246B0095; Wed, 26 Aug 2026 14:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E06F96B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:31:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DAB61C0BC8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:31:27 +0000 (UTC)
X-FDA: 85144263414.29.172EB9F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AA51A0017
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:31:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="G5IWy0D/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787769084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUtHTUNT4n74YnLR960uHy5yHY5DHGaW2iEBGhm8SA4=;
	b=Hi9L9YZKBt7Wu51HyCGEjP8cNoF4/FilXr2R9/srnCRZUBbgTOEq0X+b1uZFqXXwRsrhT3
	4XFqTCUN/Mnz+O+ynS/7iF0N45Y4WTszNZYNk4xZwKMWntg32Hd4gZya/RqOFsydz2ugx6
	LkIRX+SkmxKbJ8WS/if192Jot5nkx1g=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="G5IWy0D/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787769084;
	b=27x+t6ndiL3OiIIUa57u3iXC52I/CctG/dLUEuhTt8D22R/yabHK6rOSPXenMwRB2VlOtT
	ucZ8jxp2/FUe23Ak4HKXTc3h2KdqmuMBTngdstLKEiGza2giP9+ADSBrsC3pT9ew8sT6em
	JfPDqtjTk+Hk8OxeUnLvPCEa7eyYTQ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C91f1XtTbMgfnyK7XOXCdnwk5kHci7TCK3NO4tmg/gyykXSghcAmS5fgUAbdUVXrDhBPheWfWUaeuNlEMgD3n2EVyd3b7s6VUZZ1n6c4pz3TG+6BEE2YcPXkgbIIjx48oCBx4/fnR82c4CiuRBfxxzD+qjXQRpNgV2PkvUJ+/YljEOdiOeZWcHFgF7tSSoGR9OEurnrrc5dqq/SEI7fp2r0z1G4NfabWCzkBDcqaF5HJgb0p0eAhTieh5u24HTl59C7vloVsYZpgm6MAV+jFTbe9xsH5fmu2e3Q/41FvDltwqmEzhuwxehLjIRMn8t+Qm/m0KWMBsURzKsTo1LDbxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cUtHTUNT4n74YnLR960uHy5yHY5DHGaW2iEBGhm8SA4=;
 b=ym+2b+JmjU4Xzt4iXsWoo14LuJju5dIGa2i+uFBPgchx7oJe6wOH9Ld1oVuMMkZiRBacH8Xi9yCnfYdkXugasHMK4RoUCwkzDJZa2Wd39sfs0WmAdyizOPLSUrp0KUxJQaeypdzkeN/hLyN+fxVcqLNTR8HUfe//lavqDoci8Ojs2ODqp6r2cJ476/WhgKDeosQVNGDL/UE7xMiG+nW6OVG/C1eDyYjJfyA7Iu5gdv2CymJ29q4W2PNpm57QJ0/xtnHig9Y8Hs3TXFqCdwFBVJrrWEyxClp6GNCdj0F92A6zUcPp5X76BoHaRIA6RVUtCLJEcvnrESiAj1kT/S0Qhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUtHTUNT4n74YnLR960uHy5yHY5DHGaW2iEBGhm8SA4=;
 b=G5IWy0D/NdCNVoZoD5i8Xb8XZCevSKCi6yGGidslJt7NhNgx7IJ7SsOgsxqGPf9GE0UKPpPGLz4ZVREXepjpMrCF6ljeqP6jjNhWp0TQttevoZRrOvcvXHIrKiBeDOUj39gZSXOYCLW+9RL+8yEFJuTA927SqabjwwqR5BQpLBFoUcHMOAwQRQD30GNmWU94JrW4/IPISP9b9kyVK5cFwHFDvcDOTUs1OKa+aYEVBj/qiATApYleGX2yhxhIapBDzZmR52uqDgD/aV38rjcVDEF6juFTRxSOSUyIh8SDCO20N1zXM1/L8FOi8Dq2BbwqrrwVc0BrMoFmVrPIFc/0mg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7853.namprd12.prod.outlook.com (2603:10b6:806:348::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 18:31:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 18:31:14 +0000
Date: Wed, 26 Aug 2026 15:31:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Will Deacon <will@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pranjal Shrivastava <praan@google.com>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH v2 00/10] dma-mapping: Add preservation of direct
 allocations
Message-ID: <20260826183112.GA3703145@nvidia.com>
References: <20260708234854.4044652-1-skhawaja@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
X-ClientProxiedBy: YT4PR01CA0199.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7853:EE_
X-MS-Office365-Filtering-Correlation-Id: fa7c5df9-a87a-440c-0098-08df03a035a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	U1xRiz0saDyqo8KSK0KxIwer3u5WPg+no3TCTTYu+w4jMgPlm+j/snLvHLg+bf60z/DkTLhAX0H+ivihaJc3kklK6mfWd61uw6bvnGacIQmjJh0nE9RC+TpAR4giYdNbMxl/MkKBskBdm1BVDX8TICn4xPqLqOi0m7g1MJUMnat1UZnthq6B/iRPerukdfWj7PwAJupMJyTFf2jS1i6olwi83CP74OO0YmOQOwFZ9Iy5FZ7Z6v596Gs+zUJFao5z2tZy99MGA3ghvMrH15AnqAIjDOT1TsYcwSza+6Pub3gyOCtWmSRK9hgWKbb9Q2KqbGtHZkIBwDnEoyPWEDjLw+VOU0mg+1KAvuiwtWavQ2wEU3E0DH5vKU5qFYdbehUjJjioC6RT6SwAEIy6qKqSOgF0Geo04twV7ua19p8lcGdb+cH7k5dxJ7s1XmB9PzvePRqFOQYMdUoonMnDbCmnBy/5iB2I4X9H7l7kQoIAoyR23KnEJYHzkDWv6rK6te8ceyp0wt+Ei04dWPxYPPRAAqgrLmpir4HPwm7v7DFJEP6e2FNRrq9j/McuakOeEapzdCN9JnO73O6zL1pl7G0fHTkXLVdKEo/fddtiGheQHYedEjFCpT2IZYiszCN2sLIpqcLLex49XL+DzkOkBGmVVfm54QKTVgV03cnAU9UnpnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7lK494dCRtQJhFxW9B1X95icpValKsEkGQfxFp1MEy7YW51tDXLHma7oJr3J?=
 =?us-ascii?Q?bKdHy9+8MSglGXItUOykT26wJovv5AarlgHlr0ww/7jZRvIz2tvVe5v5sF9g?=
 =?us-ascii?Q?zyDyJCcuabON/dQ7uwP98bmLU4P4rvnegLM948ivvRqV4vpy1/nguIq43v+A?=
 =?us-ascii?Q?DCfP8LK6e2+zI8nKoI3Hhv6HR93jVVUB7izVoW5pPBRudDuC9PKtvYAFE72A?=
 =?us-ascii?Q?iueTfcyXS63nkQtgZcTUA5nCGHvcb0iGdamWysXBJavcYW1/i6ktoBx0Sq26?=
 =?us-ascii?Q?8Tkggv7tDYESGAwIWronFv0JlSIu43R+VDUjoOI8LDLaI+vYkU2nY5TPGAsp?=
 =?us-ascii?Q?oy5pXz0S9Qb+bq/gpLr3zYzIAyin4ZGvJfMK0UE0EsmoZFbxMyu9FLXL4twE?=
 =?us-ascii?Q?nawwnK/vnDw4MNN28Bl4AmFYCPzcvs8034qc4/NN/oD7O1wL92YbCF6q3Ul3?=
 =?us-ascii?Q?2/eq5XCz4vOqInl+pvVn+Cn3nvumReVxWwNYnMokfLx42ms8en7FD+VnQf7j?=
 =?us-ascii?Q?nQ85nBpGivh9yMxDmxGPBV3S/ZRkDWM/uQtt8DuORPaTZ+k0s4S1T3+aVliN?=
 =?us-ascii?Q?GZXtpeKX/WYtXif+A7BNuERDtd0mVSHh2e5RF8dPqZnj/bwxXXqXJQcERROd?=
 =?us-ascii?Q?wg5qNhH1nM24q0hKpLoAF5VhcTJc4nFKzI3PXQEQqU+5W7U83LKFnX/5zaFy?=
 =?us-ascii?Q?uijvdmBTy92nYX4MM+b5VENXxzGEtBme7M2OSiV/lJiy02nvUuG23gIu6vrT?=
 =?us-ascii?Q?wa0uXSqeVu4XpIk2C5l+aSzUUrpV/MNl7tVrGMuu+LpXiKEqskxUldOaFmpG?=
 =?us-ascii?Q?iJBGDq+KnBfgZ1PXF/p9FIRa3vv9EnNZHWKTDIWlOeit+DbQh6gngKkdxVPU?=
 =?us-ascii?Q?q1dPFi5zhUQ9SEseeBlnerVqIP9ofd03KFgHrmi9gCrP8VF/lAwxJr1DOvFd?=
 =?us-ascii?Q?jf8B4FEejaeCF1d/YRYOd5u+rfaS68WAQcpCzOm16vgl+Zk8NeA6IFIC6LCX?=
 =?us-ascii?Q?yEaXVzp1AIWh4a/ppsj5ybRjymzuDlqL8sEze2Dv2asXD626k1mD+7VzSyng?=
 =?us-ascii?Q?Mm1p8P1hm1e9HYqST8K0WqmEhk3yXZzvbeT/pFQsvS9Pd/jIwNrEefqUsTNp?=
 =?us-ascii?Q?xKr/ImbCgaHeGcC0Thf4ggumDvvq/oYowBhxi8JDwnxuv1x7AxE6ReLs85Jr?=
 =?us-ascii?Q?h9OeaST3jbjYtyTSgQk083M0f+iZaCkUhTsSB+Egboc5Y0PYSNQTFIMD1FWQ?=
 =?us-ascii?Q?r7qDLWUJXsrLaoGeurbX9cWX6WoCkwxenIu0sIvUm6l+7/VlJNnzT5xfBmCu?=
 =?us-ascii?Q?Xi6i/jJ6Wx/ZD+txyrusNSpFTpMgmshkMxrfo3WEaHfo9MGOxFMMd3HBX7Cd?=
 =?us-ascii?Q?6gS21XBg99/SJOco/4gsGDbQftg21yOxz60s6vVvGX4J2Fi3GXKgogp45ppO?=
 =?us-ascii?Q?YSXj9cHnqyiZtciq6/BadhM0Kr5y171/HRiBGNQqwSdpfGYybI3dpE+tCf9b?=
 =?us-ascii?Q?eHuIsrKMDz246jQgePO64mrFpJmLfSfvOI6QRpN/RTlwSF4Iyws22HsvyeY4?=
 =?us-ascii?Q?0TOWh8xJPX8+3QLuhVRuz3sGeUFAenmdlDoAf0Doi0AGrNSKCVBVGsbOSzIt?=
 =?us-ascii?Q?QGliSbRgJsbvFk7GmhJfZPTWp+CccQy/D+QwUfTxiUaObJc/DRhL4an6v0GI?=
 =?us-ascii?Q?01foEFatZxDiVQQDlch60mpIVmQ8+aWodTwCSCr1zABXXmns?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7c5df9-a87a-440c-0098-08df03a035a3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 18:31:14.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0LtFoQcwtVeNibyzPlkjotIB0TU4xv2kDl71uhEaYaBr//mSh54TpIJC9vaj9Nj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7853
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: psi48u4w83b6pa7yt8wkreiheg81zm1z
X-Rspamd-Queue-Id: 7AA51A0017
X-HE-Tag: 1787769084-210828
X-HE-Meta: U2FsdGVkX18Y0lTfczXdMH0ypsU7kT47pOHSRMRvcsVmUpoA1IEc9P3aSiFVh6Hu+VRZwi5KLixDCuULdECJHIXUXZsPiuZIJGJXzH6D/SuzgNztXdei8bzNKMKMoVnbfCTWxSbJl2rlIK6kADFX5u+NJclt75Cejm56seuBzzs0xEnZ8dx7d2z5S/psCPwYBqjdM+/BzyrXc2dMcimFvz7RUml6jzEuyR7dTyu8MBytBlQnGnjTN23eYA4LIsTJtx06teZ6/hAlRY96NbRWS3QCC6UruCMOOVy5003VT97Gg2VEc/vjQ8eOuipTlGk2RhvgG3zn7uoqdnZD1lg/7QPOQB8ONxT1ONeqobXiTbnBLCR8EPTLkUNJuDZcCQGF9g34uReUbrmcsStPJtjbspGEJZTwg+ulFdqhAXEk+yNeC1W2UxR9sFca2va+8ZBvoq0d2QNORBmYHbhLQSOPISwfxJqCweOHITMoXjitc9y/kIcSDGqRozC431ExFdZLAtGpA+JKEmgVNm1I7o2bH2EeErHtaYkA9kQX699tFfGVTr4PpjNOsIFsEmQL1ujnXZDLi/vBxvQo+N5mJfwRn4Yk3y63DtTbZZa8dVrxzG6JjOsivvt52SyUx4khp3gQ5pa0+6mgclEcd9Z2hUvKCBR//XYeWjfFStQuluBDU+U0KGbqLAtzpaDD2qq97Hik1hgk97YBzU+huxC8wySRnuM4NuoTX3KsHNsbHLHfLWHhcN6pdxSV/xH8dlLWzVtji98XXKyv1DNrnS+BctJ86l96Fd3kHhV0SKM+QCmZLVB1jrmOt2ezOep4JiVFw87BW7YLDXeZ95O/pyyY/baNVFY7yqxqmekMgss6Z3hOFgAi9gtzRE0/qJRDvbsooick08+O6/a6AaJKyvQkObUoUej+8bxCnwXBmqvMpDcgEZsUEnwwmzsryMrZLgYYhRxCDiUFl1a8Q1se5xQVa2/
 y2Kq6psK
 deqS/DMK3Y9XtEC/+ZhDFPNU8/6nB+qD0b/COq8St9W9W3qT+4q/rvLy85fKVqPswChoD+sL4s/HTpOFq1SmrD0+S9h5KmZJIeure77OPpLhSnRC9ZfsZcayyz+Q9W3FYdye7w/8MaUAO1h7kPOKY32vbnMPGOdmE5UGZN6rI5W5u4vREn4uRLeKwC/FtI17SwkRg529z+q1rhNycA+gMp8tbv/U7AEkgIcAefWnT0Jw08Iz+l0wFuLn1GYZ2KZrzmnvNtTy4xk8BAeKpJeiarO9qfKSx+HwrY4Mtni/k3yiHMFmLeofoJsqd7DEXj42/r3QJt+itRUg2MVdL6zNx30bt+MoRA6G7iIHbTNLba25Z4Tsp5wJQn1LIv6k70tgSCM4Q2G+9GWLBGGIoQV1fBSoNIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:48:44PM +0000, Samiullah Khawaja wrote:
> This is an RFC v2 to discuss the preservation of DMA allocations for
> devices that are using direct allocation mode. Note preservation here
> means preservation of physical memory using KHO only. IOVAs and IOMMU
> mappings are out of scope.
> 
> The complexity and need of this was discussed in the thread mentioned
> below. It was proposed to allow preservation of only a subset of
> allocations with minimum support. Offline discussion with Will Deacon
> concluded that this series is still needed, because we still want to use
> coherent allocations for Arm sMMUv3 ste/cds, so sending this v2.

Was this before or after concluding that ARM was OK with using
cachable memory?

>  include/linux/dma-direct.h        |  29 +++++
>  include/linux/dma-map-ops.h       |  10 ++
>  include/linux/dma-mapping.h       | 100 ++++++++++++++
>  include/linux/kho/abi/dma_alloc.h |  32 +++++
>  kernel/dma/Kconfig                |  12 ++
>  kernel/dma/Makefile               |   1 +
>  kernel/dma/coherent.c             |  11 ++
>  kernel/dma/contiguous.c           |  27 ++++
>  kernel/dma/direct.c               | 189 +++++++++++++++++++++++++++
>  kernel/dma/direct_test.c          | 208 ++++++++++++++++++++++++++++++
>  kernel/dma/mapping.c              | 132 +++++++++++++++++++
>  kernel/dma/pool.c                 |  17 +++
>  12 files changed, 768 insertions(+)

Because this seems like quite a big change to swallow compared to just
using iommu pages.h

Jason


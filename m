Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7E4CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD2D6B0028; Thu,  4 Sep 2025 13:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4996B0029; Thu,  4 Sep 2025 13:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9940B6B002A; Thu,  4 Sep 2025 13:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 889156B0028
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:34:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E4EFC0331
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:34:49 +0000 (UTC)
X-FDA: 83852267898.29.7AC8F53
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EE91C0016
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:34:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VnBQxi8b;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.88 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757007286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+J8omS1gnNZidD6HpQBltWpb5njgr7U1lD1TVKcTk4=;
	b=1j8LDiXxpjRYYONGz48ZcEaGUux7DpfCqk5l0yG6wsnCHNLjyI2g/wOzme6TBc9o/5qZHD
	yB7y7u9p3Cm0m486K07uUKkqArpRcyYc+YzaOUgh/HLb8K/7mhERyATkozFmFmAmmPlhhs
	3UsDeBxdg00eGk3FKodfDMUbF3maIkc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VnBQxi8b;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.88 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757007286; a=rsa-sha256;
	cv=pass;
	b=hxQ4kECES10AECTEqpLU3gHluBr6ll/moonwXTarsiM1lkuJ69LWUVT6BxlKvvQqgnlM2Q
	7URJyGyfmphXK8rTGKrmjrXBdWWDDsB/Is/f70xGUHm4dJfANKf3SxCbC4/iz+E4nCuPuk
	RJ84Y8ZmN/NoxjvPykvzwoXc0o3Vktw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekmqO7Fm7SSlw8vRmNX3H500JRzpNBemIvtJwSSUPANOxdmNW5y4WoFrk49m3k8cO4qZgQFAZz/yOdrT3BGK8QUtmkKe5TL1a2OwnlF2/uGAYpAmE/cna25RCNFDQSUV/RlEBOiJFpIXSPEMii+guqQ1MbH0EScJLwyxO8EXkTf/Js8jBcCBPCbBxnhu3dqybZb5w4we9dbaf98K58XpSW4aMa6g39LKhvLAEDfQEDbtji15/SUXU/u4YOBE4r33QwzfO66Mz6h3E1BcH1MTfVT7mU5SB3X2MYZRCFntUM/auIGG3GFZvE6RxUALw4Lg/nY6meqQVgTE+q5ShCjDOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+J8omS1gnNZidD6HpQBltWpb5njgr7U1lD1TVKcTk4=;
 b=WifC5NqVCWMfkVXnPU5oXYHOIDJ4nRIVy/GSwkddYrCnqV1DxePkl1BMRfYEjYhzoWkSvSUjb/xD8PMexCMThIUOFAELQ3VO6//bjrPHuTYeMHFYYp0a+wsB8hEYkHjvie2/IRQcHVsrz/OmCkBkPKhkm82lZD7Iz7QIfd+t0DdVeNOIY0+A88kzhk6DCsr7o2bYut6bTNqOXyX+j1FF7Z484QObX7emeyCRXdVDtGLPorGxX9QpOVIdPdYEXu1CpY3xXfDhCEiUWqoDnTTMFx51QKcgeUMgdxzy5mR+LgXOXaP+yOB24vxl5+Sp1KmOpRuMSEv7G3RkVcwqhULE5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+J8omS1gnNZidD6HpQBltWpb5njgr7U1lD1TVKcTk4=;
 b=VnBQxi8b8QPmXq+r5dOWzRaoi9QfAhDmLq2ggqzJsipyS65MvwVlnR8LNMw5T29V0XXzzsRi4Dp5nHXoDSX7jt8TTsKIgzdM7M6UZkWS//cDRbHwHZDwfUm+4pSotUzfv/SEOSDgQUAZA//uZ8wtsTd9b1Gn6QIcZFFgBor1kgqLjbuGV2bwrmb9Ij588MQOaK01uHL+NayjtTlwOBX704UMTTUnngkyR6EPRojvzb/EBqpIWpDKmt3plOV5tcSOUIe5Dykq+CPtEB3sDM1dVng7iZVQNSboPP7e5H2qzwBk0YA7C/O5yULVxkjwgrtwv89MWtuehNNQjEEiMYth9Q==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB7647.namprd12.prod.outlook.com (2603:10b6:8:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 17:34:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 17:34:35 +0000
Date: Thu, 4 Sep 2025 14:34:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Chris Li <chrisl@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
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
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <20250904173433.GA616306@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <CAF8kJuPaSQN04M-pvpFTjjpzk3pfHNhpx+mCkvWpZOs=0TF3gg@mail.gmail.com>
 <20250902134156.GM186519@nvidia.com>
 <CACePvbWGR+XPfTub41=Ekj3aSMjzyO+FyJmzMy5HEQKq0-wqag@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbWGR+XPfTub41=Ekj3aSMjzyO+FyJmzMy5HEQKq0-wqag@mail.gmail.com>
X-ClientProxiedBy: YT3PR01CA0113.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: f3260731-1526-4e39-1031-08ddebd950e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aurMXdrr6LKoVLcTFvS6PfF5mZYp6DNE3iP2Oru5onkh6xQtycW1/F3PZtsS?=
 =?us-ascii?Q?+2KdryoeJqPae4dzFvq5CPdCNf70QeMpJzyTfP2g+CZr2rR4fpkoutjzVycd?=
 =?us-ascii?Q?s+F7bKfY0Kt4chuRCSbuLCJMYPfDSsUWJirnFSOtcabjEAuNKsJON0cIi/Ul?=
 =?us-ascii?Q?IKRUnPHMBgiI0eCOBlEti9OeCYh38cwhWr+3gdVvg7CsgjWFxrsKKAjyW7m5?=
 =?us-ascii?Q?9SahQmKscdbXJ5c874q/h9K8pNTyDqR6/z40bbZ60oPVwsRqFXpRCKzHNmZ0?=
 =?us-ascii?Q?Nime2qB3URGaxzlBZrPSBdZISxsnfZWcmKcz1tI6RfO9q6xJoHaBfqNIKiGV?=
 =?us-ascii?Q?atToe79gvSE4n3f5R8aMWO8aTVnyobxkJU1FPAY65t604cmBVrmJl4xRbnpx?=
 =?us-ascii?Q?Na4DPvmSz6ZxQdmE4n4h7xKXDjXB3+DUMbW2HfhEmT9c94r/DLz0vrlemrGX?=
 =?us-ascii?Q?pHkZi2trGBHlCepBfSL6edt4jN4C01tMlUp5RIctNXbeVkFAlm57hSn9EygG?=
 =?us-ascii?Q?XjW7nPfdOC3CPLP0bKNhQRzhTbTsvp97zEq2m01ExKys4LMsb7E9A8kG3P9G?=
 =?us-ascii?Q?O5H5JUmd0W23UhJp8GpEvNuB8ckQ5CbqaBjDuZvH+HUXZqV1DKRdIqOhu2oA?=
 =?us-ascii?Q?iEpL7oExaxPXsgADYsijNzxdbnhPPXsIw+o6SMAL8GYi1wwu9b2W4kWHh4dq?=
 =?us-ascii?Q?aVFaxY6wZcRNyGTd0J7JY2VIM4cz8lM2Wk6njAfsWm+B/EGmQtO1AdCQZkD/?=
 =?us-ascii?Q?Jj0UewhBYjrHOm0RVMbF5dCpY3ToGO/QbR7pP3h0DUcoAD1QIzhwNJJzppad?=
 =?us-ascii?Q?xEk9kRlgeWU1pBiYHMQmu2cZ0xWc+JBIdJV/zi+MHsx2lioXn5tH1yI82bwU?=
 =?us-ascii?Q?fpyJ0mpv5xkt1vSW2vhgMGCRzFpV9yUHGdbFZAWny/pkQX1v0TgbpoH91und?=
 =?us-ascii?Q?QBGpTYz6yp2gjYuO5GnRve7R8VKb2WLmhnBX82oRS2QDz2BnFdaJ6RIafARk?=
 =?us-ascii?Q?dyApT01q5PsaHeXC/i3ZfF625JMcRGlUdAGx+/W6OUTWYH6PFCPe6IigL406?=
 =?us-ascii?Q?XZ70EdMPFbNzxuKSjqiFRVuX1+9DafQfO/FpYYw2vO1vt/1f8G9wkFrnKpUc?=
 =?us-ascii?Q?esMllAytk/zOpFCgsK5NoQnPBGJE3kKEOc4JcCfmti/ganpgJP0r5D8MZo2M?=
 =?us-ascii?Q?Ya9ndB1p5HtEnFdIpwYTo5Ho0xqHv2fXn2u8POCPf/bM48UwqkadD5ZD1qRv?=
 =?us-ascii?Q?J0bmTgRMA1KzH7inRW10PmtKaDO8D2fqHqZfE9sEpHgiAYIb2oo0kswWujFR?=
 =?us-ascii?Q?WiOjmi8Dh2Mnz/HrROP35bn01s3yTgkBM/guodMjLZhyKy1A2F1i1R0VEJGI?=
 =?us-ascii?Q?K54QkO/Ei4PMg6QPb2ePQ+Rm9+WX661bt+6f5eXa1EHoL0Wy+aC509C5A95g?=
 =?us-ascii?Q?SkTPrerPgN8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hCv7NbxP5ogWB//mMoMseWsizTYVmg73lt3Xl4+9TZ+UdRCEojeAClmVxb+O?=
 =?us-ascii?Q?2+YnuFaKvrxLqWRRWWislSovHpIW7l7AO0rP1MZ/7KJuhALMNrOhC64ixTGH?=
 =?us-ascii?Q?5BObFgCVNaxKDys2Cs2Q89IOL5EJ5NbOfQbs9tojW0DrP9F776n0jx+OG7/h?=
 =?us-ascii?Q?Rq8kwWC6el7Pg653jBA/Dcx/nLEAc8Fm4tGURj4MlxEXd810EPk4O1zCfJxe?=
 =?us-ascii?Q?qVjSDtq9I72hZ4n6ZR/Ss1ULi1DkFrYweATXQ6Z2UymhtPBnhZWz7Lz4fsTq?=
 =?us-ascii?Q?3JtdqFEeFlVAzLVkSG00ErcAFSSOJwm2p8O+xMO/Ec+sZXh30uQt42kujLY2?=
 =?us-ascii?Q?gFD84RV7/waWE/lMe3BZilRNJ//q9FVwIqv6p1RfzdIN7aAzisRto1h4WU5U?=
 =?us-ascii?Q?t6yylBcysp6/B3yZ9bg4gamW8PwIGh6ZrvcnxPRqh8r3zZTnu3Gw38iI0DVB?=
 =?us-ascii?Q?hIcHpCo/jdkfeyWLhoYEscBMvrluFLND41TmYoep5JXEPGlIlVWJtjyDW7rM?=
 =?us-ascii?Q?k42B5efZd+w1802yJEDu+OVfEYyivMd2Od19PcLD6o/bXr7Eb03GKwtDMqfo?=
 =?us-ascii?Q?eGDLeXBNNpLHvMNCvgHlHE6XIQMOI3F2autGP3s0QaBQhDyHbTbc/Wcpw7BE?=
 =?us-ascii?Q?Cx+rJ2Kg50XxgBPXYRJdRNm8O2eWdSKWzOsmEFT5+VoubFPxZ4eHOu2skzan?=
 =?us-ascii?Q?ABvoC+NYoxTzs6ex/Sr3/kg3+Dfw3Wj2Pmd44LSBIQ7qjeX7ASb3UD+qJ3N2?=
 =?us-ascii?Q?8LTM3KUsDP+68bLl1x5kKwAgF57r5Tf33PFiLArM+9GeuXkztSXGYgcxme8P?=
 =?us-ascii?Q?2+ffCk2HSbAAr4J3nkskBBW7wFg9KYtmuzISVw+pEZ3rn5/WyllK9jVInkqj?=
 =?us-ascii?Q?uOMCK0t4jUqZxVodgaOALjCdIRFYq7ocgiooVVo0o4v4lSsC4OVYwB9TJChg?=
 =?us-ascii?Q?ufmtObtU1VKUPa7LopQ9xXt0Ug2hLhdUoP+TovRq4S4+Y37GAfbSIG/DDP27?=
 =?us-ascii?Q?pvUJksvidkqoEr139asDalLjzwafmsq3Eqjknwv4Cv4GleLy1e6prEGK/RBV?=
 =?us-ascii?Q?9yJuy7vyIVsnO9Mb89zJPyf7hrAGFMoZNOL5XCe/QpW/VP7cl2+VOnr5ePaE?=
 =?us-ascii?Q?nU52A92xxTqnfseB/K5fiLwHSj4ar9rfVZTs4pW7swmZ1rNiMCBnHNVnjFIr?=
 =?us-ascii?Q?uH2o3tGeat9IM0NR1qFRi5GY9ky7i4HXhovhzZSSpwihuSY7H06J70de1yzL?=
 =?us-ascii?Q?OfRXfnxWQSiMaaFCBKngHfYle/mPuTLiicVLnCDSs+5eXCjSvEoRzgKUE/xT?=
 =?us-ascii?Q?3n4nJrrSdV3JgxL9Xh1jKZw/hcpCTBir83oU6uYciOQAUueg5M7xmVlRphMi?=
 =?us-ascii?Q?zXWenecppGI5Bx8I0pDdQNH7tjL5iVYR9UqSgM8vsoKRuLKloyO9FGhyoequ?=
 =?us-ascii?Q?XJQHQsHO6eWxJUgXTsi4f6+b7wfV1eNPYt4P3go6JdsL90xnWNkgGEfQmt6M?=
 =?us-ascii?Q?sQW3XCnM5v0SmcKnKa84gLlmiv9hvnddZeuBNVo5RqNDKwZmwmGzqHmhugCu?=
 =?us-ascii?Q?lbhin1k6pfexo5px+gI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3260731-1526-4e39-1031-08ddebd950e5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 17:34:35.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M544s/fY+8S+xhI3kLyf0nuab/zepz7raQD1z0T7q8AXqazPi4rr3RRD83r0Omz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7647
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EE91C0016
X-Stat-Signature: sdt9qapy39c1uucdxzpyq1wx1aqichz6
X-Rspam-User: 
X-HE-Tag: 1757007286-678852
X-HE-Meta: U2FsdGVkX19zg45e+6lR1yHfeZ5sSWTndi6pRu319BjGXwrG2C2ONq6oLoMtZCZodU+0RM3OXmDm7UZZS4OFU2fQacYh6iYk+H4iH87n52rlHIulxpsUDt7Kxz6ZKRuA8oI3qtAnGkYbM5P/xHMoVtWqxb8Xq2GHD0Sr0EJX0enLYR0skE/J0T6+lzFPO4VTZ2YVK0Be6RUvIraKom1+IeOc9GboMZinIsK6DHUDavUYXFN0UsQE90XGKK34gJHlJRKhizwfJqyfEM2JeFrIXUSc7qCM04ArTfd3bwYrO/gcUPHAzFx7Vb82Dej2KxdrxTWZA7+fJ1Ym7stxQFY1tS0VSRfJK0M/gQTDlixzSNflIzZPbKIGLlirOo/+55DX4j4Dpf5U+/34W7fRSHg36gZWH1O5YTMWg80N5B3pQCv7L/PJNK34yKRAZIzxXU1VlxZfR9dobxr4bOvW/j+hGhPTEZrnmNDx2Mye/lrobba2llCfxfxrLLLnEd/1sOZWSeYrPd1NNZEOl2xnt0nz++YWv0MsDWWnmqhucYlT792LM/ib9vbhQR0r4nmHPt2PzT2U3bxiclrJraQMMSKA7JXC45cG7QnkdTAFRv2XP8YMYc49BVdYxHtkvSiLZqPRd7h7IFkLNd54W/qU5rChKrbCo7TheFeEr2o0lVfoZWHrHaoebKgmiGM3Vh2b4dAOuwSQMmFxng6xZMtUOSVECTXb1ucvsF0oxRooB13+1m2p75+/w3FNf4Zfvi3nByqlPFuWLMbryaV0onOO032EdrL40eY4KIrFhf300WS7iwIGyNlFQP53w9al/rJkpIVLu7fwAo2PmaU58vyP3qJSmzH2QV3eA7y5piEBkZueNKvLFASsBFfuIrVfFSIG21gX+cpdwtpzizXzSYbQf502yjhrB28OD9KNBwnxXLoYII+ET9FX4MsAjvdbDAZ291uTTWjOrxOnGMzu61kDfaW
 ZRG2h4WG
 3OuCmOCzXR9W/2V/16mjt40MzKo4osDHvd+3MgMpw02Z+KL26PoRD7pLSPd20TNnBXsfbuYQ9+AwMVuTPMTSBWbMTIIKrGhQw8zEiqbItHJOQPQkIMzT4wxBpa8R1d3DKcK/PMPKOUnmtfby7+6SeaGsQd/t5JB9XYJKEQ41A1BiweVQFO+bpTNP0pwXRHpCfuJMczE9tP5dkB9OWLneyv1XrsKfihWoPltMaV2erIiiNLJltDZYV8t1z0TMoEJqV81BCgnWQwIs98tPj/4R9lFebjDt32fJEs1diPFyEUEJmhqjuJ9CXrxGX62ak6l66YsyQ0vdEhCDqJMAtMQ/ugj93kSTE7biHNKcPL6Wk/VNTy1SkivKDr3f/TITboiXiNui+CRdhip8SCeWfBrTZUNZy16qpBtSoY5B7aY+yYBFXMdqofq9STTah50vJOVF9kahkiHAQqBbDSiKuxp6TK10y8iJs9GnegI5sDepXlTbaUBxvP2Q332ojU0MR+HyjTM2/UNoAyEap2twwrf/7EKaPpPJ8RXhsFAdZjTwkg8Oc/Cv23BXXL5aZyldgP2AFt9MD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:01:15AM -0700, Chris Li wrote:

> > And if you want to serialize that the optimal path would be to have a
> > vmalloc of all the strings and a vmalloc of the [] data, sort of like
> > the kho array idea.
> 
> The KHO array idea is already implemented in the existing KHO code or
> that is something new you want to propose?

Pratyush has proposed it

> Then we will have to know the combined size of the string up front,
> similar to the FDT story. Ideally the list can incrementally add items
> to it. May be stored as a list as raw pointer without vmalloc
> first,then have a final pass vmalloc and serialize the string and
> data.

There are many options, and the dynamic extendability from the KHO
array might be a good fit here. But you can also just store the
serializations in a linked list and then write them out.

> With the additional detail above, I would like to point out something
> I have observed earlier: even though the core idea of the native C
> struct is simple and intuitive, the end of end implementation is not.
> When we compare C struct implementation, we need to include all those
> additional boilerplate details as a whole, otherwise it is not a apple
> to apple comparison.

You need all of this anyhow, BTF doesn't create version meta data,
evaluate which version are suitable, or de-serialize complex rbtree or
linked lists structures.

> > Your BTF proposal doesn't seem to benifit memfd at all, it was focused
> > on extracting data directly from an existing struct which I feel very
> > strongly we should never do.
> 
> From data flow point of view, the data is get from a C struct and
> eventually store into a C struct. That is no way around that. That is
> the necessary evil if you automate this process. Hey, there is also no
> rule saying that you can't use a bounce buffer of some kind of manual
> control in between.

Yeah but if I already wrote the code to make the required C struct
there only difference is 'memcpy c struct' vs 'serialze with btf c
struct' and that isn't meaningful.

If the boilerplate is around arrays of C structs and things then the
KHO array proposal is a good direction to de-duplicate code.

> It is just a way to automate stuff to reduce the boilerplate. 

You haven't clearly spelled out what the boilerplate even is, this was
my feedback to you to be very clear on what is being improved.

> I feel a much stronger sense of urgency than you though.  The stakes
> are high, currently you already have four departments can use this
> common serialization library right now:
> 1) PCI
> 2) VFIO
> 3) IOMMU
> 4) Memfd.

We don't know what they actually need to write out, we haven't seen
any patches. 

Let's start with simple patches and deal with the fundamental problems
like versioning, then you can come with ideas to optimize if it turns
out there is something to improve here.

I'm not convinced PCI (a few bits per struct pci_device to start),
memfd (xarray) and IOMMU (dictionaries of HW physical pointers) share
a significant overlap of serialization requirements beyond luo level
managing the objects and versioning.

Jason


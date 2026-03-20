Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930811093172
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 04:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE876B03EB; Fri, 20 Mar 2026 00:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EB66B03EE; Fri, 20 Mar 2026 00:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66646B03EF; Fri, 20 Mar 2026 00:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 940AD6B03EB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:57:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCE0E1DE34
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:57:54 +0000 (UTC)
X-FDA: 84565234068.13.C3642BD
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7E78A000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:57:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q8XRdALR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773982672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QWklbdcQQdcH/vkgnx5l0UMM9k73g91X5VyIUZ45pw=;
	b=jO7+cFMGb1nAEQQTV8UY6b4Y0DMv/JIJZFT9QTnZT1/R6eEeCiUZwlykNsNnWZS4TZbwRE
	KfJPyQrqF2odxCD4Ftj3wETcNgpf0+/Lctzot5tp/JXVk32TGU5qmZWrIENJd3UOF0ocDf
	CzTnKLgYxe+g/O3Z83DAppQcBZYE0Cg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=q8XRdALR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773982672; a=rsa-sha256;
	cv=pass;
	b=QE2LW5FFVh8uAwXh0H7VVbcAL6oHVQroLVTW3W1icM5i/7/ZhtT86ari1Kh1kGJ01EQgnh
	IRHLfnh6Qoy5gZvHRY+07HCe12RrRRFdMICpEtMtl4iVeo3E3PJbvwel7H8mIx6qUHJIWi
	B1glCIniEtwj9f5Tv6CD2tLbHpuMybA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drqqoq37n/BcWYA35VP+V/OliP3+HtaqUoZTwWBq0X+aSr89E3BVtQwJQQO3iOQWgBPHO8r5DDrjvFTIoc9gcDNWlao9k4U8Btr6czjIehOu1/DmtExey4WzDFHKLSzLEakhMTM0ovAhvjTSI4tCU52utGl1Uy8uHGVJ/uNBaLIh7zwD2+nUSgzW4tKPV1MEOQESmKTovNp06CUbC3VbeVD/tANL5UT4xtjxP9T1MII3ERKsotVxeCb1iJE92R3sFYBtzaICEfW3MwpaEGfBJ6q0k0yRlnTMcGWslAJ/JBNQZ8iX46VJcEav+BWSBR9j5HTPAb9E2CuRtpRldXuGqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QWklbdcQQdcH/vkgnx5l0UMM9k73g91X5VyIUZ45pw=;
 b=Ucycfvfj59aBdRTbg8WeBvQPtkyWk54kk8ylRbufalcEC8fM8NjK85ByXwitJ1NzcwJEejSBgRB9TUwVYjt3FEv/cnraqvK+NTc/rgTqJY2hy9rdU1BWDux5oWRfswT8iKzoE290H67eC1k5lE5gU0AndGdPEkPRaLf74FY/Tgma+xJHvLmSEFt8lBV0XvRUk96k3+nNTi/GmXu9mbIZWli6+PXua3n4fDePsc01mGfOlCxHhu8cu7XUATZoP/hSBB26jtPE2OqBnpunypmk06b9A2uLnojM9kvUn1HoCLWviFyfnSflhc0+2qXTYQGY3r67zl2t8N5j8y/6n1Imcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QWklbdcQQdcH/vkgnx5l0UMM9k73g91X5VyIUZ45pw=;
 b=q8XRdALRcV3RICQA/4b5f4D/Ngw7rL1ci4J8hmTrJ2oIYp08s2k9KCuWGUXnKIkP6KsWfJpco+lMWnuL165kWgn2Ft1vCmtftdgtWYkaQMmMGxQz8lSoxivMzNukLJe2lHUs0xCgS/0tDn47cpjiu2BAtRwuTVtdzhO+rUg8UnvCAhwxN6FjVTlBioB99jKrL1ywOt1RSQp4IM7ApmQMbmyEc+c3aFrzVLukkl6Q86eAWlVMJ61EeuBTt15Y7ksJYJ0VVUfmmKc7Fr1G2Pxc+BpISwWV43k1wjuZTCpTkdUTzjUosEgM2usc2B2RoWGSSSaaEdwgw56yYLqszn9B4w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB6221.namprd12.prod.outlook.com (2603:10b6:208:3c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 04:57:46 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9745.007; Fri, 20 Mar 2026
 04:57:45 +0000
Date: Fri, 20 Mar 2026 15:57:40 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org, 
	balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, 
	simona@ffwll.ch, rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com, 
	willy@infradead.org, linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, 
	jgg@ziepe.ca, Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, ying.huang@linux.alibaba.com
Subject: Re: [PATCH v6 05/13] mm/page_vma_mapped: Add flag to
 page_vma_mapped_walk::flags to track device private pages
Message-ID: <abzSSHQUnDs_AFoz@nvdebian.thelocal>
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-6-jniethe@nvidia.com>
 <81e7bd1c-54d5-4f88-969a-685177447c51@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e7bd1c-54d5-4f88-969a-685177447c51@kernel.org>
X-ClientProxiedBy: SY5PR01CA0124.ausprd01.prod.outlook.com
 (2603:10c6:10:246::13) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a816721-51e6-40f5-07f4-08de863d39e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|7053199007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	91RDluNrY79+kKG5qf7yKJZKKFPFDfmAawdD36qgc+Aggd1lKgAnDb0teiHLJbyd/1yBsKEUNJHkxuTDcEdpNRUK5CU13v16Vr6rdKAk7xgn3inoVN0C98REtMEhIpdG/HUY4Mnd2zlwzihzLzHGIrKIG7w4U7baRMI+Ml3X7bIQ37dvscR9hYMF2DeKIJzeGoDWIZ6EtF8P1bFy7D3KyuAI3B3QRUaKI/x7C6ef+wjotg0wud9HURRijLod+nG8xhsG7K17hXo0qsBmWUzjsS3ob7tAOfFNbHSTS3jTBltKQ1VyckFHpMyV3IfzSvcbYGR2XmSvLBlFz/wDr0KEI+VS9FU/1IghWfLyhh48joEBnaoUrsyK/asZ88g/FpDaCXB18YyDNMDmhwIqjekolCnQBSYV0aCS22gThnIAlFNAXQjyEPC+gos5B3Egn2XA5YCyeVDXuw2gB1m5VbU6s7PEcIhsb7EfMshzKFf5ppFoj2XU26GB49DTILAMFhiLez+jgagF9bzTA7L/BOZ/vIwCLdT8beozppucsVsuZqumqTCP8URloupKPUKfbADUmZTLYamLRfYKsHPJOohyzMoXkRyl+ofME0ZLs+fLpwlJaedpUljia1thEHsyTty7zGAlIqrE4LACZxUMTmctPRyELLkzL5QxydG/sW5i/bY68N1qi6Zzx20jEOUsWsSZ6ERbxJjMHlzzlg1Lm5VSpzrW6mIRENFBc74wceCh/9w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(7053199007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DSp7Q2nNCsTZQOBXApbLmr8b+CdnGV4kV1A4/xCB6dADfOAceuOrdiuQluIo?=
 =?us-ascii?Q?Fl23Er2Wt4rEKkOrpm3AyB33H/trc+kUg4r3FGgHgqV8PvHbuvamuPvEUdb9?=
 =?us-ascii?Q?atZtN6uplduzvtUOSLnvAmymxyIOWPTJEgKZDGvNOXs6H6qfZMSwWy9Q1i3B?=
 =?us-ascii?Q?EDXTPuay1/gz/7vx4VXyijnFclWh8zG1Bs4ZPuubw66nZw7Bj0QwnTiz//07?=
 =?us-ascii?Q?R7zyN1CDgaiMmexVanQnNwM/1uxdjJwIQayqpmNsd559rEnEWFQUiApNfrC+?=
 =?us-ascii?Q?W/CpDWJ8tDp+mu8Xx6Bevw2mnyMR9SeCK5KR/HzW4fnqi+qze8UAGa6mufmv?=
 =?us-ascii?Q?q94/CL17WfT2RyqpUj7lPZVCplQ5+qBDe0FaT5PuiYSNzf3h0Z95mjirhH2a?=
 =?us-ascii?Q?HQ6KpRfTp7d/YQLSvymk4QhA2ejnTAm15vJ51X8TCmPBeWTj9KQKzt8/pl6P?=
 =?us-ascii?Q?FKyFR3/JUVR2CWKo2z8hwch/nVW9cctzen5IPZcrzw75L2/O/GzVMyEfgFdL?=
 =?us-ascii?Q?4vKqV+/HGS2Q0BVtJD7a0AhPtVUEVzeQGTY/sSOUgACaaTws53LAK9UpofI/?=
 =?us-ascii?Q?bgvCT/WHip8YjCSn325/4efE3C5Q8mdN21H78ntKEvhKPHM/WkBymU0JZGIC?=
 =?us-ascii?Q?03gFvGLMsEkxTGtFpaiK8xoMv+/wHDAZIdWe8uzN0Zxg1QamBdhzAT9+xDl5?=
 =?us-ascii?Q?FLslTiLIxSdnMhbPafa3Y1FSuTr62lYx+/oJuXYajj/DmV+yWQW+XrYA2z5H?=
 =?us-ascii?Q?RbQHmpERTlS+w3MWIelzIeJPoZdRcuI7hiC0XFMjc/Xa2yAhlki5hH/HU4Q9?=
 =?us-ascii?Q?Uae0XZVeRYJGD8Fa6DYo0op/w0xRw37Jsc3BQuoLWC+4CxM4y9gXtgIqoMme?=
 =?us-ascii?Q?tUk6Dl86eA3IarruMXgjJvJkR0kGn+xqGrrI8llGPOrUIeEbDfXxAhLoewhM?=
 =?us-ascii?Q?Ro0GcELULR7F0lmufjNDzAMLkA8Rk5a7X/2e0RISZp3TaWV13M6cDyx7VGph?=
 =?us-ascii?Q?hcl45HNF3la6y8NAwFeor1s2SFQXysCka54EUdZCexw+QZyeZWYfNUMy+LRP?=
 =?us-ascii?Q?5scwViVltQ+ermXAtUOLsf+JJiTh1e+iJK8V6/UrDXOcWqEqTEZsF/4E9HaL?=
 =?us-ascii?Q?GafijPVTTKwCht+3lvcb95RNi3XbvgF+PWinY+BTsBaPZAm8Vl12qXKCi1SD?=
 =?us-ascii?Q?FEuAvHvhYb2CZS0UepFgNK+hb40hwCfVP2OOCgkO4gqqKyOok1gwtwtAuFJ8?=
 =?us-ascii?Q?NLjp6OhE11ocWZ9/HBPRPQBkx0BqLG1Ugs4jqTRGS913x/EouMcrYmEjun85?=
 =?us-ascii?Q?Cl0Fkd5hnfDqN9Q7zmas8yGKqRfNBS7o5/YsamgE7ds8JwB6JRRxdrIRJJjs?=
 =?us-ascii?Q?+oOZ6LulDYsr0azTQqcRIQt2/dG8jp2SqSDiL/lnRYCHswvyNKhF5Xpxbcho?=
 =?us-ascii?Q?Uq0HFCPgp4XPyBsdMP2Q/mF9cfuRtgxXOGoADh44eoJpOZxkLM/gi1XTorKd?=
 =?us-ascii?Q?wPgGtk//5ueDnDEkQnUMFYjKfXxgsEScnjaEgmSYizVKiQEaI5DTdaiURDlb?=
 =?us-ascii?Q?g1EmuGzcnuPvOnb5cNLhIAzCQvpV8c2a1oJeDWffjRzFKLxCspxg9t3ZXsPh?=
 =?us-ascii?Q?yJSkBLPNw2VWWm9rkT241xwfa/t+h9Vawza7zKlNIMMWMHGFA88twGqGduDA?=
 =?us-ascii?Q?ppeODTq6+tVJJHbA9jY+vAzz6xx2DQJmytVDrxxEf+RMd+H77W35sGIuVhP3?=
 =?us-ascii?Q?xnrkVTRxJw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a816721-51e6-40f5-07f4-08de863d39e9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 04:57:45.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAxIr6he7iu0qdGZEdaUirRs008uFr5YZAED2KTPReuw8fxZi1bXstpPBJCvFjSPx+zxdg1FKffQitXVUValPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6221
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7E78A000E
X-Stat-Signature: b66oq9oxye85r4gd4fsp7hh56w8h1hsw
X-Rspam-User: 
X-HE-Tag: 1773982671-959319
X-HE-Meta: U2FsdGVkX182RelvLOaM1Uiz5B/RXiolHWxyc7YBUXb9LYUL21HlyyCF67YzWxtjdKKSkWtBMrHz4Xn1p0yncwFI3Af51htjFJdo126a1l9wkZemZLbONg+BvKRXKAhswmz9ve6hTE2R8z8aj6dYbr4wkREP7PigVZi0FtCV95DPgFxVgKGS/b3ov5TaoT1PnwF3szNRL7jWiJ5mymfnMwzv6zzGrT2EaVocZOMZqVD6Rkt+7bHEY9v6M1usJ7hf1lw7cFQ+ikkI3IZ9auFEFeTb1nHNlynrTvwiwvI3Siu5CMQoesoOgCGj4XjbMWUSJ/YxQnRny9XjjjR1Uw7D5dGLYIFbsPLFWY6Pi0sZqrj0VdPKBUFMw7ufOZ1jPtswcGyBJzGi9iZvw1EIqG95rbQZQFw2sZ7IDNB33027UJxTYW+sCqMLgFcnkkyBJtZlQDfU1KlAkvcr62Ka1BfN44PFpJBDBbOXoaqIOMbXuUCamNZXx8hiB1EaE1JyUexhXi2DWCYjHvdLc2OCflrcDVGMKn6yPR9ajq5HXz9qbYMHGpzZnotVkmdPrKWPQ+JtTSHuQXDeBLKtnOIDhpKehAFC8ztdcLrWA9qJXFewgmlPI5Q4k4lnXlS/vdNdk48d7Pvb/T8BXhG/ey1SaXeDLWuaSRa1a9IsZossPFCLO8rGV/AcwosPEyvxbAwQKofpAeOVNN4UWZ8szfJjeoIXhuP9cgiOi84ynkHs3fGe8kvUKnnUv2rGBG32khjEfjkZBfxYUrPrcmGbKJGUPHqxxUP3/fukjXSEJXLKn55H9K5ODnX88ne3iVvlkkWVOvxw2O1ScumitJakNX7PFdPxpXVMlJkYkQ2RpqVqTsXhAjyKssUy8BjZk+cfsK5qCa0TAYmegzSUOqHlt2aGG9jMVWl3KwXeoUk5D3zmuQPBi/JwJHz1wQotHhBPKK+yVcT6Y1WuIElX+s/3VkO7OQS
 +8+X+jUn
 oNbsAB3NPbdG1zY8Rpyd8RtdOf66PTGJ3BzeWOPpO9leu3Sa/oDIScYEy66iQg8jyF9/3k1c3v1AfUOyQ0kSxhvVRpNub3StcTGH13XJjMSoRhNttfdK+AVLIrG9ih1hX4KMr08dtPuF2BB3Z0E547ig7t4S53PMbDQmZm168soqI0vtPGtpgGEg7ekXmRD5O/gL9b4OiUKIHXrMThKoE223E7hi9FO7OsjtcahwkKPIof44uTRiQacac1ugO04PGCcdoJCMF6FPCH/+InqeHc/9O54lI4qJtNtH/SshO5lSZCysqLDHCB/1jsgb3u0jOj7HqinyOR0tSRD8F9McA2yRMgG+Jwtbb1fbhSXfpjNoa9XrZU4ExbcZIrc+1rWfbTLqWyUi18w00q1tCnO2dEWIsChkf+y/rrWxirljbtCUzLP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-07 at 02:44 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 2/2/26 12:36, Jordan Niethe wrote:
> > A future change will remove device private pages from the physical
> > address space. This will mean that device private pages no longer have
> > normal PFN and must be handled separately.
> > 
> > Prepare for this by adding a PVMW_DEVICE_PRIVATE flag to
> > page_vma_mapped_walk::flags. This indicates that
> > page_vma_mapped_walk::pfn contains a device private offset rather than a
> > normal pfn.
> > 
> > Once the device private pages are removed from the physical address
> > space this flag will be used to ensure a device private offset is
> > returned.
> > 
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> > ---
> > v1:
> >   - Update for HMM huge page support
> > v2:
> >   - Move adding device_private param to check_pmd() until final patch
> > v3:
> >   - Track device private offset in pvmw::flags instead of pvmw::pfn
> > v4:
> >   - No change
> > ---
> >  include/linux/rmap.h | 24 ++++++++++++++++++++++--
> >  mm/page_vma_mapped.c |  4 ++--
> >  mm/rmap.c            |  4 ++--
> >  mm/vmscan.c          |  2 +-
> >  4 files changed, 27 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index daa92a58585d..1b03297f13dc 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -921,6 +921,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
> >  #define PVMW_SYNC		(1 << 0)
> >  /* Look for migration entries rather than present PTEs */
> >  #define PVMW_MIGRATION		(1 << 1)
> > +/* pvmw::pfn is a device private offset */
> > +#define PVMW_DEVICE_PRIVATE	(1 << 2)
> >  
> >  /* Result flags */
> >  
> > @@ -939,14 +941,32 @@ struct page_vma_mapped_walk {
> >  	unsigned int flags;
> >  };
> >  
> > +static inline unsigned long page_vma_walk_flags(const struct folio *folio,
> > +						unsigned long flags)
> > +{
> > +	if (folio_is_device_private(folio))
> > +		return flags | PVMW_DEVICE_PRIVATE;
> > +	return flags;
> > +}
> > +
> > +static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
> > +{
> > +	return folio_pfn(folio);
> > +}
> > +
> > +static inline struct folio *page_vma_walk_pfn_to_folio(struct page_vma_mapped_walk *pvmw)
> > +{
> > +	return pfn_folio(pvmw->pfn);
> > +}
> > +
> >  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
> >  	struct page_vma_mapped_walk name = {				\
> > -		.pfn = folio_pfn(_folio),				\
> > +		.pfn = folio_page_vma_walk_pfn(_folio),			\
> >  		.nr_pages = folio_nr_pages(_folio),			\
> >  		.pgoff = folio_pgoff(_folio),				\
> >  		.vma = _vma,						\
> >  		.address = _address,					\
> > -		.flags = _flags,					\
> > +		.flags = page_vma_walk_flags(_folio, _flags),		\
> >  	}
> 
> That's all rather horrible ...
> 
> 
> I was asking myself recently, why something that is called
> "page_vma_mapped_walk" consume a pfn. It's just a horrible interface.

I don't disagree, and in fact it used to consume a page until 2aff7a4755be ("mm:
Convert page_vma_mapped_walk to work on PFNs"). If this was a page it would
basically resolve all the hackiness of this patch because we would no longer
have to pass PFN context around. So I wonder if there would be any opposition to
changing this back to taking a page?

> 
> 
> * DEFINE_FOLIO_VMA_WALK() users obviously receive a folio.
> * mm/migrate_device.c just abuses page_vma_mapped_walk() to make
>   set_pmd_migration_entry() work. But we have a folio.
> * page_mapped_in_vma() has a page/folio.
> 
> mapping_wrprotect_range_one() and pfn_mkclean_range() are the real
> issues. They all end up calling page_vma_mkclean_one(), which does not
> operate on pages/folios.
> 
> Ideally, the odd pfn case would use it's own simplified infrastructure.
> 
> 
> So, could we simply add a folio+page pointer in case we have one, and
> use that one if set, leaving leaving the pfn unset?
> 
> Then, the pfn would only be set for the
> mapping_wrprotect_range_one/pfn_mkclean_range case. I don't think
> device-private folios would ever have to mess with that.
> 
> 
> Then, you just always have a folio+page and don't even have to worry
> about the pfn?

That sounds reasonable to me. We were hesitant to add a page back to the
interface given it had been removed previously but lets try implementing this to
see what it looks like.

 - Alistair

> -- 
> Cheers,
> 
> David


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AAEC606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rYqL89KQ
Received: by kanga.kvack.org (Postfix)
	id 859546B06C3; Thu, 19 Nov 2026 17:31:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A8A6B06FA; Thu, 19 Nov 2026 17:31:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1D56B06FB; Thu, 19 Nov 2026 17:31:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAB96B06C3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:31:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2430A8AD3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:31:37 +0000 (UTC)
X-FDA: 85453316634.30.72D1E87
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05091140009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:31:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=rYqL89KQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795127495;
	b=ylQVrsS9G6xFElfUTJN39sGOGuBrKdbSJ6++SrMvDZ+XAo/NB7yJs4j9eCMWQH/tzc5hSg
	SHAVd3zVZjRdKrMePqbIZGwahePMrQInwQxJoAj5+drU+QZFb7Mp0XqwtU34vBKHQGoU1D
	odNPxqhsh22nv5dUaOSZr9lpMuXwGkI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795127495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIRY6igsAmZBrJsLLFqYsgnlH3phyKo9jDP8D0q5DhA=;
	b=bmkWG5d+hqxD3OQgxuSVlKRKDVZDMbKEFK+PaXhJme48a/grb89M45aDbq+pZqA5UA32x+
	nhbAAeSsrWg1DcXrV1Cm6S6LXFiE6LiA7ES5MKWvwg4dt9IVkemD/T86eVs+xfnA4VUPiS
	VFFLVBrzF1PdVvFHDNUCpHoNN0mRn0I=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=rYqL89KQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nAejj3H3aybbcpIyijgjVzBll2iWkhwd8PMrGxvjAIyglACtFkrofopiRTWQ1z2clPAK7VOwGCddtj+PYg8s/U+9yhNaA54T/TlTwbdZYkxQLUXwyDY3xshE4MlDpviEHqCn+h98etr4nx5ZgmQCF6t0MO3DczNWf+IUKJhpdGmOJn+x9XGoC7aYzL+uT2dYGYVjae/BxvelkVCoCZZ3Qu51S98kwG8Ab/vvT+EJL1+JLrVCkwasDKKCNM7uPks34MXoU2EBzlsk89C+Y5v+XoMrsxDcfkFoWHG7douKBlSmAW83vZ3PNprXbN0MkupIFbYFMR6yTT1iHmJ6xEyiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIRY6igsAmZBrJsLLFqYsgnlH3phyKo9jDP8D0q5DhA=;
 b=lFCgJR332hLeeOKT/HMIU63sNYjsXc03xEZQ5UPGIkhy9kDVCbPKgvOKAF+ruHAjzTe3TL1Siri0A/Am0wn+HDmd6G0dTMzWZXBqUYGWSor/KbsVNNyF/o7KN2vMItfL0akXzg5+Gse8WZIODSxnAizOqohtiEDWelAKNgZp+avmrb1N4FNVq+kYemzmPEJM/jbh1NaP9g0DdrICw1vDv2/V92tQ4Wy9TcpBbj8vVgbE4NaAnvtZZKf748ugkAn4YxeoYXdHgLg8JPMlyIYj1uH+vyzKXIjfWWmzYNVJEGpSm0crJjHrv8hXEeqqW0Pm7Fo3zzUg2IaZmi8m7yiZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIRY6igsAmZBrJsLLFqYsgnlH3phyKo9jDP8D0q5DhA=;
 b=rYqL89KQqFD3ZXiMSa4gX61bQkFX1eRAbBmLQmyvuLsfQU3GQgSTd01xHG9dsZVyDJljgz0XWD2ChXnhBMMoxMKcB3WxRRM8gepb0m4Xqx6UNZqsGWphbo0D2/lUC5v545ib1zznUDFcw5HYCjLd1tPYBV40GBJRC+0XP8QJB1XxAOOBct2dGuWyprRwD8fXHiqR/vsDbrxGH6IlSnyINaPHeSln+YE0M/SDX/YhsRPmCrlafCBmwXyVX3ShKqM9BdU6omtaKwPaNb6RHn9USaklSBhYghWm/itQrM1pMgIfqZBfBHL9wYm6VLqsT85OyPWLsx25J5UktnK80nDrTg==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by DS4PR12MB248322.namprd12.prod.outlook.com
 (2603:10b6:8:509::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 22:31:28 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 22:31:28 +0000
Date: Fri, 20 Nov 2026 09:31:23 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, jgg@ziepe.ca, leon@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, balbirs@nvidia.com
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
Message-ID: <av94SXo6ZAU7Z5TR@nvdebian.thelocal>
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119133955.54001-1-zenghui.yu@linux.dev>
X-ClientProxiedBy: SY5P282CA0029.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::11) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|DS4PR12MB248322:EE_
X-MS-Office365-Filtering-Correlation-Id: 5472758f-5c5d-4186-969c-08df468cda89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|11063799006|261021121427099003|261009223027099003|10067099003|261102123227099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261021123027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	8lIWj5T3tE85LGePevXd+FncPkeTTgVXaindUY9+oC9v+sRCbGNaT0LlUukvT8FZkxpNZxTizPRuxK8v7CmqOvv5mnj1ZvR5bW/47F+y164cN5h5wIlL0IeJ4EyzUghdBs7a1OEnKUDke8k+oe5W6/YgfVosX1m70VScyMXY7CK2eV5tH2s7sDxlRw69WGB2AGLJU0ygoT9SurQtnj1UG6Gbm9w3Vphgy7FL31u81rmSv+5MZeCYNwDe2mCGsb0vNdeJdnnoebsH41Uhs+U1EaJ1ZezwWKO83Fy5wCanFnja2F/+G6hZhHjE++ccv6q/e3BTD9b1YrPRhAoGa8Gc4TtTNdqR0lRliiOm2rGRviQ88AeiXB7LwbQ8R+vvhm7Gyd37iGQbKldEAXpxMbSOtGY/TRAbuEE8g+0jBkm2F7nk6Uqu8m7At2LQUqUSasa4AqzsEBApBAcz9bIfvjJA9ij8yVeP/fHciQANLkTlR6xpAIoj0fs5HaCD/00TAIml7sRZjO4jzfOh0wBlQloRPUsh5A4is5fPHrt6BkxNGQdt0tEnjir6Pf3SIH0sM/spD67oHuHyKN8Na9PS54LdA1W89cFYnwpba0EY7mT7XIumZeNzqa9QrhYzyIpsAZJ1SHjCDbIh+3nf4KYD2dFnyFd5jB+BFw8Kd7BiL5F7wXs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(261021121427099003)(261009223027099003)(10067099003)(261102123227099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021123027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mDD5BqIkp9CYlxqZRvNj87rk21WnW0lKoSzO2GOO99QSFK4GeGP6/n3/7Opd?=
 =?us-ascii?Q?Iwd4rCRBmsDmQzVHyUqVuWJcLsAp2Z0L7hWU769C1KX+Xs0Ik0VMLO2Datax?=
 =?us-ascii?Q?HzBaQvWGsAxFhEqMmmPhruf1HgKOO6yGiyp0YiqS0VlAsg7kQLh0TB6ZgfQr?=
 =?us-ascii?Q?g1P9VG0qumLP5rZupcY0LfYgDKB9GyttAjaCvarVgSRCG1OpUfqY7P9aatt/?=
 =?us-ascii?Q?r/0f2/yVz3M1OIDhis6FfwW6Svr5MYui661bx8tfZvjZWz1klnGIxq7uSgMP?=
 =?us-ascii?Q?AKGsL+qhYGAgAiZNhAsrnKK+lBWcxH34BwpbbxY6tsLMNOnwMy5IDkVX3Qdy?=
 =?us-ascii?Q?SxDM7S6EIEJKCD+uZ/mVl3tBzP3qYO+Ky1qgBzvm04+yrghyNJHb0vS6Zywx?=
 =?us-ascii?Q?AUR13I/QfEPmNzUyiTRFKHm/XP3hV2zOh+7cihPte+EeTc396jHxgwoxsiKQ?=
 =?us-ascii?Q?W0+AHD/n3K+eFJfCImtTi6nRurCh/++6XcZ4gYKn8g2G8FtkVZFFd9hIoKY+?=
 =?us-ascii?Q?72b1QqUdI4vGlLmCTC+2gD4Rwm3YBuyHPP6/uTsBrSI0yQjRYZl1p5jtQaoa?=
 =?us-ascii?Q?I1OpUtQzQU7LbtMX/UCMm7tp+U/Xf1t27gdKb6hCKOb52/GAupSBATJxBFFO?=
 =?us-ascii?Q?pCaZQE3hNWviQnKwTgfEVKzfvMUDWozv8F3nwCopK5WiVEPspTg3cTPtzIKy?=
 =?us-ascii?Q?gDiGjAmpuA6BQs8bwVufZlCAirDOP1Y3PO6N+OIEwynz2/Uc2owxWIXegM1W?=
 =?us-ascii?Q?hBMRVx/2fnZxD7gkt4zZ0ZyTDA5YQ+dWfpq9a8H9MNfC6a7bqjw+qyV8MY5l?=
 =?us-ascii?Q?BRkyqWLeCfEpmx1OsPwxC7HpR4s2iTFVbVN10Oh5vh5WGwIJi8FySf73DsfD?=
 =?us-ascii?Q?0DozBlgwvCO8RO9mtD+LsDP8fVo/abhfujrGEyxeM9+m2kU/1q2J55d3iJn0?=
 =?us-ascii?Q?OUHvaaJGt8m3ABdfhF0Tgwwes0jtj+9OxDdAXmGEssWEWuAC5gYpUp61WcmD?=
 =?us-ascii?Q?Dg215E0GSiJIUkHMq257HPWhJK4bduhbmuR7t7dT3PUr3wtJLwxOZxPvN8LC?=
 =?us-ascii?Q?YhE0FeA/C7zHChY+aYDeMKsO1v23P75Yae+DsHHZwP3+10MaXbkP/t8mQvtt?=
 =?us-ascii?Q?vaN8Fy/kEfkogOIKnCpdWYmYm2weDrlt56eJg3yTyIanN0faC/AZkeMMflvR?=
 =?us-ascii?Q?fX0vXZ0Ec2yECXcdoW4ejg/hpMRdoxid6rPOLO0wltRlyqAMo7zNvEx2jlFB?=
 =?us-ascii?Q?mGS5CyzwBDQcY/XmW6RciL989BebChLwfCfEvpJVBg8jGn4sRuWvAO283Lne?=
 =?us-ascii?Q?tA61epJ/CPI5ZuqjOm204IylWttbXvBp0JtX9G4FEr1k6QegdWZ2K13ePSFj?=
 =?us-ascii?Q?sMef3Wdf3NLUwB0FsEugrlwzhSFDGe2zB4qhpHingPGM6AjRogOXd0izCUF9?=
 =?us-ascii?Q?Lrz9SGWmAS1y9nq+Fi7iX9HuVyY77s3guXF0kA1z7uyNSw4RUpLp0RE4gu1a?=
 =?us-ascii?Q?hdx2QqpTcMHpzEITeWDyExNzoEOjSi3Nkp0q8rtdPAw9akpuVbCK1dG2H84Q?=
 =?us-ascii?Q?F69vrqrWn+lZ7LfNZl/aNIGET8eokaQ1lwhzs+RTye9rQx0a0dj4lIrr6maO?=
 =?us-ascii?Q?o8l5MHigVYz3ap0MgPTsc0rw4EGF3eH75/th1EpiDY3NLk5ej9tqijLpXaqy?=
 =?us-ascii?Q?1n/c27bNwI2qk57AuMqa8UmZfTwFhnuTp9vJ7l84mP2ex6CzxFLgnlgs8kgx?=
 =?us-ascii?Q?KLu/Fq+40g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5472758f-5c5d-4186-969c-08df468cda89
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 22:31:28.6897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MapFrgqfjuZQ56ySI/0UyuvM7n2dThxvHObJNT0aGJtCyquktxqMeCTXX36FJQOmySOJAYoDQ9pcuM6F3QtJBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB248322
X-Rspam-User:
X-Stat-Signature: tnwh6199wm3pdfebfo5z7pn7b4qgdmd3
X-Rspamd-Queue-Id: 05091140009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795127494-578304
X-HE-Meta: U2FsdGVkX19eYgzrDoCMNkq2JP3AZzT/C1lqoiMeE2RmRznfjOebTPUXil/J8ZENk48OjyJzY9uEZNQsP2+OJUb5O86O2M2XgXQ4G7EI8jDidLejh9n0SQb9Iy5wTDgaoXntAh8b/F/ts23VdHKW58pf3ZQ+98xfoy41+nlMkLsFthjQyvSmQhf72fTcZrqRDb1NIsth+9JCuCJKQXEbwigANubIpLpDOp/M/huMVnVVRMa83ikD18k/rHRSewmaZggbfRJQD1L3f7T+fHlnMFojp7/1OX5+aj0m/V2fDdYgAtvV5vJEEnBZqhVxgF0DsR7S/7KT2hGdjudxmBHhTNtg2mwqi6xqEs5ywjsjvAbjIwim4HPzKZWi9J2I07JSl2pgPfISQCSJiY1ZzWE+SKWxV6rPcc85uujobwQmemIoE1yudeGv/ZlNVhfJwlLno3vbDQBY5GvvTQhop0102BZUC6SUt2r9baKuGemvmTPZUZIy+Aahx+kDa4FD9VdH8h+vK4aocxSIEyaFIthMpH2MKhk/47lCo4gKLQEgocnjxtK3eU7hAjGIucuJl7dLFdn30WReU8MCWqTMNBzQEpdIvsb3bqp8pLLi1kf2S+S3xaIhJVRv/3mu8lW4SVLLxuKuc+4k3dvk0PCecySGQC8KoaDEqV46e9uH9t9AiSZgxVfQgUo4vc4ftOPJZBvXpVU08L8tWKTdTVrjLGnEtmPBeCEtveQ4eOauDpR5EvJHjLjg2eJHE7Q8g02ebaCl9bWWOuRFm+90Uhh/H2gRNomQXXKM5Uhd/k9VhTfR5mSp61SGoF6V6U7mN4zsTOtdSSgOQ/hg07+PKeuDJw//qHO/48k6d8nSA/qQF4vgt512VVLKYXiunlhZUVtPVTp1jhuEMyrjl9wqokX76CRfq8voFmAj9F2SFjbwkb+4EH1o8iflr9FA+B65IXykqeQhfwz+clYNI8dU51iNFuP
 odOqhvy/
 YVfMZshGTccG9dERhHdwigOKfuyomznz2jy/UhkyegQ7/5GpwMc9z/MREFvsedz0DJMiMWHqOHmZR8EPhic3rTevOvgDdnXd+Cn+6RXQJDFd0KslqszmujhP4E1w0jWtkb2R4wtRIV3+73NEa1hYfzzuZKOq1TBpjkN2ESS6bBf5qTHRTMsQVA2xvXyRb/P0JnvXnGpXUICVW5vO7V97IZfpZARSawrwnYze8ghoEQI3LJIU93vTS9Gvn2gXrACOosAz5OaKa6AoKJw4LK8HKk9LX/fI2BAjOcURm+wy69ge+rO4DApnPCfXJ2DSucRam2/Xs1vTo8CaziRp26m3RMl0M1ScinYv3KLSpPVLJ4cbtX3Ti5tigegxvJcXY6JLSDU4XjNvUqCGeSju3+tDzR/F1zlZKmI27UFNxItIYNbP1aBaZQwMMaCzXFKAg21GC2O6fZolz7hRj7G68rBLUXpYSmZ7/JQ/Rq01ebfW0bFzIX3q3b8ewU+7UNzzc5OT3rdolAiEPzpRrPTy4Bm2g65XSZVts4w02dEANIpNbwkWkMXE2djZ4zyHqS+/isYOg8zMqqF6J8ecgYxu1wi4oEMHRPNpEUS/CvN8WFAEPGpqVATYiOsunm8l+Y2as2bO8pN7yzFTcH4cKrQlK001p+t4y3YelFFdtpLqI9bX0RnaJG61nFpktmQ1caIZJMfHD7MwzFcZgPt0n3+eaEFnG6HIAhsbguTpJ99Iy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 at 00:39 +1100, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> migrate_remap_fault sizes its working set from the PMD page size and runs
> 24 combinations of migration/mremap parameters.  On arm64 with 64K base
> pages the PMD size is 512MB, so the test churns through tens of gigabytes
> of memory and takes ~32 seconds on my test machine.  This just exceeds the
> kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
> and the test gets killed with "Test terminated by timeout" even though it
> is making steady progress.
> 
> Raise the timeout to 120 seconds via TEST_F_TIMEOUT, so that the test can
> run to completion on configurations with large PMD sizes.

I guess the alternative is to reduce the number of test combinations, but that
seems like it would reduce coverage so this seems reasonable. Adding Balbir to
CC in case he has thoughts though.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e5f273ca84c1..840015cdd209 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2221,7 +2221,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
>  	}
>  }
>  
> -TEST_F(hmm, migrate_remap_fault)
> +TEST_F_TIMEOUT(hmm, migrate_remap_fault, 120)
>  {
>  	struct hmm_buffer *buffer;
>  	unsigned long npages;
> -- 
> 2.56.0
> 
> 


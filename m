Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF711D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0E56B03BC; Tue, 20 Jan 2026 05:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381456B03BE; Tue, 20 Jan 2026 05:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2459E6B03BF; Tue, 20 Jan 2026 05:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12A7B6B03BC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:42:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C832889D30
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:42:10 +0000 (UTC)
X-FDA: 84352002420.17.F4D5D36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6783A20006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:42:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hZrBMaDe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mGuHkhlx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J259To/lhGde0Bbx1G4K4T+GkjJFMd/19po92hVhOaA=;
	b=3HHcOaqDv4xE0rUowRdP3AIGVwG+maWNJkjIcy+HmlxoRyXC9hrU8fyBipsZRBQ4p/6M+0
	uJJq5drXVUy64fPYp0SVcL943R9bOLPw6DPJEc969BBKSS6Lg2CixKVGpVgyPgdpl4CxMb
	rOKdu211xg0/UGyMmgVwmPBP2kIeoQs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hZrBMaDe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mGuHkhlx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768905727; a=rsa-sha256;
	cv=pass;
	b=z4RaZLm6WUPVrey0/XNiCHs40E0qMLjAsJeLJ/ITKxvl/IDx2UgJxYKxiZdtNLz2tx509d
	cnxi4pGebw06oy72n3PHdZFhWbZO8LpxsiktcbSifGLEZUAi3pupUHPDGM1j383wIrDvAz
	7qvA8xSodKXsZGODrjX2Y6V4XrGS0WU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7ushc3264931;
	Tue, 20 Jan 2026 10:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J259To/lhGde0Bbx1G
	4K4T+GkjJFMd/19po92hVhOaA=; b=hZrBMaDebdfGbNJgBEAvs6rkaiCIRl0aw9
	mYH6oYWgxvBzlbuyLbXDOFBsSuA5QKxAIGSeLSOGZJnOsr4eTGUrqhuBOdFXNyxr
	QbwspEEhuSo1ue6GVwYhTAsojqiauwApAmtNeGxLcarb5zz3h0ZqkKH9ZlfmTXfV
	pqRbahRhzw3mDmQgFvIH10R7ywt+xrbQ5x2PuQW4FTx6jO5hYzqTUahvIvXbvAqG
	KTqwGZhnUQiP2+MFZxrzkrYThFfxAZCnMEQ7Ba8FOWZSngA8QNLO3alpC2ce5r9D
	lJT5yB7WrK5XKP3z/3QdRbY0Mj7YFEOCGGtSd82C2Q9kA+gJ4O2A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8bdha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 10:41:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K99ilB038724;
	Tue, 20 Jan 2026 10:41:57 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9eqgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 10:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/MorbngOQ7Wsd3WqII7xT4UpQFsoJEOgSpIZ+5voiyeyXKsEw2AIEbmw+abnRIjaIgYd17/wEEtLps7QCKvjByOu7+Wmqom7mG550jax9KZ1S3QOhid8ppwc3uJvh5IyT51zv0JDIGf0VPAMupXqOuZlw+BGDsTWs50X8MRtjxor8RsB9nspV+f759HG6te3acLNGLZUKHPBbpiQo1UacfrZkKXd+VLSmk0z+WbTn18jW9sILazl9aMWBNpTw0q4W3FWzY/nsi9uVRTair+V0gyvble6zLfX776kolDLIdd1v4leabRDbWhn1bLYcO7U7gXmnnNqhv1iM6SqY6e/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J259To/lhGde0Bbx1G4K4T+GkjJFMd/19po92hVhOaA=;
 b=g0ttxocjH0JgRw8zQmhnBrP+Z6y++6nVuu6h6uSnj5UpPuZweHxr3pOOKjvefLeHNvBpCGhk15U3c9YbIw/R73QAebZ70Fn7J2n6vcfBcqkzbPM9eZsNjgKPDZEPAXEGEooCJiLk+s7jiJ+hmzhlE7B1fs/r7YQ2sYl+NRfg+LmHNea/CgQzrKFUtocSome+0XDpIX26ER07ktMW90SaB/c7Z+4eLKS1H1M6/swySAgXOrbM68PLvDFy8+u8gdU4ZrI4+ZxIHLxWpj7bKwUcyjZGZUu0zoXCMLjg7287H61XBKkIeUKWwNTyQUFGez7UoQfIaQ9eTV4bIOx+oOk93w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J259To/lhGde0Bbx1G4K4T+GkjJFMd/19po92hVhOaA=;
 b=mGuHkhlx28JEpa7OlJAOnkmpGCLSuRnOXGk4gAHMIpQs2WMfse0RQOUlNLiEjJAL66bU7S0ypxrEz1HiKpded/PrKtMQ6DdRmeAFg1Ob7c0PJ+84CyBKsD3WdaKKKNHEk0bFN85wuW3FUWGWQM3gpJoVA1dEuIuQZvUn5PoHz2o=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM3PPF120DC3FA4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c09) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Tue, 20 Jan
 2026 10:41:54 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 10:41:54 +0000
Date: Tue, 20 Jan 2026 10:41:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zenghongling <zenghongling@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        zhongling0719@126.com
Subject: Re: [PATCH] mm/pagewalk: use min() to simplify the code
Message-ID: <bc9a831a-f677-46c9-a876-6e313f2094a3@lucifer.local>
References: <20260120094932.183697-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120094932.183697-1-zenghongling@kylinos.cn>
X-ClientProxiedBy: LO4P265CA0203.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM3PPF120DC3FA4:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6a0f3c-b3d4-4ae9-d033-08de5810874e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X70P2USZ34SjO1g0NRm4vCUOMCqLrqHha6aKhne7W0RZFo16cyLP40rYEdhK?=
 =?us-ascii?Q?XymIYLBhe35LlBLzoOvIxdXxSXdTjY8wgD0D74vk+qQCenCSsYON4eu6rcWQ?=
 =?us-ascii?Q?isNupsj+k+ppceNrlm+2kxWwqmbOvVNiEvc1DliMYBy4YAZELm3eHbVHfrNu?=
 =?us-ascii?Q?/kKNKd0jFCCHcgcgBdv2a4awSkxpG2//6Ff5ysHOLaD9syu13eJ36H4QZJpa?=
 =?us-ascii?Q?N4iecCR4ML0dgfSHunSYtcx9Rr2cKshhbzf9hV15+DasAttHqgkahCLD5ojO?=
 =?us-ascii?Q?0axGAvyzdTifhqG20TjcAaWyN/l1eOlp+Vbhhu10dAQCllMCBqOWfcfkRcgq?=
 =?us-ascii?Q?N1CvVamEN+7FTKYr4z7yeq/WurbtK0xRwYP9Ab5m2uSU6yPyKF0zW0RuZs1X?=
 =?us-ascii?Q?DKJkM4rWptaYO3rnXbZN4ROn1cxVFs0xSCDSnmmhNU2+dZPtp0QLYvEXHuZF?=
 =?us-ascii?Q?5YNe9HHZyVCpzeO/sANFkYGi2ihHb43EKTGpORfhvweKEgTxC+28xywmV+Sp?=
 =?us-ascii?Q?ruSQ/rsUihVsQR/lr+Wujgns75LrMAvuNvYlN/i4rfj21+Q0dZ3ZOa2qYr7I?=
 =?us-ascii?Q?xH+muDUV46B5W52tpw5bxT+2Lj12fdKzua530o/Dj0yhiDmfpMR5X9227N2z?=
 =?us-ascii?Q?8O/NSRwm0DlnbsSpdyhlBXdED/odAlTWpEL+hcHFZKgRwLPMuouALHZypt4I?=
 =?us-ascii?Q?IGMVTfpdf5/FDKQ7nNgl5griVJJ817AkT9VwDl/53PPHhKEupKkwfmaSo7hW?=
 =?us-ascii?Q?ZEZSJFKKRHdNNeetlsHdNwVlSYO+3BpKKjRkIY9/zQk2YwHWbiICb1L5supe?=
 =?us-ascii?Q?rkrMB7IZ1r5poH3UixKoXPtPLySroZgj2/nBBCPulQNECefMIHe/pN1h7VoV?=
 =?us-ascii?Q?18gtvQ8vCF+ZZstfBruyXEhsCvPDbzthORJk98o1HWhBjJ5V2RmFYpw4kQny?=
 =?us-ascii?Q?wQeiJts323Cz9cDRMoLNyMih3CdG5BLqh8g8OESEF0ZY+fXy2wOKYspYmB8P?=
 =?us-ascii?Q?URppvtodG0VJHzn+kEubfgzZX2stni8F/DrG8GXXxxMT/B59Ky69L0+ebTAk?=
 =?us-ascii?Q?tSNYw+wJ/M05HpJmuh89ETTekTPfzbbqakuwqOps1yv7qEC4x22bLKs1Dsyk?=
 =?us-ascii?Q?0gGVMgXFyK7OFTHXWF32qyTp6vXU7JG8ffEXs4UzUkLhXHt6j9W0nvuCMVQS?=
 =?us-ascii?Q?Aji7DjCLRhQszkubKfUSYLTCAgoQs19KKtryO6EUe/kOhhtj1zXRnR7LlkJG?=
 =?us-ascii?Q?58dlvp/k61amfUSJBKBff8n5c+tHoY//VVl98xnwBX37MwTHDWxph3Hnp7P9?=
 =?us-ascii?Q?XbbSOlXOtiQPO/9l/uCAE6CTpEry12IsqSDoM6YDICWWifMd4K6o3h55Nm6u?=
 =?us-ascii?Q?b7VHenxOo1ULde5uJz22zl8ngA/QKWb9I0IUBDXIS5lqzMkc1kG7fzA4QE3k?=
 =?us-ascii?Q?8T4WJcNLT8seiVU5syazjGeJRNKiEsJmEMgfmdzjtVFm/JsN5ef/oLIjRI+F?=
 =?us-ascii?Q?y9iWtmKrLvnQaMUShem+2ddxxjTha16YKrd1beIVfG274rAtlyNJRLvU1KS6?=
 =?us-ascii?Q?CeO+TiFBuICdSZUHyjk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mk1v/LkLbSd1k2lUSKgcg/cvQrPAg9fRCpyw+PTwhwgo9aiC78p7oT6F2rSx?=
 =?us-ascii?Q?UoDisWuEQAZDzEAXh33QrftzOK/yKHUJI4G9/Pt+QvLi9Z3HC93ptYyJH2GL?=
 =?us-ascii?Q?+llnqOCEsJxZf3RhgNznjKyNLKP6G+lhGDTggFClnt68D+o9KXnavkjufZZp?=
 =?us-ascii?Q?3J0ElP2V8iBvYfjsV1fnguMn2grKSz7De26LFtqGwjUsMty7LOQAoP9Ka+QT?=
 =?us-ascii?Q?xJHGKLU6TA6vnOhF7z6ielAH7J9hz2SDtxWYCcU35rh7rJ+iWPYk5lCNZlDz?=
 =?us-ascii?Q?sKuPf85FgMMJHbzoFtDehqsL/h64roELgBqJWPi3Nn7usjF4zVG5fspbpGMG?=
 =?us-ascii?Q?L92VQDezfRyti4IEZr7LudV6P6PQNKTL3pVg8v/7rbNiVmp4GSP2OYjjIEMg?=
 =?us-ascii?Q?fwsqoz5K5YCw/vzC5ykDZ5aTOmR5RtUW5Ke5HClmK/epiy3rcJSExmHeEk5J?=
 =?us-ascii?Q?KgmObq7fRrAgPsL0m+iqfNpt2DBXWSLM6CEpXjH2txhFwU4vgPW2jFSPYn1z?=
 =?us-ascii?Q?tnZU1tg5rGYNx4a20z5N+a9ith0+IBlZF8m1n7xS6tvrf8/BnAmkJ5ni2XZz?=
 =?us-ascii?Q?cFsMZHrzeVU0G7Q0+9urobX+3fjJ4IIxcq4VXrmXzfniYikLnJ7FaoQpSeoZ?=
 =?us-ascii?Q?h6B3W8CXJ7lx8ggV5mj0xKityUM85CUo0LXaMQHwbDS+7J66ckEEYdu7RwhA?=
 =?us-ascii?Q?GzCxj+VnAywmnEF2Yns+rukllPX+QESrR9+FxIt/3ns4ehz74RxDsh8fcpwr?=
 =?us-ascii?Q?6gPhxaC/Pvx2H/VjaH6m6TMF+kp1Wjn3IayrHvwJaXOUKuaz9uRyBZCG33Ox?=
 =?us-ascii?Q?Q6kpTTyEkHYWdfQOwjI8Pa5xWHR6dJBwdu/8SHPIjJgYPMErcYN9+CFkhU8+?=
 =?us-ascii?Q?s5E4BHF8culV6ZG++MJty+cZrEQykkYNm9vRTDf2tJmEiQn2czq+r/6rO5jT?=
 =?us-ascii?Q?iWOuGqtQXN7BW5y/gvNa63QBsGrAgQtSwRiPMQnnYuBzhTmlEO8Pa0KKZSIw?=
 =?us-ascii?Q?peocrDpMlk35YJdsEghP7YT2Tx039gz/wfXXV3UQra5ougmsbF/C8SUnpaQP?=
 =?us-ascii?Q?jdo5TDENWQUJsR2+KfQnsVRPyXMf9V9Cf7JzKU1aO+2dV6Jn5mOSjziMObSs?=
 =?us-ascii?Q?9aseaXx4lkQKXEIWoOcrMRSd6FH13bml7ZPyINxlGF43Pcq+NrhjanEfgwxS?=
 =?us-ascii?Q?LwNC3uorptJ9lFEwdgqt0ItG4xZKJJo3XxFEAiNw2BG3Yqj/+BT108W4a8Gq?=
 =?us-ascii?Q?0E2zFwBXGzqrFfgtXacDtgqCGfaDhU/ungT6a04s8tDkRisxC81CkVwlenPs?=
 =?us-ascii?Q?2vRy3X47S8WBleeIjLJNn1WNux1/ttQ67hQ6Zq8hwxiBtbrqDB29ZCBtgHwG?=
 =?us-ascii?Q?UqIz70gKYVEYrRYtj0zbMHYZh8I1D5swpJ0rVYqy69MEdjbDKv5IUbW9pOQT?=
 =?us-ascii?Q?yMkwr2UTdcBFzD1X0Hy42/t5Boc88Wu3A2iYNU+IrwoLdO2bvpsupRFrmnHi?=
 =?us-ascii?Q?z99d6G+VVIi1vMMpFDtn6x9VZMJY1geWkT7ucHezN5GBceWJ2QamMQMDakbD?=
 =?us-ascii?Q?LRclxtUcTScgqlLwvBccFCuvTn1nlMAgxT6pQFN4VRkVMC8vMr0PTN4JiM7j?=
 =?us-ascii?Q?uvwW4GMbkCyqvXmp8oiSwLBiQixQ1i+TWu2Sj//tWQPIKld09s7wSgDchHzX?=
 =?us-ascii?Q?L8fKmmVF3FuT1PXABG3DzSta13Di7g+JyfkhqySk66Ezgfvz8Zr+Q0wTCYDs?=
 =?us-ascii?Q?U9brmiuNC2TK5g1y3OIS8q4ndXzFS8s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dmKJP093gStLMvDbarYNTnbDjXMN81OoQVHxspbuCw4gbzPbkuYspWX6cqQmCKflvnLN76bmgQcTSpvGj6r8GuGIweoa8gWqPhuDq787MQs1I9uD9U1XPkC16JS8287LNh9AyRRbMSgIIFxOIQwIf+A4k31qqy2bW+LqwNk3CuDvv2Amb/Q96CzeDq0i9EfpLXPbM40aOwSpv3AXES9s9SqhOb4N80lFV4QXsU9WqHGU4Bk7g9SbexZ2qGuEmr5utdrc4od36+jjfKltK5cKJ1V5A+CYWd/xcStqjnKz56VmBk4L85avDDMBfaqbhfKCv2dyME97pxhxbUIuZQzYB/kzi9tEWqLZ7fnJKgOJjnXHqcGifIE17i3T47aI13F4j+rxt4se7a9YPo5aG2T0lI6fIqeFF2rVb4zyMFvtVy7x0qsg1+u9LT8uvmBuu2nU07VatF1CxjSR0PYOujGaH3NbKdFZ3guNSUYTZeQopk57gF2/o+ZGK+DFb8IsoqIYrIfal4HT4VOqEr7vmtqBLucRpDGWq/BRSNzNTo0RY6oc7mxfiWqEQvfMuztHwZdoM70S2EnStjSq4bjHuSsQTVxT0k9nUDaTHhAcGtCbcEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6a0f3c-b3d4-4ae9-d033-08de5810874e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 10:41:54.6907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efHsV12QV9YZWU78UceCyQPpN+nHSEi4ZNiqeaCnH8sDzcXPV6nKwDSwtLJ0vnJGD9hxwxsq1UW+a8KkuwwMwrWXbzxTjGLMMRvI3BZOjZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF120DC3FA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200088
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696f5bf6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ig5Eg0EmgIRL6cjrcrUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA4OSBTYWx0ZWRfXwLwG6Y8MeUby
 E+d5E7ULFUzB2ijJBVh1Y6sWvYlUtHzKW9pFzbs6PielfRevlXa+mIVM7QMBUADOztEKP3qmPbD
 vov1kZkHzE/XTfP17j6K2BbGAhgbM/aFk5I0Gy+Gr7ja0+GvJEZAgizu5pCXkNNbEFIFFPKnl97
 ylUYdmi/zPCfXtRnntEPgF6Op8QPGpf5i18d+03SiJo+EuTJ5NzZhmOgvMA5ZEQtKhKyzXMORi5
 PpcWFn00UH5Hju0QIXLH1U3clC11NkBKGFWVkBswpIUlq3QWVecjQnrpqvjvHP7jhTEPdW1HTA3
 0aMcXLW2RD+OX2m1+mOATCvt0e3cweEwn3Xv/sd7CE2o1KQEHHL8NKPusmN7z/ZE9C8tU91JYBQ
 eQt0Y0hvjRMoJG2z5SIqr3N0sCRklp/1rX1Gj1FmuoZzZm4Y7R45fgUFBSWKygCZ80u2tg1NWCf
 16ejRllQOXdFyf1PdfA==
X-Proofpoint-ORIG-GUID: OBhaXy9ll2cWenKIzpXGXCVZqZmVVeRo
X-Proofpoint-GUID: OBhaXy9ll2cWenKIzpXGXCVZqZmVVeRo
X-Rspam-User: 
X-Stat-Signature: ffuxo6yhifp6n61dsu38wqtzw6s1tau6
X-Rspamd-Queue-Id: 6783A20006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768905727-73744
X-HE-Meta: U2FsdGVkX1/j/f8jkrI/gxrP+jtpeAcD58YV8aGqYJjnX8FmiMqlfk5uws2uu8JR78ujIdUWpAiqI+NuKId8xNw1JaaPtEWaT2RRSpfOLItvyzd/iUf8Ind73n6zcS7cTByYq7iZ2JMBU/ypkkjnQXEbMAkofejJgKx+obf+yzIOSwLZhHaN0IN2liBSw4JNtNT3r4pcqyqKaA5kKQEpxaVCWopqjvZ0QTZMBe8zuPaNPJ7KbLHMr8NmMJRy1kVzAeyW1UvMZw7VdCXVLRM5pzslqkrX6+GQUkEuxCDXe6CvCwwjB51veo0LYV0DRDfrqscriwKTMC4Bt7iIHDrr5YpQQ6t7/+ITkG/J3OAUh/SAcyBGs43Y+nFf1VbMflZp1mEc72D8RxZceIW1tJy67R4f8OF0saztI4wEYNyP6nd38Ly72fZuHzQbcAx4BRPJ1odL1VMxDGM9d0sYyDUJVNir4ZnPBLWhBEau04haTTPEUVI7fgX8gGWv7nJw+IFg5uZINfiAODBX05bnFKJELcMS2451sG/icaHT/JUskS8OPyxGCo01B29FATMNNzRxhvZeQjwHJzinc63UaVYKorQ8qcAmXmmcnUE7ovPjAakloyQ/Jus+HYeiJtklpF3S2I6K+GUhUrmDJwQKVu16oJVg03Y1QvEnNiXAXqkp5ASS6VLssXJQ8zy6wkDvMxp2nUC5iYoPcAItsUDGvBR+/7xlZSXZv+xo7OIoHYrPrAgL8yrf6+Bmcii3e4dXPRwffS2+Pb4GaZqkMCRmWyH4vh3Rl4BqcUZ9oTuAEa2tWDRcf+rhYIFmopG/Alm2rcm3PZZMw+2dlVrdDQTxk82iiL24byA+i/M8fpg6nqiD6LqHUXScgxlsksk5Vmr3QhsNVbT+JazvoM+u2AydeF719UzWLRy409v78jY2S5TKRJEmndT7KHN+FToyn4UAPAkB0XKvxpOfXcr19caEWWJ
 Bq+1eaOv
 rf1UghDvzGXJfn1DINwzUaSGBBNOKM3tdrx4KsQzQtqVlJIJFQKhBEjCVtTsSiBklFqKE1eRyTDI3GBcA19/Mi/g1MRB4xzJrKvKFwD6TJinRMXBIzoQngMocNydKp3LK27DqHFA8MwiMfSLboNM7VHvaSEsP2gQiEZqYti92OH6jRI9Vt9IXEFYaCmT/jAHVBJUKXNkT8noKMi4HhTkqbuCQlvGrimq5UmKZpCFy3N3O0a/tMyGRL5xWSnhOoykAYKn0BXnbwP4TJib4muQWlxIprRCmi+i6kL7jScSPelqZ99VzWVrbOxL3jUQXIaKs0PRVbl6pphhV667jVqT2wYrIdqxogUHnbMTpv0AQPGBFNf4H2W5vBeWS/bFOvwHS5D864G3yUYaxM3X0YoJJeECATi4jJigvJCMNIRXGLNPoPOB4QEopuXeSNIHnnGmX4uE6LGnHIgqrUV83MupbwTRIhMfCZf3QYXnLnliCPWNI/JehVYzcx7atCimaKS7sshwQAX6Bcr4dK+ZA5Y3oqvftW5xcQGJ4lt1PVc4k8Z6uXCDIEiOKmdbALAUZEcKcxbCTqa4A1T5RJaBVnp5NVx+RK0AZBN04X4kP45fDcW/NZK8HfUBdhYoicJ6haZ4PotZCTgOPOD1wu6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 05:49:32PM +0800, zenghongling wrote:
> Use the min() macro to simplify the function and improve
> its readability.
>
> Signed-off-by: zenghongling <zenghongling@kylinos.cn>

LGTM, other than nit below (Andrew, maybe you can insert a newline there?) so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/pagewalk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..82db421b5b34 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>  				       unsigned long end)
>  {
>  	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);

Nit: Ideally we'd introduce a space between decl and statement below.

> -	return boundary < end ? boundary : end;
> +	return min(boundary, end);
>  }
>
>  static int walk_hugetlb_range(unsigned long addr, unsigned long end,
> --
> 2.25.1
>


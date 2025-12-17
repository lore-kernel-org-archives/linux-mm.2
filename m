Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F53FD6555F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036556B0005; Wed, 17 Dec 2025 07:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25F66B0089; Wed, 17 Dec 2025 07:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCD96B008A; Wed, 17 Dec 2025 07:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA0D76B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74BA8C0AD3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:28 +0000 (UTC)
X-FDA: 84228888576.10.712146D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B54040005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rKYOwrxl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dwoEBUoV;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974445; a=rsa-sha256;
	cv=pass;
	b=gwT0S4HrhNkhItsKTwHZV5EUMHv2ffN21VJRcuCTPIcH8wPiuXyFCAVbHfLpck7r0aKYpV
	5WENVJVulg8kpS43S+dV05oNV/9Q4e7XU/pqV5EK0UlbMSPQyMa/WROoomdJWH3nn+Eysq
	wRN0stqMQ8mVBegAGxyuRP5fmGFoCgU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rKYOwrxl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dwoEBUoV;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6EHIO0wz3ZYj+mIRk5zruCNcZdXJNE6VFgKef/P4aNk=;
	b=hLcCrA8zRVnxj8viE2mfiOHq/D8b+4lwTR5QYt+nEg/RpPXi6/zEnWWMNjgn/S57nfNYXh
	tuRZa2crSLVAeYpDk1wziuUC8lSIcYCCvBe7VxllREHFaSztRYbBQ6Ajkvqb68dmaxK+en
	F0ovw05s0XAqLe63rlKGp3kWUpQTBfw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6OMXU2145250;
	Wed, 17 Dec 2025 12:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=6EHIO0wz3ZYj+mIR
	k5zruCNcZdXJNE6VFgKef/P4aNk=; b=rKYOwrxlsNieXq3KkCQacUyMPL1GK3FV
	/EInJsySse+hixMq5QOIX4KY+RTi5TMc1QfmY8RX7nz51CW2Oq1ZU5ujMLxGBin6
	gtawE4fnvjomAyWmA0KZ9GAIXgGpAPjx3uJGw70kT8yOrk41fpFl/FWquqMFUtsd
	Ypt5W5NIbsrHsy5YrmQIVKCn6cPPTgVcR9Gz/ILnLmCsqC0N1AZlpv89txE1wt9y
	EUrPO4wsYYqMh8Jq+YdU99jFmEtQbbd8UIKmqSYMtw0+vHlfRzaJqV2ov7b1lNAh
	/4DlsR/lSE82IEBelWcc57jOrPSA5G3FtFrLkyn7Ji9t+YJJrg0IVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0yrunq7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHC6X9t025258;
	Wed, 17 Dec 2025 12:27:19 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012065.outbound.protection.outlook.com [52.101.48.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbqws7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KXL/I04h0e79wjxeG0j8yYHC4RoHT+1vQIXAoZpWlBzt60ba2MvRSI1mkESLGggzNpVhIF0+rzkiQJnYVwzZkmrBhKqs9lr7hpsGgb65/swnSY1EnL0QxGnS/lF/CKkNDQA/ZwWYaFxyaOSQSxwP7TwuEGIJ4DPsXxGbt5ShSrK6m8x4dSKORP5bbI2YnphLvLB8RLQTlavzBjMDeetVBH6xJG3qB+Kj8mXs+zbeyej+UL/JZOdzdnQm9zWOdY/1QIPbF1N+gyc3nC3trhZxTaw7f0u7mugxI9rsUnPKcsDrOFNjOENF4vEM+RapSFzNDDeUaRPqr2j2Q9Dskkliew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EHIO0wz3ZYj+mIRk5zruCNcZdXJNE6VFgKef/P4aNk=;
 b=ZHz22J8IBhL2wxfyFPRyNYfNmQbkGqEVn11tgUiLNJAPqaiX7GmJS5ZRb4MOe4rVuxMohg3zT/D5CRnhcr622e1Ulm4zd226euBkMG6O627QYEfpFxGmPx8fzbxAQLEARNTA/WW5lodjYMB6ghMUkKV1KGr9GWm81mqu05AkXCzEYX5jgjw2VEfP5nI4wTveiF+9s9yj1FBnsCl0n8OgnQmcHNlEgR6yRg/Jlmcv+WDTBzbJEITB9Rk/JmcV/weLaK1ilyAIVWO8zZMPE+hTBu5HiAdhJBu5HFLyYXN3Dvmcuk9RLAd61wLMAzRL1eAmBFUeyTmaOmEWFDzx8guCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EHIO0wz3ZYj+mIRk5zruCNcZdXJNE6VFgKef/P4aNk=;
 b=dwoEBUoVEx3YlDoCMm8eR/tPq6u0HpjxrS19b/M6CYpNarZnoeN3mOd//63fMfIdaILpQu57O+H/fpnVT/aebiAJt945pBVSJKRujsYcxhc8MEdd43PXHKcWqHqB16E365UgXNdpc7pqWYz+jL8v120Z7FE+pOAuN/vO21j9CII=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] mm: clean up anon_vma implementation
Date: Wed, 17 Dec 2025 12:27:02 +0000
Message-ID: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: c364cf74-c8ba-4ff2-48e5-08de3d679d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jyx8+rSOi4oAoJprzUJE8TnXwf9lR1gDMvG17/kwobW/YxvVTqMHQ513KfSU?=
 =?us-ascii?Q?x0+kumd88eBOeC+Z/RQgQ9Tp+N2kc9WtaLh0SCz9ox+ZH+9dapG2/THlopyp?=
 =?us-ascii?Q?HFnSoJzjmJnwXb9Jfue/PjcKfLF3gYAqZ5+DPunSXremRUQN2YGzaykxCsZC?=
 =?us-ascii?Q?5i5tHU/4QEmWXCAX52c5P2Hlv8ieWdSoAmddo5y0fEhSkgnkAGqs1D2Yls1E?=
 =?us-ascii?Q?DYVCFHIHAuKm/UEkK1jt6+mBGXBuKJse2ylY9o3XTqOvJoQ89L1FNx/PGqLi?=
 =?us-ascii?Q?+8aQP4oIl3z7xfqMCZxBS0fit5co5GYFaPEUrKCLAUn8b2Iz+vcfNdpUxc+A?=
 =?us-ascii?Q?h0jHhWJwRH/ryQAb58ewxy2Ooiy94sV9J7ZWHndzyoH/k5j5mtxL3AxmJ/+8?=
 =?us-ascii?Q?7X5cpMajbRxgWTyzYOSLi8rpq7HOltsEQ3TBRDmUCrUyDcqH8BVVZUxKNUPC?=
 =?us-ascii?Q?tBorOqZ14ImrFvd4j9iitlfJYpqML1dVrJQw3ph0aHDWmzL73mqDFNKJ+17K?=
 =?us-ascii?Q?X7VCaK9hoW7LUtRpDTjj8gawy2zObaVNGrc+VymYbYpXq8WBSSYMe7p/auLY?=
 =?us-ascii?Q?7/0oga1WnfPA699ZXiAihmDUjapwbzXlxD/4dHBYVFX3GeQLUTFQcPeD2znj?=
 =?us-ascii?Q?KQezmMLTeC3FiOOqnfWbz2KPfQSazv/AzGnYS0/5CkQ19plWOtooRtqYo5+f?=
 =?us-ascii?Q?96RXjhktwlfhJLikI4rgFMSiysmDF/Apl8xiydtNVdulczL1cJcsbZ5a/J+v?=
 =?us-ascii?Q?FekrvsI6TyL3rAKIslIwCzWE5ZU2yDNn8birfWBvS3KWTAE8JJbNotupk1ry?=
 =?us-ascii?Q?taLa9uzF35a03MTIl3m70DJJJCROQ8rcK5sDUbPx6jZ8F6P2Mo4xe1SFhT3x?=
 =?us-ascii?Q?GaHbKRJNer4RMLnlJXX63G0ye/eVCguvKvndDdI7lgSzgTf0Dbk8T6UnFM2u?=
 =?us-ascii?Q?VZB7OTkIFsjWZ2L7QMhh39Q32lng+lcqwq/fBCcuY8phEJfnb3rOZd+sHyO7?=
 =?us-ascii?Q?PfBnYaXpUIGfeBMbulvgN5tQAkd6L8KqhzkBRmjNShbmybak/T9s1uzdiqce?=
 =?us-ascii?Q?hNJ5q5G7oxj9f+16mHX7e18SrxX8l0R/xU9Nd4fMIfHGJH262XTMCu+Ju+Lc?=
 =?us-ascii?Q?13oAX2OomhGmeonnvArZgE/GilxLWLBf3jNmOPQmMzh2IjPf0ZmxIEGQzIcu?=
 =?us-ascii?Q?KfsZ4DHDMnYJAD5EMW8eLDXGMvCzqB5HhPaFDmXmuWFGKtj2iFe07FVqTHhf?=
 =?us-ascii?Q?pybF2gj8RLDHYaqmJsLlBdo9cGjXPQBFR91a0BeNjjztu9+GhV4tTwKbFj41?=
 =?us-ascii?Q?fROmxk4s5oSnGp+0Kg2GmKgylCmK2iuWwHgDXRVJRwIFgrEwhP3U+YuW9Hwn?=
 =?us-ascii?Q?vCYNcjdoczxGcbvvbXUzjTjFhjtJWsa6ox46wnao1YJrScGXP7N2b98lx7Zl?=
 =?us-ascii?Q?HEfRosfM+3qR1Ebv+6pyJxMem0in1yh0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gKgSsC2T1/XIew2XxQizXrcR4exLlkVV/Sr8hC1LYWP1f+J8dN32Dx7LtNGT?=
 =?us-ascii?Q?fWvXiVJfRBeiTfoBxslbmslXW5V3LQmwB4Y2XGlDBu9eXg/96gynD7OMVxPs?=
 =?us-ascii?Q?0+0lvGenJiyvSXbkahR3x9vxGlLMV37ZFrAZlpBYqZCtmTHg4pxDlYisnsCp?=
 =?us-ascii?Q?AhAeq2IuD9IQGKhBsqF4E5Qst7Iy+UeDZwsi6S6DkYqToiachtE8GUTFIeZJ?=
 =?us-ascii?Q?RjLfB4kEHSWcRcAlOBnFZdBqd39HYUffUluiJB0ew/cFQhX6HkURRqcEFQpM?=
 =?us-ascii?Q?VUB6SrS1Ss4L3UrXEs3y+VfWS8sjK6K86xmF18W9daB3FpvESC7yTOfiFH3n?=
 =?us-ascii?Q?1BXDea7DjaXWXWqv09UnY1TP6bjEULF4zCmp/hg6cWId4Pt3j5VGU+Zc9jLL?=
 =?us-ascii?Q?mp1zu0QhqvAxr1qiwPZ0vypNkXKd7KgRWR9frETg4Mt42ubiIw/s5T07e3iK?=
 =?us-ascii?Q?k/ifbRdmXSBA2OFPBoP9nBBNaKdnjEeRkFvycMNgjuGpUIXt076z5/mFoX0h?=
 =?us-ascii?Q?ZXnh7tADUpvjaufZZ/qqtaFZ4fsqJxBt0f/nixY2G5ng8LkHX8WmQGKO+TH7?=
 =?us-ascii?Q?P6xUEH/f9J+iAbxc/RQU+Rag0E8YNVo49C7VhaGLYgV64e8D1hJ3RQRqbMhb?=
 =?us-ascii?Q?Mef7jCqNlhvONWzc7uFYJ0M4s9OWf45kvA16k+ZAgpGpwwsDnWRABLbqwvxp?=
 =?us-ascii?Q?uWqG6U8i4rEhrEKjzmTGN173Ak/U1u66p8jhecregJeS3+lPSeCsjh4RkcEC?=
 =?us-ascii?Q?UW1MZYbYse92k+3MI3RFjFoBfV9LPJraccOSEmomToKeej1GllsOF5fkbmyK?=
 =?us-ascii?Q?HyHsyqGCwWDwYbsFN12sJoWH4cCU9kd//MAtM+o8uTjxdBsBFdh/CHLVkI/y?=
 =?us-ascii?Q?FYAmC14aH1F1dbgghT8tdWfnvyi8tNcn3sV1n0mXz2PcXKPe4CvBXcgGdg43?=
 =?us-ascii?Q?TQuvYcnFlIAVQUCVzptMVxVUQ5Kgy0uaDvQIkJZHZ7EedIKZL/OODcdpGci5?=
 =?us-ascii?Q?2l4q3qXA9/2Z9bAJcnRpR7pUmNitRCeimZmKxhFxbxfOdTY+stYOnO94bCeH?=
 =?us-ascii?Q?3CskqB2MPi8dbrfUmMLCMzYzdjHcCMm+Ns547Ivdpmdxsc0oZCxTfJ4ZNXs7?=
 =?us-ascii?Q?pu6eB8wjGViq7uLwob89+ny8lW4A6XIBd5rTrHEDYTS4Gi7FwG7sftX0Utl7?=
 =?us-ascii?Q?/2AzOGXgJacFRYFzMLZfefeJo9OoPTpbkUoPfloAf6CNsWxwYNcGs7sNfRDp?=
 =?us-ascii?Q?em7rypxjp8y4M3MMKQRcljWb2ictZ8BXZYTcY7i5/OuVJbJuqJNGRrfADyc1?=
 =?us-ascii?Q?0vBXK80IUwByLFBiG9QPNHiLifLD6P44alYB0johUUGvhMvRm2jl6iEqJpyI?=
 =?us-ascii?Q?mHjz5nBua1ofSpUvNUTlZ+qg+ZeBryuIDTr3fAbffnvwAZ6cbvCXQumn+ccP?=
 =?us-ascii?Q?WRAyi5/+KWOBVUGjY5Eu9oXkh7dtv9tGa97Lgnm70kLWobrCS+kBKrhb8E8p?=
 =?us-ascii?Q?0SjQkHdSplsa6Tjub8zch7w9mlg1zPWKQtbxUIgXgMGOEzHZy/4In6ZdTXsp?=
 =?us-ascii?Q?dJyLS17J+CeLcsw8k/BpV9GogEGsGAhMXs2SecyxD2rSu+2Q6XuYv7kIMiM4?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LikqZ/ZXg9dpfcnuz5HW59VNcgdmFV0crGYuZu13p2IKJCUVu5+4IwlPNO3uWz65sQMxxP9AU7x4bvGAtexxkKCF02X1liZzB3efNyTaCnleLOKi39vd5T0VB0/3Nw/qEe0nPiNvhHgRswwgexMK7muwPPsoHjc2rvYqY6nK5Hp3ikeZ0TdkAIHQwNrbyZcEAMoSPE0XL1NA8iBD6pdBnaU3TuG12hjPmrbELST5UK68WF8gIsGW4r/D8N4qhjhdXl6W4lwODVWotGECfaBrNyMor5denxFWbGw5vzg/XlA7fzPsJALGJMmjMTCf5JSaaGzj0YOIHVnL/TAqWmxRWGURFJPcHJreLKm1mZUBzyYuJiYGhPC8aFPMtmT6N9/1gduLEW3ocSb9EPdqMDJJhKF4GR8qkVrqsegXZatHULfwHL/Ybq/0vOHG5ribaLiuW0XH9ThrPjoDuxUqBpGv+LCwTLCdkn418Kc46kgwsudyR62Fy8gDp3V/d3EQgC27GEBBCS4XlWLx0LSUiDMRZObd7W3OI4Db903DHjgaN00bBuKclCPLc0Mab4P+9feq7IV7WasUNi4EJYMB+XPmtEjvsIHihPO22bCnxj5WIzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c364cf74-c8ba-4ff2-48e5-08de3d679d0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:16.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xu6VaxEwzGKbQxQyCtyNWEcW6x3qJt7UcPnbRrvb/Xx+Ww2CYuhzpUMjVicXUAjMUAu3wSeV53/4Q2FqTULcQ6mE8m1x87zdD0Bjrz/PLg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX/MnNZlAPqxEA
 83XmaYpJVg71Im0y6zfVThQhL9SEYMPLmd+FglTSGj7O1fddxWKDlEUGM8FEcpEGuGe5GDS2ba2
 Z8Mc3HoH7jVX1iUWUcdSZ23IQT+cHTGfH82vOd0tK0w4hrsEYoHPJMdMF1AzAoY45W2QvVKsH/9
 j9rWDKwBWVqZRuBr25JAYgGZtTzRHlfGoOakqt3mAv/+UXkbx3CtAX7S+UZVEiJk3zTT6Zt6KeB
 uW2qZopbBjLvfRkzR4SzjBUaQD8uDkkuGOvCrZUbT9RSb7fZunzjQ2ZnUJdOiBlEHj6vr7oI4Om
 Bmb3sfdXArgpjNoJfyTFC1dnvElqeHDdLWTjz6gLsKsOeuLw8eN6YcmF/6zvCqnvipTHdEi5lWp
 zmtnqt8ckONv0x/x3RpTB2xY3twfAw==
X-Authority-Analysis: v=2.4 cv=TL9Iilla c=1 sm=1 tr=0 ts=6942a1a8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=N69ZbxCGvC_8b3ropFUA:9
X-Proofpoint-GUID: Ar-MDZJh8sZhTRlzwEbgRtaNU9pF2NSP
X-Proofpoint-ORIG-GUID: Ar-MDZJh8sZhTRlzwEbgRtaNU9pF2NSP
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B54040005
X-Rspamd-Server: rspam04
X-Stat-Signature: mtbxizx839frf4abxu4sxm9tfzbcifww
X-HE-Tag: 1765974444-279449
X-HE-Meta: U2FsdGVkX18RtnNL23bRzCP/f9qtdv78OZPpSym17qgdtQe+FXEbB79sgsBNi3ZxmGPLnAAK8p11HY1V1x9fvl6D83WZoVbQx2VhW+tkphUMev6mi8znD6Mu1lqVVVYtX8qI2LXm9GIvK8X6l/eeXAMvfqW9VQoH0O22Dv5xIKsZQP5o815KvtBlB0A0UuOfe0TeaqS4mGXgidCrrzviSe23kHuY2TkdImKvAxlEE6UuEPlncvgAI3Y0cEZmBZVSrRacSW4x6kG+IBVvG/xZ2bIOZiagtLnEcpdG8ruouuY2FCfn4mjrDkeMd6+x5N6+TaZ0D79LvwvIKxiJfhyMPW5rfnRqYE3V5NWr7VlQLo+jt/etIdRTL95MOpEBlCf4dI8ezr2SSVjbYdzBg7EapFleezz0pLbrdaOVcZSQJgbfE/j2QPyIE77swidtkoMUxedi5KEso5g0yAzSqIQK/ofREvnWGiP70GBiOMBT4xaPlrreS9OcxKh6nSjAVPa7WW9yNWar+ppE0ZH32dutEyWdbIbCtkyfNMefoAe6DJ1K1N0ZgBnLZqwZ6tRfS3Ek7A7XXKUzYBXfynsVN3iVYVkST4R0JGkRQl9GnVYj85bUtGLlZ+eIbgd6KgHBczfgr7THjFiN7mUTAEEVKv83IwrtCmyUaEy+VAap0uXKMhpf2D9s6zcTZVxbc3PMEw46NaoXDMsqZ63+8jhbM5jNMJtYkxYqQ3KSY0NHbom1ZRTn7WJCiFTIkreozNo9H0rsrdzK6hwmrtwABU/khAHZFznW63ZpS7AY3BbHmofj3NAOaGj8NxQNbwVvGjTQVPgjkI3b3epmtGq/5sAZ6+ttDbPkK+wPzCYcBq50H0CNq0cT24IwrnvrGfQ6tIqm2GOAdPd0Wqm1xZmXYVUCfs53qXaVH54nYLDYfTWvRewiVZP/dXF4izi/tTI9PeiCwc6c7I8vxJocMSXDw/7IyKR
 MdQTmmCr
 ePJ1KFYLuOH5xJkntjl46BCch9vGa0yraiwba44Xa1kbBd0WDhIuT3U0wRX6ZS5kDfGCCYBACCKDsFx6c4c4SOuHe9bjAYbLZqXNh2sSKSOPLK8VAFrOPJAkCoyOzUR5/xmtcRRkI5vSU2GW5riE2+75LsQgNXUtpg9p1pF+1odZ5BSXIHRFIO6T4WYdYY97WUZ8ltBRj0Cgo4Wizv5zl3MJk+viW3Xk1N36MX2JNwStkQAOqjSMmj4iR11Gw0vrbY3oieqD41LpqRCH8csIvoqwsioeI3mfB5us1QwSNdJMxyr9Rbie8h9L0V0D9112iLBkDzak/CtJRn1Dx00vOgR+wbEVKjLj439i6bCJdZHRW7Pso6QlIi6hwf4bFqsvhk01EMBm7j0VbW+FfBNTtwGGV8NEXjtVULZUXsPCzrOeT2Anpd6LYj/GrX/V1Gnpa3zToOw9uZ8eEIssrNoamcJ/0jmc0C6q+XDedx2FXtZojpR7TSTxt42aNgYL43gAm9Ix9wR2oSmmbFBjjxfttVIHU9Ec/p21Lpk2myu65ouaPHJQ5lCoI1Ahkt5SCmtQzzIIjjL/OAUIFJhMjDJBZ4H9Wsw/kvzWGyBl9wH//KihWhY9m5irfivH5R9PLg0jjcJzw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon_vma logic is hugely confusing and, much like a bundle of wires
entangled with one another, pulling on one thread seems only to lead to
more entanglement elsewhere.

There is a mish-mash of the core implementation, how that implementation is
invoked, how helper functions are invoked and concepts such as adjacent
anon_vma merge and anon_vma object reuse.

This series tries to improve the situation somewhat.

It starts by establishing some invariants in the core anon_vma_clone() and
unlink_anon_vmas() functions, largely expressed via VM_WARN_ON_ONCE()
asserts.

These act as some form of self-documentation as to the conditions we find
ourselves in when invoking these functions.

We also add kdoc comments for anon_vma_clone() and unlink_anon_vmas().

We then makes use of these known conditions to directly skip unfaulted VMAs
(rather than implicitly via an empty vma->anon_vma_chain list).

We remove the confusing anon_vma_merge() function (we already have a
concept of anon_vma merge in that we merge anon_vma's that would otherwise
be compatible except for attributes that mprotect() could change - which
anon_vma_merge() has nothing to do with).

We make the anon_vma functions internal to mm as they do not need to be
used by any other part of the kernel, which allows for future abstraction
without concern about this.

We then reduce the time over which we hold the anon rmap lock in
anon_vma_clone(), as it turns out we can allocate anon_vma_chain objects
without holding this lock, since the objects are not yet accessible from
the rmap.

This should reduce anon_vma lock contention.

This additionally allows us to remove a confusing GFP_NOWAIT, GFP_KERNEL
allocation fallback strategy.

Finally, we explicitly indicate which operation is being performed upon
anon_vma_clone(), and separate out fork-only logic to make it very clear
that anon_vma reuse only occurs on fork.

Lorenzo Stoakes (8):
  mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add
    asserts
  mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
  mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
  mm/rmap: remove anon_vma_merge() function
  mm/rmap: make anon_vma functions internal
  mm/mmap_lock: add vma_is_detached() helper
  mm/rmap: allocate anon_vma_chain objects unlocked when possible
  mm/rmap: separate out fork-only logic on anon_vma_clone()

 include/linux/mmap_lock.h        |   9 +-
 include/linux/rmap.h             |  67 ---------
 mm/internal.h                    |  67 +++++++++
 mm/rmap.c                        | 232 +++++++++++++++++++------------
 mm/vma.c                         |   8 +-
 tools/testing/vma/vma_internal.h |  16 ++-
 6 files changed, 233 insertions(+), 166 deletions(-)

--
2.52.0


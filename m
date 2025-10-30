Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C504ACCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 10:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7A98E013F; Thu, 30 Oct 2025 06:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267A28E0112; Thu, 30 Oct 2025 06:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E24A8E013F; Thu, 30 Oct 2025 06:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E62D78E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:27:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57B1213C072
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:27:12 +0000 (UTC)
X-FDA: 84054403104.15.4214F78
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD969C0012
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:27:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OU2NI/n7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RMOSXnLy;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761820029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9UpSqeQF1Dr+5x7DX5NRXu82RmRDAekTv9iatOq7rA=;
	b=Jv1jTcuQLDfAQE9v8FNMfLcZ2YdXYXeiVnbzwaPRGsmCYi7vGxbrTvz1MU9Aypa2pyKbgE
	ZLzFGJxFvoTK1iuzGsgolkhEpsWUsIk2UTbox+003MAUQj38/tneHqkyy0WXLXxW8WvY8Q
	oy9OzYXW1aadsH2X5qocRxF7Y1b1x2U=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OU2NI/n7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RMOSXnLy;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761820029; a=rsa-sha256;
	cv=pass;
	b=g2CvFy3c44qHSpxzNpjplyO+O6jKU4Tom/96LKuK2vXCCpgZ7WT69+gTWOP7MZbns4+aZQ
	HMYqhnwdkNIqdxvmf5Aqviaahy3z7ynkjrb7B6618AgEwbff8VYbD3A8iJNRCRDz0Cm6ZD
	GVpNOZkSlqDG6U3K/fBzx9xxq4YmO+k=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U9vhGn013710;
	Thu, 30 Oct 2025 10:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m9UpSqeQF1Dr+5x7DX
	5NRXu82RmRDAekTv9iatOq7rA=; b=OU2NI/n7sz9nHi4AydwjfRkMpqMH9hdI6t
	3y/rq1stRq1Hq91B+dCIi81TPV0nPVYEMpsCTB7PqGfA9F7fCNzi+wCzjQsv1IyL
	VHTDKU37XSvom+AKXo7SessZmxSlrfUvcQFEPflKCOgYjOqdHt/US8y7tGiHZtZj
	6ncXEuE7xx2xp+0cIT4pKKK3a5DQNQ3ScUYjAlKxwm/DtuLuQJzhI761lN88/hnP
	UTmm92knC3Q5tZ579RZhEYnAHF3ckNiGdJQPqbcEB5uz2+ea8OS3ouQFpBfdRwC5
	CbHTLPZnhIPh8BMOjfoa02XrbiGTm8NfFG9Hx51/lECz5SLii7iA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a430x8avf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:21:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U8BxiR011272;
	Thu, 30 Oct 2025 10:21:49 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33vyems9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 10:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=varQi18jtd/YPsV3VWb0k5VCThpO/Iyamk2HXQ73G+vnY53jw0iWxjN30J73UGX+bRUo1E284KeRmMwn6MH2OEY0gcLQlBOJJUBGHqeU0rwGj3F2GmNJ7PRUOJYB3l8iCvNaVPNRyskI7t/BCPDdvCcMonK4pYLOxBGrbrLhCbTg+7t7dA8uvRzAMHMAUfo2xZNAGk6nk/DR/TbQdI30eQ+fuTB9PKUx9nuvqDRKLrBJMt107DR4A98VfPlNXSfPcfZz0PUcDRnf+ipuEnBlBFzM2jXVsgzWGInAvw7JeR+qhCRa3FnnVLo1khonfXwM6aOHhtsyeRIinqlpuJNpQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9UpSqeQF1Dr+5x7DX5NRXu82RmRDAekTv9iatOq7rA=;
 b=TEwhqf0wBOxbz/i66ol60wHqo+kW9fnCQvL7livgcGkKRdhO3qLyQHVEpJGPuarppkbNW8mkyPT+TnFrgkCWiTVtZTBulrzSvGXfM1TtlTojM3T9eTqHCrqXQuYmnaovjCuG4n/2Ns0inj44tsKUIqk4iSXMsSb7nWhozaejJw0R6oDrRX7Fb0vnBBZB7Rqq5kH6qqSa7927FyPitgadObbOYVdKhml01SX8UY6wlIG21xkAG6Dc0vxE4C5yVVXHkHLKFGW/2ri0/PKgjStN/DVZhYNSC2Sn20iK+FYEsYwFTz5Hq5DSBCH6lwwvYUKIXQeJ4CPQUm0bzavGMKoN+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9UpSqeQF1Dr+5x7DX5NRXu82RmRDAekTv9iatOq7rA=;
 b=RMOSXnLy1pVCrJloYDgBdvcpenScZAV/oVtxRIh6+zjy3QC1qSc4FD23o42iLJhTmy/a2WJ57MvOmCsRwqK2NAdLvkjthnVfynNQSQqwPJX08vD2GutURSuVmplJ6ne3ClCgpE6BNFF9mw2UN3VCAA4dlvl0YWCWKk4UhX6Guyc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4570.namprd10.prod.outlook.com (2603:10b6:806:11e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 10:21:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 10:21:45 +0000
Date: Thu, 30 Oct 2025 10:21:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gregory Price <gourry@gourry.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
        Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <791c6945-3726-4ad1-9ee4-763d796b58b9@lucifer.local>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
 <20251028124817.GH760669@ziepe.ca>
 <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
 <20251029141048.GN760669@ziepe.ca>
 <4fd565b5-1540-40bc-9cbb-29724f93a4d2@lucifer.local>
 <aQKF2y7YI9SUBLKo@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQKF2y7YI9SUBLKo@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: LO4P123CA0167.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4570:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f75d922-e68a-4502-86ba-08de179e209c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BWsyk+DKM8Ny41yBzhjYEC14jCqPbHGhJ/AwsIcfJdDCi/LH7SyUlsBcT8Td?=
 =?us-ascii?Q?mERPPGYuOeaIkgdfNFchK+n6R4pxOKPuJ824h90BZQXt+NjpvdSNbquf3pX/?=
 =?us-ascii?Q?UE7PRtJ2muSvXNWSRS0LAKeva4WrYysLbIklMwq0R2+IYUC1PM0VsBU0DTbM?=
 =?us-ascii?Q?YK9v6YfHb+VnkDDmwF6zdr0dCDTyqS19eL3tBG/4kCJ1kFTlP0c8JLeO5AXd?=
 =?us-ascii?Q?HFfy8fc/grAHEPIFoU0zYoU4CrBgqkgi8ZVkWZeRJ1DBKJEmuvxsvtgtzE4i?=
 =?us-ascii?Q?NMNrBsjK0busthqlapJhIXlHloev8eW8H+t3SoR8/xDPSiajz5Venqs+JaeX?=
 =?us-ascii?Q?CX8/KWxj2dKxdH4uP5FHL/wvfWF/Q7j7OFtRvkSidGXt893jHSJxO6WAdqCr?=
 =?us-ascii?Q?CRMFtolJx/jn9jsK5QBFyiKGSfJcrbYYw2SOSOdHwO1yVvKbDuQWYczIs3jr?=
 =?us-ascii?Q?feOggtiwjRR7Zd/XGEMPvRJuzgrdfTG43T327kRECsu3PJJaSJ9ewo5bXcRw?=
 =?us-ascii?Q?U5LU6oIyhQQUMW17NlxAffKSutckEwXTa0pgZaJe6N6xvLx4x889F+WEoDlW?=
 =?us-ascii?Q?lcFVntlpZKsnxhWcazXrz8CbxfbckQMpQx8C2SnHgkJTwj7qwyyEgMI7BjUw?=
 =?us-ascii?Q?jex6vr2JyOYnEhp4V0eRsnRr8iUNU4Qv+0Jkc+Y+UqyNYZ6g7+JZBKgEVuM/?=
 =?us-ascii?Q?OdOSz2HE/+TRa0BcKtCiI6aqTbiS7KSNr+qzFvVocHnYQu08aJDfoXe5Enzo?=
 =?us-ascii?Q?PQLJzApQJfR0sIhl1tod+zIxCwG0SRZ8V4ApKc32YoqIeRTI2ZCgGweAXxDq?=
 =?us-ascii?Q?xbi5CRhqtXMEf5djZXcCExq3OhjOmh30U8mrhdennv5nJKVhuyobyZOfOddI?=
 =?us-ascii?Q?pCUajzLwziETgC2Cxgmk3KiIz7ViGlEJLdXsIxaxPrIgsw8welbc+yoVLhKF?=
 =?us-ascii?Q?sB5fqJ8bBdyR92QYSECXhp4c0H4T0uFDCykRP/lJoZugqqNRIpyA+bn1ulQ1?=
 =?us-ascii?Q?E3AOApHwHetlksVRvyAM4e/KQ+XteyLL9x8vr2KtbPLZQrh57WReERVa+zLD?=
 =?us-ascii?Q?7hqwV2FjUCGUolxhDPUW41tbpMp6n4LX6NclwwU0dyua3hORfxMaW9StNORj?=
 =?us-ascii?Q?IQ2hREyRg07l6VnWBVQegUqPoeY7QHX9QwVDQ+Y66Y3i9npvjWMEtEU9Hoby?=
 =?us-ascii?Q?LrunhubjFjN2qQ97fFATLCfOu3aloac3lM3k2zkrRFb9Nnnts5Lu3Z4zVq1Q?=
 =?us-ascii?Q?XWAAa451BQNZndcKxJXWbnl7HQAckieY4I51zU8lztlVB96+IEQfPlu+j93S?=
 =?us-ascii?Q?+ObVWPzjMN4DGsnjP+jP9yKruwkneyNPePTXzzJnAxRsmMUY+K5ON+UfM1JN?=
 =?us-ascii?Q?Z0OQTWmyy6Av6i5OGSDDkCe9/aEONLUsaM/UUEiWCXlid7in9EseI2+vBCn+?=
 =?us-ascii?Q?HCpUxuuN3wEAliB7cH6OsF2EulDem4Le?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nO9KmWzm1ANoGY14MpRBP500KzGuMBvh7c8hrD786TsucaQ/4xizwwUgPlSZ?=
 =?us-ascii?Q?xoV8rWK0nm7gfvvoLPijMjPthKLv9kX/b3orkZ0FTn/Ui+ZoYgp2aKA/94MH?=
 =?us-ascii?Q?RfYbHw26hC9i7gyMf2sQFqvzKlmjFiMS6LY8FhYIjVjhUQi+nZHUOc+XWcyO?=
 =?us-ascii?Q?m9CaFxhW7q3ADxIBrqi+gYyxvAMiqfUrJXcGPPl+CWG4Ih8IJQzdDCpO5Vv2?=
 =?us-ascii?Q?avymdYHSAlpIPi8gZcZFGBfItlkaJqcFoyyzhBKZLod3BD6tSx97SMHqRfDN?=
 =?us-ascii?Q?WdwwG3qAlfrlfZc4nso+4iPS0UrY/O3Nhq0Xx2kPG2LW9qNvJPT2On69JIgu?=
 =?us-ascii?Q?qws+WqH7l5uIfmRE2F0/moX8hstW4Z6OavYImPfc7R5HaAzV33E1uv45a5c4?=
 =?us-ascii?Q?/LfdT3yH9cZozQ5ZYnk3qQSwY3Xz0U50+jZw0PwVD9n+RRowSItMvrO1MTPV?=
 =?us-ascii?Q?vwUg2QJWn+y3sbQhjLu3ZuYAkDPHr2N8CnRwHVZdqaXVFqm3at0oyQGQbIzC?=
 =?us-ascii?Q?NGFTPN8m0ISk/YxTkSJSJZoGF/bQtF1O6UUvIuIwGdTi4wX12CL7ZIBg+qyV?=
 =?us-ascii?Q?vA8aGQ6v7T9f1yClOYjbmnj+/LbrQXI6LMujnZ84LQ2rXBEcJYJVkYRdbfFg?=
 =?us-ascii?Q?upNbU4MXUiZo0qHKQpxNqadUwhgS5ypngBX6lvn+FFSF0CUX2mhmKsKQgiIm?=
 =?us-ascii?Q?nOWmxl1u9XvS0IMLWuoijPsyhRYHQm3XFWWkyQ9/AyD6b58ahavMDVKlP9is?=
 =?us-ascii?Q?vfzASpDjuo71mHHj0kyxsTdirtAwrXNTaE0C8qtbEF9gTF2G9kv3+mxwnJxa?=
 =?us-ascii?Q?raHEXd6B8JGmY8HQxdbVV3tcfRiiIVB5mwIDR4Q5TJyqFKRpXxgmCtmlYos2?=
 =?us-ascii?Q?3wYegk7Pi5WNbbbQsmZZ/GjR2NT/Pxyq6sx9jBuAiXIs4QmD8RSeEAWFJySi?=
 =?us-ascii?Q?spxtQopqz70FqCxuuwDxhc2h4CY0x8eIAm05O4Mq+bniJYM7T/8t1+IVEhGj?=
 =?us-ascii?Q?JgZwg65OjBbqRNXzbH4a+8lPyfdr2UuziBzAQJgP0m9PCHs2RgB2+D0ch+aT?=
 =?us-ascii?Q?lwBYLq1dYBHfTfLtb5qOxXjLy2LRKyPTc7zW/GcLut62gw9BGpAGJJ/5jFlT?=
 =?us-ascii?Q?d23ky4VgJnxl4NI+ed8vZ/Ymhom8s13jwit+nMs1AAMhtFpK5D/GGATxdmOY?=
 =?us-ascii?Q?4/aWl2moGfxKsH/F0hBarVu/eR+6JEDssIWWZwJqPrq8UzVSlZ3iCaHGyR5p?=
 =?us-ascii?Q?GWY4vkjizJEtS3okJN/Gu3U5+ypF0aMWpWdHKCJONFJlTEmu9qbdhGH2bo5F?=
 =?us-ascii?Q?jE8Vdk/Qyd+P8AvG8tmSgTiyDJNmOnrA0+h3E/qnRz1GGLdEjfj+Pp1j0hWr?=
 =?us-ascii?Q?EgWCTB0nnu2JSioOzcO/LuOlFJMwbpaQqWcHZ25ZThaUo4kNLT9cMCDH2T/r?=
 =?us-ascii?Q?rx1QPYSiH07rWXBwVU59fnknkaoWFgp+K0WLetnDlpt5Hkj12ntk5EiCeR5f?=
 =?us-ascii?Q?4p9+RXS8aYbWa6Z8MaJB2FKgFP/ASOzY90p2LmomS2SkysGFU4wjhrrdjY7o?=
 =?us-ascii?Q?+QZ5PuOR4r3zub3eAABZz9NkaVf63hooJ2sKGkrfSGpWstarCUG/7P2SrdLx?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S5VYmkasEimYZPc3cFY/4H5BoGuDWG5ogJNr2HFsKqei3FfAcGdVG8qPxqr4Vk5SE2m5y2knvq6NS5hJyWdUG7thNXk3dzPRxQhosmBJObRpRMlpKc2nnXAERfvpglcYOApJ8cSGWKPS1jzIuQHy7Puy79sTjSY5s3CmCh66/AinJTERzAZgk/ON8/sPa93uu0snhnFq7F4RVI3kBS7ExS6jELszHqi1LFzj+cReOsAE5mALTpcSnNC146D+CUb2lp6TEivWKFiAVex4N+XTZ88LvieU6yWQtRTXuYCLIs3fRlmcyt7fo3+yesaMLH54kburkakIOWqrQjEDK5gbG87WDFLiltbd6Zh4/GFfQY7NSM1P2g9N6luPzKalDefyVqniDtV2dpRMkvmT/GYBSRfAtj2AskBYN2FqDyIbOyXgdr3xr2+U/yIAVZ6HYgfeby2sl+SI7yU8cPJWohNQFpzy32tie3chDD5jDeovYdOiDhCOuMUfMB9OAflR15bmh5wP4M3MzgzBOXsz24r140bLevDYxuc9BHJfnVpi9LMBCkUh4643Bopzax1M0KHFGxBafKRW8+dD3Bu4E/HMjQjtepPuBjxi4MfkjKn2r40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f75d922-e68a-4502-86ba-08de179e209c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 10:21:45.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9U4CP28EtYss/w4g/e8tp0XoNivqJggrVeqX9uoFEafVQXgdHaJvKTcCQ5au3YzpUsjDxWxzfbFaaHU28bp/Isgtl95REsvQY0iOnggS1uU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_03,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA1MyBTYWx0ZWRfXxPo24Q7ragxu
 1eKMUkIqVVIQ7YIyRUWMGvjk37xM8+uz7HF6PqMTBMxDioJoWVgMSvv8opYt6U0UvIUMu4CTy6u
 HpyPyDnsO0LXIcQW072ip7zV8AVm7scW71cINopt1EJoFGch6SivPwO3KeZB9DWHsMGpKlAciuU
 6iV1sMO1owDYehcb6z2dSlqrIKi0ZSkd20nZaEOHy7dWFCZp7jz2JVj0+P4UCW3gL93m9NMnWp7
 xrikRoTCCxuUZkTWE2H9O+2kucCH8PbqPrerCAGa1nNlFxjvh/Qisr71s2hDc6N8teYKqBBiwyG
 Zh20lRnw4lpTTL1oH2FlObfYTZNHKzNai+0aFYmx2O0j/XzBZFgeP+GNINSPETZWdgdfPl/Ubr9
 lPdUNm9HcISCu89ZmXGGXEZDTgjLOw==
X-Authority-Analysis: v=2.4 cv=F7Nat6hN c=1 sm=1 tr=0 ts=69033c3e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6iYNzCaUjdNj9gwTP0YA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: oQG_MxCsiDyUm0nn_OjACD9Sdku2V5wx
X-Proofpoint-ORIG-GUID: oQG_MxCsiDyUm0nn_OjACD9Sdku2V5wx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD969C0012
X-Stat-Signature: kyrrznq3hadn8q8xqhnnhcgw7chf4ti4
X-Rspam-User: 
X-HE-Tag: 1761820028-10225
X-HE-Meta: U2FsdGVkX1+1uLnh5kPleLB/oL185ZBvKuKewEZszJRvvQvJblGiPIcSiduZl8wTJtFgBHipIAHuEJKDCYCfqE1fdCXrfYuygrnOlUy2L1b1EyyUWy+xg6z16Y4qyLbrYxWuLrlEUvGqC+6DQkENsn50ZAT8nyeCEq1I70RuA3mThKOuUESUpOlb7h67C4IVQi4T1ywNtkPKcfhWtSNPx85eMuQDMCU71NniuVcUwxA26lAYYCS15MflULbWvsArqvwhWIjOF7xSWD/A4skNTd2ewqCISYsx3d0AxqhJvp/3M+dFqPl8uXwR0k8HAlJibtJrDwnanEJtXYRDYdxw61acW1ZAR37+JoQ7D/+tfgKRnXsxcQh+zXE85pizrUQkBWlNsI479rCC7YJxb0KnTyhUm4Kn0Khy2Ayx6d9uxUY8jrVhXOrJqXLNjkJMZlOCiLVRZ5JTxtUFDpskGvREhs+6FsWkZ6J5uN+b32jcg/t/WCiIGWmJ28h8tpjnU0ARZT8Jv7sv21eW5iXRa2wAjXwAsudzydbP8gM803fDcSD2wlhc7E0Tph/FSR5bhvkD7kHrhUqOkaNZ6Ckj/aCSkseb+1JDRAkr31zk0jwQDodHk1HsBnGZyGy6L/dVwjSyjKWDuHGWWtBlBgmCUcjJ7cIAMBeR0l2WtARM4ygPKrMp0bYjofniQiMSKjhQ6ywL1gRvuvffoeChQo7bTOPNNQP23DhzQk4KnA6EQ51LbLw88l1wPLJw+xjsOjEeioEqXd01iwnpuGGOpZKVCRo5BisKtN+Xu1d+nbA1gy2TRdeZmxGNQgLlgU0XHJBR6aux96XKgs+Jv/n+cSGyMPM/arWt0wNXwTjUBK/XCVzUGbh4OjKm/JySoXX3zpLfK6X7AgEgxSmWVGHaSAG+B2xZ1B3pSexVatTsKitgsSyqrxjbDv+JSWAED3wcdn4ey/Eh/HgHbQ+FVt9Fn8zNXDh
 zhfiAwNv
 dy1Ldxr16JQSzpiwKqn8K/5kQ/0A3yx25ySJoHvF2x2SGXVvJ+8983r25blMC20RJDdpKr1btBmlaq0bqqeoJPLF5fFHkqFY3uexDU9WZBuZCgUtgbfLh0MSIcCCl6hR/oHZSd3EjU8/AP4+xab+tH4qOCBVbDgloy93RZoYM8wqTuozgl3/kb+Nk1pzUDXe5iRIo9q8+39crAFME6C6I6bGbON2xgY5sEkG/KaW590evtOCTNTskQm2UGbs+w0ImqcUefcbTjGgUFhq3mijGkUhepdMoL3zEy0zE1hQVWj2aEJXmbDTZ4FnbwItt6PJ4/FYhAG2RSkXV1hBTyJe9C+GcIofaAgeSb/E3eIArEJslKf4EQsAljkYJJA9v5xFoDXpEHHKJmh8rNtPIRq8JOcBmDM+JmlCAmPpR1Wd5klpDIIFMmVkwv0vPCfk90F/GSs4S1bz8Q9khuEMPcA5DHZhkAhk6ame3hWPNSFr/7Hc+92uWALQ6sSF5d2X/SVXGGrWMi9M4z6Cq635R0qx+pNqG6mf0QqBJ36TmWCdevo50PDMEBPBpGm79+vGema/dQzjjR7ihr/9PFi1zd58W0822YcEZN2Qsd/wh9Faw3B7eAVbySkg0AjIsdvSLD2wrRPXv6KEVcb+Ce4tLNBU8sKTHEijYHEgrF2hJ7YTsaQ0rT0evgqqt7CH0C/1TQIa54zQv+h9Q/PAxf+mhSqa5XfRQd4xamQtg0FpkamEm2s3BQXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:23:39PM -0400, Gregory Price wrote:
> On Wed, Oct 29, 2025 at 07:09:59PM +0000, Lorenzo Stoakes wrote:
> > >
> > > pmd_is_leaf_or_leafent()
> > >
> > > In the PTE API we are calling present entries that are address, not
> > > tables, leafs.
> >
> > Hmm I think pmd_is_present_or_leafent() is clearer actually on second
> > thoughts :)
> >
>
> apologies if misunderstanding, but I like short names :]
>
> #define pmd_exists(entry) (pmd_is_present() || pmd_is_leafent())
>
> If you care about what that entry is, you'll have to spell out these
> checks in your code anyway, so no need to explode the naming to include
> everything that might be there.

Yeah that's a fair point, and I prefer short names also :)

This does read better thanks!

I should try for a non-RFC respin relatively soon now I've sent the other two
series I've been working on recently.

>
> ~Gregory

Cheers, Lorenzo


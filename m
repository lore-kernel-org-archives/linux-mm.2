Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52898CD6E7D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDD28E0008; Thu, 13 Nov 2025 10:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE218E0002; Thu, 13 Nov 2025 10:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728558E0008; Thu, 13 Nov 2025 10:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59CDD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:02:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06EB84D63C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:02:03 +0000 (UTC)
X-FDA: 84105898926.11.8C50E34
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6456D180022
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:01:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nbkCCTqC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LurDlMFs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763046119; a=rsa-sha256;
	cv=pass;
	b=D4gViYaerW9/rIzc35Lv+MYiReeszDPFO2LADP80YcR/Bc///Jv5o0PP6OABR4jEa6RmkF
	bZPolUfI5ru4LYslo2Etr8Fk7qBlmlIasFx5UfFZM4x3frsxt9tweCqWLRzdpXWp0l9GY7
	z2Gb7Ed5n7ArtjB+H1wSbTGNV+HwE6s=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nbkCCTqC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LurDlMFs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763046119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38j9ED7pi//z3OR4ZQyz65fO6YVmfwpDFLqMvUYJTug=;
	b=g8K0AB6r7UWFlacf+JOGgVSqDh7ZJBsUO4VZ3SuUDbppP7lLTeJI31O25eTCC9wjYq36/U
	QZbBnGV+YqJ1s0lz+B9Y1m8wDX++e3zU4G6FT7LrdB6xYltoGrWcLXH5JXAubCtMgc0Y2m
	bHdX00wh4fhMEU86O7OM5uBUX0k5nYk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADE9t7M012292;
	Thu, 13 Nov 2025 14:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=38j9ED7pi//z3OR4ZQ
	yz65fO6YVmfwpDFLqMvUYJTug=; b=nbkCCTqCr3//FA3091CH/lXmEVWYtbdxz9
	XOxAvrF8JJhdwr2UlhKK6JhOW2Vem7vOqHYJclGGMlFgHK89CqyR8gDubt3dV+Uf
	vL213evYuCf4tIvjfT77pRd714i+bM5+A+v5vSKQ7XxoLvSi1a9W7dv6GmYtjEy9
	0GqV81CdUs5jBw79IzY5l+JP/giV20a27/2Hflm+J6uPGtAcNh1dBxpBwOJuleDb
	mVGgsac8T2dldM8C7/qMUr7QoGqWScnV9ahPO0jt5IHfbKvZ/aQXnpzKou3m4O4c
	7ZD8py0902ukg5wZ8/AB4Chq8uzt4HvhwAw+hqNyD9nz4149ATHQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqsyq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 14:56:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADEFEOL039422;
	Thu, 13 Nov 2025 14:56:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac72f9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 14:56:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ohebX/lKeiMwUz+DCjUA+7+Mk/GmTiQMDjUdZQ+NHqRBg9ADg2UAWAms56aGh96pTDQLKTnAmhrVVeoG8LKkrhPKS2vwIF4qnHf9zhbF8ab82qRcCIs+IJ7/0dJQxyZL7q00wqQ2BdhmKHTiT2mtkQcJ56rWcs0cAHSiApm5j7ua8m06qePgcyA3ye7b/oDYzfMFXzKdGws1aV9RG6EOt4H4G7XeHakY4KFV6rw69CAYmb6kx8lVVA0abvitMlIkQ0OKCNZk/16wSU8eBcUR0H6r1sQkvu3sDsQvytbIxUJ+/OhPawXE5PWrEP3b6O1fNf7M1FDMAfuMVZ4abwRfzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38j9ED7pi//z3OR4ZQyz65fO6YVmfwpDFLqMvUYJTug=;
 b=ikw6M51cmK+dpOLebEbv3bnJEp1LpXp1txyHeIm90cJohk9h/iK6L0/2NhsbdY2GLRCVOAU6+n3PCatHBK4tyMFUDSPK99b4YaAzYeT6f84SsdkRjX4cWrHBbaVTrlCT8CffWlyRjk6+kQdYkv+OqTjt4Ub39Bj532jyIyhXrelvYvYmYJJFYVTyJumLO4LX0Nl+mthgfwsA5Jwsi/IdXfplR7jHbSjwxnE/eCkGhd24uo7MvM3bk2Mi1YSlLe69kKAflgYQSCTFmjN5vSm+k6FuoT0egYvzLuf7/beM4f3SsL+8TBOoPHOFy8IbGb07JuDb82rNoS9KVgW18tflRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38j9ED7pi//z3OR4ZQyz65fO6YVmfwpDFLqMvUYJTug=;
 b=LurDlMFsTUhkUu4wJNB6QUE5LkKXQ7hpNtxcqKPF3ttWtosnRX/yeFjmBM327k7KLaOFAX14l5al7N39XRzs5hfZyDv81Fo115k3RkXJb/xYwsHJb7JXcuI1F7zNwco0yBCrRnBeExQ+QJ3XcXy9LC/GRod5cH8OAh9VW99V1OA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5079.namprd10.prod.outlook.com (2603:10b6:408:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 14:56:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 14:56:12 +0000
Date: Thu, 13 Nov 2025 14:56:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
Message-ID: <b55a87cc-239c-4475-88aa-6296e67b4e7d@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0296.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5079:EE_
X-MS-Office365-Filtering-Correlation-Id: f65b552c-e219-4612-2e9d-08de22c4c99a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kODnNUkhW9HM+FWHd+GOCZDS4iFqymhVgZlhAa4TrVuugmA8W+PDo0z3+wdQ?=
 =?us-ascii?Q?Ano7KnOMLgwULEzvQ+JTfHz743gNQ1rhPoGVeoIP/ymfpVmILE7rsb7bNo1U?=
 =?us-ascii?Q?rLflBuCPuOd7ofT42dZCgIJu29ESqLihrqzG0BMpgfYEj630tkW0T9g2rFj4?=
 =?us-ascii?Q?VlNSnZzUq3YFJIqmnZNERl7JHarujiAQGXR6zseL13uydUHAY0Q+qJ2NZfS2?=
 =?us-ascii?Q?JSHR75SglsP/hZxUKgO4l8yyo7tC6SjZD2l8P3FV2TrVpmb+9xxg0l+W+KTV?=
 =?us-ascii?Q?Law87077Webbt/VZSBHxjMLASIdtGphNz1HPnDpSPtCvg0SbyQvW8Ht1/6ap?=
 =?us-ascii?Q?oBXyBzzrkCYyZc83SZDAPTkNiIc1zvjZfdEDe3iLUsl4cAZr9SX+EwNShEZl?=
 =?us-ascii?Q?SHdbSxtma1D+LnyYLruGsQpCBOQWdVFtCBagv/tHW5TkM6vxgi7t4dBCT9sm?=
 =?us-ascii?Q?HKjGT2ucS7qcVoWRpkA8Mi5yHI+nfpZ/UyAYjxOM4mUV8YgJBDFwwD/5MnqB?=
 =?us-ascii?Q?UOeqPpcWFLshEMJEMH+QxC3B7wyVNv1NCqseuP0wbB5nKC7tZieokz4/gZL7?=
 =?us-ascii?Q?fleIRz86CNXubiFBGj5zaMP5KVqBV7vV1Vzs3brR7GqjJE5SPPE4GOoqyqzS?=
 =?us-ascii?Q?/v8ynbEgmEPOoXp4L++CBuEV6SFN7I3Co6Fr6mUrRp1nlPnZHaAWXP0wFMBs?=
 =?us-ascii?Q?BEs1o8hdpP9T/lFtvzPUCf82kbO7qG8Du5zQ+mFJpdm2Hh4BARQ58UBPvkZB?=
 =?us-ascii?Q?ih/Ltc3NwzUR/2U7mPCW8lDJZVbtRQdLwP+YADdfyaf0j90fmHOq8Xxrl0ZW?=
 =?us-ascii?Q?rzV73oZop9NIeMjqpHA/g+X2KIoO/r5dBcIAzVG3ff+DL3Dr8YMty1+eTYoi?=
 =?us-ascii?Q?Pl4crAlEJOPFGl7BomXDMNWSkp42QbQu4ii+3qqR5NHSbhpGr4S1p0w+4b6i?=
 =?us-ascii?Q?98uRcgJ/teCVqpCdceJ9/HIQ6/F4WveStI7747fBzpGL4FZ/XTCoEq1W00hL?=
 =?us-ascii?Q?rqaZ+2IClCkGp2VtZ28duzNg4JjwekKxiMsYEQfbfZlpMc13JrUbjqEUkHyC?=
 =?us-ascii?Q?AcyZtOIR4h+SX+4sKfsVPR8C4lXctemEddnMx22yAZQbs35uM+P7GGtyHS57?=
 =?us-ascii?Q?WtzpKrVOULj6N3ZrLly/cQilFahYLXHNfhNRnzBoJI9kCTX0JD/ycA+FVEN3?=
 =?us-ascii?Q?MvHZqiLtD5A+HLsBk8fe63RULX+rt2+0LQBBu50MFnUKZMZAM/g3yjxThIsa?=
 =?us-ascii?Q?2lE8PlyrE5XNG6JpIQlHniZzAQZwp7QvWtiy1RUuTWU6+xuhsbeiN+SfNm2c?=
 =?us-ascii?Q?6qTCPLAUyJ0Slmg+dx8MED3IEIgkTmKzTvOn+qzSOCiajkmqf4xCEl9QMPi1?=
 =?us-ascii?Q?MXxdqvA/FiaW0hjMtCbXpHB98fBCj0l/YeUiGNz96PYof7RhIXcCqJBDWLaT?=
 =?us-ascii?Q?31ANiJcOzjpPh12+I7pNp2YgEJY8qL3o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vQCf9SYRJZt9LW+d/rqYZgTi5E13BWCW2ua0xaxPmlbYkf//iXd8S7Dt9DNE?=
 =?us-ascii?Q?CYHhvQC9LWbgot7I6neeFDLSh3ft2rjivsj/FiOW4WR+QT6oEzrZJRZInCeR?=
 =?us-ascii?Q?hDcrK8CRODK32zsMyKx0iJwPjtX0zH0niLGUr++RywBsCyfUXx7Wp3kydgNl?=
 =?us-ascii?Q?mjGcWbEa/Z8kRDTpYNupbq6euovjxnPKCgxFF27M1BpbeqYIqZsBlh1NVUUF?=
 =?us-ascii?Q?O0pmV+BHK/DkInXJfxKV7t4TwNXdTbG+DPgzJptdHMB99vKD06jNq6x6Appc?=
 =?us-ascii?Q?O0rt+S2sM9SgVPbvV5y6vk3RJ8rS2MKJqbjeUmagAul1wLNLdmZyoKwZerwJ?=
 =?us-ascii?Q?Xhsk0vp0pA8BYJrRCQY6OGoOM7v+JpWQ+kJsiadphUIvThu9bvHhj1X8WaB2?=
 =?us-ascii?Q?jsptN/J7kLg4AdX5Y7q3H4V+2/6fnHeX0fPlW7gwnCjpf32mO7uNJwKD7EPD?=
 =?us-ascii?Q?1Q9L6uhpM9gUM3S0YvaBZRViQireX+qHYYcrk+B3EO72buwfSqiAXaZlIL4b?=
 =?us-ascii?Q?HkZCmAzMmthLT1qPDrmOx7Wm8fGwWDPqPRBW/NozhfArTxOIuiC6BEmqBqlA?=
 =?us-ascii?Q?dj7pSVcTjNDZQn/xKIZxnr1XZ9f1co21hDxz16oMKmChfZCEWhX/2RGVnsxl?=
 =?us-ascii?Q?zocZSbrBmwEIbtBpPx+q0HL7BJ6LtrUdtcDi+d1gp9jascDjeyFBHiMSKLm0?=
 =?us-ascii?Q?QDmzqzY9jWuHcNjZt8DNHe7pqWn0xqGp1GGzS2c1awOG1jF1816OlJnmYcZ/?=
 =?us-ascii?Q?Le7CT7dmTL262SFe3ucm8BVBg3p75A+09dB7Kq3Q9tZUZxIRlyPmQLU/zNor?=
 =?us-ascii?Q?O2hyKcM6cXkcvW5dQdOcg/QdBHhjC1JbEm5cwcz8U1W+OsiH0v3az7gtb1Yk?=
 =?us-ascii?Q?tYhzd6BT6KS03imkN/ER2NPN0cyLP0iaiOcNyRoWWBfHL+nLxzu2lRHjc8Co?=
 =?us-ascii?Q?cT+2YUjeuaIq+tA/gFsibvLQbVC8S2NpbyXAS3ChJsl0DLiD37tcPXqKK3vI?=
 =?us-ascii?Q?blHH/0QKL69vQoogocF+RENvcRU6IdhiAC7udkI6x9x9ri7BWKkfPh1JBVbn?=
 =?us-ascii?Q?iVKq/WK8wYV4LZxy8+GXDdLvbPrTwyVmBed7DZiyeW/BoJ/Qq9IyxZ5p7NpF?=
 =?us-ascii?Q?WT3buqV4sHlnpzMzrJI1TRjK/VIGW4DeyExKSO4efNdaHMgVY762c/BZ4yE5?=
 =?us-ascii?Q?rWICzUYTO6cM1j8k8Eih0Hjk/mzQh1pNtwSGaYZX7odJpK3oi0Sv8oT7cR23?=
 =?us-ascii?Q?S2OQEkFm3YI2OTzTNcHzJfPlC6C/ERCxY3EzifiYkIBZA+QViqUxEHMZAKmO?=
 =?us-ascii?Q?Ry3Nd29RkD1rhZXlch3f0ZiFj8c10k0FxNHmxtqI7J05rVxvGuqr88/A4wyp?=
 =?us-ascii?Q?nzdXr20HEmVghKQplrxke5uHtxJynMU2ZpFeLqiyvXgf5Zw2O2DQASrAkOFp?=
 =?us-ascii?Q?a/luoCZapFAFPobhzR+S4zwknsYtvXKBCbHTy7ipBaccuoh+xF5TAsx07YjB?=
 =?us-ascii?Q?TyBQlPcwZiW90BKqrVv3fJTG6e4diFPN/UtOSf+d5ciM5nmXo1pNAROaPVD9?=
 =?us-ascii?Q?+xH3ddA76ffyVUbmj66dWTTMNG8T1MzNdOHUKVfbYd1o40aZ6xJHw3CC/CCQ?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fz8HoIgp/8fEpWrKEy/44rHUa+wpsKAJe3lnzfUWprTWnU/3QTnl3DAEs3m4b2HypYr7UL0XoxU8Ets3+EaiKcSNRk+sAM+y3qVCzTVVlT0s+btaLNFxDolklnDonga+w9OPc9qHcxdiFgd8uHTU7uD3psp8SGE9RUgopQXKPIiig/ZKNGA2m4/RCD/qVJ6UtEXbuMQIei2fTTIsIvBNrwsFpTqIE2ErUlYbXITblaWDRAS5YZSr7iBIjy0ZN4bFgNOBGn4iAJjBwKwkWxwb7EC5JOduOnjP6q50ENYxSfNZDY4glwZpkJyKQ87eoIth05uXL4fZnMTV2SO17JCDbc6gXB5NPODeH1sgwBhrtkzfbV8wzKBcn7cTt6qkoElNP2TXfOQbdlDz5ZEchm8prmfDHishohrpxWszGIA1zP/GUgAmJCfrD1K7i3J951PXmc1yIqT1w+9yGGBj4UKcaTZ+GV/u66t/747KaxprDZ5PdcZF/NsxjaRtvHQ7s7AgjzcqSAFTcif1b3Vs0SkEqGvQg2C0prqXdmTSAN2th97AmOARlRtdizFgR0TJ5vqG0xCemWl80V9nIPHL63iXJWynQ5JBkbgAYNDtNw6UXNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65b552c-e219-4612-2e9d-08de22c4c99a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 14:56:12.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnkcfSuz/Iv5sdQkX7tFMIzk9w/cO0IRdCo77FN1MJB3uVByf/lQLCyKWNEB+VBNpVh0P/g0o09Srdge3gJkCQ6z8S4Clkv8BZlWTsvEU+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130115
X-Proofpoint-GUID: 1tGG-8_OfyaaQYKUd9sMkLUrXRkrHD_v
X-Proofpoint-ORIG-GUID: 1tGG-8_OfyaaQYKUd9sMkLUrXRkrHD_v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfX3XNbruFwuDuR
 s6YZG1aMKYbNTa3DbSm2VtpVfNKh5g42ueuIY72NHdE2nrlSXg+s9ia+ghEoEOCdhXBP1xrZ9xp
 ZQTjkikL2z7vHzfXF92El+vFC0wVX1HSrgX4+4T1sG7Ib6DkjrKivsOvYSeECVWyXI2s2EW+E31
 nnPugDjXbiorJiItQWcREY9EcIqJHIkNYaZhZX0gUuCSAQe+LvaBNDw3+znknQsf9SG9E/nBe6S
 po1XKPOJ+12gOagjKoDOntZ0rEx5IMvar07zW2r58DRnFRbx+m3S/J0o56noaK+Gzpez/xShjfo
 4FaiVreoNCnC4/eI1cnhrqsSWMId6GJlbTItQLQ15GIQYieXfBqGGN6N3KD/RYqwYRpY3VDkPQv
 LTvUT/kLGv0BcJXVzW0BESBK2paUhg==
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=6915f194 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=xJS2Mvx942PPHSrvKkEA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6456D180022
X-Stat-Signature: idnem14ysympumoqxdpud8m47t56911r
X-HE-Tag: 1763046119-889319
X-HE-Meta: U2FsdGVkX18ZCxE+qxXj+Fakv+rFfXCjAwy/huFD5hKeQEKQl1en7tghfrW7/kmFgcIB7+DFt1inSvj1iP7/k+Sd8pPitZTdNUZWBvSb+k02qzsMhfzlKvca4+2a1FdhJ/2aD15BB0Db5wDqgo7e6+TxPxptB2Txbf/wxr1GavSC0pTxhZRViMVhJyGMqbvdn423o0AxanID8BfhunKTDyVRkJtar34EDzXbcgJVVoRViVt/rzc/M0/oxw3ySpnO42hZ0n8TjxtHUFFYcb3lxuVfCU5dFKdfhjyJeuLwqIvR7mjBz5VP7XZbLuiU3syUafx0iLh3vTLYDxu+YWC++urw4vmTZOQBVVXcmOyWJBMikifwk8PdUqIhtcRsi77jR6zgYZqtvoVwPKaO8/Ts5Q7aVSUOB2SvzmsoA/WU5qQW/ZK0HtFIFsOb9+Lihthw+jf3xVsrYZtiMSNecY0cyjoEY9sd3Y8znTDgkYvCUn0L0pdtGTgYp21AfrwJCrgEwOn6M4QvqGPHWmNx9L7UCb6yS+QOorYsB3+GeLGVxmIwxbVbHeJ5uAHUXHl08LVOtwH8x9neJjkeq0FdTfq8ZW2SeYekjV6lN7CmPWON8Ag3KZ45aCwh6MfqNcqB3+Xuo9sUlb8+U60x2Tw+bdRb1/Uj2pZrgPMto1YN0yH6r9EUcDtDfYi9LAiqlPgj2eoAbBIzWq6/naSfkaRjipTXFD1sZPJqjpTtiACxsfiRLaVj/zHR4Rd/SWlYo08PYO/rOzz+bmE6EwbryETaJVYVZ2HllUhP6eY54sZErpX5Q2vu5SvIp1jaUDY9f9p6j9NI+XLBLAkHKuEifQEGQeuxutngyxnuqfmZ9/h57FlQE6ulFIvXQYxWwY9Qf+rAxRMntrbJCwTqls0pojc93I98FmfNSniaKPtQoPEHjJvW0+591QofG5CkX8XDw6xgJviU5sZKJsFaR5DI6sYtg/D
 QADWVvX9
 CwUBbThbfboLyoSRhm/licUITF6jhWYieZs2rG7JKdRydXWDdDABAPr4s248jkPTN2VqhiF/KTrKFZNgoBJJSiSVdLoXe7D3i+qnYoHCfxXFc25/hlg5aInuP9dU74R89o0AbC/Ij6H3TgOS+/WG9sOLmnFcvV8bnBD17efaSyjdicIkZ0l0bvmq16i3RZVFm/bH/r5zS52Ftr5IOixtj2ojAJaSeaOPPnwHAznrsgkerPlG8yIdyZV6tmvIHtETKvnOD8r7FVGuxqiRKHVBFTVskYot0OEzaa2vcGNGkt6L5BWlmfXlXQavjKGebMNC/BzWSLqLO5apnVJQymWXsy7TEqaqbM6PxKLyPyr80V8raUZwNfSdaZXsq+bLrvIaYJ8jW/QC6tPrT6MX1T2OwPpDGCaCFplvT1WLYaX9gb8ojQcoa+IPWdZxxaYoIAiWLzz18kyQfrfgHAfuKQ2CL06aNm6RV4/d4KMTorbah4Oh3LymMVVH42Pe4HcQu7Nn32vEVQev8Sj8jlaw4KzGvkq02HBZCt7ZnzF9agvrdtQvgluHNHv8Y1m9kStx1GreX/BSrUQ24SnUwb3Ld26Kvi989Zo+UytahmZxN3E2zZ8zCnMYfGy8TF+LONJ8VWPCpp/YpsmG4toUGI74xDEgYGyIVdIHDb6rVY0wdtBifKLxIhFm8Iv8Hq6N+mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please apply the attached fix-patch.

This ensures that we do not accidentally conflict with any valid swap
entry. We can do so without occupying any additional swap (softleaf) type.

Cheers, Lorenzo

----8<----
From 78439310eded5db10692c3e8d0d322bdd6409eff Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 13 Nov 2025 14:20:34 +0000
Subject: [PATCH] mm: avoid any possible collision between swap entries,
 SOFTLEAF_NONE

The way swap entries are encoded varies by architecture. For x86-64 for
instance, the encoded swap offset is the one's complement of the specified
swap offset.

As a result, device 0, offset 0 would be encoded as 0..01..10b.

This means it is possible to specify a PTE entry that is both device 0,
offset 0 and something that will be identified as a swap entry rather than
a pte_none() entry.

For other architectures, the encoding may preclude such entries being
valid.

The softleaf implementation currently depends on a 0..0b entry being
uniquely identifiable as a none entry.

This is therefore not a safe assumption, so let's fix that.

PTE markers unconditionally occupy a softleaf type, and currently use only
3 bits of the offset field to encode their type with no further information
recorded.

It is therefore no issue at all to add an additional marker type
designating the field as a none entry.

We also make the none checks more canonical by adjusting softleaf_is_none()
to reference softleaf_mk_none().

By doing so we avoid any possible collision with swap file entries while
taking up no further meaningful resource.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/leafops.h | 8 +++++---
 include/linux/swap.h    | 1 +
 include/linux/swapops.h | 6 +++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index cff9d94fd5d1..74fd95b55e9c 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -40,7 +40,8 @@ enum softleaf_type {
  */
 static inline softleaf_t softleaf_mk_none(void)
 {
-	return ((softleaf_t) { 0 });
+	/* Uniquely identifies none entry. */
+	return make_pte_marker_entry(PTE_MARKER_SOFTLEAF_NONE);
 }

 /**
@@ -72,7 +73,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)
  */
 static inline bool softleaf_is_none(softleaf_t entry)
 {
-	return entry.val == 0;
+	return entry.val == softleaf_mk_none().val;
 }

 /**
@@ -199,7 +200,8 @@ static inline bool softleaf_is_hwpoison(softleaf_t entry)
  */
 static inline bool softleaf_is_marker(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MARKER;
+	return softleaf_type(entry) == SOFTLEAF_MARKER &&
+		!softleaf_is_none(entry);
 }

 /**
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..e5abea55448b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -112,6 +112,7 @@ static inline int current_is_kswapd(void)
 #define SWP_HWPOISON_NUM 0
 #endif

+/* Leave a type reserved for softleaf none. */
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
 	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 0a4b3f51ecf5..04e74716a845 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -419,7 +419,11 @@ typedef unsigned long pte_marker;
  * PROT_NONE, rather than if they were a memory hole or equivalent.
  */
 #define  PTE_MARKER_GUARD			BIT(2)
-#define  PTE_MARKER_MASK			(BIT(3) - 1)
+
+/* Internal use by the softleaf implementation to represent 'none' entries. */
+#define  PTE_MARKER_SOFTLEAF_NONE		BIT(3)
+
+#define  PTE_MARKER_MASK			(BIT(4) - 1)

 static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
 {
--
2.51.0


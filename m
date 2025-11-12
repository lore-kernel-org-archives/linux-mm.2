Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8CCCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48338E0006; Tue, 11 Nov 2025 21:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20028E0003; Tue, 11 Nov 2025 21:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7748E0006; Tue, 11 Nov 2025 21:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 988FD8E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:58:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42686580F6
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:58:48 +0000 (UTC)
X-FDA: 84100447536.30.BBD534B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46FF08000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:58:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U7VZ1F7S;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762916325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX52ichgjC044UKTP0yfsUJ91M7raRwWvWEbTKyzhSU=;
	b=sycD/27oxLWGMc1ye2XyyxO0qMHYFrJNPbpPxPHXcql7y6E7sTte6JwRM2K20xL0ywWV1M
	/vn45Exvrc6OWRJ9R8Tk3LmdppatB1emxkRn7kExkGcluxjpt+DSRvfTjc5E19mzJXQJlr
	33Nen9P6BiM58VUIOBBvXHRdvpFQwFs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762916325; a=rsa-sha256;
	cv=pass;
	b=BPXeNS2IYYdwIS1R4a92Pd7jaa9OncrbcssDE6GL3V1G1GnYoNI02nZfPv8Sa4DgKxIPGX
	7NwM9TkaYiG8BnZ9Vz0RJAUROlBT4ew0OJTaRXsFytP95tTlRHznpVHowBf2VsLTvDoy4M
	0FJH6w8G74dgrKJf/LPd41Mjj2Zf3y0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U7VZ1F7S;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqr8VF28ML9PFRYA/t46MWdVj7dXMeEJpe3H22tiMEKvfEUYDhUpanUSkG6G5cohyUlnYMJqhLQY8F7XNiBo5CEhRjodnT317eZ3LnWGBrwcgMhszSh8GwDlfQCeWGDqyLwXFY2mQmgg8PYgEj+89bts6G2gJNq2/Zcb5tlOXy00SkwxD+YGCx9cJNXq6dQJMw95Tw20hniQLk5v1aWvhYxsrAz7lj6jVRI5dvC2tootwkjyZptupmoCToPlgm3lcaGgmKT4oHqqxQqNHxDPuOMcqq4Uz4N0Gz4sqHRnUFTuNIZ64oPLhWp8gidiWvEH5w0r5MljPjjcdyCHqVDurw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eX52ichgjC044UKTP0yfsUJ91M7raRwWvWEbTKyzhSU=;
 b=bfpNADeneyo3oc91tGt1eGyKp+lGc/akbAmBUbHtnUhf8zhTag8Bd9Awe/xidvl04XRY08C/DrdQMYoOINlut9OiJg3jXCqyf9lPHR+49LzjwqQEhJvqYHMpBsNLdlnADJ8A89XUgTGCWUTVeoyDXeEIePMY6blT0Ifs212U7hISaU+zPSEcniYzzOABueYA42Tkko3PdwyRj17Y0SqXcx6OMx53CG+MNUbHxQTceRRprRiRROpjklZ9G+r4OK1T+njlp6+WDE/Nx2JeQIHf4DAswxg7ntyyiZEqkk6FtNtdt9X+YW9SM9qHsb+HI/KSt0yZ4m/X6dMDICavEtYgmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eX52ichgjC044UKTP0yfsUJ91M7raRwWvWEbTKyzhSU=;
 b=U7VZ1F7Sx68CpaOzVucgCeArbitRNjy5UR0Uc78stGxt4leGR2o0VbOoY7YFvt84ZmylHuEPA86qusci8HVmq0Ngp4dcrTdNouVp2L6C/r/1nL17gAGdFLAbrCktLjnwjG+4jiezsht1drnzrPIt2InCdTjs8kwCWaBo1whxx3S3NUSFss0gFyEpJXYALVnMxT0blyDoqOVpTtuRA2v90shz2aQepv0MqhR8Mokc5XnJ5MGCzUtaCJ19Ck96aGXf9kpy8xB7RvAq+lQpmHylyc3H1d5TcV9RhV16ge2BXKsvAQyCD2Ut6PhbTD/ZiETH6LvPqDq8+zRbaZjaV8XqwA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 02:58:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 02:58:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 03/16] mm: avoid unnecessary uses of is_swap_pte()
Date: Tue, 11 Nov 2025 21:58:36 -0500
X-Mailer: MailMate (2.0r6272)
Message-ID: <B114F7B2-8EDA-44DC-8458-79E3FF628558@nvidia.com>
In-Reply-To: <17fd6d7f46a846517fd455fadd640af47fcd7c55.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <17fd6d7f46a846517fd455fadd640af47fcd7c55.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a98c80-878b-455d-9b21-08de2197624f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gMoKcN3fAiCi6MBuaib3VlrZJnEwrrNINKrcdr1c90MAs5athBUtXPQ9regS?=
 =?us-ascii?Q?kJr5kVtIAFeMAFfNp08l5oKSpfhEv6rk+sNwjqGctjbIt/uS/mFTK5AA9YCq?=
 =?us-ascii?Q?b/a0MbQKFHViauS6ra+hDkTa04Jsd4u1tRc1/1DP557eDRPaueI2RaxQDr7w?=
 =?us-ascii?Q?Ggejh3nJyyp2P1+//+yxVMpSLjV7sI9hdsZEbsFbNa+OVKqAyzgBwbDBfDeX?=
 =?us-ascii?Q?PNLZgb3rOq9uS9YcKdFGLs2kbCXVzr64KfkJkT+kdjKQIvaR8ZzoyleiPsxe?=
 =?us-ascii?Q?DMQP78D2r4/bziuPls66EtVofTG8T9llZdVFcwUSrxLpPtJ90ZEKFI36ahkS?=
 =?us-ascii?Q?00dDeB1lM7MUjLb+rlB9CERLA42sTw49eAmsW6xPqCSyuXtBXBWYLSW7xw+c?=
 =?us-ascii?Q?7O7MgcPqHtcmCBEx3zYvGFhYq3y+uT0kRaY6WA0MlSC/QL16mPmZMgUwWLLD?=
 =?us-ascii?Q?35QWqjKW9Q/5uWsFCeq6O76gshKHsjBnf8+JUSzgqoucojat8JebrklRdsT6?=
 =?us-ascii?Q?/FzAiVxgDLYK9gBCXGtX+S8NHdRt26HHcDj8bMdclqMAX0MGJoYq5VXWjCxo?=
 =?us-ascii?Q?KuQPW1TPHIwxadsq27ikO2NuBP7qsab1QQMhIYbqwekwJO9eS5gBonUY4N64?=
 =?us-ascii?Q?trI24DJojo8mimQG6rcG1VwA8NQyAISVxwaSPI3o1GbswD9FOpo/8Ms8diYo?=
 =?us-ascii?Q?5GWgiVnixUfNmXWmgg9UP9qlS54W/fbdrXv5XrAhgnj5w23WgQo6mxFIXIq8?=
 =?us-ascii?Q?Fvz/Ydny0MRG0BDFCN3YRlbM7AphNL6MzKaQrrq1pZtzNYytYodDtZprm/P0?=
 =?us-ascii?Q?GkqQsiIbOr6zJu96KTM8urI/ftJaWs5AdPpsT3hWwnu5vMyo6Q11b5UIwsFB?=
 =?us-ascii?Q?6yDhnZ5XsAKlNDGgSlj3oPrwFEDFS4ccTEuhSbLM4dMnZ904fnmvkrVjkLW3?=
 =?us-ascii?Q?XyWtOJy3jelpa0HUr9erxWE6IxOmQKoH1/owFziLn4HPNA+Y1RC6puMpbYOe?=
 =?us-ascii?Q?8wx8BqadxZRrSKfPwVQ+46YPysI9VugKdVKEDmwP6ptStT8p5Jqcu307PRsp?=
 =?us-ascii?Q?eWmr9o0UOI5mzoFuT9iCPq+RuHSrOD3WLJH1EIvJFLMpfIDnKUEzgnCG69Oj?=
 =?us-ascii?Q?KlZNzLsvkCP2m8rIbg5YFf+HPG5RF1fyU2EYTjG1GUI9SWhV8Yk+y6dMOqT1?=
 =?us-ascii?Q?mH71uPNK8/M3HufTWPwHYsghQA66fd1TW0PkxBTXEq9RzP/PwuQLtNsIOWks?=
 =?us-ascii?Q?EImOFVPDdZZI6BdXgy4Bw0CLebdOoLVQju+Mi9pkX/hPQaXZ2MOD/ZLEjEvM?=
 =?us-ascii?Q?YHNeXdqqrZd1ra/ZCO3vQd2X2MlfzknG1vStR3DWOqH2ApTb1XJgfGkp7FqA?=
 =?us-ascii?Q?DGNbjctILSsc2dG0KMTwfCzKc5gSOGe2Rp0xGmtkjjvOptZgUXOjKG6zG0W1?=
 =?us-ascii?Q?OV2p+N+FIe+W+s36DfVuVvPDyG4u/HVS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7B23abkw97vk4lQRjDbiNEK28WuBTCyknHcosT2YxWcTtkz1kg8mF9CenLkC?=
 =?us-ascii?Q?G9noYLGcSipa6Ja6X8jBaj5unWxc0Pwh4tGIaH1DEfKy1LENI0U19ctigAd/?=
 =?us-ascii?Q?axhqAYOxzeh2yjmgh03lS8toCge91q1iQS930Hc7JfPZeFGZlZfKNrrdwC8t?=
 =?us-ascii?Q?nM9O8dYjkXEdnrFDeG6BGxxV105Uzn69CutzbGsI2iPpgsUEixu450Qqhzgz?=
 =?us-ascii?Q?vDUgyhkiAUVm5v+pLISfr/f18ue/BJf+6QDESlsZBFYy0Tv7q2juSM7d8opW?=
 =?us-ascii?Q?jV+KsKPf1URDuKdNs1Zdcfg7L17TOIsTj4GY5KZEfOsgWOmLpI4DmYNQ02LX?=
 =?us-ascii?Q?6LmROBSb7AtSBjHP0c36muBygbhFz2SZ8Ua499wG6VhNULGPt+lYMFYm/+yo?=
 =?us-ascii?Q?weWR4/4wwXc+lhT4SysUuo1MikPOQ0c63rHMKAQp9xr+zgayf15n6rPLnWXJ?=
 =?us-ascii?Q?DT+pC0N2f0r0ddOww9BmK8q9l2u8ipxhXERP+Qyjb4o4qWeZFtla3ER/8L/L?=
 =?us-ascii?Q?4rRtZ0av1Bsn/vtw9f+0H3Gvl9VGPWDb2tmVNWll6hUJd+/cnZujNAgEIVru?=
 =?us-ascii?Q?vR8VXHGTS4YX5X4kgcyBn2LZdFBZxK9mpP6UtAtHexhRBOJDXgQYlxYA7tKC?=
 =?us-ascii?Q?xUe8V52wZ80WZ/NUkG2d03Itg1k4Fxk8yLvDPSlT0e4wUPXm5q/FdgU1dFy4?=
 =?us-ascii?Q?1UkrJ2kYrKbnByBJ52PZhQXlClioHxzt9uUiLravwtcycOCPi5XkTUWnMzwB?=
 =?us-ascii?Q?i5r6YK9w4C9V+yWY9LD9ceUvByi1elxR0ZpOQaAQCSiAwbxUa21z2L4dIFPD?=
 =?us-ascii?Q?NA/qLHJMJ4M6kJT0lTv7eT8sDdNyqzIlgc7fkeXCn4mENPOnir7jqeS155jR?=
 =?us-ascii?Q?eykVNWMK3vBTp+OYHx4w/aq+hvJLraT3nfEjMUBfC5yYcjIw7k3VCnliSK6O?=
 =?us-ascii?Q?tRgQ6nPHTAzBxJGqB2FfsSCuMX+bgKi5YW/117WKUxRegUAucp7mWjMMcgbO?=
 =?us-ascii?Q?9oSe+aONtr7gkdl98V1/Nm9haGhBQXXKJkJu7ZP1X9b/JOrv8pQnSyN7oue0?=
 =?us-ascii?Q?S1qGcfcmu3sziQc/cy/c5knkN6pPNXLODaQOGR2te6rtrfRDRPaOAPqXbYLD?=
 =?us-ascii?Q?B/2IoBFY6ahaeT90ox5vaVLGoPtb0muzRnbbHoePoDe6zMG6J77HQBq3YOMf?=
 =?us-ascii?Q?nN12Duv4g7xPANBguBxkvOwVoxdGQWGweUa47uGlDSmRng/tIPeOPM72cl95?=
 =?us-ascii?Q?D27Ovp3qQVfk+AcB/m9MHbiGkTmjYEx5Ku/Kv+wArQBNWAdF3nWVV9uGziWd?=
 =?us-ascii?Q?4/8L+Vczomi6jeyIOK646T3upVyGS1UT1/qHmjbjGiXPgiWoSB2dT6gjbBE4?=
 =?us-ascii?Q?9T1JPFwqbPPExnJ29gIG6ecO3jcj6VNQCxyJo+thVwa4a7A6kWzTFKO3nPoa?=
 =?us-ascii?Q?KnevEAEk5DOyrqe8TA+rI+fRK4v3BExK+JzATcEGfUPMl7THlM5OENHGaXNJ?=
 =?us-ascii?Q?FFUx9Lp5yBb0oy6ZM4N7eR0rqteYH3ioETmUwIwTqptCavKUaOS+ynF1kq2U?=
 =?us-ascii?Q?x1MQMobNYHBESLkNcJM/VXDnhY3DlWJzUJY+Zim+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a98c80-878b-455d-9b21-08de2197624f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 02:58:40.7760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jlzq5Z/Is52aqMPPxyMSx7pBIgdC6aNw1msyEBUQ4l0rTBgrDkRwvyRLjMDBv3V/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Stat-Signature: fjffxjoexbmc95njp9n7hmepod3kfiug
X-Rspam-User: 
X-Rspamd-Queue-Id: 46FF08000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762916325-209389
X-HE-Meta: U2FsdGVkX1/g6nkQhGPMCa/B1Qf8mmEsCXcbpqvVFxIbFzPxGd+mV7Wrf7BY2Gsv3YhvYTq9hPHqoE+bDcoE/oQZXKrIpCOFuc0ivFN9O0guzYoAGovzYjJc7mqb+cGEFAaYuSlWZux6OR4Dq599JZhDgIIpxyktBwlCQ4VR9ZitYsoGs8kSr/gHEsugvitDyCWzRunSfTR1/76xP83dumIueKWaS/0IUdjgIdVnju/Zj7ameQCw7QWqyW30yGCZavPRCfwoUfctNdBopeg24IB0j19olStXMut6JC6//RIxRDIfnlW6fAxyCbMf0erWQZ7ZEPJBGIBKEP9wB7nuTTmqhM94ZuxDdrlJ3mHcV1izZ5INnA8l6Cy6VAhL0U8tKBkoPuoITHYRZh9Kq3GGTCmeFydDSFR4S9aINbmA8x1pgj6KkIl1+SDbe1TZyIzEz8e0Pce5vp9ncMWjkLN6XPVJATJJBNt7Sib+BT6K1/WhRQ92NAplctflap5nYxCmK3jbb8AoC6DpnT8kIpeUro/c2VpVerg8HUcvzz06bag5/Oz01mQtukfn3in7q8gfdaC9RWbL0Go+neMmTCjIO33e24v39C2UMLIM1JyL/FpFfhRKj9NV3O/yCNVdmC3aGfCf1c6yVMirYd/GbSUUjg2JSCQqaP82DESJW9KTnkxIhMcIKSM55VeVugiCR5kOufhX7qq31WjG4d/13sJMSeayc+PJK93NDJvETMKaJdWDuxxrgR8ADOBGDEyspTrwzlPU+yGBx2SOFin1noSWORvPyQWBEW/ivUWcwDl5NxuFSNwKQXFf0XkRU4bP4J9mb37LyDlns3zU3uWSZvwl5CBu5COHcO+ZOFxrSmmwFjJQiLgvKbOhxZvgTKRBcSEb4HMLiLn7MtstvJGEfogkvRjue7FWDZemyUkMqgeFw1z5cPjdRvcNZS9ATFohghzCFJU4h1pUEd2seb7MHlM
 mNTZYgi+
 1wKX4zbAYxOxtGwnn0D5R4pM4mrUuVYiZfp0c9OQ0AF/O6dtvL6MGiLtF/RcVNUZU3gbgbv0EeO+7gTz3lOHYfTWQHHPXRrap7q0Y9Nk4ul/Ge+ohrzd+UdbOIaMqiHq9rYX8EWjI38EI3T1R4ldxxbIn4cOdrnDV5VejxyJtxfw5OVxrM/WJTuYLWCsLF6V8iOnKPzhkrtM8MNAcy6tDsTOAhFbMe/cZtIwrbSquQVYbB3q6y9Kt1UW+QNdFvjpjfqOcAMtOmC6sCzdG4zSFc589b1xaXnfGvpE5PZQP3fpbIT6vHj7nsfLCTYUc0o5HiE9n54LSLai+Cj91b4B3NnOihDV2hbntxIPXtHk2EKx8MBctUlgTKHjErHxHzhBEqur1PA3CErYS975HXQK7xvQ2s8T+mFkpLTyWlNRg7XmB/FisAskyi0Gz6K+H5x0U1BZAmUoNZl9QpaAH8TJKH1vv2dxph+FoYGDrZiGmfmd/bSLTifJ2TNNP4XimypUg0vOm3pRSGY4oFGSrYTLKRNvAKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Nov 2025, at 17:21, Lorenzo Stoakes wrote:

> There's an established convention in the kernel that we treat PTEs as
> containing swap entries (and the unfortunately named non-swap swap entr=
ies)
> should they be neither empty (i.e. pte_none() evaluating true) nor pres=
ent
> (i.e. pte_present() evaluating true).
>
> However, there is some inconsistency in how this is applied, as we also=

> have the is_swap_pte() helper which explicitly performs this check:
>
> 	/* check whether a pte points to a swap entry */
> 	static inline int is_swap_pte(pte_t pte)
> 	{
> 		return !pte_none(pte) && !pte_present(pte);
> 	}
>
> As this represents a predicate, and it's logical to assume that in orde=
r to
> establish that a PTE entry can correctly be manipulated as a swap/non-s=
wap
> entry, this predicate seems as if it must first be checked.
>
> But we instead, we far more often utilise the established convention of=

> checking pte_none() / pte_present() before operating on entries as if t=
hey
> were swap/non-swap.
>
> This patch works towards correcting this inconsistency by removing all =
uses
> of is_swap_pte() where we are already in a position where we perform
> pte_none()/pte_present() checks anyway or otherwise it is clearly logic=
al
> to do so.
>
> We also take advantage of the fact that pte_swp_uffd_wp() is only set o=
n
> swap entries.
>
> Additionally, update comments referencing to is_swap_pte() and
> non_swap_entry().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  fs/proc/task_mmu.c            | 49 ++++++++++++++++++++++++-----------=

>  include/linux/userfaultfd_k.h |  3 +--
>  mm/hugetlb.c                  |  6 ++---
>  mm/internal.h                 |  6 ++---
>  mm/khugepaged.c               | 29 +++++++++++----------
>  mm/migrate.c                  |  2 +-
>  mm/mprotect.c                 | 43 ++++++++++++++----------------
>  mm/mremap.c                   |  7 +++--
>  mm/page_table_check.c         | 13 ++++++----
>  mm/page_vma_mapped.c          | 31 +++++++++++-----------
>  10 files changed, 104 insertions(+), 85 deletions(-)
>

<snip>

> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index be20468fb5a9..a4e23818f37f 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -16,6 +16,7 @@ static inline bool not_found(struct page_vma_mapped_w=
alk *pvmw)
>  static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,=

>  		    spinlock_t **ptlp)
>  {
> +	bool is_migration;
>  	pte_t ptent;
>
>  	if (pvmw->flags & PVMW_SYNC) {
> @@ -26,6 +27,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw=
, pmd_t *pmdvalp,
>  		return !!pvmw->pte;
>  	}
>
> +	is_migration =3D pvmw->flags & PVMW_MIGRATION;
>  again:
>  	/*
>  	 * It is important to return the ptl corresponding to pte,
> @@ -41,11 +43,14 @@ static bool map_pte(struct page_vma_mapped_walk *pv=
mw, pmd_t *pmdvalp,
>
>  	ptent =3D ptep_get(pvmw->pte);
>
> -	if (pvmw->flags & PVMW_MIGRATION) {
> -		if (!is_swap_pte(ptent))

Here, is_migration =3D true and either pte_none() or pte_present()
would return false, and ...

> +	if (pte_none(ptent)) {
> +		return false;
> +	} else if (pte_present(ptent)) {
> +		if (is_migration)
>  			return false;
> -	} else if (is_swap_pte(ptent)) {
> +	} else if (!is_migration) {
>  		swp_entry_t entry;
> +
>  		/*
>  		 * Handle un-addressable ZONE_DEVICE memory.
>  		 *
> @@ -66,8 +71,6 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw=
, pmd_t *pmdvalp,
>  		if (!is_device_private_entry(entry) &&
>  		    !is_device_exclusive_entry(entry))
>  			return false;
> -	} else if (!pte_present(ptent)) {
> -		return false;

=2E.. is_migration =3D false and !pte_present() is actually pte_none(),
because of the is_swap_pte() above the added !is_migration check.
So pte_none() should return false regardless of is_migration.

This is a nice cleanup. Thanks.

>  	}
>  	spin_lock(*ptlp);
>  	if (unlikely(!pmd_same(*pmdvalp, pmdp_get_lockless(pvmw->pmd)))) {
> @@ -113,21 +116,17 @@ static bool check_pte(struct page_vma_mapped_walk=
 *pvmw, unsigned long pte_nr)
>  			return false;
>
>  		pfn =3D softleaf_to_pfn(entry);
> -	} else if (is_swap_pte(ptent)) {
> -		swp_entry_t entry;
> +	} else if (pte_present(ptent)) {
> +		pfn =3D pte_pfn(ptent);
> +	} else {
> +		const softleaf_t entry =3D softleaf_from_pte(ptent);
>
>  		/* Handle un-addressable ZONE_DEVICE memory */
> -		entry =3D pte_to_swp_entry(ptent);
> -		if (!is_device_private_entry(entry) &&
> -		    !is_device_exclusive_entry(entry))
> -			return false;
> -
> -		pfn =3D swp_offset_pfn(entry);
> -	} else {
> -		if (!pte_present(ptent))

This !pte_present() is pte_none(). It seems that there should be

} else if (pte_none(ptent)) {
	return false;
}

before the above "} else {".

> +		if (!softleaf_is_device_private(entry) &&
> +		    !softleaf_is_device_exclusive(entry))
>  			return false;
>
> -		pfn =3D pte_pfn(ptent);
> +		pfn =3D softleaf_to_pfn(entry);
>  	}
>
>  	if ((pfn + pte_nr - 1) < pvmw->pfn)
> -- =

> 2.51.0

Otherwise, LGTM. With the above issue addressed, feel free to
add Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470E5CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B84F8E0007; Mon, 10 Nov 2025 05:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068D18E0002; Mon, 10 Nov 2025 05:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24448E0007; Mon, 10 Nov 2025 05:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7D328E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:18:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3212612D8DA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:18:49 +0000 (UTC)
X-FDA: 84094298778.03.F7D5857
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3BFA1C000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:18:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pw0rmSd3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hPE1WnR0;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762769925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WD6qTc/tzJ4Bvl/Ak8MrhObAErVWMH+6u8pGmMvT9uc=;
	b=Mdq8Gf5nh0Qawtcu+BSMOssONinFYX3wgoJcGZXfdc7h8kIWjJAX0zp6WgwSwbJvrwF50y
	5JbiVy2j1MZY8+Uxq1kI+oVmGWU/7epHweylrYIjqtqVuYiCZ6J9h73EScSoGB3NWoQxQD
	BZrlKp16NwV/SIKwU03juwG1s8BuIk8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pw0rmSd3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hPE1WnR0;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762769925; a=rsa-sha256;
	cv=pass;
	b=uo/JPdGaTDuw+z8APT7wsET4dvhVdKWadsf8dlxNTZ2MWXBKAcOT36R9iEURn4XYYY6vy1
	b/NOfAc20C392qLXM4fu9BaXzZfrW7lDItZCPWryiC0hwlCNnq2d0mlTy0obhiXRDhbLPk
	ZhgmeNwXKilBfUzc8j5NU4LcpgujjbY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA95Bog011538;
	Mon, 10 Nov 2025 10:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WD6qTc/tzJ4Bvl/Ak8
	MrhObAErVWMH+6u8pGmMvT9uc=; b=Pw0rmSd3gTYZOStaubyNh7/aJmBF3g40EF
	IDFMPjCA5LHoZCUgc62iVbci6PpSK83i/IpZFqha3nX+5/7Gt3S5oVVxSQkI+iwR
	Mly5QU0UMdVcL/6X12woQVsF1C9PdFrTAEm1T1Nc++uPnRK3z601eEkmgrm2GpT3
	pKHZ8xUk/lDdLcCH5gNslOiT/KdFqA7wjoFh2I4va159pRUkzlKAGfzpNuJzRxvS
	2EUCCIRIq9Z7DxreEkmr9iUJdrWEYuzIeK3490o3lX2erOu9cgOMvF6K02+xWXe6
	4wyTvQFtnA0zxsCObf1N23Yw5SwY297cb4S0YwDZ8PbrJtfZCLOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abd3wr6jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 10:18:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAA3aZ5040006;
	Mon, 10 Nov 2025 10:18:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va7y5d6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 10:18:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flVUhoSs6QNPPPmYfhD+Dkj3MUBxbgkHOloRg7VyH2VVV8NsbvZudsBssR1FkU08XUMKZWrhm3z+gr3ckJgqDgAJiJSyAhkYTVibE0E0LgUvrooPNCHG6dHIFIVDmmEQF+MPY90LJ4w/5lQ91/AyfHp7Bky6MA5yUT4ckt/qS6+tkQ+PJeEnd1YlYScK4QzbHr3XLjg4PTGhtBANCWUA4JI+L0+v9hgCs6jNDrTjesqT/oX0iIZzD4rUAF9S0lr0u8V4vga4JcjY2VCCwGU35OC1O/TkZt/7ogG9b7MTRi/LYHGAb/8ikwRyzCCnRI4iab//pIfOr03XMXK80qWOow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WD6qTc/tzJ4Bvl/Ak8MrhObAErVWMH+6u8pGmMvT9uc=;
 b=rK+AaIQhmLGEJ8Ge+RXvsgvK8etgDItMvszXYmvCR5dP7UmgLNdhqAOq6Zs/f0mMf1hxD3lnpUnCh2TPDAheQLdWMjeGnO6BQLBvYC4mSdI2DEHa9WTeeZAnEQD1K4Us89VbJJAMJ3Og5GE2MW4/kc2J3l/auXgxJcr1oJ60nbys+Nc01RvbXwo69D/EGBRfo/R3gsHpOB3FHMTq/OB/W4TOuDJ6fbxoKepM/qUp/uCYE7nofHZ5uXW76UTlHaprbjUw+o9THO5NcpBHc8beDVAX1v5HmZurgOiD0gZvYa1ZrlCnktPyhJR5HjNh5HWfeuQlalGmfAhiZZvQWJHiwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD6qTc/tzJ4Bvl/Ak8MrhObAErVWMH+6u8pGmMvT9uc=;
 b=hPE1WnR0IA3BAwcSFTfPP5e6oTZnSGIR4s9K9N9tzH6rxyTgNwigWnM4cIOAIp/mK35LAO7lCxrNhAAQjSR+yt9GNmSk+6LDEFdOjvEPO7WrOUZ/YfrCyoCuGoP7RD/fi66fHEGgK96Rq8Te8sDnI2/z3kEiXFd6tL5DX1kaQ/w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4879.namprd10.prod.outlook.com (2603:10b6:5:3b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 10:18:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 10:18:18 +0000
Date: Mon, 10 Nov 2025 10:18:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Chris Li <chrisl@kernel.org>
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
        Baoquan He <bhe@redhat.com>, SeongJae Park <sj@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
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
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-ID: <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0006.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4879:EE_
X-MS-Office365-Filtering-Correlation-Id: 12eb1a5e-db02-4d3a-f352-08de204277d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4s3m4FKl+asqDfdliF7alJBMnENCFPWxm3RIuaobypHbI01Hr+iTzpu45DOW?=
 =?us-ascii?Q?uAFUcKdY3Fo3CTkNL/c8q/U6w6P5AyaQ9V6LZT54KLHcup2MHJBxkxk28g5+?=
 =?us-ascii?Q?/SRZSbUUSpwf2jT4UFPlkzmlYSVyRpgKDxk1zIwdCeF+bzAcNzEKilka6Iob?=
 =?us-ascii?Q?i1TgZfKXibixYA1Jg/5oISG5rgUIiZWmS3C6slJ7gpekMiM0DTofpPNoyXxG?=
 =?us-ascii?Q?tQn6y0GXztHY8y9beu6TY4R0u7EIinAIeUy/K25gnGMi4c15i+0d4iQd+xnT?=
 =?us-ascii?Q?lWtuyktjOSHhVh8b/PeIqirXb6Yz8r139Ihs0r4fDRCXK9J619vr7YhQmXdG?=
 =?us-ascii?Q?7H2PQ6ctk6asyse0Hs4cDGep0i0s7p/nMU9XjRXvH4CzKMJgc6NOD+Up3/Gm?=
 =?us-ascii?Q?HusbpNWIBCTpQscNMNziDSQ+vTTtB5TDCxdtH6s8KtQaZCGS4lEjOqsLRVqy?=
 =?us-ascii?Q?TQ5qGS0TRnGWxR55XOEWPgIP7vYbDLrrl6au+S6m0rme7cSPDX4s8BcTz1RJ?=
 =?us-ascii?Q?t70pu1CrFyG7NOQ/wuzdbqDLwAn7m6BECZrhISkSrTBwFchzRK9Wy/fL4/Kb?=
 =?us-ascii?Q?foWgCYt/5ePjYDJgUveocYI3QCfwp+VX0KDPrEXMG4f6c1wmRgMB957S2FS6?=
 =?us-ascii?Q?4oLQKSRcHyGnJKybEc8RYiKR+mtvGwLcNhjzHBkH+Kukv7os0G9StSO1tPq0?=
 =?us-ascii?Q?mE2WiHT7pScObbIsz21NydgUsj2jA7ty5yUJAx1ygEr3tpCNYti1ONDoL8SR?=
 =?us-ascii?Q?P1T9UokWc+uszKZodTbjZwxzLHo8j+8VlnCeOhBIfd9HJ+Tf7cvDNJyiaUwT?=
 =?us-ascii?Q?VOHQyBn1MtHrGmEumxp0L5oZsyhRpZv97Y9xRa4aXFDwJFvSz6u0HKKwuhg6?=
 =?us-ascii?Q?D+eHTkAsJtLjYKfs+hfmxmjaKkOIW2fxVN/MDRWuZL5xWQrIeGUmQAKasumF?=
 =?us-ascii?Q?W10UgeeYVq+Abbj0jFEcg/744NNGu9Q9UqMOwaIjo+vSoKw1g+3kJqbtV6TI?=
 =?us-ascii?Q?CWYW3WXgTBLaJwH++E8k8c1JRU/gJcw8CBiyC+ErZGZYvo5hvSSdebJbqrY8?=
 =?us-ascii?Q?M6RmqTElklxcUOnR+7ijiez6k6Pmr9abPWgQRqRCKDWuVr8CeAzHsAH/0k1I?=
 =?us-ascii?Q?iYyjhj+/G5sZG274v1wBJWNw/Jklx2Slp0rvcStJ711QnoPbaxCfOktJOIvv?=
 =?us-ascii?Q?9esxH+Ijzs835fmp5Uy3CXn1hJ4at06cRWeB7DWm39n2EIsWHBEDTj+DweEl?=
 =?us-ascii?Q?R2sdPomuw8w+QxFCClw546RYaKVd+HSuyk7YThz0dOMz9RY06ahybH4KU2Zg?=
 =?us-ascii?Q?oTA15KNHCBEIoa5SGlECza53UP1aRVxT3JYvkC70OQUMHJXwqF1IjKOZCFhF?=
 =?us-ascii?Q?yfdhndrk6ayt+/C61rX0G9Oy7pRYcQQNvT8Qh8zrasZuIXVqhf+IEOkvViti?=
 =?us-ascii?Q?pHx8LrBd4LKcf8trdWWIyuNg3tfdD7kT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lnSmZLokf7T4mt+av8Xu5ggjoH9sdMACpEUSj5o/+yWOUd00Ig98P9y14l1O?=
 =?us-ascii?Q?SX9vwNhWfhwNAaUzeDV+VopORQxP3oHSO0v7qGVx4JjKXdSWvOXFv+BTVlDz?=
 =?us-ascii?Q?PJsiRqvsxTAzU7LTRGhwDzUGbiFKEX23abeeneZGa1ZmeWytZYxyC6LiOgH3?=
 =?us-ascii?Q?A2AD4X9KOry6GRgkBVhtqpTDk3kRZXyQ5tpQ1+6R1dMPHaruixRR7f0JTwo8?=
 =?us-ascii?Q?EpJd0yOZoa66aAcLOiNuf97sBcTMn9faRvW4D5FSjfUqOgkCZAIJWpPm9Wmw?=
 =?us-ascii?Q?MxMOl63Byf/L0io08WGnPiuzgP4h03TRx7gW736mB2PPy3/EHI2HM0J/MgIy?=
 =?us-ascii?Q?01DRliqbqbJ51Sf3sU4CxbzrDJ9uxvkZ/LqV+pmwNq8WOrTjFq7oLQ8IoWGZ?=
 =?us-ascii?Q?BWSYQacAot2JiTCLT9J7Cp9wsWuuKBBvLyZfS95UkP1aT2yib7yKGTR+Rt65?=
 =?us-ascii?Q?axNKk9DWfcHqR63UmSV6lMxIHmdaNXmMjGyc2uH4v8v/GitfwuHqCEhQlIT8?=
 =?us-ascii?Q?uVFzbK2dDHh9oO/KtzSjzhtfOLo/+ZRic9/hhlRECJKvWFupPnNqYaqWuAKa?=
 =?us-ascii?Q?1H4seygJ1c5THEcmzdar9oueCq7Srwv/zLXovTlddWe5alIM7yLZGIMItp4f?=
 =?us-ascii?Q?yZ9dZnhKKuVskMG5X/n/MNYFjrWnzyL5fF1GDPUFdhsqvYKO1NvdCDje6uKd?=
 =?us-ascii?Q?ksriZIUpVAze9oSsq1ztgM1eezWTxeQHkyLhqBwZSfkft01bmLo+iUC/mGrD?=
 =?us-ascii?Q?E4HNXwW6JS9KgSuiBsI0SGc6ebMkWhh0LXMZE6quiDSJPVf0wf0VvmlijNIX?=
 =?us-ascii?Q?hahOo/NnIQBDWA+O5K7V+TOfmHC/rtTnGWWEthdMUB/q0gi4YXnPlypNkDot?=
 =?us-ascii?Q?bEHtdZAa0FZ3N8SNEUICYzUSezNYBNfpyOEXk7evFOA+Zy7mPW2FF+8IgquW?=
 =?us-ascii?Q?0p/lwYf/9s7ghVxtWdz/LHnlJQpYn3WQatv6kWCdKGgzOPMKVV8OuJ344ICZ?=
 =?us-ascii?Q?ecC9SfPfrg0TlT6tAImcl4KnnxMICgoDBTlOm81ICnqL0R/V4Yl3jgdKxx5M?=
 =?us-ascii?Q?BFvJq5lfQtkRZQRLKZNeqpHUTE9Zm7KDILlWZqaSYlQxXwNkPPxz1EgkARJC?=
 =?us-ascii?Q?gusCPkx1pS3Tl+bj5vaHXEGfuXylmg262oMtbUZgI1qA97dRdJNi09esJ4cs?=
 =?us-ascii?Q?wBWNlVgBxyfLC/ZM+LVdScReY9bw6/YhKEJ4RKO0D4bru2YThUGa6evVuxEh?=
 =?us-ascii?Q?EydmN0F3p9Wpwbmtbk+Zm6+WSarPu+QTrUUJs40G6H1iHXwdPx4nike8nWE/?=
 =?us-ascii?Q?GABBH5R7t4f0esUQSSVEyvDZNhTcMS7RazOEKBHiIzKZcNoTrxfBbJvAx3DT?=
 =?us-ascii?Q?a04IEsNCIbEXp9DdxkHVA/ZNLWOB8AtZ9vAeswKW83pBLgc8dWN0WftAxnP2?=
 =?us-ascii?Q?OL4pxXSWsrRetRhSSy4VdoZXgTGGrg0O5/h83rL2oRzhuwBw9fKotDojC52g?=
 =?us-ascii?Q?H/QeJ3FtLvmszEpbGfp5c9lij/+GkGsrpS9+dTvf63d2RUo8iHRbSx78Kjpi?=
 =?us-ascii?Q?12OnTKXAyS2+M1ABsA2KoxTHMe0uROxLnRERq9BbHese00KhaNZik9czF8xX?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GPGulhfyrGJiYhne+ZJex+TIpiZ8voAyA/aSxUUAKU2b94dbghI0WsrNf/RXyqCsLmGHitDIMVEMwBTTNCFDU1JZt+ec/qsG5AeArpXOvI465NLgp4ILkMVM5yoP4Dq3YQkY7a7NgmlWdihCIKXfrCOyEd5SDKOkBKOOhDYTDeEcl+ccAbX6CHMEPttqvp7dpq7TN/YDv/4Pktd9PL+xgMmf5LqNYz/Cw02F1O6YADBhMa01zzYsDDnST/LJwmO6OOCF9qS/glAgwD9drrKZalSHV4/WaW4Geuc4XmPGXEZfQXA+U2O//aWwWi37AHfHMDl5wMmlyu7DySTWqjVWzxLUOt9lL/6Qx86lkfziDsOe4d+FkSs0AVTST8N4lm+wr+7CSnBMs03VLq4BsX3Fd2sze5qfz5/Nvpo1SwsoHLCaDYtFiwiEnh6dZH1GPkdGDtkLi6HHvcFWRhVCM5uD+bRu4uuqfBnTe8lckTDUPI9dNiPEB+n8q9XB9Y45HP35XZuu4xPSC1l8GFf1twzLVgmhf22A14Gx1lqPiJbudVDGpA9M6xZFcgLchvRFPfQkwKSFtcVfiIvVHSmktZCQcxqM9KU74aRRWvUD/dhvZuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12eb1a5e-db02-4d3a-f352-08de204277d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 10:18:18.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIP27imcm/fCi3NoufN/Y4qQUEwCplhW9uFQ5A9VNnw56JiLiphBSwhYZ+NdfIgC7MzigLjm7aciFd4h60lK7CVbcZG33SIuzZ2/+TD/e5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4879
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100090
X-Proofpoint-GUID: Z6Eg75hDt9Y1tp8TUTF7bDOR8LUlnShM
X-Proofpoint-ORIG-GUID: Z6Eg75hDt9Y1tp8TUTF7bDOR8LUlnShM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA3OSBTYWx0ZWRfX7Sskzgrc1mHs
 E6l40zCGEUioXjDbNkjdaLj0j3fHPTtYj2iVGrVG3A0E/irrT5YRKKO+ih3LDIdTUiwcXaqxeSA
 8UaDoYB0i5025LdVnf14BSwZin/OOc1zKe+pbjKIQ8vEIv7K7SATgbKiK63erRdXZ4532gnCkEl
 XX+9wSbpEwhFCV4pnXUYN4LEPrzJ0o5aYpd4LDx1GnBaDCWlsiABrAecL4NzXnRE9bZVjX/p2k6
 fjczMWa6eBI0gas63WE6F6vRvHtNQ3nf6AZ+pRji82Lj1+flKPJmo9sSCGb0ax9l4VZP7hgVpke
 nPZ9+BEzKWkCFd2RRl2sIWBgAbuRkcIAYgLvZqntuNWLc0SI4sviK9Y6VtIHyaYD9wAkZ4yGifi
 CXa8rfgmVFkBwm2g45kg2rnUHF4e+g==
X-Authority-Analysis: v=2.4 cv=Fv0IPmrq c=1 sm=1 tr=0 ts=6911bbef b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=F2A9QBwkmGpXvlTU2CwA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: B3BFA1C000D
X-Stat-Signature: gqzfhik7u9pnex7qdd67no6wr9xtn7pi
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762769925-681128
X-HE-Meta: U2FsdGVkX182OeoVWuX44iatJT1m3y9U7ZI5oD+VgVSbqQZgCUyLocmiaRIFLegigDbyFwxCLMURst+PlOpJTZ97bKmZ/NhegaQMX0PQfdKtBjpvNlHONW8pYstM6An1JHZ7u0l0W0c7+dpXZ+f57gUh2njoUVxzP80/JEFKTnWrSRKpxuzDF5D18aeoNSi0eZzCWvpODyIDIuH2y+E4fIk1NCnHbnDjkSDRz56F43UbIbX9UZaSJkh/vhZ9JK+lAYT3ymaCYCNe4yHX2U9V51bKXlrgdOkzk6/5gCuNDnsbzL/i63ArA/jKhRD9+Pz8MpXKlztxRXAv8wsO5/r0rP6SkaSi9gCW8JgYDlgIgaou+2rqF8f764hejAQUpyg0vZ1OVsINMASRt/C2ifWU/hGYyvlmwRZlS6pqKQwQcwlfl/+cw4NBEHF+ZzE5W34tbH2kw3SZbRHZ7PBrubgZ7bffZcVhTbi8/4pRMNJT1m+XryFBPkndyqR9btKB1p5jhtZh3LG1xRAptQ7BxzA87mKxrPuRrxRjlD4sBNLdQK2Pjst/Q+cP0QYr5NKnNzGwftDyKQgCW9F9QPw0xrAnfDRmexd0e+bl2q+jgdr5lPF+sAeIcwSJ4OnWoY3KZSzGypusf9Cw2h33D1Tl1phXGCljQt/vhjVC9jg9xU9MoFNQ9w1b5wIJO+x5Gn1r80eToOQ5ASKfJ3bNBzq4f0aVLEw6uNIDh2I76vv/vOx5ELHmuXC2RIou5v/X7U4KlvN8L0UFqobhJMUiysk0v0EWSbWJiOPpQmh4rYRuAtD1b+3HSDbha3g6jBERGDb7ZI4h7lvqCLz7q/YowGVo7xm+K9NGkaTpmaPeKgS6PvXdDx8OFGIx3T7TVP9cYj0wPTcnovuYVJK47fHFFrwwRdIEd8/mthJEqLDvQeAsVTy3e+qLqv04gFqtvCfYYD0lIqXTtmlVpdxIBEP2Xr6o/YK
 55vn5Ol6
 pBweymEvkyPhcI6qHk89h4dpcZN5+O/dDM2K8t0E74g1eGFboG8rFWOYxdAZHXSflBn0I5eCHrCZF0y2Cu0orqj8fvVU4dPseNx9Jx9+FjGXVOthTpH9z3kdPexYCtLjS5PWghbYSecF4TGeu25YEJPTLry3Fj1Ycv6phKEELXBdTjXkwc74SoDrUz4V7UWWn1h4UVS6bm0W0YrPSp4jDDJW/dBEcuZ6I795bi1DdzjAQ714NvfP4hBjX0X4C75uuW0hY0UHJU4VSHgfDP2Pp2WKry/ddlYFbVYZf5ppbJ7G3jgR7zP4opCYEOTAHRs0IZdVjvX9mPGc5xri3/ekSztrfqcJhO/+6g7mKMytiPl2oNtEHTG49tO8ojWJmyfPnH3idKKYUddBEWUIPU8jGUW9jipJGuXWGw8EISsXJh77f2LaRm6Zm1Fsw9EnUE1us+iRxphBci8mt0uTFs4nPv7DNxNla4Z49AzLVK2KKdUZkGeRXV8sHEywRJq7WyU1+tR77hL2YOyA84n4xN8iOd4KSfS72cRVesMwojIo8vv881PiqNiTi5kUQNtnxLXm8X2RqQfxbL10eq7GN661VDmSSlIL4Ev71i9QwPUr/ZYkiPdFv3D/Iv2oS1nX9/uJ/q6XBD2yRT7T7XHGr2mGdeu6NOFioTy4BVcOBbAk8qGBLAfZ0k8D6XVhOoRIfhPEbQY4ADeGetFW4n2UwR5sAWlUl2z8oM+VbFOWiDaKtwVRjoGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 11:32:09PM -0800, Chris Li wrote:
> Hi Lorenzo,
>
> Sorry I was late to the party. Can you clarify that you intend to
> remove swp_entry_t completely to softleaf_t?
> I think for the traditional usage of the swp_entry_t, which is made up
> of swap device type and swap device offset. Can we please keep the
> swp_entry_t for the traditional swap system usage? The mix type can
> stay in softleaf_t in the pte level.

Ultimately it doesn't really matter - if we do entirely eliminate
swp_entry_t, the type that we are left with for genuine swap entries will
be _identical_ to swp_entry_t. As in bit-by-bit identical.

But I did think perhaps we could maintain this type explicitly for the
_actual_ swap code.

>
> I kind of wish the swap system could still use swp_entry_t. At least I
> don't see any complete reason to massively rename all the swap system
> code if we already know the entry is the limited meaning of swap entry
> (device + offset).

Well the reason would be because we are trying to keep things consistent
and viewing a swap entry as merely being one of the modes of a softleaf.

However I am empathetic to not wanting to create _entirely_ unnecessary
churn here.

I will actively keep you in the loop on follow up series and obviously will
absolutely take your opinion seriously on this.

I think this series overall hugely improves clarity and additionally avoids
a bunch of unnecessary, duplicative logic that previously was required, so
is well worth the slightly-annoying-churn cost here.

But when it comes to the swap code itself I will try to avoid any
unnecessary noise.

One thing we were considering (discussions on previous iteration of series)
was to have a union of different softleaf types - one of which could simply
be swp_entry_t, meaning we get the best of both worlds, or at least
absolutely minimal changes.

>
> Timing is not great either. We have the swap table phase II on review
> now. There is also phase III and phase IV on the backlog pipeline. All
> this renaming can create unnecessary conflicts. I am pleading please
> reduce the renaming in the swap system code for now until we can
> figure out what is the impact to the rest of the swap table series,
> which is the heavy lifting for swap right now. I want to draw a line
> in the sand that, on the PTE entry side, having multiple meanings, we
> can call it softleaft_t whatever. If we know it is the traditional
> swap entry meaning. Keep it swp_entry_t for now until we figure out
> the real impact.

I really do empathise, having dealt with multiple conflicts and races in
series, however I don't think it's really sensible to delay one series
based on unmerged follow ups.

So this series will proceed as it is.

However I'm more than happy to help resolve conflicts - if you want to send
me any of these series off list etc. I can rebase to mm-new myself if
that'd be helpful?

>
> Does this renaming have any behavior change in the produced machine code?

It shouldn't result in any meaningful change no.

>
> Chris
>

Cheers, Lorenzo


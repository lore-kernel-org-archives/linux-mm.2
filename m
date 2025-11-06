Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C74CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E3B8E000F; Thu,  6 Nov 2025 09:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954EF8E0002; Thu,  6 Nov 2025 09:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D048E000F; Thu,  6 Nov 2025 09:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D61A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:41:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3982B129FC9
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:41:12 +0000 (UTC)
X-FDA: 84080444784.11.A572FD4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id B57FD20017
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:41:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MAr/pBC2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ezo/8B9r";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762440069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O552z82k52JKdpsy2B3eS3+2KNOrAkftOpyDB3eQO8o=;
	b=b0ohRl1NNO4MiNGjEA0GFLegppaZHy82LUIJFU9NLdMvZOoVrjCKIpkU4IGQ9kI4BdheaP
	rDXh/RbRDnDxL/Ss921qbl60xbLl0f8/me7VZRwEqG0iXwT+QfGNDSgTNyzCO1uM36FFpx
	LJaWyCC8J7j1kY4q89XzphtVuPkqftY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762440069; a=rsa-sha256;
	cv=pass;
	b=Ycde8QZhfQ6pWlYnAcFRLrwgMLKDmUJzVqFk5NNUxV/kmbaqJjV/o9X0fW6EyHeKIZmUz8
	PKCFR+uegrZTV6xd+CSJ+wSVVOrY3cu9SgvOQg8DWL6DtMC40gQ9Krz8JB/5NRWBhosiNB
	gmV20/UdziC/ZSmH7tZg2BrobjfrSSc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="MAr/pBC2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ezo/8B9r";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CA4VQ000476;
	Thu, 6 Nov 2025 14:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=O552z82k52JKdpsy2B
	3eS3+2KNOrAkftOpyDB3eQO8o=; b=MAr/pBC2Gv0WgDaSf40AkkKuE69Z1Xp8Sn
	j4DkNSmSWM9szJzthTNn6kp39EJM9MjeNLg5EJqO9akrSR9xchSN673BLI21UE+r
	PVriUADf40FVUJ1N61+GPkVC2e1J4w6947K1nx7jg84jtCamQxIRF6NnqvvWIhrs
	rqZXli+C/ugoTFUoCLHbvhkq+9PLhWaF6QLXPS09qfHxAiPl5MFGyudsY3m023rh
	orcn7ZEcszqyUOgbl19oftheJ2qy3QcGFTchdE+l1c8jzMik74RFH9NGT+/naWax
	eez/1Nh6bej9WKb92Qi2LVQd9qOF1BlA8L4cz2nTuGrFr/FXdTsw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8at925q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:41:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6DK3Lw023093;
	Thu, 6 Nov 2025 14:41:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ng1g1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LTioP8KaL/5XP6DPz62ayQZd3PvHZeEcNNxy4cqLByUpejpe5H/qnOY3CpbRYEfqobzb6Po/uaVE5/IHiFgOxApas7AApxlOaEcEEQwsAP4E3a04c2VPOMYertFpDPeFGH3n6DszDQmJNxJiYFV7Aync4Lbbrk88xg4EU0DVEeiJ5omhw+1sYCiyWbF+QEDuvphPbM8qEeyOaHFsY8Y3tmBbrqgAZl2jFnXlG/SDklvCwSUUBfUPD4f+XF29Cas6rp9EACU5smgA2hK9QiDF9XoNkK1FCsJBWjRyBu0Yj9G0+hvxxrucJ3XHLKkIIKB8uKzc4WjqhF/JonGaKv6z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O552z82k52JKdpsy2B3eS3+2KNOrAkftOpyDB3eQO8o=;
 b=CCsghB+ENVZTlSSZjGDOsh2dLqRmpwWfx+9WBRyibus8DTOmn5FtSfPQUtEvtHoKxUqWMEegAMk8jfQSUJoGuSQkOuyo7pTcur7WimWbXmPxPXf5JU7bBTLExs8JC8+Tea+YGoiKLOSBdqewXViQwFeaYk4oDEGGwPPwSsfjfNRA1rkPU4Hi8YKgG6T6CX896mVD0BaYaKGPgQf81XLNQm8Ll9v4QMJrSdj4vWn3oY/iNbq8SpXetUTxZcEna7oIHgE+vMYzdp1wKNYFWZefiGTnDa6QKNFk1YYv3MiWzxvCZqUSsdQGfhOtbTw06619NkZK820Dm8SD4lT2OCjSuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O552z82k52JKdpsy2B3eS3+2KNOrAkftOpyDB3eQO8o=;
 b=ezo/8B9rbcecZjb8vDwmb3ejYMiY83hXIdzkIDk+E7iPeY90nDw5I80Ifh/tkUnp6hSeeBi5W5qOUELgTSwqyP50V7pxYBtrC3gzLgU/TZRJeNUd3zhhYp/Esy8rqC8/9KQCOGvAtBnEDGntSWPa1O53IyCtuGeGKhDU7d9sXYg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6143.namprd10.prod.outlook.com (2603:10b6:930:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 14:40:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 14:40:59 +0000
Date: Thu, 6 Nov 2025 14:40:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <98ae03ab-ec73-4649-8a7a-71839d6e6eb0@lucifer.local>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
X-ClientProxiedBy: LO2P123CA0106.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a08f94b-f3eb-4f98-1522-08de1d428088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6uF/lJdI5AuwVO0cod2ZNAvA1/mPjZ+CJh1F9GMzskiyDRWaPDaQILITaYDC?=
 =?us-ascii?Q?pxU2igFkzfIHnejVmxWrIGLe1lM0f/wSg4IYUz5rFG2lGzGCf6rHMsjyTqIL?=
 =?us-ascii?Q?cJvZspWp5KxlfowZX0tCWAbJ3guQc5yffCC+P46HW1FIuukKnpV3NXs1j+XA?=
 =?us-ascii?Q?0WytkQGQlRZQBE94KWicCoMdHbIjl66SHZz5TKLc3nSlV5sR4UdRQ7LrqE3g?=
 =?us-ascii?Q?IZGd/cb7Bw5hlbXnE2jzYm/urQcUwDrWvcpZ6RA2sCeM4dG1momSsTzPFMbS?=
 =?us-ascii?Q?MHZp58UtmRbK9F0QhfMdG9thr3C32ry1Ws+Z6wtyiiLvhkmho6RG/AsgE589?=
 =?us-ascii?Q?GGIwjQBRcS1ooNHG1i8bTUPqVsG5Dz1pjEPq3dSR4um2SLDJSaBr4J/Hvcnd?=
 =?us-ascii?Q?kehmySfOwTg+7vnEz9kMD8v+u+REccepbt47vO3TMM8TiXz4d3pAfF4XflRi?=
 =?us-ascii?Q?YhTAZp80+s5ny0S6T2fB05948NheD3YiAgfLDID/NsuqGYvf4gQ7wZn3CDv6?=
 =?us-ascii?Q?Jc2on8N2IGynjTqEFfUkuyqCSZO0IDUhXQ4+7u9hTslyz9Na/l6KTd6mGSG4?=
 =?us-ascii?Q?Gp4OBLCFPasExEKymHCBGZC5TYbY02YDVgtAF776kIu5uz8RB/boEomypiqA?=
 =?us-ascii?Q?uErP/IG1PxmDkoePTvvdRt6a801LJOC+I0yNWINdSj7xVBjI41kMkKPB18aK?=
 =?us-ascii?Q?65pv3MzewhWrSywEcEUJe3o6qH5iwMsV7mCxvn85XNHCH6d6CAbUFWJWFKP1?=
 =?us-ascii?Q?a63wuBEzAT0Flmg6nHUq5dFH+2j9TPXWwqw+LviAu/KFtEogjyA0be0PFx4p?=
 =?us-ascii?Q?fS8mlgKaTSf4+UenBPY0JdYRaxStPBpgFMZUnXVpzP6OehRtsznK7XGlm3+R?=
 =?us-ascii?Q?5+1/XhUKvQmuajfTG2nQeSuRnYCmjoDvpeqxHzoHPMkD2SgFqcIn5V7wqr/V?=
 =?us-ascii?Q?ufaoNWv79sWbR2NsNwNjxdOtEB0CbcIpXETXu4tRH4FE41kA1j11pNSS8TUC?=
 =?us-ascii?Q?XfFpYPHemS/XAVvdsnTd5aYH3s0aW4FVZZvMtQFNPiik0FBYrBNLzoP6VfAm?=
 =?us-ascii?Q?tovNOpYRCaFp3VTsSRQo77MuH5cAUG5YxiS4CZCbgFFtH54M9H7Xr6k54DiV?=
 =?us-ascii?Q?6bI9ESdNSF9dCb6Jd3xiTHlOcUYeF4s7PQ5/6kKzqmt9EmRE+/b1qjS/SW9p?=
 =?us-ascii?Q?4lpBHrYyaUHNNPr+ijSv1j6F77sE4uKSKI9krtPAKAXuGLRVev+24ZspCxt6?=
 =?us-ascii?Q?kddeAAxFPwuGZ6ESmwX9KN6YVzUJmSe0U61xCILQpdKX2o0qS+H9c+hNlN6f?=
 =?us-ascii?Q?tE72PkokwyW/FjH/OwRlEFGMHCilXqXXU7c29fRinuijUqQlEtnZTj5vs+tu?=
 =?us-ascii?Q?fVm+Arm8+rhUfdhyUpEfW8bljuowELUEzn4HYaP3iCnjqTh8dGpQZ9glnnw9?=
 =?us-ascii?Q?EF9AsGVgpVxKVb67UaNOjRbtOsCjUSz8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VLbHTlnNn0JjInxk5Gsj+TWcfs8mxESkdZqxaR1yXp93dSTVphi5vbR9y6QR?=
 =?us-ascii?Q?9+O22agQrPTgLy4mrDHy3tT0q+iuxkLQKshBEwRtiGf4IZJ29uDxrRWkHdpY?=
 =?us-ascii?Q?REkaKnJdaNXXVnQ6IfYdaqoMx95hrCaKm/GA8nHvghlCvD2xIZJhS+fn15/+?=
 =?us-ascii?Q?jcsyGmkjc6xJVy0JOvY4o7/bMOsSL0uMQVO/4BnsuqBA2xY3pbQ8djL+Xs53?=
 =?us-ascii?Q?fN0CL7JjyS6m3eaxR9UMeSDN7n/VcTcDgmYhRCoBeaaP3ipA74ZH6WvVBZq9?=
 =?us-ascii?Q?j+pIQy4otX0eB9caqmNLLITfSjutqwnupeulIFYpvzAvdTaT+aqVjIrJNFsD?=
 =?us-ascii?Q?V43UbfzH65dDQtC8uU2/LOUIEhStPl5zY2pc0Oz4Y+wxyKERD7TgUbAIsmet?=
 =?us-ascii?Q?u1vFUJu8pBM1aetM9TiV3LiQO9xsHF8OEt+4XE5ViIwxyz4InlWFrwI5DFz2?=
 =?us-ascii?Q?MV9utg2RzcyQc5ycdczMT64+3B757ANtAZ5sfvs9/ewY2ILs03LgEVqTaCaV?=
 =?us-ascii?Q?zjlCjhQHI2qx6fzeYmCK+p/3J7XT3shAJwUq5EXQl3chBe/ZpfRQW6OfLJk1?=
 =?us-ascii?Q?b3lj7t1oAcWzmx+jwwo+ssUNqcJRmEAfgG1IHQp+86uZTaONV8iTas9dCssn?=
 =?us-ascii?Q?y4Y/i+G8pdumBdimOle0FJPsGjdAfcjKCxZ6Sdi73cV0gD34eVtOpbqlJA9+?=
 =?us-ascii?Q?KkQNUXqN2E9giS5hTxZn7HiTH8+RPFwmg8A6EttxeENPVVpuvASU5dGFMGZb?=
 =?us-ascii?Q?mMTtU+AVwp/X3HNwP4FrPZWqJiSEH+hd/ft7BuojAM7091q9LxzgFWnhYO3H?=
 =?us-ascii?Q?jsBZ2HErWeDS1hXetGCIYjcjuWEZK7D8fCb+AQbIu2E189S6eVpk4A7FBk0m?=
 =?us-ascii?Q?qG5CFw17sB9RSjJ92e8o5+euF3WpJ7mhibWTj86E/aFlmHZIgjh2ZkNAahpP?=
 =?us-ascii?Q?Yt9JNXsPBSeqYv+sQwbF0Yx5psFduP7MtDn0Uc9455X1OSrrWfTS8t9a+xO9?=
 =?us-ascii?Q?fOtEnowHpG3fhhcOdIBKqyQZBwkasL1vpwtjU+e/80xn3QXSRxSuJaLoTIAQ?=
 =?us-ascii?Q?VgzJYTTeAcA9IaJXJSWmleg1hZmPwe5SFykjEnJq9W8ww4dG6RIErdcdkSan?=
 =?us-ascii?Q?REpKnTqE9PmWTmg3H+Ey+gsyjY2VGZ759ndQ6t71OPrCcNATSxeJaYvX3kUC?=
 =?us-ascii?Q?aoxfJHhqONyuwfgURaAXmNjX5/jWraNVU08XPymujeOwASavaVntdurp3VFx?=
 =?us-ascii?Q?F6oMlvopEHwVPAAIH9rvjpCgtiAiEvO9CtTy39PJxs245Q/5iP5F0lb14yea?=
 =?us-ascii?Q?6gEGPYehtXG35PxAqRp83ywkHMBHo5nGKnIQbzPEmL2XsnaprAOwT9StQrGS?=
 =?us-ascii?Q?a/jAOzJ3ZtndF3cugQdyEX8+GA28jaZ6ANwqBzr0upc9XJsev786poxQZLEK?=
 =?us-ascii?Q?E817Uo01Ol6kbmdOVYMgXq8jX+38nkP4HWH/1Jz/4ZTLFl/Lm5lbiJks6UbO?=
 =?us-ascii?Q?q4dPqaEoBY4ndEh7Vgf+S8R/EbANo79s/a0mA6ViU02ZhPiFRX5CWp3YrjIP?=
 =?us-ascii?Q?QRerQ2O8Dn9eWUicfIbOPdc4MBZ68n85RQDqcUBWQAV8i+Xifz/KhfsAcmoG?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XsN3YmzLv6XqDSeJUD2CZEH5/Eib0weP242teNOmQ1EtvazvJRYz0WcDLZncgvYfpJPIHKNWxdnhywmRTg36cpBPMC0MbjpqYH1g8wiDVC2Yj+ft0FbgJIJMzx0S3Y3c8oIc/vishJUVgY1ZGoUNanSTktCSOkXSPBdNLJ3E4Bejxdb3QNY2wDr5QftO2JVGkM/t4cRwYctyUvPqgeD6ibzfnL0KAvSmuudHDG8sXJIbjd3so74dmS5il35TgwAoKLfeYhFjpfQwVnp/sRjhncqrgFkrH4XHJsKJgs2z/ftyPKkafXsWYNDNGDvDXF1IbAza6g6c/M6JJMUhywxwiK3P2D/+Fvin4cZLbntTOcIidJvVnMJnXRz19swGmgjjq0OHoLkrtAx3oH86l8zgASf8o+1yQgXLPAFMDbb+YBmCS0cLgO4+5O0yhk6kQfNdPKznaKYXthhQZMkh/XiPd3tG/wvRtVQGHLHoExLH+OIWD+vvNlrzDIDYjqO3gMqfhA5fkdXyVFWlDgx9KXae4cbaVyaD3B1K+W/6jEGr0uOm/fUIWg2zOjepPfHSflEqWmp1j0t5tx/EIzMdgkij3v5ZHM/1rZq9ZMVelUszcqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a08f94b-f3eb-4f98-1522-08de1d428088
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 14:40:59.5398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93VoWDPAAEFHtrdS7aVGBkwQnLWO/00zibgTQS/4OLhJkTxit7U8edQV5TEwFl2TAg+v+CV7lnU4CUZUSwtnlay0gEWHVXBMkavdNx/Xr4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511060116
X-Authority-Analysis: v=2.4 cv=HPPO14tv c=1 sm=1 tr=0 ts=690cb380 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=BkskC4soglnEnhqh4IIA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12123
X-Proofpoint-GUID: yaMmj1XtyMlW5nmtpSgC7uToeSs4ft1E
X-Proofpoint-ORIG-GUID: yaMmj1XtyMlW5nmtpSgC7uToeSs4ft1E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzNCBTYWx0ZWRfX8BpFmn3n7LZP
 2Lmk7nk5iCzfLAtk0HWzk3HgrS4fKhv8/mV+gO+QzjqiM1Trq38QsSsolQGKYOPaBEzpAWqzgYF
 ppeOn2NgiXvHSVlNDW1ot3Hk0NuSFSH8TDjPV4d+WeSxBHM6sM+KETlXAqvukZvizUIYX3r/53f
 Bpg4w/yWg1hcxdVrsmyqpdx9y5UfCs9Czvzrs2ykpsSFQu5mPF+AZPsyKXViZuYisrCsiR1krXs
 NGllG3i5nkskVefkHJSLhexWA/GRakBJvSi30Wdyhfp7mNtucSvI8V27rO7vldSmn+Z/e/W6P/P
 YFAtzPb0DalGfIPdhdePKCI17uVbf+Sls7rn5SFIthCEOdQsAurdb0whijKKKhsIfyru+BmzCHI
 dnovzKPiMDlxsM1VsHgIzCKc+XtvTUHJnWn+uEB+D9ZscqPv1OU=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B57FD20017
X-Stat-Signature: wr5u9odfors6yaw6ac7f1bautgmme1rg
X-HE-Tag: 1762440068-536028
X-HE-Meta: U2FsdGVkX18I7fpmN7lTN+P7+Vx/a5fwawbMzhRfzs2VkL2bDfOxUnnkLFqsjzI63Npbw/5628w9fqPj1DfUsIk70xKJXNuxfb9P8k/p1RM4I8hAPgjcrUR/U04wpDaVZASULDVmujSsEMIQy9Cv7sVVQE2Rkt4RddsArNi12hW72SKVYkwhhTHg/wPKpIH//EKtn943bTeoSKYm9wvO/CkLUx+4N/Yzm5I92qmOb+h4RYd2unRFfn2DEdYyqeiH8f84Mcnx33V3JOw10n6hAfdmAdmdQtyXeF/2fSeku9sLkPuDbG6Ogq44u0+3dWsPU3EsqGh32cTwQXONFYyPpr08gVk8ygt08LIZVRO5RZfFHjtE7Gc2HCpM/+p5FBY3dz1sHB0Tv0dakr9UGbyG0azAGFPM+aIUd99P9EevGTsLIYgHyS7bWFR8mrWQiylAqO5XH8Wuyop1nbJk3Vh9y6Myb+lYwGp+1mdkd/IQhg1dvtO3KoeTZqg/KWlzzUaH86T/eM9Nt3aHKMvKCzz1zatv+0cMKYrVVQltfgY/qgdzYS+Z/8jm8eVzT1gckavVY0DKMTqNcPX4Rgzw3JrfWx0MTJ7P28Ng6Tqr49vwBQSux8Add1ef/m0vz7r+AaDq5aJuHXBmfj6PASqqUfWGCQV+6pRv49QOy+k/hQ0vuzDk3pDYlG19bOOB2/8G5Y2cpgah6XUQjspI/k2y2mcvg/M+MRUrvBcdHqZQEiJBh6lJV4E45w0JWZHKDV04Oe4TE69WXrYCqB5uY6vFoPvQlfVUPrh/svALmTaVrOUcEgOQ73rKGPlPrWYVUniUDoZOVeWszrOKvGY/lI8PQNd1QLVnj15+40YqIDFfuwAt4C75BS2XMPmBtcX645+5yHMHAXDcIA09QkwErJlR7QCEh71nyz/YOSrICgHn5DB5xBUoolqGfqn3Ax/q2U3Zj8JQENUUcbxHybpfJysHhjP
 SjB1yO0a
 L6AEBiGHLmQyugHyodunTitCC2EX01wf6bMTou7uaMlR0jkpPGFrpZmon+0T5cjSSigyslZq6L56W42RSr3ByVlDyLMCED7qadvmNMtQLl7f2ypdVE0yfFX0Je9NA52Kd9f9UMHU2L0j7MpWnPocSvzFFEpNYCv8CdwriXU8Y8IcaHMPDWKER1VPQ9Z+Sur4NoguudvAoRiihUDOIcUHyPYQ7mwXCWVkknVz4eEwARAJ6vaOp5g+cuRwB+TlN0X6zxkKdu+hC1ncYW+NqL2+T48SM1AMNxASblB/+/5ml5+SBae4HwPJoXn7WHP6AW6wx2hgB9DW4gX3O9dkXtm8eXmaWD8YCq9vQ2YdQQzAbR/GcnQw9qYzNKaoDJEmencDCNIiksQ03jXe6NaHxqBaVktnUWtVraJASKc6364NIlWWYvL9K15hfyg9fkQp98FlVZLRXL2X2zv+7pjTCvF/eAy/suRNqfFtwZQUAgdugb26QVekARyY4w85XJ2eKOxGL6QaZ3fgOm3q5FmCgXkGJ2ASj7qHxw09vK8EIEwEraUdf/Zs+MLma8PCLdkJ1F+ICr2bB/cshcSzgTHxbL3nH12e4DGUWCU0Uo1F5/Iku8CsZWeYJB72FCGlMzQgLcWU6M6xhwDsLE+/yLlTpUqa9tNeofA3E2MacCbsLFa6LfOw19w5z8P1Odnkv6ahdbqQVL/YAjW6oU0UxZ6Gf6NDNl4JovaeJJOz5UrQWnKN1UmQXxl8zs5LgDYsDDgyK5BF61Oa9XlWZa7A+Tsz4c36RvhmB2E3KFK6faoRt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 04:19:17PM +0530, Ankit Khushwaha wrote:
> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> triggers following warning:
>
> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> false [-Wtautological-compare]
>  1035 |                 if (addr + c.dest_alignment < addr) {
>       |                                             ^
>
> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.

Thanks for raising!

>
> Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>

See below, but the fix seems ok despite the existing code being really horrible
+ in need of rework:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  tools/testing/selftests/mm/mremap_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index a95c0663a011..5ae0400176af 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -1032,7 +1032,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
>  	/* Don't destroy existing mappings unless expected to overlap */
>  	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
>  		/* Check for unsigned overflow */
> -		if (addr + c.dest_alignment < addr) {
> +		if ((unsigned long long) addr + c.dest_alignment < (unsigned long long) addr) {

Hmm this is odd though. gcc (and presumably for compatibility clang) treat void
* arithmetic as if void * was of size 1, so on 64-bit systems this should be:

64-bit value + 64-bit value < 64-bit value

Which is a valid check for overflow right?

On 32-bit it seems even more so:

32-bit value + 64-bit value < 64-bit value

So I'm not sure why this warning is happening.

Maybe clang is doing some very clever checks to determine this is false.

In practice I don't see how this could happen given userland pointers are
already restricted on upper bits.

BUT at the same time this is something that the rest of the test code does so it
seems fine to take this.

Also, (to be clear - it's not your fault Ankit):

This (existing code) is horrible, I don't know why we're using unsigned long
long _anyway_ here, the whole function is appalling.

Your fix is in line with the existing code but is still quite horrible (again
_not your fault_ :). So on the basis that it shuts this error up

I guess we can take this patch as the fix is equally as gross as the existing
code, but can we please:

a. do away with the unsigned long long nonsense if possible (presumably to try
   to detect overflow on 32-bit systems, but I do not understand why we are
   bothering it seems totally overengineered and pointless for arbitrary mremap
   tests)

b. For the love of all spiders, cats and other beautiful things on planet earth,
   let's please store a local unsigned long variable for the address and convert
   from void * _once_ :)

>  			ksft_print_msg("Couldn't find a valid region to remap to\n");
>  			ret = -1;
>  			goto clean_up_src;
> --
> 2.51.0
>

Thanks, Lorenzo


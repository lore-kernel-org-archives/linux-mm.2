Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C315ACA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FA58E000A; Wed,  3 Sep 2025 20:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9B08E0005; Wed,  3 Sep 2025 20:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80FB8E000A; Wed,  3 Sep 2025 20:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92DAA8E0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:14:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35473C095B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:14:25 +0000 (UTC)
X-FDA: 83849646090.09.EEBFBAC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id A418240005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:14:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qLcnmkEl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QSVYkEga;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756944861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48GennlgANH2TM6bdONYedOh1b8zXqkcZKC/vXactAk=;
	b=OOB+1qMlNd63sEa2jxpxmF7Za/ddrkDgFyGBKIx4dI6pu5ExNCQWkCm9r1H+ltEJUjbdaF
	f4B/zxS+4Fv6quWBMhES8fBSMCW53guc2QhLn0Ug2mlAfhlTRGFrVn3DGyyYu/pfAOBjGK
	b5vQMUpQJBJVjG+tKYsAXzs8e0iOow4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756944861; a=rsa-sha256;
	cv=pass;
	b=QOcLNg9DYl+WS4JY2CHIgjQdBRVb0+nKjuRF/lVRBXd7xguj6CBD2VIGzpx+9R57sQORCn
	qnECL86+SJruxCrDZfPjfV+4EuuTILhEQB3sMoZQiMU34KNEtFuuyLrOjxmSXH31ZFpzyW
	A0uniyPnMLn3YF1WVHr6FjUDZn6dQbs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qLcnmkEl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QSVYkEga;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583Ndqjp008881;
	Thu, 4 Sep 2025 00:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=48GennlgANH2TM6bdO
	NYedOh1b8zXqkcZKC/vXactAk=; b=qLcnmkElZ3+V9nT8Gi8ShL6BAZeFT6HOcN
	5gAksdMcEAIjQP/qvNdZ5cQwIoCcGSXNKj5q3tMnSCpmQDogDLHtnT7jeNRaz33b
	2uAbi6rFlYA2sNVLHzgWg8FDEOs+c3r+X6m/3HIZAAqupNGBqeED2ZKcCaXucBJ4
	DhGkDnh4xWTbCFCJUiQ2O/Fm4YEzQYf1xieTWwns9itEGsR5mUEE3hlcBviMiHUh
	P64nNwpV/FG0Y/d7CxVwX16Pw4Sv+xsu10D2z3DCHU9U6vmk9hV8uhgjekb90nPX
	MJuQSudtY3/8TO+YBouun7dU1SJmmpWxV71wkAJ55T6EzaO2eXLg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xyhs80xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 00:14:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583LHAWn040116;
	Thu, 4 Sep 2025 00:13:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrh18x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 00:13:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlrZSy+/9qg/5YW8KS3lToufG+bXm7OgDVfRYwA+F3FjrU6Ndb449LSaXjob4IlNDUZ1qOfXb60AfwM4tLMdY+Glvj2PS4i2ZSEwvpo5XxChku2mrtiyVrv4lcwsI/SylC4gV3nUMasfWKnrQDotaWYXAeNij0V3ByXvlaftbuLi9qgpp/GJzBK1NO75CtCY7Fj6Du5SGpNbSqWPvjSbHkwqM4cZy71ZCu5mA34dEAZ6ybm9Jnsa6Ey/EZSLsmm2YMc4wJVC1Qm+E94rA002qJMZttPlGF6qdfoSob452d3vCXhyZQJh/NUxIVLtle6Hcm98H9BCUAFBHCalkMcjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48GennlgANH2TM6bdONYedOh1b8zXqkcZKC/vXactAk=;
 b=lSpy7g+rUafY9qbrZkDOJ8E3ZeMqVsuCZbEzY9x+sRDzI/QnTbeCJC/pAiWJbiv+FyEQQuELvyoIjzU763r5UEUMRWHpAznMbCd6PwwQGCvPW9oAL+e3u96ftkJRTC1PcqIWPZzg1I2Zg5aH9lRDBCxguecSpwPCCazVGXUrLiTWuWDK9CxLCaAE3lL7LTstRqhm4qrqKwOOCllhZu6ZeVV9fG2OZig6JoMjcWojU/OeiqvPZdfzgr3fzexr1iyX2qfZieb6HYB8vK7DvnEGyZdIU3lyGQ53RAP5Jtw17ecXjFl+l7OS2fth8NSmLpz9yXPdi+am91yTwbV3FspD8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48GennlgANH2TM6bdONYedOh1b8zXqkcZKC/vXactAk=;
 b=QSVYkEgaE03ZfIebOpAYe/QeDTzp+OLmX+r8j53+bScIJBlFpwMAUzfVtSiO6PqIZusa3dZwadKdH+o+kPEYsTM6RlrGfSlWRYmm3dLfwR1Ft3TYxV99c7tveFH/Sk3E8o6fqQjCnCVjnbjSw+tZwPOcKVkeVyUPobJHbD6qdc4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB8079.namprd10.prod.outlook.com (2603:10b6:8:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 00:13:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 00:13:56 +0000
Date: Wed, 3 Sep 2025 20:13:45 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 6/6] mm: Change dup_mmap() recovery
Message-ID: <jr57bivqyzarzicmitzuz4unk5g6gytfnh5olmradn7nmei7yt@s35yr2zhknz5>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-7-Liam.Howlett@oracle.com>
 <de385044-e9a2-45a1-b74f-68ba80bba146@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de385044-e9a2-45a1-b74f-68ba80bba146@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0020.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 22dd92f8-36c0-419c-4afd-08ddeb47f028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Om/q8JKf8ZAoqQVXECcjTHOvuJgHaZyO17tQOaxDHTXGmg5UY1tiO8zDTyx5?=
 =?us-ascii?Q?XxxGMErZmEAEL9iB0vuz9ucpwWNVJ5Vs0xo2mvND9J1zthcRx3yBWdLGg1vt?=
 =?us-ascii?Q?0FnMiMKDY17DiQn53p+gMjNA6BTqShJA/+Nlh47fzcvs+lfncE2RAWiMW8Th?=
 =?us-ascii?Q?ys1u05BpXRfgkBawJ47zNEjd0XVj9x54P93aBM6O9NZ9vRe5N36exGb/PObb?=
 =?us-ascii?Q?WNmfIlBo+4y2leWWmVCehvDMx62bstEBHW6b2UG2awClzgy+OykQ9wY2N0vz?=
 =?us-ascii?Q?BkhtZ5nCCVIdeMFRU+0CCeSmqNJfAKMAu431xAdfgXbXfVLS1mFQhsjrc7HU?=
 =?us-ascii?Q?AiHoXGfWv90BEHy+OXjnydr7MMuhtmuEdAKqrxQlGffPFfsbfOq1rvo+vjIM?=
 =?us-ascii?Q?/4frAISIS35VMdc2LC4lxTnJtTXSuSw1I7rvv2ZDF5Y/hhAg9k6Q6GPU4gzO?=
 =?us-ascii?Q?tHv350WDONkU010h9VpIPRYy0WKAGCbGJhg2vsWJ1PlcXcAFo6hZCEqIkdAf?=
 =?us-ascii?Q?RtGgPckAuWVXve/R9+Lf4NagWIphJBOfq9uv6M5z2xCat96gPZ0KeaX4cOEw?=
 =?us-ascii?Q?atcJyK+t1pksFHKb4G5rpnvduAqAV8DwyOAeZsbsntaTSTkk3V9n5/QCzXRR?=
 =?us-ascii?Q?vytiWzLK1fhKYU4Z1mYzw66pJ/4Vfvma/QrwkhdYKtcwIfl5bWT1OaTkV7ZW?=
 =?us-ascii?Q?VhfMFbWY+UM+BTNGcXLKgRv9mfxDF7v5Ej97H4DeJyYxJEOFVkvSIEDdr7gS?=
 =?us-ascii?Q?IPg9m9/xAjOmu94XdYKKN1M7JxuYITbDATNrnpbBOAXWg64cixbRs97is0la?=
 =?us-ascii?Q?OtSkfnmFPRofKhiIGxU5mL0N43cTvPbbguySYvkOwJ/Ti/zkDOZkAucg5cWq?=
 =?us-ascii?Q?lP3PA8wSqM8hvsw+2ZmEoBO2HH3hId0pW+cNjCcFXOCzdnqvNwrCAbieDgtb?=
 =?us-ascii?Q?BMjHDCaap8jDyWPfxFXf+XTty3qEjJVVrtU9asMdJdYQwNNasy9lpUyweRxs?=
 =?us-ascii?Q?65MyiNAykIBsCjo0iIeiNHM/JggnDzChWUcAbpFNGmrEPbcUCOON4+lEqtxz?=
 =?us-ascii?Q?4kS+pQw/6FPQECSLrwf59n9WCoJPfEEVZ1pA2sPZxXsD3jIudKN/GOs35xMw?=
 =?us-ascii?Q?kmIsGW3C3JmQ7176Dmhf+RoHFZhUa8nQsDgcXmla9kfDaxm7SOvX5wzgugnC?=
 =?us-ascii?Q?eWo070PMEoG18Vrim9M7TNmCaGN4itan2TOwq2dvtmd7JSK+TjWhaQ+MbNuf?=
 =?us-ascii?Q?f/Cco8nPkr82UtPnuqzlX9FSCHg3/E3k3YYRPkDw541nPEvPWWLpBRAKoxIK?=
 =?us-ascii?Q?G4fxQvMxtNf4eUYwkYrKkIb//2UbHLt++5KXVPhyOii+HIEaVDehW8o4nxRe?=
 =?us-ascii?Q?0BBA3WGjmHP6VmCZl2S2kX59+uZ9L/0/KxVlAZxojoJ9Dz4lPn4YHuDu5rmG?=
 =?us-ascii?Q?GtX4Ku5TksE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vO/d+AJPOS/7MEf1Fmt2L1lHiPCA4oCvG6DPtwKufTdIe6NlHFv4e/C45SZM?=
 =?us-ascii?Q?4l1qTMAed+VtJq9sQ+KDe5BXnoRe7k/WUL6aHD6SDpP2zkyec8W//wdtpGjw?=
 =?us-ascii?Q?XDxDtoCJFrBy4FdtbGIS9W8epO3FG2pHnIZ7IUqMwGgd0LNOyKlA8E2yDI6o?=
 =?us-ascii?Q?PrTtm33mp0rpOY3h4JLr4uzqxu6CdqU2EVP5HoZgHgGIOnu02U8IFSSwlGLz?=
 =?us-ascii?Q?IQJbjQdgBr8W40eZ+Br1roz37ZnsXwk2dyzykj8GOQaVUnV8AgEoKnTZqDzo?=
 =?us-ascii?Q?+kjyKGUHTLUl6CzRoO7N6Spmi+Zd8jXd5XsFaDTsCaSXo4F9zp8NvdwqlVfD?=
 =?us-ascii?Q?kosFxeo2dYb1sRLh1d4o4NLjQXy+s52MX0rFkBjdGV9HSEDWQs8MfLG4NE0S?=
 =?us-ascii?Q?al/iWfu9PNrk931Of0xSrZzpYEMu3zgmEdF+B8FUoLrEIZXVjkZIPICNtnFl?=
 =?us-ascii?Q?mntdX8W4r7/M8F2y3l8HOP2gOp8unTI+at2uMtFlyz1M8e5+z7Uu1KsxTz3O?=
 =?us-ascii?Q?xBpUyK45X7mdkaPYE2LMhtv5J/lSa7T/9GfR4qUGMP4LJat9jOYsZ7s57lWH?=
 =?us-ascii?Q?UIVaCHUnZDqN0CB1FKMKuLzBasTwXJdT0/Rnc7tILZ/MvspEqZE1oDL06UsB?=
 =?us-ascii?Q?XZPH5SbYgu3A33kMUpyHlm3hMqXbxN8TO9KUAnohqSIA6NvW5lupwis6xrDu?=
 =?us-ascii?Q?0UoOBCiCzAPyRJDRwn9HzEJZQ6qYsAt8IxxfrqUiwef7lUR4Ye0KAgrTF/Iq?=
 =?us-ascii?Q?VvqPnzGQWbQew1vnn7O064xy5KULe3zqDDywJMcR5/u0qPBPdRIPtz+UWHnH?=
 =?us-ascii?Q?s+hQA+pZIKdIpGbglu32JZY6EKQlD/W5jHf5gTkTP8RH/zyjtyokJYkxqC8f?=
 =?us-ascii?Q?16XOiWnPqEMPHzD38o8aS1NBYCxTE0ukwkPbHQodb7Qo7+hDeZ8erex8q15S?=
 =?us-ascii?Q?9Dvj/r4CzljaPafqgkdXdwqLW4jZXgFPowQgwdiQwQKCW75Yzm+pJovKOGUZ?=
 =?us-ascii?Q?YyzQcxA46gDpAguZ8QoM5HBNjLwCWLztT7lIPUHeBcjCIlBBG/8NZyTq6cS9?=
 =?us-ascii?Q?6IkZhi8rQBsWjjSnL/+2uC9PIjT+/6qt0l1vpRB2XUn1v3U31ix5GSUISkhz?=
 =?us-ascii?Q?2Ng0gTWCR3UWEQdxkYeoyds9qEF1WcWo+WfLySL0BfMRVrh+SpcIFDAq0CUe?=
 =?us-ascii?Q?mSf17WI4QeILetMLDeeO7ZTadQI6u2MKoTxY/VeMbLDZ4XnVe5uh1m17c3IX?=
 =?us-ascii?Q?iMxL8XnnEK+39VLWLOmCTN2ajfSRN3+DSAvJR/VgI5wl3I7hVrPoMhkzfOST?=
 =?us-ascii?Q?gGVb6LwWq1kQephv7mKLBDlO1H9BwO8iNQPoZrUqYnC8J1MC/K9FP6oWjvyE?=
 =?us-ascii?Q?IFeZmy3K+R4xHPPdl6xyzsLEzYj3H0XfYXkP9dWj7W20kPoKI144PwXkuCBx?=
 =?us-ascii?Q?e0OB5vFj+uq6XzZ6SfSe6cXxj8iE4ngVn3IqP59PefNni+FA4myBd8lIVYN8?=
 =?us-ascii?Q?5+/zbBECvCV5tEMUP+c2jZ20Il7QayyV4G8Y9lu1Ey9zDKxNWZ7pWA9YfsIJ?=
 =?us-ascii?Q?+ewyiCzDHNvqB/WE9w9pcScyZF0XVhY/vVEnkJUP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	afIvYQc9SFbfaZEcWchGyYTTPYAdyD+osgcKQazTfKhkC6RgOAWqE2Y/g4uGTw886dBwY+rwdulmUQTAFuDg/0rwujGuYcGh/h2nAub1gjxkFaecrdLA22EMiDbVYgd8+Hv8PxV5qdD5Sa3ofiRv0fLbSq7+10EOam/vwTcU7TkXGxlIQ9/XxD+pfFIUPiJh7pcZv3qP4EY31JbFpGNLjYLi8gx96khLFh27C3eD/0zXfpmooou+ih1ziFCXU4MyXHzlLeIDDinaJ+MFlcscfs3sMGSc61lZ8GpSWXR0ifVIjSPBGY/p+6OjPilEPjWqrqavubdi9dfCmrp39KWQ+Vb4ch03DwVPYrTTtBfES/GLEcjeSW0DKfXXAwNpGWoZPbfWgHGb5olDd+zat5MctZ1UfxUcbffrQYziUHd6p96eQRzG0Ar/2S44455Tg+mBJgyfmxCREmq4IlY/XoYewc0EAEUDU2UbadAhFFzvtEC7eMYhi148B9L873xnk8PR8CejPLPhUMgh2yBU+7CcBgFF+wILSFtDnfvy8iCL7Vuavh06ZxCtXJ1XY8KrLRLME9WBNkp+fPKvps/N1jTKaGkMSJ6Z9XQu/hF7n7wQx54=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22dd92f8-36c0-419c-4afd-08ddeb47f028
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 00:13:56.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOAZCYKta/dL8zr8ZrP4w9tYZ4pkUim1vyu+goFYXugmf8Zw3K6DIGr8mSVhfSkQ5yG0PY7mxO/E9M4Z/fi4CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_11,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040000
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDIzOCBTYWx0ZWRfX0exdzel9xGy2
 9/VJvod88wdZiCF2V6TGE3/FuBMYfqnkhnxABl36LcGZNsASWUWK6s0iH22UpIZcF+C2jD5v07E
 qxur5mmlTqPVhfGtE1yKJqb1nR3K/RITHLx/Az3C7r2PUcGkSLJCMLvw+UOyXhlVmSYDaiQQlWn
 KVJb6VNvQS642cjpqQgLBm3aoJJHAX4cLqOThE6HYMuQm5YR4V1jKQyhliphDUKRge3TVCLh3gH
 vhFHDBgE4A0qE4OWivl3uNKHi7YS4tC7qY6aJXV8Es89ULly1aLbPhhIx5Xvyf12tRm33zfzRtE
 9kyZ96EFlvintOmu5TGxtitsW5pp6vf8R+1REDeIGu38kQGoJeP2vzhRURl6Vd2z8pj41IQIHl1
 EWcYgu4bRPzD3vb2jC2GJca5KDPqJw==
X-Proofpoint-ORIG-GUID: 1YUQHn8Gvljja783l6R7HapcxSX0S2ZJ
X-Authority-Analysis: v=2.4 cv=UeVRSLSN c=1 sm=1 tr=0 ts=68b8d9cb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=qdUBQZRZxbIx8WG-YPcA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-GUID: 1YUQHn8Gvljja783l6R7HapcxSX0S2ZJ
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A418240005
X-Stat-Signature: r1guacwwm5yzprtm31rafax5shigxsyu
X-HE-Tag: 1756944861-730140
X-HE-Meta: U2FsdGVkX1+TJP+MmZAsTq8/0LNy306jJ+YmIaBrkC9p/MCElqfK2JCeUSzL3V+oRVd+hszk8sQyApZlbIzxVk2xWWCFehtlyhrep9KONBspDPrScaLpg6JGI8ANckGOdII10jUaB2MDvv4/SUYBMa6bcBH43NVHkrKyqITaOhnSJlnwZgppjS9gxb4ZdQ16svyP5Y9WwdgowoBKk0+KRy2I69zbKL+d/5/IFGMVCMixVDC2z4foXoitEW4AdG2Q1imGjSbChHcVgSGeDRqZOyifLhTqfiRsy8XRemkXULw58pYXnqlvPa4NQd39GMGo97j3kRrj2fS2da4CYt1aYlLD26oZLSXDK48xLs/NcVpiuBcsuWKdEZEAPtML4i6Ex1+7xPm3q8/YxCQD39/H5aPhd56IJqx9f9mMHR3EtgmGKgPfZE1r9FjWWO+79TEY8rVS+Sbk/01KYeHs20XqBa40stbHm4GOpQxYc7Uwzc+oQYIABTAeduybN65DqiAu0WT3zrvKp7BtE2JVwuHREEMN6HppikLRknlqhL3b/njRco7+xP/ubwdKRQhObE822MP5yCKmrJuLqJBjgi3KqPvN229hNkNcQLiq57j3eS9InD88fsQdHmzwr1F1vOlfx24FGEPyq/yT+C4uTbDbbGgZQyrtT9UjJa5/itS5bMhI9B1R7KZVratiNsX9fTHETN6IocdVih10+KpR+65Y6Pl7nhaub4vNssxxBT5o/XvjG0uKwXORh0dnk9c6kzE6PeP4Ng4iusi9oFFhilSlWHNy/Y1280OZocfHgjz3MvmRwrtt1fmTkibkV0kYbv0rIfwRbZJJDRSuY63+bdLRQjq0U+Pu/fYm0GckGo/BgGQCDq3sJbHjsk6EYxr6Z12+40yRZfivFCtvhPnMkAMj4c2fFWPEnxAlDZJnnw/hjCvHhyjMa2FD11P+5q2E4ARQWjczgM1izWw68jSckhW
 nduxJt7F
 5ARGMxaSb7PFBtt2V67oY3abZhQHZ2F7QE+rMT9gsZ5e6dU+zCJGKwH7On/f5aL0IbnCIkG2Z1tF3MGYMK0QrLoh785RSM2Rp0ChpshFAM+v1FkHTH1wMpq4x4Q8Ci3j7nxKWWcDFh3WD0pgXGNT0Jhs7SbXjV0Qp2fmqc+1vZFpQB275D3+3FFgkxoPi+ouM/iNNeDQrlfc8ub5O69txfkw+Z7348tM5KPADh81M7A3bLoGKjxS+2UtsjCGinPNzuuK3uvP/la5+827jieYYnfzZp3eD3S8tZc5pvHsPGNAJWUiJErwvNhw6VI4OUAfZRbcqeWAVjlGImRWuvRJUfO/rysnH7A9VLIWbT753zqQgRYw6T0UJIeTEjPfOgKygfuiUrW6Qv+QynFSQw/RcVwlbAgiShRgW+S+mD5UmZLmR02lI/C4EdCEqllnbmADUk20ngD0yNgRai+YAdB5Wg7cAGPmC4mN6kLz3O5ewY77F3mdYIhJtj8pbHb2blWEIKMKztqNLt6MNbXpjOuy4TKSwbIpnLw4WJAjCzA+zuGgsCXvHa9z0aGfQ64HordJtHkkjGybqYiYN8DqsB/TpkYmia8hBWkxPWefzld3jqfViSeHivfr0Y5gQ4AxFVyZrXh3acRoprs4msV8lDtZdVBDkq/0RBm615Hq2doVMUitVLv/ORVoqNkqtHctv9ijJCRT/gEZ54mE5zCTzxQX+X1a2LWCKuZ5ivgbrfzCxlpR5Tywx38prmVi7mMV5B4XuUhpZXDbioeKgsSNCL1JJJ5VvvOdBcoo7GFEM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 16:34]:
> On Fri, Aug 15, 2025 at 03:10:31PM -0400, Liam R. Howlett wrote:
> > When the dup_mmap() fails during the vma duplication or setup, don't
> > write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> > free the new resources, leaving an empty vma tree.
> 
> Yesss like it!
> 
> >
> > Using XA_ZERO introduced races where the vma could be found between
> > dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> > race can occur because the mm can be reached through the other trees
> > via successfully copied vmas and other methods such as the swapoff code.
> 
> Yeah god.
> 
> >
> > XA_ZERO was marking the location to stop vma removal and pagetable
> > freeing.  The newly created arguments to the unmap_vmas() and
> > free_pgtables() serve this function.
> 
> Nice.
> 
> >
> > Replacing the XA_ZERO entry use with the new argument list also means
> > the checks for xa_is_zero() are no longer necessary so these are also
> > removed.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> 
> Ah finally the 'action' patch :)
> 
> Obviously my review is on the basis that you fixup the rebase etc.
> 
> This broadly looks right but some various nits etc. below and will have
> another look through on new revision - this whole area is pretty crazy!
> 
> > ---
> >  mm/memory.c |  6 +-----
> >  mm/mmap.c   | 39 ++++++++++++++++++++++++++++-----------
> >  2 files changed, 29 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 3346514562bba..8cd58f171bae4 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -387,8 +387,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		 * be 0.  This will underflow and is okay.
> >  		 */
> >  		next = mas_find(mas, tree_max - 1);
> > -		if (unlikely(xa_is_zero(next)))
> > -			next = NULL;
> >
> >  		/*
> >  		 * Hide vma from rmap and truncate_pagecache before freeing
> > @@ -407,8 +405,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
> >  			vma = next;
> >  			next = mas_find(mas, tree_max - 1);
> > -			if (unlikely(xa_is_zero(next)))
> > -				next = NULL;
> >  			if (mm_wr_locked)
> >  				vma_start_write(vma);
> >  			unlink_anon_vmas(vma);
> > @@ -1978,7 +1974,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> >  				 mm_wr_locked);
> >  		hugetlb_zap_end(vma, &details);
> >  		vma = mas_find(mas, tree_end - 1);
> > -	} while (vma && likely(!xa_is_zero(vma)));
> > +	} while (vma);
> >  	mmu_notifier_invalidate_range_end(&range);
> >  }
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index eba2bc81bc749..5acc0b5f8c14a 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
> >  	arch_exit_mmap(mm);
> >
> >  	vma = vma_next(&vmi);
> > -	if (!vma || unlikely(xa_is_zero(vma))) {
> > +	if (!vma) {
> >  		/* Can happen if dup_mmap() received an OOM */
> >  		mmap_read_unlock(mm);
> >  		mmap_write_lock(mm);
> > @@ -1858,20 +1858,37 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
> >  		ksm_fork(mm, oldmm);
> >  		khugepaged_fork(mm, oldmm);
> >  	} else {
> > +		unsigned long max;
> >
> >  		/*
> > -		 * The entire maple tree has already been duplicated. If the
> > -		 * mmap duplication fails, mark the failure point with
> > -		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> > -		 * stop releasing VMAs that have not been duplicated after this
> > -		 * point.
> > +		 * The entire maple tree has already been duplicated, but
> > +		 * replacing the vmas failed at mpnt (which could be NULL if
> > +		 * all were allocated but the last vma was not fully set up. Use
> 
> Missing ')'.

Thanks.

> 
> > +		 * the start address of the failure point to clean up the half
> > +		 * initialized tree.
> 
> NIT: Is 'half' correct? Maybe 'partially'?

Thanks.

> 
> >  		 */
> > -		if (mpnt) {
> > -			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> > -			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> > -			/* Avoid OOM iterating a broken tree */
> > -			set_bit(MMF_OOM_SKIP, &mm->flags);
> > +		if (!mm->map_count) {
> > +			/* zero vmas were written to the new tree. */
> > +			max = 0;
> 
> OK I guess this then will result in the intentional underflow thing, maybe
> worth mentioning?

No, nothing will happen as the if (max) will evaluate as false.

> 
> > +		} else if (mpnt) {
> > +			/* mid-tree failure */
> 
> Partial?

Right, thanks.

> 
> > +			max = mpnt->vm_start;
> > +		} else {
> > +			/* All vmas were written to the new tree */
> > +			max = ULONG_MAX;
> >  		}
> > +
> > +		/* Hide mm from oom killer because the memory is being freed */
> > +		set_bit(MMF_OOM_SKIP, &mm->flags);
> 
> Obv. update to mm_flags_set(MMF_OOM_SKIP, mm);

Right, happened on rebase.

> 
> > +		if (max) {
> > +			vma_iter_set(&vmi, 0);
> > +			tmp = vma_next(&vmi);
> > +			flush_cache_mm(mm);
> > +			unmap_region(&vmi.mas, tmp, 0, max, max, NULL, NULL);
> 
> (An aside for the unmap_region() impl, maybe let's name the pg_max as
> tree_max to make it consistent across both?)
> 
> Hm we could still use the mmap struct here if we put in vma.h. Just have to
> set vmi, obv prev, next NULL.
> 
> So:
> 
> 	struct mmap_state map {
> 		.vmi = &vmi,
> 	}
> 
> 	unmap_region(&map, tmp, 0, max, max);
> 
> Possibly overkill and hopefully stack ok but makes other callers less
> horrid.
> 
> Maybe also good to add a comment spelling out what each of these params do.

So I've tried to do this cleanly but it hasn't worked out.  I think I'll
add another struct to clean this up in another patch on this series.

Thanks,
Liam


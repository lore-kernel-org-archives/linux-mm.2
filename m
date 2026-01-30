Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E771E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370366B0088; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DF46B0089; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB4F6B008A; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08B6E6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9111CC28C4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:27 +0000 (UTC)
X-FDA: 84389848494.18.23596CC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2C1B20022
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G8LDvpQW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SWmwwfOe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
	b=ITIBUPz+wuVafmgn+fn8Mel0jFXhHFC6Qrah9dcm/xkcDSeLdFF47WLXp9qzZKyuAcI4H2
	A42MBfhCEVKFQbvggok9jhOmHgj+yyNjB/oq3VAFBg1mVAyv0UPK9jHSfkkqdOwxgDKRc/
	FOG62eYtttbSp+CGJ6CiM6ST6a/Esvs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806824; a=rsa-sha256;
	cv=pass;
	b=AFbUwvUV0pRwAihoIfu9hl8/JRja6CZG7IZx5RjwTXmUDPB3UQIWXDdAlm4I0BdHw9+Ylt
	/XFLOrFUSN6mSbOKQPRN3qTvPqAXm7xp+SfkGEP71ZKNjuoe2X78SMP2pzvcmEcpaofG/9
	beEK2VLj4ErY5R+ZXdpJAndQCbL15V4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G8LDvpQW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SWmwwfOe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKE3Ve4029215;
	Fri, 30 Jan 2026 21:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=; b=
	G8LDvpQWVkytiyUcPHTJhgMISlBx2tO4lefnWa+L1T1ZpjcJJ2XMHVF0p/gmtzoy
	V2BjYmKZbsIR3vJFYgSSSDQrBxxvLSRHupiqKRBAim87+RlJUTjW5+cyv/sITxqT
	ptIY7WGVNnvr8wdeSW5fXLGsO8lJj6PP+yoWfnW98YVC+T/qHWSyiLuXcD+ctcv3
	jexxODRyW+5KiQzkylpcoCNBb66Eil/rTkDdZPI4GSw2VQj08bXgycc1G/S6+B97
	+/f0vq2jDuz5b3cfTmpN4+s95CMOkJINPAMq8mzj4CGpxmNJVCDTsCQMYrIpK3OR
	Z5X+fZiWNhpzWWsdTs29oQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJ6DU5012456;
	Fri, 30 Jan 2026 21:00:06 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5fr8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U4QdItGjB81ei9/K2cgbXtb+d4UaR45P/aI0rGN7AHoaZ3t7ZLNDT1zNJABdvK9hO5hvYpyZccZ3ESRaGbmngbXUSYFoKK7wrkQv91Oq8iBIYNevNHMkIBB9sSNyA8cq1QXaRLvlH3qgAB1Y/fY+iw3IzrxiwtVL9TLiWJTUcYt6eH1E0YvBD6y2N6pF+/RMCsFOsgLze3isic9esKxuvNYOXNf8seLa6RFlZYtx/+3yWSNdJps/nt3lsMbqpqXh2P6WD3raEO2Y+aZ8Gp3XoyQbqJIdaV46y8tTom6iz5xoaiCyCozRzcS9zZ6nyAsDjoY5H3oRHwuym9bdmEzpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
 b=ilQD4/unNHKabBt4r6SQUj0M9ONQdiuffDS39v2WuOnP4un991UAUEOaLOwC9HTR2nAEQCcRG22uNLDPzUs8teBDKN3VauAk4regTRzyG8yo49Oyn6GVlaDHws7NBmA6D3Oa6df+c7PiY57C4nW8LGITLbVflJdWYZ2SDnIz4ysJLQENq/z9fb5PU7CoQAfHvC3onpQvyWTA7ku24/HZvsTU5JBWMjVO3tvDYjuOP3wEy0mhDsEsxiyVUjGynonBoU42MQN2TkAlYvxIjWIDqeCfMN2uYhLK6zYBCH5zAokgIOFDNG4ThJM1l8ikYDgiRV697dxQBmXmq3bxzAt/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBVpczB/At/Hp0AJLlZrh/IdMx/NryCDZYyORdy8gXY=;
 b=SWmwwfOeoUBnAUltvVaeYJhQ0knNyBgB/u8gJJQ0SkEkV6L+9zDRt+juc0NfrtJeIs/9uH3lO0I5/EbY6zFZvR9TSr6JxMsoHD8wuJ3CBgs/RxQTa02mYC/P+zac3iK5wWuKssDH3rA+Ebqirf8N0ihc0mpx80dkqQB5S/XjSC0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:04 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 04/30] maple_tree: Remove unnecessary assignment of orig_l index
Date: Fri, 30 Jan 2026 15:59:09 -0500
Message-ID: <20260130205935.2559335-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::33) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ee6ef8-c3f4-44d3-6723-08de60428a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0y+UkmOrnsh7yPXrEq6F258O1KhPhGLfUoG6GGk7tQtiPNqTlEZ4ICu59gqV?=
 =?us-ascii?Q?GfF+T1pxFoYobNeglHh83j/NwG+vz288wwysf+RzEgofafkrnHQFLhzP2VHw?=
 =?us-ascii?Q?b2LYDpCdLxRphF/9U4PU4Sz1gglLMP9GHLMABfp0hZBDAO6u+Psez84REyUF?=
 =?us-ascii?Q?czERuR0LuAqxgN580Q7AJHQdXr8DxWc9RUv6n6A/7Us0lJnz1bpVR5oJ3Ukk?=
 =?us-ascii?Q?vJOJE39z4ez49rbg8q+e+o+I0Oopn/su5iYV1QTp5zr2lZ4FViYEOhS2NjBq?=
 =?us-ascii?Q?EP7tlRcgvPZW9umg0mMKR65c/K4Bmk1Zdn5TPYejqyxsghY1oSgCzx5Xu7rP?=
 =?us-ascii?Q?nFKTNYOl2JLf19BmLlbL8jHdZQPLr0RYhxD0mSnxK3r1yATHKxX8jYlq+ukZ?=
 =?us-ascii?Q?awMSrWvPUz4YdlBnRRhYlJuOyTupbyUHPOFE5s7EaQO4Sz08xpO+sCJEvlot?=
 =?us-ascii?Q?XNAUbK4Cvo2R33eHWtbGfnnQPiAqXoF2xocglGyWuXlhTsXJGLpCK2jxM/S3?=
 =?us-ascii?Q?fMFb4sJ9U7+/PN85l/Oi3+6nv/e7OTI2PXhkkNX1e50AokYwWoWIzOzkv0yY?=
 =?us-ascii?Q?yrKJwkpmzQAtVcK+oaSpOlKIMSBxz4a6t3Nj9+6DARy6N88umamPjje40xKX?=
 =?us-ascii?Q?BUufzL6mht5wYkdYpTWASeyq68+8jwRZCQXZSXAGFLzrY8K6I9XCCBRWaB/b?=
 =?us-ascii?Q?pTSEKXyT0Ih4o8h/9QRVLZeqPD5pXHLVb0k2Q5+wYXeW5Em9NitUdUXW7KOw?=
 =?us-ascii?Q?h2/dEf24Qa5KXm8LR0PjdBguDZOveQP8+WzbH3W0+Nuj7mcvT4527ZWcD/gB?=
 =?us-ascii?Q?ebrsIQADUppgWer4YkkNNqMJjMPfywhHy6PXN+ZFDun1ads/o6D6ejG7J4aR?=
 =?us-ascii?Q?YaDr/KI/aUTgCMW9ThIxV3OEjz5KRdFh9fqgW+XOBmCbijRS+GFIeC3XXxYy?=
 =?us-ascii?Q?Mg7zAwyUiyabhG69Bd5F+BidZXislXV/bZWhqlL7ouzLoIyj4aIrtfzu5bCj?=
 =?us-ascii?Q?cyGJnNz38SsoJp9WIIr7bu4IIuHA0JKrmZcjFkcVc+fHXM5T7L03mGV2LR4Y?=
 =?us-ascii?Q?nFRtLbtzsQANzbi+5I0fvzggooI1taGVaa6/+7yLnxcPa4bSkPmlC0YmPBY+?=
 =?us-ascii?Q?z1xeVcuKxcJefKyapZxlq4gTyuQZf0BK09vuRpMxnJOYNAQeFFmwDGud/tth?=
 =?us-ascii?Q?89xIcMsfsKdNVE3Ag/tu6NtQ6flmHmJ1yXms10iSyHx5raozrq9aIKZ7RyLs?=
 =?us-ascii?Q?A2nylO5h2vzXeM+WCt/VbruT63FxnGFTuq3xmpGnUm+XeUgKhxboYaW6unDC?=
 =?us-ascii?Q?NbUQWs/6uhh4kGUTCp+nsZc1kMHOOirY6BC3rMNxzdPYNydQ5Z8QZSO93V7h?=
 =?us-ascii?Q?8OOG3K1weROiLdJsh27MkOxjKMlGGRmlBzpJvhQzW70AFsvU5MMevdabZkqH?=
 =?us-ascii?Q?uao3UzAN4vDFZj4cjGiwySFqGmGZvHj9nrnZPIhUAHuXGSxc/ZnnUSIk2nrX?=
 =?us-ascii?Q?vnTnIE6c1HW9G2dMM9Klmy1BpOfflbJQ6V0fx7wD9uACtl0z2CpxIfKqqauk?=
 =?us-ascii?Q?w043Can1G8VDJn8tDog=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PfQUpz0sV1OwqSIJd8Co9YABnKXfZmpX+z1kt+87fOz0rE4Ev6BadLIppMFc?=
 =?us-ascii?Q?Fu++/7FYEwo4GuF6uB0nWd06F12aAmNPYlJPYd7eKGX7RSKOFPaUgzJqTLU9?=
 =?us-ascii?Q?pQy0pHbHY4c+QMeu1sP2SKmovKwME2xx0/K5EMjRj/l1tL0zLp651UJBi/0m?=
 =?us-ascii?Q?KosyNHpx1atQJnYwXsOhtE/F0CtebraS8uwxDW0O563UpjqF+ZLR5hW6F56T?=
 =?us-ascii?Q?zmOQMdU1N19YFs1DG6JzWq3Hl3ZACoHK/1PzV5s4YfItEF0W97RdfkGW1fhP?=
 =?us-ascii?Q?OfKnBarnmp+tHMT9x+OCQXJiR4k773R1hK8BsIVvmvVXX4QZGmIyoAvUBlql?=
 =?us-ascii?Q?DkK6RofLZ4Co/UOhJytx7jfs8qLtOPsqsgBs9jQl88nO5dKO6kvopHvx7IQz?=
 =?us-ascii?Q?y9/9ErY1vpZ09itrmd3bXnOKODbs/MKc1CwnbkkIC5KYpmtBuF3+QSQ562HD?=
 =?us-ascii?Q?/5wPUcUpOS38OHisJZsFW5G7s9XsDytTvJmvy6l8pKP0cODsaQDY3IfhiBYm?=
 =?us-ascii?Q?/bXOTc/gnD+avC1UpfmkVs4YOYqvn3/1KPpI/0SgtdzoKaEI/A4+nbKbVX9n?=
 =?us-ascii?Q?u3DZcwY87lFyzfan+ns3UO5avlBYFbjYvZHYr6oNrV6KIRxmbL5cVwB7354N?=
 =?us-ascii?Q?fJqDuEQOydmS4TAtsH0ajN5aY9u74oWVOvnIf9hsFavJ/AMrnXzQCO/XlkLR?=
 =?us-ascii?Q?mqTJJe7xUpp/Nf0l7l0rwRHztXmzbtc9ULUaPK+XMb6wPMO8TJaPavbI+DHj?=
 =?us-ascii?Q?VhhUE10yWj+WnDqnEjw5KxpJmOmgaxQiSqEsXqTBESVAW/t/aftdg3pC/yNJ?=
 =?us-ascii?Q?sqmg3+T4q6JfnzrrJ1ddohGxp+wcYZTyYyb1jsm4HJ+2QU9pR2obv9BAezTA?=
 =?us-ascii?Q?8GKwPPPymZHbm9lfsQDsk6sBaN/5kahMKeexI7dQ/ACtsmFcl/6JEPej0lmC?=
 =?us-ascii?Q?D1PesbIS0E2iq7q9AHMLrQYUKgXKGIVLUxi/eTzasN5g7AoUV9oxijLpU7Mk?=
 =?us-ascii?Q?KEwQo/WSjcDcmi9uYZXZlCYUNtT+SYBVCVudv3QDvNEzqQnzlS6FhqUBKh+r?=
 =?us-ascii?Q?UhmMx0iISmht/0Iljw6EDqSYAz+snIW7/NveqKbPRb4y1ly1n8bUg9Zrn0Q1?=
 =?us-ascii?Q?jLoTnHg+ui4cm/EMTZKDcItZAxrVYq6Mcubg5fla4Aa3TqW0z6dGRqpLa3Kr?=
 =?us-ascii?Q?WcwUD2MZNpEyY0dLPwVmBYApM9I2v2pvPjAQx6p60H0kXH5lsz4B2rxHgEuG?=
 =?us-ascii?Q?r3FJZHPhra6GQ/S47gx/BQv+KbbFp6KzYrxUJTYDW+m7GpwomWwwt9qf6tGc?=
 =?us-ascii?Q?O6Rl0MHrKuqV3Co4JZjEyMyaMod4UEX1v/CtPKB3hmAXeVltLQAeoRdvm5UR?=
 =?us-ascii?Q?0mvjXyNQmjtoaLxw3oqNr2GQEYkN7dn2xmufMjKl4oNnKMzA8SZv17LDT7wq?=
 =?us-ascii?Q?xCvFkVhgxeEYN7+5v+PQYIGrtjzG/EZuUfQ1A0ZnLLWpK6l8zAGpoR6PknSx?=
 =?us-ascii?Q?xA9dWgP1GHudYbeyRl6ySmH2JFu1my0kaactKU3teAI79YBWPUmcyA8HOXJ2?=
 =?us-ascii?Q?E2aD0oN6ISElZfbGiF9uPzzE3GLY55Qs9BjToGVksNc7GCHP6VLu7s3fxJPA?=
 =?us-ascii?Q?JqiuzU0qEjD0HrxDyCsc3BOml9fA+dTp19gAAYK3CSX62o0MyF2iId+o9X/a?=
 =?us-ascii?Q?YLbTOD2A5/FfeKHHJRfekKeNPWMY88QWK4DyDoUTyXtbLptWCI8WzLKMpeHX?=
 =?us-ascii?Q?fLCfqBou4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xt1g5wpi/lsO/VGHIEjzWYDliAkVfu+zshSh8uFYPW1kVIUw1gPf8amtkIkb7NFG1OCdBCGGQbLFTz4HWRQW/uHdkpSKDVhA1xnGpsTfbg270LxhgS0ujiPtRxCm4Z6Tfpz0uNjSHN6zkI+imG28WERgbzNepL/RGvgSbYhM2X1hKLARupiVd1rn/tnoawb4Zax+ocwT7wrUVQUbdV+FvBiDj0pCavk2nAZ5aZcHcznN/SIm9EYjyD7zlD9AxOb7amogf063/tk18tXCXy+3YWSbMyOy862xEGEaX3J9cSmQ7TUQIMx7ukC13iIvh7KWbtyxDUSeEb63cwetqkh2uOIcnYUZfmn8rLMIWEm7espUQKvbJOxZ18R8HcZ1h90ptEtBq3ZEnbU21thisSkVtmA6W9Nj7S5244STzK7sdDtChA33EACCSjiTkd4jC+8IC3UOGvM1qXXguncWSfX967DwBqOkLi1FIbK8zNl1J8clAy9s1y3rhpkbxnSfa91KKaN4TyhnQb7WR8VfHJo9V23ojyurBetXoJqN7y/aQGqMFplBBXX/OmLGhNtyt5dDy4fIGNryRZF61m5pupxe9Loa757HyNxbIQktEQTgN6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ee6ef8-c3f4-44d3-6723-08de60428a5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:03.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b2HxjVvjl9m5Mnu6Z+vWSp708sgfPQkPTraD6mVRb0dO8Bz+1b58y94LWTKbwiAQtLVP8pLO7g/tDinm7iSpKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX45nXUexXzL/W
 caH/j+BUu9DGuDZ9JEowkT0WuIEO/9kjDZc4ZW/kTbRNTlBqKUDmwDWIESF8LfPBmvdrI3cYS/R
 0naZIMP/WTg4XnRdv7gw29a1QmTX+95WPecp6oIHmAi/P1ZTKeeibcAXGjUOmvkKaXvMpvYO38i
 4zxmmNgqTXA+3EA6/gwy/5G3NEaPkVFJs3a5fwuYpCVH5XOiUOUKD5bLhzCcw++uG0yf+/c7aRj
 lSZ3fID3RHWY0XEjCm3qjZhldi41SHldrDtLj2D+MZOFe09Q17q1ttanUPkx08PLj1as1LZ1zBs
 sasJ15Oo+fBICf92V9fhljuokhf8OoX+gevsANOAnmUix9V1KRbhRyVPMZoXyUb+PiEGcTE6pbJ
 FyAQKocbmKBBQi1GeXCG9b1ZU+RlqSnZSUlrAlHbBY7AUSzoT+Zq1XB/IUMqVcVh96mYuIPWKfy
 thCHN5aSrsdIpuH56hA==
X-Proofpoint-ORIG-GUID: ZlufzSr6PrKZ3CR4h9FhxAOPxKZ0vX4j
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1bd7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=sHg5AOaFVM-jeF-jK6AA:9
X-Proofpoint-GUID: ZlufzSr6PrKZ3CR4h9FhxAOPxKZ0vX4j
X-Rspamd-Queue-Id: D2C1B20022
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xuokinae3mq9wwf1x7p88tbbz8kzrica
X-HE-Tag: 1769806823-179941
X-HE-Meta: U2FsdGVkX18QQWRwQWvPTF92qk2b2GAfho5B5QRnnf8LiPVlhz52CUj2JE+dCFLsqvwditbfNg2BA55C8eQq7SpN6ZumPDBoaHA6O8jJ3GVJT6BrHOHahq183iiXfvJLGiHZugL9+NLfnUoAj8ho3jSR2rxhbML9pzOIaAdqu/fye2b2bI5lheV1QMdPv1n6fUY2sGcqw6feWrZ4XVgFA8eMYtN51lpYHpZTwC6kWu59iUskW3TBkYa6v/7iRXfYACbVzbkQVw7TGN4mLgeVdyZBi7T4qLaPg8kSNVk8lL2xBaj+2BEB+M+tWfekRxockRkWmPfjwMAH0OoQxdingdK1Yf2fJV60qkWQSpEq09Y5Ds8CwcYWnJRuTJ/X6jxwxsZB9JenG6eIJFdSj+LvLONHZEwC7kHGf6GdKrhNuBEsUQ9RDAQVjPL3CfhJh5nOriEYbbXo9jEWgFSsiH6MEzq+6Z2oJg+l/az9d+UJk5y0ZSgcDKWUpgAUImqtfEoKJq8XRhs9PjRH6CnOJ59kW6ix/TpHPXbVB2Hl+1piF604zYqEMQ666pVwOp7gwwYWBwOycmqNvn4I+tuIh27as7fOhewhPs0Ex8S/u3k14nQ5pqdXt8r43TZoqZ4i08/yI5NUQAkO+BFeHLzFvnfCOBd0Gc0oU+UcH+mRRfs4x85Kto6jUvqGNDu/mtEY9F6Va2lEQgVpd9/9nOLlf+2SSo8YVoOfQTgJraXxiRtvPgwiTx+q7L/NDXLo5vYZPMAKizBJ4UB8/6LEGmOZ1Wa2ON0Z+arOcv3JqWx7zOaayIzOHPFUSK55eV3q2v2b60twfTS0FZPfpjXwvVDdKiLTl4Jx20+1PvTyQIZvkCMG2NP8RhW3zKvecmzD3/9vITgOjrPmR9JQsOCXajQ8aqUxRgqhtJ0mS3p3KCy6Dl1mxyleE9sNl2KNTUeYkH3MAxcMteNIa320FRTMJ8b2IWH
 Y5t/cYeL
 ffH99QP+aQ8VsnX7lyZj7HXZpSQP6448+tMmPlc7UsHq2+w5SVemzsuIByfShCRYp/IXS136BVy3ee4n9htL9lMwDLX+KYQoQWl1vcui8bttQL6t7pOo1wlwVAmqkZxrmEFP+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The index value is already a copy of the maple state so there is no need
to set it again.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9ab42821ee2dc..1e780427c04a0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2766,7 +2766,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->index = mast->orig_l->last = mas->index;
+	mast->orig_l->last = mas->index;
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-- 
2.47.3



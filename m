Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0788CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0A16B000D; Mon,  8 Sep 2025 12:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B81A6B000E; Mon,  8 Sep 2025 12:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FE66B0010; Mon,  8 Sep 2025 12:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E83166B000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:53:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95AA51A0213
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:53:59 +0000 (UTC)
X-FDA: 83866680198.17.4D3A93B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id E71CD4000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:53:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R0La93TU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A7SGmoFc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757350436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UruFRzLMln3/Mz8BdhEl0Je9vLwj1EmmMSCudwBkWyI=;
	b=3xJ4guSyJzMKzaf2nU9ZA7I7oa7KIWOVyc3qDXoyW/UwCV22weEwwX1JBTxPgTQAmuNeLW
	hfR+BAINSavMENnpYG9sTJ3vLbiut72Ysyl43S06osEZe2wHn5oaGNcqysxFD3345vY1uo
	fy0pPtpcV1pZhzZDtFjZj027Bj3osM0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757350436; a=rsa-sha256;
	cv=pass;
	b=E3TNW71CkqnKB8FxvgrWUiV3HNjSd8ABuDMue7UqNAJYb+dvFfFiVpgvmdyrhQk2kyoEea
	5zRcKZALB4FBzjE/RuvGRFAKIy/XdEg1ORLes0E5/iQgxp12B7BzmLSREVEP2OJqKJAyyR
	oCrMyyTOEwaQjyXWqIMMBRJ74fcgSbE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R0La93TU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A7SGmoFc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588ExrKI029634;
	Mon, 8 Sep 2025 16:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UruFRzLMln3/Mz8BdhEl0Je9vLwj1EmmMSCudwBkWyI=; b=
	R0La93TUA+9N62MIvJUvQERZEmo0g7Y9StNg5c1Fyi5wLExQm0P9cb5Syfy1wwBF
	1EhXQ8VyTqLFwVNYg6Ku9FQk6VpfouF20Xr6jGu49gB4hQlRUhkOCpT1ZHK51IRi
	vFOlAenEV8ZPuxSmFatKLOMZ7UjaxQgxILYg+F9iCj2zxotVaqejHqXM/MXy5GpN
	Kr0QA8pK8BMSGBQYoGCNJIfXmbLQWIfnmgsEoOk889GJNDsuJXo3mXXBFL1bu72F
	55oJ/Iflu71UAf3HjI49NbYFDtSdAoikC6yYtTblEuPtQ3EKqxqaSn+sQrAdQSuQ
	tSEZrPaJhwf/OnwUhI+7YQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1g8hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 16:53:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588GVjpR025894;
	Mon, 8 Sep 2025 16:53:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8fnh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 16:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mt2nWDm0oauMYXhojORi8tPkFBl8YC4EZ4zUqv0lR3dwRNnF31BYmvSAyazWLWOYuqf850mqQFQ90jLSNcQF6PdCrHeNHJ3qLBGvuAvC1LueQ+C5Untii2wnmB6zw1e538ucTtNuzfvaNccUQxglvi1oDlxzkTpkHv7XGB7t8+XKz7947+qj/9S7D9824ZOTZmWeTN/Tgi62RZXMIbPQlJw0ExJEbI29ytEonmckhMMK0B4el3OYACrb7x1JZZ8I/xJ4Oi6EcpI4oJC2zkACOpP0HLZ3z8eBaizRY0Wcb0x9fo7Sunxxg5+VZZDxrmqFGKyCgfzzIh8jR/AiiBCKuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UruFRzLMln3/Mz8BdhEl0Je9vLwj1EmmMSCudwBkWyI=;
 b=EZuuQ/PsNgp5nXdmtTjz9claNn0hZbRGc2or0scnuL7y/+zf4uzFPFutsjpxvZkjg5t49T/Q8NI+dlltvRWK4oFy5uSugxkMmuiBTn9lev87A025QNkjgCrqR7Ix7qJS32SbyJ71lpUBJSqrbtrxvKPcQe4gaUcHBXrBBcPHvKhLxP//OUxytt1MxRW8aN51296kkGdw2BPsMnxibRHdJjIvJL5J3iGHkGFsy4f6j0yzMJEWLgEC/GUkKsmCgFxHSe4goarC2MCI5R3wep7EHxltOjFYg5QjMkIGeNyBFtwKfiSI2+7NSnQX+8HgI+eOKhO3YDlxC0WKHc6bJ3RHkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UruFRzLMln3/Mz8BdhEl0Je9vLwj1EmmMSCudwBkWyI=;
 b=A7SGmoFch06hKUfNdxowASMfTTQ5MuTj4AzvfrR2cg/QawmyGYMBmkL1R3yEtC46xPmkr5sYUB54XHL+Do8N2vGSUQTiSGVzttDc4hZL4W+cdX+68iQeu253cfP/A8XoC+9dxrpoMQHYUwR2Vogwgt+pcqhYY0Jwhv9PxFRPpow=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 16:53:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 16:53:43 +0000
Date: Mon, 8 Sep 2025 12:53:37 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <CAJuCfpHN6vpDx+UNPEzJgZ_qD9USTJZ_+yZzQg2BpF_aRpufYw@mail.gmail.com>
 <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: QB1P288CA0032.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::45) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4757:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f396ba9-d10f-4dfe-8c42-08ddeef84481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7z8cucH7V8GN07unlippE3vWUddOo//k1QvMZvqo1fCXXXO/mSLuwmp3cWnH?=
 =?us-ascii?Q?5uQaUXu8Nu8Y6FE2atgOJM9yVw0E3Rx0n8+F70JU97/NWKUepRBQUD4SPmBE?=
 =?us-ascii?Q?MBuuw35i6lgymQWsVJ8o1n36eymbnLtm4czm0MKOdc0ESDJiWeoTL6tPHU0U?=
 =?us-ascii?Q?D/yW0BZEmauV6ocQtVRewC7kh9IcFmVXwt70EXaZT6seY7UbiTBP3rsQjzvX?=
 =?us-ascii?Q?2ykQyRWm5OpNxeTTdJ3VWNjkr73H2GknJNcUf1IBPsfE5XGuhSEK8Vl85dRT?=
 =?us-ascii?Q?9SW/Q5NM9dY1BGalJW7HR+io9bFVCFrknS20fZei+XD90XjdI3z2Kmv/ChmG?=
 =?us-ascii?Q?r5zYBV0LfAQ3JPjQtSze6c8y0hFxDZph+B+smtGoD2ykgFUOZlDxQzQutpym?=
 =?us-ascii?Q?k1KGJinI8aspAcLg++eOGV8Z09JpZFjPkj5lXwiG0P/g5uU+Q5xnA7rUNcz2?=
 =?us-ascii?Q?YfPAQ4C3ZokTCvLx9Bta5cCjnXjagOzyaIqWlbNGpcP/XeVKQFUvepsscZLZ?=
 =?us-ascii?Q?B4l2iCF0I0HB2E9pVPOz1TSuLo3ROy6KcS4kOp/8wyQSaLSrDOPah8E7ryyr?=
 =?us-ascii?Q?s0efKBp1e7LPZtIgaOBiTvMmoE0tdNDKoVDKc9cTmbfwWsh8yHXsShFzgYkZ?=
 =?us-ascii?Q?8PiBulA7BkIOMF/4+qTAFf+AQIFsTf61G9AwzVNjzCBG+eLGJnP6lctU9MTp?=
 =?us-ascii?Q?VwpodmVVnKuqSDe+7JGhxdRYWz7uWldYpAiBsaqLIbxrIn8W63aNjjLpbrU/?=
 =?us-ascii?Q?0Qtm9EEZ3JZeFuNxqwhzNokyE0QTloaHQG09NOC4u9ocnKdzwEfZGcsLpAyA?=
 =?us-ascii?Q?0MbaeRwSQqsxrngZXW4EY/HqIKBw/r7Dv4iQ/W58feLWZyMcumD3e0GKp3Ut?=
 =?us-ascii?Q?WJQJ/l4lqoqCWvwuC4gdj0wdqq/hOrxQPnW1cvbyuTK+CNQbycIA04UOSKow?=
 =?us-ascii?Q?o7sPVtXg/OS6O4Npo1iVW993V2+HmmYngEVn/mYn2Hvsc0rLF5X202UXzTfz?=
 =?us-ascii?Q?2ExVGhrVIEGyzLNQ6dt3We6pXcHxK1uda/fN38mjd13w2AHds9h4GbBYNmC+?=
 =?us-ascii?Q?1ozUF7YkrODgypE78gA6ZIsBFJ6hkqp19iHGTiNd40zvwEGhHHgW47m9Gbm2?=
 =?us-ascii?Q?LzlwUq7KSd20RiUe9oFPKLEDDTfo3DG9chHHGEsnnyuDlAZlZy+ZuK7JNf08?=
 =?us-ascii?Q?khtsLr74Z3i11kAclais6cP6qS9AS7pcwlqM3CoY6zhPqBF9hWGDZAZTh4a3?=
 =?us-ascii?Q?PvLk+P7ARQ0okBeh3YO+v+pdVLczz2zz4X/Bdi/f3X6Owl1QDNGtvMS1D4G0?=
 =?us-ascii?Q?ACi8WsEs/e/NtaQR/zbv75MM3Gx6y5Y3Wj/IN/IM04DpgKi3P70K4B4G9wMj?=
 =?us-ascii?Q?glaLwXxfpXPj17YcdErVX2q+ssryKGW6tvdFzhFr/5KEqzeDGjEKzMih/7DS?=
 =?us-ascii?Q?Dmtt7IL7wWk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p1jDFDi37nVPwS7OrlAWb47oMmk0WkUVETmh3ziSCgwobAs3WuigIklGbP8t?=
 =?us-ascii?Q?sM/3MX6ZxAdnQljb2Zw/6HUWaZePGg6ey9Oz6ZIjdfLfPEmzoNcEIJv71xqt?=
 =?us-ascii?Q?q36GbAd7HSHqGTYaaN+GD8/YpzjrrOolPVlEz1OL6OQ0dBNowbIglsinx7BQ?=
 =?us-ascii?Q?D2JZVVssvQl5CaYueeIunmV83XxZABCh+egoigtSf92sTRBnNiaDTPToqqHU?=
 =?us-ascii?Q?vRaivCAtp9CBO4jT93jyyIm/JLEdWN626JRNsHzx2IYKAUbbz5yYJBCfqFoR?=
 =?us-ascii?Q?HKMZiSjDYG8qFF7c6s3CFk002zhnJb42cpZAJGD/kSAZQr96ctBZbQdjqcrP?=
 =?us-ascii?Q?p+ygev65m8fw31oDiKOYrjs21Zk2T6gkk77hfHp2jHW+Ma7PdHXMHkT49Ubt?=
 =?us-ascii?Q?15p6Wpw/NOgNVRMtF3mFb/XsPyYXa8oeLQaQGfF//7WQ7GkmIegjIfWRWy2v?=
 =?us-ascii?Q?1L6L78GZ7/TqSRlwxWZHIyghW8R8AXv4cm16QpVKyP7IU4MUp3nq2KQVK7+e?=
 =?us-ascii?Q?3vespo4Dw6575kyixbsItClIu+rC8Xjx8ko2oEaTFPtB1KI4qKK5xKApA1Du?=
 =?us-ascii?Q?Gnwp3uw1fUxAJib2kSc4gpHXT9plHtBawuvHApSyV8Y7GViwDCiloXdM7IlX?=
 =?us-ascii?Q?HUWAEhf7ALTNpTJk9TxK+vOLmMVtFSg3bElDrKQ9HRdTwBFwWh7sA/lmMgmp?=
 =?us-ascii?Q?39wrxSJqanfLWPiFipqxC1KI8ZfbtHsuLUQjkzq2JPe3uNTfJVVOl3AEpVXX?=
 =?us-ascii?Q?I06Ty20u60AfQUkSk/Ye9YXhICrgXrvTbVDx6EMQ94pHl9pzC6Xnd/hU60HN?=
 =?us-ascii?Q?RG+mtlj5tBsYrDM1skceoMSyxwvMv5AGMlEWfeibTbgVa3zbTAaQPZIcdiG6?=
 =?us-ascii?Q?IWL+9TSQW0R0ti/x0FftV/VCSEND+9k399bW3rDktFGPNZyAg0qt5YrEr2Ul?=
 =?us-ascii?Q?6+N4VDe25R4gXFbBcQcC1elO+b2ZUnCfFE4JSwREoMg02NlVZlk3QJssIUvW?=
 =?us-ascii?Q?9mP0OGG/Nd1OTF1TKRjisTk8P3ccMtbP1MOpnGbQOZ9UKrZRF+cLAr16waBR?=
 =?us-ascii?Q?jzv9Rmxrasu6V0a3fcccOevvlPD/eHTOfaXjToBnF/YbHYPsQt+2WZ8szCDd?=
 =?us-ascii?Q?Pdyq4JowRcti/MTqjmrFeevT1xLZI8rqcTEzXd2XJucwzvkAgmEmLRe8fFMl?=
 =?us-ascii?Q?sOTKi0MWr0FjLTmtWirKIfOeSye3bj9rl4vAlHo3Q6poT0KTslIRq2PJgj+o?=
 =?us-ascii?Q?gWrIGJmEA6OmCp4kRlUZ9OiFjWVl4oKJI6P9L0TYKvjKxXVmT6UVoHogRtur?=
 =?us-ascii?Q?+jBqfNEAgcIW+bYZTV6oKBpGc50znttwf7OUHexgXmiXOawUqyF2QnIKHTrv?=
 =?us-ascii?Q?bguBqu9ZcR/27epWrZEiaUfvjxkecD1Nqw/NeCSP+S/AQerpVpb7I8VLwa4j?=
 =?us-ascii?Q?7CHctx/FKsqhltjXevWM/uADr1iA5G0O9TKDlQDE//rKs8CNJFR2iO1Mmrqr?=
 =?us-ascii?Q?Utm6Qfg7ztUbzUKXuVNExwjVEK+sl263k4D7moM9G9GKb9riKpji5fd3Acg0?=
 =?us-ascii?Q?Xewpb4G12U+RwhUIh2Au08Y/m6WhV703N8vOnrSB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YNpEK1myfMD/ZIkK2rR2zTD6hzglPaSBjnbpCVr6oCtwpuHigafkGWNEXrBupFE+y0iBDEGC1c+Q4vERuLkGPivPMOAmib8j+LnBKRfmao73aR12w13JZ8y469mi7X99NvslZEnjOhQ+9jD1jCD0/W5z7F0/pxBXvCGbco44pzdp2kN89em+3U1xQqN77wvBz7EBkqJZoAPu4shPAdgp8rj0oZNz29ZzjWU6skDgB+5Q51wW/a2VeGeoloEWJ7E9IA75JD74Z8tQZQlwvmiHttblWsHizkbLL2NFB1MfBzy+mKtYasw9pT6cql9V3AjRzb7DGaGEiWTDAJB/0ooljV5vcmlxxwlpOmOWYpIjAKP4IplrKPcHsc+nmYGlX5lSq42gTObF+8uVpHqmxyY4r4cfqss3pViqyG5IobJZSMTDas+8hY8aCEVnNjN/E0sNwwJ1LiyKVEHwcDEs+pDkEuBsxPXaw1P7FbUmW8WS7hAsM2vDwqndRRjWaKmskmFkVtvEFRgJTOi0vJH3wcXw06qZOOLxZF6ldYobMK2AI20c/GvI7RfIBC12jBwiRsxC6F2hexpwa3tU7UhQvxtKzz98W4qfvX3gzi+eEnf7omM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f396ba9-d10f-4dfe-8c42-08ddeef84481
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 16:53:43.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMmvv2vEyA+DyNXG6FM2IrL/PerQMrmvmnV2urRiRnNu5BMzjY111l6eIPyN0x587rYmPN21XalJFLBh04UbOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080168
X-Proofpoint-ORIG-GUID: X0WQ01t-lGQd97Fb4fCm_32WotTJYbih
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfXycFFR+61jcyk
 5imTyPBkGOp7Dqgj8KxMenjyZMB2VaEmPyLkyEagRtdlYf8VZXzFGvKFoe4qNk3GAwnvhPbCLGL
 1jLk3Fj5kTCHn0H65wWSNGEM2/mIvYLqlr2z6WjhmqPY2PgUJGHFF2azPJ4k5RwgJ5c0vyP11Q1
 r339gyFpVp9LQ3CZEx2uUEhy5K/L82JQwrjXE2LrhH4BBtVxWzPoRA8Sx/2rMWhVFgl3qbcisi+
 vh3yB+rh76Rj24urfZ5xixfWBBq8ZFOeOAN7tEkM76z90fON1avo3V7bVgPbKOD7QMN49gCcvW2
 3GOv8VheZ8O6Q9gWReOzbCgJUo8W79LV7tNzToZ3qnHSrDsCyhXqAkL//7ggHzMcuwh32mHLs2u
 O+mXGuIWN/m9o2uGevu6AK7JltR2IQ==
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68bf0a1c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8
 a=vggBfdFIAAAA:8 a=20KFwNOVAAAA:8 a=8DstSWihVa5M2P4fkQsA:9 a=CjuIK1q_8ugA:10
 a=TjNXssC_j7lpFel5tvFf:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: X0WQ01t-lGQd97Fb4fCm_32WotTJYbih
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E71CD4000D
X-Stat-Signature: 5jzof36n1ytd3tot6xwg7ayc1wa8u4os
X-Rspam-User: 
X-HE-Tag: 1757350435-664431
X-HE-Meta: U2FsdGVkX1/drQa7UFDevIM9OQUD4D2qPuMLvvIojjhWb5ecj63xawUVm0ilXAtRdGP85ji4dRaWLPuh5de/ia24zwIzsmsRki2jGC133CtSqYSfs36AbJjq32RfgI7ezdHZmvfb2cDlLGzDtWWYCYmZNepu10swIRsrBJHGh8nBEJvmmCTcCXKKpDjlGNHiRCyokzh/tty0YeJCl/j/VXKm4zy2agCYP5eapcJ8peERFSiLVPaAGdNKbjKUYI2p4mT2cgMYavGTgK6X1HsORli2CiIl1Gje5vJiW3T1gC5tnEJ4NuqNidyl/ROqhbYOOVwDark56wSp7dP0nmOLAucNKFGijYuHd9rwB6pCM6IUFefqQJy1z0v1g1ydBocofogy9gK7mqofJ/ziRC/xQn+AqWfaNkArlC6Ry0Qwtc71IyoxtRe2biZk/PDeGG7IR8CW4XoFaBT4bI70gUWfTI0k8mCu8iCPj73hlC89Vl6iOGXQtFGnkJHR8LsZrREkDmuzfergOzXud1i7wjfO6IUu3Q7VDeMsKocTzBw+DwIe8O1PM6nU8vbIh7KhgDLTkxQQRwPE56dzKwaMEQLnDFpo6hwHFsDQGQA5u+jInCyW5v9vpr7guEVGzBKsFTcgk/68x5JSEV4VmfOAtsHT54E2NutZH0bhQL3Y+rw+WMZno63/rXZgE/JonHyJjoStnJ67h2Vj8BmTJYuBPyln2ot0P8fDRNDqxK8RNJ76VbxanskP6GP9ohD46JP3/mP3gs9cxnzyUpFL6NVq4fEdFNHOwyiTAwLFfm+yqfAlwTlKamn2GVyO51rl5UGDS+3UiGD5I1UganMEa7FNXmabyyeKcn53bEJkW2WgGeeK0VPM/hOjI//O4uztAauBXpLFYxBhKE1E1RHGFfhmuvHU8YfwGChmONErS1ESELzd6md6rf72Gun7PceekkXf006IPQPu26GUonAZuR03Ekb
 VnbvrDuV
 P2M1Zvm/+IooWH/OX+GK1XrMkbckC43fhmz57CF6jL06fKA+FjjDTJe+GhGKVxfECc1g9bBIcju9bOICB25iR3pz0l4sbWS7F1iEJ/IfTtZP0OmMPfWFMdwHt0hbBQPWNmI5im2wlJBe9R5x3jP+7O6gAWpEqCIqh+QtYj+oLPnWPF1yLbx5n1nOJ9Z+sO+phmhrlhmOEjlpiQ5RCcaOqDUwi5t3fszyFAkDvDjffBWAIkRgwAsAS2iqriL3wXd1d42zp6w0XcSnt8qrES1l0uMGq/QVaBbfp0sDLsuxdAknSQaqwjN4J5GWzqdbYGTsZ6bqW1sZVwFL/3rruWUqwVecLREGL4ZnFl25qTzcEbq00ENndaz1vei4QaWLGnPdpmhxpHNfGLrM5d1Hg5WmJPWW+vOIwb6g65Y5850rTE03lrVeALHIHn3xAnQTVKsaQfZdV2trwVR+pHEL6Gbv/rQFp1qEKFXPgCEe57P32F2Bj1CeiAfS9QpCd6CMr/7SD6EjEVtbl+noAtuoh1XDxYKNbIPW5bAGrWp/hrm7nO4hOK7rD/HYeKAyMbStsTaajRBqGLQNVijLukJ18hQ5kKQsLVUvL7LTH8se8LmV74+KT6exwfF2Z++ien76+2ieFJFT+KP5QXaLXv38LBAK7tqvzyvOxBJ8afV0HrwdfnEDYXP1j+SDrOLJnWuQMzw0uQX0L1N2K3bKvNehPTkNqnAPQ9La3pM3j1B/q1wJCJLZn34otsfotFHPC8AHoGIRQGp+vKV6a8wDSy/1Zji6S5jI63NXPEmSy6A+i1+r17So0CJ+eEIMPiF03Hnx9p1d/ew7Sws7nUePGj9ZLl9z/HhYSCCTR7C3emXdjxaIiz8m1Q6JePWOdu6iMoeXQbLoHfjieljy/PCeBinsjl6+JFPaXlfFTg3bFtlcrMcfuzfa9Y4E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Nikita Kalyazin <kalyazin@amazon.com> [250901 12:01]:
>=20
>=20
> On 04/07/2025 20:39, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [250704 11:00]:
> > > On Fri, Jul 04, 2025 at 11:34:15AM +0200, David Hildenbrand wrote:
> > > > On 03.07.25 19:48, Mike Rapoport wrote:
> > > > > On Wed, Jul 02, 2025 at 03:46:57PM -0400, Peter Xu wrote:
> > > > > > On Wed, Jul 02, 2025 at 08:39:32PM +0300, Mike Rapoport wrote:
> > > > > >=20
> > > > > > [...]
> > > > > >=20
> > > > > > > > The main target of this change is the implementation of UFF=
D for
> > > > > > > > KVM/guest_memfd (examples: [1], [2]) to avoid bringing KVM-=
specific code
> > > > > > > > into the mm codebase.  We usually mean KVM by the "drivers"=
 in this context,
> > > > > > > > and it is already somewhat "knowledgeable" of the mm.  I do=
n't think there
> > > > > > > > are existing use cases for other drivers to implement this =
at the moment.
> > > > > > > >=20
> > > > > > > > Although I can't see new exports in this series, there is n=
ow a way to limit
> > > > > > > > exports to particular modules [3].  Would it help if we onl=
y do it for KVM
> > > > > > > > initially (if/when actually needed)?
> > > > > > >=20
> > > > > > > There were talks about pulling out guest_memfd core into mm, =
but I don't
> > > > > > > remember patches about it. If parts of guest_memfd were alrea=
dy in mm/ that
> > > > > > > would make easier to export uffd ops to it.
> > > > > >=20
> > > > > > Do we have a link to such discussion?  I'm also curious whether=
 that idea
> > > > > > was acknowledged by KVM maintainers.
> > > > >=20
> > > > > AFAIR it was discussed at one of David's guest_memfd calls
> > > >=20
> > > > While it was discussed in the call a couple of times in different c=
ontext
> > > > (guest_memfd as a library / guest_memfd shim), I think we already d=
iscussed
> > > > it back at LPC last year.
> > > >=20
> > > > One of the main reasons for doing that is supporting guest_memfd in=
 other
> > > > hypervisors -- the gunyah hypervisor in the kernel wants to make us=
e of it
> > > > as well.
> > >=20
> > > I see, thanks for the info. I found the series, it's here:
> > >=20
> > > https://lore.kernel.org/all/20241113-guestmem-library-v3-0-71fdee8567=
6b@quicinc.com/
> > >=20
> > > Here, the question is whether do we still want to keep explicit calls=
 to
> > > shmem, hugetlbfs and in the future, guest-memfd.  The library-ize of
> > > guest-memfd doesn't change a huge lot on answering this question, IIU=
C.
> >=20
> > Can you explore moving hugetlb_mfill_atomic_pte and
> > shmem_mfill_atomic_pte into mm/userfaultfd.c and generalizing them to
> > use the same code?
> >=20
> > That is, split the similar blocks into functions and reduce duplication=
.
> >=20
> > These are under the UFFD config option and are pretty similar.  This
> > will also limit the bleeding of mfill_atomic_mode out of uffd.
> >=20
> >=20
> >=20
> > If you look at what the code does in userfaultfd.c, you can see that
> > some refactoring is necessary for other reasons:
> >=20
> > mfill_atomic() calls mfill_atomic_hugetlb(), or it enters a while
> > (src_addr < src_start + len) to call mfill_atomic_pte().. which might
> > call shmem_mfill_atomic_pte() in mm/shmem.c
> >=20
> > mfill_atomic_hugetlb() calls, in a while (src_addr < src_start + len)
> > loop and calls hugetlb_mfill_atomic_pte() in mm/hugetlb.c
> >=20
> > The shmem call already depends on the vma flags.. which it still does i=
n
> > your patch 4 here.  So you've replaced this:
> >=20
> > if (!(dst_vma->vm_flags & VM_SHARED)) {
> > ...
> > } else {
> >          shmem_mfill_atomic_pte()
> > }
> >=20
> > With...
> >=20
> > if (!(dst_vma->vm_flags & VM_SHARED)) {
> > ...
> > } else {
> > ...
> >          uffd_ops->uffd_copy()
> > }
> >=20
> > So, really, what needs to happen first is userfaultfd needs to be
> > sorted.
> >=20
> > There's no point of creating a vm_ops_uffd if it will just serve as
> > replacing the call locations of the functions like this, as it has done
> > nothing to simplify the logic.
> >=20
> > > However if we want to generalize userfaultfd capability for a type of
> > > memory, we will still need something like the vm_uffd_ops hook to rep=
ort
> > > such information.  It means drivers can still overwrite these, with/w=
ithout
> > > an exported mfill_atomic_install_pte() functions.  I'm not sure wheth=
er
> > > that eases the concern.
> >=20
> > If we work through the duplication and reduction where possible, the
> > path forward may be easier to see.
> >=20
> > >=20
> > > So to me, generalizing the mem type looks helpful with/without moving
> > > guest-memfd under mm/.
> >=20
> > Yes, it should decrease the duplication across hugetlb.c and shmem.c,
> > but I think that userfaultfd is the place to start.
> >=20
> > >=20
> > > We do have the option to keep hard-code guest-memfd like shmem or
> > > hugetlbfs. This is still "doable", but this likely means guest-memfd
> > > support for userfaultfd needs to be done after that work.  I did quic=
kly
> > > check the status of gunyah hypervisor [1,2,3], I found that all of th=
e
> > > efforts are not yet continued in 2025.  The hypervisor last update wa=
s Jan
> > > 2024 with a batch push [1].
> > >=20
> > > I still prefer generalizing uffd capabilities using the ops.  That ma=
kes
> > > guest-memfd support on MINOR not be blocked and it should be able to =
be
> > > done concurrently v.s. guest-memfd library.  If guest-memfd library i=
dea
> > > didn't move on, it's non-issue either.
> > >=20
> > > I've considered dropping uffd_copy() and MISSING support for vm_uffd_=
ops if
> > > I'm going to repost - that looks like the only thing that people are
> > > against with, even though that is not my preference, as that'll make =
the
> > > API half-broken on its own.
> >=20
> > The generalisation you did does not generalize much, as I pointed out
> > above, and so it seems less impactful than it could be.
> >=20
> > These patches also do not explore what this means for guest_memfd.  So
> > it is not clear that the expected behaviour will serve the need.
> >=20
> > You sent a link to an example user.  Can you please keep this work
> > together in the patch set so that we know it'll work for your use case
> > and allows us an easier way to pull down this work so we can examine it=
.
>=20
> Hi Liam, Lorenzo,
>=20
> With mmap support in guest_memfd being recently accepted and merged into
> kvm/next [1], UFFDIO_CONTINUE support in guest_memfd becomes a real use
> case.
>=20
> From what I understand, it is the API for UFFDIO_COPY (ie the .uffd_copy
> callback) proposed by Peter that raises the safery issues, while the
> generalisation of the checks (.uffd_features, .uffd_ioctls) and
> .uffd_get_folio needed for UFFDIO_CONTINUE do not introduce such concerns=
.
> In order to unblock the userfaultfd support in guest_memfd, would it be
> acceptable to start with implementing .uffd_get_folio/UFFDIO_CONTINUE onl=
y,
> leaving the callback for UFFDIO_COPY for later when we have an idea about=
 a
> safer API and a clear use case for that?

Reading through the patches, I'm not entirely sure what you are
proposing.

What I was hoping to see by a generalization of the memory types is a
much simpler shared code base until the code hit memory type specific
areas where a function pointer could be used to keep things from getting
complicated (or, I guess a switch statement..).

What we don't want is non-mm code specifying values for the function
pointer and doing what they want, or a function pointer that returns a
core mm resource (in the old example this was a vma, here it is a
folio).

From this patch set:
+        * Return: zero if succeeded, negative for errors.
+        */
+       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
+                             struct folio **folio);

This is one of the contention points in the current scenario as the
folio would be returned.

If you are going to be manipulating an mm resource it should be in mm
code, especially if it requires mm locks.

Thanks,
Liam


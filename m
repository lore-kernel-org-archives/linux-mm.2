Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01085CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA0F6B008A; Tue,  9 Jun 2026 14:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27AAF6B008C; Tue,  9 Jun 2026 14:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1429C6B0092; Tue,  9 Jun 2026 14:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C806B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:53:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 810AB91423
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:53:05 +0000 (UTC)
X-FDA: 84861271530.29.F44B9D2
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id A1E5680006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:53:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cnWMy0Hb;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781031182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99+1M+IVtMlRMe407WjQc467U9XqC6IJAz0nmEG3pek=;
	b=aDDIdLRa+lOA3cGul4esS/r1PXpkZCqimtTVoE3oDanKEdsLdU9SthZzdghSkC6yK0fvhH
	XJE22dT0AlF/RM9RrlPYXc6v/wgHnxvi9W+dFLaVmnBHJ6E/tMTJVE7nPEW9SfT2L+09V7
	VgZ7jHCtRbgHLHJYaletz9KJoNC6t2s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781031182;
	b=nO7TcEpGEvQT05lsiGEKrxopfhymRyy5sM8VkmD9UVBj0XH4qZpoOlufG2vapcfcRuL8Px
	fjZNaDAtj88jRDO+xBIHuQ+4OJ61Ix9lsqFnStVew9aaUKkVyivRAsLUiRqxE8rvaBUyBD
	uW8g0vHj0m42UnAjb2EA2BwMlrGiMcQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cnWMy0Hb;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPiDTUksv2aXRnRSxZAZI2mOt2vxOLK5GOmf3UJl7WtH5AY4DIQgu5HuB3k7zhmxbd2PIofyV3xjU0/K5EjFHDHGOj4wTvbDk9mjcJmpiSId4Z9aRY3P1LZY/tiMx/n3cDcauApHaTwsGuUcdVNWUbUw3xrNnTqU24pq8X0CG/fQebZkax20S4GTqdO94IVDACo53osauGf3S+XiWS4hM8V9GOs8q4yT1/T+kwqP7rcNH8XKuKWbfITNoGqoCHVHcKwlt2M+aWVb6eyVftRQe0/qhwQEPxmVpsYGL77BSVSCP97DBaGVJdJIohEPV8h4EjonnqpXfS2LdhjvpUBcVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99+1M+IVtMlRMe407WjQc467U9XqC6IJAz0nmEG3pek=;
 b=fIDdbpA7nopCDrbuI0N3CeCoRjBHwCTXDbRgQirQrseYftdKhdBl0A8aSGKO6kWwoOwo3xqUDrAQ2YCqhrJL6QRNgeb0ItDpL/SDZyRUTWy+jdaIyHxV8gM4F+3gbJud24a0INaKaOoxNx2toAtyYR7P3HnKcJoHmdnVosa7S39hHi15WgkhhVFPMhGRkj64DTxsZhTJVvOgNhsWYAoOAXpQcQmsGKtC5BOctfymgIhSe7SqaHfj1d/A39Zme5c9dlXrjNWQ2vME/VgOFZzflV9qjOylWj1ahplTU5JlWuBBq3LHyJcE0OR1wkwyHhH6sBRGKuCkHJR+l78yog50ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99+1M+IVtMlRMe407WjQc467U9XqC6IJAz0nmEG3pek=;
 b=cnWMy0HbtPaDxTNF6Oht2nvWQ+X1DQa+xYUVPFTulyWs5BH64+E+AO1fGxIjBb9WxVPTxbe7sWJ74eVf1l9yOpH4NQ2bQVgBPOz9KTyqYcaFdsV3NQTRaLEWVDyRm/eBQQdindYSvhSHKQWK/PAurDIrHudio/1TIMy5lnUgz4ndoHr6m9ZcRWAu4Zse5F56FH+BhcPVQXJewoOT2SmWRNklhvXtNhVa9J1vfb//K6zn/bJ5l3mM8R6fQf1Upwd2EJyZZakC4L1dTyyzh1ZSb9caJt85fbvLpnt97hocu6n+ANkpm5aOI/eDuoVrWgNh8Gl3P6rvvy2tHJcxnOqILQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Tue, 9 Jun 2026
 18:52:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 18:52:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 <virtualization@lists.linux.dev>, <linux-mm@kvack.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Date: Tue, 09 Jun 2026 14:52:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
In-Reply-To: <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c6d706f-1d10-48c8-c62f-08dec6584f78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|56012099006|11063799006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/TltIYIUnWWIaEkHYRGhS/ApmFvWgFd5v3ZGRKwmR+TjPCRPJPq4T+2w6IoVrMaDdfynq+YucBFMcpa6Q1Jse9fFpSqZjuA6YJdG8il5AGAbQ6gYxWOiMd7QgeBmiLSzkIvnU7O/OQhLenOmDx/a1iejBaULa0Y/9dcm0cfu6T5jFRBJgT6tG04/5EDEC7vCvKLTdRIC9T/oicf5SqY1aEibYNNPHn16gvNCII+1bHmnX53GNxW7epNTj3ed02rhaadwWSqITHQDSfXTX0LgOVTe1a5GVQax/40B4r501Lwfhu9uhswVM/yAesrt5lgQ3XjoDAgE3e9cliLlQ3nQBV+x+QIbHv3ftaZDdM0/ygeiVYyk+k1y4jcpoq6RFFqQP0jcpLtu+IOv9+i2cRXguSISyYGEu23Ri0BFEPEVfODxRTtnbd/YvT/TIs9woxeiv7KK8ofjsiUaKnxGFeagweEHHjt/vNbCdxF+mtL6xKqnPb+UqeLiq2lV+WcmlUZ3jeRWYAooe9Qjc7ggFdw2lQ+UBU5T9vNJCot0uee+tLL/atWOW+mfWI3cbicDjARy/sNn1bjGCR2fB31S9regKBaeELJUtX4o1Cc7R7if6EYuYadQ6K9vyqOt/HlwCq0lbyTWHVOVwuviG0YDgE93HH7MwGBl1HigzD0jceJGkyxrY2JQ2Oz8ZpetsesfQ7GN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(56012099006)(11063799006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/tO/oTG6a+letA0vE9uu8S5YXfyVHUulolzQYGecsuy+lkbj3b1/zNbqMD7b?=
 =?us-ascii?Q?tment+dk+C878SoxDzkWiCwSajmSmNOgYibYkF+OglE1taj6yVvzAdq3nd1p?=
 =?us-ascii?Q?BAswBGlFGbtdedDySgT8Ptv3fPefa+xG/i2yJF8rwnkmIa2FBIVF2GhdUSPB?=
 =?us-ascii?Q?MJ691K+YtHoQ+xZWQ7qIpBne+8Mf6dBDyR8pWnB5bqLLgXNQRdGl3bFL36F4?=
 =?us-ascii?Q?j6Dm0wKYTDq9weookeQkWlB9D/J1WYoG+wcaMJOiNNvAy3f2IH+0b8lRaAsu?=
 =?us-ascii?Q?iUJxKSdBQxq8qO6rAl8CBQe/qqc+gEX7GR9XhQF4ZMvkj+pUw1vnavQbyWAb?=
 =?us-ascii?Q?5xccTkiy6n5SmomWJBJ+52FBLMAPlXEv1W/+XV8VUpGIbv7dCKtugO6PJriq?=
 =?us-ascii?Q?AzO92bNpkEpTLdI+l56DoXLGCFCg1mtC4SFd8nYFM8cohKmkK6RqX77LIIzw?=
 =?us-ascii?Q?T4sle0xshNpWMV05V/RkIfTHjQ8KxUTnY+vhRpYdzwCDYjNTPhVRiu2LCuXY?=
 =?us-ascii?Q?1wnF9JY1+SFf+dopv/rWkT7QP4UKxYI4EuYXQ7sn7hr/trZoB8Y24jdtQdYE?=
 =?us-ascii?Q?OSHuo/VI6fBTtYZJXwCcMXaJQhxOsGq55Rg9J/EOAcd6+1l3SbhWq7h/kZSm?=
 =?us-ascii?Q?2ecEBX51IuoM1SEwAWaaR/nrw/+4DtUwugd+9UAaN5JlXFZEkHYgUBSQWTNv?=
 =?us-ascii?Q?KGxev8MwwxJw0Xd8ozXoD5HsCdGoOyrYqprOfqJCCLTi3V5nP1WYM/d2lY01?=
 =?us-ascii?Q?aNbcP7VihweDum+zse4cQAHhuloqGuTOlbl4lcbglzR+9Qmd9d5EbLhR/PWS?=
 =?us-ascii?Q?nW8Bx9uS8JV0aEwelkB6SogArz5mmqb2GUt2dH6/PYAW6BJh+f92RgIrg9Ll?=
 =?us-ascii?Q?4QkPNOhJQiczK/P7yeVR15/U+uMPXLBvTHeYFUYk7vnPL4yUzs9hGG9xu5jB?=
 =?us-ascii?Q?XcxbYnFkspxsI71hgEcsw99B+8osns5/+3p/tfro9U6KBQlBQ+gq4S9f2eDc?=
 =?us-ascii?Q?3Us1jAqoMSND8b6Wb7aUiPqxOQqlMsmK5YpuXWdo83ROUyZEUYgT9aoTHppu?=
 =?us-ascii?Q?7Si3o65YIc1Fz3SYVj31WDi75wfH5PQK4iS39qNiBNMUuw5/CNmp/Nkga+Ns?=
 =?us-ascii?Q?nDoC16rlu8Z9yUZ0GH2rh/QLGNy9BTv9DPFGeUdnS2hnRku5oUaWdwLT9GDq?=
 =?us-ascii?Q?J2gNDnEfanm2RFOalyjoaDxUq5eXHyZLK6WBKwyLtslLx/fc3htGHGhm7RYc?=
 =?us-ascii?Q?B6xGlKG9ypuymksGE1pd/nDdDxmnys3jNqFOGN/tCJpizAqtxOn9FHr63yWV?=
 =?us-ascii?Q?2FlbFXyXTOnBWRQsClS41YgkJBpZ+CYO6MaZdkiMdAn6rHzYIlPsWxqRW2Dy?=
 =?us-ascii?Q?4Rc4Ir1WMAzkmgvMGVxEekInTt7SOmPoej+G6uk1G/IohXZRF2b9Xpl9sRYw?=
 =?us-ascii?Q?Ra2f5dcMfOu2LpP2LFGPBM5a5VYPKue2H+czrc22cH53wdjuN7APe2IhmpDy?=
 =?us-ascii?Q?ssmeJkg5KNd5u4KC3I69GnWiHCX+6P0q3bxJdrecjhXIqaj56WetY9Ren4th?=
 =?us-ascii?Q?K9USSl9/HAjjZTI7nBUYlXaLV2lUTioGCKhqRNNCNfmQ+iN3l2ABraGfJeQy?=
 =?us-ascii?Q?W4+HDqUu+WnWOFYgIEpn5rwEbapfBnkw4cG0QKXV196f5qiwgLPGzZ5q8kUj?=
 =?us-ascii?Q?zQwR9KgUFVv6DrZjyQtc9wGwElC4pzfS9XLiL7OsLoMiAN8leLjfNsF/COF5?=
 =?us-ascii?Q?SSMH1eb7bQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6d706f-1d10-48c8-c62f-08dec6584f78
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 18:52:52.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwdgwja9gt6lhwuy6IGAdkkd6xjLKyZQ/zd4klVod1lRlv8cR6kU2uKzdMgKZXyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1E5680006
X-Stat-Signature: iqife4pqocknbuieqrgz6zmqcjwi6mah
X-HE-Tag: 1781031182-640055
X-HE-Meta: U2FsdGVkX1+H69aZbG52qQ2mIF6aLbBeOVMPqdEIyWd5DDZtEFJi512FC3J3ljcH76CT3Dmz95TCpdD/4PC4tRzp+AFBY52ZEaCaoC/eUXktvwCOZ/YQf7dR2IJhcQHeclxkyDeXF7lvfx6krvPJypb6AZu8cTKtDFnMzkkFg12u0c5WdxN0TM/MUTXuK8bgRPTHZhOM9yZWNFvJPSWRHXm0Z4TbPGBOkqN0N17pf/6UsvhD3Hwfa6HhqGA9JNSqQyFP8S1jeUwF3sO+yqgWrDOmr+KxIyyYfgl+BJNOggsGAGLoAwlMq10oCVsSjBanq7Tb3dXyHkAcsjliBU6Py1pGV5Fc560t3yZNVqvNtNb67FIjBmJoA5aDGLpjmgCcOTj2lTq6BfH257rG7rFUGiFPcMM420aJY1n8wUrsY12og55zavVGX2VmkY8FEykxJqZgyo6PGl3bUVNljr3EACvRsYzEZC14ClYIiEhgIaTPbCe3O9yjZyw2GsftZY/mlqV4t8vqqQpWLXEVf2lxz+/UpcOOC/Qv7KESGQ5Ffnsh/XugzKL6uQN11VKGKDoXvZMd/ZSbFr2NXw78AhppVOmHb/DtCjPKnzAlVtAyG8k24TQA7bbmvXNzdBBEqC83kAjuwNUpaO7CRm+LhE29gRu5LvPLjFeKP1hHCy4nVh9KcTNKLpv0SvTQPcmwtK1GuYxgahKomq+yxiF3VKVzcrsEUyJC3sqMhN6l/zPrBYHmU6q8x2utLvxU8JDqEA/Z2d8cz6Fr1v6zLOFYkQm4/oUZaPxj3NyRKW/Kw2Oatj9mujtAlngRpbK+oZQ2/bo2k62tlZZCooYHKt5HWOLHIg8CkGZnNochHpZR7MTf0Xnwo3WvtC7xvOUTcD0o3PcIuqPwoVmH2DRe78oqss/uGG/FZq7WlTk3zfKDeB/hBK2Xy5UHeURe/6R2QL8IG7oebATsyney+XGUTtXG7Ay
 tlXmbS6l
 qBARFHSB5yJECW0CHsSY3bhwkmHrrvef/7GyWySOw51nlnesysHaLX4Fag2RbEx6DTUze9HHs10RRoTgxG054G9GHS7I1qGr16/dAsGo5tOorUwwyF96cODcnvAgCGAbzv6HabuV90jdQWQ9l4NjVsEOhoN3CUuZ+543zUHHe80IrE1xi850HaO7cXG8ygVNpN9UGgmFqMrwTXP0o0BFBn23+aWw/lLqXfR0S9Cr9pjYMwqkIeO/nEZctsGx7c4yn9jEunN1tKsQMKRSI49XyfMBAxUCk72Q0AWzxDnlZbJmZ3FnwWMQ9nn7MbNJSWIoh3Di9qtyP2rFrLL5kcS0TJVJabg7cNblaxbnKdpZkji2E5QzM0+o+tlCR8wAci7EZWS64gOZVKccuTwqL9rv3qXGLMr13RlKefVBeMGedBScjqkRpjXvY9DovSdBHihdy5XiCEKJfoAd5j2ctQQar2QxVwjhnPMhfmAZToPy3y1CVzBcl0Vn1Mzt1SRKVZN/SuHqTiE3OCvfFbS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jun 2026, at 14:39, Zi Yan wrote:

> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
>
>> On 6/9/26 20:10, Andrew Morton wrote:
>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.co=
m> wrote:
>>>
>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>>>> update to page->flags can race with non-atomic flag operations
>>>> that run under zone->lock in the buddy allocator.
>>>>
>>>> In particular, __free_pages_prepare() does:
>>>>
>>>>     page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>
>>>> This non-atomic read-modify-write, while correctly excluding
>>>> __PG_HWPOISON from the mask, can still lose a concurrent
>>>> TestSetPageHWPoison if the read happens before the poison bit
>>>> is set and the write happens after.  Will only get worse if/when
>>>> we add more non-atomic flag operations.
>>>>
>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>>>> around ClearPageHWPoison in the retry path.  This
>>>> serializes with all buddy flag manipulation.  The cost is
>>>> negligible: one lock/unlock in an extremely rare path
>>>> (hardware memory errors).
>>>>
>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>>>> in this file operate on pages already removed from the buddy
>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>>>> need zone->lock protection.
>>>
>>> Sashiko is saying this doesn't do anything "Because
>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>>
>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b=
90.1780998980.git.mst@redhat.com
>>
>> Battle of the bots: it's right.
>
> Yep, __free_pages_prepare() changes the page flag without holding
> zone->lock.

__free_pages_prepare() works on frozen pages and assumes no one else
touches the input page. To avoid this race, memory_failure() might
want to try_get_page() before TestClearPageHWPoison(), but I am not
sure if that works along with memory failure flow.

Best Regards,
Yan, Zi


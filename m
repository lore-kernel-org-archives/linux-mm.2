Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C62BCCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 17:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E188E002C; Sat,  8 Nov 2025 12:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE988E0003; Sat,  8 Nov 2025 12:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977F28E002C; Sat,  8 Nov 2025 12:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77C728E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 12:14:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D5165B571
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:14:32 +0000 (UTC)
X-FDA: 84088088784.17.B97C7F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id D1B541C0006
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:14:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n6wnEALL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q+LQvOt3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762622069; a=rsa-sha256;
	cv=pass;
	b=Jljgiyj2TzD4QM6mL3dZGol8eksQvhVHzseySUUwe5QQ0dHOVa581aYE9iF6b+1D+5P1c4
	im447BrGHJfkLZVUc1nnabmV9ZYDyOZjwYdhoYCxmSa3nwK7GDXxqWkskdXBqbUNX3XbID
	93Of1x7iIZxAE8XrXNkrz5V0TzzS060=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n6wnEALL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q+LQvOt3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762622069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IS+WCD4gx0ikSahGAzl3Mo97b95pzUAhU1bCbk4hhuM=;
	b=e3cB2cvVwTPr5+s2+R6ZkgDk/uxE6EQKzUlvJCFBgNpnvzsSq8uIO8l2N0qmf07Mhqo3rn
	xKyhWa5u+v9Pcurq1PpO4W/deA8zDX6fdASHkkw1qj2azw8bsAvH/lmZm9cV/LbPNSaLyf
	wnz2WE6Ue6va5ZM+bvYVvRwzYeW03Ys=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GjTwk017440;
	Sat, 8 Nov 2025 17:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IS+WCD4gx0ikSahGAzl3Mo97b95pzUAhU1bCbk4hhuM=; b=
	n6wnEALLLa6C78iesBxKpzXaw/hQ2gUeC9PZAMUhmRTQap01wU21WY2nLLvGvkxX
	R3mclPS3Yc1mh4eXU1ybCwmFQ47OtQWjSA6YSX6LrS/t+kLY1XUM/03iuciijoJ0
	IdM7F1JuKrliVn/wqODe8xw/lC4/RfPQE1TTsOMI8oEtn8/I7Z/3a6yEdUhO71Y1
	5DQFizytpf9v0bzPu6urMQ9O4/qrWag5v79v8zuJI6a6sOUPl/fKjqKBpy8qyhxD
	h1huQy7n1g+fAmFrmier8hbejGNzrRQQhsMw7cH41hSAc8jKpjy3JJPmZG0FNAwU
	6kGGJWEL+VrGvUDSidDdXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se01ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:08:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8B7Vn8040113;
	Sat, 8 Nov 2025 17:08:56 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va6pstt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mOQyd6YVvMjo1wpYpoivODSda9bf9jaM7pcqvdAPIBg0EHufIuiOIOpi1TtQoXXpwMAf53DrRpp9yF5FQlrp9pb1kiCfOXXdlBZuSLBqHiv2qdWZ21tDLZuhrH60gv+fgvj6WVV3LfOAqBQPhWEuZD9FhF8UyDHcbEGuY2bPfGEUQ54hWhvz5KtyyVMBgw5hGlGjGUtGlR+xLyvnIc4IrbPsIOkinexe4AOQe5Rsq6MXCc7sQ3rKxiOHU0rdaoW2jWof1HzaDfBi4jH3VeRfln13zWcttM48kgPwPEDYzKk7zAujKC0mCq9XI6sJSliSlPkLbrReSQUV1j+K0tu6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IS+WCD4gx0ikSahGAzl3Mo97b95pzUAhU1bCbk4hhuM=;
 b=NF8ifJ2UIHAAhs1XIpOWFpnKC0JOiRkDjuc+Yn9+X24wC71S9jFkXrucAPlPOv7PVr3787URUYnkX7vUBvUciOsE39RURkEBivsO6XqQKj2sm2eAoqyp6ENTFeC2b1FrBbrh1ZMPXWTo8nnsjs9Cu0dTWTCobvpN1btXfKM42UDHYALOdejbwjt9c26d7i8M9b6lIxLtAH0/456vCsOzJ/FOPIvh+ukYtrdBvFl5jdnkJKeA9imOAdqVbCrH6EUipfPh1C4GNDD3I/ABxhkyXejqVBj8dn7jX2QVm0j53PSJJmHCATU3Hd9muqRqxjtpPXleUR+/VSk2sPAGFhdZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IS+WCD4gx0ikSahGAzl3Mo97b95pzUAhU1bCbk4hhuM=;
 b=q+LQvOt3c5TD5SZw41jMBrh7iqT1G3D4/i3nqomTS7ZZZGNev/zw8tdCETsRjQ4N3OC4HsY+SgNqmNmGpW0uDVhz4/WUa83nH0ePGRZyUKwkDwNOReXj3zMYcWzkmW1R1UGRNF2BDlEEl5bqQh/EJ2YiESmG3XIfEgFBSjc0ZCU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF04D2D7FA7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::785) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 17:08:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Sat, 8 Nov 2025
 17:08:51 +0000
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
Subject: [PATCH v2 01/16] mm: correctly handle UFFD PTE markers
Date: Sat,  8 Nov 2025 17:08:15 +0000
Message-ID: <0b50fd4b1d3241d0965e6b969fb49bcc14704d9b.1762621568.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF04D2D7FA7:EE_
X-MS-Office365-Filtering-Correlation-Id: 48973cbb-7c70-4736-cfce-08de1ee97d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lf+ePcQWWISnPxJyUB/BgKrc/6AlgMwjUQ4DKA3bQZKF2hV2ZtsL+DAzzw6Q?=
 =?us-ascii?Q?VAMb98BERk6YkO8JoPyudh8L/b9rqKDvPZwSloiEITCethul08Kl3RBOWUN/?=
 =?us-ascii?Q?FfgygWbneo8OYpOMufiU7FEo+B6ZDWmXqGaEEUq9RtgBOuUTYw1egyW0bQwM?=
 =?us-ascii?Q?i6Z67Qga9/Sg10bGlI+PgYHzZ+Qp6EHOAAecJCnWD/TEzd8UikC1QGLRvfg2?=
 =?us-ascii?Q?w47w+jkcn97La2nqaW+ydwrktKzkMrzVwuCOgRa/02YIr3U8a9nHkiaypGGR?=
 =?us-ascii?Q?J5fM8JI4top+VmiOLHrIIM3XJv2GAqAaBrORHith8D95w6NftIMYFkUt+LgT?=
 =?us-ascii?Q?7KXWYeHLz33c8loiQJcoI+18K6OSktA8upC1zdePAvUy73L0TEEl1qMR7EcY?=
 =?us-ascii?Q?IVuBxTan9FGAm2libKn7fKDnanhQePHYB569VYQWK6kLqeL3RywKuUbFRxvr?=
 =?us-ascii?Q?zwQDA/D90zaLGRlsu3y3u06p0V92Luo36hyUMpFKb/GFXprtOy9pHaci9TX5?=
 =?us-ascii?Q?L1l9Gnqm7IPN0e7UkbZkxViRubUhIxh/qaL5eM/MjaHwbJMBKwW8lUQNMfTH?=
 =?us-ascii?Q?HLu+bY/hkkAbPPribPBillSHc4Ua4/GRTm/JWqR/maOiZ891RjM0dcSUZ+mA?=
 =?us-ascii?Q?E7SX3gEdUxUoAeUkckAI3W6/g4OyumnIzSDWW4mfYKn/llLM5wPd22RFaK+4?=
 =?us-ascii?Q?JHIoemPnQwsViLJkgq/8OblGI6Hcze28HgS3HaqN+5GPn57zGInmD7J3uMNM?=
 =?us-ascii?Q?ACLsuEyaE6CdpWSI3VHFgX8ORzGr10PMOYKdVaLvM8inA/YUt8/BllBzbEcu?=
 =?us-ascii?Q?017Z3Kk9BoaKceVkCzEPx5xrDZsNBcniXNCyI3lNcOVwSmkQcBPOxWZcYXU6?=
 =?us-ascii?Q?c/mdMIof7wc7F7w8LemORRHNIZ6HWcYFdvRoVOT4Xp/FKzjKQmx1u+bD4UiP?=
 =?us-ascii?Q?BswPJZE9y4j+kQj14qN21a03ONmDJZP6FTyArMStTykvPS3C7vjq1RJtrr6c?=
 =?us-ascii?Q?Re+qmYmNo73bP4Nwf99eN9KM2gQ5Qgt7NkaMaH5p4nIYxd0zCIhZxEIS+9RO?=
 =?us-ascii?Q?inJpiSz0z4+kWuGtotCZwYiuG+nmDXv3DlirduLDgAFA1hy65JH71EiWpXQp?=
 =?us-ascii?Q?TkMvyWbvPVQRr21N8pEulmJCarDN1tN3pNzzkGDQKLKENFzlOCmh2Q2RdGcM?=
 =?us-ascii?Q?3VX0Acg+MKS4HUhfOm46BgNYJJ0FLDAZRmyr38VUz2Y5+X/59742fs78bqVF?=
 =?us-ascii?Q?ng6UPjg3V4+E7rkfojY7r7CT2cZbRclS9BS2KjV461ujtxHZ0651fYWSquHt?=
 =?us-ascii?Q?oNOoqLnhLJEHbDSoWt3GT7SlY1CNkePeZd3U/dSsLRwaOOnd8eOlsKmh2Juv?=
 =?us-ascii?Q?CbHgaL2no2uRsccSR126gJBamBANi2ikKUyYVqlPyE1QNgbbcNs5OZTHZ/4g?=
 =?us-ascii?Q?R/owuygmV/FNXC88D2rgS7pkja+5RqU7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ugzTvX7vzE9PRab0ZWhgrrOTcluW4k89zTrTxPKIDcRCqlz9twOETRzTR6a?=
 =?us-ascii?Q?alu9sKIGV3wZihEw9fuKnbau2y3hFPrk4sILRhRMZho1GRYHPVA+Nf2LEKrM?=
 =?us-ascii?Q?b7AFGYikvUPL7kEkISda3A9XocCFMr9YWG563XEG/tZOkSpHwRrYXzs+5AFR?=
 =?us-ascii?Q?wSIkopvY86ED8Qosr4IHgbu8yfKq/osc/0RRE2DOO8X2kQzKSTJh6/xvRywl?=
 =?us-ascii?Q?yvQgiL2QAiyIEdARbGIbrgnbb/O4Js4HdiZqvQ5ncB8lsL26DLCXQRBv6bQD?=
 =?us-ascii?Q?Spu9u5IHMW2bUxBpxKBcq8qmZnveT94591cdBFt7E6c/U/iTtLwq4u2SDoZj?=
 =?us-ascii?Q?7cnlquBE/sKlotzAC4PccKstJtYqkoZnfSCMeTQIzzOmYauBEm7GsWx586Ga?=
 =?us-ascii?Q?40WnkZB8d0EIH+UtIXvYzrVNGQN8wXpiEc7w0tmbUF2bVGJDs7gOsAhFutLL?=
 =?us-ascii?Q?qSShJb1HAx9P3MJFe2cEK1FvHNDlAq+sjttS6Sy9kB3NNWJu+uR19rsO5zqU?=
 =?us-ascii?Q?84/pBXN1rs4WAzba6lETQSkAlZaYz/wg13Iu1/9kWE8y+l0jiaUAPZfObLg3?=
 =?us-ascii?Q?wv8b9L5b8/eg3TgsLBlnevOBzm20dwaa8v2Od8mmnLsTTEyjhEUxvzkzz5eV?=
 =?us-ascii?Q?m4mqwxPRablRz+lKh6q8kVDr8f9Op03YhwEuFgyrWSL95ZiPoRjln5x+A1gy?=
 =?us-ascii?Q?25/hfUoVnlSq46roqPMi7llAGEdfEi1NUcrq/umkKkOsVfoknJh5/lncOO3v?=
 =?us-ascii?Q?Yqn/sidAoEIkr8hpjXcwx+WkGr/yPh6jKeDtjEqpOwLpWRvGf7uLDbKF/YRr?=
 =?us-ascii?Q?gudLrwetBHg3qdgu9SyalL03S5PH0jglsoVJa3G3PJz1N74Oz9UhRZeKdrFx?=
 =?us-ascii?Q?hQsr9WfQI6ihdbQfqL573gZfRDQaBVRk6kNCktW9lLM8EKneiydjxe+pWS5x?=
 =?us-ascii?Q?M62XKHHpx/xDMMN4It031UsR6cMJigXG9p5AzsI+lNTg9uUKUC+gshXF2gXW?=
 =?us-ascii?Q?bdsePu+ReC111jZyFGoOb3vugg8RJ8XXoIFsHHOKqySQ28U4BshNfnkchM2g?=
 =?us-ascii?Q?2uFnTxOn+XbKSdByWQH4W01NPpujlEWRHHbrUqOP7silxSY0OYX/XnmUKVta?=
 =?us-ascii?Q?vSzJcZ6ud6fzvyiE9UuMmqsI2mhkIPUU/3g2IMOjy1SpqmBXGLxeVZfAiW9I?=
 =?us-ascii?Q?ZMtC1G2lXpCzKUMKQ8BU0pix7XkSntdFLf5bce+NnVXKq79+nRH5OcwRwAAC?=
 =?us-ascii?Q?mmztfm9Gtb/k5UEReXJg8NTCt5q9J1EOAeLxMblPdS88UKmBtQPV4Cef2AV2?=
 =?us-ascii?Q?wmJJV/63SOsrPIhiaiIsoSptmrZcpNncWpA85KUJF0m668hqmsyRARMVe1+i?=
 =?us-ascii?Q?SM2Veir5V5ve8ThJ3s4YfoKIGBXmC4C29JKc9Yc7E8shKgJ6LO0KlK2F0rGZ?=
 =?us-ascii?Q?JGVIQfzO3qXe8/W9kdZpnSmHX89UPzjqmLCz4vmgFxEhi2D+IHdlOO9IQw0a?=
 =?us-ascii?Q?v15rvLU2JeCxbQKgVhgjXuKIsVb6JfpWenzAV19qMI2lK5iAuhUtX4YFURkd?=
 =?us-ascii?Q?EJ4FUKmQyOzVY9bJKFu+2j43zbnEWcD6X4MIi3NZUcnfGEUQI2SLFHhuNEc4?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pa+vvP9LRliD2zGI1VRvNwTYnnVfsWWA1Zu8pBZhPvF1m4NFwqjM9+/61n6aC/7D9/NoU+MUxWjgnH6k7F8EGf1IFd+Xgvez7UUCyugXS+u7KbB6NUxe+QmH0r/U/TBnRRV7gTBinsdtsXttOK/szsS9hEv3O6TEBoYT+PQ9SSDpUCByhT87dXnkIbQNLLKFuVWB55qXzQgCCamfi5CVnUUuXYNtVGBRPGbOjhpEsZaJOdg2lu86E0UmolSMquTIWxCR9iEDjDcazPeHL61gltJUOnJMgL2ygOaUBHRjlVSz47qt/BnAZ8RrLAPXnpDwEReb9ho0Yg1KyJtnPZXUFpe2PHmb0IgM1Ew0pUmhqNYqcOO241GSyh7jaCdk68Gj52qu2eoJ7hLJIeixdTpBXgFF0bZ5RFboGVaSSh3deuGGg5CfMhHOqhNYyh1fZv7XqqPxvyP/UHDJjxRTIJmeN1Ar4JXlaWMO/cCsrMvZ0Xeo7Z60ATHURZKIbVPZ36B6UQM1ZKxx33plr1q37bc8oY0mQuiutM/WbXtbrdJp4ImwzUNii19Xuu974uq9OwWRsVZKeoq0qmT04D/wuSqF+y0zCFqzKZINBA+ptvEy/WQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48973cbb-7c70-4736-cfce-08de1ee97d3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:08:51.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKzPMqksAhrYBcO5LTPcbnhnwATJJa8ncPGNAEcMorvx/Qlks3X+ZKouQ0wvgUF6RBSuEtaW8nnbbXW5s6o7UBnZGeKftSbRtwoRBs0ah1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF04D2D7FA7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080138
X-Proofpoint-GUID: 0hRw9a0T6CAuI5o18NW9Yz8cy-_Z-3l5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfX0BXb6ryUjDDu
 Qx1E6tkd0oLHf8buBY2SKlsjRBN6eYfKgv2ihGlMkyw9qYcQP++Pnk7iibX6giNkuSoM6ht7/2d
 tnJ0vjeKKebFeDPaDERucl9byBW2u28lCNoIjflKuigLPWJpH2vPin/5R8meXHwr8HJtJxyup/N
 4/WFj/TdqIZzYQ6q7FDHtPpwk8KSZazI0/R1Ty3Gyk74++9kMOx1WxO4kkVSXDp8dK0MYE/fDOv
 vf9z5/PIqQlDRehGqtG2g6CBGBXMbU6xjijaapvOCmJ1A63rE3DgOJ1wSv/FazsUP7iWvoJTNWP
 w//62uv69MMl3pG5A8iYg7JODOySrXasEsvNNnPCTi+peF3DoArkrIojxkoLdxtBhyMXAg939p1
 FjKeC5jRrYcDXUlzk84afQN96YIfTg==
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f7929 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=K7pD0KWnulOJboH6qJQA:9
X-Proofpoint-ORIG-GUID: 0hRw9a0T6CAuI5o18NW9Yz8cy-_Z-3l5
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D1B541C0006
X-Stat-Signature: igtidzmc39c8xub6tgdc3mb6caoj66wd
X-Rspam-User: 
X-HE-Tag: 1762622068-119741
X-HE-Meta: U2FsdGVkX1/n/M7rhwVtKrtLIzaEkTlKAzshjC26B1ZUki0UEuCbh9USl48yMN/l2pje+WiMTLW54g1zZobHHCjKWXSzIP8TeN0LqgydWsIuyMYstF3ZXKj7NefJZLomI3qoCCNW9HGwqfkrZ0KR80ZWtl+TTZ6rd9Sb+/D8YvZwpkiVPeFfJuRuINbCda7oTOpux941XcjzKdvdDxupRhv3MpvXeMMuK+AGqu3od1zc0NFGMk0CO5zEL0Q6Cll0c8KUvzHX9nlzFWwymKj+V9jU2WF78P4pRBACi18hDII2x7UHEa84NbPNbSF52CAU0N6zDDL8vHLZVNRelZ0PWw50ioY/KRRY8TaiPJQiqb0dMvvVfwt3zRRPwEt5CjoI2OUJ8CpnEZTYEMGFbA0KjXBOshsuSW/Uh/GdPKpn06qOpQjTx0qzql3OK4xYDFhCLgT1mWnBVHZR1xdZC4NJXZYENNf9Trc8L7ArI6buNWrNq6cN474nkmIkucoJlXtHa+b9TjPx93kbdYIcCv8/n6wgA2wMDxRMKUiehNvip8a/YmsoBXJ0Sun9WuBzDuva2mKNsM4dbgKAddzhDc9OXx/4UKpXsRqaYfwxm9TELvwaJexxH1l9RGJE7pXrcWJ93JbN728tqALXIM5F5uutAY+vXy/V/mHiGESfQMRK2XGT4JI6lS7aHmj/3XgWICaiwg9mHZWiqZV9z/MpLP/8DabiT5x33sMxbhj+KcWBd+iYl4icYJCjIsEGmipdZencD8yajfupNuJY0LUIQMQayJIQxjufaEBV0v26k2FtWtlpjlR1KalZdu0ynESzZsUYA5QuJuuVW8vXvp09s7zgDTK81Yd40XkfLs5z1V1q2zWIS598rhnYbCS7Z+6xVU6AR4g2behzZxJHJRF7vRDacTq4XQSA3Z3y5lykn8JGEHQmIVsQ9iGWHgmEDyVe2qIqogHfcuVD6BghwMWLJyl
 Cqou0uof
 lWA9BySIIuSecg+0yZt9sZKIuPI7r7dGhyAhyx1pF50yi66y8sa1lIRRixRmOjBmbt3rK3ohAj1zmxwd14aeT7zDY9OFAIJjLmSAto7GBoo5OT8/BWrT0fR2i/CZ7kEWOiTHMGmiIHOm3JerrTBCM0Fo4tIqIsSkwX1Fukv0aD2dYeRNtLvE7zNx/5mSz+Tms72WnliSUN00Bd95GOy56f5yfaJqnKXDqnvzrXeQdVAIDvx9lcIxC/y9vvg1k6T8Aj/OmELdu8lBKKWT6qG1NE0b+KuiNFEZk+Ik/ewM2pYRt9hF8zozKiqVe8IdkYLF7FjBecisQDzEoAtR2HTx4jgHc/cLNy1hE7qJype4TvT4l1lb71Nxc/TuYwta2ELT22Dbhooc9qHwyGVbtdK2Z+6rnrr+Uq+IFeekDgKcAXvYoqtA6Pfz0d126D9lss2F3ziNc5VYo0A4B79Kalt8py9nECJp7P6NHWygDtwCdeNPSQsJf4fyEWiBVpClT5Qv55W9l+bMtcq8IJMP4hAeZBvajcSFyaJ48szm9D5IW70jNf1CJK7/rDleoVOTGTHgepf9qn66dclOoSBtdwNqzAd8+nshofRUHztoPTBhmpUYPD9KqXHGUEScWPKj9sqT5hlfl7M2eMh/Kkukr5Ui+zICSh5+qpzl4KpDaM5rDbfxFZqWfKoSOdKf1VsvanEmTN9pcHSYssbFlxRKjUOJlO5Xn3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PTE markers were previously only concerned with UFFD-specific logic - that
is, PTE entries with the UFFD WP marker set or those marked via
UFFDIO_POISON.

However since the introduction of guard markers in commit
 7c53dfbdb024 ("mm: add PTE_MARKER_GUARD PTE marker"), this has no longer
 been the case.

Issues have been avoided as guard regions are not permitted in conjunction
with UFFD, but it still leaves very confusing logic in place, most notably
the misleading and poorly named pte_none_mostly() and
huge_pte_none_mostly().

This predicate returns true for PTE entries that ought to be treated as
none, but only in certain circumstances, and on the assumption we are
dealing with H/W poison markers or UFFD WP markers.

This patch removes these functions and makes each invocation of these
functions instead explicitly check what it needs to check.

As part of this effort it introduces is_uffd_pte_marker() to explicitly
determine if a marker in fact is used as part of UFFD or not.

In the HMM logic we note that the only time we would need to check for a
fault is in the case of a UFFD WP marker, otherwise we simply encounter a
fault error (VM_FAULT_HWPOISON for H/W poisoned marker, VM_FAULT_SIGSEGV
for a guard marker), so only check for the UFFD WP case.

While we're here we also refactor code to make it easier to understand.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/userfaultfd.c              | 83 +++++++++++++++++++----------------
 include/asm-generic/hugetlb.h |  8 ----
 include/linux/swapops.h       | 18 --------
 include/linux/userfaultfd_k.h | 21 +++++++++
 mm/hmm.c                      |  2 +-
 mm/hugetlb.c                  | 47 ++++++++++----------
 mm/mincore.c                  | 17 +++++--
 mm/userfaultfd.c              | 27 +++++++-----
 8 files changed, 123 insertions(+), 100 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 54c6cc7fe9c6..04c66b5001d5 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -233,40 +233,46 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	pte_t *ptep, pte;
-	bool ret = true;
 
 	assert_fault_locked(vmf);
 
 	ptep = hugetlb_walk(vma, vmf->address, vma_mmu_pagesize(vma));
 	if (!ptep)
-		goto out;
+		return true;
 
-	ret = false;
 	pte = huge_ptep_get(vma->vm_mm, vmf->address, ptep);
 
 	/*
 	 * Lockless access: we're in a wait_event so it's ok if it
-	 * changes under us.  PTE markers should be handled the same as none
-	 * ptes here.
+	 * changes under us.
 	 */
-	if (huge_pte_none_mostly(pte))
-		ret = true;
+
+	/* If missing entry, wait for handler. */
+	if (huge_pte_none(pte))
+		return true;
+	/* UFFD PTE markers require handling. */
+	if (is_uffd_pte_marker(pte))
+		return true;
+	/* If VMA has UFFD WP faults enabled and WP fault, wait for handler. */
 	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
-		ret = true;
-out:
-	return ret;
+		return true;
+
+	/* Otherwise, if entry isn't present, let fault handler deal with it. */
+	return false;
 }
 #else
 static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 					      struct vm_fault *vmf,
 					      unsigned long reason)
 {
-	return false;	/* should never get here */
+	/* Should never get here. */
+	VM_WARN_ON_ONCE(1);
+	return false;
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
 /*
- * Verify the pagetables are still not ok after having reigstered into
+ * Verify the pagetables are still not ok after having registered into
  * the fault_pending_wqh to avoid userland having to UFFDIO_WAKE any
  * userfault that has already been resolved, if userfaultfd_read_iter and
  * UFFDIO_COPY|ZEROPAGE are being run simultaneously on two different
@@ -284,53 +290,55 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pte_t ptent;
-	bool ret = true;
+	bool ret;
 
 	assert_fault_locked(vmf);
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
-		goto out;
+		return true;
 	p4d = p4d_offset(pgd, address);
 	if (!p4d_present(*p4d))
-		goto out;
+		return true;
 	pud = pud_offset(p4d, address);
 	if (!pud_present(*pud))
-		goto out;
+		return true;
 	pmd = pmd_offset(pud, address);
 again:
 	_pmd = pmdp_get_lockless(pmd);
 	if (pmd_none(_pmd))
-		goto out;
+		return true;
 
-	ret = false;
 	if (!pmd_present(_pmd))
-		goto out;
+		return false;
 
-	if (pmd_trans_huge(_pmd)) {
-		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
-			ret = true;
-		goto out;
-	}
+	if (pmd_trans_huge(_pmd))
+		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
 
 	pte = pte_offset_map(pmd, address);
-	if (!pte) {
-		ret = true;
+	if (!pte)
 		goto again;
-	}
+
 	/*
 	 * Lockless access: we're in a wait_event so it's ok if it
-	 * changes under us.  PTE markers should be handled the same as none
-	 * ptes here.
+	 * changes under us.
 	 */
 	ptent = ptep_get(pte);
-	if (pte_none_mostly(ptent))
-		ret = true;
+
+	ret = true;
+	/* If missing entry, wait for handler. */
+	if (pte_none(ptent))
+		goto out;
+	/* UFFD PTE markers require handling. */
+	if (is_uffd_pte_marker(ptent))
+		goto out;
+	/* If VMA has UFFD WP faults enabled and WP fault, wait for handler. */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
-		ret = true;
-	pte_unmap(pte);
+		goto out;
 
+	ret = false;
 out:
+	pte_unmap(pte);
 	return ret;
 }
 
@@ -490,12 +498,13 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	set_current_state(blocking_state);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
-	if (!is_vm_hugetlb_page(vma))
-		must_wait = userfaultfd_must_wait(ctx, vmf, reason);
-	else
+	if (is_vm_hugetlb_page(vma)) {
 		must_wait = userfaultfd_huge_must_wait(ctx, vmf, reason);
-	if (is_vm_hugetlb_page(vma))
 		hugetlb_vma_unlock_read(vma);
+	} else {
+		must_wait = userfaultfd_must_wait(ctx, vmf, reason);
+	}
+
 	release_fault_lock(vmf);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index dcb8727f2b82..e1a2e1b7c8e7 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -97,14 +97,6 @@ static inline int huge_pte_none(pte_t pte)
 }
 #endif
 
-/* Please refer to comments above pte_none_mostly() for the usage */
-#ifndef __HAVE_ARCH_HUGE_PTE_NONE_MOSTLY
-static inline int huge_pte_none_mostly(pte_t pte)
-{
-	return huge_pte_none(pte) || is_pte_marker(pte);
-}
-#endif
-
 #ifndef __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep)
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 2687928a8146..d1f665935cfc 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -469,24 +469,6 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
 		(pte_marker_get(entry) & PTE_MARKER_GUARD);
 }
 
-/*
- * This is a special version to check pte_none() just to cover the case when
- * the pte is a pte marker.  It existed because in many cases the pte marker
- * should be seen as a none pte; it's just that we have stored some information
- * onto the none pte so it becomes not-none any more.
- *
- * It should be used when the pte is file-backed, ram-based and backing
- * userspace pages, like shmem.  It is not needed upon pgtables that do not
- * support pte markers at all.  For example, it's not needed on anonymous
- * memory, kernel-only memory (including when the system is during-boot),
- * non-ram based generic file-system.  It's fine to be used even there, but the
- * extra pte marker check will be pure overhead.
- */
-static inline int pte_none_mostly(pte_t pte)
-{
-	return pte_none(pte) || is_pte_marker(pte);
-}
-
 static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
 {
 	struct page *p = pfn_to_page(swp_offset_pfn(entry));
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..da0b4fcc566f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -479,4 +479,25 @@ static inline bool pte_swp_uffd_wp_any(pte_t pte)
 	return false;
 }
 
+
+static inline bool is_uffd_pte_marker(pte_t pte)
+{
+	swp_entry_t entry;
+
+	if (pte_present(pte))
+		return false;
+
+	entry = pte_to_swp_entry(pte);
+	if (!is_pte_marker_entry(entry))
+		return false;
+
+	/* UFFD WP, poisoned swap entries are UFFD handled. */
+	if (pte_marker_entry_uffd_wp(entry))
+		return true;
+	if (is_poisoned_swp_entry(entry))
+		return true;
+
+	return false;
+}
+
 #endif /* _LINUX_USERFAULTFD_K_H */
diff --git a/mm/hmm.c b/mm/hmm.c
index a56081d67ad6..43d4a91035ff 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -244,7 +244,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	uint64_t pfn_req_flags = *hmm_pfn;
 	uint64_t new_pfn_flags = 0;
 
-	if (pte_none_mostly(pte)) {
+	if (pte_none(pte) || pte_marker_uffd_wp(pte)) {
 		required_fault =
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
 		if (required_fault)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1ea459723cce..01c784547d1e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6743,29 +6743,28 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	vmf.orig_pte = huge_ptep_get(mm, vmf.address, vmf.pte);
-	if (huge_pte_none_mostly(vmf.orig_pte)) {
-		if (is_pte_marker(vmf.orig_pte)) {
-			pte_marker marker =
-				pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
-
-			if (marker & PTE_MARKER_POISONED) {
-				ret = VM_FAULT_HWPOISON_LARGE |
-				      VM_FAULT_SET_HINDEX(hstate_index(h));
-				goto out_mutex;
-			} else if (WARN_ON_ONCE(marker & PTE_MARKER_GUARD)) {
-				/* This isn't supported in hugetlb. */
-				ret = VM_FAULT_SIGSEGV;
-				goto out_mutex;
-			}
-		}
-
+	if (huge_pte_none(vmf.orig_pte))
 		/*
-		 * Other PTE markers should be handled the same way as none PTE.
-		 *
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
 		return hugetlb_no_page(mapping, &vmf);
+
+	if (is_pte_marker(vmf.orig_pte)) {
+		const pte_marker marker =
+			pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
+
+		if (marker & PTE_MARKER_POISONED) {
+			ret = VM_FAULT_HWPOISON_LARGE |
+				VM_FAULT_SET_HINDEX(hstate_index(h));
+			goto out_mutex;
+		} else if (WARN_ON_ONCE(marker & PTE_MARKER_GUARD)) {
+			/* This isn't supported in hugetlb. */
+			ret = VM_FAULT_SIGSEGV;
+			goto out_mutex;
+		}
+
+		return hugetlb_no_page(mapping, &vmf);
 	}
 
 	ret = 0;
@@ -6934,6 +6933,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	int ret = -ENOMEM;
 	struct folio *folio;
 	bool folio_in_pagecache = false;
+	pte_t dst_ptep;
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
 		ptl = huge_pte_lock(h, dst_mm, dst_pte);
@@ -7073,13 +7073,14 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	if (folio_test_hwpoison(folio))
 		goto out_release_unlock;
 
+	ret = -EEXIST;
+
+	dst_ptep = huge_ptep_get(dst_mm, dst_addr, dst_pte);
 	/*
-	 * We allow to overwrite a pte marker: consider when both MISSING|WP
-	 * registered, we firstly wr-protect a none pte which has no page cache
-	 * page backing it, then access the page.
+	 * See comment about UFFD marker overwriting in
+	 * mfill_atomic_install_pte().
 	 */
-	ret = -EEXIST;
-	if (!huge_pte_none_mostly(huge_ptep_get(dst_mm, dst_addr, dst_pte)))
+	if (!huge_pte_none(dst_ptep) && !is_uffd_pte_marker(dst_ptep))
 		goto out_release_unlock;
 
 	if (folio_in_pagecache)
diff --git a/mm/mincore.c b/mm/mincore.c
index 8ec4719370e1..151b2dbb783b 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -32,11 +32,22 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	spinlock_t *ptl;
 
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
+
 	/*
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
 	 */
-	present = pte && !huge_pte_none_mostly(huge_ptep_get(walk->mm, addr, pte));
+	if (!pte) {
+		present = 0;
+	} else {
+		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
+
+		if (huge_pte_none(ptep) || is_pte_marker(ptep))
+			present = 0;
+		else
+			present = 1;
+	}
+
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
@@ -175,8 +186,8 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		pte_t pte = ptep_get(ptep);
 
 		step = 1;
-		/* We need to do cache lookup too for pte markers */
-		if (pte_none_mostly(pte))
+		/* We need to do cache lookup too for UFFD pte markers */
+		if (pte_none(pte) || is_uffd_pte_marker(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
 		else if (pte_present(pte)) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 00122f42718c..cc4ce205bbec 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -178,6 +178,7 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	spinlock_t *ptl;
 	struct folio *folio = page_folio(page);
 	bool page_in_cache = folio_mapping(folio);
+	pte_t dst_ptep;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	_dst_pte = pte_mkdirty(_dst_pte);
@@ -199,12 +200,15 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	}
 
 	ret = -EEXIST;
+
+	dst_ptep = ptep_get(dst_pte);
+
 	/*
-	 * We allow to overwrite a pte marker: consider when both MISSING|WP
-	 * registered, we firstly wr-protect a none pte which has no page cache
-	 * page backing it, then access the page.
+	 * We are allowed to overwrite a UFFD pte marker: consider when both
+	 * MISSING|WP registered, we firstly wr-protect a none pte which has no
+	 * page cache page backing it, then access the page.
 	 */
-	if (!pte_none_mostly(ptep_get(dst_pte)))
+	if (!pte_none(dst_ptep) && !is_uffd_pte_marker(dst_ptep))
 		goto out_unlock;
 
 	if (page_in_cache) {
@@ -583,12 +587,15 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 			goto out_unlock;
 		}
 
-		if (!uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
-		    !huge_pte_none_mostly(huge_ptep_get(dst_mm, dst_addr, dst_pte))) {
-			err = -EEXIST;
-			hugetlb_vma_unlock_read(dst_vma);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			goto out_unlock;
+		if (!uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
+			const pte_t ptep = huge_ptep_get(dst_mm, dst_addr, dst_pte);
+
+			if (!huge_pte_none(ptep) && !is_uffd_pte_marker(ptep)) {
+				err = -EEXIST;
+				hugetlb_vma_unlock_read(dst_vma);
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				goto out_unlock;
+			}
 		}
 
 		err = hugetlb_mfill_atomic_pte(dst_pte, dst_vma, dst_addr,
-- 
2.51.0



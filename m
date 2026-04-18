Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D585F99C72
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943FA6B0182; Fri, 17 Apr 2026 22:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4D26B0184; Fri, 17 Apr 2026 22:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD126B0185; Fri, 17 Apr 2026 22:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 65A4D6B0182
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:45:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4BDF1A041C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:38 +0000 (UTC)
X-FDA: 84670135956.28.CA56CC4
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012061.outbound.protection.outlook.com [40.93.195.61])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F54C180003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rOENTRFb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480336; a=rsa-sha256;
	cv=pass;
	b=4o3Hu3aciagKnY1YGqDl8FwNOTarOCm1iZ7mKw+9zBPKyjx47w6oxSSACCTxOpv6zqFrNu
	8tZ08pB/kjoZIeGV51rXy9CqS9lF1jWzy9ufL81U877r7PtATvkoKlmQU6S/BQtEo+2JiN
	l4GtgGbjE5E/vCDiKdNR6RRLEPocfpM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rOENTRFb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OjsVlOTVfTNoVHZkizN1MitDHCTg2U9G7WvY/CoHZs=;
	b=HCgVsS55jut+DSGIteJu2pdNbk7m+im2+2v4wRcTeMi3Ia33IvkpQKsyPSKv2Aa/lK23aP
	SfGCNoLeekv2wIf2PkXiZQ4KaXiqjlIyZxPGcYcPq66Hg7MLINafvHLu5GvkzrZRB3z610
	+qQIYN/7+QYvKMtSv7mSu5hgXbS5Ptc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=emunM+KGelORjIpp1pMfJ4qWtduEqqIslM2KP+hjLCRrfy9+c8WhthWkOGH1Jtd6QY73w/Mf8H2epGbp1/4YHKjt4HE8oa61ffQMPUjViQMg/pwYUUbDtOubqS9oysihOHoRIgUYkRVA7CObu+dV9aVEftU9jHA3le6Ny7jV4z6L7yKJnPrBNBWtRyn4qpuc5GN35aX8UjF0LIMJ36LRRiOwR5Oxm69vg1YgY8LMlwDJ5kUdgUwsC1/I4C8Jh8RZXIDFlM7eulWH2QehXGMDC50I9GOw/pTEz++0BDiaSUo2/9pJLoVeDCHR9tkU3HZFadyWzxuu8x9/ZcJkSJghbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OjsVlOTVfTNoVHZkizN1MitDHCTg2U9G7WvY/CoHZs=;
 b=O8h1LMz197VDoqSwhUEGfMZbIwKIgltVs6UtGiqnhKYRwSxydVz57ve9TQWQYkPTJ83KrCRQeswHf00PGinvIdddAasYtM6B21NRYaGBunl+Pw8yzAuP2papnqaFTFSqDT9exr4W218EGiQsigBClwlU1y3yhAFHSqeFekbjakKyFbyflbyyUk5dOiaGMJ6ztAVMRoGMsf9ubZbbeW+016nyw2kht6bSJ7uzemBcyyG5ICUJuvqyqVxK/w+hkKfcDAqJmly3NsUE2P5dh1oDnnzAM5iY01eLDl6yXWMATmiBR5kWjPtDi+o9zfafE1da3HVJw5eIK5E7GFitMyAMvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OjsVlOTVfTNoVHZkizN1MitDHCTg2U9G7WvY/CoHZs=;
 b=rOENTRFbQE7V17gmLhd9U4vbdkFFAMSSwGwmYOfYSxIeeOy606mOPt5Vox15juV6NcRB3CaypKdeDJ+ciPfe20UtahjBrWUJ57m4gChjpALmwlrRBkQUdTR0UHw9TMeOGIwAczoTaioiUARGweLmnRnSZYA6U0ogpGOEw5PFNZ1EkErGU4A9w+TAVpv9FVVXJ3Iq4ueU1E8QHetAOAdo+YmfWv1vftLeKUDzg3msQUgfNx3TO5ZYX5sPwp5pzTKoo+FNxztQeHnPxu09EEfmLeCxd4SBVUop0WfFNOAxewRLz1BsHvSo/F4XtrRO9CYlQhXL6gAu67d0lRleNxhCiw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v3 09/12] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Fri, 17 Apr 2026 22:44:26 -0400
Message-ID: <20260418024429.4055056-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:208:23c::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: d45c6a54-bea3-4589-6a7d-08de9cf472df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Fhv8RGh1WaPSWjJsQ3H1MOP9X2Nb3kA7f8dj7culR+bmW2gWW9iIDJbofu67hSMoM1nWk26bGrrZmmTNyXtuPtdIOfZOP1HNn/qhqkmfTZFd+lxKoio8XjIbpSs3jcp7scfP0GqhQz3rM7lxYUcpHRsYlkaAgGMGT52iF1sVub/Z35JeL7rie9bfoBtAERcRnMbNemFW7oPZaQugUnKCTgQAto68O66dgatacDjjiZQpZ/l7wNZ0dvgCKbY8Ww2YnVQZCuka5d9pcr6i2j6VnXskM8OUzbbK9gCtSzFx6xwhpNXhDEjyEzGDJtXzmj5OHJArekl7yaDTkzKsoqO7G22WskBA3KHOK75BZA4in3DO1LlEeZzac3TUsIun2S2CIStKttWX9PBITUWQyk0d8zJBwV4KrQVKvp/i9Vqk/qg825ISWZ75Z4i1LHs/Ed35dgq+zNdYvTMwvOMwFAcFwRPLURU5FgoJND6B/r03o5REnfLE18Nep6DJpsNZoFAQZAhPnDDnFk1RT0dIY2clCU6MHy+hPoI9vQdXQnUQSXLVQ1CrindQA32cB6hGK5nYCTgRC54aTrwY6lz/xvrGvL99OrIbZypl4Gm5NTShoZpwlfh4eAU3pdSQWdQhc9b9K0fwIwkpc1nQLRVK5lS1IVhKAIa3RHjhIhkLJFSXOizzhDIyp9DQz/PcITjQaGXpWOLnvfh/Hx8eSzfGnP448mCQGX7algYUBJ447UnqNdI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zKARoZC9cY4zNz+TH0ZKK9M569frJHbI3dDyx1ex+DmBAX1Xb4HUXil+RgzY?=
 =?us-ascii?Q?j0bFzHTsukK+t8E+EWVoVGAgPrJdMdGTfSlpVvuFfD4HgZldiw2CxADKEkG5?=
 =?us-ascii?Q?y1gC4o4dWelVKYGRpmhndGDwVJTs8Xm2hpr7+GJslBYmSMLRzvpGAJMYYEbW?=
 =?us-ascii?Q?AqzOXo5Gl6idgq4M/25gxgOwRErt8N8kBTHgSgF8kcFJk9A7fAripJb+4udh?=
 =?us-ascii?Q?Fez3pQbBTRFBEAiNn8NFvUk7bG+sVVHkl1UkORqAs2KOf0dgQra/sn6V3vWN?=
 =?us-ascii?Q?mcCdNci8yK2VNA0uH4cUcAGJy7nSntLBnouYCBeFAqVwXjBVlZLXJLZ0dLnW?=
 =?us-ascii?Q?Z92sdn89cDVtYzbT706qQs6DGysKEYCid4qyHYqkxbTQoPoTGYrWAXsUmS9B?=
 =?us-ascii?Q?taE54T+NB6/9bPNd/JksexHgahyE70HORDWaDnT5kXI7s03kMRAyKBs6TdJU?=
 =?us-ascii?Q?cKSb8wv0h/sPW4jP2WKkuVxjEA8qbr5aZkDz0QFPCxlVk5saeJqKm/qITMhx?=
 =?us-ascii?Q?bp5y2TD6uPlFCwgHGZvoq3yApP1jYFtgECsRM4HVz7XzlQ2veE0JWSFuCta9?=
 =?us-ascii?Q?C7kKiY6WP1Ant38GYborhmltvxZNEWbU0kes3cktD+5Vhzvc+62Rdpc+wh75?=
 =?us-ascii?Q?tsYSW8hRSw5ScwMEEXHpeu9U5RKixkuh3zImUoy6/qpdcsTMa0ae/+kUonZn?=
 =?us-ascii?Q?jrzE/i3QFzcc9SYpI39FKEihOrtAnrQXjqoOEDMZnWedJvZywaoJDtNruz/l?=
 =?us-ascii?Q?8wtfO7FKdOkPW6Efhz7iQeqkQ4SnSOPUaykxl9o1Qw1NLYXfH2Bc5QiJxFNK?=
 =?us-ascii?Q?C6S5qh5f/9crxxYTYoyXe0YybHhX/0+zQ9XAMEOshhOg3KpLbysktsqC6+ti?=
 =?us-ascii?Q?/1h+LmAV/j/VnFyaEinNgeItbHwlqWBG9GvGTCc7Wa0gJ1qI1sc2JSXoyY/e?=
 =?us-ascii?Q?J1fFND/Bjn880e1Mbo6PaJfvhC2fbk1f4TKsWgYG2vrvNgWsPLobm0X//IPt?=
 =?us-ascii?Q?cFZ/cPZXTQsVuQVvwZcpqXGmhwbwVcjjK3BRhLMvykFg0ALNbeY+HRZl4Jub?=
 =?us-ascii?Q?ZgtJW42JpHQkHEhQCmsMV0M7xMGheLvjhwyZsVbO9i3ovHIZe0IEWYVV1wjK?=
 =?us-ascii?Q?XL/NteXyzx2wjrcSu30pZ4pMhtA+eAjWujSmbrFPCopWKTRyBRB8pbK69Hxo?=
 =?us-ascii?Q?REzNpNaI6+R4yLVqRe0VL9NvR/nQuVjVJenTCrxXJkgSg/iID+wCxiMIdnzn?=
 =?us-ascii?Q?TnsLTriEo4abq4znQTlyc1+Fbm67HAPUCWptTz1Z7IYL4JtbEWPg8TeVQpKM?=
 =?us-ascii?Q?uipzpaS+X60v2TPN290mVqwyj3mcs+uR2MxdoYxJs+G7yZrGbyCrFiq0OUcw?=
 =?us-ascii?Q?+jVggXP25RXRYLS7flXkJVS2NDTb3wkQeS9teuIohyI/pcTQzipusbFiwOjx?=
 =?us-ascii?Q?EHBkv/Ir16D6XX2d+crr3Y2KqZMKhpWXnWI0DFANhGrKf0vTVDocKLrOCARd?=
 =?us-ascii?Q?sJR066lgtBBPpt9UKGr9qo3f1yVrHhw4B68jI8t8GuLkb4kvv0CHlccTTjiM?=
 =?us-ascii?Q?NlxOTmzVs8skcbQdscakF6OTTl9o1PLh03XBBAtRF2k3IgmZvKL+HZHTwP/g?=
 =?us-ascii?Q?GDT79OFFmOX61guIK6MZU6UDT8MCipwwrSRDFExUUYORPqVMdBbZ02t/poNo?=
 =?us-ascii?Q?o9ke8KTy5LLBscNbVZyblYKy6Z7mqV21BVfof5L+pQmZ/ICc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45c6a54-bea3-4589-6a7d-08de9cf472df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:44.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzREsIbl6smDE9cbHNFyyY1YiCnqyYPO1VvsUENBnz8lbaM2+89vA5EOKjyu1aID
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Rspamd-Queue-Id: 2F54C180003
X-Rspamd-Server: rspam12
X-Stat-Signature: 5x8ga83wwgzficqx1f41ipyf5a46zp8y
X-Rspam-User: 
X-HE-Tag: 1776480335-346186
X-HE-Meta: U2FsdGVkX182liyz2vRNnngSigGVxueWTl+tbCPUbkpYA0UduaYw8IzdjITHUbExNV+rfx3AMNETrezkpKaddp7FT33mCwrMUWRi7anwQpWTiu5B8Far4jBuxjmV9lfknteHV+EZcnO+h5rKutvq7OJe4I+QE0cM6sTD5blFvYWvq48otSES3cMVMHP/YQXRwUxTWIjnMK2NTOGDLl/OIwhqmJ28p+OOfvoIF6T91KuWL4Pa3oJCWL7dvkHdQ0BxOLry0i811rUXcHMAMsW9u0qQcDIze80B2hv+Co6QSu0EcW95NZcxTSwDUbzY2y5+ovc34PTyTNC+57EG/9ewLDTh3Dfz95aQkJa6j3Cr7Qr9F1iTlbMdlD8TCUoHfxy8H2LGOhlMmZXq2ab+IuwmYDkEO2JgpYGCV3tfQyMAjqrpbUa6wImjA49vyMu6S2ee5N5nn49VkFAZTrVqSvd2Ug+zQTlfGimZyOmO4CITvYdR3uxm6Iy3YSWBXoDR+SIFoPq/UMhxloNvML/7Z9nk59csM9mNts637Vd6h1M6XtPN8P0QALe9JfEd74ly56kRGa2T+C4Bak6vpbXrZEx6Ff5TcZQPAmjN8VWaAdpcC0T7Bug+I8jFDOifDkJKaKTV+AV5VULHR2pg4hG4aJ8zPvBPNvJ9d8pCZ81kFp0QIEoxU2ao0r9o66UOPaV4SoBbh6JAxlEkghpzF9/V/pbdu691r7wPmh5ov6rRN87CqSBtlXKJoO8CMtkBmovpxQTLbvMUVr8W7VI2plQ3ZC9CzFSAse2CcTIFQc/ilvzXxIIrjK6JJBeC4OkX8qTFc3Im2eCe6otP1IdzxuIjL2XycmXvVmxpAfgXVEXv7Scs3YP0tXgrLbXoYo/AOvafdWYfHrVnzg9YNxAFuqhQ69oqlwLvHjZtVu2sOcv9VcnYE93mn5pCtdgoEb1cbk9Hj2MsDvKIlQ9U/klUYE6FS5N
 71Va1DvV
 sUyxfSr6qIHq1+6KOXjUx4y9NfPqwbHSYcFNwvGwzFzBWKMZ+aW7vWwg31Wz0tC43r5BWOQ0Avf+JOidZG+32t/+sb4L0sfENxKuF7F5HRcSyt5www1uBp8t47a8xKeR7ZcHIrmyRk/9GydT6lOCTD/q2cLrRAol/TfM/QdTJzjFrkmPNoZ7GP3Ottst4Tu2yiKYA72DJdBr4Y6eIYam6qUJ0IJ87nLRQ//5yWOJoQZwl0e4pMNb9MksC+6BCtpWlrrPytR/40EJZ5UWLfsBhlHza7E04bqbN6st8inmvZaaXakk1o+hopBbT06BtDsOCoblS+vTpXDkSqCavyZlZIm0rjAr6HoreOBbOjLzzaGFaLiPPi43MoMOrLVnEevpmG7L/ZuvhHZkDymwACJM5IKvzhNWhM24bpaHn7PPDXq1Wuu7FWS9hwAYjHF3pe4NFf5jaAuvw/s1rlZ5tFKl14klgTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders. try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and all
large pagecache folios can be split non uniformly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..164d6edf1b65 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -642,8 +621,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 12cc89f89afc..b58ba940be47 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.43.0



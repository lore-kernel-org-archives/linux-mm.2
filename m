Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B610C9830B
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 00:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE906B0005; Fri, 16 Jan 2026 19:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D166B0088; Fri, 16 Jan 2026 19:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029726B0089; Fri, 16 Jan 2026 19:51:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5EE96B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:51:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90BBEB7C55
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 00:51:21 +0000 (UTC)
X-FDA: 84339627162.11.91EEAAE
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id D29D2160008
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 00:51:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OqE6D9JZ;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768611078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W66yaejAh397j3QqYwp6iUJsV7DwDgrHlCmvpcDTGos=;
	b=p74crOd23BbuZTglbWwbiM2rpIJ6Zg4rAxYP19jlrtfiHhNB0PvVq60uT6vg3yU5rIbonw
	Iaja9wgP7bpZXIkURr/5z89sqeHcafE2RD6Qo/icDOh713zTJdYNCBUaLLwcjsi1r74XYc
	7NjNYdVcySHyb7ddDrnLlfC/2tSpzXU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OqE6D9JZ;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768611079; a=rsa-sha256;
	cv=pass;
	b=Z+Ye2WtH2KYbKrhoNhH2JuFfkxKVZlxWFM/RAPdA6MWWwhmEM0qnUd55jdCVLzCXamiky2
	1qZzAxw7DQPJ+V6nqcAKYk5AmfTbRXQE8RKBZ/ZcCMpk9Y7YujV0doF8w3NfTbvBe3HkQz
	Wnab8PA5XliWoA5RDCJD3FiZf4gm/Bc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bc+F7ELt/H8geqRYBwDdzdzKkIs6Q5BSbNCDcX0WYbbAO3rQAsHs2QzqUoy8H877HmJdqiq1kFLeGJEYZPpg1mXMaK6iz5lTmCWQYZpTDdJZ8RyN7mYuK+LOlAcOz+5XFwcopR6dn3EoCcoaRLNrpb+r+XyL3M8T1s1DapfOckiwQ57YfJtCgruXv6PSQomEtuz3hRm6l2bCbE2jsoF9k+67hGhoYn1o2hn3wsv1RS94VD2ZpD0R+U1oYdyMo9iHH6CnoGQ66y704HaCRbDFEGTxC0vVQgF8RTgsf/WENRKrk4iIZEFYvf/SEC2CgejTieqNZTN1JJiSDlm5FIS9dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W66yaejAh397j3QqYwp6iUJsV7DwDgrHlCmvpcDTGos=;
 b=WMjt9nXEE4zqgaHwn3+Ff4uUcJQO7EiEP1mk/VguEUEC0O2zpyQhcZSttz9/0uesrzM1yfwR+aMtdcgsMRO1KTv2db+80hYFe9ouaalHwPZx5PLGt+ua4MNl7KWdhyHeDImACGhGoAx7PXUlK/GqypmVLuPUH5E5Y116DDbpUgdZpBq8t5L7Gx9GTmCGWD4T4A4MYESKUTrS35NcyOj1JFGJVrbh2hKWg+r03RFv84+UJsYYJEsQzFuOmQwc0ZuUhP0S5LvH7VusfJEDhDI4qtTKf/Uu9/Y8WcdBErT4qg//tASa5Zgix2mCouaYhU7kea/KbR7let4rNKcySq7N1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W66yaejAh397j3QqYwp6iUJsV7DwDgrHlCmvpcDTGos=;
 b=OqE6D9JZEhvamRV6HmqKDvlWkCW/fads+90lPp+p98lkLotDzfbflBZiHgnQ13htYuXuVHNtpUXwG8bBJ6mwsSCWGH4Bv1t4u6OdBV00mqmNuWfiopANmHf3HTCYPB/PqtH66fD454H1q8qE7nVULg1XHLdZ7F5ZwuiqZ2pD8UI5s3QSrAco39ioXsHNzz38ApaIqk8cO5Q7Voe2it766x7tE+AkpZ0IMMIXuHF7PW6b3O3x8qKaaBqtdRFTUWctGTbyBzwbs2Jxi4Y6CiHpSsxdWGhX0OBL3eAKrbfspps1oG9zzZGEtSa+1voBFUdFHtAmBEOqhUTkfKAZtd4Bcg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB9496.namprd12.prod.outlook.com (2603:10b6:610:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Sat, 17 Jan
 2026 00:51:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.005; Sat, 17 Jan 2026
 00:51:15 +0000
Date: Fri, 16 Jan 2026 20:51:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Zi Yan <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
	adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Balbir Singh <balbirs@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <20260117005114.GC1134360@nvidia.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <20260116174947.GA1134434@nvidia.com>
 <8006ea5f-8845-436a-a2d7-125399428762@suse.cz>
 <aWqgHTZ5hjlRvlKU@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWqgHTZ5hjlRvlKU@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: MN2PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:c0::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB9496:EE_
X-MS-Office365-Filtering-Correlation-Id: e706ca1e-c71f-4368-6c72-08de55628451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?knZlbIOdpFig7Vxzg6uMXuk4x3Ya5wp8MA0uqq0It8GludRA0O0NRM9hzFwf?=
 =?us-ascii?Q?Uj5Sww3zt1yhCsWZWWduvUy0rd33vf8mhvKRPDohmT21IqCgmdUGSZqiCtj1?=
 =?us-ascii?Q?0s+k86lBoXCcdkrTWU3ezcR9L8cOMcWfAHT5QmbAeWfce+1HJPu4GGPwjWxt?=
 =?us-ascii?Q?gCTVJXTGj88WmppBBqaZs11wnsE7tWDAEoiZp+CD9vhuwnyHxt5uoXIyYRfm?=
 =?us-ascii?Q?MoplwusNudkgoDi5aGYz53jKaDGnZW2zBx1dX8W8/jKJpDJJLvjwJ6kMB37L?=
 =?us-ascii?Q?zqbpkdhT/KSA7eJD9bnhr/ehCLBb0/K5OHu+IIZ0rNWGZ5CIZa0svAMiRHxz?=
 =?us-ascii?Q?rmTfcsbTK8rDyWGdK4Azp0l2fKNsqwFSXnPTC8a8n+xNMDcwAXHmAE1MEcr7?=
 =?us-ascii?Q?9Ug9zTH1EACewRsr6WD/YKOutHsNF+nm1/o+2aK59+mJFAurivzhSLSdU7hk?=
 =?us-ascii?Q?nRLyk5KOOpA+1xctRsSOGavfs9Hh1RnXjPg5RRGYp6dZvTgwwWZLpezKwe+J?=
 =?us-ascii?Q?gifeM7AiagyZRbOvo/xHduNvjGRhobew4Fbzj9xsbA68OP8QgEk96xTyvZYM?=
 =?us-ascii?Q?952J2aOmqMkwoMAAqiWeOH0+MK7iCS9EJ0nuYV5JOYgAY93YFMrLiVFkd0IS?=
 =?us-ascii?Q?KNHwJjXTt3tUAx/LMiwhxyVnC+j5vqchPEqyJdZ6whT7h2OOJLIXRPOiLGUf?=
 =?us-ascii?Q?mT7HHQO5VR0r9NLpcw5eJIYFoq7+od7I/ugi/2Jxn6kfOxoTUbZV3WEkfrsX?=
 =?us-ascii?Q?wu+/j0TzJLdUEIYfI8H4eTlh3l9gkIxcHGucz0ALH1JNce53xB1ISkL+T0Pz?=
 =?us-ascii?Q?oSp39Yo8JCIuGZdSwbX47SE1A0Kb8BAJBooi2IKc9NPJUcUdxZ3dUe2+Lc6O?=
 =?us-ascii?Q?aFS14NE2jB1Vm5T8RqZcHeaOHDNB8RZomGq8hEZ7GGvYXMgfhzEm6GjQvyMg?=
 =?us-ascii?Q?CGoUnsRs8WHyXfoJ107W9z3axn7myj5F8RJ/J7QndC6s1nxfCFtLcHEXHOGY?=
 =?us-ascii?Q?eVr1eCgqMEDyVT5K8hetFFIKo1jiyPkkLN4jCezEgd7E9s5NJwYRgRoWYMjy?=
 =?us-ascii?Q?ewrBJv/CGUrK4gnXGpC3Djs8zX6IpjZiEtnke/c2FeYejjICbnAnDwFKJ4p1?=
 =?us-ascii?Q?ZG7NNvjloNEZcDA3EZJ+0r3kgEuuLBZwXH8dAqzJzjW7YfUA9dJQ2DCKHn+2?=
 =?us-ascii?Q?XiFJANCMvNfUtF87f/2IrV6urZLMIaUH1z1V1S13xQGasEfXPpzJcNLYgfuG?=
 =?us-ascii?Q?FLxTmMinONsRbWpH0InWIoYod9adyIyjdccwtbpOZrdqH9FMDLGKhSnRNDO0?=
 =?us-ascii?Q?KgRJowTMRbWZ7EyS59k4/QYZ/r8/XyH4WRsS0P4f+YbLfty0dEvB5JFXSABs?=
 =?us-ascii?Q?mf4lnRMwUM33Lk7+65wBgVirGokrR/yBMzKosPWniAT310qHR4ld91vq+pvX?=
 =?us-ascii?Q?FJ8q4r12jRSeEwYTSYlkWscXYxb/S+0+YD9KX04doH9+hcEKeF8+O1z9m89j?=
 =?us-ascii?Q?FRZr6NGsoEp+ZF5WwPCX/A7eaxpVJ8fyEGcRoycPGyWxFJOmEKo9ATJjj1Nb?=
 =?us-ascii?Q?ZyBMPXGhDohpLY4XGgU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wgVJoP8omj1bB6pBwLBQqI+Wv8qHMoMJspuj9UXrKatsrwTSodNk3f/HBg2E?=
 =?us-ascii?Q?N61nHiCTej5dgchW5+xPPNtskYg0IebrViO4hxO29xIsZPgbm8AFKh0rbcWu?=
 =?us-ascii?Q?T+QKmiPGM19r1iNbPhBex+Xlg4B7oIgDqTlNc6hF7US42QCBXB0HPJ2iItLe?=
 =?us-ascii?Q?LJFTgJfivC7i+D6trtixvQldbqSAmt/R+VIw5q2uDaFbIwqOf2RCmSDHzELs?=
 =?us-ascii?Q?1IWhd4+bQDTmsor05w7bYiocAJQI4d9LghT7qsFYjEVaVoEHz841djMC21xH?=
 =?us-ascii?Q?cJ0bVWu23DnYR59WOIpz1GvKoBVBZGwGjOIo/nEj4YQWaWrBktHpRDUekZrL?=
 =?us-ascii?Q?kCSXUDthUfnte5A41ghIA8iqjrwXWJufhKhwMMmwmryTf/VyANcdFjXMldE+?=
 =?us-ascii?Q?JkAJMdWatoI1tJlye+3sQgTBnqFG9x/xUvvj6fr00z42PHrOndA/BO4pi4Eu?=
 =?us-ascii?Q?xvgxiZk2SkSOAwxHgkIE0xuilW5qqVvwdmzvb0gG7iWIIy+3FOgwOPmfIijH?=
 =?us-ascii?Q?glq9xHIFgSabGkHpik1Yaah/lrshP5EqCYNdj2hUSpZ4wqpShpVBTthrXHH1?=
 =?us-ascii?Q?fTikiWBGJ0Y1bK2+QqNUBXp+xBOqWP2Q+K60oAF5gNL0YS3qbQaWwcYJqlV6?=
 =?us-ascii?Q?cXaBbAWsI+5rR1PviQuX+9I0fXRNswXB4U3X9HwaBaPizhaSXKyqDsKr8Ho1?=
 =?us-ascii?Q?3LBnkA2I5nzpwYD3wcbd+4P54GN5SkP+DCRc9rIJbh3TdBwP4yN0VN2zR763?=
 =?us-ascii?Q?iUMAKoLqPIdC5sh5xFtAzNKpIi8yIcMh8v3anoO71Mrz4vP+kYvNc+wG8WSx?=
 =?us-ascii?Q?1QXBp5e72dxXOXQ1BFD7ldvWfZbQ9K7rhCBZmU3am2KGDeRUdVsoqlVmATn2?=
 =?us-ascii?Q?veDIy900I17Wg0mIRfdYW8f26aKn7dI4nIJ6YcNo1uCkIxpaVJM+fsUpM1OA?=
 =?us-ascii?Q?TaruCWRcZdW+G3wICqQHoifs7ukA6llyXl3lsByRPstwrTWuwgjZgouZUZgt?=
 =?us-ascii?Q?H4Lt7asH4cscWkiFjfvGSbifmqbCMJdqBoUgOClFZVL/tpy5Vw5rGwyc995P?=
 =?us-ascii?Q?zU4U0IpoIEVUbDkJHz+F0919SgCqBbCPzsdKkCHDRplSu59ubGIA6SNILoZF?=
 =?us-ascii?Q?egeHUoCZUiXvdN1GQ3AUMqddz+Y0oR+7nczRSloQjytJHOHrjJKWGZ899ovU?=
 =?us-ascii?Q?v1yEo7dQEImtlfJk3SB2EVWXmt5NmxH287IHW2NNle9ARvwDMb2TC9Wo42jj?=
 =?us-ascii?Q?IvnU9LhftgsJqcAn3cSevrYAfpk19PVeZNkh98AGbJ8aMAKlGxbCwmVTIMNA?=
 =?us-ascii?Q?vH2ngAbVQf+alGMQiPWt+1Ix7JFo6BI9fuVMKOBnWLMyl1EBQEilyA6YCaNu?=
 =?us-ascii?Q?QpeBnXL5xWFxQ2FqTP5LO09tuadY2ZYVULtHWoC4/NgHvg3XedxHqN1yZU7d?=
 =?us-ascii?Q?VulRKs0bD8w4xwP6zRCNRTtsts9a28fRA/v01cFD4MQ/ixMxqzOarEWlGCv1?=
 =?us-ascii?Q?WpPx7V7afwBFqEYVe73EKtNPJhkKQq1hHaKeUpOSEw3u75lzUU7OKOi6ahwK?=
 =?us-ascii?Q?u1QA0gF9zVi8uVm0cBT+RnILCWZ0jXrSA3Cc8FvbkXRJrA7bA6VCmMZgkIwr?=
 =?us-ascii?Q?vVjuOtX4lT/8x63oqZVnmi1ftPt3beCspGftxWXUks7JP2+6MNsUQc0pegq7?=
 =?us-ascii?Q?ZY4vFJntnHU81wCmA16GTuYy+vePbROdAHL1nTo10r3qPcMg5rIA6Yo9QGdG?=
 =?us-ascii?Q?csBMxk5B/Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e706ca1e-c71f-4368-6c72-08de55628451
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 00:51:14.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eDPkh/xbnpLiapdmW47YfEiVLCP8dYmYI7jBhY44q8vYgFBJpz/QbInFNYl0FSy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9496
X-Stat-Signature: 3gb45gigygqywi36z7ycc5agnsetxdy1
X-Rspam-User: 
X-Rspamd-Queue-Id: D29D2160008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768611078-61275
X-HE-Meta: U2FsdGVkX1/1SJ2fN23MzxoQYIc3lh9QKh3lX2GSqJ+85SG+lCzYqbz6fP0PiVzLvLviH1q5l4uv+Kgshp49ntanAMf7LRL19T7yDrM6QFO+Xw9nAC4zOM24/LsgTAa4F90g4b38PKjBMrIybiQXZv9QNVrR5v123o9ZqPwQtuP25ks97TY8oibZF/5+ZFn0EfV1EP4/ipsmPpFZRpkMZPoriB5sP/ek/Q0kE7I0Kb/JLgZTDPCotGwwMTvkeHori8HkBVdMAMj51Zh63LxjLiQsqCI/7zSvfVipUk5FxtxGP1lCLnS0f0s3dX9sSImPnIEkkrCjQ7pOMgbBfljNbVCCZQkflXNZJm4IP/UWl75U0ivKehywVBHjsoAP/yamDR/1b0YiTKyTXdSDw+NmK9pll9lOhsxumdCzrb+INxn868EnOE8DQQLXcwNOu+3pqvrjjLYJjRj2YwIPVX/frpAEqJSNOU8uQ7EgAPj550md/nfEXH7OfZBPVFO6PpvOCxr24vylsng/IEUq4YYTWYqxjPHR0avWAQ2cpGghnh96NjjDmXbof//ER2YcyVkJ/c/3193281LiE/jVFDT02eWqqVGRn/Ktqyi/Bnmf9ZTZ7GkuTMtEnR09W43zrUy99sXqsssp/+a3/WiLIBLmwTqQqe91fwYRchlVIRm70Vhpex4z1jEhQQygWSht/XKCuFicq1bWgnYUzIMlIiG4kqBe6waGQ3DFixPlOYjFERyoDHlILtndmRBUkO12VycDIaeywKCQwuRd06hnHCrqRvwn64XpxhHtDn6DXAbh15yyHyP2NzKXLcYa4hR7uXz5HqOdp7sxUppqrAF0dfw6AO1yBv+vdA/O2ypTxKV9GKD7tFJS4PBw7rvdZun/CKXgGsM51jrhT0itjEqI9MbWsebc0IbJIfTyj9mYYORb9AxJ6hjIDi9XYNbanWVmbSOqy5wW05wndcpuELWhTV5
 nHRBUTIU
 wM9Vt4pLwNv/+RsudhM71ur12mG5ovmliFDGp/7JuHxbjnC3x1C21Ry4+F3UhbC7utG2sgllXfqnWxBDGowVrELYj14w1AK7iwaPLo9pz75HDomuuhc30A1CVnYG95z6cFm5fuBWLtsUrqTTtNjicSDVH8OFOeOw/f0jv0tgaxjlhWQDsNBl4Nn+X72aJdakzZ5Qldi51B83rwUteoAQD0aBW2u8yAZf1fP+sYyBHI77y3E+Y/CRCMxxYkIpQJWk05bhhjAqHzic/GBAa2jbYhEwR72MjOYxuSUCXulXoFrSBPBQ5Ju+SBPewAYTL9yG6bsbHDPen31+Sh0F9DkLaXVC51Z/9wcnaiA/W48ZayoMidjMV2ITpkgbgCdZTty2gRkScGUHzvDzX5rdWDIk8s6j+4o88p9EgqN4AzF/kgSlPKGKosncemSVcYGUSougnjt1QAp3/ktJMK0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 12:31:25PM -0800, Matthew Brost wrote:
> > I suppose we could be getting say an order-9 folio that was previously used
> > as two order-8 folios? And each of them had their _nr_pages in their head
> 
> Yes, this is a good example. At this point we have idea what previous
> allocation(s) order(s) were - we could have multiple places in the loop
> where _nr_pages is populated, thus we have to clear this everywhere. 

Why? The fact you have to use such a crazy expression to even access
_nr_pages strongly says nothing will read it as _nr_pages.

Explain each thing:

		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */

OK, the tail page flags need to be set right, and prep_compound_page()
called later depends on them being zero.

		((struct folio *)(new_page - 1))->_nr_pages = 0;

Can't see a reason, nothing reads _nr_pages from a random tail
page. _nr_pages is the last 8 bytes of struct page so it overlaps
memcg_data, which is also not supposed to be read from a tail page?

		new_folio->mapping = NULL;

Pointless, prep_compound_page() -> prep_compound_tail() -> p->mapping = TAIL_MAPPING;

		new_folio->pgmap = pgmap;	/* Also clear compound head */

Pointless, compound_head is set in prep_compound_tail(): set_compound_head(p, head);

		new_folio->share = 0;   /* fsdax only, unused for device private */

Not sure, certainly share isn't read from a tail page..

> > > Why can't this use the normal helpers, like memmap_init_compound()?
> > > 
> > >  struct folio *new_folio = page
> > > 
> > >  /* First 4 tail pages are part of struct folio */
> > >  for (i = 4; i < (1UL << order); i++) {
> > >      prep_compound_tail(..)
> > >  }
> > > 
> > >  prep_comound_head(page, order)
> > >  new_folio->_nr_pages = 0
> > > 
> > > ??
> 
> I've beat this to death with Alistair, normal helpers do not work here.

What do you mean? It already calls prep_compound_page()! The issue
seems to be that prep_compound_page() makes assumptions about what
values are in flags already?

So how about move that page flags mask logic into
prep_compound_tail()? I think that would help Vlastimil's
concern. That function is already touching most of the cache line so
an extra word shouldn't make a performance difference.

> An order zero allocation could have _nr_pages set in its page,
> new_folio->_nr_pages is page + 1 memory.

An order zero allocation does not have _nr_pages because it is in page
+1 memory that doesn't exist.

An order zero allocation might have memcg_data in the same slot, does
it need zeroing? If so why not add that to prep_compound_head() ?

Also, prep_compound_head() handles order 0 too:

	if (IS_ENABLED(CONFIG_64BIT) || order > 1) {
		atomic_set(&folio->_pincount, 0);
		atomic_set(&folio->_entire_mapcount, -1);
	}
	if (order > 1)
		INIT_LIST_HEAD(&folio->_deferred_list);

So some of the problem here looks to be not calling it:

	if (order)
		prep_compound_page(page, order);

So, remove that if ? Also shouldn't it be moved above the
set_page_count/lock_page ?

Jason


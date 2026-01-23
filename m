Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323D1D6CFBB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 03:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703D66B0383; Thu, 22 Jan 2026 22:55:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1316B0384; Thu, 22 Jan 2026 22:55:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599146B0385; Thu, 22 Jan 2026 22:55:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 472856B0383
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:55:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 050D91A0C90
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:41:26 +0000 (UTC)
X-FDA: 84361677372.26.DE97878
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A84140003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:41:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DyTWzRNN;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769136083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mo2AmB4afUWo/G7gmKZODhTGxv3RD904UrIdf/DZLhw=;
	b=qJqlITLqTkWXZtuZP9Kc4npbqM3GZzizurMHzeG9PEpNqjKsjzFd5pInq9yNmJsb2pmmae
	nG2AzJD1lGiclTMIdNuL1ArPHqPiViscSx1ZsdMhWzSdptOuDJqEVLSw4gHA0ovL+t0iwh
	DnE7YknTWwtWHY0gkaMIQtms4i6axZw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DyTWzRNN;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769136083; a=rsa-sha256;
	cv=pass;
	b=pUzsKN6Z+IZu/oeL6oNL0GuZzBwMYR5zyDWjBwzgJ7bGDn1hC1/Rfc8E7WCF6lIwaisyYK
	jSvgxNNc5HU2CmOKubjbqNcQiHcwnKbk7QIVPQTt6IXXUHLDbNdkVI9zIaaf0yBkXBR+RN
	GrGhAbd3xslKtt9+cGrGvuR+CY2PI7U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnvoc1qSLOi5/7S2q1sEGAXZsQrnvhTAv3yqwfcpj/iOCardBjn74QK1KmEx7EA8yoWdRpocey3ZfylV74PrcOgaD19JE+GSXhB5+qlIzhEe9ofIYSvZA9MBvY/4OS5rkhiq8oZmZqdKzGziDgkMIQJ6rIVdyX8Hl9t3I5hewnjdoYuTeS8ScC4MHpY1PtQgCwiREyFpxLK4MM30DhecacRzrqwapXUQEgeFUl0ABqlzWCFWITLHSzTE7TklrD7HAyYu6IEfqRytejL0VSHDGHMwPyg8rMVwqIE07ZxmVSUC1IPOGoej9CVgL07XtoGPdfnwAst0vsWHKEabxSDZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mo2AmB4afUWo/G7gmKZODhTGxv3RD904UrIdf/DZLhw=;
 b=MmHbE528xTUwFtA41nj3fD/9uZvDP8xtr4Qnecw7AWqhG7j5VPYTV8aJh6pXtJG5g0dmeiw+y86M6XkHiHHgH+zSSRnwCPWzpU+SkZ8vBCfak62A5Y6TaEPge1LFbBUbUtMoDdorwrRTD+5oj4wvU0cUHG5UjfGr45iLdd+8sPIe//l69+lWwGOyuLjWdcc2nN9/vHjBljFUr+9Uzl/h9NbHNuwx68KB3sntiAXhH2691VW3Dmdnkhi0g7WXyx0NhbEXZCb48LQ52p8E7WJGM4nyACtHL08l5No6AJk8rBc8k5Jy3UZ5zFOesH1e3e/9vBfJNd4VBJscMYiT6sC7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo2AmB4afUWo/G7gmKZODhTGxv3RD904UrIdf/DZLhw=;
 b=DyTWzRNNQBmDpc4CJszvYtPNbXilUHLVvKW8uPhmDrJzWXThRhWBSI15VGmmXShhgzj6j+ShuMfoeqqBAG7ls1QKm3kFuYrKse2AwVYIp/Ox59e+6UccIg7fuXvyykEJN7qrXn9tH4op1HNsadDo10+cpxuw51egHYC+1/0jTEXeXUOo2qSnK7ctdbz2lUwsQCVytH0exuyV4j5kYMD6GLqKcoSJGa1O0uhsy48QsC8iM0KsHw0ZxQU5NbMM3csYSKdZC50Mr8iHaS/K2kSt4hwp8FG+pqIacsf/nE3fncsXSzopR1e0Vwzp5WypN4JWqCKM1XToDo2ltzr9bEku4Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8983.namprd12.prod.outlook.com (2603:10b6:208:490::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 02:41:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 02:41:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Alistair Popple <apopple@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, adhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Date: Thu, 22 Jan 2026 21:41:03 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <1EA077E1-DDF1-4356-B8F8-CB13F0D6D8B5@nvidia.com>
In-Reply-To: <20260122154646.GQ1134360@nvidia.com>
References: <eb94d115-18a6-455b-b020-f18f372e283a@nvidia.com>
 <aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
 <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
 <20260122154646.GQ1134360@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a03:505::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8983:EE_
X-MS-Office365-Filtering-Correlation-Id: afa10e68-391e-44e5-b48f-08de5a28dfd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WJjctPhWk2mmDUM9U48o8ulRry5sg1PngC8HnnnrRpi9Wn+2MrAKkLxu48Sq?=
 =?us-ascii?Q?/L6drXpHvokwP/dNVHtEpT9qTAnseXwu4Y08jODeaBM+T49fNn/h3KVzLOpV?=
 =?us-ascii?Q?mnVmDoP9V+iJoq2wG0D07pLr1pbDZbbmBcb9nYrDfej/+BpatDnmZFh7m8ec?=
 =?us-ascii?Q?5Z+/QGWouhdpEOG2fwx52pc12YTobZFel/kj4b1SMmNrwi1fB63JJgNYDOP7?=
 =?us-ascii?Q?GbTayT/UO1jkGynFUe5quD5dwWJlBbvuKtNXrNBZpOJ8HFmEXkKIH1CL1zfP?=
 =?us-ascii?Q?CycyVSOIJCHbUSddILvrAH326N0BfUNLpm8isS7q38/hoi8s9N/461pQwOvn?=
 =?us-ascii?Q?HuiUOYyZXmaHDb/yNU/caLv9JlOb2dB3pw9Nn47qlHr67efAmR0dJbab/6XF?=
 =?us-ascii?Q?6VhwULCqKHbW7rfMUJSnSLGKsiMO32EGoWFC5nD1XVLSyfHtisoabDM3upF1?=
 =?us-ascii?Q?55hVVIEPmpkUscfSJh+IyyJzxSth7XQTN3JxvmMtEB6Q/MEtB/Km4qSWAImx?=
 =?us-ascii?Q?b7oRJZiVMCyzaxpf4cDx89ldHqDuyTMwvrH+NVoqOa8DlK2wTVtBbiNa1CHP?=
 =?us-ascii?Q?EWH+e73us9M0vQlMJEz8Jne9UgWppkXLeErEBf92F/i+wTZN20F3514e61S4?=
 =?us-ascii?Q?cy0MewRk5BEYYAtqMHci1bxkhzUjxjaGIil4+55BWUiT0tQ6+Cgrr//4WYcK?=
 =?us-ascii?Q?6nZcDj2U02u4RIBVKPJ9DDs/DS+/LEar88snio0D6VDdEn/rKmQbpAzH71u6?=
 =?us-ascii?Q?ONq87zVdxJ+Lgt25FxjDDowQuCk7DZmd3Z0sjOOUJnKO8mey8UIyy/MOjeG4?=
 =?us-ascii?Q?cTdmeVdyUbeWsNNcLMPk8CogjPtiJfiO++YszX7o6IVefzkOLcoR6wNBalJN?=
 =?us-ascii?Q?OgtijBj/65pPxfHhH2USrxIOncocwF8v9F7hWxJnONp4JgDv8ydmU02rbPnU?=
 =?us-ascii?Q?Pl5+HJ+MfMpqURya7t3snEkFsTsl8jtjGeMqLhLfIsVEV5UPm0TGjvqLEZHx?=
 =?us-ascii?Q?ZZ1rAuWsl1IHztGL78F0NYCX2L/1AFpbkmMd6Q4uWlXNS0TQX2M/af6uxntm?=
 =?us-ascii?Q?fCZPdrnR6+U8Tt2brn51qfeb4EyiZ9vX/fsdSBrJ6Oq99GW3S8BJ50htnaRT?=
 =?us-ascii?Q?N1JaYH0cfLTFGBt3aAJKAqe9dhl7VeZoRf0AAFKkrx5gfIyWftyjGXWQW3ss?=
 =?us-ascii?Q?qmQiwEl6Ss+ay2XeqzLqxbY/6Ho2c0z0IrA+OvKqk6qdkh1sE92NHwmxc13c?=
 =?us-ascii?Q?hXkKQjRpNTkPmOuhKJDOR8Z27dfPSOK38HxJK1NUj17mOgLKXqsSc+DeKIMQ?=
 =?us-ascii?Q?gtcfBY+m2dsIqVJt4ygQpKMqStbf8RtuIlER39q0wPwknOOe7PKAEjWUHAz6?=
 =?us-ascii?Q?DQ3a7g8fHM1HufR8DSqurSnJCbm6rZK56Yx0m4A7oxouIFbrNLfZvsrsOe0z?=
 =?us-ascii?Q?1Z0R7D1nnG9qrnIkJ8zRxnJEFFVfm4UZGjF9OnxFjAdMkLyTIH1dnayBObGP?=
 =?us-ascii?Q?k3dQQfnoSQAKvvdNI6A/82NUzzIEeziMdvCup8QFnInFYcwj3Fgm+LMecYy+?=
 =?us-ascii?Q?mhDzOLpj5E4UKFLqw78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3SMTR6h1cbjcOjkKFp2umxl5mAdSwEcWJrHp7FK4e3C7OdHU1vOtsbS6442z?=
 =?us-ascii?Q?rTs2Ekj1TgMnnrboS6x4dtsr4hmCXZMJFo81oh+nJZ/xZJJpo4HNGRWUlYsM?=
 =?us-ascii?Q?qDhD7XWCJwSSCO2ADlxRPYzTyqisWxfALyittrFnRFFzGMVmoaL8i3paVExu?=
 =?us-ascii?Q?Cx71q4H1hPStgXSRUibXn8f+CeWd7yZjInL307UrfzK3k/DY1ZuBThR0x5iK?=
 =?us-ascii?Q?9AAjo9VBBaLZtrnLvqX8L8g6G2dJ3aeNE8kp+7bBLlWlZw1iL/6ABk1FG3LW?=
 =?us-ascii?Q?rwzRhwYvueG3huHOTKIWVjPT3BiR0Ypi5qtw9rTJE4BUJsl8zb4GmgfLl2x7?=
 =?us-ascii?Q?KImu5xD4hvM+HBc2ooZ/USFjh2C2mgIJwtxQWSSAGNlFMLIFeTH9TSwT3Eyk?=
 =?us-ascii?Q?UGV5rN6XKwPCvkNUPJsU4PW0eLnKY+ng97ZXtfLtobTsPH83ehpHyOETl4Wd?=
 =?us-ascii?Q?HUAlZxDtqkzmQpu96aDQ+aShvk8nTzE4cb56Oy3q7Dh5SDj6WoVnN9D9fQpE?=
 =?us-ascii?Q?fZ1t5Lllx0nTQUVLNN0k2B/IuXErDqLPb9FIxDBhkMp9j2lxoMPkEa91Yskz?=
 =?us-ascii?Q?eza30E4RdheFgp5zVsEp+d7x99taMjAkucA+p4nfH5YSo5WUjEpnjQXaTFci?=
 =?us-ascii?Q?lQb3UVN+XZZndgoXhtDK9Njqn5XkD4JvsW0bR56dKsRHpv4SqZUT1Ir2k6Ki?=
 =?us-ascii?Q?0j6mNOgePUStY/vf3QNudiMXyb/j91hFfEgT0+47811bfhdVfGBnDTQq1QKe?=
 =?us-ascii?Q?AHlWEm0s1/WEnlQoDbahczPaO4x8JDgDh3mCs5H6FcNzQ52s7GKN23sDki0K?=
 =?us-ascii?Q?JgXULxo7P1/5aGSqn6HYNXBTf5O3QkpKDPGopn9Gq4RXeNf9xnFsGTQvJhj2?=
 =?us-ascii?Q?eUyuZmv1OoXvhb3i62oeOe72jLlTRugIbTO5GXNgaEAIuVOZKb3mhDiahYoA?=
 =?us-ascii?Q?z4iHpOqpkyJx1hX29po6QmEsSoslqGfB4d9WBw1ybXOZUQZgjMAwpvJzPjar?=
 =?us-ascii?Q?Zrr/3Qkwzk1UkmaEDNUTH8XgzqwdwLONW++zJwaVxYWhNPdLW21PxfrhhGOl?=
 =?us-ascii?Q?9fTdiB9fRAHegY99WsQ5/Wh6cAIjW3+QR/22FMk/FF44yjSkjbqjMSaEa+o4?=
 =?us-ascii?Q?ccViiiSivCzb/EgGaxZ7/3kSPcIwRVP5PC5IJteSOgCieg3xN8ov5yGc7WAA?=
 =?us-ascii?Q?3j7H4EAtiRgxqYlsPXFVQKnGR6UqMJzm2HIrdb5Peh0FRx3u/7SbiwXNIVJX?=
 =?us-ascii?Q?nJNSlyofqHPsokugdq+1JNoWEwzjcet+GZYmag4phJmnQ7cAtONQXH/mRPyL?=
 =?us-ascii?Q?Ddt7o3htvuPUhs1VrcNaeQij2ri0vKWtLiL4hUZgm1Yl41h2WagJ1Jx1F+rJ?=
 =?us-ascii?Q?xbYmdCG/THWCQRjtvrtAA0FtleOVsEX6He3SbpvsefzF2yUX82NX0UL/LIHn?=
 =?us-ascii?Q?4A+2LZjM7FQJ8n9dXJ0fFaYtJOx0h2a81UPZitnDYpoGwBFYzFX96ksSGgZG?=
 =?us-ascii?Q?6dlsMeMeq4CFhHclpcLGVWwp1HeNsId9hz67jO1VpMADec/U8GE16KJOyolJ?=
 =?us-ascii?Q?d1tI5Jw84v5R99fdNRGpz7s7nRfiOph26cXiVBvcVjd7wmSdERxvqa+0+qKJ?=
 =?us-ascii?Q?JZo8gG21gC75KLAK6MGnIbB35z/7/XiQlNGoVUKBWdekLgD2VCnN0tzu1aM3?=
 =?us-ascii?Q?q9su/juE/LVjnfLWoOBVycNY6UNw50JiasF01UrefDKT+3mf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa10e68-391e-44e5-b48f-08de5a28dfd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 02:41:13.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKFd8R8EOmiZotSEsVAgDUuadz3WRrToTAh/QWvlcBmKa15BihQH856/QSLn74ZV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8983
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A84140003
X-Stat-Signature: xir595duw4qrzdf9yzntz37qfj8fpsua
X-Rspam-User: 
X-HE-Tag: 1769136082-589464
X-HE-Meta: U2FsdGVkX19FLxQ18dte6FO/U+GaRk1bjslW/HYl9v23iKU0aTG0GsJhwE+nmqqAtkSTeVll2csqFAy255+yEdIPqLG159GY0VVvcYus197URO6XAf5wlSmWrSElM0lRDHYB622VaYam1w67Gg3Ka5WgEaCXa5KYr8uCGfosoFOBrRkofAYPOmGuYh60tw2bOSj5VyywQaUPjmFDc/A+8LHC/SEV20WgiryluAfK3Iyn+18jqFxOFo5Uisma8r8/7TBk1rC5g2cnH+CNThg+HZ79kW5k7abjyXE+ZwYj6OROQhIaO3xzxcGdm7oRywp4DdiXeCk6lk/sEaQ5Vw+ug4YLNIico3hdZaoBz2mCJdFiL8F4SucJXNIGUPJ2otCUr5/FLeSZ+LRWiM8hsEErYWIufcDelNZk4tDXEqA/2czWbI1LEKxf/JIgy8xsK4m1HCgiR95agqtsccVqZaakp6tJsuz6XeiUmEdTl69m3uyR0eYiB502wr+IOngiAMRlhXRSLn3WBjXPi7Ne1KH8XUOTPhlHGKjN6oQ7fqkB7syeo5Am3kKm6m7iA2elC1ccpDNv2iQu4UY+L2Q4Ru03pVrFZuUGYSqTtCiFtO+ur9jQI8egWnO34uLdcvY/sq/KJI2zl+C3it2HkQx6H8HTFnDckiWfliHieI++L94lpJNUo1YqiZftG5myFYL9b5Vao/ogExBQNNNtszBSMBHqpbnadbVQAQbefghZxwNozK994SXpuJIiGzFgfFWK9zXPnrAGK2Py0e/fYonlGhSy7HC+1JgBMLMQ6DE5UPntIopjcTGyAnSyGk0xbQA6DDfdJsh7qhlD6n99ROwaRVTN17rRCFL5dVvf1DdrXgjX8BEcnVJMAkws1InbsZMlY2etCMR7vnSBC9aNDJwREocPkm8xWSUTpSvWrz3EJ05Oo3T70VcPuGzDC/XINwX/Wc4Q5cBx0dDo4gzmagEY+XW
 FbV2wGpt
 sFDbsFqPHNW7+rphG3Zw0esirvzCma79eCm6Ba4421R0JzKTPP+1LAit4/yqrNLZO9TEq2iY3JaFKqxvvUrO14DAso5Vxk69ZVvcYeXHlU561FaXUxnmrcPIa2cUPFaCe8FjGrZV5qUasuygU6w/gWLit2I6F5wq5uwnWTl/iymOiI/p2UfJESpGv9PSUz54dxg/eN25EG9Qs4aw/mAe5+84z9Xsh9AUQFWfVvjpWAVpiMkwnTI854nq4LGtudcR8aXJM5I8V1KIOIqTj6Zdju3hYjX2t59ViEmbDtqpnhRQKyynEfvssz0Ivt1UPGg7K0YCX9ESMvhro8ECJDaL1QW5nJve6eJSgcKT+mQhERnxlNY/cOqhVysLycw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Jan 2026, at 10:46, Jason Gunthorpe wrote:

> On Tue, Jan 20, 2026 at 10:01:18PM -0500, Zi Yan wrote:
>> On 20 Jan 2026, at 8:53, Jason Gunthorpe wrote:
>>
>>> On Mon, Jan 19, 2026 at 09:50:16PM -0500, Zi Yan wrote:
>>>>>> I suppose we want some prep_single_page(page) and some reorg to share
>>>>>> code with the other prep function.
>>>>
>>>> This is just an unnecessary need due to lack of knowledge of/do not want
>>>> to investigate core MM page and folio initialization code.
>>>
>>> It will be better to keep this related code together, not spread all
>>> around.
>>
>> Or clarify what code is for preparing pages, which would go away at memdesc
>> time, and what code is for preparing folios, which would stay.
>
> That comes back to the question of 'what are the rules for frozen
> pages'
>
> Now that we have frozen pages where the frozen owner can use some of
> the struct page memory however it likes that memory needs to be reset
> before the page is thawed and converted back to a folio.

Based on my understanding, a frozen folio cannot be changed however the
owner wants, since the modification needs to prevent parallel scanner
from misusing the folio. For example, PFN scanners like memory compaction
needs to know this is a frozen folio with a certain order, so that it
will skip it as a whole. But if you change the frozen folio in a way
that a parallel scanner cannot recognize the right order (e.g., the frozen
folio order becomes lower) and finds some of the subpages have non-zero
refcount, it can cause issues.

But I assume device private pages do not have such a parallel scanner
looking at each struct page one by one and examining their state.

>
> memdesc time is only useful for memory that is not writable by frozen
> owners - basically must be constant forever.

Bits 0-3 of memdesc are a type field, so the owner should be able to
set it, so that others will stay away.

BTW, it seems that you treat frozen folio and free folio interchangeable
in this device private folio discussion. To me, they are different,
since frozen folio is transient to prevent others from touching the folio,
e.g., a free page is taken from buddy and allocator is setting up its
state, or a folio is split. You do not want memory compaction code
to touch these transient folios/pages. In terms of free folio, they
are stable before next allocation and others can recognize it and perform
reasonable operations. For example, memory compaction code can take
a free page out of buddy and use it as a migration destination.
That is why I want to remove all device private folio states when it
is freed. But memory compaction code never scans device private folios
and there is no other similar scanners, so that requirement might not
be needed.

>
>>>
>>>>>> I don't think so. It should do the above job efficiently and iterate
>>>>>> over the page list exactly once.
>>>>
>>>> folio initialization should not iterate over any page list, since folio is
>>>> supposed to be treated as a whole instead of individual pages.
>>>
>>> The tail pages need to have the right data in them or compound_head
>>> won't work.
>>
>> That is done by set_compound_head() in prep_compound_tail().
>
> Inside a page loop :)
>
> 	__SetPageHead(page);
> 	for (i = 1; i < nr_pages; i++)
> 		prep_compound_tail(page, i);

Yes, but to a folio, the fields of tail page 1 and 2 are used because
we do not want to inflate struct folio for high order folios. In this
loop, all tail pages are processed in the same way. To follow your method,
there will be some ifs for tail page 1 to clear _nr_pages and tail page 2
to clear other fields. It feels to me that we are clearly mixing
struct page and struct folio.

>
>> Yes. One of the issues is that device private code used to only handles
>> order-0 pages and was converted to use high order folio directly without
>> using high order page (namely compound page) as an intermediate step.
>> This two-step-in-one caused confusion. But the key thing to avoid the
>> confusion is that to form a high order folio, a list of contiguous pages
>> would become a compound page by calling prep_compound_page(), then
>> the compound page becomes a folio by calling folio_set_large_rmappable().
>
> That seems logical to me.
>
> Jason


Best Regards,
Yan, Zi


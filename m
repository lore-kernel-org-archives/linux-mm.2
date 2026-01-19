Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE35D29C30
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16116B01B1; Mon, 19 Jan 2026 09:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC37A6B01F0; Mon, 19 Jan 2026 09:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98DD6B01F2; Mon, 19 Jan 2026 09:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A74676B01B1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:25:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CE9655F87
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:25:00 +0000 (UTC)
X-FDA: 84348935160.23.2182F3B
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95F5216000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:24:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CT+Ovppq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768832697; a=rsa-sha256;
	cv=pass;
	b=1zxXLu0V2OU2PXx0OHsskZ2zkjxW+nYUyzeFvh0ELMbFZhc3YqJRNEvldNXqRBOQkTeWXa
	y00deg2fNdHrFjVwqg7OUUGX16h8Op1VYW6ly1eN274icCHcMHUcNOQIj5gDOAKgo7wK6w
	e6SRnTr4PPtV0mgB8nGRLrMVbXpxrRs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CT+Ovppq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=turi48Yi8HaHD7cicRn1hz8MEf4SqCBx7ESjkvKLhh4=;
	b=LAaVA/aw0pTWglra40Oz+NqL5o8dF+pFxdiuncGtPdbJW6wQfk2mloBqBuABxJwap4ruCC
	h9B464PL6Oe9TPjUHeMhxxoBRZ4Dfmy+0Gu3GtCkVto2Hchy/v8Zd9hnlNn/tu44lWEpei
	r9MAWV3fytRivNEUkniMeg/61H0U8+I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMFZSUAu0i/ot1DjJBhxolhaP7Eo7GIgAzEgvFBTGrnXTxRRN6arFbOlXJvswqaG+gfGzSF+wf11RgVu0a5B/EbZXVU/hsheOSN0XIWS4F6wWITSpsRabcBkIsTiPYHtE8DyUaLOeCRhXhdh3uc2buLtwlQDfHL7+OGhqKYzZUpYv7WO2XbRzkq8+HDz+opkVDl9l66AjLiz3PRsDY45OgvYZFArC4N6yciv0lj04BT2kqiTUOmE+SrYQSMDiC7FSw2Z5FMS3s8HeS6O8orPcGCS5mFpoBScAKUIKGc3NozOJO54gMTMhroiTOYdjYBrPubOgDyOiyHUtBBAgZjQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=turi48Yi8HaHD7cicRn1hz8MEf4SqCBx7ESjkvKLhh4=;
 b=bjYYHqweWzF/FGiC4RoWqST697UGtyXp2x8CPZFd7K71u1Lb5bKsW7lpS7kNWsG9U5p1WxSIVlguJQ1KHD7pzjMDEyFz5h9JOnHzBh/n2qNFNhULM+p0aeDmn7csmFHfTXb3vNinUGPQbiZ2W2jPPvMasR4om66viovT1K7BqmEP/HosOfNUbo83KZX13LfvWkpOCSp54jPC3Faf0DOKY98KSFxib7pfkPwPEBzHYrRsxVwsR63ct2VQCn9cRSZeuCy9ezFLK3eRuB/I3ju1ko1KuStxGVpJ85vk3IJfTbRm840S3nGV0TaBpJqd3jd5YxkiSDGQLuPYdq9quAXr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=turi48Yi8HaHD7cicRn1hz8MEf4SqCBx7ESjkvKLhh4=;
 b=CT+OvppqmHcWsydZ7y3vgvhl49D34QXwQiEn4v5OqCgtmxEdiCTzWVRW9jNInb1WpQcTcoS7+mQCFfI0Vw8NZgD+B3E2TG37Utw5zJrD7xEyQtmj9Nq/BFZ+uLjGPCUKb2dBWPAuIyuX+hQECSOph/NjXjczVRphZrsTAcPU035+KmflpVpw9Lb/jsuObGJa3t5PmYeKLxp0vrge/r3KRxqdO97PUDfiLnBRsLk+BsTtXLymLuBxlalGj1jlCVduogwaSPgqXheM7wsHdTZVHGvgoFSZjbpbawfJxLkOV2muvjKYGVdCBW07H5HSe2X7uWF1Jvn3IxfD/v1W3KcHpg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB8105.namprd12.prod.outlook.com (2603:10b6:510:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 14:24:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 14:24:53 +0000
Date: Mon, 19 Jan 2026 10:24:52 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
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
Message-ID: <20260119142452.GH1134360@nvidia.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <20260116174947.GA1134434@nvidia.com>
 <8006ea5f-8845-436a-a2d7-125399428762@suse.cz>
 <20260117001921.GB1134360@nvidia.com>
 <y7dm2sqf5t5txirxkbu7hlmsfsnlbtdirgn4ts2l4st3z4kawo@qpa56ysy5v3t>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y7dm2sqf5t5txirxkbu7hlmsfsnlbtdirgn4ts2l4st3z4kawo@qpa56ysy5v3t>
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: de0f970d-dc5e-4682-e3e2-08de576682ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qpNg0AQEMUOxxl7XI5m6FY/WWnQXFZyA7a0+XQPXPdKNJ4aMSQMTZVMX6MgR?=
 =?us-ascii?Q?oBvUZqNe8GP6O8GDZ5pyJEwaLK7MfKPcElBzazdyPy3FQd2ybuUcvgJhB26s?=
 =?us-ascii?Q?fRYPQWWh6SosfxeSu3POLKHIhtYG9/DogFb7zhHpaMBnpTD9ZHY/HPs9h50D?=
 =?us-ascii?Q?61Kkj9Xa/MhkmAczt39vMLpIlQOKDN9sCbcf/vRFOKDE57FnHznDDr8awZTB?=
 =?us-ascii?Q?cGfgBuoBChhb7dJbutJHi87AxHycPSenC7p9ODMSdXtjwGKrCuOUS/BH/d3Q?=
 =?us-ascii?Q?5fZk9fYdR/a+4XBEtSuUu7BAdBjo9uZOojeaezw4qE549WPqNWMPgL028UJq?=
 =?us-ascii?Q?AAK/WY+ZBxXofiDK8WzP6CFicR+NYzGq9OEbfkRJ/vig5yVzL8tzFgFY2PQS?=
 =?us-ascii?Q?01+TBrXQU86ZgjYRALNaCdoR+4+01/J0c5njTafvmZQxlee6430dLM8tScEa?=
 =?us-ascii?Q?9cRxAEN4v7NXr9jecO88eKoZR31QFNwI9Y7dFdCkIK9X7/aPh/AqlJSHhR89?=
 =?us-ascii?Q?KH/wfVd8Y5COB7j4tunnbTsIFa12ssbu/qu5aZoRGiam3/Ifnv2SKrWghd2C?=
 =?us-ascii?Q?XZyjknIoN5e4vbS4yDQ+w/o+S37WmGky6G3ux32kjFEr16/7BprbWu+0zEnj?=
 =?us-ascii?Q?WLP59z5GCzmMic1emzdNbnGJrmerAiFyJNuXpt9fWOSDyfCER6i0QF4RtxcZ?=
 =?us-ascii?Q?svQ3ZEX6b93miIg2X0fdgjBWK8teMit/h5d0ZuEWgtpmdIvIMdl4j8nK09pK?=
 =?us-ascii?Q?YwRdda6mYC0fdtXJ0Gt0+mp+JmgtdRrST5xcXQpYYMg0nkYjC5rnBv2N/7PR?=
 =?us-ascii?Q?M3/wsWTPu+UbYGBCGXOjLU0ljpmutynVSItRCcdGiYZjlE2QohNln32w7J6Z?=
 =?us-ascii?Q?BeYaxFQDkYh54cLOei9TK+TBycYOL7nus7INyw4QCyoGWJO9od8vhIqhMA2b?=
 =?us-ascii?Q?hiWEmPNqKWkd1WaZjNauAp8/6eeeCrRWDNYpk4Hnt0xdrzaPitIY1TPyesHO?=
 =?us-ascii?Q?lkpBWgFDE0GLH7DGZNu2juEFsSn+xzOBrsO2nFmfQJm8FSIrDn4GSK9Js4YW?=
 =?us-ascii?Q?klxclZvGizxu2uuYiPWS34msODjpxg3RFKl9HrDJ3WZvSAYesBsQeEDL22KS?=
 =?us-ascii?Q?NmuRth1XgfB/M61vGGh0f2NKH9eMu8wsZbtrg/cGsmpHTLBip2udExAaSSqc?=
 =?us-ascii?Q?CQf3NWRCubTIX52gCbD1kbTNrTTV1tSavcYynXNGZ5lPAD1EynWDIFuBeLlQ?=
 =?us-ascii?Q?nl8G5JdkiVQCKqIaGpFO/RT8aDNUycCdc5kqCJm3SqD1CtowM58XshAU/Npe?=
 =?us-ascii?Q?eDkrXYf2ZDEMMsETp7kRxqIYNmNJn1k7Ims3bS5h7DoeKaEMcTEX2UVKriom?=
 =?us-ascii?Q?OXLeTeaoJu3C8ZD5eEPiedZPsoDGqRCVspzuuix+LjW78AEjt7YpmhdE2R5K?=
 =?us-ascii?Q?QCENcX+PrfsBfa40mPD5MoISgAU+khJKHB0kvsUYd/zJb06IJurg6vd0kt2G?=
 =?us-ascii?Q?tRyggclOazBHAltY0+XeS2R2xL63p1XsiU+RMptER3sf5K66riFE6PYuZUgY?=
 =?us-ascii?Q?Hdnbu4+Hr1ojPZueIjU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jFxcYsyAWyE2y6thnaoxl5OZUAuIjZ3kxqMlbii6vNbN+PHK4wtKOZzB2PJ1?=
 =?us-ascii?Q?+u9E4be2XXy2zk9lSZDj+NIsxqA8Dq/SEW2YHEiB+DNO29W2kvpGAIlPsf4w?=
 =?us-ascii?Q?eIwny4jAZz5GJq0X4idpvcsqa/yR7L8DK7EzFDFoFW7fmExwF10/x+wOk/KE?=
 =?us-ascii?Q?A9IdwT87YRu8IJcJhuKokfq9+Ka5eRDKxY4R8KeislCJNPIeeHWvbHdn7QPo?=
 =?us-ascii?Q?SHbaGEyI05rdM68GKVR/uEVXWoscR6korPwXrG9drL0qN6yItDuv8Gq6chxG?=
 =?us-ascii?Q?0mPEOAhXdifDL/ArDSjeydl0oWQnl8fNOg2uIwHk6DDFPZShft9veubBI3jp?=
 =?us-ascii?Q?+WQrchbjiFuR0CXhKdS2N/y+q08qXtnoIxHalevwpuoX7HIaKaOowe+17T9v?=
 =?us-ascii?Q?eGu3KJkvAQm3zqXV0o6bfd7kxebixnuvuiwZeng/4l8QNlgO8Yca6jNMusOx?=
 =?us-ascii?Q?rkx2EPKpdgIAo7gt3j35FKVR6GLxVGxkonjKtu8aHWByCuRub32hdiX080LY?=
 =?us-ascii?Q?8X9AXR8qHUaUmiA3GnhVYoH/aSBqAE4FZo9iFLB8RRvrcBC4fHT/TG9yqBzt?=
 =?us-ascii?Q?4HT12C67LdvnZczxvGJNJMRf9vLhuwZqSlUSPygB46jG3kEy/zwkbd5/723y?=
 =?us-ascii?Q?JHCm7sR4T6zExxNd6wcaHyZb5L67x1tNiGBbt4itr70SLx3YrG1Dd3GVhAiw?=
 =?us-ascii?Q?tXI9FEwk/XpZXaeg8zXPSR63DxZx16PHBzZePS91ZmY/rJGJJLXIro8uUJnE?=
 =?us-ascii?Q?2Dg320HW4dwgQxZMGRVPVyTzmJrhtrVTYB5S0lI40UrnVnlNTphR0rGRaxpL?=
 =?us-ascii?Q?iqa/WU7wNZIBrCB1FE0/VVPuCkSMTisazJyLKQ+0IHgvCalu7xWribueXbrO?=
 =?us-ascii?Q?uVf5qDLOSe3wFSeJwICql11WsuQBJviLswwrPU2Q9lLyHaDnPSQar0mhD0Jl?=
 =?us-ascii?Q?Bt3aS4uPDJ7bwhQN4wrTz6Ucyxu2UVR09bnfeQ3b2lwPGTDrW7rP9UPLDijf?=
 =?us-ascii?Q?hawpyIBirIyHN0D2/wmC2mtB/UR4qPyh7G1sFhkZPANLQj5OCu0+vL/bGaVx?=
 =?us-ascii?Q?HQGK7TcJTcF9iO9ma6QKUWBY/XZKLZnpOwLJQ1TFYX6IvNhslT7Z9q5TaDkw?=
 =?us-ascii?Q?LjwObWaScTRpTJzHecmYX8sSD92H05Svu2S2F4o/hQx2x5/pIz85AT8pR/Rs?=
 =?us-ascii?Q?jmn1KsNSAXQ1Uq4UqQJu4rR+mmRizlp7EjcM2PvLiZeBpHdgKeNcwqeUnE34?=
 =?us-ascii?Q?whvgJm1x1XrEjaMAsc3GwgOehf5o4ouVR/jp1Rrs9/uKcKYzBHduQkBOpFi4?=
 =?us-ascii?Q?c6zymC4nY11FwOuiXFWSPZnik3iVFaillccBvTGmCgGUiiZ8T7AuY6VhnWld?=
 =?us-ascii?Q?Hn1itPsvbJeYn8stWxHn1dk1Yu7F+QZPUCHjgb2OiLpyRI2kyoKoqqKvHhSb?=
 =?us-ascii?Q?akas0lXOZGg9bOq2J9OhPgaSyMFtTOPb17/IK0ZBRIPF7etA7v2QVWEiHipB?=
 =?us-ascii?Q?tWzc4437hrZmPkHfqStvZH4o4uKuSRsoKrbieCywuBgxO88yNXvNIba6hiDX?=
 =?us-ascii?Q?h94jvRbLhoOs7VGhJme0rkVY3qA49ZrqQHhimEi1qrJqVs2uDvulS0wansnp?=
 =?us-ascii?Q?M6GJ85uIG7/a4NXpm/F+h+gYrAU4CODFkoltWIkEmqHvwD+y8qTa7m5ESSLD?=
 =?us-ascii?Q?1AsoOv3CZof9/kUMgwkCwOFDGPfV+Z+QR3DEeZzzf2rtJDQ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de0f970d-dc5e-4682-e3e2-08de576682ee
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:24:53.0717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtIx/6beXT8S1fxwvbvlbZ/htYlYiBQ7UwjcEmg5WIGGbFYPHLMS1IDe/h1UMCTm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8105
X-Stat-Signature: jhdx47j85rm355rumuk4q7ic65a7x8nx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95F5216000D
X-Rspam-User: 
X-HE-Tag: 1768832697-639570
X-HE-Meta: U2FsdGVkX1/JO4pqsaIVNS3Njqm5rMUBK6574BEpKg0sqJ4LCMqTcXlnuHkCEfKDObup3xEuItxyxV2u0Sv1TMWdPVJ4aFI2HGTab6acRx32aFWl6raxBalOgz+klOsHoAjXG4QCBspCLPCp2JbBPPJvNsPuqloETed3quTxdXyJWDbdeNVWTI9Rtt0Dh8R+ja9pVK5px9RLP61bKyFy7EKlw3yT5QYJl6gBnvUQl2Surm4QpYwx20gFIy/v8naeZ7nHmflg4v3I2sImZ0lzKB8Vw5Khi7+yGXIWh8rzSR2wwBKxyqv1PBVlAzSYyp/Qwwyi+ZKL1ikkmz9bKyBMF1Em7n0At9j7T+pK1Nm3zaeKL1kh0aViz+yvDsCzroxpAdTu4DGcjRVyWHLC5gZ1cFMLyDd2NjsLwr5WPWMwnr8JqfgMx7ek1L4tvdxVwsPAUeTNYcW+Xd0FqxumY3A5TDo+BNNYXpToIaNNyjsBPS3GdBXmmsjUR7sEI+LD25LIX3odFD/z1yawryFZWPUQyLvd7WsGrudb2gT+5xdrCIakgdYus209G5D8NgiLkbKJV5p5gJd380BZnoiabq6oEdgTaWspUjswOvDNYWfiky2FsAlMAzln4zV+tArpLpzCDKALXbdPnKgtD+EUCq++rlcwl4fOS+VlRkP9SfSqg5aBbleAbD0h6j+MW6LpoO3uTXKl5e+hm8c3VzGw+A7xwmKgaBiM5sxlVaQMCATidjbwHbiYd3go9QZhnoY0/d9evmnzm2Jggyv3OKOT4e8WyYoTa6CjhoKxsc4aWtc02qJEp95q0Ll2Gw0+CoYqVQJMd7dhgO8r/kp+UQ/uGPygSlzWjH5VS6i3otIIrvco3t1/DdPg2lf+xVHn++HzJAQVBmD5Fu32lxVOFkm+t9iHbTqbArVfFB0AcwKXrZgLTULugxpI0xCwt7p1r5CXy5Ka+GaxaK1KRQ7fsoW3ibe
 GhYwFEb+
 BeiTiUF+CHtAAfdyu1T+18XMC0HJ62WE0GrpOxxwTb6rEwew+DLvN9ZlhNpPObGQbnV0dabNzYnGAdkhiynjpsGBJXN8u/b4qnusgpdVbZDpQ0sVBOTDueXzL64VkHH6Ggn5itdUyRFg6YtBpH1NE44XO7h5jaYisMErUsxXYVx0HK+wgAvbGBwiibykCiexNGwM5EIJhbgU+FfcHUnoU40TOL80ZGwfLy2+CiG+3tyc64MWH4qoCcDpXVyRqTomJOEQfjI19CN8QaYpCYgg7deQmSjPVmtNciLtOArcU64lKx4G+fgyJCAjyDbTfKlCnW0F+wSnn3X9NBYkDqwKjvrvfdEmWOapRfSqgODGpICApIeyEldspU6pumNAult/u7Sn+EKbwpFTGrGWUt+b7a9xT33X+JsPKG6+G4PXSKwsvA+lrmdbLUgBVCKEbSfe9v5AIk/fG4vlsuYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 04:41:42PM +1100, Alistair Popple wrote:
> > And if we want to have things set on free that's fine too, but there
> > should be reasons for doing stuff, and this weird thing above makes
> > zero sense.
> 
> You can't think of these as tail pages or head pages. They are just random
> struct pages, possibly order-0 or PageHead or PageTail, with fields in a
> "random" state based on what they were last used for.

Agree on random state.
 
> All this function should be trying to do is initialising this random state to
> something sane as defined by the core-mm for it to consume. Yes, some might
> later end up being tail (or head) pages if order > 0 and prep_compound_page()
> is called. 

Not "later" during this function. The end result of this entire
function is to setup folio starting at page and at order. Meaning we
are deliberately *creating* head and tail pages out of random junk
left over in the struct page.

> But the point of this function and the loop is to initialise the
> struct page as an order-0 page with "sane" fields to pass to core-mm or call
> prep_compound_page() on.

Which is what seems nonsensical to me. prep_compound_page() does
another loop over all these pages and *re sets* many of the same
fields. You are aruging we should clean things and then call
perp_compund_page(), I'm arguing prep_compound_page() just just accept
the junk and fix it.

> This could for example just use memset(new_page, 0, sizeof(struct page)) and
> then refill all the fields correctly (although Vlastimil pointed out some page
> flags need preservation). But a big part of the problem is there is no single
> definition (AFAIK) of what state a struct page should be in before handing it to
> the core-mm via either vm_insert_page()/pages()/etc. or migrate_vma_*() nor what
> state the kernel leaves it in once freed.

I agree with this, but I argue that prep_compound_page() should codify
whatever that requirement is so we can trend toward such an agreed
definition. See Matthew's first missive on this about doing things
properly in the core code instead of hacking in drivers.

Jason


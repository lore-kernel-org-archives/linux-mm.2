Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F899D3EE66
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EF46B0202; Thu, 22 Jan 2026 09:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC7E6B0204; Thu, 22 Jan 2026 09:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A256B0205; Thu, 22 Jan 2026 09:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B65676B0202
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:30:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63238B8C27
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:12 +0000 (UTC)
X-FDA: 84359834664.16.31CD11B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73EE9180004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lkA8fI+m;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769092209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QaUP5GqYvOIp6c/Vutnl+kWuxjmaAMD80HBgyVxwYw=;
	b=mclaV/7XkJYW6sG7VnaIZbtk7LZLG0dDbz6P2zZ/ojKDk6HyMzKpV+Un63FOZInV/vzn3q
	d4SKD+3hGvjCSlHz1Y9jPd54a9YdjCybMl829wa2TiWDVNWgtV5jTY5RLu+u76GGwjLXqa
	TleXk8UFETJH4f4MhXWTJxJEBi9QXFY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lkA8fI+m;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769092209; a=rsa-sha256;
	cv=pass;
	b=Y3yQwNiPndw82jIqQT/W/KFkpu/3JcLCosaxCr5jhTMVOHPCzTQ2MnkxWpnB5P41LjSW/c
	anoJWpRuMPSaVGE5esz7RV31dwMHc4Bg9ISTcPFffZru3TMWUnfMtEpoFxk0SI4GWaYuEh
	+js1DiJl8BU7b8163v+1zhYIh1hkzYs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=caX409E7m1QqncXi9jgbd/UJkeh7FBjxBT1VBEfAJF1RvVUGfDiCn+acDYn5y3s0Fo8cNmH/26pRNxBIzw/GHyuKH8jrx07nCGANN4yf9OczaMgBbQ2StAm11XJos1LhCeiXGhSeyeufK6G1KbufGkYMQGKGnqUGjMQN4RhZlXrjZ7br1CG704zUdJb/UFUSO5o17B7sKMQjct0qhyO2a0GczeqBPDIfwxbuD3fEnFrVL692Y9nuRMCJreSaYP2iifaCXxHtyX3P55yYb6mYZstbaYpNq6sO3HeRhx9CbnyiRR5hlaz61vj3RknLFV2PG/ZCjpX8OVQzNsHALYum3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QaUP5GqYvOIp6c/Vutnl+kWuxjmaAMD80HBgyVxwYw=;
 b=G86kDG4vXsQAj3F4XDkYMvUVzLTZ9SKlKUjf4HU5NoNZQlne2Rr/CIKnNCyxuhtpn86lh4z1TOs9wvUGtZHLqlpQA+lBcBRjyE2zFH6lW34rL8BObUFObt6nKfPRKM3ogFxa8n2YBSXikgxUdANAzP6R2IyMQ5pwL88HfgnmWnW2kNmF1iQx5oVqIKTlnXI4u/25jMPKk7G3cDz8xFOGFPspcmIobkdm5AJyqZh1DQsP8Job1ISCtJPM3zuCkaE5AtUGLNHLVqcEV/H3iztH6zM7DyDzxCXGv8pDa/2nqNLhUHCAeelVIioCwyy09yYGS8B/FvlB8a7fnjAkIXrIKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QaUP5GqYvOIp6c/Vutnl+kWuxjmaAMD80HBgyVxwYw=;
 b=lkA8fI+m+AtmPWyAoGlGeRvtD3k4aUiQxhdE6+MPbjtWpo92vdLLoPZSeMcpvJua23h6iXhXArhw6AdjWlzcSotJf3AYhsQeN+eUo4K2HcqSqAJAbCopi+wWQN/dM1qdD77GHnn31nAO+Yrmmf4UuXz8RJeX7wjA+GJ0pl6xLjWmX8z1RtmBgQjndw3sXrkMrWGRaaCLYMqAgfSBFYw8dk8lEolWbCCahXnTusmdVZ/GRBa5ck6Ti/AuTSFxfN914aIghm5/Oy1PEcuz1XoafnXS13JeNgMzKFR0SRSo2/gW5jA1weixPBYZnCA6uX1S00zY/ewhgfzZdUfp328Qrg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 14:30:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 14:30:01 +0000
Date: Thu, 22 Jan 2026 10:29:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
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
	Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <20260122142959.GA1569362@nvidia.com>
References: <aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
 <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
 <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: BL0PR02CA0104.namprd02.prod.outlook.com
 (2603:10b6:208:51::45) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: af31d2c5-35a7-45b9-15e3-08de59c2b988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmgvWEQ5TWU2VlZtTTVqOW9VcXNjN1NCbnI1aVJHTE5KQWdkNEF6Rlg5TnZY?=
 =?utf-8?B?d2lZV2MrVkVkeWJ4R1JEQmVub0pTN2pYT2xPM2JxT1EwOHU0aEdUR1RXK2cv?=
 =?utf-8?B?ZUpUOEl6T1F6L3ExK1ZYL21EZUJoWUs5NXJ3bW9sY2piV2RoMDBTbEp6c0FC?=
 =?utf-8?B?aDhaZUFsazQ4TERQaFE3SWJLUEpGMEN0TGlhemI1L2Ywb090UWpTdG5oSmlk?=
 =?utf-8?B?YXkxVThGbzlyMllXK2JzTEI3eVJVNzBaYWROcG51MlVibnFBdzNqNTB1RlQ3?=
 =?utf-8?B?b003Umx6WnhVL0hrY3NIcDIwYmtSQTdaZ0lQMkRSYjRkNi90d1J3ajVQbk5X?=
 =?utf-8?B?c09UMWxESjgvcEhLLzF1UW5WTWFhQlpLS2ZmV3NqdytKQmNkcUlLVFVYR1pW?=
 =?utf-8?B?U2FUMzZxRkVHT0ltaDdXMytJL1A3ZG9NREkxMXhuQXU0ckdWZ085MHVFakRL?=
 =?utf-8?B?Z2F1V3ZJbWp4QTYxV0ZWbVBYZXYxcU9QRldNQ1RJOFI4ek9tcFN4a3ZwM3lM?=
 =?utf-8?B?T1ZBK3dqeXhDcGx6eGRDR1JhdldRdURjMlp3S2NneFJ0SWNmYU1ldFdVb1N3?=
 =?utf-8?B?TWZkL1ovUmhxRnZpNzR5cm1rb3Vjb0lNbTFSOTVYenZhaHhhdldBdWtRc2Fw?=
 =?utf-8?B?TUQrY2svWU9GNkdDbTNGa0U0Nm1rWjVYNElDZUlYSXh4MGFiRFBWNElCWnlo?=
 =?utf-8?B?SDMrRzIyTmZnalBCbmhUdXlZL09xQ0hjcktTdlJsUk9IMnJvTk0xSnJ1b3Zh?=
 =?utf-8?B?OTBMWmc0M2p1bHRVMWc0aG1wNHdpMCswa3hTNFhCUnIwK2ZKL1BxckNzR1pa?=
 =?utf-8?B?cmZNQTdQSE85Tkd4NzFqUXRlUmoyNnh2MnhZU2JVeUcyMUhEamN0WWV2d1pt?=
 =?utf-8?B?YmpQcnRkRVl1QkVkYzRvRm4wdjQrekMvTy91M0hoVEpscGxxcUpSalZoT3N3?=
 =?utf-8?B?TEFPSVpnNWt6WUt4ckdUWkNjNElLbVFnZG0wOWxVaDlRNnJpOE96MEdrK0tW?=
 =?utf-8?B?TExHMzBPaldEaDZibDdadDhvTXFxa0p3KzVUdjFYQjhkMlViRW55eUhCb2lS?=
 =?utf-8?B?eGtYZC82bkpRelJFZTZGdm4ycEZqZjluSUFzMWdFZ2ZOT25iUnlGMVhhZ0JU?=
 =?utf-8?B?WEdKZm81S2RiOG5xQVJvOUkrWXZmazJXTGYrUitoYlh3ampuSlZhWkV0S2xj?=
 =?utf-8?B?R2hoVjlRVFpGMUgzUXFHUW5jc3ZWUXVBYlJscXRzSzhaK1lqTFFuRW04T1Iy?=
 =?utf-8?B?YjVjSzdsNW1IclBPa1JnQ2h1azRTeXAxQi9TVHdmNkRZZFVHMS93eGJRbUFw?=
 =?utf-8?B?czJPQml0YlhpTFVVWU5CZGt1NW5HUWRSQnZxT2FXb2NnSHVZenhoMldLc0FB?=
 =?utf-8?B?VFhwT0xkemZnaXh5bjVmaEorVmRid2JUWjhoZ2RZMEN0eDY5UnpLQ0RSWi94?=
 =?utf-8?B?UG54dDdkMUZSand6VUd1ZkhIRS90UVVVOUhnY0NieU1aUnF6ZW9ja2ZCL1FN?=
 =?utf-8?B?Nmx3S2RrdUtabXZJWEorZHpwOEZVZUdMcVo4Tms4TDVuM3RjSk50WjM2bHVk?=
 =?utf-8?B?SDR3N0RyVVlzSW1sSzNZeUhMTWErQTdYc2NaaUhBdTJxREVJMjdFWWMrekZv?=
 =?utf-8?B?NTRsM0k2ZW1jYW9vcExOUEFHOG1zNC9kOUxWUUZnaG4yV0o0dnhNYWNydWZz?=
 =?utf-8?B?VTBveEN4TTN2YmZDejU3aWhZSmRkZmFTRkZPTHB4aUI0a0R6SjhFQXhCRnpl?=
 =?utf-8?B?bUFHandxUDVVOEQ5ZlVkMUEwRVFpS1FocWtXaWZLOWVVUHB0U2dsUnRQWU1T?=
 =?utf-8?B?WUdpeVBSWXNyT3JQYXI5QzVYZ2xIOWpieCt2R3l2alZFRGFXNldRTmtEaC9Q?=
 =?utf-8?B?WFdGdFVBLzhENlpkNTQveVpjRi9kZVNZS293ZVI5aW80aTgvcGU3aTdWTE9U?=
 =?utf-8?B?cjIxcHFKTmJ6ay9nY1ZSR3VZMUR2bDlVYnEwTVhJVThwOTVnUGZoZzdrR25w?=
 =?utf-8?B?OEI4WkJmTGtvNlVhK3lwdW5GclhlYVdyZzh0ejNLcFpKeDNUYzdDdnVnRjlu?=
 =?utf-8?B?WnoxY2c2RVFwR0NYdmR5ZzNiTU45ZWsvbnc1NUp3YVE4ZzdWdHkwdXE0dWR5?=
 =?utf-8?Q?Q6tk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1R3N1duV1d2MVJNSitWaERWMUV1RzVQVzl5NE9oYjRqYkMzSFJDK3g2LzJt?=
 =?utf-8?B?UFJ6NTZRMnhpV3ZsTWtXNzVjOC80aGJrWENhRjdpY2hBWDYyREFCYnd2UWNY?=
 =?utf-8?B?Q29YdC9kNTNxTDlBRTkvaHNtbllLUkhnWVFScTQ1TTlzWnpLOEorek0zSmdZ?=
 =?utf-8?B?Nko5Qis1YlZKUWNTb1Nma2lxTnpJUUVaTWR0MkdnNXdWU0ZrdGdoLzA3UjVp?=
 =?utf-8?B?U1Vsbml1cU5FWXY2Q2R0T0ppQW0zOUozbHBDT1ZEYStWOGYvQWdGcFpiWjlQ?=
 =?utf-8?B?aFNpVG44RmJ6MzNCSEh3czJDSCtxd2xPQzlHU0txMUthWGpCdkRvN2tlZDln?=
 =?utf-8?B?QTBZSkwxamp4eDVWNGRTOUU0R3FVT1RNMGdDWkl3YzdoVlVDUEhjY2kraUlJ?=
 =?utf-8?B?QzlzdTIvYnJmUkk5RDV4SDZMdzNUbFAvcC9sTkxkdnFzc29ndmt6T1oyNjlv?=
 =?utf-8?B?UlQralk1dUh0Mm9XanNhNktjUUd2TEtmaEVxak1NNXByMi93Qjh0VHF5UUNL?=
 =?utf-8?B?dm05MmtCMnZHcVc2eHZNSmhCVGtKUE5POWhRdWV1UnVoU3Y2WG9PQVlXbHRL?=
 =?utf-8?B?emh2Znk4UDVST09HTExYQkI2aGU4bVdYaENGZDlDRHpoZ0drTDJtMUNGWnM3?=
 =?utf-8?B?ME9tSnU1cUxUMkxGTlRKREFlWmQ4bHVLby9yM21yODJMUFVDL0R6SHdpTkE1?=
 =?utf-8?B?WkJJYnI2V1F6YVVLTCsxU044QmEybnhFQmc0emwyaS9PMWpmb09TU2dkSjlT?=
 =?utf-8?B?MGZKeGNDQlI3ZlRwU3dBRHlrNVJHMy8wdE5tMzI1dTVpaFFOVFFUT0tzZStk?=
 =?utf-8?B?M2RWZDJ6cjc2cFB2b0U1QU9Rc1phR0J0UnVZT3ZQOStRSEVIQ1dzQlB1d3J3?=
 =?utf-8?B?NXJjWHcvZ2JLemt0QWFBT3A2TlVDMFhFWlBBZnZFRG5mUCs5cW5DSkpSblNx?=
 =?utf-8?B?Q3RtcG1jSHFReWhPVTJxOEN3TVFqcE9uMlNPdmdvTUlQVXlJMGVFZ3o0OU9L?=
 =?utf-8?B?dzZYZ1d0RjVMQUJlZnlMVXlLTmE3SWU3K2NRVExzVm5MNHJhaEQwbks1VWsr?=
 =?utf-8?B?QjhaQXFmTDB1cXZySGVpaldSOVdHeHNnWWoxRWN4aTltMDZ2M1pyRzM3RXl0?=
 =?utf-8?B?NUxvV21YcUNPaDc1UVY5VXRLK2ZJTFdSWFlhR3Z6Z2NEazkvSkk3ZFVnL0hX?=
 =?utf-8?B?T1RkUTk5UzNLSENyMFlCaWdxeCtFV2I2MnF4VHIrVVMyVVFEMzIydFpDa04z?=
 =?utf-8?B?TERtdGFVL3lXSTlWTUFXdzIxRmU0bmNFZHM2MHJoSCtSZUNvS0k4cllsV0NO?=
 =?utf-8?B?a0cyUEYrQTMvRzNVdzZNSC8zUk94dzY3UnMzbHJOVTZRS2Z4S3NsYWsvRXZX?=
 =?utf-8?B?Qm9XN0xta2RwRWZPL2liVXBGc1dSeDhxMXpQaGdCYjA0QldmTWZsNFlKSU1L?=
 =?utf-8?B?c2lxRStrRjQ3VldCMzBkRkZ5K1dsVzlhS2tnYkRQVVMyV0hWQjlVSzluRm51?=
 =?utf-8?B?UWJzN1Mzbk1WK0N4VnpxYTMxakJXZVRHdHE3TFZndG42QkhKR1ZsdjJHMU0y?=
 =?utf-8?B?aS8rNmoremxpZkpPMFh5ZE92cnRUVFNWa3BWMm5oR1l6N1BuTVduWHVqTGVl?=
 =?utf-8?B?a0xHUzhMMmZkcW52cHpoc1hhSnNOYWJPN3FncCtMSWRvOXdUNGJOakFNdjlr?=
 =?utf-8?B?ck1VMGRkM2tjMm5EN2FMRWpBQ2JQU3ZPMEVnSjcxRHRDVWl0dHBBTDFKQjBQ?=
 =?utf-8?B?cnB1Vk1ZZXU1cW5MeWJlUjM2dFNIeWxQOGsrUFI2TUUvVjZqSjllQlByTVZ1?=
 =?utf-8?B?MDBRUzFBNEJZS3VnTFV6TVBXdWR6aGIzTU16Zm5ZSHpLeWp0UlkzUEJyMUcz?=
 =?utf-8?B?bzJETlAxWk0rNVAzWDNpWWZSWGZqazN0b1NqVGUzWTlGZi9PZFdySHJxQ2lD?=
 =?utf-8?B?aWs3em9oaDIvWDJ3VTIyRVYyQnZqZGRwUUtKY0NXUTU4cXZ6Rnp5WTBMNmxw?=
 =?utf-8?B?ZGFkZjJVaE1ZTVdBWktEU0hLdFlnZE56S2hlWUlyTzB2M08xcUtTeWpWYURt?=
 =?utf-8?B?aVA5VkE0VFhqcEZDRGxaajRCMzRvRlpHYmhIckpYVFpQNVQ5NkZQTk50TkJK?=
 =?utf-8?B?MzFHUHpQTzdnSE80VVNLelB1V2E2cUpZL0JSNnJrUk4vOVNEREtpbm1Cc0NP?=
 =?utf-8?B?OTZuYXdaM2szRmxaVklWMThESHdsb1lmSlRyRHZOZGJoVGVaSFVwRzZTV21C?=
 =?utf-8?B?UzhSUHF0T1lzWEs5L013Tlp4MktCMXhXWjZiSkVLSEFUOTk5U3hXV3FkOE1N?=
 =?utf-8?B?eGJsWHROMjNoRER6Vk1lRHpUVjN2dW5MUk84NmJWWHVzOHl1S1BXQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af31d2c5-35a7-45b9-15e3-08de59c2b988
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 14:30:00.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMJPdEw0D7v0Xt9DFJ40B5SBzLyBkd4jPHbbNmeJ1FIITNVOyhXQVoaQ9ArhPrKx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279
X-Stat-Signature: h5k1cjybta9jun5n6kjf558pz6dn9y9u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73EE9180004
X-HE-Tag: 1769092209-259063
X-HE-Meta: U2FsdGVkX1+1FsD1V/JZ5VLvnUs+igj8TRYUboUlM3Ru+JCYnbOVfkyRVJarT65aMoBLI+qJQumRvv1f6aUCwifGmMEsCAuTIz6yFsssFZDlzwgXgRKBVwTXdeX3M8C4BDujxin4W8jMXJu19tj3bc9ARwq7nJxKq4xFeCwTcymBr+G5S/jSBgfAqZyIP+xcyBAdamwAKuvYFW5KbrzsIuezbmjy7Mw2eol3bELikjVMICUIBn9z+kabCamcdZ7c3b30tu42DEryw1oUiCVoVfoMtKu9A/hfgGCJS0anx2V21U6gjPOhEt9Wr6y1dcyJvZcSo8Pb13HrCCbxKLjfzfkDqiMxFhPv97dh+tqlXQBNuJOIJCU5lWDgko33juX12p5zhIOg6IVjOB15hz4PeIT19qvcNCPI6aYiF0FbO7X26NpPuQwEkCaGb8r6s3qGHB5fjv0LmSHTKHTO7ji8eV3mmJReRmYfdYqd52okx8HrjGbOBp60D9Dg5MTQv301qWkQT2w9vW/DDUTmhyxwWIQqvtX30rHeS/Z9Zomtg7pZ/rtaRBPO9O1tKDrdL86Ah7JLz3qNPGqv53cAWK8c9ZEFH2D6Zy5TuJ3CEe2TgUTUS+fZle3VTrI43+UkcTVkMqR4dVLFOSMvpNJcvDG26/vaXhFaiL5Tvzo42JTbTBDFaaMeSfyAa/9shDRGglQtOEwIIQIk+EN28doRl7KE2YMgXJutmn+537B0bkNKdUeQ1rgt1Vc8iFaJ4iXK9hg/HOhpdJ3DEtrGj2Ht4GBp6/XrYqJiefonbsSxcyOvhvkfsNJ6b4wD/1glDQpwxGvZce3zWUP4C7OHMfFOgrCTCQfO+BCEq7jAepnSSwW3aFtS11nY1NzUGO8hEcsSgzPGImg7TdTN4cVX0IekykdnQckdw1skYEe/PRybi+UD2HVyAepkSbH5rMItlr+Xoa11hd9h6EudwOmssiCFZT9
 p1kFMThb
 7vicxFLkpVdyEs7PLv4utU9YVxEikVtTTPG/bM4pk7sZ9M/PCYZzt6ld2eaVWJaQsbq42SzFxD2vt5PytDMvz+stkzi+/KjCuPpepJ4F7Z0aWekT66/iqwckn3nDJECm5KV1Yjb/qj2wbBH5Wpaxq2gwR58Efv1qXxPwDAsOHJ1/tn6JJgOyR+EKnYjKQn9EKk+gi1d7NAGi7SMGaaZKMehPIONGRnBW+uYlCWGX3YPshFx3GILYncDEORm3eev/RmBXbBCjU4Y3j/D0PeFX3Bazry+aeXXRi0IQS1alXxX2rF0nmPMxx3pLPoP4dcoKmRK3m+DViZ+wV3rQilg+qpP+8UIcxySZPTV4KMPZ++Gmpsg64+sB0h7u7u+/+Fy1M91AOTfQhr8fHoJkh3p/0+sUxCtTy0sviVrgHX64M1IiIvGXxxR9W0jHabgIFggnalZ8BUuGmY85tjOdRMtIWdKa2vmRfPWX0cn4o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 11:19:45PM -0800, Matthew Brost wrote:
> - Why is Intel the only one proving this stuff works? We can debate all
>   day about what should or should not work — but someone else needs to
>   actually prove it.i, rather than type hypotheticals.

Oh come on, NVIDIA has done an *enormous* amount of work to get these
things to this point where they are actually getting close to
functional and usable.

Don't "Oh poor intel" me :P

> - Intel has demonstrated that this works and is still getting blocked.

We generally don't merge patches because they "works for me". The
issue is the thing you presented is very ugly and inefficient, and
when we start talking about the right way to do it you get all
defensive and disappear.

> - Given the current state of the discussion, I don’t think large device
>   pages should be in 6.19. And if so, why didn’t the entire device pages
>   series receive this level of scrutiny earlier? It’s my mistake for not
>   saying “no” until the reallocation at different sizes issue was resolved.

It did, nobody noticed this bug or post something so obviously ugly :P

> @Andrew. - I'd revert large device pages in 6.19 as it doesn't work and
> we seemly cannot close on this.

What's the issue here? You said you were going to go ahead with the
ugly thing, go do it and come back with something better. That's what
you wanted, right?

Jason


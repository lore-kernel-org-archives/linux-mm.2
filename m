Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347E5D6CFAB
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410A16B037E; Thu, 22 Jan 2026 17:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E83C6B0380; Thu, 22 Jan 2026 17:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0716B0381; Thu, 22 Jan 2026 17:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 194B36B037E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:53:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B98F71A030D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:53:23 +0000 (UTC)
X-FDA: 84361102686.19.4C7FA43
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6E8B160006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:53:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=samZ9UDc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.15 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769122401; a=rsa-sha256;
	cv=pass;
	b=WN41GKXb2RtqOcdKHtqUhmYo6IEO0VJjwttruZfpLpDjg2Hr0Ej8tgWSZ1vLlUMFlnmDjX
	hw4woVCL4DB43p3wRCj/cQQ4QygTiZivYvYTNMXcsiRUKZk09iNBq+IBoauGF7Eul8/p7Y
	sj8Mmso+22655Q1jewjIuMPIEpd5QIg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=samZ9UDc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.15 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769122401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ/B5chrXQRSVDl8N1B3xzK9dWTnqFStA60oy2WXxpg=;
	b=qfEDK366i2LHUwjOIBsIhkjW7jOETnNaz0YC3l46JUeMZDThTr7ikB5JVwaxnPOzPQP0aU
	rvppj5M2sVhyEa8VjE1abngl1uii3hh2t1MwxN13hwb9yFasYEPUGSOACfNUDo/JkSPtR0
	SA9UjY2VtCS25yKgK7bnO8nOqEHQjI8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVHhEMQLOhFUwVjWzrXUNbpI1JRjNJG8ev+1vr18cUAtUtmObjOn9ifLi52CTNG2bsH7uWhxwOJlhxuUIiTcXpTDEhkXpc27sGthsPq3FVkZ/+GGECKgyrtpO3vQGwfpgM8I45sTPdW75Q3iW+31BszBcGCyyvDKGjbPkIQjTJMPot4M47uNvEZ/G+tjOYjwx4UVXGVFDaVm4GU2f7L5PzNbuPSuJKyQe3EKjFbTNyoJqRdnEOeWufdxq4AYW4cgb0LhD8Wg33SGrK1muSzy91BhfnEDimn2wtDgYL61KGyCjb6L4OOXcRCGNACVGqvB8ohCNk0zlxeqBzt92klbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQ/B5chrXQRSVDl8N1B3xzK9dWTnqFStA60oy2WXxpg=;
 b=TT1Vj7qPkPplQVZjJgZ8yuC3NsAPOmAftYG/V7ZTMBp/HrQCUSPnunj9zLjlmNMc5x3Zu699eyOGmyNp+sQ1jFufNAe+ZiK/LjO1IeQTjV9zz7DW+5KyfTaESN9vdYPg/s+ST0RKa40Y+kDzWHGFvedRPSTdEZnwd+MmxBI2GwPx7PVSKFguJx28BfbmVN/fNvjYv3nV1HbQ/E11NNfTUwoPV5J8y2DW6lged4xiPy2edz51Ou/MzRvyYYfzCWT7k3/ucMSDEne0+IIw4cj/HJua7zFfENdTu84Q4ChCXUayqMDUp7xnysu01/rnSmGy7U5GNqi4Qj9GIQ7tocjtOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ/B5chrXQRSVDl8N1B3xzK9dWTnqFStA60oy2WXxpg=;
 b=samZ9UDcNqsSHv3/gce0iNP6dmiwEUu8cSGYS3wbGyNrT0cYF6paVkmWljEDn47ymGUQHYX4FMwqNMq0NJbYzaGr6gWcEkns4yn+KAMzk3B9yRR5NliKl2xMWx0lR4ItdjUl7FaZFe0c/DQ05h6yGyGk14aZQL/SSB0FinUWuFrnG3FKOS4WZYOrjCXaVkVoaUSRsz59KgCVHF2hRotqMD0bPdhn7AnkXQsEZY9/ndpVSmgavP67uzvwNTU2Un6g/ed46q8idwOPsqlAIk6Pr+AtPvg9jVadehdc+aeD7ElNlhthgtYhuvVs7hfWByG9h470SeIqz8yaFG66ABbBog==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH0PR12MB5647.namprd12.prod.outlook.com (2603:10b6:510:144::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.10; Thu, 22 Jan 2026 22:53:14 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 22:53:14 +0000
Date: Fri, 23 Jan 2026 09:53:09 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Matthew Wilcox <willy@infradead.org>, Francois Dugast <francois.dugast@intel.com>, 
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <w37swembg3m2ruxrlbm4xpx4eccvp3fsd7e4shfdxcpmpisk3x@dqsxzkyabjc6>
References: <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
 <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
 <9077ab5b-f2c8-4c8d-8441-631e7c2cf384@suse.cz>
 <626c34fc-34df-4629-baf3-fbebc9abafbb@nvidia.com>
 <20260122134114.a04ddf4c34a4b926d057032f@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260122134114.a04ddf4c34a4b926d057032f@linux-foundation.org>
X-ClientProxiedBy: SY6PR01CA0159.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::17) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH0PR12MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: 0539c5d3-3a10-41ad-039c-08de5a09066b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dk94VXZGWU5TSXQ3cG96dkhld2drTzRXWmV4RDNrYTBFemE2Rys5RWQ3dzVw?=
 =?utf-8?B?SHhQS3R4QUUzbjBLZGg5aTFCSysvSDNPSjBWNHRjTE1CYWpPZys4UUs2UUtR?=
 =?utf-8?B?b2l4amc5SklRTTJxV0ZJaHJZTmFsd0k0dHpXQzNsUXpLOGxlZ3dnRUJ0YkRK?=
 =?utf-8?B?Q3VjYk1wSzlJU2VpSkVFV2E1Vy9SSnJQNVdQRHhrcDNtOU5EZnZYc0FFakdh?=
 =?utf-8?B?QXNSbFBGZVIwMVhUQWVNREZYc2RsZDRzWnlsSy93Rmxzd29JR1VJQ0xSVFFj?=
 =?utf-8?B?Ymp2QkREVU83Y2IyQzQvRHR5OU5sTmhaUDlWQW05dzU2RjBZVTBNTjhpK1Vu?=
 =?utf-8?B?TmtKSktPUDM4eXQ0RWtEUjJEYjRwU2JhWElsTkQwQUdFNmZCQXl2Ly90SXhj?=
 =?utf-8?B?NU1IWDhacStnbm9VUXhGaENjQWZXSXNZUngzcmtkb0pmOHJHZGluc1F1WE95?=
 =?utf-8?B?c05ZMi81aEZzY3FNamkrSTRCdnBGMnErbWdXTUJjVWNLVWpGOGRGT2hkT0Vq?=
 =?utf-8?B?NXk2TDMyM05uckZBOHNHTEtCM3REOTdxYXBsVDh5LzNZSm1VdENuN2ZIWGxh?=
 =?utf-8?B?WmJhbXFZMlpzWTFXSUxaeHphdDM5NUxGWGhTa0tTUlVxdGtpaFdXME9IQ1c2?=
 =?utf-8?B?N2hRbEswbHhGUWVEWWdmS0M1UUppa051eldCcnhYY2dqT1Rta3UxNVg0dWdT?=
 =?utf-8?B?MFNpemR3RnJ4YVhWVHFFcU9PTlF2SHhBMkVpUk1Id1RDQjJNUk5VMWJ1dTBE?=
 =?utf-8?B?L29CZVVyQTNVUnVQOUpKL2xhNEJ0UFYwaVYwZTJKSldNbUhPQlRMMGgxdWVz?=
 =?utf-8?B?aCsvZk1RMlJEc3cwMVhQeUNuRW92VHAzcG9NVHRSYnFITGtoc0p4NDdmTWsx?=
 =?utf-8?B?NTdsVUY2V1dISTJxbDViWVd5QUR1eXl6VFh3djBEL1IwUVpWbHk3eTcrTjRE?=
 =?utf-8?B?VElyTUFrM0N2SnhidXpVY3J6N2tPaTY0ZnFaeW43c0ZLUUJ3ZG9ENmsxRGxT?=
 =?utf-8?B?MGVHVnZzU1RuTmpweDJIVnZuWk1JMThqTlRHOStKcnFwdHpaQ2xQODdIZnUy?=
 =?utf-8?B?R05Zd24yV2JyeHpsYkIyVFJqemVQRHBjNXYySHdlcStWaWlUdHhZNjVYS2JV?=
 =?utf-8?B?aXljb2IvcFRZT2crRnlaLzJnQ0RzbTZwZ0Ura0hoWERXeERhZC91UE1MVDRS?=
 =?utf-8?B?UzhEamNJbUp2Wkl2TDVYdEFSUkdncWNUV291NWxUdXkxeGpjMUUxY2RtelJ4?=
 =?utf-8?B?SU1kSTMvTU5DN0didFNPdUJRQStPQ3RyTENRR3VMRTlzeDRCSHlQZnVDc1Jk?=
 =?utf-8?B?Z0RUcXdNZFFRdmlLYmlKL2xmUkhGUkNTQ1pxZGhEeHlHSEptclpUTlArd2NV?=
 =?utf-8?B?djhhTUdWRXNkRUJwb0hheXZJMWlBZmxMVEVDSDBJZ21wMEJNUjFTRmcxZDZN?=
 =?utf-8?B?a2hWcTlFeXhJVm1CL1pIZ0o2akFqeDRzRkZqQlQrY041YVZVMC9VVHJiRDJh?=
 =?utf-8?B?TFliRjF2NDE4Tk9hRTFGbzB3dFh6eWVFcGpwVGFVZW5qWGlGNUplZTFXVHdP?=
 =?utf-8?B?dzZMa0dZRXlhaGI5QnkzVVhCZHYyUXB1MVdrWGdRcnE5YUs4azJObUFiV2lV?=
 =?utf-8?B?RnRhNFpnb3BYa1VUd2lETDlvemgxeUdUb1hnM0pRVHJzazFmVXpJQVZoSFhi?=
 =?utf-8?B?L1hRZ0gxVGI3U2EvSnN5TzRZZEQ3SGNockMrVkw0dWlzcGxOalFjQjg0bS9t?=
 =?utf-8?B?c3dycUNqSnRqNmJOd25jUytFR0tXT3JzVndxS2lVa25iaGtWTTIvZGpWNHRt?=
 =?utf-8?B?UksweCtCWG9jcVFBVWxYbVg5ekdsVGhsaWlrWlQ3QVd2N2xGT2U1QUxUYzI2?=
 =?utf-8?B?NGhET2psVFNpQmxDRGkwU2F2ckxuL1BhN0FaYlg4eXZzTVlSSWJPMnFCN1cy?=
 =?utf-8?B?UmdXczl3QXN0Q0RTTlFoVEg1UHlyNS9vd1dmU3hxZ3diV3NmL0pBSWRRd0tS?=
 =?utf-8?B?Y3llaWoxOVBrRXE2c2dhZm9Xb1plblFNWFVjaFdzaFM0emwwVkdEOHBFdkto?=
 =?utf-8?B?N3RIQyt5QTQrT1ROUUdoNHZHbnVlcXEzaGY4NUdITEtsbEhBSks2R29zMXJn?=
 =?utf-8?Q?7IzE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDlhN1hYZ2E4Y0xjMGZqc3pKUm9lK05uUy9QUWZYcDRxTG50WlpjUTdmbXlT?=
 =?utf-8?B?dVl4OE1zM1o0c0piQkt4aVlZbXZWcEhsK1Q4bjg5RmlRNTlHUzlMOFNONzdq?=
 =?utf-8?B?OUpZV3BianVUMko3S3F3VmJrMi9VZC9aYVZnSEZ4VHRTM2hOb1pTcHJFTDlP?=
 =?utf-8?B?RytRQTBoLzVZcmxYK2YrWFZqc091KzRIVHpYb2UrVzhYOGY1WEs0cDFBeElR?=
 =?utf-8?B?SHZmc045eWRWMnJIWnV4R3BSQ085NnlLMFg1Z3lyemNmZngvRVNCa3Bjd3My?=
 =?utf-8?B?eElNZ0Rvb0VZcEtXcU5CQjliL0htNllHSUVORUR5M2xkZGN1ZFFuOXg5dzRW?=
 =?utf-8?B?L3VpRC9BVG96ZGIzZkUvNFhrN0Vtd01kK3RBSG92Q0dOczBydTdhNHoyYjBD?=
 =?utf-8?B?a09zYnI2WnJHcXp1ZGtIWnoxVXQ1N1BrQXdidWxJV0VSN2gvdlJWWjdENVVw?=
 =?utf-8?B?VGorNElnelhrVnpNVHM1YWZJZk1ONFhEL0FVRThGanNaV0J5QnpNYUNkZzM4?=
 =?utf-8?B?TC8yT0hlS3JnTStuRUY2QkxRLzc1WkxXQVJ2VUlRRTk1SHkvMDg0LzdXMzk4?=
 =?utf-8?B?QWF1dUNkVFNJRmRuUlQrQ090UHJWTStYN090MmNaSStlSkpFZ3J4dFZuM0Vu?=
 =?utf-8?B?clVDbTFSeG5EbUhBS3JiQm02NVRnSnl1eTNORHhPUStjOER6UHhmVmxZV0Jh?=
 =?utf-8?B?ekpKTURuWG5RVFlTRTdsTTZuWHU0ZlRqdHpqVE5nRWxyK1ZKTzRDUE4vR3JX?=
 =?utf-8?B?bXphS1JDNmxtMHFOb3E4N3Y5MFd0bFVyZlROd1cvRFpQeXErQ1VkM3hXUDJz?=
 =?utf-8?B?S1B2MWtRSHJNeDhpdFpUclNoVzRuSkhsd3ZHYWJTNTlvYnhHaDZwY3B1K3E4?=
 =?utf-8?B?V084c3V1dThQbEdrdUprL2F2RTZ4MHZ0Uk5wdTVPSnNlcDZUN0EvQ095emsz?=
 =?utf-8?B?UWpJZnZEVkVjWW42MVpjODE2RzllTno1cDBLNG1NZWI1MDF1ODUvd3dQQ1N0?=
 =?utf-8?B?bW5GcWJTempsY00vaENPRDNsRURrdGFpd3BNNVNZMm4xTlBuZ005QXc5T1FR?=
 =?utf-8?B?U0RpcFFVaGxMZGdncUdYb3dwL0g1ZnFKMzF0Q2VDS1l5RmZuQXk1ZDhwQVJI?=
 =?utf-8?B?NWhPdXBrVHMrcXdCalJRWDV5TXpJZTR3VGU1NXRlUDUrTDJmc2dHMkNLclJG?=
 =?utf-8?B?UTZwQ3hIb3JMdWZKZ2FMNm5SeG1haGMxRkFCSUhBNElKWEEvOWlqaUM4Tm5w?=
 =?utf-8?B?TVR2cVFRRkRiL3lXM2xtSmpwb1FKZ2pyYWtFWXNNTk5VdFBjbWJrTE9pN1pm?=
 =?utf-8?B?eFFSNGEyZWVyeFF1aExya2xyUStVTnI1VkpHeVRaOFo2M1dOVWJjOGFTb2FP?=
 =?utf-8?B?WkVRaWxoKzFiNE1Yd2MzQjJOaHIzdlZWckNaRUY5cTBxTk05NktURVFhZk8x?=
 =?utf-8?B?TEFYb3FxbzlmYzhqMFhUTFc4ZVBwc2dSUjhPeDMvZFpqTnd2bStyODlibjlJ?=
 =?utf-8?B?Zll6R2dvM0RUQitaQmozZ3hGMXZqOGg2V0VPZVhBcXJ6WGU2b0pLNVp6SFIz?=
 =?utf-8?B?T1QyaVNWOCtFTWNuSElsY1poazNvZkp3Y250dFVqNCtuT1B5cUV0clBzczNX?=
 =?utf-8?B?RFJwRWlZNXZtN1k1b2FrTUIrV0ZkeWowUGRDKy82dVg4SlY0OHVNRk8xNWZx?=
 =?utf-8?B?KzJxV1VtL3NWUHY5VWZBUGRxWXZHTWtGQWhzNG9mdUR6MWNZdlFKTW81QXkz?=
 =?utf-8?B?Tk9XNVM1NHVzd2JSSHd6UVQ3WnFBSnFaNHdIazc4RGh6dXhZYTUrY1IwNFoy?=
 =?utf-8?B?eDNWenVTZFp0SGNMSFlabXlmQmdRZkxSOVdEY2dqbGpjWWZyZFpTaEczdUJh?=
 =?utf-8?B?QkovQ2tWWnRYcGhoSm5oOFJGNTQvTUxHT3JVUVJvYUpNaVlGYnVycUZiQkFn?=
 =?utf-8?B?c1BJZFZPdU1uYk9ibXY5cjJMVDFEMnhsRE0xZjZMUjNMK1RlVW9nOWNVcHlL?=
 =?utf-8?B?Uk01SzI1V1RBOWhaaXcvMWh5eGxJRVBCOGtKY2MvMEUyeUlZaVVoZVN4N2RM?=
 =?utf-8?B?dG1zNDJJVlFLT2hvRzY5czNUaDJQVUdhZFh2SDJLbWJlUWIwdDlDMVpucnpW?=
 =?utf-8?B?aHczTGZRbmtoRzBxQzRtVDh5RHhmRVA1ZWRqSEZXSC9rL0JpWXkwejA4YkpM?=
 =?utf-8?B?cWxydUFZSXk4SjFQMm5oT0xQaWM3UTlqdFFaQU00YUZUbUs5WGRIbHpubUly?=
 =?utf-8?B?cFZxNWFpcHVhMUdSSjdmTjVJYXhqdjJSZ0R2VndOa2U5YUhuMy9HVDRLdTNz?=
 =?utf-8?B?V21aV1dubGRxUkZGQ1JiV1lRM3kycFYxclNwYzhNTWFNUS82a3J3UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0539c5d3-3a10-41ad-039c-08de5a09066b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 22:53:14.3973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHeEW4HH0f9kDMOX+mBI7IlQW8rQqvNRvgbQrS3N5MbQ3yLy1eE8iBzSg/WbfwOjO4cMC3Kjh5QUhT0mglaeoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5647
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6E8B160006
X-Stat-Signature: e9r116poocohj7herha9m193dxrgkqxb
X-HE-Tag: 1769122400-540066
X-HE-Meta: U2FsdGVkX19mseQGaThtxwTf59+jezGOlOX0KyNvK2FFsFiAya6DUc/JgUd2iwj0+ZaQ9iFCN/Me4iPdAGuHtT4Sj+ja2aoysjEjRaZpOu3DxQVYM3pzt5Px6tkd1IMePCdS/7n+W8ncrKnX3YirtCzXquCjWH+xVPp2OFJbQrEA63iNVt/37hrMCWcDe7R2MTnJVrdeQgnAfFQ7S1IKtseo3j/OGfS3VJZgN5yYRgc1woxR5mhZ8lhQhqHb8ypYj/rcHVgnpa/pBIz8dI2hYtmEKPT5XKILlOTntIVWdT8AVmTznhQb+GJgFdmBHJsit5IVAVtFU/Hl5GrOW2lzP8yjqpPl621P6WiQiFyKnpvTycezw065DIrUO6xg6kAY4WelxKRb6tzdK5roVLvDkAovxZMKW6q3ZQOMHa3in65na1A17k/ZBzEsHqNITRnU74xydoSnlbs/6ABysOwfq+PC8GGzC3qAoqWDNno8JXUo0PD7iY3xMCtO3Wv1Of06T3yfEYkRfLu1a5Pa83pT6NGSGy9h4g3F1rZ+Ap9hjKdndTGTiK326iiqEY+YF8YTpQaOgE4zyXM1hZC2vYRR8A9pgvCbnzEMEzW0flo0TLEKxFW9RdQdS/BD4bq2vDm/8KWc/WcdT1CFgndDYzldLSj8veYE9x3+3ElDPqmeRJpxskkuQsdUx/xAxjmA64ZyPy37D1JpR+yTLhdVPTLTyCeliS9NIWSI+iPv+3I/bWepHQ6Q5+ihwDW8Ot52/cYInkNeiiaQDK7UmoA6dnoItbco/cst6naDHfZ/e7V+cSsO+CP3Cq9bbb5jGskBQyk89Szc1e4TbEvR+gyUZtj6loIwolIH7t1rsR00LlR6U/E2KTVMbVU8u/sxgd8ciAGREwkgKF5V7IpOl38iCgcYI4bis+tWKgs2dnxE6B2ImzQ5GOU947h1JHyS1BZXPn0V46uVb+IiHnGrhRxZOfs
 5cMpqKDb
 AsmkdofjWrM3FYtAGz6w2ISvsNmL9cVhOns2OMrZZyUBZuyw5oMRDTS5D6KJ9V4gEk9XyBD5VfHWpt7TKe03APJ0LcqS1Eq42NqKTvhl0JBUmD/lEVHnYWqF52D1bTpbNfxBnfrz2qhKHhtol7jAQMhyOjla6AJUu12vTMzW0lW0whCWXoBOUc+YREv2vwclDqNvZnWAfM3YMfzHxjr8M0NRhvcIngPv+DWFgIU74YAZlwXkigCBjbbBOrihgv4GJ2cpl2zX5Ac+dEYetxotNYfPVxDi6duvFNZjCle5MQP/s57fokxtaCnQDkCkbh9KgXyDf9uXyQ6u7IMQQYxd72s+DoA+Yvmi0fkHzGIT8DlgeEEGx1LJwUuLeFiMnXKPHdpDAvPTOdx57C+ctyqJRIozzhBlvbjDTeEphGv/T1HYKyxSu8VD5FYYGt+RoYNU8tGyfH6n+o7W3Tl2qWimKeqbJkdJfPjmUTKLPAN3/MH97kXMyJfar0N1iN6/vm3IcZK05UqSjyDrXItCnzZij8OuZKbZqMG+wApU/hT1mosKxFXskbYhlIBOEB+j5ZAptwqtv4dnISKDeSE08cx/+nOzSxzB7yeu5EQF7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-23 at 08:41 +1100, Andrew Morton <akpm@linux-foundation.org> wrote...
> On Thu, 22 Jan 2026 20:10:44 +1100 Balbir Singh <balbirs@nvidia.com> wrote:
> 
> > >> - Intel has demonstrated that this works and is still getting blocked.
> > >>
> > >> - This entire thread is about a fixes patch for large device pages.
> > >>   Changing prep_compound_page is completely out of scope for a fixes
> > >>   patch, and honestly so is most of the rest of what’s being proposed.
> > > 
> > > FWIW I'm ok if this lands as a fix patch, and perceived the discussion to be
> > > about how refactor things more properly afterwards, going forward.
> > > 
> > 
> > I've said the same thing and I concur, we can use the patch as-is and
> > change this to set the relevant identified fields after 6.19
> 
> So the plan is to add this patch to 6.19-rc and take another look at
> patches [2-5] during next -rc cycle?

I'm ok with this as a a quick fix, and happy to take a look at cleaning this up
in the next cycle or two as it's been on my TODO list for a while anyway.

> I think the plan is to take Matthew's work via the DRM tree?  But if people
> want me to patchbunny this fix then please lmk.
> 
> I presently have
> 
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> 
> If people wish to add to this then please do so.
> 
> I'll restore this patch into mm.git's hotfix branch (and hence
> linux-next) because testing.


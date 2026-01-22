Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA9AD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBC56B0250; Thu, 22 Jan 2026 10:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6716B0252; Thu, 22 Jan 2026 10:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E206B0253; Thu, 22 Jan 2026 10:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A26566B0250
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:47:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7077713AA97
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:47:06 +0000 (UTC)
X-FDA: 84360028452.20.5B05F29
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7651140002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:47:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NeztxjFf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769096823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urLRoIBEUIKjiUtuMX6/RhXFrlQUu0ljUyUgyCTDCgI=;
	b=q0fF7wknfJqCDcaZ6H8uWQi2Sz9HWaBNR96+cz4Ff816jcKGALB3rSlMeFi3AD3w3D83pi
	0xMq0gFRYJSDhvKvpgEwKv9rqpeItHfbZ0sksVVUQ2fxVb1K2MsUx4fYVO82+fYnDKBCzr
	3Hn11c4BZ7ZaGUnfByHbXl7Xm2cqzhI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769096823; a=rsa-sha256;
	cv=pass;
	b=U85/laoORnwDkhR0DnYMSndoGBYNlLI80yDJ4gTTakC+oJG7KB9dZ+RGxWm19Fo9DhJqJn
	UYjtY2whTuXmA3qeuKZuZLHsHQ4dguTTccpky+bEiyWD9Xl4ahOq7j/wRZYk+YfljA4tXo
	cOHENfxro5Gvwp7U80V78/rfL+B2atQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NeztxjFf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1hntf+J10Wc+3Hv7poOapR5c8+zLAhhvTiisk8s5Q06AvLBI4+Q+q5xSw0qb+ph5634Y4PP5bnf/ddv6MS+GgxiO5N7/q0wenCky9fmpblNSFiSFaXwARw+f1TKJeKK95u/1qY+UHqiDXt0SHhc3+tnbVSdoUnHYngsULkOUZgLQwYFhUEVRnFo5Gaohf0tOfxh1OCw5zqVvZZQLvLmLLY7ppkcaBgRNImiSj7Dmtdqmk7RXrRcUlEKjEj01LnbHCng0ZMDercma8b3Vda/uJtuSFlBcbXk54D9MCpnObIoEUdQiO9bWI5rhdlIikkTUKPZqh63bSD1sxMRbhOdNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urLRoIBEUIKjiUtuMX6/RhXFrlQUu0ljUyUgyCTDCgI=;
 b=zBWm1JAqg/d96H6sksdKd4YBdInKj8eUU6/NSPZ0gtcArmTaDNMpeh7oG8Ue/FcPSJbJo0tOZveibmPfYFlfsIfw5GgJJGPS3WykAVXAZhjer4MppHajUBWf3AfAUJEEBU+90y6LVFYi7HOUmIAFqaqL1Puo8D8I7Vh1leGn1gJ+NTB8cNoGoF6GSi4+5sjlqo8PsU+zT2Tq9pknb5WxbEsyW1CtdZus8fbHLCIePJe+kJxv8f4brkAi9jgaHtavUQ56PUxiEpICihXYX13Wzb94HMBzRl0Lg4QAG7PAxi74fbpoosBduPeQWMceT4dOGWrGtMgltKQYLxVSWTX25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urLRoIBEUIKjiUtuMX6/RhXFrlQUu0ljUyUgyCTDCgI=;
 b=NeztxjFfb/XCKZywgF1ikrJGBwwFfT6XHaov7k8FJ4XH2JOScFhCxjUfVsbdAsXEY1WzQz38Ze9r5020u+EM6FwhDw9Rdcs1S015xHLv4YMgdwdPnj1c9GjTktDPRoIi5oP21+AST9VjoiPoBRvbtCI93yxDur+FNFkveMbVpoxp1FcOGTP3OrOb4Z3zFidocNRyCp8+WOLaOL5EEzDeLywzVMOPW7KkYBdhg2PsP+b5etRuXkvpQBzBgqGkEhvccGtRmGu0QxeDRXKleXIfJ/nXXltmPLi407y9Xba2atb+0Ikj3WQt4XJjXoOo2xlSTIi/5KD7W65sfMhpkf8Dug==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6556.namprd12.prod.outlook.com (2603:10b6:208:3a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 22 Jan
 2026 15:46:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 15:46:47 +0000
Date: Thu, 22 Jan 2026 11:46:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
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
Message-ID: <20260122154646.GQ1134360@nvidia.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0363.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: 6619fffa-3efd-4f3b-38fc-08de59cd739e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ohj6vJhRcoQx0d14rJ+KUVn630uJ0OjyBmRLufFHoNPDUq9wqhGhBsSWCyHs?=
 =?us-ascii?Q?5YPxYiPGzbTI95G/Tosh/PEWY4YIxyKqM9P0/QFhWN9H+mAkzdX7BMLUzDCH?=
 =?us-ascii?Q?Wn91BCJnDrMXYm4EUJICmdzS0aQofZS16JC0sAQDjt3qTv2N1wtbBCHiNw8I?=
 =?us-ascii?Q?vUhWQIIWF8Qiwf13QX48aeQf61Lr0T7AN4a+nofJnV68KFlMU/1H3sp/tVf7?=
 =?us-ascii?Q?6Uj1NmizFTB6/cO7bWwvKufbN0o64Zi/dul0yyQFl6IZ8hnMBo/nafS5FpZJ?=
 =?us-ascii?Q?eNzuVqNsk9mIUOLmxZwJICLZBZZ6jmjD3HO2LPkxRt/lsRjmVERA6FLE71FP?=
 =?us-ascii?Q?WsPStBDbYELQ/N0BdXyKRV29LLI7Ny8/L12N8NJMqUY3gOw6ka3j3UQUgVHF?=
 =?us-ascii?Q?YHxYfwN8u9zgOznfORp3xh4K/EDQLFIw2qUYuEOwIEdbpNTBkP4xwXw3yzuw?=
 =?us-ascii?Q?qI0NjfzKRhBQtRStUetRK+QZJjHOgAPtSA6wPc8JH5oEqClCOcstWw4WcWpW?=
 =?us-ascii?Q?PwmIAogOgXtCUpr2Qp6CP9X0TufJOp+VkIm1uj9PHuFFeU1+0R8Y93g1qIpN?=
 =?us-ascii?Q?vwbDHpKbKdypgBOD5MHFvFX4JOfc5KHLAVcrcBrIvDi2pOHUNSbPZKKAe0TI?=
 =?us-ascii?Q?/4h8CXIhFPf7em/wcWgkmMaG0Ig9RlvoIWz1XRm+JfytRqhoiLD4gYIJzXKP?=
 =?us-ascii?Q?ZsGRoSSt+WAe4lCSy2sbG6rTCZIuIAKRsdDmh5MwHUy5FbQBmJ67RRgAx36+?=
 =?us-ascii?Q?0j4uuTs7j2ZNJPJbkbDV6b9dFyG4m8Rdm2UL8rbKf+7/wldoB+jStJJ8h9ic?=
 =?us-ascii?Q?kuIKwaz7Q9ZkUL0ih5rIeFisPLf5vWZ6O7V06+TlbqMD+5oYJZCDxoBf9aam?=
 =?us-ascii?Q?3FENRWgqoE/vnsMO9aWgfpckUgP3Kar6EDVCY3AjCbFAZVMb2oyqeA9udkyN?=
 =?us-ascii?Q?m7w2Scy42T4M0KsrKK8Y8XDe5hHecvKaIku5etlKUV4uNiFdw2bULmVVAncB?=
 =?us-ascii?Q?CPbRGF3S+Cw0jWbeTi3fixQWx559sCNbqikUUBAVmsw8RBKSPI+JVPUV7RwF?=
 =?us-ascii?Q?pLWJxni5bB3uZGd3a1aiTPnhrFsrKnZvkZoYpNhiJ1NMLBQ85sd67DH53YY5?=
 =?us-ascii?Q?lB/odiXJhICIDrK0EtAdUy1aCwQsNF8PTI519VIVKDJ+GXZXlDKofSWT0YUd?=
 =?us-ascii?Q?caerQEosFEqZdm6lJGmJkwPet3yllCN3LyPobXKRrxRpgVq6oc/zkPLu6QCC?=
 =?us-ascii?Q?vHGm1ZmSd2yUOaN6VIjjcX+l1kzEfSUJCWYH4hue+IhHpbJKQQBMdfEvqtGc?=
 =?us-ascii?Q?UHlmvKsPF8bHftyzqnCIbTF2UjTAqIoXDw7jEvRWhGFzitJP2y+Tq0v15Gux?=
 =?us-ascii?Q?YKbjfR6F+ylGNATaeXrun93eJzhM+prGXaa+LX6BxtWaQWgV/K35688NF7l2?=
 =?us-ascii?Q?gqailK2Dwl6I8WBRCvmNfYjBvQeCAEx0diyWoLUmt8QGMKB7BvxY1CCRSRQX?=
 =?us-ascii?Q?Ym2O2PVDDKSItKO9pjcjE7WutgsoqKtfGagKU0I/HWLx1s4U0xuQyJmEOue6?=
 =?us-ascii?Q?ftfkYvUaRqSr/VDgWQA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E5Fs5KJqLjfrfdCxIzohuRce/HV8FgniJIFkYD4lqISS7ma6j3xVErWMm4CA?=
 =?us-ascii?Q?ssbKy8+xYyEDheYDEu80czgFZxfyxrCGnOe4YLJiVD3saDbtU3wdoZIfzEJK?=
 =?us-ascii?Q?asGVYAMLbvgvkVHLwvKGAVcTj+RArzJcSO5Yo+jKmBTRpmI0DMWMVH1H6pjk?=
 =?us-ascii?Q?aQGXK6fP7MLASzuS2r6OQNYaS7UTM8CR/xppROWd5BfDUYoAGBSo928klec7?=
 =?us-ascii?Q?sg9Z1LsIhaxCAvEGpcvZc6FEjQnMUJpCBTIZ4Gxj1FDNRX/OgHXHGkkgC6Cp?=
 =?us-ascii?Q?lt22OYx5eidO7HBBhnNhIapEQh0asyouPbFl/sJ1qtyEszYnEKWtSNSukJNW?=
 =?us-ascii?Q?btraflU4GZHy1R2uf4IQCd/MyMwCy0YTGOGK3UbjK03wAemqq19PiBR33huS?=
 =?us-ascii?Q?bll0+Sx0umj5xU4zHM5rc5JdMFMsBvEyTkW6TesZNmYiMGwqFr7riOLCOgx1?=
 =?us-ascii?Q?j5sFdHv291N95kv/WbpI6jooA6wRHJAS36NE15piwyju3PznC4+OSEQ4lTfc?=
 =?us-ascii?Q?q9PH01RHNZJNHQhbRzeibQPKyAx6Y3FtyT34VGCL9NmIKBBA//AbHVJsES85?=
 =?us-ascii?Q?fCEhtl3+D6P1kAS7RjSKqu9WRGaCNtmTydxJKeEOUQn+l5vuX7ePYXBhsaEM?=
 =?us-ascii?Q?1d4dmhNSOyaPSAkwDbhs6m0VA1Ko4UvhrXJ0FhZe5kW2qX0sU/wD5K+mvAeD?=
 =?us-ascii?Q?kuB7jBYx84y+NQng2Sx6r2qNMDAqPiAyLnKxZGwjySK7ztDNgBIBNOpeicmn?=
 =?us-ascii?Q?LBPsd2axGHGIVKY1cQpjIcVU5ubYaefwmdu043WIg6ijffnoyM4BTSzlJSzE?=
 =?us-ascii?Q?XY8OE+gItu8mNXewXzCtjOIP49xs3i62bmGaHRQRxNB0Uq5A+JzKBS1ARlkG?=
 =?us-ascii?Q?ogGzN13BMsneyWgQWsfEvnXGedVUeG7Q4exZDQcSXAeD7GmG8aXdBKdNj6+U?=
 =?us-ascii?Q?q+oqISKb0MS9aJSMPE1WzS24VrlXCgqCHV2CptoOYdWQ6/iSon6dAe0fQl69?=
 =?us-ascii?Q?RG4Bq0wpjUn6hYYwxWE6VnHiBWQEXOoAZZaXRoY9Z6LZMMRhC4hYAjeJ8lr+?=
 =?us-ascii?Q?ek/Cn18vYZRORri6SiD85LkClJ46PklsEVu3DURgFXwLa2tfHga5C4XUneoV?=
 =?us-ascii?Q?y1vcsuK0Cg6CMBzsKTwjbHyc5FyXcsW+KgPZjNzTAkHeJEERtvOxvDlXTMv6?=
 =?us-ascii?Q?gVsR3469y3KZlcLoTM/661eHBBCkLO6n/sHjqLoSSWorSOEgkCMfSapewc6Q?=
 =?us-ascii?Q?Xnvc7JHSh6hOgM+Sgs9JcIb6XkLx1soLqWQoZa/GI5tgaMQXRYesLe0/hJfq?=
 =?us-ascii?Q?1aOk43ByRVAGMl1vxoXr2+3FO4h4hDwF43F0gyEj7UiwLoLOe5vZEhEHwlHy?=
 =?us-ascii?Q?5rLL/6oxihjaRSog6zrqgBgIKXpui9eerb17ERs5CEgYAIblX34y2dZNAnEC?=
 =?us-ascii?Q?HSL3iFY3eYBZcXjKflIW1BWVpPYpNht1//WJnyaKMDVqYpolMqwNCFM3YOnc?=
 =?us-ascii?Q?+Ce9SmKXLd8f+VV7WoYMuSCUMHcs8ZS4iZRmtYNLbn0msHoyavh7EzGsgKA0?=
 =?us-ascii?Q?pqHgZzRRVm/wJUBb1L/wA7vvQBwEWkkzcv8sG9rjxNx25haKT3hnCQgzMrYD?=
 =?us-ascii?Q?iOH+A5Z98zU3GUJPipZaNiaaxcex0BAvP9+tB1icCV871OqXSjYUvWY1RRtT?=
 =?us-ascii?Q?x+blK5vG4fjOVBDIvK445VpbdQrH3qG+obXZwRJ1iuQcXOfIlUtTQyTAhN3T?=
 =?us-ascii?Q?lUMOZfpMqQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6619fffa-3efd-4f3b-38fc-08de59cd739e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 15:46:47.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61UuDPbnbQgYaKMW5ue6PUb8TuV9NI6UMg7dVvAEh1C4w7RgdricARs5c63CAC1w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6556
X-Rspamd-Queue-Id: A7651140002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5pmrgsydw3c81bd6yxjc8r5f4rsjrjcs
X-HE-Tag: 1769096823-242381
X-HE-Meta: U2FsdGVkX19k0aXOiwlolODt7gm4JXCfkzNGDP1Wbo3UDWrKD8+NamIbDc6+B7SXZNZcuTFExTwVWEQ9boamqCkl4qu/oMBvOTjKubblcnoOt9sAeE/fRIvHBjZaAZDq8Ep5/8w9NLXRWhQ6OFyviOwelGNyiguFvPVqq0YbY50QQUjXL/Ipb4GCO/SrnTxbEWluX2w6mE9YTlECqBU2iFo7X/wxhroK02SpM5xHSMqTuJvP7x0fbqG5s5LTjwGtl0ghU6sG50mdqYcks8mJmFgD5FZN05GMTFgQ5jCfRueE3PPFg50IBR0GIcsSduGkDjEluQlbihDHpYVKi1i0sGZoJkwH7l2/SUBsl5MSHgYKQdECwfwteTBhAZvr2/bOPnZnbIZJ9/0jqwz1YArZaqM5gNR81PIFsz9v1fh9IwjFZx6Q4cjLvZ75+dKybm7LnGHuN7Ms5PW+unnAlywrGGSLBz8YRd+ZLYRdMbN5jnBgJpJITA9upuWWN7jbw67JQck1ih7Cqt/OUtYKcZ5+12HvERLqSSxuRJNf6w3GMzRM47udZbmRZ7e2NusjpNWPjsCT9nz+OjlRTHopUTPHBiM1A7Bjf2Ms1IiOw+v4AYvMiHvsek2J0dgoyq8ptQqJmforGlfEuMEGGF/LqiEEhfeYNB9iYhXbiW9tCkM9BZX9vk7KL13OdQcTOxEbItFCVRdoLXZS6Wv4qdlHyI8Z88dNowG2DyCbhO5Bmvoj49Kl0XenXJvsY8qOHYxvX8GHnrb1FIYB7zM9rcPFxoAECQy9UVPeUnYp5TqN0YBbgUjYb6+4ud/71YQNiJdTxBFjOpMuCklUf9x19PMMjYSe3XZRTkgzsgZCeURq3QMMlMKRfLgEg1oKDkAcjRtOdIY2j+BTVTHcwUFbAE84UU3TeZB/A9VoQDbpA9aTJvxZCaiS0nh3FGxIWr6UNwUtHvG6ootfMB/agOpJe1Lsnq2
 nLMqzCrX
 r/8O2q1k+rmKHMZsthqiyLYA+mk37hoKZ15DLdjCPhJgHMhwDY7O4sZsv2FFl2sIWLbXchwX5hL/sGbpe4SIZHTsFfXMaU4clgoxpMb980+IQWyjeJfhKaH+pLYsVL6QnrbPFUMF+kJS9qe2zw8iKcZhm45mNNjxTX6tR+hco3g2rOioKECxYNJggtc4h8udrnZo/KEO6YkYJeufYVrLbHScsoQmP+VrqnjZhZJ9/Z1jH//iQ7NtfvWOgEQc1ffwxyRyC6Q6AsiQzcLu+FmQJV+3qZ10LKADR/jWI2Nz0xQADw/84XD/bl8k9D4DCA5vOJCq+Nvq/zd+NCDX7bwtbuhY52elrmiqkqiZ5fEymEYVvvYbmYSHLw3NW3dzQSjrP2ab4i+Os7jmjl/ReRQv99TdPz+8KMX4Smf8dBWbQI+ICVNCvC8IAbya5eR6aCUodLM6ozRqRkUsG4vw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:01:18PM -0500, Zi Yan wrote:
> On 20 Jan 2026, at 8:53, Jason Gunthorpe wrote:
> 
> > On Mon, Jan 19, 2026 at 09:50:16PM -0500, Zi Yan wrote:
> >>>> I suppose we want some prep_single_page(page) and some reorg to share
> >>>> code with the other prep function.
> >>
> >> This is just an unnecessary need due to lack of knowledge of/do not want
> >> to investigate core MM page and folio initialization code.
> >
> > It will be better to keep this related code together, not spread all
> > around.
> 
> Or clarify what code is for preparing pages, which would go away at memdesc
> time, and what code is for preparing folios, which would stay.

That comes back to the question of 'what are the rules for frozen
pages'

Now that we have frozen pages where the frozen owner can use some of
the struct page memory however it likes that memory needs to be reset
before the page is thawed and converted back to a folio.

memdesc time is only useful for memory that is not writable by frozen
owners - basically must be constant forever.

> >
> >>>> I don't think so. It should do the above job efficiently and iterate
> >>>> over the page list exactly once.
> >>
> >> folio initialization should not iterate over any page list, since folio is
> >> supposed to be treated as a whole instead of individual pages.
> >
> > The tail pages need to have the right data in them or compound_head
> > won't work.
> 
> That is done by set_compound_head() in prep_compound_tail().

Inside a page loop :)

	__SetPageHead(page);
	for (i = 1; i < nr_pages; i++)
		prep_compound_tail(page, i);

> Yes. One of the issues is that device private code used to only handles
> order-0 pages and was converted to use high order folio directly without
> using high order page (namely compound page) as an intermediate step.
> This two-step-in-one caused confusion. But the key thing to avoid the
> confusion is that to form a high order folio, a list of contiguous pages
> would become a compound page by calling prep_compound_page(), then
> the compound page becomes a folio by calling folio_set_large_rmappable().

That seems logical to me.

Jason


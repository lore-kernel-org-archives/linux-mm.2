Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2503CE6BF00
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8859E6B00A5; Fri, 30 Jan 2026 06:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A356B00A7; Fri, 30 Jan 2026 06:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C706B00A8; Fri, 30 Jan 2026 06:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F79F6B00A5
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:14:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3223458FB7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:14:23 +0000 (UTC)
X-FDA: 84388371606.05.8AF412C
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A68CA0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:14:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B1GL/mD1";
	spf=pass (imf25.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
	b=svLoJWFaQJsobO9eWzJdlV4HhwC6bkIQIE829PicX+oPZ0OveeZ85QMtzNQFBNj7aQbXWk
	BGkUsf0+JqTab0CSMqfC8b0IRvt903wKENcU3VFFkE1l/bBYE9iHZZkO+qsH7rdOYkfePE
	LQfpMhaFoNAQ/NMziQDgF0PBXEPos8E=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="B1GL/mD1";
	spf=pass (imf25.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771660; a=rsa-sha256;
	cv=pass;
	b=48HkIMnXsKuDEvhSlVFKFDYb7Rfada6hKr0KbNtilZU4da6CBfCwUAhJH0riEcx07Fjjx5
	RXzbis3EY5QZ0EzOVzCu8j/jxvF7XANIV8J6FhS6p8o3ujPdYixyz02XOs8eDkeHMnSQSl
	3589TOsgB/qn1oxPhtUMpCb0jUY0Niw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJuHkny94wMHD5/XYZYudfdw0SD/46prJe0zkL9hoQHTaV1E68VFAYTlg7OBiHYuzfeoK/fVLokVEKDtW16vYPASnRKrJe8xALS5x4IiWoT2FKNi3PkzMh+0IUtKMAsPKdedUq+QfwccouY/rlmemehB9DNacypjEVqM3FoZeHNhoGIb5euHcH//rfTEdqIeG+ptfTGLcSvkCcQfx3m4nFMwyranLJb+askWRd9chh4dGJQm2dXJMg5aHQHsb06d5XDW/sf/iZf9sjNeGwESp+hUWLanotN/yDRsciv/+QOKT0uP791xqPVYtKI/vxURL2qqtU3o6FQ9YywOoCV3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
 b=xDhQpV4YE6xUjc9A6UB4KaBZaMpeHmTeIqzJMrVmPMC3agf75d2sBuEDmztDRdmSG0Vn0v/EiSDXth1m7Yqjjea1alalDY0m4oYYUk9AZpwkjLnMxkCadd0we94P0Du2P5/LHghSNFnlsM8JR7VqVKp9QP979khTt2J9psQMU6Dz9eyaGsYxOWKaWi+CKuDqJoxp10zYClK8iryYd2cFYH+/XAlKUa+Tyvfu9vlvoASA80o851glw1iWeMGpwraFdDEtlmn5hE2QPz2J218ouh5UTfBPNtj5evoTGHWqFxEy+HJEUimNCero47b7gx/raVN7lc3q/c3fO1BsptTyHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy8hV/i/DFV5JHYl4XI+/zmR/Oa4YzgS4cgb92MksjU=;
 b=B1GL/mD1Td9Y5AZpVRTtCer8n0RvQoB7HOabqGu/FuF0ZvUY4MSK0i7z8j/YxiBTJIto8EZkWfaFNTl5wmXME8PrUFJs3gLzpjPrLPFWQzIPI0k90SixgWlHG8rlF/ncyuHBnqC/x7MxO0k/rWG8wmN7+mR1MgnqSny1ExVwdJ7Kh6hfZFeLzAillbVcAPszQI8KyGcWYwG+3daHF183J+5a5GNrLp9EhViJQK3pHm4icrucmchSddc6r94eVXv+bNFxaGr3s1Kxww3f51SaZ2HMPyJRmvfMxCM25tyasBCJarYGJTCdJplIWlIkr+0oi4U0XqKDsigVZbFnAC359Q==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:34 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:34 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 11/13] mm/util: Add flag to track device private pages in page snapshots
Date: Fri, 30 Jan 2026 22:10:48 +1100
Message-Id: <20260130111050.53670-12-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:a03:167::41) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 14dea54f-ab06-4cb9-c022-08de5ff05413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MeE6BEiaPPiie4rsY8A+SL59sbXt2gIXvu7iqGzwWBrBDfrrbtnzgAFDsgoc?=
 =?us-ascii?Q?ywSZs9c3xP+TtuXBepT6BflENaHkb4OGruVsgiQzmXrIExWtiQjetG+I3PQ4?=
 =?us-ascii?Q?DhTTS7Nbr0IkvwV3Qk3VFpuoammdDVXPeT2/eUpuBBn+VcEKQecmN+QV+wx8?=
 =?us-ascii?Q?sU2/Z0TA3QQMtkdEZcLm2bzojV6xcEYxw4KDY84A1WnUZG38gJ7Ccwt7UTWk?=
 =?us-ascii?Q?BmQmhkGo/SB9I+Mcr6TNEcwptpTSjNeQl04qHL6WUsx8dCyCz1JKXfPelzJu?=
 =?us-ascii?Q?vc4iWMng/JCyRJJv5ralA6X6ftNOye2nPLVUzhxWGiALOo07eQjUx795eYbh?=
 =?us-ascii?Q?CMilHBw6K+gvkVY88sV6hK2LDjgernwwbKSmoQ3Y613uS/jxwvzRl6uaCvlE?=
 =?us-ascii?Q?ZL7sd6IsdI/JC46iZe9PGSeCFYc9Raeigykxi5tPHVwb1TPjrsIufq9Mtqng?=
 =?us-ascii?Q?bTy+Q24mS/eA7i+AvVAEY0lFLlYqxOyTZVWE3VZRoWuD4rClA/DZf5IvMGFV?=
 =?us-ascii?Q?8Gq+h6xgG0kVmVS3z5g3Y3IXQx558uPeKr1gxCHHJ96o82wUtyRaXm9nx29N?=
 =?us-ascii?Q?M/N9jspbx1ZDPMh5u4cWdGdeaSYx1P0hZLDAbjR50T+B57mHNHfUxAcecrsC?=
 =?us-ascii?Q?uxBFMiuMVyNZ4TxQyx3GPz9Br8PfKNq0KyrJ2pBu+W6cLi1CGHm11lklXB2X?=
 =?us-ascii?Q?IkA+0zxZlgkRE3F+fi+oztBA+ciaSAtK2Xe+fqwaVohZHvbnBvga21McYWF/?=
 =?us-ascii?Q?tlAmY86uswC9fX2eJ5avO3PF/CVtTSoviBYh9IO0ku7FZN8hFMYhssAiU13+?=
 =?us-ascii?Q?mrUE6N/gWoxSAWE7AsZ3SWlsJSCFJ2N3YcGjn8B/sWGeppCiBjcPXdZFZiPR?=
 =?us-ascii?Q?Xj8eKdFbMaRfxhFKvL/SQlNmLE4s5j6ckiPoIOBsVrZ0zruu5Fc/ME10+qoU?=
 =?us-ascii?Q?0uZQmNoRVQusz86PniVIXNTpJbcBgDDTbNjf85gzELFxc63acho5NbdzLQwR?=
 =?us-ascii?Q?ImkQxg1QbNUB5sC1HWQ/Q+4iVGDA85TFJhLy/qgK5j9Y+QkvDhXgPsb6npjR?=
 =?us-ascii?Q?eoUkRgC09RxQKckMgE/iu7kFPpedFj3MkNYUvDsz2UB2cgUIweYHMuf1v9HF?=
 =?us-ascii?Q?hQQ1oMBOluzHwSgMexRRjdl+a7sv9+SArmJ5JKwvt+GW1ctGSWVYZCCqmdI7?=
 =?us-ascii?Q?wXyYvjhp7orJNOTtEM99am+lryXYQBWEwaTNdmLhnTUmliRTO8b/T8V+skKW?=
 =?us-ascii?Q?IdP+/RnMB5Mp3vO6BRDn6XbD8z7YDeRRFGF0kB4wyHlRmexdpTrqgJpwO5Nb?=
 =?us-ascii?Q?xYQMLpPe12W+rimkOkKLqh6doXypg5y2hw/NW1gTbJb9N+K6TPImnkEaxnTF?=
 =?us-ascii?Q?6thP3S9B6va0M9uVoezbP2pNWPhjPWX9q+qyfs165yFx5m8wvKrTuXVrotjV?=
 =?us-ascii?Q?XHhPvIdEKcWaQNnq9GwIznA+nBe/JXDN/pGHvoce7O5oYX5JeTZHwXSfXGK+?=
 =?us-ascii?Q?rbn3y2gF7Wuqnrtwdzy42qGaQcNZNTZlI1iZcX+ID76CLGAHRoEKMgz3rQDX?=
 =?us-ascii?Q?umXbLVZSTel0jyj6sxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gDptYd/inUxBKNZOm4DM2G1jmE/qdJWMDhwWqyXRvAghxZiK3t1UNH1AtZtg?=
 =?us-ascii?Q?O++B1Bo8rqFPvEC8YApB3C3ssrbkyhkpUIKFi3uBV6tH5Av3N7u8XPL5YJ64?=
 =?us-ascii?Q?G1Wqcp2WvkrfIOfXtZdmaQwlpr+2ttWR2n95A4C+b1FaqRoDoEwdQTZTkUn4?=
 =?us-ascii?Q?60Xp1oAJf+uqj7ipEfxP5VNJeaZDS5P6fZ6OwU8+sPwiA3MsLahbMGETUX6z?=
 =?us-ascii?Q?nleVVbW3NW8getryhaYMBRvBbL/Mml47eSBf8/6vr4j79jCGhWwKUu20yJ9c?=
 =?us-ascii?Q?7s2zVq+9RGgjA62F7MgncuZKmFfDb9++/PCqF4q9+NTF68p7C2zpjDchUjTw?=
 =?us-ascii?Q?qq4hxCA+8W0NYWRWAEK1AcLRwY8LgDVmyzabGrchWSxqEC8MBKkzLSdgP7iR?=
 =?us-ascii?Q?qx47nV1DXdFJbu1YPPhFMAYoPsV9RBxnGtwDwGe/UI6zLSQiMD8nBlVAdisi?=
 =?us-ascii?Q?up5bhewOhbiFqfogZQxXIFJlT8ahf4zg/XAB34uj0DcShCBYVL8x2d5wDaqE?=
 =?us-ascii?Q?s2LokQXZiEQiBObGgHwllepPjErrXFNrFcbrpU/YB6IbQLBvj77Bqq6D/+0a?=
 =?us-ascii?Q?eNXoapEdYgH+lC9jO4bVycLOi/yi3PEW74wddFT+dfSa+KVM7cZ813uY7NRb?=
 =?us-ascii?Q?31oVRvCzZc5NRcGkFPRP4/BRTtEOPHwarzW84WK/0G5pcrPpQSCMfL5b9lUe?=
 =?us-ascii?Q?AN7TAtqES6qKEYvBCSzu9IFJCZ+TtM3jLeW76M8tPcbr77BBjAuyrpu03W6c?=
 =?us-ascii?Q?ofqhJIVBeezR6Mhu+vX0moRKogqLpP3nAOPPtHc4/jOy92naZjfStMmWsM9b?=
 =?us-ascii?Q?iaB9Jlms77xY/z8/U6GAarGyJB1/SfCICYhYPDU7K/lNSrRLX0f49y3RDhYz?=
 =?us-ascii?Q?6aCtp+eNFbFLJbV+R/1pMURuSfJ5WRB50TJn21ADh5CZEVeU/HLrbJLXwrQG?=
 =?us-ascii?Q?Dj6HNu5yW4h4EEPEZ/0W+3oRNQj5LHfhAmiwjRUPvYDL9z267ZZYeRtd2Doj?=
 =?us-ascii?Q?Z4nc1p3Lvt/PQXtmT3vboFCmoYqEkS7wytLVAdOWJVSYHiFqZrIxT19JFMR+?=
 =?us-ascii?Q?19X4p2Ssd8b5Ld8jPNZfygtguz9XCpXqNPJXPeBKueVGZMXc8/cU874D3xPP?=
 =?us-ascii?Q?tuN9r1fd687pHS14iPsgzq91EoKLWuq6dLGl8xrLgaS1OHgxaOPoJ/++9zz8?=
 =?us-ascii?Q?LuC6o/560trzmkXlC3xRP5x/wCEADor1tusAIQ/DWORSqCLvbtpRxOFuPhRd?=
 =?us-ascii?Q?ESQTy49tKFMM2n45rltMsDpJdnekyFCG0MEjQKPqnTccRXiGSi9oQ0k+1FNW?=
 =?us-ascii?Q?FvbBCgngM8YAeCZbFH+lEkIP1FCCwC1PqbLQ0nKGotOSsyZNmlF2OXMNOBMs?=
 =?us-ascii?Q?Sfrz6FJ9KL7x7wrSNcsjqVYCKxSyz1ctsdLDVRt3yhZSYgBy56bGpy3s3q/3?=
 =?us-ascii?Q?YshyKHJ02wp0K5joTsVvorEmtjA/UN1k6B6Vc3ai302WNcbl08RfaDDlJUfP?=
 =?us-ascii?Q?H/czq9WT9uPcxG6S0LYFw0if/eEFF2UJPxN0+Peuy/DyBr1gd6Ot6R+1VpWD?=
 =?us-ascii?Q?wukH6zw2DADdxA9a3TBQdWaOnHzu0CzuI5kDU4mr8vw75zGZOIfHaJJN0jh4?=
 =?us-ascii?Q?sjna7VlNna7c4i/kxsqNjMV5V3l9SKplSKS1MmYQ8iRLo/eeyP9vbH58SDTF?=
 =?us-ascii?Q?vMsKt7n2EvJoIYIFWKnHfCtV7xlbXcood9Ki9yC+FA2S0l5lT+ZIO2qC9kZa?=
 =?us-ascii?Q?I8kDTfCBVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dea54f-ab06-4cb9-c022-08de5ff05413
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:34.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwLo8WTgRBZtq1brkHsbA380WzuWmnxGZ7/0gt24UKMJJG179ygiEUV48AMMIlOC7sSJ0BDm/sFbsd8JkaGWVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A68CA0006
X-Stat-Signature: ffj96s35ygbccxgxsjz6srcqr4kee1e7
X-Rspam-User: 
X-HE-Tag: 1769771660-102509
X-HE-Meta: U2FsdGVkX1+mSdGiBhzGRjonSRMpjoMQ3YynhurhQk/nlyizl73IGebLUw3pS7oD+Hws93KP3M1AKVdh8vcFbe3jxpdX3WbX6XINinf35iO6X3uDpA7OPYDBBTQqbFMR8Rh1l8Xngcbf6zx+5fDpoJfsAtYDQJunCTN0wKcMY3labv9maImQuSw7LCkSLnIUpqzs+fg/leTNiVzQBlkqiStbxK59iOErKQSFYB5xx+2faN57f+MIDSdvdshjrrw0KN3jh7KcDoFHsGAP9F53ECCDzhreQ6NHt0N9WzaV9Zi6OTGEgwwUaRUvQ3AfZcv/FApLrF4PoJgKv8Ork9KIl9bZ+AwkPYSWl4D2nxHJ3GNnya6SPqxR4yc9wufLAvai27B5QWdkP1E1WKE809VzsSnW7/DkKlJb0QMom32UVeujg89lRajyB0YwuWUhdh7rVeYU0MdoiePf9JZfKhP34AunJvQcqqbb+Oi8Q3IwUDa7B6/pQJG8cmt4oZ5QWkksWZ/HOEyuOLXo1JdWEEkhoEDyiICgVnixBVhzTKQr/Gq+BryV2i0bVMyyGb3xqMVTCdidJzeU8kyasQBSIQg401Rd5V+Qn8V7gERAnzTEhOBZbS7VkzNhImxfqCPhXJC+8PjuJkI7rjBQLYjTvvhmgAcIZXCQWEiDNkveIfR7de/7eWwT378fL/1KGYi85hMX0cM7Rs0jeADaHLr1Fqb7ONBtIP8mmijV6V66BH2/PC81MTh9LW9O6iMqd5FXBdcG+02CXw/cd5e15ssUyA5FhqllvPPfNoG6LrN6f3OnSCy6+8SJ5/yM2UQUer5k4ZLiKAeRPTvMyX7+ZrbDMKRjNqT7GATmlveUAey5ZBZ8oRH91nDMCGlK31pSa5Y35LdjEX4q7TPouNox5xnXeyikUtnx6dCRwcbQfl1b0XqzhwzQ1lo/2/R+d2E0vfwzS8yiS95JjvJ/0deukqaS3t6
 Wj7nJM/G
 zPeC6MCaSjhdBSi55byGtiA0fsrWHRTRxWkj6ZP1MTTsP97MsDQfykD7AUijZxYscXL3YwjO8AN2EVgz1yTRY9+0wXsOXIvFn93ZWumntZKKIiMmyfl+b0qi66AFkS/0NluOrOczf+sA7NtGHGGZvXdelRFFXlvndEeVuE39G/NKdd3xmVO0wCSWF6HXznwHD3hzqIpQDDumdAclLeHk0J8nPXdb3oiFYHiNk2/uDQQULd/FWJ1EnXV2XTvI2WDs7A+ALjuffT/GF2RdJQuqmbzJV2+7rfStHqSfL+BdFu7hBkWBFDqa2BZIpA8C+VETBkZ7es0t2LmzYXc5A5t+BSzilXqXaEpWpAsnG2wzuu14zi+TWu0I4K9Qk5VRWvoxqMaVk6Dui6HR90m6xc+C/UIMZy4nWxYWqK3qn3mxfSDBi2bcDTLrBSVRQctRmk1Yi6cz4uQdWhCRdxaQbcZUkxi1oc6mFKh2xGoIRRdMUEbQb/aNLCzGgaaGhZc19wCQ1DoiFx1mLbXynOb4jbFkHf0sMcMe1oohQeiTE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
page snapshot is a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - No change
v2:
  - No change
v3:
  - No change
v4:
  - Move logical continuation to previous line
---
 fs/proc/page.c     | 6 ++++--
 include/linux/mm.h | 7 ++++---
 mm/util.c          | 3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..bc14f7ebc369 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc736..a52979536a5e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4627,9 +4627,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 }
 #endif
 
-#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
-#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
-#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
+#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
 
 struct page_snapshot {
 	struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..65e3f1a97d76 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 
 	if (folio_test_idle(folio))
 		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+
+	if (is_device_private_page(page))
+		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
 }
 
 /**
-- 
2.34.1



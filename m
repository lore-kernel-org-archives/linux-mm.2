Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9724CD2D11F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056546B0005; Tue, 13 Jan 2026 09:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017506B0089; Tue, 13 Jan 2026 09:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86036B008A; Tue, 13 Jan 2026 09:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D98066B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:58:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84633C05BD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:58:09 +0000 (UTC)
X-FDA: 84327245898.25.7812C95
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010007.outbound.protection.outlook.com [52.101.56.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id B9242180004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:58:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VGOC0FUT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.7 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768316286; a=rsa-sha256;
	cv=pass;
	b=wk5FqghCdnlHwFo6vjh2su4S2TAnFT7/vjgPy6CDPihjaMKQfUY+AcJFBFFBkTywnIg1NG
	fUMNwXG86WZGUVqSPHyQ32jjcbw4ZzedDDvdxj8KqGDcWfcPfYhbmdp0wByPFFW2jIgzzE
	sOLkDzsudeul6R9+NJDGEuIHltdEmDI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VGOC0FUT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.7 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768316286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paRhG5IbqWyei/JqRYN4GWO/v0Ue03oBbO6AY33ob8c=;
	b=qMn0AFE23j+z2/uB/doiDx1re29zIl2ltCLAh/hQvSyqoMq9JFetXGp40KRyoEB+XiYL4o
	LaIeH3/MCvUPbMFsmdddIty3xZAC7IhHljhd7dmnTiJppIwf/a8/xY8mqdmHewJfjgqluP
	Ak4k/lz7h9gbzJ2/fLRlw3Onpr7QpEo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9EzgPDJllZVLe9Ms6yIe9QPlo3zXrCsFm47B5Wh9sQ0mM03Azmz+POF2/J8fSJVW9nT7NAoXM05pwQtjEiFSh50ATesLhpbL2k4f9xxujzt4lIfbSMp6g7Qd85VxXxDD+NoYFFTMxz4uSwj5YdhToFbWV+3xs0Cev/oPuZ9hw0L36audOcYbGcBrZfgIRgVy2ATDEw7E1q0qpVh8Gtf5Rw1ag/8Z2uOBvOd1VWDts75oszJldT96e3bcYddzT2/3gREnn595FbFb3Dz+mhDygN8FfqOrDlqJwKx0F/3kHrfxLYh+WXvW1tTjKesC5rlmWmjSwiPLerIla0hkbSbpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paRhG5IbqWyei/JqRYN4GWO/v0Ue03oBbO6AY33ob8c=;
 b=S8vV8NLni7lZ43/EQBiyq/aCtGV+PwfAoRFkohfZgwfFM2BkSMEHRn7zW9PtAz7soDsludY7Wmp7MI3SxJMTP4mxiNAqr3Z7OVojh6iSpx+9+/XAwy3xpKgnfqEBR5vH2fIjjUOUF0QXHboWmK5rCBuoAiXda7BooRQHYFfsfZGUG6mIb/SkTQUSrlHSjxdT1Ppdjfn6/qTHDl1Kcp5eMxy0r7d5ddK0bDLiuLopdxNv7eR78aW2IgssFRo5DI88lYPFfZxkWLKQQULPTDhChWvW4ibGICmQg+Q8Feaj7L76UOM3W8OiyEOx1f6UYeJz3WtbqmQN5455QFb0WDZD5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paRhG5IbqWyei/JqRYN4GWO/v0Ue03oBbO6AY33ob8c=;
 b=VGOC0FUTfxM6wuWFEdxsEsIk5011RkPT5g1k+OvhYr3CTEdpMsn+S2C9Qv8nOBxNv4yXzodmT+jcLVMj+RvOqCBW6YySPocqo4QF2wW0yrWx7VrPRwR3ugKA+YB3dOMBasLhBEPU764yfHQwTMAK+HP50HF1hPeiwfasqYp+ARQAC/Lxod/b/vKEWFZ9Mw5xEjKI7/XdKc5eFqgcIK78moxv5gZgeJ3V1iLoYeCbnWby+cDYQl+KS2BOoZ7EOX6F0+4d+l7/a7VUTnhOQCCobDm65YU2N0bl/OCWTDvxBi4NI3cVZqZ3bik9LSQBaq8IgU7Oe9XTru1fCtWNSB/4wQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6285.namprd12.prod.outlook.com (2603:10b6:8:96::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Tue, 13 Jan 2026 14:58:03 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 14:58:03 +0000
Date: Tue, 13 Jan 2026 10:58:02 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <20260113145802.GA900112@nvidia.com>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
 <20260112143904.GA812923@nvidia.com>
 <aWYt0gBHxDCKqj9Q@kernel.org>
 <20260113130526.GE812923@nvidia.com>
 <aWZaqcStRAK6VWLy@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZaqcStRAK6VWLy@kernel.org>
X-ClientProxiedBy: MN0P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: 02bf933e-1a5a-4e55-c280-08de52b4269d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1YN00qVN0bleVQ9L8FSRFOmKwSM7fvuUBVDGjFV8F/1WTHkhKo/A2/rYPaQ?=
 =?us-ascii?Q?yURpDBml4DfJ+Rai1lcKCK25HMpo0KWdNrKocFfKaujGmnPVsY8KkQIxV5ks?=
 =?us-ascii?Q?sCGIoNK+JziUAhv1g2M+FV+fAC1qeaUi78RP6HLe846R3Hq6VWbLnct3cp5i?=
 =?us-ascii?Q?g6V6t0K34FQXXt8MqWrf/sbvepa6RO+V989SWPeXms5KqhhZF8tDkkndhtT2?=
 =?us-ascii?Q?Xll3bS5oE4YEStWLwU0LZTXxor9AazTBXq3VozMQa1MGHekQSKSWSdOhBXIY?=
 =?us-ascii?Q?W3BlOiZRi2moZ2bfmgBEwuMBh9y8BdxifOGTUdrpkTDUCFOv4NbDrL5ZXpcw?=
 =?us-ascii?Q?iWaE2Vv+bvnhijTtYsdDOYVOUrzRVp8XAE4zyQasia5W1jYQV125a3ZJUXs5?=
 =?us-ascii?Q?gbVIXmmjuN7LcIxXp7r0C7AU2XGrG8NVfMQFpKE6c3KLEwossqo7ST+fKKRQ?=
 =?us-ascii?Q?imoIdTmmMT2Lhuglp71J6+BS2BEuGCUHVvjwR2bj3ruCl4gR1/sotjGqLqfM?=
 =?us-ascii?Q?xqGfibqR2EEl0ySo0C6DboDUvUR4Lciq5hR0fnOeSqdPGR3X+x+jCYAg82PT?=
 =?us-ascii?Q?+ZMXXSuHq5S/8NJj4RT9j/V25pG/j+z3w/qJsyGGDp8Ha89/4eKV18QX+Ias?=
 =?us-ascii?Q?7e1IDP9u1y7MEWnU0rnVFQFKZhTwDxJr31NQcwiAQjQJ60bC86o/IQzcn8gd?=
 =?us-ascii?Q?OpL6F3O5MBJUl2k73usYSFP1gCbUH58dqpkWFPjPwMsE/CJECCOH68rKFCna?=
 =?us-ascii?Q?hLoQxXvrSwqHpFe9qc8Bin7EqlZc48mkQrAbgEf3u0eN4YOvQMl/iBefneGL?=
 =?us-ascii?Q?L7qvEy4Kuy2VWTLMRCfy3c1YCuNfZe1EqeU2uvhydRKB9mLG1d/JZ0yOJVxk?=
 =?us-ascii?Q?Laf/fnTVOJibJ8L50q17ILDSc4CqPQyyQYQXnxBc8VQDYdX5WBVYFARTxvDl?=
 =?us-ascii?Q?m7CrS1+zXk2sTGWtxFx6IVfz59sED15tgjRTbOXPQTuAnVvAP6Aeks+s4Qq9?=
 =?us-ascii?Q?ykPcPKML4ohQFv7n8zioySnFoY5dvo0XMz/6+H4IfWPA7XQjskIqJL2uUIoj?=
 =?us-ascii?Q?rFs+sZFnaqY43YEtB7EtYPbQf+UjnH8tZ4UB/hkN6n0BMDVrKQfNcFltwb3f?=
 =?us-ascii?Q?yL4JsPoJNeQOdJfVz4LdLOdEDIhxJqHHA/n+A3j/TUIPPoW/2OizbB6+zKWu?=
 =?us-ascii?Q?sDBoRTReb8fzbe8Ar4/8W/wEbv3ytJgODxudPh2SYxkcVXPox3l5eJjk7r2v?=
 =?us-ascii?Q?Gnk8jFxEgLtyNFsw8vJ3kL8OeU4PNRkDTS8fvVNrvt9F1Su9I5uhPvDfg63f?=
 =?us-ascii?Q?RSIvbEmdLMO57kYVQnQd0vn0Xnor8hNBD2NI4MQ8uNmNK6OUt4VjAE5I/yt1?=
 =?us-ascii?Q?29P71jupxJdsXOQX7uqMDTIxIoM4KzxPr3YyK1XEmp2wXp2fZ7U3/6rSlRLa?=
 =?us-ascii?Q?LopcoAHlZV55xnTmQ0xGWHTiUK30nOxv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zSSkrTtC0Z4DDqx+CpLQQAuJEo5DeXixTSVRElGDnDmkKjcZG8kCFJRkNsDk?=
 =?us-ascii?Q?pIR/QJFHdTCmJ+aOG+PTK/Zl8s7zmVEy8dF2kNsB3eSk4CdTPUTOuVyeJZ67?=
 =?us-ascii?Q?2z6jIwTXiwKoo6F9qj+NcdJK06Fvcn22pVqDQ1w1yuD5Q3nTyXNmyCZjvqyz?=
 =?us-ascii?Q?S67D1OxDVC6WWl8ZCxqgvb1m9tr2Fh+ZVFBFpgOcE2vzyuIBC01iDjaK8hoh?=
 =?us-ascii?Q?toXJYwGrjpo/KobE/ieUgDrG+j/DYO3JZa8hEGMAnDC8O4zFHHpxI9miTTwo?=
 =?us-ascii?Q?66e+lbYoXC7waIncRQzohUypch9jXQ1ktTia0kv8cIfLPRZUGZZs+TECVJyb?=
 =?us-ascii?Q?Urn+v3K/P2qGvc7IjGfjwRGT3SZ94f8gtQSnnG66oZGB93Q/kYNbZOYgs6g1?=
 =?us-ascii?Q?17PEmRhb2kY4BWqNOsTItvSO07wVIGh7O7N6kEVauhBOJallJF46orbdFSFE?=
 =?us-ascii?Q?77hx3WZoL2wtZL4IT0V3o34b7QYw6eIMX6cLd6qWxHCHVo2Vlwkw5x0zVqec?=
 =?us-ascii?Q?ZxeDrvwIgbULgTHpJKU5o8e9mpR6tT1CMyMrlr0Y30byBoH3/2nbS6DLqgeT?=
 =?us-ascii?Q?t0Gq2+H2r4gYnL7xFCfSejF6W9qaN12LQcFvBTSYbMmSOQtX39zRx387QieJ?=
 =?us-ascii?Q?CH4r629eH3bLGO83GKfxvrNRtPPZe/YTDEdU8/uFWMHYTC67pVPLaOKN2Q8w?=
 =?us-ascii?Q?m76O57AzP+yC3R2rnu++3q7NqWaDdg3JjUoMoGjDuuz/uc8zuDGlN+BZH1c7?=
 =?us-ascii?Q?lt+8bIcGOfclPncfC1npP3CS3MncW6nHFvLAQ637us3B7QdFSsdc/6CotzSj?=
 =?us-ascii?Q?jmAIm/Rtg7lSHdT4SkVv4K4UGbMex6zNoC0lkPCKPmKUcSw6I31Xhe0sn8C+?=
 =?us-ascii?Q?GVBCcHKMg8Y4KkpANoZiwSApevarOZnFLgD30TUkCjGZkc6Oq1g0oeDlPrU7?=
 =?us-ascii?Q?11lWmWaT+ErH6alEE7obkg1W0adRAK1CoUM4dKros1Re0P8YWwQvGgFTcuFs?=
 =?us-ascii?Q?1YUJjOGC2QBiRL59F3VOQiIhGWm4wlefkTtyyakqZHUpFsvYRO3TUiaDNvlF?=
 =?us-ascii?Q?tCXH3bakYZ6m0NQEt2awnWDisqLNxfhgsn+xmD5yvODAxyo2K9M0lbIlc1X/?=
 =?us-ascii?Q?GLHVeWdQ4sXRsJmTu402iFndRvVtcJRSA8wbfodgqE3l0324Y7YDqByFoRyY?=
 =?us-ascii?Q?rZuujyNCTPh5shtKbiBfpByAXfmsjMhCs3gfhcEgEN4KSWRXe5P+vF2bDl8U?=
 =?us-ascii?Q?99ZoSoabJj+gWiBUbo/o5rkOwRHUbLkPzo8GgOrS+RYaj7JSbch4JK2dlcsW?=
 =?us-ascii?Q?QJGqNIpihSYVqMn9rs8L3ziE5JonSsJQXVGNaHlSJt8ONisXXKnsbIfbCZl6?=
 =?us-ascii?Q?XBI3quCL/quO6PHsViVzuPW7h5h1VxZgpxs0HRKg1dUUx278CgxnWS8sCjfc?=
 =?us-ascii?Q?Qww7APWZJt6l6a6UC1/DWEHWa3lrGcOY9U1ckFmGvUCtsJnuVkIenNmrX53f?=
 =?us-ascii?Q?SG0+4RjCsJIbaSHstcSCROU4VAksekWG/dOpg8n2030XdZofhPUxN0DjC8Bv?=
 =?us-ascii?Q?eQsmZPv0HofKcsicbRyHvwyUyjDXnOXQPRT6DtfstaZJALKxb97noXUKpowd?=
 =?us-ascii?Q?DIENjhvSnfXVZUV8uL3QUBvDED3XDKu+U24b6jUFK3t4hc+M1rqmjIEmuzCZ?=
 =?us-ascii?Q?YgxaY5/06RJqC6BFlDvsHuuynX4x/re96zoQ2G7CHg2J7d1gMtl1g83gmuqu?=
 =?us-ascii?Q?21I3KhBDFw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bf933e-1a5a-4e55-c280-08de52b4269d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 14:58:03.0043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kwwSWB+2FKB4iL32Cd/7p7G0pRgbqAbPKtxIxXKGU6FSl87nReM/Nau7C+HluC0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6285
X-Stat-Signature: rt5hmakddrbm5yqc3ch87aeo4th5tzfu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9242180004
X-Rspam-User: 
X-HE-Tag: 1768316286-326371
X-HE-Meta: U2FsdGVkX18IOu319R05B30RTbMoafXnaWlw6CmFE4rR/+uQ3+LeiD9pOHPXV8/UFhjgmDrGUrOBJ5nuDvo4tulN050Pebgz0YwE1lUVaFPz8krjrD32IPEYkhlo8Ye7vtvcqu5x52WhMlOPNZ/URnHLc0IihkJCrOru+XtFlpIr5etKGUx466T/7CInWm/fM0x+/6puUpd1W8JSV6bbpnnbIKW7PBzvgl8CCV8FP5f2ipCbQ6sxRdNK141Tue48H9xQugubvtcD5WqRujCW9WxyTps8sA767pg6q3pxNyp/9u7hEc4QGFwjPiKEzCJSEsFOiaESbcHMGBsjwSU4NUzEs+RQTWZCCH8y4XKmIIvTcmfL+ZFMpfxhxQ3UVOS1ezUZChxx67EeMPY7ayMnRuNrDOla0cfaAgNbVB8ESAYDph491diHR4KY7n7loHhE1hGMdz5w24oI2mPtS+nXxnNXkMJ6hA0IPjVkNJBzbomlWVxis+nDNoEFN+pcphlD1Ksoun9KvMUcGOlMP/oigYPlsaB1o1fFbmixziGOHoV2B8fDeaXshIbhtNZdayFqMHKCNE8VnGgd+V9zVJ64fpfQhfffY23hwynw0Tw6FZ+jSfJX4SncoMx2NubneQhCy8TD0o4qSzKlMh3oMM3e/JJPLlQ1mSWmMZCfrcqOKi2TMOoU34YbK1XC6GZ+5YErCROjH6anpxXqAZ/xNq8ybf2xrXrZXd8q6bfW6hMx2ha1sFNcOFK3SzWRrr6H+HieprK+Gf5cLPgmRbqygDCaqwcGcEkG5EtSmhtwnKUKr+chP/87NRaljFtnuCdVohDPrubM1O5mxSzAAHkAXAtRpzfr/+QMsrKIDTa5ocNFXpgaB+u2ULMpfMxl0zjnjNgRNx2o6q8sZWZXTpTUf8/M9XZvcTF6SYeV+ao/xMRznHDPNpR4/gm+acacqBGtkIwLxt9EQbpoK0oECR3KvPU
 XjLQTpQe
 dQE2UnTq/hStcNbeayoa/y61XJh0TKr4UocNuUau9qSLPVulcgA7znX3/pIW8ESk5pb00/L3ypaCD+xpRkE2v13FM6/XP3E4/MIMOF8YP+UxQurNvwRR/ImazbayWnVB8Zcp+i7pf3DMVxzHh5XVmXns+tkh3Jf6Wb3he13/wyu2PruaDuU0bNnhfUDodQMW4rbG2VPTjco1SS+anE5eGSutVe9amPq6v2+PjFXsozqwvPiw5j3T2TedVR+x0W4AHrkK0gyXusNKghKYnRzOnSuUh4mKxx6fVK0z0CZVStZU4Fc2QeH5w0O2uU+a50S2eAaGN/Qk0miIEdK6qr8dqn51Tz1mdnMsPYDMN7QlTigXou2ZIJ525X3TDXRLXK/4ab2uWsNWuqI/FiE7o5wTjNQFBhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 04:46:01PM +0200, Mike Rapoport wrote:
> On Tue, Jan 13, 2026 at 09:05:26AM -0400, Jason Gunthorpe wrote:
> > On Tue, Jan 13, 2026 at 01:34:42PM +0200, Mike Rapoport wrote:
> > 
> > > For example mshv intends to use kho_radix_tree to track the hypervisor
> > > memory and there unpreserving will be a part of the normal flow.
> > 
> > I do not think this is a good idea.
> 
> Sorry I wasn't clear, mshv is not going to use KHO memory tracker but
> another instance of kho_radix_tree data structure. 
> I don't see a problem with that.

Oh.. That's.. Interesting but sure if it is made into a library then
it makes some sense that it would need freeing support somehow.

I'm surprised there isn't a better data structure for what mshv needs
though?

> > Nothing should be touching KHO until a kexec sequence is started. KHO
> > calls should WARN_ON prior to this point. If a kexec sequence aborts
> > then the entire radix tree should be discarded and it should go back
> > to WARN_ON'ing KHO calls.
> 
> The whole point of making KHO stateless was to decouple it from kexec
> sequence and let userspace control when preservation happens and to allow
> preserving as much as possible ahead of time to save cycles at
> kexec-reboot.

Sure, but also the data structures should not have a life of their
own, it needs to start from an empty slate every time luo starts the
sequence. There cannot be cruft left over from previous failed
attempts or something

Jason


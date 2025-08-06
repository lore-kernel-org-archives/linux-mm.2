Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FB5C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCC88E000F; Wed,  6 Aug 2025 14:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D758E0002; Wed,  6 Aug 2025 14:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4355E8E000F; Wed,  6 Aug 2025 14:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5118E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:47:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C607E136528
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:47:26 +0000 (UTC)
X-FDA: 83747215692.28.4486105
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EFE112000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:47:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dfhq0KDm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754506044; a=rsa-sha256;
	cv=pass;
	b=gzSK/G4bQd2olvMt1LSCbFHZvtbuJclIwJPk1YLDpbTXvKT0wFUEW1ESYt/P2NwuVv6vYa
	rCz1AOp94WXyBdfj2tYJxLdw28TkHoZOy+URmWglbuQa44pKCemd9E3yQ1Ca9AQ2tFrs3l
	nI4SnvCY5RGBfdiFpQMJAnO2+my2MKQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dfhq0KDm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754506044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaplO7n4QpZeVX3LF9H+/Y/a22QslLPGzwYcwq2JjIE=;
	b=V49MOnsGsUM+8MShSWy8xhlsjLLfZksjLS+3Wn3Yw/ZxzThnyCFA/zoolFSxm6zliRybf7
	Yv2EnVZA8t6zVuc893SgqM1vSMlEA3xTSBu33ITMqOFrl6III0nkX4SP4eJrRBF8TAb0AZ
	/MnHP1LfeF/F53oeIeIK1/8RaML+a6I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9CWudGS7yemOffT/79eCJgLD5V0SUX3DqtEsl1YmaBZayAe/O+yxB/dNJBE1EcaQKG4ZVJXJka/hEaJ0CGboJjwiKMF5fobK7bvafSSnVJDMyvJxQzP26of9EYB0YOiWwSRuDhBDm/pND8QpV/UW28jXbWP4i1+dSLeZrLGZQdt2d558qjTlAmWSV3+6DEm5glKyeb8OdzWOF7sZEFlEzdELbD4VRWILltMcvhwc6dEPK4ekfOVu6iaROrdnjDgOhBUrVti0LEh9lRRsqNYt4q02SWKGdeMWhrD5rQMRxchE3zKJ0p7kV6olzCA62WDWA51skwnzMXkXnqf+6BtXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaplO7n4QpZeVX3LF9H+/Y/a22QslLPGzwYcwq2JjIE=;
 b=m6foz4vUBygeEaq02kZCY0SlmvRj0RNcbEID55x0nRIoQzxYWpWEG0DSfojzggwAGmWoLwAV/+ZnvZtsxJwj4TolvKwkqCY0Q6+Koj57RKl1qFO6Tv95Ot5hhspXqJUXnv3uz+fpEglNtwil1XYo8EjbSNaXb976X6ai9/Q/vl80tmeiDFEg33slkQuv2Aqe5dN9bPF4fLUIoXqBB2Rv6pEO8/uDNGV9rndwuXOTjAmKeW7QJslTTB8kFUowhPmpY8NeGNGmf+FOAUCFNGeGBIAdWrVqsXo/Sdd9JkivIs2eLwjkT4jIqbHEn8ra+r81mrD3TYpP1N6LLbSHLAYgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaplO7n4QpZeVX3LF9H+/Y/a22QslLPGzwYcwq2JjIE=;
 b=dfhq0KDme6weZc4hXE+TzhqwuqVy8n4SGGri8jVvfgSo+nXv19suqEhLWSXhMbvhvRDsdIhLCZLFKtqVTxII/CjTf6vPveomEb2Vl/Wuq0oObNonZEOpA25WUAW+NeRD5grY1Rneb9B0i2kF16TkIiOhI9ekUp4xdRUCX6uL9G4OcsOiiGSWP1Pv9JLVwcefn2hjcBBjIRZNBxFV9aWZ4y2EPd92dp+KMUA14OLfcrdOFGaGYsysXY+2pdxdG64955g4vSGPkdPOKLX/ASOy9TCy7whritkpJ7IX52Y1s5NsOLNcJNFOJRIK7HM42EejxYAAPlKFP3lqRF0cIKxviA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 18:47:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:47:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 03/11] mm: Introduce memdesc_nid()
Date: Wed, 06 Aug 2025 14:47:19 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <0EE8EB3C-EF13-4F6D-A1D1-9F840D8C10EC@nvidia.com>
In-Reply-To: <20250805172307.1302730-4-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-4-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:408:ac::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d1c8de8-0734-403c-9273-08ddd519ad29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8KRk8b4UVO3yNIS87VhzQUU/5DY+6qmQOBxTZRU7g6MN/bQ0Hk/N2Z8Um+1s?=
 =?us-ascii?Q?D9Et3DnJKNXa6THxUTZm2va1Cx9XrZUNUyOrVqSYpvIsIH6/EqqKGD1WLhCF?=
 =?us-ascii?Q?V7dQ0eW/PiitAVE1sKrssUPciQtBFunr6D2zVLnOuyTFyTC7oJuk/jtRBH48?=
 =?us-ascii?Q?LEMv8YmBkD68ONznrxFCVqf/e5htRBdO+k/p2WFlsDQxR5DJZEmZqHMxEXHI?=
 =?us-ascii?Q?C2pMIV7jt848lGqUdh2a2SPZMGNrVdtIfFXx8WL2YJb06DkpyHl3wJlSyczR?=
 =?us-ascii?Q?lNMgiefwApQ/3pDa1kia9lvpix7w8pPFiBxgnYciLqobLCXnDR3V3jzbEUh0?=
 =?us-ascii?Q?XguW/CghCZFutJ9yAZ2v9yTKs8M7C3LKqd77t460DUUG5bQNZPM9y508FD+m?=
 =?us-ascii?Q?t+RD+uMe9WeFaommMIP22MA+jc1MZP9TQszhqgF80Xu1uFnMIz2rHlpjuarh?=
 =?us-ascii?Q?jA7ssdUrckL1/tBYwdAZZmgG4azaionpGmap8VMxbXN8jIsjOqy+qOtmkX23?=
 =?us-ascii?Q?1ZRp4DbVt2Jo+FiMFbJbj9IzWvD2PEc760TOS+EMjfmT8luVgmOLh5NyLJjR?=
 =?us-ascii?Q?hQM59uDab6T5UxzW22anN7LX8YU491Th5R6gxTHzPGkZyBnH8LPrjR6li9Bh?=
 =?us-ascii?Q?9Fa7WpMP0zczC23YD3VCWDwz6ip+8ISVYa2r5LtAyq0kgtPVEXXl4uWkFXE7?=
 =?us-ascii?Q?JXFdQWMzSawHiOJrkUd9BGaht8r7oDaH2t4oUWbZYb+6XZ4zFFMkFC2NkIXu?=
 =?us-ascii?Q?rm7aGkO2dP1SnOYi6Gmqsl5IsWOLKsgSQyvb9GNpw+ik8xmE24KCaj0Lbaym?=
 =?us-ascii?Q?1xDarAno0GmWFADau7AL+hRFidOTAxsQLeRgAlNmb5aFaKeL8XSCwvFD/EOu?=
 =?us-ascii?Q?okLQO+khqweYdLWENPLeLoLEOGK+7ZRqarEXZ3ifTD8LfXmw8dXUaDmC1MU9?=
 =?us-ascii?Q?yZnFA4HzsG2Z2IewTdLQHEejqh7FDKs4MqyAd2FUUm2cCTDs0pkCxzCBaZsx?=
 =?us-ascii?Q?oWULWux45cxhm/VeFt9XoqROI8CJyDtN/gC2vMF8jiOFFghRkBMnQsYH45Dg?=
 =?us-ascii?Q?2kd9qR2kTNPZe7mAdayi/vrt/ceGNW93UN02ykuVdr3lqqz2FBX0y7DLGQ2s?=
 =?us-ascii?Q?ma+mv1bBZjH+UCP4K+zuxZHGVqAD0PFovGIMQ/VE3z21NlkPG4hkDZJZM7Vn?=
 =?us-ascii?Q?88Tc5nHN1ZYqxBomUe1ctt7dRrVXhc4NRjuEtwnzvuwt8bCcDp06FlGcOwK4?=
 =?us-ascii?Q?LfWkBImJkIJ6UDvU4BIN7YA8rqYt0SSl+IRps7G+HIg+LPQbXASYB4CDBohl?=
 =?us-ascii?Q?5WgJUeNAUjWrvMLtj4izc9lBf315F3IZ4QKTx5NVS0fynA4dB6Ye73X0jDAO?=
 =?us-ascii?Q?2zzdefYWfqQwS5qQv1yf7/99wyQUtpNxLnR8GKzNQOgScQ8L5GfGrCClXPdY?=
 =?us-ascii?Q?rGmNzYrNjnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CzlR9Ffe0YrcNF/3tP/fYf5nFx99FbC4L4g1O3QLAgcsvuOs+CKpyf83CzG2?=
 =?us-ascii?Q?hdno454vf1JtlFhz3DPQP0rwVEpF1zb73s538LeZeC41Ou0IfqmqNfNzBxnP?=
 =?us-ascii?Q?ciUG1kogKgvpd3SLBzYC3Nax2narkBvC+O+95l4iVuafhQEH3PV8ptdtKKT3?=
 =?us-ascii?Q?y3f2Uob5IXOfpPH6HABvJE4XJB1jBi8xyUq2WI7MkXQfT2NgSxMH/2wsFsno?=
 =?us-ascii?Q?hX7PYP61LcyGyUGgBJ9CDx4j28vPH+JPzy0lOVRNag108gq2SbD2y6hSK8ul?=
 =?us-ascii?Q?KjxipKx6qIa3guewpw4DB6RDtCgbBTwCqkMR4mnI+jHtrt4Vleshgy9Ezg1K?=
 =?us-ascii?Q?YFHUypKcbtCOzUHlPMmookaO1Qtzfd6zJkHcRGaUCx78T9LolALCMMTch9VD?=
 =?us-ascii?Q?uy6DzINDfy4YZ2XZyRJkVNrqAOGQCBDNVR3a52sd/nP3gNAjhkSDpGUK3dNl?=
 =?us-ascii?Q?lR7QQTin8uoBsPbU1V90kemfNOLz3+FirMvQZjHINojoqiJdQJs55Nnm1WVI?=
 =?us-ascii?Q?an7EDmxs2Ql8qba4VckHXE3KYxnPJz02GnNZwOR4LNRR6dumBlJuQUYmwV6N?=
 =?us-ascii?Q?O2xBVgmHB9qou7HTDjq+LOfaUClcge/ZutyL7G0Lobt58/tfUnYfKepNBPUH?=
 =?us-ascii?Q?VBJfj4dV4424gw3/8tJghxInziojqQeJMihkYhwzJrFehRiHweOqEZJKLIFX?=
 =?us-ascii?Q?5pKsLFddqGystUwSqA3xdo9s4rJ/Aolc/O9KhkG6vdks39qegw3av2OuTUiv?=
 =?us-ascii?Q?QEOcsQw4HyQIWCjCcdTNqKC5hCLJ+YDL6GF4kzZdNHFDwg6tpqG1ofj3X4rC?=
 =?us-ascii?Q?mCL2p0JB/xnTIIlUSeqQyTzke/TjugOErGG5SdTf6VMDLdDm1Q3XyeTu8UZJ?=
 =?us-ascii?Q?gfZHQhkUzQvfBIth0iyhGR6p5hhCr1moLN+lKTTOrbc83bKc4TLrjN9ApdHw?=
 =?us-ascii?Q?i73KA11GM22YIfVB8EUUY2aW1j4l2itO6NxzwucwH7VdhB26ru1d1azw8JJn?=
 =?us-ascii?Q?VyBcZke7ZOQiufQ19l9QJ4Vjl3T9T+PH60Y5kirA2+5QKco/3Ezq6RWuGSIU?=
 =?us-ascii?Q?BpN4zE+01hqRyNV6QC5xwD1tgjiKaYrYR1wZ4SxbeH7ISkJeG/quy1qZDTut?=
 =?us-ascii?Q?vaIoCHF90KpIVMe2+/oSDJkfyneaVIG+Vm0iW/6Rr7PZnhk19eB+qG4Tq58Q?=
 =?us-ascii?Q?cnqr1dXhHHfRBWWaIh/kJhHg0G4H/FIlUDpioid5zqqhPSLj+jtL19zCZK0f?=
 =?us-ascii?Q?8ieuvFOWnpR1uUE+yitJD7L3q8Qo6sI3JY4etigQQXFHz+pVMm34jjgluyif?=
 =?us-ascii?Q?E7va0Lg+iWgvlsRxHLz2xoA8VY1Lpu+n3QVfGtPwwD4l90RRyV5oAufThV4j?=
 =?us-ascii?Q?c9JgHl2si/5XZhgoNMv3cgojzprKAkBx/MuJP9ZxBb7P0MdZtDi/HTuBttg5?=
 =?us-ascii?Q?gm6hJFqVFiSNtrNNv2ZfMDT2MpjvK3MUdbtuTttaNoIBQZuCs7gwnGX1D2c5?=
 =?us-ascii?Q?ClPpK/4MmjZUbJoCv9Ocd1GeHFzy+p+2j2xh78ppODIKVGUObp932wbJKJbW?=
 =?us-ascii?Q?KN0PTdUFUgVIs1m8f6EoxHMznxa5LWeHYUV4kkM6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1c8de8-0734-403c-9273-08ddd519ad29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:47:21.3619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTPS5eD893/xOYMzHm9lJSqD0P9VWKuCeqk9v/BKcw8A56KYD9K2gI4/qGSCJuOA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EFE112000A
X-Stat-Signature: wgquyyt4s9yinf94anw4ncpqmaw3h5ze
X-HE-Tag: 1754506043-252645
X-HE-Meta: U2FsdGVkX18KQAevklpdEc7MB+EoR0zPnNSs9npOXizdMru1FYl7xzrK+qO0bhG9+Xdwrha/6L+lsrgktwfbGIWXkhXsmkz9fSOl/yZuZAIPKD0nHq6qdNTjPDeUK7PmwcfKQHRu3RHYenhTxF1C3xoatpcDCf4Uf+4zZWSJikZTSm90U44yG7SsosxI5cWNaCs0Jyuksjcyg3anNhUed59r6M57XZWgdYOJkQI1wYmdDM6JxrVt3ecF62ZhIwoGrBr7kSmOfygUTfXMtb+rVuuLFVN79MgIBoEVe7ZngdNu9/IEKLJefwcvAU5uYvOtfVRxi+3CWzMNrGZv6GIc8d2mw+hdQpwByaYPb2SbAh/p46QrQvglYPmicu9Wd4UlXWACGJjUXicCtFI2dVtOUpSFihYaMiLGI9QXJ+0meB5hDClYXnKNV9IYZjAZW3zzDf2QBRHx6ulTIwzXdGS0r13/i6S+lDjNc8enWAuA8O29YtLX/HNfYvw5ll+/J5wcktMoBZdXceJGiDAlp0GGlwUJWcQW4b1pqGuuOlR6gf9xCiM+7qApFUvmti03ElLeZwLQMXdTQWnCwKvA+BR/hhHN4lvNXdIKm+OJa0j36nH9A5Mvg+6N6DLw+QYlvOWaRIQEhyRAuXmMETpW/GSsDmtUWSpbexeSy5XNHmFld0ylwGB74SCNvK9KpYOseXhX1Kta0+DVycRVQA8ngBW3yd5qdlc8lsA6lSOyhNI1DhOmqqFY2wkXRGfIeJ7Wpd6EhGj89Qsu2FK14O6d0Uw8KlXhPHoJsj8MAMjzVndx3OMCLsYZlOE71WTgUv9ZRMeDjr0R8j6F9C+ZTSUrwtOFWMyiEIPkFF/mTxt6NZ5PMQi5TM2hc0Hxs6wcjNE1AEMObCEmB8ehGlUz/Tct0aHfvnDD7xTGonAkz6vHwGR9vaQUt0XZb9SE9g7poCxaBZebdKXHGR39NSRkIcBGZv1
 qWcg7QEf
 laa002gmTJhmFy0eGpDeMJQcjHEV+tsy7pbOQBVMQ1OhnJ2sYUX8DIYw55ULVA6yJ+kXCVX6ITFtJNPmMl0gnSpwVWIQxgrtAPH+zZnGlWHAbnYHngSIKzEqOLJCO3AqOdgFwKf4lKdmi4aavDs10Pp6zyqR6a21mJ1PQIMsIC2ReAsRysHmAm+DwEvEeO0BQGcZNMupO+Xd1vGafTzCg6461wfdNXtxHM9YsHYO70kcYQULr8gQwHEzUb1YWRhxMTqgdoz6az/+PWMzlNx7BaL9bitrffXS11/v1m/L4iZSZqOFK5YYyTHs2sQNRkYI3hsQE1FUNSR1IlV2kTpGKEpzMRGC8D54zrkuDYf7hZLtQStPevAfnp08sliDUMA9wsTDP5QJMCalrtgRnJoZaY7Pfp8NnETOkS6+3O20Bh0Wy65L0EjIPXK2y7pcCCN5bghS06YGUqC1iioyToMW05nAla34pEyX+ZJ35627VpABOUJpvtZFIh32+jfCFiln+ZO43I0sd/bKuQCJWuwooqyKDM8x/tbb8gHZfvC2fK5GUzYXUpTO71g4tNokTgSO5r5j/2tZeEhSEwfU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> Remove a conversion from folio to page by passing the folio->flags
> (which are a copy of the page->flags) to the new memdesc_nid() function.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h | 21 +++++++++++++--------
>  mm/sparse.c        |  6 +++---
>  2 files changed, 16 insertions(+), 11 deletions(-)
>
>  }
> -EXPORT_SYMBOL(page_to_nid);
> +EXPORT_SYMBOL(memdesc_nid);

page_to_nid() no longer needs to be exported, since it is a wrapper of
memdesc_nid() and in mm.h.

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi


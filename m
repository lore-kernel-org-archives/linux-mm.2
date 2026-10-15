Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A08ACC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB6B6B008C; Thu, 15 Oct 2026 03:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4526B0096; Thu, 15 Oct 2026 03:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175886B0098; Thu, 15 Oct 2026 03:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E29106B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:28:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B3E5C094A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:28:13 +0000 (UTC)
X-FDA: 85324032066.27.601F4D3
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 76DA520005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:28:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I6iCqvXf;
	spf=pass (imf13.hostedemail.com: domain of icheng@nvidia.com designates 40.107.201.19 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792049290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zwSmR+M+kpgV5fTlq8DQkM3TbPgAh9kpti/un6u5J8=;
	b=p9w08DHNrOgelfQIsNR75xt62Lt+5ZuKECUROX+Mco5bRWktKrBdsGVKjiHjxpTZgI/tsF
	gN790Sib8ZctVCZNyATG0sc/GBcyGxBqgwc72zz/ZpLgEaptoqlx/U8+GQB9ODGOBiX03f
	8ggr5F8EGgyC0/cIfeZkjL3lx/pZXfM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792049290;
	b=nITCV2Hk8wfnT0B3vvnpjsA5IT58ILTJTUkzOK7/3Pkwdf/Ln4HHlw/QHXYXCK78A9tcMG
	YJPU9mIajS1lCsG+GZw30gWTHoACy/aKixNVDPfev8phzE19SfvZdrFwfFuoUbi0rKmNTW
	55w6h6iiCZFlrcNK8lrADo76jSGb/ks=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I6iCqvXf;
	spf=pass (imf13.hostedemail.com: domain of icheng@nvidia.com designates 40.107.201.19 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxcjjfLZsvof/+DmzsHjSLWH374XZd2KaMua2oQ2mTaYvQm1whuAflAABlwg5mO7sis+wBjmLK0g0YYSDr+36wL92Sk6/f4bjRgKL1D6tlS/gdxMDdiSOs4Qt4cWdfzZikLofkbOQU7Vitay/KyWMEj3x7jlyDWVeuC9g3GlIJHezUuv/TjLdHmVcgWv2fSQGqkVOjzDYNgMJBkklh/fLFsE5YTeb6DytRH6GGB+b/JegAFlyURepq80s5nzie8UT2Kbi5tC8lB2ncqhcXE38LbyAuBqvCuLFi9bss2q6sVeKi+Sr9S5d+BvjXDEbZei16TSGAgDOozs5Jsm3//hiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zwSmR+M+kpgV5fTlq8DQkM3TbPgAh9kpti/un6u5J8=;
 b=KsAAhTh9S2nnBz0XyqGyjw7AZQJycSMrJqRcgb7br3+Uvm2UAH1KeAmcN8ZFAkBkCdTigXLrCugUWGP5evoJX73aymYmAtWIcjzNLSKOy50AyQx3wLouVrx3m/LZXCA9J+U2zrcxUOMzYhpDzOPx6oa0G/+9Z4s4pc+fRNOoAux+9km3EyhOF89dxepFtRN0c3CqljFQLbDots7E3tCxb8oYnMSMc9Zz2fLdRrgjWth6m7NNejk0KT8lgrIo5SVxZxWKxv90QbrbxkBZTA9WJlVggniz108Y+UhU3GiGj387vlMku860Cim6ZsVDdQe59L9bFLnKf/NqMVhgBu6sLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zwSmR+M+kpgV5fTlq8DQkM3TbPgAh9kpti/un6u5J8=;
 b=I6iCqvXfqoLW1Gaok9ZYxcTOVdFy3s6gcgZKNUwYTwkAlvxmE16UwA+LPWev2x+FdX9Cuqa6pRaW/rzxHV60nTK9kISoKeg5XkvuroBlGL27BfzbNR3VYJCLMd2DEKJ8vKMA7opmvizjnENQ2oVC6YSkTpt71ALj0dFAGG1s+Nmpa3RlOTWaq6/OIsYg1v0qAmspD1DTABvb4CXZvA5oK/IhtjF/j/TzUNYqZrXKqOopK+pmS/i0zPfU/Es4bnmKXocO2gtC/s+HPOFQPAOQvXukGuG+eBK7/rsa48sHvEJiLRvZ4jjpGdsL6gbZEZppIC920PLMA3AlT4WPQXeyDg==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 07:28:04 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0496.020; Thu, 15 Oct 2026
 07:28:01 +0000
Date: Thu, 15 Oct 2026 15:27:54 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, 
	Jonathan Cameron <jic23@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 4/5] mm/page_alloc: Keep pre-online poison out of the
 buddy allocator
Message-ID: <atB-cL8x5CSMOHEP@MWDK4CY14F>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-5-shaikhkamal2012@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010162017.62506-5-shaikhkamal2012@gmail.com>
X-ClientProxiedBy: SI2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:195::10) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: d0488aeb-56b1-41da-81c1-08df2a8dd79f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|56012099006|11063799006|4143699003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	h6sRWnO/tCth3hvfWB9M9Xw7qi7i6g167Ne7HRlUUK53OdV7K6Vuzcj76FbOBK1SYx+a5P3fF3HJ58/W53vZVoIv2NfvR660eNqg7NSPqp6wKNlSaTb90KFFKIq+Nxfp5g5PdT/KMN9nn5IDiTRdTVtDjBvAEN5bSCK8BT3+aqG64gIg3bQBlm7umDVCrRYsX5/59ta3w9aXTQ5GHBOwgmcmGTp2pR9F7h1FoHf6Nt4ewbgO1XDrDLovzNSWiVi4xj4VjPXf0w2znabjGqFVCiRNkCl3pxqkAv8UGINVQdC9WwuMQaE6CNVHj6Ba1kU4wxk0N2OAVrzENGVnjFhoBOV1EI7eBJTCPrbxDzU0SemeaRWPsXsfagRZt4RBdwmaN0sBxOlKoF4pOnRo+UND5iahNDrdQSOse8ahu/91IqPCcFqrfNhbfE0AoqoD23mZ/KxXNilpxVh44SIkI+8OLTZhIYxp2I2dF+2xis3XMB1FI1DlpmvWcJLNbsSR9XZ90EAP6jGEbiH1AZPmVjqdeFXM+x0hEQdybEhT6mMoaErTTQY6Vy/iPQ01Qf9m2y05Ac+xYy3KJdOPjYVsp/qA6cbsf4uQIqwDqbFcoDgi3sSDsKFuy2yLsko4Y9TGhaynoaRBbK8ZxjzwMzwwALRLNoA9nU5ttlgxRpcIWl7A1cU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T0HcIpJrjwZMw5QfEWbfbAiPTEjMSk7vewP4jRqluFTN5EEPZkXDQySVB7Ru?=
 =?us-ascii?Q?a9sqNL4pU/p5HXDh/H7+v4PadDOGj13rCdMgghAp+fJG2+GXkW0oXkttZFg1?=
 =?us-ascii?Q?mWLqn6Dik180hMQY5s2cqP4FgYaaU56JJqt+LmVRDbnoONHS236pMtHRC1XW?=
 =?us-ascii?Q?LC/FjpSBq90jHgBuGLGoBvHEySPrlqxKvuVpbeevUeK0pRxhCKkwL+XnuV2t?=
 =?us-ascii?Q?yCHB5cQissF8REs7PxIQqr5xMc3Ax3/+b7YQMK6nOd1/nJjxeq+qWK21pCf8?=
 =?us-ascii?Q?C8UgXdVnoqYCwP5lic5dpxBnOzf/08Syq5r0/0qEzGzr0pFkpe9Fpq0rjAfC?=
 =?us-ascii?Q?uPkSsMJoDI1h27WWM5mByds+QPEb/R8RNfWfjO1wOozz7A9NntZ+eTX7M9sG?=
 =?us-ascii?Q?q7a7F6wxibEdELBfm49Ku9VtVgrskRmdRxUmIRm3weekSv79n80QY2CfQ6PD?=
 =?us-ascii?Q?6i3WrA/a1/E6OFUccKTNjs2mtVDXRvEM4c7jImCOj4YCm6RWEkh4YWib3f9k?=
 =?us-ascii?Q?M7zkRXbQNPdlR2CceDppbK1bgcvuSRt2sh0yrutUfAog/SGuNp9RyfbOz+QO?=
 =?us-ascii?Q?x5Eg9/05LmV7dbYAXDO/4UQZlYBU/jOtCNHNrzPmYVFyff8FiXOMVIQEX4re?=
 =?us-ascii?Q?e16QBQ8ok9cVrjvpn3EYD4vR7c2G5uuo/QWtRszS5qG3cC3gMrj0RMRvkwbK?=
 =?us-ascii?Q?7bRxnpmy5YYhXgeJKMKwD+7AL4lP9+ySdJjQJZTfH15s7OM0NLBQa7nWn3if?=
 =?us-ascii?Q?BK363Ccgr/oXyFaPZbnRwvjRlWjoiaD8kVDgyaOkPD3KFDGDNdLDDq8bPr/E?=
 =?us-ascii?Q?/8/5Jrdg/WVuZ3XGXmGz1IvJo1XJikI2zAC9PgdeBjIu2/iilSL1EWGt3F3s?=
 =?us-ascii?Q?xZ+eN5PKsIwo0Q6cKuhWq2byfi4R6mnQm2oVYTFIrCSFsEhK4udOpKGqF3Dx?=
 =?us-ascii?Q?FtDHNCTpwXkHtXgSwaQ2Um/7OZznV7xTWSZF4xErriEMPZypHdyn+BIBj/t7?=
 =?us-ascii?Q?j7l+k1oIGUIdF5rnCLfgsR2KxjDrKoh1M3/mr+KXxcbMg6+m61214jhRIQhA?=
 =?us-ascii?Q?fD1pzD9hISVXRECY3+JReaIblicC2SxlioRTt95WI0JYbh4JPNS4dSWm/VhL?=
 =?us-ascii?Q?MGNrkw+4GnS388pUf5ctXNCebBY5Zem67AXV+nvZ//bBCSgzlVF3p6Ss/n8H?=
 =?us-ascii?Q?hhQyP3FkqpVV7VnXk9nDZ0SrX2g9A079/uo7iEk+hGZw4g/oBr9bhXoRQ9lM?=
 =?us-ascii?Q?IcrXWd9IXwSZwpYHYTKRqBXb4QXGAlrfWjXuylsxMc3BjxR3HYjtHAodawTB?=
 =?us-ascii?Q?PR2xv52q4s3VbP1PueamUTE3UI5W8HkKNoCm6N6Rhhro8R5jctihy8J8TkT0?=
 =?us-ascii?Q?SQJ9GfPo4cwrl5zUW7J8mwVwG1YVOYpXbQ48kUeA3ShNxeGRwDPT25EjQ92Y?=
 =?us-ascii?Q?wI77XAq1YZNd+KMN56aTv7LCnUoxbT1UBes9GCMIwCWhh+SspIbY6YCtsl4R?=
 =?us-ascii?Q?o6SGBOySBSfWfRhqdOiI6nIicnCCrhZe8XtmcPyT/uCvrCEGrTvncucG2b3j?=
 =?us-ascii?Q?Mg923bWe0YMeUY6W66IoGKrEtswM3ioc4QcceNv92HJDBlqFCLpqRPHwIumh?=
 =?us-ascii?Q?nCduegiKoOdknsGfMNXDSy+pVugBDquMa1Y2H5wtslcsJxN17H8ohD2R3wMC?=
 =?us-ascii?Q?f2X9udy9OyNd+xyfySDEyjV6jb7atXYD6al+h6X5gMNwLBpc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0488aeb-56b1-41da-81c1-08df2a8dd79f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 07:28:01.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MGFU/kNBiwD89qXs0MQeXcbqJVbUU+EnUitVPykBFU0NX965YUi94Gxw195uGLjPpAWlxJRruP7g5dA5+gyFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76DA520005
X-Stat-Signature: xayxxr7ej4xy4n8imse5mwmgxfrozjgi
X-HE-Tag: 1792049290-290684
X-HE-Meta: U2FsdGVkX19Gqv1qExyq2EG0Z9lUP94OzIaW73ZhsVCrQAz44gjYzM0Haxmm3wukCHUmMbyslscqrHH1xNwvSgOZKKEc4PwPBRcrAqs214gf4QF+H8dtzf4i5zDECeIJ7BEAWqPO9isqWSJyc76iNuq+zmV6dfxUFx3lskypJ+Qv5ggOObiSa3GqRgw+dzIuothF0R1ITJoO18CshyqfkDWWTa5BBXm6HvqqA2mrr7Ziphg5LozEb5sXrvowju7bH0xgWc7NYNFrmXqe006HJXlD92GfpnkQvKns5thl8Y9ioOfW/+TjD4uf/B14ItB/4WPqbv4r4vAJnX31X5BLOjASu5fw5EzeBQ1ve/a2EM58dFEc3/3PW3/5ueDeENSIdUgGkyRB73RPodnz8Lnt0WqNSv4BP5T7qdkTq5N/Mgssq8p913qqQKdZhm4gOnwTdBK5EuVA6qV4Ur9LYDTY275NHiiDRg6iJ4sU4XbqjcILJbEU0mIBSQsDIGKIClIJXvMS8upr7IwwkSj1f43KDanj64m/JAho2BcLCi/0qZG3aFzQ0OW2no6PtgcGypcu0O9qeOfiajfkQgIwC85YD6fCV6tg2CKsVtcKcnFvPcfBuI84UNqEKAWdhnL2QknzdkcipcyD7EvQNtEL7WkO6zUC0uGzJOiwHbTJmWk0GMJeTOChlQXWFovOwrHWojtp2aNpGObiloZBpi0pfkYg0W/G0Wx/U1fXt1TAisj0tCeoBtIui3gkTZZvfrG4357QnzSWGM4xZ2dPg8uxm+a101jdksMBVJp+i7g4UH3HqoKM4/1QKRH1SutnfzyxcyW23YVLwZTAASuAPHTgu3HJYRIR1qTkcYdzABGBa71MIJsBSvsMzqr4DmyoN5Y9LWxf/GPBoVGmt1tvEJ5iRq2enwRQArPNaxopsadbjGvlzsU8F4fvAViX6LMu4u4QiVhTFgG8MWAHvYSkiJwa6L8
 nHj3kyGv
 HXqBzpfiJBWKGuwcGlMc5TuVE2oeVl2csatwPPjhH1CpTDaxUvk84XIu7JI4nbX6FBXPzQtDZMruafGZtpmshvu3ymUyv3M8g4hdXeaimHZgdESffHGO3tr+N8zR8HIkIWdqe2Ix+sSMLyEAQhSax3SgtcdobUZO5KKCDutWt225eF0ODGZgmPIp2Bf9IU0usmf0slEGlxYmW3lqBnh2NGm4RZG9I9469iivJzmKTjbbwVVlkDaWVlI/j+J1cGEkazYtW2W4Gsn1gTWv3ahiQYX+FcWaEW7SgVM+Py2bJZN/AFySb+0+22wvpSQcPbwMwD65hr8V1ioLAoxCDo1w2O1Se5GbJTpbq4ck0XgH+0Flt6R4exGdoX409j2khpVqqvCLyPc1l8+fg8LWuMXmOmSwVJjh2jDYnd1YpoIzFIjcsesRn5Moh177TB+qK04bXZ4KfZxxEH8lE3rWW0P0P0BkTOa8cNGw0Q9ifgZLHDLGeJ0WdUoZz6TkCIahlVA1sHEcBWIxqZwmulsQb2vEjFEJmiV0Y8l2SI+utfGHqYVBnwQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 09:50:12PM +0800, Shaikh Kamaluddin wrote:
> The inherited-poison path checks initialized blocks before releasing
> them to the buddy allocator. CXL device poison discovered before
> hot-added memory is onlined is recorded separately in the pre-online
> poison registry.
> 
> Extend __free_pages_core() to send a block to free_poisoned_block() when
> it intersects either poison source. In free_poisoned_block(), withhold a
> page when its PFN is registered as pre-online poison or its physical
> address is present in the inherited-poison table.
> 
> Pages identified by either source continue through
> hwpoison_boot_page(), while clean pages are released through
> accept_and_free_block().
> 
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
>  mm/page_alloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cca67a2702a4..57843df01b2a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -33,6 +33,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/folio_batch.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/memory-failure.h>
>  #include <linux/nodemask.h>
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
> @@ -1601,12 +1602,14 @@ static void __meminit free_poisoned_block(struct page *page, unsigned int order,
>  					  enum meminit_context context)
>  {
>  	unsigned long i, nr_pages = 1UL << order;
> +	unsigned long pfn = page_to_pfn(page);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		struct page *p = page + i;
>  		phys_addr_t phys = page_to_phys(p);
>  
> -		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> +		if (range_contains_poisoned_memory(phys, PAGE_SIZE) ||
> +		    preonline_hwpoison_contains(pfn + i)) {
>  			hwpoison_boot_page(p, context);
>  			continue;
>  		}
> @@ -1652,7 +1655,8 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  
>  	/* First: a block parked by __free_unaccepted() never returns here. */
>  	if (range_contains_poisoned_memory(page_to_phys(page),
> -					   PAGE_SIZE << order)) {
> +					   PAGE_SIZE << order) ||
> +	    preonline_hwpoison_intersects(page_to_pfn(page), nr_pages)) {
>  		free_poisoned_block(page, order, context);
>  		return;
>  	}
> -- 
> 2.43.0
>

Hi Shaikh,

I think the idea of discovering device poison first is good, but the boundary
should be more strictly designed.

Now if I don't get it wrong, if we turn on memory_hotplug.memmap_on_memory,
we can have part of CXL memory to do the bookkeeping for itself, without
using the existing RAM.

What if that bookkeeping part is poisoned ? the check ignores this situation
right ?

What about draw a clear line between normal RAM and hot-add CXL memory, have
the latter gone through the thorough check and do the rest you want ?

Best regards,
Richard Cheng.









 


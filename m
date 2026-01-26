Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F804D19510
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6176B0005; Mon, 26 Jan 2026 13:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874436B0089; Mon, 26 Jan 2026 13:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B656B008A; Mon, 26 Jan 2026 13:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1616B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:31:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6175A13B9EC
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:31:26 +0000 (UTC)
X-FDA: 84374957772.20.2B86A3D
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B4528000F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:31:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fBC3gfX/";
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769452283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGgbDAorOlXVLa9tJcd5082PBX9Ynel2eawhWF8bjOc=;
	b=QlVtF2d6ovQ1mNPfNbqK8RPDM60hqmFQMXiQCQEM/IgwMaFe/mLA14eQat6CjxjtkmyWmJ
	N5HBRAuzlXl2d0V+zjRgWF++wF8+Lgd2/kpNqeLRkAvnVKk6ulK3Mk77TQsN4mgkcuxEBT
	+ETpeh7V67PrlxKF7h86stGRiCa5Wp4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fBC3gfX/";
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769452283; a=rsa-sha256;
	cv=pass;
	b=hO0zOn6JM5NN0BdkyO3E1KL8v/3Q+9GFmk/+5xwGj4Afd71AJTXf1aenAYvvg67I555k3g
	KjN6UldBTrxnyrcyB5tlKYXh6D5gO00bNs9Bl811X9LaKfPxbzJK8VXEuCeJeHuDplNnOu
	FovI3lFCoSOVU43+gQ8VwkUf/r4HROc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LLmjNW0Hl7GfZLtryt/6xN3UbCSxsM0yj6Ab5anAh/j06W8wMdKI4E9Tthjd6AkSDEYlt6P7wGyDfwY+fFpfK1FP78lcICknvT8kP2ASb8MFgsX0JREQvv7BtZTSyJALpqkXP8M51SD1s5Kr1a5PkFsiJDUq/kGfG1nWTk6u1ZFJy4gEnzwyXvxyuUtXPA+BBlbkHBh6WMuOj9DQl65fc03CwL5DO5bH69iS//f4dOFL29s70g88kJG5Nik1+1d6avZu7WVblSW9lrIy0PlBc9m3J7NvTVl2/6QhN98uIoJniQVgZr2/ZE9aYY7x/oGdHgvrjJAPLfWGdRzOPzXfZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGgbDAorOlXVLa9tJcd5082PBX9Ynel2eawhWF8bjOc=;
 b=Joesc7uqwej5l34r+QMKmKAYRWcmcdGpjEyDPIG+E9DuMK4S9zSP6s0Sux6UeGewLYheOkz4oBNA6MVpmoZD6RyY/bgaz4faONY0iKBtaKSU+FOIXbjpkFyvZ30SyAbWWnYLhzpdcw/TQ+vryrASipkG+0NT10iCUBbkhRwZIGYE3Agk4qatf7GGGAf4yCWwmxPusd+wG2UT+3bH5ciMtnewyNPv4vNFZktgmlJes+808Sm5hLv50yvea22FgviogyRJ3CCkJ50HP8igZW/1+v+ysPEdnOvDl951LRKxHkLSO1Gsp5yZYhb/4TLGpuxvj04d0TvFpNCncfkcZOTW/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGgbDAorOlXVLa9tJcd5082PBX9Ynel2eawhWF8bjOc=;
 b=fBC3gfX/VPHGgV8a00VcMO0Sbhl7zkQWogXESxeTAamR0fOKzEmv4RyxkUsJ1USPj0Gv4uA/2UIuJfdshKPnw8gUMz05XdaWn/LQkLvnGNAEOvTq9xJViYW/EzqzF18l9sPyftnrjCQVPBeszzY5hRUdfD2Zwiw3ZVwe5llvKmIvsZ4v0urWUlr+eHUM9laQmOSiYbsi0MMNmcZoqkjrbhso8FAfGO2e8sFqYBZsDmps6ItzVQJMJQCH/gkAyAiEIel+ovbB4V+AgRKv3Bn+SwZgGHfuW/Ol6b/ADFBxEG2VK5mMl8IZOpXFHv+Ycd02SDGlAmlOIpVjHZ/M2tuLdg==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB6682.namprd12.prod.outlook.com (2603:10b6:303:1e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 18:31:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 18:31:16 +0000
Date: Mon, 26 Jan 2026 14:31:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
Message-ID: <20260126183115.GU1134360@nvidia.com>
References: <20260123095854.535058-1-pratyush@kernel.org>
 <20260123095854.535058-3-pratyush@kernel.org>
 <aXYGkb-QtYNaWYw4@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXYGkb-QtYNaWYw4@kernel.org>
X-ClientProxiedBy: MN0P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c408825-bc49-4c3d-6e25-08de5d091763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qVtRhqhpUqs08BGXmuwJEi69l/IPsQjYBBWx6BpX5L6C5t3DZ/vDi2fxJW66?=
 =?us-ascii?Q?MOggjJpP2/nmelhwTLzkxF6XrXos/dYJV6/RkOz5HOQiNTVfMRxpghEh2fsS?=
 =?us-ascii?Q?MR52/XXa0KyZFQw2BNpFc0rhTRgFpjC+rjMUXg8VwNaSaV8ZiBg1QkqQkAj6?=
 =?us-ascii?Q?7Aac0lxCigln7wQYJ1yAggWc3yYEGsqEBytooRU84IiW+QaXRIWRxcuGsl0o?=
 =?us-ascii?Q?cgzgKf/yKkkIkerk2bKrrQsRM0fyXqFhy1gmsa1eLkwCBkuszT4YUvFe7Z6x?=
 =?us-ascii?Q?caeBBjPJ/BVLtFX82tSChzU68zsekwJDWoPCoKIPoyO3FsCcfd3AOLWXGPO7?=
 =?us-ascii?Q?grNepoKu1/R3mXGQMb6/vrrUZ4gmNlv6Fu0PDvqTGOvUHQ69etOC5orttfOh?=
 =?us-ascii?Q?ULjtQXBOsvVcmn+GWVI3/M5NayWaytWRG5A+oiReRITTh4MOuwYVkgkdzVuX?=
 =?us-ascii?Q?1IFlqmk+P2S+ybYZgLEuD0hFcyC8Hl4gXWh74XMME3uB5k25U6VY81LtbG67?=
 =?us-ascii?Q?rgWjARTKqw1VBnvqLyUEZN7B19xU4LKeBrFLq8FFprdf4BlJlRbkdztzSp33?=
 =?us-ascii?Q?fVhcmHN1+4ck6O+W8YsJlPLKNgXSjw/xZJsl0rBylbOd4wVy78F+byJX5uUF?=
 =?us-ascii?Q?V11bJSLp63DpYHRuaV6/mDbwyeABXWE8VOw8SDiBUmiBwOvSImcpJpPkPbi8?=
 =?us-ascii?Q?a/qEtzIPelqJPft8lqXenLyNSiLbpuB6FwnitZ6sgeZXtjkPr6zk72YXdk2O?=
 =?us-ascii?Q?x4e1VMVyccnBHOSlN/oFU0s+KeziHpkHr4oi0HiFJFV1y7acclJL0zS38ejk?=
 =?us-ascii?Q?AXLnHd/l6VikefaySFRnrAUMpP4ugIA1wZl1AK0/Wh6AXzXnwLUUY/cVO0kA?=
 =?us-ascii?Q?wTRfsEc9jDnbSjU4tVpKf4/7xTLxC62ID930d982Efgad1fnOcG9oIxynpMk?=
 =?us-ascii?Q?mCC1OvXmw8yHYhjOjyV0YMPBJURD99YxPd1FkFGy/xmctDYqU2QCS4pHhVje?=
 =?us-ascii?Q?vtopGl1TZIsR2wnxW5idcebNBHQmSh5Fs0/1gme5TdbdHVn+ha2A+sec80dX?=
 =?us-ascii?Q?jcKZKqVFjwfo+q0iC31N3B3V2GlLIeZwY4hc2WDJqgo2iH1unxvd17D9/R5u?=
 =?us-ascii?Q?UgcWAw5nOZ7nvVOWM9H1yFXKIvQ5YBWjuEHOrV9gKqBLIDRb+Ru1najBIDkq?=
 =?us-ascii?Q?KqYq54o3+SOAO2MSDznvyvRCc5ngjUZzVobcXvrAeqjVUq/ZLXGdp1XLm9/M?=
 =?us-ascii?Q?v73WkrCEFOmq6vSK/LtmLUurmQ+4rWFQDWzJt1nhOhBexeTqjs6O/+XTf49P?=
 =?us-ascii?Q?fTEIKHsfkOI76Nlii+tJBXk3R+YO+lnaOHh69hTrRx7jrmmME9OlGiFv9GNJ?=
 =?us-ascii?Q?xJPIFx2IQH1VbCO+3CdQtzO2qtisnBAVFY9CSue+hYGCebG2flSNgKgjaC8w?=
 =?us-ascii?Q?0iajLh2sbZL2K5JkK9zDlo1VcMbmkZHOLC/EJpiA+4UjQaYJ+XrjAhEnVDYP?=
 =?us-ascii?Q?HrMeKJHnP9OUzMXdWcPwuP6H8JmnhPDLCLfkFK4SVDoCZKJUHrkxIWtMLv16?=
 =?us-ascii?Q?zSQ53v87wperW1P4aSk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7RiP5vUpibKD/rv7qPw9+OYKR5HTkwvbGyjedW6gWoh3Sp1YCedgbyxBoC5b?=
 =?us-ascii?Q?PxihbZmCBRpzv/oTK7Z1Y6eLUp0LkAB4HtB3dKhd8QgsLrlryB0ygqzIoMYR?=
 =?us-ascii?Q?PTFDRB1WiKMZvJ0YeIHwpk3BNhK4KN31eC/li/WhtOwi1jDZncBPubylCcq7?=
 =?us-ascii?Q?F97AMXAluK+9eaSI5ax66uybaJ0FW4ZstxZOh5tLNsZSo4px8Mev18GPfHbL?=
 =?us-ascii?Q?3DCZL1eBODfzsvvfwaBSxoZ/3uxfxOCri6nBAdXspKJc0cELzeE51zj5sbYP?=
 =?us-ascii?Q?JNY7JFlsD1HKpRtepTQpeP/5R9hWYvsy6+4nAgJFbOMuZSP7c5D0YsqqzURj?=
 =?us-ascii?Q?ym6HKyR9iLqUOk9iVYkJCk8MT7aJOlYYOLtN0H6qHqEBg3uX1Ev4d/hv/qox?=
 =?us-ascii?Q?UftXpLAAjSZDeIdME8JJbo94OkMN3vx2F0kFcmLEnMOgSk97ksUoRv1KtKZi?=
 =?us-ascii?Q?MX6mss/n5SDyEzB3MVh06P31qCAI9qMuw3ckduycNCMrEADCWrV1LbxKEz17?=
 =?us-ascii?Q?nOK146WhG0ec5NCohu+SlIkDv6wSIGpKLymWHKS7HUW8oOvsEc8amNxiVoxo?=
 =?us-ascii?Q?JLSa8ITvNBoexQC6w/ffi8HWVcDLxkOGo2IXLsTPVDT/M79k0cPqRCkItnPg?=
 =?us-ascii?Q?/n0awa2EOc9Y+UKQRYctsgvnr5Q8SRe/HNtv9YbgCeQVKyi/wvjMON5VsuvI?=
 =?us-ascii?Q?Y8dg91TWQR+gRVkgB4xPNFqoc1sNA9OqTtdMzlx0czSLy6GuSpy5YX+opvbb?=
 =?us-ascii?Q?FIMveE4lgRpHVd5HKZSGNxrchHrSIwdPhNm8AZx+pMPwdNS+wg3ttVfEbseK?=
 =?us-ascii?Q?E4Itw2ML7NRpFotmMTqhEsKpWK3CFuHi9S+/GqEozn+rbh79+JugOzq5ZnkU?=
 =?us-ascii?Q?0FxANeDCPiYEd5FQOShq2923tXFzrpQzVUqZzbGY5N/VUTqArd47MYztDzAY?=
 =?us-ascii?Q?A2gxyGEzfP9Gbu5eUeZATMl4SDUJ+TkLKjY61FEqKGOE4ZfMiYHNIK8M3hGQ?=
 =?us-ascii?Q?8IDEWC9kPN2PMggA3MVd2+4LoR6rGMwLqrNVYpfQRS/rFOvLSAqlyWfqDcp8?=
 =?us-ascii?Q?yF/2/o6yXPGBL8sjlEtW0liugWfkqdQXT28p8AoAqXJ8PdUKZ/Vu+ugizJxD?=
 =?us-ascii?Q?wjEJ8fbGG0xGKvAqrB8o9WY29ZoRLdBt15WQVcWs7i1h/TY8rat8uL4wUKoG?=
 =?us-ascii?Q?Gzx5llSX6BjIrF60Jb83EAXE1HgDVog3LuZSF7VfYdxRWg3qIAlHJqEXVDA2?=
 =?us-ascii?Q?eVcIDl/Jcx8s4n4cwAorRGmBpiWPRrcCbLI2GOfy3nLh32HKPZALo4fJkGon?=
 =?us-ascii?Q?dUX146D0fSZtXwBZHQs4tJDhQcfdJrqiIB/jmEFOWXuyudrNdqh8ZFUx+UKR?=
 =?us-ascii?Q?VKFbxvEfuQXUOsI3GwuXjqY0CGV6JczbW9gL8FdGrBD3NvI3GqXmgvu36KFW?=
 =?us-ascii?Q?RzWKedSwOG6bPaYZFRrz0WH85AxvpG/jgOjfZnDxtM2IkGhdZPg0XMhF2z1F?=
 =?us-ascii?Q?gqoDkCqfN2C7GLNtp25wOIU9SRRVKxM/l0fpTJy+X19xSqYja9Ti9DNwBIGM?=
 =?us-ascii?Q?8xKTNHwXjpXI7KPosHMbfUI5Dx9tQQxAlrvTrm6c1fv7nnEBU8/I9FmI0Atn?=
 =?us-ascii?Q?lrJgdjPQWPD+mxpECCy+OyKJ+nwgnjD2keLhU8yaE3L/g3tyGb1mmaKbsyrv?=
 =?us-ascii?Q?eEr5q6+aP9hjbSUOclqAdWhpVCaTdaJ1ugdbrm1Iphks4vaVKKdLoHzAn2bR?=
 =?us-ascii?Q?hmtstmXXeQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c408825-bc49-4c3d-6e25-08de5d091763
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 18:31:16.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGW/oedD6VHy5jh4o2wrNUWI0XLhNUkGeLyDPxtAVQTwC8TsThNgy1YdDK5g6Y5F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6682
X-Stat-Signature: uedgoa3dkxukaje9s3nuem9bsuxnfqc1
X-Rspamd-Queue-Id: 7B4528000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769452283-900640
X-HE-Meta: U2FsdGVkX18fz5vC4gbBlqzI5xg+ztc8WnNn4QFn7Qy5Hlz8QnOQ4+vPfn8N6J6W04oDAOOiC6x7IeaWmkwcZuHvpTHB4mrd5oICR3e9zH45XmTsNCLae7raVwXpUcXDzjo5fBP+RkgoE2s5bylRnd4g06BqJcb/2L9U45npSpA0pZJXUbGelfdwCvQLfygks9Ph9duRVpEDFtsx2FgXCvn+yH8hrLxBsCmq+mqZlaA54oVFgioRhE3x9Zh72YPHJLvT5bj4+opEwUD5kbmP/wFsVR2O1c9BO85NNE1R3cFm8fS0RP7eImGOx5t2esyMdaR8CXajVjOHelvGcNpHUsoVOpMr/1krazxu2KfVr/7FR/nLNBCP7gC4JbYi+Bezw7qcOFheCr+1ZImO7xYYWu801Z/YAO1v/f4tN4CrbMgkVE+sxVGNh4F7ZihgB6GMJ4StYNds0FMezpn/8/9WiVgpKkzHW6PvXIRCqfj50KKN4CZR6tlcj7OjcuZvR8MLeB5i+24vZGKubSTXM/cllIC1OGJxYfZwieZeLAuOEjqlf1wu1AgVid4ehSwc09O6VMUGRIjaUujN14sMMynFr8HxIcSj0wBy2SAFrjTFZhGaqs54u4YjojXUq47YPC6Kw5o/BrUt93tXPfkdPShAAWzrTPd0Y6BGZosBqG50XPGV+p0KqBbXmJY8tNEo9f/g4Z/8+uEKf04AsVs0KwZRhJYafCf3IIufW0dl1E29ZAB5aC982F5UXIBs0QQflm/Cz5QJLju81xefaWGiJIWfK4/Tlf3x4SU/erxm0lrofYXqXfYs/37edVCH0/pbUKdZSNtkvkCt3yXfTsnzkHmT1vJuTIqFQBw5v8Y5VcR9kIKt45oKlJH8FrYjbdvAtqC5p6lwMXbQqVbUINJcExQrL8ZHUpsCeC318jrY4C0zqVhyWcDVCBheNeEDVg8q05UdPeAuHncol6/BLrlSlLW
 MmfK4h2l
 tlc4dyvbRUQ8Jv3W0OSlPdFW9wsxBLabyBvffzQvSwO9fofho7TlCuW58BvIF2HeQaeHPRBOezomIml+jHd9BKmf9KvHySdulOFQJhDxxAlYEP6FRN+zi/FHVT1LvezB7aAaoiIyWM/oXSQi2tGusZpKHDVnTZuBCaqC6xaqrsivG4vHjzU7gleOxBZ8NMSak+hARFMNVBn+LnQTOeyIu0rSZLJcjRBuEJPhpl4XENBgS2wn2Emaxde2fwEpkTfmSDNdDFm5z4xkt9Ky4uPYHLUsiVXdOdoWebAR9/IjwJolEknlLlvFHDMB4QxVPQPg5R+lLMwVUpXM414F4QYt/J3nR8pgzbAODpEjEppaucKUOKQ/qgm/GPRxDQWJseViSlDNm7RF+hU2y2yOYcqzBYYBKOOAJOELwIJycZYfpZVT74D17NR18Ozsvxo9Zh5GVDuYL8wlV9LdfQG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 02:03:29PM +0200, Mike Rapoport wrote:
> > @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
> >  struct memfd_luo_ser {
> >  	u64 pos;
> >  	u64 size;
> > +	u64 seals:8;
> 
> Kernel uABI defines seals as unsigned int, I think we can spare u32 for
> them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
> MFD_HUGETLB etc).

It is a bit worse than that, the "v2" version is only going to support
some set of seals (probably the set defined in v6.19) and if there are
new seals down the road then this needs a version bump.

So I'd check that only supported seals are set here:

> > +     seals = memfd_get_seals(args->file);
> > +     if (seals < 0) {
> > +             err = seals;
> > +             goto err_free_ser;
> > +     }
> > +
> >       ser->pos = args->file->f_pos;
> >       ser->size = i_size_read(inode);
> > +     ser->seals = seals;

..

> > @@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> >  	if (!ser)
> >  		return -EINVAL;
> >  
> > -	file = memfd_alloc_file("", 0);
> > +	/*
> > +	 * The seals are preserved. Allow sealing here so they can be added
> > +	 * later.
> > +	 */
> > +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
> >  	if (IS_ERR(file)) {
> >  		pr_err("failed to setup file: %pe\n", file);
> >  		err = PTR_ERR(file);
> >  		goto free_ser;
> >  	}
> >  
> > +	err = memfd_add_seals(file, ser->seals);

Because we really don't want this to fail :\

Jason


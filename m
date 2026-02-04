Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C907E9D410
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E3C6B00A1; Wed,  4 Feb 2026 11:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F59B6B00A3; Wed,  4 Feb 2026 11:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF926B00A1; Wed,  4 Feb 2026 11:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7573E6B00A1
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:36:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3FB3D1C0A6
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:36:20 +0000 (UTC)
X-FDA: 84407326920.09.9E4148D
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	by imf30.hostedemail.com (Postfix) with ESMTP id 502F78000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:36:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hHYlUMrS;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770222977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIACaWBzbIdZtVMgju4ygYod7D77Gug+YYMke0S6Ppk=;
	b=ZsQrUD79rnsJwzIl3GXYrPdx1EfABTARxtIMGNF+H+Y4pNs6pH2j9n7tIJBr4loxyAXeTs
	XbAALCD+yKpiIEhIsohIQTrcBKEXycwk8f0bDyora+41z75uwxlBFbbpTcoUrWfU9J6o+q
	2wz1au9c1+HZNYNjkq5Pjl868xHn/w8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hHYlUMrS;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770222977; a=rsa-sha256;
	cv=pass;
	b=XzwlIh/iUVpdnFao41nQ0YrRLpPJ7OA0gEglXLlnQ6wvjhscTRWAY/T6azvWF7QGfA6G1u
	0LhagVP0ha6QzzIBCMypLcaBaxd3cQpoFu76K0hrpuqyS4SmqZSTCSlKI/gJ0Lwtyhcl6c
	gJpkVI3DxzEI4Sozf3CN2sghcRMVEVc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=heQ41Am/QX6WFHElxptiT+36I81Hp2oGSCIT/5mJOkQcaHe8oMOeIcgSVz/Rx5nxfpWrH7MvWYSvbKBt9dLhQHnzaBPNd32hrmrtrMV8RutAoqRiYrEQHKTVkCnVEnUMSymRpQqDBXsVMZfJyk2lCc0YSPGZBxav5e+jl9aYK7MEN335Rz25jUqdX3v+dxF9od0NIBqz5v/1W/Z3BpJOOU/VSloiVWK8Zr4B6a77rqhqqPp6i/ukt51rAy0/Vj5GPQnY8FXYWgThyykjuu+zi/fSStv45c614GiIC3DYW81lIgaDbMYOTxb9dBgmpaJw8wZoyO4WcgpdiJMxcCfDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIACaWBzbIdZtVMgju4ygYod7D77Gug+YYMke0S6Ppk=;
 b=c0xpP/9TJEyuvqIfJHAuU/i6PkiaalZEECu5BUnWqDAwnfivPszw1112HD+AqAHPImvoZJHzoJjeO84l9OSpwfvQFyzS998qHjw9tK9kgxAvE0kxbOowbqEvTTW+1pzj+zLb5a0x3HtpM5djFbp1ezOGbQ4INGjhS6+9gpdxZpsQfN+u7FfJ2+0ILxVAxut3rhYZhjY91kfvAhjbGoVb2K+D9//A4yI8IwYlEkeQRWd7Mot1wrOlgCatuCDcwUzA3ReQEpw8w+sSSGR+HZSGBB4w0wiQflQa31flx/oJanYa76SmIMDuf+J4XWiHcn8tcbZzwQTCv4pbl/SebXYzpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIACaWBzbIdZtVMgju4ygYod7D77Gug+YYMke0S6Ppk=;
 b=hHYlUMrSa+C+50nOBORgh/9ZHLbY/TVw1cbR5LJhETvE/G9a/R701YBldRVPcEegLj28Pr6wWyJlcQ00/JWUCfNPuDRhiIrTRWPmjOsjeGi3a5O68NPTxWLvMaTMVEqje7143DD2+0FTblsLI8DTL0OdbzsYGmtSpd1N+e3I1/VnZ6iXVLdlkK9HHquw8uftA2Rjb3jle+wDWfFvs7IEpNiH+IezCCaGkpVTKkdKTDr0wc8PjEgng5prdrZkOg8XNtXPyYIJd9J0v7r+VcKv5azCHG4pEvpjcqn28katMGbjAhFkpQHFN/IOItRjI6pixtMkDHbRsQhYo8k0MH5pCQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 16:36:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 16:36:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
Date: Wed, 04 Feb 2026 11:21:01 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2EF8F5BB-7CEB-431C-B9CB-00B1E3E44E1E@nvidia.com>
In-Reply-To: <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:208:23e::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d98c8ce-6b5b-4204-5c91-08de640b7ca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xmo7MMnEoVqQru4a7OM4msibutPvJM+4OjR5ddqnXmyp0hW+fT/0JgeRtzt9?=
 =?us-ascii?Q?znkPqsYNQYlTWF63i7iKEx+/x0rx3bY1AfBsQ0Hk+l1vtFLF+S9QUVNqk2mx?=
 =?us-ascii?Q?el7a6NiAIq8NHHTTleCN3dxgsuZmbQvKHhquXPmnH81nmSe01zqzKL2ZA0Og?=
 =?us-ascii?Q?tL3VI+Ce9A+Qxbmv9e6IQDbjKgRA5vX9Dh4/eCvdMP8GiXeg9YeAnevSdBWo?=
 =?us-ascii?Q?3ou7rIoNnvXh/3ZGzxiutdlC0XD4KQA1EjLkO3W6ZnGwrhGymwAdBh0scnjT?=
 =?us-ascii?Q?JC/iaI9H/MNmnET3zEtLbwRCCpMhDXs5VFPy+cSDiIj8H5ajAJW25qaQrSrp?=
 =?us-ascii?Q?SDEgWOf6eCDDI4F2ky2dh9SZR3QD2q+LOyyeykHWYekcVsSYfRJCsaCjgE3e?=
 =?us-ascii?Q?BaSJTsOkSsAdrYsbugPoWToytoYDwT//xqx1AskWIBetv28hyNVm/mZ7FBYP?=
 =?us-ascii?Q?QsK5BZYje0ds/AHDsKC7sZtXLETk+BztUuWAUQl9A+RUVFuXV1erzZRgfBTS?=
 =?us-ascii?Q?m+pZLHXA3K0HNNzcv9m2t3Z3foChooQxs1KK63ePno0xRh7ORZEg0fgDLjnz?=
 =?us-ascii?Q?+e1+K3hG8rkYeZSScX6mzO6kvPe5CddBOsCzKZ2CIi0AtZxfklfju8kMZ7w4?=
 =?us-ascii?Q?4ZDlvTq5VRHyh6NvkmYPUpzvyI06WIcaHvJctKQ4kj4oyNpIB1hBnKCIsy8U?=
 =?us-ascii?Q?qShydc0lUS2Vr8i9w1Uiqe1l73J7JdRv2/rDDoBpVhINcZbMA6Fp0hXOsEp+?=
 =?us-ascii?Q?7FHsztpXLzA2rkok4b6wYVtVxJiBKxJDE13NBMb6N90mF/EM1yFBSMH9xrYD?=
 =?us-ascii?Q?Xf5vQrlK3ak2y2tuDUpSMGHsY6jrfpaOaIOEchM7Z+JZVdfHeQLGID8UcpHQ?=
 =?us-ascii?Q?2uWue6+EOHjYe/YAV9zj5jm1kI42olekuqhtxtrgwpufACQmAvtPH6GPB9zh?=
 =?us-ascii?Q?zo109I03mX8w7iFyjemy19m8whVpxuSo8nx0Ylhp2E061B2r+lEPayjgGm4W?=
 =?us-ascii?Q?qsLlBM6nUtSM5vkJTX0NvTbG4mL/NuCPS57FPGLVsl7B5SaZZWdg+0I8KFzt?=
 =?us-ascii?Q?NeDI+d6pNXYkV23pY3QtEefWlD5g2T9QsIOX4T5dM3sfAgaYMlriPQdV/sG5?=
 =?us-ascii?Q?0c9/TaS6VsQNSqcpftkVuPCLn2+51xm3lJb3vTbojiiL8qamdoqK0g8RTDNB?=
 =?us-ascii?Q?3L+C8RjAa/E4B8fUa2e31lH7ej3tqEEwCyYSVW9NatMOafsscvUk3nz9cEU/?=
 =?us-ascii?Q?jE3xE96KMKwSw5LuuHWW/gnhpJQLURVTVUZduZo/qnc+sifdDf06TOiYFiwM?=
 =?us-ascii?Q?IVBM7ZKc9wxcyWnyLS66VQv104LM8u/GenZEUukVFpc+3fF/qQr8kd9Tzh11?=
 =?us-ascii?Q?eiJtdOlSw2JtIblo4A/ZBi0pZLb2+FU+4vIBhDNuRqQBHdNVZLF7qYMaDtGz?=
 =?us-ascii?Q?GpMSYEzNnUmCmdfOIkk/nZPt2nxNJgxNX2MSajMjNNzr+8kwbNLneA4v0n7U?=
 =?us-ascii?Q?bLhN5Iej/duS0bc+Z3suFsnVcUrLACAwLu6det6AtQafRKabjaPTxgSluV0m?=
 =?us-ascii?Q?7T4sLhcWKR7aoby0Cso=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UaADDgoJpYLwLE+vwm93zx5iGvIu5K34wj/UJ5FwSrPlPGhi5EBY4YUdUP4I?=
 =?us-ascii?Q?5MibvhOjqm8LE+zy24f2jei1AlaPZfmvQDa2P0qlz743u5oCHrKKJogmIQOG?=
 =?us-ascii?Q?IORn1egkZte2T1vr6QttKT4dkuFUlKcmagM0swfSIKli6VOn3hIhISv+KwgD?=
 =?us-ascii?Q?UdHKhJ+Cd//xBS852nY1Ms/Ec4nWEZ0U07/xLAAdMIPvg9sZRKINZsM9hzk1?=
 =?us-ascii?Q?NbUelN7vmVhRjvmLPhZpQEX4l+/PsPK+0Ngu/OKxX5FhuAjc1wDWKMDmIi7X?=
 =?us-ascii?Q?NgW+MJ1IHDSGB71vRtNvrl73HwQgGZoJ4mCcWYGmMD30NEf1uXPt2a6Ap1aq?=
 =?us-ascii?Q?KyZQ0TnVnqFO7CwAHY0KRhzZr2RJ9uCByxWor+8N52+zgYfRYvzwFx2CLpVj?=
 =?us-ascii?Q?7V6B9uPKUCMrfHyJgaKB36YPz7F07tKvtlAnOM30sX2TcJellIKQsQXnaU1i?=
 =?us-ascii?Q?dzYxBibvEikzrVXhNqELaREMbQqCDxlxLn4tNNG5vy5TPAHFqmto0GANaJAm?=
 =?us-ascii?Q?/hlweEbTFsaiPNi6gCFRRkBKFycgImeJM8cPWPsAb40svLgvfMEvbXfXJ4vX?=
 =?us-ascii?Q?FSuZVfMmgjwO3nDUsEssEQLjwNxxSS415PUJzmD7FE4Oc8zidMKMOsylBLyq?=
 =?us-ascii?Q?pJVwLD2MjraW9pfar+HMguuFA1GXyCeeraGr8r6z6SXXSrzFRWZNNAzkkY9z?=
 =?us-ascii?Q?RkxbfAnq6E+Fn7Q2OPxWYiOnR3Kj736N5IzrR6wu6ZZxjmVWduYgGPUvJxHX?=
 =?us-ascii?Q?/biRUAjxdyiHnr5f6TT1nynHKprFSDnS6AvbW0arpLyr1qxhCOerR3ujsQR9?=
 =?us-ascii?Q?QY+7FsUB8QqoU97BwqMGdACkgxytHSlOw6yD3IF+aG/6ocdEb5lTfCEowfwD?=
 =?us-ascii?Q?ZpKjY8/MD3foVLlcmC9hywd2gq+qsxnd+VKZOHkBETKHSUYVarkqkogcGrmq?=
 =?us-ascii?Q?iFEKrhllDCglmyllovDq0DlQoZzIj4CFJmpGGrOcOxYD+SVZkhc1BWcNnR+G?=
 =?us-ascii?Q?8Sv5/N7pLoUvMgMBYwANal5AQdcqY2HxtA6xD64kA6eemGG3u5eteNMNTgkA?=
 =?us-ascii?Q?MKx+KZSuS3Ux2YsLSZqlfZrAefPdTFrb4eO7ktT2R7wDTyOpUxqU85nIxu/J?=
 =?us-ascii?Q?f7sbnYsWjveASg3KiDO8jfwy6Z8aaWgOC0HzeuIu/VmerNGPabQ/F3qNoeYw?=
 =?us-ascii?Q?/t+lGQ7N8a+itxkvUv+iSpmUjzb04z4ve8+7X5Rs+K9qQmOX6V5YuY8hA3z7?=
 =?us-ascii?Q?Bg/LTGA7rWOYXc/eO4b2LRxK2MgvgXJoACMiSZrZ5bnFPm3hfXCayUIHMKn2?=
 =?us-ascii?Q?wDt3te7aiJhg6ZFkaLsp1t4lE+tv2BiaU2n0bsNMagry3kx7BcF33vAjGnmH?=
 =?us-ascii?Q?zvvVj+lSIiFvCXwFGaU+eibSXfeTuw+oStT0y1fBKiT7Cl4B0Mi8u+QDMGY5?=
 =?us-ascii?Q?4HlWclYk+kDNn3p3CqhLSxsy7UYYgT/kelw8kvqiyWbt3S4z8H8/SxmJnG/O?=
 =?us-ascii?Q?e51GiwiOQQ3gRjFQQPqpOZIheODPRB+ZUkPWJ/444SBG5gyX7UO9xKe1bZQ2?=
 =?us-ascii?Q?ckwcqx+T//DwWNLqX7SsVmRauMKH8gBXj9oULzyW8fqLTwbMTVKvFinqYTN8?=
 =?us-ascii?Q?m6nHgS6obbnC0S5UolOLdegkVQpDblEwQFgaZRxQa6HIUCUAUjJ2A75cr6Me?=
 =?us-ascii?Q?rl4v+xJ/c0+h0dqTUJSceD1IuXQbW/Xx8PqnT6DWk95h3itq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d98c8ce-6b5b-4204-5c91-08de640b7ca8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 16:36:03.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8oYKwj4LvEQdTB/zh4Gn1M8ePvQVzLpbfzn/wLTFOHwwVdQy+gjEFml7PkRDGpBy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 502F78000B
X-Stat-Signature: h9c884af3nduo1fozy599kacc475egum
X-Rspam-User: 
X-HE-Tag: 1770222976-821519
X-HE-Meta: U2FsdGVkX19X9GPtlcliX1tLpDBC4g5GfhhWqVFrtJd56tflkKfxa+7H92sn1X6x7IB4hZrS4VvLB4U3wloVvJdhHw1MrLJjcdxY/jiRznl9zMtvWdImdkwsWc/XjCsjSm+p/qlGwHouJgybMNx17MhyFvX1DNMfHvddxvbjKRbyxGTHbjRDteUdQ0Gck0+OIj9lAQiEXypvqTi+7n7v4Idygy9kzQxyOLXzuDmHrKOdnuFfCpUgBfGnwpYCSZMIjYG+9X4yZpfRKbNviyIDgFGSmPrpCcdMum4mpx1Ta2EMUW+IUD60Z9XQNJ4N5ceEBLE+N/mwrWnKTf3C36O1XkrgoAWGpu4wRVDHPpb4HSOFUs7DPiCDvtbheejFlBy7O4QXyZZfiMh9lFK0ig446C/hJDVpZk49RtDTqw6fnZ22SDRf5OUdKQrWPesweVgNnKqU6pROW4A0yRwewgEp/CcZJhsE+q/C/CT8kQfA48Q039JBJXu5KB60ITlu198+J9IKmarCNIA91G7Crigj3dQCmmeMSh6+EBMLRdjGYVewpo9OXwzFHGA0+7GHYQRQleL5I3qZ7KgLJkNk0YLIVja89XNvt2Csl5izMgTenze1s3Fv0ax+wIf873zcRfmOLMewE3gF6trXA/ZOZP5sC2/WNcBwnYrNoomjdHuQo8z3f+DlgGICTGwLO5CjuoZX2NgF3so63AdLVbu9BrwrU2aqpgDmtA+fsOBYQzKE6EBa0ZD2RAAveabn2i5xUy1IUvu+f9ltXufHMSBTLVDGMAhhLT9ogAarlSCWtdemYOI8o4Bby8XYPLWSZ5ys5RiztMhkx6ny6X70IuwKaOdguJRGAPn0QjEGO8gk1MOjp8iX+iZ9BHaVPDO3Mm0M7hpHFqueHuK2vcF+sSkRX05eGWhuH2QreE05/XxewYqap1Wd+BQB3TJ/6qrMPG+5B5hPIhwH4b6TqlLyltGhTMh
 Ejnpuq2F
 j13Pk3JcHqxxnjg1FxYQt72x7A4jT0dQaovQ2dD5ydvTUXolbMaFWwRpLLmq+pdYpu2yY7iQwv6GSpCN1uJd4hLa+irgKb4GpDf69tpduR9PxPFih8wZRz1FbBEcxPuxLCMPXmUIf9GFavdd9hqKKQI3YIcqH2vrzJ0yDTD4kROLjmDOBg7Fr3BOhvnenpR+a6Ejffokw0iqh/EltCdt7/0h1bXVkOceCQJSD9V25DCtU34KwkbP1szrHOEaj4Wv6GgwZxjZjoRA8kYG3eAny41aOE7Msn+OWJQwaAiyoMV+SHYrg9vMSk5sMA8jqOxPBIiBM6J9uu7i5diprqrcD7hY40AovwMZCoR477y3Me3263I0RIVTBpUb/bW6Cgz7MtkJUeJNERUavHkT6Y5w1Lkt6n6j2zIrK+hFA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Feb 2026, at 23:30, Balbir Singh wrote:

> On 1/30/26 14:48, Zi Yan wrote:
>> Hi all,
>>
>> Based on my discussion with Jason about device private folio
>> reinitialization[1], I realize that the concepts of compound page and =
folio
>> are mixed together and confusing, as people think a compound page is e=
qual
>> to a folio. This is not true, since a compound page means a group of
>> pages is managed as a whole and it can be something other than a folio=
,
>> for example, a slab page. To avoid further confusing people, this
>> patchset separates compound page from folio by moving any folio relate=
d
>> code out of compound page functions.
>>
>> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
>> passed.
>>
>> The key change is that a compound page no longer sets:
>> 1. folio->_nr_pages,
>> 2. folio->_large_mapcount,
>> 3. folio->_nr_pages_mapped,
>> 4. folio->_mm_ids,
>> 5. folio->_mm_id_mapcount,
>> 6. folio->_pincount,
>> 7. folio->_entire_mapcount,
>> 8. folio->_deferred_list.
>>
>> Since these fields are only used by folios that are rmappable. The cod=
e
>> setting these fields is moved to page_rmappable_folio(). To make the
>> code move, this patchset also needs to changes several places, where
>> folio and compound page are used interchangably or unusual folio use:
>>
>> 1. in io_mem_alloc_compound(), a compound page is allocated, but later=

>>    it is mapped via vm_insert_pages() like a rmappable folio;
>> 2. __split_folio_to_order() sets large_rmappable flag directly instead=

>>    of using page_rmappable_folio() for after-split folios;
>> 3. hugetlb unsets large_rmappable to escape deferred_list unqueue
>>    operation.
>>
>> At last, the page freeing path is also changed to have different check=
s
>> for compound page and folio.
>>
>
> Thanks for doing this!
>
>
>> One thing to note is that for compound page, I do not store compound
>> order in folio->_nr_pages, which overlaps with page[1].memcg_data and
>> use 1 << compound_order() instead, since I do not want to add a new
>> union to struct page and compound_nr() is not as widely used as
>> folio_nr_pages(). But let me know if there is a performance concern fo=
r
>> this.
>>
>> Comments and suggestions are welcome.
>>
>
> What does this mean for treating compound pages as folios, does this br=
eak
> code that makes any assumptions about their interop?

Yes. All folio initialization code is moved from prep_compound_page() to
page_rmappable_folio(), so such users will see warnings on some folio fie=
lds
are not set properly. They should call page_rmappable_folio() on compound=

pages they are planning to use as folios. A common use case is to
vm_insert_page(s)() on subpages of a folio.

For in-tree users, I am converting them all in this series.

>
>>
>>
>> Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44D=
@nvidia.com/ [1]
>>
>> Zi Yan (5):
>>   io_uring: allocate folio in io_mem_alloc_compound() and function
>>     rename
>>   mm/huge_memory: use page_rmappable_folio() to convert after-split
>>     folios
>>   mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
>>     handling
>>   mm: only use struct page in compound_nr() and compound_order()
>>   mm: code separation for compound page and folio
>>
>>  include/linux/mm.h | 12 ++++--------
>>  io_uring/memmap.c  | 12 ++++++------
>>  mm/huge_memory.c   |  5 ++---
>>  mm/hugetlb.c       |  8 ++++----
>>  mm/hugetlb_cma.c   |  2 +-
>>  mm/internal.h      | 47 +++++++++++++++++++++++++++------------------=
-
>>  mm/mm_init.c       |  2 +-
>>  mm/page_alloc.c    | 23 ++++++++++++++++++-----
>>  8 files changed, 64 insertions(+), 47 deletions(-)
>>


Best Regards,
Yan, Zi


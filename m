Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6CDCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E978E0003; Mon, 17 Nov 2025 23:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70EB38E0002; Mon, 17 Nov 2025 23:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D70E8E0003; Mon, 17 Nov 2025 23:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 478868E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:10:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B6904D10E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:10:37 +0000 (UTC)
X-FDA: 84122401314.22.6234D78
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012039.outbound.protection.outlook.com [40.107.209.39])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2ED16180005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:10:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rCuXG1yJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763439034; a=rsa-sha256;
	cv=pass;
	b=HYMDY9HlOJXsA7DwdvjzopwsnaK3qi+hu6rz+YkYAYzUFB5Dv5XXuunPGabkgpI4cvSVm/
	al2zFdSEnU1Yi8ChwTXtAAKxOaYL9FMSwKZ6wifdnjUufPblM2U+gEp8Ym4k5t0SIhr0qB
	PgP4UiKh0te2+VfMXi1+QytDi1Ceh3M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rCuXG1yJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763439034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjiB6twKeXMm04bNg0sN0nBSDPbI/dHnD0fszU+4zjc=;
	b=XaDlNUDw1c6DutlMYSoP6+c+cwqBoFPtPQu+YeBHW+k+3+4SWUxUeCgu3vQGbFGxsrQNfg
	VfDha6rz6XRQvOduTLNiA5V1W8THtLTsyMTjchfTGMSl9wh36WKuB1MfOw2Ojg10Ek5Xv9
	3jpQuy4afnfEnsVzJRBHEa2B6nhzDh8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lu8K8Bf3GkGLyF0xFmMfXiUA0bDk65GyxKlcN20BPn7hysFUKim5oT2F81nPwGj0L8aQbRihk6riA987nRO8bicFmAHeJAA1M9uz0LMcPRQGftHQV+H0Y+K+bJf3FY3KUMwqigKIHI7CiEncIxI3XNmrjMlcnyieT4DgJY7THEEPyEVP3gYVeNNJdo2Rog3Kq9q+4uiHCe5vhIosPzNDKA06oD3BIi3+strVcpiUrVPZtg9nEzOg2jSPD1J/9PcPvFqS/Z8dmMz2oCIMaUPmAcXXnVSeZIDSzHgQuxXc9czMEImNaG11+EifhWrHg/5aMCMAtoRkrRPOu7eRwTtpng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjiB6twKeXMm04bNg0sN0nBSDPbI/dHnD0fszU+4zjc=;
 b=wZW+D9Q7VXIjVB1wx0859dHAvkDbfiZSlhjBPnlIETnS+0HhcWyqSXY2P9CUxK6cDgzq2jw/OCrtk1JCbBgv+aFIqqff6fDrRvq4xxJ/rsR7InP3ilBH0JfwrRRvRae2Cfxw9ugt+Li6KW9grfoeSdrCfSA2r5ZkTRfCCGUbl8uSFtj6pIn/Ax4WRCjOiCnGyyQ6o8KWuOY7D1fWCNUmELdfYUsNWOMgE7v77Nv7ksEeMF+AdDU6dIx+W6FRSUPwlYk/yhD4LbOfF86P33KnsvohxKD/uxh3bm3hgBymlT8ZodYbcn0g77h/vDlgbeWhoFnrINP9NSe8Vx+2EtLqqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjiB6twKeXMm04bNg0sN0nBSDPbI/dHnD0fszU+4zjc=;
 b=rCuXG1yJNC7LwA8JHiQuLIynspoGgAabL4fxjvqLCKzEs4w7K3Senlf3+ow4cWS8OL/UxacUAhYVFt2AJTKq98N/d19raL3DijyOdUNHBR51NP5+v5IWawnR+ewl+hynGPRj7IbnxFBMNPbMCX893MUG7+Gd7Yw4VJPu+uYYKtUyeBS43qD8KTjqp4pEw/f5tJhyEnVSCDhTI9BPtfOgfr+ny2hyq9HtB584ZjHyg3MC36I+T7F9BUtOeYHlH8DtNUoAhGJ4li90GDJYAmY5ug/ddVvTHprsn2AnzW3NPg++TOwqEnojEY41J7QokA1J2st3mnOnZLWLGJ0tgTByoA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6126.namprd12.prod.outlook.com (2603:10b6:208:3c6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.22; Tue, 18 Nov 2025 04:10:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 04:10:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Mon, 17 Nov 2025 23:10:26 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
In-Reply-To: <20251118033339.7rukw7vvjvlbj5jb@master>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
 <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
 <20251118033339.7rukw7vvjvlbj5jb@master>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:208:15e::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac0ee3a-8546-4b50-7031-08de265868ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iP7khTljwmNJZPmaRyRYYmXDti0uens/0S2pf3oCHgo1YjSS1v5bGOQGo+wm?=
 =?us-ascii?Q?5q4CMmkXP1kDGsTVhfOCYs6tWMnMxThJPef2WccMkmBdvRToQGR5EXMIaxD5?=
 =?us-ascii?Q?U7PIdxvHlOf6TxwEZ6Df0f19q0mdIfQXIXAAkCwPtWeOJUWaVt19e4Ep8cpu?=
 =?us-ascii?Q?Y6NCI2nSQ7xsQaVC5yNwXAF7dngC9SlyZksYYFWWaw6ht2VMcL9wcXniRygA?=
 =?us-ascii?Q?tJGKJQCiK/+OovRERpXfImtcTNTs3iYXI/F/DhxJs18dCerBe5SkwG16lLbR?=
 =?us-ascii?Q?K8d7ctUeNl/tgu5tK76ym1yqHRbhQgH2thmwrwvWLiSxlVlAyb8DcyWUU66i?=
 =?us-ascii?Q?Q5qeZH+f2c9rmzQZKfyOoDGHGY9ushrMvd6E2JN89zEhcJ60lliQTLTuH1JH?=
 =?us-ascii?Q?8S50q5U28OhWYPy/FCiq+7c6Gg4Mm033dPr0Z4ygfxvMRA8hnChyV/yhibiR?=
 =?us-ascii?Q?DNajPchoOKmbh+YdHFxqkpympWhI72emV/Vtj4SVWwtnjj1HoylENTXcKvRp?=
 =?us-ascii?Q?iqEp21IAN1geCDUTxVMWotBQEkUqGh5ifQokvRtgz/eRM5d89uROv4TagTge?=
 =?us-ascii?Q?EnKi9Min6g9mCEsbD6rGGh7gTe0Ek5d6priThLvlgfiwtZL3Rwu/vrBEBcC5?=
 =?us-ascii?Q?20LH1BHPtziNP9zJRGq7tdrcjo3+8CrdHZT0QqSFmk7FZsdjJPA0pIeh5rl+?=
 =?us-ascii?Q?4CIEs7TVKyzVlYkOrsbCCtc23OCsrH4LQVbS/EhF413pv2x35R4/OvhzD/sc?=
 =?us-ascii?Q?2D3gjAO91FRZTi/EeS1FiJBlZiKwCLasSv7S+WlDhql1e6/DzyWXXIO3eJ9y?=
 =?us-ascii?Q?KTRui/OYWSM2f41GsqftfhA14hcDdT9JagqKvAL8lUOn5ns8TLoHd8vUrIRw?=
 =?us-ascii?Q?BayrfiaiqaywhPjIX9O4nBZPAJmSAGzLgcznVdztio8dk/Wwg/nez3ZPl9kd?=
 =?us-ascii?Q?Eq2lhRJp60Y+fHTOfIEyR7j/FEk75g8su8E+VE3fPgGM/0tAySh9ZDLL8zvc?=
 =?us-ascii?Q?/8zTJnDkpoqDd207Vb+7wiiSAxjTfSWhb3qsk3t6SoFps4jl20NyQhx+4wjQ?=
 =?us-ascii?Q?aCoCmXpCStyVdui9fHH09WPIMu48vsuPuGGluANXjab7l6hA7BxjTn07Plqz?=
 =?us-ascii?Q?mBQPz5ZURvC7B8BquFNaqoWVCLwQsZBNUdL1NwiVZET7ZChBfrPUqki1xaRR?=
 =?us-ascii?Q?R9gZl0DC97BV3Ne0GQAcymsDOFBrXSYD41TSjj4ttMfg3HqXgaklaEzHOVvL?=
 =?us-ascii?Q?SC1Vie1geNuCDukRjdh3FWPiqdPnLlrmu6aXoi/fAptx1G068lOgWuIkpMpc?=
 =?us-ascii?Q?2VEXueM/W7HPXlfwMcNI6sdTrpt8Rb5DbSs9Fc8X+d5tVfZ3tOntTXKl6de4?=
 =?us-ascii?Q?vZ4FjTzuBhN8iT/ryunttIgwoQJCZGVv6UN6qq3WLDrc58GVNPgOSfLjhH1h?=
 =?us-ascii?Q?4DFMgoFWLRfIKtSUk/ISy/zMj2Ix/075?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ASIjegimGKZIX39kF/T+IbuLFs2SrGuorLDGsAKdlLrSdlRWL1qgUr1BJ7BC?=
 =?us-ascii?Q?TO2e1HI6EGPYWde251+dwAyKLwCqvdOgmFtjdOEGnzbIXMfoYlO/KyVLOEI6?=
 =?us-ascii?Q?+5TeGdNIGjWpbQr+3yU2SA/w4HOEOVTffJj6O98zKEi34Vt9mVTrcWXjm5RI?=
 =?us-ascii?Q?xhgQ64jwSXMfovFSfyY8wIenYXnJ19UZZ5S+h/tAOOptUmxl5E2d8CFGByTf?=
 =?us-ascii?Q?NB05sB1sZBvS6GG4r+6iJjnzBQPtbtgd05QaK3BHSi7ZN2W9W3iSggWqIHU0?=
 =?us-ascii?Q?NfFEJ05eSXxRy8kYEntT5PWT16dt+Dw+FwvdfnPvDTTtsJBnBu2MXyPcyUcb?=
 =?us-ascii?Q?eeBcJAw9f4GHD0GiyWxU8SPCiYZKZlvclu8m0ODiV9Vf46eEEU4nvYlh6fkR?=
 =?us-ascii?Q?6CWwwp8X7fF2qYvRjyQDeWiDogS5bGal394SORpRFO0DfPBfjLQUa1FNUw0Y?=
 =?us-ascii?Q?Wczx97Qq00/IjK0kchbMsd+EASwUQBK68b1YXkXojvsretb11Gnie6fVMyct?=
 =?us-ascii?Q?mb8yeedPG7qgPBAlvlZfa34m4M88PkXtWOFP4XIPlLql/k1AGIo/yQYxrqgw?=
 =?us-ascii?Q?WbSDA0LWE/0GjcEgbESvIGQTVgaAYC1tTRZor+DN5mP+ggwbSQtT+cGyAARV?=
 =?us-ascii?Q?YnAtEQiaF9mxuU7XOnejRWCLB5BAQ7HwPBL9nWcM878LcFQts1A8RnCW4N1B?=
 =?us-ascii?Q?KyeUtZZGTbYISSjkVmwp1OmiGqTIwNE82DOu1XKXLWtaA/edhx8wii2l8VkJ?=
 =?us-ascii?Q?F84ewkwA4bwpHOBcCwqwZdgnGoZqssTgPX+8GFDX5nSkYvCiOgJbHEKr7ZwV?=
 =?us-ascii?Q?iFshYf4zkFr3Wz6KWP5xbxF00mLVaOLWF2eMUU4F3Bc9NSOloAuImGXAfPe9?=
 =?us-ascii?Q?/QWwRpcgVSHckNOt33/+VTXHJIgu43JG3pf6mr6vDmd2OvMGVJbNZhWrZEzF?=
 =?us-ascii?Q?8eihbkq/gMcX94c1WWLYottuQArMknpo6X1EtAfcstQjEMNgXecB1+7o2Zy0?=
 =?us-ascii?Q?HRmuuR0xSeFrY/Dy9CA40pTaV5hbDZKiql/13E3dSs+CTjo5KYF0I5Dlagpe?=
 =?us-ascii?Q?ijswkGWqSMRVdT9EOkjqeYMq3IcqzPNKb86gPawm5LcI06w492hTZIIwVym4?=
 =?us-ascii?Q?x/ufLlwwr3ohYHmd/c1HVr350JaYU7IlDyAbj57i5wx0l21ZXAmxYOYd/uQf?=
 =?us-ascii?Q?g4XxjznigtnZS6HsenpQy6zockIcMelSZAl1/93dxSvtIljKUJBEfkFlS22I?=
 =?us-ascii?Q?7BcF7uRqGyRjYLdAeIxQVz3ZtG4mEao2Hci19Co+LwPnSHqSm3AoHXcFGt5O?=
 =?us-ascii?Q?lJ+XYphW0HrJpOZve8msxMeuK8R1ebh4DMGvAeBTSSxLZJvnx0kqH2mWM22v?=
 =?us-ascii?Q?/y+HYn08kQ4bvS6Tt6+Y1iaOQdkerZ2jJkTXcmDKlfnGNB1olqZmZi7hPjs5?=
 =?us-ascii?Q?noKl2y97a+ArzWAkiIvj0h28jNZtf87r1d2+goM3Kod9gIoOkP41Mfd7qDU0?=
 =?us-ascii?Q?FK8Tw/go4zUwn3/TiJbPhZEcM7/7Mk0QXsRTSSzY6raJL5k1h7jvMUczA25K?=
 =?us-ascii?Q?BWoDDu9AQGRkgfXeJt7YPQ8jhMPrqRxARgtTYnpR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac0ee3a-8546-4b50-7031-08de265868ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 04:10:29.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSc/H4i216TmiE6UzkFObpMJI9YLbKFxouZf6hrRP63/uEDTCrLmoTuxE9OxMGv5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6126
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2ED16180005
X-Stat-Signature: dxhj47m7mcny9ytfar7w4ntuekq6cnoz
X-Rspam-User: 
X-HE-Tag: 1763439033-935175
X-HE-Meta: U2FsdGVkX19c2UOCnKRG2eltWg9BSKlEn3aJkpPDq/JErhowbPpd1MoIhMkmn4PQA7UrVv8gjSGg9BjY56hMnyDYYh0wjtEPy2R4o9L0YdPTt2aAhLjKDMqNV4HhUH5qeJ5NX/A2uR0tCdmvJwT51xyH5V60gGbukzRtkDmEkDQL0jwYgdLdEj/FTnuuWssRbub9BcXKvpldu30BbisMN1hnUc5SQ0wtqr4p8CSnzRoN0DCsvzyFQuyfwScZW+e22jylkJVFHWy6t0QyYM8a169BgRNZRfTf1oBjhpi6nR3Ar/j6nl+Kg67JTJboX+tXwFsDCAqsoC8voDJsrtOrxm9YjLefqzu4FqIrqXTlr1q3K9ekl6G0NIecJYCnMDglHj1ScOgf/F8wqIMoEOvxT8K393hehUYJst6+B1siU4CCe8jtsP3dGrwW1kFxhnW2KH14k6tzjrYZE5aBbtH9iq6LtzR27Rjc/Ef6iL7x8OzUFePZBgEBRUXnItSLmJ4jDc7GZvKccDRILjbxzyCMXIgiaXW9CkiZk1uRTD/cJOQKaU+Tz9BuqEbWx0Rm1ACs56PP4nGzUN6a4jwq6KBqLLaGniubadVe6K/kRiKkL9TWALQkmuH7Hw1NylZT4ZMDcwi2e33t5WRHE0T/H/f826QJRNx0blW8OM87eOK4pmYQy8v0Uz31yCJVP4IyUIbPClL4EQuST3M6imGDYuLbsmytpiWCOcEQmvhIDNna/UOc9rfV4akxhJV3pKduQkdmfpiliasj0bSc0VFd+1nc9XT+l5lA9jQCRMYuxEo8TQ+yuNRL75zyK1G8WIQ6sBcH89gJWkIeGwVJp3OjJmNQl0zQ51DUng8vvKQ0TiYlemscBtI5leXei9ZeeNFlJT3+RTwUTjoblbGSXHapDF9j9kNk6UQ35FpehHa/pRQpfXLZE4cnyxWabAvjBKKeF9Y2gRCE0nUKdGOdP0iYDG+
 175ELXkc
 J+SGe4Y0oVEQYc0tKNgI6+q7mV//p0fTvfJ8RHQTEQRj5CRhyWEfUw7JTQRTo9d3qnpxxw/B1TeW6WiE+TEc8N4WpdNzuDNkm7xxOofeM1wSnmfv5x7We0MnXj/LZfaL6iB2nQwRErOnmjR3q4hnGtscnXBm6g7EEoE/+0pCqZP40vZBEn0gMN7XdnyezQAoOaFuRScyG2mLUN08vDsm6XGwHyOSmsmUKlgaXpOc1gEi+szl7hpVyB0linwPIBWmMbSt4OLFSXe4kib9g3xX48zLNDLDaCg1VUOBiyplsfVR8+C3O1fVVBMRVwEr5jhA1tclw3tl6nuk14ZpzVSxIHr+H4GTScLDO/wUypVt4LIIVkAzLBSkvWAmrpViXuiggUJu8v69l4YJ8vek9TvR5r3eY7Whb+zkQZrRUpm35+n0oANB5B1+fQT9F8QqXovPP/5Vgyj62QHZ9ymtA791XuFmQUqpAjEFrDdtZde5e1TRrUVYGR4KiX3RrFOb16g2MD9LiFicdFTWMHjGJufV8AHmRCx8JwDdM917d9gRKAIKPCPYF3PeRWVHxrp5zyEjSAE9M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Nov 2025, at 22:33, Wei Yang wrote:

> On Mon, Nov 17, 2025 at 10:56:39AM -0500, Zi Yan wrote:
>> On 16 Nov 2025, at 20:22, Wei Yang wrote:
>>
>>> On Thu, Nov 06, 2025 at 03:41:55AM +0000, Wei Yang wrote:
>>>> The functions uniform_split_supported() and
>>>> non_uniform_split_supported() share significantly similar logic.
>>>>
>>>> The only functional difference is that uniform_split_supported()
>>>> includes an additional check on the requested @new_order.
>>>>
>>>> The reason for this check comes from the following two aspects:
>>>>
>>>>  * some file system or swap cache just supports order-0 folio
>>>>  * the behavioral difference between uniform/non-uniform split
>>>>
>>>> The behavioral difference between uniform split and non-uniform:
>>>>
>>>>  * uniform split splits folio directly to @new_order
>>>>  * non-uniform split creates after-split folios with orders from
>>>>    folio_order(folio) - 1 to new_order.
>>>>
>>>> This means for non-uniform split or !new_order split we should check the
>>>> file system and swap cache respectively.
>>>>
>>>> This commit unifies the logic and merge the two functions into a single
>>>> combined helper, removing redundant code and simplifying the split
>>>> support checking mechanism.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>
>>> [...]
>>>> -/* See comments in non_uniform_split_supported() */
>>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> -		bool warns)
>>>> -{
>>>> -	if (folio_test_anon(folio)) {
>>>> -		VM_WARN_ONCE(warns && new_order == 1,
>>>> -				"Cannot split to order-1 folio");
>>>> -		if (new_order == 1)
>>>> -			return false;
>>>> -	} else  if (new_order) {
>>>> +	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>> 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>> 		    !mapping_large_folio_support(folio->mapping)) {
>>>
>>> After re-scan the code, I found we may have a NULL pointer dereference here.
>>>
>>> We bail out if folio->mapping == NULL in __folio_split(), which means it is
>>> possible to be NULL. But we access mapping->flags here.
>>>
>>> Looks there is no bug report yet, so I am not sure it worth a separate fix to
>>> original code.
>>
>> Probably because the race is small, but a fix is still needed.
>> Likely commit 6a50c9b512f7 ("mm: huge_memory: fix misused
>> mapping_large_folio_support() for anon folios") introduced it, but please
>> double check.
>>
>
> After searching the history, it has four related commits.
>
> I listed here in timeline.
>
> [1] commit c010d47f107f609b9f4d6a103b6dfc53889049e9
>     Author: Zi Yan <ziy@nvidia.com>
>     Date:   Mon Feb 26 15:55:33 2024 -0500
>
>         mm: thp: split huge page to any lower order pages
>
> [2] commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a (HEAD -> tmp)
>     Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>     Date:   Fri Jun 7 17:40:48 2024 +0800
>
>         mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
>
> [3] commit 9b2f764933eb5e3ac9ebba26e3341529219c4401 (refs/bisect/bad)
>     Author: Zi Yan <ziy@nvidia.com>
>     Date:   Wed Jan 22 11:19:27 2025 -0500
>
>         mm/huge_memory: allow split shmem large folio to any lower order
>
> [4] commit 58729c04cf1092b87aeef0bf0998c9e2e4771133 (HEAD -> tmp)
>     Author: Zi Yan <ziy@nvidia.com>
>     Date:   Fri Mar 7 12:39:57 2025 -0500
>
>         mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
>
> So I think the fix tag should be [1], right?

I think so.

>
> And do we need cc stable?

Yes, please.

Thanks.

Best Regards,
Yan, Zi


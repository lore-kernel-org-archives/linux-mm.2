Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B61F327A3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 05:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D386B0088; Tue, 21 Apr 2026 01:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE0C6B0089; Tue, 21 Apr 2026 01:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C68F6B0093; Tue, 21 Apr 2026 01:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDE26B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:57:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF5815C99D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:57:34 +0000 (UTC)
X-FDA: 84681506028.13.4799D2F
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 280521C0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:57:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kb28dF05;
	spf=pass (imf18.hostedemail.com: domain of apopple@nvidia.com designates 40.93.196.43 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776751052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrDnHwfIjI04ZjftgTLRQIzeTVE9MuhfGXqkkjUMJik=;
	b=et7lEKn8YB8Ry8X3V8H/OIPTlGukPKyWgcjBu4VR8xyKcoXUfgf6xc9U9GvNHca4OSDbfM
	UILdJ108cUHYO6/p4Ph49NLdA+HLtOqzu9Fz1I+8raXAe/LsrONoMH+PSwSp1pL+HQDAe0
	SzWlNL6sF01/Qvp1M+pqSKhQPPeuHPQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kb28dF05;
	spf=pass (imf18.hostedemail.com: domain of apopple@nvidia.com designates 40.93.196.43 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776751052; a=rsa-sha256;
	cv=pass;
	b=zQJW/F3vvKZBaxqOgwCIvoJNnCtDISrnK7a2iLwJi/7T7fGeA0EmP/jIznmPIhg5Df6pXg
	kyhoZFBvVXh1pMMxZ7o9zro5nfB2Fp4ZdcQukLNwLoR+pfo/mADGM/I2O1kspOpilNhabi
	d/TtnhqN1VhxSAFaZlBKrhjknIJigSI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+oXQ32bzo05utcA+YYwh94VxBn7mO/GNpRDCsPmBMCC2JCvWvbtZfZy97Qdx3fu9vRLhSVsL/OlG4m27MFX6rYoHtxY/f8Q5TDG5IQQVRWxegP7wigTmt5KXpZekzgoUOKu7LWWyb2Dv7kN4QW0tBU/6KNVK6wlAv6O3naOQmcYy8cVi6XswJh8cxPP1fPk3PKLuDdWfUpEEibGSpO0tOWPxf+GefNobQ5RJ2A1g4q1dS3vPkUd37js9B+NyAJXXXzJqIO2AXNh32kto0Cri1hjf98lU7fKTdm0+H3CYrQW7zesVFrXpsTmMhbWS6Ro6QkQ6S4+hVHk8dOTIuvyLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrDnHwfIjI04ZjftgTLRQIzeTVE9MuhfGXqkkjUMJik=;
 b=ytON228veybh97pnLtvck17GT9RcGHlhaKJuWOXTjtg0a0TU9Xc+0qM7/fxMX+7ufv5BI1KAOASH9HtBkv443xoe+7ofCRtiX2Ioc7+nt7AmCw6l5+Ko896bYtH0VGvH7Fe/yHPCE1QOhAvt5qvIKgEzpPuOc1UAP/XC2eesuGki4Ugu8ynA4z7vUU6QPoqphKIZQWcuSXSwJKGR6a6zQ68wuSF53zqadDSCQPe6uOox4+16CLt9WFq5VH1KsKTGdbhJL52k1/3qPC4Z9Dvf76drEW4jnGjE+N/RCZydMEfQiz7gIR6eCaz4BBbvNp4AqyJyaVQnWI1mAXkeTiNIvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrDnHwfIjI04ZjftgTLRQIzeTVE9MuhfGXqkkjUMJik=;
 b=kb28dF05bZMqFi01raM3T3Fqvev4SeZ78p7woEltXllWCDqXOTHu5sLP7JSNxSKt22es798rtN6BrVbmoY+lIEIvvjt8+1iArpehdWcDeYYe4VVFQQGgccE1Ix2gswVIqnPsH28WbuDzTFD3j0kkMgzBKkBk2C9CovW5jW0z51O0QKBDtlH4ZClTCmAlcFQP/PgV/IKt4MutOCCh+myf4D3QSSchVk8E8QJ4FtbxxUgRXxdZYHPCaI5ncCBf88AUmRryWU2Ty8OFBV2pxWzxpj4T+vjO/cBT8bUsuUNVyX/eiBN/jHnFzHRRQo7wKmEmc643+2mH3sXLeoOyME69Qw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Tue, 21 Apr 2026 05:57:22 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 05:57:22 +0000
Date: Tue, 21 Apr 2026 15:57:17 +1000
From: Alistair Popple <apopple@nvidia.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm/migrate: wait for folio refcount during
 longterm pin migration
Message-ID: <aecQkNxjoMReR6Ss@nvdebian.thelocal>
References: <20260410032333.400406-1-jhubbard@nvidia.com>
 <20260410032333.400406-3-jhubbard@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410032333.400406-3-jhubbard@nvidia.com>
X-ClientProxiedBy: SY5P300CA0093.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::25) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH2PR12MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd86fa7-0032-44f8-b66b-08de9f6adadd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fS4DdwM7I/j0mIsCVTB1FsVUlTbPCI0xx1OSLyLVfZCRh0iGRvJESzfN+U1wDnFQXSbimbE5ijNZechwZ8LJHvJ0z21MZ3arqJ/NbZUmXPzuo88Vlv86oyXOrCFxHL7bqOEiJyIYsZCraaOyhtt1xMKgN/wcEwKDfdPx/TU5b2xskB0YZPL+t3rNHMLV35VwCZ0zEbqBmtIBmCmNcsdkWaRyok4VtQO05ScqsYFOyhfJqngQy3l3U7xTQhEZIPF7ytdjf3cSiw0ZNuHharAST5YhGf4y5tkz7UDRJLcb1i66XJPsYCbzPDoEZWuabLPU5dFSqPVWFP1DC8pse8GZKCYwvU8t/++dK5Zr58zifwxZMdOf8Zi+SsFDELgtFpKP1Qvd0Rj5uPStZEFIUgEj77tS9UzoFsXCuJ9jUBo5vEOUL0Kbst7tpQrX8xQEPBK9ANW8JuZ5XYcDHzgpZHuwV+lABSDEhMrmKDRsEVqfKC+KpNGOC+uEcG/VzHWvas0GeBn3r+Oj4qzpzGOvduD3KhUrgnEwnQGQZLDYqbOm+/4f2XIFBjM+zuP8fcdRPIXvxTlRut4XWiHQfNBGj50dccf26kf2poDHh+dAqJdjUF0jmSE2EjnkW1fDVLsquEWAgzxEZ/xxoeP5hduhe4Pzam/PcvYJAQOPqXBIPca6PgVKVrb68Jn29BEGPE9hGnE1q6c7SgPDX27DFdLnSSJ0oIpgbqk6+KH073eL/lKZoG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1xr4KbioQkURTvnW3rs0CejxIgok2NrtBmpRhrYMvFXFBnMsO05JH4rJOd1O?=
 =?us-ascii?Q?qITWEMtzI+yNYMi7nGd6vPkJ6KRG1qQQWKeHalsDkZgqijIUdUpAqGGdDNv7?=
 =?us-ascii?Q?XhnGROwK3t2joS8c4RzSSjQ/x66PhHSaAzye9BQIxJoNIffaAEGp8c29NP8k?=
 =?us-ascii?Q?VAydJZS+uWl8Ohfz92viYql9A1Rm61RiMaJjAApz3B7D6k1eaDLRUc+jCz2O?=
 =?us-ascii?Q?a79/L0DHe8svkRBzB5eCk4IuT5NjZu5rTKVQl2q4y7wdqVIuNrEflVYvIYRm?=
 =?us-ascii?Q?+dUbaU9VNVRhHMIAAI+dt5qBxR3ksY2ViANv1EM2HmTS0HdMadBLqEOOYTIm?=
 =?us-ascii?Q?U5HEaZLSoiWrla7bR73Cjbp8oQ0idk79LhRNAtW4M6tRZTp+p8ATDQJaWixk?=
 =?us-ascii?Q?xbiGuE0QX+XBkw8JrnabfVsQyAP6jzydqwA5teK0NGhrPKZNoimwvM4FOvRy?=
 =?us-ascii?Q?8AvCxEOM4ZZla9/wda47XdGb6Z8rR/GV3K8dGGNLSpIN2gt/XE/ptLKDqmFx?=
 =?us-ascii?Q?R2lWkIb919VdPBNn3OTzwnDzEh9HaYsEDvkcBwRc6Ni0Yt2s3xkCP8kXnApY?=
 =?us-ascii?Q?uedxr0KCZjdy5bnRcDjj26B751G1shd1T0KshpxDzD+F+4RBkHbBLHu0fy7x?=
 =?us-ascii?Q?/9KLoEkUxvHqWpYiqogRE3AwMWY+L7FLVFb0HJn0tJO3lUjk6xxlnvk96TSg?=
 =?us-ascii?Q?4+rRLuOZXwyiac6sHY1F9mfUJwXeDL1epCgwKfJWXO65oCi2E3BVplYygsTx?=
 =?us-ascii?Q?TurQCMHYLlBp+GLH86FacDdsfaLcOpSVQmCuiiky+fDovYQbmKUFqwzk0gG/?=
 =?us-ascii?Q?jnmconO8ld1THkPLu0+ewj+a2wShz5o5FXxF4Vpmw0FO0aj7amU/QBEe6ZXp?=
 =?us-ascii?Q?drxVLh4eyn1+CFMzC2uvBmkSyMljH0Yzg9qU2XVB71bkrjqAEfvR8QAZjgJw?=
 =?us-ascii?Q?FlGqTaLzp8x/4WdiZDFcCHcSvG95p2E4ZF/DiWKx2nSbznvVPXC3ZIn1q5e0?=
 =?us-ascii?Q?6KGdmQbcrU6xmPrpBHfbF2FSIEx0ZAR6Tdx2EPZ3ERb4O5cvGOI0O89e5z7S?=
 =?us-ascii?Q?kLYzZLAQRDt1iHNH223/2eKbg12dnijiDyaoHbQmonLji2+l1E7tr+dkkSd0?=
 =?us-ascii?Q?liYjTwtGd1/gfVJUs2oCmRzh2+LmDM5Pm8JLEPCxSlti76meKfzNsqHP5oAo?=
 =?us-ascii?Q?5GPQ5sJgBfglBJUQDZbvTHcCgG4PR1foEtsk9Fy1ClGAyptF3sA9hNvhjvNO?=
 =?us-ascii?Q?U9rCknlus5pf8rQbrRLm1u5WP5q3u+LM5x2PpxIOqBB+mPsWywgTgbXNfFs8?=
 =?us-ascii?Q?WyqwTqw6bxh1EVwyiJ2XLuxWwLG2Rfu1zslt7176hQqlHkKP2/WpQhszgWMn?=
 =?us-ascii?Q?UvQ8JZGQO8rungUXJj9k9NszmwQuAiDOrAtPF+cqTeV/h+qdsr6jpf+O3RsR?=
 =?us-ascii?Q?XEePj/hzyz1+vOA54IQvJNgm67fWBl7YUnoN/MlRIwZ2rjJx0NeQvwwqJ+Ew?=
 =?us-ascii?Q?XAkwYlYVc1lsT39x5hXVPoP+rLXwWRUT/2L56T+iiaCDzCKpIu2LcOc3t2n0?=
 =?us-ascii?Q?3oMkKntV2Yaj3J2cSJj1p8VF1k8TSCj17lIQELZf/+d3+nlYkfwP1LaSMgNL?=
 =?us-ascii?Q?nt7l+jdw+YhzgI8ldX+92aZhmCj7WOWNg8kz4JQ5UWxulynzsApxw5oTKa40?=
 =?us-ascii?Q?S05s4ZMJYSjSPAeg6NK6L2U7tX/xPM2vp7iBIA412T8S8Ae8YxU8xpxtZ3t5?=
 =?us-ascii?Q?5MHkPFBTgg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd86fa7-0032-44f8-b66b-08de9f6adadd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 05:57:22.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLxfFa2yYftvPE84zuDYmHUDx+GS+WJ9XZhBl1PyD0y5n8eylVaMt5khzXAkqbDWA+dUJlqlAlP9TCcbSSdZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213
X-Stat-Signature: 6n8j9pzyn88pskakhs94o1z3r4rsxuje
X-Rspamd-Queue-Id: 280521C0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776751051-381664
X-HE-Meta: U2FsdGVkX1+hzJKo33BPy6JWkBh4rdGE6Im2A8ifukaKZCXGMoFiwwUhVWhTasR3s0W3nvfLwfCvulqKetJptnHyAT4u3/yxKVxQheyf6gtDlf6c/4yYQhjx7N4oIYx5IIxODifdO00OaLNrPwDSrGBUvZGwwiy7KYCtk3hhhhb6CQbgX5CFeRJI6dSWhPQzzfeMRomFaej5/9I9fDVmNIojFvW62/vpfzTNxTp/YNfhLmOOoGoP4fcaWt2O7wwndUAVF4Obv8aawd3Ba4OUGLMlq2Y4ClokVb1z/bmkBg0lsXR5++hG+r15jUoaXxC62xTB1U5FjhVWsQGhF9So/wWqDKtkVGsF3MST5jph2kCFEOb31+OPLFH/rexNUbQ4NzIapW2i4j3eDdtUQaanKQ/9RkAn87y8VdarMbsyX9WU6Nxije/nXh974WiS4Iv3ksimsaJvZQJA9FxN98cpjeb6VjnwG5QHywcyuumsFj8efOLwZYG4koliqJYUBqGeh+eFP97D6aX0Z1WbXWnLOWlhAwHdSvN3UaVd/aYxrwgUwCfsebmrTRyvQxnychUurwqxsu6tbMs/LGhWWOGI8rkkGrxOeaiI30ejYp/gNcIH2kgHtvuervYLtutL5aIGK/oT7zEdWBNV4W2xVv1SccMe5J7xuCurGIBS+IZwIMdnOeH/jWfmTUuA2ymiptXTtVqp3mpMKf725TXCVPfVmRZiJsrS7TXhN8I6sQrkvUwUypfor1Q7/F4qdncuCoQMXeswbJ0+kLWwk668x9ZbrshXP/LmP7kwZ2CJGeZqflfbgyDZo7+2FaI9TmTxU2s2/3g693+SWljY1m8j0oifIBqtlWxsBH6Q5wT88l8ItehqEWEHvibosBThr566KjIXWp8M6yg076HhEqUle4fK0A2kv3M/qF/sWoZh5Od4y2OHUylFx7ohbE/hGqe7LgjZZ6FT6F6xBZ1zpFZ6+hF
 eREHF4wW
 RTIdUAdLS3PJgTmhwaUlkHpChoOlJ1tN8iRoI52wnD0dp8C4Gsmjq3/Fd0jAwzZY9IBrirlBA8Wwr05qVRZN2lOs7uuPe9YEssMTHXd6yhAGG03MQPiVLYFveYyAWDbahEf98T0ovY6Klhz+m8suTVLlMSPplKE6I1ERiTnVLV+MCXhPxRJ7gTpPuLlCZJv4VhWMEbcX0NQXa/n40ryl9xBlasKbXOHFKWtPNTFtYUBNI6/evTgAGbpLgVYpdhNabjR9TyyEeTxSy+0E8QSGxqm4lqBU+PcoSBWmg2Toagz72nfjgjcgeNK5eZqp3gXwzUuSkuV/vxgbeldznXTi7BUODwzCjwge0Kb/HaJCRCZnPWGP9qz3CPD0Yr3ImMQJ2KADsPiFytRo1Vhxmj2gsvIj5BguyZTEZpjUKP1VSLFDTZOA/3CM/aVAq1wcGOc2EGS3Lncn8/Nq/HhryTIxdsWjrdXM7Xjf1PtDwIghIV3upoUybpYkOMiB97w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-10 at 13:23 +1000, John Hubbard <jhubbard@nvidia.com> wrote...
> When migrating pages for FOLL_LONGTERM pinning (MR_LONGTERM_PIN), the
> migration can fail with -EAGAIN if the folio has unexpected references.
> These references are often transient (e.g., from GPU operations like
> cuMemset that will complete shortly).

Is there a reason this logic should only apply to FOLL_LONGTERM pinning?
Or could it also apply more generally to any ZONE_MOVABLE page, for which
migration should eventually succeed? Currently that has similar retry logic of
NR_MAX_MIGRATE_PAGES_RETRY times and give up.

We have a similar retry problems in mm/migrate_device.c:migrate_vma_*() so I
could see something similar being potentially useful there.

 - Alistair

> Previously, the migration code would retry up to 10 times
> (NR_MAX_MIGRATE_PAGES_RETRY), but this busy-retry approach failed when
> the transient reference holder needed more time than the retry loop
> provides.
> 
> Fix this by waiting up to one second for the folio's refcount to drop
> to the expected value before retrying migration. The wait uses
> wait_var_event_timeout() paired with the wake_up_var() calls added to
> folio_put() in the previous commit. If the timeout expires, the
> existing retry loop continues as before. The folio_put_wakeup_key
> static key is enabled for the duration of migrate_pages() so that
> folio_put() only wakes waiters when migration is active.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/migrate.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 2c3d489ecf51..a5d9f85aa376 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -47,6 +47,8 @@
>  #include <asm/tlbflush.h>
>  
>  #include <trace/events/migrate.h>
> +#include <linux/jump_label.h>
> +#include <linux/wait_bit.h>
>  
>  #include "internal.h"
>  #include "swap.h"
> @@ -1732,6 +1734,17 @@ static void migrate_folios_move(struct list_head *src_folios,
>  			*retry += 1;
>  			*thp_retry += is_thp;
>  			*nr_retry_pages += nr_pages;
> +			/*
> +			 * For longterm pinning, wait for references
> +			 * to be released before retrying.
> +			 */
> +			if (reason == MR_LONGTERM_PIN) {
> +				int expected = folio_expected_ref_count(folio) + 1;
> +
> +				wait_var_event_timeout(&folio->_refcount,
> +					folio_ref_count(folio) <= expected,
> +					HZ);
> +			}
>  			break;
>  		case 0:
>  			stats->nr_succeeded += nr_pages;
> @@ -1941,6 +1954,17 @@ static int migrate_pages_batch(struct list_head *from,
>  				retry++;
>  				thp_retry += is_thp;
>  				nr_retry_pages += nr_pages;
> +				/*
> +				 * For longterm pinning, wait for references
> +				 * to be released.
> +				 */
> +				if (reason == MR_LONGTERM_PIN) {
> +					int expected = folio_expected_ref_count(folio) + 1;
> +
> +					wait_var_event_timeout(&folio->_refcount,
> +							folio_ref_count(folio) <= expected,
> +							HZ);
> +				}
>  				break;
>  			case 0:
>  				list_move_tail(&folio->lru, &unmap_folios);
> @@ -2085,6 +2109,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  
>  	memset(&stats, 0, sizeof(stats));
>  
> +	if (reason == MR_LONGTERM_PIN)
> +		static_branch_inc(&folio_put_wakeup_key);
> +
>  	rc_gather = migrate_hugetlbs(from, get_new_folio, put_new_folio, private,
>  				     mode, reason, &stats, &ret_folios);
>  	if (rc_gather < 0)
> @@ -2137,6 +2164,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  	if (!list_empty(from))
>  		goto again;
>  out:
> +	if (reason == MR_LONGTERM_PIN)
> +		static_branch_dec(&folio_put_wakeup_key);
> +
>  	/*
>  	 * Put the permanent failure folio back to migration list, they
>  	 * will be put back to the right list by the caller.
> -- 
> 2.53.0
> 


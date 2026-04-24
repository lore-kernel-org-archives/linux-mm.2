Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962DEF34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCB06B0096; Thu, 23 Apr 2026 22:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DF16B0098; Thu, 23 Apr 2026 22:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6946B0099; Thu, 23 Apr 2026 22:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DACB66B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:52:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B55C1B92FD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:45 +0000 (UTC)
X-FDA: 84691926690.25.A064DDC
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC9D5100002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kODBmqoW;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIEPCNKonCOG8nUNo9yAkwGSFW+QQq43rlPc/tgzw8c=;
	b=16I+xspyCKgHX+f6Z6Qk2lMn0FhV9PW4AR5pwc/nOPePBSGTyeCOye/Qs3i2QVY091CGDc
	6oAVgVggIhLQpPfsM8jniEYGlf1D51yzBnkZd4v3aRaNIvyDEfK3kxZQF527Cho+b4V4fr
	pUQExqcnbgErFEhRl9EbihDzk0JBEW8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kODBmqoW;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999162; a=rsa-sha256;
	cv=pass;
	b=puFhppgNe3faMG0cndxvtLBdEA0BMBa/uIclntN3yqaE5VsYzVagOi75SbXaO342K2Bcfz
	RnInN/oFEqQnjRhWHo4zpgaZqufoF2H7SdNVQCDJp6UpcTVxkNveS3c8VCoFwyT/ghT5RE
	DC3x2sA9ptZ0TXbiD8YsI2qOqQWXZik=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gCh04s86dV+X29Ya2zR7zL99O9sy7pbPnSHFILhlU5gLN7ifigXS79oEEUuiXKgSaPCn0QiEc4jI3v0+e855sQeoVz0cddmWyCifv4dybHKnzPQbdQitqb2Mjf3Fzp062TdNRyqegaUQKsIV+47cSIPCxLrezSA6ogYNN9VrolU4JnpQKa6+yIjCmPTmbi3idpaORvUyeynGSv9x6AAYXE+dm+VmFBOTnOOWy6a8MI0h9t4qsXo+/MEC2dLdlm478c5IuaOQagq3IMuEPq8pDZXUvo8Kcm/wPXoxCyK4VC8aP6fE9C+hK9tFGTyqxjmjZlTfA5v6PK4lGULM3CzLZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIEPCNKonCOG8nUNo9yAkwGSFW+QQq43rlPc/tgzw8c=;
 b=p6mt/ekGCXt32LY0O34Vf7DWrkytPpny8L2+48QCI+ZM1zW01Rxq17jbyKpRd0kVwtqDQdqJNTtuYgju7Xa1jhzI2d5BD3aagayC8n+gY7FyddzZSD9ja4nTtyi3A7LXvU0POTb6UKVESc/MWoWxB3Ue6bVkHe6JhX3xPacQrpPKIiG932IIhMbSxeBmXjGCBhH6XNrFfVrJcyHvThi36jBm+IEf6074KJRBjZ9+UVoXzi+BpelL7aak+c2OC/LVjNU1hmsjwJQ0dSWOJahT1rnex0RO84p6/Y5sv9bh8hfO0JSVyrxlBED27gbzlPThrwGUVb5f7P7Y8UKZChuUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIEPCNKonCOG8nUNo9yAkwGSFW+QQq43rlPc/tgzw8c=;
 b=kODBmqoWJQZ61c9Rv19Zx2ZDRJXlNL+ZGOoG3cDGgH5PsLjGZIxF07PyUtSdnfscLEGf8URTEXCUftS08qxymi+pPM1ls18x/xjWc0OEde6rYgm2vLY/JEp39TB2xytP7BJHzGZpUaFbfWa0yxTJorQpEY8z/ssnMXsYuvbp93k2m0SpNhZui9JTopPkDRVOeTCHGk3V/ylzAx27NyBEtvMRmg+iV7DiXFvoybM77fJR054h5B1MY3HXWMfJIwMrLyfgNM2NN+jpKbCOXordZi12lnpe0wjUvFIhBBE+jIaK6LjsdGZt7oCRZAgLPzlsS+cSmFimv9pAFVfDwJJcoQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 02/12] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Thu, 23 Apr 2026 22:49:05 -0400
Message-ID: <20260424024915.28758-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0150.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: c196b559-551d-4bb7-ee2a-08dea1ac7c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rb+C4ZhXo9BCc6wbBD9jJk4zBd5mHr/JAkXhfyyaESgAI/7X1ybGadOgoqAI5SBMjxCiU1xzGnW0ZKTnljPxzEvMWaohFWEiEoEi9Cqerm5wFwrg01SnoZp8Pj1/tZ6GMF++OdiBv/lzQZklFr6icyTyM347u8hCOCvBXJIWWgqfiYmNDUYHOTBElFgQa3Wbym8Tsf7rMWDD7m/X7BNcK0ZP7HfZU6/qXe+cofgV5vgSDv6g/5mBgCIPRSVBraC8333zoOGyXY/AQ9UxXInrj6OvLpMdP5dCHDJz8bc8asrBkOF4em9/B83QGVizgYtdEm5W/l72o1WiWMTDuxlcm1exQGkQ41SbmDe9Uhyscj3RyZ13bCtTVm4zTPegrcaauNnsO6YbOoyBr4UfphCEsNaLy1ujKC/I7OZFrS+g+1Sn/LtglzeGzP3p2DiBRL8XJHUvqDMsxboY1z1hcWExOQiE8qAqvUKQez5492Kg6UU6bPrp8/TYfn2ivzovq9Iw7hslczy4qlwj+i0HsK1XR6OZlJz07+zd7hVwN/dK4xzrEau1k5vgq2lN9hvGMSgrsuRmOY1zIhIoTiejvVVAohFICFXsXX4HgidthKWZpXHKo5jruEKIWKdve2F6/A3LMf+/oEzeBpC1cxqeszyDlmpdBNZmhd1/Q81RAIA/tLNCB3SsBrFVxHbmdSFEU+gY/dcu3xc5ZVR1ETVCkB+h05uuIUtgkMSivdnJCIr3Wig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OA3x0tp/I1jRd4zkdxERGqf+g32ASzwi1IqUpiNevMD6gJbBiAe+KwfgSzbz?=
 =?us-ascii?Q?o21lBXIlxvSO1BZtdbL0XQPfcstp6ubvFAPS9iKk+eTUIM7S61KWC8wmBt8n?=
 =?us-ascii?Q?KVAZ6znQJ1q/shgCkhPogwFyi33B8MdtXV4FHUv8YAnvDcj4LAh2AindUZwC?=
 =?us-ascii?Q?fh9VCIIoZb/9WUpOhdoDooZzxlBD/Ml3ifGIfwStuqIvmt83dpEoJVRn6hcm?=
 =?us-ascii?Q?3DkfId8MvmgWMKqDyfi3VRsTkdPdYQrFq0zfsa1vd+BpWsfzuGyrg7d8sDme?=
 =?us-ascii?Q?cRSr0iMf+Kog1JJJ1Qp2Ft1y4uRJupUjaH40BbNiPAXmJWuo+gt7NZ0P4QVz?=
 =?us-ascii?Q?Cg9E7Jw3jpC0B+AJJBoUs15YDAzvZqyPl/taWE3hJJv7yxuHZbHETIuRy9RX?=
 =?us-ascii?Q?9/SIo0he//+GENqDLnzv0FWIHGGrpvQXJqDoYDQo/m/PWx9Tc9slT4j1uJzw?=
 =?us-ascii?Q?LgxJaTo/eRDMh4l+HMnvra1yah2OX+bHd1KzcXkeCbO1oDtw3RpSWX9tWqPy?=
 =?us-ascii?Q?78K1FkHqj8KdT3/3I3AN9cUPmxSuFM2od3MO9saXu9NLQK75jpt1yrKXqIa7?=
 =?us-ascii?Q?1KhZqdv2q+3MPxOLWs8G7vHvmKDIMBZ9YoCR8ZbMig8pIXQuTXmPmq2Q589J?=
 =?us-ascii?Q?NiE7V9EgTgpvLrdExtOxDpLNFRKhMzQ5XmvHK+OQ7dDa7RU895xeG0q4fquv?=
 =?us-ascii?Q?S3s58wH8AQ9sOtBiaVZlBY6sF7LmPrZOUbqzazBGgqnSZXCLocGe62SqGxKk?=
 =?us-ascii?Q?JmmlwQRhI0OyazIH9hZ2wZO8kAe1/5+tOUpiFN4s6j342ouR9KVZTHmEKcRy?=
 =?us-ascii?Q?LSuCxQNbGcGPGI7c8zQx1pS8Yhp+ulAkYgXhKAyqtJ3AeVNSfWunbKRhJ1fQ?=
 =?us-ascii?Q?R60sgpMnTfrS1FTGxjbYzcBLWqxDIe0ZNxQXnWZgMMWhNNbOm4z3GwjN4rIm?=
 =?us-ascii?Q?g/L1NtLt99HcJfQMOoBrcuOOQ4jJPdK7n5z0zxQnfBgj8GrBc9FfyOSM3+29?=
 =?us-ascii?Q?nMFQsR4l5hPCc/lFT/PvgLZqvDQQKIkqsLk7nutOcE1to+tc0GtnK2BriP7Q?=
 =?us-ascii?Q?N3juspfR46LH65gQ/etlGa03ZcvcvFl/hx08O5Q17iU6t/1ClsE+8FbVQNks?=
 =?us-ascii?Q?GYrpH9SD5BdAgeG6sMOxLXYy9BxylBUZifXdLmllUTqCI2YA8E3qhgxY6C+o?=
 =?us-ascii?Q?SXv4vxVlAV2Ic4fmfGdy1K7srl/WhRTRM25DYRt+3FKRZTSgmeqybVZR8dv1?=
 =?us-ascii?Q?4zAcOcMptUoXSsZV37XrqTgRu7I132E9mAbsQEVTgS45iMToQ4CP65oNddEA?=
 =?us-ascii?Q?h+dAjLXrjB+wgCiNz9c51ePSeLl9bpIcxRI7UNAaSt0A4u7ZC8JOiv/268Ro?=
 =?us-ascii?Q?FgmAZotUCyPkAqmR1yjqhs6FIkLSVyZdoj0Kcowj4JcosDi8P2TOSgafSPsx?=
 =?us-ascii?Q?0M+Tpyk6v+1oWJ0UUEEVvFRpD8bEhfd1Id3Al4TPLYxLL1lfg5fvCAZDOXKG?=
 =?us-ascii?Q?FahpkBOGPqKusNZkXYaUBmh4+urI9lVlH0lpQQfh1LRMTe5eSz36a8glz9ub?=
 =?us-ascii?Q?TvzPt+lB5j2Q28L+Cs4FKZKYIIByVzFlG+RXWQF9V/wjWIKoKmXjMf+jxMn0?=
 =?us-ascii?Q?+mRf3bwMt0ku571tu5Wk81uu0yqWGgJajhdZz9E9udx5awhrBCuu4tK6YOfJ?=
 =?us-ascii?Q?nHniOKqQT+A85zpRS5v/4dZHHs0SCApDRxOxYyG2GcKiyzlX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c196b559-551d-4bb7-ee2a-08dea1ac7c09
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:12.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MFycldFOVGDprKWro80qKA5q0MKVdIrexSjyXZ2jvxI3HtKhTR7iyGGAzHhxDDC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC9D5100002
X-Stat-Signature: jcados3d9p1yuy8r7kcjto6c3dxfbd9q
X-Rspam-User: 
X-HE-Tag: 1776999162-293366
X-HE-Meta: U2FsdGVkX19G6c2M4f0hrtWBGshQAKw3oZIadc6BMZ1F1+UErnBnXTpOi7J4HzfelLaj9skSKLQZAC+SFB/LEUMMmAlRaffCBhlUZYrczLgYW9CUz7jYvXkx/QDQF6YZfH5oEH5CoZJwwQ98ABEZvNpkAk/kf0ved2aSLcGstiI78mNEiLcdswpHd1tKba+c5G2wBHUaNaJqC1HlIRW0qYBBTlDZ5mH37vVrdisezyG6RszshZ4/9eplx+Be1ilTycMZAmU+K3fk+xdO7otzGpawUT6z4IxkTZNKT43u20dQLnXiJHxJZ+ep0ZDYZd4rodq7RHvr5EDAY19NsJ9jaozgkYKseuKy+c4Mdz7iWWmOrtmhxJAd4aEt2AWKxHA4UdyZdcQjBHKBpquLild3IvZ9+iG0aI9mzeVtRXNrHgmPUPdoGTtuNLvZP6XAqLnGRrM1FEaoBBWZ0dSZaXuowjnp3soRAh+FBRBCbg3EEbn8iQihat6wefibsIK61M5Za/nCQpEoL73CSmOQoFxZYBSpVFi4GL/IUwLTaPjGg/cl4R6y81600Y2hbTxJiAnpuNVBAxzQhT0jlHQsnCyj9pcfke3dbyDlmddoD9CF0AEr1Kol4JqIso0dMELpYAITzyMWJYz9QKS059F+yvn5NYB/vbaLp4hUbHVhRwQlBhiIq1l71KfjfaePo3+Ysdl+eHNpmMsx6cZq/IBKlOTccrGqyLPrbfjjiH3i/8Wi266pcOjGHLMsU2KtDwvqqh1BMLHIeRCg5YPk/vwJ6yBlp/ZWdp7GMmZBwyY6Gskvpvo4c89aqbw1mQcm554mzFuhQn55vb5PCwA+L1gqV8b6mfMBdL1CJ0QJiuHNSoRjLJCsuLzkpiQsGhBVJPuT3k+lCNvOvYVdv2r7qiG1SlYjw4Z+GlQfasf+k+fnbiK6xvH72MVKGzwu20ZA2GKegfyLHuC72ouS/bBWCY8+G1M
 wqCt2y30
 PhKUIJ0OKJ6AZouPgrLToO7d27pdqFMCdoQELTWYZDSKgvaB9IlOEy9/rDxvLGAtJkdNO3Wll5laUfxR/bQAMadwfemFRGeibJ5wSC5HD/98rv7eArAm+D0eh261H4417TXklfAn+DV9bAHFaJpfw34Q+dh+AddRzXZu5And9IxAq4LHYqpOQsCGkPlOu1eXHS7PClWRIMSykYfOauIjM/JCcjen/Y4HfpFWh1IwePEsAtF4OQWB+lgjXICzWd9FcTrOEMvn4bG8vA9GBxlKkDaYKpOs7v49k6K/UR2IEA9WuzgPG//l7tpXyUsyynlob+jShVpo8pV2ISuAIJZOuMAEGL0A1dA97oTWS4FAka9Kj6U478diEMvdZDHAAZC6vbUSZlv/I7QMXcCjq2DWucq67LkWCbOsfbfpYVNx5Q4mKXLpQ8jwROc51sRxsXBM/fFCIIAzxuUJd91/EmbLewYFOAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This check ensures the correctness of collapse read-only THPs for FSes
after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
PMD THP pagecache.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too. To ensure khugepaged functions
as expected after the changes, skip if any folio is dirty after
try_to_unmap(), since a dirty folio means this read-only folio
got some writes via mmap can happen between try_to_unmap() and
try_to_unmap_flush() via cached TLB entries and khugepaged does not support
writable pagecache folio collapse yet.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 79f051eb6195..726f8ace01af 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
@@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * At this point, the folio is locked and unmapped. If the PTE
+		 * was dirty, try_to_unmap() has transferred the dirty bit to
+		 * the folio and we must not collapse it into a clean
+		 * file-backed folio.
+		 *
+		 * If the folio is clean here, no one can write it until we
+		 * drop the folio lock. A write through a stale TLB entry came
+		 * from a clean PTE and must fault because the PTE has been
+		 * cleared; the fault path has to take the folio lock before
+		 * installing a writable mapping. Buffered write paths also
+		 * have to take the folio lock before modifying file contents
+		 * without a mapping, typically via write_begin_get_folio().
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
-- 
2.43.0



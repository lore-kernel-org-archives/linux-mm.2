Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5316F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155BF6B0005; Thu, 23 Apr 2026 22:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107556B008A; Thu, 23 Apr 2026 22:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11606B008C; Thu, 23 Apr 2026 22:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D86BB6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:55:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98DDA40AA9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:55:42 +0000 (UTC)
X-FDA: 84691934124.30.C4FD46C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013062.outbound.protection.outlook.com [40.93.201.62])
	by imf04.hostedemail.com (Postfix) with ESMTP id D699E4000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:55:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q7MMEEPA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5bvDByMgjl+YuCLWOghI45uyIUL9A9pfHsjeoZR3P8=;
	b=ayv6CLlrkJ7sIGrl6IAQsSeQ+uiK9IIWohhOG8/uqH4elec8hBVz02QAVPmJE6XFmFFRsS
	HjewQ+Xse+TDeHOoTPqgxhxUGAvBD68wymKZ/vCrpKVD4O6+7C46OvxoixwDSDnb7354PZ
	VZlbNtwRR2KImHy7+GaHW07mqTNt8N8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q7MMEEPA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999339; a=rsa-sha256;
	cv=pass;
	b=1UxELGWJkMVQvYa/E47LVelTDQ8U9pAjtlRNRvSW1si2QKRtkA9mlOxZ6VCVlxX68iD3pp
	ypWUFTmvFwZWTfTECK5O1sD0dX4DVkRMVTBAIgU67vPTylk5XHdL6OZzAB1AScXs8RipEH
	MOqPRgW4Odjae1MFJlymXIY36QeQhOY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzMFl+wtuZfKAuPtTNoq3pjLrGw4ePYJjf0E2fAJqv/pdSpvQi1iNz9TO5h4w4y8f71+Evz9jA4DRD8mBcEB84HTMt0l8HwUyV/jh0Hz0oRwtywUa+1r6mp4w451NemYD4yyi4NRpzv1siNHscRV6SPZrzDqglMV+8m+d2HUBdvg2Fk9OC7Z/A47tPo56ymgnkueE6nOVpzAaBxvK1yqzvPDu+YZtVPa0K4YwEjlCFc5cPUGPEjtosJdKlY0MRc9iEaXRTTUIaB1lyJlCvJxB5XQxuRvtLgo80m3Lp+am+4mqqBJmXzvozvS0tJUbi/+NweY5FVURpHqMCbt9DeDBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5bvDByMgjl+YuCLWOghI45uyIUL9A9pfHsjeoZR3P8=;
 b=h9rG1K4uJKruXBd49NH8qTKFG+g31P5aYASXJMyTvoP5dwBpCU2fC9TVC71DLjnPXKODgqGyPy8SHMu1bf2kQqwBG+pZ+FpCCQTXVktMP822YkfA4oPUmyB7z2r6WSG0pmgQM+gbgxz57TOWFqHxQu1G/60ABse7qEGxzMXZlLxCz+TxUt+8h4xAtbfCW7t3t4FS1bTCeUuUvRWI9Ei/+rUGaVHNCueWjhYdPYUv/IKZp6/E0/1BJVkZJgSmtkCA5/QnyjcEGedjMtMzY/d+21d+PNwJyDS4rB2CeXITgBxRcVePZnTvBuMtOl2mKiEYKSaCq0wNtzk0siEScRKSMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5bvDByMgjl+YuCLWOghI45uyIUL9A9pfHsjeoZR3P8=;
 b=Q7MMEEPAPZDSB82rtxW6tLtFHDF7S1oOt/4jhBTws/FXwCbpBt9eVzyQgeR437SI2C8L5zIOJNlduPdBiHEPKqN1kTulELY5lkOzgQxiOwD43PbDt/hDbSrmoVddm3XyFDX7sHBo6NDSIJYbW1Xncrg3wtH6JWxj8OskuuxiLSyg7zetSTcuYoIKBK4l0sg5jb0+ImP+UN8kawVMnFk6cXgpD853UK3WeC/1QGK61pJpn6ybOY1CFyCKgM9bz2WzDmHT3THOuyuxN8NvC1YUpwh9V+DSuS1mkpNDiUKdEP666XP+g2eYTF7hO06UQ+9cvMzosZhpqfEjEhw9dolmOA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:20 +0000
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
Subject: [PATCH 7.2 v4 09/12] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Thu, 23 Apr 2026 22:49:12 -0400
Message-ID: <20260424024915.28758-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:208:52d::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: f05796b5-f6e6-48d0-c7ed-08dea1ac80d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yskLSkKERtddR8aZKQAh0YmuugUwGea0ubaaIw2QZ8gtPDXFhGBDFvliFZ5K7Hb6d4n9zPFsH290rUS0Rvg2SwrKxzURojmHB3+I0/Xyk9x1dCLvAkP3GcsRLMGKQhq33Q77KBzsT6Oa88G0/QF7dqUz+/giVEgCIRL+ymQ3IRPzaZoMS30Y9X6BhkGjb5+fygEULXCOl+rGysO/9CFqK2Dx6zjJaagdttl5xGuuAGAnMNuE1wpIteDFZogDPnpVgQ05DI94nDxz2OiPhZHQdJsMJsXmZP8PtDO4pnDw/yNHdBcR3LULf6K9t2T00KF/j2HksCanwLnJtaNCmlZvL8PVdHS3HMulMZDfIe0Z9no58kr5nElAXhVbISKNtmUEuDq1zseqOBV093IWt2kP5hP6lGqLnC1KqZLIxNfSci0A+dEoHz9Ouqj5K9yb5HB7t6R7z+TkUygaQ/GJA4f7/Qj6Mo81AnW5/IqVsiWp7NJnW9PuZdzp33ti7OVLd164YHKgyD/WkU9pUlXEyFJeAQllMACI0aXAQy9bNG9JWZbeJ91nFFqWzyJo6HBgZzvgsQpPiT/Fizvx9k3Izi5UOj2+AEyK5U01gYHVCKdYH61FcJgK/r7vBNiYrXOTaVi0RzjqmNKVXg6w8Y0S9vLmM5uHqg3qJqu9YVFOPP7xsRvgyzCkWq16kAVYUP11vB1AxyQ0H1Rebi2A/4GrtxfxaRgcwQOfeUGqbkNO7ngsc7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qKnAkwZDIusBdnn+9pnl5c6qN1g3hjIrs4TmySPNf+vRggEeNy/Nz3hywKh8?=
 =?us-ascii?Q?sFGGWwluRo8xyKeKKcWg8xC3VaumFpKB7CXJABc+nE2OWLPoSigUV4Z0d+bq?=
 =?us-ascii?Q?GZ8WP+neFTD7MjP91w63Z+V631AW5cG2IGatJ6yUSQi9SjYGup8bfDKU4DeV?=
 =?us-ascii?Q?9XqQaMHX14e4zTTlm3XMi2WyBMWCiuUPod7Y2RmqcEo6AewRKaYjDTMPjiWw?=
 =?us-ascii?Q?9XaHNOeY5s//c0ZkFg5krfmqk3PGpBymhQE28ciwHYwAfwMoj0uqA26ZWOq+?=
 =?us-ascii?Q?rSMwd8tZJgVzD7HlJvhguDQ66pobr+ld9xEUFuhkKOLL4sadIlzrc5qrztE1?=
 =?us-ascii?Q?qPw1ANncXxsCyHoIFryRfu7cYkOdhYDkQREUI9iItJuK0JrW8foC2HlbbX18?=
 =?us-ascii?Q?/s9ofkne/t2nClbYIAboaDcIPJvsBOCpP7UxYq9oiJAVcx//LTkBg2aO5l+m?=
 =?us-ascii?Q?NfBRtoXSL67eTxcb0RfstN69InYVamMQuL53OqAURTcOj/h6lyvHjU4svg0p?=
 =?us-ascii?Q?ojenP7QxD/USszvt3b8JEmWWscLKdytK9S3T/VaVZXOnVw4hk9Yr4xu+LjNb?=
 =?us-ascii?Q?cXtrUoYyK0YLntemsJzlK8+5iN6CXaUWofz8hu9KM+7SQSPVcwUVs0rrrLsn?=
 =?us-ascii?Q?nyqblEco6SUsovcYsYSRLt4gaWak97CeIERpGfyTi/7BG3BmAn98fd6q1pE5?=
 =?us-ascii?Q?nCT83OYxKOsVBZbTPLcFGBgwKRDQddUwAGXq5rAYVtF9uCbN4eLnDwWKuPkh?=
 =?us-ascii?Q?jCxrRgiv3gmRRlfiQ75JdGpXWf6IjsVhisvYG+V8IqiSrVmG+aTC2xeFDOx/?=
 =?us-ascii?Q?Fd/VX1CFEYM6waZ2ct16a05Bo3vswSg6fTcusRODiW34e7aGeXtOdorTp8eH?=
 =?us-ascii?Q?WfC1oVQ1RayYaO2tbfkkHY8mmxuQBRJ6+6wUtJJQIz1J7vQpJHOIPTI5pHqu?=
 =?us-ascii?Q?/69YsiA2BEO+sIwswwo4YSBbalTg2ji/ugi99Pb8vjtW/WgUdmdj0cxGoiZA?=
 =?us-ascii?Q?IPbOOGCH8LTTz9ut5/GbO6/yVwAgQJxIOryFDsPtGlmyrBe5vMbE9iikAxFj?=
 =?us-ascii?Q?WymmuUUecmNp+399s8g3AeLuJ/mi3+fiFmqgkYQHH8KnHvxvt3Z+TVAZUSvk?=
 =?us-ascii?Q?HFweVgxs3AoVnBGgWP7Yq+ZAVcTpXt5hkU1pa6+5+yd6qoRCpmMFKAcQqMjP?=
 =?us-ascii?Q?4DQpCJC9Qh8Oa1yxfCOCuDSHo2twbgWOBwqPDCCqAF0OzC/WqLuztTuODfMo?=
 =?us-ascii?Q?KydGkk33M9Q5jR+zPgtEWseNh1xYgLuO2Lsa95f1GVmijXwiOdkYsblfHt8h?=
 =?us-ascii?Q?BagojHGUtG61RG2JbofX1LqvHPqB4OxI1ywM7sAikUDDs1i5ZSoYQeHI5RwK?=
 =?us-ascii?Q?k0ey90kR1njgGxXFqFsKYwPUSKIl5CBgyTnm5Y8SpcVbsAS12TVkTzwnhEUq?=
 =?us-ascii?Q?gExZO7nzGiVFkxaVCm5zNPjt9fS6/44L4MfXROcj5f1bobR3qRG264F5w0Eq?=
 =?us-ascii?Q?b7n45M8LbUB85/FSr/gukTxuoiVvi5XAUVJi3rPGGk4MEGhVdbTX9cq5EF79?=
 =?us-ascii?Q?74sF810jmYOr+7RrjnTyEqxSvWZiBk4l6LNeVBYwZhRuTNJNJAahAwHpt49r?=
 =?us-ascii?Q?tHXJ38Yx+DvXFsV0Za6FNo7CtLQeUTVnetsOg9VMucVWEV0y2+5jlwXlxiSb?=
 =?us-ascii?Q?NnfGdKhVaYBGLsvHOGEeUSSlGuqm8a88/lUUxwO99z4fS2Cr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05796b5-f6e6-48d0-c7ed-08dea1ac80d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:20.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6bdaLqo7hKdcUHwEch/RpFv5Hr8uGnHZDGcSlctaYOG8iWGrPQtCIcWix3wM8MR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D699E4000C
X-Stat-Signature: n79ate7ar11dy997irn97zekeii9kshq
X-HE-Tag: 1776999339-810086
X-HE-Meta: U2FsdGVkX1/Dzi2T4uZRTHwncPhmdk0YQZHlY7rIi3mnkR95EL46aOlgNXWrE8fapdUrEO58PIdec+jjRICRYdCkdbJ/IuGOU8BjpzFXo/Svox/5f0mg2yRfM4zvNAfRSJsy4bpvV7sSXBWmyZAce4302YMz1nOGMAsdrbG0ciJOCiuCamUQqT1njhzDP0PTCyFePYtPZ5InP9bstwUSnl4Nnpa/xerj5ICnOf6E14WJXCFGybo5TN3ew+ymHTyMq/XgrDANCOGTn54B0OSVJseTAOiSg3EeSQbG27j391fBtjE0RiM9nzXjLkRPVFvQWwevdnUZG5RuErQQEje8KFpVnMraaXlYPOoauRbT4pcIDREce2DsFf0nX9ngMpLIlJeg+mA92T8Nsrskz5wWr2uQP1xCDqxmnGl+Gsz307ZEfYw0fl+Gnxv8RVzu7XoFpCderL3PemBqqmfvlkP1/ZJ0nrmBQL/O4JB9mNKQfp1TF/tFchjWJYeJRIZIfL6Fsbnfvkxr0kdViAGzWXSdoT6p4nmaGcTCUcw/QhJCj5//sj4B6DTumSOLa101Txo6WI6Wqgk1twyzA9Xx2kmlj/oMgqvAf3mNRHpaVT/z0vQipdjzcDcTGrDLX8f17QLsIcZqyFKOL+V0/v249s2MI0MvGK1TDnC1KMRXpBa+rVGbBXVfJBBK+hzw0YDji8dpi2fwhelHxA5saaPaYzpEZQQbF1GH4wgdqDeRmPfEP83OQqratCRIdJaGGb7chIXaV1DTBR5aC23CaIbuluZzQx0PXxEuHhcMxMBisx+T/+jP4aaP/jZMrogu/6L7aRoZuzApkdqideAOtxqcedtp+h9RZ6rF4N4UMFllM3dljUip1Xe2asBYHv+YcD3TOVDDrtTtnsq6PXLUPxtq0GS+dHBM9SMkxuI00vpX+414H2Dy/Z+Dh9hYCXOZlRF9farwaVpE9HDcHl57mIjmXg6
 CkJo6vie
 V/y7WE59t2IjEVHizVhTMT2Xq7PNBH6cYwYAdM0Dq+Af3FRiQW6Dz0aWHDH3aXPuw5YD9Yf2/Q1uMsjModA3r7FDXOo9A2pGTZbsvB4yHT2dZSur/hC6rPAd68fldjTBvWCM61QeJVYa5TQLeAChLlw2HsPL+kZXirRE/b64EvOmhQe1AW5mWkhefUhiQsMKS9mAuzzWwZg/ccQ+XqXXsKVlekNZr7Q2o7qNvv+3EJ6KNs8dIGJmtsrY2g5U9h0+fSdV+JeUCNce8emx2IpIZ7cq4z1x6Nslc0/ali7D/u2o7wKX0suAChiXaX4tdKbNChtUaGmFYeUGBDw4x42mj0iJ77UIBtnk48u6HBCtJazEZULZFYRfVPlp+BZZfHK46Pu4PlmrHwXN9JcWx0/Pr3MbtaSXXAVybmpOJLwoMnaTyOT7NEjS9Oyd2KpaWJtGx5ijkMXPXlWpiiEMPks3nXGawyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders. try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and all
large pagecache folios can be split non uniformly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 48496f09909b..127f9e1e7604 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -394,27 +394,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -647,8 +626,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 12cc89f89afc..b58ba940be47 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.43.0



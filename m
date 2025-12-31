Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BFCE9410D
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D526B0088; Tue, 30 Dec 2025 23:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CCB6B0089; Tue, 30 Dec 2025 23:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F446B008A; Tue, 30 Dec 2025 23:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8BB06B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:32:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 669501A0422
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:13 +0000 (UTC)
X-FDA: 84278494146.19.FE37ED9
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by imf12.hostedemail.com (Postfix) with ESMTP id A610C4000C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:32:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i7cmNFz6;
	spf=pass (imf12.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1lH5SS3FPf98eOj3RCW19JIBohzq9Muvg/PqFYkKtXs=;
	b=16PGg5l3TiHSAD+JHuauzYmCR7KKd+TRxqUFFiptt58YdXpdtAWNsVz0YVBNylgbwSmqOX
	x4437XfPtKUkmzLcIPENDj+Dl8ta7Rl32SyG8YT+/csf8VvZAITRZ0Es512jHhmXfO9ZAr
	FHVFDOIa/1tXL/SC+m489WsgafnhIoQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i7cmNFz6;
	spf=pass (imf12.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767155530; a=rsa-sha256;
	cv=pass;
	b=4gmRZG17vkjImGcs1g9sRLi0QulWV245wxTRPmasHJlW2OrZ6xzS8+60Tt3rSCpHf3dTmM
	NzyR1W2+pXhZ9u62iMVJxAVphVkhKnyK2riqlrYlEu2nTO8DOQ7KWqE/VcfKngVxvnQytT
	rEN7vtG9oNjrpi421pMO5sjJN+Y3nfY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ld3S0mbZAx+P/KhegAtFAS5Wd6cOKE7R0TOasNWF+QkWmgt0enL8Ffd9Yab4SkVbT//+eajMH+0PUobr6PA7vR+KcDkqVNl/xTmD61I5Bfg0jR16ieTqhtCpXZc6bu8psaPvF47iOvK2KPGTBZR/lKzTuk1jznCq+9CGvwzNNpDet9D6akCEFJRTotSX36OrCjEGGcg7F8Av6PIu4WKmsrkVx08IrfnfBxptm8Rgqqs6ajlYr16qq/ou/yEHKTdB42V1okk2TcoUE6d+wfr+1xi/wjhLfi/E6CiZv0ZZNfUDxN+A4P89KyVwj+nPngaSs8dTpoSJLMe3EZOlzq1YSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lH5SS3FPf98eOj3RCW19JIBohzq9Muvg/PqFYkKtXs=;
 b=hhTk+l8ClmXDeX3O7UBlFdHa5ykG3urnwWGL0oRKnuKYA0VuU1wSJKy07xZmZ/KtCz20lQak/dj4aGf08enCwwN3IcCR9qcTYL5xJbK8hrXD3G9U2FvUUViI/IK/AjAPQoVi7DNb4Pxa8189aFEApqf0tk0IkyIsArxgiNNvmiuurxNfsZ5XbpbR4lMDvq/5Cjnj/zmiaow8he0ZBohHC5DNDRDVnltsjgFs/Lhn8/R5f2rM8reNn0jgTF1oMFYmXEowCRSu5C0R+QrMGmUFbx82sEjxUQoAfxuct4x2n56on++iEPuJA1ZVEBN02/kM/z7jKnYBzxV160ZQ5TF02w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lH5SS3FPf98eOj3RCW19JIBohzq9Muvg/PqFYkKtXs=;
 b=i7cmNFz67D5+8LUUwFZJqlkceu51H7njFptSKujumkPFx2L9jbAL74xBMp2Gj1eXxNhDymWGUPyl31FRvqYmyCPB3UkT3nthuHoR1qEBrGLpvPpRNkGyqDuMaHhanzAK8gy0UlLF3t/Q3BPMRbDYKKFhwnEtVPYkDpz9Fs3D43ye7NYpkCjknulOtlAzR+cad+AyNeib+Tb9EIhTRpCOlGOzEqiU+O8dKQ5f4nye96lZbnXYHx94VKoJRN+BDApbMkfLAsAIlPjeOMbZLOTQ1nrb8AHqXWmmAXSgvdL1nkKr6VLB7WT2Lxtgnwdhm96hO8e490bUF7sQ2F9TbTq0Uw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Wed, 31 Dec 2025 04:32:07 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 04:32:07 +0000
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
	Felix.Kuehling@amd.com
Subject: [PATCH v1 0/8] Remove device private pages from physical address space
Date: Wed, 31 Dec 2025 15:31:46 +1100
Message-Id: <20251231043154.42931-1-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a03:505::20) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 195d558d-b1af-4b2b-ca7e-08de48258e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v7z+Epud0MLEh8Glr95i21wOlMvzPKqrReTVwdzWo9Z/HVJpU/boIibyNdSN?=
 =?us-ascii?Q?hzO40HXYwTC3K+vMNuxzYr4PUz81EfxnM9RgJmy2MzD2OyRXWNvIHkL6b1MR?=
 =?us-ascii?Q?yjd0koA+AvrctSh9ud8AmVJrlguuun/YDxA2ZkTcWWy7fzMimm1HtVUTpIJ6?=
 =?us-ascii?Q?fIOdA09Ax8DlVQxuv+kGfRDa1zrWyOZaFGOAm640c3z0q9oPDtvKIOxs6nZr?=
 =?us-ascii?Q?W2K80MOMktp52aoR00tLYFG/dGCcw/GxzZtagM3sUZDR47GUMary2tfm728v?=
 =?us-ascii?Q?/1w53CISEO6V0qY0WCxq6/CZTwEyZ+jH3q+2s8e5ig6tNWITQGqsYi7vWI3U?=
 =?us-ascii?Q?hS586RaeuYo5VzYDikJG3aQ7cplj4tmlUA7M+G+tQwIpAddkCtUtnNd2Hqkm?=
 =?us-ascii?Q?dx/B6WH/anCCEj9V01cD4Etulg6CpCps0QWW1j21PwBZDq8sn89KtF+WD9Vh?=
 =?us-ascii?Q?+BFg1aBteTX4z7Agw3FCAQEDieNEoK6pr31dsbD20TLVABcTHEFUFcmRS12b?=
 =?us-ascii?Q?YFy5lxCOqWS/KJUlUQku/QZOXqjqJESlAhnG23JQk1RtmI8vZgbvMhlsnaQU?=
 =?us-ascii?Q?rW0kQ3JBNfs6V/IdY4dwyMKZ9M8wrnogpZ0AxM52ZowPzuJtAY2FbMfrCKlp?=
 =?us-ascii?Q?ks9/fA9Bu7SWP+6f80RrV3lrQkMXt2sNh+z4CJv+Q9QN+VaIt3Zgc2EEwvS5?=
 =?us-ascii?Q?D1hbTeLDE5gqzY1nYKqi2cMEBA9uOoL/eyFCXUlLI3jC+8bvI1X8SkNzKj00?=
 =?us-ascii?Q?VfkS3OD643d4xsOHnIC6mhaVH+fr66Rvt3S3r/qPwW5Tkm2hR48cxaSYcwdH?=
 =?us-ascii?Q?zbAN3MrDUOcuLO/1qF07ilbm5oZuzMCjpzjUgeAs0GD7+PK6FFkwbTXTtMqG?=
 =?us-ascii?Q?zJcaiRhndUd0CJk9mJn1bJhqU+M9qBgoqXWLm8YGbiGCtX3rZP/lZH5TBE8S?=
 =?us-ascii?Q?66fjY3U/SsaPKuW9I8XhPhZSnKWXGY36O/tOVvPdJ4IPXRTZTTaXr2EiwkSk?=
 =?us-ascii?Q?CtwPrq8Qit/0vTVyJ4zSD2lcNfQa4UfEfqu6sDMsshZYpkHorDK19tSczOCb?=
 =?us-ascii?Q?EjIfhfm6/1githw8Te2cpkcn8nzoG/zl0xSSnaiaFy1H9ZfAf0ZHnFT5QJlD?=
 =?us-ascii?Q?qO+MXrXnz71z3g/9Ds+jQbRUOshYHD+afzy4+h3g+mJkfSYthVaTKN5Z1Acy?=
 =?us-ascii?Q?pD959lJOgOjVydpxcBjLuJ5ldj25mOWgcuaQ1GYohj2Z+TmRrW7kyQtfR79d?=
 =?us-ascii?Q?GSnKSY/a2GJW8FVscqjhRKCwQIgD32G3jmgFwhAkT3PuioYb63Frpq+lOivw?=
 =?us-ascii?Q?jIlR5TN8Cm0T79B6PchZ4oJO/ZLGHGHb5C9l2344zh9V+eyPOBYNyHwtcB8j?=
 =?us-ascii?Q?H8c52jBDC6A0+ULytdC9LUcyHnzDjx3RW/e00VHoOvjntizTT8e+tAqhEmY8?=
 =?us-ascii?Q?KQN0zMpDsQBRDaSodMt9EdCJYtvu6C5M5JGPAmBQMsMnIUj4xGCplQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qgBKxDVTCVtxNOH280pI6tIPFbpDvqmWC3+2g6a4XsbGfOLSM6deTNutXRvm?=
 =?us-ascii?Q?lpn//nb9wxR2H4jBIzLd2kIxdWDcaYzjdgNCWmyhis1O2kp7tgUlsTAnH3lW?=
 =?us-ascii?Q?wLCfLT66KalnXTpmFZlVghk7MXHUNQau4scxtwXjYGPLrR9EMOv9t5y1juLs?=
 =?us-ascii?Q?f3kONvqJn9Fm4RFZCaODwwyLSkKmH9OUzUM2MtSXw9SlRXUl47cwpIMJJLUO?=
 =?us-ascii?Q?+k9KeMb5j5o5KaIGkOtLEe5eWSbbTJHL4ylkbO0CesZBJbCsm4XumHi67xu6?=
 =?us-ascii?Q?JjUEzhRSynjigxAZF3xBRGy+U3MlBMp3q0yhV5RtgOm0OZFdp8EzxBWe/Ept?=
 =?us-ascii?Q?nU0wAUCgnZ4tYuKSN3PQxt2XQA/xDry8Tur+fWhnTvNsQgEbPehfe0xM32df?=
 =?us-ascii?Q?Q9bXaPkj8G4qihbqAAwqe9MkOZZgcCq6c/4TmRP6hbL1PVVL6SznZYDkFG+t?=
 =?us-ascii?Q?cD72xQUFPptZNG7UlpXCVRMAWrvGu0rXfsc9N8zxbxsA80soBFOhiqatt1qg?=
 =?us-ascii?Q?HDvUoJWeTDiwsd3Kb10JA4MkJVv7tSKyaZi/kzhWU+uB6iZTP/Ga/+aQObI6?=
 =?us-ascii?Q?NDN7p69YJdxcs2VhZi50geUspCzZTizIXTvwk+fHPnxINdvf8vxpgBFSfzbt?=
 =?us-ascii?Q?mP34GP+NNYKS4PP7PklzI1Z7/+zh7NAI13vf8bOzT78BLDMkQvfR//ppJbFP?=
 =?us-ascii?Q?ZATg7etRBB9KHnqwB31GTiBfNKIxOdQEffFu8EI3N8ScmYMjDTBkrqGGCoUN?=
 =?us-ascii?Q?7IRxmSevzLAW/K0t2y1HRb80gZU7PykpOR+AFp1iEGB8wJsZX2w+rrz/I/tJ?=
 =?us-ascii?Q?4QxiR8HLRLoQfA+ju+89rCE70jmmwxncsA/xuAVYIa6bK5XGpwELCeLle1nC?=
 =?us-ascii?Q?xoEpwIl6EuP2XDFFcd4M0VeazVBTDBzCmZG9q35MmpRgDdN/VYQncEmQ6bxz?=
 =?us-ascii?Q?YNFFEPfodee/MsuNRKsF1qnwshxo+fwpX+iakpS+v1B9woyvWUAmExhQZBpr?=
 =?us-ascii?Q?/kZeXMBoE3jEupQwvz1Cn4SIKtSh2bi7oVQgvT1lplO7m3Z+PrtrCBQZrLvq?=
 =?us-ascii?Q?AxIDeHP4Q1wjpT5R39ozK1KcdkJmL03QzCFU0CdWz1jY1OJwrA5MgOtVuz2p?=
 =?us-ascii?Q?doJJmDHmgpXgAW1SUJq1QyT6jeYS5NOlwCWuyR7aOm9qY4UttmRtcZ/3n33y?=
 =?us-ascii?Q?sJ3a/Ieze3s1HrmjD7uQeRMqLHoivXQdkt9KOdEZLiqB0u7lSQtTSGRozmkH?=
 =?us-ascii?Q?Pe4bBdjktTAh4EVVvpgkYaSeb7Msgn/KHUYr4+3cvz4yIFfuV624w7bFgmuj?=
 =?us-ascii?Q?HJkRrZgsdyE4m8oiAbEBKhfLuOiaarKBrlhh/+nqfokAeP1j3u4auGeyX0Hc?=
 =?us-ascii?Q?AhPEm/X/TpDnzL+S06fJaOdm/KV9FF+uua3RTpjwQOpH+nSmrJECGqbaMVsV?=
 =?us-ascii?Q?yImEFBmv/Ld9QxplLjDuXnP/wCcxb8aYHuFsolQI27CQd+6IqOFiRS5scZWY?=
 =?us-ascii?Q?AXvNbZaHXh5CMRFh/l6A8xECBirlPRAiUrtjgJV93Qhgk00wd1gMKJmeWJDs?=
 =?us-ascii?Q?Pjl2leemTyD0C0LdqbOShMzBA1Iq3iDIS+WoBJ2Oz3Nb4FFGN4nyu770omMk?=
 =?us-ascii?Q?PQeRs5SBhe9vqGLrq9/sY82/3qeo8KE+uf3wQrUGtqAPWuGggPWQaWQG4lb/?=
 =?us-ascii?Q?biOwU3n+Z6/P9V2W5yicYdg7dIvsQR/9cy2aSjeljaKV2ReQSK1MV1Z6gVly?=
 =?us-ascii?Q?deTrjfNFdQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195d558d-b1af-4b2b-ca7e-08de48258e26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 04:32:07.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9adz8+UN241fopJFBADuBy0nKi0yy9ISndUHRFI7e2fx6rTnOxJsus7cYl+JbMtaS5N7OCOOdvkLhdBib7TujQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Stat-Signature: q731uqhyiew7n38sti6zgb6rfc5ggqdc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A610C4000C
X-HE-Tag: 1767155530-270028
X-HE-Meta: U2FsdGVkX18YuOIVdjAegCdy8yW7GUWICn+F/MANj+tA8Xt1BzVUES1zRuLY5lGI2wNzA5CCkvG3sUqos7lPW16PXtQMS0E3WnslPcRyXezO8dseWy5KeYyGc+Dvov+KFk2o3hOx5BSc5hHx51Bhuf9dPbzCOBNBllsgvvZ+DTjxaVCkMFpqz3U/NfbM+Z8yyvGT2//ARG/GSCFawE9tVOxs27a93QSBJEqVB5jeOMkQ7lKUK085aX3M9goO3yjTRATz4wBehuL0xIUxIwn/b8FAN5X+GiHYY85aV8DHALuOyVvhbkzouuGZ9786F1Dq46rMporOkoKHK8+ShOucGMLL+MHy5O9+szTuyjBy52atd+sPXrFK6j6Dp00JQM5JBzs6DGa4O2Mt3934XxyHWvpA3j+wNYK1ktomprg3DKwVT13q9/1AIvwNEUw6FziHlotqm5R8EHKHFBHexw76OyfsPFfzG+ytaN7ZhBVphJeEkSLuStwrWJOmZhtVEIC5EB10XERiCc3S6rlUwurrwCiUL16opIPUEYV0aJ82sQHT1fsJS74x24/WiSr+U1byDTNBy9Lf94cAU2px4/KT7rT0M0WPWmZYG3UALCwpTehq7m/NyK4UNLHGnj5rxtz8XY6nUlsQsit6X4UDd3yyvdn4xc+Ga//gEo1Ptsw3sTFNoAHVcmLkqn0wm0KX/DgM95jMHhQRDd9QOJ9orGDcZfH+iHPW+gBCZbSwRV3yxsesSdhqxGNP4qJ8X91wqNmV/rgN4C5xOVu1JdBIoDHZWqUKoJ5uZ4WRDtAZTyXioPxT6Tn61L2veIF1kKvoTrCekoOkh4Tcl6cziqC4rBakzBxEXdkoH7fqnAbZVIvx8bHyxe+nZHdUHsKOJNDR5blCnOBscd/2tR9ymNQtwzyDpRVVKrCS+ChiP4bkuVZ3IRHl7kwNaSM/gwxFWejI/cEY8iIFJKbVVLGLwMffB1f
 w8J+jNPH
 5Y9wn/+iU98GrkHww5oDfXadgWL9zc/210sgQs7zj0Nje1ERFt6klSClQloTnqqczFGc6Qzt7UuGnPrLvUXCRF8/HTF5LP7MO6INqKH5ES0sbvymNmedGWD9uXBbPs4cWc4l4Uy66b0gw1NYbh4S84vx2rx30NkMBuLcibbmCjBLiadSbTBttOLLXL25ivSAt0wiDaLNPagGLhAqZaf+s3d24kU8a21jhqWJSFJFFq9UZ4+opHL60jeAqq6DHEdH7u8fgqDeode26oZTsLYi307tWaEZuF2nEYWvfU5byVTqrC7YmSXmRkjPDaztWJKHiPVJG8HuBOFkgqYdGyW/9Ghhz0ELliST9aYrEtBMa1k+NjbDATX+nvoHVpNrJIqhwpwFMoxc17k9z5nX3WI6IaUdB4DYNRDvNbFPMHyQPvKzpNJ2nOokgWYuBeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, when creating these device private struct pages, the first step
is to use request_free_mem_region() to get a range of physical address
space large enough to represent the devices memory. This allocated
physical address range is then remapped as device private memory using
memremap_pages.

Needing allocation of physical address space has some problems:

  1) There may be insufficient physical address space to represent the
     device memory. KASLR reducing the physical address space and VM
     configurations with limited physical address space increase the
     likelihood of hitting this especially as device memory increases. This
     has been observed to prevent device private from being initialized.  

  2) Attempting to add the device private pages to the linear map at
     addresses beyond the actual physical memory causes issues on
     architectures like aarch64  - meaning the feature does not work there [0].

This series changes device private memory so that it does not require
allocation of physical address space and these problems are avoided.
Instead of using the physical address space, we introduce a "device
private address space" and allocate from there.

A consequence of placing the device private pages outside of the
physical address space is that they no longer have a PFN. However, it is
still necessary to be able to look up a corresponding device private
page from a device private PTE entry, which means that we still require
some way to index into this device private address space. Instead of a
PFN, device private pages use an offset into this device private address
space to look up device private struct pages.

The problem that then needs to be addressed is how to avoid confusing
these device private offsets with PFNs. It is the inherent limited usage
of the device private pages themselves which make this possible. A
device private page is only used for userspace mappings, we do not need
to be concerned with them being used within the mm more broadly. This
means that the only way that the core kernel looks up these pages is via
the page table, where their PTE already indicates if they refer to a
device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
use this information to determine if the PTE contains a PFN which should
be looked up in the page map, or a device private offset which should be
looked up elsewhere.

This applies when we are creating PTE entries for device private pages -
because they have their own type there are already must be handled
separately, so it is a small step to convert them to a device private
PFN now too.

The first part of the series updates callers where device private
offsets might now be encountered to track this extra state.

The last patch contains the bulk of the work where we change how we
convert between device private pages to device private offsets and then
use a new interface for allocating device private pages without the need
for reserving physical address space.

By removing the device private pages from the physical address space,
this series also opens up the possibility to moving away from tracking
device private memory using struct pages in the future. This is
desirable as on systems with large amounts of memory these device
private struct pages use a signifiant amount of memory and take a
significant amount of time to initialize.

Changes in v1:
  - mm/migrate_device: Add migrate PFN flag to track device private pages
    - Update for HMM huge page support
    - Update existing drivers to use MIGRATE_PFN_DEVICE

  - mm/page_vma_mapped: Add flags to page_vma_mapped_walk::pfn to track
    device private pages
    - Update for HMM huge page support 

  - mm: Add helpers to create migration entries from struct pages
    - New to series

  - mm: Add a new swap type for migration entries of device private pages
    - Update for softleaf infrastructure
    - Handle make_readable_migration_entry_from_page() and friends

  - mm: Add helpers to create device private entries from struct pages
    - New to series

  - mm/hmm: Add flag to track device private pages
    - Update HMM_PFN_ORDER_SHIFT
    - Handle hmm_vma_handle_absent_pmd()

  - mm: Remove device private pages from the physical address space
    - Include NUMA node paramater for memremap_device_private_pagemap()
    - Add devm_memremap_device_private_pagemap() and friends
    - Update existing users of memremap_pages():
      - ppc ultravisor
      - drm/amd/amdkfd
      - gpu/drm/xe
      - gpu/drm/nouveau
    - Update for HMM huge page support

Testing:
- selftests/mm/hmm-tests on an amd64 VM

* NOTE: I will need help in testing the driver changes *

Revisions:
- RFC: https://lore.kernel.org/all/20251128044146.80050-1-jniethe@nvidia.com/

[0] https://lore.kernel.org/lkml/CAMj1kXFZ=4hLL1w6iCV5O5uVoVLHAJbc0rr40j24ObenAjXe9w@mail.gmail.com/

Jordan Niethe (8):
  mm/migrate_device: Add migrate PFN flag to track device private pages
  mm/page_vma_mapped: Add flags to page_vma_mapped_walk::pfn to track
    device private pages
  mm: Add helpers to create migration entries from struct pages
  mm: Add a new swap type for migration entries of device private pages
  mm: Add helpers to create device private entries from struct pages
  mm/util: Add flag to track device private pages in page snapshots
  mm/hmm: Add flag to track device private pages
  mm: Remove device private pages from the physical address space

 Documentation/mm/hmm.rst                 |  11 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  43 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  32 ++--
 drivers/gpu/drm/drm_pagemap.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  37 ++---
 drivers/gpu/drm/xe/xe_svm.c              |  28 +---
 fs/proc/page.c                           |   6 +-
 include/linux/hmm.h                      |   7 +-
 include/linux/leafops.h                  |  86 ++++++++--
 include/linux/memremap.h                 |  64 +++++++-
 include/linux/migrate.h                  |   5 +
 include/linux/mm.h                       |   9 +-
 include/linux/rmap.h                     |  33 +++-
 include/linux/swap.h                     |   8 +-
 include/linux/swapops.h                  | 124 +++++++++++++++
 lib/test_hmm.c                           |  73 +++++----
 mm/debug.c                               |   9 +-
 mm/hmm.c                                 |   5 +-
 mm/huge_memory.c                         |  53 ++++---
 mm/memory.c                              |  14 +-
 mm/memremap.c                            | 193 ++++++++++++++++++-----
 mm/migrate.c                             |   6 +-
 mm/migrate_device.c                      |  45 +++---
 mm/mm_init.c                             |   8 +-
 mm/mprotect.c                            |  21 ++-
 mm/page_vma_mapped.c                     |  32 +++-
 mm/rmap.c                                |  59 ++++---
 mm/util.c                                |   8 +-
 mm/vmscan.c                              |   2 +-
 29 files changed, 737 insertions(+), 288 deletions(-)


base-commit: f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
-- 
2.34.1



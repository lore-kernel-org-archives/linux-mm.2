Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5F5CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 23:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874B68E00A3; Fri, 31 Oct 2025 19:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BF48E0068; Fri, 31 Oct 2025 19:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A628E00A3; Fri, 31 Oct 2025 19:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62FDB8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:52:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10B881A0645
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:52:41 +0000 (UTC)
X-FDA: 84060061722.08.CB973C9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26998140010
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:52:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GyqbO6Mr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761954758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3JXCRbRWGJa1wiwrSAR91RoNAo5KZkpz1+9GLCeSbM=;
	b=nLpb6KJIl84Tfw0Z76OzDaXapi0IWhEbDyb5xKJK+Em4iMJf44Oa9uoA8PECn5c/AsEuWO
	INMVuSIj4DPIn1z6u2a51HKBGTaRqfRl+Ugq0G4SWKO36g4LfynZnSRFUoX7/GBbzDh/kg
	cnMGwArIYU/lGiK1yz8+SvEr6mvUfkQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761954758; a=rsa-sha256;
	cv=pass;
	b=KLhCY8jaf4oqYnCUnoQGXktnAfX0oQsfzZ+QmrTMicrHrxRu2KSz/O+s5oNepWp+80riZG
	63OgvmqiQ2NyoRmTC6I/Jn0472Rq7bgD95i8LBz/VbK5D0S1JYmdHYhG/C9v3nT+mdAdNC
	jCrallaQJyQdXRSGA0mvSSC3n8dAn6U=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GyqbO6Mr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PC+f5MJ17n+TUmMzbFtUsz6dEyXdfhf5Ba7IK5twpy2b/krZCxLxEaGxYI7r2G9MpGqhVLYlk0uMHw7LZOZCgiyF5mITshyVRtq8eaLQrz8yLfXu+Qd9Q0ckVGtczrFbMQuzO7BJH9Sw8dlkdcIO5VWAahsMNtGOacofFyvgu0FKYJ5ZNSnHaZktRA+sn1NwuvPUF2G62S9x43F7cmsYHSOV0tWyf5nZBivVl6n+meeTQJlV1FU0eMIMTf4ooNqVJbFSDnBaxBa7/85oKGH3vsW/+3vbGBfCqAXB+7aZX9fKWR2yCW1HdsLqD8K6eSOmwPsiQgHxThWc1VSPi1tRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3JXCRbRWGJa1wiwrSAR91RoNAo5KZkpz1+9GLCeSbM=;
 b=e/CGshAwxU5kuYm8TVgYiibmqjCYxwBfPRid3lrfm6xG+/lGkpr0NRCe+xz3VR30NB+l+cgP5EUNqwNgMwkzPsmnIB0D04D34oDP2MzaBilMrkerrsJs/zwBxxkJceONRY1KB8e3/xueuUanprJkfwc3cfj/F+CtM+GWq8rLpUVuTOUY6nZujhRt+Um2gI/K1mu7l8eWaR/azmCSjVWzPaUPdzyNKwPbmQMubegwEyoJLCiZXtDDevVpbSpHa8TuEaiYmWu2yMq/EacgnOywmSkneG/McrsuXms5aC2oPa21FeEbIEpgcf/uhlAqW0IBK7Scf43SRpeL6dntNTyZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3JXCRbRWGJa1wiwrSAR91RoNAo5KZkpz1+9GLCeSbM=;
 b=GyqbO6MrZ6QMou+Q1uMIc+juXgDYtchqRfthBkoKkiMACHJ6o7NuL7xNWTwFycc7NCjDESko5W4S3tCx8r0YVVJqclBigvBxf+35+UMEeWkakNZMlNUroOJrvxs2/ADqZ3MhnAiowXlH2A1uDTKtWLSO/nD45nUi5kcMSOKeMw7wvJxoz7f8PfPYhS1f2fjjMZGCjjyYuU8w8NX6edVFllphAsLnf9WFlXWZBbygPpp1c+g8DYnpBGOOAijxai2eMg2HdKCr/CgE8c4R4CdSqgzTw/08MZm0cuAYlo55Qtca740l8QAH3V3zzvrUCSylLg5Cnf8oy/ymduL/2GPHlQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.19; Fri, 31 Oct 2025 23:52:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 23:52:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: akpm@linux-foundation.org, Wei Yang <richard.weiyang@gmail.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Date: Fri, 31 Oct 2025 19:52:28 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com>
In-Reply-To: <20251031233610.ftpqyeosb4cedwtp@master>
References: <20251031162001.670503-1-ziy@nvidia.com>
 <20251031162001.670503-4-ziy@nvidia.com>
 <20251031233610.ftpqyeosb4cedwtp@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:32b::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 279e846e-b996-481e-956d-08de18d88eb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W3NHtgM07Syrqfleh0fPXxeWhArM7m3+u6vGiYoSUUpkQ7UuKEjw6c5KS169?=
 =?us-ascii?Q?rTQwvASutooq7iqSRAcHUh163HfoiQNWnzQkQJR9nOl/yxk4NLDYF+LTVVAW?=
 =?us-ascii?Q?UP7ZLX2h1HfO8fUYdvzfe+1Ynw6FoWHaQCn+QnPuXsp4jWj9hj8crAmUnjFt?=
 =?us-ascii?Q?7U/QrHLfcAwe4f/cqMsJP+LWOww+nDP4JyGsR2irDpmvmXztbWRtEBBDVTdv?=
 =?us-ascii?Q?DDYQnRcldJWpfSJdF6L+lR4IHnBDkV+kuxmi+q8t1wAj/7LH8GQua8jDZYIr?=
 =?us-ascii?Q?XuJGJzOeTZmqy9jcDWOyuNTzQ9UhcHLzmPXiGLyPDKCvfgX6oJDX1Ry8sDkR?=
 =?us-ascii?Q?Ab/SERGd6YfoDJ6aBJHi7oH81F01ASu+1J2CA0izUQi6aHywKmogiTgMeiKk?=
 =?us-ascii?Q?Pqnj12Ybd8uZ4GWNM+N+9JtyxL6iV5s+kbpvO1gIrjmpsvB83kJTwrisT/Fd?=
 =?us-ascii?Q?2iAAd68+25thoQo5EXNVImG+rV7qOtRe/oLVkpLgZ91a1IEH9VQEHLhQhFb/?=
 =?us-ascii?Q?PcxUri+4j59JZHg+FA7vJG/DSaDr2+jv6ppf257qqLDwxKvmAZ1zsoQcFq08?=
 =?us-ascii?Q?rX2FnEJ4vSKOcBlEWq75Qc1XP849njnVt+/W8UpPjwQq17+yUjh88awS9A0a?=
 =?us-ascii?Q?7O+onMrcf2G+TJSDnrg/GmjOIKxzIBAxvDXy1tLR8UUNaAuWgzTDuf8SLOx/?=
 =?us-ascii?Q?HCmroafNAMvSCu6HLXbm+nj4k3wHO8zlIheguV4ir4eI85Lb/imvpDxjTOgk?=
 =?us-ascii?Q?nfkNzFdW+Y398s70j2Eco8I5ldd6DYpKgDTK8taoIMXAQ1YFtYkvbecr1ekl?=
 =?us-ascii?Q?FKP5bwd34N0/ego9LCZIy+OpD4AfzFhD0RviPRlBaprEx5ow9BAnNJJCiim4?=
 =?us-ascii?Q?QnHzJoXGrH/kz4EjzfzAL4wa9wu9HQeOeHMLl6asuf0UeUXSKPSUJOp0KhO2?=
 =?us-ascii?Q?3OREdTSIICfYE/BhlZ10LZXlU9D3ExzRvJhzP7M+8zFq5pzf9tepN48uVpKa?=
 =?us-ascii?Q?L64NEvwJrSwzTkeeRhodpc4SqoKHSuR2QgbNvDtlaSh7ExaMa6rwJjcV6kMV?=
 =?us-ascii?Q?pwll3dPHvl4XbaFFl4bMSFsAr56lszzKiZ3zVTn5u/QFQ9if+V/skja0tQtw?=
 =?us-ascii?Q?m9myxwr0xL69sF+ym/7JLU/PpIBVY8uJ0JQESZvdIL8KhflATEusAfUvFV+F?=
 =?us-ascii?Q?p2rhlh/x4l4JMU8xagGC/ohT1cBHfXeE5qjKEEuKUDskN2KjqO4nvUqu2yQl?=
 =?us-ascii?Q?WiM8j2PVxkeRyQmulfrQ2CfJZDhBRcypemTzdHdxFuUlNFsKgw13vm+kZjNf?=
 =?us-ascii?Q?T4E6BfG74OjqdBR64pJMeJmu0FtZb2mtknnShgRDMbqfT7w4fRK733n3CyPc?=
 =?us-ascii?Q?mAmTK7uQMDjvKB4SZsTZxFzTQjGKSJ5G1dfIAi3XlvkG+dcHngbqkIhgBP4m?=
 =?us-ascii?Q?dqiWKysC5gPtIF5qzQGVaMA2bcKkQxt2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kFowg67brAUEGL+DhgAu6xADzZZXfTuyLl8imHkyP6zZfSYvJ83Lh5o6wP72?=
 =?us-ascii?Q?oAXftD7YYk2T651zuSW/xEb7RiyUeLdi7Y021oYtixm3QPg7+5RFxy0x3wRV?=
 =?us-ascii?Q?5iMb2+oIEe1B2aoqtzLAX3fKrxkeKhQqRHNrEexs6n0lvu5fRzl3FIubM94r?=
 =?us-ascii?Q?yoHnTWT9l3a3Ct3GWBo8CEtruVURYTA4s2XvSeg50efz0bLxVZaITecXmpjJ?=
 =?us-ascii?Q?w9KPDnGdGYKK2NxdPduXfzWdgk6E2ktiIV6ghyy8ViR66YwtHKq9qOIAuSFC?=
 =?us-ascii?Q?suHyiiLCSQ6eRD2NyZbmGOpOKn7iA4HviAZrJM9UmVEb6n/S55+2FBUa7mo+?=
 =?us-ascii?Q?gI7ODKiK+KqbVdjqNG/LkSqGyAyn4+eLAGHs6aXAcq0e8UzpFXZ65mdzc+OV?=
 =?us-ascii?Q?WDuZUSh6ZQwppqjDukM17kVjbipFh931sfgnFlVVl8S30X2Pz7m0l5yDbld9?=
 =?us-ascii?Q?hjM3eFLoCO0VXh2i7X7fpySFLaMBvD6I/sEUukNaydEm0Bj6i/7NrkTwEBLQ?=
 =?us-ascii?Q?u5SW273xkhG9itfd0M3UQIa4AhMFHutJ1DMWUMghaMVCeyRD5xkJA8LZ92iE?=
 =?us-ascii?Q?sIs/BOhSkTOEbRkOtg4BuVG+M4YmSKDU86XUYENyd+GZ9lxb7Ky3pxaSBJco?=
 =?us-ascii?Q?tP7qr43iA4sd5uWdvN5st/OPGO+RfSLu5w800FYUD32ezEBfDE7mk35eqXP4?=
 =?us-ascii?Q?gyJFgLgTgQCoong9d5ua7ij4STz88Qopnr9BrjDtTcAL+GEjK7JpXPeWBAkl?=
 =?us-ascii?Q?qRGe48AfceUGOReksmnzIfLcDrKj4zsW+QhlxKiTDRdyqmh67yFd6e4/Cuqy?=
 =?us-ascii?Q?CUXDXTvnw+CjhkgL/E8F3LgMIFi7rwzdS23ldfoMO9weJrlEtfR/WAGQCVWw?=
 =?us-ascii?Q?bItLxpd2LeQeIThTo9lOr9SoH8pIxpd+931ItGlZTvGywRXVvX7gv45MlGQo?=
 =?us-ascii?Q?pvk0CQOjQ9muWj262Xxf3clAVcSaJbhALb+3PZeifPEhsuDWTeLA1Ct9OqH1?=
 =?us-ascii?Q?o8bAKrpMHfH/TbKDcYSNLDAm2folG9bUhbsqfc2E73RL/X0wh6kf5rzftcwg?=
 =?us-ascii?Q?+GoDVvVWdouS96q5toxRpPZXJY/2P04/9Yc3kt23Ka/W5VlOExMBL3iWt+kf?=
 =?us-ascii?Q?/1V+Waqs0pWM1RXEyew3DpY593ddBZMWeXcXO8H6aSno8b/EiP0Y23khvQLF?=
 =?us-ascii?Q?QEclzoYbJ3KAMikmk8nBM33B5PGNBG4Yu6prST9Y2n9c3gXgJDdcGUDbbdFp?=
 =?us-ascii?Q?nobXy4pTOoClq/3iTSqPbtaYp+iwFTG7h8jczgi1zBTM0ohHZXPELQvX2/NI?=
 =?us-ascii?Q?j41YFjT72+huITmZzxyIlITIcZ5GxghQ31kzWUxZeIi6PlxxlQPBQJlcYuVD?=
 =?us-ascii?Q?jidLRw+DQs6yzMBgb6Tt8IqIQ0xzgCjovnXnqvcbaOZJEMH1LT92IPwZUNQe?=
 =?us-ascii?Q?cN4NqD5mFq+ugoq5FJePHLLYz8lHjWG/y1RcCPLFoPY6CBHXkT2AM5Zr5kRn?=
 =?us-ascii?Q?n0Dh495DoQVdTpthA4ZWD0+4hAPyg0j82QLpDQutX2ej0YbqMbxNc5pHHV7z?=
 =?us-ascii?Q?E3bpT1WXeOjtSfjLJGcOABqlfX/s8IgkH+/TIC43?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279e846e-b996-481e-956d-08de18d88eb0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 23:52:32.0380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z98cpkR5OTf7A7jJil0XKAFQ5C42FPanGHkTM1ZgYQeUG6+b+IcZRo9zhcNDwnYb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722
X-Rspamd-Server: rspam05
X-Stat-Signature: rh5uwhsywbrbysyeycf8syfuqapsj596
X-Rspam-User: 
X-Rspamd-Queue-Id: 26998140010
X-HE-Tag: 1761954757-77341
X-HE-Meta: U2FsdGVkX18oACecRKjBpNoYGJDAzzhmHqdSF6MctvYQKnvD9y0D5tWAzVbWGHMF4PqPGvipgExjT36bn9YUWXZuakUdYuXszJilguY1qkSfYpx0rXe41bvV4EEH7xLnw7LPE7aYJnDQqxzG+ZDBBbqqxTn2WnYUw0Y9uc9ignwvX2oFHj6crXacbHhOiypavNaHTSUXmrQYzEHGK+dPLMKehJpdsXSMWpw5oCIJBet+FTnJA03OvHKu68VOSINwsHxUsugqCvmhugI9vldvFjpxD5Q4x1CDGlCf8+pkNc2ul18q/uzTueMQMzQuMSbk7FblunWHO9x1bfsb4OqL6f2yGPI+bQvMnibOMVRZo5UTutwJeju8lQLS4TSVpfFQhdoEmaxaNZ0BtOZGSC0pd6Htq/f2rhOkIMBtcJh/+eGaweoxLeaIrn4xIV5qcTKy+RWmmhqZYNVOVxN3gOd8AUppZGbIkl38ETvDLNw1vG0J98rLsb9ajKX/c7ZglxrGvIWmvJPs5iTVH3qApEiFtTZ9f/FIWKltdABi4W8kpL6QnDZkqYHRviaVz72+saRg7abFvsWbkyOwgl/PboBC+KPPMK4O86uWnT3J8r1kIh9DR2qcsWn8xG4ZbaHAc85WkiIwafoONqvPyE0lrpP/d1lg4HDCSzuvTs7sWqahb9hhE0F5AbMomCZ3EstCFvIT17jPT4wG6HPUNuWD5OQK0mc3qdUeW0JnLyMl+I5b3C2XZwXBEhefxp4bjwpsJa5XrBJDtkxf6ORHMisgXIVQKS64mjDnLbTHQd8i10aZAUia1ReqgPgctvC+pfv7WbZlc5qJ/M+5XjDrZrB+eCD+v32J9A1/q5MrOMiML2q0rpt/P+F5FdT9LAU4rJOHMYkErxTIg4n++vxEAk6qUFppOlKhteg94hngoZulN2FZnACh1uSHAEdnNnbr+j+GcO+rLVD093g7eHOJQms1Egx
 H4G/boOr
 yo0NI3YcRnXNb4f8NWp9eYUfoHunyI2rgi9Nig8DiQnTBJ/CHSSuC3ouAEmJbuOF3EMkpBeoQleVa37nLX09pm14l4iZl7nEhffiH60mPQOyC8lYDC47UW42PsPZ8OFd/bzWMaOkihY5fn6dsqcsRrjMGvO6n6hht4NuD9Yg0zY/ZnP0+zNA0ZRtT+MMra/+hyvUmDHnbHo2CqwsoiW9qmDu0HN2Vpe0PISzcBEFVXCzBfY1qhvU4eDTOEx5ZbN3ZQwQr9aOGT8BN9+1Qn5EoJlX3cL9D/1cOSDK3jG3aWPJj+AYdNiUn7OVhgOTYVJPwvGjhA1oHIJjsbKxr/HZ44ehrOUdLCMccVsH/9vDh4SM7rSPYeQJW31yPAtsBGup6wXXgEeJkqUEGcVfavrlwM78qGSG1gBB0ROMtTRR0it4owre9IO5nFxVj83tR3F9QNCOSYRkUI+bIMj4dQHhjItniqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Oct 2025, at 19:36, Wei Yang wrote:

> On Fri, Oct 31, 2025 at 12:20:01PM -0400, Zi Yan wrote:
> [...]
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0e24bb7e90d0..ad2fc52651a6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio =
*folio, int old_order,
>> 		ClearPageCompound(&folio->page);
>> }
>>
>> -/*
>> - * It splits an unmapped @folio to lower order smaller folios in two =
ways.
>> +/**
>> + * __split_unmapped_folio() - splits an unmapped @folio to lower orde=
r folios in
>> + * two ways: uniform split or non-uniform split.
>>  * @folio: the to-be-split folio
>>  * @new_order: the smallest order of the after split folios (since bud=
dy
>>  *             allocator like split generates folios with orders from =
@folio's
>> @@ -3589,22 +3590,22 @@ static void __split_folio_to_order(struct foli=
o *folio, int old_order,
>>  *    uniform_split is false.
>>  *
>>  * The high level flow for these two methods are:
>> - * 1. uniform split: a single __split_folio_to_order() is called to s=
plit the
>> - *    @folio into @new_order, then we traverse all the resulting foli=
os one by
>> - *    one in PFN ascending order and perform stats, unfreeze, adding =
to list,
>> - *    and file mapping index operations.
>> - * 2. non-uniform split: in general, folio_order - @new_order calls t=
o
>> - *    __split_folio_to_order() are made in a for loop to split the @f=
olio
>> - *    to one lower order at a time. The resulting small folios are pr=
ocessed
>> - *    like what is done during the traversal in 1, except the one con=
taining
>> - *    @page, which is split in next for loop.
>> + * 1. uniform split: @xas is split with no expectation of failure and=
 a single
>> + *    __split_folio_to_order() is called to split the @folio into @ne=
w_order
>> + *    along with stats update.
>> + * 2. non-uniform split: folio_order - @new_order calls to
>> + *    __split_folio_to_order() are expected to be made in a for loop =
to split
>> + *    the @folio to one lower order at a time. The folio containing @=
page is
>
> Hope it is not annoying.
>
> The parameter's name is @split_at, maybe we misuse it?
>
> s/containing @page/containing @split_at/
>
>> + *    split in each iteration. @xas is split into half in each iterat=
ion and
>> + *    can fail. A failed @xas split leaves split folios as is without=
 merging
>> + *    them back.
>>  *
>>  * After splitting, the caller's folio reference will be transferred t=
o the
>>  * folio containing @page. The caller needs to unlock and/or free afte=
r-split
>
> The same above.
>
> And probably there is another one in above this comment(not shown here)=
=2E

Hi Andrew,

Do you mind applying this fixup to address Wei's concerns?

Thanks.

=46rom e1894a4e7ac95bdfe333cf5bee567f0ff90ddf5d Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Oct 2025 19:50:55 -0400
Subject: [PATCH] mm/huge_memory: kernel-doc fixup

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ad2fc52651a6..a30fee2001b5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3586,7 +3586,7 @@ static void __split_folio_to_order(struct folio *fo=
lio, int old_order,
  *    uniform_split is true.
  * 2. buddy allocator like (non-uniform) split: the given @folio is spli=
t into
  *    half and one of the half (containing the given page) is split into=
 half
- *    until the given @page's order becomes @new_order. This is done whe=
n
+ *    until the given @folio's order becomes @new_order. This is done wh=
en
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
@@ -3595,14 +3595,14 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
  *    along with stats update.
  * 2. non-uniform split: folio_order - @new_order calls to
  *    __split_folio_to_order() are expected to be made in a for loop to =
split
- *    the @folio to one lower order at a time. The folio containing @pag=
e is
- *    split in each iteration. @xas is split into half in each iteration=
 and
+ *    the @folio to one lower order at a time. The folio containing @spl=
it_at
+ *    is split in each iteration. @xas is split into half in each iterat=
ion and
  *    can fail. A failed @xas split leaves split folios as is without me=
rging
  *    them back.
  *
  * After splitting, the caller's folio reference will be transferred to =
the
- * folio containing @page. The caller needs to unlock and/or free after-=
split
- * folios if necessary.
+ * folio containing @split_at. The caller needs to unlock and/or free
+ * after-split folios if necessary.
  *
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio m=
ight be
  * split but not to @new_order, the caller needs to check)
-- =

2.51.0





--
Best Regards,
Yan, Zi


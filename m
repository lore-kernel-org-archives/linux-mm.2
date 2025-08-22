Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC62CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBB0440155; Fri, 22 Aug 2025 13:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3A68E009D; Fri, 22 Aug 2025 13:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A22B440155; Fri, 22 Aug 2025 13:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 615748E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:08:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6BA41602BB
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:08:28 +0000 (UTC)
X-FDA: 83805027096.23.EFD5521
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3715814000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:08:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QmQSjgqy;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3BsPt/hsUiGGdKLwxrd49/GXmJgFiDf/ZufbMJBYpw=;
	b=DWhS0PLz6qngpslawRbj48gsAEURba7QR72Ge5wp7SEkfTPnL1hqN5y7mgZy04sKoA/a9n
	AHVBOcLscSU66c+8LLld/vbewF5pf7EKNvNNGAsBwJj0V5Qtmo8P6ULp9a+mcB2DRBY1bL
	+MjEdrR1mPIS9rzwyRvuxzU49nMAnhY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755882506; a=rsa-sha256;
	cv=pass;
	b=QwyAxe4XQvrjoC0HZzQ2b62BECHXtTzvoGh/D28ZjrCUgGmq9jgbZT0vEK6Eg9vlZvbs3I
	bYy07bDE8Yr0U11lwU06HvZDpi5YT4OH4qqKAkXsX7uE2ZMMvzjZprOr+b52i+ctmZdF0m
	24scFa2k9nugYaf8m4DI/OvOKuIoCHU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QmQSjgqy;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.74 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TCAVH8Gy71FEz06RoR5zFpAOWFKt3tpV+Nnhx0tHFbof0zhtFnpfb8V0A+7vHIDbusMsBPwO7cXNPe6iCdcH+vXVgRx1Tc8kEoyNjRxdn8C4xEwWqYO3csTHt9M4RGqxJE9myRMoUI+zm851FPp0YvxGgFbHFI0cL3UR5KHaIoRBn7Uy97GEl1VQ485OrCwBuaY0xFZyXgVgkAYu+ac6MCa8crsvDzuDFAqgi7GuWG6+sChC35mtDaoU0HtrpAaMS1CanyifGA3NKzxc7uVscIre/k06K6GSeHTeLn99zR565mjBp6mPNmU4kSFtFMQ6Ir1F/ETni2uG5XYXEX7LdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3BsPt/hsUiGGdKLwxrd49/GXmJgFiDf/ZufbMJBYpw=;
 b=fv+weZTJN2kUBqBNBS4nFGRjdhwGD4tKU1bQjFWynFaOZMlLlk2AaCws76U0JYiPEbNSd9Rti9/loiSZ6bSBbHE8o2vFXZwpxQ+44aPsKHNG8py0gImK57ATl6WmBzYLS2wkr41fG9R7uSb0ZFHAjnJDVRMa6Il1bkjLsZ+scXwK+uNOmrXQUnZHZjwbELfgtxJD9bP0Luw7ZMXA/zJNCxGd0j92DphL8XYjEE5QUpZ5PjVRROZu8rf8Rtfss7RN6tBzOFLgr5AFnZRZwoCoTQTMBFZ/ynbL8bxV+nRgBCwJaqFU6ZgWsv5VEmKOZb7T+nHzxJgOeI/TVMG4Myn8HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3BsPt/hsUiGGdKLwxrd49/GXmJgFiDf/ZufbMJBYpw=;
 b=QmQSjgqyrsmplRrcdne1ygMX4G0+l0k4qpgJNPrH7scbAxHgIbXvgnq7hoIgiX8qSNQ9ZeMn9HrwxcnkO++dFZJ4brqSYmolF/OAkDwyVqg7/7Pac9AJfJlCBKD6hhjnJk0L4e9ws0KTOhwzG76XnYvT9L8MsoKpc6qpLFKv5GhwWTr/uxOP7C0rDCu29SjXtedFExBpJTOggGu7ajRDhKLjQ+AvhHgMBWtubgUm0Sy1M/8lpV2zTba3hAOD85IQJszB4BhGbYjhzJpRjmQhvvgwW2TNLJU6WV5DPAsPj/x9RO84nAIsCd/Lp9s3oAhF505dcBnCaVmJqs1xPpHfmA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6845.namprd12.prod.outlook.com (2603:10b6:806:25c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 22 Aug
 2025 17:08:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 17:08:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com, kernel@collabora.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 1/8] selftests/mm: Add -Wunreachable-code and fix
 warnings
Date: Fri, 22 Aug 2025 13:08:19 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <6670A610-5230-40E1-98A1-7F30A9321B2B@nvidia.com>
In-Reply-To: <20250822082145.4145617-2-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822082145.4145617-2-usama.anjum@collabora.com>
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0035.namprd07.prod.outlook.com
 (2603:10b6:408:ac::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6845:EE_
X-MS-Office365-Filtering-Correlation-Id: 08705c30-20ee-4777-18ae-08dde19e803c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QOQKrt5wcOXP0adgULxqSfzmm5JYBg0n9YExjk5+8sT5D0FQXiPoB9qSsyL/?=
 =?us-ascii?Q?WZIchi41JgkF2ALKLPOGnfZQMUqJcPLvJXwuVKy/l6EdigJdFiHIy2RSO7ej?=
 =?us-ascii?Q?07+A0//dLVsgJP/sPQIClhVtXqZJEc14QKG/dSzC7ZOM16tm0m2VEnV4eIbm?=
 =?us-ascii?Q?OoSTR2ir5hhU8ZABoxsHW5FIBCEytuwrM2FqPYfECANi7WbAsDlInF9wgR7b?=
 =?us-ascii?Q?TYLYlNiPBl+WOKlpCzrVWMt7rMgh7nfhVPTRe3xbSB3wiqmO23cTFV/L1ogB?=
 =?us-ascii?Q?5WI1DAZOek6tK1DEjp0A0eQ171Ek3qNE7EwO6kaFTySdO3McBb3Uo6KN8K3t?=
 =?us-ascii?Q?nW5i7yfOhBsHKroPuNGQIQBFkaJI2S1LmhH6DvZsHxVotvESML8Wu4OTVNi+?=
 =?us-ascii?Q?J3Wo/lzcIcOtkMuoQpNXpKHdFqNdcqzbFVqOL0QhzbhPal2kkJO9yejJ34A2?=
 =?us-ascii?Q?KutJEpU5mCumMHXiJ4EF/k1+wBsQ//AEX3azhsfWp7L7zeaKRii0ZysG9ZGw?=
 =?us-ascii?Q?4ScujcA1WmQU3q6KSLC6CLjfEbi5/4YsY1isQptCOQyLfMi5lQLaCeWVpSTC?=
 =?us-ascii?Q?IH3J1NqaMsedmPYLSkNNI3NxcDmQQ2kzpGKfUcEMgAxBGoWaafEBbjG+4Uqe?=
 =?us-ascii?Q?KJmiDilBhKEXHUAr6SgZeCWHh2qkveepeIYmqw1HE6nIbRn7fGe1Z9nLTT6E?=
 =?us-ascii?Q?XUwjVyRp8f0d3OTIG/uvYfvr9CfSqF6L7KmohvjEqjBBUN6SgSBTt5JP+Gb9?=
 =?us-ascii?Q?1zHrT7ONaYUOGaKzIL1ZvVPdXiPZ5VBwe74fBLdfvUawrxrbfiOdr/QZnufX?=
 =?us-ascii?Q?Lepq+vjeVASoL/lJt6sBDwVapLYyhhQBLRj/I8QokzydG/S0P0/+pxXlB9bE?=
 =?us-ascii?Q?XJIuO1VLXjDOBeUyFUkTenY6vmqsPBaympVg5TiPbruK4DZYzalBlP8i4okD?=
 =?us-ascii?Q?JtWDsRE80UCvLnkKES/qMMFI2HMzPLt7T70K4gabYs+TV3yHuV/g3F0EgNW6?=
 =?us-ascii?Q?DnM6Hy06Ym+fIdp8SAVVdB56em15B9Yc96T5qyvp9rDALTSDRJ1zV5T2xV+2?=
 =?us-ascii?Q?T6sQA9iY7sAh5Fm/9HqFRQZpK2C537D2cBzm4W5r2DKypuk5VMXvhKx0a8E0?=
 =?us-ascii?Q?eyMEX7x2EWc4/6MM/s+sIJJVmytfBnwk5GmwFvvyhCBTgZBuFozUWi98T8mu?=
 =?us-ascii?Q?vYKshvXBSrfJ+ah9/duj7g2nkQM3CKR7m5JxpMPiHUhpnDArQIpoPSnQc7OR?=
 =?us-ascii?Q?nEVSBc1O7cFcKYpzUjkgVAG5Rr1AyiX9gT8dzlKKqL35t54JhUXlZJvpxGD+?=
 =?us-ascii?Q?4JMBzFQry89Bp0RthxxeQNxY19eCi1aA0gVILhx+a+icNsbwMcayeItFmzP6?=
 =?us-ascii?Q?yLU74X55JNyhnQwapnio/SjUFJE/yZYyCULWfYLrKSYkj1/johGVHN/MGZRb?=
 =?us-ascii?Q?jd9eHYqUG00=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E55Tkv5cR3ddJa9cCZyGNkyw/Tfvr+SlZCYMoM1BkhrD3UT9rAJo2X4PuIyR?=
 =?us-ascii?Q?vGt1rYAYEHUcP00X+/+WQcg44GM1oJouNcL4v2OzgaaGtaqEm2m5YSEdWbk5?=
 =?us-ascii?Q?lw4E1bDflTRHwrfPouxCjqO4SpQyjmPTq/A1gu7L2gbsMCbDC3d0+TlhJR6p?=
 =?us-ascii?Q?AesxdlwWi/h7L//4HrwkPrBQ07GdzkKwlTbiH1+PfOo72AO4pyVH7oiU8mSK?=
 =?us-ascii?Q?DlAhUNvQEnQQQLfK8TCN0iYm+ZesmLpEIREtLjBs2GGMwSqYeqZotawgG+HS?=
 =?us-ascii?Q?pKkNbnulg3iGBZSQYj7ivSEAOaFMRuDTFwwoP+vWyWfTu/AmJub/DHifEqX1?=
 =?us-ascii?Q?bkrudNaeEKwpW84Y7soW98EnvrIVWsPsrAc4+aWivjL2SBWghaO3u8H+uS7T?=
 =?us-ascii?Q?kzYN7NbolvKUL9xfkwhRXRszli132V7++qZf5Iz6zrlKyILwWG4ppozw7Bp/?=
 =?us-ascii?Q?/tn/GJJQ2Zh12J9xlhCdK7x8BDL3cX6H1cVOxeULPkKdV9i8tBWe/++UAk9k?=
 =?us-ascii?Q?naPWczPJQjOrfmd2MClGYtkxshjEYEsswQO+4nJ8EDsfGxOGdBHRDgeyVinu?=
 =?us-ascii?Q?GLr+bZEHwceW6ESjnie5CDO2+k/bEAZOk+RJpL1AxAxKDWraPUgnWHRRk+Fl?=
 =?us-ascii?Q?WREN3WkI4AevAanM4QynCiyg+cJ3jhKdHbGZUoNnrPuJhMZYKWvHzu+71OHl?=
 =?us-ascii?Q?AdgPPxQQQ+eAgZ+MNBgIwuV4czq6eKXtWI1koMgzGfgkAmVyvvPPovVcgNsD?=
 =?us-ascii?Q?wVsJ4CKtiI0KCtDP20GuXS7ripxzPtrZOqMl0BMwbaBf/9s/+Pnb0USzYD7Y?=
 =?us-ascii?Q?srg7EJ12jHeeYBaTgYXwSMtozDQPOzu0NAd4QGX0uvP2juzvktiMB4lUcuhr?=
 =?us-ascii?Q?jNn+IkQ3PvlY9/FssWaAVo10K+yPmKhSJhtCetWIb8fHzu5BeeS1B6P9CO05?=
 =?us-ascii?Q?LV1uf7eWXPRR/jP8bwvB9um82mkpfG/Nn2bsG4BW2H2wkSBaZmR14MpiKogD?=
 =?us-ascii?Q?k6hOqo6lJLyKznX88AvQg5U90Pbjo6OfP9zwkBeIrJvG7vpMey1bN+L8SPvF?=
 =?us-ascii?Q?VqPsJb6BgDGoE60+aqmM79OJ28YRITOCqzziXQmGiKPo9wGo4MhjD1O9ofQu?=
 =?us-ascii?Q?ZqG1d41AGlXgg4LOCtibf9H9pplf68jGV/IEoGzSYkQCvmWVXjNjrTc3t8yY?=
 =?us-ascii?Q?pUB/Uft5TiRUK6Fww7Y1K36koRJtgJymn1QtNXZXIp2BVOZBKM5QqSTw+zb5?=
 =?us-ascii?Q?Op6oSuCe39jHBkyXMYvYltNkbLyffeUuJVHNxyxHx10EtDFPnIJQjleAE1ou?=
 =?us-ascii?Q?w6q6VVCW30gtm/cBdXWR2atlp9VMbMtTMeuWAfRwYHy1o597tO2Z1uRxRcRQ?=
 =?us-ascii?Q?awy2GxAmK5MXtUATvoBO7/RcXwL8F3CerxSL7seqO0KJiKVf12XpzpOqq16r?=
 =?us-ascii?Q?IU42vpy/CJbYfCUjQkrR7kUIejFzNtDHXv2W1Nw3UQ/34wUoa8MNwW3QhNrJ?=
 =?us-ascii?Q?ixMpsxj3WTyfK2JDhbapLwYv4Tu+lahqX1Z7Zguk9XQQrTika9/1rjcQ0VEo?=
 =?us-ascii?Q?A8QU6iF7Hn83lnuVZkESxmcc7O/BFtMApUhWpBer?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08705c30-20ee-4777-18ae-08dde19e803c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 17:08:23.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kwMVjIaEj0KQ7EYc/W3e3ebUB9iTMvbhdzegC+OGlStq90Bja067MqmsA6f6gti
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6845
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3715814000B
X-Stat-Signature: 9393hem4sd7fh65hap494acyj6ukeag1
X-HE-Tag: 1755882505-754011
X-HE-Meta: U2FsdGVkX1+3mc0LM36JTpFJHn1yJTOwaEXZYrZ/vAjGmtxUsMlz3gKbo6jXCwYZliuB/NNVXywHJDSNKotnkCMyoFSDAZ9zsVSWjCr1ZrB1YmoK1mgJegC4Eg+M05HuCfAeO7WKJV7ySCkGpvt735J9dGd6dmnrR8cf4np2kjOB2KfORknJS3otSg/o16/vO4I2ap7FfjC/TZin16mWBq6TuV9lHOL746z/krVQ9wQ+tp0sPq7N3nwm1Nff68KlzkpZemSZhjfKDQNpM/7j3Fi8/Rh6oqH1NjYcgA9/37PnreSeJY1Wu8Zo01BEDasd9y9h7SUgd9iEZf8fx69GNVShxDXMXJppDGEoUF9SeKfWyiPKLmaW6KG35BHaSx4UCXLlSf/LHSt8xAzM3P3gjhZGKlA2o3N95pzCVDjw2BoSjRYrZDEF+Ol7YYnGfqGu9TxuqFwvjwpEGZu3UqrG1fchgk1QRlt+CbpvET4jZq6uOVpIZslDS5R9DV8MRVYavAjG74snici+9EJNAJUgXnaVp1yJXuR3Yqktopa8UPgnH7jfz5JM20UDL9NpQUNdYeUsKw4eNpbxS+ch5IpzzuU0j51CYPNrQ1OHLpXaBg6N7ImQpXad0hDwUeUnHIbzAz5DYqDY0bbPd8cJSt7ZsjnIBSBIfkEAfFJKBtEEc3aVncSMe8zFptClYlXFg1BxelPI3nUO0hJG66NpYXsdkuCTgHXf7L115NLUWFJzjHMLdD9dHOq0fPGMLmEPGoyHLm0EapTJM3MGVKtidTI0swuXlw9cBMdjyBz3ec+YlQdxEptcegwBJvX1yuA/7qyw3kSfJk2U5SWTTnLYiQLenveYk9nLEcYWFqiraGwtgZ7o/mg9Y60w7i/0V+Jl2QJ9jJaFei00wXiyI+cEPq69KqMNDRFiHWEiy6nodf2pxkn4gyQjzCvIKhI7jpPgNMyKggBiOXGu2wr3ZGN0q5S
 jbQeJMus
 dSWZ5I5BdqDIGvjjSiWCPwUWDUsyxL+yT1o2p3s2Te4sAssqUZtKmbEoVAaI9EhHI2EWQi9fJDwyCApEmAHr87F+FnWIfqVpzAZ0I37rh1lD7/JE+JFkNmJRpF2TaVCUKhC/Meqd28ySVn6n39u6xfF/AhndHquj+MLjF92k7GBJn6Wt5b3NMv2bq2i1kx60Y8BmtIJpR4h2mk0YdpCEN8SpGv/Zukk0m4jRZ6f/1d/CYrtHTGjASV9AXSKcG02xMcG+pabVhv8+6hOGiNZqe0Fxfq1sC1Ha24gNl0+TNdFt6rqNpRSUtw5O7lxKLClQhaD7c8E0mMmYLbCGpd4sKCwUFRVyg1Toz0iWWA1LfQpn8LNc9LYFjPE4NYbOV28ZA3VCLFPESo4XpTXAC7P2RwyOKsHFxWCHq6bQMQr3haX++M3W2hurnnssNlZkbmbotk3iHK01TYZDO2Yy6ATCcvuoioF+IXpxPbv92DtlhJPHRttPgwq+uSbOfUt+kzu6xuFPt57HPkgR34x9gA5E+z5RGqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Aug 2025, at 4:20, Muhammad Usama Anjum wrote:

> Enable -Wunreachable-code flag to catch dead code and fix them.
>
> 1. Remove the dead code and write a comment instead:
> hmm-tests.c:2033:3: warning: code will never be executed
> [-Wunreachable-code]
>                 perror("Should not reach this\n");
>                 ^~~~~~
>
> 2. ksft_exit_fail_msg() calls exit(). Remove the dead code.
> split_huge_page_test.c:301:3: warning: code will never be executed
> [-Wunreachable-code]
>                 goto cleanup;
>                 ^~~~~~~~~~~~
>
> 3. Remove duplicate inline.
> pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
> specifier [-Wduplicate-decl-specifier]
> static inline __always_inline
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes since v2:
> - In split_huge_page_test.c, print error message and then go to cleanup
>   tag for cleanup instead of just exiting without cleanup
> ---
>  tools/testing/selftests/mm/Makefile                | 1 +
>  tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
>  tools/testing/selftests/mm/split_huge_page_test.c  | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi


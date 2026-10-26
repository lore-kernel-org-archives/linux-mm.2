Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0C2606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nEX5J9/P
Received: by kanga.kvack.org (Postfix)
	id A666E6B05B0; Mon, 26 Oct 2026 15:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CF86B05B1; Mon, 26 Oct 2026 15:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CFE6B05B2; Mon, 26 Oct 2026 15:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6505D6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:07:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CC96A07D7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:07:34 +0000 (UTC)
X-FDA: 85365711228.26.1241527
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012063.outbound.protection.outlook.com [52.101.43.63])
	by imf17.hostedemail.com (Postfix) with ESMTP id 41FFF40003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:07:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nEX5J9/P";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793041651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIdEvAhvD72pVilhcWiVsqONnHhA17ggokD6xusTGsw=;
	b=vhxFsxLMjIQ4hzEZDocYuw9XkXyYEFerrq7mQUyEnQWQBI+SgA03rz+WsVtlSEQ3WInXYw
	xTZnFkCdVlRmWbzoMjw2YwavaHWK6q28e1ekKbxSLEX72LfFrD1LJP75GpmhnvJDr1WXbs
	w0kcrG14ltHt1m3nbteKWseToE7jbLw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793041651;
	b=q1dXzEfIYb9oVS0S4x0eJ1qrm7fndEOZeuW03Buz2OPlIPax1hBTG8lOuu0FLZGG5WTgO/
	QVo7mjf52aFaohr+kBgfjv7LKXKfqfeHfWlVsnu9S8ZzTmBw3TDVJZ465Bzz+/wf7X5yUZ
	S+dkw9Tej/seED8YQhYCQGCuPfNcn+w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="nEX5J9/P";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDYNy2DiG0Fy8D44FZqw4BhIjEjTfV95rXkFzjpA8JQVZ6ODFPdf+ik59MvyISiLhJjERo+ljGIBnWE/2BBuoszmnXSeCFg+KKfZoHeHLYn3v20St7ZefUEIs2lfehoS4mlfO+EduonVxjr9c1EpRwN8AXQz0KrcFuwJnW+LVztDBv56DxPHvHwi0ovoG0i4mXVfaXcSUJdU5gE8H+Ztsd9SUqRafZtWBU8qaBAv1d5NOVINL+l8r34vRtLvluRZ7GeP1Q+QShPNXe148N3gVe+VuftixUYovCnJVKaEn1rtB7XqJidJ/LJsQlVF4QMQXYmUt06xDlPbqua9YUlmnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIdEvAhvD72pVilhcWiVsqONnHhA17ggokD6xusTGsw=;
 b=yviIAFs1PmQklQ0Z/d4MpXzdMnsReMrtQN5NzwGdGrXEzW+l+vqUVOGCx7JcQxGxZ5RBeqdZIb73l6Ei6ErqxsVTGOwLnpEAiFy69J50CCJTHqogp3GEIcR7LhKlUcEjeii8GvX9RIsWcPuiqI7liLlCPknaWrDeUEgPuTWXRU19KLEtn1uUu/PbYOs43xfEmAGpSaDKFAMN9a6w30K1H2VAH01a2O4cVhFHB8KESNDQWQdQqGgtLDRkzMldzpeXGyscQu32JlastvKZAcuc4lu8+QCswY4lPs1XL0aXg/CEbQfpftKQMC38BXuQwDUc6AZzzPbI6EyA4gBi0SfXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIdEvAhvD72pVilhcWiVsqONnHhA17ggokD6xusTGsw=;
 b=nEX5J9/PQBH7iU4UpAYqfBn5s6Nbsvt0xPzhhGHMjql3X1H/OouzSuMAmbcNjhA2S5E/7ivnt86jQVBCgzvowlmMAgwNU+stj/oyPeDWhJK2IYM74qZwf5o1z5Eg1L1aR+c8jNPj2QeKLfuYzij7obWR7jyC9bm45gYwZRo9FmokaV1zfh80C0FZeaUauXfcgcuj2mTd5xIM7I8ZnqlSWKiThXZFCR4t/rrFwuKuUbMgcJo7lN1SbmcewOt5GB5tfueFL6CHOYPeum0cuYHVJ8NDP6egDRdFmS+OSTtr9zbfDjx6eZxQThg731JXOy3UDNTbcG6D+7Q/D2izsD89Kg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAAPR12MB676730.namprd12.prod.outlook.com (2603:10b6:802:301::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 19:07:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 19:07:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH 04/16] mm/shmem: honour F_SEAL_EXEC when an ACL is set
Date: Mon, 26 Oct 2026 15:07:22 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <695BF4CC-9285-45C3-93CC-9DB8F7DAC962@nvidia.com>
In-Reply-To: <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0396.namprd03.prod.outlook.com
 (2603:10b6:408:111::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAAPR12MB676730:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ca30312-9ba5-4430-7045-08df33945f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|6133799003|10067099003|22082099003|18002099003|56012099006|4143699003|11063799006|261021123027099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	jFQEInD64OpSx/3ZaZRya2q9IABCPqvWJk3v+g1OwnYr3U0oSZnJWKzOMIUKmOr97/PDX4b/teT9eeGfzVOwaa/51Rbg0LOkwFjU+7OvcRgRhjem+YHlP+Oi4iZ3sj2byyXLj4EpHQmiHqyAZXVf9ASy6NgahQfo3wKrgFW5gkPBUmR1rY3vT7/VD2EJnxqt0J/FmZOJEEzpZ/7e0lHpffVUbDtIf6/eL/JfXfm/xwBLawhnYSH6wx+HPLaV8JHJzDuQVvatcYbTdDASBilVDzyo3rG73OJseufG+nRRZ/OzJJnZnueQCJxGm721y67B1Zmk3IxZsH2mHx+yYEUyUg3w+vTQHQP2nrkohPZUquRvul9pbQ66dgPYDwcQckISQBUQWMwlVGVQelp9Ni8A14Cpb4wOyjJ53/vh1gjq1H76XxuEHQRBSe8j3435j9z8BAZyEqKqxczbJnaS4QeVlWQBw4C0VidZYoAXkhN4rKTnH4Ex86j8Yq3iK74KCxoRqK9aLImHOumZslIDFe6Z/IWtW7MEB3VKobBj2IDZEz8PNHuCagly+Wnf4Vubjwf2qEVbI7yATQFDtGJIu9FBah6iO5N3CSnUriaBPwetOnta7rdgfG/j9FQdhLRpAbdNMVCEXxvskdKZx4zBkJmqxQRDQuz5Qyj1AuXMJwOd3Rk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zcxPKuH0x295fzAFi9aqG80I4XPESCx68j8gyOBu/LB5PMWr3layVcwUYKNU?=
 =?us-ascii?Q?bsKd7c7BVMkkOwqdseRWH2LIVeOki+V/9yEKechr38w4gIPPhFr2h+J/ylUu?=
 =?us-ascii?Q?geAOqVq2b3iRnCqeOj7aBaVyBM7kZGusaGyj0ClaZMSAvFnSrxKIZ72fWwKi?=
 =?us-ascii?Q?XILa918ly5rzTItI00y6H+1fYY5z+Dry3kry5iNI6hww3lU+RY6xMhiABpax?=
 =?us-ascii?Q?8fncGLvbAkWfLt6dohNbwhRUNXtT6O542TUswrYZYKFyVkMyxZCYQTEhhQYx?=
 =?us-ascii?Q?71a+6t2mIZKRT8SNUj2jyqNcnbTMtwUa1Z+IROHiU2GgWCoyS5FVSjxH+WWM?=
 =?us-ascii?Q?o44ydeWO8yowCjbkgIPkqy72ZXiR5NwBqUwF8pzprr0vaCT4/7zWR1yY9Ynw?=
 =?us-ascii?Q?RaxyH8cA8p3xoRBfwoZc27lc8WY6fg2cnMc2k2ltKJ0CtHKSKhWWmucHNKL4?=
 =?us-ascii?Q?BBxG4NxkNKC4xq3XX1qq3AEgtx7dpBC1Z9si7Ri/FufHdt+7Pb06xT+Fq8ho?=
 =?us-ascii?Q?N0O+4G2t8Y0JahJ1VB4AKckocl3fhN89/9k7EXHOetHFKbT09HEfBwixWvF8?=
 =?us-ascii?Q?hN7Tcf/30s6V0CjEqKQ6pB1+P8S2Zl48Y1GV228VRFjecl3zshhGEDMALA4C?=
 =?us-ascii?Q?hK+46jjS6LkW5clhPNOcSCOiI1CSMhJDMbJGBWzEhGnnE7Jb7jumai8XTBI3?=
 =?us-ascii?Q?4KHujRYkZ9uXK0JII7QcD4XraeGyZf9/KW60teU3sW/K14Ti9aIdrYXmzwea?=
 =?us-ascii?Q?n3dZC9I5NQh1sp1gDI/A1Sa+pNLuFqMuol63jBa3dqyhIJeRC9wS08OBmwmd?=
 =?us-ascii?Q?MZHirzx0BZJUNEhB4zC50z7UW/Ok0EFfV1kd8x5BSNQvq3osLPF8eH9lpm1a?=
 =?us-ascii?Q?Yg94Os9JfSyo3K/k0JmiW+SO3+M7mKezBEZ1bfSmEQBVd44JGaX62XHT9aw3?=
 =?us-ascii?Q?zojiGuCjVnHTA/sqgstXCtmAZpkG5meDhHD0jTx8CajNeJqfYRnsnh7kUOnK?=
 =?us-ascii?Q?9ciCxgkY9ooMF9QLpauoh6uXrdovXb6XL/74OFfBv7pQS1q061zqz2hSwC1X?=
 =?us-ascii?Q?ygsl0x1ja1aGz+VZFMf+fVndc10M6jTkrpC/vFgo858syVImBMafFG5vIT/b?=
 =?us-ascii?Q?s1RGP8IM+ZaD/pGjP4SOU3e4vSZrdMxEmBQIP5gHTJwvsYpm1puXfEyl24SA?=
 =?us-ascii?Q?6TWstelud+ObQu7rdw8X81HHHC6YRCCBQilioIeRjWmyK6ckvLN/Vsa8geUb?=
 =?us-ascii?Q?P9qFEP4wpTrUWyHFLx0QfQFLs5c9IA2qkF2KVNYjgr7J/kb1mqalY2XVU2bF?=
 =?us-ascii?Q?EpsWroIMi/hBhVPWcGr7aAJQqPlxC2uxEvGjOVueuRP354df9MZaH2Gohnqq?=
 =?us-ascii?Q?G9XOKatcaRNgFlMSHEMyFpt3JDx5qyXO/bcu7oVE1LtAkYcd4MQL7tyJ3jXk?=
 =?us-ascii?Q?Rw/YHxLa8a+junagwgyUXF0vsSlmZvugU354KEtE3ZGmMNPx4HtXhxaNiIIQ?=
 =?us-ascii?Q?X/Sf72q+mwx+wbgWrG4vkaNfxAlU/9HnIK6R1sIzuTx3Z9ZRKWJ3ISrfTsxK?=
 =?us-ascii?Q?SxjCIMIFecgPVTFQqGHorwKdRPqB3/dVBEl6IpEURH0bu7E9+IuTUG1hSwuk?=
 =?us-ascii?Q?e4S43Qi3BClmFRt8SEKIXCzPpB3OIP+UgjsCrjgmPUXsS+xS/hGQvBmXFG/U?=
 =?us-ascii?Q?cF9i64n7BzD2BfeDsnVnZ1Mgwos473xs2QjYoAU29Xz/jKMp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca30312-9ba5-4430-7045-08df33945f0d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 19:07:25.4415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OIHSxhPUWskJyeFA7Qn/ES/LrUOus4DalOi8gY9yW3GeKNgEoaWZYYiUGYOwGSJ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAAPR12MB676730
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41FFF40003
X-Stat-Signature: rtp9w331ng5oozsqebn9yi64ahdoakbo
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793041651-52537
X-HE-Meta: U2FsdGVkX19TxisS5TBJbEfxTmJ7V9LvzkIXqoOINNEaT8RVmHez4T7wDWWBcXizmxMz6usILII+tgpUGLIrEkeEdhf0iynxFBtSL/YUrVcn1/UgoQ0JPshtmfq+GIeWeEpMoDCmPmf7YGeFGLcdbGH19HHO8sxYklKmiOjsJANixJmot0sBKiL43y8NzkstwRPPZHTOSyTgu6/kkuVBO98UBBcy7TtMpY5c8BP3CDSqaGWrpYm8KCBmHVJt1DWB8s/SR8u/dVoWbNSdAYK86R2Ttg+u9X1D0xY8Lmvc5gB/t7dJhR3PsnwFl3iRFuux4M/0tj1NHAzRAquR79P/wyRzkfdYhbyaID04lmB999LpfaZYuy2CW5kP0ymwLyWp1NUz6b0P+sm6yGn2VLF9AeAe08TfC6GHD/jauKMM+He/wAN/pwjYulrp2wfWV42p3dvd6kEwmzx5dOGlur4YssEZwOfulx/1W2Q/PRKiiyGlnrY5NObCgKIS+QvUS6AdVrr5p6bzRueRdBZI1PutiYKYq1wXZdRUKfFvp6lY7pkKdM7A6ZAYK+dOdZOMHYzIxO5/fQrdN1DJnaZkfp/sxK5ywL1xxvzYGD4qxLTG8uLuPp2r+yLNeZ4UOu4iZe+/r1cP0zUN8SvgbZuUUJJKVL/S35KqYdgxZ5O19CeGNdfTLcjdVoOOYLrB2HR0nCDLuCHPRKEGjbZdXMzHG10K74yhGycXGzMxu71o87ICsbLVSPlf7TJCZHGvMO9SRXzqllC1xRRZg5o4cEUx9O9hmbAzJHPigG19MYaWlslJUlNE4JK1qK6L1ltpgImw6W9dzV26tlttWVHKZADbY8ZMLtUgzxemLBQf1yjZhq5p2jO/MLvxKI76q6R6UhSdb4sU0HIyv+3HY5MApV5DG85epQsawmP8WmZV/Z6aWk48WuGsW0KA7DtX/TmLa8Kydhz788dbOlDJQWdjRN5Wy3F
 kNYWdAf9
 I2psiIWsQXpzQybtd6WMPTj99QJPzkJ66zygES1FRpgdisjgfzBNpBLj7nuTPBdUrwbIHUocyWHNcwO5X189ufuT0mjiDS5i6z9YjHNbZIDRQyvbAWOlaTDd/Nt6Iz9kHbC5stA2bngev0V+vbS2wMQDNRvmMIu6FVbgUAAlwDFM8KCAMcITi21cIT4N8y85S1Qn3RsE4Dp6v3ehL6WeAUewAJKaPxXJH08B4ey47af6zopInhAjjiSVdKND31KMaavm6UCEq07jqFLfEhDzbq4YpI7MufAJOl1qUhvsSPSA3JnCx37DVbI62ZXxNA8VibNLB9eqjrccvMRVTzdgh1zgJxSdbWcCbGOEXU4Sivn+vet1srosPUn+fRJ6PAp1GFmOXSsZMB4/xIF9Kxc5SAPuvs3F6TkBfTJ523HPIOL/xSbfWMAL5YJ9kv2pHBEXqcE7GMofGJUznl/hgoF8WJmkj2+iRvLY37XbsY17RG9IM8puBuYpQ2HRbCSOeZFuByB+3i7/NFF9SQKNM0pot94k5AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 5:40, David Hildenbrand (Arm) wrote:

> From: Chris Mason <mason@kernel.org>
>
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
>
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/memfd.h |  9 +++++++++
>  mm/shmem.c            | 35 ++++++++++++++++++++++++++++++-----
>  2 files changed, 39 insertions(+), 5 deletions(-)
>

The changes make sense to me.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


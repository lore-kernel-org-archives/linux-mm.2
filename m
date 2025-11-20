Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F07B9CF64B0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524CA6B002B; Wed, 19 Nov 2025 23:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5516B002C; Wed, 19 Nov 2025 23:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CAE6B002D; Wed, 19 Nov 2025 23:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23BB16B002B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:01:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E040AC06C3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:01:50 +0000 (UTC)
X-FDA: 84129636780.07.DECAAC2
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16F1F18000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:01:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H6ydHM5z;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763611308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Np4ruUkAOxSab3WqC2zsg2Qr4QnikyRbnlkA7XAXtIA=;
	b=n38fe7nQK+VL9Hwu5RycMlmNAUZ2AA2VRNIFaERY1TlUYOhieHflBA0qyEsLZKwkv3kCI5
	Gm2JeT6jyYGcq35LUyqFUe7XgInGnLodoW7LRv1erSisLvHL4icGqsSOri1yTz69kASl46
	wVjA80PdMSs9SdrUL0+0WSLxHmCp7kM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H6ydHM5z;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763611308; a=rsa-sha256;
	cv=pass;
	b=6NmMlC0vfpjasNfaJihn6PHjMevaZiVZ5hR+qE06i3jvJqAjFtRrZWtHDcZ4fPv+7Tqq5/
	aMLrJWUI0n4E5o0KVzFbjJI5TDLclIBgpj5g3tUo8fOQ/4OsvQm1rQp/grrwiaNOWIynil
	fKA2X9tcOy+/uj+mCJeyUawKBfu7kqY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEYLTTMHelvvI1bh1WYRAtCo9a1YXYsbzgJQlawpj25wmcFxbkgFj14RWjxTiiVxfXMD7LTsvYxj8wnNNy/u9z23FFbAyxVkmgTAJcQRTESqpv8DLyGVHRDIVOgSzYpxXK2IM5/wBJSq75zCpOIPGzjZ20Q4DIpzIb2uf1BJz2RhRy3Y0X9g2q38IHmEUDbUaidxVIovsFMUrDO4Ug5rSv/bVHvK8WjWmEFo6yVZ9JJb+CkywLeNPR8RrC02OuitH4Ezo2AAVOzt1cKG8Qog9qlzm9ObMlXnyhwi0lW1k0hP31FPi2snREn98O9QPd9RLZuW+w6qYbXnYRbt5cyNDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Np4ruUkAOxSab3WqC2zsg2Qr4QnikyRbnlkA7XAXtIA=;
 b=snZyNezQEZaftOp/hsADZoKx8C9IQMvAZyeC5gqdHgeZp1qc5nkgTVKtfkV98nqWiSR7QtEGh8zxsFaQlaCU5GtvI07Rfh7tFevc85Gsf5CXj6lTmU/oPrtd5Y5J6PHZR46SArWZGwM9YbxIMTgNaKDMdW0HToyMqz3Kb+6yXhYjsZ/vy9wqKsRPVeXPcsQctx8uXwetqbxsyu3252eV+4rf3A5C+GICNhmEZpQ+GHusrpjnNJO1C5jw0K2c+Sbwp1WJWVjXINj9Y+JpqEsTEq+Dob7Rt/NG7a3IfhhyyBK5TFmjUPoL5vWbfCACNVjLb6my3UrSxyRcTYnMSdjtnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np4ruUkAOxSab3WqC2zsg2Qr4QnikyRbnlkA7XAXtIA=;
 b=H6ydHM5zJ7VwVy162hR9/SiUiRe7V3KTHKRue2dAIlVtOP6bD2ugEDF5+HgSsaI+JVNdIH4rBxwkVZrzcX24bkDXefnoLTZ8g+atl0eN2/A6S7fB0PShpvzGz8jtG3xbu7pxxFLOxk4NmhwNAAdzxLa/DHELfazgKry2ZoUoIexcIuuCtKKivP/vg/3lkFkmXapE6HiDekaFsEMXaIDZxWMzShYD17Y9P3La3cp5apjxGX702X8PzoJSbkHf8buBm7Jm4LX+DYfvgbVJmvkizDJhb8hR96TqTys6UGr3QFuKGA6B4GthWPrFu7KUUVF+G5iogHbj2dUse00iWEMdWQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7914.namprd12.prod.outlook.com (2603:10b6:510:27d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 04:00:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:00:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference in try_folio_split_to_order()
Date: Wed, 19 Nov 2025 22:59:51 -0500
Message-ID: <20251120035953.1115736-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120035953.1115736-1-ziy@nvidia.com>
References: <20251120035953.1115736-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0093.namprd02.prod.outlook.com
 (2603:10b6:208:51::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a82ddb-033f-4072-52e8-08de27e948ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4NsJnLqzVI14qQtxTYyhdRQgNsXfDo2lBqEXwWm9dowfMALC8Vob5UMvvTAW?=
 =?us-ascii?Q?/mq2KtNU8JYjPTih5fzs+r9Aez0esqTP0RAOErYpkUTTjiN+xV7/sD1XXrFV?=
 =?us-ascii?Q?y2kM9++q4P43ltKsS5nSBMTV3zHKRj8EHPF2iEBKAXHV5tNLpa9rn7e+ENqc?=
 =?us-ascii?Q?TH5IGC8EwhYBP0nmESbMFjT4byry6MyZ2j9Qi9JPlN/ddTObxu3bOQp8lxaU?=
 =?us-ascii?Q?xK3Xp88FfcjxSgu1eeT7TmJ9p0WhA/xrFimcnqkSt3nFARw7mLBWYqppZRhL?=
 =?us-ascii?Q?3Z4dU3u5LTUA8EyN9gpNWFtH3MJBN0u3e29FlLYmLQvtEJB2RMz6aEGvv7Gl?=
 =?us-ascii?Q?tfHC+72e5jzrF11aEEYVqN2+cA6cYi80zwIS4h5XrjkQ58V86J7U2Cy20BfQ?=
 =?us-ascii?Q?P/RnF/96MWdOC8HizCz1mN2VN3MRJ0IQRM+Nccrw9eO1ZeUwgXOnk5z+qvWe?=
 =?us-ascii?Q?JTu8XO13PoEcyHKDJ/sncZ/XK1kxBvu/5JHh26EKhthbZOKSaRIK/Zfd1idj?=
 =?us-ascii?Q?y7Rjt8P+NjOpKJv3Hrf376E+LGuN0DhXB5aPnLFZANKR13CzjmkeiAKhrdGW?=
 =?us-ascii?Q?G2Jf7dND3ZcfEsAK52ModcKnno/u4MAKj0DeGu0Yki0+SH1Vqok6T9i0gTnS?=
 =?us-ascii?Q?H+FE7pNOJTC13lwwKjh2Xl0Zx3tbFGS1U8VwbOnZBOl7lhdk6EuZso5dsl4Q?=
 =?us-ascii?Q?wiGznvh9SnfD/b9bQiCXyNwx9it/rTOJHO9XRtDb41AQJXBTlMyq9syU84Qo?=
 =?us-ascii?Q?VBtj34kJdojBNb1UFg+E9YuydZyIsL/kkPJ1HtOsFip90Qo1Bfszf/Mi14ew?=
 =?us-ascii?Q?5qqW2EryNhVgP3BwlIr2NIFTW3J6tKfqbcWEaW7U23CdAQqg5NRpGHrqusRW?=
 =?us-ascii?Q?6sR80OULienAs0mxEw/HSksBptBOedSSs1xVgWR3zVD2/JC7t90XnTOWIi+W?=
 =?us-ascii?Q?tVeWKrU/+6kqab27jHQ53dT0/v+jwcyyBUKrHNQsxBdQBE6tJ+lp/DwnyGSW?=
 =?us-ascii?Q?2ZA9RSE+rkmCojOxIdylfYmZXT4zv7JidcYkBQR7XNaU+IwGvJeadBtueOKk?=
 =?us-ascii?Q?uij5IvSX34vp+pULQpzuo7WxCDZZctHlL7Y5CPgPunpyRo2v8e5Flgy7F4HZ?=
 =?us-ascii?Q?1ZJ0FutJ0lhWKmoJ/hIB0ztZv3mmKoIcDRvT1duYePc5A3/V+8AIWuPYNdsj?=
 =?us-ascii?Q?uB4oUKuMTReHktPI4UDLcFWrRMeRRdCxhkqnq5YjB9ctBzRR4336dYadHnbg?=
 =?us-ascii?Q?PPpFkPOcaYY2o1EQgPzQ4b5z71D4e1NNsH1FuU+IFQIWIZUV6YawgRM3ti1p?=
 =?us-ascii?Q?FykbxGcNniJfgm33PY8YxxkxOy+8cUQKKezo84OO3u7k3O4DszSYivJQ5sRQ?=
 =?us-ascii?Q?ZcM7iqbBMDHy4gQOARDcy9ZkAO12mqFirjkHtv6vqEDRYl2XEOTzQZtwNxoX?=
 =?us-ascii?Q?mBbzko41xQBYzzI2Lw18uuw0cD+pwP1h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?++o7LHW3dVKGDxbdNdAxYLxtWluEq4gEeIbq32VCKPQtYNJkUtoKysEmXgk0?=
 =?us-ascii?Q?B2t5eUvB2OSNyq37pgV0b0EejQ0E8w7eslQB2qBCibR5op77TddZKroP7mUe?=
 =?us-ascii?Q?LzsNakFqgjYxqZ9JmEyCPAL7U2H6ku/jYEigrk5US+BGZeE3ZA5YLGgKIAGE?=
 =?us-ascii?Q?qP2DV+uWbHTIpSRv55KLeAoZXwEvkY1o/xeZ3Dl5M4OzBoSj9aSksT8Xbytv?=
 =?us-ascii?Q?r8GK/72oWt/CRXrUmv5ypdSOkO/28n7dIQaSpkKzqFQEcN6Ymp84B8OnLbyw?=
 =?us-ascii?Q?oLNcBjX6SnPNgv96RwXJd45H3Rwmz6/YiV7UwrUk5OOX3yauSWo9KpDStNc7?=
 =?us-ascii?Q?w2upbb6nPmr7K/0vVnTKbEYyQGHxAEUwmuSzp51Du4L/0jSb/k4HfxBqb7h1?=
 =?us-ascii?Q?NxH7yqPy8+27iN61+wqt9ndYv8/HOoLXJXsoxBss/QnYwShu2CBNpasLLGnS?=
 =?us-ascii?Q?pX5ddqVgU4FtdJKtvZHvMRMiB3WcrarK6ANvDfVSAcbB/C0mZ0h7UifAp6W1?=
 =?us-ascii?Q?qjJCWI8c/lp05o0IGumzPcpR8pz2mxjZl/ayEzAWwv4g6iwmSQvQc31NwPLf?=
 =?us-ascii?Q?o9FE3i7aWqajpXeqQYajnCKNyPp1WvW4EJuomry8xPXbqJWtmyV0Ohl/4Pf6?=
 =?us-ascii?Q?6EA+zJYq43aWgwYjaPMm5TGCdq8dbDjhEQaNvzK59TtEqwmi0mfofUM2m46r?=
 =?us-ascii?Q?VxrydeIswvLYUmsocX9+xROT6w4iqd+w0AG2EGScRtyD609zasi2SLkz3uFU?=
 =?us-ascii?Q?RidWzY+ix0MCqelgmrA8OW6gBPS2ZzeJLDp0wEagI/Vl7BJh2nstOkHaFah6?=
 =?us-ascii?Q?rvLLxVTWVQN5R5sN9/WCr1aHyJ2nU1GMdI8FUE9hnqneS57N8E+LxkF/bZBS?=
 =?us-ascii?Q?bB1Z8osKBuzNRWktz217ufPrpKZtHtaZAQ7O94Ju/TE/RUs4vgtxfQjj8JPf?=
 =?us-ascii?Q?4yzn+WHEzjA//9NmTqofZv1RJvgyXdwZRsTg4fpFrG8BCRdVeKq8qA+BLeJs?=
 =?us-ascii?Q?DVSzIcwBvq7+kQesSrrdQCarA+xKpHs9iE2zdw+vuzOkwwmmV7IzwLs9s5nB?=
 =?us-ascii?Q?8PkH9cHKZ63YdP1hzwyHsQRsKEMAnpQzFzxpLHulFAA/q4loieQ7qKvL9smO?=
 =?us-ascii?Q?N3Z8LK6KyE31+VxaPr5YTMdUyRFTLWhWPME6RJhydaZd1Ev6DUmmONQ72FeZ?=
 =?us-ascii?Q?Y13oHsWGabs+0X6SrnsePvlzWPpTlpXXit/oNz97WQh4ssDMwUbVp97C7q0S?=
 =?us-ascii?Q?/y0Ny5Tw0/RxRvBoDWZJErRY2ZQkXk2oWV2ZV9KLQJoRm4jXxnGiRlC5PS/i?=
 =?us-ascii?Q?KMBEgM9ltKMfTYUTgikqCmInyKoxQg03Znd9q1T5FsL5niGSAmkNLc09ebL2?=
 =?us-ascii?Q?1+nSPWTZewl/WT6Wicj8G3cXPkTgaEuVWkfc6+8NFsdigjHkc1ryY7rRQbG0?=
 =?us-ascii?Q?UMwdFUPJIOYAvZS0DazOH6EFHm416Of8SerNebLquj5ScAgxsnYfmAkzlSyB?=
 =?us-ascii?Q?VRUyI12AeEp+p8s5Djatz+R8okEKxKRY4DnvFx0CQHUe+uWkZIGNi5thBf7v?=
 =?us-ascii?Q?aEf9I56trnfQ1v3S5ACiNZHdeThEmlEY5UNmZXyZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a82ddb-033f-4072-52e8-08de27e948ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:00:03.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW2QhKZX1A6WuOrc14gfP5UeULa9/hezUAa1fCxmwY5IVn+XqpBaIkRfX/bn8oFY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7914
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16F1F18000B
X-Stat-Signature: 8sasj9jpeiafrwugqo89yzm4quy56756
X-Rspam-User: 
X-HE-Tag: 1763611307-941341
X-HE-Meta: U2FsdGVkX1/d0+UPJLCf8KbnlQ4sEtveDQC2xQDa2srqdAFpXzAjnnEF/q36VBjnwVGvq+5TKdtNhxB5Fb5huvLL93Wf4vvZH0mC1H21CRL6JMs2WBk1qX92f4xcnd7J9MBgJgQ1///Rqu50ZJjrcItJLV/ydThlHetwuRrpy5Kvrzv8s27pXbmnO0Tll4QIPEEPIv8MM+aqZm1+0mrJU/uwKyq3m/QEhrFEqe1ojwvXN5bzOKSl01F/szzwUejrH3H4jlKlMT3PJnqWP6zjnRX3ZEF/Vq/BNy7OxmisX9CqcsYoDZe0+M4YAQ8NkcKJ1F8Zix9iXpjuXB/vXycbcRM3th864rqsW4AmfnR0gsX3i7OhNsjvj5yvIoug0pFLBHy64Dw/PXyGT8pZIzbqUgVxvRArleJy2ECnEP1NYURRejekMdRicEJOr/tLeYU2uQI4T8H/sQ+PB2n1YEzh9AP0fDyHgFXu8XbVhCJU7Jc4eb1GmU8XZM8mjHR22tsaAUkeJjKa9sv8Qu6TLIcbrzFi+h3mDzccXoQLSbU2byB27tLAdKyqS/WDFF1893CK4w1jIbaf+ZfEXwsWjDL10gUr5z4A48EuO67V4hDnaZa2c6V7zE4fJ9KrjvS+5AkI7djQGPhP6XQzmHdr8S4yJNuSVE3vIPP7+Vp8tpq17172pTUXMLwI6pNKkNDLCIVBukawW6PokJGwlsG1IZ+2EcnT6htF7kbzhs3o4IzV+hoZS3qbjQUyU5CXnv6OuO3yELQPgL9hB6+GC956ilo69VzV+JPcXJqs9z55rUnBhlpFPdWrH0yqMbkpnZwsEGAkU/rwEyM/1Tvb+gMUXv7pGp4FtLQ+cTvwXgmF+PmarV1l3XfIrHb60nmSf64GOVFdIMhNyeBdm4IHHGHqcqbAvD+/bcAICWooMmR6hR902dFESQ5j+1iLEKzgxzlYWzGYeYQJL5xnQ6AXt5oaG2l
 0YhUOmsW
 reDen+egifO1wAr7A21n7e/+230SXwKqjMYSjhgSpI6lkA/G1LBgxwAWXKCEm1ge5sj2TxN4KhwjcewpRVx+cWhXEbn+48QiH87JBDCgdJosjnmz8WLeeQxghlwYKJ//Ao4KqdcNQuPz1onWkNTLek69S6VAwKioprcl/fCzV+B6bQLgV9AxPxNSXWR6RFjER1GMFH4oEOJ0ixUkDZvR/BU4LklXw3STcHq6vmWtHrznA+zJJRGu59MNiiuuVr48tKt0bhx0gUj7shRQyKyC8pJoxgPr+LIrzUPxYtew0XK6A9ecezi0bxsD6we4yplcdEM9XNDZw+oY6atkNSx9Z2Dib+BOy3lP5yUVatl6+s2QBdonsb55pTIG6Q1ragwoWt/qLPxR+P2WkFMvERVlkdc3Mnd5nJQ7pkfOa6eh6AKPMYrskULfl4qByYHT78vpzKcHOWlOKWoi/sURS0o+UCuMQ5Uy4jQZSiasMum/Xm/4AFS9h9k0vGTKuefkIE9y2XsXH4HTTnMzL5Qj9X0CFcRASeVN2V7Mhqhyi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it. Add the check to prevent NULL pointer dereference.

There is no issue in the current code, since try_folio_split_to_order() is
only used in truncate_inode_partial_folio(), where folio->mapping is not
NULL.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1d439de1ca2c..0d55354e3a34 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 */
+	if (!folio_test_anon(folio) && !folio->mapping)
+		return -EBUSY;
+
 	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
-- 
2.51.0



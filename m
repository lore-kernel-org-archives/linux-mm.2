Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD71CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538596B00A1; Tue, 13 Oct 2026 08:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510296B00A2; Tue, 13 Oct 2026 08:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426076B00A3; Tue, 13 Oct 2026 08:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22EE06B00A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:22:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E5ED140B5E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:22:50 +0000 (UTC)
X-FDA: 85317516900.06.43022A8
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id D53082000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:22:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rNN0xJWg;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+wEt9RoxMstqYDfMgU/aZVdd2TgXoSCaXwYp6a3UlQ=;
	b=jbgWhec0ZamGZrMTvFsXXnpFno/IqZiRj0F9Gf0qxJgp3+spW4S5HmD4TQUN4vBIdMkOFG
	XK6yFnyQ2VOL4OGbJIvhZ3mYHJE0BP4Pdy5XHEa3hdXHDQH9Ku3jV7qEriUGRrUm/cAi6j
	v2Qlonleqbx3idz0nLNCNG+L7DBHGbw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791894168;
	b=3s5U39ypf8I6qum7vmKW8UE07eOj/dYqx8YJajZKZCpOGYPTqvOjo6fgkkvsLndh58KsCR
	l1tGf94X7jUyvYKydFpVGarJwdP6X4FvAcC7WFBAvsKywBEgcQ+qd0SAl9E+En7b9/R/PL
	LfDMuAAu7hJQkoKPOYrR92iv/z8fPyI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rNN0xJWg;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGxUkAS47x+/e+PjS6JgKUvxhH78KkSGLH2TVT4j6lrt3nafrF0DhBIPdCwgkAmVTzIxre4s0mK8wOsCnwL3R/qPANjMGeMWHjY1rDV4DSDZjwhrXPFYHcx1jh32lsVAmR+vJVScHBnq7ctGRcMt8atqoFaX/buwA3vWDJRT/FJqCwmWB3/A4HlHTyMsv10zDYM5pqZ6UHAGDrAan6WWFbJ+MK8OqApzjDQDSbfpqHpgHZq7bHef1yASY30y9uNGYXPEVDoe9/I7fvc8bi+5MwPdWk+GsqdCB2xkLtLsFQw5sBcsyB8CbgUJg3Q52qAKXIHknli64J2My0x5J0dTjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+wEt9RoxMstqYDfMgU/aZVdd2TgXoSCaXwYp6a3UlQ=;
 b=TAeGp3qN2gMrQDZbrrg0lLrsW17EGzFgEElQMlciShGRASuAws/d/YPNJ5zpCtlMW5SZE5n/2qHkaX/q/9fi5LndcaTDEmpm14i097VN0cmrNnTP56+2qp9y+11Dl9q/TkVDRtO5D972BVkdvGj6JXcXS4EExrnA7GEQjmUGreRXvFaGQa64LhUf2jzT1YwbktjFjfbx6IYlg276LXqWrgS3qBuYaTXBA1ESdPbhmS63a/UjlLz3XeSsCP66QbY84x6F7pCqHA9iHO5KEszgh3568N2+wgn/DCVxzFxwm4R0U5eaKTbWqzkj2pjUfypWuafTlTFKPqzWsESHMcR/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+wEt9RoxMstqYDfMgU/aZVdd2TgXoSCaXwYp6a3UlQ=;
 b=rNN0xJWgfZd3UxFXfL/HshtKE+k5cpt0+Zka8o4/RC0WsvbzTsduN8LWSfOi5k+6DsPBV73A68l8nclDuZsUkKBoGD4vRELlgBp8hLYCwvzuGJNmhvOLaalP9T5U2gcXCxIA0ANF2RKSI8pnfg6AYTHqbPzxUX9oWkkWHHvg4v0jTibFtn5Fa3GuqVB5rSPaMGWtZ8SCDYztUWAJPxzzQPUtCfA69eXOwH0aNWAWF/pxUXwfY01i6Llh312C5/BJJc/rsdgRZmqQFvW6gE1MUiLErH+tD7Ep2kcimBRfgvwOcX+ABw0EMf+3TbfXT8tqWgg5tgP3UrIs0PkSg7pCTw==
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6564.namprd12.prod.outlook.com
 (2603:10b6:510:210::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Tue, 13 Oct
 2026 12:22:42 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 12:22:42 +0000
Date: Tue, 13 Oct 2026 09:22:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <20261013122241.GR13920@nvidia.com>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
X-ClientProxiedBy: MN2PR15CA0049.namprd15.prod.outlook.com
 (2603:10b6:208:237::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 85aa23c0-8b76-48ab-1638-08df2924adad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8PNheXzvleP1Mrd5XJzu/o87Hzb/8voBiqbOfl65Mufolo8YISSUdRwcHctzHKa/Ln7M523POeaG6HI0Znt0rF2au6+rik6Ivz3+3Dg2akQZMiyfS7AeIrJ0g11uQxIp0mrNmsQJoCYpQ1ydUlmZrmaWx6ENsqYIFAdgcwqwLw45Oqz1XCMbV04sCTvEwd9G1gpg+oLDtsgMbplbh+kajr0zZ2wljRQQuZrn8ELOaZkGLf4hgdMBBCIYaI6UqyWNL4XIXk9CAnqX8pn2PKkDhFasKn8qO9FS/pfN0dhXaI3fbpb6Aud0IqovC/EO6wJ7kArgucyuG45qtGAtbmTAprgcMn7nszbQ4tB4YyCKERoaS79Nv0ibHDCoEf7paeyhoXnd367EE7Iqm9WbROh0fTa8DN2LsWuwwe6iWFtYoDk5/VRi3ZEhe4gE1dZCLkNNAX/PsnsY8wvV7ouvnKki6zddcJ/Zy62lOpw9daSB+dybRkaWv5cfnZZLRqAjxsW2W3kv2aQ6Qfl24PWE60qfevId/iY0c7w8WlwG+ZPIJaQ+KBt8pbLEsZliAaxmexyGU3YCSA6gMGd073bg/4aGP/BwwZHCQad9Kdltew8MslB1B/G/bdXRmherYxDKivmPpShQhTG31jNlfnGrKU6gr+Z+W2XTWQIgHxxADf8OBbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?smqlxlUDgM0p7XxQzY/nbzhZH6qVMBKljGz2SlbQ+y7x40jedZ65RGbBge4g?=
 =?us-ascii?Q?MeZUJrB45XRlWRzwTHFZRzi06YeY8dkddBnTcwu8kZFfv9lYkLKeRmwSrBjA?=
 =?us-ascii?Q?H/je+p/LzhfNeWYD3N8/EAZbEQEo45CeykbfEAhYAn617ib322mbbE2K089C?=
 =?us-ascii?Q?zkNC71dvLhgAUQz3KNl1w4TU72mHJZFMfe4vH2qx6CXciYjZDnx1FUjXL77c?=
 =?us-ascii?Q?FzZ8eimhb6epYGcBZYkbQcX7ljXfIsQfziyXY16Nqp/zG/6vBM6j1JojRONL?=
 =?us-ascii?Q?eoiwuliouYrm01e5cYB5RL6JhW1/nPWV48yfUWr6wT0nT2xpPmr6NUdAjrzm?=
 =?us-ascii?Q?vFLPYkJ9xK+Arv1hEhRMlTpm7GhKELN4HP5azWDObHMtJousO9fIAIp7rOe1?=
 =?us-ascii?Q?St20yjz+yRq5HOptjDKnFEuz8X/4nA7y5CHt5L6fJLu5h8nctK1kWBepxSKm?=
 =?us-ascii?Q?wCtGo1doZ5vNTPI9vNNBSUBQLa9UzhituxWt1V51fMdfQhiSp6Y0q+CTLxeI?=
 =?us-ascii?Q?nPh/aog/FLeOS0O8MATKZOIY2pxCrN1z5Lvyr8e8Al82lYXm0lQE4aY7b+tw?=
 =?us-ascii?Q?1FVo1x4n8Inc3epkC+EeQc5tJQnh9KPEtG6WzJBBTAiwB3CNjcC56RJDh53Q?=
 =?us-ascii?Q?Q3S0OUY/1ulAZvBF/Xtl2swXsvY3UwA+cdOuYD4fHtpAiSU82UIFdBABZYmQ?=
 =?us-ascii?Q?W1spDl3d+AhsNM7DSlrKE3AGMqphegCEHu8/KqDXT69jn/Owdc6RS+GAjIYO?=
 =?us-ascii?Q?jAAqdhZOLkp3OstLMNNAzzY6RGCWpqNg/ov2j/hC2SaIFlMazHln292DmhHy?=
 =?us-ascii?Q?3aOsLZs4/9d1rleZQAHCvls4QZfNdAfWWA8F80DqPRTcB+gJL4YfcogJDy8I?=
 =?us-ascii?Q?3de+dH/QTwTwlDG12xU46GzwON0Z4RoCMIJCsGIwg/H6pJrR2qCWEF8JlgxS?=
 =?us-ascii?Q?4r77VsTGHuvtNCxoYJZsXlEMgKougGOKEYUyWtgl9LCVbN5h5rqUbvbBN/GB?=
 =?us-ascii?Q?Mj8Q46yxCOrAXTCKOnW9Au70IGUndAHTAQ5PP7yUFgp++yRr5STmCPmKQU1x?=
 =?us-ascii?Q?sBqOaguDzMyzr39PnJxmyuqqZpn66i2Q+LZ+kf8Rcoq5MG5dVcrtkJjsbg49?=
 =?us-ascii?Q?KrE7tBDhGihpwOFP2pxAnMY+ZzcTjlfL3/tufTzX9aQHIHRtpgREGH/Mi693?=
 =?us-ascii?Q?aKLSYYiJ77itytzv/tykPrUV0vSiWFfvVTe8kdEslrsLBPtwXTaqT7YqtXZ1?=
 =?us-ascii?Q?q9dJVdKKeImGcY8t0e4ppC9Nd8d5xwXCd2xHrJyFvfZWUoZxg6+H3u+f1L8l?=
 =?us-ascii?Q?9/0bjK5BgPf4heuJIovvA5wAPXwXh5XSClKvT1ak1jWXOzH8WeZA90k6amVl?=
 =?us-ascii?Q?np8dI3jtDF/AOrsyHMrDr1tODbwqMb9hgJAhkv1eY5GgzYLun/g5h6E8U+BR?=
 =?us-ascii?Q?IMTsgRwbZyhaAAGZYLspdvwRXoUgDap77kpOHKnZ+TZumUvI6UQjWIbE1ial?=
 =?us-ascii?Q?7HDZvL9beUpQQhuqDYXujDUysW10mGQcgCz9KuBFU/IcBayyBWB7VLVBCpbA?=
 =?us-ascii?Q?Ln1hqRtXJD8XIFnn1414oIMuCReII4G/QstLHHfbjHm2utn/p0LIBOYwVKaO?=
 =?us-ascii?Q?uIuwubKSPGc56CxCJLXeighozfUqGfgpF74Kjd1bH6p8m3K47PT58nnao41P?=
 =?us-ascii?Q?BnU0gsMWx66GKQ9XOR/2UpCjLKfZMm+vkhKtd9gJ2+x+1kZy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85aa23c0-8b76-48ab-1638-08df2924adad
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 12:22:42.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vajYsH3hRncQpXw8OZoYPNDyy84Uzk87vm+XSk1RS+1fY8zmsLqek3FVzT44O7g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D53082000F
X-Rspam-User: 
X-Stat-Signature: 7gpsjusbqty6ut7fgnrzk3n9amnux6iq
X-HE-Tag: 1791894167-377044
X-HE-Meta: U2FsdGVkX18NBlU6njW9ciWxiy6GyDXFrP1RDUMrdPsg5YY7l6BSfj3imfxHYIurzF7ijqJS2aShiLheFbaRhduhKa3VZEfAU5t0izSudBuMGXs66kKvytEB1zDeUD2ZlLhWEI07gGwrMT3HhOjZkPs5LoqtRYaBZEcbsrKBVCUtcJkZJaXXgZ4+DrUZ9mxbwiPS2jSmSylYBdRXK9ZkiwyXYZEukLVdG/GaLi6iCFINR/wbyI0oSuW9IlCQfj9R/4tYy7NEqWitrD7BmtRIgzgMlxN1Jd3fEqZh+6T/SxNAQPxgf0wK1dk6NOI4gi8+xrL9FR9mBItyU/db6+YafpoUMNk9eMlCDQGn2Rtj7q4aM0lbj4EuVq/E1W7Pk+50npthfqwW3gFVEOSTzoutLYXoSxFi3SH3yNjWvQhbcrnpQ6A6UnjJ0Sz5kWqJu+6dazF+8edo4HQxvBRAQ5OcvZz+TFWW/TNYM8IRaDsrHYA5rAnZJfDVFKfxKfcjFGDqSzYsF+FLeT4XGZNkNpakDoTsbAlqxRFQk7rgc/gu9uRPLUFg10qiLUualY9eBygr1yXfUU3YJTgkUWW76Z/g+2SiSdXSjQoIAidXfet1Arpr5FHDBf+kKKFdraO658Ze33EU1NY/+UXphGNqCuZkmjwuC70zvcK8mk/KjoZNfnvB/bN60uE1PROKPugYWmhzbvA8MCUapIizIo49hqi35ti7YSXC6cDX/bvpUZoXgVf6YOjtMU19WpWV3bgoNETnYnyRKJBsIn1SbORCcgqWzn2iH1l9d9w6tvKwx/K5f8ysx9CX20S0Oqvcq4OtXKBy85GhHlnHLVMWAA28bQ5Pcs/dSBr0OfgLIjxWJQQ/FHe+ZprixczYN1MPhzGiEyg+1z7fuy9YdHYL+MukTU1Ip53YwyX9rTGFNnOYWEh3KKk1Y5BNvIjqCwxZ4VHG0MeNpwqYG2i4gdb39UWo6wS
 hHMqpfXl
 7jXQ/Y4PR0jRo73KvERVzB0/XhQGHGrSAqmkDw7mFSsdnnFP5iOPxFf0/+bDeiyV+OhK2dQpNqKBPvx0M00PKLZs83UxheR/1pZ/FfwZYLPn+T6jiw5tVHeSknExXZ4ELYeHRJwMk3snhf2xN/jXPGCM2CLWU6diQC1Pf+cWMejM+IBfSljRnTjG8x5Kuu01fdHwO+nbDf8KqULRDlHfbX03crw+Y/PudNYEgYkBKPrb1MEmB3+UbhsZ2VhylA1qpKNmXXxGxNCARW/9UrpoH+tosMLfAzv+Iyns7vwUwUq6Hyv+Yhbj97r+KqUzHFgpODT3o+d/gPtZVpcRC0ztQticICTTVBxY8nYsiigVwelnwQfQFBi28+n2FMofC8IXuIqBd+nryyEYFVUhnaSXALmWa9FkG0dcyaXrOs/0YeDhhdZVR4hH+y04cuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>
> ---
> Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
> Before/after testing confirmed that the block-on-fault case charges
> the page cache to the task's memcg after this change and is subject
> to memory.max.
> 
>  drivers/iommu/iommu-sva.c | 6 ++++++
>  1 file changed, 6 insertions(+)

It makes sense to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


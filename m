Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84C9C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6F16B0089; Wed,  6 Aug 2025 15:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687AA6B008A; Wed,  6 Aug 2025 15:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576376B0092; Wed,  6 Aug 2025 15:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 470CE6B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:25:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F208C14054C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:25:51 +0000 (UTC)
X-FDA: 83747312502.20.1FEC229
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C14C40003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:25:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XqZAKfgZ;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754508349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBP1NEEGTcuTF6AsvjVVHzIGZgegC8zhhDvVOECZa+s=;
	b=mGeDyiqScc75QNWwL1CUVAf8R4Rs57S2gkebVzQV5nC9JhMGcqKuIQtSzSJrTkcclWGqgA
	VK1a94LpSsEVxgZ4Rk4S2BWu9TkC2vHyibLN8fncbc9mzeI4iwL4A2i6VFubNLc2R+iX25
	WBIIE0dOj7Xu/RtRVGGKp6z22EmH30I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754508349; a=rsa-sha256;
	cv=pass;
	b=bCQ8WpYRal+Ozv29OAziOUPw0pB280sgjMgkouoCEeQLPaNNbzJAdienqzt7M6LlMZxBjh
	sI+QNOZXPJt4RHWnV/nD+hQxHUlSRR4PkfV4d2ekPGqx4oRiEQEtGyCaQogpHU4hOhceBM
	bNbWcGkZ0Z0nLWT3yQqTQg+C3QpWWog=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XqZAKfgZ;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yny9+xEfsqUSiQBPB91L+SSz+Ako3URCl7xptHQwRYyptZKEj53FwJvE8KoF42G337W/fW25ZzYmU3Z2ktJGWgqQDF16I5t2XBsVM2CjG6XPRnb59o8+Ko3nEP47mcmD4/bMYmDoFRt1+syUhHxHuM7SX/8iZbdvtI7m46OGmCTA5cGEOYHmFZwsQoI9Xa0hvb8XvOTM2rR004jFkq9ukCrFsbdly25F3hykVWpHR8PqZVwZIyK1ql9vNz0H0aIXs31s3hQONS+GIFONr0jWBEG1pe70TGQiooQbhHa0QjnyEb+fZ3xmPRLXLcM78JdKqXjnY+Nxlb4b3VeStvcyEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBP1NEEGTcuTF6AsvjVVHzIGZgegC8zhhDvVOECZa+s=;
 b=WbfzvqsfQjDObsdfz66leXl7zp8qvJEG62zCfSVeWwStXQF6EjmKXIfQDxancrRiivnoQ1o9VYVXVTzDQLODwnbUTob3/fq8XdargfD4l3hNii/Bd8Xh6PA187Gq5ljrNQrU7uCGNpbiESkikSSKXNbYZwUWRU+geiVDJlwTbM+7Tt7kt6x3WmfbqkI4ZY9Ien6ljPterHJmqurfX8hZuFL4UWFhd5NkCm3gJ3kfkx8ppPJabKnq4pgdtEjafG8q/iyfVxn9Lk9PpdAfftKTO/6/u/8G671Dnn0CtCE3fWQc41d9VKzvL4s45e1PmUf7teYZmABSsfMYDhAS3OPXsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBP1NEEGTcuTF6AsvjVVHzIGZgegC8zhhDvVOECZa+s=;
 b=XqZAKfgZgUM1h2TLxdZOOOTKNmoQS47lv6HwpDcoY5qNwWIqMzrxBOGhNY2OOiG8mIHUEOzmtHp3p3niZTx/PBndlzMV636IeKFaxpbFV9saP6Fk3f9AmcVjswmE7uY2uF/KvDSq2bu7BvuN+n3I7QF29v4Hz3bddDpKZNo0YJYP8yaQV256edqp3V/iJTTHb9zpFrRyEQgwgzScaGpVqjXHq+/LlljT+OY2TsBdNMAXP77Tj4eSD5I+4oL/WnEBkYXF7+MphEN9q1WLS1gatMFRCFZALLklUjbzPrucAehw0MKHGFycOT3wOctCxJA0ka3/gL5fTqYKd8bstWHCVg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7356.namprd12.prod.outlook.com (2603:10b6:510:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Wed, 6 Aug
 2025 19:25:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:25:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 08/11] mm: Reimplement folio_is_device_private()
Date: Wed, 06 Aug 2025 15:25:42 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <80E75601-A11B-4481-AB1B-AB80DB1493BD@nvidia.com>
In-Reply-To: <20250805172307.1302730-9-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-9-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:207:3d::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 44d54980-a5f7-47a2-aaa1-08ddd51f09e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cM0qbZTClhqpmKx/pASkwdP/tSbjj03h1gUUGRrCpEFo3j2tjLPN873gZpg7?=
 =?us-ascii?Q?OIXEaeFbAmunqa/95CmlY+gAA8OFSiS7ZCuJAQZxL1WsMBXt33jW0+GfBPTW?=
 =?us-ascii?Q?sgZlAYovxXs376pKhpBA2tImSPYSAPi89nyAm1b8j9nG2oHsiwNv7zgfX3vi?=
 =?us-ascii?Q?htcHF4ikOQk9YDB2V8QtJc3xjS+4rT8Mf7n35zm53Km4ZJDcITJDXZ2Fd3kz?=
 =?us-ascii?Q?bUnUWm0VYNYXMclvSfiWEPW4bf9dYU9eVQT6kuL3OnLW5q28boQFy4nk1abk?=
 =?us-ascii?Q?sqFCEBACm7Z9VNPiMkAiX3whh/ka+dgP9pGTbbgWjaNhHlP2Qjg+jx64qjz+?=
 =?us-ascii?Q?U43EMQ0yzWDF5eob7fYXSN99EuNUZikGflWadRAVIc8Fem7ceIVZMeYa25uH?=
 =?us-ascii?Q?Q4j08LPESgVbTlvfAU0+Tcgu2vRVgJVPDWAnTguND1BfBHnsx6fEPszWLS8D?=
 =?us-ascii?Q?fYRJB9pMO+qpm08MzL/GCPoMUcxphvGt1nzqNGtAq7ZvNNvrxuhlcK987Txc?=
 =?us-ascii?Q?OCqpBJ6rcCt6q8veH8+yZfhmgc9Mqv43InD0YrIkUHHLGWjWgBsr/RpVecfz?=
 =?us-ascii?Q?hSffO5ZcHyEe0e4fKB5kvVzHh+Y7Fh3DJDr3Nb7r+5phV28K/R46Fox7A1QC?=
 =?us-ascii?Q?x3rCO3ZsCj7atPibSsLuQwp6v1+t91BL52ClQinkg8v8vcvMWelQ2nyoB8SV?=
 =?us-ascii?Q?PMYmz7U0a5EaRj+Af6qQexoCnLbXswLuK/yCZRhlj49JkkSpldJ/DpRzvfxG?=
 =?us-ascii?Q?Ei20omOwoxCLScx3NbPVwffshGftG1oE19QCwfIr1U8Kfqm6dwh1gwuO2biT?=
 =?us-ascii?Q?5DNfUaSjPeQ4VssfJ5I9v5zxJDpwPR9Wri072CJRJwp33Zt01t8jawcpw5ej?=
 =?us-ascii?Q?wf+WQi+EFQqOXCXEN5zEnDWdsi/Psal9IT221JgX0ik4VwOt6XKDnKrswxH9?=
 =?us-ascii?Q?j9YtOgWCBU8ZQjIPjqtNx07FJAFYOCy9JtjKwjAcvYBXNzPsB2n42fe4inLU?=
 =?us-ascii?Q?Qk+NWQaYU3D6bUTkmx63kk4WUsagWg0NFNRBBBJlVxiZmdyIG1Zl6tbRUQLA?=
 =?us-ascii?Q?b3fL1G8Y3fSICUOcxvy+pN/I1VnUOAUtnXTcja4sP6VM4SgF+aAPNgiRxmqO?=
 =?us-ascii?Q?3TmSzdsGn3J15Be64DnsNGAIekAq9xg2U7/wn47ZxNXYRRNZhtadNQxXQliF?=
 =?us-ascii?Q?Qv20RJ/GH+2JvBMlW9LTWEJvNFZFjNTVeq9nMSQIKRSxSPWko9J2Yg2kl364?=
 =?us-ascii?Q?Z4hX2mw91frKwV/5YtoJPe1MI45q1epBQsoiAnIBKDlK9L8BVxL4OiOy7qCQ?=
 =?us-ascii?Q?fa/zfKgipKd4dyDn7KuZFRSGGoWZPTNrRt1UHKtnhHTgKD/3LWFBxWDXoZFP?=
 =?us-ascii?Q?IuGvqBa2LFFivTPtN1P0MgRZQbvPhLfxZl9G0coSlRY/Wm7oZ6z3rZZiTzSM?=
 =?us-ascii?Q?4OFM/14+4Tc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6Kg8vQZKbdT7qxHFi0iMdFAS0l8Ap+l7iYjNSiUSjyVBsl7w8QZDMFLHHSyP?=
 =?us-ascii?Q?DBPhDur/KiwKorL08Ad1iPQsQvvy0b1mnvsZj/h1atGXJOIZz/ckznUfC5Hn?=
 =?us-ascii?Q?5iur1niSkyBmgMECWv91osovvWwLGVx0JfaH171+e6/cbQyhWLelVYkZlIAv?=
 =?us-ascii?Q?4jHzIiz/qCBHsxmIicTJq9S3C7/BgwD1e64EKNWp531cuHhkF59Iz2bGNS5q?=
 =?us-ascii?Q?R9ZqOUbyD4X3QK1m5prXe0EDeQuTKylivXmd9ygy1bN703d29SpIgBN6rpSt?=
 =?us-ascii?Q?KaAywXl2iD6YxB4f3txWXt7ug+2NOMlNrg6fWRBWKMws1aQMqXPTPI2lPefv?=
 =?us-ascii?Q?iBQuaTfiu+HY8Jtl/MXbSXlnkhuMpLHS0PAk0+4cD7Nm2WrkYjnvhju9giA5?=
 =?us-ascii?Q?SVZIodqjT4/O628CWSHMxnllubs9MNEdUH6QT7bgSkzL4fVlTvx7qQd8Fzvf?=
 =?us-ascii?Q?ldJ/Y1RKNN2EWZwsCCTApY5CferVXqyInTwPd6mHtpTH45K/mHl5E3ieHL0T?=
 =?us-ascii?Q?UZW/u5LPSkdjUhUJlXQxhEyPEIjBolb0+bJ/95DzfolIxALqqw7Esayxch7M?=
 =?us-ascii?Q?OSePCwnota/tbutMCEZvBs/7V0rODXnAdFWg3aIBWjRFWpxQs0BSefnAa9rU?=
 =?us-ascii?Q?4iWnSE/bIBI6q2NZKqRCcIAgaIDODuUfp3X42k5xJB0HFrEvI29cDBFUlzIl?=
 =?us-ascii?Q?0iSK2KRyZ1YF/XwmCBWidg+woLt4iEbWSGnJa3sYRP6mskkr4GMiz5izGBj8?=
 =?us-ascii?Q?TrluuzuU50XGwWcl9yQUbeB7wW18lmSfxeTL0pfG7XOoVESr4mqJW0MvuoDH?=
 =?us-ascii?Q?+a4+mSmTEI5XEDjHfC3Cv5CLZ8/yujGz+iuyKe3LoUHnAWx2gMErP9gPYJw2?=
 =?us-ascii?Q?x9RfMBkGaTBAeHW27MTzdcXFjY2dbMVALOLrOdBv2ySf6a9U/3/qEjt0XJig?=
 =?us-ascii?Q?0rMe9OxfMCegLm/pvarqfQn3tyXlxBdH6VjWpfwPzMjaXl0FGQ2cBcNAqlzL?=
 =?us-ascii?Q?z3SI1Urq6qf7T9RBrrEOJeM5LfTnucGRcqxpBZ5LhvClP7vtgiPQ1dQuI8xU?=
 =?us-ascii?Q?SqVkbPR+/9zITf1aXHVnRKnRkxOlfBuZQ9+Hbllln6KG545uw6eQNBZ/VxmI?=
 =?us-ascii?Q?gwXp31miGnUS6qZy48N5H5BMpMKjLnaqRuk8vkOA47t7ib22Zua0idiS9n91?=
 =?us-ascii?Q?4rHMsABd2OHYiHFmVRnaYGXa6rBiatUUrDw9SaYsasZJbBKlNSxMSKpw1ks9?=
 =?us-ascii?Q?Pn51lYGdTdW2ynSTMNX/1qM4jPc3sgd8A4nA19xqK0cxwjCfgxeeG9fOHTVR?=
 =?us-ascii?Q?+GDl2cpHBsCZt96awoW+h+ZikLbHM9wMtMB0D1q3aO7x9Kpz++60SiIoX/cs?=
 =?us-ascii?Q?HXdGjTxJb16n74Q0XUdH+0zFZ8SFhvjxWej2TgyrK+i91/CXyomaLdtI5Mut?=
 =?us-ascii?Q?UsIFxvl5SD/7/CJPYSUUY0lyf1aw8DK/CQyPw3/ObOYi6q0RdDtP8o1OZOYE?=
 =?us-ascii?Q?mKj8UQNd8/vImc2wjNmjDONQM8KkIF99LoRHyPM+/a9NVxdF+A0NgEcVrgdh?=
 =?us-ascii?Q?szLWDfRX5s9p+ifiir6S1z2a8nSBwchLLkqDH8Dh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d54980-a5f7-47a2-aaa1-08ddd51f09e9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:25:44.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N72udt4WO9tTSwbiB/nbuI0le2wIxwcrOa61TxXVk97jScjNz+KO48Pn1lmeAlU4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7356
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C14C40003
X-Stat-Signature: yakmxd757r9dhqodh8ahzxut9aotifsp
X-Rspam-User: 
X-HE-Tag: 1754508348-578338
X-HE-Meta: U2FsdGVkX1/hsxg/SST0dzlHmIDASRs/xjqm7+fJGq83W/yEYskpM9Z4zA0t1jaORzUu+HrdTYAzLWcOfQsagLtWph0A3ci8sEoaob6X8oCXxMpWEv3gZypxXkH41+DdB2lkPVZA2KTi5Uwf9bPENR1uUC92Mg3PJS2u7Ce4EkNv+6JtVgau/Hln/ChxxL24ydyvdjPSASbMRYC/H6GVvd1BEQgketiMOO8dx6vFV8rXoBtF5VitJ8PhGqr6GAnnrqzhvoJtzaTb+WRw+BEhKW2zSPK8EBlcOSy8e525yCDZtMAYFt8JBqwr41rxiRwue47PqsrAIZIlDlORiTEkR7k8OxjGSOlnyV1+ALmPZZAqvRcNxzUoQWJdueYzx3DitXh6glDh4u/XsWKTecuhvLCsLtEtn/DPbVfP8vQtF9NK31unp34M0EFq9FSFe7U2WCdbMyGq7uA/E3t3I/qq8by2B2jLzjIGkxIw7rfUZxTbb8QYXpEY/VGOg1BdctDaR+wdn1fBFFjvonvFdUYGK45pSXCL9xtFdLhpqB/ELoeMG1oKo8Pt/F6JHD6hzBnGzCmE80dsnidH+HYSU+d8RDYbQgWjSxlYq8Wm3eChIrgCC1jJlvuL/IlBjYmg9W4k0amIHhlYpxDiF3HM00vhN3+38VM/DAdEIvda8qK6YdP0Gh3wdjKkUevVFD8qFXG/KUbC3sH01izDCi3RPRBnDJ2SsUV2fmgsZIE3j0+1pQOKRpDPALpvOtCAs8FGYDbUVUcjd7TWIfpK/xWHQbXrbUPQqsx6Vqg2iqtnw2/I22GZVjwhvWFqvNPrh54q8wJWcppzDK6Gelm37p79X2+iqaQDR56oovCu1F/G3iQn6CcQhXuD7ahLAoiffxiDBVyoQgsCYfQqir2zd/IyYbaHKZywq/cl53OHhQhlzNTl46+UFWBCVKn+D64/TnCbT4GlMPfhkToNUrUb6+qA43l
 syw83xyJ
 Q4+/jfm7ccQMk/BmIBtIT6KO0mYzwJUz+xG+cMlbl6lOvhFRIQTThMg0+PBKQxWO7z/ctXdsZpFudJEdBqOR25OZ7iKAJV36sc+4u4x+jnfxpfyk/b1B+Nw68j/HMsEYeHl5K/qCnnwk4mrOtmNsOVHIGsDLjT8dgAeZ0Rr4x0QUcIETgzJIkYKaL+BYjiZyJNIYJsO39gCkNQihNJ304QHQXb0LJixQ64R8jvECNvx0BYJwMAcm06v+WDqiwKfpH3A8gC688ExuYyAiOuU/P1dBnQPo56TXttw5BLbM7VWxJB31DB+NE1PwKWwrrnklKBewAbky1jT5NbUBe60UZa4Mz780do6PS1qw9FcU/qcwaEbIUGEpgRzmDXZO9qwptpx+BgTVfFaoohXfCG5xKIcWO1zTi3m1nm4T3zAvm7DHMVx2ItLv332i6u3DVunTvRMfyXHoC77vZ1VBivr1jEO0YRwn9qQBcYk4RKh6j8xXtr829trCoTdUjWLQs383p5bJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> For callers of folio_is_device_private(), we save a folio->page->folio
> conversion.  Callers of is_device_private_page() simply move the
> conversion of page->folio from the implementation of page_pgmap()
> to is_device_private_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/memremap.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FBCCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05736B0007; Tue,  2 Sep 2025 13:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5C36B0011; Tue,  2 Sep 2025 13:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4A16B0012; Tue,  2 Sep 2025 13:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 889E86B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:05:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ADD75863A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:05:10 +0000 (UTC)
X-FDA: 83844935580.12.A9550CB
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2BCFA20012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:05:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G2Ic9cWT;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756832707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQrGQtxobVX4aBf+rHw8zNyiL5D9mcLGar6Bs1dcgcM=;
	b=kU5Vt5K0J5BHPqZjNh4Hqu9Cjuep06lq4nvxJEzJEUEUDRCNsPSWmZ2poaL+fPiIEeRdUf
	9J+JtEUp59+SfEBuvKeAH3q62CCHf48b/LQTD7YeD+FYqBggQXFhKvCvl1e6XljhnASIBv
	rKSD2KZbASYZgzSPlLxJPGCQYrZMYko=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=G2Ic9cWT;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756832707; a=rsa-sha256;
	cv=pass;
	b=mH1TFfsCkcgwEyN8s0YbWp1FIVMAaR32mFCC1FfAPkKIyu2B4WOE1hULRSheXNK7fraIoa
	6Z2N2iyxot0mNkjMMrQqRFSV4ynIo32gkcJERXwY08DSPC2Foyuwy7esHsccQjTbTiz72N
	DQH9KFuLoh8KLndrH+P2wYF3K1cECzk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8Y1sGKxGcvqfsgpUJDERFEq5Gx62oCbeuoJ9gQjtY5wN2yjpsQNm9UQBwc00e9ctlM2wm3EhZUpRRtWvUnLAXw8U+xVX8MywS6JKxq83qBEGQtfZWTElmpWNefEX6/m/A+HMMx5vrnwzQVRDshKb79k1jJOw7ldKwjnKsnLblACXd4XTF7pnM/C4gi8KLBkw9d09D4if22NKY62az6WjXy6e0svs1AQS1cUQ231rxX9mwbg7x+JL5EAwJxhuoPAuG+duHhwbUgTOkUyiZkKkJwMEYxmhAS81F9U5FWkshc2/wMzxmjRhxUQL5RUUREZrB344o4jeR/KkQVdHqSKSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQrGQtxobVX4aBf+rHw8zNyiL5D9mcLGar6Bs1dcgcM=;
 b=DLep7roYVJDdcidqS+/xeBk5mYKKT9RI8k2zRQ/3mwt/BPRwDLdzhPwE5U9jrc/eedVKHkN5QxkQa9oJS5fvNce7JrLbmGPKaDYcDEkNycVUaWL/zh/jIZhKFTfGnhbfsS3aq5u/yXlx9ULFIdA41UT3pDWXY6pLhUVfmBoApXpDk7c2vGUQrzoyyIhuz6xQBi1G0tIbntV+ycJGk4RMEpyELipgBnoK/QJFb30oLhZmnwnsCUMi2ZDlj9ft8HnBOOeQ4atvbIhn+18Y71fhDyrOWcTWf6wh8d+FHbJhwc9/++W5RvpF5QMg1vs6iCHyn5b1sGrECmZQH9UpU8rN2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQrGQtxobVX4aBf+rHw8zNyiL5D9mcLGar6Bs1dcgcM=;
 b=G2Ic9cWT9HHE2EcTuttXPt2zcKxmKdtV3a9iBpwu4LVup3tvKNF9mAy2uESdeRsWCSb+6pglhR8L0YQ8/jJb2Idms5Eal2/bHYG1oaVhnOX2a5a7LIHJ0BAEC1L31NGKewdV/w2zWsePqslz6n5M3nC9m3VTixPsxzyDewWbWhksaoh4CYgGQDUclSg6s7IO4P0mlnYLkOdrXqJu6FqYngacfWTLsnoa5T50HXfVGGvHoHV34nTNeumiaHbW0eSGD+NhmHMEq6vCmHANrWPfFz0t17p7eMjCx7SzE/ev9LncIfY6oQ3PshekAVg0+FsunhbfGC9Ue8dmP8jP1Dinrg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8904.namprd12.prod.outlook.com (2603:10b6:610:167::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.26; Tue, 2 Sep 2025 17:05:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9073.021; Tue, 2 Sep 2025
 17:05:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests/mm: split_huge_page_test: fix occasional
 is_backed_by_folio() wrong results
Date: Tue, 02 Sep 2025 13:04:58 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <789664CF-2350-4E31-ADA3-BD08FAFC496B@nvidia.com>
In-Reply-To: <20250902162536.956465-2-david@redhat.com>
References: <20250902162536.956465-1-david@redhat.com>
 <20250902162536.956465-2-david@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8904:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b2c6cd-cf08-4bb4-de84-08ddea42da55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nrsYMDKhoubgcnAqYxeIxwqOgK63dkw16URCvcDrSbobh1DiM7dSdfFlvvJI?=
 =?us-ascii?Q?qfdXrkRpF6HMV/A/Lnu2FE5A+wl3OgbPbsfO2r+Ms5rFxBTMWG+VgJz3v0L5?=
 =?us-ascii?Q?UzqTCQW+ewOqb3EqUh8ngmpCk8GjpxAa+WF52ZxLS3O8qVdk6i0jczVsIQAa?=
 =?us-ascii?Q?+ujuHQYVTiClKF8h11wKaHV3ffoeHjfiWqU1JuJy8nnTh3Gj0vH0dQIwSW+B?=
 =?us-ascii?Q?thslpLqhC21agumdapfKC4bf+1jodquBmP4SP4pRLgUMmW6h54YpLKIm3wLE?=
 =?us-ascii?Q?r7jAl3cfX9vrjd98bxq7nJkFJ88SpKhvEBT0jM9zl0d/wKquYR7wDT4WIdrG?=
 =?us-ascii?Q?DMQufsV3CKNod+S0qgcWPo5pjpx3nvULnRK0STSBS+hCgf7PwX3G0SAbGweF?=
 =?us-ascii?Q?CC5yvpq+03akZcG8vwndwIkZe46oponf1A989r4ZtpKtVFgqtOwbmyawXwMP?=
 =?us-ascii?Q?eQ9EksjDMlCfTZhmaq1OEOXS4P8IUSX+AlTyc3MZyQtvGBnTVF2uRE4i1ayw?=
 =?us-ascii?Q?iz6aF9rjmkXBMCTeudmzX+ucVhFC0kDpFLZRM6/Dn5wZEpr8PaoI+G0nlJ3X?=
 =?us-ascii?Q?/pP5pEBr+lYEALScUN1EtdyafxAVbx/hp3SMcJ/MFiW/+c8aJZVOHdBGe9cb?=
 =?us-ascii?Q?hoEGZfZTA7VJtJz6gy/jAJAJ52R4YrKbgkaoPpyLLx3JGSCfoKxKCYghmxAi?=
 =?us-ascii?Q?SPsMr/cNgoenOh7sM4DYWfh0n2bmXxR9m5oW54TKVIFhEXfDxW4c89btcqV8?=
 =?us-ascii?Q?GflzezhMuqtpldOzSKCzwX1fRfabuaNQX2a58rTDO/YYM92RTF6szuuHAZE5?=
 =?us-ascii?Q?PIzEVLgku/pt75Gl33J8phJkp9+h5FlobCP0YjRPt9f73U1MJVkkrjv/tH1v?=
 =?us-ascii?Q?+DN6qv/MqslXWvpapcBCir627Nqu3EUGrD67mGp760SAB6ZQM3PS2MmpC6BJ?=
 =?us-ascii?Q?WYIWwizwDeP/1SE9G+Hc/yq1HcZKaZr5Ezz2pxtUktvNGILcbPzactsGDU37?=
 =?us-ascii?Q?8S7HyuUsg8OFu4lyW0Z5bpRi7NocW61LN3LfETfXk1SSGVCB+5KL9OP3XAHR?=
 =?us-ascii?Q?ICOO5JFbp6rsa3L/JDNPIupdVxLWen47X7zypBNmaKoCAFpZfRA04QPcroBn?=
 =?us-ascii?Q?867chaubp9KaCn9nfbGCBExtgvF0tcWPpIQuIcuAk1WdfYTsoi63r94QA0qK?=
 =?us-ascii?Q?XWwSrclbUhVlI4af1A+Umb0iCadJQGyiFLbatzEBhoxMV9/8rN5ueWS3twq/?=
 =?us-ascii?Q?XHkRFOQiXKRkfZzCMgghueUaHDKWgsdP92CBXXawDaT0pmS+KAH9VhFVgEj/?=
 =?us-ascii?Q?PVUWaQV7z0rGWQY2wnQ6DUetkJzvCTPTZV5ETzvKGPwS77kwbpQ29DvXlpkz?=
 =?us-ascii?Q?xM9R+aMqb5wcI72iwepcSIvJ4TcUky23C9l5ytSX0E7j2qS/F2GtPVlUCrdE?=
 =?us-ascii?Q?2HapHKLJal4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xDbinSbv7FdrGIyT+q+LaSTa95mvcemK7kO5ZrpkP6J9kUQt0i44dwntzgOA?=
 =?us-ascii?Q?ReCDZ7iQ6fGfzF/oW69CFCLSpnASm5GIF2rM9u8uU94+Bxdx1UIj2ljoC8Wd?=
 =?us-ascii?Q?93nNKrjhxFSq1hWcq8Xt003ysGyYejE7gR2JszPi9KJRJhqR/fzFUq193znq?=
 =?us-ascii?Q?6w2uL2iWyy8kEXb2pvHlWt6wkFvjOj+UiFabmMjhGXIe/SUrvGXaGIqAvHMJ?=
 =?us-ascii?Q?DiBo4A89IW2xqltoEXQchppV6fkJ0eANDbQWU13JpuZI9xY7Nz2RChm8TyuD?=
 =?us-ascii?Q?ogT42MefNYIcb80yUoeOX4thBkIDnf5rB8roOc1XB2lvPqyGs++2X0UYSNsj?=
 =?us-ascii?Q?+Ek46Omvbi08eaHiNsfyse/ojRkrEneX8sP6KXStxjnRlujNqpVGINBnv5ga?=
 =?us-ascii?Q?EOwUcfFZgGojc27AAC6+BFKybaP5PkJWYkZTFy/bSjvftBo7IDTZgTPtjWPJ?=
 =?us-ascii?Q?S+7PkpUWY0ZzBoPUcWWsHxBCl3qZ9e93ajWsoIGzRYoyh/AzrzhqtoQbj8vw?=
 =?us-ascii?Q?VpJ9iL3Stj5fNy7TBz4RbzRKUuVhmG2RogWFYlh8x7UgO6i0sVYXvNPZPDJU?=
 =?us-ascii?Q?P2gq2YfHBxxws48OV4YZG8FPjHf5D0b98m2w0rnsR5CkYJGPaHTjjzbU2QsC?=
 =?us-ascii?Q?WdYUtQ0PlgVLfgIGNxhNipnLeaAIjgb76NZTItza9gYyZizhIlQsOuhX6nf5?=
 =?us-ascii?Q?edQAIXddWjedkv1smR/M9n4bU70iEtA65J9Fg/Q2NYGTShaXSpv1+FPaUItG?=
 =?us-ascii?Q?GsV3P7NOy1Bp+ZvTKUNVGpnoCPlFFDN9kCfKttPq6tp6Z3gfWRm/1+lXXhqb?=
 =?us-ascii?Q?jotwuz6+hoX4CEID6mkjnd5WJe7nx8gBIGf5Rm/0jJEiAhA6w4U2QzPiOuHS?=
 =?us-ascii?Q?G5gHOhgGSseti1iZ/WtMhDsHyDACuv44mxJIDxbUd0bZ1laMtPbh9GcsbZp6?=
 =?us-ascii?Q?cTBgfG/9NvN65UB9XLxRAasUn0O9WjTeY96C2B6yY+nLGN8jtneDnF5hBUDn?=
 =?us-ascii?Q?Xf3XC2KtCrHPGt54YaCYK2wyOp2nsbhOKwY1P+w3xEvV9HXPAS9mZf1ewZ4+?=
 =?us-ascii?Q?yW+40fda2pVTO32h/Bl7Ad35WTUcdTXI1/c3Tk2FtNNvOKltY8F9O1aU9jkL?=
 =?us-ascii?Q?1Ig5zcLUj5ehra2O1iJ+6AeJnMq1iJotxuMUWnZn2KD1wZInKIRMQ/XzwNZi?=
 =?us-ascii?Q?H6H6RNzG0aqRNV4Tpd1AAw87zRu6Jk+vr/bRS6gjhoH8PjqUm4QcqGiu77NT?=
 =?us-ascii?Q?2ZJonqb+3OnX/JXhh0ZmtOORvnKyjoyChjgG8U5+Mt9RIK2/hM8034ydaaWj?=
 =?us-ascii?Q?otqdpSGNylyQ1xAXarucN35l2sKw8LXlmW5BqXO3lk4Tvix0YwhfO/YKrws8?=
 =?us-ascii?Q?6mTn7hruQZSQJiF/SRr+GtP2frm4wHWJwMeciNwUTlG5hKwR036p+PeG4AeO?=
 =?us-ascii?Q?hFyRSHuiOlfevYNgJADi1O80UY+aXho0IiNdRkpLsmZQhkJmRIFnx73k/J1w?=
 =?us-ascii?Q?QiiB1YkgsWSRx5Lk6KxOeVvDnXUcaHSVWqJdPCp5zxTzI5B3NkB80xyKNCUn?=
 =?us-ascii?Q?KWFl8FLb5hjhHi5fZTwlTuQ7wpjQOb2ySPEZElYF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b2c6cd-cf08-4bb4-de84-08ddea42da55
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 17:05:00.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0K2b5f121PxcR833qz+mmdpQVq7RmzfmP8ZvghqhRGwjf6SmhnIU8lYr5bM7w/uX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8904
X-Stat-Signature: qx8fg8781ua3dbd41wrgjfdyqfftcbho
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BCFA20012
X-Rspamd-Server: rspam05
X-HE-Tag: 1756832706-492497
X-HE-Meta: U2FsdGVkX18SXSF9Bp8X5pUbfSYvmiXrdQ+kcsBa2NNLfA2y1qL/SIWTBinrv7hVtVB1Usz31XWXFMeoUT6uCsB2KST6ZcbzshSZMjDr++65F08bfhPm7aiBcGwsilntE42zs9aKtWlgwCvmWgncMhQSnfG7ihqDFFgAOTRJaC2+77CNFjDeyNc9J0wvhT+OT8mA45aUePgTIxRXtv86I/KbtpvfJyKtiHk9yNJHTXT0sqxqwaFztYxUdBEHvsGZNKbmy3sJJqop0SS/IUsDxF67z1oqmGuHhltQ5eqCfGhmpySWAZ3MPSSHHE+MaPGAgMLLhgT1XMHKQ9epyrWExWmQvV8yogH9ZuQW9urXEAm1/LiqPymHEFb6fv4nsLfiqXy7gIbw5x8o5KPxz3puSJi/lEPQbizmUWAVwF4yOORtJJibUnIpOSFdxJ/vQ9UqPjXmm2P6epIgHA+q0EPMWYD6iuVNqJfSWIAfW3q4wzbm2Oqw1yqj49ih78el7ckhuqWjKK4ceoAD4eokb50EE7VqTSEKnjlWS03xI5KOk9eVfjExGtvXfyur8P+TTvhzXDoBNOIySN6RK8x/jM7R7aEkNoDWXeelrqzlP90E6sBCVzWLJeBAtchfi9HuJBABPsZhLcAjWEriG9BWEh4A/HAVy0Rr66mzjEuwiED20dPkctBbfEIW3ijCWu1uQdnWMyJ7DkIeTBbWwjnCRLBF9xHx5YwlikIdF5dsNobKyvRaoGE7MId67FcIPNPD2YU5HpL5RtTXWpXEiKjFTaqyGHGn4e80phtqCUHgRgqCcTLpc3wu/EHrHCVK3G8fm29leI4PKwZVtiHv4lxEaxEJhjo7Ug+mLqN75qrJsVJLjH2JcK1XsG7fENWjDQT7nxeRahLw16mt2tNwl5G/2+e0Mtkt7C8o1Sd64IFiZRsTHNT2ORHlp9wfjUTFSQGx5fB2k2ThuQNuNM5XnCB/0P2
 +3nQWN3n
 Q7yMUVbSlRKTVrpNLNKn3ybDZ4GIAKQjkMhlEkALxTEsOwRcpadtaCwRZzl3j29HFqGj04i3f75/D4fckqgOuUAhj2MfY1Ybt1QzDov/a2XZ0KJnT2atrSyRChPtHHtmL8SCB0Lnonv+D06n3jpzJ07k/S/WJZinqKM2E7lFJCqd6zWZg+ASMzDGN29n2EQrq7sTRrVwRX2ASG1Qju4QUnTpqDFlaNEfxCMYat08byJTCa95fI4vskF8y3JIypRRgS/dJa474/LEXDK7Yla083fyJNkXcxKy7xiZXI27mwj6bgat2ACieimrxOVIreFkpOAb9YZXavYWUxBcGjtUDPVZa/uM8Gd1N05BFhXqHQMogWg/kRZlGxeoAXY3vx3HiW9Ew/bYcv428iB87t6VrpGxv3qVFV7lY1KUFyJUQUG3eBF6iMrqRmfjiX37z449QUNW2RZDDulHN+38oSJ0Y+U4CGa06uQ7maoSr3fJQDBtQankX/W0JNSfVwU8ITrmVV6SH3KCji+hJAxEuSJqhyOZtEblh8cxvuOtEXAdcNamKe6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 12:25, David Hildenbrand wrote:

> When checking for actual tail or head pages of a folio, we must make
> sure that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with
> KPF_THP.
>
> For example, if we have another large folio after our large folio in
> physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL" would
> trigger even though it's actually a head page of the next folio.
>
> If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp()
> can fail with "Some THPs are missing during mremap".
>
> Fix it by checking for head/tail pages of folios properly. Add
> folio_tail_flags/folio_head_flags to improve readability and use these
> masks also when just testing for any compound page.
>
> Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with=
 more precise check")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++--------=

>  1 file changed, 7 insertions(+), 8 deletions(-)
>

LGTM. Thanks for fixing it. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


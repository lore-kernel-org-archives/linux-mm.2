Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4103BCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799576B0088; Wed, 10 Jun 2026 10:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771116B008A; Wed, 10 Jun 2026 10:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6881D6B008C; Wed, 10 Jun 2026 10:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 556686B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:38:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 060844014B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:38:58 +0000 (UTC)
X-FDA: 84864259956.11.159D99B
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 185421A000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:38:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3wS5qvM;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781102335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeshW7FzHV/d9V01L6WqA9YFXcEAwzystSdWa+Vp/og=;
	b=UAXvvxa/hfst+eRXWcR0DnRTE1ZNFYL3ZfCLaxNrrn7ufj8lIUBhe0xr9rH5br9maykq/k
	ge7j0GM0cWo1ho/zIlabz1e2FPQ8YSALZnPGxxI22uBQiXaC6v3NUXRKpOmpg1MJ66arn1
	zkOvGdkYc/P362sNlqcnFXO7l6IGrPw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781102335;
	b=ud7Km5q9fglNG3Db+zEt6hvPLfOXOcZN50G7cLvuqS3UoyRAHyBR0mWg7hkfKoPAOP08kJ
	rN7QjQqCkiC/aEoqEgOz1uG8GE6LaWqDK11CUU/9jN9/TTCDwbApIcIvnoyWMlS4oHG5H2
	RjvU7QgBAnJmdQ24/c5b4+e7dVjjd5w=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e3wS5qvM;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lGZmtWPcAThgeYHCgnBm94x6lAgFXbr43KUIa8hrpzTbK8ZgeNPjU0k95JbPGw54eW5z7KSuCENZ1yo+rClwoCuqO6Q56x3dzpKMm+T9r8uGDytD8x27uxRtOV4ImBCOHtEDM2N2JkQ/hd9vRY/OJrjjRSS7mMU4vagBft1+oT1F7z6iju5pBLwm6Ffm2iQPhjmryfSTqcqRxFXnBSxiJK6BZMmK1roqGXkG3pVas5AoYUfQV2Y1In5tMsxzf/p1+lDZy+41dDg4NIG0lsKxs0zEp085QLfZOUHRcaDjEcsNVPns0bh4OtKwFyHeMUJPwjlQDRWPH9MwE9toB1YN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeshW7FzHV/d9V01L6WqA9YFXcEAwzystSdWa+Vp/og=;
 b=G/qrStvNY0OdiUKSZkFSZKHKXrWeMMrpSU7/OaqMNaaF/sYea5rNbuPfrLHSF29Xe7gbgywEgF++7LNVdgw3dWXpMBHjqBHTZgV1R6Ngz6WSG+Qq9NJ3L1JobCnghtAelc5xxm28Nl20V4DCAKc9OD8Yed0RvHe0XsTVdTuK2l5Za4nI10JJvZHF7675U5GrtoG7cXbPwRaJVmWfvZU8+QkN1lT4oUPCHNbEXJ6cDsR0xe7J0JS7e63hXw+pL4uCeDXisoRPy2D0z7JYq7zFNZCj/y2BVLMSWViKhF9S0oWxUzgKg/HAbtF/+B9bvyJC/CRhvxQ85TPBLqWO1k+x2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeshW7FzHV/d9V01L6WqA9YFXcEAwzystSdWa+Vp/og=;
 b=e3wS5qvMjPCC3JvX88/YK4kds0ZMmI6eSxSRVLr2JoYjW0kIAWKR/oMrL4Z+Pn+/QjzR2UqsUgqqcT2hrB2ppBc+UTNqtOmfE1hyD1LP/pJI6OKSVc2oTSoC0jkJKu30mKhAqfLS0vITXdoLDmCl4mloUygr+x53muNzqo4T7TA9m1pI8Dd+XE733vloZvukSZx5eVKX6YjiqSzD4D1gJzUGT7LUVaNNJMBerUpxd3dTeWEtWAUy8KeO34XksYtEgAUpA/06IPWtUcHmn3duM08ec61thZnX4ckxWenYpAtwUCVgTC1CydVMKxPYJkNGGxBYNDxXg1689jdZABqXIw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6667.namprd12.prod.outlook.com (2603:10b6:510:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 14:38:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 14:38:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 10:38:45 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
In-Reply-To: <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0161.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6667:EE_
X-MS-Office365-Filtering-Correlation-Id: 739fa545-55a8-4bf7-a62f-08dec6fdfafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|11063799006|56012099006|4143699003|5023799004|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EMRja+aJwVx/FPlqCudDPX1KWhVlMHsvISytsJY1S/q79+VjTCX75XymBh+eCb+maN7w+obB+1F7mMajv0Kgw4I4ODq9WgU1S94rHWCBw3gnMOniDYScbO2WQn7waUS9TFhR968bDt4dnuDG6EqClgyLYpBlXY1ayqc+cClR4jSnnFt3t6sdy7Wft9Dak1wzp8u+97UeNPw5Kt3YgpUSjZTzIUWXZQ0rWlCCPULC59AzjqkjcQ7/WWZjRX+G+1hnJmVmPCQo6HZ5Tm0OazCwIrK5JZxVaYsslx94tTcspp9JFJd0qoumZtBN4h7Ah5M81LEEx5dVo1JPqrSR4kVCzV0FTws91eBE7bPsveqT8dKknFlZuO69rTfWS6yKEswG7/XzlNNj4ssdTojAyC4dMtr2BjEFMkwfNxlJWKOMcLrLRwbD1o+3avVopk7O8S1ID2tvFBWULYDvpyfErxNaaCRQHJ3L81+swF5ubPnxcnWb9NEy2F1WfnTFsC+VQF+q4KcOtIbFpRMPVlfaVwgdYZMt0q6iGLsDnrrjZXGOpu5y8A4zUwIGfAOXsKuODvv7yFne3t07Bna2Xt2aXGfmPEEbxaFO1tes2lsHgBPnI7TRP/bpd/u4JdY+W3NCsfCPY8RsB6kY8u5lNXPC4RUIFHIxZKyHu6qWaLH05U/h98ZdVpoE7TeKUDnGBft2hz0R
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(11063799006)(56012099006)(4143699003)(5023799004)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fwm19GZJhvnb+MkAQo5iEBPpxEhe+1WPws00zppqUZ7vVpEbLhe2DgNjvokD?=
 =?us-ascii?Q?XqiplOcbqrpOh9ODD54vyJfog86mf7HfnzwyM7Ji/xAPe40YA+c5I7uVu65f?=
 =?us-ascii?Q?VVzyYpj9NxWrx5lbxQdXUy9BuDGt8Qyjl2xtVHRc0aT9IEXsJ2GW71nxUYVe?=
 =?us-ascii?Q?o9XXmJ0aXV0o5iT9V84EfC6dCFi4HNQ1aBLp/uuJfhv3BDuxmWE9fu1k02bS?=
 =?us-ascii?Q?+u+pOZOCY9dv3KhXiM7CQge9M0o3peLNgau2p1J8W8JXtCb7fJIgYUj5bl4Z?=
 =?us-ascii?Q?w2HE1D7CgZzoXhPx+8YZx6Znzgkpc+MbBo855cA3xEHeh4fsdu3uRNcHZhaC?=
 =?us-ascii?Q?JVocPxYFgc5BNHp3/vmDeG8tDC536FKxx7VWQEdziJMRsyoIIw1tmUCrdBI3?=
 =?us-ascii?Q?b14QEZI1rECsyFBocpEpoOSjhkGjr0PHlkoEdDPAWa3Cxfk7pLAEEaqvsUto?=
 =?us-ascii?Q?TWG8ewHm9YzmeIEXr5DyWiqK0NCLp8JZ9PGxlnaTij3rv2ZX8V/vbiVRTgeT?=
 =?us-ascii?Q?kkLrmKsJHYn6EomJwBedWB/6rjx6iuA9Bctf14X5a8UYUDiUk6xkqpDF7cKN?=
 =?us-ascii?Q?JH/53pdtr5czzn420fZK0sVnjmfoWpPNUJHBCrXtTIVOgmtcWA5Z2kZRgG37?=
 =?us-ascii?Q?2+f+w9AvYAlcXGNGvF0D/pFzWa1SA86oPriEo08bpvfvYHC1sCSMAGy9oqp8?=
 =?us-ascii?Q?v42j4tf8AKL31zHgwGO8iT3AnHq9qLHoz2IBBklLA+rdkEVFAsynTzfZvVo6?=
 =?us-ascii?Q?cyvAYJkgs4Ah/NIOslb9X2yQgpB9lSikqeSJLgAPEJBJIwB3+KCF92fN5PAM?=
 =?us-ascii?Q?GO9V9OPrY4MwyI+/c29PWVdWH30Fkcu0j80BlRn4jyQPN9LlWqMzw9dKsiKV?=
 =?us-ascii?Q?HlCxPIYS0+QGIVPBArz04+ZBVNkj6/4O2d1pJHi/+5o2Dv8xzr5NWpr6mEwp?=
 =?us-ascii?Q?AYZS5qQBGwuXVi16q/NUNeBpt0UnCbXovxpfdcnzZCIq5lHCXQwrdwNenwpa?=
 =?us-ascii?Q?yapDAsGZ+FYrYR0HjUrsrDec1wTnAK7hCNGCmy1jurmWYRPnMeXQR3iufazC?=
 =?us-ascii?Q?mlA2VMZvoEYLK7QHFVWr2iCh7c3pNlGRkvWA7OrY+gRD4mqz5z9sH0Cxjg/7?=
 =?us-ascii?Q?EICr0R+aoi+OpxIm3twPVGhEQOjrsZ8/8nyah9olPn4EOgXp/S90rEQdk4Ru?=
 =?us-ascii?Q?lwQtkdmo/wAtsdr8fCZLNI7ykLj8xNc/FniSDaAwOhnrfjIG2sJ/ugm62X/n?=
 =?us-ascii?Q?VgdQ7faTgiHNCJi/h3Aaag4CVRGlyxtCHdBXtGsfXAgiwRYqN0EBr41zJ/vC?=
 =?us-ascii?Q?3UEC6PD8KdaPOqg3cilB7WiYWyy8L1ZfqLeWnHh6DjNZHvuWkHgjr4OYo8W5?=
 =?us-ascii?Q?odKrp7LibzJRh9vewXuZWLhmhmgjwuqHEUWsZVwqN44kI1FH7DMTMPq3ZM2j?=
 =?us-ascii?Q?PAO6e9NRsFFJhEkAHJFI+qxFJFg4TpzGFxp5cjcUrUw50ma9a930kS9qN9gq?=
 =?us-ascii?Q?2ncYHNL9Qf19DbgiytSNpo4/hvXMo5xIXG2RBBNWkDW+cKBS0s1XHs7sZ2dU?=
 =?us-ascii?Q?JANhselkkIm0yREmqRVnJbrdfuucOMDHT1nmXBpsEKeqRiwZmwqP+A6Je+Dg?=
 =?us-ascii?Q?QHUFytYdi45fHMXsvjI9UnvkiQCLSOXmSUSM6xn7bhVed3CqGzFqygZyWx+D?=
 =?us-ascii?Q?pJ+Cu9wMZTJvXOfaehmsqFX8xt2oiApRa0gj3R6/qjyLLAAK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739fa545-55a8-4bf7-a62f-08dec6fdfafb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 14:38:47.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9k1xvMdNDe65vkmO+XbbPukZo0OcpsN+xeeQtxfe7OsvveyDJpdOhDOcvOau5vZg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6667
X-Rspamd-Queue-Id: 185421A000B
X-Rspam-User: 
X-Stat-Signature: hw4h96a5gwd48tk8tkb4ktpqbcyedcgs
X-Rspamd-Server: rspam08
X-HE-Tag: 1781102334-101022
X-HE-Meta: U2FsdGVkX19zuOlbw01W7lhSi2LobAmsla/WvFhsJ+joiMbEHozT2EC93x5kwiAKLfO2V5zs0tNfuV0fLYLMI/kL7pE1n+5pvif8w0NGyoQ32K7XHqsnN012RELe9zNvhDHrVlDIc6q8xRgsMTigI3ya1N9ENeOx7zTQ8p5nnR1rIWpFiCOzByjlOr5YQsRd3RhO30BScbFZdRcUPwtNZKGEXMq+7j/n9eduArTI2HwVRlBOR0vR0dgh4TgvfSDKgAiOYO6Ewew/UU3UtF+9GjUaLU2p2AH7uhNQEAi4TxdHcOG8g3dv5qORX8F4yDlMACRHAqzdaSdHTBab584l1mEFf8q7HQnmybzGEw8viVFUqkphwyayf0RpQ99JaF1BZnKDP7go/rjPHbEHJJUjuPs/dKBwSo9Zhf6Q3ra9vzjtKfUYt0MX9IUbAxocUHlvhlet6QuOR2nHIEkSOZYnOZfCpzDHKypWmOGbDGMCkxkvW+mOvaGMYYUJ/XdKkV0mrW/xledpU11AkRbpCHCtE9y7bpW/teyo7LE8Du/PBLH9G4t689Eux385j9sab8/fNtVD4coyZchwSBWI0AVlyHiiqSJvhNnheklHcdMALqnRJzfk3I+fT4g1f0LHXFUyOQl6UmznPRO6ZnAU6W5+kk1oszzr1Izropc4oiW9bzsVT8l8MXgVgY7NqEgLNrr8Bca44actUy/lDHN1crH/6BWA+qPyVeP0adck//YC1ws3Ac7hBidwZBUirCh+XMeyPnbwF3bmAqnVzRbElbE9JE95r4XAkfRdi5U+VAQRdU/NcumU9zet0bztShe1ioWb9K4Oij8C9Qum9AJbylkZPVoFDitjL1b4ORbhsM+CaUkB5RdunPyb6djH74KKgu5Qhk2WMxTGE+adUiXZccILTYgu97rhkKp22TIph1vYjSJd75g5RNgEeLB+I+PGJ8igE0L7OvGIoJ2uOpYvVrH
 vqpUsvH+
 aSdnRYJEEl3WpUV2BVZ+nZsNnwra6YUeDI+Cyj3HM5lG2aWOd0bylbxCr+dzJpDr9rMZ7ZvE4uELWekQImHWl6sdBNd0q5y92MxFqY3t8c6iGqec1ouUQBu8jB6SSMXS3HavKOEVJOdKYXkMrGK3vffDiWNBn1gqh88zXejx0WmGyg1sYC1zUsAjOJLYCCGGtwzqBw3qiP2ployVFTF24rY7LEypfXTQ3XtW8NeyYd0DoHjjxBw5haiWCVwZhu4L9xvULuldgwWSMVQJUl8d+VDVk/9SPO8CGwgTZk89wngLzeWlTN2K21FNF8J2UOkLzOcLFsUqJ3vlwLBww0p8c1NN6wsZEV5rADpFNSqBtThd4OLi6tZQ7pqwREN6b42uN8jM9csNaCcK6uUBpsZTfQcf+BH7NeEoOsab0sQhit301lYqdylM6Xv76WKkLS3X3TQugLhxPTBaFZ/Ah2K4jGEcI5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:

> On 6/10/26 14:05, zhaoyang.huang wrote:
>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>
>> The kernel panics are keeping to be reported especially when the f2fs
>> partition get almost full. By investigation, we find that the reason i=
s
>> one f2fs page got freed to buddy without being deleted from LRU and th=
e
>> root cause is the race happened in [2] which is enrolled by this commi=
t.
>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: re=
move
>> non-uptodate folio from the page cache in move_data_block").
>
> But I assume, that other FSes can trigger this as well? Any insights?
>
>>
>> There are 3 race processes in this scenario, please find below for the=
ir
>> main activities. However, by further investigation over the code, I
>> think there is a common race window for the truncated folios between
>> split_folio_to_order and folio_isolate_lru, where the folios lost the
>> refcount on page cache and remains the transient one of the split
>> caller, under which the folio could enter free path and compete with t=
he
>> isolation process. This commit would like to suggest to have the folio=
s
>> beyond EOF stay out of LRU.
>>
>> Truncate:
>> The changed code in move_data_block() lets the GC path evict the tail-=
end
>> folio from the page cache through folio_end_dropbehind().  Once
>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
>> page-cache references for all pages in the folio are dropped.  The fol=
io
>> is then kept alive only by temporary external references, which allows=
 a
>> later split to operate on a folio whose subpages are no longer protect=
ed
>> by page-cache references.
>>
>> Split:
>> After the page-cache references are gone, split_folio_to_order() can
>> split the big folio into individual pages and put the resulting subpag=
es
>> back on the LRU.  For tail pages beyond EOF, split removes them from t=
he
>> page cache and drops their page-cache references.  A tail page can the=
n
>> remain on the LRU with PG_lru set while holding only the split caller'=
s
>> temporary reference.  When free_folio_and_swap_cache() drops that fina=
l
>> reference, the page enters the final folio_put() release path.
>>
>> Isolate:
>> In parallel, folio_isolate_lru() can observe the same tail page with a=

>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its =
own
>> reference.  If this races with the final folio_put() from the split pa=
th,
>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio()=
=2E
>> The page is then freed back to the allocator while its lru links are
>> still present in the LRU list.  A later LRU operation on a neighboring=

>> page detects the stale link and reports list corruption.
>
> Complicated mess :(
>
> So, folio_isolate_lru() really only requires the caller to hold a folio=

> reference, which can happen given that we did the folio_ref_unfreeze().=
 It can,
> for example, be triggered by memory offlining or page migration.
>
> So we really want to not allow folio_isolate_lru() while we are still p=
rocessing
> the folio.

Or we should defer adding split folios to LRU after unfreeze.

>
> What your patch does is, simply not add folios that we will drop from t=
he page
> cache to the LRU?
>
>
> You should describe here how you are fixing it: "Let's fix it by..."
>
>>
>> [1]
>> [   22.486082] list_del corruption. next->prev should be fffffffec10e0=
ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>> [   22.486130] ------------[ cut here ]------------
>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS B=
TYPE=3D--)
>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>> [   22.488539] sp : ffffffc08006b830
>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 000000=
0000000000
>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffffff=
fec10e0ac0
>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead00=
0000000122
>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffff=
c080061060
>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 000000=
0000000058
>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 000000=
0000000003
>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe857=
21f0e25f00
>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c6564=
5f7473696c
>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 000000=
0000000010
>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000=
000000006d
>> [   22.488647] Call trace:
>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>> [   22.488661]  __folio_put+0x2bc/0x434
>> [   22.488670]  folio_put+0x28/0x58
>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>> [   22.488689]  f2fs_gc+0x230/0x9b4
>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>> [   22.488725]  invoke_syscall+0x58/0xe4
>> [   22.488732]  do_el0_svc+0x48/0xdc
>> [   22.488739]  el0_svc+0x3c/0x98
>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>
>> [2]
>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 =
(folio_isolate_lru)
>>
>> F: pagecache refs =3D n
>> F: extra refs =3D GC + split
>> F: PG_lru set
>> move_data_block()
>> folio =3D f2fs_grab_cache_folio(F)
>> ...
>> __folio_set_dropbehind(F)
>> folio_unlock(F)
>> folio_end_dropbehind(F)
>>   folio_unmap_invalidate(F)
>>     __filemap_remove_folio(F)
>>     folio_put_refs(F, n)
>> folio_put(F)
>>                             split_folio_to_order(F)
>>                               folio_ref_freeze(F, 1)
>>                               ...
>>                               lru_add_split_folio(T)
>>                                 list_add_tail(&T->lru, &F->lru)
>>                                 folio_set_lru(T)
>>                               __filemap_remove_folio(T)
>>                               folio_put_refs(T, 1)
>>                               /* T refcount =3D=3D 1, PageLRU set */
>>                             free_folio_and_swap_cache(T)
>>                               folio_put(T)
>>                                 /* refcount: 1 -> 0 */
>>                                                                   foli=
o_isolate_lru(T)

If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio), =
folio) in
folio_isolate_lru() would be triggered. Maybe we could just return false =
in that case.

>>                                                                     fo=
lio_test_clear_lru(T)
>>                                 __folio_put(T)
>>                                   __page_cache_release(T)
>>                                     folio_test_lru(T) =3D=3D false
>>                                     /* skip lruvec_del_folio(T) */
>>                                   free_frozen_pages(T)
>>                                                                   foli=
o_get(T)
>>                                                                   lruv=
ec_del_folio(T)

But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T from=
 LRU list.

>> later:
>>   list_del(adjacent->lru)
>>     next =3D=3D &T->lru
>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>     BUG
>>

Why does CPU0 still see the stale link from adjacent?

>> Assisted-by: Cursor:claude-opus-4-8
>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> I'm wondering if this has been broken the whole time, or if some rework=
 allowed
> this to trigger.
>
> I assume the issue can be triggered for other FSes, and we want Fixes: =
+ CC: stable?
>
> Looking into the history, I think we always unconditionally did the
> lru_add_split_folio()/lru_add_page_tail().
>
>> ---
>>  mm/huge_memory.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..7465525a94a8 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
>>  			folio_ref_unfreeze(new_folio,
>>  					   folio_cache_ref_count(new_folio) + 1);
>>
>> -			if (do_lru)
>> +			if (do_lru && !(mapping && new_folio->index >=3D end))
>
> It might be clearer to write this as
>
> 	do_lru && (!mapping || new_folio->index < end)
>
> To match the page-cache check further below
>
> 	if (!mapping)
> 		continue
>
> 	...
> 	if (new_folio->index < end)
> 		...
>
>>  				lru_add_split_folio(folio, new_folio, lruvec, list);
>>
>>  			/*
>
> folio_check_splittable() makes sure that we have a mapping for non-anon=
 folios.
> (no truncation). end is then only set for non-anon folios.
>
> @Zi, any thoughts?

The fix works but I feel that it is masking the race between folio_isolat=
e_lru() and
folio_put(). I worry that the same issue might be triggered in other ways=
 or
in new code if we do not fix the race.

To summarize my thoughts above:
1. adding frozen folios in LRU might be problematic, since folio_isolate_=
lru()
has a VM_BUG_ON_FOLIO() for it but still chooses to proceed the isolation=
=2E

2. the race analysis is not clear, since both folio_isolate_lru() and fol=
io_put()
do lruvec_del_folio() if folio is on LRU. When list_del(adjacent->lru) se=
es
the stale link, the folio is already in buddy and page->lru is modified f=
or
PageBuddy use? So even without CPU0, folio_isolate_lru()'s lruvec_del_fol=
io()
can do the wrong thing on pages on buddy?


--
Best Regards,
Yan, Zi


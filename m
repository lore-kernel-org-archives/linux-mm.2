Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41A3CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38788E0011; Wed,  3 Sep 2025 13:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E101F8E0002; Wed,  3 Sep 2025 13:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF668E0011; Wed,  3 Sep 2025 13:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB2EB8E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:06:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D9DB1A07A1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:06:40 +0000 (UTC)
X-FDA: 83848568160.18.26E2C14
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A34540009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:06:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFRKKAAC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.101.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756919197; a=rsa-sha256;
	cv=pass;
	b=SpRki8mGjCTxSDVhBBzNKI5P36WyKs2TX0sAepJr6OwMAcuheRpOEFCORNNluOjDHdoV8W
	Qn6Y8LiLZdAXZS1lPW5KFgOn0rmq6kKWoAuenIZ2Ms6Uu2TfeZdPXs8uIUd7R2/Tlq6wRc
	vTud5NNzBgwqaGXakXc4EpAp+rfmbFI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFRKKAAC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.101.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756919197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsE1hiqNNWdX1K9d8qh4nNysrbtwaSqriEk9Wbt5RD0=;
	b=nPGsFYBIs9tYZJQSQqKhcoMpG7W6fZbwGJjqcN4ns1/bjrt6dG1z5DnAfx3j/7IHImUwEf
	Mf2mNOE7jySudOVt4hIyq8y6TUiBLXGfu172ICFazZbEfhA0Rm5fE9FpECK3C+DHrCZdzM
	NQ6x2Ndm+D7Z3gkP/HKK8lAe2D5d8VE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuBU8R379BlADwEtLLQWoY9wBKN/hQ96fII5sgtagDMl2SPYeZA8tUxPz2a7KWE3xSt5t9ra2HUazP39Mj8iB+ChrSDlIo6qkcsr4YP9onkytPb0tQMpcYm/oqQK5UykgStINAUUYpBKwnOawpzw371gGRleKI1pkVNnQifoq6/czgdSlwMV2zwhKqF97f8pMh1dj91t+XBF2p+V3+efNzdTZuIf1Kc3f+Uf1TatL3hnrBVMVS2/Mv0/RCVWohhpaF2OFg/uBxkKdCeyzS+XpCJXUgPilawsOa7wk/u+s/z2YMFVStGDkuHEUWa3sFGyWpF4h9rqomIfTfN8+kY3ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsE1hiqNNWdX1K9d8qh4nNysrbtwaSqriEk9Wbt5RD0=;
 b=UjPX66ue6cN4gOFoROToDkKUpBNLffwDDnRdyXmUrf5rMNSwa090qVm4I0nzzEqnQBFiC68kPNOvq3wlxqB0bBM+jlD7LVDPJ2qHWnKWYnw6WS2DpvsL6oH5giR4ndz3K3LIirKmQtn0lS2TgG1xu9c/3M6C+ScKLcQtNBrhU/vg7CzJJ9qEPxBlOjRenJEDvwthnF6MuFNbYIP6tRT3sFg9r/B9+LMO+e8QRCkt6KIIOgqu28HzWzOUFjWggl+q+eOx0dz61IonMInT2mC1h1G325ibNH+SYejsbyLC/aVFqJ+Fzh+CWPrBNFE1j7i2KPuVh1b81AdSvYh0ketqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsE1hiqNNWdX1K9d8qh4nNysrbtwaSqriEk9Wbt5RD0=;
 b=pFRKKAACeW2KxYXAeL8Ed0gIgI0MNuu5GVqxHbRMFcYKaA7VkOmPKVxb5nrBtJJyUCNHvkkQn+IbaTd9ppOaBh57V6+X7B5H9w6l8ZhgPyREw5VUMU5RetZGS8mbFOvLEjjxPOsROY7idZIve4P/XnOreJDYH/nL5S3o/vMOP47wCGIanOjE5WRpYSd/6dpSGRg/8z7/iJRym12GYK4A3RZbAAdPi4smNV5wOzqj0Hi63+VvZGi3sYeAjBRYg5wBJRZJDgFQSG/uuWlGzQ7Z5rO9xubzhXng0U4IT7RJk+6959gxK4fH6muGsuocwV9zqa/NhbZr+FOl7mHCao8sYg==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN0PR12MB6272.namprd12.prod.outlook.com (2603:10b6:208:3c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 17:06:32 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 17:06:32 +0000
Date: Wed, 3 Sep 2025 14:06:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: add support for preserving vmalloc allocations
Message-ID: <20250903170631.GK470103@nvidia.com>
References: <20250903063018.3346652-1-rppt@kernel.org>
 <20250903063018.3346652-2-rppt@kernel.org>
 <20250903125620.GG470103@nvidia.com>
 <aLhg2Jli0KUe-CXC@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLhg2Jli0KUe-CXC@kernel.org>
X-ClientProxiedBy: YT3PR01CA0041.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::21) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN0PR12MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d12f61-4d5e-4a4f-6ac1-08ddeb0c3b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sQ6JEcnz5UCa3HUguqDO4kgpZxyy7eiPxzsQhBx/lyUf91NSSkZ6fid/N3Hp?=
 =?us-ascii?Q?ZBVWHtM8UfqZQnDfz42HDcZd06SvL31FvNUwcj4M4VZMyeFFR9jK81bsbqhU?=
 =?us-ascii?Q?WveSk/xalhvxttAEyTW1ifo1VvlsBQK5TfrGb27avpziHDPN+6hGYA20aWlE?=
 =?us-ascii?Q?dH9Y8oSas+X8/9+AlyC+raChzxjPF1qKVGq1t8C6MfWvs54lkXzm3wh6U/ow?=
 =?us-ascii?Q?dKfWBmqnJYoreE5eW4Xl1SRmD7tUD+Ip+5KFEQp0tCVtWF60qIJbYeRvQ72q?=
 =?us-ascii?Q?IFvwt8cnuPd3a59NmYEmtZzjGx1w/8M9039K6rJAOEVdijEqwjL55uyftLyv?=
 =?us-ascii?Q?2M6vhBsgRsPFvpDmrLcweiGc/6kdx5OyWJiZ4lvWHCVGQL2ShuTo7fLHEVdf?=
 =?us-ascii?Q?0SD0BdW6UY5Fbw84It/vg3FLn8N4tlvNlvxvYOvzyO0e89XKtN5d6fqKJvaO?=
 =?us-ascii?Q?yaMXwptapmO/4HlQJpOCRwLD6Mwr9CIpCrFot7pv4+yAI2NMRsr2osCisvQq?=
 =?us-ascii?Q?DDZOGKG1xA2ywXi/EmGrw3wYXF801go/K/MX3iwc2yL/6vfCJy9T4Z4UHWJa?=
 =?us-ascii?Q?18S5S9aGvd4dhqR5+2f7h5MIs2LlyEDJC7rqrKtIfifd8STt6q0zOMFgiWc8?=
 =?us-ascii?Q?+XlVursGsKCAqN9s1Rw+ZKH7qmBadN8ey1iLjJKpnkPCWJGx5L8/Iwb7lXFJ?=
 =?us-ascii?Q?3DMyKpfXcGzBSHs7kB79zXcZDSuNJNIxSPjFKkbzQoRha/QKy1lkd0O5aiug?=
 =?us-ascii?Q?FIH4DlO3TyHM6vsHMWBG4thmeessLuOf/XiEZ0P4+NZuQGWCjJV1VdKfw+tg?=
 =?us-ascii?Q?JYndHg3UIDOAoOMhoIpxhx2PwfBIpMTvGBuhtDmuk7z1nt0V6O9J/GHGfG2b?=
 =?us-ascii?Q?vNRLJw1zl89UYDCFkIWz/Q2vJ1MCW9XEyfs2kyRQ+ROGIzivJ8POiPpsxzza?=
 =?us-ascii?Q?vlwM2F7wH3TVGwpb4HPaX2ZdSG+5buvE3roIDv+Opq7L0PUBIyRR84I87746?=
 =?us-ascii?Q?QkoVn5sJAGvj+7H6tr+Tw8zNSGibLjmBRMDLmCNwUgXMsmsuPEaj054JG21s?=
 =?us-ascii?Q?la+vHmKzDywMPg+kDv0jKKqtQz3v8IYJ0ewSlPrGVz2Ku0mvYx4gYwDjwCYF?=
 =?us-ascii?Q?lZ/X+6LggyaXu57lP6p5r89amxTVHrVS7wA0Njan9wUpj7qhOCTV5WlYRCMS?=
 =?us-ascii?Q?3iF1sKPhkndPLtI1FR7/JmzbAC9QE+b8v+vX2c+5hCPzG29ZG7HGlvlPBxkF?=
 =?us-ascii?Q?3P+d9d2CqtYHA//RodYUQQ5JbPejJvNqcgciAT+94dTh2CbRHQcOP60llPA5?=
 =?us-ascii?Q?BOxif5GIB7vfkJYF7tnZIn7YtSPVqn/VaLhi7DPx/yYpdT19P8+KSdFKgKgv?=
 =?us-ascii?Q?inN63i/9FVlQwnsRve03R9dV7bs5MxQ5slYP2oX+oJyxIZFZHSJNWqMHybnP?=
 =?us-ascii?Q?x3LvCnXkFQw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZoszUNMrhvCN3AJDkVXVJ9vZOjtV6ciaSVL/JHDNtuJPYCDesZxYhGfG6un/?=
 =?us-ascii?Q?x/ypt2GyUSm3dzIXZW4BAciXlhl7CtoYLRWmgBfGZn82tHrRAe9fnkjaR+ff?=
 =?us-ascii?Q?huveDF3nEQd4iO4vGGyMqn77qSo+YUGSHFZpuhHLgYYdao+VZurMVSyWLeCL?=
 =?us-ascii?Q?iIlMLOZdE4mskkNcurldkEHb4Tss+CN54snSqJJx+4emrKbAsjRI3+r6iZ/z?=
 =?us-ascii?Q?f83Ghfv2JYHmnDvpoZddCjDAKEqi8sOTbmGHYGDYEvuxL0U0p9D7l0+gz9mH?=
 =?us-ascii?Q?JbJP+IDJ25emEzVsLkKeq43oMrVZ+FO271Y0cKk6DheWab7H/NnUPnQ0KcKM?=
 =?us-ascii?Q?AjQotET+XR+XxBbgO2xYXqZqFHUaLZKE3XycPxYjRlccj/HNB3VN3F2cD7/t?=
 =?us-ascii?Q?Oh1mR60wSg1l5flRMLcrDPM78Mf6xvayi9rPfOd7cxIrqmIzgzzGK6K3T2Gk?=
 =?us-ascii?Q?7En9Rqp3PLm4n+xnw4OlCjVT8OyjH3k/4juEOH/bJOrS4awQh6K30Es2eOTN?=
 =?us-ascii?Q?uPFian3gP3LZkYBrNmamPODgM/bStQqKC+0xZtsiqWhK0tgIfdDU0i7qGgQj?=
 =?us-ascii?Q?Z2uLg1mGCg/r44p0fSAme++MELtVGM9oqcz5ITnF17u/Y3gwDtv5R+BNZy94?=
 =?us-ascii?Q?2h/usSBCXKIcxT5YOz3ethaK3mniUV3Ky8AQSD5z+jHV06/awmSrjev4ezos?=
 =?us-ascii?Q?SoQQjB9qVc6AKDtIoh0vafpX6taQErME7x/L8vfe2wPJEvRZnMl1V4i5TLN0?=
 =?us-ascii?Q?jxXhgnwmNgS+Pgm7UABcHQuHazcsYlbxniWTwIb3/M/Roet4Gj2v1RMRHTkK?=
 =?us-ascii?Q?eSumABQ2zd/UECgI22VpTQ5a+0+zEVwe7qKA5axVAoAXlP2pVe7aT1y23NP5?=
 =?us-ascii?Q?7RhUGOTXmdn5iAP21QfYhl3NSUuXeixW5qyn55MMg2EpiUiqrZgGqDv9KaMi?=
 =?us-ascii?Q?A/CxC4wrmzyZwxEopeLw6yd4bWdW/vYQClvWxDxz6OOSTi0xnZfxcLiJFt8z?=
 =?us-ascii?Q?tmvrvNqTjqocKcRTmHMc1L8iQM+xhh/KE/+NMEt59ex5yXRebeN6EBEJzyDm?=
 =?us-ascii?Q?swmx+isM4o5QMpw7wcFjFJLb6LEI9ZZz2NYqERHvyB35CptsKGOF3iF4Jw/I?=
 =?us-ascii?Q?+7z+yh7WqMccW2KckORucu2xLDD0E8WK4GHhBmCumk5vNm68yu2qmJ0a+Zq/?=
 =?us-ascii?Q?r/3rI/ReFsFzuPPauj1zLnl2pBVtjNUzICilXTjauul/p1G2gSxyLFyK7LUl?=
 =?us-ascii?Q?f8xqdwZFN1KmGNhZb3YRTwXOMsa8VHGBxARuy6aXKlxIoGKUAAeGTTsOfDmr?=
 =?us-ascii?Q?axzplWlOlPg08Ymfhr+aQ9FxjBuWEWKsAKGPuwpIDSj+wU+X2uV+JGFph8Kq?=
 =?us-ascii?Q?Auvm2TZpLmMssGdQheiNHNa5nU5AZhTxpe766Qw7nrdF5kuOpeFImnmm3cP4?=
 =?us-ascii?Q?ueJEWzeX3Tt+y91RON8ZFMK3ZnxG/JVjAeLp48r29WoC3at4tB+51CMiNBQk?=
 =?us-ascii?Q?2vXcOP3gohkc4MHQXMoiVMz1Mcd7XBrOq6PuEcpKNkxG+4C8wW6y52uG0qFF?=
 =?us-ascii?Q?3pqUURMSnhmW9HJ6bMk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d12f61-4d5e-4a4f-6ac1-08ddeb0c3b4e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 17:06:32.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXPRXdHEJQf5H5SSoLJ9W/UUzE4y+5ZVCPvl2qyKDjEFUtp1gSlsJxOjPNqWOkPo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6272
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A34540009
X-Stat-Signature: uegtzwzgdxph988nhnuxduma6t5aixuq
X-HE-Tag: 1756919197-646931
X-HE-Meta: U2FsdGVkX1+QquN3t3yLx+gZwK81N2bKr9mYTbFjkVx5GnRWNkZctN7UNOT6mD4XWnB/hdQbB8ZHX/kAZi4Ef7afbWpC7FLtMHo7GIaEQ4kG2GNsFT2PhEGARS1HLP+JUBPALpDPnR5x0Md1X4KED5k2Tkj4f9INOyhtn5kvX8mrtTPQWIZuy9bj3dzI/WvaOjy3hSYgceFi+oNH7UfTO32fEhEb7qa0V2OEpTX7+vpAi4TvMdNgo+lQmrBVFK3/jWftq2/Tc1vkb89dtqqJXT7I10jGBt6eXh/QEILLzZSBkUD6tQLptmVQnTjtoZsui5/8UcjuCFxQPRvWaHtxzvcAUBqNZnCMNQOeaZtwDKKgFe83xfK8s49icuenMpIoLBCL7i+jtMFhlPozfUgxfhrcGgt5XoJC9KtVL/QWLAz/TNUVwKoUeLO9/MKpcLcDWctiudgZwbvsGJ20Na8nSK1kvsHzkeKep23y2RWpJmQTlcgizGU6R0eyPWpVAIWd/vqGlbsT3uY1IQXumIygG+WLpsWsgDnrjTXdpPKlmq3TQw8xRCTzc/HTCg9yKFZq0MyCR8r6FJvjO175DmoqeiXS8uR8hIpsZdfJINRW74bTY91ZN9XikegZ0875ubYko4EriweE7D6TjZjAB1Nf0JrIzpL4muWlFHpseQL4b+Iy5omWavD6+EFrHIlNX6vmytvwnpi+6UIY7OUd9fVmvBGGieRH1c38wsub7kehAZW4af8x9k9lHQLmurq3z5gX8FYq2dX4HMDwHDa8dcZGul6wb8NPJllnsAawpYLfsDjgFtA/gmfH17Zh+CaOkOq/kMUngLd3vj84D/B7octok5zz8MgSDaHslgy7UGon300733fCyR2tQ8IRQ8ID5hHTmqycIBBTVMfHzPV4zQ7JmmDiW7pljHtUv17B5UYdpsc8vmFLmpwrF5I5egVNCb4qLsTXMPGGlXYFm5CZWYZ
 9AfPhGel
 jqNgHA6KSHyFzMbOpQqRk09k97QssVzAFWxxdQB2to/W6mMoVqCgFaAKNquUwh9PoLJvxuwfXJr6cq7B49hdQxl1E0Z42xcJ1jomthwdh9itYHTehNBqwqVBeLY3Bg3fbOVMif4cvZucpW07JTScY++peaPEr2qxKKV9kcZU61kOuPewG/V+ZrQnKvNaXpF0UIGtZ+g7JrkAMAdSd8HYplB/KdZIbs7reU00YAN28ZNh8ARJibEA1nukGkXkznk+ParfOAgc3N0GRu7ruxf6DeEFSY65QUb0Ko1Da6DNIVkJgDj7REvLxLfgD+ulHM8xU06Vb7yP68neww6nSNIGVqkhRKvh+F0YCQ6zKTBNWMSX+KaLtGY/XqTFR7vyWsDkYvy6JYulGLk3kMA+aVzKbIcvzzpOmvec0WrDxIRMqb4rEczB1GtoC06WrtLgfsxN0oxqk6eGxWYm9eaFZuvmE3lhlGLykfXQEUONNv0Y0lWh+56uiRVUypcxaGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 06:38:00PM +0300, Mike Rapoport wrote:
> > Don't call kho_preserve_phy if you already have a page!
> 
> Ok, I'll add kho_preserve_page() ;-P.

Cast it to a folio :P
 
> Now seriously, by no means this is a folio, 

It really is. The entire bitmap thing is about preserving folios/page
which are basically the same thing ATM. folio is the prefered type for
what used to be compound pages.

As Matthew moves ahead it will effectively become preserving
memdescs. This may even start to happen this year..

Every memdesc has a type, so when ever the physical pages are restored
KHO will need to recreate the struct page and page->memdesc with the
correct values, including the memdesc type code and any memdesc
allocation that Matthew plans.

Meaning everything should be struct page or folio based at this API
level, and restore functions should be logically paired with the
allocation functions that created the memory in the first place.

vmalloc() is calling alloc_pages_bulk_node_noprof() to allocate the
memory, so the restore of that memory should also have a 'kho restore
page' type of name that clearly refers back to the allocator it pairs
with.

In the more general case this should be setting the cgroup and
charging it as well.

> How do you suggest to preserve memblock?

Does the memory have a struct page? Then it should be a preserved
folio list so you get back struct pages in the right state for what
memblock is doing. Someday that will turn into some specific memdesc
type and so on.

If it doesn't have a struct page then it shouldn't be in the bitmaps
at all.

Jason


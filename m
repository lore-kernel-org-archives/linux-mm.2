Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9F0CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEDD6B000D; Thu, 28 Aug 2025 12:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7ECC8E000B; Thu, 28 Aug 2025 12:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF86D8E0007; Thu, 28 Aug 2025 12:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2996B000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:01:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53DEB160290
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:01:25 +0000 (UTC)
X-FDA: 83826630930.30.447DD4C
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55277100019
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:01:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="NK/a1uBn";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756396882; a=rsa-sha256;
	cv=pass;
	b=cnI72roW8j4zhZw3/Qrs1F76l7ZyyLQPQtq7cUje4Q7ynTWAVoIi73CG7f7AJy63uzu812
	i9tGisno020XDkH8VRYmEY3JD6eGj9SYrM8VZx4H/p3Vy6tgglDwvKmbPb9Ih5qMKgKKrk
	kbgf1rvm+jcHiExgUlXlvCmcXFdO9tI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="NK/a1uBn";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdstHkCHpawpiiJfH9Q2VpWGfYVCpet9NlPpEzQD2U8=;
	b=ZZyap87HiiP1Ai7QytNFpClE9KkfCUt8Hf/nC6zE1W307Fuw0eQhSkf9YtkPXcE2cbX5IO
	zbOJkD5SDrh+SrOZW5A57zZ88C5upXl2wl6ccC+hsoBX82DyVcrzKE/YhtTDqChjJ4n6cO
	10YdkxbmSuNKab8b3T2SMzGi+HovZAE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om/BPnGW3ybONVhhNEzf2AuwccXH98py5hPVxqOuSAk8HTsfTTcptHZMlv6jpYYBU92ZK+PNh8ZUsKOXl40b+OE1tjbRZG3kVZQt5Bl3l8Ct8euqFGDFQqPhYNI+Wb98DKmf9vt7PclZM01wuVO66Q+CRRZFOKoIlIyrEptnCSCy6lrKRu7TNj/FyoID8j6b2VJ0tmbeE84DFMOwJhel4Z5zOmxmog2aBLvHoLnKE3k46CC9rnzWZMZ+L4JkI6u1Uxs0uZEYDOrtcqkJBZKasDFE7MkBg262FA+FYTt/34oZ0SI+utZNuFZ45UZUNM2l9G8FPMRik398ojmybHIRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdstHkCHpawpiiJfH9Q2VpWGfYVCpet9NlPpEzQD2U8=;
 b=u1T5CCxCpwnppSirsnQ8EB332l2COzmGJ9dSqceybYnbMD6+MOvb1+w7vX4UvZoQ4Sq6DGTEyf3oPYEnIP9ylgzpEaonEAF2nLmEsjKRkG1sX+oep5dhagKK63dGQsq4Ec3mOLRsiIJi5lxvxoh0/MeyHHotivEEzl/FXRiQnoRjGcIDnVMrvg774MySaNpZvYsFUy3ZUYVGy0AomzyoezwyBUJMl33iYpA+zp9K7fu7ClFNZgY/ZFacz+KJqXkhhskY9Iu7vS9r3wWgUh+Hsqfs2dvQELAuY1X4iNk3kN8FQgYe3K5KI3GH+KLJN4uaQQYOn3+KuRx9mPtyrVR1cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdstHkCHpawpiiJfH9Q2VpWGfYVCpet9NlPpEzQD2U8=;
 b=NK/a1uBn2bAOPxY5btMMiD3DOxoyxkytv1FmKKE8Akl2SQvbJUkG+GTS+YiaIg/JP0/wXKF12JdQie5OBuRVoCR3MJU5mQQQCbL5/r9mbURKiSRltov7TayyGfXmZVNyVuaavfE5NS/+7Mme2tuPNAcSvd7qJ20wEFm6X73Y11iH03fs3sw0TZ48fUmStwO39m39qvAjKYfgDCkiQNfAUSKqlTVAsEJyWzSU+TYM7/ysF3S9++WDyig8UYJZoxsMrdaRRoheDr6EZBBQ0eTcAQi7nDduHrIXGxKImTJVkl6qgstGFE0LvfPpDtNePI5cB3a9iRJ/j8zfIFSJo+E0UQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH0PR12MB8550.namprd12.prod.outlook.com (2603:10b6:610:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Thu, 28 Aug
 2025 16:01:12 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 16:01:11 +0000
Date: Thu, 28 Aug 2025 13:01:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 11/16] dma-mapping: export new dma_*map_phys()
 interface
Message-ID: <20250828160110.GJ9469@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <bb979e4620b3bdf2878e29b998d982185beefee0.1755624249.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb979e4620b3bdf2878e29b998d982185beefee0.1755624249.git.leon@kernel.org>
X-ClientProxiedBy: YT1PR01CA0154.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH0PR12MB8550:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b90076d-92b3-4e53-369b-08dde64c1bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h5QOdmaL+pLjklwJ1hsRTUJ0TU5FA04/ChUWDKTTEIqoQR6UG8DtCAMxdfY/?=
 =?us-ascii?Q?lK3Mfl4rfLLltCVSN5mDcwgJqgbNufDwFgGtWFjs6ScwJ0jcR97gU1LEqURR?=
 =?us-ascii?Q?1Qom41k83JxNkuc1HJMc/tT3qq1nEdc6MbzoYJZpB+Q+XmgmKcVP0B1lnSeK?=
 =?us-ascii?Q?LfjDFxgyfyV7oQTjibvCwJpJW6Bxh1Ps+o93NY5EKKWKCZJD7E76EC4yOIge?=
 =?us-ascii?Q?3QOBIlsZsXdFu8+ziTPOZe4bukBIQcSmJvSgo2/vY/DbBllOJ0ndP4YhNZjx?=
 =?us-ascii?Q?m8H3Fas4GJXij5lUQChQFPTPCoPfCZr1nrGARzLf99lU2FkyTMfF0I3xuYBx?=
 =?us-ascii?Q?DwYyIyJ9csKTf4EXyEsrwKwx3qrcnWoCqII5HkuOEKG1/JefAdeVs+7v9tLF?=
 =?us-ascii?Q?6vb6T2gj7Jk2s9ttmqUF29eaGFMf6u6i/Mo3LvOwtB0WLpVNGlCGgu+tWhpm?=
 =?us-ascii?Q?04w7sZE75F/r4qldip8G91NgKjSpUYfARvDxILl1Q0yocdNf1Urkg+HcGkRv?=
 =?us-ascii?Q?7ha0KWl2DLagKMUArRKtMOT/PW7y9kiC9n4RVj9/7OG0Fdh+U/cauDu4P0n+?=
 =?us-ascii?Q?KQKskgvtRUjpeIBGNIMmc3ixSwcEIVe0Z2qhBsllZ+jUm6mjffbphwI30gAP?=
 =?us-ascii?Q?Lm1Xopxg9YnOFFGEVQGUOlZrKc8YFaWn/01NCqTS243i/o3AdHPjMoqlmgjT?=
 =?us-ascii?Q?VKZF+H0BRsjUq21SxZYirHgJanOtCxwPyt23Y27qMYBQxhynXpKBOC/pfUFt?=
 =?us-ascii?Q?RO9rGjkwIRsY0bR7Q3wzxFfyvyX6WrZJ+mxuHUdc1TX/FLT6LrjUjqAgAC9N?=
 =?us-ascii?Q?IN6p4sGFDiRFgwxAJtAsOmMg4kb4WCysg7Hi2UGE1MQXK383JCIToz1Lnd7/?=
 =?us-ascii?Q?oTXyHs0pkjAvn5u0IrS9zoTwYp5tnNnPkX1PZWrK0G5pmqD/ZUVkY0l164IE?=
 =?us-ascii?Q?erul3smld5KgOtIduhg65GNKa6Xq11iWjivCWxZEZd3pXpv2orkd9v2h1spy?=
 =?us-ascii?Q?vHKR1w6GA+KsxrE/8GDrNdUXJssFcdaPf7Grj5eGUyHwTd5bfUoBxrDhArCb?=
 =?us-ascii?Q?MX7LUIy6jzi7kRwAVK5+WIAiQg4J6zYF+LaFSpCnHde9olb2xyoS71dgDd7c?=
 =?us-ascii?Q?XzahdIlMbpPO0Ic/VN7aGTWMXaQqDDmExuWXlv/yig4nTbcUF+5OOwUh/XKH?=
 =?us-ascii?Q?hcTb4CntXjiR+6qAMQy7jVCVPgMUuipCBxyowj+VZ1YwokJstnCUYrvU4mxO?=
 =?us-ascii?Q?3N4fQrL1Gy6cvV4M1t4x1bEgwtlNyRrdh66bUr0+BOrgUGzGHV+EH0DvulVM?=
 =?us-ascii?Q?+NeQ5uqiAcAQkHind7ExXp6nD9Ik34uMRD4TyRItoXasxcWdMmG4X2bo28Lw?=
 =?us-ascii?Q?IIWn5AzUZ6A8w7GP9UsBFCuTvNd47A2xjvujqV6E55ciZoTxgq1rzRPwdpkP?=
 =?us-ascii?Q?QYK4ULd4kbs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?emov0xpwdzd0eWxrHayyQ7BNIYV0B48ZSFkY8q+Iibu6uGJ1cqJOC//YpdY1?=
 =?us-ascii?Q?4ttE+ETLilY0wpbs3ECP6dzeOge9VxxTZfTKfaTY4Du6hNH2VFPxiWXGaHdI?=
 =?us-ascii?Q?OnjnmtgMmhIZLhwJ6BOA7+6kixnJyYYRhzUiRhZLa/EJQ4Tpmr1uyGFzzwqI?=
 =?us-ascii?Q?X3bYusGsggfolYa4h3kQq27IiMGOQchw23QUH5DBm3EppzV1bsLWwkAbKA1E?=
 =?us-ascii?Q?xwvM/3mjQlSk7VKa/GqQ/7MgtC19p8lRT5XgZpcSRvgLeu0LL8xS25kHgxRx?=
 =?us-ascii?Q?w9M5gnmrn1oF4azTs2w5dFKqlt6MZRY95P7mH3254cYanv1PR3NWxpZMWbJU?=
 =?us-ascii?Q?5at4WjuyDP3YQJ97njw8klZ9uBNoOzi1O8SjmNwbPpqEJ/c32qjajdBzJi0H?=
 =?us-ascii?Q?TX6LhgmZ9ixJ1XQX49fS0j70h1fmEN5PdLojmVrS31pbr8g3tOyMnE2fXtVJ?=
 =?us-ascii?Q?ZDAX5j2Nx6CYOIm1SLb/MIYg6VJMwVmCk5Ba9AKt9GPhAqA9KtngB1sq3+Hf?=
 =?us-ascii?Q?I3HT9y7DYyyMpuYWoBgzhi+8jhj/pgc9UBBcc6VxJx6bD6/So/FUZR/3zttA?=
 =?us-ascii?Q?q/cT3T1PL7qWwIda2n3zyjYLHCTVSuv/iCIXC2m/om2THcpzvlJgL99BV1AG?=
 =?us-ascii?Q?4tltcoIjgDSCt88uqUIn0BIZITXm78neuB9uzKtZ6pV8zWHLfnA/Jg/yUZjb?=
 =?us-ascii?Q?AZXtMiYgHSXip7KeMP2VDoSI1S2DnVfiTD2kkr8rwptPYgzxk+ChXDoziLRv?=
 =?us-ascii?Q?aICu/DMElz5cNpMQQMOjXFBt/tiRkWV3LcTOf/iWPhJVgrKxI0dMrkbqBmwn?=
 =?us-ascii?Q?zMJ6hf2tc4JGPV7pBUuUOIB0N3RWN4gH9C5h7uPkrRgF8frKhQaQ1JFkZ9Yl?=
 =?us-ascii?Q?XyWRbNtHwOeeWJyXAFB6IysmuBL6HPOKlwSSw32/1UaCk1m7nXWyPj++7TeO?=
 =?us-ascii?Q?Cwuzlstr0xgeCB5WF5xcCmlxFLhGDhKGemzZxZ4CgwyY8GM5XYXtQ7HHRAkH?=
 =?us-ascii?Q?ATGiUdAGkBQGR+2tB3caEYHXdLD7u9r+0yQ+/NmadoGnQXkNwFbMCP2HfHso?=
 =?us-ascii?Q?HWIsCB3MmK8O6rVJJASq+fD0dQqee6+fgGgtmVRHG1REhBnBJfTewWxjwpPH?=
 =?us-ascii?Q?3vFJJuTfC+AZEVd2dMWG4foAEYqa1Uxd3Dmwzt2Zu5HMTaAwXB9AsI3MTHc8?=
 =?us-ascii?Q?ku26jTqXKcIapCsE3uQeSWYxScVNsWovY0Tm4MzvLrvr6sCMO5iUZR5PxsM6?=
 =?us-ascii?Q?TAL/g66tPit46GdzWbNKlxn6ssNEBQg/D9SeF180iiEd7pDlRkmf+pSKUnVS?=
 =?us-ascii?Q?+Ye+hPdcAn82qJWXjDqLnWsXXH+fScnGLJcDOCsTAXrvRzdsqE0sBwSYUrxo?=
 =?us-ascii?Q?DmpW0gKJ+PN9QCd0/+43ejjl1wXVy/2jMVR0gwmeR+WqjDktDoxwqvlclysf?=
 =?us-ascii?Q?sFn9A2x+oErF9eyl1YK0uKVbSM+0ihycpm2qq2Az3vAT+iVMRGjDkwPkWAoy?=
 =?us-ascii?Q?ipv81rex8L8KP/jH6zKVwrsHeAR9OJkSXQJVqVhXogIJdvDYYPR4D3nUomvp?=
 =?us-ascii?Q?1Mry+PoimqGoaKlV1jE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b90076d-92b3-4e53-369b-08dde64c1bc6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:01:11.7298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynsF20IHaNaMECo0lQvm8uXEaRXVaxJRSfgxp5voMi10rNTDoRaHMZISyi080voU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8550
X-Rspamd-Queue-Id: 55277100019
X-Stat-Signature: nst6x5hn3uhhskfhtce14h3fxct4oxwa
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756396882-419736
X-HE-Meta: U2FsdGVkX1+ectTwlCpTBpQSLtsMU9lnxo003FmbI4bN4cV1BMCltY+yKQkSne11hVfG3fbUE6NfxWDvNM6Qc43Tx/HkfzA4Jx0jiwq9RKFlNxmGVJms3CfI1ydGOgXtjHjUCgj3cSEHYPCorxVYlzQ8t/ljmcxGU08wbsFt9xBPxO86uwntG1LYPpDv7VwZb09u81uKuK22rp4mQ14UVYHEwCTSCX4fld2+Q9se7GVraM+6awtvYS4xdsp8yH3JFeIvN1Q0f7GZS3Q8MxFrlKIJGiN66ymykeNv9eNutxY0Hdso+8otG4ClRlV6MdnwYUL6mXNfmv/kDoor7qhjnragBXlacsuVAzuaQp/NsHRO6AM+d34F1B7oVW9xkFsVbGUHxG8ZtNcD0Y9OgTYJJ7TX3/UVDKeFpSgkGmztLcuxNgVLe6KytkRRCMytj50pKpSKqT5bFB87EnvCvnB7Gs2ghTcMcPTA0VEpjmm2tTK1j1kbbXIPl22d6RBnytn4cNHoeb9lyEYW4wpx7w8k1518wpBPkGc5hzDluVuRkN73P+IS0mm6QyMp6sWjWSQKvhS7fDpWFeBv7+gKrmovzpbi4qd3o1VS8URo30XEb3pXQPnGx37XuOulltlpiU05799jpeYU3zWGCJGW5XRWPWk2rBgJrjOfUfOkfdcPwZprRJ4eVw4Ll662BmDvIldb6OuQtyTZYxhutstJeHfXgXYPQVLEEO3v1fqfR6XNlbYawgRdyKlY0lVYv0FS2g3+RlPU78aBqCyJ9kVGSstjKk6buWioFs6CHdUUTbwA+iwR+6WD3TGLoYoljozo4cU3+0WlYshizGuT82xQZL+59KAtPT5IDepZiHvlULaO+LC7Oi4Txiecoih3r4SxnwkAB+f0XspZ538fbdaHE3fMpGOXqQdA3uBhgYuAuZE4h0jMebYAj0CJUmUNyx2O1uoPXF5X0nNp/w5/GCL4IAG
 pan4PLX6
 EhpetUmB536DR/bAvMoTLucCpEojUD7w3JEEpVwJm2lCx/q+F7ikZM+Bn+N+5Okxgjfgy8lNePlc49OIZvCd9MrfGaIZZYcrHeD2Wyq9V4GiRxJEu8glhebKhNEit69F62cebgZQIspis7l8FHGIbNVfr0c+U7RITPY9Gk3nr2ODRiFFg0s/M9ZqSPox1osTvMVxi0q5oo4anFrkA+VgtJkzwLVHrNLrNPT7P8roMoUO2pIMpmWyUnBmW1CmU9l+vAPMudq1kIhLIVtmEO6LCIQyBy59zhS57DDrmM0UwI3bo/b0x3yeyO2bq4s3K9LHwqLmO6TkDMY/5/jiKevnpNx4TCu7PrFRpVpJJIgFRn+FmjjQYd6TKZ5s2fUEBu0AIArAlw91FzHLPBecWp91PtC3x/ZDBZ9PU0GwWiAGJU37TslRh2QmAKMQH5whTqbccvvoHfrQ3cS1Kjs/TPry3Yr2VZNhL2pl4DJbk1ZN8lxsDsezoMMdInEykGLGuxmOhuTYn4sur4fWdHQTXEOxUfIDkezfvYhuHP4t9eFlA/IN+KbxRbTAM6w45zBrNT9d5mRdsajRjHQ6eKprrBpVOSoU8hzDmQUH5tL8bN3uu1Zskcxd8NzsIwAkU35LivVwOSnPcqPJ2Rj7OJ4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:55PM +0300, Leon Romanovsky wrote:
> The old page-based API is preserved in mapping.c to ensure that existing
> code won't be affected by changing EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
> variant for dma_*map_phys().
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/dma-iommu.c   | 14 --------
>  include/linux/dma-direct.h  |  2 --
>  include/linux/dma-mapping.h | 13 +++++++
>  include/linux/iommu-dma.h   |  4 ---
>  include/trace/events/dma.h  |  2 --
>  kernel/dma/debug.c          | 43 -----------------------
>  kernel/dma/debug.h          | 21 -----------
>  kernel/dma/direct.c         | 16 ---------
>  kernel/dma/mapping.c        | 69 ++++++++++++++++++++-----------------
>  9 files changed, 50 insertions(+), 134 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


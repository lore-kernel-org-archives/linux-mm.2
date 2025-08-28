Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303EACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321778E0026; Thu, 28 Aug 2025 11:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9468E0001; Thu, 28 Aug 2025 11:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7E68E0026; Thu, 28 Aug 2025 11:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED128E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:17:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5EE114024C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:17:45 +0000 (UTC)
X-FDA: 83826520890.03.6409E21
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 045D11A0017
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:17:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UIZ0GZxL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.73 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756394263; a=rsa-sha256;
	cv=pass;
	b=YPHufCxNTNOmqwaVRPnH32j6QYfX0K8mxThzh+iEHZk6ZferI4kA4r+yIu8ZbAzVBnuKYO
	5UohHxs4AYv22eE7Uigb2DZ6NhgH3zIoWxuoSFQma0eXZWbOpaM572+8aC9PgadMK75zUR
	JYWmLtLlharxp+gCvKH7CZgUWqysQno=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UIZ0GZxL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.73 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756394263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Gj2EZNRr0DPgaVxIhfrzZTloYAFkHlRSLQ88RnkN/Y=;
	b=4OhklJmr89gr1N/HCeL04/Q4UY7KkblDaKITbyOT2TkXCWw3lHcyxSyowIdgcm3MAdWdS6
	xCKsEoUIIMEkQzYvXT92MHaRcxV6s0Pq09fQfJHs6UDfLsQB00NjLzHqO7adSnoyYNKJnd
	lZ2nCTulC5cHcbuxbeh0Twgm4Cd46Uk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DeFisRlfdtskQJuokSZMY5Xg0kP2ri832SWOoOxZmFyfr1hQfzKObwTm+dZ/jmzAp7YiYKcameskckoFkgeqeKsJxR2M86hxVxefTFJbbHlbo89kJvMWfHWDSwK/7Xbo0GP+iu1sr0X8F7X9m2WKLIg4t6QznLNFOH/MxS6vCOK3IPW3oyYLUg9yK0etWTT2a+s/dKUyjQ88tELxataJ7E5iLzNbugrf5kkulSCJGU/EvDMBusPgZ8cjI4kdKgZrWBT8VeRErl8D8Ri5s/0qX+BTGAQoUlsRXJ/0BnVyew7Z3j3iM+QlgZObIGJGnjVP1RNDkbX2v1H7YIjLyIISSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Gj2EZNRr0DPgaVxIhfrzZTloYAFkHlRSLQ88RnkN/Y=;
 b=dJXQVVIKxoWlQmbSqqZra4WL6Kz2zfSDPLs05lcSjOU93g6u6C66YMMC8Lt3Gk8wFzCpFvCT5ecVUr69Yz9PvqCgt8QZlH+B83dzj16RIDYQMsoCT04lKTgWQTCPY1rNP6GnD9WyIvwDUgafnL0bPZdm8DCw5ABjQBMBINbCBaiLuf7hCYi52ryeathkd22iFVq6j6zhCh3E5CMa04us5TUS23R+FIpNb8rlNq78JyS1RQyYFtZ99/2WNmCca3aanZ1jIYmPQ/OkZg+Wvu8mWT96SktYVKQjqsH52wQNa9gpzJz/G0n/q5JG6ysHSnvUGNNYmzoeUJKVqVuN27ktMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Gj2EZNRr0DPgaVxIhfrzZTloYAFkHlRSLQ88RnkN/Y=;
 b=UIZ0GZxLWq96gYKdBE/P4lQCZJ/U53VWHTY3ryAUhjy0X1E+7u9oiu3k5AoUiMUDaa8eL1b1Wdk5oukxyOCLIGxGWfEqpGWwD0WnuQqK0CWUk4Pjv6sZATLWHy3VvkAz1N6i0ZIuB2gSyRBKH3ged5fEf/orLDC4hWPRCFed0nYiRGEAkC1JX6QMt+qgnmMkpflTk5txVNqxo17dOPUe5QdVM6bbYWPbF1aOsOZApv4G9Ez+qUarJEoHsl2dH5FPFKLe1FDSweTA21KHqzfcelVf5uDwFPAMt74wpsbdBW+zyizr+r4458egUOpiKxlVc2I7emXXunUtZG0jyRuMsw==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:17:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 15:17:31 +0000
Date: Thu, 28 Aug 2025 12:17:30 -0300
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
Subject: Re: [PATCH v4 09/16] dma-mapping: handle MMIO flow in
 dma_map|unmap_page
Message-ID: <20250828151730.GH9469@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <ba5b6525bb8d49ca356a299aa63b0a495d3c74ca.1755624249.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5b6525bb8d49ca356a299aa63b0a495d3c74ca.1755624249.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: ac16ca3a-0c04-4c85-d3ef-08dde64601de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?njO48yMTkw5FBTMUHcU9RfdwduyPEqfYr5sDmRvb6M70ofOoeXEHGdq1KNf4?=
 =?us-ascii?Q?QnOK8yoCKTiN54zd+3Ivy4vhFI07qsRdXAtVykVph5TO913t+GGI3xiUDVb+?=
 =?us-ascii?Q?jdnd66i9zxJkY2od5xp8XaKem47dhOkzbyqZTg0QSTIE1Kl+JtwAQuGucH+T?=
 =?us-ascii?Q?WjnqVfoyqNqJyAXe7F4pk/eGqkOCR+KiacAhMEjzezrQL3MBdzW1NdVzexOQ?=
 =?us-ascii?Q?4JoB0upSpmTOokwwxt2bakEPV0ltEhyRe9dYQxfuSK2Ni5IBHIpgyw9/GjgO?=
 =?us-ascii?Q?rNdkK/h3qoZxtMvYY2QtRdUSkPrc4Xxm4GIfjB32jEXKmfR0gmsX86ipkdSl?=
 =?us-ascii?Q?+ImevhWLNt2q31YwRfzliMD7KZSG0HsQjlY1SSVnmAUUf82tnmqrimbEPDLg?=
 =?us-ascii?Q?eSdVfVKj7cOEAAq1+leLcYkCxGBZl12n84VymHT0KYsqW8wleBoLujozvOqc?=
 =?us-ascii?Q?zmgLDEGRinBrPJDXwZuGq2f9BT4fJm0zdrIJfns1LtxKDEMqVmDAWNh8/SgO?=
 =?us-ascii?Q?9V2fUyO5leN0oa/4AVwYmWXV3aV4V2gUOzu1EVUlutMPRpfmeGz2vW1gub/D?=
 =?us-ascii?Q?ki9V01NbOn8YGcJiX8wDYnKzaK4aqlnnVuZH9YRSeCaaRm1Muo77Uhd5L3LH?=
 =?us-ascii?Q?INl61YEAVQO0z56Kjz68QZSheFaG3KDVD5f5BEn1oRj0PzThcoCsU2k9tWIq?=
 =?us-ascii?Q?UxNTSR+Pb4sW53wbVO7DgnW1qURzXATYaVpNa00mg1Yy1LSGgkQQCjRYGBHq?=
 =?us-ascii?Q?27O1T4Jx5AHYP3cBB6ymsreMfcb/Ta+gxBBQAtwbjxMsJVU7jz88CVvQn7/z?=
 =?us-ascii?Q?+WKSsy1NKee+3h6bbDYWAOH4FdM2Y7eQx41AvGBe13AgWiTDC0b+ZD+eRZWx?=
 =?us-ascii?Q?ZwsdUsxeIZx+zEvtrxiMU5OhJJlwBlTPBOjO5wSkKX3WqPUSpjaxR8BDV2VU?=
 =?us-ascii?Q?1wx3mUKsBiRWWhdj7HUjQN53bDZFnAWV7CUSCUt1EO/Y/VTP3xsRgujjSe/+?=
 =?us-ascii?Q?BSLh/DT/4OCuihxSMkTch9BW7a3YK/5gJJyPDDblqNZ0pcDTobHcfz8DTYJn?=
 =?us-ascii?Q?Ck8DUdWdRnBvLdNHEaGz8HiqeczuoebVoyqnxnVuNzA+nxR3ymb+d0uKw4uZ?=
 =?us-ascii?Q?iKR+taHPMsQ2WzJ7cabBlBYVSqX63f6H5dMGHIn9K44bU/MW0BOeJY4BhkwA?=
 =?us-ascii?Q?QHSqhhpxargIpwGhK1abMW0zmR+qJVJuDoXc3rIZSpt8N3mkfHnb0ikI8p48?=
 =?us-ascii?Q?CwJzWANXRtAbCp8qfDMvPDcUQuWlZvAVE8yRoHDUNhguvACqUuTu6nDAg/vQ?=
 =?us-ascii?Q?t5GGhsyS4K6VUdYb16hY8nIS2UJkrMLqTASPdhZdqWPT/P3qqDThBqsezU7w?=
 =?us-ascii?Q?ckjS0OwVRy8YboJ9/UkMDTqTRY5Q2TSeLuYkVmRNbBTZUYbRAwnlOakGXQWO?=
 =?us-ascii?Q?xKNTVNVhIIc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jdNZg78XP2T9TUtHO4FrQOYHXwTm5pXMXy4+gH+6XrSX7+gSRUdR6SOGtYEH?=
 =?us-ascii?Q?HBth39Oc9aLRJBNWgk7O8lPEICHVy+pfoNIpyct5Rj3WezAlVOXAvl4iRCzg?=
 =?us-ascii?Q?VRcyxl9TvcvDq4wWiG56ZTJlx7IDlObxlQ9JuyPvdbibioMEpVIfgfJGHkB/?=
 =?us-ascii?Q?B5MPYLJACoNIJH3MHSn0DW2KwM+6yeEyfC9LQ4PqD9PeN7fmLX3u/JSRbXIy?=
 =?us-ascii?Q?NAXdRpAs3wuONAvSTzn+75geHNCvqxmuFmZLoEz/AqX61KOtRvg93Ee78uND?=
 =?us-ascii?Q?peUCkwk8Oy09PptlLWkstUOcVdOS4my9pSfWso3H/0IROqZIFLkKoDoNkwcv?=
 =?us-ascii?Q?kILYeC7kNf+VH6z19s6jkr1t2zH4PtxftHk+sUqKCeX4wQV7ZJ8w6+ko2CqB?=
 =?us-ascii?Q?iEXLEDSYPg85+Njc5Kaw6p7ej/9nB5LQvS3L9gSNVGzPX7fiPT0jfn+sbDwA?=
 =?us-ascii?Q?zDo1NrvIGE8yJgrURQyQGI8NGl/gmac6MSrfKEyE2wYOwuihBg+52zpOsKDT?=
 =?us-ascii?Q?zVPQGuknFn6xhw0ULIhgilBdsMTevgwlb8qik+1gJ43vwHxDHCa2Anp9iHQk?=
 =?us-ascii?Q?TJLSt9NQ1qSa8R2ssZqykd9si9z9ihI5/MiAuuMbmYKUqklCS2wrGtcSAl9t?=
 =?us-ascii?Q?f7B56uwj1x2ObZAI4STPBh9GoCG0cjFA0CDbaCzesWcfTbERSpM84j599A3A?=
 =?us-ascii?Q?7/pOpboO/5AzqdZXmgN3iusPK4ZsGs3PawOZNUKRjdOoMirfvjsNjGaAu3e9?=
 =?us-ascii?Q?mHR5nsa+ehX36f5u+5vBZKoaCd7cliPg1DxHMnaRcEKCzF/+WOoA7I23qLG9?=
 =?us-ascii?Q?WWME2fMxQsO5zwF5c0bzvTXVO6Hi2XAQfd98biDYJK17A7m5+17+VtkU5337?=
 =?us-ascii?Q?YjFKF/V5Pq6THGrsvVlUSNoNyIG/X0vgCedtyw+iebNuNTKeWWOyklAbORXt?=
 =?us-ascii?Q?2JUO+pW6trCpPpIAfhnlNn4EQ8nX8WAiUMIdLmvdkP5pQpAQ2ATG30U5vkJI?=
 =?us-ascii?Q?MhRMHPJ1FVQgx7yYaRYurqh8qUxc8NDRXR1mXSAO19NQo+k9y1rbWR+JlkLG?=
 =?us-ascii?Q?FuzY4iQ4QiaZwAIKT2jv0ZXztWs+nnlZ2aIG7UdiTK++Sl77Fx1AvE65Amt+?=
 =?us-ascii?Q?Y1875MWrBCt+Wn7UE95WSo+fXxDYboAE+E8BZ++FSd91hEpKBaTazy5qHd5F?=
 =?us-ascii?Q?GvYxoLDevzvJgY7AqRGDY6RqRTMaSAgYOTnWAXVJEqiXjStCFQ2xk2mhoZ/9?=
 =?us-ascii?Q?4O3blNpfVskby8PNMgxF4LDXhmAmGIZ97qQgKAQhEvx9H7K+lpUR9d5i4ctY?=
 =?us-ascii?Q?UMUIVKh1YqIgWJ7ftzcTNKMbIvuAu44IA5qQLDK357xwY6CzE+ywzliWXGJm?=
 =?us-ascii?Q?L6KnQLr6kD1VXrLjSmlzT9MhabxD2MryJs7/a9RtUr/RmwVnntoTXxdp1NJG?=
 =?us-ascii?Q?IZzy0C2fDKu4I01dJA/qvtIZRvPDzy/WptVch3Jg08J+u7E1GsZKopGv3DLM?=
 =?us-ascii?Q?lCw0VQ+/cSQbw0BhTD4bvNTf8wfDSAMKWNhgcNrXutwByTrAMqSyv26wVxme?=
 =?us-ascii?Q?1DqU5O6tlVCU/VrZBMg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac16ca3a-0c04-4c85-d3ef-08dde64601de
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:17:31.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZwuEXlW337UFGaRmTgrOOZ86hQJ0hssTlhNBI9xQ+44PM8OwEdLJrn8oa/w6/tN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 045D11A0017
X-Stat-Signature: 5pwi7tkgsn1c5xgzqmswqyiwyut7rk5z
X-HE-Tag: 1756394262-14276
X-HE-Meta: U2FsdGVkX1+/lNAPNrjeXz/m3k1VR1TbFt0Bw5X540XppBK3iu6NcW1wyhG/+n9sYwDPYuAWVNta/ukJPwWpPylI32LJmE9Wkr/QlgO46zY58qyUHjUVtbGDybYo0a3zBFlzHRR6Pf03iLfpeFrn8z5I99Lq0b8E9uNOpxBRsl0jGk/FlWmVE/wtS4gS1P1RtAXcjk8i7CnOMb2tt9s5/3/4O0oScytiPtYglfQ9mPwDAOnYlB6SW985DnaDe4SX/1INF4b25FupYl1jLQLgts+e9NdaPTT2j45KSr9e0PREK8XrixzDzxi11hZMtieqiNtxGEEuajevew4L9q0GKUezsFY8IgkmtgoFPoQK/kjN2zEosBuKvW3FU3lAG9ZHlsqBT26AP84Xg+6tdRHZx3745FG0Y4GS9N9Dort6R+7AzUQR675Mc/CEnBS23VfFNlC3nu3RvZO+g3EI9R5irVVKAlfhZNqtYMaZk6aAnxnfLlGUb69iNhxVJosxtZcLvMbcXyY0qewEH2i6+4auJR+xsfG/Tv6jt/aUMdNyRbh/jvYKx7ZvEqBunDIhMPwONcxfGkAj1AvgwjbyOBCsqzbte9AHo56iFaeGVJt6/LxLdiw0tIkS6fixKlU+ZSRKvtXdR0Ey7jRB4DTaofI1RZqmP3vFnTXP3niVVBmot/I7RCfPkwMH6xmuInABn4uVlZUSc4wowl8rz/Xz2IbWwM12oVphCC5uEK+fcTSLekMCD7KUMmYCku7Q3wOa79YDbVONEcW0z8bOD+FnqnfmKb+wtDr5pLbv6bM6XgVf1qEGpR7oK8m7/MUwkmhhf1u4+GPD89aIahrO2Ja3YEsKI0lqMVoj6M3VSmqTbAhnZaorfiud7VSRnW74LHph6rbN2xekdnCT+kLKNQ8NYrxk1dWxg06d9+dUubnHg0D5sZdvZdHWDWNS/JLU8zPSc5FBeLhUpEXI7HdLf6Fw10/
 BI4GG5Tj
 HPRkiP2UxaIbDnSfwj7g7XQqg9rKF3AXhnGxR9InD5kXXwx1Ytu1gPpck8rBwXQmg0dxUCMw0k1DTi9qAqz9+IWrXi1m3k05HxVvwv1TU1JDpLpE4eASkWN9TZPpCBFtXKazpa4T3ck2E6or9tqxF5lJ1/BbskQOt8R/dWuVKthdmOsf/duIO6vpw78D/7dLEXZ2x+74RLGUfZ0dExISnA8GlHCC52qupXQqVA8gw89SgU+PZfpxyrfww4ak1fwgj0f4kTlcc6ypN8QLvvRzTcWNgEeuKbXNz9FVlXkDPqKt0iPoaOWdSN/uf+AA9NQNRj2ppWe+OjLOZ2WqO72u84qA61EoVY2fJncCP1xi+j9PlPKuY5Vs3WaP7YrSpqIZiQsLEi6ZUSb8kCAuwIpBg+ilXn+4akvcGgghd7KWAnU182J6JWBQYRnCLX/yljT6j9vCOzJwct1uXyLjwpnLaiG8k4jKsuU9KPMzDBQhg/KKy0uFPVrlH1D6hGzdDVhw6lHP7f5Ha3sizuPFGVrDjAJw51ijGCTJBoF+uUOtjaXzaz9VkixfdfKmOv65wJuVpjEVSIw0J1tISs42AOlk+qHx/3pwI1aEd3i2qevaSYQK/bQnMtWGQDL3gfhY5AlMGRoNTUd1s8KF9NLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:53PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend base DMA page API to handle MMIO flow and follow
> existing dma_map_resource() implementation to rely on dma_map_direct()
> only to take DMA direct path.

I would reword this a little bit too

dma-mapping: implement DMA_ATTR_MMIO for dma_(un)map_page_attrs()

Make dma_map_page_attrs() and dma_map_page_attrs() respect
DMA_ATTR_MMIO.

DMA_ATR_MMIO makes the functions behave the same as dma_(un)map_resource():
 - No swiotlb is possible
 - Legacy dma_ops arches use ops->map_resource()
 - No kmsan
 - No arch_dma_map_phys_direct()

The prior patches have made the internl funtions called here support
DMA_ATTR_MMIO.

This is also preparation for turning dma_map_resource() into an inline
calling dma_map_phys(DMA_ATTR_MMIO) to consolidate the flows.

> @@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>  		return DMA_MAPPING_ERROR;
>  
>  	if (dma_map_direct(dev, ops) ||
> -	    arch_dma_map_phys_direct(dev, phys + size))
> +	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
>  		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);

PPC is the only user of arch_dma_map_phys_direct() and it looks like
it should be called on MMIO memory. Seems like another inconsistency
with map_resource. I'd leave it like the above though for this series.

>  	else if (use_dma_iommu(dev))
>  		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
> -	else
> +	else if (is_mmio) {
> +		if (!ops->map_resource)
> +			return DMA_MAPPING_ERROR;

Probably written like:

		if (ops->map_resource)
			addr = ops->map_resource(dev, phys, size, dir, attrs);
		else
			addr = DMA_MAPPING_ERROR;

As I think some of the design here is to run the trace even on the
failure path?

Otherwise looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


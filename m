Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E42CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 23:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAE68E001B; Thu, 16 Oct 2025 19:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3098E0006; Thu, 16 Oct 2025 19:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A19E8E001B; Thu, 16 Oct 2025 19:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35AF38E0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:53:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B669213B087
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:53:42 +0000 (UTC)
X-FDA: 84005632284.10.B818B1B
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id E04EFA0008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:53:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sExZW6CI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760658820; a=rsa-sha256;
	cv=pass;
	b=SOghgAqOP7RZ9un7xJjuYI1QEkYlszAHAXoZEblcohFhhu73WNFgy3yJEBHG4A5UOkW9AS
	ffZGHONsST/KjxyEkkney4i783hkqC/nSgzG2Wt9rqxsk+akLgYcj2W4FINcYqFys+TIF4
	KMYKp9qaOGOycHz5VuqYPtco5ldPJ/Y=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sExZW6CI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760658820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RD/xCVRTrLeDxfGMCtcUQXjf8Hu5gk0sMVUTLPCchq4=;
	b=3NbItD0u59MA7Bj0L78fioo5rmA8uj1lr+nWSHZ6yNz20PogUPxmA6d4lW0Q75btjh5e4J
	HD0w3w+DXeAVsgGhG1C1wMKd4mXfG5hzPRiGI3euRS4uJ+ICAJb1DPwSN/flxqklVvZPZJ
	pQ3+p+RFmkYoUOwMmARYMywBSCMYbz8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzVw+V0y3ntpsI4be8b+hKVS2vjN3qfKRzjVB8p7LEr1ciZUJBTPxX9xEm6FrBcISrwovEZDKvAwxYLI7mu5sam3aJu0JJo/bU0eT7ThIcggJMGTW79QktjI93zODK+TSFA6GnzsatvRtOzpTHRD1Qdbdz4knCyG8gKOwn7W6YeXf3aDyKUAv/8xDAIDdxjkjee+ReKwqsXmkc9SPS8F/XhRvp4kWaDC1YFjd1M4znnjPJuEhES+Q91xjBThuP2EqwkIjG/OPTVkbtHyvq4rfz9UoaO8ahlOpdPW6tLlztXMA59WmMRVOzsp9FCO50l5KDe/BeTDz3hULqQJlXJByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RD/xCVRTrLeDxfGMCtcUQXjf8Hu5gk0sMVUTLPCchq4=;
 b=G/O3XDxmPm9fnTUeM4lVCSRolYgasAohhCMPMOcQBgCG+tHD3hTqLenj9TiWbCyLysciJGmMWAVXacJukpoHPyDPd//LfaYEQtURtCnNglSXeZxl3YRM/6IrVor9e1L+Ifj79YaKc0RST2K4CUkk1W3c2871uuc1hkchpYwQLVm0uKd1x8LjBx3QUFC0zftkemzQfjGFWFCBdCWuVpl3u9PC+64DWE6SYS7b3yD2GiwuTuHFFh531MN9P/BbKJlYxcQzoaAQnzjOwB5LokDcUXYNrPWynItUWAiLYvfNCgjEfbo2xzRhWV9DUqSdDw349WsKMA4mXEsfZrnE3baAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RD/xCVRTrLeDxfGMCtcUQXjf8Hu5gk0sMVUTLPCchq4=;
 b=sExZW6CITN4sB1IKBxwQfti39f+DtUoF4um3BD1Hzg8j/ajAdbhhxXNvS7WQOHdpgK0J60tKbJKGfXLJCjyiLOwWrCmDJ2UtoKZi9A+Y2bOYM1cwF6Xza/ArVXH4nmxwNePYNnINKoA/DMkaNfE/uBrDBMtkiaoa7xX55iCWpOWRabxrV8N6v97viCY2jKL7QlPJcOYqvXPLCITHFURKrnpzPc5/Iwmt/knV0euWC8vQWrfEBIHll4nTPWnxCp+2l7auwnkyZkCNt3rDShzzhf8a1a67bvTrgcU1j5P/XnV/YgYY/3MhmDjcxumjuqCPKv4YF2qvDG1pD29T2qSc/g==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by CH3PR12MB8903.namprd12.prod.outlook.com (2603:10b6:610:17a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.9; Thu, 16 Oct
 2025 23:53:35 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 23:53:35 +0000
Date: Thu, 16 Oct 2025 20:53:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251016235332.GA265079@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
X-ClientProxiedBy: PH0PR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:510:f::11) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|CH3PR12MB8903:EE_
X-MS-Office365-Filtering-Correlation-Id: 18b9e1f5-f067-4b8f-547a-08de0d0f37de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rnGVBiR43qrrkw2KiPc0VorIsauBwV5mCkT6wX5E2r6AIUy0QZ9igCmFyYHS?=
 =?us-ascii?Q?iRRyHFQCo1te+/o8kLfhZF+RdMCWA2Mla7l7OFLDsFmB2UlouEb3v1ptWRKE?=
 =?us-ascii?Q?kOH5Gyt9IXs60jzqs0QsMDKrYcq9lyU/O+cNhylM3Z1Z9jo1ModPpdpxoBsL?=
 =?us-ascii?Q?T7gxlOhV+YAQj6v6aiU/IArK6oPNPxDN7QFcVKMHSLG46GTeQhasQLc5z39s?=
 =?us-ascii?Q?/A8CK5RzujiZBcUHZ2zLH95K709+oQMV5SULDxSkTCNsWcO1IToYNJJw5kpA?=
 =?us-ascii?Q?oR6bdR0j8WW0xwJwLAJ3+9SVuiErXpSAViGk8TylRYn7FJDYkJnx1OqPbMdf?=
 =?us-ascii?Q?3U7qQOLNtNekAR58V1ZcwuUSic84dqW2E5ja2CHTHdcbvRUrfvYlhvCcMsBy?=
 =?us-ascii?Q?pMQs9EUQ6mHO8e1AkujRDf+owbgyIVaMCXbjLUcHb9lM7WKX+0xOoQHh6KDn?=
 =?us-ascii?Q?0hDL9XU9sCYBdS3E4FhpUhtUXVai2OuZ8IO49mIifcOlgZbE3KRt+h0aoCsU?=
 =?us-ascii?Q?0ZikxUQHm0wRhKK5iVwE+b6OPI6faBy4ULydJOgAxR3q4ieXyilbQPE03dm7?=
 =?us-ascii?Q?Rhg2CCiVoEKgDDIEcB4UtnIjIQbY0TIcGaIPsxslfxReKGN2GDT7Fv495ef+?=
 =?us-ascii?Q?SPQlOEW+Q9PHW3kmdSd/JFT57VNdHBuWfwx2IK4a9vTiRTkAt99y9r1gEF7r?=
 =?us-ascii?Q?m8Lf8bhVuuOcknXYz9w5FPF4/iiDth9s8+GRgiRfn1ydce5OokHntgQtfGtu?=
 =?us-ascii?Q?cZucSiOQrzw/MEYlRqoi2I1cVhvCOZMlVvUjna9glu6vkOxAm3A/A/wqEu8G?=
 =?us-ascii?Q?Z1/4ywpiOpplfVZJeqfSYn+KAIRmUxu4PMmsRQuG9MvRrpQHfQx8da5VOSlM?=
 =?us-ascii?Q?6uZGuTOmmypbxV+k2sI/v9oRiWDJ/lHtBUSnzAwEL9xQldTVGbgT39R7Hqnj?=
 =?us-ascii?Q?fyeIfBsN+uTzRcr9Ko7y7n4to5keywpEEjekmxn3WJ9JZE9AwF1RW1O9ZFWH?=
 =?us-ascii?Q?fGfkliw5geCNy6i9LXOW++IFdKskAcqfT+YzfSZR9/fnQcWrycqmbUct0Njg?=
 =?us-ascii?Q?NLgrMmMwFjh/22T3odvVKoMDVQPEWpbhgXFQ76MVfOqfmFJ6hjZP4Spktw6P?=
 =?us-ascii?Q?PpczAYp7rTR7bteEvuQPks/AzeoTBMCqGZIrvCrtvePGJMwATx3th3LQvysU?=
 =?us-ascii?Q?OuYov/VwO5KlFHKCA82Jm9DQVsX8eYl+Nd9j6JPXjXs1jLGMuGhLSk8jWeZD?=
 =?us-ascii?Q?qasp2rmqmTZZO77Wbq7y77MCn87Wz1q+U5f5i5xsymCN7LsCUzrJk/NLvekY?=
 =?us-ascii?Q?fI/oilB4mfSG367kcOnBeJ1JekvdXlGei+asIFFhxHURgLzgREmnoUu7HORG?=
 =?us-ascii?Q?24zy4o64oyTZvkv8nQWXjkN41BDQdlJyo0lgD+laCZKbyPD/iPHD9DoBMxNS?=
 =?us-ascii?Q?Y38c6zxsUkchGex7PoJ7p9sNxjAUMunV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?39IpYg/hgaPLPdM27s4mQS8T4DJCdcelKREpNEih5CqGHfhXY25GKB7FQpGU?=
 =?us-ascii?Q?1wlmQI1GBdWNOP2xQlsOerbQgvvOfJ3Ys0l0F2CN4wAbec/B/tTmtO6ecuBa?=
 =?us-ascii?Q?ZHTjeaxpUy7tgyO4gXdj69R8iDMMFtTm9eJIfF1CWqhx7SaCPB5E54+fQT7Q?=
 =?us-ascii?Q?/cOJMt3+zPqWjZHa3Oz8zpNOgFACOD/qrDZwmk5ishyCk256EsEs6QZaaMWy?=
 =?us-ascii?Q?9dn/42TJCdZGLG3mcylwCP6ZI5C7/famSHJ8QDG90NFySPfIPofgsXMZHB3M?=
 =?us-ascii?Q?umeWJuvAqPPyENcHhzRHF4b0ZZLtqzGAP5Su8g3dXM15UzlCjttHbEVe+9pH?=
 =?us-ascii?Q?jCevoFiq1odNZgD4ieKOiM9eFTkta6N6qC/AiGwsnmJVyufwkLQocZSiHODE?=
 =?us-ascii?Q?ocFHHWES0WN0/fziKRTiCW8QGBsJuDBlqOCaY81eJcftAa9G/PN4UFQIwBuw?=
 =?us-ascii?Q?0YVff2+meD0rX8wOoVWkMaYy//C4zWaSHVkQFnr8y37kmnUxgfs1kLkyVbDa?=
 =?us-ascii?Q?vFy8K3H7sZ/IXh21RqW5vgjyGMA/wN9FsKsFIHxm9QugudMxOhedDzaxuiY2?=
 =?us-ascii?Q?vhbUoDpE2D7BA9w9N74SQuIfxPyuBAfkVBAqZR9knFRCyWNYulL0NpngHkMr?=
 =?us-ascii?Q?+SCTkfuzRDbi6cWFRaKnU69MfcAPbCPFQaSQaDvh+zO7nUrAg5IotyFrq/zy?=
 =?us-ascii?Q?lI9Nfo5tGVldpo/OXN/6ueqw/c08MIy/d94to0bDEZmcgolNb3WThtIAdb0c?=
 =?us-ascii?Q?7bUcjrbtWBZ8Pwc8cS58Cf451bo3qOE+S8Aik1QoRvy28QEJC2nDO4Ku14rO?=
 =?us-ascii?Q?Cq6Au+4VsunJDDL+OPYQaamcNzbfil2Mb3dtrZx78f4frebgAtjmBKGpFmI7?=
 =?us-ascii?Q?9JIhvsZcK0au8oKnqXlP/35aiQQjWiZp2JGbKSndAuBWHZrE/rrmkvNjEwig?=
 =?us-ascii?Q?YwQFcjmQuQshLmhzp9bJYT3vAtCG8DkWBPQH0KPXg2Irhyx2SQoLClZkafh9?=
 =?us-ascii?Q?L4EkHye5uSok7uIh5D73QDJsavp0yFmjets0ICGn5cBcegZuNqHkuxHUNEkm?=
 =?us-ascii?Q?IMY1+XvKkSmLVmJgXo5E5i1SJJunZNgjmvlvSSoaoqBtgl1LZgTBxSr6TsdN?=
 =?us-ascii?Q?7wdhLakRX4rHC79s7tQa5PA4VgffcwX1qFIy5DmfGhGPKwqfwdCARAeWYfY1?=
 =?us-ascii?Q?NLYz0gXnWnUAyfmqShrTv/+fwrI3V/cXlDzrcIDQ6k2KELnd/YAibhpx+Egt?=
 =?us-ascii?Q?8RMFrg9m64JSPabUuAB9hZ0qzfSXcO/+B9f0AYsAoaxhuh3Zx818c4yQP9gH?=
 =?us-ascii?Q?z47ukY2r93USzf4G0+vqDqJkyODFn7WoJ7KFndaPjdTwyvqZblWlbvuhjd2T?=
 =?us-ascii?Q?1MpBvmLzDHzzrf89WCbIChjPJf9dPLnhCptzEONgPbPGHFih3yZ/MhJ4cyYf?=
 =?us-ascii?Q?ONaqS03P7jo5buSVHmZrTEKgq6WRs63DXLlADkt7cxXWsLzLQN3l42PyuOEu?=
 =?us-ascii?Q?IaFYjZwxhs3//Ny8OFWTTIC/e7Nq7KmK8fx04IDaXoWBVz7XaVCO2QtPrkAW?=
 =?us-ascii?Q?slXOzxFYhCDN0lX0KLSZQy5LNnclfs8SWJ45j6MB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b9e1f5-f067-4b8f-547a-08de0d0f37de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 23:53:35.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jt9bYDuyBbkaHgYqsT62+FAa/0GFys7MoQUQrQy99mNhrDUn13ZL3GVgoxyajCEU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8903
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E04EFA0008
X-Stat-Signature: 3dmsfym119wox96u8ft3d3q1dg9cauk5
X-HE-Tag: 1760658819-292971
X-HE-Meta: U2FsdGVkX196PJvaMTuCU+DtQwmrsIg4QPmk0N2WM9/GhLcBOZSq+ImSPXaHGrrP1hjiP5A1RhuCMuuXGXntVJEZSjnU2Duaggzzw8leHF3mYzheTVuMqowFLg2UFFv52kXYsX3zNHWN3sNerDeXNtej+Vg0gP7vVyNyGisYxuUGNFM9MCz/T+rJTbENwA7PMZs1uLGZyE+ztPtBmxhFG3uEb2p0asUId4YQfZzhCjsCum19QYof+n1GC7NH0U2UIcPAlacWeYvfDi2pErYc5RnQkBshlShwSigstJ5tmc3j4hxqGxO0dl/NwEfd9fbwivYXaZsPMned11EZ4RBadjZa/Fr31tX+yOQ5LTclTJU08fomPXgKojbt1BT2c34aTFI6mKVDZh/beIJktoZRgSnAmeYkRmP89i/WV/u9MGyCZf8kkb/u7AAzrfpwavbGn+Lc/6PcMg+LquJH1cqUWmbJno3+H5/XL+3benaUraKYlY7ubBKggEhOXSzeqFDXuCv75yIef9xoBg9lbdnDBvKTU8xGetRjcTyoeVchA2U+ZBmReKi1qrxI/gyojGpRAmf+Tdtoy5au1PNnRgyF+ZRW7rT+kCXBF0igShYWJHYZm6yTfKxLn1qUWkilkOsxYydj1vAvQ5P70RUBImeTMmuNXEz3N2h1B/QsrOU5yXE4z7bf+w3I0uyMztRLEwsJ/RCIdoYKuqt0wbmBi70p0E1l73GMAZtvWLXrjr0f0hCV4cpZXh+GwYZb+0KGzx3K0TsTXSMb+5kvKiYTO+rlVcXi4C6NHgVLQq72yn/Lufa2MDv2kyaGdOGUFJOCCa6+pg415SkI+JouopyR7akGDKIoGKocdtlxOWpxGxeAkEFQi2LmR8QPDMlKf/xrxDwbthFckqr5dhoXN+C+ucpYewGXj+rU0t2ozoWtUfFuK5VZldlQNF51Ifq27r7Qo09h1rBMIkZIQv2WShEoPs8
 EV7lOgei
 9+IgjPsn3jN2UliT6x7ZDf2T2ro4f/fyPy2uT3jNGREbTATNEii/hlH2VLnRQsPmLhKzC1YXGxvLw7KD6U5N35aPXh50/nkh58+NonFfq/ngHfcHv5T5nURQr7PSG+ke4h7Y1hhczTwbR0XpWm9uxaK/wNA5fitGQEDWKZ0bDTo6qBSdlmF74AjUqm9FTszHskOPq0dP0KxQYs3ypMwrj3Kzuo3Q3RqkALn7PCQlF0n43LizWmuD5dH+p0UILT3hyapB5EEgh5sdLHLrCV+S1eu9Ghdrg+jhxbKW5q0QxALNUcMzUpzBawSlI5IvtbfSbPDqwcZHSJix5lI3W0QYNv519yW0Cr6j9V8Lu/cmWbX2baYWZi6yn8GZggeqFnvZNttQbXZjMQBPJlIgoQ8vCjJJ3XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> +
> +static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> +				   struct dma_buf_attachment *attachment)
> +{
> +	struct vfio_pci_dma_buf *priv = dmabuf->priv;
> +
> +	if (!attachment->peer2peer)
> +		return -EOPNOTSUPP;
> +
> +	if (priv->revoked)
> +		return -ENODEV;
> +
> +	switch (pci_p2pdma_map_type(priv->provider, attachment->dev)) {
> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> +		break;
> +	case PCI_P2PDMA_MAP_BUS_ADDR:
> +		/*
> +		 * There is no need in IOVA at all for this flow.
> +		 * We rely on attachment->priv == NULL as a marker
> +		 * for this mode.
> +		 */
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
> +	if (!attachment->priv)
> +		return -ENOMEM;
> +
> +	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->size);

The lifetime of this isn't good..

> +	return 0;
> +}
> +
> +static void vfio_pci_dma_buf_detach(struct dma_buf *dmabuf,
> +				    struct dma_buf_attachment *attachment)
> +{
> +	kfree(attachment->priv);
> +}

If the caller fails to call map then it leaks the iova.

> +static struct sg_table *
> +vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
> +		     enum dma_data_direction dir)
> +{
[..]


> +err_unmap_dma:
> +	if (!i || !state)
> +		; /* Do nothing */
> +	else if (dma_use_iova(state))
> +		dma_iova_destroy(attachment->dev, state, mapped_len, dir,
> +				 attrs);

If we hit this error path then it is freed..

> +static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
> +				   struct sg_table *sgt,
> +				   enum dma_data_direction dir)
> +{
> +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> +	struct dma_iova_state *state = attachment->priv;
> +	unsigned long attrs = DMA_ATTR_MMIO;
> +	struct scatterlist *sgl;
> +	int i;
> +
> +	if (!state)
> +		; /* Do nothing */
> +	else if (dma_use_iova(state))
> +		dma_iova_destroy(attachment->dev, state, priv->size, dir,
> +				 attrs);

It is freed here too, but we can call map multiple times. Every time a
move_notify happens can trigger another call to map.

I think just call unlink in those two and put dma_iova_free in detach

Jason


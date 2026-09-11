Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7913CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893796B00A0; Fri, 11 Sep 2026 11:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846546B00A1; Fri, 11 Sep 2026 11:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CD46B00A2; Fri, 11 Sep 2026 11:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA416B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:37:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8169A802AD
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:37:18 +0000 (UTC)
X-FDA: 85201885356.26.9A9E16A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C585C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:37:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IA82WWvJ;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789141035;
	b=iJOjxcQ19br5cnH2u9ZX7y8cIXvL6EGO4os/voOC4JgUDOwUmxgTvnZ+We8kQkohZ2FwJB
	/qlgTkFd3skQLQ0p6dm2gAQOLK1uFjO/OgKl8VokqHY7mcZlz9fMDiV4EVuh5Zwh9tZAv8
	nyb4N4jiFUrswXdMwEGa9X7mGbURP4g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IA82WWvJ;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789141035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vBxu9QTqT9xwiBzCnIFr88Ct+PZYbRk3JxdVkP6qfY=;
	b=qCfLv091kuSIUK/Q4a0APhPuulWUJSHwYd0obCHQt/8X5AZRCpMOHpDgpz1xhcqq6qAm99
	FeZkUgEElsC/EN6F3STxbnQe7AWkAebj0s29CR+b0UJ18j0z7QR0Z581j5+IxsBU+cGVit
	Go1xF2m6NFmaWQ5aKPRQjRFx7kTByyg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4L5j20T4YFY0ngGBjF4zlvjWvx/W0quX7Z/FFaVY7nYyCvdRnrGT6w2d5P0msEqDwpobtV8KkaSgY536/uMW6ReL78bJjy/mZLl4/X3k4/yupVm1Bm2ABASaqfVWmkETKtsMU99y2lxVOc86TMxEo6I4JIJl3MbHeaLYaJKflUmW11/d8tNJ6Il05Z2DcEzDREPcQePKzZryAGFp/ocI5Tr3IIJ7e2mMAZYjgZ7SOlev+XPxwzXgrSoH1iXYP+sL88W7mHX2bejBzTtbdlibtkZzUXQtDO9Cd7GdqM/ws/k+b1HrG52vo7Lztv9fccxGKhJtWALgPxXp8f4Og8z/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vBxu9QTqT9xwiBzCnIFr88Ct+PZYbRk3JxdVkP6qfY=;
 b=s9ai24mPeTWVAwIrm7w/D2kyvIMOYPnj/NYgWh5zWmsHfNIoLu0cLIgO+CNjScLY4aS0sxx9MJYcr5mYsjvEihuPdzi39Rf2kHhHWD8yDi1RarS1FbqIA0D+BTAbM97i5dNaDeRhBeQF3FPFmOZA3yUUeW+EqBkQFTV9OuWuzSaqCtL4RyW/4Z5T+zZUSvZWZWuUeb8DMaAdei+Q0F6Huu2MQqaO2Y8PUaX3c9r2hX31qhXWOxNYYxDKQjYet3igoGf/c6FIbzZEKE/Cwv00tTD+n4NDOKLXYqo1Ww7FyPOG3mypId/V5+yrHEtgKGc6Ov7h9uLKND0kHvsUpIvz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vBxu9QTqT9xwiBzCnIFr88Ct+PZYbRk3JxdVkP6qfY=;
 b=IA82WWvJy0vncmsOvW/zQBIroYR9kKjFjnaT5maVRT4ONmZ9IK02P/WkA/vTxKiXpKVLr01uzWejxsd1V/jUBVGaSxUh+jE4BXZ/hF3m9SYmcfmn2KItbm3zQlgy3YleG68D7H9NLw67EPQP6eboji4BR2k0nWl+ztTT6xAKhSsivTKL8rPgsSSQ4AjDOrDtJfhxD5ywivGKmMYGeE4TwVD5PsPq8e+rRAE2avWMykmpOgCqS/taEAzcnVqiKU69TIhd2sIedqONq+Pct9KUiIrSzqyF6gwqiVlnGoX2NUQnxeD0CV2/NeMxNx9PpGjiYcspkIAwUtxBxADIX9lylg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 15:37:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:37:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
 akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 willy@infradead.org, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
  __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 11:37:06 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <ED9E1F18-6BBE-4E61-89EE-2D513EFFC12F@nvidia.com>
In-Reply-To: <20260911142102.2294202-1-dipiets@amazon.it>
References: <20260911142102.2294202-1-dipiets@amazon.it>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e35f232-18da-4c3d-2db6-08df101a8771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Jp7U5bCXWaPjFlDWxAZMResXz/fRQqkZOX/Q2axn/u/9XFGoBGkfV7Twh0y6lc7pVbUnW20azPuUKLQQ41jzMXkRVAatB2WcfAfjztQsqoZg21Sbd7a3QLFeO7WWc7TgKPfCf1dnhlsEbCbbBzugO54Woy32pRxACWLJZvIDymujd37Bz/QR8sbRRrLbHnsysBv5Jb9a9bDtT0I5vJ3lhbav5cXgHl0hqnWuHiWcNQZEA6J37h7crwNVQXCPLmv8SNknCKXBvDJhQBHVHZ51Kkb3DV/34nCuIQZzkZtADpRhTTYIqPtpGUa6NtAs6bTwGwOwiXzX6g6inAVoaD4z1hrMQkvHWXv8EPbfxwmJBnAU986SOf0Dibt9Pc0lVZ3W9nByLZvCcPjzl2X9i2GjCFf5QctDAtEsIhfd7O7XSWWo5YrG8JEyOAANxjQcAbhZnC3qxQs5haBSCwiVldzKoDLzaSmtK+B2ZcVqs/l+CP/ATffMCGQA3U4JB0igaizZg348qBnFe1ctWAXipSQ7xms84A34U6Qk/r58HDseEoZEpOjIKAF5FicL7n0iKTu1+Tna5mj8LPWF1/7T2Gn97IBAIK23TjZGfp3X5SthFKAF+6De3xaptStYHYV/VNZpMP8tnz/cHM7lDEteBSsPPJYCVokTTfCQEfCVZK1bnSs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPWACbVI09PQtTEIAwcYnFLCnf30Dr0XRTSxFXOA0fVIUKxc137EJkXBKAE8?=
 =?us-ascii?Q?UUXHXyGpP3EmfufDU778jRfuS8Xxlm01ZWaOW2TriOaZyrI+oAeSaHt8XfWs?=
 =?us-ascii?Q?e7YuNH2vQhoEpAQZAjkaxkLB6LzLfgjLq9CjeFn13x6rRWR29mKRZ7C5zZxA?=
 =?us-ascii?Q?5TTv1VpMJe1lPVOoyH+jy3Awb/mNc6m428jKGBlFkmyc8TZd3yrZZhxMhTSU?=
 =?us-ascii?Q?wQnZDp+4yAvr6Wxyxn3DVr/6RuQ3xu40h6N6VwF3XYPaw63bu7IdFM4HuFpX?=
 =?us-ascii?Q?oDdV66SfY+VPcjkwhb/6r43zgRS4Bf1Sn+RspQri1njTfknU877MYgWYTe5N?=
 =?us-ascii?Q?dhGdd/0bQwce2VB6j72xX7NNUueJEyyp3AtKWl+errgsRyj0QQLU/zm6JGLg?=
 =?us-ascii?Q?1urL5f2Ca5Lm5jHZIDe9LFbX/1r0iR9W7Ipng0M+48DlKDBW0YaENkBDnoWM?=
 =?us-ascii?Q?7NGKP+Vltx1+I58ZJjpem0I0ORUgBOlEzXrz7zmjP7S7A2+uK+b+1aEosMxw?=
 =?us-ascii?Q?jmuQ89sBFir2rYBgVYjiPQn2400uVZgvdXAOvSP9kFXwXVvNsfaAwvsrJg5n?=
 =?us-ascii?Q?4fshBd5y1wpRrc8SrIb2tcY4B55r+XpC39kMoSq6YhCeERDUbihFBqUgG74v?=
 =?us-ascii?Q?O+ZUpsOCb91zvpA1eNjcB/vEjqhOAqTPVxaIk2lDI0ZKAbP8obeZ3/UtRndY?=
 =?us-ascii?Q?fB6NrYCsm5UVt8hAHF7RT5GutZ3TlhZ1PqUCJ0RxOA6jgCccozk/iMHWenA4?=
 =?us-ascii?Q?HYkNn8+nCq0y9Td7TorrwBVUCdPPrLoioY/3mWZUQhKI1DyGnrZVRiXwcVZL?=
 =?us-ascii?Q?Xx2sktu2kyKCLlZ0DmIXi2RNPzDCWBunqDxQr/1LY9Wfejeg+XReCppztSGk?=
 =?us-ascii?Q?Y4iBDhUsQLkKCMDalAEbsSS9eiyLYhxXHEENwNNjal9mqD8D0Lppx7yJ36u5?=
 =?us-ascii?Q?TgodNxqbhpndRFCHPoYAD65KCsBp57ofuXe/CKolvoAr/5w+sHwGrcKw/oHd?=
 =?us-ascii?Q?KBKFtqNS8rYXcRWprMKAP9RZKw4/V0SvTW6/IcVPZ6o2t+UiJDTBGr3KB4Sw?=
 =?us-ascii?Q?pOThU7SvhuPUbmJjxSAIVcoKFMxXhQUw3Lpmygyhn2zJfMGRdMLAnXQA+b0z?=
 =?us-ascii?Q?+vdYykabFYv01MgsLvDRx+Jv7prhlQ5zs4xoR63WiWO84SBpR3TvsEe0QZCC?=
 =?us-ascii?Q?aHSkhhkqjZRlXRDU6WLlh0gHE5Uhc8WDBDBUzAdMR2Eh0nYTd+S4XO/d+VDl?=
 =?us-ascii?Q?OjThukn1cAHf2DsIdHoHmgoVplzRJycwn7YPdBcm6gZEJurEUtzSCRKu3o1x?=
 =?us-ascii?Q?/qTmplrynRxiJq+SlDWMAAGNfaJ/p+/E7ZFFiUSjaKPrfvKVePMGpcv89rql?=
 =?us-ascii?Q?yO/LKmYjnWsPlsF9Slcvu8Tv4NDM4IfswrCv45LqtHdXM/GFuBEBgLGLN/hM?=
 =?us-ascii?Q?O3wxSAeXCGj68CFRFuoBgoiDEiZydqizOBeho7I7WY8YLaBOPS7fK68K33xW?=
 =?us-ascii?Q?JDRoKcxe1sw7GVqixh6sw56XX0ITw9k71lrgrqPQxCn7jI/vxHRPE5X7Y+1a?=
 =?us-ascii?Q?toQopqvmSHCULdPJOVqNsGHdTfzoB8VpoYhOrhHxhTsc+WP0NvGU86W0R8cV?=
 =?us-ascii?Q?ONGd92sGaU19Oyh7tcbhgRw1Dz8MQXxJQ+H1XRz5fcD9jgM9G5QH71VuR5TV?=
 =?us-ascii?Q?E6/g38zfK17UuWPbZuJorD7ai9mwZmqotMg8xfyKlMoYcbMr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e35f232-18da-4c3d-2db6-08df101a8771
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:37:03.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRwPIJmDLfUvZfqsCunUrqu9Bz3anX2cb2qox1xUgTBYNNQAMNEoLHf4qlvh8Dfx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C585C0008
X-Stat-Signature: sib4hmbh649g6bzuyi5pfq4c8a4rbxx4
X-HE-Tag: 1789141035-7095
X-HE-Meta: U2FsdGVkX19j+oGQaV0TIsDadL5H+ZcIgzWnL1qa5TdSCKhfKGWO/n8GZru5AjaB16fC2K0lkVICb7Is7t8kr39CrGrWrmQIQXleqBCwliyqJ1OiELx3dhKktbPJFT2URp7HwbqIofTeYmTIdUhGZsYsKFr8u5fm1OQ5CENdiWb4Fylh96PS/ru290xLpGZVXah9oduo9JoqFH38qQAK9rY8wALl//qlBLZZie5DfsaPJ+4bq78iI9zB3vgLiBnWERrJGHDMeL2fWSbZcMXmQxjDE0aNgqHP5sdrWjd5by6HbJVMJ8ElEm3gLAoMcyp02YjNrJhYIQtDJna6E+Vdm+Xu+iCiViziK0cjfOu7LqA6RYShry5cSwa4wvJCHVj1b/f9Lju0qeJhv8cw7PIUwXDw8cmwDOG6vBc54NcUgibMCa9E20ay5DBFMX1P7A2AfaKGnmCyTBciJ/VyvcFzL71sUFxjTKevnxM7P8No5ZufEzTRiuj5dPY+f0tBdERG8iYxwwQCgc5msSF6CP5jyI/znZMNcyXjuDohFJlCXDYi+dUUlo00/XSLdRKAfpnGs1Rh4OWtAO0KwQhz97gmoCeWAXvkRIvZdRNf6cGNGTo/lfw1tlzgnMbRSX6rTlb165tqCf5/Jqt68mTXEOYD5XDZkyik7FHS7sjo7K4+E0JGdzn4grXCA7HTOhble/7D1oMF/TrFkPkgbRCgbshm5SKo+fHsrMm46Q1NJicI7RP3/Usxpe8sf/k83B/j1tdeSC4lu6Tk10TaGjZAgrvU10KzD2Zj3CJSj9j4LYNuT7Kcv6R1jm5VsrMZcMbKZgeTKrXHC1lg2tc/JAy3/qIG7mnXqqDdbUDlZ0lYqwwi5EjOqKRaJYRFy08oorVb6UARhZxsorUT8Cjii92jYxaJeWGFvyMxLBJ37FHZ+WpgtBy8am4aFnX+7QLuGC/y0ckzT9Kw/bpLl3zkwHarc33
 ZFaqHRhR
 6o1qGjdTBlzMlEsPfrDy2AMHsqt4UPJfRx0DlBEzKFcu/+cs4zawJrU8ic704uO6M2fPY4OFZ5MSqYontctlLf5EFStZUkCzy7iF8HS4HjR6Z5k2ope5MY4UT+58LraVt5o/13IuDwQ3werWmhYt75xU6WmnlVSS6GkP0X80KPpzGJ9A/vCCFcH9ZbrNcgY7089TQnK3X2qWMP/ZuSLiyKOqgGyYspUuSI9rxUOAV8627xw+HV9unEfv2YrfDLNpdDgwVdhRjfUUvIUbwJOd42COh+4lvDT7tnMD/CyxcU2V0o70SIc3jJhd8btzEKyP67NZXivfEBdE+GLM1qgISrOw2S5j8jIQ7c7EJNT43ax1Jr78QiQDsJThStQKcODwhab501vhv/dGmHv9VqZKWhQ7qAznef9TEH371OhGof/IFuBCVuwAhDzIrrNUthJ7FvDvX1ld0ceIxWnfb7gVhm7X9ElyFLKHcTzL5Lon9BojN+oVB7tHnYUG36KTxvsVOvgYqCQaZqBN/TVmsHmc06bOTtm/eD5YftLw0ngDlwa2qqRda4V59b2dWV2zlTRNecLH/GSyAeaJVMGdwglZR+a0rRJwwoCnEDa8Not47q8tRuPJgHDNGQ/0f1W6CTJ5Hrp0GQCpGdD6QBhxCNY1PB29Y0Qj9AWCUGpwL2EIFSGN0BOQM+ZxomXkJ/ZHnYpWuYaJ6FBCPvRlRE9X6P6IsnRwDEq9RI5aLgRn1mDLMbfpzpfGlabn4rWPUr19xubv/37uS6KoqEYGwGEXcB0eUXE0yD1jwNh2Gj/D7iM/RxNXgTz1m19PCH75lreKC1ISs0qKpnjPMCwO+v9e91eJcDB8+30FqKqL6HlitXC1XDXVx34CNPzqxYEIH1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 10:21, Salvatore Dipietro wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily=

> aggressive when the caller will simply retry at a lower order.
>
> For costly-order allocations with __GFP_NORETRY, suppress direct reclai=
m
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of
> the slowpath then short-circuits to nopage: no direct reclaim, no direc=
t
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
> in turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system healt=
h
> while being removed from the latency-critical direct allocation path.
>
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
>
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
>
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the
> ~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not=

> directly comparable, but it shows the pre-regression level and confirms=

> that the ~59k baseline is the anomaly and not the norm.
>
>
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.=
it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@ama=
zon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon=
=2Eit/T/#u [v3]
> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amaz=
on.it/T/#u [v4]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> ---
> v5: Derive the decision into a local flag instead of mutating gfp_mask
> v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
>     __GFP_THISNODE so THP attempt keeps using direct compaction
> v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
> v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
> v1: Avoid compaction in iomap folio allocation
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


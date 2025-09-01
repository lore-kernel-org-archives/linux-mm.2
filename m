Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFE4CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 22:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E438E0008; Mon,  1 Sep 2025 18:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435E78E0002; Mon,  1 Sep 2025 18:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3244D8E0008; Mon,  1 Sep 2025 18:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC058E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:23:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A08FC5C2F1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:23:09 +0000 (UTC)
X-FDA: 83842108098.18.12C85CD
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3B3D14000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:23:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iv80n33E;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756765387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PcD09FKAh1vF3qniFuOOvXvPYB3eKU4OoIktmAdxRs=;
	b=JIxu/a9pHDe5XtnDZ5u4TAAZZteXioc2EhP/VQtxjD4Ru2w3Uyw20jchGERtlGq/KuRstC
	6wTnYxDzeBoMqOKQntNJLYlVyy9WMjjghJH7gAmEes3EHpjFf0l8nz4LIkvB+JQg5QxRw/
	LgfPadULhY94WHZIqfQJwV0IBAssKVM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iv80n33E;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.50 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756765387; a=rsa-sha256;
	cv=pass;
	b=YTNKHZu4nmgYC633c7J6Gw1Gwp3BPer1Sst6v5K8dai4E1f9LDd0nO45Kuc5WyCyE1+qC4
	E2xix0W0k6zBX73dhOGvhfze+5klGbqJmRd+/PEeKLezazDX0EWRDsEn0J3gunLeJsamyV
	QyjCwbwJRcZcLjnX3IoEbwfPygifYFE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bS1daFUznnVp//4wMYjsC7mQ61wfIUfOOaXIhB/KaP2C0FWv8GZ+AgFHdNow9W+6LXe4icajYJ2+WxXsc3zUbDKHO5qLBwEuMw+Q9bPQuu+vMYEQBHOuug5k1pMM+CHRmqItzRdnFmk0yd9gP1Dz8dtvUDuBXv37ceqZgk4JkGoauVNdC7DCt21lV4fbSKhkV5UqbzVrfG15J2hRPgi77evgwJcR5AbM88DSP+44Jl9DoMtdqDfb7NmsFMEjmsqpPAOnDztFEHEvqFK124YgXyGcVctt2NDvsBD9+LotYwcs40TPnAp0q4vlNtCGwMuLIVI1Kmi6+1vjV6I4h+6LPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PcD09FKAh1vF3qniFuOOvXvPYB3eKU4OoIktmAdxRs=;
 b=WD2g5hBKoBkYOk72WapCvsuBh+eJvISk6j/e7JOqGTjIMxvJ6yAKX/KGI8zX0b5x+4+D7HcK3ab0wk3SSgkNNQppdXjtXvwPBNcDl/9NZoiOPLVlA8jNZj4FT0aSixw2m2UOrq1lugxBIVYkegHX2pu9CTI0Plgmcu0xrdJl/XdmmG2pvxFen7O4klgiyYAPTFe38ZrLdRzIPoHJi1rLN5fMWUI5o1tfon6zz69GRkz9LZxZUWlRiWWC9ogwpn6NCnXrDMvwgcJSwnxSofKEcQ8vMyV9E7xVIeOfnxtX5z0kY9O2R0Z8GRkFx68JvIa68t9nPT2dARPCjIyNbT6RZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PcD09FKAh1vF3qniFuOOvXvPYB3eKU4OoIktmAdxRs=;
 b=iv80n33ELEVJgtxrACFzsV82DMFeFd43SDMUiVLoegOHzbTYcA7r4CMH1sbGiPoY6cwkuw8VulWQXba0j3FeFjvT99gIiZa4vX8Tzxx6ip5ceePsWwkLhRXSXlIYIfhDj575uqeU9wxrHXDHja0UAN2pR+vtTxAgO4nG3CyLXU+T05mEaLRUYs7E4y+fRcEbPSVIgJ8eY0kCgCrTk+rYKNed0UZd8lKNowWUkVaZ3s3qL7UShVOncZb5UGp2klTxwCLlqBGluBQPWABO3E40ijffqC669j7VNVkElnT7UPJLbWBGvdbKL4Mnt4A5edHgaXkcDk65Yj3I1HAbQh/hKw==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB7495.namprd12.prod.outlook.com (2603:10b6:208:419::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 22:23:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 22:23:03 +0000
Date: Mon, 1 Sep 2025 19:23:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [PATCH v4 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250901222302.GA186519@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <CGME20250828115738eucas1p24f3c17326b318c95a5569a2c9651ff92@eucas1p2.samsung.com>
 <20250828115729.GA10073@unreal>
 <26bd901a-0812-492d-9736-4a7bb2e6d6b4@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26bd901a-0812-492d-9736-4a7bb2e6d6b4@samsung.com>
X-ClientProxiedBy: YT2PR01CA0016.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB7495:EE_
X-MS-Office365-Filtering-Correlation-Id: 2712e776-387d-4145-20bb-08dde9a61dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0E1b1lMQkNvUlZFcUJCUEU4NWNRZTNUNnMwT3J1MjJOc0N0MTRoUWdhTkd1?=
 =?utf-8?B?VW9GZ1FISlp2ekpIeGRia1RkR1F5VThDUituWGpVWVVHOWlNZzB3bExoZVNn?=
 =?utf-8?B?SDJGRmcwYmlDTVcyQ1NkQ2lvd0lwVWIwcDlYYURNVFFBdHZMUHBvMURRR1Ir?=
 =?utf-8?B?OGc3UG42ZTRlMktlN1BCVUR4NHNCRDA2T2V2dUJBN1liUlRjTGxIT0hZMkhN?=
 =?utf-8?B?YmJaV0dTZ3VYS292S1VMb2hJSWNhYzRmWDJOZnFxaktvTWplVGRDUjQ0RlJ3?=
 =?utf-8?B?U2VVY0pxaHlmallkNkd2ZElUd2l3L0FDelhSeHQyTlNTd2hwS2xvMDF0RFlI?=
 =?utf-8?B?R2xVTTJ1NUxZTWgvSnNvTGp0Y0ovQ21LcTkvaFV5UmpTUzlTUDhEV0pibXhU?=
 =?utf-8?B?ejlXZkN3Z3NtRDR2bUx6dUVVL3BtM0ZyN3BDbGMrVHJpaS9BM0p6T2Uyclpw?=
 =?utf-8?B?eE1ESmxUNkFWSHkwZkFLdDhDaHloMUwvMFM0ZmtNaWtIaGhZRDdIZEZVcVYw?=
 =?utf-8?B?TC85ckZTa1M1bWtVQ3F1azFyeDFWb3lyL2crMEtVcVcrZjczTGRxdU1pY3lH?=
 =?utf-8?B?bXhlT2Rla2VpdDdIQUV4b21uQ3FGTnA0dU9ZU0lmSVo2TEJPcG1LaDVBTG1o?=
 =?utf-8?B?cW9INzArVVJlZUNUUXY0QytHN1J4M3VWRUpRZHlMYTFyZTA1RHdWVlo4dktW?=
 =?utf-8?B?dHNPdnl4dHovK0EyOHBneUN4aC9WdWhyamZodytPNTBzcHg2bU9nOCtpN2JG?=
 =?utf-8?B?TTB2NkRnT1FKWWo0bkNDdXZBY2dMVzVocHBXTnp6TXRGdDk5UlJSNWZsSWUw?=
 =?utf-8?B?YmRBRjc4RTNKdXdkTzc2MmtyaWt1VEphMTR2c3Q3UzBJOEhUYzBGQXdvYlpL?=
 =?utf-8?B?OW9VbDQ5dDJERTZRMW9Ib0R2bnduMFVSMVBBZ083YzBSSzNxM1hyU1RDTmVX?=
 =?utf-8?B?UHJEMnNsdC8vSmJDWUwvaW1ScXBGQUpnMGJCb1lIWVJSNW43Qm9rVTVCTVRD?=
 =?utf-8?B?aTIyMUUyUm9KelBESWc2UUJ4YWNEc2Z5ODBsRjVOKzM0SEQrMVF3QXV4SnQ5?=
 =?utf-8?B?T0t0dC94bGxHaUo4eml1UFY5bmtWQjNpdEZXZ1BsNE1nZmFyTlQwU1p4enZC?=
 =?utf-8?B?amFHa2pLM2c5Tk9wUk5ObUFFRnN3SjhIVUFEclhzN20wdG1tbmxYYjE1NnNU?=
 =?utf-8?B?dFM3dUhIWVZEN3E4ODFxS1lRUjVHSG1VNG9qMm5hRFRsOEYxb2F1MkxKdmdP?=
 =?utf-8?B?ajFQTU1VUVNrL2Rrb21mTkg2bXdSZThLUHJOSEhKSHh2SWlwM0t4RVl5ZXpo?=
 =?utf-8?B?bW1DNk9KOHNBMkcrWkwvM1JUZ1FPU2d5c0JHZmNvL1hrc1NsalRHUlExZTho?=
 =?utf-8?B?RFdDSDM0NXo5cW1kTlk4RDVGaWc3YUhTZTdMWHRJbXJ3Y3FwRjNkQUkxRW1i?=
 =?utf-8?B?VVRBUm4rQ3QydHNxMlRFaU9KM0h4N3VCMVE3dWlVay94V0o4ZzQrVDdoaU9C?=
 =?utf-8?B?d0hLZ0JWWDE2UXY3THY3T05hMFVkNjFvMG9GL3M4UytyaThINkRXTXhNVlhV?=
 =?utf-8?B?WTQyMnNqZk1TT1loRXdYSWV3ZjhsMURMRllTQVZvZFZ6MHhicyt3S3NTVm9y?=
 =?utf-8?B?NkkvVEttZU1nSUtmMDNhcE5UTjYxTXpGYVVuby9HQkY1MXQxVDdDdi9ZMzh6?=
 =?utf-8?B?dWtsc2dGTkJiWWNnVGVlbGw1V1VHb25CWmcvQmFjTTJvN3lHdlFsc1J0cFp4?=
 =?utf-8?B?b1BOMmFtWjhYVTZ6NjdleTlFVEFvSUNiYnc5MDNBUURpQk1VcFoyV01tSW41?=
 =?utf-8?B?WVg4N0kvUmxnVFhuZkZJZE1NRnVpQWowVW03bWRIZ1dSQ2FuTXdwVXEzMkRZ?=
 =?utf-8?B?V1IxblJ1L3A2N0Z4N2t3VGVaT1JNR0IzbHZVdlBtUk5qVFpSZnZGY1NsdXBN?=
 =?utf-8?Q?9gT21r84I2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkpjdmdHb1RMcitLaVM5OG5FZUZkYlU1WndDVjBnR1RrdEwxT3Jvdk8rVklj?=
 =?utf-8?B?d3NEVm1qSzBERU1wdVptRFhTUGZRTG43SDVvSHRCL25yMnZaSUMvVE1sUDJE?=
 =?utf-8?B?aldBMXRhTnNYN0c3NUVxK1M4dGFNNjQ2VFBnMmV0MnJzSCt0YTJGWlhLM0Fy?=
 =?utf-8?B?WjBjVVFiMDFmL2JLby8yWk9KYkk2REh1TFVQVGtxSUtFbytRY0xhMWt0VWxG?=
 =?utf-8?B?VW5GcEozb25ZaHUxWGQ5N3RTa3g4L1ZQeUQ2SVY2T2VmdHFnV29pa2lNc0h6?=
 =?utf-8?B?YVgwZTlyRDgyNmlxY3g4V2FyaVNsKzUzTzRlL0R2TFUyUzljZWx2SmY0VEpw?=
 =?utf-8?B?WFUxeTBrczh5MytEUUtVbU5XT0pOZ2U5T3NMR0xxUW5BNTd2MjNEVEZKVTJ1?=
 =?utf-8?B?Z1BHckFwWlJxZUVKckNsSUxFdGlScEtxM2ZBMkRHcHFtaGtkeGc0TEFRbEdt?=
 =?utf-8?B?ZnlXd1BzdEdZYUZxVFJXRmlFVks5MDlnNUYyVk0raHJ4NUpWbnozNG14RW1B?=
 =?utf-8?B?YzVIVEdERkUreVZaZlhUMTlDbDdBVzRRb3NCM0hiZGg0cXhuVGkzNm1oc1VU?=
 =?utf-8?B?TG4vSXZON2F5ZGUzUk1KMFM3SlRtQ0hyQkJlSmFFM0lnRGlnaVZEbC9EL2V2?=
 =?utf-8?B?VlhYdDZWL082a3pidkNQeEpGZEUwc2NWTStKQlByZnNLV2p0bGpmR2VVM2ho?=
 =?utf-8?B?ZFU1V3NrbGNaWlgyRFUvYTlKaUV3Kys0Qk91N1AxemVMemVhOURUYTRkQmln?=
 =?utf-8?B?MnNCSSsydW9KWFhQS0d1eVdEUTlITGVTVzNFZXlyd3BxeTRrZkg4Sk03bEw2?=
 =?utf-8?B?TWU3TE5mRVNDRU9VMmQ3V09yNlN6cWFrMjNOTjN5bXIwTVQ0RWJKU0tXdUFH?=
 =?utf-8?B?b0t3MkJoYkc5ZlR2c3R6YjRaU2RWVFBYdnFnQ1kraU9tc0ZXNlExa2xMeVZU?=
 =?utf-8?B?RFEwQWJtbGZGRHR0NXlSYXZhV0E0THk3WGRERUU4a3gzYjlTMnJlUWZ6eDM4?=
 =?utf-8?B?d0M3Ti9NNy83S1lCWGFqT0luTkF2VzF0ZUo5OW1sWUwzRXVpZzd4cnJhNmx6?=
 =?utf-8?B?K0dnLzhOZVdqMTBjVjgrL3pUTlByL3Z4WitmbkRSaEFwZGp1VVdJUDhsQWY5?=
 =?utf-8?B?akZpMlh2aDVYSUhwVXNpZWVjTnJqVXZ4T0prNDdQL2JSN200dlZ6NlBocnow?=
 =?utf-8?B?clorWUFjejM3WnpURWFkU1k2dDlSZUZ3RHJCZm1ZU2s0VmxKVDVvVlNNc2Ro?=
 =?utf-8?B?NW10T3ZYdi9LRXQ0dVdBRmVURHdaRlMzaUJzRm1SLzdzU1NVZ0QrcGU3UEVT?=
 =?utf-8?B?ZklXY1l3cFE3M09uT2w4bjkzcHpMcXZHT3k3bjhTcmpuT3dnQ2RMRmdDMmRQ?=
 =?utf-8?B?UzBDMXpoVlpwb3RVVVNqY2FUbkttYmplV01RRlQ5K1Ruc3p3QmFmSytaWnJM?=
 =?utf-8?B?RGJiVWQ3eWp5RTVFYXhmQWUrYzJlbmVjbzA2d1NCKzN1eS9LYlBLbWtnNEd0?=
 =?utf-8?B?RVdQMHVFdWZwTnVFcnFMQkpneXhocmw3d0ZMalo2dHMwQmhnY0VwNjI5Mkta?=
 =?utf-8?B?ZUNDQmhtZlg5eUpyVFhPM2s1NFZhbGVkbU9DZ1lxL1RCbGR6Q201WmsyMXE4?=
 =?utf-8?B?T2laZ1Bqb1NDNmNjU1dFVXZQb0xQOXd5Q1VwbWZQeXJhSkxmamRJa0MvTDQ0?=
 =?utf-8?B?bU00WXVZWlNYOTd5SlJBWUNydkpNVVhIUkVabkI3OHI1VWV1QlowOC9TdVZY?=
 =?utf-8?B?cm0vNlViOVp1V2Nxc2czaWZjbW1VVDBURVlCbHc5L3JtN2gycDNGNkNUNis2?=
 =?utf-8?B?ZkdyWnN6UU9rNzJ5bFFLZFJreTZkanlIUkRibk1MMEk2L0VXcFhLcGp3TW1T?=
 =?utf-8?B?dnlQUE9RRmFheVRaUitFbTZQaG1oenBLSXg4WFFiZXFJbHV5d3RMYUN5azZI?=
 =?utf-8?B?ZmlmMHR4YytsKzlaeUJ1dXpjdG9EYkJka2tMd0pMOXk1RGRIS2JJaStRdEk0?=
 =?utf-8?B?a0NkRTlmcVY4RloxUUI3Q21LU01Md2MxUzhqTUZ6TjdiVisrWUR3aFpKMjZQ?=
 =?utf-8?B?Y3lDWVlqZC9iUzB3dmtEWjJOK0NldjA5SWxxejlxZnNUTUZBZW56OVBOVW1r?=
 =?utf-8?Q?mYgQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2712e776-387d-4145-20bb-08dde9a61dfa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 22:23:03.5273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4znFzS8ZQTnhjINhC0mXrOLe3RICQMXCayvRTPzL4tTrPL8qJPNdtjBo+rtk6D0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7495
X-Stat-Signature: e5pyfbrmco6qzhytydzzzu3hhg7e9srj
X-Rspam-User: 
X-Rspamd-Queue-Id: D3B3D14000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756765386-429739
X-HE-Meta: U2FsdGVkX18heV4cjVVZIXTD8b9Lz6kEmxkN4cMnBTXJuAYecon8LZaFUfVEbFZf3RHki3Kmrj+JQzN/I95q2xzdlA42QJUbnY+92Qd43+jfdIl7sbe/rtYfIpid8+H2c6qxLEn1okppyssFIeDs6pog1vF2VwzG5f+UDt/JaYh41vEuz7wmqEdjqHXh2/+25N32C551BDcB/FuWAl6pLKq9trZ1thOu/EyOhv2g60btoRJE00a1Khd+J5170vTjMmYQtUnV3go8jB/uFti/GkIvy/92GV+GvhkUXhIuYxg3V47fkygzPle1wJ0/tHrqJvF0m257867nsEfVj/KLefmcsLW4Y3Byiptji4YlfgVl5ER2zIUyBsfinbMGlcujOFgPcn5BrqpgSuw48kb5QfBqXLdbZP6xIlBeFCwZzorJJgyC9eRi8ysAcmFA7jTukRHNxZwQ14jppo6m3I4Ij6JxKgP6aGdmFrKXVQpLrFylrKiqgarIak2E9/p+0j2PMMZIdXAD4w33A+2IZ8X3ArvXAScptAJuaYKMjjkVj9tl0vyKTAtgbW1zoUuuGApXhLJs4ZVMap633J/JtEQNUxeSuH7kirjrNAU/cUqfr2+8p+8DpO1n+TJXSojW71+zQpc6Hh3nRxqo3d+ozv1jzJRvjs+WE0shcE0VIL2yrNxSjkNcKuoJbmv9mTHM+ccJ0TrBvyJEGq8jVPtrzQljXvXIFh5meNB8DgKEe4/WDN03fd2Y7Kkgne1id86Npp0Fiw8jyMST6hHbaGFTDCM3bCv3lVlZXT+AuuUuMchenZ0UIG4SxVRwKTfl/LCd+rdj3s7l7m6JSpjqGggHG2D8BOr56FE7RIMr/WXHIjHKrxiFiBvbMYALSDH8LCHbtZ774nr91nGuDEdiAFRD9jtlWsW4bK8TI2xhx1Q/vvIUBGSya4OaWnUnTo84K37arEz9Jl1XMGD2Q9UkH+RbbOj
 mUdMatRb
 /JoTry9YmRJLXIJMcSjXyWJANEV16B0Ml981vw6BKNOifa7GeYZSq5f4u565I0rMc52q16SLb8FWcV0MeRKIHBPbFO6MRryTb9zTHVWly0QuN5D0fuAY4adao7mcUBFGDJdhhDnIEzS9klWJ8Mo8df/bzJRV7+Sae3lUek0duuhWEWbr8QMPixG98VgyDu8dU/zl7GsQORWS3a61vktxX2LiZn+fkyAcSE4roK9WdziWVXjrEykav/iR8xUF5LMA28Fhn4ux9TOxuazdUyc8ikVjcOxGYFyjuzqr1bhCw8Z+WsCewqT19lsWC7qzSEl520rSeEG+nBlVDdAt8Lz4+ZV3fvx9/X8t7Hw8K324vuCgmiWtrgziYCcBturgFj7eF1JHFybfygUgzwjEI0tcYJLahUFbMdqSMoFkpIYCCO5a8YJZielxuOxItTUro30VMH4BtU1gw52ULi5NnNdvYtyR4CqwCOFDofHI1jb7w6D6YEWOCGi9TPQkn7OCGMS9rPuvOT2YBVetM6k/YL1yVnopVF6DOdX1vtYgwSQTUDUWLzLSHo7zOzdWkqEI6JGNjsVzwqH4q57VMQ1KrRaDAGudq4T3CZP0fJzqU3XVGeGexX3T474nRgNT6ZT7TAWNO+MXjQN3IgbSCYcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 11:47:59PM +0200, Marek Szyprowski wrote:
> I would like to give those patches a try in linux-next, but in meantime 
> I tested it on my test farm and found a regression in dma_map_resource() 
> handling. Namely the dma_map_resource() is no longer possible with size 
> not aligned to kmalloc()'ed buffer, as dma_direct_map_phys() calls 
> dma_kmalloc_needs_bounce(),

Hmm, it's this bit:

	capable = dma_capable(dev, dma_addr, size, !(attrs & DMA_ATTR_MMIO));
	if (unlikely(!capable) || dma_kmalloc_needs_bounce(dev, size, dir)) {
		if (is_swiotlb_active(dev) && !(attrs & DMA_ATTR_MMIO))
			return swiotlb_map(dev, phys, size, dir, attrs);

		goto err_overflow;
	}

We shouldn't be checking dma_kmalloc_needs_bounce() on mmio as there
is no cache flushing so the "dma safe alignment" for non-coherent DMA
does not apply.

Like you say looks good to me, and more of the surrouding code can be
pulled in too, no sense in repeating the boolean logic:

	if (attrs & DMA_ATTR_MMIO) {
		dma_addr = phys;
		if (unlikely(!dma_capable(dev, dma_addr, size, false)))
			goto err_overflow;
	} else {
		dma_addr = phys_to_dma(dev, phys);
		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
		    dma_kmalloc_needs_bounce(dev, size, dir)) {
			if (is_swiotlb_active(dev))
				return swiotlb_map(dev, phys, size, dir, attrs);

			goto err_overflow;
		}
		if (!dev_is_dma_coherent(dev) &&
		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
			arch_sync_dma_for_device(phys, size, dir);
	}

Jason


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB08C55180
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34426B0088; Fri, 20 Feb 2026 04:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2756B0089; Fri, 20 Feb 2026 04:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96EB46B008A; Fri, 20 Feb 2026 04:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8124B6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:45:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F5EE5C440
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:45:23 +0000 (UTC)
X-FDA: 84464352126.06.EC41776
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010042.outbound.protection.outlook.com [52.101.56.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1566840002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:45:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=irKOSzft;
	spf=pass (imf01.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.56.42 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771580720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfUaEMeqn7Jk1rrNcnmHv5AW1OxnHQeSGMBKJEnOd24=;
	b=rISlN0Nczm+0lAn944wsD0cDRNav7k01Y7PBi9VTBdTOahHT9TA1XGPb0w7M2ETCuERVzz
	ne2YEFMAt+zelL/Ra4acaA+rKXKYE5+gUdCBFwM97fr+tG0pckwJ7I5F0T7hEsmPc2Xp4O
	sXW9nERcDP16q+LibeCBemMlZvIlVpo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=irKOSzft;
	spf=pass (imf01.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.56.42 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771580720; a=rsa-sha256;
	cv=pass;
	b=TMWrLXJFJL/6XYNRSgNFKZeFKTK7Tb2b6yLsI9ZKfLBL4rEmD1EKU4F7BY+o2BYIvCZHVU
	CuIqun8ds1aV4j06FsXGIj8GG+OPNl8F98Fa1O5pSKB4fGM0NKh1wJwFZ+4+gCx7u+BjS9
	gAC09k2glDlQyjBy9x7ouRMIfSvIurE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVFVKICShWesKy15mlKsFLZklCAllM7tGpZmeN+Fjzu/4/rFBrZ+3IRtAdB4PzU+9919bnmANPaQIFLZ+WBlk4upiMIryzJN/9uWZaZrPijpRY/ITaLFbj7wjFcSw/0BWDRIHaMKqVFZmDty0n6uoHx85RPhk641JJMifyljne1XOOxR7pMxwboso8rGSwhGEmw3Qf6kel1mrTzZyPh8Oufe0PTyQbg+5ybGiAQHjdaVWmjZZJmLs+/ItTRfpi3XOlFqnGfOtklRnuaZUlc/8+ROZDdWR5USzoce/PNQ96PoCMIJv1XTJh8HYygMWqqx1inFhZrxvkdbDi2wJiTmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfUaEMeqn7Jk1rrNcnmHv5AW1OxnHQeSGMBKJEnOd24=;
 b=YHm1kPMMeTJiYdIphsC5GOCOE8kZv3IOnkSO1wY0aLlyr9vJ5RicNVBqARUwKvp/BkAA1aT65hVTHbhm9k6czHd0yFRx11iI/Qr9xEm7lj52bmkiVthlzEZApiFP5+eXIcNxvwQnwYutpKl0rTEEnGkMMHYrtnfBJQYmgfHSpJdcMMpo3OVDJnxK2ql8XcV5vhCspOVR6BhstC8ckgAzCjKwlzfkoSM3/smLl7YwMvTukSh2/ufwTsCXTZFJ7h2cW0HNivwY2HxfnX8xx6KuYVClzXpwYc5DwlW2xtiIKmgN/ehu4pL2jDXueLXfgbicJwDC+gWT3zbT/v1nFVsYGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfUaEMeqn7Jk1rrNcnmHv5AW1OxnHQeSGMBKJEnOd24=;
 b=irKOSzftjKP0e7veuC8iNIkN9Rg3AGlDPvrwsUN+qUh6nPH3SM8qGy4EqcO19R0x0seKxX13PA2g9nPPRf82Y6e6Skm/Ql+7/h1NPbzP9YPgRPAeiyG7u6YOLV6Zg5ED9t7pSHd6kY8I6xsOcSkPIuYDBvNRHSeo88ix3mhzWVE=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW3PR12MB4364.namprd12.prod.outlook.com (2603:10b6:303:5c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 09:45:16 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 09:45:16 +0000
Message-ID: <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
Date: Fri, 20 Feb 2026 10:45:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: "T.J. Mercier" <tjmercier@google.com>, Eric Chanudet <echanude@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>,
 linux-mm@kvack.org, Maxime Ripard <mripard@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeel.butt@linux.dev>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::15) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW3PR12MB4364:EE_
X-MS-Office365-Filtering-Correlation-Id: c995acdf-11dd-4550-de49-08de7064c06b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVhPa2JEemxpVWV6T2pvOHdzdnVkcDkxOFJ3Vm1qWUtOZTVkNXBNbHV0ZnpB?=
 =?utf-8?B?YVl0eCtucUttb3VpSDRCZ2xXK0QwemptV0VKQ2RoNXJkQW1nRk13NVNQeTlC?=
 =?utf-8?B?bE9mWlZpYVpmamE0aGp6eXFwZnhoQmxEQUVtMGVsSFN1dFhDRFltNWtmUHp2?=
 =?utf-8?B?SlRYTG1wOGlSTFlZN1h6aG1Dd0xtOUc2RHh5NHNham9pOUFtbE8wTW9uK01N?=
 =?utf-8?B?bGYzL3QyZHdPR215Q05sZHVDdnhYZEV0NGtkeGhhVVQ3NlR0L3pUdFFqbmFH?=
 =?utf-8?B?aG9nWFJiSTBSY3ZCOVZNR3NHcURVeEErNVFrYWgyS0M3dDBEZkRNbUNFYW5D?=
 =?utf-8?B?UFpjYXQyWUxPeEtxUHhmQ1QxMnVmZHFXUFJhVEZobVJOaHpwMDBUaDZFYWl6?=
 =?utf-8?B?dmFtOU9ocnlIUkp5Mis0WExhV05YZDYrcXkyRldHcEw2NkxpZmVNa0dUNWRY?=
 =?utf-8?B?amJyTU5KbjAxdDl4eHBOQzhUb0dWMVovelRIWHVOMFV6S3lqSFo4ZjZnRys2?=
 =?utf-8?B?OWpnVHYzZkN1UHg2WWxIc3RhVm1Xc3lscjZDcXd6YStudHNYdEJJQzUvVzQw?=
 =?utf-8?B?RGtlajk5bHdtVFkrR05yMTMwRkdGbS9yOFltOGM5WFlCUnRFd2Q2WTBtWHZS?=
 =?utf-8?B?UmNiZzNXdThNb3UwWUJpaXJPRWtFbHU0c1NUdStMWURiOTVmc05rQTlmZ2xj?=
 =?utf-8?B?blEzYXlNY3dlRlRzcXNZclhJemtZRFEwTzhyTHliT1JkZHJXU01XVnYzU3Rp?=
 =?utf-8?B?QlFoQ3k1bzlRY2hQRkxjRU5iSmxLd1JudWJwYTl0VWJaY0RjUzRpcTJ3Y1lK?=
 =?utf-8?B?TjBWTXF3ejNCL05NdzdYY3lNd0g4ODhrOFR0ZTJpbTFCU3RqMUJPQTVvRVZn?=
 =?utf-8?B?MXRuWmUrbWZWQjI1OENKR3o4T2ZyVWVyandlNG0rRk94cXRWM1BIZHNJQmhH?=
 =?utf-8?B?cGtGQnFzSkcwRFhOVTVzWjVpTUFndzJrZGNWdU4rSVU4NVpBVkVrbGNYMitK?=
 =?utf-8?B?TjZoMExWUEhWYktQOG1ZTXFlajVEQjJVdERhem9FOUJkK2tjMWVUdStsK0F1?=
 =?utf-8?B?NkRiWGdtSEZvL3JuWFZNY2ZyVS9zVXRZN21ELzdVM0NHSXFVdXBQU2xBLzVL?=
 =?utf-8?B?eHRmTGJRMGdBM1l4eWxLRS9STGdoVFo4aEtMVXJNZVBNbnE5enpPVTNWUE5G?=
 =?utf-8?B?Qk53Nk1OcjVRaXBJTnp1cVo4d29oWUdMelV6MDNrMmFObVAxcEhqUzZoUE1X?=
 =?utf-8?B?WVpWVjRqeG10NElxamN2Z2FwWDBTR3RFaDNqdVJhQzlIUkVqaVJ5elV0RmRU?=
 =?utf-8?B?ejZWdnk1dkdSOE1sWXFnck1QMFVSVE80enJUaEtEOWl1QVlkNE5ubVJZTTJN?=
 =?utf-8?B?TEQ1K3NvbGZNYmVNZUppWFdZd0JDWUZqeFVuUDYzM1I4ZE1UQXR4MU5MeTg4?=
 =?utf-8?B?bjBjZEN3c0VkK0IyUVRJNzI0bzJLWjVWZ2w3eGdSZVFLcjV4NGhpRnlRaEk0?=
 =?utf-8?B?MjhRSXVxWVBkL2h4WGxZWkFPcjB2YURjUW8yV2tyUWZkaGVYbDRMNFVlTjdq?=
 =?utf-8?B?Ui9ob2lzME83VWwvelROMW5Ba0ZiSGJqc3pkaERFa2orcmpVTCtMR2dEMXgx?=
 =?utf-8?B?RzlFNGVVTzd3ejZuU0JibWx5MTAvcUQyREVxWmFLZmlwSDNjL3BmVzJqQi84?=
 =?utf-8?B?VjlmZVlHYi9WSXhuZnRwcjRaODlHc1FaZTc1SzBQTVNScHA4Nll4RzFEY3hF?=
 =?utf-8?B?cHVIVkpDZG4xeEt4cDZmc1BPYlFlRFhQQ3U3SFBLRW9zNS8zUVdkaWs2Q1pJ?=
 =?utf-8?B?bTBldGpqSFRNV0h6b0M3RTRPdE9LNTdwaktwOGdMaXJtbElVdE5aT0ZKS2o5?=
 =?utf-8?B?YVFKZndmZ3poRWlxOVROR0Q1R3hxenF1Tm1IMnBscjNQYkxwMkFiN2laZVVq?=
 =?utf-8?B?ZlRHQ1V1VlpjUEVaVG5ZSUw0a0FTZUNPVDhvWkl4TkoyZ20wRXAyY2xibFdn?=
 =?utf-8?B?dFliUUdzMWJZVDMxbVNudFc2NHF2R2VwLzdxRjgweERxZHRyTEtDSC94ZFpw?=
 =?utf-8?B?NE5zWlE2S1BkZkFRSC9NWWwyRUxCYWp5UHgwYklVVmJQZkVrOXRRRVczeEND?=
 =?utf-8?Q?w1tv06XiJXYkCM7IH48GmyYh6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmRLS2dCOUdEYjJBZW9YaDRIWGZ0cS9WaDZxVlJtSGExejVzT2ZFVjFyQmVP?=
 =?utf-8?B?Wml2TkNUVG9VWTlFeUxURW1kRG5jeVM3cG5lOWZmUEthbHEzTU1vTG93SU5y?=
 =?utf-8?B?NmZlbDA4VUczM2FkQSttOCsrWVRrVElvZUpFbzZuUDE0d0piTVBadlRQRWNm?=
 =?utf-8?B?c2ZSK3dubEl1Tk0wcVM1eWVkb2Y1ZmRQVlR4enJ4NU9IR2p0aXlrZUNmL0ZW?=
 =?utf-8?B?MW50MnRnMkJZeGFEaW1qMWszeExSK3g2b3pRWlpYSVI1M2gxVkJ4QXJWYkl5?=
 =?utf-8?B?RjZYaFQ3UHExb1g2Kzk0UkU4TDQ0THNkRGdmK0RLUkIyWFA3bTc4a1VrVnVh?=
 =?utf-8?B?VzY3TkhJUW8vWGNFd1VDZjlsZ2QwSjUrNlcydmkwWmV1OWV1TmRGTmpRR1JK?=
 =?utf-8?B?N2RueUs2RXZUVnpVSjVtdHRMajN0d2hDM3dCa01YTEpzd0gwSGtqSTl1NDdp?=
 =?utf-8?B?Ni9SSEMrUWR3MHBjTjd2U0RiLzdyTjAxbGNXa21pOGh5R3JwWTJ4ckwxR3lw?=
 =?utf-8?B?Wkhnbnp6YWwrV0pjTlZ2VkIwdXl6aVNkS0M1KzFWZFFUU3YwQml4VWwrdVlK?=
 =?utf-8?B?SDZZU1BZdjF0eHM2L1lwQlBMMkx4YUI3SSt2SFFPRVFzd2EvcGN2VzdlSGkr?=
 =?utf-8?B?WFJXZVJITEFwZUR3RmdOdTJhcnRTSmtvd3haOXE5UEl2UUtFZmp1N2UyNmkw?=
 =?utf-8?B?d2U0L21mVWZCbkRrNXZIK2Qyd1ZwQk82MW1zd2MzQmJSakkrckkzK2kwT2JW?=
 =?utf-8?B?TWQ1VWNrRFA2MmR4N3hzNk0wVCtxeUtObTlxdlZyYzc2NHE5OENLdFdwcDVh?=
 =?utf-8?B?aGZHSG9CQy9DUGNTb29KUnFzL0k0czNQOXhwS2VKRzI1RXdQRVMrWE04T0c2?=
 =?utf-8?B?a2pRQkU2Z0c3MnIwZHVFUVFQN3VCb3ZGUHFHV1ZUdVhNOWVoaE5JZWYrSTJt?=
 =?utf-8?B?K2dLMEozeG5Jcy90d09CdXllZzFCdUNIUlI1SVliT3FVMUIybzYwUTRldTBF?=
 =?utf-8?B?Zi9ROXhtTXFlRzJiY0JvVnhpb2pYSVBTRWtudUNTVTE3bkFXdHBFTlJpMkNm?=
 =?utf-8?B?enJDUjB1L21lYm80UlpzSG9EbFphaisrYWpzbE1tWWkrT05RVlJxTDltNEE5?=
 =?utf-8?B?dWp4RjJxbWRzMDNkenlhRHhDWjBxUUpJYVJkV1pyT29xYWduVnBBS3FUN0NL?=
 =?utf-8?B?K1Fqb1JDL3RoaUs1K3FiNG1JQXFiWWh5U2VSLzlKQ1ZCZ05mbFNoU3ZDTFVn?=
 =?utf-8?B?dXhEWlhkaUh1UWRCVjNRbkhBa0dyMGNGbTh0ME44aWhoUVVaV21CUDlOT0Vq?=
 =?utf-8?B?bWxxTmtmRlpMYmkrQ0VMOVk5cHpWNkJZY0ErRzFZY3cydktiNWpuWDRXeGNu?=
 =?utf-8?B?RmYvREMxRW9pOUFFczBGbFZvQmdzMmtRbXdPVklSZTRwSUNTNllKWVpxWXdU?=
 =?utf-8?B?TkVrQ0VuWVhYdHUzWWV1VVdzZ3M2eTM5RU1ZdmJEbWhnSWp6aEx6VGJDWklM?=
 =?utf-8?B?ZXZ3L1EwcHlNUW8rQTdST3pIMXBMMXZtNWh3ZGNnNlJEckh2Nko4UGV2YitV?=
 =?utf-8?B?bnZZeUNESlpIczlxWnFEQzhuLy8xOWdjNU90SE42dXRQM0I4aE9DWStneC94?=
 =?utf-8?B?QWRSYlZJVTlOUUVJT0ltNmQxcmsxYmxIUTdpMWhiaWFGSmxuSHJRS1JjUWVY?=
 =?utf-8?B?Q0dTblgxb2ZEY0Ria0ZTVGo3akNHSnYxTHlxTlMxdFlPcXZGLzB2NXBPWFp5?=
 =?utf-8?B?dVBHdWlrOUo0NG9OUlJ2Zk51L1c2bEhkdWNFREhKYTl3Uyt1UU1kdnBNeTY2?=
 =?utf-8?B?a25LYnJuNzQxUGpRM3ZOTTkrUkhJb01SSmdDTmRIMlE3OW0vN2Fnd3ZOR1lT?=
 =?utf-8?B?NGR5eDNOSWYxV0k1Qm9vdmNXVXpiNHA2SDVwTXNXaWVLWXRCRXljRWltZkho?=
 =?utf-8?B?cUx0VUM2UUZCaDhqK0VtN2xrdGdydktqNzBGTGU3bEZ0eU40S2dxQlAwNFVR?=
 =?utf-8?B?dWlPYVFZbDlmaStXN2dheWdsTXNBUXY2NStrbTJrdjNidlF4TlYveVpKNWRO?=
 =?utf-8?B?bkQvRnA2RVd6ZitqV1lja1I5Tnp2VG51emRYb0FOcFYzc1E3bEJRRWxzem9H?=
 =?utf-8?B?R2Y0aVFKa2htb0ttb3RLVmc0dnNpczlJV0I3cUg3eXoxZmxxb3NqWFhIV0Nr?=
 =?utf-8?B?U2RXZjNLSGtkMkNRdkk4M3VLUzFYM2RHMnNRZlQ5RUk4ZTlHd29nU25tNEVQ?=
 =?utf-8?B?TFR0T0dNQzFRcmRTVTNWQXROa2V4K2pVQ1pyTjFFc0FlRnJzaEhKdVVmUnlH?=
 =?utf-8?Q?7Yj5Y0QN0p9+QtEAzH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c995acdf-11dd-4550-de49-08de7064c06b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 09:45:16.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4u9AU1e1kuNGytMCDKLprhAe1+6RoLdYPuVVlpxBCGtR/lTy0SBwk5TETjfTIyDL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4364
X-Stat-Signature: d6jotgwy9ozy7wc8i1cf8kwcczdix6j1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1566840002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771580719-851523
X-HE-Meta: U2FsdGVkX19vAOkYOgukAQ//m3i9nQaatImW24LwhZ/1Vs5/ItfTWVa8LE/Z8mR0j8vWC27b0eA4lFB4XssNm48jELd8DoTRmf/7hhcUqCZkQGpmHmaxt1J0R/3vqyCRBpgJpbJlLeq6StXR1tICv0wHcodBJpCUDZnec8d3qErN2zMOhjobALzlakXIIpJNmaJP1751s1ppkv7KyWsE1FKfGMMgZ60tc34QOXw86HGMBsw8SQkxxSarNxj4B/boHqkyRKVIBRN7wp2GN8RY459HsVaBkwiGqy05Dfow73xExGtgj3SpnGYS1DE5evNgKzrUfRugXIYSVlqmcHW7xoJDQSEhC2i8eExa0kqZGuj2UQXGKOIgBrc5D2eajyR6/ckfpamOcSakZeCWut9X/SeQiJxISo7iBLMLQ76PoKXxf0sRmzzwv1/Ey6etgvvuRDlo0jSYLhhQ4sdrbbdc1rh3Q+Z0DK6WTCGHdBkiyX6IHiAyykuuzcKsY5znrAqIdpDtP+qOFMGY5S1O9k5a/uMgq00WYSSiZMM596oyq0CHoX9/HlqDtssJQMHhoIEtz+nHT7GyGWr0FUSK0K8fyUB2l6fjSDZ1ufhOKWrc2eXhVfurNh3EGPyRqf6iZ+ZsbcTr5e11jv/yH8+kBWNfe1R+3pqhhkFA4T3w7DHkFLoKor3DFAR4KjRHmLg6Okhk18ZChwevMEO/ifT4IdyEFfIr2vodLFH2xZrVQ7B7r1Lir/jHWOqOopgLSj8twHt7MyI4EB/gZ3vfoCuWuyWwayJf3FDji6iSItDNI9CdJPO6GDAjCYaA0B7CuIb3DTCphCw/iQ++Qd+hWvcMg/RcVxb3ex8VlweAS0P2q2AkUzjHPYHgtrIl+v4s5F4vhK1CzxuQXhgqUHKcN5yNnjo3b4dI1M6kZHZJOXry+q3/jOzXoRb8jyVe/XCu1JiLUjZBhvFePy7ofW/neJCLJLm
 jWg7Wqet
 x36kWv16/bnbHgJuJwKfnGkfB/XlisHSuoFDZAzCnFosbVhxvm2ZLhMvO8JxbStX0JXtBqC6kQij85sil9GrSAfYOQZwogjn6j+jRaBbOtukr6RE88NvkjbkAatCJtWZGYD6sM8K1EEjDXRxoDtwtBamnqRSvRmABy1QnNxXWLcaDfBx9OZq8Mah7l5GwhXTE64/4kBTb8k15AnfXqjLoPTPDRC1a2TmnQ5j1EtpwOrcjMtLsHcucgzt9UnHyWjNQMXPToU3Gm7z518picCEQbEsfN+2C1IoLulacFBPDD+yxWU/fYim1SjopbEQxdLrt9Al5C3OE441G85Z3xUB6v1oy3pYDdB94F3EGcikRJn6inHS4MJX1qw4q08Zl9NxdM6qlVvqfFVeusqPqz7z0euykC8eFOwooovQIJo4D4iMAzrdJ1OSLdrEJgDJkFkti2ti2IskQTdfCYxYeZsEGzDG7fdd+XNPHvO+dy6LvrBBZAxLnNaqAeJ/+Gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 02:14, T.J. Mercier wrote:
> On Wed, Feb 18, 2026 at 9:15 AM Eric Chanudet <echanude@redhat.com> wrote:
> 
> Hi Eric,
> 
>> An earlier series[1] from Maxime introduced dmem to the cma allocator in
>> an attempt to use it generally for dma-buf. Restart from there and apply
>> the charge in the narrower context of the CMA dma-buf heap instead.
>>
>> In line with introducing cgroup to the system heap[2], this behavior is
>> enabled based on dma_heap.mem_accounting, disabled by default.
>>
>> dmem is chosen for CMA heaps as it allows limits to be set for each
>> region backing each heap. The charge is only put in the dma-buf heap for
>> now as it guaranties it can be accounted against a userspace process
>> that requested the allocation.
> 
> But CMA memory is system memory, and regular (non-CMA) movable
> allocations can occur out of these CMA areas. So this splits system
> memory accounting between memcg (from [2]) and dmem. If I want to put
> a limit on system memory use I have to adjust multiple limits (memcg +
> dmems) and know how to divide the total between them all.
> 
> How do you envision using this combination of different controllers?

Yeah we have this problem pretty much everywhere.

There are both use cases where you want to account device allocations to memcg and when you don't want that.

From what I know at the moment it would be best if the administrator could say for each dmem if it should account additionally to memcg or not.

Using module parameters to enable/disable it globally is just a workaround as far as I can see.

Regards,
Christian.

> 
> Thanks,
> T.J.
> 
>> [1] https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
>> [2] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-0-ecc6b62cc446@redhat.com/
>>
>> Signed-off-by: Eric Chanudet <echanude@redhat.com>
>> ---
>> Changes in v2:
>> - Rebase on Maxime's introduction of dmem to the cma allocator:
>>   https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
>> - Remove the dmem region registration from the cma dma-buf heap
>> - Remove the misplaced logic for the default region.
>> - Link to v1: https://lore.kernel.org/r/20260130-dmabuf-heap-cma-dmem-v1-1-3647ea993e99@redhat.com
>>
>> ---
>> Eric Chanudet (1):
>>       dma-buf: heaps: cma: charge each cma heap's dmem
>>
>> Maxime Ripard (2):
>>       cma: Register dmem region for each cma region
>>       cma: Provide accessor to cma dmem region
>>
>>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
>>  include/linux/cma.h              |  9 +++++++++
>>  mm/cma.c                         | 20 +++++++++++++++++++-
>>  mm/cma.h                         |  3 +++
>>  4 files changed, 45 insertions(+), 2 deletions(-)
>> ---
>> base-commit: 948e195dfaa56e48eabda591f97630502ff7e27e
>> change-id: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8
>>
>> Best regards,
>> --
>> Eric Chanudet <echanude@redhat.com>
>>



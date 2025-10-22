Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9C4CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8658E0010; Wed, 22 Oct 2025 07:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488818E0002; Wed, 22 Oct 2025 07:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329638E0010; Wed, 22 Oct 2025 07:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8508E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:43:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC3001407B6
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:43:41 +0000 (UTC)
X-FDA: 84025565442.21.D8D6208
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4072120005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:43:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aSpuQcpf;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761133419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGjbhCexq77FjJxqx8ELdv6+oyb+9U6NESLT3iRUSH0=;
	b=v1xYP+2+z6gyZQ9wYN/qawBPK04snTS4WHD3/356c0jZdgSzHErJJDAyIWOtntlwtKKVEb
	RLUcO+0/7I/giaKEoF6da092pI/saE7BuVllouNpiBtUxpgYC7yb2NUxui/lPXhbKGzsx6
	ZD/2ZJpVn9kkXXqA/5Nzlt/v6+Vulxs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aSpuQcpf;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761133419; a=rsa-sha256;
	cv=pass;
	b=3DDHZuTO+aoxKbAIQELhTSPQEvREiFs2JGgT1Gl7G8qolhPuGFvKg0V7+QuJSyzED1EJay
	voHqk9M8d8EyQ4z0I3DoHf1497zfdQG+Hfx6zF+1ROzwgsJhfGWBnSDqvL2s9p+Q1lFjQZ
	t5mNHqyQgZPdGz4Or7y/Fl/4h+KqKiE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pDacv80TEHxZLPpX2c1jSyJxmZq044Y9TcdlUa8XcjxWUNuk5n5ZM/90Y74OVp7rDjb+0qq8kSVxoaMiuvDQbR8phbVUeav0yc+T2Czl61P5dY8l3MSzsH0nHGDG/KpSDgA7L6qp6ZJXxLlGM5u41MfHREtjLyExucGT2qf1c3u3Yth/xFr0yZwrr8vxX3KjBe4SKLzVbEDopz+S0bQ1+BHDxV4QFu82a5cFNaQ39k7+KuVMTjLTAgpdpk30pLfF29KBKBihBCGB81vk0/EzYj/xBMHY0kNOzTR00S/izYRDKaAMntaxPoLyYRpuMPB64z6DcxSZBtjlRVnOxHw2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGjbhCexq77FjJxqx8ELdv6+oyb+9U6NESLT3iRUSH0=;
 b=AjnZO9oRYxf+0jOaEg2Hh8C3UXDmXFYGkc9RPaBeB2GAAY05Lyw0kA+EugVHAfF4FMyCde9TPZ35uQHt/fxKKvS71pSPPGDR6HK8Rn7FQIpZqISTzjX83YCAh8thyHh6m118m++fQapEuzumQUggjWs2Xso7uNEm6LnG/bpBacsi9MOFrpmoILyZmH9TaNgKtpG9SYg318BS+4bCu0QfiEgxc4+PsvqmEOs/3ELlXSCX4v9AY+b503nLBHDW3u4MF04HpdtaTRvAApoIQLf7gDkIxrICPPaGbKeHMWVKNGub/q4naadGncnc3yY0EagLJY8kmsOMGG2Zu2Gu1wbdTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGjbhCexq77FjJxqx8ELdv6+oyb+9U6NESLT3iRUSH0=;
 b=aSpuQcpfcCLi2MhwrtKwHXXOeMs03JxN3ka+823dBL/sWFQwKyfCPFjzykHXYeYZFsxeQa5AEGfhNMhWmTOr3/HzqVCEPXNT78h1b5knU7BQf5sfF/YYTw0waaZyBiS06JE4EKz0XTSE/0f5ll9kbgM8jCC+FftaM1ilX9HmrZQlLDPbBYmAwOAb3FpTnqKGzXeb1sGhmtNwd6aNrhwrbaSo0Hw6zQ1Avd3uXaUulBpLDg1AGjiYwboPvx8nSpIGYSyZ/52wNRqknLBMgoC1T2TRlbO/vOlgTWaZEXsbeAB0fiCZ5/w9om53tA+ECJne8Im26f+EvzixKHgpW7PyEA==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS7PR12MB5960.namprd12.prod.outlook.com (2603:10b6:8:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 11:43:35 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 11:43:34 +0000
Date: Wed, 22 Oct 2025 08:43:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <20251022114333.GD21107@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
 <aPYqliGwJTcZznSX@infradead.org>
 <20251020125854.GL316284@nvidia.com>
 <aPiDa-QruoHC3alk@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aPiDa-QruoHC3alk@infradead.org>
X-ClientProxiedBy: MN2PR20CA0046.namprd20.prod.outlook.com
 (2603:10b6:208:235::15) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS7PR12MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 29fa22c5-5b84-4bb6-ef7c-08de11603b7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0pRZ2pNVGtqUEdMNytCRmZEKzZkTzVKUEkvNGc0anNoalIxckhNWGczL0RS?=
 =?utf-8?B?M0pPc09GUkYxZGl3VTl1alNkbSt6WEd1NjE1TGZnR2pyV3NSVHVYblBQdU9Q?=
 =?utf-8?B?VWx6dWNxdDdVRk1DLzZxb2xqME9Mb0R0RUc1a1UxbFltdFZUdDVBV1E3T1VK?=
 =?utf-8?B?QWd2Y2xCYytDcEs0SkFPUjRIaTk5VWRPbkxqS0VYZU9hN3BWLzJGaXFxRTd2?=
 =?utf-8?B?Mk51Zmk4eXkwcVZUVlVDejBQLzJlUXUwL1pha1NWWEZ1Z2pHRGR4OE1ma1l6?=
 =?utf-8?B?UmFabVppQmlUOVJycmN2bzNCanViM0djTVFEUTVIN2IyN0hUWGlTNzJsK1Ey?=
 =?utf-8?B?L0Q0ZFl5dVRsN2c5Q3BaaUJwUmUzc01YQUs0c1R2ZnN2V0JaSlFWSUo3Tnl5?=
 =?utf-8?B?ZUdrbWkvUVpGZFJTTGNVTi9MK3JveHBDUUZrNWVLN1VWRjRQTDk1UHZmdjJ1?=
 =?utf-8?B?T3R0TzhjWEhmRVdxdHZKUzV0THNxNVFOTVVBbjE5dURkOUhpUUpZOUFYbkJU?=
 =?utf-8?B?eWc5eFJpTHZrSUMvcnZtSjlqSjZMM0lYek1UMkZyQi9QNUwwTFNXQk1PZTRM?=
 =?utf-8?B?SURGQm9HVHp6V21MbEJ5Z1QxMy8xKzZLSS8vTUxBTVNBZW1lek0vcXZ1bHBu?=
 =?utf-8?B?eWNWcC9Fdk9kUTJybnAxYkpaSmhZRkpsNEdCbjhaYlF6K0laZ2NZUXlKeDVw?=
 =?utf-8?B?SkpCWkxQbTg1WlJQcGE2S1d1UkVwVDUwa0FObWZsanE3MmljNEhGZUpwK3hq?=
 =?utf-8?B?UUIxOXZWWUpOemxSbi9HTDEvYjc1UDB1TGlGRkpSZWJMdDZPWS9DTjhTRC8v?=
 =?utf-8?B?TlBvbVFHd3d0Z2tFeCsrK2JVSGo5bFhPMW5XVWszWFY5enZ1bDNFT1RoK0g5?=
 =?utf-8?B?ZXBFRnRUUkYvNVF3M1o2ZkdSWVRFQ3F6ZDZ0YTkya0lBditBNmFpMytUZjRv?=
 =?utf-8?B?ZGRscFczSzNzbE1VOFlMb21DVnhSWWxCMVQzUkUvRjd5M2JQVnRsaitoWWRO?=
 =?utf-8?B?UTVLYm1aQm5FWmgwZUdIMHhsRzluMTR5Q3BzOXFid011Tk0zUGRqWkN6SGEr?=
 =?utf-8?B?TDUycHRhcTQxb05qaC8va000NW9hNUJZSXVLMGVqd3d6RVg3aXp4eEFCODJQ?=
 =?utf-8?B?RDEvR0JEQURPR0J2ZVppSnVYUGxkWkxzUzhJWnA4ZzduYUdXeWdCS1A2cG9z?=
 =?utf-8?B?ZWE4SFlkNE82Y0JMKzZQbmJld2dkNy8wUU9NSElVZ2x1cDRrc29GYW5lUVEv?=
 =?utf-8?B?Q1lRRkhCeTFxRjhYZi9SWGxZbTlhSDF3VnFVOGJnYnUwcktFTDQ0RHk0ejhM?=
 =?utf-8?B?dlA2N3RlbWZJRW9oNDZnUi96dVZQb0FCNVBoekdrYXJhbTl6YW8rbmNOME1y?=
 =?utf-8?B?SldQbXpyR3RCei9oVGFaMDluZ3hZOW9GWVQxL1VzVVJFenpNQk5Pc1pkWUJW?=
 =?utf-8?B?d1RualFab1hiT0dKYVpTNCt4eFBYYnNBM2t3ZXA1TnFkWlA2RGlqZzNjWUZv?=
 =?utf-8?B?UFRobUp4NXVaSlhDYThEQnlEY1FwREJ2c2FvTzROcDFIcVdmZWxUMmVxWkhh?=
 =?utf-8?B?dTEwTmFBYjNhb0Zsd0kvTWpaT0c3R2JEQUhDajBubzVqZ2RNd3Q1OCtGZTJy?=
 =?utf-8?B?dmNydGFoREx3NVFtQXdZa1VMcVBMUnFtWE41TCtzTk5iWEc4MXdERWxiMDRN?=
 =?utf-8?B?bUo2c0c0WWhtanUxK0NkRW00RXNYWmxTOEl2RTNMdERuV29QL0dHWDVNSUVM?=
 =?utf-8?B?L1dnTWtXeEgzaEhTSGg5QVFEVEtiMjNLcDdqMTR5MGk2bm5LaWdJSDR6SWNt?=
 =?utf-8?B?bU00Y05SRkhhM1N1VVZScENoRmgwODdZTk0xM1orcC8xRFdIelRUNURLVzg4?=
 =?utf-8?B?WTZDUXJUM2ZEK1JzZUFlcjJWQTZOZy9QVm5WOXlXMmgrd3ZDSG5oeGprYm1j?=
 =?utf-8?Q?VR+JG/qOdsGsWcrwvMdSl7OxMHmCbaGU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk01bGY0Qjh5RDRPc3dwYkR4cmZqcTZGNDZpSmpHUS9YcUZvVnVlQ0pYWDhT?=
 =?utf-8?B?K21qU0hFNlJCcFNCSVhUU3dudy9wSGl1UjFrb2V5WTNHMkJsS2ZVNHcxeEFq?=
 =?utf-8?B?R1dYTi9KemNmOVM4eWU5cVpjMFlvNGloZXRIcEphbUx0ZGJYSW9MQ2N0TFZq?=
 =?utf-8?B?NjNxNkc0UDh1bUdRb0FPTGFBVStXT3U1TGpRRzIrVWY0dlBvSkVET3ByaDg2?=
 =?utf-8?B?U1Zxeks3TWJ5VWh2VGdnaVBNKzFvYzJDdzlRbXlZdXhiamFYK0wveXhwTFhs?=
 =?utf-8?B?WlhtNmFJc1o1YmMwenpXSWZiNTRGa3AzRmVrUVhYWGVvU2lTb0V6WGg0VW5p?=
 =?utf-8?B?cXowL00vRVBwSFB5aHJqbVpEb3JqR0x1a2p5bmg3MVNFL2c2TzJjYWFIU3V1?=
 =?utf-8?B?SXF2YWdCdlNvZ2NHYm0vU2JKTHUvQWkzNmdjRTk5VWZIL3JMKzhsdUo2eStS?=
 =?utf-8?B?NGZ1NjRCV0JFR1ltaHpxVDIrdFZTampCMkVZbFNvbFdWZ0RiS2Rsa3dkTmQ4?=
 =?utf-8?B?NTJnMXNWMkRKaUpkQXNISkxzcEJscGdwaDBBNGV1WFQwVWEydTcxeWEvTTM1?=
 =?utf-8?B?ZnZXcFQrR2FvM1hvR0dId1h1a0pPdzVFYXJXZmc1WWJCOXEvTVExUHFET1B4?=
 =?utf-8?B?L0d4L1VZT3h5UmZZNDV2dWxrTGg4U01EQU9ENUxaQktOayt6OFo0VkhMQm1V?=
 =?utf-8?B?alVZVjZmRjB4R28rNnFkNEwwRi9maHExaTNmRUk4eGphOGJQTWh4bFhjSlJp?=
 =?utf-8?B?aHFHc2R2Z1BuT3BLcXVMeGJzelZrdEI1Y3haMTE2azBaWUhYOERzTGFFc1Mx?=
 =?utf-8?B?YjBzYUJOQzVtbFVkRjVQQkxDSm0vUWUvQXZQNCswRHdYZEphVEpWTkpCV0tZ?=
 =?utf-8?B?dHBneVo5UGYwQXFDY1FsS0liZFR2OGRvZ09MVm1QMzhmMWZxUUQ3UnczcW5S?=
 =?utf-8?B?alpQdElQWkt5YmlzMW9hT1ZQQnVHQ3lSZUdFS3ZhU1RWZi95WFdGRGlsb0Q0?=
 =?utf-8?B?WmJTbHB0alBmd3pZUXdoN3ZnMk03Z0lqUzhZNFZCQ0hsWkZ1VEtKb3k1K3lN?=
 =?utf-8?B?NmNJTWZWSTNaVlJYVjBCU255S3c4dndibnBURHRLbzM0Y2FaTDFLa0FFakdO?=
 =?utf-8?B?ck1TcUg0Y2hpRzd0ZXJWM2xtaXRYY2xGQWlxZlJhMWM2TkZkZkl1cnFxdXVE?=
 =?utf-8?B?dDBtelN4aEFsVnBSaVR2ZFlJQlNVNkE3RXp4U0FidGp0bUhQL3FJWDJoMkRa?=
 =?utf-8?B?Z1JBNXl3R1pyUTh2eTNia2htYUFRVUxiT1JjaXcrNkxmOEtSa2ZXbkgraVFB?=
 =?utf-8?B?U0RicjhhZnlSRGZmQk9OcWFyYTRxVjAzUUFEK0NjdmNDUmFOblV0Y1B5eGk4?=
 =?utf-8?B?aU1MNitIWWRYTWV6eGJhNFFmbkNJNWRQMVBUZnkrQVNITWRIODU5VkhSNXU3?=
 =?utf-8?B?L2NPYklWYVdNRXhUTVJld3pPalhZbXlnK2tJSlJVWlB2QjJTZ28rUzNYYzhN?=
 =?utf-8?B?NFBUODRkYVNjb2RyQkN2aEpheDhpOGpDaENESkxsSkxPb1NHQmd4T29DK3FM?=
 =?utf-8?B?dkZtb1FKcndYUUgvYU1mTSszYWtYNWFvT1U2allaTjdtVjV2TTNaWWtYR01a?=
 =?utf-8?B?Z0I0dkhuYUVHdHpSRU9yYXUwNlJPZDJIQTZ1K1pwRE1zL3NXT0dsSkRndTIw?=
 =?utf-8?B?bTNxaUlpaW1Sd2tjNWQ5b1c5RXJZejliZVpVR3ovVGczd3Zac3N4ditqUldi?=
 =?utf-8?B?L3dyaGRaajFIUllFdDlKbHBmUnpiZlp0WDUvVDE5aUtxcnltdFZ6YTc5TFpO?=
 =?utf-8?B?WU50a0t0Y0Yxd2xjSWJFbmxDMkRjSzlRdU9uWlJnY3Y5Yy9FUk1YUXIxYU12?=
 =?utf-8?B?YWlwY0YxWjhnbzFzbmJyWmxldW5NYSs3cWxqS1d3NmhKdWZtQS9rc0NwVmEz?=
 =?utf-8?B?am8vV2dMYnJPU0pkbENJL3VQbVhKQ0g3cGFUdWFCd3VYRnJXaFlJazNDUWk0?=
 =?utf-8?B?bnFmRlZFVzJPV1p3OGtUWGJzR3I1R3d2VTI2TGdnWjZjcFlEeVgrdVVZWWpN?=
 =?utf-8?B?LzIva0JVVkYweDV5MWtTNkpRUEJydVdNS1BDc2VZdUlrTFB6N1lFQkZOSyt3?=
 =?utf-8?Q?XjJg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fa22c5-5b84-4bb6-ef7c-08de11603b7e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 11:43:34.7723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXD9Qs8pViv6GLsF4IC9NQbzDiGhxBlbHlzMAi6MTtWmJENQAtt3Y2iiCTZezOXD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5960
X-Rspamd-Queue-Id: E4072120005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yimp1ynj6ic9jrkj9bxdfqaxnsynjed8
X-HE-Tag: 1761133418-518595
X-HE-Meta: U2FsdGVkX1/brDPwslyoZA5pvS4Gm1KvjpyLHQLAdmnuMj5HCk4sNXNDZMdZ+pGgSyWcgrEx+vxZwN2Yt7eA7HUlyP83FeJAzWqa4+phLYGuufEmG0YqPyaqd4dAP5FwqYgdCr7Alt6b12zqdiz/OCX9vbODAE633DsDy9E3/MBT+tMirr6pTz4KgE0FfPQQSLsTQqkfpHzmxGrIhfrEoEkPoYmndylwDAb2Ws3UlNd9t5W0LLWhSp0EqdP6ZlE9pL2tGG6xiHpJ2w5vjA9tsmD619LAQylY1c/QEcHZT4Auu1oXVDd9FjiI3FMz3rhmo5j8UHzTT6s2QJ7duJC+d1946LVo57LrV0LBVu2V4Jgx9wktXGMOcBhxiK8GHVc02S6auCUgm+akoMQs6qWkJnkh555iI28U/BEf/YpwZ9KXfp93+adqLQ9y7NAIm6wGHSRe/47zInuTDs8nlZuI03HA9YeAK5oVqY7ZIyh9ulB6ZjeHDS6nzN9H6pSkEqUrrYjlw28YTANW5vFnxnowG3s6zWR53wd6gKxNDqyihk23AA0RkIcKmmBgWdu5rIEuoGN4QncJQ9b4Nn/HXHp9WQoXMVEsl0fMXiPJVZShBpiCzWcLiDgtls4KnJmhOMaFR7u0dRKApRaL1Ha6riHjcHAEiwgO/n+fqtAS72fwyXkcpXTHlWBm4l5fCoGUJt/jJokjrBOejWGob0xm3Lh5gDgMhrveWrnEA+qqEdc3tG3pO+uznTvJ1oOohST91BdvoG02fTsRzmYD+Kb3nusAS7h847jooEFusogYRlzgS1Xr0oHmDJfFba3XsXm9bB5rbBwbRMCooiZvrdtUXItSz17C6XxrOuIztDO9631GlsLUcV/mBzhwfVoxHTpq+RSguLRIUyz4exd9umo5o2sJHyQLO/5ZkcbIrYeeFxBtd7Do1SYyTLD2kmX18Yrdl1eY4m/fa+G+S8xRBmQojnb
 iR3+5Y3q
 baJRhY6eP0b0HYF0ZYACRFSYwc4VNulbQsAn6S+bFOboQeq9NV6GNN530X5A31LDMQ2yKzC29Zu9OrndUc9ZVOOAjRMVBeJo9Pa5U/W9V/b22loZnMKve+8Hov7r6/mVtL0OZ9aqxrgUicIGJ5ErrT/Ex0hAvNCgzL5adQm0qnKYFdFZr9XxOBGydYBSPdIThDqofrWjuvXEVPIJQXf2vkhjZMR1uI7klp5vo9WDafsd3mSp+fJW22ZLTUrkjFBrK/sMk34cBaJRttF8CGlJnPXTSFwNOyIU0xTfTPjyKPzInzHIPYO6TJHfWdNbItJbeF2XSH8lUcSwyKRND7/ySBhRoiU9zykMuuCWhmYdOWQCoT3XAbx8y1HBHmh//EY2CAJ9I7m4tQAh05pUYWJ3cV5rJYgYV3o92aJr//T+AeDKx0oSiAh43ArCQnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:10:35AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 20, 2025 at 09:58:54AM -0300, Jason Gunthorpe wrote:
> > I explained it in detail in the message you are repling to. If
> > something is not clear can you please be more specific??
> > 
> > Is it the mmap in VFIO perhaps that is causing these questions?
> > 
> > VFIO uses a PFNMAP VMA, so you can't pin_user_page() it. It uses
> > unmap_mapping_range() during its remove() path to get rid of the VMA
> > PTEs.
> 
> This all needs to g• into the explanation.
> 
> > Instead the DMABUF FD is used to pass the MMIO pages between VFIO and
> > another driver. DMABUF has a built in invalidation mechanism that VFIO
> > triggers before remove(). The invalidation removes access from the
> > other driver.
> > 
> > This is different than NVMe which has no invalidation. NVMe does
> > unmap_mapping_range() on the VMA and waits for all the short lived
> > pgmap references to clear. We don't need anything like that because
> > DMABUF invalidation is synchronous.
> 
> Please add documentation for this model to the source tree.

Okay, Lets see what we can come up with. I think explaining the dmabuf
model with respect to the p2p provider in the new common dmabuf
mapping API code would make sense.

Jason
 


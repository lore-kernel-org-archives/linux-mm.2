Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5E2CF8553
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977416B002A; Thu, 20 Nov 2025 02:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929A06B002B; Thu, 20 Nov 2025 02:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C98B6B002D; Thu, 20 Nov 2025 02:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 660926B002A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:54:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1284A12FCA2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:54:52 +0000 (UTC)
X-FDA: 84130224024.06.6883E23
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013032.outbound.protection.outlook.com [40.107.201.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A8FF20002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:54:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=id2t+wYy;
	spf=pass (imf03.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.201.32 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763625289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pad6igYdvd3ravLoQeU4mGzsCHjI2hMmiOJa8jkjDiA=;
	b=xueLiTv+hOZaj3xqHpFQsXHR+myxNYyrzg4RC68LaEqOnMpAze/jGaXbgZKfTmLwy41Z6F
	uSvceEOOIOaxZf3Cx5AffGttgt4rIue8CiDDjo7JS9As8UtqrEbg8TfueB4ZTyz+91fbr4
	uYV4ryAzku4CQBYl8kCpu++rxaeYTV8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763625289; a=rsa-sha256;
	cv=pass;
	b=5DoaQpxa4AlVmnx4w87/wScZbfnxJE22Kkk1kXzNZoy5KJbkZcsedDF5wERBLXjs8OFB9p
	WNAj513DU6579MgnQsTm2kMOzGeo4IKbKajLfNSAo8uSmAS0OmN9wvxQBse/QciVrhGp9o
	Abkrvp/V5WOqCNcQRNzFGUQn3VIaKqI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=id2t+wYy;
	spf=pass (imf03.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.201.32 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aqtKGo8gDUuCeD/IbskpA3sCr7PrYpAX66k3CcBM5gZYKbNQGEQ4LOrrH3AES9c+iS5L1/aUakhh62jHq2arYE0mKNYt365b3d0Q09durg7tyljKggysTsclLb/dM6QKKOw9FjwpU3oXKiauAdbSBhYFqJ0D96x+cIyxulDjDOAwYpuo4/8Ksd1ElTSyoatsk5Vv9tYXQf+UdYInwpd9H+2eU8mEIqC/0SQflbr2/XoJUQbjbKH0LZmxe5Q4TzEjKW6mjN1azfs2eIG2jyCjCUjnfMuGAIb+EJRcL3xNurqQEevfF01wYQece5EXJBtHH90++AkYfTIS8rG4doz9jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pad6igYdvd3ravLoQeU4mGzsCHjI2hMmiOJa8jkjDiA=;
 b=gCJscsHT8MSxD9uYIoYmNX6vKe8bmccgIx9Ds51d2cy+D8JyOX44PduRLbmwybM8obecIjYz50JwteVpKJ7kPQCSsg3fWof9Hamv6R1RXofPzEiFLnbSECz2MX29GDkb4E9jxh8copl/tTc5B6yJTceTmiUmV1IHgU0IuUktL6AgwnfTpZjJvEDL7a9jmoINDpNni1S9ttrf/9NilJwmaOTn7hr1dIpu1sgwVWMH8Ev3+q82/gaPSDDz7PgPV6eSGieUsuVDrs8zJ71snUVC/u90IL28pX/fAA+7I19w5Lrnzx2ASLXRPwkamOVLfFawif6MaCOgN8DKXiYv7t1jkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pad6igYdvd3ravLoQeU4mGzsCHjI2hMmiOJa8jkjDiA=;
 b=id2t+wYyOvxycLMb5MZMTJH8ZDvK4l38dARjF68b9iZK4G+vfNeSBezirgdmOe6hQ6EvKFKPl6dhDCj3OKHeJsc+beecOskDXQls0/rBryKRNUDEGWt51yGjfCiGmPooMq/jrvUk4cb0IVbW2aLi3SomseXguxbQzyu4bYqXSwY=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 07:54:45 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 07:54:45 +0000
Message-ID: <209499e2-6a06-4291-ad4c-77230926c665@amd.com>
Date: Thu, 20 Nov 2025 08:54:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
 Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
 <20251120074137.GR18335@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251120074137.GR18335@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::7) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 8583f03c-9988-4f8d-6772-08de280a11d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QU1leXpqdDZqVjBuQUZCSFBsdDhndmd6ZzFqZ216NWs2S1FHTGcyeDhibXo3?=
 =?utf-8?B?aXJKWHNueFhYbkUweDIxM1ZkSW42cWI3dkhZbTRMd0NXYXlRWEUyNUtlTDRv?=
 =?utf-8?B?S2tkK25TbzZKdnB6dFRoUnhRSVdNd0wyREs5a1h6QVhBMndZTVFkQUVtakhL?=
 =?utf-8?B?UWF2cVlTQSs2RUhlalM4YTRKVWVjREp2UDYzNGpxSGlTamgzMXpqaUwyQkZW?=
 =?utf-8?B?eDRjWUxXUS9ENTZyZHVsSjFSN2grRXBCU1BrbFg0ZlpOV21KL290TFJlWGIw?=
 =?utf-8?B?NElnTCtVNVZVSTlPUjBmN0pubHBJMjhYczhBcFNzdUI5YzVUWGp5VWJXYUgx?=
 =?utf-8?B?Y051cE13dkN6bE9KZXZTVGkvSHVOY041dWU3MkF3T3c0SHhGKzVFdEQ0dk82?=
 =?utf-8?B?YWNHUSs5WHJWRS9iWnBJRW1UK3lvVXhNL3Z0b2hQUER0UHd6dFZkOXA0Mk5t?=
 =?utf-8?B?N0NpSVNHYks0ZTNSRWRITm1xVVllTWUvYjdwRFArMXROc01mZWxIR1N5UzFP?=
 =?utf-8?B?UVNXUkNKaFMwSHQ2NGRDOWhNK3lseHgyc1BkWWdpMDBEVy9Sc2FQK2pnU1hC?=
 =?utf-8?B?L2NhY0VwM1g3aDRGZi93bmh4UjF4SGNQT1JPK0hMZzNCS1F1U3llMDNtTUp0?=
 =?utf-8?B?VldxN0p4d3RSNDNXZk1aYWp0cFg0dnliM21KMTZzNzhrYUxXSG82YnBHWlJp?=
 =?utf-8?B?MGVwaStvTVFkY1YyTzh6TW5HMkZNQWhUZHdadVplVXp6bWdhN1I0RTd3UnNV?=
 =?utf-8?B?dXlWNnc1UHRaN3Y2bHlBMFdWMWFPNnBjWGNiWkZIOXM4MUdiQTEybmJpaGJl?=
 =?utf-8?B?UVM5eWRzdFM5SyttdnR3dmlQQlJtS0xsVDZ5bWVMTktLTmdUanJYV2ZnVmdT?=
 =?utf-8?B?NGxzTmE1QmhrOXIxdXVHZjhyOERSYTc5bmxFVmZtdmYweEVMNzV1RW9QeXl6?=
 =?utf-8?B?MXhVVUZsY3BaZmJ2ekhSWUFoVEVvQ29YeWFpRnNrdEgreHRjazFwRkdlc1hH?=
 =?utf-8?B?VTJURVRBOXFEYVVVUWErY040K0pYTWFWdjJId2lYcStJQmU3ZW4ydlZXM0RI?=
 =?utf-8?B?T0VWMHQ5T2I0V25WT1B0SEJxSHVTdElCSEd2RUx0V2xRcWR2ODZJcTBUS28z?=
 =?utf-8?B?dHhGakNzRmFsTnJEUFFpVDJmT3VTUmxiVzIrUXZFY1pJb29URi9HRGZnTGRJ?=
 =?utf-8?B?bUVBdGlubStIaFF5VDJoMENRMHV2Q0xVbU9kNkFqQ2NXSWtwMGttZXZ5UEFE?=
 =?utf-8?B?eUU5cWtUeEZyMkNIQXBSYTNIRis2WmwxeHBTWXRGSFkrcWVDSHBoM08yTnBX?=
 =?utf-8?B?OVAxY1pEWjNselM1UlZBbUxvYlBqNjducHB1cXhHbGdFTWJRQVVCZUV1NWZz?=
 =?utf-8?B?VDVvYlJ4REo2K2ltd2E1eDJaWTVWSXcwR2JjVi9UU3dIQ1dEalhNeVY3SElr?=
 =?utf-8?B?cGpZclFqNDNRNmpMN25vc0gzelhhTmg3STg5Y0ZuTTBVMDZrMEU2djFZNzMz?=
 =?utf-8?B?UEdlUk5KY2kxZmNHNUNkQjh3YjdEcmx0Q280dWxGNmNCR0JidUp6dWxGWjMy?=
 =?utf-8?B?bDdiWGFYY0l1UU1IRTYvanlTbGFuNTgvWW95R2R5ZVdMbUM3eExXNnJJNHdL?=
 =?utf-8?B?YURmanlNTXNIaDhEOUFNTXhqV3VsWWVhbldxbUJzUGpVeitDSUN4TzJTaFkv?=
 =?utf-8?B?K3NNcFk1aHlKb2tWcGpKV1NrbEx2Sml2b29IQks3K1IwckNRVU9kMUdGRW5K?=
 =?utf-8?B?NHUrYndIa3lNc0l4dTNSRnZPQUIyWSswS3lIYnlyU3VCcHAwSTB0UEFFeUJT?=
 =?utf-8?B?Y1ZXVDh4WVY2dk4ydi9vb0xlNE9VTFRESThGSWorb0Q4R3lSN29ZMUsrcm8y?=
 =?utf-8?B?dkxCQVYxWjBlYzhZL0ZKMWF4L0pRNURDS3NQYVdTaGViS0pUVFNrclhuT2V0?=
 =?utf-8?B?QUs0NXpkZFd3aEVTZk43SUZvNzg4ZjV1MDY2Zno1dHhhZHMrT0RTbnRpaW9F?=
 =?utf-8?B?ejg5SkErZ0VRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YW9od2lod0R4SlQzalBDWFJ1bERFUWN1SzhkbXlCYzdrUzZNcGwzc2RmNFRq?=
 =?utf-8?B?RHJJSmpLNmtjUzhqdEwwTWtDTE43ZDNTeXIzNEF0a2xzbEVnWUdldThqUEtm?=
 =?utf-8?B?cTduTFNPQ1NieSswcVBod2Yxb2lsMnZGQnVZSVlFLy8zOFVpdEZ1UXZSaG5r?=
 =?utf-8?B?L3RvREZER3BRUXhOcGxYSCt5bFBhWXJzd0ZvdVBpU21vTkFBdmVyWStjWldH?=
 =?utf-8?B?K1Brb1ZQZUxrclViT0FwK0FOcUI4MkFLa0F2WUZyZ0psSENNOHc3Zm0vRlgw?=
 =?utf-8?B?VDhHL1E1dk5NNGtPaitIWjNUR0RDKzBMays3Qm5pc25UK1F6VTJ4VjlBeWs1?=
 =?utf-8?B?cHBPcGpoTWZlcVo2UThsMDJ6ZW9aRVhPWW5xc0ZIdDIrdVcwS0hReWJncnN4?=
 =?utf-8?B?dFhqWGNOUHdWMmN5R2J3ZTdqRElDU2ZVYVNBNzh6enJDTzFwcE1XVkY1aEFS?=
 =?utf-8?B?UU5keTJIT3hpU09XemxtYlMvbE1TOE4wMGJ5dVZkMWNxbzJEMTE4em5rZmFi?=
 =?utf-8?B?RlREUWhGWkZibk9YbUVOeXlwMmNvTzY2S1hveGRwNytaaWVTdWZkYm9WaEVK?=
 =?utf-8?B?SVVhaXg1U3IxTUhucnQ4b3dXME56YlJNT2VrbytFNGxTa2lucmdNM3dCU1da?=
 =?utf-8?B?OWFHSFlFZVhralhKQXpnSVBESFRkSzJrS1JVTkZQUHA2MGlvdXdNdjFYN1lm?=
 =?utf-8?B?VG9EWGE4b1pubG1oK2llR2htWlJUL0M0MWh0bWo0M3VTL1RneEFBd1dML1Z4?=
 =?utf-8?B?czNBMFQvaFMwd0dXUVV6TlFjNHBWcENnY0M2TFovS1BldGVZTTBHUWlXNWVB?=
 =?utf-8?B?MUVta3lYSWw5blRnSVg2dWpWK3hmK3dNTUVuTEExYkRhdWtST3NoSkZiYisz?=
 =?utf-8?B?Sjh2ZDMyMWJhdU9WZW03R01TL21SMkRwSWt2TWFpMzlTQjdUTEVVSFVRaXZB?=
 =?utf-8?B?Y3l2dm5pQytjTzI5UFRHRE13RmJYa1k3YmdrREN1R1dDZldVb3BQRGsvdFhL?=
 =?utf-8?B?SWtrUXExbmdnUVdMWFZYMytwOG9kSG41Zk9hRGkwaUxiU1U1UzlmM2tzTkZl?=
 =?utf-8?B?ZTErT2t4NXNvSjkyNUN5bWd5WjB6YitHRmcxbDl1THduL1pYL1pLQkNkLzIv?=
 =?utf-8?B?RjNuem5qUkdFbkhyWmJNZnFmTHlhN2tVVGZhTnpWSnl0bDNJRmdQeWRPMExY?=
 =?utf-8?B?OEdkM1cvMlBkQWEvUmNJVDU2ZnNPTnl1RGRnSTBsbU11QWc0UXQxZFgyTEdO?=
 =?utf-8?B?L3FRQ0dOdW1iOFUrNU1HYjFTa2ZOeU1NM09PWUdhZmNkN3NFVXpQWUNBUkpS?=
 =?utf-8?B?TEp5MzRKZ3FpN0VXWkYvd04ySy9uVkRXa3VNTFVYR3VGcDRTOHhXMmN1T05B?=
 =?utf-8?B?OXpsejZlNWo0T0JyTmR5Sng2NThRb1Z5UGJqZU5IaHk3WTBiWjFQa29rc096?=
 =?utf-8?B?dys2OHNtMU5aaFFtSmxFZzZqdHl3U1Znd3Z6RHplbkRyTys4MndieDQ5UG1W?=
 =?utf-8?B?NE5LZDl3V1dHTmpjRDRRYzJtd2JTeVlTVExmNmh2dVNIMkxIbURQMVg3ODZV?=
 =?utf-8?B?VDkwMHFGbGxrY1dNa2oyVldIdk1NUEI3OENzYzE1RzBvR1lxR3BEYWpBa3ha?=
 =?utf-8?B?amZGUU4xSU02TlJ4MkUyalhmS0VkV0N2SFppR21RdDJUK3g1cTNrdHNOQjdU?=
 =?utf-8?B?amhXczZhNlU1SzVHV09GL01vc1dpYkdmUVJZeU1ZcEdkQnlFTTg3TFBBc2dp?=
 =?utf-8?B?NWdzMnhBdG5iVlhBOXUxbzVLb0hqeDFLaE01bGd5YkUvZ0haNlQrWUhUQ0ND?=
 =?utf-8?B?M1czYlVWMVY5enBZZnB3bnN6ZWEyTnFZL1lZWGhIdzlYWXhKaW4ySEFzRjN3?=
 =?utf-8?B?LzRtSnJvWURsYUk1ZU94REZhNGVCdk1rVlRKOWNDTVZHOFVJQ3ZJaVBMYWdD?=
 =?utf-8?B?MUxnMDFOcFpQaVFhUjFxSUtTc29wM2F0bWEzWkU3andJYjV2R0NLTjhaSyt0?=
 =?utf-8?B?ODE4N2ZRUXAxRWpvSGlzQzZGSjF5dWwxeTZEbXdQek1Ma3pqR1NMakl6MjZv?=
 =?utf-8?B?V2RCZmxHSDl1eXdlM0NyK1lEa0d3WWdSMVRENnZncmtsMnVsMjhvNHNOT2tU?=
 =?utf-8?Q?Cu/c8Fm+a4znytHl8tE5S0qZI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8583f03c-9988-4f8d-6772-08de280a11d3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 07:54:44.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4T3cMQ2Cx3Xf1U4lOtBUZ3aNCga9JLnUdkkiMO4e5zpEQ1nqTGqzowHaoD0F6lZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929
X-Stat-Signature: e9khrir3tspupy7jd1uyke6ofxwgsep3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A8FF20002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763625288-435008
X-HE-Meta: U2FsdGVkX18vAu6X1qmRH4k9NWlIwrNiG86G2uiQVL39cGzSyubQOUbA2Hdp73rzpcQPNlTBQgcU4u/IejlbwLCr+eK+R54DKO7aol/6dAa+c62Bz0eiVIYOiPInCgNFKQFgMSoAKdF4NePA7bdId0Crn/frfTBgTqWnHYp6TK6Ic1My/SitLKNBKHHyPCQLKHOu3lFJTbc+CCWEu/eo+g7bl0byVBA2wZFwqrbt6HUN4vIij7FhcayIt25WZQOQj6dh61Q+ncCvun7saZLMHFDBfD0tMc/5PhDLWCD+9Tgbnv7I/Eh4ifhEwUDlvNAxAinIZEE0/68i8LYVx76Doj0B4s/3eV+SbQ/haJ/fd2gtzQL7CXU8IoncTWpv94FMSeDhjOYUlhN6buMPzgn4wNc0HRXPAP0Aan5Tkz1iUS8ttdhd3BYbtrRjYwQbe1RxFWYO1/gfFtmsLIYGeYyvlyr4sPAe/+uhShi8BVGKGeRCKGcIwDGqehHsKh13AGvVAr8tXGBuiHtdlYyC3eIOGVmjOaCSwRj0M8vdpoPTWcaHynrtMgvl8KXLu9xxwnb9YPBAmY/U9kriic38OKN0TQwGUZI4sWUDBXAvNpuu0roogkW6b2vMvSWvL8jQ6231JwdYBrjlNc3++H74i6ql2vHv2gSU/5V7awCp1K4w8j9v6E2fV1KzavFWex1JuJU3nar3PGJBBa7nA0mXTu2itd19O/ZUQ4LUZEtnqnGdsLjw+xUVYi/BHaO9dNPeUh6BYwnaVFcnBFPFlWcMHGRjXfTLQ3QKhtDxLs3PAX6JLYV2RusNDHAikKgbsdDUV1eBYuHqGnYpR5YUVUIMr5pAw8CQz0ueiBwTGVlprdOO213dH8mwuidhALxlrssQz2E1x3hGRJMbijZiD7sRvltcAqIPyfIuFcwlZVFe0pKlymCyhRnz3fcWE+cv8wYVKTFhgfC1QNjWm29SZezV39y
 dXuuRXQ/
 XTom3k7LlkT2cnh+DS0/drncxAIGGa6zDOfkGbew9TCyVu4m3uw3R8dw+NrWehTZMeJJ5C/eN5RzqyGYySDZtsMWz17t24ieLU4sEOSAeLMShnvKt2oQIJlZCKjjl2terQ2Co13NCD7VmH/piadYexT58JgIVLXTTiP0zBMe1G4hPA8kSM0pW/6xuJmGe/TYtnFIJPPQXuzKb3PU0g93CJjA4KBUXrYFeGJM9Tm8tdUqt92csPTN0QESg3eY+Wq+dAqBXqGQwAos/+qb9F7TADV67NjpzUGOk7s+0PnnlFUFzHzKJQ6cdvgdWcMljJIliKwOR8VQjBt6/riiYccPlp2SZ2CbpUATkSXt1Fi6dd9BJMpg8TNcKXMqvZaw1Alg8Q6N+lU6FkPstGweZ308ynq/p1C4lb4IbMmVdz0MHJlMF5KD3Pk5HfHb57/thiZCd3XX3lnx8/DXo45FhtF4TM/idlyqgBkSOn1pHU3X6bBpvCKwInLCGP2Q4kJ0jacavxQ+JsbkZIR3jZiD7tHnN52lEB/Em8aBuCIJOlel26V1Ji8+dFuZ4Ot5NVo4z6u1UAeFQ6EI9rJDjlcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 08:41, Leon Romanovsky wrote:
> On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
>> On 11/19/25 20:31, Jason Gunthorpe wrote:
>>> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
>>>
>>>>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
>>>>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
>>>>>>> +		if (!dma->state) {
>>>>>>> +			ret = -ENOMEM;
>>>>>>> +			goto err_free_dma;
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
>>>>>>
>>>>>> Oh, that is a clear no-go for the core DMA-buf code.
>>>>>>
>>>>>> It's intentionally up to the exporter how to create the DMA
>>>>>> addresses the importer can work with.
>>>>>
>>>>> I can't fully understand this remark?
>>>>
>>>> The exporter should be able to decide if it actually wants to use
>>>> P2P when the transfer has to go through the host bridge (e.g. when
>>>> IOMMU/bridge routing bits are enabled).
>>>
>>> Sure, but this is a simplified helper for exporters that don't have
>>> choices where the memory comes from.
>>
>> That is extremely questionable as justification to put that in common DMA-buf code.
>>
>>> I fully expet to see changes to this to support more use cases,
>>> including the one above. We should do those changes along with users
>>> making use of them so we can evaluate what works best.
>>
>> Yeah, exactly that's my concern.
>>
>>>> But only take that as Acked-by, I would need at least a day (or
>>>> week) of free time to wrap my head around all the technical details
>>>> again. And that is something I won't have before January or even
>>>> later.
>>>
>>> Sure, it is alot, and I think DRM community in general should come up
>>> to speed on the new DMA API and how we are pushing to see P2P work
>>> within Linux.
>>>
>>> So thanks, we can take the Acked-by and progress here. Interested
>>> parties can pick it up from this point when time allows.
>>
>> Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.
>>
>> This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.
>>
>> So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.
> 
> It was put in VFIO at the beginning, but Christoph objected to it,
> because that will require exporting symbol for pci_p2pdma_map_type().
> which was universally agreed as not good idea.

Yeah, that is exactly what I object here :)

We can have the helper in DMA-buf *if* pci_p2pdma_map_type() is called by drivers or at least accessible. That's what I pointed out in the other mail before as well.

The exporter must be able to make decisions based on if the transaction would go over the host bridge or not.

Background is that in a lot of use cases you rather want to move the backing store into system memory instead of keeping it in local memory if the driver doesn't have direct access over a common upstream bridge.

Currently drivers decide that based on if IOMMU is enabled or not (and a few other quirks), but essentially you absolutely want a function which gives this information to exporters. For the VFIO use case it doesn't matter because you can't switch the BAR for system memory.

To unblock you, please add a big fat comment in the kerneldoc of the mapping explaining this and that it might be necessary for exporters to call pci_p2pdma_map_type() as well.

Regards,
Christian.

> 
> https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/
> 
> Thanks
> 
>>
>> Regards,
>> Christian.
>>
>>>
>>> We can also have a mini-community call to give a summary/etc on these
>>> topics.
>>>
>>> Thanks,
>>> Jason
>>



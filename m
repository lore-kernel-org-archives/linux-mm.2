Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B572CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36C08E0005; Tue, 11 Nov 2025 03:54:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0ECF8E0002; Tue, 11 Nov 2025 03:54:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD8D8E0005; Tue, 11 Nov 2025 03:54:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB648E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:54:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1589F12CE4B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:54:43 +0000 (UTC)
X-FDA: 84097715646.18.9C13DC2
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30692180010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:54:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=frNFVAsH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762851280; a=rsa-sha256;
	cv=pass;
	b=HRAoTWnPhLLY0K40MjDtNrEq2bmSExeEvG5UKS/a0qLo1gLVT6u/RvbTpYIDo9hvLcRXqm
	Je21ic/pSugmqKIWDLF2g+kkjynqJLRyrDhQxWZzz7G34xvyHtUzxTKV75nM6oG2LUNgHy
	NdB4Jtrvi/BqjiSj1elwmBdaYIyV+dU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=frNFVAsH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HSogeOULgjGakdGeJwHGr8EhkaVo60j5NpyI2a4FrY=;
	b=QQ350Ns0PZLzyJOdKGgIMh/MAtxghtJvcrc1cMCVbvXU0bX1TNEmyV3BZSw4W5iZZF+RQS
	bgBbgKd+1RqD6AVPCPv8VAeTejy5xMOgIAftzRsEl5db4WKntmL7LwEZvgBuGUzz8wcRyx
	MfVxmPtF4ccRHwYhGBe5gA5O14o1E8g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vop6QVVseuXAixFOBHWnFKK1zkLiC+bhbBa/CC1w3sZVVx27edoyE1pPqDCZukv/bzFYysSmSVVSEKfM/x3rii7ub89YKWbUJi76IUbW/mPAbQJTHtgzwPNwlMAQdP/v4PTtF8Nwq+l0Y74Bv62AcTnq7sOgdV2q98Wg8D0/yTX0f+KkZhLacP2rucUndOJcEYIEi5cu2osG1+IK9VXNWyy40aQMPag0a8AxqMm1h0UoejUhiCf/uQ2JYU/Kgev8jBZbckXcceFSOtjiwTg1aM8jh686WD8PIuk5nfZ60qHfjsxt9Z8FJb+POFOh+yyB1HgXzhLEV9Se5qCOMks8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HSogeOULgjGakdGeJwHGr8EhkaVo60j5NpyI2a4FrY=;
 b=ZGFPlv0PwyE8A+sDkJmoOyZ/61n+Xr7YjgssOiva8Dj2fTwPPWmx8zq2RYVSIObrIWIh4kdTXNwvgphFw1cSbvAmERkMy2O5JuOPAoQT8lw+pWY3+uKO8HplV/7hXshiFIcV30A8zGOrVW8b+XjQ72nv4VT+CtXz3DcuqsNx7H7gyA9AdhHsimfb8b3AgHeEHiL21uZIgrwKCSjQRoup6DoU/ETH66VEc/LnrB3hnYILqHeORMRHxD0BSkRJExHUB7THBIkPab9CnPDenQ06Q3GPb78rjcQhW/Gpk5ggeLT3ol3N/aaL/09qsJsB6YRsAq+2V8akwcFZg7fVYOIeaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HSogeOULgjGakdGeJwHGr8EhkaVo60j5NpyI2a4FrY=;
 b=frNFVAsH/5ef2g+Ws2MZ2xlI1LHfYCFZWJ+2RBaodRGFZePFdm6SXrF96nifwxrgiMydEDK4OJEZ26e9hgaQPiAbECZxlmZ13GLd9CGmz3M+uSw3JkrNSjNtMuYssj0G3CmQpROsfS4ZXD3jRPGolCDfZghQgkpDvxs/IKnN/oY=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 08:54:35 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 08:54:35 +0000
Message-ID: <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
Date: Tue, 11 Nov 2025 09:54:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251110134218.5e399b0f.alex@shazbot.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251110134218.5e399b0f.alex@shazbot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:408:ee::23) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 2970022c-20fe-4232-9e4a-08de20fff017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXg3aVdoaU43RWp1WGFnRG1jYS93OUwxKzZtT3dPNHVTU0JvM09ZRCtNUS9n?=
 =?utf-8?B?cDVuUHNaZkgvRlBEeWlHOUVQZlhvMFF5c0ZwWHFGZW80NkpRL3JXcEVXOHAv?=
 =?utf-8?B?ZmFoQkphTk9PV1Y4NHNKNTJhbWJSalo2bTlJbFNvbkZNSTM5TC96bDVma1Vp?=
 =?utf-8?B?Vi9oK0FSMUsvWGxnY3Q0WlFhUkZ0UE1jWEhEbWU5cUNvVEs2ZFU3Z0RGZG0x?=
 =?utf-8?B?Sng4YlZCU253YnpsM25HcTFKbjdGZGdORmkya25uR1hRRWJxNUR0bFRzYkF2?=
 =?utf-8?B?Z2dJSFlUQnZkbktaNTFlNjE2R0svTHBYS3VQVlB4Z2wzbWlnTGN5dURIOGN4?=
 =?utf-8?B?YitRYjR1b1lNVDJFR0lacmhzcitVZHpsVHQ0RjlmS2lNekZLaFRDcThWb1BZ?=
 =?utf-8?B?ZFBMYTlyK0ZCcGtGUW41V0hxNms1TERuN2gyejJ6aG1ZdFphclJ3UkpHVk9x?=
 =?utf-8?B?TnNYMklwQTBWNzhzUnc2QWY0blJKdVF2L05USmlqN1FkN0plc3JlOUVJcEhO?=
 =?utf-8?B?d01BNUtybElOdWdIbzRJRldTL1d6eDJMTStvRHJiUlBMS3pUQUFKdEtlaVJv?=
 =?utf-8?B?RElsZjBweGhTOWQ4Qi9rNFdsbVZLSlczV2dSOXZUZThtNUFKMklhTlh2QWxw?=
 =?utf-8?B?ZXlBL2tubU9RR1hIQldsYmZvUk1NU0xCUERsaEhyMWVNRzlLUGl2WU1wdXcr?=
 =?utf-8?B?NHpLYzRGSGlqQ3hXSmhyNVNDRi9xZXo5dSsyV0FGUFREakVNZG91UDFHKzJz?=
 =?utf-8?B?blFmQktsMTd0a1o1MXI2RllGc0U5K1dWdEFMME1rY2FqRFk4Yld5bVhROHM0?=
 =?utf-8?B?aXdKNFhZRE9wVXArL2FQT1M0TXI1NWM1SzlBYkJoUTNtSE9yVHpmQU8ra0Zp?=
 =?utf-8?B?aFNhYkVyWDU4WXlncWRMTGdOdkVZc24zZng4ZitFbytjM2RiQUxabUdRcmdB?=
 =?utf-8?B?ZWlrSlI0bUVodW5SKzhBMnVZQTRodTZZM3NkajRXSEpyaVJxMFY2ZkpYd0Vn?=
 =?utf-8?B?K3dWa3dnVExjVmtKSDhhdmZVajgxNUVYQms0bzJ4TDlNdDNvWlZwWFFoWmtF?=
 =?utf-8?B?NnZSem5ScVRtZy9ycW8vVUVFelM3R0lpNkpmYW9LWFNEQk5DMWJRa1dVN3Q2?=
 =?utf-8?B?OU9UNEhraTBBaVdUeFd2VTl2Vi9yajdZZm5wQSs3RFYwcHFwSjBRSCtoY3BR?=
 =?utf-8?B?WHVDSlRiaGRQQ25zRmRzeVJ6dWZUamtRc1huVkJtMGovZUtaL21MaVlmYnhR?=
 =?utf-8?B?UnBXT3ppazF5Q0Y5enlaK0dSWUI5RE11SnQ5dW5wTllveXVpRmIyVldJUDBz?=
 =?utf-8?B?UExHY0VoTkpSbkV2ZmFwQzk1SnVxenZoQ1RvT3JiWXJIZGl3Y2FpbUJvajJ0?=
 =?utf-8?B?bjgrdUxIZkFXQ1J0S1hQOSt0cS9HUGZkbUJMN21lUmk5UTF6V2t6dWhrYlZt?=
 =?utf-8?B?aWFWcG5OVUw5YTBPNENEVG1yWDNrZDI2UXV4MHlEc0o2MzM0ZlprSGFaMUgy?=
 =?utf-8?B?VGs5b05MMTFZOWRlYzJNTTBTR2N1OHpqczEwbFp6dU45SG10cTlZdDVDQ1N1?=
 =?utf-8?B?bEVyMUJoSnQvbVhmcEpuMEVpclErbUNsM0RKcGI1RlJzT3FPaXMzRTFUNzB3?=
 =?utf-8?B?MnlwSFlpMlZJUkJtQmRNZkZzNUs5bWFUZEZRU1VNamZkQmh6eUIwWXdPeTN0?=
 =?utf-8?B?eVBvSDFhRFNFZlVxS1ZENkNBbkM1MzFyaDlJb1l0cXVZNStHRDhXVGU4WlZX?=
 =?utf-8?B?QzZEZjNtRm51cDJ2dHBVTTh4cmVRTVBQK05YeFB6TTgzYytWRmVOMmcxd0h4?=
 =?utf-8?B?YmVIaDJabWlacEU1MnBnTENDbmtFZ3o1MUpXdGpHN00rekdJYnA3MG1ENTRM?=
 =?utf-8?B?aW9oeTFESHpKZkM5NUd5eUdmOWFiNjNzVE5YaEJDRTgrQUl6TUxYZkptZFFw?=
 =?utf-8?Q?qp3koc+mPao3o/Bk8RHIDpLXbwnYyzRQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUpXRWgxK1FhaTZ2MEpBNXlvVndCeGs5ditHbGNJZEJ1YTA1TWg1Z1VKa0l3?=
 =?utf-8?B?bTBpeE44dkZLNGpHL0sySm0yTzJyQWxwOFl2MHhjQWJVV0xKWHlEa2YxQ3Rr?=
 =?utf-8?B?ZmYrWU9GRk1LM2NtK0lvUGJHakZ5T1dhQnNGN1pTeGZtYWNXL3k5R1l6OU1q?=
 =?utf-8?B?NVpaRmdOcjlkSDBYZmlYMkRTdlZoUW91NzNHNStUZjVtUG1pS21NMVhxeGd4?=
 =?utf-8?B?VnMxY1lzYkE4Vm5SSTdEQUt6eDRFcGQrUXJnbmdTZEFiaWg1aWlpQnNqbjBj?=
 =?utf-8?B?dnNQLzRIUVZkbVdrR3FiTmx3NWFzaCs2cGhIU1o5UC9aVDV2Sk4vaUs4UHBD?=
 =?utf-8?B?R3J2RVVNcU8yU1JQdFJUNVhRbWN1TTlaNzExbENPRE1TcFQ2OFgyZ0ZCeFpD?=
 =?utf-8?B?elBleTBhUXAzcWYvM2tzME5laEdFVzFRc0NvekkwY2JUSXpzVUJQKytwWXZW?=
 =?utf-8?B?ZkZ4KzFYbnNHSUxTWEd5ejFmcjZmR09ReG1xLzZLdkFkUDVPOTBWZUhUdHNr?=
 =?utf-8?B?d3NCRldFeVVqamg3NWJTM2taRFUzblVXR281NmE3TTltd1JmOG42UEtDVmpy?=
 =?utf-8?B?ckVjSFEvNVErVmVrUzMvaUV3Q2lOVkpWUldCMFh0LzMyQytlZkE1Tk12cEdI?=
 =?utf-8?B?bmxiZmljM2JwelRKdDZhdDY3SGxmT0dGQS91VDF3cFRXdDR6cjRTeDlnb21v?=
 =?utf-8?B?bmR4RTN5cmdic1VSTStTZmZrVFBXYk9rSkJEU1Rsc3VETys1bDdHQ1R5Zkdn?=
 =?utf-8?B?aWtjTFczWnBlVG4vV2dTZEd2d2VZN1VMYU9XcDNxSTdDKzEzTVNJMXFKeFA0?=
 =?utf-8?B?cnptQ3RXektnbVJ5N29jSjc4anJQN3hjRXJmUnArNVZFSFRpWURwM0phQk9W?=
 =?utf-8?B?QTFBWC9DbHNZQjk0aGxGdEF2V2o0SVJFekZRUWtVRWJESzVhSXBDb2RtaEk5?=
 =?utf-8?B?emR2cy94Mm5KcUxoQUROREtZYVNCOWMreGswM1ZiUVJ1RDQ2TGNGT011OEJr?=
 =?utf-8?B?M1B1NjAvMmhHbnlwUUxiM2tKcTJDYkxMVXNjZFhWWFJIOFBVd0FMUit0bzR5?=
 =?utf-8?B?U0phdXRqYkNraVZOb0g5QzRFSlNTb2tndnhJWlNaalhESFcyZS9CRnlTSkdi?=
 =?utf-8?B?SFJqUTE5NmVCLy9kN0FjOWFTY3NFU2Q2NjBBZ1VFcklKRUJoTkxRQkVvdGV4?=
 =?utf-8?B?Q2VCS1ZTOEVXbERsZy9zSnNFTXFsVWM3dEx5S0J4NGVCZDFuTkdYSzdjcTBS?=
 =?utf-8?B?ckpBREsxQ1cwc0RtdHRaMVdJcmw3b0hKZnZManZRV2g0Q1dZOFVubzUzRFRC?=
 =?utf-8?B?WE1kcWxXRmJiV2NIdjhGcURodnJJSjJvcWhmakQ3ZUdSUE9QZ3MrTWZWMm5a?=
 =?utf-8?B?TGtvMGhRaUJMK29GZkpOaUlVSjZUZlc4UUE3eUVNTkZPbHdFTlNPdk1vU0du?=
 =?utf-8?B?S1BUUFRkVGVaSnQ3cmFsWGY1b0VDamw0UlZ4ZDEzNFdGYzA5Sk5SWGRaNndz?=
 =?utf-8?B?N2lYZ0xPRCtLTXliTHg3SFRZMmkxcDc0bjY5VVkrTmdsZHVwQUFRUXdEM29a?=
 =?utf-8?B?cUFucHlTN2RrUW5icStwS2hYUnRqVU53L1VoazgxbWtqY2tDL1F4NDJhUm5P?=
 =?utf-8?B?U0NlTWo0OC83UCs5S1VDR1NyVnU4eERINFpuNHVmUENkNTN5dXNYV3g3Zkt4?=
 =?utf-8?B?c3VHdGhJZytHcGYvR3V1N2thNHN6elowQU5pN200Sk4xY3pZSGk3ZEgyZ05R?=
 =?utf-8?B?OWFwVHlPNTZTdWJqNk5mVzJvZnRyK0had0Y0M3lpQ3FIWGgycmFFYXV1NFZU?=
 =?utf-8?B?K2Jub203VDVRZko5bkVIekhId0kvTE9WQTF5NXVEbDNEVGxNMlJpWm9XN21E?=
 =?utf-8?B?Z29hcGhIWk5SR0F1ZXRaVXJVQWJoVVFDRFdhajA1WFFwVGNSelVrdnhRR1Rr?=
 =?utf-8?B?d05PNm95MmkwNG9QYXI2ankwUDVrTG8zT0J0T2RtSC9mL1RZZUgwOFF6WVoz?=
 =?utf-8?B?S1V5MmUxKzJ5aDE1Q1BJazhFNmJxbi9vMkVxTUFUaGFHM3dlSTRkMm12SEZs?=
 =?utf-8?B?QTVpcko1N0hISjVoNFZDWmFpMWV6Umt3Z0QzVWNCdVpGVWFYa1lrRlVCaTRx?=
 =?utf-8?Q?M4cHLK3S5fcCTIX3vVT9PlA7u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2970022c-20fe-4232-9e4a-08de20fff017
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 08:54:35.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKHCWtDSyozt2GeTwZxTq5E0sJys9jWMYJp6opGv8Kq5WBAjVMM9o4xTBnv/HjoB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926
X-Rspamd-Queue-Id: 30692180010
X-Rspamd-Server: rspam07
X-Stat-Signature: cmpjfxcdipihxgygzt88msn61opzypt7
X-Rspam-User: 
X-HE-Tag: 1762851279-818779
X-HE-Meta: U2FsdGVkX19mxr54AKoCyZpZdkbegv1TPHxHvJsxRoRwgREoSFjkXyPgn2g6hiKNJGViWMU+T6Xd4Q/9hIryLLQ6iKh0QhkMa+1szevRHpIleP1GhGdU2h/GZy5+ZF2Zq11kOGkfI92tlTkO2tP+yZ1xCuiKpii5Y0dQ8Om9Nr3WgPIaIEbNmHrrjx3ufjHqc7WMpXrJI+TEueO/3yalab5reCDfGqpxj7vwsLmFOXYG1zyjRD7O8hbf6DDYXV9IGUSOIdx5shQAgCrE7EPS3QTWKyeC3RgQFEyJqiTf9KhHKwGOet8VUymelgXlK9unSw3lwn0iu8J/KanMVNU38HpzajpmPyTdiRZjK0JVtGX0B7pz2z+34A2tA7AYFliXtlwZXUdqaMeMIA/+/QMi2HS7O4lGJkdJ2uwz+SQWI8F1PRumK7eqNUiwGev/okyFMfs+tC6jLc/RHtGm+j31gD+KJOOC5w/UuZyQIQRWKBNWUrwNt5WDUakW8Fhq4h4Sxtf4ib3QvtimtdZKNfjgm85Jxz7fFsYhYsExcVfriJZ9ltiIA4TsOACttmj/64covgpGCFXqSb5noQ9/rgAepE0nVNp17EdioEwdY55+vCsY/Ki2LfdgqN9//NjgBNLkq2YNodUtKAC63e9JHkLpsJlWULFl+Ok12pkKIYKmDq54zvBZ9hkRMuZsZuplBGbX3ggLNwMmgaNHnrVlYW5i4Rlz1AnHFe8ekAN9LakSRLFmPTSTIITSd1OdT9qmlUD3jyubSg962FTfH+ew6edtvyYjzrOw/B6R5qq9rC8zFFCpoQEgmbyTOsh3JwCmkJPnSfS9rix2omE7MtUkwo84enTrrdThbYY/KngxqLog5K/n1vFUkoaq98sIU4BNcDF1q3DDM+jvveEUNT9HKbbvE/AobVJ8WiCM8+35RaDPJDSnAF8YtXc4cPRRg78ZJvvpr8bimQOU30rc5OWo29b
 Q/0Fn7uS
 2erE6MOSZwf0SMUcUgHh3HDUmYVDMTqPlX9RkmFu7JxHbYcrM8Joc/uXHwH+vJofa4N+m4C7uriIzpLpnkWPsoKCWi3RgYwNN2wWebeeC6scsrQzoProNMUQor2w6v0PdX8PsD7BVvyM8PuZQA3mJGGRvOtbqU4KdIXxWOL5FxmkkNDAoRA7ZF3Fo5uGGSuto6qidkVgle4hPSNUAv2Let1X6obDOgNz26iaGNqDdrdNfpfQwNagk7Z5gqNuDrgVP4QI4CNDHFaYhFsT9ruuQUb4EhTaww5KzeLkp9DzbQsm+h6Zbj73HrK3jTC5Gk4ZZJhQ3AviEna/TSx8JWOqvmYvBldTnslycYl2Vr/7KDEHQiMfCV7H7GtmPfFfDdsqVCdpydX3InZH3RISDE3kUTh/uRFDBW2VjxBwN2BReIhyV5EmwR+8G91oop6/MKU+qAjAZhCj7Y480raU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 21:42, Alex Williamson wrote:
> On Thu,  6 Nov 2025 16:16:45 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
>> Changelog:
>> v7:
>>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
>>    to reverse loop.
>>  * Fixed spelling errors in documentation patch.
>>  * Rebased on top of v6.18-rc3.
>>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.
> 
> I think we're winding down on review comments.  It'd be great to get
> p2pdma and dma-buf acks on this series.  Otherwise it's been posted
> enough that we'll assume no objections.  Thanks,

Already have it on my TODO list to take a closer look, but no idea when that will be.

This patch set is on place 4 or 5 on a rather long list of stuff to review/finish.

Christian.

> 
> Alex



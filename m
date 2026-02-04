Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFB9E8B383
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA556B0089; Tue,  3 Feb 2026 20:52:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ABAA6B008A; Tue,  3 Feb 2026 20:52:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855D16B0092; Tue,  3 Feb 2026 20:52:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 718F96B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:52:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1774CD548D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:52:22 +0000 (UTC)
X-FDA: 84405099324.14.657C2BB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 184501C0007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:52:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NAzAAYUm;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.17 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770169939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZIFeCCHV7++AHNMfjs96GoG87ulZzPyhMha2bHwFEY=;
	b=e+2kFf5JsYNOO7cg8S/y5fqO8Q8auNagW2NvUqE0EDmikIrpFEyh8N5CWRCzIzTmyAiQ1b
	ApAP93ewaN4fF0fgc6s9Z7yz5l0JQ6ujjKnpoXopjcH+Ditipfgt/y1lkCb6AOvLnAK7bk
	Y3Kmi6uWA3pQAyQ+1x3MsQwB6gX1UD4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NAzAAYUm;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.17 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770169939; a=rsa-sha256;
	cv=pass;
	b=d2sMHK+VmvIPvM2uhPwFaSElqIpu3oJvkt+WR2sx5U6EzGjylcVSk43v6Ifo3N7yJ9uyCW
	d7/XD7TQpj75GixsPGGpYl9glr9GkQaMpKWXt2bVFd8wHhJjeaMN5I4l83N2ChsttdGfc2
	Y+ZaaSQmZfoqaBn2gJ2iPtqhh/UtTo8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3vSp7hXozQrFXYCacU6RtSn0FmHjWYpn4IJh4QN4RUdPt+0077nirnr7z4x28m4GOVmySeVq41w6L4tntmZPh1jybOk3xDNj3TTHhgubcf/Abwg0epK3M1wC/B3YkfKne43Q7IpfDh4E7jZZBplmlPCT5M4b7X68zdY/RWuvmnjKye5j3IJEAeC1hosoZMVcpwUvDceKvjOx4Iv09Amj4+NjS8v1wYAG3r7Qa9Lli1i1081AJvnlpNF5unm99Se+2AiotcoCyIdBfR9lC/wKFaVA28Sp75sMkEYz26b0EgkiIBJ47q888bmMUZ7/pEgHDXHIf6j9GuwpeSXI+wQHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZIFeCCHV7++AHNMfjs96GoG87ulZzPyhMha2bHwFEY=;
 b=yr8+1c72RKrCy40D0T57yNxvJHc1Ex0LBNfvgGdfdJOpwUdy/idtHMZpc69jXgYSyyG0HZBV35WXomvfM34Pv78O9MzruxnjQK8BjqwHWIt+8ocAkQ/kJ5qQaKu4rxqxJWtRwmjPnBDNGRcbPRX5jcv0TsRaEl2Pf0Acq7BzfH8J0L0erhEoRpJ68R1j1nCwtVk+G6viV8mzsk2wQtHxCb+fhw9lPLDwHIBrxvlPsyUXncSAZjcs3k/7WNBymM1ApeOy4QhsakwG5Q9gd5FFs6EAu5woEkAfA8ceLfoUcM1Q4ay82BSYlH9HOKnrFZWDn+695ibNtcnW8o9zGOLh1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZIFeCCHV7++AHNMfjs96GoG87ulZzPyhMha2bHwFEY=;
 b=NAzAAYUmyefKE6xFd0cjVoUgZUONo0ON3d9kDRw57+3VBXle+jf88nuQI6dSZJ4tCALSzVzFHf6F7J1gbQgjqHnR+rUDMsX6e+gytj1OCbk2Jqn1rqef9RSkUf9ftgi9IFdgnmeuFAVFwrSYstElth2GxhkFYzocRQuAk85IVCjyl5aejJfaosarvcaNp0QAIiIsf8H5UGtUVyotwAsvL4Z05j2Db0i4FuTvexKi9vxyPAUOi/0mFmrXhvEaV046XLdr/szH/W+8h+8El6ewGI5xKD2PHrQKljsC4rdBs9MaZnOV03LiAotSPw0glfY6+TCLx6JnNb65AZpgMYm/KA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CYYPR12MB8732.namprd12.prod.outlook.com (2603:10b6:930:c8::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Wed, 4 Feb 2026 01:52:14 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 01:52:14 +0000
Message-ID: <cd38c301-5bfa-4c7a-bb7b-a4e2239b0477@nvidia.com>
Date: Tue, 3 Feb 2026 17:52:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: Fix a hmm_range_fault() livelock / starvation
 problem
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Alistair Popple <apopple@nvidia.com>,
 Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Matthew Brost <matthew.brost@intel.com>,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20260203143434.16349-1-thomas.hellstrom@linux.intel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260203143434.16349-1-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::16) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CYYPR12MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 10366b4a-958d-46de-7bd1-08de639004e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHR5S25DbGxBVDhQU0UwSzJRTHBUd3FSZ1orWk1XV3R0eGxXRnZJS3BhQTU3?=
 =?utf-8?B?bnlUUkZwbzJCWmI4Zy9xckdtaUd1U0JycGZTbk1tcGVrbklQc0JXZ1l4a0ZU?=
 =?utf-8?B?M2VYcWZldlBqbDlhS1hNSmd2VVE3NkFidkJaZTlYRE5ySnlEY2plZ2JPVWQx?=
 =?utf-8?B?bEg5OTdaRzN5NUwvS05ObDI0R0ZWSGcwZ2RueEpmT3BnSDQ4aWJFSVRaWGFW?=
 =?utf-8?B?ZGZXekxlS2ZjZC9FdHZDRnU5VDkxTEV1SlEvcCtDT2ZzTkJBbU1ic3BhZ21I?=
 =?utf-8?B?LzhwK1I0NkFhTExseEdNWUZnOFBOMFhZaTBqZjZLQnFwR01meDNoaCs2SURa?=
 =?utf-8?B?b05LclNKUjhhcGJYZ2M3OCtNQmU4WDNXdHRzYjlCOFBsTGl6ODZDSWRsVk1Q?=
 =?utf-8?B?VnJsTGJ6dkFodHNOam1hUFMwMS9rYWE4aXA2QnFKdTJtMzlHNWpmK1l0MmZD?=
 =?utf-8?B?cHFMQktqeWhORkVMNTFuSjBTZytzSkpVOU1TSEFqNzBqT0VZNlBoK09sZ2hx?=
 =?utf-8?B?TUQ2V2NNbEVDL2FaL1Jhb0wxemJhTVRaVEROZFVRVHRNQnQzRjJZdVZ2WU9N?=
 =?utf-8?B?RzRKYnAzL0JHcGxZNlI0Sm9LV05LU3ROdnRvaVZxdVlBeHF3VkM3VlRnVjFJ?=
 =?utf-8?B?Ny9aWFVzYk13ckdDUjZrcy9FRnVtZHJTazM4dEV1cnI0YWhwdU53M3ZtUUJ2?=
 =?utf-8?B?cUZrV05YRGlHR0NsVEVtWUt2THFMOUJ3aGU5dUdqUjJYRlkrU29uVVovZ3lP?=
 =?utf-8?B?YlRzT1MwdlBDdXpIVFlwZEJTM3pOSzNBM1JvTWtkL2xPRndpeTNQSjVraG1y?=
 =?utf-8?B?dm5Wbk0vVjBGd1F5ZWNvb2dMSUg5Zmcyb0tMOS81S3hlMGplY0J3QjlGOVNr?=
 =?utf-8?B?NThYSERsT0V6RmVsaWoyV3NkT1ZuVmE3M2h3ZitRcGNsb1A4bXBJazlvSjZS?=
 =?utf-8?B?b1FZMUVmQ0htY29Rbm9UT3dNZkl1azBzRlRCajN5M0ZDRnBMMHFUTEZidkkw?=
 =?utf-8?B?ajYzMHZiL0dEU1JTSjZKOHd6L1F1UEhwaFBSdE02ZjdCYlo5L1JIQXZtWmc2?=
 =?utf-8?B?Z1gwWXhIb2RicDdNL2tDS2IvZzB0YUE0Q2JZcGI4TlZqazhCODNzdmp4bktZ?=
 =?utf-8?B?M0trYnp4Wi9nK1ZKd0s4SkYyVXh6MDFLYWlYbjR0OVNmcXRHVmdlczNGV1Vw?=
 =?utf-8?B?eGlYMTFEYXM2dy9JWURoSlF3Y0VUMXlsTWJpM09MOWJ5b08yd2VBVmhnWm5a?=
 =?utf-8?B?ZTRYN2NJY0hTZEhSNFhFYTJ4TXFPSDAzMmNRWnUrT1NlbGJBUGZHaVJjVCtM?=
 =?utf-8?B?cXVvMHl5T0R2bnhIb2YzUDlZMHNkcEd2b0FvUGp1aWVKRXcvWHJiSWY2MEtY?=
 =?utf-8?B?clVUenNwLzR4V3BHN29GbVQ4WWNYdU93K0VLYlZya0lZNTZabFNqUmZiTXZ4?=
 =?utf-8?B?WGdXVWx6WEJJeEo5UGZOM1ZkWHRYbis1TERBbElNWVVxL1VTN05BSkM4Sk9N?=
 =?utf-8?B?ZEMreXZ4US9BYmlBd0x4UlgrUHJXR2Z0ZUl5YXZ4VjFYUmJneEpVellwTDd0?=
 =?utf-8?B?RlhyenhUaGp4M1ZNOFBkRFptcmg1VzVEcXR6T1hRRnhzZGVBRTR2VkRCbW8r?=
 =?utf-8?B?alVpdlV6T2xac3NJUjE2eWlaYXpySlZqb29XYmpMRmROdEpWR25INmkvUjNy?=
 =?utf-8?B?Tm03WEdPSndoTEdhWW9TcTVNZERIMlAvRllnOENENjM2Y3BFdWFkNW9ubkFx?=
 =?utf-8?B?T25uOUtMcHhwZGlHSGkySXp0dnNWUVljM0J3ZXhqSmErNEZrdkR5K1pneXpi?=
 =?utf-8?B?OFdUR1I3aHZaaS9LUThaTGc2Skp5WDA5N0VRZVZwUUxjMzk5aU5VblBlMjRl?=
 =?utf-8?B?a1FScHczV081RFY0aVM4NVNkbmhNaVJGQk5HMVc2RFVNV25ZWkI2NUlEMlB4?=
 =?utf-8?B?S2NBbUNudm1pR1dOSThYYnk3VVZWV0xIenNpUi9XWkZuWG50ZUdpUXAzdkxS?=
 =?utf-8?B?aEwrVTlhaU43b21Rd2hUZjBFWTF6SEM1dnhJMHpXR2xyaWNUcGJnUHhISElr?=
 =?utf-8?B?ckozbkhZVVVWdHd0MzVhLytUVW1waHN2ekQxUW5XRkdWcDV1SHYwMkdTR0lH?=
 =?utf-8?Q?H7bI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmEvMVp5VVJtcmM0ckNtRFk1QmxoZi96elFxWThKdjA3UVp3dSs3NHZhTDFD?=
 =?utf-8?B?bTJoTjBwNlZpbStFODNEL2QvZDE2ZE54VFlQVTlEQm9hNzJ2U3JRVUtTeHd2?=
 =?utf-8?B?UWsyQ3p6VXpONzN0RFFhTHVCWnJxdXFybUlRTHZqekR0WmdMdHhiYjVtV2cv?=
 =?utf-8?B?VDBlWllqQlZiZHZjeDJFLzQ1Q1pETm1ORDRZNTNGSlRTZ3dMWFhiUWpwQ2ZM?=
 =?utf-8?B?WjcrQzQzb1dnamNJbkllczBNdStGUmpGUm5OSC9TbnFBZGdDMEdpUXh6dGU1?=
 =?utf-8?B?aDRwUnRJSi9Pd1NRektWVFpXdkdMMFR5Z252bkJtRFdVTUptQmsvRVlsU1hR?=
 =?utf-8?B?RTBtQkJJd3UxS3hDakdIRWpTNnhEbDBKZGR0c1N2SDhxNXBjK0U4UDMwRE54?=
 =?utf-8?B?MUM3YVZhV1Z0eHZGVXpLZW50SDR3M1FvcXJOb2NCanVnSEorNm1RejhjeUwy?=
 =?utf-8?B?OXZNT0luaXB1OXpoa3IrTDN4MkxQOGQzKzliK1FJU1ZqTDZWNG4xUDlpeTJI?=
 =?utf-8?B?bWhCNHNZaUJrMVQvVkp6K09iZTFKbWdpU3ZGQnEvOFg2OGxTZ3NkNEp0ZFFL?=
 =?utf-8?B?UVhHWEtoN3pGa2xBU0h6T2FmZHBwazh2eWp2RlBkcVNaWFhnazkzYjJNb3Jw?=
 =?utf-8?B?Z3p0VWVEWDBjajM0SVh1MFZOZmYyTnRzUWVjUG53b3J5dlp0Wi81Wno1RlZo?=
 =?utf-8?B?TUo0YXplc2hxZHNjcFpwM09FczhLSC9aZi9xSS9ZZ3ZGZzh1TU1UYkluUVhn?=
 =?utf-8?B?TUZhOHZIeXZlZzBGQ25oemQ1eDdTMEJ3Rjk2NkdhU1huU3JwblBaSGxvN1Rs?=
 =?utf-8?B?UUtjdFZLMjREaENzbnUrcUIzc2YzV2xYOHJEb0pIZXdCd2FrSStBMDNyK2t6?=
 =?utf-8?B?ai9SLzNXTUZ0TmVidzY5bFZ5Q29yT3F6djUvcjNWUXRSZWZJZnF0V2gwcW5F?=
 =?utf-8?B?QnZ1TmRCZWJORXFKenc3MFRUUm4yMUQ0akVmSjZsekpzRFJMcnErSlJZeXZa?=
 =?utf-8?B?WEtSYURjeXR2azFHamt5U2FSdG9nODJXdmt5MWZ5TkV6L1pPZWc5WXJ6NWVQ?=
 =?utf-8?B?WGtrZUpFMDMrR2tZNGpDMlEwckFUdldaU24xZWwvVGhaSDRRNnMwbUluQ25z?=
 =?utf-8?B?c0x6Z1J5UmNVUnhMc093M2tlUHJUdzlWWk40bFJkL0M5UmRkYmVURWtsbWxH?=
 =?utf-8?B?R2RHTDJXakEyaVh6WWdKd3dtdkNzYXdMbFVrNUJQY3hNQkJmWklUNDBMaFp1?=
 =?utf-8?B?NjgxMlJVK0p1WG83RU40QXA1TFovK3ZTYUZ0YWdFa2xjK2ZxejA2N2dOdjEy?=
 =?utf-8?B?bEZtWmZmZWQxVWNSWmJ6U1dLTC9TS2RHUnk0YkQ1WVBHSXFXTWExZ0MwRkda?=
 =?utf-8?B?SVF1aFQwTFVLcWRYbGowU1d5UXFpMW9GSkwzeWVjZ1J1M2xHWkdKdUpxTTVX?=
 =?utf-8?B?aHRvbDlyRjZTWDlQQ2NUd3c2SlNWRFE4TVMrb1FyaEJCNlkxUkR5YTNUVFdh?=
 =?utf-8?B?QTVZWUgxREI2ZkNVa2tKMXlQcWR6LzhIWE9VWkRhdUtBL1NkejR3ZUdjQVY2?=
 =?utf-8?B?VzhnZzc4OFhPb2hybzlOUXg1TExsYVlzUnRad2w5WVV0R0JlUW83Zi96b2cz?=
 =?utf-8?B?ZmlZdjgyb3VPUVM4WEhNalgvL296SERnY0F2ZGlONG9FL1J0ZjhiMWhqWFhw?=
 =?utf-8?B?dGlhRERnMUJFSGZ5bEdtWTZ5NVpwaHNpTmNVWmc0T3dMRm9YYnFTQ2xoSmN1?=
 =?utf-8?B?RTlRcTc2aGRuQmY3Q2VLZGdPNHVHWVkrN0NURytkeUZaYUhwU3lxVmo4M0pT?=
 =?utf-8?B?VTdodnVNcXg3cFM3MnMrNjBXcE4xVlg4Y3oraDlQZ0FJU0RMbmgwTXNITlBi?=
 =?utf-8?B?NWZoSEpDTzRhVXEzdFh0K3prWVRtc1BrTUlZZm5TK0RGMjNHVS9tSTQ0eEg3?=
 =?utf-8?B?Rm53L3V3RHIyeVV6RHNvSWNTWnhLbDIrRE81QVFsZ1M0cUVPcmVJN2UrZ1U0?=
 =?utf-8?B?V2RPRVVMMHVleUtNSXNHZWZxejN4MFBzdEFNNERJU1lTMjBHV1ZST0Roa3h6?=
 =?utf-8?B?elBjdW9weDVOYUpMU0ZvQW05dXlrUnVWY1RZUVpZSGloY3FjQW51WFhWOVFM?=
 =?utf-8?B?dXdSaWFsODczRi9PenI4L1hBWXhCWjVrSmYydE81YmVNVkNpMTk3SzFRalVE?=
 =?utf-8?B?TWNUb1hseTBoSzR3Y3pIeWoyMEk5ZHBKWmdjODI5bHlibUxRUkszcU93eXU1?=
 =?utf-8?B?eEVjai81alJMMHYwTFhhMkpxRnlVVnorMDFDRkdyZ29sTnEzQjBCMDFBQWJa?=
 =?utf-8?B?SG5taHhhb2RJeU9xekVPbEdZbUtmNUVYNDZOOFpvYjVmZldSTkY2dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10366b4a-958d-46de-7bd1-08de639004e1
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 01:52:14.3762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsqNCDKw39mKNNcXoNCsNg2Vhn6NRIC/GgNDR/3zEwitMT6fanDBnV6H4ntz+lP+oUiFpCKTRjkIYUojcY8NNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8732
X-Stat-Signature: fku5gffeqhqcezdmh7tzmmmk6jhehbnu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 184501C0007
X-HE-Tag: 1770169938-794930
X-HE-Meta: U2FsdGVkX1/BR6933JdiCIpDZsFCUhKlHH9F53xpNe/4ghI261hkb1wpdUFkezwD2CtvN1ANjW+ttM/lrNj/IuBF7OGTrIx7VdCSIF3IJ5c2q4TKwY117ObBVPJg0KJkKOqNdka0B74P+Rebg05ZADAPcsY+DginPN5YgHo03hfA0GpYA11ijs/m7DKsxGsreKHaRFhtLE6CeElk7Hgv1P44tNDyqDN9PM0eYu3dCFjvktz2mF4foQiRDz4vif3sE2rL+LS7TQlt2+/Uw1ESeeDwTB+h9E/ATo2oa/RyeK0om7G7e83Vnpfa9Pj2rATR4mo3diOhDtbjm1OPIxDHD15EMvLm7cO2ghVLF05HAvXMPmGaTpV6f6PB2UuJmAj0UyDgcvfIrPQUkVJOoVi69U833PZHwY+ZfLFWsgApBXh7LU/Pf5ay281kF+q5N9oWTgkLIwLy7EnuRMchoL82cYrL5d5OVMLzZCmNnn5DY6uheBVZ4JKApDMT0g/W72akU1dTtTf8PKUpTqbdl46eUpQVfGAiXRapXr9PIyE/4WzaMKW/wB3RAKcQSCu5EVPwlGw21lpIC4+uA74Fioa9XlY1rq0tDqlqwtlpAMht+M7evqDrxEsVhfp1engIHgBaBFDplIuRX/ix4gvJUWIr5sibwrjA9qszKst/+WLEpDR+ORqcp7qfukXE7aVuTn+VO2Vv55mVmY8XS8K5+xJBptoYSzEmCvZts87no+aWPRf/tIysQlCub8J+cwjGC7oVSE+P1AmLdIl6ywgPwhLmMQyBJCwDXSQvglajo2eqNcVm4O6PDoBmKT35XUf9IRQ0WXAQkU9Wb3hPuBipwoTzPTYe5qvY5crGGoPqc5b4kdl/BzBc6S66Sj9CS1ciARd+Tdfd190E98WH+2xsNWRA1xvuH2MkxbSpbD75QaOA24N02x0rvGBJ5I9VwunmArJQFGH9TJc3kWCgb53JaHg
 5zFIPm4r
 9BW4QIGG72DlyvjQc639m3NXSjHXLbE7OladgE0TGe9VBeIc7fkK+hwmPNjaGRcgDhgmETZDu/kF4zfvyNDa4AqFw+3Omm/hMcfPvpH53xOCR6Xi61YCFnol3VHRGAmz7G0bvz6lb12D5SkqEELHh0Jdz1nEn0/8XZLk2ylH36VfG17L4H6ethreNuzYNlWYDf9K8ODuffw47dAmO9ut/PzO3ZN7mwveNjTW6zhhzTa/+63Z4iqsF1Ar1MEHtzBddZgzU7HDO1Sr7kHiiwKh/+sduNcDLu71YPDG8hd2VpptNsvCC0mDpvgqXKwTQGiPZieCNpNEuimfhQMjE8ASbp1wVeZH/Xdjw3AFQ4hG9KRzvTNevpZVtNZoKnNhBMiO83MK6G0TMcaZujD/r8YSbGTMjR+jJYreE6SE1eV8gDUQ72JaguisrclU+jNdOhnI8Ou09g/fhdJDudR/oOH0HmC9LeO1kwamereFZaHf68Qekwmo4pgXSILXIAV3gKX4ULmxYjM2WtDknyAxjXs/DzPzZgtSTtxuYw3gU08duZDLAJ7XSKRu9jUBx2epvhJjuq4wsiC+JECosX8FqLjbRbRP/lOAf0FoIfmh9/C7SpVP0WKXsI32ulVujvN26pyXi+sS3pFhSVwH/dvqsrmPwt1i6ldoNBCvAkOSX3Ids25oyN7xPEJ1Y6pLoxkPprN+Y6zG7aQAsQfhUMy7YE7Up78R9dmVjjQScm8qmQ1WONvBqSFWtytB6DXjoTEqa/p+qsjj0R7Qhn3oAUbgY5yBKQJiXVab4TjPzhHi44Pwu/Sn77kXFaV34kiO4ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 6:34 AM, Thomas Hellström wrote:
> If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> trying to acquire the lock of a device-private folio for migration,
> to ram, the function will spin until it succeeds grabbing the lock.
> 
> However, if the process holding the lock is depending on a work
> item to be completed, which is scheduled on the same CPU as the
> spinning hmm_range_fault(), that work item might be starved and
> we end up in a livelock / starvation situation which is never
> resolved.
> 
> This can happen, for example if the process holding the
> device-private folio lock is stuck in
>    migrate_device_unmap()->lru_add_drain_all()
> The lru_add_drain_all() function requires a short work-item
> to be run on all online cpus to complete.
> 
> A prerequisite for this to happen is:
> a) Both zone device and system memory folios are considered in
>    migrate_device_unmap(), so that there is a reason to call
>    lru_add_drain_all() for a system memory folio while a
>    folio lock is held on a zone device folio.
> b) The zone device folio has an initial mapcount > 1 which causes
>    at least one migration PTE entry insertion to be deferred to
>    try_to_migrate(), which can happen after the call to
>    lru_add_drain_all().
> c) No or voluntary only preemption.
> 
> This all seems pretty unlikely to happen, but indeed is hit by
> the "xe_exec_system_allocator" igt test.
> 
> Resolve this by waiting for the folio to be unlocked if the
> folio_trylock() fails in the do_swap_page() function.
> 
> Future code improvements might consider moving
> the lru_add_drain_all() call in migrate_device_unmap() to be
> called *after* all pages have migration entries inserted.
> That would eliminate also b) above.
> 
> v2:
> - Instead of a cond_resched() in the hmm_range_fault() function,
>   eliminate the problem by waiting for the folio to be unlocked
>   in do_swap_page() (Alistair Popple, Andrew Morton)
> v3:
> - Add a stub migration_entry_wait_on_locked() for the
>   !CONFIG_MIGRATION case. (Kernel Test Robot)
> 
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v6.15+
> ---
>  include/linux/migrate.h | 6 ++++++
>  mm/memory.c             | 3 ++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..800ec174b601 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -97,6 +97,12 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>  	return -ENOSYS;
>  }
>  
> +static inline void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +	__releases(ptl)
> +{
> +	spin_unlock(ptl);
> +}
> +
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..ed20da5570d5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				unlock_page(vmf->page);
>  				put_page(vmf->page);
>  			} else {
> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> +				pte_unmap(vmf->pte);
> +				migration_entry_wait_on_locked(entry, vmf->ptl);

This is neatly done.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard

>  			}
>  		} else if (softleaf_is_hwpoison(entry)) {
>  			ret = VM_FAULT_HWPOISON;





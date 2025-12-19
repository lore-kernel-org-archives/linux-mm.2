Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3054D7496D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406EC6B0088; Fri, 19 Dec 2025 04:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B53C6B0089; Fri, 19 Dec 2025 04:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CCE6B008A; Fri, 19 Dec 2025 04:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1491A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:45:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF6C2140494
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:45:46 +0000 (UTC)
X-FDA: 84235738692.12.16F1865
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id B158814000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:45:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nBWnVVkc;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766137544; a=rsa-sha256;
	cv=pass;
	b=JarO/WQygUnez4fFT704PK2SAjS49GFQMXLhdJNgk5SHyszTYvpTy/h+ZVi+MsZSST41Tk
	wIJ12hAseflsWQCvmdsc4i0SbaP/fDUjhTaFU4rQiZKo2BeAw1kt1kqZ+uiFw3spYOoUyE
	4M9UQHXxszNF5yfj1i5ae32FnDDQfs0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nBWnVVkc;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766137544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKyKkfv6svuPZZufc/4MSZikpkG5b0SxLlm+ykerj6c=;
	b=CVIxGaw3DsRwotI8Z4v269xJN4sYaGHu+aYpYSd/AMIYeXCROqQDMwgTcmq6GufzIL3ClO
	rGetTYbAKJSTpsUeDnjr9PQ2AU13ijPfBSWKhZ+16C22GX/2HRkvGdSfqlcjj6cGJbvWcF
	qPA3H10IMZowYYn6KhQEQJhQly0+RDc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpididfDKI6Tpk+aEfZo5VUMaciPytH7PB33LFxIE9HLrvsgeo5/LGkTYxHyBDzcgvMjytOj11vfux9lL943kU+q2tN7l+lWHn9FJAzRwcLXVzwJcAt5pPaz0CsrVpdjW/5tWxtIxcpx115DFnvlz+Mi8EqbmPrZacGbRjzZbktLPP7dO4UBvDybWbq1xcPVm1KwnHqZRBQWURXHM8uRdmTAJG9Qnormx/6TK9kN0DyTypSmEZefj//s3OtLmOYpisDFDXTbfJPf4SiNGs3DJUPaThEyoK3Dh/h1AtPHIyEoM9Xir6SntrehbOJf/BOLP4aZA3DkcwizUaOq9R1qFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKyKkfv6svuPZZufc/4MSZikpkG5b0SxLlm+ykerj6c=;
 b=hnw02LrHMzah2oIzNnoJyhgU6uHDuOMThaMEQMipF9JIuz4BHpSaFeTSlCtLkQzBjSOz0QLJ/9gHVFkClblEhuLXnnGKWFXc2RUXmpILYvKx1lAEnBVTfAfhf7l8lR7Ky1YezEIEiXSsCqz0lWWINgaN3eetyBSCQgoBgR8Diq9mSKNtoVhfpVSvOau6vAeuQ/U1z+6HmPIJVleKpjLzPyj5dgHQR8M5b0UYbUKMJPjDe+xRxgviGMXlZl+O5zHsezzpTI4b62GHIojrEac0rgvVNmniQfX1ccZaP6m9nt2gW/PpJz2HAxqJVX+tX6q1OZ5Ct+TI8fiDZDh9jMFThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKyKkfv6svuPZZufc/4MSZikpkG5b0SxLlm+ykerj6c=;
 b=nBWnVVkcORPqJlmEXIVT0JPRIudrVbW5xE7Tcij8wxsvb0EAG69smYvAvtmFhL83Syz/sobc57FErsrrJoDZaAD/L7EEzqwoZ8CAmK+OBTc7onDkF969Nd5AIMvvrHGXYP1cXL/R/Yh25gs4uqDhsYkL1c8k/EIVDfTTiPUFeBg=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 09:45:40 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 09:45:40 +0000
Message-ID: <b2623e1b-85f2-425b-bdf2-8846daeddf75@amd.com>
Date: Fri, 19 Dec 2025 15:15:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/khugepaged: use enum scan_result for result
 variables
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-6-shivankg@amd.com>
 <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
 <79fb5cb2-8a24-4260-a9e9-bdf2c5ef602f@amd.com>
 <b75674c4-2439-4515-9b4c-bc3d40f76fc9@kernel.org>
 <B6AB9DAB-7985-44F0-A0D0-9FE77D3853B5@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <B6AB9DAB-7985-44F0-A0D0-9FE77D3853B5@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0039.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::13) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb7c2cf-1813-4a86-441c-08de3ee35ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWg0cklkaG9TU0o3aUdoWFp0elpFUW5aQm9HcW9ZSnUxNUxUeWVsc3pRcGxD?=
 =?utf-8?B?SnRReFJlTmhJdGU4ei85Z2o5SlJqV05udTl1ekpjclRrTFNvRWgrRzF4UlBa?=
 =?utf-8?B?RkZ2Z2FkZm9OT1llWGcxRDdHZkxONlRJZm81OCs3YUR5T1dpSVpiR0hxY1Uv?=
 =?utf-8?B?MnlJN055MXZLZVljN3RVYnMwUVlBejhOYnF3Y3FCanBkSEVtcmdGS3BTVDVq?=
 =?utf-8?B?WUlkY2lORTM1M1NBV0FlWXJpNGMvQ0czaU5XVXcrQlRqay82b2xvd0VUZGpv?=
 =?utf-8?B?RDVPTE5kLzQ4c2xnR2o2SkFCSDJNZk05YW9jYmZmWFArOTBieXpvMkJRd05H?=
 =?utf-8?B?YWJKeDhBWEU3VzlnUmFsbTZYZHVwZU1NQVVWL0VITzFRd1VlN3ZlMVVuVU5V?=
 =?utf-8?B?eDhvVElqdjZvaGZGZUE3OHpVSWhlZ3JjVlFWZEh3UTdvU1FTTENrdDNrcm1r?=
 =?utf-8?B?NzBQaW5lQnl2TDFyRThhaHBuNk1oVmpyZFBCVUZhMUhITlFpQWRlbk9zeWpu?=
 =?utf-8?B?ZkhaZks0MC9PMmtkWlJpM243ZmJiblByRWZPUFk4eVhldC9QMWRvcDFPYXhs?=
 =?utf-8?B?V0VhZ0l2U29IVzRFbXJwOTk5RGpSbUVuaG9OOFJxMmZnQXh2aDcwd1dCYXAr?=
 =?utf-8?B?TWIwMjlNWCtzOEtkd1VEYithU1ZGMyt3VUI0YjliNkFGai85dWVSVDR0dllP?=
 =?utf-8?B?Z3RrYytCYTNUQ0s2Wng2TXc4S3JEbEFHdU9TLzRKSFM5SWlsV2M0OHFWYU91?=
 =?utf-8?B?dmxLN2tIeWlCaEI3VXpCWDJWK2hPTUlHZTF4NkVBRmtSWGIwSzFBeGJMMmhr?=
 =?utf-8?B?cTAwNmJkWkVZNlF5V3k3bG1Ha3N6dCtzRmVDdEphUVdBemY0blloSjlvYzVz?=
 =?utf-8?B?NmpFVnlEVFloZWxrN2YrOWtEelZZYlJKd29yNGFhQXZOMWZVV2JvOWp5ZS9U?=
 =?utf-8?B?VHArSTdPY0szSm1TQkg0Nmt0MWZsZC9wTjVmT3plOU1hY1dadG51OW1haFg1?=
 =?utf-8?B?SnZRd1E4ZVJiUC81aUkzWjdTZEI4Z0c3bFk4aTZ4anJScnVZZjNRV2dJcTZ1?=
 =?utf-8?B?anJZWDVVN1BreFJRS253T3NZWmlicDcxUmNnbjNydDhTMEplaSt3YjhHRVhk?=
 =?utf-8?B?eERsbWZGTWJSb2JqaFhobU5PQUxuN3FkTFIrTmVyN0FhaWwrQ2M4UU1vUEQ2?=
 =?utf-8?B?NWF6cHY2UnVBVkJYL1dsVVFBY3IwZDYxenRjckFsN3RSY0dxQytLK3BTRDBu?=
 =?utf-8?B?ajBDeGtaS1U3TDNHbEF1ZTYyZ1NHVVVhQy9oTGc4ZnVpMFVsUWpPR2JvV0VY?=
 =?utf-8?B?NTdGaDlYVWRhVkgyWElzdDRZZnlzVEV3aFdsMkFrMjZERVUvZmdEeEc2MXZh?=
 =?utf-8?B?eG1yWDB2Z25LOHZ1cE1jK01QY2NReGx2UGZLWU9QRnFtQWtLL012aVRhMWpY?=
 =?utf-8?B?S2pXWEc3NzNIL09OTk0wK1VaazNSb21yR0JSdFRIem1LQXB2dTlDcE1iM25J?=
 =?utf-8?B?ZmN1a2k1WGN5VFZjUWhDMXBmeGZwQ1VZZGNtVHpqbFUycmpaSHl2cHBla1My?=
 =?utf-8?B?RGEwRE1ISlNkOWxLUHl5cktkNUxCNVR1bHdMQ3crS1F3OThxcUxUVE9kZEp0?=
 =?utf-8?B?ZktRdjlnZzRMRlF1Sm5aQS9VZlg1T2Fxb2VNMVVLREVxNUpqODZVTW9ycktn?=
 =?utf-8?B?QVZqNjA0WkpOMmRqRWJvNmRwSytCSjhkQjVUbVlmWE0xSWdTWCt1dzY3eWNh?=
 =?utf-8?B?N1hYMkI0MGpLSXArcUhNZnlXZ2ZxMUJidkgwRlU1cWhVODArRlR1cThyZEc2?=
 =?utf-8?B?aUZObTlIMzhxMy9KVHNWQXk2VE9xWnRZcDZFdlZsazdCc05OVklMWDdYYjZ4?=
 =?utf-8?B?NXdRYms0TWhqbmVXU0pPVmthMXRBMEZGcWNZQVcxNHlPWG9GSnd0UVU3NDNp?=
 =?utf-8?Q?vJS5AUp1CyywevdVx/DpsiFTzBwnt95y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHp3Qnh6Z21EV1VLNTJvaFp6N2MzWVF1UzNMSFBxVU16T3lGZ1drZGU1S2Zx?=
 =?utf-8?B?MitxRElTTXpXNkh5MDZTL1MyNmh6YkdGVDgxSlAyd0JGK2pWdm1EbVVIbWU2?=
 =?utf-8?B?YWU3QThBUktqWGxwR1pCQXZ3WmVWbkZSSjJlVDhqMFYvYzg2NmJhNWdjY1Nw?=
 =?utf-8?B?K3dMbzYwaGJkcXEzMkRjN05CeW84dGRudlBRd3pSNVB1eDZDM0o3TzduTFhG?=
 =?utf-8?B?d3ZXUVVRcjIrZEtyVGFaaEtBV2xTT0ZpWGNzNjYwWmNwb3dCR0ZyM0VDYjJ5?=
 =?utf-8?B?b052VDZBRzJXZ1MxSUFqVGRwN0w4WmNlN2RFd1RveDhqRXgybWRLelBqY0tW?=
 =?utf-8?B?UnhzbnNoTmN4a1FDSmF0a0FkRXh1VVBoaWM4SE8wREVOM1A4cEx6MGpoR3VL?=
 =?utf-8?B?Z2RCS252b1BxNGRQOWFSRDJhSVNNak5JYnVXNlY5Q1FVWkZCK2pXQ2FiSm9R?=
 =?utf-8?B?T29Tb3IzbzJKR0VaU2lrVEVnTHBleWJTMDlCRDIxTnVJQzZ0ZHl3MTFyajhG?=
 =?utf-8?B?c1c0SG9zdzJrcXZuUUI5a1NMczJia0JqNnR5ZmJ3MmZSblNIY1RibkNFRCth?=
 =?utf-8?B?YUNMdjlVSmpKd21DVU9Tb2hCL2IyUHZKZUxOTWhhRTZwcXNaNjRmb1pJdE05?=
 =?utf-8?B?RFR4cTU5aVdBTEp4ZXV5MWtFWWw0WFlURFMyV2g2dk12RTBONDkvclVaNklu?=
 =?utf-8?B?RzBlSUhHOVdyOHUyR1FLWVRDeUc0VmtFZkxYMndBL216eU51cUFpbVl6TllO?=
 =?utf-8?B?TmdhbzlUNndWb1ZVV2p5TENVMkV2NVgyaGhPUlBKS3o0VGQ3QllrNGp6eDMz?=
 =?utf-8?B?NzNyaVVtZWFZcmM4azN1SzlrUkt1TE9zeDVUV2hqdVJCeWh5YVR1bkFKT2VB?=
 =?utf-8?B?eTdablNiZG1vWDlINElIOW83eVFXK3N1VkpQQnhYODMvOHBFNGJSdnowVTdY?=
 =?utf-8?B?YjJVZ3RBaE0yMzBhekxwYldFdjNmM05SSEZLclNDZUUyai9OVnlGZEgzUFp6?=
 =?utf-8?B?QldEU04yQkRBaUVjNjhsY21WM2d0eDYxRGUzNWtNUmIrOGwzMFFyUE14dUFo?=
 =?utf-8?B?VG5XOXRMUFFjSE5Ld3RYVlpKQUlvd3BqWkNwRWVIeUtRUElsbnV3UEhmVVF1?=
 =?utf-8?B?anVtRG9rMkltR0ZNNHNRTDJwT25jTjlzYmIvUUEySXhjUFpwSUp0V0U3cjFZ?=
 =?utf-8?B?MUNDcEQ4RTcxSFM5M2pDZVBCOTd3MjBwcldQVGNIMHJuaEx0Z2RVTytTUzdk?=
 =?utf-8?B?T2JYVGxEY3ROb1oyMzhseFRieWRhOVhoa1ZkYXFJWGNmaXJldUFENVdSNWlk?=
 =?utf-8?B?bHZXeXFQdm5SVDcyclE5b256cExXS05EdTFDSkcwcmpwdTFoVUtOMjhqSngv?=
 =?utf-8?B?dTBhcnNRWFJPZmZXaFI3dWV4NE9sVVRiZlFXaWxIdjZRSTd3MHR6SkFEckhO?=
 =?utf-8?B?WDNvazR6Mkt2VExnSkRaWU9Ga0pOMUZ0M3lOTlM0VXVMRzM5OVNrSm5VRmF0?=
 =?utf-8?B?WndMZldPWjdDT1MvMFh0WG4xNXdxS3Z6UW9USmozc0hORmZySUNjUStjTWFB?=
 =?utf-8?B?aE9aWk01dXVoT0ZNZjNhdWlIY2cvR3hPd0hoMUZDcjR2Zlo1WjJXQUlTdEdx?=
 =?utf-8?B?TmtyNXB3ajRJZG00YWtjWVNzUkVtZW5MRXlmMGJBVUptUnNzbVltSm9UZElt?=
 =?utf-8?B?YUpteGRLMlZ4eTErOVc5bURTcCs1bWZDbVVBeWUwWUc3eGs5dzVZTGdtUFFa?=
 =?utf-8?B?a3JRTlcvYVlUU2MxaDVXREg2Z2loTFNSZXVFRFFwV2RSaXBwZ3gzVjJRL1c1?=
 =?utf-8?B?elhsRGJvZTZEQ1JqMWcxSUFFNHk1WHdSUUhpMHE5b2p4MHdyMTRTZHlOS2hW?=
 =?utf-8?B?Z0VycDRkbm50dWFzRllVSTQrNm1JMmpScG0zMHJJVGxqdk9XaWNRWjlJYnlu?=
 =?utf-8?B?UE1YK3NwRFFOelZBVU1VdXpQUFo1M2cwVXJSMXBzRXFVdEpoRHBPYnNubThj?=
 =?utf-8?B?SWlQdjdNN2xyNmF2V09zS2hQcmpqRTRQVDZzRjlJN3N2MExoUDRSbHo1RDRP?=
 =?utf-8?B?NUZuQ0MyNWdyTTVhN0JhamI0LzBxOWNqMkhUUFJMeEhYOUhPNTBuU1A1Nm1q?=
 =?utf-8?Q?L4cPxEQ4GXqCZa649ww1GsCF6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb7c2cf-1813-4a86-441c-08de3ee35ea0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 09:45:40.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hs6xaEBbq/qn2CRgfDzaPsA95IoFEr+t/gM4Bje6KWZjPQDy9cAkwogcw1pfEjV/xp0GEd4OR2/h0o5k2644Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128
X-Rspamd-Queue-Id: B158814000A
X-Rspamd-Server: rspam03
X-Stat-Signature: qp9nizo5t6uesfxte3uy6mxc7amtb4p4
X-Rspam-User: 
X-HE-Tag: 1766137543-719837
X-HE-Meta: U2FsdGVkX1+A/ajwUcdmCuJZLnF0BOPLiIaH6WyYmvtg3O8SIwFi8IXelgv5iX/4FBcOI3Hsas0wArgHsrKrIhBeAg2tRot5VLDWLgqOjc5PGhfhhA9hIXQa08wqm/UQ9Xf094lCGhPSPSqrKfUac5NUzlwUwwE59+1RIQ5OyBWEFTP8njOw0agDND/UwPxrzJQfyyrH9FPp0XqQzzekxMh6wOeI1I89c+grEQnTsu7Vn/m86MNRy12GizcI5PrflGS24c59+A8OkasaUgvRS1gJGWztZFfXgY3chlLXj0GyL0kMCOmaO3pafPLgTZK7rWz5nIXn0uGoe1k8q2yGUdcW+q2nA7WBDBEh5WpWjPHhTMw0kiHAvc2DH7H4ceEaNUIfrhYtYFlsFWdFfDABwkJ6SCuhQ8h2PbuTGK5ydQ5yKa1eI9Cq6mBpRQHIzU3K51puk6ceNwviuznQ07CS8jDfw8v1pWSxRgetDwPhmcgPNZe5yHDrIoS8Z5MN/MwkNSys5Jf1OnSQ969CE95OZlFFoPOHfevtawIhGwJk+qX+ZKYCVfpyerUvNRnBZ6noZ0ziOh0NmyJ222kNT53RvoRPXv2rk1zyZRUYyAfLW9EQS7dz8DgZUp9dVmbqX6uZfsEJsozzAeL8za9jLlPfkPTwdvLA8ywmn77Th7WY7w7IzHWiVY2EFrCIGy+44NP3L354smZQ/YfkhZ48mUJDKCCFgUXnmKJ1hUL3QIBwyLoMYXIILdUNZz57RyiKGFcU+aCvfL2fn77Bcbwyr6WLF29R3MtnNr5fppDsZEvZSuxgmbqX+n8HztSaG2CJ7ul+z1vaSCZzaWuh632tBfO7l8PvtVxOy0GKgZcSONyqc79bVF6KoJXnEorQUtjHnEA+0Z99eKw84sSLC3xZSZeVYyRxrwndaa0xvBNE+iQ3ar1gJPWTAhwXOtVxk8EHKLFW2ZY5lHPvOUKx/mya3wp
 h5N2XowL
 G8+7Q9WmoOVvClxcbTf0LAKHcaEB5GOj80X4wk5pfSz0zDa8ByTIP+moZ/uPHjEdlyR5UYiLGIpdgNgpN0qP50qHMT7t5wg5vcA+tMESUIz7eLbcu4hDJuUbzHkcgtHrVJJZhTaNwTUSE7JTqE7MxzXY6jztALmJ1KbxefDCDDnTGHYNUzZgnt+KyPQa9xXDsnbafQ8dQfFyV7eTD5r6GsPUAO0A3JX+0Z1b689lULmz/YM7oJIFrQgvLt/9UtUMC3tlVzD5IfdFfgfPfmuL7WTUy6ASpqPqxRGcMy5Oii+Mop/o/whpVC3dtI0pl3GGJx3m9iqPzEfwz08kl17Jo0JkthgUr/Fr/+B8NDA30HCxccpdd5YtNHmEOTCuT2e6Qwm21/tiSHuIZNIYa72qT7k8mFsUXgIs4p+5kJLtUO/cuac4dOaNmjKIEPjRNdO7VNo3k+OlBkZLYvyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/2025 9:24 PM, Zi Yan wrote:
> On 18 Dec 2025, at 4:17, David Hildenbrand (Red Hat) wrote:
> 
>> On 12/18/25 06:40, Garg, Shivank wrote:
>>>
>>>
>>> On 12/16/2025 9:08 PM, Zi Yan wrote:
>>>> On 16 Dec 2025, at 6:11, Shivank Garg wrote:
>>>>
>>>
>>>>
>>>>>   int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>>>>   			    bool install_pmd)
>>>>>   {
>>>>
>>>> And here.
>>> Since this function is declared in khugepaged.h, I need to
>>> move the enum definition to that header. I see two options for handling
>>> the CONFIG_TRANSPARENT_HUGEPAGE check:
>>>
>>> 1. Define enum OUTSIDE the ifdef: This allows the static inline stub
>>>     to also return enum scan_result, keeping the API consistent.
>>> 2. Define enum INSIDE the ifdef: The enum is hidden when THP is disabled,
>>>     forcing the stub to return int 0 instead.
>>>
>>> The only external caller (uprobes.c) of collapse_pte_mapped_thp currently
>>> ignores the return value.
>>
>> Probably best to not expose that enum (especially when nobody cares ...) and instead expose a new void function for uprobe purposes.
>>
>> Maybe
>>
>> void collapse_pte_mapped_thp(...)
>> {
>> 	try_collapse_pte_mapped_thp();
>> }
>>
>> Maybe something like that?
> 
> Sounds good to me.

Thanks, this makes sense to me.
I'll do this.

Best Regards,
Shivank



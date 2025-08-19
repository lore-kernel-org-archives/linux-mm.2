Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F89CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17338E0029; Tue, 19 Aug 2025 05:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDCD8E0002; Tue, 19 Aug 2025 05:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6F88E0029; Tue, 19 Aug 2025 05:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9735C8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:55:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38033140506
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:55:49 +0000 (UTC)
X-FDA: 83793050418.25.3796E40
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62B18160007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:55:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wv6vqF3+;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.237.77 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755597346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAHgzqJsB8zqAoS5we1uOaCG9WI4RTtOircvBVOb7P8=;
	b=TgfdO9T7wfHVz5SNdLCXyBt0chT2IITFODjrB3He9yYvYW5wVCLbDF6Clwzo7ZPmrGv4Ba
	C41EbNEYCCicq1hHLuPBsoxqquJHsUp9glRzdrwY7c2Rbm7hVvW544aLhZN1QtOzTB2PWe
	4tX4orqdvpxxMBIQ8+smmgHATDVd1a0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wv6vqF3+;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.237.77 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755597346; a=rsa-sha256;
	cv=pass;
	b=te2eQjBvtpixq2ZOVrAtSBp7oBwkThZHWtM7wLU1OiCkiJy5m/kD/vCctI9VXEsfUzs9va
	xs0AEnd33w5WEVKcuIHjVGFoxakFNnmWqYq9/IQFUrnlDoaNEu1+o6IQa1dhibWS7ELOS7
	CpyQROCkSq2SXiGJ7DL5ahl0QCSSabg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qg2UqUoOq47gRhDyI8FlXbPcw9YCJJ1NiluDhjbvTF0HBJHJs2VXj/2hJs0Qt9wk8zvSBK6TKgP1McJfHhHbLMxNVBJwW2zcbo7yKVCSS7eRZ0uenDplYNZYSUPbnmldbiBq6IytwfAhSv+KtWWIUXUKZk19GP6a43nD5PveXukSceH2FKMflJsyy/xOzhKe23tLqECLgh9SW2H2qqdYa6lHS5QjxMEEh70BLxQawc9HIGGigCm0RG2E3vxS9uDwfoHdm+gD+bLViOXPUW4ufLPMRbER7nTaZfYLLxbR8kfwWe26cSCW/zGAsOxaX1NPXRiBETreDF/IVFB1iJN+VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAHgzqJsB8zqAoS5we1uOaCG9WI4RTtOircvBVOb7P8=;
 b=idSPsRfDn0E4aO+/A1hrRNTkDK9+db2m1aPTQ+0psatZuVqgzbN8SeCLfCCoF8EJRWgecfW4cCIZmpxqjrqD7JnddGQ843fkfDypZ4bsUpdEU7ZL2hGAVLrk8x+nxYdSk/skNkLOt/soyQUor62TtIwcMpVSHB9MzK6fpbXgwpx9ylx0Y2OmO3ty27aouDeVoYZU4s314F6r9m0IE75lHNjVfHQbQe9Ik0+QvT0ztz1iMk628zF62XKXMeBszMDkWGPHDCw1vzjrHeB4cm4GJcGUpbmFioF/g9cs+CDrIKhowq2gjEtCB/avLlEDfkenbj+Qt0e9mQpjBG05XuupBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAHgzqJsB8zqAoS5we1uOaCG9WI4RTtOircvBVOb7P8=;
 b=Wv6vqF3+kV2FrMWBHIGWjxCuDe4HwT1Qe4pGM37ysmveN8DLI51TTW/VuLiErYx3omDaBtqPUE9+fdcKMyjwwrHlVt32VqgPqqCv3zm1DIpj1/b5/Glf05wmGjJYN5KGGYbRKwHCZZOXUdVLlAmH4PsnHsbEUAHf8CwBnwL/TIuG32CWU8tSnY6PxABfSVgxHh+grR5rMqBFjv22ua9uTLTTv/ckh08lFMu/J0b17rOH0K9mD6Za2sFxrrY5WI5ymk7LGH+w2O3Nk43P2s1kkc9yVpLDHVwwgIaY0G/6hHZdBB1kqUe9UnZCMMeo2c5Zr3RBY5MouB5SpfBI5znXKA==
Received: from CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9)
 by DS7PR12MB6141.namprd12.prod.outlook.com (2603:10b6:8:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 09:55:43 +0000
Received: from CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6]) by CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6%7]) with mapi id 15.20.9009.017; Tue, 19 Aug 2025
 09:55:43 +0000
Date: Tue, 19 Aug 2025 19:55:39 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Brost <matthew.brost@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, intel-xe@lists.freedesktop.org, 
	Andrew Morton <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <4lsv2lcd7lssyvcjvkqe4t2foubxbhuxrt2ptzee3csymz5gg3@jwrg3xow72lm>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
 <20250818160726.GH599331@ziepe.ca>
 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
 <20250818163617.GI599331@ziepe.ca>
 <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
 <20250818164655.GJ599331@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250818164655.GJ599331@ziepe.ca>
X-ClientProxiedBy: SY5PR01CA0055.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::15) To CY8PR12MB7705.namprd12.prod.outlook.com
 (2603:10b6:930:84::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7705:EE_|DS7PR12MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: caac88eb-e507-4a12-31cc-08dddf068fd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWlWRVBMRk4reGx2TjA4cjNDRmF1QVp4L2ZFbDlGdVlSNTh6T0pyOC9zQitS?=
 =?utf-8?B?Rm9LL0lqcDBPL3JpdXZxdlVMUlo5UkVRUjZaR1JkT08xN3lRcVlYVGN5MXht?=
 =?utf-8?B?ZGdjcHJMK2pWOTNrWFZ5Tlo0cHUyT0txb0Y1bFNpWVZjbFBuL29PQ1pNWjFn?=
 =?utf-8?B?T3FzemgvbUJOTU4xTkdyNjBibXRhdEc3b09oQjlyTkZtVWkzQjNESGpwZmZk?=
 =?utf-8?B?dFhxcjBwRWl5OWhGSks2Q3U2bVRQMk41cTVFQ0g2YWR2UUdxUSs4VXJydmVK?=
 =?utf-8?B?NklGbXVRSXEyNitNMXNXdmxBY1RKODNPRzJZYVZwSGdRYmkxQUNCVUEzL2tH?=
 =?utf-8?B?RkJONU0wV2VVWE5KWnQxT244UWJ4dEJ2MFkwZ1BqQzZrMjhJREpVUmQ0SHZR?=
 =?utf-8?B?L3E5Mm5ZV0NLMW9zK1ZEZzRGUEJrSkRGK1VhTTYyTmprYzdlUUo4RitTdjJl?=
 =?utf-8?B?OGN3ZkJkOG1WcFFVQjVDNG5acGNlU3gvbS9DMjdTSmNCdEdsS2dwWFBncGpq?=
 =?utf-8?B?aVhFRlV0L1VWR2d1bHFIcWxLSlNnNzdzYTVqNlI2R0JXZHhhRWpmNURRSDVy?=
 =?utf-8?B?TXJ2R21OWnZUNjUrUFZlRXR2d0s0RkRmcU9MZ0FlSUNFQ2pkcEJHa3FCblVn?=
 =?utf-8?B?b2o4U041Z1VES1k1eUk0RVM5UERmSGRieTNKZTBvRkhPd0p2ZVI4VlBxaUVW?=
 =?utf-8?B?QXRyL2VWSHpuWndxa01OaHlqc0RDTFJQNGxVd3ZUV2ZNY1EyMlYza2xSRHUx?=
 =?utf-8?B?S3NVdkJwOFJHdzVYcUM1bUh2aVRUTUVxeitNMWhiTWwxeC9MT0krYXdFeVFV?=
 =?utf-8?B?RGNOYWVxeTFKVFdIZXFldlhlYlRXS0NtK2hKdlZqWjZuWGVINllDUHJIbFZR?=
 =?utf-8?B?RFhBWFp1MWVDMXVlRXhtZ0xSTFhXODJUTm9MS09idkhIWmdYMkNkNzl2aTFJ?=
 =?utf-8?B?OERyTENjU0VrZ2FydGJSTzBXTmVEVnhYcFk2dFFXNUhqZDBLc2FHUDZldUpl?=
 =?utf-8?B?MGVNbi81V25mSlY2eHZ2Yk9DRitDRmE3NnJmSVVlMzNkWktwZXRFYWdlUnc2?=
 =?utf-8?B?djFKU2wxTThZelVGSjRYOE9TTXRpcXZPWDhXRjJXVUJqN250dVBOYjR5SXln?=
 =?utf-8?B?SjgzRllmV3E3TE1VUGVwNnM4QUUwcTNvNmVYZzdQaXlzbHhuREFKMXV1VWZG?=
 =?utf-8?B?TlgyRFlTdG5UYTdlTGMvZzZjRVZOVUtHWFU3d3lsK3V0SXEyOEJRekhNTFJU?=
 =?utf-8?B?RzBPTlRma2t0T1pLZlFSMSs4T3hxQndaR01LL2tEVURiQmtrdlNwLytORUtE?=
 =?utf-8?B?Yzl0QnRoazllL0I3Ny9adzhSMWZVRVJ5UG41VFRDZXpLTktJYzdMZzNjT1NV?=
 =?utf-8?B?T2VzbmdveWRvMHA2MktOeEgwQzVnOW1wTWZ6SDVKSmw1cXlPN0M4UTJXbXRo?=
 =?utf-8?B?aGpocGxlOFZBSnBaWmNrS29oTWJ4dGNVNGJjQ3Vrd0VMYkVGREFJOTgydnoy?=
 =?utf-8?B?VjRJdFJlYTV0YjAwVzlHdCt3U1JYMDZ5SXQ2WS92QmJWanpMNk1LeDNJcVp0?=
 =?utf-8?B?MjNIdE9lOVUvY0VWUnU2MFRRNm8zRW5FN2d3SWtuc0RaK1J4dVRrMktxbHhP?=
 =?utf-8?B?SXNqazMzMVZYZVhTNTgzdnNPNnZlTjBxR09LZUtiVzFkakxndmNBUlljNWZC?=
 =?utf-8?B?V2k4bHNycFFWb3Vxb1ZPS1U1SnhlSExXeS9oSkd1YlU5RVJaY0swc1k4c0Ru?=
 =?utf-8?B?dFBjMjJxc0ZhMUEwZmgvNndVdXZGUFJidGpuZjVXbjlRMU5ha1BrSUhtc3A4?=
 =?utf-8?B?OXpKVlVKbklxZlZ1bFYzNG9pd1NVT1lvZVNQL3ZLcENPdG1pTjlzVFAzc01U?=
 =?utf-8?B?a2cwTFpSVEVGR1FwYlBjcnhlMWtQaHNDblQ3blk5aUtTbDhSNmxhK21iWVBY?=
 =?utf-8?Q?JxdZM+HAojk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7705.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHpLK1pzVjlVRUpOQ2xyQ1VSUGpVcG80S3B6RXIwV28wTzBRRkoyQTErb09J?=
 =?utf-8?B?UVZoeDNSbTNvOW9SNkVFaVpwZ3o2c2ptOW9BaUdBOWh6YzFlQ0pqaVBrSCtF?=
 =?utf-8?B?MW00NEFudkpGMXpuTXEyV2x5ZlRFR05QZXVsMEwwdGlVekZXT1VRZXFmZ0xq?=
 =?utf-8?B?djAzS3Y5ZmtCUmVGME5sR0JtQzlCMEJMMFVMeXZ6bjc1R3duaGtIblkxYVRp?=
 =?utf-8?B?N2tNN3hWeE9HTzdxcC81c1E2UzMyT3Zlakw4RkVpc3Rkem5CaTFLTGs0VE4w?=
 =?utf-8?B?Z3Q5VndzdzlVUTdzVUk1QzhrL2g0TjZManRMQ0ordlBIRWt0amMzaGZhM1dY?=
 =?utf-8?B?NUcwSHRkNVNhWmp2bU9ZK1Q0TnFzNWczZkpOZzU4UWdiSjkvVzlLTUt5eTdH?=
 =?utf-8?B?aWg3ZGd5VjdzalRHL21WTE0rTkJjVGZJakxSSndjc1J5KzBVTDhiYXBqbUVz?=
 =?utf-8?B?ZjFhYlNBYWdhT2l6THpIOFM0MFY3a2RLcm55VnpMb1I3eW1CQmRDYTRVRVlY?=
 =?utf-8?B?dGlBckNPb3NXUk5tbnBIMFl0MW00T2xzaFNUZUxoV0xQUDJ3TWRUbXZXeVFR?=
 =?utf-8?B?RGdqU2xNOUlMT1dBMzdNV2h4eENMZFhPM3pFTGlZcGZxSUtEOFBQWElObkU3?=
 =?utf-8?B?ZUhkMkNQUlJiWDJtazZOSDQvdktXOUE1VSs4OHo1QmpYdHZITCs5U1ZuVEh6?=
 =?utf-8?B?ZFpmU2V6dlFZbG1ac2tzQlBjR216ZEpGMTI1eWR0MGlEUnpRSDZCZVFhcHp2?=
 =?utf-8?B?dCtpY2g3a1pYNFJDRXdrUkhPR1JtNGxkbFdsYjd1QWQzL0lNV1ZqSVhNdkF2?=
 =?utf-8?B?NXVzWHZqdlJ0OXlpTHV0ZDl0WVNHRHhGWmVGaVcrQUd3UGFicmJxaVBJbEZR?=
 =?utf-8?B?STk2TTFtR1p1VE9KVmxkWVlnTFUybzAzeGR6OWE2bVZkWjBOczVwN0N1VnFw?=
 =?utf-8?B?Z3UyNzRmd2loYzlDNUxxR0dNMVlKNFRyWmp3eTV2U0lITXRZeGtuQ0dvZzJI?=
 =?utf-8?B?UkhxYXNqSEtOY1NRSk0wTHBoeVJTNzdWYjVicnZZMjJwUHdYbjBjdHUvMFIx?=
 =?utf-8?B?Ylh2QWRPVUVOSjZLaFZWRGpESld2WUNwN05NcldybnNLeTJ0V2tyZ3ZxakdI?=
 =?utf-8?B?NUhsampPaXhaekZIdkplN1Z6MTZjYVlGZnhUMjZ0VWlxd0VEZHJ5TzVPM052?=
 =?utf-8?B?MlhFcWlBMkxoNXNKMExmT1dscHlQdVYybVE1YlRNTmVwSWozZ0FsMThBVzZQ?=
 =?utf-8?B?N0g3cGVPY0RGWDJDbmd2UGxDakhPeHdBQ3NkTG9mT3pGcHNJNWZTMmlrd3do?=
 =?utf-8?B?UHhsM2xLaFdwTThjemlWQ3NCL3hHMjlOYW5zazRFK0RHbzJtSzYxcVdqNnZR?=
 =?utf-8?B?M1k0cktVUkxRTDVxOG5jZ1NGOUYydjM0ZXJXSm1MY0I2dUdkRUMvNlNUcEVv?=
 =?utf-8?B?R0crUDZRSVU3Ulh5TXUxV1JMTDltQ1BDamJoeEV4Wm5XNE0yWmJXNnpSdG10?=
 =?utf-8?B?WW9YOFBWazZxeWd3eHArZHgzNW9NUmk5UmVMYWgzZVZIMW9ycllXbEJ6YXJp?=
 =?utf-8?B?YmVCWGlpZHBZQTlrQWowZ1VCLy9KWXpDenFGNkJrSlJVRVZTN3BIYzcvb1hC?=
 =?utf-8?B?YzJ5QTI4MmVlSVZKZHRLbFE2U2Y3WWJSR2ZFbmhtVDFISTB4VElGYnZNN2J6?=
 =?utf-8?B?dFNjTVAyYTloZ2JqZ1gvUHFtMHI1TnZxQjFLbWtvenZPVlJTVm5VbW5VeTVW?=
 =?utf-8?B?QjZ1V2tjcUNHcUpaMjFZdmp6a0lvMFFwY01Lc1ZxYjBHdHpjUEZiWGZqd3E5?=
 =?utf-8?B?MGNsSjBQY2lnNWk5N2RObWVuTHpqY1Y1eSticXlIYmYyU0MvbXE3cVdzWlRr?=
 =?utf-8?B?TUJ0dEdDYitsL2xlZ0dHcXhhTlVkc3ltOVBoSERzUGg2a3FnMzRWdCtsckRD?=
 =?utf-8?B?ODBUdWs2UldCNHBudFhMd3RRV1dhd2JuWEUrSW95WUVobm9uUzU5TDIxdDlo?=
 =?utf-8?B?UnlzMGIyNlQrZXZWR0xjNUlrak45azlSNFJvSDlQamsvUWpBRFZNcmppN0FV?=
 =?utf-8?B?cmlKNkZlcFAvb1VoUmcvMk54b05QblA2d2o3b2JLLytyTk5iMVFCZzNWVUs1?=
 =?utf-8?Q?wUCaB7IVfjt1qLXS00RCNJdyQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caac88eb-e507-4a12-31cc-08dddf068fd8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7705.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 09:55:43.4263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOPhQFlWMa1dxMETtwtgtkZuwp/d2OR87ls/o8Decw0E05DvJV/9rDETrYAKB+clPu8i+iiNgsBssagwVL8kLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6141
X-Stat-Signature: zjnnygyub5io55uxk8tchk3tgqtmaggq
X-Rspam-User: 
X-Rspamd-Queue-Id: 62B18160007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755597346-684928
X-HE-Meta: U2FsdGVkX19tuaF+HFVtmx/s4ZkgNMOThmo8s+vptQoB0xL5pG32Xb3tZ+b1l2V3oq5ttR/qDeZFIM3/pRs5NClr23Kf6PigUSvqqyIqjS+aRUMxyceJHs6Ojg6TsvUV4TLVoFGWBjn1c4wcVOMYxmTFSxKh/fQvageG6OGVeTDh8DQ+pw6m/y4MLasMrZEclHLLS6CpO9otkiTdBf57tNGdrcduEwgmPQNVSUmu31hbBNMAsQYl2HZLllvqXEKHp8IsSKzpBb53O+MmrsfGS8+5AXBkR1VFTELOdaXIYTw34/wxEh1btRrCp6U7EIZZU1ReRDYo9p4vbF8XulYQJ2ZSSJ82b1QpBwIsfsa6DQLlojmULGFm+hwU6BqBupPEN5DCLsqpIieIRWUh8pTGUZEZdqfiukUwYo8LqaOZD8zoLXFVxA4iqcgScwqJJpWNekl/0v6IwJ6UtdWjtD6+A1ufrAaUHwP3XtcGmeQ1htkUYiVcvCev2tnyB4r0h+TsO5oo0wHXQYURMugYCGGigXHzOl2NiyWnPhEsQfsaL4viitZBTlk4wANcnjMEv+I6VypXPf89aALge91qHdWT9gpa817/C8GUOhDDox5iaI6ZMJGdzhitF1Xvfmlt4RnukbEG3Va73wBNPoMlgK8xNU+H2kT2OvNnu9UFMNcVTfCB0EHt5Nc1siEwW+mLnj5moMgVnnO6SKVe+VjqzIteP+10yVb0PwxFIgo84QVBwpP414qq8vqy5xOX6HvpNkGIJwUL91hLjYlmd+B58XW7Em8KH7JP/1F1VcPykhL+SRWafBQw6EISLg/8DjlzfkixwlcMy8C5Do0gro5vJ0r3lEqdbyK4kBTREmpSqtwlgpyK4ALREtCOyMw0lr9Hw0YDS5JGw0eOn3MMtluF/bdfjcXCHclP7tP0Cg8CqlnQLVPF3qP5Ql7uqO4JL7abcKavbliII4Gf3pIQCbUa1J1
 tx2KeBjN
 KFtjXdl+APq+YA5BFpCUWyoeFV9J2w0jsyKa8MEfZbBs1PylFMe9BCFQi9dMiJ/6cdauKLhnk8OE6zqx4RLEondgAr2PkZlnunyl3HtXbqC/bL0fbVluRHo+qCMKqaRPMxVqoaYGSe3PT0tDYgfmI7ULocd2nmFEnlB8CwCZV1bnsgSmfmrDI4KX/PzfOmbYmR28nlUQBAfx1qj7MAXHuZNRxcnmAeUoJltZmni4QGlShuH1C3R1GYUbUDmMnYXro7XRUB+sBndBrSDU7bGBqbbVFYSNuGWLleA6t1F10a+gkim4P26/ik/xmXocx6n15S03jkgH238ERZ7nrl4g5lCHs4u3SE73b3HtuqPByCIX/lksHr1eLXwhswHo8mmxTW88ywlCBXYAt8BJGdeXfH2g3w3JOPV/07MPHT7nlqWtGFuTwJhCqQ1FG9XmCzcwA707H3tLVHiXfcnuxfxiWfcBbbORVBJ+wse1n5LVCj+uRoTgJa04hvLDV4Yshk5IipRmjZ3av6Oji6vnl9tv35yC27Lkh02qFA7GSqXNzg/f5XCS6THBO1JeAUMUUARuRa2AC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 01:46:55PM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 18, 2025 at 09:44:01AM -0700, Matthew Brost wrote:
> > On Mon, Aug 18, 2025 at 01:36:17PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > > > I think this choice makes sense: it allows embedding the wait state from
> > > > the initial notifier call into the pass structure. Patch [6] shows this
> > > > by attaching the issued TLB invalidation fences to the pass. Since a
> > > > single notifier may be invoked multiple times with different ranges but
> > > > the same seqno,
> > > 
> > > That should be explained, but also seems to be a bit of a different
> > > issue..
> > > 
> > > If the design is really to only have two passes and this linked list
> > > is about retaining state then there should not be so much freedom to
> > > have more passes.
> > 
> > I’ll let Thomas weigh in on whether we really need more than two passes;
> > my feeling is that two passes are likely sufficient. It’s also worth
> > noting that the linked list has an added benefit: the notifier tree only
> > needs to be walked once (a small time-complexity win).
> 
> You may end up keeping the linked list just with no way to add a third
> pass.

It seems to me though that linked list still adds unnecessary complexity. I
think this would all be much easier to follow if we just added two new callbacks
- invalidate_start() and invalidate_end() say.

Admitedly that would still require the linked list (or something similar) to
retain the ability to hold/pass a context between the start and end callbacks.
Which is bit annoying, it's a pity we need to allocate memory in a performance
sensitive path to effectively pass (at least in this case) a single pointer. I
can't think of any obvious solutions to that though.

> Jason
> 


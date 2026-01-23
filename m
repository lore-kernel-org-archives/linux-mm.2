Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E350D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0EE6B03E8; Fri, 23 Jan 2026 01:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABC76B03EA; Fri, 23 Jan 2026 01:25:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DF86B03EB; Fri, 23 Jan 2026 01:25:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 974E26B03E8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:25:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 567BC16033E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:25:26 +0000 (UTC)
X-FDA: 84362241852.17.5B692F0
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D13AA000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:25:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mqNFJNWU;
	spf=pass (imf15.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5J1rpiHRpfCQc/BFCNb8Fngc4dZK5qasWF65UrhwFc=;
	b=TG6/JgdhkFw7d3vjmUX3RnXv4BM58U0/ctlumWCpLuOd5lHqarHmg6+yNU0voKVInfO081
	8M8pGuBA2dJebLBJHpNGUu1WTafyh1zYCiO4lZcchXI2nyrIajacERvYVm5YmxJ0p9rdMl
	M9XbX0zNeCJD/tr6ExzOtSE8G4mJWrw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mqNFJNWU;
	spf=pass (imf15.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.58 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149523; a=rsa-sha256;
	cv=pass;
	b=GA3nuOyJRf2RWSxilfrpp73UbjHKyMWyXwkKLJ4YGek2VvDVfNWJcecxg+RNz12gYWKjTU
	acbMyynnCtwhXxSdkPHbp9KFrKcch7MvuS0jCFv/CyOBuW7fv224af2eMnBqoNou0vYzNc
	5i1W4rev/Q6iX+IDRWNRfiNfgA7MoKQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSRNZtWRSaXEg7AjA8zAEHsaxGhHZkjaRCTH4bsrTXm6auHuMwrQKDyw1opdgyav1CUs4xDRisy+2rjYUknZ4fHGRzhHGut6OHk0Qpz7cTHsYD5xqXM0MxH0BxkwfAI/JpWJJ73WcdJhFRsswabw3c3OQA1+tKm5M9t1spoEFu1NtBh853PvaOLrTN8hwZFRoMbQTk+zH5/xbRF65ABwYFGrbRWHcPHcH4ZilvAU5P+cjkKmWyqLRRiu9wLaXOO1okgxwtEgps5cvkwL6+dYs5nebuWNBl5FJgRH+5YGhbRwVcRpBDcQ7IGb4FwmxMsip0dxwqcWJeJmv2YLG8jZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5J1rpiHRpfCQc/BFCNb8Fngc4dZK5qasWF65UrhwFc=;
 b=JBdzCiULswg80YeT7bGLsnph+5TX5v/kiIHdsYKIxXlwRouhwgD0UUdIdfemdjYWGTXO81VS/vbD4err5Pxkzg8qubzj0o60OgTs+IxRqRmgwwZdB81CBEUAKaZEAAIa1p7AccPrHUgUeuAOBKfBIEZ4i2HR3Xn4ca22EQTCcKeiwiKXuGHdOfVJp95t3xDwJmB7cxHW/Ukd3CD6yOiQn7MnS/pkaVbvdsGs2K9Ga4Evcxb4BIH3C62aRBQUpJ6z5l4mOYrvwaisRWGau/9CrwbB607W9x7k2BsU4Oa2YOafDbKkakg/GoZuXLFeGn3GslB3s5c9nomZAOquKqlejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5J1rpiHRpfCQc/BFCNb8Fngc4dZK5qasWF65UrhwFc=;
 b=mqNFJNWUSsJQlRwuJo0UbYnpmSpYSOJvmle3hWKJnXLZ1w06wWvH9l48FAxyTFDPOSbPuXEFDmkihaqTEzn48m9rZAKJPV1cq4GW3+LeZSnnC1449S43Qc0YZar9nBSC58oEv8hYjRl4xB6eQUwsmjvqxu0lNoa7YJdOG+dIihrCixHzD2P7OWABIHn1/gdTJYvMIUWjjwaFTgpHvqodOpMbtzGVDHj2u3n1gteVc9rR1xx76h3ufTofxTBz012B9bsE3hVvDjR4hggw2wGPAnlbGqsd+ClYUv5MA8+PybvUyC9fOOmW6FYEEH4oHTSxi1aPWXzOA3Qey9jwPx3KgA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 06:25:19 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:25:19 +0000
Message-ID: <b2b81b99-29ee-4122-99ef-4a6094f4ec5c@nvidia.com>
Date: Fri, 23 Jan 2026 17:25:08 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
From: Jordan Niethe <jniethe@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <aV6nvCw2ugAbSpFL@lstrano-desk.jf.intel.com>
 <3586d8f1-a25f-4087-a987-162ccd97c25f@nvidia.com>
 <6a911224-05e5-45ee-8008-e36ef35cbc7b@nvidia.com>
 <eb45fb36-4f0b-4a83-8852-abac3205a988@nvidia.com>
 <aWBMbGQApg81Kxba@lstrano-desk.jf.intel.com>
 <ad2a0fe8-6d00-46a8-8f4c-fd7fb6aac8b1@nvidia.com>
 <aWCerW4QP0t7CrC8@lstrano-desk.jf.intel.com>
 <f295d9ba-bbef-4a11-95b5-c468f08f992c@nvidia.com>
Content-Language: en-US
In-Reply-To: <f295d9ba-bbef-4a11-95b5-c468f08f992c@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a110c9b-0436-49a8-59d6-08de5a482e45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDljOERLc3ptS1p2RjdLWGhDVDZ6QVp0eGxWNzRESC9ZSlBjZDRnbzY4eDdj?=
 =?utf-8?B?RE9uV2VSMUEzaFpSMGpmQWg5dFl6YzZmeUdIQVRSYUZFaW5CZURyU3hzWUtM?=
 =?utf-8?B?Vmd3ZzE5UDFYQU5FRmU3RE5PditmT01NVGRXWVpyYlo2ZHVJamNmcnU1S2k2?=
 =?utf-8?B?WGQrVUlwQ1Z1bFJCTGZVZmU2UDBYb1JkcDZPeW5uSTJPNG5ORDYwNW5YOWNZ?=
 =?utf-8?B?WWpMYVlwSGphKzBlNUZBZXhYNU9ESVRoK01aSnV4VUI3bWFhTGZlOEQ1V05T?=
 =?utf-8?B?MGhOY1RYeXBNbG9kRDhpVW83UGw4c3pYcEQvZ3dmcWd5YnJMaXpDa01SM08z?=
 =?utf-8?B?VExZczQyZ0U2cjJoWFllT1BieGVDblVLYXhoV1c3a3VTQStEdnpqTnlBRTJG?=
 =?utf-8?B?S3RQdEQ5bTBpSGZxM2RvdFcyRlgrK3N4VzRlR0gzUkcrLzNNcy9HWVhtQWNM?=
 =?utf-8?B?ZG9oZVllRDRJUEdMYkgyamhaM205cWk5dVlkWEg5cnEzK094ck1DTm9hQldj?=
 =?utf-8?B?VnAvYW5zLy80Q2EybUp5NUkydTZMdDBqRDdsQ2h1MGZWZUNHaHpvaHNJTnFC?=
 =?utf-8?B?bXZ1UTVRWVRlaXNPYVptdU1aMXZlOWZvdlJ2UUJJZjB0MUU5OGJ5WlptVENi?=
 =?utf-8?B?YldUb1ZEdHNBWEF0YUVETE9reDFvbWkrVytqOXpMOWp5WlJxZVVNdmtkb09P?=
 =?utf-8?B?d0FsWklKcnQ3NFRLclZPUXBSaXNOZDByQXdUTS9DL010MFhUVnFWaWI0K1BW?=
 =?utf-8?B?UnZQUnl2QmYrSzUyMSs5QUord0FLY0pmWndHMC9wV3dnT0dCK056MjNBV3F5?=
 =?utf-8?B?V1QwZEJIcnMwU3Q3aG9VU0F0NmdseFJCeTFtMHFwS2hkei9HU0FTSUw3SWxS?=
 =?utf-8?B?VytubmF1cHYrdktQZlNSVStHL1dLRDNOdmJ4UHpmUitONUI4dUJDQlNnVDRZ?=
 =?utf-8?B?SEtOdVlzM2pXbmpvVG5zY1RLTnorZTE3cHlCVW9sbWFUNEgvT1RWdUpyZ05p?=
 =?utf-8?B?S3lMWW1TMEUvTjQ3bzZzd000VkV2ZlJOYlA1TU9IV1dRMDh5UEEvYVFwZzY5?=
 =?utf-8?B?TGRYZnRmTnNLenNRRksrVnZUMXppQ2FkaUNWd0REclk1dzFDZVo2b3Ftblhz?=
 =?utf-8?B?NC9qOFFTZjE5OEdyNzREVWJlVEVydXdlR2pIbFU1VzJUbXpxZ3ZlY29na2h5?=
 =?utf-8?B?RmsvQ0ZlMmdLWnFQK1JvTVlWZm5tTHZjVWo5MFFxK1ludkw5WkcwUlV2NkZZ?=
 =?utf-8?B?RVV1TzhudjVISUpQeXdpaGh3anNrYktCWU5yTVphOVBiQlMvS3JFd3VGdmJ2?=
 =?utf-8?B?WGRWb0JGOVZSS096RkVFdXNySFY3NzZTTmRwUFp2WFZtVTlMSVRoQVI1MThn?=
 =?utf-8?B?d0JKYzduQjFBZWdwQ05PbW5RRE0wMkhZU1pWdzFoblFhMWhnWENsWmhoM2o4?=
 =?utf-8?B?dVJTVkI4am44WEowSWF4aVdqZktmWGFzN3B6b2NDc3NhTzhQS241Y3NSV0Vs?=
 =?utf-8?B?MmZkMC94MHdRK1JsWE85VURhdGVnSG8vOHdISFFpNG5VWkpmYkduUWN4MjdH?=
 =?utf-8?B?dGdvaGJTbmNvMmt5MUF6VVNzR202TFRXQS93ZVJ5SGY2dWpGMFdUVzJoVE5y?=
 =?utf-8?B?ZE03OEtGWThHbjg0VDdja1M5OEhWWWFCSjUwb2NEMHpBZTRBSUNpb2RpdGNt?=
 =?utf-8?B?dzFHZHptc0krSVgyc0NpNmhmVmxoUDBhUHZiaGRabVBDSmFRNVFYTWliY0hh?=
 =?utf-8?B?UmZUUUd3NWE3bFJ0RU5qK1BtWXVybHVhMmwxM3FBaVZtMDFIR0xQY1VhQzM0?=
 =?utf-8?B?cjZrVjhUZm1yYnBZZjJtS1NwTVpxb3JReHRKbS9jSDV1Z2dvVlp6YzJWZjdY?=
 =?utf-8?B?TFR5cytkQzNFSEorQWpRZ1BYd2JlLzlyZmNDVVprTjNiakxyZjdHajczelRU?=
 =?utf-8?B?RlBOdzJzem05Nll4d1l3TzNKUjdoWXRIOFFUZFFOdXZBQnYxSFdzejdoRHZ4?=
 =?utf-8?B?dnQzUDRXNEpWTHBEZm50WlphZEtTbnAzcEZ5bUprQW8yUGtlbS92c3QzcGVY?=
 =?utf-8?B?QjhlNzNXM0lMR2JwbnpmVlltRjJVQ3dGOVJ6V09UZDUvR3R6d1hpVnd3eUxu?=
 =?utf-8?Q?Wlm0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXN1YlpFQUtJNG9nQjZnOTI5c0pqNkhnNGE0VG05a0pOWjROeUtoaE42ZEx6?=
 =?utf-8?B?Yk1pYzhwWXhHYm9yQnBGQUFmY2NISVFCcFlwSVFDMU1PUkI4WG1KYW1lVlg5?=
 =?utf-8?B?UjJFTjJSckQ5ZWRSWnZQbld2M3h0YU83RTZaREU0bW5KWGZtcXROK09KWW5E?=
 =?utf-8?B?ZlFHRnE2dFNXUWlFVGRkYk1hZm50V2N6NG10TzdGdTRuMXE3dWNVZmtGaXM0?=
 =?utf-8?B?NXBObS8xeVJYVEl1bFNod2QwYnlpOVhaeVlkR0E4OXQzc2liT2ZpN1U4NWtn?=
 =?utf-8?B?ZGR4TEVoeWJLN2RqUGpzZDFFUWNBR2FqaytLTHkvZDhuUWErTGVBaTZnN1Zk?=
 =?utf-8?B?eVpxY2gwSndjekI3RWFuN2hSb1Y5bFdmc0taVmRNNmMxM1NEcjVJOE9sWXJ3?=
 =?utf-8?B?am1lUTFzNTNuL3BqWGljOUx0d0V5UXF2OUtHMTNFMC9KZllVdDl6VWRFYzR5?=
 =?utf-8?B?a1NvN1MrUHNkVFR1R256M3J0UWZCU2x3VGw3VkthK3d6OGw2N0xQRzZ5QkpZ?=
 =?utf-8?B?Rm9uUXB4TkJzcVo1bmZ5WWorNEtOTU1MZnNwd3BHYVpiZS8ycFUyN2h3dmQx?=
 =?utf-8?B?SFdFZHBJMXd2bTQzeFBOWVYrSFNqckxEbkpUY05oWUlzZitRK2NmRFZ4YWRh?=
 =?utf-8?B?UGVuSTI2WVZwdmFZTDJNMVVKZG1ON2hub0lndUhDS2piY3hVaWRnenNKVlY3?=
 =?utf-8?B?dWNMSmRjRkZONmVCZ2doY2d2Wkx6TVROaloxNFJVK1lqblAwak5iRnRqNkE5?=
 =?utf-8?B?RjdLc1oxeENrZDVmL1lmV3o4UFpRclQrS0J4NUs3azZFVnVZOGhod0NIdnVx?=
 =?utf-8?B?UkNmRXN2OUdGNWpWZkdHYXFVVmxLaTlocmFCSFFHdzZWTWU1bjE3TkRMRlVy?=
 =?utf-8?B?Vm1xTm1WODNhNjhWKzQxcmZZK3ZQcjQraWVYVDM2TlRNaEZxeVZaazFxdUxK?=
 =?utf-8?B?a3p5bE82d1FsRTI0ditjWnc3SjA1K0phVlV1MURqbjNDZnpad3JUODdubU5B?=
 =?utf-8?B?QXpNc1dzR0haN2ZCcVF6OXZ4WEMwSDloU3RwRjdFT0J4dEtnVy83SEw1a3Fh?=
 =?utf-8?B?djlXNEswZGtFRENhb0gvemxadmw0Mi9KU2xCZlY3YXlKQWhPWXIzTUFCZWdz?=
 =?utf-8?B?SEZPOUJzeHIxazk4aEFCV1lhQWx6MEV6Vlhkc05vYU5mQnhMQlJDUXZVR2kw?=
 =?utf-8?B?WEF2ZWZQNW43UmlJZVVpQ1o5L3JzL2IydnJMZjhaZXZPZEJYcUsweHFVWlJh?=
 =?utf-8?B?K0NqS1RNNmdiK3g4TW9PR2xRbHVMVDlLZlRpVGVUNmRsamRMOUNDYnJzNTZS?=
 =?utf-8?B?bGdlRHdWWEcxRnVGOHNQdUNLdEx3dnRrRDFtRmxhaHFrNEk0Nlg4T3EwYnRM?=
 =?utf-8?B?U0p4K1Y0VlMyUU41NTl0R1pyMmp3RGs3cUFJRkE0aEk0S2dOVE9mMXRackRX?=
 =?utf-8?B?cUwycm1kNWRPQzhVcW1yMUsvRjBHcEFKVk9HSGNMZGZCcXV1UXBnQkpuTGpC?=
 =?utf-8?B?SS9NcDNSOGx2Z0lpTVJ5d0daR0JCcVpndzZ0dUNPMTlYaHQwMDlWaGZTeDlQ?=
 =?utf-8?B?QUlLSHdDanp1MWpnbTczMmliVUhDL2ZyQVZVMWo2Q1pWdHpoT0cxbzNQWEds?=
 =?utf-8?B?bytKdmg5TnNLQ2hhM0x3NnFoUnp6clpLMlNhekF3dWhqa3M0V3l1OVZmeTVN?=
 =?utf-8?B?S1JZSFBBNy9FMTBWdXFqekxSL3g0bjJZd0RkWkQ1b3dZcWJPV09aNlZ3Wm4y?=
 =?utf-8?B?Vld2a2gyZGo3ay9Ja1hkMXlURjlxdldxOHpoaDZNWit4VWJ0djRqemdhc2RZ?=
 =?utf-8?B?Ly9NSU0zNFBWRldIanNSTWNTODc3Zi9aVXJuaUNIcFVHVmlub1ZxbjFzY3lu?=
 =?utf-8?B?Sk1LN2tzNmhPUGF0K0FieHJlU2hZN0FGTUlTakJweXFmYkNIbEFYd0cwb0JN?=
 =?utf-8?B?cXlRV2xPSlpRSXcwQTFxSTE3UDhVenBqNDBraXAvQWNoWUo2SWJFOWcvSWd3?=
 =?utf-8?B?dENqeUx0NXAxNHFkK2ZUcEdlQ1VrVVp0dE80d0kzSTd2OG5VTk1Qck03TFp6?=
 =?utf-8?B?cXNSTmY0bnpERDBrZzRZQ2RBQW4rUVVvTy9SWXdjSWdUUUhsREpMb0xPNGhV?=
 =?utf-8?B?TXpjYWZZZlFtUTBEbTU3bWlUSEpudUlPUEkxOWJRcUFnVGZhR1Bwd1NUelhC?=
 =?utf-8?B?THFEUHlHZEErYllQeTl2cGVCZXZYOTFRVmljZ1hJaWc4dXFvSkpMYndPclli?=
 =?utf-8?B?U3VlWDdSWm8xTDhXMXRmVkkvcStPYjNySDNlbVRCK2E1L24ydStRaTB2RDFi?=
 =?utf-8?B?emxJT1ZtT0hYVlVyTHZpa0hoVThWU2FjL0RVT2lHaUx3T1FTdUU3Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a110c9b-0436-49a8-59d6-08de5a482e45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:25:19.5857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HV48n2fcwMpSoztZv48oFpyWzyT5QaW6ZxWUZ0IOD428dfbA7RhrtDSp4DFBbAW4f5WNmoGQdPUEkSmAa2Rwmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B
X-Stat-Signature: ibowkkuf9h6sha8emw89qdc5wshqd3qi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D13AA000A
X-HE-Tag: 1769149523-586542
X-HE-Meta: U2FsdGVkX1/hgX0dVlVEhddGfAGyJWOXy9j6kn3jRWTMgwSYTGdoBtJvTOR0zGiHY0h/Dq3LQFeUKVeDBqtBiYpvgd/41OJoqckEOsUFJPb4sNTGLe/bUX9w14+cOGpqFcb9AKN5JXaVGcXeRlP7CEbG/GnYC2Y7gRTeAxjiKtGw5k7wJXl/ASqM4DLT4vP6A/3pU0lPhq7VheP3ppS+JihlWKUFGfHUFIyqgjbaMQ+h0vE30wOJ6OLjdwPe6BEKGvwlXCrsLpSVg0LeipYZffu2YVZ2B8Q6+HfyMCEw/9LIcToKfyHcgxVXz5Y3QL8574V7R/Bxxac6PpF29w5dlqCNo5v8zQc92BZc0YhBihL5f83rfAHz0hR12jCrsBXqVnlAYb3VoCdrA89+16pSB/wsv1Fn2Lg/EPrRflinfV9hL17k6Vle0V+0zWFVI8YBjJIWd10tvUzaOs5GTIBrs/SpuMLEbNBXIatTXpPqMuVSwCzeCBbCHqlLqGTn5J/4DhfplRqmDumdx2Pc1Q7EPQmMahyeCL7yWn+plqbFO5ZJ0KEUwmjjb5TjJv54k5Hoq7RNXbquEqPGSJb7kHKOfxfTEu8OY5GGaD0iZtWrXgbJqb4grE+mNNbc8CuKxEWF0uvy/vXit2BkFfS1FJ7LMKbfjW//9nngOqvcyFS33sTQs8Q70Cbcx6zXJdKj67HhOlwHcCbcjrJgV5aHA7i4izPZWMRD6tmeld5ou0d9wvsDqJ+QUlrocSEZxWc2yKou+J3ZCt4wuFNNqM7NpsHTl8UEGvNzgtlFfVz54+1LSbKl+h/by34u+N2xC777+QBF3Ni0Iuk9EOT3PkxCsNLHU6JkyPd0A/zQ+IQ4MlwdTE2P4ndMEzCo8ZDC0c+9eDSTu+g3Ha2+U07opKNwGojZs0T2uYn02oDnewRQG1MgcpbWC/EsyOFBYVbuvuITtfDS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 14/1/26 16:41, Jordan Niethe wrote:
> Hi,
> 
> On 9/1/26 17:22, Matthew Brost wrote:
>> On Fri, Jan 09, 2026 at 12:27:50PM +1100, Jordan Niethe wrote:
>>> Hi
>>> On 9/1/26 11:31, Matthew Brost wrote:
>>>> On Fri, Jan 09, 2026 at 11:01:13AM +1100, Jordan Niethe wrote:
>>>>> Hi,
>>>>>
>>>>> On 8/1/26 16:42, Jordan Niethe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 8/1/26 13:25, Jordan Niethe wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 8/1/26 05:36, Matthew Brost wrote:
>>>>>>>>
>>>>>>>> Thanks for the series. For some reason Intel's CI couldn't apply this
>>>>>>>> series to drm-tip to get results [1]. I'll manually apply this
>>>>>>>> and run all
>>>>>>>> our SVM tests and get back you on results + review the changes here. For
>>>>>>>> future reference if you want to use our CI system, the series must apply
>>>>>>>> to drm-tip, feel free to rebase this series and just send to intel-xe
>>>>>>>> list if you want CI
>>>>>>>
>>>>>>> Thanks, I'll rebase on drm-tip and send to the intel-xe list.
>>>>>>
>>>>>> For reference the rebase on drm-tip on the intel-xe list:
>>>>>>
>>>>>> https://patchwork.freedesktop.org/series/159738/
>>>>>>
>>>>>> Will watch the CI results.
>>>>>
>>>>> The series causes some failures in the intel-xe tests:
>>>>> https://patchwork.freedesktop.org/series/159738/#rev4
>>>>>
>>>>> Working through the failures now.
>>>>>
>>>>
>>>> Yea, I saw the failures. I haven't had time look at the patches on my
>>>> end quite yet. Scrabling to get a few things in 6.20/7.0 PR, so I may
>>>> not have bandwidth to look in depth until mid next week but digging is
>>>> on my TODO list.
>>>
>>> Sure, that's completely fine. The failures seem pretty directly related to
>>> the
>>> series so I think I'll be able to make good progress.
>>>
>>> For example https://intel-gfx-ci.01.org/tree/intel-xe/xe-pw-159738v4/bat-bmg-2/igt@xe_evict@evict-beng-small.html
>>>
>>> It looks like I missed that xe_pagemap_destroy_work() needs to be updated to
>>> remove the call to devm_release_mem_region() now we are no longer reserving
>>> a mem
>>> region.
>>
>> +1
>>
>> So this is the one I’d be most concerned about [1].
>> xe_exec_system_allocator is our SVM test, which does almost all the
>> ridiculous things possible in user space to stress SVM. It’s blowing up
>> in the core MM—but the source of the bug could be anywhere (e.g., Xe
>> SVM, GPU SVM, migrate device layer, or core MM). I’ll try to help when I
>> have bandwidth.
>>
>> Matt
>>
>> [1] https://intel-gfx-ci.01.org/tree/intel-xe/xe-pw-159738v4/shard-bmg-9/igt@xe_exec_system_allocator@threads-many-large-execqueues-free-nomemset.html
> 
> A similar fault in lruvec_stat_mod_folio can be repro'd if
> memremap_device_private_pagemap() is called with NUMA_NO_NODE instead of (say)
> numa_node_id() for the nid parameter.
> 
> The xe_svm driver uses devm_memremap_device_private_pagemap() which uses
> dev_to_node() for the nid parameter. Suspect this is causing something similar
> to happen.
> 
> When memremap_pages() calls pagemap_range() we have the following logic:
> 
>          if (nid < 0)
>                  nid = numa_mem_id();
> 
> I think we might need to add this to memremap_device_private_pagemap() to handle
> the NUMA_NO_NODE case. Still confirming.

This was the problem, fixed in v3.

> 
> Thanks,
> Jordan.
> 
>>
>>>
>>>
>>> Thanks,
>>> Jordan.
>>>
>>>>
>>>> Matt
>>>>
>>>>> Thanks,
>>>>> Jordan.
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Jordan.
>>>>>>
>>>>>>>
>>>>>>> Jordan.
>>>>>>>
>>>>>>>>
>>>>>>>> I was also wondering if Nvidia could help review one our core MM patches
>>>>>>>> [2] which is gating enabling 2M device pages too?
>>>>>>>>
>>>>>>>> Matt
>>>>>>>>
>>>>>>>> [1] https://patchwork.freedesktop.org/series/159738/
>>>>>>>> [2] https://patchwork.freedesktop.org/patch/694775/?series=159119&rev=1
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>
> 



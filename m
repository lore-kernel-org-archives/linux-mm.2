Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D9BD148B0
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 22:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601546B0088; Thu,  8 Jan 2026 17:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF046B0089; Thu,  8 Jan 2026 17:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4878E6B0092; Thu,  8 Jan 2026 17:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 369E06B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:00:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03F421A02EB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:00:47 +0000 (UTC)
X-FDA: 84310166976.30.3AF67D2
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010001.outbound.protection.outlook.com [52.101.193.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0621F4001A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:00:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="nq8/A2of";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of Felix.Kuehling@amd.com designates 52.101.193.1 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767909645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8jM/hfD6aFbo3SFoDlkdrKzYEBhiqDK71DJoNc+j6Q=;
	b=zvwk7GbIy0bSdN8YxJuSRoDef6LLl1elKljPht4zALcb+FJ1EO0WnVyC9JVt91hyvqnqVm
	jURp9ypkIJafqKrrI/fJIx5r2HjvMPWz2dy7u1cJRjiMcACbTZQEGdUfIp7CutfrGdVAg8
	yc+rh1UxYlZZrjBIXVxwCo6RNmE9HEo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="nq8/A2of";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of Felix.Kuehling@amd.com designates 52.101.193.1 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767909645; a=rsa-sha256;
	cv=pass;
	b=Wza6ixQhOmjAxfZF13pea0jN0qKIiew3R6lTH4YqQLHxaZcl1isiFznk1rvoQfypmkQS+a
	/ZlkfHaUHm7L6Ls7bjEouXx09GMsrrcBa00bDOAq2CrZ5HZqaLg3nKToElBUz0MrcCOArh
	ZesWrdleWQ9HzmuZII2+EXaJjvSH2pw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bErfc4E4cII1xG39StNfR4+x1QaVPHAZExsYk1XpLCQDs8itNCfJtzdxqAR2Ee0VFUNqQeLJKfHWwJ5ZXpYowAClm3cxCwVqOiCrGZKIbF2wtHCWiAZSODrWAgSKnEETX4wYCGCGR+/PtaYrdPb5BTfygyBPQ9v4M+A4wR5Gry7/wSaJS1TWyM2IF6XQz2JFBO/gpbNB3VMzhtdvCBP09+d9ZqT8QqcYQ+oJJ+wxL8zig7767DkVZxW65FIWv+7327+RQWqfQmI2FzrLg0EO7SXWTLf2b+GF3U5XZbDEWkEGHeMpcrJCHgMTNpugDoE4IUYpRrGB/tFj8zhS10GnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8jM/hfD6aFbo3SFoDlkdrKzYEBhiqDK71DJoNc+j6Q=;
 b=Pohn+2hqY7exKAaGc8fi3RBDLOJoJexV1BBpwEQ+lHyZbSypd3Mi3/UhP8z2Qv0X33CP2BqVbjQusOuVNFjkej+A7fcjzJR0MO1lk65xo/QcsBmS4lBLB+4WvaLn1ly5jhdTpsCCjaR8GeoKX3FmPc3FiOJMU+trNv6zSRKJ0MN8wf4pcaV3SzmPL0Nqgrimh1tSPYjUZ5ikJW80joDUBcDXIIDR9okf4ZGE+rz/HmK5yninut8s0zVu5VSn1RBYCWqBhF9HNxvH4YV7Xn3MNSDk5X6AkxGMozi70FckRnGGmPa9mRGhhfsOdGl+nUvw6LCA2Jf7z7BQJhE7kwH+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8jM/hfD6aFbo3SFoDlkdrKzYEBhiqDK71DJoNc+j6Q=;
 b=nq8/A2of6tEz478qtgH4RiV+NhxykWkCcjykZVIeYMlCmBmiKubXRHlxdG9j9pkIZkBXI4VTs4YlrePlnjG7QP9uK29VpeHlYpiGJ7rk+6CSvD2YywA/fTTXp3Eu5xuPc8r6eUnMGZYGE/XwoQdKjQPhs6hNi7I3C70vSaafCnc=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by DS0PR12MB7801.namprd12.prod.outlook.com (2603:10b6:8:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 22:00:36 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81%7]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 22:00:36 +0000
Message-ID: <3bd6af70-7b76-4938-9d56-e74ba0b202d8@amd.com>
Date: Thu, 8 Jan 2026 17:00:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] drm/amdkfd: Use migrate pfns internally
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-3-jniethe@nvidia.com>
Content-Language: en-US
From: Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <20260107091823.68974-3-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0289.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::29) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|DS0PR12MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: c24658f3-7567-4211-06d9-08de4f015a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmhJUnVTdTF4VWlwZnZxN0M1Smc2cHhUR3FYUjF1b1VlT2taa1JZYm9ZTlpu?=
 =?utf-8?B?eFkvL1JGMFdQYTkzbG5uaUZZUUFqN1o5c0w4MEFNTzNZenZtcnI1ZjNYVW9x?=
 =?utf-8?B?QTk0N05icmlYNGIzcUxMb3p6emFINUt1RlZ0NVdoVkRwQThmZlNtM0JhRzV1?=
 =?utf-8?B?QkhlekR1eXVkVjhZdC8yUG1Rakw0TXhSejYxSlpRM20wekpiOHZBd3dKUlVO?=
 =?utf-8?B?TG1vZjRCU0V3cHRBNDIzM3pES2lwcTFhVEFtR3RrNXVXWGVWbjBEODVMc0FC?=
 =?utf-8?B?bHlSS25KQ0VscmRlN3I5Z1FISnVhcmU3bUVwRmk4cFFaMmZhbEFucHAxdDFp?=
 =?utf-8?B?bzhvVlR1cjNtMEpRbkpQd05mWHQ2V2wwWVE5WWRZVDR1UGlCVUdyQmJzc3NG?=
 =?utf-8?B?aDBtRTNTZTRaVFNuc250SnVKb3dYQW9YS3VkZDVKU2pKZ0RMM3pxYThid1FN?=
 =?utf-8?B?UHB5cWpaN3l4dXh3ekVwalMzbTZVeWR4OGVQcElNQkZkZ3FSZjY4TzN1UExo?=
 =?utf-8?B?Y3NTMWFKdFN6d1BPV25sRUQ1Z0laT21aU05RYlFFMHVHclQ5QWFLYlhGazNJ?=
 =?utf-8?B?RzJDNm5PN2g4angzUUY1cDQ3TUV3VFZNV3VxSmRnenpneXJjaFNtZ2VjWS90?=
 =?utf-8?B?QVV0OVBjQXVYR0xDMDg1ODVnaWowdEJWc0p6RG43c1Z2VlJDc3hUNVFCbUNu?=
 =?utf-8?B?MEt2OHNzc2xHOVVrOUJwSC9PbEpUVXJ4dldVdEVrblN0M0NOWVE5NmtVUCtW?=
 =?utf-8?B?eXpwS2d1K3NtNHpCOUxlZVRMVHZlYmtLRDIyNzFzOTF6aWRNQktiY2ltNmhM?=
 =?utf-8?B?STVyeVRFZHZ1d05KK29hbHpyU3lLcHV6VFVOdFVPMEhJTFpvYmpUa0NKWVBm?=
 =?utf-8?B?MUZubkRpNTNuL0xRVWwrWmJjcnhIc2k0OE9PRDNHdWh0Qm5vMVNaRnIvNTNW?=
 =?utf-8?B?M2ZLVkprdjdKcm4vV2szeDg3b0FDR1F4QktHbHFhblpDbmE2ei9pWmRDenl1?=
 =?utf-8?B?YXdQMndpcFFUZG5jS2dSaXBuRUVUWCsrN3UvdmVsdy9Wa3plZlFJd1ZoUVYz?=
 =?utf-8?B?YWlMM2RmRFFMT2xvaU9HNXpTSUJyemU3bnQxbGtFeTFSUG5wVXVFYzJDUnJv?=
 =?utf-8?B?TUxBckZrQnBFOFIvS3U2dlpmUmNiaHF5V3VGbzZBZlNpNnZCNkMyVzlNckZH?=
 =?utf-8?B?NGZ1V010VDN2eGIzbnBDcEZERGNtRlF2bmlDK0Q4ai95UFB0RkRRTmMrOWw1?=
 =?utf-8?B?ejNWRkJmT0lpc09GMXZ0K3M0K0J4RGhNcWhxUE9wNVQ1bWI0V2pqUFh1Uk96?=
 =?utf-8?B?YnNhSTFFQWlUaHlpVmQ2anNpTkhXV1ZJbDhEbkpjai9Va3h0dWdSa2VkdjVw?=
 =?utf-8?B?Q01qTWpROEw4RUpnVGM3TGFodXhjY3J3QTl5TFFsc0ZYRWo2Z00wa3REZVB5?=
 =?utf-8?B?TGNhNHNtbGxyQjFZTURHTGc0Z2lpTldSbzFEeXFwR2dGVVcvdFRJa1dnOFJZ?=
 =?utf-8?B?V1pDV2ZWTzQ2U0djZTJnOGI5WXBvWnpwM0ozeXEvbkdhT3RkM052ekw2ZVRr?=
 =?utf-8?B?bGJKbkVrbHZyQjdESm56dTNxS2RkT203Z1Uyc0ttZnJRRkRnWEZkZEF0aCta?=
 =?utf-8?B?TTlUdERUVzFodDUxTlhHWDE2NG4vV0dkU0IvTlQ4Q25KZkNCU2R3cjRySUV3?=
 =?utf-8?B?bnVSZUErNGlNU25vekkzMUNkNWxrSHdLUWVRbUZWZ1FRbkU5RGZSK3JuMWN4?=
 =?utf-8?B?MEd0cGxtbFpqUmdpaFRodHg1Vmk4VUovUWlmTFV1RDQ3dUs0dGxCUHp6bUhS?=
 =?utf-8?B?UlUrZGdlR3dKeTBOMUg3eW1FMHo3a0tBdk9YRjY1dHpXQWEyUTU3cm5sSEhu?=
 =?utf-8?B?bitDdzR3dXZsdm0vajlCSUE4TnNrWTNFbGJ6Yk1lekVNU1BRb2xmNHlZS0l5?=
 =?utf-8?Q?rpeYPK2sQzz7W6Tco1uMkDRr67R3MUS0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEFRcGV4bTZmeVVqZ3N2YmJYdjBWK2I1Yk11b0kxTGFBcnlxcjg1NC9rdy80?=
 =?utf-8?B?STJydEExRVBpZzFMRUh6YmUyd0hKbC9vOGhJbld1dUdEQWxxL2puS0tjT0xZ?=
 =?utf-8?B?SVhBRkdGUVQ5alhjbXZkVG1yTllYOVk4WC9JRFh1STVncXV2eDkrVlhNOGJU?=
 =?utf-8?B?V3BFcTd2L0QvM0Y0UTJUNjE3NHI3eDI3OGNTWkhMRStIeTdVdGhMU1M1bXJm?=
 =?utf-8?B?NFBYRUxZK3A3ZEMxakNESTBhVHBFRFhrVWdRMXI0SXQxRUZwMkMwOUJXTlJm?=
 =?utf-8?B?QzZZaWJSNDN1NHprREtWeHR0TFhsYVpuNG83Z1R1a3I2azBWMTIzSzFKaitp?=
 =?utf-8?B?Skcxano0cW0vbWVrMXZoV1pTVjdIekx6U2NZYUFNbU5zcnBBWE9KWk8wZDlS?=
 =?utf-8?B?OGxJcm1KaDlmNjBmcVNkbzUvOW8xVU4zRXg4S25xVGZSUGsxTitLTDUvQzlG?=
 =?utf-8?B?NCsxVU9zdmE5MVMrR2ZRbnFlc1NhdGExTWxmbVJ4OFVtLzc4VUFkRTB4bnlI?=
 =?utf-8?B?YUdXQnczaG1UWGlIS2JMYjJFVkF0LzNGUm90amFEd1VaVXE5dzlzeFNrUUZn?=
 =?utf-8?B?VCsvTjZoTjZmN3d6K0liSURtTWpkemlOWGF4RjRTa0xJdXY1L2d4TjBpK2tJ?=
 =?utf-8?B?amxpeGE4OWQ0NmtlU2lGZHVHb0l1dUh0ZkpzV3U5a1gyVW90aEJhQzU5RVhs?=
 =?utf-8?B?NWZjZ3l5RXRjbFR2UG8rR3VqNWNZZXV4WmF0b29WTUkyaW13ZFE0Q0ZVZEg1?=
 =?utf-8?B?WEhDUlFINFlqWkVVdkRkeVhSR3lIRU5xd0pBUFI2NndqcTNXWmMydHlOb3l6?=
 =?utf-8?B?dGI0eENtMWlPUUUvdDdNZTFZQlVnMVRiTjcwSDZ5ZEc0QnJrOFY3ajFxUkFT?=
 =?utf-8?B?Ylh0RUsvZzZuSWg2RXpIOGlQOThkbFRyTU5nVGM3MlhoNTh5V1ZBeXROTnJl?=
 =?utf-8?B?U0ZpNnNaRWhEM2pyTzBXSzZReUZFWVdnbTlPRXVyT01VN2Y1SEFVNy94cWhO?=
 =?utf-8?B?ZENDRHdWNms3aGpCOXUvVkVWa0UvekNxTW9ZaHJ6eHVkQkdRcmdMTjFGNGVj?=
 =?utf-8?B?aVJHQXJSZWxWYmZ0VkpyMVFPMU0ydjhnbHdkcmExeHBUejRZV2Z6alNuMEto?=
 =?utf-8?B?aXp1L3IxVW9OaHkzRmJ6b1ZJQ09rMVZWVFhBMGFoZVZaUHh1MUsyQmZjbkFu?=
 =?utf-8?B?ZmxjYWVydm4rWGJZRjhEeVp1VGluSHA1S1NuT21HcTBqU2NGS0hNM2x3RHdF?=
 =?utf-8?B?UmYwa2RsdGFNTklGWnhXeHNOaW8wOFRKR3lQdE4wL0o5Qlg3WHFYcWxMTndI?=
 =?utf-8?B?UENycDBuQ3J2UmRwb2dVdW9ISGpmU0dob3lMZFl2YTN2OGlxVkN3UnA4RTh4?=
 =?utf-8?B?YVI4MFp6TWdIa2NpbjhUY0c0Ykdrc091MHZRcW1XR0pZMWVDMEFPdXppMTZX?=
 =?utf-8?B?UG1QZitNVnJOdnpHbEdzT0VpUURRWm1TT2ZvYXdrdDVRM3BCVUl2cWUxc3kr?=
 =?utf-8?B?T0hsL0VaNFkxMHN5c3RNMXRLZnhFOGNSZm1Zdm9USjIrRytTeks0UGpBbURw?=
 =?utf-8?B?VksrNTRIb0huclRoK1N5Z2NFNkZiaXRVRWxVWkVEbXhZKzBycVdtOHRua25s?=
 =?utf-8?B?WlIrTWpBS1ByQ2hGRmVoSytMUXQ0V1lwSVJMMGMxc2ZzODY1ejdxRGYwUDQr?=
 =?utf-8?B?cVVuSW43NjJ0dGFVZm1XNXhaVmxNQkVDaTRpRHFRUGgveG9lV1pha2xRZ1Er?=
 =?utf-8?B?ckdZTWxlNzNOZlZ1SVNxZ0pJUGZhWkZIMzgyNVduYTBsaWFKRjNxbW9pMER5?=
 =?utf-8?B?STkrZ1NnOFVVQzdKek9WZEhXMExqWmZYNFI0UUdqYzdLOGV6T2dsUDZoYkRZ?=
 =?utf-8?B?VUVOZ09uY01CMzViODF1dlRCaitIcDZlWW40YzBTdTQzTXFBYzZxV0pzYWpZ?=
 =?utf-8?B?MUxHajNITXFwcm5YVTdTQUU1bU9JUlpDdlpLNFQzaFhDK0lzNkZXOVNPRGhX?=
 =?utf-8?B?SktwZ3JGVGQvMVl0d3M2c20xRmpDQ1R1d0JkaGlxSlA4dmZBbHE5NVFpSWd5?=
 =?utf-8?B?NStqTldjaUZicGo3OW84dWFKWDNTc3ZHakRDd2lwMy9ES3B0eWU5MmhNWkZ0?=
 =?utf-8?B?cjhydTBrZTU2T0RIdng3a0QvQ1o4Mjl1OE5HWXM0K3ZOM09XN29vY01oeFk3?=
 =?utf-8?B?anE1RURMOGo1aDkyN0p6VE5HelJ3K0V1MW1aT2pDMDIvdTZwM092WTVEZGZQ?=
 =?utf-8?B?OVZvQ09nVnVtQkRWUVNsZEdJSVZBdVR1NEloZUo2ajdHNFdlYkczTnQrSUpp?=
 =?utf-8?B?bXRGYlBnSE9JQ1g1VnlmbzJXcnp1ZHdnMzQwb0xTTGtxUk1qMVhPUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24658f3-7567-4211-06d9-08de4f015a39
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 22:00:36.1881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0RnqX15fZM6yr21RtDICr/tX824+WeYh1bccky6q6VLDku79h9UgF8Hlv/9JNWzZtMQQ9hFcRb0EEDkAqm3mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7801
X-Rspam-User: 
X-Stat-Signature: 7qnfum7w81arwsyhnt4fcnwigihsqiqy
X-Rspamd-Queue-Id: 0621F4001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1767909644-389951
X-HE-Meta: U2FsdGVkX19T9YEU5vHxLHI2+gijlXaLGn+FDywQUMkqi4GF5Hnnutsr88QS0k9RE39qtGLyeyWPq988gv8qta2tmNSdX7rdjfDHCVbArh75xepn+M1n8AuMuDAiIEgNPWEC+/h8t3n4iybRfheeh/0z6kKftRQn/yrYUWx+B1qyn9NLAOZXS0cjKMeF4JmzxyM4o8ZEgY7/pEtKRkYtlTqMzyM0SvHoxQO3In1DC3mvXqIbmljQC+zjcHv2U9Kvl1wevXS1E+2apr46UkgORdejgFlOFFKlahRDMaB4HMBE/MtZqB70Be8/Il8KzG3RAES55Igrl6itofggcRnaBk8LDShykGyreTcV79yFuQj5XLChm5faSl60QHy7minCK8sZT1FMSGGuer8OarKNP3Y+mAXKGJKANM1KvZuStoC6V05oVSEf69ZTn8gh3idH9i7/nIeEVqv+E6EZCnwL6B7Ffi3LpaoVBS4u5NqCuDEIM/V6C4bXcfDeQYkiGc82eEJZ6Qaq+teh7m/qKWt2O5akuxzGUFnrrjgnN1YSCmx2Q9EqleYQQawu7xcRXbqW0I0pA42KdFDp9IDDb7advrFmLueFezlgzr7t1Jx5xqrt/yxFgHP8CER6Z6W5J40pqWGqmemO2PnzJk4W4SDOawdOJWib1SDqrdBWML6otilbgvcIzOd6p6vEBe9+P8nCCTsmGE/Pj2INiUdlv8MIMfPC+E9SwOTVnY5Vgo4Hx470jMG3mDsAWxp0yd7v5Ov1RaV4C1Yu8fcj8Njm3Fkvi87Abdqr1pIxDgEfiLk9PQgV+b1OHFitrws+3ek0vg0KDXau4QYV+1r+cNmWpQ0c8c094PbDilm1P9LCEoqNBYQsfJ1g2hVmPFnVu9RiRclwXI/w+mfQ0hSXr6oaYe/dfNZ33XwkZUezRU/QA8m5AE84F3O07WJk4t0VUGYOe7p/98iRRoiX0Ytr6KNbusg
 Bsqq9VxJ
 rXXtjifX29U7WMl5BfVqvfpKM6gqC26LWTswNA8lzEgi5Y/hZaj4v/Xx0WUhjCyyCWQj+4IcU/1zIdoW8SHyEyfYgt77hCIwqTGGFd8Vl30dlQT/XsOUVqAF/2IhxnORALCwf0/2dQ5YTTwJDRCRYCQGghiBrlI7NZymbSxI3HfpHrefeOeVn7dDeRTYLZw5E+eqCT9dWekT5iGDTYcgqDYIVft5NIqJSnfdGixuqGf6IWFbakvZ+N+aWp+b/2HCzOJB0lIkJq+shRqu+LDMWk+wL8UIWwBq1R2DHA5lYamDIqxD3TKrZgz9uqRzxH9BZAJGVJguRDJhvVgUbnQcGImI5ARisW9KVScvIsiZPL378M4fp1ifG1+K1Cf4nelOHTbOY1bc0ZaNiWzB4gSUA1ug8xwOzGH4hQsO9XxxEgoVruo93zpNaVVBOE03KO15T4m5KEfXNnzl9R/dWFxVm2W5eSELpyjnm6OniuyuVk8mqb0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026-01-07 04:18, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have a
> pfn.
>
> A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
> that contain a pfn vs an offset into device private memory.
>
> Replace usages of pfns and page_to_pfn() to mpfns and
> migrate_pfn_to_page() to prepare for handling this distinction. This
> will assist in continuing to use the same code paths for both
> MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_COHERENT devices.
>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> ---
> v2:
>    - New to series
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 15 +++++++--------
>   drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  2 +-
>   2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index ca552c34ece2..c493b19268cc 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -204,17 +204,17 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
>   }
>   
>   unsigned long
> -svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
> +svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
>   {
> -	return (addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT;
> +	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
>   }
>   
>   static void
> -svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
> +svm_migrate_get_vram_page(struct svm_range *prange, unsigned long mpfn)
>   {
>   	struct page *page;
>   
> -	page = pfn_to_page(pfn);
> +	page = migrate_pfn_to_page(mpfn);
>   	svm_range_bo_ref(prange->svm_bo);
>   	page->zone_device_data = prange->svm_bo;
>   	zone_device_page_init(page, 0);
> @@ -225,7 +225,7 @@ svm_migrate_put_vram_page(struct amdgpu_device *adev, unsigned long addr)
>   {
>   	struct page *page;
>   
> -	page = pfn_to_page(svm_migrate_addr_to_pfn(adev, addr));
> +	page = migrate_pfn_to_page(svm_migrate_addr_to_mpfn(adev, addr));
>   	unlock_page(page);
>   	put_page(page);
>   }
> @@ -235,7 +235,7 @@ svm_migrate_addr(struct amdgpu_device *adev, struct page *page)
>   {
>   	unsigned long addr;
>   
> -	addr = page_to_pfn(page) << PAGE_SHIFT;
> +	addr = (migrate_pfn_from_page(page) >> MIGRATE_PFN_SHIFT) << PAGE_SHIFT;
>   	return (addr - adev->kfd.pgmap.range.start);

I guess we rely on the fact that for DEVICE_PRIVATE memory, 
adev->kfd.pgmap.range.start will be 0 after your patch 11. So we don't 
need a special condition here to handle DEVICE_PRIVATE differently.

In general, I like the way you handle mpfns as it keeps all the special 
casing out of the drivers.

Regards,
   Felix


>   }
>   
> @@ -301,9 +301,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
>   
>   		if (migrate->src[i] & MIGRATE_PFN_MIGRATE) {
>   			dst[i] = cursor.start + (j << PAGE_SHIFT);
> -			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
> +			migrate->dst[i] = svm_migrate_addr_to_mpfn(adev, dst[i]);
>   			svm_migrate_get_vram_page(prange, migrate->dst[i]);
> -			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
>   			mpages++;
>   		}
>   		spage = migrate_pfn_to_page(migrate->src[i]);
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
> index 2b7fd442d29c..a80b72abe1e0 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
> @@ -48,7 +48,7 @@ int svm_migrate_vram_to_ram(struct svm_range *prange, struct mm_struct *mm,
>   			    uint32_t trigger, struct page *fault_page);
>   
>   unsigned long
> -svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr);
> +svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr);
>   
>   #endif /* IS_ENABLED(CONFIG_HSA_AMD_SVM) */
>   


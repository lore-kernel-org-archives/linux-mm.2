Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59395606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0Sx7pyXz
Received: by kanga.kvack.org (Postfix)
	id 7A5036B05B2; Mon,  2 Nov 2026 06:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D026B05B3; Mon,  2 Nov 2026 06:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B3D6B05B4; Mon,  2 Nov 2026 06:51:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2536B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:51:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA81F1C4739
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:51:38 +0000 (UTC)
X-FDA: 85390014276.12.90DD6E7
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE2F520006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:51:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0Sx7pyXz;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.54 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793620296;
	b=vnWSyNeXxfcaA6nCrtepEo7Dy9bLtR2uzbSPn9lhPRW6muj4gvQKA65M2EY/fGBclPUTl8
	F4YLDPps5Rh6UCcKkeSt80CouJkoQVQttq5A4uOuzs+KmuV5zYJ61/0xYfE54gO/LLjRmY
	mlLFrRX2NJ36klqDXBQQEUZ849NezVA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793620296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnZmcVW4MUMMIMJfsdgbhHqxz7kCQV5HCffA9o3EzD0=;
	b=hQsfJhhSi2kDSyk81RVMv/P1dlY+ZPlcsDBBgB9u0IxRr0jH1YuacoDFCTiA6yLvOqhl6W
	3UjruASiUzCEVaC7kT4qwoEevJsFIgpQfPzL8ktlTQjodyL2Vvte3DhmtKATOoLCoRX23G
	3LsA0ZXWG762rpBQlS5LQnCvUmi9ExE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0Sx7pyXz;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.54 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oy9JhogJk2IJLsWtSjEu3EEKHOp3pOA9qDxR2W7T/WFDN4J2TeceYWPQNfJUsi9EpRpTyWCky3WOwf7o1cUqDlX9UYD7i8VAScGdLRXqk+Q8lvJGuz33JP80EFlqTVDuOSps+c3vpugPM10T4o+Ntwgn3lWQ6OxJW/ZahDDqoGFu4pZiP8AteBG4F3xvdI6CNQ6lWM12CiaaFtILa98RUReLIiXPl1zFEQY5URfl3R5PjGZzB2oPufoRwZO6nM+O65vlm8B4YgycseoV40kbszyzcQy/93VlB4fTfnm6/ItY2MOcJyBeGKMtvTrReYffgtp7FJAd0XLu2C0V6gYrZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnZmcVW4MUMMIMJfsdgbhHqxz7kCQV5HCffA9o3EzD0=;
 b=BLAP2+SxZZ8EGSY+Tyz58fxi1o3ixx9+SVQ1wBbBaszfHCxRGwopUJnumAMNiX54YIpHWAEtjctouY2daRIcgZb74KTjfQK6UCSzIHDP0/DQAtiTdWQJ+TRNpRqmKSWk90x18Blv8O1tvFTuVxAf8Re8w6o1KuQ7WHFLziyqLbGEE08jVSUWvxEbX/xCyw4n76A7hVnP86bHybZPOTX1cxTw/RZcQu65HYs9gEqIlE8FJtvINXmTfUtc622dWn8qJzrrpFou+Jy25xQ4iQ8atHLkLOWcSJIPebl6fgtbuc9KSUgTXJvOiIDE/jBqmwfdXy3lPXi0DH9/dclhUNxhpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnZmcVW4MUMMIMJfsdgbhHqxz7kCQV5HCffA9o3EzD0=;
 b=0Sx7pyXzZsHdXOCg9PtrLOc9gyAUfPlZkGTCLVlS5QQ9BE3vSt46fNydVwMrxg7CT4XFPI1qfUqa8dh4Mwk0twIR+L3EXOGjzunjhaKleO5C1CAPMAxyQyxbXnntPRc/n5//86/4wFuOrhlSkaXVXVQ0cSsfT7vP8xBXgs0dWDE=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Mon, 2 Nov 2026 11:51:32 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0569.010; Mon, 2 Nov 2026
 11:51:32 +0000
Message-ID: <a9fb9818-39fd-4b6e-8998-761bc3439893@amd.com>
Date: Mon, 2 Nov 2026 12:51:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no
 longer E820 RAM
To: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org
References: <20261102113127.161823-1-pankaj.gupta@amd.com>
 <bd56cfa0-6fdc-4e83-b571-f2abf647afa2@app.fastmail.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <bd56cfa0-6fdc-4e83-b571-f2abf647afa2@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0220.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:374::16) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|DM6PR12MB4044:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7f3d9d-2e63-44ff-e68f-08df38d7a34e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|261021123027099003|11063799006|4143699003|56012099006|261009223027099003|261021121427099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NRRcgKhWNkgg3RPCrl0KyT6qE5oaPC+mde94p04/NXgX3qNW7iJtrhod29vLWev/h7J1ASBeVUeiGJqJ5bymBv0Kge3D/89dGWxC1FgkYfGetxJIwj4czmt40UhfFFE7fFWXnfjPgl9xunmXhS8gxH0YI//ITevzQ1pOQQnkiAUcJlQpakXiZ/eye6xA+IBV0mVapJKvrHpAZwqU5r7bp2J4SPBq3d6FJLJADzWz8Uf48pAqJp0eAuWTKoARp2Qq226uHNWSLgSVmGlfcyGcSo84rnA0ssESuUf8MHkgksFWJVLr+TWs8hPPR7L6qxW015n8MAE8ZkvJBm045/FQ3j1GfcCrQZ3cRQ5+BZaR6n0BoYHOwS/o/poRXUYo5XnM366uFlNmtcNed9MSw9jgsgEdnhMnL2/fK8tXF0353rJSzrPyrsybiW7xqqwQubifR71fgy737tHd7Cs9nr4iy+B7UBVIVzQZoE7zWOSXvIuzyycPNQWy9EaTMeM7eyJmc7872jG3DayuOqlvUEjxh/XhiL6JN5brEyeH0IHzdW5KfJLRoksmdiH1pSmCQIxbHJb5hl9s+4mGVjT9kQb9f1KN3N3Q+2al2xTBhSARQavG+gphelC5syAYX5FnUkmU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(261021123027099003)(11063799006)(4143699003)(56012099006)(261009223027099003)(261021121427099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWRqOGEyZGlLaFNCNStHZ2YzT2tlSkhvdTRCMUpBRmdzQjlWSXkyWDlyKzYr?=
 =?utf-8?B?MWtZQmJxM2t5V3hRSHB4VWlVZzdORnBDd2VqekREaDRoRmpCdGhtRkp2cHZu?=
 =?utf-8?B?MVR5LzJBRm9oVWpveEg0dFVOUFUzNTkzVkY5eXd5RFpIOFRma1k0QW95UFp0?=
 =?utf-8?B?WVo2WjBoaFpFaks5OTQ5N1RYU0pYRnNJV1c5aW91bnV3N0w0SmFRYzBocElY?=
 =?utf-8?B?K1UyVEh3NUhLNHFGOUN2N1JialhtS3dqaU1zei80VC9qZnp1bUtlSmVYMjQ3?=
 =?utf-8?B?cHNWeWJiVUFGcXFKY0M4VmFrZjJMeTkzN0xudjR6UTk5clNIRFQ1TWxscjNy?=
 =?utf-8?B?bGFpYnAvRklNZGF4NU1wV05yTUtsdWFCT1FGcE9SWlRsTGVXemdWT1p2d2lL?=
 =?utf-8?B?RnpnWlRSRjBIRXRHdi95Q0JDa0pXNVQ1cWFPb1JvcllIdm1hV2ovUFFNU2g2?=
 =?utf-8?B?azc3RXU2c2VMNGZPRzhkV0gvaENTRndvR3hvVjA2YlBhdFIrUWpwaU82d1Rq?=
 =?utf-8?B?aGxBZ2pyZmtGdGF0MW5nR2FLV1RrQUdwdXBPQmxNQkV3dFpSOWV3bU5USUxv?=
 =?utf-8?B?dmhGUkEzSm1tUkQzek1PQTArZWRFMXFNNkdYQmZBUTVsWkdURjc5VkxoaFJ6?=
 =?utf-8?B?ZDlJQU95L1FFSS8zYkRnUFM5dng2UG9Pb3VkdWhDalY4L2ZESC9NNCtmMjNH?=
 =?utf-8?B?cmVwQlpzdm0weFJYM3JCakI1UUg2VzUyZUZSNGZxenVrRkJIWjFpNHlVTGY2?=
 =?utf-8?B?MFRUa0w1bWtxbTBrckRMbTIzWVNKRmUwRlBqQ2ViK1M0NjJXRlFwM1h6Z0pK?=
 =?utf-8?B?WG9mZkpZTjZNU1lpMkZpL3NsZ3NVOVN0aGgwVE03eFdkQVY4NHdDNVBDRzdD?=
 =?utf-8?B?cmlpQ0NpTWwxT1YzM0JjdHl6U0R0WGtXMnVUSmliaHJHbHFDT1dENER6cEdu?=
 =?utf-8?B?U1UvZjFjc2ZPYlNFNUJUcm1VMjVWS2dTY3N0VGdVeVhGTERzVEJOLy9CbGZq?=
 =?utf-8?B?K0U5TCtOcFk3ZlRuMTl1MWVVRDB1TWdta3ZvOWxad2QvUmZ2Zkg4TlcxczJp?=
 =?utf-8?B?ZS9HeTU2RUxtUnBZd3JUZVVHOXBPWVd1T3EyVHZhV3V2dzhmRHU4SW9yMDJM?=
 =?utf-8?B?SFhMRG1jeVFiZFlRdHlHMWg5TE9RTzNJd2RqUEY2bmdieGFqakdOdVhpcEQv?=
 =?utf-8?B?eXdFTU85QWljOHJwVDBnMnlVSEdIWmlJbnB6ZTNJMkRxT3FKRW9ocHVLS2xD?=
 =?utf-8?B?VlJVQUpYcjFkOXJjNmdJMlZ0a3ZMRW1Ed2Y1RnhRQ1NtZ1UrV0xOQjdzcHJM?=
 =?utf-8?B?eVNlZGRmaG92bHRxekxZR2lFcWNPeXBMM3Ftc0tiOU5mdGY1LzFhcU52V1Ny?=
 =?utf-8?B?RzZKcHZ0MmRFZWR2U3hQY3ZRSEpVR0UwVzM5TkY5Y1QvNXBZWmJzdS9aZ3lV?=
 =?utf-8?B?b3BpaXk2R0xqS1hmaWRBZTVjaVhmYUd5c2U5NnZMU1RtRDBESkVLWi9rdjlJ?=
 =?utf-8?B?bThzLy9mV3l0N2dSclFKMGRRV3l0MHdFTElITnYrVVNMR3lRVGRMVW9BQUZj?=
 =?utf-8?B?NHNCUnRFUXFyUExTSVg0djVEcURYMmhSbEp0c0l0YmRjb21wVGhESzd3ZlNS?=
 =?utf-8?B?ZzB6c25Qenl2R2NheU1oZFJzekdIWWdJcXFqNGZNNm9ScmJ4dTgydlhJRm1w?=
 =?utf-8?B?ZzQ0WDRPSllpZ1JnMXRxSGt1cm1MSnkvK3BwdzhXSi9GRUtBSWprTXRheDdS?=
 =?utf-8?B?KzNkNDNuMTN6YjJWdE5LK3hPL3RaQmY4a3FZb2cvcERIMWJjSjNUczIxSzlD?=
 =?utf-8?B?NmJ5K29VZDg3eVIrSFNjUzlxcDMvdkl4bmpab2RWSUpyOTE5VUZvdWplV0Vz?=
 =?utf-8?B?VnoxOVJOcFIrMEZRZWpIVnpEZTdlRExvcmp6eDZOSys5ZUFGL3plWmZrYUdU?=
 =?utf-8?B?V1piNmRKcXg5cDQ1amxHenkzd3hTcURZSVN6ckVtdnlYY1dTNFNxdHZDczhp?=
 =?utf-8?B?cDkxNFZ4UFhwRHpRbDhiZUJhcklpM2xFaUVNWnlzOWtFdW1VZWxabnZINnR4?=
 =?utf-8?B?NjZBM1VmT0lHamkyeHZCZ3NRL1Q5NGZXWUk0WDFlcVkzMUs3NUw1Q0lqM0RE?=
 =?utf-8?B?d2lrdXdvWkJKcSs3blpCT1JGb05CbXFQOGltajFzQ0VQWitzcTlVUDNSOGY4?=
 =?utf-8?B?TW4wemxsOVptLzNKSlpEVmNzdVJUWWtGOTVMNERHdk8vTEtxYjA1MnVhd1FC?=
 =?utf-8?B?Wk8zK0JxV3FXU1pDN0paKzd3b05HU2ZvNU0zZnN4UndNUXZWeUorZURiQUxu?=
 =?utf-8?B?L1JYU3hmWXFJTXlnY0EwMzV1NHNHWEk4WDVITWVUMFIxVmc0QnVmUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7f3d9d-2e63-44ff-e68f-08df38d7a34e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 11:51:32.0433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3AaykUShJwG8hEDYox85Gf3xojdh49oTkxg7fuKvykgAeySo6ScuW7LFf5FPwlOp5NTIpfwQ0YHRy3HGqPOJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
X-Stat-Signature: fdhqesqst9fgaa19wa13rzfo54i6rjp8
X-Rspamd-Queue-Id: AE2F520006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793620295-427357
X-HE-Meta: U2FsdGVkX1/lUPC7vHPf2ui28R4u1f1QmmpqgS7cMOjAMM4rslLcY/8/NW9bYvdochaVJrUcBOszxQ9qNLdU68bWmy75HDPYnSLwnlOZKUv8K0lpjtF6OqivlLlD0RhaqSm6wuBOe+W5LoUzMJKUCdLOPM13mGeR1DmI9xGgXZ15sEuj4tYGA4Ddcy3M1E84pP3DSDp2PiNulrSFAzo6sUkC6e7S3aJiM9KrhMuCAWIqqf5waYfWKVynTd5FYkAL12gaAzuMCVc+OlzG2aqFv5+1DaQWYovFUlayr8VvmY8BYRIEXlPMJCKsUj4Mcn/Kbddjx7RO8vD1EvQ6XWqZQ6BObo3O7lI++kVL5uZz2BB2zVtGwb7Mm8HJox+Pfiq3p0ZOv4Q6dOXT9HkLFEMRqSNGomPVyZ3Ic5wmVfRH/h0BwGdz8rFevzUzbFkbrLjwFYRA/olbqhROgqefjTixztSzcDZiS+kjJqsZ2zEooPGKHtG4pQzAaqjirpkkaf3AS6w3/GO1wET/Xanc5aI17AYAGoPy5lRCARA+c6SiFTQRMk6JZ10m9YeyzPVJfMPfECRaW8/dP7gxRNW2MzedXH2s5xc0r8x0QknyEmldjFmsil/U6TxMvNDxM2l9fcDWI3jw34B+NGqg1e6qNe84jJT5RU60M35r0lYcyqXL+RDXiC9Dl9LV2ls4wB1l/pMkxEAZjXHqxPTDWgm1qNr83vPd/quHu5r47W1N9OkEKQp1sQwCKVLoo/YvuvEVHQLCiFliqTd32Px7kBEe3hTHhMqbYsAb/L2oCMuSnifYY7VftR93qykhNiAQ/EK3Z3++6zlsVED5kDLH+Lf4cHEqiGtV3EdBMzRUS4VmSt9tF6sp3RkdgMrVcsUkXFjyG2/I17Zm5U4ErwTbdLK2xfwKxPJ61zXr+qiotNF7J/g6AHti1VN0tAQ0yB2zjncUGLo4dSerwVnMRXgsjHxyi1J
 kCZI+8th
 WcA3D7QceIy/4QL2/j2dCrAzVvMzJv2mNCTNM7meJ+AbRUsfu6rteaExryoCQa9rYZfEaZ64iumAGKnznGpeoxrj6F+szw5CCXvyjjvE4rzU44wj4KKk9C/7qSCwb81G5YKZDfM5QRxNtkQGF1M5dPEcRmWaXO33P6cXmrku6HWxYhzNSKkNqtO5189NbR58xFDyUcBHodY+OLNNXa0AoVsYREZs2D+xBiVJt249extveqJXIJ9n4L5bGdeCCfG4HRY/Hs3Iv94U9yRVKAOGsItMTlLvK8M5ANHzxe+Vys+P4xOVY79czCQi1mAFIurooWPhOThR9zfCcgQ2R5h8OlNIgcwMxqULr8w2/kp1s74TsV29wX/z8g1bFEoP7oP5tzB0jtndyIa75In+UmC1LDxgDhl9LVELUrSAdzqT4SZPwt0l2kqmW9LG1NXdmGCqrjvG5YqIwYfYTP1I/4mXGObX5CrQmtOF/0VuCp9/x/fFVIivOArRIXJ8ZieyZSoQnK0wPpK2NM3onK9dYLozvUTEFnOGIhvxUJ5d/crXPxHv8q1Qg0JXxWmZpro1ZlF8Qre/xuzPUm8ai+E5QVbl07M47XQKjOKfTb4balZRc6wuVQ+iF+KzVvEF6Ai0oqdTCG3FHEmjreKwQeRCgCgmleVoK+Q2s9GbblurIYfnyWXcvO84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ard,

> Hello Pankaj,
>
> On Mon, 2 Nov 2026, at 12:31, Pankaj Gupta wrote:
>> The EFI stub builds the unaccepted memory bitmap before the kernel parses
>> its command line.  Option memmap=<size>$<addr> removes RAM from the E820
>> map while its bits are still set in the bitmap.
>>
>> The removed range, such as a memmap=...$... hole, is then still treated as
>> unaccepted RAM and accept_memory() tries to accept it.  The hole is not
>> mapped, so on SEV-SNP the PVALIDATE faults and the guest crashes early in
>> the boot:
>>
>>    BUG: unable to handle page fault for address: ffff8a14bfe00000
>>    RIP: 0010:pvalidate_pages+0xc0/0x250
>>     set_pages_state+0x41a/0x440
>>     snp_accept_memory+0x3e/0x50
>>     accept_memory+0x186/0x260
>>     __free_pages_core+0xd2/0x240
>>     memblock_free_pages+0x1b/0x30
>>     memblock_free_all+0x275/0x2d0
>>
>> This was seen with memmap=2M$0x1ffe00000, a 2 MiB hole in RAM, on a 19 GiB
>> SNP guest with lazy acceptance.
>>
>> Fixes: 2053bc57f367 ("efi: Add unaccepted memory support")
>> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
>> ---
>>   arch/x86/include/asm/unaccepted_memory.h | 23 ++++++++++++++++++++++-
>>   1 file changed, 22 insertions(+), 1 deletion(-)
>>
> Can we just disallow memmap= when running in a confidential VM?

My experiments showed: memmap itself don't have a problem but memap with 
a hole is causing crash.

There might be some usecases which are already using this, e.g:

https://lore.kernel.org/all/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org/

Thanks,

Pankaj


>


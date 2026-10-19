Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F93606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mC5cjnnb
Received: by kanga.kvack.org (Postfix)
	id 8D6FB6B00F0; Mon, 19 Oct 2026 13:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860876B00F3; Mon, 19 Oct 2026 13:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7036B6B00F5; Mon, 19 Oct 2026 13:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30A736B00F0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:32:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D2731607D3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:32:53 +0000 (UTC)
X-FDA: 85340071026.17.3412137
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010011.outbound.protection.outlook.com [52.101.56.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 578A880007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:32:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mC5cjnnb;
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792431170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QtrI64eOMrx/8dAY2aTSP8/4qMpRO/bnOOrK5OW9Rg=;
	b=BTCdXvl49PVKs3B0fTnwak3j4enSbHhWrP3d9qLwS0fpOp7PKCBLcJ026ELrINJr4CLh7H
	MDDfPvrMwogbSvtywdvcn+4UeMWP5UZyeAAix+vV+TVTvOIl67hD0cJktKZ4gBiwnYj6cz
	dAnpKq1R3dSLxtZL/XlPDXQyJeHL58E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792431170;
	b=mcgS5taK5Hskr8GNbsx7gX0NI0kzvZKtifssSxUX+xosVsqbXaf8ci53o+DFdijuL+c22z
	k0R3D0uIt75xMRxboW7ZvOr4PQLMhG83sXoT29HrgzSZvZflZ9ST+5v6JgZcRQTLtmttZU
	hNZ0GpV/j3coxpLJn8PxGNEnjUrZ3EQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mC5cjnnb;
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRQ7qLfsGXitj3myGHJWNpDPMNQKLVKFgLhb/4itv62CRyh2ZF41Ot7ZUm7ZONQdhbf7+I/5ccDxntKMJb8dxYIKkZMUQRhQkKsgntZM/ghSMuwPMdJeQJ7PuqStcZwFX133dlHBul2MAIwEMQKnA6z9dMWu0PmHWaEMJ4z9c8rDZWLXO2+QRWUHi6sshlVIE7F7OHYk9b37jc6VLhl8sbrHuKEVOQTMBxcr+6kwJEuYxjtOWT/RfxYDXWG0C2qX4OIJ5Nshm8YfGevAXgR6lOPKktwzSCPQu+OeOXWjfzSgYwN6bIBa3NNn2Rg509Vp/T4CFekzcVQDhrMMCHlxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QtrI64eOMrx/8dAY2aTSP8/4qMpRO/bnOOrK5OW9Rg=;
 b=eIyPxPhpD4uyYPSSAyuUvj+GqNI4HIZY3w42G8p1kmnZBDpTcukm6oZfB45RVnExk7e08mRNEiXQeigabOj2YCQH+9CtHZ/tgHrOcNPHLpLugxgGP0x7bTIk1ovv+D9oArS0R1k7Bc+v6TOuKNzpY/L0MccBKw7U0aj713onwJgL22JE232CwMVJyPjjJtcVyZVKO2ZO7nLdc5p58jIWRB4uAdtllVVeO5+ZV7esqTZjljhGWaJhLZMTj+oxnBb9za/MyGEds+iy8EU4eKL1ywT//soJFIAzzWCwXYwHp1Uy7LM9B2e9PjQO5+gcUETHMXxdX6g299Xi0h9HHsG15Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QtrI64eOMrx/8dAY2aTSP8/4qMpRO/bnOOrK5OW9Rg=;
 b=mC5cjnnboaNjtt6SaWw+EcfA6eAb0v5JAaphxTozr6uU5I1hTTsYej+DIDA8D9rlxeuQBgRTwp2rDDY13WotEOmstHhrndzNclwcPBnv6gx976VFfUCRqkVHDCd4FgWw49kmbnSk6yvh9kI50UhAtULMiQd4OOUGwwxK5nMGwLw=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SN7PR12MB8026.namprd12.prod.outlook.com (2603:10b6:806:34b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 17:32:45 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 17:32:45 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "david@kernel.org" <david@kernel.org>, "pfalcato@suse.de"
	<pfalcato@suse.de>
CC: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"surenb@google.com" <surenb@google.com>, "Salunke, Hrushikesh"
	<Hrushikesh.Salunke@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"liam@infradead.org" <liam@infradead.org>, "nhuhuan@google.com"
	<nhuhuan@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
	<rientjes@google.com>, "torvalds@linuxfoundation.org"
	<torvalds@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Topic: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Index: AQHdX7GhnuOfO5oRrU+HnM1hVhc+T7cEtTAAgAAUroCAAA0WgIAAE9SAgAA1hoA=
Date: Mon, 19 Oct 2026 17:32:45 +0000
Message-ID: <a15bbeb33d1c6e6d2cf4922f65cbde43b5784837.camel@amd.com>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
	 <atX3lpXQBHH1JPhW@pedro-suse.tail5790ac.ts.net>
	 <ad34dd6d-f106-42b1-b8b6-a4487822285f@kernel.org>
	 <0346e29faa551efb6a4e21a920d344f5f9b918e5.camel@amd.com>
	 <046e3eef-aae6-4361-821e-06cadf250d49@kernel.org>
In-Reply-To: <046e3eef-aae6-4361-821e-06cadf250d49@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SN7PR12MB8026:EE_
x-ms-office365-filtering-correlation-id: 6a06ff71-dc11-427b-2cf1-08df2e06fcbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|38070700021|56012099006|11063799006|4143699003|10067099003|261009223027099003|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info:
 clWkcTDRcZLlWaZJIcD1Xo70B1IVYFHFA+mTsT881DB1+bFXR8tvs8izWaxkA45lkjEVvHWA303NfyPYmJBrYKUxbXbpgj5xqdgdNs7hVjABXbKtYa/A4UJfV8zsRjYdxhdlbWUKKlANdlb33fLO4yxYgdZCn0Vctf2RL5FVfM4fwzF0kl9vg7cN56kS8cGenWLye0VTHyIo51qDu5VjcmD84yYRCf9AS1atxgld0kEVymzxJniqSWePKpql55K7qYdDFgdrCOVmq4ik92wRXtQcOjUo7LaiKBMawsND2yhOQ2AtSyytjCqOhyZjeopw0TOXMrUoYj+4JR765RK7Pu3v5OOBU81o1IPJ/dBVD8nqYyl8BO6HSqEcrBebq6R4y3gVlPGUG+wmE3GR546+Rc3zrw+/Lhb20qSUBbb7m9isgIRRBmMUk9SRyViG/kECHly4C+WCzoa9Vg7yuUUeK+bFQ/bmg92xTIYtRDoHygz56hTzNsqJX4kH63E4/6NmWnGaHQxpefVlyMSikR822dDOTVQUbQqqKUMB6P9tInX7/PJ491GbE+58fRz8MyukfM1LdkD8KqeKM5xDpLRQDPfePW2uUX3Bo2VwcLmdnuquZ3KVubCjLgRkydeW0tnZH/uJLi3v3kQNMKeuER8w5gcBpZ7JIHaZFw6DXl5ix9JtnwDZW+vLHgv2rk2sAQt2PVROQpsGE+Q7UXPwHrGvzs6icel5sZb3oapce5eJb3Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(4143699003)(10067099003)(261009223027099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFgxVWgwT212MDhtbGlSQk10OCtyZ1crcE0rZjdkVjJiNFB0WkozTFJzS0Ex?=
 =?utf-8?B?ajRmUXBCR3ZldEhNQU9hNEl4ckRoenh4dWdpdTcrcnhRWEJ0a24rbUR2Vksy?=
 =?utf-8?B?eWZNekJ6OGQ2V3Z6R3J4WUZweTZuaXpya05QV1BLTEZ6UGgrR2lHNDkrWkc1?=
 =?utf-8?B?L2R6WitZVDVuVzJmTExsQTBobStBamJWcEw0bndRSHlJY0tENjRsdmw3NVRY?=
 =?utf-8?B?UEo1NFo1b2Z1eGhTQXJjeHpZa0piWlN0Z2xIdDhlUStxalN0VzNpY3N1aEow?=
 =?utf-8?B?R1QzM25rMGJ1MGg0cjAyUUk2c2phb01CRFdCMGNzamhFem5YWUpuUUdtcVYy?=
 =?utf-8?B?VVpJdHgvdndRNWsvVzRZUk4vU2tKb0pMM1Nxb0RQZlRlMWNIekVMeUZRMHEy?=
 =?utf-8?B?TFZKbDlXTWFldHdsMmY0c1RtR3FQRUx0dmpSWXRJTDRhRmZSVVVyVHlsTDdx?=
 =?utf-8?B?eEdkRnlsYjhkTDM4dUo4SWhDeWNBUWo5anlZRlZSNWpYNUhaNEl5WTJ3R1V4?=
 =?utf-8?B?QjdiT2dZd1BSRllHUGYveW9majlGeFRJZXVyMTlwRDZMYXZhUE1WT0FLazlC?=
 =?utf-8?B?Q0hDbUhUaUtxbFVtbFltc2VmUUF4MTBkRHVuZllCRTdob3VFQVp5UGtVaWxo?=
 =?utf-8?B?ZllEZHVnMHBEek9wVTV3d0hwVjYwT0RaV2RIR2w0TXp5UHEvM1hHKzIyeXQw?=
 =?utf-8?B?K0YzWU03MTVGWkZYVHJxeWgyNVZzY3JBU3RZVW1HZkhPc3VjQ2k2L3VxMDZ5?=
 =?utf-8?B?VDM1aW9UV1FRc2FhK0UxRmRxanFFOWdKYno5RktEMDVNeFpEY0xjaDJlMUtu?=
 =?utf-8?B?ekJXNUJ5SkJtdHJFM1JCbGZ0Ry9EWTRZbzI1bERrdkZ1MnpFdmU4clhQR0lW?=
 =?utf-8?B?NHBPUWVZVzIyYkltVVVaUnFweFhjcTR5TUk2Zk5yMGZTUWR3ZGIyek1zUUd5?=
 =?utf-8?B?aE8vOGdPRXIxVi9JQXU0dW1yMmkrRStSUXNYNU41USs2ejI2UU5mNnR0c1Z2?=
 =?utf-8?B?WTJmbkdIa3lVWGMyMVhwTjUxV0dGTUtnVXc2Ull6UURsZTltdVJ5U2lOTnJk?=
 =?utf-8?B?UlY4VHFHZEMxcURBc3FlZ013M3Q3dUtYamJHTGJlMXBtR0NqS0dPdzVHbmlV?=
 =?utf-8?B?S0NEblJ3cndwVGJRamVSdmRjU2lnNTlSWWVYNnk5ODZHRGtTNjRHellmWS93?=
 =?utf-8?B?SFdPWFVFYU8xR09rcWJMUWp1V05mZHI2LzlKTlJkY2FIcm1ybnBySFpvUUlG?=
 =?utf-8?B?UEhBZU00UnBJOFZGMUMxZmZIYXAxNTlFMk03NWNvalBmNkkzNVJJencyejhH?=
 =?utf-8?B?Wk9PcFFxamo1WHZyNXZrV1NuRjVteHRjV1FOMUxyUUJ4cnduRjcxSlZVa1JS?=
 =?utf-8?B?QUdEdmdEcVdwSDRNeGRQSEx3RDBtL29ldXBoR3Rsc2ZscTFhS0ZKV0kwQ3FC?=
 =?utf-8?B?b2lpU0NXaDNuZGowODhiOUhNYzVBM0ExS2NTa0Nuckhwc0dVeGEvc1BUR2tU?=
 =?utf-8?B?WkFNc2EvYWQ5TXpGUXVjMGxhNnE0Rnk1bXFKR3VHMEFwZFF1eGxiL25yM3Jn?=
 =?utf-8?B?RElPZzJuSjVFTXpianJLRDkrYW4wbzA3UUhQbzFlVDJYTVYyZldoQzh5bjNU?=
 =?utf-8?B?Ynhjdnl0dUFXcWFPelZPWDZkeC9XYzc0RlhFbWk1SjF5UW1lYWFQMDFsMEpt?=
 =?utf-8?B?K2NHeHdQYXFCMDB6Y3d0a3I4SXlCc29uekZlU2ttMTlDdnJXVkMyKzM3cHhT?=
 =?utf-8?B?OXFNWnhSRHlieUNlR3RHV2xFZXh1bWhMYnZlZ0l0VG10NTcxdDBJekR5V3dQ?=
 =?utf-8?B?SjdRUFBoZkh1bUZTZStrWmRlb3VGdTNETFg0S3F1aVBUSUxjeDZWWkpkSFFj?=
 =?utf-8?B?VmFRVktoUjBaRFVXcEFNYm4rMjlLOFphTDMyeUx2UXVEZnlWTExUZnFXYm81?=
 =?utf-8?B?bXJMU251cERVQVkyYlFSK0UrUHNDdlpDWHU4WnYyR2lmQ2lqekN4ZXNxYlNU?=
 =?utf-8?B?WXFNSFlyV254dGp0a0RPSHA4c251UFJDNFc1MEk5b1djNVlXTm90S0lXT3pR?=
 =?utf-8?B?Z3VoQndSOWxVWHFqRUlRd1M0dGdSQmttcjVVT1VYaGhGdEJrT25QSkkzWlB3?=
 =?utf-8?B?UlZMZVJpUmdOMnNoalcrelFjSlhmTytCZDlHRVNCUEZDTFByMG8waTFURnBx?=
 =?utf-8?B?RkNRZHVRLzdPemRXUkZHdzhvMHdBYXNrN25tT1Q3YndvWEpYcit6aS9OS1VC?=
 =?utf-8?B?NzhEN21GcHZQTkQ5Z2IrY3NKb2tXVENuOFd3MHJrb3V0RXlmYTg1cjM0b0ky?=
 =?utf-8?B?aTZRb3ovRGZBc0NEWERwMlIrVkljTXdtY0RhbUVteWlFQ1dMTUVKUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <723F7F5139E4AF4B9D448FCEC67AC5BD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a06ff71-dc11-427b-2cf1-08df2e06fcbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 17:32:45.4846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MZQRlmAQsdeH4OUmtwY/XMx3+L3/r9zhqi2GqLlw9TDH5HdMxeWQtgm8DPnglFdFxB7l5xwve/dMlrtuGKvpDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8026
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 578A880007
X-Stat-Signature: ujuuzsikmreu6meibsy3k7i37rmehqro
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792431170-132061
X-HE-Meta: U2FsdGVkX18QN8dNlro/5WJQmSrgOIX9D95srHRizdAhA0SSNtzLFMOtTXjAFpUGUlaHdgQ/Dmj7h5NFCoxiJ+2fHrCYe+ZIqbxeIEIlV9kV8Ckc8g/xCoqfqvUMoxFxtGWOh2K1t40C4jXydhxQ17liyp+PACUSyBudKceYRkBWd+n60fjAT6gmkLirNurCIK75vFuveHDwvVqEGzj1xl//Wp20FN+Fnnsca7JiJeodR6tJqE47UyGwgjfyZxNYqqPLZXlI8Bwcs9JIKBu3yg4K23PwSyVP3hN0NDFSaRG/gzSr8AQd6aNnHhS9vqc3q3gsQosiQgjxhxG68/BqvJmR49KwmwB8tmndEqfQMr0+H1pVlgRtHCt1RxVvLVhD+73Ymx+AOlYGPdPBG29BDtIHzG9CRXQ6Q1trZWBCDcnc5zzg5p7P6zpdoxwbJDQbvw41l+IwqztFK8A9r3Tezw7CHI53BWpGTSiSPNFjSWPlDL1rihOxrWbtYYzC7EVlhBRrReyza1BAAxT5+rQ53XlEqEMyiuVlWVobnf/0mXwiVKDjhMSVzTlpT4k41rpFCmNvF6S1NaEHFY3nVpmaTxBsLuyHon4/JqexrxHKU9ws+CA2T1JcgIs5etvnJ3aOycBbF1Z4pGcBlqWJbT5PVdqG0JictaLfwaHFjYiosw23AG4VN5tIzs417UppLLfj7qbBirqFWbLfFS5OgBtxZxIpBvtk9Ih/A8DDXVryvaTNv2r2o2G7W+I0nP06BQ2cWtb4Kyd2kS/gUMnuwf4E9QLFXHojWLRgx3by5ZcuUc+TD8kq5sZNDxeWlYFq5Vt5nQ5SOKU95G0Ggxc0A3n8PcK92KtyxLoveyxiEoxLGGp2e+cLZkV++D7kKoxNjRD8r93hIl4djbZZB39FxtorTXb2zhWCZL+0Z1xgm9pKTHmaMJPwiJkTIsP1i178hUGz2yjbVHd9TKWQzNZtWXd
 3BYtkbRO
 9fwynCJqi6BrKigJfYe8nxKQVa+/AomDyxr7Jwhis8a9qUoaRnRwqo7Z4/ijdOkOGQSPp4wCf76cRUhbvhoWx/ENFe7z7sj4jOICr7uEsGZkCtfWToYrdNMB3LvUllns+Vk7GHoc2HIbmz3+olqKJeHGLKdf12ZGnC4HS7tzkTXm24WWbwcrbpjYuhjYFEUJkN6HwMFcuAje8Z35bF0t0BsFU1qtJgQbA0cRwxjwVfX+TuEmVxiuaPLTbg5ZwtMKn6vyndy9UCCnmzZFJKjQfWfqAPFHVL38QhoEbXqAAVBfYqZuFZZ0B5n7adUQEjkE4ckQsoTFVdvIMiMA19LAfcuaC853xX7dyg2XNZc4thiOK4bXDhNk4onFJQz68wEdotJMx2JqJVzki4n+OufFTd3WJXAxjYZI/F7FgYZGiI6KGhM4/MVhK/tmYvU+RsQ5KzgMp/Pynf5qodsZTU/0Wy/f086/N+vPzTh4bHLvb6sANc5soOi4ZT5wJyIQ75ksT4vOrTxX1lv6Mq/8tEyVIj2S3l8gLOKN+ja9fJ/dvDyVhf+uKJDY/Xh9FeT4AZ4pqggqFbkYa0EaNLWemt7L6Iv4dv1NIPfRaXal3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTEwLTE5IGF0IDE2OjIxICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gMTAvMTkvMjYgMTU6MTAsIEdhcmcsIFNoaXZhbmsgd3JvdGU6DQo+ID4g
T24gTW9uLCAyMDI2LTEwLTE5IGF0IDE0OjIzICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IEkgd291bGQgc3VnZ2VzdCB0aGF0IHBlcmhhcHMg
dGhpcyBzaG91bGQgYmUgdGhlIGZhbGxiYWNrIGZvciBub24tcHJlZW1wdGlibGUNCj4gPiA+ID4g
bW9kZWxzLiBCdXQgaXQgZ2V0cyBhIGxpdHRsZSB3ZWlyZCB3aXRoIFBSRUVNUFRfRFlOQU1JQyBJ
IHRoaW5rPw0KPiA+ID4gDQo+ID4gPiBXaHkgY2FuJ3Qgd2UganVzdCB1c2UgUFJPQ0VTU19QQUdF
U19OT05fUFJFRU1QVF9CQVRDSCB3aGVyZSB3ZSBoYXZlIHNpbWlsYXINCj4gPiA+IGhhbmRsaW5n
IGFscmVhZHk/DQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gDQo+ID4gSSBkaWQgbm90IHJldXNlIFBS
T0NFU1NfUEFHRVNfTk9OX1BSRUVNUFRfQkFUQ0ggYmVjYXVzZSBpdCBkZXBlbmRzIG9uDQo+ID4g
d2hldGhlciBjbGVhcl9wYWdlcyBpcyBkZWZpbmVkLiBXaGlsZSBDT1BZX01DX1BBR0VTX05PTl9Q
UkVFTVBUX0JBVENIDQo+ID4gZGVwZW5kcyBvbiBjb3B5X21jX3RvX2tlcm5lbCBhbmQgb3RoZXIg
Y29uc3RyYWludHMuIFNvLCB1c2luZyBhIHNpbmdsZQ0KPiA+IHBhcmFtIGZvciBib3RoIHdvdWxk
IG1ha2UgaXQgbW9yZSBtZXNzeS4NCj4gDQo+IElmIGl0IHdvdWxkIHN0YXkgaXQgd291bGQgYWxs
IGhhdmUgdG8gYmUgY2xlYW5lZCB1cCB0byBlbmQgdXAgd2l0aCBhIHNpbmdsZSBvbmUuDQoNCkFn
cmVlZC4NCg0KPiANCj4gPiANCj4gPiBIb3dldmVyIGFzIFBlZHJvIHBvaW50ZWQsIG1vc3QgYXJj
aGl0ZWN0dXJlcyBhcmUgZnVsbCBwcmVlbXB0L3ByZWVtcHQgbGF6eSwNCj4gPiBhbmQgd2l0aCB0
aGlzIGNvbW1pdCA3ZGFkZWFhNmU4NTEgKCJzY2hlZDogRnVydGhlciByZXN0cmljdCB0aGUNCj4g
PiBwcmVlbXB0aW9uIG1vZGVzIiksIGZvciBQUkVFTVBUX0RZTkFNSUMsIHByZWVtcHQ9bm9uZSBh
bmQgcHJlZW1wdD12b2x1bnRhcnkNCj4gPiBhcmUgcmVqZWN0ZWQgYXQgYm9vdC4gcHJlZW1wdF9t
b2RlbF9wcmVlbXB0aWJsZSgpIGlzIHRoZXJlZm9yZSBhbHdheXMNCj4gPiB0cnVlIGZvciB0aGlz
IGNhc2UuDQo+ID4gDQo+ID4gU28sIHRoaXMgY2FuIGJlIHNpbXBsZmllZCB0byBkcm9wIHRoZSBD
T1BZX01DX1BBR0VTX05PTl9QUkVFTVBUX0JBVENILg0KPiANCj4gQ2FuIHdlIHNpbXBsaWZ5IHRo
ZSB6ZXJvaW5nIHBhcnQgYXMgd2VsbD8NCg0KWWVzLCBJIHRoaW5rIHNvIHRoYXQgaXQgY2FuIGJl
IHNpbXBsaWZpZWQgc2ltaWxhcmx5LiBJJ2xsIGFkZCBhIFJGQyBwYXRjaA0Kb24gbmV4dCB2ZXJz
aW9uLg0KDQpUaGFua3MsDQpTaGl2YW5rDQo=


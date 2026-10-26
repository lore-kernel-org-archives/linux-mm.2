Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A61606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xcWWAAup
Received: by kanga.kvack.org (Postfix)
	id CC6226B05B2; Mon, 26 Oct 2026 07:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FE66B05B3; Mon, 26 Oct 2026 07:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0496B05B4; Mon, 26 Oct 2026 07:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 632AC6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:16:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC06F406DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:16:08 +0000 (UTC)
X-FDA: 85364523216.04.230111A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81C2140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:16:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xcWWAAup;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793013365;
	b=QG4WvJj1dsRj8BlfHuquB5GvkMtxkjCKGahraPa2CcdvS1XBW0mhKEIJHHepuwXC9MAA2U
	cLf68b1opMzQT+AzPgFIf3fpcTOIS2vBD77N0Z1ZjIcT0PJBvHpGmCu/FvTSfYhZoFFLYb
	/DcMTfi7a+ixgfJvqOi4G/HEU2XorPM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=xcWWAAup;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6M3HzjF6YR6KPZTEdvNwdLrkq68EX2UEzcqtPXcNpRE=;
	b=yypp4Jeq8fI4vOq+YTYHRskXVG9GYRMyBuAhPeaxmMjdbgOw7rH2vvwM07T86uuIJa2Uov
	jck8DV9DX5jt0RPnBIYNHLdMrqYaeZZYPebOgC62NaDMREFhkcGltxpxdTd73GjxO4q054
	VNVLmI5MzYpUNpVjC0ASsX3Y5oLaW8o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zCzLKmH2jWGRBaVh4Eiha8KJv6P5Vm3fFeiUAAs/k6O6XX25vUWypmU7PfEoxQmea0gjxUgorYXPg/5zqdt7bPMBGrX2ZD+oXcxcpyzUu0HHAoMj3kSmqbr6Y6SXZUYT/YF6zVuvnu43nlhnWyZSTRbVR9MS2L/m5CbB+NqR6YmVcfQA5EWoScyO2L2g0a8v/0nHWgpKkvpqeNZbe65cKNR88HuAa3S0V4hgLuVjfRqhj0gTb12WgNz99KHCTEvEITX9Rpxj2FWVILlYQeVRkt2tieaVzcNSO4fGPay+aGaa30/JGtoCUF9FtSoTIM0bfdXphFIPF4SDpwzW+hm8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6M3HzjF6YR6KPZTEdvNwdLrkq68EX2UEzcqtPXcNpRE=;
 b=eNuLPVGXeI/g39DgQ8Ax1BUZfW+Lugx4rU1CVSEPep+z1Rcu+Iv+WqUqk4QrzNBI7gOtfoTYCvpHfwQyhNjTNLYUXjUdmRQ8yGcSSYiv0Gu3a9rChYQ6wWufkMOdIuSHiImzwDpllzZOcaakBBo3ZnwmpKyIshKKscnYeDh4Ffht+sPEGsIctIzAdZqFup6QYS0q1Cf1z/Ow07QddUmevHTyNQjsOQWysEsBgY23PxqEr8ck5E1CIB87Zf7wQbByJJKniyFvS0GvxRgEr6Nenyz/P/fIG2VnKyY3PDtAoFNAUjVHcAv8cs0DcYq+bzioO0Hy+FvxtRAU9BpufiPhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6M3HzjF6YR6KPZTEdvNwdLrkq68EX2UEzcqtPXcNpRE=;
 b=xcWWAAupI4Uj1PBIcw2EI2hl3b6TmJMuFDnaSmxdnNQWFX3pxM2fo7SNik3xwCCeGu9r58c/nmtWvQBVZNnSoKcXOTObcMhvDPnr3tkXW2jTY9bqa3c/wZ8lLBg1UPlotOIZg5fGJu5CJfz0eb11yMcbTC/0gBIk0Hl1pb4O0zc=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DSVPR12MB827618.namprd12.prod.outlook.com (2603:10b6:8:3e5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 11:14:19 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 11:14:19 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"riel@surriel.com" <riel@surriel.com>, "david@kernel.org" <david@kernel.org>,
	"mhocko@suse.com" <mhocko@suse.com>, "roman.gushchin@linux.dev"
	<roman.gushchin@linux.dev>, "jack@suse.cz" <jack@suse.cz>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "weixugc@google.com"
	<weixugc@google.com>, "corbet@lwn.net" <corbet@lwn.net>, "liam@infradead.org"
	<liam@infradead.org>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"jannh@google.com" <jannh@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "glider@google.com" <glider@google.com>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"rppt@kernel.org" <rppt@kernel.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "dvyukov@google.com" <dvyukov@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"willy@infradead.org" <willy@infradead.org>, "surenb@google.com"
	<surenb@google.com>, "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
	"minchan@kernel.org" <minchan@kernel.org>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "hughd@google.com" <hughd@google.com>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>,
	"harry@kernel.org" <harry@kernel.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "elver@google.com" <elver@google.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "urezki@gmail.com" <urezki@gmail.com>
CC: "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "damon@lists.linux.dev"
	<damon@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 0/8] mm: remove unused functions
Thread-Topic: [PATCH 0/8] mm: remove unused functions
Thread-Index: AQHdZTUkz5Xtrc54UEuOjm7ik+VGGrcPoD8AgAALnoA=
Date: Mon, 26 Oct 2026 11:14:19 +0000
Message-ID: <d97a48a93c5d986a1a49f7ce361a6934148f277b.camel@amd.com>
References: <20261026-unused-sym-v1-0-82ca2dceabe1@amd.com>
	 <8da0110d-e05a-4559-a581-44a1fe28a41f@kernel.org>
In-Reply-To: <8da0110d-e05a-4559-a581-44a1fe28a41f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DSVPR12MB827618:EE_
x-ms-office365-filtering-correlation-id: 93a4e55e-0beb-4109-fff3-08df33524798
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|56012099006|22082099003|18002099003|11063799006|4143699003|921020|38070700021;
x-microsoft-antispam-message-info:
 UKEWiGXBsgwz80pSAsxITQuyW8Vs9UYJxPQI1r6Re3lNc9kSNkQcuUABkBhfkkD0GzJsAASuUGDQVn2rzAqC6cHILQuJD7fZb3ny4e1a9tubNc8N6HhBwIW0XR+pLPRjurZ9S045POt3uG86Rie/6D6fXEP5VMXFOWAFgdiay67mqtnW7CR4vbCNnYRFYcSGuTVJTAdjfwU1HiHebzYkYkittdyyL42qWK/zq9dk44EQDovlKLkxHYAXZ1q0bjxodSjONO3M4IrpDo5+JwowWm5unRXoJAQXxGjNGFRy37zxnXOtolUPzoGKjO33Me1ZvLRjgPccfpoOMfijDEGrG96w964oo6flYx0aCYCmeAziwtegTjejIXM9N5x0L2IpFzGS2g22ip6vWD9jeVhCKQDGBJeybKmSoTQmSioJFTHoOol8qNcW0EITn4MDVCfrhHo/vj4qW8QjNTFngdQNZQNXzv1u3zPY5ZhPK/SD5wzhJZ8Qk0LSv9OuNCH72RDdTo93q4vghpJhKNeNI6jYjb5Bhn/YblDwn+LsIKmQKFTbLA7vuk1Zm7qAjS4r5SChhsCzEqNkTQoT0wG3SiDgYTDHhpbwd9DnbjFNgNIFICCn91ih9Dju7HftAURV3tqA1pcauXP5GPAiQ9CCqOC2LhHi8T8ViXc+mvE2keIWl8clkKBCcQAXGdIBXJwgpHeq2rC1KdKXAqO8qemPw51DLiN6GHwiqQ0Mx+fevnrLE9POpAonxJtg2pbqNIOB9o00
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Qk5SMWtTTmpCOTJuUzFPZ0hGS04wWGcyTDU4OXBHSCtuOUJlOEZxNE1wc2ky?=
 =?utf-8?B?a1pNekd3Q010a2FqN2RyMlFmWVdzZG1FVFZ4cUthRkxQdENUN05ERlBCWHIz?=
 =?utf-8?B?WHZVMHVEc2x5Wk5aaVFLdFRpYzV5NFA5dkl0d3BYaWsybHRTTy9kamlhZHE1?=
 =?utf-8?B?dWUrblRnK1hlejlSMlM1dEI4c1BsK1B5NXJoZytFTVZ4ZlZmNXpROExMb3hQ?=
 =?utf-8?B?UGltQUlvNlRrWFd4QW0zSXRxdTd2VDU4RmJ3Rno2eVhNM243K29sclBtUStO?=
 =?utf-8?B?RlVheVRTN0ZsQmEzS1cyRStPRXFjaWI3dG9QY3JKblN1SjAvd2NzSGpoaFlk?=
 =?utf-8?B?cGVRaStTN3NhZUYvYmRtcXFQQndFbWtRWm9YdklrSHFoVy9yZVhiV3ZqL045?=
 =?utf-8?B?bGVzN2ZBZTA5ai9Ub3RnTThhRVlQOUQ0V1VNaklJV3F2Rmc3R1JQcWFWYlpR?=
 =?utf-8?B?SjFUQkwrOUplUndEK3o4QzdLSFFDbEhIc2FsNVUrQlNXZkZtYnE0M1VTTjE3?=
 =?utf-8?B?Mm4wanA2VUYycDhPeTRMSW1hQjQyU2RRZlVtWXFQZ2FvR2pZSEFDTGhvVll0?=
 =?utf-8?B?K1l3a2Jkd3NMWmx3MVRMbm0vekErNWs0TFJjK1c1YUZ4eWVpdXMydTBkMnZK?=
 =?utf-8?B?cFRKOGI4bHExQk9FZ2YyZXVCSXNQVVlCYUl2VDdjd0tQNG1Xa0RFUzI2Q2xh?=
 =?utf-8?B?VUp6QkF1RjZVYms0YTN0MVQ1dkt4Y3hPNTVKSWxGdE9NZTR1RDltaHRuOVdl?=
 =?utf-8?B?SHV0eTJ1dWRGUWlJUWJDOVpuNCtSZUtqZ0tlb0p6RWZlckNhai83ZnZFS0tn?=
 =?utf-8?B?eXpCQ1B2UjRpSDNWUU5rbGFqclBnYi8xTkNCU1VsSUVlQ2VBWHFlVlR0TDJ6?=
 =?utf-8?B?V0xkaEJSODJ6NEF5clR2azYwUVZvNEh1Y2kwbTVqbFJHektUblBReDZEMXha?=
 =?utf-8?B?citqYVRYV1EzVExaVm9GLzA0QVh2UVlCWm92Q1I1TlgycGx3VHZvU3h5ZlJ3?=
 =?utf-8?B?QVJ6ZVJyMmdIRzZsMGVza0pUY3oydElGYithMUtmNzkyNWdYTTcyUkdwUktG?=
 =?utf-8?B?eHNYeUtaMFNuTytWRHFveG15ZjIyaHVSV2xWTGNzbElPS0J1cGpZY0M0K0hH?=
 =?utf-8?B?L201aERKeHdmZGJuOGRTSmY2N3ZKcnVYejN5dC96SUtOZk1qcDNra2EyeVp5?=
 =?utf-8?B?eVNUNHltVzNDK3FEWGdOdk9tVGdqTm4yci93OUEzaUo3L2Z6U3U1T0s3V25F?=
 =?utf-8?B?WVcyUDMyejZHZ0ZQaHVoS09Cc0NrREl0R0wvdG12QVBRUTFtT1kvQ0pWVHMz?=
 =?utf-8?B?V2FMSHdXR3ZMZm9vZGF6dHRudFJiblk1bDFnaGhzQkVqRlY2ekRCTTRGVDF6?=
 =?utf-8?B?cE1PblpCbDNKVW1ZNTdLMjdnU3JkRDlja3FqcVNTR2pFTVYyK3BMaVVFYWhX?=
 =?utf-8?B?QmRyVndaTHdIODg0UlMvYzhmWTdJMU5VOEthRGpYaWI0eGU0eEFEVFB3QlZp?=
 =?utf-8?B?aUw5dmZSZ3g5em9DQTA5YjdkZU1UaHdLZG1IUjVybkc0MVBhVWViKzN6VHpG?=
 =?utf-8?B?ckFYVEpXcktvMlZnRWtyeVpoMTVubmpSMWd2dHR0QnhFNHlaaDVlaE1CaDdZ?=
 =?utf-8?B?c1B6RzlkTDM5akRHaDNEamV4Q0s0emswNXhSUlpwOWIyeXFPYllQTWdZVnRX?=
 =?utf-8?B?c25UbjYwbHlKVHRBUXVJWU94UmpRQzBtd2ZjbGFVYXoyamlkeVFpYU1ZRHEy?=
 =?utf-8?B?OVIrK21YRnIrSDJuVWs2L2VwYmtzTmtoeHc5WVhvMFovWG1HVTVFUnY1dDR4?=
 =?utf-8?B?UTBLZnZJNk1pMjNIV3NQUTNRcXdzNVA3ZGpnR21SQTJDVHdaUEhlUlF2YzdT?=
 =?utf-8?B?WFNnc0ZPMGxtd0hseWl3ZElzVWlsMzJEN0J4VnJXZjdlTU02eUFDM1FFRGNz?=
 =?utf-8?B?MjNoQzJiYllZODlVY0I4bURFT3l2WHZqdXh4OGVtNXFlWk8rVkJjOGlEZTNu?=
 =?utf-8?B?aXFhQkVHdVZxdktkOVloTlppdzg2dllnTXY5SVUwT3kyVFdRYkZuT3JEYmFJ?=
 =?utf-8?B?RE4wd1hqZklFa2s2Tjd2dkFuR1RDRjNadTZPdDVsUFRjN1NIaXJrSEN4blRE?=
 =?utf-8?B?WGlHOUxIZWtPcE5keTZNNlVacXFiUFpGdkdnTk9rdXZTVjFtMDVyRmxUajNr?=
 =?utf-8?B?Wkt1elFnVGxTU0pEamNvOFhvSlVnSHFEN2xrYVZwVXJGVGVZU1oySFpOeGFW?=
 =?utf-8?B?MGhHcUhSL0FCbHFEUWRaY2gyY0MxTzVjVWZGZ1RJY3NRWjlkZUVaRSt0WTE2?=
 =?utf-8?B?Z2xYTlZuY0VHSnBibW01TTJRc2RSaGNmNlFMSFpHSzZpTzMvdC9EQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BA3F2634ECCB14C808C17864BFEAC82@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a4e55e-0beb-4109-fff3-08df33524798
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 11:14:19.0618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihqgaT4W9/QvV9MlrXGeBmepYw6jQh5rNkRZIVzgLJITjHk1/FwE3DRX1YtXy2f/s1y/aGQjK5+ylRXVK76sEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB827618
X-Rspam-User: 
X-Rspamd-Queue-Id: 81C2140002
X-Stat-Signature: 7om5a66h5mycd5e7sk1ewjyfho4jyiu8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793013365-957489
X-HE-Meta: U2FsdGVkX18ggGkc+MqiAxhKLRSo31uzrDIOWhkFxa31QRyMV+zjQ4glvIn1kexwTz08w3Aje3WYLqWyNnfLzmBxLAu8pDLmzxJY8xauPhRglbvF8BfPAUcDDpgPerJn9sX9xdtf/MvmdF+zrFiYrcr1S0abZvlTa2QdcGcg07rkRlGGvR8Yz+fZ5xXXPIw9Ft8cF09OtdRnSWDVOcrVDh80j8xEEeAk9fzSjt2d08+eBrqZ5PrYrVsk+I2mD8Qdjyko090kh3xe0bmSZVquimyfnYOShSDaUg0D9pYOZ5Y7FKyVCBLFQQiQ2ECA6fmOFeO9re7nR2qP/gdTNWrROp9V0wTkjWcsHmbbADlx4817AXPgVoMTZQmSwog0We+Qydx5MGiJUUAIBFt0bTT+Gy7zzz9pOSvbJQXlYOal4uIvD0H0He1cgZKLPynkkXI9t/DSaSMqjHqcsIHco0iVUgx9hQxl5CQ8VHc5aBhKUjRWZLu5klSPKeXEm+CbnCBImjHxMI/pAZnCGKA2stLPCTVjg2FtffjsTG41y6q43JoBvzH+1lwdG6uY7ZP1w9hIPyGzwR5SEoTvNIqqskdlObtrFLiSJL2c/NRcKt32zLkWZjJNin0Fs22ota6Csusc2xBpeLf7ZYp3xB2r/LQ7x7b6TpH7T9F6bWQqbBMDljskY85ipd1mCPLcXKiNVMzsOnHFP3+Lrl3H32ofY9hZuCETvH29E0o0PZw8BoydM6QjWWGBzC9fUi2ScqlEHXkDv0KCIIPm1XlQMGOyBH6RIm/pRlcgk0WFLSQ1bTZ4UQsM5TOe5ktaeO6BA2ZTwPtz5/k5AAQpeJnJopP8fjS/4Vp7fVteKAefKXnBIQSw9RW11kP7cWc4tS57le80wMUUF/ymTpPSQ6oSip/lOFA0LqwmqUJibBsERuCyhtsBjkJbv3ZLywrux5V+BWG288G1vdq27+M5Tt9+lYNYFcS
 Kf1JVq2H
 dkbfYqTw4eqVfNyH5/RbpfjU7Zdo1/UWX7lZlnIqgtgRV7T+NhOV63s82FhVEg3WVDuj4xwh00IjvpFkiEWw+HQR0djYdMcynUouYZG8dc7fqUDN79cuE5NIJoWmPlsDkpp1TGdztHbGBPk6RpjeTMIxzN9EZ+GOPWtDznyjp0D/8qMru4L+BHxADBAJoJffdRu6hH7UH0kZYkofSspep4A+WCzMwK66U+NRCHMaqnZjRWBugjBX35u/mN2jQatMHqUJAki1Or/VhRye2kNjCl41+s3XQcsp87KF2TTwo05yG6VgIKGjlOzUlH06Y48VmHH5bin6J0YHGpiIrY1ue/YvaplbfR/Rm8W1VgLmGzv0uy2mNL5N+4vya5PxUa2vutf7c2ddjZSpVJHgNSoVhc6IZRABvUsr26u998cncpwpDrjYBBRKl92rOqgj5xAoE+jv0195cfc5YVqHIbwVkKJFV4L7QvdzzKp/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTEwLTI2IGF0IDExOjMyICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gMTAvMjYvMjYgMTE6MzAsIFNoaXZhbmsgR2FyZyB3cm90ZToNCj4gPiAN
Cg0KPiA+IFRoZSBzY3JpcHRzIGFuZCBhIGdlbmVyYXRlZCBIVE1MIHJlcG9ydCBhcmUgaGVyZSBb
MV0sIGlmIGFueW9uZSB3YW50cw0KPiA+IHRvIHBsYXkgd2l0aCB0aGVtOg0KPiA+IA0KPiANCj4g
QWZ0ZXIgdGhlIG1lcmdlIHdpbmRvdyBwbGVhc2UuIEZvY3VzIG9uIHJldmlld2luZyBmaXhlcyBv
biB0aGUgbGlzdC4NCg0KU3VyZS4gSSdsbCByZXNlbmQgYWZ0ZXIgcmMxLg0KDQpUaGFua3MsDQpT
aGl2YW5rDQo=


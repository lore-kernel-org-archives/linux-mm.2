Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE92AC561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC206B0092; Wed,  5 Aug 2026 15:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3BB6B0093; Wed,  5 Aug 2026 15:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A546C6B0095; Wed,  5 Aug 2026 15:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674136B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:55:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85BA580593
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:55:56 +0000 (UTC)
X-FDA: 85068271512.25.BE60036
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BF7710000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:55:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=RDGQxwOE;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf14.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=njTDX1l4CAMUN/iEQUDf+0M5RTBTQgWABYStuDaS7VY=;
	b=GJ2rlC+aHWg+un3vIwjrtxQsy/BCTF7Kv2cA94QUsZ4JOa7U3nUDDk7lY8zMERLURFg+5O
	LoTy3LCKJ63HksCPd2Ld3ZIU3d6USqy+5BCogqQruN0n/Xt/RSn1TiZ27wXr0FROs5jKS9
	LWAMj2Y8nyzQSj5Edx8YyNx5TVb/hOU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=RDGQxwOE;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf14.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785959753;
	b=xqo/mkWtEaYmlVZfNeXnYk7VIQLe5nL/DGObAYB8PnedzRpZHTUCvQhGK2gJx8gTbCPLq6
	GrKeUucQT2AgjHUULeQ8oFGCqtqYEjHIfGL5Et3NM8jCY5Cg8uvK1xlU7QKwH3PJ9bPBQx
	xXN+k/PSihAkm/vXbnFuiZT+hR/IBuc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1785959752; x=1817495752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=njTDX1l4CAMUN/iEQUDf+0M5RTBTQgWABYStuDaS7VY=;
  b=RDGQxwOEnn2YxHtWou57LRb4hviVqAa5McDb28Q54x2jnbLLgPJyqLFK
   IjKEp2V9JmSwVLlGmDQwOyrxQ6GcYQk2wnhPU5AoKA61AlHU/+caLHCck
   FCnfAO6+GJmsL2XC3S0W0IStoNHlsyhyEWLpgqt+sQW9GOPC7oWwQ0THx
   4r2OYPlF5Nyx37OAJmjfg2NoTfOa0f1WQKNwETS+lyS2o/noZF0BDYmQ9
   mHsB6YVzMJj+KtVfum4S4SbPQxqIQX2fMGJuF5LZkUx+aHc3x9TW4X9TM
   zRz2FdGdo2+YSILF0Pzjd/VcygivCShLLKaLPh66ojLyjRFG1tLMbIh3n
   A==;
X-CSE-ConnectionGUID: dJr9cmJqReS75e5DfuF/1w==
X-CSE-MsgGUID: fzKmzQ4wSomoJ7AkBdW2FQ==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="p7s'346?scan'346,208,346";a="17438940"
Content-Type: multipart/mixed; boundary="===============2525170940429881838=="
MIME-Version: 1.0
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 19:55:48 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:29786]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.0:2525] with esmtp (Farcaster)
 id 2fb6c594-df1c-439d-9767-69952b92e381; Wed, 5 Aug 2026 19:55:48 +0000 (UTC)
X-Farcaster-Flow-ID: 2fb6c594-df1c-439d-9767-69952b92e381
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:55:47 +0000
Received: from LO2P265CU024.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Wed, 5 Aug 2026 19:55:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1BqVgaDvHS9XbneNuHQcZfc8QEwjWNbYiFGVQ7wsWiIUvFiAa9vvZTuxXTlfdsDQD/FlMcZch3yYcHSQNljF46SNI7m1zio1TRHGdZZwlmgmJvuujSOOxc1BqQenGRgUCrjSlI6BVwTDGn7korls8qQxjkFx3OOPHEc5xY1SRLw4UbO3VY8HRfgGhGxxCXex/Jm+FsyLDPsnV3DmDvcoJMI56+NApONHaUY8w2VrC6NTeZdrei2sJGjOg4I/t/+uuK1OAbjscqa+2gHJBd7AGgVAfnFLsSeqA+vMJ/6Em7yWO9uj/Aj0ToEJu6qiFxQR9PR6zgyXFfIrze+UvF5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=bT3fymG17kWp32rRdkPivHdHo5QDE2woxfI3mm9HRIQ=;
 b=A2u0Rq/IG0FuGmr7WlDaZ30LRkm+N6yyPhIt5VNDy2vGC9Ce3TZQhgKp+x5ggU6PNZQm/n9aREMXMC/6jUCBVI5waaE/7wU+g6EA8fLgkLWHcghtY6hWHcOcxhq8MSvLiVdMsadraWyptt7lMxI4v46uPQ75oRRIxHI1ZzhlUlroM0RIy9cZVEFlxFtS2H2Mv1xB80Jyt01rz8BL+wEDYQbln7J7RT3Z4OOqta2vQ7tvQZP1gCgEkAc+AwHqpjppobyJHnt7PykP0wNB4PGV6H24IIAFV8UojL0uMbEIzJgeVjwBkY28mug7dETKtrIlAue4h3XWXUcgc25J1mB3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4b4::12)
 by LO3P123MB3417.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:55:43 +0000
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6]) by LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:55:43 +0000
From: "Woodhouse, David" <dwmw@amazon.co.uk>
To: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"will@kernel.org" <will@kernel.org>, "longman@redhat.com"
	<longman@redhat.com>, "boqun@kernel.org" <boqun@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "paul@xen.org" <paul@xen.org>,
	"Stollmaier, Carsten" <stollmc@amazon.de>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "mhocko@suse.com"
	<mhocko@suse.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>, "jglisse@redhat.com"
	<jglisse@redhat.com>, "david@kernel.org" <david@kernel.org>, "ljs@kernel.org"
	<ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/7] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Thread-Topic: [PATCH v3 2/7] mm/mmu_notifier: Remove non_block_start/end()
 from notifier invocation
Thread-Index: AQHdJRRl4fRVBAHJ5keGRxUdcdrlzw==
Date: Wed, 5 Aug 2026 19:55:43 +0000
Message-ID: <20260805195528.3853473-3-dwmw@amazon.co.uk>
References: <20260805195528.3853473-1-dwmw@amazon.co.uk>
In-Reply-To: <20260805195528.3853473-1-dwmw@amazon.co.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LOZP123MB8516:EE_|LO3P123MB3417:EE_
x-ms-office365-filtering-correlation-id: 56523a69-8d5d-48df-e66f-08def32b886d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|6049299003|7416014|23010399003|376014|366016|1800799024|38070700021|4053099003|6133799003|10067099003|11063799006|56012099006|5023799004|18002099003|22082099003;
x-microsoft-antispam-message-info: +ReZBZezTIucOLcL1rMqgrdvG6rhqGLrejv8hbkKxrBFG3aqMbYdAr0QCWuCm4ZvKQZCqTmeL7VwV1oD4xtNNQGLO5PGknmItxQ0PBjSjmDnBlXwgFrFdrXTeTZLlizxWKlmoJUKxFd6QOZG76dReiZcUBrK9uHfOKgDbBaUrcdvzOa7olGM4ivPmCp0woUV5MA89NBiQ2s9L/HcrjXmdZ0mxUM2gh3iBRBiCriHooHX1ADgTwGeG+NumA7iP+JKsPWQB5Jv5HxpTYvxtRunUdpjp1eBjzPmIu/1DmzyVf1IfTB1Yr0lj/h3xlhGj5JVD6e+mRu5lhFUoA7U2Yvr8DdiOYV2DaaEAgCchAfOqw0/HqXRTOT595W5N+5P8o5qX174t+S5Y0k6yDrYtu1dDnctc+foq2D/5/NkmXCke2PNaPBrHSFl9T0Jnfo5/62VOs3G6Gde8VGPFArTVLM/jJC0E3hxq3cdOjzs0e4ux4SbgMHDFytIPhQGIOs2CmC/aPVgwAu2vAIrrsvfNS/SLE28BdjiGAyg1BynVPnFsESrQX8UxHQDr3aPDNBYti+/kg17kRxQtv98DSfGt47qP3dbg2MD3hQpFILwYOaBUdbz31e7q9Gsux/LNJ7+AojhhMdL9OUAfwdpgDqc58kGw56xWM+czGsk84aGwmrA+ur+E4hDLc0jA2axFA9wevpzCHQrCBkGpYJZXsDUvH3xa9qTAitjZmoht+DmIHPwVn8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(6049299003)(7416014)(23010399003)(376014)(366016)(1800799024)(38070700021)(4053099003)(6133799003)(10067099003)(11063799006)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0dwWEVaTHhYcmgwOXdEUm1TTERGckxBOFhvUmZ2Z0ViR256YlZyM0NlNmxl?=
 =?utf-8?B?Z3pWVDFIRVVMOGlXNXg0c2JTVG1mcitpemtGbWtwakJPNXJFWWtNdkl0U2N4?=
 =?utf-8?B?YlNGZW5raWwzWWQzdHN4ekl4SzZLT2lnZ1RNMEk5TkdzV0ZqcUZNa0tLSUha?=
 =?utf-8?B?Y0Zqc0hBaVcwMTlHb1NERktiZHBxOEMzMGNnTjRFYUxMUS9kbjRtRG5UakdT?=
 =?utf-8?B?VS9IUWRyTHZPQ2pSSzVhTHU2Wm1BSUlXSTVJZFFidHJxL1BpSWlkZmtjRE1r?=
 =?utf-8?B?cEM5enVISXFKQ2IwQkVIblVQZHdDNXRDZXdTZElaMkhEVnp3aXk3VDVJaWtU?=
 =?utf-8?B?OEVyMHhzR2YveDdKOXVJVXV5MXdZVDFKb0Evek9KT1NwRGNxZFVuT3JQR3Br?=
 =?utf-8?B?SURkMzg0T3lzRUlaOHlkQi9HY0Rkem1qL1VzQ0VkQmRVU3RCbnQyWlpGMmY2?=
 =?utf-8?B?dHRSc2dGdmtMSnhXY2FtanBMRE9hQzNsbzF0aGZybElWakJqVVBGUHFiZVR1?=
 =?utf-8?B?V0ZGbE9lWjljaERGMGtoeGlvQzFmSFZlWEJ6UzZHSnVmK3V3aWpOWm9GWlkv?=
 =?utf-8?B?TzVWK2V3WThDejJPVDVYdWgwTWFDamQ4QjZKQzVEb04wT2R3U1hJMzdxWURL?=
 =?utf-8?B?b1QvQ3BMZHJIcXZrNEYzT0Nma0w2K3UyYjBDYUFyRE00cW1TWW5VdnVOaFRu?=
 =?utf-8?B?T2NKekorbjRtbTFHSUEwQ3B2YkVnMGFqT3cyd3BBcmR3dUVmczJDYS9GVXRV?=
 =?utf-8?B?WFBRQU93TElLOFd3YXdvYVR3WUpQV2t4NHI0cnRDN29DeWxMTlBGY1hIc3p1?=
 =?utf-8?B?MXlkSUZzdC91WTh6eUFTdDZ5SEE2STZCUVJ1SFYyKzhRVnNQM1dMQkxWdzFB?=
 =?utf-8?B?amMyZ2lQbmpHYlROOE1Ra3dVZ3JTZFpsVVVtU1ZjVElGMEZGS3lUeDdUSC95?=
 =?utf-8?B?TDhBVTQwaUpSblVjZTdXZER3TW02SkF3em1DeHFLbnV1clpLVWlqYUh2eEtk?=
 =?utf-8?B?Z1FoNVRMS2I0VlNVVGY1TGxuVmtjaFFidkU4bEJaR3JwTUpZMWE1cEJIdmhO?=
 =?utf-8?B?N1hYSng2elNTVGZ3UHdJTzJPNHdYenRsc0laSm9pY05tbVl4eGdHUEpBVm1Q?=
 =?utf-8?B?Q3VoN3ZPTGkrMW5adnRZeWVFMm1DRlcrN1VQbjA2SVVPYm9DYWVyaE00c2c2?=
 =?utf-8?B?OTV0VDNRSHc1TW5YbTdhTlozZmxDNjdYTjlKWEFHSWxPNE5zUXNSTllsdTRz?=
 =?utf-8?B?bGZ2L2QrRzN2bUxYSTdWbWdybkYzQm0wQlpydWlYY1NHWndnOWdRZzN3MWps?=
 =?utf-8?B?TG0yOGF3b1lFWXdZVWNhWHExNjNLVHRSRHpFQkdvbFAxbkdHOEZVN0ZlM2Mz?=
 =?utf-8?B?WHpnWFB6bU4yMVpVbEFLK1o2VkE2NTB5c2RJeWJleCtwaGhmdnczenFhZmhX?=
 =?utf-8?B?RDRKczc2SmYvOFQwVTBIOHR1aWpqbXp0S3lBTVpaTTV2OUxsTWNBZ2t5T0k0?=
 =?utf-8?B?bXBPYnhYY0VmdWZLV20vR2QweWlUQUQxdUkzSUhvUTdqOHNHOWdUVUhZRXA0?=
 =?utf-8?B?SkhsbEs2YTFaTHVkR1FkeUYrTXRXWUlxaVEyZ0Y4SzV5Uy9LTzM2MVZEN01l?=
 =?utf-8?B?NmI3aTJuTzA5TnM2azZFTFM1TmJtM2RNMHhHRGlvVDgxallaNCs1WU4zVzcx?=
 =?utf-8?B?TVhhakxtOEF4em9sYTJnbU9rbXRJMnNUUVdDeERsQWNXSHpPSER1WnMzOG1Y?=
 =?utf-8?B?K00ySmhYNDVOdXpSRDJUdVAxSTlyZkRsRGhPNFEwVlkrYUxVc1RPeTB2UGsx?=
 =?utf-8?B?aUZsTERQU0tFV2VPaTZkZ1hSSXg2MDk3SjJBckJ5UkdOZ2tjYXE5cUVPU2VH?=
 =?utf-8?B?NlpweG85WnBQZitUS01CdlJXOU02TmM5U1lzVUgxY1pyVVZhQld4RzFidzZV?=
 =?utf-8?B?T3ZLa29KNThycmR0ZFMzakd1UnFuRXlNTG1pcmdUcVozY1hUWlBHbTA4RVUv?=
 =?utf-8?B?YzRLbjFYYkthMjFmd3FQRCtBNEpqK0h0Z044T2tkdnBhcXJyRGI2RUpBV3kx?=
 =?utf-8?B?N21hTEtvYTlQSGNDK2FlUzhMZVJnTzJybW00aXNlUkVFRCtBTnp5N0JjVlNC?=
 =?utf-8?B?bzltSC9KU1NlOFlvUnByQ1RTWE9DV3diTE1SU3RiK08velpDSmNpQmRoUHZS?=
 =?utf-8?B?dEdtYm5UNC9UNjFTR3l2R2tDZk0zVWwvMkhkcFY1ZGVTbC9HdW5RbWFvQTFI?=
 =?utf-8?B?R0wvSU5Yd081QlVuNHl1eWIxcm9sanUrOEUzU0dRZ1l5MW5sMm1LWFlvM29m?=
 =?utf-8?Q?9CuXMmoiJJPNXMrcR0?=
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Qx98TTpSbkfvm/mfdOVsNSzMJNIennZjQxEViJJXPcPH6wbeul7biSBa9cEDhd4v3PZuUGD17uKfLPmppX7EA2TwNyND2B1JAwJT7Ja/6RtP4GNHYR4sr0454muMOC8ujs6gD6TZQ2NeRIkjPP9qA8iOeIzNnQmiV9Kqp8jVj6RPBOj/wYOBmsYAC29nK9vpqjWP0fDK8wp38qJ+XxDTaq2ijPdQwpRfNUJVoTHlGwuk5zrq3Crnjj9xv0jI7e1kef0WYby4fcaYHZ8m23bRURrkpYsGfty8pcdoxFvln7fwRte3PocgtYrZ2WUCQIzWfSjvXpj7RYznJSuPjAJC+A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 56523a69-8d5d-48df-e66f-08def32b886d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 19:55:43.0336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhVgbFydsx4YN+PgABxcRhXzXfUah51p1HXm+wC8NGrgUzKdFX3xqAhz4mLstPq+gy7x+NkVBU+p+EIH0u8GNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P123MB3417
X-OriginatorOrg: amazon.co.uk
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: tsjcda5wmfgcr3nxpufpb5chu1yejcdg
X-Rspamd-Queue-Id: 9BF7710000D
X-HE-Tag: 1785959752-220606
X-HE-Meta: U2FsdGVkX1+UopXzzGGXNwsEGX5jT5UAtlyf0gOmwCyL4z5qvWwwELTw8TKDA39P1RJe9T0rXxyUWiu+lI3wi7Mlcpi/G6ToJ02lIjPURSdYOWnrh28RfH31sNA5OFnZFROcmcNorzsQhz7ofXLEsNB+OKhiLyEQB7UiFFINj39Ze/kAj7xlfGIbbxqzsqBR2o5Xcuj8j1ygwLbEwnnJaCj2eTPA0fWi2hCbeBV7eXGxhLebrX50VpLHFZzerNTPNMpR1XBzts4ANgNE5UrwBx6HjX0zijk2K3HLqplRvgSNEiK1bysbkS+Vnkg9bRgKpfAOzquDBPD7UXh2Usj+QDk9mW7aSERxTo8t6F1gcMLRrCUgtGpZBx4icPNck/38ZkDfXsCgCLJYbowWCGpOGE7XLRTx1HTlfV+b77c71/PmuAppFS2euvzXRTS2fKwRdlCXWAiGCRSApfMZACy3n/lT6xYzIaQJXW+jQoqLchOIsyvL036W48dZqeRdX3L5apMl6pBytdn0X2l6cZbrYzAwmSD6+JZG+Yr1V1TQYXG4NftFkjOiys6SkQeZxtoxNDDyKQ7Nr5QZiQiA8Cgs1XWG9TSFH9NtTEfylVK5uVZK4xy04zzbbeJjYP5AC/rLaUf0MN338vPhRyHjPZ96W8BO9DK4hOqJi4nrqMA4sBm42E7RWeaxOS0Jin3tslmX9eN1C0jTKbJaNDWxpBL4ug5AMC87wraUtyNjlMBiLLSBL9IHCV+vILEfbIRy52dFnM7j384nCB+nHGwqIrfaMUKlCULKefJT9NUAChu1+yqSBhA50/CsfLE+Vd47Rkl5hfvH8+FmIieZ2AVnoE9xTmyxI/K87NLoBPE6gDEAwWd9un+lZ8rpyn+aLHM5VJ7Kmt+grNjnWItPspFmB/ZJIq0TO0GBs2qvheda9Eq9jS93kKy4KbpNspNFW3694xvQ70hEL4TaTChNFkEuFNS
 7gx0cxCW
 E596C5BLrT6V+Wdt7eBhJr2y+aMUpuxlEcaPnI00Z9G7mEtJVs4WAMTODqCZ25hn7A/zdEVq/dgt/K4EvO0v/ePUE7mTpjG6EpGDHF1aF2N7kAfuFRNmIFtnWm+fj71PstbZUsXSNRXuTM7VZad+sPyejBx62Yz7tj5tYCwB0odoqFJFWfFr0fzdGAE2haPBQKfDMlTgLoaob7ajb28kYR1yO2uhS9oiCRx3AiMooOsEXcZLRVPdJr3kq4oTJn28DK202GXnGMAN/6JbvWX78uK0wTuvL5pDbpjMkzDsOpQOQ3192VbIpxKlkFoCJsLVtMlMwDkFeImeaGr4bURkE2f0+jKz4HSZnnfgULh6dAam/P1TnpO+ELCGurDZ3ts1/kdrAJg8cY3L4X019DKUMaowvaSeauaj3typYKq4NQaewEQAMPxHrwxw4JF2eiH19YwawDENxZA1rf8A2ncACoidDK0UdLUXOj1iGRfxpL5RZT4UE80f7lzzkYWCTnzlgA/eVFMzIZ6p9caBVk+Q9qjAG0T87hGI13wbrvB03REAV8dDNHDoFDFNKvicXaFQ6HBE1Zyv7pfJGShgph3VxtzvGOchiWuE7rYBwyTswcedS1+FfwNVrK2EoIHuRgoeQTqtNFUbLEpCZ1gYbj5mmuICpnnanV4J9tEo1icSVsCMkTvxNOtwZpeO8rrNkRhk+dmn30jLLEKCjLwuN267wT33l/zvMkoVOySVT2bkMlmfxXdq9L007Z9vSxqzuQYqwNwHPCUaIX++6v2KeHvmZec5NfBBfcXRGb0IhqY+OZ2SsMaKrAmJ84UB3BPGDtUcfHJnybNqrMjgiMRHkeuUZAHwRX/PlEpr0diX3UYM6tfCCjauCiKPTou6CbvgZccTn21QUdqrmpXk7UkqKAMigTO/NtwMXxwHmSCFKEcbDJwCYUybIaOOx5bPk1OojK8SR2MoFdVAlNIaRdlI3fp1beIGVKKO2
 F/Mdic2Y
 4SfDzmk36SurO42VCrCwUby5gdGKSLmxN0fgo7PtV/mNT4IF/3v6N1FG2vtrORFTWC8Ws6mxulGmNl73kruCSLWMazJGm2EzPlmlZYwKf4JPpvXDyu5Y25rFcnQcgeRs5ipxs/ceesM8qHI4vycW/ns8sIKGk17VywckXnpJm599Mk0x4T2rlVoDk8c8toh/2CKhNhxahts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2525170940429881838==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha-256; boundary="----F3F7044912BB47D11515E6DE65EE77DA"

------F3F7044912BB47D11515E6DE65EE77DA
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This effectively reverts commit ba170f76b69d ("mm, notifier: Catch
sleeping/blocking for !blockable") for the mmu_notifier call sites.

The non_block_start/end() annotation causes the scheduler to complain
about *any* voluntary sleep in a non-blockable notifier. But that was
never the actual constraint. As Michal Hocko put it when the
annotation was first proposed, the OOM reaper "shouldn't depend on any
locks or sleepable conditionals" and checking for sleepable context
was "the best thing we could come up with that would describe these
demands at least partially". The real requirement is that the reaper
must not block on anything which may itself depend on memory
allocation (or on the dying mm) to make progress — which is why
spinning locks were always considered fine.

That distinction now matters in both directions:

 - On PREEMPT_RT, spinning locks become sleeping locks, and perfectly
   legitimate spinlock/rwlock usage in notifier implementations (e.g.
   KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) triggers the
   splat despite having no allocator dependency whatsoever.

 - A notifier implementation may legitimately need to wait for an RCU
   grace period before allowing the caller to proceed with unmapping
   (in the manner of a TLB shootdown, waiting for readers of a cached
   translation to drain). A grace period completes without any memory
   allocation and cannot deadlock against the reaper, but the
   annotation forbids it.

Checking for genuinely forbidden dependencies mechanically would
require tracking *what* is being waited on, which this annotation
never did. Remove it from the notifier invocation and leave the
constraint where it always really lived: in review and documentation
of the notifier implementations.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
 mm/mmu_notifier.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39f91..cd5d15cd646a 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -520,11 +520,7 @@ static int mn_hlist_invalidate_range_start(
 		if (ops->invalidate_range_start) {
 			int _ret;
 
-			if (!mmu_notifier_range_blockable(range))
-				non_block_start();
 			_ret = ops->invalidate_range_start(subscription, range);
-			if (!mmu_notifier_range_blockable(range))
-				non_block_end();
 			if (_ret) {
 				pr_info("%pS callback failed with %d in %sblockable context.\n",
 					ops->invalidate_range_start, _ret,
@@ -591,14 +587,9 @@ mn_hlist_invalidate_end(struct mmu_notifier_subscriptions *subscriptions,
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->invalidate_range_end) {
-			if (!mmu_notifier_range_blockable(range))
-				non_block_start();
+		if (subscription->ops->invalidate_range_end)
 			subscription->ops->invalidate_range_end(subscription,
 								range);
-			if (!mmu_notifier_range_blockable(range))
-				non_block_end();
-		}
 	}
 	srcu_read_unlock(&srcu, id);
 }
-- 
2.43.0


------F3F7044912BB47D11515E6DE65EE77DA
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MII+PgYJKoZIhvcNAQcCoII+LzCCPisCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gjpEMIIGEDCCA/igAwIBAgIQTZQsENQ74JQJxYEtOisGTzANBgkqhkiG9w0BAQwFADCBiDELMAkG
A1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYD
VQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
aWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5WjCBljELMAkG
A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0
aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMo87ZQKQf/e+Ua56NY75tqSvysQTqoavIK9viYcKSoq0s2cUIE/bZQu85eoZ9X140qO
TKl1HyLTJbazGl6nBEibivHbSuejQkq6uIgymiqvTcTlxZql19szfBxxo0Nm9l79L9S+TZNTEDyg
NfcXlkHKRhBhVFHdJDfqB6Mfi/Wlda43zYgo92yZOpCWjj2mz4tudN55/yE1+XvFnz5xsOFbme/S
oY9WAa39uJORHtbC0x7C7aYivToxuIkEQXaumf05Vcf4RgHs+Yd+mwSTManRy6XcCFJE6k/LHt3n
dD3sA3If/JBz6OX2ZebtQdHnKav7Azf+bAhudg7PkFOTuRMCAwEAAaOCAWQwggFgMB8GA1UdIwQY
MBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQJwPL8C9qU21/+K9+omULPyeCtADAO
BgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwu
dXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2Bggr
BgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1
c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNv
bTANBgkqhkiG9w0BAQwFAAOCAgEAQUR1AKs5whX13o6VbTJxaIwA3RfXehwQOJDI47G9FzGR87bj
grShfsbMIYdhqpFuSUKzPM1ZVPgNlT+9istp5UQNRsJiD4KLu+E2f102qxxvM3TEoGg65FWM89YN
5yFTvSB5PelcLGnCLwRfCX6iLPvGlh9j30lKzcT+mLO1NLGWMeK1w+vnKhav2VuQVHwpTf64ZNnX
UF8p+5JJpGtkUG/XfdJ5jR3YCq8H0OPZkNoVkDQ5CSSF8Co2AOlVEf32VBXglIrHQ3v9AAS0yPo4
Xl1FdXqGFe5TcDQSqXh3TbjugGnG+d9yZX3lB8bwc/Tn2FlIl7tPbDAL4jNdUNA7jGee+tAnTtlZ
6bFz+CsWmCIb6j6lDFqkXVsp+3KyLTZGXq6F2nnBtN4t5jO3ZIj2gpIKHAYNBAWLG2Q2fG7Bt2tP
C8BLC9WIM90gbMhAmtMGquITn/2fORdsNmaV3z/sPKuIn8DvdEhmWVfh0fyYeqxGlTw0RfwhBlak
dYYrkDmdWC+XszE19GUi8K8plBNKcIvyg2omAdebrMIHiAHAOiczxX/aS5ABRVrNUDcjfvp4hYbD
OO6qHcfzy/uY0fO5ssebmHQREJJA3PpSgdVnLernF6pthJrGkNDPeUI05svqw1o5A2HcNzLOpklh
NwZ+4uWYLcAi14ACHuVvJsmzNicwggXeMIIDxqADAgECAhAB/W0w/KPKUagbvGQONQMtMA0GCSqG
SIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxML
SmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNF
UlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xMDAyMDEwMDAwMDBaFw0zODAx
MTgyMzU5NTlaMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxML
SmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNF
UlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
ADCCAgoCggIBAIASZRc2DsPbCLPQrFcNdu3NJ9NMrVCDYeKqIE0JLWQJ3M6Jn8w9qez2z8Hc8dOx
1ns3KBErR9o5xrw6GbRfpr19naNjQrZ28qk7K5H44m/Q7BYgkAk+4uh0yRi0kdRiZNt/owbxiBhq
kCI8vP4T8IcUe/bkH47U5FHGEWdGCFHLhhRUP7wz/n5snP8WnRi9UY41pqdmyHJn2yFmsdSbeAPA
UDrozPDcvJ5M/q8FljUfV1q3/875PbcstvZU3cjnEjpNrkyKt1yatLcgPcp/IjSufjtoZgFE5wFO
RlObM2D3lL5TN5BzQ/Myw1Pv26r+dE5px2uMYJPexMcM3+EyrsyTO1F4lWeL7j1W/gzQaQ8bD/Ml
JmszbfduR/pzQ+V+DqVmsSl8MoRjVYnEDcGTVDAZE6zTfTen6106bDVc20HXEtqpSQvf2ICKCZNi
jrVmzyWIzYS4sT+kOQ/ZAp7rEkyVfPNrBaleFoPMuGfi6BOdzFuC00yz7Vv/3uVzrCM7LQC/NVV0
CUnYSVgaf5I25lGSDvMmfRxNF7zJ7EMm0L9BX0CpRET0medXh55QH1dUqD79dGMvsVBlCeZYQi5D
Gky08CVHWfoEHpPUJkZKUIGy3r54t/xnFeHJV4QeD2PW6WK61l9VLupcxigIBCU5uA4rqfJMlxwH
Pw1S9e3vL4IPAgMBAAGjQjBAMB0GA1UdDgQWBBRTeb9aqitKz1SA4dibwJ3ysgNmyzAOBgNVHQ8B
Af8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQwFAAOCAgEAXNR8Dc/3AX1BmWUM
c8VSn8v4z5kGfxvaQxWfngJVV5YU8VI8J4eUKO0fOgE3onb8U1DAhJvGa066jCFPoo5VYpHzaRXY
vIjjxKoL/e+o6UtVKgYgbVV4KRnuXzBcSyQRVf8kmm5eKivuC02ff/cBOJQUlUMHCftgqe4cqxKM
oJpep5hqWW2LPwj7yNFFrxgVZJASD3MoLsXiJE78WOzw9EX+IrPrL47S2UVhBcGXb6h2co+LjDav
vw0FznGN5qZvH2ymcWLF2NCDcgzxZxGJDJwTTHI037zVcd+qcd3huWyMPBJdZdq9VxK2Q2v/5d5N
ZhFRz5mu7Be26HGRjN5J/t01caIVJ5Qcz2HjJrtvo2clIV3m3R0LLmgbO4Kv7INnhdSYUXSxuZmA
if9/eBlceUpgLpJArkw3KizJx2LIDl33NlvK4CUlAbTdGgecdwA/0NzV7D3U+rs/zIXWb3+pLd+5
Avf1l5q1NdrDZ7CHSqkoniOO/1wna+GwT/MH7gAu1FmHy1JBler0R9fuZEFVfI1ZApXdYp3Cue5a
KHSEpZu3kMcMB9/1iTZ0MtYowbCwC+CcTMMc1vzjabVHRoEvooKr02NEcMSN/y0zuq2Pe7VwiK4+
Gc9AKNj8yJC7XZki9VLmWMUfiDFD7ogd18aOPENqHacY3n09FvFi+cqQqP0wggYQMIID+KADAgEC
AhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UE
CBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJV
U1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UE
CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
IExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
U2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyjztlApB/975
Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUfItMltrMaXqcESJuK
8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeWQcpGEGFUUd0kN+oH
ox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YBrf24k5Ee1sLTHsLt
piK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewDch/8kHPo5fZl5u1B
0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAUU3m/WqorSs9UgOHY
m8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1UdDwEB/wQEAwIBhjAS
BgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDARBgNVHSAE
CjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VT
RVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUFBwEBBGowaDA/Bggr
BgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUFkZFRydXN0Q0Eu
Y3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUA
A4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+xswhh2GqkW5JQrM8
zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9IHk96VwsacIvBF8J
fqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7kkmka2RQb9d90nmN
HdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1eoYV7lNwNBKpeHdN
uO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4KxaYIhvqPqUMWqRd
Wyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL1Ygz3SBsyECa0waq
4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQOZ1YL5ezMTX0ZSLw
rymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qodx/PL+5jR87myx5uY
dBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i5ZgtwCLXgAIe5W8m
ybM2JzCCBd4wggPGoAMCAQICEAH9bTD8o8pRqBu8ZA41Ay0wDQYJKoZIhvcNAQEMBQAwgYgxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwG
A1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5MB4XDTEwMDIwMTAwMDAwMFoXDTM4MDExODIzNTk1OVowgYgxCzAJ
BgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwG
A1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAgBJlFzYO
w9sIs9CsVw127c0n00ytUINh4qogTQktZAnczomfzD2p7PbPwdzx07HWezcoEStH2jnGvDoZtF+m
vX2do2NCtnbyqTsrkfjib9DsFiCQCT7i6HTJGLSR1GJk23+jBvGIGGqQIjy8/hPwhxR79uQfjtTk
UcYRZ0YIUcuGFFQ/vDP+fmyc/xadGL1RjjWmp2bIcmfbIWax1Jt4A8BQOujM8Ny8nkz+rwWWNR9X
Wrf/zvk9tyy29lTdyOcSOk2uTIq3XJq0tyA9yn8iNK5+O2hmAUTnAU5GU5szYPeUvlM3kHND8zLD
U+/bqv50TmnHa4xgk97Exwzf4TKuzJM7UXiVZ4vuPVb+DNBpDxsP8yUmazNt925H+nND5X4OpWax
KXwyhGNVicQNwZNUMBkTrNN9N6frXTpsNVzbQdcS2qlJC9/YgIoJk2KOtWbPJYjNhLixP6Q5D9kC
nusSTJV882sFqV4Wg8y4Z+LoE53MW4LTTLPtW//e5XOsIzstAL81VXQJSdhJWBp/kjbmUZIO8yZ9
HE0XvMnsQybQv0FfQKlERPSZ51eHnlAfV1SoPv10Yy+xUGUJ5lhCLkMaTLTwJUdZ+gQek9QmRkpQ
gbLevni3/GcV4clXhB4PY9bpYrrWX1Uu6lzGKAgEJTm4Diup8kyXHAc/DVL17e8vgg8CAwEAAaNC
MEAwHQYDVR0OBBYEFFN5v1qqK0rPVIDh2JvAnfKyA2bLMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB
Af8EBTADAQH/MA0GCSqGSIb3DQEBDAUAA4ICAQBc1HwNz/cBfUGZZQxzxVKfy/jPmQZ/G9pDFZ+e
AlVXlhTxUjwnh5Qo7R86ATeidvxTUMCEm8ZrTrqMIU+ijlVikfNpFdi8iOPEqgv976jpS1UqBiBt
VXgpGe5fMFxLJBFV/ySabl4qK+4LTZ9/9wE4lBSVQwcJ+2Cp7hyrEoygml6nmGpZbYs/CPvI0UWv
GBVkkBIPcyguxeIkTvxY7PD0Rf4is+svjtLZRWEFwZdvqHZyj4uMNq+/DQXOcY3mpm8fbKZxYsXY
0INyDPFnEYkMnBNMcjTfvNVx36px3eG5bIw8El1l2r1XErZDa//l3k1mEVHPma7sF7bocZGM3kn+
3TVxohUnlBzPYeMmu2+jZyUhXebdHQsuaBs7gq/sg2eF1JhRdLG5mYCJ/394GVx5SmAukkCuTDcq
LMnHYsgOXfc2W8rgJSUBtN0aB5x3AD/Q3NXsPdT6uz/MhdZvf6kt37kC9/WXmrU12sNnsIdKqSie
I47/XCdr4bBP8wfuAC7UWYfLUkGV6vRH1+5kQVV8jVkCld1incK57loodISlm7eQxwwH3/WJNnQy
1ijBsLAL4JxMwxzW/ONptUdGgS+igqvTY0RwxI3/LTO6rY97tXCIrj4Zz0Ao2PzIkLtdmSL1UuZY
xR+IMUPuiB3Xxo48Q2odpxjefT0W8WL5ypCo/TCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2bin
UlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNo
ZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoX
DTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0
ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQD
EzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg
0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJG
NcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcfWlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQK
iz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqzaaPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHv
bRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDKCMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsU
tQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAUu69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYE
FIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEA
MBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMw
OwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0Eu
Y3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQAD
ggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u
/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK
8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDMKVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCW
gWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm
0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfHM5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b
3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDD
AI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1tyZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpN
SCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4ognzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof0
6r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAbR9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZH
ynoSMIIF2DCCA8CgAwIBAgIQTKr5yttjb+Af907YWwOGnTANBgkqhkiG9w0BAQwFADCBhTELMAkG
A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEa
MBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkwHhcNMTAwMTE5MDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBhTELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCR6FSS0gpWsawNJN3F
z0RndJkrN6N9I3AAcbxT38T6KhKPS38QVr2fcHK3YX/JSw8Xpz3jsARh7v8Rl8f0hj4K+j5c+ZPm
NHrZFGvnnLOFoIJ6dq9xkNfs/Q36nGz637CC9BR++b7Epi9Pf5l/tfxnQ3K9DADWietrLNPtj5gc
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
TU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEF
BQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAeFyy
gSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+jsQgwRGiHjZrAYayZrrm78hOx7aEpk
fNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD7f3iT7PdkHJY9B51csvU50rxpEg1OyOT
8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOd
GCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurf
fade2022O/tUU1gb4jfWCcyvB8czm12FgX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZ
ojTq/OCR6MvnzS6X72HP0PRLRTiOSEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo
9jzJ16HO5m60ttl1Enk8MQkz/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8ao
rYew6CQvdVifC3HtwlSam9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zm
EVDNXFnHn9tFpMpOUvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIwggXY
MIIDwKADAgECAhBMqvnK22Nv4B/3TthbA4adMA0GCSqGSIb3DQEBDAUAMIGFMQswCQYDVQQGEwJH
QjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQK
ExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1
dGhvcml0eTAeFw0xMDAxMTkwMDAwMDBaFw0zODAxMTgyMzU5NTlaMIGFMQswCQYDVQQGEwJHQjEb
MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhv
cml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJHoVJLSClaxrA0k3cXPRGd0mSs3
o30jcABxvFPfxPoqEo9LfxBWvZ9wcrdhf8lLDxenPeOwBGHu/xGXx/SGPgr6Plz5k+Y0etkUa+ec
s4Wggnp2r3GQ1+z9DfqcbPrfsIL0FH75vsSmL09/mX+1/GdDcr0MANaJ62ss0+2PmBwUq37l4278
2KjkkiTaQ2tiuFX96sG8bLaL8w6NmuSbbGmZ+HhIMEXVreENPEVg/DKWUSe8Z8PKLrZr6kbHxyCg
sR9l3kgIuqROqfKDRjeE6+jMgUhDZ05yKptcvUwbKIpcInu0q5jZ7uBRg8MJRk5tPpn6lRfafDNX
QTyNUe0LtlyvLGMa31fIP7zpXcSbr0WZ4qNaJLS6qVY9z2+q/0lYvvCo//S4rek3+7q49As6+ehD
Qh6J2ITLE/HZu+GJYLiMKFasFB2cCudx688O3T2plqFIvTz3r7UNIkzAEYHsVjv206LiW7eyBCJS
lYCTaeiOTGXxkQMtcHQC6otnFSlpUgK7199QalVGv6CjKGF/cNDDoqosIapHziicBkV2v4IYJ7TV
rrTLUOZr9EyGcTDppt8WhuDY/0Dd+9BCiH+jMzouXB5BEYFjzhhxayvspoq3MVw6akfgw3lZ1iAa
r/JqmKpyvFdK0kuduxD8sExB5e0dPV4onZzMv7NR2qdH5YRTAgMBAAGjQjBAMB0GA1UdDgQWBBS7
r34CPfqm8TyEjq3uOJjs2TIy1DAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQwFAAOCAgEACvHVRoS3rlG7bLJNQRQAk0ycy+XAVM+gJY4C+f2wog31IJg8Ey2sVqKw
1n4Rkukuup4umnKxvRlEbGE1opq0FhJpWozh1z6kGugvA/SuYR0QGyqki3rF/gWm4cDWyP6ero8r
uj2Z+NhzCVhGbqac9Ncn05XaN4NyHNNz4KJHmQM4XdVJeQApHMfsmyAcByRpV3iyOfw6hKC1nHyN
vy6TYie3OdoXGK69PAlo/4SbPNXWCwPjV54U99HrT8i9hyO3tklDeYVcuuuSC6HG6GioTBaxGpkK
6FMskruhCRh1DGWoe8sjtxrCKIXDG//QK2LvpHsJkZhnjBQBzWgGamMhdQOAiIpugcaF8qmkLef0
pSQQR4PKzfSNeVixBpvnGirZnQHXlH3tA0rK8NvoqQE+9VaZyR6OST275Qm54E9Jkj0WgkDMzFnG
5jrtEi5pPGyVsf2qHXt/hr4eDjJG+/sTj3V/TItLRmP+ADRAcMHDuaHdpnDiBLNBvOmAkepknHrh
IgOpnG5vDmVPbIeHXvNuoPl1pZtA6FOyJ51KucB3IY3/h/LevIzvF9+3SQvR8m4wCxoOTnbtEfz1
6Vayfb/HbQqTjKXQwLYdvjpOlKLXbmwLwop8+iDzxOTlzQ2oy5GSsXyF7LUUaWYOgufNzsgtplF/
IcE1U4UGSl2frbsbX3QwggSvMIIDl6ADAgECAhEA4CPLFRKDU4mtYW56VGdrITANBgkqhkiG9w0B
AQsFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRy
dXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBS
b290MB4XDTE0MTIyMjAwMDAwMFoXDTIwMDUzMDEwNDgzOFowgZsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9E
TyBDQSBMaW1pdGVkMUEwPwYDVQQDEzhDT01PRE8gU0hBLTI1NiBDbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAImx
Ddp6UxlOcFIdvFamBia3uEngludRq/HwWhNJFaO0jBtgvHpRQqd5jKQi3xdhTpHVdiMKFNNKAn+2
HQmAbqUEPdm6uxb+oYepLkNSQxZ8rzJQyKZPWukI2M+TJZx7iOgwZOak+FaA/SokFDMXmaxE5WmL
o0YGS8Iz1OlAnwawsayTQLm1CJM6nCpToxDbPSBhPFUDjtlOdiUCISn6o3xxdk/u4V+B6ftUgNvD
ezVSt4TeIj0sMC0xf1m9UjewM2ktQ+v61qXxl3dnUYzZ7ifrvKUHOHaMpKk4/9+M9QOsSb7K93OZ
Og8yq5yVOhM9DkY6V3RhUL7GQD/L5OKfoiECAwEAAaOCARcwggETMB8GA1UdIwQYMBaAFK29mHo0
tCb3+sQmVO8DveAky1QaMB0GA1UdDgQWBBSSYWuC4aKgqk/sZ/HCo/e0gADB7DAOBgNVHQ8BAf8E
BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQw
EQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0
LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUH
MAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQELBQADggEBABsqbqxVwTqr
iMXY7c1V86prYSvACRAjmQ/FZmpvsfW0tXdeDwJhAN99Bf4Ss6SAgAD8+x1banICCkG8BbrBWNUm
wurVTYT7/oKYz1gb4yJjnFL4uwU2q31Ypd6rO2Pl2tVz7+zg+3vio//wQiOcyraNTT7kSxgDsqgt
1Ni7QkuQaYUQ26Y3NOh74AEQpZzKOsefT4g0bopl0BqKu6ncyso20fT8wmQpNa/WsadxEdIDQ7GP
PprsnjJT9HaSyoY0B7ksyuYcStiZDcGG4pCS+1pCaiMhEOllx/XVu37qjIUgAmLq0ToHLFnFmTPy
OInltukWeh95FPZKEBom+nyK+5swggYVMIIE/aADAgECAhBUK7v3iZFOwcXku0+rFipmMA0GCSqG
SIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3Rp
Z28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTI0MTIx
NTAwMDAwMFoXDTI2MTIxNTIzNTk1OVowIjEgMB4GCSqGSIb3DQEJARYRZHdtd0BhbWF6b24uY28u
dWswggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYY7Ok+LSdJXMOPurGsBJ9haMJobp1
AbJ0lXHAfmgO7N2XfT2VeOglOqYQJQlqSpNchVXA9UZ3OLsde6OC21IBV4iqzkUtI4hf+TmtK1xt
xSEhtV3Y7fKDyiKvvWdbNnuyKYuVlo+ABv8ZZB/2DDHLS/TvAgkR0q4YgoWxP4Eee8fTwJ7eWnmW
dmFs2hjjnnHmmXvrurxwhyE0ZpJ0gJwF/2jaDSTbEAhnH6xPN8vYh5j/ARa0kWamowSpSqvLciXe
RZ0sDx95ElHEJRzsIiHwkRVz+K6V0me5yjhGa90lx9OgA2PYGba0qcAW7sylgzxljEbkZ8/KII/2
Og3lONswf2QCIuW9Ac1n+LtKwREA+cbaTgsWB3Np10GhUlrt+pD9SWjahJROdTkPdhMlSn1tzeqm
XCoga1Yo12NhLUfv+VvYsURZxLOJyHm/eEn/dlDBHhvXsNslb3GF1zT2onBp65BEjQtff2vGF8UB
GX65gXgD0/b4kCYZ9zvrA+KT9ErN0o1WXOhDu736D9O27dp/WBNPF0j5MXMm9Sf+Lf/gLJJCnmBQ
RnaY4MXfoixcY0sAcrWbod/uw7h1H4PO+lgOOInkA64R0o7r7gGdVm/FlLK6c63C6GI6hZm/23+v
8sqMZbd9ZnYDwvhS3PmLtQUMFwtyTG672xQVU7Z+V9hCgwIDAQABo4IB0DCCAcwwHwYDVR0jBBgw
FoAUCcDy/AvalNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFFr7QNV7ElfMY4HxUC/w1EzSGybuMA4G
A1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMEMFAGA1UdIARJ
MEcwOgYMKwYBBAGyMQECAQoCMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vc2VjdGlnby5jb20vU01J
TUVDUFMwCQYHZ4EMAQUBAzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLnNlY3RpZ28uY29t
L1NlY3RpZ29SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGKBggr
BgEFBQcBAQR+MHwwVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JT
QUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwIwYIKwYBBQUHMAGGF2h0
dHA6Ly9vY3NwLnNlY3RpZ28uY29tMBwGA1UdEQQVMBOBEWR3bXdAYW1hem9uLmNvLnVrMA0GCSqG
SIb3DQEBCwUAA4IBAQBA+k/q3z9lz3S3x6AneZ9YhiHGGrlnzx0XWTdk8O2uzRFyJJtsmTYszkqa
dzazIljgTdd14Kp2C7KnacSYW48CnMyl+dP6n4YZDh7a0NBkZLnMmyuOOwGrpfNHGU/E91hvVPXY
ZdwrfzLsigVkINzGJW1E+ruJAvT5PK3fnEdeLbWEVFgyk0tgay+3vI6TZrQqBGpA5DGODK6aDMDN
X+ADVamfHJw57cF6uaK5mSJLDdg6sbCi5qxclQDjYakkk+9iJgXyFVoRUUwhfbU3COcBP9EpJduR
WZkrAQdi1IHnICuzGcsPQ6P29LGEvvGJgP7o1AqjW9HzyQRPwfbwaJobMYIDvjCCA7oCAQEwgasw
gZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1Nh
bGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEFQru/eJkU7BxeS7T6sWKmYw
DQYJYIZIAWUDBAIBBQCggeQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjYwODA1MTk1NTQ5WjAvBgkqhkiG9w0BCQQxIgQg4QdgwQtSAJTIhI0UGAhoQbr04cS5MtfO
Cir5eX98kuAweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggIALS405sC2D7dwNzUrldV73kXbTCET
2uNJcnqTrhlc9uZvfDyyGTn7f+JycmmHpbJAdy0H4+Id5DBwWruBPIm9L7a7ExE8NtykNhAEKABx
B20adb75mesYoR8k1ZXxfGam9fzLKzvgWAwzLFWp5iCmHGjtxYCO2kQhZmsX5Cq2hWR5TcStlqSz
EGhvIW/rJpPpv1fGio4caQlc7lEyGsL5OAp+APXx/hhDKaPTdC6XSrxBXc9E/7nZQP+//82d5T8I
NSncvx8MvH6NfLMWRk0PiDrZDLHx9HkO8i8AdVjUULC6OnHV1Bnm17ZrRrxwg/SwXSSOJ2pTDeZ8
Nh7/UlkSYzuQSSOd8YHz9Q9DwFzwVCQmmCF+oQG2DDGabCBcmXpdcq44DOqJ5FoQZ9iHOLz73LkZ
i2wvpHj4DRsbSk24m3m3cn73pq5J4oC6TLlGpVs7K8gehGIOJMHUZ6fGq1jHZj7Ko19+9JJ/kR5t
AqScl0+HkvSlu2t8oy7qP0e0WDUIz2OA+AhS+0AcGVjonOUnu/8nw4HQd+80klDakE4gargiul1l
XVyWiM1CYQHGWDpHWgnxxSeagVB5xz988an9jTleADiL2jPzmcHsidcvUDWV6YQSycdPL67CMczL
CdByFtfP6VP3kCDPp9mJLwiPJ0podxsvwxNoOzwo3EqsNpA=

------F3F7044912BB47D11515E6DE65EE77DA--

--===============2525170940429881838==
Content-Type: multipart/alternative; boundary="===============3309014326949955468=="
MIME-Version: 1.0
Content-Disposition: inline

--===============3309014326949955468==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============3309014326949955468==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============3309014326949955468==--
--===============2525170940429881838==--


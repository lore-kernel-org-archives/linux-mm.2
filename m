Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF0F103E174
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 13:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D266B01F9; Wed, 18 Mar 2026 09:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E796B01FB; Wed, 18 Mar 2026 09:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE696B01FC; Wed, 18 Mar 2026 09:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32D8C6B01F9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:08:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE275140731
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:08:57 +0000 (UTC)
X-FDA: 84559213914.19.F86EE4A
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC3ABC0006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:08:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=cWXHh7rg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=softfail (imf10.hostedemail.com: 67.231.149.131 is neither permitted nor denied by domain of mboone@akamai.com) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773839334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL6OEc+80G344PEa6NS7XY6voMuLdYc2h3te91Du49M=;
	b=dx7v+uFi2VQBGT2SIiYuu3RqSLWKkJVuBwIjyfJhgy3yZxjVmoFApPLH3TL/Pv8Ym7IvVb
	pkrA1ywiIC1n8guSbevsgHudZaXxpSWgfKHthbOTXVABVPXi/SMz1m7nGNhCuLepR4pXH1
	BiKN/aCLaRtoiDisoUTFNKEK0pKccuI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773839334; a=rsa-sha256;
	cv=fail;
	b=AGGGmqPDmDs4+wygAuQ1+msmBiWKGOf3Nu7RsxOTBKHZMjiPbGve9nzhyEWUgGtQoyVeGb
	bdbLWhRyCY6PefdvZAlvowFymT+tUQPkCJRg72/o+ICkQZnLMZ7YgwgxevtjoQp5Qgmvac
	8HtaGHMYL8Fx8bGrPg/x+9FO4IeDjdE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=cWXHh7rg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=softfail (imf10.hostedemail.com: 67.231.149.131 is neither permitted nor denied by domain of mboone@akamai.com) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
Received: from pps.filterd (m0409409.ppops.net [127.0.0.1])
	by m0409409.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 62IADXnG2513977;
	Wed, 18 Mar 2026 13:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=TL6OEc+80G344PEa6NS7XY
	6voMuLdYc2h3te91Du49M=; b=cWXHh7rgjWduEz23K7OzFWu1W3DH9Nq2tS3y5m
	KkhCUtSfvdvpko/aYvTe8qKTsjA/5K/ulOt3Mng/jEJHt3zaDZ35HiKQ98LmelZ8
	VJF+sPbdhHmpTrQnUmF94r1UfKxFuAK4H11RW3NkL+0gcT2TOiPSD+d/6FP6ULyI
	J1TDTGhpl79C9ugiIRs5D/HOve0QvaDqaRb+OuIlGl8+3pB1MJP0jUOvFDnlpG3G
	CBzsv/XwEPbhZs1W2bY4gG9Q/A0F104QntTjGej7bLUE28TDzbSuUWGns2/s//os
	7+PvU0gSJyZKSsXc04CuSRxgHW8lVhC1AsHpfPgBR7b7dQYg==
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
	by m0409409.ppops.net-00190b01. (PPS) with ESMTPS id 4cwhvrpyhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 13:08:37 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
	by prod-mail-ppoint7.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 62ID48js001344;
	Wed, 18 Mar 2026 09:08:36 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.201])
	by prod-mail-ppoint7.akamai.com (PPS) with ESMTPS id 4cw30wsd3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 09:08:36 -0400 (EDT)
Received: from ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) by
 ustx2ex-dag4mb2.msg.corp.akamai.com (172.27.50.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 18 Mar 2026 06:08:35 -0700
Received: from CO1PR08CU001.outbound.protection.outlook.com (72.247.45.132) by
 ustx2ex-exedge3.msg.corp.akamai.com (172.27.50.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 18 Mar 2026 08:08:35 -0500
Received: from CH2PR17MB3797.namprd17.prod.outlook.com (2603:10b6:610:80::18)
 by DM4PR17MB6905.namprd17.prod.outlook.com (2603:10b6:8:183::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 13:08:33 +0000
Received: from CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2]) by CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 13:08:33 +0000
From: "Boone, Max" <mboone@akamai.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Vlastimil
 Babka" <vbabka@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Suren
 Baghdasaryan" <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
Thread-Topic: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
Thread-Index: AQHcthbQ53vDINHPrkGROmzcGUn1MrW0QNWAgAADlIA=
Date: Wed, 18 Mar 2026 13:08:33 +0000
Message-ID: <719CB417-F511-402A-91E3-8A696ABCE0D5@akamai.com>
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
 <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
In-Reply-To: <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR17MB3797:EE_|DM4PR17MB6905:EE_
x-ms-office365-filtering-correlation-id: b7951590-0a77-4a30-fcba-08de84ef7546
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|6049299003|4053099003|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: iW0FeLWkHmB9V0hP79Umkm4zClSyp/MHut5RbYslq28KZA2ozcv5yUg8laYwy+UoneCT1ZRoKPU+Ru/NS+RA3KK5qSbfPWp4+zvL8X5vHAGTH9H1ufnTAGodbN2+VU4XzgRSRivqtQG4WMvyKOljv56BZ13PuC67YvOypU0P+bh8U5uXAgyQUmj2jlLror04cOIId30PZawzY/7XMQcZs9BDwG7u26yZyOaG159EdhDpoBeEnYbVHfLmtOm25zRlvvsdQ/RO/gSYp1Glj6cjAoBVpNiDhUl2lZ9fAe+ub1mBBrJ7cai9Ym9e9B5PaHugYK7Kh+011wXqVQbVLR9C53sHOWo6LIwtQzoRcX0R2iQcaihDPqGZ/iu+ORRdkV91iJ7VgOdA/ET9vWJV61H/j8LPOwEGc7lIAHFoXy3Ww2pqLI/2PAIrDmkGM9buCg+DMwz7vhrh65gUA11GJeI9b0v22Nt16hxF9aDrs+yg2/CmiJFN/nx7u2odkNDOzgx6+gvm+9hNf0uLQW+wSE81brzWDbOMkwpgKxEtNERTUKi8vUQZhcJ+20+ME2OU2NucltN324HBDevKFTLPIZ6uHgIcmGVtYpyTFDlJLrofGjC7XrI2NXyz+v2xOrzu2j31ahfkmEktX/gRaZ/7lCPEXpwSUBd9oJe8XTHdQx0xpVJGFSqK0nDL+fQ5mS5efVngHpBd6e4HhebJexS8GYqY1K2OMF99VWki985VaDG5KVWPx/cse7eDHXNqelZcAEpoRVwOd0OrFC4vkT0+QCCGHv6dM0GHTkbLcPUwgy+I6Bc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3797.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(6049299003)(4053099003)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmR0UXdiUnlNUzN3V1poaEp5NVZvWlJTTTZva244bmJsaU53S3BnM0s1ekdj?=
 =?utf-8?B?c2lUeVQ5bnNJUUFJdTNoaGJUM1A3U1VlMUZHYjVaUXdpSkE4SXJqdUxibldM?=
 =?utf-8?B?TE8vdmc2b0syYWVCL0RnY0IvTU9iODVmbmRJWG53VVovOCt1Y2UzMXRkSjFI?=
 =?utf-8?B?UENROEl2OGJMdHJlZHFsdlVSVldtSVZ2NHdTQTJNY09ONGkwZkxvRS90d1hO?=
 =?utf-8?B?QkxOSzRsVEoxdXJMcStSS3pzbzRxd25jUk9SWWdETmFLTVdhQXc4SVU5cUpq?=
 =?utf-8?B?aUFycmtnTXZUV2d0cjEvSU5MaFRnNk5obS9JV2toNHJHdFhjaEo4aUhCRHlQ?=
 =?utf-8?B?UGJja3puYnVvSndCeTBtRUFnV3BpYnlEQXFCbUZ3dlZqMmZQMW9tVzNVeDFW?=
 =?utf-8?B?S2VpeWJ4clR0VzRzMGZmamhMeEVTa29aQVFtQlJ6OWRBNjVCYUl4cWVnZUlM?=
 =?utf-8?B?ajFPZHBWZnRwS25vbHhsWVdtVmJnbzF2NE4yWDBBUTFHVVNuczlkaXdPd1Fv?=
 =?utf-8?B?RmFielFyRTRmU0lybHN5RWJRZXp1VVNuN2JiM21yRU8wa0NiazNRZHhkNWhQ?=
 =?utf-8?B?TXVGcmY0bUVPSlR2QXJuZnFPWXBiRkdtL0NsM1VBTTJSNkEwdW5CcUNjSUEy?=
 =?utf-8?B?dysrQkxDZUt4Rm84a0ppNXpvWVJVS0ZjREJpQ09jcnUrQjN5d0xvaUdtdHJk?=
 =?utf-8?B?cG93VndQOTJiNFdCSlJkblgzOGJoTFV2Rmp3RzhMVmZpZ1U5cUVvWVJuWkZN?=
 =?utf-8?B?S0s5UFhTZnlRWTJzeEkvWlo2aTZBRUFuaTIvN3hLaUpRQUtJZHZKaDhHZ1Zz?=
 =?utf-8?B?U0RkVjNqQ3hZQ2o3YlkwaXpoOVZRQXgwY21nb09zbFVaZG5xQnFSeWdSSStC?=
 =?utf-8?B?d2VVYTJaVmYrSHVIcFlFN2NIZ3RseTZmaDE4NTRTVjhrTklVWmoyUzZMc1VP?=
 =?utf-8?B?bG9oVHAzbGdNQzBzNWNTY3JMcHE4ZEkvQzB4TEJHL3ZaanYzQ2pZZHNVWE4r?=
 =?utf-8?B?eitrdHpRZUhxVVFYTUFPOGsvYWMxcUpSM09BTWJhZC9lZVN2SjMyTVpXbUhF?=
 =?utf-8?B?R0x4OGlsU3JNczE2OGNOMEliUUxNWXlIZlBvZ2hldnBuMDNOWFFuaDhIY3Rz?=
 =?utf-8?B?OTloRVBIUlhUUG5SOGxuMmRTekpwaXNNQUh5VmpWL1Vkdy9qejlqSS9oNVRH?=
 =?utf-8?B?MDBXczNuNDd6bFJoRmRGM0FsVS8wMGlkQ1hRVFJONE84WlhwSFNUcTFxQytB?=
 =?utf-8?B?aWxPTkJBdURWSlpMZktJWXVFa2EwZVllVmhQNklxVkJHcUxCUWlnREJ3blIr?=
 =?utf-8?B?RnNkNTlzQ3ZLMG92clYvcGZvR3JsWGVRMmhnV1c0WG9mVGhVMlZBWnVWMjh5?=
 =?utf-8?B?WndwT3ErdUdLNXppcE1YZThNK3NZNFdJeU1pNTduOEhDMjBrazJpRlF5R3dI?=
 =?utf-8?B?cnMwbEdERytYb09qcTNOVlB4YUNpb1FrNjhIS3dGT0dWZVlwaU9CMERIa0hL?=
 =?utf-8?B?N0UxZGxoYlBMbG84MUdHQzQwL0oyUDB2Y3BrQnlnT3VRb2hBcDk0SGVLcUxj?=
 =?utf-8?B?cGgzRHhZSytxNjF3S1p3bERTeTFKalRHaXFJUVJJOC9iUWZhYm50UXN5VWQ0?=
 =?utf-8?B?VjVMK051ZDhEZG04cjdpODlzR0hkYnJtSi83TDBMa0FCdERiWHBsZ2t3RzJH?=
 =?utf-8?B?Q0p0OU93QXFXK0tjZE9oaUt0dWdxV1d3Zmt1SUlMVzFqZ1BGT0FabkNVZWhY?=
 =?utf-8?B?MGZLS0xsSml5Ykg1MkpiTlBEWkcxUTU3b1BtK3Y4WVQvUFZ5OFROUE1VUHFs?=
 =?utf-8?B?Vzh5RXAxMGFlS2FkVkxsZmpXQ3RyOGxMOEwxRG5JekVBUm1wWitlU01ROW1l?=
 =?utf-8?B?dnQzV1dtOGd5eXFBVDJFOVRldjdiOWFHYmM0Y0RGR3MreVpScUhRVDNvYjhW?=
 =?utf-8?B?QlpybFFOL2RjUnFWZjQ3T01DS1M3UVJHNkhRc3VlckpNSHVvbWFtR2hWT3kz?=
 =?utf-8?B?RlFUeXVXSUhjb3NURDYxNzY1VStpa3dFbXB5UVh0Y0Q1Z2x6RHVxdU9uMUxB?=
 =?utf-8?B?dUNXQ0dLU2FRQWVXR1h5bHBnNGNxcWxYWGlGMGJ2cFNLY2d1SkdWU1lhZkRF?=
 =?utf-8?B?Nmttbm8rUy9LeGcrakcyTEJoVzgrRy9KaEwyZFpRUE16KzgrWEI5eGExNDZ5?=
 =?utf-8?B?OG50Nlo0alhMM2U3NVhjMGlLVEFTSGhvZk9pSTFGNE93K3NqUWt2dlkxYTFL?=
 =?utf-8?B?QjU2U2d0WUUzcmdqNDk3NkNCTG42N2p3WDJOYzNYMDBoSGNHRld4ajdSZ2c5?=
 =?utf-8?B?R09BWGErVkIzMjdvbGV1K3hlNjdPVTFZUkRGVDJ4bUN2Ylg0QnBDZz09?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFrjrGPAbLMP78F0YbMsle8uDwu4rPYwpYct8bczFoDlbP95CW35mMAdSgepd/XvTQDUGehnaDLZoIOE2ldAlszR5kiPwIKS5PnQM4vATvlrNCkZvxmaU/2vt5+4JMABjI248Fbjpl9AOcnYXy6+P6KSd1Z+dER+ZaQuQtUFeiN0Szfnd37NDplGOZbRwMEVfrs+eQwTN8sMPGw4k4Po5Zq+LlVGNrxrXyasShA9trXLz1DLLdbbzG+9hVkEeN5Zl8CniSFvlh4RgAqMnVa/GEEce8AVG9CLsrwY5Onk71LvH2jbnMnKRgnMeDbHQ0yZgHxIJn970oK4nIws73i31Q==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//vH8ROMFGUDB1gLFrvUb56ovm5z3XqQnP6GAQ1WEyE=;
 b=yX5cX0gBMpQR5bMpro6xDCnQuFkdgfi7fvTaa2hf5WVjfn1g4SOEReLzV7JyRI9Jnb7cj3bjuyT29I17Oig8XgaQvV1XDqqN98cgQu/mE6OXmmhUkkcv0DcBWlZJKpySjdIN6JanPMCwXanbFzk+YiL2ErtRULl90PQItKYM8dxEWngHReKexd9SK/bm/qHaMNHwwRJ8ti2IioW3OVZjxKJf/w+fd2d+lws1jKGY+MnqqA86e3PfkaWY3yMASeL9XUf3xe0/mthMmeW+FgbZIDlDBuEPT6RyABj37sNLjYHW0FWwyK8VP88c3+1hB9J+NKwJ3uDz/KvO28NimkfuIQ==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
x-exchange-routingpolicychecked: mkQg8jEExiwSBS0sbpDt/ds7IndAYDFsroI7Wb0KhcYa2fng5mLj5xqugKBg8u1sEOGr9u61HAaEzf8OLoBIT15iZw1+73pa82htP7Q+kGWrI9jgWjVlLOjNZ5sUGV0/Prd7thUBOMSxPTOX/CkOCrgmdEMClCAigWTx6GQOaEukSdFeYNJdoi3PkSWMJLUyoBG/joTTYzYuhX9hHCrH/AzPIuAKhiFqCD7/Bbwu2buMF7aisHjIIs+o7pmk7POxzjWP5HctHiaLa8Yszrmz2MeuH7BLpkZfj5smHwEVSpFaacwWe9XIIA8HGULhjMrf+zfngqcW6zfbx8B8srFRkQ==
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH2PR17MB3797.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: b7951590-0a77-4a30-fcba-08de84ef7546
x-ms-exchange-crosstenant-originalarrivaltime: 18 Mar 2026 13:08:33.2713 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: zsrK8epZ5XhkiQxKD33cKci7q61tPb3X2EzhjlmRiEPZ0Ul7LK5fJFBiOzGRQjZ6TwaVonNf62baTK21uBHSIA==
x-ms-exchange-transport-crosstenantheadersstamped: DM4PR17MB6905
x-originatororg: akamai.com
Content-Type: multipart/signed;
	boundary="Apple-Mail=_B94DFD7E-C0EE-4800-BB88-4B5486579E43";
	protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2603050001 definitions=main-2603180111
X-Proofpoint-ORIG-GUID: fPH84BXdB-0gnU-lfFySUeGsWP1osWrs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDExMSBTYWx0ZWRfXyvOIyQtscfL/
 k7UfQQsV9hPhnF4spkr8yD7f7Q6HyO60ML2K0erXCmx2hDph/UU5DEqt+oTOEAcQnt+anORFpeu
 xenvmp7Si8iz1UV2yEFMFkM5ONbdZ5mlHro0tCGUGsVfUN3z4N0DLt3+1wHLYBO/uvXDlmgIVU7
 NUgSgTIpNLdZtTBAx1uIWdgwPrz5vs2UiiDqgdgU+Bk9UT1S/RQXrY+4sV3wDyV574zNeInexgq
 9mbJzMD8Prs4hkdcP3GyqSkI4cm40FKUI+UTz9Ff48MA0hBSUxsUdFIOIBKtw0ShV+z6OuD/Fwv
 bt8PdUs0c1ojppxGFPC8/xYGPxAE/qFsgZ+qmZ2OsX+YvEPGXBgMdj8HaslIDlwVSRxVOhKkJ3k
 to3p3nVLWs0mNt1pwwAs+U4aVcGwoN9HT4+EyjX2U6K2i+aC5YGxoeF2dC4jV1huRCFlJLXv3iU
 wRH1i7l/N2OcbooRMDw==
X-Proofpoint-GUID: fPH84BXdB-0gnU-lfFySUeGsWP1osWrs
X-Authority-Analysis: v=2.4 cv=DeQnbPtW c=1 sm=1 tr=0 ts=69baa3d6 cx=c_pps
 a=3lD5tZmBJQAvN++OlPJl4w==:117 a=3lD5tZmBJQAvN++OlPJl4w==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22 a=TTBIr9FR-UdC54aaq7Eb:22
 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8 a=hJAsHtX9mSUYjZZCTm4A:9 a=QEXdDO2ut3YA:10
 a=YFfSyvVmZfbc0_zi5bsA:9 a=ZVk8-NSrHBgA:10 a=30ssDGKg3p0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603130000
 definitions=main-2603180111
X-Rspam-User: 
X-Stat-Signature: ffpph5m3txsqn6qbzmo6xmfyp99apkr9
X-Rspamd-Queue-Id: EC3ABC0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1773839333-685578
X-HE-Meta: U2FsdGVkX1+G87/ncy+o4YqHE9uLh+eeiDr/K21JhIcuMr13gKHMg1o2yhWTx5xEcEH2003ZC/uP6Fld76WS4ctFTWVsX/zhpQ0qWxRafdcpOErdGzN6F8HraltkZ4HEq2TaBRrR8DsWtkQwytVszx3V7AxqC7ch5SPkSZ8e9k1ywBG8yIlCYdWDc3e4FPPT/VjCLeFJPPxcgl4TlqQprtrZ8yeewnUWCkAG4wfUgmaIjc/jm5cQFqB8s2gZzq5aKcxHMKfKY669TYamcM3x9R4zTotus2dOzvWlKqwlDW2uCQXrw9bz5bTRpa2vuDqN8p49vNhdFiR0G7M4RyGbXdi3BEEkNswT64WJ6R2V6B21UDlahqH9whgdA/Snx0NMbJ7Zfv8IfuIRgqA0DwP3GtThk+Yati93xruDdhDxh6lvkK9NDuWwUEDcsowahUYx2YDWZjxyUR5HCuAXI4/ECuHqkCMB96qcoC0wPluEVVinEf1D+ofbZRD2noWhITpYnjJGw63CzmzFKIeQVYf7B5wpLYIUdK7ZindTazoOhT0+CkbieMGFNvkhE3ESIph11ZsqRA4W/ENo7gdU/JMukx9XTC1SxWTOIJEllIb/YOekPpzYYrgLGWQVq2cSGJFNnKOigncIbJ89ZdXT5wwBmA4pIse3sv3jy1wHMrSgIjUTc5h7Skqj5PASkwHYW/5/g4fVl4AyIgAAtnxJYmacA/zg4R0ai+OozKlPrDSmr+9AbHAFDaamw451JGBcvMvdkMPw3vFLHbzD5Lwu5DFK07om7rqxerYxiUFvS0+XmsfsEt7FGQhcZgEy8s/A8oknlPwwNlOj3cph8Rr4ZqOQErMplHPDZhFzd2WD51JT10EAfhvMJ1Rn3MpZie0tzPPw/tThd4XKFTSd+6pkY0T0Es7frwN2MUe/dBtjM0MEWnsHSi+zDem2x4CuO2dWRos9rrC0qD8/9dPiiRBy+Hf
 iksxIuIs
 lQ3+gG7/mf1kPRR/ix6v37ahv9qWB68RVQ/klU3VZjk6eeoAJjyKumkFJHwP6cDWORisYQp/ZvxwFE1uJUORXDm/9M4eLk2YqXp7fkvig7oYe8B2ZTf2JO/64Bgpt2pcc+o48WhM/LQMrdefDEwaOpQ13u7vERh5R/6crY451cx1UZqmzwlKPrgoD1MelGB97kYFA12fgrGBr1AV2fNV3AeoQ6ajNvrFYW1/qhEuwux8Blp04tzf4Jx9/ugVMR9sHrG72UhkHN5OY3D3o43jTQmZR5tswipV9NxbOJb/yKW9N4PMfFDwiMJsxYDnLLGDa8epcaKs17cEAizDqBOxlxyDrlMgLqndknAWfScpEgHwwJ2EVHoBVvgl0eIRTxMuB7USSLIjyr/t7tLV0bjA7f9R/x9RQkPqn0waVrjgo3HtwG9436anDL9xNX0OIIPpZnAEORJRjSbNPa3srl83ORYlmXaPPo/eN3y9QfgoGMRFnj7PCy0602TJEPmbns69N0c5qgAqZLHIV9BSd1Ue3Psaarlk2Ba7AxhZ7i0PK7wminejZkB0mRjOCpWJbDBq1n68k/CUekbl7ZADHhtpFuVKajWA/TZC3tx4AM4l7fbkeE0vOinekMauX4pZP0NqDvYtO52xSXMME4gblA0qwmG1CMgugSkE+Zh5+bNGBjOilw+yh/jrVAqOnHREQnEl7/oJBAUmmlSqSkptwbtzQaZBLkJz2DO52Od3RuDwHuhGebQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Apple-Mail=_B94DFD7E-C0EE-4800-BB88-4B5486579E43
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Mar 18, 2026, at 1:55=E2=80=AFPM, Lorenzo Stoakes (Oracle) =
<ljs@kernel.org> wrote:
>=20
>> [=E2=80=A6]
>=20
> So IOW, the PUD entry is split, then refaulted back to a PUD leaf =
entry
> again?

As far as I understand indeed, although the usage and faulting of huge
pfnmaps does not feel intuitive to me yet. Empirically, yes, observing =
this
when follow_fault_pfn() in drivers/vfio/vfio_iommu_type1.c is running=20
concurrently with walk_pud_range(). I have another patch sent up to
that list because this fix causes follow_fault_pfn() to return -EINVAL =
[1].

>> [=E2=80=A6]=20
>=20
> I think it mirrors the retry logic in walk_pte_range() more closely =
right?
> Because there it's:
>=20
> if (!pte)
> walk->action =3D ACTION_AGAIN;
> return err;
>=20
> I.e. let the parent handle the PTE not being got by =
pte_offset_map_lock(),
> and you draw a comparison to this in the comment in walk_pmd_range().

I=E2=80=99d personally say that the main logic introduced is =
walk_pud_range() retrying when
walk_pmd_range() fails. We=E2=80=99re also splitting the PUD in =
walk_pud_range() and=20
descending. But yeah, retry logic mirrors walk_pmd_range(), deciding =
that we need
to retry mirrors walk_pte_range().

>=20
>>=20
>> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent =
hugepages")
>=20
> Yikes, really? :) This is from 2017, I'm a little surprised we didn't =
hit
> this bug until now.
>=20
> Has something changed more recently that made it more likely to hit? =
Or is
> it one of those 'needed people to have more RAM first' or bigger PCI =
BAR's?

Yeah, frankly, this is the first patch where I could find the splitting =
being introduced. It might
be more correct to refer to the introduction of 1G huge_pfnmaps?

>=20
>> Cc: stable@vger.kernel.org
>> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Max Boone <mboone@akamai.com>
>=20
> Only nits here, the logic LGTM, so:

I=E2=80=99ll write up a PATCH v2 later today.

>=20
> [=E2=80=A6]



--Apple-Mail=_B94DFD7E-C0EE-4800-BB88-4B5486579E43
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCCcow
ggShMIIESKADAgECAhMxAAAAIa0XYPGypwcKAAAAAAAhMAoGCCqGSM49BAMCMD8xITAfBgNVBAoT
GEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3QtRzEwHhcN
MjQxMTIxMTgzNzUyWhcNMzQxMTIxMTg0NzUyWjA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9n
aWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAEjkdeMHsSTytADJ7eJ+O+5mpBfm9hVC6Cg9Wf+ER8HXid3E68IHjcCTNFSiezqYclAnIalS1I
cl6hRFZiacQkd6OCAyQwggMgMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFOa0
4dX2BYnqjkbEVEwLgf7BQJ7ZMB0GA1UdDgQWBBS2N+ieDVUAjPmykf1ahsljEXmtXDCBrwYDVR0g
BIGnMIGkMIGhBgsqAwSPTgEJCQgBATCBkTBYBggrBgEFBQcCAjBMHkoAQQBrAGEAbQBhAGkAIABD
AGUAcgB0AGkAZgBpAGMAYQB0AGUAIABQAHIAYQBjAHQAaQBjAGUAIABTAHQAYQB0AGUAbQBlAG4A
dDA1BggrBgEFBQcCARYpaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNQUy5wZGYw
bAYDVR0lBGUwYwYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAICBgorBgEEAYI3CgMEBgor
BgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAwkGCSsGAQQBgjcVBQYKKwYBBAGCNxQCATAZBgkr
BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNV
HSMEGDAWgBStAYfq3FmusRM5lU0PV6Akhot7vTCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2Fr
YW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNvcnBSb290LUcxLmNybIY8aHR0cDovL2FrYW1haWNy
bC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3JsMIHIBggrBgEFBQcB
AQSBuzCBuDA9BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNv
cnBSb290LUcxLmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFr
YW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFp
b2NzcC5ha2FtYWkuY29tL29jc3AwCgYIKoZIzj0EAwIDRwAwRAIgaUoJ7eBk/qNcBVTJW5NC4NsO
6j4/6zQoKeKgOpeiXQUCIGkbSN83n1mMURZIK92KFRtn2X1nrZ7rcNuAQD5bvH1bMIIFITCCBMig
AwIBAgITFwALOJfLRtbGzZc1dwABAAs4lzAKBggqhkjOPQQDAjA8MSEwHwYDVQQKExhBa2FtYWkg
VGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMB4XDTI1MDgyODA3NTYy
OVoXDTI3MDgyODA3NTYyOVowTjEZMBcGA1UECxMQTWFjQm9vayBQcm8tNDZZVDEPMA0GA1UEAxMG
bWJvb25lMSAwHgYJKoZIhvcNAQkBFhFtYm9vbmVAYWthbWFpLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOX+npfSrX/rwhOySq6aejQMUVslPFpNvXdEnmMlnEjR95gq0Ygp+wQc
Sde+JGBpGHsPMzHT1Nd3V1acm4cW1WB1aRqJOMfSLifg6SLkq2EM9WsftEiA1G4BT4UP0PFZY2Os
6TXvebAuVg6LwhB417rEJ2kuS/DKpiG8trAVDR6Uy9vbSMBp6iIewBc9r0CjW8l1zgRr+uQpXEUP
mF2BV0l3Qo5r0nhPqTWR9oAX4/oTqnhbEhQ3tOFYTjzO1K9DdzX8mVggVSZz/M0v0gtkZVvO4B1t
3Sh+1lla5eMY4hlVHW1/FKqMe4EMXmDH7goTEuXPpelJiNRdBh7ud7xNNFUCAwEAAaOCAsowggLG
MAsGA1UdDwQEAwIHgDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcKAwQw
HQYDVR0OBBYEFO0y/xWMpkyOUMuNKmuzNtjXpdtRMEQGA1UdEQQ9MDugJgYKKwYBBAGCNxQCA6AY
DBZtYm9vbmVAY29ycC5ha2FtYWkuY29tgRFtYm9vbmVAYWthbWFpLmNvbTAfBgNVHSMEGDAWgBS2
N+ieDVUAjPmykf1ahsljEXmtXDCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2FrYW1haWNybC5h
a2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEpLmNybIY8aHR0cDovL2FrYW1haWNybC5kZncwMS5j
b3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0EoMSkuY3JsMIHIBggrBgEFBQcBAQSBuzCBuDA9
BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEp
LmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20v
QWthbWFpQ2xpZW50Q0EoMSkuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFpb2NzcC5ha2Ft
YWkuY29tL29jc3AwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIgs7lOoe41C2BhYsHouMhhtIP
gUmFpcMQmtV/AgFkAgFTMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQw
DAYKKwYBBAGCNwoDBDBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0D
BAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwCgYIKoZIzj0EAwIDRwAwRAIgD5UL4MI1RXeg64RR
kifZAeItCnkZ4ecrqSEGpLcXV+ICIAdB9vZdM1WGxtag0rlqG0j0FBrCWixC0cdHNpFrqNx/MYIB
6TCCAeUCAQEwUzA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMT
DkFrYW1haUNsaWVudENBAhMXAAs4l8tG1sbNlzV3AAEACziXMA0GCWCGSAFlAwQCAQUAoGkwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzE4MTMwODIxWjAvBgkq
hkiG9w0BCQQxIgQgC2sf1ds164KoW2XEGvA8X/UU1wcheHgI+RkqZKvr2hUwDQYJKoZIhvcNAQEL
BQAEggEAEDHvutozO8JE+6lItYkKrMQf/77EGrtNZudgEuQXJmBZcgx5BTFAOYGInYRMlAh9JF+j
QUCnOJ10/m1ldzEZvH4657ORwC7M7ff2yKYhKzoinJJIksCn95a1nxT+MXk8hIxgBizB6QyaFmRD
QYNGI06Jl6X42P91l9NbzpTchQGl7MCcFzCZPIX3Uq1HlklUwDMdnyVPVtQonSd+jflOZN2aDlRy
sQjAcDY84ktgytLVTyvzh9hIM0Ceq4d26rkfyraMrH3g7JdJhrSvukAW8/iPhfXqk1d/MHk5ny5O
6QXCLK/CH1PxMXOnRiybGu9/hOfBo0xghPtWz77JF0PWeQAAAAAAAA==

--Apple-Mail=_B94DFD7E-C0EE-4800-BB88-4B5486579E43--


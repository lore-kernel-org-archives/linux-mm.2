Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D2E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=RmaE3gGG
Received: by kanga.kvack.org (Postfix)
	id AA80D6B0118; Mon, 19 Oct 2026 14:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FCB6B0348; Mon, 19 Oct 2026 14:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9218B6B0349; Mon, 19 Oct 2026 14:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8796B0118
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:54:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9786407C1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:54:36 +0000 (UTC)
X-FDA: 85340276952.18.C2C530A
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8A27840006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:54:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RmaE3gGG;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792436073;
	b=JWEN8Id8c/3aHaW/KTXoyFAHG1QLvRvB0aYowEkbYzNNmB9WcZIVlFkCJw8ogcChtLXDU1
	Vhqbjv1T7OEEw5VSV/61iqMMsHqCyUiTqPUHsjXrjL88Zt92vTtDldz0QPKiUwZ1tOaF8V
	Md7Du7xmqHCAa8n/0l2Lqpg57h6wgsg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RmaE3gGG;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.25 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792436073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRGj+ryqwyT8zg0gEWovwPA0vIo0aqv9eviwhbeC66k=;
	b=A3GGilYA5E4DsJjlh2Het00cwIYOg25TjjHnFaBAeSBkYyT+kdEfUbVWzq4KyIYiRwDIOI
	/mzhb2qDtWNuFqoIQzT8j3Ml5Icv90QIxBRoun0YlSNMcjGH2shPHMklYUaGw0tXZ4OniD
	znJZY/L7oz2jAZV2WS7ROFenON3C5pE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eOv+moM3KPfSOBH1v9cX7sRomGRYbQ95UJAPwkUvUMHbnDylkDX6h2+IhoZBtdE0Bk9dWWdm7dz6DXRzvSxYrYBeZ/ZHPGa8QmDHNsnb8JsCv1cyKlQW+tZqwCBdJ7l1LOuJbHeeRPMUKLxj80Fwgv28JLYrDkZvb5wx04L9+3yvnawG7kQV/teKhjgCkblQWI1WyMH2JO8rT7EUPVtkyAvE6TYAbnxSjydn+vLhtTj38zn6cK9zIhziBIviSNa2v8vt/XgnUDwO2YsZ5N78tjaM8wh0e/ZbEaNBHof9UnxrFFiMOrgsRKl3la7pb5Oc8e1RSOlW36GcPnXSuhBYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRGj+ryqwyT8zg0gEWovwPA0vIo0aqv9eviwhbeC66k=;
 b=sdlDHoUZ7WNNRK4mYDe/ZMJotK7Ehv3hYk9mUYt2bAKO68YVMjVtwCICo8LbIb2g3RFdmm22UW8wht9GgGYfgwRGEC2V7IVYYMbASqu4VFwoNxFqW/20xBvIsyTvZ8vmek5Exch3YXhXekrDXiS2e9Z1mM1LzuiS6hDoJmGGxoYVOfNGq8VNGQn63m4hjNyYVD60yks7cy1mx9HsSWmO1OOeo8hls6vWeQz5SLDuegsNBgEgXZUEs1dXPHGU956ZbEVy8F2a4eJy+b2d0RDlWc5V3kbXWhRr58FZtJjVoLfAD5MYEG7ZlFyNcy9SD4lBB5SG7AiKkmpbeY+azlhgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRGj+ryqwyT8zg0gEWovwPA0vIo0aqv9eviwhbeC66k=;
 b=RmaE3gGGLhNjGaUtD+xE2N26S8jgH0SBX+NV9b/7cDohhG5OsMEbG4XQiXbA1n74Yxo9DdUFnpAC5fhWa9uwmAUtXCWGC+wjpA0vph26LF1xHrgwfid3iFjZlsBxxVL2rlC/FbuOcPZsXne7Pt/DFEW/kK2RGh3BKbyolxeaGlM=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH7PR12MB6693.namprd12.prod.outlook.com (2603:10b6:510:1b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 18:54:26 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:54:26 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>
CC: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
	<surenb@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"nhuhuan@google.com" <nhuhuan@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "mhocko@suse.com" <mhocko@suse.com>,
	"ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
	<rientjes@google.com>, "torvalds@linuxfoundation.org"
	<torvalds@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Topic: [PATCH RFC v2] mm: introduce copy_mc_highpages() and batch copy
 in folio_mc_copy()
Thread-Index: AQHdX7GhnuOfO5oRrU+HnM1hVhc+T7cEyKiAgABud4A=
Date: Mon, 19 Oct 2026 18:54:26 +0000
Message-ID: <b22a59fa30183e13043e69ee91dfc77eca4d4a26.camel@amd.com>
References: <20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com>
	 <20261019131901.7a8fae90@pumpkin>
In-Reply-To: <20261019131901.7a8fae90@pumpkin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|PH7PR12MB6693:EE_
x-ms-office365-filtering-correlation-id: 29fbdff3-a0f3-4f69-6937-08df2e1265bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|38070700021|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info:
 r0G/4773H9oC94jVWMFISoPsfx4FCis93W18/Sa6pGPM77VcrU0bH4UX2urzwhsGzG1OvBVgEkFJncsQRdN0m/oc/KSVyDLt8q+Xs1MNuJzuKWvV1FMeyNEQaPR8KwvZAYwvp1XkoE15CAaphViaRTOdbKoiiY+3w9tFp4n4z7wRFlIvqeQMMhoZZj6Q9xu5zZtVt336JA0rR/hHBslpT5bie66yiGXQMGVMY2tuKTfrco3CHvfraVEQhFSxwTln17lVaz2Sk3a0HeMu0yAfFBHziNbEB1SFK3glFHeTBui/03UmkJxhWTlpI1sHSMpMUU901ba3JacCTFsc0gB6Crgfr8Uo/BR/RKbrd4PhMcJZZj/bdzqG58CDHBL0eAtDMkYzInE5wDs7WJeCAYhe9OksDN8QjIvbGqIf7QnPTPEs+sgDbf7Nx7YOrbK9+FdAmz7xAQpxvKpCdMwS3tbEEMNzSGJ0VZEYLXp23fuO9KVdlpGCleM3lhasqOqShJjFkcGfzSdJtDV4ndDJF6irUeibtPs6p7wygCVmjeXMhTE8b+8Vxwt2c4wcJTlOwidjKhbunh10NLIqXjXdf87H2JLYj2WkJislpUHbVdlTwFyXTBsh6izw9IcICreah6E4eZVIWdGJ2tE0BgIGNgJIG8T2ZsrLlioSuPhxR+Tlr3EQDgAsuaucfwqfWlMr66tZ3y+fiZUMukV4DFLSTWOoveRB9SuAQHk/ibA/7uj3AEw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(38070700021)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WURZd25uQUJQZ1IvWDRaNUh0MXUxZG9jVjZoRC9YejJZSzFsWHVnV0ozRWdI?=
 =?utf-8?B?aGFSNlZpZUJsK1ZZOFJ2QU12elh0M0V3WlBQUkFFQUpHS2t1enNaQnF5MVlh?=
 =?utf-8?B?WlZra0xvSU12TjBxbUh6WG5Ncnk4aWZtZFBQNW00VlZMckViTFEwSDNCanNP?=
 =?utf-8?B?Mko3NHIzWTlMcG56czRaajhTWU1xelNCWk1qejB0YXNDaFFPdElZSGkwK3Ew?=
 =?utf-8?B?cklWQTN1RFU2UElWaU9WNzN0OURmQjZaQ1hkekxFc0wvMnA3bnhLUEJUQjlD?=
 =?utf-8?B?amNOMjRVd2IvZkVRMENOeTZkM3FYeXBRSHltdjdvdTN5djU4UElPbklZWWl6?=
 =?utf-8?B?bmRpRGZBdHh1S2VCNjEwVTlaRnlVbWpudHZQMWVkajZBMFN0RlY4dzlacU5P?=
 =?utf-8?B?MnJ2eVcrN2dETEFTdFJLbWJVN0FQcHBlTjRTdGZZUjFzMDdVaHZFN1NaNUtU?=
 =?utf-8?B?aDRPY2o1bVNsMEpwd2xwd2MvTVF0cC8wSnUyTGFDOWErcGxJRFRrS0VlUkJI?=
 =?utf-8?B?NmhCcUtjMGVScXR0L3ArdXIwQWlwTFEvM3JkeHNYeENjRHQrbFU3UktDMWdB?=
 =?utf-8?B?eEhvZUZycUJpNnNFdzMwNGNud1ZJRngwUG9NRFIvM2p6b3NqRXV2c2Ura0Rx?=
 =?utf-8?B?OXp5ZUg2Qk1PUlk2dFhqZVlFRmRldWNzZy9ZRDA4d3Q2dVNUbWZ6Y2FJZVBH?=
 =?utf-8?B?cmxLMmFpeVlKbXEyTlVSY1JQM21iZmlKa21PeU1VWXkzRmJ5OXZLUmx3NFVV?=
 =?utf-8?B?SXpJcUFLOWVieU9yb2tGVVM3a2pyUWM4RGVWQW9kTlo3UFZUb3JXNWV4Ym5i?=
 =?utf-8?B?UVMxWWc2eCt5ZVJPSHpCWk9WK1FyaFovK1FNRzVSbytGS2Z6NUxSWDU4c2Zl?=
 =?utf-8?B?NnRDL05reHlMUzZ0MWVvdUs4REdXbllXZHcwWmxYc2VpTFVrektXa2RVTnNS?=
 =?utf-8?B?cnpMckJEMVh5WVd0K0huOVYvajFGcjBUd2hFcnFwdW1ta2Q0SnFBd1hFOW00?=
 =?utf-8?B?OFJDTTRLM0J5M1FjSlFhTXFnaFFZRXJHNEZwVTcrV1FrSTluNDE2YXpDVnF0?=
 =?utf-8?B?ZUtneFlqMGRTOWk5cnVUSlNHNHJZNVVGSWNnT2NrOFRKTFNPNzRFY0VzaWN4?=
 =?utf-8?B?YVRKWVNUem1HREJqOXE5L3gwbUVETlBReHNYekZuREVUeUZOc1lGaTV2Q2VT?=
 =?utf-8?B?Ti9GUi9xcG5naFVxWExDZ09WbzJNUDBVS3dOWGhRNnc5MFVLYW9ERU1Ib2My?=
 =?utf-8?B?Tm9kZWFrL1ZKVEljaU5Ob1U3RU9EK1ZMTE51NWIzU3pyeDFnais2VjNDeEd4?=
 =?utf-8?B?UUVnUEJXclhyeHRtR0NSUERNYlNxZmk3V0F6M0VxMml4UjRkNXFyQ2xiSHc5?=
 =?utf-8?B?WEcrSExCVlg4emJvbU54anhBR2RTcVJIODhGancwS0ZLRzdRTFd2NVZCWGdM?=
 =?utf-8?B?dzFkOUhKRGsrWi9XeVhkM3pZSXNISm1pMzE2bjhZOWdxRkZZWlYwK01YdEZm?=
 =?utf-8?B?UXU4UUpNU21MVHByU2NrVUlSVURoLzFVdHBVa1hsYmFiZVNjRHBqMy9RTDlK?=
 =?utf-8?B?RXZCWWpBdTFGcmlrYlMxYmNvYzY1V21XNWZGSWJkYmpOdGgrVm9YZ2JneEx2?=
 =?utf-8?B?WmlaYU45am5kQ1NvNG9KNVFNZEU1SzZvZ1cyL3RUZzdNcXVSOUprZkhMOXMr?=
 =?utf-8?B?ZTJCMVBzMzA4YmFTQnhVYm8wN0ZMcVE2R29PQzZSU0E5czRtcDVxRy9CSHV3?=
 =?utf-8?B?UXIwMVJ1TW5LLzJIOGxZWVlpdE4vZTlBUG14YmdwZGV3cXdrUEZRZ210RU1h?=
 =?utf-8?B?UVZwTmF2L1NIRXNRbmxQZkhvb3QvL0d1UGNJU0xMTWZwNmJvTWZ4RnBQYnJM?=
 =?utf-8?B?V2ZDTTBnN241dDEyVHdJOWNZSm1yODFzUG5EMmNlb2RyZ3h6bG5WdkVpVFd6?=
 =?utf-8?B?bUpYeVhkSVdCcGNmbWFEOUNOUmxJNEVLTlg4NWhpZ2orN0I3cTBxMVljWXVl?=
 =?utf-8?B?dVZyTGRqVHlNaTFtdlJENk1hNDI0N2lQVTZKandqVHJxRUtPK3hSRW94RW5O?=
 =?utf-8?B?MFRQQTAxcmRvQ2sweUFHY0NjVmY5aUp6QmMzampjRlY5d1d3Q0F3WHJ0TGtt?=
 =?utf-8?B?cGZaWk5OY0Q1K0dHSzJWa21SSE11UmtIcG50ekp4MVg1NmVZZDNmcER2NUpO?=
 =?utf-8?B?NnAwaXNkeGVEYk5XUzlmVC9SVUVFUGd6NmZuNGVOTGt1SnVMQm13a2pUT1dz?=
 =?utf-8?B?YjUwaENoMUZsb3lXSGlBWmwzNEUzUDh0LzdLbFJZdGhUcm5XQnZxZi9OZmU2?=
 =?utf-8?B?ZXdjVitJMnlzSlIycnFKUUJiOXUvUzVxQlR0VUFLa1JpYVJkam1yQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE79FEDF3B6E9048A734A4F30D75C7A6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fbdff3-a0f3-4f69-6937-08df2e1265bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 18:54:26.1069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kDU22ALusuugg0Amp5vg+R1AM3JLf9M8HDNt1jc4ZWSUjKmsmaY90k/LxxZdKt0McGS/54NuIGTYmWNkfKypJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6693
X-Stat-Signature: ano631zmhuc57bc68dmkxjk9dgzp8t6y
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A27840006
X-Rspam-User: 
X-HE-Tag: 1792436073-243021
X-HE-Meta: U2FsdGVkX181Q7GSJj8YTd6WSF9KJ4Vq24hXrehOSczUuGKzlK4KubNtETOjjbRqjtBpXp3LQWGOTLHAuRhrVgPc3UaqcDljghicsK8D3bQBcK1/I6xZWLBAfQ0mSvJI8GD8KryM0pFuuShh4CxkvCh6JWFSFuXhPXo5OVJ3ToBFMhwesEkQlx+wOqQtLt3ado20a727tsNdqYLVHIsW8YkNmm48l149bcIjQON6UcOk1imI4iNYRSEp26gukCFvVrDKNxQhWJ2ERT8K6F6RD5lcPcdqNyfBWN5BUFqMDAk56V8ezkvWyoKLkjp621fe3sc6F19KY9r53cuhLWX3i7tmPCd9N4az4UINaUf7/0rFWPyHpMWJrAnXIFleI/NLTYvqStvZfDTGU4FbcnUx5Hh/EPRyn2Xcpd6tGlJ2ejXY4NtHvX1SteD0MuheRluAb5jzS9IgByAOQ3IWweo23kwdNjDNry8+CdLcaZyoXEFqsGBesEaK9fj3VJtMK8dQ5czJAAqX1R8kgZFI6ZnBKaVX4uKdROofJ5ClXq9TgsNdVlP/IMEbW1AQ8K645/W/6NMAol0bz4fQqBr69phobcMxeNCw0CEOYmZnLT4c3y+MTVHuv5uixFQaEhfsgb9MLxGVnS5C9OOIQres+HYxaBcIb5KzWrFG2hhWqrbsJpGTv1DHG/f2S4amxGmXfCQSK1vnmrMXJ8eiJmBfXVU4a55wui4t8xZN4Nohnww+E7NBt/zIBwtuh7D86S2IeRPg8QfSaBMlNkq2qsYKfdPlM7chuPXhNMtyCkSvHxvO3c7+oZ81LujhJuO/2tB7/NqNZqCWyQwBeJkykYBGpIOQ3XhiUQP4Usdc8WbCZ3TxhqqZXz23V7Iekc15/KTCAQhed4I8n2cAIp3jojqgVAR4QkRJhtxROYpyMaoEgaaKbpXWLkv3Vo3dk4eo5F2ON7PL6xICKr7uv+FuzGe0r62
 mVt6IFt0
 mKbo48JbPM6BTbsUUHxJX0en/WOaOEe7qG66QLIz/VEc6nurdoWZi10DvqrD5hGhWVjVC/FpE9x0lsaXj7rcYOwmFznHI8pBwV6chgdSKfC5jz6of8WCyQvvwU8EZv3DJM8Di0AqeIQovk/kcqKIcZzjVqpe6XOm7BXVxTR9eguY3xZ4andH+5KUIhrFIz4p87/e+CF1tfIZZbSEXAvAkLdDUaIbn7t3DPC5qRou4AEn2I7aCGfuXP5nWFJ9VrlbIb0ZX13EnfEB1zFc+KZjbxuF0G7+QTjtZ60/FM2hSL9KHnOfPZeQa21zgYcXsoHO1OZHCNG5o5Hpojxgff8Z19iz3gFiVdCkjveVpYwOGNQcLN34A0glCIU2jXuPxr4Wo3w4wx1czomfBtozkmAHz1/2N5wORaQgSEO+wKcImBy4OjW7F/TkSkfZVOVg0EBUYwe7+ein8uUYa8QTSvb8Qe/w8dpmhPeguQnERc+P4C1uHx1jjpYfCweTMn24Vf+0G9KGANa/gXxcTmafhzAzF9wpADSVvby1Vo3LudhnrRsPP8AmHuV/OsdveVV7WRPlSMzgWtbMs2GNi2r7ugkywg0AGhFVsDNow3aYmBaeov/LbM0dERqC0E14xsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTEwLTE5IGF0IDEzOjE5ICswMTAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IE9uIE1vbiwgMTkgT2N0IDIwMjYgMTA6MDY6NDkgKzAwMDANCj4gU2hpdmFuayBHYXJnIDxzaGl2
YW5rZ0BhbWQuY29tPiB3cm90ZToNCj4gDQo+ID4gZm9saW9fbWNfY29weSgpIGNvcGllcyBhIGZv
bGlvIG9uZSBwYWdlIGF0IGEgdGltZSB3aXRoIGNvcHlfbWNfaGlnaHBhZ2UoKSwNCj4gPiBzbyBh
IDJNQiBmb2xpbyBtYWtlcyA1MTIgc2VwYXJhdGUgY29weV9tY190b19rZXJuZWwoKSBjYWxscy4g
RWFjaCBwYWdlDQo+ID4gcGF5cyB0aGUgc3RhcnR1cCBjb3N0IG9mIHRoZSBzdHJpbmcgaW5zdHJ1
Y3Rpb24gKCJSRVA7IE1PVlNCIiBvbiB4ODYNCj4gPiBDUFVzIHdpdGggRVJNUykgcGx1cyBhIGNv
bmRfcmVzY2hlZCgpLg0KPiANCj4gRG9uJ3QgeW91IGFsd2F5cyB3YW50IHRvIHVzZSAncmVwIG1v
dnNxJyBmb3IgdGhlc2UgYWxpZ25lZCBjb3BpZXMgKG9uIGFueQ0KPiBjcHUgYW55b25lIGNhcmVz
IGFib3V0KS4NCj4gSSdtIHByZXR0eSBldmVuIG9uIHNvbWUgdGhhdCBkb24ndCBhZHZlcnRpc2Ug
RVJNUy4gDQo+IA0KPiBUaGUgZmFzdGVzdCBhIGNvcHkgbG9vcCBpcyBldmVyIGdvaW5nIHRvIHJ1
biAob24gYW55dGhpbmcgYnV0IHRoZSBsYXRlc3QgY3B1KQ0KPiBpcyBvbmUgd3JpdGUgZXZlcnkg
Y2xvY2sgLSBzbyA4IGJ5dGVzL2Nsb2NrLg0KPiBBIDRrIHBhZ2Ugd2lsbCB0aGVuIHRha2UgYXQg
bGVhc3QgNTEyIGNsb2Nrcy4NCj4gRXZlbiBhbiBvbGQgc2FuZHkgYnJpZGdlIGNwdSB3aWxsIChJ
SVJDKSBjb3B5IDMyIGJ5dGVzL2Nsb2NrIGlmIHRoZSBkZXN0aW5hdGlvbg0KPiBpcyAzMiBieXRl
IGFsaWduZWQgKG5vdCBtdWNoIGxhdGVyIGNwdSBkb3VibGUgdGhhdCBmb3IgNjRieXRlIGFsaWdu
ZWQgZGVzdGluYXRpb25zKS4NCj4gU28gdGhlIGNvcHkgcGFydCB0YWtlcyBhdCBtb3N0IDEyOCBj
bG9ja3MuDQo+IFRoYXQgbWFrZXMgJ3JlcCBtb3ZzcScgZmFzdGVyIHVubGVzcyB0aGUgZml4ZWQg
b3ZlcmhlYWQgaXMgaW4gdGhlIFA0IG5ldGJ1cnN0DQo+IHJhbmdlLg0KPiAoSSB3YXMgdXNpbmcg
bGZlbmNlIHdoZW4gSSBkaWQgbXkgcGVyZm9ybWFuY2UgbWVhc3VyZW1lbnRzLCBpdCBoaWRlcw0K
PiB0aGUgZml4ZWQgbGF0ZW5jeSBvZiByZXAuKQ0KPiANCj4gSSd2ZSBuZXZlciBtZWFzdXJlZCB6
ZW4gMS00Lg0KPiANCj4gSSBhbHNvIHN1c3BlY3QgdGhlIHNsb3cgcGFydCBvZiBhIDJNIGNvcHkg
aXMgYWxsIHRoZSBELWNhY2hlIG1pc3Nlcw0KPiAoZXNwZWNpYWxseSBvbiB0aGUgcmVhZCBzaWRl
KS4NCj4gDQo+IE9UT0ggdGhlIGxvbmdlciBjb3B5IGlzIGxpa2VseSB0byBiZSBiZXR0ZXIuLi4N
Cj4gDQoNClRoYW5rcyBmb3IgdGFraW5nIGEgbG9vayBhbmQgZm9yIHRoZSBkZXRhaWxlZCBleHBs
YW5hdGlvbi4NCg0KSW4gbXkgbWVhc3VyZW1lbnRzLCAncmVwIG1vdnNiJyBhbmQgJ3JlcCBtb3Zz
cScgcGVyZm9ybSBhYm91dCB0aGUNCnNhbWUgZm9yIGFsaWduZWQsIGxvbmdlciBjb3BpZXMuDQoN
ClNpbmNlIGNvcHlfbWNfdG9fa2VybmVsKCkgdGFrZXMgYW4gYXJiaXRyYXJ5IGxlbmd0aCwgYWx3
YXlzIHVzaW5nDQoncmVwIG1vdnNxJyB3b3VsZCBtZWFuIGFkZGluZyBhbiBhbGlnbm1lbnQvbGVu
Z3RoLCBldGMuIG9yIGFkZGluZyBhDQpzZXBhcmF0ZSBjb3B5X21jX3BhZ2VzKCkgKG9yIHNvbWV0
aGluZyBzaW1pbGFyKSBmb3IgcGFnZS1hbGlnbmVkIGNvcGllcy4NCg0KSSB0aGluayB0aGF0IHdv
dWxkIGJlIHdvcnRod2hpbGUgeDg2IGNoYW5nZSBvbiBpdHMgb3duLCBpbmRlcGVuZGVudCBvZg0K
dGhpcyBzZXJpZXMuIEhlcmUsIEknbSBub3QgY2hhbmdpbmcgdGhlIHVuZGVybHlpbmcgY29weSBt
ZWNoYW5pc20gYW5kDQpiZWhhdmlvciBvdGhlciBjYWxsZXJzLg0KIA0KV291bGQgaXQgYmUgb2th
eSB0byBoYXZlIGhhcmR3YXJlIHNwZWNpZmljIGNoYW5nZXMgc2VwYXJhdGVseT8NCg0KDQpUaGFu
a3MsDQpTaGl2YW5rDQoNCg0KDQo=


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64372606A326
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rvyVhE0v
Received: by kanga.kvack.org (Postfix)
	id 1CDEF6B008C; Sat, 24 Oct 2026 08:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181046B0A72; Sat, 24 Oct 2026 08:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048BE6B0A73; Sat, 24 Oct 2026 08:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6DA56B008C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 08:21:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FD94A7AEF
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:47 +0000 (UTC)
X-FDA: 85357431054.25.5A66CB5
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010023.outbound.protection.outlook.com [52.103.20.23])
	by imf13.hostedemail.com (Postfix) with ESMTP id DFB8020002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:21:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=rvyVhE0v;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792844505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
	b=BMsJ/Q8YEVDRf/w5BeeERh1QtG8pe0v95vHMZjJUPCh3jUTJvH11WWdDN+s9r/zVx2EFQR
	m1fgjLK5ZWep1AbZt6adtjAfmIbISLcKrp8CWQKAjEydiaEIx+AoWoBkTuPIgdt59oN+CI
	0PUY837kiBCbBk6dgsoZj+ElfgKKGRc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=rvyVhE0v;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf13.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.23 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792844505;
	b=VF/awCoPPZWj39woGitABxiTYy4VX12T7YIsbEOtHhGvWYdjhm9/ChREbp4SNC9YHnR+rq
	65X8rYZaQmoIpybFDPJ39o3S9oQaiPkwSSldzPsV1nIZ9gyq0rrvsVlln0iEQor42RKoun
	XjDmK/CBAfuh7YSkvU+ZZZYMZV3atco=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMG8E/9x6hKniJKSpKRrP1uBqKQ5TfFuo+PUYieS4AuInIyLEIAlR9HUsX+Zsx0dHxa/uPg89ZKcJduTb3vvPgnB20fHbunD8HNnaj04QGSmXxRjG14VvtmlMc3CG7DFgXXIIldBop28CPctkr8QA7paGjU0gcLmGK0metWtYKmz9duIDB1pMGHYwLng4VM6v1MLXSvFbFu8VHx6oOQT9U9ew09L+RAmsh+t/KTCXi6GvymNWR9ZnsTP8wMUxYOJGG+ibtLk8goYT98MXNAJqozJAu1D5cX8/NcTZ3epN6Z9CT/szK2nYdUNtpvK+I1vqFvrfCV5/rPFG4QQrWBjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
 b=Jf5DsKo2UoMNFIz1/mp7lRNe5gNwwngUwJ8GKWF743FD24TL2ifosx6pSsWjGfhZoIw6058375szmBGf0OSNj7xU9TmRtvvwhvqgi+bFEHmqJOxs3EmXK/7AyjL7ThgoA7TAN2T1FAmCXKadWPe5TMu9yFrwzaxrq9TrtkiPkzEJ1XxwDH7HfMef6WS3q+ofXgVQoBWCrLYOyhN+dLdQ0+2XbhqXACbmykBAwj9P5Nc6WKpbe06PgAH+DQj6nXcTqmw+pUvye9KrNCVqFejLUATsh9XWC42Iia3t34ebJXJbaCua9fl3JGm1iXHIAD3KpEVwQqmAQxKbKhSg4s6ONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
 b=rvyVhE0vR1SC/3RcJ6yusboPcn1otKojty9b0XARNc8JMugg/Z/1aVU4//TswP71dgtmA4ynfYb1I8OhS8vRhytODvFjLVx/uk5sJVMDksctxkaz4c9LLg6PpJRebja2eDg2R0g2O16FRxNlxBGOvwP0cB1eK6X2ImsQDCQENsgPyHglmJ5EbCI8Z9q+S+ynnen3RrrzONbWOkuaMGpYsxQmcB++p72tO1lLWR3me2871ZkVTu603MBbCU1W4pI8psxDt6EAQwZich9zNDM40mgT6Vi+1aRfDBJjiAr4KvMMEExuZusYIJ7rHcEQ24oSaaCZ+0jeoJ64Qtcii1yKwQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:40 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:40 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?utf-8?B?TWljaGFsIEtvdXRuw70=?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH v3 0/3] ipc/sem: account enlarged sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v3 0/3] ipc/sem: account enlarged sops arrays and
 validate SEMOPM
Thread-Index: AQHdY7I5wbt/X9q08UiVmhsB5GVyKg==
Date: Sat, 24 Oct 2026 12:21:40 +0000
Message-ID: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 91b09f98-b3c2-43b1-46a0-08df31c95b97
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|12121999013|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|38102599003|15080799012|11091999009|21061999006|24121999003|22091999003|1602099012|40105399003|52005399003|10035399007|26121999007|102099032|440099028|3412199025|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?dHlRTDF0N2pYeXFCeGZzb05nQzVucEViN2lkUkpONFVrUTBQdTdkR2NyQ2dK?=
 =?utf-8?B?bTlha3BiK05EVFl5RUF2a0FhN0lFNVprMjdOM20rb1FHRWFDYWgvUmZ2bTlE?=
 =?utf-8?B?Y2VXNW1RQnpDVnFka0FINDZBbG1oaHd4T2Y1ek9WUEg4Ni91ck9iS0JjQ05T?=
 =?utf-8?B?VnlnanMwS21rK1NjTlRoM0c4aDZtV3FleWVwaHkwN01hczhQUzJEY3NTRFJ6?=
 =?utf-8?B?S01GNXlDcnJ6dkJQSkRzNFpPeDBhVWNlL0lTaFF6OGlXMkpaM1EwOHNwaUlG?=
 =?utf-8?B?c1k5MEQ3K1JoVDRqRWFkZ0hrVTY4VkN3NFNwUzJqNzNrMkNjYWY2M3FxV3dq?=
 =?utf-8?B?cVJINExSTHFzM2dJbkdwRTJ1WkZpNk5Ta1NtRHlQblJFZHU1UkY5Qy96MGVh?=
 =?utf-8?B?V25CU2o1blJQMG9FeXRFdjlHK2hHSlp5enhhdE5hWjFrNTJnR1hNRVpVZ3p1?=
 =?utf-8?B?V1NJNlMxZ1lETjluTXh6bEJBTjJDYTdrbktXNmxsTW9qUDFBcndYVnVrT1dZ?=
 =?utf-8?B?R0JrdStxK3g4TWZCZitQL3lYRTB2WFhkcVdvMktEODQ5VlUvdWRCVno5MFdh?=
 =?utf-8?B?ZGlWTkxpSnZVL2Rhb285WFAzSElzNy9zWGJYUStVQ2FmbHNKR0dhdlpHVEVE?=
 =?utf-8?B?WDQyWnk3eUg0VkZtYk9TVG5DeHNObW10eG5wTENiLzlOdlUwcTZwSU9IL20y?=
 =?utf-8?B?K0Fvd1AzaWlKbnZ3WG15dXR6MWxnWTRlaDdTdmJXNDRzZ2lHelFXV2IrdkxB?=
 =?utf-8?B?UHZlbmxOckdLVjMwY1lLNmZKT1pKM0t3ZnZQTWRYck5OMng2Tll1enZVOVVZ?=
 =?utf-8?B?WUVLRU5WWUFXNXFrUUs1bE9mc0VjeFZwTTJtWVRrSWY5R0dPem8wTk1xSkxr?=
 =?utf-8?B?UXVKbXpvTit5NHlZNkt3WVNyYThKTDgxRGg3Z1ZnM2MrQldUdzlKSWd5dGtz?=
 =?utf-8?B?V1VQbFkwNThvSFFYMFEvMG9JNmZNYmx1Y2dYdWI3bHdvRVp1SG1hU1ptVzh1?=
 =?utf-8?B?QkdnSmwyZlBHMitoWGh3Qjd4UGhXZlBIZFRFUGlpWFNxTTM1T0Y2TmR4SWR1?=
 =?utf-8?B?eTV3M2I2cW11SVdhSlp1d3M5Y0tHcWh1cDVySGRYaHozbHAvNENjOHBoN0dz?=
 =?utf-8?B?Ym5rOTRwdmR6VFZzSE1VTjJEMjJnSWs3UGtxTlRHeFhtcElVQTVJZm1kQ3Fl?=
 =?utf-8?B?MTBjcExaZEVBNXZsYlR6dHBraGNpa2VLWDBmU0F1VHlMSUJJaS9sRlc1VndT?=
 =?utf-8?B?ODJzZkxHZTVDNEFoaWNkOHBPQTVSRVIxVUxKcHJOTW5Pb0Q0TUZWU0lhN09y?=
 =?utf-8?B?cU1HZWg0Mm9wclN2Y0F0dCt4ejVFMFEzT3lIaEl6Rm8vMElncXM2R2VDbFNO?=
 =?utf-8?B?eWJQMFA0aGJKdVBWcC8yUDlKSjN1QWs0ektXa0Q5bFdDTDlMQ3prRG04UkFk?=
 =?utf-8?B?OEN5YUllbFJxRUEwT3NzTnpwQXVKamxCZWY2RnRWTjRvL3ZWenpJbGRGcmdz?=
 =?utf-8?B?cStjMHJxRXc3b1hyQ2h2bnNvMnF1dnltT2xnWGRabTMvZTUwTzZtd05oOEx4?=
 =?utf-8?B?a2lSY2R4citMZWtNUDYxazEva1psNzlJeWZtN1lDeUtsbkFweGNncGdZNDMw?=
 =?utf-8?Q?jtDBpz+MFk7eiYMguRhWWNqRrjNymec/IRq1UGD/DstI=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVQ4Sk5pTlovL0hCak4reVJVVTBvRk1heVdNWnlONFNoRzhLMUltYVFOTzE3?=
 =?utf-8?B?d25ZdnBNMm1Tb2txbUF0L1AwRnE3aHNNeFZXcHp5Z3lScDFrbHRCeW5CL29G?=
 =?utf-8?B?dXp2bXBGZktjYzhXY3VsRTc0aXQvcHFwSU9HM3ZiUjZBcndZeUVMeEtDVlQz?=
 =?utf-8?B?bHNQZVNhcEFvcXR3VVVrNG1VdlhybUhLakdjeEJ5S2dWbXlDaGg4T2k2MzVh?=
 =?utf-8?B?ZjNUd3lCMFllSWsyb0lnMjlEejBhTFNWY0kzeU9pTlpFR3B6dFBqTTFrL2Fm?=
 =?utf-8?B?eXo5NnNOUWNYcDJLTGFrMnQ1RERjU25CdS9xNlcrd0JSU3RGOGJGRkFSeGRo?=
 =?utf-8?B?R1BBeUViZU9qa3NJWGJwQ3ptTzlybWdMZ1UyV2ZZT0lXcXFXUllSZWgvR3oy?=
 =?utf-8?B?MXJDRWdlMXFzZElIanBpMGMvSTlnWGFlTm5YN3pWbFF3cWR1NE0rVTk2SWNj?=
 =?utf-8?B?SXpSa1FUZHd6OFB5ckdERjhtN2dRUFZpVExRS3Y5alRvbWVlbi84U0lSVm8w?=
 =?utf-8?B?THNvZzE2WXQrZ1paUmR5OTBxQ3Y2TzRVUlFNZWtYSHQwSlpkNEltUzhFUXFa?=
 =?utf-8?B?eHQ4YURILzcxTTNSQlQ4L0pUQnJOWWcxOHBKa21pc2ZNZzg3WlFaU1dQOFR0?=
 =?utf-8?B?VjhnQkxZMkFaSHVYNnlTbWE0RjJVSzJYbk9LT2FvcDhyRVI2TURjbU5MTVIw?=
 =?utf-8?B?bk00QzBMYzBUQTR2clJHU2M3cTV5TWlRWjRSWEl4cVhEUTJkamVlVDNSVGZF?=
 =?utf-8?B?ajlnQTFZL2tNSHlUY0d5Uk95ZERxcjJlb1ZoRTA1Si9RUHpqN0ZXbnFxRU83?=
 =?utf-8?B?V3V0OXE5c1M5QTRCWFhEYk9yKzZHNE1PNkQxV2QrcjFaTXZsdEpVdWVubDNV?=
 =?utf-8?B?YmhtZFpuNGlRemJ5YlRiM09XUWUvbnAzb1VFUFhueXpCVkpud2dzLzc1VmN4?=
 =?utf-8?B?dlhYTE5GRUd5WFF0VWRkQ0hpaHcrVEJEMUM2Q0p1bFM5ektJSk5HbEVLcW1Y?=
 =?utf-8?B?RDMvd09rczZ0WHJNWlE0L25mdVlhQUxFbkpDYU4ybzdsUDd3RHFBY3RXa1Mz?=
 =?utf-8?B?L2Jtcnh4aGszNUl6eTg0UWlleGoyU3VRMGlvQ2VhVDlCSDFOdzVIZDI4dkhO?=
 =?utf-8?B?YkJIdGR3UWk5V1FTVEJpVnRjZ0lSV3NzU0QrNGIxR3czTmVrY1AxaU9nWTY3?=
 =?utf-8?B?L0UvRWZKZGxkQ1EvVGkwTWNKUGRQRHpYZDNDK0lvYWRRUGxCMVBhdC85NUxh?=
 =?utf-8?B?bVQ3QTdsbnorV1JsUXNsSnh0VFVrWENLZlNnT3VON3JRaVRoTG9oRWtpNTI2?=
 =?utf-8?B?Szl5Z0hNcDVKSCtick41RXpyWXdMUWZDc2oxcS9UaU5NMjlUaHdrZEpoa0pJ?=
 =?utf-8?B?ZSs0Q2pFVWdsTnNDOTZPTGNzaG1XOHBMaXJ0aDN2eHRlUVluUnVwdy9hU3pW?=
 =?utf-8?B?cTRBR2pYSjVabWtHQ3R2Z0ducG5wb1BGVjNwQ0RtOVEvVkc5dW9xclJ1T1dQ?=
 =?utf-8?B?cDd5ZlRkSXNuVFlLQWxLZEx1SVdzZk9KQmVHSlRKWXlOMllYWDFDZGRZUHlh?=
 =?utf-8?B?SG9ucm1pVEpDcG5PbWVBbWs2dE5mMzVlSURRaS8zNUxpaW5ERElKeHZ3enQy?=
 =?utf-8?B?ZjQ5dHNQMGNWUFpSV0VmbnRGTVgyZWpYUlpZZE42MnVmTjhha2FkUThvMTRm?=
 =?utf-8?B?dEp3ZWRuUmczWnBoNVZrS0FHeTJqMUpOcXZucWhEN0lhY0gySzkwNXcrRHU2?=
 =?utf-8?B?KzczUTJlZVFHRDNSTStaTkp1VDh6QVhvUnZzZUlQRlgrcFlkUENxTlZkRGZ1?=
 =?utf-8?B?cEFIZEZiSFl0RnQ3VmlZWTdmdG8zdkowUWh6RHo3bko3SlVZWGFVc2Z6VkNi?=
 =?utf-8?Q?rMmbUalnXoHTm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b09f98-b3c2-43b1-46a0-08df31c95b97
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:40.4371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DFB8020002
X-Stat-Signature: goi3qp77przgupohysdcij8pig8u4rqi
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792844504-492390
X-HE-Meta: U2FsdGVkX189eD0oblVTfJ3kF3l6H0kIDl0BCMrC7/LIvbvmJU/Ei3g3sz4X/K4Q36XRrDayOuHVD6I68r1U4lVCezGGTd9+ia0vaQyVRj844/3ysBZykj4XsPjymbfXo/vGY4Hnal+P7NFQ7oIzIJSO7Tcds8lytLZ+NSu56dP6PNOTJxr1dTk/p1N4kCftgmReSFSJL2gGXLM+yjHRiwJlXi6GuC9ZfUNRmrBgTHvnca2lB925EUzNqo5TSH4+iBtxkvAkMJx0z4Wm8RtUjFPtKMJVMFFenGFko80od6l1/5bRNHiQF4f0Z7kb72uIecASxzLcAugyyjdjWWlowdu2s5IdOpBrkePjICUx7kLPd9DFkdOQqr573teC0YPVbyHYDYuVp1XGYBJYS7KzNkByEC2mXMxDwclDffmixwU8HfwAZ6+GpDab9ss/87tmJ2394nZ4NT7H4Igy/QmES7C5Jz3lkGXIebCgvxp+x3MfKjOZJ4i6OlwBhztUQmvNN6nZtueqIhevf/04IZ2t6GWgH1IlUxxzueMdcSrZe7SCVhJfoFMQDC9t9vy972nzHTM5w5vn3KmYjoQj73Pj5zTYnUvUXIqvjC2esiGeWI+HrqLOhEP92So3OYEfT3YaNhSRKiUV9KHNpIwPK6uYyt7gfO3iltvS4DEibnQsMj3eSxj0kVoa+umS75nOzBo98gIaYhRt25TSjv3VSTRQIiEf4dvJEwrE8lMOaSLrPjmoAgkp3Ktg3PbeMcHUTjGR1TgRvLzHB8JFxCBwYD5erUbfHkA4I4/etV9m4+8QLh9ZL+FQJprz/Sje1ifCLAwkRZKriyjkpOurL68HF7AgX/7bo6GwZ2+lkUCJf9UqDMN+Lzts8pu0HA/NLV3c6lyoB9cqIAvWuf83iEiFadSKuhMH6/N4wSJ8qQ9hAucnV5fQfmfo5tnL5gjkbw+xNnOx74hDIlmLJyT6aJQu1TK
 p2/01+4q
 P2MqVKvOQk+PmwbOhV30QG+ME4hfKbJzDcjpwmI3B/0qBF4CLbKVzSrtgucFMLxz3h6Fmqq9DDvevCa0G0e/aijxbQ9Aoz6JW3/msOP/R+fbJk5UgmdGTG71qwjuJd4CJaLs2F1WO7bsG2rfbWlQg8zQ9dqx89934YL6m0V9td4zQRzV9SkQnW0zrMi54scSiGn68M/Pd+0sp2vXOtHcXBmgByjor2HtRBbQO9bAnSiPPBbYmIDEufJ0F6YQpGuUu93cxMEG/xgFURNYPUlWu+OijyKdxARHNrG5wR+jQ5fA0N+984f+pEsVOVd8GFqeTMHsNNTBNU5cIZ+b5+m8Woe6GTdsrgdwIdNt1+flwRNvbxErLyofJugrow7M9r555sbQvbP36T9aNKx/c3KmCJATazxWkyGgaeygKNzewnOmnHAHgGCBAr8N000ygTN+61Fae+QXfRDZUiCxfW5kpI0KCewHmgdssF1Zlcu5JkyRxmm+sAPYC4lVL26KMHgyF6GXsuic2pTpiie72LdS7tNmtFvu/oWLc/BdCfVcLcRTa1z7phsNdYmrJW/6lkgjjMR4gNKvSohZDA38MvKFn2I9fUEY/OYUb+2K/2zBseIem05xul+mnpi9aPwVAxOXRMHzBrphsPNsF2lUAV1yOydisXF1UUi/twbizphWUYKz2DNTEnKd0U00N5W33mIRp+8WATszAYxBqI8DrZJ9gNASjWNXlmcx896ShCBPiuZ1j6nP2ZKrV9NYcvO0gwr+4AICc8jlfMue3fYzt/m/PZhrzt6x4hwIMZQN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

QW5kcmV3LCBNYW5mcmVkLCB0aGFua3MgZm9yIHRoZSByZXZpZXcuCgpUaGlzIHZlcnNpb24gc2Vw
YXJhdGVzIHRoZSBhY2NvdW50aW5nIHRocmVzaG9sZCBmcm9tIHRoZSBVQVBJIGRlZmF1bHQuClNF
TU9QTSBjYW4gYmUgY2hhbmdlZCB3aGVuIHJlYnVpbGRpbmcgdGhlIGtlcm5lbCwgc28gaXQgc2hv
dWxkIG5vdCBhbHNvCmRldGVybWluZSB3aGljaCBvcGVyYXRpb24gYXJyYXlzIGFyZSBhY2NvdW50
ZWQuIFRoZSBuZXcgaW50ZXJuYWwKU0VNT1BNX05PQUNDT1VOVCB0aHJlc2hvbGQgaXMgZml4ZWQg
YXQgMTAwMCBvcGVyYXRpb25zLiBBbGxvY2F0aW9ucyBhYm92ZQppdCB1c2UgR0ZQX0tFUk5FTF9B
Q0NPVU5UOyByZXF1ZXN0cyBhdCBvciBiZWxvdyBpdCBrZWVwIHRoZWlyIGV4aXN0aW5nCmJlaGF2
aW9yLgoKVGhlIHN5c2N0bCBoYW5kbGVyIG5vdyBwYXJzZXMgd3JpdGVzIGludG8gYSB0ZW1wb3Jh
cnkgYXJyYXkgd2hpbGUgaG9sZGluZyBhCnBlci1JUEMtbmFtZXNwYWNlIG11dGV4LiBUaGUgbXV0
ZXggY292ZXJzIHRoZSBzbmFwc2hvdCwgdmFsaWRhdGlvbiwgYW5kCnB1YmxpY2F0aW9uLCBzbyBh
IGZhaWxlZCB3cml0ZSBsZWF2ZXMgdGhlIGxpdmUgc2V0dGluZ3MgdW5jaGFuZ2VkIGFuZCBhCnBh
cnRpYWwgd3JpdGUgY2Fubm90IHJlc3RvcmUgZmllbGRzIGZyb20gYW4gb2xkZXIgc25hcHNob3Qu
IFRoZSBzbmFwc2hvdCBhbmQKcHVibGljYXRpb24gdXNlIFJFQURfT05DRSgpIGFuZCBXUklURV9P
TkNFKCksIGFuZCByZWFkcyBjb250aW51ZSB0aHJvdWdoCnByb2NfZG9pbnR2ZWMoKS4gVGhlIHVu
dXNlZCBzZW1fY2hlY2tfc2VtbW5pKCkgaGVscGVyIGhhcyBhbHNvIGJlZW4gcmVtb3ZlZC4KClRo
ZSBVQVBJIHdhcm5pbmcgYWJvdXQgcGh5c2ljYWwgZnJhZ21lbnRhdGlvbiBpcyBvYnNvbGV0ZSBu
b3cgdGhhdCB0aGUKb3BlcmF0aW9uIGFycmF5IHVzZXMga3ZtYWxsb2MoKS4gVGhlIGhlYWRlciBu
b3cgZGVzY3JpYmVzIFNFTU9QTSBhcyB0aGUKY29tcGlsZWQtaW4gZGVmYXVsdCBhbmQgcmV0YWlu
cyB0aGUgdW5pZm9ybSA8PSBJTlRfTUFYIHJhbmdlIGNvbW1lbnQuCgpUaGUgc2VyaWVzIGlzIGJh
c2VkIG9uIDdiZTRiYzUyZmQ5ZSAoIk1lcmdlIHRhZyAnZHJpdmVyLWNvcmUtNy40LXJjMScgb2YK
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9kcml2
ZXItY29yZSIpLgoKVmFsaWRhdGlvbiBjb21wbGV0ZWQ6CgotIFc9MSBidWlsZHMgb2YgdGhlIGNo
YW5nZWQgb2JqZWN0cyBhbmQgYSBmdWxsIHg4Ni02NCBiekltYWdlIGJ1aWxkOwotIGEgVz0xIGkz
ODYgYnVpbGQgb2YgaXBjL3NlbS5vLCBpcGMvaXBjX3N5c2N0bC5vLCBhbmQgaXBjL25hbWVzcGFj
ZS5vOwotIGluaXRpYWwgYW5kIHVzZXItb3duZWQgbm9uLWluaXRpYWwgSVBDIG5hbWVzcGFjZXMg
cmVqZWN0ZWQgbmVnYXRpdmUgU0VNT1BNLAogIGludmFsaWQgU0VNTU5JLCBhbmQgbWFsZm9ybWVk
IHdyaXRlcyB3aXRob3V0IGNoYW5naW5nIGxpdmUgc2V0dGluZ3M7Ci0gemVybyBhbmQgcG9zaXRp
dmUgU0VNT1BNIHZhbHVlcyByZW1haW5lZCB2YWxpZCwgd2l0aCB0aGUgY29uZmlndXJlZAogIG9w
ZXJhdGlvbi1jb3VudCBib3VuZGFyeSBlbmZvcmNlZDsKLSB0aGUgb3BlcmF0aW9uLWNvdW50IGJv
dW5kYXJ5IHdhcyBjaGVja2VkIGF0IDEwMDAgYW5kIDEwMDEgb3BlcmF0aW9uczsKLSBjb25jdXJy
ZW50IHBhcnRpYWwsIGZ1bGwsIHJlamVjdGVkLCBhbmQgc3VjY2Vzc2Z1bCBzeXNjdGwgd3JpdGVz
IGNvbXBsZXRlZAogIHdpdGhvdXQgc3RhbGUtc25hcHNob3Qgb3ZlcndyaXRlczsKLSBzdWNjZXNz
ZnVsLCBFQUdBSU4sIEVGQVVMVCwgc2lnbmFsLWludGVycnVwdGlvbiwgYW5kIElQQ19STUlEIHBh
dGhzIHJlbGVhc2VkCiAgb3BlcmF0aW9uLWFycmF5IGFsbG9jYXRpb25zOwotIGEgY29uc3RyYWlu
ZWQgbWVtY2cgcnVuIHdpdGggZW5sYXJnZWQgb3BlcmF0aW9uIGFycmF5cyBlbnRlcmVkIHRoZQog
IEdGUF9LRVJORUxfQUNDT1VOVCBsaW1pdCBwYXRoIGFuZCByZXR1cm5lZCBhbGxvY2F0aW9uIHBy
b2ZpbGluZyB0byBiYXNlbGluZTsKLSBzdHJpY3QgY2hlY2twYXRjaCAod2l0aCB0aGUgaW50ZW50
aW9uYWwgQ09OU1RfU1RSVUNUIGRpYWdub3N0aWMgaWdub3JlZCkKICBhbmQgcGF0Y2ggYXBwbGlj
YXRpb24gY2hlY2tzIHBhc3NlZC4KCkNoYW5nZXMgc2luY2UgdjI6CgotIHVzZSBhIGZpeGVkIGlu
dGVybmFsIFNFTU9QTV9OT0FDQ09VTlQ9MTAwMCB0aHJlc2hvbGQgaW5zdGVhZCBvZiB0aGUKICBy
ZWJ1aWxkYWJsZSBVQVBJIFNFTU9QTSB2YWx1ZSBmb3IgdGhlIGFjY291bnRpbmcgZGVjaXNpb247
Ci0gcmVtb3ZlIHNlbV9jaGVja19zZW1tbmkoKSBhbmQgaW5saW5lIHRoZSBTRU1NTkkgYW5kIFNF
TU9QTSByYW5nZSBjaGVja3M7Ci0gcmVzdG9yZSB0aGUgdW5pZm9ybSA8PSBJTlRfTUFYIFNFTU9Q
TSBjb21tZW50IGZvcm0gaW4gdGhlIFVBUEkgaGVhZGVyOwotIHJldGFpbiBNYW5mcmVkIFNwcmF1
bCdzIFJldmlld2VkLWJ5IHRhZ3Mgb24gdGhlIHR3byBwYXRjaGVzIHJldmlzZWQKICBhY2NvcmRp
bmcgdG8gaGlzIGNvbW1lbnRzLgoKVjI6Cmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2tl
cm5lbC9tc2c2NTI3MDUyLmh0bWwKCk1hbmZyZWQncyB2MiByZXZpZXcgb2YgMi8zOgpodHRwczov
L3d3dy5zcGluaWNzLm5ldC9saXN0cy9rZXJuZWwvbXNnNjUyODI0Ny5odG1sCgpNYW5mcmVkJ3Mg
djIgcmV2aWV3IG9mIDMvMzoKaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva2VybmVsL21z
ZzY1Mjg2NzkuaHRtbAoKQW4gQUkgY29kaW5nIGFzc2lzdGFudCBhc3Npc3RlZCB3aXRoIGltcGxl
bWVudGF0aW9uIHJldmlldywgY29tbWl0LW1lc3NhZ2UKZHJhZnRpbmcsIGFuZCB0ZXN0IHBsYW5u
aW5nLgoKWWluZ2ppZSBXYW5nICgzKToKICBpcGMvc2VtOiBhY2NvdW50IGVubGFyZ2VkIHNvcHMg
YXJyYXlzIHRvIG1lbWNnCiAgaXBjL3NlbTogcmVqZWN0IG5lZ2F0aXZlIFNFTU9QTSB2YWx1ZXMK
ICBpcGMvc2VtOiByZW1vdmUgb2Jzb2xldGUgU0VNT1BNIGZyYWdtZW50YXRpb24gd2FybmluZwoK
IGluY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIHwgIDMgKysrCiBpbmNsdWRlL3VhcGkvbGlu
dXgvc2VtLmggICAgICB8ICA3ICsrKy0tLS0KIGlwYy9pcGNfc3lzY3RsLmMgICAgICAgICAgICAg
IHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIGlwYy9zZW0uYyAgICAg
ICAgICAgICAgICAgICAgIHwgIDcgKysrKysrLQogaXBjL3V0aWwuaCAgICAgICAgICAgICAgICAg
ICAgfCAgOSAtLS0tLS0tLS0KIDUgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKSwgMjMg
ZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IDdiZTRiYzUyZmQ5ZTBlNTVkYzlhMmUwMjMyYjg5
NDI3ZDJjNGI2MTQKLS0gCjIuNDMuMAoK


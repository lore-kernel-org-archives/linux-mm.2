Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B0AE83837
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 22:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5352E6B0088; Mon, 16 Feb 2026 17:06:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2F76B0089; Mon, 16 Feb 2026 17:06:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A556B008A; Mon, 16 Feb 2026 17:06:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 254026B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:06:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA362BE580
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 22:06:12 +0000 (UTC)
X-FDA: 84451703784.04.B9FBC1F
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013069.outbound.protection.outlook.com [52.103.20.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id B672740006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 22:06:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=UYGL3Nzu;
	spf=pass (imf12.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.20.69 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771279569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tpqH/5i1hgNd4GxLPvFuv4WLv7j+C0tV6bqhGX8O3w=;
	b=Iu9+rmsTfvFXLXYm7ADNGzo02feGX76PKp/00uxDKzoxdOrREhaWci9PZ4tL9xJGw+EZZM
	YPh+y9ajzEezdZUEYjhoFT3S2tnfdqFlZvU8UuNfaCl260xMgPGAqJbz9iFmntxvlwovx3
	+5inFv2ArkbcgrwHaLoiSkdEJEYpU/I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=UYGL3Nzu;
	spf=pass (imf12.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.20.69 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771279569; a=rsa-sha256;
	cv=pass;
	b=FsEE727eKjhLlL92uxpOV9Xm3SKy9pPGGwnxLo5dQnNEzcyqH56hLU3Yvlrt8mvGmn8r2t
	NBvSqR2X40HmkFRmJrhEB71DRCQb9RYkOXGqRe9gp1W6XV9h0Np3FtvC/Vzvl0ta85UzrI
	pRVLSVovpdUtfi7GVIn8ypnlfOAGUaM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PU55aFm561tGlZR3WlUGniAHgpbCeXAjCwCl//xNlwau24aRMzG5+Fcx9b6bvKHruKMKLRnEiMRO4VpAFp2qonhrwf+AiAc0L2/AcGq1K52biKMNfGmSMqjZBA1Fcsym/qbKNoQx6J+cVLLQEuCKMyF96MBVuZ+cKJmbJfquBKJnEOlnba5bKJuOlALv0gM1EE5t0qg9x8gKf9p8D1G+99vbo1uKXSQjOKfdaIEK4SrnzIZA/OUx4H3ilL3DYOH5EqyEtPh3LvxtOPAQks7bVurjLaqwGY3cw99kOeYwlOyEoOTaWmLzJWDlBjWElgPvwZZ12dOdxCgQElOJ3SeiEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tpqH/5i1hgNd4GxLPvFuv4WLv7j+C0tV6bqhGX8O3w=;
 b=j2fOwoGxtjGG0mUfP3dr6ZMEsOsFpXJzt5JNYLS7MnQDvaumFPYroeyi8vuettzN+1LmDuoBemwiUzLdGfr7SWiHcr3qCVVo0GOGY1IbQzL/60bkKfnfOHc5Cc6afM/OscnFAfXmgyYSjsYxFXLbSGmahyctnYk52KRHZmpqKFS3XMxIYx4/t5QpqiBSERBhtD16xqn6J9pBuvGHFHroP2zGOEI+4HjCOTSHTVHM0yKIwcaVLgLDVoKwAsVqdQASy8E4EL12ZvyaU7YTjX4Z6bPF1p34i67wxmA67hRpgNBIDYfTHlQbiz/jJGMiDSD19M6dMhLSGiNN66bKyIZSnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tpqH/5i1hgNd4GxLPvFuv4WLv7j+C0tV6bqhGX8O3w=;
 b=UYGL3NzuN2fRO5W73U6iLVO8J/6dSnYm8r1KN+p8okrEtf/pZeQT1aSrhB2qMinAg4CWy4M6EtFNp7bbge66zIZK27kcOlfBxL6Vg29IfTtrx8GaLfIWVIZ1cp4haOM1rzyiMK6aDicIAu1y8MKJHmUvLBFDKAoVI9Kj4RlEpO9cB/x9Rr5RoUdhnkFrwtLKOp2Nd0nIGbyMYKg6FvON9Tlx/KjDLzl/xtngImHBSSKXLwaVB+F+xRipsgDwB/bf/kXafe0/sjloY74nbhQTPKALP2THtNjhnaZGdu5YHB4EETkKOn9jCskbpqiW9j9sADvOzyDhNIYx70CH6c0jEw==
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com (2603:10d6:103:2c6::9)
 by SCYPR80MB6869.lamprd80.prod.outlook.com (2603:10d6:300:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 22:06:05 +0000
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82]) by CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 22:06:04 +0000
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
To: SeongJae Park <sj@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, "security@kernel.org"
	<security@kernel.org>, "damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Topic: [PATCH] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Index: AQHcn43UX2YXWKFY70OVjnptzM1AerWF4aA6
Date: Mon, 16 Feb 2026 22:06:04 +0000
Message-ID:
 <CPUPR80MB8171248D75CB3008172C50D9956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
References: <20260216185741.74145-1-sj@kernel.org>
 <20260216214712.68725-1-sj@kernel.org>
In-Reply-To: <20260216214712.68725-1-sj@kernel.org>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CPUPR80MB8171:EE_|SCYPR80MB6869:EE_
x-ms-office365-filtering-correlation-id: 10d9204a-db72-4047-dad3-08de6da79453
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|461199028|15080799012|15030799006|51005399006|19110799012|8060799015|8062599012|10035399007|3412199025|4302099013|440099028|26104999006|102099032|56899033|1602099012|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?idsO2YWJOQhAZy+Dy3Sc6cXzTLB+4EjrvOQCHxw1c4jL1S/RMC02fVsJRf?=
 =?iso-8859-1?Q?8pUkghZJlqo0sOgYIW24UL/ponwPZVwwEvEEtTNtg1Lj+DtD7rd1JrQJ5A?=
 =?iso-8859-1?Q?XIef/nLBbZVeBQLw8X5P6llLcKclmbjHAP9xgiXbGbSyi/NUgJNYK+XYB9?=
 =?iso-8859-1?Q?SzcNTFXgqCBMSEtzGVyC8GPVUElso9wvMxnwXOJyMu73+BsuG5CkRngAv2?=
 =?iso-8859-1?Q?DlG+X4x3Z6Mh0TVy7jNfHdYpvjsh0+VbUyBP7EOnAQWEJwsA5cm85gKzPz?=
 =?iso-8859-1?Q?7c20sIIcbpah8I4+ZSnZnA9N5JHD7QglV8izy5boDFnlBDm7bJe+Gmfjgs?=
 =?iso-8859-1?Q?GJEKt4oeg1MoATYZD43R0S5Y5ByD4Z88HpnsEIhhh2k2eRCmTs162i/Sue?=
 =?iso-8859-1?Q?EEjCK9dylSbQYHmEyrqxC+89Gv86cnG6GrSSkeMTNvOAxnMOUcM5RrKE3y?=
 =?iso-8859-1?Q?1iAqFnLGgscI3jyCsmf/n5Ubvm0bSXNWv+W5xxwr306h7TztLdVtAzDoLT?=
 =?iso-8859-1?Q?M6NT4Z6kQ2d1oJ9IkT+DK/C52XDChbZK/zlAJ5Pnwosi+v8i+P2RmvO27P?=
 =?iso-8859-1?Q?1z/f37wysDbi2LGDDDWUhwi3jhhx1xmg7hCakznONaK5eYX7Lk+T9xd7sD?=
 =?iso-8859-1?Q?TQnuxzGYWBahv6wcEYbzcr0yPadTEtsq2GYvCUz/sIjWpaYP0ofwO2Yp08?=
 =?iso-8859-1?Q?3XJL+AT9cK3mUfbcQmugba6tt5ybxfJ5LYIECn0O7AFyfbk51Ek+R6PRxa?=
 =?iso-8859-1?Q?zsJY717qU+8bjQgkH4qcKEeGmWAcsoIVNrNz0hCpipExxGtS15CN3/sKH3?=
 =?iso-8859-1?Q?xmFYG/JEHd6GlKAME4Tz1ro7q7+TRD9JoIMBYW3UDtpnKeaTH4EMqa5E99?=
 =?iso-8859-1?Q?JoCXQABFynIS2p/IykrqDrecX3LYfGbFR1Qxk+nFw/r8n30vIMenhEv7ZI?=
 =?iso-8859-1?Q?zon3Cv8R8ivxRpSrSkEFhHS2dVhAcSoSNNlbepzDB6oeEAEuC0p0ot1/I9?=
 =?iso-8859-1?Q?tP/v26kPYEJamXRo6Th9TWsRWk6vRuHZO74BSOdK7QaCwsTJdtI6lRd1QG?=
 =?iso-8859-1?Q?Ff8ViB/D2++wpkK3JtW8pV7tIeXi9wGhsW/JRebTTDTpu3MceNqlFLN8Gx?=
 =?iso-8859-1?Q?vvPA0NJUmFmu4Zn3cZcfWk8FqfNgmXPHBPuPgmHEsMErZCEG14iBlqgO0m?=
 =?iso-8859-1?Q?GD7pJIbc5eJWUMrv+qO/n2QglZVG7Pt6o2t9Fu+ddty4oq1GDk9v+1Tdpp?=
 =?iso-8859-1?Q?yvUy7jG1dm8BTNHvFeYupbPNCFEZmX9qqgrKeE5CPMAsn8pd8BoDpHYFbS?=
 =?iso-8859-1?Q?VW8sC3lsqjjrNyozbLY69KzGwErnth1VEMemD+HFdgakPee968mposyuLr?=
 =?iso-8859-1?Q?XJh63OyiU70hikzfWz7hqlCalnAy4hlKSAQC6o7yNXrWKGEQfcSZae919F?=
 =?iso-8859-1?Q?DCWTWxllXqxvLSp/?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?AhENa2rmoHtBF2Wo2yCXkilaY+O+h1Q846GAgpbEV7Q+bzLeV5VWmSTUUj?=
 =?iso-8859-1?Q?Bs9euBV6h5iqYPOMBS4mTRH1WGblGp7rB1d+BPjbQW2VpK/5Y7oZYvO0Fo?=
 =?iso-8859-1?Q?XceqWCfUgyu6SXzCLGMyB2iuBfUO8N3hMO9cQWt/oAo4mhqzu5OHAiTWMK?=
 =?iso-8859-1?Q?WSsecPJZCaJU9jc6l4kKN0xHgklgFp/7sj4AP9nzPFkW0LxV6eIdROnHt+?=
 =?iso-8859-1?Q?HM6lfucM3SS+kXBANTfZt76dTQ1nm0pFSspCLYDjA4u/zSFw6XzMqCkGFz?=
 =?iso-8859-1?Q?Iu687L6RpKuRmUqAoLdXD071uytpxPK869YvQnofyuCW/83Gk2uECEJH1Z?=
 =?iso-8859-1?Q?i6nzWL3fJiFmPMM96IjTyf6Gfwda+aeVxpzrOS8sssVfGk7GU7aLC2EbP0?=
 =?iso-8859-1?Q?RAjPohQw/WeGxugU150bILJf+8ID/OM7nTdbvJfTLcpp2hSiIig8u6Aekl?=
 =?iso-8859-1?Q?m0rwVg/I/FVniz4IvPBCj/U2pOSk0keGeMtzdNVZGDg8NweQYmoMOhedI7?=
 =?iso-8859-1?Q?NTxlbz5YBnuvISNWOA8mSbJve+4D+pJuWKWiw+Ar8ZmZd1v+XFEGgu4ksz?=
 =?iso-8859-1?Q?4PLz1y7iRTjXfBN47MyUCANd4wew8fgCePmiwBCPKTla9mvIf9/ojtacwE?=
 =?iso-8859-1?Q?X5jDIcK2LnlWWtAHLaDGmTnJEV7ohbMJRGYwAup1CtxnRVTD66Y8D1ZjZ8?=
 =?iso-8859-1?Q?rYOwzSc9cMGLRNKu9HFthH6ZRGNa9x7QdVeWbiRwwIPEYW/k1KwuvuIYP7?=
 =?iso-8859-1?Q?AI3YJ7tP4oEoNPhDadE1gHZAyI9U6jT7vXJuxh9Kuw6fI+6yLt67+96CQg?=
 =?iso-8859-1?Q?tBRThSVauzddPToY1FzvHezLRQSbv6uB55qst+kxqvYtth/dTWINKtBDaL?=
 =?iso-8859-1?Q?4dxHQKoMXkaibSOu/21/cfANCLFkRfInHaglgKZaC+fLvUyMWlZzajJorV?=
 =?iso-8859-1?Q?13wJhPbpWBenWl4TvrNlQjnIJdFXJvcyfdHKk1stlTHrgOeMxvoqOz66ct?=
 =?iso-8859-1?Q?aFOtvS96C1XXwCwpmFoBHxzTNzoYCqMSZ/FZ9e4z639O7zJjd/t4dwbjUg?=
 =?iso-8859-1?Q?Ow4uVQC0AqBYjZAx/FChzb1s6qSvSEFb4eT7uwhUCcwutvwV6BUPeVMndC?=
 =?iso-8859-1?Q?aT6dZ1UCmB59CjG1xglgWVCJKK+Fw9P0L8pucVhmv4wh9DorzMQdUhn9jZ?=
 =?iso-8859-1?Q?/fuLU8bprTu1GzixgqQt3b1HPdj9L+uWKAW0D6JLz4FJd9i3rWgFmAC4l5?=
 =?iso-8859-1?Q?ePDR3vdCia6KHg44RKdBDILsya/Qnfj5O9v8xUib1LMAxnBoMl0YOD2kus?=
 =?iso-8859-1?Q?FkBwopq/8zin15mcePwRGeaAh3gyHBqznygIBeJDty6kau7jqjvyDDF7Xx?=
 =?iso-8859-1?Q?xrjNrM8MmPeyF4Hp+xMEYDf/0aBIHF92elyM2Y6CEDKhLemyT8lTsJCDgw?=
 =?iso-8859-1?Q?CfBiB5d8QfSz0RxR8dJ/fOoyMFbyKwBvDA2zVtOX0kvpKHMrP5rCORk27R?=
 =?iso-8859-1?Q?Fs+2Wd3RCwh22jsvT9UJeT?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-8eed7.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CPUPR80MB8171.lamprd80.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d9204a-db72-4047-dad3-08de6da79453
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2026 22:06:04.8064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SCYPR80MB6869
X-Stat-Signature: a7eckcew9up7aeabrxzr68po4pgfx1dy
X-Rspamd-Queue-Id: B672740006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771279569-963027
X-HE-Meta: U2FsdGVkX1/Y/xdWhE+eNIvtPojzozpSvKA7GJYqNxKKNtZSUQSBDrI2H+jXIONPkUftc2SijtzY6ltXpZAduOGyphnRFKOn7goySnyO9j9s3jo8cunC1hEqYdztb2vhkwYUGzn86tSbaIrMG3dSfFLacexNX3e4RmCl5/aDqrvbKo5J0I7b6M8sv+ErlhPp8GYaoiXAdRDn+JcXhu60i/3Ff0Cn5aDS1t6GL+dJK+7xgSyflRQ9h0X9Wma095N31ZduZ7xtAwQZBMcIL3BwiGyWlC9J9aH+lf11kxFMygr9/SIlLIeOrtdSan6UhD8CYly5tfRYPb3iHqlmUOxhPX6fAKtYer6IM+MGKcowWRvETUVf9vpFRoB8I6EvR47jBWK88rokhKKxitAn+NLQ3Av2vl6LyV56HVzrnhB2yqHw592c4vSR8bm2CDFyItx3MHdKgLVEQQRdCRI6QQb/BUy+PPmrQz2jYgJUHH3GLVUJGZbZg39MciOBU3fPkij098Eo1RTBlmJy7V8vZNVWxtMF9C4H5ZT4hGzUnCPraq3Ec3Guy+sqd2UAUWHbNxbRH4Mozp7ggizszO4CRptMj2TiP9gubR4PHJB2APxIghLNN/NDIHopZP4w3F1vEhjZ6xz2X32ishgR0FZhZG9kdOzQ+c+/YITgUe18YGIm2rup5qwopBkqY7nAZx4kWtgsNmPQT6SIZFN/4Ge7fzPipsY5M029K3V51FW4SuIOEwvB5yZ2323vxDWroF6xqECWvpD56JxZY5A33Su38oK25YnhxkKCUx0xkmiwq7VjULNmdQr6HkRElneQ7GgLZ0jdGl+9gUkBJLYcCakOiMWNPhNhTOXhjKfN+kCxBLOzxMhmqPArCWYJNHbXDdSfnUg1dO+2tHIf378N0sbiYjEvsAL8RYIW9U/GYmA724ohLXf2uxfZ/mFm2/vyzLtkblytZ1exdk3r/dk4JS/IxQi
 g7p3drix
 ekCk2noNfW2GasNv3y51PmVUSLki9VmyskSgYI6DUIgSbZmHxu3xh7Vy+MWzicgOIQkfKpt/w4a5JRyqx6rqtPSBfeSXSk5Sfa5INwHXIgAeerZozja9S7HyaFF9Bo3zxI4niFrT/woHfz3Dkyyh4F4r4Ft7DubMbflUCB3hPaMhfD87bKpNcoW5YcxnTj6JIcq7APg4Dlz1p+Atw+TmUEj2krc6QyPKEJfIOAOtV9Y9gEyBDdFUdA6RlQjX5AjDn7bqIVJsgDQhKRGW9qRQF8SdDyKsQEqdapMqx5WwfpEIFhlQcANknoqqXNvH1NvZMQi2k8WtojcEuHl6CZ7YNsgeOlLJ535078Ry8q74v2azxLFayhm6CRBn6n04/oYdw1DTIMYFY3TDpNPPqB1pDxtSFk7dFGpatjLEuIGrPHI4BgzZNthJ0cnH5oMDWLjl08OGNakDcbpERr0TQQ32K4L3yKVcdj6kERWF+NYFLkDT0DMQRAErOltbWIU2VaMA1qYn1sJ44AFJZJxE2bn9wSSH3AIomaAbRjzv/sdqh6rwChJww1vAbkhiEiJzESmzUGXsz8qnzbxH5dYvENvZHAMBnjHzL5CfWVBAP6aoVbC07sm2TwJLpa3yt2JsDhyR/uG+UY/M/tB8N8urnpL698cBYSwhoJqOL/tqTJG61brsz7gTUpKeBMXXPVZZbNeZOXEELMhT8zRCtS1LwD16mFdB+Q4EOhxxeTVn0c485F1ey+Sg2MOEj+0zBGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.002655, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=
Hello =0A=
SeongJae Park, in my opinion there is no need for any modifications on my p=
art, I am extremely grateful for your help. Next time I will consider the g=
it point informed! Thank you for all the work you've been doing on our kern=
el.=0A=
=0A=
________________________________________=0A=
De:=A0SeongJae Park <sj@kernel.org>=0A=
Enviado:=A0segunda-feira, 16 de fevereiro de 2026 18:47=0A=
Para:=A0SeongJae Park <sj@kernel.org>=0A=
Cc:=A0Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>; Greg KH <gr=
egkh@linuxfoundation.org>; security@kernel.org <security@kernel.org>; damon=
@lists.linux.dev <damon@lists.linux.dev>; linux-mm@kvack.org <linux-mm@kvac=
k.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>=0A=
Assunto:=A0RE: [PATCH] mm/damon/core: dangling walk_control pointer in damo=
s_walk() on inactive context=0A=
=A0=0A=
On Mon, 16 Feb 2026 10:57:40 -0800 SeongJae Park <sj@kernel.org> wrote:=0A=
=0A=
>=0A=
> Hello Raul,=0A=
[...]=0A=
>=0A=
> I also found 'git am' of this patch is not cleanly working on mm-new.=A0 =
Please=0A=
> consider using mm-new as the baseline [2] next time.=0A=
>=0A=
> To ensure this is not forgotten and merged into the mainline, I added thi=
s=0A=
> patch to my tree,=0A=
=0A=
I forgot adding a link to it, sorry.=A0 It is [3] on my original mail.=0A=
=0A=
> after manually rebasing on mm-new, adding a note about the=0A=
> user impact, and adding the above tags that I offered.=A0 Unless I find s=
omething=0A=
> on this patch needs to be changed, and you mind, I will post it again aft=
er the=0A=
> current merge window, to make sure it goes to the mainline.=A0 So no addi=
tional=0A=
> work from your side is required.=0A=
>=0A=
> Nonetheless, if you prefer to make a new revision of this patch and repos=
t on=0A=
> your own, please do so.=0A=
>=0A=
> [1] https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR8=
0MB8171.lamprd80.prod.outlook.com=0A=
> [2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile=
.html#scm-trees=0A=
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/sj/damon-hack.git/tre=
e/patches/next/mm-damon-core-clear-walk_control-on-inactive-context.patch?i=
d=3D398e6f536b37de82f789d74ea93815dfcb129d99=0A=
=0A=
^^^ This one.=0A=
=0A=
=0A=
Thanks,=0A=
SJ=0A=
=0A=
[...]=


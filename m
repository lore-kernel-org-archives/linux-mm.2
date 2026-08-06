Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53708C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688F06B00C0; Thu,  6 Aug 2026 04:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FF66B00C2; Thu,  6 Aug 2026 04:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528B76B00C3; Thu,  6 Aug 2026 04:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3405A6B00C0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:41:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4740E1C0FB8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:47 +0000 (UTC)
X-FDA: 85070201454.23.7415E52
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011029.outbound.protection.outlook.com [40.107.130.29])
	by imf05.hostedemail.com (Postfix) with ESMTP id 185BE100009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=siemens.com header.s=selector2 header.b=VU6q8ab6;
	spf=pass (imf05.hostedemail.com: domain of felix.moessbauer@siemens.com designates 40.107.130.29 as permitted sender) smtp.mailfrom=felix.moessbauer@siemens.com;
	dmarc=pass (policy=reject) header.from=siemens.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUUd//HyCzvUlNIY6TeAXCkPBv3BSIIUXbqH9kKuVSE=;
	b=nxwf7BSD0NwwUEFIYScAFv64F9X1mzP8Z7wo7Yqe3jGQILZCWRbnxDddY5rdTZXJt6yPex
	2mCIVFZysn+g58XLOSBZ7q3Y/N0q9Kg6V3vj9d22wtJ8179Tcsng1zC7cZcKnouA3RLZaD
	YInG9qIlkhdWS4vYEDD9mMOvn3gjCs0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786005704;
	b=W0zD1bQJaaEtGpzVyNjDnQyV45lCNp+HPlEB18w12u0tWEiggQEkQpvhYdJ1PJGebL+GW0
	hY0vsH2s901e0olbx3Atw5SDzlGQT7kEu+F5L9CbbxXO8Z5bsFqQG1bu42kze0zPpgX2T7
	mGyFYIyg4RcJ/JwY7hk9QLq4wTI0Qn0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=siemens.com header.s=selector2 header.b=VU6q8ab6;
	spf=pass (imf05.hostedemail.com: domain of felix.moessbauer@siemens.com designates 40.107.130.29 as permitted sender) smtp.mailfrom=felix.moessbauer@siemens.com;
	dmarc=pass (policy=reject) header.from=siemens.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SduNFUVmiEdOs22H2kMDWvHl0JuwPw8NkB/cW+m/CfuEuf5jxTvOr7q+g8D82TZAPvrymmM+69o6Vrs/XDURoH8Bg9nwviZenIoLrb61+DL8hxsH6Ou7enVM3rbpLgjefRS+t6LAlQnJcHWaGa2LpODiqmfbvc62eFKpDjWkhMxB7tKfHPG38SEYpOMDjlZG4/b8Ci4Z7ABH3+/3Rkf0OkY2Drjfp3o4VYfIb4NbKPmgfMg/Q8TUvHEFGAGNe9kvUxOWrJU+Dumi1GNRY40i84tHBWZhAndX71KrJUMzDKgdcSvQwgqP/tM7o3vTtESxKMk+/1IhooHfisv8PIVbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUUd//HyCzvUlNIY6TeAXCkPBv3BSIIUXbqH9kKuVSE=;
 b=T7TQ1zo6O3e2Z4iytMb3lDkg282flohjkQhYiBcqaDbkD6EXF73uiy6G8PnvouAOBNjZxbL69t+4FLH94mOGbc2ighQszGVRx/ydLL7cSBwKSdJF4kQ8L94VPIAgEsIRfy0wIL2yNqwHCJIFs6JWY71nZJe+lPeBeZn4DqaavfhmZgkKzlV2hAofVlzewJ6jBA4TIuePlSZgNg8neDHjfLLNmjO3xsZRCR8YaiIUqRw128yMUYx70SifrOCP1JGMCGcuLdWFNzE81wMXToQpPjohNasQjaZZX1PDYApphQQLt5f1CnWRsqFvnBV+my+4jO6nnzxsDIUG9P6AfWdfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUUd//HyCzvUlNIY6TeAXCkPBv3BSIIUXbqH9kKuVSE=;
 b=VU6q8ab66x4u0vibjOLd/pFPGuF2h554eNucJB4oF5tBwNKH96NY87DSbgSOgAYmXGBCxKyp2C1OmRhdUGrEJuuomsUV32rmFQajavZgrOCH6mRRn61AqfFhwO+kiicPmhWGnes3DdHvhCfKGoTJ68UD/jAiY5IsoLErrW1GgI3cJcRUchf1nAE0f2VEM7Hh77/MeSs+hZcZubbZZnkoLEZtKwI8N13EbrS2L21RN7xAXXtCdki7VJ/gNAuEQo6tIJt8EeClFjSFV/cJMGELsvSOO+sp8538oDz+GUZN+alSSNuVcUhzMVCPhdvla4WMgWdwkDROxflRRKKdS+ZnUA==
Received: from AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:17e::10)
 by PR3PR10MB4144.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Thu, 6 Aug
 2026 08:41:39 +0000
Received: from AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c54c:ccd8:ebbf:477c]) by AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c54c:ccd8:ebbf:477c%5]) with mapi id 15.21.0292.013; Thu, 6 Aug 2026
 08:41:39 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "Guanyou.Chen" <chenguanyou9338@gmail.com>, Ingo Molnar
	<mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli
	<juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Andrew
 Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@kernel.org>, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook
	<kees@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>,
	"chenguanyou@xiaomi.com" <chenguanyou@xiaomi.com>, "linqiaoting@xiaomi.com"
	<linqiaoting@xiaomi.com>, "chunhui.li@mediatek.com"
	<chunhui.li@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] fork: fix default_timer_slack_ns inheritance from RT
 parent
Thread-Topic: [PATCH] fork: fix default_timer_slack_ns inheritance from RT
 parent
Thread-Index: AQHdJXx2P+8FdujY0U2DrEQ/qcgiWbaQs9EA
Date: Thu, 6 Aug 2026 08:41:39 +0000
Message-ID: <e1f1205d5b133eec3fe6a51a2c0f8f55749c7566.camel@siemens.com>
References: <20260806082009.144846-1-chenguanyou@xiaomi.com>
In-Reply-To: <20260806082009.144846-1-chenguanyou@xiaomi.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-10 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7PR10MB3956:EE_|PR3PR10MB4144:EE_
x-ms-office365-filtering-correlation-id: b19ed59b-c34d-4698-2f51-08def396886f
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|38070700021|10067099003|11063799006|55112099003|18002099003|22082099003|56012099006;
x-microsoft-antispam-message-info:
 UQanhyLLjjiHsiAeem6k2Whd2070M4vW4op+zMV5NdpKVMcSmO5WX8Nw/niA87qMtx+7RU+yNHPO+1zIyJK/l7Gq4x1wV4M8uQUr/WHC1AkIR+osN2DWsr/Yv8EfXxmOmoqsgivWwwMHOVBws/ohVsLo0iOMbUoFvfmkGKJsyP4NqCcQMCvrh//kjc1u262atqzMa9HTFjMWqmB9PSW9Zre338KqEsJz2D+9/rlJrSG28rTppGshFt2rgqPG8U/vCByGsMr+VzLCGK6zNsoq7sLr7w1RH2n6Trmo2+iWVT76cg698M7k6OyOJfk9LK4E2RVWgNJWi2xjjdZj1cLrHsHaAt/Vr6q2Jv0ECFWT8iZ2/H5gnEcYRu9hGAkjEqXZV7E3vDrXwEqNOgJUTybTw9V3+2R87s2IXAfrQnhq9cFhkUTRPvojoJp4HtQ9qqySmPVV8pEo8vyefyk5myQKiskvabU1GcRghfdSODE6IzNSYz590/Kg/RTVbPzu0VMlrMUf7g14XKiLel9LyDjm/1ZoAUy7AuDe836RDbGAXZt3UQvzoegOdI4gUoOdp1eU3MDcV2Dm3GbpmYTudT6UFVkPN3xlA8dGRVy4/UmBQ3YWWNx/rjmZUf25cavjprMr3PEt3+4v0YjvBjTyA0DU4mSNuc/2ecvAJp67GRY8mJxs9x69pfZZ4nb1g29MN/4iNtnjCdnXZGf0yWZlDad5nDSslnUL/fi2UMAtx0dHeoY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(38070700021)(10067099003)(11063799006)(55112099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zks0UDFpZXFnb0U2TjlJb3BiVDFiOVVQZHAzK0FEclJHbERIREEzK0llOHpp?=
 =?utf-8?B?ampRN1dyMC9WNFo4RjhMZ1cwcnRITXVOM2w4K25CbVhYZ3BFSzZHSi9JcGM2?=
 =?utf-8?B?WVpSVU9sZXF6YWlYSXhWeTJlUkM1MDMyOVBNOUZQdVRmc1pCM1AwLzdxQW9u?=
 =?utf-8?B?YXNrL1YyZlQrVGRHMThVMGlSZTk2TE9ud3IvbGVHd2ZwbDdpbTRNMW44akNZ?=
 =?utf-8?B?M29COFA2cDZrdUNXV0Y1ZXA5RTBzL1Y0VEFjMEQ5Mi9MZk9wdDdIZXFYUERS?=
 =?utf-8?B?WlpDRUZHU0krR3l0N0dWK0J6eUVtSENJQTk1UXdTVC8wVkNDUXFlNW8vUS9q?=
 =?utf-8?B?RS9oMy9PMEpnNGZOeGZQZnlDR00xSFlEZ1g5QURsZmpPS3I2UjhELzVrdTdR?=
 =?utf-8?B?bnhQZmxQZXpQOFVkL2RZQmc5RkF5bWFDK1d4bnNQVDJPR0R1NEJtUFVEaDNF?=
 =?utf-8?B?MHB1VlZrcmwwS3c1WVEySVhELzF4Y0RSQXBza2EvUFoycXh5eTAwRGx0dXFv?=
 =?utf-8?B?cHFSbFZPNGZpRldWSTRmbGpCUjRXMHdieUwveUFBcE42VzdmZ0xVYzlFM1ky?=
 =?utf-8?B?NlFXSFd4dmIxZHNCZXZNVERsOUprcXZzMXc2UkU0bG9wZTRPdzRZRzdUUU12?=
 =?utf-8?B?Rk1RZ05IOHJ1eGpmWjgvaGdXdUN2b2FXclhmR0lRSmxzUnJuYVFxRzY4MitT?=
 =?utf-8?B?cmx1cTRWdnArb2poai9uM1F2dy94S1ExK2hxb0gvQnBvTFk2L3NyZ1F1cUtO?=
 =?utf-8?B?Mm9ZcFdqR0h4U0pvYVJIRFd1MXJXQkxRNmQ2QmhnUmd6R2pNL09HTmYxemF4?=
 =?utf-8?B?OHFBVlBwbTdEd2trcnVwWlNyWS9lSytjODIxenF1UEdGRU4xMk9TMzRIdGFq?=
 =?utf-8?B?UGR4bHd2WDdLZDBKNmdHUy9kYWt6TDVMSmUyNlJJMWhMWlRGd254c2tmdHRr?=
 =?utf-8?B?SG1uNUU5eW50K2VnSit4Z2ZKaUc4eTBiQ0grR2lrNXQ2SEZpekxRelNKUnZn?=
 =?utf-8?B?OVhPdUg2RTVmOVhVUU5YRjM0UkRFeVZIbmsrZFN0cktmZCtqdG9GS2VPUEhM?=
 =?utf-8?B?SjA3ckt4QlB6cEROU2ZNenhrcXIwNDV5NEQ5S0tyblRydHRoVzVtRXp0Ynll?=
 =?utf-8?B?djNuSUt0ODlCRFcrVGEwNjNYUlNwYTlPa2NmRnc3SU9FeVVHVlNubWRzT1RM?=
 =?utf-8?B?WXN4WnFrWEU5dGo1Snd5TUM3dWU5RWhnUmdtQm1tdkNyN2N3amxhcFdaSURl?=
 =?utf-8?B?L0N3V2JGSjI4aWE5Qi85OXcxb1NBZStYamd6UWZGTWtGS3RSaEtNSExPUTV2?=
 =?utf-8?B?cmJ3T1VqcTBDQ3hHVWFIMDVWQWJ0R3E3TTNNL2I5WjJQR3U5WU1xSEk2c1pS?=
 =?utf-8?B?NTlvZm1iMGJCd0RxQmQ2WTRGdU1KR2hzbk9JUEs0T3YzaEkxRWVzbzRnUWVO?=
 =?utf-8?B?MnBFTTJNS3dLNlZPRGdlcUZXSTZjY2lMcE1tTVlWR3dUbDdZNDVicUpXRDRQ?=
 =?utf-8?B?eTNQSzhDMlB3S0RoYkNTRHI1V1hLNEtuWXE1L1QyY3FXMjErWnJST2JucDFa?=
 =?utf-8?B?eU83VFAwNzJROUJnekRyem9VaGZSVzlQanJYbUFVL1lzQVl3K1RUWWxxcS9t?=
 =?utf-8?B?RTRLUjNUVVB0VG9YVXFILzZWVW9MN2ExdVBKWDA0V3hla1lUOG9vOXJuSzBC?=
 =?utf-8?B?ZFRBTjBqRmtMeTNQVlh2LzE4UVJsa2N1eWZMNkdENVNPMWdmL2dTY2Y2dXgr?=
 =?utf-8?B?MklVOXJIZWFLeUlrYVhtTmk0YWhVMjQ0QUEyalBOaWtMQnYxS3d2bUl6RnVZ?=
 =?utf-8?B?WFdrbXhQWWVzVUlqYm1xUDRzd0hFR2xvd3BmenFKdVJJVjZxNnZ0SGhidWts?=
 =?utf-8?B?WDF3V25xdklxVjdCeVY5VTB6N1BIRjJJQkF5RmFoMGlxQ1dVVHNmYktVU3VV?=
 =?utf-8?B?cTdBcWZncGZnWUE5UUJJNWVoejJ5NSs3SFR1d3VpRk81dlRlZzJ6UGhGOHNv?=
 =?utf-8?B?QTFVRm00bU54MEI5V0lkTXREWW4rVlFyY0ZtcmFINXhVZE5QQU9hQjBNYkd3?=
 =?utf-8?B?YjNXbGhKYk5MLzVaK0MzZ3NiM21UVVJXNTE2a0FxcWVUb1pQRlRLTHdwMjRP?=
 =?utf-8?B?eWJ1dnFnYk9zZHd6dHZ6WVdXY2dJV3VPcHNRb2xtVWs2YnUvMXoxdjQ2UFBz?=
 =?utf-8?B?WFhIUjBhSU9nYTV2TnBPcG45TVBBYU9RMDdHaDFmdXlrZ0d3eXJuMWZLa3Jy?=
 =?utf-8?B?Y1dTcDg0T1FYdFpkS1JwZlZDRC9aRUxRNVBkNTNqVTJ6bER1RzVqQkhpeE84?=
 =?utf-8?B?SllOV3ZHQkpKbHhZbnRtZ1lpNnRLYWl4VlM2b2xpMGFUZ0NZQVRERlU2ZUx2?=
 =?utf-8?Q?gGrt4sVkvTOT4Y2Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C074511ACF13D459855B5D48C594E1F@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b19ed59b-c34d-4698-2f51-08def396886f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 08:41:39.2237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MyaAcDtLmBdXdDuC/H0FwzL/KglsUpT7YTso/ZJ8z4w6zoW2/pGDpLb3H96iiGURQ0OZE0vYKBVAecHRc1wEZU6N2cGk/wZjNiOLfSufjKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB4144
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dwcpjfwhpwy13fgmg5psuy81ts99bj7k
X-Rspamd-Queue-Id: 185BE100009
X-HE-Tag: 1786005703-576259
X-HE-Meta: U2FsdGVkX1/yYOor0G1AbYpVSPOrFK6gVqvOKRnydLX0ZYFdAj9/tQOX68WEvI0QTeySEszPmXogLmsuqe4PriXcCcelMiR0J1N41SL/UNgHxvCzAc524zlEcATW7Zmvf8xZgWRdQFbYS6ZsAG/DZtOYdfm7kW5GaXmf41E5CM4hxk/QBtVTY5ohBEIcvP1Yz30oesZ0aNcW04f+l07do/IFM6Z+oeDlfBU/Mmzlj183ivTQzOtYpYzKKEzoLPAKNUdoZaBWOQeWqBjRFsTjEHvQnHAJDg/LIzHnH3K6yo/oCOHwqAQ/tKTztkw6jwbS/7RH4ZVjk6NNZA0bgLJkUjSLRwXnfcbPtSm/NgeAB6m8ri9N3R+i1ZWYSU0j1X6me3wsgfJ9SRqeYTeYn9uJfFZvFj+IUs+doEZHNkNJECND3jrqmQYATBc1fEcmAYfE1Fnk3vaJTWCAyZnKjE34bq5ObKqfE4prUDAEbjKk/ZAJp6usCDBH88NMsmpGasV6YldBidCrOlExJrNfJcvkdlqRig5aAGyuw6A5FUamPw1/GeAuNiGVB2omR3otW8i8KsHrxiE4+hJO9kSxBb7uRSOkT+k6jS3221LF4i5UmOYibJvLHTnpOl7Q7n3Lcb6iX9fmOVaxsM2nC9hAu5Nh7Y8HRDhD13Y4MDJb66jzIUS6Hc2zWTVEMKzNWg0kI5UAlXpi1UKNff6i6PvEeQRWL8BadnE0Hv+dsyozugN2fsbdDjj12M0v+v+ceWd58QMhWh+H6F8vncAH3hFLlvLTRKh3b+9mo18dnVYJF7ocou1FYwO5JRiNpWoh+Ve+/v/mm2pxw9tCdyr81Cf3cHmwiIf0wqC3urHRIA0lDFKa28C1WOwtm1vQ9adgZgIAXnI4pxWggDhxniyNiIDLyi8O3IBjFVVIELp14ag90V6L+WBr95JBMcuhXIhEWQunCf1tp2dcDrdvuxXZKr9l6CW
 1zaf/f5c
 1ZENxmxv5i9USr7++Qg+gHtqM53RQMVzUUutGWfeS80UnCLoESr0MLhZdhqNstccZJJKZDAYUwWmZpDNisMyPXZqGv4XrcD41PrVQusBULCWkbcshTJO8AsxajWwMX3nfEwKBVd89jaWZ5FIhJ/HGvYSFMbV1auwTsIVqKL11PZ9e0zKzJgr9L3K5BCs3jNAGWP2/MM2qjPB7tc666ySA3BTUj7zwFmHYvReVJVumJRH593i/LYjvawlFCERCOWFj9syoHKaAjIQ+95mg2lVfzSiqb9rh8b0NkzS3EcMOMUoipVNE7+hp9zmIMxgq39SPNlxG1UoHYqWOkTfwpp1T1eZ0CSqV8LDmNGCdixRX4ubnvWWakLVYN6YaGcDkxTsd6G6FJqSGyeYmyMsP3IvP6GHjr5GmTAOYKeD5ziZDBN/G/SEMlIhzr2Q41o+gCU7gAl97xCrSD+Wovxn70pM3RHmHpLeqFRfKBsIIM/4qOreuLLuo4pxUsH3UeAm9cwNOpFCxCj0zGAvdfpQA2AG1VU/eetpnowjCKOrlQtlzSEBPRPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA4LTA2IGF0IDE2OjIwICswODAwLCBHdWFueW91LkNoZW4gd3JvdGU6Cj4g
UGVyIHByY3RsKDIpLCAiVGltZXIgc2xhY2sgaXMgbm90IGFwcGxpZWQgdG8gdGhyZWFkcyB0aGF0
IGFyZSBzY2hlZHVsZWQKPiB1bmRlciBhIHJlYWwtdGltZSBzY2hlZHVsaW5nIHBvbGljeS4iIFJU
IHRhc2tzJyB0aW1lcl9zbGFja19ucyBpcwo+IGZvcmNpYmx5IDAgLSBub3QgYSB1c2VyLWNob3Nl
biB2YWx1ZSBidXQgYSAibm90IGFwcGxpY2FibGUiIHN0YXRlLgo+IAo+IFdoZW4gY29weV9wcm9j
ZXNzKCkgc2V0cyB0aGUgY2hpbGQncyBkZWZhdWx0X3RpbWVyX3NsYWNrX25zIGZyb20gdGhlCj4g
cGFyZW50J3MgdGltZXJfc2xhY2tfbnMsIGl0IGluaGVyaXRzIHRoaXMgZm9yY2VkIDAgZm9yIFJU
IHBhcmVudHMuIFRoaXMKPiBjb3JydXB0cyB0aGUgY2hpbGQncyByZXNldCB0YXJnZXQsIG1ha2lu
ZyBwcmN0bChQUl9TRVRfVElNRVJTTEFDSywgMCkKPiBhbmQgc2NoZWRfc2V0c2NoZWR1bGVyKCkg
YmFjayB0byBOT1JNQUwgdW5hYmxlIHRvIHJlc3RvcmUgYSBtZWFuaW5nZnVsCj4gZGVmYXVsdC4K
PiAKPiBGaXggdGhpcyBieSB1c2luZyBkZWZhdWx0X3RpbWVyX3NsYWNrX25zICh3aGljaCBwcmVz
ZXJ2ZXMgdGhlIHByZS1SVAo+IHZhbHVlKSB3aGVuIHRoZSBwYXJlbnQgaXMgUlQvREwuIEZvciBu
b24tUlQgcGFyZW50cywgdGltZXJfc2xhY2tfbnMgaXMKPiBhIG1lYW5pbmdmdWwgdXNlciB2YWx1
ZSBhbmQgdGhlIGV4aXN0aW5nIGJlaGF2aW9yIGlzIHByZXNlcnZlZC4KPiAKPiBGaXhlczogZWQ0
ZmI2ZDdlZjY4ICgiaHJ0aW1lcjogVXNlIGFuZCByZXBvcnQgY29ycmVjdCB0aW1lcnNsYWNrIHZh
bHVlcyBmb3IgcmVhbHRpbWUgdGFza3MiKQo+IERlcGVuZHMtb246IDYzYzFhMTJiYzBlMCAoInNj
aGVkOiByZXN0b3JlIHRpbWVyX3NsYWNrX25zIHdoZW4gcmVzZXR0aW5nIFJUIHBvbGljeSBvbiBm
b3JrIikKPiBSZXBvcnRlZC1ieTogUWlhb3RpbmcuTGluIDxsaW5xaWFvdGluZ0B4aWFvbWkuY29t
Pgo+IFNpZ25lZC1vZmYtYnk6IEd1YW55b3UuQ2hlbiA8Y2hlbmd1YW55b3VAeGlhb21pLmNvbT4K
PiBTaWduZWQtb2ZmLWJ5OiBDaHVuaHVpLkxpIDxjaHVuaHVpLmxpQG1lZGlhdGVrLmNvbT4KPiAt
LS0KPiAga2VybmVsL2ZvcmsuYyB8IDYgKysrKystCj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEva2VybmVsL2ZvcmsuYyBi
L2tlcm5lbC9mb3JrLmMKPiBpbmRleCA2NTExM2EzMDQ1MTguLmJjNGRmMThiZmQ5MCAxMDA2NDQK
PiAtLS0gYS9rZXJuZWwvZm9yay5jCj4gKysrIGIva2VybmVsL2ZvcmsuYwo+IEBAIC0yMyw2ICsy
Myw3IEBACj4gICNpbmNsdWRlIDxsaW51eC9zY2hlZC90YXNrX3N0YWNrLmg+Cj4gICNpbmNsdWRl
IDxsaW51eC9zY2hlZC9jcHV0aW1lLmg+Cj4gICNpbmNsdWRlIDxsaW51eC9zY2hlZC9leHQuaD4K
PiArI2luY2x1ZGUgPGxpbnV4L3NjaGVkL3J0Lmg+Cj4gICNpbmNsdWRlIDxsaW51eC9zZXFfZmls
ZS5oPgo+ICAjaW5jbHVkZSA8bGludXgvcnRtdXRleC5oPgo+ICAjaW5jbHVkZSA8bGludXgvaW5p
dC5oPgo+IEBAIC0yMTMzLDcgKzIxMzQsMTAgQEAgX19sYXRlbnRfZW50cm9weSBzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKmNvcHlfcHJvY2VzcygKPiAgCXJldHZhbCA9IC1FQUdBSU47Cj4gICNlbmRpZgo+
ICAKPiAtCXAtPmRlZmF1bHRfdGltZXJfc2xhY2tfbnMgPSBjdXJyZW50LT50aW1lcl9zbGFja19u
czsKCkhpLCBJJ20gd29uZGVyaW5nIHdoeSBpdCB3YXMgaW1wbGVtZW50ZWQgbGlrZSB0aGF0IGJl
Zm9yZSwgaW5zdGVhZCBvZgoKcC0+ZGVmYXVsdF90aW1lcl9zbGFja19ucyA9IGN1cnJlbnQtPmRl
ZmF1bHRfdGltZXJfc2xhY2tfbnMKCmFsb25nIHdpdGggc2V0dGluZyB0aGUgZGVmYXVsdCBfdGlt
ZXJfc2xhY2tfbnMgb2YgdGhlIGluaXQgdGFzayBhcwp3ZWxsLiBDdXJyZW50bHkgdGhpcyBpcyBu
ZWVkZWQgYmVjYXVzZSB0aGUgaW5pdF90YXNrIG9ubHkgc2V0cyB0aGUKdGltZXJfc2xhY2tfbnMs
IHdoaWNoIGlzIHRoZW4gY29waWVkIGJ5IGFsbCBmb3Jrcy4KClRoYXQgbG9naWMgZ29lcyBiYWNr
IHRvIDY5NzY2NzVkOTQwNDIgKCJocnRpbWVyOiBjcmVhdGUgYSAidGltZXJfc2xhY2siCmZpZWxk
IGluIHRoZSB0YXNrIHN0cnVjdCIpIGZyb20gMTcgeWVhcnMgYWdvLgoKRmVsaXgKCj4gKwlpZiAo
cnRfb3JfZGxfdGFza19wb2xpY3koY3VycmVudCkpCj4gKwkJcC0+ZGVmYXVsdF90aW1lcl9zbGFj
a19ucyA9IGN1cnJlbnQtPmRlZmF1bHRfdGltZXJfc2xhY2tfbnM7Cj4gKwllbHNlCj4gKwkJcC0+
ZGVmYXVsdF90aW1lcl9zbGFja19ucyA9IGN1cnJlbnQtPnRpbWVyX3NsYWNrX25zOwo+ICAKPiAg
I2lmZGVmIENPTkZJR19QU0kKPiAgCXAtPnBzaV9mbGFncyA9IDA7Cj4gLS0gCj4gMi4zNC4xCg==


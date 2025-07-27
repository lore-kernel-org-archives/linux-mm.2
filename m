Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9BFC87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 12:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88AE6B007B; Sun, 27 Jul 2025 08:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39A26B0088; Sun, 27 Jul 2025 08:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01366B0089; Sun, 27 Jul 2025 08:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1DDD6B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 08:03:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DE281A0136
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 12:03:10 +0000 (UTC)
X-FDA: 83709908940.17.F0A0BEC
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021121.outbound.protection.outlook.com [52.101.100.121])
	by imf04.hostedemail.com (Postfix) with ESMTP id 32FEE4000E
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 12:03:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="ij/TU2oi";
	spf=pass (imf04.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.121 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753617787; a=rsa-sha256;
	cv=pass;
	b=V7Hc+S1qkENRM3aoPG8K44LqdGPA6oSHwiHbzWFxEitXStihJs+pgDaFmomSM18tZs2s8f
	x69ZjJrO/Kj/dGcNKzoie0Wwy4V5da9YP9r/Xc8h2fj3glMeK25aVbkXYKidery6Ge02+b
	BWm34du+jXzLUqNqEYK7TPi0gGCkiQ0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="ij/TU2oi";
	spf=pass (imf04.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.121 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753617787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCTd8Us6jbI+bsiDZASIu3uQiGBB6WczkzdcvaglY94=;
	b=y7hHY4fDoCI8/hG9z558+1EmeoU0nsG5mTegI15XgXBJWH6e1vLwRscmYQ0sD7cJE2pWK0
	dhqbhmgsMOrL01geMcNKBS20JZQYV/xSEH5gDQh7l23EcYWIjObZYQPMHbrhurtvjwVAvn
	Cy4+4EzADSeMys7pQskAr7H4qggO43o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PSG2LBKmPNuCf0FKRKCVpi1t3bReipKGWrnqPiEIzEj+COqwjPd1zcqD4xD0mhmQBOmix+MhNgaGDkkbz5OPdGLP53X87XFQiI7st2xpnuCSDiatohE0gZh1RM2hX97NydhfB1mHfpl6YjIZHaO8VdUZITNUxii8xfXDGhogRRzAOhmK/QtKxfvmIPCWjpkgqv5HDIphQU4RjAATvAhiFkAtd6+tX1UctSiorpw5mca4eGCj4A8HlQLsG6PzJ9xP8Iv6HqyZMLi5hEXt6EFaW6tEFDpzTYH4cmoPmIice5tUQt2ma0nMA/reeErgi+2UJs6HKtzDUf5p/3z+tXKOhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCTd8Us6jbI+bsiDZASIu3uQiGBB6WczkzdcvaglY94=;
 b=UIH3iP5FrGh3aV7DeT/t+YNgwj0caPqIMjrXpo50oVyIvSZn1tIHWe0vDo+Y1lBysiFVjsVPBoGqboQbjM2h4jdsPTuyLr0Fdo4WxPHy0ohg7jwh2qoTNb609BbWiCwlqsJv9B9Z3BCG9lSPCgIvymlaw0zpEJNeN01KTsyNjFh2dawTCCVV4bf0Ihhz4e2CKVIlI4vpyoZIYOoBBRcOt8fAh3/vmWxwqaAwAbvBjZU0a+o3zRm/hqbnOayEAKClvT9gLHGae/JTIQlLMSeu92DaKTQgFZ21BLMwLam/leCFSiKTsx5umbn01ctlCoC/ZfwWIZ9lHKS9Z+Sf2k9bGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCTd8Us6jbI+bsiDZASIu3uQiGBB6WczkzdcvaglY94=;
 b=ij/TU2oiNvX6ecmRZ47C+5NRgq8yth9eJ24JwYQ5ktudCWhPIjJPC33EhJjoKlfjyNBPVsY9JnvGHoba7XZGrrneDPZq4gNBPT3gWYxHu+FPrfbkiEpUDviwOl6mvj+V6jyGRbvyiagmUC+n/UMOoWKlCXi31JbdCpLEnERpFbo=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWLP265MB3073.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Sun, 27 Jul
 2025 12:03:01 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%4]) with mapi id 15.20.8964.025; Sun, 27 Jul 2025
 12:03:01 +0000
Date: Sun, 27 Jul 2025 13:02:57 +0100
From: Gary Guo <gary@garyguo.net>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance
 <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
Message-ID: <20250727130257.3549ea3c.gary@garyguo.net>
In-Reply-To: <CAH5fLgjB7-xJ2OjVa6nxnUPk-1+wyxPMWQ15-Vc3mUp36+_Rhg@mail.gmail.com>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
	<20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
	<20250726165020.46880c31.gary@garyguo.net>
	<CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
	<CAH5fLgjB7-xJ2OjVa6nxnUPk-1+wyxPMWQ15-Vc3mUp36+_Rhg@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PA7P264CA0241.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:371::7) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWLP265MB3073:EE_
X-MS-Office365-Filtering-Correlation-Id: ab591c3b-422a-4fb9-6152-08ddcd058912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzdrTVZhd3plV09HK3lHd2ZrVFFvcDhUclY3V0FxVDdLaE8zZ1lveWV1enRG?=
 =?utf-8?B?bElIS3hQTDBnbjFrMUV6dDZxSXE0NEY3ZUN2Q1haeXIwWXlCNlYvNk9yKzR5?=
 =?utf-8?B?QkNzRFRxQnlreU1VSFB5bitURXh4cmhxOHNCcC90OWZ3eEVDaHVMWm1vcjhi?=
 =?utf-8?B?aDh0YzZzWFV0NHcyWk5RTE1EQnA4cnZ0STgzb0tFQzJRY0RncXJqUVlZbWlk?=
 =?utf-8?B?dU9TZExkOU1seTBPbFk1OUovQlpmZWtVV25uNzJ4OUMzdmc5ak1SdmtCQktQ?=
 =?utf-8?B?bWE4dXdpTWNqc3NKZFk2RjRRbHh4Wll1K2QwbHdia3VmN3JmV1p4QUI2WCtr?=
 =?utf-8?B?QkRTekZtcTUyb0p4WkMzWVNPdFRVTkZTUCtBMHc0R0lWYWpteG1RdlBwYjBh?=
 =?utf-8?B?Zk1wa3lmd1dmR3cyWmpYdFBsS1Ewd2hEcWFlOFBmWFA4ZWpQd0wwajJKQjlE?=
 =?utf-8?B?c3FWeDhDTjJLRXNVdmNqSW1wbXN0UVU4VGNTY1RSSTdhUUczbHF3ZXBzTG4x?=
 =?utf-8?B?TldkY09jVzBESlJjUTVaM0pSWHdFRFA4Z2hEbWdWOFV1OGZHNExGUHo5N2dD?=
 =?utf-8?B?VlBUNHRldjJMcGhaWGs0QVB0THU2OG9OS3FWZG9mVzlUWHhiR0wrV3p5ZE93?=
 =?utf-8?B?WDdYa0E3eDQxcnNvQXF5emtPcDh1cUIxTkxWRUtiYkcvN0ZaNXJBOGlFem50?=
 =?utf-8?B?ZmpxU0NFcVl1bFlrQzJIcjRMdkh1VFR2UUV6VzZwbUFHc2U2UCtKOTZ3eHVn?=
 =?utf-8?B?VHZtUis3aGE1eWJIekRFbEhMdHRmNDNBa25ITVpEUzV0d1VyaDVlaS9iK05X?=
 =?utf-8?B?VmhWM0lQV2phSThIS3ZGeFRCTTFXYjZmQnllRTU0c21OTUFrc2daOVAvZlkr?=
 =?utf-8?B?SlNEQVd1R0RqZll0b0cyMWFxYmdIRkpFMTVMQk5wTGh1ZUQ5Qlk4a3NySEV3?=
 =?utf-8?B?Y3NCRGt3ZSs3dENTYmVERkx3OFdnamVRRjhTcUtDVnI5aWZWSWswSmphQjBC?=
 =?utf-8?B?T0hmaVJ6VFdneUFyVHJnMnp2amhvcVBSTlZyTFpnZGQ5Z2NZZE1UWC80aTVD?=
 =?utf-8?B?eWlZOVlRYTNaUVV6T2N2VjQ2U2RWdmZNMlNPdE54OHE4Qyt3YjYrOWVBL2E5?=
 =?utf-8?B?L3ZtR0lZNk9Ra0ZuQ2x1eUF1SENjSEExVXhPY0dLNU8ySVE5ZUlENkZnZ2dF?=
 =?utf-8?B?SWdtQzh1UnlQaDlIRnZYNWdIa0t2NzUyNWo3RVVlaHZYOFhkbWVsT0pHNUJB?=
 =?utf-8?B?SmU3L1hPc0VMZjdhN0ErNEE0NlFXaDd2RHNjMGdVb3FnMFdidk80NXN4N3pH?=
 =?utf-8?B?UDJ0dWhFdERiL09oaUJBdnBGTm1GUVhTYUp2ZGc4T2RrdjY1VFJBaGlaRVhr?=
 =?utf-8?B?c2o5UXdTMkhLM3pxRWtzME1ZekErVEVyZ3ZJYzdJYkkrdm5idXZTZThiK2J2?=
 =?utf-8?B?NFlHRUZpS3VoMlFxTDVIRUk3RmJrMW1MWERFOVVBMmFsRloreVRDck5TRzVw?=
 =?utf-8?B?QktnMDJOMHJzaytLRXFFT2VGRG1RRWZMRzBUTm9XUmJMNFloQkx5UXRxOEV3?=
 =?utf-8?B?ZVZsZFRuc051dlJlZXNJaU85UWVwNTZOR0RqQTdJTnF4M3FSWGxTUmUvSUVB?=
 =?utf-8?B?YVJzVVRyN0tKMWtLWmVzUUh5cUpPN1UxVzRmSDNJMy9CMWJnVTIvbEI2NFI1?=
 =?utf-8?B?a0JFN29GK1ZteHcrdnJxaDU5YzhFcmtwaXhhQmNoV2dQVjI2dk5hM0Nab1ow?=
 =?utf-8?B?Q2xFWHczV0xPanlyVklIbE12Nk1jaE5MdnhBVUx5TnF1ZTQyWjZ2TkZTZnZV?=
 =?utf-8?B?TTdVKzlZOHJqNGFDS1BoTHlLRjRHeGZ1dERVUi9Rd2JrcENFN2RVNS9jTzlh?=
 =?utf-8?B?RUhNVVJqbWRKVm8vTUp1S2pkS0diMHdGaUE4VmJNaDRxYUVhUmsxb09yTU1w?=
 =?utf-8?Q?NbE2pGYSqhE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEU1Uy9iaXkxU21vOWlOSzFKZWRsZHZGcTNjdFFmeEEreksxYm9tcEZEaHhI?=
 =?utf-8?B?enFpS0NlZXZRQjZnMkVzOEprYjJsUFN6Y1YvSjVreHhzQ3I4ZWxvNkh4Q2pu?=
 =?utf-8?B?SWQ0OG1UL2RqWkI3eE1RTFJGUWh5ZnVFM1A0TGdWZmFsTmU3QTVQMGdUUGk0?=
 =?utf-8?B?Mi95cnNJQjRIb25QNmR5d3Bjekc3S0xkbHBQUFAxVXlaWGU2b2VRMGc3SVph?=
 =?utf-8?B?azQ5UDR4UXZ6NlN5N2pURld2SzBEaDdwaGQ1WUxldmFsS3hza2JNalBQaUdR?=
 =?utf-8?B?V1cyMUpwbnAwNTZHZWFURk5FQnlTYXFHYTRXSGdLVEViWE42eUJHQW1xcjRV?=
 =?utf-8?B?Y0g2Sk9sbzNrVmhnSU1IOUg2TVV3ckdSV2tZcDkzbVpLdmp2N05tWmRSRWJM?=
 =?utf-8?B?ZlNKNWJwVGtScVdkK2pKc1lQcFBCa29OMldIL1ZiQTVSUG9qVzA3K1JRSGk1?=
 =?utf-8?B?S1NsckRxaWtwTW9VZFdoZlB4c2NzT0tVQnltaTRRVVBNZVRRRDFpYjlJQ0s3?=
 =?utf-8?B?OGFtYTQ0OU5jZ3BFV2RHNllaVUx1bTA5dzdSZkVTYlVIMXZ5WHBXKzR2dkdV?=
 =?utf-8?B?MjRlaW1SWXFiNDFOOG5nMnhLcXhXbmZNWHc2Nkt4R2ZnK09RZEVGL3pHSUxN?=
 =?utf-8?B?Qk4zZ1FPSVNacVRHQ09MZU16N0p6TnZvbmtSTzI2NnpKNFFnaHhwV0hWTGtF?=
 =?utf-8?B?Y0plNUlNRExMREJlR1hmcmRWaE5VWmJhVmd1RDZ4bytqS2JEaHVENDlnRVNa?=
 =?utf-8?B?cEF3dmxWQmxmc3owczdVYXkvbTRYZUFhajI0emw5VjA0dEpnVDZLWmlLcWZG?=
 =?utf-8?B?Z2FsRzArS2pTcDJZekR4STYzOG1XcHZZa0NlNDBaNi93QUdJaGZ1Mnd4NFBI?=
 =?utf-8?B?ZVBySDF1cmpQSjdjejhlbTZqZ1VtOVpOOHlxT2NYVlBDREhmZ3dTaE0zQ2lD?=
 =?utf-8?B?TUlSSTJURWhFUDdLS24vUFVMaXdEeTBvL0czZVZZMWtOSTJUcVZ3U01vUHUy?=
 =?utf-8?B?dmdYZlpjaFF5YzBCN2MzNDNFRXl4UEo5LzJGcU5mU2V5Wnd5OG9aRURnUnFl?=
 =?utf-8?B?dVU2Q2RWd0lwNWY1MGk3MEZwd01CRzNITm9RMGxSRDRjdW1mL2dtdFdGRFY4?=
 =?utf-8?B?R0hSU0p6VkhVV29lK1M0TlZGNDRoYThBN2hyNjU4VWhXVzBiWHd6VndvUzhw?=
 =?utf-8?B?S3R1Um0wcHovV3Iyb2NWb0lkZDVEbWNrbWtKbCtScGVGa2ZRa0R4Sk5FMHI2?=
 =?utf-8?B?UUpMeXBQRkN1THlSZGtFbGhGOEtadXI1NGZ4d1ZBWFhlUlRXc2VRY1NJQ1da?=
 =?utf-8?B?djlBaHg4VDJuaWIvVkV1SnM2VXdXSktNQU80RjAzNzV1VlpLUlcxMEdGd3Ru?=
 =?utf-8?B?cUVEQ1g4dGZSQTh0WG5qK2ZURVQySHB0eWtMOHpNazYyaHN1enZUTU1Mb0k3?=
 =?utf-8?B?MzRrcTlOUmwyNFdTNGFNVzVLc3o5dlMxR2kwQzNSaDhpRmkvQUh1M05lWFhm?=
 =?utf-8?B?bEoySVMvN2JLS1hXN1Uva3FLbHFwSzFORmU2VHdZVmcvV0tDUTRyT2Jza1dC?=
 =?utf-8?B?a0dVMGV5UkRIdmtDMnMva1g1T1QvSUgxOGU1ZjV2NmdDc2VQVFNDeHJpREp5?=
 =?utf-8?B?WllDS0QxWnhPeEQrQytXcXhVZTFoWjJ3RXdQLzVRaDF3ZmZuNVBaNG01aTdX?=
 =?utf-8?B?UHJEREFMVW5CRXQ5VlFPNVlhd2xvOTdJaHVhcFlBenJPemVXTkdraWJYQ3lv?=
 =?utf-8?B?UTdQY2p5MGRKQlhmM1dNU1hWQkFSZlRtZ2tYWG16NHowTkE4WVNJZ3hhdFhv?=
 =?utf-8?B?UmNVR2pXNDlIVHdjTGoyVVF2RHEybjFNYzFzVE9HN1dsWXF0ZEdYZU9ZZDdk?=
 =?utf-8?B?dzJZeVlpWGJOZG9qVmNQV1BVUlQwaWJab2hlcGtKUi9waUgvK1BMMzQrRVM1?=
 =?utf-8?B?MzU5YVBDRlJTK2hmdC8rSjZvcXhVcDJvdWVubGZRQm1JVEZmanVIU1R0Q05Y?=
 =?utf-8?B?UG1xczJEWmpoVFN2NWZ6QWtSMmtnOG02ejI1ZCtsTE56Wi9JWVlKcnlIRkgv?=
 =?utf-8?B?Z0pEOXpMenVMcWhKb2ZwYkswVDBqZERCa3pUbVJjNkV2bFNxV3BPa3B1cmFT?=
 =?utf-8?Q?yfjl7lXNPDgmDQHO3cg+Wd1YX?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: ab591c3b-422a-4fb9-6152-08ddcd058912
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2025 12:03:01.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ea6QPhoUKlgEgR7ZpFXhaZe5ez1Z/g7qJ3MVK5gFf+o+FzsZ8PN7THiKadcruNSPXl6G0yg8Y+CFQ0R2qCYhZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB3073
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32FEE4000E
X-Stat-Signature: ui4pip3heweyruwyjw7wqhjhehafay69
X-HE-Tag: 1753617786-296805
X-HE-Meta: U2FsdGVkX1/gx/l7SQbMDeEl5Kaf04HO1s4NdtsNhe1zmmf6cJVCqVq1LKc8nvDRCIQTzvwqkvKNlko+DNR61U1gNFhjM9S+gJj0OP24HldR1ZvsTAF1nFvGGAxgji+Fn4OsgVmftnDy5Ma4nWlzTH+wXhPb8PkJDx+zocMMY0iLCt3Xe43sW0E3co/TdIKAoF42bAs0ufkskRiY66ScAzFk6Tm/GeiDwxEDf6WkrrAG3ubEDo/VpDxTknRQdBFMqsbWgPOqN9tzldqTkUPPtn8mGst+cAtmo96Hgzn+JvBhug2xPqQroV+c/CfhOIwUOXseBgXa1blKQpUQz34TV6IUYFVzkUz4hV5/uxQj617Bz+LEFDFdp6ctyqM0Wo9CcOwNX48409Dx+HtvHyYjcSyFZfDcVcHf2gpWc0cWKHp2xU4ZgJtem1K/V1ptzpmkfiRd9/hlcGpNhRVRKp6s8vA4B9lrrLiFoIoYv0DQ1m3yCcOR8kgO+4c2AVbvAEwOxsRYp8javs78tXRw0YwiPJd6gyOhhaUuHAfhdqH0nEpxy4A+p06LqzSv2rV2ZwVW9cR+nSj8LH3K6LbP1WV23vcdJ8vJbs5VYPkIBONrZOJe6+DPh6HDqpAPK8E8ia/dH30EfXveJ4pwhhd/tKNsyflGEIicBbsSwpmN2QeW4BeKVnW2492kyQ02dvURxg0jPyOMxDdYB2RzEl5y+RcJ8kbKWUeHYR2JaiWx8fDKzYRJKArC90J/uwmwunl6L40LsE8s6Xyc3esax74GEUUo2XK0tFW7A1103YKCoQ/STyGEmeENcilYVl9DLZWdNXY6/y72xJJz2L6vm9B8zFl2iYUqb8DpPXQvxIN1end5i6yKYnRCUV9ozF/m/5AYJwKjRqenbMoYvuCTaFy2mVA9FiO/d71BrYXg+LJipbn7XZw59XOuAbT0SuQkRplG10GwG2cC3iv/agSVZJCuqLQ
 DXzlI8r7
 JJhJsb8phr9Ii8A9XMSuN3f6mZmB92L71uz8Dw21vb6hFcCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Jul 2025 18:18:02 +0200
Alice Ryhl <aliceryhl@google.com> wrote:

> On Sat, Jul 26, 2025 at 6:15=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> >
> > On Sat, Jul 26, 2025 at 5:50=E2=80=AFPM Gary Guo <gary@garyguo.net> wro=
te: =20
> > >
> > > On Sat, 26 Jul 2025 13:23:23 +0000
> > > Alice Ryhl <aliceryhl@google.com> wrote:
> > > =20
> > > > To load a value, one must be careful to hold the lock while accessi=
ng
> > > > it. To enable this, we add a lock() method so that you can perform
> > > > operations on the value before the spinlock is released.
> > > >
> > > > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > > > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > > > ---
> > > >  rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++=
++++++++++++
> > > >  1 file changed, 94 insertions(+)
> > > >
> > > > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > > > index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5=
752b4f5337fb6277182d1 100644
> > > > --- a/rust/kernel/maple_tree.rs
> > > > +++ b/rust/kernel/maple_tree.rs
> > > > @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T>=
 {
> > > >          unsafe { T::try_from_foreign(ret) }
> > > >      }
> > > >
> > > > +    /// Lock the internal spinlock.
> > > > +    #[inline]
> > > > +    pub fn lock(&self) -> MapleLock<'_, T> {
> > > > +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> > > > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > > > +
> > > > +        // INVARIANT: We just took the spinlock.
> > > > +        MapleLock(self)
> > > > +    }
> > > > +
> > > > +    #[inline]
> > > > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > > > +        // SAFETY: This pointer offset operation stays in-bounds.
> > > > +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bindge=
n_anon_1.ma_lock };
> > > > +        lock.cast()
> > > > +    } =20
> > >
> > > Could this return `&SpinLock<()>` using `Lock::from_raw`?
> > >
> > > I guess it has the drawback of having `MapleLock` needing to store
> > > `ma_lock` pointer but the guard is usually just all on stack and
> > > inlined so it probably won't make a difference?
> > >
> > > This way you remove `unsafe` from `lock` and gets a free `drop`. =20
> >
> > I ended up going this way to avoid the extra field in MapleLock, like
> > you mention. =20
>=20
> Oh, and it also avoids assuming anything about the layout of SpinLock<()>
>=20
> Alice

Well, `Lock::from_raw` is designed to interact with a C-side lock:

> Construct a Lock from a raw pointer
>
> This can be useful for interacting with a lock which was initialised outs=
ide of Rust.

- Gary


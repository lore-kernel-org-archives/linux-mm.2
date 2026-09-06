Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2184EC79FA0
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 12:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67636B0088; Sun,  6 Sep 2026 08:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B189B6B008A; Sun,  6 Sep 2026 08:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFED6B008C; Sun,  6 Sep 2026 08:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACEE6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:47:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 031CE120547
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 12:47:48 +0000 (UTC)
X-FDA: 85183314258.29.0DCEFDE
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021080.outbound.protection.outlook.com [52.101.95.80])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C6CD1C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 12:47:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=M9rK7u+j;
	spf=pass (imf20.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.80 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788698866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ArJ/NwlKm5x3Wt4gtCx0trr8O6gWjwg7f6vKNrg66U=;
	b=HxC3OdUqovAFXXi+T3wapKO/TObYN8+CmJEEv5YZP485By0J9srooKED87LhmMB+4Xkvjz
	UR2Icos8Aa5bsniXJY3BedOTWKagk/mfRzxv4VKglxlLsa3ENob7px3EUtBPM9NMq8UUHf
	i/8yPkE4FX0riYAVG0xbxqMJtJEjLFU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788698866;
	b=MsoggLqkbvGMsy2c3Mu0GMImoSJwFVsnlnC1vBiRt/1Z5Z9uywmXCzg8Xh3qG8iY5hDHE5
	gJXHNqN1lBrVFnvKnWNHF5qqSPrUYz7+Km3jKeA3G4+G67f0SdBdVorEdS7xERVU2kNp5C
	iH2MTjJ+vnRQLEpj/S9SFvfRXICAn34=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=M9rK7u+j;
	spf=pass (imf20.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.80 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sk7OLRmLAWBYyfVnimqJt5s1fummg7XNBN/gcYheuRDpFMBeM6wFYLemwXf+gGiznCMO/Vqd42C9Pj4uIbZT/zO+dVN40+0nxoma1wDlSlr/luChz+BCcSmDPqBAVZX6tJEQyg6gHN9zHUYFbkby8lNgnFZhtsgdW9Tj+eW8j6iFgLzpV15nw4JHR9PVm9WqLKa+GnZFKa/BeMLgNe5DXYeQXWrtkMfpis24rXQTCh2czHxjAvLjGl0ocTzSBd9DZLNJX6UlaOkq/6icdHUiBs08vSFjT57gQlASSygBYwTrf47hg+apiU0EviHqM1rSBta5qo1ZXVwI545FS5txJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ArJ/NwlKm5x3Wt4gtCx0trr8O6gWjwg7f6vKNrg66U=;
 b=sx2AuA1IihNhBcvpDZFPj6sRKvlkL43OWef0VlPlafDdHQOPGpv1Qtq6X0JFcX4xekpKUdBPcfBVdUyfhds2zGqFmPLlMd/bj3xepdPfEt+HWr6ginsFO/KX1kIkPRz+TIpp8e0KN1Jjhstn2Zf2v6KNVHBHfXks+Ia9PtPy5bqAcfi4nJJ0qu11igEDvraDVDyH2WrdsGDpLhj2ml6B859wXhOlfvnmBwKyqwFzVZyNuXtExIdkI3YZo7w2DHliCJxarBxIWi1Asm74P5i97caThi/XeeLr3mSqu+MW+ATZcgv3tb5kDAccdpEgUbPSoHS0VJar7v7KIMvX6ZRIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ArJ/NwlKm5x3Wt4gtCx0trr8O6gWjwg7f6vKNrg66U=;
 b=M9rK7u+juZbyU9iu6NegEd7l23MWkhh8o+ki/KhOxHzATE1W1zJhujZ3XutHf0H1589NNABOr/dpYLi2H7C72oINZOwls4wtqBpL+i3ADYTHJLXKg7QiYIynKLhuqiasI5FWHy6+4NwFYKkfUUjDmfrtQjMHJHLkjAaM/oGrlHc=
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO0P265MB2699.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 12:47:43 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 12:47:43 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 13:47:43 +0100
Message-Id: <DL88TTRAVPIC.2ZQNHJ07179CK@garyguo.net>
Subject: Re: [PATCH 3/9] rust: sync: arc: relax `ForeignOwnable` for
 `Arc<T>`
From: "Gary Guo" <gary@garyguo.net>
To: <sunke@kylinos.cn>, <rust-for-linux@vger.kernel.org>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Lyude Paul"
 <lyude@redhat.com>, "David Airlie" <airlied@gmail.com>, "Simona Vetter"
 <simona@ffwll.ch>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <dri-devel@lists.freedesktop.org>, "Alvin Sun" <alvin.sun@linux.dev>
X-Mailer: aerc 0.22.0
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-3-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-3-e0fdbf8bd108@kylinos.cn>
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO0P265MB2699:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e51db0-f983-4630-4ed3-08df0c150b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|376014|1800799024|23010399003|366016|4143699003|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	UYsYKQ/Z+5lmnx7e1jnR/VVA3v9Q2/fT/8zOzfIZwZ7x3SNKotIrEMyMJ7BXuwduo14INQo9J2sB3bOJUQcSbD891wBfamd67ss+eGg3fOhQrVte+gUdNO+kbE+E0M0F2J7bb2EtUtT5kVs5cwYkwqEsr6zbtnVo27v4U+wG9Rxo0UNLptJBOyHIfnh5qmkRB9ohSBs9ETuBAvilZFpjrfkKtmzt3PmFi59IXk1+tA/0cK6LPTYFSBZdQW/uQaB04XfBvm6KyIlNYavKkr7QzydlcLw4BcG9q1MPscNyBGhQuHmYxqZ595Al2vxYqmnF2kZ5Xl2YGZR5bLbG3VnxbYcSChSJMkdWkMKjxk+oVgqAl7nZeel4nomXjbOzSL/HWXtS8OoZoUepxIgKlC2R+mPYaoQ8W6lWW6DOvuuaeBMymrKpLlUzVEfjnejiSkLh8oDbEmtHQa838zTBHZgymJFTuKNxY9c84kYYlHW0RRDMbPLOP6V6dmARHn5YhnQfqPHwdDTgCwcRGJilxnoW/1M+YH6rQ0Q/c0z/R1wn7svtAJ4P4M9tSOlasBZQXg7VySfkvxokA5DrkFuTzquj/CvGYluBNGL1d/Lz3SzzlVEeFO+6uAEmQ2NriDw2/aZPhF/2MF7Z+UY5ysft5v1yJAG/jKyCZlt20fPZeXp1s+o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(376014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjdKN2tEK2lnMU9ZcjViR016RnFlTnQ2SjM3VXpUUlNVOVA0Zll1WEV1NXR3?=
 =?utf-8?B?OFJWWmFMWW9jdzk4K2dBbk5PNUY3ZjEvclNWUmh1NWVyRTJTZ0ZWbllkWHNv?=
 =?utf-8?B?T3FDL2tFbnk2NG9KWTdCTW1DdUtFTE1xbTdWY0RvQ1ZiOVRZUlkxamNLam1a?=
 =?utf-8?B?M0svUDRkMzRBVXZ2Qm9GVmdDeXR0ZVN1aldDNFhPTGkycU91QlZTUnA5RjN6?=
 =?utf-8?B?TXBBOGEzcnRicjV5dUpkdXlnQm9lUHJaZG41Wkd0VlRjMVk1ajlJdERMamV4?=
 =?utf-8?B?WDFuRFZYRitCdldGUlY0SU5nTUZ1VytzaU5YSGZkUzlTMGR0V2lmeUJWeHNi?=
 =?utf-8?B?VTRlVEVVVVI3cURiVFZYMytjNWR0VW1lZURoNE9rdlNHMVNneEJ5WVpVc2tt?=
 =?utf-8?B?bmFmbjZ6SjV6UHZPYUJYRWY5bnVUMmZYSjIvOUQxZHdLOTRmQWwya0ViNlk4?=
 =?utf-8?B?Nmp1MHZubk50cDY4TlpodXNRWEE1NnFZek5ZNXlsTSs4QXI0V0x5bFFxcURO?=
 =?utf-8?B?ZmJISUxTTnBhczNsSVU1NndCaW9QL3AvajRyRHFXcDl3MlJWbkpHaUVaakNx?=
 =?utf-8?B?TjEwL01Jall6VkNoWlQxVEliK0VaZUJ0RjlVckdyL1hiUEpwaXFiSzU0UEVG?=
 =?utf-8?B?V1B2RXVuRDUzMnFYSkxWVXhJV0NNbDYvUkxmN3p3aGZiOExRTkNudmZTYTlj?=
 =?utf-8?B?RC8yN1h0V2U5OGlGQlZjendnYmphc3VVenl4OFFya3lLdDZidER0UWNrWmxE?=
 =?utf-8?B?RWNmV3l6WXlBaERUVy93T0NidkJKOVl6eTdCUjRHTUY0a25tcEFMenZ3MmJa?=
 =?utf-8?B?RDYzcEduMW9yN2hmY2YwUjZQY1hZUVNSR3llSmN1bEZFd3Yxbyt3UmFTUHhy?=
 =?utf-8?B?V21VY3VEejQzOTFYR21xTGcwdGYycy94ZzRhSFFKRFF6Q0dRSTNCdEQxVzU1?=
 =?utf-8?B?M3NkWGRvcGZnRXdrUVMyWW9DMlZZNUkwaW90VEIyakRHaENmSVVYKytudm9L?=
 =?utf-8?B?eHZVRzlnNVg4azFrcVNOOFhOdmtiQ1BCTzJFbmRLSGM1VlZvR2RtbFNobUJT?=
 =?utf-8?B?WDhYY0RwemFEUURLUmVFWEoydmNGYXUxU1dwVzY3amdlZHhPdHR0ejhEWUx6?=
 =?utf-8?B?Q2R5aXRQK1lSMy9ZbFVSdUtYbUhBUlg5Q3ZyZDVlTG1mWFM1TzNEOUZTR0xM?=
 =?utf-8?B?OEJmWHRXUVYxVi9BdjB3c1Rkb042YTZ0eHBNQjV3bHQydDNVSEpKbHM3cHVs?=
 =?utf-8?B?UmlNRTdZb3E0NG5MZnVsY2pOc3Z0YU5pdE9WRXRpckdlOVFDcWpESFpHK3ZD?=
 =?utf-8?B?Y0FudTRsM3N2L21kT2JxU0Y1L2R3dHpvY0lqbkpRQ2h3aDBzMmhMQUw3Lytm?=
 =?utf-8?B?RU9xMGFpZDRHS2VxOFBKWWN5b2ZmTlZTd3BiZDVFMk4ycElPSmFPWW1yTytG?=
 =?utf-8?B?OHZWVFZtVGF3eVB0NkVTS05UaUVWUUtONWxjL00wOTlpVzAxaVJoa21HRXVp?=
 =?utf-8?B?aENqTkx1c3ZDb29RMy92Mi9UZzFYK1F1cjQyVHJSeGRGLzhCbHhsVmVZNUhO?=
 =?utf-8?B?MmFMbG1xZGZhMTJJcHd0OEYwUmoyTTRrM09OV0lBK0U3aWI3aFRUVUFqOEhC?=
 =?utf-8?B?Z2VFSjNGcWVkMHhuOVdZSG5GRTBkQXo4MVJOVVAxbCtCT2VNK2ZnTmZ4dW1L?=
 =?utf-8?B?bGovaFRLNW9lSDlwZEdaNjdFOThTR1FMVm04N2ViY090UGNNK21oNU15Yk9a?=
 =?utf-8?B?dFZ6ajdIay9sdjgxaFRVRVQ4YjU3RzFPU2FHY0FFZ2d5K3M1YlZySnM0Q2Jo?=
 =?utf-8?B?eXdFVVp1TDFFd3VqdDgydmtKZFZJMkh2alMwY29vbHN2V01vT29JWG5TSDRY?=
 =?utf-8?B?NVNnZmFPbnRJVDBPWW55MEkzQWhVays1SmZDbSt4a1MrSmJBV0g1Vmk1dllI?=
 =?utf-8?B?aUd4YXJ6cmVvZXl5VG5sb1RvNjJsU2JTRUlDKzlHNC81VkN2YVlnbHREelRn?=
 =?utf-8?B?b2VNMmVBR1J5SFRPdDZEUERsOVJubUVCS0tDaDJNN2hUL3FUMkhQUGtqR1Vu?=
 =?utf-8?B?OGRyV1dFRDgrcW95eEFPR3VRZFZLOUtmSmk2NytRRC9GV2ZMWlJzMWlvTTdu?=
 =?utf-8?B?ZmhVSkNNNk5yT0R3dUxMeUQwQUlUb21jbVhNdVZsSHZaVVVDM3g3eTJyK2hT?=
 =?utf-8?B?OFZtUGZCaGsvYU1TWGFwZWhOamxMVU5keXIxeW9iMUtnaWNzSHphZ3ZWOUND?=
 =?utf-8?B?d1RLNU5rR0Y5UmppWVU0UHp0d0c0NEh4T1R2NTlhU0FQUVRoU3JjQVBCdlhB?=
 =?utf-8?B?blh6OTg0T1BmRkROdUFma3RSMGtGdG1oQTZXektSRjJtS2lNbGtvQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e51db0-f983-4630-4ed3-08df0c150b96
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 12:47:43.8729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z151AyWCLS2gEaOqHudgL6HrFdADZTaSIt7gVxU+khYvBUZQZZ5QIoyWHOU/wEzfpmpABi3tqg4w1j0l8Wtvow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2699
X-Stat-Signature: 1tcw1ppiqdkgrgdq51ujejskb69knft9
X-Rspamd-Queue-Id: 1C6CD1C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788698865-428765
X-HE-Meta: U2FsdGVkX197zvno1Tzhqfxpinv3OAhwSAZ9qLqT1EkjnEsLteVAuhbhoqSdD9kPTSK+h3/M/j1c/jpDVP7J9kzUSpvRjJs++/fhJqom/TPpB+qsDvaxlA9a8rht2ZkfjS12zuQvXukNsVLyqpvbtSDgcnBkocoM1C35aYrEaF5mdf31zC8jDhdU4oamnSAH3IJLRAVcx178V8wp5Ln2VKsac+CxvxZzEBHFLtiydzvOBzigXa3O9ddeOBrLWqe3XgJAfAEUBSQZGcu8M9pIzhXq1D/ujKI3oNPIOwbJLl/7Npn871bGfB25AfNVrrWNiaLf/ND3nGO+5XXODzflKeSkz6esUZP8umdNmAn9WhBRmRVsyU+1/jGTjZ7z+F6Vhs2KGEQFvDL4kkVZixhlDwWiTQdFb7tCopdp/B0sLEikOZ9VnB2cErSpK/d4gUqGx+aJx8Dt+Rya0dslpGfExzAtOc8uacogciraIz/nxp0sArc/k2WGFm/bos4HMHrLRZrnFH9Ex5iSuhTYMgGyEzmIYJntntREH5IwmPNwxAnXJVw+2G9KultCUW6ax+6wUy04tFX2pzloGj05oqwdfm6qCjhwHqYgtvsyJfWW+0oFF9Xikr/fBTxV1iXu68FP7B3DUHSYcV2gKPn/uKH/3NnO6xvdrKk2RTyVy66yu9ASbi7jPQJwRF5/gLLZYzcgboX7BcqfZ/iO7QIFweXHvDkGEbyY/Si11r9BC3MIO/5ZbgMWp4g1wFc0YCIt0iWNVrNdDHmfg5n9XugsO4FavufBnI3HIcHTHFxmNRBWIjZZXAkPuIskrswd5ZkyW5F61IBrxIiFnVJFtehFgeBXYILV7FteV18zaKxLR37qi2usC+0LlWN3mWcyA+wve6Byg7LKmtOLjEAMw3rlJDaJshGCZjvcXGlphZhuG8RKuVSndHvQUTDkAXLXNKVGCKJlimBFElsNK5V+V/azQca
 QKYbZn87
 TdAaKfZRQbfYYt39lhJYUYnnSeHY1PS56JvxfgGRQPusGHTqQ/KpN9HkFLdti8YTahCriJrO4F0yaJlXMwvgNHZckcTga86hvTuu9Y0A5Roe+pPislwSv+zxYHGXqiHeYPC7Hp4IpzGCQPU5EMynaN4+fVjDAXm0FB545Xm1ubrrlbTRDuaHKK8CyuKVJZNY6o4c5ba/rbOdPwiF5cItn/32ttd8uTRmze+q2g/nexD7cBcQ2lRKWvAFZsjihUhU7RYMOgWpX4kLn75wIn6wlX+8UOlF66PB+6naghxcK0hTbUP3AHxXgRpxqSBn5YmCgoT68v4svZIkqhphphmEDltYMZT4FacD7LXws4/tTLHT/YNIH7I0PEhWR+4uz5wJLfhqDSa0oZP/JOdx2/GMDFjRwZDbLhO0WVbyHk+2aO5mRzY5wopi9xWezVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 1, 2026 at 5:09 PM BST, Ke Sun via B4 Relay wrote:
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Drop the `'static` bound so that refcounted values borrowing from a
> driver registration scope can be foreign-owned by the XArray
> abstraction.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/kernel/sync/arc.rs | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)



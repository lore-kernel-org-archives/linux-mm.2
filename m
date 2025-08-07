Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B21C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9A98E0005; Thu,  7 Aug 2025 12:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A3B8E0001; Thu,  7 Aug 2025 12:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40F58E0005; Thu,  7 Aug 2025 12:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2A268E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71EC5C0A35
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:15:47 +0000 (UTC)
X-FDA: 83750462334.05.5B564BE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 020041A000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:15:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FSb9BK83;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IafmJ8ge;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754583344; a=rsa-sha256;
	cv=pass;
	b=FIGHoagkgAKWLlS43t9X7iA9i0dpM7e3YN3PBlfDUwJ3WAYVtA7DpiFkQVfPDuvyurgBRx
	ISXS3YSrpMkFju5Lyj8zgkFIeNksypICq3vOICEgtgUxdmfAwLJJzK81NFA5ZGuwtoK26s
	mGN7TPreLaRa4mgn7z5ICeY0M/MpU88=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FSb9BK83;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IafmJ8ge;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754583344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cwv1PJCvs/xU/eBjgq3W+czkmGw+6Y56nZanmoWHm1g=;
	b=OChnitDwcHGPkOYhHtGPnOAMC55apHY3O8AQj5PeStxu0H4lHPNVZXN2tIaeplVOFakGpR
	Orfz/xsEc9DISEUGwYPhAyhRXeZPXMuj/1Sn54FORijekrw9kT74ywvpDyNEvLIG5ZGBC6
	uP/NaqajlCrjTZ1KOiyrkfS6xytN5yM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577FDQes032029;
	Thu, 7 Aug 2025 16:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Cwv1PJCvs/xU/eBjgq3W+czkmGw+6Y56nZanmoWHm1g=; b=
	FSb9BK83oTwFOjJl5XMHG8lMGbguVVGOWVrVmN6hLqOKALAb48vjLUhr664oliZO
	E3/wjxx0gvMd1C6LjV/cL5PMTRVr/CPIPFkkuIl4FtCkz1SGf3pN1MDl7gt9B/eY
	Yo0SDDhXKxsVkRVFhvqqVa38WO3/NxcNwFGF8NtKsRd/We+9QPU1XjlYbYZEFRSj
	3YPQxCynQAy29z7xWmby1wGVaSdJB3g5o3YVgjawUCQrEZIXk+Fv4qBsgcMI+5zt
	K7wdfzr5Zs1kbt5r9/rxweQucOfwkJO5k5qdMWVcNAhZMg2y3bFEDikJmRrcHQG5
	LxAyxAnqMtsgdJuSbc4xHw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvjvdnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:15:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577FmexN028404;
	Thu, 7 Aug 2025 16:15:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwnvagc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6dLa5aOU9VRvWjgRxZsPMQIz9fDDJWefhjElE8tM3Gp1/sc+yvcIlauGhb9l6dh9gHELiC2AjFhvKumKWKHDQ2kD+aUJCkLmKIn49U+FcSdH3H1XryuOmy06SbQk68iQckMdYR6A0LsmoEyD0QKI211GkTlxI0ik47MXMcO//QejLRtjO5Bz7ZLR2vLgYIGwoaUDikPcYu4uVuv3MQZYPb6ThgKrBtrhviiqlaVVPOj6bd/KRwneb7qulb5rMiq3xUBRuwm6b9hWkI+DYD18ospp8zoFO5VTuTKsoSlcC8k53IQGxrwCRI0qyLXa4zBQ+r4uGYI+LBJ9lth1pHpbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cwv1PJCvs/xU/eBjgq3W+czkmGw+6Y56nZanmoWHm1g=;
 b=S1U9NjLGMNYW5Oi8xuuTF/StrOoJV4xKSQCL+kSfzDeMZCPfJFCWdJgXTxTMh1yVOptwmh8c2te+h9Dg0KqHGUPKMKRuE1Gwu8rQ+YpmXffsYTv0eYePtr5BsvtqiiHIkRiG4BC5eefw0ngIS5RtPedRff/7CmcP8k9iKIFbFswEvwd+IYec2mx3Cg52Gc/DYof+rQreUesndlrkSo2h3sZ9mkqhn/H7vZFg+PqB54Xl6IQwyilWDwzX/gtDLx74tNNRmZMkiqNXwo5sZ9SQBI+8lWrZA1V+sFhFVz3oQU8Hh6HZA5uuPOyFVbNHMHpI0YX1HQSzP56waVY9pG43lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cwv1PJCvs/xU/eBjgq3W+czkmGw+6Y56nZanmoWHm1g=;
 b=IafmJ8geH5/1yu+lTPzUu4q7x4jvIJbyoEB3MOiEn8OBagzdeiwao5OL2ZPNMiUAZGv7q1Gm7Nt5/PVywqPYMfMZBT7Ye7QfXolc5ErnA9feTzFNxBLIWxkKVOaByeKoRvFrUeM3JM/az1d6SNAkKxXgf8RjGY9SGxSLhoX8yBg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB5883.namprd10.prod.outlook.com (2603:10b6:303:18f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 16:15:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:15:28 +0000
Date: Thu, 7 Aug 2025 12:15:25 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
Message-ID: <imzcbuqlhj3dhzxyk7t44pt3ufxckwlonuqpsdohxuztvk3sss@z4douqoxmxqw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
 <20250726165020.46880c31.gary@garyguo.net>
 <CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
 <CAH5fLgjB7-xJ2OjVa6nxnUPk-1+wyxPMWQ15-Vc3mUp36+_Rhg@mail.gmail.com>
 <20250727130257.3549ea3c.gary@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250727130257.3549ea3c.gary@garyguo.net>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0176.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: eeb15a23-0a78-4a5b-974f-08ddd5cd9ffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFlhakVMZDlYbUhZaDM2Yk1NWWpGUEZMMjJqOWpyM2JTbWNSS1M5bUw0UWxm?=
 =?utf-8?B?NFBHTnZPQldOelVZZkZaMG5YRjZXZ291NGROSzAyK24reVJFT3JycmhHcGNO?=
 =?utf-8?B?bWp0aVlkMUpOTzdxaFpOQVMva0NpakY0dUVrN0NaK0pOeEREd3cwa25Db1FB?=
 =?utf-8?B?Z0toZFhHaVFMSys5RExHYnBmSmQwK21PVHFFcXpkcVpLWDNSdkpQOUt0RUM3?=
 =?utf-8?B?RnpKL2ZueFNDNkFQUEpnM2tQeWVUMjdRY1dOVldBcm9TRUk1REt4TlBTS1hn?=
 =?utf-8?B?UVNHTEtJRHc1aEllczJITTJZcHc1WHJyV0ppQ2JaREtIOEdZYTQ3eTVRaUR4?=
 =?utf-8?B?QmJrdW5sYlYxemNEN2hRRVBQMVpyNWpMZWhzNVJoalY4SHpmYUJLUUJjMUJS?=
 =?utf-8?B?cjNLWGMrNE1nSzNxR3VFa3J5TDdQN0dNaEpNSS9heUFNcnRxMVkzZG1TYTY3?=
 =?utf-8?B?UElDVEVWSGN2K0R4dU00WndyZnR1djNPbCtvYXZidUN4V0ovUEl6YjlacktG?=
 =?utf-8?B?MG8yQlRZVVVzTWR3NzZPT0huZFo5cG81OHNWMENSRXlqUllrYW1hUCtHTm1K?=
 =?utf-8?B?dU45T3Z2YXRyRUJvZERHYUtOVi9JVE1NNEVYRFNFeWNQNEZjNzVXcVJ4em9T?=
 =?utf-8?B?TERkL3Q0QzRtWDI4clpJZ3ZWcTZMY0h1RXJJanRIdG96bzl2aXZuVk95dkhY?=
 =?utf-8?B?TkVNRE0yeWNrN0h0cGQ1YW0yRm05Mk8wcGw3T0VtSmljRmRXN1VaeHhPcnp6?=
 =?utf-8?B?cmI0R1U3NVhVMG1NYTVESUg0RXdNTWdMbi81QVZHemFnYjRlTDhEMVVGYlow?=
 =?utf-8?B?clIrd21VZWNZRU13S2lqS1d2MUtvNW5EaEgvcE5OWVRtNW9MRi9CRXNGS2E3?=
 =?utf-8?B?ZTZVRVdheUMwNUZGSE9rMG43b3B0QWs0ZEhEbStkdG9CS21wT3ZmMWNrR3FB?=
 =?utf-8?B?UXZuenAyUzJKRVRTb2JnQTExQk9PQ3dqWmdSRE1wUnJya3Z3b0g5MXRXdFVk?=
 =?utf-8?B?bzZpVU43VTZ3SGJmdGt5UTNRdkFlelg1NmtHdUdQa2gxODVRSE9MYWFuTlQ0?=
 =?utf-8?B?ZVR4QkY0TTRHWG1WR0hoaVFxZTVoY2xjWWZrOUJuUTZHWkVSV0sxQnF1c1gw?=
 =?utf-8?B?eWdnUXNrM0NoQjhKYmlhWjZFWEIxOG9rOUFTSk80M1dEVEg1Uy9weWRqSHVx?=
 =?utf-8?B?U0V1TEJwUkJJeXEvdXZudFhJdUpyWnRvbTYxR3hUanE2d1RiZFQ2Q05VZ2Vo?=
 =?utf-8?B?Y0dFcEpBUnYrWEVpK0VEWVBiZk9HRTRBTHl1WVhCWFErSmJhRzdsYVhsTGUx?=
 =?utf-8?B?bXQ1ZjZxSmRoTTI4aHdXTVJDRVVpb0JWV1RndkRCZmtsUVpBMTU4Qm1lWUlF?=
 =?utf-8?B?Wkx3N2s3d0xadXVWQVBRK2Rxdkg1VW9JZTc4Zyt0VFRHTHk2UDU4V2RDTlJO?=
 =?utf-8?B?TGUrblIyNnBLaTYyR3RyczJrUVA0MTNEYzBPT3F4R1o1dmptODFNVDJ1VXYy?=
 =?utf-8?B?UDcvb3hhV3dFRFl1clBGdjlBT2V5STBQaWNDOFIzUUJZZnpyeUJUSXZQamlE?=
 =?utf-8?B?Rmx6VzExZlRVc0V4ei9XK2FXRThWOG9PSVltN0pwcGNzYXNrUHVPVlp1N1Fy?=
 =?utf-8?B?c1B4dGFxeFo2L0Z2Vzg0RWpkYzBGQWh4WmJvT0ZZUVgveXdZQkVzdnhsdWZT?=
 =?utf-8?B?d215cEdUTXhUT25rMWwvQTNSUFI4WFV1NnRqME9Td3NYbUNHaTVrdTUrc21K?=
 =?utf-8?B?VXh4NXRDVE1Ha1NYaUNhMCtTRkJjS0hiVWtYRlJJNEpXNElmVmRpMlB6RGJv?=
 =?utf-8?B?SFNYRlBFS0dnM1pCODduOHR0d0VtUndqcWRGTGRsaktvMmU0TVd1eEtFQkFP?=
 =?utf-8?B?ZlZ5ekNybzlkM09jUmFpWmVuL3ltaVNNcXliTFFQUFJCWkMvbmpOUGFpWjdk?=
 =?utf-8?Q?KbcatlcKNuM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWhLRml1UUlqQjRqaXhiQUthT1BtaVhGME5ZUDlXVVE5bFBCaFRRZGk0OGZO?=
 =?utf-8?B?RytuRHVkKzJ6bjZ5RmVXMFV6MDBHUEp4eHJidGxNTWozbnR5Sk9GSTJJS3Vt?=
 =?utf-8?B?eng2VmVjdCtWenBVVUttL2NNYzVTT0UyS1VBVW1CYWRETFIwZU8xcWMyZWx1?=
 =?utf-8?B?UEpMZis1anJ3UkNvSXVsMGJsdnNzUkV5ZVYvc01mSTdSSWZCLzZkZU95VGtQ?=
 =?utf-8?B?VjZzK0ZnVGdqNjRKcUlFc3ZWS0QwV2IzVFZxdGhlRVhBMHhmSWFHUXVjdVFM?=
 =?utf-8?B?RW42VDJPcWZKRDNKckxuSkFlTHM5alZHdFluVDFOOWRxTUQza2tPYlM2TkFO?=
 =?utf-8?B?SmFmMllUbGhFR3BQOXYzYW9QRktFT2VBK2FoZkhsOFVzZ2QxMWhtWWFqVnZB?=
 =?utf-8?B?M2dWcklzRll2cnQyek03ektROXN3T0ZJbkJIejd4TnczM3UwaGUvekZ2Y3dU?=
 =?utf-8?B?YXhrcmxGMWJYdFhOdmZHMzhBWW02MTlhS3hoc2I4ck9IcnhaR0RZWTdCTWhW?=
 =?utf-8?B?ZWc3Snd6QUoyYnJqSWRtNEVaa2lrM3dTajhZdmxrcXd5ZFMvWHkrNFVZYWhr?=
 =?utf-8?B?dDBkVzRUa21sZjl0dkhhSjV5a0s3bm9iekpjblN0NXRUM3hRdFBHS1FwZFhP?=
 =?utf-8?B?V2tQYnZvdS9oR3JIZjl2RFk5cmRVUFF1T28rejlJNmh3SGh1c2EwRU5xblZB?=
 =?utf-8?B?SDNsL0Y0SVIyU2ovMjFCSTJFY0k0RGYrSnFUaFdFdE8zUE4rRitXNXBkd3pk?=
 =?utf-8?B?UFVUMzV1dDl1Nzd6RHpmdXRvWGxIWVNKOTVGV3F6eTVSM3pvR3BQQndUMmYz?=
 =?utf-8?B?VFZxWWpQdTlYQy9EKzRSdmxoWE1nR3AvNHVvMkt5VFZSc280bzVjcmttK2tK?=
 =?utf-8?B?M0oyaTJVVGdqbzNhUHR6amdObzdzOWFkcjkrT21XdkV0cGN6L05sL0tTdVFP?=
 =?utf-8?B?MGxOeXp1S3Y2c2tJd0I0aXZTbCtqL01VdTcxR1V5dTllS2VvbjNuTlBFaFR2?=
 =?utf-8?B?MlYybWtmNlpzTUtZaWFVQVRneUY2WFNpL2NNRWpobi9xT24wVjZJdGc0OGo3?=
 =?utf-8?B?SHJ4WXBTc1NicXRwWVdhVWpNaG1MaVAybEE0NHlwaVhPcGlqN1FjMXZyeG0y?=
 =?utf-8?B?Tzl5d1VlamZJWktPbzdwU2ZDSm5BWnovLzVBOVVycnkzUGtweWFQM3FHeHlQ?=
 =?utf-8?B?R3k1bHJQSVUxb2Q3REs1N0tDcXpGbHg2YU1UckxzZmpsL3huOUJHV3ZwZC9Z?=
 =?utf-8?B?bjlZVnYxTjFDdlZQN3VoM05OVHFwcFJCUnQ3TFNmbU5GUWNHZDBVeGRQdnlX?=
 =?utf-8?B?Vnh2VHJ1TUVLb2J2ZUNnYlZRM1YrTy90SkRxV21vK0FJL2NlVG13WkFXRnZh?=
 =?utf-8?B?NHNEaWZCR2pWNHRRblNNbWgzSmkyU1Rkd1R3d2t3WkJEOFdwYUR0ZmVvWE5o?=
 =?utf-8?B?Umo0dU1uSVFTWkpwMkh5RFF1K2FpQkhGUTk4clBoT2NyYlA3Z0l6TnZxNlda?=
 =?utf-8?B?Sm9DZjludURvNW1IbzFJNGdPaUY3YkszUzhMRUFBR1U3WStSckdxSytZeXdw?=
 =?utf-8?B?TlFaQjhUdy9DTUpJd05UbXVvbmhueWgyMmZPVXh3ejZNQVJpSVF0MGFYMVI3?=
 =?utf-8?B?UHdyT25SeU1NTG1GUVZYOTNqb25GWlkxeUZ4bExJZkVQUHNUQ0k2N1VlVUJT?=
 =?utf-8?B?cWRrOTN5dWhMbExwaGN4T2NrZ2tpclBUcllyclZmbUExZ1FOMGRNd2NWbTlo?=
 =?utf-8?B?RVBoZExtNzRBWmlPd2Y4alJsVDZVYThpeDVoU254RHRwMm5MLzhhSFVuOFUx?=
 =?utf-8?B?WmV4a3hKNENMc3lNekErNTVzRGFlcWhQNGwyZ01mT24vZWtiN0dMSmplVlR3?=
 =?utf-8?B?UFF4ZmdDT2JZamtMckdTSzVhOGJteGFSRGxkNmc5TTdDTG5RSnNqQlptcFV3?=
 =?utf-8?B?S0huNmhUZkZIS05lY21RME9hRTBDMmROaytQQ1NQNjgwQVdXeWE0dkswcCtN?=
 =?utf-8?B?QUdqSzVyVXg3K1JhY1c0QlYwVFZKcCs4OGwzOXJQSUdacU5lcGRDbC96YmNa?=
 =?utf-8?B?RklXNFpTbUVmM2E2RDkwakdsWTR3N1RVREVtWVN2Ym93bHF1NEtpTlh5YzU0?=
 =?utf-8?Q?oh01w15s7KmbNJzj0nNZsmSNj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O3R/GNNlxHsTKVXokxtQtkFO6rJ1gU/EsPkdai4j88SDOuX45mhILMcO44Hm64OYnftOP8YJJ8sr/XRLor2EhXGsAzgdRzn+ymoIeUraMHliMIE3s6t02LIFhbV/CK9vMtG9giIO9p72FVBWDAG0JfDjFt3vNsuubKuDRyU/AhGX55vdWt8kdCcVvD+dowWtocw/29Ixp9W7F4THwTbsQXu2ocDyqzQVPUrPExNM9YLTKdPIEjEgndioSpUHZUa6Xh5h8FJMXGfS0ZMTFFlTOFqGX1/C71aOtJ6ceRcwzDbajwqlzfhACvpOpkgUasPBktLdsOmF0NCDHm8eBTR+gs8shnFxwlo7pUCTlYiHbNmjIFqr385sZKzmarBpyGWHGskwErzbwlgzpkVmrd+GKfxo8YCrhHd2AyMmirBguJ40T5tikQWkf2n+robShlA9lzQ2wb4zZMd4d1KWQBGBeplIyKaVGKQTPzCNssdI94VXheiiQrwR2F6soC3QaiXEGDY0DKVAgVjarx7FocAcN8m9npbk6/wbL6kIRhdMRpngs/ku5Zfb/WFXkjOQUVhxhex7YMdvoYvF0qMytpdJrHQBMUWZ4TLR4oX+522WLi0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb15a23-0a78-4a5b-974f-08ddd5cd9ffc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:15:28.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0l8s5qwZLTyWPK65Qakd1LnSBxcqsXy3H3E7TJ/J6CS4vCOn1mcbJBSaHGkTNn5VQtdwBGK/GYLcGNqHctPBww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070132
X-Proofpoint-ORIG-GUID: isiSVgPOtE1Pj7gKdaaGeYjWMOlvEyX5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDEzMiBTYWx0ZWRfXwIpSudrUkBnU
 LxLbeltMUgez4iyb5Pp82/N24r1vTw/E6eP7ey0Zc5fY2T8iS14a5cJrmoYCiSXzAxp0rCUoYlK
 sVCmmcrSWjlSmkrNTQgq+ZMELkqWtUDOUpicZZqcFnzA8PgsfGMXho/yCBo/uInK+yewS5Ifkew
 C+U7jRI/2rAvrhu9oSdmGW1ERYHAgMsGTz/mNUBIf0ukTQSAm2gEJ3ZdaYeOgigRiApf9kqwdRB
 ED/NAYMIez6kmCUkMVKN+Jx/q/rEE8Bd85oJ5kij6LJHzP1kqyWqbMIyueGCEfhlnZackZ6ZOY3
 UjC0/lh24jxttdvK6hnmXQoDcBIljF51GDT/fiJz9VjM8bkOeVGHIA/QVbtfBLcyP1ohqUXnRs9
 Y+lG/YBdW5tbtOTJnpCV9nQiRBTca9/srvI4M1/39E9cU2PULd6OyNGyZBL7ukKTi5t/Vfod
X-Authority-Analysis: v=2.4 cv=dobbC0g4 c=1 sm=1 tr=0 ts=6894d127 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=_2yia0w1AAAA:8 a=1XWaLZrsAAAA:8
 a=pGLkceISAAAA:8 a=OnqHoZvJb9BcTGhYnYsA:9 a=QEXdDO2ut3YA:10
 a=4yAS8WwzZ1jAEY03B-5r:22
X-Proofpoint-GUID: isiSVgPOtE1Pj7gKdaaGeYjWMOlvEyX5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 020041A000E
X-Stat-Signature: 6m4ssdg93tumx74tpq5ohh6jf1rg4wrr
X-HE-Tag: 1754583343-189244
X-HE-Meta: U2FsdGVkX1+fVtVtQk5jvrWisrxwRJOC33LMJz/M4tQoBGTzvIuThlJ1qc6pihD4gV4VLpy+4CJD0KahSzrr9ruCpF68bw7RSE5iOZBZmqOzL8cpBGWFjUD+ZePcm5vtsoirfa8OgWtYLJhtmSPcSWB5Uwkg4XCI2ZYhK/MF8q1x53uxKeCrAqrCogm5RfBed538+UnXWHCdL/T2RpnWnoldtveytP3kKjw1it/RSdBEuMFEEMIQ8XqIZwMoPwkGPSBUQAdWTzU3CPMUcSPXS40QFmUM8rIKjIhSG19LM8/Lba0knnoR3Faly57zRh+iXia8pNm1PxsgfspyLTG70UV+Odo4/QH0+G+CKrTt7RMbMTSuQFqCn/b0n9YpZTpHrK2xpD1NY2Cu9a9JmGaZMUwyg2in0vVqDg3BRr23DpSbSEUX3sIjPVmfUeHbd3cG4Lee8QyWOUcN+1jdvsrxaYxjIgsfnsYX7DJdnI+SZxpWU5a68D5M6deOrAtMqSGkF9uxlVlnGMnNaTItFAtuPH+SHVNY8ZJMCpV8HTtal6lW4btNqkkqIpnHzoVeI64kiks+ojKOnp7TnopdM/69pUcIOqMzrprhwYgMdlcQo0c4gVmSZaJGALkXJXKD3nafV4fu1PxxTDY5Ln9jhwJ7PoRIpU2JrMZINI3RmGE/m+3UA3pUTnQf+PTB3p7eoC4nU+kb8Wiu4aJTF5QHDBslcY3x3BwO1U4dm6s9IfmG0a2XU7xLJ/99SbWAlQipTxYcpViZvQLgHbUJW8PJ2MJRpoP5KlyCW2MczvfZeQb7YbSvWhRG+7QscwX7w8jSuqxmsMzdWDIBHUGhUJXAify5r6EH8VEhrVMw/FGnkKR8Zim3YIrO70CotEmd8iZw8n+THwiZbO/dDQuFw7o7MQbJrcPDZB1NTVMMWqRjmZunT17XsKrRpxcVTW0Z3M0f4crg2HCJqwkhIdbH0SDaYrf
 T0c11jO0
 vfslCeZmtDH6T5bcwfHZPSkdW/C1liqB9yk+QEvam0jN2AOUsRekt5c0RDXAmRTtCoMZyuKFrcXhhs3FAC4tKR7mRiRV0Py2BS+53ChV1WIgyOTrgdKdWP9VF078dHvLYHFAISi9Rr7TodtZGxQjuskvgrBG3bxulh91K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Gary Guo <gary@garyguo.net> [250727 08:03]:
> On Sat, 26 Jul 2025 18:18:02 +0200
> Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> > On Sat, Jul 26, 2025 at 6:15=E2=80=AFPM Alice Ryhl <aliceryhl@google.co=
m> wrote:
> > >
> > > On Sat, Jul 26, 2025 at 5:50=E2=80=AFPM Gary Guo <gary@garyguo.net> w=
rote: =20
> > > >
> > > > On Sat, 26 Jul 2025 13:23:23 +0000
> > > > Alice Ryhl <aliceryhl@google.com> wrote:
> > > > =20
> > > > > To load a value, one must be careful to hold the lock while acces=
sing
> > > > > it. To enable this, we add a lock() method so that you can perfor=
m
> > > > > operations on the value before the spinlock is released.
> > > > >
> > > > > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > > > > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > > > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > > > > ---
> > > > >  rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++=
++++++++++++++
> > > > >  1 file changed, 94 insertions(+)
> > > > >
> > > > > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.r=
s
> > > > > index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3=
d5752b4f5337fb6277182d1 100644
> > > > > --- a/rust/kernel/maple_tree.rs
> > > > > +++ b/rust/kernel/maple_tree.rs
> > > > > @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<=
T> {
> > > > >          unsafe { T::try_from_foreign(ret) }
> > > > >      }
> > > > >
> > > > > +    /// Lock the internal spinlock.
> > > > > +    #[inline]
> > > > > +    pub fn lock(&self) -> MapleLock<'_, T> {
> > > > > +        // SAFETY: It's safe to lock the spinlock in a maple tre=
e.
> > > > > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > > > > +
> > > > > +        // INVARIANT: We just took the spinlock.
> > > > > +        MapleLock(self)
> > > > > +    }
> > > > > +
> > > > > +    #[inline]
> > > > > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > > > > +        // SAFETY: This pointer offset operation stays in-bounds=
.
> > > > > +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bind=
gen_anon_1.ma_lock };
> > > > > +        lock.cast()
> > > > > +    } =20
> > > >
> > > > Could this return `&SpinLock<()>` using `Lock::from_raw`?
> > > >
> > > > I guess it has the drawback of having `MapleLock` needing to store
> > > > `ma_lock` pointer but the guard is usually just all on stack and
> > > > inlined so it probably won't make a difference?
> > > >
> > > > This way you remove `unsafe` from `lock` and gets a free `drop`. =20
> > >
> > > I ended up going this way to avoid the extra field in MapleLock, like
> > > you mention. =20
> >=20
> > Oh, and it also avoids assuming anything about the layout of SpinLock<(=
)>
> >=20
> > Alice
>=20
> Well, `Lock::from_raw` is designed to interact with a C-side lock:
>=20
> > Construct a Lock from a raw pointer
> >
> > This can be useful for interacting with a lock which was initialised ou=
tside of Rust.
>=20

If it matters for future build out, the tree supports an external lock
that may not be a spinlock.  This is currently used by the mm for the
vma management, and others (although willy wants it to go away
eventually).

Thanks,
Liam


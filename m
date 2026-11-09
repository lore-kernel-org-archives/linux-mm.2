Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B23606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=Kjs8W2e8
Received: by kanga.kvack.org (Postfix)
	id C71556B05BD; Mon,  9 Nov 2026 07:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48306B05BE; Mon,  9 Nov 2026 07:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10056B05BF; Mon,  9 Nov 2026 07:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86AD76B05BD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:18:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A418120640
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:54 +0000 (UTC)
X-FDA: 85415484588.21.7169678
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022103.outbound.protection.outlook.com [52.101.96.103])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1894940004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Kjs8W2e8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.103 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794226731;
	b=FjSSSl/NLY4roFkmLwFY3tEDaiOZWrfH3xktLAEhTMYcz+N1F0pZLcnofaL+PbExn8+ghc
	lyxvK46FM2/LsPNHEazZZzuQnrfCVlxBk7Ioe6Kh38RoPn/Bmpw9n5vh0HbxIJNZ2sMe3y
	hhEVW6Hu6luc5Jd6LAoz9DxUJxsmXcw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Kjs8W2e8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.103 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+JNS4zNxX0LJcsOyuiae+sJIwpEyobXZzVTEHyUKTM=;
	b=Y1tqjVthj6lb8JTSTrM/mJVC3zExzMBxl5oPpbwN/2jLxDqPaAraBBI5X0+lbm1gjXsX+M
	Q0daC/ODLTa0X2NfpiA0hE2HKa0j8YFRLoG4C/9tYsj2vyoCCUjLYkiKvxKQTmt4PeLnm2
	Uj2bXM+x6Ydlg2UY5xvynHaZiUWk+bQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRIvLKN8ztkxMTuID3EGqxPcuygMjIGqtmMzIBFGVce+9VJCh05Nn/3O3KE19Lnhm5bpIjEaQ6+OBdtle52IevVwBG1ktY/M/3JSo2Lz40/qU2o4QmzB1D9/5oTG4CharAe/i74OED2esCl2hpKNGGA5iOLtjJ7+f7fcZPvtqt3yDgSoHDPiJEDv/yJZiLJdHIo7KaJ5yH51ybMgQjELToYNN1pPz+9GZJNP6rD1koBqtBlq0K8qd2xhu6EOd92OTPIpkO/uIkRJMziWBc0qhmJlwt1rWlx5cDanFq9T4JnM88Qxb6IJhv/79MDBUstHMoaFsTGfYC5jKt9tUpmzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+JNS4zNxX0LJcsOyuiae+sJIwpEyobXZzVTEHyUKTM=;
 b=S1lBnN6D18YIx2r1K6Cx8GjgUd0acL+ENByrSAlAPoQh6t/83vA10CBDU4Iavwr+BjW8EehdHZNeNk59gXxWJBgw1wX3VhcSQi/nAVy2XwpKzyfboINajujMIvidugn2gKnX8pl1F09m3fbQG7P3j/YCzuPbjc6s2gYJP785qk3e2yrsdORGLvKF631vTSptSVnUfbUWM51dODWhrTxvUFOZFaOpXPdKDnlbQubmPjRoHBDyoC4s5Q5LCFvma+ce/cppXLBqnpCw/rpCQ4euZYplwaCqpghkfA78ziMjovFUPmPy2IE3p/LTLKmjFktz9PnSm7LoZkJD+iLq9xwMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+JNS4zNxX0LJcsOyuiae+sJIwpEyobXZzVTEHyUKTM=;
 b=Kjs8W2e8x/3vq5IkxTzBDtU8vfG1a0YtnZlHSN8u6NYPFJ+iNWUZiKwpsudhZIpkDhcMTdPrhtYiUz0DldWpeYr8L8L0wyH3+1EbR7WljcPCf1yYIK3iwsUTgS+hjmXJCeQ0uw9nT8oAnvYk0P60bWxy+mz+mPzIS4tY5Mk3+wo=
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by LO3P265MB1833.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 12:18:45 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 12:18:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 12:18:44 +0000
Message-Id: <DMQOAI3KE9UD.3KOEVJO02ENM4@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v3] rust: alloc: add per-task memalloc scope
 abstractions
X-Mailer: aerc 0.22.0
References: <20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org>
In-Reply-To: <20261109-gfp-noio-v3-1-a573e7be9c44@kernel.org>
X-ClientProxiedBy: LO2P123CA0088.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::21) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|LO3P265MB1833:EE_
X-MS-Office365-Filtering-Correlation-Id: 81df8e5b-0c6c-4539-e1ef-08df3e5b99a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|376014|7416014|366016|1800799024|921020|261021130227099003|56012099006|261021123027099003|261021121427099003|261021135927099003|261022115727099003|261022113327099003|261022075727099003|261022105027099003|261026130827099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qtSCjiXQd/I5GGgIFPq0iN4zvxUlQJBK3sohMdt1O2WWE+UomyrnRd22w7F9J76+enlYcMR7B3+QaIaXBh5gL6ZZDnIfwG4/kUnai0D+T6Th0L68cdWKkZHyO/zI6I6tY0KsFNXLsjbqk+g3ujFmBWMFPzfqli/olOgkBVDdi5181f+/GkBESbHB9Oz4m+1HV/4k2MntitHZaei8+wSrJW3QdrGRUKpHh2m1ynveHaMkccvGEcoOIHQAvvDhCRCz02AEM58yIYje3N4L3+hyGDwBbct26+Tku5+PgahezzeZu2OHnNRo7I9ejDh5WvHfppiTW+MbicJOnVru2YbnQg2v/xLNLM1OLfDT2VSe+9fYBgCHnLIoF1CVqdY+VIzUGQzAqqhIkQj0bxR+B3MlwjsENQAFpepJA6vNsbkb/ClRbNNkOut3APM5VNgVoU1Y8ifHN26NbzkJFr8RP72DwCNiC8Nw4UPLm15mLev85tACI6+biHBHYc1BjDNM6Gqs/YgqdEGw3E+aS2T1t1IspG/6rquDXr9+H/LTlsSV7v5obYH3eQd5qxw/YnFUtNkhXPRz+DABmSiGtAKm1iue0jjli4/2rxDuonJOIwyQTKI7DrdRfhhGYwWghKUlvb/67Fcbh0op2hGYMf2bMmlJWvHtNaT17E0WcCHAZdfNS2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(376014)(7416014)(366016)(1800799024)(921020)(261021130227099003)(56012099006)(261021123027099003)(261021121427099003)(261021135927099003)(261022115727099003)(261022113327099003)(261022075727099003)(261022105027099003)(261026130827099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkV3YkJ1RWVXZGl0dFFmL3l6ckI0WXpXZlBwZTA2MzJuVGx5UTAvVDVZYk80?=
 =?utf-8?B?L0Y3VFAzSCtKRHhNM2J0czB1dUZRWGQxWEg3TWFheWZsMlp4TTZlZy9tR2F4?=
 =?utf-8?B?ZXZwblBWNmlCS1UzZmNkejRKRVVib2hZcjBhdWRDajZZTC9abmsyQzZqNTZO?=
 =?utf-8?B?ODE4K0NnQzdnNkdmeHhHMk1rZnFwaGVldHVYTVlEODFYMG93SlZLQVJ6S1ZR?=
 =?utf-8?B?OGRQRzdla0k1NlMzdDNGWkh3RW03NEdBdTJhWThBc0hnYThXeTVkSWxrS1pX?=
 =?utf-8?B?TjBLYWxSMnBobGxRWWJ3ZmtYQXNkTE50QWxQZFNCMk5lYi9TelRnU1hxT1dK?=
 =?utf-8?B?T0w1M0tTdlB1SWdKakVkYzV1cHRJSVpqR1RPM3ZZaU9iUzQxakpyVVJPNkhK?=
 =?utf-8?B?RnZ5NFM4R1NoRkdEWVQxR0F2NTZmVW5BMEQ2K2luVkdma0t3TlduQlB0dndr?=
 =?utf-8?B?SWc2b2Z2MXdDT1UwNWxmQWh3WWQ5ZEtFenRORzZUenUrRWRHcUFaR1Rsd2N6?=
 =?utf-8?B?VGtsQ2ZpeUtkSlFBSVJuRWF1RXZJQ2VMWDJWV0UwbHZXNGp2dUpXazJPSWRz?=
 =?utf-8?B?M3hKa3VNVlNJK1FnZmJFRFMrQkpGYnJoUkhyZXVTYVFFWGRiUGd3YmxVSzRB?=
 =?utf-8?B?OE5DaDNGLzNyRnlsUCtaNC9pODJHS09ReExqOGpQd0lSTERVQ09zeU1rYVUr?=
 =?utf-8?B?aXR1aXF1OGYycGFIaFYyTGErdVZvck5uNy9kbTc4WDZLRWZtTzIwRFJadnlE?=
 =?utf-8?B?bGNCUjNCZWdZV0ZaQnJUeUJ1b0ZYRmhVcWpXMXYyMWx2YlQzaCtjelZGQnJp?=
 =?utf-8?B?eW0zT2hJWW9TVHFtRFZSZHh5bVhycjIrOEQwSEhKYzdWRFd6MjVLdlZ3dDNw?=
 =?utf-8?B?aWMza3dQTUtmM2JMOFlXK0M2dnpNdldNRHBnNjk1UXNicFVXUTVsbGFZY3lr?=
 =?utf-8?B?Vzh3M080UUdnbC84TDloQytraExrSGRoL0RIRlQ1UllDWmJRTlpKczBncHN5?=
 =?utf-8?B?Njh6eUpkWmlLbThob2plWUJXMWRsZWwvUW1LSGlONTdDVEpZaE5ueGtQRWZE?=
 =?utf-8?B?N0tzbHlHOHg2NjZlS2dJTGRNcHhqV1JvMkJlRjhMcVhaQzlBMUw0NHpYcGh1?=
 =?utf-8?B?aG5SNWtPOVdaRm9CM3ZaZ1pPNXBFaFlLSDVZTnk4Q0JBaG81UlF1L0VpZllR?=
 =?utf-8?B?VEFYZ0JjUW55clFHUHk1Vkg0TjV0bTJTUTVwOGREWDJFaWtjdDZibEFTOGk5?=
 =?utf-8?B?cW03ZWdIWWJYMThKRUVvQStHcFZKKzZzTi9FSEh0ODNlTHdxNTNudXZKTHMv?=
 =?utf-8?B?dnZra0FjS0lseXhjN1JLbVFqU1NnbFV5N0tjTEp2S2J0OXMzQmlmU3BROEhh?=
 =?utf-8?B?Wms3TVBkYUtIV3UxczNiT011UDg2ZWRPVUJFeG9uamxRaVFtL3ZCQ1RUYThm?=
 =?utf-8?B?dGg2K01BOTFMall6RmpweVluL1ZMUFBGSWpXQnFnOWkyOHQ3L3JZZDBqa0hY?=
 =?utf-8?B?cUdzTkU5WCtEN1pJZmtXRHNITFVDZHc0TVVmSEVJZHpOeU81THpnT0FNNU1D?=
 =?utf-8?B?VjlkMUNPUDBGKzRRTHJXMFBjSlVMa25hN3orMlZTbWhKbjZvbDhLaU5sZGhO?=
 =?utf-8?B?RjNvTmJhR0pLQTZoNTYxVjdaUjR0OTR3K1EzMTdLWnJkcENla3hadDlNWll1?=
 =?utf-8?B?YzdiREVTSldPcG9ZVVkrK1RLbi80QUgzSkVCMndvVm5hVTFnMzJwWWpVUUc5?=
 =?utf-8?B?cjBEb2UrUlFGelFsUzcyUGpMWVRDcVVHVnZaVHhzSFZjUG5qc0FCZzY4SkZF?=
 =?utf-8?B?RnZjR3cvenZRQ2ZVMzdRL1BIRTFWQ2JiOUQrNGY3UXM1SGJlWEgxdUlyK2Vi?=
 =?utf-8?B?a3I3WXR0VmMwYWhZNk8zakRBcHVNREhzdkdSOGNFYkYrRzZWbVdLR2U4OXVF?=
 =?utf-8?B?Tkl1U2FwT1VlaU1Pa2o4bGlJSEx0Z29FUUlLZWcxeEk5cG9ad1lxNkY0SEYv?=
 =?utf-8?B?bGJCUlRlWlh0S0g3UEFGVTlneU1HSk1GVEprejMxdXE0bTlRbEZXMEQySEkw?=
 =?utf-8?B?Rzk0TjVnSCt5N3NhclpYeVg2cURZK2xhSFY3V21mVzJLVzgya0hUaWR5VUxs?=
 =?utf-8?B?a05SSTQ4NXJPa29XODJlYTVlNVg4clNDbGgzSXlETnByS1NGaW1XOVZTc2RF?=
 =?utf-8?B?dUlaTEFrQWRjVVIxMms1ckVOQ3ZrbGQ2RnBRUjFTRXJ1N3FiREowTU1HS2xS?=
 =?utf-8?B?OEtRSjAvTWJCTHJWQUFzcnFsQXZPeEZVMnp1NTlNbDk5eFdNOHN0VkJjRW4v?=
 =?utf-8?B?RnhuSC82bHE0NU9La0FkVXlBL1B3YWsrZHo2VUd1K2EybGI1WTZuZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 81df8e5b-0c6c-4539-e1ef-08df3e5b99a5
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 12:18:45.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 369McrvBtxn2rfbDJ9pRVUpzVox5aParO3D8PO/tg5EhCNj7T2LQhYa1KUulm68gbyTP1hmct+e87ZmhbrIx1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P265MB1833
X-Stat-Signature: w8kucaowbjkgzs7ycfy4itrksngt4aw9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1894940004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794226730-288710
X-HE-Meta: U2FsdGVkX1/YcVpwoyyOu20dNyzRR3tBHacknLIgxrtoY3hzWTQwKFjJNqHiyGulYQ17tp1ceUc9A/EcjTUgz3/ld1rRbGBzDNG34DvLyakg00lg0hluNM7W7pHOJeeMn58V5a/DUNx8leWW2tzWzC+9RFohaIvoiog1qQe/3QtwjjFL0Pui78tji8F7iZrUZAq/W7zaqtpFodHNekgFKaucF9bs48g+2cPP2+I7Y5rtirD4ZojYFA32jxD1RJy8B9yJOg7jva3yqR9IhRa9pGHXu4QJNob5JzCxAubipmyP/kpT9DdnD7w2UgibEQiJ2GDtzmCG/0xkvrwFmmxmrP0egnUZJTY73AD34G39CTzduunUJE/h638toByOcZhuL7d00lfNdHN9NWa6Kn4mHvJZAHgbtURTlqMfPOSRHYUxuliz6ZBVsdQwyHaNmyjNwXS/XFCOzMzizhsAkALpO+jijK48pbP34QoC+kiNfzri2Lt5t1Ens+8xEAWDv2j4nuQSxmN+RvebW5w0xCUWVhpomIjuvQx09QMICGA3NFs6BIDuCLcoPpVDNQvdquhvuBYeyOhcyinJ9183G9ytUiSvJiQRLDlCcTW0yVVXIEMRquUAzRhdimOzXbFpGPweFqrUSkP8wtygv2tBxU6LxFySCojYgBNzK357eGUneguFk0P7YDzLS1VJW/24yMydlCaJPtwI+SOPrlUP9ZaVAUpEN6GSfVegYD085e+mUuuKXaxQ8n8gnXuDDeUmDx/iu8mqQZ0F4RaIS7YN5WDD3+LCr+74E3I6tI4cIjuykkNL4l4gIvp/rgMc7atQBj+G5fEafGxgGUjDaJEn7IdRpdKAu4amqvUosdpFC3lYjhfPuscMplaMlqcnABTTweYJB7qdMZtxGPwje8EI6mIpqfB23/cyLdWu+cc98t3w6plNeRfTTGRkK6ER3urOwZrfkALD+C/Z7etIq28GA/2
 Tk815Sq1
 yRzFE03JZGHoPdnWQlCVQzpC8ymFk30KNOXLAZITaPopsgxDf7ZlNCa18lptNfc50nBNLhdfAhOnHdNqtoMCIShP04CkWaWyaYF0gzYd3kM3qVf3L7kXFswx+UWJVCYXa8yhhi9yGA0W77ChQBc9tjT1rDX84BMn7E97yOChqntA34sdGwT1v5YD8iU1hYbC0Bku6K82O3J+w6CuVyauSF6iol4w/xz+4L8JNv3KWPrv2iTEEz3ijKzqSDBRBJWAxEF5SzAlR5OnrMTapMYceltZHnKHLAyNp1kmxY8ASpjWezYgabiA4iNXyzUE0yTGDgIvoguLp9KmHpYOmlaRQU4fri+q3SdWRFelupxBzodYbWAwb9cl9PW6ZoecETbYCQpencNO2m+3XsdPKjYYCXPwzq47pr2mKD/tSf6KXP6E+4u1GF53Rjtxgzi70HsY8Eg0i7LLPSwFE/9L4Y2pOIkB0AMc2LH9KWYsmLD5mC3lIgdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 9, 2026 at 10:37 AM GMT, Andreas Hindborg wrote:
> Add an abstraction for the per-task allocation policies exposed by
> the kernel through paired save/restore helpers in `linux/sched/mm.h`:
> `memalloc_noio`, `memalloc_nofs`, `memalloc_noreclaim` and
> `memalloc_pin`. Each pair sets a bit in `current->flags` and returns
> the bits it added, which the restore call clears again. The pairing
> assumes strict LIFO nesting; restoring out of order corrupts the
> per-task state.
>
> Expose each pair as an implementation of a `ScopeKind` trait on the
> tag types `NoIo`, `NoFs`, `NoReclaim` and `MemallocPin`. The trait's
> provided `with` method saves the policy, runs a closure and restores
> the policy before returning.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
> Changes in v3:
> - Rebase on v7.4-rc1.
> - Replace the pinned `Scope` guard and `memalloc_scope!` macro with a
>   closure-based `ScopeKind::with` entry point (Alice, Gary).
> - Make the doctests compile and run under KUnit instead of `ignore`.
> - Document that `NoReclaim` has no effect in hard interrupt context.
> - Link to v2: https://msgid.link/20260605-gfp-noio-v2-1-cfa2e236c2a3@kern=
el.org
>
> Changes in v2:
> - Rewrite the patch to use scoped allocation flags instead of exposing
>   a `GFP_NOIO` flag constant.
> - Link to v1: https://lore.kernel.org/r/20260128-gfp-noio-v1-1-9a808fc49b=
44@kernel.org
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers/mm.c               |  40 ++++++++++
>  rust/kernel/alloc.rs            |   1 +
>  rust/kernel/alloc/scoped.rs     | 171 ++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 213 insertions(+)
>
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 3791af0aadc7..df21b5b129a4 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -86,6 +86,7 @@
>  #include <linux/refcount.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/security.h>
>  #include <linux/serdev.h>
>  #include <linux/slab.h>
> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
> index b5540997bd20..1e490b57057e 100644
> --- a/rust/helpers/mm.c
> +++ b/rust/helpers/mm.c
> @@ -48,3 +48,43 @@ __rust_helper void rust_helper_vma_end_read(struct vm_=
area_struct *vma)
>  {
>  	vma_end_read(vma);
>  }
> +
> +__rust_helper unsigned int rust_helper_memalloc_noio_save(void)
> +{
> +	return memalloc_noio_save();
> +}
> +
> +__rust_helper void rust_helper_memalloc_noio_restore(unsigned int flags)
> +{
> +	memalloc_noio_restore(flags);
> +}
> +
> +__rust_helper unsigned int rust_helper_memalloc_nofs_save(void)
> +{
> +	return memalloc_nofs_save();
> +}
> +
> +__rust_helper void rust_helper_memalloc_nofs_restore(unsigned int flags)
> +{
> +	memalloc_nofs_restore(flags);
> +}
> +
> +__rust_helper unsigned int rust_helper_memalloc_noreclaim_save(void)
> +{
> +	return memalloc_noreclaim_save();
> +}
> +
> +__rust_helper void rust_helper_memalloc_noreclaim_restore(unsigned int f=
lags)
> +{
> +	memalloc_noreclaim_restore(flags);
> +}
> +
> +__rust_helper unsigned int rust_helper_memalloc_pin_save(void)
> +{
> +	return memalloc_pin_save();
> +}
> +
> +__rust_helper void rust_helper_memalloc_pin_restore(unsigned int flags)
> +{
> +	memalloc_pin_restore(flags);
> +}
> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
> index 68d80f3fa6c8..5e4c142b5682 100644
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@ -6,6 +6,7 @@
>  pub mod kbox;
>  pub mod kvec;
>  pub mod layout;
> +pub mod scoped;
> =20
>  pub use self::kbox::Box;
>  pub use self::kbox::KBox;
> diff --git a/rust/kernel/alloc/scoped.rs b/rust/kernel/alloc/scoped.rs
> new file mode 100644
> index 000000000000..6745c06d6725
> --- /dev/null
> +++ b/rust/kernel/alloc/scoped.rs
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Scoped allocation policies for the current task.
> +//!
> +//! The kernel exposes several per-task allocation policies through save=
/restore pairs in
> +//! [`include/linux/sched/mm.h`]: `memalloc_noio`, `memalloc_nofs`, `mem=
alloc_noreclaim` and
> +//! `memalloc_pin`. Each pair sets a bit in `current->flags` and returns=
 the bits it added, which a
> +//! later call clears again. The save/restore APIs assume strict LIFO ne=
sting; restoring out of
> +//! order corrupts the per-task state.
> +//!
> +//! This module exposes each policy as a [`ScopeKind`] implementation. [=
`ScopeKind::with`] saves
> +//! the policy, runs a closure and restores the policy before returning.
> +//!
> +//! [`include/linux/sched/mm.h`]: srctree/include/linux/sched/mm.h
> +//!
> +//! # Examples
> +//!
> +//! ```
> +//! use kernel::alloc::scoped::{NoIo, ScopeKind};
> +//!
> +//! // Every allocation inside the closure behaves as if `GFP_NOIO` were=
 set, even though the call
> +//! // site passes `GFP_KERNEL`.
> +//! let b =3D NoIo::with(|| KBox::new(42_u32, GFP_KERNEL))?;
> +//! assert_eq!(*b, 42);
> +//! # Ok::<(), Error>(())

I think this usage looks a bit strange, especially that you have to import =
the
`ScopeKind` trait which is a bit awkward API.

Any reason to not just have API like this?

    memalloc_flags_scope(MemallocScopeFlags::NO_IO, || KBox::new(42_u32, GF=
P_KERNEL))

Added benefit is that you can just define different scope kinds as bitflags=
:

    impl_flags!(
        #[derive(Clone, Copy)]
        pub struct MemallocScopeFlags(u32);

        #[derive(Clone, Copy)]
        pub enum MemallocScopeFlags {
            NO_IO =3D PF_MEMALLOC_NOIO,
            NO_FS =3D PF_MEMALLOC_NOFS,
            NO_RECLAIM =3D PF_MEMALLOC,
            PIN =3D PF_MEMALLOC_PIN,
        }
    );

Best,
Gary


> +//! ```
> +// # Implementation details
> +//
> +// Since the closure used in this API is synchronous it cannot contain a=
 suspension point, so the
> +// save and restore always execute in the same call frame, on the same t=
ask, and nested scopes
> +// restore in LIFO order.
> +use crate::ffi::c_uint;
> +
> +/// A per-task allocation policy with a `memalloc_*` save/restore pair.
> +///
> +/// Implemented by the uninhabited types [`NoIo`], [`NoFs`], [`NoReclaim=
`] and [`MemallocPin`]. Use
> +/// [`ScopeKind::with`] to run code under the policy.
> +pub trait ScopeKind {
> +    /// Begin a scope on the current task and return the flags added to =
`current->flags`.
> +    ///
> +    /// Every call must be paired with a [`restore`] call on the same ta=
sk, in LIFO order with
> +    /// respect to other scopes. Prefer [`with`], which arranges this au=
tomatically.
> +    ///
> +    /// [`restore`]: ScopeKind::restore
> +    /// [`with`]: ScopeKind::with
> +    fn save() -> c_uint;
> +
> +    /// End a scope on the current task.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `prev` must be the value returned by the matching [`save`] call,=
 the call must execute on
> +    /// the same task that ran [`save`], and no scope begun after the ma=
tching [`save`] may still be
> +    /// active.
> +    ///
> +    /// [`save`]: ScopeKind::save
> +    unsafe fn restore(prev: c_uint);
> +
> +    /// Run `f` with this policy applied.
> +    ///
> +    /// The current policy is saved before `f` runs and restored when `f=
` returns.
> +    fn with<R>(f: impl FnOnce() -> R) -> R {
> +        let prev =3D Self::save();
> +        let ret =3D f();
> +        // SAFETY: `prev` was produced by the `save` above on this task.=
 `f` is a synchronous
> +        // closure, so it has already returned and any scope it began ha=
s already been restored.
> +        unsafe { Self::restore(prev) };
> +        ret
> +    }
> +}
> +



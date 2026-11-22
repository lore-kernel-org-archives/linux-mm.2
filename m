Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520C6606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EoBIE6Fy
Received: by kanga.kvack.org (Postfix)
	id 5DE696B05B2; Sun, 22 Nov 2026 12:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B57F6B05B4; Sun, 22 Nov 2026 12:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB4A6B05B5; Sun, 22 Nov 2026 12:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAD96B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:13:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51E901A0702
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:13:41 +0000 (UTC)
X-FDA: 85463401842.15.045A4F5
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 33E5F40002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:13:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EoBIE6Fy;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795367618;
	b=2brZp5qDldGgQUEAs46iNDDGTAOOLQs7+p6vjomw5J85afFTFJF2QMGFpQxc6vrMHkuEI6
	CHBhMQabv+LrEWg1uUpC+ku2PU39GmcpqJC0uVVKulUgnw7TjGRDG5CgSj6BVwrgXJd+0t
	n+X9HNrlxVt2Mofe5fZdVvQUcXCD6U0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPf6sJRnnEbMVjtOP7dqL/u79Qa464lhAIbhREqU590=;
	b=U9adQLGswIso8XLtrXbhfMbKCco/fqwmEMIEgZOkv2qqAqvHS3BfIP+mgaHFiQUj3aCPiB
	quoVz3jnA7Odov2baPIKRK72grhzu32dfwUBX2GKf4h9g4tvS0n/yKCZ37ElH+XUFUEYGl
	I5qA87iXYa41u4qLCmvnjLJCIm0f0l4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EoBIE6Fy;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4kC6AZOtMmP0EPATz6rHMfodf/+PTsE6Fw+BaUFhlLkm4aVyhbvf0P07tBAf6iXGEnJ38IxmX546R9lSNlI/YZ3PpLZudQBLNvj89s9lqGhlv5aZArgdx2QZ66bH83gbmd1iazJC/cRBMLMivPVyS6gpBUS0hyYYd4KEVSs7E0aKSMsIE+KHfzop99YjJRsJWDlk3ANgU07yul9RS07BX6Al3dYtFr51kopjk37o/4xdXucmTpQwZfWmLHctDKoR5x2ulW67GFj30D6EadKc+Lo3B1PhkpqVeqt1fzOz/ipJqwrmtNNXtAVXcB4DIDvEdpzaHuzI4gnjcA/RbcK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPf6sJRnnEbMVjtOP7dqL/u79Qa464lhAIbhREqU590=;
 b=JUgAUz8PLnG+DZBEVRp+G3l3RCnKoanwHV7VYKAGkUgJLV9Ml9aKzU43xtop+SPuXhjC8lHrkCbbm8u5ZYEZZWUWdfiBH6/VnZ3auTJxRpamZDmqj8uTT7fUCMT5nUM719+ieLNhJrFZjpZA5TTWmBk1v5JmjcUf+qMvPh4p3kgdM59DIPg5ybEbqxkiKNNW2/pB9qfK+bD9XwP2vaV18jCbUyApVplJGlQXL8cWma6GR5r4RFwh6jYv5CQv+FYeg6oA1D+MDLNY5QL2R+FcjZ6Jak1GIZC8dFRDfZC4JO2AJeUXBuqVJMgtu4Qpf685mJbuuj/L2TqFuUad6XT4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPf6sJRnnEbMVjtOP7dqL/u79Qa464lhAIbhREqU590=;
 b=EoBIE6Fynq8w9qLKSB/PuwiAzmBsgFEDZyxYC35Iy89NTEgu48d1jgOa77XG56Du1zMkOdCsKI2k30iN1ZLJNIz1g657LWuBCc3nYaxOFSt/0O1QUYm/ogjeAcreQghfwDwT/9gjAsdw769Yr0eY1h/jnE3Ma0EqPwqOB4l5ZJo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB7576.namprd12.prod.outlook.com (2603:10b6:8:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Sun, 22 Nov
 2026 17:13:31 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0615.013; Sun, 22 Nov 2026
 17:13:30 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "tejavojjala@google.com" <tejavojjala@google.com>, "Rao, Bharata Bhasker"
	<bharata@amd.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "david@kernel.org" <david@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "surenb@google.com" <surenb@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "nhuhuan@google.com"
	<nhuhuan@google.com>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "rientjes@google.com" <rientjes@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "torvalds@linuxfoundation.org"
	<torvalds@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Topic: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Thread-Index: AQHdelNQK9xyGOWW3E+nupmHNSP0mbc6VO4A
Date: Sun, 22 Nov 2026 17:13:30 +0000
Message-ID: <6eb8b1f35116a0cfff7f27c0afbd2002f62943a0.camel@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
	 <20261121233006.bc03ca9b7889c93a482791aa@linux-foundation.org>
In-Reply-To: <20261121233006.bc03ca9b7889c93a482791aa@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DM4PR12MB7576:EE_
x-ms-office365-filtering-correlation-id: 5273c61c-61dc-4f66-c9b8-08df48bbee63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|7416014|366016|22082099003|18002099003|3023799007|56012099006|261102123227099003|261021123027099003|4143699003|10067099003|261021121427099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261026121527099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 YbQEknwC7P2CiIBM5TfZ0jbTlzx5UFZpHRxL2lS9j0lqR8I5p3vDjBEUwqblU0pdLCT5Ggc8XfAwzpYf1UwTwXrd4J1ZbpgnJ/53ONYGJZSxQgSmgwLE1znjW/1OI+fwrDv7oDYnhAYL2k3o8sIiImT8Uk1falRdejfX5KHKfPcHoD/rRteVF2eh+qC2S9vZUKFeSnvOEytVBkWpayHW7Adfq8rjBwWnDz+JrIGxfNep7lSwcwyyRTOMX1hYLrFhLyHACfpl34tkpLg7qzXnbcvH7tAf9je6P3Shuff95gfMGyY9m6sdfd41zJwU7vaj1FogW0LJ/uOXax5SuV5v5dzW8VrB3ybDZYYkHLH4WzpiJH3go+QdjxkwKOBcsxei8Q6Ub5lPwJRJqq/iaT+AgyKyioa09+E72F1An0dQR2rDxnlXC0PKTrBmOAtsg33MhctaSBNgS7QsdbnthKtDGq07KUIgeciKrRYguA307dhGMsQmaMPjTUVTmHP4dj8plijaFvq9yVbimBemcI4novDbzJIXQlnUTBQGCkMg8wbR8GBGhYVq7mlWtJDnFyFh/GJv0oAEcH4GoVKMVrZjGjgk77PIk8UAqDsPF0pfUY28JJ4KLB6naBfxDZb+fs5KImCe/IMKftgJI2DJ+I2hrhFLs8hkGEBrJ09w0bydwEYAYU7m+SJcVjqaAULpcyc/glxNPe5KbJbGX+QND05auJnkJUNnCpZgvriW+kZLwqc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(7416014)(366016)(22082099003)(18002099003)(3023799007)(56012099006)(261102123227099003)(261021123027099003)(4143699003)(10067099003)(261021121427099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261026121527099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjFzakVBbDZXTTkwaHkzb29EbFV3MnRWZVBHc0ZRbFZrR01uZmRWY1RINDlW?=
 =?utf-8?B?Z0hjVkkyUzdXaC81dkZhdkNSUHk5UFZMWngrWitFaWcvbnROUENqcmF4YmRw?=
 =?utf-8?B?L1VhSEJKdGFzaU13Q1Y5dGF0M29pdDg0Wk8reFF1QjZUV0ZlRUsrMEk5K0ln?=
 =?utf-8?B?VnRVTXVRSHZIQXNUMmdPbDBpR0FrMVUvMG9CcTl6am9GUnRPL1dFYlZZN2VY?=
 =?utf-8?B?UnRNdTIwa3BFYm9uNFhxZDAva0JYYjVZRmd6TlNmRGVUd2d3NU5PSGlQd2lN?=
 =?utf-8?B?NyttNzZRME9zdnc2Sjh2QjJQTWkzVGRsVjRUU2p5djc4OStTU0MwRW01cXpy?=
 =?utf-8?B?RUh3U0QxU2lpL0dNdEdOY3BMdTFCbUZyMXN1OWtZdWc5VWdNejlnS210dTRN?=
 =?utf-8?B?N3NRNmxoVEdhSm52YWsrclNiUUhaMHpRcmR6UytCcE1EOTk1M2JOR3QycGpv?=
 =?utf-8?B?OGNydFd1ek5PemlrcHd4eHNOOVE4YzVHZzNJbGFNeUpjUjl1K0lzZkR2ekFV?=
 =?utf-8?B?SlQrc1RkUnA5THI4ckVaY0NwWGpsV0FXRnMwK2wrZTJIbFhzTHRtQkhrQ043?=
 =?utf-8?B?a2cyYzFsek1TMkhMU1YxYVI0K2F5M1l5VHhEOHI5bFlJYVFpUERuL2tWL2U3?=
 =?utf-8?B?QzQ5RlFoc0IraUdjamM4bE9Ecnd2S3l0OFpiS0VlRm1sZjkzYk12TVNsY05V?=
 =?utf-8?B?c3VrVzhpNStSaCt4UFlWbk9UM3o2aUFFM2xMc1poWmpicjdlc0pFRUNYNnFM?=
 =?utf-8?B?YW05clNMTnpZWHF2a3VqNFE0bDNNOUMwL2tWeUl5YmM1Z0xsekRPc1JmMHpp?=
 =?utf-8?B?MU11RHFVY0lLTTVYbjRtTHdmbXk0QnNzVm5pRjNsL1pRSyswS2FpdXVrZ3BM?=
 =?utf-8?B?KzRwelVGY3h4K1BDWFhvamxyZ0pRUENWQjRubTU3ei8rejVRV3J0L3JaMStt?=
 =?utf-8?B?WHIzRURid09vQkh6R3dhdnIxYUxmUlUrV1QwYnVzSVdmM0t1YkdXdEdPNHZJ?=
 =?utf-8?B?djFiS3ZCNUZINkFOZ1IvQ2VQVDM4ZnRkVThnSXFOZXUySGlmWEhKRHo2KzUw?=
 =?utf-8?B?TmpqTGRTbXo1dW1KV3Z3VXpsVlgvNVpSS2RtT0diT2lkcTBIeEl5d3FkTER3?=
 =?utf-8?B?WnVpVnp0aFRqN1VuNGFuRTRFWHhuWmxWbGdXUXhBNUcwVE8xbzgwUWUzQk1C?=
 =?utf-8?B?eUJybUIzdFBueDBsa3Uxak91K2ZHUU91cng3U1pJN3h5T1AwQjZMNHR0TkJz?=
 =?utf-8?B?WlduNlRtcEhMY05Db25scmY3UTBxbGh1cWVBTGFyOXo4eFJUY2JDNW1CU1N4?=
 =?utf-8?B?eGtFUUtHVytML1dVd0luSWgrQVd0SG43M2NqYXdTQ1lRVVdRZlJhazhKRkpC?=
 =?utf-8?B?SGJWMGQ1cFA2VHJWc296bzFWOE8yWGJHVjRJK2xaSUtDeFlGR1FrREI5bUpJ?=
 =?utf-8?B?amErWnRSb2JzNnVHRWNyTFVVc2tScDdKZDE4enRISFp2cXJCbU1yNFFlekJV?=
 =?utf-8?B?MGtDUFBNL2ZQT0ZYNUJnTXUweFBhTCt2TVFuZFdlN1lhcXpyNXFVV2dwQzZm?=
 =?utf-8?B?OVhiclJzUFZjbXVyVHd2Ulc5bHMrNnVkM3ZSa2c4dXNVUy92OW5aMk1ENm1v?=
 =?utf-8?B?aWtqb2ZVTHpZSWsrR1VxS0I2Wk1iYnpuU2wvRDdneG41dzV6SktNWGl2WGly?=
 =?utf-8?B?cnpzUzRiTEZ0SjBRMWlqd0FLVVptaFp5VW9Fck5ENkdtbmZMcW9pejBFWUtF?=
 =?utf-8?B?ZEhIQWR5N3NnQ3ltc0tsOCtNUU56d2tsY3BJZkduZFhDMHRSV3pzZzJpMEhr?=
 =?utf-8?B?WGtweW1XbndKRHBMc2ZYa2tYU0ZKK1daVDl6T2FKa1Fsa2NIQ1d1Z1NJaHhx?=
 =?utf-8?B?WUpMaklHTlQ1TU1IQng0RlQxVSsyVmRqWnJ1ODlxbWc0Zkp5UnlzNDVMUnkw?=
 =?utf-8?B?TW1IU0NINWRSVUN2L2tWYVB6WmxCdWR2UHE3ckNLeUZyK1gzRGw1NFVlcGFl?=
 =?utf-8?B?a2YrcWczaDY0UUlBLzJKV3lTeUxZTmc2dHhHWFVjZ1RWT3hGVEx2MDBtczJH?=
 =?utf-8?B?WWxtOE1MVVovUWVTVHpkeWF2emtYSEtjVEs1Z0hHYjF2SGJMSDdQblVKQklt?=
 =?utf-8?B?SjY2MEV4VWhTeGl2aVduckRJTTl4UjY2RU9aMUJXNVV6QkVWYmFEQ0hEYVpM?=
 =?utf-8?B?TlI5UUNmOHJMMGlIWC9KYUIxaSszYWFueDNsRG90Y0hVRkV2ZFlDZmc2UXNR?=
 =?utf-8?B?eEpYSTRSV2QvMGVSbTY2dkE0eFdlMzhzWnk2c2Q0ekRGUWdUWGdCTXRhb3ds?=
 =?utf-8?B?OWN2VG9jbGZFUGxsek1zaStZRitqZVZubklkc3pqdGpEY25aS1lmZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D6476AF0E014B4598F3C76933F389BB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5273c61c-61dc-4f66-c9b8-08df48bbee63
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2026 17:13:30.5488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXGIMjjnuGOvMfdEbURvHMIN2RB978bp00BMzPuyjTAuOmc6E1TJOyemWk70uOFbouXLCBAbW4q1RFmlw1ckqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7576
X-Stat-Signature: oigg9u8hemio169ftu8ejyonyttn3e4e
X-Rspamd-Queue-Id: 33E5F40002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795367618-585806
X-HE-Meta: U2FsdGVkX1+oMWiyHag/oVaAqLbPmH++R3fSbFuEPIv1AgoPK+7OsRRrnFmfBlfW5ISIJuuUCVxiPmU6wWZDSxj2JXjRgri6un4pt7fmKAAr34RXjvZeu6h3G03iF5e8DWfYxfaKeelIrKOx9ijJk4m/N4cZnuFHxgrVipxkg9nFxDBoD2cWwPAzn3VWfIZoP+pEPNIZ69g0JvB7B68AEU5Fntx0Grot8CwsuzFmlhDy+x98xoBLBwrn4CsOYHkdoVmSt19Lbpl8YyJSaKwOGrmyIYYLbWpqlHBcisd4sgNJ1Vmz+0qGXEhgKy0zf5a8MiA3Hrp2aOAf9OV93Cs06Ejw45PYIs7Tpnm2IFWN+EFDQHmrgDB4CpsZyGWakz0ohGubQ5yTofsf/BxQIi1hWd44mH5H1oKY9T1v3pvp83Ybv938fO8nnD33423fbCOUcfKvNL9EOi0UtG2X60GVSdAQFNnXDGBQarP5Y/mV0oPsBd/6WtM1aTrGkM9IUmGOy/Na84InOG18lj9tSCOq8+SGUJuKFukZvze04JltPkoj4XA07utrZlaiEvnic7Y9DIgEJUJJrLCu+k3+d5/tuDGKOgTwPHsvrqazNvrB+W7Qyj2Khpf2MbTsWWuO+TA44/8g/iI1ey24b3wauEZ8U4gI4qrbnWG8ZJTpFXdy1iudjgvlHWA7PoJv9W3jO1/+QzJ35dsiiFapfYC30HuHBQGFCXdyokuPmiiVqs8VMpPu6y6PNv+zuWcFdADVRI48EVtSMO7vGh2lW/OUGgGKszKerXb0OyZ5T3XxnTYPHBxZycn7OBQyKKNPL16noJsCtf95GJ6BR1EOaDxK0mZUKasSQc1GSuFNeOkMTXUfF7TZf34L+Ulh4RlQvlyuacA2r/3/JhvavTZY82vjEal0mmf/EAdOWUIeKsYH4cXgAzo6w5xKSl+5TCleXrp3Fb6fjT8ZR2YlVGZmjkNTitW
 Tn98rSUc
 XumCaLryH1I51f5BI4ZAdsipA3itYcAl0pT5I3olOUqPpfFNsteGDjVAKmc3ozlLuIFVgh0+QdipN2VlW3/tyJr6BTz2Il1APcJksuBTYkC3wmjahrx01fx+plrUCDr92iecb1vCJmO/Ln9iPXShHT72G6S0i0t8YxaEFsKuzjlQpbBAqPSDD2lcC95Skz4YdAW1iY00FBhjqZuYVa8H0jKjdO9pZwEQ1OOVS5eEwJ797nj5OTClOPzZE1zxVuqFz/X9C1x17Ef/MwRDtfe2JWU/R2WPMRMn4LN7FVdQUPiF9MsrVoaMRXxDU1jNWvL5nqJXkxO0/jwKUySARNxmNVx/8Tcwsig/lKwFoNuROc+lx8RgYm3hhBTSss/o5mOjkdA3G0PfAr8vVfvioi7EHsk3nIj2Vq32roxfnH6E1Yd7mro0tehNNJrF0gTZJc4Ri6PQcpSzmq0/G+jk1T2nY/zIytDzOo0bgiHRddeiKw7TmhGz71xRNveOfuH0qyV4J/loGCtRRKFbhmFVeZ1bXOL7Gi1DxNmrwGU3Yz0drn5CHCUIT2xXIeSHZbRJNh/Ba+18HrqH8e1XWrFTTqhB9fUhk9koJ1Nrpv7G8JECMika3fr0GBft5phfXYe9+8WK1hGYfRrC/Z8QVq+STcsPxEtEIrM4KWlxt9tim0V51/Tdx7El8eHVwDP1955K5ao+MFAH578ztbQY8QVsGj0yGJz90snCflga5BeUgKGL3yh5vjAvOgckMioQONfRjdrlOswg/gtdkiVRaho/7+fnMNxWWKR2A1Zx6ETjQwr8esAxb2xYLatuhrijYSn/vA0hhQkQe+HV2kKRjIIG2g48LpYt5PMY4mi408u3H2CF5DzSSd/qo/MIsWx7E56O0PvnFhejR1SUDI0g+Rk6asWABUWAuyRWJd54Y/LbjhM4sQVTsktlECxAS/oJtFwB4Q9h4LhVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU2F0LCAyMDI2LTExLTIxIGF0IDIzOjMwIC0wODAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0K
PiBPbiBGcmksIDEzIE5vdiAyMDI2IDE3OjA5OjIxICswMDAwIFNoaXZhbmsgR2FyZyA8c2hpdmFu
a2dAYW1kLmNvbT4gd3JvdGU6DQo+IA0KPiA+IGZvbGlvX21jX2NvcHkoKSBjb3BpZXMgYSBmb2xp
byBvbmUgcGFnZSBhdCBhIHRpbWUgd2l0aCBjb3B5X21jX2hpZ2hwYWdlKCksDQo+ID4gc28gYSAy
TUIgZm9saW8gbWFrZXMgNTEyIHNlcGFyYXRlIGNvcHlfbWNfdG9fa2VybmVsKCkgY2FsbHMuIEVh
Y2ggcGFnZQ0KPiA+IHBheXMgdGhlIHN0YXJ0dXAgY29zdCBvZiB0aGUgc3RyaW5nIGluc3RydWN0
aW9uICgiUkVQOyBNT1ZTQiIgb24geDg2DQo+ID4gQ1BVcyB3aXRoIEVSTVMpIHBsdXMgYSBjb25k
X3Jlc2NoZWQoKS4NCj4gPiANCj4gPiBJbnRyb2R1Y2UgY29weV9tY19oaWdocGFnZXMoKSwgdGhl
IHBhZ2UgcmFuZ2UgdmFyaWFudCBvZg0KPiA+IGNvcHlfbWNfaGlnaHBhZ2UoKS4gV2hlbiBjb3B5
X21jX3RvX2tlcm5lbCgpIGlzIGF2YWlsYWJsZSBhbmQgdGhlIHBhZ2VzDQo+ID4gYXJlIGluIHRo
ZSBsaW5lYXIgbWFwLCBjb3B5IHRoZSB3aG9sZSByYW5nZSB3aXRoIGEgc2luZ2xlDQo+ID4gY29w
eV9tY190b19rZXJuZWwoKSBjYWxsLCBzbyB0aGUgQ1BVIGNhbiBvcHRpbWl6ZSBmb3IgdGhlIGxh
cmdlciBleHRlbnQuDQo+ID4gT3RoZXJ3aXNlLCBmYWxsIGJhY2sgdG8gY29weV9tY19oaWdocGFn
ZSgpIG9uZSBwYWdlIGF0IGEgdGltZS4NCj4gPiANCj4gPiBPbiBhIG1hY2hpbmUgY2hlY2ssIHF1
ZXVlIHRoZSBwb2lzb25lZCBzb3VyY2UgcGFnZSBmb3IgbWVtb3J5X2ZhaWx1cmUoKSwNCj4gPiBh
cyBjb3B5X21jX2hpZ2hwYWdlKCkgZG9lcywgYW5kIHJldHVybiAtRUhXUE9JU09OLCBhcyBmb2xp
b19tY19jb3B5KCkNCj4gPiBkb2VzIHRvZGF5Lg0KPiA+IA0KPiA+IGNvcHlfbWNfdG9fa2VybmVs
KCkgY2Fubm90IHJlc2NoZWR1bGUsIHNvIG9ubHkgdGFrZSB0aGUgc2luZ2xlLWNhbGwgcGF0aA0K
PiA+IHdoZW4gQ09ORklHX1BSRUVNUFRJT04gaXMgc2V0IGFuZCB0aGUgY29weSBjYW4gYmUgcHJl
ZW1wdGVkLiBTaW5jZSBjb21taXQNCj4gPiA3ZGFkZWFhNmU4NTEgKCJzY2hlZDogRnVydGhlciBy
ZXN0cmljdCB0aGUgcHJlZW1wdGlvbiBtb2RlcyIpLCB4ODYgYW5kDQo+ID4gcG93ZXJwYywgdGhl
IG9ubHkgYXJjaGl0ZWN0dXJlcyB0aGF0IHNlbGVjdCBBUkNIX0hBU19DT1BZX01DLCBvbmx5IG9m
ZmVyDQo+ID4gdGhlIGZ1bGwsIGxhenkgYW5kIFJUIHByZWVtcHRpb24gbW9kZWxzLCBhbHNvIHdp
dGggUFJFRU1QVF9EWU5BTUlDLCBzbw0KPiA+IHRoZXkgYWx3YXlzIHRha2UgdGhpcyBwYXRoLiBU
aGUgcGVyLXBhZ2UgZmFsbGJhY2sgY2FsbHMgY29uZF9yZXNjaGVkKCkNCj4gPiBiZWZvcmUgZWFj
aCBwYWdlLCBhcyBjbGVhcl9jb250aWdfaGlnaHBhZ2VzKCkgZG9lcy4gT3RoZXIgYXJjaGl0ZWN0
dXJlcw0KPiA+IGtlZXAgY29weWluZyBvbmUgcGFnZSBhdCBhIHRpbWUuDQo+ID4gDQo+ID4gU3dp
dGNoIGZvbGlvX21jX2NvcHkoKSB0byBjb3B5IHRoZSB3aG9sZSBmb2xpbyB3aXRoIGNvcHlfbWNf
aGlnaHBhZ2VzKCkuDQo+IA0KPiBPSy4NCj4gDQo+ID4gLS0tDQo+ID4gT24gYSBaZW4gNiBzeXN0
ZW0gd2l0aCBDWEwgbWVtb3J5LCBtb3ZlX3BhZ2VzKCkgZ2V0cyB+MS40eCBmYXN0ZXIgZm9yDQo+
ID4gMk1CIFRIUHMgYW5kIHVwIHRvIH4yLjh4IGZhc3RlciBmb3IgMUdCIGh1Z2V0bGIgcGFnZXMg
KG51bWJlcnMgYmVsb3cpLg0KPiA+IFdoZW4gZGVtb3RpbmcgdG8gQ1hMLCBrc3dhcGQgdXNlcyB+
MzElIGxlc3MgQ1BVIHBlciBHQiBkZW1vdGVkLg0KPiANCj4gQnV0IHRoYXQncyB0aGUgbW9zdCBp
bXBvcnRhbnQgcGFydCEgIEl0J3MgdGhlIHdob2xlIHBvaW50IG9mIHRoZSBwYXRjaCENCj4gWWV0
IGhlcmUgaXQgaXMgYmVsb3cgdGhlIC0tLSwgd2hpY2ggbWVhbnMgInRocm93IHRoaXMgYXdheSIu
ICBJdA0KPiBzaG91bGQgYmUgdGhlIGZpcnN0IHBhcmFncmFwaCwgaW4gYWxsIGNhcHMuDQo+IA0K
PiA8ZWRpdCBlZGl0IGZpeGVkPg0KDQpTdXJlLCB0aGFua3MuIEknbGwga2VlcCB0aGlzIGluIG1p
bmQuDQoNCj4gDQo+IE9LLCB0aGFua3MsIHF1ZXVlZCwNCj4gDQo+IG5pdDogZG9lcyBpdCByZWFs
bHkgbmVlZCBjb25kX3Jlc2NoZWQoKT8gIFRoYXQncyBub3QgYXBwcm9wcmlhdGUgZm9yDQo+IGN1
cnJlbnQgbWFpbmxpbmUga2VybmVscy4gIEkgZ3Vlc3MgInllcyIsIGJlY2F1c2UgdGhpcyBwYXRj
aCBsb29rcyBsaWtlDQo+IHNvbWV0aGluZyB3aGljaCBkb3duc3RyZWFtIHBlb3BsZSB3aWxsIGVh
Z2VybHkgYmFja3BvcnQgaW50byBvbGRlcg0KPiBrZXJuZWxzLCBldmVuIHRob3VnaCB3ZSBkaWRu
J3QgY2M6c3RhYmxlLg0KPiANCj4gQW5kIHdlIGNhcmUgYWJvdXQgZG93bnN0cmVhbSBwZW9wbGUu
ICBHbG9iYWxseTogIlJvdWdobHkgNjAlIGFyZSBvbiA2LngNCj4gYW5kIDMwJSBhcmUgb24gNS54
ICh3aXRoIHRoZSByZW1haW5pbmcgfjEwJSBzcGxpdCBiZXR3ZWVuIDcueCBhbmQgNC54DQo+IG9y
IG9sZGVyKSIuDQo+IA0KPiBJJ2xsIHRha2UgYSBsb29rIGF0IHRoYXQgU2FzaGlrbyB0aGluZy4N
Cg0KDQpBZ3JlZWQuDQoNCkZvciBvbGRlciBrZXJuZWxzLCB3aGVyZSB0aGUgbm9uLXByZWVtcHRp
YmxlIG1vZGVzIGFyZSBzdGlsbA0KYXZhaWxhYmxlLCB0aGUgYmFja3BvcnQgc2hvdWxkIGxvb2sg
bGlrZSB2MiBpbiBteSBvcGluaW9uIChjYWxsaW5nDQpjb25kX3Jlc2NoZWQoKSBldmVyeSAzMk1C
KS4gT3RoZXJ3aXNlIGEgMUdCIGh1Z2V0bGIgY29weSBjYW4gcnVuIGZvcg0KYSBsb25nIHRpbWUg
d2l0aG91dCByZXNjaGVkdWxpbmcuIEknbGwgbGVhdmUgdGhpcyBkaXNjdXNzaW9uIGZvcg0KYmFj
a3BvcnQgdGltZSA6KQ0K


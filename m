Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43516EC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE6C6B0092; Thu,  5 Feb 2026 08:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C976B0093; Thu,  5 Feb 2026 08:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E656B0096; Thu,  5 Feb 2026 08:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8031D6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:21:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43E71160549
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:21:59 +0000 (UTC)
X-FDA: 84410465958.15.44A4215
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022095.outbound.protection.outlook.com [52.101.96.95])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57E7B1C001C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:21:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=KVkjzVur;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.95 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770297715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wh8qW6xwR3Y83irtAbziNc0hGcc/XN0c+iRXooG2XQ=;
	b=2nqUKRwA9zIWRTH9u8jb1EFQw94i/052clkPDFQaT2kIBo8STD1XNT8e2PosF+EOY6q7wr
	8Q2Ku6/4QlpsRPbcrMPbVGWWi9t0TMeDdGA5uX2yJ4hBfdFXG2THDLahDxyLDttas1YlBY
	IE9DVxl0QF8U5EQTzHpzCOUPclYqzQY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770297715; a=rsa-sha256;
	cv=pass;
	b=uLGo3CyxoKZKV9298rM6hx239Mc1Opn0rLKXrMif9T5UFHEtYhD8BAGCdqrLwYHHbEgxhH
	dJV2J324bj9oc3jukVf9CPRrjiMka71XYkAZqOaIVLnhZztm88A7IkYp/ILaGXz46GX1ed
	dpS8Q9fCt53v/pbCUPHGp+qgrVQqFAQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=KVkjzVur;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.95 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anK59EADLUXSieWh614vOyBeLlywjGnd1+wnAbl9TGKnO9iVORL9X5ASFNAD8uto8PGEAZzFPULup3MP7ZbU7cJ1Y7GjFU1Dj1SfUGmgTRdgDZbwJtPH1MY5QTAlKzUNArV07X7w009AEonfCIoRhW5mNzyLTV9R5doX3rj5oh9he+GRw90A+TE8gVtp7aNJztvPkMvFnloxvFWds7rqZYDqVgeO2oiG1mKX/1I7hadeFKkuOBvMWPhfoIwCCHA1qaaoh1ScrBPdJSX4qs0GAtxIO+GjCEhjEe72tYpcAZV8xz0vyXf5eZ2uLRYU/vYea4iDV+B5122fQ2uNAisxLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wh8qW6xwR3Y83irtAbziNc0hGcc/XN0c+iRXooG2XQ=;
 b=D2t8XRsJP/og/PQEsUCUcZIBUTeMU+JNtTOTxxFRaks98QbsVV3MO4Dqea1gjs1FbwFYfb+LsMLFnWImw8p6V63Z0AgeMRkkEWq26gjsy8wKgkV0f8OjmZDkRhu9AXNKkgiTQUReThUltFOuUtfMARIcylljB2yXHXOWAEjRzUxXFb3dOfh3GBlDKs0zoKhQ0kaWrIRGYWd1MoSDvRjhIxC5YIQe3MybnzHL9lF5AucGYq23VQOG6DdpGtsS0mZI09Ds+7NSCa2P0viy/JqgkaAtVgGWVrzdD8TWt+V5rlP2tiB1q3Pk3DnI95qR2lVn6gbasYiITUpfpiCDszvGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wh8qW6xwR3Y83irtAbziNc0hGcc/XN0c+iRXooG2XQ=;
 b=KVkjzVurxhFP8qjDQQ2inBid1sdGrsdqjKGOBUvXPIpv8gNUlDCHAXgluJDFh9tB0gKCNdbmgW4PL05VfSRx0oX9wVPiNmonRNWm9vGQ5M2rhJNOR35vvaQed5upYOSa8fAN9k883plxsBE3yKzPzWj5wZ9Ix5uNvb4pOANt8FI=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO2P265MB3296.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:177::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 13:21:51 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.016; Thu, 5 Feb 2026
 13:21:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Feb 2026 13:21:51 +0000
Message-Id: <DG725XBFQBWE.286RQFKOIX19J@garyguo.net>
Subject: Re: [PATCH 5/5] rust_binder: mark ANDROID_BINDER_IPC_RUST tristate
From: "Gary Guo" <gary@garyguo.net>
To: "Alice Ryhl" <aliceryhl@google.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Carlos Llamas" <cmllamas@google.com>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Paul Moore"
 <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Dave Chinner" <david@fromorbit.com>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, <kernel-team@android.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-5-dfc947c35d35@google.com>
In-Reply-To: <20260205-binder-tristate-v1-5-dfc947c35d35@google.com>
X-ClientProxiedBy: LO4P123CA0126.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::23) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO2P265MB3296:EE_
X-MS-Office365-Filtering-Correlation-Id: 723d31f8-c37e-49fb-2059-08de64b98641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDF2NXd5am1WNzNkZmdzRktQZC9lUVNxeXl6aVE3N0YrU2tqdlRqQ2IwZlhl?=
 =?utf-8?B?SkEzRWloWnc2K09HaS9hMjlnS2dxZGJTcVRHdEkrczYza3d6Sk9oV1E0WVMx?=
 =?utf-8?B?L2h1WlM1ZHNrQURPMU5pd01FS2dHYXg4UWJPbXNxa2ExdDVsM2lSWjk3Z0lV?=
 =?utf-8?B?WnVaZnlTNzR6OG94Zm5UblJrekNQZEdpOWVmY1ZLTjJtQzJoaXM0YzVZSUs2?=
 =?utf-8?B?RnVwc2l3MWFPQzJjYmRrdlYrVkZDNGh6dlBUb251N2tPcTFqVWVlVS9FWTBU?=
 =?utf-8?B?czc3d1ZzdWE2anYxMEFUNXl6b1FIeVBEZEhsUWphUGpaRDdvSFd0RCtxNWM1?=
 =?utf-8?B?bkM3OEpPV0M0bU50OXFYZXdkeXIxWWdGdnRTSzBJYW1NRnJWVnZlczI3Nkhx?=
 =?utf-8?B?K09YajlNWEhoZjhGZFFKdXlUeXlqZmdUeldKOWNWZ0Z4Ky96clBvQktwUHlT?=
 =?utf-8?B?T0dLanhJVHVRclVwallFRDZQOEVvMlF1aHBiSWdQejNBTFRHelZWbzNGYXBn?=
 =?utf-8?B?QzVFNVRZV2tKYnJaU2VTYU5lb21yNjdyamVsN3lKdWpWazNEbFlzTTQzczFz?=
 =?utf-8?B?QVhjQjkyOEZzTWkvZnNaNGlBaUdWUnFsSVF0OWc2V29kbXJseDJmeXFBbWlR?=
 =?utf-8?B?OTNQL3VSYWFzVDVQZ2ljYTRFd1ZyTE51VGtMcTJnaldxZjFvcldJMWhCSVlw?=
 =?utf-8?B?UHNvQnB6eWd3VFdQZ3pRQjlxVWx1UU42a0N2SVJ2M05XRGhueFRhWHA1WnI4?=
 =?utf-8?B?d3Z0QjZuQnU5RGtzVWVjbVppYVdweTZWNnVMQURLRnpHYmc1WG1ZcVFQRTlu?=
 =?utf-8?B?SzMrYVRVZFdrblR2bnJTVFVtNWJDOUxsaC9jOEVWR09uK05JOStMNVl4K3E4?=
 =?utf-8?B?SFhHeTMvblZVZ1dwbnpXbTVsOWFTU282czJ1bjNuNU5FWWpFREY3TGtBOE00?=
 =?utf-8?B?bUVBVVM1VzJ3eEx5V1Ztclh5M1pyK3puZ3pmSmhpbDRlRlltSTZOSEdYdkhn?=
 =?utf-8?B?elE4R0tuY3dNMzg1eGhxOFJUMlZuS3pwVmpKK2pYTVdoY0Vkd2krTHRMTEM5?=
 =?utf-8?B?c3ozM1dOUzRXbWl4MHhoUDB1bnBIYzFJUmVQSWVuV2hiWDlheE9lZ1ovMjVq?=
 =?utf-8?B?TDRYM1lFekU0OFFYdnY2S3BnNk5KTGU5VW1tTE94dG9mQ1AvMDYyVHE5bGh0?=
 =?utf-8?B?SzlYRkRPdm5lMnFxSkFNeHFpaTBYbWZkOWw0QitjRTZmUC9nSk1BSmxqSmZs?=
 =?utf-8?B?QjR2empXaEFkT2M0M3gvY3c2QmVYTU1hM1VreGliNUhESm9jZVBhVTYwYURp?=
 =?utf-8?B?QUtUVnlYaDBnWDhHSnhXT1JjYXVremlVWFZOeG5UZ2g2SzJ6ZGp5bFBiN1VV?=
 =?utf-8?B?QVhzbXl1aDZ0SzNua0I1dzE2bFVwZFl2cmtic28zMC9zUFluVVBsMlRBMGlX?=
 =?utf-8?B?M2tFQkZ4UXVweGJxeGhjdDh1a2lsSmZCVnU4MnF0SWtQaFZJU2x6Q241NmRM?=
 =?utf-8?B?bnNna0RrdHJxV3NrVWNPOHBNTlRjVGtZaFF5d3dPRzdmVjFPR2pBenpISzVS?=
 =?utf-8?B?eDFPWUMrc0N5VkdJWEtEdXVFai96cXJBR3dwdzVnL3F6a1dZUFhVTHl1YXV0?=
 =?utf-8?B?MkVGUEJMclhCMFBZdkJsMVROcXFFeEg2TWMvRzE4YTI2R2FLSlAwSWJnYzNT?=
 =?utf-8?B?QzFHKzZJNlArUUE3SWxHT3BBS2RWS2E0ZC9EWUp2b1piajhiV3FodEFCWWw5?=
 =?utf-8?B?S2ZMQmlka0xXb29JOUl5K29wOVdCOTU5OTFzT1VtUjVMK1Ntdnd0TnViOHJM?=
 =?utf-8?B?M1NHQVZnWVlnSjNFYUg5dzhSTU40cHR4VEZQeklYYitFNDUwczBHVnluOE5x?=
 =?utf-8?B?TWhaa3FTUDdkK1ZRUlc1cStxNUptYzdTVDhsTzhuUk03ZjBtQSs3ay95Z0lB?=
 =?utf-8?B?cWl1SlhTMXdJVy9hVXNuWVk0VW5IQ29IMy9KRVFqekdmZzJ6bHFwNU5TRnpn?=
 =?utf-8?B?bnptMW9qTGZEUHZYQjJXaUpBMG81ekx6MTh4NFUxajNldlhqZHFKUngwcDIx?=
 =?utf-8?B?Q0NGTE1SYnc3WDdPR09RYmhPMEFnTjkyNUI3NklhSGpLZmo4a2FlSHBRczg0?=
 =?utf-8?Q?wkvg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWZ1OG0yb1pyZHFDN1JqMy82cGVJYlJJS3EyY1BkRmxvU0lEODRlT2NmYk1J?=
 =?utf-8?B?cWd4cUlkM1l3NWlzMDJhMlphQmNicWZBcjdQblpjOUdXWE9GbDlVN0pEVFU3?=
 =?utf-8?B?SnlqbFpvU01QOEtHdHByK05YSmJYZlducEIzWEpnZWN1MVQza2pOZjB5Y3NH?=
 =?utf-8?B?TURRU2pkc2dNZG9EK3NxQThZUzZ2d3Yvd2RSL1BJb3VzcnplZjJHV3JQa2Qx?=
 =?utf-8?B?QngwWDd1NktleXhxVklGYkhpQjBMTnV5V29wSk9Fb0FxVkhyTzlQa1FYSXlk?=
 =?utf-8?B?M2hBWGYxLyt5bDh0RFF4aStETG9Oeld5SVRnTTlaN2kwVzlDUVZ5L3UzbUdR?=
 =?utf-8?B?ZEdoOG50LysyYldBUkR2REdYdlpaYllmVCtIYS9IaWVTWVhvcEpVclcycVRH?=
 =?utf-8?B?SXpUaDdqaVlzWDMvNW0rKy8rakI0U3ptV1pWMG9uS1lsOUN6UmV1ejV1NnN5?=
 =?utf-8?B?S2RMUDNab2tMWFZuK2g1ODd1OXRKcGZjUVcvVVJtdTJoajdLeCthM0RndGJz?=
 =?utf-8?B?SXkvMkZrMWhCUlhHSVFBVkl4LzIzODdzOHpUUGxuR1M4WnJYc0R5d0JMMjlZ?=
 =?utf-8?B?QzdNVmkva2tzRWs5T2hsWGF6SnRJRlA4NFJUNkRDcVJpcjd4a0ZZZDRWREw3?=
 =?utf-8?B?Z2lOQ2lVMGt0NU1PWTBaeWpscGpuNlBPYVRuNll2c3RBaVUrK0NSUTQ0RUd2?=
 =?utf-8?B?VGtuamdBQzJ1V2tKRmR0UmdSRXp4MTFIUERTeXIzNGc4MC9PZUd3MDFLRkg0?=
 =?utf-8?B?Y2M4VHh0MVFRK0dNU3hZZFBiVjR5cVl5bkkrVjhxa1pueEx2RzQzTFpPVFlP?=
 =?utf-8?B?aU9ha0tCOEJLQ1ZzckE3U21ibmsrQWt6ME9YcDdDTjVJNmZEUDV4K3c2aFRy?=
 =?utf-8?B?d280R004aEVhRWJEMEMvU2dDQk1EMWdOamd3SXZXSlNCd0c5ZUFuZWlKNnRp?=
 =?utf-8?B?VkwwOWF2cmJ5aUpLa0ExSnloRHRIWVp3Y2pxNUlnaVVtMGVCbU9oS3p1QXhC?=
 =?utf-8?B?VTFVQWNRa25nZStVTGJxK3NvajYrQi95VmN1QXJ1eGN0NlVJUXlnSXRnUmVM?=
 =?utf-8?B?cUxsbFRZNkFNR0IvRUVDVU1ldXhkQ3d3NlNsVXFXcHZFMnhtNWJGTmNoY0Y3?=
 =?utf-8?B?SnQ4c28xbHE1MWdNS2hTVHk3bUQvS0sybUdxYk1ZdUdMaC9kRGxMSFZHL3Mv?=
 =?utf-8?B?dlNqZ1FsUkpYTldPbnJ5VnpHOWYrdzJvVnFlQjVpS3lCMmwrYTkrSmp0LzBU?=
 =?utf-8?B?M0ZKSXk1OURxVzdxa2ZLZmtKUTRxc0Jxa284c3REb1ZqTE14cFF6bWxkN2wx?=
 =?utf-8?B?LzIrcXJIellXMzM5MW9MWnZ3eHdGbkNKVXhOam0wU0wxbFRqT3F4TTNlRFZV?=
 =?utf-8?B?Z1BhMVplV1JiSFZXNkowbHlBZGNtWHhrODFhU2xZQVRidUF5YjhzdE55U2tG?=
 =?utf-8?B?NlN5MlhvSmRGOGpkUFlhbVh6SE9wUWl0M3ltdHBBWkhGcUYxMjUrL0tyeTZN?=
 =?utf-8?B?Mll2Qnc4RytGNnpzRmtvclBFMkhaMjlzS2tOMUh3SkQvaWZUTkFFaEFUTmd3?=
 =?utf-8?B?aWlkeGNLM3dxL2VZcUsyaHNYd0RMU0RPNWJQT2dtZld3Q253aHJyS2dCTHNV?=
 =?utf-8?B?ZWdrYmhKczErdlgzVnBETmtUamZqeU5IcndZSE5ld2NXbzN1a3JIV2ltVTNT?=
 =?utf-8?B?alIxQ243eGpEZDhpWHBaOEJvZW1vcjRHajZQUVlrY2plU3M3SE1HNFJkVXYz?=
 =?utf-8?B?YUczMjBjZ0xyRk5oZzB0UzdKRWZ1NXU4ZVNNVzRGa3VzYmR4bk4xS0Njbmxq?=
 =?utf-8?B?ZFlqM0RBaUhkMGZqS21PVTcyT01NV0FhbCsxTlpteHJJOS8xNUNEZWh3TkxC?=
 =?utf-8?B?NWlpSDlZZUdmT2tZLzR5NFpCSUxLbkFBeVdMM0dWMkZDVzJCWk0rKzc2Z3pR?=
 =?utf-8?B?UHZjNEVUdkRWZjFFZlkya0htNTdLTHJoV0hkc093ZjB6UHpxRWt2Q2tITHBH?=
 =?utf-8?B?L2RuMWFzNlRzcnZGeUpyeVdqZFRkWlFpYjdoeXBHeFNDK1VEZlc3cGNWRk1T?=
 =?utf-8?B?QTdxb2NuQWlNYmhJQVFQck4zbTRZYzJGd0w1bnA2VWFYYWFkVUxCanJoU2M0?=
 =?utf-8?B?R2doeXZRY0tId29yaFdJSzBDeG9UR0VoWmZ4QkF5d0owOXI3VVNMbW1RSDQ0?=
 =?utf-8?B?bzk3R0MzOG96SmEzS1Z6QjlLS2pvR3Rtck1MdG9xK1p2UGdWSUdSRllPTFJm?=
 =?utf-8?B?cXlmZDZGdDNNT1I2S0dTT3J4a0JldmdLVVVCVUNiY05JRmZBTFZ2RFJhcUJw?=
 =?utf-8?Q?jHTN5aqD1iiR3fXYVJ?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 723d31f8-c37e-49fb-2059-08de64b98641
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 13:21:51.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXvQrc7Z0VqnWfRl+nNeGI0pIcPbRGYYOy+lmFrln3HEWas4gDSnhF05NC9cbGEyyUyrqWw8UV2E5RXIiSXr0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB3296
X-Rspamd-Queue-Id: 57E7B1C001C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: e4iwqif9qoj196pkgch976g5qpne57n8
X-HE-Tag: 1770297715-500547
X-HE-Meta: U2FsdGVkX18HgRwPU8dImcTgT9TdsXqQJPDDf/xYvexZaeZa5XDU1mYm7CCjHe0DLNoClG07ronUecgSY3C6KbUnlUT6iD4BebmKHLOrT5lswaQYuF6t5M2J98LBxqvpdgQMf86pZfhH6p5Q/eoU2h4B/sGWMuCFW+8hiK4Lu+X+uDsYE//sWB//Sir3IkGAu1+8d+/LDSusEEHGJHy1Rq3K3ZQ31UAqRbsF5GOX2iwqiPKwWFc34CE4+ekvZb5Z+rnE64Y1Q65EfqaqB4eCP2cz6wWu4an2flwNrH64h7iNh2lUFyst90ANW1/zAbPZ5rFluZs3rB0ZZUhayJi3+Qp8tNXgwvYYx9023ZtNWA3AB3rE0RTMAzw5RpStZlous8WLXpTxaQY4r+RlkPQMuqqTvBbK6+K8bNDuB5g/O3DlWyhvBVx+gvU91Qtr6FKMinKb3j2fYz6H16d1NbQtZPCEBRbbJh2tbh/hF1mU/Okyr/Ck7kU2DJOcAV1efjjnQWAJaxfrs2e9RovVzzxY3cZriEAj4uQxTMj0dB+FWfHkNuCFvr1u1sJKjwNYWD9AD/VgprLykBoYe28ilF8XWKXuzkhKm29duQBinZyTN2X93U94hXQDX5gTdunhXaFFKOT0A5nKIdCdy1R9BawZkqH3QtheRgVYMFyYj4U2WKU6GcWphUFaJWGI+yIeaq8zYKXDCNQGfr+DqGn9mWw/J67czGdMkMXv9raRPoPpLLI28PgNQ8lAjtrJwXjha73NmatnJUMTjOZUIfTm/2e/TpTB+B7k/cBvlSnMJQ05dGLeP0LeAS4GM5BAMDPuWjfgtTiPN2BL2Eu5QvyrdBlSSnvQBxcpwnXfgZIvafm73O3zNQ7mVjZPPG99xWw2A3F1ocvnPJe3m5sToypPejUbLL0n1sef/FgRo7Uz3NcaYp17EE28xiX0t98w8gP/RB1GqQw6chBcHppulMT1rQJ
 25y/YF2j
 GGlJlgZrpcP5mejoV+yeovLplwW4HhKOoONL9kabVPJ8zcG/xZ+/UcMxFgNle5naRGKJUMRFDg+NBoqz+4FLGrPzWLE7v8foQPKQ1fLw/5J+2huUHgNUn5TGoKIbJzY7ew9I7Pfkb3HVT0je/q0NlXgcEEXj80DGaavMpIQyae1OYcYMgsvb2G68iZolbkzVOYoZU2C7Fer4prAg3CSNlzAVLbpwQQggcgZbz4ZbPRYmWrzJ3jhcVVuRw/q4BkPtS1l86jqjWIPGzUC0TSfyiCEUs/GyUqcjfY061fMss76hEcVbv0jet9DLdUdSi9ak+pdRZR/k4zVi0VA/H1VTVikdYg7bmW11ZQl2XWQUnHbXuKSY4YGqODfFMojLlPHV/FjCUXdPCTfs6WyxrIXx83HBdJi0O1eAMVvvkhsTFJ+eMhb8s+ch5kJx700rhZMCpQkAnQIcQvBmDl7H+M7SZEeYgvC3p6PFpJrTfu2y+bUmo8Iao8mYG81+NjmIfhpJlqykXiLRP69o5rNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Feb 5, 2026 at 10:51 AM GMT, Alice Ryhl wrote:
> Currently Binder only builds as built-in module, but in downstream
> Android branches we update the build system to make Rust Binder
> buildable as a module. The same situation applies to distros, as there
> are many distros that enable Binder for support of apps such as
> waydroid, which would benefit from the ability to build Binder as a
> module.
>
> Note that although the situation in Android may be temporary - once we
> no longer have a C implementation, it makes sense for Rust Binder to be
> built-in. But that will both take a while, and in any case, distros
> enabling Binder will benefit from it being a module even if Android goes
> back to built-in.
>
> This doesn't mark C Binder buildable as a module. That would require
> more intrusive Makefile changes as it's built from multiple objects, and
> I'm not sure there's any way to produce a file called 'binder.ko'
> containing all of those objects linked together without renaming
> 'binder.c', as right now there will be naming conflicts between the
> object built from binder.c, and the object that results from linking
> binder.o,binderfs.o,binder_alloc.o and so on together. (As an aside,
> this issue is why the Rust Binder entry-point is called
> rust_binder_main.rs instead of just rust_binder.rs)
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  drivers/android/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/android/Kconfig b/drivers/android/Kconfig
> index e2e402c9d1759c81591473ad02ab7ad011bc61d0..3c1755e53195b0160d0ed244f=
078eed96e16272c 100644
> --- a/drivers/android/Kconfig
> +++ b/drivers/android/Kconfig
> @@ -15,7 +15,7 @@ config ANDROID_BINDER_IPC
>  	  between said processes.
> =20
>  config ANDROID_BINDER_IPC_RUST
> -	bool "Rust version of Android Binder IPC Driver"
> +	tristate "Rust version of Android Binder IPC Driver"
>  	depends on RUST && MMU && !ANDROID_BINDER_IPC
>  	help
>  	  This enables the Rust implementation of the Binder driver.

Hi Alice,

AFAIK Rust binder doesn't specifically handle module unloading, so global
statics (e.g. CONTEXTS doesn't get dropped).

If we're going to build Binder as module, we need to ensure that we have th=
e
mechanism in the module macro to prevent unloading of Binder.

Best,
Gary


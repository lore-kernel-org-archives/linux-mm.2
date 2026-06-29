Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 670B8C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B216B00CF; Mon, 29 Jun 2026 10:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB956B00D0; Mon, 29 Jun 2026 10:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5BD6B00D3; Mon, 29 Jun 2026 10:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 073A36B00CF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:37:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E3EF8AE5B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:37:42 +0000 (UTC)
X-FDA: 84933203964.30.9D35519
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022073.outbound.protection.outlook.com [52.101.101.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E05E1A0008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:37:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=tqbBWUdj;
	spf=pass (imf19.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.73 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782743859;
	b=tegQHPmZLo7211GcuKf71U8lERxZ9wTQy0nHDRXifsKBxdLmYGNMyxx/O6qTOCbbqr0uxO
	8jWQ1yX3TcXjsNfdYVQStCPPoibWqlPLVNGFhjCsKRN+D/CfuPacSZirtP0OCqBrCuRQfO
	iM/ZpGwO27wRS+r2DBtxDb51DNeC8xI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV7oZKbABRxxMwpZXqVthvBESnI21SFwDJM/ql3zJvw=;
	b=fcjuetfKuxIgJwFgITqk+DQJIUg8Y93kDwSgy0TTzwsxkvbv4oLDNM7+jeLUF0RcYhB5lm
	DJEPYnKpFr9JlKLBH4wGJuDePJY+bmZyl0X8NvOFXI6BORVNxs2IwMCiE9DvORnolqDqCV
	DnNfaVUgACe/UIHSfgrUjTAmg4mLJd4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=tqbBWUdj;
	spf=pass (imf19.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.73 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfpQLrjnCsss0Y49a4PJzrP6ngLQ3DEKp2TZi36gKAZTgCci0X1BEoVhHpNEudcLq63gAUGYDz3ohVmF528LKQKArvLP1jujYx7TbV2Q4SFmqbifS6ojC1Dlj/lyK9MwU3ZG8/Zv3v4imn6mLusm2m8dMDqMXWUtB1uiQ+2bogvco1JtsfiN+P1Xldpu8RJontSXXcP/2D/FXjQkSThJ9mG561f4erE4PrWpcFAErWeqDpAL1lr2aOyH2nY+s5H0p4hQztfuwESJCUH4M1dLyZZpxJT8te781Pjcs+bIJxf3KHlLcCq8YAjdMyQSf2MZNxQNzxh5ChQ/HUKir5Gq9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YV7oZKbABRxxMwpZXqVthvBESnI21SFwDJM/ql3zJvw=;
 b=pXL7ZDq0NxmeJqEBQnmqiGAjp/tSFpdj8Jx6NeKlwLwc7/RjnVlMTkoF1mECxg3flT0UXamDYJVgpStEtqUcyzA9yG/7G5G97uQIt9H273zJp4O/s9s5YAj3YIdY/+T7tdnCq+UHCl7hO11EWlXP6bcaE+UveWQIyxqeboasxzOuWcoQrJXByB+McpPS1utIxee8eY+bhArQDozV+gWX5iFSlIl/h9x+ttKazfSAVNFzeOpKc3697rYMGUULPoxdpV8Me5CPIFZBuA2eJUwX8Pryo32ep4gJ5/Dr7uoO8iNuZGqrZSxDZko3Kq07kddkkuPmpMsadC5biNCElcug0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YV7oZKbABRxxMwpZXqVthvBESnI21SFwDJM/ql3zJvw=;
 b=tqbBWUdj5vka7a9zE3S8aiXnqyDJe+nELzeW5EaC9/FgWMUY0Fmve+FBc5/DPRMFUGtuFCvpdxjAJ9jplETJLMRo/YK745zKQ7UNFHQXqOcrFLm+8gKTVwEk8U72pduH53w1kFaGsIqeGc0VhPYfM4hPJdFCuuEYUhMt3sv5/TE=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWXP265MB2662.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Mon, 29 Jun
 2026 14:37:35 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 14:37:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 15:37:34 +0100
Message-Id: <DJLLYCLQEBV0.2L6F55OJ8A6B@garyguo.net>
Cc: <david.m.ertman@intel.com>, <iweiny@kernel.org>, <leon@kernel.org>,
 <bjorn3_gh@protonmail.com>, <tmgross@umich.edu>, <tamird@kernel.org>,
 <work@onurozkan.dev>, <sergeh@kernel.org>, <matthew.brost@intel.com>,
 <thomas.hellstrom@linux.intel.com>, <jack@suse.cz>, <ljs@kernel.org>,
 <liam@infradead.org>, <bhelgaas@google.com>, <kwilczynski@kernel.org>,
 <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH v6] rust: aref: make `AlwaysRefCounted::inc_ref` an
 associated function
From: "Gary Guo" <gary@garyguo.net>
To: "Trevor Chan" <trev@trevrosa.dev>, <gregkh@linuxfoundation.org>,
 <rafael@kernel.org>, <dakr@kernel.org>, <ojeda@kernel.org>,
 <a.hindborg@kernel.org>, <paul@paul-moore.com>, <aliceryhl@google.com>,
 <airlied@gmail.com>, <simona@ffwll.ch>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <igor.korotin@linux.dev>, <vireshk@kernel.org>,
 <nm@ti.com>, <sboyd@kernel.org>, <m.wilczynski@samsung.com>,
 <boqun@kernel.org>, <gary@garyguo.net>, <axboe@kernel.dk>,
 <daniel.almeida@collabora.com>, <shankari.ak0208@gmail.com>,
 <lyude@redhat.com>, <j@jananu.net>, <lossin@kernel.org>,
 <acourbot@nvidia.com>, <markus.probst@posteo.de>,
 <driver-core@lists.linux.dev>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-pwm@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260628095132.47753-1-trev@trevrosa.dev>
In-Reply-To: <20260628095132.47753-1-trev@trevrosa.dev>
X-ClientProxiedBy: LO4P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::10) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWXP265MB2662:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c89eaf7-5e09-4c01-cf62-08ded5ebf5fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|23010399003|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	lfW4LtejC5NkcjQrS2K1vSbpS1pcuHsaPqK5i1eH9LtK2wbCFOGhVTxv7q9bE6LOk9j655n8ggoEoITwmAnao0fxye7284u1HQWHOYMpa8CCnomhFe5ptU0pbIox2yiOXylK8AXRNoSrfv7/7yF/A1B5bbnvmRyRdv6R36hMrBxqrr0I82vHKxgvYkgddXkx6GzDglVHvNghpfOhapPIdjoWyrtbraszhhWkM0Ft895aV6+/Z5z45HTpbRdR6aj9IyborTscsCvavF93tonKUfqe9tSbHMPGFYLBK/9PaTAwnu6/ggVGdjKmJokKmziQs7KfuG22bUKYoWphXoZfTerRhpaKg2c5ZeITyG8EqERBfVrcLxKs66V2k6k1lELdidkovWPVLai/Qhffcibunylfz5o49Aud+BE+vTIgERV5SQ+Xa1zCKUu8pGG7f5FmCXcluaFuXIbk+abpa0uGwYMSZSjqaEiE+HcEzEfOvU1x4Pb0VH67KMwa6kLbtW/zDesvnnuvJ20TjDfCMzZJjHNes3zBBc4Q/PJnlWPXOrBoB02J/vUKja818VzoDwKI10WrLQ4sfB1z/pevlyJw+wiHgd0dha+SAJZXrN5h/V0HPngzZxWkCWVf7XudU9d+V/0sQ/dSUqHehB4r/jOtNe+bdifAoWyj+Cib0YBMaC+qqnF1eXxODXBoKyhc2+wTDH123y93izlTXqRK8xqNrw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(23010399003)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVRZbGNLTXl0clh5b0ovUTZJREpsTXJLeFRheTBIV2lpZ2t6ZmF2OVY5L1Q0?=
 =?utf-8?B?TjJ6OXRSWVVNMzhpTHlMSWxaY3BFb2tWNzJUMXVuWlgwMWlYM2pzdTNMbkY3?=
 =?utf-8?B?akRZRFdQMEFnQys5Z21HRXkvdS8zUGxTWC9Ody9yeExNZlJ0eCtIdVJLWW9L?=
 =?utf-8?B?c1ZCV2IveHhudk4zSERabjFQdXIzdGhtY1czMC9FTWpBbnhPeXcrem1HN3ZI?=
 =?utf-8?B?Q2F6WStDTmJEMk1YNjBnWXUxaUp0NVRmVU8vSCszYjNPd1phVDhkUjdtcnpw?=
 =?utf-8?B?UmZERmRicTRwWWlyRU9Va1J0bVdnT3IxZmE0NVd4VytSbHZGSWI1Y2RmQTlL?=
 =?utf-8?B?UnFlR2J0ZkhneXc5Uzl0Y2l0ZW5hdVZQcnRrWWw4UWpsOTJ4U3B1cFZNcnlR?=
 =?utf-8?B?dzI5Ky9jTFpWazlUbkQ3bC9yY0FRR2N2aTBtWXBMVHdRbXVLTkcwbU9WWmlo?=
 =?utf-8?B?TkdkOUx0ZTVjbEpYdFVMUm9Da3poQTFud3dvTnV3TVpWZW1YdDdCSzNXa2tO?=
 =?utf-8?B?LzBwcG9DUXNtZ1NkeXdqVExycWZLZkkyaGJ4L3ZSTWV1V3FoT1o2ZGd5UzBw?=
 =?utf-8?B?VFp6eE1NVEhOek1CZ0t0MlR4Z292a2ZtWjN6Rm5KU2ZqSnVDUmZOR3JFNEVI?=
 =?utf-8?B?eXJpWGw2TUx0RENmaUNLbTFESnduQlRlOHlUMSt6b29uTTBmQ1NFa0lnNE02?=
 =?utf-8?B?cFNDOWRJRjdaVnVrcmFQYzJ2YTk4Qk5ZVmczS29yU3ZBNkkxNk5BcXhFZW5k?=
 =?utf-8?B?SzNqSGNiN1QwRDcwOUlwQlBwQ0hpSlB3MU52azBBSHRYTEdNUjBUYVlKWEph?=
 =?utf-8?B?SnJGRXZOZUlOdFFrL3M3Qnl4Vis3Nld3N2hFYndTOFptaEhxZUNweVFaS21u?=
 =?utf-8?B?Y3NDTzNtb0hEaE5TWkVyUDJNdE41Vi9TNzYrdkdqU2x4M0g0UDIzTTVwK3F0?=
 =?utf-8?B?OVlOaTY0dVA1OHkyWVYzUjNmNXcrNTJzSXh4NEZFbWxLK3FxRlI1Q2xoMkkv?=
 =?utf-8?B?eUdlbld6Q2FQdHRjMGF1UzNKajdrdkRJR25yNS8rVkI0djZpTzdNVVdiU2VG?=
 =?utf-8?B?UjVsRHl2OWp5bTk5N3htQkJNUk16NnRDWWdmRHNIWXErbE85aUFUR2RjTU5i?=
 =?utf-8?B?SDNSNWNVK2NrRmtVZEV5ZUtlbUJIbko1WXBsVkNuWUFTN0xPSyt3dzRLdWFK?=
 =?utf-8?B?c3VJOHF4SHRhUXhLYWJyNTFsZ0FwVkVGanVPNVNCeDBXTG5OL2xWUkhuYTZ3?=
 =?utf-8?B?L1VNY1o2Slo0MFRYeC9YVHRKU0RYbkQ2QndEVnZqYjVWc0p5eDMwQTV2Mm9J?=
 =?utf-8?B?L0xPMmxOZklYQWExUjN3QzdRYU5kMmhvWW5WeXQ5aStlLytmUlBPYk1wQ2hm?=
 =?utf-8?B?TUxHdmU2TFdOODQra3lJTmVpb2ZEcVFUcGlsQ3poTTFMWHBiR1d1NnpldzJ5?=
 =?utf-8?B?Z3JPbUh5TC9BRlZwdm5OUG5xRmpkWWNzd21DL3ZWaEViTnh3TDIzVGY1Qzd4?=
 =?utf-8?B?Y0pkZUZwWjlJb2RCekROd2RRR0kyK3NkUkkwZnVFdFp6MFhhUnoxWFRGUnhz?=
 =?utf-8?B?empwWldNVWhZYTVSWjEvU1NoQnRmQjQvRzErMU1mWXdLUVZaaW1seEFpcmY0?=
 =?utf-8?B?aUFPd21TM0xjcFlHVnRjcE9XMnBKa2JlRzFPazBhb1RxWE80V25PTkN4YXFH?=
 =?utf-8?B?R1pLRFpSeUNEbkVzMnlHV2J4QUdYSHpDQmZoRnpGc0F6cUJTMDAyTkJtU0lQ?=
 =?utf-8?B?dWhianA5NTl6WnV1ajZWakpJUEw5VHNCRzdodlhiZU1sSCtPVzU1UjR4RGVT?=
 =?utf-8?B?eVFsUHg4SEMxUWlqd01WZzZJYjdFS1NGV05jZEJzN0ppWUFZaEJHYVBCREFk?=
 =?utf-8?B?U04vTkZBem8yVkcyWmxDWTZ2TFJoOFNrMEN4WFhldEt4aGFWQ0pEeDNNUnRz?=
 =?utf-8?B?UVNLVVdIV3dVRUxmNVlNcklCcWMzemNIWkpHWmlweVlFZWdjYTJONk5INmNW?=
 =?utf-8?B?RUFLWkFIakVrN1JnaEVYcTF2c0t5TGRUSXB5SGFJTURLaFVRdW96THViMm5U?=
 =?utf-8?B?VjNQdUhFSHhlT3lBSUtLcTdVbWQ1eFR4MW54ekR6V0RISTR2YUNkVkU5RWs4?=
 =?utf-8?B?bUF4SVFoNFM1NVVueGVCNnNXR1AyQ2plUXJQNVVWbnBlYTEzTU1iTzdCTys5?=
 =?utf-8?B?S2lQV3JMaDQyZTlvUURmVVhBb3RRdGRpK2ZVb2VTc01TcE5HcFVNV0JFSVJq?=
 =?utf-8?B?Q1hEcTlpaVhwQU9nUkxGaFo3YjNTKzZDVzVEMGlkcFc4ajljYSt0bXZCQmYz?=
 =?utf-8?B?YjZzd2VhRm5DSWlab1ZoSVFhM3pkdUxGbGVMdEVVbFRzOTdzQUM1dz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c89eaf7-5e09-4c01-cf62-08ded5ebf5fe
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 14:37:35.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvHVrIKuuKEsO9lOZwHVhmz87YIOzMTcCr0HOXMSvWCP0EpcNCwWzsmCYhrSA7sxBt/kbrQGtt7mcGJ1ttb1sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2662
X-Stat-Signature: qedhio7u5nggxp3g6jcei4w63uagg6hx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E05E1A0008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782743859-431830
X-HE-Meta: U2FsdGVkX18iBzD25URfJKjUY2o4/8ST2LTeXTiT1SLJ4XNjC0Vo2FDCFMV8ykQeVKDlY0IGYpklmuMappC/zjTwMvhU9wJ1Z0saoz29OxqGRA9t6wCZM5LqnaBM7InmViSqlND7sSFiqAN6SfYtKIJ2++nCLa0xa+suueF7aGJDdHJ4PXrW8OenISujDLmf4ExsWBXqnkDcxSGH4R8U3iKKVZouHMBrB7w7/4mVK83cl0euoL7bhS0lfgfminmlKcYuvkdVaEtVPVnQ9S7cw2cN/lfroziYM/luJWJuUZ3HamQIc+uI2pfRIKhUkAvT/J8iH7omlWZxktw4x7Hbpx9P4FERH0LwUTY0uGXmjntvnWDBG0jd8exfdvVmpTaIVGwS9SRaMzM4+Iy9J96tm3jggzaRzb6mVkt+cEmjqKUeTTspNYZq8Zr6IoBMrAQbLt4q6ncFBx9wQY7f3JBCpKC1E2v3mNTQrSMjR5Zj1CpR0sZyDxIZTnkFPa+6J5I9B9OugllgA0mfq4l1i7GbEp6uauH0nhQOJjzCovD0YeJjfErpcY1WgwzNtywvJetne/FvLZb+9TazGIsV31L+3rl1QWzYxnluBmQsreg6pUt42VHMN8Dnbq2FbJtIGKGr0s15uG2YfCH1fTa4EtEvS6XkJyFtJ7MQiOSuLOVgjbj1ZDjy+KMVCu/SxQkZFrBjbXyx1Q1ePvSyCHUGSnEwV4f1UEw29FvS53aeguwJricV1ryeewUfvZNb9YLSr/FaA8vgknMu+WZk1+iC7ez5bCiHvrxO1l7comyoT7Y+5XxudUIrDaX0O7FPcneYachKhfR4oUN69gmb03eeu4SgJxjoQcEydJfWYMB3gsB/yDjgUp2WwiGH/tuon0igHbaikPo1NfJeNLkYT/FCfc9YYvIp8i9EAGd9jsxDG9WgfBVuRyEw0EvQrpPULACo4qWPnr8XrZg0SbGqmfu0fnv
 dNZxWcdD
 BTb2LBYz5zdCfqICDdPRc0S5GminR3DYa/cHMuJOiYG2yKtZt7USK5KY5Ymz9AMeXeVHjlGTtaKdMORxSHW+p+ROUQphfYndBTLDHMStDLEIBkTLpkF3OIgM03ln1kQiZTSaxVlYItVDvwKtnHGroR4pLRoActWpvk6qVo27CmpnMFiaIrvmGkyZVoLefCm7Kb6DS09obVLp5P5IYF77hSy+NwK3lQ0dQhooylqXDLTLesFaUkqr8mQPvACHfUXkX2eiQC3rYxvINXHgU2UV5FgzuCqfUkRtiVV4w4ZRnjkqRD4kvOnG+P2Nm8sNfnXDu+0VQFyiizbzfhgHtwAedaCYTKlIsG3nHcn9gbDXkaVAYq4N56TLIKatbENwQeyoUDfuq6Rr62D/n53t/LF0HPxPDQTFcuJ/PQakEhudI41531qNloGAksW7oWQZ0Bx9dVOBvOiDls9oipBrY72bYWXwrsljbdZTZhjWiQdP5qRleyvscG/3kZ9j4nM9UCUvlAhzpBMkTd+Bex2fuhmLfmJPsqJtbUy6V+AJ/UJFZLIR5H1pCQodO9BEEideeXPT1X/f002BnHn5IpvO1+ZRFwcGNNrB7v/YfCULBkgwyO3+smPWgoin8bv17MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jun 28, 2026 at 10:51 AM BST, Trevor Chan wrote:
> `AlwaysRefCounted::inc_ref` is a function that shouldn't be called lightl=
y.
>=20
> To prevent accidentally calling it, change `inc_ref` to be an associated =
function.
>=20
> Modify all `AlwaysRefCounted` implementors to work with this change.
>=20
> Suggested-by: Benno Lossin <lossin@kernel.org>
> Link: https://github.com/Rust-for-Linux/linux/issues/1177
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Trevor Chan <trev@trevrosa.dev>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> Changes in v2:
>  - Don't word wrap the patch
> Changes in v3:
>  - Make argument name of `Empty::inc_ref` consistent with `Empty::dec_ref=
`
> Changes in v4:
>  - Rebase to new rust-next, change new implementors
>  - Reword explanation for change in `AlwaysRefCounted::inc_ref` doc comme=
nt
> Changes in v5:
>  - Change commit message to be imperative
> Changes in v6:
>  - Change all the implementors
> ---
>  rust/kernel/auxiliary.rs        |  4 ++--
>  rust/kernel/block/mq/request.rs |  4 ++--
>  rust/kernel/cred.rs             |  4 ++--
>  rust/kernel/device.rs           |  4 ++--
>  rust/kernel/device/property.rs  |  4 ++--
>  rust/kernel/drm/device.rs       |  4 ++--
>  rust/kernel/drm/gem/mod.rs      |  4 ++--
>  rust/kernel/drm/gpuvm/mod.rs    |  4 ++--
>  rust/kernel/drm/gpuvm/vm_bo.rs  |  4 ++--
>  rust/kernel/fs/file.rs          |  8 ++++----
>  rust/kernel/i2c.rs              |  8 ++++----
>  rust/kernel/mm.rs               |  8 ++++----
>  rust/kernel/mm/mmput_async.rs   |  4 ++--
>  rust/kernel/opp.rs              |  4 ++--
>  rust/kernel/pci.rs              |  4 ++--
>  rust/kernel/pid_namespace.rs    |  4 ++--
>  rust/kernel/platform.rs         |  4 ++--
>  rust/kernel/pwm.rs              |  2 +-
>  rust/kernel/sync/aref.rs        | 11 +++++++----
>  rust/kernel/task.rs             |  4 ++--
>  rust/kernel/usb.rs              |  8 ++++----
>  21 files changed, 54 insertions(+), 51 deletions(-)



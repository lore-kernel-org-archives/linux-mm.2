Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E06F5C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11016B00D6; Tue,  4 Aug 2026 09:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8076B00D9; Tue,  4 Aug 2026 09:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD73E6B00DA; Tue,  4 Aug 2026 09:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5A9C6B00D6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:44:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BF9BC0176
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:08:56 +0000 (UTC)
X-FDA: 85063617072.04.5F4C218
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F18620011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:08:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cs-soprasteria.com header.s=selector1 header.b=NZQN+ucq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of christophe.leroy2@cs-soprasteria.com designates 52.101.72.41 as permitted sender) smtp.mailfrom=christophe.leroy2@cs-soprasteria.com;
	dmarc=pass (policy=quarantine) header.from=cs-soprasteria.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785848932;
	b=RycHLfzQuhFCR/qNRMJ9VSs+z2EIVmQk0geDZUk6RYjsd+1lNVs8qbvrtRZla2fUDX+B1f
	4u67IIGkLXqJRWp3mzJFFzD4uTxmgPrsy046IPZ6PDgHkRojwg0a5R/7+NWZpErHnOoWQR
	IHr2h9JZGRwYKd76D0GzoGWnHbYWlmM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=cs-soprasteria.com header.s=selector1 header.b=NZQN+ucq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of christophe.leroy2@cs-soprasteria.com designates 52.101.72.41 as permitted sender) smtp.mailfrom=christophe.leroy2@cs-soprasteria.com;
	dmarc=pass (policy=quarantine) header.from=cs-soprasteria.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYc+vf5kWTzzU+b2DGzSDmMg5ZF2tV/LZMlaD5k+5zY=;
	b=iCWWVfKwrsAKQcke6TX48qEMRSrOE1wBj6d0ZUhaexVQ3zfTLqzwpt/zHsA2lpBK4zcdo3
	9YHezle34fzz7WqceGlPYhSwPXeRli8ccJrFIjp3yoGVk49IVRRGEdFMAYgfOFU4Bm66Id
	WXKljPGWSwxSknJApX4tRFPISGgC1sk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ohkw+iccLv3s0Rk9YP0AHzCOWsnbuMxSurBGCDJ5S3QlX1bd9NCFZcbsTZJ+f3vXXc6PsdlVfqWExO4vHjdGUL8LdpWAre45PtH2fa4D6pw0jh0ZzFP7ZWjRGE/536Ro7ZztTSOB5WCITVIY60F4TB5oVxL/c7y2p+luqMyRrtjZI/N5a1pLReyIUtfeFwH649dkaEvJoPEUAoUnJUplRbT1256bKTCpBfG+zEURspocfJLCyZ+Kmjb1shbhK2d6jWtQ0y4PRQUjQyr5ewAFwRywVL/aD5aLbFZUwiLaeBcptWOVmgzcBB3uItpRkw89W9FzSPGsWPbskhjK/aWQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYc+vf5kWTzzU+b2DGzSDmMg5ZF2tV/LZMlaD5k+5zY=;
 b=TWrdY5cyFLoSY1jwhwYPLsV7T/K67wuP9rcXj//BodhIOzMnzeXvHfWzwpRWKU7Q267GpO5azcFY9k3wxkl5s6aVYJk2y4dJN1S0kkjLU0irJn9G5pcawnsItt14RvleGSl/aHI3vDng0EAz/bHYt8DrMIjh7N3QYSyuzGJGR9K7q21DVC/G7pJHF51HwzmIpUHNZejq1Rlaf/4pV+NdvjNYNUYgxpvh+3Dgfq0fWhGP37TrQdaXmNv/XRtqi1NW1eC+MsBUYEwPnIaVSu1zNY9P26cPMTM9jz4tplzzjo2ILMqOHOM66UgSKIFPG/mvsFK3xfQhFe9wbkhSAjYvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cs-soprasteria.com; dmarc=pass action=none
 header.from=cs-soprasteria.com; dkim=pass header.d=cs-soprasteria.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs-soprasteria.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYc+vf5kWTzzU+b2DGzSDmMg5ZF2tV/LZMlaD5k+5zY=;
 b=NZQN+ucqnQxY8PwNlDBNcX2pHb0aToiFcpu3yuup9KiBBDEEeDUbcDOVzKqYR+aZC7PT4X/YCL9nM6EKGCjhqz3zt/n+d3cM1m30pa1ZSO7/aJ0iIovrRZZomOdq+sBPt5fpXqWJcSIk0phLmS/kid086oNmgGYopCiAELWTRljfcXoplMHRqCZjrPqvPKCCtbXUAI2aaebdGGZ/tVlSWcqYg0iWMSR44HnM+B6k6TS5lcCvcfEGQLa8hUnOQf55RBr8NGAAwea/z/alHnWmRt7wjYHjC+5JEsM86gaI+cCcjBUEMAk7aRcqo9CHd+1rdlVUDvPP2QrZhZh/zBWqvg==
Received: from AS8PR07MB7960.eurprd07.prod.outlook.com (2603:10a6:20b:396::20)
 by AM8PR07MB8246.eurprd07.prod.outlook.com (2603:10a6:20b:325::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 13:08:47 +0000
Received: from AS8PR07MB7960.eurprd07.prod.outlook.com
 ([fe80::2c24:b25f:5c9b:6db6]) by AS8PR07MB7960.eurprd07.prod.outlook.com
 ([fe80::2c24:b25f:5c9b:6db6%4]) with mapi id 15.21.0292.013; Tue, 4 Aug 2026
 13:08:47 +0000
From: LEROY Christophe <christophe.leroy2@cs-soprasteria.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Christophe Leroy (CS GROUP)"
	<chleroy@kernel.org>
CC: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller
	<deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
	<npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kevin Brodsky
	<kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Thread-Topic: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Thread-Index: AQHdI2dX1o9HiVOWnUmCd4kAiQcMf7aNvayAgAAbIYCAAAJ2AIAAArEA
Date: Tue, 4 Aug 2026 13:08:47 +0000
Message-ID: <ca71cbb5-2f6e-47cb-8f54-9149a94d0804@cs-soprasteria.com>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de> <anHI4B-lMu6AJJfA@lucifer>
 <dcdb8cab-c18c-4995-ad1d-2f2d4700e7c1@kernel.org> <anHgw2Z-d-OQk9qs@lucifer>
In-Reply-To: <anHgw2Z-d-OQk9qs@lucifer>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR07MB7960:EE_|AM8PR07MB8246:EE_
x-ms-office365-filtering-correlation-id: 40b5bc38-e5c1-4cc5-92bd-08def22984fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|10070799003|366016|3023799007|22082099003|18002099003|38070700021|56012099006|11063799006|4143699003|10067099003;
x-microsoft-antispam-message-info:
 ZaBJcThRJ7JpfKZJdDIMVPI+ZJW5yv+aaUqUaY1bSoUsNU4PWibe0Pc16qga/JqPcnBQUFh2ukh66Bn8Q4/AKsnb7QEs3lNtR7Mx/3VVn2aBoM1gqk6lG6/zHWiMze3reZTbcPneeFYE9UIw1nJ34ArpnXm101Fo8UBeAtls56aLquWFIAERsG6H93s553PMXeHlPQBb6nzxhtLluWrOIRZaffdeecbIdyhOzduMSbQjJyBjMFZl7L8V/LL+SwqHgnET3CFTLaaQZ6hv+nXAPhpS6UTdlb8MLuoNoZuR9LZxDN2mTJLvRSAU8v8VPSdjeS0ypaOsABvZAkdh93yWKbkjJQom6/WWPCNpcOCGDrxrMmUPdKazmwO/1vUbQ2pkJ/VGx5ySYI2VJntIA5A4lmPICkC8g9c33cLpdRDVFTaB3UCp0LDvtXcYpQXQ/GLJYzikmzds1Favl7fQbSw/8X83AoG6VseMME7t03YCXYJdaC6ZI1A/zwFBClE50vGphKwjomsQUW19DC4lSn6uKkukTRshGaZCFTFP/q4Ntlf1UQsoiTk+BJ4M49JnQgcTkIt6NasO++zzvul67KF5K+ilqdlRxNnI9/TfEsdFRkXIMEr+Q7NzWq3YA1OAR2MsX3G0F9gzamQ7RkVShEcU5vJWqLnwKDAPYNrjSwQ7bakGEMAqHoQoYJd0YTnpEZaP1p8Q3WbXoT8XaCJnqeTyVZBwVk0J56l24fLKwAVlIOk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR07MB7960.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(10070799003)(366016)(3023799007)(22082099003)(18002099003)(38070700021)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SlNNNlpoakV6VnNtOWdjUGRnMUNjdXJYejEzYWtGQ3hCNzRXSFBXNmV5QVRR?=
 =?utf-8?B?UytMWDJIK2xQOHl0K3I0bmYwUG4xa0VXV2pGTzR0NHRpZjhSZXQ5MGErOTY4?=
 =?utf-8?B?eWZqWGk0UGd2bkVQcWFkWTNWMkJQbG1WWFYyZ1ZoWmF3ckE2djVkQm5nL0JT?=
 =?utf-8?B?MGR5UHhBb2NSUm9LYno1aE1NWUk2UXZtYm1PWWVTVWE5VjBNNFhUM01mNnRK?=
 =?utf-8?B?b2lYRFlsR1FpMFNFU1dndW1KRklHOW9iYnA1Y21SYUlkamhQRXg1dUh2Rm9G?=
 =?utf-8?B?T2FpcnprR2hSQWpnWTR2eGFnOE5iQkl5R2RYVURBRzZEZ2UxcEozSGUwekZr?=
 =?utf-8?B?eVhYcDdBSldOS1p6bzNPRFN5N3F1ek1pYUtjdm9BV3RIT0RKRkRmU0g3TU9F?=
 =?utf-8?B?R2tBR09pNnFNSEgxSVB4RE9MVEhrR3JhbHRXSm9WZGtHZ1M1b2tWc2U3RVRl?=
 =?utf-8?B?ZmhwanN3UnlwMmNtLytxcjFHMi9oNEZBZi91TU9iOXJPb3pPOW9PNWFrVWdS?=
 =?utf-8?B?YU9hRzRwNkJocnJDR1ZOWnB0cm1mK0J0eU54Vm1LN2V4U09HMmRtZ0RIZWx3?=
 =?utf-8?B?TnMzd05TTmRQQ05qa1ZCZVdzYW16Uk5lVmJwWGhjRUExNWdPL0tpY2d6SGM4?=
 =?utf-8?B?V0c1dCtLUWNWb1h1ci92eE4yY09JUWlqRGZvaWM2SlZvaThUMG1BM2FybFZh?=
 =?utf-8?B?QkJnaHN4SEg1Y2dwb3hKZUxqZjk2bXRDVE82akNNa281T2t5YkFiZlM4eE40?=
 =?utf-8?B?NWdubnVXKzlqejdianBJenZ3d2hYRDZNbTJOLzdiRTJlaGRjSmt3bE9LbHdN?=
 =?utf-8?B?OEIvNEtsQTlyVlBiV3Z0aHZHNGpjZWJ0RWJ5Y21KajVvY1I1MUVzaWpvMWlT?=
 =?utf-8?B?bkp0Znh2d1Fud2xMZGs3SGRPYlpla01PZGRLQ0JCbER1WkVueEVUSWtRcnJn?=
 =?utf-8?B?VStXYUFJZFF2MEFGeTkzNmg0ZHUwbm5hUkhlL21TTWl2YTNCa2Vmb2h4QVZv?=
 =?utf-8?B?ejBGUmN6cjhQTUd4VG9wUTBDaGRuZWhaeW1XRG8rQVBFVnpSSVA2SUlicXQr?=
 =?utf-8?B?dGpwZTQyeE9pWVl3KzBWUm5JeU1FcU5uMzBYSkdxRTVOb3NJV3lpUVlxcHpE?=
 =?utf-8?B?b0kwK0xPZk9IdlpoMlpoRVd5WkJNTU9XUWdqQ3NxOUZrcVZEeWtpeU93czY1?=
 =?utf-8?B?UGRqRWxPeW8yQ3UwRDh3NzB2bjBIWGlRNVNpZk53TjdIdTJmeUNuRC9kMS81?=
 =?utf-8?B?TG0xb0swZmlDWHk3OGdCSnQ4VlJLejhnWFNtRTlPYlNyaVhpUWJldHV0anU0?=
 =?utf-8?B?eHY0WkJRM2llaVl5Q3FMM2tHZDVTTGhiei8valZDNWk2Rjl5d3YrUFNKOFhY?=
 =?utf-8?B?TWZnaldzMWw2KzZITVUrVHdZNDM3UVVXVU8rWUkxRGxMbTVGdVAwRTNJRnda?=
 =?utf-8?B?S0lZMG43TDh6TnhXOVJJWEZFZXBTeU9rbzY4MU9mY29kU3ZRcjFGdmRzOW5u?=
 =?utf-8?B?QWlDVVpPTkNhWFAvaWptWURRMitNSjVObVhQT0FMZ08yZDNRcUtUWXYrSG4x?=
 =?utf-8?B?WVozQ3RVbHVQYUtQMFh1emxYN2VxREV5a0tKVU1JZWdJR0FlcFMwQzlURjNS?=
 =?utf-8?B?UUZ5U2J6Q0lKNGRoZW9OOHZ0VUxRNEIrVElQK1VFQlA1R2ZINUZpdUxkRnRU?=
 =?utf-8?B?RExOUVgvT005VXA2b1RveHF4M29BM3k0dUYrL29Dci92WWdtQUZHdHk3TXBu?=
 =?utf-8?B?NCtJM0NoNUg4QWVVTVpKWE1NYUEralM5dVJWU01KaGFTUlVjN0lPbVptcFJi?=
 =?utf-8?B?UXIxTzBxUmZnbzFPeDQvby9qRzNFZXZHK1UrT2xDRitMNHg2eHBYb3ZWS2hF?=
 =?utf-8?B?VGVxeEVJaUdOWXZCSUl0VkxkZFhrM3BsTjRDUFF3eHU1N3ZJOFlQWkNseENi?=
 =?utf-8?B?cGswZjhDSFh6NnUxY0pZQkdVN0tPdWlQS0tBTWcxemZDUzR1d3JXU1JRZVVh?=
 =?utf-8?B?MEtNdlJwWWZyNG9tUG1yVE9WZ0dMemNWWjZkL21VZDNoelUrdkZOckZ5VnV0?=
 =?utf-8?B?eXVzL0dqOXViTlRMRkk0Q0ZEaGR4TnRxY0tSaHZPT1c4cU5OTkJOVzlDY29V?=
 =?utf-8?B?NGJ0cmt2bUx0dlp1SXh1TEl5dTV5eTI3UzYzUWpRaDg1Zll5eFVaZk5PZysw?=
 =?utf-8?B?QWlhRnIzVWZ2ZTlIVFcvR2VYNjdTdjhwTjFaNG5FMVB3R3VxN1lGN1ZBeWJx?=
 =?utf-8?B?QzdONVM0M2dUdWpTZlBmWTMyQm5LWTUzSXZqWktkdFIrd3ZSaVBkakVVeHJV?=
 =?utf-8?B?N24ybDA5V1ZXT3dwVXZxQ3hLM3VyY3FkNlBmU2lSVTFOaE43cG9OODhoekhR?=
 =?utf-8?Q?XH/4i5WreGLbKh5uC3RgFV6HFEnFW4s20FOJ+uZNZnj+h?=
x-ms-exchange-antispam-messagedata-1: 1IwGqB/7DLe0/PeFRw/q4QZsqp0wdE9hwso=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34E02A3588DE934D9E6BBFA755AB1E96@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cs-soprasteria.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR07MB7960.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b5bc38-e5c1-4cc5-92bd-08def22984fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2026 13:08:47.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8b87af7d-8647-4dc7-8df4-5f69a2011bb5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wRlNVnEjK0gEjmKxHi9D51PK12w+oYvVzvpq/OucBJNaPz+esuwm00Mv1GrC9fm+GJmIYexaC07q2xvVI2xw6OKB2uxZA/mWiG3o04z0JHq+ms3lVIm+ci1HZYjTFrB3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR07MB8246
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: AS8PR07MB7960.eurprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-originalclientipaddress: 2a01:e0a:511:aad0:9f10:86ad:5cd0:9703
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: AM8PR07MB8246.eurprd07.prod.outlook.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F18620011
X-Stat-Signature: pebm5tq1anpkp7juxqiuqjfjse3eh5b9
X-Rspam-User: 
X-HE-Tag: 1785848932-515381
X-HE-Meta: U2FsdGVkX18s0o9GTK18pBUdzNIyS4Nkh4mY5YGJxCD43AiiNN4YEyV2bsN1Tu1VKlB9UB5dBVWa4VZ4Op++O9vtAMkoQX+WIbnxusCv1gKGcetzXA9En02Pd2a4UFy0p3Ik77Z3yaiSPqqL5NRc4M+vwuUE1e5FyPnHBPwFXvzoT7IYBIvGFfR297nxu4bJbEj6IfAQq+5dFTWGwSVSx/QLe2RWbOFg8XTf8Bsp43WeY6gWX7wKERhdLdqzrIV66oIsJUIv5LBhdziumV3LeEtdBagU2P8+irgFIi6+HNBhfxWtzns0IbiTqj+B0lum4H6se12hE8DnbqNN0soDCX0QPNWXhoA7Z1OK9ZpwWHbHFgOiuzquB3XvFkNaQSu7yq2aGXAqrSJOnJ/apQ75PTwDLVfS8ABLGDGsrPEL9X9mW6kwPfr4lbTuPGzzzLudG91J4A5ulAHwwdNQ8qGDQ1BxO3FjRS7GFfuy6gejTxwx/n5yuSxNt0b3zUQfv5YdGJ3A83hfYrj4K+UW2hECGnRbmyZbL0joVgPk+dmQyLf9FH2Bicf+zyx+2XTF4R0iaPAQxA/6jO1GfAsFHN6u2UBHlmu8L9J/rbbveyoijLZ8ZCr1/Mt/K3hTM4NCzRT08+95Y/zL1zzVTpYuEWtpR4ZY1VliaWNlJh6Pv+um/LdnJ8QFCaxiy/hGwHVmMCYoo5htJ6zJzIszObAl/Qq5Fo/oEVOCrwnYJ4CA0GCFUChvr8D7/NOLnqpkxATEWIWZM5jR0OrXOnveE+HD57BmEDB8SjAYzuG+Gvi5mU+wBmyc/lnV+BTPCCB5RfDclW8XItXa6aVR2L06fGESnGtY/e3yyaobqyEKSiyA7OOS7sZdLOhgm+gaM2Xjhpd2IYFhi/gi9RCX/CqRcvyBesdr0hvOxe6I8R1LPAXKtbdSWlAsGDx3tJm8obg626zrTqxJIGZ6XTWGpmnZ6xLmIie
 fQtGc4sM
 bcRN59V3mw0xuZwmFRlZcVqidve7MLXMxBBe0rpKOXsuUtEl/2nFrcy81bp7dMPjAx3T05IJ/ysb3a7wKGzZqxRup7oiK+oNVPVKV7aG9oDLxogEbBaZivu/Vne8HHTyvBxGGPpT9SsJCBjRRplxWBtUs6R63C6lTy2kUpfHugpgH6Js22YBCe4bES5wkcgxqThF/ub1AsYGc+89v+hznMZmHsNy9VMc4f17zIEMprtSUJ490KdMcMN5li3xf0LMIPszFECsnixK+hvK/5etgDWagv3I7lms0ElMYe4q9ovHUiv9GDZdQ0X1qKMIs+rcMfnR5UiowJJZy5KDPuUbOUeZj32GT8V16lxYxI9F24hffmhwYeyQFkugb9dCHi663ax3T4C1tzkFGAJYBqydBn/XSdnrCek8/VO7CwZT8M+tF9u8SoHLnF+NA1KN40/M8CTcEvlRnXfFkBS9L7ZER4yj2lqcDd2iESlszOAEs7EjtdnlKKThyc3LEHzNO2YN7agpmZKDiOPJWydF2xjsM14mKozRT4AV9XJOW1ghwZ0Qq41ewq9TexqdbZ3rh6IRKMGtmY7Fnr/X6qzFPEHdq2tdxHyXIYme53SzY9gb6EEwo+lxgs3TXDJtevw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCkxlIDA0LzA4LzIwMjYgw6AgMTQ6NTksIExvcmVuem8gU3RvYWtlcyAoQVJNKSBhIMOpY3Jp
dMKgOg0KPiBPbiBUdWUsIEF1ZyAwNCwgMjAyNiBhdCAwMjo1MDoxOVBNICswMjAwLCBDaHJpc3Rv
cGhlIExlcm95IChDUyBHUk9VUCkgd3JvdGU6DQo+PiBIaSBMb3JlbnpvLA0KPj4NCj4+IExlIDA0
LzA4LzIwMjYgw6AgMTM6MTMsIExvcmVuem8gU3RvYWtlcyAoQVJNKSBhIMOpY3JpdMKgOg0KPj4+
IE9uIE1vbiwgQXVnIDAzLCAyMDI2IGF0IDA1OjQzOjU3UE0gKzAxMDAsIFBlZHJvIEZhbGNhdG8g
d3JvdGU6DQo+Pj4+IFRoZXJlIGlzIG5vIG5lZWQgZm9yIHdyaXRlIGFjY2VzcyB0byB0aGUgUFRF
Lg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBQZWRybyBGYWxjYXRvIDxwZmFsY2F0b0BzdXNl
LmRlPg0KPj4+DQo+Pj4gV2l0aCBiZWxvdyBhZGRyZXNzZWQgTEdUTSBzbzoNCj4+Pg0KPj4+IFJl
dmlld2VkLWJ5OiBMb3JlbnpvIFN0b2FrZXMgKEFSTSkgPGxqc0BrZXJuZWwub3JnPg0KPj4+DQo+
Pj4+IC0tLQ0KPj4+PiAgICBhcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL3B0ZS04
eHguaCB8IDIgKy0NCj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9h
c20vbm9oYXNoLzMyL3B0ZS04eHguaCBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ub2hhc2gv
MzIvcHRlLTh4eC5oDQo+Pj4+IGluZGV4IGUyZWE4YmE5ZjhjYS4uZjJiYWIzMTA0MGM3IDEwMDY0
NA0KPj4+PiAtLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL3B0ZS04eHgu
aA0KPj4+PiArKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbm9oYXNoLzMyL3B0ZS04eHgu
aA0KPj4+PiBAQCAtMjI2LDcgKzIyNiw3IEBAIHN0YXRpYyBpbmxpbmUgcHRlX2Jhc2ljX3QgcHRl
X3VwZGF0ZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9uZyBhZGRyLCBwDQo+Pj4+
DQo+Pj4+ICAgICNpZmRlZiBDT05GSUdfUFBDXzE2S19QQUdFUw0KPj4+PiAgICAjZGVmaW5lIHB0
ZXBfZ2V0IHB0ZXBfZ2V0DQo+Pj4+IC1zdGF0aWMgaW5saW5lIHB0ZV90IHB0ZXBfZ2V0KHB0ZV90
ICpwdGVwKQ0KPj4+PiArc3RhdGljIGlubGluZSBwdGVfdCBwdGVwX2dldChjb25zdCBwdGVfdCAq
cHRlcCkNCj4+Pj4gICAgew0KPj4+PiAgICAJcHRlX2Jhc2ljX3QgdmFsID0gUkVBRF9PTkNFKHB0
ZXAtPnB0ZSk7DQo+Pj4+ICAgIAlwdGVfdCBwdGUgPSB7dmFsLCB2YWwsIHZhbCwgdmFsfTsNCj4+
Pg0KPj4+IFdvcnRoIG1ha2luZyB0aGVzZSBjb25zdCB0b28gKHRoYXQge3ZhbCwgdmFsLCB2YWws
IHZhbH0gaG9ycmlmaWVzIG1lIGJ0dyA6KT8NCj4+DQo+PiBBbnkgc3VnZ2VzdGlvbiB3ZWxjb21l
Lg0KPiANCj4gSSdtIGJlaW5nIHN1cGVyIG5pdHR5LCBhbGwgSSBtZWFuIGlzOg0KPiANCj4gLSAg
IAlwdGVfYmFzaWNfdCB2YWwgPSBSRUFEX09OQ0UocHRlcC0+cHRlKTsNCj4gLSAgCXB0ZV90IHB0
ZSA9IHt2YWwsIHZhbCwgdmFsLCB2YWx9Ow0KPiArICAgCWNvbnN0IHB0ZV9iYXNpY190IHZhbCA9
IFJFQURfT05DRShwdGVwLT5wdGUpOw0KPiArICAJY29uc3QgcHRlX3QgcHRlID0ge3ZhbCwgdmFs
LCB2YWwsIHZhbH07DQo+IA0KPiA6KQ0KDQpJJ20gZmluZSB3aXRoIHRoYXQsIEkgd2FzIHJlYWN0
aW5nIG9uIHRoZSAiaG9ycmlmeWluZyIuDQoNCj4gDQo+Pg0KPj4gcG93ZXJwYyA4eHggcGFnZSB0
YWJsZSBpcyBpbmRlcGVuZGFudCBvbiBwYWdlIHNpemUuIFdoZW4geW91IHVzZSAxNmsgcGFnZXMs
DQo+PiBkZXBlbmRpbmcgb24gdGhlIGFkZHJlc3MgeW91IGhpdCB0aGUgcGFnZSBmb3IgdGhlIGZp
cnN0IHRpbWUsIHRoZSBIVyBhc3Npc3QNCj4+IHBhZ2UgdGFibGUgd2FsayB3aWxsIGZldGNoIG9u
ZSBvZiBmb3VyIDRrIGNlbGxzIGluIHBhZ2UgdGFibGUgdGhhdCBuZWVkIHRvDQo+PiBiZSBpZGVu
dGljYWwgYXMgdGhleSBhbGwgZm91ciBkZWZpbmUgdGhlIHNhbWUgMTZrIHBhZ2UuIE5vdCBzdXJl
IEknbSBjbGVhci4NCj4gDQo+IE5vIHRoYXQncyBjbGVhciwgdGhhbmtzIQ0KPiANCj4gKEkgc2F5
ICdob3JyaWZ5aW5nJyBiZWNhdXNlIEkgYW0gbG9va2luZyBpbnRvIFJDVSBwYWdlIHRhYmxlIGZy
ZWVpbmcgd2hpY2ggdGhpcw0KPiBtYXkgY29tcGxpY2F0ZSwgdGhvdWdoIHBlcmhhcHMgbm90IGlu
IHByYWN0aWNlLCB0byBiZSBjb250aW51ZWQgOikNCg0KQSBmZXcgbW9yZSBkZXRhaWxzIGhlcmUg
aWYgbmVlZGVkOiA1NWM4ZmMzZjQ5MzAgKCJwb3dlcnBjLzh4eDogDQpyZWludHJvZHVjZSAxNksg
cGFnZXMgd2l0aCBIVyBhc3Npc3RhbmNlIikNCg0KQ2hyaXN0b3BoZQ0KDQo=


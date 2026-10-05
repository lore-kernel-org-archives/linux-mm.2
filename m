Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB40CA5FE2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 04:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5816B0092; Mon,  5 Oct 2026 00:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A65A6B0093; Mon,  5 Oct 2026 00:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FC86B0095; Mon,  5 Oct 2026 00:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C73026B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 00:55:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 451171C03C6
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:55:50 +0000 (UTC)
X-FDA: 85287360060.06.9401FE1
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013061.outbound.protection.outlook.com [40.107.159.61])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C7E61C0003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:55:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cs-soprasteria.com header.s=selector1 header.b=FyQkGA1e;
	dmarc=pass (policy=quarantine) header.from=cs-soprasteria.com;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy2@cs-soprasteria.com designates 40.107.159.61 as permitted sender) smtp.mailfrom=christophe.leroy2@cs-soprasteria.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791176146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPEb/8a2cGn67nq2k1mkuW7ZVRq+eCDF67m6uNcZhoE=;
	b=rvPdKqEOlXT8tZ80EDVzxWzIYdlkEsrjPw3SVd6oW8xqhJjphI0Xc4cfoD9lKjE+hxp11L
	kZS95GczN8G7SmYTGFAya/TDOMdFAWyPR4sBPLfWoF1kE+pO60B8IJF11fMheUFvPyNhsN
	4vsek2FlFEnj5F4Vv9WF0Oin4ZfB5ME=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=cs-soprasteria.com header.s=selector1 header.b=FyQkGA1e;
	dmarc=pass (policy=quarantine) header.from=cs-soprasteria.com;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy2@cs-soprasteria.com designates 40.107.159.61 as permitted sender) smtp.mailfrom=christophe.leroy2@cs-soprasteria.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791176146;
	b=6rQL3To0D7YCSyEEoDNNTWV5L3FYkVkFDD81cPjVK0BkoyAsIA7lHBUcV8isoch/MwCq4y
	FQIDajnZYJwbexeiQbWciiw5lK1RrvcFiqgSn0jFusoEwisStHJQqGjWr/DhkVUcZEHr9e
	NatY9G9mFRVLsa1v+FNgU8JIikR4l6Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQbfT4o20vGPiqWUmSIMPUAxZroiQzzfvnW65GERwkU+3RTNFR7RyT6UewYZ4LYU0QX+Ucq4x4/10kcv415dX6Uu3wrNAV0wIN1LEOoXRjfakbE8kbbf+DdeRFgkcVFjII6qEXinaJOE1aZMlnKU3IeZuFia5S63mlhDk8Fk8Rj9fpyYqZqCEwPCim0DUiaTpShy8Jkeu9a6n+PZumrby1aeSJaPuthAkWM/kdVcLV2roLvP7IzHh29D4N6Hxf46YWRnKpLwazOMx8yAeoB3BUfMKUWJDga15OYEknlgIupF6qxXk+vkbp6am+1qCUa+n1n130QSW/ALPoY1w8djAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPEb/8a2cGn67nq2k1mkuW7ZVRq+eCDF67m6uNcZhoE=;
 b=vc53EAvipnfjjLIAdxIgjxEC7ZKMak50BpPnolw3EIajykkPk8G0z5I1KKxOw5ZCCpC/zCzjW3cgyIhir9/8JTpCacHGfnVIExgHYvLZFG7Z5ETv4FjWIOtOyYCUmr59tf4lVpJXPD6qxW4LISDgG+Ftbnv6ROR9hgd2Q/8rThlLyUKqW9LmO0bplOLbIZZpKaWjxumtkyvEnXefC9rdF2r6MMHCtKa5RjBMuOtvB6jy/o9wVwABlaOg7cKc76cOv+UIAdE2pIGFB9uk/VVuCiCw2lgVe+UfHkBVvu/xm5vlWI8rm3pRPz1NAzHTc9XLySsP8arcUOnd9rFj0dgPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cs-soprasteria.com; dmarc=pass action=none
 header.from=cs-soprasteria.com; dkim=pass header.d=cs-soprasteria.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs-soprasteria.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPEb/8a2cGn67nq2k1mkuW7ZVRq+eCDF67m6uNcZhoE=;
 b=FyQkGA1eHtnNrjSXEmkGxw1VJsHRbymqIVP1qj+YYG1I13tnxB/PbTHlbXhKo8NvHNDYMEtwLXfQ0JeUulD9rJe03cjtf5Alszye5KO+wHuvGsJDcV/rPAhl3m42ySqDmMDPqOUX4mWPFoDLjR00TNNPIRqlhEPMQ9hXdjywQhy+KiMeAh2v0GF7z3+tg/zoE0mRXB1vF5ZuP/iJ9SWOhoxRnPb29X5v7UhvemU+DJQYJPmWmCoayqfqz1IGQgPr3fLI612NJLSVrI9xqWhPplib9YgL9a2iXynSljAvsMO0ZsRuwNLG19j8o7LR7hQfSpOuoCaWvznkzXdXvoYL+w==
Received: from PA1PR07MB117361.eurprd07.prod.outlook.com
 (2603:10a6:102:54f::13) by PAXPR07MB7792.eurprd07.prod.outlook.com
 (2603:10a6:102:13b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Mon, 5 Oct
 2026 04:55:39 +0000
Received: from PA1PR07MB117361.eurprd07.prod.outlook.com
 ([fe80::1d89:eaf6:2e3:6d71]) by PA1PR07MB117361.eurprd07.prod.outlook.com
 ([fe80::1d89:eaf6:2e3:6d71%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 04:55:39 +0000
From: LEROY Christophe <christophe.leroy2@cs-soprasteria.com>
To: Usama Arif <usama.arif@linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"chrisl@kernel.org" <chrisl@kernel.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "ljs@kernel.org" <ljs@kernel.org>, "ziy@nvidia.com"
	<ziy@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, Baoquan He
	<baoquan.he@linux.dev>, "willy@infradead.org" <willy@infradead.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "riel@surriel.com" <riel@surriel.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "kas@kernel.org" <kas@kernel.org>, "baohua@kernel.org"
	<baohua@kernel.org>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, Nico Pache
	<nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, Vlastimil Babka
	<vbabka@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "shikemeng@huaweicloud.com"
	<shikemeng@huaweicloud.com>, "yosry@kernel.org" <yosry@kernel.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "luizcap@redhat.com"
	<luizcap@redhat.com>, "kernel-team@meta.com" <kernel-team@meta.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>
Subject: Re: [PATCH v8 04/30] powerpc: mm: add PMD swap-exclusive helpers
Thread-Topic: [PATCH v8 04/30] powerpc: mm: add PMD swap-exclusive helpers
Thread-Index: AQHdUlRCbJ7VUIjfwUWpnFYkjf5EvLbuZt4A
Date: Mon, 5 Oct 2026 04:55:39 +0000
Message-ID: <4a4bf0ca-b21b-4b37-b2e3-9bd8ba343bd6@cs-soprasteria.com>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <20261002095503.3585565-5-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-5-usama.arif@linux.dev>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA1PR07MB117361:EE_|PAXPR07MB7792:EE_
x-ms-office365-filtering-correlation-id: ea2bd5a3-be65-4503-7307-08df229ce6f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|10070799003|23010399003|1800799024|366016|376014|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 TBk+02B+Ty63RhVauyueoiA0Giq/gAr7pzQZC+Z+fUSdVEjUUDFZet1105DehuX7Wn3ICbI3smHXOe2FOfuA+OzP5FdZQCjgEZBwdxY8ZyPjHQncWODtr3PYk4GsMWg6wDBMjvAmABUyGun82i15kGNVltJOp9LipXl591SQXkeH+4d7Yqc0nm9OHtPu8UDRFTE69aqajB4rFXNN/6UxJuSbe9wJ7mq32R7uzLx7l6beTDy5+zwKw75LbrYopEEJ1u4UOVYJu1f+pTFg78grf5OHIqnxoiHjjInkVWrvMCEinCZRJZhivfqik07WW/nVa7w8eVbLN/VQEcF2tz7DUmw5ywmwoKXmKxtmWVI8txALtwDJJsbHyvhf1d/tAGgtYqVIl8KrTGrA5PHAFTZCq2uZytY22E1pqnmrMz9Lm31qDfVmrrDz3+Nise5AmNjD3sifkCail6YbSGtW4qpN1mZqLrFF/RKDsLrQsVC7Fd+5cFcMYcN8ETZt9qgeWnwbd59GwqgIYoG5lypWZFaHnI8P2pT8rbTs7fEcKop3TjsJdwBjgeHNRlO0sZHsuy+qlkS23QF6D87UnnToWC45cpYVsZn/pdL2MYDIfZSioT+1LIhN2VybBvLXldpKcuwyd22HxSmOE8RG00eo/PZGiBJAvMkYvDjMV7OYT10Omy1tL7bVx09e6I0QdIjK+iEnwAArBipcgrTOaWSzOGy6LA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA1PR07MB117361.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(23010399003)(1800799024)(366016)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VGdFZVlhajJKemE0ZUVPeG9hdUx4elB2OCsyNk01MElQSFRnOWkvVTVBSTY0?=
 =?utf-8?B?NEFVVEdmeWgxSE5pa2o0ZWduTjU2U21vS08waHlWMFcyQ1grUlJUeEZNV3Va?=
 =?utf-8?B?TldsOGlDcmY0dTJqL05DVU81cWYxU2RGZGYxTVZnUDNOaUFaU3QrUDNuL1Ix?=
 =?utf-8?B?K1NFNTRVZDdHbGJkOE5lZDFPY0ZPNmlnODBwVVVtQStuRjd4U1RKUThZS1kz?=
 =?utf-8?B?REppUXdwbFdZVEpmaUV0UFZFUEE5L3F3enJJdkpWVTNDcmd1ODVzZ3F4QWEv?=
 =?utf-8?B?MXdKZndvWGJXSm1DNXdJd29BZ2ZCaTFMYjBQcXkxR2JqT1VJTmNDWndpcEhX?=
 =?utf-8?B?cnRZMFlpOC9UUUo0ZzZJNy9icS9FalpRRTNxa0M5TFdOMXpMVkNmNTBKcEVp?=
 =?utf-8?B?SytROTh6Zm10bzVxemw1c3cza0p4enNMMklZSVVEU01xVm1CQTJkS051L21x?=
 =?utf-8?B?akdYMlRiMGdCdkdSLzIraEtvUG5jQmlyVFZOVkJwZy9LY0h3ZmpINFZaZWlP?=
 =?utf-8?B?K3RYQzYwV0VncTBqSDBQN3hsYy8wckp6c3JlaEJSUE1IdVYwTjVJdEpGNGo0?=
 =?utf-8?B?eHZNRnZvOGppc2RJWEVQdG5PZXU4ZXd6eDl1WmY1Y3V1NkJhcEcxUlpLQW1P?=
 =?utf-8?B?RlFVVjhhT21mZGhOSTBxV2JvajRUdk1hU1hEZEFqN1Y4UTJSeWhlQ1VPZmxM?=
 =?utf-8?B?TUIzY3RaQkxNZTFocmRING1lQ2hhUVErN0hoaVpvUVpwd0cwcGhpZmZObzVi?=
 =?utf-8?B?SHBiNExaaHlxV3NNOGxJaDhPSGtCZmtJYVE5VE03Q1pKYitUTXF2ZjlMSlhv?=
 =?utf-8?B?QVNUK0lyUVQ4ZEhRRG5NVDYxcEJmcmhDQW5UOExEV1lVQXVsMUVkWEYwNUI1?=
 =?utf-8?B?LzFocHNqOUwyNmphOXJUVVRRR1BwWkZNWVlhbmRUaVdVT2pBb1BUbHptRUtM?=
 =?utf-8?B?ck9mM3Z3S2c5MFRGb1p1RldnWXhvaWxSK3pJejhpcFlyYzJqN2k0ZmRrSFc3?=
 =?utf-8?B?N3ZqSGN3N0t5dG00ZENrRWZYV200R0NUV3FQc05ZdFNITWo3b0hGN0JxSjZ2?=
 =?utf-8?B?c2JOa1g1ZFpFY0VWM1hPSDF1aEl3bG9idXYzUGlsNkRuWUNIN20rM1NFQ2Fa?=
 =?utf-8?B?QWVHa2pBOG1oSjFkZXdBZVRYdVpwcytKL0dnT21UazhCSzdWRzRVQUViVnJu?=
 =?utf-8?B?S09MZDlQNzhQRnBBY3FIeFUyQkRHYk1Zc3dGSXdRcnpFb2dUT0tqUGsybXJt?=
 =?utf-8?B?ZWJTMERtVkFqbnFvUHNzN1k1RE9sY0xtdmdlTVFpb081bFNHWTRUOXBaUURr?=
 =?utf-8?B?N2QxWkpJb3FxQUx4Y0ZmRHB6eWJUb0Zzc3dIanI5c012dnhobGl2UmI0R2hx?=
 =?utf-8?B?U0hhTG83OEFZNnB2VDZMc2ZSVlpGVmRubjhFdWUrazFJUDlJVHZFd2pobC9l?=
 =?utf-8?B?UTBXM2hwTFlnMjNlcERPRGdOMmtCTlY2Nk9CMHFBZGR1YjhGaURGeldtUE15?=
 =?utf-8?B?RlcwZlhINGtuVVJ1aGp5VklVcEFSQzdJUW9lOTZXa1hFV3AwYnd2MHVBR0dv?=
 =?utf-8?B?eS9CaFdOa1QxL0d5UzZONXFCUHJZQWJ2NVZjU1ZJR2QreC9rNTgwaVVLZkVm?=
 =?utf-8?B?RUE3c3lHam9zTDhSUDZWL0pHbTdkMjRyRE1lTzU3MHVxZTRORFRNdjZFV0M1?=
 =?utf-8?B?RHE3SGRocmh0Yk9MOGk2NGhPY1RwSCtxbU1LLzJWYUo2SVF1L0VUVUNQUjZx?=
 =?utf-8?B?b0R5aGEvazZScDU5NXRGUTRObTVEYkQ2ZVNHZmJlc3JDRHdZTWIwKzVrVEo4?=
 =?utf-8?B?ZDhOY2xCdlpOZDNIeDBOUE9vOW42RThDRTFTTlIwcnEraUpGSy9rSTgwK282?=
 =?utf-8?B?TGpuQVkrSHc1b2s4b3JaNjVzd0pGaUtTbTl2cTNpdzhpTnVUdzcwNUQzZkxU?=
 =?utf-8?B?Q3BTYmVkQWVPVHpMcjdweTV2ZEVOd0F1cjlxRGt5MXBZU3IxcHM4aEVaVWdv?=
 =?utf-8?B?eEd0clV0VFNobE14STdlSHB4elpXQ1BBUXZHcFFvK3N5R1NaRERwRDF1WXFB?=
 =?utf-8?B?N1lKSGVFNTRidWhnWVlidVJDOUJMcWhFT2N2cXdrWVdjNGtjbStXaGpzeGRp?=
 =?utf-8?B?SmVuWkVpQkIvU3lYZWFWQWdDbng1VkR6QnROYXpRV2I2bDFvSjFpN1F4Y2VD?=
 =?utf-8?B?L1daWTlLNUpOVHVobkNONk00UkYrTkxCSmNMTUorR1BhMHRKb0Z5cjdVWFV0?=
 =?utf-8?B?QWttRXByTEs2TEwzV0Q5UXdJMzIza1lBajRiNkdKVHZPMDQvT0Q3cjJCSFpI?=
 =?utf-8?B?bzhkektKcDFKUWYxd0tjNkZkajJqRzBkeDJQQ0FidmRrOGRnWDd4bnd2Y3RE?=
 =?utf-8?Q?0cLb+mKYYymIRcNYw1+AEfftqiED/M9shkbBelVQyDRzA?=
x-ms-exchange-antispam-messagedata-1: He6QZ0k6Vj3Z+00b5nmgf/swPqFZNDMDSQc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8752F736EA7F8341A815E5AC9A86A31C@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cs-soprasteria.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA1PR07MB117361.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2bd5a3-be65-4503-7307-08df229ce6f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 04:55:39.4320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8b87af7d-8647-4dc7-8df4-5f69a2011bb5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8POoKcuh8h1hx0OdeByBQyzt/sW5WtGwcTn+kWtVwnNTBvKBr1kuteeI4w7UEWOaDJhWBY7+BWXjtxytUSU8vAGEQZGnwANhOaWjyGpn5s1jmKZx9UpUqSJUlAIsYjHJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB7792
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: PA1PR07MB117361.eurprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-originalclientipaddress: 2a01:e0a:1268:92c0:9afc:451a:f254:8766
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: PAXPR07MB7792.eurprd07.prod.outlook.com
X-Stat-Signature: 9dn6xzyaoh5a7jgzgqqk38wa63sjzyko
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C7E61C0003
X-HE-Tag: 1791176146-990637
X-HE-Meta: U2FsdGVkX1+Um7BGOFFjgGXKuZeSCawB2ByZ/yi4GMJz68WosKX0uWMoqkuOU7nJu8b8We7xnWb/gBw5PzX7mJtS+QedndMvqETrUUbdkVBvj18Trs3fy0gjQzxgxYc0LRbpj4L+wYwQ8B00d6+1fo85BJwnC65us6TgKuNbncm1tslYsnFU0MegDjDKNy5sSJv8aJeqF0Mr0uvFCORyKIteXDePbutAIXPbCxpUmjWgOpcwBbl6wMSUXV8ESjppcen0m5XRU8LeoDKQJMNBjTFV6DB8CH8Y3zesP230WGl5YsQq0qwOa977M6Vvc0hvgQosUNvThxPSwNE1k9udKzZQSbppfORHGkjSohv4KbtuQ0SiTLMkOneQJ7O+BIppqmNT7aRi+I4ryva94ObTov1NmzjCfwEnIV+EcpPCyRI3QYD7lznVWx0WlKJRkCIo4XQGRc5x6Az+y0na6bi7pG/po0YPDzNVMGC1yiE+gcMMTmvQWm/gswhj6HAzGD95/GvE14ZKJHv8UJ3C2VOsOofrg/813S7quIsIM15xUaq6mMDxvZ04nEJ2FuoBtDtmaPmO1+379tZTYHJe/hVE086mhe1URg5XBg+mwS0xT6+q2NIWgMgHEPe/VLSLpcIUvY/cIAvfm4mRUmWDrflQ2oNmvHPlUmvDueUTA7p+Mt6Z+4oVqsQtOnEaqmbFxANHsEXkR78gQjJGtr5bxY3Fflnm71xj0Hw2O/xS0ITLr48do6I7eksManb+/kIg7iTMYKNr4AEcVPijLbIY7td5A6Qi+Ld1XHy8y6sD/rS44l0AzC7IVfkfXgEa0yxb30TLr/A91abT8QQRvKTcM+L/yh6r5EOLDbBTiaoyL9ipxoTu80NGX7D8TVQrtDwJGnkFD6ytoRD+FwXPcdi1/VklPpsHqtlatU3z6r9aJOgKjeAlSqE06UB7cF0wlvSRibAD2U+OT9neuM+QwWpRXPL
 5LtNA6Aj
 yQyHnx3gMnmFuZ7aOmLI6p3481PE/bb42hktGn+goJ7YFLUM4YPotaDn7fj+Jb4HHLP1rUxxR6r3/0HZ7i1x1Ab4nmu4f3GUV1bCUlnzEK3Xh8GJg8TMdkTl7z0D0AnT12Nb32ZiZRQi/bsHMMv1SYyYDFoPYwWlmLorxgNVXJxL0iL0g5Sqlz0Ix9U0w3I/Bi7Xr9cNRHExWfqqd0pBkAAghkwYtrZtn+s1c+ZhKtjSbVub+A7J05tJbtxQX2IC/nnc52vlM3fbcXSMuri8aK9UKvmWRYx2R0RfEqCmhJJ0slzL4vTcfiFb/EXYwlsbHp+glDLlu+ONcOR576SutLt9wWeJlw98jiZ1zIwzgPQeIaYQJTHqzb4BCth7SSHwbKLqJIunR6+M7FIVArwlbO+5HgyNpPJ+OKsRbsIckc/yCeA3sAwoyRLBRCAq8Kmu7hDX/qmtoFiduS7cBajAwpGwYyqa5SB3cHDdnIo4wWM0P1wMzlcKarhmX4KODm8oFED4iEBNB7vIAzl5D2VhWYgSxXMSijMmizamzU/a2I4Q04TlDp0A/4EZ8QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RG9uJ3QgZm9yZ2V0IHRvIENDIDxsaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZz4gd2hlbiBh
ZGRyZXNzaW5nIA0KcG93ZXJwYyBhcmNoaXRlY3R1cmUuDQoNCkxlIDAyLzEwLzIwMjYgw6AgMTE6
NTIsIFVzYW1hIEFyaWYgYSDDqWNyaXTCoDoNCj4gUHJlcGFyZSBmb3Iga2VlcGluZyBhIFBNRC1t
YXBwZWQgYW5vbnltb3VzIFRIUCBtYXBwZWQgYnkgYSBQTUQgYWNyb3NzIHRoZQ0KPiBzd2FwIHJv
dW5kLXRyaXAsIHdoaWNoIG1ha2VzIFBHX2Fub25fZXhjbHVzaXZlIGhhdmUgdG8gc3Vydml2ZSBp
biBhIHN3YXANCj4gUE1EIGFuZCBub3QganVzdCBpbiBhIHN3YXAgUFRFLg0KPiANCj4gYm9vazNz
NjQgYnVpbGRzIGEgc3dhcCBQTUQgYnkgcnVubmluZyB0aGUgUFRFIGVuY29kaW5nIG92ZXIgcG1k
X3B0ZSgpLCBzbw0KPiB0aGUgUE1EIGhlbHBlcnMgd3JhcCB0aGUgUFRFIG9uZXMgYW5kIHJldXNl
IF9QQUdFX1NXUF9FWENMVVNJVkUsIGV4YWN0bHkNCj4gYXMgdGhlIHNvZnQtZGlydHkgUE1EIGhl
bHBlcnMgbmV4dCB0byB0aGVtIGRvLiBJdCBpcyBhbHNvIHRoZSBvbmx5IHBvd2VycGMNCj4gdmFy
aWFudCB0aGF0IHNlbGVjdHMgQVJDSF9IQVNfUE1EX1NPRlRMRUFWRVMsIHZpYSBQUENfVEhQLg0K
PiANCj4gQ2M6IE1hZGhhdmFuIFNyaW5pdmFzYW4gPG1hZGR5QGxpbnV4LmlibS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IFVzYW1hIEFyaWYgPHVzYW1hLmFyaWZAbGludXguZGV2Pg0KPiAtLS0NCj4g
ICBhcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vYm9vazNzLzY0L3BndGFibGUuaCB8IDYgKysrKysr
DQo+ICAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9ib29rM3MvNjQvcGd0YWJsZS5oIGIvYXJjaC9wb3dl
cnBjL2luY2x1ZGUvYXNtL2Jvb2szcy82NC9wZ3RhYmxlLmgNCj4gaW5kZXggZGZmODc5MGEwNDdk
Yi4uNDU4Yzg1Y2ViZmE2NSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNt
L2Jvb2szcy82NC9wZ3RhYmxlLmgNCj4gKysrIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2Jv
b2szcy82NC9wZ3RhYmxlLmgNCj4gQEAgLTEwNjAsNiArMTA2MCwxMiBAQCBzdGF0aWMgaW5saW5l
IHB0ZV90ICpwbWRwX3B0ZXAocG1kX3QgKnBtZCkNCj4gICAjZW5kaWYNCj4gICAjZW5kaWYgLyog
Q09ORklHX0hBVkVfQVJDSF9TT0ZUX0RJUlRZICovDQo+ICAgDQo+ICsjaWZkZWYgQ09ORklHX0FS
Q0hfSEFTX1BNRF9TT0ZUTEVBVkVTDQo+ICsjZGVmaW5lIHBtZF9zd3BfbWtleGNsdXNpdmUocG1k
KQlwdGVfcG1kKHB0ZV9zd3BfbWtleGNsdXNpdmUocG1kX3B0ZShwbWQpKSkNCj4gKyNkZWZpbmUg
cG1kX3N3cF9leGNsdXNpdmUocG1kKQkJcHRlX3N3cF9leGNsdXNpdmUocG1kX3B0ZShwbWQpKQ0K
PiArI2RlZmluZSBwbWRfc3dwX2NsZWFyX2V4Y2x1c2l2ZShwbWQpCXB0ZV9wbWQocHRlX3N3cF9j
bGVhcl9leGNsdXNpdmUocG1kX3B0ZShwbWQpKSkNCj4gKyNlbmRpZg0KPiArDQo+ICAgI2lmZGVm
IENPTkZJR19BUkNIX0hBU19QVEVfUFJPVE5PTkUNCj4gICBzdGF0aWMgaW5saW5lIGludCBwbWRf
cHJvdG5vbmUocG1kX3QgcG1kKQ0KPiAgIHsNCg0K


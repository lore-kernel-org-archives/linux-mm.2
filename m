Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A64C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B62F6B02F1; Fri, 14 Aug 2026 04:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EE56B02F6; Fri, 14 Aug 2026 04:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F756B02F7; Fri, 14 Aug 2026 04:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 156A36B02F1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:00:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2BB71603C7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:00:19 +0000 (UTC)
X-FDA: 85099127358.04.58FF85C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013054.outbound.protection.outlook.com [40.107.201.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AE42C000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:00:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cb/itG1x";
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786694416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jd1g4vk1eiKQo526xINFhw0ZRxwk/XY0WQkoO6hLb0c=;
	b=awAP4DZFhzYwpEc4Mw/KrhaKdPJH1HdHnixnT55ImrBiE05eaED905fPjnbtZsvXOEYbxY
	ImkOQm+zj1r+2QmUhJws9gZ/WBdLWh1RFv96WgiKXMY1OLzs8KU59J0FJT3qeoQSGvW1kO
	SNF3LwgSqsCRqjsBBpqgyBq4H6xr5pM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786694416;
	b=K9NRkn2LQhbhbl5eLZMJ/dpl2unZ9QXWgIsl7QoVF9QQ+RNhIVd2oVGOC+LoCfPaxrvGuk
	AIevXmAsjTpvmfl232gQwritYE3TQGu62RcsUDx1bYdzsW0v5HHNFYQwnCrSKEJFpn9pL6
	fjMTEngAtbS/i6anOKaZE9eqHxwxUMM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cb/itG1x";
	spf=pass (imf28.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.54 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WksnXj0AnaB04abFF/TmpJAeKOgRdyK0Y+HsIo2YQ/oasMBK/y0FbEa4WVmBVL+Grih3norCQ1mufiWS/Mq9OmqJhGH2GVBG6XQ9QOKVHGLhANYtxE1IDcTLWLsr6inH6ByXJ5MebwW0YcVJ5iHTXFfm+jDEHev8Qy7EHLA/6aziEmPnpOPT80aJU/HYrfQv5SsDbMe9LjgUPqWIVUMefB0XKxHnlmd8zSX0kZxViyofwhfi1UnW0GmCgWdxH5+DPgVTQyd/K2TiG/+y1hYaN1eCNTfoLVQD/Gjr6ipCOEItc2o1vslRYZ0viCS0nADNo6mfp1CsF7jJWM0mQvegRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd1g4vk1eiKQo526xINFhw0ZRxwk/XY0WQkoO6hLb0c=;
 b=bcdXdSpGuLKqoma6L4i9xLQX+SJYHtAjq5vCYDq+EWqiuShtGdaT23sRrrawqQ0I/TwzGx5R6mOS56ApN/8+DIjoXJvCZTBTcBozt8P2JPTpWcTdPfHLjIihoIWBYrqmLGP0deX76dEZwBie7wpj3uTItmLv7BvwPsKMxW1muDje4pWHsDT1/wRM8mJTq63e5mqe3vTB49KIqEu5Zfr0H9NW95jlGBBE7YhMHbW295BE040yraLf/7Zk2OBuXnzEFJJ1QSegBT5TOmNpft9dA0yf0tyb3P65CfzL1pcKpGsg7+00pGC8QH/0x7ZAQ39tbVo2D7BK/6tex6gXu2ULug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd1g4vk1eiKQo526xINFhw0ZRxwk/XY0WQkoO6hLb0c=;
 b=cb/itG1xjbxObfg8qc7GOA5ss9YERMEQKfCQgNQpXyTBqdwX+uXY8iIAOCXMlmE/fsOd2E6mly+8Km8OiOhJooyac4Avy+mpGIIV/bcmRyqFHyqfGvKC41ndKfJ/aSebZuZf514/f40ALshpVbRWEJwofVWBE3XqNy/uuSXx+es=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA1PR12MB8700.namprd12.prod.outlook.com (2603:10b6:806:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 08:00:11 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 08:00:11 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "rppt@kernel.org" <rppt@kernel.org>, "byungchul@sk.com"
	<byungchul@sk.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
	<harry@kernel.org>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "riel@surriel.com" <riel@surriel.com>,
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "surenb@google.com" <surenb@google.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"jannh@google.com" <jannh@google.com>, "liam@infradead.org"
	<liam@infradead.org>, "mhocko@suse.com" <mhocko@suse.com>, "ljs@kernel.org"
	<ljs@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>
CC: "Rao, Bharata Bhasker" <bharata@amd.com>, "kinseyho@google.com"
	<kinseyho@google.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "kmanaouil.dev@gmail.com"
	<kmanaouil.dev@gmail.com>, "fvdl@google.com" <fvdl@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"weixugc@google.com" <weixugc@google.com>, "rientjes@google.com"
	<rientjes@google.com>
Subject: Re: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
Thread-Topic: [PATCH v2 1/7] mm: factor out generic PTE batch detection from
 swap_pte_batch()
Thread-Index: AQHdKtueM0yQWXpIfkS5aMhDVrNWlbabvpcAgAFxjAA=
Date: Fri, 14 Aug 2026 08:00:11 +0000
Message-ID: <2dddb3bb15dd9179388cef41a6564dbe722f9b1e.camel@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
	 <20260813-migrate-rmap-batch-v2-1-3c5424c555c7@amd.com>
	 <f2dbbe27-ba09-4213-ab74-92db526dde7f@kernel.org>
In-Reply-To: <f2dbbe27-ba09-4213-ab74-92db526dde7f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|SA1PR12MB8700:EE_
x-ms-office365-filtering-correlation-id: 24ab2496-8b39-4168-1678-08def9da10ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003|921020|38070700021;
x-microsoft-antispam-message-info:
 EfIp8ifZumgetr1YSRMaft56fEQ9StsrDbpduC5S2pxt4DKU2FIc0JcbZrbHU335NhYm6OCuxMhOmErIcQ8z3+JKSslBjSvhDkBBxpOYv+1szlooiRR84Kte5a84nlkB1FerfOntY/wHGQwcwRnHngG0cRCwxijmxaRK136X6o51G/RTQ8MfLUE1pnfP20E/1rhKNJ6vgCk6LOapNTTj2iGIGl68lHDbkKrkU7g9L/NU/bEbBQYhKYmbgR6XJPXr7/T6pkZCVdBdmKZhwyEWMs9FFkiV4e42MaPqutD+CNoyrC5mwb6mhsWtGGpEQd2FfFVw13r6+vVIgD7AmYV5oUDrLqfXx70zOmIPMqtuYXOht3sT/99kbTtG8Hbc9D0mXzddUyFVi6mHwX6BW8Utk/H30t0oU244dutSGM0Cxd/zQK5Hs3uDPS0vzRsonK3kTMJw+lRCwzS0QmmxAEjAxMBZxSVj+4wCZbeTa4Ro42vZJHjnuWxKPyS/LxS76cfczb9azKLlTC8+uJ82Auk8BpiWrwR4h5mOTZqpbpsnQ5YxCUb1gAbms+Iz5TeD7OvbCNOUaRoBPIlTohrHtMhL42lhQwnU4eFvOdbONX3Eyl6e6wZYlQLQ29dp7XfIkUIRj3ZLW+Cb0zMDtGZeo0YvKdHVcrw4UU38Ps0aoJhCz/bxElV9GJCK6URjKA5ovnCjN764pEGY8JuXnNADAPLlZKrAFbXVXV/aG1XQUq1xINM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aU9QV0pGNytyaU1YR1hraGlWcjJrMWNzczRWYnBaekJqN01OSk96V1cweVVP?=
 =?utf-8?B?K1hMUUlXZFR4QnZ2NWo4eDk2ZjBLMFdOR2Ruc1AxaDUzM0pSOVBueW1qbW5m?=
 =?utf-8?B?UXZrY2w5U3JVcmdMcFJ3aHJjVVYra1B3OHdKWTk1eDRTVkRmMi9lL3RwN291?=
 =?utf-8?B?NFNISi84R3lqcUlkMGtSZmpTSVhwdUVSMEdQbkNYckk2VkxnMmNlL0ZuOVow?=
 =?utf-8?B?eWtGNjUzTzZuc3Foc3VDU28vaHEzcnhrTDBCS1JQczQ3TjVjNzhpTFFFSDhs?=
 =?utf-8?B?WHlQdDhxWmRGWGNLTWoxUkcyM0J0VmNHMGwxRjRzVW80elFYeks0dVhxNVpv?=
 =?utf-8?B?L29tNGpXajZ3empMeU4zWlVnbHRmNkdXK3lYSFUxTXB6OEdmNDBwMmlTRXB3?=
 =?utf-8?B?dU16TnFtdHp5Uk9rUHBwcUd6eDVPbHNYVFZKekxTNVVhaDRuWXZjdVpOUCt0?=
 =?utf-8?B?QW55RnhKL29leEZueTM0bDVUYlZ0WldidnQ3aFM2SG45UTZjRWdrRXV5bGVB?=
 =?utf-8?B?N0JkS29QTjU0d1k1QU9adlN2UXZpUGZ3endLRlBFQzJQdytKZVErMkcveldB?=
 =?utf-8?B?S0J1ajVRUVMxMFdHcE5uSCt5b1gxQ01GRit5SXFqTWZFNU9mMEM3WE5pMUVV?=
 =?utf-8?B?REYvbVNCNnVncDJyL2w1NThabU1XMkZkSkhxUzhNMW1UeXk5TXV0WVBKRmUr?=
 =?utf-8?B?NklRKzdGWWlDK2xNL240eEJLUlJGblRmYWt0VjEwQ0xCMWVJZC9DWldYRlJJ?=
 =?utf-8?B?alpPZGF3WVcrTjNJR3pvL0h4VTNFTVVHaHJnNWJYbk9RTW9Ob3ZsVHVpL290?=
 =?utf-8?B?Q0dFaFJEZlI5alBjWVFUS1VwK3FKYXlyR0xPVXFiLzBzNmd5clhHSUdpelBC?=
 =?utf-8?B?RE1JRTdQK2VydnhTTnk3Q0x2SlJ4NjJmK0dIUEI2ZmNBM2pEVUd3WnViWnBB?=
 =?utf-8?B?ZThVV3lpL1h2OGVQQUlhTWM4dTdIVGIxOUlXMWRJWDhCbWZnR2tnVEt6UTBG?=
 =?utf-8?B?SzFsMGFPNkV0TmcxWmxhYjhseWZxQTJGMmVvWENYNVNPaGprZU9DU0Jnd2p1?=
 =?utf-8?B?NElVcFU5SmpJajFBeDc2VVZrdUthb3VkWkJibVVVVytGbkVlSjFqUXlJbmMv?=
 =?utf-8?B?NHcycU5objI0cTYwVVhnbGdMREtaNTlia2ZCZWtIZnlMcVB3V3hvK1UzMml5?=
 =?utf-8?B?Snl1MHZQdXFTTXRqRTFYd1Y4RjByNCtTVzhzV0tXYWNrUW9HVWM2MW9rVWhI?=
 =?utf-8?B?dHpvMzlYQjJ1TGxPRXFWMktqRmlyTEJpdDY5d2FOS01XZFZzZVFhM3hDbS9m?=
 =?utf-8?B?RDhZanZUV2U3bUtvVm83TkdCRHM1dTJQMmxGa0J0dUs3azBiKzMzYkFGN20r?=
 =?utf-8?B?dGZBMEM1YXFtTnRPNWxwUWZPdXZjM2xXdWtadTRkbU93VzlmczBEaFNjQzdJ?=
 =?utf-8?B?cnJSVkZLL0ZFdjdRbUgvRU1QWnQ0YlFlcVhHdUNiTDZ4R3lHQnF2SHpvd2d4?=
 =?utf-8?B?cjVVMFo1WFpva1VGaVZ2WnpBb3lrNFdMTnNLaEw1MkwvdE1lVEt2OEN0eC8r?=
 =?utf-8?B?U20vSnRHOXREdUdTVy93TDU4RHdOR0gwdmZUbTBMZDFoeS93S1NZSisrSE1O?=
 =?utf-8?B?ZHZVKzJUcldxQ2xUYnRnbHJnYVNvSmhYbUw4a1l4eDhVMVdEMGsyMkRkRmVT?=
 =?utf-8?B?RFhmeFQ0UDNtQ2phdUhXOUY4OEFHdFR1ZE5UM3NCbUQ3RGFuM24va1VPTUlQ?=
 =?utf-8?B?SzRBOTJFS3pqK3JlbzdwV0U4a2xTZUkrTjh4N21UbFlIcE1BcjZQMUF2aUs3?=
 =?utf-8?B?d0pQRHcyMGpFY0lBd1JjM3dnTW5ZanppaitwODVGdHkrNU10czJ1cWVaQ2ZP?=
 =?utf-8?B?OW1HRkxYeTBLaTVSVW5ZWmVKOWpHRjZNcTd0NjdSOVdEcHBYRGRqZTcrMzF0?=
 =?utf-8?B?aWJReHd5MjJRUURHSmdsTzFMaU9YU1l5NzFlUk9HSnc1V0o4YkxDaXNmeHdW?=
 =?utf-8?B?QnpqRnE5R1QvRy9RVVMyYUk2TzI2YkZXdHkyRzhTOFJyUUoxbUg1clJheEh4?=
 =?utf-8?B?U0xzMGtnc05xZHNOYnZtY2pybHkwaUpmOVBQVXlrUXUyOE1lV1R3Wk1HMjBK?=
 =?utf-8?B?Z05mK2VWRzJFVmNSREVSQXZJS2pwUFY0YllZK29OUGt2UkIxUkwzM2J1d2Z0?=
 =?utf-8?B?V01yZzl3dDRQL0xsTW5DMTFkL29JcE1sZVU0ZzEvNjNpQlJzNDRTaW5vblpZ?=
 =?utf-8?B?K1V2NW91WHN2Z3dweVBGajVvVkNQcE4xSXVKSnhoN3dkUGhodnpnV3IxT1R2?=
 =?utf-8?B?QU9melR4RWVCNDliRkF4M0s4OGwxLzZoNWxRQ3RMNmxtVDlxa0plUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <230A3E8D9E099F46B98C0B4CF31EEA29@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ab2496-8b39-4168-1678-08def9da10ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2026 08:00:11.2788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TSojhXr8h6WWPTKFqJONaOzek5DzUNO8QGIKxmlGxwY0Ti2dzV0K5ETxBB+od4L4MowNXTYF0Qc09kfcC+4eaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8700
X-Rspam-User: 
X-Stat-Signature: z4mhjsumd1xa5eo8j3g3kf4uzk35fyd3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AE42C000A
X-HE-Tag: 1786694416-908139
X-HE-Meta: U2FsdGVkX19i9yImBytj4DQdDTdZ8AYsrAiWtqWD8HS6KEBvwuoF7YN0apcC9ddO90lgoG7Yue3x2PN7OW2A3Ag+zgs4iH/jgE7nZTNFhpeNvce75gXqF8Mhmecr5d6tV02wKewtswEj2zRjI9vYLBaFl50/GEu9WXaTXkTs4GVMETVju8rWLrwBiuPWDBri+prdBJNFcCzIJHiRcsuvoXhDoEMJIeKdQC5a3Jf0G6yi2Mrq0Cm+jkHP1sJBEsys65gwKdKHODgNHe6D0sm++QJEPTRe64LO6STanDBBujP6oBwT9VGDKNLvcXWKV5Qp8nlZ8krJvwI7biBOoFpG+bYaeBXQsj9gWwQLYT2nXmfobJ1eaQqASUz8vgEo5jC2cEqK9dnqamMsqe3CPzwb7IFbkefa0g6URY4xsn27lhIbhekz0k8zztA7WHhTE4hS858HorrhkTM3++h+4oqotZqRazU1wyfBd9QC66Xbwqx9PagmemhyYWwgd7YvjvOu8aqO0nN5wqOh7d1FlxOlTSKLkcwU0dbTGRDbfw6WNwlt2KiOIr02X9fgvNqSPz6lFKRlwEAWnsIjaituGUMD/r9pcSq3InPbh5cmh7BszPzzds4s7OoCPPV4rwBjYqyRo7sQbaeAWYL/Ci17ixu57e/ma5w7k/RI1elnYcyzfzgosoOKbrQjRrVQkS3Z/Q8OGWGCQD1yv7zMY68Qdxy9x7VxwUnLGllGA6oLy1/I85uo+Yom7kDueOkxvb05AlOH014WfxYfB6h9JNmWZA35qItxEKLMmlHxFmX2BT8VbFXgIh+h0CWvRN7HfSKLMSaOAwBcaiuG7RizQ/tWb7nlSTT1YQWRbhIu5waby2b9obCrKKlUCM2J35xJNKd5uqvA9ps9wkgIyeSF7XWDBMo6nSpQHpwlTGm/kydetKaPhancaVaymXdKNhFUjlkCO+BnX0s4nkzufwM7KaDXNVk
 Yonslpmk
 8kOkFnsr0npafUvF0wKNsL/nuPZ9GE8eI+Rajl+NuMddNUSENj32Gruycjc6HrgT77rncP5byGvNTcwJTC9Je/T/lYzwyBsd1nCreovlrxuwNvz268skRdIXnc8IB3O1L9aM8HbPAl8Lp36KtGYv5Tr8DZASqCvHkHo8TBFcGTiTEhPabpoleFgcpfPoSnsGP7eWi7TCGM/P1UEarPhAgsUAYJjj69URffkeBaURPbGkzHuEaNJXimWKavTPyCGc0BXxuM1OuXOud3d/wklLXiuakpENUlwLn9lIuSo4s8hdgA0H+/sAFm8tK39apH3ADktQz1AHFF8kfSxyttE6mj8Uniflz9pD0Jp4QGjMURYyigSzCGgDQ/8IsUfRep0sANxUQ751Xm+4RokeXocx5G2AWBxGxSXB77JGKML68QfA2qvXugooHfZYqe2V02Dz++F0wIm96JcRmEMLWiJJSIUvXTXI+ryx6dXg3zuZh7Jcn40YyFqMDb++lRjFD2xhS+nL+RPqPUHAhkXq28YWXIpypf7mE0TYni4f/6o/miuoD+WzN9jsO1NsC01jMWZbDM138twiQDcEKdCht2lCwDdYVDF2HZnjozwnn32hM9cLnk1RSRPlCnCzoWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA4LTEzIGF0IDExOjU3ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gOC8xMy8yNiAwNjoyMywgU2hpdmFuayBHYXJnIHdyb3RlOg0KPiA+IEZh
Y3RvciBvdXQgdGhlIGdlbmVyaWMgUFRFIGJhdGNoIGRldGVjdGlvbiBsb2dpYyBmcm9tIHN3YXBf
cHRlX2JhdGNoKCkNCj4gPiBpbnRvIHNvZnRsZWFmX3B0ZV9iYXRjaCgpIGhlbHBlciwgc28gdGhh
dCBpdCBjYW4gYmUgcmV1c2VkIGJ5IHVwY29taW5nDQo+ID4gcGF0Y2ggdGhhdCBhZGRzIHJlc3Rv
cmUtc2lkZSBiYXRjaGluZyBvZiBtaWdyYXRpb24gZW50cmllcy4NCj4gPiANCj4gPiBzd2FwX3B0
ZV9iYXRjaCgpIG5vdyBrZWVwcyBvbmx5IGl0cyBzd2FwLXNwZWNpZmljIGNvbmNlcm5zIGFuZA0K
PiA+IGRlbGVnYXRlcyB0aGUgYmF0Y2ggZGV0ZWN0aW9uIHRvIHNvZnRsZWFmX3B0ZV9iYXRjaCgp
Lg0KPiA+IA0KPiA+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlcyBpbnRlbmRlZC4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQo+ID4gLS0tDQo+
ID4gIG1tL2ludGVybmFsLmggfCAzNiArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9tbS9pbnRlcm5hbC5oIGIvbW0vaW50ZXJuYWwuaA0K
PiA+IGluZGV4IGE1ZDA0ODhhNTRkYy4uMWUxYWI1M2I2NDJlIDEwMDY0NA0KPiA+IC0tLSBhL21t
L2ludGVybmFsLmgNCj4gPiArKysgYi9tbS9pbnRlcm5hbC5oDQo+ID4gQEAgLTU2MCw2ICs1NjAs
MjYgQEAgc3RhdGljIGlubGluZSB2b2lkIHNldF9zb2Z0bGVhZl9wdGVzKHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tLCB1bnNpZ25lZCBsb25nIGFkZHIsDQo+ID4gIAl9DQo+ID4gIH0NCj4gPiAgDQo+ID4g
K3N0YXRpYyBpbmxpbmUgaW50IHNvZnRsZWFmX3B0ZV9iYXRjaChwdGVfdCAqc3RhcnRfcHRlcCwg
aW50IG1heF9uciwgcHRlX3QgcHRlKQ0KPiA+ICt7DQo+ID4gKwlwdGVfdCBleHBlY3RlZF9wdGUg
PSBwdGVfbmV4dF9zb2Z0bGVhZl9vZmZzZXQocHRlKTsNCj4gPiArCWNvbnN0IHB0ZV90ICplbmRf
cHRlcCA9IHN0YXJ0X3B0ZXAgKyBtYXhfbnI7DQo+ID4gKwlwdGVfdCAqcHRlcCA9IHN0YXJ0X3B0
ZXAgKyAxOw0KPiA+ICsNCj4gDQo+IFdvdWxkbid0IHdlIHdhbnQgc29tZSB3YXkgdG8gbWFrZSBz
dXJlIHRoYXQgdGhlIHNvZnRsZWFmIGVudHJpZXMgYWN0dWFsbHkgY2FycnkNCj4gb2Zmc2V0cyBv
ciBwZm5zIG9mIHNvcnRzPw0KPiANCj4gPiArCVZNX1dBUk5fT04obWF4X25yIDwgMSk7DQo+ID4g
Kw0KPiA+ICsJd2hpbGUgKHB0ZXAgPCBlbmRfcHRlcCkgew0KPiA+ICsJCXB0ZSA9IHB0ZXBfZ2V0
KHB0ZXApOw0KPiA+ICsNCj4gPiArCQlpZiAoIXB0ZV9zYW1lKHB0ZSwgZXhwZWN0ZWRfcHRlKSkN
Cj4gPiArCQkJYnJlYWs7DQo+ID4gKwkJZXhwZWN0ZWRfcHRlID0gcHRlX25leHRfc29mdGxlYWZf
b2Zmc2V0KGV4cGVjdGVkX3B0ZSk7DQo+ID4gKwkJcHRlcCsrOw0KPiA+ICsJfQ0KPiA+ICsNCj4g
PiArCXJldHVybiBwdGVwIC0gc3RhcnRfcHRlcDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoqDQo+
ID4gICAqIHN3YXBfcHRlX2JhdGNoIC0gZGV0ZWN0IGEgUFRFIGJhdGNoIGZvciBhIHNldCBvZiBj
b250aWd1b3VzIHN3YXAgZW50cmllcw0KPiA+ICAgKiBAc3RhcnRfcHRlcDogUGFnZSB0YWJsZSBw
b2ludGVyIGZvciB0aGUgZmlyc3QgZW50cnkuDQo+ID4gQEAgLTU3NywyMyArNTk3LDkgQEAgc3Rh
dGljIGlubGluZSB2b2lkIHNldF9zb2Z0bGVhZl9wdGVzKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1
bnNpZ25lZCBsb25nIGFkZHIsDQo+ID4gICAqLw0KPiA+ICBzdGF0aWMgaW5saW5lIGludCBzd2Fw
X3B0ZV9iYXRjaChwdGVfdCAqc3RhcnRfcHRlcCwgaW50IG1heF9uciwgcHRlX3QgcHRlKQ0KPiA+
ICB7DQo+ID4gLQlwdGVfdCBleHBlY3RlZF9wdGUgPSBwdGVfbmV4dF9zb2Z0bGVhZl9vZmZzZXQo
cHRlKTsNCj4gPiAtCWNvbnN0IHB0ZV90ICplbmRfcHRlcCA9IHN0YXJ0X3B0ZXAgKyBtYXhfbnI7
DQo+ID4gLQlwdGVfdCAqcHRlcCA9IHN0YXJ0X3B0ZXAgKyAxOw0KPiA+IC0NCj4gPiAtCVZNX1dB
Uk5fT04obWF4X25yIDwgMSk7DQo+ID4gIAlWTV9XQVJOX09OKCFzb2Z0bGVhZl9pc19zd2FwKHNv
ZnRsZWFmX2Zyb21fcHRlKHB0ZSkpKTsNCj4gDQo+IEFueSByZWFzb24gd2UgY2Fubm90IHNpbXBs
eSByZW5hbWUgdGhpcyB0aGluZyBhbmQgZHJvcCB0aGUgVk1fV0FSTl9PTj8gSSBtZWFuLCBhDQo+
IGNhbGxlciBjYW4ganVzdCBkbyB0aGF0Lg0KPiANCg0KVGhhbmtzIERhdmlkLA0KDQpBZ3JlZWQg
b24gYm90aCBzdWdnZXN0aW9ucy4NCg0KSSdsbCBhZGQgVk1fV0FSTl9PTighc29mdGxlYWZfaXNf
c3dhcChlbnRyeSkgJiYgIXNvZnRsZWFmX2hhc19wZm4oZW50cnkpKQ0KaW4gc29mdGxlYWZfcHRl
X2JhdGNoKCkgZm9yIG1ha2luZyBzdXJlIGl0IGhhcyBvZmZzZXQvcGZuIGFuZCByZW1vdmUNCnN3
YXBfcHRlX2JhdGNoKCkuDQoNCkJlc3QgcmVnYXJkcywNClNoaXZhbmsNCg==


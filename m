Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D2CCF588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D7A6B0089; Mon, 20 Apr 2026 11:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDAD6B008A; Mon, 20 Apr 2026 11:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC2F6B008C; Mon, 20 Apr 2026 11:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39E926B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:38:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9051A0A23
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:38:37 +0000 (UTC)
X-FDA: 84679341474.25.2F5EBF2
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020114.outbound.protection.outlook.com [52.101.196.114])
	by imf18.hostedemail.com (Postfix) with ESMTP id 166211C000B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:38:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Gsw+Qsne;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf18.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.114 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776699515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y844hGU6GEmxVpI6CjymvEDZ1pA+jm0vCBeuTVg2Hy0=;
	b=OOyGqqvPpSsgo9J4amhk/YXNQlyM72U78g3B0JQlxLXb60quGP7dxV1P+88p53RyUig5Kl
	xvlysiOZqmsZl0ooHBT4meJFpdR1LPPJ0sFgjxmlm2noX9nrfBE0mWUtRDZbDnJgLRi8HC
	wHxI6sMcN9fuoiEpAm5ZDkiIQCep5K0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Gsw+Qsne;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf18.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.114 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776699515; a=rsa-sha256;
	cv=pass;
	b=rdrj3hTOjGvSu/i52JNVoSW647Vw0UF3efWBSoFJLAagCgJ4wAJOpAsDQcmRjcToFbRPJ8
	FqSlLta5X/WAl9/cUJh6XhqG+tQFAimNLcUi1LaA1Xg5OnWStpKPnjT2wvKgRoBUSqy71B
	uh6ZjmRd1eKZqvPWPax5y2jkBLHk8ro=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+NU6jnnaidbK0Khtd4+BwLCFB5Jh2TRg+Pf5rEV7QFAuJpq33WDCINXRq/nuu6oFgmx9e30iUa8smXd9t8+rfVonculpouv9ZFhIxEBs8x7uJVf4dwHOJIAcFDOj2Pm2fYQTLAaN/0T4vnYcJKBj1kOA6L3Y6IWK7mqsv5wMxmFzLWUmPozyCKKSSB4s737svHWMmB6MiK7DEedm3KbzCOb9cxB2dLgfH+4ubV0AzoD0LEpdBomSFnqAl9Wkyj+9G/740y7yjOoxKnxaPTbXRkCxjaoLa6UKa5yaEPQiToa5Qz6LpdCa3ncR7Kz9PPCtuqJQ9okOfeO5TevKWTNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y844hGU6GEmxVpI6CjymvEDZ1pA+jm0vCBeuTVg2Hy0=;
 b=TdWEpGPoBxHcV0hvdQXo//nCdJs1AiQurVnCdyIwwv23oqfkMN2XWuUOdxyy9ym/KyfF7qAV1bhuZjvImgAl8VvUnBKXGf2lEUpyROYQ+wojXGY2eiWi5NnyhioXCbH/h4PNbnNUOt4tp/jTrkSJ9OATbGRb9pRtStqirYsF7rjRFfjHMlsAkHVtyjSuOEBrd9O3HKWUs7hH8zB1YjUorSIQ9JCev9steRB5U9HBCL/88rWc+mCbuAke0drkwxrcxwb9TJK6lanMcYkK5sSdvD9GzjY6mzQ8lOM5TJQSlolDFkGuLqxb5em2SPjyTtLh4Lq3yEqksUF4nZWYbXVR3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y844hGU6GEmxVpI6CjymvEDZ1pA+jm0vCBeuTVg2Hy0=;
 b=Gsw+QsneYw2wxU/9rbzwJjNU5cEFSUvGv+021UItinaaaCJ2F/uX8MYmIf6CngITIGhsu7AwA3nnIhI12Az2AKo52ytzSqQbKNWrZsvntQEy7ykMY/iOYcnybTz69M8DXwV5INL6jil6X4Rghixpjt6LVC1EDgNaR2nHQ84me5c=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOAP265MB9285.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:495::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 15:38:28 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 15:38:28 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Apr 2026 16:38:28 +0100
Message-Id: <DHY3EUA4LHIE.FAP0QSKIZWYF@garyguo.net>
To: "Alvin Sun" <alvin.sun@linux.dev>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Tamir Duberstein" <tamird@kernel.org>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 3/4] rust: xarray: Update StoreError comments for
 alloc()
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-3-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-3-41c6e9bb061c@linux.dev>
X-ClientProxiedBy: LO4P123CA0652.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::13) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOAP265MB9285:EE_
X-MS-Office365-Filtering-Correlation-Id: e541bb14-ed5b-4db1-afd9-08de9ef2de93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3ac+nOOBg/ZJXnVYMHEBJTu/BmpOxAwmYk7OcIhLTTUxFvIwUcHeVazC9JDVXZiaRhN4uCahr5xhY5X8KgWyyyG0WOwvnMNN0GKswMCymdIyAvUnFxcLNYimAg+jXfnbatRkT9PJU+vUrav9vKYCib2EBM1h8EEMKkMjnci0BxHVPKEaY/dh0O6AMXbFScnggabgA1OvBeDCgMdY0lqWulCBYY2g5q94bZl3RyYR0yGS3V2Eijyjz+ElBZtGVzl20P4wgMHpcOQGegtr60PPFspw/21zVjrSLul10LNFMI7uNIisJuax2BO2Tbv2icl35XBIh2YsMqkF3bFkZg2VwsE9Yvi7ILn7byfaR9hul8q/xu1fqPW+OLHmLfFRj1ralVscA+rcsz0656UFS6K/KDPvHZXuGL5+W0L/leE5LZDt9DeV4OGCjE24e/qYpiOiBjte5iVrhA3MkpCSs538RXIZM8/NTRNVgrh0tRixINyAFukwFwNXdFMDMTmnSB91Qb3chsloz8CJuVt1xdkcqYGufGy/+3mXpA//Wnyhxm9FPOtr8cMji9E+OQ9grmmZ8O0teqq7ZY0OGI29rcZ/Zq5e4+PIiirA7LftE/mbGWbzJCssbuauc3vm8MSKgsnY/GoHWOfogced4HkeSdk9qbCMguIql9qc3PVC07NaeNEu1DxKndVrUSjvrAbuSJATlWXxlZ1mj/rXU1Jyuu3mJwSLGmDfu7sBDXihhQ3LtdSlCTdtg+X5j8zm0VAES6+S2Fza5XShLcjb0nyk7qN/4A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1hGTCtyRGVwOStVZ00wUnl5U1JyTGR5NlRRa1h0L0l0eGs0Zk92L09WbUE0?=
 =?utf-8?B?ZldTeUlQcDYydFhCMWZNcDI1UkpkUmFtMmk3N1dUaVgyNnV0a0UvcnJJTUhJ?=
 =?utf-8?B?bXVXNThncGxuaHllR2R5dnJOczB5MXlINi9rZmZ2S2xEWmhqSUJBR2l2OGV3?=
 =?utf-8?B?WEpsSEtobmxFVkNuNlo5Rys4Z2FLckR3cllvV2ZBYVdud3lkNTE0V0h1R3la?=
 =?utf-8?B?d0xnbHRnRlR3N2JoQjlzQTg2RThCMEpqT3R5dy9VU1N4c1FpZ0FsT09uTmEr?=
 =?utf-8?B?WHFWR2ZzZGMvUmUwKzJvNi81WnE5WkFCOHVjK1UwMnZ2djZiZU1zeEZTT1o4?=
 =?utf-8?B?cTNKK1hqMUtJMUo2NFdsU2JEdHp3L0ErbU5rc3RiUnBRTGduUWRab1FpbHJH?=
 =?utf-8?B?aDdTcGlxbE1OeVYrMXBoQ0wvOUtNL1RHU1l6V1JleFNqZFVUenNrQmtUSDRW?=
 =?utf-8?B?Um1hSUpiVWRPbVRmOENncWJmR0JtWnBqOXlIRldTUjJqcmMyL3pSMjFLODRI?=
 =?utf-8?B?Z3AwV3dsQko1cjFhSkovTnppTzhlNHdNdXpCU1owRjVYVER4emlvR3UyVU8z?=
 =?utf-8?B?cDMwWWw3UU5KaEp0aks1dXFMUS96UUtFZGdCdk14QXFTWWhMNzJTV0UxaWpL?=
 =?utf-8?B?NFY5RHJSKzhXS0VBNDRVV01ZMFpOMTlQb1FyNDZUSEJnaGwvQkQ3N3MxZk1F?=
 =?utf-8?B?cExPWE5Pa00yNmNMSFpaSnZsM2JhVEZtS0NrVE94U21wbEFoQ29JNEIyZFlz?=
 =?utf-8?B?ckx6QklmV1JUWUhZZ0wyMWJxaFZ0SEtYb0ZvUjVtN3JTYzFveEdmdys3ZFBX?=
 =?utf-8?B?NzZ2RlQxZWJoQ1BMVDZHK3V3UXJhT1A1Y1FPMkJ0RnJOWDZ1djlQaXdodkFm?=
 =?utf-8?B?bHcvaWtBK2VqUDVNM0NjbzQ3ZitVcTAvbXVVYzNsUmVHejFlR2FRSS9lT2Ru?=
 =?utf-8?B?MGlSZUtVeGVnU1JMVkVaRVBneExrT1RoKzJzRXJ3L2gvTzA2TnU1OWRyZ2li?=
 =?utf-8?B?ZHlHNmM2MFgwalF2MkM0cE9jMmxSL1pmaUNNeGlDWmRpbmhEUXRsYWZJTTRk?=
 =?utf-8?B?dWR5elU5aXErd2ZMaFZ1aEpvWjY4a1JyWFJrcWNRV0JJQmxwaG1RSko3d21Q?=
 =?utf-8?B?d2s4SExDMEtVbTVKeDJrYjhSQzY0YnhsQnhuRHR1NmtYRVBPQnZtUGQxdkh5?=
 =?utf-8?B?bzQ2aDRqTk5wNUsrTkJyY25vUmNzMUsxdXJKOXBtTUl1cHVtTkJzNXNTV0pS?=
 =?utf-8?B?KzJUbE9UVmMrSVpmSmtsN2ZRdnZISGFHaXdkcElxKzk3MUFTUjgreGVrS1ZQ?=
 =?utf-8?B?NkwwZGNndzRvRGVXYWszYjExdU1hL2xRTVpWOE4vcXl6WE1YUVJWZWtVY3c0?=
 =?utf-8?B?UzEvc2dxckZZM2pCcUNGRGI3aXJXdUZtd2U0QkdSenBwc2ZXamlORGYvRmF3?=
 =?utf-8?B?ekxzRzM1bVhxbndFcDJRait3L3NjZGxWRjE5NVB4V1ZlMlNXUC81alNqOWlp?=
 =?utf-8?B?OVdXYnRaaFZmUjJPVDFyZmpJOHBEbDI4WmVMTS9rSWFpWm5YNVJKM1czakhr?=
 =?utf-8?B?MVFCQkJCa2ZmQmFzN2F2U2h6UUI1QmFMWlRISjc2U1I3VkgrY2F5dDYveTNR?=
 =?utf-8?B?YTN4cExOSEZwaTR5OXFwNHFHOUR3U25Icy9PQmhKbXNCNWYyQnZuQ1V2TWN0?=
 =?utf-8?B?NGpFK2tRZTBEZDh6enliazlxQ1lJcW1wWHJNTFVGbjBkbjk3UWFTeTI5ak5H?=
 =?utf-8?B?NFZrVU81WTdESUwvUmE3R2dEZmtnakxjNkp4MlVlZG94YjFJTldScXpoQ1VJ?=
 =?utf-8?B?dkZvTi9CRWlUSlFnT1hOK010L0kyZTUybGdrTklBTGtoQWdUcm9SU0FRemo2?=
 =?utf-8?B?YjhZTWlyR1hmOE8vVG0vcmxCOXRhMEtiM0F2akZQeEhJTmtEN1hTdmtZTDRx?=
 =?utf-8?B?c1Q5cjVWMmphWHpPSmtiS25qSXpoOC9pK0dsN01VaWFoMGp3eDRkMjRIQnRM?=
 =?utf-8?B?bnpjMFNFTFRlamlXWjQ4a0lXRDJxTUN4VEJvWit2UjJlYUZCd3ZjSDdmZ1l3?=
 =?utf-8?B?UHc2UWtNVVQ1ZjFMNEIwZjF1d0pqMU5ZaXBzOXNETTBndS9iOGJobC91a21q?=
 =?utf-8?B?N05YYmphZzc3NWlKRjIwYmRUc016WjVnQm1ONWhWSlAycWpSeUFUTTdJaUQ4?=
 =?utf-8?B?YURlWnNtcE94SnljcVA4S0pyTHJIWFN5aWVjbGtrYXJSSlpYNzNaRGtCeG54?=
 =?utf-8?B?ck80ZHUzWVk1RWdNMlFwSHBZV0lJUFdvNDJHVmc1b3dTeUorRi82a01wV0Nx?=
 =?utf-8?B?U0FMc2dUM1NLUms0Mnc5UXVRcW9KclJSNVgzcFlHYUh2ZE9tY2didz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e541bb14-ed5b-4db1-afd9-08de9ef2de93
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 15:38:28.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFxLSoaLDyCezNmf63qovT3CBqO9YWPan2zKUJYol5oVt2i9Sv/caSilNeHGFqTvGnsFHiLtHpJZLERRI+KaaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOAP265MB9285
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 166211C000B
X-Stat-Signature: jymmaba5kderak4obe7hc81ww1yqnqw4
X-Rspam-User: 
X-HE-Tag: 1776699514-372561
X-HE-Meta: U2FsdGVkX1+faCVOtaEY0pw+wUeMd1Vaz3AcqfJ+82y1dsY5m07/SUiXOVLEf9e0ffrkdCg3y6GMaN/eG03ggcRxF9oqliAE0WZOTIkyDY5rPYNtLXmek0MzbBfc/tegwB8oUj4PsnJFAVMjDofFui5K5S9ci9+5FJehlYbajQ0Ek+0LSflYi1LPuYVHRh5MQnPZQaRpvR1iAvooCJO7p7XvolgTMaGVaF1hNxwbBIGmvLemhTYwdxFki2HJUoJDAx4PmmVU5wJbSDdeLVboy4MoQCq0qWzQm0qlOFtM1V56BekDT9GH/ePdpg9o4XCyBbFxDPBXty8wKRiRdm4fLhV0Mv/DbEAWCluIegng60VPf12JVDro4MC+3LyJuHPm7ieWsHiJgcFEJw4GOEjADSE4D77siYUKAS6IMgrnQEM2iK2Pp/2rea6brVhvHHSH6p1EveTidUd6PnNRyOZaxN3Gb0Mn/kAe1muZO0meERpaw/1unJk3oWAFz3wIy8ht3QwHfZTrGZS+M2i1CjSFpHs+K62HyodniqhLLK1lE+4zPuPhz+1H0lOngyAnkeSQH+37SH2W5wmofxkdXHkKiaYpXbtYs9r3Vz2Id5Mgv8eHF/GEHrs/roSjO2mNkbO63mOuIiOq2SDlYvCWk2V6/aUdgKO6QoCANfNifr9m3SNj8BuGDDk9PGuGh5ItTnwUYvZ7A6SBjYMdKjv3zzvVYzRTpQ0MnrveWGn7HNUZA/25lhcr1kB9Fheb0R5zmrax1o9FVGg8KUDbQ0ZztQb1gTofVlN5SwX2f9Y2yOyb+dcDGIWCv/o5m9Zn9Tq8gHwHUSEURBgt6Uekk5jaNLkBI/dRuu88I1j55dFAfb1Kx/z6zR9vtdQ/Ox9HgM97qtiUKxh2yDoIcn9kUo4kNTRaYrE+R9sKdZN0iTnq2H+NNumZiPeAIHiusBr002bgBR1b1B/IPJDz8O70YReLSum
 Pr4x4ZWq
 P6aLEDVPLTaKUNMWlsW6SupxcPnER+iSRyjyckkSzRTiUX3o7Ve+z138EFV9GWcTEF8od4r3rTGLPqFXh+min67FylycmwzWxwfpWGZKTc2ZeWtkpzXXj6Edp963Y+JimTXqGLrpLAdvv6NlseqC4qJhSzMOMUHl8RqqI8SZ3eCWtgpd7PLYTntKoI4hOcpD+uc9jJg5hs36SPkZfQ15QzSvMIYMzKLZM/RZZo0jWj5ygPsEVf1uqmfkpkPXaA/lGP8kWh0Pp5+Ort864eK8IgLySnIOEWxhwaExxc4q9Om1qeN65GSOLJr4Rfzfw7v+Kxn0nUV62I/mHYk9n8lHpBsNIy307e26vKajW1zir0j2Clq9dlO2cE+kB4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 17, 2026 at 2:05 AM BST, Alvin Sun wrote:
> Update StoreError documentation comments to mention alloc() usage since
> this error type will be used by the upcoming alloc() helper.
>
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  rust/kernel/xarray.rs | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 1b882cd2f58bf..235fda0e394ba 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -161,13 +161,13 @@ fn drop(&mut self) {
>      }
>  }
> =20
> -/// The error returned by [`store`](Guard::store).
> +/// The error returned by [`Guard::store`] and [`Guard::alloc`].
>  ///
> -/// Contains the underlying error and the value that was not stored.
> +/// Contains the underlying error and the value that was not stored or a=
llocated.
>  pub struct StoreError<T> {
>      /// The error that occurred.
>      pub error: Error,
> -    /// The value that was not stored.
> +    /// The value that was not stored or allocated.
>      pub value: T,
>  }
> =20

This should be a review comment to be folded into that patch series.

Best,
Gary


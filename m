Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404D1E7C6EB
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486286B0005; Sat, 31 Jan 2026 15:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409C26B0088; Sat, 31 Jan 2026 15:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1456B008A; Sat, 31 Jan 2026 15:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1563C6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:49:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9877413B12D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:49:03 +0000 (UTC)
X-FDA: 84393448566.05.880046D
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021083.outbound.protection.outlook.com [52.101.100.83])
	by imf12.hostedemail.com (Postfix) with ESMTP id A174340002
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:49:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Eo8YywLd;
	spf=pass (imf12.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.83 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769892540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVhW2IyawMVUd/geUrb5UUeneeN4V6dxkSGBcxmufoY=;
	b=zNMONUscNO1ajGt86RHuqHxpZJ6rq8k98KuCr1zacbQoDyroyMUSnF7db/PJKNwT0dRecL
	QHoB8wZ+iQU4cLOgpg2KQZS0X9RndQTw3AszihJ5N6vE1SOXdWAX+jxzlw9d5t9XvHQ2UC
	yHjZf9TJpD7Ed3nd59DaAKr7WRSIW20=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Eo8YywLd;
	spf=pass (imf12.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.83 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769892540; a=rsa-sha256;
	cv=pass;
	b=FXVZ8m6jBCg4L2MJKEAxgPJrZt1paAAA86yKrrx679lwHZdQwaap66dNzt6OiDSp69tQYh
	GhZZRluXgzbJHWybdkodJMf8TB7QY19IwPqrm+5oqavJdvaPmY6/KelBISdxoRGmtg6Or2
	ZPSXnmOG4h1fZDooW72B4hrwtWbo5r8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQiNx1vnpqo0xGe0VBB+X38FGtIOzeGZ0ZoZLMDE6+mkOE36aUIiVynX+JKmlhKL1jcuOtKJRooLaO2EHYKsSpPSGY2+OISWSlwvLNS3MHJdb2T62/GTnnLBGeSERASn+7EmVg7UhJNN9Ac15SFAs3BntmXbz7LmSx3d9q0rWbmtttjUDzqrZs+ir/hCha9YlGffELvhyhMOJr8wuefHAWpsJhzOPu44Dm4P7KMIKWcbLQrNWiHU3xPSQVRYE1cnPID5gw9Kn2rbDOvhPTqKoeK5LtQrXMltDp3t0g7+ZYC1mFPm31I2MZlooDVapKDFXYquxl8RvbkM6tylphPTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVhW2IyawMVUd/geUrb5UUeneeN4V6dxkSGBcxmufoY=;
 b=Ktsl71cu5yrGf2nwDHjFvttMgX3CvDGV5XA+vIe0QsTaPvjUgNsXj0tYw5Nzl7dkPS78e1xAdN70KpO1ybraPTS92KatA/6vWoXR8m0A5A9l6rsPhrdpohCKSuZazd2A4rO3BdgkRkv1scKsTO2DTpcqo93rRQaVWXchmbCZOmiNXDfLgCq6pLR1m2xjuLRRGOsgPtwMHRD+FwXYxfcRcsQDebmcWt/aHZetfvKVXOI1Q4qvOUzu6AEP1v0XJsF7tl8MxP2HzG6dE831leDbvgPrIqrAlNPBPUwO2LpQsqPMlqcrZApBRbUfgb/+jdDpJs8nHQDiyVYbDBZF/6n/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVhW2IyawMVUd/geUrb5UUeneeN4V6dxkSGBcxmufoY=;
 b=Eo8YywLdZlV1Lxp8b9EWzX7EQC4mftYTr20D0s7Q764pS7hHj1OkT4XeTM9S4A+VEmllex1XU4NhIf1ajFGxHlURBpigwXmNtOF5tCdr1ZmUfm2mYfnnXxgtKjP/gbkpTJa491h7UBNTofWVZSIBpyHMnUgUAiKUMEUMUXoxSz8=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB6424.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Sat, 31 Jan
 2026 20:48:56 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.014; Sat, 31 Jan 2026
 20:48:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 31 Jan 2026 20:48:55 +0000
Message-Id: <DG32JI45HFKS.29745T7AZGFTV@garyguo.net>
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich"
 <dakr@kernel.org>, <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, "Boqun Feng" <boqun@kernel.org>
X-Mailer: aerc 0.21.0
References: <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid> <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net> <874io3rwl3.fsf@t14s.mail-host-address-is-not-set> <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid> <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net> <871pj7ruok.fsf@t14s.mail-host-address-is-not-set> <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid> <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net> <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set> <aX0lcVngRcRwqgd5@tardis.local> <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid> <aX2tyn9nBUEKM-SN@tardis.local> <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set> <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
 <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
X-ClientProxiedBy: LO2P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::30) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b98dc8-aa14-4da6-929f-08de610a270d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGNyR0o2N1VwUG84enRNM0EyWUlJcWJCeE9UR284L1VEdXVGbFVqeU8vWTBZ?=
 =?utf-8?B?YS9IMlF5Y0J5Z2NtZ3oxemdqMWlHUGU5ZWxkWEE2SVc0c2o4RjdSV1Z6MitO?=
 =?utf-8?B?SnREdlRlek5mVXZyMkpVT01OM09MWnJhQ3V5akZ1dnozQUM2Z2t2MTRaQUYx?=
 =?utf-8?B?Q1Q0RjRROXYwZUUyYmh0cHdzOXJLTTlGZVpLOEZoV1ZzQWVLaHpzWUN2cEx0?=
 =?utf-8?B?RVpZTXVYZ0ljV3FJZ3k1S3p0OHFzNTAyMWNmOXpKdjdSekJwbUlJa2xQdG1l?=
 =?utf-8?B?Rk4waDVKRkE2Ry83UE8xYWthOE1tUVoraGZmeHdObFNaN2pFMXM3V1RpZzJl?=
 =?utf-8?B?aWZrd0daRG0wTnVldE1HTHQxUVBLKzRWZzFEanEwMVZUMUVBSS85aXVVRXhw?=
 =?utf-8?B?UU5aL1pqZTI3UWN6V21oWWxwUUM0aERuT1BNZU9kTU1SMEEvejJtdlhOazJ5?=
 =?utf-8?B?MFBUWjVjaHJ1K1oxM1Y5OGoyUGw1Y1FUaTVIcVpROUNqNXFDYTVXRWd3YzlO?=
 =?utf-8?B?bFRFMVF0NlROdGRQZ2dTcWVJcXozZHgyaHdJRE5Dd1ZvOHo5dXh2RnQxeWxJ?=
 =?utf-8?B?dUhwMW91UVd5WnRwNXNPOGJQSStiWFlLUHZGbW9ka1NwWmhNOXlmSjZnR1JO?=
 =?utf-8?B?MzlRVG9mWFBHcjVIYTI2M2JhRTB1eFBaRFNvbzFIVzJ1WDJwTDgwNndONU4y?=
 =?utf-8?B?Sm1PMWQ2cHlMbDI5bUhwNFppLzE3RWYxVWxNemYrbU5qaDhBTEo4L0kraU83?=
 =?utf-8?B?b0V1K093bnRPU1BkZ05YN1F0aEx1Y3JicjNUUytEb0xpblFxTzdNd29uMWRK?=
 =?utf-8?B?Qkk3WlloYTVBWE1KUW8rTGMxZyt6SkwzdDB2anFlNjcvYTRPYlVNbVJ5UlhT?=
 =?utf-8?B?eGNxSFRodHdTM05uaUJGSWhVRUE0UC90M3RoaUFCdWU2ZFBnVW1aV1prWFNG?=
 =?utf-8?B?T0VxbzYrMWJEejBXKzNQZWZZdjBJdVlWZzY3cktjZ1BVdlRwak93UkdsQnBv?=
 =?utf-8?B?SW5JMStwMXBCRGZQL3NpTHdIYU13SVA5VVZRUjQ2MC93TkNjczluUWR4bUM1?=
 =?utf-8?B?V2tEQ3hReFpXNmRTbFV0T3N3a0tWajEvMFhlSTlSOEdHMUVNYTlzOGNyRFlF?=
 =?utf-8?B?WCtJQ01vWDVRN0J4ZWhpaHZ5d0dTS1dCbEJlMXdaeEkwUktFcEMzMDN3TDJ4?=
 =?utf-8?B?MThFbUpvNDdRaTEyUUwwMUlrT05NRStsY09NOUdLcy9mQVVZUjVwY2tvWXJV?=
 =?utf-8?B?S3VIK2svKytZMi96Z3Z2RWFjQTZZTWdHVzZqNy82OXF4WnN2WW95NXhKUjNi?=
 =?utf-8?B?djFtNXlSc0dkUWpseDh4ZUt1eUtBK1ZIamFxVFJjUCtjRkRuMkRQei8zY0N0?=
 =?utf-8?B?MVlXczcwd1AxbUxDOTBBWnVzUDlRb2h6d2YxM01KeTNESDd5dlFXd1Q0K050?=
 =?utf-8?B?TlhjMjVEcS90UHJnY0R2VzAwMUJFZFdkNTJYSGREQ2hyb09HWXdIYlNHQW9W?=
 =?utf-8?B?RGpoRHlsSW9SSU9rUVBsMHRXSTNhV2V6RWMycTNDVVhsTDNtRFF0ajluNXJF?=
 =?utf-8?B?ZUtyWmlERVFJRCtML3doNlhOK2V2UHVLUEd5RFZDNEpVek5vVlRKaEsyLzRT?=
 =?utf-8?B?ZDd0MVJQd2I1eXdGOW9iQUVhODExaU5EYThDbUJtcFVjbG9pWXk1UjIzOHU0?=
 =?utf-8?B?OU96SGEwYjRHNk9mYzEzUm1xaHlEa2oxZjQvMmRWZWlrNllmdnFhd3FWSDFR?=
 =?utf-8?B?eERMdHhFTFZNRkJYa1d4ZlN3NTVxWFN1SzZzWUtET0UzeGdmd3cxT2VtdXRB?=
 =?utf-8?B?eGRqaDdvUytlLzIxSnYzcVFzam83cnh1VGswc0xQckZhaXJQaWU4UjZBczZi?=
 =?utf-8?B?blhOenhsS29QZ1hRUS8wS3c3alI4d2JFNlluMkprNkhnUDJ3RndNbW5odHFY?=
 =?utf-8?B?eWFSWXRZbDI0VW80S2kyRnVEMXNIODR2ZUtSNGQwS2NFdHVFMUpaeTRrbm9T?=
 =?utf-8?B?ck9JNi9HRSttbU1zRlp5TVljRlhIN0FlNUlGemIxYVVOdlRjTlplZVArNE5r?=
 =?utf-8?B?UDEyelR0dkJkb2tOc01TcTlib3B3WGNGRnpjVmpWSnRwQUtZR3NxTDRUVVZV?=
 =?utf-8?Q?57j4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QllWNzJnZG51TE01RU9yY0JHSnd4NGdEMkZEM1ZweVpUdmc2ZUZQcEp0SjAx?=
 =?utf-8?B?UFc2MWM4Z3NtRkRraWxnNGVLQ3JUemluQktadmo3TGVMMjIvOEdMaFh0aWFy?=
 =?utf-8?B?c2pJdmdZL21WQjU5U2tMMUdqMjhzaTZ4d1hYVExTQkRpcHpmOWFQYmFWM3hk?=
 =?utf-8?B?RitadXczQlhnQm9uUTM2cnNqak1xMTA1SXkyendZWEpWVjdvNngzWWhBM3BK?=
 =?utf-8?B?WnIyMWNnRmN1dG04S2RqUExRVkh5dVpTaFc3dnVuUzg0WVlocmtwUkpQV0U1?=
 =?utf-8?B?cVp5M1BEdnI4Z1BHREM2TC9EQnl2QmttTUNBbStvM1p0QUgza2F1SXpnRjl6?=
 =?utf-8?B?c0R0aWFoeGI2cE92c2o5WUgvRnVyUFE5MEZ1YTU5ZjdlWFZiblNWckZRcjlJ?=
 =?utf-8?B?azJHQ0s4bTNpZlNNak9CeTJyYWM2a21EOWE2Wm8vM1pQa2ZOdjBJTUJCcWhK?=
 =?utf-8?B?eEplTFduSWJwalZCYUQzQVlKZk1ZamIxSHA0YTRZQVZWKzB4eEFFRVFBT2dC?=
 =?utf-8?B?QjZlTDN1dWxnZzExZFk0YmNZazNoL2l3ejZZQ2dIMXlPSllMVVhiTi9ibUts?=
 =?utf-8?B?NnlUd3VBUk9rY2FxRk0wR1NIemVveHRxbzhCZU9ZME0xMzd5eTBqQ2ZhSGE2?=
 =?utf-8?B?SXc5cWw0WE5ZeTVHUVBVUUx1OHlKWVVzV0tSREpOaTVWb3ZOcUVhM2JtQk1m?=
 =?utf-8?B?aTNGbmZ2WnJwUm9RdUlLQ2xmYjNteVAzcUNCVGNCUlo2UTlNb1RvQ05EWHlN?=
 =?utf-8?B?ZmplNDRLMnNWMElzb2tHVmhPOFhBdXhwSlNsZjlxY1ZsRW5ocWp0OG1DNHJa?=
 =?utf-8?B?b1RiQkJ0ZHZHZENrdHYvOUJ2dS9EMHMySTY4R0ZJeDZEb3E5ZFpPYTFIYnpL?=
 =?utf-8?B?azUyaUE3aHBDTkd3RkV6NWNUSEo2eGltcE9zSG1QQ2l6Wjg2MXo2elM1YjhK?=
 =?utf-8?B?am8ydjhxdHRmZWV3Wk1XZGRRd3dzMS94RnpiQUtKNnByRWlEMVdYK1Awd2pZ?=
 =?utf-8?B?SGxlYzFreGovNFh2MjRUUDk0WTh6T0ZualVLMUxOWHFwWllZWnl1S1NSMkNW?=
 =?utf-8?B?Rm02K2pIb3BST2FqNW02cy91VDdpUkM1aVMza1FVZFhQeE5pMVYxVk9PRi9i?=
 =?utf-8?B?aDEwaGpMemNzbytjZGMzNTVMZmxQM3JEbE5YMUZEbVd3M2diN2todUU4Qkxk?=
 =?utf-8?B?Ykp3QkNpTjJYYjhnRVUxWmhLUXhyeWIveEw5M1pRazZycmFyNVF6UzVPL0xv?=
 =?utf-8?B?QVVWbFNwdml5a1JUQkxQaTlBSEt0akgxUG1icnZYcExPZlNKUmQvdUpKRE1H?=
 =?utf-8?B?SjF5NHRDc1NYRkVlZ1BIbVFKdDIzajR5amwyendyaWh2RzF3bHY0UFlJWCs1?=
 =?utf-8?B?amJMbDJUMXQ3UWRFVk1JM1QzOUlaakdSWWE5SmtnbHNEMGVzZk5JQXJabFFB?=
 =?utf-8?B?RXU5Um9QcWhiTmRQTnpLZzFPVzllTkYwQVhwNitqVEdHTVgybkFnTzQ2dUxI?=
 =?utf-8?B?WDgyS1pXSVQ5elJPbW9IOGg1bHRuSlRXTTlrUE5tSWg2Y2dOVjBjYVpCNVZF?=
 =?utf-8?B?WVZoWG9oUzFxRmF3MXh3djVubTczS1JWeStXNXJ3bXVmOTdOanh4bml6bklq?=
 =?utf-8?B?MitzSnFXdStIY3Y1a0JOT3BTNmlIaGcwSFJUYkNlWlh3ZEFDT1k0TlJlenFv?=
 =?utf-8?B?OVNnZ2VoS3VhSlo5OGlXNElOLyt1Q1laSXBPUlVuajhhbmFSVE9oOWh5UTd3?=
 =?utf-8?B?R3RHb1RiZURWdEl5SFQya3Q1SXY2Zm5WT2FHY0duckxYNlNyRTBKRnFYdXZo?=
 =?utf-8?B?b2IvYm1zRkJZL3pBMm5iM3NnanFDTE1hRkRGdlUzYkhjQ2xISzFnQnpWRzIx?=
 =?utf-8?B?Y2piWnlnQlhDL09tc01CZERodzYyc2dISE41NUszNklFTmkvTWxKbm9nMS8v?=
 =?utf-8?B?S3Vlem5Mby80TmdORTdCT3hhSVBzcEp1QXcrY3NRRUExK1dOZWd6bkNqVlNH?=
 =?utf-8?B?RUZGMkdwOXFtbDVKd043YVNEd3dwZE8vUGovZzZuK0NQZlBxSDBVZi9yUThM?=
 =?utf-8?B?ZFY4Sjg1dEdocldHdE9pR1YzejEzNmdYRnphUDJ1dlgrMmxQTGhVSGZtSXpF?=
 =?utf-8?B?Q3hBRFpyclhIQllLcFRmajBuQmp0eEJLMm1KdUJ2MURpWjBydWo5aGZDYzJv?=
 =?utf-8?B?QlZMMWM3ejJROTA2dlU1OG1FVm9wWno4cEFQMWFjSXh1OS8veEVGQVNxNU4v?=
 =?utf-8?B?SnEyVS9lYWF2Qi93a2ZSV1gxYzVMbVR2ejBTK1NOWTgzaXBSVzRvdGxRNzV5?=
 =?utf-8?B?d211R2s2OStLcWcyUDFGWjV5UjZBSkdraTJ3d2l3N2VWekZKSHZ4QT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b98dc8-aa14-4da6-929f-08de610a270d
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 20:48:56.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdIhFOecYnmgMMYG981JBY2j2QcokLGAPPJUP6+rZNcQSlezA2QLy6RwLXNyuwhthw5WAdtzBgsZVlBhHSDDVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB6424
X-Rspam-User: 
X-Rspamd-Queue-Id: A174340002
X-Rspamd-Server: rspam07
X-Stat-Signature: 3uwrxgckwxfimuwr1u31dwsfm1c6phi4
X-HE-Tag: 1769892540-52096
X-HE-Meta: U2FsdGVkX18EkSg0jQp6MrKqoPTJn4OmvSTfOGqUA/Qg4YKDDWp6ICMZTqMGgLKuAQx1Ia3uHsRN69wOM58tjFRc3glOcxw4aaFNsG1GqNiC0FZat4Y5d2fSCg9wobbS73NyZIMX7pHrKmQUWR3Y7WW2QpSQvr5nTmhOuQzWL3IQ63LDXlEnaIS46ZMECmd+vvoaI4oKDB0ZujkWJq10rxp4bM3kDPg/89o7VGFqIgVuqs36O5oge3dpM7KMN9QypyKqJXaBeu20l8WBc0LMgeez2w7qCDnbPhqjmCkU0kDSyGuXMd2O/oSRK6fqdnlDsqM45qrtRxmmXMmpeXSGyq0pXlJaIIzri6WBkkNX/paGb88MjWIpVZaOWQt2kfmPqAasnGl9GOeZRr3AHd+NCglDiiFubAckWc4bFR8qBFmW3NAVYbEOgTIwLYd9jEBweZlZqHZGfNLsAtN7Cfhs5SWHKpg03n5jT2RxbSL4FzoLgLV1YuvoycKTgE52QPqTBmwzVZbsRNHEDwnwXi0rQDH68D0VfsqpVGo9oSEADwx6wbDAbgeCu1n6o3AfwiMlcgpTg2vJe/LQsQCmqp7H7RQF6OCl8AebD+5SF88gHrHhkfH6IrvEXHktPJeQyrhdNmt4dlEz7M/4XUDP/CGu7cCFq4ss3Vt86FQ3GWyRppJ4lXRxmkbRZjvjvTYfEnc88nWnEAvTSJBU9XZLLVYaXXHyz/UywhlKN8tuTotBr0x1uxJubY9hErPgZXuKTpE7aHjZYzoMtaMn5HTIf5brlw9IuW636EFbLLmG5lWOujgbRtYNv5QcmKkT37EUc4GPqyn2ywExfvdMGWD8Z8puPCxFHDe5odN/DEHjppwTjf1WXOv5WpROhb4m8mNN3QsyLtxT1X0EKtrFEq9fbsdnuORIwDO9RbEGCM/Rws+w+sHLGNcBKMRml02ZDJtJMhIYxlpQxQOrsEICPwIl1Jy
 4DY1jDs/
 uMuflUxaCksj0aVr7jHEpr/aR9S6TtbUq7+O6aDzzKLKcpHzA0nnSC57fq8MneILwLSifY4YqKue4I5PnhbjqxQPmvxLsF7yb/BBfLt1eE3WsWAfGeUv3d0B73QaNgKKL019N+YmnXMhwxkzKSDeCFt/CsH6+hHGu5oPNzuohxdvwkhsWGxrSqNHjZ+zx1b0wgSKuMzeRlbkeQTRj8hUdII7eRz2lTwhdc8NyFMePmlNqGXYrD/geCX8A9ENrAyXEqyieKEm+tMuzf/+GsodrcEJzjmrZBd/1N1DoxkByCMfyrJsD4MqG6UlPt8o+tqHuPg4CKJUDPExn7FvVc0KfBsMPc8QezRytC9qrrWZaFJHazlMrh0FUXFO1FCxLTInhiSBOrvc8j4jGlLFOg2VvxuunBSYJy4l0eKQuivX2ZzwRVrw2MA9hKbHmjka63SpyJ6pHgPgVqL/pXush5EuuYF2r8Er8GnG18kM89yqxL63AZYjetFauweSxGp3xOeaNBfID4wRwivj0ARbB+h5RKmGPnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jan 31, 2026 at 8:30 PM GMT, Andreas Hindborg wrote:
> "Gary Guo" <gary@garyguo.net> writes:
>
>> On Sat Jan 31, 2026 at 1:34 PM GMT, Andreas Hindborg wrote:
>>> "Boqun Feng" <boqun@kernel.org> writes:
>>>
>>>> On Fri, Jan 30, 2026 at 01:41:05PM -0800, Boqun Feng wrote:
>>>>> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
>>>>> [...]
>>>>> > >> In the last discussions we had on this, the conclusion was to us=
e
>>>>> > >> `volatile_copy_memory` whenever that is available, or write a vo=
latile
>>>>> > >> copy function in assembly.
>>>>> > >>
>>>>> > >> Using memcpy_{from,to}io is the latter solution. These functions=
 are
>>>>> > >> simply volatile memcpy implemented in assembly.
>>>>> > >>
>>>>> > >> There is nothing special about MMIO. These functions are name as=
 they
>>>>> > >> are because they are useful for MMIO.
>>>>> > >
>>>>> > > No. MMIO are really special. A few architectures require them to =
be accessed
>>>>> > > completely differently compared to normal memory. We also have th=
ings like
>>>>> > > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO a=
ccessor such as
>>>>> > > readb to perform access on the __iomem pointer. They should not b=
e mixed with
>>>>> > > normal memory. They must be treated as if they're from a complete=
ly separate
>>>>> > > address space.
>>>>> > >
>>>>> > > Normal memory vs DMA vs MMIO are all distinct, and this is demons=
trated by the
>>>>> > > different types of barriers needed to order things correctly for =
each type of
>>>>> > > memory region.
>>>>> > >
>>>>> > > Userspace-mapped memory (that is also mapped in the kernel space,=
 not __user) is
>>>>> > > the least special one out of these. They could practically share =
all atomic infra
>>>>> > > available for the kernel, hence the suggestion of using byte-wise=
 atomic memcpy.
>>>>> >
>>>>> > I see. I did not consider this.
>>>>> >
>>>>> > At any rate, I still don't understand why I need an atomic copy fun=
ction, or why I
>>>>> > need a byte-wise copy function. A volatile copy function should be =
fine, no?
>>>>> >
>>>>>
>>>>> but memcpy_{from,to}io() are not just volatile copy functions, they h=
ave
>>>>> additional side effects for MMIO ;-)
>>>>>
>>>>
>>>> For example, powerpc's memcpy_fromio() has eioio() in it, which we don=
't
>>>> need for normal (user -> kernel) memory copy.
>>>
>>> Ok, I see. Thanks for explaining. I was only looking at the x86
>>> implementation, which is of course not enough.
>>>
>>>>
>>>>> > And what is the exact problem in using memcpy_{from,to}io. Looking =
at
>>>>
>>>> I think the main problem of using memcpy_{from,to}io here is not that
>>>> they are not volatile memcpy (they might be), but it's because we
>>>> wouldn't use them for the same thing in C, because they are designed f=
or
>>>> memory copying between MMIO and kernel memory (RAM).
>>>>
>>>> For MMIO, as Gary mentioned, because they are different than the norma=
l
>>>> memory, special instructions or extra barriers are needed.
>>>
>>> I see, I was not aware.
>>>
>>>>
>>>> For DMA memory, it can be almost treated as external normal memory,
>>>> however, different archictures/systems/platforms may have different
>>>> requirement regarding cache coherent between CPU and devices, speciall=
y
>>>> mapping or special instructions may be needed.
>>>
>>> Cache flushing and barriers, got it.
>>>
>>>>
>>>> For __user memory, because kernel is only given a userspace address, a=
nd
>>>> userspace can lie or unmap the address while kernel accessing it,
>>>> copy_{from,to}_user() is needed to handle page faults.
>>>
>>> Just to clarify, for my use case, the page is already mapped to kernel
>>> space, and it is guaranteed to be mapped for the duration of the call
>>> where I do the copy. Also, it _may_ be a user page, but it might not
>>> always be the case.
>>
>> In that case you should also assume there might be other kernel-space us=
ers.
>> Byte-wise atomic memcpy would be best tool.
>
> Other concurrent kernel readers/writers would be a kernel bug in my use
> case. We could add this to the safety requirements.
>
>>
>>>
>>>>
>>>> Your use case (copying between userspace-mapped memory and kernel
>>>> memory) is, as Gary said, the least special here. So using
>>>> memcpy_{from,to}io() would be overkill and probably misleading.
>>>
>>> Ok, I understand.
>>>
>>>> I
>>>> suggest we use `{read,write}_volatile()` (unless I'm missing something
>>>> subtle of course), however `{read,write}_volatile()` only works on Siz=
ed
>>>> types,
>>>
>>> We can copy as u8? Or would it be more efficient to copy as a larger si=
ze?
>>
>> Byte-wise atomic means that the atomicity is restricted to byte level (h=
ence
>> it's okay to say if you read a u32 with it and does not observe an atomi=
c
>> update). It does not mean that the access needs to be byte-wise, so it's
>> perfectly fine to do a 32-bit load and it'll still be byte-wise atomic.
>
> Ah.
>
>>
>>>
>>> You suggested atomic in the other email, did you abandon that idea?
>>
>> The semantics we want is byte-wise atomic, although as a impl detail, us=
ing
>> volatile for now is all that we need.
>>
>>>
>>>> so we may have to use `bindings::memcpy()` or
>>>> core::intrinsics::volatile_copy_memory() [1]
>>>
>>> I was looking at this one, but it is unstable behind `core_intrinsics`.
>>> I was uncertain about pulling in additional unstable features. This is
>>> why I was looking for something in the C kernel to use.
>>>
>>> I think `bindings::memcpy` is not guaranteed to be implemented as inlin=
e
>>> assembly, so it may not have volatile semantics?
>>
>> In absence of full language LTO as we have today, it'll be fine (in prac=
tice).
>> Unlike C, if you reference a symbol called "memcpy", it won't be treated=
 as
>> special and get turned into non-volatile memcpy.
>>
>> If the volatile memcpy intrinsics is stable, then we can switch to use t=
hat.
>
> Got it, this aligns with what Boqun is writing. Let's go for that.
>
> It also looks like memcpy is implemented in assembly for arm, arm32,
> x86_64. Which would exempt it from LTO. Not sure about 32bit x86 though.
> It defers to `__memcpy`. I could not figure out what that resolves to.
> Is it from the compiler?

I think it's the one in arch/x86/include/asm/string_32.h? That is also inli=
ne
assembly.

There's no need to worry about if things can be optimized wrongly. I haven'=
t
looked at the current defence against LTO when the code is implemented in C=
, but
As Boqun pointed out, the `memcpy` and `memmove` symbols are assumed to hav=
e
volatile semantics anyway. So the issue is not unique to Rust (also, we're
immune at the moment as there's no linker-plugin LTO support for Rust).

Ultimately, `volatile_copy_nonoverlapping_memory` is translated to `memcpy`
(similarly, `volatile_copy_memory` is `memmove`). The benefit of the intrin=
sics
is that if the size is fixed, it can be optimized a single volatile load/st=
ore
by LLVM.

Best,
Gary

>
>
> Best regards,
> Andreas Hindborg



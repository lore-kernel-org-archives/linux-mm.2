Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B371AE6BF1D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1229C6B0005; Fri, 30 Jan 2026 10:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5F86B0089; Fri, 30 Jan 2026 10:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95506B008A; Fri, 30 Jan 2026 10:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D44466B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:05:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74B1BD4B46
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:05:02 +0000 (UTC)
X-FDA: 84388952844.29.E90E1EF
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021122.outbound.protection.outlook.com [52.101.95.122])
	by imf22.hostedemail.com (Postfix) with ESMTP id 759E1C0007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:04:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=wHUKEu01;
	spf=pass (imf22.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.122 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769785499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FC9+vqeB+Qi8sb/gdPiq4ITMSyPN32X/nFM7DN8B20=;
	b=4jMARn1QMXx3lhy20RY6bKMDOBf6LywtG1HF/j+lgrtQiNWRv3ad0DoQqCfIF0OvAP69yz
	wFKVATFJPq3lmS6VWiUKs3CNldRl4S9ta9qeLSE6p3C+6bKrdvVtNMZc4+UVxaXX6pdXSP
	lSfL3RvRL2Fqgx/fScNaBoXBej50EOk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=wHUKEu01;
	spf=pass (imf22.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.122 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769785499; a=rsa-sha256;
	cv=pass;
	b=DGBoqj9weuG8PhSrT2QIRF9t/t04S8/eGgDneZr66I3VbhQsPWeSxrvjB1Xi8AQVrL/hIa
	Nj98W6UMMjhrqcsAgnIWIIKXKbJpNtEJNQ4K8PNJqXRYUlOSUsaclfy1zS0s2WwkYUExhu
	NeK/XA9ueW+2UOBtbbCtPHf8PuEHK5Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TtIQxZm5l/qBPQQV6pqZUNXqmeF70gBmvgk9qtAeQ/v+AASzh6HR9+QC52zoDtBiX1civM0XV34t8IFjcwUU0tiTisN8Eza++9NNR5XfLoRarQdFCymT9tRH9vvd5uoH/gg7dpZOth8cen4rmSqmsbkbynO8JwsMt2EaobEDhutNMlWVfKMyOlprgZ7tzf2aM2d3HaF0edk9f85QOZBI3DgPSzkJrvD1r1QOG84LD/XLodeuAbwI84qkOVGnVbZgTSnvbkjTlmFgawE2iXon+nDQFZBhUbmYvbQJZw7VlX31fI1x6hBddMndmQUTdNsJ64Kg0FryH5tQTBWkCFgGWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FC9+vqeB+Qi8sb/gdPiq4ITMSyPN32X/nFM7DN8B20=;
 b=s2dqahZT0rv63STQxLBc/Iq7nAwRy+ChzbdPnIlHWqySqcQ0wzm+tvt5ZfTn0ot71UrFZ6I/Skr53Tk+dFy/IlSRZncE42RWie+sfTP6q4iZ+MncadB/8xkpU6XoA8N0EK1Iv5iIaL9fNzrXPpr1LBN2vT2nhxVMl4SbnU4pTojtL9DYO/yX0BwQn0TmTfZ2tGA2C0oQTj2O245g1G3p9U3f6vIVsSo86rGnxL8SLGqEyM/6IfKW/cL4t/9KjCCEsHUdDjgoCmA/lwQFvO1fgYFysS1Xo5QrCz17j2EGH3/2WB9sIGuuFWCzUL6ldrD8DbItySLcv/R/yk+lwGU3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FC9+vqeB+Qi8sb/gdPiq4ITMSyPN32X/nFM7DN8B20=;
 b=wHUKEu016zf0pIbRMqAdCY8W4d//3+1wYZSalWh0fWA1xpMY3Mecd9+tP7ndiKWuEfS8m6RCHbTgri0EENfBEgsZXXSFojkiEzIqqjN9rO9CBuCifGKpi09UXcJuwkqr54nAsXVWHbYSzbtlGLhlVr6GjJMHnOZnOwoiUF57xYo=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO6P265MB6332.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.9; Fri, 30 Jan
 2026 15:04:55 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 15:04:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Jan 2026 15:04:54 +0000
Message-Id: <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
Cc: <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich"
 <dakr@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid> <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net> <877bszrz37.fsf@t14s.mail-host-address-is-not-set> <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid> <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net> <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
X-ClientProxiedBy: LO4P123CA0412.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::21) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO6P265MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3f6815-9ba8-4205-293f-08de6010ed5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZE1XNnBqQjg3TUQyYWw0bmRneGdpa1pob3U3QXNkWWlGU2Y2OU15akZsM2xt?=
 =?utf-8?B?SmxGS1dGaGZIdlJyS0l5cHZvdXdaaVZrd3dIemg2bTdKWTJLL0psTmtTMER0?=
 =?utf-8?B?YXZ2ZzJraGlpVndFTDlpb0luOFBaaFhrTTBueTRFa0JWM3llMTl2Rlp3bHpo?=
 =?utf-8?B?T1ZoRk85bWZTR0NDeENJaUZHMjQrdjBPYTlzRmpHL1dxQlhFMjk0V3dLck5o?=
 =?utf-8?B?MjRwZktpS1FQL1A4Vm1kZHhKNnhZSWJ2UzZVa3JIYlRhY0JLQjhxbngxdlo3?=
 =?utf-8?B?Mm9YOUszanJHZTQwYVc4Sm5Ubm5KeTQ5endlMGsxQjRVSHlOTEs2S3k3Qmcy?=
 =?utf-8?B?a3ZkaWszcXFxSktLQ3hLZVd6ckdUa29CVGsxYTFTcVJxVEt5aHVrWndqK2I4?=
 =?utf-8?B?ZUJXTnBtUzJXcHFMMkJxSDhWeUd1V3JXSlhEd1QwWXJHcE9aK0pqUHpyUWtZ?=
 =?utf-8?B?UVp5dVA1WERWSSsvM1RoR3FtNW1FZGtzRHB5dGlJdGFWZy84SHRYQ2ltNmp0?=
 =?utf-8?B?NWpyWVZ6cVJIVnowdVNwMVAwYVJSODFyVjNod3F1TTRqMU1rTFlQSkl6RE5r?=
 =?utf-8?B?d0FpN3hSUnQwOXZ0eDZWQ1NJbVFqWHBYNzl3YkVxM3lhWHhNL2czWXlDZlNw?=
 =?utf-8?B?ODR4aE5jOTBCdnhiQWVmaVhoNG5WdjZuK0hqVHpZRnVSYWtFMWZjZmtnMjJ0?=
 =?utf-8?B?UjdVQ1VtUHhvUmNqTkJETzZOalhmaEg1Vno4dDNKMjZGRHFmemFXUStkbWk3?=
 =?utf-8?B?NFpSTVFYbExMalJtOVMxTnJjd1lML1NUbkxUdXhESXVYSGpHdGRSallGQWY3?=
 =?utf-8?B?elRxWGYzOWJIV05PNmd1aFhkWnVMY2NVdjNRZlFicUJtK3YwMDBXWmIvMFZ5?=
 =?utf-8?B?OW43SXR5RXYxbmFNdlcweTVQZ2w5MlBITW5rT25XNk82akU0ejFtRVowbzJ0?=
 =?utf-8?B?QWJkUk42WlNWSStyUlQvRTBwU3FkeDc5RzdwZUtjRHNvK2Y5ZmhaSWMxTHRX?=
 =?utf-8?B?OXBDM2VQU0FHNFd1VFd6MUpzSTVZeHlLSFc2QmlXd2MyWVlNWVI5b05DZXZY?=
 =?utf-8?B?SjBJOW95eU9NcWRpYklrcDJnd3NCVXBkUVMxb1Q5RCtFTXB3bWRwZitSUEhw?=
 =?utf-8?B?UFpRWm9yd0NTcVNjbFVZY2tCSWZzQlF6RWh5dE0vYXloMGtnZDVvRjhValFM?=
 =?utf-8?B?SEJNOG1kcDArQzkrSGk1K3NiSXlOM2hNeEc1YjkyanhyV0RZTkVmLzhDVGhp?=
 =?utf-8?B?UnBDMDhpbFptNEdnNnNWRmh0cFhvcm1Da0JjZTJaMUYvbHp6YjFaZE9ldHIx?=
 =?utf-8?B?YmJWZ1IwR0k4anlWVEE2WnVGT01CdnJ4V05GazFMcU1FSFVic3pTZlYxaGl6?=
 =?utf-8?B?UE9ESlQ1R2tja2h0MU1qUmVVR1VHVFczUnU3YnEyZ0E0RDk5YTJpTEI3Nm5o?=
 =?utf-8?B?UGJxcXBOTDgwck4rWkJKOEZTL0JmWENaZFJBNWN5TnJGQkdvalQ0QnBlL21R?=
 =?utf-8?B?QWhUVmVCbjBjMmNPSlNaUTRvRXBWcGoxMUN1OStiWG94aE5ZYjNuUGFTa1Rs?=
 =?utf-8?B?cTBhZ0lRZkx0UGVtU3krNHRuODhYUktNV0tEaHBjQ3lSZHVVOXlrS3E0L3lR?=
 =?utf-8?B?cVJ6REV0SFM5T3lCVyszWk8vckhrZWtIUHNyVjBxb1BTbVhudlc0T09qckxi?=
 =?utf-8?B?c1hqVjk1TnN1WnBvWXBydGx1YmZWeWFvL1FYdkZRMXl0ejRnRjdQN2ZWTWJx?=
 =?utf-8?B?eUZYWlNVSkNwWDU0ak0vNVJyTXhRdHZiakg0TEF1MnlaN1NmWkduWFZWcnF5?=
 =?utf-8?B?eTVTRFR6UTNqTEcwU2ZRelFOVTczRFpsSThPWnlMc1FTNWI5SzErKy9GZ0h6?=
 =?utf-8?B?b2pqWXhpQ09yakhPZ2dJM3hPczhWVVNLdHExZlFKZlNpNDBTNjJ1bzdRUVY0?=
 =?utf-8?B?dE5BVSs5ZWNHMlFIbHpzeWFmSTdtQ2RaUVcwWlRqaTMxYnMxU1NvV1hYY3RN?=
 =?utf-8?B?RGpvWXJIODZlZDdWeXZGbzh2eVYvcWFxVy9tdjN4RHk5YXRjTUdhWmphcm1U?=
 =?utf-8?B?T21KSm1pcGNMYjR0Y2JMUU1udHBEdkQwOWtkalZ5bnRGSVAzZFB0ODBveUhx?=
 =?utf-8?B?S2Q0SHY3TTdsU3pNVXljcitaNXYweFVleG5xczBuQjBjQ3Y1ZTdBRUNDSnNF?=
 =?utf-8?B?d1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXdIazBZTy9GeHR1dm9lVEN5U1AvUXlERmRkQitQT1JudE9TUXBKNzRrdlVo?=
 =?utf-8?B?d3A4bS9ETWR0ak9yaVpNNWhwQ2ZMSzVKTkRObjVtU0JidTZJZG9VeHJUa2Jx?=
 =?utf-8?B?MkJBNWFtMGF1c0l4YXFpSVg4M1FRQ2o5Y1FOL3lEYVVGbyt0c1FiR2VnRCt6?=
 =?utf-8?B?bTBNNkNGVEE1TWJtU1FRMTZ2bHZLYUN0K0Q0QnRIbnQvUjFUa0lVS3E3ek4z?=
 =?utf-8?B?YUtOOEtKNnJpcHJJajRBU0dGbEZZaUh4TFRnak40RkNIRDNrZVpNV1Z6Wk4y?=
 =?utf-8?B?b1RyTVArZGR4SUxtWHZDSHFBOWcxVVJQMU1GYzh4di9iSzFqSzl2dUliMGkv?=
 =?utf-8?B?YURha2hTQnVvaVI3Wlg4KzI3akJiWjNUcDI3WnZ5WnNHa2RkeTR5c1A4cUdn?=
 =?utf-8?B?d0taV3hPZkpqaEdQZUtqSHFNTWw4Q2k5cmlDeHJMUDJIeExtMjczNjlYQTBC?=
 =?utf-8?B?T2trbExzZXhoVXJSY3dmaVh0b3I4Q0R3S1VLQVJ3WlR5dTJxcitUV2thT043?=
 =?utf-8?B?OTUxRDBoU0QvZitSaSt1SVFiQTY2UElGNGp6Q05jNlBNdnM3b3RWc0dneWpD?=
 =?utf-8?B?Q2ZEMGxUUUoyeUxkRkh0OFRWUERnbzF1SkpWSlRDTkwyRGw4V2lNVjF0QkYz?=
 =?utf-8?B?RlB3Y0tjVjNuUXNaNUJ6OXBORWdaaWxzdUo0WFRRcTUwT2QvWVpUdjlzYU5l?=
 =?utf-8?B?UFRiWmlETURNdUcvNTdBZzZRVW5UVXkwZVJvTnp2Ym02SGhETjhGZkkxVyt3?=
 =?utf-8?B?aW9Pa0NrNmJSaFFNQnA5YmI3MVdwTk4xMU9OQmQrd1NUOW10Z3dzbEpsNGJM?=
 =?utf-8?B?TzNSdjRXdXRPbXdNQy9yY255eXFXL0ZkT3J0T2JZalFsQlplbWplc0VtSi9a?=
 =?utf-8?B?NUJ5RmdvKzEvL1A1cUxPMzhOeFdsSlRXTVNmN0hLZUM4ejFxbFpvcHdtaG0v?=
 =?utf-8?B?SFhMVW8rbmswQ1BteGtOOXl1anVrS0VqTkJjaGRCUGVycENGN1M5cjhzbDBv?=
 =?utf-8?B?Ui9OS2hVLzBYRE9VRmNLM282Q3Z0bDJFWFFoeWhQZTJxTVpIdWdXSUtqNnZn?=
 =?utf-8?B?OHdHUGU1WkV1QzVuRVcrREJXWThza21mR2VQbHROTjMvb0t1OEZTY1A2UEZy?=
 =?utf-8?B?ZllvU1pqQXFEMExyb1E4dHI2ZTRjbUFQS3BnRm93c2NFVm1LOEtCYnRyMC9z?=
 =?utf-8?B?c2ljU0NvSWlXWVhlOTFEWVAvQzdVaFVUR0t1NGhEKy9LOFR1VTdSZURTT2Zz?=
 =?utf-8?B?V0cvcUgzSUt5Tzg4RUFMNktxbTdsM211RytNUEV4T1A3M3BwQjNyVnRLZ09E?=
 =?utf-8?B?TDBZR1c3UjVZN2U2VEdVUGtZWXZJRjdzL0hOSTVHQUFuaHlGVzgxNTgxQVJ6?=
 =?utf-8?B?RkdSMVpWcHdMTTFseC94WDd1eVpQVVNwd0tORGl5dldtOTQvMmVTNkZ0TUcv?=
 =?utf-8?B?cWNLZEtDVkVFTkRzRXJLVVJKSWtYckpuYVg2TzVGQkUzTU5FYkRoOE9MOUVp?=
 =?utf-8?B?eDV4T24rUDlPYTRwVGw4MUxkZ05QTk1sVjEwUlpsdk5ucXROdUJOZzZHY0dt?=
 =?utf-8?B?N0lpMVNyNWpsd3pqaGc1alh1VjZzWVZ2UEIxZWtaTVJXN2VPbnZWV3E3NVVE?=
 =?utf-8?B?SG1PNVZxYmd0VUlHZUtJc3lBSEozQUlKQU1rTGZEZ1czbEcySER5aEdwRzRX?=
 =?utf-8?B?TnRTMDlpTWNnbEM0dmFFZTdYMHlCUFY2a1g5aktqbUFtV0hxWU5mRzVqd2V4?=
 =?utf-8?B?MXcyanByVXNBQUUzK1FZRlRlemlIMkFlL1p5bnI4cDdEL1ZPZHVwWUZwQ0xB?=
 =?utf-8?B?ME9IQktkeUhqaXBIckRTK3M5aDJURUtYWm5FV1JTbUMxNXBwdndwR01DaUFq?=
 =?utf-8?B?SFd5UWZBT3I0Vy9GdXJnNUtoVDhKL3piWlU3K2p5akdWeFV0ZmRvV2p6cGJp?=
 =?utf-8?B?dzRPekhXb09UNzh6OE9KeGcyMGhST0VvblhUUUdxL3RNOHlodjNqNldlek5B?=
 =?utf-8?B?bmtrZU9nYU1VN1l0eGJaSkN5WTZKV0ZLT2dqWVc0OXU3cE1kTFZGK21CcVo2?=
 =?utf-8?B?Y0FlOWhVd3VQVEpHWFVGVUlLaXZBKzhtWTBTMExNd3ViY21ITkJzTjgxRE9x?=
 =?utf-8?B?NGNRZHJjV0JLUWs1cnlTNWNNUVpZbyt0T3pRVy81ZUI2MDYya0RuWkFKQVNT?=
 =?utf-8?B?aC9iQk1iSEtQS3JkL0JRdE9GZEc5OVlaOURnbUk0bXQ1dmlRMVFVVlYyRE82?=
 =?utf-8?B?VEwwOGpaTTV3QkxwZ0V2cmlDSFlRa0x3cmRyT096cmUxaXNHOWlWajQxOUFH?=
 =?utf-8?Q?uIcUmrFjmdqNkBWh/r?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3f6815-9ba8-4205-293f-08de6010ed5b
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 15:04:55.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Vq0HtIHEk7lSO1pBdR+80It2k63GZHt6LfgYUajXGU7zmFF64Do4a7DtgzB1RGsDXRvu99kONv6LJ0jiIQ+qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB6332
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 759E1C0007
X-Stat-Signature: k5bb4r6udshu9yf538t8f11unxywsgrz
X-Rspam-User: 
X-HE-Tag: 1769785499-911995
X-HE-Meta: U2FsdGVkX1/d8luk6ACmSyB+aK4jfvkCJhYXQ4e7n+arPwTtp7KxY42i0bzNFzrdw/l+5se2/YsZZi3rB9k/TiljFyqihLKqG3BCsTqjE1BDcbq0cKQoAhFZD435kfye5s0DFOodGJ6QMrRWinS/isQeNOhxjZVpYCE4K6zVDcx1mDLNgM/5kyyRBbufxx/ily7u84lH/CtTc8xaJeqeSakBV8n+BY0SwhOr6EJo6H4SBkLTZfJCZlejefhhbmNtiaTrvt7uKy7ibdz/de7VeqOjDWOpWjIfR1dD1/RCv4wi7H7VtBVutH0tFF9qHqwZlTe+pyK1bHhMnKrqR5vSAdR9cMqvj5rykgOmljGv5nMowmTaKNQAc90KLW5AKpuIKhCbiDvGz0vGpxuku0kPmEev5PYe31BCf0mF5WjDbm/aLKEhPqtPXzHt5Op+P6k3hxHfDYj+vfelnVuK0PZD+SoxjIj9SYi23GmWsRMbRS3k5gD4TK6YfkTWmWNy+26UZs6mPQ80cIZLccsGSmAI0ubckMN8+hZlvrSDNIjtn5ZT6KPbdAK8RQ3+fIYJNZyVyWEIk/ulyvec7X0/HCsjdODDRnk0ZHZP7qUFifAe5u6HfI5DRa3XLdnD57yk8k8992c9ZpKYLxqlsX+TOg/LqHt+u9lR9sf+kMu4PDRFf2c5jKfJQ7zFe2irHP0DbVcSMmY2fldXACI6M6fbdl0LrROpFDqn+eA7XvnITSbX2t7+P8qU9h+f66qyaFE7VNcNgZkI0TIyzbnA8u2dhXvyWKqN62zwAizUe0NMl8VP1JsgWgeB4jR2577NDPyCM2UYkq7icSO1MiWsQTyl0Rtfxytp0w9NQe60ladSFKHrZGCvYT1/z0tnS84d+LfI9G5IrvdLBlU3imCK/w49sHB43IhBJTEgVD9BjhfeUm9w8OkogMJMLWg4b3QvRLtZJdl+ktRXX1VCbNsj5GCvmrS
 5CBNKJqb
 NOfgTPIFVlwRgydIqurnIkbRsLmIE8MsLmx5KJFIEOhSOAEqip5J2V+EG6p8UmE6Rhe0t4Lg9kx5pek0WvqxHpViKc0Y977EM/j5Qkadfdxp2vkNj/rDcLY3fqHuCtX1Vendbh167R0gogv5Hjnu7f6fn08Mmv7wtS/JxC1dT1qn6DXQk+hnGbP7TQh95qrZq1sh+2PiyPYXRl0oI1h+GxiuSc37JDj1pIDurV20NF7ymdpiS5OoT1GxpsR6f0gquiCeAbCKjK50MNRF/kMiMygDZXNU5e6gaPspAOM0Zk4XmWkuP7maiRiubXJzZfAk6le25bsY4+eGZqVDyDEeIchB1ehCWYHuJ9Pmd7hrf7a92cpnJ7+bVlopTloUASlemONg9mm8aNyhsFV+7+zuB94JeOaCDMXESrk5eJM108jR9l9UZEI8b8obL5K3pGpZx7bVDeuPrVH6dru6NxHbI4u0LF4kyOSOAMMfBouQSLJj2syAPG5hP82JYYDIbFueBdhPPWEmPyP6Nz3eTAnRIxr1NZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jan 30, 2026 at 2:42 PM GMT, Andreas Hindborg wrote:
> "Gary Guo" <gary@garyguo.net> writes:
>
>> On Fri Jan 30, 2026 at 1:48 PM GMT, Andreas Hindborg wrote:
>>> "Gary Guo" <gary@garyguo.net> writes:
>>>
>>>> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>>>>> When copying data from buffers that are mapped to user space, or from
>>>>> buffers that are used for dma, it is impossible to guarantee absence =
of
>>>>> concurrent memory operations on those buffers. Copying data to/from `=
Page`
>>>>> from/to these buffers would be undefined behavior if regular memcpy
>>>>> operations are used.
>>>>>
>>>>> The operation can be made well defined, if the buffers that potential=
ly
>>>>> observe racy operations can be said to exist outside of any Rust
>>>>> allocation. For this to be true, the kernel must only interact with t=
he
>>>>> buffers using raw volatile reads and writes.
>>>>>
>>>>> Add methods on `Page` to read and write the contents using volatile
>>>>> operations.
>>>>>
>>>>> Also improve clarity by specifying additional requirements on
>>>>> `read_raw`/`write_raw` methods regarding concurrent operations on inv=
olved
>>>>> buffers.
>>>>>
>>>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>>>> ---
>>>>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>>>>>  1 file changed, 53 insertions(+)
>>>>>
>>>>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>>>>> index 432fc0297d4a8..6568a0d3b3baa 100644
>>>>> --- a/rust/kernel/page.rs
>>>>> +++ b/rust/kernel/page.rs
>>>>> @@ -7,6 +7,7 @@
>>>>>      bindings,
>>>>>      error::code::*,
>>>>>      error::Result,
>>>>> +    ffi::c_void,
>>>>>      uaccess::UserSliceReader,
>>>>>  };
>>>>>  use core::{
>>>>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>>>>      /// # Safety
>>>>>      ///
>>>>>      /// * Callers must ensure that `dst` is valid for writing `len` =
bytes.
>>>>> +    /// * Callers must ensure that there are no other concurrent rea=
ds or writes to/from the
>>>>> +    ///   destination memory region.
>>>>>      /// * Callers must ensure that this call does not race with a wr=
ite to the same page that
>>>>>      ///   overlaps with this read.
>>>>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: =
usize) -> Result {
>>>>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offs=
et: usize, len: usize) -> Result
>>>>>          })
>>>>>      }
>>>>>
>>>>> +    /// Maps the page and reads from it into the given IO memory reg=
ion using volatile memory
>>>>> +    /// operations.
>>>>> +    ///
>>>>> +    /// This method will perform bounds checks on the page offset. I=
f `offset .. offset+len` goes
>>>>> +    /// outside of the page, then this call returns [`EINVAL`].
>>>>> +    ///
>>>>> +    /// # Safety
>>>>> +    /// Callers must ensure that:
>>>>> +    ///
>>>>> +    /// * The destination memory region is outside of any Rust memor=
y allocation.
>>>>> +    /// * The destination memory region is writable.
>>>>> +    /// * This call does not race with a write to the same source pa=
ge that overlaps with this read.
>>>>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, =
len: usize) -> Result {
>>>>> +        self.with_pointer_into_page(offset, len, move |src| {
>>>>> +            // SAFETY: If `with_pointer_into_page` calls into this c=
losure, then
>>>>> +            // it has performed a bounds check and guarantees that `=
src` is
>>>>> +            // valid for `len` bytes.
>>>>> +            //
>>>>> +            // There caller guarantees that there is no data race at=
 the source.
>>>>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src=
.cast::<c_void>(), len) };
>>>>
>>>> I feel that this should be a generic utility that integrates with our =
IO infra
>>>> that allows you to copy/from IO to a slice.
>>>
>>> While that might also be useful, for my particular use case I am copyin=
g
>>> between two pages. One is mapped from user space, the other one is
>>> allocated by a driver. No slices involved. Pasting for reference [1]:
>>
>> Then what you need is a byte-wise atomic memcpy, not memcpy_{from,to}io.
>
> Can you elaborate on how you get to this requirement?

Memory that is possibly mapped into userspace is still normal memory, it is=
 not
I/O. I/O accessors (and IO memcpy) are specifically used for MMIO, and you
should not be using them for userspace memory.

For memory that can be mutated from userspace you can just treat them as a
potentially concurrent accessor hence all accesses should be using atomic. =
When
tearing is acceptable, byte-wise atomic is sufficient.

Best,
Gary

>
>
> Best regards,
> Andreas Hindborg



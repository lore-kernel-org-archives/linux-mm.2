Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57634F8E4A1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DB36B0005; Thu, 16 Apr 2026 23:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE9F6B0089; Thu, 16 Apr 2026 23:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD186B008A; Thu, 16 Apr 2026 23:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3546B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:18:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 426605BDA4
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:18:49 +0000 (UTC)
X-FDA: 84666590778.17.B416DA7
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D7CC180005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:18:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AUPogo1F;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of acourbot@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776395926; a=rsa-sha256;
	cv=pass;
	b=6gCCbjBVqN2QxfXOyjHelAOuBZj8Tsh7rXqe2yY2KQ/jW/OFxGIHV53zVMZdme5YS9HHsB
	dZFR/XJL9UwCVozoUsSfLjiV6CotdlYj4f2xH2WUmMEtFz6xXtqxxWSJhXOaqf0PygeCVA
	IZ1/Wt9A2kIludqoYDgs8Zxlz5I9GPY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AUPogo1F;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of acourbot@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776395926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epvfI59ZmSD5sG89/dR5C29OhUomoJqjjSbqvuMWLCQ=;
	b=IRJnQl0RGizs2l7ZVR/7oMlnqjry7qokwTYqx2VgQtZtb8Ooyaxyfmwg4ridlvU6Q86fc/
	J4/Yk7iR9D42gbmmk9Vtgc/FjalLjyYK/alU0yrtWFT+st7ojVwMLxxpoDNepW9RwpVB46
	aj6OhX/vuxk3kKDK2Hqq+pARixMsUf0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nd7B+0vVa/ODtVQI9lOuXpIfYkm9BtDBlxianFOVBxDBXo3tSDCLOMmH5uaP4F6PafY5u1v3znqkF2ZmpkrHKlCDmzAN8KIJh58lU0RrRe1dgxgF1qiCyAzW8QCqgUuA653P2s7ssDxfWT0MHMMLtmXpy59647R1lyMI3TZdgwwBowgtIFjs5ZDmOZchjCE29rWsux6pncZBwDDgR8AFjEAzVqrktvY2Ax4EyMBAb2i3z+mvz92UFF+O3Ll+Nya6cK+pngk9UvDSDDTQxzUV/OPPbgu07Xlbdiisywl10DocXTUKPst62jnNi/j54FV1Aodinm0pxn0Utd2jGKBOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epvfI59ZmSD5sG89/dR5C29OhUomoJqjjSbqvuMWLCQ=;
 b=AOOAuSLOrkcbA/dn4t/5F5ZQ+ZhMDvuMejGf9/6Yr48lQd+WkvzjnA+Auvp8mEJgNgz7pWsJ9nw1PbUDI31d0rTeQqQFC6ck7znVASyU0Kg8fWExisYU9h2Pj6kxfvnAa9YmQ4Y6dAxLLbQ22OQEDT+VPADsejSYxXPBDpK+m4+PRyuZiO+cPJsLslpj5eogDTK/ZI1TpiKffcPWPJ1BBWpcoY0WVyHO7k7hG3QFoR7hlETXboxVpdEO25RGeaMtZudFFaOFPZETW3dK+3rOMufm6Wa3YCFfsehnIwVJ67Y/WGyznWT8y10vjRgdqohPOyKZTcYCbo06K4Wz6nRyzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epvfI59ZmSD5sG89/dR5C29OhUomoJqjjSbqvuMWLCQ=;
 b=AUPogo1FLZsySSJ1xrgHkuWNkrDiNrvFZ31EpwPHLFAh0m9HupzyBLrPlqwNz3e0P4cpynoyx1q1SCzIu20BQQTZyb1LAVD47FVKEbdaqDO0Std49RGERXJjv5yE7s4IfVt0toVXkMIfEE1bopPTM0GyZrWoIBDLujybadSwzi1EYcbkKLpjLwrA3ms5FST4w/ICel9d1WoFerF/f4aV5Be50tRHzxXFGdkAbAjxsWpCKg+dj+Dr9VAXmDAR6scBOIRBz5qvVERJmhTGHuB+PjJpe2go+Z0b/nyM1La9vDBLqqyEORuJHv+wofYoF/m9kN4WO3xgyEReQYT+GkoZEg==
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by IA1PR12MB8288.namprd12.prod.outlook.com (2603:10b6:208:3fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Fri, 17 Apr
 2026 03:18:40 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 03:18:40 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Apr 2026 12:18:36 +0900
Message-Id: <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Tamir Duberstein" <tamird@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Alvin Sun" <alvin.sun@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
X-ClientProxiedBy: TY1PR01CA0197.jpnprd01.prod.outlook.com (2603:1096:403::27)
 To CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|IA1PR12MB8288:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1fae91-4e9a-42db-e1db-08de9c3005e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Fhmnq7nBcywO+C0zBHxo0CQqBbCRq/96HZpugr3DaP1ZsNKsnkgPc2cFt16fcP4ou1ChdEdby3+lN39rkV/rqpsboe1tRKnDcMx/AWF3JzGAFslbpnCo9Emlre1Cf99xaivkCr+qcwtHv9InXvsdtqAiW7sOdIgM872zE0bcPZItizV/3+2tokCkdVDVPSj4HL2p4JVHxJhChtcintP/LTlaa1rAgFrHM+18qQkGlwo44qLZ0jun9iU4tA3xNgefjpGQfIDjZ330dqxiRNP6W443br+fu+FE1F3ZE/tYhZb33RK8VYRnYpW9OltR4iPoJ/5IbsJJug6Yb/RY+DZ/eDfbXgLaIHaczAQqfsHRcFr0RVWIPD7CGX+TldO4PzyBVugky93WGPh1wq66t6uPkanK3bCFjek3VKXswVe+yZPO1xbz4YPFIA+y/OTHPkQyjuSf9GQ/KYWKTMBiywvjFdoYgDY1ZN2wPgAJQ6JucllM5djs5hsbCnYwFHJQ/QZ8VFZMIJPH3EIaAG4IdtTmkiadsHAEyKaahVZiwnVQpGGRZvi5wsmTXiOAYiu8vp21Tu/bBgRHIT4mQ2R3mxJ8lKNQvaDPnHx3u0RkXOnJCou0a4btUPttC/s0w4w2EFg+Na8X2f/MkzPqz5ADA1pv+Fg57l1v1LUnHM9gW8IWNRgIwoyvyefnZeOU9vT04JfaeTqxm+9vOCJq3q4Jb0Vqc51wPnto+PAo948U6wcbPdk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXc1anRFR0VDTzFDL3BzUHQvVGk0VEVMZWdpRFQwbVpuOHdwQVpISzNmbkZu?=
 =?utf-8?B?TzdYeXR4VUhJNGZ4T2xZZGZXNUh3QnJCK3Z4NEFtVFNjaEZDa1grSWZaNWh5?=
 =?utf-8?B?MVp3NG12VjNSK21ISVNhLzVPZlJDbDB3a3FUYjFmMlcxZ1hxMERSTmlwM296?=
 =?utf-8?B?aGtBOEJicDRlRXd2dEtJTmg2amdRdHVGU3VVa2lFbEhIdUd6emhzeEYrbEQ4?=
 =?utf-8?B?TmY5TWRMbmhHZTNpblRvUnRoc3lxTENqd2JEazJmcmllOGpFcnNDMGZja0Rq?=
 =?utf-8?B?MTNQUnU2ckdCUERFMk01Qjl3cmVRVDUvZkZMNk5tWFBLM2hnVEJqeTRlWGND?=
 =?utf-8?B?YVgxNSt4Ry9iMDJyeWhJSHdaRk8rTW1HUzVoSnMydVp3eWpBN2tYZXUzZmVV?=
 =?utf-8?B?N09SNWlCWjV6engrQ3N0ak1HOUxYQ0YvVzJnQU9lVXAwS2pxalc2dG0xQml3?=
 =?utf-8?B?cFpnTGZWQVdxOUxyZVhQcWZlVzFWYnIvQTNTQUM2Q2RheXR6VzZuYy8weHg3?=
 =?utf-8?B?cW02OElScU1LVCtKd0NKZlNVOTMwcjhYT0UwT2IwY0UzaWxHQ2ZIbDBJSEV6?=
 =?utf-8?B?YWlGcjJ6akh6S1hvcUJ3ak9RRFFpY2FGWWNlUnZ2L3d2Sm1CUXJBdFhOemN3?=
 =?utf-8?B?UTZGaDE1YjVaNFFTQTlCVmIreUZveEpCM0krQjdPWW9qVFBOZUZqbHoreGxw?=
 =?utf-8?B?WEhBdEhiSFZTdUxJTFB0elFhSWVnR0lTNEZuVGM0bEtsaHRvVXZJVHRZbk1h?=
 =?utf-8?B?K3EzdmNSZXRHMEZxRGFSN2drVWJ0NXM4NXRhNGcweEp3NGRkMDN6bklxaGhp?=
 =?utf-8?B?eXdxdHRVTnlTU2kybWdXaUlGREtkd0VMZjRwRGNsTTg0NUlPaFJjVGs0TnU1?=
 =?utf-8?B?T2VaMDdyRUliMm9hamJWVHVrdmUrUW9YWVh5M2lFQjFPYXVpUERyYVpRQm00?=
 =?utf-8?B?NnEwYWdEQzJLOHhTU1U1MWxHWG9tWWJCdkRucWJWQXZHZGx4cFNlNkZtOE5Z?=
 =?utf-8?B?dHJKR3FYUnM5UkJNblB6VjU4TFVwcjBkVXYxaFJDTVFSeHIzRlROVldjWkpP?=
 =?utf-8?B?enZYemQrMjZKanhDVktpeENFSWtpNzBIV0pxZmptZkRJSXg2ZFlhSTBGeFhD?=
 =?utf-8?B?MGZCK3IzVjlHQlBWUTViSlBKRU9tcm82SUdkM25NU2J4ak1SUktTbVQ5dGNN?=
 =?utf-8?B?SXRudWlhVmh6OFdlTXR0eXoxbmQ1b2R4Ry9XZ0VnQVJYS0RuMlBzc05kM3lo?=
 =?utf-8?B?d2xEZWltSzVTSEJOR2h4ZzlhSTgvQ1JLd2toUHYvVmxuUjMzRjdpRjhWNTRp?=
 =?utf-8?B?c1RsNU1XOFlVNCtEbzJKME1pSDhITnFwOHYzUVk2Q2Y3MUtpZHU0alFUdkpB?=
 =?utf-8?B?VXN4Wnl0Z3NtSzkxbGw1VE1xT1lkZHR2SGdFZ210K2VCZHFlblhVY1VSQ1dk?=
 =?utf-8?B?UCtadzUwMU80UnhhbGdLbHJLM3BtdkxzUzVHNmdtUnRXbnpvRFBiZXlRTVdz?=
 =?utf-8?B?OXBiL0VWUTVIVnNMdXF3dzlaYmtiT3F6Z2Y2YTJ4cnI5WUtQTlZFMnl1enJj?=
 =?utf-8?B?SC80ZWtoWThmY09SQ1B6R3NnWFJPeW1POERGM3NpWFp5aDlFbWF5NDZDcVJW?=
 =?utf-8?B?S1dyM3UrYWc1VlVYRnZhYU9TQjNnb0tCR0c0NjVBVFdveU16Y0k1VDJYaDhB?=
 =?utf-8?B?SGEwK3FjV3pFLzA0OHVaeTJXeENEWjFwYTVSMXFhT082ZVBJNENSaDJWZ2Qw?=
 =?utf-8?B?Nkd2MXJkZExrc0l1bkFad3RjY0xsZjg5bktTQklYTmNlSkdyWE51WDhXUzhM?=
 =?utf-8?B?cERIOC82T3BlZURLc0xLLzB0NWR5WThhUW9aaHVmM1N3TndaU2huR2wrbHJC?=
 =?utf-8?B?YnFaaldodGcxRFI0NW91eUwvZHhNMTZqR3h3czdJYkxReFlSZXFVZGdqR1k3?=
 =?utf-8?B?YjJwTmRKTkdHWDJrazkwUG1tSFhzM3FqcXIvZEErbnExanBHSko3dzRndGVK?=
 =?utf-8?B?TWl4dEMrYXA1dnVINytpTDRjM1dkY1hCVHlQNG1IVUcyTG5lMFNWVkE2cVFJ?=
 =?utf-8?B?SDBrVVh1d3ArOXF4cEdyZlFvMXo0RFB4S0E4VEs2azlicTRjS2w1ZGNHSTBh?=
 =?utf-8?B?RGFSRkVhUU82b2lib1NMem5URS9KQ2xIaHEyRDNWQmRlc0poLzNtMmlDVVBk?=
 =?utf-8?B?bVR2K29aVFNndFhveXJ3YW9GUkFuQkJZTHRkbHB3REhYVUp2eENHaXVMbGJS?=
 =?utf-8?B?KzNqdjRJMy9kYTJVaE1QZHlEbnI0Y1FqQldtdWhmd1hhTGs5VlFic3VZR0x2?=
 =?utf-8?B?VlZCVnM5Wlg4S3Q5QlVMRWVocFNpRERxQXlkNXZacVhUUkpIUlFwOWdoMzgv?=
 =?utf-8?Q?HTbc88CKNRzESDtle5vIgIDi9RMyG8SIEKGvYgW7pKqZu?=
X-MS-Exchange-AntiSpam-MessageData-1: j8Y62cM06fx+vA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1fae91-4e9a-42db-e1db-08de9c3005e6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 03:18:40.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCl1B4pydOHo9ggS/IOTrqtURgC5gbKEwn+4n2yVktMDLIfv1nyA3GlfyqMX7sM/oUiW9l/vhloxEOwHpd8g6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8288
X-Rspamd-Server: rspam10
X-Stat-Signature: nk9ogup5ww9tzfhu49ze8c3gotg56ier
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D7CC180005
X-HE-Tag: 1776395926-121333
X-HE-Meta: U2FsdGVkX1+FGXjO9rIiPjwIlDdgZUEXMIzvxUaNu+shvoPerhFvG3pHM8if3eR1d6uN7fVYyHAAVVLDhtYqM8SFalgre7d7ptJJFwfH2+khczlq9QYLrFA408/T92BIH4hu78jqTj7l3BI5NNSe2MKY8jok/oFCIGbvLLh7LpumdtuAEeAm5GEKyNopKXUSII3w7biZLbge/8rsiINihmAC4VbMnM5h2N0ivleCwAsEwyMs+yZwlta4KehH+6HqxW7XjifgP2zPW3LeZ6orcsidEAnwahLQZzyIwuI/RDccqySNs6qEz763n33Y/3yTZNO0TSbtKMsMISe5g12YZ5REM+FdQ9J7IZtOEcXXTCSnRocy87pFtnruaMLPNvdpTCn+l3YuMWm6wBAceuWi3Cjsrh3L/KAG2/wLcSqD+3oOdlplszmsj1DePPaEvUiS6pyOmf2NEIhKIOOBTfJJVFz+JdYFs/81jYX9XNNNtZhONjf1AcbkjdMxcwfSD9gMUOcbnsOgPqLVlwD1NdFnI0BLDvesk/ZWmOH0WOcL3+mnDPb2tDIm7iKWEaf+qQlpjCFlvfMai7xmwiypF/5THTnzXuRIV0N209N9c+XLitAUe0MPVnGZ4XAGwq6bOKykOkOGuzrbFKvHAFz0igk67bZq8s8USMGrgw2M74WIvg1ZHuMWUdbvwJ1VM6zalDsNwKpDrb51bEuER7c9OZ6KDBCrxs0MjtH6u4libPN4BK9Txsb9A4SmtKSp8ThXqt+uihuZiWOynSyVBdjXrKHeGaax79YUDZKyQIqnjTVq69/k7c5M2CehvBbCC0jt9sywLTv+p++YDMPhctzfhnseZqI7ZC5j5j5JoTDj/Ae8p57HVU9uFdUwWkM/MAf6j6aI1Hffcl3j2ocUuWPhsH0k+9rXg/d7pIWLV7TW8t9zSGXO15eJ1LbVyGg7POegIsTK++jsPYsqQJQpF21kO3o
 ArsGlvvi
 3AvVTep2xMescmNW/4tdxFllFhaA14Lk/XEhUdETeyH6Q1BMygqh83Oi8kwQ4Cb2+9DIxkybAUzKT7i2Eor4IQpT1qGil7KJYNoj/f9VP4LSzWmf3Vcq8LL3uPJzG3oJnM1/zsFi6ox3a/MWr/1LLMa0oBk9BMHnBOdpaQIOvy913+9X3A7Y0oakG9/SEANlKic0lS9rx4PQL0ljR6Ngf+YrwQIt05jKlt1zBJc+ChbrxCOxU+S7Pukzh8i6BrCNv3jng7VKBNhHIoQP0WK8LU5zlG8NYQxFbplCUbMOTP7gIrXqN5jwCyifqbPDhFQeY037WzIPKmxyL5zVII3rNCH8D/IWo++oT2XqdcNJYJmReIzqbl44biGdqgUM9rss42g1Tp8KGws6MKEopW7xITW6tU8ogjlxAy7ulb7//8w81wWXc8M/ZQRovsa5Ug2osjPBVU+DT+2+KmE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alvin,

On Fri Apr 17, 2026 at 10:05 AM JST, Alvin Sun wrote:
> Add SZ_4G constant defined as SZ_2G * 2. This constant will be used by
> the Tyr driver for calculating user and kernel VA layout.
>
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  rust/kernel/sizes.rs | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
> index 661e680d93306..872f5bb181ecf 100644
> --- a/rust/kernel/sizes.rs
> +++ b/rust/kernel/sizes.rs
> @@ -48,3 +48,5 @@
>  pub const SZ_1G: usize =3D bindings::SZ_1G as usize;
>  /// 0x80000000
>  pub const SZ_2G: usize =3D bindings::SZ_2G as usize;
> +/// 0x100000000
> +pub const SZ_4G: usize =3D SZ_2G * 2;

Note that the way size constants are defined has changed in `master` -
you will probably want to update this patch accordingly.

Also there is a `SZ_4G` define in `include/linux/sizes.h`; I am not sure
why it is not in the bindings, but we should probably add it and get our
value from that.

Finally, maybe I missed something but the new value doesn't appear to be
used by this series?


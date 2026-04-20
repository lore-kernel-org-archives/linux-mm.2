Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723A4F588E5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1D76B0005; Mon, 20 Apr 2026 11:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8FE6B0088; Mon, 20 Apr 2026 11:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFAE6B0089; Mon, 20 Apr 2026 11:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B26E6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:33:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F361C19AF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:33:10 +0000 (UTC)
X-FDA: 84679327740.19.5F4BE58
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020133.outbound.protection.outlook.com [52.101.196.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 573928000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:33:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=gQjltReI;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.133 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776699187; a=rsa-sha256;
	cv=pass;
	b=LjUNe6DxZ4BbJlvYaA7t5EvB7XEsGI/yqJF5bM3/D+434SNu6lhQGywzAlCZS2G8Gzngkm
	MxU2KQ/cpXACGJZZHbsrJDRl64CJmZv8jR3sBMiA8AiyYhZTyer0YyMvW4tCPL0ho5SSzf
	rS8p6mnidNrFBRVskFbVkQry1hROd50=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=gQjltReI;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.133 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776699187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2YqZeWuaxCV2OYmJrCi23cXQG3aRdNALY2uffA9TaY=;
	b=a0CTBq1GrAvbumCS8c+q8rznH8u5ltYqMRZSIo/G1nUvwlSa2d6TdXoGUIyU8hMiubL/Be
	X7jArBFGpWPcxke6bEzC4aHqOSUT0pF+iY/GHW5BaWwaxHMLEk3S9ddzQ1GvvrcKrlGavY
	53pL0HWE6D8ek3xPCs1J3hr9G/iAyEA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jlFR36KllFGnDIK2KkOaI/LhDByg6l9yDumpXYaKCn3ZkOB8ebVHeqY9lUXNyhft64wtZRCFm8V8GL5qCf2X5QbLt5nc+5b3Qax9VIO+tKVelHxCu6237ojPewgB58emxwlub7VlC3CRqtsEUD91myoTeHk7xj37vlBb3DPZ8UpeBDabngq7789/IBdqA53YHw+0n6iw5daf8hmba+JnoZgbBarkl9LkoN7pKGLx1lxae6DEad4v58ktH459C1U0T+XtN5XIiROANznltDUWSrLIwz7vp8cl19Q+/GwWNrd3UKSyS+2cSmsEe8ZYNIsDanrJShweBIiGflm+ZWJ9tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2YqZeWuaxCV2OYmJrCi23cXQG3aRdNALY2uffA9TaY=;
 b=rFl3lBrch0iN8XA7J7KmjpJrh8xmtTksnReXLb8lszmqtp8hURO/6nwj2jFg4Tkzzczfs15QQyDFp1vggeBF49VTOvBFcMEdVaoorGXbJnh/TLgKah/d8313mpQE02pWGKyfasb/vInNmAnyENp0LItCvHSb4xDvzzsbqW1OmUGurdpNPDGUwitdS7P3S8bPQbgiUYu6bTAAxF1JlUuh74OpX4YBOJX39hN7Th6SoVBNBGstm5/Jb4Of7NqWu7ob3mYiM/mY3/8GiRsjsVVDVU8cLOhfXGFUjItdf66Vw/NC6wDfowuWtLMNgxA6GlsRq8X59rSJq1gIkTRTlfKL2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2YqZeWuaxCV2OYmJrCi23cXQG3aRdNALY2uffA9TaY=;
 b=gQjltReIJpm+23yE9prvImw2KUIrUo5xmM7XGdwq2ANGBnK+b6NtGDc2RSair0DJC2hkRO5P9+EseEiX0jqktVWxRFrrfrC/f/T4S190Mb98WftIZ2AGudobLDd4G786isNTa2upf1HQS2/hsLjdB16+pBFKk3bs0izQoHb2bPo=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB6689.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 15:33:03 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 15:33:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Apr 2026 16:33:03 +0100
Message-Id: <DHY3AOUMH573.351G47J6UYLMX@garyguo.net>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 2/4] rust: mm: Add task_size() method to Mm
From: "Gary Guo" <gary@garyguo.net>
To: "Alvin Sun" <alvin.sun@linux.dev>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Tamir Duberstein" <tamird@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-2-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-2-41c6e9bb061c@linux.dev>
X-ClientProxiedBy: LO4P265CA0165.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::8) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWLP265MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f9828f5-1c84-485d-8a83-08de9ef21cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eAQ3+ffEvhzGEpZ2sV8n/no9jJmamCso5FatUBcu+hOxU4dVjOgnEUeg0QbAFqJxSnJTGzFokWwjEu8qNCCdQP1Ws2egAJjIaJqhHMajkPqLFupQhgGF+VxriRv/YCs3kA/d8nL6aB9DsWdHpsjlHQkZm4RfGcEDNSub6Xvcn6GFFiOw21vQqNGhUUigvkEhRBXa1jXCesvYlcKdG9Wwz7HyftNTxEZRkeH/NRjHI7MxTOoFl75cia67WgEBFhCw4IpHBjWIPIYc9XIY3stAd6OzOMqNb0gaWLRDuvyUfTnebCPSRXKZ33ZrL9sHgrDyXAhniMT1PCkJ3Dio1xjHhW2Jvu4TAUiGuqHVf6cPwNnYS2UrgP0RS2SHFfDyeVriY/34TWyM6dUBR9Ldj2mXV0x4Q/N066pCFtaAdPypxjrL1Ma3Z3kxSdL4NAXDxGMahE96rmAOfR6hXZ+9RD0qwJ0hWR+EF4MT60MhV/gptu+8y2CRomZWXUBo/vKY6H4UqPeUETiAx9soeYxYKpieNlR//uDD+zXthifUp/CRKIDnPDkczRGqBRnK/kYEEYdpTqaFQXnyKncGgaPavGvCwaiKrkfrdZiOyNtzgqGtL+9n5msV61cZrE8v2mO01LT22nqCNWma7+XiGnC5fzZ9sTNrGZU8VXrBpp2qQ7a9ke/Fs5ejFvEY8qiqXeswzmrb/x+cbBLBqokYyturUelP4HvqDaF5gHNwN15KfFZIVC+krIb0/Van1u3F1cnknC4Icy9tFY+NjEcISSGn4pk5nw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmV1N0ttQ1NHbkUrdHNVNVkyQ2tnSC80S3FyRlJWQTRqYkFuTitlcUoxdFdr?=
 =?utf-8?B?UjJjcU5IL3BwOG11VnYxV2tRS3czZEdQTFRkOUVDTHVFblpnblkrRjE4RGdO?=
 =?utf-8?B?T2NEUTZrTzlYZ3Q4TE5VY04vb25lbUtndDZwOXF3cXlNZkxROTFzZnpqZEgy?=
 =?utf-8?B?SzZQUGZ0bk1xNjZTUHJGRUVDSnlZNFdoSFhVVzdUN0xnbHliWUxmWDJIb0lj?=
 =?utf-8?B?MHdGUmthUzZNTGdIMUl4ZGFERkp5dG15Z2d1N0w4ai9ibi82VkhRQ1JhNlh4?=
 =?utf-8?B?cVVwZGJQVFFLSHNCSTd5R25MVUFiS2tPWnNPTFRibjNEaXIzQko5K0J0d2sr?=
 =?utf-8?B?YUI0dytjb05OZWJEMDF1dHptc2dEMklRd203L08xQ3BpL0ZyVUpYNVorZkZ4?=
 =?utf-8?B?ZjZEZXh5TWJZS29JODVIQzROVytwOEVUWWZhdFN1eDVhYW5YeVpNRnFVWnFL?=
 =?utf-8?B?RnlMa0U1MEQ5ckhKanJJYnlIYkEyZDhSVmpTbnpZOHE4a1FOUmUrSUVrOVoy?=
 =?utf-8?B?eldPZktqTWlqMFBPMWt6SW1GMC9xTnlPK294TEJBaHVpeE5xUXF1aGs2ZHpR?=
 =?utf-8?B?ZStOTjNsaFNtWkxRUzhnYnNHaGtOWHd5SlNqQ0RUR2ZtUHZWSGpmR1I4b0ZU?=
 =?utf-8?B?cm01NGI4TngyN3g3T2QrZnZvZHNaZC96TUJNTVJ3S0dvMi9LZ3VsUDE1ZWQ1?=
 =?utf-8?B?S1U2eWIxS0drUzRNcjNPWWtaQTgzM3pGRURsU1g1RFVEd3BpMWZEYkNwZlBp?=
 =?utf-8?B?T1JKd0hGWXBTTDNML1VhT1oyakJpSFV0dHRoc0djNHozQ2E2bkdPdEVqdDFD?=
 =?utf-8?B?ZlUxNUpFYlpxSjZQK0c3NUV4ZVI2c2RVSzhnK1dmdE5FbXJ5Z1VsRnhtTUhO?=
 =?utf-8?B?MGZSMXgwckVWcXV1ekFqVUZPR0JGSVVNd0tHckpUYnc4blp5Nm9Vc21Md1Ru?=
 =?utf-8?B?VWRUQ1FHeUJaZVcvTS9DNi83c01FUUlNdXRJbDRpR2R2VDZrNW1XbnIySW84?=
 =?utf-8?B?eDhwOW5RV1ppUG9UbnNjeE15ZU1BU2MxMFVsemtIRHFzbkwyc0dCaWhLeHFI?=
 =?utf-8?B?a3AzYXo2V3lrQ2ZjZHlrTnlzS0hYOE1DN0tLOXNIaGZNQ0pEWlFPR0cvR1kw?=
 =?utf-8?B?NWFtU3JYSDJlOUh0VjcwVEM3cHFKMGZzcVBoM2lycTRkS3NFWWRNMkp5ZExU?=
 =?utf-8?B?WVJPdDhBZHQxVWFiVEV2QWs5WXJZOVVBMDBaS1F1Yk1ZQkFKblJ6cExrcFRy?=
 =?utf-8?B?SkcvUE1DbnpHR2NpUjNGaUNSLy9LS1pYRmxWUks5eERMUUNhRDgrTlluQ29m?=
 =?utf-8?B?TWZFaE1zNTl1SHd4SDRBL0RpODlFbjYxU0xKMU9JQjVUY2haRmlXbFRwOEFY?=
 =?utf-8?B?VitKQXVLSW9LeWlOVXB0ODBLSEw1NDdXUW1PTWJXakM0ZXN6TERnZ2xWZE04?=
 =?utf-8?B?ajFBNW0za2NueUhRWXNIQzVIZURrY2M3dEhESHUxSHZQcWw4MGlBK0dmdmJj?=
 =?utf-8?B?ZjFwdzAyOUY0TURhUEpSQVpscHZicmFlRzFiaWdVVTVmalJ4enBoc0xsYVpK?=
 =?utf-8?B?bU5QREJBaUpvSEpDWkYyc3QvQlk1SnF3dDQ4am5oNVZKamJMeTdrM2FCYmFY?=
 =?utf-8?B?ZllEVUI0Q29hSGlPQW1KbXlnd29zVHp6MzFoczV1SXB4eFJ5eUtad1N6L2ZB?=
 =?utf-8?B?YjEyWnhyY3pqWnoxdnIxV3dJWkRZTW9oSjdDQzJla0dVVkVReW5XblV1T3Uw?=
 =?utf-8?B?WFBEN251aWlkdjczWkdocExZejJKNlNNQm1iMjFKMHhaODlMY2didzEzYWQ3?=
 =?utf-8?B?YlAzM290YVZyZ2oyTUprc2IzRkRRdFJGMmtZSjcyQ3RPZm5ERXl3RVVrRUpD?=
 =?utf-8?B?OVlWUTdjUDczY0lxRGkyamJ5ZnRnZlZvcFdsWWVKa1UyczZZeFdMNUV2VGRF?=
 =?utf-8?B?WXlCeTEyWXBCV0hjTWZiUUpkNXB4RXlUVU1rSkxQY0FFdzUrMXhMb3ZtcUhm?=
 =?utf-8?B?alNHb1FyUkpBa0lUYTZtK1RsVnk1T3pIMi9rbTJCSC9xNndnUmFkTXVsN2s0?=
 =?utf-8?B?djBPM0pwQWdTRnVGc3Z0RDVXV29qOXg3eUpqaUVHSDIvUTJOR2wzek1qcVJM?=
 =?utf-8?B?WDFxSXVibVlGZDlYREw0eUZwNmFucVN1Z3JkWm5CM2NHV0R3d3ZLMlFEbTZu?=
 =?utf-8?B?WWlHLzdyN1dZaFJZeXF6Yi9iMmU4cnRJM3R0UW8ybTMyTmtBK1I5Y2crU1pB?=
 =?utf-8?B?SnAvVmY3ZnhTK2ZUS1BCdWVxbEttNVpQWFdRa3R4eGpGUS9HZ2tDelIxVzVz?=
 =?utf-8?B?M0pZR0xhbWZTdXZid3lkR0NiQ1BvUjRab1VoUjk0YU9pczc4bDZyUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9828f5-1c84-485d-8a83-08de9ef21cb5
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 15:33:03.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWnUYle4PIPhw2VfPpcjabvN7B6/B4oMjteZZGXnayFdUcCjq9QBQfuCD56MlcJQbLRrj51kM5EosIGeOFfL6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6689
X-Rspamd-Queue-Id: 573928000D
X-Rspamd-Server: rspam12
X-Stat-Signature: 6b5pc9jsn7xr69qnkocha65waz9uyzsr
X-Rspam-User: 
X-HE-Tag: 1776699187-765622
X-HE-Meta: U2FsdGVkX1+jydjtZokldxSDw5LXAU/t33ZF9Rde5Sqseaf+HSYLkigB8D7wJcxz4HM54fAhjTCm9Sh5kSwQiSaOiqM8OLhfkVjM2UpuiN8MoYqlHW9ErfHk3qWzdMnFMYWn9dz8N+BqJC4HiI/3JQczF3Opg9xkAAVpJ5Yn4QjQ7+auIHsD6YmoBk3xfGzfLZy5hpPmLoMZrn9qa4YsZeggOcTFxaXQPCVWAy8WNpGalTmHWgzRfdDdKwKeSwQWRBsti2G5ZfV5tulBQ5nQo4OmDyIsa6mUW6pv248N6LlYFX1YIJzGG1Yij2RvdSYFeu+vKBtwKnbIxmuNe1WBy9CiCa2vN0hb5IKPegJnoJre75AGjk3IwgH249k1hX60SwP2N4Q2kXuVmXFHKGtkb/yMKdHQC6vFgHqDqb+45xAGzL6iSOB+SfQfCPv+G4RE2VtIK6u1LE8xz1IoFHd08oDEHZXGoFgX33+unbYCZTEde8YXKx8OxCwbrEyz+I5BNUnWR39r1kLtcK/raXpMZBJnRtjMw9mBOgS0E6CA+YP9zcRdxtrjvgTnVwKxR+j+eQ/md8SKGbGnOfg6g3UfEpGbyD1ZfrGr7FaevOE+3DxwPeHBGQI+CTNmDY0ocnI87nXkV1BHRbT1OVU2OGk2KnhbnGFuF55TrYelKsTB0DnFeKEP2PR39fKcbII6FfHoPduimOR27YO5g4ZP8Agj1P72LQBXmuwLnmnpNYkInrxB0SBr8xVdjlPcG7NoaUGWBijhXNKSNzrNejEDd98RztmvqkHmUCp+PYQzZLTrk6umiR17Scgy0sgCcXwC31spnicK9sgN+fi7+vF57SSnYrjW2yE6M9wLxsYb7Fj6jjNCTvi2b44zHde2PIirpZSDAOaFVHAD+SwOoaSRQKakOU9rce+cUjybqmrLjleif78tKfR/YcTcsxbCWOw03pAxY1pRS2LfBSgzZcF6bKq
 9iTVbwY9
 VC9ZiTY5W0sN7vdwi4wyiA1II9FBmiCFggpKsWXLwaTrc/JsGz+lk/9eYEDfaOr0L1xPB9nmc+55Bb1loI6njw4G8tu6zs0C0mAC/hXS4YbWpr5g1zhBMZACpJBlaHfiEh1J0MqZ0tED6DJTHY95ZrTGSBz+WbDQpsr3Oj5ltLuG1AnK9Vd+RIprLgaP2dugGVE4NkXkE3YcsTS2x5TEqhUrGr3OzwGEWRu1ubB45FbxTNqlc/sXiyo4bjV0nkdh3bLkQKBV2MeSOh6sACfUVS6d6oNMLDLluXz5pfC7bY3ANXDO3wBEEVYk3Zje2eTsHcua9k+uGSDsgszoxYKO82gMYaiVytW4j9g1h0fzuB5q8Vm4gyuaS3zhFZXLbdFAZQ8hYOe8AzdB3cq7L/iueNwrddzheVCmsIbKB0RWQPZHr3jY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 17, 2026 at 2:05 AM BST, Alvin Sun wrote:
> Add a task_size() method to the Mm struct to expose the process
> virtual address space size. This is used by the Tyr driver's VmLayout
> to determine the user VA range when VmUserSize::Auto is specified.
>
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  rust/kernel/mm.rs | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a7..c6ba4da52688b 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUs=
er>> {
>              None
>          }
>      }
> +
> +    /// Returns task size for this mm_struct.
> +    #[inline]
> +    pub fn task_size(&self) -> u64 {

Why is this u64 instead of usize?

Best,
Gary

> +        // SAFETY: self.as_raw() is a valid pointer to an mm_struct.
> +        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size as u64 }
> +    }
>  }
> =20
>  // These methods require `mm_users` to be non-zero.



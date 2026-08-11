Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D23C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4146B0092; Tue, 11 Aug 2026 05:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454866B0093; Tue, 11 Aug 2026 05:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3436A6B0095; Tue, 11 Aug 2026 05:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F5E6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:04:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 791758032E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:04:10 +0000 (UTC)
X-FDA: 85088401860.26.02469ED
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012048.outbound.protection.outlook.com [40.107.75.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32BC2C0004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:04:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=J4Q4jgzF;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.48 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786439047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2Nw9JAWsi2H0r37DwkIjujiBdGzw2kghshx+QHnOsQ=;
	b=XnYL9RElCTadjo7QusX/axshSCRCtbJ1YILfi/xE7y0O0LzIaa8VDE0PdhX8OeMfCXBfwi
	rPJSbL2KmINdKXnVE2/EeodyxwvaSKkLLP7Vl6aC/XWp0TOQWs0j04bdsf2themz7Vgq+/
	uNybZdRJp6HSwhtJUXrP5ll7TMYp5r0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=J4Q4jgzF;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen@vivo.com designates 40.107.75.48 as permitted sender) smtp.mailfrom=xueyuan.chen@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786439047;
	b=XckkB12Qs/IkMwSz42G8xntbKSmOzhuRP1HcqruWw8PRhPTn/vIpI87yhXFoCHWfobuD4f
	hoSDmiZDl1+cSCND8dlVCuE4y1H9/HU/T+MYZI0Pr3V4sfs4oISE24AxZscWEhK0Lm8OmT
	9ixOTeE4x7WHE3XW5l344qXXV8VMK10=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EihLs56W++I41XPuIT+d9wXcxalIFuexZp3nzfPOmS7db9z4AZ3xz1eJ/OKFskNkeei2a8BbgpBI6JeluxYMjBBca/x50aHfdLkJu7RhcqjCGTWzHVJSBz9202emzQJAMf6CE3kw2jYWDCIAzs7imfXv4YJ9Biwhvr1SeA4tJtE4SQLZSmjFRth4+DJpvmcnHiMJy+6R5J825tEQ5V+aHqC2u3XPCl3ymipHutcNyTO1Wfvw38r+Oq+I1bOVh34mhhKkucYGXAnb9/U6433oPKhu43NCC6oknUHZUIAt8hNRKIini5BgZgwOI4cTbbSlAD9e+aM8avjQBigz25lFsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2Nw9JAWsi2H0r37DwkIjujiBdGzw2kghshx+QHnOsQ=;
 b=YmSuFDTr5/5q9hdOBss4OIHsOsFcYsrnORNFxvGJK97wswJSLCK96nSQ8vfoweBl20RCgjPBD7Ktvnq1Xt++90yoki7SgxAeBoxPU6BaL0Lvbpuvg0okuauVMXoQjWZvi2KfFBU16K3H0kfO9bTRA0x/nry7QDT84zx/DJ7D/puzWkV3lUh52EVo0KWPRpWiqHMs80JXKOHJdL0EJ/iLJGOB7M4DZPhWZV9HJoQfEhTCcEzSuEYRTwhqo10V0IdVjrajS/Aq/DGTzrT+HOer50HZJghKibZ53YLttR9MhsFvjX/KSC01dGYG4MDNFw3ySR3OqI4g2gAEzwEWmSlXMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2Nw9JAWsi2H0r37DwkIjujiBdGzw2kghshx+QHnOsQ=;
 b=J4Q4jgzFPXotxaDRjMU0u+CSMF1Us45hzxkX5IzC0FTgQnssvjFuh5yg8WmEIg3o1Jg3GCaqnCwf0djRN+suChefXp9JGGPXcNsLNhCu7zxJs8hLan8WCqjeb/z0M4qImk+exgaGNs2KtJ/3pFNUpMUOFdBWiYf77mIT5vHrsMe2P5eVf4uX2ibuz85TvB09ezQSDeBZspTHkT0LIHK9WSSYAQsyrvr0JjkgF+oZPVd9D1QUsam60WezCofsMsj+kLixs2Sts0HU/uuLZoZStpXvEY97O2EnwMy3f3GWqs4kTrBIiM8H733Ylvgkuk6thdUoIUzfzV77jgiViwthCQ==
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com (2603:1096:405:383::20)
 by TY0PR06MB5209.apcprd06.prod.outlook.com (2603:1096:400:21d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 09:03:59 +0000
Received: from TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96]) by TYPPR06MB8235.apcprd06.prod.outlook.com
 ([fe80::6ef9:8fa6:5ebd:96%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 09:03:59 +0000
Message-ID: <7b83c51a-1777-45e3-ba38-89e12dc87b5a@vivo.com>
Date: Tue, 11 Aug 2026 17:03:55 +0800
User-Agent: Mozilla Thunderbird
From: Xueyuan Chen <xueyuan.chen@vivo.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
To: Nhat Pham <nphamcs@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>,
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com> <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
In-Reply-To: <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0045.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::19) To TYPPR06MB8235.apcprd06.prod.outlook.com
 (2603:1096:405:383::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYPPR06MB8235:EE_|TY0PR06MB5209:EE_
X-MS-Office365-Filtering-Correlation-Id: 4711a78f-d519-4972-819b-08def7877b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qQtyu9hYjJqi4JTDaPXSthlh/KhAyXzb6y/ZxpR4T0/oPax7Qodlae76PHTPAJvxGd3/L0KhfenUoFEd5SFDl5FEp3OhrwU6Ocm+xQn1ji/3OXQKztIiD6q7ctiwVW2hvPsmKtkdhcDjKh32EjkiYsQzd4alA/IK00KjRoHrGcRHFB7fIhUNs10fyqy1U/8B9zPWg1Vf+B/DVl7i9JfO7WFpIgreGm3wpaeFzis9GftgkGeIhFYVcpEaEQwH87A7HtfLrOzn0tAk/gqMp24/i+Q+uckwlho90sfWQEH7mqdwu7EzID3AiHGbBR/50rRZr2k+nFUG+4XUy2SfwpBgrkyE8SbMW8MfcSTxNDXoCJ+9TYJA+3+n9YcgRoOYM7DQ21aYUiwU82ScMHrEr2WstjR0eLaCW2E3cHfZsmdbk1acBk8fTnT0zUXWNsC8x6mY8gEGmDbbOy3IH9U+FNJnT5j4POO3N5ufgQITt+9M44bQhH60AIAnufkxRY18QZMn94C+VYoZiwwOEVa7cCAa/uDroACexawfKeZwgTfdSBrNNycl7d7EKkyth2KD5Q7U8ZAcWgtmQidaS4Ufh28Jy6Pb+itbmBCr0fTjIh8sE4YQb/LLSRkHTVlJ1U0nZ3WfSCzk8f9Ob1S+fMuF4aEXRspip7FPQffou/ie4wr/lTE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYPPR06MB8235.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2t4QWx3S3ZZamVJd1d2d0RHaGJJNkhFZnk4ZnVTYVpZRGg5Vm9sbzl4ZFI2?=
 =?utf-8?B?VW9IVU1ValhJRXhYWkQ2a2JtOGJPUlo4bWUzVC9OZzZ1Tmg0dHc3NjJQekJM?=
 =?utf-8?B?R2h6cHd2RHlxdFE5QXFUZnRlZEVhWTNSdWZRakxrbVlya2VKaFljR291eHJs?=
 =?utf-8?B?ak1zRVcxT2lxWEY2SmZyUmdsN2R5SFA5VDBzSko4dEk4Nkpsb3U3WWExcDBl?=
 =?utf-8?B?OWd4cmNlTHowZFRRdjY2eXA0dWkyTTJSRFIrOWViUlVtNUNTTUtLQXc5T1NW?=
 =?utf-8?B?NUdXRHo1aEtLdWR3LzdPei9kOU9waWJzU1NKMU1MVndkTHVKRFFmaGZpTzBB?=
 =?utf-8?B?UW8xdVlNMUhmMG1UYzBNdVBLbDBOdnZXSWlnODlFMjJnM3lDd0dmK1YzYXhV?=
 =?utf-8?B?SXAxbld6VlpDL2dsVEx2QXRWMHgrY2hWdmFBclNaL0lRR2U5UUxQdjhXeWMr?=
 =?utf-8?B?OE5uLzNhQTB4UkZoWmpiTFJqbzhaTDViYkx1VTdUQUlRb2hVQVN2Z3Z3WFZk?=
 =?utf-8?B?aWx3bXZkZnRYUnhIN2VtQVVPUXVsVzIyUmY4TWU3d0E5S05XWVRtR2VMaDY3?=
 =?utf-8?B?aHhqd0dKb1VqTTVYN01vV2FaeC9DV0UxTVZ6TjNRU0ROcUNhb2RTMXJKOGk5?=
 =?utf-8?B?enRXSXp5WEhhOTNQbDNkRzFTTFRGWkYwZjdLUHRicGtaYWtUbldtWVB3T1U3?=
 =?utf-8?B?Q2xCY2xRaDVHMzQzaWRhM1FGamoxampQUTdXK0oyUkNtM2hiRVBqV0NKQlk4?=
 =?utf-8?B?RzkzK1RDcDdXTWhtTldBRTJ3NDJHanhNT2V6T0lqL09nOEFmOWlpSkZWTlZX?=
 =?utf-8?B?alVuSHgwZkR5SXhBWnV5MzdMWS9jT202Y2pDYkJiK3NkVFFPNjRwa1hDYzhU?=
 =?utf-8?B?YzZudnJ4endSWUM5c0ZiMVJ6L3IrSUhMdDZPcUFNdlpyaHhpb3JubWM3ZGYr?=
 =?utf-8?B?ZkhzRWNGVTZMenF3V3l4M3ZzZUtucmlteWNDZmt4K2VmMTc0M1R1a0g4ejZT?=
 =?utf-8?B?OG91WUM0MzBGMFluNCtkd0ZEVnFOcUpKdjA1ZGVveVFnbFllT3ZKWHRTWkZs?=
 =?utf-8?B?ZjBIZjBYcklhcjBMRlJJU1c5dGEzdkN1ZG9qeXBvL0tlQnB6YWtjdWhtUW56?=
 =?utf-8?B?cVFicTF1MGNwcWVlSDE1V3FFT3hHOHBBSXVCZFQ3Mm1mYzMvR3BRMm0zdU93?=
 =?utf-8?B?OU1NSDc1TlRFMEd5M0VmMWFMNGNFWGpNSXdXSUF3QXBqMGxZYldzbWZLZW5m?=
 =?utf-8?B?a2pQWi9Oa0FhU0Y1VkYrYVFrSjd1RG44eXlQN1ZCSzBZUkgyd3ZMcmNSM1c2?=
 =?utf-8?B?dGt0dUVuS2RaQVo2SnBCMUFRZ3NsZmdZR2grY2g2RUxZKzFabWhxbHRuU3Qw?=
 =?utf-8?B?VWJzR2s5bVZsZWRWRHlNZW52Y2VDcHlWdkxjQW9nZGwrSjlwa1I5SjRLRlVq?=
 =?utf-8?B?OU1Bd2VnUjJDZlM1blBOUU1oV2RjQ3k5R2EyQkZXYUticTRYZ1JWNEc2a2Ra?=
 =?utf-8?B?NTZUcjhhNEVMVXVycmVtSjcxUWJFMGZ0Nlh0SlVGemVaTTdMNnBPYktZTmMx?=
 =?utf-8?B?WmhPMGNHdFVLdHpKUzlBaHprMVNYOHRycEVaMFhmZGRwbDhVWWpJb1p2SnlX?=
 =?utf-8?B?ODRiazY0U2RRY2RxK3ZPNDBqL25IT2FIWDJ2RDhiQWIxdUtLWDNuajlRQWdZ?=
 =?utf-8?B?NlFTS2xpZ01tZnEvMjBWeVgyNExxU0JOa1BHVHpjdUpRUjJ1WE83TkJoVGl3?=
 =?utf-8?B?OGptWGVjTmFLT3hyY2JGdWZTdFZpcDExN2NHU0FxSnJCVU5tdExTRFdMTlRX?=
 =?utf-8?B?UnhtQ1FGU3JqNG1EYnF4blBSMFMxVU13dFVDR1lsOXJKUnZ2ZGVrd3oyWTFF?=
 =?utf-8?B?bndneUJDb3JxRU5aRFZ6c1VpbDZMYlVLWmpHNmJpaHozbEYwRWRRalRsR3Nu?=
 =?utf-8?B?WDNmcFo2NnFETzlzUGV0dUFIT29BV1hCT24xSnF1R0wvZ2hPZGhuVkJDVTV6?=
 =?utf-8?B?MnAzRlRwS0Z1RGlJRzFFdlRtNWJUeFRZVmJJWkdOMmsvaXcrVGFnNDhKUFJu?=
 =?utf-8?B?VkU5bWZiZVQzMlg1Y3Z4MkNUWDdFcllyTEc1RmFwTzlIT2VZZHJSNDZBb056?=
 =?utf-8?B?R29Gai9tUzVaWWt4YlE1cWVTMmttem42UTBJZExIZmlvTUhYUndMWlo1Ylgx?=
 =?utf-8?B?ZTFqTUNCY0lKWGxsU1VJZjlQWGRBZWd0QS9TK290WGRBazdydUVuanlmOHJN?=
 =?utf-8?B?MlR2TFFjRUJSSDh2TjBjcHp6K1liK00zM2hLc3BGakpaNlBLWVlkREtsdkxs?=
 =?utf-8?B?K0grZDZtMzNkeVNmeFM4TnA0Z0hwVHlHN3NwSi9GNVNGQndHYkMrQT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4711a78f-d519-4972-819b-08def7877b4f
X-MS-Exchange-CrossTenant-AuthSource: TYPPR06MB8235.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 09:03:59.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zUsNdqp6PQr7En9FApOkYbKmkzvQgWVWGRVgIhum5KMfS2H99gXjGLZ8vitnPhbvKUPnpgVjy2z8p4tzr5pSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5209
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: yfr4hmedimnjcmd1zr5d7s3xn5we9x13
X-Rspamd-Queue-Id: 32BC2C0004
X-HE-Tag: 1786439047-844325
X-HE-Meta: U2FsdGVkX19P4N+DGDYRPPwhvIJd2iZ1nRpfN7wDBzW4nD+Aujf1UzQDUgU8cVh99PQ1WxDPeg5QEusesecP1K6sYDykv0kll2dMj3nLLTVcoX3/GIprWjrclmIoblO9tB3im+DbapRh3QQ7EJAcX+DSA0ijoYs39kfMHpAHNEgzSywhGjH7tRxVoOpPjc/i+uoks6A7LoGM7I41+PeIhN39EQn0ESrU0RL4wVTfRIYn1gimq5R/moOi30bWLNzLsKo0/nyJe0kDROYlmSgXCX6Byw+mQdvDcRJEw3z8oseM5g2wqqedR754NSCcHtYrceSHeGWsEAniU23RDYPhivhBQ99dLdly8njrGbPx18YLa5/4fWg6UQXzHaSVNOvFzc+7IB8L1FPyYxa6VcFuPk3IDTGGV+2ZiqG57rnWq8UTK4xfALaAzdEp2INKNLsmQ156cgXbvqF5Kovq6pp8XrefJkLAOToyP6OqqaZXQFP+TCAjwu57y09ii9MZpDgrhcH2FHX1p3wZY7uJiv5SUcVsDaXye+Gz6g7DzKoSmIOyEl5PZpT+oYZtjPYgzVbLB17QdJorymUkw1ro5OnJZBoNhGhmK3amY4EGAOxPLvzgpkGqAQPt3fMsVKXldf7wIKGkBRxjZ5YHTBjctMX1booGhi3RE40fiH1B1OmTQQ27I4ePedEgv3iLfmdzll8SFJP4XEJNv33M/2ZHxLcQAVUwYpILNm4QghiI2frsAOgLAYjjuuMkuxenWwFTohCheHtzlBk0jQ7xQPh8rk2mqj/fT9czC1SEEfjS8PZ7zZQ52Hw++i6oodmCw8nNZpMyvVgE6qSqj1GTuYGey5gZWsBp1f5BpJ4Q2ASs8mWyed2lgyTYkn14atmkxEzVYsEK5FMQfX98/M3P4++K50WAS61VgTZTu+KjzKIkGvgmy73ui7wjiE8ybLEXmUhtCmrAh9ycDFyMRb9BADFmNWK
 vQitECQp
 +ak91oLpCRIWmTXblU5KwD3C8ClC26977eGJH6a+4HZl1p8Q3CfLwbWvEY2RjlkgaWOmkY5929EIZS6QnkkdHW08xNTqAh5xyN++KIf2EGHYcLBKIMTg+G/bEWx7dytuz0N+7CbKTOkOHgXxFsj4wIF3R0O4BVH4+1pbzgL80RPczUgv4nwCfbbxYSlm5NS8S2HMIh0fVcA6RtJOau9O/gsgnsQQRnqqPmhxd5Er73gCUR/+m7eeO7BwSx+7HCeGaG2Huvk5+8/CBmKZNospMqQb5yeaTc+Fi92SglArBsfuLORBiIOziC+o90JEmntVv+6gyr1MMLOg/ZR/6eTeDjFVHYlnAtvBZodervgEaH+qGpKWZ3OfUIWremXkwl/9FvTZjwI7lE4Guucw7VwQ9j5nzVtBN2YPP0hxTf2ycpRRWygmOWxZJZEPqH9suv2lCs8Igl5RzRUmLH07o5czKtJBymCWx1kitDGybz7nFgvFA062FmNfY8aVc9ErZgpjAULyaXJarsJeTt8R6n5QBX+mG/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/8/2026 12:25 AM, Nhat Pham wrote:
> On Fri, Aug 7, 2026 at 5:12 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
>> On (26/08/07 18:57), Xueyuan Chen wrote:
>>> Hi Sergey,
>>>
>>> Here is some additional data:
>>>
>>> I used the following definitions:
>>>    compactable ratio = freeable_pages / total_pages
>>>    memory reclaimed  = pages_freed * PAGE_SIZE
>>>
>>> freeable_pages is the estimate before compaction, based on the same
>>> calculation as zs_shrinker_count(), while pages_freed is the actual
>>> number of backing pages released.
>>>
>>> There were 264 callbacks in the trace:
>>>    callback elapsed time:
>>>      median:    5.77 ms
>>>      p95:      55.82 ms
>>>      maximum: 271.36 ms
>>>
>>>    compactable ratio before compaction:
>>>      median:   0.32%
>>>      p95:      2.86%
>>>      maximum:  8.33%
>>>
>>>    memory reclaimed per callback:
>>>      median:    3.80 MiB
>>>      p95:      30.45 MiB
>>>      maximum:  92.73 MiB
>>>
>>> The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
>>> and it released 7,650 pages, or about 29.88 MiB.
>>>
>>> There was also a 241.91 ms callback (with 30 schedule-outs) with a
>>> compactable ratio of 0.44%. It released 1,019 pages, or about
>>> 3.98 MiB.
>>>
>>> Based on this data, it seems better to remove the shrinker.
>>>
>>> Would you prefer that I change v2 to remove the zsmalloc shrinker
>>> callbacks directly?
>> Let's bring in heavy artillery to this discussion, in addition to Andrew
>> and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).
>>
>> Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
>> I don't think those buy us much apart from memcpy-s and lock
>> contention.  Systems that want to compact zsmalloc have a sysfs
>> knob (and API) to do so (based on zram mm_stat numbers).
> Hmm we'd need to collect more data in our workloads to determine, but
> if we can compute compactable ratio (freeable_pages / total_pages) on
> a per size class basis, can we just skip the size class whose ratio is
> too bad? Would that at least cut down on the vast majority of
> fruitless memcpys and lock acquisitions etc?
>
> I'm always a bit hesitant to over-rely on userspace, especially when
> kernel has information to do something smart about it. It might not
> react in time, and many proactive reclaiming schemes back off under
> heavy memory pressure.

Hi Nhat,

I collected per size-class data. 53.7% of size classes have freeable==0,
so skipping them saves some time. However, 94.7% of zs_compact() time is
spent on classes where freeable > 0 — meaning the cost is dominated by 
the actual compaction work, not by scanning empty classes.

That said, skipping freeable == 0 classes is still a worthwhile
optimization on its own — it avoids unnecessary write_lock,spin_lock.
But it would not meaningfully reduce the worst-case latency.

Thanks,
Xueyuan

>> Any thoughts?


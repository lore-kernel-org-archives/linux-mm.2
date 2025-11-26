Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3764D1036F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 00:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D826B0008; Tue, 25 Nov 2025 19:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDFF6B000E; Tue, 25 Nov 2025 19:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0852A6B0010; Tue, 25 Nov 2025 19:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC3616B0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:50:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98F01C0F3F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:50:06 +0000 (UTC)
X-FDA: 84150926412.09.5C2F9C1
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4EC3C0015
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:50:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dCvvq2tB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.201.6 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764118204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIuCm8ryFyfbZUY6bVsEX8wN1WxZp9wbzzdhK7/hrPM=;
	b=l26wzq1iklx3NjHCoSmLrUuyrp1wLBvAuPUe0fFD7IxXM+f07nv8WMI6QTm5eKkCuh9DKi
	s+zvcYv+yUTRQZcwWrcjsftxPWwSgcZsvhHURPzHVh9E0who2xpnYLhPCW49csi2QZt1yN
	+mxSZOtF5L9FCnMAyMXZSDrfVq0NgWA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764118204; a=rsa-sha256;
	cv=pass;
	b=YAweA67Aa1QcbYtvPiXqIYkRSac9DUOXPHAwXhhtBBrshBHHOXCUO1RLeXQXZyZ+Rwpoz8
	6DwPBsxxFX/P0hVO28Jzu140W1f5keiHv/q/5aflFr6SJXc050llA5cmYCTxiVfZWzgp+A
	sbx9LF2oEZx+rBQRv9KA+/1JqWtJed0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dCvvq2tB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.201.6 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v30qzTz65dPbVkdEVMezU8AuFpOwU/yoxbI6vCaoYadpLguP5Jza25udzGlGMBvVH2MroWCYeweIkrx2xdMRoGfEdd/faSj0+xSaBIWH+ukY6qrTOpApswqdu9Pxqhu4z9PMs4kchznMDfvcDibZvV2w8SqefRDN6VSQmAeEAaCBi6KIdQFPQwzdy9SaREM7dz1rP08gkx9KSz0omYVYRLVchPH2ISeh3m+F+ZQARSgpLDADATa+igNgEo2XRCc9JeTm50nMwo4QvQvfvxzlF/EgeOz15wltEm+FORofPcxYkWTtIafjml0QXURZPGL0AmuxIL/+G06+pzO0mwGYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIuCm8ryFyfbZUY6bVsEX8wN1WxZp9wbzzdhK7/hrPM=;
 b=Q2I0Vx8hubS67mQSvTqQJN3eDApxNucnWW0MBUAS3Oeojz+WzUEKXA3ZayKbMSQAtRNDHyAZJcSbJM3wm8TKvHnvY7mIih298z+MFWj4C9OV8fBIQbQ6Z562TaN7kvA7nJfGIiALkxkywj2lO2i2m1QgE5iuzncu7SgHMwvluRlTHkMlFkANEjLitzAfOYH3wOYzXsiVd9LYqCmkDA9Yn6uPgA+gF6R8ckkxmNRXj1usLVoN+Ko8X/owH+b2e+w44fQ2F+N1Hur7QwvxeMg9aGpj+UOQ8jX03zCFzmfluvcJMlKlAXG7pk+1lb+OuUDy80rlIBAiGgy+eyClbFXwjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIuCm8ryFyfbZUY6bVsEX8wN1WxZp9wbzzdhK7/hrPM=;
 b=dCvvq2tBBJZ9f2/m7oD44N+jn3pyUb2Q7iOpqq2UuUjIcZX4eStH+QVjrfr62wf+wyxpa50kvO5f0ROp0x/zVVwjXZe5GK2OANnWAssm3yYIu4AbzBkIrugfFEzFwlb8x6k9fyvOqnYY1VDYHvRF2YSr7uwQP5OnSOEWAVXOF3x9MhdWOXnp6AXAk18iBKIt3nOmztkHmCmoKT/N9h7YwKQ0Krmm+BffC5l1ETdkXF7IZbrLYGkLEunMUXqe3IQu3jMjkAwLBriEYiLJhnPGVYSG0D52FJ5wuKNQbl+K00q2FrtWVReIdMEhbgTIgZdEr/fwE4KCKyiGugixUYKm/g==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Wed, 26 Nov 2025 00:50:00 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 00:50:00 +0000
Message-ID: <861bca05-1964-4539-ac69-f3afc82bfe99@nvidia.com>
Date: Tue, 25 Nov 2025 16:49:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Jann Horn <jannh@google.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Vegard Nossum <vegard.nossum@oracle.com>, Harry Yoo <harry.yoo@oracle.com>,
 Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
 Yafang Shao <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook> <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook> <aSTRsIUPeT5EC5An@casper.infradead.org>
 <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
 <aSUB1qrfhXp3suGn@casper.infradead.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <aSUB1qrfhXp3suGn@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::30) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: bef19c01-0293-42cc-8b96-08de2c85ba28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTM5RVg3SUc1SGpJZHBHYWJkVmJSNUhJSElqTTN0QUZLUmtiMXdiRWlndklq?=
 =?utf-8?B?Zno0UzV4NmJvUWdBdU9vU3RxaGk0bzZPTzRlUTU3UlltenBMZ0Q0dC9oTmg1?=
 =?utf-8?B?d1dsSXVWbTVIK0UxQ3kzcFZSK1V4RlVQeURMT3kwYUVlQ1ZiVm04b29ZeVp1?=
 =?utf-8?B?RGkvbWJIRWxJUVg5cWtPM25VbkJSWmxuR3ZWRVlTVDN4NnNLNEx2WVQvY2Y3?=
 =?utf-8?B?WG90cWNuZVBOQTVtS1dBdFl3VHpjSVd3WjRVV3h5NXJiUktObnM1ZEFJMDNY?=
 =?utf-8?B?M25pZ0x3anNwaG5CdDBZQzRRSkJLYWRqbnJtSFZOcTFhM0F2c2U3RFJlaytY?=
 =?utf-8?B?RDlPdU4zaUJ2RlJTUktkVHNyL20ya3IxeUgzOVdwRkE5dGlTNmV1Qy9sU0or?=
 =?utf-8?B?SnBRUGhmYkNUZnU0RzkrZU84aXhaSUwzaTBOMExYeDN2RzBzc0NvUzBpd1pQ?=
 =?utf-8?B?eE1vT2w3Y1FtOVdqNVA4eUhBUDdzV054aFd6YjRzWVRmSUMxazA1N2lCcEFN?=
 =?utf-8?B?UExHSno1bVNjdEtDQjRiY1lhdjJWZW1VQ1VnUHkyZEdjZENtZDUyanFiZ3Vu?=
 =?utf-8?B?TmlHWjhhLzFna2xFZ200YXpteG1hdG9wWk9SYmEwSXU2ZTYxaEJsMWFtN3oz?=
 =?utf-8?B?bWJNUkhndWtMdVN3LzZ1MFd5MG9xcE9nZ3lnODFOTWR2NUJIOTgxVEpqLzF5?=
 =?utf-8?B?SDFqcFFyUUVPY2t6d0tMYW9ReXk1NlU2NE9rUVZIQ3pOQjlHOEMxdUZpLzhR?=
 =?utf-8?B?eUlpMEo2b0tWZkE4aktaOHp4dklkSWJLcHBnRjErcFYxMElZQ3g4d2wvWXg4?=
 =?utf-8?B?MCtzc3lzVHVpUWhReGtPTWZyUjluTVlQZVYwWGpEcVlMSEZ2TGZIdHRseERx?=
 =?utf-8?B?dFpiSGt4K2VuZXlHOUtaWXJ2dGxUeGo5Snp0T2JZRG50MFRmbzFDZTFXNEp1?=
 =?utf-8?B?RFN5TkpXMFpSSFVTZENDbTUxSG5tLzNkbmRMaHZRdHRiL29NTzBiR3U4UzBM?=
 =?utf-8?B?ZmRmaXJGQzBHQklYQjhHZ2pvQlZPYThPcVNBaUlLRW01eGdBaGJ5TXowZm1z?=
 =?utf-8?B?Qnp4QXlPY0N0dEF1eWVFTlV3ZWhucmVlN1h2dk11dFJFZys1YXZqb3pIeXpL?=
 =?utf-8?B?RzRpRFBxTkcxYkVUSEVoVit5T1pBS213bi83ME9ZNzBac1BGUDJWU2FwZWNz?=
 =?utf-8?B?cUJIczdyN000ZmFQK1ZiSG5qRHRaeEpjTkVwQ0RIVFhQcCtMUm9UdUY3OXVI?=
 =?utf-8?B?bnVEYUFmMkxVOHBnbnpoOEgwR1ZvNU8zRHdlV1cyMmg2UTJoQlhsUVZzUERT?=
 =?utf-8?B?Y0dFUjVOMW40eklNQk9vOGJaZUdSSkhNV2hRZEt5MnNkODYvLzhhNXdwWldC?=
 =?utf-8?B?S2NIWXQxWW5MbUo5MzNnZFNmTk9xSUtMYlV6cW9GMUMxT0tQVkhVZ1pYSVNR?=
 =?utf-8?B?MUswT1ZXaVFSdWFRWEVlOS80dXpIR3ljeHhnWUs0Q1cwa3hQMmQ0YVBhQ281?=
 =?utf-8?B?S0hnWUZNa3lmOEFmWUFiUWZuaW9PUW9hZWFBdzd2d0pQcUdYbnB4RTJVU2VZ?=
 =?utf-8?B?bnk3aXQ0MEE3R21tTElEWEhURHlYUjFRcXU2cjFNbHB6ZUYvcUYxNkpFWFZq?=
 =?utf-8?B?MTRtR2l2M2VXWGNZZVQyMElSZVVqMVBsUDNFRmF5SjJoL0lFd2RJZnBlbWMx?=
 =?utf-8?B?bFBmOHFQQWg5OEdNUTQzdDJJSzE3aFRjNW1hclhXZkQ1cGwvNHRyV1h5UUJZ?=
 =?utf-8?B?MWg1dDhnN0ludkVJTHhEajJoTWQyUjNjQ2JFdDZVcnRiZmx5UzByYS8rZ05Y?=
 =?utf-8?B?RnFLdWU3SEVQTm9HOVZSV0dNTG5CTFhmRE96VXZrak1CbE9WT01wUVIzWFpV?=
 =?utf-8?B?Z1VsMXE2WHNtMkdQUTdGMFhrZ3BxaHlqQUVMNzBNWmVVUXNrZVhLTVFTakRj?=
 =?utf-8?Q?gaqjEibINRFQVpppdPR0VgWnLYsnwRt+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVhJaGJ3UUZBTHFJWGkxRmt3b1NTalBjNkhVcWJBZ2Z6Q0puY3h4enlCT2FP?=
 =?utf-8?B?ZmJYK3RPcTVhQ29RSFdVSUVhQzBtMzFyNzlQMG5Nb2pVK1VSY2tJYmZMV0ln?=
 =?utf-8?B?ekgxK2VuamEwbUladzZEQzNSYmRRWVhjbkFrTFo0K09ta3lYWmFyUFVYdWox?=
 =?utf-8?B?QVBxQ3ZoU0tIaTlJdXllSGlRbHRnWnJCZWkzamxRdWo3N21lUXdHbm45bUFR?=
 =?utf-8?B?L1FlNzlJVEx2S2VRK3pET2pwSzVIYldRS1cvbHZmMS9EZlJqYWlBZmRGbkp3?=
 =?utf-8?B?TU4zRDdyckE2a25Gd2tLb2ZIRHJKZ09KUFlSWUVOdy9wOUhHUjNicTg0WXgy?=
 =?utf-8?B?aXpUa2NXQk5vVUYrTHFaeHdRampoeEoxTVJqQ25DWktYd08vTk5XWHh4WDN5?=
 =?utf-8?B?aTNEdGZZUTM0NEdremt1R0RUcmNjQndQWGtUSE9FQ05MYW9KbHVLVXZIZUZi?=
 =?utf-8?B?c0dZbFF3ZmM5bzdRUTVkNUpPcEVRSndwZFBhYUtQV2Q0bVZyRmVUSXZ5aGhD?=
 =?utf-8?B?UFd2N0RORWNzV1VrbzB3WHBGbGh0N3c3VTlBL0RpNFpMRklKZ1NuNXBtbkQw?=
 =?utf-8?B?bGVvY1lWMXVuVmpRdVZKVGtxM1NDdEtFRFdsb21VNjJpNDNaRHllLzh2SVNJ?=
 =?utf-8?B?QkJUVE1TTDhhZzI2QjBFdzFvTFNDSHhGQnhOeGdNa0lQdGMvSy83bk15UXV4?=
 =?utf-8?B?MS95Q1ltUkpKZFprZXhXb2xINlN0QllpUFZHRnU1bTNsbUdkNzUyK2dWeXM4?=
 =?utf-8?B?UEdWcEpQa2luSzhQbEt3OExKbXdrdE9xRkphK2FnaXAyQlJRc1ZjeFFZTGg5?=
 =?utf-8?B?U0ZsRXdXZ3BaTHpiRUQ2QmlDWW91TEt5aFlHYzY0SjNJZDU0SUMrM21yTGxQ?=
 =?utf-8?B?VVJ5cEN3OUgyY2M4T3NSZ3ZwK2RWUTZHWHFxbE9UZ0FFYmlzbEo0R1Z0UVNy?=
 =?utf-8?B?SUJLdGUxekpDeVNDaVZrSldsT2ZhdWdhTmEwci8weXA0ZnRESU5Ba2dicUUz?=
 =?utf-8?B?a2FLamMxNmZYbmxHRXc5SXFRRVhXQndEaXMwYUxIVy8zYldqbDJKZXdCRmJP?=
 =?utf-8?B?aDJOK3YwSG1GRFI0Nk8yQ3FON3RiOFRWTUkzS3E3N0VDa3I3bWtnVHA2MVU2?=
 =?utf-8?B?SytKa3ByV2tUS3oxcDBaT1U5Q2hPM0pFUkV4N1Q4UEQrdjNMalNmejdNQ1Uz?=
 =?utf-8?B?K1NhaDNQTzVxaDJhSnVwVHB2algyZFFhZXZycVBJR2dUN0xEcDhaaktJQVZi?=
 =?utf-8?B?bng1ZWZKeGVnNFgzYWJmdDM4SjQ0SSs4cmxVNUFMY2E0cHBlVG9FajhoNDcv?=
 =?utf-8?B?N0FweTZQY0c5VkgyVWt4MEdTa0Q5Uk1FYzVzTTNtWVo3bis1WUFFc3p0b2hu?=
 =?utf-8?B?MjJ1bEs0RTVQN2MyaVROR2JhcFVFbUdUdWdpSCtVekF2cUZPOEtvbk5udUVs?=
 =?utf-8?B?NGJ3WkhxdXFLbHdvbDdlZ1EvOCtJMUlOSEQwUWhMcHNNSHBIdVFqbDBWcDNU?=
 =?utf-8?B?Z2xldFUrLzFCdkY1M3UyZ0Y1amgvQ3lsZlVTb3pjNFhOWExIRVRHWGVjNVpE?=
 =?utf-8?B?RW9zS0dhWnBzeWZNZVlJSWJrU3NGb21ieHpCd1FuUGpYNDUyVnVzSnNQQ2JJ?=
 =?utf-8?B?M1lDaEVaUjdGUTB2ZU91Nkw5N25GSnYxUVNzdHFSaGlEU0JoZUVYamJrZmZC?=
 =?utf-8?B?a2hONDJjYjJNUko0OGVrbmphTnMya3FScnYrcU15UldqdWwwQkVpZGpyQzJ3?=
 =?utf-8?B?K0FRUEVWbVFzTVM1eHVGTmZwbG15Z3h4cW9RTUxLeTZkdm5paW1vbUVEOGhw?=
 =?utf-8?B?bDY0eEhYU0ExalJ4dVZlOGdTcThha3c4eFp1d0gyREVtN2poSG5hWDJqM0Vk?=
 =?utf-8?B?WndNeTdmTGt4bU14MHVzTkg0OCt0clpEUjdzMG5WcGt3cDRJYno1RzBCdnNT?=
 =?utf-8?B?U0t5RkMwV0NkMnUyY2hMNEdTMTBxbG1LcEJzSVAxZHFaRE1YK3ZPdVRJb1d1?=
 =?utf-8?B?TnNWTHZLWkFpSytldlpkaXh3a1J3ZlRyeG16MHJsK1pyUDFsOFRmRHBUTWJE?=
 =?utf-8?B?ekxEQnlRS0dQditpM3g0YnVKZWJHVUY1bXdFVmJvTnVUMzNMQkdaWFFyeUlh?=
 =?utf-8?Q?Kur/aS/n8MEPoiRbkUbZbJx2/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef19c01-0293-42cc-8b96-08de2c85ba28
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 00:50:00.1233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMLkwZQ+/hVcgOev5Pwawbscmn+TUK111Mp6kH3e+j3xsh2Y4DTdJ4PqMCRxoKqGj32rgETGmpsL6xSwIqHcUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015
X-Rspam-User: 
X-Stat-Signature: fs3g5butet8rdbhq68c4qoh4ifffgxw5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4EC3C0015
X-HE-Tag: 1764118203-680505
X-HE-Meta: U2FsdGVkX19nHpAuubjRBBA2wyAlEYF/mjvEcxA8HYHIpuD3KMagHR9d3hlsRynWYb0AQ41lgvotJ13IbhLO3vQTfVwbdyTdxVQTviYm3KaiAxEoPD2WDIAiUwlc3iKbmYIeO2ChMz7XbGXjD36Hs9pCTRUuq77nJIslKaaXINxxvdGJ4GciT1JvE3/TLTbQotpZIHXK1OGTrJHQn5YbLCptsKjJuurDZ+aZVp4fNhjPxkm/yprSdZyXXV/dPtj90MjUrPIhnpvOSNrWxhUJjkHi1UwK01T3L767kPApJWuKfijBEWpgbFguxCxlFJ45WoRymzlLrKDJmKMq+oEToquzmi1kTLQWEMPa8e+b9aPmp449lmIGOAhp4R/F6gOjvtdcyd94CmAeR3xYphq48dDSps5rZCeuFKzHS42Ywla88IpiFCCqfHtK8v79Xu+JGQjHwyZNME+vgXz0dlmwIpm3Siy6nqyNQKMyu6iNi8RSpAf41Kh4gt7caMK2Zr6SmomP7I6CfX9lrZi1UiAFcIYcUsOOlA+k75enBNjSIt2RwO8Y3GpOk7t446QBTniRq3JeWfR+PvfUGsOYmtVg5wAHeBmNfo6HpJ1aMpqfSMim3ECrGvMp3q+LBuI2U4sSfJpQYivwGuxR+vzwK/+dyDrWqPQ+gxeNT/PRjyV97XdNAC0k6WrRedrIY3RFgSIWckmA1XVpkxEI45B7vv7oBhtlvmN5Xv8zva0EAqjAc0l+1LxP/pc5Uwx/Wy6r/GR4K90dbEEaUlhMUB1zTWD+NEZ6W92IoPHFMJm6PKDtKilG8CShoDf/VWFgNbEWisIRu5f375yW7osGUrFCHCbvvxGLrTG0bOlyHH8AVo8numb0Reath7big4dqoFjnXFoOAprDtVuS6GHrvOmrhPgO3vchz/knWngTjxcQnMxD5qHtWYjjz9NhTvKUVq0SMzfaXIGPwPsNnCRmTm1odGf
 kHuhHcZM
 iWrBoTqSZRBG5kZZy2DPuD5AH9wSwzE2bJfQog9/vH5oRk17DXOK2DL6VRAksve8R/vMI52gVhVp/g0a7CekaAiu0VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 5:09 PM, Matthew Wilcox wrote:
> On Mon, Nov 24, 2025 at 03:30:19PM -0800, Linus Torvalds wrote:
...
>> Imagine how many other places you add integers to 'unsigned long'.
>> EVERY SINGLE ONE of those places involves sign-extending the integer
>> and then doing arithmetic in unsigned.
> 
> I have bad news.  Rust requires it.

Well, yes.

But the pain is front-loaded, so it's not like we have to go back and
retrofit anything.

And I also want to tweak the characterization of that, below, because
I suspect this is unevenly understood, so far:

> 
> fn add(base: u64, off: i32) -> u64 {
>     base + off
> }
> 
> error[E0308]: mismatched types
>  --> add.rs:2:12
>   |
> 2 |     base + off
>   |            ^^^ expected `u64`, found `i32`
> 
> error[E0277]: cannot add `i32` to `u64`
>  --> add.rs:2:10
>   |
> 2 |     base + off
>   |          ^ no implementation for `u64 + i32`
>   |
>   = help: the trait `Add<i32>` is not implemented for `u64`
>   = help: the following other types implement trait `Add<Rhs>`:
>             <u64 as Add>
>             <u64 as Add<&u64>>
>             <&'a u64 as Add<u64>>
>             <&u64 as Add<&u64>>
> 
> so the Rust language people have clearly decided that this is too
> complicated for your average programmer to figure out, and you need
> explicit casts to make it work.


A couple of key points, though:

a) There are many other, better options than casts (Rust's "as"
keyword).

In fact, Rust doesn't actually require casts here, but it does require
something to explicitly declare the programmer's intentions.

b) Rust doesn't do this because programmers are too dumb to figure it
out. On the contrary, programmers are required to specify exactly what
they want, in the first place.

Some examples, using Matthew's example as a starting point:

// u64 add operations:
//   +                          - panics on overflow (debug), wraps (release)
//   wrapping_add(u64)          - always wraps
//   wrapping_add_signed(i64)   - always wraps, accepts signed offset
//   checked_add(u64)           - returns Option, None on overflow
//   checked_add_signed(i64)    - returns Option, None on overflow
//   saturating_add(u64)        - clamps to u64::MAX
//   saturating_add_signed(i64) - clamps to 0 or u64::MAX
//   overflowing_add(u64)       - returns (result, bool)
//   overflowing_add_signed(i64)- returns (result, bool)
//   strict_add(u64)            - always panics on overflow (even release)
//   unchecked_add(u64)         - UB on overflow (unsafe, for optimization)
//   carrying_add(u64, bool)    - multi-word arithmetic, returns (result, carry)

// 1. Wrapping: overflow/underflow wraps around (address arithmetic)
fn add_wrapping(base: u64, off: i32) -> u64 {
    base.wrapping_add_signed(i64::from(off))
}

// 2. Checked: returns None on overflow/underflow
fn add_checked(base: u64, off: i32) -> Option<u64> {
    base.checked_add_signed(i64::from(off))
}

// 3. Saturating: clamps to 0 or u64::MAX
fn add_saturating(base: u64, off: i32) -> u64 {
    base.saturating_add_signed(i64::from(off))
}

// 4. Overflowing: returns (result, did_overflow)
fn add_overflowing(base: u64, off: i32) -> (u64, bool) {
    base.overflowing_add_signed(i64::from(off))
}

fn main() {
    let base: u64 = 0x100;
    let off: i32 = -0x200;

    println!("base=0x{:x}, off={} (underflow case)", base, off);
    println!("wrapping:    0x{:x}", add_wrapping(base, off));
    println!("checked:     {:?}", add_checked(base, off));
    println!("saturating:  0x{:x}", add_saturating(base, off));
    println!("overflowing: {:?}", add_overflowing(base, off));
}

// Output:
base=0x100, off=-512 (underflow case)
wrapping:    0xffffffffffffff00
checked:     None
saturating:  0x0
overflowing: (18446744073709551360, true)


thanks,
-- 
John Hubbard



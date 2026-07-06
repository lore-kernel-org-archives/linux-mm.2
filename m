Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82F9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43946B00E7; Mon,  6 Jul 2026 02:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5CD6B00E9; Mon,  6 Jul 2026 02:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94D36B00E8; Mon,  6 Jul 2026 02:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 761426B00E7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC0DC402B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:19 +0000 (UTC)
X-FDA: 84957420198.12.C730977
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A5A880003;
	Mon,  6 Jul 2026 06:47:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=NtLqnPgt;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=dQ3u2EIA;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=6405674cb=Johannes.Thumshirn@wdc.com" designates 216.71.154.42 as permitted sender) smtp.mailfrom="prvs=6405674cb=Johannes.Thumshirn@wdc.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItddMh7QtoZjS5vILWI8C4XxIbFtqHyNGrTCnDBnuSA=;
	b=kVZBabuy4oZT5Jn9QM2b1bARsmv0M4LrQTeraPBhrV71ADVUPt1q/VXI04/LmEXdqPyQdA
	b6jR2nho9isnQeSAbbnnQhj5Pegg+G08BQO+M+/pcE1iSAg6WHHhVDsVGfwcP/L/G7LRz9
	ciQ7gPgPUZW965R17uPef6j9f5+rrXg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=NtLqnPgt;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=dQ3u2EIA;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=6405674cb=Johannes.Thumshirn@wdc.com" designates 216.71.154.42 as permitted sender) smtp.mailfrom="prvs=6405674cb=Johannes.Thumshirn@wdc.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783320436;
	b=UVNI8ATA/zdDzVHWni4uhUBKP8Klpzgnjs3/JoPrrJrw6VnQX1TR3pvMXRdZ5rmLx0d8oa
	M4ax9rkLpc64WDrz48bN3eFcguGglEIMeaSGPsdRDJ52QHWfOaGdsoUftFzBryxC8XwtWf
	FnJeeSrKzbsQRnjnBtF5dHgixWILDmc=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783320436; x=1814856436;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vTqIds18UBzmaVqkjahJWhDGr/u9SJdme48te8Y8Gj8=;
  b=NtLqnPgtwbUv3MCREHuiBQ16UDi9FDR4ryYjkImvEMBRz76BnRtaLdag
   X+rdOM2driWGV01dFxUhV1JUd8fBCGIBJUkVFLYLsrlakugHdolaZpc5E
   xp+ItVfnjV9qVk5oOcd6rippocUy7pMmreEv79Mbiiadpk9ZZOPpu+Wq5
   MnhWhA7QmWn80ivy+9uwiiYpVckfoAZ3YbYJTG03y0cSTD/4jXI2kHtoE
   EnC/6izeMOiwa1tQVWq7b0UUjU6e1RRFkOMRzGdC/icjsN808FxaxgsQv
   zq2LiCXSa3Xjg3eyMSMLS+xPf9nFmDdL39npl4+ATH/2QIeI1yo9MNdSp
   w==;
X-CSE-ConnectionGUID: hZg1rIVYS1avvjTgM+pmaw==
X-CSE-MsgGUID: TD4A5mIcRFm1mCeJ9k6CmA==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="146292982"
Received: from mail-southcentralusazon11013071.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.71])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 14:47:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6brQA9vtLHXIpZ1h3QDa7Pa3POIdE1oWJdgew7iOdM5IkrnqgpafpnBIS4oedhwTBFN9S0eafUSlq4o0dqKGhV0JGUrXvTTDtDCAJkilTmaglM1W092Ma1wTssTeqqz0uLjkT7L4B7/ZxlQecMyT/WywWviYlHcnhDJcJuBJkRlw+E0VGZg46oyASs+DXxZc4uW8OYszh1y3jkBl8rziTrej24kB4grEy27yfQskMdyXNs71sBwRC4QLcXfU38r2VBiBRLS184oSEW6aDp+OlniGg1jSlO/PQzwIlL6VlJt1GWKHqg/TuMeI46ZxQG+YwOYnmoU6k00TpK1VI2XoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItddMh7QtoZjS5vILWI8C4XxIbFtqHyNGrTCnDBnuSA=;
 b=tc6k41ql/Lz+L4CspHrBzjKf6Dk/mPtIldYDX8nJICNFp1fFfH7Dg6mj2kw4MyBnlVOVJpqQfv1HSOoJ7v+6VjUDEq+SSgILNKwB32o2a6K0Oc78a+xgSC+L0CnNC2Ox8Y/qeCAU+jWHCONhRKTusDenjqjVtrks5p7zyGqlwZj6U2mWXdUa0aHfiUtnte6BNCsLiAeqPs0gKAWQssWsuY8a6VbPVMSn8FN5avBoxml+q60pIkdx+jxVT/yLf8aL5knMxGCa+Qdaba0Z5DAlcFnEEoi+5xGHWEGFV4RyZGCdpl9YU50zbgzwkaRVLffTxN8j+uJAAoysfVlEzmSBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItddMh7QtoZjS5vILWI8C4XxIbFtqHyNGrTCnDBnuSA=;
 b=dQ3u2EIAODfAjJeali3jNKcgjC7iNNMeRhvV4VlXXYeQ9fqYe0UuEqHPaEKzB7yERGxytuK/Ga9vawMfwTCoZ8B7tN9ShhGDvRdIR4qJvbgNrsULGrruPEGVYYKvb29z8G/l505wt8pU3aTDIzyBjWhXsOKDXd1XH00xtBquFsQ=
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6957.namprd04.prod.outlook.com (2603:10b6:208:1ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 06:47:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 06:47:12 +0000
Message-ID: <2147452a-109f-409b-81eb-4a4d3a83cbb3@wdc.com>
Date: Mon, 6 Jul 2026 08:47:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, linux-mm@kvack.org
References: <20260706041125.642097-1-hch@lst.de>
 <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
 <20260706064547.GA25268@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260706064547.GA25268@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0230.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: aec89f1f-c2ff-4330-78ab-08dedb2a689d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8XgjJ5gCoRvKS6rlwEP4yobp+8QzQ1G6LL5Y31javczvm+jYU0WibBMv3mXupFXnKt42FwozkxgcZaIn+lfp6DOMPxKkf5IBGfmrpXjUz0uemS4zUIyFfufSFG9UTt4rg6AkYoovXuiVXqWqVpo+BqWYZ8gBDQhrQGjdjeTfbddX6bMEnAk7vf6JpGqyYtbkgCtxdDUeQ8VNtFKyNqjuw/IFFQBsSLFLIAIxyFoEH0CJHA2FoK3WMipkwgMW/ho9fv6mY0iTlzLmBM3hYG93ybl1kUULQKVhyivL43e6Kci4MJb6/UuI5KQUbo1IYKTg8LXQx4AW7EHYYNqpslSOy32b7H38V6yKWoq0ZYRU3zrLjdMioKfzYvfIe7eU6s2gvSwzdtuD16gk5Erb+G+TqK6mWPDJJDS3mPwNYR653EfVnbENT1MCXJ5JTSeWyEQ68prHKQrfdTbMy6r28FgLOvBlSGFX94KAgJQDI06fBJThqTDWHlbauMac7qWm5m+oPhxwRYcpqTh5qy4/EoCtHZ9iPTzrjDEzhyXYjSzP0rdqRVsBt0/ACkG6zxqsRbgY4EGgaOAep2DNx2ZnV+2hbcqF+wklf6cm1xXARUXePOvtRXu99JDUlO6BuPkeGOpMwLMKlAQ6jSimFI6vQh0g/9yuG6ZfN8oIm8Svca+pxH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1ZKT2ltbTdobFk1bFRWWmJTMU56VVl2UXlqOGdRUDdoMW1EYm03bHBLNTc0?=
 =?utf-8?B?V2VINlNEck9MRHV0MGJja2ovWEtLT1BVQk9sdHo1VmpNZGVzRGJCclJEWnNT?=
 =?utf-8?B?VFFYVjVTdTcvQ3I3eU8zZ2FDZ1YrVmdzSkdvRFJGaFBGaXMvY3RSSG81d2JU?=
 =?utf-8?B?V2I5SjY1dThFUWV4UVI0QlVGVEprSW5pMTl1MHoyV0krUU9ZeWxJRXNQUXVu?=
 =?utf-8?B?QzRGREhGc1A4VU1UTW5NOC8veEtZejg4ZGhHYVM5NXlKYjJwcnJOVTd4SkFQ?=
 =?utf-8?B?NzdZYUVyUE50cXdmSXRrQkhPbkhrU1dOOTNmVWZ0Wi9sM2Zwb2FhU2pFZllJ?=
 =?utf-8?B?N2tpL28zR3Y3WFVmQlRlcXJ0TS9CNUdaUi9UNjVZQ1hHT1VxTnRrdE95Wmxv?=
 =?utf-8?B?Ujg2ckhOVXZqNWJxd05vaU9YeVhkRkpGZ1Zlc1NkTnNYVjNFMGwxbmVsbzZS?=
 =?utf-8?B?czNkdFdHcGp5ZDNNN1FhSEUzWU5FclpjUUdwQVg4S1owYmsxdlV5S2VEN2Ju?=
 =?utf-8?B?ZFBWcmd0UktLb25pd1B6MWRySTVsdUpjeVZzbE1NbjVNV2lLTmpFYnNNU0l1?=
 =?utf-8?B?bEdEMFVnSUxKN1R6aGNhc1BDVEgvZmtiT1VkOC8xTzA3aW9wY1dvakVRUldx?=
 =?utf-8?B?V3hJRFUrT21FclROM0xOWjFuU0QxOWFUY3ZEZW9CRjRGMWU1WTYxVEhINmc0?=
 =?utf-8?B?UnZaSlFwN2FOQ3p3VkcwRkZxSUVxS3VGLzFCSXI3YlBjc1BPZEZKdWlhZjE1?=
 =?utf-8?B?OE1ZcGk5dHJLd0M5UGg3RVJEb3VLMWVWeG9RU1F0TGVLQXFjeHFWRDNjL09r?=
 =?utf-8?B?ZjNhcnUwYU8yUm1FYXdMMTA0U3FsOHJINjZDL2lMRUJheTBDVjNkazlWNFZV?=
 =?utf-8?B?ZEpOam5jemZZaFQ3cVRTbng1QmV3RnladjNOcW1JM1pJb1BsOTA4NStKeEEw?=
 =?utf-8?B?T3NHZlBMUGhlQ1F3Y0I3OTViR2V6ZzZSTmxjcTNaOXB6NG56dklWR2s4NmM2?=
 =?utf-8?B?SmFtYjdVNTN1VEw4R3ArTUVTWC9Wc2tzYW9MODJVTTBwdHNVT0J2ZU1BWU0r?=
 =?utf-8?B?dE52alNYTDBqM0tsejlyczFidGxCYjhJSzNVbERtaStwcjZYUHA4VWJ1WG4y?=
 =?utf-8?B?UFNleHNpRDV4eUpjRlNqMmJRaUlJOHlkSS9lSXFUVENTRVRYRzV6SkErVzk4?=
 =?utf-8?B?ZGN0WUF2ZDhQQXlrNVBVN25LdE4rWWVUYkNVdktvUFYycGdzMjNjY2tYQkxi?=
 =?utf-8?B?QjNlNnpKZ0RDMXJDM2lJZzFBbUcrM3BGRmprc2NTcGcwU3RVSi9EVkRZOWFx?=
 =?utf-8?B?YThNcmJtcDVKdGFoYUpEVVBpMjhTZm1HV0ZUZmE4ZmhJL2k2UVYyaHgzNXMz?=
 =?utf-8?B?amx0bTRGcVVKaWFuYzFZTTU0Q3hzbVlJM0FhN05xd0dPR1RHQjFGMjRkMlFt?=
 =?utf-8?B?M1FoaGZ2Z3kyM0gzWWJueXl6ZkRSbWZrVExaQVh2NHpMRnNNaWh5OXlPdURI?=
 =?utf-8?B?OGROU3daT3pHdThKRmtncmIxajFQTnZBUXVoRFpIVXZhMFBrcVoxRjVlVEdV?=
 =?utf-8?B?MDdsd3J3dVBMamZWZXFOVmQ1OW40TkEwWnRyOGFLZlZ5RDJXY20raEoxNjJ6?=
 =?utf-8?B?NUtzK0FVNG8zUzVpVVhLUEpvbU9ZRitRcUhPYzZhMHhyL3RGaU41M0FRdVRB?=
 =?utf-8?B?NlQzSlZxdktqZmF2WVRKV3RYZUJUWEVJNDdyYkdtNGVwUmNzUUVvYlA2TkJw?=
 =?utf-8?B?Yk5Qc1hTNjFtYko5cWd5bjh4ekY4cFpHNDVqeksxYlZWbjljOWtwdnViRGM0?=
 =?utf-8?B?OVdTNFgxbGIzK3dLeThrTExaNGIzZTZJMVQyNUZQMDh0V05WRTY2VGgxUU9l?=
 =?utf-8?B?bVNreWdRRllWQWtvUVlWbkpJM21oRTB3QWl0dGRVSFdhYUE3UnNQNWxGVjMy?=
 =?utf-8?B?bHVqNkxCYkZtdEt5amQ5MUZXRHhUOFpzNzh4aGVtWVlUMWUvcFR3K1pvbzZk?=
 =?utf-8?B?cFl3LzIwM3VQVytsWmRERkZWZ0haYWgwZDFHeVE5U1RlbGV1UE54bXJnQ2wx?=
 =?utf-8?B?SjZ6NnJsZ1daNU5GdVRrZVRyTEtuc2pUZXFqcll0QjY0K01qSFA5K2x6NC9t?=
 =?utf-8?B?TUdjaUl5dFdWZU5MSnZIUGRNRFFzZlgvbFJkRlNBVTNJbE1OZTE3UWFhM1kw?=
 =?utf-8?B?MjZRdmVmQ1gyRTBycTJKSCtpWHNCaU56TGNtVUx6d2g5aEpVUmx6ZTBPb2xp?=
 =?utf-8?B?cWZvYW5jYlpqYkZlZlVHK1lVT0VlUDByd2dScFhMWFZkcWhtTC85SDRmRDJl?=
 =?utf-8?B?S0R1aWRrTWltZ1RZZVpCUmRLTWxnN25PQlY1OWY3TEVDQ0Y3OElaRFRkVWR0?=
 =?utf-8?Q?dG6CtYkTkGKPwoFc=3D?=
X-Exchange-RoutingPolicyChecked:
	mlg/qZ3cj0K+j2yMWTXynLoCq4DdrG8vk3kqtUT3X45iYUDSuiGrlPfi+881FaaMrTCn/fDsJpfhcgHBBCDyWYuUtwg70mZRyx0x9Cj0Lium3hCTuWSjfMk7K/chyZOKAwohls8Wpa7eigEZeQgA2cAd5PUOPWE9+MkvPy2PWCH5icpvE19dfs1CuGhX3zTQTFMa9i4vOrnslVWnRupgkg3h3Si5/7/wnIqSaPmBHjjbv7hXOoOQy5ME+jFytYcEFNue9s8XFFy8m6nUOPS7mxQrZt6rcL4VjbDq2eiLmj6QUZJTXyBrX70IwDtrniuvI0K5Yd4WT6O4sqNx0F0buA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JE0NzH9DK78pVP6GCB7DITIqzOyvmTA0DiQ0FWSnRVIFJ8AKoDt7eiQWLk4kFOQ8atABP9552f3wMmqMSmdR259ZEx8o2PxY//4da1hIvFIUzN1h8VKg6t9RBfLvmp2gpJFnJ7enlWn0J1k68HHTZi+QMjFB66xnkWfF0a/W7gTeyj+ZpcvvABr2oHsvmihuAlvRwwI3Wwn6iIO1luOCfH+wJrqqFfww3QcFp8Ya3zIItoB/XiKBVxyKuDjmNtr+FEcZTU6XWaaO3Xv9pWDgUL1mHp8J0C7BHj2f3Lllb2uWKTdXWTUm7dnaJy+HIJq/GxFJ6YdxBQb/INrlaNHPwdcHJZ1dTX1S2VhNrcl2dthiIRkIOpaRiOfEXEk7D46/dVR5QNG6Xl8f9TGsCZNz1dDqpgEyHgxiIXyx07nL8JqGMKh3qFBLPWRFrqdb1RozpNS+Gb20HWwR9kohSplQx84jjgjpXQWmwA2SyeoMERV8RAgYdlUJZ+FENibUBL9M3DGgVgTOy46SpbkOX4tUwv7wX8i9vIfPBGEYKtT2RZDck8Y+ozcWpfIPbaiUFkKb5h8LzG0g+CaIU7OtceAYLJ+tFvRjqMi+lhE5g7T28MvboLXxgOBYN0GMJ5tfFxLr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec89f1f-c2ff-4330-78ab-08dedb2a689d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 06:47:12.5223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9mlx44bkQDRtZrnVGGKQwWp3e7blpSDGC1xSMcDO2UPEuJwkZJCiZeDVJpCAGPtrt5jcin367KrUwMDeR7BR8SR4ZR5simXTLlBhdJMGS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6957
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A5A880003
X-Stat-Signature: hnrrzcg459ub4rid3iy3h6d75rspurkr
X-HE-Tag: 1783320436-834112
X-HE-Meta: U2FsdGVkX18kklGlfqfm3ho6VTTRRS35AbcOphnntcQ2XoZGgZpOXsctdwblrFffbdqq+kaQXkUapuV485WCHdjLBJaH3lo7So3eBau9tX6CUIQUxXXcXcF7dGdu6pCzo5KwxJBZvY0IA+GsArFcXPu7yAE7lP5Ig8RzJ+Ueqqk98UoOMK2JUa68I+2AxY0FjOOfOJPhe5KHWTVEVAMugAEtCcEHaWqvAJjf9MleHitnIZZqP/6OmSWam1rCF3fYCM+ZLFZlSJKPgC7kGA32lrlROj0E7HgWFxDONGENQs4O0CyqwFRrx3AOqJAb0+SAE2aqPpMo7/NYfwLdN3RQTAkcGS7jP5Ib7xptkWjoVZ4nEc2Gz/St4vS+icheUbpjNp3tdoiAqJprEDDm8wh+h3k56OxM0BwTQKJVzAXobNZEQLIe+Nu9bcKeJS6fMUIHV6ROvKUqNVKpC/Pa1lfWpPu3sS/9g1jxKUXq+Y57FP2vLaXa0jIGVanF/gjtAn/BNk4CgEilvy7qqx0g7HnYcTcnKwStNGxw3jGbihhZgwf+kMowu2Z+tSChkBtsigRrBFIy8g6dfxJvYbQ32gbn60W4/RZUzM15WCCJsaEy+gBOwVQo6+5RWQjS1ZwK891A8lUo1uXeaH3OlEao9noxlkje+iaJjqxS/vERK0bf2Ot6OQNojGff1TKCzclgup5zQIYL+cfUr24h0uq+R6EEjaIZ5r0Zhtt0iLQKxEz1hJO+i5omEDJQquyOgRHjiStdl29rSFoP4gWOUmIrlyKmkuXjk4IY5TycUMPpWmhE6rbUpbDuXy2BgpuPDpBK+oH5F34ob2RE0pZFjYy9V1E8OTx+qR7AJfpaKNERkUkKm3aa7c1A2fi87WiRkok7bs0Cf0s/NWNYarAg/KUPYwM0HN5jjwx5dea+BRXbgVBnoCXnqCBgU84r8Q16w+C+zXXHGthaf0fiWXKTUbQ8HB9
 j45v5ggi
 7bNxD3kpLMhB3sphq1xc1gFUU2h49KjBcMbDMhXfW2f6Okq/ILLCqbAZ6Q8bBW0EtYjEuH4hHO8pCHS9aAbNLXeuxyjDcUoUFQoqqQpVrN0iOoEtunm4FrP6P0j+OiOPFnAAnJBM7vhaL64YJo4WVXdR8lgI0HFZJZpNOKLUClgZ0FZSqfq1dLNOmZXsRvmaYgBMf7YuD65L6d6VvgIhbY2lZQzqJmX0DwczoQsYszCKt3TLXxcN81EoMuP7rhXJhUMuCCepNBBnDI5Lhmwo9c0XCh7tuLNtOqmxKeFDvhjxbI/jQdJuCZfaVdbrCKP2lPvKI6CoKzA9Q7kDOjonqzA0tgqe4xicundggUqzgQ/K6hxRrY3G4ofx9rZICZHe2rP3gaPywTuYJPpk/5uEk4DWvNoqUG0/XHkvNwew7LnaJvPckwKiOUI27N5HrwnMzBCN+nRcaLBfk6qzubmgi5kegX+6SWiEWPxSoT1u5VJafYl5oJEmvWP21FjW01YTdwM37O705QHnzG6ENsd93C4G0crX8tt8iadKp8seV0aOnIwjLTZbHPdzHIC5OnZcdnm9f/CeQphSq4vsFIK3AsB6+0o1PwfcSlfucYcJFdSYZWzts77+BV78g+Zw/nH4N8Zdhiob9iTkPzJFdVBJVuZ9eSfin6dW0xFfQTdV5X9UFjGb6wQrAHO/hz2giJlBnTmawzTBlJ90t/VE0tXyuIISaBNMh/AMsBwPlCOxmxxWWPF34XpyLI+00pnCyQmO50010O2kOosRd9ajmYkSCzPATZrYQInvalpDffKjN+foWbBXueiYGcfEP4MoGLELL7un5pWer+9BddNGOPwQ+oGvdr0aKA9wtrIbG4FXFQ7dTjPimnSl2fWrh1OlWbgL3l0GKbKFBt8bVYLxXmiLZhDsbj2grJH1r5kua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 8:45 AM, Christoph Hellwig wrote:
> On Mon, Jul 06, 2026 at 08:38:12AM +0200, Johannes Thumshirn wrote:
>> On 7/6/26 6:11 AM, Christoph Hellwig wrote:
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 9213a5716f95..20cb8ed7d987 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -7,6 +7,7 @@
>>>      #include <linux/types.h>
>>>    #include <linux/blk_types.h>
>>> +#include <linux/blk_plug.h>
>>>    #include <linux/device.h>
>>>    #include <linux/list.h>
>>>    #include <linux/llist.h>
>>>
>> I know it's a lot of cross subsystem churn, but wouldn't it be cleaner to
>> not include blk_plug.h in blkdev.h, but patch the update the consumers? A
>> quick grep shows 68 files that would need updating and some you already
>> have updated.
> Right now blkdev.h needs the rq_list from it.  So we'd need to move
> that to linux/types.h or something first, which feels a bit iffy.
>
> And no, including blk_types.h in blk_plug.h is not a solution,
> as that is still touched far too often.

Ah sh*t I did miss rq_list. Fair enough.


Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



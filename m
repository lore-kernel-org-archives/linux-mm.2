Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8ACCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E038E002B; Mon,  1 Sep 2025 06:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDCF8E000F; Mon,  1 Sep 2025 06:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247B58E002B; Mon,  1 Sep 2025 06:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08A698E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:20:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 919111DEB21
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:20:27 +0000 (UTC)
X-FDA: 83840286894.06.B73FA11
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011016.outbound.protection.outlook.com [52.101.70.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2060520005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:20:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="HFrpc/1/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="HFrpc/1/";
	spf=pass (imf13.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.16 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlBpAeZweiASUJTC+nVkYA4THNAa/rAJ7AAp27RPTyw=;
	b=Nz4KAQVVauwsuWbmsmYiB8VRHZQ6YAe2WnpXBiTwt4U9tFL/vXunYwP8mP6KWuojLoYIRY
	9eMu5hadyIGqt6b5YL++dFgq33em5l/Hvhs4kBqdOk9Htofek8sLOg+9u8SW99rlvGmj/J
	kVTiTk8v2LowYumPF8qkPJIufqC+vTY=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="HFrpc/1/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="HFrpc/1/";
	spf=pass (imf13.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.16 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756722024; a=rsa-sha256;
	cv=pass;
	b=21SpHx3XhfcJ71kYSKaxR2gpstmUxuRY6ysIkyYUGWc+l31eEm6ikE+EJN1KhOw5LqIXuu
	THwML/aG9a0Cmkgz1+9UrSFCpmUSNPWDZkKeG7+ccMCzleBMk2UXa3tpHxBhshVkSgdMYX
	jpJC5gXkeBwJMcASfTEdxYKVrWFlC1M=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lyJ3wybiiboSNRNSUWR/HM/wECtMITRmIkU1K2kXLohCEP4F9KK/ArfSlUk+fBv2/c4ffbtvZJQSzjTPi2D4DL5xfDzpNg0o8NfvTqpcy2/I+a+yXUtawwPMgC2960JS31GvRWMvXvLzFGUhQu9FflsrGMFMSDTv0kdhkcahDf+Mn9zjBV5CHEb4yL/fr9q135LOfTSDw2ldUOGziTB2m92KNUPAIuGnv0g0JWSCkgcoPPOv2FPA1gcf7ItOBcbaLzwkZWA9BYsrid3ZA2AH+Hm8BNV22MdZ90/teF94EN1qChzAkOTgbdypP9k2sSa29pdYAmrBTdCN398/se9gyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlBpAeZweiASUJTC+nVkYA4THNAa/rAJ7AAp27RPTyw=;
 b=YQSiN79S+LWFg2UikHrzKzKkU1NYe4iYMaxffIlGXw7L1M86E7SUSpekN5vVgtDluh4J/JzcAwZAzllpXNLt0ch0F/bT/3C75CIGtzlgPfKfuPiQmQVyFO7ncDgYeRPc+6D+q247cQWFUadlgqFJ9HfDt4eRm+Cgxn6/o/2qbpXvSIeoTQNfdKXa131g8Rd1h95PZXwqIGwRgV3FPREfDdiIMdmpallw2fR5UgvAQ1/R8R7HnjLWifxJ6G+wsftRDxDly1nsrWKrwkn27mIq0nNTX4JoAymRaXy965KyNTEMvS2dBV7pyNiggRzksSa7S1faPG4fePhtegmBdDe0aQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlBpAeZweiASUJTC+nVkYA4THNAa/rAJ7AAp27RPTyw=;
 b=HFrpc/1/4n1MiSz2twbfo1nTbMwpeXQoL6E3bnH2gBh0FKL1k8Lqcmf//t6AOeGDivnrGsNeTD25dFNPkUTqbuUunDLxAERyoRjN22Aly5KjpQVjaQBs28a7B5+AAzHkUsyRreAqNIhdsrWD9KiNJMqjqFc1JnxsfecI3O3+gv4=
Received: from AS4P189CA0023.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::11)
 by DB3PR08MB8962.eurprd08.prod.outlook.com (2603:10a6:10:43f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 1 Sep
 2025 10:20:11 +0000
Received: from AMS0EPF00000198.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::2b) by AS4P189CA0023.outlook.office365.com
 (2603:10a6:20b:5db::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 10:20:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000198.mail.protection.outlook.com (10.167.16.244) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 10:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Usartn+LSGkOMuKrx7LQRPXdeWrwXxgQEdN2Mpxg/+UwWcIiGhlT1haEhIy3FCylS/TyORkAS5C1a1aQGIBLvOwe+5aSFcggmQ/gzXb7/A71uDGcbibd3io0c8dNN+jwWQXBBtC7kpis+RqIoNF4KK0jVMlIi4JddG3ESQWxV5JSkYIjJh0EjUY2rG0mFBP1+En+vecTbaAlW4n5PiOmUJmmC4Ae2gUhNvyqpZJD98eRoDjJi+Tcm8hUZtrWWtr3yswJUPJBtRaGivKs4XjkCs0CDWYdh1YJZn9c7twxvNTeuOzb8HM7fjibZedRt4vN3Qp5rLMZqo0FkU7YblzLug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlBpAeZweiASUJTC+nVkYA4THNAa/rAJ7AAp27RPTyw=;
 b=Ioj2z2lPuBHviqF8hkZXcU+jokbqe6ECp+2ayUWfu9uw4J3x27o0H8WFkquScIzZZaYdpdh8PY8rtQRwXxCAp8NYNT/G1LnGxqAszSJGcvTKgxUZnTDj0NrNn2sVIGCYyfXUd9ozLMJXIDMIAcbAtbcPqXrNvp2eWrfhxMbVGhbneYWkJN1xAc2EavBKT7gutdb+FsHm2zL+hvlz4kgI/dyZQKgKLKfIDPwMyOtb0GSmIOnbc1vpTRFcvBQJeS3EZPyOFuDqZCJ5ukiAHaIVEzrzDJZHuBKBnGlkFTIZtdklMrZ06Buxif9P7K7EVa377VWHXG1bchwV+WWWkx8EWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlBpAeZweiASUJTC+nVkYA4THNAa/rAJ7AAp27RPTyw=;
 b=HFrpc/1/4n1MiSz2twbfo1nTbMwpeXQoL6E3bnH2gBh0FKL1k8Lqcmf//t6AOeGDivnrGsNeTD25dFNPkUTqbuUunDLxAERyoRjN22Aly5KjpQVjaQBs28a7B5+AAzHkUsyRreAqNIhdsrWD9KiNJMqjqFc1JnxsfecI3O3+gv4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB6327.eurprd08.prod.outlook.com
 (2603:10a6:20b:31a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 10:19:38 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 10:19:38 +0000
Date: Mon, 1 Sep 2025 11:19:34 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 2/2] kasan: apply write-only mode in kasan kunit
 testcases
Message-ID: <aLVzNmN+G/usuJoE@e129823.arm.com>
References: <20250820071243.1567338-1-yeoreum.yun@arm.com>
 <20250820071243.1567338-3-yeoreum.yun@arm.com>
 <CA+fCnZcAgW1iVKJ-MyzzdFoaDpRpA+CnTt2y22uZcUbSegc8CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZcAgW1iVKJ-MyzzdFoaDpRpA+CnTt2y22uZcUbSegc8CQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0251.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::22) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB6327:EE_|AMS0EPF00000198:EE_|DB3PR08MB8962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db5ad70-9ab6-4d72-bf47-08dde9412259
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?dVNMcUxYamdKNHFZZzRuTlBOSklJUy9LdUJoQTFFcVNjZ2k0RGxqOUhyUFBk?=
 =?utf-8?B?eERhOHEyOWVZMEFCOXAwU3QvV3ZvdHdsekxFRWdCRHBhTXVJa0F2ZlpFWVZI?=
 =?utf-8?B?eXZJczRYMW5YaWVmRGZReDhsc3M2WkM5MWEwa1dJM3RuZFh3aHpXVFBLbDJR?=
 =?utf-8?B?QVEzLzRxVURIVGwvZGZ3ejJiamk3clBkSWVCNkg2L3pTamdETzNlR1AxSHlt?=
 =?utf-8?B?OEUrWmtXYmkyR24wMDRxMTFaRDk1TjdqRWZReGpSODY0YWNDSTZ2LzkzaWZX?=
 =?utf-8?B?TFJwbWlSUWtuSElVam12NE1sTzhqOXRDZk15QjA0Y2FLWGVkcnpqMGxiYTJG?=
 =?utf-8?B?TUFwdWVOWWxIQno2TUVIYVJpanQxUFhXYWZUMzFzTkZMSkpOTy9JUzZkVUkz?=
 =?utf-8?B?bmtwSDhLcjU2bXVKZGFLWGppdWJ3NFBhREs2bVNPYWVDY1YxZkcrNUlYNG5G?=
 =?utf-8?B?ZnduV3lUYmQwQ2hTd3NOZ2liUXFSeTNPN0JlcXZvY1BROEVZdlhBVUhJVVdD?=
 =?utf-8?B?aDVtTWhJVlNkL05LNWUxams2Z0ZLcVo3dFJZL2F5M0xVOWFSV2swbDVwQVJv?=
 =?utf-8?B?TFJRcHlaZ1hjM2h5VHhDQTZBbXJTSHRZWGs4WkFTOFBxNVZMdGFQaFBNZWF6?=
 =?utf-8?B?TlB5cE01RkI3SjVjbXZDVVZhUzQ5blNnSjF6UTJVZkU1UXNkQjBNK1ltT0wy?=
 =?utf-8?B?WHFrREVvb1Nkbit4a3NDcmIwQjlrVEdjWmVMc1dnT3p2Wndxc3RFK1I5Kzh1?=
 =?utf-8?B?K01zSmpOUmpLVGNaZWY3TXRLM21QL2QrV29qSUFsbFNMUzJFYkY5Qmc5TEJF?=
 =?utf-8?B?NHlnN045TGlTRkJtLzJnbGU1NVlOOXBCbTB2VmNNMnBoY2RtVFE2dzFuZDRC?=
 =?utf-8?B?M1F6VWh5YmdwRUI2SWFxZXZmYkF3WGs4RVlnYXFxWUFaUGJ6SXdVUWY1Rk53?=
 =?utf-8?B?T2k0STcya0prYStzaXBybTE1dEN4RHJWTHhSUnhKVHRFNC9IQ2dGTEp0akFL?=
 =?utf-8?B?ek01WWt4ZC9tTnBvaGlHQjNNd045YWpsMTBEV2kxUWNMQ1pNd3RNUXhQN3p4?=
 =?utf-8?B?VDJ5aVBqYmJHQ1ErNUNrZC82L2ZzVDlETDZtdXVIQVdReXV2enIzU25CVVFV?=
 =?utf-8?B?LzdTeGUrdzJDSTM0RzFIbW8wK3RjRk5kUkl1UWhMclUrbzJYWnVIY3oyQkZ0?=
 =?utf-8?B?R05TZkxvWXRTUDhCdjBJTlVobWIwYUpGNzdRajhYSFVxTFRFSmk0NE95a1ds?=
 =?utf-8?B?cDErZ0w3Y3hUQUpnbDFDYXZEQW9KV0tQZ1dsVUdiZ0twazhPd3BuTzNqcmxh?=
 =?utf-8?B?UzloTmlVTmFHVDA4TGxyd0xycnlQL2lMeU11L2xOemJLL2pPRzQ0WlBYOEFH?=
 =?utf-8?B?dys5TEFrcUJYRnB6RTZlWG00YkYzZ0hoUTNNcHRUVnpUM09uY2xJUjZLYjM4?=
 =?utf-8?B?S09BSXdCQjM3enlaekdwSzl1R2E3YmdSU2ppOVpxQ0ZYdE1MVzhnM2VhK2Iy?=
 =?utf-8?B?ZXFETUNJU0JtTk9qV1NpWFA1MnFERDBWNkNROVdLWHdIQlNWQ1B3cVRCZlls?=
 =?utf-8?B?QU42Q3IvSFFXNVR3UDRPWU1DMVN6MUxsYy8yYzRhRmlmbTZ5Q3pIV1ZwYWhh?=
 =?utf-8?B?WEU3Tnp0WklZbndyaXRjVFlVdlpkNFZtUXdMNTYvRVlDamM1YU05NWtENjkz?=
 =?utf-8?B?K21HZVVPUGFUUi9EejBkelRBSUpGdWpXQ2V3ZTg3dXF3SzhlVWdRVGR6Nnpo?=
 =?utf-8?B?VW5nTGFvQlJjUTBLS3ErNHNtUk5rTURYQzM0N0Fpc3JHZ2JZM1JnUFZvclpi?=
 =?utf-8?B?cXRrUjc2Rzd0eWpLSTdrRER2bzJTa0J3Z2oyR3NUaWFqTmpmdzNPWnpmVm5a?=
 =?utf-8?B?Nnd2VTl6S3JRdmtvS1JpZlJlclhqOVJuT3JpK0FUdUlHWFFtR0NIbVlEbVZj?=
 =?utf-8?Q?3mxTegNhMMg=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6327
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	da397305-0530-4bdb-8bce-08dde9410e3f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|82310400026|1800799024|7416014|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0NIbHZVU2swbHhOL3RYNlpIbHdvVTF4bUhzRk9NMEJXZEo0MnFmNTFuNUlV?=
 =?utf-8?B?dTE3bmxBTW9xUEduMEhzVFpEVDhMeFliY0NYTDBrd0dlN3NoMC8xU1RuUHdZ?=
 =?utf-8?B?MnhRQ0hzWCsvZTFBcHN6OVdXZTVqakp6RVQ3RUdaK3JWdEFjUzhHOFVMMXk5?=
 =?utf-8?B?SGlkT3ZqOVR3RE5pdDFEcjNXc0FuNTBaS1ZGWU5FWlNybitadFNGdjdHZ0VS?=
 =?utf-8?B?RTl2bHVVcmdOb1doWmRxL0FydjRJdTZzYktUOUtYQlNWSHMreWgvTlFpOWJv?=
 =?utf-8?B?bkJEZ0xwTmlObE53T054aVh3QVpPRWZUanljYzdJY29qVHV0VnVBNG5HRytX?=
 =?utf-8?B?d0RScXNySFl5SnV5dW1sMEU3T1liZlRUcFBMckthaXllMzlpL0JUb29zNHdH?=
 =?utf-8?B?K1BNTm1YcUxuRUJpSEU1MWI1V25YRmdKK0loS08wNDNpSUpTK0tQcFJ5R0lH?=
 =?utf-8?B?c1BTeWJNaytqNzlsRmw5aGM3SFpUVE1WRGphaVZjbTJOVUdkanNVV2VTV29E?=
 =?utf-8?B?UUYvKytUVFpBTzhYZXB3T0lGbm1LemVhUDZMMUdnTHkxNmc1dlE1eHJXU0JB?=
 =?utf-8?B?eUZhZjJEejhjQnNmVCttQnM5bFZqUTVhYjJpVG1xejEwQjFqVGhWcXU2Q2hW?=
 =?utf-8?B?SVBueXFOSXYwckU2UmxNL1p6WDhvYkxLL1NJb1U5ZTRpSE44NXBJaGhZY3dV?=
 =?utf-8?B?TFZUeEpSU1hkQVhVUmlBTmdxbjFkUENpRlVlbHpqV3ByaktKSzJhMytWS3NQ?=
 =?utf-8?B?VVlwNHZ4UlBnajlhdkNTbUs4bklNSGNLajdsSW54RlM2NlZ1RGZZcEp1M1Fr?=
 =?utf-8?B?V0VzSkFueExDSnJrRm1oN0pMQmdjWklOeGhlTllnc1NzZ1BudXU5RWJOMkRi?=
 =?utf-8?B?U0JRcmpINUtoSzNnOVd4dUwyY08zWUpIL2c2djdqQnZTRUlLVWFmeStsWTNY?=
 =?utf-8?B?TEtFRzRiZi9XZ0VDUDVJUjhGMzZXNjlseFp4YTdlMm5FZXRCclNSY08rY1lG?=
 =?utf-8?B?c2NSZ3k5Z05saGZ2eGd4cUo1WHRWcUYrRGhuK1VMUWszUXh1QVo4VWtkWkJ1?=
 =?utf-8?B?TmFDcHRjQkNMVlgxb2dVdUxaZ0RDdGtSZyt0dHFwZCttaHFhTTRwM2o4V2NX?=
 =?utf-8?B?VW5PZWMrWWVOWVhoelhDakUzUi9hSUpyVHFzS0doWGI5TS9lTHM1YkxiUk9N?=
 =?utf-8?B?VlVXeG9qazViOHkzZklsbUp4RVlvL1kvMW41ekxyekpMZkhDays3VnpIdmxm?=
 =?utf-8?B?c3BLYUdFdU9JRmpYNDVjMms0NEZVK1drTXBBZUlyMWdROWE2QkVlUkx0YzRP?=
 =?utf-8?B?blNtMU10SS9Zd043VHZGcVRteDRiVkxiS0lxc2JqVXE0SDRISGEvY2Z0ak9M?=
 =?utf-8?B?dXlVRG5DRFk4UTVFQW1aYjFhQVJYVXRJT0FlRmFGVlRTQzNHZ25xTXFuQnVC?=
 =?utf-8?B?TEh4ellsbE8wNFFIU3kxb0x5d2pJcjlzcW1FVUFXMUUzeGlSNDllMytqbEVN?=
 =?utf-8?B?RURVSWs4WDFMTWVsckd6T21GVHhOd0IyV2tUSU9CT29OTVBtQ1kxK0FZT0Q5?=
 =?utf-8?B?ditFTGRRS0Y3aFpTMXRRYjd1VXgvK2NkT2t6clZYRGFWSEVBQ0JDRmdTcVpp?=
 =?utf-8?B?bWZGZm15S3lOOU04elJNZUdheVVhazUrR1NVV1VUU2ZicXRuQkFQVHVTQTdR?=
 =?utf-8?B?RC8vVEpmUHR4KzE3QVFUdHlwNTBaeUIzbUQ3U0JTT2VLV3prb2FBUHdrWk9S?=
 =?utf-8?B?cG1JT1NBZ2tId0MyaWxlUmZESjNJb0hacFNzeDVmSWFDaEh1ek80WjQ3Y09k?=
 =?utf-8?B?Y2NOVjlYMlFpZ2szQ29LZ3ZUOWV0R0t5T0VCWktTYUw0WFhyRFU4aER4MFhO?=
 =?utf-8?B?Y3R0SENPcjJ6bGJnd1dqbEI3c1I2eUQ1OTJrQUJjZHp6QjBvUllheTJPVUx5?=
 =?utf-8?B?WE9SdFdHYmZXUllINnlZNEs5WFQzVGw4d0ZURVB2ckNYMUQ3NllVUUh4S3JI?=
 =?utf-8?B?UnNoeDhRcTR1R3Rxd2VtZDNWbWRRS2Jrb3IvZGJpeUVrTTJPU1NtYUxPYk4z?=
 =?utf-8?Q?MEeyLk?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(82310400026)(1800799024)(7416014)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 10:20:11.3871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db5ad70-9ab6-4d72-bf47-08dde9412259
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8962
X-Rspamd-Queue-Id: 2060520005
X-Rspam-User: 
X-Stat-Signature: 9ipwz79tnedohh6ejg9afafxm9u68ixp
X-Rspamd-Server: rspam09
X-HE-Tag: 1756722023-5667
X-HE-Meta: U2FsdGVkX18feqQGJzEhIcy9eyhp+YfsQys6T7MkylErKOfHSQe43KOJjlBWh6vdukfduNHNKG51D2QyatzmDrDKja0RgRpCGDdTViv/Zi7hUl7tbUNsds54lPMm1Dl/hlEb+TKBqz2hd5sq7SlzsxxAArQGwq64l2unZ8ePDM3g99k6Cq1NqarRFbM5BwU0tCBvAXUwUdDi0YVdnrzkD0vLzqEgBM8l1X0yBQkeBT957Yn2eXyP/QYSmXZmVjos/AZMbCpZVdFxPSRB6NlINJ0RHTki8s/dV6JCLPbvW2bHPSmEimh21iA0c+rSS+xaTHaoC0giaT+GxDYuRLc7LL5QfGH70jSogDAZLdfgw4q/S+MKGr28hosvbc6OT9yovQ/Dd0rSEsDyvCaM2J18X7Yxd0f8y/GerWmZD2H2rVzvRHLJDmGPf7YjQPAwA8CwyQRKl3EbbaDsAS62QmuPCUzGi4rqebyUwYdE19AEFZb20bhPLf13Cb/hotmqCH68iHV4ZO66j2xk5PF7o6jdr/20zPSLEU4vPX+0c5mLkQrtztYr5riOzl8BrQvx4olSyCyPHyl4BkIfBATwDfrpip3mRrI1n/57adq5c/E4Kh4+P3Ibt6GcZGnQd5Uuhs10oFo2w1XzWrFGLydhi4Vyiax26DkSXf3b47EMl/mdY0EQ2KqoIB45Ac5m106g3Spx6PwZqwZM12o3ad83DQKGxtw1SzbG+ZiWOm8Fpqv37MuE5iurQ+5ifpZboXnd8tlUJ06aO3nuU009xvTvwatXppXShriIFJKormwwSk4J18lsRsC3//3cyyJ4MQ/BZjODTexV23bPWHE7l6/rOX9bMTdMX12kBR8QrueAo1BwtDjHyfUcA033ySSxgkN+V5rgTzPXxiX4fmppCrPmJyCtgOC3tTvsKe8llBwcVuvSCkxP7uaDLR2rFL/7Wnhm3aEn2IgwJYswFw8fQRuGjZN
 L6lZzWFM
 cgpTL4i2W7/2zjhBApMmvQkIiSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,

> On Wed, Aug 20, 2025 at 9:12 AM Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > When KASAN is configured in write-only mode,
> > fetch/load operations do not trigger tag check faults.
> >
> > As a result, the outcome of some test cases may differ
> > compared to when KASAN is configured without write-only mode.
> >
> > Therefore, by modifying pre-exist testcases
> > check the write only makes tag check fault (TCF) where
> > writing is perform in "allocated memory" but tag is invalid
> > (i.e) redzone write in atomic_set() testcases.
> > Otherwise check the invalid fetch/read doesn't generate TCF.
> >
> > Also, skip some testcases affected by initial value
> > (i.e) atomic_cmpxchg() testcase maybe successd if
> > it passes valid atomic_t address and invalid oldaval address.
> > In this case, if invalid atomic_t doesn't have the same oldval,
> > it won't trigger write operation so the test will pass.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/kasan/kasan_test_c.c | 237 +++++++++++++++++++++++++++-------------
> >  1 file changed, 162 insertions(+), 75 deletions(-)
> >
> > diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> > index e0968acc03aa..cc0730aa18d1 100644
> > --- a/mm/kasan/kasan_test_c.c
> > +++ b/mm/kasan/kasan_test_c.c
> > @@ -94,11 +94,13 @@ static void kasan_test_exit(struct kunit *test)
> >  }
> >
> >  /**
> > - * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
> > - * KASAN report; causes a KUnit test failure otherwise.
> > + * _KUNIT_EXPECT_KASAN_TEMPLATE - check that the executed expression produces
>
> Let's name this macro "KUNIT_EXPECT_KASAN_RESULT" and the last argument "fail".
>
> > + * a KASAN report or not; a KUnit test failure when it's different from @produce.
>
> ..; causes a KUnit test failure when the result is different from @fail.

Thanks for your suggestion.
I'll apply with these!

> >   *
> >   * @test: Currently executing KUnit test.
> > - * @expression: Expression that must produce a KASAN report.
> > + * @expr: Expression produce a KASAN report or not.
>
> Expression to be tested.
>
> > + * @expr_str: Expression string
>

Okay.

> Expression to be tested encoded as a string.
>
> > + * @produce: expression should produce a KASAN report.
>
> @fail: Whether expression should produce a KASAN report.

I'll change with this :)

>
> >   *
> >   * For hardware tag-based KASAN, when a synchronous tag fault happens, tag
> >   * checking is auto-disabled. When this happens, this test handler reenables
> > @@ -110,25 +112,29 @@ static void kasan_test_exit(struct kunit *test)
> >   * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
> >   * expression to prevent that.
> >   *
> > - * In between KUNIT_EXPECT_KASAN_FAIL checks, test_status.report_found is kept
> > + * In between _KUNIT_EXPECT_KASAN_TEMPLATE checks, test_status.report_found is kept
> >   * as false. This allows detecting KASAN reports that happen outside of the
> >   * checks by asserting !test_status.report_found at the start of
> > - * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
> > + * _KUNIT_EXPECT_KASAN_TEMPLATE and in kasan_test_exit.
> >   */
> > -#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {                 \
> > +#define _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, expr_str, produce)    \
> > +do {                                                                   \
> >         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
> >             kasan_sync_fault_possible())                                \
> >                 migrate_disable();                                      \
> >         KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));  \
> >         barrier();                                                      \
> > -       expression;                                                     \
> > +       expr;                                                           \
> >         barrier();                                                      \
> >         if (kasan_async_fault_possible())                               \
> >                 kasan_force_async_fault();                              \
> > -       if (!READ_ONCE(test_status.report_found)) {                     \
> > -               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "  \
> > -                               "expected in \"" #expression            \
> > -                                "\", but none occurred");              \
> > +       if (READ_ONCE(test_status.report_found) != produce) {           \
> > +               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN %s "       \
> > +                               "expected in \"" expr_str               \
> > +                                "\", but %soccurred",                  \
> > +                               (produce ? "failure" : "success"),      \
> > +                               (test_status.report_found ?             \
> > +                                "" : "none "));                        \
>
> Let's keep the message as is for the case when a KASAN report is expected; i.e.:
>
> KASAN failure expected in X, but none occurred
>
> And for the case when KASAN report is not expected, let's do:
>
> KASAN failure not expected in X, but occurred

Thanks. I'll change as your suggestion :)

>
> >         }                                                               \
> >         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
> >             kasan_sync_fault_possible()) {                              \
> > @@ -141,6 +147,29 @@ static void kasan_test_exit(struct kunit *test)
> >         WRITE_ONCE(test_status.async_fault, false);                     \
> >  } while (0)
> >
> > +/*
> > + * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
> > + * KASAN report; causes a KUnit test failure otherwise.
> > + *
> > + * @test: Currently executing KUnit test.
> > + * @expr: Expression produce a KASAN report.
>
> Expression that must produce a KASAN report.

Thanks.

>
> > + */
> > +#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
> > +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, true)
> > +
> > +/*
> > + * KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression produces
> > + * a KASAN report for read access.
> > + * It causes a KUnit test failure. if KASAN report isn't produced for read access.
> > + * For write access, it cause a KUnit test failure if a KASAN report is produced
>
> KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression
> produces a KASAN report when the write-only mode is not enabled;
> causes a KUnit test failure otherwise.
>
> Note: At the moment, this macro does not check whether the produced
> KASAN report is a report about a bad read access. It is only intended
> for checking the write-only KASAN mode functionality without failing
> KASAN tests.
>
> > + *
> > + * @test: Currently executing KUnit test.
> > + * @expr: Expression doesn't produce a KASAN report.
>
> Expression that must only produce a KASAN report when the write-only
> mode is not enabled.

Thanks for your perfect suggsetion :)

>
> > + */
> > +#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expr)                       \
> > +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr,                 \
> > +                       !kasan_write_only_enabled())                    \
> > +
> >  #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {                  \
> >         if (!IS_ENABLED(config))                                        \
> >                 kunit_skip((test), "Test requires " #config "=y");      \
> > @@ -183,8 +212,8 @@ static void kmalloc_oob_right(struct kunit *test)
> >         KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] = 'y');
> >
> >         /* Out-of-bounds access past the aligned kmalloc object. */
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =
> > -                                       ptr[size + KASAN_GRANULE_SIZE + 5]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =
> > +                       ptr[size + KASAN_GRANULE_SIZE + 5]);
> >
> >         kfree(ptr);
> >  }
> > @@ -198,7 +227,8 @@ static void kmalloc_oob_left(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr = *(ptr - 1));
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr = *(ptr - 1));
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -211,7 +241,8 @@ static void kmalloc_node_oob_right(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] = ptr[size]);
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -291,7 +322,7 @@ static void kmalloc_large_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >         kfree(ptr);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
> >  }
> >
> >  static void kmalloc_large_invalid_free(struct kunit *test)
> > @@ -323,7 +354,8 @@ static void page_alloc_oob_right(struct kunit *test)
> >         ptr = page_address(pages);
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] = ptr[size]);
> > +
> >         free_pages((unsigned long)ptr, order);
> >  }
> >
> > @@ -338,7 +370,7 @@ static void page_alloc_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >         free_pages((unsigned long)ptr, order);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
> >  }
> >
> >  static void krealloc_more_oob_helper(struct kunit *test,
> > @@ -455,10 +487,10 @@ static void krealloc_uaf(struct kunit *test)
> >         ptr1 = kmalloc(size1, GFP_KERNEL);
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
> >         kfree(ptr1);
> > -
>
> Keep this empty line.

Sorry for my bad habit :\
I'll restore all of uneccessary removal/adding line.

Thanks.

>
> >         KUNIT_EXPECT_KASAN_FAIL(test, ptr2 = krealloc(ptr1, size2, GFP_KERNEL));
> >         KUNIT_ASSERT_NULL(test, ptr2);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> > +
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *(volatile char *)ptr1);
> >  }
> >
> >  static void kmalloc_oob_16(struct kunit *test)
> > @@ -501,7 +533,8 @@ static void kmalloc_uaf_16(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
> >         kfree(ptr2);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 = *ptr2);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr1 = *ptr2);
> > +
> >         kfree(ptr1);
> >  }
> >
> > @@ -640,8 +673,10 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
> >         memset((char *)ptr, 0, 64);
> >         OPTIMIZER_HIDE_VAR(ptr);
> >         OPTIMIZER_HIDE_VAR(invalid_size);
> > -       KUNIT_EXPECT_KASAN_FAIL(test,
> > -               memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> > +
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
> > +                       memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> > +
> >         kfree(ptr);
> >  }
> >
> > @@ -654,7 +689,8 @@ static void kmalloc_uaf(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >
> >         kfree(ptr);
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> > +
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[8]);
> >  }
> >
> >  static void kmalloc_uaf_memset(struct kunit *test)
> > @@ -701,7 +737,8 @@ static void kmalloc_uaf2(struct kunit *test)
> >                 goto again;
> >         }
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[40]);
> > +
> >         KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
> >
> >         kfree(ptr2);
> > @@ -727,19 +764,19 @@ static void kmalloc_uaf3(struct kunit *test)
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
> >         kfree(ptr2);
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[8]);
> >  }
> >
> >  static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
> >  {
> >         int *i_unsafe = unsafe;
> >
> > -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*i_unsafe));
> > +
>
> No need for this empty line.
>
> >         KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, smp_load_acquire(i_unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
> > -
>
> Keep this empty line.
>
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> > +       KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_read(unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
> > @@ -752,18 +789,35 @@ static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
> >         KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42));
> > -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
> > +
> > +       /*
> > +        * The result of the test below may vary due to garbage values of unsafe in
> > +        * store-only mode. Therefore, skip this test when KASAN is configured
> > +        * in store-only mode.
>
> store-only => the write-only
>
> Here and below.

Thanks. I'll change them..

[...]

--
Sincerely,
Yeoreum Yun


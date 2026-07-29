Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99D2C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB656B00D7; Wed, 29 Jul 2026 10:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA36A6B00D9; Wed, 29 Jul 2026 10:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BFA6B00DA; Wed, 29 Jul 2026 10:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04296B00D7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:09:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB8BC1604E0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:19:39 +0000 (UTC)
X-FDA: 85041266478.11.8DFAEC7
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id AF18940005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:19:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VzN4bNLS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VzN4bNLS;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.8 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785316776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOB1mrbRuIMi+lgdenFU0/RJa7bxWrTWnjVJjBEo8B8=;
	b=acq1L+ureV7FzHxO2E2MpE0GZDXZZFcBrWdDuXovHa5qK3Zrd7cCzQN6YmxtuRCKAwjmyg
	wzugh9HscJAFHCCxNCs+5+ctD9KlLZTpTNjnyi1DnUtWbnAIuLcr8BRbyyn96R8sfKFUuL
	sx7vn3nMZmOWP3BzXVFODI3FJCTmOTA=
ARC-Authentication-Results: i=3;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VzN4bNLS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VzN4bNLS;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf17.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.8 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785316776;
	b=gk/waqHIA8yUabA6oorZYjuARZJEV7467PvPmDMI767CG53iTOAtLhqvyR9P4Fb5pwWJEe
	acBKkqUilLDrHlVCaW5878LwCI/DOK5a7lUZcOJrhoW2OVCVLAq5JOkOJ8BjfaaMdlUjWX
	hRqwwBAxJ3B+1zhm52aSFSm0SGxyF20=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TJbyUvJYMVvvmADfrD3yy+RFoLWXzZHA0aq80MISP1rrZy+lSswdOQJcLARdVnJzRK1gTNkrzuh1m4S5slmf0W0BpzF54W/2JtxTx9W1nUVTsFGgAdDwmdLPn8oqeRqxS4qH75hfpH3zhpIedQE1MDBHIEsTLBpoWIui2RW32uc+M4Jy2kOU4I/hnMkLO/l8BXdn36q6QCZBknkbObjjc3NNwSaVqPy8iIE9QaHIYWGMss8VNaQIRNBxBh9hom/WJgY+5OfOTpov2EgxqvnFFKpCTI18dFwQ041rGCKgU9HlAF2hIz+Mv57nG6xu37D5pyghJ56mbdQvwMhnMwg/tw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOB1mrbRuIMi+lgdenFU0/RJa7bxWrTWnjVJjBEo8B8=;
 b=FRA8c2ys/SdBx0WX3QhPt/x04qsd2E21WUEvSsQOgerT71WcDvdXDzQwGtRkbHUMF3vqgQkAJ5P47Uq5GwWdYy8NbkSXtxJvCW08hUsjYgxO67MNJuXJk52C5rhCrq1Ro/0Y5mIUVgw+hr5APtUhlVo55Fdp3RaUrtCRh5ITsWjF9g+LafI61vODU08WJQK3yVECaa2x3b+jOAelgPwFbk8fhWZmacyFDtFHaxfRCOfbpm2buZ3iQE5YfGMiy7wSd7scR+nRl579BCPgDztOmSXdZRJgMkcYYVnM22Wu299Y07cejhBkBPXbbnwZV5z6bnqv0dr/fhwXhLtu8Xt6JQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOB1mrbRuIMi+lgdenFU0/RJa7bxWrTWnjVJjBEo8B8=;
 b=VzN4bNLSbfNVhK9gM5N6X7g4de57e9BTWPVuQBuu1u0gGnEFbqcTboHdHwj32YH7EIQDy/UUySL3cbI40d6MXQp9TYYAEaeGZdfaR4IlW9GO/nWsWnavENuYgefEGgntuPSbn4MwKZbgLCfmiCFcno4FuQHemN89cjgqsM2MOKQ=
Received: from AS9PR06CA0338.eurprd06.prod.outlook.com (2603:10a6:20b:466::32)
 by AS8PR08MB6405.eurprd08.prod.outlook.com (2603:10a6:20b:332::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 09:19:27 +0000
Received: from DB1PEPF000509F5.eurprd02.prod.outlook.com
 (2603:10a6:20b:466:cafe::97) by AS9PR06CA0338.outlook.office365.com
 (2603:10a6:20b:466::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 09:19:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F5.mail.protection.outlook.com (10.167.242.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Wed, 29 Jul 2026 09:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Binu3A1oCmJp8Bt6h5imSGiYjZ3sNGfR03MLw6hKU1J9HArdYDPLgVz8pUdMRVkoIourFbGAKWwg1pPhn9E5cHYvOjDu2AiPFbZFjsLSuPugba7no5Mrpas8ir0ZOFnENHilHRRaQ0ouC8g5KAdkafE+vg3OPkhF/xfA+nKb4f6tdk6mBdW443/Vvz74ZP0JP5oV9F/Yhyno1KZdBusZDntI2pjv8kC0rbMQzP6g1JWan7cCyU56AW+MAyHsceZkBuaMqL6g1Hmy4duUaByoIaGIUZwrSOUXyqmlXS8mDX9cqLTRRulAiNctr2aKxGcGhVp8C8ekCH8uYAiqcjRD0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOB1mrbRuIMi+lgdenFU0/RJa7bxWrTWnjVJjBEo8B8=;
 b=Vk6IDhb+bsRXOcxnOF9LxTc+R3pzhkb+d8aICJ724OZfvpKAoT6UIoIK5UmeCZHVGW6DsiZdCQAbHJ6vNAEoEbttMvmiv7FejiCk4su2RwuVkHK5CQaNiKocHHlrRV+ov2/w9n9RX3epBcsRLjrNAvAQQQ511Pl7ytNl8IpuD6mG9raYY0qyG/u1gm7v/EuIn+wuY3UydXETbtjVI/2BFD5UoNkSrOgtDpBufmV5AFkpYM4E0c/FqHvgzpNnLjhrcQnv1F5uggKKaM2HVUY1EfUBFjnJbaWTMrXRHVStS7LQ5cERUZhHv7g3stCXbTS57mi9iJGYKBrwnQ1IhaIKbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOB1mrbRuIMi+lgdenFU0/RJa7bxWrTWnjVJjBEo8B8=;
 b=VzN4bNLSbfNVhK9gM5N6X7g4de57e9BTWPVuQBuu1u0gGnEFbqcTboHdHwj32YH7EIQDy/UUySL3cbI40d6MXQp9TYYAEaeGZdfaR4IlW9GO/nWsWnavENuYgefEGgntuPSbn4MwKZbgLCfmiCFcno4FuQHemN89cjgqsM2MOKQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV1PR08MB11089.eurprd08.prod.outlook.com (2603:10a6:150:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 09:18:24 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 09:18:23 +0000
Message-ID: <3d0753dc-7789-46dc-8918-d1e3db5819cb@arm.com>
Date: Wed, 29 Jul 2026 10:18:21 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] selftests/mm: skip khugepaged swap tests without
 swap
To: Usama Arif <usama.arif@linux.dev>
References: <20260727171825.2835957-1-usama.arif@linux.dev>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260727171825.2835957-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0428.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::19) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV1PR08MB11089:EE_|DB1PEPF000509F5:EE_|AS8PR08MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: b6547df9-f286-43e0-b502-08deed527d3c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|56012099006|11063799006|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Wk9gOfBMq1btya+5PXpIozIm1ae5OVwVaUqoQ7Q8daWL0dNAtZ/VQnzKCboH0NQLfYUUNiv5H5whRYKBdn4gYF4/0hmLxDtWxZ6k7nbkaWgign667FhSYOPN7dXTFTa/SB1SxGGD5rpUXl8FOcxs+BDpx5tWThOUQ2fwXsZx5h/hiI6a5+c+L4d+GhRwdCDs9cQDaRxe5UoqLe39CY3s5Nde8jS+KdlM3KwyxrwtUbXporipNw6CLPTXzJ53hF9SgXyFiOt9R14X2qlu7EAJvp8/ZocOfcIh/fqNoyjFaXa8Q5OD+gUBKW84euAi6RU+MWuMN2Jxn0GCYC5puzw7ITgxHolTDuVrDeLS50ApAraORc/umb2dP6v+CckaD4Ji6BQ8CzQgXjBsl9kZTTFaV1FerXAhDojU29bol75s10cV68nSTsdgGWm4wgUbBB8LE8dWIZWhkVZJvkZkIH25RBjIcIXRkO0O6JjCLx4GcgKGZqWJSTxydOwRSB8SpPVwxjgINc9tVvsZXcr7qFmqNmCXFUE9umX/oY5nzzHrg6CamofkoUDeTJ5wTfrLMB7/ZeF8Ku2g1hD16lI4zjubcJeitpqN3Kw3oOHM+Wwc4m+C3CLkikYMKGz51zcXxflo3nQZZ62yf4piaTsH6o6aFVzUKx0YlJiuK+5B8R7KW+o=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(56012099006)(11063799006)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 bbUmlMUe3DXYC2/13+Jl9dda95s+dazP3NhEjbzGg7u8qiUAL5CgDi5rpFZVqM64Lp7msvqxR1A0mlGVbcWX3GscR06Ffsphf12APToS3RKsvQ7rY3h2OfWIiNEUeEkr9WthlVMHTh1nYOJXeIX6HUaxC6uYKKBRj7KjiJkXTPQQvkBuCXg9ct2AsHW8s95n06bUXIA1Xa7UJR+Z6KZoMctXrr1GmT5VylKCsw4MDhdSoLxZo+CdMYKPg2r28BoyY5RsyVeEQlAbN4AQz59ebRNkua8/4iYagF3SXol3nJWam4vTz/nXnFbSHQpA02TVxGfEpjQRHM6kWOBFsIbZWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11089
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e339009b-1717-4368-329f-08deed5256ab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|14060799003|376014|7416014|35042699022|36860700016|1800799024|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	WkyoD6iwKb9MWc+e11O1PZKEsLKUv/uzNAFaCvhbuIq4IOJ0i1MmA95JVXCQHqZ676k7Uynb4EfkomYj+4UHZGP4tUBDQ4wigZ/v3S4gme+mSttJmkkKL5DhtCHZMLiVBd4A3o/y28Zt3OMqUzMSEcfE1Qgx/4h7tts9bT0l5oeb0UwTJv5hMQrm8nrfBg3e/nl5PrOe9LQDlO9BgGfUnRGJgTMwHoV/7KNVHNezwmIvpsif7arj0YrHWnQ/P/aDfI5pFliULzxQZGcKOfLKecx4EQ600Ljwe1McT3RQz46ma7h1AkW1XXeY54J32sAAITIVIWoyp0hhmZO/eK62VPvcX+q47KwU7UP+GSW5/cxBeaQ9GyQ+GVxXskxEcEXAx92qqVejO+3fxI0FwUnMekWH5rZ3YWMexnWEY2mfo8Qa+7wChdpc8CkCsYX3otgjiVV+NZq2EPCA5je5F5fDXccxFi6hwKuR8uXGAC/Py5s+3OO9EGULD1K/CZRTWJXHP4DrLz/VlaSCCfIkxgQoVTrEMDgJM2aZuUkwqja4NQ3+leYO/LmsZqEiwbfIXZPsVBesA6kchlha22XZWZ/GM6dRKw8UKpzIIYI/3flBBaxz97gWiMzRPyDgR4HA1Lf1w8Z0F+o8HF44AOSO+12JWd96MO0NJLpTPEtUIWDZKB6Xt3PvlMFPUk4F845hUYyGWnDsbMQyNfW9ixob+lk08w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(14060799003)(376014)(7416014)(35042699022)(36860700016)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ixe8oXm/xWZbArYq/ha4CBGw57j62J+a7u6pIXGFCtgjPXUfwCho0tD4hids7aq6l5D247cNuLh0BBAucyVHLLVJhV+ALQ3gtMN6tLjxnLl1V5s/MydFEe7FTnXNVKS6ue86jfGJw7bZGE8rEci7P/cPDSgGE9k2XSAwTdy2pGMgVZcQjmgAoIMpoJBnjJtfN0tmEmKFe7FFRH3Tn4e+o5iN3R5g85p1P4/688DkO2/2dgic/gy7FzCokO3Iw/fk+ZTC8RMJ83yC2RgjsQtoYvcgISyXXvKAU1Rgxc0AU6SpomhOMxEgZrNjjervlvQMliAdIlJFSN1+KuapgMZQ0ffC/+vHBcQ6uiU6tBs/oY/mjt4yQjysvJJrpe2m+q4H8CJ3Kp4yCBVE+bK4hA/C5Niz2MJA72FzAY4MbVBrhW7Kc8b4whHuhuOcoFewuRl5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 09:19:27.6442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6547df9-f286-43e0-b502-08deed527d3c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F5.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6405
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF18940005
X-Rspam-User: 
X-Stat-Signature: q4fbw87kap9dennpnzmyzfcge5yjw6e5
X-HE-Tag: 1785316775-298323
X-HE-Meta: U2FsdGVkX18GKrZvJaTu0QRqWYbOt8SroImyzO1Lr6KSJj3QPgarJMp7Tr6kz4AP7B5FeLYc5v+JQg+dloQgvXyaDUabm8mu4DF+Z9EY+MlgYpAJBdkAVJKfEVDBy70K0zIvP4zcXW6yDyaOf15qsLY/ydxsPEQ4YUNoCDoQYjPB4Fl/gm6rE/iq0GRW0HXHoXXBc6PeF52HEvv+qPlr1GeYPTVZIvx9vdV5ySRcVsAdi3Ef3FHQyHWJw9xNMjOIDEk1dSMM60C8ZTQCDFlRGujT9yxJdBW22a+M1EjnGo/Kii6AjLDKJ3ZUHbR3oy/cscId1rasHVMkJ5NtgKqjl+5/SBDN5YMV4su1y8ZXZKrcP42fHc1RMo0PTQZiLL18LqZz0lbUSSIpP844MEJJiiL0vmBnkWlAiJjAHxxLUKAh8pdQ1E9aZJCJTOk2FDZPz0yZDWc43eIUU6rCliaEy84D57F7a90S0UB/djShDkcAJJ06AdqFZnWELAPDHXu1HIaZW2ZsrpNrUUPUFQl091GgSIfyWLMTiLROBZTKsZh7cXQijVY+w3YzyGSPXBKtr8ZIqWgOsIxBFDzny76iTpTSIgacoHT4cRT8Ph441FDZDhzHaaNu2OYTxwAEbaTa+Hg2Y2vGUArbRMBX5Tf167fIcqC0JSvFY0F2jT82VAhoV7akvF6629rK7AeXl4El5eFD8waJyZeIQIY5nuoaSBeakA0wjmImih+6BurZd4jGmksbpQxSPTIUjmGbbA0yvj8SMLIMFGkQ9DSUAF/otJQHmII+VhCmOQiwNPyuB1Ar+xGNOS1XvK7YyO4EJtnsGFkv2F0wPmdwUs6m32oXzjC4RlLsUTbMiqMb2qpe0lsLj+VkmDV6C+c3Wvz/kUzdk3MXd1HvJKUO4vnKYnPEIDmpSLPDnbUY/BhJkFgeMMNC8mFmCw49giYL/KsByOO8H5XVw8qu0by8Zu5xtYk
 f/UVnWSL
 EJLH1yM+uQDJs3DSkZCdrcenQ2FH9dbhHY+q1cZOGTUNS4inqN2MH+uyBo/imUfA3bexUWKmLwnXCenQlTexI+Z4FJvvrHeEYKUjl46xKY+zOmMu4Hg0FQu/pFAORTvhv+xyP/OJprwfAiBP0DR6i0OlXOQ4LR9vozca4LglUI5eF6OfY/oa22aazVjLtJG54m77JpQwQB3T5EysCi2IVCDfrLUCYb74vJvYyCrES4/Dx6lPVU9pzB1f7yMtbgaG5meNwjt6kf2FUwSB1d8P4a8p4vi0aVut2FkEZZfBCKs2mZkUJC/R1AspwGhC4HlSe09FgLSK2Sa83d1InZg8jbjbCSUBeSWN9x9H6FzbgREjcZGt/xKb5NoUiifLxZkJgySplOlxv1RlXR/AWoCNeWd48mVBWVVd1cn3YL3kgUumP4YrCCN4Zn/qH1b843qut02snewbKij/FVa8p7n4onDMBMA//EJI69dQft7z3aC0M+G79SGvMgXXzwE0A/MRWmWi8m8cifL6HwBwB94bk/YOXqd0o9xmTCBxmzjSsHKaanU4Y0L9YMb04Emp/pVxMcqVFim+YfQuJElW/h6RWWqFVu966PZQ19xQ7yieZyN9Tzvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/07/2026 6:18 pm, Usama Arif wrote:
> On Mon, 27 Jul 2026 10:52:19 +0100 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:
> 
>> collapse_swapin_single_pte and collapse_max_ptes_swap require
>> MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
>> systems there is no backing store with which to create those entries,
>> so check_swap() reports missing setup rather than broken khugepaged
>> behavior.
>>
>> Swapless configurations are common on Android and other constrained
>> test devices. Failing these cases obscures actionable results from the
>> rest of the khugepaged suite.
>>
>> Check /proc/swaps before either swap-dependent case and skip when no
>> active swap area exists. With swap present, retain the existing
>> MADV_PAGEOUT and swap-entry assertions unchanged.
>>
>> Print each existing swapout diagnostic before the prerequisite check
>> so skip() completes a KTAP diagnostic line instead of emitting an
>> unprefixed message.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Print swapout diagnostics before reporting no-swap skips.
>> ---
>>  tools/testing/selftests/mm/khugepaged.c | 38 +++++++++++++++++++++++--
>>  1 file changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>> index 10e8dedcb087d..54e888eb48bbc 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -100,6 +100,28 @@ static void skip(const char *msg)
>>  	exit_status = KSFT_SKIP;
>>  }
>>  
>> +static bool is_swap_enabled(void)
>> +{
>> +	char buf[MAX_LINE_LENGTH];
>> +	FILE *file;
>> +	bool enabled = false;
>> +
>> +	file = fopen("/proc/swaps", "r");
>> +	if (!file)
>> +		return false;
>> +
>> +	if (!fgets(buf, sizeof(buf), file))
>> +		goto out;
>> +
>> +	/* Check for first active swap entry. */
>> +	if (fgets(buf, sizeof(buf), file))
>> +		enabled = true;
>> +
>> +out:
>> +	fclose(file);
>> +	return enabled;
>> +}
>> +
> 
> Could is_swap_enabled() be moved to vm_util.c. This will definitely be reusable
> in other places.
Thank you for the suggestion. There isn't any user of this at this time. But
its always better to have such functions in general library. I would prefer to
keep it local for now. If another revision is needed, I can move it then.

> 
>>  static void save_settings(void)
>>  {
>>  	ksft_print_msg("Save THP and khugepaged settings...");
>> @@ -734,10 +756,16 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>>  {
>>  	void *p;
>>  
>> +	ksft_print_msg("Swapout one page...");
>> +	if (!is_swap_enabled()) {
>> +		skip("No active swap");
>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>> +		return;
>> +	}
>> +
>>  	p = ops->setup_area(1);
>>  	ops->fault(p, 0, hpage_pmd_size);
>>  
>> -	ksft_print_msg("Swapout one page...");
>>  	if (madvise(p, page_size, MADV_PAGEOUT))
>>  		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>>  	if (check_swap(p, page_size)) {
>> @@ -760,10 +788,16 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>>  	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>>  	void *p;
>>  
>> +	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
>> +	if (!is_swap_enabled()) {
>> +		skip("No active swap");
>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>> +		return;
>> +	}
>> +
>>  	p = ops->setup_area(1);
>>  	ops->fault(p, 0, hpage_pmd_size);
>>  
>> -	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
>>  	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
>>  		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>>  	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
>> -- 
>> 2.47.3
>>
>>

-- 
Thanks,
Usama



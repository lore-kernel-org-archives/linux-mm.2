Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5827FF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD346B008C; Tue, 31 Mar 2026 03:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4446B0095; Tue, 31 Mar 2026 03:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193426B0096; Tue, 31 Mar 2026 03:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0726F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:55:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB6ECE1597
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:55:26 +0000 (UTC)
X-FDA: 84605598252.20.289A839
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011042.outbound.protection.outlook.com [40.107.130.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C80E8000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:55:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lTXcNiGA;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lTXcNiGA;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.42 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774943723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlmN4RLrvRucvPZIt5r2L1+GXY0RHGx7JL7YwuUKcXg=;
	b=7VnxIiqTpQyUPyI/Cjd7hs96QP9T56F5W1pLbYfwbvg+3bSzMRdmrl0+zlbL4JtuM9iFJ6
	pRCNk5hPig1rMODv51+5iOLA0bR6l1pyZA60NSj8LF6dhXZQxlDk3AEIOzcNhZFLUJ+mbt
	rCuF3e+5PXFYYW4+m9QsgIcXw1P/G10=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lTXcNiGA;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lTXcNiGA;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.42 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774943723; a=rsa-sha256;
	cv=pass;
	b=6xVsOq3jnCitASvKyCbMYiVeIllV3Z4WUwXrLkn8+evVSN+nv0QPMeRsplyXJ0ecgLQkqP
	TlL8bZp55TncxMh4VrrqQnHpcrdz75vcxMZM8G3pati+T9lfoCG9B5XTty/ESVbfb4yhdQ
	UZb/zvBn2+p2wIcMw5BbOMbld2j/DRU=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rCWns+KalGAkK8N55Ml8MeUvsVM8q9zA4Gle6qKnkZlz8ky/8xxK7DT6Zrl1XQxZ1LmgQ3AG8xKF1wAuYaopI7Lp2QiWgTCWcPw67kAumdce9NgpVjYxRsLHduah4JJ8of5WVYgtMb01ynK/CuXDWApElNg3ytVIW18gYx9oYz/PaBGoQnnDlJZ/NFU+mtJYRSSfl4acAgjK8ZAy3JM0rnvA0sEeBbXpB9BOUbfh1av9+oK4lUBZI7DIaQVl6ULGiN1OIWj55HMqtSNL0JCxofDSJlNYRB1EiTDwY9UwOr4ry1PPIMv+i3uf1r8R4g3kps+QmyLs3cyXYvOez+R6iw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlmN4RLrvRucvPZIt5r2L1+GXY0RHGx7JL7YwuUKcXg=;
 b=wmEdSkgD1uGOJeu33ftLLHNf3yjm9oUVDlogucu+tSLJeOkNF9JriHvvK9P1ov//sp4c6Zg4hrMSYz08w1ZbiHdATDLzG0vQateyhIKCyvIGgnlevl7LEjjfbG4CnJYlJkk7WEGyIlX2O4dPtAAhW0titzsYzcAjrBdZZsGXlbcLysDNpw5RmwM4Y/hzv27TO5anaqvFLwQp56VwBJveeVkZk3m01z5hHI9gbIpCdAA0xW2ZixaFxFT49vxS1miymfO6t1WOgeJc8DC/85N24iPJrpjYQaWK3CPtSam4TRZIlYPJC/U4B30unU1IgD+DG4BRkI6lRSAvPF1c0Ab5lA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlmN4RLrvRucvPZIt5r2L1+GXY0RHGx7JL7YwuUKcXg=;
 b=lTXcNiGAilX68MZyI2sSF4mtal6numTxZTJmBVWedKaw95zG6OKtUMkLQXlQRtelhv8a8lv4KkN49tJBbMlZWM3hMqBe6rY7N4hviKBYj1mpfXZzbfFcR8Ot4SB7HgQaJn48QmFPpV0p0Cn0wcrzWClQTHHvrYuXFm6RpoLpjeY=
Received: from AS8PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:20b:127::20)
 by AM7PR08MB5509.eurprd08.prod.outlook.com (2603:10a6:20b:10c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 07:55:13 +0000
Received: from AMS1EPF00000091.eurprd05.prod.outlook.com
 (2603:10a6:20b:127:cafe::3) by AS8PR04CA0135.outlook.office365.com
 (2603:10a6:20b:127::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 07:55:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000091.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 07:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbeONEMAvg0Tr5g7ebFI0sFRtCugAjy7hJomiTOOcbCxHNY4FPMZUhKZ47V1zEOnuMQHJzi/J6VcV1RKFqtG4+BgJNgYV+i6qxQYsA+nFvPJYzPzvzrx3XcZ37TL6HT2cAkG+lUqk7c/KAGtvhX6emZQd+3aVVDZAmrJcMnzW3NrGsLuM+JKgisifp5JMmedmRz3mQE9cVPCkm/f5Jvoov0ANbKrKprTqdqjiAtnb7ZdTkCTeSouiyvYLlosD/9Eb3NBOAUqSe6Zuh893WJABTnOaL3fN5dBhoT+3Wjt5lkoIuKDk7b+iZ2RjMqJbvZynd1BMBvX+noehRC5j4jkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlmN4RLrvRucvPZIt5r2L1+GXY0RHGx7JL7YwuUKcXg=;
 b=fU9cYPswR3lhWbP5UiiD6kfWxAlZ4FekTvvugXjPwyAVJfBJFCW33eJLeYMQUqFYc1CH5sDOI/4pGFUgUxxWcHr1h9eByahdl5s6W7is5vO0631ANBdOZSAi1Nto+KS7ONlAuAmcuzFUaqYiya0JQS5e4Md1bVn0sSWSUJoxbtxe0NbuQIhMjqjfwXxMblL9vKCt2U/XW8onWmCODyFeihj5bvfOxeOQwUljE75wo7HInfQm/GDR3mcMD254I0xumVGGK6PF1yMScwOGWmz3kpwRLkmo0zTGWFp2kNI5eK11oWK9g3zFEt5gTbo/dJnVpjLC2ldGmHUBdSsu2710qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlmN4RLrvRucvPZIt5r2L1+GXY0RHGx7JL7YwuUKcXg=;
 b=lTXcNiGAilX68MZyI2sSF4mtal6numTxZTJmBVWedKaw95zG6OKtUMkLQXlQRtelhv8a8lv4KkN49tJBbMlZWM3hMqBe6rY7N4hviKBYj1mpfXZzbfFcR8Ot4SB7HgQaJn48QmFPpV0p0Cn0wcrzWClQTHHvrYuXFm6RpoLpjeY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB9PR08MB7652.eurprd08.prod.outlook.com (2603:10a6:10:30f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 07:54:06 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Tue, 31 Mar 2026
 07:54:04 +0000
Message-ID: <3256bff5-ca00-4c55-9215-ae3f9d101431@arm.com>
Date: Tue, 31 Mar 2026 08:53:52 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
To: Ke Zhao <ke.zhao.kernel@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
 <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
 <7c0e9735-51fa-49f4-9c39-c8c0f2db2f09@gmail.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <7c0e9735-51fa-49f4-9c39-c8c0f2db2f09@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0128.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::16) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB9PR08MB7652:EE_|AMS1EPF00000091:EE_|AM7PR08MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f607ba-f69b-452e-1343-08de8efad714
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 8Sl4119AkuXgRjuL8bDGu8fYjD271bh8QS9KvvbxuiqOao14RM1aznCWumtBe9TyxVQ9VU6XJc8CUSJ89D2YqpHFBR8VhjrwPut+dywWA1jBrWgwVWRDb4SxWEjcEknz8cpXU1YSBthKYkvi0uVAu5tBfUcpaA4CrIsGeovcMdEUvI1FFlketGW30l/kDt45odNpPrJFeHhAduHAxDjtih8iMBWxSJGHAHKhILuetNdCg2yhfBM3qjyjBNIg61xq1SIQkRuCJIypBlpP06JFvegOYjeP7roBRkzwqo6xeT4Wc/UeN6Jrq9F58uzC3wPNfFlcdPlAGH5csNFk3WT0Js+ERvLvvHMy3cj4BqyGXNtodT+l3FNl6Qxo0hT8kahoL/BQwkcnuGD7vd6Ia0qQuNpdo1w2Cq4ZG+fpYvaC5XIDhG3FfwKIyTm+ALpDH2lppY9DJVCs/EDB5r33QJdua4VxSv2GtyZB+Jepj50DDFn2Ao/EqEy3tiOx9KIdzfwm5etlMEYa8hPBPG8vJm2oSnn1kOU4eL1nJG73DTFWDl7JbK++UcMSgPR7fK3SPzxjCrbLR/Uvp3TkLN9r1JYEHwkvNS4u5DiAaZ0STVzt5mJIbTy13+yWyBGeSqDt2Sr5e+e73zbq9JYP9kQ1nIfLT4aBvNV7Dt8kl4sD4fWkDqZmAI03MsF0YvyFST0K4cfD
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 bEY3dUQ0OTZQ2FtaKHHK1XKYgoEQiIpUTpQw1ClzzSpbhLQFQ/pPFWj9YL3WNLngAx9HmhsBSHIXltUAv6EwICNYd0uRTNYCJ+UkOC2aYi+z/VZdnULryvXY/pQlPbw7yFbq2IsiZtwHmIZ6ofDD3Y/HADLhsAceg/rWk/FEhvodJZR48n7FMyoi/0hXvAOTK7Sn34QX4MDLvW9SS/bvA0AdQMN6mkVqysm2WR7kt6szB1cHcru5DFeqDJTyEJfBaWzJWG3bbWzYuPRMXjiptW4hDfWP4OVumo1hwDDC7nmFv+UsB5G9OoyoVa8Wm3B/IInN04VCBhPZCZBYTrif+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7652
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000091.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	667af3af-d373-4c5d-580c-08de8efaad45
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|14060799003|36860700016|376014|7416014|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u56OJr+9h03JaRK296HxhUKFmjgqUd6NilSIzwPDEZMH+DT+94J9hRvvE4/GhmIfw8H3EwAimcPL2gBhLFfDVUyIDx7IJQ+AorHWhlHGD+YT+mJC5Q1SkvELPgHtCa0gLozUjK3bbInrYOLnAe14SxU0bsUO82NRD6exvpRfv2nplZgOhMqgkQjdTdV+bnUku1zfLQ3cOilcWOlx1VqzGoAzujm48+cndG0k3RJwq1cNRtuknUaGaOvNmEP5EQpuLFYEVL8xZB9ZTOX9Ag6SMqc54qFTsnVjhSW5XthtIowuEo0vOhvZzOqTjwP/R3btAA+dsvITybv9G/y+DwblE6ap70y/RHnITKZ/3vVDMUWbwR5ORli9RaL8d09+zsZBiHnGNgF/pJ6n8Gnu97LORYGIqmeABtVTRdjjwxjJj7hrxehEM5WqIhm8JhkH+oq/BGzp833+HRV3QmjEVwP84UwowNOexcvAWLhjLsm1weMwaCyCpROejUA0fQaD3ROFaOeQ28rwZortg6ywHpkMLY1Fm6fkvF02WCYg4Iepf7joGRXy509zyYFiQux3JuM1/kI+6MF8vrnkcOVz3J0lj/W4GLfRlBMWj9EeUqL5zieU+ZKilWN2m0glPUQ51r66F4AJDWeCBW1Ov7LvDTFp3JpIDQZfkXNiMGLtJUcv5V0v3MQ4Zjg2zO9aKc2doF2jJSnMstbsd7b1hyDzteBJ/ynl79peBvRdKHuoXLbsg0c=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(14060799003)(36860700016)(376014)(7416014)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zlnFFlv3XdrkWpyuRSXuHB5pUXNj9BCTdjiPaJJjCg8UJDBlIVr5TZ35F2SWbHbV57SB2t9OO56T3R52fzQ6wYLVYj21AIrAz5AmI7dWCQUAwKGpQqr4QT/SJMww8WU8z/a21bUkXji2nNjIPe5GySpnvBrkpT0rGViiOFPicSHXmntl05LVkqoELsmsrlS9+hjZnbpzuocxbWiBs1fCuECdaPOkWFWbAFBibRfscgHaEZ+RH1BYeaC+yLV7pavejhB5cvcWfT/VBHdmHyoxP2eJqzDhogHi4pF4D1x9SnMmHPSxsiH6LyT41NFmdq2pT9x5/AzFboq1efvUHthAfUf/EWrEerWQYX0h0j9gPECXZzz1j666ZY3/DXHyP0G3DkwyyrDktZlKP0RLiSWrodJPaVJpy8xFO699ie8eWi7K9kQFmaVvV7XFV9gaXvgK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 07:55:13.3613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f607ba-f69b-452e-1343-08de8efad714
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000091.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5509
X-Rspam-User: 
X-Stat-Signature: s9iyehdej73itzipostzs57hqhe9gtfw
X-Rspamd-Queue-Id: 7C80E8000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774943722-413499
X-HE-Meta: U2FsdGVkX19d1Xub4bRmWcyZyJszStU972wsep4r43Qr3AZ3tiG+JhkN1+SGCnpb9xLi3cMF+axqjB/CynY7KKCLjPr3/PLfv+c89L6BLhZXiPMbebYTYR2qaC9NRdXVHET8koTn4NdWxiEEYz691VIKPFTq1oUgroEmqchazkTs3ZQx3t8kmgUezE0LtyHxMuuapJg45kyeq/cu3hu3Oz8xr+8iZ6OVUeNAf9spB0pHr/l0hneqacEh1KJ7BZNPSlqZTKapXBKiyORAO0DIm8PYqQ+DD35rnOSp4FbUb9GHx9OcXlwa2nn+bNY2kUWPngi5A34XEYfwyIAGlbD/g1axy/qc/YbWOtZlK78QhPTG0Sy3iB521rKPENvLkvswrOHUK0By1zAHX8pEtVC8B6JbHoV3cbezuNr4CLoSjoKu86LohaeBSaswgqPIaZXEsAUVFKZgmvj1nl6cHfeB4CG2d987YmPlWInvcIo7SNyyeu/D04GPxLaKXA+WGp2ZKqd2p1R9i5HdOZEU5sD9nPEGORLXLgi/gzbL8Pxe4L/zONu2fguI2x+ZnI95rfge+H0ZOEL9uVkQdF5nMcYAhlYOQfn8kq+rXiPf6oTXzqHmAZ0FbNYLM1zc0hDkkOqDdYq0BM6NYyAMyGqoi8diNqTQB9x9THRU0tfW93l0aK/48Tz0XRXGiBq6eE+bPhABCf3M0Y87OF7D5E0O2/Tli5he4KgCMCAwNMYEmJfp7Oj//P34VF9JcHegNIXB8NKKtqC86vvRLOXiAfxh5dmQq+Ka+49TvV9DPaQLnZVVuWUiLG38PIlcP86osbh0569CF+3Ml8TCxC6w93b6cD3I/uz131DVKvjsoRzVB0cwXYXa0DY5/OQqPgW4RDZmmBQTwVJ/unk0ORbx07IdYATHaAhlhFbiMPDqm1DVrFmov8QkcwXTlZfaOeghXH/it21mMMl91PuH7XUZuo4Lj7M
 CDSfagTB
 dDF8toJD/V4IF6YK9VQKud43bWF/6YXu1pg4Pc2S3Yj3k02FLYLWBeAUL+an3bGAyHQ8NJdi69QNb8c2EQZEjPyl8QVmBhENK33hswZRABOqlpYefF2EGTq7aI38SNsCX+pdTuVmQXOuHzy8eKvpNbXP4uZ+2LtMFCCzy0dq+7Bvbky67qn1wbJA274IOAZuH7TrjaSR1fFVTUkKJnROvPnTD+RBeriqw66vnD6N9a1zeFI16x4OVuYO4EUkf8v4D8xDVAYccW7YmHTjbTvv7rpKgest0Ld5fv8XDNU+d/+6/R9+u/PuYGNXBZN2RBX+q5zd0m5MYPb3DVrypswP9Uic3qD4nyAG2OONPFH7zo2LQLn3x+qO39AIk3UDH6OTgkm54+rI7IfQyh7fadiFkTH8NRBORWRt2hZBdBM3zSMbhBIC+h2ZEw1mrcrmRcKYH5GTBs+ydCkmdhhiNnrlxTa8dO6bVaMQCXyDGnyzswgxBy0l/+LJpGIdbSOnS/lsfp+KnhXp+098FaaQ4HFRLHsEebRduDqK5JairLan2+yXIxAt4xO/gJmQrU1ubIWsybRSUV7rjbxgqkORXo5NP26kytiE8vEH9uqr+t7tgQdBUpIlsV3k0JM6/B15psRMWQwPaVJYVecCJs4Ud42LjZM194SeK0YnqZn/sul7Md0rC2xEbkfVmVMvTAiE1cxQuE9QSkeXiKDv0wUmdpdBIqfYTY2irhF10VrQp4VVzlDhXjZoK60Q1irGuiX58ceGkXQcdKYMW/xxKWMJs3vcS0jBB9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/03/2026 3:00 am, Ke Zhao wrote:
> 
> On 3/31/2026 4:39 AM, Usama Anjum wrote:
>> On 30/03/2026 9:36 am, Ke Zhao wrote:
>>> Some page allocation paths that call post_alloc_hook() but skip
>>> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
>>> Fix this by explicitly calling kmsan_alloc_page() after they
>>> successfully get new pages.
>>>
>>> Reported-by:syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
>>> Closes:https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
>>>
>>> Signed-off-by: Ke Zhao<ke.zhao.kernel@gmail.com>
>>> ---
>>>   mm/page_alloc.c | 13 +++++++++++++
>>>   1 file changed, 13 insertions(+)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 2d4b6f1a554e..6435e8708ef4 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>   
>>>   		prep_new_page(page, 0, gfp, 0);
>>>   		set_page_refcounted(page);
>>> +
>>> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
>>> +		kmsan_alloc_page(page, 0, gfp);
>>> +
>>>   		page_array[nr_populated++] = page;
>>>   	}
>>>   
>>> @@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>>>   			int i;
>>>   
>>>   			post_alloc_hook(page, order, gfp_mask);
>>> +			/*
>>> +			 * Initialize KMSAN state right after post_alloc_hook().
>>> +			 * This prepares the pages for subsequent outer callers
>>> +			 * that might free sub-pages after the split.
>>> +			 */
>>> +			kmsan_alloc_page(page, order, gfp_mask);
>>>   			if (!order)
>>>   				continue;
>>>   
>>> @@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>>>   
>>>   		check_new_pages(head, order);
>>>   		prep_new_page(head, order, gfp_mask, 0);
>>> +
>>> +		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
>>> +		kmsan_alloc_page(page, order, gfp_mask);
>> There is no page defined in this function. Most probably you wanted
>> to use head in place of page here.
>>
>> How did you compiled and tested this change?
> Sorry, I just simply compiled with the change but add wrong code into 
> the commit. I can hardly make an environment that could trigger the same 
> warning here. I'm not sure if I can trigger syzbot to test this.
Please try to send another version (v2) of this patch and then
[1] follow instructions mentioned here.

[1] https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patches

>>>   	} else {
>>>   		ret = -EINVAL;
>>>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>>>
>>> ---
>>> base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
>>> change-id: 20260325-fix-kmsan-e291f752a949
>>>
>>> Best regards,
>> Thanks,
>> Usama



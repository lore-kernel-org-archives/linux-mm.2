Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCB3CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 09:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10526B0088; Fri, 19 Jun 2026 05:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC11E6B008A; Fri, 19 Jun 2026 05:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88706B008C; Fri, 19 Jun 2026 05:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 748EC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:58:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E78061A03B8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:58:58 +0000 (UTC)
X-FDA: 84896213556.15.39A9ABC
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013066.outbound.protection.outlook.com [52.101.83.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB0591C0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:58:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dudumu55;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dudumu55;
	spf=pass (imf20.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.83.66 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781863135;
	b=NE7GFBJAdfbjgUvIzrw0uSHpks9GtH0KVDhvwyO8ZgFVFBo2xz6icL8i8fzu3lexrJyyDl
	Bm5jAWQ05gc7HRNs838y1KLFu99xJRrR6z6OEqQ97YIg4dmcY1Yl8EKdTyJdFGVl7ps/qD
	rpdKPw689lDxmTFSve/2rnZ9Tb9Y8RA=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dudumu55;
	dkim=pass header.d=arm.com header.s=selector1 header.b=dudumu55;
	spf=pass (imf20.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.83.66 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781863135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOXd5q0cOZ2LLFsKgopDMU+oE04WeJ6OcHZqFCbvxDc=;
	b=fxqiILL3mZqGa0TgeIbZmuUxi3xFzuNI/OYvlz1B5JnKzBVLxl016VIw0hcrVQjPtI0pDX
	5d13hku03XwVXOl6zgSQE3/G0RghbvXmsvbGWPxbverqqeS+90cJQKlX6TT1cKcxt45Frj
	jdsRs5z5O6q+7iLa9C6QOXArBt7flR4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jpGvcg/vVj9yhhrnmYIsUu0bKb1rFYX6LjPWInjt/8LTpU/LHFyuHsS7RrZZQ56zwVWum92AWPNSE6QZaogjV+I9e80z1+hzJyssMdjD8voPZ5Mf2d+PWjJVTomR9E5WnVuGHuAXMX5BNqDEiIJYfxSeEVZV0W1Xw2BBBUcTNivBhHonzA5tE52wGsRvdEErXQ5pizKZrTPJ/UYBWv72ZxqO/O3KcFIHoxe+mLr66wGIvMD1m5Wt1dc/x2MFA6tdtddz9NxGM7enDmXY3nn1sUuXBO6HQOaKhVggGfhxFDvGZGJYUrJDoIOXnS6MgWyFQULedJWqxRXCtD5U7OEJOw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOXd5q0cOZ2LLFsKgopDMU+oE04WeJ6OcHZqFCbvxDc=;
 b=SeewuoFog4WaDTuEPqRWI+2cW8JxTsyh1mZzY2JUgHbNWY4BcWRAHtyEXJO0eEYawjlRB8u0ZS01fS3IrZZ2UFIAz0qwopN2wfBIwyEsRjeRjPCPkScNz8dCLuF0V9vMhl9yF7QIt1oViUZgZpuY2q0RcwgQ5C/C4s1tf+LOHbaWBEbMQ4HXfNpqqMBH7IpE99YtqB4tKcA2n4nbFujjVy/gGsPrqYwU+gtvIe5ZYoBtfUWASeNEbJERTYOZVaCVE02g4AmC87gfUzf6q3pun8FiI1b5E0g7tbgEnLdLfD8aevWsefnsvLOXq6uTTaOYQwxa3bpGbAj+e2yzwP4l2A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOXd5q0cOZ2LLFsKgopDMU+oE04WeJ6OcHZqFCbvxDc=;
 b=dudumu551XldHBKqBRaF9gButeOZ3fgj7Kp2hfQ2hQMTYeezZiNAEfKEUQbw98H8+vojqC6cH0TC7HtIEOwOmdWllt7XXqx9S9wuuGNIhOHfmsy5wEVjIBSxSJ1A0r0MJ10jkguoxTYFqveyZ4qRSjsNvFiWHMZyXuDbBsflN5o=
Received: from DUZPR01CA0070.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::9) by DB9PR08MB7511.eurprd08.prod.outlook.com
 (2603:10a6:10:302::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.13; Fri, 19 Jun
 2026 09:58:44 +0000
Received: from DB3PEPF0000885C.eurprd02.prod.outlook.com
 (2603:10a6:10:3c2:cafe::3c) by DUZPR01CA0070.outlook.office365.com
 (2603:10a6:10:3c2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.16 via Frontend Transport; Fri,
 19 Jun 2026 09:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885C.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.8
 via Frontend Transport; Fri, 19 Jun 2026 09:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBoZeYI8lGvW09PisUm5pfKOl+ZsUEM3DjKQTJQhRheWpGmrLDqhfrSgB6oBk3jmwvjA02rYnAuzRcjjKO9OFLxwYcs6uS4dnfgdLkzKLfIrv+nfzVJpm7xW3V1QXFtm81N04dmMT15AGX6Sw59YKlWlva5a6DyLBuzzNgj1WiVYvp1GocsdtdlYOwJ615nLDGdx99Nk7NV/FtIzFTnH5CXAw7JZmktoBPicyTAqHaVM8dcssYuPdH7u9UjEipaS2u+JPDcvbm9I8U5sEZsLw65vNZ1YNOUbk2WN5Gd14KtkP+Yfu0YjrNUistfEMlJ2bYAlTXhctV6AFPbGwgKHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOXd5q0cOZ2LLFsKgopDMU+oE04WeJ6OcHZqFCbvxDc=;
 b=sCPKb7s5W5GsKSqBULbJ5UOMkt2bsHVKpa/Mnnt3vdd9kybUjMbrvFOHKkivZYUfbo4S6GthahuRRB3hCkViKphor6Uxwk9mJfmzn5OXECD9CJbprmNIPmsRoUPvsdIzwLL6r7lpd8Zx+nZxqkvpUcZMXiQUZyjG0Ynx6Uuc3jH7nXsQrzLidrJyu/PmHTbseeiRML2OZPxzudMrM1Wz40UwbUlFMSsFyn1zyfLGghrVlORidiGtTePS57IqT2c+zRluyBOc8n6fuepyaMpwRwZl3XVXg0ZytDhTwOzit/rn60ZUKCvnDQ8gEotBi82HG8yUZxVgUJ0hftRpTmsUAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOXd5q0cOZ2LLFsKgopDMU+oE04WeJ6OcHZqFCbvxDc=;
 b=dudumu551XldHBKqBRaF9gButeOZ3fgj7Kp2hfQ2hQMTYeezZiNAEfKEUQbw98H8+vojqC6cH0TC7HtIEOwOmdWllt7XXqx9S9wuuGNIhOHfmsy5wEVjIBSxSJ1A0r0MJ10jkguoxTYFqveyZ4qRSjsNvFiWHMZyXuDbBsflN5o=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by DBAPR08MB5718.eurprd08.prod.outlook.com (2603:10a6:10:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 09:57:35 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 09:57:29 +0000
Message-ID: <3ec15992-2a29-434b-8c99-8b86bfcf007e@arm.com>
Date: Fri, 19 Jun 2026 10:57:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/46] KVM: Provide generic interface for checking
 memory private/shared status
To: Fuad Tabba <tabba@google.com>, ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
 <CA+EHjTw6x-mxDnJjnhE-6SV73tMrb0paKDTtOC2j6zJ1fXZDLA@mail.gmail.com>
 <CA+EHjTxu32nQ+vPV7Zmcw76_-V4g2_g=P_UzRnnO2dP1PFO2ww@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTxu32nQ+vPV7Zmcw76_-V4g2_g=P_UzRnnO2dP1PFO2ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0584.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::15) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|DBAPR08MB5718:EE_|DB3PEPF0000885C:EE_|DB9PR08MB7511:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a63bccb-77c4-46d2-3427-08decde958f7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|4143699003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 0BarHkqB7oUdO/TPZn+CkBAWcqDOOI3OGPp7xS3tsksnEZ+kDpTW+AQNtAcZqakOWvMNMjfVdMwWqTvYTuY6Q6Xynu0UKGmBtw7raYoLQ1PAxYr1NmY7fOkGAR0Z3d41e3L/Bj/aqmfcwKyMAHV2NaQyoOsJcTCRpVNPNmbkWLm8Bcz7T7rcDZbCt+93V1GL4PhJSiEfFTtfHX5Lu6xMEaSnOVmeNvGKC5aZk858dMdnb/GXs+PYNrxpTTP08gAi5qXdZaPoKOcwmGiYAZeBdpolrzyDp1UYmfffcP7QBaUmsyntQT255/6+VyiaZQ1Pd0T5tgEQXn2OpT+GysTMDZk3uggPQz4smJYzMj12u7dOq2DZjZS6xdSkZcMILYwxvDhHrglRMC5Y6z1RHfa/6abmebNE28kzBu7bkdJK0Ei5dWmXxml+k24iHZh67QiZjaLsEjUu+KIHMYUZ4Z7rzzr+Q9x5vppTXzvBwa84Yz1jFwoNCkmQLfVPoXsftRx4UfQY1jK/KUfTvMN9d/JBZMp2X/c4YSb455goUntv/PzdilvbT9dda8iJIbcP4mBM05rFdfZRAv/MXh9WcTxxpy2500OXLLlTlH836CZd/pBtSqebzOciIDQUCAQbzwFCWcKywVqqHwDwUMwAwOIJA8ullli/yn0VCWSyBRTX8oE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 XiG73K0VTou2Q6upM9CVtC3NQJfszAsLN24pZXF/YSYxk30NzJdmmufE33ZaksGkGQuNYnr/2JbhQOnX8lgiSdSYsxme4k/qCV6dI7pUH+6eoF8y/SHUm8+XWvONVhLWIt3srfvbMrNsi+zyBBCB5JjU8I22DEPLFkbrzo90iQgzvq0MFU3WnxFX46zPiSOut4xWEDxIa1DJ31yWS0kylt39pitQEQN3V95oxUdqMKJgUxpLZ8jKi+70w5+LFU8lhj39hHmpR2kGGy+WmB44292OSmq7up9ItZ68KSokxDFzZkwPj0qGFVyemSbISzHPh7xDzz5xj+Nkua9+yihvug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5718
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	53329b84-b658-4fd8-04b6-08decde92cd5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|7416014|36860700016|14060799003|35042699022|6133799003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9RFjHCkReN4bC5E+m6YSzBhR1QjAgVGi+quLffOU2W4m0KevFe0OFrWrdrKvPqAtowDGEljURoTakFNdUybEsB2Men3T9KExJLmZEEYS6AULkBdTlWfGlPhsCPspeHZ2UvuyceO6+NbxGs3FdYSyj+SBtS1eAom08CAkvCVjA0/ZC3RzXwC4qoSaszpWIKGMiITFn3IRKHKtWV0WN6ZmCANofMHFjs28xgJqr7O/LIzuZWgNTwW03z3CEDtA4fcqgccFWc5kWRmIxivlt4x/yikl27IPWYKKUBeZhs4POflvlUvb+HxIbczEvrtSMLoHj875oPKwJwjEbhjnNFRZaQl2Ya7iwyQWSxDh5HfcUR+igwh65PviNKV7c//V2UXMC7l8slAgD0XCBwTUj7hQStD7gbQkBcJDM2XCPICErGnOyXbco9/ZiIx+VzvghqBoViJbL19kaBx2RbdSvaPIZesqL8dDTOa3Fc4B0HBoE1M8vsyMQabc8xiJIyFweE3ILHCfBfcBqy7ppng+pqBrozFgwHLSWXurKq4j29tmKRQsav7j2s7BYikc5NktkVOPS+pR8tWh/zQlviD/5UNkaEIH2WQ7R/q0+dtYC4ypzb3Ymlb4YpSnM/abFWNWqorZ+427d6GSCLaYkbMhY23KBOC8u/eOtWMOuEkJYSekon6tVSSRVLJ0u3RFRzmp87xMprVr4d14+2ZD9DxYJtS/bA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(7416014)(36860700016)(14060799003)(35042699022)(6133799003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hukrKrgi8pdGdH+XOQZipQcZ1wcI16sr5B+sZrG2IDrihQ86Dbo1dn1A4y2E98P+9YUGVNBK+7B/02qXrI+lpATnhQtjJOHoZOPAPJPCYgfaHc/up7uO2C3n764yehX7mC/M2eBHiVmoG0BqsnaBm9pOLSS5HQzuOvBIiFeVEEWiJbG4dvzGGGmeEn8yfMstVJdx+6nveHqFmUhDlVwfSPcCK8ZHjjIsEBnlk1BWgsWFLil4BP394ZC2HNTOPUNsZXpJCRwrhwTnPMYyynM8sXd3pJYLDPRlgHBvMW6w4OMzQjG43yLtnkOveQtDiq3JHZTtJMypIeoLRMRDfBFvspMmo2REomFSxeaPkHNwB2wppTzQY8m52DTqMdkH4Aby50RGU3xVpXWCP5g9Acb11VmktQKuTRH8xr95aMDrO/h3J9VBw4OoFvDR4dl+3QRe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 09:58:43.6064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a63bccb-77c4-46d2-3427-08decde958f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7511
X-Stat-Signature: 1yh56bibcgnt8bhabiob5jrnweq5w9mb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB0591C0002
X-HE-Tag: 1781863134-18906
X-HE-Meta: U2FsdGVkX196hi2KaKwd72A87SIisE5P5iBw5VrP0p+TBxXIB7lz98Kbv2lTcalQU+9TPbpyE6WLkuwtv2e5SuCDXPf5m0aAuyNmc91X1QpjZXn5XR9FbI0QZD0h/xGKrbQ4T4GQ2jO/RhFPhgLhGw1/30AoUTvfK+8lCtzHVdCM8P9Il/Bb18MNDPFq3G6+6kTw0QtYG0txQ9HDYE6g4dp7jG4crO61HN6CEmO6RoCy2ELMqTXk6Xu3lRDp804/EQrXNlIeE67J+YujaKSbVK+BbERAFubru1fg+4Q2T6Q8qpJhp4kwgACxk1xzcp0VfwlBbpkW6eDn4QpYgEoZ+Z/ZcnguxSx5AvjHSmRYe2+TbZaWyIhTcnklT7LzXh+IwFzrWK7z8AIsJ6pVgke3pUcmTPZLJmY7rImewEds8O4SthO5k/lkb5mwt2Q2ql8FsT7MP5mBKYrRw6ChLeWGT9rWDAhuoD9gzqdY5kxcDCtsuFXsLX9Y8BKlBMuLg0TW/vy/XkscTuoqlD2hm3bX3Yya9l5qXuLyKA61OQtGhrIqz3TPHLHCp57o8c2NJMG59OIQiZwVeKYWh/t/vorf+5mnogBdeZIAdhIzoQnZMho5LuOYF9DT0DvyRKxrZMpRIn0W52VOPLiq0PrIgXjgDJGLGOk2YRiTv5M3NTr0EGWsmyOKAPuADyyhKqXpxcuCLUsEAfXGJnX0EJUStKShH5VBgUqc52XsuOaTNuhDICVFoWjPXwuo/ae8GoqqGGvL2R1++Wx+84y/TnYwdvVqYNBsLndXlLm1qIKjzmNd64jZ7nIUZxphd2m8f+LQCX+Eg2ggd4T2JNY/62SCyal9K2pwCBtRaSfjoRqBpR2rRIx9woWKsIocnD1AcNh1wzAakPIn6Uk5a+zsjQAK2vz6t1UEMF1ROJtsyZI9DcBReKyCMBf6hGq4agcfoStB7qxI051FgHb4aFHZcL0sX1S
 RuJ7ji9M
 MH1YL81o3Ximw74Q16mBwxp+Xujq1tzQ6PtIPt8R5n+93rwH4MnrbOocxjDUH5g2Z+f03zrZTwmIit2DwvJljX1AeAAnmpKBRd8rhia99UlB1R+NXDE4mkmbygnaqJalqVp4SykcjVGVEcs6wSEfZaZieYIxC6A0s85wFolKTH5AqhWaLtph322++hw/wlh6SrZx+XnzajEbqMFp7+Gw581VR/kbOye6IkgBNY98DQZT7ZQ5b1hNXCNJB8bgdEKy6TX7/bAtN1+qrlMVJakwAxkTRkzx2qZldkGUx0QsbXqiejIWDYoRIFTU0k1myglqvIQ/GW01PjiCiz66kB+u5rBQVuJLfxfE1ayJqvsM9wkDuECg2/vq+C3Ko2p/z2vOrJ3uozF2kN2+tomkOVz/4P94UbSOl9LZuxGUj8Yh7FbHJsf/wku3HyiYz55cZ2+tePm7kboHtIYa8lFxfdPCbZKFHInJN603rDz+d31eJg9bdaq+fpvJZqqagYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/06/2026 09:21, Fuad Tabba wrote:
> On Fri, 19 Jun 2026 at 09:19, Fuad Tabba <tabba@google.com> wrote:
>>
>> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>>>
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Introduce a generic kvm_mem_is_private() interface using a static call to
>>> determine if a GFN is private. This allows the implementation for checking
>>> a GFN's private/shared status to be set at runtime.
>>>
>>> In preparation for choosing implementations between a guest_memfd lookup
>>> and the existing VM attribute lookup, rename the existing
>>> VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
>>> looks up VM attributes.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>
>> (SoB fix plz)
>>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>>
>> Cheers,
>> /fuad
>>> ---
>>>   include/linux/kvm_host.h | 12 +++++++++++-
>>>   virt/kvm/kvm_main.c      | 15 +++++++++++++++
>>>   2 files changed, 26 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index eb26d4ea8945a..3915da2a61778 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>>>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>>>                                           struct kvm_gfn_range *range);
>>>
>>> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>> +static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> 
> Should have read the Sashiko review first, but where is this used?
> It's not used at all in this series...

See below:

> 
> /fuad
> 
>>>   {
>>>          return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>   }
>>> @@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>>>                                                    KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>>                                                    KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>>   }
>>> +#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>>> +
>>> +#ifdef kvm_arch_has_private_mem
>>> +typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
>>> +DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
>>> +
>>> +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>> +{
>>> +       return static_call(__kvm_mem_is_private)(kvm, gfn);
>>> +}
>>>   #else
>>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>   {
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 6669f1477013c..8b238e461b854 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -2627,6 +2627,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>>>   }
>>>   #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>>>
>>> +#ifdef kvm_arch_has_private_mem
>>> +DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
>>> +EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
>>> +
>>> +static void kvm_init_memory_attributes(void)
>>> +{
>>> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>> +       static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
>>> +#endif
>>> +}


Here ^^ as the static call update ?


Suzuki


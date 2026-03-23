Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7814FF4613B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCECE6B0088; Mon, 23 Mar 2026 11:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6476B0089; Mon, 23 Mar 2026 11:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94B26B008C; Mon, 23 Mar 2026 11:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21446B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 679F3BD458
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:08:12 +0000 (UTC)
X-FDA: 84577658424.24.BC52E42
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010068.outbound.protection.outlook.com [52.101.69.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id 746D51C0017
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:08:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JCcOCQU9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JCcOCQU9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774278488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcQhD/JXrnjUPEgAKalNxm7BB/KRjbCIU3b5hOKKpas=;
	b=SNMo7WQynPdBG5919B6/xSQnyi6XBspXkxMqOAxV0S+WxvXGEUjv+TeayZszOLfQfiQh9u
	jGT5mytho77dS6vJFavRvHsIWtksps5CdR7UCk3RftVWPycfJLxTN65Wbd5c2c2oxNu6+V
	l4SerunmZyJ/ILOGXGeV8FfxW2iZX1E=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774278488; a=rsa-sha256;
	cv=pass;
	b=sWe68yEkuTeReO/xEy0rB3nuBIm3ricDNt23vsj39bsUh+joFeErFrhJtN4/UF+01dInya
	7LlEEqEszgTiVrEzMf3TuxCk21ZaFFHCwRlevwDRgXMz1/d/QDoRkpN6VU1kH4gsqOtPff
	WY4gvdJ8vdgVXXe1N2XOJKXg+bKn2Ls=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JCcOCQU9;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JCcOCQU9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.69.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XElzLdqg2gCEcTvy2xQf885A0dweo/nJ/vNLySVSfu35fy7VqfPfAcF9dOB6Mn84YZzEu7SODDyzfoZkWOjqLob2n7zkmbIIq7Zs2C3dNPI6gsMDHK2AIu281JTpWJWHRrDqUiD3Jx5Sm2oaj3QpGs1ZLxHBo6zRu0dEA4EdjEozNTP1w/KbwQvbGVFvxQeqkpNwnHXGCGqbIxvwkWk1qz6vKdpllLVBso6IJh1CETWzOQdylpmQPEFS62twM+Z/F89F/mHbqcpt344gSczkzyo1FZsD0DmgUMZ7R8rEGCdSmWTTIT2epdUlFo/ruoPypIJnaikv3T6tyC1SYrfTrg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcQhD/JXrnjUPEgAKalNxm7BB/KRjbCIU3b5hOKKpas=;
 b=L9asw7WJ0ELwv5Esj8hnMTUXNUqmZ98Ke4mv2DCp/vXpRipbpkLrSe3Dzk/ht3nl3lHsf/UIkdKV7oucsA31CgdIzBVuoQZ1P9D8at8O/N/2Brc7xsJ4mH4Pep6I26XsVanAnOv5SVy5PiVzuU34E6rXnqIyVAmnc2ZvvsvyzNUe0/qJkpe+EEfycyF7YePFaPAwhwNPKRoAzip4b5YZxw4f2XKJOE4ERjaIH4O0vj6KIOI+uyPdizo2E4hYHXua1J7PXgVgDwMJKb8LAETVMnDvH6x3TWHITmMta32YiJj62iqVHNvYNAeQCXEURBDguEy7XN07n1B0JzrZQLJ3EQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcQhD/JXrnjUPEgAKalNxm7BB/KRjbCIU3b5hOKKpas=;
 b=JCcOCQU9n2GlRUYrVFiO4vABXy4DeztUo/L2z2+BrWizPDuTjiuL1ZuZYZIFEQNM2lPNz2P6rm71iebXc7mFF0KXApj4ILVAMM7RanhKUOcGa3RCzSgByu5/OQeOi9rb88GIk3hdLcKSLciZuMLJJ0V8x2xpzhRRSSsNFA2mcWM=
Received: from AS4P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::9)
 by DB9PR08MB7448.eurprd08.prod.outlook.com (2603:10a6:10:36c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Mon, 23 Mar
 2026 15:07:59 +0000
Received: from AM4PEPF00027A67.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::6f) by AS4P250CA0020.outlook.office365.com
 (2603:10a6:20b:5e3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.29 via Frontend Transport; Mon,
 23 Mar 2026 15:07:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A67.mail.protection.outlook.com (10.167.16.84) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Mon, 23 Mar 2026 15:07:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLzTvh2PVe+Vl3X6kI1Fa6srSBjh0bRhEwPtbngLFLER4sbmEDLDsmPhe862H5hG8cZq29byzikUvSy8p5nMynLJMzyZ4jF8d6BFMpWfT6wsMgUviDoOaQr3cQRvuT4RVe2dKYCTAOo+OJ9kxqQwSvTMURaDqUrcB9XbzYz065bRrVyR0sEBN1sYjzT0DTGQUqOdsa2avhaPXD1X27A+y357dRQnFWOLw2f9eeR/sOLBnYEErDedDUsSx8Sg8I59TtB736kIcEIGOnJSWl/2N7Te9K5/yBfwfpKfEJ7XWMytoVvdEVWYFQaQljhvhVIYk8w3CRjg0bYr7G7Pe8SspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcQhD/JXrnjUPEgAKalNxm7BB/KRjbCIU3b5hOKKpas=;
 b=yL7FVx8osTYfLoM8F+hqydi/AbOadVDBNX+VgBVWoqJ8x8L8tA5Ng5CLGIMnM8zBoEGJRheCUvKFD0er9SUsaZ37y2iqMviAAS+wV59LEusG0BzobAb068KDhDAwIXbnZrFloZAAutBUpOXszxNTLLNNIgKdS4NmZoqNo7aC0iaHISyxsTDpaxQoMoDQC0OKoVNeAGbDCXRbHD3fZwSFs5J+MNc1tfWHEKGykim1BmOn9w92aG84/TiJgVt25F7b6Z9CBh2T2nfdQXHvE5HLHOiuMQOigsoCEuqSIyLZH5MLLtR/2TIqSIsOq4rDggCsx2u9hbM5gLBpMkayyPxrRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcQhD/JXrnjUPEgAKalNxm7BB/KRjbCIU3b5hOKKpas=;
 b=JCcOCQU9n2GlRUYrVFiO4vABXy4DeztUo/L2z2+BrWizPDuTjiuL1ZuZYZIFEQNM2lPNz2P6rm71iebXc7mFF0KXApj4ILVAMM7RanhKUOcGa3RCzSgByu5/OQeOi9rb88GIk3hdLcKSLciZuMLJJ0V8x2xpzhRRSSsNFA2mcWM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by AS8PR08MB6311.eurprd08.prod.outlook.com (2603:10a6:20b:290::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 15:06:56 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Mon, 23 Mar 2026
 15:06:55 +0000
Message-ID: <111b71af-a175-422d-a7d6-a204ce6f679f@arm.com>
Date: Mon, 23 Mar 2026 15:06:54 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Arnd Bergmann <arnd@arndb.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH 0/3] KASAN: HW_TAGS: Disable tagging for stack and
 page-tables
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <1e71acc8-8dde-4fd5-8428-e76e8c86121b@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <1e71acc8-8dde-4fd5-8428-e76e8c86121b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0094.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::9) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|AS8PR08MB6311:EE_|AM4PEPF00027A67:EE_|DB9PR08MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: a2ad6dcd-09ca-4895-8381-08de88edf844
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 3DI1KSWXSJ/zv850oLbKu8kF+qsbpdAXOcpksyE7ZCOmqnJnYuH5xv8ZoBcDqzinMAp4aq3YTCqcLpiWBgiksTU5aflMnsvLYRewpraYzadPJTfegOU2bj8RnSYmCHuRh0w3RzivCYD2nmaWP2AXxVaqQDUtC4XLIXoX0dNpw6ZKObZ8cCw+Vz4haYGmWt2arU7kxEBeRv2LK4Jau+xxds03FjuvGNGVrWm5ZuxLQEpUIDH1rckc77BJJioPsrXanT584QL0tDLZovbNQjKpKklGFHYkBQLUH8ZYdDt9xp5hwtmRFUZMKcaimyWr0CGbQ2xXGvYeRYOkHHTmbFyjDsgjGASO1gx6gm1eTgdLoOC1usCmwrevhRFhkjHGy0KZZgkw7K0RsLo0Yz+M2aG2Ba4OM275tuF1ou04RNYUdWXjMkerJ5B7ufdvH+4C8XHWCF1Peq5tPkf/wC/cBeXs2y9kyWnZKfUYANg4Cqn/jWMxv3CRR7U6gNunbLGU+eOPGaO2Aexsv/4IgMwGDQUYpMDdP+e84scef88TrJKs+Fr8uYD6aseElWEip3wnYb5j7C6O2M3oCAxsq/qTw7X0FbNkIxH4hpDVXPVZTM/gLGTZJhVETHyWvso3WduLTSe5I/YDql9oL3iMI1nlVsj5eWF7qpBKi9ZFJfzf+wtvCsP86HewidMPV42GM1uLHXHveEGQ1uK2LX58PihXHm7kPdbV+qXQqW3ug3l7HnWYU+8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZZfXT+WfQMHFxZXlM0R44DnOGdauRpzgKjjoSp1RtXBZAAkkaNTZVk8xzSB0qkfky8uVifMNqGx2qbw8hK4TtjHpCqr2YzXGY8SMgC9IHr8WgNvd5cRdFKLAjNLVkM8A92VYTRRZ8eXSUAmZ5aK3WPpx1Of1q0onmO9uoXzX9o93xh1TdtIOcNUCgaj7wSBtV9mtokbtt1w4/0ZrZvxfxCamrUMAnxml4Bnj4dUR21HsCt0nEWENxUhoJ4A4i/Iyp3uX5WMjbh8EaS6m8wyPHZRwCNAhWiFrL2n9w2ELn84KdUE6BtICk6SDSd/3FTyrb5grMNjcS6h4PsSNLFV7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6311
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ac338afc-6ce6-4b16-43bc-08de88edd2c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|36860700016|7416014|376014|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	woBHSWsf5+SQWYDXtqmk82Flj4y2hgMsTs3OaGXsj/1GJ780KbLepWGn1b03fzZo4ijBIhjaJkwhsGpIMLGNBxw8UmSuHunA72qHHuH8pTgXQBGvP7FVpCwbM233eg8vXsC+7yrD3TG8RWQN/L/+Vxs5Drtvw8vK0YwJnl2bit7RtMvKnKUHKXP+O2+5+SC/qxDtZTQYMS1fQ6AWxyPy9Tdvi/cWNK2NjqyPebunAIz+9u3iIGLsciEuG48kP6shL9XgfMcPdHCD0NNgup88MA+ciw/LNP+vys0LJovI2ToQTztmgkf5Cvi1C8uPHaUqXCX5GhFquJLdvM/w8gUxEHxm0hSJDM7Tk2L4DpnFfUxP368Vfeg4dvExTzE8dTWomVtK2KmjEHVXtMhlnkQe0LLcj6+M0D+95uOMkqUOJlD5pSibu41WEx7g/WZ7QtFCi+wDty4qkSibsUjGWg4gvPGbDYqdrn+/w+dui1XvPsptDSY1DjqvVBrL1rzl515fafuTIfBfvmwLdJm+FDWYC+m/fbwIYwyyybWyhS25eIxq+/6CiDKwf/1shbfF9WmkREOM3lWm6JjJnDazZi4m1obHGGE6uyZ1Ne+4nSJQguqkEbsYehj5lpf3MbmdBB67XJIebm1Zxw9kS8kbhmRNuRyxp+6cey1UE4WcL0PzAHNxxfj8boOEZzMzkjL9Oga/zSd/N7pZVh4Aw0sFWITMzpydvG0hG+Z5sBcKq9z8Twv8lUpYSZQW7L2kbenweTlwslacs2Sk8x6IADmmFDkEKg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(36860700016)(7416014)(376014)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cjn4vIXHeA6kk7R5Fix9FGp66eX8sMuFuVd7viq7uipUw9A5u/6+6QYLjP6N7eZuKgrt57I7MvEH63ORsvTeA0uF38SNBRpa9fisj6zH3a0KpFDzbMZmiP//1DNvmSeHlzFoa2IfLn0UXpAIkvasyUIZ4m/RSOoBB5dY3cZjcICfF6pvte59WlfvKJzBQca9vqDkYUJ1uf+OjF1YjI6tT5pZ40K2wsC0NWiyXQrJUUZbTocC3zwf0GaheP3g+g277f5DVpKkPwaF2KF+1EzCj1nIrl7xqYrFkgan31GCqwWur+9VISfV/JoZ5sar0iW4IKZxRMJKxPjjFbXBwmcbjEjzI9HWu7NNP55tAmQTFX6fHmn7G8fFbU6JV3oK/+3dwYZwRkp2eNDMBZsSNvYuhlP0pSH2J91jTkH/vqgPWv9PZVpW2g17TfFn7POCaY3q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 15:07:58.6100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ad6dcd-09ca-4895-8381-08de88edf844
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7448
X-Rspamd-Queue-Id: 746D51C0017
X-Stat-Signature: mbqywmz3krin3m74yb6mceo1cgf311im
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774278488-544207
X-HE-Meta: U2FsdGVkX19VzcrFolaeWZlYcUgQWnIYiPhrswPuMLJDfWLSFmoqao/F/HEAvuhKi9wGqwD0kgelXOUD9YqzsDmyFnI0c3z1p7KvEZZC1puMgwlqkSVLzHGEjDktFcKx0lqD26/i97nmffu5MQ9eoYIXqGKHMdTDJdjgTmYFf9RKEGoQFGLFcoef3on0U2dBZnl1jgoMRXMH9SbKCnOC23lO8x5g1uaLTkA9FyC/maV5S6I18GWd7tvQOQnrwcfVi3LrJdl7Tt8K984/n515An/bBEJ65LG9DmK5dP+QAe7r6njWyOKOaIH2m1YVj9c8n+2KgOZwgWkwyFB3SAweD8c7GvJaonXrdK3TurgVE95tRDOa9DnYW4X9Pk9ElnTuT7kkeKy5psvtMNVsWLs+YkMF41gkkKvMvVjSeUugf1L0CmqcxauMNZejuEqN4B4U8r/ZtqsdifRVdpy5FS1moimBv/7PuSnIureG4SOqgbLPsnqJ2Dcv3i0w+Gz9wfSDf87SOWl28mFbYjHwnCJTSwnPuj/Dydn+Yg5O5mXNUMHXo+gnDwifKOxfkbOiMdMZSdb5O4VIjlmiYYCiwCctl1b+mObu46Ry8D8vHmax40X+p0vOIJZXzYuuyl6KjozpPl0wov1pAy78VzV+5PdIy0z+qmZ4gq240a+gaxPAHg3TEgm7nmn6F86CdgMcEQzC4VaxRQNEMAZFVvJu0fLGOAMZVEPQmcmJaIaAfxMPOa8J4m6WhljXf/RzBqrDNkPtU7HbMLy3ibVH5mp1G7FWlv86au4zi3yk18wr7J4fox+0aJbSYoVZHzmylDK4+cSX0juZsbDsWKhEBjwi+/0cCqY45j3lx0XPkw2K2kKrQ6Hlb9KPPQRR73RwFMB3POrD74O1ed1agA4QVJEDt1zalt5QCweEcKJvs0yKqkcj4A4ygUcBYHKxzAtbN4unyTgVb5jHYeXbwkNm8rk0jKW
 HjLzDWxa
 rbykrEwXPuSr/3pu5Ul72GsxeqPOHiklA1Nv3SRgiPq0DHPrYirWnXWiBo2JrjT0VEsWJogDv4/xShmZHj30L/skzl5cd3CMVh8c8i2OvlKvXclGcf1nj4YxHIY8ejORGF5YuVmx8tu0/lKZvfUFZrEajdq5i5jjt4KBrEglDZXnoj2+XiSUBegozftKwUYUW1xd3IGfOghUaqikdZ5DlZ0afeNhjbGIYgvRy2+4UGMr3PUhzLXPDIFSRpLnJSfOMLOGiq/cfcC81a+Nhsgp1jrBZrnqK19xNkBVWqORBh+4fw0hwoXIaYo2LWUSiW1us8H3/vI5yzaiX94/73s0vyiYjhYRi2MUSNuIoJY0SuuvQjVxpRd6YXPpCJWCdOcx1MC1TkVOAEvHkuGh3nvqv2+UxJg+IxD2c1lGbRlqP9ggZUDJhca5Ok4DYjA67A2/Mq7ZDB4IuPrI14T/KxrHeV2GRBmm6qz2YQ9SfCExzA7k8K0broevvmMSb4tYyMgIUvSU03k5kzHIByRt6+j31tj3VZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/03/2026 8:53 am, David Hildenbrand (Arm) wrote:
> On 3/19/26 12:49, Muhammad Usama Anjum wrote:
>> Stacks and page tables are always accessed with the match‑all tag,
>> so assigning a new random tag every time at allocation and setting
>> invalid tag at deallocation time, just adds overhead without improving
>> the detection.
>>
>> With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
>> (match-all tag) is stored in the page flags while keeping the poison tag
>> in the hardware. The benefit of it is that 256 tag setting instruction
>> per 4 kB page aren't needed at allocation and deallocation time.
>>
>> Thus match‑all pointers still work, while non‑match tags (other than
>> poison tag) still fault.
>>
>> __GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
>> unchanged.
>>
>> Benchmark:
>> The benchmark has two modes. In thread mode, the child process forks
>> and creates N threads. In pgtable mode, the parent maps and faults a
>> specified memory size and then forks repeatedly with children exiting
>> immediately.
>>
>> Thread benchmark:
>> 2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)
>>
>> The pgtable samples:
>> - 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)
> 
> As discussed offline, I think we should look into finding a better name
> for __GFP_SKIP_KASAN now that we are using it more broadly. It's confusing.
Agreed that its confusing and the name doesn't show its under-the-hood usage.

> 
> The semantics are:
> * Only applies to HW KASAN right now. Otherwise it's ignored. So it
>   doesn't give any guarantees.
> * Will currently leave memory tagged with some tag (poisoned), but
>   tag checks will be disabled by using the match-all pointer.
> 
> After pondering about that for a while, I realized that today, all
> memory is tagged by default, and __GFP_SKIP_KASAN is our mechanism to
> request memory that will not be tag-checked (close to if it would be not
> tagged).
KASAN uses the poisoning and un-poisoning terminologies. It depends upon
the type of KASAN enabled that how poisoning/unpoisoning is done. 

> 
> Is there a real difference to getting untagged memory, if supported by
> the architecture.
> 
> So I was wondering if
> 
> 	__GFP_UNTAGGED: if possible, return memory that is either
> 			untagged or that is tagged but has tag checks
> 			disabled when accessed through page_address().
> 			Using this flag can speed up page allocation
> 			and freeing, and can reduce runtime overhead
> 			by not performing page checking. For now,
> 			only considered with HW-tag based KASAN.
Its again confusing as __GFP_UNTAGGED will not return untagged memory
in case of KASAN_SW_TAGS. 

As __GFP_SKIP_KASAN skips only for HW_TAGS mode, the more appropriate name
may be:
	__GFP_SKIP_HW_POSION

No matter the final name, it may be worth the effort to rename / do better
handling of this in the code. Let's keep it a separate from this series.

> 
> Would be the right thing to do.
> 
> Assuming we could/would ever change the default from "all memory is
> tagged" to "all memory is untagged", we could similarly introduce:
> 
> 	__GFP_TAGGED:  if possible, return memory that is tagged and
> 		       and has tag checks enabled.
> 
> We could make it clearer that there are no guarantees. Like calling it
> __GFP_PREF_UNTAGGED / __GFP_PREF_TAGGED.
> 
> 
> (__GFP_TAGGED would obviously be something for the future)
> 



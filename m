Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376B4106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F4C6B008A; Wed, 25 Mar 2026 10:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F686B008C; Wed, 25 Mar 2026 10:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8176E6B0095; Wed, 25 Mar 2026 10:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F78F6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:12:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 226BD13BEA6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:12:18 +0000 (UTC)
X-FDA: 84584775156.11.A77A0AF
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013023.outbound.protection.outlook.com [40.107.159.23])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64EA040023
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:12:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qjw7QNUB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qjw7QNUB;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf27.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.23 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBDVhOjifwpRiAck7PVguDC40k7zDBj2sbtoDpWgUbA=;
	b=3V0Ibs0kjwrGMbexM3u0HRizxn9BNZ9CZk3tY/OU0MUFLMhHolwOIIEKyIGc8veNYTDBtv
	cLUjE8M7/bL9WgduC3m4RGIE4SoSeDsFMWsHef8fh45LIp3BtTIVsOU8Uhu2JMdu8EWika
	3YjgOSZcW3+j6LEw6E1aDhThswq2MVc=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774447934; a=rsa-sha256;
	cv=pass;
	b=KjRpBki06UyrmpSqAbb1ajpJjudRZmxMb0oli2CHcwdj/BdI07eRGZmCxL2w07Z8p4nhdP
	vajtYn0zYjo0SulgDn1+sW9FY4hcqrRPMacvuanJHrThoszBtTeX81EED680cDkcKKeEWV
	8uTnb0OKG+ujwhMr4TgD381pIOkuMMM=
ARC-Authentication-Results: i=3;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qjw7QNUB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qjw7QNUB;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf27.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.23 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bGzOlaNXmXuIoygiNsSPL5+WyRyUBH59ImyodMeqGxD80WuybUfw3/68ZqHRJzp+zed/jH8B1tF2Rdr8+9CfCmCOYFndEYGKiozFub6d2/RLS2FJ0Bu9kPS9uEBa9La26mxBeAO+U+laYPS9jWGq38inU2IVFRHqmYdoKDXyaO9wT/P9y63oR3b+vGa5AsrDojIRyr81QUJXw32zQMoBwYoiZuYM/8MVE8PHMz0kHp589YlI5TbhM3ZCVvcEKcEjDztBI8sxXtiFf3BXkmEfat9QFrPtERH+a7oAupCk2cM7eB0Rq2sTMWPpg6/rA5Znvz0B8vC+OGxr1sWm/RJWSA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBDVhOjifwpRiAck7PVguDC40k7zDBj2sbtoDpWgUbA=;
 b=F9/rGIYo6AF1qMft5CCBWTp2NGKhyUzGigNE/R7p1JD67y8r4J8Ns+sU4zwdIdugRIPdqfAkWwAdK81BnC0NRX3SGNZcyPzaFSvIrVFgMlwW+TAVzO+TOLqm1Tjnr1atyp7eQP/EVLw3anRBP+ahXxggqRYUv0y6o6VnGaTBVv0GmxwSUvMf09zUNdn9IO7R7ECWlPWmcN7/+PMGWR7bSNWCTDD54vGrHvZBX/Nx01KB655L7ExDS/4NJXILyCMoqqeQAWy/uUdWP+935brMCWPV0H4UViFXW83FLnUkShTOKG8S19z7j2M9yjrZWcJQzndnUDI6gUaar8Qlsp8kMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBDVhOjifwpRiAck7PVguDC40k7zDBj2sbtoDpWgUbA=;
 b=qjw7QNUBvxo5/HHkOwDmAqlgrfDwkVPm2C30kDyD5+b26AIcSjonfq3tqzWHWZh1ZKQ8iyoV0+CVZuVkP99QsN3VGiEWN/h2r1X1NcakJCo6y+0ShpED4M8SPpn1npKB+MQqOlRIwiD9pQItjXEy97+uxiiXsBDHr6RGTjYQ60k=
Received: from DB8PR04CA0007.eurprd04.prod.outlook.com (2603:10a6:10:110::17)
 by AS8PR08MB6024.eurprd08.prod.outlook.com (2603:10a6:20b:23d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 14:12:07 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::10) by DB8PR04CA0007.outlook.office365.com
 (2603:10a6:10:110::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 14:12:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 14:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMsoIFpW0LHWMkvWZjaCEGMiyR9pd0P2URKXAGVLwaATffPmqLRONlkZvZ1MOXUMfBrb5arPq5Xj6NfiZUm4o6mdmJ1QPciZOu0Lgt/UhyAaafuS/7nUVJ3+ugm96wCdMeIOhy68u58G3RcCx1qWUUA5iyEPFwTIexYmAqf53krhdhk+7TXHwCnIFGs0Hd6fllOvjJHonvde7rcmMaGKNuMbRt3bbxcxxnwUZcfee1Qlll1jB+47/hg+3QRoLO1nzApMrvZxY+EMSzjP6CekFC6t/XYzFnBOW+b5PzrZ2Yxa3GKFNmfgCWM07teso8pgfRGdUL1nc2xk9tLJBcrNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBDVhOjifwpRiAck7PVguDC40k7zDBj2sbtoDpWgUbA=;
 b=HzPhsIkiHhwyRjAtH7P2Q+o5fnrKQQcjabwAnabqhsgcfnwE135qfSh+s72yUgJkWK+fBq+KsYfKZ+8RF4VE20tnaruh+pis2L/Vvobrm+t8VBJFiP/+hnRHm4BDrAmpD1W2khCBpn0FBaiJ3QL3ya2zLFAuVzJ/3gBUde9O1Xlhpc94i3OQvvRh29iod/K36r7gNsitBlAC3j0fBK6z8NJKM/3Lmc37RB4pCtEaQ5sFVb3/HJreY8kiWws4wJr4n7aBW2TRHYAq5Zqn29RZb+Rn+Woa+UvsZuLLkU4K53eBawWyRisZl5KatCWIK0dkk/DRUIKdLaRQStjbLvr4MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBDVhOjifwpRiAck7PVguDC40k7zDBj2sbtoDpWgUbA=;
 b=qjw7QNUBvxo5/HHkOwDmAqlgrfDwkVPm2C30kDyD5+b26AIcSjonfq3tqzWHWZh1ZKQ8iyoV0+CVZuVkP99QsN3VGiEWN/h2r1X1NcakJCo6y+0ShpED4M8SPpn1npKB+MQqOlRIwiD9pQItjXEy97+uxiiXsBDHr6RGTjYQ60k=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by PAXPR08MB6654.eurprd08.prod.outlook.com (2603:10a6:102:15e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 14:11:03 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 14:11:03 +0000
Message-ID: <a5689d05-018c-4a21-aff2-c03157f592be@arm.com>
Date: Wed, 25 Mar 2026 14:11:02 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-2-usama.anjum@arm.com>
 <cd26436b-539d-44bf-87a6-0109eb8e26f2@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <cd26436b-539d-44bf-87a6-0109eb8e26f2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0473.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::10) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|PAXPR08MB6654:EE_|DB3PEPF0000885B:EE_|AS8PR08MB6024:EE_
X-MS-Office365-Filtering-Correlation-Id: 21c88052-f90e-4237-6d09-08de8a787f51
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 e3pSu3NrfQiyPTkZJQeNTIG1+IehDsxE5U9iGRtcI+8f4Y2blpk8n/MmlTa7aPkJyew5GUbA9d2SIaGWsseHZwXQfdhHAs2X/CuTpudRtt2QeQiFpisVIapz6CK9E2WO7yM8rdiMmW1MisJmAszMJFlJudbtDwm1oLsiLkdm1dNWzFQvDs//2aYrBH3nIL3ACo8TTHlf10uVjiCWZQgVHhjcLTuPeheIN2rmHIfem/bFqiuo5MHuelUfpScNpfjzSU3RXmlArr/YMRjCrrOjFhkOEQtcXJjqExEziBw06FQNLU5pbSh8J8zDWfzaSHHig8buUNQKFeM8OIeXtJK1UP5rW3HlvV3iohY/Dfk3zccHH7bq51PcKKfmZmmK4WmfsIsj4lyqOrJt9ZU3fwZ0iDWHMnSIIKJeiMhcwaw4SAtiNmLZwivJL7/MABQj5hYH2f6QL9oLjZoEL4/sr8SI0gpVtexEpUtorYIO/BkfPcCT2tz5PXX9fVCfJRD+5gUJrcNiiGbmtjB49ho9iOifjlWkShaO62C4Z+xSbmb7I2HPtc0scfGAC+aOS0G5q6s95hikfuZTRjqvRLLbaFK00xY3UFCsMrMMftoE0tLEa9wO2sbeGjhc9ciVrKd+O+vnWZqgMOO9WqCbkWiTBluMiElhAgu+s0t9A/ZxbtUQIBo/qmRVBUpca6aH/7SbVLNfvxU5n9sN8QE218RpSYH97EqDReWWyz2Ln22npE92+Lr3nSgvwSet0JhMjRXxvVZwLQ22RSvyi8buxMnxj7jTPw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 P1U6/pYdO3OzbPRujPQ32YApKllnIkwgQp/5r66v6lGG5J2je9P39oojftkUZVRnAb/HVVU46zQe2LhtVErd+o0hR79durrC1VWLjetU+/6/JV2U68hwcAN1tvJj38glvPAV4JKi+H/WIe81ni6cRmoA9U5DZH6QexplCRNJKjNR8LCvtUSlg/EtouNzfXqfdihN6h2mx0NxhZHYT/88NzRu52KBQFxuoyof37PU5H8MAJuIis2G//OaROazE+F4Z87PDIQFG7UMH5tjKANdJiQ3c1PIm/7jRM36YRw9P9NGb3hMekOw9Vai+9/cEyN/6W5pucFX8bUkYO5YEauxlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6654
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fec1a1ed-f7b7-4d26-2ffa-08de8a785947
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|14060799003|82310400026|35042699022|1800799024|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fIy+bYgaskPC5/KJYz53+LvUbEXKDNVLFrFpaNbrXAQYM6sBttdh6mWrQvo1cmJt7kXtHHb1KwTAJjUTd//cXddfIfuy2tltI6oolJO74o7hCFesHYCh4dG2xsUO1XEZCgj/RpquihJfI8cyR0c7qRl60ki7VtGyRim/e9gaJUfVRRijw/rO3DEcrpl5X8HDQAroW5QpYKE/5sZnw+h2bk+ADrmp0iPIwIkbnlPExpcA0Ccqf+qeX0/XuLrQyOYOMtdEm7WFaMxCIlO5ZauyzbDssXAxxepJEWipfCtnPqVZwkQ23yHb232Y68vqnJgRp2RDDst8b+cxCb3Cosx3n/X8+aBD9yx3RS2tovcE/3XrgGaDQ7mZAbDjfJbGGgL8Z1E3ZIGu4o+nYYfNOUao0cGT88051RzSYIroqKukigq2GzQOOs9IgphIvxigStffenag+vHXzo9z6ESZSI0llMb1/vt5PUU4RG3OGDFFCetIgbJCMQl/rcK1S7Y/TEKbPkQYaw4I7BmsEnrvUOy+d2tcCZfH3lFa0nNzEy8Qch7qOp7svtu6m1A+TKG3K93xCLppc5RrGOXI40z+3aqe6ZW2aYYocOFuQuUS3ot1cu0GgxOo+Xxkun2MAAxGtzvS0f6UsUByeVh9ryxONI4XZC1KbeqoffgQSlT2svmDpSbc+PyB8o7Wo661M8y+dSUwssNDm/aOoOIvhOVsnLzdxTzSlcRslI9DyCiUmpDwWaVnWMZVnNx3HBPvyq5dKFKBh5CIqvW8D1AxJPlg2QQ+CkslhmGJ37th/k8gyJlV3iTCSuldiqhSL3U4OT0AVOgN
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(14060799003)(82310400026)(35042699022)(1800799024)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oWaexPmX9Pv7Oty/dxqq9Z7Ee9uPWYAG2uEXq/KKEM/0zJbyAxzpH3nGpQEPxIerzMbu07cR2MbJdbYhE4iFUDbdPYlXiVswFFYSEIMZt4dxSzznWQYH++GV/IDWp0NbN5UchvxscFok6jcb51SUyVcU43Cr9lKgPjjQV1J3kdTigKFvr1bJQAzwwipAH4qj0nLXAilfmW0D/33owWmLWwE+wiGhzB8m8HbA8i/9dI3xtfH5JHC5tjOmyoO+sa48JpYeUIJ7UCAELWJgUzjazOIULjd45tjgRJbkYE2NSoWrIfpmw0NNUZ1/HozbqQDCoJX9LUWfN80LEeG3unhIwwPSfJBFxovKSydhLboY99WOWHb5Y7mVXzYxZyGiwL1sumFJTAXnh3mBl4I27+KA/LjgCnvF23SUXSk8lJDvRv7Gsdh3VkkQRxUNNgl/6omq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 14:12:06.8833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c88052-f90e-4237-6d09-08de8a787f51
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6024
X-Rspamd-Server: rspam12
X-Stat-Signature: 6x77etd6pmugw4rd9z1sc885f73zr4is
X-Rspamd-Queue-Id: 64EA040023
X-Rspam-User: 
X-HE-Tag: 1774447934-926179
X-HE-Meta: U2FsdGVkX1+Bwh2Ds6sBOID8Hcyq7qI3ofchRBA8sNgS/78BixxIFHdCdAmNDnphvoGsUITUgUA1FfY6Pu7E1z/zyj5aXuFMvpCzbS/Mim9eeqEXMPI680Exc9r67tdFhC/MTvxEJBbSy25TXdKkQ9g6aDOyRDaHA8YfbPI7VaJiCHRauiEgm08YOzUeM6i6vLDtK9nSrDKdCqR9xzpo9L1+UwC2Iid6l3huRT5XnhIQMr/ROxIgtCDfbuB9ksk+cKPpGxEE/mAPEnzluEpyt4eLtBn/KE1y/z/af5omhfpafKIIJZZs10o537nOYP04T3z31yuIC+r0Awfzl9VGieMijjFLE1ezzmy/N1quGtze0oH0bodU1dbHXZwu2/E79hdzm+qWjo6nJ9pouSnes7hOMRHdt3RKt8RkL3SVCAYlHqTFNP7fD04ITW4Q/MIwJ6hnHjRv6DViLv6e/yjJyYU4t8/v4uGqt5fNPwQvXzMvXufklxKqm8auWCWZNQe3MnWkov2EP0h68PT8V8IjVfbcaK/w+X+MoYsVKtk1XzUHtaknKabDl0flCTeTkGetPZ1dlTnC1AFMPkyCAVKnCQf9azmHCCjbkr7y4R7RpMTExvqtbfCHjxEEcnrC3/Zvq3XfgUwl6BeRezuH7Ugd/nDNU5iv1O0S2BhEp+xbAtbIah2hjhO0eIq4TrqPlhq5nNwWcfu86k3c0r6YQQJiqoISzD5BDdXxB8sOY2UCmkDtEltHOUwd2Ht4ZjAeJA9gHI3N8xz0aBFSaqgfvB5QmWUzwsaTzifKT+exCcYXLBGvY9+UkrmS6DfKNoQM9XJgccZgvvKyixBCXwOPEuFThjjqLHQ1T22y3pATB+g+1V2r7I2RyUQCSKWRvvNI4mi+5oMk+W/yRHSZk230Kv9o3IYWpfmndR5fvglsLVwTK8vbi9idsSd2y+qNLywa6NYWxfdNAYLP/AGRTdzBhve
 Cvr5Iy0m
 sK2yjV0db7e5RTDvK3fsqGI6UyMR5t3YPPOqu7aUvFEFii1DdIKyw+vslwsiHpd71MUxUWaiD5GQ+0uFjSWwEPG/7sLKBYjQBg2zvyF62KgFUCH9JUEBWNqMv21oajw/I4wzf69hXjJV852SRbVVApij0Orh7zXiR4oe2fUSUCNeeuGkAH1nYTMPZCVAbxOLy48GO3oCL6g3+RkmNcuO05xAk3vyNiAKhsj9uzcSdraKdiaFafqGCzQumr016XrQb5f/ZvsiTDmcyh/h4VopJWZNLcRSMXrhScKByxeVdGLqKWFkwoim+F7y+T7E9xc3lDUL2rps0aMrZe8MMDz/+xws7k914zovKS0VWeqcMfQx0WKO8LMwcHGIfZNdjk5sJaTw/m3cSAmKs7LwY0ACv6ZGswFAw1QkoRQlvQ4I6KQqv78UxH47bMI3iskJiVcRJklro36Z2CVJ+qyuVY8EIAphAC7qbN9895+KtAW0TSm6W+52xzzOcs6+Ixcq5ar843nxrZKOAdbmdCXvuT9G15EO5zJttPZpzpmg7v7SoNMUbDPfcCFd2zPsrKVVipG0Seb4aq6LUKnjTMN3Ve9k0XSGGFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/2026 8:56 pm, David Hildenbrand (Arm) wrote:
> 
>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +	struct page *start = NULL;
>> +	unsigned long start_sec;
>> +	unsigned long i;
>> +	bool can_free;
>> +
>> +	/*
>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>> +	 * free_pages_prepare() fails we consider the page to have been freed;
>> +	 * deliberately leak it.
>> +	 *
>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>> +	 * vice versa. Break batches at section boundaries since pages from
>> +	 * different sections must not be coalesced into a single high-order
>> +	 * block.
> 
> The comment is not completely accurate: section boundary only applies to
> some kernel configs.
> 
> Maybe rewrite the whole paragraph into
> 
> "Contiguous PFNs might not have a contiguous "struct pages" in some
> kernel config. Therefore, check memdesc_section(), and stop batching
> once it changes, see num_pages_contiguous()."
Agreed, I'll update.

> 
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		can_free = put_page_testzero(page);
>> +		if (can_free && !free_pages_prepare(page, 0))
>> +			can_free = false;
>> +
>> +		if (can_free && start &&
>> +		    memdesc_section(page->flags) != start_sec) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		} else if (!can_free && start) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = NULL;
>> +		} else if (can_free && !start) {
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		}
>> +	}
> 
> Simplification a proposed by Zi make sense to me!
I've added it.

Thanks,
Usama



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AC0C5DF89
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 04:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF506B008C; Thu, 20 Aug 2026 00:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8397C6B0092; Thu, 20 Aug 2026 00:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAE36B0095; Thu, 20 Aug 2026 00:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4110B6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:15:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A63DF80201
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:15:38 +0000 (UTC)
X-FDA: 85120333956.28.1BFB3C8
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012002.outbound.protection.outlook.com [52.101.66.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5395140004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:15:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mJQgg37O;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mJQgg37O;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.2 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787199335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMfnL6RVmBcoUy4FBDpqZ4SkwUbKP7oNJfhx00mB77k=;
	b=sZnbj+76PFhGXGnEDg2bMud4ACCf6CumuZbXYUI4DrBT2fPHFwxiUA/ec7IRLnly/tpwRL
	H60tMN7RGGikUtzyLV+eX7shScQ24R1jR3OisLZACoIBX3iDYwPQdLAnBhbLwW6WMPLRzA
	hzzfAfiaFX3VfA6Ds73dZBH4QVLqv2g=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mJQgg37O;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mJQgg37O;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.2 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787199335;
	b=Oe7E/7GB1zaYsyeXdhwHnu5DapCQV94EHBhC1IN6I9OSteGAGqFBR57VQ6+agzIhS303Wt
	N0RXDt5IaTSR70hiDZviWtw7SknKW4HRupaOt8YpOo43VTtibgE9vaODvLAO4rdRBKvOfd
	dKsJT2sQ2Xaoyix+7fpcFfJkvputdFA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oIgtB+vnswzOsVt8i28grKkeIz2EK835trI8P4A9y+LNRfDuRkg8MAdHD17gPUlVfbsiK6Ff3kPObXPFeAkKLITROMB8JZTzHkxSymyfu8NQgrqmnKCb97b8mV7v3wbb0m7fIyvr7vN0zELyogOCJ+tIz1EbqQqjXqZgHpQM2zBw7kKe5KtA7khpXZw/V9u7P+m9l8MCkuZu6xLn9TVSzLwO0pLIq1S+EkGUp6vU6YFVRwCmfr1/BCzb15DBik1RoWY58nqmpK+HvZzzTJuNsjvsUV9rn1LT/ELKVnz72bg8de5drISZt13sPkDIb3ZdVPvOXZEdUbMSfphf4bBlDw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMfnL6RVmBcoUy4FBDpqZ4SkwUbKP7oNJfhx00mB77k=;
 b=PZpdyluZqol09KDwMPcq4mRJGdFVwQqs8rfmigH/EF9x/eu6NMTl2aGRCJjcRLmDkOkKoInjkjJtK6Vjlh41unoy73pbUxN5JVqP0uB0oOtcjxtjv4IxGt5pFCs13b4z9qQJggFtvn2ZCZoZ2GZwNNTcLYdT8Kzf8c8pZd7fPYpWvZqFP1nmT95WS/F8BPJLMjfGVeH7i4TV8AiNM7eQh/0mGg+EgN2u+EBITcgEVzdOASxketKraLBVFF8CVlHSVBQ/cwMcXymvpQc9Q6nlYc6NxgKhcO4W2sJimC8UW8HOBUY863kf7LCFkSmNmdGbZfb0sgK9y+Ktalph6ULyuQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMfnL6RVmBcoUy4FBDpqZ4SkwUbKP7oNJfhx00mB77k=;
 b=mJQgg37O947FvY2pBUnziCXFZENTtCVnH+wPy3THe0XLpDWwdl/SOJrjnYdSFHltrygO5MMwvwKNR04day55LjIJi1srnjxl2QoASVlIS0WibZVrX4eAj4vfa/EPh7YW3nLFr4bs2rU7t9vTyUCQbphvka46KGQNEFMtFKZex+A=
Received: from DB8P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::34)
 by PA4PR08MB6254.eurprd08.prod.outlook.com (2603:10a6:102:f3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 04:15:28 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::60) by DB8P191CA0024.outlook.office365.com
 (2603:10a6:10:130::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Thu, 20
 Aug 2026 04:15:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Thu, 20 Aug 2026 04:15:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rn0r+QiYCngBAqib+rfV9kRcoaQkUL9vS8lLpto3hT1vOtEqdfoWjtZzVfr1ylgG8gInFMwkOApLRI13dHtkjEhIa2BsPJqpZs/7BXairyHX9iDfuGfhQCyl2ez8GRACA2BdMi1jrm7fMJeMXRnTuiZ8cg9oIdbiXlNPpKrjNtYrJ6AJ+ZY3+gfYdSa++iagHnyKpObRKszZGkl+wCupgxc5EboNqWLwhk5/qqum61M4tC1qkABDB50SQyCX7yo1QptEu194m1N7tkSs4AnLjzB4IesTQzqsrqIJiWbIKBt3jT6G6xQlVhOBTU2BXsSzE32/Xg7sLqBMhHWPtSIlng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMfnL6RVmBcoUy4FBDpqZ4SkwUbKP7oNJfhx00mB77k=;
 b=bqFHTH+njSjJ4bUfo1pz/g7HxKaQyUOzSU+vF6sR1bTkKYksFo+7oanZV2WLlNIKOwH0W/r6xkhwLr+Ixs6TEi+Zx96XsXy3oAvdTDbQ80bYf+pEEuhMh2tQSJJ2QQWrPeV6SDJhpqYl+1VOE8rSAfKiDVU/dNgngKsP7jxfYx31UBb6Loqsm9/Ta9npsWOq/LOifn9fTk2LR+oOedD85DX3YbFzuaezk6gQGRTpt4mjSw8WdJ50Hbe/vS/AaRJ97urKKib8b7Qmw75Wka07dZgDJTPNwdvkm/5HjNsZHTALAH/JyGv/WP40X6Z9Z/ubXCt4sQKLQgID7WcT652PyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMfnL6RVmBcoUy4FBDpqZ4SkwUbKP7oNJfhx00mB77k=;
 b=mJQgg37O947FvY2pBUnziCXFZENTtCVnH+wPy3THe0XLpDWwdl/SOJrjnYdSFHltrygO5MMwvwKNR04day55LjIJi1srnjxl2QoASVlIS0WibZVrX4eAj4vfa/EPh7YW3nLFr4bs2rU7t9vTyUCQbphvka46KGQNEFMtFKZex+A=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS1PR08MB7513.eurprd08.prod.outlook.com (2603:10a6:20b:480::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 04:14:55 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 04:14:55 +0000
Message-ID: <8fdf8108-9ee2-4b30-9036-ad6066f3db5f@arm.com>
Date: Thu, 20 Aug 2026 09:44:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check stat() return value in khugepaged
 get_finfo()
To: Anshuman <anshumantewari123@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260819121426.49500-1-anshumantewari123@gmail.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260819121426.49500-1-anshumantewari123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0114.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a7::17) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS1PR08MB7513:EE_|DB1PEPF000509FE:EE_|PA4PR08MB6254:EE_
X-MS-Office365-Filtering-Correlation-Id: ed3631a0-258e-4f32-2cd9-08defe71aac1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10067099003|56012099006|6133799003|22082099003|17002099007|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 OKYOAJKarE8gJW1Or418p7QTCPvSXA/0Jwiy1NybfCH2DFB6X2Yf+2b1StSOmVvFp7ixrHY5oabbI9iap2QKDo3dy0+cIvHQWy7V/WH9b1GPjOOcpcZTWVUVv/b+EmMhn3veloNwPJqruBb5RpAPTwbeTOAyz2lcpxwXn/fS4csw9AoM4lWDfNSpue3eRyOiYTg5qbOJZxRTpXj+sD6RdQKAgYpyHkVAdtyWgnZ42dBgORijh18siQsnF70Tr+DirEuV4fUTvbgAjlZ9s/Uy5B7fxTe/YLqlnSO8ZO5Yml5idGSf8vTT8D5h+27iBnianPgbo1phXQwg5IDtz1cPx/Ym7FXGlSMhI+xJKvzxNMtJUXzRXoQjz1XWPP3J7wD1wrhPW5BviLjPMFHj9EbUydh4EG0RzSoDcps+5MglfzdGWWLmiigEgvPlmERD7QbKN0Wxpqd7Iw3uFiKuwxMpI2MWIuHPK74KiBmRpL15Pc/rTyDaaUKJ9gzoBLqym1wYzS48NAf9LpUhKoMC40Dcj1KePAVHhlUe6+PQdXMJySlpAk+3tiHdeDZx0hQKgxWeqDla0bgiZ8gye7h4c6WrxPnbI4QALaeDPHSCpdoQR6PXEMPOd1IO61Eu9ROGMYaXcKhplw6ZAtfC77S+72gIJHnC8Zcm834fxOXzuwR6L6g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10067099003)(56012099006)(6133799003)(22082099003)(17002099007)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 bq/UYyeJl+pLBFHxaLA/Ti0kfqaOjtw8TH7gUZdW/cl4KdWKuSHhegLz0uMGdgmAj6OmkbAvR1fET4OGfKj9OnrUG/XgIK7v55Mp1vr4WuX/1KWdnaAxqzRLVL0+L4qGlw7LRoa4JgU++fAOisx5C+OadpjddE5cPTNOBAYooscMLUOosZMzMpubTwWLKMM1j5HVcK/VfWpdrtTG/ymz95HaMAL4SRvUDtEdmDYf2OiK1hFtjdbi/+2IxSMorG7Dht3VU/6OAvSli2S4XT0KdMrnG1unU0pycNhmWr+Lgw5H4+GCK7z0TX01MRGSWlsZhsQYQBuZIOxYR/x52x8qTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7513
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	43f8da14-5e36-478d-497f-08defe719708
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|376014|1800799024|35042699022|82310400026|30052699003|23010399003|6133799003|10067099003|11063799006|56012099006|22082099003|17002099007|18002099003;
X-Microsoft-Antispam-Message-Info:
	E3eHA+8/pWgn04vLL4TG4INrmOWnnQU4txTzmRp0mhaiuniuiHmKGl1Dt+mdjzpPAoKOHt2+jrIWUnIHeO079QCsYUykc17FfQ2h0hVsM1r7XYWwFPzltgGyoTzLupdLgwlS/bZghEiw0cGo1oWvW0czzV3IDuZT4juF6zB2QtMO8PAvRDfzFoa87MM9EbN8SHhoXwWiNtaVsMGqhj9dDGayFPuewwqRxr2GOtnbMAvxshK2BCN6U9o0yxzyjXpI//uUAVGmuZbvvyM8X6RsoUXYLxLT44lvrxNfd5ir9/VmDSaYnc2htPYtNQtUCZgZGiQCqeLqRQnPg97dFSSMpVxXKFbagcFPJEjzpvixyQfUUarwsNrpUF5Vn2vAx5e1BFwe+xAd4US44N4H5Hncr2J1D2SbIKegOTzw7wv/qPjWRWQ9Ifv8ynYzkk14opmpFWRDPEkOE2krZRrDPhK5mjO/sVBagwC0LMOXXfZpYsL6KsOqzwvCw6P5Pr/PNemq251VyMDhrrXNrCnA1RF2XZQRcaPYmcSvdZFa747EAEjg6biREU911Ma1n08hEATlamygGmBFJ/bZIFzFoJ3njuEINOm9OI9sR9HHVla9rps4pXifFGYfOZGsAg87dQgpYNp2Gh4cjXh/AAbgq3IepgTzQ6DcRp6Ue0ZXua0ofLLPubKOV6jXFd64KaHQqCNAVpButA5OUX35BcItpASXbw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(376014)(1800799024)(35042699022)(82310400026)(30052699003)(23010399003)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(17002099007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UHuUkeaJWB06WWfFuRYbOrrKlNeFNlAxagm1znWr9AXDkK6P6v/BORUd9eDAh2gv9ymOHb39csDoWEMjgGlQUDOa3n1qio0tdMujdseTfS688HzDUsvvtVX73ZWVglbrAUK9ag5SuQVnRdF3IKl+P62gTIa0Fk0YsVi9FfOhcNvUdHWuCN4nFei5TSulj94o1XrinAw+wTVusDBQ+OH0v9MswaWWKghrIRbD9ArQtH1LIeno0j6I+3erVFRuHfTAkpcAusatLUfNt6lNPiFYe2zNDEy/tcadOfRldwDNtbvHY3zaY4s9wCOPfDFo08S0R9rES8R6/uv+vqSb3j18o5qX2jrib/EktMmf5+rxpWavrPUayNVXtNZAo1MQuSEtBbDyqWz8EAwtvSmbAqiH2t/bLJZRSmBVFrhPP/WGZeMFAnwUTe2AhKxy1zwiQtyd
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 04:15:28.1713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3631a0-258e-4f32-2cd9-08defe71aac1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6254
X-Stat-Signature: kxnut5d1sqygqpfiayidbj586um5u8yu
X-Rspamd-Queue-Id: A5395140004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787199334-567300
X-HE-Meta: U2FsdGVkX1/tDCtGSay8uAH7aW1ZgdxPRyLWiCJU0zZaiGkh/0ONM/MZsm9/4Bmer4ZndUJeXUtI0DwqxWTUI9alQnICF28pTH89wraKk6ommHYWg/nQvAZcnG6R845MvcdO1ykNNj99SYocHjW7ulyNBGyDcF/xzjHxXUfxzaD25M4Ht6n18mUmJHfHjTdHjrAmN4+wT/8giHxZXiMLzLmTRoB9Heo5IWNR9XyiSQ99SLHUW4JdtFb+klAPAepV4OVeItKj2wmAwRLSR0tJKBV9hKE2DRetNhf7l0/+R+SX0ev9Ywt02VqXprRnQvcPp3TIYCQpuIjf+ViY6yL9LwqymqIlXReJ1sKfUnAU3E9ioQFsJ6olsWEwsC/ajIk9k973mxxlGkEeAJ23YJZJ7jOSivoTvB7g50iySGbFKel3uVUCtNlz7uRd/cZ1Ja+qmITa78lDiJ1fkzse9ubPSuC8pgklkuzzDeKh7WMxYPgCLh/2qohjt5986l68rzErJmLOE6scTtR4id7EB9LVK/n2snESq9+9Jrtl+PKl4cOfH8N9GYIZKG/PO26OmEFud9nu+zuMwgCtrJy8f3z/JhWXEHaaIax1f+uhW27eg9Y3zjHOW9RygCfUf8ucTk0nCNLAASzlPDFGVFD1f1UjHeRHU9iw8sNuqA/tyM/hySc/t2jssdqtOwfw8spUiEtde6LuAEj3U+kj3Ncy3ZdUIpLGf4uDmPn76Kuqj0bN5TuPrgqCDKmqDOuBI4d2adgpv85Hbbfr4LlWAyLO/RHq/0GDCwH2dXwtAEllYXUY1o3yFIzi19+TjAXoOA299ViGs3moW2hkIfsAju5po8WG1NB6QTGnoGA1KPY+ArUsyRY1YGip7+K1jCj4jjGUuqdRCJYWKesSyYk6RPQZb5+whWCO5JTxiz+co+WpyDZqMP2voFgyIOWtUZEcnGt//5LfLzyXPdrVubop/qj+YDA
 gML6fzBH
 YBRlwReRZ4QnmzuYaUULUNPQ2qIWoK8EljxDKO6NjnfyIMnL6uKxYkDuM4gnka4Wwrk8kTLW1RtzQU+f2ge61a0uxdhfsm8rN7bsULuff+9tPV2aZbdIyAFLLVbRXsXs64QhnryoUX+J7Yp1PmHmfiM9cuN++Ae1o88hs/3x9iFRKUNa/RqbxK+MZdV9fyhMoGXX1pF5/hr6yCuw94P7vphqOI8qq6sUYfS+pY2ffnXIMGaZDYt58I5NgyzPZRwyUSLhVIVgVA+tkwYRH0j0h/dG6jhNCO1MWrEH44yVScQgosn97Ja8IOYIdMbsvP3i/pPI89f3iRbr3ZyVIiI1tqBkLGtxMY3ftmS0lbC/54fh3r3OvvQ0vggpW94I2V7riQGKS0I3bdH+IGl7zYVOnQEciMDh+OiaiDu7IfyuWy0AUdUseRBEddByc8U8puLUpPd75PqFwo+89XqyC+PjHBwEmhU0txerPDiIcnB1kv2qXgNFFQFxRol+2WWK5VzEgEofXNRMsJ8aHegaaiD/Klm6ytwIEcyjKsJdClkoUpO7/qxLbX7P6LBAeehIngPmITRq77WQeOiQdddvRXEQe1dA+nhBlmwaD54HCU3K8/Y0Cn86My5iVYEpp2lq0mnd/GGwYVI/RTIyzyQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/19/26 5:44 PM, Anshuman wrote:
> get_finfo() calls stat() to get metadata about the target directory,
> but never checks the return value. On failure, stat() returns -1 and
> leaves path_stat unmodified, so path_stat.st_mode may contain
> uninitialized stack data.
> 
> The code then checks S_ISDIR(path_stat.st_mode) against this
> potentially garbage value. This can produce a misleading "Not a
> directory" error when the real problem is a nonexistent or
> inaccessible path, or, in the worst case, the check could pass by
> chance on garbage data and let the function continue using an
> invalid path_stat for the rest of its logic.
> 
> Check the return value and fail with a clear error message if
> stat() fails, matching the error-handling style already used for
> statfs() and read_file() later in the same function.
> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>

LGTM, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb..2240a9b4f 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -121,7 +121,8 @@ static void get_finfo(const char *dir)
>  	char *str, *end;
>  
>  	finfo.dir = dir;
> -	stat(finfo.dir, &path_stat);
> +	if (stat(finfo.dir, &path_stat))
> +		ksft_exit_fail_perror("stat()");
>  	if (!S_ISDIR(path_stat.st_mode))
>  		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
>  	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,



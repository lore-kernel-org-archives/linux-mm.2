Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C5AC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1E16B009F; Mon, 20 Jul 2026 08:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B86B00A0; Mon, 20 Jul 2026 08:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF35F6B00A1; Mon, 20 Jul 2026 08:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A02AE6B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:03:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B7BB1C0063
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:03:16 +0000 (UTC)
X-FDA: 85009019592.05.2C293C6
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013045.outbound.protection.outlook.com [40.107.159.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 282FB80002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:03:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="mqKW/tSu";
	dkim=pass header.d=arm.com header.s=selector1 header.b="mqKW/tSu";
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.45 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9ybt+IYkNSY2waLSeelMX9wJnsSO2xsDvMsvAlRVAo=;
	b=shcxU/7y319Tl1bJ52yFxDtv/4o1VegNbJ8jgtuHQKD/zajdSr0lZxfmTqZmKL8mqwfFDS
	eFODh6szeMa4PRpRGsQRAdANE6qebBv6uSTeN6U83+z670QXthiy5MnjHNFE4NndZcOv2g
	wtc7MKaJSRp1OVCMwGGTfkWqWKACGrQ=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784548992;
	b=Nx+6iRYH/KAyrNSFJhjLfY+N4uR4AoBwuo+WJDarsdOj76xweNc4gkNYqc5M89SQeETN1N
	91YO7VEry2u/29/31710/U+Vlg1rAuizRK/eroAODsnGwmVjR1G6YNg9th16rgrqE8Z0jy
	jgdO3hwha5JM6+NfSxdPP0dMlCv/8nw=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="mqKW/tSu";
	dkim=pass header.d=arm.com header.s=selector1 header.b="mqKW/tSu";
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.45 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VWHZ/ZqNI89CRr+87xroCEftGfjPU3dWqJSmBuGK20gbP1oQzAS2f7PcKxNsIH4RHjDSKyhPB69L72elbMwqgJp95IvgTXBQ6P1s6eOgLc4PsDqDXxy9nHHK2+qQoavUK/acS+yzklkpzPE62FXsU4TotfgES2Tm4vvSGX/Hajb/nZNgfkSi71wBDpEZ9tUcSuOBiR8dFpzf5JzrEWz6bxt30oUewMpAXcqlPleAKNkeel5Aj5mMnaCc9Z2PnfReVIUDeh8tg7kAke+eeZ+Yfow/0J7xupX4/n8kaFHlX4QrpvQxW2C/pUQyO2xt1IeYiMGSGfvyiEDaesYT4mwX7w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9ybt+IYkNSY2waLSeelMX9wJnsSO2xsDvMsvAlRVAo=;
 b=dPyt0SciiXpnTnEKM/54AxmxStwH94/7Ui4qSt6Buewg2+0faGWEU9YPHWe8z/ClQvcybE1a/USxLV8ubx4FSfwt1eTpS0XSElXsqBAATdC6+pzFVwyN/yhSMhMsr2D+mfOVXCVYRVh1UZqmI5ufDxw3aXzQfBWcmiJMjotZD6IblQHQoh3GCSMHBLLkPlMa8FNie4EES6ZhSaQ11c1/8LaH/tnzSweDYkcYcN6E6n73lcLaCjOt4sDt/OolIQPG4cQlvYJjcbXWFDrZT+HmT4Qg7Z7Kso366Ps96SDsqSHrOWsgjiIRJ6mA5xUEAw47a3MmoHmJaT5SHUtqp9fBpA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9ybt+IYkNSY2waLSeelMX9wJnsSO2xsDvMsvAlRVAo=;
 b=mqKW/tSuKrJ9tD23V2GjmILpzR0wX3oNb3FYy2lvnPVMRVMkFoPRxXY9KkfumPKHqD7c1UDbokhIDjdh0rZh0eBLePSxyYt5hNTw69zrvVBTxr+tQITq03yZLX1T098Gb47cPHTrJdY7P2R8Tlv2JYI7XLcyL+L/OTg8JB/DVNo=
Received: from DUZPR01CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::20) by GVXPR08MB10543.eurprd08.prod.outlook.com
 (2603:10a6:150:15b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Mon, 20 Jul
 2026 12:03:02 +0000
Received: from DB1PEPF000509E7.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::53) by DUZPR01CA0004.outlook.office365.com
 (2603:10a6:10:3c3::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.16 via Frontend Transport; Mon,
 20 Jul 2026 12:03:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E7.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Mon, 20 Jul 2026 12:03:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVElLTETcMl0nFS57lBc5IGxDJHyfHEpWEcCi558L3Ul+NeOXr9B7dzHGxIbXu9G1umr8sM7uxPyke3i4+aSX4uehegNuob7Foqdys43QckKCMIxdfaOAoJJkAIK0k5wkvFDPPHO5qM0E3+nNO11SCM12Q8juHs45wZbnnRjHhfsA4pPQJHJenbQMyIGH/0W0leBgK4fqfm+O8Ao+QyUN3MkZ+pglKyRZw/vEkBSZISaQxMB/EFc6MRZhsKUFyFgNsXp3F1mFBHsclZnMDyNUJKsyrFMeSAvU/+yZDrWP4/+j0uhF31gZvKb8eAwU4O13e/8wLBMRDr1L7ghbMmF1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9ybt+IYkNSY2waLSeelMX9wJnsSO2xsDvMsvAlRVAo=;
 b=tQeNIpXODJ52dBbZRZZ03LHD+m+ZuSHh1avPOWjsoBLTCqNQ6cvx9jkvSCuHAk+QcLpzojs6GXka1F4Fci+cFFTncflp5y+D+s3otuFxcKLfvhavKxpps+49EkqptL0wovwtC7sYJmOKDItYf93ywv7Cg6Mx8bif+qGhQZBHWNU7pBY++6TBb1qTJS67F86R72gjJxlJQdihEafAwY56uCTWfh5Zilz7xJsgvbOQbS0ivXBKEDFpztNtCxBO69EwPEXGbF8QZ0s6Mx4FdSUwR66B6RVT1R2mdgr350bXi1+oEBSf/T7dbubarqO9PxzmkKYMfPudb4N0DC9gtouDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9ybt+IYkNSY2waLSeelMX9wJnsSO2xsDvMsvAlRVAo=;
 b=mqKW/tSuKrJ9tD23V2GjmILpzR0wX3oNb3FYy2lvnPVMRVMkFoPRxXY9KkfumPKHqD7c1UDbokhIDjdh0rZh0eBLePSxyYt5hNTw69zrvVBTxr+tQITq03yZLX1T098Gb47cPHTrJdY7P2R8Tlv2JYI7XLcyL+L/OTg8JB/DVNo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GV1PR08MB10806.eurprd08.prod.outlook.com (2603:10a6:150:162::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 12:01:56 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 12:01:56 +0000
Message-ID: <338f3237-917a-44b1-8ec9-798869566234@arm.com>
Date: Mon, 20 Jul 2026 17:31:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260716123226.197736-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0206.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b0::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GV1PR08MB10806:EE_|DB1PEPF000509E7:EE_|GVXPR08MB10543:EE_
X-MS-Office365-Filtering-Correlation-Id: cabebfd3-6b17-4e18-46e8-08dee656d88a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|18002099003|22082099003|56012099006|11063799006|5023799004|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 CfLgm1X+Tw6DtAodThyOZ+A1+G6LooKcFjYui2Jo5yRMlRnQERSt80vLA0Tsnm3OLvyYzZtZb0Hgq2nSHiQHVDRpVaz5cvSwPabGcfFBFdy4oaGGFYmqBJ3WIlnSHDe4KHdKdKLsSJCoO/Elaggi663wul+Sirjrvmf2TwgBBzbkDeH+wBOhkPe28RvKR/Gr6M3JCxNkuOmWbLd9lbMhPe+8xc5NckWFhoIe5ZHKoybH8QYvWdTDFPgre4a7MXGNpUqxPoqnRTj5cyfiDsqCH6o1PYdZIoNHIoS18QVQ4beMi/eFAKjVei2vtrQoJh9YahVQDStOUHc2UBm7cjvGOr3uTuzJNmGnw84ILvIuBJVrc4W7ZnFEJv81p7gnMXFKhHFuNpXWKHPoFH0apASMB/KQwlsGVmBKqPycieNRIzVH2US7JxF4hoMbTnz1pAOZasBqjYudtK5ICtG/oZlLlzqQ150eMtRcMAHbt8vrEdgwLoOREFeO117sQnUpIVesfFQVU/Sfb3QbU9/7DgeKDLfNql2pBAG1D+l5Kg3p3rvBBDCOYb5++6rVjxMfBF6zYHaJCO8MWnMZbflqj3iUIxD9x0w3K3q1JsNJY4BZJak=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 F9kXjaG9jd/PMaCZHLqQn6qS4hjwLerBJ7WWTcKZkjc4iKbBztNarIU2h68YwZ5S0tTarAxeN7j5CaZe31ev8Hepki5Du2ut0xkb0YiwRn7BmBtLpna8kBNentPyXe/6JEGc7ZtkVPn2xz86Ifgg+XjdtdU88r0QOjQSoDWUoCCZmHiol+/h0O0CFBo95PshDC3hZ3Bey/eeWq1BlxNdE94gk3B9mWgji3kr47SbGH7lhLv087CRmrQgOkfaiYaNZLEwBXUAD7OKeMbqSUQJdrFXHpf6YSvcs3Xpc62yRF7/Mlr4v1VzfPS2AKR21tKY6cCs0oqeLSK0GBAku6c5RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10806
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	000635f4-d7d0-4965-1ab5-08dee656b1cc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|35042699022|376014|7416014|14060799003|23010399003|22082099003|18002099003|11063799006|5023799004|56012099006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	JlP65FQ24G3fI9DO1yG7Rt0t18ivUG2UxRRGWJWJjFLAFkQ4qUeTX4BKhgIfQRwiP4QXLtulF2sjeieZr6qVL0196HPmig3egrHhRjLFN/3XfOR7LNB/K1pQi3jJ9D1KMU2NDdQddai8KK/FDnAeuXPfdZeVPZYcLh1nm4bYYwKXetrKx+zQ9/vAnEvI8YNiHEKqSZgX3R40qI9CM8a0K/pCjkAN/nZosgtnx2Djxe1vFX3HIUmwCeOwlIl3cEbxsiKRPFJiIaLTZhz3KAKCratHztXhKplbMwgqMQcgHz5iNGj+SK6Crz76qssRwlaez3RWss5sj3kqewOyD+x1hHjgs8a14+GrrnnN2o3O6WrYEnxpOe/+TO2BQhLh0VW9sYtZDuhkDIJTxiO/Pny29d5kqc2qEpGPRuDB6ub34DykJysJ/0c/Ug9ctqoawHeGjC/14c/Hj10PtAUd+V2ShW3RZK2R3s/H0QPpL33uwliFqUejocxDTbabaQFAnPlx4lNJrE6tCoGYGk9Zcg/LVd/E2FTozpesPjh7iW+gulfh/71Rb9npfhVrLuJwAmeAtnySBNg8858DqvTJ3RS/xogjQJ/uRrNpa7ot+Sw1FPFAdS5VhTrTj5D0dQEHBU5glWf5oQhWV11U/TAXfAQyiw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(35042699022)(376014)(7416014)(14060799003)(23010399003)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Rza4cqKVTXiX7uur6cIG8qpBDGaCVfsgkXOY12RypR71tVuMJH85dcFO3UHH3L5o2fqxqUulUBxx8sXKO2U5hzZ9jiVZzSFaEnsw3BOBAGqpu4waHoLRuwYwBVZwoAVz1ajM8k+h7D9GUHQ6EaW9Xy6P23MTrevFvJPbjA4+kWqzSS6J0RII+sdNJLJK2H4AfsPu//V6voRKa8p8M+ZaFX3agdlVmbPHe8Hp9hME0s3k3BYq5zBsSBhEy/IsZ2l5pNYICNIM5n3MzAHAfvE/jhDS+XpSmJdh7X2NMUa0y5/CEaH8pIrAb7Bbmb4LzHMUTTvl58Xkoja6kfwOxV+ygZ9GZBy6ZAV7HD+sLY61RDlH8W+b/nFQfCQ0zOEPI1ji5+YCfRlTZhV+V7Z60eWGTBKUKVN1KP+Zd8c/ZjhlsqQpSQ8yILoGYpwzovyNNQj+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 12:03:00.6713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cabebfd3-6b17-4e18-46e8-08dee656d88a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E7.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10543
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 282FB80002
X-Stat-Signature: mgtniq7w7niw97mzc33ygwbkpw8c4pqo
X-Rspam-User: 
X-HE-Tag: 1784548991-157057
X-HE-Meta: U2FsdGVkX1/Qh+ub5y5u8g678kUsz23yEujLy2U56QWgase/4fh0Tc8KCD8XbAISv46CmMDnwEznFqX0euTnJifpEvGN9xCNYYHnQr+Kwyu0UySfOU41gCNpd4pl/Vc8jMtnErzGE3v81jTXbWy2eTxqVo22MmyIaP2vMMBaKunfriYeWTEBUIsfJDvnATZnjHTq0cHVQfmdMLb/UD3FxtEBlUbFrVZpqPQl0s4f9B4QPO1aGj/zbN9Ib3UOfUWB1KwhsnHmEHoM07mxIWhC+50zmrlZ4kF9gNH1kREDsMm09B7g8s1eKHEplhZkhEDUKhkVasBFbb+cMF1cwukcNo8Yg8kDFk7fDB5sd0dEGnHvCT/4QS8wva2pOK46FWZI7UbfTGlNF1++w4BfRcyjD5A7aoY89LF4smHf/oWNia6XvuzLNPiT26Yenp+/B+tiXqp7Z8ksJjrKplod6lhixSAQn2emTrEpinn/3CtcyOf0zuMReqd37V4uDgOpLDfTYtQz4EJKLWQCRf9i4cj/+SFh3ryBgAb2ZqyAX0AI/WXxU48DoEJQIFUBbjYXMUhW99lD7RchIlvPGeUtDF9rkhhf6MLkJS5okP3KhNi3VGwbHCT++7Ds1q82OoR/Vi6mgcoMOzzxkwthwj//pUp28yhPTBp6tXlSI6N9W5mBzDNaqzY4C9/BDX/dKL5vLcfT1Wlp2eKVHSN9Z3658S0ozAjaRWAhwNonXYW+yqiIBMey46Nr+RstCwbyibAaTej21c7xG8iMBCHyqkzVCjRU2C8N1ruqwwDFYvpm5dEffvZDR65Npx/Htnauwndk53DYCZLsTT2rieMXd9dPdqxakLBiAA2VsHTUyi0k4A0VVw0q8L0Fw+LjHJZXq6gzgGSF/T6rLwEn56WiUHwh/gzYTdTZ2QerPK8agcAubPOeED/dqb7d9j/xTX9ybYnQYDynAhThXKpdA9uaMP1FLJQ
 5iENdNd5
 RybCPVLWXeKzU6hRDqfg0IdI6gY1fdg5LlnyqUmrPgy7hpPXdvt8+wzI3pGmxKxRt/EEmP6Q4xv9iMJHsQKiN+Ske4yoBdKUGWcix3/sE7KxEwm8JY2OZGfRIDH63CCBBYhvd7MOuhjry3q+2GEALMcMV3ac/agGOpTTGnE0WmdeHEcAraIWIkG3XFBkldkkfqvZtPC3fVTA9dlCIYUZ9Jy4kre1/zf45xMxC7YexrVQ2c01mrCg6LyirzRNnKy7LQ6XDKc6AERAENMcjhYlvUAjQhFKFoYVLeghOmfO5jJ7mvAo0K1KKWBjgJImCjEG2+5vANoxio7k+WVp+Kp821aePb7+5FiuLu209/82bNxtoJXQv/NP6lxyLNj/VEC1JYysl82RtjEPMYd1VPEXg+dtpLNhnTBiMbdA5aJYnO6URrIMB8+Uom/0eqANHnokLq7WW54/fu7Z99Zvv0yktdgnadzHTs3VjJGb+mQZ1IYWzivKT3LvPfbjrG2m7DDUGX8riJSEZHR0q4Y/C/QZ55eDvXz+qBDnkP7UwrFh4Ya4rY5tXgEJS5+KRjVD0ncvcNzBQG0sfE4bDDFHeo6URk0dmpxNICmrSCaLvDsx0ATd/DcKV8A14BLaRujMjXd+86tFd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew!

On 7/16/26 6:02 PM, Sarthak Sharma wrote:
> gup_test.c currently serves two distinct purposes: microbenchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
> DUMP_USER_PAGES_TEST). Mixing these in a single binary means that
> functional tests cannot be run or reported individually, and
> run_vmtests.sh must invoke the binary multiple times with different flag
> combinations to cover all configurations.
> 
> This series separates the two concerns: tools/mm/gup_bench handles
> benchmarking, while tools/testing/selftests/mm/gup_test handles functional
> testing. To avoid duplicating the HugeTLB and related file helpers, the
> series first prepares the existing helpers for sharing, then moves the
> common code to tools/lib/mm/ for use by both selftests and tools/mm.
> 

I went through Sashiko's review on this patchset [1]. There are two
concerns that it raises:

1. Patch 4: gup_thread() does not print an error when the ioctl() fails.
This is a valid point and it would be helpful to print it, but it is not
a functional bug.

2. Patch 5: This concern is a false positive. ksefltest_harness keeps
fixture teardown disabled while FIXTURE_SETUP() is running and enables
it only when setup succeeds. Therefore, FIXTURE_TEARDOWN() won't run if
setup fails.

I'll wait for people to review this patchset and if nothing else comes
up, I can send a fixup for the first concern. If there are other things
to address, I can include everything in a v6. Please let me know if you
require a different approach.

[1]
https://sashiko.dev/#/patchset/20260716123226.197736-1-sarthak.sharma%40arm.com




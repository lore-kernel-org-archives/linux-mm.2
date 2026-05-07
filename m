Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE8ECD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 10:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75D36B0088; Thu,  7 May 2026 06:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF916B008A; Thu,  7 May 2026 06:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78D66B008C; Thu,  7 May 2026 06:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A03A66B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:30:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49D0BC1C69
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:30:11 +0000 (UTC)
X-FDA: 84740253822.06.F1DDA96
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01CBA40010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:30:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=3")
ARC-Message-Signature: i=4; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778149807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
	b=y3nSV56H1q5a/pnZMo66xEyjRgEJ1CBte/OGK6W50oByCb+OnAtf5Fv05hne7KWOWY1tov
	3UlN21Q8phErzuLE1frxR3+AxIwLcIbiAbm7hCO6ooZkzMl2sJ3k22eeGsXB/M5qKD0WHN
	Hp7u5AnPW0DU6yy0WKBFpYbLQGY9h+g=
ARC-Authentication-Results: i=4;
	imf12.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=3")
ARC-Seal: i=4; s=arc-20220608; d=hostedemail.com; t=1778149807; a=rsa-sha256;
	cv=pass;
	b=oIh0LgClL9ALtcNpoZ+D1e8ia38Ix1/CaJft0wfOCwPofP1WJJwSYz2VJhvB8OFA0urmsh
	IY7Mrh14HYJ/w+08UnuJYJsqFIDsakvO5mvlBiOe6FzwK8vTlQwXuUKSu0hABnf1Frhv/q
	MiJhl2v2pKF7wkYCzLwdOq3jqIpEGKU=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 880B38C729
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:30:06 +0000 (UTC)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B58B1604C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:30:06 +0000 (UTC)
X-FDA: 84740253612.17.D70EB44
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012029.outbound.protection.outlook.com [52.101.66.29])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2CA761A0011
	for <linux-mm@kvack.org>; Thu,  7 May 2026 10:30:01 +0000 (UTC)
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778149802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
	b=B1wVoiomeodIcIS6ruk2vrtJcpnycquNakP1iC7Acx9FLw64PCVsEeVPo7cIYZ6GUR2boW
	Zre8Y6uRxsoyBoEIU+GeVdGsJ0qmimrVLyBo7lK1hVy/UBBeWzgJdSfObTdp+97WarkCkP
	AmwNY8It0eeq9mDdrUL3Rn2f6KnjtFk=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fwLno8yZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fwLno8yZ;
	spf=pass (imf19.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.29 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778149802; a=rsa-sha256;
	cv=pass;
	b=ECCEKT4QzFZO/s0+oy8Gg7IVkAUjVv2/Gp83Prehwz/DCSchATF8GsLEPO8CApvUNiz+XT
	3YjW0woqliRM9THv5qYL0YjH5s0dujmvmGfbIkHVX3GEGjLA53VsCXzcTJ6IAKBMm/HvZZ
	LOJbfaj7GpEjPriG7Ys17h76P2AFUOs=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hk0DS+vzxQPGi02p4VNIJdYpCbgCDPqL44qngJP2/yFBFJXNWAuwE6FaGmjtE32QuS+B8nxpBLlrNkS7izz8fYV2BD1S6gTu+GKJ+ZEtAqIP+26l205UttmlCq6zt40olBWAl0q3Qrw3VjBvvjyAX6m1PaDqOZVCkf8DvfK4dZqjR2NA1zF0rMMvP2EOZXdWbN1Fnok2GQBC/fVtJQt4KBcyYPuAN3xYDjRYZer3Ff/b0LnODV/aCOzcBGv7aq4QcO9CXpDNAlbrZojHjWxYraGY2SEPmIgXo1LVO+m1R2FWGJabZCxuYO1XkMcVh7B8LfTXc7FWDxK/h6bgQRTGGQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
 b=XYOQigYxGdMCLIg1MnIAH6ZFXD75zBeYEjP2olWCM5R18ODU806PAJzZI+daZjr/bie2ezhZpTsX1QU/r4y+YtKTqMrXkyjt4MqTVjWJCzmNRa+PBxu/QXU9MM6tn/otbo6fwKxM+qvatu5VgxR4ZwcqpQANIFvW8GqeTX1WLGMdDUNJuHLaFILzQ2rrzudm2Sd7sIb+7+NPssGhdH1anMeBPNewKFhyqGYfV6XvizeH0slLQqQQtyQ8t7f88wspiZNt5ixS/jAJFE0NXq3b91XxvaiS/zTeYW00TFbPj2vrBQBw2lXEeLkPkL1zHnTV20G/asR9bne/84zsdPwe9Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
 b=fwLno8yZw/nUyTynGnLd8xee6wa1btiAer8rsSxuIBTfrY8aXlm58w0w+CwxBlEoIi1r+ev+YI/CyjPBw+mcPcgG01hWSxctsvAg3pkJUgUU5YnuijFVbM3X8m9fExlcO+FUavcrH1a15sAgknIo3sy/7PR0Vsr6T2eFpZAQpJg=
Received: from AM6PR0202CA0050.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::27) by AS4PR08MB7630.eurprd08.prod.outlook.com
 (2603:10a6:20b:4cd::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 10:29:57 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:3a:cafe::a3) by AM6PR0202CA0050.outlook.office365.com
 (2603:10a6:20b:3a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 10:29:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 10:29:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tLDCDMuKM4pOISV9PMOVQkjtpoaMBrs+57omWjzG+WxlV6rXJxYj3eCw4/8fr/Dt0NNmRO8q7Q5amiDYRxLBFx/EfgDeXye70JTs0koZXThpN6njIq8U46hWaF6frOa79Mg46vvcnWFjo7BvxTDW8qlCkvRgy9WjQqlRf3n9Q3hgeTKUz1/1ZQaOA69CUyqWDKG8fet3BuGa/FwUhWLPOJZ1y0iMpCQmHOQSLBB7GDeWJ+oFA4BFlvobd2aLfgaBJul6dFqDAA7OkjAkLAjZ+FFQ+70BT+hHePqYaTtdWck8lwkycTDK6F+nulIGkJ6+EUmT/eq/ZaTrquLnZnDljg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
 b=b2Qcob8hqahgt6mGC2Jm7qDhFeU2V1kMVg8cOLt5rUvFPC9N/OB4kHjjmXRb5LjWk1PDYwcvLvnO8eWv2I8ZiVjPCxGstPBkARuBKeu7pqqt1PVvQYGgSqhdfhljA+PBFKGPpw2rIU2wNwvamtFbNcUby+HxOGONUL5aUjhvua9Mtr1S2rYARIBX8UELZOOnxH5EFSHzIfYrghp9inJte8qwMsvPt1XIOvk1RqEjoc6pFJjx7F4qAWxi1Ku62EB+GvaNWqrbceEWNbZQGhCJdGIHpY+DoUGxx1C2KJgwtO+wm1P9T/Xbp4kCSABg7C+lLtEYdrLM0TYOO31MNRj4kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5gnczPUsWQhvarKYqW9AkQmLxTGEo91UMGIxd/r5DQ=;
 b=fwLno8yZw/nUyTynGnLd8xee6wa1btiAer8rsSxuIBTfrY8aXlm58w0w+CwxBlEoIi1r+ev+YI/CyjPBw+mcPcgG01hWSxctsvAg3pkJUgUU5YnuijFVbM3X8m9fExlcO+FUavcrH1a15sAgknIo3sy/7PR0Vsr6T2eFpZAQpJg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA4PR08MB7481.eurprd08.prod.outlook.com (2603:10a6:102:2a5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 10:28:54 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 10:28:54 +0000
Message-ID: <6d03a77c-7936-49e0-a30c-9b7efe2ef8ca@arm.com>
Date: Thu, 7 May 2026 15:58:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 37/54] selftests/mm: hugetlb-madvise: add setup of
 HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-38-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-38-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0132.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d2::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA4PR08MB7481:EE_|AM1PEPF000252E1:EE_|AS4PR08MB7630:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc16cdf-199e-43b7-d78f-08deac2395df
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 Weg/2Gl9QkrODqvfHnyjC/Q4qZdYb+TTXX2QVRaB3ZzmYgosvfP5WwxobFLff8mvbaAAmx3QuglMgrEahHXUnq91mfGxJXvCMvnIIB6dXSHhr414p+dnsmzywLAPh0nUPDSPqkGxMHPJ3RuESuT+nl4IowsuB9RwxHLpZ90chmk3nLX+hR1DZoEVMevOEI4GbejRAChrwFezn1tx78xR3c23cxIaJCOaiCRP3e2jDoSLpdrjekLHq/l5MhhfEcwB5u8ofZ0O3p/NokGCD1ONLUg6me97auPz4zwMoFwJZXcpytZ2hRYNJ6GeYyjkkiXKaZGLHnpiR53IRdX0GZN+8KTsnyA6pEYL/jsTNhDk2NmhAQjGI7ko5gru2qhRh20ZmiPTIej4kBDB6OPQvmvZz2KPcjdb+X7ZJU9f4BDoKPJZ+6kKWwXSTYAPuqDpw2d8SP32eYGZMZzn4m4hA8TDItC8WnsNBGesJGIByKx0/Vhkfo7O7KH2YCTp0dCBKrsCluwoSn/oPr4+qkaAC1C+R3H3EdvP7R7bS7zbxuodpeQFhC9muvz12/ZjdHMet8gUKm4VCifr9p9yKxeRfsR6Q5CNNr7xMduwFWwuO4mdO0AOoDobZZvrVE4uf6ctcS6b6xT0Ze/eRqTItd0HeWbYXzaOVgPHLRI5IZUWpY+hbpCfSXScd0A0k2Vjh8wG/4p2
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 c2oiJC5nDRJHzUp5dOVUzJdhllufnVqn1uSt1t5qpi+Kr0shDeQ9giCfYRay/Ic4QOxwPl8RRtI3il2aYSfvBxpF78ywsndZEbIKu7+5nknG7O/B8xDh0fwXUjI3AEvMeMdv4XNOggy60/IADZJdsfjTZmhGXqm6YqrXKbfKg1KIubwzgev76vfWn7So6S+/5E52Sw3mGp3Je9KjCjYVvR40FETlnwPDOye3M6FCQvknB9yhF0gwDzg/MItKu62suj52jDBwEUH+zcg30GDLlNeYnEiCpxncwo7VC0eqWeSBMeJc4kByI5HLt7SWn97iwuhz8lfC2hUAtwZFBuP54w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	91e58503-54f6-4092-e5af-08deac237027
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|1800799024|35042699022|14060799003|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KZZsxW4SY1z5BphnKRp7xGXj6xc6kWyJl81juSKGIgpZPI/DozBbnay4NGLTCMrXUzY/n/fLavBWc3rp6MzMHESXVUf3IbA5G+MmUVbBI3Ru1jwy8cA61N+TuxH1A1bVjMHjDMO530D37c72NE1IQDqMPIBerqnvx9KAqZOCxhOrAkAw9tFzN1hfhxP5LqLvmLDu2FNaJemYyTRCWTkDhgzukXGIa8w1O/wGzZzpFyHK2o3+tChYW2H8e9Np/rbvwXlztcISG2CtXwTLkswTSc0tgWD7OvLEORzjx3tozVm/OwCPmghnt6YY1LbV8BBo16jXGJthwEGfxrhBvN1HpsRepCtmK0JiifPLu3yu6RlqkLRNtsC1hQQ4ChxMpvaZxDEgaZ9cNbfAuYjoBdfNb2dGOVMCOt+ZMGC7mQ6jeBPoTEfD1Zo+qu898Obzm4imnlDGqVN1PY7PBYSpc4ygFRXxF4Q56QljqgOGvFZ21Pyqok0Jog+BK7vs7K4IVBn7/iVql2jL2nYG/5lJboMITQd075/3UKNSmZJ4W3W/TlvuNkfArjlvhp/mbGsxG9iSyTYTTzy4CPPaSkSRB1oNNwEoB6TpciA2r4LdEYwyH/1d7hh8v/zok9hZk0ybSLOlqbKNvNk8IGwFEbpFQaqv53Q0VZ0V7xhGGRDtZjgUOef+bjCSIkh/vTmK9xwPT0bHQpyj13Qej7AQI+2jpw0wvZhGUfCvRRXtgglSbER9O7g=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(1800799024)(35042699022)(14060799003)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eYQQRKR0BFHBiIBFfZdZgZ2mnZbuS9sQvSzg/BP31AjEYwLd2/DhfzBOGI//crp1O/1MZ4buIHXVqeMIV4zOL6YH+hHByyBjg5S5ydskXCrTg3f/JQD1KuzjRC4kav3GfsNFy196U6AuAtZVDEtcFhUvHFKMihJ3FEIo5hrISpS9YrPK9tGLw+smCSKbVOSkw3Pgdm6PqxikgLoCAKjZOmiJVAdFPrw9ISFglU/6AfjKefDH8sKB5WuU6Ob75UjXgxW2GxYEiysChx9Wtcb+5i8Hm0uaLtMiaz47kQQkZMjuZ+ArMN3szbCmJvW80f4y0sxKymXCwEBKqjKardseo2cEj52HyN9sihgBxgDcQs0qKVp6QuDXwxnY1pHJUp14J163F0/VKuRrnQliIdYg3CundgEX6xnEFNue6g7r5mO5pL+7pjVKVVFuKtC+NUmX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 10:29:57.0540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc16cdf-199e-43b7-d78f-08deac2395df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7630
X-HE-Meta: U2FsdGVkX1+HiJz3NziFBr3edg3qEav0TnRZH2xykh3bQFNfmP/Sna4G0ax5bDjr8FjzOLpufp5IByu00ATKN8YoS5I1+t3w+qkUDhecKFb2YLZJJBdfCapyxKFwvO7d7/QftAlAdez3LPseSLDjKgFtU6/tbGs35VYzfQxtB1l1lApb1UhmVcchRB/+IoOA3jTm+F9/bJQ8JracOUBkIgHfJfKMEosJ6K6JTCevMcsOuTKL1aCI19BLZlHK1bv4zExXf36YY7UglE+yywkbZdDJwZc30VnMeYPFTA3NBoREPXMEhZewOBRnMcoeHCjZbPI281c9vEs5HByDakKGU3DlZwQZ8OyezAQ1BPdYg302neQTvYWXXNrEb0WEPsa86qZ5GdjaG9fJgKyfw0dZxFqa62Y26Xrkkc5hYyvIRB3QkS3cchaDGJI0VSfALiXvi/2Ftx6djukzYLMdJIPIleqkpDu72Q0Kfz7DXi/Oxrt4JIwHOmflXfBZGPxe9dlQ+WFIHsBelhVKuD/2X/2GiO6ocqdYUXTvcBkum0aloxO4zBEY63L19GMpKnQfbNe+8bcShVTuuRkDQ5LgUUI+4QCCnTO4yjQB9M7f5D2T3+qm4LvKwJlKHOdspT/s1YdMMRTbX0+1z8YC/T8mDmJtt6AtCUGb+Zy1wZ+E9R2ZvglyvcTpo75Q1YuwXFF/ZnnspVunVb/6g7T+5m8XIB4gyaWih9ldHG0ax3f13pWuJW5nSY2VqlSgbnvkkA1Sy5K+T7rlJzIEStNBxa2hRB0J5IfKSIxS3hwogg0UHa8DGC787KiZZM+mQsmCfs+j9+ugiT2aiVO8ApR7gk+URgTUTUu5KbLhBt9T9JgkoamjWp5jmJS4IExQVsdIOW6Gj2I2rQuVtKkLINz+eAu719RS6j11soaUDZaDmzLrPztNUTyjNyLK0t3unIn5jsfQ0pg1CRHepw9oEPVVJ14rTr2
 ZJXMdVuX
 ChBTlyO7b9wCJ57czMZvzS+RaBxZLjxiPpWbdb71tseHaTPAhWKAZtXwwrxbVqPajUJEG880AKp6gWQxucotY9xxdW5mPQ8m0opsLJJPN3Np+FPtOhT4jhenaCCi7WciCHaZcdjtCDSVqeuSXUKTW+pGAJH8ZOYofbRZTbnJjfaN8N3cjORSnOCbUuUgbShWjzOu8iUG31yvINxL113SmjF/RV7+wwemQjr8AGUJuX/vs0OzTCKGVE+J1kjsO+u9v2ns2zyj1PLo80UtU8g2CoN6HZmuQtSxI+nrzrBORyVnaNi7S5A9ve4rOE3ZFuXTQiGEa/NXpPXlI7WU6A/Lnukt+8Y6m1TLCB5g5JGM5aOkQtb7YSE05GNmvyMgP2kISE5IRGJMpOJi15tibicywV6H7DbiXlUEZDVzkQK6yxdA7NPz5SixuotNkxhPWWgUikYep6uoNb9kNW6su5B23g5lYdYdSaSbOUl49ZCeMVgOANMb+6lOZdyqPxBk89gtLFo49k1dq46BYYG85D/lU3HOYmmCgZxGr5sfyqdBCCGx51I+VU3W2v7ksaA==
X-Stat-Signature: mayy5qhwrpx1ctmy9fcpk64znhjmcqe4
X-HE-Tag-Orig: 1778149801-935014
X-Rspamd-Queue-Id: 01CBA40010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778149806-82716
X-HE-Meta: U2FsdGVkX18vYiJ9IbmClqUV8t6+V7sNPSwrVpzEbtrkMDDTVTDlCe2+Kzz3AEmFtkkUufkcgKaBab6i4ZGm8xwIAGKlb0Mu96WwRvElh6CtbbX6Y/D8V+jQjDQbeUz12cc/asTWtLej/ojJypxBl0VTonYzFvRsonR2ES8gsxdPPX/F4VqBuMamm0z4YYIw/wEKUjEoDfU23JLRSY9uG7QDZqlaItK9VW+7gGMbY4laNNl2rc1wcG6saUncZZk6Xh1f9Iy3QSVoWsR1kLbMo/YqioZ2ZvmZZUsEqTFIae/LnCyteELgIn55vtmfPoNlZjkgLgh5qG2lBXLfCUNx66IMgAtx58qg3mgviLsYRrO06/NlgF1vxzgE1aQjz/vydvG3sZOFpMYZKyPPpSXz8+atCkX48hqZlm6rOtiZ7l20WZijkNqXRXPuUT5dcYnmfYtkwXyOseZRNyS5qhLrqu3ZUNSn62w6taph2pq8yyL1sAybeuwYyCeL+hHzcFOYTB0M9XthFTrQ6ZuHxxbakSvTBw8JhoLbkdRy4wId2vZHfFNK+c+PN0iFME6SCkM4pf9j8jh35VI/1x2GGDd0l46Xn3HWGsk/4NxXLbHozDYh39PSLyGjh0Akw3A4H9RD/Zbyyi4l97W36EhI8z4gQm0VHqHWzUmRBvupsxcuqUjyxA83g6/UjG4LefqbHJfd2cXbtyuZf51e83fF5/+ykm4mMI5wLwfVDuz/FsMbVlZEOjD+pFp5ZFoitvfzvXKL2deO01tNlgQ2yGWrb9ybvJX+M0BALfCCRE4KyCW9MoxCFKm6XV7HjbcbTLQS2ZORM6aZ37U5hNyse2aziAfFSHIc3m04PyNoTRKyL5Q08BpDL9BHizrhHwD+oC0WDPicVsyIGMUfrNRkE3D5LEiRQ6CY0XrQlAdF8APz2MfyXYH5DFpSUKn/3adRzmgAs6hspu/eGLoBBtg4ulQ/zwc
 8U7iG0HV
 mysK+Eg1s0Iu7wwju9C5uy6YWdtoT2RCJe8Q/RktQqiUD98D/B4Z6hp367xwW00VU01cvtWy2AKKWlmfvI6rIigaIUa+cIG7w950bH/4/nVJyUHghHyPqkf2gkMkrRec/7JNvXLnlr6SyuOSvRkX3ewKlDBDYoueeRsw8DYQS9rqkGUPdUEhACZEm1jbAX5gDzatSiWPHquVBnPauK1QJJh8rbnTwgMDtZyAYyFGSYqxdPWZK5teoRsQ2NoM5ciovnp1sx/8m2Q7+wvGCZWZAs3HVwRMLRUAtklYarzxE2Z36wKWMZS8Q71AYy1MEp2qC/WtT11xQo5icxy6ABhD2RmrxzEPQU7QuQxoHV+C28VJiATq9j1lGwn7FiWeqp+cTrIJXH1asMM3wHo4rBOHJK3rq01Ydix3K0bccpx3fJ92pjpoY4ZcNhaTK26U0zwb4vZO9z7Ag9FD/Z8aTFPQYtF41Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-madvise test skips testing if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run this test before and after applying the patch. Before the
patch, the test skipped if the required hugepages were not allocated.
After the patch, it correctly allocates the required hugepages and
passes successfully, restoring the original hugepage settings at exit.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb-madvise.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 3c08eb6db6a2..b20648d025e6 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -68,9 +68,9 @@ int main(int argc, char **argv)
>  	if (!base_page_size)
>  		ksft_exit_fail_msg("Unable to determine base page size\n");
>  
> +	if (!hugetlb_setup_default(MIN_FREE_PAGES))
> +		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", hugetlb_free_default_pages(), MIN_FREE_PAGES);
>  	free_hugepages = hugetlb_free_default_pages();
> -	if (free_hugepages < MIN_FREE_PAGES)
> -		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
>  
>  	fd = memfd_create(argv[0], MFD_HUGETLB);
>  	if (fd < 0)




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4227CCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 11:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E6D6B0005; Wed,  6 May 2026 07:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FA06B0088; Wed,  6 May 2026 07:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7386B008A; Wed,  6 May 2026 07:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E65C6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 07:04:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAFBFA017D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:04:53 +0000 (UTC)
X-FDA: 84736712466.03.6381136
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012047.outbound.protection.outlook.com [52.101.66.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA694A0008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:04:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GzngxbHR;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GzngxbHR;
	spf=pass (imf25.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.47 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778065490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4G+3kTb1h/vUnnYSHPgTjGuaSbq673UD28urxJg27qc=;
	b=0NIDooDPYxBkJVB0dzpwESry+1qsoiSL3Z/+sRxF1hld0pPYYOXCEqEsu7veoyrgvlfhMC
	qNhl1+3hMW9sDlpv5/NeIWw1hOUyEZMIMJzFh/J70nf/Qk+wSbenBnF+GmMQxmUKukJacw
	e/01UCbownKoER4j4ZJsQfgj/W4+PAM=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GzngxbHR;
	dkim=pass header.d=arm.com header.s=selector1 header.b=GzngxbHR;
	spf=pass (imf25.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.47 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778065490; a=rsa-sha256;
	cv=pass;
	b=Hj6lG7iLkOiW6IQTEVe2yGd619bMm9grku6JUmBVQGeGqSaDlIYlFeGRzigQjfcr0EF4La
	SPPig/OL7R5DABIe5nr/KIRWb1XSJROnsnTO0zkjHkS9W7RUl1AG92SXN9FSBpQ4Z07OTi
	jvvdARjJaCfweZfcAvWQ2mN/P8hu9fc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AniRTt41B1FxYlen2Veb7asIrCvL9N2t+Q85N29u43FKf5MQ5o3mh0coxEjdtM4QsJhbT+KK67wOBy+1GaJ6ruF72qxHZ6hJGkY5aeoHjboBv9oomJO4YS0YHX1zqtSE0V6oeFbWK566X1EteoGFlZaykgiZeBC+I3Hx/UPNElwkJbtzs4kMrk2yK3PoDTSj8p4AdQYOf+rSIBz24gCXtHJK/hf1KhzbT6FkPWexS2b2u4pAOdoMaBkX6qzDMP8JKgUnoNDW4b/njt+CQS4q1UAONpPYbO5CEu26+5IEsxYFKBMmemXEcpr3brJGEsByVleRdGTAma4jVcEmxNxGxw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4G+3kTb1h/vUnnYSHPgTjGuaSbq673UD28urxJg27qc=;
 b=auWx7pQ9NO648oTrUdasctzYndO91Fmx0lWMAUhbgyfv4UkgAZZXLVChpngXD2j66FPi6doyONwIVQ2+B4vl1zU3HvNA45AsqPmvRFxEG1OnmloTemYWuWqATfbT4Ei5J4btuGpcO9PqP5GWzhywn+SdI7nSG17YLZvrNowb7yQi1a3vQbgNYCZ6WyxhL/+N6T1EzQo/YxawVjOE/0s9Q/LOZUSvsFcnw3aJhu0nBNOAwTQ+Es6lQdMT5DgxFbdi+c2e6pbQUh5PxbmwqA4kHFEBmBSV26ZblQTV33fqHFiaymt1okpTANDCNRiKQi0q08bczQ1TvtbW5AgaMc3mgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G+3kTb1h/vUnnYSHPgTjGuaSbq673UD28urxJg27qc=;
 b=GzngxbHR2I0Uf58Mt782whP5QFb56KnZRsrT8Hh4UwdHv6JmxokdZPdpmjCRafzMCvvB82BZeDvhZotklRmrC1dfS0ZTi6yLhU92u7IJgEjmcfkdZ+7tu9rWZ/5HqZ46SmbuSNWjaMuJoqzNGwJdlakRHS+0rZohxBuxGRg9boo=
Received: from AM4PR0302CA0013.eurprd03.prod.outlook.com (2603:10a6:205:2::26)
 by GVXPR08MB11763.eurprd08.prod.outlook.com (2603:10a6:150:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 11:04:41 +0000
Received: from AM3PEPF0000A796.eurprd04.prod.outlook.com
 (2603:10a6:205:2:cafe::54) by AM4PR0302CA0013.outlook.office365.com
 (2603:10a6:205:2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 11:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A796.mail.protection.outlook.com (10.167.16.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 11:04:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RM2RgL8/vKHAnC8+kBp+FlhJE6mLjjQVolHKqSYh6jnx1/v8zHPA73UxLogtqTImRK+BoYLAf1q3QgL3H3yK729UPzhfcXzo4C5upA9zGwYpGKYlTIyty/HNeyiR3KWdRXq7ScsRnbs88iiuqXk7MwhB1830E9b6XvaxbDG9PqHZNct/T0/JChn21FJfvj7ZCTN6zQIzhVZqhvYTSZi6kPmh8cB4LDWOngAQ+mysk8nMYDkdbErV52fNQI+3G4IbjFJ+eihYElUDUF6oq/aZiGxaBsKAkSM8pwSY0lA5CYCubWOsst7niieccpJthb1CCD3to8nvxBKEOD3xkYausw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4G+3kTb1h/vUnnYSHPgTjGuaSbq673UD28urxJg27qc=;
 b=pnngf77C77ZbuyTUb0APZr1V7N0dPArv6FzRg9uZfHu/vxU3HwXGXa3e7R+ptCOzoO5Ik7oF36yDlJUU0TRVbNzSkS4qIT8cFa/ur9gy1Zxl3UWR/sZbFj3lyW9gHsmFZTilX8BK2pOiFyxZ+8EJWJwxkh8Hy97Z5tr1r9wcIZ/yELUDVyAhJVN05RQFLsxSq3KuC6GT8roDZrj5N9mfDvf9dmKCetFNUQeRdHE1GGQWS0M/ix92YPIfO5yofgTodEAnFgDVZ1NsUK2TwsNQF+DgulLlUH3xctx0xvp7KeM2dWRcNpVNDDt+17L0fTMpd6gFdVCSg2ezRYNcHKZbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G+3kTb1h/vUnnYSHPgTjGuaSbq673UD28urxJg27qc=;
 b=GzngxbHR2I0Uf58Mt782whP5QFb56KnZRsrT8Hh4UwdHv6JmxokdZPdpmjCRafzMCvvB82BZeDvhZotklRmrC1dfS0ZTi6yLhU92u7IJgEjmcfkdZ+7tu9rWZ/5HqZ46SmbuSNWjaMuJoqzNGwJdlakRHS+0rZohxBuxGRg9boo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DBBPR08MB6236.eurprd08.prod.outlook.com (2603:10a6:10:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 11:03:36 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 11:03:36 +0000
Message-ID: <8b789c84-0949-4afd-8112-15cfb0a4f1d2@arm.com>
Date: Wed, 6 May 2026 16:33:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/54] selftests/mm: hugepage_settings: rename
 get_free_hugepages()
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
 <20260428204240.1924129-27-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-27-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0241.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1f4::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DBBPR08MB6236:EE_|AM3PEPF0000A796:EE_|GVXPR08MB11763:EE_
X-MS-Office365-Filtering-Correlation-Id: 8447697d-2310-4e4e-f208-08deab5f45fb
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 3hgeF7mTLneefUkNK/kAGiUh33/6pte42z2AFVJVTKdtLZTfuQGuN/jOstkMyCFyL7MYECuaXb9Hx0x6U2wL132qYiM0w/ahbOw6bWLt7jhyP5z+X6Qdd/aov9EZryws4LBj9Bu9FY1znDX7SxCF5gFp5+kIAY1lk7mXjSyP1fl2F0SzF9kxc12h5gVANUVqrOe210GdsqhSJ5I/zl1na8GasJOrAq73uQskNcySA4121q7342bPDK42+siuDy6BsR+KA0BKmAgGLojF8T5df7i/x8FKe9prV7yVMIHdWSS7/QgaX4h5NloE1wR07YisiUvsQWDubf0toRJgm/QZLZ/LVlOuEFFiCtmW1PFMm6YipnCKWNELGidRt7f8CNtXC+gCq9yBRVCcKWaM1jnvG/4knaF+18MjtgqkU4Nz9p10bJ8wouT66WSUhFryLzoDRtHX0Z7Telze+S3x7TFr40LS+9xiSfacHKBYDjwBr9WCjpfZyt6y6YW8JC1vQqpd89gjgU6t1ka1N28Ubgi5NFGNrYynwYhZsAL6vVRqnSKR6Be7ZkbKtRF79O1F0khYljKY/V4WnJaRJwos7hEnQtsRkbcWpmaQ2qU7IvJ9tdIcXB1WkLK9j32td0a8nJw3oqu94zwK5B0/uiHJr9QWmj99U7R7hUi3jeICJxRO+BbBEs04t9TEKr+DkO1hWE01
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 T5nEM6Iz//4a0/cqjQkLAua/hz5GT/MoQtxlEMxZYALXXUXZIaPT52FUS1MWdMkzFt4Ke5YEnragkRWOnGVnfHFCTMD6C3FTapopxtosiuOpMExtxjszsNhFUTB6607kClUY8JW8OZRCGdre9YAdbLxUeXmOKSD/gBVCbeS23//AiiWnnVKCTXfbbI4YMEdkFkpwkEn2cx9syduv9sLzgEn8OE/xE0cYjNuj7Vggo3iuKRa+JPhy8DFbzDHvm+8NPchCX8ypr5N4ixpEn2NvutvCrMUU67TYsUO1IaopNVKomfVLuOIBwGOQgmxpmt9mD4EDkfGHkQwd9awhwSn50g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6236
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2dc613cb-137b-4878-707a-08deab5f1ecc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|14060799003|35042699022|1800799024|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ZA5KoqCwxWMLB8jP24jz5/CTvUhtuababCdL4JYj3Po/qOQHQofHIbl9RWyWeFGd7J6eaJjXAgw4x8do9/w/vYycF1CIPH7Lw40HoLfwMqGfzrny8f5nX62OMBfRVWgLHdyzfVH23rMj+8BdxJMN0xhpMR0VCSRAew+CnioF5ESoAm+Z+LLv0Ti33CRm7ppo2oImU6amMiitVsLKRU3+uvGu51bwVhuh+4pVv0DpCVLRgTNl9Hgx0ugQeCt3z7Gmgc25zhmhMMn4uJUNglPw2kSE8xz/8gAzj4AfoFL4n7DbX+zVrElwnJkBvCgUoArgeHzHK8NnNMot/y6aAqvjZOQWXh54+vDhxulcyEfy0AWP96TggyYlPrtsnGolqQoLkxIJ4wqF18QVzOePPZDfwjqI+82bcSv3H0NqRato55mzafldMZZkRxGFfSL/ji0K4jgjIATc3awOb0dKX/iGs8o6S/WicuAuBcrHchd6C5A+CnCpth9tU/vHk/0TVTW89Fqs+OUt+YDGYXh/e2wpSdjZtihRY6eetVYAooLMslYQBMqANm0H8Uya0JWLfNyJFvXZf6hjNHQTyiizUgX6QTDGrRcpY+MWqAevgMDQiHp7v59pdadDaaLsc81+Z09RCu/MoFxQSBI/si3/92uLhLal4q92Rih7Y5K0H0Co997FsftRnZR921wItqFh8C3A0M7xnPO/6SIA1szU3rHMOU4qgVrd+AyFIpHVuXc23ho=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(14060799003)(35042699022)(1800799024)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lmjdrskAHIPeBN6h4l6rLBj67xcuCiFfTf4pst3/g+s3x9uJxmuJAOYy8JuCSUWNJD5wkBq1nOQN5qCPIMr/SzjXLp7JnFLRYVV0EDqTN1APRbNlPZaPmcTS66GLjDxE/GWyrkqA3Ckif12ayTneP/HaFzWVy2lpsz8PpxrbBrKHufZFRWByanFL/HmgdKPLIPmwLw/6DwZ6vALp/WcB0fvIYW+Clc2SR+Y1iggaMR++x2L9qyBhIQq0OPuBcBP4OVllvo8kenYisPo51BKWzJeULlitGYJD8C2NLc0WfBWKNvskCABy2+lSAbdnu05Q9sklmGRF8LASvgf+EupA9vZfQsUMQGJW2IxjFH8VMQDfnaorojUGv5ulYqjU5mBVYpof3A2YWn4YUlcT5I3Uf5eecLEz2UBrR0wFp08eD3aXB9rCxJNKQ/78at4BpCuG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 11:04:41.6441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8447697d-2310-4e4e-f208-08deab5f45fb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11763
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA694A0008
X-Stat-Signature: rq848mi9rz4gopfwxkehp1z6ppoh6xmo
X-HE-Tag: 1778065489-706770
X-HE-Meta: U2FsdGVkX18hZ5F1vqJWOEOMCtHWl9W7qiELR/YvFRfOZGE/pZWnvkK9mBsNn13VoTeQWdRWx9jJ9seWTVU0zUkdFDLaiYvUJ3S+ugkEM8/m13+7pPYeSsLSlDjT6mFmqqTnI6WL7fEzCTjKP/CWibia71eRSVCnQZqutst4U1Qs5FjXlw19E/pMMUISkNRv1/STVnZC6HvyISRrctEnvAh0g3FvluZREqftFqUNnbzTGCCQvg8pNumfJZm+qsIed4QNqCGmj8qfskeqwacQlPE2AUGPZlGynUObynbTGJBqg4kgYUQweK0kkyJMuqVm5QgYIDCJbuIukEmiAuWRPMe+ymNH0r2pCEne/4rmEz0QDmcSVh/yyg1/nB9ajQX27FKo/zBCDG/icsCXTKNvq7X59G9zqWEaWqjG7i+L+dOKbdLPMAo1BhcOZ7hgFpWRuPjbBJ97S6bFnxwVrokjlqhIc0w7Wk61tbZAkXxpxR0xZNe4UUV7pQbLqCYgNhkuCD5e4Gm003hdhriqs3Oqa8QEbROaP+qy5oDygUEi9CMLUbBdWsVfd3WPDCug9Bt1rgSgWjDaeh1bxk982s8DEp5KDc2RxE2DTXDgChwh9pI9MTKzrE2bSDtuvqPo7+NDMJaRdEAE2omfDrST9EioxOh04N2hWrYTV4s5ELcma1A7CcARiumTfw44sG3g8gOBB/tozEwHzfgO4lQz2qiZvtz7IRBJwb4g/FMn5p3znkpgP0R+bF+v7J9dWKsVR7a5IraP9bsYqpM8fVKpHGBBXQF/BBn0MTz6dLTgI2jz/In6QMQEEEicKSVCjGIOqGmh5Z2Ek0kFcqy7ny5mStyocRjyaU47NBkd8dDs1+uP9VPtD9VOuJOxRMP/6KlJHKkGFtRpnypvmTg7Nn8TYYN9dAo/4bi+EhzJ2ZWmXQAyN/LhgA38WTPnGH/Tb/6lp1388mH43ojEOsymcsJQ4yF
 fISz2s/G
 2MG3i+scvVTlvj3at+8oBgeyV3Uz0sWYoLiDRGbmbzbjzxesAAxn7y7rZZ/ftILx9IfKwcgH9951FpfXNH217h3nQnNeNBjIMlJO81H8D19Sjxi3NjKn0V41EZh08Dgu1o434RE8OIUtgmjWvuwB7Fc6S8JGRLUMUJF994CaZjVETR8/cFc06O8IEOkOsaRDe6xSoHQVfEbo70gBeFwzE9uqb9uD1iEbmian5Sc4NKkD7j3pUw+xSdm1tLwJgtuSy+aYWCobySp0BWuAKIRUpwbalxTyfoRfV9h69Zbt8QDuzX1ki6R0a9/iTPa4N2Nk20vGltxyLjcWKvVeVn5Mmwuf3r6KVqnWNtB1WKOicj+qhk4Uwx1n+1fTV2jZ2zf+rsTQVr4ln0MTJ2Xxtp9yqx7SLbwMkzIA9qLK/Ivn/PZ+ZTqZ9uXETvHlazZJnuBcuWZ9i8SGV+FhHgMGVDHFflVSrX93juoWDcvRIBfbg98LWctLPVAMlAqggEpon6VXhia8hISE2qDzUyCZ/4eMMT0XnbK+lQsd47lnRLiGkmpt5bKH8tFTXuDoSEiJSqnc1EbbN80LXfdsLfHu7xmvlEKLynk0/pysY3YeEqyeTYIwbM/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> ... to hugetlb_free_default_hugepages() for consistency with
> hugetlb_nr_default_pages().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Small nit, the commit message says hugetlb_free_default_hugepages() but
the actual function added is hugetlb_free_default_pages().

This change looks good to me. All modified tests produce the same output
as before the patch.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  .../testing/selftests/mm/hugepage_settings.c  | 28 ++++++-------------
>  .../testing/selftests/mm/hugepage_settings.h  | 12 +++++++-
>  tools/testing/selftests/mm/hugetlb-madvise.c  |  4 +--
>  tools/testing/selftests/mm/hugetlb_dio.c      |  6 ++--
>  .../selftests/mm/hugetlb_fault_after_madv.c   |  2 +-
>  .../selftests/mm/hugetlb_madv_vs_map.c        |  2 +-
>  tools/testing/selftests/mm/uffd-stress.c      |  2 +-
>  7 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 5961229b9931..4ae7332b5e1b 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -446,25 +446,6 @@ unsigned long default_huge_page_size(void)
>  	return hps;
>  }
>  
> -unsigned long get_free_hugepages(void)
> -{
> -	unsigned long fhp = 0;
> -	char *line = NULL;
> -	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> -
> -	if (!f)
> -		return fhp;
> -	while (getline(&line, &linelen, f) > 0) {
> -		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
> -			break;
> -	}
> -
> -	free(line);
> -	fclose(f);
> -	return fhp;
> -}
> -
>  static void hugetlb_sysfs_path(char *buf, size_t buflen,
>  			       unsigned long size, const char *attr)
>  {
> @@ -489,3 +470,12 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
>  
>  	write_num(path, nr);
>  }
> +
> +unsigned long hugetlb_free_pages(unsigned long size)
> +{
> +	char path[PATH_MAX];
> +
> +	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
> +
> +	return read_num(path);
> +}
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index d6f41a45e8ee..57fbf2f57e13 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -92,10 +92,10 @@ bool thp_is_enabled(void);
>  
>  int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
>  unsigned long default_huge_page_size(void);
> -unsigned long get_free_hugepages(void);
>  
>  unsigned long hugetlb_nr_pages(unsigned long size);
>  void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
> +unsigned long hugetlb_free_pages(unsigned long size);
>  
>  static inline unsigned long hugetlb_nr_default_pages(void)
>  {
> @@ -117,4 +117,14 @@ static inline void hugetlb_set_nr_default_pages(unsigned long nr)
>  	hugetlb_set_nr_pages(size, nr);
>  }
>  
> +static inline unsigned long hugetlb_free_default_pages(void)
> +{
> +	unsigned long size = default_huge_page_size();
> +
> +	if (!size)
> +		return 0;
> +
> +	return hugetlb_free_pages(size);
> +}
> +
>  #endif /* __THP_SETTINGS_H__ */
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 316384d919db..3c08eb6db6a2 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -27,7 +27,7 @@
>  
>  #define validate_free_pages(exp_free)					\
>  	do {								\
> -		unsigned long fhp = get_free_hugepages();		\
> +		unsigned long fhp = hugetlb_free_default_pages();		\
>  		if (fhp != (exp_free))					\
>  			ksft_exit_fail_msg("Unexpected number of free "	\
>  				"huge pages %ld, expected %ld line %d\n", \
> @@ -68,7 +68,7 @@ int main(int argc, char **argv)
>  	if (!base_page_size)
>  		ksft_exit_fail_msg("Unable to determine base page size\n");
>  
> -	free_hugepages = get_free_hugepages();
> +	free_hugepages = hugetlb_free_default_pages();
>  	if (free_hugepages < MIN_FREE_PAGES)
>  		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
>  
> diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> index 81e3f7bc8e76..47019433ddaf 100644
> --- a/tools/testing/selftests/mm/hugetlb_dio.c
> +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> @@ -93,7 +93,7 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
>  		ksft_exit_fail_perror("lseek failed\n");
>  
>  	/* Get the free huge pages before allocation */
> -	free_hpage_b = get_free_hugepages();
> +	free_hpage_b = hugetlb_free_default_pages();
>  	if (free_hpage_b == 0) {
>  		close(fd);
>  		ksft_exit_skip("No free hugepage, exiting!\n");
> @@ -121,7 +121,7 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
>  	munmap(orig_buffer, h_pagesize);
>  
>  	/* Get the free huge pages after unmap*/
> -	free_hpage_a = get_free_hugepages();
> +	free_hpage_a = hugetlb_free_default_pages();
>  
>  	ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
>  	ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
> @@ -142,7 +142,7 @@ int main(void)
>  	ksft_print_header();
>  
>  	/* Check if huge pages are free */
> -	if (!get_free_hugepages())
> +	if (!hugetlb_free_default_pages())
>  		ksft_exit_skip("No free hugepage, exiting\n");
>  
>  	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> index abc3904c5268..c718dd065d53 100644
> --- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> +++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> @@ -78,7 +78,7 @@ int main(void)
>  	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
>  		       huge_page_size / 1024);
>  
> -	free_hugepages = get_free_hugepages();
> +	free_hugepages = hugetlb_free_default_pages();
>  	if (free_hugepages != 1) {
>  		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
>  			       free_hugepages);
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index ac60b4f18784..dfbd71a7f709 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -89,7 +89,7 @@ int main(void)
>  	ksft_print_header();
>  	ksft_set_plan(1);
>  
> -	free_hugepages = get_free_hugepages();
> +	free_hugepages = hugetlb_free_default_pages();
>  
>  	if (free_hugepages != 1)
>  		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index e92a85463eb1..7e37cf3d27f6 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -480,7 +480,7 @@ int main(int argc, char **argv)
>  	 * for racy extra reservation of hugepages.
>  	 */
>  	if (gopts->test_type == TEST_HUGETLB &&
> -	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
> +	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
>  		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
>  
>  	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;



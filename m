Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A00108E1FD
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407896B04A3; Thu, 19 Mar 2026 08:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7E56B04A4; Thu, 19 Mar 2026 08:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258D46B04A5; Thu, 19 Mar 2026 08:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCF56B04A3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:31:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6CB8140559
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:31:15 +0000 (UTC)
X-FDA: 84562747710.02.DCA5D43
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8064F160003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:31:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Y+8lRa0F;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Y+8lRa0F;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.55 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773923471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/dtdQKMb2powt8ohLAhmVxBxHzafOxTgDy3QfUIa0g=;
	b=AHmdQiNpDBu9eClnF9roUUEECKGpsns0wB2iNsI9p5Kiv52TP2YLnsr9H+8l5jmd52x9ye
	rBdIxO1I32lIo9SL/q6b135CehUFkHU2i9CzPw7v+y6CLn5d1ANOAbSWsXqd74ObPqd7cf
	cCzSLRiLBhw9bRjPtTG0kY9k6xnT3dY=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Y+8lRa0F;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Y+8lRa0F;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.55 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1773923471; a=rsa-sha256;
	cv=pass;
	b=rbM4Wet/I7iUic6hZxUCTvWX+0hFT8gbeQUudvtmgNgbBLwV2Cx42fjVFULluDlG42rbTK
	KQL6DdYsUx/TCnJzFe4jAPYEJqLmfDQHn1mn0y7uFudlrf9+kS5ZYlp1HqYb1Njr/PU4TA
	mQIrEjgOy6GwURqJIMpBsp81tzai6as=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KWBPTUNrFbpiwwSgWxvjSY70l7UKCv2tCrHbt5Tn6EElO8aafkQ/kH/hKcJavYR25dBehYYhr+6eUPKNmDFHQa3LJ0a2ifsR7TN0YGFM0h+XCrWAdc2NjxEqKOxqK8EYmcaWQl12wOOGcvVOAWrHeZWYhQkRQV/xiywcuyoVRx3RsqGKyABuXf9plp2LpOdzNcPmtLAJUOZ7lUO9vP4aUVtdnH8XtNHRtezVKbu4VhW8/JiwQw8jCkj8cBQVDBAID23ROfODwR1gcAHByxE52dQjpr8L7EKbI9s7kgQDsP3IlBkhJO6XR32vFKcg26SKUnWvn1M3XqiTzhoUCYqmyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/dtdQKMb2powt8ohLAhmVxBxHzafOxTgDy3QfUIa0g=;
 b=Luc8OM/eXW+q0GEpWoHFi9WPxyaceyDK0w6F2eKrNXIfFOCw3IvbMvvmDSjxJsCOkEE67FAsvgWvM3NLkXx2SmxOaZ3RquO+AeE3ZzZoyISpuvxmE1U/W7TgN1JQj8DAGhnlZZusrsrJy7s+u2HEwcYtztYlwq+BIzXaPeBq44Fw0pMOkeD4nydV6XpVF1wmtFuCZj5IlYAw6jDOpSeN5GqcG8tMLJQTo7GlrmT9W5POVEAR3ToA4fYNEKC07FINVfFHZQCFbxlu5UYfMj5b/q2yvx3z+uzu7URtInaZr5YoHlBh7OcNChl7QZP6gzhNUJ9Bu41x5VoVUpcVQktEpQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=arndb.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/dtdQKMb2powt8ohLAhmVxBxHzafOxTgDy3QfUIa0g=;
 b=Y+8lRa0FBYJum7yPiHoPwV38mLzhA5APlACaq41N6o909qux+xL08yuBNFhRlM336EntAkg4i6XEIMg4UGopkIVKIh+BWW+p/6HIj+vBTpGoO1FeTLAALh/W8xohLnpXos5VoYmBYD4t6pDqZ9ilNN0s1p78JkbwVMKQlmQnS+A=
Received: from DB8PR04CA0029.eurprd04.prod.outlook.com (2603:10a6:10:110::39)
 by DB3PR08MB10336.eurprd08.prod.outlook.com (2603:10a6:10:43b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 12:31:04 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::94) by DB8PR04CA0029.outlook.office365.com
 (2603:10a6:10:110::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 12:31:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D02.mail.protection.outlook.com (10.167.242.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 12:31:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WwlkCE50rmCfNp6zbXQzHYUuPv3cX3H8OrRGPq720/YvdRqslvQnXqbkwwmcvQ9mWKnrRz2Hw0TJ3yc4NDO9Y1teZse1yhdAiBfu+zbPsMj02ejG3foboLmt2ge8mCznsuHi/6Xa8dYwrD4Ynye31fGmhatVwodPOJd+NH69Md/SCMXN7clAClGPkTZ4VxiqQHYYmhBRSEu+MaxkaggbU53ABudsfbLUpNhd4XXqrzz+YjRzFXcLNucWKLgAFZkpbWAl1ETnfSX6+JwITa9VbV97c3HNYF+6ZVRO5zoQHo06G3faW2yfuEtH6vYHeTys9gLyEdH5UAmEe1QJV3kqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/dtdQKMb2powt8ohLAhmVxBxHzafOxTgDy3QfUIa0g=;
 b=XZxVmWfUQMp+gLlOhCimNdFxGeCO6cUKWY8+0nN0MNbrWr6zD6Q5zOeCXlXosK7XlpwGX6WM2Bx5q/i6ELuygw90TqBYaqBKNGWufq41HrVGzjTQKcq6WlCNQsyB1o6iz6W2RfATopaqNCrXJbdS3Xxq4i338uQUp9FMgJRv9bWLnzXlX+h/Dz/IvTgd91s0IR63PHHzAb3oX3ZINiaJlFE/LXBAKoVI/eCneGDxLwP4EuW42aBZVPg9vWIaewUHJSHVAIVlxp4htTGIF0k/awHU5ZUHTaZz3L5AC7As8GvuJutN3AAEgIIwMhe99B0+q2gnHStyjp8Bf9w/zeHqVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/dtdQKMb2powt8ohLAhmVxBxHzafOxTgDy3QfUIa0g=;
 b=Y+8lRa0FBYJum7yPiHoPwV38mLzhA5APlACaq41N6o909qux+xL08yuBNFhRlM336EntAkg4i6XEIMg4UGopkIVKIh+BWW+p/6HIj+vBTpGoO1FeTLAALh/W8xohLnpXos5VoYmBYD4t6pDqZ9ilNN0s1p78JkbwVMKQlmQnS+A=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DBBPR08MB10772.eurprd08.prod.outlook.com (2603:10a6:10:53c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 12:30:01 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Thu, 19 Mar 2026
 12:30:01 +0000
Message-ID: <6f9ee2d8-7906-4051-bc30-44823e2b2133@arm.com>
Date: Thu, 19 Mar 2026 12:29:59 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Arnd Bergmann <arnd@arndb.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
Subject: Re: [PATCH 2/3] fork: skip MTE tagging for kernel stacks
To: Ryan Roberts <ryan.roberts@arm.com>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <20260319114952.3241359-3-usama.anjum@arm.com>
 <dc85cda7-cf66-4bfa-92ab-af23f550562a@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <dc85cda7-cf66-4bfa-92ab-af23f550562a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0024.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::10) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DBBPR08MB10772:EE_|DU2PEPF00028D02:EE_|DB3PR08MB10336:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d1e15b-9ea5-48dd-c1a7-08de85b36336
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 V8TR1w1ewM4oELH7XKsVgcZQrXj1W3epj9i6RXgHcJBvYAxclbn+hNcCnFg7vHn6tg8Ey2sIO3WbzUJj3CdnBdDt0NUsCyJCNrMyNDAQjh+FNvMuGuLulXhNgBp7+uP0Bq1N9fGVp2Q4ecWAnR18WwnStmzgHScDUHKv5siERG0jHpyA2oSWphUkMKi9TZpBESKMRdX/BR2GkwIXJkDM1YKPksLpcqXFm7WgKDrE+h6EGazyZv12uTri7L8XJKabvWNkclizOYTI5jlJd+TpFrLL000yI4pjH3vowTd876Gwlvz9HtrRfHRlZItZU70+dsM3xwSNkdZxsKR7nH0W4AMe1/E2AQjAf+7KUf2iCt/nkBrL7Xve7reY+hAvKJI8R1Zlk6j5RTHKLvLqkWUydnh06mgHNpADkNuHt9zpHV73/4rb++U/d7OQu/jnJqyBZnTZvo6kiUFf5vReNk8bPmy4Qqe1R23eIeF5jmc6PBwA8WTOtTqCN5PWSDWsYc525CY0bQsKJaPJkralPfIqOg0G/IoKKjOuP0l8XYWSHSmm6YYyQEUVFqrUr0AQ1P6hRTunTLjOv+2DjmpTj7ptTFC7uULYR+sFgofChB5o1nqDMT3v0d0bxpewn98ddeTkkuvF27mmxNBk2sDJw2TstT3Nr2kfxu71fpDHID4bgaUv/gce0ZdmixGBZUzOc/Py+FlqU5ksKH3DRecbqMZMrrJIPN+XuwyCichxxl/bRrE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mP2kzuaEfNzMzHI5bRmVKZ++ldI4dHAr/nfbKMYBtPA1lgOhHJf15YaOSUU6/HU9W8tvcgRyIexLweZiKx081mDRYix3x0oiXf4Blk2oGt10XPoie4NwTp3oz/K+NhwmWOzFRK6mNd/XqkUsynhpWT5E0U2xNt6TMZMmu+2NBRYYdohw+ZF6yGgDFndBVUYkRPd/+AImQ/po4sVgzNMwFDcUkqL1LwTJ6xveIQn8zdVIBm1mKPEjqgimmbeifj8GpzhdeszDbYAlyqJL69Wuwy1E7jh28FQRREM3ksUG9mLb4E2dZOmmxWUZzzE+wEs+8rEMbXqbvPu+1qQVHtyQBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10772
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f3fa6dff-7589-4513-313e-08de85b33d76
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|7416014|376014|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xCr3Zg4BtfjG/zTIwss8IS1Bgm9fERZxWfIJfbVIj49CkwGHidlfY6gl30g0bTynw1kVJ/GAcl38+nRNUhW8LhnhF5imV7AvowtlaNj0+REN5mELUGPOaz2BTzaxPPml704Pp+S9tGtGO40JLRJCSqTPXbqWX0TCigBQzJTyFIC3ADDk/gEMC8Zte8/NHeLn4IvYT7gzss1/PT8KTxKoox66gMSTnK3ZR5P3N5/vBZULLTKlp8UHPg3tL1DgxT43sVuGcWvTt/TtGzcYEgvuFbxQx/ZXV0aWIJ/0CaA6KKUptaWefh4xIalYwXAi8qgLyolr0VutS0hLjdoXdk52Sz0F4QAOby6eveQQl3IHhwgoEMGIKXWmVD4R5EZ0Nqbf6c3p8imdD/hLDSq9hb4uJ0vbY+3KEz9+rthKBEbcCG9uJJzO8wyUhOqMJfnWYlxm272wDPgjpYsyTj1DGEGzyq76p3tnLTmEbGthjf5n1UX12Gbsy82ke5UST1VNMmxPE3rFFVhkbtGU5ZRQ8THtnbM/Edtsz+TY8vogTuMQrJE7DjhQ2mESEjFZqYO51eLOWpQYGSzZkDHyd9trBvizXWqiqSseH7KKhtDBEhRRm37MZbLXZJh+lvqavzmFFmaMDb5Dj/HjvOuepZ/m0BvkKeHICR67OGjaNQLkpd31kkF8FGrjvfSSdeIpEo74IkKgIMhfDFMZEgkbO12moX2Zg9Z4g9Kjdq6Zr4EgezN2KTNtWH/28Zpws3Mb4U6aFj9y31mlxlNZxrlGVSqC909ceQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(7416014)(376014)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PBhuHUTRR0k9m3a4ZSNZ69XDkEpZvu2nV4wrdX/Qu2KyZY6Xcdzx4Mloei4K13a/UVdkJO8iKo1leL8zL26Ag0RJ1QzzNeRE1efqg0Iun8LkOvYhwWg77q+nV4eOFRQOZsZPS9ZncpMNZLzluEFUjGX7OLeYEgSNjGjGgQ+h8RLlBwEQWkSThkfEvOEmLVEnAIZkbzqqW02UMjMNanWI7UdH45/A4mObvEkBOlhReKWy5IU4Cz9scwOKR90qSrVMpqWa6O/a9SkyvcjUH+oDzob3wvUPZ2BNHO+W/vCOSMJ6Mff2fbhA1hfJTTrKhjHXJkwXCQ50T/MuFOLN4QeOAw+uI9DulatbhvHMCSdAkSwUzEPO6mj6ejvjZOx3tC4ZOopiFiH0HViD4Q/dbrmDJJDoJXRjMJWDV3v1fOHtJWil7sGqgIPCWkXr2Gr5uxzF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 12:31:04.0971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d1e15b-9ea5-48dd-c1a7-08de85b36336
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB10336
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8064F160003
X-Stat-Signature: xx8gd387g3tztwq9chc4f84enzaywc69
X-Rspam-User: 
X-HE-Tag: 1773923471-777811
X-HE-Meta: U2FsdGVkX18seJq4O8HhfMzt3sUnEBTDrXiwMQFlAtN9aAsk6JGGzyDtYPuYAtIo5aSglvnIe72PydLDwMlbioIUKhUc6Vb0yb9RC4F+rPXhncySI49uZzfp+NflZNCCjnr5VopJLSgeJwR8IsjjNHqsr0wx2yQTR0Ur5l2cGKNtl/xmtFrfmUA6jRBB557dBxo2UG3PSTeUvwKwUXjN5IqID+kupjtXqhmNDCxMwmFtFeF3MlX+Hf4VVGpbZT2gORdbWdaeUPlZuxU49MY/jKwldyobwFtcX21wzpd+hOaPOgJR1s2l+dmvfH3gL2VM9FF/o7Mg1l4WjoKYyKZMnSaQHcvYoE1OiStlQ+28V113btk+7AGpJQQoVUBRKgVtVWWQt/KEeYh9hoF0XOe0JzyalmgSPw3+oZvpGeUgWBKsaY6dvFCMHdJbTTbu5i13f8YpOh+Pyas/G8zf4IiYLYNUiGUeGWWpPttzPEeJ6SeWIAedjwG9PqaOxsubRs2HHkCUToqwAnePZtumNIrr5umaX0mH/VLIzVuRklrbedl/J7zJaokAh9mJHt9Xqe9UVIA5Q4UeKAYd0aQQ7purQdykbfwKRHS7pDaoox6foJGxXYBv6mAgq31dRWIuAtOuoE1kUal6CAuL2FkS/akH1mKaU34D16ehLxl/btnTu0TpqDgsClOROM2v8Xw6pbNfDQjdN3V5myhL1szYwSUeUag3TIF0gUiuCgMbs3rneo8x8g2Rl0pM7fDbxOXNz9DruV6wZUElXD4qq9+Y1f+AtfeCe8poyPkKFw0WzKoXXG31H3EKNwr+OaLfg8ZfXkNBzNmqt6l9N1fdipC5EyMslOKTx1kzJQCajpGcYYg0VY/yyuk5TQPQ7Cnl7lLnoP5IkdAtsWURay+3GxWz/YC8RZCB1qcLM5g++5RbDYbF2gbIyyoRVIGyT7yNy4U96aw15WHQkYS0OQng1Ia3FlB
 DboHxC35
 +Y83kEA0VbyTe0Y7cLEJf8TzLgwH+a5ClHdrlBYRxJ0oFH5RlmaP2Fnlm1j6sNaXD37TbkkvHdtCRZo1yZV+6o8dMfhAofz6HhdWc2M5nr14B2nMzcywRARd+gIIQbxdrVa/MQulAqWDq+fgHFy4dJUtIe0q1wvM8h24rAzy6aOzSZQsgE826IFxntzlj567wHH+9HXYapbzDN66TR8B7h8J3JJ5E2UYfc9XNd2quOxkzhWTaGzh39WA7SeBiPQWPV3bV1yFe16iayGsnuA3kXQeTuYtZCa1MoupPbK61BZ05avvwU3lUXKA2jS8+ILvZirgbdQIRPNp5IHTEIYJX+E41dbylSixjaPEptRLMg/qNFHPDne7HXhJMylXhkGysK9P1q4T0QcGdY1OhARYMbnOR6FvXnbsn00G/LWQ7l67dQysXMW0msqSPtyMEpoReQnb56A5hon4wENxtpwPf1rhK6zOdTgOELjxQz53shzzxtzkDhEixDZ9ID8MsNetkdfhKq6zYpHS5YGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

Thank you for the review.

On 19/03/2026 12:09 pm, Ryan Roberts wrote:
> On 19/03/2026 11:49, Muhammad Usama Anjum wrote:
>> The stack pointer always uses the match-all tag, so MTE never checks
>> tags on stack accesses. Tagging stack memory on every thread creation
>> is pure overhead.
>>
>> - Pass __GFP_SKIP_KASAN in gfp_mask for vmalloc-backed stacks so the
>>   vmalloc path skips HW tag setup (see previous patch).
>> - For the cached VMAP reuse path, skip kasan_unpoison_range() when HW
>>   tags are enabled since the memory will only be accessed through the
>>   match-all tagged SP.
>> - For the normal page allocator path, pass __GFP_SKIP_KASAN directly
>>   to the page allocator.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  kernel/fork.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index bb0c2613a5604..2baf4db39b5a4 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -345,7 +345,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>>  		}
>>  
>>  		/* Reset stack metadata. */
>> -		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
>> +		if (!kasan_hw_tags_enabled())
>> +			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
>>  
>>  		stack = kasan_reset_tag(vm_area->addr);
>>  
>> @@ -358,7 +359,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>>  	}
>>  
>>  	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
>> -				     GFP_VMAP_STACK,
>> +				     GFP_VMAP_STACK | __GFP_SKIP_KASAN,
> 
> Perhaps cleaner to include __GFP_SKIP_KASAN in GFP_VMAP_STACK ?
Yes, it would be much better and the correct way. I'll add it in the next version.

> 
>>  				     node, __builtin_return_address(0));
>>  	if (!stack)
>>  		return -ENOMEM;
>> @@ -410,7 +411,8 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
>>  
>>  static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>>  {
>> -	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
>> +	struct page *page = alloc_pages_node(node,
>> +					     THREADINFO_GFP | __GFP_SKIP_KASAN,
> 
> I think there are some other places that could benefit from __GFP_SKIP_KASAN;
> see arm64's arch_alloc_vmap_stack(), which allocates stacks for efi, irq and
> sdei. I think these are allocated at boot, so not really performance sensitive,
> but we might as well be consistent?
> 
> You've also missed the alloc_thread_stack_node() implementation for !VMAP when
> PAGE_SIZE > STACK_SIZE.
> 
> All of these sites use THREADINFO_GFP so perhaps it is better to just define
> THREADINFO_GFP to include __GFP_SKIP_KASAN ?
Yes, it'll be the straight forward and clean approach. I'll update.

> 
> Thanks,
> Ryan
> 
> 
>>  					     THREAD_SIZE_ORDER);
>>  
>>  	if (likely(page)) {
> 



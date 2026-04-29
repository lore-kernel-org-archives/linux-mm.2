Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3917FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3761A6B008A; Wed, 29 Apr 2026 08:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325F16B008C; Wed, 29 Apr 2026 08:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDD36B0092; Wed, 29 Apr 2026 08:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0657D6B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:12:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A05CAA0194
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:12:07 +0000 (UTC)
X-FDA: 84711480294.15.DB78EE9
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011065.outbound.protection.outlook.com [40.107.130.65])
	by imf28.hostedemail.com (Postfix) with ESMTP id BAA45C0009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:12:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gOgj7KS5;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gOgj7KS5;
	spf=pass (imf28.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.65 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGa8Dv6c0oY7zA8rxxPyJ26KB+Qk8zyALnhp2lNUrkU=;
	b=Uy1zNs1GzTdUwG9LY6CBvsVj6/XVSL0VHaYr8JbiPJQqWkYQt3V/0muazpT/EccTgnil6D
	AlaB2sh6vKY7V3o8q+9BMRjxYAED+cQamFeTzvAUAWwZGtHOnjqMOfJcoUI5oStINZ/nW3
	5pRxl4P/cUfFH9uGDNR9421bpFl2Nxk=
ARC-Authentication-Results: i=3;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gOgj7KS5;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gOgj7KS5;
	spf=pass (imf28.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.65 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777464724; a=rsa-sha256;
	cv=pass;
	b=kIs3vJtjT8OtF3a8sozt/Nzh3wdz3pomxOqgbItE900vwgjmxbIH1E8mE/tuNE6DiXGr5Z
	6PPr1it5514UKAkFYRRmiHpXVnRh4uDcFuXoT7mao9J7w79cgv9s4kBaANsSG/fg03iinW
	CsDI83iMkLN13FTp1goKXcYQhyLwClI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m7gPMhpLsUWuPz6KRXwOLO0gmV8JctLSMHQ9EdnPe181iyKm6es6vISK02QsvJUkx8OOg+8JNQv50/fuc0PvbwMYARVm8PW7rqbjqBr1hq1pLVaGN6FYJLeuj6/AF/XIVJ0oXrOF+j0YlUJmwSU/qUuG5PYyImw8VitrVXRYkrCyOGb5DO5D4ZLM4qyIYAW8HqBpgz+7cqKZD9JLnKHe9KlYGm4232tZ0AA5ElbD7VT16W+miitITFLUtTF2fx4SKCv94Zqryxy8xBD0Mo+E26b+zCQdPd1IE/p3XdONNcUmdV2HXhVYTp0eFVibpYRa5n5lCOh7kI1UmlaPrZIkjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGa8Dv6c0oY7zA8rxxPyJ26KB+Qk8zyALnhp2lNUrkU=;
 b=x+ya7j9Rakg/jd2a93QRzFC6B7SBFqNmqcdGIJNVlR0AEpBDXZfH67RFWfZasjTzVMwmSW9g3D4wT1eHTe89Z+OqPEedCpDgRczKIcz5dJ7dQK8XMUI7+eUralJXFe3TyjWsXyKeyfnqKvkxsUdzQS0qJ8tS3Oe85RJ8RWMNob1Ijtx+kdKJlHDNDYPNb+C2WftpR+kalnEshwdX+4/ZxVpVBEnS12FpqxEdJvW1NPgHTR1uU9CGHWKa1qs2LCfRg49OyAn51adEy7OsEEkw+q2zY5eOoUBmCffPjf+HsNCOCj/8Ynp0Mr5BDVLADmNwIGWlGoiHM0QqrAELS+Kdxg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGa8Dv6c0oY7zA8rxxPyJ26KB+Qk8zyALnhp2lNUrkU=;
 b=gOgj7KS5eJJ0HNRSEZ43pWI5ZcZz2st71n0V2H+513oqxNAyM3twutAp9yMAXZV3Q5OHPTFseJS7bHLGev8ijfr3sgCqGlxh+F46emkNEyguFu8mO9V26O6afuMnQxHE+QjPpUvcRZ1O/Cg5Q/JShcs+EeylFwd7t836kd8CQ2E=
Received: from DU7PR01CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::13) by AM0PR08MB5508.eurprd08.prod.outlook.com
 (2603:10a6:208:186::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Wed, 29 Apr
 2026 12:11:56 +0000
Received: from DU6PEPF00009529.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::15) by DU7PR01CA0015.outlook.office365.com
 (2603:10a6:10:50f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Wed,
 29 Apr 2026 12:11:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009529.mail.protection.outlook.com (10.167.8.10) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18 via
 Frontend Transport; Wed, 29 Apr 2026 12:11:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KvXZCI2xGJ4ZEcb2IWRgjmmYjT1Q+YAgTmGMWezmyh2WxHvES9LzV8lM2AZaf3f+Qhh5/xkbJ9/1FT/Axe5Vo14kwCGOuSZNWupkMvouD6wjANeipQan2hgmpu3MoTmwUqfTO9g9x8lKMT9o+NpzX6QLT0pBleZCnxDdY4aUx9DPX44iPuE9V15lLcCOJvchO2BbQF2Wa5Dof74KneA7VSdTTP2uVhV84eXLzqA+KBwLaodeg7nowq3D//HyytLX+OvAvbSMc48xIdPQbXbiBvZu+UcWylULrcoXRU+rXFFnQl1i0hbwA2QYFXxANHQmCUmNyiSC5QiVuNDdisYGTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGa8Dv6c0oY7zA8rxxPyJ26KB+Qk8zyALnhp2lNUrkU=;
 b=GVLAXJRgRWx2ACtDaoy/+4gwwKZV7sk7NJ4/+dVHma/+QlvPhx6tyIBsWT6t05uTjZFuPe81OlARaflEWqTQK8pbEe7v5tSpoHGSodUqF8KC3QUMejgDNkNBWqbx0CNZaUHfHm0gyv3LgSjEyXMETlkjLjDZEHgSIfkEv3TxbmMnUEkHC6DkE0J9INfB0TIJ0KyG9kmVPDzSA5cx8qxvakgKEiJiGqUpvMfIHfeu/Nb/uanr9MGPu5h5E2K+RrVHk0O7lPqVWyscALxGR0yp7JgErH9oApEXy2WALelNi/5VbIm3mlqN2Vee0iaQpZfNZwcFpmDWA+3iEtxsK38hfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGa8Dv6c0oY7zA8rxxPyJ26KB+Qk8zyALnhp2lNUrkU=;
 b=gOgj7KS5eJJ0HNRSEZ43pWI5ZcZz2st71n0V2H+513oqxNAyM3twutAp9yMAXZV3Q5OHPTFseJS7bHLGev8ijfr3sgCqGlxh+F46emkNEyguFu8mO9V26O6afuMnQxHE+QjPpUvcRZ1O/Cg5Q/JShcs+EeylFwd7t836kd8CQ2E=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS8PR08MB8875.eurprd08.prod.outlook.com (2603:10a6:20b:5b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 12:10:51 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 12:10:51 +0000
Message-ID: <37b23ae0-0532-420c-b426-7f91bf35ac36@arm.com>
Date: Wed, 29 Apr 2026 17:40:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/54] selftests/mm: uffd-stress: use kselftest
 framework
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
 <20260428204240.1924129-19-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-19-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0215.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ab::8) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS8PR08MB8875:EE_|DU6PEPF00009529:EE_|AM0PR08MB5508:EE_
X-MS-Office365-Filtering-Correlation-Id: e74399d6-0681-4e7a-ba84-08dea5e88193
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 6fc+SfkAdYze1CVTNhDVbyDXw3nXdyHKLd1J9K8vt0N8HonBPTUq0K1v2LkAlnQZr9g1tULpMe1qQZpwjmbwKd6h8d0CmJtCyUZhm6vI0XfxUq0axKl4wfB3O2rxJro0mZDkMYKZySEYIeNh4UV/eJFL6M1Vrnf3ii2ZEEsvLRs4LePC9LNpE7cu3SsohLQOPb/iZIuBWvHsdyuDO8nSiz7J18K9WWYE6+K2+3kWucpH7A7B+ZgMChWVmK7/1rR3D+DtqR9HoXORgx44GJ7oVInn8tieTTzVgsvNRHrXsjVMvF8RfJLSiOwPqWf+dbUU6i8QnoGa1Gsw4L460c9UOG2Q7rOTEAYp27gKPsq6nOjkWSY6+WsAKLl2+3Nnt2qz+S4B6WV6TPf91lUIT0K1oulDXAWXuVuf6aaOq8xiiyfmgkBAPFRyGbOLczfNEI7oNNuaQXw7uBKrYOGbyxD8osZhs7VIzhORpbk1LT7z9F7zlCR2zLjPlsOg0U4d3cn9HC8mo7KblX+oQapeKh3fkPB8vJamaebSlO42shcHXndny+6rT954oRNSAMy4Fte9vjqOj8G9Dmi/GCcbNmaSzvXhDEsyOeUipxB4aKIXq5i2tRo6NeZ0Twa6uQhPfdYcs6KXpGuJ9zH7ISNuahjZ7TWSsm8rnGV2694gU6Om94E5NOfET5mq65M/X3jI+XpSsTGM2dwgP5+OKYswrb1y8GIhI4pXb5hM+yV5aTOCrvU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 eZ+TdKYeh1fGvAq/BJPaY8OVVedgQNxwivWeCNcRjYmBm943NeUbthgEEYvp0YLiZhb/sGd2ZQrR94tKyrTaMnjU6SdY6dQxc+HwU/In+dYTJUjTcREPGU+aX71/RneDyztzYVX7xsfisd+u9DaFzdSZfigpvBMHT4z/AGGK7sJCjrghgw6xxhLY5VncN+jzypAHOiaL94V4UBwrptpenckxcNgx/XrVf/ilc21LctB0korhiPv0yoHah4sCwy+9jg4iXBbeUK/ejmHbFPl2PB7/pMp6ZmeZ5yHl13OsyIHICNZvtebo7uZR7qEB7V4WWPUFQZ5oJzf6RUc75MTCkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8875
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cbd6223b-dd76-44b9-c766-08dea5e85ac5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|14060799003|376014|35042699022|82310400026|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YV2XJNvCA2WOoNnOHdaLzaHyZ5zECA0jA59g6P2Z3YbEKIvTlv2DjmaNYakehrDHehX1pSov0QhxsU+yq0x2//1BKFXX7QKaXQE6aTzjkHbANIoTF3nBqe915iLYKNb7uV4+XrbhMb7yEldMQrfQNJtRGXXU34dsGFKFD4h+TV3WGmZbhxnlaKNnsNRtRjC5GDeYU34CKXNNhPpyF/KcV9tB4Dba+kgqF2SxcS57jVYFMg05UkLnM6JVPcgmnvkOyPdNm2/g4bI1ls5No/qA2XjuL58ETI90gL85JczrR7qXiWw6S6d1H7G5qXVN+5ofvXfbYClU+6K9rhSawmbZGUJM0nm2W5nTT6fQIDcGRifXc/oDGTg4Vp5sF4zGf3y/83/ddj3eI2mZy3kS0R0EGuPdcAfae0WT4doqJUD07Im3aOUU/lEEc4XK+ZjR5HIo7VMvxGnRu5UfgBgNgP7xI4eUlwCTMWW7SH4lSYleN5xCAXiFy0xEe4BWBNmrSnj28t+svbk1pzGaNx6qbGoe00XZiZNCpmTxoT8rw+oWz+Z2Zrc0P/69wA1HO8R85bWV80B8dgKuwx1SX/lct3QAxJeHRHvb1UGgJAflmJ3VMIwydcPYSOk6DF/DmjhJb+DgAaezdVNzjPYHTKRoGoM9BoeS00xoUy7AjciPfkcwPKprvZmhCyvLz0kwAMFTs5CaA6a3h9qAu51mSd6/hnfF27lCvRM6hRiE5ocXxcrizUT/8YWP/hNLlYUyd2D50AOT3QJ59db1jPjR859oa0e5nw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(14060799003)(376014)(35042699022)(82310400026)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VfkcA7uBGR3V9SM6wVgydWT+tWV10ZYmjysfN2vKW9YcXE95tNJ0BN/ve7XngfIRI7wvLH/A9GQze/nDsguGhn63yf3vOZT3MTekrT+6sbaOcyEm2GGZBuWzIYbGJAiJ8NoorQ+oNkg/30J5d9gf2M1dlFXIOlG/mF4py2dBcywUfYBDnxz78GRxtbcKUjKv3gmzWQ+fX2UelHEW6swK8mhZSYC8WktXN0fWNGyI7QsSOkgQyrR4GC9aCN3huCke1RNQXqD7K9WDv5IuGPOP1Ma2BqEkOCTi+lFJXxR5aCLOXrvhWQi1tNXfEQxO7aP8LTVtO3EmuYk/QZGRkwCj7Jh5K22XpmW7OAAB6gTo3ml/L+FT1CwDgrT8LisWMe+LzNT56sqoajZ1QT6snHl7p9UmHyhAEIIs4VEcl9Q/JCpA4kn69Tfv2SMWeWiUUxkP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 12:11:55.7148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e74399d6-0681-4e7a-ba84-08dea5e88193
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5508
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAA45C0009
X-Stat-Signature: 7eh678funyhhnfhodahcdi6udoidoii8
X-HE-Tag: 1777464723-646397
X-HE-Meta: U2FsdGVkX1+UVZG1Q272FukvwiN6YDxxLO5d/70qq9LqXG+CTNQVC+QVMqPbcD4U+gi/HGq5uTowp5IPKTnZsu9wPox68zidMcqK59E/EG2W1wyBtyM7cPpqcQ2K5xuSc5++Ek4WIFsteRFuEN1TgNOqoyV0LtWcbO7NTgI7Xpau3AMxzQvUx62aelQiUQJXs0uLjL/coC4ReyGSvMsaIXmUDt9dv5o4rhxJMQbUSiwqhR33u0GeveX1XCEEoS+I0uZvrX1VPB6X+BcBqnIslbP20xkcVFMwGJdK4Hhd2gVYQjUM/lXwbLf3F5yCR5kdCT9TuLjGU9nQ/Je4PHUmUpa+V4IQh5c4KWyRt5zv2H1IwqqxeeB+uR7qP/5IOO7Jd1S6EE5RDpCMM0A2QNLlrNT7sFMIlHDi29YtChtWGSrYNz9HwIK6LSG0Ksz9r9bqyxKFURBjwLtRUpYzcTqyZT0IUJBk0bbIEchiJWwlbeSOXxm3n0bBJdgZQNJYUFABna79VIYTb5MLAY+rBYgrI4Q3IDMR4xV8HiQ2ABUPJChMB3hhPqm75STMGma9HwZR8++2i+hIVot18oYiQxOne12oE5ewwc/KjsHWCHwCgo/zTXMHBGD27KDREX0aEvwcWbWHneZobgJYm4amj6BjO38GWNLhYiuMqY8czlUkZXvOBK+gqEtqx1OXGoDvh9rgSE87oLIe3j1aueoRADv0/UTO1kFzYNGQUylSSrZLE75kFZgOSdYt4cBABa1PqVmZJYGEahj3hYit5NK+IDKbHAq9lStZQSpOc/pwcFS6bUMOtOyDXklscevcvORo9YkmGIAPCCUSUstRAAVtv/oM+cKWgYqRO2KmnTiN59igjNTeTjnymnMklLiZv3QDKgDueGgnADpd/FXWKcSMhzYfqSFR7t0k6YEfJ3TyeDZrvpzsQqH3w8/EDk0m/FuUBoRrNzAmBz/M0UH9fluE7tR
 MeajyzQ7
 O77WQ105F2jlIGvmAoZXj8KUuw3sccZb1H1CYv6vIwRSB5jyBXIsx8x7GMj0gm4e/Wn01h8r/aoX7B6Ui/EiuUM7t4C+5C7bVa9L54maVwa4wyxsIVCMs8FDviuyTBEQ/tWvm86WvQYYW4SMzd71bGMLkCEdOyhTAmOw5VTYFl0z3HF7vLBqkwGf3ZKJztWH688coOiDIM1qSTrtbEw7sebivuT9IzYd4ts2Tm5+1Tnp1w7Sj4Xkj3byQji9S7vy737eu3DoWWNRxX4p7xxJcSn9D1MzmwkFZG3RQapw2rEOBEnAw0Bb50YvortEqtttQ4lgcQMmI5PTdd/QE5W1mjgooHPTNbuccpO5pKA1NS5Jx6gp9QG0aD/HIoSmOU8zq4uXJLrphb6HJzrXCmaHV9F8jma7tBrbUrdcJ8vBjnpDZMkM0736x3rxs/TnWuI2ObQETGEyRHH7lu+RViCZkf45bIlwXffVD5uwUgRhanCrZKata4+IEjp5UWLOGjcNsPR5CYZ+ZPQkFu77w8G8IjJ/sM2SQ2gNwn7y7vgh1nZZVzOuYdjTkelyaRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert uffd-stress test to use kselftest framework for reporting and
> tracking successful and failing runs.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I've run the test before and after applying the patch. The patch
correctly formats the output according to KTAP format with no change in
results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/uffd-stress.c | 41 +++++++++++-------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index 700fbaa18d44..e92a85463eb1 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -286,19 +286,12 @@ static int userfaultfd_stress(uffd_global_test_opts_t *gopts)
>  	pthread_attr_setstacksize(&attr, 16*1024*1024);
>  
>  	while (bounces--) {
> -		printf("bounces: %d, mode:", bounces);
> -		if (bounces & BOUNCE_RANDOM)
> -			printf(" rnd");
> -		if (bounces & BOUNCE_RACINGFAULTS)
> -			printf(" racing");
> -		if (bounces & BOUNCE_VERIFY)
> -			printf(" ver");
> -		if (bounces & BOUNCE_POLL)
> -			printf(" poll");
> -		else
> -			printf(" read");
> -		printf(", ");
> -		fflush(stdout);
> +		ksft_print_msg("bounces: %d, mode:%s%s%s%s, ",
> +			       bounces,
> +			       bounces & BOUNCE_RANDOM ? " rnd" : "",
> +			       bounces & BOUNCE_RACINGFAULTS ? " racing" : "",
> +			       bounces & BOUNCE_VERIFY ? " ver" : "",
> +			       bounces & BOUNCE_POLL ? " poll" : " read");
>  
>  		if (bounces & BOUNCE_POLL)
>  			fcntl(gopts->uffd, F_SETFL, gopts->uffd_flags | O_NONBLOCK);
> @@ -456,6 +449,9 @@ int main(int argc, char **argv)
>  	unsigned long nr_cpus;
>  	size_t bytes;
>  
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>  	gopts = (uffd_global_test_opts_t *) malloc(sizeof(uffd_global_test_opts_t));
>  
>  	if (argc < 4)
> @@ -484,10 +480,8 @@ int main(int argc, char **argv)
>  	 * for racy extra reservation of hugepages.
>  	 */
>  	if (gopts->test_type == TEST_HUGETLB &&
> -	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1) {
> -		printf("skip: Skipping userfaultfd... not enough hugepages\n");
> -		return KSFT_SKIP;
> -	}
> +	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
> +		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
>  
>  	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
>  	if (!gopts->nr_pages_per_cpu) {
> @@ -503,9 +497,12 @@ int main(int argc, char **argv)
>  	}
>  	gopts->nr_pages = gopts->nr_pages_per_cpu * gopts->nr_parallel;
>  
> -	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
> -	       gopts->nr_pages, gopts->nr_pages_per_cpu);
> -	return userfaultfd_stress(gopts);
> +	ksft_print_msg("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
> +		       gopts->nr_pages, gopts->nr_pages_per_cpu);
> +
> +	ksft_test_result(!userfaultfd_stress(gopts),
> +			 "uffd-stress %s\n", argv[1]);
> +	ksft_finished();
>  }
>  
>  #else /* __NR_userfaultfd */
> @@ -514,8 +511,8 @@ int main(int argc, char **argv)
>  
>  int main(void)
>  {
> -	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
> -	return KSFT_SKIP;
> +	ksft_print_header();
> +	ksft_exit_skip("missing __NR_userfaultfd definition\n");
>  }
>  
>  #endif /* __NR_userfaultfd */



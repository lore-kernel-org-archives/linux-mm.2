Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F96FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40AB26B0088; Tue, 28 Apr 2026 09:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB5F6B008A; Tue, 28 Apr 2026 09:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C4F6B008C; Tue, 28 Apr 2026 09:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8156B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:07:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1971A0138
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:07:16 +0000 (UTC)
X-FDA: 84707990472.07.DC1C8DD
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013011.outbound.protection.outlook.com [40.107.162.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41897140014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:07:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="H0J6w/cB";
	dkim=pass header.d=arm.com header.s=selector1 header.b="H0J6w/cB";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.11 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJ6oKewEErqIU4xRunh+a3GtDz+FRCzkGWrgYFrlVjg=;
	b=U7lNmALi9uhZdaER5CJJoiLJi6t3DEMna0us6NSSzSVRiZeGTNpr8pAeVL1hqSQTeg/5F0
	s4E3q5aKKRaM1aG3siN/KFoRgQJ5K621ZbHkeJY8ohJxoebGtR6PwcNjxFt2+pmOdeE8uk
	Q7JKQJhxcsKDKfFQDulWItoX8CJNdd0=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777381632; a=rsa-sha256;
	cv=pass;
	b=Gxi0Loh/OtBpT0iHtpdZtWTv5xXW4ZBuoNiR0J1J7LvNCdPQa0p3AxtgdOGCyRP/L65ACS
	DNot2YZvE3fm5tluwIlB9Fmfo9aZCWtH1ygfmejJ9P4IwOVA5BI7PtnhO3vGbhequL/iT/
	HTMYGCDyUNCl0AEjIom/Bv+WhBZXzf4=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="H0J6w/cB";
	dkim=pass header.d=arm.com header.s=selector1 header.b="H0J6w/cB";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.11 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KQP9yXuNkVq7L8KkYwVv2P974QhWn0auFWQyUT8v/Vn7IwVtmULlrZlUS/L65PAoe9XizkbgEJ5lEilAu3dVRGQyi4gJCIVt0fkOcW/m2IDRFSXtkixCiOYyd+dBP2O4t0vfcunheB/Y1ECO29GfWHx5Az9V8BWbEwH1kTQS0DktLVQTtjSIEjo7BIYualJILHbIp6a1oCCUVGN8XnTgGD+8NjVEBKbnUvoydgHnehnA7SnFc1mBvuSDo+c6gMjP9P0HkWuzBlio9R250NXg0VKCwS9g1PWVdBKDfUHHxC7Bh3l3JyGNywHHyZ/AADn/dWNZf10bWw0So0FAWrScyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJ6oKewEErqIU4xRunh+a3GtDz+FRCzkGWrgYFrlVjg=;
 b=kTU6bUg1vhVukuucqcdaT8K0k6hyDFLHgmMW71dykMZ/aEjXJlEhJ2gZSlX4rOLKXY0Cygs2akvtMcTsJTHWMPGxTCE4ZnUMwXxpKgbuopQqai795ryPyGXKoOuKH3JzbEWmYZAuz3WBgyT9raJeCDvPVwWdy37dgor+YW/wevUdTEI7Dh+lhRfNfUcQl7KQLNQD2m7JRi5yYdSQg9gVKHrqiA0vxV4PmyNleew2QBx5JlJVy38zmXusTgf/PjfGMKxe0thNZOTANKJ5Uuf8aSa5MFLpkEioPbdHsDxvmQLJ7hcLA1rP0bBPnKSdUC0YjhkJ/zrxphEdeUD1mRJDNA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ6oKewEErqIU4xRunh+a3GtDz+FRCzkGWrgYFrlVjg=;
 b=H0J6w/cBXkekK1+pjckLQULzi6pgXKPy1n2N+4skZ54erOXVe5akd7zs15xxE/P+8OrWEzeqoOU6Z2/tT4ejO3y2/PwGZwf8ZmTtXvYPDj5F2AeirLbZ4h2YK0EPyopIEbXqpHXaIVGJFMY54IRRAsdHltv+8Qu4OblFYE1deLg=
Received: from AS8P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::25)
 by AS8PR08MB8921.eurprd08.prod.outlook.com (2603:10a6:20b:5b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 13:07:02 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:330:cafe::65) by AS8P250CA0020.outlook.office365.com
 (2603:10a6:20b:330::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 13:07:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Tue, 28 Apr 2026 13:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KykH+SHISG3XSHPeD3ke1p64AC3+A9vHqj4uEh+afRMg5DPMAZ/sUVHAkA+o0o5B59e9E0CLrh9kkRLwzQKKzNnOzxMtXBYiYui2mrmM0F4AHkKw86ybMbqOanHT461881UfwfRorpb6P29o16EboEg7+su3e/QTvAg5ngIkGxi6KbjMrsY5PpTwf1uMifqoGleBPWixF/BO2OgN3Yg1x+KthYaY0cxRw4c/0VSzQuh4mvP9VVl4H61UsDr5iLH70rIkTBs2vGo2D05QQVKL4eU9L/45W0/BzKv7akl4zcJNFuMhscp1dOFNX3gufWLgPJ+7nInQFInDMapv1k2f1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJ6oKewEErqIU4xRunh+a3GtDz+FRCzkGWrgYFrlVjg=;
 b=q2Se7SWPlT18bx37nfmlPeDQmU8+R8+TOq6IoY1e68Bfy734K9qVbvxUW47LWbEXda4fiJoGIzrp90Nmw+4AtjBciVFB+tHJOO/S38j9t+qgPmldYHCo5F80/E0qTDorMzuKnygNWm15jFeRSfGwbnGZx1cK9EWs5aqpBHHzfKPZQSlNIolqlO/8OXNvW3Ioh5oi+8viB6BsayoL/6r3Z+faNzf+tTtcKGNQFwN6jNGIMujWADRa3IlY5ZcST9hPx4Z4tNTwMG6LR0viQT+m/3RZHmg3yoTKIwL2sgDDXeXSpru2fdJWRVno+uiEaQMTl3c8rQmejbeUdJwCWN9RGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJ6oKewEErqIU4xRunh+a3GtDz+FRCzkGWrgYFrlVjg=;
 b=H0J6w/cBXkekK1+pjckLQULzi6pgXKPy1n2N+4skZ54erOXVe5akd7zs15xxE/P+8OrWEzeqoOU6Z2/tT4ejO3y2/PwGZwf8ZmTtXvYPDj5F2AeirLbZ4h2YK0EPyopIEbXqpHXaIVGJFMY54IRRAsdHltv+8Qu4OblFYE1deLg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM0PR08MB11701.eurprd08.prod.outlook.com (2603:10a6:20b:73e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 13:05:59 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 13:05:59 +0000
Message-ID: <231d0f73-ed99-4c7c-879d-3a2223945b21@arm.com>
Date: Tue, 28 Apr 2026 18:35:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/53] selftests/mm: khugepaged: use ksefltest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-14-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-14-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0177.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a9::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM0PR08MB11701:EE_|AM3PEPF0000A79A:EE_|AS8PR08MB8921:EE_
X-MS-Office365-Filtering-Correlation-Id: ba136a3f-ea2c-42f6-be09-08dea5270a3a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003|17002099007;
X-Microsoft-Antispam-Message-Info-Original:
 tzr/0yQ8nFL6R6jrQStTeJhYdfgiF8GfZyZT3Z+QQaSYdO5T8OBFvTp4TYFZu82Emei4sY+UigeU2PYD6VBT10EVSEtdBWynKc57DWGY+8RCLnuWmqc7weDof+GrS2OIQiINVIMpdvw0e9HFX3aN4YKBpwWDfVLqZLKDd8XK4ZbnegZCLsOhgPrdeCzZBLN0GxpGKrtxN2EqkO5sbRa2kpuFL1lq5bwtPeKUmFM7wmZpS0sNkHc9yPDyOWTaNRNXxpZNciQSwjH9VKfRz0LHqtCdrLvCEGBs+1GlS8N6a2rOfrI4XywPdPJb8bDUlAVQl5ys1iJUCm21SVja7n2YkY/6yw4KndMSiMHaYfJdieHMvGQ8h+5RRxeXTA3n99Ed5hkGWQhQXqdUDqlTjaSowKMdxlfsExL0JCXfS4f10aUHcfOEet87Oc/G2Se2KA2VSY8NbI+nIXdjwapD+40u2TvYoI08jrXDw0dAA8cXbD9G6Q8/ttmB9JQ7hE1C1q3KpC2d5xaTbFp76BGDtHbQCsI87NyHDkf6+2/JcO6QZ8zJUf4r4sBRf/CBsn4nAvi1ot3o86K8GYnBYQV98wHHb/2q4WNnb4WTDYXKuSj4f7eDHvtDiARoMC2JGZWwkP/dL+lYp/al7E1f/2yTPv13n62kXPYWGdExE1dG7cY1sIB/tYaEK6C51i7nJHBL2dwP/vc5c3Ttf9dX5vt0lag4iWhAnAUzvviBOApLo4sR54w=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003)(17002099007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 mTGGKZ3lNlRSE4RqnarHODJQ9nB3EmBHo+64AAVzWU3xGe0rKflAIQLHpTx7GfzjrwZrlH/Q8Gds6zY/xOZdcK9Xy6C3UtDbwicT3I4fqSdNDSveNNg2AOUIY96BoRTFDkve7mwWBcfX2PdXQHAGf9oZTCqIrVepXsIMXOtvld4yTIc7jZ4uFed1wFSz73UAzzhwPRSY5sqVvDctFJiDsO+gGNpqxcNm9+Wm/GVkq64sgLG+D2J0xgj9qANa/HO5RWob93oHOwiApcAthNjlkBEY9BUD/a/NLWTcp/0ffm9xyHy9TQuKCynbjZij2rZlV4xksLbkGoPkvBxLdNRK1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11701
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	290fc20a-673d-476a-5ff1-08dea526e45b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|14060799003|36860700016|1800799024|35042699022|82310400026|17002099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ullpp3VpG+EqdVGY8pDPqNnQiSGp2Yvlj+NYuhww/P9f/fMYJmd8TM3+Zc1RThtQFGYvu7DK++5Fubol12E1J333xOmBVmvsR56rFiFM2B7DqPBedhPUcUFRAUMLV6B98h2KHU33y5P228dBzsJ0rbLPpfls40JOyf7k8IzvYo185jJMXnRRnig0P+mlJLIESO66DATCo0e0BlbtaBXiLUmlQ1vGzpzOw3BZoLR41xkc5p4KMIA2eCTSgJuqlC9aNi6PojCsUNvs17cz06OX95w/rG8TVJJPhdgAj2hT5tf8yQSW7oShIUvsp3MONl1kFF2GIpFjkPffLe8XhXT8R7x0GYJMCJc6K+Vx81uKX6mcmoFL6rYOdon8aB9NrEmduiBkSAKsSv+L11ju30xyE2l3lAljazaNMLlK0Nw3qJmkyOKn4w+gkfRxnI/ku8hU3GM8DhU07V+htKwNz6ICjGhKQuMKBKfTjM0apQUVp4sgqlkXc9Ic7SiMI3LDWFwuipNwUIAr1J1I5puDg4KBsvCDmz3JifbjFK2Hx8S94VLRB5grrIUg63HKaJ7C3RzoXHQjyXceFI0PRvzkegkFFWkTpvuzDYHTaza0ItPIj2pspS93lp7KozsIPx1gFFYqA+8nZuVaYLWAN//LxsJSeR7fpb8zdx9sBOyw5ILLz6QR1odJGDJmC9+4AnIwj3t8SU8HUhDeuuGr5FkOSayS8QZtWACFfN1e1EyFau5L/8rUP9RleNDmN0a73Q3RALWxQ0kBKisCHqfTmjzEjkMvPQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(14060799003)(36860700016)(1800799024)(35042699022)(82310400026)(17002099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wfCufusKUW6pGjrwA6lQlrWGVwp8g67GvAleDXKswPZQm2fMNAP1qTZxoWFU4ulHNPm7WVlI+bBQk4v4p3wehTc2mGcGZrOujg+T84YwQptCLF6Vue54ZvyOTcab51h0E8gppm6kVywTfbxK74o93QxMRQfa+CIojb2nOiXw7NI5X2ZcLcbmcE9zJu3UNTEob3/HB4bldUaf/dLRbdWpmby5UQHbCxIwPqcWIguvy54kOYgYzGfQOiRQHMBxGVJBCfAyCI7D3kVDlMH59ACAfFSWzgm1Qo2aAAPL2M5y8QVH54qxrFGj9eSKBVJMw4fffvGgIGbxp8ppr1wcUuTD2eEvpCd3y2umFlwqK+Po5WjJWe+BsD1QGQMWids6VYEOStwthVnM6RHiBYmnegsyNn281x7PmRIJkI2JoQs7uVsPM9Q34LSjAGVAEqsmQyFO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 13:07:02.6049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba136a3f-ea2c-42f6-be09-08dea5270a3a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8921
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41897140014
X-Stat-Signature: fz3n5saqefc47eh51jpx367s78trt3sc
X-Rspam-User: 
X-HE-Tag: 1777381631-630795
X-HE-Meta: U2FsdGVkX1+9vDNjEsDpWYCa6PXtiEOC7AqUyE+zyoR/TbpiyAeC+Y+N5rOnCjv78K/ETjKvu8O0GNxC5JaVzgxGteMkYYmtgLjF2vE6awECc8318SbL87Gj/mjhhgOGhKphwL3F+IE+A4Rjh9FSnUG6Kb1lwvIrmW0fjutHzqPNCl6/c9sA5hoZzRy5Cx68mCc/nuaKb7sMlNM+Z/7Gnxci7X1RyQwVbSIQ5Uk4N0cbGgO+2JnARoiGwK8wfRlTHwsYzWDDDnA1vqD9JqIUKD1mIKOv6iOpxFHTvuciyyB2X5F05ugzI9zrJRMAQWwGCDPRsqCwew7X6xlk//jFj3rAabdU6XnWy2DHQGoaQR/KUgYX7AQLJWNqIkyKFiGEsQ5sOipHUtOotXpQU7/dIwnnvQiTE3jzGVfb9f5hIltmGOp0qwBjM3fLJ9i0xsQd6WmMgwfFqgjhS8rJwJSdSSJ0YbVcINIG6FuVSwzHlgghlyfS4kYzruNrzy3zD7qOSU2ENXZanivrchx0Fd4AIgIM6piviVY5ZUx/ypRvcdBrheYscDSMDjxhOIladhTGkJWZqJLCj9kGzMIHxkC0WQn8KhVmFvWYxNBDQJUELXilOEO09d9yYTiFAvPWLNvivSwI0p9JNxjEZvnSQWAIF98/gaTeQi4iV9EILWgpWooP1gOw8Sj4ogwX2zKitJxjMDx+GHVtx/Jja5JNJR3Kv+Ak9abdlJeVAMzD2xh6s0jwHg+f/h+xEtpbMCvpHXFCjD4dd8hPvqtXNs6jdGxHN46hLbpI/6NV+C2sI0ohXEsF22TI9BKGGHFw5bJRHJfkDADq751ZML1nZ5Vnv8Y0QZoFTZDXB0Oqn+LSRtLr0f57eqPHQWzyOg/7AlV1FYjSZ9bzJZIJxeZEnpE9NOFKONJO9Vqr8zv3vyKVx4o4XmNVD7dYH6lXEOFBeFIovCmBe5BTFU9kpBY2Ss6gNY+
 V0b+BWI0
 jUK8Upmjkov4xFCs9hpJ+YDeqUSkHrtm3HKpvpOFp4kZoWpZRHisSQk71kLh1QUrxU0AEq+Btrd4UWpWRVVn2eWIqztY1hFcfb9N6vuAq6LbZOLElLwyQeDxjUXgF5SH0es6AgfIILoD7IrIxCy3nSTsElXD0MAlgrjYKoxnIn2G8AMXb3hbg8mRLLhAliNBrPH/iumfDy6tINcfPxoWY0q+WysjM7op+rHcltLPVagrCwb0U7TRIsUcTnD7t+83HQynxAZPDvfR+skTwKPY6mRTpqLeV1aaX4yaufKNph8gjTXz2QTg4Z9cO9Ua7aV5BeePHcbYlcrfvftCpCXJUtbhwyq8qltfJkAY6ERszttFVsSP54/74zO8uAKncWL3Gbb6ICgYYl7NMuwc/Jq4jkjVHsDqi0V58Oe5laRlEVmN+UHkPnwEkGKHVaPwoi3wSUivtjwy9WYcezzW3/mQSpeFr346aNuJRhzWiC5WcB0tz4tn+jbzBJb3RrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert khugepaged tests to use kselftest framework for reporting and
> tracking successful and failing runs.
> 
> The conversion is mostly about replacing printf()/perror() + exit() pairs
> with their ksft_ counterparts.
> 
> The nice colored success and failure indications are left intact.
> 
> Replace the progress report in collapse_compound_extreme() with a single
> ksft_print_msg() to avoid headache with formatting and make the test output
> more concise.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 311 ++++++++++--------------
>  1 file changed, 128 insertions(+), 183 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 56494eea5ab3..da365f850365 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -83,12 +83,13 @@ static void success(const char *msg)
>  static void fail(const char *msg)
>  {
>  	printf(" \e[31m%s\e[0m\n", msg);
> -	exit_status++;
> +	exit_status = KSFT_FAIL;
>  }
>  
>  static void skip(const char *msg)
>  {
>  	printf(" \e[33m%s\e[0m\n", msg);
> +	exit_status = KSFT_SKIP;
>  }
>  
>  static void restore_settings_atexit(void)
> @@ -96,22 +97,23 @@ static void restore_settings_atexit(void)
>  	if (skip_settings_restore)
>  		return;
>  
> -	printf("Restore THP and khugepaged settings...");
> +	ksft_print_msg("Restore THP and khugepaged settings...");
>  	thp_restore_settings();
>  	success("OK");
>  
>  	skip_settings_restore = true;
> +	ksft_finished();
>  }
>  
>  static void restore_settings(int sig)
>  {
>  	/* exit() will invoke the restore_settings_atexit handler. */
> -	exit(sig ? EXIT_FAILURE : exit_status);
> +	exit(sig ? KSFT_FAIL : exit_status);
>  }
>  
>  static void save_settings(void)
>  {
> -	printf("Save THP and khugepaged settings...");
> +	ksft_print_msg("Save THP and khugepaged settings...");
>  	if (file_ops && finfo.type == VMA_FILE)
>  		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>  	thp_save_settings();
> @@ -135,19 +137,13 @@ static void get_finfo(const char *dir)
>  
>  	finfo.dir = dir;
>  	stat(finfo.dir, &path_stat);
> -	if (!S_ISDIR(path_stat.st_mode)) {
> -		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!S_ISDIR(path_stat.st_mode))
> +		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
>  	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
> -		     finfo.dir) >= sizeof(finfo.path)) {
> -		printf("%s: Pathname is too long\n", __func__);
> -		exit(EXIT_FAILURE);
> -	}
> -	if (statfs(finfo.dir, &fs)) {
> -		perror("statfs()");
> -		exit(EXIT_FAILURE);
> -	}
> +		     finfo.dir) >= sizeof(finfo.path))
> +		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
> +	if (statfs(finfo.dir, &fs))
> +		ksft_exit_fail_perror("statfs()");
>  	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
>  	if (finfo.type == VMA_SHMEM)
>  		return;
> @@ -155,40 +151,30 @@ static void get_finfo(const char *dir)
>  	/* Find owning device's queue/read_ahead_kb control */
>  	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
>  		     major(path_stat.st_dev), minor(path_stat.st_dev))
> -	    >= sizeof(path)) {
> -		printf("%s: Pathname is too long\n", __func__);
> -		exit(EXIT_FAILURE);
> -	}
> -	if (read_file(path, buf, sizeof(buf)) < 0) {
> -		perror("read_file(read_num)");
> -		exit(EXIT_FAILURE);
> -	}
> +	    >= sizeof(path))
> +		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
> +	if (read_file(path, buf, sizeof(buf)) < 0)
> +		ksft_exit_fail_perror("read_file(read_num)");
>  	if (strstr(buf, "DEVTYPE=disk")) {
>  		/* Found it */
>  		if (snprintf(finfo.dev_queue_read_ahead_path,
>  			     sizeof(finfo.dev_queue_read_ahead_path),
>  			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
>  			     major(path_stat.st_dev), minor(path_stat.st_dev))
> -		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
> -			printf("%s: Pathname is too long\n", __func__);
> -			exit(EXIT_FAILURE);
> -		}
> +		    >= sizeof(finfo.dev_queue_read_ahead_path))
> +			ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
>  		return;
>  	}
> -	if (!strstr(buf, "DEVTYPE=partition")) {
> -		printf("%s: Unknown device type: %s\n", __func__, path);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!strstr(buf, "DEVTYPE=partition"))
> +		ksft_exit_fail_msg("%s: Unknown device type: %s\n", __func__, path);
>  	/*
>  	 * Partition of block device - need to find actual device.
>  	 * Using naming convention that devnameN is partition of
>  	 * device devname.
>  	 */
>  	str = strstr(buf, "DEVNAME=");
> -	if (!str) {
> -		printf("%s: Could not read: %s", __func__, path);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!str)
> +		ksft_exit_fail_msg("%s: Could not read: %s", __func__, path);
>  	str += 8;
>  	end = str;
>  	while (*end) {
> @@ -197,16 +183,13 @@ static void get_finfo(const char *dir)
>  			if (snprintf(finfo.dev_queue_read_ahead_path,
>  				     sizeof(finfo.dev_queue_read_ahead_path),
>  				     "/sys/block/%s/queue/read_ahead_kb",
> -				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
> -				printf("%s: Pathname is too long\n", __func__);
> -				exit(EXIT_FAILURE);
> -			}
> +				     str) >= sizeof(finfo.dev_queue_read_ahead_path))
> +				ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
>  			return;
>  		}
>  		++end;
>  	}
> -	printf("%s: Could not read: %s\n", __func__, path);
> -	exit(EXIT_FAILURE);
> +	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
>  }
>  
>  static bool check_swap(void *addr, unsigned long size)
> @@ -219,26 +202,19 @@ static bool check_swap(void *addr, unsigned long size)
>  
>  	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
>  		       (unsigned long) addr);
> -	if (ret >= MAX_LINE_LENGTH) {
> -		printf("%s: Pattern is too long\n", __func__);
> -		exit(EXIT_FAILURE);
> -	}
> -
> +	if (ret >= MAX_LINE_LENGTH)
> +		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
>  
>  	fp = fopen(PID_SMAPS, "r");
> -	if (!fp) {
> -		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!fp)
> +		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, PID_SMAPS);
>  	if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
>  		goto err_out;
>  
>  	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
>  		       size >> 10);
> -	if (ret >= MAX_LINE_LENGTH) {
> -		printf("%s: Pattern is too long\n", __func__);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (ret >= MAX_LINE_LENGTH)
> +		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
>  	/*
>  	 * Fetch the Swap: in the same block and check whether it got
>  	 * the expected number of hugeepages next.
> @@ -261,10 +237,8 @@ static void *alloc_mapping(int nr)
>  
>  	p = mmap(BASE_ADDR, nr * hpage_pmd_size, PROT_READ | PROT_WRITE,
>  		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> -	if (p != BASE_ADDR) {
> -		printf("Failed to allocate VMA at %p\n", BASE_ADDR);
> -		exit(EXIT_FAILURE);
> -	}
> +	if (p != BASE_ADDR)
> +		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
>  
>  	return p;
>  }
> @@ -314,19 +288,13 @@ static void *alloc_hpage(struct mem_ops *ops)
>  	 * khugepaged on low-load system (like a test machine), which
>  	 * would cause MADV_COLLAPSE to fail with EAGAIN.
>  	 */
> -	printf("Allocate huge page...");
> -	if (madvise_collapse_retry(p, hpage_pmd_size)) {
> -		perror("madvise(MADV_COLLAPSE)");
> -		exit(EXIT_FAILURE);
> -	}
> -	if (!ops->check_huge(p, 1)) {
> -		perror("madvise(MADV_COLLAPSE)");
> -		exit(EXIT_FAILURE);
> -	}
> -	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE)) {
> -		perror("madvise(MADV_HUGEPAGE)");
> -		exit(EXIT_FAILURE);
> -	}
> +	ksft_print_msg("Allocate huge page...");
> +	if (madvise_collapse_retry(p, hpage_pmd_size))
> +		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
> +	if (!ops->check_huge(p, 1))
> +		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
> +	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
>  	success("OK");
>  	return p;
>  }
> @@ -336,11 +304,9 @@ static void validate_memory(int *p, unsigned long start, unsigned long end)
>  	int i;
>  
>  	for (i = start / page_size; i < end / page_size; i++) {
> -		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
> -			printf("Page %d is corrupted: %#x\n",
> -					i, p[i * page_size / sizeof(*p)]);
> -			exit(EXIT_FAILURE);
> -		}
> +		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000)
> +			ksft_exit_fail_msg("Page %d is corrupted: %#x\n",
> +					   i, p[i * page_size / sizeof(*p)]);
>  	}
>  }
>  
> @@ -371,14 +337,12 @@ static void *file_setup_area(int nr_hpages)
>  	unsigned long size;
>  
>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
> -	printf("Creating %s for collapse%s...", finfo.path,
> -	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
> +	ksft_print_msg("Creating %s for collapse%s...", finfo.path,
> +		       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
>  	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
>  		  777);
> -	if (fd < 0) {
> -		perror("open()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (fd < 0)
> +		ksft_exit_fail_perror("open()");
>  
>  	size = nr_hpages * hpage_pmd_size;
>  	p = alloc_mapping(nr_hpages);
> @@ -388,18 +352,14 @@ static void *file_setup_area(int nr_hpages)
>  	munmap(p, size);
>  	success("OK");
>  
> -	printf("Opening %s read only for collapse...", finfo.path);
> +	ksft_print_msg("Opening %s read only for collapse...", finfo.path);
>  	finfo.fd = open(finfo.path, O_RDONLY, 777);
> -	if (finfo.fd < 0) {
> -		perror("open()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (finfo.fd < 0)
> +		ksft_exit_fail_perror("open()");
>  	p = mmap(BASE_ADDR, size, PROT_READ,
>  		 MAP_PRIVATE, finfo.fd, 0);
> -	if (p == MAP_FAILED || p != BASE_ADDR) {
> -		perror("mmap()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (p == MAP_FAILED || p != BASE_ADDR)
> +		ksft_exit_fail_perror("mmap()");
>  
>  	/* Drop page cache */
>  	write_file("/proc/sys/vm/drop_caches", "3", 2);
> @@ -416,10 +376,8 @@ static void file_cleanup_area(void *p, unsigned long size)
>  
>  static void file_fault(void *p, unsigned long start, unsigned long end)
>  {
> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
> -		perror("madvise(MADV_POPULATE_READ");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ))
> +		ksft_exit_fail_perror("madvise(MADV_POPULATE_READ");
>  }
>  
>  static bool file_check_huge(void *addr, int nr_hpages)
> @@ -441,20 +399,14 @@ static void *shmem_setup_area(int nr_hpages)
>  	unsigned long size = nr_hpages * hpage_pmd_size;
>  
>  	finfo.fd = memfd_create("khugepaged-selftest-collapse-shmem", 0);
> -	if (finfo.fd < 0)  {
> -		perror("memfd_create()");
> -		exit(EXIT_FAILURE);
> -	}
> -	if (ftruncate(finfo.fd, size)) {
> -		perror("ftruncate()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (finfo.fd < 0)
> +		ksft_exit_fail_perror("memfd_create()");
> +	if (ftruncate(finfo.fd, size))
> +		ksft_exit_fail_perror("ftruncate()");
>  	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, finfo.fd,
>  		 0);
> -	if (p != BASE_ADDR) {
> -		perror("mmap()");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (p != BASE_ADDR)
> +		ksft_exit_fail_perror("mmap()");
>  	return p;
>  }
>  
> @@ -499,7 +451,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  	int ret;
>  	struct thp_settings settings = *thp_current_settings();
>  
> -	printf("%s...", msg);
> +	ksft_print_msg("%s...", msg);
>  
>  	/*
>  	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
> @@ -526,10 +478,8 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			     struct mem_ops *ops, bool expect)
>  {
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0)) {
> -		printf("Unexpected huge page\n");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!ops->check_huge(p, 0))
> +		ksft_exit_fail_msg("Unexpected huge page\n");
>  	__madvise_collapse(msg, p, nr_hpages, ops, expect);
>  }
>  
> @@ -541,17 +491,15 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>  	int timeout = 6; /* 3 seconds */
>  
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0)) {
> -		printf("Unexpected huge page\n");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!ops->check_huge(p, 0))
> +		ksft_exit_fail_msg("Unexpected huge page\n");
>  
>  	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
>  
>  	/* Wait until the second full_scan completed */
>  	full_scans = thp_read_num("khugepaged/full_scans") + 2;
>  
> -	printf("%s...", msg);
> +	ksft_print_msg("%s...", msg);
>  	while (timeout--) {
>  		if (ops->check_huge(p, nr_hpages))
>  			break;
> @@ -621,7 +569,7 @@ static void alloc_at_fault(void)
>  
>  	p = alloc_mapping(1);
>  	*p = 1;
> -	printf("Allocate huge page on fault...");
> +	ksft_print_msg("Allocate huge page on fault...");
>  	if (check_huge_anon(p, 1, hpage_pmd_size))
>  		success("OK");
>  	else
> @@ -630,12 +578,14 @@ static void alloc_at_fault(void)
>  	thp_pop_settings();
>  
>  	madvise(p, page_size, MADV_DONTNEED);
> -	printf("Split huge PMD on MADV_DONTNEED...");
> +	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
>  	if (check_huge_anon(p, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
>  	munmap(p, hpage_pmd_size);
> +
> +	ksft_test_result_report(exit_status, "allocate on fault and split\n");
>  }
>  
>  static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
> @@ -650,6 +600,8 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
>  		    ops, true);
>  	validate_memory(p, 0, size);
>  	ops->cleanup_area(p, size);
> +
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
> @@ -659,6 +611,7 @@ static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
>  	p = ops->setup_area(1);
>  	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops *ops)
> @@ -670,6 +623,7 @@ static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops
>  	c->collapse("Collapse PTE table with single PTE entry present", p,
>  		    1, ops, true);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *ops)
> @@ -706,6 +660,7 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
>  skip:
>  	ops->cleanup_area(p, hpage_pmd_size);
>  	thp_pop_settings();
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_ops *ops)
> @@ -715,11 +670,9 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	printf("Swapout one page...");
> -	if (madvise(p, page_size, MADV_PAGEOUT)) {
> -		perror("madvise(MADV_PAGEOUT)");
> -		exit(EXIT_FAILURE);
> -	}
> +	ksft_print_msg("Swapout one page...");
> +	if (madvise(p, page_size, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>  	if (check_swap(p, page_size)) {
>  		success("OK");
>  	} else {
> @@ -732,6 +685,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  	validate_memory(p, 0, hpage_pmd_size);
>  out:
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
> @@ -742,11 +696,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	printf("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
> -	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT)) {
> -		perror("madvise(MADV_PAGEOUT)");
> -		exit(EXIT_FAILURE);
> -	}
> +	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
> +	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>  	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
>  		success("OK");
>  	} else {
> @@ -760,12 +712,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  
>  	if (c->enforce_pte_scan_limits) {
>  		ops->fault(p, 0, hpage_pmd_size);
> -		printf("Swapout %d of %d pages...", max_ptes_swap,
> +		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
>  		       hpage_pmd_nr);
> -		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
> -			perror("madvise(MADV_PAGEOUT)");
> -			exit(EXIT_FAILURE);
> -		}
> +		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>  		if (check_swap(p, max_ptes_swap * page_size)) {
>  			success("OK");
>  		} else {
> @@ -779,6 +729,7 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	}
>  out:
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
> @@ -792,7 +743,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
>  		advise = MADV_REMOVE;
>  
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> -	printf("Split huge page leaving single PTE mapping compound page...");
> +	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
>  	madvise(p + page_size, hpage_pmd_size - page_size, advise);
>  	if (ops->check_huge(p, 0))
>  		success("OK");
> @@ -803,6 +754,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
>  		    p, 1, ops, true);
>  	validate_memory(p, 0, page_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops *ops)
> @@ -810,7 +762,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
>  	void *p;
>  
>  	p = alloc_hpage(ops);
> -	printf("Split huge page leaving single PTE page table full of compound pages...");
> +	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
>  	madvise(p, page_size, MADV_NOHUGEPAGE);
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
>  	if (ops->check_huge(p, 0))
> @@ -822,6 +774,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
>  		    true);
>  	validate_memory(p, 0, hpage_pmd_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops *ops)
> @@ -830,16 +783,12 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  	int i;
>  
>  	p = ops->setup_area(1);
> +	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pagesd\n");

A small typo here, "pagesd" should be "pages".

>  	for (i = 0; i < hpage_pmd_nr; i++) {
> -		printf("\rConstruct PTE page table full of different PTE-mapped compound pages %3d/%d...",
> -				i + 1, hpage_pmd_nr);
> -
>  		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
>  		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
> -		if (!ops->check_huge(BASE_ADDR, 1)) {
> -			printf("Failed to allocate huge page\n");
> -			exit(EXIT_FAILURE);
> -		}
> +		if (!ops->check_huge(BASE_ADDR, 1))
> +			ksft_exit_fail_msg("Failed to allocate huge page\n");

In case we are not able to allocate a hugepage at fault, should this be
reported as a per-test failure instead of bailing out the whole binary
with ksft_exit_fail_msg()? In alloc_at_fault(), a failure to allocate a
hugepage is reported as a normal test result via
ksft_test_result_report(), so should this case behave similarly or is it
intentionally treated as fatal? I realize it was being treated as fatal
before this patch as well, but just wanted to check whether that is
necessary.

Also, when ksft_exit_fail_msg() is called, totals are printed twice:
once from ksft_exit_fail_msg() itself, and then again when exit() runs
the restore_settings_atexit handler.

>  		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
>  
>  		p = mremap(BASE_ADDR - i * page_size,
> @@ -847,20 +796,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  				(i + 1) * page_size,
>  				MREMAP_MAYMOVE | MREMAP_FIXED,
>  				BASE_ADDR + 2 * hpage_pmd_size);
> -		if (p == MAP_FAILED) {
> -			perror("mremap+unmap");
> -			exit(EXIT_FAILURE);
> -		}
> +		if (p == MAP_FAILED)
> +			ksft_exit_fail_perror("mremap+unmap");
>  
>  		p = mremap(BASE_ADDR + 2 * hpage_pmd_size,
>  				(i + 1) * page_size,
>  				(i + 1) * page_size + hpage_pmd_size,
>  				MREMAP_MAYMOVE | MREMAP_FIXED,
>  				BASE_ADDR - (i + 1) * page_size);
> -		if (p == MAP_FAILED) {
> -			perror("mremap+alloc");
> -			exit(EXIT_FAILURE);
> -		}
> +		if (p == MAP_FAILED)
> +			ksft_exit_fail_perror("mremap+alloc");
>  	}
>  
>  	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
> @@ -875,6 +820,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  
>  	validate_memory(p, 0, hpage_pmd_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
> @@ -884,18 +830,17 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  
>  	p = ops->setup_area(1);
>  
> -	printf("Allocate small page...");
> +	ksft_print_msg("Allocate small page...");
>  	ops->fault(p, 0, page_size);
>  	if (ops->check_huge(p, 0))
>  		success("OK");
>  	else
>  		fail("Fail");
>  
> -	printf("Share small page over fork()...");
> +	ksft_print_msg("Share small page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
>  		skip_settings_restore = true;
> -		exit_status = 0;
>  
>  		if (ops->check_huge(p, 0))
>  			success("OK");
> @@ -912,15 +857,16 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  	}
>  
>  	wait(&wstatus);
> -	exit_status += WEXITSTATUS(wstatus);
> +	exit_status = WEXITSTATUS(wstatus);
>  
> -	printf("Check if parent still has small page...");
> +	ksft_print_msg("Check if parent still has small page...");
>  	if (ops->check_huge(p, 0))
>  		success("OK");
>  	else
>  		fail("Fail");
>  	validate_memory(p, 0, page_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
> @@ -929,18 +875,17 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  	void *p;
>  
>  	p = alloc_hpage(ops);
> -	printf("Share huge page over fork()...");
> +	ksft_print_msg("Share huge page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
>  		skip_settings_restore = true;
> -		exit_status = 0;
>  
>  		if (ops->check_huge(p, 1))
>  			success("OK");
>  		else
>  			fail("Fail");
>  
> -		printf("Split huge page PMD in child process...");
> +		ksft_print_msg("Split huge page PMD in child process...");
>  		madvise(p, page_size, MADV_NOHUGEPAGE);
>  		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
>  		if (ops->check_huge(p, 0))
> @@ -961,15 +906,16 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  	}
>  
>  	wait(&wstatus);
> -	exit_status += WEXITSTATUS(wstatus);
> +	exit_status = WEXITSTATUS(wstatus);
>  
> -	printf("Check if parent still has huge page...");
> +	ksft_print_msg("Check if parent still has huge page...");
>  	if (ops->check_huge(p, 1))
>  		success("OK");
>  	else
>  		fail("Fail");
>  	validate_memory(p, 0, hpage_pmd_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
> @@ -979,18 +925,17 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  	void *p;
>  
>  	p = alloc_hpage(ops);
> -	printf("Share huge page over fork()...");
> +	ksft_print_msg("Share huge page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
>  		skip_settings_restore = true;
> -		exit_status = 0;
>  
>  		if (ops->check_huge(p, 1))
>  			success("OK");
>  		else
>  			fail("Fail");
>  
> -		printf("Trigger CoW on page %d of %d...",
> +		ksft_print_msg("Trigger CoW on page %d of %d...",
>  				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
>  		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
>  		if (ops->check_huge(p, 0))
> @@ -1002,7 +947,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  			    1, ops, !c->enforce_pte_scan_limits);
>  
>  		if (c->enforce_pte_scan_limits) {
> -			printf("Trigger CoW on page %d of %d...",
> +			ksft_print_msg("Trigger CoW on page %d of %d...",
>  			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
>  			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
>  				    page_size);
> @@ -1021,15 +966,16 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  	}
>  
>  	wait(&wstatus);
> -	exit_status += WEXITSTATUS(wstatus);
> +	exit_status = WEXITSTATUS(wstatus);
>  
> -	printf("Check if parent still has huge page...");
> +	ksft_print_msg("Check if parent still has huge page...");
>  	if (ops->check_huge(p, 1))
>  		success("OK");
>  	else
>  		fail("Fail");
>  	validate_memory(p, 0, hpage_pmd_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void madvise_collapse_existing_thps(struct collapse_context *c,
> @@ -1046,6 +992,7 @@ static void madvise_collapse_existing_thps(struct collapse_context *c,
>  	__madvise_collapse("Re-collapse PMD-mapped hugepage", p, 1, ops, true);
>  	validate_memory(p, 0, hpage_pmd_size);
>  	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  /*
> @@ -1073,6 +1020,7 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
>  		    true);
>  	validate_memory(p, 0, size);
>  	ops->cleanup_area(p, size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
>  static void usage(void)
> @@ -1176,10 +1124,8 @@ static int nr_test_cases;
>  
>  #define TEST(t, c, o) do {						\
>  	if (c && o) {							\
> -		if (nr_test_cases >= MAX_TEST_CASES) {			\
> -			printf("MAX_ADD_CASES is too small\n");		\
> -			exit(EXIT_FAILURE);				\
> -		}							\
> +		if (nr_test_cases >= MAX_TEST_CASES)			\
> +			ksft_exit_fail_msg("MAX_ADD_CASES is too small\n"); \
>  		test_cases[nr_test_cases++] = (struct test_case){	\
>  			.ctx	= c,					\
>  			.ops	= o,					\
> @@ -1212,10 +1158,10 @@ int main(int argc, char **argv)
>  		.read_ahead_kb = 0,
>  	};
>  
> -	if (!thp_is_enabled()) {
> -		printf("Transparent Hugepages not available\n");
> -		return KSFT_SKIP;
> -	}
> +	ksft_print_header();
> +
> +	if (!thp_is_enabled())
> +		ksft_exit_skip("Transparent Hugepages not available\n");
>  
>  	parse_test_type(argc, argv);
>  
> @@ -1223,10 +1169,8 @@ int main(int argc, char **argv)
>  
>  	page_size = getpagesize();
>  	hpage_pmd_size = read_pmd_pagesize();
> -	if (!hpage_pmd_size) {
> -		printf("Reading PMD pagesize failed");
> -		exit(EXIT_FAILURE);
> -	}
> +	if (!hpage_pmd_size)
> +		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>  	hpage_pmd_nr = hpage_pmd_size / page_size;
>  	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
>  
> @@ -1242,8 +1186,6 @@ int main(int argc, char **argv)
>  	save_settings();
>  	thp_push_settings(&default_settings);

Also, can save_settings() and thp_push_settings() be moved below
ksft_set_plan(), preserving their order? Since save_settings() is
printing a debug line of its own, it would look better if ksft plan is
printed just below the TAP version line.

>  
> -	alloc_at_fault();
> -
>  	TEST(collapse_full, khugepaged_context, anon_ops);
>  	TEST(collapse_full, khugepaged_context, file_ops);
>  	TEST(collapse_full, khugepaged_context, shmem_ops);
> @@ -1305,11 +1247,14 @@ int main(int argc, char **argv)
>  	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
>  	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
>  
> +	ksft_set_plan(nr_test_cases + 1);
> +
> +	alloc_at_fault();
>  	for (int i = 0; i < nr_test_cases; i++) {
>  		struct test_case *t = &test_cases[i];
>  
>  		exit_status = KSFT_PASS;
> -		printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
> +		ksft_print_msg("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
>  		t->fn(t->ctx, t->ops);
>  	}
>  



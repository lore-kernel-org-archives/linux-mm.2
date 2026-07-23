Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E471EC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56F46B0092; Thu, 23 Jul 2026 01:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF10A6B0099; Thu, 23 Jul 2026 01:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CF46B009B; Thu, 23 Jul 2026 01:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFAB6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:09:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7C071A03DD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:09:45 +0000 (UTC)
X-FDA: 85018863930.07.C60BF46
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013052.outbound.protection.outlook.com [52.101.83.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9A255180002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:09:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HaYL8C4q;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HaYL8C4q;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.52 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784783382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BC2LrYMmYNAUhDC+EbVV0wQn3vMbdlfxXhSyZEHgwxs=;
	b=LX4aD85WuteoxELYHBeXEaA81atsPTFl9MgTiNSCksWgsIqXRogVQVf95t4fg1e0CstnP/
	4XUbFXhQ0i8G0cKbad2vfkQYdIj8Wze3nnUu8j3neT2RgmXimK6G7LgY69nj7Zzx/HuBtG
	tqEcg4/9wyfVfqp0VNhQXEEgRLgeznE=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HaYL8C4q;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HaYL8C4q;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.52 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784783382;
	b=PofnWFPoIxd7aA+1d3W4LCeMlHwoPgmppCn3xZUjyGcV7ynSAJyHVpy7W9yyu4endbwOFx
	alxEa/Ypt7a0/2c275o39EK39lBjTuLUMwJ1wysOv2QqRagGSfjAbsP0X3buLm3JzCI3Vd
	tAru2Mg1qFWMHqTdJk4+9EeT/9YweNg=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C/bJjAyTxrBz0J5m67Nii901EqFGIdqcU2Ji6ouTlQFoyVyq+JBFMSfKnvRCTdnXGbRrcoJhWLhWz5CULgAVo3DTzfzA1h/8R99cueHa81H+yonosR/uRLKSkWkPVVAlJdLqFpWH7iFa8Sh3hnsrGGuB1PU6ZulC3qk2GqM73/zpaUcTtQpg/r2qJNtV/xrCa8/waQNBWCSs+Tgy2cXMnPUPQD1kJyCrtHJW5nPPSguy4tQTjvMk871hOZKQScmH6WB4v9Z2xeOzMMGvaVAAGxJnDgF16fAKqqfzj1KPCpMAx1d7Fd+oEzUOGoiunAsKg/PQssJU/03ARf0WEpT2Jw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BC2LrYMmYNAUhDC+EbVV0wQn3vMbdlfxXhSyZEHgwxs=;
 b=irpm5gKN/ByEPfTnzpVPpfGGJ7NJ+TVa7anXe0bvXk8Lr9AGc7qRTO8tU0BhEWiw1r9g7D54EmKVa1qYmMByWY+oTLI9eAyfxwUeWVIJeHH7OsZ4gusJyKn09+dlEDfjmr/lskMYspQjiE9r+iDLP+1uEQSyQjCxlwqfV93Utwr16sWODklZ10ZJ+Si6/LQLFROU3Sy6cUjgxJARW4QsRhfEw0E01CfXIRz7+Pv4vVtKz5nX3AWAs1LbIzk7fshIFdBn56fIU7PAYnxXE0W995uyTbVaWo6ECXkT1httasQidPDOGnNaK4wS4K4OguPkmDlqxRzV9gtOUQm1uzFjVQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC2LrYMmYNAUhDC+EbVV0wQn3vMbdlfxXhSyZEHgwxs=;
 b=HaYL8C4qJhutiSJAQsGJLs4Yh65eoFad9REKbRuTJpH0WeJaDDCpCY2yAmF0i8GhsL3UX82NkPjpmUUER9SQ1qnpuPY0sdeppQWXe8tvdy5ZW5PlK3vRNVSC8hLpxGV5bT2AyjjwMyREUgI+H+7pM1+5wyUQIHrUfl5TIWpOkzA=
Received: from AS4PR09CA0016.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::8)
 by GV1PR08MB11075.eurprd08.prod.outlook.com (2603:10a6:150:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 05:09:35 +0000
Received: from AMS1EPF00000045.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::6f) by AS4PR09CA0016.outlook.office365.com
 (2603:10a6:20b:5d4::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 05:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000045.mail.protection.outlook.com (10.167.16.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Thu, 23 Jul 2026 05:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgJ/YYf0cSdgrT91BSokMQFXuv8A+wBsyGIfSwK495e9V+jifNk4VfOSGYhmBRzulDDxfnvuntYSJvuRod9ID2KWy8MKcc9tVDbvtulxkSqpBC1uk9ROpLOO7q1cC2Mg5JCXGP+dMk0tV6wvzJwK/Zx1v1cQ3Juz8sxB9Ds7K0Z0plK91UTLY9/TDT95r2BT3ovt9yiYuy5ulaS5dnWdyVBn9w9vUn1sOI5eT5eLYb65YgiMvIT6pXgMnGxbLMSKc2eEqb5Y+8yGd8Acl63rj8pXciKfQACyt8uFZ7GDmWNy9ZUZWdzA19smHchaEDuUVIZ3T/tF+Vt1iqYXQGeulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BC2LrYMmYNAUhDC+EbVV0wQn3vMbdlfxXhSyZEHgwxs=;
 b=PhCOIN8I/AQLgC1ogCLE6cHR/us87WblLLWmq5uLx+tHi42OwSKa7/GlCOcikBKgFewI5nY8BQLfF9o5D6SXroL2EXRP57EWpIkLCUGIPewbaI6mnlb/LkB9d/w2nXh82ZRfWH3ppsDXi0mxjsYqHQqJyNvX75IRWsCTGfHOJIjhXCEW0k/cauSNtR4qbKcVtBOeWWkXtnjd0HbSFGzsN5n+rpcnZv7OiHBUzvMNsC4F8l0z2KGAMUtOTLop9N5Ig3zgNXr5J+CB2jaqJHQa0X+sviXs19m0jNUMHe2UMZa111edQB8UKB2LBr1y6D+uMYaHU+cbo9/0dBAPODYlAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC2LrYMmYNAUhDC+EbVV0wQn3vMbdlfxXhSyZEHgwxs=;
 b=HaYL8C4qJhutiSJAQsGJLs4Yh65eoFad9REKbRuTJpH0WeJaDDCpCY2yAmF0i8GhsL3UX82NkPjpmUUER9SQ1qnpuPY0sdeppQWXe8tvdy5ZW5PlK3vRNVSC8hLpxGV5bT2AyjjwMyREUgI+H+7pM1+5wyUQIHrUfl5TIWpOkzA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GVXPR08MB10430.eurprd08.prod.outlook.com (2603:10a6:150:14e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 05:08:29 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 05:08:29 +0000
Message-ID: <188a0acc-dd03-443c-8e1f-329a4dddcd5f@arm.com>
Date: Thu, 23 Jul 2026 10:38:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v1 3/5] selftests/mm: skip khugepaged swap tests
 without swap
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722091219.61504-1-usama.anjum@arm.com>
 <20260722091219.61504-4-usama.anjum@arm.com>
 <9bb01e21-159a-427c-9d64-5db7070f0209@arm.com>
 <5af250ab-6a52-48d3-bd50-64e8ddd99915@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <5af250ab-6a52-48d3-bd50-64e8ddd99915@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0351.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:219::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GVXPR08MB10430:EE_|AMS1EPF00000045:EE_|GV1PR08MB11075:EE_
X-MS-Office365-Filtering-Correlation-Id: 273e579e-cf9a-465a-08d3-08dee8789636
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|4143699003|11063799006|5023799004|6133799003|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info-Original:
 FKuLokhEd+u5SYvyNqZfxxldWUeDUk5gksFVOcSb2q3YB/C3a30Hx2EvW3ymjlXqCdnshDO8CrkVYqqGyDmrNBvrnjcr44IbflFx93kITqWyto3rOMTv3IkGKTjfJVtHMXjv/nBFk25XUzEROv5zIcOYpbfJZtH+t52zYlE028dtuxEYXs2o7boo30uTwsOYwef+ndyHaKQaQT5EBFN543O46cPMNNW7NFs6hlkdG4VJsC9jhPvrEq8kUY+V2C6m8/ijdhA0oiKK+NxabsYRhtvJM057BhHvdz7gjqOdgNZZtSA8WyTyEENeGiLAAh/4EyKKaTB+9bgIdHx3RX2O7EPQ0wp9R6pRYyHNpJ5dg0ZPxz7PQ/PQpvpjpaNJ9/y0nijFhY2/bxTqUmI2ZHHR5JBa3WwZ9CAvVLVqnvvyMUBjesvo2Qe469ZGgdUt0Qsd/anaZSu/urVyFXvpNPBYyCTTNw+fOJSxavJhYrH1n1su/plDx/GjpZWUaHcrMOAHw2XdknwrKk5Cd4ZMMA6Qjk0mGrWZD5RkHfCNMXsHHhGVp6imf6HPn9JVZMHjAt+r1bYUVR+1HlxibpVS29ULaiqYMtYHoU2sbF59TwCIzvax300rcelucVaPpQFaozNwWJcVLgellpyfEB4UASWNeeq64Sck5m9POfJQs+n0t7vWbsw61QWkxVBlvGWuBAW0D2jHdWST1rm1jshryQXfPw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(4143699003)(11063799006)(5023799004)(6133799003)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Im2KyhcfZYsz1lI+RSmY0SwkaZ+xDG09Wk0/+WLE0kWYEsVVoZe4k6jNUhaAvf4lpkYAXD+Nt3+g2yziGlCy6RUb3pTfCv57qaYHJuTr8Jt8Ifw21BpGxRvrLOLc5mfgTPRcgUUOJMqOa7ro+81j7ilIV/lmGXbQ8iizaBQlHmQ12mtSHK4shxZiF+28s7cBEWhYVCuFagKwRsJH7IAxaE07r1L/tSNJIMNiVhdGk9/i7zbdnPp4FmdX2J4n5aL70LikCJD8GJR1pXcrEduzirQteyjg2i1JvT3cuVW+PIWZ9X8RIRxEvE+RW/hHxkaWp1aHwrdWJn7E6qJkF8mUQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10430
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	07324c50-1973-4506-6f31-08dee8786ece
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|376014|1800799024|14060799003|35042699022|36860700016|921020|6133799003|56012099006|5023799004|11063799006|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	6uyrygNkv86SnlvbYcSHh3iq9HQfmOj28ANPwheInB/8f9SOWHH0IRobXwFUv/FG8zUaPbRY6G89uqkavFNxCWA2NKH8OtWe2VWavh2KYeC3J5Dhcg0nLZTGgKv/Xv40l0noymR8TLKFkc4C+hLldtP/JO36MgxkiOR8ptE8vvxm7VeuXufjyFtviySMqHFj3P1PD4nWB2jExoqWnQkTLTJY17Ks7PUGOK2SVheB1LxMitJ4xBtURS5Y+IlwLmygnSgcbgLdEkYfMj9PyPiLWMqw9PgK32VqDI3dO4DNfiJnxa2TMZxuHQxu8aQ6LUiCqi62Xiiw+krrsG2c7InkH7iE4KB2F3yVp9bqCUaJpYBPaFHokf6QxH7aHt+rOkuF7E/9nAKl5YzB85795PrqfnngtYuVFhuYvqhozdkBxb21T0E0SWGfRqrs3I62x9o2IGQgyK08nFA2banwlw71SqJjmdJkwj7u3Nbyf4GkNbWCgzRYqXp6CysdsB3HN36ZWHz/OW4R+MLTylsq+6uxUdlfFib9SAMcvcGWikczfR+icAD6u0js9lze7zt6DyWN7nTx8crqyS9beewV/VcKbJYZyWgddVfktNogSqMBjMLXZJE1WgkAlSlWog00ODEIBb7I4TJ701bhUeqqzOX0DVXRNE9YVy6AfZy+IWhVzCmlUSe0a1S7oHjWIRgOwOtXnPJNbOmE7hcDzsev0/0QmCPJUgYYzJQIgYpBiTp2t9VQvRKzyF8zEiicCVFNYxJe
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(376014)(1800799024)(14060799003)(35042699022)(36860700016)(921020)(6133799003)(56012099006)(5023799004)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KzC66H9nMFhtEM9qSuTXz0DYJTfQKAdOdJMXxw5fWSMh+RL0CE1i1MZTP9eN9y1nNGzizRkskdNJs5uVUeEkg1gQ9wbYh+4dsPa4IoPpuus7sk6khkd2rXSlcGIjHIlYA3Wtpxe1k70GpxlP7QoI4G21GetzkVv8rUQJtZDUlgmdCMbHlRh9nM49hN+WbrNsPN5HQO98JMi1uVPGRCR4/+pyIQN60/ToZE3G+qLqzAuyTov1WARPvOauLvCxL0n0M+oVOGYoDrxgZ14IeyQkPFMxeCZBD5IS+Lu9ebxhwd8L6yUpDFoQyzXMJNz+ifN5r5cTP4dMM2SZzVwIHYffM74p26QVqTalJiGaDt+bgBBu2DJycvB1CbNTM0Ne+cpvCwf/uIGtaailoJL3bg0HYKoqh8PQWLAsvS+RgY0H5QmImtfLFJ1S5voN9lnxPviq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 05:09:34.6007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 273e579e-cf9a-465a-08d3-08dee8789636
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000045.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11075
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A255180002
X-Rspam-User: 
X-Stat-Signature: pr4iqdr5tczogq995zorjgsjetzg4on6
X-HE-Tag: 1784783381-614989
X-HE-Meta: U2FsdGVkX18xFDk3z3mZO6VsR0+gUOJZNeBYKnOIfjb679iBipIQe8SqjxXMU8Zmj0z+5NWRGq0nEwJgrgHrgrDC/fT3tDt2L+LKSFNnc7oO4nMpiNKH9xtj4WBM4P70VDksIWnXgPFiIZJgB6GMYGwxayy8UVrJDgVUTIV3e0Boxq6cm/fbi8zNtopMxxSg6tC0L4p+PP16yr+y6VuLP80owuZYmEtyj6CB/LU+yZ7vTdUbynA34ogTy+/Kg8/5YBQSh/9WBmr17ogNlMy9130p4EasK4eWbau8GoXwKNyLXYFQr3QRXbjFmPJU621G6H1J1BeVYsINr7lseL9ioiO4s9bbngRSJpy9ofXbfHgVAER64bINcfQ/zkvls8SVCfGV/mfuUrNCjGJKMis5AGrL1a50xuJrZQXq68GdCaHK/4B3QyT7dfs+uPo3gFGiURv6+8Mv10Sp2FbcT2wW2OIRCgLGDS4GMpjbPzOn8OhypGDtlPdmbTR7if1h6Ydro2CzsHI9kUiAVI/TzJG1brJxRiY99NS69cslXzkaW5v80mEbl+t+jpPQMAb23V+J41oTwl79GJIwXpcgUeNw4xZKo+jkdCu79GP4NA9Komppd1o6KMj3+ji/m3e1CFL7PRbvgoXFhkgNlxk2M2Swd10vvEQQqfvfWvKKfzpQ/89SXzUHNz7dqAuFed5q5VrPA8POqR19vw4OP3BRh4vHSLeGPOWr/6wEVlXqZ/N0G4CuRC2rkoS593aHII/+PLftDvipDfT5nzrcimk0YzZEHYGAxuHAqMve59s9LZ1WoIewqtVLzMKd1jzRngQGY2gUav0pUphziPzPlmJ/g3ZMgF6FKJXmHkOYf1xHeba4AB73To7rM0rKxBpHxwOda45K2a59e0IX86ONx36tv3hIjveWemwOuvMN5NndezMO/pzdPRoEnkEA9/Ao/RrdU3526STooZBkwO/nqPrXzaM
 Qs+puWuX
 /ZtaD3cTi5UggZMbDAjZBumFIq+g6xiOfaIKH1otU6iSf1hwNXN8qaiTKSZinGv7HFpcXUhgXDKsKlDCUufsSQ7HVJUUOvWvMdqYMmkrBvBsb6332yMhrLL/iB/6cORI0hcfacipDS29w7ts//XDE4//gxy8xVWaoDvtmf0oj1dHMBQRyGRMtZnpmKr6KL2MsB3i3fEwOwPUKueC5m/3cIluQiT3+MBE+g8vtC5LBRFJ8dMQPJCgmAcgMIj9Ofsv9BlIwgWAWc+23lucbmimvbt2mwFAqDePC/7t+mfugZNU9MmwC8YR2eIEj65Xh4XfjdHAKuxqhQWceTI6oTCckDyvZykWj8ZrelYYQuBLWA6AtvKk8L4hkLrMSZbjM1a+0CBSj429yZhIt08ABw49fn6vnxsvFWmXu6rK5R9huBS/awzl9lEFdR6PiZFMRL0ylufkTDBx5fMz8Rxguw29h5OtkK1QkGdGjsqb3/01ELfi/MGCEPWRcDo9HKDmDZssc6a0JUm1OJP5m2sHNwOtEdAq82U4MgIfLtNly0wC549Z0J7vt/NILb/AAvWlhjVuZT8j1Lto94h9oB6CelyFtMCMCWtNp+AYKmMDwc5NH2iNfcX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/26 7:35 PM, Muhammad Usama Anjum wrote:
> Hi,
> 
> Thank you for review.
> 
> On 22/07/2026 1:16 pm, Sarthak Sharma wrote:
>> Hi Usama!
>>
>> On 7/22/26 2:41 PM, Muhammad Usama Anjum wrote:
>>> collapse_swapin_single_pte and collapse_max_ptes_swap require
>>> MADV_PAGEOUT to replace anonymous pages with swap entries.  On swapless
>>> systems there is no backing store with which to create those entries, so
>>> check_swap() reports missing setup rather than broken khugepaged behavior.
>>>
>>> Swapless configurations are common on Android and other constrained
>>> test devices.  Failing these cases obscures actionable results from the
>>> rest of the khugepaged suite.
>>>
>>> Check /proc/swaps before either swap-dependent case and skip when no
>>> active swap area exists.  With swap present, retain the existing
>>> MADV_PAGEOUT and swap-entry assertions unchanged.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>>  tools/testing/selftests/mm/khugepaged.c | 34 +++++++++++++++++++++++++
>>>  1 file changed, 34 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>> index 10e8dedcb087d..a152cec59fcbd 100644
>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>> @@ -100,6 +100,28 @@ static void skip(const char *msg)
>>>  	exit_status = KSFT_SKIP;
>>>  }
>>>  
>>> +static bool is_swap_enabled(void)
>>> +{
>>> +	char buf[MAX_LINE_LENGTH];
>>> +	FILE *file;
>>> +	bool enabled = false;
>>> +
>>> +	file = fopen("/proc/swaps", "r");
>>> +	if (!file)
>>> +		return false;
>>> +
>>> +	if (!fgets(buf, sizeof(buf), file))
>>> +		goto out;
>>> +
>>> +	/* Check for first active swap entry. */
>>> +	if (fgets(buf, sizeof(buf), file))
>>> +		enabled = true;
>>> +
>>> +out:
>>> +	fclose(file);
>>> +	return enabled;
>>> +}
>>> +
>>>  static void save_settings(void)
>>>  {
>>>  	ksft_print_msg("Save THP and khugepaged settings...");
>>> @@ -734,6 +756,12 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>>>  {
>>>  	void *p;
>>>  
>>> +	if (!is_swap_enabled()) {
>>> +		skip("No active swap");
>>
>> Can we prefix this skip message with a #, as recommended for KTAP
>> output? Right now it is printing like this:
> It looks like `skip()` is not being prefixed with `#` in this test
> because of how it is currently used.
> 
> The `skip()` helper itself should probably be fixed, but that can be
> handled in a separate follow-up patch. This test is not fully
> TAP-compliant at the moment: the normal pass/fail output appears to be
> compliant, while the skip-related messages are not. Would it make sense
> to address that separately from this series?

I think there's nothing wrong with the skip() helper. Normal pass/fail
output appears to be TAP compliant because there's a ksft_print_msg(...)
call before calling pass()/fail() helpers. If we move the
ksft_print_msg() line before the is_swap_enabled() check, we'll get
output which is TAP compliant, something like this:

# Run test: collapse_swapin_single_pte (khugepaged:anon)
# Swapout one page... No active swap
ok 16 # SKIP collapse_swapin_single_pte
#
# Run test: collapse_swapin_single_pte (madvise:anon)
# Swapout one page... No active swap
ok 17 # SKIP collapse_swapin_single_pte
#
# Run test: collapse_max_ptes_swap (khugepaged:anon)
# Swapout 65 of 512 pages... No active swap
ok 18 # SKIP collapse_max_ptes_swap
#
# Run test: collapse_max_ptes_swap (madvise:anon)
# Swapout 65 of 512 pages... No active swap
ok 19 # SKIP collapse_max_ptes_swap

> 
> Also when we run the whole mm suite using ./run_vmtests.sh, it appends an extra
> # in start of the output which we get by running normal test directly. Its
> controversial already that we are applying TAP styling to suite level and test
> level as well. So non-compliant skip in this test makes overall output
> compliant.>
>>
>> # Run test: collapse_swapin_single_pte (khugepaged:anon)
>>  No active swap
>> ok 16 # SKIP collapse_swapin_single_pte
>> #
>> # Run test: collapse_swapin_single_pte (madvise:anon)
>>  No active swap
>> ok 17 # SKIP collapse_swapin_single_pte
>> #
>> # Run test: collapse_max_ptes_swap (khugepaged:anon)
>>  No active swap
>> ok 18 # SKIP collapse_max_ptes_swap
>> #
>> # Run test: collapse_max_ptes_swap (madvise:anon)
>>  No active swap
>>
>>
>>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>>> +		return;
>>> +	}
>>> +
>>>  	p = ops->setup_area(1);
>>>  	ops->fault(p, 0, hpage_pmd_size);
>>>  
>>> @@ -760,6 +788,12 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>>>  	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>>>  	void *p;
>>>  
>>> +	if (!is_swap_enabled()) {
>>> +		skip("No active swap");
>>
>> Same here.
>>
>>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>>> +		return;
>>> +	}
>>> +
>>>  	p = ops->setup_area(1);
>>>  	ops->fault(p, 0, hpage_pmd_size);
>>>  
>>
> 



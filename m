Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C50CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB876B0093; Thu,  8 Oct 2026 04:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76396B0095; Thu,  8 Oct 2026 04:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF7C6B0096; Thu,  8 Oct 2026 04:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93A386B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:19:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04FB6C04A1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:19:28 +0000 (UTC)
X-FDA: 85298759658.16.5011773
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013045.outbound.protection.outlook.com [40.107.159.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id D97A8180002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:19:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Qignhpwq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Qignhpwq;
	spf=pass (imf16.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.45 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791447565;
	b=RfhocqBF/eX32PtUfP2YVwMuEDW9OxVrWhQY6wzOhXbKSq1C+UGdHipIvie5i8fw2yvFqj
	/yno0+TPfyfhIgDPc2P8jH4H7Hf2J3VPAPdexO19xsYG0q6p44WRL3uYpbLpU6wPs0sZaU
	Kdy2rQiL+LSxPKWxYCA0SLYcxsAmXhg=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Qignhpwq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Qignhpwq;
	spf=pass (imf16.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.45 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791447565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9xmXzL6tFsZzlFEq2VdqlC6nUBbqk1eYY6n1C6SKOQ=;
	b=4VpLxB66UwezN4R1siOg49rdIlVcgehQNNX8lujao4ajuhmd9C9XbqDJqhWOIxbrmmfc6a
	HoDiH0BNI5uq4fFMix171pkaay2sVlKb47Sk2auOpbHqkCOn/iNajZ4I5Dh13sr0oCl1L/
	exkEVY0tjF1QB2wY8BN394MX6A+Q3MA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=y/Kn7f2LIUo8cqJB+fmx6REjWlGEgqTxx1zDCXOavbRT2kRKz72KyGM9jDxFAfxGSrkZFB+mBg9Ggu+xJUkzuVYoUUnfBvF+rrtEWW2O9tUEULIw9duCFWm0SGgeg4gG2NQwrK0btCp30Dz1uH/SASVSGyUHTUSpI3t3/1OSsBJcKSvT72Kb7AlwDaGCAqR+IksS2whBin1un0BCnAagWesgn1OZxQfNLTkbXDc820srpRmcve3scfuGyiB165BsxxUrYmFy8JYiUuH0WTUYWHBEvyAnGj2U36cDad2Vqouc6taYIHQkPgMaz+TgSj/qYXrvHAIeqbNH08L3zzMhjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9xmXzL6tFsZzlFEq2VdqlC6nUBbqk1eYY6n1C6SKOQ=;
 b=vQFDdEAIZyBxY2mjBmxA1BlhSFHBYlG4fBrOD/c/GWEf6iiRSFu6DOWbIFKJNlRzXoQ7xeWqkadvKERu2wx4y7Wq4ZEvb4MHMpc80+MK+YCIn5jQJz9xo3efdrb5O9xPJObJF1hn0j5uFH2Zcf8pzhLS355KDQrR6ZCiP1xs691xvO/sqCbPQtmENVAYqipi/3NhRUM1/PIQ2bqLDMm7C2xJ3q696Gag7KO5WidIkzkRj79PYhkvQaq8BPmmBlwbCdtgLF6xptczC43jSkMq2vmXtYFFwSWEY4aqfFrhtJM+/A2t4CRfc5Ikb/Svx4yuYp6mR1F8rgDVRquq3r5ZdQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9xmXzL6tFsZzlFEq2VdqlC6nUBbqk1eYY6n1C6SKOQ=;
 b=QignhpwqPlGpi22hw+dDMHJqeIosrrXA0vHT57JVAyh1TO7XH43UIivF5zy1//qVsATVI9UeIkN8qt0+3hi5phjD5ko0FixOFBmD32J3lBU85jmy9fl7H0YNoOJOIrB4+BunaXgFreySBrhrHcGB53E1XEvoDYhf1PyufjJHTE8=
Received: from LO4P123CA0115.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:192::12)
 by AS4PR08MB8166.eurprd08.prod.outlook.com (2603:10a6:20b:58d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 08:19:17 +0000
Received: from ZR1PEPF0000E463.eurprd04.prod.outlook.com
 (2603:10a6:600:192:cafe::31) by LO4P123CA0115.outlook.office365.com
 (2603:10a6:600:192::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 08:19:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 ZR1PEPF0000E463.mail.protection.outlook.com (10.167.241.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.14
 via Frontend Transport; Thu, 8 Oct 2026 08:19:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbtmiIXvWrVs0/TL/y4fwlsVWl3L6yfcMpt8QIAXGQFCr/caQJnZ/l10w6uwtDWVRqOIThp4p/l221tXNBwtvvEG3E3B3q+jmnOn87o4jRtvhMjt44s0HIPcw6dyFakE/xiOXbUML4+fTyH2SJ1ibKvp34XHBdBxhOtfvx8aJg7HNo6JertiTm7OSyY6OxvaAJQQHQziaTUwHvE4+jyOqg3sy8i2ZC/pHgovhhWvwYFTxsytBRJLtT21kTjT3q/gXVBjH3JaHGeQ33AJgqPX95B73Ou/7yVExwyNvyr/md1I/LfJUQL5SVTG21/zQan4sSj2gLqdxrpceJ6Fc9XMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9xmXzL6tFsZzlFEq2VdqlC6nUBbqk1eYY6n1C6SKOQ=;
 b=qPT5s677NxJB1NChD6fzoZtzIBnrwCwu3BqSHaZAI2KkjgDvED+Kasj9E3g2k+Il3x7zB6bxZNN+tOGka3iM+/t/9stEQ0yy5ntPpFKW3EavNWJn+LFOe+pgwZUKUErxWjinbRZMXZY8phhFb5FbX07BU8yZqtosNAP3MulqLvgy051MIqI7ogE47mVXX2QL2A3EdlFPSMgG12sh90ylk8qvIzJ6UzW4W3KwjMMixUyIFjM7zjO6r16V2/VdZE5FvZO7FgIJKyE37AiBpWfwnvXedYlwsJLyctsDvbr4OmK7pF5hJKOjmNgQvKHI3hpO9zbwYgkFHaLvdP9N4CyObw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9xmXzL6tFsZzlFEq2VdqlC6nUBbqk1eYY6n1C6SKOQ=;
 b=QignhpwqPlGpi22hw+dDMHJqeIosrrXA0vHT57JVAyh1TO7XH43UIivF5zy1//qVsATVI9UeIkN8qt0+3hi5phjD5ko0FixOFBmD32J3lBU85jmy9fl7H0YNoOJOIrB4+BunaXgFreySBrhrHcGB53E1XEvoDYhf1PyufjJHTE8=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AS2PR08MB8696.eurprd08.prod.outlook.com (2603:10a6:20b:55f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Thu, 8 Oct
 2026 08:18:43 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 08:18:42 +0000
Message-ID: <6e3c298f-9b93-43b2-840d-65c5ffa3bc36@arm.com>
Date: Thu, 8 Oct 2026 09:18:40 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Usama Arif <usama.arif@linux.dev>,
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com,
 Kiryl Shutsemau <kirill@shutemov.name>
Subject: Re: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
To: Zenghui Yu <zenghui.yu@linux.dev>
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-17-kirill@shutemov.name>
 <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::16) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AS2PR08MB8696:EE_|ZR1PEPF0000E463:EE_|AS4PR08MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: b05259ac-b18f-4446-2261-08df2514d898
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|10067099003|56012099006|4143699003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 zPIBKzAxrdDlxKGvuVidcghrTcAsPt0DwNZlOezXJNZf0jdlY4d0X9vHpKUcY9J63n0R8vPQUZVRFXSkjLBmB1TZV30pqKA0PnaOw1ElZqpGjTZ9vClHwbR89+IOW9FelvaLceXwSZ/oaj8pwDSUITn1l40plPB+uPzAdqh+MfvBSHrLy7ruwZ5Dn67/I4o6Qex9F1ZsuocypPBuxZRcCdMUCxJu9em8dD4ayfac8+s6eMlSctJGfYGSRK7u+zVpN1+Wfrcheg/9iEmeKHZWfIvPUYwR9FBechCscpU3pWxh4bUAAxk39TNiEsDqAf9nqOoT3tXL/AXaSFEWbwOtm5AIMZm5W+YpYzQLevNnmUNyjKlUAl5moYQK+N03KnBOBkTpF5OYRj6K7UlKSf2YMQ/2nKQLspRbu5/LH6QrvivDx8c45lRLeGk0SRmplF4Q0sGqRWckxmOfGltUhXbLrM8Wk6Qd5/ZDDRAWBcmDe3m1oDMO9e3qBnxFhdlfBlIKX7SEOx0ubyYQBvlq6AaOgAUkFzTIlx4D3+ZVUAJtEsNkbihtRANe2XXbNwnYIXvFVE9+SgAgz2LCuJgfpGFunO1Lil3Q6fiPTAvlVbQHKiDFWA/x5gwoAYtotjKCneiDAMPiZWWAdxYZPO1sOaiIok01OA4rSZKiOylT9BF2mpU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(10067099003)(56012099006)(4143699003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 l3yHF1IvH0nlxOZzok1RtrWm1s3NConfWLcRcZpIRQDgsboKRvOTabEmGQypDcFqEu053x1u6UYIpEmdnYBYFAm3oIi5o3G7M/cXXq7UfRRm6qzFyqKLQolqZrQn+LYdUqwI+ToAQQkKl0DrFIHj5YwJ2p5skkiia9TXtSz6Jl+Me+/g5xomEIKiNZjpbTqaVA0EmH39B5RMJwZxMVRUOE/+EAeEjOY5t9beoEBxfrXzK1uNdubNgh06GJrMNX1RbA5TSvypYYfERJa4O1g9X+ygGVtZTBCSPknds//3aPyGKv6dsu2CEqGmOIM4nBjyD2JFgPcMbRguspIJzzAvVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8696
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6347e238-5bf2-4e8f-4b4b-08df2514c3c3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|7416014|376014|1800799024|35042699022|23010399003|82310400026|11063799006|4143699003|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Gh4Rs/+HLcaUYTQj70KRcZ/koQynjebDiliF+dL71s8rqNJ7T0Bst7bTyDNu520WQh1nPxqsfWm+2n1TWKKnYvpmejlz47BrRpZeqJw5ij1B1etmkVVSa9sMnijCJfey0fH0wS8VtUPpa22oGl2NCTzG5Zrr0kE7s8CzIBdv6ZA8eyMf8SYaEkq6+FasQ/doHhGvV9WVqSATWq/WFKqlnv2s4nkXo2jRaGqFmVgYKSpWqFvVma6QIYu6Iu46xQONFiUFZexBKVzt6ZNIO/mUJ0zMxfRrJZ9Qlqe6cG3fsayWzg5Rj6mP+ULGE8xOWPwkZaZTlrKumkX5A0o8ZBkMUXHnYkze4lvbxSK3r4CzicwqGHj/HfqrSHbF24N3mJVpgNwXcIWeUA6wyQz6JQnyDQ1Lt5Ift3OKQySY9t/Zxx9Qp/19gfsB9pG8PfQuGZFTXapanXXDs2VjrHUKzswtVASu8UISyLg/HQnLINfY0mLu8fg/gWbk55v49wkpMQ508JIu3CATqRbE9YPwcksy/FdTi/M5cyfSozScG9ovJLQ2YS/bVub+gxUUPQmZsr1Yv4Z7FQJtOqAr9C0EsAt0Sm5IgeIl0QNj6dtMlW1EpY9zlU77v9pBlPOeINx75WQxTaMW3wcgAh5oqPnKsnmrrQeis6UX1pNMmHmR3GSztiCoeAaClR8DEfFARZm3A/ZT0GK1xadZfSGBjym5vytHBQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(7416014)(376014)(1800799024)(35042699022)(23010399003)(82310400026)(11063799006)(4143699003)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KzdSFSvIZ+QM331PDVoHrvHNg5SIVqCwTfOboK3DI+y26YTwG/bhHsFnsOPPE2L95vU9cfRnvbvlU+Jtery4wKMTCTEN2sb0K2qXdxQcTJa50LAUyc/awhS8pBp0FlqRThMfwBlN4qXQxp/tYw2k1qPqeeh2sBz7ZedBJO+S0ODMlTfIa4CL8g44B9qaOaLC9G0zANfm13LPy570O6BMtwtRBjvvTlIzz/cnzyEjGbJZSrbGMoijRfTnIIsnii9laT/vH6xeBA0cmICinOizgAABgV3LQ4G+iwTYHEewq1TKuGJvjiebsEldQAseb3t8IkniSemxEB08kiTxGPS26rZxRJBG7ba4qY9jS+wjTEGdrzyVQRzyIm6Eplh2bvkbjiDXObGxwCHnHc/dFX1oEEkza5qCiEWBik2XqB80V0iyzUr4fv3xS6h1d4jEGIx3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 08:19:17.1801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b05259ac-b18f-4446-2261-08df2514d898
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	ZR1PEPF0000E463.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8166
X-Stat-Signature: 3mexogijdy45mjgjwormztjk953wxowt
X-Rspamd-Queue-Id: D97A8180002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791447564-697265
X-HE-Meta: U2FsdGVkX1/8EAoA6kchQ9jO8rTh75XvuP4+jd7sloV/zHfnJmVojQCVAk+phWuxKZllnr1/QCNTL2nwr4vOOVwtR+SX5/8myy93STnmNSjypbf9D42y4lpP2MHCPSoHJLF1wRJOcTURD2UHVwGEoQSh67ARExkCbl077NUqAdHmWCX5WmZg/ks9fJPfKTWQiayx+Os2baZ7tipl4hZt84LeQNx1+F0Dkvwo3nQ4FsnzM2m24fZwouxbdptGL3WpEBg+lX5J2awuPNgLt6K8FQjlSLTQRkpEq2yaCa1wyF3LKyrCuFjPfCse02ZiZ4vc8AGgnpxPvc7Vvd5X0we7bth+WLG+rDipdhkQtKiVxEOMkmne24D8fwqaiwsaDewFOtsNsYlecIPsQM+0ZitD4cYWkAPySoCrHEM0QuIv+uljojyXENLg6dv+lEvch6NxURfNTqOMYwHYH3J3FHwJV1tAm0IxztbMahno4CezP2ah/43oJojsQmHcAdzoJ1Dxu6OWhcVYdWny0oDom4qsgvM8JOtzcosAy768hUfS7voS0Ah+U/Uf5PJd6qFmGYhQxba9CSTvLHKQ++8v25Mo4ZbXGY3aw80mTlP+kn3QxJ5LB9E3OM9uyipEmofjJ090mWhmc3OyGbbjpiAtDIaYmo5Z3KH1p8CyqqwYCQ0esWjop68gX9aEzNQ3zdXzHTbTzRUNFm8UL0ZLJxbZfvOEDF8u4ZbCxYf9/YVFWSTRJwqPuMph9TUO2ISDzInBhCTkQM/faX9VFXLsVtEmhQEKggyHnkQ0d+gSdabNkxbfWTY6ryirU5bMrYghHTCxgsKOHTP97whPwFBDoCyNLzyPQJtWk58sXFmueeHkHqdn7RulukUH5TdE+JZnYcanbhaXE2kEUl4oFkrngO1BuzQq8hb2DLyU8dBHse/F4pdTBfsKeQ6vvDUk4B/VVhj0k0wuX3AROBSIafOsdF4rVPX
 zW1MREe9
 4k4uPBrLC7asa0z0zh+WUSxHQhE0a6qnhGTKN5RQczYJ5+ai1b0iBcr0wrYJHg8TIvXJiIywer9XF8s9atzreKP52jaJgWtyKiH0v6MyaZtICjCH/v2wzbVOoiPAxTsnej9T8RJPRpdLgWdL8N79hJ9/5E2Bo2+GYkzwPK4lICESg6Zet3xaXLx3AZ65Sp+nWwKT85brbJJOJTGNJ8/bITAagm395kltg/ugEGcv04vzIZzPZ+7CenjNwcDO3aH5a8VbQvTYA+CxDeYX/XJItosuA5N5paV0OFphPoxNfmL+ixQt/T45YqcJap4Wlvv/Z7jQyg0mXEavphqBPGNos6bheal/x7v4n2v3grmw71qXerU6NT2Jk9TMROFIdfZyBEAl4zNWAs+qYERkd10dLk90dq7NVFA21NEISZ8E62IT/1v6dbfZZaPPedCih6Rxnd3o18XAo31ToPLYLfEUTJF+Ap7JOzSu4GHyrUdh+ieeKbNh9/HXv8BSsbLbuqOfA+DJ3Zwk5n44/QJ2aMjE1WwTOYzjBXsZKOe2N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/10/2026 8:30 am, Zenghui Yu wrote:
> On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> 
>> +		} else {	/* madvise */
>> +			while (now_ms() < end_ms && !corrupted) {
>> +				for (i = 0; i < nr_shared_areas; i++) {
>> +					madvise(region + i * hpage_pmd_size,
>> +						hpage_pmd_size, MADV_COLLAPSE);
> 
> I got the following error when compiling it:
> 
> khugepaged_race.c: In function ‘main’:
> khugepaged_race.c:506:23: error: ‘MADV_COLLAPSE’ undeclared (first use in this function); did you mean ‘MADV_COLD’?
>   506 |       hpage_pmd_size, MADV_COLLAPSE);
>       |                       ^~~~~~~~~~~~~
>       |                       MADV_COLD
> khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1

I've just tested with and without make headers on linux-next
which has this patch and I've not received such error.

If your system headers are old, running make headers can help.

> 
> Thanks,
> Zenghui


-- 
Thanks,
Usama


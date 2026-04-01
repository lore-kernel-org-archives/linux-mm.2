Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B98D3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3136B0088; Wed,  1 Apr 2026 05:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3656B0089; Wed,  1 Apr 2026 05:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B736B008A; Wed,  1 Apr 2026 05:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13D446B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:20:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B00318B96A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:20:29 +0000 (UTC)
X-FDA: 84609441378.08.C735DBE
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011035.outbound.protection.outlook.com [52.101.70.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79DE28000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:20:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ErQWJDoJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ErQWJDoJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775035226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSRfhEFzwzd5PqDYvgVfFspx1QWyol5RY4cgpLuPf2E=;
	b=ClDncmA6O/8IUENWCmFlJE08c03X/lfzu4SzSCqVXrTl/12wZE+PwTtjwp268B/vx2+KhR
	sIN8m/6YvyBxk5VXjjabZw7eORW0EOwbg0nYa4WDCryBvWI/Nol5hfNl6SLUFWavN/wa2E
	y11sKkCgckLYE1QyFCW6GhrS8okkoDU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1775035226; a=rsa-sha256;
	cv=pass;
	b=JuAg8Q2yCiFg1nMLlNoqaOEDqB2sazjaZvPLv9LgUCBDFhWqbkIIGn6mnCYBM31SZzQK+V
	Vi5qNWgJlDPwjbeCu4W4N9k/VYPkWiYrRJTE93GiSVUzCz8SzlDER7m+ZDZJI9VRPhCuXi
	hVk3sjiLRIlMVlqpyWbnEKZwy9Q5Qe0=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ErQWJDoJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ErQWJDoJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sRLKPT4M9lblZef2ggzEImIdi6g+gTtAi3byU6QZvfrnm5o7TlwgfzB4JgCKKB7lAOr3bMaGjZIuak+xnRUvco0iCKYJPo84NGdz9jSfqQ9ctQRykQ9au1QNMuU+9EtFGB0X4VE326qhjAyZ69X8cXvv0/rv1WACBbllpaMwlDQ6I4bJLRRaqmLdXe8eoxVz+s7BwGhFFYO3hsOjSM1bpcZ1D0Ym5j5RSE29DgZsKnFK4y5NtVu4ZQ6QYaxGAHyw7SS304j1RiWf/N9Zbi17ius5yWWUDGLN+P/Ux3mGY8G14uoY2PJgqtKoER1QqqO1Jc0NCbxmA0/dPbC7s7pSZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSRfhEFzwzd5PqDYvgVfFspx1QWyol5RY4cgpLuPf2E=;
 b=cKx2imUQE7OSFZCJL2w0JVQBamfrOQL1nSlMMAYIl8ems/xUY5mXC7OGbGFmvVJvTly8a6Fl8LZ6KRvoU5FMdyqIyKIuyad89zUO0WDVuMoNS1epkETEADiOhIVrl6b1gAtv3uX1mGjtj1ojRi864fMJUqwExX/xe5+w6vnNrmHBkWOwXisBgzG3Rdb5Wi1r8HnSpGGZXw20hSML6WJ0/PF8sAVrFJu/Z+8PCNFR0rc0wVy1EBJL4M203FW1LbjG+lfP7OnTB9ypTeur9TZwtHgHrM/fb6LB+ebWQGKy/OEk85T/6O7x3WxN/VB6NfWOqJt6cQa8CVHVmG7u2EVvyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=nvidia.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSRfhEFzwzd5PqDYvgVfFspx1QWyol5RY4cgpLuPf2E=;
 b=ErQWJDoJsu/2aOFOgbrdu1HG66WRVmZm1/LXrPwBKCScfi8epGa6TBoAQ8EhLl8z3MRB8ikB1TVNFpMtLC3jwG1RYDhoGt3bywH2EGEehG8ceq3M4fTeG5smo8/kem6yUg+8og+JL4+sstSTn6r/EIYEKL11dD6XVxDYIG7Qiuk=
Received: from DUZPR01CA0109.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::28) by AS2PR08MB9223.eurprd08.prod.outlook.com
 (2603:10a6:20b:59d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Wed, 1 Apr
 2026 09:20:18 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::29) by DUZPR01CA0109.outlook.office365.com
 (2603:10a6:10:4bb::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 09:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 1 Apr 2026 09:20:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8fbO9Dq6HmtJCCGkowjGr87/KIPw+2x3gkl/befsCvOPNd5KMXTXqMYYDEcQt4yIVWU/qyWQqy+wxJKdrCtq0Zqn0sSPFScd1Ylq0uT+J5WFa6PWCDVwAxWZFokllNkEyriLW0t04vAUwA8vIS2RpCKNh9v9m9jHjeDSySBktHpp9GlRZEMP7UWKl0WATtUC3PJwNSWT4xuSrJRuRGQGGsTfYTqcjroA6WluHm6zW3NhL3R+hT4OYP7jAclOcrLTYpkxwcC3Wqo4AR3nU/EtFoAsrWo79Mhnbh8mBqjUcku4YtFWWFR2Z1NrB7puv7snZJsGbEejf8QSzd67F/Dkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSRfhEFzwzd5PqDYvgVfFspx1QWyol5RY4cgpLuPf2E=;
 b=OuPzF0MBFHvcK3uVXa9MFzveGW5fQYfIQ2eV4fmJZkf5/02tazdpr7W1GqhlbZ07HQMRqQVULEbRHmNAimImocq6R3P7/hOXqWNlFHRrowRve95+5xu9IOFBCAAth8hGGdVXT/RHgd8cDFzg4/YRPtDd70HsdMjda6fLGp80Z2qwYgr/Un+ZjUAHUfHUqWbEsZLfOcaQgXVzQAK/hio/z3n5z2ck4/Y4eZ9JIm07Pp2vsjH3bN7kHx6qnG8VycBC2SIoEnm1wlehHf5qvMXjs2PCyt4RDzkvvo3DPd8zbDSUipgItrvfU1v/sEPNhlj/M9kaWaIiZd/zzQ6Zi7sVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSRfhEFzwzd5PqDYvgVfFspx1QWyol5RY4cgpLuPf2E=;
 b=ErQWJDoJsu/2aOFOgbrdu1HG66WRVmZm1/LXrPwBKCScfi8epGa6TBoAQ8EhLl8z3MRB8ikB1TVNFpMtLC3jwG1RYDhoGt3bywH2EGEehG8ceq3M4fTeG5smo8/kem6yUg+8og+JL4+sstSTn6r/EIYEKL11dD6XVxDYIG7Qiuk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by VI1PR08MB5469.eurprd08.prod.outlook.com (2603:10a6:803:132::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 09:19:14 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Wed, 1 Apr 2026
 09:19:13 +0000
Message-ID: <a6be48c8-2a7d-47a6-8c89-51cb4858e999@arm.com>
Date: Wed, 1 Apr 2026 10:19:12 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
To: Zi Yan <ziy@nvidia.com>
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-2-usama.anjum@arm.com>
 <808663DC-2C66-460A-81D0-2943B9B7CF69@nvidia.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <808663DC-2C66-460A-81D0-2943B9B7CF69@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0669.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::19) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|VI1PR08MB5469:EE_|DU2PEPF00028D07:EE_|AS2PR08MB9223:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a05fcbd-7d20-4e01-f2b4-08de8fcfe42f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 l34qOSJrNSjkjA0y0jRTkDfkN5txrTbtw1/lvZyLiFFx5Eod86k5mkZoZlqHTB6JHe1dyjpFvRdjwVH1Dx+tPCOaWKB0v0toHSEYftUJJsa/tmuRzYpY1fzCbeE0XJ8fZvCAyekp/NOXPuQJ/6t1t9Ji7KaFzgnlpFgczpnJ1rAPPZM1f9aUd5mvRJlrMrc8GddWfLAQeY//WAfo2UUFKxXnEd8LjHQpowjopNnoFEhc9fIfR60OEpmcbvOiU1wxpcQH9YH/fj67YrIVvOtqtQCcaZilltuObjBk0aOuxt3s1inD3YjVQgaAQam7WDGZgrAaEPhLCPAoWgOnDrlw/tCa3IEZghgqqTyofLKR4SB4Z8gFt85MTmyXapcGLbZLEysyUNG0ctNT/x+ODlK//KuTfXIpzbl7uiZTp+TR67jIudaTExcIUEclgpmrM72zsSvzYFwn5M0w+od8uSNPIchdj9w5aRg6R37TGIw4IcSAwWkuBSuBzD79u8BshhSgD8PXTIj5b9XGKvSR3MUxY6dsSF5YOQUQBFnu7Yl85GkDjlFjZWGWfIpLW4h42jQ38rjc/NFDl/snZt19VCm3moy1TiuSe3cBDdgtAdtekTDQkCVnqjOCUdtQjbtWeJGRotqXYOYDYDjvdIar01XrWlsBKaW/uIRlef520quEAqosPxlyYfybLMmF5otnzNWWk/SGkbv1jHqBKZLzZ/HCt4wkaAxsySF53qesdomnJrI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 tqy+zofOxXEHGuK6cHMJmCJLxtqNcpWIyHUlOMYOylzspjl0PmmGvK1MdrsY9ty8tsZ1J5PhvGXdCdAC5W+RnbXWVWpDYam9QYE1lMiNtQamJ8NI4Sqy4hoBeOBvdcPfq3/mmh051ubAtq/ertARpW034XyyJi9zN3G/JOMVnvji9M23AOob8E7B4SUPdkLXNEKz4Ofc5hMltunuiuV5M6LqgBPLsGeLaFKHdIvEgc/WeEOJHN4KaeztmJjH+rqJQ1r7nvSjmolThZrXmKV9ta5D/gh8NRoOuz8QNKSSW64qo1T69xGyMqJ2o4MJaISCLiuxARMcqJ0PA3EZaTeUDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5469
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	96fe5e2c-89bc-4986-93fd-08de8fcfbd85
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|35042699022|14060799003|1800799024|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6ZedrPFdgIcfskDecUvkxORTRQ2/iu0rT58sYNtFSZpaLJXCax7Uvdsyuk5Bx3pdM3PJgayDBihvD18qIxfqxCqaKzkXJPRsY8fquv78hPGtpGFf1CmYyEZF87uTboVkcowkpyoJ0lIiOncMjjF7tN6F+UUYTzF4Raxrdtzj6IqKSZ422x4CTV/H9x4Bg0+PEDHpPZCMeE+J7oLh1LuiCoSqb0FHvW6p0ZT6WAQMLanIuLyDpXfO3YG/Zz6G/xJV1kbxltb6t+E0X52z6Q22iK9s/WhZI+Zp3nXPjFUAPwq8kAj8II0W8y1rgfzzCzDxmyoH1QY7OHV2koMJtRUajpioAA3Hgfw2izD03BZ9P3xxIZ+0Q+GqwyizD1IB2yLPmF41NDPJCtRYls59roKcNQUfFSdcYt6lcDbEwQqrptRRbK7Aqslxy8nb8/PZNHWUgwRYbpR7EDiAjLPyqpRMenqN6Em2Wc4PpvDE36CM5+6EHInCrG8UF7F77RTNQUJwwDVsqcBY9ZHaRKhHJ/gqvRvY0QkeZccToNb58z4tIdBzE1H99HFjMYN++g0IVBS1iDZhcymELzs+cuUpn4BhoDXusHN2AZ6ct/KxB3GLBCrEBz69kamNJwFZ/Zo8+QG+7ntBzJB/Jm9Kz/mLF9h3bmVbzgZPbRCo+GVOW1i6uy5yc0uDRW7oGierwKoZ1L9sYCWwAxiaM2Prej3oH7P6wxUfmTWnhltwFZyO12kfdqPhKxNYCTxI+mFbCrcgSsyZxjZ11h54QpYZ5+0gp7YUwg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(35042699022)(14060799003)(1800799024)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pUSEDGkJg6yDRO6fFyaGIb8fNHcy971M8tBhWxS/N6sYBOkgnCIx7bRvOpJeRlHE9dKryitD5etlyKhwqxBbPOi/g4zVtLH1yCBKUoSfi2tmOMmezr0m3/EpdK5binYEPRIy+mPf7MHllkWCAEaN8mJjB3a7rgAB0vEvvIYw6RfdY4YhYJiVcCADF3rdiUs22h5t47ilCssrGT2ft6QznKqlVCAk5dD6SBnPGwmQzsclWIoisslK1cxob1aYMixWAPiv96HAxKqMxg/lZSY8NxnhEoNE+KJZlo2yHHdROUQFSGh0umqPgJvAlxjNOUUZz/5F952jdOigQqI0CtbyHu1ZuG6MMSJs9Q+ZoLNR9A64Rt82rdjoQa13TokdQJl+gWe2x4kItBXalItnsGi2JJalsXWb5v5RCMQ3NTwb4pedZE3HCYDrLNhbt5cI3BQX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:20:18.1388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a05fcbd-7d20-4e01-f2b4-08de8fcfe42f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9223
X-Rspamd-Server: rspam12
X-Stat-Signature: bpu7e738on5cqyncwj7otoudusomju6o
X-Rspamd-Queue-Id: 79DE28000E
X-Rspam-User: 
X-HE-Tag: 1775035225-175590
X-HE-Meta: U2FsdGVkX18FJJzrkMNPkxwEwaIxLPqDO6wkF4KfwLz/F4midObHeyzvUq2z8r/Ya6S8ETsdbFe1HTwhNnlapxjqJ3UmD/0We0+xnc5Wpe9EtmQeqPL6UMcEssx36tc+8KL/UfggplaRcrxGXY3XKGBEMY0PhoUDWhZsSrNnOz9y/Lb4uxScIltOjQ9fkKv1yu3otIm9FHju6nZ0a7q3AVQNPJ8b+pyJGNZdZ1s7SS1oiJGUQbviDwHYSqfPHX/C6hb5XQdSQfePBcj/oT7EwG2rQC43mWFw6Qf/EfNrW1DsW+4zzOPqQFcLxDQek03hSpstxNGKrbTlKnH4vAYR9fsNLL/exhLsj38vinkhpyI5DaJCISNUWPnOHX2cpTq/hHarx0yQKU+N/jsxfp3YQDN9SnQLBo9nanaz8M4E5kj5r1nB8SSSZJmyJniq/iYycDjUeLF3FXKZrD4Q+5KzgLactzZYHPqkYErfsfjASDt8/h1JXR68/BtffjKTX1wa45kp2DVyYqGONi31cVsaEcS5x4bbk/C+LVIti8iqjEZPmp0DTeYjzxOFVQLIriCop+pC4Y5YPtnXbkE8DorvmEb15BVu4NnkYirHNqcvQOF2t+DQ3PWj4FDL51d0ei6fXiFPk24DE8ZHsvHBhGgRv/YTgtbJJ9s+3gfZ0lbl0Mve0Yp5KCg/owwS/iQqJCNW5BWMX1o+95bb5Yb2kjkxkkAOSraa62MX/2oRk2f3FtR4ZfR0vj+cIEy7/wFOQkavfZUPC4gYKikJJGKf6+TVD83HkqJrFZ+5lsFyE8fCjM8VT3SATUyU5X2R/EOgnRd4oDX5nuW7GWoPtTU8trhtmsBkZeRLKLrFB6CzDex7kB7b5fhke3CTN4E5n+xdF54ibHKhbZhesewR5Vz4BF3LzRr3Bty2UIy7tbIXy2gqg/Z0u0R+GsIrA7jZMbdQ4+aDcIyPlTi9XBrLuwETCx2
 rVoR4Ouz
 62wYXOyey4oDSQDWs1MfcOSlz2Vu+pAomR+dnBWppCRdKnfz9fuNUjR/thai0xPYvB3crIpKXd73IZfciv4N43aJ/3hR8cnrUt92LZ7QQRFpKZFoG1UX1XGdVtARnUACZqdDEZllgiwvszD6nbpULAtyReuD362hSlwUcILNDdmKE25Ff2xwG4CvnFkWZTIlLsXBCkD1R0nxfC5ZQ6ohOJKX4zAoVg56WmNRPIwRuNC/tBgai2yno7Hxmy0ybfYmrfIJqO5JL8Vq6iJga7YhI9/bbq0eWTzDqQvTXDBzXA5DjWkvcQc1PQQn/8E3wW7RZFRlvDA1z376NxUxi9Io2+lwkrHykoukYuS7JF3R+oPpuhHm+h2uGgJMXn980lQFREIi4FcrU/vHWOY2cIOl7zm0ipb2e8zukrAiw39dGgH8oHtrhn55DbGDHfmf5hDd8soy6sqHQdf0jtvkkQk3OQDdj9U/TQuB/DVIRDdZLLSG1d/5jODKFkMYiwrPP+6WLrCqCakP4gCvDZVfADRc7cGfduW9Ze0KeCduVNpQ4BsO5z1cb8Mxvuaa3Pp0xHBaAB4P0nK/VjnVv3bog4qJfl1AajFBdkwo1W7LuImuCI5ws41ysjaL4emLPxWbyWQHp7n3e5hA3rH3wFqrWaDb+GrYSSGfIZVzoaGWgI/y9lmXqDg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/03/2026 5:09 pm, Zi Yan wrote:
> On 31 Mar 2026, at 11:21, Muhammad Usama Anjum wrote:
> 
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Decompose the range of order-0 pages to be freed into the set of largest
>> possible power-of-2 size and aligned chunks and free them to the pcp or
>> buddy. This improves on the previous approach which freed each order-0
>> page individually in a loop. Testing shows performance to be improved by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a
>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order
>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each page
>> ending up on the pcp order-0 list; memory remains more readily available
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it aggressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently.
>>
>> The execution time of the following function was measured in a server
>> class arm64 machine:
>>
>> static int page_alloc_high_order_test(void)
>> {
>> 	unsigned int order = HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i = 0; i < 100000; i++) {
>> 		page = alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 4097358 usec
>> Execution time after:   729831 usec
>>
>> Perf trace before:
>>
>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>             |
>>             ---kthread
>>                0xffffb33c12a26af8
>>                |
>>                |--98.13%--0xffffb33c12a26060
>>                |          |
>>                |          |--97.37%--free_contig_range
>>                |          |          |
>>                |          |          |--94.93%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--55.42%--__free_frozen_pages
>>                |          |          |          |          |
>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>                |          |          |          |                     |
>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>                |          |          |          |
>>                |          |          |          |--11.53%--_raw_spin_trylock
>>                |          |          |          |
>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>                |          |          |          |
>>                |          |          |          |--5.64%--_raw_spin_unlock
>>                |          |          |          |
>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |           --1.07%--free_frozen_page_commit
>>                |          |          |
>>                |          |           --1.54%--__free_frozen_pages
>>                |          |
>>                |           --0.77%--___free_pages
>>                |
>>                 --0.98%--0xffffb33c12a26078
>>                           alloc_pages_noprof
>>
>> Perf trace after:
>>
>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>             |
>>             |--5.52%--__free_contig_range
>>             |          |
>>             |          |--5.00%--free_prepared_contig_range
>>             |          |          |
>>             |          |          |--1.43%--__free_frozen_pages
>>             |          |          |          |
>>             |          |          |           --0.51%--free_frozen_page_commit
>>             |          |          |
>>             |          |          |--1.08%--_raw_spin_trylock
>>             |          |          |
>>             |          |           --0.89%--_raw_spin_unlock
>>             |          |
>>             |           --0.52%--free_pages_prepare
>>             |
>>              --2.90%--ret_from_fork
>>                        kthread
>>                        0xffffae1c12abeaf8
>>                        0xffffae1c12abe7a0
>>                        |
>>                         --2.69%--vfree
>>                                   __free_contig_range
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v4:
>> - Move can_free initialization inside the loop
>> - Make __free_pages_prepare() static on reviewer's request
>> - Remove export of __free_contig_range
>> - Use pfn_to_page() for each pfn instead of page++
>>
>> Changes since v3:
>> - Move __free_contig_range() to more generic __free_contig_range_common()
>>   which will used to free frozen pages as well
>> - Simplify the loop in __free_contig_range_common()
>> - Rewrite the comment
>>
>> Changes since v2:
>> - Handle different possible section boundries in __free_contig_range()
>> - Drop the TODO
>> - Remove return value from __free_contig_range()
>> - Remove non-functional change from __free_pages_ok()
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>   fpi_flags are already being passed.
>> - Add todo (Zi Yan)
>> - Rerun benchmarks
>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>> - Rework order calculation in free_prepared_contig_range() and use
>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>   be up to internal __free_frozen_pages() how it frees them
>> ---
>>  include/linux/gfp.h |   2 +
>>  mm/page_alloc.c     | 110 ++++++++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 108 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index f82d74a77cad8..7c1f9da7c8e56 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>  #endif
>>
>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
>> +
>>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>>
>>  #endif /* __LINUX_GFP_H */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 75ee81445640b..6e8c79ea62f1c 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>  /* Free the page without taking locks. Rely on trylock only. */
>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>
>> +/* free_pages_prepare() has already been called for page(s) being freed. */
>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>> +
>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>> @@ -1301,8 +1304,8 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
>>
>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>
>> -__always_inline bool __free_pages_prepare(struct page *page,
>> -					  unsigned int order, fpi_t fpi_flags)
>> +static __always_inline bool __free_pages_prepare(struct page *page,
>> +		unsigned int order, fpi_t fpi_flags)
>>  {
>>  	int bad = 0;
>>  	bool skip_kasan_poison = should_skip_kasan_poison(page);
>> @@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
>>  	bool compound = PageCompound(page);
>>  	struct folio *folio = page_folio(page);
>>
>> +	if (fpi_flags & FPI_PREPARED)
>> +		return true;
>> +
>>  	VM_BUG_ON_PAGE(PageTail(page), page);
>>
>>  	trace_mm_page_free(page, order);
>> @@ -6784,6 +6790,103 @@ void __init page_alloc_sysctl_init(void)
>>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>>  }
>>
>> +static void free_prepared_contig_range(struct page *page,
>> +		unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned long pfn = page_to_pfn(page);
> 
> pfn does not change after this assignment. That is why David suggested
> prefixing a const. You can send a fixup to this patch to change this
> if there is no substantial change needed for this series.
I'm going to move page_to_pfn() out of this loop as now its guaranteed
that they are from the same section. The page++ would be safe here.

> 
>> +		unsigned int order;
>> +
>> +		/* We are limited by the largest buddy order. */
>> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
>> +		/* Don't exceed the number of pages to free. */
>> +		order = min_t(unsigned int, order, ilog2(nr_pages));
>> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
>> +
>> +		/*
>> +		 * Free the chunk as a single block. Our caller has already
>> +		 * called free_pages_prepare() for each order-0 page.
>> +		 */
>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>> +
>> +		page += 1UL << order;
>> +		nr_pages -= 1UL << order;
>> +	}
>> +}
>> +
>> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
>> +		bool is_frozen)
>> +{
>> +	struct page *page, *start = NULL;
>> +	unsigned long nr_start = 0;
>> +	unsigned long start_sec;
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		bool can_free = true;
>> +
>> +		/*
>> +		 * Contiguous PFNs might not have contiguous "struct pages"
>> +		 * in some kernel configs: page++ across a section boundary
>> +		 * is undefined. Use pfn_to_page() for each PFN.
>> +		 */
>> +		page = pfn_to_page(pfn + i);
> 
> page is local to this loop. You probably can move its declaration here.
> But feel free to ignore this suggestion.
I'll make this change.

> 
> I was about to suggest make it const, but put_page_test_zero()
> and free_pages_prepare() do not accept const struct page yet.
> 
>> +
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		if (!is_frozen)
>> +			can_free = put_page_testzero(page);
>> +
>> +		if (can_free)
>> +			can_free = free_pages_prepare(page, 0);
>> +
>> +		if (!can_free) {
>> +			if (start) {
>> +				free_prepared_contig_range(start, i - nr_start);
>> +				start = NULL;
>> +			}
>> +			continue;
>> +		}
>> +
>> +		if (start && memdesc_section(page->flags) != start_sec) {
>> +			free_prepared_contig_range(start, i - nr_start);
>> +			start = page;
>> +			nr_start = i;
>> +			start_sec = memdesc_section(page->flags);
>> +		} else if (!start) {
>> +			start = page;
>> +			nr_start = i;
>> +			start_sec = memdesc_section(page->flags);
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_prepared_contig_range(start, nr_pages - nr_start);
>> +}
>> +
> 
> Otherwise, LGTM. Thanks.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
Thank you so much!

> 
> Best Regards,
> Yan, Zi

-- 
---
Thanks,
Usama



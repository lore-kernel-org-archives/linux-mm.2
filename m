Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2337FC531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244196B008C; Thu, 23 Jul 2026 13:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B4C6B0092; Thu, 23 Jul 2026 13:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE186B0095; Thu, 23 Jul 2026 13:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D15CF6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:07:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6601FA124B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:07:59 +0000 (UTC)
X-FDA: 85020673878.24.BC64104
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	by imf21.hostedemail.com (Postfix) with ESMTP id F16E81C0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:07:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hjJYpn+b;
	spf=pass (imf21.hostedemail.com: domain of nirmoyd@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8mMPg9TqsqiVxPJ4y9PHkt6iPNPmFCEuITfesVev98=;
	b=CTCXa7APSsEgxWSIeQtnJ1Mw/5OdG8De/oRfJcYDwy/qyDAgn37/Xsz226rcZ/XZ2K2nzC
	/sr75e6my2nynjVaagTOWPixPjjOHS+/wgdhfTFU4hfKRdtsMzLI89nHEHu0KqR5HkIsCx
	j1KTjv4UxALiRWB+ubvQd1GS78U0M6A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784826476;
	b=yuccvYnljFWxMsFuNkSFlzg3kLOUhp7O3CEefGP0aWyK7/xELC9BZCZLfR9V4HGs06y7fa
	yTDJsSkH9xixZ7ndHV4teS+MQwVvUW60oU/MgarfQfmWqxw9k1kyr6n6IkghgbOOTlI5GV
	zawc6wTXQyYVEckVfNw4UDJX3uao+B4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hjJYpn+b;
	spf=pass (imf21.hostedemail.com: domain of nirmoyd@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=nirmoyd@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2ud07hPP3FKF33wavxYM1WLdmCBs35HVeTIIZ+XXiyfFxltssl0Lb/HHS2EpqCWXHslsC6GYR/zS8vWE8F0nixEjSVDZ2HvqJeUsaXhZZG9fm1EqZ+kvKuWZTjT5kgJi/cta9QcUrSeo5T3aMVeYVYOGfOlwxQ5+MyZ9CQvBsb9ofwnngIuwPsvBxqC84fQf5CZD/aYz819vDr2w+WxCNOZvFYE+tIlQlBvh0BteL5Yuq1gqsQwqKhOiWwD5YEL/5vq2xgnke3hIYqF7ZYPojG/tPxi30oCVUWXdnS5DDJMLS3YMlycF4Rza40ppKpe6X9hoempTgHotiSFhuz73Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8mMPg9TqsqiVxPJ4y9PHkt6iPNPmFCEuITfesVev98=;
 b=AYXSy1npPmyD1rodXtybJanAdgmF2S0OhQ5Ml4/8S+RHFji5HeU5zL5TfGOdrMv52yHmvedSpVCZzvrtgmwOK5OCWl3C6x20bMZAde8pgmKjulsaKwngoPk+S62OxnW/SR87WDGpBL04hbfQSJwLq1NL4UV4MlOUZ4ttYfweZpPncFk3lZhBPaiNJk3/GkkLvhHmQ/SYZPYOPDD6sZ8fT1G0tfDoh81NyzLs0ANS0oZEtPdfEqrtO2+y2IiTEoaKIXH9UMCglJMJK8MTpjfsXG5aSO9Ef1aZFfzwNaH/C1Iiyqr1smnBXAWTg3ZYD4UqMTxtaLkIsPPsR5V8HDCWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=efficios.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8mMPg9TqsqiVxPJ4y9PHkt6iPNPmFCEuITfesVev98=;
 b=hjJYpn+bHBje+CvG9pIodiPUg9CIwkcOAPcCePC/oTb0wdb+sBhLylxQr3sPaQGiG/q8Qhte9Jznv3NhsbwozoiuOS3/N+/dUGCGpbHhnyVZmoj5ixASRReHl+64R/QNYA1yzMfy2XRhlL+2f3OrkHg8EuqqaAXYdV2XdjMmoA9TF6fCZEEluuNYh3EuOEfiS1kUFNao7oGML3jwrG3Gbe3yiDqTJ/tlBScuaK/OEkea68smUBE9MiD1A/9p9MwLjodzhXivEvvDQFdDYGoCrSRwu1KwN13zlkmFvy+k4wbobjjxhv76mCP2WArstJFz3NCklkZ1L1oQBZAkqY5QMA==
Received: from SA0PR11CA0158.namprd11.prod.outlook.com (2603:10b6:806:1bb::13)
 by CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 17:07:46 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:806:1bb:cafe::51) by SA0PR11CA0158.outlook.office365.com
 (2603:10b6:806:1bb::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 17:07:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 17:07:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 10:07:23 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 23 Jul 2026 10:07:22 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: use precise current RSS for high-water accounting
Date: Thu, 23 Jul 2026 10:07:08 -0700
Message-ID: <20260723170710.1971749-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <21d24fc4-141d-4957-8b96-6d5887ef4027@efficios.com>
References: <20260723134158.1473841-1-nirmoyd@nvidia.com>  <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>  <20260723162133.877125-1-nirmoyd@nvidia.com>  <21d24fc4-141d-4957-8b96-6d5887ef4027@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|CH3PR12MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: 56084cd6-7443-4dc1-95df-08dee8dcea76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|23010399003|1800799024|36860700016|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TWdR2aQ9GucmGQenFMYqhiKt8bnelePiwY0BCWmNLZ4XwidGfa15/WzYhfbWlmcz6kkwJW+XhCG26gl40AvmlFnqlR9uszzO0qFg5zyIRS+dV08obkLb9YKaAQaw3mbl1b33YfNZyi7rOvH6P8gve9a/vjeHVnYLHmu/nlMIfiVVsMXQaCs3ad+HNA+pNe3OU5kMWkxi0oJswiUrnMufMPo8TxINljLpc3rxfF4GuQhfPb1DhPndDQbr5g7p/KNdZcBdsIBZwPtx53lYBvyLDqgXIO6nsKTaDGiesv8rLAXv7pkAT3tbZeikREmxBzVS6enSYwBjgOHdNlhRjv5J8al5eJuePM/a5qpqQxtrNFjrbuQr3h1wfbqO+AtfBIViUsAFpi7rpEmJrEOky6+KuQdME+9k94F/wcByYm19UV5wy/5W3Rf6kKNeJBOppVSs0Oq1mbuIxugpCRYcua1HMzUS7/Cccb2YQbFfnHjOzSBgDoy4KVfVDmoCIR5ET5Sel3e4KAUH9e5WbhXq0TklfulmDPQbCd9mmnI4A0hhea+anQfry6FOAWXE1tvG/3SbmcUay5zKAaZITtGtDkca6UWcnRD0lY5jvYunBJYiHim02SNGZFY5rvug6TSRGr0uxVtnI0fHbJ/lnkC/AUzQQ8Q8iTVVDPXEENfBNFTbfPjl8gZLlU4li6JK45TEcJc9GzANGUH9dgORmMVhUzFyUA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(23010399003)(1800799024)(36860700016)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	foPolEPhmvRd8a5kJOAgM1uqXoLaOFLxW1OXuP1y9oqXR6Weq6VsYzANDYO4uZlyf9WpR9j8XKgxfE2X78eKPde6mGGwg64ypo8HCkNdnncmTT9k2Js9qw6K36uP/5GyB1s3coZhQExlQ1Tt6zBu8yrG+a2oG3fMmVXd3s7NplKaM9k1BogbtgMWz8r6nt1cnF2hwADS8y4KNvLnKV1WycrUXK/60nkb7MNpWH9GLv9I3TJuBCZ7A76XtNtQc5Ji+fQkI70wpnoJifO2ViuVkbGnZZEpWLJIK8FihwMndWiXC8UyeoFELzzIS+RXRePS3eBUvOufRENv54AQiyxIAjT7nq5uIKjn193v14ejJtf6kzhZ0uLzKSq4c1EgOPeDExos09bU7Oz/FsojGRPkpondfzfnvx8Ucpumli5r2Cfz8VpIdVl0pwQVoAncawzh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 17:07:45.5751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56084cd6-7443-4dc1-95df-08dee8dcea76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8660
X-Rspamd-Queue-Id: F16E81C0002
X-Stat-Signature: y5ty1wbcbuaptg6i4xq4ny1c8xgidjy1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784826475-830636
X-HE-Meta: U2FsdGVkX18L/mhniJxkul09rb5JBxCTdbBGLLVwM/qWlMFtNRqMga9jKls6kBkj7dt2etyffjvbae8xiRsH1uSaqPI7AEJUMiKaKr6XIKTVGBd9WIxOuawQB9l0UJBkJAqLVm64vcLmLYO7+dQOLlhgFFj+nxB60lgvlRmE7S/cKkrdjRhoOr8pv05ALF5miCOs9uKqY7/6WsAH65uAmW4oRsEFrnSAEjLLHi7nVjH804DnN/ryOCIbuykz15qlMXa5ai09pwB5zf52D6cQJ267JwMWWzQ77h0m0LH2bp1f5Wa24he51bpzLUHpjqxmoQQvdYeSPhGwZxSE0AJg2cYjrJQ3k72AMGl2ZWafdftK89MzgHSJdXIBAEIPDmimyKaj6hSo+ircjocXq8J7ENSOiDS7xyBZp0348Gf9uMoT/JhmO6JDOhDaANF0ohA0OuTnHjYIERStWLzk7IzbycCCcSTUfHWA5BDANvYM+WGV9HP2uvzz/O1J+TbUJCpmMHL9SD1eLXx86hSH4kq1XA6lmkntHOHJc0L6GuQBAELXpHSuNVdqujnMBFMHco44BI/pZgEKS8vFoQ/vIbFLVwOcDrqMUlsHspQr/FE1r8VlgpfrXFULrf/R4F62CFMnQdNHhSi+66dmVWLpgOVAbKndQYzZfcn77lVeo7KPLeA4cSBXcw8rQkGOrhYSLdo2YQipd2C052WZqJK6DOIL+PnoY4t4zaYcytlpJ+oDRbL6zRuZnIBBh3HrKm5OlE+A6eunR7sqo5ryWD0midnoVnZm5ggCYdYJiZxhVjJGh22BDX7R+Pk6iR36vi99/H3IfbWtOpeJn6UC87DT5X6uZo2oPCvMTylDCrK9yn1Qs57VRkBwnHwtKRE1RWRtUbUyoO8IixQEqj7jOntA0IhSVnrRCArWeF/mxzxhvRAQAyz4IXB/Ki7/9evJsSW7j2/ObtscQ8YaKAt1Eqz4qtU
 sWosLHSe
 E4EkoCxPwnD/I+W4aLhO+D49Vb1zYEjZHh+KLsYlwSy53MSBTlkWDSnfOh3O9OHkxn3QPtz2RCN0u4pjx451IpFB3oYAGORgeW1vhpcB5mkhBRFVtaBMNqLQnRTPeKTgF3Gn8UmiEr6VxjGbvfU5tAvBbIFCpdHgwPckv1E/jH5RthuxSZAO/T/L8xwEa1y5nbD160qlMWJJNJ3fqC2HoV6Z+dwDHzVnGIiH4xxM6NMSQAc3bxXQi2xTh4tiqOX+FgUwdDfyVD2fYY0ubGseJgIRYnQ+cS8xcX4C0cuJXyxecEPy1CxY4JtJhapP0NM/8uWrvMXhJI6gfClr/3o2SCKSLZYkGsx02OC3OSIuIM+JCHcmFEwvS3c9f3hKYWnH9GhSSx3jEp5E/8PTQ4fFIhu67gLKtSIHyKsf8svFG0LIhIMGWxjOQgrubeB/DWjphFXaL6rSEz7GndKOaaq+c4rEwUA3vNzw1pjryxEOQriEwrR02IJwyZWHcSwzbVzm0NUGt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,=0D
=0D
On 2026-07-23 12:31, Mathieu Desnoyers wrote:=0D
> What is this test validating ? Does it actually matter for a real-life=0D
> use-case, or is it just the test being too strict ?=0D
=0D
It tests getrusage(RUSAGE_CHILDREN).ru_maxrss:=0D
=0D
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sysc=
alls/getrusage/getrusage03.c=0D
=0D
I am not sure about a real-world use-case; I do not have one.=0D
=0D
> What is the overhead impact of your change from approximated counter=0D
> read to a precise sum on this /proc ABI ?=0D
=0D
I have not benchmarked the overhead yet. I will get back on this. =0D
=0D
Thanks,=0D
Nirmoy=0D


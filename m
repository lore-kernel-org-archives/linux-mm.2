Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD42CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8106B0088; Thu, 25 Jun 2026 06:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4717A6B00A3; Thu, 25 Jun 2026 06:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312DE6B00A4; Thu, 25 Jun 2026 06:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3A9E6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:51:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C0609028F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:51:42 +0000 (UTC)
X-FDA: 84918119244.19.4981A2E
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011014.outbound.protection.outlook.com [40.107.130.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 459524000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:51:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nIGy4sBU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nIGy4sBU;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.14 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782384698;
	b=zh78KG12wFy5E0hLaEcS6HOOfgvEE2OrYv2wEFVkuNuWTMSJnJ8NL2L3s8kCy501QxK2Pz
	RPAzMuCNHmmLb4IdqswCxsW3qaF6oJRCP35l/eOY5Geo66anoI88EOKmZrFZfoi82iUoya
	xR1zfoMImYtIt3MBJnUclRakopRKIoU=
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782384698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRG8vM8YsKjBBjrZANkboyr0K9yL5W1CpjHX/qZYyAc=;
	b=LwCUCkIKS4DnSiQ9ZtdZ67HnWRaKU6POa2yoOmS8600HihvVI0PYPNs4OrLaQ8FOJaLXcT
	vq21wiNlBbqgYlsrHSUg10kNPoOQr7hX9RLE6LrAbc0vAFm7LxAqHavy2qFciCRJD93Ne5
	AkpT5tv6b6Kf/Cz9/xD6tS0OkY3Y4UE=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nIGy4sBU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nIGy4sBU;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.14 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TkBPeP9by/KZkLg5wN1EX1buXs+4RNDjtLp185hMQdmEJP0q/NjoJh29H7JebFnNqHfn43yOrSzKifY7Yq5mx+p7RxKUHY4iQdqKlidM5Dgc8nvw2PicB7BaA7uKDgEtywoM6WX/d5jN6F69qn63g6XoEYgM8o4QQ0rc9Oy+uMgd0h9JMgwksaW1TAihf1AEw6Ku5evx2sE3kqIHbXQNI8qH57Q74pnNa9kykjoruPAAr/3ZZZebHfPl6G11MWV1+R+ZaQbolKFNgdR63j8/fOXBuVard7P87Ki91BA8Pj/NaEBI2lBrO0wpPizVuClRLaFD3ynIZUwwk4uj/XEpCw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRG8vM8YsKjBBjrZANkboyr0K9yL5W1CpjHX/qZYyAc=;
 b=rjiFinU4q22O83wYfSj/ho+Lkvg3BBOfiq4SPoixrA3M28Lt3uoJb9u3ych/RtfE7zotgA+TiFSyJoIwbZmdkt0fb0adZK+KvJn46Z5I52Yv0EiUX+XkTogQ3TaiV+iXLl5jievKT9pT3mAmsy9qjRU1bFKTmbJVLNIpOTgipDGBXJsEk4kXj9P6IU1Pu/wTqXQhWqdw0xyUan/s17+dmSp5+RebALQXrb4+bBUxnJ0DmQyiNQWnC2KTzY+trk7Izgxof6LMBpkABpy38hHhrLb69PSO/0yW2Gb01W3mH4Pjj16/JqtfcOdnuXIYHt7YnmKflOpXsKehAdVNHe5OmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRG8vM8YsKjBBjrZANkboyr0K9yL5W1CpjHX/qZYyAc=;
 b=nIGy4sBUaKcMlvAqlXvGYa5XCyQPmck2Vej46817e6kBrZ+ObcTVv6bp4Ta76zd4qRYjWK1Ryrikoug40F2ccW4wnNXErV7x7x8RvhKGAZlyHx0Vzo8dnlx7kFmCVW3cJC1u2ClaLu0YJg1gJkF2SWK1PRvn1WVK/owQofIjxQY=
Received: from DU7P195CA0027.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::20)
 by VI0PR08MB11020.eurprd08.prod.outlook.com (2603:10a6:800:256::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Thu, 25 Jun
 2026 10:51:34 +0000
Received: from DB3PEPF0000885E.eurprd02.prod.outlook.com
 (2603:10a6:10:54d:cafe::ae) by DU7P195CA0027.outlook.office365.com
 (2603:10a6:10:54d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.16 via Frontend Transport; Thu,
 25 Jun 2026 10:51:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885E.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Thu, 25 Jun 2026 10:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEM5/h3xhGvqgZGgvU4Bx6K+hpQJYp035zzc4khm7pJMz+8O4f+skcXoutaVa9GeBfZUodGD7nr1cY8k/FbX3qljU4HCtR29zz4z40LDuniF+Nsm3mRj4R6c5C7ThLkeM9X/MqiobjKqRFmKWqqwzEbUmqBAB2MlwDDCMWIttsmvAJ0eV0fXdwVJz1wBsjDwscXSI/6g9rPewO+fumiew20qSbdU2q4SYvNcNVO+sgA1jXbkaoOyb35Hulb5FaLtciazwU5I8Ii7cccBMohr87MxF+EAXY0ruAc+2CvV+gnoKhSvmoK9/uG9I+5W/vYQsr9BlsDCaxlYq1v5qrJ7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRG8vM8YsKjBBjrZANkboyr0K9yL5W1CpjHX/qZYyAc=;
 b=Mt0PSx9kVBAxL1tJQ/A2nXIAQL7bL7gUyav1Js7u84D7wN0e62c73+Ck/n/xue1yCl4JRfwg144JMLZ8+RJ7gWZx7SPqof/YDBC1rBHG3cj3riW8rEvp2OUxDwIVPi5nQmwQgAcPZl7Wcbu64Iv9xySLzXFIlUJuth/VsH/l6RvQTZs3+aQv769XM2i3wx3h3yKTi9b75ViOSG6LTuAwqs2Bu/CKW46ZOxomsQy1az1/rXxmkXI07ctJKc6XOH3xUBnlduUHBeqwloqpWcHGfEvL1a1SZ2YKlXK6l9Kr3N8hOMXJcXhRKxTsJlYqVXxMdnlRj+LtXCF8jT7guFv86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRG8vM8YsKjBBjrZANkboyr0K9yL5W1CpjHX/qZYyAc=;
 b=nIGy4sBUaKcMlvAqlXvGYa5XCyQPmck2Vej46817e6kBrZ+ObcTVv6bp4Ta76zd4qRYjWK1Ryrikoug40F2ccW4wnNXErV7x7x8RvhKGAZlyHx0Vzo8dnlx7kFmCVW3cJC1u2ClaLu0YJg1gJkF2SWK1PRvn1WVK/owQofIjxQY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DU0PR08MB8230.eurprd08.prod.outlook.com (2603:10a6:10:3b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 10:50:31 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0159.015; Thu, 25 Jun 2026
 10:50:30 +0000
Message-ID: <66310292-f618-4497-bcaa-2a4b1240566c@arm.com>
Date: Thu, 25 Jun 2026 11:50:28 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
To: Pedro Falcato <pfalcato@suse.de>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <ajwuKpSnElvwIyhC@pedro-suse>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <ajwuKpSnElvwIyhC@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0183.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::8) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DU0PR08MB8230:EE_|DB3PEPF0000885E:EE_|VI0PR08MB11020:EE_
X-MS-Office365-Filtering-Correlation-Id: 7030e21c-0170-4171-569c-08ded2a7b946
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 foU8v1wZ/YNMPwf4B3ScSsXRIYBQSOx2I+NOK23w2w/hDzghnPf8N/65X/TDY2iEBOnm5Y5OPJsofbSKBZ68ONT44cmBQyM5D2IGNXtbm9MfboYfxu1+GtCBprxaWXaUJxQjCfPN1DmcERXwGgxdBUSAvNzLsChkeNi8bf3HTYbH+YYeY7c26G5GEI/iYpWsL3K95KvPj+VeyblGmHfW3F8ScCUuUcS25eVqRDqrIYiYkYEIsPmzzIQO4TDDNgq2za8wuMDQL4dfQ8ds3uPekChATJCyOSMqYj1ABPTxRoz5Kd4SE/z1O2gQgbZEsfqfT8xJCSUNu/3Veetutk2rgb99aLZnfaoe6gryN0W0uzPzUahUgcvdgzAkcuc68Gad9moD0Chbm70ztBoannNgXPYYzyqfDGXF+n6z0HBGvyYRy3vVj72+09jid8iJYWmQ5lmSYKOWgxEoveo2O529LkJjIOxmhynQ5OHA76FAG0gmnLaw6pQ9gMfbIZ1E5ddCxytP+EnDSZIwZuq0841TAasBWdPhPVJPAuMoiaxdpcq0U5bUsxV8SxlLyirnYM2oPOeWMGN7Z5W7znldsFPiGFQsZtIzH8CMYBPEIx2WDlpjKtGbimycaLEEEzYKDmk7RSR4biM8gwvNpRpcSjuFaewyLJz6076Xa59wTMaAKO0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 cqfCQpjfWiP2KAnfJbApecCS7CTif7qrlVi0pmuAYBYOl9AsZqPvlnS6zbE/1p1rR1LQMWofGl1c9gNLvCpPUBuBToow3B3yUy+JyKwFg0uFPNG2c0T63MYCyIXunpT+ZQel+B95SKOwPPE0iQ5KICm2e3YdDZHyhEZZeDG4o/EstKWbNJuLyRdAbpsM4iWT7XTekAvD5PMcMOGssiXpWFMO0OT+C1TvaacB5WMfZeoR1LITPkY/ksPnT5t1KdhZ1CdqtgnOwStLBwNDv9tv5TCzs1YEgSch+WaPxFEc0VwzMbw8Q+S05JQc1cOMrYIHfpiE+ipbk9qD+V7lmestBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8230
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1a67c32b-1a04-4a23-663f-08ded2a792fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|7416014|23010399003|1800799024|14060799003|35042699022|18002099003|6133799003|22082099003|4143699003|11063799006|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	2YqYVyhQCwQy0+jf0TzzxSljyBel/7xyYwEUNVIdiTspF+iXBoMixfCXDDraeKa7pm/XU0xFY4sdYXaVOxJcvr0XIJijnyWTNNRY5fbzIsv3e5fTaSXO5TjNqHLjJfCObLrSyEJeGkC/Z/g7yKROkLeNdnibB1TfVeC9ScK4SvSt0FdGVwZ/CvoFjkJJ6kmTngCo/7grcIdgf/5vGaGhJ1qafTolCezqAqJABBt9H2rZMPVyXKoZvtTNk8Ay5oKRyJLmrIxSzHqq75geeO9HSaqbbFusBItmgtyKcFqCPCRGugYE6ONlccbqMRJqc8H1Ym4hN7z8GmFQyRvk8GTLEST4Sz70xsCCibWhakLXHp+UKDqsyYu2lkJ1hQk/Y1nCBIJsZggiUHniTZhE6sk1VzGNpvdcNoWSOCJd5Lk3kY9Guenv1ffjeam3QCuK7UXmgaAAVgP2JvGOkIu010BpXuwa0KCqMM9C3BENCcuvvXqvUvHqLSszgG+pyoGn0ntRFBftvAlXNftQDtcqM1SlaJcXpn9EYtc/7enPfPZ1v0IWW4lR5DPp4j6lpVVb8uzAR9GcnYMpNANZErMgsYmNjVMqTJux9nM9k6vxtvxLPHYKv4hNlsRbmo6Jog1VC9rixWEHCE2noqohXR9F/PvJJofF5SHj12qBi/fA/IRfRb11xUGbGB5Tvny1eQ9bzlib2KASByyLcHVenKsrIhSu5Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(7416014)(23010399003)(1800799024)(14060799003)(35042699022)(18002099003)(6133799003)(22082099003)(4143699003)(11063799006)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jLhCvaUcm3Mwqg9lZ16HrApW6VduQq9SJcIOLAWnMzDYjtZAjMllfCI0a/hsIuC9t8dkX4K5Amyn+BiPKJ0D0aEGu1yYGKhP+93Ze1SP7kDf9SHE8d8fi6quX1pcolOgOqy8jDtOasGHNDqb2A79Ekb8+HXuVYWGfStldRzHwhaA0jgQ2ML2truWJOpX524M/unUi+JwuZYkBJ52lAmSJsLHjT4HgB+Ie0pL0+MDnd1DyiqcFhhk5WY+LffJ+BB0wE7gyqvLB//nZ4cWZ67tExstpjp9IEugbp6pk/z/XDPOCQtKgYFjHf2ZXkfi+VIwueNoIvoCiIbYV+lI/skrz2FZ9McM/G+qmB6pYU7zD8XJAIxDWcijrfdRvs30g8C5aXBu0bJRht7kKavTHKmM9hnlPby0c4STLf1Z98/PDRKqdQwcE/7ER1nhe+trfNkh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 10:51:34.1803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7030e21c-0170-4171-569c-08ded2a7b946
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11020
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 459524000B
X-Stat-Signature: oqzmeobjxmkjnhkpjo1rnf1kbzisxt4t
X-HE-Tag: 1782384698-671445
X-HE-Meta: U2FsdGVkX19WJSvRKr4Nd+GZeMi6HP1fkcTyCoga3MERMLJbQE4ZaZ/zAhr6poO0PkZWkvKTTm9d3OD2Rjv8PAv1pVA95PbMC4TewMpIc5VSJ2L9ywreWLCrRFkThNzzlvPCBcAAWoi3aHAzmItqEt5+NqVrc4Qg/l8UY384ROiuVaBJ9RSOSHoecyQpID3TK6RKsJfOIRrKC/IYZ7KEd7qqJ9VGE2kb+ciwZPcNg9CzQKfwTJ5ZBxZCERgDnB/40fEFsb4De0hpBlP+GHV4YfkYz29pROs2c3TnAF9RvEjBQphT8uPzXrMGxtbUm1VEzui4u/UGk3JERwXQxG+6ZRyZbzYD+SUoX8KyPI5YtVMhtNs2SIG0VlUqv48Vtr9FTpPnlvfJ2pzrQbrlgi3Fxh7PU3xj0j5QfWnLUC42NrjhisHIjVhaYGBcqRi5B7eSPgXMe0gxI01oNAqWOIh5xfTfmI0O5zSUCuGICqzOKYGS+dl2tt4LrCD4QUaasL1W0MliPePak0ptCXCAletGzX0OiPnM3eKhboQIVYoucwQ73/QhOcvuPpKfSFLkZA3pZDh40UA8K9KDieJRcdQlHBFFCrJnBz1GrbFWxlFxyq+arBU0OwIsS5llh3SGWMfLwi+Nx6x8JGFmdlyQh2lE/3RXB4yZY1oJ6oINOt7wEB75fsOcWRKiBn5zKyMHFEBr+t5Vy8G7htLhuvB5wFeqv+foY+RxCGO3YnMvXKUlxi2Q+eJcZ4Tg4RTU3I95/JsG97drwnXiouXMIRCoHklpsVXbRPhT31Siasl5Q7C6VFrPe+mZxJ1+vkjNqSGBLqwxfPCOESSB9FcoQJoGm5iKmmMlNhdGCSjSD04gNBJqbOzHjel7pgUSYUbqNw0JHPXgw4En3eDt85YEBOxzol2pZeNmSY+HtCaNkVn1Eqd9X2izDxObhqxByaUQKMauabZ0maOdLbPs4udQBs0CHkC
 zIvwhKYp
 +uyeAm3gqynPKMRCDxHFWICk8GuRAudHpAYiGxC3e5ezvOXXbto3GpIEnELlv50eS48rl6DpyEssQKqERqYKcCUE7idgIszFjncyYrkXY/cUVymlCWdL6qFuu4AcMvb5aSapGkVs9oNfHkCpbUzGVcifQ8vNri6Nzw8btLKALphD3TigMzERLyH/e9dxKl4uzWssQWAmwXQpxmFeoyhohq+gK+hMVtwQJcZKgiYk59z6gswi17wx4CWKBcSpW3JZhNE7XEAtRSezibrl1pe93J8+0iTvjl70xBuVfPB5Scjsgv0ZbX7lQSEnqM50kUWgj1q2IeC+yrpkrlOd+0CqbE/Qmr+KeYk3Vmm+YxSM2uWfPRmbjOgOtA6Qush1eZOWTJpv0O/8AtBtKoHwKgUL7N3zWHkYX91oCSlVVJxof4oI86D1QlF0nm24zGZOzbZTwLLLVxxURdweSgfQYrmYQHEYHIEd4cDGACYFP8A9sitaYza5Zf3EKffGZblbqkV8KpaVnBldOr2dyw0fUhwPdK1kSDsF5Ylh9l4n5IvI8pYUro0Uw0XBO1TzNmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/06/2026 8:25 pm, Pedro Falcato wrote:
> On Wed, Jun 24, 2026 at 03:09:08PM +0100, Usama Anjum wrote:
>> Hi all,
>>
>> This is a direction-check with the wider community before spending time on the
>> development. This picks up the idea that was raised and broadly agreed in the
>> earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].
>>
>> The problem
>> -----------
>> Core MM code reaches page-table entries by raw pointer dereference (pte_t *,
>> pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
>> representation. Sprinkling getters wouldn't solve the problem entirely. The
>> problem is one level up: the *pointer type* itself is overloaded. At each level
>> there are really three distinct things:
>>
>>   1. a page-table entry value (pte_t, pmd_t, ...)
>>   2. a pointer to an entry value, e.g. a pXX_t on the stack
>>   3. a pointer to a live entry in the hardware page table
>>
>> Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Nothing
>> distinguishes a pointer into a live table from a pointer to a stack copy.
>>
>> A pointer to an on-stack entry value and a pointer to a live hardware entry have
>> the same type, so the compiler cannot distinguish them. Passing the stack
>> pointer to an arch helper that expects a hardware-entry pointer compiles fine,
>> but is wrong - a bug class the type system makes invisible. It also blocks
>> evolution: an arch helper may need to read beyond the addressed entry (e.g.
>> adjacent or contiguous entries), which only makes sense for a real page-table
>> pointer, not a stack copy.
>>
>> The idea
>> --------
>> Give (3) its own opaque type that cannot be dereferenced:
>>
>>     /* opaque handle to a HW page-table entry; not dereferenceable */
>>     typedef struct {
>> 	pte_t *ptr;
>>     } hw_ptep;
> 
> I don't love typedefs that hide pointers.
Nobody likes them. This is the only way so that by mistake stack pointers
don't get reintroduced. Its also hard to catch such cases during review.

> 
>>
>> With this:
>>
>>   - a stack value can no longer masquerade as a hardware table entry,
>>   - a hardware handle can no longer be raw-dereferenced,
>>   - cases that genuinely operate on a value can be refactored to pass the value
>>     and let the caller, which knows whether it holds a handle or a stack copy,
>>     read it once.
> 
> Just a small passing comment: how about doing it differently? like
> 
> typedef struct {
> 	pte_t *ptep;
> } sw_ptep_t;
> 
> or something like that. Were I to guess, referring to a pte_t on the stack
> is much rarer than all the pte_t references to actual page tables. But maybe
> reality doesn't match up with my guess :)
We want to fix the current usages and future usages as well. sw_ptep_t can work
for current usages, but it'll not force the new code to be written using correct
notations. Apart from different types, another benefit of hw_pXXp would be that
it'll become an opaque object which only architecture can manipulate. Hence
architecture can decide howeverever it wants to manage them in certain cases.

> 
>>
>> The overload becomes a compile-time type error instead of a silent runtime bug,
>> and converting the tree forces every such site to be made explicit. This gives
>> us a framework where the architecture can completely virtualize the pgtable if
>> it likes; and the compiler can enforce that higher level code can't accidentally
>> work around it.
>>
>> It is opt-in by architectures and incremental. The generic definition is
>> just an alias, so arches that do not care build unchanged:
>>
>>     typedef pte_t *hw_ptep;
>>
>> An arch flips to the strong struct type when it is ready, and only then does
>> it get the stronger checking. This lets the conversion land gradually.
>>
>> Beyond fixing the latent bug class, this abstraction is an enabler for upcoming
>> features that need tighter control over how page tables are accessed and
>> manipulated.
>>
>> Getter flavours
>> ---------------
>> While converting, it is useful to have two accessor flavours at each level:
>>
>>   - pXXp_get(hw_ptep)        plain C dereference (compiler may optimize)
>>   - pXXp_get_once(hw_ptep)   single-copy-atomic, not torn, elided or
>>                              duplicated by the compiler
>>
>> Keeping them distinct simplifies the conversion and avoids re-introducing the
>> class of lockless-read bugs seen on 32-bit.
>>
>> Example conversion
>> ------------------
>> Most of the conversion is mechanical.
>>
>>   -static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>>   -		pte_t *ptep, pte_t pte, unsigned int nr)
>>   +static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>>   +		hw_ptep ptep, pte_t pte, unsigned int nr)
>>    {
>>    	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>>    	for (;;) {
>>    		set_pte(ptep, pte);
>>    		if (--nr == 0)
>>    			break;
>>   -		ptep++;
>>   +		ptep = hw_pte_next(ptep);
>>    		pte = pte_next_pfn(pte);
>>    	}
>>    }
>>
>> The bulk of work is this kind of rote substitution. The genuine work is the
>> handful of sites that turn out to be operating on a stack copy rather than a
>> live entry - those are exactly the ones the new type forces us to surface and 
>> fix.
>>
>> Estimated churn:
>> ----------------
>> Half way through the prototyping converting only PTE and PMD levels:
>>   77 files changed, +1801 / -1425
>>   ~57 files reference the new types
> 
> Right, the churn would be very unfortunate.
> 
>>
>> So the line count will grow once PUD/P4D/PGD and the remaining call sites are
>> converted; expect meaningfully more churn than the numbers above.
>>
>> Introduce the type as an alias, convert one helper family per patch, and flip
>> an arch to the strong type last - with non-opted arches building unchanged at
>> every step.
>>
>> Open questions
>> --------------
>>   - Is the type-safety + future-feature enablement worth the churn?
>>   - Naming: hw_ptep/hw_pmdp vs something else?
>>   - Should all five levels be converted before merging anything, or is a staged
>>     PTE-and-PMD then landing others acceptable?
>>   - Do we want the two getter flavours (pXXp_get / pXXp_get_once) at every
>>     level?
>>
>> [1] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
>>
>> Thanks,
>> Usama
>>
> 

-- 
Thanks,
Usama



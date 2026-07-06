Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9962C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE4E6B00BA; Mon,  6 Jul 2026 08:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6696B00BB; Mon,  6 Jul 2026 08:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D726B00BC; Mon,  6 Jul 2026 08:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3366B00BA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:53:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD37140198
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:53:38 +0000 (UTC)
X-FDA: 84958343316.30.A792251
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012026.outbound.protection.outlook.com [52.101.66.26])
	by imf09.hostedemail.com (Postfix) with ESMTP id 795F4140004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:53:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b+oQRLY1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b+oQRLY1;
	spf=pass (imf09.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.26 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783342415;
	b=TGybzVplqTrI/asGLaJ9AyRPTts0z9YEeqEmYGvxc3bhyD963TPGi2Y0KVTFvNegdS8vZp
	hbm2YnCs+gEhinMfwLDw4iYcmakihyi+66DTMCqsNcFGAHtiNPsqHRdcGh6q3lLNA3llDk
	d7HZ5FgIUAF8XGZcSpXIyttmV0ArR5Y=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b+oQRLY1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=b+oQRLY1;
	spf=pass (imf09.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.26 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRmtcR3sW31wpPkF9HR6vaw05CfXeJkIUJ35Z3+EA24=;
	b=QInFF5+zyrPVvncS4bFQ1IYxoLHzErsXSsfmEpIrr8Sm5e2vTB4shZlYnFuB/bAwHKZyV7
	g/fpkcdLJY/eQR3KsnFgNDP0zxle5HuwMy1s5Ho93FQqP13dc6P/sy4lyofKJGHn4R+EZz
	6ChX33CUFBIrhT3NUrjE2+FkRU72Il8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Z5YjqCgAfZ1fI9TjzA7TN8mtl8A+yDu9iNMg/ZnRDKcF8zR3eP7Z3O1zvmMJ1hSSshGBW5K9xvtd0zZpMioF6T5KYHYKOa6vGDjj+81A1n0q+s2EgmJNWeyl4P1KzIypwNKsAitWLs4AoxhW73iN98p8rorud3o0m0Lry9p+G5Ox81w2TNgHteNoXfJD/LkVRP+3ytpkm6jMTBOpS9eWa0qrHc5qVdtLelMovLp8hHQQCPgRYTZnvfKIg+bdguBN2KD5+lJ8bHoN12sX1FEVlIXe6zBal9BNNFtiNgb/iL6chzxqzySzY/dl4xQyQEZAPkJUeX5eivA4VYqgBYxwkg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRmtcR3sW31wpPkF9HR6vaw05CfXeJkIUJ35Z3+EA24=;
 b=ABM9CU8A8klFyOa4f3WnhXzm7U3CYm4jANZgw8mJVlqFVEzFro51leUdKO7zDEuNzlxvUjiCcpv2s1ZAr/udnh6HWt+wOwphFck/hrwBlE2ZVuKRuqwF16Gn/j4HWB3yxSPJ0TmXPVf4rOsj/xANpVud/HCjIwVM+zcHk8ayd61uBt0Caz3ftk2KHVMdz63Y2AzV9aXG0lhC9wanU5ogYOGO36xUZ1cZRSqSBUWhxoTkj1wZCFO9ig9bt4UDT/zc79KherNPFXlMgHu54dmyICW69O3OoHRfFIHArTIarULa6bRYXzX7Xa8/NM/BnDZ/eXCKZD2Ult+4XNrHjZLlOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRmtcR3sW31wpPkF9HR6vaw05CfXeJkIUJ35Z3+EA24=;
 b=b+oQRLY1f2TbGkB7fobDe/hnY6MAhCDVsmqi+R49XVw8Z2LfqLDJNyRRJyvctIuuxWI8ZcRs4MnkLA7Rf8oJVnhf1lNs4GAmzGG93K9LJ5VpdTsFRa922tEuhiGEj2CiCT7HOhuXmnPB9H4+Z6WKLo8LVWBW1JyuyASp5tNxXys=
Received: from DU2PR04CA0292.eurprd04.prod.outlook.com (2603:10a6:10:28c::27)
 by DB9PR08MB8675.eurprd08.prod.outlook.com (2603:10a6:10:3d1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 12:53:26 +0000
Received: from DB5PEPF00014B97.eurprd02.prod.outlook.com (2603:10a6:10:28c::4)
 by DU2PR04CA0292.outlook.office365.com (2603:10a6:10:28c::27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19
 via Frontend Transport; Mon, 6 Jul 2026 12:53:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B97.mail.protection.outlook.com (10.167.8.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 12:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOMaA6N9mu0yhk8a5V8UYi9Hmgo8zAzSvYn5GD4IpO/nRZs3qJaBMECXeXyhvjXHVgeSaLhgjSNzLHh1BaEef/PHujt5panwIF/VAKWfwhvgY2j8cU6rGzo4wsxTyOAds8heUy6D5aD2NlyhMJLkZ5MDfQO1230inQoUeIZ+4cOe2/JlNKukyeylqTL033ShjoGR/1//pskBQ8rmEVXJgNN/vJ/sBzwqFRD6KQP9C5oxMMPBElwrmI6Kzf7pquelXu4R4sHbG3fY3EQrrFbMyeBlw8yLfzQxnjdlwGwhCnJYaL5F5eDBbsPIMQVoxGkm2IvqIGbixqFfe5AgAedFSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRmtcR3sW31wpPkF9HR6vaw05CfXeJkIUJ35Z3+EA24=;
 b=nQF0Tf6aO6hKmIsa24OR9YMjWL3GeHVGQwII55Y4h0gNOGmzBXuV1tw6jbT4DyU+OBM3n2U9Uww9fkYPJ+751rd4GvDdFG1CXzatP8kOKvjf3NS0fZgPf5fnt34w3aqRqc63gUPiDhgV+h8uk4EZ6Y1nD96M4r5sqUdg5/4aSwFRe1cNMDdddIzhiZ+43+mw3XEiHdFxlsVQKGB2oTPEk7p0N2uSlu1hgpz48DwP0U9mnXvbE38cxS9s3vz7et+J1wIvHMyBCVsIU1Qzd9pJ/uao+o8hacMzC6AOpmM9WQVSVuQnXDfq9Kocynj5l/VEeYy55DdxOvNQ2NTHBxr/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRmtcR3sW31wpPkF9HR6vaw05CfXeJkIUJ35Z3+EA24=;
 b=b+oQRLY1f2TbGkB7fobDe/hnY6MAhCDVsmqi+R49XVw8Z2LfqLDJNyRRJyvctIuuxWI8ZcRs4MnkLA7Rf8oJVnhf1lNs4GAmzGG93K9LJ5VpdTsFRa922tEuhiGEj2CiCT7HOhuXmnPB9H4+Z6WKLo8LVWBW1JyuyASp5tNxXys=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GVXPR08MB8234.eurprd08.prod.outlook.com (2603:10a6:150:17::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 12:52:17 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0181.012; Mon, 6 Jul 2026
 12:52:17 +0000
Message-ID: <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
Date: Mon, 6 Jul 2026 13:52:16 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>
Subject: Re: mm: opaque hardware page-table entry handles
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0397.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::6) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GVXPR08MB8234:EE_|DB5PEPF00014B97:EE_|DB9PR08MB8675:EE_
X-MS-Office365-Filtering-Correlation-Id: 459c890b-5834-4249-4261-08dedb5d91fc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|6133799003|4143699003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 eULe19KgP1aBwUU7Q2v+wIVHkh0dJgr3DIJgUJf0jG43priF/+aJNgL2T9O3TuTQ+Kl4Bz+G84eoxuNy18urXRUt8DkhDDiMv/ZXLyuht/2W2j44XioeySOOVM2p0XAttdWy7MLiUYD2+WkFJF8HJpGjLnJgrlKLBNyzul68YKBhD+oKdyjbFMW09No/leThvPdMyhlqtc+aUwZtS7+NGcPtIygv5sRJPuCm+qIVv0UTgQUPNjkQ8eOLQT6ibqVm4XjnUffutM+n928CeJxhOMzGwbZOqo0/g8jsEwXnpXhuL3mxmpQL66PKI/VdTgHb8arZ+aKFX71koywei5VYEoSrrDFsKEfIsVSKrPbR+KiHpb3ouwaO3yU1IperXqYT/nriKXZ37L8sdqNcGf6C0uNzdvYo3BgKTCsbtoEEszdz7lErtwzeqW2I/ydgfRJ4mgBQmHLakzmmw7vkcQvKsw683I+LI9hDy+tfaBwBfx74PAABEeO6lhgd5qYTQ54sewNnHgIxMjtWgbyorfhPpMLoPUAf/9gfab6SGPNXJEgwtK86rSJjnB/D08R8hnlHx3HtVaxNoistM25VZF6WFMOWqYk3HmI7YfQSMy4j2wzDCOfOYCSAqG+A+n96VJIA+ilDIhmaw9L74j9MsBPMnQxGYV2q/pkEfe5tP4E1cAc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(6133799003)(4143699003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 KXH4k7w3jTiQdAXjsdc1IKOLC+N814jIqrPmdthMY9lPnUmg9IrLGJ5wiwo/LHLc7ppURrkc0fgIKjGlWYB7XMqAMg4AJHpQBD1PR6DkQVz2kYf1MyVfIdNHDYSrRIJrXyE16NEQNVJ+aty0qaVVKJQ3sl5NV/PDPgMlD+x0ysMvhIs4dBfuUGpd70ngPeGRcvl1aiOvgFN07EPLZ20SFtbQqgOmofDjts2FZnML2wbpaBgu/RIYpJeKsApadnUzFmec8fRnG9rcN0o1l0GYdeHf610ByT08EMqjYi9pkhLwNjhuQIWVs1vvfVWG6/0Kn7dQLtOkF6/Z0crh91vo3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB8234
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	796aefd6-4277-4350-efd4-08dedb5d68e9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|30052699003|14060799003|36860700016|376014|1800799024|35042699022|82310400026|23010399003|4143699003|5023799004|56012099006|18002099003|11063799006|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Vnrhvw1oklIRKtW6PEjsv5UL/T5c3yAqL9lCwwsiKk2bYm0NmsSDDoHwI0KPMezC2WilCEwhO1C25sq7cjVwLow3vfV71z854S7eqwF9SNBiFwVzjxNhFeifxlJukmFMSlvdWLIhObcahe8REhGSVaRH51BVk4GXGeoiicwsc19ONE/yxWN8MHGGtfMJ3ecwOmVoTPVEZcs3c1Z6Qkq+iC1YBt1JdLuylg1uWYsiKLuvlual2VmRA7Fdjs44BvmuIUYaULak5pUvIzEP8iqFoDvgoYd1idyaKFuSS0jAm1pZ+scAJDQjtKOzjRJNlMcAhxmjSzOQBoszdELYWDtqcED6GCb8npLNv42BPP9rZaFBSZ20oZm3fWGmW+1Y3wxtlEgTCh6mU8R/WTjr/hhZzWHAPwKNR99JjDcYAFmKRYroQe8lkdf18ZrArBl/544rJ2/B4VaRcq0xGz4WXEGx9zE/LiG+dCj7aab1SbzBzQTp5tnzU7MNSGPkz2yfBfVYGgU5zE6em5OiDcnqiieGTUecmYcH0LnKk3zi4jnwKy8jVCx5rsffuNh6QBJ3/mF7R00dhZGmZmRALiV5c0A6nksRXtWuLJGLANjRI043rAl86s5WukfLM/iW4bPSknOGBKoOV8aVL9i+xgoV8vRmiHH+sRH4mRrUzeOmdrHnbkNy1ahddRFzkJo396skrdXzTsskpJLTzE+NzhFW/tlx1Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(30052699003)(14060799003)(36860700016)(376014)(1800799024)(35042699022)(82310400026)(23010399003)(4143699003)(5023799004)(56012099006)(18002099003)(11063799006)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OMEsVvf64vbwHorCyCiu1Yx0LzMNo2ydsUufxGzA968fYP+Nquk7XSXT1gaM+lXRggoPlsNSq9YhKqplO3UUmFTuPY9CL3l4cZLLIFU7QS1GrLMs6kWQhTW2Uee7ef6fNSra7cMdbEfSudWsDcvEsztrnYruIYYZrNkWK07OKGwEYoBI9bSmw8Ybv5DU81xk3ix0rI5fAKcGMelQIkTPQZjQf/AsPSKdIyL+2DHvEdTqsQ2pb8WQQJkJFDUlQiREz4DGSNv2EM/DtNk4qIN2HMxOYTkIPIXWcz2E/CvQzxa3DFF7jdwt5OF/asFKC4udPvacVPAVFnS/kWO0okCBfGTVrrv0NOpSxQdxJUW7l56U13ke27T/q/wnFWiuWHI+DR5san2/Y7yAPddfpZVFFcQqI8e29T9Pg9Gnd3UaOOcBhXjCRgCaPV+UPlW+UyN0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 12:53:25.9621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 459c890b-5834-4249-4261-08dedb5d91fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B97.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8675
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 795F4140004
X-Stat-Signature: t3bk6hieuhjmku7sit9ec5h5bxigugi4
X-HE-Tag: 1783342414-35142
X-HE-Meta: U2FsdGVkX1+l0x/AFXloYvKXK3m0JREzbwcayZOVVNa/IFTzlq/hTbG9bUBMund588yFpYXlQWx9NW23Qy7rr4VZ2vAzOolPLvVU0cbcCyqUZT3txhHOj/NtYz40rCpboflbykegIyP089jvh+QFjSm43gCfZQX/i99wPeUGGwsajfZ8QgYfGan/2zRVOa+yI9MS+9gUMsSggmkIv8CO6hif6czLg4A56QtBjGqIDR/CdlqTc2BvxPbiwy5BDOmzH44vYAGKJg2yuQ1nXSX6SXK00pouI8d+97B/aQgHfUNoVRnDEFUBiG63Sbvs8WvVSeSnAaEMcLY5zOUNkOcIUvBg8fihgj3AhwA92yc1/ierLd8PI87M1JQN1i6/UC4OV6QHikkD7dXcRH4+e5O+y1HjdIRFQHrTlLQn2lRjX4n1GGaxjQGO6+L9hzgdVR2SMjZ/h/cANIq+i4I/1/+Lp5s0feNBRV6LATNOarlCwELGOQQgATAD8wG90HbIn66cO6LNbkMvQIcOoFS83kBDg6sN3B4g2UN4AMg+tF6CUKTpDheRZqbSDQnvS+wBmD8qibtSoGbSEw8agQ8t+c+2ebeSjYkGCRZFfGEvrh2TaKg/GGcLuVOloXlLZezXpjBMvaOypNnxEDpqwJyhd3kXizjqDVmuReQkJF+yX0bVI6ZHGQ6pTQ25jcIO5nFMUTaR5DWct/Hw4lBPS4ig7lN9EhsRSbvqc2TrMCHpTEnPuLypKrnCtWctyYKwNdr2n7LSq9BpKWXBg0f0lwvDIKTpqT7nsrZ6jPZxYOoG5mEQP6WIXOi/xhriznq4m4XPFSjaycVTNe3tf64RWawx1B9hEev3RHFo3FlBCf28i0TbDD3ePvM6J6+Uox44f1hKT6vhER1Mre9M3wWEHcGwB4RVkGFnL63PZPpRXm7yrWbfrXBtFbe/bJcj7rUraFYhEmCK6zmX4fX2P4x30FnXACO
 89R4IGBX
 3IeASw+HebUFIIW8xPCGs/DZAoYfbwTLR8WxBSl51cY3le1ZSHM9UPDeugeoh2/9/aszNkvW5YexJYaUivDzoBQG8jPP2NxUvZYuxQsUjmYtbOOQR0SPKnVs8LRcUuHGSD/q1qc4UPxUMsIi2Of8kjJJHJwIR5BwedjOUPNB1+cKp2XNnBCyLIYwrBnA6/Ku111YlvTJkX7w7RpFgI2ddnTIy9RK8mYYc7sfqdI8giDFiL1mRPIkTT/KYAmzjvDDoz76DzAXO5oNvaFkMBQZhb5FSebctZQZRTp/grikfNbRp/b7SzhzJRLBL0aYdIiCQ+4C09tHFTcYEjCbPjvW3XXiCq1KsdPFvTUbHXWHnMnFYyFl2C6S5eBg2MOcaufpIyis9mifA8Z+pOnDA6vFFzmqGOk6XmziATbigCjq2oZGZXnVCit0WCm3qIK+qSqY5X8pDN5tL6KEQj5m9L0v5KqLUZVXDBCTMgppgsYqbuYVcIfeB+oFzSDwbSmNknUa1pKfDqbyNqGTjH0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thank you for the review.

On 01/07/2026 9:56 pm, David Hildenbrand (Arm) wrote:
> On 6/24/26 16:09, Usama Anjum wrote:
>> Hi all,
> 
> Hi!
> 
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
> 
> Yes, I just stumbled over that myself while working on Levi on some folded page
> table optimizations for pdgp_get() and friends.
> 
> The stack usage is nasty. Calling ptep_get() on stack values makes no sense.
> Reading actual page table values without ptep_get() is suboptimal. Punching
> stack pointers into functions that don't expect the, is shaky.
> 
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
> I guess the proper way of doing it would really be for hw_ptes to have a
> distinct type, to completely decouple both concepts.
> 
> That's where the fun begins :(
> 
> We'd need hw_ptep++ to jump to the next entry in the page table. Assuming we're
> on 32bit and have 64bit entries, would that work with the hw_ptep? hw_pte_next()
> is rather nasty.
> 
> So, similar to what Pedro says
> 
> typedef struct {
> 	pte_t __pte;
> } hw_pte_t;
> 
> And then simply use
> 
> hw_pte_t *hptep;
Make sense. So you have suggested to just hide put pte_t inside a structure
instead of complex structure of pointer. I've tried to implement and it reduces
churn enormously.

> 
> 
>>
>> With this:
>>
>>   - a stack value can no longer masquerade as a hardware table entry,
> 
> Right. What we don't care about is if someone deliberately would instantiate a
> hw_pte_t above on the stack. We can catch that more easily.
> 
>>   - a hardware handle can no longer be raw-dereferenced,
> 
> That's the important part, yes.
> 
>>   - cases that genuinely operate on a value can be refactored to pass the value
>>     and let the caller, which knows whether it holds a handle or a stack copy,
>>     read it once.
> 
> The question is if these cases really just support one type of pointer (I assume
> so).
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
> 
> Like Pedro says, pointer typedefs are really nasty.
> 
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
> 
> That's just what we have. Defaults to READ_ONCE().
> 
>>   - pXXp_get_once(hw_ptep)   single-copy-atomic, not torn, elided or
>>                              duplicated by the compiler
> 
> Why do we need this and what would we use it for?
The idea was that there should be two different functions to read value. Let's
leave this out of the first initial series. It is complicating the original
proposal.

> 
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
> 
> hw_pte_t *ptep, pte_t pte, unsigned int nr)
Makes sense.

> 
> or (with sw ptep)
> 
> pte_t *ptep, pte_t pte, unsigned int nr)
> 
>>    {
>>    	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>>    	for (;;) {
>>    		set_pte(ptep, pte);
>>    		if (--nr == 0)
>>    			break;
>>   -		ptep++;
>>   +		ptep = hw_pte_next(ptep);
> 
> We should really just let ptep++ work as before.
Makes sense. There aren't very strong reasons to convert it at this time. 

> 
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
> 
> We have to minimize the churn. But yes, we really have to find a way to stop
> ptep_get() and friends getting used on stack variables, or *ptep getting used
> without ptep_get().
> 
> We have object_is_on_stack(), but that doesn't really allow for compile-time
> checks ... and I don't know how safe it is in general.
> 
>>   - Naming: hw_ptep/hw_pmdp vs something else?
> 
> Really avoid ptep typedefs.
> 
>>   - Should all five levels be converted before merging anything, or is a staged
>>     PTE-and-PMD then landing others acceptable?
>>   - Do we want the two getter flavours (pXXp_get / pXXp_get_once) at every
>>     level?
> 
> I'm still not sure about the _once() really, and if we need that right now. We
> survived without is so far, why do we need it now?
The idea is to convert all current pXXp_get() to pXXp_get_once() and convert raw
dereference to pXXp_get(). Let's keep this idea separate for the other work. Let's
discuss it later sometime again later.

> 
> 

-- 
Thanks,
Usama



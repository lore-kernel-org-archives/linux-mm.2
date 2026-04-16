Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C801F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA236B0005; Thu, 16 Apr 2026 05:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2006B00A3; Thu, 16 Apr 2026 05:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A3A6B00A4; Thu, 16 Apr 2026 05:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76CEB6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:12:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F5E8C28EA
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:12:18 +0000 (UTC)
X-FDA: 84663852756.14.630E485
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013014.outbound.protection.outlook.com [40.107.162.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6412160010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:12:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fWOIs9yp;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fWOIs9yp;
	spf=pass (imf08.hostedemail.com: domain of David.Hildenbrand@arm.com designates 40.107.162.14 as permitted sender) smtp.mailfrom=David.Hildenbrand@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzjV+aN7aZpPU05UAi/nzkMb12ISHbPwBTYVtnyAdQk=;
	b=pRPg5fzDr/SKLF+OrbLu5RheBQMRhzSoxuS2dDOHiU8ul2wiiRNky+x+AcTVjFz4t3T8wF
	R//7LfutZ9TbVhEeFeX31QRGKl4XvTcfB4iKG4KgOjCLxTPpA0R6JSMSulV39tBzwvhWKX
	xspLa09DCcXlcoentB+odrVppkj3eC0=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fWOIs9yp;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fWOIs9yp;
	spf=pass (imf08.hostedemail.com: domain of David.Hildenbrand@arm.com designates 40.107.162.14 as permitted sender) smtp.mailfrom=David.Hildenbrand@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776330734; a=rsa-sha256;
	cv=pass;
	b=UIgN40lHO40uCPsnHG3u4umX9ftCYjAY3YgPlT8wMrlHpnh8lpbf/p/yYxz2KEukzV5iKq
	gnvNeymMLn9JphtRfsttXi7q8+ohuxYEgIU/QAapyEej8zClSTNwDJEK8LqLkK9SKXdAup
	V3A6vdgYQSoY5nWYSMM7ZW5jOCfpvVk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tMHcmqmRgAYjfx7sK1xUL9r7WR4yo+aTkhGM9i9aLa0kbWn71gz3Ze3ivC60l2tDT2saxLTQpKsckbog9+ExKxy5/YbtVWzOjDGSEWUn1gT24hxLL6FRDS8xzKtIjamxLq7NnU8QtVqKem62ZDqrP6ClNze3uDraMIfZfjGake/qwc9Tr6y/e4/b0SGO06w3fhjka5dlpnpye1A0B9Ydjl5enR8qp42jIVIFnZhQbpQzItX7wBSeECR4zxrfDU8OGOVWa1JBbUMAxL8farXuRpVSZVUJ1B3FVBh//DRoqOcgbHrQsPZlx12tPZK6EpO+aFJQ13sjrCQVBK6QwDtUvg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzjV+aN7aZpPU05UAi/nzkMb12ISHbPwBTYVtnyAdQk=;
 b=oYNvlGs8Upinr92TiN+An7lBkC8ZjwWaZTw1zb/pbt1GQb0YM3uekb8Ybp3fx7aiblH0+vCj89wtUgM5sJELDwK1EBg1JPgOAU7z+sJ7cuQ6uA2IAbANvSUFFAX8vZq0a9QEz/xNPxLSV/xUXbRFHABpKhVPaFmVo4jlTLKOphEUSHlUSI2UXwTytKFMk5wT2g5u4khWs4q03f33x/iZyGFtSZHPDoC9V0cPiKgVZ593BMknc79Xul3+qWLukkYGTlHU1qJbZky4+3wzouPiKBv2G8EURmkQ59DfBaROa0Rd6FQfU9QqEZJz3zude1L4fd2xXaezhJSfQpuXMUuaOQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=arndb.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzjV+aN7aZpPU05UAi/nzkMb12ISHbPwBTYVtnyAdQk=;
 b=fWOIs9ypLqxwj6N5awB9SlziDdJ8eb0fh8tsa1c/l+obOdw9yB4FYWKbieAwz0Uq7KSGELum6Zk1A0uaYypUQeU1IsvvDABAX29M2/b0CW9KvVCbOAnnffSmtiZ7zuwVMqimJGNbgN1UFVsIVzSUK0xz/iFiDzf/w51z/f8Sbak=
Received: from AS9PR05CA0346.eurprd05.prod.outlook.com (2603:10a6:20b:490::21)
 by AM0PR08MB5313.eurprd08.prod.outlook.com (2603:10a6:208:17f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Thu, 16 Apr
 2026 09:12:09 +0000
Received: from AMS0EPF000001AB.eurprd05.prod.outlook.com
 (2603:10a6:20b:490:cafe::e9) by AS9PR05CA0346.outlook.office365.com
 (2603:10a6:20b:490::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.51 via Frontend Transport; Thu,
 16 Apr 2026 09:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AB.mail.protection.outlook.com (10.167.16.151) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Thu, 16 Apr 2026 09:12:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TEPUa7tAMF5jjDlNcyoaOdfb9o4vegNFPzZCUD/ycJDc7YeKGlM+STEWXMfH7lxbGYbztjJfj4dill5E5Jgrqb6oJfn9eOL+WRWb0E4wJchARgHhBFwkIBRZGRkhmfapKLX5yqZf6rgw8txz0/P3/poI8yhNN+6h7evkaLSFFvWvwgMexKceztfTg+OaJrffP/D/l58euWRQVO9xu2pqHWh7rDWJLTL4f1ln3sqeBVkxGWlkLHFTE2boFD7TyTuc/TDvw3Gv4OpSJXdIYXK2RgZ+Ktw3SDbXVrrTOpe8uZqyO7AaPV3O1pJEXT425ZTX+xynlqVFagLtkZhQkLZIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzjV+aN7aZpPU05UAi/nzkMb12ISHbPwBTYVtnyAdQk=;
 b=ElFnQ7/feVag8y3L0xxD8nNGfMAPXg1ZXPQk71GweyqMmjyJN5XB8RKzbh+6WjRu6gJSrocVg7dU2QQ8Okc47M7OvC5re9ruoIkmRuwsdz11GzpVlszjw7mqJtUp9C5hlEiN71lLBL61V+x0IFZHgrG6PQfwmL7xi5PjQUUdxodm9Mv+rufVYx8foYpZynwEEndISMvIfh2Xy1l1N8ywOo+TPFOhTLb8sZ5A5KKthTG0xVMgzbsYKza70pE5EmRWAQ0oIg6G2M+/RLovn7YHOSnO/GR4kGheXc4eWlNTpqHKimPVrQS4eoumzDlFYh/28d04ZDuyJO4HBmv2FTeEJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzjV+aN7aZpPU05UAi/nzkMb12ISHbPwBTYVtnyAdQk=;
 b=fWOIs9ypLqxwj6N5awB9SlziDdJ8eb0fh8tsa1c/l+obOdw9yB4FYWKbieAwz0Uq7KSGELum6Zk1A0uaYypUQeU1IsvvDABAX29M2/b0CW9KvVCbOAnnffSmtiZ7zuwVMqimJGNbgN1UFVsIVzSUK0xz/iFiDzf/w51z/f8Sbak=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by FRWPR08MB11636.eurprd08.prod.outlook.com (2603:10a6:d10:1b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 09:10:55 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%3]) with mapi id 15.20.9818.023; Thu, 16 Apr 2026
 09:10:52 +0000
Message-ID: <f40a0724-8a6a-4a19-b8f1-d1942659bc54@arm.com>
Date: Thu, 16 Apr 2026 11:10:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
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
 Ryan.Roberts@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <20260324132631.482520-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|FRWPR08MB11636:EE_|AMS0EPF000001AB:EE_|AM0PR08MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: d8008bec-5438-4056-1e89-08de9b983ca3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|18002099003|56012099003|921020|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 IaR9vFi1UAWTVTwGa8AhwPeFru1zQyJua/uCA99lmXLGrXwRM4IBk5Qn0BUEXDiNW0+aeyIuzNM621arQr5L43rwJ1j99QBoPD0MHuALZoR26EbJ5X7JzlJZ6Zkg6XXzTvdGluusM3MKrT+vSAC8f5I9TwoUxuPb1acvDbYEWs1YWNhndwFnocMz99huZ776rPmHprpEq1njdjCiQxRGlctaaWcBONjzVzlacHA6RDdIV0wgFUXSAWCATgVuC5JPnm7nbEiiCIeydJa0veSl25u4kHrpoaFFH6lYut7ow5ndyY/c9Xf1BGGudA/EdbFHTWh8WpG+4oQsCOjO/TvYXSJiWnoY+G2DUxylNeSxQsfGl1wXmcDVvtWHbvJ3iOZ6QeW/FpXZb81uohYJ4LfqeDKjaKrCEzahWO8spIeHB4ELKUGm5TMUgyTMlgLj4xpgsrM9XLS06jt1oFOyM8xk+6iXjxuyF3FuBmvmqiLYz4BXeWfExbLAPdACi5r+ch+c9VFZL7+QSDho6epp0KJTWYC2OB/qULsxykNKZot9GBUdg4HFAD0xv22xt8nlun83K/ST8jU+DodcFO3oxB8wUDMZLo7l2seBpiEKk+BihutdExNDAh/px1wB0FrFVJAGxu4VwAqllREZtUsQKBRe0AKJ4JlYIUACD8p39Wu/6BV8zoQ8jAyZ06nQL4/+p/LOlWcysIPE8h3PNZQ0Jp09DuSpycN+c1BMjPeTGNz47JjAD9gUsEWcSbdvWeddgSWXHfmsqjlLeSVTIyNVoU9J0w==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(18002099003)(56012099003)(921020)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 a0GhWV0MGnSsGP7QsmdcZMT90oD9NwO8lDTYGS47SjRG5gwvyhXTDcopz2Pi0Bc2QTT3EU9XOMN/hTzRKvJuhdUMQAOZG1yZLSwwE+uBj26zWCmnYMXdv177oIOJXyXh30uJs7SbwJbC1NusaZGGXvdRWZ96503X0VdidpgHqSF302OhyiaJoIGhTRcn/X0zbjaXCj2APfJRQX7TspvKZm7n9To2oUtCjvTYdq2SlJwwn0UULHgg3OADkRvpSHOZFwEt7l5g87DxjVaLn8QcxCa9uRcRMlsRlDVZHDw27AanZwhm9lVKgwitXfQFgrEtU60vksRVH5rJ0vEOr1JduA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR08MB11636
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e911ec6f-2352-45c6-f010-08de9b980ebc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|7416014|36860700016|376014|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nhmBRZnDg0iJIIzh0pZ6zVAJ6PNAgb8qPHyK0JydixBv1Yhd4dt2GcFHS6XwEVHHYbxou1o52c3TwjMbTd6RwHqAE6reDDyjGhc7NYSg5ZVECZ4AV78MJqfxiKJTrDWovvOj2ItvkJT6m4091qovhb2NAQ9BRebjkc9srZkr08pf9euZGImTfaasRuuz1DfTBqmREyrTvGHUJguyqCJ7hpyAXWzxTTwVbKvNBkAM7rj7eo/nnq4Lrls+txZlVpgkHNhyak4tbnK/mDvOU9sC/h22fJPYffFGuJUIiKlwH/A64W+uDO+a6Ukf7Ps95x+0OA2oTWYSSkrFm8IR1RIxz0Qmyas3T/ExJpSYaa95X+5HVPvlsRw5hxost1BE1HEh8tEIHnevyskgVIpgfeM4joGONAEZ27psOCYrHh0DRJ0YENYmi0UybxfHQeCfMLoa1qGasUitMmIjXC4Hv/R11kQSygA5GaYEX8sK1DhofkK1dbJ1jyODbEXle5wmEJgR+bAh/hD4SyZF5ZlpV38c9dFiGOb6TadRJKZIjiE1p11MSCP0M3G2wXTl57+tDj5GvyXJBmWjS28VVEukOJftqtdldi9V1ssrPdcUzBsOtXZF2mxZYKvWHR0JDypTC5ifXGIO9kgsBKA0MMR1UodDseAekXqjRy7aR8JpwSILFmqs+g66BC+o2TtfLjJr/U31HnWIcGjUISW9m1DTs+1LZt9/U6GXqRZmMwQnokAVB55zfKpbq7NWRWCOz5I0CMEI9TB5WNnuy94/7w/KKtajNRW7EAhZpx4lTCoCvWw7WB1XRPnfiZUoMqXCV9w1HSIi
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(7416014)(36860700016)(376014)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vHX6JM/wehLx5/bBCRSuog/ZXKaqAa4Sz/BZEgG4RMegzYCSPz2Xmp2YUlm4Fr3hXDXcvN6kX8UtaiM6axXq/QAGmF+tBmFW8zubfhQOQzpbXaGede8XnG6HKnjMYietOjB8G1cUJW4zd0T11pT80BoTZxPeXsVroOwjKkQ8CknLeU5UdlxUIFAkcoqwDGz8G5QtQMB3mial4MnjR5wwEAdIZ/FCh9+t+Qo9ZXjHK9KA97f2wdD9slPmm1iGIK088uJydKmWyLA9Q/3i/bktCunVHzPEEDgLSaH4Dtchh4DcCHifF/w6G8xvh8BsxzgnXmD6bsBVLX0e4HgI6Ya2LE9vdHprn7ggHiJJIU1t2tz8ZkPubX21AwMf4kcItXG7PhvHhoUf1TIZ7vDtwu/lhgBf+cvSs6vrErGgPRqf9m/sXT2fmbnzFLDWePz2qlpi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 09:12:08.6854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8008bec-5438-4056-1e89-08de9b983ca3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AB.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5313
X-Stat-Signature: a6rpj8jjeawh87r8b5bin3webafc9onx
X-Rspamd-Queue-Id: E6412160010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776330733-742762
X-HE-Meta: U2FsdGVkX18PGAdNEogdAIU8DyF1l4RSxIdhQJUmM6aKdSCP/elqhkRFf9jtHTKEm3yXuX5ApX3NBH3U2RxRpDeo1FdxJhsdtRkMXE5SHPWLh6WGlBif4EBVlPnwSImXLbTi2am8XxWY+OyYp08AjgRJCgzrn788YAulwi5J/ePU1JEKETWI36RI6y0Kv/Voa9raTgzVztqr9FkrT6GNjjqWg/rKhZ4Te6hCPODAM/zsVI4Wobk7Lp+VhgVBVt6wYZPjJuNysWNAxmu0K9Nq0wkOARmVdHLdtOpreh/n+ZouRdrgfNZn85ZI3e/wHtr+VJlw4E+48tMfTJ2Ozjj8jF8+gtGsfCAegsioQ8qFZoYbI7SN5zcR458HHIVN4ii2Duzx4DJkzJyV31GQP7TB568+wDm8DQ/o6IRTdUqSQy0tjQhmy8ruZm/4YFnkX0K0oQRSSl6RVMapM7yC/L7CnO1qsN64M0KLiHdOGU5H3OjsVYG+aPiqW7dtWTxFMRlxQNqXnWxRBjnESwD7oCf4KjyMZopmEExiofv0OWriapsyv+4IC6IIsVkui85LdiV3eLCTkDuPoVzuNVFd/e8oK++IJngua+wfusWciIe04CUza43+L9VgKRoWKxg0oV9eXoE6HBaLDSrvQWZp94SbTScUFd7uT9C8YLWQ8AF2aLd6r+Wr8/XdAa5nWlca2jB68VKNJOsf/YZlxVH9JXwoZvKW7FH+4QxqOGk4Gzc4fGrIo9xs2J3OYGrqPfLzjB/arAW4OUDJroMCusMa3M0JmVP/Vt5y2MsuFK4zH8m2L/iSH7V332ygmJb+jd/QawmkBfy6suowrRV8j1LbN41IF8CZ/EJ9LpxmIV3rP576narPm2pvDizrxygurHoQpuzTQaMVhC6YOeV56KDQhmbquRnmz5auaXYDZQAgWZJtwQ6kSpwlR/EE24XoFqfwLViMdWXX+OB40rmmnT8ikMh
 /2Ac9Kx0
 arZoVLeIP/bZmMWFMLXWOqjCQzXRHt+yFNwUbFrb+2kbML0Nm+hjtl8hHj5RlCrJo33pFfB5StQA7rXdCSEQRttJ4SK7J0p5ARDNmlCkP/xMWlVdPNgwlukWJcdzIiay33OYw83deyX+5Kj8eDzxpEjGE7fgl9mtBuYbDzgcELkDRdgXcURtQAKBdrvQqIkF3QGCYDDcC2Nh99CeAzYDNSGbO2qfRtq4W2exZyEL9+0YWtKmn70aS8NgJdYD3C9kTspgiHDOEs/JwNQsPozjrAVYOHCrygzCWW4VJu26MCvSZuMEusaSjDX15ScboyUyLI2lbk1oTwVA9d+SZTASt9JM2sNgh9rZ4qlhID5kJCHpBwYl6OtW5w4zim4dB40s+VYLEBWYm3jdxiZYbK0kou1GRhXVMNJnTnlgP6eZdGw0+pEWoDVuAbNrJnerXXIFJwDRfCEedOSsnloL6J3QbeGQWjWo3uSKho2isJDNqThTz6R/vpBP7C68lDeSlVwQ3IhTilkfQ/R1FusBgHJbv7eM2evVgqe3HN4JfgFWpNrqJaC7MI89ZrR8aTcM1xg4Gj+hByPziP8fUl1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 14:26, Muhammad Usama Anjum wrote:
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
> returns early without tagging.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
> defined there.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
>   is zero in non-hw-tags mode.
> - Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
> ---
>  mm/vmalloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..69ae205effb46 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				__GFP_NOFAIL | __GFP_ZERO |\
>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> -				GFP_USER | __GFP_NOLOCKDEP)
> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>  
>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>  {
> @@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * %__GFP_SKIP_KASAN can be used to skip poisoning
> + *
>   * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
> @@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
> +
> +		if (kasan_hw_tags_enabled() && !skip_kasan) {

This code gets ever more ugly. :)

After I spotted the horrible ___GFP_SKIP_ZERO that shouldn't even exist,
I thought about teaching vmalloc.c to use a sub-allocator interface to
the buddy instead, where we would essentially say "leave zeroing and
KASAN to the sub-allocator": vmalloc.

Then, we'd get rid of ___GFP_SKIP_ZERO and just use __GFP_SKIP_KASAN to
decide ourselves here what to do with KASAN.

I tried to implement that, but that SW KASAN / !KASAN handling messes
with my brain. :)

In particular, the order for HW KASAN is currently:

a) Allocate pages *and map them*.

b) Zero the pages

That means that we have temporarily unzeroed pages mapped there. I don't
know if that's problematic, but it's one of the differences to SW KASAN
/ ! KASAN handling here.

-- 
Cheers,

David


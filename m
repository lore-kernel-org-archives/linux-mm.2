Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B8ECA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9396E8E0018; Mon, 18 Aug 2025 03:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9BA8E0013; Mon, 18 Aug 2025 03:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A5E8E0018; Mon, 18 Aug 2025 03:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEDB8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:19:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01E8B138C27
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:19:54 +0000 (UTC)
X-FDA: 83789028750.14.AA2B6F4
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013061.outbound.protection.outlook.com [52.101.72.61])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01ABCC000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:19:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NHfsh3XT;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NHfsh3XT;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf10.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.61 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755501591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqKY0MeuypYSfQWJ1mHeLVl/UhkDbaXtOdK+5KbGf2w=;
	b=owtTWHnysD//nh48Zzeq2wK+nE/dlVoljGCh33J75Uqm12wmytSnAWX/+fe1GPplgeVYRX
	fR95KuI1vc/+a7LrBaHMmdO1aMZSGm2HZPX7S6fDkD7DukmPc6hoUALIEpA2WCYJFPiy8J
	3+KWWIXy5rPBh852jcSqmNhIRKBK6Sg=
ARC-Authentication-Results: i=3;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NHfsh3XT;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NHfsh3XT;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf10.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.61 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755501591; a=rsa-sha256;
	cv=pass;
	b=cwKmg35asEwTzaAr7GrDgSB3weLYYD64TBPyQXltpEnzHz45Tywib/ICcWYwODAhbs8muO
	AlmiOP5+SedFuQb6XSYK1IHKhasJohOb7XdWrFy+NnllfZhUMtroLGH+A5ut9GBKCO4jRE
	587RY7q1co5OfMOSlq7g4DJb8cMna4Y=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mLI6nTE52DlaXtVCRQQmXd/1Q1W5Jv9GVrjGXla0yyyWsuUROJv118zYcVlvIjtAB6DeqHOUuEqkKHIkHzy5aPZM4RGm49pjdgENFfgf+cF94qQt7KCb+valQY0Qwec1txt1meiOIYy8zCOdZYN0HsKSDrbgjhdtjjsqMZyqoz74DS2kcgDv1aVpd87BQ1puhiB3SbLz6HYXkExgcfx5gahU5I6yPVGnfsz7bNULvJ2D8Q2TyAW1OLKWsd+f8wMfV15YnhZeiIvsOASCOY6XDW023iaGLxomRzF2OspNG3oTA4nWPmJlljFliu0depnL/luIRcH2jOEchoaz+o63cw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqKY0MeuypYSfQWJ1mHeLVl/UhkDbaXtOdK+5KbGf2w=;
 b=ednG2t08N7j1dgLJGWveAj5aU1AA4ylFSGTHofdooewohSC7Q/nyuOhNmtm2zb50YjYQt6rY8ZoOMwHCM9izTXc5xQcQWnatVxUnt9bigDt302gZjjuDN6LihIc39R+GxRvp2KDESlPyB/3nGzqxEXLr4wuCczCrHBaOdEMJabtlVFdiHkWqIkf9TLGOdlf3RYfm2bllcEDC5uxXpwpjbMIw8anvSNZuNAE/j+lLTZLtUro/dy1e0r8Dln41I8WF1b2B8EAQTsovFtZD/BAmcrEeZs3E1RlgW6YaMorJ3jm+ZlTrmPDnP9KHBBHa5TO27uFuuIgsPJlqW7z26cWFBQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=intel.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqKY0MeuypYSfQWJ1mHeLVl/UhkDbaXtOdK+5KbGf2w=;
 b=NHfsh3XTS/cexdyTsLLDIKym4wAL2sd3kOzyCSm4qX6XTXoGNsYnm5cTjnQ2d47DE8Y2NuJ1bqrZJTvqlyMiMQNciHmvX8XLGhDCJt+v23Up84oWbhsGpHU3B6Wu1mJyozCkouV+GCdl1bsx/eHmzpnfQllprlquQE7hk2AN24s=
Received: from DUZPR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::20) by PAWPR08MB8887.eurprd08.prod.outlook.com
 (2603:10a6:102:33b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Mon, 18 Aug
 2025 07:19:27 +0000
Received: from DB3PEPF00008860.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::96) by DUZPR01CA0078.outlook.office365.com
 (2603:10a6:10:46a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.21 via Frontend Transport; Mon,
 18 Aug 2025 07:19:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008860.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Mon, 18 Aug 2025 07:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wa+12+DxJoHRe4YGTFp6OQcUnwCFRDVPW6vK7UETvY0o2woyuUUZz8HE5BQdYJC91zkVRKOr4/x9UEn7UcmKkbQp92WiQO/RTkgupOSjrQwJH2YDgvORxEsDzgeLp+rLXdaPr6qzEcvjaEn1hPkOfh0qFgXCf3/+9XYNb2KCAYAQ8F/xsx05tDZlZXENbpcjfAwtaJLb7mA5V6SMDoduqLyx6zUFjf9EkIZ5nvkrh6JWnDHDuQiM1AwWSv6Vz5OGbe7BCtI4MnxydeBt3ZxoGqxBeIIOhpxcVanN738Y6B3gZ8jRojrp0a3RGpulkOan++bb2jW3PqSscUJmDSq12g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqKY0MeuypYSfQWJ1mHeLVl/UhkDbaXtOdK+5KbGf2w=;
 b=hoVB0yKQPuYS7tweuwEgRvRPOHWAFKpgYwG+l1sb4vgP7anmEbLoWnQaoQ5FSdGGqC73cyGdp++fQbH2J5FuU0o4xYCJGZDCilp/yaDaEemlyfKHVxhY1fgLFBRaI2f6EAWACz1Tu6QMUuX/EQRKtUftDTrfU5rR6WjGvh5MnaQxuq9n4MhZmjx8+ZRDgJcGv6Xe+EpbsIliWJC4kGU2ETzCwkq0BJ2iUa7iwkdIfGckgjcdgXGOtLlORjg4OKd5Hz8G/o059VoHZyTziaSIYwqVPYSmF45wIVW6IxlnD9MaahPTQ3xy/OnMfd4nxtqc347xJmfCFtclpTXpP/Mf6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqKY0MeuypYSfQWJ1mHeLVl/UhkDbaXtOdK+5KbGf2w=;
 b=NHfsh3XTS/cexdyTsLLDIKym4wAL2sd3kOzyCSm4qX6XTXoGNsYnm5cTjnQ2d47DE8Y2NuJ1bqrZJTvqlyMiMQNciHmvX8XLGhDCJt+v23Up84oWbhsGpHU3B6Wu1mJyozCkouV+GCdl1bsx/eHmzpnfQllprlquQE7hk2AN24s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU0PR08MB7439.eurprd08.prod.outlook.com
 (2603:10a6:10:356::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Mon, 18 Aug
 2025 07:18:53 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 07:18:53 +0000
Date: Mon, 18 Aug 2025 08:18:49 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kernel test robot <lkp@intel.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, oe-kbuild-all@lists.linux.dev,
	kasan-dev@googlegroups.com, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aKLT2QobergBhExD@e129823.arm.com>
References: <20250816110018.4055617-2-yeoreum.yun@arm.com>
 <202508180747.PxkbPnyA-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508180747.PxkbPnyA-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0604.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU0PR08MB7439:EE_|DB3PEPF00008860:EE_|PAWPR08MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: d49688d4-3551-49a2-01fa-08ddde27904f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?8ABSb3r1vKQaV6UzLO5SKo6rnDMgJtw7Kr/I0oa2INp5xX/JD8sDxOOZ3gZm?=
 =?us-ascii?Q?4KgwWKtDp0jE44lD1mZWyaMdZLEnW57jEhgwJQDM46ZOiP4PQHZOz2QCa4fh?=
 =?us-ascii?Q?1VKLHIdjPz4pu1ewCKzEaKi+r+4+Etb8EmzUeaspGr+4WDMqIy+B3KL88Sm8?=
 =?us-ascii?Q?ro6hMi4kvhZYKoz7LLj/DhaXu4/VxFFnxeo23c+zOoAQZ15ZpDTJ7YNvQJ+D?=
 =?us-ascii?Q?4e0Q6SsWw+tQRkHMjmhH5bnhdu1Oqf6hcu7RWmE9P7a24O641gfrQmYz/67o?=
 =?us-ascii?Q?dqZGz1/xKphkkDsxf55U32ofrYFQ2AhX3BzEFpJJzNl4W2EmTo9JDKWrXSsT?=
 =?us-ascii?Q?o6Z6aB4tTMpqHplpOGDtU859nBqA+B6B82tWNtdOYTp9ngohL15aNy+HFoTv?=
 =?us-ascii?Q?xiIR5DKIHpFHfaxrSqDanf59jmVzcK3Rt1VBGi7eR4TUt4ckcPx3+U7ymyD2?=
 =?us-ascii?Q?Sp903YvHonLHhmePxjgV/7GRbtdgti1NfEtnuAbOhFBoBRNdBpdp07ZrF0Sr?=
 =?us-ascii?Q?Se5qNH7+0hvcXCORlxvgUOQKYYwUMoozIOkvE3g/YHTJOhJAt4QeSBqu4GmM?=
 =?us-ascii?Q?MNTR7bJMNBd0qWslAWehuecGWebJ7DKVwFcZDlwKsOmsopeks03b5q59fxq0?=
 =?us-ascii?Q?rSDH9dz5gTu2+t0ZDy1GPBtTyx9tHDwCZ68UZQce8t7krHiKcMNJZTmEDtQX?=
 =?us-ascii?Q?QLok2N4Y08m7Vn76pUu1IZMrYl1c4cqOzmNt1amgqOkUIqMossAW4mreuqP8?=
 =?us-ascii?Q?Af1446u9CoIncuh390AG2U8t+xkONyAQHPcP0BX7fhi7kOlsl5OY7H/eOB/c?=
 =?us-ascii?Q?ugu0KjKr7cnfOFi+lsoX8oSv9iGgHhEUA1uQI4QvqLbH+1EgACZLwu9PB66o?=
 =?us-ascii?Q?CyL9Z7+PfGkOxsjXVKTzVJG2gyw6wxFmDspaNd3t7HSVpLx1oDNKTlcPkHei?=
 =?us-ascii?Q?0PWua5nRFZxhW0p+EP+n/wqjX8cDPNOLTg+Cb+fAFs7t6c11yPnHJVppoBIX?=
 =?us-ascii?Q?PRInW5T+E4BRl7wIdbic0cKffQtkd875ihbGaW5BpD1KZf0zt4EalsuHPiqZ?=
 =?us-ascii?Q?xtTcFejpRuDsyaDwQhrX4Pf/ckr++O/cfLL/tIscQksMH893yNL/zxCycuyL?=
 =?us-ascii?Q?5gH1houUk6W/qfPt0nDo71B5bUbS5BZ+mbPVRUP2feLeTd0o9kqlvG0me0J1?=
 =?us-ascii?Q?mzTl9X99UV+Jl/hYn2kfZ/8cOKN8dYyoAaHpyAM/rEHs7jhLt9tnPxJPsl5x?=
 =?us-ascii?Q?OtXnctod3WpgheZXBYsYTF/uWHuavVGNj9Qx35OOwQoik89cWpaQrTHiRYxz?=
 =?us-ascii?Q?yt8WTQ7tOrsCi5tZIt1vu+CX/qOs8qjPmzHBz7WbaWl2HwRr25pxffT/ST8i?=
 =?us-ascii?Q?riZbf7b8StPk4yzqiwFHtO4KOl6P?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7439
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dfd91b71-368f-4801-295d-08ddde277c75
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|1800799024|35042699022|82310400026|7416014|376014|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6EInhdGRAXNsbi9QLuzgXtPnuuJSKqQGyzeJPo5yWWfmZD3libU4oiIl/6PR?=
 =?us-ascii?Q?tDsOnTArhr32huh6hShKre++GMHrQqX6B8kZsh+t6MV9oy7nB6v0dTbgT7J/?=
 =?us-ascii?Q?oUcGBwsvQ6zbUoz04ZJmXZxXUPRgbJbjoLKC7rolUtMXewjJWwpWMNZQMUUm?=
 =?us-ascii?Q?fqWzlMo8tlid9ouhLFhMnNNLQHdGWcCVeIkErUVOjulklQaqs7iLsgNE2xSE?=
 =?us-ascii?Q?2ZgLKpL9XOlyXxS5NzW7brXgRrAWTtUYSowLBd3YVm/IdOCV0sJMgDe9Ys3V?=
 =?us-ascii?Q?A625KilaFZpWaE3MHS8ot4xAPG2Z7LxJaGMR4fxJ5hymcKBGccGm23bXuNAB?=
 =?us-ascii?Q?SLJJEA6S70y66WMQLyzrQ1CVFnF/ZaCyIEQjLMoPFseP7G3Qa9V/Qvxcv1uE?=
 =?us-ascii?Q?4hXmAzkbpZnCZxphtvu6L15sUfeiST+1h+s2SBDgaUDlJJACI47tudQ3GoOg?=
 =?us-ascii?Q?W0nj11HNQUCf7m51fRTqPthBD19Lg0yTDgFTHHfMTooHzdF/9NgNlM8nG+EQ?=
 =?us-ascii?Q?pGhBqs3CW6UDq0jyezHftrz85Zj5QA32rydUF6u7YZUMqUXEi+1ES1hwahIz?=
 =?us-ascii?Q?hPTXcyUGV21BSHd8dW5O47YsiBqZHXaTIY/DVpOJoaG6lTyS+On1jEpBuXOQ?=
 =?us-ascii?Q?vmVc7s+mRWq4p5S3o9u6VwkyF4g+3+Im6hjblYa9MQqoEbg3ywNYOsvQ+rUt?=
 =?us-ascii?Q?yyXwAsmaJsHsDYbYCn22kf4iIM+W1YZH81/Ue5Ky17Cmkq/Vp7Zqxw2e9bb7?=
 =?us-ascii?Q?sFYm1O04oXEluXvo9/4XZ8j1xt+T54FhYEo/s6bIiRB9ujv4UMXWv+/GsmG1?=
 =?us-ascii?Q?GPvJYbQbwRJdNOkZzPZsduSq2rnkekbcWKeuRf7QPfoJPPCnUWejApzD0Hud?=
 =?us-ascii?Q?GOBHtTpAjbKnZcfwvcKcCW50ww/2sBjojwkdGOaKhodZ1lTTJar5dhIWJ1ZS?=
 =?us-ascii?Q?3IJDw0TShyzStim9UhvgJ/SYyZVGZ1aOCjFCg+ty3LvDfQvIYZdLQv8IpggG?=
 =?us-ascii?Q?Kbs5yjBxypWudz4TOdImCiqWKuE9n9IF9yLz2BkRlpUC7jlQymLiiTQ+okF1?=
 =?us-ascii?Q?leFU9J5BQRU2SyZsjd+OU6P2FGHMcoPxfjMBl+dOGqjwVWKiBbKDYs0iR3/N?=
 =?us-ascii?Q?CGE203ci/sXGkTkbTQICwnHVKm9wt9EBi6DGFv0BS1yL0mWhesC/vOk6khxS?=
 =?us-ascii?Q?kzi44ywWkvFeEjqLjKb8c3mdHpb47LPHEjGNi8mLaRahWtuDnPXTfYlxPHuq?=
 =?us-ascii?Q?ac9wMEYm/VPM6oGABUZq2936bAuR/Eh5XITc+utybbRjRO+gevXzoNNgPLVj?=
 =?us-ascii?Q?7VtChYgtj4YFSsyPN6EBSCPE8hWh790oxwqy8e/YCiexD1HeNAddS7UKwhf0?=
 =?us-ascii?Q?1Btk4aVGWeA4lEl01Fp7CDC3FjAxsENaB6yqwP9L/ebw0NKlqPGlKeQNnAmf?=
 =?us-ascii?Q?hBeCyUdl7IE58SsQ5ADU616uNZpZusdGsPcXXq9ltlziHkrAZiJedg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(1800799024)(35042699022)(82310400026)(7416014)(376014)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 07:19:26.1638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d49688d4-3551-49a2-01fa-08ddde27904f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008860.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8887
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01ABCC000F
X-Stat-Signature: 5tccg8bp98ehz74zkipxcb5dq5iey69p
X-Rspam-User: 
X-HE-Tag: 1755501590-603316
X-HE-Meta: U2FsdGVkX1/RYNeTlxMohnT0Xy19cUHHMCu+EAi7TQT6217UjXcAennoPyq3KCpWeH1QerPUuR0yPcnC6HSDJqxiNc6Q67yfvpRbBVymb0rskMKTOapUpiI1R2NcwUImLbUdHFzju/zrYU5jsibIEB3MehjcTjHi8hG/OI4q8fO40lLB8jva9hqUZT3/jWWSbytrsgKHDlTHQj5NkOi7mNM8LdHHIdpMKTvdoetYAT7PS7g7DBqHl3mi4Juk7qK/FmyllwDHEwgUXp4bZf/FVjKd+0VwjpGB2bBkkUUyjK3U/VZbSSXhe+7+vmfUF9nbrF7e7dybYd+vKB9C1VISiWFbk9i3HozJAlEesY0OA1uCLh02Wlt20mH/EB/ZHINwM36VKewJj5NJ++UxmuwrKNdabI+Jdj9HsPjt3JupYWSZo+E8aWta0W4TGdfcbGJ0kQmYSDmFv9fHUmW+OSFrE72IDrzic8Z51VobqM/Rym4VMc0olC87i8Gg0Ys7ihY0VqER08qT+VaJL80xS7oBDYoo+Dmpj7T8NnOnZTwzYHDp4KRpj+iMTowPCJX5pg0ENopSLTQclRIhJC+FEfUINkYmt0Sjch5F+jPPhuzuoqax70ifJusWIPXckS6b+Jc2oTmQ1m/9CE4wkUJ4F59lj3Ty6qMPquekJ2UDuJ6twx/hk2QoXuqHKDphHxv1FZdG+NF+xgt+dbqWxUzd13GIgQgMcOnyoIU7QBk+zQH39Irxe5osaUphNvdobbG3Cr9FRREoUzJhNd0IolucO/v0bkgw/CnOGYsIcpjPMpjNkh9c2PEpkR5TX90njps25izweHJ4zN0rMwBjQvhBV9uu98k19xbDVUOi0Eas/jd5jXNPYW8xY4Ac2+wxPX/kehS/2xD+g6b8QlcG01m1HhnTyHBWOi1Oj51n3zVFU0MRL9ib7ACTkiqOS24Ysaepbj6gMXeHV/8nsk1Zwybt8cH
 dBKW++pU
 LR8HPqbgqRy3GaSmm/genFT6XrGmYk4NoABBwpUL3OOjYwqNt+sqF8wszjLufn6p/zt3nr3PFcy6KArCHboQsg9LPSukVcPriO/z3PCtByQ34/pZVRmIiXG/E5svoMutX8BfvszZxzUOcrBOtUNF8D9mc8H854GZCen+94js1DVXLDn23Jt+NtxpHrexp3QobCaXRcSpO8t9Uie6c7ADeob5bt3DBTCRM9hTCfBC2nCCEJMEOlNEVsSemvXVmLDz2npymYgDr7VQVG9PK1kH68+jtxkx+UKE/KoqB0qgtaO+H4EQkfmt4PRB/WfXRXAfnKL4IKPsChbDcDcpVyPULBwNGHHNF3eYeNME3W68MxM11vjnBu9pXd8iiXYcNdUe9Pa5xZId8+DUhGxT+a5nS5i2Ny/pYFLJgEjwHh2l4kC/UzAsqCLZnjgf2+l50j2nM5C0NuzGJ2REAk6j8pNGOcB2a9hPxKz5tSDGQ/kC+WNOVBEAXF/1fV2lnxwdz2lkRlWxqk/SSJdxAltPgSZr/q8++m4n26+y1HoZVIdQQMKksTWYCKIpED8eWFwQrNJnaAzwyC+1a8hnfGse6CH/xxJOvXONfuFssi2Z6l16DNSNklD1VAfEP0ieYsXNOWfNoCRDZrvMf290DStwefTxlwdOMUi6/E12sggiLLM9Lmv7S52SQOvGkNWdUvNQl/whMTTffSdyjYafi/ow4fvmjCnG/KJZP93vTciTb6O54sRTwJkOvfLh0LlmCnEydxfTzuMJmDWUu/UEQNMbKgRj9WNK7IyGJNh5Bv2IuOVs+7a6JvQ8JWOxdPdd/WapcjgFwpLHrZNuX+f52uNUM5qmZxJs04aACuD+GHeMe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi.
> Hi Yeoreum,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on 8f5ae30d69d7543eee0d70083daf4de8fe15d585]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yeoreum-Yun/kasan-hw-tags-introduce-kasan-write_only-option/20250816-190300
> base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
> patch link:    https://lore.kernel.org/r/20250816110018.4055617-2-yeoreum.yun%40arm.com
> patch subject: [PATCH v3 1/2] kasan/hw-tags: introduce kasan.write_only option
> config: arm64-randconfig-r053-20250818 (https://download.01.org/0day-ci/archive/20250818/202508180747.PxkbPnyA-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250818/202508180747.PxkbPnyA-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508180747.PxkbPnyA-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    mm/kasan/hw_tags.c: In function 'kasan_enable_hw_tags':
> >> mm/kasan/hw_tags.c:433:21: warning: comparison between 'enum kasan_arg_mode' and 'enum kasan_arg_write_only' [-Wenum-compare]
>      433 |  if (kasan_arg_mode == KASAN_ARG_WRITE_ONLY_ON &&
>          |                     ^~
>    mm/kasan/hw_tags.c:435:18: warning: comparison between 'enum kasan_arg_mode' and 'enum kasan_arg_write_only' [-Wenum-compare]
>      435 |   kasan_arg_mode == KASAN_ARG_WRITE_ONLY_OFF;
>          |                  ^~
> >> mm/kasan/hw_tags.c:435:18: warning: statement with no effect [-Wunused-value]
>      435 |   kasan_arg_mode == KASAN_ARG_WRITE_ONLY_OFF;
>          |   ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~

Grr. Sorry I think I've sent the wrong version.
I'll fix it.

Sorry to make a noise.

--
Sincerely,
Yeoreum Yun


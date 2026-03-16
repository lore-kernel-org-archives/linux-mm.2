Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00519F53D6E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4440A6B0300; Mon, 16 Mar 2026 12:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B9B6B0304; Mon, 16 Mar 2026 12:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6886B0305; Mon, 16 Mar 2026 12:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 196BE6B0300
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:13:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E22A3160313
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:13:13 +0000 (UTC)
X-FDA: 84552420666.17.111C74C
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013038.outbound.protection.outlook.com [52.101.83.38])
	by imf01.hostedemail.com (Postfix) with ESMTP id D0D354000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:13:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CIt8yuHL;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CIt8yuHL;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.38 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbobtKf9LjBOwrz6b1xQM5v1ZNc/Vjtdj6go1Dm4bqM=;
	b=6/s8N1hvvXat40NKynaoEuJjhiHrBzx0XBNxx6mE+/hL+bkvCzrcdISO8/85sHopPephfy
	zHfAyo4pRrzjeF07M4U1K0jesb8oPu9LoHOhreYtmOYIPXlOOHfLSs4ut4HGSmn759oM2l
	ou2a6KWJC61StVyzd+hNFQAjW4kD8oM=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CIt8yuHL;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CIt8yuHL;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.38 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1773677590; a=rsa-sha256;
	cv=pass;
	b=iYWCJskllgl2EfuRdeQwKJtCbXlGxljvKwC1EC1FkchC09BwELWZptGlg45U1TCJ73Vod9
	nhoC3QUcNKasSnF/Mb22k0vluyJobfakVrg9ujtjNZYY2L08I3Z6IPme7JdVf2fBeIKoGZ
	Ia3ikRYap4f1c2MQpnTk3z0X7pj41B0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XrgoEM4tIoXDk+0k0rcyJ7ai80h8UIVVptyg8gixtkbku8YdIRRdU/uNZHJAVsff7Hq+8ITo0UTfxKrKPReHAWm7Ng51T5ca9owHgkJJwJ1eptEtBpEnMwO524O0Np/JTtdc9Qrxyar1xhXaBzOwjtU5tPWoDePNpTOREBL4uMoR6iaWaDbxCgJZx2XL8lYAvsjxn6GLImoj2g3mtfQluP7HCRNwGfrQfq5TWfwAkSuFTI5W7jmpfQoIFBOaeofAA9CepDCsrsi+6mmtNxso6GTu3mplQEfICccvyCjaXeyWImK8gYbgG78NOdwFC1LEVkWP2gQQFHSc4/DOLeEH1Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbobtKf9LjBOwrz6b1xQM5v1ZNc/Vjtdj6go1Dm4bqM=;
 b=TtRPOVic3gsj0/DnZinaaZ5Gp6G+sXL6KPRxriPUqkWv8VeI0oPY+FlbuPybQt9JSUu1pZ20+0Qb9PFC3ns84Q5CO1QC0+KMU5aybbAH4AACWbHh5N2OQyZ3RHR8z9FeLjzqOHQ5LERdL0w+tW0zeiOOxVqsUMO24VeEL1PME/ds43pOC5Bd75jvLCx5W0VG2C3M+sDRABGjzrXeWyk/s6CMZKOF47I+Ty7Bl8QED70zpgtpUeUL2wCrWblR1hepnv8L0HSjJUIbtRYbG0STi+Jv3ItZqAExJfhbMNIb1w0EvJ4qtx1T/FMSKmh3eTiApRInq4h88YeZUi+dF2W+/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.cz smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbobtKf9LjBOwrz6b1xQM5v1ZNc/Vjtdj6go1Dm4bqM=;
 b=CIt8yuHLPfSOgFszSHtZ230BINXkyiB5e+s1ml+i5alKjNqUkfCy5Flg5xnSnczeEBqH+DyvXTrbruS/Y8G+fgASxuYB8PuOQ1V3dmEQ2V2m17AO+Cz178fqNfaSFrqLz/r419OMikxcqMUm4ovv1Nu/DS4wonXmmzi7suTW4VE=
Received: from DU6P191CA0036.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::23)
 by AM0PR08MB5444.eurprd08.prod.outlook.com (2603:10a6:208:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Mon, 16 Mar
 2026 16:13:01 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::bb) by DU6P191CA0036.outlook.office365.com
 (2603:10a6:10:53f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Mon,
 16 Mar 2026 16:12:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Mon, 16 Mar 2026 16:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uq3meWZ9xoP1i241PQlmZP1DSRnycvooBlvDG21wps2+zdkeiv1bZDxGC6p/rXx0BMtuTDBUqx+3G5KWKUqqoEKcVbUMCFnUOmS5vswV8KxhpW6lzi9jRblp7x6/YjNb/1Rd/5gTyO6mpk31zeoAJKgoSS1TXrPn17vnGoCinOD36OFgHW6K69UVmQimEqARfcNHmNIVvKakZe1Qfhcn9ozaNv1l9JACpnhNX4dp5R6YA9JGsA/iSv2vljrwSYDzn76mlgQIDhzQ9BjpTnF/sG2DLeg4z8j/JIq+6EGcqKzCOf4tnMoqhjsQbtLJVnDqfP5u+aovAbmECwBoRGM7KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbobtKf9LjBOwrz6b1xQM5v1ZNc/Vjtdj6go1Dm4bqM=;
 b=Zn9cncczXhwVpmG6hfoi85ZLCYLzrrGlf57rtc+3WctUqIJUdBhinivWLadCkaHawQxfzyxbEQxM2HZAxo+hRjejo04uEtMKQ45I5UajBnt8aB0/MgTy559RzE4cyXHqRK+2Lfx7cpNdzcBaPwqeIXhPDaV3/1VEwGF2RROotXBwXSXTvIDjB6adKhHgrqhaHxMm0CCwJoNy+ed1kbuyjRFRfUX8E2QGBq11KBGAOSUsf1IuVdxoTRh8jmwHlITjrwnuHrD7XPrYmk211Hb8xet0mfyjAiXVdPq1InHfR/6iKOIRD3lRXVYBbheZKK8kzoS8PfTrQ5UnXFMO7kLZgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbobtKf9LjBOwrz6b1xQM5v1ZNc/Vjtdj6go1Dm4bqM=;
 b=CIt8yuHLPfSOgFszSHtZ230BINXkyiB5e+s1ml+i5alKjNqUkfCy5Flg5xnSnczeEBqH+DyvXTrbruS/Y8G+fgASxuYB8PuOQ1V3dmEQ2V2m17AO+Cz178fqNfaSFrqLz/r419OMikxcqMUm4ovv1Nu/DS4wonXmmzi7suTW4VE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GVXPR08MB11095.eurprd08.prod.outlook.com (2603:10a6:150:1fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Mon, 16 Mar
 2026 16:11:52 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.20.9678.023; Mon, 16 Mar 2026
 16:11:51 +0000
Message-ID: <0c01dd45-36d2-4299-930e-47851f396123@arm.com>
Date: Mon, 16 Mar 2026 16:11:50 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
To: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0523.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3db::28) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GVXPR08MB11095:EE_|DU2PEPF00028CFF:EE_|AM0PR08MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: c13c9f11-3ec4-4504-c7a6-08de8376e521
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 FBBQXoAZqmOL8plg0C/HblomtwIXHxNIVsOSuvMvFkWFZmd9seUGgi1xFNLSvYSXEqaaUPSd3geWjYTYy/hAH6FMvIJGb7BCItV/LWmTup1ZQbSF08EVcYLqMzxUPwe4mmhrz6ANiTOVEJqV86pjSbTJC0AbxzfLpMqy3Tiz08VWSGxfLw4d3m4jSL/c36xy2Yq1ycdcpxnxuHs7kHJgOc8mJUYj/UfN1PahpEucOi4UGHAme7VmSyXK+9MjNP/ztiPUV+TyG53YRPcjRXXEgj9dJIAyN28yOVAaXC+ppN6MRV9NKgG1v67h+MsbmGVKveQKxvbHtiVv2ZbHfERTto9Lbbc/Rn9wqH4g4qeJtFTNkvmcswxo5kLQICzaPLSxhDMJL0oNcEdmqdr1v1xtH3XIV8bgCQc4gw7GIQuRpf7XkkTCuYQu2+YQxHLZaE5YLSY41Uoe92rpHHK44Dsrz4PefsWdRcRnKuIDtEMcHLKdRupKYCM9IFUO8WLhpCBaTfXI7zgarzPuuUKSClj3gXlUEWksf6AsbL1Unn/zj/72gnu8E1X1OJfFhFSh/BApxrBVs0Q6l/5+6BXD2dfPmM+br6RXrM105jXMhd47r92md3zB1AFhRqCj/iziCgkWFDjTwVK24o4ErJtqhk6SqiR1IWBnoUmK91kdyXavIpRb+1Q0VdALBzAgwu5jl1fQCpdu5pRBlcU+pbtSFziDmKfm8FBkBj9knus/GucMmbIeXF7+SbDSB9oXu4ALGP25BDXQe9iWfonHe7WICpx7hQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 pYX/Rf/NrKK9iUAS5hNxXCunzs3YR3bq/bSa0zOdYnKoIrWvle2BhRwxD+MfWchvLoSixY0m1DmNTpLD3/43ZLh6fD2uE9maUUBcNW3r0mj9OZoUl/L8tLIpau3LXn5nLe3KlrMohOxcxftHcAKLL1mal4mELAh/LjDleAjghikKH1S2BdmxCAMSOSy0UzL7+Gqke2XZc7KBKyUb06fPGQNoAM6Ws+uoh9U54vX9LosPSCYohfP6F79OJ+Ez/OCXMDkDttZbczHWImxmAS1nnkpjcmkOw/elpEEFBKBpJ9VoUTQfCrrK4LT+Yz3j4xV/ADqin+028cAfq/vmVchjJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11095
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eccd6ddb-3f3b-4f34-e7f1-08de8376bbd2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|1800799024|36860700016|7416014|376014|14060799003|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Pt10nfFGjONLybPDavSnFGBMdNc4t+8Mv+UA/eg0GAtQoCradnVETsIGng5f216SHIWZRVN0rnRS5IGivqdeRBojt1ywRTAvn4Qru4yGqr5YPeahtHVSbCX4XhJv2yV4AeWmK+s6Pp4D3yi1AMCwFQjLHwfRASlUYyUoZrKIsYa7uuAodIRjXDkrP0rL0nOcSzG8zO3+mrR0VU5lDb1S/Gt1Pv7ZY5zGN5sQSsDBnqobzWmypKjOdzQlthKGpmHz5QWXK1dKdK+wb6F97soN0YbXokt30uAnvoFOlwrSEjWrPsxo6v8Regsz+CYztt4uBms8MIcPlp1DH03LdFL7uBiZupbcEFef+5Rf8YEq4en1OtJNNKi4sOfBQxAAIvrlhmnHeOJ1Fo1yoheSfCd2we4q8mpa7mzklNpgxVyuLRMExv3PzngxD1do/ZiUBuYJio7aVNvwfRUioPkyBMsbKJtOnb5nmoagcp6licowhNUWjk5pKwAWXLIR5AIRqI4hQLDiwNfeuBW5bsO8WcE5nZVZTN9zhRqIVxT6BlsvODaGu4DhEVtcuF3qPa9DjAm/aQOe4Q4K6crD9SRrbRWN7CGSqQqax3finE3K6rcUh+GokRqU9AdLowE+aqjcxaoypXbZcdKMaIu+8eCzCcISZCFKM4/AV9duzZh4oTuO5x3e7k4qixhHcgpAX4zbzAW1JgIenJX3hXjvSWuDXWzC7Z4Rm5LAqc6qfKMapO3va+r6tP8LroL6yIwCZTBfcHFf+U3z33XxhrN7ppqvd9EJDBWQ1gsk43LKW4Ih9oZULoA+UlIkhJgooIxU+QrRuyEm
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(1800799024)(36860700016)(7416014)(376014)(14060799003)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X91AjrgVqbxOJ+0X2c3VbQWeAoP5rwWNkeJ2xBhs3ivM1EuqxlirgRmV1F9dk7jeouzu8PBEkB19Tqy28EmwzwUENeIPndzmrYOW7jrdEDpf8CIx0UBHO0kvGfSNo0aqZJcsjOX4nKHAez8PQS4C0G0FdH7jT8+m8ccKHy03jXrDNO6N5k5vfRch7iDt1iOZN1I5TVKD9saJ9QgDtWIB1OeUJ/iDfuxNE3IU4NQiyB1sWHrA8zMhAtrDG+Eh73F2VpNblDxHBqFLB9ylMhg7eAq1c07zesj04M35YkAXUbNv1BQft5XQytQd9Dd5d+dqvVYOqt/+MmgJqsIjuCoixt5RY8tknhvQUhiKYE6L2eUEhRX5MGAtLCKvplUaIWOsZsEOmCnMGHqdApg9oQjQgMVe0bmYQLZ4WcoMbVWvaPbTGep/PYRULgQlkU2VhBvJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 16:13:00.5683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c13c9f11-3ec4-4504-c7a6-08de8376e521
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5444
X-Rspamd-Queue-Id: D0D354000E
X-Stat-Signature: q1o8xh84u3iahzeemz8kii8zhdatme6i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773677589-821311
X-HE-Meta: U2FsdGVkX1+WLcMANNgxvrAjgG6O0p6N2jDXdzW1I2O+L01IE0bIcvLuYzNqFU0UJvjRw0k5zuKz29lV62FLtjncU7u58WP6BZBaQtlly6bdHcq+KEzmOYGcTrqevRvquAZjOAhs7N+CT4e0P0NCtJLPFfmsgT/Ox5LM2jlb9xIYKAxctQD/T7fS+OoqMZ/+BLCiSa7hb2wJnQlrNs7DV01FsYSXENfNSeBvX1vPpz8X+aWoCZDFCjfNt4szufFZUCRH/epZ0zxCy2YD2dmbpwkUP/2+f9kRS2TnKHgsZA1CtqG4E2dCoCp33J36ZLFtSkcV0CRpvDadjbqCI0NnoXYj/AcrES3QP6rWPhqscU7N3pQmvkzfTICT91abjybAvmGDZ+pOwrxi6oMNWd/EZvNBIiF9TGZBDCLmIUONB66YAbhEqd7wq2qIHMEBpwK10crXDCPNTd0XZfNSjmw/YKIj5wL8E2M/fswTNjBnYaYYHLfqtxkfy24ufUOlBCtIGle8YyqJqVAQrKlrsMrTKGAYWYTfzmx47BRWQ4wYt2hEXwEhsBH59s6/FicWA8IKgNce2B03q2fZbNMMUKMsa+i2PR/ZbK8k3n7ZifbLPgq50d+13rGVlg/XGj0YqVbbN0Ar79p5XxmH2zDsZgD5THet8ALKPXSq2Dh3n+uk5cm0fDijhTpwmiLNYzzhBzGC2cEGX/iiM7OG4We17BN94aRbIeco3TyBm0ZFizSzp+uIXv0aMETTM9X1QXDEGRlsLIWOsA8IRD1s/6yp6qS4fJPYot5ykAGS7Ga7nRhx67CeA3ZDD/yGxKHWfo73YustLB7QS6+y0WfnEur4uMzls0MKhiw8dkIq/g6N/Y0/WL/HU185uZv/03WSUse4M45QaKE+2EtPZKJLhAir9Q5lb7tVijkT8s7Mh0Qy5S5do3EeSRGi0i0NYJW191anuzNCP6O8zM5Pea9FJDRtbSZ
 kMcmmJro
 qvOPDTdotgTDf45rgYTPme4Qoy3hJoZv/TYHY2OM3NAHlJIbNVUT3EuvQzcbVVfRMGz6T7UWPYUIetT5uOUIpxawRvjIDkqycAD8uZt2eT10UBOjNvNIV0XMPsVD9B0CGoHrdSUAmTRXxslZ3U57Blv3asV48QpKY79WzpjFwGRWr5letEb4uEAo/0maP/1R3WfLVVDfgeY63ahaT4JdCouGd9XuNxIay+yK3IwXQcdAzIVhmUs6LoEFCIqLkeIutDOgbqP72cM16u8/t+aZlBivaiQ8Sw8dSUaj4ivLNUaBfSXEFwX5v4VoxgEtZDx7oUsbgKDsfPuyqmdH6RKBzNE3/R9HKa9x2HFKHBCUNWPrcq/er6oAOQgtT1mcQb1nAR9UG145jdooIHKRVhDWetQXwzUGcXb/ukxWbKcyPXN/CWZommQ+hdyiX/bZLdin39ydbfG5/O8NAhU3B8evNCqU/agR5TdpMQeO0ErMa42t65V+3n5sV7KYmEHR6jIgkK8pejb2bSbU9vXdf2ZZYrFBWierZXBmQdQUbjZNEJUnbntCOwF60S/diLY/6rikbb5Zhb6EWk3tHvun3stQ2Yd5v8ELISD0xyVtR9eyr3eWSNwAOkrgwtBqwrT1E/26V7LzWGp5frH8tH5DNyrp1/4hyoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/03/2026 3:21 pm, Vlastimil Babka wrote:
> On 3/16/26 12:31, Muhammad Usama Anjum wrote:
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
>> index f82d74a77cad8..96ac7aae370c4 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>  #endif
>>  
>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages);
>> +
>>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>>  
>>  #endif /* __LINUX_GFP_H */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 75ee81445640b..6a9430f720579 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
>>  /* Free the page without taking locks. Rely on trylock only. */
>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>  
>> +/*
>> + * free_pages_prepare() has already been called for page(s) being freed.
>> + * TODO: Perform per-subpage free_pages_prepare() checks for order > 0 pages
>> + * (HWPoison, PageNetpp, bad free page).
>> + */
> 
> I'm confused, and reading the v1 thread didn't help either. Where would the
> subpages to check come from? AFAICS we start from order-0 pages always.
> __free_contig_range calls free_pages_prepare on every page with order 0
> unconditionally, so we check every page as an order-0 page. If we then free
> the bunch of individually checked pages as a high-order page, there's no
> reason to check those subpages again, no? Am I missing something?
Zi Yan replied in separate thread. Let's continue this discussion there.

> 
>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>> +
>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>> @@ -1310,6 +1317,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
>>  	bool compound = PageCompound(page);
>>  	struct folio *folio = page_folio(page);
>>  
>> +	if (fpi_flags & FPI_PREPARED)
>> +		return true;
>> +
>>  	VM_BUG_ON_PAGE(PageTail(page), page);
>>  
>>  	trace_mm_page_free(page, order);
>> @@ -1579,8 +1589,10 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>>  	unsigned long pfn = page_to_pfn(page);
>>  	struct zone *zone = page_zone(page);
>>  
>> -	if (__free_pages_prepare(page, order, fpi_flags))
>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>> +	if (!__free_pages_prepare(page, order, fpi_flags))
>> +		return;
>> +
>> +	free_one_page(zone, page, pfn, order, fpi_flags);
> 
> This is not a functional change, can we drop it?
Yes, I'll drop it in the next version.

> 
>>  }
>>  
>>  void __meminit __free_pages_core(struct page *page, unsigned int order,
>> @@ -6784,6 +6796,93 @@ void __init page_alloc_sysctl_init(void)
>>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>>  }
>>  
>> +static void free_prepared_contig_range(struct page *page,
>> +				       unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned int order;
>> +		unsigned long pfn;
>> +
>> +		pfn = page_to_pfn(page);
>> +		/* We are limited by the largest buddy order. */
>> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
>> +		/* Don't exceed the number of pages to free. */
>> +		order = min(order, ilog2(nr_pages));
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
>> +/**
>> + * __free_contig_range - Free contiguous range of order-0 pages.
>> + * @pfn: Page frame number of the first page in the range.
>> + * @nr_pages: Number of pages to free.
>> + *
>> + * For each order-0 struct page in the physically contiguous range, put a
>> + * reference. Free any page who's reference count falls to zero. The
>> + * implementation is functionally equivalent to, but significantly faster than
>> + * calling __free_page() for each struct page in a loop.
>> + *
>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>> + * can be freed with this API.
>> + *
>> + * Returns the number of pages which were not freed, because their reference
>> + * count did not fall to zero.
> 
> We probably don't need this part.
The only user of this return value is free_contig_range(). Your explanation
below makes sense. I'll drop the the return value and clean free_contif_range()
as well.

> 
>> + *
>> + * Context: May be called in interrupt context or while holding a normal
>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>> + */
>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +	unsigned long not_freed = 0;
>> +	struct page *start = NULL;
>> +	unsigned long i;
>> +	bool can_free;
>> +
>> +	/*
>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>> +	 * free_pages_prepare() fails we consider the page to have been freed;
>> +	 * deliberately leak it.
>> +	 *
>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>> +	 * vice versa.
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		can_free = put_page_testzero(page);
>> +		if (!can_free)
>> +			not_freed++;
>> +		else if (!free_pages_prepare(page, 0))
>> +			can_free = false;
>> +
>> +		if (!can_free && start) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = NULL;
>> +		} else if (can_free && !start) {
>> +			start = page;
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_prepared_contig_range(start, page - start);
>> +
>> +	return not_freed;
>> +}
>> +EXPORT_SYMBOL(__free_contig_range);
>> +
>>  #ifdef CONFIG_CONTIG_ALLOC
>>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>>  static void alloc_contig_dump_pages(struct list_head *page_list)
>> @@ -7327,11 +7426,14 @@ EXPORT_SYMBOL(free_contig_frozen_range);
>>   */
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>  {
>> +	unsigned long count;
>> +
>>  	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
>>  		return;
>>  
>> -	for (; nr_pages--; pfn++)
>> -		__free_page(pfn_to_page(pfn));
>> +	count = __free_contig_range(pfn, nr_pages);
>> +	WARN(count != 0, "%lu pages are still in use!\n", count);
> 
> And we almost certainly don't want this warning. Spurious temporary page
> refcount increases (get_page_unless_zero()) can happen e.g. due to memory
> compaction pfn scanners. It just might mean that side will be then the last
> one to drop the refcount and freeing the order-0 page. For us it means only
> that we abort and restart the batching, so we get worse performance, but
> functionally it's ok, and should be very rare anyway.
> 
>> +
>>  }
>>  EXPORT_SYMBOL(free_contig_range);
>>  #endif /* CONFIG_CONTIG_ALLOC */
> 



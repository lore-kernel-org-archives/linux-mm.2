Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008BDCAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609348E0006; Tue, 16 Sep 2025 16:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA158E0001; Tue, 16 Sep 2025 16:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45AC38E0006; Tue, 16 Sep 2025 16:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 315998E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:20:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8AB21DDBFD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:20:19 +0000 (UTC)
X-FDA: 83896230558.04.D1A9BFB
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013070.outbound.protection.outlook.com [52.101.83.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25ACA180010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:20:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NJ+tRNwY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NJ+tRNwY;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf16.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.83.70 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758054016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3YrmNehmqe1Ht9TRKWTelwYxC1g+CY9haqK59EB0B0=;
	b=rTNUf8l/6V99SMZnfLovjEyTSPzJG5gmc94NqmXf0SmzpffyaQt/DDo9LOflxBjNw/t7iq
	Bjwyb5GZGNnuGFW06JapLEh9k3belmV21UBoHnFb1RrkxtcqDZnvPqC4CHm5HORhiSkjJ5
	qDtqoBFU58WIppGGoSBKCsJ3RJoHxVE=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1758054016; a=rsa-sha256;
	cv=pass;
	b=J8jfSYti2Pu4RFc9xeaoLHnHf4DILQJrW0I98WIrCiEcAa2PfGtqn6cllFcZHVf6tMh8f2
	6ap/JUU5JhfD9+A/j9ZB2nrpQSdWyGOmVIa8XjZQAv1Xu89Ay8V+JP3bhlY3mPyqg68oLQ
	Xepo07ySedydP161LgKoHWMa0H69umU=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NJ+tRNwY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NJ+tRNwY;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf16.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.83.70 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Mt7MdtgdyXq+GYPSRX0N8Qkm7vnigu1qXRCVq1SjHrQUEavZMh8f10L29FJHzG6YijbwRSL7HWh58dbnftruORZijjs0wtFmajbvMLyLrxSN+iZMw9IZDe4O9Q9PStAjXBnSm9+rakEjEzbBWHFvK0az08T8qbH0mZYNWezehGQFog91Qdz/0mQOmnoGPTeFmyN5y0fmi9iIt9iC6CS+NPPTxYbR9oh1usCur3UYmA2jUlICmLjVA+h3EnKB1IYNzmV8y1UBZyE757FA2BUcZikz/gvdEH89plCuWTOYOZweqG1lpN3WyzhOrrg8u1YLxdv3E75WIcGHLP2J6Ugm/w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3YrmNehmqe1Ht9TRKWTelwYxC1g+CY9haqK59EB0B0=;
 b=NCPe0M5lsfkyWtCJXZi31mhed3fIR9QIFRisM38expgVOMGi+w034gIolgA52KMUuu1B231eMl1WOF/5tp8AqnV9lfLKkXDbFPXW5bZhHkFDOYedioq0f73f24B/3lix6b2iEqA20cC/xZ+aMv6mj1wvy6+YNRAS08WNXgz8gjhS8iTV0RgAeuk4xjrjLI8YAtY0twqNdB/uC7ytvuJNjSTLKwCKxWBbZqAqY07EKb4Yufh60Y96gKa6QBzEV+GiaWFiQbTcNuONhhjCA58T3OdYprdrmscT1Is42edUxERUkgM1BbgrIx6BGqU/PSvpjWrEgsRuxdYt+n6vssBa5w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3YrmNehmqe1Ht9TRKWTelwYxC1g+CY9haqK59EB0B0=;
 b=NJ+tRNwYnW+5cO1gKK6LjHgcdfy9RlTSFzIYeNbnuFTpaP7ofobdLkSPo3TmldWBjLwHItK+oAaPI2dJBc0znRYYHA0XNWDUYXwM/x7+6DfbwpN9g66QwGLa0F+Na7jqrokQ20VaYoG332Z3x8Uenfg1brW7l2lMoDL593lRhMc=
Received: from DU6P191CA0031.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::10)
 by AM8PR08MB6578.eurprd08.prod.outlook.com (2603:10a6:20b:36a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 20:20:08 +0000
Received: from DB3PEPF0000885A.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::95) by DU6P191CA0031.outlook.office365.com
 (2603:10a6:10:53f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Tue,
 16 Sep 2025 20:20:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885A.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 20:20:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O+dVUi6QJ8+erMATAE8/+NnNm1v8PIl61OyrfuR8i1XH8Ni48h9GYmKQR3O+Yc7V4jyzZE0ykw0EnlA5IIigBBJJz3NX34+hBB2d2D1BYUXPK2Icz1KzhjamhWFAR8NTtMPvqc0T1Tykm+d2lqTolrmIq59zqjrJszRDL932Riq1zjk16ZO+KN46tUdi5H8NZamGv3BNJ4lVUtV+UVAvukwGgFqThg/ME7GEAyyFjRlVPkvMAzMQ21JvOl+WCk9fSa+Oj/p9MSOevF0Y7wDHTP5GDT6MyqiAbDw5PLvq+SQrgK4611znNKfitFpDvCnRiVwX8iJlh2VNr7KiJuDS2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3YrmNehmqe1Ht9TRKWTelwYxC1g+CY9haqK59EB0B0=;
 b=RM4fidqMIB5autWCGUeWxq99bUyUfEeeCNzh4hTGO0uaNJ0Cq6k5yO3AJ30Ji9lLUTDkJF8nMMQfbDmBQ4EVfibC/6+ZNCRV7mDB+Fei5EhnfUWKQZSTIKolo5+vlWON+l4CicVeiFfeUQEVPlXESLA+SpQokKb3fmN12jTM6FbSnx40Wj4BSbvXHduxvTZs/bLYMIfd79FFUKhhiev0oMmm1PRdh6xNaUIFZ23mI9YSeaN6ax8D4Jc4YgRBCtkwWao5so2Ds16T9ZsiJOAa9pNSEDGG0Lcj/cDC+xD0E1uJI05sia1SD2gQB0InYPSgWBznXV37z6eGZTdiAbOpJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3YrmNehmqe1Ht9TRKWTelwYxC1g+CY9haqK59EB0B0=;
 b=NJ+tRNwYnW+5cO1gKK6LjHgcdfy9RlTSFzIYeNbnuFTpaP7ofobdLkSPo3TmldWBjLwHItK+oAaPI2dJBc0znRYYHA0XNWDUYXwM/x7+6DfbwpN9g66QwGLa0F+Na7jqrokQ20VaYoG332Z3x8Uenfg1brW7l2lMoDL593lRhMc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by FRZPR08MB11097.eurprd08.prod.outlook.com
 (2603:10a6:d10:13d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 20:19:34 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 20:19:33 +0000
Date: Tue, 16 Sep 2025 21:19:30 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aMnGUr9zeutyPpAg@e129823.arm.com>
References: <20250903150020.1131840-1-yeoreum.yun@arm.com>
 <20250903150020.1131840-2-yeoreum.yun@arm.com>
 <aMm69C3IGuDHF248@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMm69C3IGuDHF248@willie-the-truck>
X-ClientProxiedBy: LO6P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::8) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|FRZPR08MB11097:EE_|DB3PEPF0000885A:EE_|AM8PR08MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: 822ef14f-0e62-47d5-234c-08ddf55e6e6b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?JNDyuGhrBv4SpZSvkhKQHrO+l7SJDZ5ZZpLETbU1RlXP8bD+56GrdrHtERch?=
 =?us-ascii?Q?ok98uh4JdtCbXVAeEgQqU6qdNXlc+iAk5olymZQEypBGlVVnhQJlkYZPvOie?=
 =?us-ascii?Q?IUNqs2H8x0JLoMDWmzEp80OhgRNkoBMH04wSe3Ctn7eUL7YKL2yNEI5UGo9T?=
 =?us-ascii?Q?GvdvRBA3vtw9vtK07zTTq5zD858aX0iu2K1eGQI8Af1YMI9PssE0qDlpQOFp?=
 =?us-ascii?Q?p4BbKFaZSXk8xNHR4ekP+Agz15aXBCWwVtoZsTvZXAqhZJKfaLyQPPgzO6Kt?=
 =?us-ascii?Q?dcSe1K0SkFyVehW2uo9JisrYSjbIJjuB8YcoVinox7CYWyZXTm3TYTafoOEe?=
 =?us-ascii?Q?jWn4ZoGSD3aClSStEQsH4gBZD808BpMpn+7j9kBIoWRBjxKquBj13wvDKzCM?=
 =?us-ascii?Q?OrvdqDb2dgkutxG+SdgQoxDBBPYAAHg7cn9kwxXwxqqpjjYf16IVjg/9AvAu?=
 =?us-ascii?Q?GYaWhYZw8+QU2NEBLYXRrKG6A4irJRKH5spRi4/R+HxgXJs5afUfv/xo0UEz?=
 =?us-ascii?Q?UZs8TaH1BXzIiUHWNritXKcO9SLN+DqkAWCk6z3jbwKdovPFU2+QmNOQjgBf?=
 =?us-ascii?Q?+Dk2tYTIBPegN3SaIVmlqYLZjItYB2+sxXHUEr/gPEgGMA24s4oBKcn3dUvh?=
 =?us-ascii?Q?wnZZH/Z9u06JeZ8NSfQl2Cnn5Ez5Ry98qvhccz9wCj78f9aLxbwlM5mXIOUK?=
 =?us-ascii?Q?hbnWn3/yKX493FQZEduyzIeFklKwxXgqmPCXASmpTrIfm7j+FU4MDpiBopzh?=
 =?us-ascii?Q?qcD+Jd5pk41jVYTorqOv2Io0Lvn6gXiUJlGSkO8jpIQdFoqkJQLjRXnw/Vyi?=
 =?us-ascii?Q?1SqXkGBKO6mkhn81glgv1IOu7VRyUqdeOSiZUWEJOg/w/MVONSeEVyBtdSd7?=
 =?us-ascii?Q?TU16V2NFBn/GtodA8klCJJVLeE+Yxd4Zv2u+j0F5iLB5jkWgn8MIwP1jZ6+A?=
 =?us-ascii?Q?AuaH/t3IYQnl5ZoaZpChjLSU7i15uWbvt812XWKkXZr3qO4dxj/AyMrZERfL?=
 =?us-ascii?Q?N3lq5lUNSpqeabdGcrSopasCYmyQA5NV8PTYFWchWFu8pffJm2baK8lEj0yx?=
 =?us-ascii?Q?pUx+QTA+Nrz1QGtkkQwBymNQHht2nUmvMRvqHt/JLi7ZODBMjPHaaZXmSS0B?=
 =?us-ascii?Q?JTnm2HmDQ/27m/1bILJS/FLe36YaJowJVFAa30dFM8GjDlavvOes0uni4QLX?=
 =?us-ascii?Q?an/7Yv1yWA20oj0l6RqVztVYbr3mSMZj9dCqG6QglwO8Hl7LKHH1Lom4FsRI?=
 =?us-ascii?Q?gcl65e9RgApJWTKuNuLEs/GbH8wo4DlnnqMJuJJVqn5d6KshqHtjvXHreosG?=
 =?us-ascii?Q?I43N196UjaZsGftuhQV79y/gh43mQf6EGmb9yigsHe2TwMySZN8MFm5uBRTx?=
 =?us-ascii?Q?l+UG76ylwzOVpxzzJdG3rS2QdHPoW++H2D7tV+OkPj8ALiViuCR36OeE+Y34?=
 =?us-ascii?Q?+Aal+mB1m0w=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11097
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c3807f4c-f252-444b-bb30-08ddf55e598e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|14060799003|7416014|376014|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iGXzVzR0KlbvwFvy+AiLW/ip6uiWEGFIyaspagtumpEmJGnxf49laKFPeaXJ?=
 =?us-ascii?Q?v+ZOd9xLhOAA90jI+f08EhQWPr3FoFW8y3xCg3dH3v8hJ1rypk074C+q3sQ9?=
 =?us-ascii?Q?53mduiPCcatMdh6Z5NG/rIYboy8XIc13ogT7DDBXDXoyL0L8yTAQ8kalkkPl?=
 =?us-ascii?Q?jo0cx8/PLWxZV35g9+V2BrvI7lXxTVoWprws6NiGQK8pVZgzNDiNdJrK1tEv?=
 =?us-ascii?Q?q0uzfq1O45nNfTyLE557QPY0fyBjSsYQQPvR749KucAUcjTpy4PBONcYC+g9?=
 =?us-ascii?Q?rdS8WWSTbjAilhzQv7ilhQP98nKT0W1c0BkztCd4cjZ1DdUsW+j6+1x98+zq?=
 =?us-ascii?Q?xUxHs18c676qJn+Fdkc6rWQ9M8pLYMYZWxTPvxCynUs3pnyTJZ0yB8sm8ABa?=
 =?us-ascii?Q?mAVZEduJzcrcROpcJakLYAylOBc4U4d3IRkFiqq3JnDzsXlE2WnFgOahBeNL?=
 =?us-ascii?Q?Ktq1ebKj4Hs7jvFeK7FwdY9Na9XvdSk0KXlmajnTnH+xDgcYWNooE40lrdNo?=
 =?us-ascii?Q?kEhKvobUkb03F97jyMRjU5kL/IX9w/FMt0YQXHFWCMv49NgYcyT3WB/4Mq3R?=
 =?us-ascii?Q?hZCQGs4XjzQ9JbwfD3AN4pjwULfsN0bFdaBIFckcwsZhOww4HmXIosuYRyeW?=
 =?us-ascii?Q?vHPuJGgvNrr0satBwSp3Ry6/nQoPVfrKvDRGd1xGiOD2EOWUAYh0Tw9vMClX?=
 =?us-ascii?Q?ReMXpi3mszCEdDyDfT9h2HymEh9JZN3X0qqLm6Zfb1TVIoU3+UIJHbSvK+kv?=
 =?us-ascii?Q?melp6mjxo90BV7G6WkkyrG2nib6BmF00kl0JPPe6m8sNMQB3+pcdRI80xBMT?=
 =?us-ascii?Q?1jI9j10mUpmprkBprVXKmK+GlNxV3ExkCdlUx2luGhEvPW98Dep7v0nAUpKQ?=
 =?us-ascii?Q?e8q+1N7loWFe/La0IveOkhiOTQOovbdo6kpVLjVNqZYxu6hiM9oLd4xzmGNY?=
 =?us-ascii?Q?8Ipoe3Tpnd3BMNc97CSlbLb83gRv7HujQIxIF2R6ZqaC0V8wmYtMBgmVqNCC?=
 =?us-ascii?Q?i/eYL1VpQiaITAK6wt7AcYv3Xdp6VrL72P66jx9P69yTGNH4rGe1yRgk5X7r?=
 =?us-ascii?Q?qSUXyTx/VO3kwdS5Vfbv1TF17/0pRmp0TP7Hfx3BgcmPlvOsxsdcb58dQXjC?=
 =?us-ascii?Q?gvZLIAbp090i2QWIs1G7CGVDT8FhO1fAZT+BRFGQP2Doj/uIThRCGQ6ih/hV?=
 =?us-ascii?Q?dxoLSgX7OHYFGPTBoQBUZTL19/XvWu0Omfhm5mfFOFOSCwQsng60k737qz/d?=
 =?us-ascii?Q?qdIODzObsv/0uo/EgbzvLh3UwAor+Ks4FEF+BTUCrjs8PJzqj7MEKzMh7I1/?=
 =?us-ascii?Q?Vszh8q93k14zfxjniziao4jQhOk9vPxTZPME0iSyXRQQyy2TIb1IZSK2/rie?=
 =?us-ascii?Q?Rmfxzw2iIGGI/XKlfMZ8xH42scCetsL4qAfgFM1+v+PeVkRFK26r5r9CyEx3?=
 =?us-ascii?Q?IuGdbHvPnfOAi7Seu6kIPDDZXOVk2Tly31/iPf6RhxlR/QJvxi12+BwvXAqC?=
 =?us-ascii?Q?TnR/pUFlHB7LJkGQNgRforgRfnqLaSAVGiSU?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(14060799003)(7416014)(376014)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 20:20:08.3394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 822ef14f-0e62-47d5-234c-08ddf55e6e6b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6578
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25ACA180010
X-Stat-Signature: jj9hhn5pg1hb41bxf1c8xcfzmw3ihfkg
X-Rspam-User: 
X-HE-Tag: 1758054015-595824
X-HE-Meta: U2FsdGVkX19uaYyfimUeMJVfe/ClpmngSWYqf2v0V8OTlripXjy1UlSj5z9PBjhoAV/OsoY4jz8s5OxKkDh57kA/Yx8zIRodqWik1UxleQzaRV3NPd5cS4JTlFhtwNsVQPz6fZe/vzm37g8Hku68FSJOEvuwHYbyzmqwipQ6pgaP+ciqZewwCGGGcKIU5YNNS02fkEfZ9GKKazXZ93kQLXfmsYJ/dWSmzGUgg6LfI3dUWrUynp6gRwdRZnIHqSDYq9Oz2/0wqOxFuqNdODO+6C9SuyLwyZMf3T30GZwVm0L+G/mWFFqVUFD/OzeUhdyUA+wIDzM8QdNqzI9lCibISWoM0cWKTP1i9MuqwhlRNqbq9gQVB5q+Udruc6BL9lQp/vutAIepJsvBQGiUYS4VofAkRiSP8HCK69349zNFGKITx/vbTpjkuE5iQ0aFIPFADZ39Hvgl8ktReApiK9HtVSxoLIrz1pog1wbcFAq/chsleosYR5UR6Rpv/rn+mk5ZDbMqbCq6p5LFB7ihMmqmwV2UIt6PtsU4dJCKPUdZF+DHaejFOT2U5G7Jf06RtMdqKABmwZq6hRELC2DF/4WCg3h65PBde4JBO5eBDWK09X40n9KRwQRy0WrJfHMOPj4ElG5OyL3jq2uoNUr/0bd7GoeXR1V4s8HIoWR7v0wSh7SHpdE/0Zme48mi+no+hfjxt6pKNkjAIf14L1t2Xm6nU1sns4QoNW+0DwUQcEH2xKmNjvUQwRmO2SIjiHrC639AqDwJ0/9BdZ05AM7gTTmNauWtQ2A9v8IePR3ovnR8qUzHJFq5fh65wGVys3pAFGBFockhqkUmsiohWMnj7GJm16kZK2MejVjd6HyRNaccyEfD79RBvorKfnNnE3H8TG8mdpBS/V2wawtiulIHXaFVv/yCRUtn93w5nhaXjr0qqYG4lGi1+NuTsIfSuxO6M9YsZ9DzULrOQc//fRsOgjR
 ZtSP2xFh
 pglSK5kJnsUzoIv4FSm9y2aK+kPuiT8LG+ZTBIPmn5ii3wYq4h6sNnvGVH7v5WXmlAkjJStZPnU064kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Will,

> On Wed, Sep 03, 2025 at 04:00:19PM +0100, Yeoreum Yun wrote:
> > Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> > raise of tag check fault on store operation only.
> > Introcude KASAN write only mode based on this feature.
>
> Typo ^^

Thanks.

>
> >
> > KASAN write only mode restricts KASAN checks operation for write only and
> > omits the checks for fetch/read operations when accessing memory.
> > So it might be used not only debugging enviroment but also normal
> > enviroment to check memory safty.
> >
> > This features can be controlled with "kasan.write_only" arguments.
> > When "kasan.write_only=on", KASAN checks write operation only otherwise
> > KASAN checks all operations.
> >
> > This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> > ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> > with other function together.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  Documentation/dev-tools/kasan.rst  |  3 ++
> >  arch/arm64/include/asm/memory.h    |  1 +
> >  arch/arm64/include/asm/mte-kasan.h |  6 +++
> >  arch/arm64/kernel/cpufeature.c     |  2 +-
> >  arch/arm64/kernel/mte.c            | 18 ++++++++
> >  mm/kasan/hw_tags.c                 | 70 +++++++++++++++++++++++++++++-
> >  mm/kasan/kasan.h                   |  7 +++
> >  7 files changed, 104 insertions(+), 3 deletions(-)
>
> [...]
>
> > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > index 9a6927394b54..d5b5fb47d52b 100644
> > --- a/mm/kasan/hw_tags.c
> > +++ b/mm/kasan/hw_tags.c
> > @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
> >  	KASAN_ARG_VMALLOC_ON,
> >  };
> >
> > +enum kasan_arg_write_only {
> > +	KASAN_ARG_WRITE_ONLY_DEFAULT,
> > +	KASAN_ARG_WRITE_ONLY_OFF,
> > +	KASAN_ARG_WRITE_ONLY_ON,
> > +};
> > +
> >  static enum kasan_arg kasan_arg __ro_after_init;
> >  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
> >  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> > +static enum kasan_arg_write_only kasan_arg_write_only __ro_after_init;
> >
> >  /*
> >   * Whether KASAN is enabled at all.
> > @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
> >  #endif
> >  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
> >
> > +/* Whether to check write accesses only. */
> > +static bool kasan_flag_write_only = false;
> > +
> >  #define PAGE_ALLOC_SAMPLE_DEFAULT	1
> >  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
> >
> > @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
> >  }
> >  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
> >
> > +/* kasan.write_only=off/on */
> > +static int __init early_kasan_flag_write_only(char *arg)
> > +{
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	if (!strcmp(arg, "off"))
> > +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_OFF;
> > +	else if (!strcmp(arg, "on"))
> > +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_ON;
> > +	else
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +early_param("kasan.write_only", early_kasan_flag_write_only);
> > +
> >  static inline const char *kasan_mode_info(void)
> >  {
> >  	if (kasan_mode == KASAN_MODE_ASYNC)
> > @@ -257,15 +284,28 @@ void __init kasan_init_hw_tags(void)
> >  		break;
> >  	}
> >
> > +	switch (kasan_arg_write_only) {
> > +	case KASAN_ARG_WRITE_ONLY_DEFAULT:
> > +		/* Default is specified by kasan_flag_write_only definition. */
> > +		break;
> > +	case KASAN_ARG_WRITE_ONLY_OFF:
> > +		kasan_flag_write_only = false;
> > +		break;
> > +	case KASAN_ARG_WRITE_ONLY_ON:
> > +		kasan_flag_write_only = true;
> > +		break;
> > +	}
> > +
> >  	kasan_init_tags();
>
> I'm probably missing something here, but why have 'enum
> kasan_arg_write_only' at all? What stops you from setting
> 'kasan_flag_write_only' directly from early_kasan_flag_write_only()?
>
> This all looks weirdly over-engineered, as though 'kasan_flag_write_only'
> is expected to be statically initialised to something other than 'false'.

For the conherent pattern for other options.
Since other options manage arg value and internal state separately,
I just followed former ancestor.

>
> >  	/* KASAN is now initialized, enable it. */
> >  	static_branch_enable(&kasan_flag_enabled);
> >
> > -	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> > +	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s)\n",
> >  		kasan_mode_info(),
> >  		str_on_off(kasan_vmalloc_enabled()),
> > -		str_on_off(kasan_stack_collection_enabled()));
> > +		str_on_off(kasan_stack_collection_enabled()),
> > +		str_on_off(kasan_arg_write_only));
>
> It's also confusing, because now you appear to be passing the funny new
> 'enum' type to str_on_off(), which expects a bool.

Oops. This is my mistake from v3 :(
Thanks to point out ///

--
Sincerely,
Yeoreum Yun


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60366CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAA58E0006; Thu,  4 Sep 2025 03:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2AA8E0002; Thu,  4 Sep 2025 03:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669E98E0006; Thu,  4 Sep 2025 03:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 551E58E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:46:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0CA486ABC
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:46:06 +0000 (UTC)
X-FDA: 83850784332.05.405E3D0
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012001.outbound.protection.outlook.com [52.101.66.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A61D40005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:46:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pSGA9Gc+;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pSGA9Gc+;
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.66.1 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756971963; a=rsa-sha256;
	cv=pass;
	b=NOHErCPW/P8g4yL9nxXQ/SyUM3WILKhxmw0CCDAEIxvhnnBw+IximO/wBikraw5z345ADV
	TjcPFTDHPikvu4FC+yoTprRWu/uYOHPoV5zHf4paKvK7GtvOfPpNjdP0eRlKbH0hhSRhgu
	cuTXkAhs3R9QbRYaXzkiX34niP5N/Aw=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pSGA9Gc+;
	dkim=pass header.d=arm.com header.s=selector1 header.b=pSGA9Gc+;
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.66.1 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756971963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb8OyJNWkXoWbomOVdkD8jSMhnArCsbleFsCSjAudQY=;
	b=amHfa/b/xJuLqoaZWp/gSL71Id/MJkIZPeJbXXJrP8HRYnQL2COl/tPgudfozXW05ZfdSi
	Hk59Y2OUpOEWoXyFFhk3Z2/9rUCg9PnxE5V0/MCo4/Pdb1cqOWIxt8KGpJFE4HBcfheBqu
	qGmt0NxVQ/FzJHL54dPHPeAqLXuQ/7k=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Lq63AZHxRRs2Xjxr8wLTLMz8kD+QJ9KIhW8mptN2HFBZhCJdXA+Gauvdt6GGHMzIDwxo1/t4DL2kLYsxAAGVFgg+cMhab9tD202E7z/jWml8KjaIsePh3eNTgQLFKJf+coZynswFJuVkLYnNrt3DKy/O3+yyqW61ia7YV59fkWfLoRayDuDmjptcg9BkZ1187dYvfxp8KVwxeK84pMjXDkkFN/dVBPv4/Y65jrsYej23FU9OQMvv4JEfduqPZuMGeEBq6qxDWBdIoy3vvC06KtvwEkeDCnaAbeiwmMYPr3DAV0OZRHAmuUstM5+ZDg7dd8Yspv51JIPwU2DDQ6FNYw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb8OyJNWkXoWbomOVdkD8jSMhnArCsbleFsCSjAudQY=;
 b=vcPQDTEWLQeV9qcl7fUJ+j/mH52ofOJutYyn+MVAH2Bjd5++6nTuortcCi84HHHEN9ADO9Y84Wz7DhVGu2STsyBgT9saaUKH2uZ+LqI73eFJ89U9R8XUnvDWxX9xQEoP3h8i54rlgykCyLDbqZMssEG4GprWAoJrGyp8et/A3YtCcHcu8KIRjEaTW59tu5xs5ohmOR9qVppfARX1HZFeZ4kX7tT6uzqAuCvP8m9hPamNx025QkmooSPthG/YzQRoKvuqd44VQ3rlpMEWAhnQH1vejDMF7xcqQZiGr4vFuknfxJmUkDsb+upEaqAIosYWxdB6jHmOom4yhfBCVGS+pg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb8OyJNWkXoWbomOVdkD8jSMhnArCsbleFsCSjAudQY=;
 b=pSGA9Gc+acodALr8BADU/LusLrrpc1P65s8l7dB+UqtA09E4slAN69umSgHJZ1WG1Gx1V7tnxHSHqbN7GXYYQu+Ctxba9M3IiURhdU3ZoOZBPITgjFF6wqDRK2yB+1rl63c16oHqeNujauyvWQ0Cr8qsrAu6Yh3cGMFGEZq6MkA=
Received: from PR1P264CA0027.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::14)
 by GV1PR08MB11089.eurprd08.prod.outlook.com (2603:10a6:150:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 07:45:59 +0000
Received: from AM4PEPF00025F9C.EURPRD83.prod.outlook.com
 (2603:10a6:102:19f:cafe::a3) by PR1P264CA0027.outlook.office365.com
 (2603:10a6:102:19f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Thu,
 4 Sep 2025 07:45:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9C.mail.protection.outlook.com (10.167.16.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.0
 via Frontend Transport; Thu, 4 Sep 2025 07:45:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjdIG4GHK3agalbYIS5iOoSZAL0xg5ea6QGk6OEYef0+azbls06ELGmxxd4dn455fIVeT7p4jAaLYDopfQJzaolc80sDAo3IKdai7LF8hVqxivGTdObOIR0G18HPpl4jqqYRL3ig8FPGdwQWzJ1mdWpRb0maBk3IOv+0p/TjBAjpHCtnGuT8E9GQWlId+wYFPOlcy34ISrq5lRm2Q7NaRGZoRdJwNIS4pWY7xWd2+pVZIQbwe2e5Ft5VKRbvJlSU9PW4wZxeK5Kla90SYDGFvw0AcXUNlO3RZkoEuOCGKPVoMtbyZpht8I8jDTCNSb+oXTDJc4Vm9sYok4DEDnV35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb8OyJNWkXoWbomOVdkD8jSMhnArCsbleFsCSjAudQY=;
 b=OFUY3q+fSqzvWftgKcbXVOjvdxlf4+4cIzjHKMBXYKb1QthDyaO7q5NIYbaQPc3NN032f/iB2C0vzD/EoT94XHxJUEzzLTxLX5Q5FNtnFsLvponOdQ8z7Oj6ECuzB7I4zviTMdvRDQE85WOb5BdqNepGM+Tv05SPx18siiSa9ACdVHYYP7vW136PSWs7OawDnpTR6lYLI+7rOjCSntS3Wq7babvS6Fy0DRYVPGP8UZPiJ4e+dJAUwovYqcK6D/jmkKRyPgsCksNb991xEMMFv0q2pA99U8aRpsDxwXNsNr5h6MnxML9wow3up3ZRyUhxsciIfpP0+zRMXrF5006SIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb8OyJNWkXoWbomOVdkD8jSMhnArCsbleFsCSjAudQY=;
 b=pSGA9Gc+acodALr8BADU/LusLrrpc1P65s8l7dB+UqtA09E4slAN69umSgHJZ1WG1Gx1V7tnxHSHqbN7GXYYQu+Ctxba9M3IiURhdU3ZoOZBPITgjFF6wqDRK2yB+1rl63c16oHqeNujauyvWQ0Cr8qsrAu6Yh3cGMFGEZq6MkA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAXPR08MB7393.eurprd08.prod.outlook.com
 (2603:10a6:102:2bd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 07:45:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 07:45:22 +0000
Date: Thu, 4 Sep 2025 08:45:18 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 2/2] kasan: apply write-only mode in kasan kunit
 testcases
Message-ID: <aLlDjmQF0DSOqILw@e129823.arm.com>
References: <20250901104623.402172-1-yeoreum.yun@arm.com>
 <20250901104623.402172-3-yeoreum.yun@arm.com>
 <CA+fCnZeyKuet2XY9=jOdiK4Z6f4_=Xb5ZBzBaDL-2gFPv9yJ5A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZeyKuet2XY9=jOdiK4Z6f4_=Xb5ZBzBaDL-2gFPv9yJ5A@mail.gmail.com>
X-ClientProxiedBy: LO4P302CA0043.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAXPR08MB7393:EE_|AM4PEPF00025F9C:EE_|GV1PR08MB11089:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6bceba-7f59-48df-93b5-08ddeb8715c2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?5tpcSuMHSDR338XvUmkG5hqIm81h55AwZOp3g7/jivJPT1M+h2+KZcSy/9ug?=
 =?us-ascii?Q?QiABnMsCAa5+WSECX6hhiCmLm8gUR/bqTlef/+47tGw0+RwLKUiQjTUbHWjS?=
 =?us-ascii?Q?rlfjxve6YHV0Sozehhg5di2HUR0TCBOuApP7FAO3jatSRCy500I5jVQs84bv?=
 =?us-ascii?Q?/zODw055eoK8Qq4/Dm8lviOry3jW5r93h1jSFeTSOW1SQsQL53pCYHb2NsXp?=
 =?us-ascii?Q?hT+fL3pDi5X/IM0gnCwfkyJzVqJBuVqmu38xK484zyUshe9UOfDSM8ScULSZ?=
 =?us-ascii?Q?Okq8Tb3YW+r4x1uCdEqfmbrAWjwRiiijudGtpOBs9kwE7GhLdTPiIdERLoN0?=
 =?us-ascii?Q?jHac0WyPT4MTJLq1V4ZdP9pbZ6QcZquZGIDKxVrBJTxJLP9hSxDD4gusM+IE?=
 =?us-ascii?Q?2dnrYAUOAsBlkDEQ2o9YE/fLD8ieKOuEO6YqWafu6uJSltHZBzA9sDQmtmhX?=
 =?us-ascii?Q?AXn/+0syQeBF2pE0HEQ9qV1zPabPGZtgK+z9SKtLdZsq9k0cf510VZL2W4T9?=
 =?us-ascii?Q?66ujplk/mSJtfbnCS3rkjcegB+bENqLW3vHemRnGFeaREZOEqEZncPFtW6Pt?=
 =?us-ascii?Q?pbXYzvW1H/o60lc6/Zir3CIkb0BZEuWRyNbNA0tp0y1DSthji7Unab09jQiD?=
 =?us-ascii?Q?3lfoTNu4liaBMlhkQeCgPKLw53MhHI4C2KR6WLAv4vkom8RB8ZShX1w1L6td?=
 =?us-ascii?Q?+IIc8t23a4We5FFhWga9Ll0ztd+vajJIocVHUIp0NPfRv7TtKLjUhI9qg6+t?=
 =?us-ascii?Q?kOYU022UNpeTAycYngfSVxTUBrH4CKynaV4dVDhTZeM/sBLnnr+OLRNeMzg5?=
 =?us-ascii?Q?LYkv1vDWSWcGK3SE2fciR1MOpmuEpo88rrfzB8Who9auTd723Sxn9YJh+vZg?=
 =?us-ascii?Q?nVMNXIPlw0Mo5/mDIfgwyAjyno9OyXa5WUJ8oR0ANsnGc3nqxo07xmFe7ZiE?=
 =?us-ascii?Q?kwzoq9s0VfbgDHsXktO0oTZsiw1I808nmBqn+XMp+wXouIBjGds66bjh0m0z?=
 =?us-ascii?Q?7gR00TdWTZi6fENJpPob050k4lVK1E4v2vHV1MQSPOIEDFRgEiolEYtAfdKz?=
 =?us-ascii?Q?swnNDC+jgiyMKMkgvwU545b2gzzhCr6jGZpcvWbNA6AWWY1Ld0AJvyh9cnhp?=
 =?us-ascii?Q?gnPA8hfS5Zf90Dj7qle9+6N34qgLnt5ShNgaLa0vnJsnvfwBx86N2GBq8rPh?=
 =?us-ascii?Q?nFuKApwaphiQ5qovNpigSnJgU6m9tsfVnPA2zWIFbcM034HKRp4OSsuCgd5L?=
 =?us-ascii?Q?WLfIt6iszu1Kp4oPOPGP6Rzz/BqEVgUf91DC1GXOOw3fkEodN0AnsjiiXLxM?=
 =?us-ascii?Q?CIbtzFTUTRmHurLpGcctAt0I2T92hZdf5PvZG8igdpq6rQip+P8LXBRkwsNo?=
 =?us-ascii?Q?94MUfSlnU9ZzYiWtJfqHxn25SQs2vrw6o6oyAt2lwZkVQIR+aL0+kNjyj5x3?=
 =?us-ascii?Q?zsU1LVT7/sM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7393
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9ea77e3-b520-44e1-547f-08ddeb8700e3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|36860700013|376014|7416014|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wGbFgm/vmMXJjg0nb5oYdTlZShtxSzz01dwTjMsOnh3/I+vREKaMRb7qGInO?=
 =?us-ascii?Q?3iYddgW3DDafXUnomGe/xkJe4iJfmhFWByNcGh1t9LcBerpC0Ok2ix/ABsnk?=
 =?us-ascii?Q?HYBqJr5n9C2K4WdfvzWiYev28u2wBDkbGxxik44XXEvJprnpKJ0MhLc9ovkk?=
 =?us-ascii?Q?0bFHS5f5shGQv1TAqVjjHlGhA6bhdNKtphmSH5ScNEp2zNi9ofBjXJbLQMPE?=
 =?us-ascii?Q?l1EIXrS64CX4VlvcoWgc3sdGlffmyljf5guvOip8V+Xmnwa8LWY8u6rnJaPe?=
 =?us-ascii?Q?WL6nDyIKYb2NOSUjdPWf/QjW8AHMgKvYqWCcekoCbZ3CUF+1IHwTEHIFPBnq?=
 =?us-ascii?Q?GEdC1OMinG6oWCIK8f2/UJg1f0xxsbUHxuJmz0CyGvyVDLsHQXVsg6eP33AT?=
 =?us-ascii?Q?iaQHDjKyfotBC2uxgaoCkuGG9R1LNbvehqqu8e6O26i/N0YaiFzkXe91zGkN?=
 =?us-ascii?Q?E5C99mm+o6bmSbiuCVp2q6Sd28nU34u7rOoHgWRptHnth8rLGiJ8BLFN1QAE?=
 =?us-ascii?Q?lMMpAeuKQp11Iq6WAa8RY2cI3szf9WhwqC3EoQF1CjN/qtHy2mMElwQxsYw0?=
 =?us-ascii?Q?2FllUncuozlBc62UJ58oVA/Twxuxqe6wM93eU1TH8cTPUQqK0crs8p+F1ncq?=
 =?us-ascii?Q?QPQPNgmk64PDKDWOqpmKlx0WSFIaHRp1vQbpIgE2NFGE3A0aj0F4Au5HtLMl?=
 =?us-ascii?Q?pLjApHF47P2SVZDSBTxRXEjxX/Rrp1YaAFTr/pGPGDIyoUlIi/9d5DlBhebJ?=
 =?us-ascii?Q?vPsRCCHFmSZN0htNBuqjWdY4S3BeUZNqje87tbL6XAA/QP0MtlXSgVYbcR9R?=
 =?us-ascii?Q?2vkyDEsJ6MDUJGrEJOgsQYmv75l5ovWohFf95Z24TV5gn2H223fLshmdoUG4?=
 =?us-ascii?Q?FsQ4ttcSWylN2fNKDmuotU84e0yqQ8g7wwO1j9xLFuoOQ27Hv12CT7XTdXy7?=
 =?us-ascii?Q?wbjgAGY7jHy/7F14UWMe0FxisJABLysYZW6y+LRwObKO3NTUfLeLe0buvkQg?=
 =?us-ascii?Q?7mSNOAgtikhPzKOWr6eBxzxb3+7ZUlGRaU6PIAy5Qx8gHfu5vHOy79nTivlv?=
 =?us-ascii?Q?0VWzal8FmBhLLeq4fMeet6BrfAV7HXhEHxdXjs1fHxTgZD7O7JqHiytoNWnQ?=
 =?us-ascii?Q?8apj+yyP4bpXIhGR9mfsWJl2CYkSYMXL17xZqm4fsJu50MPIv0SYpdek08ak?=
 =?us-ascii?Q?anzfoOUOLQWgRjwBn9x4enYqglxGq9QYuzLFaQhiOZx1Vm46Kq/YcQizDJyU?=
 =?us-ascii?Q?aH9iVVnuLXyHF081E6rWmYX/SWusCpxS+Suo7deeRysmIlrufdFl1bGqTeP9?=
 =?us-ascii?Q?OoLdwlNkLsDPC1eQLOSN3tOxhw7HWKxm8proMkQXVsDKtIIlZ3q3Q4F4635H?=
 =?us-ascii?Q?ypRZ3QsRfAohcac0mQ9GrrUqfrpg9SEGrjvtN5dwEXDAIxasTQxjQt3y4E75?=
 =?us-ascii?Q?F3p7H39apXDA6afq2z5t6th+KEnNPbKc8vjI2SNy7oTa4WO+0lOwPfjnVlOd?=
 =?us-ascii?Q?QzXvz4WGMjaZoBx/5eCobu8kcuiZMIwkCNu+?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(36860700013)(376014)(7416014)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 07:45:57.3702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6bceba-7f59-48df-93b5-08ddeb8715c2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11089
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A61D40005
X-Stat-Signature: 8ub8ro8616nzw35o3g94ts6kymf9iice
X-Rspam-User: 
X-HE-Tag: 1756971962-88349
X-HE-Meta: U2FsdGVkX1/4m+nO1q7SuRgXwL2UBjkdWCNS1XJz3kBXUUw7780vrpRw84bxCNNfJYWZwvkgQu3UgYz+4LGiiE4UVfHYXZmUDhU62X56ZDhPeoaKdLbsFcoVk+LXDaddXddSNhTjx6L3hhqV97CRVBGibQk6H0ITrMy4x+2MK3lbfsieC+HJHCGX6w1RH9NPxjvqOHCO6D+Yk72AFxE++RG0uhryngD59wxBULVOJK5MSgtiRit0/3Ai8YC7RcrjZ9mVlp6wc9n61srMZQTErlh5qbfEgZycgD8+bSMnA+A8ehj5sq4C+xdpqPK64eZeWC4TN5lvcNwVAAof/Yrd+oGhalYEnkqJlbicYSlqTGRUsv0do42US2A9v3kKAod2omFnBSXT1P/Px/zehmHVyqPYlnrDxXxwuj/Tb85+HVezmR0NhYojprFTadqpOA5sLj6WXO0vXOKbpSATOg3d60Kx0wnFZmrXpveWmmU9dxcUhpATxjR+7jUNyrrrbKo3eqQKZf5h35NtzcbIgUSfNEJLrkUG8MTcNwvG4wuD8r4FCz6hasqOdMY7fW6QI+z70WOsDd14hDUmmIhTDU0ZOU/FpembpCQBOPLwb/CfqTGS5GSNEQNduXKWAJaaNU01JBxr2v4s6IFelJn7cye7WpEAGUNjPADKMyQbNup2/z2E7Nvnr2qgOQeLpavz7e1cuhOZIsb30c807zqKATMvIqFhsRXrIwcWoG1J5u3K3Zk0D+t7HcEH2iVlXr61qH8EV1C8oAtObiZ2Fsd3E9laMwIEy6J8iWOS11iUQGfjyTYdR0j8QfmRuf5yjpI8UH3dlB/LADt2zWH4bryZgmHWhxspblPlyXRCRDRv6UuKkt6fqAuVZxmgiufbsA5ZZjD5bghOGiwcz9/+lTjuUpK7mwZ/BXng0alUH/KmlAUj/bBsDzbhdUrFlLkNB3JG5Wqn/zxIbkmjJ/V34xjD7t4
 5UCNric1
 gXYFHUt7AgzzIMQmPTYpBv7lm7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,

[...]
> >  /**
> > - * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
> > - * KASAN report; causes a KUnit test failure otherwise.
> > + * KUNIT_EXPECT_KASAN_RESULT - check that the executed expression
> > + * causes a KUnit test failure when the result is different from @fail.
>
> What I meant here was:
>
> KUNIT_EXPECT_KASAN_RESULT - checks whether the executed expression
> produces a KASAN report; causes a KUnit test failure when the result
> is different from @fail.

This is much clear. I'll modified the comment this again.

[...]

> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks :)

--
Sincerely,
Yeoreum Yun


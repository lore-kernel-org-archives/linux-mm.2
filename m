Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D11CCD184
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A88E8E000E; Tue,  7 Oct 2025 03:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432068E0005; Tue,  7 Oct 2025 03:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB358E000E; Tue,  7 Oct 2025 03:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 123DA8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:54:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C057E11AEE4
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:54:15 +0000 (UTC)
X-FDA: 83970555270.02.68ACEA4
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013071.outbound.protection.outlook.com [52.101.72.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id ED43C8000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:54:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oUcq+Es1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oUcq+Es1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.71 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759823652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttOP87sa4qRVnBWkrzYuFN9jMt/DqWUYnIENdN/eZA4=;
	b=d/o8BxSzX6Da58przdkOW/MMr5Vxj4Ph8nUQNe7PtUJ6imDjFXmU4dbaM44c5U30+RyDbH
	jQXnFvNXg4NoEFvmZLDG5yysdVOwrpVRdLhTpJWBp/Uw8OYqG7tmdnkj9nkZZrQ7hADFMo
	S9APIds7VWpvm1lTrmJhiXQQ45Q2Bzw=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1759823652; a=rsa-sha256;
	cv=pass;
	b=IiuSIq/5tbEJRPMLRTl54j0tjYib198amHFRVYqCRAhMQcuHd86Nvk9l/9/TIIzGhvErB5
	qYI+yFy5/n+S+Jfxyv6Euj4HWvAK5tW2U9VW3RDfQznk+pQVeCmyuINBj9ccRYQJIdeaZn
	/ETV0IWzxnrcAClQRbMWKurB40JdmB4=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oUcq+Es1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=oUcq+Es1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.72.71 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HNjsEP+dPxFY7zEbRcJQ9DBp1eycmSeDbpCn8XSLYH5wE7tlsfftPSxy94U3ZG7s6Y/TA3RU/fsQ2emYnoR37S57HucNDyf8Ut9Bv657A61rhQsZjd6kSzWZVtq/MYfgl6Gcdqb2qoIfoIyndJ+gQ7lZ4sTqs9CgKO/dg2qkXUquC7LjjHWV2zmH2knn12IMAOQTZ9RfzTbIuS/dCZ5gbt0xuXUeR5XtimN9gFpKZsVHjkvpVRPU735+0591wJMsVE3+aLsdjzBdMfEl1x6RaulmS4zoSNCEwNnjcizO40jOyqEzGFsmGKBkZsSGA/Nq3qfqR8IYDUe1bvKD75g5RA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttOP87sa4qRVnBWkrzYuFN9jMt/DqWUYnIENdN/eZA4=;
 b=To/Nsp42jr2gNEvcAGY+Zwns/H9WjPvMeZvg8DKUuXDqbn2saaKAlz9V8W+IGgA8LEwWr8unKLLRanMzvvQ8X5nFBVqo1I3Sc6QLnhR+eIDJDSp651xSl6s++/lroC0Zqm9yL72rDkQwSuD6wo+UzT4RGqMX9HlfLU2Csv2LDEpXq9tJ+6u8xfLJQyLhdbEFA7JJ11hic8+Ym2EIOUEKxQQPhkBdfMd1QC/qnB5Y2b5DEVPffLR1yE9IwZeY2w3cd9aQ/Ai2FzHo0WvU9Co3HiyrULiU+8J+oiz411Kzh0iwuqMmL1SMmoWq6qZUDZP+LnAxVc5PABh7s760/W4ZhQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttOP87sa4qRVnBWkrzYuFN9jMt/DqWUYnIENdN/eZA4=;
 b=oUcq+Es1M/LvT37Tw/YrV8QmelEGLL/VOtJnEjRyCwEPdRCSxLp4UqKFMqIpTlUkrTfHIb53fR6t3pM7dzmtmUhAG/1I28ezfrBf9uN1SHryLJXtYChMTQfS0VDwiDS3NCgti9koPcWpvGTngaaV2IE+L/T3lnR4eEJnii97ff4=
Received: from AM0PR02CA0210.eurprd02.prod.outlook.com (2603:10a6:20b:28f::17)
 by AS2PR08MB8429.eurprd08.prod.outlook.com (2603:10a6:20b:558::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 07:53:58 +0000
Received: from AM2PEPF0001C70E.eurprd05.prod.outlook.com
 (2603:10a6:20b:28f:cafe::19) by AM0PR02CA0210.outlook.office365.com
 (2603:10a6:20b:28f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 07:53:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70E.mail.protection.outlook.com (10.167.16.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 07:53:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=js556opMZTN4OtTWFLt8EP9ZOG6vuQv7mYNbxwSnZ4ZCJgmAvF5P5QseWlB7GU/42wZEi9+b3EVh1XHFcm7jn5ibTiiwxBNyxy8KNtgt5YTn5OSoWNZxBI24czqHBJ1ef7tabKWd8lS7tT5xXbhEXQpqOaQB8dnvPK8WMgJN8mGuhWuwkRSg8okfvDuBsCDJb4iKht6KVlrrETui7F8cHXOXKrkw2jFFnQlfMKfLxCypVeQRKnnZ/UY2Bg3ztok39dv/e2GVHzpzimo1Bxox2hZUtyLrN3Q2VTw/B9R/Zy4NLcdw2WZ6hzbYZyd/rQP34DBs7UnU/oIOGSkRPM5jVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttOP87sa4qRVnBWkrzYuFN9jMt/DqWUYnIENdN/eZA4=;
 b=IYKzWoqEqdoARe9fY9twE2CjmKnKJihPWS2vvH14hGMxcvOOtVudme4KGgezYLrF3tuROcFtoYFQh9RW7JVNZJcdlx0Q2TsCwLPj3inmct5Ydl43geQRGdAfalnaNcjGZw8MXGPhke5Y3bmMNJrYnwVenxP6nCFoFhVGeKSqytcx6VbwbGhOS9c2orOdaLCIM28uNwfXxAH5XvD2ySFweDqgbWR2f+P8pV8c27FTfl7Hqqtl+gFP3RtjdgTrqOsCdsMqecIZsh3SOH6oHl/BpqC3pA/yeY1KHSi80ZJdsPo/XPH/NoFsqolWxeE5pZwLsAUqzSZ1zalb8Z+P2qwgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttOP87sa4qRVnBWkrzYuFN9jMt/DqWUYnIENdN/eZA4=;
 b=oUcq+Es1M/LvT37Tw/YrV8QmelEGLL/VOtJnEjRyCwEPdRCSxLp4UqKFMqIpTlUkrTfHIb53fR6t3pM7dzmtmUhAG/1I28ezfrBf9uN1SHryLJXtYChMTQfS0VDwiDS3NCgti9koPcWpvGTngaaV2IE+L/T3lnR4eEJnii97ff4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBAPR08MB5606.eurprd08.prod.outlook.com
 (2603:10a6:10:1a7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 07:53:20 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 07:53:20 +0000
Date: Tue, 7 Oct 2025 08:53:17 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Yunseong Kim <ysk@kzalloc.com>, Byungchul Park <byungchul@sk.com>,
	Hillf Danton <hdanton@sina.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <aOTG7VTk4s9WfrMN@e129823.arm.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
 <20251003005230.GB75385@system.software.com>
 <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
 <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
X-ClientProxiedBy: LO4P123CA0656.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::12) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBAPR08MB5606:EE_|AM2PEPF0001C70E:EE_|AS2PR08MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9839dc-5e93-4617-3579-08de0576abf6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?w2hjrbY6/Hbj71REJGV6IEV58IXzVEdJSzotvpdlyz6hSQ4CgXJKLCKGBZLN?=
 =?us-ascii?Q?6QaXCzDABGAKteNf8IBCfGIpXlAN9GPwWnRAVa4sefRvFaIa+4FJm7/bVTWT?=
 =?us-ascii?Q?q5CBIr7SS9YCEFXKgH7Uu1gaaxJc8GNCNJXcJTAjfdcOwS0g6nRrr5HmdQrA?=
 =?us-ascii?Q?aSNgJE8sDYNjw9cy0CqIUjTMl287uijK6AbwcCpVgd/0XAb3TiP2MSJntY+v?=
 =?us-ascii?Q?y2ryMptsN4EH0SSOdgx/QVY+DY2RY5LzLMW9mEMyjpFlpBYaROAAw4iNLCl0?=
 =?us-ascii?Q?V0lS/xSJut36Fo+sEKFnVSUdADAIXleCkMa2ItpWxfLTGQjDjGhFnes/Jnvj?=
 =?us-ascii?Q?F7jw5VPafOsr94NKMo1KVFq7XPDjw9dzwFhFrW6DvINQLkG08dIF9aNvvVvH?=
 =?us-ascii?Q?sAYVzjO5F1GJqKb6Eqs950DUM0PftkAzW/FMGNdvxoDGszl7XAhtcfpViXhB?=
 =?us-ascii?Q?pYEJ6LS+kNUmGAza63qQMiUSZnnN7Vw1jd2GSQlmR8kcBYVcq+EsVH2zdYVz?=
 =?us-ascii?Q?wz+TGLaTKU27AwcekdcaXlPs6l+yGaROcIID2f7yaVnipEz6oXStXgsb0Sdl?=
 =?us-ascii?Q?u2DTkCul9ZccLOWpaozn/mtrhGkmw0MdBeAbkQJIbEHRWBpW6eQS7X15vSPQ?=
 =?us-ascii?Q?Mnm75oaXk5Yhd0y62WKIs97ew0YQyFVbw8kJWjbkBWLTlADjfcqhdqhXjmnA?=
 =?us-ascii?Q?e1L2JkNaumVyAmUypciq0U2BVuakna/b+WLWd8ISCOn/PnCji2d/xlKsfpPP?=
 =?us-ascii?Q?rd1x377NZh77ojiLXoRGy+13P/k3BUNtBnGxfGSGlnjqmwpOGvCzqIiuP1Ra?=
 =?us-ascii?Q?Uh/tpPw1EwJ4WBNUO//dYbp9kIkagbqizyRDhBILB1N3AlAzseD++FDJzUQ5?=
 =?us-ascii?Q?35W26aQJiXq1PH+qdh5iACQYx3XF/TAbX7Zs3lZ8E7sTdGb7dxrI1vRMjbZU?=
 =?us-ascii?Q?i1uNqIOkUo61lBLFmqnkhALaYfIaD1z4qGruBs6G6/FoHCr+zSRnEKww2Ekc?=
 =?us-ascii?Q?rqis7aoGRg6R9G48I1DW5yjm6ehRIsNSWkN/xztZxxt/zCpsBWEV18W1dD+9?=
 =?us-ascii?Q?05vE8K9m1BRfyKue2rKPp3MYWY0y5UmoX1gSZ8iQxqwQoE5jtXFwkX5ZmHQg?=
 =?us-ascii?Q?kuFx73miAktiP1bYOGmW03TrQjOyADUAXHUGBdRpcLTdTUNGmU8p0xDF+VRs?=
 =?us-ascii?Q?8yXUB1ZqeD5Qxnam7Bzpam1P4DdPWaensk83rhYeZZhKfFG1wF1MEcT59ahS?=
 =?us-ascii?Q?noKBEsvLOfDYWtmakfrQuNsZHcxqVfUnPT+f2lu/F9Y33d8RDLcc/SxEe+UN?=
 =?us-ascii?Q?ny+jX8cE3oJmWfgn1Q5qnyBe/YrAq6ADNBJMKNs4xdOet2qp6wJAV+k64GXZ?=
 =?us-ascii?Q?A5HiObzFNleo6twKYWpFKDXWSnmqqEYRyzvBKvrP1IreIzGiWOTjbC1rSfD0?=
 =?us-ascii?Q?d0jiKLIz+e0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5606
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5f843709-f259-4e39-6b8f-08de05769509
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|1800799024|36860700013|14060799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QdY95oULzzc/8HNJcLdUZxH6viduzcZbxLnZXIAjSCAQBPiN2YwuWZN0qpoz?=
 =?us-ascii?Q?ztAyJPQCxxooeNAzMJDbuoh1dluM6jKL3+1YXuw5j3ES+h7zEX4nBNyi+wc9?=
 =?us-ascii?Q?9rJNBBgbIZLjJbhEaHG++Uapf7IxN+dF1w0hBSQlauesZW2+JVoTLj/+QorD?=
 =?us-ascii?Q?eWIKD6R6552XlDoMl0l5aliKVrTPxlLgEsxwSk8dhX6ZQ3KLAYZJXF/Wa0WO?=
 =?us-ascii?Q?fhIUgoau0kSX0Aug3MPlPqBXEsyA0kMmCpCNDIbvELP9Y8e/TtDCoxhx6Rzp?=
 =?us-ascii?Q?2En0NuyeYfuF3Qqxld5E0R53LaLcHNyTCe7FzpIuQsQe00OpIdZ2s7QZquyS?=
 =?us-ascii?Q?Ul85CBa6ADzSxyJGmDs2O67T32RncB1NCMcfqB+kKnK4WbVehub8gpcDs+Ji?=
 =?us-ascii?Q?2wdXF81CkKxyfPKIb6dZXaAgz+UtBPgEcaECncY2Pfd6QJKJdeL2dtTsi3nl?=
 =?us-ascii?Q?U0WYtMeVqMlHaCMxnQsoVJPD9QpnRzIskoC2mr2Jd1EenM/CPXk5yg2henYe?=
 =?us-ascii?Q?+71i7hJx1EERK4PNe2V77A68cuVAY9/9eYU8JC4ahBkDAK3RQamUw+UxAN0p?=
 =?us-ascii?Q?eVrfo2pBro/3J3KL8Xb2PWIfBgJzWDXHy/G7Vhh46K3zI/y41Q34QntS8HH+?=
 =?us-ascii?Q?HuD0v09snLoKKWHik+q/27gQlwWW9uUC0/Xg+etYhnNzh5JyQ2za07/hlhBm?=
 =?us-ascii?Q?fhhouax31diYCYZWKYKiJIrwrp3scUz1DlzwQ/AqBG2VyZYOGYWT23M7VjPB?=
 =?us-ascii?Q?kswE2BwdqAYjs7NgN+CFz4u5wyAMLuP3Nl8j1rAD3FW/2e+A2kusLH60Awkj?=
 =?us-ascii?Q?fszT5Uw/b3yGIJtNCUitkEp1DkK6JURwklCpBQCazIAuYuW0Hi5T0gTnrjnR?=
 =?us-ascii?Q?gdfuL4RFF77n9f48PRwlA8O6NejDPltSmudO9qjgiz1OcuaGyuDBfgDSkiXh?=
 =?us-ascii?Q?TAFbL2A3xvLKRG88fVNjFwoPjNOK5bt1WOJkxTRSEF8+IetD5DaIj9kpeAEV?=
 =?us-ascii?Q?QU6FkjHuRRWHJu6zdNyleaUy+51wDSX7fVXfnqbGgnAYlwEMn29oYbYag0xs?=
 =?us-ascii?Q?KShwjc77Tser8fFEtMLGQ7aaUD5twOgo1pcITl0SXAKLrz9lSIjf3h2/GAmS?=
 =?us-ascii?Q?w1fLyVviRqXsWCPHr08Mnpr6ad+p1x9g9091jprkOI1atwb4oHPkJmzIXvm3?=
 =?us-ascii?Q?9+taWka2eFrgSYLIwgD9u4aPvHaBmrAVGtW6fINKiZDpktCogS+gE47D9+2f?=
 =?us-ascii?Q?mH+UwlYdmsUQ4FfipVYEyTsiznCUqRuCy1EIfSOU1J1lEvjKMtAOTgT76uq+?=
 =?us-ascii?Q?00iApOFYhGkNhTfXM/6qXhNKhL9z/3YOfqUbveerzSXBB7BkKwN4dSSKOq73?=
 =?us-ascii?Q?lhRSJGByZTtXUAG32YTD+kFVNaM8/Kd5h+M4r/n44W9PNOH79VvX3zP/rgi9?=
 =?us-ascii?Q?dwbkkQhzYiPbH9UH/Qh8OFOOEKju/IxRyIYMc6k3RYg4cymFraTelnD6IX71?=
 =?us-ascii?Q?32PiYZ+WHuQ402W8Np+YwzJ8P6+I6qJdghw9?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(1800799024)(36860700013)(14060799003)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 07:53:58.1568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9839dc-5e93-4617-3579-08de0576abf6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8429
X-Rspam-User: 
X-Rspamd-Queue-Id: ED43C8000F
X-Rspamd-Server: rspam02
X-Stat-Signature: tbebruzxu7g6rfe17ii658s3m49r1qf1
X-HE-Tag: 1759823651-963942
X-HE-Meta: U2FsdGVkX19SnCDadhavX1jEvRQuMCt12/QIghtzIo6I31vRR5Ayf35H+GClSCVCldk2g7GJ504fXWbIM8FZ8A4A16hNACKZp91FAqMCYLywN2hfr1Ulo1P6/J+tzwesOnCdU2/eQoGIUrRVEteDiipSZST+D0mcCAqfoymMA0nJrKcOzKvNDkkxZS2RtPliyMlIK/VLyiuqBOKjP7KOa2f8MCvdE4NRyPi8INatRjYsN93FigQCTwC5qpald6x8me7X0nSWdvFv1eb8Z1j7uW8BJ+nkEudLblE7qxw8TzhldFmnfhaOEqnZnIlaNQL6WaPWwuRHahsjGJ7/Yf0d3lDPW98DyaiASppTENoOPOQF/I0h5IH4MAnhOOGKraZPN03IUBOYW0+aYK4f51TeBgxEqV/wU4CtXja0aJovlALZmFoiNWlmccTLEh0kq2tE6eIsypcXXpmBxSLHQvcPMooXvwIYyTE5J0slDdjzzevBeJvOuTLluUFyRZdK/h41bYCUkl032P9hzNpkmHizQTyVZsjVuAx6BACs9TPNC2O90AcQdNFZpbnvJRz1HlYl8GfP4+AkBsmy15/DH+xxV35kdtz2dak+hyBIWPkg/0GptEOjwR2QYzfyr7Mq72ZTsrpS5vPyQT3GPu3Mv7VEbApWoPUobcnFa5zpS8PpujyS8syjDuipDX4C0/yNlKU0nbPPu2AwNjRwvynL3QlDSu93Dgs4p2V6E9XcSl6PqWAieiMzpV5bTC4itPxFUnGxmjyo34qVKvK9DprT943QoS3/s53JLoce21G4UuKmrpEzlLGDhaoZiwaC86a5v0UfxGoth4pbHLE3dNUVQkWkUZbJF/mc/53n0FKO+cVa/DsXedrmJs7jCu/I3vAzLl3TCp70e0LVsVegS661mT/u70Pvt+VjCt6vPla2haA1l1VMZmpq7cEFiMzVVa7XXsCBHyppb2e8MDBTSaZCZOu
 /ABeVqr9
 dydwaF5jg1xCWMxD39XDYUfMahBPZQGrbxwjnynMeyZtIHOVZ7Ltqlh5kmTRjV3u6occCg51H2cbUC7fZnxlWq3hvHv6K91bpO6lzuz1S6oo3ZfPyjzoaYKpEL95surOL2tgKUuii9pC5dBs9Ufm2d7NtcauL5X8jUnZ0lTw2SjMKi0YMBUZ5yfVsAFgTtKznIN9wFKCzSCMxabxln0tHQeQpLniqYt+u+4z1ubC2Mhhbn30cnLRT4HFeuejur3sA0QZC/MQicvTgXZ/XmYL5bEfmKZC68gHbvsb4fM52TisNHtGiKDHKHFsXXuAuRmhmpuQaykKBWxJqt2TQml3e+Q6/F/C2Rty1DLVztM67t+5Y7ZH2yH2zt38fNQ5Z116gYWEsEgUMUh33ZJsJE1kcA/vwy125BstxMtItlVR0EfH6iZaFj4U5IArXplstgd3ZIi3nlVydQcBVlS2TdfWyUR6FdPz+OWoDZRWpfVE9JcwXLSJgn0R4mZ4N/R6TWCOLX1vRBJp7dQtNRuOTnmdL7bv9YKBZPaeT7M7A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> On 07.10.25 08:32, Yunseong Kim wrote:
> > Hi Hillf,
> >
> > Here are the syzlang and kernel log, and you can also find the gist snippet
> > in the body of the first RFC mail:
> >
> >   https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
> >
> > I am reviewing this issue again on the v6.17, The issue is always reproducible,
> > usually occurring within about 10k attempts with the 8 procs.
>
> I can see a DEPT splat and I wonder what happens if DEPT is disabled.
>
> Will the machine actually deadlock or is this just DEPT complaining (and
> probably getting something wrong)?
>

As Pedro mention[0], I believe this DEPT splat is a false positive.
The folio targeted by __find_get_block_slow() belongs to bd_mapping,
which is not the same folio whose writeback flag gets cleared
in ext4_end_io_end().

Since DEPT currently does not distinguish regular-file data folios from
the corresponding block-device folios,
such false positives are a known issue, and we plan to fix it.

Also, when i see the log shared from Yunseong (in hung.log)
I can check the migration is stuck while waiting buffer_head lock:
...
[ 3123.713542][   T89] INFO: task syz.4.2628:42733 blocked for more than 143 seconds.
[ 3123.713550][   T89]       Not tainted 6.15.11-00046-g2c223fa7bd9a-dirty #13
[ 3123.713557][   T89] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3123.713562][   T89] task:syz.4.2628      state:D stack:0     pid:42733 tgid:42732 ppid:41804  task_flags:0x400040 flags:0x00000009
[ 3123.713577][   T89] Call trace:
[ 3123.713582][   T89]  __switch_to+0x19c/0x2c0 (T)
[ 3123.713598][   T89]  __schedule+0x514/0x1208
[ 3123.713614][   T89]  schedule+0x40/0x164
[ 3123.713629][   T89]  io_schedule+0x3c/0x5c
[ 3123.713644][   T89]  bit_wait_io+0x14/0x70
[ 3123.713662][   T89]  __wait_on_bit_lock+0xa0/0x120
[ 3123.713678][   T89]  out_of_line_wait_on_bit_lock+0x8c/0xc0
[ 3123.713695][   T89]  __lock_buffer+0x74/0xb8
[ 3123.713720][   T89]  __buffer_migrate_folio+0x190/0x504
[ 3123.713747][   T89]  buffer_migrate_folio_norefs+0x30/0x3c
[ 3123.713764][   T89]  move_to_new_folio+0xe4/0x528
[ 3123.713779][   T89]  migrate_pages_batch+0xee0/0x1788
[ 3123.713795][   T89]  migrate_pages+0x15c4/0x1840
[ 3123.713810][   T89]  compact_zone+0x9c8/0x1d20
[ 3123.713822][   T89]  compact_node+0xd4/0x27c
[ 3123.713832][   T89]  sysctl_compaction_handler+0x104/0x194
[ 3123.713843][   T89]  proc_sys_call_handler+0x25c/0x3f8
[ 3123.713865][   T89]  proc_sys_write+0x20/0x2c
[ 3123.713878][   T89]  do_iter_readv_writev+0x350/0x448
[ 3123.713897][   T89]  vfs_writev+0x1ac/0x44c
[ 3123.713913][   T89]  do_pwritev+0x100/0x15c
[ 3123.713929][   T89]  __arm64_sys_pwritev2+0x6c/0xcc
[ 3123.713945][   T89]  invoke_syscall.constprop.0+0x64/0x18c
[ 3123.713961][   T89]  el0_svc_common.constprop.0+0x80/0x198
[ 3123.713978][   T89]  do_el0_svc+0x28/0x3c
[ 3123.713993][   T89]  el0_svc+0x50/0x220
[ 3123.714004][   T89]  el0t_64_sync_handler+0x10c/0x140
[ 3123.714017][   T89]  el0t_64_sync+0x1b8/0x1bc
...

which is different from description "stuck on writeback".

Unfortunately, I couldn't analyse more with the log he shared
since it was truncated.

@Yunseong, Could you make a reproduce without DEPT and share
full log for futher analysis?

Thanks.

[0] https://lore.kernel.org/all/dglxbwe2i5ubofefdxwo5jvyhdfjov37z5jzc5guedhe4dl6ia@pmkjkec3isb4/

--
Sincerely,
Yeoreum Yun


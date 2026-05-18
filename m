Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C5ACD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 00:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0FF16B0005; Sun, 17 May 2026 20:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1246B0088; Sun, 17 May 2026 20:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0386B008C; Sun, 17 May 2026 20:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAD816B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:10:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69548A070E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:10:56 +0000 (UTC)
X-FDA: 84778610112.10.AB3CF61
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C87520009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:10:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nOpX22gK;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779063053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kv8ob/xKF1AB23rTdvTlmRR8ft44LaNC2f341L2GKXQ=;
	b=g4b0QdlL1Z8P0mSLEFKvEeit/qDqJvz99/XcUjBxK05QWkVBOOkVddk18S4bWrqwF2XaDt
	vn0KdHUPxX7UjyrA/t/aCEI7intpKTZO9cMAWtvSUk+i23M9fnkANLeCohk5zItZ8T7BBi
	JV5yxr/vqO2bTgNT/jV8j32RSx1P4QE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nOpX22gK;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779063053; a=rsa-sha256;
	cv=fail;
	b=uj4w/e4r3Othm6x1WfHmDFYga5/xBvZcJPJLPeiz/hxTlFdkGeKko3sFI1/JYsKv682LAZ
	rld+O3480zvrAABaQieSc5tBuj1WNSRJ9eHdGR7/U9Hbt7T5DoLdzbuj4gUmwhcfQ1rk76
	gTAXe8lQO3KMhKAy7QcKCFCr2RdHTUs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzvblYpbAVrOPqkq2o4zgRPiQbqyrzcGL/FGRxP8ifH9x062dR24WGujguNgudc5Jdlsr1J+lB6R/q6nVYe00B5zYFg0fZZOSK3/1Wj56Xs445HE33NRzy1kWokJ1ka5h/AXLVM2X7KaD10jqFDiz4B4BlVfu4wvhTJdkFEH50lkQ1A4lzn0DSXYjZGyQ/jw1YvOUbDUjxZ/DYtYprN6rDjDGCcSd0juO3/0KFhI/7pDoShN6x0QT3CXdN+eQ9ob93yBQtD1GUnZ0SFu/Bhp1jdjbUhWGFXbthnKh4dcl/RD5Za0uCwvqs2J5a5ky5m+fCrvFVPyPba8c4IPIhP48Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kv8ob/xKF1AB23rTdvTlmRR8ft44LaNC2f341L2GKXQ=;
 b=dfRYKwWnVkezeAnOTYufVfgwVAs3lCh6WpZEXSAIV3b/FHHBZ5MLQAjBJE72Hrjk/UGQuaQ2g66WbEOgb9AL63IdS1RZsInTWJ1WbHXfuIjLnlfQCHrhWoa38Vca7C/JE52GOYX7RrmVNONGgifxyTI1L4wy/vnJehOz2OUDhdY3eJh+V9UhUGIBzo3MUDZgyMVSKrcHqPQ27pGmB193A17EF4KZLg4AaCvrE0MjPrad+UWTZddi0zuRVx5WDdtefMN6jKhXj3cjU6vgCUm8o9PxgeWL+7qiX1lAdQIrOlbggkJzvrGy3n9XLXLiAjSA8srmhu5on2NzhS94jtbsZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv8ob/xKF1AB23rTdvTlmRR8ft44LaNC2f341L2GKXQ=;
 b=nOpX22gKB/CLAQnKE+iebOuQCfO5Z19ZDMqMUfCYxS7f7QrVp53qMxBaNuPPSaFK8RPLw19b+jxX13Fq9nrZRS4K0NWr0PcqssVoAFiIZ1XYhoE9uvHobyed/P4cOaVVxarnhgWOHtz1i+wKoVjB8np+VcatW2HsDwBClmadFSLz1/RtIkXBwRCIFIdWnZMQ3+23WfWNhbZpXZ74ixfQ8gqOXjHToAurRHFzhPjNdSIJBTgZ1fBczVscKm0xFE4YzHV/P0o7jseCQZtdXlkLdF/qx4oFna6SLOVidgLCGd8eA7aW6Og8pT1c5xdJFLJQZtItm2DkWAFfdulRmZok3A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 00:10:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Mon, 18 May 2026
 00:10:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop a misleading __always_inline
Date: Mon, 18 May 2026 08:10:26 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <1145423E-D3D6-492C-A7BC-8390B8B5840C@nvidia.com>
In-Reply-To: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
References: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: TPYP295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: 9313b544-4db6-46bc-5bb0-08deb471ea3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	MX26fSyJOmZr7dno+OnZQaYq8jO4fEPhdDBtMyCVn9e8rd3UR9SrchYv4SHd0cBd0+K7fVzLx5l76OKsv8SQWXJIx4cITG7/K4m1J5vP/H9/kVRJeQyJGtm0n2Ayby5uCYkFySMIPmNcmdTk23PAGraxyuSoGFDfw7bJUTZrW2TCVIkeIw5js5JAG1NScyoBLJPaos3pV3MrESQh6uVY2B3bPuCrchSAKd90M09B9mIjKhI2hqBLo8OyXz5tq9TSx9TFuJCxGREWhPhqzWydbwKyV2uMY3eeWGdJul5FNPEjGwJURXpcBuFAridjzsjScUUfzLn32kjcpzbCZsUd+c1ZiJ0jYFs3VCfDlTUfycuA3l7vdfFswZmepGAMm4tASeRmD1btEg16WHi4OX3hHneYlRUB3jAJR0k3HmAbpCuBk+b8EqqquO6aXX2uP2OLR2EWyFtld2KfQTkyZhtsSNdBceXLMI4/C4ZUAyb6GwsFuxz8eg30Jx5nsC39J4P5aJULWAHNV8grn/oFCebUbSEqLsfXvDgqXnqAdNlzvH61SxVtbAJ8k6lAHG+pNFIAt9wxm5ypfcavTgdft+pM3Di7Qq4/Ad4arQydZYfClhfWJ3TQTW1t71wCW7mlMcUdOZk1cfNSizEx46hfvnrZFFwYjBRh59kvcVMTwU2TvAmR5SUKpyFY+DD3vkj3JdSHeGzJTW9VuBH+yEzsv0eh4A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KVyAgyBgE9N6sUG5faqyPfz6yEQFJnQi6Ix8GbtNLAeK+PpbxMR26t5fnEna?=
 =?us-ascii?Q?IxKPTQ0zZ7whjyfutPWe6Jd8R+2aeyJpw4Sp4o08+O29XU+SYEnGJdUXlFHN?=
 =?us-ascii?Q?YHA0xUgQSmro+pqCq6JrOaDzrtOwXphHTtZ0s/piw8BmXxmd7g0W4yus8xEG?=
 =?us-ascii?Q?sGb9wLPOn97t8B0AZIWNynfx+KBe12Rc7sZhQNVtXNVwywD+4LkcOUB9aeou?=
 =?us-ascii?Q?ehNaBp9hrEIDoXeNO93/EsvK4oEvpLtDj4YN3TU1YO7zO6lCk5gou3bPc+aT?=
 =?us-ascii?Q?PsL5oqUrendIH/noiSzULPMvxM8nMv2p+N6BEwUnoPWYzIof5f46+FqLJgZ8?=
 =?us-ascii?Q?zSO9Fuj4sbOFPHV+ehZ5/pEF678cvHnJBE/ELRqIyHXWTrWI0uz/8v5DQ49F?=
 =?us-ascii?Q?qpsbC8cOFqscTiW76lDrgAJmeqwiKrniJSGKRuGEw6ZApbLXiEJ5e+3Mvzab?=
 =?us-ascii?Q?+VJO46MplV6pbSe/QneC130uuhrCnhpAtv90hLZudfDxR+obqrd4OiZus3/3?=
 =?us-ascii?Q?OyVYUkpdWZFbeU6V8I1jBkvwYya2qAMd6GZ0x2Ludpv+WOaBn8CYe4Lrv7De?=
 =?us-ascii?Q?SeSzy/7fOgNYXPZs3U8hBL3Ia9LzaHd+5SOQtD0qQtj6x5j2PjoqMkd3CjJM?=
 =?us-ascii?Q?gKEp/LX9YYDOOESHeW0CIt3yHPPP1MwWpP6jwnGLFAxXKgbgNRIp3Is2NJ+3?=
 =?us-ascii?Q?GiJeIiWauHS1lklezWHKMHbJraDICzBWGDNSYYNQ+igl90hTH5vKCFShTAlf?=
 =?us-ascii?Q?bP/2rmybGBfEVwoN9tL464LlyOXkiLzHUNI3cR4F+QEm43kFG71cYyOvX407?=
 =?us-ascii?Q?RmURQwg9lbW5aMHBR439Hk5ZlCQmkpqCL0aVJo88UoKKTkhvIdfRSJ1SD8S7?=
 =?us-ascii?Q?DuaZgJzKT8Z25Dl15LOHSGYHcYjiwutFuLew+xv8XCpyuS/HnXU/GLY6ElC0?=
 =?us-ascii?Q?zRULqxQiP67vL21VZni0ZxGyIFfbyUeML6jMoSfnNuocT+2S02EWZCXQBR3U?=
 =?us-ascii?Q?oXLPozgJxjmarc0stqNKvBvFN1LjwgeeJhhPjCqmlVhZ2Q/lsRJq526XnEqg?=
 =?us-ascii?Q?Mo0MJpx9UMG5WYCsLC4l2AjwW8jxYj7XxVd8KPr5yM6QapnI5tqIQcfQOyLa?=
 =?us-ascii?Q?ugMQXQXGXcOmK5jcmFom2AOBoyibMln5NCdqZwhSmNqGbCt7oHkWX/o3u5wJ?=
 =?us-ascii?Q?Y9jeKJDrHRWfvvLEnDb1D0U+iPTFo3QLOb9ErobU1qKB2N0ownvITnYXKZ6r?=
 =?us-ascii?Q?aN55r5NWvISNaNII8irP86sZ5mvrSZw6q8GFC/Q0TEcDC3p9bCPly8oiMrhX?=
 =?us-ascii?Q?Lo73/MSqaA/tUeJQS057LSnDCBwmlAHnSQAe7P4VpAL/7K6w70CvpLbPLyZY?=
 =?us-ascii?Q?Wm8favJJHhLQmt52ZAUc0pYgI2IFw5UAeKocAaLzltP6s/btbR1xfz7G3V6i?=
 =?us-ascii?Q?g9aSIer3SVPEsm0OvekCA2bXo1mWznkStrVvvzKTIdLOpNsy2aNHf2NvPc90?=
 =?us-ascii?Q?C9pdCM3iQ1Hvn3+fgXEb0MFYyNB+CZiHalErWaV9v3JHS59F+X9wynew6mtb?=
 =?us-ascii?Q?7s9oASPUPNC4i3UpG9b/9/hr3SGiKQtG2qE6cP8tKF/KZpxaeBcNoCwpHRor?=
 =?us-ascii?Q?NdzLD1cwWsAx3U+k90fvYSP3//xk3ZQ8z9FDnKwaIALBG6IIT+/01P/Oxsmr?=
 =?us-ascii?Q?Sy3UB8yukga2agE+Y0OJaLq2JDCiUOHNUYCH/17gUBmP/3O4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9313b544-4db6-46bc-5bb0-08deb471ea3f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 00:10:48.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8GN2rwYme8/X7bnssAfxZmZvqyyLVuvwk/tAFkYLiuhqg2sTKe8rcvTAY7kkU+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
X-Stat-Signature: k4f563c7hxje9ot1gjb1jimrohi5jd3i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C87520009
X-Rspam-User: 
X-HE-Tag: 1779063053-979731
X-HE-Meta: U2FsdGVkX1+NtYXFgFjLRCe1Z4Y8Jak6mVSA4c6Pg+sR6U303CJhRwF3XFUqbDiL5DyVPbeutv/3NEqOhtAw/0L5giQvcrEjTUpqr5a/fHu/leF0/+coAGQ7OdzLPKiJgrT6E04KOny3+SQkAa923Poax6oKMheo+lXTFRUUeKS5A4FrsN+dyBPL7Y0syV82JUIciyWEGdLQhE6zR/g/4D4KbihckBoxgoOA6btGRgYyCITJtqKMEVq0VhKqcxyUqzwAF5P7ZcR9tnlkX/3VUiSqc+aCkKv6YXh7dKYYzz67J+z5yZYselQINWVXBS8R/bNRy7gJUr9LEUp1djt3E+mbBgleCGvgtBSb1wqGcBOHEAaX5w0ITQg+cIogLIJGy6StDsTalhEPhw9x6ihhA2J4VoZyEEt82ccOzIi12DNORwpz/lQKtKxObIkCVMH0pSkR+21YlBPKBB0EumJpUMYuCY1E1wwYh4iB5PGGDQUQ1z/YKv0mPHMd3RbdphWsOVyDv9vhQ7gbaBLQSxaVLQgCLM4ihiqdm8DgemQiIV0roimlzD3qp+ckLv+BuSNL502M+XIMV/sdnMed4rAOeLZyJputPBtUM95okvCApRvI6OgjtndJ7oArZZ6IjhUqjXPh+rUYnaa4lhJhWr49pXMo7f5FwYX+711Tmx5XyH+fFXN0eFphr1zQyP28wg2pzWkCj7YuDI7cN4+xcIEF5D5k64XRr1HJ/6DBPm52QMWUzbCIaKyCK5JcS7j/PEE0pXVU/o31n468faTYLRpH+6WyUBzjcQmwUwJgGYK9EIiurR3mDTj7c/ZW9lYoTurk1ujx7o7e5qs5C9lqkWAkoVLHamULGP8btqNDmXyscX7DuNwQV0mkinzTvj0Wz+Jwp1EAmmAXVDnwR5b/YzS4PK3qsje+tNm7TrY/iAx9j2vXN3hc1xHSrdgU4vBDScEZkuQCPK7FJwoMV1z+IpN
 kG0qm+Dx
 O96jCGuqQOTwQPOmOKbBMMQQs+fT6RJM6zxuo/m2W+/JpamC5A+qqOSkqQhxkz/1n7e8qR0pj9uPCXmv4+58YuoFFo0y/OjtyKBT2ZZLbvWJs081Pb/66+q+QjMBiOfUate1KFwB9Dp3DfyownAA4N22utL6o1j6dGUqn6uiU/PY+RRzrPGpKHjmHZkf2zdrReknJugUmO5HO5WWOxGQ47+GuiuMOTzVxrJQKaWl4/6faxF0LiSMg/yXmnO9xLDRyR+Q7SWW+Az6jpNrYWpuQ+QunbqDWM4xT2G46Rbsvy9xwqO9zqW+3jXhuMItqdgh96KeDeZfZ4vhQryGECKhNgi43+f+sxQu09cvXNioxEjV10Dn6ZQuYtDX/XwtLLqQvA5NDcQNpCaLFppYS6pdTFYJCV9AAZsOW9U+yAh+EeQZoyH5LEcqt/WEHZv31B7+VpGm/de9sDKkLkVTQl8BdFteaJ7sPj0BCC7lSrYSlEAr0D08kskL2uOkjzJ/XaO/pl7Yg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 May 2026, at 7:37, Brendan Jackman wrote:

> get_pfnblock_migratetype() is called from outside page_alloc.c, so it
> cannot always be inlined. Remove the annotation to avoid misleading
> readers.

I probably did a copy-paste last time.

> At least in my minimal config, with GCC, this doesn't change
> mm/page_alloc.o at all.
>
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@=
kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e262d1316259d..be7f5671d421c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -434,7 +434,7 @@ bool get_pfnblock_bit(const struct page *page, unsi=
gned long pfn,
>   * Use get_pfnblock_migratetype() if caller already has both @page and=
 @pfn
>   * to save a call to page_to_pfn().
>   */
> -__always_inline enum migratetype
> +enum migratetype
>  get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
>  {
>  	unsigned long mask =3D MIGRATETYPE_AND_ISO_MASK;

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> ---
> base-commit: 0cec77cfd5314c0b3b03530abe1a4b32e991f639
> change-id: 20260517-b4-drop-always-inline-17702081c2aa
>
> Best regards,
> -- =

> Brendan Jackman <jackmanb@google.com>


Best Regards,
Yan, Zi


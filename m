Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15543CCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 02:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1DE8E000B; Mon, 20 Oct 2025 22:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4982B8E0002; Mon, 20 Oct 2025 22:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3613B8E000B; Mon, 20 Oct 2025 22:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21B158E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:16:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA88CB82AA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:16:45 +0000 (UTC)
X-FDA: 84020507970.23.D7D9D0C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5077FC000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:16:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SC2+xb1w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xAZaAlp1;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761013002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmgx6rUgSbYPeVTE9D8rTUBGek9ebWOf7J51PG+KFi8=;
	b=takje6x4I7MSRP/GxPAcIYDoy+L6LeWaQGl2SpQDgnnIP1fFul64gCtJZ+CpoKtonDmTiT
	M4HmBWIxgyaySXOFEF3zoNVHSYo1ZaW23l6c3or2zj5LqmUKx1eWTQAepjLnkTErn5KkYw
	eAZYC8iVSC/qt7uCH7jEq6kDazW2Mcw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SC2+xb1w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xAZaAlp1;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761013002; a=rsa-sha256;
	cv=pass;
	b=zcxNtC6iTm+8ltkDgmleFYKFuNHXm9fNSX2IAKEQTtWJDOdrKFBRGu/KjxUM4TQecg9+pO
	LFRhfaY9Mejab0Exj9jieFLBFgXm4bFNf9Y1i+tTpvWLMLlqqLfwNK54EGAYOXdA0eM13s
	GlWyyzoeCc7MwvaSlvVlvtIkU5vtnlg=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KJuj2k003494;
	Tue, 21 Oct 2025 02:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gmgx6rUgSbYPeVTE9D
	8rTUBGek9ebWOf7J51PG+KFi8=; b=SC2+xb1wjRjQzTUuKYRD6gyZAFpuvjyhRS
	N0x+FlWE6deD55njqQLUNWD2CcETaymg41wWuDJmWS0Y3lpMTfP0xt1CPE+vb/Jz
	WRwdWVN6NimdtYsAYaVvpbapx/6g+lEb0QUbZrh91W0GzKRsUYcA5kOrogkbxxK6
	ufK49KofBrslcOCyZKuUL0G6CM1tiFIyIvSE8zJph5wjE+hAnkDLqP5LJ7y0biYv
	w8M5T75yM1z306i2/4ghb28hIPRW4bcGFh7ofNi6SalsIpIfvGgPYPcvnlMhjWXY
	qjxFI5x3DzjVmimTYKZ5xMDUyhXrqDajaOLfXBb1ODXZdIZ6mrbA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypuhjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 02:16:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KNpplm025448;
	Tue, 21 Oct 2025 02:16:38 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbc4hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 02:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0Dsw6z60um77kF+Ma182bRBG5e0JJqUDASGUJrdjPGDM17ilms4JxnEHPIHUbf5gG7EG4e0ay6NgdadjFdRC0JKqN+YELlXCBqgTlul6fMA4taEWGvvb0c7vpRylh8aFsQdZTS/NH6Zb0kvS1nlowXCeoPzDVgnr7P3SdSznJY1T+EOP/nd8bI7iGJQIjTC6IDV8LtFE/sK2zhyxAqWNZfGS39D76dq0J6k5u4KT8fYSpf/3iCv2HtCD9T35Kcqe5tvkAyG8Jd0LA59kzcCBS9/es9Rk2CunpVN1w9Ib0hpCgY8eRsS1PUE94CLjGLyBOn7mWOHRYwSs2o9StvUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gmgx6rUgSbYPeVTE9D8rTUBGek9ebWOf7J51PG+KFi8=;
 b=OWdJtxpbBMtwAGPmVrvONQd9QnkhEjabokZeJlOIIvxdEP9RFFWkzlRtWklQ71qzygGU1kfhHx8YW+uilfBCjSLG/cMZ9PtZv6NCwBLqWe++IlpqACyvNxTPfyfKR+R/Axl1YgTv5WMHf1n+WbhezMc8TobO0uD9BTeo3mUvk8IoLDOCr9dx8tg9LiFP/8UtQH61BQaR9XSujnbVO+xfXDldD+CMXYZ0c1nsRtA1dM9SnSmT5EQ4eV92r5KtOp0gqdFWKFxoeth8ykUFWDkBBvQvPvt0N6Ol24JoqhFpGZ0MrdkkHnBYKKlVWVG7vExW1ilPnLogl3cZAJwWeCt92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmgx6rUgSbYPeVTE9D8rTUBGek9ebWOf7J51PG+KFi8=;
 b=xAZaAlp1pNfo2SLGjD+jaM32J5nbXl0s1D/dOCmir2mVZO5SagYqORhIr4dbxd9AtppGKeBNkmmGk8kVi80YN1ZcclwNsVugWkePtlIxuhAW4+lpUNzyDdMl7jFGg8vHwE1ADYGAm30Df8/pTz+nCAL0UWNUUx001B7oxFZrtGE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 02:16:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 02:16:36 +0000
Date: Tue, 21 Oct 2025 11:16:29 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] slab: Avoid race on slab->obj_exts in
 alloc_slab_obj_exts
Message-ID: <aPbs_cu261GnQgcu@hyeyoo>
References: <20251021010353.1187193-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021010353.1187193-1-hao.ge@linux.dev>
X-ClientProxiedBy: SL2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:100:2d::30) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bab498e-01ef-457e-0a19-08de1047dc4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G50yf/K5HYIZ4mBg5vm5zgJ5gxlZ4MXq+P1rGv9wM4u2+9JEfrn0Wo+VbCwU?=
 =?us-ascii?Q?VeLFbYRi6aatg5DuUbO6kE2G/NrXcHG9Yg1WtEXh0mjT3ZjwRgsnfJ1qCx6b?=
 =?us-ascii?Q?+J0y1bjjZFToMYhB3lTGwbZVL/lkEGf55k9Vo2J52tSPRtz3nckIlm+DQJkx?=
 =?us-ascii?Q?B9j/cihn4PONVePDuGuA9dC6EgrdXfcR6EM8ZAk5j38FmRGU/JRk7BLoq3cZ?=
 =?us-ascii?Q?OCdDWmw9tIVN1i3KvjdbrO+eSVfl1T/Dm0x5ekoqbTjcumHKWSZWwuu5ugLw?=
 =?us-ascii?Q?Kqk1CrwJPM3U7dIP1UAHTkYG7pz1yDLAO5921nrZuI4tZG3n15FAbNTnPpUl?=
 =?us-ascii?Q?FbYFB1qxGOKy6jB8nGWxMA2aGH/ABxe4DOJlVZ6sW+LiKHaDHU8Q1m/fOIVN?=
 =?us-ascii?Q?iZAMvp8Nr8scAnJwbND5kgs9dw9U1cptvmGd7rDF7m9e54fBrpqR4pekc2eM?=
 =?us-ascii?Q?qPke8U1zlhb7hJQNSPWLK09wSyb5bpeCdy5H6PX725XCHzlFBtQUey+43PU9?=
 =?us-ascii?Q?OTWuqS4ZGsK1LMTASv4QL336vNhd3KC72qV0lkzRn+SSE21h4puOLgptwBNy?=
 =?us-ascii?Q?NP6pQ2cGaISlD5AieFpZZvlKI6ufchhErq56U1o2njVodofPS9QHtLvCFTIY?=
 =?us-ascii?Q?BFciSfSCvSmiopAYur3fJXZ/J0SkKWtkZn846Q7lWIeDOYUf2Z+nLtNPZEr2?=
 =?us-ascii?Q?XhTmyiGCbgigvfDTFMcbNmBQeiqKV4swDGiGFs2u8Ip6uOSMXIrqRk4USbcV?=
 =?us-ascii?Q?0vHVDyLlWF1s0XuOMd0huqh/mW3eW1b+w6rwC7qnxPTqFl2OK2yqAJqS7RIY?=
 =?us-ascii?Q?g8fPVT8xafvPLswVYuJ08eJb2yie8BJr9tqILl/hSWGuY/gicH8fOOTJYAm2?=
 =?us-ascii?Q?j+ZmnIvgpqBxTq0k902k+VMF/qEjoGCaSQt6AfxMge+vqti54A7m/OyJm7DW?=
 =?us-ascii?Q?ktioGDvjqdbaR7GabWtoEPn9zLO4ZDN7U6DAXDStdGGGd6/Xg9DXmU32fHWG?=
 =?us-ascii?Q?mLvokLE7h++Jm4RuS2nYnPscR1a2nYaBcCPmtIU8dOw5cr/txf2XiOOFfgFp?=
 =?us-ascii?Q?t7PZOpCYBzXwYlZUw9bd4I7Tb29zHad1ymDBR5ppXCSdJVjdba+fnTYdAZHo?=
 =?us-ascii?Q?9uMSBtMzPm0X0xDey8U0DM33e+pNEmRNsE+w5/XARX+krHRSNXZTnqZzCrW8?=
 =?us-ascii?Q?L9vofriuTY4OKJheaCty0F1tvfCsGKYJGAGCJTJqcy7YfFzEY6PrISUwFWoE?=
 =?us-ascii?Q?WPVqpOZZ5XIaQZOURPVhgpAnG03TsVZFc8a2KT3o4zL+e7fLHCgevZHzU4zN?=
 =?us-ascii?Q?nW+M7PDjBD7Yqasp1Pt4Y9pahK6bemQMwZNe1XPzF6LsHYndXUjAmjU+54/C?=
 =?us-ascii?Q?9Y2bPpgKpW2v4un+aefyuxG7wrB1vu/QVDxa/iQa5ERsTwyquJp5GoE9ei1R?=
 =?us-ascii?Q?3GFbksWs1Baz0jY+yKEIH4PadphgHAZO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KQ0dV7HkhVsW+atDsXikHEpmdnEPZDIvV+78yOYBoyQeQCiQeB9x3gDH0QyR?=
 =?us-ascii?Q?BPHXpH8jS8jHnXwIBXVmx71H9yeTv3/idDnG+MrjwNCM8y5rglPUGj3wzO3g?=
 =?us-ascii?Q?pLt50snLND8z2Toy6qKGDzJplmfCP+QelOf+eR3wpLikBUpHZEv1eWV8f2Y+?=
 =?us-ascii?Q?o4V+/nP/82yQ1juHr7Kxi4eR4Atw6F6hBOZgc/9RRP5ZI1tnObf4+cZWiMg4?=
 =?us-ascii?Q?HkMizPiZ4iLLpehxkz9/A2DgH9jSOE7WO1AjcPoZJqFMkHG2ycDHSJ+gE/0D?=
 =?us-ascii?Q?pIt8QlGZUAGvHpyZKBfNalPM6J7jQDpiCxuozuTXwf3VXAyYW/N7kpJRqnDy?=
 =?us-ascii?Q?/I2iGdINPjqv2oA/55MjmW7ujyBnuyUWGa8No5zgxDbt+LiiiSBCzY7uVl72?=
 =?us-ascii?Q?gU0zOqDcuJUnRuK3dJzliz1VUFXLtd/iQ6NyhlCIV1HFaC/4jczQSWsbZNPu?=
 =?us-ascii?Q?hsrFrQZpguxo4VsT6ESDanaKZ4acZZ5WNDD3i156MXv7VxeHxHjZOpTwcV4g?=
 =?us-ascii?Q?Mj33pDCeU5KzUQ7Zp7oCZFFUDvJCyu569O1MXEW+esz8kN9OWnYSTycxrcBQ?=
 =?us-ascii?Q?UrGh2tLjkRaBhG2zfhientQflXvyp01uiPOWYr2V1i0kQG1QIHvoWl+YQOTZ?=
 =?us-ascii?Q?cbfxOUcTliwCOE+R5HqKxiNneXnAp7Ec76h0CeUl9My0nJEUzo+tO90zfr/c?=
 =?us-ascii?Q?5hAmptztI6B/BwgvVHDNeCYlUkqCGBSCRzQDfluJL9ghd4ZPfxA0piDTnJbY?=
 =?us-ascii?Q?KiuDig29YBf6IdUDWJxhHIGA2yVfB5KwjtymqnqjIhADVizbGpUYVMnJRqEI?=
 =?us-ascii?Q?J2FRQm7S6dzB3fAhx5Sbk132cs4zyrZMTfL3c8mWmbh3PrqtyJ4nt1uqDDV+?=
 =?us-ascii?Q?4dRbfVYsAU/jT8BZeqLXdKRq9k5xEK31ffT8iyXCoHzczB0jubAuljC6ZbgH?=
 =?us-ascii?Q?UyTLICvPy64tuyJD4SfytA+lgbsUgtB9sU66mmbCwgq/UDewFjTcgBBXLIvv?=
 =?us-ascii?Q?/slJW+36qA6WA+lbs2jtDXCE2aoQ3rzAaWn6sXk3CeoZUKAzYje+jJ5+m22J?=
 =?us-ascii?Q?gWw6fLaoMdkHDnNJmlz1efOFbhj1KIzbK5/n8+8XCRsRE3s5P6HMMhT7b7Rb?=
 =?us-ascii?Q?glaNvO5r0RSLIoYF2qR9tDHOAcV9wgHvzjLuDVwyuGnX8N2BNVRHGeJk6SHD?=
 =?us-ascii?Q?VD/L5jefWVx/3pRN3qhczBtSPq0jQ8xPwh0hImW4UvgYe/1VBDkhacXRqfu1?=
 =?us-ascii?Q?/0PgVpanqX9D0Vjk6Gk/QFvy7cjvxaClqMHmm4uTB210i5s8PSU4cuPcFPfp?=
 =?us-ascii?Q?L8mwJNI1RY2msbHY2at5xADZxHGfPrdxJRc6AOMsbq1c9XOf4sPyDMjx4Ler?=
 =?us-ascii?Q?2svpExRma/a8x26JnSGxkVkBflRyUO4hEnGt98QqWOYywWb2AVX5cSm24XYi?=
 =?us-ascii?Q?A9f7mZRDmRvh1xaclKQVRfVl/brr8XZisFrjAcDH3DY6pxWT0UjpcYTMYHY2?=
 =?us-ascii?Q?AtPLLUd0o9iW1M71sqVnvvznjrYsS4Jnu3Iggd0jO7K80tboEtOVEbdtSjOu?=
 =?us-ascii?Q?CICahdQ8suo3oog/ZGDVVxDHYYKU0w2DAAOIKqyS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BtZZi1SUgvndBdmHyY/l5qOF337RlLpAI+4qCOXF+IdPwI6+WRDwKsnhCX4kJe+hWGzD5OUkLOglUxFRUMMGQoo0g/+A17hQrHHkzyq3TT/QNBtzfYZ9Vqlh2eMfRDNW3AVt1nywHHEYAHL0Z6DRLmV0gQUu66LrltPqp+l9vFoQVlALx+jG/zb7nJyutw1OPFkVxJMDQUEIA1ivKoqXfMfv/fEI+ckXZhhn6h4JvG12aMgVY8+DYotAQCQhctRH+S1C1yvtNURcjy5mt8tVUEDO+V24b6yeSPZw3OMNwhEpdG8juw4UQqWNrYTmdioVXkKZ+PoMZw1mXwWIuL0qqltuBN4HhYyZkYkPARwZyZqIGCQK4l9nV3ip5oz1CWhYpJ8PTYRdbjMMXsgkcH/Yty/+eivhP6FGQy/QkK3/7SqT3H8Zke8Ga0XMhTrI1Pr4hABejE/nvaE6OV4QbwRUeuooumSopbJ+8UHifNAv7+whNBNs1EEh8itUiLHsZJTtR0NYzjx8yHSciYKmlaYc9eZ33+PIXoSZF2QI+6w1UuLIb6UJc9X1ntsLhZDM1aPsOmYWtCw3FiiIo2oHt9IPihaOGXpbJjfbvOvlW7xrG7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bab498e-01ef-457e-0a19-08de1047dc4c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 02:16:35.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scY3ovIhY5gICKUl6o0vumYzyIc2ih5x2aVl+H32PArJ3YGx8S5tcDtCpi3cO4+sCJfX0i5fEv2pyy1vmUT2DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=964 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX2EPjfednJ/5s
 6BQh+j0cHP8BcrdAmvHsYAt0biSOLpVs5MgL4QOt8IiIUlExPtO1t7Fy6oqKteCgLedVH1PzlJX
 XrjF7tAx+ppRlHAiSKAM4y9AnivBH9RA2NjRZMUGqE+lJqG7ZC56fRS3hPhohJB0IAq2rCTuSow
 lqZfZCyCTroRNWy7+pFvFaPmVirUFcZxa8ZrKfuMKUEa/A2r4t2XimlnrsrFOpOB65pAZbPlaDH
 V6C3RaMtOBc3ZxtSOuMqJSP95yed0xgzZID/1V6NzSI0xw0UBt4qCKW8Lzqdp3Xo6N0JID5fHe5
 QzSJtw2qghBPDe2NA3fD8DNw6hjCel02WkBsOqPSLnUq6g+qbVf3w0s7wu8e4j2S7dumLxpxC4m
 O6HO5HszpoaYvOlHUHQtM7t56rHhvA==
X-Proofpoint-GUID: Lh-HmxFQQUuaXIE1_ENDtC2cCv82qjHf
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f6ed07 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=4osiln6yPbGtAIqfufkA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Lh-HmxFQQUuaXIE1_ENDtC2cCv82qjHf
X-Rspamd-Queue-Id: 5077FC000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wf8sqc1th88d9iumj3y4rxsh9ngnez7y
X-HE-Tag: 1761013002-937417
X-HE-Meta: U2FsdGVkX1/KEGLJzuTzm0YLSOMHbY/raBfx8VmJQv3nxFEQa876YypmPAmV4bNjJ19JbA+QuhhH1PFaOZ+mkGDk+B7RPUgs5j5YqOXD9skuTUx1fiGZoI//JkxmTGS+rLALDIN5orY5SrDvw5Y8ZFuAPX90MCw9if+5Ffv9lAMJV869OJ4Z1JGAhh4ldYAxm7RPQIRpUCX/6ybXsE85gfS0JUAqy9qqJAS1tiUC1XbrOqQnXfMpnISfBhKR7bQDhyY4U9cSVKxvxsRlShHUUWeYj7Y6imLgnXef5yeZzTamuxhZ0ner4H0L+9VqjcTF4ta6d+IVwEYX7Uz7q1Jgy/R7JvxBWw+SK7HZCqcTavobnlCzTPRwSEMG/vQF+A/+gg7fU90zA6Exs/YSgpqqYQ57yaV8/ni2tKiwQNsNZF20rKiiGdEk7lK08nM4UbIcDaPFf1Dva+iFP+h0nsrScUPxveU41zCI7IuAFnpw/QFXR5UmhChAfHjZ9WslOHfDbsb0AvGHaUD2qkWNpVnC7S9h+fLI/1dF6O/Ev0VqaBSFPYxXL9FLilrxcV1Ynm7nyixnn7TQj82f+Zc2kd4tTCBArM6DUy1JnpIY83PCRN3Xs4BJHSm9zgs6wWA6UB1AqToGc1/kzffWGBhGRtMNuNAjGPCyVa3eP9XqY/yntM+SUsbeOFQoyq9olx2pSoKg+zs+kyaGSoImzVaoO41u2HVC6yBWgicAEyJpRvu/9JhDK03pKPTKIMZdDSeVCoNC5nd4ObezzZ5+LjTzK5mM3gCbnGD4apYlD6mMf4NozY0cFkwP9HkgCR8JQuWHUn21g3FfqM7Ao93KsUEAOEnaHcRHKrUHoLs0WdqqX6925RWwd4KOmufI/3sR+Kjz6s2dWFLx3IlqApZl9S2IFQCPstBoZR18XQT7K3u1e6LUPKNBxMwpn3X17j5kHrFjZzRscWiGE+Ehwpn/MBJz+dD
 A2iKvfJW
 F63Hnbi/tWusrnmaBMHKYA86hdYWPuNRSFdO4OWVUK9FuUODq7FY7a7L6LJdPl5skSsryq033D2P2wMjpE/gKxwvP7qg3T5Vky16wA0ToRiJ+zneFoPrFwcYr2OGaiKfISkCfRjSiCoV1ebbz8oGoShCTYUVQu2EF7f2zyJKDrODaCi2KC6mKivHmAEm5Z+r0357HstZz5bPlasXVYkNDy1LXhkz9+sa5ID+1tJGdNrpJgZnUrCw2tWizdnFMQHp3Hj0Ax0vj2dLvWr39NxQnLeS6eEenvg4ZzL/B4yRTRrjWY0g40TwnnJOeu26UFZIUbkOBB1S3kGKPoM4weKTaIZzo08vjQEYtzs/svJcEIxnDo6LMcjn5z5M3LpkjijtWtzl9ZQgfT+5druIe+ie7FeiiM6Q1UJ6kTdFXKwBDCiKgkn7OHW/bCFqiclgU6t2OKHKGeX4orWHCkUzJ7XvDQCK1MlgeaNvxQeNi2YkiAp0JkLHPWBD8XhDAK1OWZx9NHpV8G5Pwb/d2kteQfTjWSNZyhmf9DZOb8IrkMqQHE2hWr2MoznqezvMEQeeOTAR35xGnKdLS33sXJO7hBNJbBOs5fZad7JPXu5fx3ZK9beyvduUh7ICbO/WsGXwpRLe+fleJkBBmbWSzfr36qMMOkc0xgAHg1CKaDy5Ixhz3n6iFfh4T/WEAeCRMgQ/OG9e6ulNckDnqsEigOT4pUo/BqUZUMeGINJNhzUZ92G/IbXE67cU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:03:53AM +0800, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> If two competing threads enter alloc_slab_obj_exts() and one of them
> fails to allocate the object extension vector, it might override the
> valid slab->obj_exts allocated by the other thread with
> OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
> expects a valid pointer to dereference a NULL pointer later on.
> 
> Update slab->obj_exts atomically using cmpxchg() to avoid
> slab->obj_exts overrides by racing threads.
> 
> Thanks for Vlastimil and Suren's help with debugging.
> 
> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
> v3: According to Suren's suggestion, simplify the commit message and the code comments.
>     Thanks for Suren.
> 
> v2: Incorporate handling for the scenario where, if mark_failed_objexts_alloc wins the race,
>     the other process (that previously succeeded in allocation) will lose the race, based on Suren's suggestion.
>     Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
> ---

Looks good to me, thanks for fixing this!

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


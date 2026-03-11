Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD08104C007
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6F96B0005; Wed, 11 Mar 2026 07:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84F06B0089; Wed, 11 Mar 2026 07:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9318D6B008A; Wed, 11 Mar 2026 07:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F29E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:17:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F25C9C01FD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:17:07 +0000 (UTC)
X-FDA: 84533530494.11.03EE064
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B991C000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:17:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fMYMTVMn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j1jVYssa;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iY2oKoy11+4ItwFhtTZHKYD9nl6GeZQqUsIUlyi5gx0=;
	b=lLufUQfWt9G2JASTjUOI9Hk95/1ge8CT98arYt9Iyxl1OCkwbcl2IVPr1G2relxiLSCDCT
	jPAfDHoZTsc22u0waLN2KB/6ehKGrMqrVSaH7TeWqcMcF9UdqQsMGe1lt1R+HN8Ebww6kb
	TCzstXLzzKqzbbj3QW5VtFHB1kQsJZQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fMYMTVMn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j1jVYssa;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773227824; a=rsa-sha256;
	cv=pass;
	b=zW62TCBAAJrboqzPcEsVbBXRsZCj9aVgTueaoZh0nrVumKbbkm72VpPPmHc8ysYRYr7VEz
	jvuitVXnFJ/sjhjivH3+C4UqciLriIxmL+t3sDBCzQpKkkcNFUQ2vaxsEMEWrVr83k8JxQ
	OT2yLGGQkEEH4629cM6+ahQVw+RaqcU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B7vdup3951037;
	Wed, 11 Mar 2026 11:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iY2oKoy11+4ItwFhtT
	ZHKYD9nl6GeZQqUsIUlyi5gx0=; b=fMYMTVMnU8W+Uu5vc5qozTkOlfGcrb2alE
	mTE0x1F8MlAk9ph6ssdWslL4e+pNe4sJod3b1ztPUB+0hlIuaDwUv2UVSsgdzYfb
	C165vNlCIV0WMt1K9WFgCKUpeizJ6NVGiyF63iRbteypbP3rbef2a+kvsGuS9zta
	yY2EBOvokbvSck1Cl4zdgzsLOLil4JipZ/Wuj2BTP7k94227rnQQjFfMzknpOcEb
	s25z0VSmn0sNczzBDShLK5njqaLH7ZYV5ll1NQkIWaecKjydbqm1E8ZQ2wQQ9CRi
	dK80uht+eUDceEncLZnnNJCKjZMK5XnYT2Gd6y/ZTmkcuDqwZFZQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cu4far8e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:16:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B9VQM4040493;
	Wed, 11 Mar 2026 11:16:57 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbevxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBz59Ql+1WWVGzwpKSExH2CFIVe1eCg1j+kcfeiuvplPbNCt8Nu2VU7RAT+ZreTnQAne0G2xaRwzLF7zP9Xw4m19cqawOhqMdF8mL6r8kVTK374VA/QxmGvpTfT9Mg3G+eKxvbRYZldKTIBVWvEZyWrgGYAS1TPhhk42B8+xp07zF1+K3p//akTtn+lMiPEH52M+N7+Xr7Mv7tNazs95dps0g5r02Nch9GtbGT4zAX8P265J5OGePuYmbLD2sHI3OGp2eZ+ZYWiT1dKJb6SWLXel7DlaG1Fmq3MQTXW024jnw/ybfFY5cImDl1pS9SFx0RkdwUPqCbdD/xU4NtBgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iY2oKoy11+4ItwFhtTZHKYD9nl6GeZQqUsIUlyi5gx0=;
 b=ZbaA50egN0hpIlDdH6HteqpuDr0327lM/f/T937XEx+cEM7fBZ0HuUMugU7yqfb5iqEpOcbGQSSPL1qFA8017Gtlr2qjMjEUbNTH8u/3viW16yRTOUJeU/EiMTzGfvs4PSJs75EiNIThoEsOF+xWA2M0Zm6WJhMHzu3VZ2OoaEaROhRzon1VG9OwlO5JvpuwZ3KF2wuHN98GJFlu0nsA0ftS5htUXqFSmo5E4qSOgmFkMj4m87CwGLGykdP2CWg0eGQgDWKxcEmq9LKd6yKZVp183X+NXlOg4L9TGDwiok3xopkhsqiInaUKTZvQAbGKznqppBVdbM/unXNYsX8NKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iY2oKoy11+4ItwFhtTZHKYD9nl6GeZQqUsIUlyi5gx0=;
 b=j1jVYssaEqCTzzKU5mmJCbmKsy1uK3Du8kdqYu7PnW0Tq3o5BX+bGlChHayBEoU4IbvA5Oeq3UncdfrulNGINgcdvhKV/dO1Eh/UAcMkYSokhoJGoVyBD6DRn+wGJF1mJ/nqWYe/3/bOlBFSoGO2vroVy+L2hOq+K4tDut7IF38=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB6688.namprd10.prod.outlook.com (2603:10b6:208:418::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 11:16:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 11:16:54 +0000
Date: Wed, 11 Mar 2026 20:16:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qing Wang <wangqing7171@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <abFPHpBDe5DsPL2u@hyeyoo>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311093617.4155965-1-wangqing7171@gmail.com>
X-ClientProxiedBy: SL2P216CA0217.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cc6221a-ffa6-4c8a-601e-08de7f5fb373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zmrBdir6WPoHe+EYPwpowE2YweQF0M4W24ddPsvT/85eslhgsMknGt8fCh/FJrV+uej1CVQPBleDOnLqqIgTQF+y9uGbeLZE0ciCvLATk6+ZFNq+Pul1ryIhlgWWQiHip9bR2G1o5MSYz82EV5wg9NXHF+P6k4pEALAGiayuFOzmIIHKjMSFJTQt7a3nldWAX0a+Ofife6tGFfC8DAQLW1OAEa4avsD+2piZdUoax+EBzV3LxK/ryElwCD8SY4Szhkpy4u9Xl1qAUI9mnZ2Tj+RzXxINlcE6xqoDN7DAsin7z6ifziHuG+BKjKjCgHVqA3DQbkP25lZJlhxDRQ+tEctDTSpMvD1URgM9Oi0A0n3QFWWv/TZhc8BZal1l4G7GAFamRXGMSl47u9FN3WWAubFc0alOoWVixNLOnQkBpfOF6FCb0QJnto8jVyMaeaKDsCF/txcOc27P/GzMrF9weCLz2qDCbOGWN+8X8Bl7L9aZO7Bff4+fFYBz6kk0oyvAK/48vqR+GT6B5t3WKtf/AIf+KDWCL1yTPg5yWLXoADdtV8RWtABjmfrT8sNXzALdi32uLDs6sXdgVTzxnihbTaXVRaPcHiXe/ENQ1T7F1n8hPA8CgJ/n8qyPXO8DQ8mWycESDwX2/nHs9gdAxMrymo0wybGqDzG68w6HZQjpCQz+QWv59t085xx/wS6Sbq+KexBVwrupr8b02HqXKjK5/gDGrKHk9vNMKp6Qcz86QNI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?av0sZc+XPnxtPtgwB0+R7grVvnxZXkINcXtEOEBXOUg60YQYN59tx9YTe7NW?=
 =?us-ascii?Q?E1tpZMbHENgreDGn1HIv8u4XnaVPJyCgSQ8ecJqGHvq6oI2IBezU83sg0i2v?=
 =?us-ascii?Q?jQhbYmEaF6gPtSbCzqe9k1SX4qG15JYLI/se/y8bLTg2Y4xN2oa7LSqEP6vG?=
 =?us-ascii?Q?Ob38J44JSNpFbDuvA1d7q3x1zXg7iPf7R1GUl/othr9KdMKiR/jfyenKTg8N?=
 =?us-ascii?Q?gcj3X89+j9Cx3C/gJ3I8sdsRrqs1GDAgq6tNqR13nKapmOT0Z1JyLWkI0rXP?=
 =?us-ascii?Q?4nPumlVeP1yP7VOm70v5BOTPBRjxr7dGW3AVVdzB/I7TueSOau8uzW5XFic8?=
 =?us-ascii?Q?+MUu7EVfsLBJIs+vyt1dY9zV3YAU0QL0p/IlU0UsAiO70BP1m6XgzWmvIEa6?=
 =?us-ascii?Q?e7E3UkHBNLFh20wWOXyKSBvgarP0f2d5Q6M4z3VCjQAspbz4+gZPTHBUOh1u?=
 =?us-ascii?Q?sb37Lsusn6/q8vmsHzQyzW0wonMugnv/wnbERXM4WRnMlW0muN1X3yXyH2gl?=
 =?us-ascii?Q?mGm2a313kMZCfI1pL3WrMIGuQLwDCVHjizAzSLK9+9sUcYVXajL3I4XnK5z2?=
 =?us-ascii?Q?QOjLs4IqeVwUUxMZQ6pSk11YKjcvvGEhQSkl/Rih78YkdqLmWBkSdN6dgt4f?=
 =?us-ascii?Q?zzoucs7PyPDVifnu5NJU9fCB6/YIzyfk8ZxFoYo1V1b8Mr2/QKJaDX5hj9qT?=
 =?us-ascii?Q?+SZhdo23CbQChAklpz9OzZxNE6iY34lTVRoZPaigD8e4zfgJurRNUXq5HPEq?=
 =?us-ascii?Q?f5emrmuKBV87hEKM+Aoi1IUO+DU4DRijJwD0FHXcPAq0YCdJXi1jhVaXMHQ5?=
 =?us-ascii?Q?F++M9re6mBVCiIAYgET4UmVQZjyrLtASloR3AK6LOUeBsrQsN0j6bsVZaQWb?=
 =?us-ascii?Q?yoR2K6to5nnvA3OlqCb4g3W6ZxbUyjR6stpYRMTF871mHL4CCdBw7yv1O7FJ?=
 =?us-ascii?Q?+YFFkkLc+jBAZ3kFhNHU+wTNtBKmMwau8G2jnLDoJTOapYAp4bfnXird9pkr?=
 =?us-ascii?Q?Ml/I+cps0nVL7JI7YsBXOqF1QwurB+/mn1+SjruhDkNf6bJ3/LZZX/SotaZR?=
 =?us-ascii?Q?f4qdEjh7EodAkSsyjTgoBp4p6kR8AxgsJs3Ygl+J6x18WGYLpe/LQkbVN8D5?=
 =?us-ascii?Q?Dum2VclM34xSk40OhQ8hMZjCTzjzivpRGkzk8ycrA5x5qtSa+9jV/tAdSeSO?=
 =?us-ascii?Q?y3Wyr77jhMJLZju+WPDehNedg7vNDqjWlovWs3sIsH4aN6poQMGjCm59R2by?=
 =?us-ascii?Q?b+UZqnBxaZYJ6/hB2Gy9u7byeS+69y/A7N95IS8zvZAesVrJRs0CimMRh0DW?=
 =?us-ascii?Q?nQ7hRJgPgBgGiUloYZ2ZZ0Rb0ZaO0rw722SNoGiqhN9TWz8owjnmfvwtL9P3?=
 =?us-ascii?Q?GnVde3FIlc3eqZhC9VSWTBFgAU9ZUZ1X/zaF4pyFFenNZJargLOcmlylAUyl?=
 =?us-ascii?Q?0+QRE7TlPgOA0ZhyUjayRbSKH69eb7FsyIdCBC1kikSi8xIDJCUfX/3ihr5w?=
 =?us-ascii?Q?bFPQp0p/lLpUbtA8AFMqPMhK68y2wxBojDwuQbzvX0q4ivxZEVjFKu5+DTX8?=
 =?us-ascii?Q?5IJQbE15Xn2rrdbEEDE0375Ngri9fusoWn80gtsGA1D1EsBxK383vnCCTC+p?=
 =?us-ascii?Q?4sZZEDvrzfN30yPfeEqmFdiD7TAsbVsgLXKTnbIURbsj7RwLhxnGMk2G7MJ7?=
 =?us-ascii?Q?IfvagP77Mh9xswANhxzRjXMFPHkJeC5bbqg4EDbZzKsrAqIDqqK8mz3H0p9M?=
 =?us-ascii?Q?fnrvyGfLrg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	UBWD43yKqWHpxZdKsagKSzlm4J0NO0CHGk7PS/zZWpcN1PHvP4GdcsfVFVXbbOjPPLyDrKgpX0kRRJnB3vo8Jxvxg9jf8iQ/4BJLbaKl1G83176HjiIunzxy6gFmK/f+QvY+pBq9i9ZQ7BHEFq9fW4mJltJPwuZ1+EIlIacwRGLI199pgwLVqHkso363tqOZ5lNbNWPT5bjoCCClwkX3c/jiLG0lFy3E12htSPMD7OtnDTd1KUTI4JyJ7WjEzQTzfuQMfdWiM57ksh2hkA7E9OkmUl2bPRPpqnxwspGwz9rWnr6SMrSLy0XhgQVRL8W5z8Sm2e0wNmcRoUJcVOo//Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4D6KkjF494CcUFPJi8aAVSrtiaYTW+Cpd6CHq+KF4B7a1/iLRK+4gJLEhXBvprpSd55ca/EgnZgRGtD2VhRBtvKlGHkj5IYatiJquJVZGBial5cBa71YUPksTDYYNrX6S32TS2z/ZKKAXnE025DtJQU+Fap7a8npn3mdxA/0EyP04hlBVy5INv9LA3r9ynOKkPN55hsgKh5dDSFFr0kiT6EGUIL+dEkUorDiWTa+FZM1Yvv6paS7vmtm0Bc93DDCQa2zB4DidLT34cE2jlbWWUnBFnXCfuclPIUrp5r+ZvqbHqTjQCHE1yx3Ao1IH9LAeRlqbXHwHQ7afy+OetUm/FHlYo0oAW4v9gc4ub/oH9S6zXdfYIbT0X3zA8kNnoehQzMrvPpqUj0C7hQ9JNjwbBP62ue6aEAlSFKiM6RcXOhkLUe/MxIsFbWYfmagQEtM8jvUkWQWOWWJalQQVx6bWgbqOzWU1u1ZjdKi3caylvwhfHPGwAt8hAmgvDWPKU4zQlrqzR0ec+ge/JbAHAqPqjPab3sgkQjXWBRnAa/Ub8TX64OeVW3uLXZO/nIIf9R7frLfRM4b2/xpZtpzBcnHU0hIYeUNtaiY1wR7SzLDr8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc6221a-ffa6-4c8a-601e-08de7f5fb373
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 11:16:54.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYhtKsSIILUsmdpF0Rb6HuIWprqQIW3gE5hD0WwDELIR5B1RlVdimxf/+wpTEwRoi2Nxj2wEPJoUEENR5D+DlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA5NSBTYWx0ZWRfX7lYrg79DKb51
 Q45qyqGGcZBI58x1D4pdHj44qnj2CVGCwmM3GZ3q+SBDaJ3k6qYcnc7awOBG8DOkLD2qGYKdACL
 BVtakhNrEuOgMgwzd2BrefRi3MhutEdXu6TYYyoyTt819u/ZqOpreuAsK/3lh7uVGQ0Oy4Ge1e/
 hejQR+fzOXNtEoZU/sYMeVk9cknjA5H44qk1/n5XrtvnOa/x36ZXHlt0xVqpHhFRAZftskejgBx
 hc3J3weObOu5uusXMeJv706idASKKa+13bXTKh/00pHWmiG/3gZzVOLQNJzl+1uYPtyTXM4xeWF
 YaXpLdmXtpHeMhy2yxqm63GAEvP/1k6kpcdhV615XBePSnlxWBZd+6oqL42tYVPbCFLvuyc5HL7
 gy9o0J+2fzHHfzJL+VpTisAVPRBN7oUoJ3m7uL9krF+AJ8LcY1q/7IgHVwRyoLv4A/q0bFv7xEC
 GhMtFsNvAQLPpnpo70A==
X-Authority-Analysis: v=2.4 cv=NvbcssdJ c=1 sm=1 tr=0 ts=69b14f2b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ef93L0gbSnvVx2YvGFEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ioiM8MK7G2mm6vYrn8fTVFQBKT1QY9YE
X-Proofpoint-ORIG-GUID: ioiM8MK7G2mm6vYrn8fTVFQBKT1QY9YE
X-Rspamd-Queue-Id: 7B991C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: hecq9ew5t6c4ikoo5isma9z6wkihiar9
X-Rspam-User: 
X-HE-Tag: 1773227824-346890
X-HE-Meta: U2FsdGVkX1/3+ANVmiOAiDhsGJ85u8tjOg30IHjOBp+ZfwLOdWkFBwntgS6WAypRnb/1stCNuAPjkerPZGUZajRy8gxZmQS9w8MiUpB14L/5wyz3ZmYSIw1C2D67kIwoP0CrRwjkUVOmXtsohFY0mx0FGgk/FgdMOstVfjUQTLUbi5bQrYTRtzbopv2KPKs+a6gHE5cVAKzPaoZtlWgI+Iz63zUu+4DOMHvOu59DG9HX21PnYyI4v2kn//DCOnp1rlkLm8qddPSabR56QdL/c9eVH3QoUYTr3b8NcZHsqr8BJDgAvaNTL9I/nfgknDub9wPcqihxsNkMkY6c03GcIIkK686YpEOADZv4U/FRJYdgXHIeNl+8DcKX0K9CV+XMvkoY2Rkw5AsiqpVlXDrDoYaRylBX880zhDqQfLDNba4aOquz1oqt23DvzetyXdHoLoQPnV7U9racrbABKXKy2BVGh96M9IYFzm5Cg+227bCKH5UU83deM9ZERjo62ddVMA21YKTL5MwRGAL2PW1erJ5hM6ZTwNBjQPt17lFCpj2XxrMESoB2gY2LIsqI/2pRfGCfN4XsNQMoNlGxyKYosylBfd3RjL+K+3Ma2qGJpdM4w6pvJuSMCHeK1BtvYSLvR35kxD/qNc/HDwFFpnVEnnCi0OEIRcseCZUt2AIwIOKNaR1j+HOOdEOqBw+v0ek00PP3nuE64AksQKBRiOtauezLnbdFV/xLvUWr8gyDVMcCcp6oIIdh/evTFWmfeolT+MVF+0yI1lHS1RZ1farhDx376Y25gGUKpPO53EXA/Owsb33ZMT9qhEM7NiFGANYgNgVlgdQIquYoHGP0Hk1Aasf+rEc1QDJC+iK+JTVLIbgQWxhB29EvvPcov43XDt5k3arPhuiynSJwWpmnMHuzqH/lyrSYg09ExMfcNvGom4FPc9MbuUNFKVoSy/xqj2fJCBfmhFIGh00F4Dk3Kh+
 2yXvLl5L
 qOwdX+ETd2a9e+8il6Nue9DtYBJeOIXPu+qTLFQrF/1EMz7JQ0P2NooqfbEouKvK9L3KbGVMM+QcqH0RLmB9v/vceaPLK3bpixM/HkegUJFPOXstjWY5vaMxOhPn647LtfVoGNmFmTzBdReVaZVzk1ssj86UBb8l8BI1e9uYgJJfB5HgOFF419Y8TXQ/WJzN8tFIXUc+kKCeq3QG4bw8cOYGsJ8NfGzMIv4IKqSsWF1J9lnKSX70+kK25jfUrLHbrcA0rcqZ52gsSFlbyrLuFw7UD6/8X2c1w70SKWcjCaBjAFCdicunIQ+dXFtAOFC/qgOBuRuwDZgTpqDDM+Ow2xfbfeQqierLj4ALniQBF/tRrQeXw33HcfDgLCp9ljZeSvKKlgo2mZMaaI5Uynk95Dj3UiNArmFwLl34f9Gm66yvuKACUv93QAfbwopl9QY0tsG+XCqg8eECb/m0YrLSyZEBG08K7UHJxvbStGCXuSA0I8mwxBtBxaDVu7elQi8GJAoPB/h9kF3bTQ1A4wfiVpm8sw3UVM4xe2FawjmMPzENCagsk9HFcQLX4VFWEVdEZ21P93hPh+7pnLNx5lEOk4aTmWsSNTU0kI0+jlFI2ORocxDQUuqingwZT8KVCMbiJzZiuDogBHwM7+QZP+d5/Y0/2NzaOYlI3ZaYcuvYH9qZjVNS3ftyuRb6vtnWclqk+190oObXu2aGkueWRPnu/HGsE7+SPKuV/zxpwkKb4lVoH4M8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
> When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
> but need to fill 10), it will update sheaf->size and return -ENOMEM.
> However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
> directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
> causing the partially allocated objects memory in sheaf->objects[] leaked.

Nice catch, thanks!
Probably the need to fail new_slab() made it quite hard to trigger and notice.

> Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
> free objects of sheaf->objects[]. And also add a WARN_ON() in
> free_empty_sheaf() to catch any future cases where a non-empty sheaf is
> being freed.
> 
> Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")

I think we need to add Cc: stable@vger.kernel.org

> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  mm/slub.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..73b2cfd0e123 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  	if (s->flags & SLAB_KMALLOC)
>  		mark_obj_codetag_empty(sheaf);
>  
> +	WARN_ON(sheaf->size > 0);

nit: perhaps VM_WARN_ON_ONCE(); will be enough?

Otherwise looks good to me, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


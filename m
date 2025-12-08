Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04B0D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156146B0005; Mon,  8 Dec 2025 04:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E7E6B0007; Mon,  8 Dec 2025 04:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11286B0008; Mon,  8 Dec 2025 04:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC9E66B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:14:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8283B5C027
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:14:21 +0000 (UTC)
X-FDA: 84195742722.07.3FDF1A8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F85210000E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:14:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJcs+F8N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mlb8JTYH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765185258; a=rsa-sha256;
	cv=pass;
	b=l2t795IUvnqEqDGKJhMrHrPu/m7tJdYOuUrSIm3+MgLYTmFAHlZIOQq+OUJq4181HUm0M3
	SI8J+XctOIM6pyedS1Sld792TuG/3jCoIuFwnJyIUNcvriuwSGrfwa0yJUL89GdNoduKAG
	RtVkygmAcV32Uq+zWCaVUbALS9n6PaI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJcs+F8N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mlb8JTYH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765185258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75PF/UZm/1K7PMugwZEanpUO8LVVL6S3qkuuPwrhHvw=;
	b=3DKDDlvwyEeQz6iUEaWyFQqVS0G0ncJBw3z9/1azRcdgU6Q0aTSclzDrGV2B02RXmDKARl
	hYsI5yetsQBpeHltCFnuJsqR2nevnztHbx44u+j9SHCiuilGv/D8l4tvMODwsmTrAxWpP2
	zoZ56h7LIu6aj86xCtdTY+Fhxa23nN8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B895NCh2001879;
	Mon, 8 Dec 2025 09:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=75PF/UZm/1K7PMugwZ
	EanpUO8LVVL6S3qkuuPwrhHvw=; b=AJcs+F8NBJZ4aMS/9PJygJM1yUUMNdZa+n
	CbVDZG+kpYJ7yPXLBer83qiHtwz6eEisKJsxcyUGguX/l1W5pTlnSym/i7UssFc3
	Bzd6nTdy9dlD+YXtXjozvLTkLI6lQ+XEAbXJMWd10zq2Kzqwmk12Z7Nyy8frC9Nk
	qdJCo0Rg6vPCQEskiDTnaX3vcHxOT7Kn0HaKUspAC4f5w9XkLfHM2dxJo6GyE44B
	azZLQUg/+uCFnlMCGnpVzHpBqcH7GvhUwuMBY+JjWQ+PzvaYy/P4lJ9PVZcSXLoQ
	9W10HQZsygmPwNpu52OO05S8dgLljiJ2mkGiiaRDiNytaevBkHPw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4awur180bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:08:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B86GeOM038123;
	Mon, 8 Dec 2025 09:08:48 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax7gpym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:08:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H8LX6BlRqA3EfEYMSYSRAFNhFcFHmFuHJ801mpo1fjcdyujjKDb2/ba20iuj9SYS9M7egPxUhW4fCVDAKc9OavZlkDn76RJA9DvResmpR0hsX0fSaLkt4q8aFh6kgnhto2FFRTVIRTdhegpMMrnR4wWdLp2hOTAhs2LNz0DxeWyDQ+FGiZ1xptE4LG/Ub+jjqxq4PNR0qf1TFW8cN8E7AnW6Ui2CKXnnb9595hR+e32T2gquMo4mzuLNuWyhE/XJk34MEI203Fm9Qupp2ZTaCg3B+Hh2uTOZRlqqojmgjfI1CkDyr3cKDKWltNazrX9bduZNg39FNy1SWT4fc/apbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75PF/UZm/1K7PMugwZEanpUO8LVVL6S3qkuuPwrhHvw=;
 b=w/tsAKWpQbbYSnum12zOVg1Rg2S8YzFLTONS0ME/9Rb3aDOa198KZEvK4obqv6XPHi0pgFAa0T4nn54Ns64Ot7p22iQeZx1rv032fSOj7hn0fLL9qfmqdUiqhvRWsMHnL3PWlETYw6dCSbMakQl1QxT1azJPbD/RSIPpjFi/x80qxMq+EDsbDAkrW3XtDrZs69jYVnmsWMp64RLjwvf/mvWmxjZAlvcru+LjaLmglWbOE6JPrdZUlE99Xva+u5fsP1NYV4Pu/yBa4RQiyviMU0Je9fYbN/UrrA3XvpGzicXDUXYRGsISJrgEoLG4egeULeu4wud4bC/k5qwi4IM4cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75PF/UZm/1K7PMugwZEanpUO8LVVL6S3qkuuPwrhHvw=;
 b=Mlb8JTYHFeQ95HDdMVkTdmvU/SIr42GoYzP//wVqLIaYBu6xt8Rg5J0l0Ng3f8bHCs6VVcFA5FezUo+cCeFGhuOgq3LA53Bg6dGiGysW/ffB5rCVRIOU65EfrYLHWjevgDkxnOWH0iRTwIKfpxhEMn36RlvxUUPOC2jZcACmBbE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB5802.namprd10.prod.outlook.com (2603:10b6:a03:426::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 09:08:44 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 09:08:44 +0000
Date: Mon, 8 Dec 2025 18:08:33 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        Laurence Oberman <loberman@redhat.com>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org,
        Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Message-ID: <aTaVkTQFqX96UinR@hyeyoo>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-2-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205213558.2980480-2-david@kernel.org>
X-ClientProxiedBy: SE2P216CA0041.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: e49de2ff-0b5d-45ee-e6ca-08de36396336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KRRCdgX/3DM2dQ5JI3fpZO0AaoxFmKD4YB1uPOme7Pl+qzv2uKy311scni/o?=
 =?us-ascii?Q?gXl64VKjz4FMLaAP7lHlml9wY1qABnnei5I0gEZSwltonMhrzD4gzpqsyYvV?=
 =?us-ascii?Q?szlOapy1JsxZyNW0q4dgEsYEQ+u3U4IQkzkrNkt3RD7TyqY/+jQIIcdfeDgy?=
 =?us-ascii?Q?1+2YKSDohf9bYQJRXi6eDAZYP9DCM/zaRqHA/0zZ/n748MadOlkcDgwP3W0O?=
 =?us-ascii?Q?nWU2O1V3RmEsBADxjoFx9m4E548DYzhVxZBntq61cVlp79vl0U2Z0yxDSPDL?=
 =?us-ascii?Q?Z8sLsSdf6vpSArRw4aKzs5PTpFcM/eqOwBSs+pqhSIDUfGKE52gX4/Xedhwl?=
 =?us-ascii?Q?tmWpr5s8Z3NYsyexSww0dSJ/W1RpfFn3qUBTfv3dvTHCejLqMlf/msR2h/rv?=
 =?us-ascii?Q?OlzH9qkeeQ2396Odq2HW61M6nnbFy7zCGBJdZUXIcPAQX6XOtGAGHjNvEZNX?=
 =?us-ascii?Q?rHX4sqt9zuo5k/ghQT9EmRqVnGlCiE1CuyS987o6gL9IUvymnonh7e5sTnjR?=
 =?us-ascii?Q?T5VjLqPMH4jWYnUiPAkwTiOCiNtfU8pagKiF6vs7HPJ200WLRVWCV41jCslu?=
 =?us-ascii?Q?j4jMI658v4o7YfI+D5TBcC7AYvyDVAJhIRPTOt+BDlyEGpPErh4A9Xhf0tP8?=
 =?us-ascii?Q?GDrrqGUAjIFPANKwaMIspn25oY+o0WZawcmqcPantztJb7cp5OZUcDk/rtjE?=
 =?us-ascii?Q?ia5bJH7OAktvUWKZvYKI+w6IvF+UqFp4o0ELDqAYF0y5NcZQ7D4ukKjxFFop?=
 =?us-ascii?Q?5JtyzoxVlx/RCebKxzEWKXKK/mQwM0cMM8KPzcwatAdThBrzCZmAm/JC23QH?=
 =?us-ascii?Q?1zkgsRVrpH2bIw6xJAAnyll0D3lBk2+1uXThGS4lIIwjCT2L6Q2gxoplN6qP?=
 =?us-ascii?Q?Khu2c2OQ+UlMwvCiEMOcY+nfDByiSe1W5r8XB+tfsRnlkrkAS6z5br60G5e+?=
 =?us-ascii?Q?QwL0RrMW6rVep8N19Cqg5TQgvzmuUTY8eyglqQLYmcqHrGvs2Y1Sqngzw5PF?=
 =?us-ascii?Q?TbNhtptApHuQIBpYmhuWWxCAw6mSrDEM3iT2l1YO1lV3hKQ/kYNno+hxfoUl?=
 =?us-ascii?Q?ACOfkl7H8j+jGo/EXxN57lu5u2eRAFHUE+r/GHs9EHQyEpGigMXpubHmo8xn?=
 =?us-ascii?Q?9RtdWYM8nusmApVSf2K482/g5puZwGrEmOgsUdfr3kO2skG1lUntF5z2VAVF?=
 =?us-ascii?Q?A46YCv1sgaF12VogL1LWByrGn6qTysSdYQxkvkFBP70LNfKDX9LS7Gnj0/jH?=
 =?us-ascii?Q?BViR5tHH5bkD21WWWz8GcJ+eaTs2As/+B8JCITUCDcOFCkSwNHCervStWOtk?=
 =?us-ascii?Q?Wiltv9ENc6hoAg+R1YARac+7bJeUWzPnLqTmgQB6OxTB19MAHuKAw/n/DfQv?=
 =?us-ascii?Q?6GtlqMPtmVYW/ZwXOkxgVOEHRjj/UCkpnwpecC7uEH33hG5j9qGVY2sUm6Pj?=
 =?us-ascii?Q?KqA2iIjRh7zJcTslMV7XlTyqpdaYPuJl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GHLJQh427aWBu8jRTZRRr7NvdWB4Av4dlErN0zIdRRVDnoPuALmGxNrYKPAv?=
 =?us-ascii?Q?gUmF5fRkdEbDWD75qVoRqRnXNNLPfvBi+ObodNqZInoff/2FMG3hd2zaFJ7w?=
 =?us-ascii?Q?CQpm51/I52mlbEwZpJuFuzBTIbyB9Vj7gZUGeaKgtS8aw1MiIxCWG6emWjJo?=
 =?us-ascii?Q?UGoaOm0eveVDL+cfBd+Yqdklsutnp6bxk05h7cBQMH+CrE6qPckDLGpbspdB?=
 =?us-ascii?Q?U1cm5OiwXJHvwquj7MhlUJSYAmSIqfx3tAFa3dmtLC40pqAToKKOMvs+76dE?=
 =?us-ascii?Q?0HsmZMn/CbtxauJ+pdAuh/K4VVRMaikIcaHfMP0SSgao1GRRo8Q/5SXWr0G0?=
 =?us-ascii?Q?52B7EWqEsOaHnOBJIVpl0K7fEok7UpscQFrO7r+u1CtXbgs6zQdnyV8z1+iM?=
 =?us-ascii?Q?x7o08+Oj2h5nTYyFeS3VWygX96xBYmRERqDkJTe99lJ7ANwzE2RozLoGQQS0?=
 =?us-ascii?Q?mTXVdiOnombvb+aSHPodrxRJVquXpm7ztsyaDLNPyV44l/zgkyUL9lIBkI91?=
 =?us-ascii?Q?w8sM0Dz0ni2gt56C3PUbm42oEnzoCUHqYLHu/jlI48IFSdZkDEyuGOILZrjr?=
 =?us-ascii?Q?fvc7Dz6GAkulIGNCzyXeLZyl2ym6sMF15BP+fdIAbJ5u3uNQgrgBbr4BHx1b?=
 =?us-ascii?Q?6O3HZj3EqpRHNpP/C6VV3Qta7tyhzYtia1e1gy9yCs9svrD88yZ8hixdXXk8?=
 =?us-ascii?Q?1Pcq6g/5yRoaTM3I1Op57Od8T9K5FakWjlpj75kusvXkZToukYYD9V2DP5FD?=
 =?us-ascii?Q?htbouPWtkfY+ZHnEwDJ6tTDNE6dBnbaB423A88ZaC3RoGVxOgUncDx34igo1?=
 =?us-ascii?Q?93QzUAsIla/Jcj+/xf5f29DxhDh3Qpmuu3vZX+1yprEM5E0UdwbIjQdYavJ8?=
 =?us-ascii?Q?UA875D//DbyNWOVRWR0hKRVNbSOvmMNeTItrC1UZCey3U4en01buM5g237kI?=
 =?us-ascii?Q?XVabMTqpNn4rE02i64bOiGKG36HCBsttgSJPiROeI5xG9iGnQyhpNqHfAlrN?=
 =?us-ascii?Q?2Xyl7SKTW+zntfs+8AJBqa1VV0s3dNX5CdWzPZLCdrFeCi6igVsmUlA6Ni+h?=
 =?us-ascii?Q?IVPViCc1ofkBTRgvydmbld7Ef9XiZWQE3N+slJ11GO2x82xHeeUMrA46svKJ?=
 =?us-ascii?Q?eRrOGHzMZQerxvhz5dw9eYa5SlCmba6GBLgwA1p2S/r+5tNifSbtluDpJDkM?=
 =?us-ascii?Q?0FuHrWjhmleafNIL76EjNJdiiidw9hTJA25Kjx/22Xl0c1ADWF9USc9lcTr7?=
 =?us-ascii?Q?Y2jJpYmu2HmdYlx6moAJFGDltLvj4P7hdyzJLz8HohdOqXQq4z6ieAHhz3OT?=
 =?us-ascii?Q?k/3X78pEIymx06hdv38wxPzu2CE6qLlwUqqYQ/yjoAPjVWM/vm2+8AZ31sM3?=
 =?us-ascii?Q?lTtCJk978UM27lvxtyy+FU1+Ps9SUmGDxk9LeeT0e1R6itNcvgDZsm8USQxe?=
 =?us-ascii?Q?sFNMktEXQ/AWw5DUIn2+n0/8lqRr7yqsiSZP37PB/IVHfnUIxSYrQ6eARk1p?=
 =?us-ascii?Q?MXbYYkBsX8BX4L8OU2R+vfX0+9wL+hy5Tj6MKABCZy55pd41ZlPmbYiayIMC?=
 =?us-ascii?Q?PLCqTEA0wtSMVdCTAXOThixCy8+dbEPf1dCBRQ6I?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	buHxMVTxSXQtyq3UyQQ4L9FIKyIyPmiOmB/wWMTDDm3ZVlHsMhmMCAGN59cwXQL7H3wCa4QBF8+3iD6aKehOt0SsdI64lvRE0utalEvcq51yz9FdtLGDQnxvGNhnvLLp1eotgcIkVpBdtur3Gvnjs6x6K4G0qA9Xb/V9qjGJeX5h9wX4ieKlxIqXayHJQPDr5UVCWBCinmvDjAOOm7KaWJJWNOu9GY62TL/vloDBAApLiBbIMTzWmgNL3VXGZjDlRuNFD2FLV1QNg7+ianb7aufXDZ8Xteed+/bsZ+gA5iMMVOMrtJl29BKQr4p8JkZxBcLjkcNACMjFitom8QNN6EADUVQVXuYqNnzyQ8gn0VoHt9AIUN5HUwu94puBMn9E3DGxyZTmRVkoU93Hw6l1llnAwTxK6/myZ4GGmWAdZ3RMVlpJBjrOvqVGR9/KYV1W0yO4m4yA8bKG7TfHsRgB8o7fo9IKNz7AiFh3OnHRm5U6KcXdE81Ym75wNaUturIijs9CnGWJQcR9w6aw3lyICBOYRsNCxs2fWNaIQc9LTTHvwjsgj+M7pSWRy0ymSOQjsJFA7xxQOjVtfjknTfW7LK5b97mVMs5lX1enfpAm8yg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49de2ff-0b5d-45ee-e6ca-08de36396336
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 09:08:44.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CVMUwG32fyFezSTyew0hdCBGz5IDtlxu4fHEiJQ1G8b2VwBRo627XvVLnSujCsp5EQkHqt8b3VvM/pI7w1MEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=673 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512080076
X-Proofpoint-GUID: nJqaCoWqLri_cKxqJ7XE1eb8rZ0vCm4C
X-Proofpoint-ORIG-GUID: nJqaCoWqLri_cKxqJ7XE1eb8rZ0vCm4C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA3NSBTYWx0ZWRfX4PxuG84p8P78
 /DszSXtmijPdn1iXmXHU/wFOF7gRH1PtkyZ+SypwHCVJ2YpeYlwGzg6oQFkD/Oc+xd2FzIIwV8o
 1b9iao1yOSY2IN/AQaDQLe+XBTAs6KxtBkiRy+B9AbWtum1Cf3NTtyg/u/LdJnX3bJ/iO4lkmdd
 c6/v8tQRtqs997Afy81iuUctSMAg/U3Jiev6om1JmpRax8C4J3H1jdVLA2s1a6uIab+WiIyJFP5
 eg9URRM/v7dKAowG3dRBRMkmWsCGYjIGv7ZCAmEqLmyT1A5flw6nUQpVnUw/6GurozgRCPWEi4o
 eMYPxOayKZyOFo3VOL4uGE2aR7g8HL3vywuWWvoXeDd6+0Pjys98qOY8CqOESF+LltvRkr3kxDg
 kbptVvzM334XmkafVBu1tAaqTnSWhg==
X-Authority-Analysis: v=2.4 cv=Re2dyltv c=1 sm=1 tr=0 ts=693695a0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=rOnCVb_mmqEaAXsMVXwA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F85210000E
X-Stat-Signature: iqx3msu377durjw9hw7amfwb7w6rbyqo
X-Rspam-User: 
X-HE-Tag: 1765185257-609525
X-HE-Meta: U2FsdGVkX1+oHhrI1Yp4IBfWgCr0Fkfn4cYOFMZCq13PoQrhSiUu+7ohWEBuqd6PDKreYMvRmJaaONaaZ4QNJVT+5RNo8ZdU7QzWcPAk+Jxfv9S5qBEQzIREAO9TPzvHsjOUvaSsntpLiaAQgdKWs/DWoM2SW/lKmrdafdPgE7KLHhhQZqCQmF4xygzkOvObVbSvT6AiWcfEZLYEexdJJ3KcSBhaZxOv0D+pv2Fuc9Ol88tIJyzWzlyLyECwDqHKW1hFWMmVgNNgdNDXl8wiONu3t5/R5UGaqIkhas9Kp0cc1335H1kNfsoyJIj4sXIOM6e8pwLedwseYgKatqI+uyEMsODGtRGursisy9dy3/3j3j5hGkoq1XuQZDabXEF+08DmG2Lkh4No2OaZr1n79JV6bIBwcnWSW2DcYwuP7V7we9ihmJlABtYtdVQwx/kDGzz11FXYfnEGztKCp3QcbF9tseG7+xMI5bWEP5vQy0L1+USufSAe/1hZoL5zpuic7JgN60Azhy8niEArcX1+9SRcdw9NCOZbyEBaIfzaNRLXO4/93LELq7zAtThLVc5GXCasdA7N76z8/mCHmhUdTMdI5YZpDtt96FQclmHXzbJxZriIvCzGiiDCXOY8FhPc4c9UIIqNtHNEIEkuQLTKwmAdhjPrrNI09WR64M+9/SjcQ82dreds3YWBqUe743xpWJ3EtmfSN6Cic5CQKXL/CXBrzWbmtscNlUila97B+tUI+mxGDQmzZHrUwjxk5YhQ4q3mnyg8N6WkNvXyttLy/kG+yAqBZRrt+gwT9mbrowIi3Wf6DxwyxVMw3lGw/EBQ6ric6JccI0zTEnn5FjS5BMxKa0qWnX1s/ZEI0C2MHq/BcesNDP33RK8ppaLSLwln3at4xJF2Vx2QdfzuBVbWuum0fqSjTaDo6g3h8QFs33MxNjtjLqsH0hKuxYI2HxsgBsbPIjEl3DWZC2LZTxV
 8o4VclBx
 mkMeo7Z2WQOGGB2RTQwyNZOcmZTcKVM6zETJPQ+CCjH4SxPuTW5ZfWHhQMXKDVAWW026GZQnq/bMsKnMrUF+jsQlUHfOAEuEdpRyFqI/mKPVdNSnvLYTjZEQZgpcxpBaUFou/apCHILNSVYnk4IjjeZwstiYwflb3f3mk7EL8WKYDbTfVC7M04BIAEAKz3rswKNSxHoOW6wL2o14Y1ghxniorDeXtDiD42y1hpuPspcvIfDbvSaIYLSAlEIY+Y4NCr1pAW4DjuueBBKhjqjkS+bxcibPM7MG0GiTfxBwTCYre5d+plsv/Jz9+p7qDwZmWQ+wRCan/eKk4cV1EnHce88oX6BAu1SQJsd4EYA4kaV8p1KxN0eAuRt1EnUvuclAmRWvrSW4+rTxt/9hOwwylbM3WbuRCxCsnxpJOXGAkP6EezfBjE9gYIdrtnEoCy/NJ4uHx0WCKUpWehP1YGVgbTuzO9g7LoXv+/vswfs6cBEGHj+BfcwiKgjSNAvDuhg69Xzt/D4HUMqaOT4Qabt05Kb1B+vjKb1JfPEf0fG7pT93wkzx0G+E42Rz0PnOmhp1RLAaBknx5ZkjTwOeHN8UlXGM+BJsXETrbLvBec9+GUqpIQSUgvf8NEv8CxUZEh0NBr3XvXSEAvknsfsSAo3HTnOHINMSmDf68/oh55XeeTOiy/ONu1WsT6azsUPYoijIwKIZLYP76ZFJ3lbo04yNd9yeicggBn4G6p2lDhJ3iBVielQNTEI+rW0LiVZSNw+p//lJr4p/QwUX8zxGEPndqq8bduZDrEp72NPNrlirrT+2+YKknhD9T8LZ400gUoyODDPRlzm7hb8VetOzT7WEHutOKuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 10:35:55PM +0100, David Hildenbrand (Red Hat) wrote:
> We switched from (wrongly) using the page count to an independent
> shared count. Now, shared page tables have a refcount of 1 (excluding
> speculative references) and instead use ptdesc->pt_share_count to
> identify sharing.
> 
> We didn't convert hugetlb_pmd_shared(), so right now, we would never
> detect a shared PMD table as such, because sharing/unsharing no longer
> touches the refcount of a PMD table.
> 
> Page migration, like mbind() or migrate_pages() would allow for migrating
> folios mapped into such shared PMD tables, even though the folios are
> not exclusive. In smaps we would account them as "private" although they
> are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
> pagemap interface.
> 
> Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().
> 
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
> Cc: <stable@vger.kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---

Oops, didn't notice there's still missing conversion!

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


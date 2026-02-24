Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84364E9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DBC6B0089; Tue, 24 Feb 2026 05:27:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20F06B008A; Tue, 24 Feb 2026 05:27:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C771C6B008C; Tue, 24 Feb 2026 05:27:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B00F16B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:27:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCCB2160512
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:27:07 +0000 (UTC)
X-FDA: 84478972494.26.1BBAE11
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D8FD4000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:27:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ry0U/U1r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rfSlQjhI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771928824; a=rsa-sha256;
	cv=pass;
	b=12E02Ryx5tJjqwGVV0+t625/Ht8D1J2MVs7RY6xh+GdpFJ2XuOLB7U2F7x1L6rOakqnp//
	aF30V2xB3I1apnOvkSRM224fPwCnCHaUDGhoFLuh3b3Hplt24Eq3/zt1WNv7M7mnrzl22e
	gEKW2EOcQxx8GoUFeUzjk7emgIo0BNA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ry0U/U1r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rfSlQjhI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771928824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8QFUtid2XGM4ZrrGwQ4VFEkbPb6WXg3AEv7+VpXCfA=;
	b=6mDsxUWtHM4lPKR0961N1k7fzaw3PRnsMQP6N1ChpX6jhMxt+sNgWicYHq5r94IhyVsNNC
	KFaMcPebRvRDdKzyaMGbbFHDtVZzjqjQsRZZet5ygYX+d/t7ui2WqbD/dBlFnzjg4TOwM2
	WScVO2s1NMrlkgeQVetKWh/zJizCJW0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMv4P32948644;
	Tue, 24 Feb 2026 10:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=p8QFUtid2XGM4ZrrGw
	Q4VFEkbPb6WXg3AEv7+VpXCfA=; b=Ry0U/U1rkiLtrF9ahH4bqh/tK4eptiAwwo
	gXMdbjsdKtx143KkOuFYfZxtiYoxJ8eWglBip96bRNAY/Z1h1hSNQrCE7KIzZM37
	kveYiphk0aDlVwHjJqc6XENwp+TB6Gp7RtyEIIIvUuBDAJzZaBDSjeNO1rxJnsle
	kdzFxLfe0hLBO8hN7e7jyw9JLccxrznzgv7Vngi3MNMO4v4LJlkTuLQxXes+AcLg
	ela6D8X45Wx+eUTb5L3npJqtQRjInP51RHhvXU9juaZ7uyJKZP+lXOwaAGR7EYHQ
	mW6NVj0rkmMrm+2AA6mOkCc0W6WZh/4uKBOzsXyERDlCXlQXIwXQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b40q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 10:26:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O9dXmF012751;
	Tue, 24 Feb 2026 10:26:46 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35dscju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 10:26:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8hDnnxdr6kyOYBB9PPA1ICWA9OFxh7dkJa4getJ0RJ88pOYYnWhjnlMyZu0M/GmJyom0W4szX7piTrhum+5l9MUGFh9HlXli1TXOyQdk8aZc9LtHhEQngqTeoSxa0WyRf1hcKKUqn93hSTHiUGjwXwMSJwdYTCNsW/y6t9aCpyM7JX0v8ahLCyANxn5D0tQvbNKkkPS7fRNmR/HEytGhjOqqgID6IU0aFVV+AVyblHAdjJiTt9/3/cgOM2JXYzVB4JMP2AI8XtvmZILBO2IWwdHRBYADvWe9orWop/jz2CicblhssOOn3tMHFH3L1hH/s3H9Xncj5Oq7LDOoGU8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8QFUtid2XGM4ZrrGwQ4VFEkbPb6WXg3AEv7+VpXCfA=;
 b=VeXKmA91/JRtBzmc67SrlVJ37kMlvR5gDg4fdqFxUjtLppQreh3xYv/y0I7Rlq91ezD7dO5z/BOdRRdJgNUh8fB4QldEa0Kv5SfeByaPCV6KVcXLg5xpN6Yh/B+zKDptNg7aiuMeRXM0soG93jE6Im2iRKmEEAngSlBpQSATwl2NnqM2gJ0hsEovFfyOpa0CZ5EPGsJHa2KQba1TTYHBliP4jtbdAp9smW4IAsuy4U2O79yVY8UtsyiI0FBJDoLWWtfoymkAUkr16qpg2ZcvjZ/9yxIPgZpf/b+2i5E9/qCzS1wob56bUaxNwycAdsWI57TYnPxXUyz3wq8yCcsw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8QFUtid2XGM4ZrrGwQ4VFEkbPb6WXg3AEv7+VpXCfA=;
 b=rfSlQjhIvzeeIiSnTHqZq132kQVVNkG166/4GbdobhWvWtGBYyCuAzJ8o0ZwvLiCjLTWgP0Nf7wVgYB8mbLYhhnNDI4s/NVgogSkgQOGF6o/hzZ6wMSTc111HfLox0rQ1LZ+KPNHLDaU3K7BXJu+EhmwVQm7uESywubNc5UetII=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7415.namprd10.prod.outlook.com (2603:10b6:610:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 10:26:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 10:26:41 +0000
Date: Tue, 24 Feb 2026 10:26:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-hardening@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jan Hendrik Farr <kernel@jfarr.cc>,
        Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Message-ID: <675ec547-dac8-465f-b3c9-a0f97c5bdef7@lucifer.local>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-4-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203233036.3212363-4-kees@kernel.org>
X-ClientProxiedBy: AS9PR04CA0052.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 884ae578-4569-425d-eb91-08de738f3329
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xLbSMXsCIzc2gH/f7sdg+7JzADoGA4rmKVHChxMnDpxLTfiClkuxgUkZN+gy?=
 =?us-ascii?Q?zHHGLMtNIrERvlzP++brbz4LIxJzwnQYrgy0Gb/Xu3QICnCVsBf0iGi9hUUB?=
 =?us-ascii?Q?zxjnluvDIZBye7Lx7EWSOKFH6qrpHEdoylDe7DIsqf5e5MtlAAqtB0UVxMfk?=
 =?us-ascii?Q?vb7P/45Wj9XiOwxL3ALBC9GCVaRSizMnQ5Mtv3PD+xqw4gUYol9Ddda2ISOG?=
 =?us-ascii?Q?fGpvTFmG63KYua6wsJ2ZLTWfFMVp/kn26ke2eYOX9yOKicWpq+v25xFPQNE+?=
 =?us-ascii?Q?Gia2FnukhoZgHSwpodcsTUH6rMD4EZ6x5fFRRr++WB7umOj8sW+qX8w+KsrW?=
 =?us-ascii?Q?HQVzEQ+e+GpyNT6j2WlYU81ekgMoW5u0QgUaR3wG2aAyhyddR5yrRDJycOyU?=
 =?us-ascii?Q?C2LqZuti/Tbk1FxtzSP1p0yNz1pxongSpc8TTGtfPtbVy676Kt06Jj4QcZ2W?=
 =?us-ascii?Q?EZ+YN8XeaU13DSmppYDbuSPOi66SNKlTS0oXnpXLsKeDIgyStVDcxBJYfCnq?=
 =?us-ascii?Q?9L5a3pRabVslSzlgkScj+sUziloplwxu6RxM+SC3PH9ivWcttvkHsxTo2TpJ?=
 =?us-ascii?Q?ozmYi3wvSFPnYFo/M63Q5HrpyGkFCj+uw3OJ/SG8hpBp4dS8aCOx/ltt2VUZ?=
 =?us-ascii?Q?QHfXm7pXzybmj9nqbWhRK3F/WIxiM4X4cZ55rH7+YZtiOf3lmZjACPLbl6rC?=
 =?us-ascii?Q?ieeBPDP08LL3SDvzGrfclP4gmH4ERylvfg6gC83fd2Z2GCjHQ6uEs1UPHie8?=
 =?us-ascii?Q?p8QukonFPcBAKHYiIxBosH3E7TZNNLlQndKxzyfgEncNyn9JYO4cV+MfwxA0?=
 =?us-ascii?Q?bZX6Rol+TD2hFtu2WMVBiigI1chekDcl3usR/wxwV8BhVYVVMWXnFQ/bGfzi?=
 =?us-ascii?Q?e6yum0ZJXxiE3IhBaLkoXXeZ3HOD+B235MKfX8MdhZRC6mkBuHmFuXqdaDvb?=
 =?us-ascii?Q?tt1tE3t32TA1daDfqeu9q77zvADk4bp8ZkfqcjoUS5aAaTG67QAe7DYLtrvX?=
 =?us-ascii?Q?FDDo1QOXE3mbSHo8tfeJYGAdSkkDNYHNwyrcJjGg/jHXJ1Rmz66nrvd0VCcE?=
 =?us-ascii?Q?iSMLSWKTxr2CLAT9au7agmz9lv1G7LTNf5QH0vNBvIqO8HOxmg37MfQ63M3u?=
 =?us-ascii?Q?xrjz2xOMyBk0L4c/zCvDanQ8Ev4PFl8zvIEK5EDwcvEHO+ukTo1hkQctDj8d?=
 =?us-ascii?Q?+vaFgIXQWVdwRVuyXJzG2o/wbe3/31HhjWBhm7g4Mr2dhU8RvwcVHo4E5wd3?=
 =?us-ascii?Q?WiAW25trg9DfmlsBXNbvagzpq90IlFRRUfoK0Ru0oIC0DnQjKyHUR08R6W/J?=
 =?us-ascii?Q?6S4NdbvpQX3EXfRAg5HwNrNhOEdTStpUw4TzhOKKAW3DgpfHcaaNpzMWP/a6?=
 =?us-ascii?Q?29RQyTiP7JUAo74UjLVwRe7a/HQQdEYPkjBfM9ZnfQr9k/KKXFbZBaU5NcSW?=
 =?us-ascii?Q?jbIa11xXGv1rF0oDOfKe67xaG47+oXDmgs0vYYOxd6uJPEGoan5n3V3A00vR?=
 =?us-ascii?Q?q1ia4rQ/HadpbnlmbfVCFgmpT5Gouim3NSLLP5Na+xeYn8TFln4K87zDMRuZ?=
 =?us-ascii?Q?eFO4E263eAUq9D4k3Ao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zP+NWvkV7i79WjSseLtkhcxKrs7/wDB7ZgJC02F0fJGoO8NFrkssGPT+GPTD?=
 =?us-ascii?Q?RxBq8PgzzAJbi35rlDcchTItGiy7t2ubolVpBXo61L7ETVl0AcT/D9Uq4VO8?=
 =?us-ascii?Q?5E9PxTf03XgFWtUtwARWA+vT5rkdnmGfKaHidPND16gYnYS0OPKMHbjIeHNC?=
 =?us-ascii?Q?EdYklwqtbGbsqB7lKaR0sxx3T9eCzKInQUcpmBdj+2f+FnQDOeDRK+aOhcX+?=
 =?us-ascii?Q?J8loruejK7jiykiBAFdBguZ73suKDHrg4CsLJg0BT4T+/pbgUYuXrh5inEiJ?=
 =?us-ascii?Q?QMeiAd/rHUWyJgzo7SavjnEFf+ao9msD5A7JR1pIxPgQ3uL7RUGPFtbDThGT?=
 =?us-ascii?Q?iJ9XDZeA18hcA0KYt10CeP8LEWyiQd+raRtYDVc5VLUssZSL6yJeVzDvf8aL?=
 =?us-ascii?Q?llMtYpT5TjAj8QYCZ+1LUIf6Efqw0YerL8n760YK/ytRUESisLkD6QM+IoE/?=
 =?us-ascii?Q?6yjvJF00W7UZGJFgjQPZRqpyPTCzBFQb3MZbu/Hwf4EMr9Vg6stw78dhU1d9?=
 =?us-ascii?Q?rTLZ1wm9WA0Y0az+SWc6exDhTd5Y/Qw25QHwQURen7+v6VBV/zAPxB1QAdx3?=
 =?us-ascii?Q?B0/VHZg2Wb60rqfieeFrnkUdgEglxM3+/gzPN2NBkn7QuaDCE7wUpDDI04by?=
 =?us-ascii?Q?fgzpSjpdRgLEGukH6AeLBwP8Eom9ErhjpK3WO7bDFcIKUZMNUxkHdoYU9+UN?=
 =?us-ascii?Q?z0MXDsj+sw80+mO8KDZUzIBGRE8HflboeDgO5JP1+e1wgG4i18iPxIt5j7zL?=
 =?us-ascii?Q?7pGmOonZA9VfIw678kymOBSH8iYOVzM1qVFYkFyWnDjXnE9TzoxRKZ2fckPi?=
 =?us-ascii?Q?VNrIJ2USlcokecJan+V12Py5hnpgBDzjkorAOJo5bINMION1UzVYhymX3jmp?=
 =?us-ascii?Q?ZbYFTx2Sezf8WAID3v7rw6XhZKtAjV+xds4t9t/e/MVm4D6JCzLHE9xlVYt8?=
 =?us-ascii?Q?bjr8fz/be4xaT9Vr9YdQ+Lk4F1KCXEfVjiJrtuviteK2eo4LNMP094L/8gWG?=
 =?us-ascii?Q?iI+6DomIIyBDisGMLx1hX/m92OUjo9VchPPLPz1tKDl9Z87lQxNP3kIxSnt1?=
 =?us-ascii?Q?Ko6R2u60x3MrP989dFO88oLMLCfzGwfOhD8Ex6bdg4rfAKQzDbtj/ZP7Z6hO?=
 =?us-ascii?Q?er0pB+IlTwBJ+bGUYG80aONy/HGWJ/d9Z5OOIIyuabmRoAG1LchCwL9nsx17?=
 =?us-ascii?Q?REyU1UdhhQwe+PWR6Yc+FGUP+iIPV6Wv3fLbgtKfY2ZoRQau8Sic/c4UWdw7?=
 =?us-ascii?Q?Fo7MtEQJwYmoNeXk6Lth/+dFdTeTAsMAvrAWQYX5Vp61XForWi7NaxKQShpY?=
 =?us-ascii?Q?SqgZDpjh527BEJl0/TjWHK4Ge23AZCgZ8IGQqi/gijF5eWvPUKywZ5sEc3Nd?=
 =?us-ascii?Q?1KezKbr2pHAUZvD7NN4bS6IPS9d693TU7kc25C8KN94UcIpn84K2bwVxhNzD?=
 =?us-ascii?Q?nA2vwmW0JcE8hIyPxvCVI4C/VtaIRxSzCZfCsiJC+Aw53O201zCM7p0TK6sR?=
 =?us-ascii?Q?F1R8/pvSGpzwRyEUiSAS7CbwAOCMFlLJ5MhMIzHYryHhA0IdAGdzF5RhKPO3?=
 =?us-ascii?Q?dajhg2ROimE1iIxcR3VnvZ9hQPeZeYDbQL9yHxVtaxLHZjSnxl/LYiidrQ4l?=
 =?us-ascii?Q?zZZU6baNoAaoEJbuSjRfUjVnawlPdhj16ZNDnqA1scC2DbSofMKKqPl12VaG?=
 =?us-ascii?Q?jIAUgYrYO9C5gK0nNkd6yZAC5eBrnzxHal0ZNTZs1f9Io0SlwfWN11lrY2Lc?=
 =?us-ascii?Q?BovAI1hnqewG2sWZ7StoKTlg8EXanto=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/hEUYaH7rDa5tJtRKEN5tuRbWRv3dr9TcAwXRHHkcMpXJPFlDpCAY8Kodj9hVXPVKyW/XB/ywakU4DUOM0QcwWjUFy0graPzLXMH7Q7GudNxjAAkeVtVdXfPskq5gY/7In81YOCxVUcMsH/l/GOPy508Mb4/pD8zt9/QurVPERJXXSnAjxvWePQopLdE5NaXlV2ZT+39x52a6/HvcfhKiZ5oJ5I3TXVH16e9WJde9bjd3xFlUxQ2FS+wfimzYXQpFkl5TA7CPZkcYKPl5oqeeU/vaSEEi9ZEz+XQGsUgZskQV9sC1+UXsI+feJQKmcTZ1WiYhzAQqG6fM50q+VEmh/LrByT2B+Sq5W7+rwkbQQqToC85QRpD4tr+LiShc+/QY2SOopmOsPXZkjyEtxM7rJf6uQpW78wZ6cTTwq53EoU/8zRlojZHiKMNtChsI8v55EAeGtsQOPLwXRbX2ySMnLbEajSQXAQpokvrevieIjDZSbEBI/LPJWApnKAoPItaQS0s/QytS7FPw0uyHe+1mTyvdx0r4g5S6bkrvUK5571hbewBX1PsR9MQI+NhK4oepa69bL1CYtCBShDKEEVNMpPd+NIjeoDwfrEccWyJxe0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884ae578-4569-425d-eb91-08de738f3329
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 10:26:41.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xa+4O16/q0PP7TPzpBtqWJwSW+GxHY2kLQ8dtulpcAZ7xvmIyeOZ69Qob28JuRhxCY9vARQTSWskfM4ok0LhtYC73lEMYU5QsMlznxB5Bx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7415
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602240085
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699d7ce7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=07d9gI8wAAAA:8 a=Z4Rwk6OoAAAA:8 a=PuvxfXWCAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=37rDS-QxAAAA:8 a=crXs_MzoAVXMaapXFGwA:9 a=CjuIK1q_8ugA:10
 a=e2CUPOnPG4QKp8I52DXD:22 a=HkZW87K1Qel5hWWM3VKY:22 a=uAr15Ul7AJ1q7o2wzYQp:22
 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: buc-QJMJfae7AUPal2NRVBOlW-HD7tqS
X-Proofpoint-GUID: buc-QJMJfae7AUPal2NRVBOlW-HD7tqS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA4NSBTYWx0ZWRfX6sR9qq72T5si
 oSwOMRspNgqC7VVAOhnqZve3vB//BMqEsP7hsDTqZ/QIZuMmeBaZ7N94XALqUAOp0IFtLmSzaA0
 OivFxyLzRCYVtH1NtfH5eKhyuSKKFwdV5ObXrkVaYv+cPZv332nuaQoxcZ7LaPEsr0Zf8oo4bt4
 KYvTpJ5rd98HPylr3V8AKI+oQuC669LDiVwQ0K3Gg8oSnUVaQ+g+4BXpTWnkSkgQqksdus0ZScN
 kQ/c3jPWcUf892mOLclEkVhZKc5w1H4azE3S2WKdNCYY3sHdyrYjCpPQaL6Wj+bFbj/jGrQAuND
 WB4L8bKpz6lza8nNT9nyjgfNHCCVUa9zYyP98S75ulsTIYjavJMdx2CZJX/R96ibuqPVRsdh+su
 WBPSaKkHFC4F5WOs/em4n5lgpSz5VmKrhTvGnLYDlhIpALK5WgQwFXGynwE/Pf0vf7ER5ZnsXNl
 1ZicKvXlv+bgfSrwe6EtOBVeesZB8J1NuROB52ho=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D8FD4000D
X-Stat-Signature: kz9pqyttwp98wb6abbqxp7pestgaim7o
X-HE-Tag: 1771928824-370271
X-HE-Meta: U2FsdGVkX19JZBWNWbB3HjDvnGAAXiXMc/6LR6de+MJGO8CcS4BwI9UX1o8wDr8QT+EjnZuhKLZv9LbqwUQrr5WSHQOWw/OWuc7ZMYP29YYRe3eu2PzyhoBNCi6N6K7ptNkAmB9F9JaSu/SWGjYhJdKyxuI17mpX3pCs1jH0TA96Gsb71cLP+xyrxQ6/7UhBIbuLz72zFfrOsTxcUH+1Bx3lTiXVMAcYRKuCFVCTU+82rWuZT26yG5bVaEHrnTCDyw9ewl+bsYvW7Ko8rxyhP72FTPYUY4R6sNT039RCEOfimBQwCgthUhpfw7k7XIxrSmS8q4rf3HBaA5QeTsMqJmkA5VWXFORbFyOdL6SlD48zZUu3QZe+/t1WVC0ISFmTjOK9sllu6kcl0tU3v+xHL8GHHxXi7e39Pn9C/a40nKkF6tiAZh2n02fHJsRvN4I1F4uCb3SibzfTKilCvBkYA+bE+wrK1Ih/IQM3oNZSJge9Jbltnc+JD4flZs3zfMajg1LERKGySkTYfXVv7bsEHHzf58cMIG8dq5srri30znbgUdngIlSKAjbymyXsl09OJLcCAjgoN3+r9u1hNFf3ZBaJfCOW1930AGMSu/lhHPIg0eQSyBd/A1cGgzLZzLYKwiFItGwxeNCbpBkXa4H5qDlLc1o5E5a8c2c+aWyyfI73lKcNqw1Fg0Zxl+03QDek8PU0+37Nu302W5aybtJtC7MLel6Rf+oz6y7huKC49D4PR+q3V0LDQLPQEqcT924JEz3cl2VzHA3I8nzAyYOuDgH1EIt6LQ2YtdJujjIRIqFCqBeFOC9HW9gF/w+6q5HroZgeZzOHQj+qRJWFcnBu6nPsT88Tj4fG9HpMjMd+d50isOHsyPnlaST/GhmRUU/xin5av7pKItn9HPcSwFSV7MvEpMUesivyV95lDN+IyvTAy47IQkWwvhZtEa1cI0BfvLF52AKCJ8uYdYAvA8H
 PR3rkRxm
 OWj7afquJsO1IzVuBaQEVkboTgJ4JRaVM9XWkxRplD/qigNyfP9EjY6bSZ14Wkxf8IOtcxqHtVy9zQ/JktlvgqR96pcSpQbVES/mJQLZ5+FPTrxxrppgPDJ/P2r2KfAYb/4qqcpaEW48Z3OS/tCKFxW4ZnECHQf3mER603vXhqyqhzr/yapZr0nbdimgbc7X/OelfuzLIUPxpEdG2lTwNYrEF12SqvhPZrgBDSsJmoTJxi0V0l8KQTeiAJBCHiwsztqjOiYaIJovdQB1ee3VBfDtMabmGsQmkuNU8CYXp0KN5d9UHoumU8u1DTAaTc8O4FC+SbQF8tr+gh6vt9pQkskjj/85qDpv65rOsP/FVgkfBLvgQ6aIP23CAbM2O99xbAJfY4Y0/XUa0ux1mldXLEysgj1Ogm36bZmyPrMtJF/YNmS7k1w9hnWG3k3nWBq2J05Qw+n8udSWuKy2ORDriqozMzPyttbDIMmjMimd+43ut+Ifsks6/Z6EfVMKWGOi2E/eYdKsysA+s3qLXDbtmdub6M7DMDcwfLZARCP6baadJIdyRwPFJ3TyCUCIF9Kf78v0BjV1GQpX8eWMZvWflAb7oRb22Bd9v5Ke0yiiw1M3GSb6ivXK9rD2sraX/lUU0rX655nIWkRqGoz4ZYCSTOCuC4hE0ym47EoC0akUfkVScY+Lp3GXu0ZRyKOESBAjTv+cvAREDZCxU9y8XRwO3rfxi/b2F7O3PMVRRvmv9xr1vnPInApsQlK61XVup+LmBk/skwSHQ5h/0C9x5HllxE3u9tbKtfW26P8hrZ9XdIiW9l+No6HzxmSFui0AYanLugGpZzwKuAQ9qFaab+IwY7QghbAIeqsPz+OYUlPIEUbuqFCGjBpt8aXGfKC0PFp+KsBzidkzan+feAHUpFJs1sMtRFj/F3fSYBucDgnawuQseEcBt52M5WmE0n6bDfI9BXH/fC+0wXdYxKzbEfmSxD3exrwha
 fw/bXHpR
 oh8Iuj6jbdSdirHrMHFE+4P3gjLG/7LO9kopFzb6l5JD82ZoddaLtO0miKzQUHa8/WhjoFek1oU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:30:34PM -0800, Kees Cook wrote:
> As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
> arrays, which may also have "counted_by" annotations:
>
> 	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
>
> becomes:
>
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
>
> The internal use of __flex_counter() allows for automatically setting
> the counter member of a struct's flexible array member when it has
> been annotated with __counted_by(), avoiding any missed early size
> initializations while __counted_by() annotations are added to the
> kernel. Additionally, this also checks for "too large" allocations based
> on the type size of the counter variable. For example:
>
> 	if (count > type_max(ptr->flex_counter))
> 		fail...;
> 	size = struct_size(ptr, flex_member, count);
> 	ptr = kmalloc(size, gfp);
> 	ptr->flex_counter = count;
>
> becomes (n.b. unchanged from earlier example):
>
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> 	ptr->flex_count = count;
>
> Note that manual initialization of the flexible array counter is still
> required (at some point) after allocation as not all compiler versions
> support the __counted_by annotation yet. But doing it internally makes
> sure they cannot be missed when __counted_by _is_ available, meaning
> that the bounds checker will not trip due to the lack of "early enough"
> initializations that used to work before enabling the stricter bounds
> checking. For example:
>
> 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> 	fill(ptr->flex, count);
> 	ptr->flex_count = count;
>
> This works correctly before adding a __counted_by annotation (since
> nothing is checking ptr->flex accesses against ptr->flex_count). After
> adding the annotation, the bounds sanitizer would trip during fill()
> because ptr->flex_count wasn't set yet. But with kmalloc_flex() setting
> ptr->flex_count internally at allocation time, the existing code works
> without needing to move the ptr->flex_count assignment before the call
> to fill(). (This has been a stumbling block for __counted_by adoption.)
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: <workflows@vger.kernel.org>
> Cc: <linux-doc@vger.kernel.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  Documentation/process/deprecated.rst |  7 ++++
>  include/linux/slab.h                 | 48 ++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
>
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 91c628fa2d59..fed56864d036 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -387,6 +387,7 @@ allocations. For example, these open coded assignments::
>  	ptr = kzalloc(sizeof(*ptr), gfp);
>  	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
>  	ptr = kcalloc(count, sizeof(*ptr), gfp);
> +	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
>  	ptr = kmalloc(sizeof(struct foo, gfp);
>
>  become, respectively::
> @@ -395,4 +396,10 @@ become, respectively::
>  	ptr = kzalloc_obj(*ptr, gfp);
>  	ptr = kmalloc_objs(*ptr, count, gfp);
>  	ptr = kzalloc_objs(*ptr, count, gfp);
> +	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
>  	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> +
> +If `ptr->flex_member` is annotated with __counted_by(), the allocation
> +will automatically fail if `count` is larger than the maximum
> +representable value that can be stored in the counter member associated
> +with `flex_member`.
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 726457daedbd..2656ea610b68 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -982,6 +982,33 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
>  	(TYPE *)KMALLOC(__obj_size, GFP);				\
>  })
>
> +/**
> + * __alloc_flex - Allocate an object that has a trailing flexible array
> + * @KMALLOC: kmalloc wrapper function to use for allocation.
> + * @GFP: GFP flags for the allocation.
> + * @TYPE: type of structure to allocate space for.
> + * @FAM: The name of the flexible array member of @TYPE structure.
> + * @COUNT: how many @FAM elements to allocate space for.
> + *
> + * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
> + * @FAM elements, or NULL on failure or if @COUNT cannot be represented
> + * by the member of @TYPE that counts the @FAM elements (annotated via
> + * __counted_by()).
> + */
> +#define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
> +({									\
> +	const size_t __count = (COUNT);					\
> +	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
> +	TYPE *__obj_ptr;						\
> +	if (WARN_ON_ONCE(overflows_flex_counter_type(TYPE, FAM,	__count))) \
> +		__obj_ptr = NULL;					\

I wonder if this is correct? Because overflows_flex_counter_type() is:

#define overflows_flex_counter_type(TYPE, FAM, COUNT)		\
	(!overflows_type(COUNT, typeof_flex_counter(((TYPE *)NULL)->FAM)))

I.e. returns true if overflows_type() returns false, and whose comment states:

 * Returns: true if @COUNT can be represented in the @FAM's counter. When
 * @FAM is not annotated with __counted_by(), always returns true.

So we warn on when the @COUNT _can_ be represented in @FAM's counter?

I'm seeing the warning for the following:

struct multi_remaps {
	unsigned int nr, cap;
	long offsets[] __counted_by(cap);
};
...
unsigned int cap;
...
multi = kmalloc_flex(*multi, offsets, cap, gfp);

Surely that ! should not be there?

Annnd now I typed that I realise that Linus fixed this up in mainline and I was
working with a stale version of this file :))

Anyway, I see that the comment isn't fixed up, so I think that's something we
should patch, like:

 * Returns: true if @COUNT can be represented in the @FAM's counter. When
 * @FAM is not annotated with __counted_by(), always returns true.

->

 * Returns: true if @COUNT cannot be represented in the @FAM's counter. When
 * @FAM is not annotated with __counted_by(), always returns false.

Cheers, Lorenzo


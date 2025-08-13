Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3969EC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0965900092; Wed, 13 Aug 2025 10:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE162900088; Wed, 13 Aug 2025 10:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA905900092; Wed, 13 Aug 2025 10:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A64B5900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:10:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67D831173E9
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:10:56 +0000 (UTC)
X-FDA: 83771920512.14.2ADBA88
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA8A31A0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:10:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I2nUSOHm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=naOFVodZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755094253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdP9/IqGrxrEHEKTbggfBI7LwjwQ4lvhqtfMHMPH0I0=;
	b=y52WWkq7TzcSJWrL9ZRbAzfcXzsHMqO1YWs/gTZPHJtWCI6Rie44XSRO1NlfRCK/qAC7jY
	6sOZAoADAwt3NwSF4HndmZIb7dFLIhsP0+1F40mNCnplo962B+xKTTsJf8VeqNaM/stA3x
	K2me9qb6bHjM+EzIkQYaofXvJ1iDJ8g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755094253; a=rsa-sha256;
	cv=pass;
	b=mX+vqzUJDM4LY5UaVgM7TpaGOhgMmJkJmlB/blgj4P5xksXT6CgIxWqUdZlBjZzIp05fI4
	R5jhGu5paMRSZtTkH8CWWKDQ/Pa3z0auXnw9h6czMuWaWxmKj1XsrCLmeJvSuG58cPIa1v
	/y64d8tVh4N9dSQqaGHraMKMPbxoWl4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I2nUSOHm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=naOFVodZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDNUnv002205;
	Wed, 13 Aug 2025 14:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tdP9/IqGrxrEHEKTbg
	gfBI7LwjwQ4lvhqtfMHMPH0I0=; b=I2nUSOHmfJMoQbZYUib+Q5RpcSdV1TW2Na
	Vj7sITguPQ+jUcr8gCc+z5vnOwOJsg1MR6fZBYgpLgINiLa5PR3HwoscL8zOlhVA
	MXAELZhnyFyhPJmiORgdJVfn2Xl8YyPE7/g+wt7jwXXIHtwQyNZAzmcomLCKJWOI
	QIfU040b4QUFKntdowA1AX4eVBhtuzP/3QqrAGeIo3aRMOQ19NvIdz5c8LVDSSsI
	4ObLpiP011Uyiv/AfTiAoTHnXZbBYOyp9Nfqxh+WdSymi4DqAOUh2o28YBPcIaaO
	I6JYATPgo90VcUer9aq/l5u80Kc8HOq/YkOIOuYkSqQOkmi7R0ZA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dqh7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:10:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDbS6l009858;
	Wed, 13 Aug 2025 14:10:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvshs28d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 14:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZiCQ6VDC/j/Jw1f+W95CeLOq1IR2qumsC+9GK59acvrxdm+w4Sw1556DDEOtRv1BbIsLyCKKZPuuy0H1jsItyJvb13k9F1yTFlhHucsSVQVkTasiwUwru0wmVs5gimFF9qVQ9m1Hb56EMG2ecODIBAqRN/JWPvCJa8ujOWLuD2qdEfmR3M8oYl371SPh4PDfp11wMNZOUfbUbQgreUIKGdPfPf0YAZJztwlbHsZMMUPljHsWydGeXTsbzVdsL9lmRqnMY/uz9PVQSnCcRNGa/DKMCJ6cDlsBxyCCYh1L68yR8qMKGqf5StsBhfu0JQLgQX+zKArQj4aNYOnfuAhQdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdP9/IqGrxrEHEKTbggfBI7LwjwQ4lvhqtfMHMPH0I0=;
 b=Pzmv4VycuB3GcNLm9qYQkLBEF4+2RoGp8KqO6slW2a+E+pXa3fhw0jKq7mi2DVXLauhg19sZoRwFiXRVPwJUMkgbjU09sY14kr4305y2O3xJ4C9ehl6NsI5mKRCwiq3TMB+RSaCjS1iVqt8ncW0SaTwvOfryzjaLmZdiPX7vopspEU+BAR8D5PXV1gcZiaeLSZ8wSPMXpSdszfQp0CPyLomKR/3i1DO++XU6p/SIQjzo+CBfE2YyubLusJh0hfqCvGIcg5yVcsun9h4HCJn6EG/1lNvMHekTMxbAq5qssy/Z2PMRokki1/z+D3mkKBF9mEsIxcfmHn5viNFhdU+ccA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdP9/IqGrxrEHEKTbggfBI7LwjwQ4lvhqtfMHMPH0I0=;
 b=naOFVodZzqTVZrREF1pxXwxZz8nIKRf3G+nbaJ0jI/Tw4BO2gselHWH/h0q3Ti6B5UDlFzDDYhUpeJkpFzGX89eTCEZz792/ek54xV82hrSOxrRf6p3tBiyPiB1L2zxwN+yxMziPkdgXP/Auza9gUPL/q0wPwsWB9X8TSU/wT/Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Wed, 13 Aug
 2025 14:10:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 14:10:18 +0000
Date: Wed, 13 Aug 2025 15:10:16 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 04/10] mm: convert arch-specific code to mm_flags_*()
 accessors
Message-ID: <f8ff8fe9-0c89-4742-bf52-d31319d948c1@lucifer.local>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0276.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af630cd-28f9-4336-8154-08ddda732226
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hERmONdgWbl72FNDU7jpV9AsF/akGMSDErZgfH1338A9edz025syln52SW+E?=
 =?us-ascii?Q?VBo4dLl7erbUTjiFHgIa0drxMcegKw6DSkspJuxAQijDkIT/3DYZn5RlptVR?=
 =?us-ascii?Q?PR6f+daGp5mUyykY1gm49ekidF/OsT0zpKPCZuDkWMA+SyLEjNCOvmiO+j1M?=
 =?us-ascii?Q?apaOyGcoZb2nHnCyBRZQ4KRMjEXzdXlpOM/b5Pl0Ksw4iGek/i6TLHpgFTI8?=
 =?us-ascii?Q?rdU8ASFG2fDFP21bHrbgjI/I362lP9rdUDGoOj2cTry990+x4/iw7ruYQQjd?=
 =?us-ascii?Q?YeU8XUU59+/0gSDU6jW0YVH8fQeQ1ye97+OXxoCaTUtbhCj9tzRDh3zhLqIm?=
 =?us-ascii?Q?K3Om8Xj2fP6xDDZ0C4DGWnuosQP68TQ5li9FoBW+Dp7HHY6RTWNP1cxQtaV8?=
 =?us-ascii?Q?42jPFvXjm8HZTAoNFvFmTnS1hDzeM84cuVFVFzibGR3H86t35l9533p8E1v1?=
 =?us-ascii?Q?4kuMJmbQHj/lDcsgL/StOZDzCe0S5Fa+/BuxmkFgeK3cP0xrdMmwOS3W8B6Y?=
 =?us-ascii?Q?TghLMViebQ/KnazU9B0v10s9/btHsoTCYPffOv8IJAoEjdX9KanrNNgxGwyl?=
 =?us-ascii?Q?Lx+3ObwBb7sOmXaUf8bpZcp+axP3QdtIvs8e8SZCdxwgNCEqKkRC1loHcVAF?=
 =?us-ascii?Q?BPNoHqLL6lUh37RYg/8u2q3OxBhePXGyYod0WYm4uZJ0JHSYa4Rdd/ZA5RPN?=
 =?us-ascii?Q?zjWEH69EYW+59AtzqpagoXmNtwsRFxoXkyJG6LffgDhB8i33cLRLtV0Dhkr0?=
 =?us-ascii?Q?0IM9HUtskGHHgMF5CVdCYMtLuSmXYcR2NAgWZuSqIm1BklEZXG+E6/G0/Ifg?=
 =?us-ascii?Q?pET+W02mcUtLR8EOgrbvxhRHFzW8MPtzzBDsIXskTWtLV29ozu/Turdx7K4z?=
 =?us-ascii?Q?L0ivrT6PofNtmE0pllTK8JtUJ6Bj8Z3M20nYI3uPt5OHb7s+09+o7GvN3bj0?=
 =?us-ascii?Q?QN8WGz74xw4EKZm8g82g+/YWr50GtrhXwbkpx0XPusSfZd+S72Rc+7PiLWw+?=
 =?us-ascii?Q?gBghXUNJJuibXgS8ZutsWOn7ih3tgR10uuEQ9xqBzcDIpoRk4hFcENh+lnzG?=
 =?us-ascii?Q?cbXlDFSQ3mMxRiGNzGrEa8xnYg7YvlJC32BZmI5dTaoc++8qQM6VV4rnmV8h?=
 =?us-ascii?Q?/wM31znsF+gBZXyFqNV4fA/xCt1qx1VvJKzVg99qw4JIGy5y2SVstDUly3OD?=
 =?us-ascii?Q?ltkShNCjL+Fmr2qFt/Qfj2TYUYMuw2ZBvwW2sTrpwp8dqBi1V0Yj/TYfPzxF?=
 =?us-ascii?Q?ERyg42xivVI9z6SxehMdZSed0EH3zIE9soM3DCYTqWiTnqQ6kL4Is+dcvRhI?=
 =?us-ascii?Q?vo73dS0F1gBlvtdqhqx1E4ZpdJMqSc0wlso3gLkSMO50DNxr62RvXT/i0aYO?=
 =?us-ascii?Q?dALdwoorncq6Dox4i3lec/tZnn64nASEWXaJ7drfi/IWkaqakclO8zThntSa?=
 =?us-ascii?Q?eUBQpylhCtQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jN/eW21bcsehPlvC8LvqrTZXVabtud+M6G+45JzL93cIejBRGrzc6twPfFm7?=
 =?us-ascii?Q?zhunxcclM1DC7Lk4s3uUBTetJBcYjBbLMNcgWlOsDfrNNekntfU06qOTZtBQ?=
 =?us-ascii?Q?4cp0uBEyWSWzP3/GlDGRahGQkmyrwEu+8lWU9VSFUkt20zw8TsWPkZ62c/WU?=
 =?us-ascii?Q?0CqmFP6jDvCESlgfsJSLW4C1kGz6DYoQz7VOZJjmW0/WdxGxXZM9tvooSmCS?=
 =?us-ascii?Q?5ZBUTPxuHnZiLQIIMAFRZQotVnoYWWWRA6Gcn4M1H7STIN8rHuhJjmGHo1rC?=
 =?us-ascii?Q?7GwdZ6xdwriVnyHoJWy86W1pvCyGbPFukKk8h9YEPdaVdkbEv2fLuAjjko5n?=
 =?us-ascii?Q?hQfIWdkrb7GlVZb18B5wYD2PmSvAlPEgE/POdcHQKSsafDmP9EgAI7KHsUtW?=
 =?us-ascii?Q?XfnCsXCl+CuARmTlAmppXTbQ9qY7J3GFdmmHbkamoCE6WmQ/JzOP6B9q6RTG?=
 =?us-ascii?Q?Rs8NTGYl0p2MKOAIZVTX+CxJlcCIDS//4K/0GKsiApRhd6YvyaKby1er0go6?=
 =?us-ascii?Q?1nm4YNzauiiraxlH8+QOcds3h1BBa0exjfRi6J769YZi+KQ1Unan0JTn8dKk?=
 =?us-ascii?Q?OcLJmQCqWWDwfOqW8QucGmeogiiMQtAnOcCoV/edgwLdah+9EMSMin8pSSrR?=
 =?us-ascii?Q?0NHGpxDparhonmOoNXUkh63kEXjN1pGa/+vaupeA4/s328pe1D2XERtOINbD?=
 =?us-ascii?Q?xG8D6HKL9vnQj+IYj5QO2ZueVH3Lc4yBjlyzWCG2yFdWyvQ9iOVVcDZSlriQ?=
 =?us-ascii?Q?uPQYZw8u52zsBQBfuqcnzoZj35nDnCcBhz8pm7Ol6gPYh/LaNikQ8vwPFR74?=
 =?us-ascii?Q?ZXgax3nG9IaMktb/u+llmif5oDTN2evQwFV4hYLi/6lYM3jTxhY1fKa/+Rae?=
 =?us-ascii?Q?kAgnJ9DfRmjw1mJ2ZrDfJFwHwkK4YFNSfkQ3CDCjicdAuGhPxbLBpVuREIgX?=
 =?us-ascii?Q?ZnGd7S+u8NyeY4120FAftDiRHpxGjDGdeLcLmz7nX1YaP0SPo7YQYqeIOqZi?=
 =?us-ascii?Q?qfjUhubEbRyMzl1vjx9qqSiUP9Wkvwe3QDBrWRrwTW4W98cEPyi7iidwzRMn?=
 =?us-ascii?Q?TwIg2qocSmq85uDcU30A55jbkzT6rqRcu3byko389D4mmKoXEG7bg2qeS5Mw?=
 =?us-ascii?Q?fEnvbvYFT/a8OqvAId8Zd9lSLhutYznTkT/Tnf6xSzScc6tN6DAQ2cSFvCEX?=
 =?us-ascii?Q?zu4N6JBzxlc2mIkdfutaf7u9qfRGKhUPhKSJoZZ6WT5eUZ+bCUSBNSWjLioe?=
 =?us-ascii?Q?SuOp9ItNMVlw4aJBE6RopIj6lgciGEQEKBHjpPJdvd9u6jejjaDS9fGzL5vr?=
 =?us-ascii?Q?4WfRAMpTdmgKE0nKdCnYojgIRjq8mELkmJkN07VY+82vKjOBE1u5yfDaf9Lx?=
 =?us-ascii?Q?IfxX1+FGHaF3qBjM1GS0M7fLuP6LMgOrZeZ9cD7KB1QpsxK//yE3OUafAiXQ?=
 =?us-ascii?Q?iETp9qp/X+ip64nsDyzFaB79iSTbrrL80u3qBq36o3b9cLNZxwm89lpUaFhl?=
 =?us-ascii?Q?vVHAgm6ImnPkQ0ERGneHQXmd7ofhLesnEfRXzgjg0lf0Kvhx+wAh4NPdS+yj?=
 =?us-ascii?Q?cbl9Aju0MpkWMKXTtD8/WGXo/6eK14GEvIJPwXdsdXY2R8ndAD/KD6h0odj3?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wMBO8w13dh2PZ0GIsVJnbGbIqRiwV52/CLZ3M0tLKQCadeC6eboptUo8gbGN4gtaYymrSMvoX0cubQ6Ib2fn4oxbedUiPOAfHFATXE8BOtKxxMhIBWSCO7saMRip8tEPpfBrwFqT0kaves0lT+lllmua42wXXuT/NXxi9wNkCXuXgkF83Vcu0AUOJgp7QklIreKHNTJz3MwJ9gNjXuOiTkYVukRgnhHwVzWJlh8FVFhmLfjSEfjEeEDxpsBAAWsgGIedpjBP8IYIqAsvC9+2jpPICwsPKgFn+McL8eJvcwbElarhZ6EtZSWxL7qt/1TnfmpQoeddW8zIiRbFYLkuVTWCTQ6YcwgAh8mD9rUOtAKwnLucfrPbzBNgUMgG/Pi9CETl9cNIkx8W6BedCe7uwqVclusazuwLnlha+/UrD7aStBTdDb6UHfNzIiTDql53UzZm8heeHaNvAGICk5qdS0apHJmgCTX2cSF07vhAPlaIh57GRZX/QyzRylCflO9cBWYE+k3CPs+Ur0Qv5QlcDjGCAzLxIiYZkmuwz5VIWi87p6uZjyMr7LtNc9gBKonQhDK85Jx9D4QXQu9gl80VPWZZrnVZl/SkEqlJrSlk0R8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af630cd-28f9-4336-8154-08ddda732226
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 14:10:18.6201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvUYIz0zdF9kVG5T24e/YICs+XO4Bw3VYkOH0DHOjsuIhT56w47QNFwjBtkkoBGdwQBLoqtFQ1UM4jftUL0u1aXsug0PP7aNTKFJBEwxP3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130133
X-Proofpoint-ORIG-GUID: JaJUtAz81SRCnmrq0ePfDQygxcYFIZdt
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689c9ccf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=XQIjbqt0cXQhyFH8yRMA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: JaJUtAz81SRCnmrq0ePfDQygxcYFIZdt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDEzMyBTYWx0ZWRfX+7khl9/t8ybB
 2TdzlYvR3J/2bYmwlQAWEHvhV8OCK15wVvL8ddXQ/UdU4+P76KLPZyVmxkpUSDzeUmGmMaMWoyh
 UBe89q2bcqBVu5npX9lAmQuWf/rCW031jWmde6KsiWvIB+sXqR2S+JH9X6X/9b2ngcvVC5GUzqf
 EyWfljueNw+CEtVfdERpOwAW1J1ELM1LfNuBC+cmgvb3c5+ltqsJmnqN6IaY5QX8coyH3Iiw9u4
 XypbjScMIooyDL4I/scMwA0vRclv5X/nb2pjIEAVArFf7OcKnxx7vyn5pZ8AfBuyw0M1ExPCMK6
 e8uQpAmffGGNhJThr+nnTmivXzfb5P8gPsX+a8aALJ9QJBuyrLUWImJKaTwJGha3KW2ihop2b2S
 5RJs0bmqB4q5yum/NyVd8Wc54J/NIg66nwOtz5smrk1JcygPCWVQrCnJawiagAF00Rs7XY2I
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA8A31A0002
X-Stat-Signature: 46q7s3h3tgg167m5pq3kiw1o8dasj7mi
X-Rspam-User: 
X-HE-Tag: 1755094252-195945
X-HE-Meta: U2FsdGVkX19//2d0itSsetWQPpihVHhp1Xb2fn2o0nQDQiTeWvtIg0C0fnuOisjVGrm6ciq5VrJxrdM5DUqEtV+v0x5acgPE6LATQVopMfsJJBjH3ylhLKN89I2NsUAhj6f3v3qvkIGx7E8s9haPhqekmke0/k3ODZGe8A/w7ZRse4f4faN2mUhVCh7GJAa52XVGFZkWmQlpky8wWf9JGXh1KW3ZLZ0cQnv8uLugyKUc3xxwwuCo7lLd4h15C/5rP6YDcOyFYTwUXRex4nfnLmOU5Qo9bUU6Pd5gLzsvi+PdvvMVaeSqHcqWW+8QD0vJHIRplv7E1rjA4oN+BZBsiGv5n15pdEHhkVaIbwzFDgDXpTuHW8SXkt7BEAMpKAqcsAMdF2vzpMh5akzPNp7OLYIWCRpcKVPfsvBfQDRdusOEWQE1XqxhREI6kJUBDO+7Wn5tvtFJiSRMwrOEJ6zPD9/dOooVrZYiN35PRkPp93QnwJPCpBqlMQ+MW/nbapfMMEIO5hhMAIsr8Qk1ayVJoB/s0BiFEfd/rI/O6OnjtNLwlNPK3RhzxwGAANPFJ63brn/f21YsHuoCAinpn9ohdYihX9HTClw3rPU3arChvlN69uTN0AbQDN7w2Ll88iJHbEiJd2xa8fIlfWGFxo+9KCNgYBkTqkXY/4n4l89OnnAf60sHOEO4KenV1o9asBFf7YnIB+3F+j1i5UevQ3q0H4uPeXXAkZMD94xkzbf5vKRY51n8JOPIjroPKof38tmkYO4aaEDLHcLR+K5UZKRSxJfb7/9FcLcPk1d9/2Hspih48iEbgtX9C/BPuZ79vnynYEOZa1RFPIUtHqXUut02eeYjIQVHqEgV/jWv1jecLFyH/Ac8pO+zndPqPDSdol4vnV1XpJoMIGz/YpUxRUDe29xkMFhEk08es1fctAbBwOcP/aQVzERc0OLsu/rGgs8bWGuJ7HJ8/CrHTAUV3FB
 AgnOT4go
 Bz6g1YcGtPN71lOg0i7L/fjIJuC5jpgnm4Z/qR6y8SrOq07mfvewzePN0tkoIzQgGXZeW3gBAPNhdaKmt/qy04JJvq2dStXYMZz2Hne9FsFEGCyqgyMfeXI9CzsslG56b2mi2gz0NuhILSP95vJlMn18i4axmU4Z1DrS3bBPIuunGl0uIR/1pq0GhvHPyyJXflpsookw3DrqO09gV7ySkwRx6NZxFgFb6TitQQLZP13up2SI/KXf9ONw/+Lk68ORaUmmtaHlKxWy82gPYk81AzyI06pFC1C/7Iex++9jD2a3llLiaaFcAqqnSSvamaJydSlAZHx1Vu77DhCFCPlXf3XzmL9mwW+UDcGrzgiX4JywnvsLZKKhAbqCMy3EgSG/LLcLLH2xcdk7skDA7Z0SCyBIHwdJMTDDkLGJ3qe9NVwqAAwOOd+OgFfxUQxIOVyXBZC7OwUcEo6suK133lcEllz/m4IGy92tLhEU5ixDC8z62xsPXtTPmNX61lmH8tQTOR/GWp8NldsTBZp6173UivDXw+bexfjZBhMeCRkIiqG63sVcPJzOc1u9oLkKA7aJkfQuu8wHUjjtpChYnBdWOGEU2fH8OIYCFpkKtWTCFI9GDOviJyuBcQuKfzpphAD0GMDeLBg2hoy1nu6JVDUGb6bMv6PMzxuSKgf7DP+hdbJLvEL01d6f5wBEUPDLBxakSRshIS1itLRmQ6SkNME/7sYU4PbUttKzKkUUvxoZDUJElkm9hum+PCdb+CeYh0c6vJv9njPETUoUK0WUQ11PWi6AJjlSQEonwGbbx1/B7uDw4R9EuEpCkKSd2OgLSfYNM1xe+mHtsJVJZBcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

One very small fix for this, I typo'd the function name... :)

Cheers, Lorenzo

----8<----
From c2f9bc16a4ad705ac05571ac7b825d8aac5849d4 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Wed, 13 Aug 2025 15:08:36 +0100
Subject: [PATCH] fix typo

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508132154.feFNDPyq-lkp@intel.com/
---
 arch/s390/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index c884b580eb5e..547104ccc22a 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -185,7 +185,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 		mm_flags_clear(MMF_TOPDOWN, mm);
 	} else {
 		mm->mmap_base = mmap_base(random_factor, rlim_stack);
-		mm_flag_set(MMF_TOPDOWN, mm);
+		mm_flags_set(MMF_TOPDOWN, mm);
 	}
 }

--
2.50.1


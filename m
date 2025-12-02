Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE2ECFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A35B6B0093; Tue,  2 Dec 2025 05:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B2D6B0095; Tue,  2 Dec 2025 05:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442EB6B0096; Tue,  2 Dec 2025 05:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 343E96B0093
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:19:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC8A71405AC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:19:17 +0000 (UTC)
X-FDA: 84174133554.22.33B6BD1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8CDB018000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:19:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="h/4WOiUy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V3lp30Ay;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TChlMhSbCX2cgc04WD7DjEa72jyh9HhlSwfztyyDFDI=;
	b=u9+yMXP0sx46769Il8i8By/yBwOF1beonVDfFjvZ3HMKZhWUx/8dHnqAxtbgfGScFw1+oa
	dFX1+8ye2i3TmZpijlwDbBinnvcexwk3hDXPJ+Y6gRcu5f/p+qERMXIp+54USds8UBpQVt
	by0huGveXMBtFbIIZ/0zdSQ0nz1eJU4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764670754; a=rsa-sha256;
	cv=pass;
	b=4BSdlug5uewTzsEgqyUq+i7H1bgo21nQvIGNACFGVmv1xC7/nrBBwkHh4xuA1GBDEU08pb
	ESNxY3zqXnbf7SLXorH3BmIboAv1rWyXmqYwa2LDpH9LCILAKT7U/HFZagfJb7ZO8D7/8G
	uvtGpW5gH+vgikcFsmN3KMa+9pRP00U=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="h/4WOiUy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V3lp30Ay;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B21NELw3432443;
	Tue, 2 Dec 2025 10:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TChlMhSbCX2cgc04WD
	7DjEa72jyh9HhlSwfztyyDFDI=; b=h/4WOiUyzcD+oh/zAIL6Ecmf9/cf8HY8rj
	+b8UPH9OyEi0m+34kdTPeTRo96m51DGvAWckYAVmte4xliG+ECzqGkrIWX3mBrTa
	FN1kCFVLKJlkpYj6wCYJnyogdjtsxDKDRcu18WqYYppn7sTvcN+PvpIzlZnsmwKC
	v+i4qTHBmJtFUr2DmQuwDP7ESDcmg31nYAe6hgy6BExasGjrX3YADY2mFYE0dUKy
	y2aVRtXMNcxjSRUOx4NoqvS930o0E6pi5VJd/UHknyGa8apm0TPsHqEiX+DW+7th
	UgLEvxMCYlW/s6PpalomNT7li5i6VUUO8OnsiMyVy4TaK6Aczcrw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc4rj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 10:19:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B28LQub016620;
	Tue, 2 Dec 2025 10:19:04 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq98x4ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 10:19:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER0L2AaLoqr63PMUss4mNAE0WxHKl9cevwzLZ+iDhQzULMVmHGjwGaNrAQn0lj/2RF52e2Pb1ybnyKGwUt8Jc6RLeuOVsTsvCmS1mPbvRTpNrzcn7yVebpGHkfgK43AZ4qYxWBL4jiLVjEtCZO4fsOC6fbBSObzIT/DlBsghQnsFWjw3LK6Hxo64t8UQQ/1vOdIwAH5jEkzk7FQ567RBWWi8Juyur+WNabzPOvktY1GPSuUB2MpSwWZgYnEJoawvPQ7DOUEURxSQRq/uq+0nf5X7nsyTJqfjEOdCx7A1Xa1qO4uFsJ5n5Ljdys55mA+RJo04fzfFf7pdwDaXQlj7eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TChlMhSbCX2cgc04WD7DjEa72jyh9HhlSwfztyyDFDI=;
 b=aXboxfy91xmaiXep+5/FCSM62A8weoxLKv9g5neEpHkr19yzNr//4/smAKp9cxOAC76G7PW8dbxvABQHm5suJjxRlNUVnauLyyQgNOrmhW59VapYMMnIvRLjtavr/hnbYgscZT9HE/y1GyjE/ixeES8UrXXkkkSkL541U+BUT7dotYYCikNOz6I9Pg5mEHTSuJzORuVb7LZyd0c7BOhC26zotyt48ei30uhohtIUWNjVbqMgXLaavBazv5yGm4mvJcVwhFaSe+bZYEUcayxoGZg6Wo0Qu1UMcvmkAUYuwYibC1J97kp7zEHski87fwDJG2U7XicutM6wQJ/IyBBJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TChlMhSbCX2cgc04WD7DjEa72jyh9HhlSwfztyyDFDI=;
 b=V3lp30Ay0UKp8wtwPEjnRCNwgZ8jOZ+SgroRWiph8QRS/TjZCc8TfE9U4J7ds1pa/s5LMGHytN/6vkoPqnvBsw4JwM83eeugmpyuWfk0gYPbGK7nYiRnXY2DVztmgMkuU9nQT6qQwJT1fHu9dvx7c/AT//i4c9wGHUaPmktpDTU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6468.namprd10.prod.outlook.com (2603:10b6:930:60::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 10:18:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 10:18:58 +0000
Date: Tue, 2 Dec 2025 19:18:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: surenb@google.com, Liam.Howlett@oracle.com, atomlin@atomlin.com,
        bpf@vger.kernel.org, cl@gentwo.org, da.gomez@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-modules@vger.kernel.org, lucas.demarchi@intel.com,
        maple-tree@lists.infradead.org, mcgrof@kernel.org, petr.pavlu@suse.com,
        rcu@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev,
        samitolvanen@google.com, sidhartha.kumar@oracle.com, urezki@gmail.com,
        vbabka@suse.cz,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mm/slab: introduce kvfree_rcu_barrier_on_cache() for
 cache destruction
Message-ID: <aS69Csa1gtztGl5e@hyeyoo>
References: <CAJuCfpFTMQD6oyR_Q1ds7XL4Km7h2mmzSv4z7f5fFnQ14=+g_A@mail.gmail.com>
 <20251128113740.90129-1-harry.yoo@oracle.com>
 <be021cb8-9bff-4bfc-bc79-c84cbb3f4c4e@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be021cb8-9bff-4bfc-bc79-c84cbb3f4c4e@nvidia.com>
X-ClientProxiedBy: SE2P216CA0153.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: b774d6aa-9806-43e4-3263-08de318c34cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?derAxWAK3etc+WZHneRUK3ZSCi3Qnorhjk5hlgAGf3C2JK0SbqLo1Wpifw0D?=
 =?us-ascii?Q?jwbaSiJ1CkuU8zwX8J61CVIHkytJEYURsOS/25NkygzFoQviUEDFVyTFFrxU?=
 =?us-ascii?Q?0yXhtAXMp4X8l/5kMHkbSfDvqXyyEKh6p1gZ5DB/ybkHsT+EHqHQLGYhh6QO?=
 =?us-ascii?Q?Glz7ESso7GJp0af+8gYM58V1oJB9xYwc7zc6uPD5N/t5mA4eMZf7Ub77SVZk?=
 =?us-ascii?Q?pPWp5loU5lXTxectZdFBcqcK+x67yS8qJcyEFi/Pp0Gp3omgCHEevQWhJuA8?=
 =?us-ascii?Q?CrC4mli9A20nSetOaQC8INE5JQU8dGkCNMZpEGH65aX2H+K3ZVuj/OxBfMUy?=
 =?us-ascii?Q?9zvm9wpV8ufHOd3UllzUVxVUbne92ZV8OR4D3tTwGtt1fee3GLDAa/SefEXC?=
 =?us-ascii?Q?LalwxHepX/BPqmNyvoRK7xgPkI1mMSpVh0JjDKBE1dULqjUPncViBX9t+1pj?=
 =?us-ascii?Q?osy+rAg0Rnv1qBYqFIcoCtiWcXMBG2fNvMKZ4JgvI7hV8MlYWpl8E6+/l77i?=
 =?us-ascii?Q?b4L+SmJT5oOtn+rRp1Y9EUEDuq3R7QqOEXcpMCCND7R+Tyofq9F+IWuBY3GC?=
 =?us-ascii?Q?Lr6FOHwczGz+wih3I7IL6cJGCPmQOO2VoRBgXjZ3jN2Tp/+Dge+8kqisW3UG?=
 =?us-ascii?Q?QwZR12d4E9afwW4US/zC0khzbBxcWPk9onbPZ470vq7QhydEwz417uQ+gWgR?=
 =?us-ascii?Q?qL6lO9ty4T+mPS+JHJHUDdNxog8QtD+ZWV2iknqSlNoSDu2yLtrU4C9ijfjz?=
 =?us-ascii?Q?antDdPnEjhT1j++QaMM6q5CWN6BgGNy85zkuWAhoMPFNQ4wQTHeAAgkgoeLa?=
 =?us-ascii?Q?UIJuSl4ggNulcPAXfdHLHr0LMx+KfNXgJB5UbzrWN74KW0uN6Q1CE0wI8Mds?=
 =?us-ascii?Q?Utgy2eB7SgTYRD0a/JjEP9LNrXwe8PT5VY98UNLphcfnr43gq2XGCStQqkxa?=
 =?us-ascii?Q?EjnV2kzufaD/fLU3c7F/rcxAidjVPkQYd6bOk+kX6BnlFbZ8iJgJgl58BG37?=
 =?us-ascii?Q?sTOUWNVSm6MMTsiK3GKq2gFXDOQ/nVtEeZmHCLZyNRHzVhqaKmlBNX/OggAm?=
 =?us-ascii?Q?li+yUOFiLCS4HZ4y+iNqjy5EbgjOuPk/8geCZkddPU9d/uG7SU8ngR30j9kk?=
 =?us-ascii?Q?dOtn4UybB5RrcewQH3ErKxneNKkBohLVRbKmzLb/duw6KUYF774Bz471HuqN?=
 =?us-ascii?Q?/R/cdbQtq2DcXRQUReBrZvcF327i/438OFTJsvp8D6w9RvhkQCBykZZnyOdK?=
 =?us-ascii?Q?kx8J7VUFkg4Qb5SrJYE45PM+WicWeZVy9F8oJ+bWBZbGVojCXmnYLYT2tQQ/?=
 =?us-ascii?Q?4qCNnEeHdV/2FCOCpI34U8uaN3ue/Zu3rNUShpGq2Ne3wezRjQGKU1KXpT8a?=
 =?us-ascii?Q?9dn29ApPBAdgmH0FXu/8NRqsOc+PVuFeNTANFbTEg2f4cEqDjbKFwSuXKcfn?=
 =?us-ascii?Q?YxjiUmI+CW0GMd9t+ysdBNc6x4Q2ilpjSH9dnBULZCbQbvg6qmeMQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lv/J+BzR3Z2k+r5JX5Q7baofuGJ401eFqe+nbtvEbHVX+v+BqckZbiJqYj8y?=
 =?us-ascii?Q?iIhEypt2bkk9CMozepe1ZHLPtenQ0U/LywKpFmstHevgy7paNeBNnSXDIiOG?=
 =?us-ascii?Q?zMoIZVe440HgHvsz77427goGlNSJgJOHcnLiiDJOoUKQRe6CDRErgRfaaBe0?=
 =?us-ascii?Q?seyZ/nuNC10fgsB5tXpleZ4ASzVdCgOLc/j0oQWqtRWaFAcas13xtChavVXO?=
 =?us-ascii?Q?VtZCCr1CvzZVdqMjxGoP8TV6RDt45P8WD2eAXK7ZEL5Dq55cSrqYe0BUuVTj?=
 =?us-ascii?Q?Sa6PWMWUJ0HcrapA2zv8kl6ReSZAH2vz2RzlQOXbJGo9zte236sXqhS9jrsZ?=
 =?us-ascii?Q?N9JrfifdWis3PVw6DhacO53zAUOKOVOJZVq1KJPDznWHlitCqDU26o7ndL+F?=
 =?us-ascii?Q?6kSmaUunUyyD0y85daAwxb5/IL3S5RH0YNoh4IUqgE1Ad03id4YzTBghXxP0?=
 =?us-ascii?Q?Z/E9n+8W2fzFhsiR5dv/xvLs5gVTmgROGPuJ79UZofBDm4hRaFfC7sjKvE/X?=
 =?us-ascii?Q?nNcjVhIZixL5+kgk0MMx5euuUJJIbEnh2ORrf+8WeNDQ1OY3JqrO4tXP1OiD?=
 =?us-ascii?Q?ZomzdS3wloUZjFMcKCp9icNo75nwp8Obg7czJPIa0zmhn/ASs6Fz8oe8wkUb?=
 =?us-ascii?Q?OgJ/D3Eg+pnwVg3kB0zDZrf+1yA6Hp/KxCfqwyudbA0qmVQQXu6rVg/C5R8/?=
 =?us-ascii?Q?Pl/Mmi4R8MOcYuaLi/Jpxwjy6/AhKHmBIw0SFoEXaWOyCpPJwT86t1atbCEq?=
 =?us-ascii?Q?zflc7aa3C379PXF4DuR0pXPUL6Uj82lyaLZUuqGJKDqRsl562sb2UZRKatT4?=
 =?us-ascii?Q?gC3a0qeoEEP+E5Bhtqh6LAWWpuvlm/RP0HQlYq45mDkuw307MWjrdFr0H16r?=
 =?us-ascii?Q?sPkX6k27z/ROaTIC2PM9nUGjNqrxIvA6z3Ato8RCYZsLziIUWEsqiC5KikT6?=
 =?us-ascii?Q?4uz0FvAcveJ5KwyQPUkwHPrF9JnkaZrduGGfpZUDFj1uQrIMe0ENZVp5Yt+a?=
 =?us-ascii?Q?CSIlO76is1uegEtYl8CrqEU9OdwqqHxFr1XTa5OE2JZiNKwjZGEaUdzFscyw?=
 =?us-ascii?Q?ID6lobIVVnAUAmNCnPWJBXcdmwq3hsY+4VFNd1I7AWAt4mQ8EB6kTTdJpx+m?=
 =?us-ascii?Q?BxetMgBnzJm2HbXy4SPyYFe2IRiUZfBDFlue5axLVIk5fGkygkoxk8OFhl3b?=
 =?us-ascii?Q?migp8AuVw/JYidz15fBqbtHI3hCv7aTXJHTVjObQ6k76e1HlRMMioumd8LrD?=
 =?us-ascii?Q?tDxzpCnBd2IJ4pZl9cOKi+qQSQBiWNDyoa0Vvgat8eZowwykikZREyTFnxAG?=
 =?us-ascii?Q?kBYlZr2dbczuRBGIGMSCVPJho+d0IPKcqU8kCyiENSbP4BJ3hYekQYtQNOrV?=
 =?us-ascii?Q?sDYGFvT+ALanNJwTuk3U90N8djGfjeD1MqjuUZjJTXMI5EvL2m1iB13SL42b?=
 =?us-ascii?Q?oizJ2PNGMKCWNNKOuukYWFQjBu7ooidMF0QAISY7auhZqKwmOlXdI0lFFvP1?=
 =?us-ascii?Q?KKZEU9ZyJQP3VWh3mESUUQRQ12uBWZw5ct5Vi7MrASAxVvhEyWPBPPByRnOo?=
 =?us-ascii?Q?fwcqVLhvdgGRJ8BH/UkkcC/8aI4Cg263TeLmD7ks?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2HLm2uASgkolSG8bwkGlaQ2HtVpqqGcmU7itl0WPWhotrYnyvcXD4f/jaRPvAfVaB9MWHRY5roLdb2bpuURPOR0tMo8b8I0Il/0r0aUR9TMVZrBD7H4Rnz+U3Ayad2uxBC5prqAUL1E6qvQw/OJAyPLQruus67UnVwWF7rLdQAZSH3T6lQ60OFoN9tg9xL7am0hA6tWbtWYnpXsfIlMk4ZeTdo7zw2nla8xSsj6K8WxAoWoTYe4bvjWMgr/dm/89TMPEgtFP1VsB0zmjKrQIImRMb0lrazrjerjKzeygv2pL8MST7LF5d8ZFK5SOUCYAOCGbAQoZ/vTxyxZWgdaYio1dtGxA9iCnf80ZCl5UJ8tIAttGRInhAgJ2nAODfxxBH3UtJQNKHieEhOKAVPUCq5sKO8yUONxmeYgC9r8edcCyVWQiqm9e6Q8TkkWFddjzkCDsqNejr/MIDg0FVfzEWS6ibU/EAaCdo1bAGg5QvYXIhWH08VITsDO6QPqPzo6tjDL+yPG94zR6zfxIhLV9yr9JkqTtMGFCx1NMtmTZIZqS7e5EP0S2oqRY8nT1Iae24/1pZ1hUE+nV7q8HLbX5HJ6EmMs5YcYf5+ien9uodqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b774d6aa-9806-43e4-3263-08de318c34cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 10:18:58.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHRinZO7GSrBgbdfnSJWr2cm2qLVV00aKUdiC90O9Zs0fuEFodzMcc3B+0N4PJ+c5cPgoHHVvDyXoljRpqU5fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512020082
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=692ebd19 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=zNreyqZ7ahFSxSg8c-cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA4MiBTYWx0ZWRfX7g2s2QtOZszm
 YiBLWhMeYI3vo6JL6lVlld29tkYI53pKaXnmtkaK4uSx8ejSpzg+woj9hRj0ECXMMrV70CzeQlO
 hikS14NFvaxMU63Lie+60lRX/GtqHTvUwJGMmtwmMpDWH/E1o5S0jMwISl+gCmd26fmtnCnY0Af
 F92RZGVS44VYrsa2DcG41abeS0oPu5DfMY55rfLOUA93uzabEru4RQzjhYJu2U93xjiEMdw6xZ5
 d9r+yvWuBwmLEicyBJK6KpfcNUfyU0g8dFxYrrrBZjYxRsU9L68MeUfZtyIz5xtjyKQIc6GQM0o
 PXLiOO8mKvqC+7gfCpYmeyU1AXXN9ZrMWtURPluBPqEhrinaejke1SdhOu97HX5h9XfjmlEjOb2
 UMx4phha5Tz/r5Urmu+GN6lRo2Cyzg==
X-Proofpoint-ORIG-GUID: LRpTcMmJvzl0iYJpNLISphKcE0PA8NfI
X-Proofpoint-GUID: LRpTcMmJvzl0iYJpNLISphKcE0PA8NfI
X-Rspamd-Queue-Id: 8CDB018000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ew6benii8gj937btui3un5qaf5kmyx3f
X-HE-Tag: 1764670754-895214
X-HE-Meta: U2FsdGVkX19+je/n9NS0yvc/sX8toWwwV2WH+gVML9E9agGzYAQYiX/UuMfGuc9Pdz5g4aFWHZIT12qsGPCpukKBMt7cROUMNbiWR2gB3k2GnllqSJlJeOrkuB8f90Lojcb4A/4uvm6Yv8ovciQwjRz5iB/yW1QdTb9Eah7DxtsUYIRpS7TblSMHfZJZ/pe8GboN0DXs09/r2fdob62MVlhZlWZAvuGUBqK+5qRjpuTuwjQKM4/kq13TlcrWvnXNL6zgNJ/IduJhvc99VgDsV0Eo2iUVy3faX6SvZf9wQydKAxWUBM0wdX6in1I37dKZ3rJdnOzVxEr+tDmHfyuvoC75A7k+nV8ECTmC8P3cC/UwV3c1JoDr500OlvAQqSkSlcnbvLOBLaDa+2tfLc3Tc0kjJjRM5xlxJ0dEHkbgf2HH+ndn8S5Je/tSaxV+//bsAH4WPyySkQgURmMvCjRjLbKSLWZ8+wI4BHBIaRQx736mkCZwoDKafukF8WuAZUA8riXg/nL9qU+iAcoARS3NFmW9HxMbOJ5U7j2ZAgN+7/rnXQjXPYjWmZqdFYenkzJYKvc2N2irxLAOYGdMULZQXxZnhVEZFc7bUJmX05esk0DLj2ee1ClbAK9TgCDqgscdHXI/nIsblIsDn7kH8p40CNJ5aDCaL/bN2nGTVbGkw3SAljN1uyqIWkuyeQaeB8nWTrhFpKjZ7/okwzXifAWDPZC7S/OQgiR4XGCNI2Zw92g4gqbRiTGJDiBDzP/nT7hEqic1RJQ6UWD3pCC4Q0eusg8FHzSPxSGd94hngHJ3sfM54QawCygOLVlDxawM/C+Yn2Z8jFgXHyHN1AtYOMeoFxp3MQ4+SrcBqd1NC85ULGZFdCLG0+KfpXSGbpOo2EyDTqql+WNQ+XV1ho+82Qp7uMT2qnFqKNb6O/EU2JvEAb/B+NN70oz/jBjubQHquRKz+DNxn3o+vSqRsoMwnN5
 emINYt/r
 5t+VwqwwRtsxQUWrWAhj0Fog9jeU99RLbHrITFupe+ViFxCjzIbPEs/Qjb+Tx+9fSiV20Md/hAf7S4p5NgAAHt4fp6hCxWzWkVYlSbYyDFRVeAdApxjiqKL6yBImJu4YSliSqbg2fbGqVCHkvPY8wpXca9uuZD62yBE9JME3mvLz7xOS5zygQ6gpuj0ICOj6WEJjkHwBOvJUuxMybbhZvspgp2qmNkS+/gq6PyRlsV7UE/glzLfVf4iotafLm1Ck2cpNGN1eP92B6Q2XGWMtF2Ggvxv33KAcJOLPUbgC3Us5nnkmzdSNUAMA0XmSAi6I0MomH8rgVaBa1xbZoNDl+7aIMk73BPysQ0rpa45juliKloWyhndIspCU5LJ2yKe7U0hLJ0YsTvDxXIEKHn74cXEW3L8GpSob68GUbN3nfCbTaK6nAJX/NnpBKFwlUWGVLCP0YlpxwUtq97f8ixbhTDPZ6LhzKg8Kv7vVi8T6hhHVrlwh+yfolRWj21OJbHbpT+Rg50y7fs/32tzI9pHgM0mHAiPhXqXOkDYg0CVnnXR2td50Yp52qHefJUrDl99CulbGPl5zlWcStjxOwasQApAs7UxJINgBcLqWuKyUyiHptyqkPUpUq5xfCftVSkw7g+15P1QEagaRgBLTY9bk8Bb1FpBWt4Za2zkhgNKlWuKWy7KV0qcncFmCBt4HYZvQxj5B1KNi7EQ4S/RBvO0gaq6s6RcPrbHLuZPSix7yILO7hAl7WoiIu7pcxH7gimo2/66qpgpKRaizTj4iKR7ckmS2Y+HM7zkmhYc36
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 09:29:17AM +0000, Jon Hunter wrote:
> 
> On 28/11/2025 11:37, Harry Yoo wrote:
> > Currently, kvfree_rcu_barrier() flushes RCU sheaves across all slab
> > caches when a cache is destroyed. This is unnecessary when destroying
> > a slab cache; only the RCU sheaves belonging to the cache being destroyed
> > need to be flushed.
> > 
> > As suggested by Vlastimil Babka, introduce a weaker form of
> > kvfree_rcu_barrier() that operates on a specific slab cache and call it
> > on cache destruction.
> > 
> > The performance benefit is evaluated on a 12 core 24 threads AMD Ryzen
> > 5900X machine (1 socket), by loading slub_kunit module.
> > 
> > Before:
> >    Total calls: 19
> >    Average latency (us): 8529
> >    Total time (us): 162069
> > 
> > After:
> >    Total calls: 19
> >    Average latency (us): 3804
> >    Total time (us): 72287
> > 
> > Link: https://lore.kernel.org/linux-mm/0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org
> > Link: https://lore.kernel.org/linux-mm/e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com
> > Link: https://lore.kernel.org/linux-mm/1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> 
> Thanks for the rapid fix. I have been testing this and can confirm that this
> does fix the performance regression I was seeing.

Great!

> BTW shouldn't we add a 'Fixes:' tag above? I would like to ensure that this
> gets picked up for v6.18 stable.

Good point, I added Cc: stable and Fixes: tags.
(and your and Daniel's Reported-and-tested-by: tags)

> Otherwise ...
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thank you Jon and Daniel a lot for reporting regression and testing the fix!

-- 
Cheers,
Harry / Hyeonggon


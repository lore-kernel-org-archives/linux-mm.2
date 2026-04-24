Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BFDFED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018E16B00A4; Fri, 24 Apr 2026 10:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32566B00A5; Fri, 24 Apr 2026 10:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20F86B00A6; Fri, 24 Apr 2026 10:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8426B00A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:58:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CD2F1B59DE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:58:53 +0000 (UTC)
X-FDA: 84693756546.21.1A6C281
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC63E20006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:58:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jTS8ATLe;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777042730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HB6gg07Xq7AJWGvgivjUgJ42w+7oNzYxsR9MZsg5YRU=;
	b=0XgNiDdHsFucSZEBoM+n0b2UTrfWsjgCrWVDA3lPM+CpSbQO2rZl8aGPVrTWvCO26Svgoc
	xPB5cMbYisy/c4FZ7C1IGUGwNxK7Gbq8qERX8Q6m3mCcPF0Je4yRWVlU5Jf5vnf/hBhnlT
	MBIwcdgooh5NE+bnDN/4Cz6+yELhAj4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jTS8ATLe;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777042730; a=rsa-sha256;
	cv=pass;
	b=ttgJ88nOiT80hBdPsipocgVHVFdNecep5HL8nH6/l76NjBgoll47eD1VrtGp1BUe0CiAIE
	JKTlKggQq0lXrABC1xmvtpEPnM8kUrlYyleM5LCm3xot2PJuBfBKJOgvOkCbioh33B4PGd
	XoM6TZeZFiRkLxJmYqIkgQrlgExglqc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jj8svZyMrU/1VtS2tNVE7bq/DnyRHDDfkoK9eQb9znt3wxScM8hA6/wsEioeRP2cQDStfi12ipllUIc987zPYzKVDYS4yzxoHoXd8e88oG+YDHsrZBZc8v9712avKmTWzBQ36plDk/tOLnpLgNuRR2r6KID4D1H6i41wdaPRVJ4TLTvaey/uG/myh1fflhqxOpjteVEicmK4/PLurKfDw2WYYubRu4fAiQz/Vul5/a9dQXKPidsYUf2EnuBZm9R4ofsLPMt68NFTMjT03IChiz/u77YSp+yxF+o1hTX2S4bvmvyhxbOvF+2e6zhmg6gdBlGU2+FyIXOIXUT9l74YsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HB6gg07Xq7AJWGvgivjUgJ42w+7oNzYxsR9MZsg5YRU=;
 b=uLZMF9Pdig5+SBsGCd8yREhaolIAUefwWRytiMXhv0g/Q1mBYq5n3pTIOa39HitLMbnm70ovQjTDKWz+UW+zIMf10sMlExTM880RtSPgnkPBBHdBZ7fswZvFdN9hsZC7XXf6wENCah6vXOW+Y9LRD2MoC87lMyfJPfGaCPFCUkaUkMFc/D3w0rBcHvLEEmOtTEFX//oPmqFaQP/gGQbFPwD1ycSAcxVIeg6v3cG408JxTOKaOoNjPWDvCFXt/TNX3llhccisbYWvKA0QLSLSYCjdYfX8SPoQyNRVbExfVw8WSJVQBqh228390UcyxyimtplBwXtK1EfZQ0AQ6Am7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB6gg07Xq7AJWGvgivjUgJ42w+7oNzYxsR9MZsg5YRU=;
 b=jTS8ATLeC5CbtUhKrIosUfsBWPbjdj+M4lc4l21rIGZ3yYgevnaMPBmAqfRPxshgB619ej3rqDLm7QXdVLKEcF9YrYd0+JPmc04yw8dj0vRLxyfrqeWhcVu4B3z8r4HqU7d1aRC/vsTaLKijFK4H02JDVbynYsXihn7dhfvQDKgq44SVoTgR1P185l6EIrT/4haNebYOhZgIgd6beBDlRYnVBdU9q2KDGUwaUUVVEaNX+u+iVjPEB1C3Uc0xElUIARD5EawXobsRurjtjX2xRLX8uNVXINiJr+uBuM2Wys3+LwP9Q6Tleud0LagivDgNSQRVPbQf7nOo43I5VAEGRg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6764.namprd12.prod.outlook.com (2603:10b6:510:1ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.21; Fri, 24 Apr 2026 14:58:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 14:58:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Fri, 24 Apr 2026 10:58:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <15191F7F-0D10-4907-B963-DA4EA0E36EB6@nvidia.com>
In-Reply-To: <20260424024915.28758-4-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-4-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:36e::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6764:EE_
X-MS-Office365-Filtering-Correlation-Id: c65011e6-a8db-408e-c91d-08dea211f99a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AisoxqVmZKV+YVinzlW+zznVcDfnNdFtltyYe2x7XZ1sYH0q1k5ZpU4p+05yD4sE5rwNDl2pIcDIHMNuy6uaiJI4qa2BgLC2lZF8AmEmRZyb240cQnSLSY8vxeFc7ZgaWDnygnmPBJCpDxl228MykDhQMOEi45GMtkFnLjNbjCqarfRNNJF6CRAVFaMUHUb2/33446uZzHby5HUQPKMfPmvWcx7HsDlosUlFAdh3KYc6QU6RHIKAM8FO+ouZaJw7nPcbTqRv/vFEW4T/StG7EMAnGLHCL+DYKbaZ/3oeRwwvzeWumV9CWSSrhsr+KWlW/r0dZ9VUqkiNvVJTHdoTdO6Q3E+NyL0xudsHOStzPvAwW8hAPXW6FuDGlckCksHINGWrMQS/baMX4ZXhpcx/hYgs+YKfn7FjiLiZ49VRPUy9H6vmMGSml8eNLE2xp5QWBG81PaKEKE7lsVRaTGQwdORpRB33KnZSABkaU1kXCkm2jaGuvTYI3eW7M0vCxUkCE8gGsahzQnzBgG+eMmI+g2HBb4gc0W7ulREGUW07MPVLxnrxRlU7/mzv/XkSJ9BYgPSjVSwzSrXFm1BE2Y+O7Qp/wMvBoOo+fWQPofLwst+CSHYnwgSJkOSUh9tC7mFzgZWpFf/ccuJs4+eNzmCHh09kSzFh5uKz46SRv7eD8OHtnvOh389Jg2cQggE5qlTgFq78oyk6OSBjqepAAX2pN1AJt4yC6d56MuFTMg1C5z0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?COjViHJGBmXECMtUD0c0zmEySy1G184K82xNMjbhTxvRB/Zhs6BJIC2kpnNk?=
 =?us-ascii?Q?jmipOb+4C5H3RdeD25OWPaPuMUxId29zibFTTVVWHTKec09QMrEEUpWXw7we?=
 =?us-ascii?Q?UAjm7pm3CMoNKAtR08a+faxBAGOtknbDqtsVDTTjs8dyc8VO7uwFhMXiD5JL?=
 =?us-ascii?Q?9EWzVQ6+73JBpcUr3vnkuPtlu5Bw8HuIRGKnd5ZVWTFhJ4TZDs8h1Vh2UibT?=
 =?us-ascii?Q?KQfE6xShBKcAUpwJ442VGIm79NGfLFr8ZmTCE+YHxhXoXlJ2TLRNAswK6Me0?=
 =?us-ascii?Q?J1lJ8NXYq+GA8loY3jy2DFEk2pg0unRcqkCN82ZFfkOhx1Dr6q93GqC6bXBK?=
 =?us-ascii?Q?o7XbOzWJYrHiBYdP/H6VxqDHCgxpIKE0DQ1YAkcvfWu+BVgIr3hLFD993yc5?=
 =?us-ascii?Q?1ZpFiyq/jbXI4G8OZbDDm+fLMvrJKWfsZSHue0+h7m+2wY5PusQ4d4gkHBWS?=
 =?us-ascii?Q?4zwEi9r2r/rmiOzmO4hVVbSR4sGKCAY/ZsXqCbGzKoHiRGAmXF/3Mf3ez4yY?=
 =?us-ascii?Q?7nlHjZrOVFu568Pki0BnGxMxQsz3WC2YQqkCjeyOro8r3m7k2/S/ndnvLbrE?=
 =?us-ascii?Q?9+XutftX7TtsToobE0vOhxzNq3KLkjiieogYRYud0akU3BWuUz7ZYLnx2/az?=
 =?us-ascii?Q?KoHZWFA5AG71ta60JWWLA7UQFG7UrzYlRvJfhgB7vDTXms59izyvLVex+rzH?=
 =?us-ascii?Q?OF+pmiXEWcsRztt9Ohy9jLF8m12VXNhOp++uwN6lu2AW7ANRtwpc3fTC5vMW?=
 =?us-ascii?Q?OBd6X6eNRbQED+MKgJE/me/7zcKjt4I3jJNV9iQAZI8ni1LYO/aTfn1N3UsN?=
 =?us-ascii?Q?NU2tLia0eNhWEgvcsFhW+m7FbwXFjJbzP6nNMFd3hLB4FaRWxR+IIBvSZuny?=
 =?us-ascii?Q?FHAT5lX1g8/ITW5Vis96zAl9CCTVJT5OirTDx8ipis0pj3CkCfJ5idpBLihf?=
 =?us-ascii?Q?Nxox/UfP/7GCrqkD5TJAAMWPTvI2l4mahrHMKNifhc0yEYiWr8FQv7wK/aaV?=
 =?us-ascii?Q?s5DqTT8L2oowJB0da0rQo1r98PUPc6x36tL4Nf0UmAgqA5ca/c5DtbO31Yx1?=
 =?us-ascii?Q?3nSAo6QWOK9EByvuuZjkphU1hGt0LrSTIgB6ro63oQnCdMvtqTISBArKo/qK?=
 =?us-ascii?Q?kDAYiwRFQXAPFVe0lezxE1medrXp6oIOjuev1dj5d6XSNyjJIq4nahZHLv7u?=
 =?us-ascii?Q?NeRC6YBZklalh+tInMZEEKnjzpFije3oveY+hPFvXOW6Fjw0wBMB6277nv1H?=
 =?us-ascii?Q?Hh/UGfoBwbIEcbObxYpvrGatVqi6//pWBYQ4kxLzVmJZs5GFSBnHpH9o4pEG?=
 =?us-ascii?Q?/WmXupZuXbAAGGkd9pvTE/q9FycUQgcxOdsYn5QLW8r4q79HV9pYE17TKK9u?=
 =?us-ascii?Q?GUz2KOnjdvL1zT2O+pkN+/KXVkUtz+bofOij9PK7HY7rZFtu6ig2Pdz2wZkJ?=
 =?us-ascii?Q?b766JSs/6VR955Pv6sV9MGeI5y0STrikyuGBhsFLmh7DMi7zJUb1sDzQAutp?=
 =?us-ascii?Q?u/JybUT8CzKQ8O7BGWRduQpZ/7LIC0sxumkp+CBoc1uie+RusVIPdteBtxhm?=
 =?us-ascii?Q?/XJiObBdeV8OWbq/GAb8zg8Y2ENrtJY079kbk8e2PQttNoB8ym4k9fYlrqq2?=
 =?us-ascii?Q?GFnSGw7tUjW2VNxzTzpqjyXf4oXTEAzZ3GNusOQBnHzHxy52uSAWFHAmxol5?=
 =?us-ascii?Q?oXcducHimTQKhYcc+znrego5oCn8/T34PEuPBwIMs5FXLMHWYXYu538wiYMy?=
 =?us-ascii?Q?iNpJKi98OA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65011e6-a8db-408e-c91d-08dea211f99a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 14:58:42.0293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N4RJ4DIIW/6ok6vSBKp6kGD7RZdKNP+8zwKT1rZu8s9M4eFWFhzDzaZFfoQaXE6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6764
X-Stat-Signature: 5d3dwgt4xq79ajywxpi4wzshgbh16smt
X-Rspamd-Queue-Id: BC63E20006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777042730-886020
X-HE-Meta: U2FsdGVkX1+dwD+yjy1Gqk2ghT77CuiB/0zDGq/kQDudLkgl5VQUCb4V7OHMEhOJ+NYY+xfz+0AZUZJH7oCLfFrEKDY9UiRCBvXOhjAfg66Nbdi4fLAnSTEKj1nd2z0lOZH6Y1Gr/qvg7OJbUpq7jf+mEfP2CHeMVDd0gLw7Kwa2YYmueltmbWtbb4gbmDeOFSGilkIx3uAqaY72HuzxIc9ud4BcGfjAlEGo2+KRFymgdW7bCjf6HK5q2igYP3MXCoWgrse+KEaPomJEj4jW9/nQOmbNE51pWay4mcZIQo6czuwnEiujVyjryovWc4o5Uxtf2EizcFb+t2wVXiadSsRmnhohPZ2AElU+eg/zgw9cxyghyTbuUtMp2DejVK6dhxHqt7SsohJkLRAa+kfF4ArJkXncy1vyPjjCxoMcX2RISppXTuktYwJ1sULQ8sf22wxKTYsoVAuvTHUjKSFEq+2adthxAIRMZWgp5oM4FxQHraNp54oEgjewgP10SkQ13btvrIk+WVUMJ5V4rXNG1FU+HlxW0fa81NYzuMVyryWKKOwbFjrpjZfAIkPvRvm/X3J1W7n+pW9r99yiewgzS5s1CNxAlscmhUEqnyF5tT/7Jsfg4gM2KrtTtn35Wcl13JKpVDMQs5obIHVVLCrSHi6ul7OopwGndIazq+95fOB5XcUjF3Uj37bIbG+GyFKZEqrg8/Ocn8oSMMttHreJQZ+oXCCdETPgKlIDSwlSYvd41LhGQj1klAhFcaz6LPmRi+xRkgxSekESqu/wFcXD/YQsVJK1+/PmjvHh6jHecqSeqF015im38KUwJzzsjHiWTvdQKq0B5X6Um2NYfnRTP89Ep8f+QqnEC5Hltg9yGhfLr29hGNMQjw2vqpfuJmuPyRZSHSg/nASMsW22FEDvNG9L21B11dPnacPm+UezyO2r7rq69gPpFTcQKHTzjrJKL45IqpIi95jFt2E4g5E
 G1Z5yByo
 Q1t+ENdWt0Kkb12i9ZofOLqVwi2KcBvNuworZLMoi8B8K/DBaoZdK1lGLgPzkVGNlRvT08gFtfCuVw9/pxXn8Xm/Tsp9Qt5/VPmUuxcOhPZ6NWY1UuXm/tfMbTc55qZL6OgvjmT1f41WAg8CLW2leB6Nh/a7Mr5TWAMZO0ORN9Sn5rLcFXHbBolrII4QITnFAqBKg93+vEa66KXSTz4jgkfkmjAWd2G0qMaqTxYLb4+JVywF5WCUyUQUQDXn3Kxv5EeaPw6wU1/Gr3lPcvEaKZXhQyLIhcW3mCWOfZOZryRVspD3u5euMrHdIK7KVntS0QdtxGymU8vQ9YTL2GajyVTpkeMrLhzO2C5VZccdmF5ly8BqnsaQz+2klGVTFo/bxOqTlNannq7ndAUwakZmJxWF1Q2bJy3Xawf2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Apr 2026, at 22:49, Zi Yan wrote:

> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1f0d0b780943..f0db1390a18f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> +	if (!mapping_pmd_thp_support(inode->i_mapping))
> +		return false;

sashiko told me that I need to check vma->vm_file->f_mapping, since
folio->mapping needs to match vma->vm_file->f_mapping and inode->i_mapping
and vma->vm_file->f_mapping can diverge.

I will fix this one.

> +
> +	return S_ISREG(inode->i_mode);
>  }
>
>  /* If returns true, we are unable to access the VMA's folios. */
> -- 
> 2.43.0


Best Regards,
Yan, Zi


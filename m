Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD65606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pxj2C2lm
Received: by kanga.kvack.org (Postfix)
	id 8929F6B05FC; Tue, 27 Oct 2026 17:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8436C6B0601; Tue, 27 Oct 2026 17:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A636B0776; Tue, 27 Oct 2026 17:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406D76B05FC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:04:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B53BF1A0B0F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:04:21 +0000 (UTC)
X-FDA: 85369634322.16.2619A82
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id C2E584000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:04:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pxj2C2lm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793135058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjv3DTrc8QOFN8oOgd0X4+2of6rdF6Ayu9jM95Hlmwg=;
	b=72NaHKYby3vhWpnPgtAX1c1Jrp4q/+Kvyg9bLCFv9lDYBbb4lntqkosWnVodTotC/idyD1
	I39feXIs8V3lWu+7fOmQ7PGvy8P2kMa+ebjTjjZh1HIIPPAy+VDPD7fkTfFutQaLRqkKJc
	jm90ORO1taenwHW0xVFhGlBI1asUAGI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pxj2C2lm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793135058;
	b=Do5AXFFQtPBlm8PVhGLvFCRhumJGidXTHkvJMjavBjK8nKQmAXamoxPYFQWZo2g0GlbkIx
	a+BYaHYqJjwcgQXeLIOLR0UXdDPuMF4zS3UqjMvkRMXxCn29n21mm0zKzH59rG1ia7yxxI
	tD20EdU/jfijKTiEF0eI7OWxSe+X6Fs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjoO4fhhktZilcXq0lVLcXUFefRDtkIgnd+1Upq9VVTRdSPyYhiSa2fTjEVX6U3Ye34Iy2WLAXLRDqTh6n+YvyLe6DSQ/vN9aLhZZGOn6E+wu1F2uC1avJ1U/+Eahx3KbOP+Guaed+DOBghZ5wJY4q+2HCRa2EuSOvzo0D40iJGJqNjOtLIBTPa+SSLZS3FH3G2qN52Tdc4+I1bpdfd1F2SOrqzmBYIAJIZ9kYD9fh+VoWHj8/AnzfF31q+UY+8puEmRvdsUf9iwaX9+ltcbQGSr2jx3yhMkX2UuM8fiNTIDL+N8b+WPlkWlQphacTt3EpaCJKC59K+zchbP44Sf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjv3DTrc8QOFN8oOgd0X4+2of6rdF6Ayu9jM95Hlmwg=;
 b=JOlVkOYN6YPhcfvYfhkJgdncO+1z16PDdYthmce8duvj4qqkN4PTHGWauMYN1cTcoEVyrXggQ6+OHxGglj4ZAehwzmyIiQ+eovOwWfNKZnBwVn6PkyNkupo0vQsHTTmgRsGcua5B5aCGz02h7nw0DLVDf1nfJxk3aEIkh521MULrDPC6Cx3W/mBnRKniXtVdBp4VUMDnU6Z+tdI9oTuIAYr5VED3gVW7vwhj5YDEOcIAHaaGRODp13Zs7nXeBe9pQcDOlI4WptHi0nKs4YLYLu1lfAgcv4jQuth0sUwV/NAMDjebOOp8mQBEIga4b5OfQp+05LW/40SCOUX2/9qMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjv3DTrc8QOFN8oOgd0X4+2of6rdF6Ayu9jM95Hlmwg=;
 b=pxj2C2lmbfqRV11YmFThbJipbIG+fLqaI0pk2H2B3VufP3vdT082+F0cu9xu/cOZYaD22dJm/5myYwjDyXWpPKEXa/BbCuHZTmb+JJ1X4xIvXFWEQCimC2p0cG0itqD5YN+RlINwnVoUs6ExMzbp0f6VfTdopf0TJ4y4+77Io6NAe908owjtjtL9x9izNg/lSO1ME1+uq8ykgGwyPaVTGpwJOyfJMX9C5yirVHduKfkGU0kKwwhFhX7p9M7ud/pW4g7I2CkYhhxxc3si136kK3/fW7Cy1ELlqt78jJqLcS76uN1u1M3m2xx9jGu/yJgTA/LCbDjo3UCcBP35bZBgyA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB243497.namprd12.prod.outlook.com (2603:10b6:207:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 21:04:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 21:04:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 7/9] mm: page_isolation: do not take slab pages for free
Date: Tue, 27 Oct 2026 17:04:11 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <6793C31C-09FA-47A9-81DE-9897A86B2029@nvidia.com>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-7-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-7-9c7d1aca801e@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH5P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB243497:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3145a4-420b-4292-fc98-08df346ddb08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|4143699003|56012099006|11063799006|261021121427099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ywwBSkcvUZe8zHFIiaQajaZVcCKLu8ksqHMaCgELE/myjPEjlJbzgk3pg30cOrH4MgXZLDEiEvzWHbWwXWu4j6eMt/fEfohUkiYT+poeA1uRVOcpN64qe+wBqIbqDy9wXkRudQSylDkd4r8ewFPhN+nr4VpHDDcD5uPJw19zoIGyoNZaAWsCFGLgMP82eP+uSuTPicuqavpesa5yLRkLs4+xB99pUWP06H4H33aTQiWRT1SCjVjoENOWNYZYzt6B02Me0Ht8uglvvD1xiT7hspc+F92bKYVZNpH2w/hwMXKGhOBNTyJjN/tHE5eN/kjb/TicmhLchO0GQHPStbBeUFtaSyMAJ+0zayE8CtyTgJz1GS8gRtm1GpKHlBNWfxtnIHiV/KYLWfeqrGO52kVj8g42LFADSYsk2dSMW9+OMZ5qhT/we8YgHHjpaxvSfv8xok6MCBlHVIP/GInt1Uw0DkeUx79FPnhW+JuMmQPiwg0CTWV6zJ6hbmMtJWEqddNnTW2+tqy+/wNzqQJN6sVSNXETJmI0unzAnTF8KhS40HZ/IQ0F0bbIFyLCsLiaZlLCc2+MSmpBS342/yk37cn/oobUJz0CODeJPx3B43m1jBCPZbrFoEP8pWz+qw3bDjRz6HDowmfStW752kPqZ26nmQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(4143699003)(56012099006)(11063799006)(261021121427099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UFekqPQN61E6yJzgouYe+kuFrPnYQvkdVTPZCpXCVyKKlON5CEMbCtODjzx9?=
 =?us-ascii?Q?NeXpll/pyLr8d5pjRzqyxfQgVVn15GOUQY2JV3p0YA0zYBKR+GgwFfs10Fw4?=
 =?us-ascii?Q?5E1EVOSle1lBsyAcrTfoM8Vo4BqEv/q0IGcSs/lM+38wFgQiSnH+Y1Jkbtj4?=
 =?us-ascii?Q?ovqMlGriiDeJ9gdRdhxKbLmvlB4V5eEkx0ZNSmHctQc3VI1B6cRKNhbOdaha?=
 =?us-ascii?Q?s6BUU/RsGoM7jdy9IQo+70w2VkdoiJhSbBu0uLqA/35+XKtvJgoSxQ2kNJXB?=
 =?us-ascii?Q?VIDPSQtiE3naCrEsPNRq/XT2mi7gW9ByULemVFFviBvGrtFTDXIhyAMRBpAS?=
 =?us-ascii?Q?MQeds70t0emkQ6hcjrSp1dqnMinKNCSO/YIRAepzOL0hjmmsn+1Jr6idc+rL?=
 =?us-ascii?Q?HtaiGPxzCzf8UsQKK7S19C3m11iFPak8vEn111LS1ntzbXl3Q3gDbFhtim60?=
 =?us-ascii?Q?5Nkr7Z3vuqs1uQOx5sujTeX1fscahWn7qTiMiQrkfYPU2ApnqPMneFlYHPQC?=
 =?us-ascii?Q?pCQQHkTWPcobgipdwIlFzyM7CWY5JiKM/uA5cohvMxVfTKz5lSO9Uv0lLZm+?=
 =?us-ascii?Q?Uc+IqUDjecxZkj8up5bpB0Ixj4e9hePBwugi1e+wMZFUXhtVsRezeTGVaJSz?=
 =?us-ascii?Q?MEQrnPzAbpL7emizM9XXlToii8wmHCVbhrh9EZzzjrj1iwobtBmJl6FH4qnW?=
 =?us-ascii?Q?f+tzyc5VaN+lTwDdFuGDl1NP8JuVIcPlDZYWan0uPEsgAJfVpUVnj38EqXIH?=
 =?us-ascii?Q?lTIQ7Q0QbCqqpGh98MmQ24B1Q2lIVji5M9k0yx8nLYrl/dyqG/uAB1EhOEXS?=
 =?us-ascii?Q?5s1nwT0DovtcfZdH6swe1m7jBZgY/kBmEo3ywWPh2sc2iQwlARgQsfinJmTt?=
 =?us-ascii?Q?kobhCAemC+xKGbRbmuHwyGoPV7QOt2ewt0DqYKf/5NcK9yjufp8M4gYbaowv?=
 =?us-ascii?Q?4bafgrIQWDvHQGV35MbAh6teewHEs8LxZd6cRCrJPcJVSkR50PuzSv6ZckWW?=
 =?us-ascii?Q?AnPUO8/yHMzkblHio45xUYWdD9FNr0XMBSUEy/jnKqSvDCngqqkJ6ErDgG3c?=
 =?us-ascii?Q?suijl4lVdF9aei1Vd3sGzeKpgvJth0un1uqbVa6j5qxkZw58LkqqVtXHfT42?=
 =?us-ascii?Q?sTDli581aKs0qyz9RFTT7LH42bk/2s4Ns9NKccTUCXzOy6IoXl35YK7udr1L?=
 =?us-ascii?Q?gWcOUmuAFftPRldJPlUxCl7f+iOqjdzAsvtpnwDcufDr0yLE4a+whM9o58aG?=
 =?us-ascii?Q?D8OFD+VqeWq1VADkRxLQ4MkmFRaB+fI7tqJ1SvXwWbMSt5jp1Ne3P8ePDLk8?=
 =?us-ascii?Q?RvRPlmSiQ70oTADlc3XaA8H5Ht15JWw/zoJHWd/BzUfRrAzP9Pr4+IN4sqDD?=
 =?us-ascii?Q?PCaa1lDEhqx2bnczgDeMYK1TFXRxOKafNJnfwDCBUkiGE6JFx8buR2I3c7Kl?=
 =?us-ascii?Q?xXVPHMQGK07xpQs7suMa0POnQA0k6HsMfrzZMw46Mcwly1FUsrtlIEj9GOJ9?=
 =?us-ascii?Q?i0OY7y34AhM1jODwp3V6a6pRIOhwzuYStmD/W0jgqhdwJVkrmchLHBHC4Rz2?=
 =?us-ascii?Q?0VfiJ9koknPodSvtZM1xTeKxmsQjux9AALRTuT2Vjn9yDPoah/eEgTEYV2o9?=
 =?us-ascii?Q?52Y/vPyeh4meZijx/HNTCqJQg5hKX/CnAu/qmhvsbFFjhjPCXBGzHF+P/ZPM?=
 =?us-ascii?Q?yUOtdLnDRykaKbLxjahHQ8egoIEAOeVej21TAXsBkf8XLq/ZLEE2DspNxiKE?=
 =?us-ascii?Q?5f59A7feIA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3145a4-420b-4292-fc98-08df346ddb08
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 21:04:14.2381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcodl7Lqe/lcHydCtW7teKQeBPFvlc7d3N0HiD+p34XoD+yqNQAuWnlDi99QCzmz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB243497
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2E584000A
X-Stat-Signature: q8ii567fpctcekrrmwmwnfzhsabna38q
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793135058-652985
X-HE-Meta: U2FsdGVkX18WgzJiPIUlJ4mhuUmifJELVuGsAFpFK9fwTRpIXKu0aBsfGzCm/k1501FJQhBxCYJfABJr1oPzP1R6VtFvQ14MRPWQnuu1JkjOWpyaLNDsrWjYzq4GfvfzhKwk2rrT16f2ARlRnW5Hx6dO4VTsyBSe8NdLDSaf7kgj8ygSe8CM1YRjz+id7fEcOAC15U6jLsg2xZwdKI1bFR1UmPhAmFFnp3GD9vJp/ddK0iLOiF/8Q9lPt3848z772iIwPDjaKzZXl95x4IBknbNO5u9D8i+u0MtTMdGcTn3nSahMWkgP83cps/ujNcuVDsIPOL8OZiMezydTuy62Hx7kabMFZMoffzJBpBqCRt5xg+TQcyHGVENyCA/RbZx2RRr5gOsLIP1406+gHnp0OVHElcFbWkpGUsRn/w68wlPyf0YapBbdgf++q/f9L5QfRwFGcZexi09RWfhXv9lhuRhbRl4TuPYjw0UrWVz/Z8a25R/NaaSKUdYEVovjQnglWsQcWWSHe/3AsjseFhtiO5wsWSRsPVJW9WVVWBfccLdfNgoKrfb/hwVD7fFyzP2pykaoWQcC1O8T7E+Kd6HS9xr/W28AgBQcU2AvUoaYH50rismqB7AWZ2GF7mtuyxWdQC79NgT9duubHg6pb9/jOUDS1lo9+rw1VziWWzdsewD3JmhienjEdjQK2fMRGSAnCTfY+KZGJ5/22PiFgWMr+mXKSx0P+2wzhECO+n2HtO+yV6ixv4Mri7ljUat/7GcbPSHqiFWzJLj837pg7Qd5S3iD4z4hI0fZB5m6gjehvkgU6EJqENhNZpBY+gDzKTyaoFj/KEMIgKH7PqvkcIiWT/tMYdJQmg60FQU89AuBB38UXTS82HHjY9hHKILjpMfa4CTgeMvg+hrxwKVCI/2lcRweobDySnZ8Rewj8cU7Bs3KsWa9Z+y0zLc5diUBzF3du0j+BCnygiKtoF6n0Af
 OhxZewSw
 72NEocZfIn/ZyXeG0pndHRY4/47R/lgofRuf7jC95VAw9Bpr+GXO6EGmBLjVo3XLkU56rlZ6jjgzXKHgsz0sX6zGwRdodDa5EzgLGbnfF8RfyHVGDn+ijPi8SxA0Yo/8uBia2l+5rka0PBZUhc+gcF+CmbojG/yLXOc4s1lIZ9xuDh5EEhf5cqJpcy9FXShZTDYtA22eJvbNZlkZ7cK1Xw2NKkLoWrrta5A0c5368wN2AyPM8P/LylantpMWdqDLzuw1VwAAVglW/4aRVFIcyb3wVHH9d4WjxD5WFt/3gP2GcETwzxKm2ixIYkObPhTBevyrEI+8R4NkeugQxMqqI0PU9AEawLU+Vu6h3iBNd4tbSpBOR+Iyn6K+ukgrFK3FySwNvyiqqvuZw9CeFBxVyQshRpdypSS6MKUbuxlau3s9WyrdCT7U2Ky+/F2uGgCt5xJh3IyZjPUwV2e39gAyJGw7+mti3P0XLMs0KTJdn2EyBvg0Tvybt8azBMSzOhRRkR5hQ53zjKyHhvtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 27 Oct 2026, at 11:46, Vlastimil Babka (SUSE) wrote:

> From: Josef Bacik <josef@toxicpanda.com>
>
> page_is_unmovable() regards a page with a reference count of zero as free
> or about to be freed. Since slab allocates frozen pages, they will
> be wrongly considered to be freed if order 0 (higher-order compound
> pages are caught earlier).
>
> If such slabs are the only unmovable pages of a memory block, memory
> offlining now isolates the block, this can lead to offline_pages()
> looping without progress.
>
> Thus detect the slab pages as removable to return -EBUSY, as would
> happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").
>
> Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/memory_hotplug.c | 7 +++++++
>  mm/page_isolation.c | 7 +++++++
>  2 files changed, 14 insertions(+)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


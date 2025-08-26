Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E37CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6404A8E00C2; Tue, 26 Aug 2025 05:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616208E00A8; Tue, 26 Aug 2025 05:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDF98E00C2; Tue, 26 Aug 2025 05:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37F9A8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:55:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C138D84894
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:55:54 +0000 (UTC)
X-FDA: 83818452228.20.B400ADD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id ABAE6A0004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:55:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mr2ij0FR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UKbHxvLF;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756202151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wSD2p1H4T6PiFzYRg8zHM5p+w11SE7AireSRuHy+DY=;
	b=OTVSMIMoQ9lj7FbXCCZvwGDkgn8Bi8pzzEoe8Y6XmKoJYqSB/BFa4Dzn7ar3BYuAc7NSIX
	5NswmSVq6iFHlRb6ipOqIDqNkGc0O+BKHGbHGQsVPjfeLmOwPm8foBURr9U8O5dwcy5mOk
	bVhyHVOzVG7+vs5tdKTNPkg0VO84WOM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mr2ij0FR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UKbHxvLF;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756202151; a=rsa-sha256;
	cv=pass;
	b=JHnJ6WXLOFkk82RPEWOSVyeIhHWgs7jaZVLjExjiPQoBH8urwYMet1+ME7OHLPW3VjmMpx
	8xAcAoso8XXN+IshNtzWELdjWE8QUl6KhQWza3ajBd/5EPd8MaRNmsOwVjuXwdWJkLuFN4
	t0OHhl8DcZEYPdL82XoAldBu1+lQdpg=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8lvu1005116;
	Tue, 26 Aug 2025 09:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1wSD2p1H4T6PiFzYRg
	8zHM5p+w11SE7AireSRuHy+DY=; b=mr2ij0FRU2BHTJAJzKtYilI7fchmTyh2SM
	ZC1rKjUYi0NAXZA35PDGiRNtoHXBX52uUwAVevAAU0yGHI9zVZ60ptrniGxik48L
	l8yh7Ys8ubrX7tG4DJb4yiuDRrbRCgGQa8wherwEwOQ8I9q/mM1T1smS0NmEhwny
	V8ajsvCRLEQQuC8th3iLo7fFafJkh6OD6PH5GqQ2tJwxur1sBR+7NtbL2sW+YqNh
	987AtlDCR/4HlXqfwjHIEKNJJOXgYnC6mg9/2jL5q1fCTffOMvRBXW70RnaJ0zWd
	o6aQ9cBDszhghs2pOjP6Y6PulUVS/PNt+P5+izMV/Uqkj2ycygEw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t3xhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:55:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q90poW005043;
	Tue, 26 Aug 2025 09:55:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj89k91n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:55:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwQMHbXCZwOCnXVNHTdqdTTGEmQh4vOcKCo642+Ba+OCK4XeMVTyb1+O6NyHST7puijaJFnbdR/akS8kimnuu0UAvdYjmHxsIo8mp18zPg9hzKsBjuBuEoTEBOFJGpqWc5iCMXQUznKSiD42RKDDus1Jimh7rReLFq7H8HvgnGfjaNblG8WZSl2Sc+1w2vnaRP/m9UJ3nIOoYS8ni45mz4B+MX9ogR/Mlj2k0cDsgMpuOqNpQBp1Y9h0FZMKuJalysX24ZXT7iJuA3o8Af95S1U21PZyayZVNuWmUt/0vVHQjMtVaXqZnZ4Sou3/Qn7QMkWmye9AsUDyiJ3Ee6xLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wSD2p1H4T6PiFzYRg8zHM5p+w11SE7AireSRuHy+DY=;
 b=Zb0n1uSLWmRJa5LQGrq9oOGXL9H1xqYj4Ij+j5HWrl522pqMUdRwy34A34kJ61/IBdByRmLQoA8XHij/MPEvhis9RbwpM/aCGN+50bo46mChWeSIlsqOFyeJtFqJ0niT3g9C1w4gqoplwcI93tUNQoE9nUlcYhWKHLxE/9kT1TKiPg87siNfk8kqcpV7N27GFUep91aHFk8v9iNmiutlFSTooBnXLwQIqhnKgu3p/cw9rHvGKWz1dfuWiRTWuHCTs/7OFA4fpgb6A/LVqqCQL6mLjNXPcGu4xbQq1V3EOPR3tx4yFu/peR9wGd7HDBGcitkrfbU8SG2kofhucR1Bow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wSD2p1H4T6PiFzYRg8zHM5p+w11SE7AireSRuHy+DY=;
 b=UKbHxvLFpby/ND8RWkYTl5WOrthbajjEGVw91F/+RWT6fx7oxUMESxb+XqOmvFxfCuHLPnFdG8rQzQ1XeMoXV1C4pwuslybEcG8PRYXXByafnVnxVXH8YzJwyStqhca9SofpNAsTSk93xrazEb1GNJhkqJ4sRLpXJuKJW4JP73M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5068.namprd10.prod.outlook.com (2603:10b6:610:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 09:55:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 09:55:44 +0000
Date: Tue, 26 Aug 2025 10:55:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
Message-ID: <4e7cfd87-caf6-46b5-8cea-84f9b15ad838@lucifer.local>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826065848.346066-1-harry.yoo@oracle.com>
X-ClientProxiedBy: MM0P280CA0074.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: bad54590-ec32-4cbd-a0c7-08dde486b93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zk89om3P/G5wcUGcKGCOAf/iuBFylJpIZ3smUFAwut1qH9eeI2ThHwNNqrvC?=
 =?us-ascii?Q?zNSwQ/g7knVZd0XmbKqyugTKgr7EZwLt/k2hcngIrLaDXE76c32mTcFws2sF?=
 =?us-ascii?Q?w6Fh/QQ9IUw4NV3P9aBDRQIbtA7FDJ5f0dl0UQdKWXaIz/rYTfUsdZjyiQrl?=
 =?us-ascii?Q?WxsjEd4MAc0yiMYOwrg3aI6QsB7U893k7aiQXDSrqYgkdlD4UStFM4R+K47T?=
 =?us-ascii?Q?dKMn/b8m7pMTN7kEIYoDjjsR/Xj5wESHSW7D6ZDh0evYI5ARcKEqAiO1lRC0?=
 =?us-ascii?Q?ehN7PYmrDucCzD8+V/QiVC4N8nXWZrPyRgpEcnmMZs00meYaJj6qW+EC6YPJ?=
 =?us-ascii?Q?kvFhMXrie0uaedXxY+fhvLC5SuALINEM2bLmIYD1ri86GqDATo93oo7xVZ2T?=
 =?us-ascii?Q?ul4+2hSLbbU3KIRr4d3oHg1nAdiJja+M1mEHiIHZc3+7qHm7RfY8STz4E2iT?=
 =?us-ascii?Q?mWEMTEqXfJaodQgx9OiDYngG8tU8wQ3N+QbpFCdCRJDPWsHQuW07OsFKk4Ns?=
 =?us-ascii?Q?jxaRlhW5fR4DGPbL3Pp6KmRGY4UQ6l0GnwO4rvQfmJyckAY6IP/XkCjlA0Pm?=
 =?us-ascii?Q?hMVPekZQBPsuMuflE3VUWZysa1fYFdwahWmI1T7Om1zP1HDiznf8J2xN2z0X?=
 =?us-ascii?Q?DFLbihFH9O+GbHj6BOXXQHVbr0BesykcixOcblwojgwaMITJxJph1HkncUpe?=
 =?us-ascii?Q?DI6nLHQG6D5lfabG8uPd5V8k566+U0NPyAiv4zjwYYH7s1H3oEUnBde/CYN6?=
 =?us-ascii?Q?oW/iVsef43+GCWpOleHZMsF67RCwBhcLyhIY/UCXa755SoA/RQxpHPEQX37V?=
 =?us-ascii?Q?YDQWmYBTaS35rzf/uA94v42irWgx17dDQ2hUAds7TryrV7MN3pl78atkhD4f?=
 =?us-ascii?Q?l08bPZKE9Yu3+hktvaEaFJu+gU4rRfd29xZMMUPGLsjdJJ/Oze7KHREy1nrx?=
 =?us-ascii?Q?iTnt2lCg5NUXlvGcFuclR9YtIW7KNmAWQxwoKDxSeRC5wlkY+I0jg9tK56vV?=
 =?us-ascii?Q?dPDdAUdWKyyru4wmm0ekQt5F8ZcPXUWUebBg/DD3ZrhkY003U3T2Ff0ssu9Q?=
 =?us-ascii?Q?KIfOtHF0GOx/zw5K4/eheUbhBUNtx6xvfFE0RgYGmU23mf27s75bqrTTDtD2?=
 =?us-ascii?Q?w+1N1e8alco4TfuM1fRoJsR7BgeVqm+mHYfNm4wz5c10ZVwjnnRqvQvDWye3?=
 =?us-ascii?Q?yIcn/zvb4ZN5HaQathIb+6WIqLfpCNMTctFwAMr4Piq05Z8voJBbU0HAcWpe?=
 =?us-ascii?Q?SCBSrvBWl9EUK6bvl5Orz4BItSkk/U+3G+7cLPMB0k3AgzgnMkBgTnk+zAdj?=
 =?us-ascii?Q?aPi8waF44ynNjFSM2AMRvTHugNs0NqRH9ScoMD5CHvnVBqOprGfzbG+0SdLa?=
 =?us-ascii?Q?fL1x7URcRUV7FMJMd6CZsUcIkxdrXT8FXaY4qfXkCxq0mG8B1yLYv+m62YL4?=
 =?us-ascii?Q?3K5p0zIci88=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jtZMtyZrXrnHMJDsHIpjOe1X2BdIJU8qNiwY0wYoElnHa09mwSDszdpgMV79?=
 =?us-ascii?Q?54QYvtng8PVIu2hnrftqbYXRHY3/d4glsBBljaWspOROZIMbQ8DIY5OLKlUP?=
 =?us-ascii?Q?9IQCzym53NEXcxgLICbz4z0FOFIO+UzxaqwCGbM8Rk9hLVW54i6gXuxzGXou?=
 =?us-ascii?Q?WHhj4lOBswHjN2H4BEGoy+Nrm5iozf+iVez+dDCLnvK8w1xpwBMvRtiU+rM9?=
 =?us-ascii?Q?gc3zLbLgpnzX+LrDiWbz3rZNkSnJ4IwN1nKJ3C5AyP193w95Nz1GskPXpnb8?=
 =?us-ascii?Q?Zq6b+Pw2GDIoBpnbyfVyYXJZd0TFHJt2bMqMu4f7Ez2xxhvF3kXWUBsCPdnj?=
 =?us-ascii?Q?mKg8EmFYPGwsatZWJN9AZOcRpSwye0bxTPn8krWAhipjAexDg12iIjiCUvBi?=
 =?us-ascii?Q?0GD7yEffnKtG/mk3hKGfqn7FfUwZYp07NPZdmDd+VFEWoFW9cnsCTQximHuw?=
 =?us-ascii?Q?RqhibtZMfXnCom0tDN0guW0b2XTQxulrz6/w9UjiGEm3ZENaLZXDnRYuacQD?=
 =?us-ascii?Q?IQ7s+12P+m40wvTavkowMbGIOErqrAgcgvQbjgFJ/pIpK7WORfrIgTkYpvWP?=
 =?us-ascii?Q?IwcN9afgjKxSxKrEn4FURwc19pxzFAhLECgsf7M/GEdOIGsZusuCuxXmOiCL?=
 =?us-ascii?Q?neDvJE0dWToZD0h2jyEugllvi2Gcr1QfSbdaX3C4SfHOmrGekp3vgIICf1CR?=
 =?us-ascii?Q?XxJuyiQVRLVDiOta5NZFR4/mYPB9KovZ8hweugbLyt18nDd6RknQhSVcvrYK?=
 =?us-ascii?Q?/1Hm3I6Ts5pdLqUfjcgc+xqLHvJS0Q7lgFNhSYF0v1TKqu34tJRn2emxc1D2?=
 =?us-ascii?Q?GJKa7e1Xz7LMyXWbJBDOrqB6KQ7fL90eQa0yZA1LFS90m4EVOXmsf6TYisbg?=
 =?us-ascii?Q?LTAOk73yyKbWE6Gsv5Tf9+NpNnJSzslZq6FlgrkDRey7I/UH+3AnkkOny1ov?=
 =?us-ascii?Q?DiXLpkl7OCMRwWGhrvMAhOv4NnNsXA5PD4oywEZyDAqrA2sGlOvB21GpMjW7?=
 =?us-ascii?Q?Bck0ZmdHjtkwV9WlIypq2qOR68Iq6arLQo53jrh8WUy8p25E/cTycQSAxbw3?=
 =?us-ascii?Q?nWOUi5HdmbJKb94m95NFMHFcLNu6DJv5lZquY3+irxaQFstlsl3TTVfC3Lbe?=
 =?us-ascii?Q?8c+NCFhldt+G+thlqPOdT0ZUGiQHyivC9unharOLNpKxxl5HskFCm6pgE5t5?=
 =?us-ascii?Q?y8bGTxcctzELMFATniaNC3sCw5a98FKkit36c5/wr1+2Unhlsv8Nf78Gz5kb?=
 =?us-ascii?Q?SseS+YFqvOzKQtutAeR9Yy5bUI9rELZALRJnV5KcMUEtJXOFQs9NoE9BGc/D?=
 =?us-ascii?Q?J/nObLrsWRBoRJ3zuSQEekbQHcyPwtH8oMmmXujwz34ipxv1y/+14+mjp/oL?=
 =?us-ascii?Q?xhTeqym22H4pxcz/vv1tMX2oHLpLx5quoEbyJZCFlXfnYbQjMH95TVOtRUwQ?=
 =?us-ascii?Q?jKdtH6164Kl5eMxx8RZE/yWj3QbHhlw/M87S4WaFTTJBoJoTsDxTc0Eg9CGi?=
 =?us-ascii?Q?ZSRcTi8QjgJv54ebD5HQ/28T9DW12XkwydmEUhi97dWAMWPo9tIvOg4CTYzD?=
 =?us-ascii?Q?2mUk0uBFMBc7CMIMQUfRXjP4ml+EPPNhJCkQgicapfXWFP3NX+NmIie2mzDS?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4OZ3XlbiT5R6DcErOXjhh4XHO6ZuapImIhNK1wYYGN9wQMOjDIg1WmQWVTn8RhDM0F6AnYrGYk2D67Qkh6ymlWcdmY2UTvojRArYIJVui3QpfslDk72zYEwbJrzqfybYCo4JMNigI9XablDB7XnhXKPfWkQdCflEuwGJzjTQn4xWHvf1f4GynMUNJe7kF/wUMfodKC5Obc3z3y+4tW0tYVAUE5sYPvfMP4vLgg4EDRgEFjcGv8w3Jso3UTHTDpdc9Wqc4H8mBbYuo72nNvBIZA0ecoifYUsTPR7NpazWiyvP5NJjFs5W2oCIcEgCJrERWkPM18RBnAUnCzSmFUkoH7Vko5xmHmI7G4q4pA3n96/8FDO7o1zvuJFJ2Inj6gIWbU8ULDM9WJs0QYKzkrTczAEg+IYftUbZPaYXKIWcz8GLV5omKMwx9sr/cjYzO4yjrz0bIqJNiGQDE2rvkgxzNjUe4rVyVO/I9t1JHporvvQCiX7WagSpnBtnI7LlOCMtvHffA4aSLwa9zgBdEzYHnfklRYk2Z1HVcHr+1LXbNxG8ZMDUwfxm5opRUxulzeOW7pTtDq2qaZ6qoO+oD3oSAjyLPuvpc9zEr1jrHq4aIDw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad54590-ec32-4cbd-a0c7-08dde486b93d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:55:44.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDghgMJJ59QKpsRNNdYYmYdnLjp8JezKWJyaTdvxdFWhT+t+c7MCc7L9a3BC2hsf6BjEH8rERMx2tE9hbIvwItBa7t87trcfIqDqGIXwj9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfXzWXJR4LS3tXa
 13hm6YUDvFkNB7AkN/C0FMyHj5i02ZZFdZ3T4/kDvYSTKoFKnAqdsv/a8t4vgiZPGb9saHwRZCr
 szALW2fXASsHSAhgRUA2Oa05y14ZCOeMdoJ9WUSzf6LE5uChIUAwygtDDGjrxnBvpIbQah/yhcf
 7af31bDnWJNlT0nAKcI1ozeVtIPDY4YIMquXf8CM5SvA0cUJjcNodxVzd74RlLg8A1oFQCR4Vfx
 BlnbfR/ERhx5huMeI6GhzVTs9nYDJCr9gLpyhMf93ztoSIbdi7bhmzrL18TmOE1RSN0VTPp0f2Z
 QSImBEONg5YSWcGBCNkaaX863yADeko1Eh+vNBN9TW9DFjNUFlYWW9rEWSS3FtLmBhpQV+qICmW
 Se6acTsR/enDo6Mo9P7KIDMYctUPQQ==
X-Proofpoint-ORIG-GUID: d3JeLwyy54ybdITXRcCEsEKni5z_a8q6
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68ad84a3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=gDv30fyark1FSD2aAiEA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: d3JeLwyy54ybdITXRcCEsEKni5z_a8q6
X-Rspamd-Queue-Id: ABAE6A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xcf7qfj9fdjjh7txgj7b3j85ss9it1qa
X-HE-Tag: 1756202151-118328
X-HE-Meta: U2FsdGVkX1+J1vONj3EpmEyzZqK6AmdwdmLAWqTZKSzE/zVbob1NVQjaXXTGbV01hnYVsU2WAW6jJYTvQPqUYW6+eGCriry/Q+EO5sp1hgpVEOVPy4jMImOhPo205d9Vg5/Kgb1A7gmvUcc3tw+vDjPbRW04Zfbvg5oBv3Q1XOFdrb4C1vpRt+eRKsZv0Lh8bzRyLjmDtQgT/wJLiSYY6UD31pKTxa0H+u0pwLBSsupTlNgpcn21qEf2NXgXtWH4Akm+wWbTjk96RW4kFn24RngIny89ZCgyFEqYak4TgoE1EIZ1vpRp21GuSvKL6CN8Jyo3zycNNLfz8lYO2afeoyUgiT37/hFMnZA/fOzGG6IfqLjukCZtnhrxJxpqwvUD8h1mRyxvINPoLqEUOcl38PfIr+ScQ7I3DbnzzXjiY/BN1XJj2e1AYuVFGk4/c+XTvYQ36Eyt5+iT197oE6zTNPZlUW2b4h63yxhH/rVGQDqq7jwPHL59l/Tk0tII916C37UTyLD/LI8tc5dvCh57UN6SuLc2CmlljIsZA8KlHusm0wQwYcY6G9wLCIJ24xqmKGpS0Ou/p+rR2sFOtzclfcTomXYLcHF/QK+aP8htpp3oSD5tK+rvEt2FpJv40VeZXVltev5PQnW/MQxUFvE7cMkXqzenRcxMlsYd7ywjVAb/3Ce8vFpYy8qegxATAlctqr2kf5xEswKbZXHkImrMCyaBIBUQOHTRB3LaDSHhuyd0IF1Yld6IS/1LRipU+YR3yzOBYT6zPdeJ5TsNTVOB5EfAuJftxwUmLnIID4O/5ZvJXiP//G6jUBa8QhHSO25Mep030mcEbjjwMspuci2RsRs3M67S70d1xKVaIFKT9BJRmzgBoX2M61IKS1ytKbajIpIoHbHVCuudyukyiqTvtlSn1RuHyOsLHEu4vugmcqlipyPlnbOHlRa81O7GPR4bgtq/DiG0e+2ZQOi3yXV
 9DRMGE+3
 X+pDl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 03:58:47PM +0900, Harry Yoo wrote:
> While move_ptes() has a comment explaining why rmap locks are needed,
> Documentation/mm/process_addrs.rst does not. Without being aware of that
> comment, I spent hours figuring out how things could go wrong and why,
> in some cases, rmap locks can be safely skipped.
>
> Add a more comprehensive explanation to the documentation to save time
> for others.
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Again great, but needs some fix ups, see below!

> ---
>  Documentation/mm/process_addrs.rst | 32 ++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index be49e2a269e4..ee7c0dba339e 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -744,6 +744,38 @@ You can observe this in the :c:func:`!mremap` implementation in the functions
>  :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
>  side of lock acquisition, invoked ultimately by :c:func:`!move_page_tables`.
>

> +.. note:: If :c:func:`!mremap()` -> :c:func:`!move_ptes()` does not take rmap
> +          locks, :c:func:`!rmap_walk()` may miss a pte for the folio.
> +
> +          The problematic sequence is as follows:
> +
> +          1. :c:func:`!rmap_walk()` checks the destination VMA, finds no pte,
> +             and releases the page table lock.
> +          2. :c:func:`!move_ptes()` moves the page tables from the source to the
> +             destination.
> +          3. :c:func:`!rmap_walk()` checks the source VMA, finds no pte, and
> +             thus rmap walk misses it.
> +
> +          Taking rmap locks in :c:func:`!move_ptes()` ensures that
> +          :c:func:`!rmap_walk()` sees the pte in either the source or
> +          destination VMA.
> +
> +          There are two cases where rmap locks can be skipped:
> +
> +          1. If the source VMA is guaranteed to be visited before the
> +             destination VMA during rmap walk, :c:func:`!rmap_walk()` will
> +             encounter the pte in one of the two VMAs. VMAs associated with
> +             an anon_vma are organized in an interval tree, so the src->dst
> +             order is guaranteed when the source VMA's vm_pgoff precedes
> +             the destination VMA's vm_pgoff.
> +
> +          2. When :c:func:`!exec()` relocates a temporary stack VMA via
> +             :c:func:`!relocate_vma_down()`, there is no separate destination
> +             VMA. Instead, the source VMA is marked as a temporary stack and
> +             relocated. In this case, the folios belonging to the VMA cannot be
> +             migrated until the relocation is complete, avoiding the need to

Again, let's not say migrated, or refer to folios. 'In this case page
tables cannot be modified until...' I'd say something about rmap will check
vma_is_temporary_stack() so there's no need to acquire rmap locks in this
instance.

> +             acquire rmap locks for performance reasons.
> +

This is the wrong place for this.

Here I'm talking about the rmap lock _override_ for instances where we move >=
PMD, you're talking more generally.

So let's move things around a bit:

	Some functions manipulate page table levels above PMD (that is PUD,
	P4D and PGD page tables). Most notable of these is mremap(), which
	is capable of moving higher level page tables.

	-> insert here.

	In these instances, it is required that all locks are taken, that is the
	mmap lock, the VMA lock and the relevant rmap locks.

	^--- then here reword this to:

'In instances where higher level page tables are moved, it is required...'

>  VMA lock internals
>  ------------------
>
> --
> 2.43.0
>

Cheers, Lorenzo


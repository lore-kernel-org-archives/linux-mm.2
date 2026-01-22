Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E507C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B196B009D; Wed, 21 Jan 2026 22:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8066B00BA; Wed, 21 Jan 2026 22:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B726B00BB; Wed, 21 Jan 2026 22:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0538E6B009D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:10:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCB63D518F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:10:25 +0000 (UTC)
X-FDA: 84358121610.10.FC5F513
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 65D7F8000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:10:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OrNCPQSV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nwh4ZODh;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769051422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72OaI9b4MU31b2MbkfRLyaJKkrAvs4rMRPdCj6OoRK8=;
	b=8Tz+K//Jj2RV0j4ZpVdOWuHb3J8MlWwzXDjnowqK9OOtS4EiH0xc2cVZx9yrnfHTlRkjpN
	EIAIylxwTBXQqRCAD1uHlFzYyn/NiMfeDrqFIZDQ+BPoWe7Mj6HRo9ZltRBZAuzNf5QE9j
	5dXi35FWP/w/bXr4idGzMX0hgLjrRsY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OrNCPQSV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nwh4ZODh;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769051422; a=rsa-sha256;
	cv=pass;
	b=cjHG+ro1RgxbhIEjxmCMNr6Yf62+i9JI9s6EkMWPPz2LDfcffvIIxY8SGWL4t3P9X+FPe4
	RqId/vEeNBY6kuxefoPoB6zBPimnFIkgOcZp8dVlDte5jYqMBU+lugmn0wDMTaibObi6NN
	2MZBGSzdYbfk0CPCHrvUK/vsKkp/7YU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LLW82F3418983;
	Thu, 22 Jan 2026 03:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=72OaI9b4MU31b2Mbkf
	RLyaJKkrAvs4rMRPdCj6OoRK8=; b=OrNCPQSVs4ugf1C6fTEmAr3zyuM3mH3bO8
	cvTWtq9DW5Q6cGxXg0591Q3rcecVwIhrz3ozH7Ka9/2eqAm0Au4WhMk3ZUHmWXwV
	jx5c3nbRyzdTx8Bjdi7IiVFUfqrA3wkhsTC09zEiuXcXZviczkCt46PuCXGUaPMp
	sOZQ6ei61L/BLxvYDN0Qs0eIHTAcmUzs+QpGHt392s5EmoJvtZIxbE41ISwCMH0t
	mAb0MLR/RfqwfYGT+YQZxMAcwhrjgEjzfPuLgIVUwNFTHdxr4rMYqzrlJS7JBjFV
	pcJv82wSrqAj8v7x3uReMaUfTkNhwMWXAXy5KqjNqY8AW5pst1tg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9q884-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 03:10:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M16jWL018185;
	Thu, 22 Jan 2026 03:10:16 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vc7q2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 03:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJQEvLXPuP1QQ2EuWTuii7Pbhm1MAPGI1IIwn6VFgWEqPKFGvfV7Iq+rl7xDltMPZei+1LRgM8VhaSa+kQpYfXRBlzUFgmIJi9BYXU6NilhvlUORnipk+DVz4ut7/74IJr8PUQFjYFaI0JRVIKzs9/IsIhUgb95H0qUMXVJEQ2sCOxOiGPlY54Sn/YkbTnWoa3L5Y8w78aeEHnkomPWJKTNtbdJJ8+0Drbp9/WICBRephuSTfrYWk6lmEeFA5Ji7/OJiZhESDAjHDLjVbyVnJJbFNF5tquQSpJ6uCwRV+oBi6cmvNGehubWNgKM94YAaY/iG44AHIHrkRsqUSJnU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72OaI9b4MU31b2MbkfRLyaJKkrAvs4rMRPdCj6OoRK8=;
 b=JfYLFV0U48MmDgWdNoPTRtKFC66/gQfuqbTCdodeFGQEMQ/4bdlvk6/pAV4uz0W83SaJU/psPxKs1zClVEoTZh2kA8NU06jtsf/7z7OwzGLnenuVTlTV5RPJsOqbCgfULe42Bs1EbpV3MtHayTwvh3N/8iJYGwbKUL1gJkMhkx3ny9xf4YwWuZhfAuz0mOXehJ9XeXoV/N5gTy1btBOLPyEZZYlCaW9xbGJh4tUByYRnD+CCv8bBHWYx1o3dEiaT45JfVJ0tLkHMIQm0xek4UkoekNlH6FxeslkRUAwm15Q/nD6MA9NhJ+8qDQsiO5Dr/y0MIJHbuba/Hq0ozwu1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72OaI9b4MU31b2MbkfRLyaJKkrAvs4rMRPdCj6OoRK8=;
 b=Nwh4ZODh5KQ4NE4kEkqlqO6Rf+wwZ/dyDLG4UC4K+SwIEVt5LnBlDeoubs9AnM2KFRqolt0L8JAgIFIvOTnEiWjvurZR6i+ArsHcWHwhAVGC6blAl+VbguG41KbtsHXAiXmNstMH9mdzrBYqwbaUm1cBHJAtQQeZ/kwO1hcM4C4=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 BLAPR10MB4851.namprd10.prod.outlook.com (2603:10b6:208:332::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 03:10:13 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 03:10:13 +0000
Date: Thu, 22 Jan 2026 12:10:02 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 15/21] slab: remove struct kmem_cache_cpu
Message-ID: <aXGVCmvvt2N3Xcgd@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
X-ClientProxiedBy: SL2P216CA0098.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|BLAPR10MB4851:EE_
X-MS-Office365-Filtering-Correlation-Id: a9fd12d1-ede6-4cba-00fc-08de5963c1b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hYf7o9xjwDz5DWdQhxaP94fMVt4AMlGz2YhMPOp36SJDaxQSjDX29gIR2G4i?=
 =?us-ascii?Q?D+4a78fs64uxmoYLIvVsRbIhIH4tDTIlQLpGUZjOICFRyrawR2tg64W3TMxc?=
 =?us-ascii?Q?yc+lKwKgU8NIHr/klu56c7sq7GJOTrQwPk2oXCKU0+fOiwOK81gl0E9+hVuH?=
 =?us-ascii?Q?1mkUAwQQ2JtI/9mQ3iRuNZAqHMaJmCk0aafuLesXpJE7hYX+Z3rMVjFNvFbk?=
 =?us-ascii?Q?ObcJ6hCaBS9F1wCy3l1he3wcsVelfrQ+ogm+mql3BNN8WMi6ZuasXPY3/C51?=
 =?us-ascii?Q?1mVNNnMrqAGQSywfFqFRo9BBylE9QzQiVvTlmja3AdYxQzWhcQXUagCbXujN?=
 =?us-ascii?Q?nHHgUhuN/pT0jaLkhYSJWMdBCsurB+qL9bBrzfW7uCutXr5UDbjrPUZ5ejsV?=
 =?us-ascii?Q?hNPEVejGqGEjnI8mdoZw1N+QmC46x62nwFH5xq5bFOvwQ9feJJQ/C7vt3mz+?=
 =?us-ascii?Q?fMPr6PLwfvBa4BoWTUzDQpLImMpSz9Mw9/Z93oYvMeWKEfrxCsPlkW/SZjo4?=
 =?us-ascii?Q?sSFjTaX43eMX/hHs1HGhTb8E14Dw7qrEWElTmE0nLtQeBYR6XwAWp6c+X3jY?=
 =?us-ascii?Q?KvguJqp8nKh0mT0u7NOPEVdUNT5GXUHyDUB6drffxm41sZWIvxxf3+taVnhs?=
 =?us-ascii?Q?2/oToB9PeI2pcvPHoc4H9AqRIG1y1XFOgouno/NOQcg2zyR9Kos6BI6OcroO?=
 =?us-ascii?Q?4UZhXj+A2XSLfVqiVLLjvCIq4B4vPT7+okYn/JmgY+kepnXbAkx+vQaCY6Sc?=
 =?us-ascii?Q?6sVQvGehM8T9of5yQP/Ec8PoHPyPU+lkJ8DhdmzHgl+XEh773xrYdSM4qibF?=
 =?us-ascii?Q?o9+4ZR9ANa+79KUNlCVl4zq6g0j/MIieGIOWPbMWLmBlavbtwtBqs38dsaUq?=
 =?us-ascii?Q?LgCr4KgxofdckeOZ7YZv4XOX4MnYPHiwyjulzt6gaBh9gvp5l6BIwC1YaDoM?=
 =?us-ascii?Q?lrIpT5pe41xPpgbB7u3Y1x+ZJW7SQeley/8AzywUdhy2Kknt3iSfwBm45/43?=
 =?us-ascii?Q?gzMhJFZ4CX+TH2I3OXfWZvUDOxK+c8Ie3DSdfXtCeYmoO8QT6l4sLgzFR7me?=
 =?us-ascii?Q?/qbdn6iwyBvxYd6D/vh3gouO0UJuEnD8EOaJlPDKpt6QBBie8v/nMYgt+u12?=
 =?us-ascii?Q?zIJx9CVF1Um1cdlIhURZ5+qiFFhtDPfvZExIjUVPVr8Hb7kKpFGBocE7HExp?=
 =?us-ascii?Q?vinCmjVWOk1CFdW6cySAf3wSZkKX55oInYEJe+K5soGnMqaA6Vt/6cO54Feg?=
 =?us-ascii?Q?TaX8N9RXX9bdKlJ4+xNap4gXznIy4PpTd+65OKe0/X/w7LAG+5eWYOPz8rGq?=
 =?us-ascii?Q?27Wcmc/ze/3rZfLO1a4cvuffZAPnUPKUBRX15CT9pMnX4VujuALUuNiSFFHJ?=
 =?us-ascii?Q?9X2q1G8GW3ZPboZctzRqWclZL7+nNe9wuRFFcH1qY2rmNAG96HiHdvuSChnS?=
 =?us-ascii?Q?AU0GWtEosU3tqO+6uG33HT1hYYduIjw9ZLWXKWmuBI/kQcf74rrdm0rnunGV?=
 =?us-ascii?Q?2g8IL7OH6Uhm725cVMXbl3uiV3C1emWliIWcAB0DGdVU2kEzKtnzuW+buYsO?=
 =?us-ascii?Q?01tZbKUWGKTWRYBOh2c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T6frYYNnKLHspwTDYTJZkIY+OaF5SBAZblnc8qm6o84ABS2F5OYPJgaQ4OjC?=
 =?us-ascii?Q?bAjkt6Gh0+CE2grpRRB2QyWPauubdpZ6lPv2daOOLn5LyEAs3nahxPnizwfl?=
 =?us-ascii?Q?+VXbiK3cvttt16cmRHgRxmrdHnsuvI2I1mlX0arP8IMxyO/X9iOZI9Ax521A?=
 =?us-ascii?Q?vUFkPk/Q+KBqDLO4KmwNwBdMSIeznc4qYBLJecDgcr0qxNXLqrwE3QBNVXW4?=
 =?us-ascii?Q?yHsXMBtKVfnENPEsVb8LkAYXL6kuBmzda1rKysuIoBDutkHjs79YTF5DNL2b?=
 =?us-ascii?Q?vgG82ZcZ1Xy4nz56qbz0U9Dtx5YFpVDvMkPUVc4G6gXh8rWt+azGookLMgBL?=
 =?us-ascii?Q?D8Wjx8J2YQA9GSN8e3/kjtclax30SfHAVC0XWTgA2mZtcT8XESqb2d/tfhCs?=
 =?us-ascii?Q?AW36LprXMH6IsGT+t7QW3aXmDHjylulYqU+gj0uT4YryAbYk2FfUcar7qO0q?=
 =?us-ascii?Q?hBLb8GBlbqidvh3RBUBMH7gMsGYb6GEaxHEnVRnoR9a3PBe4fzOkBJNCEmJ+?=
 =?us-ascii?Q?Jn5zS9K9i8tg7g+tHaC0LsKFTURm1QkINcRu/sYAgaV1FMyHkbOeZtJPbiyC?=
 =?us-ascii?Q?gx/xEOi+ojBhpuM09PszmT5ghn6hkEI/jewfLhfKbsz0pVXiaVMCX2jXfQUX?=
 =?us-ascii?Q?ujMliSCXsJrMLcY9tbXU7hLU9JkCTiwIvB3LnUEz467c4po/vvD8LtiOl14v?=
 =?us-ascii?Q?LyB27Vioa6e5aMjsf8WoamRwrClNOUV5MPQzJR/8AfeRnl3w/k5PQeLGdRCR?=
 =?us-ascii?Q?2DL2NIYWl3Vr1JGgP21ONiQaIoOqEj0C8QNbqULlxnLyOrCIpkBSCG9Zcf4e?=
 =?us-ascii?Q?sJCj9fW29+mAZQJQMgrO0CLWClbP+CZlTtX20b6hB7Uallp2NK/2jvLsEdBG?=
 =?us-ascii?Q?APdEmW+IpuziWjecQV5nuLmfWcTFMdhBjCleKjEnfBHI9dPowddj3Or7Q6dM?=
 =?us-ascii?Q?PWtdXq5pRYBloCytZj8biPiJUFyPfNhycdaxRvsuu8OA/WoDWG5Y7o6K6W9z?=
 =?us-ascii?Q?ml0tkF4nuQk6LlGTdAWkBNrNYlVqulvIGiwTzqwGg4a9z2xxlO1t6Y+MeJzN?=
 =?us-ascii?Q?SdQZL+6iLabwM/cqFknlTYExxylMjBtJeZJANq7/7brikrCEahgVOC1u28oV?=
 =?us-ascii?Q?udE1kEqWCeD8TH/zXuy4QkkfapcpedXUmGG93drFHWVmCJtHLthEMqd7C15A?=
 =?us-ascii?Q?/LHCpSnSa5OlMexijVde7A4cUnWINBszj09dOIE1BpPUvN4oab9kZqS2y16H?=
 =?us-ascii?Q?kOkGGewLTYa3I26OyrDL35W5TLBKY45WjuAdZEHd4p2seubw+CNdnM+CQHTL?=
 =?us-ascii?Q?25N7Vts01Cl+eyTEbrWijIthPPfpPnQmeBiQWpRkz2i+BG5oowcCYcMnv1U1?=
 =?us-ascii?Q?R+cR7qknRmDVm2bNbkwpm9chztR5SZ8QHcOQ/8ANZP7eJkMVd3FiVzcpBaeb?=
 =?us-ascii?Q?hZ4N1F4idhAiQUC11ZH1YDoMLWI4rk3yFKe68hhNBvA4wVoLsWN3/8ulVEsC?=
 =?us-ascii?Q?xTdZb9uTNeshVBCuPekLd2K3+7aofMfr1RAfx35mmmR1pZIDjvlOAozjCphj?=
 =?us-ascii?Q?w1zdv51E4qf3Jn08BVkuKWFyR1/nCLKGdts7I72HxeCowrxdEBGWc/Q+JHHc?=
 =?us-ascii?Q?JH4+kyN28MiWDzGkpUAFbTHvWmIhpkriq6NpFuHD0cScVmSKN6aqJUwjp4AY?=
 =?us-ascii?Q?fLVZb1N4zhPjNpVdXAn+rUKAeqZUUX6f6bMBBLCFwEMgBixAA5SdrklsL4vr?=
 =?us-ascii?Q?KKDMheVWbw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vqyMt9gN59VRF7fuJMuyp+zmmVu+LUdsfJlgWg1MA6QWDBcecsPx+zaSGlwgiWoQ8ZXSX7fWl0YFfPLNG0ZHKlHsHDkvRN4TQhfgkJHA9fuibIhRPua10treSM8snlqacMeNvtBdhRIFpv7eTFI/xadg3d7GamwDEpHv/+XWrR7KwtI+1GWCnDonViMG/8tVU/6ViAbIkmYGXdBRUpCuz+uditEuAJhKnwPgWJ/BEMRF8GSY3xqSf676tyRPIOiACsvKJ+3maF4mOZtKjRnw8idfY08+gd9VxcDcB6tKvt6A72NF7yF16S68/vCAijceyYib+vCYsVkCLO+KbSm9PrWTL9GLB0Q6EoIaQlvyEaTFT8pclJYIV4VwyONK+vZcrS1k6UlEE8XD//ikvJgr9k8swww5mVJf4j38D/W593BN63X9u9tLTrv9v51pKLHTQPGFmECWHXuVRYhvwQ4isqxB1IyzXU5TS/AgSLDD8HR+2SiKSL7QPzn+4QtwH4ewbMw5F4nU41AGURAI7UBaVTMDKRP5PEd2/U95O4kuyOm1muF6jsdNMOaAsQfwRe8RFJ15dP4wQ39YbQpimXG0SERHxhqbKO+HESEQxbPeQCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fd12d1-ede6-4cba-00fc-08de5963c1b2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 03:10:13.2024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgDOIc4kqsD/ripoLZbHaoJcl6x7n2BustTdyYnIUgK4aWhA4SmggnLnxVGGfdATgSHV8qo7ZA+VEFpfIJ3RwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220022
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69719519 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=-YXiLwkaz6cLH1okR_wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: bQQIkjIhccBHOJSL85FTgF0rxBTCfDLw
X-Proofpoint-ORIG-GUID: bQQIkjIhccBHOJSL85FTgF0rxBTCfDLw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDAyMiBTYWx0ZWRfXyAKcan9IG9tP
 2IeiJYtyuEFDBfvGkzdXgb3FErPCh9+Dqm/TZX+cHWkY/eL8k5yaJVyuk9tQ+g7+v2u6EFpEsmw
 2atbP+GGG/JOS4ReZmVufE8JAEwnwPauH5UeKvxdb1UCaocIkhaWJUeAGY7u0cL2tzmiQapVvVL
 bL9qgLAjk36yqCfmuK1zgl33p+kqRlqj3MOxUM/5D1ZCNRfp8xXLuYIwt677Pe+JZvl6BFyxRgh
 6lvM+7VbQyTYuCThqbbpbiXn8cE2oZ5osNcov+qj/586midJoA2YM335/aTxeIfLKZX8bLFNeNC
 NiAL07TETb6c7puegLeMX+BDVsyV6HdbL1ieUCVB86P51bQEY32Xrh7UBIW3gTIOzhrmPq6aOqF
 sEBQoYDRzx2UW6LSa6uGI1RWx7nirvy5Sm8/AvuCexR+vhc2K4CJctBtxxwVNTmP/m0QghqqW6/
 X5y41VBOwatzgZMR37g==
X-Rspamd-Server: rspam11
X-Stat-Signature: bhh55h4phjc8dnioq1h6qkxdrztyr679
X-Rspam-User: 
X-Rspamd-Queue-Id: 65D7F8000A
X-HE-Tag: 1769051422-104365
X-HE-Meta: U2FsdGVkX1+8npW0+uR98GfUUS5xAheQPlaWWxPK2KUOP6lH8LlxIebhtice8a0KYvGvgw1hnkNAHVEGxXrJSxOQlcamsFfbQineUKEUUXsbuPehoHiSYTJWS54lrysDh2pDLnxr/4M2hiyezzX0cVwn2zZIGuQAmCpTndwaYFjIV+u+1xdKlXjBgHuRsZAajyh0fY+snEhjTAsS6Wd6HoUCv2yIdVys+hbSeB2WrZ1c3A4+0oXYrj+PKeTQFdLDCmvPvaGdyEetwacP6hOKLZGOjzkY8Cp6bm2/KV12P9iu37OoLA/LUzqQD99vGb+pWvPV4FLwSl1ZeUAdmhPFSQ11a/x6xS15Vp35BgfXhAPltIaCXGc2QasEAQBzNY/PrZS1NYgYlIn5OIB62SPVez1nt5J2xa4aX59hke429RWlP00rXgx9/LItBZJlASDBQjuoz50k6OZhmT+BjTE5EOizk+EPSrWxxTizd5+Z3UZA1Rqi01/Z45miS0y06qCWnVhlpeMY+jyse21+VQNTwrtgsTZuY6WXTZitlGV63nkOzr+AmNqgKqYDx2sZzgL+bA5SkJDO/YsBY8nXUu/cZG2QXCZig7h/xJ1YZaRSxaIQMgtdXysw9G0NA/REK1OHTWajSuPr2avCWCxZZC+BhOOGobsN4fbVE+OtRh0ANj7sHwBfHCCqwUNXd8VopV4VZfW0UDOpxzfA1IE8gZa07Rj4Yn9XUD+6FQdH0XM8jiw5FcEZbR6ys6aOuz0qNwygKl69pllyiCtmLJyRQSFQbeao7RxTvdeZIg5tvPbQ/XU3CfJtD+v7KdZTXyQ7sGgwo1IOqzLXyVCK1Q+dW43Lo5uwA8HLnhfiAMeTZU+Lh+TIt3taUS7hiAWhaDO6s1NZpkuvVu+KaewvmjIjGWpk5loL8YElQh0ZcJSkbfaGIwEExhvNJ9Ye+M2a/QY/du6a8QjQv7TIQIcWuMyVnPA
 nNVh6LJs
 0ZQU2BYcSmz5Aiqmlfi8zMikyqb7k/fliqMcrXdAh6eqBn2GQVv6odS7jUspLeCxTpxhbTIWJbobsjdfkt3vl6dmwJZz5TcCPPUUi7pQ50UcVzjmcGe/bqAd8gKoBPoh0tTbv2AsM34C/ZMJ4Fm86oNLJb6KL2iC5db2Z+nIM8UZ0p/pHQ25Wwml1kneUlTWFeh+sLpjAlSa7UmctS2YrwyEGRnSavxPzQK4K6E+ficK7kK/WeuaToMVRXBX374x2pN8QL9U+9VDWXAzyrk6+PtmfhKv2XYM7+9xuxKg8yicw1qsgj5FhkI9uvJ5aFeFXVKnztJS98E0IIxH1L9BzNG9cJsMQgcYsme+9pBy3QSSnltym86SOe8YqKRWfp9J06svaKkPbkQtAuElH885w+7paSocCq5jZp6l4I+Aw+UkWch3PU6ndjFvrHL6mVTyLiJg9dIrnKR4+zkkRx4pdT0zbfcA+GyG8nze1Jwd4WcyFLZBmheZrJUvdUwewlFp1fJmBtiizCugeROv1HREXlMhC5Juq2SqnOO4PNBVNE6v/XAXuBmukKp6tEYNIc55RioUVY5gNL7Pff+LSeOR+CsuWg0Xgs05Ly1KfAb2Hg8cas9cauIbP8tmgNOedMpyC8UWjXzf8bz4scMuTrgwPFCPzJ0/15HiBtzft7hEX80PWhuJON+Al4SneKhcbNj5RSFJK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:35PM +0100, Vlastimil Babka wrote:
> The cpu slab is not used anymore for allocation or freeing, the
> remaining code is for flushing, but it's effectively dead.  Remove the
> whole struct kmem_cache_cpu, the flushing code and other orphaned
> functions.
> 
> The remaining used field of kmem_cache_cpu is the stat array with
> CONFIG_SLUB_STATS. Put it instead in a new struct kmem_cache_stats.
> In struct kmem_cache, the field is cpu_stats and placed near the
> end of the struct.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon


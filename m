Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14802D4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772766B00D4; Thu, 15 Jan 2026 13:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F036B00D5; Thu, 15 Jan 2026 13:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3BC6B00D6; Thu, 15 Jan 2026 13:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45D4E6B00D4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:29:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06448C1C9C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:29:29 +0000 (UTC)
X-FDA: 84335036058.14.EF1144D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB1E21C000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:29:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DuEJ/RYb";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uvwERrkB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501765; a=rsa-sha256;
	cv=pass;
	b=xk8hDxAVmSPQFatXomNmj4NqUMsWvzC0oKTx969EFurUJdjR678X7QDHBb3F5TUA+pRq3Y
	PtGUTXSSTrmL2UHeDxNLYAYAuRwaNGhARbA6wdHEtD97aswUYgonRpLne4IFps3XNwtTpQ
	5551jtntpror2zT8TTrKDb5nJxhYxs8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DuEJ/RYb";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uvwERrkB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
	b=Tyg8Ud3rRJBbStoWmb9CPX6iz3AfbKQ0cAwsx3y3R9fIhiPlCj4fvOlDVH/lVkiuy+82gV
	lrFb71jpTg/LLzEzcBoC6HTryMtC/rcqFD7dLao5eQmI5jQK4EZPVSLhZJBnvNnbIcsWOr
	8YDS9DEmylx/JNLXtr/lIuaPjJ9cAYg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDdln62685997;
	Thu, 15 Jan 2026 18:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=; b=
	DuEJ/RYbjOrpBEk1OmWKrIHn9Q2s8NqvswHF4zs1kXjHtJKJlMwoT7ECNjGQrN5J
	TbHUxG/AQ58z61S1HCFsC4WLHE7tTxo2aZDLzo0w3Pk+0DR4ISpkIVuU9aR8N/v+
	lLCHVZN3lWjJwUrhmCh4Q1IF8IyDElOuPxWlyZ0JqtsOlNvFNbEa7DkIM4wcr4z9
	vz5EeE/X0Vy7YQC1Klua8R0q74yIP35tpp8qIb3ymkPHAScTpyCSQ8gyl+mM8NXe
	s+4JDTO0oB6TpSHkEdagNan5tCbNqZSmTb2NOYSgLHwAJLe/rsxFVBc4IvOXPOyV
	SeoJjROWAAyqkBbUNMY3Qg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb8em3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:29:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FH0fkX029173;
	Thu, 15 Jan 2026 18:29:13 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ndyn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lis0XJLNPr00aZEq3BP5Fq69ZRQdCyUoAIr/GQ+rIep/14ttrTE/jDkOH8c+vrMJvmQCTBBswWumDqIdhxzlC66KJZMxeAVsD5oT1YTVHprPtHCDyBbg9oVcM29jYPyciU8jv2+asB0WA9Y0HC8SSbEG71V5GQ3bjtgntx23vjYcV7QQMTvWPblP9PDEj9sEZORt+ReyhfgTisaYMRNNRZz8jb4pf2msZVJk9O+w5aSPGR/kJXhkHg7aofG15XG6cbQwmBjwEQbf6/8Ld8gUJClPzAPd/ENC8tlPImpKDbwUZI40hi64pzGiR4m53Kabk8JmZ/58SWWtDtjBLMkYlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
 b=f2LnOERx8Ps/IEk6wwJ3SalITMkksbm3FKnVtznjMcwS3TSupWkv4UFd7IJa2TxzTLDgJQz+a7/X8UX87LHzU3DUO+HvghadHuq+z21gFa+5rByD9hoV8H9Vgvwe6rOOD6Qhxqg192f7AoJCoLPSGSYDnlR+8LrDYhV0/1VPlaUaFsA8EkF49xlUvjIa+wLq2MtfZJO308ofwVGva5rUDWRB/v94UCRll5P/OIk2oOXyyKc34N7YwAFgYWNsUHl1wS4DjZexaV9t8xXwOv1NyJz10WwEo3omYNqdBsF/yZNvaesuY3yhM+bpNLr62J+tsdYR8huqBrF2RD2/Q4Jcrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
 b=uvwERrkBuH0Wz/TZgRGAZnBSgl91eBgvtsrWPHiKm9ZVcpEomp1nvc0bRw4Tz1MpgWvZe4ZLjRYaYhnnXmZHRomQO3aLglaC1EyQ3nktC/9MVaVe+OUFu4wS2714XeWKfeSRsYV9813e607qXATUmeqINss9d5esOG9kLn+IYhY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8181.namprd10.prod.outlook.com (2603:10b6:806:43b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:47 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 10/10] mm: Use unmap_desc struct for freeing page tables.
Date: Thu, 15 Jan 2026 13:27:20 -0500
Message-ID: <20260115182720.1691130-11-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0039.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c82cbc5-d29d-46e1-bf5d-08de5463c819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ngj1T3CAtZbgjK+Z757PloOrR33bUAArKXPnszKjHYggtDO55mNvVtyYbLNb?=
 =?us-ascii?Q?PUHZpdTuMmjP273xA5VqBz17MUYgKagpVecUb+DmFkQi0n4tP3UsMMvkpOs6?=
 =?us-ascii?Q?hfoLF9a33ibqov/KWKrwpTYPkI6Ky11MTlRYOxC9cgdc80P1YnsxiuMQp+br?=
 =?us-ascii?Q?+bs7pEmMIFsjVv0wdo8DcsJxt/ZFKuPvqMS6+sdnYA+KTM42ZhDk4mOHpV0E?=
 =?us-ascii?Q?KohjwgbY5skahpjcZ1KKmkrJm1Xnnq2kUYbYXR5ukpCSBfZfcUr9q0B9DAa5?=
 =?us-ascii?Q?jlYCEjXaL+MVdvqecHoczsJsXNvjnRpxbSf2jwhOpprg+iahOGlQSeBeZu7j?=
 =?us-ascii?Q?LrgF1JS425vJwpZEnXW1qDHNjkpawCXBBaoJSXQBzFdIixZPEPl5AnE9uplu?=
 =?us-ascii?Q?k5MOXIKZILmKBz7YhAst/Ep0c8OlJqwfpgq4W3Q7o17RErIOqSj6K9a8o2Ez?=
 =?us-ascii?Q?yODzg+0o2ji3juk71hhhxY9B1bm+0wNbshjww1o7hTQXpqAO2q8PHnyLN+TL?=
 =?us-ascii?Q?L2WGw9H2LJJsFajUVE6mxRY1cBCAvUgwbEgDtwdarcdQt8E/rLOnGt/vxlXv?=
 =?us-ascii?Q?DpwwBWO4h6iJ6zj9I+GtpQdFoQD0Qj/GwpqRjD0Jj7Y242WvdSG1MDqtfjP7?=
 =?us-ascii?Q?LXh/8KEOy94gNWn0+CpOiPerFbbis7VudeYZF7xyRXimIX5XRhAIYhsVFGg0?=
 =?us-ascii?Q?aXivErcAxpCW7QC6S2sLCHT6QhljvTCJCJa845QOu4PET7gKg1pC4AhjTuhX?=
 =?us-ascii?Q?n/aX6erDnogzB54k8SY8z5WvtrhCOB/BLQAHZ9nEdV6nQ0O6HUYhG0q30or7?=
 =?us-ascii?Q?ZD4k7LkIRQpW2KC9124BqT/SGAZ+jfIVy/syVJwUizBDU9N1UZldVGo3ANoE?=
 =?us-ascii?Q?fYtUuyRDLUhuikQNjZH8NyIqPClgnHwAs1EXm3FVFP1Je13irM4ONkxLXjRQ?=
 =?us-ascii?Q?wc6+h9GiuPYPBDOs1rJZwxr1an+5fL55QG8AnYN8I8jn+qgFs3azyA/GM5U3?=
 =?us-ascii?Q?+M9weFn7pB8vWYWbrpBlUuSeGN6mf3vwEs1YO+7TUe00tCVlRGqUnU50K8SI?=
 =?us-ascii?Q?+56T+J5sQQL7TJY7LgOkZPaK6p6RD0mXdqAg7Pm3IaeIUmBs5k1jClu6EEl4?=
 =?us-ascii?Q?iSoZLcacUdwN7UjFFQ+9ZsPteAcljzhlYrrKLwePMipf2owiP4OnM/fHtdFq?=
 =?us-ascii?Q?NUpX76jRmBxsX8rnoacWWez7Z6FKVTlxm8R75AeIsK8INmtx6gyz7D+Pr2lo?=
 =?us-ascii?Q?fZ2BvW5H7Y81jwWq1bew+0wm+7nnnEFeTY73uBYD1gvSwCN/6AYKBFY5ExTc?=
 =?us-ascii?Q?UO1EV3HfKIjACeOFOwK+DNQU6ko4I4hDO4F7GKv1qM9uU8fukGhvmOEsMany?=
 =?us-ascii?Q?OnaVxF9q6goRz//mvOKdyGXxrFM4AzYd4ZoRLXiVAVq1oQIOGU8bx/Gnbv0T?=
 =?us-ascii?Q?vv4g6ySJgcvuf86R3WS9PVBUk+0kciRSi5R+K9pOLPs9c2CtNhWX/qIdq2HY?=
 =?us-ascii?Q?hIcl+nb1W1wk8y6bVCCpd3+PKxPn0++XV4Y4sxrmhDWVYSWRgtcc6MH/mkqu?=
 =?us-ascii?Q?3/H2R7BZPqQjZ57utz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mlga2VOw0xenaARMXgSWhqNt780rW37YaVGprUT0O2/jb+bP9Ebf6rDOtunb?=
 =?us-ascii?Q?q/JA2DKtmTz5UR+qBHCl5vq9tUvpb/4WvbwhnRX1TCzZaBzc0x2Ev2XHs2G2?=
 =?us-ascii?Q?/1Owq/WEHM8NcXJ3U6KCZLI/d7YN8h4P0GaJpTrVi0N8ULYmNGyi3vF/1EbZ?=
 =?us-ascii?Q?Uk3sapDxYwc/6OYAkOlRw+zaCQMzzz22MGqACycuDn7nw1aTrqvVGgM/HYVX?=
 =?us-ascii?Q?UrlzeuoQmQ50fci8tRDw9/pc4O+nadtg6N86p8aH0XkUmunmmTQgqlP+85Tl?=
 =?us-ascii?Q?PK9bYbQImvFL+G9EkoKkM2MM1HSd3ZvkpvH/fmcf3Wu7I54R7qMQllNf0sQW?=
 =?us-ascii?Q?X4BzWNRVJjyemcgK08uXgdgHUB1H/4VC/1Dm1w5wqLAaMm/GK08pQMgWue4M?=
 =?us-ascii?Q?Hm7/Le0Ou21m82DanrzhOfxlHem7wFGsT//p7bGbIH2TG7JoF0OXbmkhkAZu?=
 =?us-ascii?Q?BpXom1ILwNh2bi1c+yEtSfZh1Sfl2Mr5MiWLQtq7xqFxPNzBQHXOiitZwjZy?=
 =?us-ascii?Q?2BPCeQxW9XQou+FVxYb3u/5JVJQ3nBsrmEvDm8GA+seng8MJ/7NSYbn0CsPQ?=
 =?us-ascii?Q?EOcy0XI3njPhFCPUr2PssDDLvOIhyS7ow3EZzLEBtdiITfZw5PWomFUTvBAR?=
 =?us-ascii?Q?PmjEocIv33dxAuDa1hVBl7OpVG//UReHjumKiMZd5duDnxDOqYffMkScTC/5?=
 =?us-ascii?Q?mVHgyR3jywD8+qdqiPRLN50Eb4SC/slR1mq9RAAw7XvX/9YpYsCrSkHhQjrq?=
 =?us-ascii?Q?BDVcD2V/iYprjLfkwVnGQJO4p6Hz7uxef4LJP2bI24L/Pki5UcFVkeg+DX3U?=
 =?us-ascii?Q?qGa9KLFrwt3yHZO7FiOWpyhgcNjg30gdZ8DoIGetUGEWQ44q0+aIlbCTPLhX?=
 =?us-ascii?Q?tJEAg8uwbhI8WfLlG3iOLnQTQ+2DcHKSJIXCy5PmBffYzkEctjD5IUEaS9ko?=
 =?us-ascii?Q?w64pJ9wj65pOKcBZ5aMCAtbdFxcL7IAwQ/KgtS1M0yIi/KyhXDPJmFasbW1A?=
 =?us-ascii?Q?tHEn7aGtf4nTuQBVNqHE1v5Y4VLiDXgmup3mTVQ/liY4PH0hVNXROZm4jDlH?=
 =?us-ascii?Q?NKaNgNZl910dLyEYnwzVH0sziGwaoZzl8CZBUdXld/brptoR6l+5AiLc7uy9?=
 =?us-ascii?Q?hF+DZsJDBsn98HRKiG/ij8GUB+rOsMVqWu79vsIHngreYiZRb12+f6KSOzBQ?=
 =?us-ascii?Q?UKwhee/2lPYU9UmLVqLOF+IwwWHcrTkrdcb+kDLj25Za0Neukr+XYAFXREB5?=
 =?us-ascii?Q?ECzOoG2F45XJ80+u8NO8AAJkxGsPQV9EIQH0wgWFPLueZV+GYELEWjzu7taG?=
 =?us-ascii?Q?QR1sIbx7WLJX7ZCz+5JKd6cjSSW0Zwrf7bAHGRzustjcOUOZlRiE1gnW41j3?=
 =?us-ascii?Q?l1H9RL4LVbz/uvE/O/CjMCld5ZFEJNdd8n3KU4LXG01qa7QJ5ffROqgEk18W?=
 =?us-ascii?Q?Nvc4gQ9JpIZjC+iWbTnN66XgCUdUils4/EQW8r5pQMLkP3KQ9ge87zWHbwGp?=
 =?us-ascii?Q?MxNnkSfMdXto+zdTaU39CnLCEgUUROH5tu/2Gvmbl6NdUu5Ok20rucFg4zhQ?=
 =?us-ascii?Q?O2RCUD0N5TYulDhIzQPrR65Ox2d86UaBknZyBAGgyv5cC9cZrU8N4dp5ySVF?=
 =?us-ascii?Q?7kKy+IaxTuoE35QLj1GB2r7gvGnCW8X+DBzwZTH3GY1Er6m/oGhBfroWFP8O?=
 =?us-ascii?Q?UB/3GQyscN1droWT192PgNaBY7szRr2IB9PQ1W4vmcgHM5bZa4PbImy2ROVT?=
 =?us-ascii?Q?B/d+8Lbgkg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jBmzp8lcBc7Witl0CLKSieEbgje5D6ngRgwoRIIQTCuddV7+QlTqnK4sPd/sSq+BUj2RM/+h5oY4MHRknyTNIsmpj6Q0/3J+KrSV9xUZsJDEGSOz7Sp3l2TpVzC7265MTN1Pyd+QIFtKmGBYJswZAa6Ol3jO7WM2vK2Hv/8I2vvx0mJy6XtlF1gOyd9cIUrwNS0U5kWiH5sbxAr1PNUeN4rB7fC+5VLXifCBbhNzUHaMYnEcualWLUmj2gW8Imfij7mD57n3LGDFJ9aODDtMXfqndv1ZujTdDDAL1SVTP5UwRf08oj2wsrxrEyqrzWYO3AIDIhMrTmaOc4zzSdmmHTnL30Rnh7I34nt1fhk9JGTK1doWpTRNPuIDLuT8qw1HX7z7LY+VC6pq4+eMTwyT3Ut5APvXdwSvSIXQXBq0Pr5IfTvKQcc7BVC6tRvGGOrDj7dpitKJdjJdPlmF200AmaVWXBXr9tgZydCzIkxuju82ne5djvdpiMVJt/WpQpHjPFUF4o9L8CC9voci4b9+ffaYe3vIZYiBXGJwEU99cIH47mDmEveD9J7YzUAQGoDtZqzq1IoQhBJFPcqp5Oe3ZP1StBuicl9tyO+7jIUctOE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c82cbc5-d29d-46e1-bf5d-08de5463c819
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:47.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjZcWH5xQpcnfJ0lgv8AEeLnGbsKwgbzIC8/iEoZEP1lZNWfYDqUWyoEbYyaYJN1qI4xfzCcKZQPxAgXNMeV5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150143
X-Proofpoint-GUID: q2ic-k1SwZ-ZIqIqddGPG_gpvuUWAsEJ
X-Proofpoint-ORIG-GUID: q2ic-k1SwZ-ZIqIqddGPG_gpvuUWAsEJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX86gSVIcduRDa
 nGDj4ue3s/NnrzVRxRIxOAlFNiAQJVf3XYoEgmlXzTJ0nCFlBEfQFNwzaggpLmB/4mHejJ0cUIf
 DTfmOTQOHq4DRs3AZba9XkxJdFkIBzZIUkLVfEtD7zRO0q7EzlGk+ovTpPpQ4vDUne6WusnJGKA
 ngsaAkFSsCXRckF8vWlNzQc0n7F/UPv9vSLL2k4A1f42lVUsC29zPYDCfeoqS9/lnYWaInyqsWW
 d7VmbYkCok18Yz0wGYP1Hv9KAEwOoFmaD+EgZdGGVSsksLCZg+xA9Qa03gAD2M95A8/dhXAjW0/
 59C1LYiE/Dm3dKmgyi5SWQU3yJrSoUK9tVURiyT1dp8e13+dl28oyu6rkKaeKuUNjbeJpGcnBzJ
 IYiSiKCNWUSOLhWQg7HJRWl3B/2ibhj+ybfKH6SZJBHvxhsnT0nzgxsXe12SBl9U9b6IaQQHm6e
 DHuVlRi2hWvbi2Icw0RDjSWFI4BaEEQam0/TfkfM=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696931f9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=vROGCtjlC6yg46rs05EA:9 cc=ntf awl=host:12109
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB1E21C000D
X-Stat-Signature: detrdsehhnqcnfhe3td4spao5x9pzdik
X-Rspam-User: 
X-HE-Tag: 1768501765-13293
X-HE-Meta: U2FsdGVkX1/3pZy71zXoob1YHVbNm22kEdLLA89WqmIwmPvBERqs4ga4JEtJhqVOC7SpB/le/1Orqe+Bs9kDKnI1H36mMKq0ttL8SYxERSdCAFL67PdiXQ7G1JWtJ4jqglnv0US3MKVuag2GkZS9PW97hbZsdFZAW8X0xChLscHi9gPUPj06u00C0mofddS5/rYIF6mIgM3qNXAUEx8QyXUXblPxpDjHMRnr/LLVDP9L1uLjyL5KS6SPEDFOW26EWPNKLuSErZUeUt8+q33KHIZgLx4KKC6KlqccEdVRhSISVKRNI28W4wZ+3yP7X0shVyF5CI36cw2ybKvPYN4Y3cZ/1px8mI8pMC6GBIz1DJMn8MFt8EIx92c57ed7rYLfCTQwRmULh2TQ+RWAwslwuPlNYEEnn22s1nlrZhMiolO8dle4Jy4jAVp7Si+pJksj0CkSJsDnWVG52xPPesZREYxXZpPCpZ1rae6uJunbUFxaeawmko2cblRaQYp9pQLoF4frSNuNYosijgq3j7UQWDDu40Egb+FuL84OodHBcwwCMxl13QjHgCFIa7TKq9WOFrWAEWhcrfpXYR4+2gYP6wurP59co4bZPpRC0WdRz3OGh00/yklGrlo35TIhFzUXQSxdOfvzySzzlcSr0dLrcYlvChnnEKhxvxSSvMyuBjfSQEJwKHbkBBQcA6pe87OpctVdZm9pK8av4mREwt6iPYchUOWZ+HvRdfrrX3atBof1qDxLMdDTrJzU+ILZg4f8iPt1qrxXVSpBPpZaaWedhSF83XPmLZZoLdetmpdj9xgB4/FAvQIdZzddNvcYcrQ/jvWOYtf/AhNock8foxhbSzSYa2PC6hxhm9DgcchiFQ3fnsZ/lobwoSXO3TL6RX8sJERoIl5c+If21Le48z2w9kRKZznl3P/Gbcmt2PhAd/4FQhh+Xm/pNm6uf7/QneXG3tlj/AEDhRmP8jDXgGG
 53AuZyR0
 W4Ty81/o5K8Kosbnxa8Ko3J8AUvLuTl+nvujxNQbfCrdLoXUnijc1JX5viT+wlAS3od3uI6SjESbu3j0AMSdIuRw+0WQYqaw7ZqObYnaOTlB63CXSSPwibFVhl8jLj8+LdF+M+TwQyw8bPrfgJoNjXuLp/n18sfW+P4H+NZZ4TXtPnMAzqFbTvBwB8CAM41o3ap+O3IAKsRjRh5XqZ19BB+tuSm5Ia8mGkBux/T2VNpZ5RZD2DFAEfl3ORfzLlYQNA3vUvNIjUmvaK/ySgt5N+D7rkNsM6lUsCy+mIqRYp7PccAzgirF4R+bFGhkmdjPQM3mEnZUffX43Yy2jT7BT396/QkW7GHJCqxaqAYbp2ptWVp0Z2nXhKRolQinkzvqpbUxjZCF7gLhUIf92bhy5t7oZoV3lMtH8Y/37QfC7XM9D9rSwPhihCp91GzupTHKhkMNHKnSXRNOTpihYR5lzcNEKrHYoVmsmXOFMWmtNLxnddHUAxCdDGAeMetQYiiC4V5UZeANZjIV0/yFePDJCnTFwBq9Fjf27Po8tZfozTTCdACe+RKsBgBEt1CU1HVL3YFB1Uv4eKpfTqQxOg/afLAuZY5LfY4U8HW0dqqSKERE7AupfVAVQqAsCiQrsg4vaUxPN9bAtopmYSrCY8NrsM2VwD1teZvg2CE2JS4WbDxRAR9858AoNuS9VMhZk6sqqKpUFhvuUg7X9KszazrvvkyB12U+5Qd0FvCzTJ6xbQJKEnx9yQqZEXdIb5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass through the unmap_desc to free_pgtables() because it almost has
everything necessary and is already on the stack.

Updates testing code as necessary.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  5 +----
 mm/memory.c                      | 37 ++++++++++++++------------------
 mm/mmap.c                        |  6 +++---
 mm/vma.c                         |  6 ++----
 tools/testing/vma/vma_internal.h |  7 +++---
 5 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 25a17eea550b8..1cad630f0dcef 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -512,10 +512,7 @@ bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked);
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
diff --git a/mm/memory.c b/mm/memory.c
index 6fd6decc139e9..16b25eff19251 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -373,12 +373,7 @@ void free_pgd_range(struct mmu_gather *tlb,
 /**
  * free_pgtables() - Free a range of page tables
  * @tlb: The mmu gather
- * @mas: The maple state
- * @vma: The first vma
- * @pg_start: The lowest page table address (floor)
- * @pg_end: The highest page table address (ceiling)
- * @vma_end: The highest vma tree search address
- * @mm_wr_locked: boolean indicating if the mm is write locked
+ * @unmap: The unmap_desc
  *
  * Note: pg_start and pg_end are provided to indicate the absolute range of the
  * page tables that should be removed.  This can differ from the vma mappings on
@@ -388,21 +383,21 @@ void free_pgd_range(struct mmu_gather *tlb,
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
  */
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked)
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 	struct unlink_vma_file_batch vb;
+	struct ma_state *mas = unmap->mas;
+	struct vm_area_struct *vma = unmap->first;
 
 	/*
 	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
-	 * may be 0.  Underflow is expected in this case.  Otherwise the
-	 * pagetable end is exclusive.
-	 * vma_end is exclusive.
-	 * The last vma address should never be larger than the pagetable end.
+	 * may be 0.  The underflow here is fine and expected.
+	 * The vma_end is exclusive, which is fine until we use the mas_ instead
+	 * of the vma iterators.
+	 * For freeing the page tables to make sense, the vma_end must be larger
+	 * than the pg_end, so check that after the potential underflow.
 	 */
-	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
 
 	tlb_free_vmas(tlb);
 
@@ -410,13 +405,13 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		next = mas_find(mas, vma_end - 1);
+		next = mas_find(mas, unmap->tree_end - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
-		if (mm_wr_locked)
+		if (unmap->mm_wr_locked)
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 
@@ -428,16 +423,16 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, vma_end - 1);
-			if (mm_wr_locked)
+			next = mas_find(mas, unmap->tree_end - 1);
+			if (unmap->mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
 			unlink_file_vma_batch_add(&vb, vma);
 		}
 		unlink_file_vma_batch_final(&vb);
 
-		free_pgd_range(tlb, addr, vma->vm_end,
-			pg_start, next ? next->vm_start : pg_end);
+		free_pgd_range(tlb, addr, vma->vm_end, unmap->pg_start,
+			       next ? next->vm_start : unmap->pg_end);
 		vma = next;
 	} while (vma);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 042b6b4b6ab86..8771b276d63db 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1307,10 +1307,10 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
+	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, vma->vm_end);
-	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
+	vma_iter_set(&vmi, unmap.tree_reset);
+	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 876d2db5329dd..f352d5c722126 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -475,15 +475,13 @@ void remove_vma(struct vm_area_struct *vma)
 void unmap_region(struct unmap_desc *unmap)
 {
 	struct mm_struct *mm = unmap->first->vm_mm;
-	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, unmap);
-	mas_set(mas, unmap->tree_reset);
-	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
-		      unmap->tree_end, unmap->mm_wr_locked);
+	mas_set(unmap->mas, unmap->tree_reset);
+	free_pgtables(&tlb, unmap);
 	tlb_finish_mmu(&tlb);
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 0b4918aac8d6d..ca4eb563b29ba 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1137,11 +1137,10 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 }
 
-static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked)
+static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
 {
+	(void)tlb;
+	(void)desc;
 }
 
 static inline void mapping_unmap_writable(struct address_space *mapping)
-- 
2.47.3



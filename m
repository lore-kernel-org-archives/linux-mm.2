Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCF2D637A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E876B0088; Tue, 16 Dec 2025 15:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECF06B0089; Tue, 16 Dec 2025 15:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0766B008A; Tue, 16 Dec 2025 15:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7216B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:23:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9523013BA2E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:23:37 +0000 (UTC)
X-FDA: 84226459674.20.9B52F53
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6A8116000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:23:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lDJl+h8F;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765916614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyEPIhSAEnPOBlO/16l3yr+VcwLidvnTP2ptqmdTGg4=;
	b=PvljpsbbCv7lk8GQ3DkY8CDKie+Fnn6LCDaQnzRry0cC+ppH4yOpvrACzYj1KCmJ/P7Jqt
	wOFVuFgZpNa4AJFfbSOF8R0IC5DUPdFnQXtE4zizAOcXjuMTg17X2zXQCb4C9oyY1reM/7
	dZmLoUr4xo0EyNuiepZhv4xV0ucBTwc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lDJl+h8F;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765916614; a=rsa-sha256;
	cv=pass;
	b=WXocNbliLc1OSi97zgFQByD4LaT+hhnzg8335zPxAi1fHLKbQ2xpFMPiQjeuUXGPG5Kxjf
	6yeQdNXc82D8w1/W+KP2PRslHyGb8rO9Ymaxw4k/y/eCxjUXI4YWuRYY/nKLodPnVv55+T
	4HgPt77UkCNqs8JKzuCudOcyez0/Vgg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oy03olduKqHv4eHILNmkdeKB9Tkdyz2XTiHStoJ8CVsU/Z6VI/si58ceQDfJgO1d3m41XahulvGGgPIs3jvKfxgi6s6O/0ENEloueAMYc6sAyrysvFE8RFwLuLTVBljK7pVDyNcx40FsXorP16iYTdy2C2+MxWlUwHDhqmQSXWfbG2ml3s3n2XD5R0UYhuKS+tFZT4E860DlkUpphN0sFaFK5YkrmseWeakghhLAOheeyABKRU98xz3lcAw8EBxKUqbsl+GdF/M/t0dVfc5NMf+p8eJ8FlJmSzspPJxpiHEpFEpiKeiLCU9wXvK5rhvCGjKRcldw9trIi7HBbwgZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RyEPIhSAEnPOBlO/16l3yr+VcwLidvnTP2ptqmdTGg4=;
 b=LeKjFheLC1EUzSes3VQuwLIy2u+8A7wYqc8fPnvNPWgdAGgJC9PY/oSU6XZ79ckpajZMht5AuhDazFvs/pg8HmJh0SJQ5qmYja/NjPm6AEz22uRBko25LMxCycu9sksHOb3llyzaD7FdalynllkqX3qCuORNKd6Qezz+DOXCartuxnzO7n1NZ8+xBId89+Z0TJxLC19h9Q8nELv/wVyAggOYZee9kCCYSCJ5VKAmctj9xVvuvDE1mEWuXYJdqcw2yUuxTBTR5D2cTToP4norhit4Mjn2SpRxRTAxe6fhluxYeaLwCDBXtJFKqCSjeO+7tURHne8QV4yWunZgTPDsCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RyEPIhSAEnPOBlO/16l3yr+VcwLidvnTP2ptqmdTGg4=;
 b=lDJl+h8FxFm3hWqlRNWXOTfD4FKqUuminGZjQRVLECztzHkBj5pE5c9JfMQZd/gxJSLzBVfFns7y2RagMhJbJoruoEoJTveeCWetbYcwYwAbGcSK8sgt7LHtpyPjPnwCiP48If3AJLkqHv9EujvpOiR2AuC9ha8dOi329MNVvq4Uho20YlmEFR1Lcoh1rJekmPaU062tTG/JP2hNNidYFG80v3L4hsn+rWvhPhwhQlUgr6erFM0/IXDHKWexW2RVJPe1FZBc2n7dUS3Papw1K+rvmw/Q0OkupR8wAdBp/oRgD/isExgqYL3njor0YTFAlYpJDe5i+pnHnKEjM/6MbA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Tue, 16 Dec 2025 20:23:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 20:23:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Rientjes <rientjes@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for
 __GFP_THISNODE THP allocations
Date: Tue, 16 Dec 2025 15:23:27 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <41F074C5-DB6E-4D44-859C-AE366EA068B7@nvidia.com>
In-Reply-To: <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:32b::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6b32d9-e9f3-4c53-89ab-08de3ce0f9f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BQ5sz9xnLYPQ5FPi7ruO9xVfKs+Izgud8XCU1GgwddkhWW+sHSloufhHXVTH?=
 =?us-ascii?Q?ryjYa/6F6cb9x89MU7wmg7IyaUc8DmVajUeM2QPQu0v1Y5uEGlTi04jZDWpG?=
 =?us-ascii?Q?D0cSybDRSwO2wzZ5Dei5tbaUj1AqLIotS+QIJN4c4vkFP/sXNeHAoCXL63cN?=
 =?us-ascii?Q?+rf4QgjrT93OcvPMlX8Fg6qOjxtmE6tDGYRYn9fis62lESQWXwn/m5gmTvJ2?=
 =?us-ascii?Q?eTRsU8I5y3egqeivNFCmA78avotCKp7dXNqRxq9nh5fQysLJX+z6Z57KzKiR?=
 =?us-ascii?Q?8b7ZUvULju8DcUoC0TaI4D6Dt8VovMMdc/Zf4Uug5sc2yqmBV4pgELBVtTQt?=
 =?us-ascii?Q?E+dDIx6UzfWGSJC9DUkjOqCydx7MMhGL9i1miUqxa+mcRRRjPyLxUB9E0mVD?=
 =?us-ascii?Q?DCjd607RaomBQ77aWFIfGFp05KSV+XtENM0T0UIot9nblgr5h/+dzvpmgKyg?=
 =?us-ascii?Q?ucj3uL4HVRP1C/6CUjznjMJv9rEiGf4D7CSu9bE7hKmsfcA8VhNGLlfPCc/4?=
 =?us-ascii?Q?EwLeTdoiiadyyR+/gXBW+9B0MjNZ9XV8y8OwGDEbVRcLWCh1e/3k1G8ngvri?=
 =?us-ascii?Q?Tk3revYpFToF/FQm0xxPvyFd8ShzWIZ1zanQNjpumSC8jCNdCEne+9p9jOBK?=
 =?us-ascii?Q?R22GGQhIpjPUMwBnxBPuaMjpUra+quMDnNBdB972Z4eff6GGJvraxrSgOqCT?=
 =?us-ascii?Q?yN37PEe+nImz2IBSjBQntN+7xJxV24/kuFAVieRBh8NTKbVsYhZjMczaB7hm?=
 =?us-ascii?Q?cMzM0ZcczfnuxaW6q5RsnqW8w4GVp/vpJl24EOrp7pAmsJ/6r6svlmfE/IPz?=
 =?us-ascii?Q?IiMdmaGySpL+f9seIQ8UllQ2Z1bIdEFezcEqRPRDqI3GRXQNp22s7DO8I2pH?=
 =?us-ascii?Q?aFSOjYcITzJdN84L6bVEQofC4xu6m9Bi6GxLnG5K8N8/kVzKxEhwj93b4kyy?=
 =?us-ascii?Q?26IBHLPt7N2o+b6WhQ7dDLc5vf6GDwFAhmOWAiX0uCosP6TpncRZo8m8jzHg?=
 =?us-ascii?Q?w8DgEikLvJyYausZ2mEMc8/JuVgdVlGx8Qs4Rn3MAs+Ilksyc76B6KiPlxA+?=
 =?us-ascii?Q?96hxVvAJXceyWrWMTHIADDYHk3yjmAvF/WZyu9x5K6cE6FG28RgMILaounk7?=
 =?us-ascii?Q?r65R6uvMYPHoBRNhzH1p9LHuvnw+/qV4/Dmy2XkGQc5pYaXku97eUJnfyE4x?=
 =?us-ascii?Q?fTzdmIa9DGqU/AWR7XHHJMvAvXxQaAyhOD6/NXeCFEp4FDt9otugSPqkS+iR?=
 =?us-ascii?Q?ttZcDcYVBQXRFfXplwmmJhmruZqWxMa5vVBETmZ7mpg5nV+TyEQ9Mr+P+WBJ?=
 =?us-ascii?Q?mc5OtCgF/QA+bz+/W72sWnocOQOLoQocssXidU+V1VWbs1OhBGEuZaLGNp4P?=
 =?us-ascii?Q?H94jq3T0LmDVwMiCGnZ4S9zZQ23cLjsR+zjj9vsTQAbDrKMzANNJCic/b51V?=
 =?us-ascii?Q?OTsUv/CpXW3t/6rSTOGEkCzKbFPclZcL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cz8GxCDn9G22Vl1pZ2F+AblL44vADqVjIlcOfZ5hwUQ6S5mvBKWktbWtdtjY?=
 =?us-ascii?Q?23AuNRkKHSroiypfBMHKBHvfpuDG0j30kbNleV0KVQ1BBPmKm/IddIcN3a3K?=
 =?us-ascii?Q?57wgbe0J2THBA45pElA6dtIlwH2E4kjdz5ChgV4ktr9H5xbahKGNmcm/AmP/?=
 =?us-ascii?Q?+EgHOHmro0kEqwo5ITKJ9qm/6bnfB75jdRY0S9He5FchhbsBRYvwqoggJbA2?=
 =?us-ascii?Q?alcDaaDgj09BUh8q/GlC6cbe9OEhHVngymdsfX1GeJTV0+F2ZjDfYJ4SwAkU?=
 =?us-ascii?Q?QfSGKMVZpViz1L4l1W2EbYZtXr7UyiKFqjPbf4muSV8zw5FU/j6YgDb3gldX?=
 =?us-ascii?Q?P1t9PnlDy+jsNbbfe3cwLD2Atarjb7vLo4kuvZns90LXtkVlDaYIr0fR/5/J?=
 =?us-ascii?Q?sPF/fMWbLnNoz9hUgCkiccy2nlNr5/Il1X3pSq1mTtOM+hAxQyrtH1YZ+eGq?=
 =?us-ascii?Q?MGkpsMzVszKmWF/i09iD5G0oBI0jXrW4Cgy42L8fHo3sVCynw6UTYYDv9oC6?=
 =?us-ascii?Q?loPoiruwyPJI/lyczUwZvOK5tnCTBVvGL9j1oaxdkPOECTojIYZD+yExYqCL?=
 =?us-ascii?Q?F5FJhldxWLvqLo5IamPS7kB+uDHNm/Qn7PtRKlEugg807zeaCZVrk09u3xbC?=
 =?us-ascii?Q?dcS61leK6jVTnnT4d1t8OVFBh1rWSBGOJeLJL8aUQLHbSAQ3QbvJGaqQm69d?=
 =?us-ascii?Q?vwfhgIh3Rv+AOVNVRm0iWVa+QOop00yCybtUN+dyr2cjIY5XtGFB7YwoouIV?=
 =?us-ascii?Q?RmQ5RhSlypuFw5w+9j5XVGtAy5K3Io6sGSY3TOUf0jK//cUT6+cr1Jcnk1HN?=
 =?us-ascii?Q?0B4tfTDeWF7hLctGT5WqnxLYyTq9C7tkc4hy6CswXJbe6yI/ndi7o40KTZqU?=
 =?us-ascii?Q?+oequVIXpi1lRgKar7qeA7EZVka5ruNUqIyctbQBgcatV4jSOEUYjS1FLHaL?=
 =?us-ascii?Q?RVKshy8qFZjv2T6LnhTV6dUxmdDw/dwmVCqHXryrOlU1gKmti3C6k/mNg1Ch?=
 =?us-ascii?Q?EdnEoxH6BMeMs1CwvtYTQNUKVFc6s9VrJG9boI0YCmmw0rrfuaI+gfygKqbE?=
 =?us-ascii?Q?geI/9AN16QKyTdT3eUFiUg7RpVSorySZQDgfH8rCTafd6T1sq/m88y0x0ZJM?=
 =?us-ascii?Q?QduqUaYduR8hbqY1KxrHkBPxsQHHK984O3Js0we3aoavgz7Tw0xCMc4s/C14?=
 =?us-ascii?Q?q72/DMxh9tNAx1YaYWxN2cDXKWp99uxay1maC5gGsvgKaa+D4StRX2+hML0H?=
 =?us-ascii?Q?RfJhejvgAGTeGQVlNfBypsZWSvAEMk1En8HzJ7z1Kpr4qTd9SIM50BzOEAiI?=
 =?us-ascii?Q?bR6arcVYWpLZJOT3wq7T/QRpE/GqbL5sTO3u3h3KxBj8nUc8c5cnSwWp4Ztq?=
 =?us-ascii?Q?fK27SVERPTdtXQZdMP6MjSjvXcgy20Wcco1oYXApWVBjNisOjT6ZiEo0y1Xt?=
 =?us-ascii?Q?wv9uJqSGxkCHC1yTQJTCENbHTBxIruBjpI+fhScEzPFvtNbRc1W6ude69FvO?=
 =?us-ascii?Q?k+mFCvhgvAOMJiOyIq4CmIucAgKQ5NMc0W30BdOAtKhUNPgv79bTI207Xw4J?=
 =?us-ascii?Q?eQVGD3nO9hrzT9M60z95hHSl1NrjNhZkE9Qbz8QP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6b32d9-e9f3-4c53-89ab-08de3ce0f9f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 20:23:29.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAybyD9qWCPca1xslb/vMxU3GBkn70ua5gOagEpMdXdbFkuCP8NNIfnNC4+TiwHf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6A8116000D
X-Stat-Signature: e1d5tch4t3a1wxmyjmsrb4sdihxrbcr8
X-Rspam-User: 
X-HE-Tag: 1765916614-584420
X-HE-Meta: U2FsdGVkX1+vDDIRxTRbKizxMXHcpzGyEBt7AzAqOQ14g+IosdJiDLTEabN2yz2UWO2ClaBzpxDIQCYRNH3UFanFnQvDzI9Uw8o5IxHuL5PWB3VHw/IwvYxJIchyEuBH4ug5rlqRpVhgXHroA0HCQa4jJ5ilW7Bs6v6P6PCcZFOQDsWqtzhnfalkaI/XKyHIZmAm8YIc1Ziyo3kNG9sCNXU8SLqfLemMtOXR84Yjz5/1e66cZuEPZOueom4Z75KcgAJ0KXqGf/s9k4Z5pXPOQSIuqTGuyGC+Yv2x9nW7tuuegPIbiQ04EMZxDIyv7K84xWby/hurpEwOYE9S01GEvCGa4RgCdFbh46CepQNEMz/NkCyFGa/N8j8wnL2zTTgnvi25o2rjBucIy/gqvr8E03FlN1kylnv8n0ADkcifmRZU1lXTBrkn0bI7SqdpCYg7lUkvhH3EkQgheGSNYWGv1cfEEHhfm7wdAmAKFACdu+owO5qHTu3hd5/3EDoipCaz1/jjk6poKcDbf7hqeDhdl/KB4TXlhZniZ6dUYdOKgSyvXP/reVY4IeAQ3HXUpeCRJBpc2NpGyFH5MdhvFEunFPhuyjNt15/8DeMFCzpT01UCwN2xQaTU0wslI0M/cJUNy0ZnXHAL/ZqjsHOA+t8bJtbC75oyxlrn0Thav8GM5ShU9Gru28+9GKd+P9cMpZB5MCJtgxMwIcEjoWVppP6fwAscQ1kUNGmT0qG1ehS4oP6ESJ+o4GZPPL+HaApqL6gnw9o2Lz0sa8ZlG+/HEx57Ti25bG+7Xe9lECabEke7XeeSZ2IfxG2K9stRVcQKbvxSNOdEWxG78y1bHpkcaJbhlkgk+CviDe3LCnszUiozHV6TkE6FQ99hJvHDX+xMlIgpkYCPeekQQ97nbfm1ZGyU3quJiBtg8XkWSqedllTRvdvJFPy1+dErLmK0CE5WqmnHqtgE1T/Sz9WbvNMlvyA
 HVP601st
 +l2PR4OsCbRIdyUH9Ajh2F54Umu/HrRx9dgH3yNfBoWdgSokt6OjNXNnTRnzPKO8uRsvtgYMstpiIau/geVSOT7HYzb9MxGwJVMhwSSxEuLLWmhwdTABqLWabRCzZZ70JHxbnjNhipOPj6dZ89k+FtAqII03yt8uXGq72xSzlv0Up+Oe5Aq/YhV5PXnkIfpx//NWUJm2RK9J7txWD8JLShuHInV2G+t0hzrvHx70dDN4erX1t3+CjFYfmrmdZgQBm7SZsQddEn0YK8Zs1aw+vSsfDVqreOAmsgbfK96/i9wVFxrQncZBqGhrnx98z3krCoIoRSsPfIvfherjJ8lZ6bmRftbyV6rY8f28zBZc8k391+D6aC8dK4cqpZwGeCGj8ya2f2alXw+ZsQfysCMs8XIKvjDe9sqSncjVXGWTwcKz7z4YGKf3vbYwEHxilHw2eh+ROuAQEzfprMB44u/jlp+VdQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 10:54, Vlastimil Babka wrote:

> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
>
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>    allocation from any node with effort determined by global defrag setting
>    and VMA madvise
> 3. fallback to base pages on any node
>
> Recent customer reports however revealed we have a gap in step 1 above.
> What we have seen is excessive reclaim due to THP page faults on a NUMA
> node that's close to its high watermark, while other nodes have plenty
> of free memory.
>
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base
> pages), and not e.g. when compaction is actually performed but fails (we
> did see compact_fail vmstat counter increasing).
>
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
> which is not the intention.
>
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
>
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0
> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.
>
> Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/page_alloc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


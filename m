Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F893606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HMDNv+hX
Received: by kanga.kvack.org (Postfix)
	id A109F6B089C; Tue, 27 Oct 2026 14:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AB16B089D; Tue, 27 Oct 2026 14:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B656B089E; Tue, 27 Oct 2026 14:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57A966B089C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:53:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC694140ABD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:53:40 +0000 (UTC)
X-FDA: 85369305000.03.CB8C156
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013022.outbound.protection.outlook.com [40.107.201.22])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE15F140009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:53:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HMDNv+hX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDlERQp3ezIZQqhJZEUQq8L4M6aQksTGqf2og7oCFPE=;
	b=zTUc/KOnZXR6b4D43rgsUQnAgdoB68zxbLozvQaVR+SY3VPJVyvd3rZf7Ph2hobYAyV3XX
	Mhs+NMyqPmGWy9pGGnMjr1GAQogAKh0NKOyijN8xFCNXvQiPjK8HqgLnBBSH/BmYonocv1
	uuq7t/Rd6156DhgrVvYmvkpKYy1heGQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HMDNv+hX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793127218;
	b=SCCEVRAcGDZDGyu8n/gJ3INcRYwFLni2zuZzrcstWz9xf0ZAQ/FAv5Q+QTxlaxBWeaspq0
	Qa0B+xFqAV5q7UVdugGRRsvLqFGQ5hkUx5QIKGqhZY9UwpSnaaBYMFtU94P4RJDCIvb5Xp
	LOjXVqP1vccRx042Fmpdt5bfBzRzcoI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pStT7TGWHdqssNPhq/v2oyyWhJxUHT4HH1bgmPe0EwkTym/1diK9ZnuGxxApsdvjRdFbixP/WnqQwIg8L/GXIkf1vkkKcfrAx2pllhF9JNBaPdpiLTI547JuM6pHCdw6ctm7LTtJ1GUWKGJBpXi9b99HSilf5DgafF6NobwTbJfvnGETR6qwF1Jut9Zt7krLIWHT8Xdr4a05zze7A4n81bQ6JTFu6mjuH0zAWZ5MmF2FW7ZnisCEcVeiTc57WzuqDOOHH48qriiuL/vtf5+XmJVvJ7z8beDarqPtqqSy2NArlpio1Ouc1DOM4sYtjnYBfAG+3HJEAU225wbg2jmsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDlERQp3ezIZQqhJZEUQq8L4M6aQksTGqf2og7oCFPE=;
 b=LSn9WnX5TOq+x32eTQvwGt41nv+WVHPjyyE0sr0AwsZ4ZJbqHTpBOJISaJTLvuDTjsTeF7cGah57ZriE3gkeawEvxkgFY3igvZHfu6G9lVVOmthwFvoUAU+YnM6jopqY1FBmn2kdsNePZnM9rRWLC6PAznroGUkeiEaZiDmDmdG37wZcX5B5Blu/UTtayC27l8BEK/4cYKM4Mc148pBQU1t004SZucikRUTMbW8052lKuOpkdswcvlQbHFghk+t+xV2G7XXkdtDbNDJQ0zh3KOfc6q6jJ/BhnxTBvzGOAKSKiCduU9ysz/GTt/H8hZSxezNbO8P9wLCvZnxks9vqNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDlERQp3ezIZQqhJZEUQq8L4M6aQksTGqf2og7oCFPE=;
 b=HMDNv+hXgEdR9Uo1aaVCmhbLpeiDA7gdMi5bJmP90MQB9ZPKLzj8V4QKHy03nmqbQ/ifoeaZ8ZRPjQjypbHdgDXJ6c0HhwmWXRlMfHeQ3h2LNYsunACPSaPkFqyOVBC+MLhzTHobs6RsRsvKCOvBSut1tL+LRpt/3CH+oveuk5tIGo8p9sE5MA4lamTkd4iFGEX2DNXJ4zKMsVYbAegBn+khlfK9t84kB0MHaQmTDovtu+tSHluQvDF/A/1H03KRzqv6Ot5YJRshayYARf5Ufu/JeH1luJiGAgpoYE+zYw7XXvdd+pHF2XCscyQHxPhsG92RgC3omIRXJiij72OcoA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6623.namprd12.prod.outlook.com (2603:10b6:930:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 18:53:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 18:53:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
Date: Tue, 27 Oct 2026 14:53:27 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <A4D82AB8-F33A-465C-AE69-933B746E4885@nvidia.com>
In-Reply-To: <6f5aaf2b-894c-4306-a0b2-e56f815d0a89@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
 <179310997463.2232644.3260379218896917308.b4-reply@b4>
 <6f5aaf2b-894c-4306-a0b2-e56f815d0a89@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH2PR18CA0052.namprd18.prod.outlook.com
 (2603:10b6:610:55::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: ec8ecf41-0a1d-4ec8-447a-08df345b9856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|261026121527099003|4143699003|11063799006|56012099006|261022075727099003|261022105027099003|261021123027099003|10067099003|18002099003|22082099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	HzprCB56KfCEDkpIEy+H1D/wgvK2jDR0Ebr2UVaO08fdGJ1hDwelMicFAnSuD9BuYjkO0qPO2qfzY9OpVxCjEhGFobVf+L4ePYbPufEbPuR9Mzvu3bH5abj38jvaZjINicTUcvQ7EdlHLKueyGgT2fNDEHG1prtkocCj9UnbISITdkgzjXaLzupIbpE51KpmbecLqtftLiQkaiNnViN4RlXKwrgLXgQ8aQVgxBbEfA7EZLjX9fz/hKUPNv5Lg17iJN92sLP3fPb8paHdc9hXIpgsiFvSzdJhUWsmtBp01guzaSVAys8CrdEybI7/KykONWtdBWvy4ivswxtFZZtF9vmfSNNpr5wUZv0GwhXpeDriH8cIEsfFXF+4sOejSlSZl/FIKAIgZO3Lko+ZbweX4GpG/WoSFWZBcZ++jUNfAfJlz1GgLXXYVT6gPFjW5aa6TOAZCFKia91Kv/PokxAfn05DeFacLs3puyc4ltqpti+PrriSJo4YWTIWN+bwkv07rEra6IwI0tYgt/tS0+RCxbZ0Yz6AcWflJO7jfTOX2JKDOXokNpnmWGzRrmT2a2QumqqXl99xXGFwpYiruJOPbJPA7bquzIaDEzKdmhwwvr6mZU1FsRlA7hFa6A7HNOJUNVgW2o1EK61Iq8B9T8UMuXBl/d1K3E4pS80WH1SZ1F4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(261026121527099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261022105027099003)(261021123027099003)(10067099003)(18002099003)(22082099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4/fT7ZU96vwzO61undPANerpi5VOn2qMG1scJ/zoBy6dC+Koq5LLRMykDJJd?=
 =?us-ascii?Q?Pre/Fm3Bv9rBsX3/DZcyWQzjM2O4tl6MfF8vK9LdiO41WEPbCWAy+MZLf39P?=
 =?us-ascii?Q?DB8970HyTviBvsXGAXcxIAKQrOGxd194vtqvrMBSZcpVb5Mk8XSHXU+fuTkw?=
 =?us-ascii?Q?3RxsG/eBMMhpnX8tFwVwnhCNYJ+cXJ0xlnVwEA513IuhWb0bOOG1ZhO097Vc?=
 =?us-ascii?Q?QDXDo4b7yTePMXX7lk46DVHw3DWnGtwodrowdmdF3BoznjzROZvOp0PI9k2W?=
 =?us-ascii?Q?aQZflMV9BXzKAoe08EqfP5vDgAOEI4pDdryfxs27o+vgYTQosbOkAX3FGOtK?=
 =?us-ascii?Q?TAAtw3xoG7U3f4CQi3XlyEy82SYA44d099HaHE0dcOplPJWNWFGQs3xTRX4H?=
 =?us-ascii?Q?/iGq3EMSmRJ3PaGDye6rshpOa4T1PhVxtV5XYXWXtpe7M8tLoYt21m6MOXmZ?=
 =?us-ascii?Q?I3T2AJMvGIB0gLQIsPNp+vwEYWaaikIOo7/kqhIvo5iY1YoV+DcAbSet0ORw?=
 =?us-ascii?Q?IpqqX6jFWoIFQrAbwQsSi5kCQ/v5A8/ywEObZKu0hqw5SB4ZVkJyoIkrVJCh?=
 =?us-ascii?Q?4WGg9AA8HbPPIWhEb8mZt+riOOCVIiAcGFRcoeh2UAeuyDdDzLe4wh5nY45e?=
 =?us-ascii?Q?XTDE6tzTM/MOfmhUqUN6Sjy8jrRcN/wjkyJ/avB8UpPC0rYNt7tWv+YRQBIn?=
 =?us-ascii?Q?BWPgrXIH2OQ4QJXAgZXRsPbMcJ7wXfwLuOE8duKdf4E/4SK6celrK9D8evXi?=
 =?us-ascii?Q?s9EJ2MDzw5A5Nrl96Deu454f/arUoV1LMZx8+iRii/7UJDfyELSCso0X8vG7?=
 =?us-ascii?Q?I4QdKeYqbWfukKFK4F0cs78Frd+nk9oUs3zk/soKHPw3OxrAt7LUkvVIk9PA?=
 =?us-ascii?Q?VNDjnRdAdm9urKQZ/emag4PfgsZgDrZPHPFXG6LabJMTrcUHTvl7bOK7hoXe?=
 =?us-ascii?Q?0VE3Ho6MbmsnzR5Foy3MZZiqnCEbhQAx46dYxaqsdGPLjhu/u2R3/K+yu3ZG?=
 =?us-ascii?Q?FG1+wZSCqavm455uDjMKSBsteMQ4hf6Wsesq244+tMH+Ui0ln3gp8Enw5DM4?=
 =?us-ascii?Q?YZc20Xwplb3odBgLkWMfoVJp+klYstACqMKYsobMsB44O7J+4CFLJAMaOfK7?=
 =?us-ascii?Q?qUYXCURvBGZYME/s/lrYQmKuN180BG/1X/XWCUcmWEeZ9SWsEJY5kH/Kf0Kx?=
 =?us-ascii?Q?+KRHbvaC7dO4MyGNZkqcnc1OCGFfegn4Da+MJMtbWFxzhW78OBh1HMPnu9Xu?=
 =?us-ascii?Q?4KoDpjvQxuCL1KjdcUAr7Qt9cJ7ycRgg6R5010ROzcC6fonheSMXHq3lOlb1?=
 =?us-ascii?Q?UTdqK0Vn+52BUXt/gnfOBA0JfzTBa+lD9OBrzgkTqidFvLGhuV4EPn1NnFjd?=
 =?us-ascii?Q?pyTYKBBFdGoTsTpjTseqof3V8taQjkMZu2ZQFLhyIa3WlswJ1aaow5vyVCZx?=
 =?us-ascii?Q?qregNKWI+qYD6pQqCUTa4d7/si303MgBk05t5g1+dWtonCjVW8VYCSfBd2aS?=
 =?us-ascii?Q?Qsm3FWWNM8IlGFxSRhxAzlTRdI6tY8SjQwj8i4vHrGo6VKubFfwTNGZyrq+a?=
 =?us-ascii?Q?ArcVzGgpsODeDfFoDFNKnzCUD+2MDakHf01Om1GEIkyv6+jbTno7c9wYuXap?=
 =?us-ascii?Q?h9Sfblwi3aFqR3LEF1OgF9GHHxrbRRGPahgfBMi4tWic/F0wJfuy6NlVohyX?=
 =?us-ascii?Q?lA+j+Hg4sPiAbOjxDLD2vFs/zlfBJ93hHxoEuSZ3CrumjD7T4AsWAJh/x3VA?=
 =?us-ascii?Q?65cFWnZ/xQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8ecf41-0a1d-4ec8-447a-08df345b9856
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 18:53:31.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvaAbfmOsN/miY3wB9l9nY1Hlk45ILlcMgvkg3czQDDroCUCefZH0q2iA60cU4py
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6623
X-Rspamd-Queue-Id: EE15F140009
X-Stat-Signature: sfkw4biuxabksat3mhgxztfqzgn9q7st
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793127217-944309
X-HE-Meta: U2FsdGVkX18OWDNW9eQLhW+LhuDdFz/bfkGt0Of/tbtgnQG/hzSN6ofrYEURgM13O9rWQtWsX3mmIADr891JJNwsQkE+3ZVc2y5cdByERkI1axqffRCRKwhGmsClHvY7t4mTrYxrS9VpMTXYUMNDXiyFJUzF/3kRa8xigGz8y5TgSS5hIFBt9Ru3I/fCMhutEDfJQpCw9uv56c08gsf75VKbR4NcCtMAnyyTYtMqCJh5UCdmqXjpaYfkCCZojMRHmVoXJkXnHcXupMIzJDJk6W+SsKNUoe//CFXhUz4Q69j1JN5rL5JkNEaKOIfEjylIv2Jr4kTBmCM+/+gFRtxv0NEzoWwaUHCrGorvuMAglU5hdn+/Z7SpftN9UrgKlBQ7bO8gZTQBG9iDcBeHX4cMY1d8r4X6x6M5rbuHoOPbV7XtP1hdFy8256L4xMmSYQ94nYLnVFO0tok101AaIDkR7EN0X/WFJR1HFu3wQCj4QhulI2kBfA+dKU4FbywlwLNSlNoV7qXud+LXyMjcgPUFV40dxz+5RYxSM0Hj459TJldLA9grFcGHRlp89QaRv9rUObOMxRNqtF4cB4yTPcrqFZxlMQINpFN4GhbmSNtMGKqwM2Svp2f/LexX0JTqH3pUSJYE/JS1qVq+LcBpSzV4bjLItP64/H5silMcBu9E+uyWBv7szoXN73FNrYOBCmDUIktosk1JgMVyBYQNWvITHyLI3oipNtf3K0rsEN2Y1BJCvqwI3+Mt6O6ZujsaNxV/3fQ9whYfTO9S+Ij//J03ihnodReDYFrmqNo2z/EiMFowUsn86iCtPYs2hXe1or/rF+mn0ZVa9dYQiB5eYjSApyoVw5XgnQTV4ewwwfhcmuJgJcH0ymN9bgQPmIh6x45O9q4JfrmAa5QFUIdvFSgR98nHCo7f3/60eLi5ctnsZLvqv5E8ou48Bj3ePdfQPRJ9BizVtTJR8nJHa8SXXBO
 /GlgkJvn
 3O6ZNfmdCS7LYrjwHui9Zo0tsV2j+vs24lxcHySLwcgU6yw6AyhFoZaw6NfIo5nxbM8/6eLQi1awStirdhl69k/3Iw3o+gOVLxju7Pkzj0T0PzHcSr2HX9QW/UcCRqB7T63rjiloxlI7NVztIpdfZ30BhMztLeyu3ke5YuRazS3tc3bPl1xpeu/Jla+gW9wLVIZeCU1JiiHJr3kIQBfCuwbUe5J5YNrWQdDAftfQagtrPK8eOv6hCIoV7UN67OsTa2Dk69VOEky94vJRLWgDfps8XUPfdaBum5ayG9yt7b6bOmO2Zp/+QmOb8zXfSFdBmspeMR9GxSW+LilHN6Xj4Fjb3g61PgwWJsj/+1GVyeaxptTXxwWJzI9C5CY2P3NBx5yD2We2D81cM2g7VZLgPZ0ZzEZreAUu+E3HLZhidCmcNjy4oYlRwu6Nd5U1PrpocPcYRmNY3xd6DzubulyMMUuZ2rerM3shnJ/bPy+d8WB5Hk+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 27 Oct 2026, at 10:13, David Hildenbrand (Arm) wrote:

> On 10/27/26 15:06, Gregory Price (Meta) wrote:
>> On 2026-10-27 14:37 +0100, David Hildenbrand (Arm) wrote:
>>> On 10/27/26 05:22, Gregory Price (Meta) wrote:
>>>
>>> We have an existing AI fix for that as well already handled by Vlasta.
>>>
>>> I think we'll have to establish some model of "ask David first before posting"
>>> because otherwise we just create duplicate work for everyone.
>>>
>>
>> Yeah, this is going to happen more.
>>
>> I've been sitting in these patches for over a month while they soaked on
>> hardware getting performance tests.
>
> I mean this fix here is really just independent and shouldn't wait that long :)
>
>>
>> Maybe worth a private tree we can rebase on regularly for these kinds of
>> un-vetted/posted fixes to see what's coming?
>
> Maybe. But if it's just us core people we can just talk on IRC etc (like Zi did
> two days ago when he was about to post something that I already had on my queue).

One idea is that maybe Sashiko is able to identify patches fixing
the same issue and does some grouping or tagging on the website.
Or send an email about it with a lore link.

Best Regards,
Yan, Zi


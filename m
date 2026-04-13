Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E900AF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60AEE6B00AF; Mon, 13 Apr 2026 15:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3326B00B0; Mon, 13 Apr 2026 15:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D26E6B00B3; Mon, 13 Apr 2026 15:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E59B6B00AF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A04E81602CF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:12 +0000 (UTC)
X-FDA: 84654500784.24.83B9C59
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id DED2610000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CU11jYTJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iwuc/J+Q3KWcuSwpmGg4LdX7/rt5d8jHE9U7kPku4aY=;
	b=beeeXf/Nh/3UTkOsXolmqxKWjtZhgDW3/QaGV5Ne8CNQLocNoW0X+ONt51ZYdoBfm5AsTz
	UYUOS9HILXkwvgFsukHQawvSOSEWM66kR7Q6AxpjTHxpw7WdfYfMsEIcKFMkbRBKDg8CQd
	NDH9B+IOKhCaEYuv9zHMQaukVsHC2f0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108069; a=rsa-sha256;
	cv=pass;
	b=P8X97gG48MkAymaXcA+A7hOfJ0iYCePk0+KQKS0sa5KzSIiHlyqriULLOONWTrfDtXTdGt
	AUg66tJaQp7XW54GNJM8zQKUZcHEnTeKkzXV4cVMon7vZGMqX89ki8TuBwO1MzEJgQ2wt6
	Gzi8JMjuWkceubflQR6HWWZkDODXB2o=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CU11jYTJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7UXtC252Z2mAKwt6WIuouUMn6ycYKKYsztwBDhY6X8NQictujctvICddyT6nYsIujNFbm7YfuyMd42iAx7qLAtHu8XeRZT/8UQhhJI8mfW17A5Ds+NZ4s2YGpAgd/eEjuzPez0+vafXyD+BKfSoKEq1jhGktoCx+A/vUV4sw/ip69cRTcVyyOyLtpksHGzIEhwUTV4Bnutvr/yLz64rj2RLUgw3xc2V+/39uQ1Us8kgNcHB6BdzOOL661fGJOnEhaGTdguW7PjyUwUMIGDEZowTMHvSocBEuQK01qwcZhGoGlRD2VNS+dltZHbkhI1zKikzGg8oN5Cy4S3lA7ZdDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iwuc/J+Q3KWcuSwpmGg4LdX7/rt5d8jHE9U7kPku4aY=;
 b=EnPCEsZQqvbnD9e+stexmMMfyCIAoxnqB93SYCDH947Sz1C6iZniz1XU4AuiQk6cB4WQEAJi+pe1LWx5a6Jqmd3RJn9hPppU9QnhM52dS5a3w/999F5U8NI0YkuzDFdBdtRyqHfAen4DevUZRVWS3RRTT4ByGO081JmPscIAEb591xawH63O4X12j4WdlIsmvjYNwdNTwMjnFyGOl3PJAdXtMQVciVR6679gfIVgc2MwXXlebzYebiZeLckMnkyh77Po4WneLQXpm3fN6X5VZR2cWPFNY9BvlPJfscDZv+9IPB1s6PcdhKO1j4IpU3DMUDjhEAyV4pr7ISIuv9P4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwuc/J+Q3KWcuSwpmGg4LdX7/rt5d8jHE9U7kPku4aY=;
 b=CU11jYTJ7oDgyoyVMwgKBkbdqI0ePXHwB81lgKBQ3ZxpZXUjE6y3WrVe7i9aL81ar0PagC+igqI7mjNs04kcwNPzjqV7EdqjQMv9TP7P+7FOWTArksgvJ+VXOVd+7LdIrXajPeeCSmzifA50TuhCmVZ+mfXJKw2WvbVsvDNeWIJ6jb3VFFhi8MxXBmE9LlQD8OQBdV+co2VpXsO00H+Dm03I/pe4pC2BntepDIeNL7YZnOcMxtk5bj5pH1q4rN2EgoD959ff8JNQ3D6qrEfYrXGFEOgaOQ/u8N5QNYk696150LexRXPrjQfb6ui0TSIcFpCJG5WoeDr3fxWZY8IeFg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Mon, 13 Apr 2026 15:20:24 -0400
Message-ID: <20260413192030.3275825-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:52f::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cff2b42-d61f-4378-bbbb-08de9991c451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TNjGpheEXX7yMjjrrpPwl39Sd+xDUUWx/FNjDX4MjHdXQ3TEdewJpqMIAXw59BAnv4THAUFrrackhVSVlyida2/H4ibgzcc3Ca4TJcXmHK91fEmjTrNk+ZyKMb0BkoinoLEpN5//oQMkIWzxfPp1wc3g1+5jVs9MdbLArm5QhA3mbBxWSxZxCz558sqd8ALOowMvuYLrhnkyciulY2GselgnZoaDfZCmMhtWZi2oTCMQzaEtwt+uo2Ta/tPgn/dhYnGM+HwyKmMvWPq3koqn7Spp5PAFrrk3XRbjWJePB2BhAf93XMqfQCG6xHI2zLO88rY/vyUBKhyU13Umz2atMd6UZkRznPpwi5wvDtNev5tO6YcfeApEdUzf6N41GEY3IrDJKhBKu45dLtiEM5IoGmGTWfBnDCMxRwrZm4hzE5qPJv82tJkqOxncE9wAgdMgtOg3Qtzn4Pi/7QAOw/vMT7dfOSBwlEBUCcbcybd59RXF4fyrE9FNgfSPuTEYR+Tf3qseFXipU5kw/DUrj/ZqBGlqizWu/YVKK/0/WJKFDtco2w4ZkpV7plY6MeisfMZI42YVnl0wZVgOsRzjL/tGZsKeVSF2DPBkf0SHU6FlVWusyM/tpCaDKr061k900PfI0Mk+apdRXRZpoLU3YG2BbY/4mDfS0o7NP2jRzqfzcTsEFYzOwLMYOf9Gge3zhn6hRXjKujztGeVk+1MLo8fH8WEuBPOpvAqU9LtdDDs0pAU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jFMT9Rp6eunDdyz/pf+dldNCOHg9b4Ac/zppWvNoilfp8YYhSNgQ2DWTkWDd?=
 =?us-ascii?Q?9dzM/acNsoBhqpCTmXQEQFlaOKmBd7xXqsKvU479SQQXoyvs20fdmoObG/Jl?=
 =?us-ascii?Q?r1+lwYmG3N/YjsFxA8Imbm1CKqfkDgKyp1AFcC/VFd36Mrc4uvDshhCkNcHJ?=
 =?us-ascii?Q?S1k/2K85yBXbCQ7hDK6MWA8HTyszPX8xXj7jdZUzK0a+HSASGJS7hu5QWRLN?=
 =?us-ascii?Q?CzkuYfDf9A46xPKgtW1+/BDeLf5iG7wAbH+HdAoQpH0iPlvYXTGXysxjQPSV?=
 =?us-ascii?Q?bdVqSbjK4w5maK/3hluGnqYNZS5c3o+f2CPx0vc4cSWJf5koAoclzni/xaFR?=
 =?us-ascii?Q?qLr2krFpsaOFJF8fYYcBaFEkc559UOXu/OAI0HUNSaIgq+uwZ4cAZHWmpwV/?=
 =?us-ascii?Q?zJRSvfdGJwRbEXkWThKVOA2+GD9NkFl2C7TG5ttxuh200WVhHLz+I0y1YzPA?=
 =?us-ascii?Q?D+uvTk60VAxnGoqMNbhIpPD9pLuX6TfUpGDWJiwSxbio6rvwO9fHlU6WC2Th?=
 =?us-ascii?Q?Xu1fA9/uzBbE8jwI/t2KbElrbgEbupEQrhPkaumD5fflMkUFKU2VWdMzfYBb?=
 =?us-ascii?Q?NEbtheZiP9d0c3fz+MdeAGrlj5sDc6nS0Xwr/9uHjez6RyCdVpeRmBNrhJSr?=
 =?us-ascii?Q?aK5SC/UsZjRx/5ZOzYmVMCDyWz90r1XwrS9BwN0Ev/cLlhYsLknWm3rGRtsM?=
 =?us-ascii?Q?vfq9jl06Ncb3A0AYj/CyvKgCwnYtRai+x3Py5cN0bJfD99mbL9ma0rUoRxjV?=
 =?us-ascii?Q?nkBL9GwZRpjt/JVm7/tfgbUa8i9vhpMsxU0+S+59Q7KPP4UlUany5I8QQTkB?=
 =?us-ascii?Q?AlqpL30mw8dbr7j/ZGBJd4SV6C0zy9j4O+L4UGmUnhyFxAT3Ej7h0l4yTgE7?=
 =?us-ascii?Q?y/1gjzbvfMxKwbf1w5zjA06MLfYB67jiqeh5nCpxw3/UYT+m8laPRpiIadxK?=
 =?us-ascii?Q?z4Yxv2vRnTemLf9kn7Yy8mxTKn57QBUTpPfj+p0/fxrmSE6YvwCWCcLRoMfm?=
 =?us-ascii?Q?qOo0BdQl+TxUyS24lKHcnl5/m77rIJjk+pF58gNwakWCq0DQBcqVQbLsjuzR?=
 =?us-ascii?Q?+Ta9eUV1woTelcXF5EjveDbIpI/Vnm8Rjlq0tp+mpLp/4g+kojOfpwCTK44r?=
 =?us-ascii?Q?XjtFPDFGekWiuw/V43+9SbgErXfw9j55dNGEO1lWBQ92hzj1B9q/PwYzahQm?=
 =?us-ascii?Q?r5NwECqUaYIxQVAOLwyVg+rvUOBV246TuDA5RSQwwUGT9LUBxpDHIzEOGZv+?=
 =?us-ascii?Q?peG9le0qNbKsFAKftv7nY4M/aYFX1RBITpofYuxQSBpMCgKxzU2P4zT0UAkT?=
 =?us-ascii?Q?XSUAsx2gFu1lVOu7cB/bMyjpMWZ5urcwpXE4U6d7ZqybklI+QwrwFSBLELtG?=
 =?us-ascii?Q?YLCwQ9opU0JcJmcSSo6fGneLC+MNRmlAigg53InZrWKfOPPaSX7ccFqVW4k5?=
 =?us-ascii?Q?zij4Z6z5YORk6KZ1oeiXCK640BdenWI3DZTfWZ8ol3qPti4ow9hvxR/rdEuK?=
 =?us-ascii?Q?SWlqmjnMnrlp5syqVuorcGNQEFvKAtUY18a54EvCF6nBhXncOCJiAMz53AR+?=
 =?us-ascii?Q?Z6BB3dRb2lhveqOkxyTogqVKz59G/i0KBPNXRnrmhONKECkorff+Z48dJjuU?=
 =?us-ascii?Q?7MzcwLh+OG5FFC3I5NZoS2fXA92KVtFFkj2+V1wlSvmuqvVgw4pB2LtLfx5h?=
 =?us-ascii?Q?4jPhrUSsW/4cASd1RugXKZNhXde4zFVshH9yXSSf5S+5mtxQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cff2b42-d61f-4378-bbbb-08de9991c451
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:47.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6l6UQLULvt2L8PmrYngeuVbo4urT9aPObDZL7n9q6CMwOBLP5PF2PcBH7r25Isny
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Queue-Id: DED2610000B
X-Stat-Signature: uzyfw9gziotd75zoqfksza95eih75cip
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776108069-213150
X-HE-Meta: U2FsdGVkX1+EgUEiCh2+NnTiBr7ttk3HFkjgDQsYM5zHWjMT3DIBUjW4FAWtg+ChyzcA2en5kkcxqAHY7vssCR5UMp/Okeg++TAMkwuXGz6SgWn2JMqTIEaqf+ZjE1ipnFK0pbdjQMMTIfmCoiyvWHtSByLNMzJVWDxg8rLap1HdJ2k8Bn89UbdqQBPZq+TyXclC8h0B27Tdpo8+S5Bo60c2EHOJbHD7XXQvJH/3/QGEL32Pe18UTa79Ta+13UAo13XZAqYTYjJYGHOaUTuXFZpWfSMOSlKtlXiP3qpaaMnpt98ClRRyCY3g2UDsZ9EUvqkCk6nEmi7IO3TQW0jfZ3StteP01q8HCb2Iytf5MyfYy82IcqkPEH00bRJslRlkOVB44H1i4WLsrw5x7BetYPCAusucsgakJgDUe9SskAr6kqNI6UEvVSK48ZwC9bw9XwwZANLUIkYqBASkfePJtyaDtW3uNcauN619p8E5VhEf9kPGwWpXIeGz7LRZC5hSCNF90oDIiIxXo9i7J5MYEsSn7ybpD7Lt4czl/CkWj1crPoQcgbA3KtCP2zmGrkoAlTq5I92ymWGcMselbeKLekC/zWOi0deDyruJOSqAlALsiDVPNHiiBfIUb1/x6XJz/oulKkmdFFSDwbsigXwqBYnN9a3COr7V9BghoTAiPLDUr0k/X2sWZJKPgLVbV1BHNm/aSVS9DKEN+2T5GoaFaJvqDyAtPN3yiA/v08WMcDrOHohF6NUs9lVKEBd4eRXg8gkBnShjNbV3vvo3HtE0aAS3Rrfd/wCI7QX7VM2SThGfMYXR4tEYNw4aWU53RO6WpgzWMBIUS1LIl2P1AdlVpEmdE43MbcBh9YtT0fF9F7OQpO0DY1FdJsMQyiywI4kw3Tq+zaAzlpkFwk49gFf1vXHHcgpWdBl/BW2M+VgHzCkLpJVBXIOXfL+7PIjtU/h115xofOKCiTdKXy5jLDS
 6cQIWwFI
 bRM7F2qG2QTl1zSLg0fkmZcuJgygwoWhm+MSYQvL11VWANb8i1YhKKGDTg53OY8JqWHVdBGcxxH3v+Oql5lARmovkZFL8pHHhk+OMLz99fox2F/S6k74FOWNO/cr5eZSzndUvNH2JQ/klBYYTIOK6VnD8H7z96EFqzkz0INwyaELtcOoDFFM/vG/26H+AMWe80zXYrmf1FDnserYH0gMUsUvYTT+IYXuywwcPJ89/E8ubH05zJ4PKHDwDcOdMS0sfCWoktb8TZioZx+5v6P/KXgXSWREYA4gPxD2EWkeRRTk+IFLOMTvjv9m7JhRxtn21MrKuLb0OOMTuhkiUem4CIDFaNMG177Tv7Gg6HKeVXW/C9oMQzqevuy3eLc8i3dHzPQ4hvHO5b2EJdm5CVbyfCD7zbbZ1QhL2YDLkYn8lTsIq+B546cKPyKBaynscAjLYVu8kxv6k0zyKx3/KPC5i4JMLFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable. Now read-only PMD
THPs only appear in a FS with large folio support and the supported orders
include PMD_ORDRE.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() and
try_to_unmap_flush() in collapse_file() to make sure no writable folio can
be collapsed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/open.c               | 27 ---------------------------
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 mm/khugepaged.c         | 28 ----------------------------
 5 files changed, 86 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 91f1139591ab..cef382d9d8b8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -970,33 +970,6 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..dad3f8846cdc 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -530,35 +530,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index c568d9058ff8..e7da925ae310 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a22bb2364bdc..5c9ee900ed90 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3926,7 +3926,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 79c985d7fa03..afd52e4c7ccd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2092,21 +2092,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
-		filemap_nr_thps_inc(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure i_writecount is up to date and the update to nr_thps
-		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
-		 */
-		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
-			result = SCAN_FAIL;
-			filemap_nr_thps_dec(mapping);
-		}
-	}
-
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2302,19 +2287,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio_putback_lru(folio);
 		folio_put(folio);
 	}
-	/*
-	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
-	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
-		filemap_nr_thps_dec(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure the update to nr_thps is visible.
-		 */
-		smp_mb();
-	}
 
 	new_folio->mapping = NULL;
 
-- 
2.43.0



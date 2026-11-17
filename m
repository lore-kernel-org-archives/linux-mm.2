Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4CF606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZuLvIZx5
Received: by kanga.kvack.org (Postfix)
	id 60C0F6B05C0; Tue, 17 Nov 2026 16:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC376B05C1; Tue, 17 Nov 2026 16:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2076B05C2; Tue, 17 Nov 2026 16:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22C126B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:54:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB5D8C05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:54:51 +0000 (UTC)
X-FDA: 85445966382.13.424F9C0
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012021.outbound.protection.outlook.com [40.107.209.21])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFCC2A000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:54:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZuLvIZx5;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794952489;
	b=OSAOQ4Y5xoudvFQo8XOo1grG2o0JaX9p0c3ax8IZFaz2DSglTebs0ggqyUrmPJgIVpxEOt
	xnIIWIf/ej39oT9W+uHjjvNdqdU4cu7B0FmgurqJgoHIJtQ4yjuYXS+YTp0qZLVUF+Ta7N
	Z0mJD4SQfpYMxLKy/qcBitDo127zGYU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZuLvIZx5;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHU5zrrEwXt6w3PW1dDVDuO0Oi2GraxME73dYzFWQo4=;
	b=m+zTmQPRYa+Aqs/007Zwr3PoAYE1/4tVwATSIbocPpk/s5p0vNcLQMBOIKShL7JcphC3qB
	4XW2brSuuzFIPv5r4O0N9ZwJ02R14vmIgLKwzZ8Xg1FxoQ7zPkMQ6vip1WXZcrdo3L9LCJ
	DXyQTAGkqsprCYOh0MbwZFGHQBFesvE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xD11Qvpo9QTDNKPPavqaOUs2G9pZosecRNpfm0Vg0vNeUa35GjQylVlx8syHonCHTVGZ/wr+4W6Qf+CflAV4kGBoQ5T/1bb6ZqxSXWCsm2ewP/y9CD1m4//pKGNoPcKj7ACceSmnWY6QAIrGLyiZRL4LPwMKbag+WtDsbj8+gXpIHL7mUzv26NhKYIjE6k2OMO18RA+yR5htIxzuj31rqpWnAOYv0d4HKc2LCWDtT1CqvTCVjAt5fImACW6VtY41LHKyvXVFSnNSl8Z8mU1kjDBGLshG0NjSLKvkci0VqeWrR5JClQ+JHZtcaBfYW0yeeDP/45QcLnbDHXWbMpkhUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHU5zrrEwXt6w3PW1dDVDuO0Oi2GraxME73dYzFWQo4=;
 b=eDP4km14U9D1yb8UNsVG4agvhd0BR7ig8KexYbmOafXlYTg22KxQ/Xu/rXsZkOM4WcYeIBp8cjsAHchBvCcCLzpginkg13MT5Pkc57xKCTkZ19DjQhsqsgm04to6okL5ly1lUIPSgZUde9vDNJIUmF5/yh/yXKP+S3zoQqWaiVCFWLC8vYxECXKxCLx2e31R+BfAIEtJMe/9zN28Jncy7K6A8d4lsiPAa80430Iiw+JxbxXFE3ccrALSmtOsLCDs7Kcca4EWFGdbulNpDoaurlIGxYbNt7hjxB47jCbeo2pHUh7CSNjw0GRMQj3gwzHlUyetgBavaSMBnCfcFN9zCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHU5zrrEwXt6w3PW1dDVDuO0Oi2GraxME73dYzFWQo4=;
 b=ZuLvIZx5oLw1cF4Q+vmUGjI+N60683Ddavx5fEm/Txmpuc7qDMfHzIhv5Us+g6KWcPu/phFA0CMWaGRIDDPoFSaqsJpUqQftsVQ/gcLQ7h0CAmvr1o6EGU39AcsH2661i8irslYJ54Ds2GETvsv8zkwu+0J9ib8lOBCDc3mU5+mT6tsJMIMC17khVx/jPLIfcTBttaV2nHX8dhwYSbaj0hoDVVwn0er91o+mg8wdrGloGQBCgcCXY62xkqNvtOTP05jZaCqn6AUoksK35LBSrZqCHewDY4Koae855Tkht3XOvbHeI5XTcUzeaJTVaz2kQ9fBwa0ZOE9QFpr3DbZ/Lg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB7089.namprd12.prod.outlook.com (2603:10b6:806:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 21:54:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 21:54:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 4/4] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
Date: Tue, 17 Nov 2026 16:54:42 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <95493B29-E928-4AE4-B051-F0A9651561FB@nvidia.com>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-4-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-4-276007e73bcb@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee5bb42-5eb3-489d-52b7-08df44f5637d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|5023799004|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|10067099003|261022075727099003|261021121427099003|261022105027099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tFY16f+DTF9O8uU+xFJzrxdh0aJh2OOgDgKyGzOWs0aRAuVORME3qa2kdyHF4EFeshZofYK25YZ1SkuLpmjfgyJrS2bHqYA709hteUooD5aUfKFQuPHTdEFbja+RDRQR8rWQWuCoeYeKofZlFhH0sVfSi0kYpyr9NphneLLEPaMdUPqyTjRMM+YaTVZm+BbLadRZ2wHL5KoqjlC1jJE79doDMDyCQzgJImLXk6XvPFO3rwU6uwBUHSsQKvJU/eVcQSy7hWNxrj9HD1pcP5T93lv+gjJE+o6dsJ5RBmVYDzuyrg7L5PI9lBenxICcfFh9FLyrDMVq9AIcP5mOq+uaaOXlhCcwAPTKaMDhJ9sosKc6kHxIkpC8/fQ5ebcPNpGIBgG3rRyudl11K6krqAKv+g73U7XRb5KQurngWjjQdJEuV49wvonEFaiWSuKJomH+vJAgogJRxPH/O3JWGn46L7j8dVyWak95E/OsolDu9arcrx2McG0hz/HFnqzqk54mtsuuA8akNR2UHasrUegthijjM/giDvaALImhwsoVKlT5hkY3jZh6h8Co+WI7gxsootnaoyu+fzTnNRX5X5+5ToMsX1twSWoPtH5TbMCQtCITSP4OlmKl99vOdPT+hsrjjztjvulWFIKlJt5o63RKPH4uIbqZrzPgzSw9Ksk1J0s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(5023799004)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(10067099003)(261022075727099003)(261021121427099003)(261022105027099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3a6J/aUgs/on+2Bwu51rZ86ZoYDkDAj+8gIiBukrIWNr1TNj2yFpcJa5GfVQ?=
 =?us-ascii?Q?7OPNUpwmFohgGFfmA0D3Bh4p1xMkvJgw0BxlCCKHH+ZYRILviNbPkr9zeCxc?=
 =?us-ascii?Q?13Imf00ytI+BK4nQ+DHy4rIKr/3TONRBaM/0Us+ZbEwIdE4MSJnpTJNlSEsg?=
 =?us-ascii?Q?/sanyelKTqAGE01GdL3jCRWyLj/7hkynH5tTjXeyrgLMZ86vAAvqqoRwVER1?=
 =?us-ascii?Q?jThXB9JTOxeM6Hh8AG/2rEo0Dw1tBqnANr9UWwafz9KxNbOvrPm5XTnVyqDE?=
 =?us-ascii?Q?7oVDxzhLvXLuxFPUdYabaBzmbFcgGy83y2VjN9IIZoX2fgXN+zUKdZy3hd8V?=
 =?us-ascii?Q?PZCY98jcVCmPioCCYYPSNY/C9nQWeRX1xPMXw5Jss+P/iVy65z69Z2nqNXrS?=
 =?us-ascii?Q?Rguhnvfhj6EkFDyFfqfypdpjyYwnULeJNIM6gdN9/BtE79LyLQoMqRiOGS/V?=
 =?us-ascii?Q?Gjjt5InQTvy4qX5cKvLFYonrZEtuyfdMYkR9J68vkQwlrk7FEhJn+yvykyy2?=
 =?us-ascii?Q?BcQVIlKwAjrnL0f1H3cg9v1B/gbGthIVpjfaypaSzzK5gupdstdtGd6sORlA?=
 =?us-ascii?Q?TpVsLU6mLlpwAz0R80WQI6dzxW0fkMP994D60e7r8vwh0f9uDlnoFRIWVxyl?=
 =?us-ascii?Q?Z/n8kbRLjtxYhLQA9CDAOuZ4HFMTYT/rZSUanGaPxqqctOYCp5oTtqzJWmYC?=
 =?us-ascii?Q?U+DVOIhHEJfhNsAsPxWJ+5TWD7Pr3oAyBofg2lVGYAoNTzff+rCeYYbVKZTJ?=
 =?us-ascii?Q?AD+74DYiCBG89HpFEuJ42zqew27/N4iopsbL5dT3RplrCTU+64Z4MmBbQbb6?=
 =?us-ascii?Q?K6DIq6yCdZ6FaSgmqA7w0hlrlTzl4zgW/V2CCFjtKCess5WvRj79oN+XPkur?=
 =?us-ascii?Q?VvJ5Dk3LFVEVVbJS1TFZzxuiPpsc08av8egY1tb/0E9IA/P5dR4JYoH833u7?=
 =?us-ascii?Q?vguoVSljOHx569MG4zGKuUaOP76A7oFu5viAlPwKSGUH+RRdxdRPSOmaiAaf?=
 =?us-ascii?Q?CaXTGpRFr3KqAgyLP8dUqpKg+cCpjcv0FHx2Koly1mY8Xpb/Zn6PmIWzRrQk?=
 =?us-ascii?Q?Ch2KUpi/nZPu6YCkq1NWhfoLC7rqYTlvyBjEOa+e+rXHjldpTt6R6I1c+0U2?=
 =?us-ascii?Q?+UxRbYhiKrsXgCLfNkgu7KjLkM9B1Hj79ECMsIeFAqt0+dG7NR9aGz/LwnZn?=
 =?us-ascii?Q?/4QT9NO3ebsjiNITdawyGKdSZSVXnaJPlSWTGa0Gaaegj9jVLJPIN4CXURcU?=
 =?us-ascii?Q?p0FvhGifWj0DhZTV9KPdd49uxHb3eP65JXPSAhYafcpqzPgLb8yD6wnWkceB?=
 =?us-ascii?Q?AzG4nngk3Swqxp9yW9wU8SHvcvedeFUAxUSpe/to1Cts1gl1fEMKnBTeFLhr?=
 =?us-ascii?Q?w3nipZcH1Grsz6Nb3g6+QrGm09VtuExayoVPoxlKHVZm06zsW4FirHHCxkxW?=
 =?us-ascii?Q?xIsH2QdQbElhR9Af4Ul8NLkYLXze2e9Wb6iUV4EqDyqeU6l3LZZ89d3nOh47?=
 =?us-ascii?Q?SIbZHOIMRr+nr/BbpM/Z6HHihV9EjsHe0rln9JJZaG68lh7FQBnYzBxqwnvb?=
 =?us-ascii?Q?ohZDxjx6T9waNqDSpEAa7xYErUuj+vqhd25h5RjFwnRlBnEC0GhY6aFM/TuM?=
 =?us-ascii?Q?ATobuR0WwTlfoXXJxFHSykWmB3J+8rY67nHxXSGCKce4VjGE1ACwOeaRrFjM?=
 =?us-ascii?Q?JkhSLJ0naDD1CekEDC5ujI9+B3bpd1ExAN5w/aCVQiDDCc25xagpINXDjR+g?=
 =?us-ascii?Q?1JJfe0Rp3g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee5bb42-5eb3-489d-52b7-08df44f5637d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 21:54:43.7622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2Y23DeZaveSvdgGEWzhDZ5LqQKZpJhRC6IDymNeHdR3tBX+/9ZthUaRH8oYHO47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7089
X-Rspam-User: 
X-Rspamd-Queue-Id: CFCC2A000A
X-Stat-Signature: e66reja7ozde3o8dn6b5yzn5hokjjugz
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794952488-133559
X-HE-Meta: U2FsdGVkX1/m96VsieuBMb+EdQNYOtFAGweyi6K0d823XN+xrpicRwze4a2YS+Ew6WnIW9+T/gAOKACUJ6C44n9JQfT4on1gEwBusiVfqBeGfP1/VpeToQgAC05h70nPmoo3bD/FUtQYLlFwbWumNq7za6m47PsD88WckGx5RHxJ7POwX4Rk4/JOHAbGf92TJ6pBGH3aaG+3V+UEm+YKhBscDq0YgVWV7roJVL6HzjAk6DBP8AMUXzvP4f5lsRS/vZYIy/8acH6zIbClIaDTGe7pOTPJ2S152aD6Hv3Vhri1v7Jipl26xTTMf9oCcmmYFmOlYZI02nWW2M5o9YIObkEPOuW31dZJL9t4m6ZgPYU6myTZuLkIf2uZRjOJVFoaBZBS4euED3sBR6AvaY5YG+JOsGTDCqkiiDPDuih/FB364iS22rOGF/LR436RCu9F8TCYgtjgEmpu/egRMK068SApmtpPS6u5qMRdJmDf2wadJtt9bzFaAgv2TmB0OrQomk8GDBzXFRTu1mlggVO50c+tbKwFoViyrN7OAab7LFsvKpLRJ3vS+S4R/d9pRKVMRqMEnZnxaEDLbCVQXQh8PKB4iNbJS/DWKaW9dAVnJodHMGwO3FBtGR/0PbUK0MK+kVTzBLzTZB4QUYuR49DzorhfHV4sZcGrKCAVi7BYaBc2zSw/oIYlOFj+KGxmKEGOFAeSCLp1YfMe9J2iqJL3vasG/FtbNd2M0YVggc4TgLlPsUDuiu5PR5IB/iQDrBjJ9U5Hs03Jq6EvuIvfXEHnTHFHC/v4obqGoKG85rWBCWoyTnaZXpZiLeVi1laIBqRG0fawnR0LLYcz/Gw6OhpORlPqXh6bClqu8ZMbHMH4K806L6IKG9v1DlauF9krV4ui3T27lGYPmFm1t9A9ff9pWurx/hB2POiN1zxRrfC5Ndximf8TUIPdUzdKoSSgTHVX7umAqE210I5/YlCx5gn
 oOkyZpSC
 0xkMVxwMZf31VsR4M5UvP01H3usVKALytGcSNe/Of9oxES6ACk74W++5ZxFiafkNJSzUM2WzbC2bLqjhejHq0+FWaLwonbGHA/PmTN3ti+P0UFwihLMrF8/gwb927KXm2YsCnoZPKE08PXQHzsdP0z59NV5Nk4HEeM0uwSov5Eyh34IaP8PRIZi3CL+f1n3noeKanqFON55xz9tPzm78hh3k2PTLcpCipQzvnc9zCheq0cu3Dp9MDT4FdiN3OzZhPmimh4yFRl8Ginn5nB4rZZaKnBzDCC3/OcD9ek3viWdlC/P8YsHpDQao27SrSgyE7xwcM+nHqMZuJJRnE48Nv9nbRH9BMWK10wBM6KUTplI/0A2UhD3xdJP9JW6MIut6CzwzFifV12NRTrABLf9Dy/+hCRpB4y7DfcZf6P/pMCidNFpU6w1KRyjkW8XPsgEGrMNJhiTntY7Tj07pfaIzxOc0BSBkkKtvGDaN5iRr2DQSwTbLP0/+MOtxq6bPqstK4xKNG8/Y8skOZLzNAt1srC881TfKb05PDkmX5Oyp97wRJb6RPO1MF1SCo1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 17 Nov 2026, at 13:31, Lorenzo Stoakes (ARM) wrote:

> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
>
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
>
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must be a
> present huge entry.
>
> This is problematic as if it is a write fault, it compares its PFN against
> the one being inserted, warning if they differ, on the assumption that the
> entry is a huge leaf.
>
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
>
> Equally, the entry might be non-present. Nothing can install such an entry
> in the VMAs that reach this code today, but there is no reason to rely upon
> that.
>
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> at the appropriate level.
>
> This is what already happens for a read fault, for which the existing entry
> is not examined at all.
>
> Target the commit which introduced the first driver which both mixes fault
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
>
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
My rb to v1 might be too late for you to pick it up.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


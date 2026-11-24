Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6CB606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Zge9+92Q
Received: by kanga.kvack.org (Postfix)
	id 3117D6B060C; Tue, 24 Nov 2026 02:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9146B060D; Tue, 24 Nov 2026 02:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8016B060E; Tue, 24 Nov 2026 02:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B53546B060C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:00:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0629EA8846
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:00:34 +0000 (UTC)
X-FDA: 85469114388.15.ED416DF
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012046.outbound.protection.outlook.com [52.101.53.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4E4B80006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:00:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=Zge9+92Q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of arighi@nvidia.com designates 52.101.53.46 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795503631;
	b=h3E//6TzlZUabMPo8SBs/pI4EmTWuW4Upc0r4mujGUs2vSxbRryKPPsFFMLE1b3EtfvqH7
	TljK2TfXUdT9LQqN20KOLnIc9qn+2YDgQU29ZBSv4eLhBSOK4k1lKeP3XCevdlXZe1U9Ga
	HAPy3BJS41fReuYSmIHWd/tlapr/nWs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795503631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OK8dpi252IPkfh9VsPtEH4UrDTMMf1Y9fXdXlohCeBw=;
	b=uxdXzmLMRN7IkOf8yr5IQxIYxJ3LvFJaHYlB2cYrr8cKVaYxMkhLmv7DVJjZzVNmK2e5NL
	xzCfAJ2aTU2OJQY7TgWZF9X+BqCHKNZMri3+2esRxo3eCIM9zL3RHU3bXeCS+uau+FyZSF
	/rw4ifFGAnzYg3qhgQmEu2rZSX9Wuak=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=Zge9+92Q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of arighi@nvidia.com designates 52.101.53.46 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7L6Soso2XwkbnMowA+24c3YArnKDDGjr/6xWrUBop18x4Jknt9MxwWUaEIVK15Xdbkm2sXdqDMRnlzfJv4uJc1ol4V0AFmm9cG+Ww11WnsLC/QfwIVmtCGJKAplsTqHYc+pP4RUIL3nMSaX3ufZzmrK364CaAmhqgA2/LFSfhfMO735oUJ2z1vuPnz3cHpFfFYJx52SIZQpmNpFTGeFFHjlq45IFfP8VtPgYXBM4QFG9Wfie0N6Eyd8AfHvVoud2j9A8kZerbhZIlzREbOy8+s/VgeGlLxPvee2s8+kh1tJAHzJ9IwMXaRzyXPRPczxPbd8r2ul4AP0Ckl2g7y5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK8dpi252IPkfh9VsPtEH4UrDTMMf1Y9fXdXlohCeBw=;
 b=G87jrAP+gupVJyHx8InUePsuEbIS7iT1tUyCqTCIiGUeQOhOgXOLi03SXw6YdKo7rGB2pZTC/zQCuswjd60FMJpYSpcanMvOXnb6gFOKgHhrCgHJ9cF+wt766gchOJuY0SJpbXPGEzUQX/9ZFSYMmQxiqfs5XRm+4wGIpQi6NKdEAd9U0wC3GxeDBmKF4wlLh7BP0I9oV+dse8h3SjRCjMXAzWV0qAIaZuTqk7kac30mNecD5+YbMKmaHPqvQo/ROF0GgYikGOgiaAh9HVynRW4dwoYxkI3oLm1FBZZqDPw48LsiF1x3UscdByvqRkH57p0dQ6E1nJxkRZuBKxm+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK8dpi252IPkfh9VsPtEH4UrDTMMf1Y9fXdXlohCeBw=;
 b=Zge9+92QkLgtPh0fjiruB7niTk06D19613gP3o6sUOKmG5XEZWsGvi6hm+aPqH4DPM4Vkg5KNGh5Z+S6xh0viq9e0fnFDR/2R5DUF738SaOHs99ZPBppoXLia4o3P4UjkZ/f5rfP8TL3NRz0nlWp+N7En+EZnWXSiujAFYTVB+iSSpWDlU0Hphgtenwpeb9w8tw+j7ZVrBOlRpiA2H8+xcnMom/6I8hMGMh8zAkVS34Guq6qAegjJBxAjzdalmMSTvBTw2Octr5po+VKyf8/LcUSYwijrw2DvUiKXHytprzarR4Yg6VgYzhsQt3zou+Io4co4XPzXE+YJHGSnddEmQ==
Received: from BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19)
 by LY0PR12MB782425.namprd12.prod.outlook.com (2603:10b6:404:22d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 07:00:28 +0000
Received: from BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9]) by BL1PR12MB5174.namprd12.prod.outlook.com
 ([fe80::58de:822b:868:96e9%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 07:00:28 +0000
From: Andrea Righi <arighi@nvidia.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Vladimir Vdovin <deliran@verdict.gg>,
	Gregory Price <gourry@gourry.net>,
	David Dai <david.dai@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Lee Trager <ltrager@nvidia.com>,
	linux-mm@kvack.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sched/numa: Only pick a fair task as a swap partner
Date: Tue, 24 Nov 2026 07:59:09 +0100
Message-ID: <20261124070011.2498455-4-arighi@nvidia.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124070011.2498455-1-arighi@nvidia.com>
References: <20261124070011.2498455-1-arighi@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MI3PEPF00007549.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::4d2) To BL1PR12MB5174.namprd12.prod.outlook.com
 (2603:10b6:208:31c::19)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_|LY0PR12MB782425:EE_
X-MS-Office365-Filtering-Correlation-Id: c1786394-68d1-4d39-af95-08df49f89f57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|3023799007|56012099006|261028144727099003|11063799006|261021121427099003|261026140227099003|261026121527099003|261102123227099003|261021123027099003|261022105027099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Gr4tgkuOAhUirytIp7gvTwloqJseHilmqzLxW46Moceh2v+6vpR/shs6+dVs+0WVlXlG+8lR+iii+JPlM1nRefxJXoFOtCqSDC+ODn2hLaT1Chj33sQZ9WtFNAwDIgjkceIn8HYz9smflM8WUI22cKSHCmRUOiLL1HPa2boPIqykJ8wAYRlKNw0uSzyXCL+09/98hZCnveEx1wx0t5PKUhtv6CXYBLtTUzLnulE30SjGm7uuwpNCUz8Om0cM9OerIdPHu7MAfaurC5nJKbhOtJ6K2w4yfPa/8K52HBkDgKFgXZ/kq5JeZtOwqvfZ+fihqcbBB61qp1K18pulBYbiiJZn/cWJLS40hzU77WiTVMloklGu6c95p30NZjnWEOEd3lZcMN8pAzQfmSjHnFyAtnu60o6KkNq2RztGGBkBv1SANILD9LIV2IoIQr5ZO8lBIpX7rUyYQbEgBha/koMXdVya4VMW6EoT5fGXVXXYLo7cOXrv6AfRbZIXlaeLtOhaVYX4XPrW0AuMOltF1OkqgWwrm4k2vt/RmEIQ1i/9OS2IJA/fO+IWq9m9XJFqAkZw0EXExcLP9WUPhS44dzCkFDKTKt+JCePFAJeIo/WMYlAwNoRpcdDlseH/LSau2VY91lfoVTAqEwMkyPU5ZCIcdiISdqfy13JofxqF8xFaDcc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(3023799007)(56012099006)(261028144727099003)(11063799006)(261021121427099003)(261026140227099003)(261026121527099003)(261102123227099003)(261021123027099003)(261022105027099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k6nBJrRCrAoql/qUuaa1YUOieAoW0Ar14xDOWKSKziu0FfWUTM3URLvaYn5v?=
 =?us-ascii?Q?CtLPw+nphxCFZyuJ/iYImZIjfi/wr5zEx8MBruXHhsihGqKHFFbtWb4MOu55?=
 =?us-ascii?Q?c9EdaoxM5EXWyWgCrG2b99oHksZQ6Npgue9tKTSmU7IsIhnMoXERGS0Sbl6z?=
 =?us-ascii?Q?p29x+teqdWt7QonkpQBW6Gd5dHh7Dy/uoO8DX8kibshHZp+Tz2dZolJ3lNAK?=
 =?us-ascii?Q?GiLnsQaogQiFkKWHAg+NshNUpuPkryOdrWRmFROtjnFNe4Zy5Jx3XjS5UC32?=
 =?us-ascii?Q?HqJpdBT1VTIHt3pFmW1kcLr0tsmJLdfj0sVjnqtduyGuvBmdNy6SWUuu5jsu?=
 =?us-ascii?Q?LfjNL7auvQWs+LQC68lcYy6IAR3bjsaTHSyYnW7AT3laJDdFIm0nTAQXa249?=
 =?us-ascii?Q?2vz5iEj8IONFgT2i/9TJ9rxIygZQBBZG7GxYL//F3FV/5YIngGM1pVT+p7dQ?=
 =?us-ascii?Q?WctpOWaP0JHWnhSXKv+sI+d6kxa4tPie4/0ImSQV4Uv/MF1YgqYM81wm7vVq?=
 =?us-ascii?Q?FLfAGq74D66d7YW+676HCC+A0Bhz4/HNxOYSAvCRW/5WkpF0bC9LrhO5sm0b?=
 =?us-ascii?Q?G0fxrzOFiJ61id/vfFVLmE8zTJw8wyO6YfoGtrRsUrEFUxQLtzhH6qHg8mms?=
 =?us-ascii?Q?E1d/5c5JewiQNbz338Pn3MzT972bUsE9tgPBysYrCVii0aJCE5wi6I0TUjux?=
 =?us-ascii?Q?AGauKYpYOTeDHGIQdGD0q0B1YAIHkCBq9YH8pmjL8ZUq63iCMxPcp0fhP7ed?=
 =?us-ascii?Q?xP7QjPqj8VtjBBFirgBO6NJZkdr/KFGbH3ZKUuCkiawQsm9/H8/HsW+9uthx?=
 =?us-ascii?Q?w7XYgpmitNKTejRWLveFQN2+t7c7d+Zn7ngun+o5u3fPuQGungE7Y2mmWZ1U?=
 =?us-ascii?Q?pu/6lzY7R5e++P0y4DDfoDs9cNuhHuyMyPUMy+ePDXDc6YYTwxvyeIq7hxJA?=
 =?us-ascii?Q?eXjUd9w9JGqJVg1qgD6iRWMD7QZEyGqSZILrjdfYUxMu2G6lfLZxF/KKLOsw?=
 =?us-ascii?Q?gPHjYQ7cK0MvT3N0B0470OJBzQhqz0tCNUInLMJYez/riSBXukpeMZ3tm9Ps?=
 =?us-ascii?Q?+a8XYeRzyGH4SbbgEVNSJGuq0W4XSPEeR4HdL9na5ggA+Se0DAAXwCXZmP5d?=
 =?us-ascii?Q?hyPYrFAi0FFIxmGVaxovtW2KDuHHHYVNlAAOCWz4ESZjRl0COiXHY/5MUlEs?=
 =?us-ascii?Q?3Mdl5x7HlJXmRnpnZwaKhFK1uxQILqQseBsReXiTCoYxJknWjqn1jGf80Xjv?=
 =?us-ascii?Q?PE3U1p/1HkeevLE3XS7OdTp66NmV8jFQIPyG83/irKPg8kYiXT7gOjd8buqI?=
 =?us-ascii?Q?sd/n4GrH3+aZlaXqExspdW5lXoH+rA9X4dyhjbw+6gjVcaAOwJ7s7eAamv2x?=
 =?us-ascii?Q?q+ZI6YIA9NjG6+hR/GrIS6TqI9HSTTAalPAGoeprK4AAMnTHsvqkDh8tAzRX?=
 =?us-ascii?Q?UwSxAWQH7euevm70eYJCI9IcXpmJ6SleNHQCSq2YcAXgCHZKRXfwAarFFecY?=
 =?us-ascii?Q?blznvm8ynhJgMoS7nS1dqkJlEDrJKFT7dDcnr4OgjwfBaUG/GBj00iUif5bg?=
 =?us-ascii?Q?LuGKkI9c/xf70rUX6Tj7dvrywKOnd0HlqgE16btKNmt+nTg/zTZMjgBQBayy?=
 =?us-ascii?Q?47nn4OVGG6asnrn7T+IDwxeI0aV/dmZfXRNUPYN6CECBHGIPLnoaNfH/c1vH?=
 =?us-ascii?Q?S8Z1D1GEKUM1YTulCs6kuJg8pG7zGPFQiiUob5mBvLeHLNRg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1786394-68d1-4d39-af95-08df49f89f57
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 07:00:28.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XblkaVxKFWzjmbmvIIELK9khp6I/fT3uFRRLn2gP3k+kD4MJQcP6xFdHzwC/bU0cdSrje9PEKOn7DQEoX6pRmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB782425
X-Rspamd-Queue-Id: E4E4B80006
X-Stat-Signature: 5e1mue7csw19ye8nsd3b17rahric4pnb
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795503630-355534
X-HE-Meta: U2FsdGVkX1+zOulvhp6uNvx2La0/aztGYAE04dKcXOSmgZlj5/JkX5j1T451GX/v5rGBrj96LlCjpe/jiRQs+ozbSeUZzML0viWZ2OsPLUSq7OC0XVMAPH5txt6tUt+Dqk0VHh8VHvMcB7RqHdYHPXJ8jOi7uUE6XU6zuv84nBYSI5hb7Q7AUj73YXEnr5deTlkyLmv1xs2+iP38P5d4LWfoed7mZW2ZhSr8yazMPIQiw16tXnTISIAeH8cKYWXzBHYCshx8s7yRkrw1t0IZPyug7zVIfTo30aZ2ciaSeilaVqlMXxLy7UXOhzlXPsGYNSLr6AmZXvQIxGxzLlGPbSWq3OLE+IDecVkJSKhy9RhvRIkS0s1twz2tBLfZYGjDpFbSayErwOMnBHb30Hl1bnB2+r0JGv30FtJxopkU5m7B3R/gQShtmzpLmS8jx/s0uXhsd5aifR/nZsi4GnPDEJ90kruQRBtSWTnIxm3kshu8VoihDx6n8hVE68BbtT6yPSbeRudv812WQLPtO3BhkvyyvBb0PC7dbP/xhH6MHn2YaQ+JFD3H5gYRuLelz/kkakchJ2FhDTlauTHR+SweYLJXKrVs2IZfP7BViDPscup0FYpa21ulExzLDcs1SzCAjC1vf8TDpnceXWsC/t3KqkE4xI/wqQDOoYKDjA7Mk9gN5RWzwfLztPVxnEzxkyOXd9QcL+hO+KuLD+YEkOgJOSFZPQmyWrrdxdMvoGBOBX6JbVD8y4HNZdu+fFxEFL55mTdvu597jCLLvVCOl+txh9/2ZJFGnbeSUNykwKNPZ25W29SEaZ5MMhAbJFRaTSkrmT1T9L+BbFH6uKXOy4KNaQytBEQz/QZELcYXDAGjtJI9SP/Ujrmjn8IPmRcqe3s4USp0nyrjAOMylaTKgfkn27dps2rA7BuvmB5KU4jlZfw40TixQASJQm2AErzXNJZvRVI83oxgH62AzfbST/c
 Rrlx9DKz
 0kWuiJmbniwtn2tOxvwbGg2e0Y51+RflC6tl5YIDvhTVFTlKQuBbnGuWF4dazW/nl7ralMm87zW0A224MWJRQJgijm1T+tSm5QRQt0KkOLkACIugV3SCn8oxAwt9Utcne91seUDE23oUGv76qHvvKDgG0oJwETNYH0bnEX6/qRGNrZ2q+avI4qGyTl7sOppYgxpSVRNUmL0feyd7DaFnJavNhTuVxzJfWKTzhdW30d3uvDqH+6ugi3RHjVBja0sUXcbXzRxGxxu4HJ6K7u9MXkGVTmKb28RY0kHA9t2hO1bmStTHdilmAN2ynfodSwYVi9XrIIcrEVTXJHKR7z6piV4nIouUnR06SIl839KHMtE40Aspv0+VKFqTZy2JgJbvW0kDkZSUuRX4InSIyTWeahDRECVmlb+ccxGPhwM7E8IC9Oejpa9wSXLStL33NkltZI8BZ1v1/sPOtgmVPe7dwAnjnH/BrDSc7bLldfr78kIyP9rgNXgDUwWRBT0gT4fDjP2is0tGyElOE6faurU5HJd7x3MCC0db1RD42l4UmZjMNAKj3tVqKlgTpJPXDlHiuyT+JGH6J/pNkylEeS84mVTfHB0iPLUbj7S3jGOon+soPR4XYCnYlCLQLxXC9Gw0KV1CNtO29iW8NfLCpSHMLTjyeY+tZ4Y5Iclag8thYBwcynhMxA4DbKiJmNIPtR+p2YfzFVtESYTMCwTxl+vYiS0s+A7rAZVFNyVQFJ14pVGATopHbv8ncz7RcY+IlB/PBW+SZNns8CWeT8mSuptiJfVJ3IICfUsLOBnLe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When NUMA balancing migrates a fair task, task_numa_compare() considers
the task currently running on the destination CPU as a swap partner and,
if it picks it, migrate_swap() moves that task to the source CPU.

The task running on the destination CPU may belong to a different
scheduling class: an RT or deadline task, or, with sched_ext in partial
mode, a task owned by a BPF scheduler. Moving such a task is wrong for
two reasons:

 - its placement is driven by its own class (push/pull for RT and
   deadline, the BPF scheduler for sched_ext), which fair would override;

 - the swap is weighed on task_h_load(cur), but the load average of a
   task outside the fair class isn't updated, so the decision is based on
   whatever load the task had when it left fair.

Treat a task outside the fair class like a kthread: never swap it, but
still allow the migrating task to move to the destination CPU alone.

Fixes: fb13c7ee0ed3 ("sched/numa: Use a system-wide search to find swap/migration candidates")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Vladimir Vdovin <deliran@verdict.gg>
Link: https://lore.kernel.org/r/20261002124559.10367-1-deliran@verdict.gg
Signed-off-by: Andrea Righi <arighi@nvidia.com>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5f420141c3026..fa0cfd48a133f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3223,8 +3223,14 @@ static bool task_numa_compare(struct task_numa_env *env,
 
 	rcu_read_lock();
 	cur = rcu_dereference_all(dst_rq->curr);
+	/*
+	 * Only swap with a fair task: the placement of a task in any other
+	 * class is driven by that class, and its load, which the swap is
+	 * weighed on, isn't tracked by fair. Moving the task alone to the
+	 * destination is still allowed.
+	 */
 	if (cur && ((cur->flags & (PF_EXITING | PF_KTHREAD)) ||
-		    !cur->mm))
+		    !cur->mm || cur->sched_class != &fair_sched_class))
 		cur = NULL;
 
 	/*
-- 
2.56.1



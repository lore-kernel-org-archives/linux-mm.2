Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F042AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1396B009F; Mon,  6 Jul 2026 22:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70AF6B00A0; Mon,  6 Jul 2026 22:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939216B00A1; Mon,  6 Jul 2026 22:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 620386B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:17:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFB271A02B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:17:06 +0000 (UTC)
X-FDA: 84960368052.17.47A7D8F
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011016.outbound.protection.outlook.com [40.107.208.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 47767100004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:17:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RTBQ+bi+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.16 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783390624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ez3fE9/tS6Itlks/AFDPNZBYXHc7sG383zFBhvlKEu4=;
	b=tnvrqyCSy1Ga/GZStnJBJkYbm9Z0OHwLNwD03+/X+4SBpq6eRbuo+ppND3exp8x6htdXMC
	dmbJKBgpEPwc+H1BCJBeL81gqMmmyh4LY9CI1BY8v3M6rXCOE8LH7SqTKAFhaN/gSz62mC
	cBzLyZrLQOqQtvoM63MvsJeL3VayJx0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RTBQ+bi+;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.16 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783390624;
	b=ZqFqkbEbrHf28qoUOzKdjS/r37ktI0dhj6vKJrtNIG5fVmFBEJDX2ZdcqrkrwqzzZU4Paf
	N1yxEHimd1Ve/dKV9gjgo/DR9gSuTK4RwnY+b0uiEN6FmB59AjsdCHJWRhiZvJSEBrRPrV
	YG/QIzoaDXLOQQAzGTb4RnHqRmiH1r4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbVE/NoICa3ggM3gBx4BuIb4dQgr4u9MjlqRdReyI6CqMrivyQgxQPa44QORKVqG0N9x2aSb0mfyMqH7P6sxlHwnH63H98kCZNPtk6LY7XF/Xfy4s74N1VMsyYYqLvcC+B54FN75jfzTt+NuH+C+8ebWiy2euOl6nnSeBlk363/eGB6hndZWstxB5g51/P6eVx6DE+H66X60+m+KcwkBJOpzSs9HrMt62PkZ2s9b9syCrGGkgEpR661Gv70dcpoNlkUYZmyAT2R1ylehDngFBBvoKnKOvqxnq5AsbxeSOM2dVSz4MhXH1EH2PO0ABfda/trJPoeOAhFJRO1EoYGIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ez3fE9/tS6Itlks/AFDPNZBYXHc7sG383zFBhvlKEu4=;
 b=Uc+mYbj35Uhj4tUpUBHy/niy3Mozu2FP9OkWLTymxCNOTgwqe3fOtn/xi6QKwAh+qxXlprT0EjiEuUtOwK0wY5/VAmDZH93TN1iQ/IipGIvBSPJBUBeMb9dD7UymEsBPauZ8yX345NM0sAZ0aGLaE34SdD1CbMGOg2mQDYziRvqFEo88VFSKpt0K4W0gXzvM+s/SWcihzwgCGkrzDLZbeZdoP4I+2+uvZ7R9XJ5Coj2DEqO8zFWKTr4mTzLTDwAcDeUG1bB2HV95KMGjGDIkuRvtnI96JppM8MHisjNBCPabAhnsnnwaGA6gP8Lj0RHICWsi5ATcNozy2kE5IUZ0/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ez3fE9/tS6Itlks/AFDPNZBYXHc7sG383zFBhvlKEu4=;
 b=RTBQ+bi+/ruUd8CSs9pOxguGAN+8k39lvO3A58qXENIGw121tDPUWgCYBuMA9Y6992OZGQDUX49sBfT3tkR02JXQggyzBrSQSPSrKaYc5nF4C0VhImQevREwlmgYUn8Oc4MYyqa0BcclvdEkSBUXbbjQFpRlMCLgzVdiosHoyfo7yA8ykleVuwL/Ak0L6/Z/1xUY+F46X/pijr+VQC1yG1cvrRX8aV8XLWgycTJELjavPS65BwICXYIGeE+SHxEy3Wch/SffdxAgSUJ9Lt+CHPcrQQr4wY5jbbKABKY/LoBCNNe+Wtf8R/bEAUkkU3M3LoRZuzIwqawjzWatq4LA9A==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Tue, 7 Jul 2026 02:17:00 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 02:17:00 +0000
Date: Tue, 7 Jul 2026 12:16:53 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de, 
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org, mingo@redhat.com, 
	rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v4 1/8] mm: fix stale ZONE_DEVICE refcount comment
Message-ID: <akxg0LSkohWvxj5w@nvdebian.thelocal>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
 <20260603080152.64728-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603080152.64728-2-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5P300CA0088.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::17) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb93e9f-24f1-4e6e-7d79-08dedbcdd3bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	DonFzFauFqqLbqgZGx7CZGtta45BhdY9TRpITUwNH8nWgI867uV+nPtC1XYicllqWlSi0N8pjsu7Qr3pI3sEQN3X9VgZT04u+8j3qqFA2GT33gNxSUMCB0cBmPo2NncNB5PKfwH4HYEbEGYoyizUXNbVKaxEoZFdpEXjYL3SzfB7DHamJE1F+5JnFZ77mYvsFKRrTsAYehTq4gVnK3bRM2Xl1fsIR78MIc8tTD/IP+iZIetdd1sKhdbNU8EZq4fzquZMA3j8++apW752/x+qw7K1DfEoPRWk2MMQVGGebFekUaSF1uVfB3SvE0liyJLmkHgAYaXUGcNJXoeOLrQvt7R0ieiLOrcJlEBXZNjUY7thD56sYwO7Wgi84U0n4KGYnyBnQ9UEsjvgwSjKQc/QhftZw+h6yUCx04M7GlJ1E8K6hDuzb7I/a1SSfhPMcq+06ag64SH6o0fjoLkYaZ9BWcl8erjdZPJDrhnU7krOJsDfM+TO3zOwhvesCFYGYboFDEvcRrJmds6zos5uVCaCYq2ejsqsYg15G6GzKjVMxbr6ZW/KBNl+5pk5ZNEJSkphb3d0lPEQsrpQK58xkeasjYFFiL7QUDwPiypuEBXczRRWhc08G+uGD2/bdIQLEVFoT41o9rUb1jcJ4Yqt+a+m313Pcud59HtIOjgrITJ/6Ms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U6XkhKMN+XbjUJv16e/PIOwLqC7ENCZ3dPAhmyzPk2fNoJqrelZCryy3QnwJ?=
 =?us-ascii?Q?kwotsdFBafodMemdpw99MiUya8+ksS3w3bIdO4ca6jQYiqh1+RzJF6QTHJOm?=
 =?us-ascii?Q?DHxA2Sqyfc8OuF83icbnDNIuZ2K4XsP+xoODJjedfSL0GE/wF5rOtshZUVCp?=
 =?us-ascii?Q?Hlo8mMO5IBGc0ShYtqhj2+Ma5hsx4vSqHYmSxIkXgE8C+4AtyBUSSyrUbybM?=
 =?us-ascii?Q?9pf+1N6cxCjHueXWwLq316pjqtt89CqaX/iEM/4jLCgLvGPCIT7eQz0wAX5e?=
 =?us-ascii?Q?w95WTOfvFAY1HW1NSLOssyF+fqiDpm3C/NL73JjjWpwE2waZCWq2sZlZD82O?=
 =?us-ascii?Q?qOd6XcKwFGO+N12K5l1rWQXq6MZizNLD03rAeicfUReNk4lAAnmtfUlvNw/E?=
 =?us-ascii?Q?sGTWb4CKf7ggA0yw+jWOSxNXMSKiafpDw6kOJTM10PM30aPNShTElahkp6Dx?=
 =?us-ascii?Q?IOMXD7GN0ljV7S6drZWFlOM/UzB7jFCiWCi4GAi02vwDo3TK6j9YPgMOKX+t?=
 =?us-ascii?Q?V68tR4+wYMU9DzjC8ZWaT28iAeQZ+RpJat3G/D7buhjB54o74TDWKV7alroJ?=
 =?us-ascii?Q?tzT/i455uVwSN+j9I3sCPTsb9oFGipbrqc0Ymr7Bixh0K6Lmc4fhF/wKywdk?=
 =?us-ascii?Q?0mHHTrO0SxizBlWhXPyLgoQLxys8jizMAKFE7Hk9Z0mkrhzX3+AN8npbFU6q?=
 =?us-ascii?Q?EphLQ9LsDfDXsske1D8kSdLE0bh7RPHKPDiXvwncv+eKPoDkI1Cj8/XdO1N6?=
 =?us-ascii?Q?zQdOH/rPerUF6F7CA2kbZZfEY89B3WPzMXG6695WM7Q3PjcGZhu+3gRXVpSF?=
 =?us-ascii?Q?LO4InErnrnx1ddXvGPvY3k4NrAFW5CEmXGCZ5jokL4hLVuMclOK8KCHKXRzz?=
 =?us-ascii?Q?wGi9hpxr680lPaZeGMBe1WbDVB9HMQtHbW8geMrPnY/XER8HnzvWIYUGvjZQ?=
 =?us-ascii?Q?cw17e/OTyLtrttlc+GLB34IK63m67smw+QJ4JJw0qFkwLD1e1I8OGYO2idS3?=
 =?us-ascii?Q?OQU3yk8fWCnP16VEU9wCjJUVlqDnlAC7rOrZEtxQIYPlmFADZeuwHb/IQvZM?=
 =?us-ascii?Q?82YELYUGfLfWPg3q7/8KtnzORDRtcF0aipzHbbek0qy+CNTRB3G++xj9J8gI?=
 =?us-ascii?Q?fPyzOSNnF67gLdDnEcGlD01AibubKPUyo47avHaItsPiib1D0XHiRHj/xXc7?=
 =?us-ascii?Q?/OoP7yF4gjlJ3FWg8PJ4RxR2bOrZ9zvNN2hetAekgHgkGH3l8Rp1up9/M1qw?=
 =?us-ascii?Q?32qji39TBieYtrF0noJZlSc2+H7oFzz8tLomdrW+cVrYeIbuuxQINRd2SHyY?=
 =?us-ascii?Q?XeT7redQh9KKPty5nAn5qH4FJXgzbFgMr68kiKDkxJ1/PJx5gu++UOiiCp8Q?=
 =?us-ascii?Q?PUyn3zIiKkyueefzRvb/v+TLOMX8mSBT37RAxTKFiFMEC5YACQamiJ9MjTK8?=
 =?us-ascii?Q?6svbgWIgsb++i8vkgbbPc8M+navkLV41ei/eYetiJ1kFlAd1aSCWcpsrLKgx?=
 =?us-ascii?Q?iUdGKOpXkZy5Mcr3HfzMnAMmUCBN5O4+DTcvjNUt/5z4mdidNTcvmhCppnme?=
 =?us-ascii?Q?qH3zLpfaHVisRm3uAj4h+KDlvcY9S+Tw2GVqoR6QZFEwCYBXEHU7y3yBaEbG?=
 =?us-ascii?Q?07aRzR6G2nWxgvPbH0GnrIhvC8J0UHDpMpQofzC4M5QDpxNBIwdvU20Cbz+m?=
 =?us-ascii?Q?C5C+NR5rebZUYWWeYt347YbvDDzBlIyNYlNOw/4ZK78nF42lZwCBUP7p7qql?=
 =?us-ascii?Q?UYfry/mM8Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb93e9f-24f1-4e6e-7d79-08dedbcdd3bf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 02:17:00.2245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Kp6J0pe396ATkUWyk29KiCzeyjWc48RfuRg91Xqwx6UIhqqhD1N4oU4/2lxCMpXqGKP6EucToXZ0zBW3558zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47767100004
X-Stat-Signature: gi3ddbnk1y9qys5ey7zif4n71nbhyemn
X-HE-Tag: 1783390624-799394
X-HE-Meta: U2FsdGVkX19HodsrCE+nrxX56f6l7P9rJ+myNIZACwBIXyeP3XQmtEr9A/OK9mFHgc0oB0xNUfiU3VggQeAT7lOnx0J0U/iRtCzL7Q1XRfffzP+1jlvvpaeNYY4TfjPs8yLPNxSW0nGnjCxdABFatHbkFRTGND3NWiowYINEJe8OkyFyRglovRgP+yltNFlu0PSfahEbfkN9NlsO1Wn8wFIGliWBvmRuhggz5a5vUXYlqk7tHNq6MhXblch5rL57QDAUv0VIbj79beQ/itoIqPl8z6iaAKMDq2zljIWDtvGMi81Os4qEbErCPNd8PhPGlb8wl4QNegDgFggdA/uynd9GJOwDDn6U5XX+OIAU8CJnqLh56HVPlP5S0fWj2wUDiImS/CfGqOjF7znq4Ip0fs2SgtnDqxtJ7oitbYl6Xsawm1SncMp8Mo9c6iWU6+VpWNJzVGdT9fQH+EMhHB1eqGPaGTWzQ2wzCfZTuAVDvl5UhNSBtPenELngTejP4M7236BBYR16Sh0roBLbecN2qZVy/o396sz5CI+WYDWmYjvwPE6QGdAA/LRk8qPgv/e4tw1j1ZGX8KARgta9rD9JKNFeMBprfauyumsXez9r6PTZE1lkMs4mlpYscgmhHar1IRIjz2Gg5hqzFABNRPx6J1be0bR4Jd7bf3Qjj6xBKEZpeqATo5DLFJuRxT2dsKnZCIHgCh866SvT4ANZVu+llAZ2F4BpGJgh7CEUlgjZbKmQuCHWFvMKsyjmWHYoVq2lGjZGNj5DswNWVVh3BHPZRcg0JhVF/WVTsuNRpCL7ZDslrONdJGBStL+cetzYc0cOhSnuo9ChPOqlbp8tmSVzjHMPTiYI+FtKVaQy1y3/y0S7I/SMt2Bmt6ZLFVDZfYoxts+R09DUyYxzsV3wmQbxj2l4J32iGGmtSMOhy0tQRk53QGtPdTEqcmnPKOub8AgPNuyUTG6TJ9vQyMbwRiU
 7Qfa8RD7
 yz/nJuH5GU2Paf4vGsAj+tMckVXWzOnodyus+plWRSdMGIbWmvOrJwmv9V4W1Rx4fVVkYlsTT0S+72k6nNcKfL83qKA3wIIkD/PnBCI3CGih1A+0mKkQ9AXsQeI9m481p65C8WPt6h022MJzTdl7tu1ArFuiQCUGWLVWLdCgtTJs7e98KH7facz7uwl+6gnv3pxNUdX8j8Fu6bNfUfEW7kwK4TW10znNi0NTyto5G5Hifzg8YDHKMpgHsT4ysuEoFuwZM3n6VYAbFz8sDCE+ZPnQZotTuaM+sNfHEPq+OY4QfVwMhF6ydDLSdgFbGmwmkckS3sytHh7pdLQ9GjYymnq2zlOgUDaTKsuRHci/lw/2dMa3GtfUNjXrqpnnhge0BZCm9XEZgX9Da6yWybX4LF0r+BVi8n69gInIM4o0Sto5VhPQ8C3PeamAMIJzGQC6avRsGe+uyjP1x5IjE3y81MJjgBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 at 18:01 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> The comment in __init_zone_device_page() still uses the old
> MEMORY_TYPE_* names and implies that FS_DAX pages regain a
> refcount of 1 in the free path. That no longer matches the code.

Correct, obviously I missed this comment when updating the code.

> Update the comment to describe the current policy correctly:
> MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
> while the remaining ZONE_DEVICE types start from 0 here and raise the
> count again when the allocator or driver hands the page out.

It would be nice to make MEMORY_DEVICE_GENERIC the same one day too. But this
change looks accurate to me:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/mm_init.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..35de3b6a186d 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1027,13 +1027,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	}
>  
>  	/*
> -	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> -	 * directly to the driver page allocator which will set the page count
> -	 * to 1 when allocating the page.
> -	 *
> -	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
> -	 * their refcount reset to one whenever they are freed (ie. after
> -	 * their refcount drops to 0).
> +	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
> +	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
> +	 * the count again when the allocator or driver hands the page out.
>  	 */
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_FS_DAX:
> -- 
> 2.20.1


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB53FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207BB6B0088; Mon, 27 Apr 2026 07:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD136B008A; Mon, 27 Apr 2026 07:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7436B008C; Mon, 27 Apr 2026 07:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F19846B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:52:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A26181B6F30
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:52:35 +0000 (UTC)
X-FDA: 84704173470.23.6B028BE
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9F7314000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:52:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eS24ZO7r;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfRPYwjlCLXyKkLvnkjR9yRNnBMPkjpaeClEfjulULE=;
	b=A2XejhAAVmh045ovggYgFhz5u8q2/1KwgMueaGmONSUjAHkNN4quA8miEsOjEGy5wX0Y5U
	CAkpjjXoZ6ppjN0SEb/616ws4ucyfV2bOqQnyUf2CZFZ5kBlyQNBvK4c2G9SoJVl1fBzAQ
	dnAwFvcUSQCzSp2lFsKs44UMNqSndeE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eS24ZO7r;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777290753; a=rsa-sha256;
	cv=pass;
	b=HK//x78tMuoTztfgxv/RmoC70319TNh7SDTYVDky9OR1YDctEvDOL9Ex8nfGbLlP9ihHGc
	680kAR0WrSMMZ2eDBL4qijl402oyWtk9pYCSeK8wVWnDhkGnPNNvEMX9p09MlyW0bOAjNj
	1IHsVJENftt5eljzkDoISffbC5LILUA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdWMidZ5ikj/mFl5iBDnyZ7IumX1pZqTAlByos7zWf4awvuXULai8hDVsGtkfcAxkr4/bPZ0/9YapnTkftLfKx7Tr51AotZMARfEq8+6pY+s4JhiwAeohrKd2MJZBYHOCJp/T3BmQzLg9vlFPkOw2elJd/oECW4uXNarSUt/vbG3Os//nwkhUfUB1LSj5lSX50aKfErqN7IUYx1ZWDq5ZIF84caRynHzKLb8IfWGFhuNoclHmGUQDPH0OkV9xFSCoy1iV07Ob2tyjy9kzP7xmAdt8gxXjH8r+KB3tJqURZOeu5UeRZsUIQcqnmLv8dCgIMSEYo8ef/0uapkpIh4Svw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfRPYwjlCLXyKkLvnkjR9yRNnBMPkjpaeClEfjulULE=;
 b=sDarhPhzJoE8X276i1M0U2RKloijP1WKQg//ZVEHlA0bSKP/tn1PPNzLnwLFgWenJOu0SbwVCjROot5L2+AAu8sS6/yHFZ3ZoJJV38K6iGSje0l6XbWwrpkVwsisBr8UYRhOcy3w/PF96tD8RG2jDO5Widdbq2ZSfSn9MBiRCXpAXHFQpayul8FWLv0DEkmTYl9PIfW2NN1BXoT8uuBO3Fy23c2qWi/HjVv/AJ7AdbNZyDXudurKodBtBWCIUU5QKo2FfXaXZY82N8RQK4czO06O8+FhhIr38mE/gRNLi/kSPMl7+gbsiaoyGZ7NIlv6oaz2MQHZTbbgsz7a4tcOLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfRPYwjlCLXyKkLvnkjR9yRNnBMPkjpaeClEfjulULE=;
 b=eS24ZO7rg6St5Hs3hzC74ql9QYi0GF8gao9m6gN3JrJeTPeaUjtzTgC6n5vtdA82TRwy4Oq7c3SrNgM/Xuh+gLPIgPioHMdM0okbaij9XfzBGWyUswNvllBgkpXnZzNOHdY4lqaDFFmQIg3r6y6LY4QqhZHdoVMEF8Ldw6SWh2TC2u8oCAF7ZAHcy/5fdmEM23svfYjg+3moVs1anH8OpCH8xditMPCYcq6zb06dpyJeRGe0EUBgz+nTW2nTY+8lzmVRxZzNV8cvaTkkellnSTvhCS1iFV3T5cG8IWFj1Ghfe1crHraA8rZPe9VxLmhZ907rkIcQkMF9mUXaETDIqQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5777.namprd12.prod.outlook.com (2603:10b6:208:390::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Mon, 27 Apr
 2026 11:52:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 11:52:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Mon, 27 Apr 2026 07:52:22 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5266C489-F03D-408D-8194-D7A427AEBB72@nvidia.com>
In-Reply-To: <4899bbfa-4d6e-41ff-9318-1872a6b91afa@kernel.org>
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
 <74D4C50B-CB20-45B3-8E7E-E9A499701F61@nvidia.com>
 <4899bbfa-4d6e-41ff-9318-1872a6b91afa@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0115.namprd07.prod.outlook.com
 (2603:10b6:5:330::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: d929f3d7-205d-4175-4c9c-08dea453735b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3OTdknLnqVL+Z2XaXJtzvRjcLkl+yEwwMkE35ZBMmQ8ZjQSWT6nFZ4i/ol30ZdIyLX5Fw/pAqaW6vin88HbaFZBvpjXH9zqk+M1vDZXTFHP2gv3fObhmMeC7qx9VHN/ckHdNPmYnVJ5bCqjJovcAbA7y43T+Nw8/4uz//txiC4YfIRCkNOJaDb0khchlg/u9KeHKfKnufH+KiX1Q2AB+6irG+ZL9jFua8d+LQR2lnrVHaZeWkBo1H2EL+6Hr9JcYn+zCbvO6LumaOEgE7m859xfdJcd8Y/fyu9U79Ri+E10raY7NLlMxF3J/Q2wAkqkw45iJcXDtNxuzBDGoG7/yh4uJALrnq7l6HY9MWxG6slnp+EmM4MsQ+fizcZaWlK705C1bOo8FyPtToORFwU2RKRgjlIsHv/Rcrfzh398PlD/XM4B0EsmrO7bpXKr01vevC1z1fyScezbF857F9Zs7fawXmiOIIghyKaNqqePRyKCqilve5p6cubwojFD3o0rTwht/Q78Syse2twh3M206qYDwfm+AakTfGAFBvvXI66KdCLkaEcdvtTBgNBkt+dmLV2DTwnh77WnQv4dKR7mPkxZapIfSuQHdrzla1Tw8cMWpC/nEbrldBv3z6mNToaz04O2rF6PoLu5jLcx6/gkJbWvc6+g09r0YjbgfGlvHAnUqtiswva1k0GzaUrIGaLIsMB8g8fNnH0P379f5swhVKxeOYomGFsjCB7RMBy8gE+E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IXb7N/zmF6NW0FHb2YytHaU9zVbiRlE+4rTiOAjMRRdDcFkG/PO84P4L6wzr?=
 =?us-ascii?Q?FPtKLRTROra6y4aRot3ZwFzQGVc1LZ8vqC+70cI5ZeQX69p48wkevxmuAURi?=
 =?us-ascii?Q?D9dcNs9vNUtrEwU2i4Xom6u0wWbPGdKByEwpcqdEH0ODqZ25KTEZfUdMZIMk?=
 =?us-ascii?Q?gkuUjkaKdJ+MuI8qd+yieQ318LuwhO0CgdJqAEtE9BfmaIRWZRY5r9t8ClIi?=
 =?us-ascii?Q?E6XgjTds3NRLRRO2TDLcjGaa1XZFzIGFPIDD6FarCsO1UHsabLutkvrz4eCh?=
 =?us-ascii?Q?0fGKpvsol/HRcdfQxpZCf/zRc2hkDLYDS7jj1PxhysECV7/4yGNmHB/GGrWD?=
 =?us-ascii?Q?i5CFUFDwanoQsQlTpxnlzrGVQQty8tR64BMYFMImvl/l83i2oSNfvwjH830t?=
 =?us-ascii?Q?MyOdtw1wSXR4+z6UoeIlXCEJX8CgcaAqRFlVDTHNf7i/F/e820N/pr36deJU?=
 =?us-ascii?Q?+aj7gvAvNqF4XRxX9/m/P0rBO/sU0QzCQdZ9NYhqeRAAygwZvg3iBSxZMY7v?=
 =?us-ascii?Q?5KYCPR619j5vyiYS7WuEkxog3i1vl3ZGbMtXSMBannR802xtGJ5XtQKw3bNY?=
 =?us-ascii?Q?rmFa1Y8VMMvLR7RqezzL1uiO6NqBk7SOKRCV4kqxkXBQyRcq2davKd/uaItG?=
 =?us-ascii?Q?txQN0FHx16CNagfLGLk1BcHXzqprbRDpFnt/D8uX2jsPt4evokTqqXyZUl5z?=
 =?us-ascii?Q?rS02wcK1a6wnMiCvwjlA5pCFnUhMmf/eIRlSSYyPKXBOt2ePq7lY4fr8yMT5?=
 =?us-ascii?Q?5Fr1BNsguKtaNhVtKPkj7X02QKoaY6oHIElpXA6dJIota7Dz/I5tn7yJfJxa?=
 =?us-ascii?Q?7xiosO6HWf2lrAQfdz/WSilYVUczt8Moo6BhHQ7teXmO42I1KobPZB+YcqNA?=
 =?us-ascii?Q?ZESHk4+VCFsh8zmAmEcT4PrppHgEuZaFId20Ro3nJ2kwZBgaQQectnrYsoT0?=
 =?us-ascii?Q?y4B4jVDox5f2V3a+zXeADNYMYqgnh+s3OWqlqsPbrpxhcQsvD/5r4APUpV0W?=
 =?us-ascii?Q?pxppshmMVE2gxTx5Z2Q5H5h1rfyBYTZKFna2EXW4WT7wdYh4VEicfInt6M+/?=
 =?us-ascii?Q?QRfWtzs0mFYai3sabR7bIObCXxrCqlgFdC1BIiSMStbrHo8tBNUX/Q6iYNIr?=
 =?us-ascii?Q?cii5Z7Sd+FGBkCKYH4WLDOia/pbsEhQaF8IqZnABaRTw9p4+3FeOCXwG3Cvj?=
 =?us-ascii?Q?yzS6m477dRU+me7WLFblH08GxnmplkhSpN9ruR3q1C3804Rda6teOsHsk5NE?=
 =?us-ascii?Q?7Au0h/HJvT2CioH3jrvbcJ3j3m6c9t8uWPQPw5KJOvdAPSUlMqfDM0G4raOI?=
 =?us-ascii?Q?SUxkFM1Uv4oTTfQGCA3n6Z85Rn31ffeh7Evw3LlUUrZlNC/HPWa8w4kkPPHY?=
 =?us-ascii?Q?dsyTGd3DUB/4NO46zsZtqS/J7DHFkOjOE4U6Fjai1+nqLv0baeOO0xd3JmuW?=
 =?us-ascii?Q?uWUrMjao8vlbk4OwicWs0xoGsUO2WRWWJqhzAfz7TjTQ2CbYkSYV/V8xf+gp?=
 =?us-ascii?Q?lFsRRiYG6Hu7UHsYC/HUKiwxdTaNHLsQ4aaZ/kHlVhDpn61xum8uocEnbXWZ?=
 =?us-ascii?Q?wULT0ac0iPBXVYmgMs00u4u9P6xPrQfsGFZbOy0pismh2ucNc1MQ/bHYqZtq?=
 =?us-ascii?Q?uq2QprLn452Ccz4zEcTRvI+V7vQbPBPtkhXuFia3zTqrTZgIohc56DPc7ZAA?=
 =?us-ascii?Q?7pfTNnNuqOS2GCzqXTiV1rHAADNsaw2jac5NU73IlEjzO0R6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d929f3d7-205d-4175-4c9c-08dea453735b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 11:52:25.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjPtNk953auzQ5fJUw3l7juMSWyGfCs6YCkGapCzZQyYlSQvavMrpQ2HihH+Vq0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5777
X-Stat-Signature: kbq39cd3dapy7tkaatjo8uabcessjtkm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9F7314000F
X-Rspam-User: 
X-HE-Tag: 1777290752-538977
X-HE-Meta: U2FsdGVkX19yWy1kfCDDC57n3PwOZbWkf8sBKVa7QsBlH+JSVT9TPzr3IzXk2EKBRgmyoNN7dXrBQwHaaM7+/Tfm2xS31t4M8XGAdaTOMQTz49uKJcpXndoGmWrTwupTALNtd5tUokPMfv4Hiz/AoqUNqT7qThcayv1YDW2FU32ajCdz0CmOm+15ItoYFHWC/SBWBDB+XynHxx28oagK3SV2jMkWyp+22l/+qUPtsSXXQZVvKphTczQLb+l7uvPzC9ViKrEFiwmBfN7T1s2ArdYrZwooYFc0k9VXqFIzf6rDR9GoHd9pGM+0EB7Af09HU22hQtQDYxRrIa8dzR3e3PLG1Xs99BX0t5+BXSJ9XAEzxF7iJMdG6yictkKtWIJbynPQSwfipf1lYx32Lq6GOTinW/VYQYciLALuOOCGdIWCv6XJFtHH1v55egaxVbcyEQ6yz/kn5tx3kfFzAi0MnF5nxooUFgxArt7/xYEAxqq203uKfcXjtTwIqdRi5JHeu3I+IeSURI5hiysw1kMSJLvSxpFqPso+UDFW96UG6vKbN2aqw14JM271y5Lc4dPwuVGMR5kyg8CNwj8d3co2Z3fJSrAp14WjjKsynHTpYZuE7kRIj3WYhBop8iKdEODi8Qq9sO1cigPNbLgrBx69Db2yrovdBOORamkwiyV7fViwrz78759JzHGWmNNX9qISDjpf9Dc+/OAxs3vMhD+ldNCOCypi6ycjvKnxgEHyFCln/1kReRzB/on1oBk3mLdDVBRgQ6luCa9rIVODZba4ah3AD7oeojsmzhOZN+XW/SohcxtIsXc7KKih0KIRufFykNY9kfcH+jTKwjVEFr0I6ttP/H83QnUKcFknefmEKoJ1O5wPTtSy7F0rm/bi4+RvmV9gZ7T3jVzlrY1zvoFtedvC9TeEk/t+Wkl9KRkHpAnPdTk/chPlUieHLKNx0aImZ5yDIQxpx+5uUY5TRuj
 SH6poNvH
 qziKV3EOqdXoJaVWa/CyIqREUbVm/OYsoh7N9NdnKSIvPCYP5HDCGX8FcGgGyWOQlSxeP/GTXLZO+vKvmsDkw+4TyPIj+Yam165HyhjofwkCjRRlZ7KNsLyO6SSSpcAJZDTU4P0C9TD4DwzhS6q2gPcdKXqh2rneX31PUCb1/D1lPzQKJ4v86t5lhy4xpiNIsMVq1YCOQ8yXbsGAfzliBit278PFQhfp5bGc52YFrR6BXuYpFKnTQGfeNZiQYZhP0gZmM2oued6q59VaFS82UCQ8Gn7ugYjfhuzNnvRZtULEEl4DEJ8n6oL0soUFQ2J11/YBHturEpd/DFYsoP2fpVxepOREUz1lIPOqexAfnOaz7eytPdHJTeGzAlXkRPp8XOF08kf3TIcJHJF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Apr 2026, at 4:06, David Hildenbrand (Arm) wrote:

> On 4/25/26 14:00, Zi Yan wrote:
>> On 17 Apr 2026, at 22:44, Zi Yan wrote:
>>
>>> Replace it with a check on the max folio order of the file's address space
>>> mapping, making sure PMD THP is supported. Also remove the read-only fd
>>> check, since collapse_file() now makes sure all to-be-collapsed folios are
>>> clean and the created PMD file THP can be handled by FSes properly.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/huge_memory.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..7e9cf8c0985f 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>  {
>>>  	struct inode *inode;
>>>
>>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>>> -		return false;
>>> -
>>>  	if (!vma->vm_file)
>>>  		return false;
>>>
>>> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>  	if (IS_ANON_FILE(inode))
>>>  		return false;
>>>
>>> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>
>> Hi Matthew, David, and Lorenzo,
>>
>> After some discussions on irc, I feel that we probably should not allow
>> read-write fd for PMD THP collapse at the moment. Combining with the
>> filemap_flush() under folio_dirty() check from collapse_file(), khugepaged
>> would become a kwritebackd that scans pagecache folios and writes them back.
>> If we limit it to read-only fds, at least khugepaged would only write
>> back once for the pagecache folios from these fds.
>
> Makes sense. The comment above the filemap_flush() is valuable :)
>
>>
>> I am planning to restore inode_is_open_for_write() check in the next version.
>> Let me know your thoughts.
>
> That would be better. Do we plan on handling races with concurrent writable-opening?
>

Probably not worth the effort, READ_ONLY_THP_FOR_FS does it using filemap_nr_thps()
and cost 8B in struct address_space. And read-only -> read->write race window might
not be that a big issue, since it does not cause repeatedly write back.

> Or could we simply gate the filemap_flush() by a inode_is_open_for_write(), to
> not have it turn into a kwritebackd()?

This is a great idea. With it, not dirty folios from read-write fds can be collapsed.
I will do it at the end.

Thanks.


--
Best Regards,
Yan, Zi


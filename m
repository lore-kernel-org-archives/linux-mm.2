Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB43FF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50106B0088; Sat, 25 Apr 2026 10:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01016B0092; Sat, 25 Apr 2026 10:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF356B0093; Sat, 25 Apr 2026 10:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC906B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:27:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A7341B7ABE
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:27:59 +0000 (UTC)
X-FDA: 84697307478.22.D215DF7
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 84E8840006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:27:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qsjbG5Id;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777127276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4I7G0gzy28M9M3RWZPsH3WpXWyhbhZOEoZSDRTISK7U=;
	b=515kzYGq6nrqvHG6OxoIwwFEqJ636oacVQatvSWSpRoeuMOrVKYePjm2Ga9b+jF160HFwl
	TW96Q8sdp8FvRpzPzXZECKUeUbMKkN92Qnt0M5NBIJoj8cqW3jETN+VfDoTI4Ul46hTm8k
	h39eRlT6jwwJGvMsohzbqbguRR/Xc1o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777127276; a=rsa-sha256;
	cv=pass;
	b=SlkPCHeRipZ4nuv1LO81xRWnt2shoVUAsDdZqSalb7xBkcTUqlUdAw31H/9E2GUEW8vEuu
	QgZQ7pygxY8qbQt5alEiUBV+HXXT/hJH/bHvd9nDeYovoTAWHVkgctDFgfJC7JnOSAwvOP
	9irt3WlFtvexs0lbwBTHTUg4qRHyBlQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qsjbG5Id;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cedXXabQ8QUaXDc6346OKrOUdb5IS2GVzDliOrowmk0HO2OTeQq2QcI8QIOJtpGcFlOcq+JHEte2zEqQ6ahuMvNWAH1YU2MLfOWpaNhHdBr/QXDe0hYCEzfB0bLbaaBoDxRE4qQHrdegyOd2drd38E0M3/pOLQM5gVLofryXeHV7sMUJBrWyI2sqv761YqYWKprh70psql5IgWAgOO3aL0rfUaRxpDkkIMqKJ2cK1eg1+KdDlG4E5WbQy4uyfr6TtaWKnCSsT46vkt5VHTFIIN4EaoLjzZrRfyXe0nICnb1sttksrUDzk/hAgktuxHHc9mbjd8mWZlLLilQoRRh2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I7G0gzy28M9M3RWZPsH3WpXWyhbhZOEoZSDRTISK7U=;
 b=OtONey0yQgp6t3YsNjjTAvBZsUqCLUEX+U7PVAXh+sxI99rrFfsMKjYm2na1NaeacvMTYyLtcbVoAiFNlM5StJoJzJw87F+eH6T93WLLXgzVp7ozThfZjAPrTP3nXFaZR/WdSIoTBvu1Xg8Jq93UhVbo+xzmrvYpffd225e6FuDAhTa66Uylzr+XOeHxpna1/h/cVmTsjWBE6qi7q0bgWAiD8pIpYhlR+GV+rDjU3tkG1jdnOcLaFySA3lDicutsu/tpFdv98RxupNwvHlMAnsrxdZ4IYmck2DEbn07xxzGd7N/gzgPN1d03wp+oaz/59kS1V8jNntj4lOaSVkUiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I7G0gzy28M9M3RWZPsH3WpXWyhbhZOEoZSDRTISK7U=;
 b=qsjbG5IdBN4s73CRrjIAluHnqkJLa2nwcCJN9HfEug9RPihIWN10qXyo5/WiH66BZSfx0beqvJYCCSu6qvIQPh1JRpsHlshMFlqVfKbeVTvRA2oHRpSpGpebYLd08WvHbrbGk2IxTdfuavNjJ55WgRKHWSXE9NzhjLxDy1ZN0o4UEbh4wUEJij6AeEwrSf+y6JZiNO1dn/xKWVwd/MlBpRUInKw7+QG8rBBLkc8oI9PcTunwt9Lb1MKiu0kzz115+52JdTVoCv6xpEDFrd0tEez+S1RJYG8bxmYu55Skqd30MhUsrUFqJ81yxMrHJu3LNtnsglBt2kjYWLBabO1eSg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Sat, 25 Apr
 2026 14:27:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:27:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Song Liu <songliubraving@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Sat, 25 Apr 2026 10:27:47 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DDB6CEDD-116D-48C1-B558-D64CA2F58F55@nvidia.com>
In-Reply-To: <20260424024915.28758-4-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-4-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a25e2da-e160-4689-463e-08dea2d6d472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bfzVzlEa4RbvTF2Bz1fUktR6oeE5IUKi/hDU/8K380w5dVQJ0c6yElwbg0CZMX5/e93lF46EyJGU3TQv4UwiAs5DQVAVxlg1y38RPzvGhd+OWt6xA84wB+LVbwVarZ+UVwRglk1eozTHVU1phDOHJGkB271QBadXLWx9RLpbabCvLbFsyaxITChxinyaB7ECEIKNtb7VzmjNdlsDByzVjkcnNHQsd4VSiIz0QuYjMGekDSV6c4K5dgYOaTEz1OsRMCEEKsz1QHn+TU3KuLZHanUrzXNkQks4w0x70yZ9Liu/15n8EKkzs4jnUF3HyjySq9NA6Too3J/47viGdEzV/xsehiRdnIP5mb61giqaPJcuFVeZRQiB3wUoJYyDSNE+/bEKNq3z6HhQdA3sIxkenIe8jzH3m1oAkBVtV+FuGXjlb9Jy0c9HLBTmC66TcUWyf2ADLaW1nKAE/es7tSTxZqPCl3VOFi/8169TUatjP/YgbU9W5Ua2n+GUObHIPoBD2s02d9/sMev+6TgjDvF5G1acUws6ywsWf06pW/myohBtDK4SgZ/iJWWOxxbnB10ynQRzNtlQkxP3j1PPU6aNSnCBB5BEMRPasQcrZeaNR06M2S/YqESA5aODIekhWd2HRwRzYgAA5IFUFi+Ixqd5Lr0oIHRpSnXespmhpCByhPKgF/yiCgmStSxGa09p/vqoMo2GSWiHrGKWIqP4tv9GHgi6L2d8avAVup9B1+4sJC4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTMAg4x494vRUiY+0+FGQqTby6tlM66Ytll6qX9q8cMejXqa1Y5uZM4q4Kcd?=
 =?us-ascii?Q?Ze3RB+x8xx95RvG9hhkq0+2A7wRqYzdn+fMl6g4UVe7SafBwH1Gs/HxajvXU?=
 =?us-ascii?Q?ClnzN4XbHPB/ftDsxqE7P9/8B6MQhDto/gZ/GSpxVTz4vyBARETpqMrJ/Xx8?=
 =?us-ascii?Q?JWsvlDwOwy27RQoKR2buOKIz/Oij2seY5cNn4kqKmLqQFJCVx1El4FMRVQB2?=
 =?us-ascii?Q?46BSQoRyyoLMp0IeXBz9WOrDeNf8IHLL7Ykbs5GS+oARWOqtSfvoNFIHtvtE?=
 =?us-ascii?Q?q6VsDWqB7+W5znj2F4OoTeUUiSPPqJcnfoGRsO98/rg1swQzeZNIHvUN23Z5?=
 =?us-ascii?Q?loop4TJRSmWT1V/F4hBcG2N5JqIfPgBV8iy5UKWI2jw0PzpTcChxdDjOrZ6u?=
 =?us-ascii?Q?PkSOtQ2cfzmaBxBs+fxzAMYjryGuhvQ/SjKa9VGDojPE4eNs4jZlGfR3l85H?=
 =?us-ascii?Q?qFxQA+3E+FyjPUmnhtBtK5I9NHFBmZ59rqjNwdBFUo/r0ccAsNZ2gjyAqq3s?=
 =?us-ascii?Q?KoyDX7Bh8BEm+HQo0jQ2nyef6WBqC18rdU/lSkVBFUQoZ27twkfTyos7LNhy?=
 =?us-ascii?Q?4pTLTuubBhwaPfnxUeWKpH/0yxbu8qou3MWTbJZJPb3bsuddjSrgxFvAE5xD?=
 =?us-ascii?Q?emg+LzFjYfjulXTgfBYFfz9ljXabWbhLUhpeAs+Gg+EQWxvzwGIce26JCr+Q?=
 =?us-ascii?Q?Uv723jEIbj1oepkxwmnQm/ZkktizsYen53Xqnm5HQ0P9jOqA1cT3PNOFOkm9?=
 =?us-ascii?Q?/3G8S3q8CtzDQ70bf+nb4TpezttWMaQ9XJFZ8MzQw0vu9SshZ8L2vEfSxiL+?=
 =?us-ascii?Q?dA3MQRZ4wvnpHat6fVKy8+Ds68I8wXUI/ke6hxiGwziUZ8Z6so3kQeLWfI95?=
 =?us-ascii?Q?lU5Dv1Hx+1xA+GLwFFglfv7hqEvqrgZxgZxPn+52+1LN5L+BBLqu5tqIhYUk?=
 =?us-ascii?Q?KywUNdwhoUe/aTO6pSCGV8jxSW660ndtFySYa9rlUVRfFE/PpWHklU9ji4EZ?=
 =?us-ascii?Q?j09Hbzbg1gj7Sodx+IaFR0uYndrpnvWWIHPeSykeMbGzm9hdC7dtGtYx9aC6?=
 =?us-ascii?Q?+3DgIxunZjAOuLtzYr0AHN12WyTHhSjsg+Du92i+L1LQfsC9eoT526+4uy8f?=
 =?us-ascii?Q?YJxHTpbn1V8Y4wBxvfQE8WRedSOeiXtDb9MUADmINWze6EHxRD7pwntDDZ8E?=
 =?us-ascii?Q?EyCxetlNB6nLU/nJHor40sniC97UmBnfXmfpxOjytJ6niperoxkvy0hJiMX6?=
 =?us-ascii?Q?e6Lc8INjOfn8/6RoJGbMkU7W6cHpA0v8ltXmTNVyeX67NSW7dS15aNQF7Uqt?=
 =?us-ascii?Q?0U4E/XQLfcrcxSAJCX50Qj9SOMALwzqpaQMxATn1ZfyAjvd4DAOood2+/7JJ?=
 =?us-ascii?Q?XJwy5ki/DOq6M5PIOX4C2dHZ0/b8hLuol1aUWXuRW6NlwYd3pdH+uh6JJhyj?=
 =?us-ascii?Q?7nLtzBRWYxQ6mHzY/CG9W+HOdAh7L29iRJqeaROFnBhWwMNLvZ2woPW0fnjP?=
 =?us-ascii?Q?7Vy4uutVGv4gjBOrJG5cIMwr986wthpHjpPpQUOt4RQ3L6/+V6IAWRSYRPwb?=
 =?us-ascii?Q?haNm/+d4M3G6sJzLBwgFyu9RSOq3XI653iDOBmUkTdBIIXjvYPbTWA/IXrg+?=
 =?us-ascii?Q?rnsWq1chDAHaYr0t5vFrLFzlQnGPc4ebi7nZiIQRxFFi9BasBqpKJ+MENQWX?=
 =?us-ascii?Q?jJPAPIZseHdaBEDB1w/xxG5V+Dj9fkWvW+YxNldt0r4ymikg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a25e2da-e160-4689-463e-08dea2d6d472
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:27:50.5048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gidVHB2pNo54iRLERZA+cdXGDs8E9Mj99bqrbrsyBca+reMHUZegluaPrNHDFmKi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Rspam-User: 
X-Rspamd-Queue-Id: 84E8840006
X-Rspamd-Server: rspam04
X-Stat-Signature: r87t8wm9sjhfufe5asb5r55fbbdbsjxz
X-HE-Tag: 1777127276-848740
X-HE-Meta: U2FsdGVkX1/g0sCAFspzzZDaxd0zvTYRrJwSV0SrQqEiwMpIrT9OF2RSGGFMm2POM3Opf07/28v/oO3BOs1qgcV2oasQl7bpm3ogFuO3OI2fc/EIXx0L5S1tGOavvbVNfG4+kLqCv5ePVBF/dkAJwj4DErIKw+dqaoixw14N6duqNFIwyMutCGjK6c49aeOk4FIMEtYuoCh8plz3ZY4peBYzEIg/Rn5qZAjAVXN4iRy95IP8mazCxBYHnD6BTO+RB+Kr+Z/Uid0XlmN1gAGuxYTt5yKEefVBxBgl4baF4slQThp0fZt65giWP92j9yGxbIVFZ9Em0TbtxE56ENPV6Hh0iu/Q/HYCkOR0AhjqyDPbpxZovzw15alUrcbwtxc6Nhcd8zDV9b/kEJrNQbYyZ6hEN1KigcqI0vA9Pj6PWFbk99lxpqG8v/p36M/4d/O4y4XxwUM1/l/l0RFlCOZTc/7u2FjR6ZMhpWkFA5i4mcRAT5bFbJ4F7JyYSFp6KiqAJHjl8sNiiRZt/c98I5naAottsOhPgUrfZOsQmfzT1UfTpQ+fnRiaLzLCTFG6Uyr7uta0evVSYjUy/cQr2hJss/AGluFg25WnPOf3vm1/8eqhs1Znpz6utcxKjG/lUfXgmgHPJHboansELqdsJvIr7AdtnyzxRCzzi5psSugsEhhtqA2Hg5i66pGoEnNfl08oD23oNvJ5/6O6whSew+T45U6W2wYEYKhtA43SQhooSQqvDYAmRZ9lv0Vx45RN9A2OkE8gOSfsc1c7Loo33IpzavKpw2RP9dRHCyfiCE6tLdAtRzq1UfRWUHwFOWFeOFhpyNmKlqYsYzhgoZ3NMBKNir+3mC4YevTR+zFq9iirD+qU7nQmJnJo3cHGIUeHvQFYbIoMCNyvT+6e2Sg4twMWmRO+himQRcXK/xH18AxzRJFZO5UbcsG2U4WZpTp2VlAqqCEmADmw343VLR21esN
 5/+PbOqt
 ZpV/L0eYLDGoWU4v6S/28dfcCFhyT7dgepvzbKkZb4Z46datPpnd+RJkI7bu3Libkx4Gqxhcugf2KEtWZbZAsnRNgwdo4LXxMmnej86fehhgFCOr17kyLB5a6Emvx1MOMXU163HR7G19kkFoTw5dDImbUNdf1heDwCgiS5D2ptnLiUGODWJvfT8EGFuhZZ83UGlWLVM/MyBXpSQu8TYT4M4vW9GuzODi6e6yS+bPlaKOXGJRAVg/f5ZVtd1QArntgnZZraTkKArIt6O1B5MKIzhS1VP8B98ccJ3CNrxEPDU9XW1fSIWsBsOI0woW+YHI968eZfSTCZQdcQ0OTK3YJe3SEbOcwU3n8AZpUND8dCn+UCDUDerc8lWRxEwCKRpoAuBLW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Apr 2026, at 22:49, Zi Yan wrote:

> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1f0d0b780943..f0db1390a18f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);

(resend to V4, since I accidentally replied to V3, sorry about that)

Hi Matthew, David, and Lorenzo,

After some discussions on irc, I feel that we probably should not allow
read-write fd for PMD THP collapse at the moment. Combining with the
filemap_flush() under folio_dirty() check from collapse_file(), khugepaged
would become a kwritebackd that scans pagecache folios and writes them back.
If we limit it to read-only fds, at least khugepaged would only write
back once for the pagecache folios from these fds.

I am planning to restore inode_is_open_for_write() check in the next version.
Let me know your thoughts.


> +	if (!mapping_pmd_thp_support(inode->i_mapping))
> +		return false;
> +
> +	return S_ISREG(inode->i_mode);
>  }
>
>  /* If returns true, we are unable to access the VMA's folios. */
> -- 
> 2.43.0


--
Best Regards,
Yan, Zi


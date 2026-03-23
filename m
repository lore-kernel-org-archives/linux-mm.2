Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D61F483E7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772906B0096; Mon, 23 Mar 2026 15:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722EC6B0098; Mon, 23 Mar 2026 15:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAB06B00A3; Mon, 23 Mar 2026 15:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48DFC6B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:10:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 109361E9F5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:10:08 +0000 (UTC)
X-FDA: 84578268096.30.A5EB2C8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011035.outbound.protection.outlook.com [52.101.62.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 079E84000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:10:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDfJLZio;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774293005; a=rsa-sha256;
	cv=pass;
	b=FnoH2M72WIVO/fWMR/QJQhToShpVYmdldMB1MU7AsMiewb1AwPxYY4I8XQrRG0JagWwoGF
	imEjqYWfldTR/Phh6kenN5OB+ExlSpHwJ6M+fLGyK3VqrDDva6N3bnSQszGnh8kwnmty85
	XEIkCDmuQGkRDYHy5Xq2TyBB+qJax1E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDfJLZio;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774293005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl6/tx73RisU+jkhIkU7m80Sk+PpsiZxq1enLBt171o=;
	b=pAJSEJZCGzuOkwArPNpRkAw8yUyPm7wXKcRaVhXs7mTbPOwHsFw1uPc1eHtSgh9o4YAN8G
	5DvfaFacAONfhshEtqbwch0XrM4kFMJzbWhgWAiCac4AUj0keKtsDhBcddhpxP4dyDIOph
	Lt0beD4CjuHRF7LQ0n+I8eZSuT5lxnc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lz1BrFdizfN3hGRqoDH2DH+TM5kLgwPtkAt4uOqtxL/QvFT+6FNw/n/Nqy8t5xLx0XdajrZOPKnsH3b2D9/XUfVVJFHMELeFlyVRuY50awUrQnUxnTOEhfxjQWgoZv4JOGf89R+/+EIdCcmZmGMG7mm97wKaZM9kdxyyOYqWTaOUGMTTdg6DeYj0Qg8pEqcdkr0EsGenMhSZGgZYmd6nAvlEzm5J7ciDJJ/1ye4n1FZDfNTbe2r6VBTtD42r2KzRb2d3SxZYkV6JplfH4eniEIvQljCbzTyHObeWCihfar/3wNZ1c4L3qT00osb1KWNc0mu9Bb3TCk39X+DJ5/nGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl6/tx73RisU+jkhIkU7m80Sk+PpsiZxq1enLBt171o=;
 b=ok2j1SwOV5j93LY5cVq6Tg1onDbXjaH9+QvtacIIFU2lYdeydNvf93SyU77G+JOU2I2uSMhfGjCiBArYljAFu5tz1O/t1avgUGSAkt0QFPYtvmELlDYGT0TTzrY0hWKcgwl3TouGXsSsy2MvJmB0dgBS/UCjZX/kqVS6T+snWydruyR1wz9zheQkkzB9ofKQJr1Dpk9U8d1mzZIUtTXUfNmZ8UMdlrEDdkzelj0mlBJgFdb/SONcRyNdQ2Bqwc7jhYzZwg/rljKx2tk2Q3uGE2j+sO0H4pmj8EALJEQBh5JklL2fRqy9KZICJFY8olA3/2L7ZGJiRDA7HoKPJQUTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl6/tx73RisU+jkhIkU7m80Sk+PpsiZxq1enLBt171o=;
 b=SDfJLZiojKAZGOFdh9SrVmyhH9Jx9OOIqwz6HK75CQVnNw/67IXOpg1G1MJ88zy85S5wWijJQwkSoTIlb/BUUJ30sHM3Va6eV06pHw8qsugQbV34bjclT6OUwG7vbkZFFhOyjRwY9JZsTW9/cC1ULuFR8KGXXL871pnf7vU68+GlNZlL3Qh/qRMkTcAEFIa3eLJkJsZ1xNeD1V8ITNrYRWBJjF3lnO8Lq1uUhMW144D4UtBaHK81+vH1RFhY2PMnuKAk/VjbjnrNpSzmIxxt+xDKaavKMAsXXxFBxdvlJ2RIZnn9luM8yrRoimUic5m+okHJZ2Sg/lqHwuTyD+bPXg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:07:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:07:02 +0000
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
Subject: [RFC PATCH 10/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test in khugepaged
Date: Mon, 23 Mar 2026 15:06:43 -0400
Message-ID: <20260323190644.1714379-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:208:d4::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 249dfc55-7fe6-44ad-56e9-08de890f5de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|20052099010|56012099003|18002099003|22082099003|17002099007;
X-Microsoft-Antispam-Message-Info:
	hh31xwDqQOIwjG6sEtvgOqWCwA/WBFQ5FJ3C/x7SrOOCqBvHMwpmDy12a3c8Q7+MVS7lGRbXcsAiZdZmC+0GN4LfW9CgXSuI1B5C3noSMQkWXSJxbcqC1y1OoHkZRu1A0Mm6hZibVUEDLtFdNLCF3DsQIRXaWxHaaq/3b8poWKlRxHk3URqDlzfFqJuWKnwU8h/JdQeqIvIGBIMgxVf4Me3N/8kVTMcp3QXBy6FaXfSjpdpoPZaRYbOS5KljTBxmxzP4Q9epS3gFGX6Q8gss+wjs/qc3sOL3XS8/VEcmMvrrP9ZjPEUMQzMdhVDWM/YBQysQNSXyJ2Lwsti+nhK/pxPwhgYQYw5HltSW4UX/Q6uaMgNb1NY9SegmuV8oeEix2TDCRxJm3VVe2DyZto4E/MQMgwAaO1bB6KHytj80wTzYpEjcuwhcir4rnsF2eH1g9A/h4P6oOfc/resZvM/8wAfxpfpB2aGcjNxN3QqsXpllsgqgnGBn8jla/KHpOkwF6EpCDoaMznMBAehXBdCIEIyYfB3MsuUtIP9kDgJ0N0+j/L6BnG7Kyo7R9rsXpHwf4pLr8PoyjNGNq8hpoGhxYRKLr97AplhK98onumIm77Kf4NLgSHN77PE0AWSWdabS9H7mYnZzuIXMxM8CTCbAjq3iUes0F4iffR+p4FGUmX0eEKw+ph5MdfkBaFqert1S5CnHqL0NGeJFepJ3XbF5gsbvOHIbNzG4KQKYKuAhilY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(20052099010)(56012099003)(18002099003)(22082099003)(17002099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HBNezNZrovWzcYIPLlZ6DUe8gKMSl379yoNeolk9YpCACJz9drbkAAJxEjnw?=
 =?us-ascii?Q?4k7iCmY5LORqgCJ+j7WEqBS9QFLa24/hSNroR5W1rpaHRN06TCBlz8J3OBrP?=
 =?us-ascii?Q?66l6O31ZN99/S7pITaMGx6bxVJnRoK8W+RKD9fO1v+HTBkz/tNndCdUsHY5d?=
 =?us-ascii?Q?mDL9WBk56PDP0ppo153/MP11hp9PsDRqUe6p2GYlC/3IKXsnrHrN21Bwj2iI?=
 =?us-ascii?Q?XewMpJCT4ZAJ3iB/M4K7m7buJUKZlqbEQQLY58FvcAx07XpvuJUY0RK9Tj/f?=
 =?us-ascii?Q?KOuVnIp4L+OOIQ5+M2NPGi1N/ynWzhtipfSIR8Ywc8Oo7nEBhcuURimATLIW?=
 =?us-ascii?Q?kXqWyH01uzxedNt18KRhUEPeoRyfmDAXBqk2OlHZJlAgRzjWXBby5XpNNaKi?=
 =?us-ascii?Q?ZByjMfG/8I83yujR8qQbo9qKGP9CpjVzg3luYxyP4jyisjGKbL6L3IZMs45L?=
 =?us-ascii?Q?Jh9T1iRDll1NACQWPgyAfSGwWJad7OP8GBRD0U1ZhMqybieegzufbyIcGCf5?=
 =?us-ascii?Q?2DUUV6yaXm6thi8xIbsdt2dVA3p+7XB8dYjZDDcJMXmSw5uPb/JUU/tjiIDN?=
 =?us-ascii?Q?nyDkNmFmw6lt1YY2ydYaA6r5bqSFrUfoECJJPF/aV3L2mWVmSUDlgAah9YHS?=
 =?us-ascii?Q?mccbV9Lz85+K+l0cwAL8fs5M8zoNbM/X3oRhd3OwtuuHXCtfsB249l1lhcco?=
 =?us-ascii?Q?BzmNZXA2h/FnaambOP2hFv655uwLm1O3PGFxY59w2pUWR1+E7tuv15hFKZde?=
 =?us-ascii?Q?f68ti2xavpdaEOomicJFlfRh0CrrozVlrhs5YWWeRMpQCoqkti44uSeFD1Pz?=
 =?us-ascii?Q?W/9V24dOey9rfFMeftzRiEvxSV0kd7C4/I+Z/HLih9yUKiK99zAHLHWc01Y2?=
 =?us-ascii?Q?H9tnGAkf2sQBjxFZePrgtFUmbc8sCBbQ4+hxSO+1tGGaYP90d8LUe94dPGVy?=
 =?us-ascii?Q?vC/3AQpm31YruLpFeNbDszbrPKVZnG9lrvQXn1YXAlF8NtDddOxhaTUk5EQx?=
 =?us-ascii?Q?IoBnLc1nyVWORgzTVxOwXyS6M1KMIGDC27uFXpL/n5vg/XIiEDpogV6fnKlo?=
 =?us-ascii?Q?2waI5SHanm4TLfzjwY2PWY3D/MG8AJ7V5D3j8Cqarpb3exLdjKkUaPcW8z6f?=
 =?us-ascii?Q?xHAI53rs9wI4hTZm3rniQ/DI+ak0ZJptSuXhwZ6bYhzoSSu2vT6IlN+SzUGN?=
 =?us-ascii?Q?ggkHPP+F0C0FEXyy65/G5/pUD8E+PddItdAIXYeZO/yLwvvWEVoDwRYIxwLk?=
 =?us-ascii?Q?Amrk4XV/FnZDwNzYyrKIIXdN+vKqdBHuiPIK8MgWPw7g5q4CGXVaUut7XkJl?=
 =?us-ascii?Q?0+H0hpZB+SqjETg6zpCUuN1f8NYyy1KOCbPXSaitk1H1Kq3Hjk7xlSsu7M4D?=
 =?us-ascii?Q?aaWPD51L4H+n7MH6eVRw8jB46zgIGD6fsW3FCuMa5ADNBTxWDRz8JUCd4uCF?=
 =?us-ascii?Q?9wP+/ijtyuVs7V/+MuFF+ArDK8g0ScLwsBMck+S3Kr/0kQTlFC3yA5gbyyks?=
 =?us-ascii?Q?MGqlPAa2IJJg+tknIcFFgGBOBet5f11qTASpohH3cQYjzSyfLbJN2xRJoSer?=
 =?us-ascii?Q?z5SGj1EnjG9iP2UIBebxWgYvgE31cMGHiJ1ZPtToxx2RpyNcp7ZfeelliVdJ?=
 =?us-ascii?Q?0jtOX95zwyfrVNUj8rl7tr3ehmh7fR6I7YtsLMDJWef59rYWgkhoAYj6L+Vv?=
 =?us-ascii?Q?W/sOmm/YfgECCUvRte+k8WWTdsQGUUS8R3cDGtF2LB5wttJ5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249dfc55-7fe6-44ad-56e9-08de890f5de4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:07:02.7903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86WIQ1nBA7YlUSh0RjqgcTcy++yerUUW2gpokJ6+I++Ngh0qKW6uoTEasyDkgHBb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Stat-Signature: 75ym5rcbbzcc3yuzwm8mqib9zawfp3qp
X-Rspamd-Queue-Id: 079E84000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774293004-989017
X-HE-Meta: U2FsdGVkX1+WRBw/U9DzyT2r4w0mhvbUyvVYIm39TD5kom00DG5LWMwvhEf12+vh81okG0CRGM4tq4InFXOTZimph6A7WAoTbvVvhYWXnV4j0LVCPP3rVikCIap2qJ5BKWa9IHe2/e4X2HW3c1Ljz0ztXfD/SHYTKwAqZ/gd+4DWLvup4ENkYsqodlnES997/jv/8xnol5LOIi0jTQSL9kFLqKtrt9HLPwODtkgy23WMViwvxwKOFaLQQgQhx93A1RwP0pGbigsCtQD1RFyNvF11XSNtY/AfBGDEGLNoas0alSDMY9xe0COonoQS6x5kr4PqAJ7+EOIf4bLgKS+ab7Eiozval2Y5V1FVWVV7i/+G5/Jb12wlrXuQ0GsAlUcwip4le4FByuJ4XPzILL4RU9gotNxrEXdVayvlS/Wxm4hbYpLNi9u75MyRMkf4cYAL4xRnocfpsyz6DavlRKtnHc0HhDzQ+3MC7VH2HgxKuHDomL1H0DLfpllzY/kqshUFT8mLsgN4jvh9aYN5lgih0bWfmW3i3NJbqu9Hn7/WWeY8+yi6jmMH3ffBOCxqDwDwIO89Zoqorzll8sPdlmtURLVYzwLzCfqIEAA5AZyFcOhDtb7o3j7FjfSz7BvS1jxJa9Jiquc3HW96dm/TOi9p+rvMAJTB9jTKK/HKU1Me0XXSgHmGuF6sGdZzC7bVv40gXhOknHd3rHjsFvHA2AU6i2Y63FcOE6410dOSafJ6r66g438obYIurx9/HnnByK5cJfJlPvrNWVrgW2FLRITE4T2wl6lVDYwkbK9Nv0gFUSNNMfZ62KGlNOlvXkzEnZThdgCnkThL+f7W83c1RVZ/rEkjZ4Aqlv+dMsKPATih1utQNcau9+wayMa/jvkv3jVJzCekgD1uFIY4DH+3bHgMpkAAwvi2I6za3nEARSeg2nYRDvlBQcV5/ICfIZUc5qqVmkZ235ClBggjo5GkL0Q
 U92kheGL
 IqUTHeerUqytoUTLTnFgp6QAPzUQfkqsdogGCoxkr0XWDV6a30f9IKoPVUy4Yi9dsiX8lRJx9HjcjYOAuJZV/JIhG95bmzKn8MS4sqMv5HWxt0jYyLlbswALd5Yw6j3fLpDDiZ11/kTdV/P7WDzGLBffiQRkoHxHg0myEoW0ru0WBp/k9X5zbcVxMFlUh3XujXJDKFldbDFtkewJ+eJtgJ4phBRzrY4ZuhGYTcQUHtTIK0khEFaOEU/PXfTa+RaHdgubvGJMvPzFaE86AoDa+kZZrlTxhIcq1YyP0J3rJVPOLm1f+t8a1r8tc/3aJXOVXHrOcQfF0J9vIuh+lugJ7eK67Zir1GniVabIHcM0Kvkvdv8GT5n2utMny8ilPs/npayKMAiwpQP6lKPAcvALKNePO4rmbmtwj7q59fx8KmTcCr+zh+G6z3bLppw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related test.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c | 197 +-----------------------
 1 file changed, 3 insertions(+), 194 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..842311682833 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -37,7 +37,6 @@ static int anon_order;
 
 enum vma_type {
 	VMA_ANON,
-	VMA_FILE,
 	VMA_SHMEM,
 };
 
@@ -49,7 +48,6 @@ struct mem_ops {
 	const char *name;
 };
 
-static struct mem_ops *file_ops;
 static struct mem_ops *anon_ops;
 static struct mem_ops *shmem_ops;
 
@@ -112,8 +110,6 @@ static void restore_settings(int sig)
 static void save_settings(void)
 {
 	printf("Save THP and khugepaged settings...");
-	if (file_ops && finfo.type == VMA_FILE)
-		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
 
 	success("OK");
@@ -125,89 +121,6 @@ static void save_settings(void)
 	signal(SIGQUIT, restore_settings);
 }
 
-static void get_finfo(const char *dir)
-{
-	struct stat path_stat;
-	struct statfs fs;
-	char buf[1 << 10];
-	char path[PATH_MAX];
-	char *str, *end;
-
-	finfo.dir = dir;
-	stat(finfo.dir, &path_stat);
-	if (!S_ISDIR(path_stat.st_mode)) {
-		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
-		exit(EXIT_FAILURE);
-	}
-	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-		     finfo.dir) >= sizeof(finfo.path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (statfs(finfo.dir, &fs)) {
-		perror("statfs()");
-		exit(EXIT_FAILURE);
-	}
-	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
-	if (finfo.type == VMA_SHMEM)
-		return;
-
-	/* Find owning device's queue/read_ahead_kb control */
-	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
-		     major(path_stat.st_dev), minor(path_stat.st_dev))
-	    >= sizeof(path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file(read_num)");
-		exit(EXIT_FAILURE);
-	}
-	if (strstr(buf, "DEVTYPE=disk")) {
-		/* Found it */
-		if (snprintf(finfo.dev_queue_read_ahead_path,
-			     sizeof(finfo.dev_queue_read_ahead_path),
-			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
-			     major(path_stat.st_dev), minor(path_stat.st_dev))
-		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
-		return;
-	}
-	if (!strstr(buf, "DEVTYPE=partition")) {
-		printf("%s: Unknown device type: %s\n", __func__, path);
-		exit(EXIT_FAILURE);
-	}
-	/*
-	 * Partition of block device - need to find actual device.
-	 * Using naming convention that devnameN is partition of
-	 * device devname.
-	 */
-	str = strstr(buf, "DEVNAME=");
-	if (!str) {
-		printf("%s: Could not read: %s", __func__, path);
-		exit(EXIT_FAILURE);
-	}
-	str += 8;
-	end = str;
-	while (*end) {
-		if (isdigit(*end)) {
-			*end = '\0';
-			if (snprintf(finfo.dev_queue_read_ahead_path,
-				     sizeof(finfo.dev_queue_read_ahead_path),
-				     "/sys/block/%s/queue/read_ahead_kb",
-				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
-				printf("%s: Pathname is too long\n", __func__);
-				exit(EXIT_FAILURE);
-			}
-			return;
-		}
-		++end;
-	}
-	printf("%s: Could not read: %s\n", __func__, path);
-	exit(EXIT_FAILURE);
-}
 
 static bool check_swap(void *addr, unsigned long size)
 {
@@ -364,77 +277,6 @@ static bool anon_check_huge(void *addr, int nr_hpages)
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area(int nr_hpages)
-{
-	int fd;
-	void *p;
-	unsigned long size;
-
-	unlink(finfo.path);  /* Cleanup from previous failed tests */
-	printf("Creating %s for collapse%s...", finfo.path,
-	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
-	fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
-		  777);
-	if (fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
-
-	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
-	fill_memory(p, 0, size);
-	write(fd, p, size);
-	close(fd);
-	munmap(p, size);
-	success("OK");
-
-	printf("Opening %s read only for collapse...", finfo.path);
-	finfo.fd = open(finfo.path, O_RDONLY, 777);
-	if (finfo.fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
-	p = mmap(BASE_ADDR, size, PROT_READ,
-		 MAP_PRIVATE, finfo.fd, 0);
-	if (p == MAP_FAILED || p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
-
-	/* Drop page cache */
-	write_file("/proc/sys/vm/drop_caches", "3", 2);
-	success("OK");
-	return p;
-}
-
-static void file_cleanup_area(void *p, unsigned long size)
-{
-	munmap(p, size);
-	close(finfo.fd);
-	unlink(finfo.path);
-}
-
-static void file_fault(void *p, unsigned long start, unsigned long end)
-{
-	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
-		perror("madvise(MADV_POPULATE_READ");
-		exit(EXIT_FAILURE);
-	}
-}
-
-static bool file_check_huge(void *addr, int nr_hpages)
-{
-	switch (finfo.type) {
-	case VMA_FILE:
-		return check_huge_file(addr, nr_hpages, hpage_pmd_size);
-	case VMA_SHMEM:
-		return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
-	default:
-		exit(EXIT_FAILURE);
-		return false;
-	}
-}
-
 static void *shmem_setup_area(int nr_hpages)
 {
 	void *p;
@@ -477,14 +319,6 @@ static struct mem_ops __anon_ops = {
 	.name = "anon",
 };
 
-static struct mem_ops __file_ops = {
-	.setup_area = &file_setup_area,
-	.cleanup_area = &file_cleanup_area,
-	.fault = &file_fault,
-	.check_huge = &file_check_huge,
-	.name = "file",
-};
-
 static struct mem_ops __shmem_ops = {
 	.setup_area = &shmem_setup_area,
 	.cleanup_area = &shmem_cleanup_area,
@@ -576,7 +410,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	}
 
 	/*
-	 * For file and shmem memory, khugepaged only retracts pte entries after
+	 * For shmem memory, khugepaged only retracts pte entries after
 	 * putting the new hugepage in the page cache. The hugepage must be
 	 * subsequently refaulted to install the pmd mapping for the mm.
 	 */
@@ -603,7 +437,7 @@ static struct collapse_context __madvise_context = {
 
 static bool is_tmpfs(struct mem_ops *ops)
 {
-	return ops == &__file_ops && finfo.type == VMA_SHMEM;
+	return finfo.type == VMA_SHMEM;
 }
 
 static bool is_anon(struct mem_ops *ops)
@@ -1084,10 +918,7 @@ static void usage(void)
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
-	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
-	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
-	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
-	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
+	fprintf(stderr, "\t<mem_type>\t: [all|anon|shmem]\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
@@ -1143,26 +974,16 @@ static void parse_test_type(int argc, char **argv)
 		usage();
 
 	if (!strcmp(buf, "all")) {
-		file_ops =  &__file_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
-	} else if (!strcmp(buf, "file")) {
-		file_ops =  &__file_ops;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
 
-	if (!file_ops)
-		return;
-
-	if (argc != 2)
-		usage();
-
-	get_finfo(argv[1]);
 }
 
 int main(int argc, char **argv)
@@ -1228,37 +1049,27 @@ int main(int argc, char **argv)
 	} while (0)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
-	TEST(collapse_full, khugepaged_context, file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
-	TEST(collapse_full, madvise_context, file_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
-	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
-	TEST(collapse_single_pte_entry, madvise_context, file_ops);
 	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
-	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
 	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
-	TEST(collapse_max_ptes_none, madvise_context, file_ops);
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
-	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
-	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
-	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
-	TEST(collapse_full_of_compound, madvise_context, file_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1280,10 +1091,8 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
-	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
-	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
-- 
2.43.0



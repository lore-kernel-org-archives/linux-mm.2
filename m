Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FE9CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724898E0016; Wed, 15 Oct 2025 09:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC068E0015; Wed, 15 Oct 2025 09:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C40E8E0016; Wed, 15 Oct 2025 09:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 493B18E0015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:35:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 040B8C013B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:35:13 +0000 (UTC)
X-FDA: 84000444948.15.AAEE109
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010017.outbound.protection.outlook.com [52.101.46.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id 659278001C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:35:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k0XJ+oA8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760535311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqVs5iozCBq9qP97ZTehYpJs4WpbW349BsqXn57tDNg=;
	b=5oRFLOBu4PYxw+IFTAxzf17RAvgQX4aNpxS9aFJhJTmEDIkX0SdfriPIYFomMeToW1xmcv
	xJIYaev3A9J3YkS0t8k4aLrt4ty6bEKYM8pA82dWwTiCkWs14VNg9fvBKwGWRqM5NGZmFk
	bsg60eZEWON+O5J7YdCW9sAWkdGnkoA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k0XJ+oA8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760535311; a=rsa-sha256;
	cv=pass;
	b=0VOS3n38x+6uBsGEva78QYxedo39zJSNtXUKfsNM4jT4VWid14qldwrw8W9ffgdXpVNQPm
	73Efmj08RYVRR288PsV64U4zxP1eB0MRqap0RUUUHvAAFXBDoKGr5HNsB5J1+NLTKXYAMh
	zO4ZEsQbvRTwHrSKpQcf1qmo+QjQ2iE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPsCgHKjojFQf5UwgZbCXG0yDU53WmP1PayFa7T1YH7NBiucboUgTkrhiDO+i8wvVz/1z/xxKFn2w7nuZOrMoJnnTmWBznSzOxibkqRagT261xhqXCPtVT6O65UoY7ZV8QjNpsKlK/jKnnh/FYFZp3BvPXnBT/Vx76yUXadqdyPJilTZ0zLUqfGKgiVm/ctQgxu588Ir7a/ZAuM5SHA5LoE1V+/O7SeiJdX+BHFVP3iCKoHR0Vqgtb53BWF1GjHX+H39QPEhXlMsEN1aTCB7Qb0AwW5sV2U8pHbni/0j4Fa7D4CRzOOSzffZPQ6nxhqZJfWbUHHdfW/+1oMChqkpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqVs5iozCBq9qP97ZTehYpJs4WpbW349BsqXn57tDNg=;
 b=I3nS6lJvUiM8TODPTgBgyYtuXOciXQMaPVRN92q1G+ih+F918oOB5wSOMjnUIqL81roPb0+r4+DJGZvCv5XGaePOA0Q9AibR36YuMFlBjBZ1vDHUoRU3aQQzzBK+QQUrlb3J7kMEPc/S7URG43vdXIzD9V4re2JlnKSOjGQNjadGUuc6VC7EOrMkLMq6+snyxZGfxsDv15Mtk9u/Dx0VezOCl11Sul7GEPdS0OXp2lDzKjKhrd57gKs6wTSioNbXQqMMrTMYOrkG8auLvdp3SiyFkaUql9zPbsUh9pTgHhhfm0onZyfFEJGXUg3q7coUp67RIkA9MeWywE+Ks5IUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqVs5iozCBq9qP97ZTehYpJs4WpbW349BsqXn57tDNg=;
 b=k0XJ+oA8TNfDg/a9RxX/+jVeaXibW4VKvd6YTmqUeTT+NAI4Vq0Rm5JzTmOuHcUHiUXrH05qJROxCI0sa0O0OaaZ2iEM08pDyWWTnP62YoWNREdLNh3GVdoRZ7hPoCNCoqia4mwn8WLRiVJNjvDzchUNWzi7D2EUfK9qrv4yQJ5FuGjJqpBjJeUS52C9gWom2MaWcWOeRAHqJK6l6xiEj60us2F928PblXp7C/2wx8jJurYUC6b4f2DMr+QCPUBxr9jVY4A1UjELPa7dY4XRyDZl5cGQevEu/XE9dkA8eRP/7jE2kHg9VshsR/NfBZ5TjEBSvnwz2XM+nqTX6XrJ3A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9809.namprd12.prod.outlook.com (2603:10b6:208:54f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 13:35:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Wed, 15 Oct 2025
 13:35:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/huge_memory: cleanup __split_unmapped_folio()
Date: Wed, 15 Oct 2025 09:34:39 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <DFC8430E-9225-47F8-A477-B032FD9E7959@nvidia.com>
In-Reply-To: <20251015081535.qesjcj2mhb7flq6f@master>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
 <B19F20C2-7B99-40AD-BC1F-944FF92ADECA@nvidia.com>
 <20251015081535.qesjcj2mhb7flq6f@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9809:EE_
X-MS-Office365-Filtering-Correlation-Id: c448be2e-2033-418f-0eed-08de0befa75d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z2LPewjo2bDZMtrXx03k5+nK/5u39J5VBj7AFsA9ZzcRq7zLlxqql+2bs8g9?=
 =?us-ascii?Q?UNH5TLd49EaBiic2nQUQVdUIheMtET6H5GzxX8dnVrUoftviW1EUG8oTemYj?=
 =?us-ascii?Q?yLPTP17AZZeEt2MSLCaxe4GAyDJSkJUDsm4U/blkgkNNQm3DHU2/r3OcFosQ?=
 =?us-ascii?Q?IcI5OULkTjFC4Ztkaoql/YbSiXU9RTqZcJb8TAjB92vF+W1NP5Q/j8mo3+52?=
 =?us-ascii?Q?WtupGtriCtP/T2csnJpzVdqwdGGqLO+0bg+mVOLE1SZFz0VzsLL4geJUyULA?=
 =?us-ascii?Q?wUUmIAafHw2EEzadOQiVgpLFzdjyn2azMzgM8xD0NQanRr2s8KdwRiatE9km?=
 =?us-ascii?Q?KKWvHWgUi5hLSwqmeDrYCBPP3nLtkOCDN5TQeWHej4ToM79BMk2IfI4D7t6M?=
 =?us-ascii?Q?KBzhs9OtpAiZRBIgygVd5IuTL8qK2q12lYr0b4s2G4RuFHRaaQMH2B8k2jwe?=
 =?us-ascii?Q?laIGngMOOvCC9e58PlXljL8DJK6LQl34uWHvtbWQ5WCU5wBLvXL0MepdGs+m?=
 =?us-ascii?Q?NqLVAVB9C55YIUZrMJQ3XNg4/qEHVJdTVro+L3zQKvBTdSIr+X9ImBAKPMzu?=
 =?us-ascii?Q?a9Y6zhPweQAGFaqkoTj59i3bLdLmbymW0XbxFujGsOffWcSY4jFmEZRyhZ4M?=
 =?us-ascii?Q?KR/ziB+o0Yct/rX0yjhAG5vOMqcr/DYuaVKC3xURQcFUlZ08VVgfFdx5RBYh?=
 =?us-ascii?Q?BjX5pyxUNF2TDPik7lIeLLq0dbEyr31bPHHN3niS0NibBqLP0I3YKD++gp8K?=
 =?us-ascii?Q?J097lY/d8INzxWUmV5OGivCyu+vL7NIg3vXIW/yRhwzBy5uPMT1e75m/7u+K?=
 =?us-ascii?Q?vyspNlKifv0wHUzUhs+92t+T38cb1tDoXIJni8aIppTaoweDyipFUmA3XWiL?=
 =?us-ascii?Q?A9qGWql0bkxGw6F8TJW2/Pydzfb85S6w6OWnA5507WPxDZicv3Tibxi8qVwj?=
 =?us-ascii?Q?F07+gcV37y0LDWYJf0XbMDn+GmDaaITNg/woy1VcNPWqGdm+76Sw3NaW2Qga?=
 =?us-ascii?Q?guK723ztA8PDFIyOaKSkOg6cbvoFMKG+yPfpgupc1nk7GiNPir3qUuJsT8kn?=
 =?us-ascii?Q?dLDbm4blgCm6pqPYxYxnIEXF+UXGrTr7tGKBNwGIYV7NYDxLKLfh3ZXrbtZH?=
 =?us-ascii?Q?Q0IYZNVCvprJ3gOOmu4vwYFoGnm6wf/z852ox5yQqNuJGNEmoYGQ21oFSOZ1?=
 =?us-ascii?Q?GOo4/vxa0HK/0ErCN1npbmqPtkCygGwE/27zue0KKy+P97D4f9OrzcaffSvU?=
 =?us-ascii?Q?BKfiD4JgMFNnUSfNUbjvT5fGetIkMwrw/tx/UqD/nRFANW4602SvFI37j/8R?=
 =?us-ascii?Q?aKGnMC4PUUjZ4UPvJe2uzBW815g2w7evYsrOR7RaihaFoMAtL7eSNz33PMvl?=
 =?us-ascii?Q?TF9SQSh77yonY7crkLfTScTgTbu4CsADVGK8kBpRNcP1bpip08TKlEaekwTz?=
 =?us-ascii?Q?QBR4X2vAovvJQkuFO7zxVV5zuOjkXA3e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zZGrszbDm0Xa+9nvMbefgT7qPBKl13AQ7jiEGbUcT9/KES01cwITVIh32K3h?=
 =?us-ascii?Q?c7REkYjX1O80/qcAs/XGMK3ucdWZEpUzpCC5hfR5lVAgw9Vn7eLSrY5ao92H?=
 =?us-ascii?Q?laX2slFBC5uxgcGjY6rTV7XuyCul8oqGfbA4Gz6tGOKcUTTMw6IDhFvkVu4K?=
 =?us-ascii?Q?ZhlUcFmFlJ+n32VjGozssY7IcphMjhK09jYQu6sH4CrWhL4N9yagGe+PwPub?=
 =?us-ascii?Q?8wVR4IdmqCXyC60OiS7LhzOcxWdTSTknw1dCkjuaGaDU0enyN2W9eMMjvByt?=
 =?us-ascii?Q?dtd31xMtjsBy0Y/eT/AfapCcVJsI0i1a6PFj4fCnxYtMrE2J3M+xwHETT1Mk?=
 =?us-ascii?Q?a4JJFHMv6IHq0ZZfrOew+3L3i/Au70YrTES7d75U+NXiHJ2uRevPjWd3P/2k?=
 =?us-ascii?Q?mVWyfA4d/DhpZjmwfeop+0Xc0IzAO7FtUS4IFOKJzzvMeNQ2SoUAsr+2KuME?=
 =?us-ascii?Q?BkXgKpM/N/R4qIxNaoKf9UOZldSEvyo2OrTrvWukBsUCnvhCahnLMoVxFOhk?=
 =?us-ascii?Q?p1SAGut2ou2/UUoNxnHc8gtMisozlunODDMoFz2QRHKuY9N10pmqhG3lXEwS?=
 =?us-ascii?Q?Du1dfabi+UYuse4z3nufRvrwLR0akvGtefNeASMz+sdlMjM7vyXUnJrwxeLK?=
 =?us-ascii?Q?skS7m9YP9HnIpdiuOvf8zkspl1FjGYgMgIotZAne9gYZYcLQ02iKyPDqEmd6?=
 =?us-ascii?Q?8ijdJNOOmCBiMYInmiSSDoWL4tLP4/5u8tEDJ9fgUtKK05+IMVCeG2nQ7zO3?=
 =?us-ascii?Q?+Nrs4sYSU8nJ2NTsgm1RP9xdvs4J7R5XR4DRVb2vl2RL6SkW+pb9DfAe5dDc?=
 =?us-ascii?Q?eLfK+h8Smy2T0LNj7iFvYEFQJuT+YKKQMK+W4wco6N2UjdgeICJOdGyL1E+y?=
 =?us-ascii?Q?Z8jt/X3BNishGb2veLeDihwwbp5gicR7B2Af7N0CFkPWoNqOe4KVDJbBytok?=
 =?us-ascii?Q?tcCAkRMwzrRUSdVREM4mpCR9tJDl3ykJz5rzfS9hyXEcFXwKz1UOACEDwCmc?=
 =?us-ascii?Q?4MZ35waqw9pCUsBYkNemAQPZ2BvZlh5/r+PE7uaX76T40ixIpvF23QeLYEto?=
 =?us-ascii?Q?5Zn5n3jU5kQuIbZqKQTtKBuaSK+idloKLgK7yTXyc2dOIUqsIrNolgsX/MeZ?=
 =?us-ascii?Q?U6+qxkEtamuiCitRXVfubPe0JsdHjggGcosawRIloqzD8Dk8fEXs8OUR82ri?=
 =?us-ascii?Q?+T+N+a3ulc65HHwdf0mMqAkF7ZfeQgfeb65g4OIW0Q69UG7vA0eLoXhHEcJ8?=
 =?us-ascii?Q?Qb1CTASMx5+gktNeoMO0mYYHb7trm9OIZ07QwRFtZ63h4/rDBQasi0BVuTPf?=
 =?us-ascii?Q?QaA6+ydKyDnrLzzSlIfjDYOirLcm+yT0qoL3Bxqs3IEln9BlE2OnkA4kpC9w?=
 =?us-ascii?Q?qN8nl3Qnhbg4rc3wmEgSTDuQeNiNNBFhsJN3/+wY1GCACGs9hBf3tjY6K1LV?=
 =?us-ascii?Q?TJ685MnbYcfKrqJO9FFwrOeENQ0eXjm5FStPXE2xnhX9JHCmecQA5/yaCoGC?=
 =?us-ascii?Q?5jTdF6sYEbC2WdPg7WzbKfqmIuzpnh84NClQy7tWgbgaiaSBtLFiu+voIdB0?=
 =?us-ascii?Q?QHtwq2R9SYUBmt35F1nqySE2oiYIzWaprQKzO9vr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c448be2e-2033-418f-0eed-08de0befa75d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 13:35:06.7639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kED9SumjwditFytdXHt/y5tYpq7BaemxIQ+qb4pVM9K+bLbgdWH1HQy9C9zKBR+7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9809
X-Rspam-User: 
X-Rspamd-Queue-Id: 659278001C
X-Rspamd-Server: rspam03
X-Stat-Signature: 9snwiedj3mnym9ms6ot5rm3zwof1p9cq
X-HE-Tag: 1760535310-280997
X-HE-Meta: U2FsdGVkX19sVMn1zyaw85JPNy/LQR1CbocQOxk6qeIYJ5M8VgbyCOmZgEXOWKYLezEGL6+htluQVw6lZ0JhKfe0iFPrrNV2xCi7Jdkl4MvjxUzUKQK3zQeoq12TRgiqPAsOxgbSHBkTrhswEC4W8ZD0eUn13LD36jAfNtEXit8BtxkjuWOIXUS4WegAXkocYOws7M5LH1RhdnZ6/7GkjJtjuREz3w3gswsgrJfXzrYSDBQxv5vOCxo505QFUi+ZCTEin9m2S29DMoYX5zWH1VsOIt0LqrizRaAjpFBa2RMzdxVkHLLbJyhH52ZMqR7E1Y4V0ghRHrI+MYN4CfUOn+H5QMZHPwBV638MJJEu68jwTOPNTdQ4tWXtgw+QuKQiOMdNMNEM82poiN89bi9TEu1SfXKAHwg8c3mxLvb7aiqyVTgoMHVS3BV38Quobz9ijYnvl1WD9FrdbQ2Bpgcyqw2JjMK5jtXBlLsciqmDOC8ECMeTdFm3y6tyJHKZZJfOg6LfJT4c/XNSQEXCOT8nnfIvNpKGikZqgIip0sIqVxle13Uu9Eqr1RGwBkmHjBldKXSId4RdA/8ZYGWEUWVVPsQuwhVAOz6LO1V3hE0+r3k1A8OXrP5BKKpjyYKb3xYrAuhKbZlNfMK+myvTEMw/8nTuzOh493DLJYmeblDxLhCyvMiP2ZtwysqypTvHPkcvOv4J9mpozqUBEWDwGsrymgGY5GfwRQzFtRU99o9XoppUZhAnXXrS1OmNtoXWshFsydMLrLyzAg120v26lnXp9X+T0qV6m5CQFB1mP+qawvzsePhxRnDFGba1WTH/xt5A8xCdAJr/WU/62d01V3gK4i/S68SX6WqnuCNd4obKoI5/yj76EYlZjBKmYLp1OmSMCTNrjGnOHjZbsUZzV5iInQaYluIRcnlZsuOZEbkg0b1ba2MNDDPke5LlIPPYd747ulZaYaBTfuWwmPKuAFw
 PF/DdvaD
 OovJmUyWqOl4iyp7+vLaBewO7HUYPqA2OLM99x4SmyLgJhgMpUxQodXs9QJ7FgRzcggOjlj8wkMSUBXBLZ9dxE14aoCNCVSZp9roy66KsMsM3JuMDqKt/czZiYMh7sXi8ET+49ozKvxHlo6y6VRqDaPHOrWuwdkdZEHyXfCeH60QOHrdFlaA+7vINQT5XSsFYfC550kgZCyxICTW+9WyafpOhDEfwaGKvNLYAXXHt3+OMhmnBg3ku12YqOBt1rhgo2AsGRw2sO1AqiwtpI8OFkeqeAH0FYUcpFIqmpL+WdA3MUz8s0kYS5yFKZEcJvpSs/jQSRUqR1N+M6fDID1K4bZjMBfA8L8/9sxVFIe9NGP/HoUGtmoRk4viFOIMcm2msBifVXnz/Djp6MW/5J5OyEJ6OiE1hAmTweAozDfVmMmSeTm/57MlH6njJRkyoWzAr0xEUa3XF8albIBjbaFRO0uzraYNuGBb6SYxJGatYIQdEz9gYV1figi7EZ+OKQr29NQLj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Oct 2025, at 4:15, Wei Yang wrote:

> On Tue, Oct 14, 2025 at 08:45:43PM -0400, Zi Yan wrote:
>> On 14 Oct 2025, at 9:46, Wei Yang wrote:
>>
>>> This short patch series cleans up and optimizes the internal logic of=
 folio
>>> splitting, particularly focusing on the __split_unmapped_folio() func=
tion.
>>>
>>> The goal is to improve clarity and efficiency by eliminating redundan=
t
>>> checks, caching stable attribute values, and simplifying the iteratio=
n
>>> logic used for updating folio statistics.
>>>
>>> These changes make the code easier to follow and maintain.
>>>
>>> Wei Yang (5):
>>>   mm/huge_memory: cache folio attribute in __split_unmapped_folio()
>>>   mm/huge_memory: update folio stat after successful split
>>>   mm/huge_memory: Optimize and simplify folio stat update after split=

>>>   mm/huge_memory: Optimize old_order derivation during folio splittin=
g
>>>   mm/huge_memory: Remove redundant split_order !=3D new_order check i=
n
>>>     uniform_split
>>>
>>>  mm/huge_memory.c | 70 +++++++++++++---------------------------------=
--
>>>  1 file changed, 18 insertions(+), 52 deletions(-)
>>>
>> The final code looks good to me, but patch 2-5 could be merged into on=
e.
>> The diff below is the patch 2-5 and is not that big. My comments are
>> added below inline:
>>
>
> Sure, let me try to merge them. The challenge for me is how to merge th=
e
> change log :-(

I do not think you need to explain how complicated the code looks like no=
w.
You can focus on how your __split_unmapped_folio() works.

>
> Below commit log looks good to you?
>
>
>     mm/huge_memory: Optimize and simplify __split_unmapped_folio() logi=
c

Existing __split_unmapped_folio() code splits the given folio and update =
stats,
but it is complicated to understand.

After simplification, __split_unmapped_folio() directly calculate and upd=
ate
the folio statistics upon a successful split:

* All resulting folios are @split_order.

* The number of new folios are calculated directly from @old_order
  and @split_order.

* The folio for the next split is identified as the one containing @split=
_at.

* An xas_try_split() error is returned directly without worrying about st=
ats updates.

The above commit log would be sufficient. Your code is quite easy to unde=
rstand.

<snip>

>>
>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index b2a48e8e4e08..46ed647f85c1 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3528,9 +3528,7 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>>>  		struct address_space *mapping, bool uniform_split)
>>>  {
>>>  	bool is_anon =3D folio_test_anon(folio);
>>> -	int order =3D folio_order(folio);
>>> -	int start_order =3D uniform_split ? new_order : order - 1;
>>
>> I would like to retain this, no need to inflate the initialization par=
t
>> of for loop.
>
> Sure
>
>>
>>> -	struct folio *next;
>>> +	int old_order =3D folio_order(folio);
>>>  	int split_order;
>>>  	folio_clear_has_hwpoisoned(folio);
>>> @@ -3539,18 +3537,14 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  	 * split to new_order one order at a time. For uniform split,
>>>  	 * folio is split to new_order directly.
>>>  	 */
>>> -	for (split_order =3D start_order;
>>> +	for (split_order =3D uniform_split ? new_order : old_order - 1;
>>>  	     split_order >=3D new_order;
>>>  	     split_order--) {
>>> -		struct folio *end_folio =3D folio_next(folio);
>>> -		int old_order =3D folio_order(folio);
>>> -		struct folio *new_folio;
>>> +		int new_folios =3D 1UL << (old_order - split_order);
>>
>> nr_new_folios is better.
>>
>
> Sounds good.
>
>>>  		/* order-1 anonymous folio is not supported */
>>>  		if (is_anon && split_order =3D=3D 1)
>>>  			continue;
>>> -		if (uniform_split && split_order !=3D new_order)
>>> -			continue;
>>
>> This is probably dead code in my initial implementation.
>>>  		if (mapping) {
>>>  			/*
>>> @@ -3573,19 +3567,12 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  		pgalloc_tag_split(folio, old_order, split_order);
>>>  		__split_folio_to_order(folio, old_order, split_order);
>>> -		if (is_anon)
>>> +		if (is_anon) {
>>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>> -		/*
>>> -		 * Iterate through after-split folios and update folio stats.
>>> -		 */
>>> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D =
next) {
>>> -			next =3D folio_next(new_folio);
>>> -			if (new_folio =3D=3D page_folio(split_at))
>>> -				folio =3D new_folio;
>>> -			if (is_anon)
>>> -				mod_mthp_stat(folio_order(new_folio),
>>> -					      MTHP_STAT_NR_ANON, 1);
>>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
>>>  		}
>>> +		folio =3D page_folio(split_at);
>>
>> This is where non-uniform split moves to next to-be-split folio.
>> For uniform split, the for loop only iterates once, so this one
>> and the one below do not affect anything.
>>
>> A comment above this assignment would help reader understand the diffe=
rence
>> between uniform split and non-uniform split.
>>
>
> How about this?
>
> 		/*
> 		 * For uniform split, we have finished the job.
> 		 * For non-uniform split, we assign folio to the one the one
> 		 * containing @split_at and assign @old_order to @split_order.
> 		 */

Looks good to me.
>
>>> +		old_order =3D split_order;
>>>  	}
>>>  	return 0;
>>>
>>
>> Otherwise, looks good to me. Thanks for the cleanup.
>>

BTW, does split_huge_page selftest pass? If so, please write it on the co=
ver letter.

With all these, feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.

--
Best Regards,
Yan, Zi


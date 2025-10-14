Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768C1CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9695E8E00E1; Tue, 14 Oct 2025 17:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919D58E0090; Tue, 14 Oct 2025 17:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2188E00E1; Tue, 14 Oct 2025 17:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6655C8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:37:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEBB0C0AC6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:37:45 +0000 (UTC)
X-FDA: 83998032090.20.CE67973
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	by imf14.hostedemail.com (Postfix) with ESMTP id F406E10000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:37:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="U9c/2F+0";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760477863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBZVeZG4nwKLsLyaDhID+WJPXxtwmVTAg2grHyRmWlg=;
	b=HnecIDEYoxjcYVpmQqzcd8Td7vUOeS47dMNEqCQTYXzNxSsG15cJejwotDG7VJadfcOTiv
	aDOc/C1s7DW5ITRZN0CIyItClC7Mxzv/a0QL/znYNmJe1jnIByCR3YM/JTCLj/+nosmuFT
	E24ZFCluYwi2OmQO1ipBDuAYMbUSl+o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760477863; a=rsa-sha256;
	cv=pass;
	b=Oa0d6ol+ym7vNGaOmH8+th35Owgejul2r8pcJs5PYOxrMMcaM7AHpRJ4an1NJM630IJg0A
	0OjGxe8n1APQSCE9D6K5aDDBkBrZvsyeMthvzgP1mXu9yb2+rM6Lq8JfApv8yprnasHMVd
	imatVQrmzyl/VPqWHc5ixnWdAtpJL80=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="U9c/2F+0";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YpCMfePtPaH1Pz+Q7HYQdlInYYRVJqsNkmx5l/G675X0AeEp++AxHYDMXy9iR+a1KEf6KoJHoIk51ZsKovxiBbm2reqO8nJGNQbJEHdQTzwyAYS8xXQzOYQes9sfVSNxRNeexMpRlqT4jQXj//GLjxnaK2bXOPK4mZ2VEVv91QwbFzotV8G3raRpY8Vz/jBBT9KGbVH8KGfmlo64Nsy0TTz668QpgdPdT3H3aKHchh/wDt3fG5WfwkzEeneMUQIot1YZlBzgQgYjoxSm09rzSPPfytNLoFXwsmxPoRVCzyxH1u9Z7YkPQ0Gr+gqaki42q0fr1Bse90rXGB5amf1vog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBZVeZG4nwKLsLyaDhID+WJPXxtwmVTAg2grHyRmWlg=;
 b=Rrfn6/XYIJI6y4Y9W2fr3OPjAgTLlzmfGX5Q1QkhrkstCO6pIUWCXcCj5FmfA2kY8vGaZz6z1IFk0Crxq3c9Co3d0ryFC/wxHI0M0ucAvbnJULWlWtgrGQiNJ3kQVZAoVIBtl48gNdpiDNuE6QJnYvjSbnWf5aMny9FuR/YHWxARyPY5Y01GrzzDtOOhpeyEoTsApZDnGh3dUw2OY1BOtwf/BzjAPUYs3XskEMRWRCpOd2JQrQRb+pZN9GjDdRDWZLf33EJKwUMA8Nb4fd7x4zF6c2idLPgPULfSov121geyA2pIX1Nr4S2mop6KzSGpFctTd0VEhLdGep5kws583w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBZVeZG4nwKLsLyaDhID+WJPXxtwmVTAg2grHyRmWlg=;
 b=U9c/2F+0QuJ3wGib+JfXFGc3VNHpy/lj4LmA0o/Q+MIj7Xwpyn3GgacNU3ejcjVKoLKm9xszmBYci/8ylzMFUApGx75Xku0yZ+Mz9CoZs68QBdNi0eSX5ePrHWoQUL/jVJV69266eman+/qJro52uAEN1GzvcoKrnmXif7mIVVg7kCdBQGJTp0HBPwAjxtn8xEMxC2Ze7fs7dZ3opdIafU8YLGX+5/kpVQGxJVxlo+Uhp2dkolgn05K5K9SBLpepv3JlzAh+WENET+nroS8RpWBuViRpyfh7YYcGtvQHZ3d7Rz7Hztz/PyIVpGCn/bGDoaUGCdEYiVYeaj6vIymIVw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN5PR12MB9538.namprd12.prod.outlook.com (2603:10b6:408:2ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 21:37:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 21:37:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] mm/huge_memory: cache folio attribute in
 __split_unmapped_folio()
Date: Tue, 14 Oct 2025 17:37:34 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D8AEE2D1-F403-43DE-95BE-310626CAFDEC@nvidia.com>
In-Reply-To: <20251014134606.22543-2-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
 <20251014134606.22543-2-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:207:3d::46) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN5PR12MB9538:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bdd50c5-7f8d-4a2b-496a-08de0b69e403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+cDSwd0aHudfk9Ef3irZb2V0LejAp8sX8J3EMru6uQuJceZME4EIuMHmUAuv?=
 =?us-ascii?Q?I+qEkTTkKsmSkMZ5iqcR4inZPuWobbkChbFEigjW7aRXHI/diDUMa7Jnd+c0?=
 =?us-ascii?Q?m0sgQYYXdLlBKLOvVJhXmDHHqTTx6iHvBrb/D2RhuKuZbajSZpgE7/1ojSs7?=
 =?us-ascii?Q?/Fs4qq7zpp+OTMiPvnvWvs0E9AycraF3mqL2Z2Jw3qne+49p/u5QHZ0GIzk/?=
 =?us-ascii?Q?2pnkk50N/FOA/X3/EUsQcaduug7mKcNJbGd7pmF9wQ5OVkXp9XuVeGwoIyXN?=
 =?us-ascii?Q?wh/TwF7YcOFX35xftojfp8yW2FhicwZ4dQS6uR0D2cJWB31KDBjFQgnIa2vm?=
 =?us-ascii?Q?VfgUws3bti9BDkc6U5CyRQB6LOnRQFGVBrH465kMVTQMDksBUIIk8d5sqnkM?=
 =?us-ascii?Q?Rfb5K/0yFl6QLuYJG+nGJoHlTs1suBRao2uCYAISiMyJH4O1+kbkav5TKlkj?=
 =?us-ascii?Q?MQ+uvdgVC15GVpxJjCUcJLKSUdQ/0PJV4uGneblfswFM5mFMwrxFo8vhOkkq?=
 =?us-ascii?Q?tgE+CykbSkHo3tpyN2v2PJ5at9dbXp/74B9PQ9t4OYwtaLyAbOL4CUnG96yZ?=
 =?us-ascii?Q?L0lXAOrqctdFztfgrCXpn7jY6vYiDDPemgdTSz0NTgoRzFQDnB4c5hGeq4DF?=
 =?us-ascii?Q?2hW9F/j2j5ktRNuTZ/ZQnl0X2ZXbeML8uJzg8WQgXYWuKBDYUlzkNM3acfu+?=
 =?us-ascii?Q?sH/2q87SKzc0iPNYUAOMM+Y//kVYv5sb0bAsctqxu8XOWr3e7HHrmy2n/zLN?=
 =?us-ascii?Q?dOmhVUI6j3k1xdvcF7Ka7EzBnxQetuI2VdTBaO6SK57oryxkYEQGzw38MjUF?=
 =?us-ascii?Q?4TI2Ldk2Vw+pAp9vtQzQKrMbs6ZJ5tFK7mdS4+em0KqjzLI1q6cyZ4xpzuX6?=
 =?us-ascii?Q?OG4FxCJuH/W2zdwaeICpIBJVeWIPXbdwkkyIir48lvDLHqoRVzZFEEERrPvw?=
 =?us-ascii?Q?gu4NbRCPbc6ZJx0EzVL2kVf/KWkRXYyOyx0Ti1Iv2nYxuj3ElWsH10mgfv+V?=
 =?us-ascii?Q?cMx85rfEz5E1ZCKARhvNt0PJk61OzePNNNkmjuYP9oPxIich0akKBfcs1BDk?=
 =?us-ascii?Q?N/8ITgulXYLzvcXL5OfzX6FOr87S0YgEd/cn6n0FxD/MJftL0rg5Gi+sHZLJ?=
 =?us-ascii?Q?Tx/sAaKAoJ0eLTh1KD2ueub1aCQPZF53SZdiyDMpFjT61Ye0lTzc0BsDlCa2?=
 =?us-ascii?Q?8p7rO6N+7vGUgsY0U3peP4hbMcsBTMfUHc/0URUVcPY9EarSeRfAC77lQtyB?=
 =?us-ascii?Q?7bGaPnXOwr/sFNocmXj5pueX4TRInjm0LUiJAYgtJYQ/KqxBQsVXuc1AvYH8?=
 =?us-ascii?Q?WDhlJAmbj8Kw+PkQxLIBwyArwo9elRSpgfe5jAlG72osx2HxkYLXWGyAt38M?=
 =?us-ascii?Q?KNlMdr67fCTw+s+z3KV5B+pju43l0BwjDl/3ByM3UmiYudP4cn5MgxRQMIUr?=
 =?us-ascii?Q?tgNnJ2jO1Ixz/n2KZjaka02V/BHNAiV8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0w69k37x8ofnFZN6FIDaj17ZUuks3GFNMY8dA+9OeaLL2FkyIHiQG1cjnhqI?=
 =?us-ascii?Q?9CFUEF3NqAXZ8WPFLqgYYunscY/pvVkEyvVg6oi9/9n2meZflEqtx7PIFqGj?=
 =?us-ascii?Q?OnMBgdMmjf9j8RNA/t48kndjlKtsvkUOhiGkqytjTB2cMu+7zpEKS4sVoAfe?=
 =?us-ascii?Q?OftsPs8TG9dkvmNKMuRxVY9MxlGnGWSlY7oWTk20pSODiEBkv85x7pkm9Ylz?=
 =?us-ascii?Q?9jqe/dtatqnkLzweF9wGqrEkpa3KLtHqXqEix0S3rCAWgmD+Ol4X3N7o/6Yc?=
 =?us-ascii?Q?+H6hI90bAiFqeiVN7k6zhVrGu5coSMAL4UtxnfDdEoVdu8AH/mNsZ7CskzCh?=
 =?us-ascii?Q?oVqQP5VuH4bnzjwFiNZpxnlFOwzncUjD9+pwxXpMocjwruz5i18giBusLPVT?=
 =?us-ascii?Q?6ACtRR4cjIZjOyKPZ+DcYH3J07T/Mhn02T+R6j9liADEeLxKQwb+diqzsU1M?=
 =?us-ascii?Q?bDRJcc4M/UO/gcwMYOoUfq2FhjbPJlV2jf77mMF/5cxZzZGTN+HLCdQtakzH?=
 =?us-ascii?Q?8EZDCUBB8vqBUKcOo0QG17DmXQ9EPvgIDbpF85di/VO0FFX+aPyrEVZNYRnR?=
 =?us-ascii?Q?cY44tETLU+OUgGC1X5rXcLCPCrIzCTjmrK5+m0CaMPI5LzmagZYtojioeId+?=
 =?us-ascii?Q?rEgVXqHPX63XK7nTNIYG711oUKh/J8ncZhroDSdRIS/GcqmkJRzry7P+BKV5?=
 =?us-ascii?Q?8jK+w0x0EByGIH9JVlYjrhReXTqM6TnfyGCxhNQtC6+MHy5T44XdvSSXH6Bf?=
 =?us-ascii?Q?Ci7fWKBc8hP3aoNSiWBCFdQkmFKHaA6FjwHo6hhKM9tcqVbSBkRi1Sc6DFUI?=
 =?us-ascii?Q?xUoRTh3t1xyGw6fdvWusUjQX9d11cVlRYQcupCT0mSGtzH/X85CrYj0rqXRW?=
 =?us-ascii?Q?rPRN8YyGhCSruL8/MRx/xe26MCLlsEq3jcpwXLbamPld5rzQ8xoqzhSlY94j?=
 =?us-ascii?Q?gDxKr+fpgCTxGmt7YNwwUkUWZ9b721Sy6rVk00jK0yA84Tzfugl81Lkwegf9?=
 =?us-ascii?Q?jAOERDdgXIMEn6OdSost+AIK2BFGEkFnaT1xsx0TCSJhIbQX3RTDBoehDs4t?=
 =?us-ascii?Q?uZmzLOBMZ/jnWNLM4j7R1GkuOFfzKLycpfapSqg+Lb7TtyGQlzuQ7CIBFFwH?=
 =?us-ascii?Q?L29mbWQGnXATG6QvibLLpihrc8fxESwtKkV2Hvz8FEoedI1raVbetS7j7df2?=
 =?us-ascii?Q?PAGRpv8LuMOSv11jVXqa/kct89dWNwWqMOs698cFzM48skEgdIi3DqStwRy/?=
 =?us-ascii?Q?yiypm8RcxjoxDr4Cq/I4PDA57wSLibu/HU67F2RaA2/4ucVpFcej6PUxG27B?=
 =?us-ascii?Q?N3XFk2Db4c75o6+NFeXF6vlAdXNW3TXcE1TbhP4KgyydqwXG5Wml9WAFh9Ta?=
 =?us-ascii?Q?qTs6x4RGzfIwKXZF2BdAHfVjRDzSP9rXNSkcxENy+dWXOkpxqcXqxy8l/5Hv?=
 =?us-ascii?Q?nKfrIBpdqyRDoNAMhRy6M3JrTsVqkvXkfWF5jrkX3BLSuwUh3Hxhn/qg2ppf?=
 =?us-ascii?Q?O9WyxGKwjmJgp2XyLEolW/ttg5y1SIztqZRPfTqqVZ0Pz4Kmd49MoOw9hRQH?=
 =?us-ascii?Q?YiCZ5nSepA49A1zbaMDWPs0PgtisP8WLs/m7A29k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdd50c5-7f8d-4a2b-496a-08de0b69e403
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 21:37:35.9709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICqm7A/RObGEhmD/oCM1J9Vvz74xyQx0VCN2V6ZByP4Wayw12y0XilaeZTThty+P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9538
X-Rspamd-Server: rspam01
X-Stat-Signature: 685zjeue3edow5nyjiw7fjf9gsorbucf
X-Rspam-User: 
X-Rspamd-Queue-Id: F406E10000C
X-HE-Tag: 1760477862-986370
X-HE-Meta: U2FsdGVkX1/DK0dgiBgB1h8TBS2LpcSs+fIBDwnECBf5i/HiZZaOVlkTRCs0Kn9H25PvGOHHIaxwBaxZOriujOIz8GXsxpn324zjREDRg354FdBQwOsdX9yE0gMvB67lT41RXV7B0w94e6FUnzB6q/X6bGUdljf1i38HxyNbclc0cg/wd5FLOeL8RVe2IeKmuTRUTqPu5eCgsE1C7P0shOIjjwwInLyy9ZvVFt1kTRvi3eegRH4THEFID7ebUmTWlbyO9KhM44zqS1su1o2oTa/Hkqha624BhQma+q/woqX3Wm7sE58rC6F0P4EM22+uh+l3riq7B0igMOcPoTZJ60a1cOZr4lj5DIWns6KQV0Ftbe9IV77hlhnFQYmPqmXwuGRYXK3EC3M8Yp2tePe9qrbctZEwy1i4+XxS9R5Tg2V1f4l0m5h4zMsAuS3LsrSsSNGLqXil9TEwnrYh1h//jlS3k6OpoM/6jRP+qtOwmkmhAmZDzzJmZfm4jBhK1Cs/EE/Oq+17lITa+auPEK+b2jcWH+d2CGIQ2tqr8jk6NvnJli+Hy4OLQ4ScR6vXfpfZjceL8/zueuFV87Ieb43Irx6Q8DjGK0RO2VcrhZ9dihrAsM6/RRj8Al8b2Tep1AHhV7DTurv8BglzABKlH2zlPNg2J6yX8ZFGGhYF+gro5218kCpSUo0Fp1JwiO9i5iHyv3yJIi8Z0mj6CvwyfeuTTU4NO7tXaOu8YH3U5IwQoAOZBnHeVt+Y0Xl0HezHc7cJEbyPGsUJqD7MjNajmDwUhIVLIhEA1+wf5nl2yAECNj0NteHcbyYSxhbBZG+m1o8AD6q1rFGA39Me2VXiln2nPjkfrTB2LnjvHMr3xVmKhVpCPvaMNsn0HbD/hEORuyEkrAJjehJ8XtrDdenSX3lKKej+FqYlp7AHx0b1ZOx1+ycP2wMkpnyLLoHDgSvCK9UXzaH+x+H50vzfXjF56um
 EplX8cH1
 OL2EN984aSFlrHQJ1L+eaMsB0AYdTh25gYHBhCdH0sbYgRl43aFyzrU9K4P7uzCBfu33g45Gyz9bDaOjsiunztV8r9vBo0JS1HrVerSwxenOPnrWo9Ncjlv0vUs+DzB9Ho/+mkq649IRaE24VOBiOTP6CTB7ZHbVeldKtuGxW6rvOtKpS/7WObOVaJDzMCwDxSxSBUQBzejWpNhikRjocIM6l3cKAYvC5+S/SzXMxBIRo1MTZuymz0fKWchFdd4N6Qy/HH8Ge+mOFQXDiks6EF2l337h/zMVuWOKfrfffmUY5iqvM7t8h7cGJP+xQ7KGhEF8j0Dd/ccBYOzLSBL7Pn25W/VCMY1cJ/8q9uWVGrd/mpQmvRBaT2TZFjEPj2PNnxMNsKQW2XPeq4fT1zE18NBFeamdMnQNtQejqhKKy0bfAuaeGnQ1TtN8Epzv5vI3n/+wg9OCSb2YBUAYImjxr1mSw5TKftqFR/w7co0sLp+Gy2tA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Oct 2025, at 9:46, Wei Yang wrote:

> During the execution of __split_unmapped_folio(), the folio's anon/!anon
> attribute is invariant (not expected to change).
>
> Therefore, it is safe and more efficient to retrieve this attribute once
> at the start and reuse it throughout the function.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi


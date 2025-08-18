Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FED0CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F978E0027; Mon, 18 Aug 2025 14:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7448E000A; Mon, 18 Aug 2025 14:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E65D8E0027; Mon, 18 Aug 2025 14:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18DD78E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:46:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A11D11838B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:46:46 +0000 (UTC)
X-FDA: 83790759612.11.DC67F64
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id D13C5180011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:46:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j9MTRevi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755542803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqZFUVlUJtjZma8SBMUpZfEMrFLcnaGTpgbH34xCYoQ=;
	b=xoOMHCmhwHXGxP0wKpswNTeeWXlmNjUX3vD25K49R/J6sDgMr84EyAjAVRSfLfSwH/BzDR
	2A8eo0zOcQIv62BAjSlQ+3lnS7DoacISDOraAOF97bUY3nXT5MBJGOAqaP50jtUe2+tfTR
	XCVFFYJMfrqDwLvxuju0bJv2QcPvztQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755542803; a=rsa-sha256;
	cv=pass;
	b=BBcfZ2RmtsmL7wp8vDPij2y0EMtzYXygC7Zq9DFrlUDdGAk3wVAF3hF+6oYagvvu4rjbbV
	FMO1P5HD4e+44e6l1jABbKf+zDDAJpsRs/Tw0eZwqG/JRZ1TUSBH8KoXzTjNCvTcqORR9K
	OFpmovx/2DmW8hWpiwCrFr2rp38pTCk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j9MTRevi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ap+qXSXabOpsed38dqHN0CgYgK2eDCdXdKd0pC7pA3+hWa3it2/sWJfbv18EcUdjU31Ch2XOtmUZ/mRCiKMKzDm2R3erIxfwTp+iAGbUrK7Ey0hRKdADptWC1AL4pqmjPNn2yYu9GkhYxa1rSabXJfOSU3A5hq9RhVEVGCS5Gc7tGkKpEuxWgH1iMcIkywP9yUnqDhPqQVHTALXOCLW1rO7vpezg/OAKH4ih1pT8UDNunJc47x52Fd7IYctvN93ViCME/92SBis2U4Uk9mpX7btizDeokjWVbOO4EQbeHEa2afIn3NgMDe6YdAMIdD+G8WQ0qhzVCE5HmVjQ7LDQyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqZFUVlUJtjZma8SBMUpZfEMrFLcnaGTpgbH34xCYoQ=;
 b=WTnCYkxAmH5hYWfAYU8qDoO3Isb3Bc4mHIUlk/nsWkL+u36OZIdlPbAFijO3FgJHQk9bPBahuEr3jKZmTHwCzpjPF3oPRupxbNVTSiEbp8XJSjtjB72j+yNTncMkbiQs4YrtPYpEZWCejRzJw2EM4GOVKC8Jzknmm6dPd6QUHQ2AUngmHq9gCLnCKnqGzqyLb7dkERR+mCGqqHo//tbF/S2wr77Qj5DecclpE8ZwFjTKms6l7+SgeFS2n4jE2ywa0xu35NWnz1usgLteClg49OEb4BxlIIZiGusteosPurcQEznHdN82erFUFqwI3XCiHUZ9y7LWQEletEHEF/QmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqZFUVlUJtjZma8SBMUpZfEMrFLcnaGTpgbH34xCYoQ=;
 b=j9MTRevids7tK8f8giSrCKuMJkMyDOdA6/nBj2h6efeVv4K/oIWuCjucQ8iY5RNK9TGe8PYKNZ8N2D1j7tqfVwQBunNtheTky2KZRchnaWemAtAzi8ETZQPeefy5bjD1dIkTnV9vEOjHIxNrvQiTmMDnT1JeOfVT+8q3A5cDLJmqZ/r5zTrBJhHoNXB3YiGle7Z50bmUc8VHHSvKuslPM7zTtB5ORKSINJeJQ6iSOoRf8ht1TU937gKDS5H1dhLahkAGOcyc6DUsHbwcjjV44y48Fiqn68PdoM1QSVn5HKpxGtQ8DrYOuesbatlobLfJqS9jDeVmBWaCansJQAw+VQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 18:46:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Mon, 18 Aug 2025
 18:46:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 2/5] selftests/mm: mark all functions static in split_huge_page_test.c
Date: Mon, 18 Aug 2025 14:46:19 -0400
Message-ID: <20250818184622.1521620-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818184622.1521620-1-ziy@nvidia.com>
References: <20250818184622.1521620-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0045.namprd04.prod.outlook.com
 (2603:10b6:408:e8::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: d6924d2a-1a70-48d1-d8a2-08ddde878b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FGOl+pp4W3lIsfNCW5A8YNyHIcgDVeWdCpdbfrax+H/Xz+aV+UnOmdSsVREi?=
 =?us-ascii?Q?wy2sU73DV6PmtPdX4/4UAE3VOgdIPInHuLU8WuiOfhcNML4iP+UDt9bS9/1r?=
 =?us-ascii?Q?1TnGRS3Wq20LjXaX0G9PJ79VWOf+RRs6qMDtwIRnJ5q+beWZ0XkPlfs6Pau6?=
 =?us-ascii?Q?a10t7R5d+NcGqqibCU3yuwUrdwVTOcpGno03b/D5IN2q/XTWfvNyWVkn/r6v?=
 =?us-ascii?Q?iX7Ld/OA+5D/PCyLf5fgyjVR9YGykRnNaltwXe1u4rK45+6bcDT3w+tfSyLd?=
 =?us-ascii?Q?VNsAfxwdz605nnHpwA9birCbcM03wW7fxCtR/wnNwXxDOuMNSFPJLDBqk+c5?=
 =?us-ascii?Q?2zog6SW4yE9X+CvYugYYMOGHz+YMW9v6NPTdeC+8XgDhaPT2bstDPjJD9bNd?=
 =?us-ascii?Q?x5mbnRmvP+tLWGLW9OAEp61EG3Jq3efxgxKYKbsaFA2J+vKVOGiGW0VS3qGG?=
 =?us-ascii?Q?ekr1ebhuFSVgtsKDMd7ikglJ3zGNBo3KEDIGGMxs18iInvWOtGYtNkmVOHcV?=
 =?us-ascii?Q?oeRCAZPcMF413JNADJOXGPI4CSMuxBPf2zTWprYmENdDptixWhL25V1lin05?=
 =?us-ascii?Q?crKj4voaeoX3NBshwflIh0ryoaOITGh2PDOpWv58XbPfIDGet1DLmW8O/XHS?=
 =?us-ascii?Q?Vn5eV9i6XQfUXtEUkOz5R9uCDwUldHuXjwLksZchbLGKqEe9mc+3KPTd+Spk?=
 =?us-ascii?Q?dLWU1LoQbNKSEHWRfxHl7uCOd5QTdpLBPXTmun3g0jnvpOyA3itlqfaCydkE?=
 =?us-ascii?Q?ArAK5OSBPiK6wT8v712fejJVqHeantCVgXdqhGvzS+aPtYEHWNNZtCgoHXXt?=
 =?us-ascii?Q?Og7XALxPiXAdkCuW4JWU7wft/bHlGwrHKhTKaNMOlRzOgJfmgnnpHGtkNRxB?=
 =?us-ascii?Q?E+nUsJUvabbRSlvcA7DfTTV++X9oMxp3THcTKmL2JDtMZTyIPWFiqKwwNdDX?=
 =?us-ascii?Q?Vv6Q/Jb3GcvAo8n1LsUjUbWRghNRLuAHNxbKqc+hFJwKKUJ7rQCYgFjNHGSs?=
 =?us-ascii?Q?Treg7V+wzgV0+lM0e9LNSmy+4ErlFzZvSNn0QC+433x3BYksxrTQdtk6e4G+?=
 =?us-ascii?Q?3mQDPgP67Y5FG97mahkxy/ybhSkteKsYrG5nT7EIsuGphRi80OhsIAnPMBaN?=
 =?us-ascii?Q?ZuJ1iHQ/hzJrO09ejIYUnpCMsfUwdq6O/g3JyutRdHJQ9QWJfM5AUINGFxgD?=
 =?us-ascii?Q?ltO6uR7CHFkdkSZNS4ohvW/+vOkx5VqioIoOsXwpXewAmszKNTYu9a9JC2rc?=
 =?us-ascii?Q?TcsYoWtgVco6/hSCCPqSjhZGxdGSwm7grHMYqlbPQ7d5StyocCcn9wN2yqga?=
 =?us-ascii?Q?f3ReEyAsPRrJVb0O0N2sXQfvRiis48AFyVBuksGSWBvLz67hC0E3rs4iPd1g?=
 =?us-ascii?Q?H2UZO6m4MORaLg/QsC9udW1cKY9CjOq4on0g8u8wfpkMVyffsywnDq1XLN43?=
 =?us-ascii?Q?LpMb8Vfzp7g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oL/8cYuhjS5NduO5eLolVo6ak0/5z7+g0iDL6M6S1Sys7OmhBxENBCYwefD1?=
 =?us-ascii?Q?DwseEwxQ6ZQBaY8VR4s9cTXaadr18jSYNSWEbp00ucz0vcO1E4w4tiMmmarn?=
 =?us-ascii?Q?BG3ZlGQnYFwSywn45+7zqR3X6WmEAJQCEad+l5TYb21xYvsOhJb8Mg05TcPk?=
 =?us-ascii?Q?bKy1eKAbGF+d41jR/YN7yPEUveY0c41hHeiGtXVpegThRlwCMilknjmqKGvO?=
 =?us-ascii?Q?Yu0Y5l8/S/osCaLTu8YNAH6Gy/vqlIcI8c8zssvpUaV1Ye8KAhXeIj1o5+5y?=
 =?us-ascii?Q?PrUssPV1JIEc1hhTnr9ZKFYL8BO9jIADCBcz2bc4WMuVOXvN7idV60oSbRJU?=
 =?us-ascii?Q?N1AL4sqoP/oVUsX+PRJM3+mKr6CV5M4upPuElhZllvFzKa5DyXWo9X9Dwadq?=
 =?us-ascii?Q?9tSE8GLpP6NRxMfsnMJfDV3vM+JB+Mj91U8tT8hmhZ60OTE+LH+EjkEuK5vZ?=
 =?us-ascii?Q?QOmFe+wgWj7foLgvTwzwzdycEIlTlIii0RXcI1SJtZZPvWaE8Zo+YripsqCq?=
 =?us-ascii?Q?MoaQvvDdFZSxhrvSA4pIRWRDC1yKPVM6Ca1+QKDHuOh8wevZoEh+eqTQKbRQ?=
 =?us-ascii?Q?Phxfw0HJCDT9rhwleBB1g0eKedBX18Zgj+czYIm5GfjnzF+OZPLcAjWC6xXa?=
 =?us-ascii?Q?kpF+A7AbN5B8SrAybhoG/pazTe50XjHZJyFkYZJP/PhdHhoQ2jNBKq4SqPs0?=
 =?us-ascii?Q?btzURybsEPp7OH2ZODpoqmKSTc00WB2ZUeG/5nAUSMlhJxLE8Jpue7JiswDR?=
 =?us-ascii?Q?ik/4H0GUefG5guzRKBn1uywfU//H693ic5LQI7le8jf3mYWdgINvAMGoyCr0?=
 =?us-ascii?Q?T70YS0UrWzBKjOisPDY5g/Em7qLb2t+/g3JyzlN6u3jbiH9N0kSnvVtkhfuc?=
 =?us-ascii?Q?eGAMDF02lMULO0L46s0CcGIgB09CyCENvbH7w/yYmDI22046krbMHKLCvBTL?=
 =?us-ascii?Q?hxriJ1moxBFNnJcXh+F8xVLc0N6Ps85zPrTBKT3eKy1CeIJwH7522Y9ukv34?=
 =?us-ascii?Q?wBA2joRlZP7q/e/q7IlLuQSYKEEh5mGPF6N/iTQ3iQN/xNUE1ZHpWPwcuaIq?=
 =?us-ascii?Q?4grPhrU2oNDr8KPMy2WrZ8jyK/TgvKJ1lnHrjB1xZZ/ll97KhHYFuiChFx0E?=
 =?us-ascii?Q?jx0Tizz6rDk9FQ7c95nJCpHBUULVvDeSWJmlWvCo1l0AV14TULIN2678UqIV?=
 =?us-ascii?Q?m73aw7idbqaLDcDQQj9NPukqHx4izBjbezYbDLci5/F9FMNyCk86eRJ/M646?=
 =?us-ascii?Q?pUQnbt6NlwSrvjqvPTtI4QnxDQ8aykHDgmJvZuHkL8lShGaPatZ1c65S7iMM?=
 =?us-ascii?Q?Van13wwamdc3IzKcDT/53nPp9ytDqtE6uiOi28neq41c3JrsujxzDb7D9hZb?=
 =?us-ascii?Q?T08ANC86+lq06LZAN3OV313d0/viIPRG/MrcrKmL0Ne3o+Dvp+DqipV2a9Ip?=
 =?us-ascii?Q?JxzYZr8wv+/kx7hfI/b4BsNKRlfOR0Mk1uuV43xxn+49EbR/C674SUj0wUvu?=
 =?us-ascii?Q?BMW8c/UfRvOZ4KKZr1a57TMj2ka+L83XNRdjau0kFGwz5MQXGmPLhpJDCwoR?=
 =?us-ascii?Q?XpNAHL0xJtjWmP7/4o4xLM0ZyCvx7FHWS+1aPdqs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6924d2a-1a70-48d1-d8a2-08ddde878b98
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 18:46:30.1968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1aFf3xQvA8VqHUDAd+nXf6UzsEj1hcObQqB+hjzWy1XD7uCtEjLtnaIQp2Hb8Mk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D13C5180011
X-Stat-Signature: ptuyb8r7u44ytawiy9uxnad1b7f6c3io
X-Rspam-User: 
X-HE-Tag: 1755542803-699777
X-HE-Meta: U2FsdGVkX19yEuhoBMiQTkp9KjXT+2PXJCq5sBZ1HGT4DIWOHKXSpgiIBkKEP0++GB4IqIDImsfxrcg6qRYOtNplZN/cDhOL4z+FeMWE7597pfHQSRYtADAH4Efc8kpSf5/vMGWUp9DRMfedY8s1EkMZy67UfYiJX+KQXZDdBWL6Bxw0RxIb9f9wx2WroULS17yqNjoDWL0/uRm7iNExwA335HOF1E2z0/qRkXZWg1APy7Gzzv/8+lizYJ52XVmLmbrvZHEJPOA6xDnzMMrYcmKunkXGJl7h3k9/s7iThXxh236joII5kGRYJd1dUVTCClg2NLFkHvF72einuM3PQLNNxAhLYllNLX/zwJPS8+kEU6Jj2BNFrbsZn6GpBbAlbjT+Xf4vTiy1aiLdeCsPfbYhoqTHefU+DgmQAhEm0oBfLKxw/78siZj42XM+ni2GqncdRL6ykOlExvRKyyfqwLBZkCCqeLgwmh4Hk2Q1uArIy9DPiHi12nyYkeC3HrRNfHeynDW1t9OL/MN/RDRfMvCCuU4wTqW/P3HPKcMdUXtRSMnZhlL8mmEa2bTdiXQPDFH8J6vM2wB0RQvHC1ieY82aBMH4Jp0kkRsEdo7WjLrSrBeDi/gRnO46QVInZ80obp6RDHzyQV4+ca3i5xqQY0IbKj/pOXyEI+uarq7QoKC/GMrU8zcO4zDsU5cvfAfhPsQHClKsbU1B5+STKpOiI2eQ6+ipIu8SFx4aPdisZsyMEwZZoP562a9q2nO9niAkmVAzeje91F0aabRlZ5N6sZtov2gD3Fi1x6u0hD8Dyt5UtvZLHpeOFihLX5/i2yFh+BaLocr5wRzOaB9TBjfvT4/ze73nT6N2gXBdvDIE3KG8Zu2licC5+ZIsvM0qeVb+IWtkIBmIK4pY5sylxo7ttDhr5ZSDmOvsejMq+6q8/1zKDDE+iJVkKtqihDLFVSjuCTw0Gu7FQvRrAa5UkYR
 naRjTQTU
 W7Qgwnbh4D3puEgr+T+5GXSXmUMuSAmpbQgVzhzJgE4UWeua4MGbYeeliTBQdPVeBe1w3dhnQG2VzQgCokVAe9GK1zPfA3aGZ3SPbwZz19iApKUD+zK6ahn29tR31FP3KVKZlB1FeAicpHDCIDVTqntiteanf4CRnD4ZzGa6dglfoeklX/w50m2r1ANnObKmP5+eE9pkXcqZ2/Ss02x8+3ie3FjWAjm/RZmxEqvYqIpEAR3SqB98J87FE0nGUWPRMZ8Et/oGliTA+twQXJBUl7pBv+p/EAJFz0MsbQFw8WBuSaBPrEg1skR69/8yHgL7pl7mx7YiJSOR1xWnOBInlK+fJ5ttIppJT6jQoCQ33IdRMBkV5Ali4RSVbu3jwO6hyESpZkKbX9z2MpL1kF0R60oFTJXuAUyBz56/sU+AUK2UIYFOE4vOg3uNIEmjicxXbJpFHvvVTPVWF3sOBXSt7FRPPj7YQRfpxrMrTUrnjU+2mGZbcIiKz0IdivQSW9jaNz9efCqYfTDHg6A0ATt+T80a3akxe/eLRzzJqlWUp7IEH85qaMaRPjq/s1PDOMR1gxUDkxkTqi/UeZIW2sq517V/Jplm6eSbhn3f+THLS/xEpWmwsNzuZfLf/pNJBFDVeIV+zB4EBqrCAm6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All functions are only used within the file.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 .../selftests/mm/split_huge_page_test.c       | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 54e86f00aabc..089e146efeab 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -37,7 +37,7 @@ uint64_t pmd_pagesize;
 #define PFN_MASK     ((1UL<<55)-1)
 #define KPF_THP      (1UL<<22)
 
-int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
+static int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
 {
 	uint64_t paddr;
 	uint64_t page_flags;
@@ -135,7 +135,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 		       rss_anon_before, rss_anon_after);
 }
 
-void split_pmd_zero_pages(void)
+static void split_pmd_zero_pages(void)
 {
 	char *one_page;
 	int nr_hpages = 4;
@@ -147,7 +147,7 @@ void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
-void split_pmd_thp_to_order(int order)
+static void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
@@ -181,7 +181,7 @@ void split_pmd_thp_to_order(int order)
 	free(one_page);
 }
 
-void split_pte_mapped_thp(void)
+static void split_pte_mapped_thp(void)
 {
 	char *one_page, *pte_mapped, *pte_mapped2;
 	size_t len = 4 * pmd_pagesize;
@@ -264,7 +264,7 @@ void split_pte_mapped_thp(void)
 	close(kpageflags_fd);
 }
 
-void split_file_backed_thp(int order)
+static void split_file_backed_thp(int order)
 {
 	int status;
 	int fd;
@@ -364,7 +364,7 @@ void split_file_backed_thp(int order)
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
+static bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 		const char **thp_fs_loc)
 {
 	if (xfs_path) {
@@ -380,7 +380,7 @@ bool prepare_thp_fs(const char *xfs_path, char *thp_fs_template,
 	return true;
 }
 
-void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
+static void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
 {
 	int status;
 
@@ -393,8 +393,8 @@ void cleanup_thp_fs(const char *thp_fs_loc, bool created_tmp)
 				   strerror(errno));
 }
 
-int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
-		char **addr)
+static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
+		int *fd, char **addr)
 {
 	size_t i;
 	unsigned char buf[1024];
@@ -460,8 +460,8 @@ int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
 	return -1;
 }
 
-void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
-		int order, int offset)
+static void split_thp_in_pagecache_to_order_at(size_t fd_size,
+		const char *fs_loc, int order, int offset)
 {
 	int fd;
 	char *addr;
-- 
2.50.1



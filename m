Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E964DC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7F86B009B; Fri,  8 Aug 2025 15:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF5D6B009C; Fri,  8 Aug 2025 15:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADD46B009D; Fri,  8 Aug 2025 15:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 593D76B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:02:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A164914043A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:02:17 +0000 (UTC)
X-FDA: 83754510714.12.FDBDD47
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3781100008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:02:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nHR4DS8U;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754679734; a=rsa-sha256;
	cv=pass;
	b=vDQCFWYUNp+rqorsG4vW/X7eA+GTguWUOKx96eDtincxCx6rtxoTsfQT3Qk2Ng5qZueG1R
	Y3MWGpl0/LoJRquvpE/Ug7ezhHXFuJQwbetp9pgdgV62qg0jmb8zQDTCWc1dtBCld5PMVs
	A4GQWdo/tySJDfpODP/5wpbz4p412ng=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nHR4DS8U;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754679734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kO7MEf1T+017gH25TUunC1UaapLIuoNyE9g8ewRxnKQ=;
	b=bI/FeOgBk5k/ws1kuUoUfCKL/cnwC1JYSogOSrvdNztMAOmaSR2tBZLsOwAb3nZP50iwvg
	5NU4cZh8egT0HBLz1/dErOeufPaNHJeXY+M38Ig01G01rQLY2L64T73Iwd4/jYfOp5DUK/
	9uCMiAXLirf9P0CE15evhvIODgmcfyw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PmW+m/VqTNuGce/fXeIhpiSc+jbct0GGA3oubn+sQYELVAWIkjB81nujanPGSv/f/LOTVCUMxBu/lwHFShj49ONKPgEjnWhZLT58fUP+LlYeAHf/+P3zorAM3MowoV3D78rSToo4tycBTCVX2Nvl1CdMrJ15Se2EC5GMHvJ53wB02S1NfpVy92PKWzLpNovyon9J7Dtu8ZYOdcUjpYOZlDeWixHApj9cYtn2dfi/bA6VglZFl7yo4UffRcvkzhX8+z78dL99gyKDl77qbum1mRfzZMhhyKzL0KlXeuiIBAgK00g1+3u8rIPElqZhNqKao9hTgperkl9VbTQKKzUDAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO7MEf1T+017gH25TUunC1UaapLIuoNyE9g8ewRxnKQ=;
 b=qTzT+rVhqtSDuiRRji/QOvdAHbY64C3FDsv6IMbbcYvMGXnyuyrZJxvYGVzUG+GLXjDBhliCaegsMpGSmVZO7zlo8uWmzNqEImi9pdWmzScSxFeJcqtHwBGXUXCER6zmuTpPs58tt9uZGA1gSX9i36+vtPjdBimDSfgoGjcsISUt7ojQeSbvUy2Nz0cMe9yHfqE35UtiGqvaIPJbEozJsM9Plf4hnBg2KXQajXU4PGxpslPYYgFxzy00hDnX1FnWC316u214TzGbarRQEXavUcAc0ZW35Jmk8VOIlIyLT/Gb03TNZvPlevoPcDtt/ndv24unfRTYFRFmRe6AsYurZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO7MEf1T+017gH25TUunC1UaapLIuoNyE9g8ewRxnKQ=;
 b=nHR4DS8U8dfdlvogTxrvskWQmrywRLn+Yjy6SOLA9iYNINiOrathfJusqk1gx7WxLc3bWspLuRmNYwcGIvBxUyyglaspdCqQnnXkpgd1YI6AIS0g/r/vy7JbaY3fMh/147r3zxIhz5bM0PltKw4r6xs21lRphKyalJSc28W4zLvqhKTw24IwKXTgj/1wHlN4aQ7Qrx1gvVmDM/AmYy48zrF8jCeVzoJyJsGtHOA0FOSWQivJr22BJ/SGblRgE5Qrp3LqLkjA5P2tK6qbp9EYgdo7yWhMLGvuAcbfEW4eZ2AcBSJenX1gmbsgVFHv7nn3eJxHRtO2AVjf9Y66xrMYXg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB9090.namprd12.prod.outlook.com (2603:10b6:806:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 19:01:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 19:01:59 +0000
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
Subject: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
Date: Fri,  8 Aug 2025 15:01:43 -0400
Message-ID: <20250808190144.797076-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250808190144.797076-1-ziy@nvidia.com>
References: <20250808190144.797076-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:36e::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 418ed480-0064-406e-c254-08ddd6ae0d90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kk+x7Zn9iYT4HZVOmdFynC3SM/Unv8v4b4ycU7vwyb/YmVPLc/DhribSDscD?=
 =?us-ascii?Q?ekbPKIpFBoM+SFaO8Yo7zPLMAE59DH/sdDU+uxxmqEMZKjmSzb7U2XWN1RA3?=
 =?us-ascii?Q?RMJaVSAOoWMSUz7W28rlsXxgYnd3QqKAJ4vc94iYGYp8YSSUTikjfTuLXd+V?=
 =?us-ascii?Q?rx+U7spZCMD9898doUrqj5JF08iTnVnEgmBhQuXuqfOuRX1TNj1iJWINkDPg?=
 =?us-ascii?Q?PkbHj/IgFZpB5CxyIqD4Lx5qv9zuHD2MbmVjDgF9o0x+4XqEfkuyjasxfdnE?=
 =?us-ascii?Q?gdrrWjotawAKPZZSahe0BXCzWIxdaVhcaiiYH4U5Ot3rNy4CIxNh0s/Xth/E?=
 =?us-ascii?Q?QpZDpRPJot+TmJOzPcRKeypB6gZQSyKVQhPKg1EAE5xJy8MfOt+3VYuxAgGr?=
 =?us-ascii?Q?I+6uh3gdD1YyVJiOcuZM6LAqvSSNOKRsz9r4XSKo+Qfr43kFkFH1/hwWp95v?=
 =?us-ascii?Q?SUtvy1fQ6Noi15AZKPM7eELZLOCEyOS30vgrJPkPqsNiC+DP0vzDe+Q63X5V?=
 =?us-ascii?Q?vatrbzeKq78SLil7Ig3k/rOycG8KJ6k5giAmiGdMckvjRlGPjYr4WCpYaZNv?=
 =?us-ascii?Q?AmvCd6kn7B+X51S6PQUqA9p93sJ80nRo2z+/3/YsJhms13oBVfY2KAwIcl8X?=
 =?us-ascii?Q?K5IddWjjiAGhG3ceBFMMjBDLaJlqiBWMDyMmdxm1iQrM9iuxSEopzhqM6HTj?=
 =?us-ascii?Q?YZM8jbvIOhKRr7dXi3A+zOmPRRI3R4q9KjnhMcUROUkcTe+ZdWrg1OL7qTkB?=
 =?us-ascii?Q?fW8QY1j7TCwQ30x204eO2rilaYzg50aB8mZv5d2I/1U36Tmz5/UyQbhtZaMW?=
 =?us-ascii?Q?Lf+yRAN1O4sVFThxBnlZNgRceOPktKf5+f9gBEQP9DC9K47lb1yfYdBaWvvE?=
 =?us-ascii?Q?YMNXmwIjtUO+HZwA1/ai7oHJXWafVrfesMawNcH5VM/mORqMLSIAy5T0Xnnn?=
 =?us-ascii?Q?91nJQGbPrd8/vugP291PFZyEIfyZydwlIWtx0AtKykaQCcVQMlnd5x/32R7f?=
 =?us-ascii?Q?0+mmN4w3tcPYy6EgpjM4kG+ttF5vQJtaKImxTaukkSL5LckVbbb0sxvyI4Sk?=
 =?us-ascii?Q?E0+9Yh5OqhT+nFbi8bFMhntqu3kwuJTICTiTn5Vghn+hQbA4LgqTzQHe21db?=
 =?us-ascii?Q?1qBEDfBWBGMzhVcMTc/NgH5UAJr/qjIyfO8X1XvJzxjYUW5wwk9sexp1Ey5K?=
 =?us-ascii?Q?6STq/56DYlez73AYrNVgPTN0Fl3rFWlkYPJe1IEUqsmY3Nd7Q7p3+xzxsfwl?=
 =?us-ascii?Q?N/qM0skKCdZiy+S2CA8TK/v75ygq4Unk1Kl8OsWQQ8+9i97kNOJ+FbJWGR+m?=
 =?us-ascii?Q?iqbmiGK2LW5HMHnxfAi5xTWdAElb64D+KHmKb2J9iWYQzWn0Kd7SQFw0+65f?=
 =?us-ascii?Q?yY55s2v43dgnNOd/rXku4+eLDqic49PzZZUmHc969QAVZQ011+gZY0Kx1WKG?=
 =?us-ascii?Q?N3hPkKDwp50=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e4sCNp/CobbMphBT4E1xf8lqXStifzDPbnMu0oQm1ktQJpyjHU2GHSCNc8oX?=
 =?us-ascii?Q?GnO1K4D9iHM59LEuQ7wUGVMUorbS/O9QFLGQoSlUp0ulNkbrJCAuacixIqNN?=
 =?us-ascii?Q?jmhd9CxjmC3vocFnaqxysuP2F8mcHdv2/mjNsMbUE6HxVG7Ro3XlbJijrAFA?=
 =?us-ascii?Q?uZ/TKkF6EMqXgfanvkLkZe7j/0g5thb/WQCt6yxzoM6mZhMc4k+SVS2+AQh3?=
 =?us-ascii?Q?vVyFADO7olmZMnZKL3oLWYXzFZ22CAHIiuSM51acqxI4RAImQ7UUMPFc+sU0?=
 =?us-ascii?Q?uEqs9DxJxe3prEwcckAMiGF8i+PknyUeUEGQN2v4xsLg+aluC7JjeBFp4rBP?=
 =?us-ascii?Q?yQHSiMxGVrIpsUNGzzfc+f1aRbKdiM+XrthEa3kkMuxZUqy1hl9Sf15q23zb?=
 =?us-ascii?Q?P70SIZA+RuI1becTiJdCYuZ0aAtG2QfVNnkrIoQ0VVt4QTzlpMt1Zw4xCvT6?=
 =?us-ascii?Q?mnWZYzimFYeLEXo4RaBycVfHgnSt9cvTThZRgKJr0aSbWEeZk3yYw/DoHhny?=
 =?us-ascii?Q?JBHPt0IHPcVAwJQfmo4Kcb3QORX4AAkPzz3cP+bN+wURkv5H0RfyEgeq+eXi?=
 =?us-ascii?Q?PHnM89oBV5fdUIZIYJcRNVSvIhRdLNgo+hJKVxZHBZvQIjjJvwVSj8ARi0Pq?=
 =?us-ascii?Q?S30S12ySNxKi+92wVB9FMKw9vQR8kqbDjn2/2LNBHn0a9s52vzSaPgupt37W?=
 =?us-ascii?Q?YdvoOuEUp+al5HchVEnmWbALLSbs9uVX0adijAbAY/dJzzadTRUr7dPV9ZZt?=
 =?us-ascii?Q?Aua5aD0++L4hr2eFVvb4kJ9FaUPlZmJGbWVREoovRvMLIlYxKEpUjYaF5DAU?=
 =?us-ascii?Q?V+jb3qirqmHDxQ3o9Yu+pS5cm7NOpVW7q3YAfh3fii6I9YjqelEHUvxjM0A1?=
 =?us-ascii?Q?HBWJGM3XjfmB+5M7P+tVuvWnUbL1r1jXFyj4UGN7/olllPydi5uHkhWGq4TQ?=
 =?us-ascii?Q?u+Pgp75VZmmdEIYoLeQOdk/aQfd+J0gE3WUJ0sjh2JPfMURcLUj5JwOgvi5X?=
 =?us-ascii?Q?jl3CTcW5kIiI7SoMh3kRmuqhsCWRSi95CmN2SStUtFmTqXH5GDVQKof/B9U2?=
 =?us-ascii?Q?I6Sg2vTMfMP605l593VapbodsbJ9sLjMHmiw+txaZ+BaKmyxaPFHzmTRV2SK?=
 =?us-ascii?Q?dXKIrxysIjAL2ADEITxrWcSn8l1OuGmTHgodC5pnyxSuzyAbwlUOxv9qE7TH?=
 =?us-ascii?Q?16WTakhsrY/GZk2+neWQjpZD+AJAkjjrf+FiEci3jlanjopCi+JHj/xSgSlv?=
 =?us-ascii?Q?ReoJQqQeVvtgCGtSKJTWlYYoCTTLw4ePRaUMlrvRFlLpQuojycbSfK7aVJ9/?=
 =?us-ascii?Q?C8k+motu4Mb0yK+BACLEEiOvVUfzO7LFdaCcRhGUOG29T1N5UgRchl1CF1q4?=
 =?us-ascii?Q?gPIdm0Pfv2DM/OLpdBS3BK/GPcNKYg8f7HGO+HMyzqVYH/B2TqwYjEz2UvIl?=
 =?us-ascii?Q?AXdLjaRY+/mlr+zN3pXp8iOHSqGjNfnexzRJEaQwWu5L99kWw7JrbVk15CmO?=
 =?us-ascii?Q?os7lRUvKCK5iMP1DK/NsKjzgOId66fsWJ96zGn6mpZ4EU+lyuxVj/I73DFrN?=
 =?us-ascii?Q?snqKiyHVyYaxceN81kiMspo/RjDmL1WLEs3JlrZ0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418ed480-0064-406e-c254-08ddd6ae0d90
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 19:01:59.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +n9lbTuT4SZWl/nt+frGKIyjUk2my4D5q+GWDzhkY2dIhFKa53vo24ZqGk9Z0I8x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090
X-Rspamd-Queue-Id: C3781100008
X-Stat-Signature: htk7bct3cn8pgukwdos4m9pnrk5nzgsb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754679734-883791
X-HE-Meta: U2FsdGVkX18he8EeGG+e3zEWNKVyDwa7bmXMt0KypRTqLWGbJO8tH4aguubBNggGLe5yQmlEH/1P6Xd+uGHmmNTruol9yBvSR8H3IfY2Wt9kirBU9UsKAkO+rR0EE+wAgAlb4bRirALOKzAnOi7wFYuetXQEw/2EyqXL1FjChXoOR9vZlmnEp6NPwo72KbuMFbn9xqBz7EeR4IuuU/9QRo1byTnM8UPJU/Hzx77RChIsyENBhN4qSwVPutTIHfp5Po4ShPPFPSevqLBHUbHsGQw9DsnbMBu3Y+7E482l5jMaKMIlsz9gblZisSVCyb85T966YDGqwK3AP4sMHEdfO3P7DWqv2Rc0cGcejAgD6Z8pYAEOxXKGNdIlSDCc92W7+cNJiNP90nH2/AxL6g7L9SE3UZt8QTLCFyCCu68KcZwNGr5Db9IfKkHoG1KNcSraPP5Jr0c7yRmj7LM3PxjMcibT0vfFUayl2jC3bRG59q2h6nEFBtit4Xo5XVavb0vcB5enSxjecivCjDO6I6qGsI+I6pzqgszBGGSHZRh4V4QTKQrPC7e7y3jqnjEz4IrawB/iU/T6O581xU020gwJFY15BWSmRHbjbsw5jYHgLVFZIJZXI6cgH6qWgeBB9lZa5qYR54HigUbi76fxMXRM84BVToUSKaopgMYPSCIWFzGaOtpsGDfRmLbQ0gE532wEDm0CBVqpxorO94N21BoL9rQ1K5lEhyRYwYzFsngC0IWSyeISkdkTroTE5rNMzvs8iLVdv5+OeQ2+3U1aYVEoH6OgunS3j6O4+ID3YeAEc3sIrHMUw8TmnlZZMyIFneXtPe/R6WaXsjjRW6elingx7oBzKjvNnFMelUAb5h86+avTQvueNYg+GRh1yOUBUkB0Ei04upGPagXsIMjn1K53HS3uu17fE60YQQDITThzA9m2fRfDYbNYpXicxbsi8sBmHXtw6KRtqS4hEktd3lW
 r90Eza9B
 aU4W5xTTyohC1Cp78JjR8JXi3Xlxd80WBUQDH8LqYYZuaM5+J2GHuQNYRP8yBDO6UlvPfxQhTAL7WHGZMy4i4ZeKH2yZ5jygQRqEAzYGsKkyfS4Nr1eVmNTpY3iOu/5Wm7AnRg1q/E4AYkyuSRdc4wob+cytiwbCyhCNok4MlZdkHk1Ez2COG/rIbCB42PT93vKiFxlY0mkxFpYKwwG+1FbGR98JE68Z4WQ4Ot4rveCCMCyxB1tk5adyn1ngjjbBdrutq/kOQamBSKQi5umH4GpJX15+DBjJasW7Y/JzDHkAotUkFKDIR4L0jfYxlfW3jEZBMowoDF/k1ZEcj20zJf3QcThBiXTecy/K9NRgwZ/yRtXlsba1cvpHlzGNywEI7xHTKV5zeoDuzfsiTQrYpQ8ZTz9v3EXoGlQ6NP3QkcmPKr+CctsB0w1xtT2T1J2FVBK+NBTQmtI4wNfoa7kA5L9T9E4DEKm6+rvOZebUkoyOlG9QBIToEj+C8B8XBxIPwGa0zSlC8rTH2uuD5/u/77wyJPANgYchUybm9eyC70kGKM+mQBf27Iu5O/gPIaCe/1HXXzKCQl+5ZjTZnPmAKGI1PjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The helper gathers an folio order statistics of folios within a virtual
address range and checks it against a given order list. It aims to provide
a more precise folio order check instead of just checking the existence of
PMD folios.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 .../selftests/mm/split_huge_page_test.c       |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 3 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index cb364c5670c6..5ab488fab1cd 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
 #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
 #define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
-#define PFN_MASK     ((1UL<<55)-1)
-#define KPF_THP      (1UL<<22)
 #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
 int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
@@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
 
 		if (kpageflags_file) {
 			pread(kpageflags_file, &page_flags, sizeof(page_flags),
-				(paddr & PFN_MASK) * sizeof(page_flags));
+				PAGEMAP_PFN(paddr) * sizeof(page_flags));
 
 			return !!(page_flags & KPF_THP);
 		}
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 6a239aa413e2..41d50b74b2f6 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -338,6 +338,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], int max)
 	return count;
 }
 
+static int get_page_flags(char *vaddr, int pagemap_file, int kpageflags_file,
+			  uint64_t *flags)
+{
+	unsigned long pfn;
+	size_t count;
+
+	pfn = pagemap_get_pfn(pagemap_file, vaddr);
+	/*
+	 * Treat non-present page as a page without any flag, so that
+	 * gather_folio_orders() just record the current folio order.
+	 */
+	if (pfn == -1UL) {
+		*flags = 0;
+		return 0;
+	}
+
+	count = pread(kpageflags_file, flags, sizeof(*flags),
+		      pfn * sizeof(*flags));
+
+	if (count != sizeof(*flags))
+		return -1;
+
+	return 0;
+}
+
+static int gather_folio_orders(char *vaddr_start, size_t len,
+			       int pagemap_file, int kpageflags_file,
+			       int orders[], int nr_orders)
+{
+	uint64_t page_flags = 0;
+	int cur_order = -1;
+	char *vaddr;
+
+	if (!pagemap_file || !kpageflags_file)
+		return -1;
+	if (nr_orders <= 0)
+		return -1;
+
+	for (vaddr = vaddr_start; vaddr < vaddr_start + len; ) {
+		char *next_folio_vaddr;
+		int status;
+
+		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flags))
+			return -1;
+
+		/* all order-0 pages with possible false postive (non folio) */
+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+			orders[0]++;
+			vaddr += psize();
+			continue;
+		}
+
+		/* skip non thp compound pages */
+		if (!(page_flags & KPF_THP)) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* vpn points to part of a THP at this point */
+		if (page_flags & KPF_COMPOUND_HEAD)
+			cur_order = 1;
+		else {
+			/* not a head nor a tail in a THP? */
+			if (!(page_flags & KPF_COMPOUND_TAIL))
+				return -1;
+			continue;
+		}
+
+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+
+		if (next_folio_vaddr >= vaddr_start + len)
+			break;
+
+		while (!(status = get_page_flags(next_folio_vaddr, pagemap_file,
+						 kpageflags_file,
+						 &page_flags))) {
+			/* next compound head page or order-0 page */
+			if ((page_flags & KPF_COMPOUND_HEAD) ||
+			    !(page_flags & (KPF_COMPOUND_HEAD |
+			      KPF_COMPOUND_TAIL))) {
+				if (cur_order < nr_orders) {
+					orders[cur_order]++;
+					cur_order = -1;
+					vaddr = next_folio_vaddr;
+				}
+				break;
+			}
+
+			/* not a head nor a tail in a THP? */
+			if (!(page_flags & KPF_COMPOUND_TAIL))
+				return -1;
+
+			cur_order++;
+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+		}
+
+		if (status)
+			return status;
+	}
+	if (cur_order > 0 && cur_order < nr_orders)
+		orders[cur_order]++;
+	return 0;
+}
+
+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
+			int kpageflags_file, int orders[], int nr_orders)
+{
+	int *vaddr_orders;
+	int status;
+	int i;
+
+	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
+
+	if (!vaddr_orders)
+		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
+
+	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
+	status = gather_folio_orders(vaddr_start, len, pagemap_file,
+				     kpageflags_file, vaddr_orders, nr_orders);
+	if (status)
+		return status;
+
+	status = 0;
+	for (i = 0; i < nr_orders; i++)
+		if (vaddr_orders[i] != orders[i]) {
+			ksft_print_msg("order %d: expected: %d got %d\n", i,
+				       orders[i], vaddr_orders[i]);
+			status = -1;
+		}
+
+	return status;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1843ad48d32b..02e3f1e7065b 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -18,6 +18,11 @@
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
 
+#define KPF_COMPOUND_HEAD             BIT_ULL(15)
+#define KPF_COMPOUND_TAIL             BIT_ULL(16)
+#define KPF_THP                       BIT_ULL(22)
+
+
 /*
  * Ignore the checkpatch warning, we must read from x but don't want to do
  * anything with it in order to trigger a read page fault. We therefore must use
@@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 unsigned long default_huge_page_size(void);
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
+			int kpageflags_file, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.47.2



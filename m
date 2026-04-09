Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E85F31E29
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18286B008C; Thu,  9 Apr 2026 11:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF786B0096; Thu,  9 Apr 2026 11:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B050E6B0099; Thu,  9 Apr 2026 11:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0F7F6B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:27:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37E0F8B847
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:27:11 +0000 (UTC)
X-FDA: 84639395862.25.C8038A2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A1CD40002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:27:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzGYzL3e;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jzGYzL3e;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775748428; a=rsa-sha256;
	cv=pass;
	b=lKD/PyQiUZ1orw5arcPLpUDRfbno0e9fbrWCNcXebLCepMd2P4mYEZ4NAGE4Xa8HWJiGtx
	ypXjtiyx3rgLuNN3kP9gpHyyUv6cOjEiSmRE8oSmlDRq5eunpZ4EboeGzDxd5kXRGwOR2B
	enLEpoISRwvD+bOmUs0Vv3ZkfFOVVl0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775748428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQDB0MtR2+mohQlED1h+R/q3mDhgYU1YBK1JC1Llw5A=;
	b=CRtSdE5TcGVCvyGPL5BHjeKTNgDg3TRsOPUd7etOsgjfDfq5f6SHx+0n0XwbPvjOP+WGz7
	0w2Tugt3z8qBD4P0TcYEe371KEEqR6qrUV7rg+7vNPRPM+dJGUVmZXg10dddLkxMx2hb11
	JfzZAZ2eDHRNt3Yt4ieDdivz1Xf4rd4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PtUPaFYvg5a5i6jUqxkCpShpl8wqIvGs7HQyTpM5vwaB7zIc+ClTsYq5P6xdeANUYTeQCT00uQr6R3ta+8w658ftCHHzhh6KzIcQkrNI5U/IuQ2UNroai2p4fHNYvUfm/WhvS6knH8Km0BgQ1YAyAQoy3JZYPKei6ln3EGFZg4aFjZmUS24I1pB3/w3YsI3cDt8fr2FJSPCzo2npbmiRQY9/iRfDz7raPdXlaHzxTFSnlXATIldA+7v25U/ld2ROvf3IaGLlxv8xFSEINgz6Oq7YaWiACGO9S1QU2u+yF7mKghT0MC1QBa1ow+SsC/9PHO8vBuk0I+cfE4kh0JAb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQDB0MtR2+mohQlED1h+R/q3mDhgYU1YBK1JC1Llw5A=;
 b=DcnKvXX8D41jc72C5KZf+0mApXzobDnRuY22dRasltuG8Y7lT7PTmhi9TaVowWSJJatwMdK8rN3lkywncwA7M5v6LWj9cPNBZQJknrslMZe4G0D+4ppC8o7zX0QqqGgnMAhpvkHRv32X+M2OeWrAJkK7r4hLoUeFKRpMMfbGbyRu09Y2um2URpfo3mzWsdkgtp/juEOTPqR1wRpISxVWZGdkM6LmyCzFcn0zefIatnu5Jg/DX7H2cZa1IiqyH3bCN6VzxyUeYyX1YLj8gGubI3mQexUlnKdKP/hCF4R5J4R8luY+yA0KMGWl2x4UGYArT5cSuVnhFOYnug8ejOIRRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQDB0MtR2+mohQlED1h+R/q3mDhgYU1YBK1JC1Llw5A=;
 b=jzGYzL3et4VYo0i/4TTROZcD8R57MKm5ZiMmIc6oWJ/VFIkocG92FSgEoj4btDviDKXSNqICqEHZHP3x0h4/UKSrudgsHa5EOjg2yfu+WaA9U0t0K1xG5xUKbKBYTKvgcG0cEftpQZdsuIPoZD7TKjTPok/NckupyHInL6AjvvPCPi+AoE3RzCgS7aw14G4cwYXX+r/8aiJFVhDFts74O1Zz1Ta+pqXsoviSi8/CJ/JGwFl8nlamR5bBzOsL2+KVY6RwSHIrP+1JIdaJ3gVFgAAd8OzQ48rqKwHsYC/hafO/H7OkrTmu8OpHNspebT/G+x3Vixs1OEJd5/guAsvGGQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 9 Apr
 2026 15:27:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:26:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 06/10] mm: shmem: drop has_transparent_hugepage() usage
Date: Thu, 09 Apr 2026 11:26:55 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E70BCC4D-83C6-4C9A-B213-7ABA5F9A51DD@nvidia.com>
In-Reply-To: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0415.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: b4381776-4736-49ea-686b-08de964c7089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	a5DXftB6FH0lLeYgvbbQRkFFbMeCA+yE6XJ8cAGZ4n5RweTMhKtdy3fRn07RaPrO+wPYo+9kVq5fxGMpqLK0I7V1l+S6dHLDqHgCj8czSvEPfCZD4MF0SvmtdbqVVzx3Z5NhuSfPXUqje+rIl5quWUBjwgdqPnjBuiB4h1U3ym+0o6HZ54acjB2EuIZGE/tOcWyL0FPOzpaiXR5NLExVcJHSM3WQHbwnEQwt+05fdfRDYnFAvOptBKMQFX7tRjf7s/JrEWRhLoO8E3m9sHwKs2WbfItwkgL2/K+y7LsNq5aBGTyjVRxKaXdU+JllyrBYzc8rPIShj2ZBSH8khEomCBFoqN9AYyVvlHgnHdYIc3lke+C7qfapozNf/bbxbqwpe++sOuoZnIBivE61JfXW/5CRvZC4gA3W07UiVHx34FPXYUT4vnrIInbZS2iPxocycDslkMiP4iSpARv+gLcWGcqKRMbQMTl0HcUI0qQJ13uhckNOfFrkqgJZXdrIJtrPJ0v9SaIgEzOOdHZc5KL92mu14wo0b0mpMuiHg+iESxxyUIGRpamqlnfsWuewc4jFwFfoNsySpQUdCfYJ2WhIAyeLj4Pzf9VZ9pM4M9Li3RCNMqVAxu4SqKzWGYgc+6TtZzsPApfhxsI+CMGxP5Gj+kmWKUbGKDh9MEpbpf+mv3OODcsmH0i0TpqDvobiRUumjN2ghRUP6hctYkLzH4DoZyYq17whyztaYDCg/I5le1c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MNGYqSJsDJM1kyifvAf/NKnBfX2TT8o/yNaV37sjP1XklhG/KPO9jN0at10r?=
 =?us-ascii?Q?0sdcIozb7/B+dhT2Fbs66LQpI9w+lMXJHtTA2s4pBWCdds5u3Z88Bi+zsx5K?=
 =?us-ascii?Q?/WPEhsqdKtlhIumvWpUziusgCTgllXinsTZiQ8MyHMa7ubfwaYig4JdPOrpR?=
 =?us-ascii?Q?qeJozvHQ+STZcchdYOZHNFipF4gRLPH7WQSTOgb8xqNf5MriLS3Aqp4wSjao?=
 =?us-ascii?Q?nFu2I6jdsPng3H6Uwn7afBocZi51kElZUV9aKjd9vDHcfvfsHBcnYIfelsVV?=
 =?us-ascii?Q?IwrFHcAw4nBBUlYqdA9ebsZoTSSw8VumFpxnZoPfpQNjD+m4xzOyTtsiLjgP?=
 =?us-ascii?Q?wGOHJgN9XkbMYb8yvQYBDB29MTiWim4i5YB6uXd+WH5Gixu24uZlEmwishuX?=
 =?us-ascii?Q?CR0kvh6pQFJ+df9VyWiRWYZ98u2Irxs+Xu0wmbgxCh2ZmEMAA1cHIC++NUgW?=
 =?us-ascii?Q?uSF4COeexldMnXVxOi8XV5Gof5sNyvsrjnmPqk7sUTFVFqSTIpMcvzdOa1tr?=
 =?us-ascii?Q?AaezEYIQRdg5xzyX0Xc5lAWFd0dwJbPohjFJbZQWtrGZVSfhCOVBdipITedK?=
 =?us-ascii?Q?8lxgTStht1ckGHtn2S+hg83sWP7QB5HO5VIuo//BWVCmkXu7zUpwokDhsfRq?=
 =?us-ascii?Q?aFGTyF9uzcPbbkShR7eyFliqe4QZMjnR3CG973QqDdMZNiT/gokZJVmNz/Ld?=
 =?us-ascii?Q?yIS1vS+h36P0zS9MhKheEJ/ozsOOHwzdVftSUO64keiS9OhCO1lYqhxyEI6p?=
 =?us-ascii?Q?rwZAH9FUflcxDTyXzFkBDNsRPnAqzCoQtT89EYPzNNjXzfL72bAk3lcCU98R?=
 =?us-ascii?Q?JpwiZSudtu+MyY7CjAMde28Arp5iIeYN5CWAzx0iyruVrh3G9QTogSGO9th+?=
 =?us-ascii?Q?j1uZwHTInSttObE78pFiFDzXHozxyUJpuMUVacLMXcSnMJ0r/56+jPzYC6KE?=
 =?us-ascii?Q?Q2ereSSpIJrwycGsafPi0raIacPGr9fgKXbMeTSyflKadaT6vXME6g/EYA/l?=
 =?us-ascii?Q?W0HR5cakIocQV3sjPuAk35x097/7wBZexjXJm9WAJnekHtnIV3SKNAbgW7HB?=
 =?us-ascii?Q?9h4JGOS++YHzpHHJpriJwjg5lTCmp4bBtSSMInPStmtKV6LwW/qtAErKk7S0?=
 =?us-ascii?Q?qNBJUEihSh0PsV3bf5A4roW/49tR9gfwBc9dvfQD/yrIaMr1PoBJNxYA10bB?=
 =?us-ascii?Q?mbbo3wVppiEnYxG6ny6XL4RASgh0u+6wKEsn/YhatJybcayO+s0yytfy5+R4?=
 =?us-ascii?Q?l4NtXx67q6j/eqjhGgp70YgESgIh294avuIeLkc1bHSgzzv7osDtd7X3EWf/?=
 =?us-ascii?Q?5QXQcxnR4ziMYr/EO3btWhF4GvgXFph6Fo+D2a3VdCnH7NItP+bbpmdPDSOo?=
 =?us-ascii?Q?Zjyx4gYvPpWnNAepgcmMgcbusIz95DIAL3NAPUgZYfQqLGuqMl4o85gc7Nd7?=
 =?us-ascii?Q?/YoPV4dGBAt2sTC6JprDfroj1YIE0n91RXkOuVEHcqLPxETp1vtG+sFzS6UQ?=
 =?us-ascii?Q?HJN3peBRQj9eu/yYRc91PZiqaPUGo4CiCfnssy1X/PlufghTv/zjKZjnoxJS?=
 =?us-ascii?Q?kuoDFCOQMIZVbIDxQADtzHcYC5ATpJTlVNsvEDUCTfQh8WZDZurVtaopB/Gy?=
 =?us-ascii?Q?jxjN/8xFkwjL9EbVAL+8UUIfbtVSzbxVi4Lglnnx9Ku8XZuVVpMmCNvmx5Hv?=
 =?us-ascii?Q?BlAZkQZFg4eRervgZKEhHNxGhbIwX28sV5ldN8U8fsbF7vN7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4381776-4736-49ea-686b-08de964c7089
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:26:58.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpI92fWLP4yOFPlW2d4UubR132CsBoAuugzZeVa12L6WldIHC1MkKT6fWMK4oZIM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A1CD40002
X-Stat-Signature: 1i79kza7dudoi1o443uazatai4tog5s3
X-Rspam-User: 
X-HE-Tag: 1775748428-54565
X-HE-Meta: U2FsdGVkX18I3s4LJaP50quA4i9tn9XaeGUnJQEqvoCjAB9j0lJ4tnjd7YCM5+jfkxlhhDpoR/OIU8v5cNklDths1KvV139UBEvHiO9VY+L8UFKMbqkqIL2wCUtcM6csDIc41eyjuXi50iHVaHwR9RiM9PgUAW6ILbJ2Ipx5sFvHipKJwu/8zfiRx+h/Mc7vwvHaeY8mEWgsCKYqP2A4HV4E5GMdZ/eTBnC5ZzfBnEm7weuv3KE3sJhuLfCV4m3phh18zRKp1ii8iwlmCCUuGctOQhHJd+rPy4S0tnhi2TePg74Dq3CLOFTmbgfhUH7O7AwlHcMYyMl/z+sEgJhL9Zzun6O8N4hNruWzAOSeDaCRT0ADK9u1nCA4Yi6nkiVwkRpOXjKFHzOos2g2Xss1MbPHm30stbZQVhTBmwmGk1jKennK6n6GCGaQtLo0vakFgcBYBknH+TmME4ZK6q153H+s1ViNl1w2ZQ/22bIp6+n8HCzQ02bc4ppH7nK5hGJsjbUf1/zquKgtW2fG8r9eUdvJklemZVgGrZK4pZPREh3b4NYyGYDD22jK0At8hcF8mjv/WK8MVPHR4J0gkYz+U8/fl12qxPKf8GBN51ozXn5/iCo1valESP2P1JlPHDyy3mnvjyQNnow4BHcddK7bKsXZYkdAQ0nOSirKVWqrANGTbxlQN6DHgzjqWEamemVb1vU9HBIJC0J3swDsB2w/E0XPf7G6EE75qxjNWsMDCJV5zOVk3WS7cZVmJl6ZIOi1EuyJLZZMm/c7p/FTTngTbUO+jYIr62qbyp3Goxm7HitoBvzFpjOCqDff/ECHFEQHOCyAFpaOtUZwLdFHZGBFByqpRwtYqAPDt/2iXmsaHAU2hQDOByDxTyx9k6SzJH6Vnn8tGVzG9vmjiis48Vrom3xzu6NmYsWt6wdwYVzwY35CsoRr4XjlG+zolrEt/LPDigbBgH4fEk+q59zg4k0
 rCANixDU
 ZdYtGbfW8L1u64bkDK8pir1NhweHsfMP35NOnfkc5EsXltXsmuHhyuIZt87AnQlWgNfuaVFT5H5nNAbKkdSMACY/0dQd+pm5VdEXrtCpH7yCOciz6Hu9Tl/3/tI1oT0UH/ceeI585zF967+4pGOwbposBMsEjIbUAnxgP0GvKvpNtAnMKuCjH+rS9l7oLIWY4an5wDCgGTveq73js2BIrDfB78COvusF7N/dM/WEZplNKEdAJun5nclHuxIhujGZ0AqCJT5TrD8EKw8cWofCJbGvHX0sfd3tjCRkhLMxlHD+hmsjg3Yqp5gWE8OtaMDEJp9jOvOnfyEd43ex7ZItqi6sZ2VqLyfhJJfe+s/+mu8BEvzrncpPMfPPnWXROB9n89n8gErXnjfDg1pWsigcuU4O/zVBR6JNpvbop2zYefinaJGzyQGvMFJ3L6i1DbKrBkxB0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> Shmem uses has_transparent_hugepage() in the following ways:
>
> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>   if the CPU supports PMD-sized pages
>
> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>   the code block calling has_transparent_hugepage(), the
>   has_transparent_hugepage() call is exclusively checking if the CPU
>   supports PMD-sized pages
>
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
> in all cases, shmem can determine mTHP size support at folio allocation
> time. Therefore, drop has_transparent_hugepage() usage while keeping the
> CONFIG_TRANSPARENT_HUGEPAGE checks.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/shmem.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
Makes sense to me.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


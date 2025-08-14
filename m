Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A0BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CD690019F; Thu, 14 Aug 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EBB900172; Thu, 14 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FA790019F; Thu, 14 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7516900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:47:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 861BEB8333
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:47:40 +0000 (UTC)
X-FDA: 83775793080.04.24EE68F
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E76040010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:47:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PeABPxhb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755186457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jgn7eU/VZvXcwPXX2b0pkEHAfwD86UlC78I2BnhOTuk=;
	b=GLZzoBFuJO+lGPfkguNi7zq7jYG8LSyDoyPles/i+pFWvG/kGCGLafuGT/6JhCvH0UyWTP
	K7xrUX1rOc5tl0lzTqEaV8UZIMnunpGQAhRrPgzSYTc8AW2wVkj1z6P5iFC9dnK8lbiYaG
	N+FndGgFCwFHq5dCRCZlI3h0mWPCVvc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PeABPxhb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755186457; a=rsa-sha256;
	cv=pass;
	b=VGumNyJcQVP91TFMHG2Rs0J0kt0dcNOeVWXS0WRSJNrc0FKhQf0Ua7YNrvvJICJ2C+KgXt
	vEXmYseEFH24/wih3V9G5tqNRnR+a2Bf0Ea1WJG+gTdK/KIdAIynfp/twG5U+m+4W1kyq6
	Kbsz+oTNiHZF570B0hueaUfn+yoG08Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xVrZlDc+GDhuo//2azGHSXqvmDYbNdArkn08lQUSRY5mex0gdruy2IyuhvwJo4Bb7yXngdeUHfH3p9ElhAN5+3O4od80RC026pyF4QiG1/m0kRWfDdOohUYZwafqX5gewRyOWTrRTPGOxk0wRjCoK106Z7CRsp0n5rUNRiCIQGgmvL6FU+3ozcZ4wauIreL+MmJZwC0ZPmlz62cQPdzirh23ZCM35MlFkeyD9ghttk5o/ExOCfbui5zsaBTXrJBV2lzjFBLBSVgrNMiqO/X8JQxOJfte4e5pdsR0Xo5nrKCjUOQ+zne+9DdYUKfIJKGAJwk3kr+pWVBt6s4CYfOK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jgn7eU/VZvXcwPXX2b0pkEHAfwD86UlC78I2BnhOTuk=;
 b=Fzvk1bN4kBUYLa07TxYdiWUXsAwUSm/dMst5cQKewW6h6zTH8Y56BDeI0KUzTtt5QKQpEaHS/BEA3Kkxn7PAkV2Bs89tv/enP6XgUpoAJSk1c5OGFZ6bAOTt4KXSRWnLH4T7fS/EdPch4sh5IRLdtRKL6JBNEmmOy3cEQ5ATiJd9fJKBHgBe2RSgCGSINroRRBK1Ttas3XV1YPHEIcI3npklLWztGS+J5j1DylzRwtLfp0hNvqMhkB96nlDWRnMk+o/UfxUX3+qJFivOIUgQK/G3dDdCfWGjd9bh34ew0k55BQi9h47wc3j9jHBs4swCmenMfZD87Ts7PdpYFIzZbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jgn7eU/VZvXcwPXX2b0pkEHAfwD86UlC78I2BnhOTuk=;
 b=PeABPxhbcSVSObWXzwLoPsYmVKQtWkQmsNk2CPr0vxitZKCDsmtREJ0HBxDTLSBiCO2A6oxbbLGZjaoVvX99cnQETKDcmASCvH4d5MK13CmsKTI1KfUZCZ9BTJpHD89gvnnVCOYOO+RMHcesCGMSabzl9wvfDDgJfiUqPmtrSQ+o77aTLATdZVBkoqSpbZ1pqD58c+0Llr7xNS5etpy8g7nArK2KvAjTkoRIMGWfm/+fINQC8jtewycA6JkgMD7SLuLX7XW2YBJQJ0mP3/7IXBF7hum24y6tdEBnlmwvDeBSx5gNsGO7WcN6vt8VCj3hkNuytpeCNxf13gwoa4/buQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.14; Thu, 14 Aug 2025 15:47:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 15:47:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 4/7] docs: transhuge: document process level THP
 controls
Date: Thu, 14 Aug 2025 11:47:29 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <608379FD-DCBA-414A-A0A1-58E0CAECBDEB@nvidia.com>
In-Reply-To: <20250813135642.1986480-5-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-5-usamaarif642@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ccdd8ec-6a57-43fc-5665-08dddb49e1c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5YQVpbi9xn3C/+DJKwSHuW7vV+d9G9VovFN1iTAyIz67e8H/wt7zZj+WSj2J?=
 =?us-ascii?Q?HqinddyzjHmxP7N1bUPKGn47jGCDISpEKaguw+jnJ30rRiPA6U7VLfmpaQDE?=
 =?us-ascii?Q?YTFJ0gHD1I0KpxgTB7YTIFHeqc9C/yx3gwIf1A+2T5dql3WR/KYz0Z1bg1AO?=
 =?us-ascii?Q?GItBqDEN1p8vXdVr18rD9EDcUAgWKhOZKTtPWNhg++e8asIoAn/dEKxns4KG?=
 =?us-ascii?Q?c/t5cVqm1FxXP2HPCNSSVPiyERGD2aHRpslDiLQs8UxWZHW9Q7B5POCyB9Nq?=
 =?us-ascii?Q?yq3lH2wkGdprQjL9NXH4bHbhj/1Z4hqP68vGjLDZNHaCbPZHeoKITF2pDCDa?=
 =?us-ascii?Q?eq11Gzow09LX7PU6mVqjFShgZFWcWGZIkEU8XwuHxuj0iOR1ld8lEH0on8lx?=
 =?us-ascii?Q?OrC4MrHbS5BZeghleQoUE8PbYFSDEsOXXukrZxM/Zib3ztUyhxrMQ63nPZCr?=
 =?us-ascii?Q?omoqPTdW8yneH+s/ZvYZuxL8UV6nPDfJkYGikskOMgK2OPiztgYZdhCW4ory?=
 =?us-ascii?Q?Gr75CK4ICRM0sbgeEx/HRSfhlNm6SBr6q1EdC3oo0+Ebl4TzcAuDbuolrpDb?=
 =?us-ascii?Q?PUTW3B8sDRS0g2Vd9A5Qt4XoEhHZBP916FdGaFF16HeWiOcNTRZKh5vm1fx1?=
 =?us-ascii?Q?b6YwblvUWC4NxIeruhGaZmEKRRE3z7Dzy2pqDCeHaEn3+KAH6ODPUsXi7gol?=
 =?us-ascii?Q?9nhmpqSKLqW0wuRbn4sbGmNfU3EziPJrWkGo1HWrUuhhNQN/UI7RG/Ig4Jbz?=
 =?us-ascii?Q?btzzj/6VkjYouaHme3SwckMbgbwTm2kagJ9MV9peLDWXHR6PCsu3YQq89q3S?=
 =?us-ascii?Q?98Val+qVX0kYI/JHSOSLRgvOCa5LOqh7d4z6wPG1/PHyJfPOLj5m81GDvD1r?=
 =?us-ascii?Q?Ej1YNJIa/r91jNmd0QzDtqjJH571dqI46PdO9ZNM/c975zZyR502F4D+iOlO?=
 =?us-ascii?Q?KDv64LORqLaUdtYr6vadT38Bi0xLigiobRjmhRtwE5PZA9yGREjLBGYPNZaq?=
 =?us-ascii?Q?Z9PqAMYpbo6VDQr4AqxfDpkrnmrQsZTQgdpKJ//5vmHJ+0HOz6GLixrc3l05?=
 =?us-ascii?Q?HnvOThUu6aHo8KBEyvCnWq7/l8ILZ3O++ALRHkcMSA2Rx5bP4REbQOUaIAP6?=
 =?us-ascii?Q?VSKGnewp3KiL6OQ4kBv9NHc9hqgiH3zEziX2VZbDggyCLhxR+IGwt6lmIFzJ?=
 =?us-ascii?Q?1aObOnsGvQ0QWIPpO2+D/NnujRdTZ6GpYTLiK1a1Y4d0k9AMVBoIcd4ImjX4?=
 =?us-ascii?Q?CCsmsemuTJIR4R/ORMU6LpNb5e82tXzofD9g7h6r9SGDIBvaz9HfaNhiOHbp?=
 =?us-ascii?Q?vTCqdfvnaCIImqfWWKIt80ZH/qFOgt0bsQsrsu+kNL7CwApjfdWBbxccjtHF?=
 =?us-ascii?Q?nLEGsPdQ23MfOt5XVWTzut++aOvaX2JqnZ5bhk3tJmFeVWz6FXg0ju62hgjX?=
 =?us-ascii?Q?NnLSVkRM+EM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HpFGUNjQEUNR7qIA36tyDJdfbeEHD3sT7SJwV7J0CkUAKouUbIvaxVp709F6?=
 =?us-ascii?Q?ZkEqU790ua3v/aRJ+7UjU4tlyGU9dkQY/gmbKicwmJJeBCxPsYSC7hR/l+vE?=
 =?us-ascii?Q?qeMuY/h3bDMSB0PsxVjUfJHWEXS4zxqsTXmT6NEVW2KLPA/fOVNDGnV1PCsJ?=
 =?us-ascii?Q?Zbccu75XSGoV/BVYGYXTW9XEQlRTiO29lep+vVA1cjc5WCUlZqlggiJaPeEG?=
 =?us-ascii?Q?i4vd+HskkTTHqGbGwwW+AUqxX4Rrvj5RyL834GBxo+QeZQmtH6/kbT07ctud?=
 =?us-ascii?Q?HiK8zcARIbPkd2MNm2oacM9AfBXZIxUg+flhPn4T7uf1Qvtm6+DKdORaPdwU?=
 =?us-ascii?Q?k2EZSOnTB0QIxuNLNoy9P7f56G5EpDhOKAfyV5d69ti5U8rMtqB/pOkpCflq?=
 =?us-ascii?Q?8RIejK5A/vzSsPkYywGsDQePMajGjcRAKRnhgN/0ljJ6pSyyFXU1y70Akn+Z?=
 =?us-ascii?Q?Rdz88EOqY4uECUt2oxvXk7Wq3xteQhYAgo2zWbRXBe1hYP2GhXPFZD5tI6bn?=
 =?us-ascii?Q?RB9B6rctO+VMf6VYJt2ckv/qUSRKD056dzgfyipcEP+0e1HMfPSSEegZSCCm?=
 =?us-ascii?Q?Hq3nbsrie1ZHYV7lO5scMHjZYx5/g4mpYVi1iuTG/MXX+pYIWzazouPPdkrx?=
 =?us-ascii?Q?b5VI4EhGKnSivJnVzohuum9E0BXSHIBEWnmFN1qH0y8uT/hRRbyqStgFqGeO?=
 =?us-ascii?Q?GjSr/L6LxP79zFgle+UbrvLf9lE+5atxDdG5coxfRnF20nrAvuyxJ36J4UUP?=
 =?us-ascii?Q?36wTAYmRIhuIeMoZRiTL8Sq7SfeBXgX7AG/cUD6rDfXlq8oyMwH5MOXRuuiR?=
 =?us-ascii?Q?ShocEqeDdbtN/PPP+T+Qz/hjU3bm4yIbanYjT0wRO5B4oMxTxgQbIE/bqXHH?=
 =?us-ascii?Q?hPq6Drdff0MYrHGgtfqtFi83XuIn5BdaYBIsGOKPbjOUbLrwPzCN/RzHL51T?=
 =?us-ascii?Q?fF/cRwOIQtftMX+YS9nQ+rU9+wek4MF39+QjtcBjV4UW5yZQ7tCb8W/rOLpB?=
 =?us-ascii?Q?AoNQqLE7a6SIKXnsgrEbx7j66mex55c+DCavJ2YfZg37rh9wDJOS7nJ3irEM?=
 =?us-ascii?Q?MHySMPOEPKo69JW5Jwj7vv/+6Lz7/QTLzs/R8vZMmbK9EmZaI3L95JBBmcWI?=
 =?us-ascii?Q?n3FNotjzVz/t0IdciNu/ofjvPiiLjzWjCRMKZ3t8Xdi1YjFgyAHtwInwpsDk?=
 =?us-ascii?Q?jKI9JB/dmg2d9KXxHm09W9CFIxxpppgMowPcXIZ4bJPyIURBbp7FZxpD7iYO?=
 =?us-ascii?Q?ZCN/xKV26TaEVxAD5M6Y7xAU1sUFjIezHP0SiNKAGO7DHT0NANzGWZJ4AEfl?=
 =?us-ascii?Q?88noXXzm9e1XH229YyINckrF1XG24EiX6TtDSxlnCZDpB71DDq6JgjkagdqV?=
 =?us-ascii?Q?SdJ4OyxtJYreSHKu0nkwztVAayUErOCzaxampXFqhdv4Qg+4fdUqi3Y2aCc9?=
 =?us-ascii?Q?CBsJo7efzrg3U8a/gYLgJWZYlwBQXd6TLv0O787UmJouUhA45Fyz+OKq+ICs?=
 =?us-ascii?Q?c3/p3GYippksowvKkDTbyVKJ3h8yawk0CiNCAYwWx3VFBXySD2bDkmv30bw3?=
 =?us-ascii?Q?FEN4OpG8ZR00GHHxMANJyeJgnhbBscozwV5CMdLC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccdd8ec-6a57-43fc-5665-08dddb49e1c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:47:32.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxXFoTdQ4gyc1UXGxSkVPlfHSGM9hoeMMjrkYAu+qiAmpT6eVJGeKC+tx2LfhDxS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E76040010
X-Stat-Signature: pjnzh3e71dsr31siedygkwksnkxjcg4x
X-Rspam-User: 
X-HE-Tag: 1755186457-177050
X-HE-Meta: U2FsdGVkX1+CIOG4h9hOOTu/F+OJpZzrL9aYlgmf51Tf9k4jiQxZ3+n6gzRRzBUme+HCb7V5PTmEKtTR5T6/SZ74SnePEtDCYmbVzJkv1sEm+LMmy/H391XSK17RKf2nF1spVmi2RWHljfS769wY+h+h62m5/9EuzIVgZsDmnfeIR21u9d37Gxc6bFqk68jFMWsO0b/MX8pty0FKT3ex7TtYysELcIxOEvP9WPmzxVAmcd9lBDBg8tIgT4SrRZB7TVqFvvJDeQ8bCgm2N6kpkgc1t0E7wf5FUVhbrFv1DYxVA4pw2eCXGXobIOYA1A5bSuuK/R3Z3f4V+qwceBNQQQ74lrt2GO58In0JIke44z6uYgMJ+MxXSUDxxgtfkIogw1hjs3VkZkw/0xL4q+XbabG0lQRbow7lkvsboxQy+sPP6vvb9LEbGFd64aqAGoE0IwuAAAmjE0/TdwIkhYNIc2nBzBORaIkNcAFZr6sPAUPJPdG5OCPQVSxLkbMK9vBCk4EqAuRg2TW5LCqKWNUC/QdF0AIKF09v1cFHn6lzFzDiC+dLV9j2A11tr0QpHT61Qbel8r+n5oZjzER9MAesvdQXSxCk+XtVfxg8D9O7loeyvU5ETOCldegPuFX+4FANSW4FUnLKnHoOgVhe7jB5Lnuey3YHEwUlfif7gdeLji91fTjdQnfDg/roOJaHyHK7zT6TuTZQT3lFlx9TzK+KSeb82mcUKLPBFb4rpS0gOoNf8Y4E0vG1NPt4SeSSZrQOCus3yZjqkVfg2f4h3lfMv4UM1WfzBdgUQSywQ2P5fNackq6p8TSODuFh8saCehp02tGKF1RvLDp8fhX4WqpZRRrBfZKPRFNSGMFylqlNGT0FhbUjkF84TWxgpBveLlwfKmsBPFdD/eVQm/ovY9tBJoRPX08Gj9J6aOXFzKbAMNsIaK9tZoveG3M990YWvzBwkbvRNCD9SPT1mIsMOs6
 ldWtdesn
 Km0nOutECio93gIXcszPYEWPXwdArLmxbKsKQk/X1IUmDRCkV+DZMX7SPjLS9HauvOJFXkhKr/kYE1OxIZ3bxsJq/pLxUOmdFmLmrcDZGjL39yxWxGou9X98ziNYIGJxjWW84UoxRhiXhthxYlgKSENVWnIvGVEhCioLv8zlsRnkCY3y6BTvRr8dJT2DOL+bolFCjikex4WmEQ89RPiGctktWVDHnlV2kNVanGlxCG2BPCJyLZET3QPxeL1krIt0Z+YnbCbqBnhhVeso23ngVTpY0g49pKoKs+uxoCIwVQXhlpMXKV5ZozfQ0plYDQvd9NiT1dK9rcG/GAcWJqwY5aaFDoIyEoGMPCQbjUTF43CAxedVxgaGzU560MEoQorXnlA2tYMseYWIb9a4HLeXql4z0Ja8pNuU5BPWV+8UjIjMQmfmA7jnaszndn+nfiUMDrC6QWwrhDpOWvlAeYJgp8SF4kJdlWZeNozvsYIudYg29gJaTY4DzV9wbY/cNPyHzrmv0bnZp842z8jn2rG9J3KTbedlfsq1GhZ6X2LC8WBi7iLe5kSWVT/oI3ZAU42MdaYqV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Aug 2025, at 9:55, Usama Arif wrote:

> This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
> prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
> flag for the PR_SET_THP_DISABLE prctl call.
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 37 ++++++++++++++++++++++=

>  1 file changed, 37 insertions(+)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation=
/admin-guide/mm/transhuge.rst
> index 370fba1134606..fa8242766e430 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -225,6 +225,43 @@ to "always" or "madvise"), and it'll be automatica=
lly shutdown when
>  PMD-sized THP is disabled (when both the per-size anon control and the=

>  top-level control are "never")
>
> +process THP controls
> +--------------------
> +
> +A process can control its own THP behaviour using the ``PR_SET_THP_DIS=
ABLE``
> +and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. The THP behaviour s=
et using
> +``PR_SET_THP_DISABLE`` is inherited across fork(2) and execve(2). Thes=
e calls
> +support the following arguments::
> +
> +	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
> +		This will disable THPs completely for the process, irrespective
> +		of global THP controls or MADV_COLLAPSE.
> +
> +	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
> +		This will disable THPs for the process except when the usage of THPs=
 is
> +		advised. Consequently, THPs will only be used when:
> +		- Global THP controls are set to "always" or "madvise" and

> +		  the area either has VM_HUGEPAGE set (e.g., due do MADV_HUGEPAGE) o=
r
> +		  MADV_COLLAPSE is used.

It is better to change the above sentence to:

madvise(..., MADV_HUGEPAGE) or madvise(..., MADV_COLLAPSE) is used.

Since this document is for sysadmin, who does not need to know the implem=
entation
details like VM_HUGEPAGE. And I do not see any kernel internal is mention=
ed
in the rest of the document.

> +		- Global THP controls are set to "never" and MADV_COLLAPSE is used. =
This
> +		  is the same behavior as if THPs would not be disabled on a process=

> +		  level.

> +		Note that MADV_COLLAPSE is currently always rejected if VM_NOHUGEPAG=
E is
> +		set on an area.

The same for the above sentence.

Something like:

Note that MADV_COLLAPSE is always rejected if madvise(..., MADV_NOHUGEPAG=
E) is
used.



> +
> +	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
> +		This will re-enabled THPs for the process, as if they would never ha=
ve

s/re-enabled/re-enable/

> +		been disabled. Whether THPs will actually be used depends on global =
THP
> +		controls.

and madvise() calls.

> +
> +	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
> +		This returns a value whose bit indicate how THP-disable is configure=
d:

s/bit/bits

> +		Bits
> +		 1 0  Value  Description
> +		|0|0|   0    No THP-disable behaviour specified.
> +		|0|1|   1    THP is entirely disabled for this process.
> +		|1|1|   3    THP-except-advised mode is set for this process.
> +
>  Khugepaged controls
>  -------------------
>
> -- =

> 2.47.3

Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


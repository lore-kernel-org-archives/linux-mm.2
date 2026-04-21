Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A59F8FA7E
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDC86B0088; Tue, 21 Apr 2026 10:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EA06B0089; Tue, 21 Apr 2026 10:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437286B008A; Tue, 21 Apr 2026 10:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF226B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:04:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85A195D5D2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:04:07 +0000 (UTC)
X-FDA: 84682732134.21.738C152
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8692DA000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:04:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TCQ+8djr;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1ikP49LDk0ZMZPgh+eZuRgRj4oOUMSDSwaG2kfCUWI=;
	b=WH4Bbl38T6ownYJFZVp1gpTwwA/OOD9p9ce3/PRO7VvEoJgB+i/2jmC+fT1QvuZU3l6E40
	4ARMyXYITDKBHBVbDSU5pdcckffFMerWFqnMFrz8p9YlywQE/UOgJkyuxXZcgDMyJIny13
	WvcBEfJJUNlDdpMKIYtGul4Vrf7FyRw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TCQ+8djr;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776780244; a=rsa-sha256;
	cv=pass;
	b=PblxvmQRQ2lxp6UjN3Rh//0EK5yOWNisEhGrWkcJZGGkhwJ4oW1kBgALRPISRtF/pY1lNc
	yMLyzoTA+v6GlnuOigyBhIC7nNruV0g0Ftwz/sRWEQLyMNxgyti22ZKAL+N+gLKGriEWmZ
	mbscC/2KKJKZwlPwsWv8c5h3zKEvKqs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l87vQ02F9ZORf3mPOjCYmXrRHx71w6ldYupdRF87kCWPQrZGLfRqzsbrnBa9TQF2ybxgN79tSS3/IP/+dnLX0CG7rJHSSB3ocXL/cVMnIgJnrsqegCkcFw5YFzAHM3Wp51p3Iq9QscyjxvGPhLUpN+ibWDEH9JDfttnkyS+ijukl+i9MLxMN44goLsD2hn++qmcfrXDj57BCu7sVqChuo+DESywq2O0l2JOymlKtOonuPO2UGpRdAxCL5siXXl9qG+eQfcRGr9B8+DqPCRg5JkflE/wQZpsrTFTh3ssimYJEJXVLkgW6AT/YGR6Ee2+X4WzNUZYYmbP7iBVMxoJ2Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1ikP49LDk0ZMZPgh+eZuRgRj4oOUMSDSwaG2kfCUWI=;
 b=E7TuC5zMUp8rzZS80jKll2aGH8E2CBEqzc60wzbHuDkAwxwTqQsJbpea07f7hn3I8XrdFLQe6AxQ8Ge0krNhVIM4z3VSCFNGhpbioU87Ni8eh7m3M8E9F0AkRI6pf0cqFZ1EyMvzI7AyiQHgvG3qBqqjJy2BGDxD+oeO18jSsUpoRCfoKnD4O+jy+EOp6V4e5fa2Xve+PsqJs8tLppkg6cBsdgtrwpguK+zC9OiYV2jqTauVIiZKV7EQwUPXZzr7hT+P8X9NCCSe2E9TD8QoJEYFE8G5uSezLnRIaA4QWXfTI1Tpo9/B6TkELWi3g9HzEanTueUfAUxDJo1wuS123w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1ikP49LDk0ZMZPgh+eZuRgRj4oOUMSDSwaG2kfCUWI=;
 b=TCQ+8djr1i0Im+Cp3w9/0AeY771pfqo1oAoVU5KhA5BMDl4O+y2jbbQ2AtaNJZiHB3hVjTP90Rrmof5O27iNNpAyBFfNJSPe3MinOzmHVvBn7wdi1WSAhYcdAfeh5bs3Ycemn3qPQCOxYoN/9Ts/1KExwG9IXx8GhQEiKytGGc0Cr6pGiG7QxHUF+FMQjoBMAdYuvgwu7Gjt2FRJ8uaIsiYUwusRx89coIBARnUEEZVa9DrZ3LzdVOzaoZFUbxrdttHDfXW3NPTu2kou4rIsCX162u15BZyiPnLZMb1vZcRnDtzc4KvJ+SEITyz8gKEwPgJOsHW4ZjWYHUGDZ0LA/A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6133.namprd12.prod.outlook.com (2603:10b6:8:ae::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.12; Tue, 21 Apr 2026 14:03:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 14:03:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Date: Tue, 21 Apr 2026 10:03:51 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <23A49388-EF68-4055-B620-54FD92FF2EC8@nvidia.com>
In-Reply-To: <a6182e60-9b81-43cd-aa25-09e54d20d13f@kernel.org>
References: <20260421042451.76918-1-hsalunke@amd.com>
 <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
 <a6182e60-9b81-43cd-aa25-09e54d20d13f@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0373.namprd03.prod.outlook.com
 (2603:10b6:408:f7::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: bd4e2e71-2059-408e-fd77-08de9faed334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PMxI1xVU+0c1fg1XspOmdEXhSz4XtREpNIBYuP8XK0x694W04TLLfvg4QgPci8hNzg9bScA6lP8nK6yAsIi3YMFbpzF0TGU0ZnhMoYr2aT6SJHYmf13tqhwonQ7WW0PTfn3GM9LuY4Z7XCIrHw+Jb/M9mp895+Cv5plDlaMfO4a2hrwijwfsf/ookcfYxQJkhBacgxPNJz1/Cm2IH2Uotd5jGuM3+YrGZvLtLfwssuM2clShI1dji9ucFWGiGCX8OVuBLeqUiD8QPiUR1msgFTSnljWJc+eb4xMZplOXuX7JZCnufoJj57syKCbq9zy0j0vDbv3vhp8JHlSHrND78lfM4CwyUDke+xnk6H9fTVWB7Umlj9T9ZyJDi/z3kbfotdh+bzFHK8pgG3qEBeZanJGqv+jLS5y3UD8l/2NaOsX/0tA6oV3PbJIcsNlwszquqfFU34RNVEgY72qN3p0IluSDMzs7MPrZUw6oPPo6J+Z/tkTtuzpNy/D5Mr7BNQiNrWp8fvjh5n3vnCNWyVDIYDgsVjTrcuO72cs42+TF+zNF9T0jJQknAqTGzpdlZDo7+npB7YpVnrD+rEkPWrMz7WFJImpUF77td21bY7P2DdR/7THPRforB+m7fM2hKhYKZM8ngKpZMje5YPWvMyV4QLKomOAzFJ6EDWltRIWZL2HOmCmjrDIO4fL6KX+vp2AT5y6ZhHF6x2SoLfyz71ysucXSGM1YeMafSn+DFupMJM8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EyzVW9G/956Kg0LSjYoU2g6JSDDeY1Dz+SsWAhQGExeJQLM+DKwVUurSrfqD?=
 =?us-ascii?Q?JxWbDpKBjFiPAS7he5JeU6gbEHXTHJcAIONZUq1EE9PMxZdJ8uIno0T0JN8H?=
 =?us-ascii?Q?u+Icq4oX19K5vBprZ8/CzKyqMHWjBMHeb31t6fy9fGSI+FhH3brl9jMeXYi1?=
 =?us-ascii?Q?4ly+OHwhvK53UEG19gmhKzsdVT0fU0ZLwk0yBRZTEQpB/NojhLk8eiwEdMVG?=
 =?us-ascii?Q?U2FzpcxieXiUILErwsX67MDcO/CN7oifgw1JHX+meB6oW37KF68n9ppYqdRj?=
 =?us-ascii?Q?XaOnZkL9lvdmiqmScAKcryLvndt3XMWL0J04fDSJewl//A2n+CU5HR7xi7jG?=
 =?us-ascii?Q?8HF5X4XV2IaGh0CbiNXfJCvudeXSTcvENGmC45cN4GBOqt8wjyAlfn0rfrKd?=
 =?us-ascii?Q?TOOK4EozqDOYEV4e5G9Ljc5Pn1zMOuQZcpPhZZd2FBm/kAbtDz7LYMIIsbBt?=
 =?us-ascii?Q?qpBrWEjHquEOqHyAqwn25+mRFSKl1ogO01cDJg2TERG090l1C1QlkSh8LBE+?=
 =?us-ascii?Q?KvOaW7HPq0owROwSuJXQUWZ+sIXOW6bcMmKF4MovypJ01Q7y8pTg4DDadUSS?=
 =?us-ascii?Q?HBHQ2pdsX8TNL57DrcTlsmolPLKdmdjV1HQOMsB/6Oov+pUwOwmBL/fwhE6I?=
 =?us-ascii?Q?J+OZNolLWTIvyXG3novjFjCxYOkZRltYeAN1ETvso+xrUCJ7fp5elbvPTFAL?=
 =?us-ascii?Q?fkgWBNAFtPFJ2LftDnI/oaTZ7eVRcUn9SqveXApsqLExEHQOw1G4kexjYWYT?=
 =?us-ascii?Q?b2eCKXl1KjjHyh0D0wFpUWs+HxE9YpUm9KV38iReSDU7DlUKbZkyLRz1vXQi?=
 =?us-ascii?Q?NkP7ZnQcqCYoQ4yi27mNqc89Csh6Tow+OuC6H6drA9SHpTWnuT3u3xGW/sfe?=
 =?us-ascii?Q?FtvynxnwI1D/yeC4fg45y9uU7tyl6BQEtHiCCBco+Qx6nwiGVgrdhCi9mOgf?=
 =?us-ascii?Q?CnNTcmGPgZ06T5KvULWJdH+AK8xsj+mtZM77/f9hMUyqVpMuvsQ9uBbuV3e+?=
 =?us-ascii?Q?wUT6VRB0BBiSDcKuFPMJJU87WZYJbM7C/WbnWo61blXxM6hNGQBH1OJQpfxq?=
 =?us-ascii?Q?IMDDBkS+7wdgV/6f8xBYSCuM0k+QGuqgHgxAlpfwtYJW2XW9nAyhM/NXFZAd?=
 =?us-ascii?Q?iK9AgAocSoGZwpsQJRcZaWF/nrWpmceWMWpqz5n03i6rNWKW1FO89h+OFId7?=
 =?us-ascii?Q?PSWNu9jsFIBSFXjA+CAXLeJKOwcBEUG0xYyV0n4/6cc6loy1tGJM5fvH+H8C?=
 =?us-ascii?Q?sN2McCtRkJgmsetgRi4rtfWJeTDhx+7cgfxMnuISivuLcYZIHs1PX1mkPcTQ?=
 =?us-ascii?Q?x6uhJ6II68xTAduwszvFm0oWdTT1L56E9nGGKSRnXEKtjnJqFCDyv/lo+PzR?=
 =?us-ascii?Q?Oi7SnIvJ56Lca1BHVjc7hw9W1XA8R/fsAK82k1pBYCq0D+i2bwSdbi2seCMr?=
 =?us-ascii?Q?lLlSKp+INjc3kpI9neCQWCIRaT0ECHSnnddtIYgCHFHECFksk3xPRirwnSEa?=
 =?us-ascii?Q?3GV1ZMTRrdyUk7XPNYbP4pWXbzkwX8TGFlz9oXVLX5PWM4CAvn+qlLV08YzL?=
 =?us-ascii?Q?CizATQ0qIFCBm48d5waGxKThJT3ePt4HsEniywdDcRvIHgUVZBWC+7ijkc/N?=
 =?us-ascii?Q?H/ZmmL5oWHOHNQVzpvuY65+YG7SMaTGLL1gSsGTnphb8mDjMalVwAQ5u5ADF?=
 =?us-ascii?Q?R4ZQY+nTXMlOQ/CF850ekORtkhofEN0u+k6XQNvfbeQodoAzcI1bm3b1luWd?=
 =?us-ascii?Q?Nw8AALt4+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4e2e71-2059-408e-fd77-08de9faed334
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 14:03:55.1391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwLLJDDaWBzpouze7+iWdSPk6M8m+v8m1XHzm6UhKGMwefLnIXVd7MfXIn7tOIsk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6133
X-Stat-Signature: rbb83yrc7ykr4etws6qx4kw3j9gc4s49
X-Rspamd-Queue-Id: 8692DA000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776780244-977796
X-HE-Meta: U2FsdGVkX187kJ4AM1R95KgQF2v2M+Y+AuSltZpVqW5E6YMfYSEk6fpayZmb6/pRg9Bs4oTCX0wHkx0iZvNzT/cp1/bK8WTb0NR7PDDbE3qtNVJ/eLnwG6ELkL4gzL75oVUyYKkn7vNbOFQkli5qVS//UTclsQ/2CKg+KXmlb1bBrR0SZScK0iWyvIqTP3lgAqVUA5+lIso2oVkg1hBWad8XeYC8JpLdT0aMFRAMfI9pLZPcbKDkcrWVrJfV72KX98NkbjmaymuPr6JgIfo8K4ee0EHd7bQ34/u8rQM+Z4ddZFbpwRjKAiN+YIqCF0JUdQA9iL0uZgrxw3yuh84dv2JDX4TY+hrGcahyiCkAXL5q1cIcUQLF9MB1kPWtbzz8qw7DmQUa7RtyG++EFkiJvv/naDQNrEpmAMQEk2Wj5P+vhED0AJMNDtpqVwtwtm6BM9aQB1FNXGFHHlZB4CxrEgNmfzPXCz4E+2fam8bK8fPcyVU45Zok5vflZGbTi+FYfXTp9GVv25cZ/rnMqA9MUgKBWRhuC7HPSUEzo6XdbKZYn3Fcmt8w9bgeeezXjfEAYwSM/z27DaJ9Qr6J2Ltks8jD3Ft+dioM8tzYea31QlnATX3oYXNvDQJceBREV5UEKAcG0yD/utv3ht+g+PN3TJFavVByk8HAnWgf6gY/nhRIQBBzUIOIW2uM7PK5l4FkT1yFefE/LXwpKxUqTIvjDk9AloTIX5tErSfeenJv9e8c/QdzQg+txoIiCMBPy2gUSF3mfv4R8iflCI8VpeOwfP6NvGb5AnxyS/eT/XYhpwU+U/4mudT4JVX7X3P+SnWjTZ5dfFlUScy4z5fYl8UXejWP5Cey3qjcZhxRJyHJpwfYH40nx3jgsBE4ojDy1F2Jp2u4HqdL06MhxcTkMJ/Kz0ilMKu46gPzepwOq9sdDIXjYEDYoUM+X0u8KZwIVzV4cbgqGVYbxd7iaSdiPSA
 SdIKFMN2
 rjijc6hXOWq7p8dETlJ4aStvhZvUhwBdtBf+qu6dpE6r8/AlWGIdZNW73AW7lr6DidYq/0OUaRSF59calvnZFDqYz1oDJpTjC3eGhRdIrHGOC5tooAWR8jKsV/B0gap4TCQMnHJbtTGlvMacJDlQnRDXtnvc5Rbne4D/tKLYheACJmf3qO90W9vBIK1Oa2t8NmZlgWCmaIkBOmSty32NMLXwjFIObpfB30GC8j9chv1SNBweeijXdkU9EoIoZSi+BcZ6SR6NyBkQxZ19vtc8cjfHq/x19Damj0LVgoCX3t9EynnTeEgxRYbbG0BEWpOSiYtCgl4YR4o2ENMHrf4Ls4SsN33wMDa5K/1009PT8yi1PuJNcfl1M4G1AJBoNEE1JY1liShv12z5s1xG+ITy/I+wbt+HS7wUSseHpG3flk07IoQ+NpC2qsFIxdhJyngpuCKD+yw27ix2PeZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Apr 2026, at 9:57, David Hildenbrand (Arm) wrote:

> On 4/21/26 15:44, Zi Yan wrote:
>> On 21 Apr 2026, at 0:24, Hrushikesh Salunke wrote:
>>
>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>> one at a time via clear_highpage_kasan_tagged(), which incurs per-pag=
e
>>> kmap_local_page()/kunmap_local() overhead and prevents the architectu=
re
>>> clearing primitive from operating on contiguous ranges.
>>>
>>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>>> clearing helper that calls clear_pages() for the full contiguous rang=
e
>>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowin=
g
>>> a single invocation of the arch clearing primitive across the entire
>>> allocation. The HIGHMEM path falls back to per-page clearing since
>>> those pages require kmap.
>>>
>>> Use it in kernel_init_pages() to replace the per-page loop.
>>>
>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=3D1:
>>>
>>>   Before: 0.445s
>>>   After:  0.166s  (-62.7%, 2.68x faster)
>>>
>>> Kernel time (sys) reduction per workload with init_on_alloc=3D1:
>>>
>>>   Workload            Before       After       Change
>>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>>
>>> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
>>> ---
>>> base commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
>>>
>>> v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.=
com/
>>>
>>> Changes since v1:
>>> - Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
>>>   kernel_init_pages() runs inside the page allocator and can be
>>>   called from atomic context, making cond_resched() unsafe. The
>>>   original code never had a cond_resched() here, and the
>>>   performance gain comes from batching, not rescheduling.
>>>
>>> - Moved the !HIGHMEM/HIGHMEM branching into a new
>>>   clear_highpages_kasan_tagged() helper in highmem.h, per David's
>>>   suggestion.
>>>
>>>  include/linux/highmem.h | 12 ++++++++++++
>>>  mm/page_alloc.c         |  5 +----
>>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>>> index af03db851a1d..ad0f42d06ce6 100644
>>> --- a/include/linux/highmem.h
>>> +++ b/include/linux/highmem.h
>>> @@ -345,6 +345,18 @@ static inline void clear_highpage_kasan_tagged(s=
truct page *page)
>>>  	kunmap_local(kaddr);
>>>  }
>>>
>>> +static inline void clear_highpages_kasan_tagged(struct page *page, i=
nt numpages)
>>> +{
>>> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);
>>
>> kasan_reset_tag() here removes the tag from page address, so that
>> clear_pages() can use the right kaddr. I thought each page needs
>> a kasan_reset_tag(). No need to respond here, as I am reading
>> the code and trying to understand how it works.
>
> It's all confusing. But we really just turn the pointer into an untagge=
d
> pointer here, once.

Yes, I realized that after reading kasan_reset_tag() implementation.

>
> So I think this is ok.
>
> I do wonder, though, whether we want to move the
> kasan_disable_current/kasan_enable_current into the
> clear_highpages_kasan_tagged().

This sounds reasonable to me. And also replace kernel_init_pages()
with clear_highpages_kasan_tagged(), since kernel_init_pages()
will be a wrapper then.

Best Regards,
Yan, Zi


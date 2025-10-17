Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22184CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B298E0047; Fri, 17 Oct 2025 13:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813948E001F; Fri, 17 Oct 2025 13:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7029F8E0047; Fri, 17 Oct 2025 13:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E48B8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:24:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA5CE1192CF
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:24:46 +0000 (UTC)
X-FDA: 84008280972.15.972CD49
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011003.outbound.protection.outlook.com [40.107.208.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDADEA000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:24:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZizsTron;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760721884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07+Bp0aFVjiCS7qOBK2OgV4GEc+6+W/NyT3hmmTN6Vc=;
	b=Mao0K81ViPfbpLFUXqqK5N5GCtRzJ2aysYa99dX6pEVGs2NSPtCCQiIfp1RX5Nf2y9ynv6
	GLMLF+gMPYjigJ/70xFIJBK6DqbjjVO7nmrwzOICdisfzbQ4N4P8KB/OwPoPk9IW/Snanz
	BVVXdWC51UihBGgbI7+R2m8GbEUcwaM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760721884; a=rsa-sha256;
	cv=pass;
	b=5e5EUcCiP4RACcv4q9Z+2Fc4r3B7Hha9NjOOy78IHoPtHte2JA9fbp9i5xN6wpZmZl1HXB
	X8Z25fth1eTISkc+UN3up8svHjOWu86o9Ui3RDeTiQfuxaG9WZk7OT6tt89IMEpkuguTW9
	P8iilAgV1mxunxVwAH1is2h82V5Fj+I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZizsTron;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yXUl8Ac/eOY7fu+BbvfysCX9gS886dS2BxZ35FvFI9HPva0Li/+uLl5UQwdq8V05Z+rAG58Ql8jKoP8Cc+f5D20NzQhlExW2VYxJ6iH3GzuUFzOJorT2yLkKGDUtPolklsWDARCS0xtxFEreFQ4dT6O/QXDeiIqG/dxzBjIiupmfeHhsUjwIR4p6Jzjr5P8PSEG+cM/md/eBW6d+C4n69GaFZo+5TT9RGxXN3J9ZepRf7xjdyqtnHp6aCUETyTPKci4+f+Gw1+e896gEO2vzpYPNaOi3CsB8jWBeO6aVGqoeOe0ZclZuem5II7frt0hwJNsGGWgk5sa8wwOie1gfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07+Bp0aFVjiCS7qOBK2OgV4GEc+6+W/NyT3hmmTN6Vc=;
 b=rHM1n8iD7xuH0oQRjUW2QQZ2G821YKInUj/u8vScabDNVM5nFmjYs3xzZTEoGXsDAp3dmJYkZw24HrrAZY380mhO37MmQ6HxNdznYvF3LWfhnZpdtf8vtNWCVp+C4JqilVSzCNUqmV8ha+Swm0LE1MgYAn1JTqkk6JWBX/uxDqJn7NbFWqU3maGOeY1S53dLHbqrkt30J0mvcfOaAPuTCPTVZq5qMApglfEbobj6v3Vi7GwOhyw+fAX+CIdodEclpojLxHdFvpu7feaNT0MBuXr/HWyv6E9JK4XmsuXajedQR42zyBsOnNkKKLMYmwi4OMVzfZgkib7+V+IKWOTQiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07+Bp0aFVjiCS7qOBK2OgV4GEc+6+W/NyT3hmmTN6Vc=;
 b=ZizsTronnRuho4IFvHzbEBGgCUWctRAYUeCYYBgojSyjSVR2xQ2t+4dv15D3REhyH2dJRDJaybVjERLzC/WR2zmcOmAdNxmYXIOSoYni2oFNNuGGJ6ZU+0AeR7Y9AMMvMULvA3/TKqM/c70fOjPChosXXSJObJD+ZOCRY2u7o0hQnRxTwXIDzoxYcJON87W+k8OGpgsPEFHdmUGVre3iNulNnH7DqG/4AaiL2wdY1BqnFAXHrG4PSXbRdrWgGtOO093gfcmwmNjOSYMsCnvjsZ9hky/DxIOnj7gRXBQMr5wFdDPaZdMuLCY/NuAhdeP29EE1Pi/0Ia4vWjgSIUPo0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6976.namprd12.prod.outlook.com (2603:10b6:303:20a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 17 Oct
 2025 17:24:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 17 Oct 2025
 17:24:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
 Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Fri, 17 Oct 2025 13:24:37 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
In-Reply-To: <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6976:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca3c153-50cb-4b2e-7308-08de0da20d31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qQs3jQ+Vhx3MBHU+Q9Ktg2CQJfI4lFrartx+hssSvvO0fYxIdGq1TnYUZieS?=
 =?us-ascii?Q?LgUKRSlcqVLXgFKYfqIdOHSm3IhmoHBCVhKrJryo4GYbNAcQcH451O/B/loq?=
 =?us-ascii?Q?a3ALuvhXCPsZ24CAIDB+a0OVoXzBYgsDs1/yvZp+XJt99TqSZwXNK85W833k?=
 =?us-ascii?Q?bejzRpiWLvReNu22QlQxe+yVpVF3yBCU5sZi1atCVtqgPsYKjTlF14Ruufqz?=
 =?us-ascii?Q?fur2SkLk73CZ9fv33gjh1Zf9XSjWKmBpRhsAzgUKQ8Xuu6g3D5CzyyK2qo15?=
 =?us-ascii?Q?dRr/ZsfBdAUU2cJM19KgeeTLe20pPpRuOVQ8lKigiEWVC3ANeaqTGJeuP9lF?=
 =?us-ascii?Q?Da8TpxD3ymRu6D/+FZzsGUCtWkacsfJdu5AVe83ujVZ7cv+fIuCNZ1gLFtoA?=
 =?us-ascii?Q?0KjGb+371TlsYmEugkD084oh4CYqyO6sWtVMl/vndgi2SvgHzQDzMBtqh8Ju?=
 =?us-ascii?Q?WwYTwl/NBqd6uI0B2gOdpAEAUfnZ06GLFqJ5EDq2ABRWJA+gM0MKWUGtoDTJ?=
 =?us-ascii?Q?uUB88uS9e9+b3W3c5EMpolegNE2JtuK39aaF+2izS/dW9nN+KThIJHdD0net?=
 =?us-ascii?Q?vJPZ+xiWZsVZWitycMT2sudkuiABnlJzkmzDSHgONM+tmAqhOTfgAPAzI1Z+?=
 =?us-ascii?Q?BI6t/sAYB9oQPMTwPdnuDtqY8NL4f/PaWbFWoCM3vY2ssVAjLwiRhy1l2CvK?=
 =?us-ascii?Q?IqstEh2fxIWUbdyLk+TqwAUMVcYNtpf5c6cmbJydiF4s0dQmHfzEs/72nsVl?=
 =?us-ascii?Q?JCZNP7xvaR1XqXCpwR9QCN9YoavVexpbZUpuuK/znI75bBlmSJ1FZXLmcTXU?=
 =?us-ascii?Q?RBmh5r880UvkOtYezo9fOCgUHXsoXBOlboNEz5F5bNzOMiLEBvOFA3QE7zJS?=
 =?us-ascii?Q?ZR/OJT7LfJZb00cpAWsuL637cIUkLav7VZhzMNO6fS2n7MdF+ZBuJ0T1kXUF?=
 =?us-ascii?Q?CpUl/ZcFK3mZ6R1Lmh02gHjZALRn2Ro7mH8UMoVjQiMMouapGGdtMXHE3dx7?=
 =?us-ascii?Q?/mTFO38pRBsamZXBFooPAbMNOjbSodlAEDydg0AEYkvKKip5qTnTW0OeKNpz?=
 =?us-ascii?Q?Yue/e70rCcHmx3uB0+Imw3JX501DlA00i+DmRF2XuPRaHZc2M+5xIKHG/20C?=
 =?us-ascii?Q?U7047y/Hw+zi+Ju5or7coWEmkYdmbbUutNjuuUATuS1li2cCsdSnLLgOnCFV?=
 =?us-ascii?Q?nn1LjS15QD4qWlnFzURRci2yILVr4YFnRJGUE7EaXxLZJ2f7FgUZFy4jZBvY?=
 =?us-ascii?Q?kV92YfooTpjLU8e2LUJPkVGLDjkUr9kvRFL6dKqpKSkDtKsLVwC514yUs9NO?=
 =?us-ascii?Q?Z9Ig9iPRephsiel492gI4TnLg7gXoP0nfrwBwU0bIjcDDkp0OM86+tB8Vwnn?=
 =?us-ascii?Q?wYVjz8KVIqVCrU0nNA4fkvTZrHaFxCFJB7/TByi7GEy9rG9Qt3OcFTVEVI2E?=
 =?us-ascii?Q?NaQgEjNlHIWyPe6JEdiQ4updXd5HFDuBTSsr/jNh58wsB2FHpEh+Tw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8TgMfY/XaPAXTAMRMZF4HaxQSpioVKKIsH4l31lIyl8iUwea70qjJNMMBY1i?=
 =?us-ascii?Q?teeaAxmwSBkWw3QOYVXPS/2SojEsbH5LyAtZGSk6HaL8TUeZopmlUjZGA8nx?=
 =?us-ascii?Q?psrlEZ1rLprxB8eA6hA1oiia99R7FLcEqauFMYStwQlvdNKey4cDQcvDiLyQ?=
 =?us-ascii?Q?HJe4psIya/tBrGI0yymHS4iZuWvsbe0jA6q22nG4026kPdbbNWDya4OIgARB?=
 =?us-ascii?Q?SrGy3dxeq6DDWcjqBEP004hOJlvhikkNsWanA75NwTI+vUGY3M+bDuCYN0Dt?=
 =?us-ascii?Q?bF/gb7DSfDFuEXVe8pjjiKA9qNdv9cvQzhCdZXBaGXHJ7MAvQeOhROBKY3fI?=
 =?us-ascii?Q?8oDkQENPfQ6y6e6MmFc5mgUHxrugued7VJgIIKmEYU5grMl8+ORxMf6jknQd?=
 =?us-ascii?Q?F2/TcjApWtLffaS0mBkV8+HwB1Dxb0hhLNj6cImxHi5FGd2FsU78cPwjQj+C?=
 =?us-ascii?Q?o5fg/VWum67wwvef6M4SuZmjQvEcgX7xB5jUlNTkfIYzp+YzjWGDt7CQ+Hwg?=
 =?us-ascii?Q?o9snOo5udbwfKr7+WdVudIXzL6JN9vHeif1Y5TMVe80ljwWGim/vqXPxwLDo?=
 =?us-ascii?Q?4hrdS0bSJ8F2EkaqpS18Tzw2aJVYaSZypHCYK62v4LlCMqEWsqOMWxrhHcDP?=
 =?us-ascii?Q?r+95sm219SOG7HyDI4S2A/OiYJ6HBINsxFHkqXmZurg0tGbXQuEWebcnbV+R?=
 =?us-ascii?Q?R52zilqkEiU22vPbydmW1h+ROk9lDgvJSCY0L0EOitRgexMo2vb3dJmiVvUh?=
 =?us-ascii?Q?TbJ6PLS1IDuO+52lWLA3pNrVegQ11r3VL/iRpe8jM+ireWZNGOyctsQrL4Fa?=
 =?us-ascii?Q?zjRnYphuTzdc3fCMWCBF3TUON1f4/vRcweEGAfc7d6n8JVD6k6ows2DtLfdM?=
 =?us-ascii?Q?Wi4rWbvFCYiE1r5Tq/TVXvs3FBqfvcZcfJFjokMTmkezPxQLUZqcewoE1WqC?=
 =?us-ascii?Q?xbvsIem7ndnGyPGJ8LmZMCJcWugi3S6+F1HW/CtgmO6xVPz8WQhhe2P1jcn5?=
 =?us-ascii?Q?clnyggsnWxmwMlUYN/HjshHAxCXC1P/XXS6isVfQymbmEaXWpHIgjd6H/4fV?=
 =?us-ascii?Q?nSYkgXWK6ARTAi1oobaa80ech0IOFaRWYEhU259uXcRU8Nan/cXW532GkDRy?=
 =?us-ascii?Q?nVMbWTCtI/L+Fxw/4OYrakTVMN5Io/de0thm3R7NyVPQ72jG8+BNwDQ4BvCN?=
 =?us-ascii?Q?eoAUJB2Lnh+AXn+Rbq54qVOxODtI1Arc4B4KODu41v2GctJXUCGO6sDYR9eZ?=
 =?us-ascii?Q?4hgOmoJtgF2doTq5Iwx1Ify2n9QMTks3NHM0K7D4tfnKWz4adyVZg8wNt3Po?=
 =?us-ascii?Q?mHnAkXmZt5uLsdQ+n6IzsAB9OSZtUunlfybHKe7ZoGI4KEBkJRlUofL2a2Bh?=
 =?us-ascii?Q?wHDX30Uy2t6C7KU2CzDbI3fIm4LlTs3BoNLe/vA8zE+zFN7MG32it4lZky2Q?=
 =?us-ascii?Q?HA/SoHhPc9Rzx7elXJWFYGJ38qPeuHy1AaCskSECk9bozSUM8XflxIw4Q5vu?=
 =?us-ascii?Q?l/d4BwTDZgiXUZhlltGJrslc67ioCnHqQ+zff8QcFNmj3CG2Tre7GRc2DbxG?=
 =?us-ascii?Q?ds158maPCeXfLpSp413dMjG2lRNomOJILsWbYH05?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca3c153-50cb-4b2e-7308-08de0da20d31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 17:24:39.2024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBmnl/cnaSsUXIbbn9sSQFHsOVtlGmEgU1Q+MQPV/YLbPAI0UVMpJOBIXOsV3mM8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6976
X-Rspamd-Server: rspam05
X-Stat-Signature: 3h7nydpppbb8ipa65ee5wmc588ja7s5j
X-Rspam-User: 
X-Rspamd-Queue-Id: EDADEA000D
X-HE-Tag: 1760721883-683838
X-HE-Meta: U2FsdGVkX18ZARxYlU+C1Wm8BjiIjuA3eRwMvN6R73iseqbdJjKzYysKH5j2+TecF6IcQMQA5fIbMqL0T3RHJZqu8WCRPYf0IjDTb19svAFaebKgRLBbNRO0Y2YZfhbBQCsnAj3BnFoa0rS9w6zuLZMetD6pzYEEm9CJa7NddmYu7VG+3MX273jUdeFIb6TamCHEkF1i+eE3tunEy4WSMdfu1jqfvpwRhwgEIxsQMK1vnJq1tLT9QrFBekU40NvQmzxz3HD2fR6QQy/zY3ihVmJKeIq7cvQcpk33eELmia7VvNbRR+vb1zh7mTjOnc+iCqajXkFoddkZJD7tmZAQ4JzQGKQm30JJ/2P6KNn34l4L48tgRpQ6rOdWFnsbTQ3YyXA7uceWbgGJzGi3d9FJXfYI+ffkSVXX0ehLUklvMxrMUZ2uTt81wPH5bkbBSSxBYWXcPWFJ1SCn95ohUTIRDOySofpwYxmk3RVIE+15jPP3JxP0Qn2QKkoYi52XKi/AaBf0H89fGWxp2yxnygPJ7juRdDY717r4S2XERGWbey+1HW7ZzRf5/0PogriuSnYfJ2jlpPquemlL3hUZ3r1pZFC5r4V7sizjYr6JOYxWv7+EsiClqlAXdCZ8ZFFOv2zeR+K5DMXD9d5kQF1efd6HzRbKFvbGKO4B0mDIjdXBQuemTT/5GsRuQ0v3YD/5chDNp89ATWBRj1XMA735Yj7xFs8AGiNJ0B47piMfOovvLK5zVAPwn6tzI3GWhP6BuPhBGXxxqzXOA7S0IDFgQYdXUifer9DF0HNUpVttnK7jnFhp9KEP4w9WsIOf00p9KQvHiki2MsrsoMoQFwVEwD7hA0Rx7lJL6+0HBFphf+5ZaKFVij/dzfN36JsifzfC7Cm2q4sYZq3Jze2rRiszerBDIIAwxAtpXDPirOoEx7705OVLkAA8mTHcPIZd13zk65E8C1Ma8UGJDonzfPF7fY/
 N+LI5vOf
 OCB6WbUfjSY4Tl2rMeiDaJQAHjxM5zl/lr92QidzRlZpiilaX6NvmqcQUQlEMy7TRPYsXFnVkACgISEFuSqoSDhzZ5w+nzbGS3mdprm25spd4bJVc5ol3/7iOct4Yc5ooy2nEuGmVIzTJWXBQLVgPloQAgHJXP0YAhcwTf5wET9naQXmV2eywmrXkzCtZ0ohUq5BZZx6y6Py8AouTJYlsbCL835PVqVLt6OixsKPjuYZVgXebQMgYZb8ViwhDKrZQdb4zXLl7Mwu1eXu4Pkygmm+WlGZmwOdkImz8CU3lm4G+Wj7pmmIuqATOaPFNzKREBnLbYobVQnGb/GyWXICvzMVTMpSN2B9exdU4BJWg7GFEFyx6QP2yRKrb3K7BJgkjcUj9X7UKs1SPnJ2yBC5gXsuyNy9cARlp5DdPSZGrOusPPUAv3g+vEHTVYPtYrBtFDNdBcQBjW5nhXOAoj6aSvhGMJAEorOqgLsC7VHR9Tm4mk59/Z64/W+u7Wt14btmaHbDIAoZpB7/UV9bsdLiHGo+rf2GVrKOOtN1SjIyYhDCnjg4DEF1qMdUaiYOw0APpIvAGNTIWRj9zOhh7Yx2FaI+hng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Oct 2025, at 10:55, Lorenzo Stoakes wrote:

> On Fri, Oct 17, 2025 at 04:45:17PM +0200, David Hildenbrand wrote:
>> On 17.10.25 16:26, Zi Yan wrote:
>>> On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
>>>
>>>> On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>>>>> Existing __split_unmapped_folio() code splits the given folio and u=
pdate
>>>>> stats, but it is complicated to understand.
>>>>>
>>>>> After simplification, __split_unmapped_folio() directly calculate a=
nd
>>>>> update the folio statistics upon a successful split:
>>>>>
>>>>> * All resulting folios are @split_order.
>>>>>
>>>>> * The number of new folios are calculated directly from @old_order
>>>>>    and @split_order.
>>>>>
>>>>> * The folio for the next split is identified as the one containing
>>>>>    @split_at.
>>>>>
>>>>> * An xas_try_split() error is returned directly without worrying
>>>>>    about stats updates.
>>>>
>>>> You seem to be doing two things at once, a big refactoring where you=
 move stuff
>>>> about AND changing functionality.
>>>
>>> No function change is done in this patchset. The wording might be
>>> confusing here, it should be read like:
>>>
>>> After simplification, __split_unmapped_folio() directly calculate and=

>>> update the folio statistics upon a successful split, so An xas_try_sp=
lit()
>>> error is returned directly without worrying about stats updates.
>>>
>>> David suggested a change[1] to make it clear:
>>> Stats fixup is no longer needed for an xas_try_split() error,
>>> since we now update the stats only after a successful split.
>>>
>>>
>>> [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789=
f1b4@redhat.com/
>>>
>>>>
>>>> Can we split this out please? It makes review so much harder.
>>>
>>> I asked Wei to use a single patch for this change, since the original=

>>> code was complicated due to the initial implementation. After my
>>> recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
>>> can be simplified like Wei did here.
>>
>> I think it was too much split, agreed.
>>
>> This patch was a bit hard for me to review, not sure if there would ha=
ve
>> been a better way to split some stuff out more logically.
>>
>> Most changes just complicated way.
>>
>> Not sure if splitting out the stats update change or the calculation o=
f the
>> number of folios could have been easily done.
>
> I mean as I said to Wei/Zi, my objection is both moving code around and=

> making complicated changes that require you to really dig in to figure =
them
> out _at the same time_.
>
> It's perfectly feasible to send separate patches for non-functional
> changes, I've done that myself, each building on the next to make it cl=
ear
> what's going on.
>
> I'm a little surprised at the oppositon to that...
>
> But if you're convinced there's no other way this could be done (bit
> surprising as you're asking 'why this change' several times here) I gue=
ss
> I'll sit down and try to decode it.

Let me explain the changes in details below, so that we might find a
good way of splitting it up for an easy review:

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4b2d5a7e5c8e..68e851f5fcb2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio *=
folio, int new_order,
>  		struct address_space *mapping, bool uniform_split)
>  {
>  	bool is_anon =3D folio_test_anon(folio);
> -	int order =3D folio_order(folio);
> -	int start_order =3D uniform_split ? new_order : order - 1;
> -	bool stop_split =3D false;
> -	struct folio *next;
> +	int old_order =3D folio_order(folio);
> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>  	int split_order;
> -	int ret =3D 0;

These remove unused variables and do a order->old_order rename.

> -
> -	if (is_anon)
> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);

In the original __split_unmapped_folio() implementation, I probably
moved the stats in split_huge_page_to_list_to_order() (now __folio_split(=
))[1]
in to __split_unmapped_folio() and needed to handle xas_try_split() failu=
res,
so left mod_mthp_stat(order, ..., -1) here. It should have been put
together with mod_mthp_stat(new_order, ..., 1 << (order - new_order).

[1] https://elixir.bootlin.com/linux/v6.13/source/mm/huge_memory.c#L3622

>
>  	folio_clear_has_hwpoisoned(folio);
>
> @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>  	 * folio is split to new_order directly.
>  	 */
>  	for (split_order =3D start_order;
> -	     split_order >=3D new_order && !stop_split;
> +	     split_order >=3D new_order;

stop_split was used to handle xas_try_split() failure, since the stats se=
paration
I had in the initial code, I needed to add the -1 stats back. Now with We=
i's
change, subtracting old folio and increment new folios are done together,=

stop_split is no longer needed.

>  	     split_order--) {
> -		struct folio *end_folio =3D folio_next(folio);
> -		int old_order =3D folio_order(folio);
> -		struct folio *new_folio;
> +		int nr_new_folios =3D 1UL << (old_order - split_order);

stats for counting new after-split folios.

>
>  		/* order-1 anonymous folio is not supported */
>  		if (is_anon && split_order =3D=3D 1)
>  			continue;
> -		if (uniform_split && split_order !=3D new_order)
> -			continue;

split_order is always new_order when uniform_split is true, so it is usel=
ess
code.

>
>  		if (mapping) {
>  			/*
> @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>  			else {
>  				xas_set_order(xas, folio->index, split_order);
>  				xas_try_split(xas, folio, old_order);
> -				if (xas_error(xas)) {
> -					ret =3D xas_error(xas);
> -					stop_split =3D true;
> -				}
> +				if (xas_error(xas))
> +					return xas_error(xas);

xas_error() was not returned immediately because the -1 for old folio nee=
ded
to be fixed later. Now since the stats is not changed upfront, it can sim=
ply
return.


>  			}
>  		}
>
> -		if (!stop_split) {
> -			folio_split_memcg_refs(folio, old_order, split_order);
> -			split_page_owner(&folio->page, old_order, split_order);
> -			pgalloc_tag_split(folio, old_order, split_order);
> +		folio_split_memcg_refs(folio, old_order, split_order);
> +		split_page_owner(&folio->page, old_order, split_order);
> +		pgalloc_tag_split(folio, old_order, split_order);
> +		__split_folio_to_order(folio, old_order, split_order);
>
> -			__split_folio_to_order(folio, old_order, split_order);

No more stop_split, so all these are unconditional.

> +		if (is_anon) {
> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>  		}

Update the stats when the actual split is done, much better than
the original one, which assumes the split would happen and recovers
when it does not.

>
>  		/*
> -		 * Iterate through after-split folios and update folio stats.
> -		 * But in buddy allocator like split, the folio
> -		 * containing the specified page is skipped until its order
> -		 * is new_order, since the folio will be worked on in next
> -		 * iteration.
> +		 * For uniform split, we have finished the job.
> +		 * For non-uniform split, we assign folio to the one the one
> +		 * containing @split_at and assign @old_order to @split_order.
>  		 */
> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D ne=
xt) {
> -			next =3D folio_next(new_folio);
> -			/*
> -			 * for buddy allocator like split, new_folio containing
> -			 * @split_at page could be split again, thus do not
> -			 * change stats yet. Wait until new_folio's order is
> -			 * @new_order or stop_split is set to true by the above
> -			 * xas_split() failure.
> -			 */
> -			if (new_folio =3D=3D page_folio(split_at)) {
> -				folio =3D new_folio;
> -				if (split_order !=3D new_order && !stop_split)
> -					continue;
> -			}
> -			if (is_anon)
> -				mod_mthp_stat(folio_order(new_folio),
> -					      MTHP_STAT_NR_ANON, 1);
> -		}

This loop was needed to update after-split folios in the xarray and unfre=
eze
folios, but since last refactor, neither is here. And the stats update ca=
n
be done in one shot instead of the originally one by one method. So
this hunk can be removed completely.

> +		folio =3D page_folio(split_at);
> +		old_order =3D split_order;

These two are for non-uniform split, where the code moves to split next
folio after it splits the current one into half. And the old_order needs
to be updated, since the folio has been split.

For uniform split, the for loop is done once, these two effectively does
nothing, since the for loop ends.

>  	}
>
> -	return ret;
> +	return 0;

xas_try_split() failure is handled above, code should always succeed at t=
his
point.

>  }
>
>  bool non_uniform_split_supported(struct folio *folio, unsigned int new=
_order,

--
Best Regards,
Yan, Zi


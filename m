Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05A0C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C69A8E0005; Mon,  4 Aug 2025 14:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E828E0001; Mon,  4 Aug 2025 14:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4878E0005; Mon,  4 Aug 2025 14:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9EE8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:13:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFF18136198
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:13:40 +0000 (UTC)
X-FDA: 83739873000.09.9766A68
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CB1A1C0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:13:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=trMvIUpa;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754331218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ud/kbxQu63kFD2lh37t0DgezwU3fClOgScWxG5bK8qg=;
	b=XC2BNHbZFNuijB/u5W6EJ+E3L8KVLL+Y4v4IuIlRYYq4DZKNu/ozEmqhheByyKlx6tMyeR
	jdSDUnG0W4KWoKMNArNLh7WQAFZBJGZSPwWcJhjvzQRZbjr6mExbKhLrjUAysQWDqZ1Zws
	9XYQ8W9pztMaL+BE0Rnbb4Mfk43ed5c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754331218; a=rsa-sha256;
	cv=pass;
	b=ee0BlTPspzO16fYA82IJvCW5ZsA1R9fMb+yc06EWXLwv3WxXCszbz5b6V+Jh71KjRT+/GB
	Cbl/RhUHIYJakCEFPJ9zj2fYY3D7ElzUCQtPMfvbVRxZ3/76cn4WiB7Jioc5F8djet1CpN
	Qr0q3BNUYK6cJI4ONeu2woNjXov3XUI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=trMvIUpa;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4byJof3TQx87SErdhgXWv/rf4jmHIpjgj0WKSnELfx82PfUUuWQKuAEqdxJXohxU8Gm70yq72ZhlNurPo3aSComxwwDUTlZhoU/iabwcHEQD1zVcvzCrDT5/8WIvm2cghkELNTKi9V1MtiRw3XuH0u/5uwQzWghUHQDU3O1dwRsehfsvGnO4VTQUjFt3G6B0Q8yniI9TNRST8o1aVxnJdZ4kChH2oiU0GoSSYP6PwU+31CCyfW+epzJ66W9gA5+HgEVFdC0XleYWC48jJm0iLTuR6cI5w2PV8Uw5cchUAR0/EQmQaCqaO1sV7OYKNs0Mmu9XRN7V6jB+Kh9kF0A3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud/kbxQu63kFD2lh37t0DgezwU3fClOgScWxG5bK8qg=;
 b=NZlFY66iMvqqTS1pbtWWcfG/C1Zcq/cAD/idh4KMPYU69Pregs+kvvo0DF2BICd3cjnK4yNpzpJal7ibcup0DEzu+4MYc+DNVKAQGKsxEinj/p7nS+BR/P21noOTT3V6rJ3ZIWpDXPSpEmPWEmCZYF+6wzO052kBgGEHhTrIUdm2CZ/ZhFe3e0EfmQUW7TkbbK+uxUP67VmNXOYtDA0PbxPCKdD31f76zmTOYtNryCAkMPyRkMEVpAERB7xva9l9TvNUeqWOYo0zaKlSkG31wKJRCeb7FPXVsTIjXcT6dn2/edB6ymcIF98qKC1LChfx1NR5z/4n/7b7S/pj6ld4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud/kbxQu63kFD2lh37t0DgezwU3fClOgScWxG5bK8qg=;
 b=trMvIUpavGURMwDiaFL5/on/dmCYNKPG8rsYGc1/nJZNg82w/xkuEBk/sYEet9ZgZQO4bwQ0xbcRVvYb7nTUMbRs1T0tcIex7yDdJ8Xpl0tjTU/qRxP+DawwI/DelEaoURAzP/XyjVAfKr21Rr8Ui+tzMEhB9gYGKywN+C3JtL1spZHm8mVnXw4pgfOe3Co8spGqey0MvmQMPRY0zVQnNtrPLCEjM2JqEmqAXt5taOUBzQ7BYzw+RYiJKnnz/V65M5QJqv442NDAb8mV3g0opYepTEvUY6gk07Z52OLNdCAwrvtDPDYZMeEYuRBlPfeRwPL5o0tZvpNRGP4fZxSbYw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.18; Mon, 4 Aug 2025 18:13:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 18:13:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 4/5] mm: add largest_zero_folio() routine
Date: Mon, 04 Aug 2025 14:13:30 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <43DE2D3C-9FE8-4F42-BF82-4DE47E2F9344@nvidia.com>
In-Reply-To: <20250804121356.572917-5-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-5-kernel@pankajraghav.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 40342841-f95f-4e0e-62a3-08ddd3829fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WYZo6cX0LI9IqvkOp3CuuoE0vk65ZgdHlW3QWgOtfYjN/B9mPbt5/Dc7rLSr?=
 =?us-ascii?Q?+diCkIfEPKvdLG8EyRj4Nodmsezlo8tbkFhewvc/sUGV7B30X3TJCqKs3bQf?=
 =?us-ascii?Q?AUGyZtmif4wYIbU1/hV4lFnYs56n1a/yIRYP+MZNP3IQbYDKnyXbzMs/OZ7K?=
 =?us-ascii?Q?2F2kJR2vJ35kJ0KHPLCFllu7P8zzrUyH6D9JgyoiqQ9Cj/wjZ77pB86LOItu?=
 =?us-ascii?Q?zO5mcjy42xTW8IkOGBKNkpAMaDZugtyPHjv7L00A8iMCSTSwmM5hxjFqft2b?=
 =?us-ascii?Q?a51FrymvYRQJn7rFFqZaWzB70kLI4JcZrVPPWZ28YdO+gtOz9cHzoSXekoZJ?=
 =?us-ascii?Q?qfMOqeZBBvVjoJx46CyjxZDohTXp15DySyIM3nKLvcLuprq1h6DmB0OJj6qX?=
 =?us-ascii?Q?2g3HySb2O6FFWUt82Vm1CGgKL+q5ZOiPFhfYRPdpjk/l9q3OVy55/N/9TL8f?=
 =?us-ascii?Q?+YMUh6on+NHwSr5qAa+JgnVwudBPtERpTbJxmhb1P9RMpTVSoAzyDCmV9gru?=
 =?us-ascii?Q?gVkJblsxeopKc5nwSqFq0DzRDhQA7Q649plLV9uUSTKr6ertL33qBOk07ZxS?=
 =?us-ascii?Q?mKpxyENcrJMKxlaEEMpX913VWVfHnsQWrJKJY7BHYTHZeT/XDMSOPh3Pduo9?=
 =?us-ascii?Q?4Dpseyky/m4jTvD6ttlTmqgHNU5S0wYo0BV7SgpnjrXeWhrsrUs6z0D2zauk?=
 =?us-ascii?Q?X7GtP+QJZAn3LFcIQpJk4bNFd5Ao9Qymu+Hn2XUGYze7Qsy+vzn0P3+XXxL4?=
 =?us-ascii?Q?M5P4rrtaAWnLSOguVptqdC8srZLvsuDbQtiMPSfySpaM7Pgj5Cj3wAlC3WeC?=
 =?us-ascii?Q?6g9232l6nu+UyGrWoO+NukTWcEpXbmxIf2TzTYwDpTM3qU2LtCKlDSramOqZ?=
 =?us-ascii?Q?k/QO8qAxhD7aQWiHejeyYMXVfwnseOqyrzbyVLMaDeuO5P3B3QHG0oj71FED?=
 =?us-ascii?Q?bOzktsjbHR1iyBynNcoXqRhn06NQTKEnbzzFeq1Zd0LSvf6LKk4BF1FNiLwD?=
 =?us-ascii?Q?R7Qa8z9q0fLiO3fHClVVXRIYJzifmmETb2AOXh3Vyys4FDAP1WU3BsUtyEws?=
 =?us-ascii?Q?vflXLjSiEQUoYjfhogTp9T6m60c/+kkSMe70cUArMGiCafUb4ppxrhGpJYTi?=
 =?us-ascii?Q?NVPKzToInBc8x0Q+ZaqIsuFXxBmISKhhaEf3rAl0OUOWOMHT02k9V5AITkDb?=
 =?us-ascii?Q?8u5LN1GtPUnwIQsfNcWhIc7GEoE2camil1EK4ESq6rqOYB4//suLiKAZUOBW?=
 =?us-ascii?Q?GGj4OiG12Yo3WPrskIJIoD5ZPyxrbW9pzle0rTDllyWLkKDLxQSJe01+rLpu?=
 =?us-ascii?Q?xTqAsZ6/yPMeRxZVM1Biv/FPgUzZlguL3pvQ/SFLRVrtYDZXrmLYMrIuZY5+?=
 =?us-ascii?Q?qNeNPnN3sf76Uv7c47FHPAJNpujVaU/mV4Dx3D3XeU1TIX3IPHyy1FNzP8/A?=
 =?us-ascii?Q?UsVvhTbCrxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f7nFdq7Bu37QXAyH8I6TY0ppdxT/dAtmyB+i0ZojnNVCIfEyH8qHacse41j8?=
 =?us-ascii?Q?ztTaZd0HYsS153L68QRicbsrOw2BJ2cHh95MuA3US3GSLyVGNOSXGLFHThLB?=
 =?us-ascii?Q?hEg50M+azjtOpqt7SNallrakF8sPny7grLoSZudfpGlTVnZPDKxEWLdssA9T?=
 =?us-ascii?Q?OGH6Bmg79r2no95QtanLRU0RPp2XKO0gHvBmR430PO2KvuvZosKkmhSe7GlF?=
 =?us-ascii?Q?hKwUWHal4XSW3/7esHo4KaDXv5eee0ZaxgyKduTIHzWgqHkV1RK0v8vDOcJr?=
 =?us-ascii?Q?6JEuaxhsJu6xy8Jvf4vKfTeXLQejxBy3g3FI1Q8LecAR+eEVqzCJbcNj7Nw3?=
 =?us-ascii?Q?FWU1uPGF5IPNgX3Yh3vcbAXSUlPiXsjCd4bizLHWYhSbaBhRNqluWPGdEA2T?=
 =?us-ascii?Q?u2DVdyM/nz1LkoacCJ+hYJCEbf++4aeti92s1mc4K0i68ek2KWJgSeI3QnV0?=
 =?us-ascii?Q?qSbQrj95uVBD1q0LrzcVUQksmJsNomcZ+4Z2XHE5yLS0VQUEU1Z1TWy2zetX?=
 =?us-ascii?Q?wnHj9EdHTEE8VgVJT2PvCrwngCefJpKyaZkSzgp92f2AqVGk/+8BpFVA0Gwd?=
 =?us-ascii?Q?axIKqPrGbdieC9PtDU3+rFoxV/WqQrmcfnj4zisoI5i4k+lyKQSXsA4KjiU0?=
 =?us-ascii?Q?nuhwg2aAyy2l8LqGz8AfXs2PnCjNk43UrWz61rsnRjTYpmnnEHzmUyl30Fwb?=
 =?us-ascii?Q?dRRZ+NsLfei9J8A969CG+Lyhn434Rj7rinm1U35OLWT7Hn82BXvh2aJFN3/l?=
 =?us-ascii?Q?yQXATLxeCoD1z2k1H+u9/AMMAeyCy5M2XP+nr1PsZy1LGVGQyG2G7TZl4Riu?=
 =?us-ascii?Q?a9qwChdcAORjMn9w5doPsn499shSof11VpF6ghis9wv1sQdW+dvgpofiVWu4?=
 =?us-ascii?Q?vrVjHvlE0hf2MMWe+DkKzZD64ln5s20P4nofVHNSHnekaJDUwXfYi7sXrt62?=
 =?us-ascii?Q?SC1uqMQUPqNouFVmwdkX7dDBw3TC51Cyfsl6ROnNsKjfGaYY6fllQHt/RElZ?=
 =?us-ascii?Q?YwR4rahsBz7nLYClcPFTgx8wEgJcLn3zDTQQNkDoJFT/mkN5kPOEcQkpdXtM?=
 =?us-ascii?Q?7jQ5zhRAB42Qw3XhhyXZ5LQfKNQ6BNIN9Jy9Er/Zoh61VNg7+WC8Q1wupdJ5?=
 =?us-ascii?Q?5K+2vbnbla4oFbCGBKaIPg4lvdYvGMIPWusiQ7XB77DOUlyKyDkt6KBJyf8h?=
 =?us-ascii?Q?V7awNnj7Qrt+FmR1+ySs6at1Uq6EOGfUerY71ojxNNoyY1Km02Hw9SOm1Cyt?=
 =?us-ascii?Q?5NNUAFxTupbbvoZ4nXlEt/kAbR1e06fUlMRmDWFoWFtbflLatE7KJLCIIgBz?=
 =?us-ascii?Q?6TB0i/zUxxq+cmL/ihWSmQasZGtce3AITFV3fwU6yymCatzRk4/3IdJ3GPRg?=
 =?us-ascii?Q?ycQctYb4ACvh575d2lvAhsVWwd4iukyZQm6b6nrqJDuGktRPcAAbjj3ifrMP?=
 =?us-ascii?Q?lTsY1yAWb3bYFWGxi6mIlazvkuF0asE91ALUR8q7tiqqP4v4M/wc0u0rRxx7?=
 =?us-ascii?Q?47n7hbpx/KfEw1/0cHUKvko1FG2SpsTDWqme3itKvTnwYp8XakEqWeck1B12?=
 =?us-ascii?Q?DXuHD5BJnBBTstysuSlReFdDIAhrpak6JVZSSkPV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40342841-f95f-4e0e-62a3-08ddd3829fdd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 18:13:33.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gI1Kt23Y+kzY0iqv9b2p7LC0S+KYdWsY8fN1eR9fhhtHpXTJfaiDkIlui8sG7PkW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CB1A1C0003
X-Stat-Signature: bpcwdztijpatqz6cpmpx7apfiemfuhuj
X-Rspam-User: 
X-HE-Tag: 1754331217-695293
X-HE-Meta: U2FsdGVkX18C9HwR+1uFpk6EIqVNsHqVpH6AaFlrIR081CHZ6Do4KyH2c8MTHbIsASDw8IUGwSIaLPgf73nIn3Dq64TGGQqMYK+RIsNSDlpqkH9gXURaiPEbQAQOYPC06Ov5MY2yXlfDqdyeizxjmxmnPFSj1zTWtIKg1Dc3AVJOxNN6cIA/Pvf3JCG2IqX0kGmIim3RYpBPcM+eddzssd530wLi3K0RekOfe3RIZxL9mk7OgZZf2qObsoZPH+Ce7do76bC9atuTzdANndUdZ6MeiWVslMefsWRI72UOwKrGscoYUi1uOJT5xQYY1Hcfck2K7m0EbUoCO3ZM3mZCDar82dvX3Vj1Iai46r62dZ9QcsSVvMBrmtpfb+daiuxetmCHRUW89c+lnrAdP7hW7XX8soqUWCyjkew0pbang7sAenVSvHw7Q7XwyoPaepT94UQh6g5wSLc019ATLolXadgOCoylhScjXaUB+bNTn03P7LqVzZwKpHPdqqtmzftyTHa8DCWnONu8KeEguJNFCXMj5pTI5q7Oqp3iX+qgXkXfJNOktmjZRhj1JBoGfXQf28LEM4EvS5wjI0abDpAyLc61eYyYkWP1ECqk+nKu4QwTh88YXV/Nw5U+f21wCiQ9TfeK+9GrNwptnSEOgb0R3HtowcF3c7xcWjGW8lhw8ALOJh06BTnDZwDw2JqYYnRDTbvEJVH+6I1BK2KWsL4fRq0kDKuHwgSBVr7uvOutpFgbzJGRo7Pro7ZW3TmTtPQjxMYKEt0oAixc3OeFX4OSLrGgL1SNnP1HnxUUrqhbfCwgA/nhFBubSPT3FtgrxNXo4akej8XtQHF5l5iImsZIVd5/skR7xo8pHKUnWa8x1KTOpLryNAeOpsc6ij7tU3SbeHk/RVr8XkSbeL4xqhEze1oRWPoAAvE92ZXt9N2B8xaZplSECiq2cZkZ83ep90ohAzXwv3ujONa+Z2snmIC
 uTCzlI7M
 8WH04rwbdtzTu8TtqXw87MCKg7aXWBBy/YmB1uplpXmBqFmB3n/Iny0Z1OpMPULsoOQB56UsG7rb7E1VZUV0PT788DWhTt1B9tEycZ+OlPPo5rkN9i1ANr3agEyzIDGEbYDo0BAFqJVcv1dHV0Va/2xGYHe9X1UsBT9F5r2vr2cnKMA/JV7LzB15KMQudZwo0AQmqmVCvMZyPUIn/Ql9QgB1BoKn4iB73h/vS5WapshLKGL86BwUA2osM4Wi9KDduTxjPBshDBdpWpd3Oygv96DLBmVXa6AGUhF18Br7FbNKwkSlYrrxHHS6EAdGbiEjDDClSDlH6d/y9k22ozQPOv0eTa975r+kBeRpbgWmtfzOP7pH9ktO52Bs36VjZdtBQFJHP1HBBdbtUyg2rv+HEBl/hxKaRE9ckjI3zlR63AlkU2supuaL6bUzo1IS0zqo1I0YAuCofy+U5ZkbyxO0pfqvnftVvpaaGW+kfkq2Z+GShcrxNK6JU7Dkwm9WVy7z9PfzB+gIrF2CXlXRljVusRG9p+vZj45pWDKimgqBtLxXV5RXU3j6vI4rWWKH905CcFMYasjJ46JQyBAG1HHCLl8zllanCWc58VoUs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Aug 2025, at 8:13, Pankaj Raghav (Samsung) wrote:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> Add largest_zero_folio() routine so that huge_zero_folio can be
> used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
> return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
> if we failed to allocate a huge_zero_folio.
>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  include/linux/huge_mm.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

